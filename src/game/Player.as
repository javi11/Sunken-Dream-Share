package game {
	import citrus.physics.box2d.Box2DUtils;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.ICitrusArt;

	import game.ui.LifeBar;
	import game.weapons.Cannon;
	import game.levels.Rope;

	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;

	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Sensor;

	import game.ui.MessageBox;

	public class Player extends Hero {
		private var weapon : Weapon;
		public var isHanging : Boolean = false;
		public var currentRope : String;
		public var isShooting : Boolean = false;
		public var isAttacking: Boolean = false;
		public var isSwimming : Boolean = false;
		public var onSwimmingPlatform : Boolean = false;
		public var isTalking : Boolean = false;
		private var _message : MessageBox;
		public var  heroCanClimbLadders : Boolean = false;
		public var isClimbing : Boolean = false;
		public var climbVelocity : Number = 3;
		public var jumpVelocity : Number = 10;
		public var velocityY : Number = jumpVelocity;
		public var ladder : Sensor;
		protected var _onLadder : Boolean = false;
		protected var _climbing : Boolean = false;
		public var markForDamage : Boolean = false;
		public var isDead : Boolean = false;
		private var autoAnimation : Boolean = true;
		private var idleCount : int = 0;
		private var idleCountMax : int = 0;
		private var lifeBar : LifeBar;

		public function Player(name : String, params : Object = null) {
			super(name, params);

			var ce : CitrusEngine = CitrusEngine.getInstance();

			var kb : Keyboard = ce.input.keyboard;
			// CTRL
			kb.addKeyAction("Shoot", Keyboard.CTRL);

			canDuck = true;
			
			this.onJump.add(handleHeroJump);
			this.onTakeDamage.add(handleHeroTakeDamage);
			this.onAnimationChange.add(handleHeroAnimationChange);
		}

		public function iniPlayer() : void {
			weapon = Weapon.getInstance();
			lifeBar = LifeBar.getInstance();
		}

		override public function update(timeDelta : Number) : void {
			var velocity : b2Vec2 = _body.GetLinearVelocity();
			if (controlsEnabled) {
				var moveKeyPressed : Boolean = false;

				_ducking = Boolean(_ce.input.isDoing("duck", inputChannel) && canDuck);

				if (!isSwimming && !isHanging && !isClimbing && !isShooting && !isAttacking) {
					velocityY = jumpVelocity;
					canDuck = true;
					heroCanClimbLadders = true;

					if (_ce.input.isDoing("right", inputChannel) && !_ducking) {
						velocity.Add(getSlopeBasedMoveAngle());
						moveKeyPressed = true;
					} else if (_ce.input.isDoing("left", inputChannel) && !_ducking) {
						velocity.Subtract(getSlopeBasedMoveAngle());
						moveKeyPressed = true;
					}
					if (_ce.input.isDoing("duck", inputChannel) && _ducking) {
						_fixture.SetFriction(0.5);
					} else if (_ce.input.hasDone("duck", inputChannel)) {
						_fixture.SetFriction(_friction);
					}

					if (_onGround && _ce.input.justDid("jump", inputChannel) && !_ducking) {
						_onGround = false;
						velocity.y = -jumpHeight;
						onJump.dispatch();
					}
					if (_ce.input.isDoing("jump", inputChannel) && !_onGround && velocity.y < 0) {
						velocity.y -= jumpAcceleration;
					}
					if (_ce.input.justDid("Shoot")) {
						weapon.shoot();
						if(weapon.distance == "large" && weapon.getBullets() > 0) {
							isShooting = true;
							
						} else if(weapon.distance == "short")
							isAttacking = true;
					}
					if (_playerMovingHero || _ce.input.justDid("jump", inputChannel) || _ce.input.justDid("Shoot")) {
						if (_message) {
							_ce.state.remove(_message);
							_message.destroy();
							super.updateAnimation();
							isTalking = false;
						}
					}
				} else if (isSwimming && !isShooting) {
					_onGround = true;
					canDuck = false;
					heroCanClimbLadders = false;
					velocityY = jumpVelocity;
					if (_ce.input.isDoing("right", inputChannel)) {
						this.body.ApplyImpulse(new b2Vec2(0.8, 0), this.body.GetLocalCenter());
						moveKeyPressed = true;
					} else if (_ce.input.isDoing("left", inputChannel)) {
						this.body.ApplyImpulse(new b2Vec2(-0.8, 0), this.body.GetLocalCenter());
						moveKeyPressed = true;
					}
					if (_ce.input.isDoing("down", inputChannel)) {
						this.body.ApplyImpulse(new b2Vec2(0, 0.5), this.body.GetLocalCenter());
						moveKeyPressed = true;
					}

					if (_ce.input.justDid("jump", inputChannel)) {
						if (this.y < -350) {
							_onGround = false;
							velocity.y = -jumpHeight;
						} else this.body.ApplyImpulse(new b2Vec2(0, -4), this.body.GetLocalCenter());
						moveKeyPressed = true;
					}
				} else if (isHanging && !isShooting) {
					canDuck = false;

					if (_ce.input.isDoing("right", inputChannel)) {
						velocity.Add(new b2Vec2(0.2, 0));
						moveKeyPressed = true;
					} else if (_ce.input.isDoing("left", inputChannel)) {
						velocity.Subtract(new b2Vec2(0.2, 0));
						moveKeyPressed = true;
					}
					if (_ce.input.justDid("jump", inputChannel)) {
						(_ce.state.getObjectByName(currentRope) as Rope).stopClimbing();
						(_ce.state.getObjectByName(currentRope) as Rope).removeJoint();
					}
					if (_ce.input.hasDone("up", inputChannel)) {
						(_ce.state.getObjectByName(currentRope) as Rope).stopClimbing();
					} else if (_ce.input.hasDone("down", inputChannel)) {
						(_ce.state.getObjectByName(currentRope) as Rope).stopClimbing();
					}
					if (_ce.input.justDid("up", inputChannel)) {
						(_ce.state.getObjectByName(currentRope) as Rope).startClimbing(true);
					} else if (_ce.input.justDid("down", inputChannel)) {
						(_ce.state.getObjectByName(currentRope) as Rope).startClimbing(false);
					}
				} else if (isClimbing && heroCanClimbLadders && !isShooting) {
					canDuck = false;
					_onLadder = (isClimbing);

					if (_ce.input.isDoing("up", inputChannel) && isClimbing && !_ce.input.justDid("up", inputChannel)) {
						_onLadder = _climbing = true;

						velocity.y = -climbVelocity;
						velocity.x = 0;
						moveKeyPressed = true;
						if (_onLadder && !_onGround) {
							if (x < ladder.x)
								x++;
							if (x > ladder.x)
								x--;
						}
						velocityY = climbVelocity;
					} else if (_ce.input.isDoing("down", inputChannel) && isClimbing && !_ce.input.justDid("down", inputChannel)) {
						_onLadder = _climbing = true;

						velocity.y = climbVelocity;
						velocity.x = 0;
						moveKeyPressed = true;
						if (_onLadder && !_onGround) {
							if (x < ladder.x)
								x++;
							if (x > ladder.x)
								x--;
						}
						velocityY = climbVelocity;
					} else if (_climbing && !_onGround) {
						// Si esta escalando y va cayendo cae lentamente.
						velocity.y = -_friction;
					}

					// Eliminar velocidad si paras de escalar
					if ((_ce.input.justDid("up", inputChannel) || _ce.input.justDid("down", inputChannel)) && isClimbing) {
						velocity.y = 0;
					}

					if (isClimbing && _ce.input.justDid("jump", inputChannel)) {
						_climbing = false;
						velocity.y = -jumpHeight;
						
							onJump.dispatch();
					} else if (_ce.input.isDoing("right", inputChannel)) {
						_climbing = false;
						velocity.Add(getSlopeBasedMoveAngle());
						moveKeyPressed = true;
						if (!_onGround)
							onJump.dispatch();
							
					} else if (_ce.input.isDoing("left", inputChannel)) {
						_climbing = false;
						velocity.Subtract(getSlopeBasedMoveAngle());
						moveKeyPressed = true;
						if (!_onGround)
							onJump.dispatch();
					}
				}

				if (_springOffEnemy != -1) {
					if (_ce.input.isDoing("jump", inputChannel))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}

				if (moveKeyPressed && !_playerMovingHero) {
					_playerMovingHero = true;
					_fixture.SetFriction(0);
				} else if (!moveKeyPressed && _playerMovingHero) {
					_playerMovingHero = false;
					_fixture.SetFriction(_friction);
				}
				// Cap velocities
				if (velocity.x > (maxVelocity))
					velocity.x = maxVelocity;
				else if (velocity.x < (-maxVelocity))
					velocity.x = -maxVelocity;

				if (velocity.y > (velocityY))
					velocity.y = velocityY;
				else if (velocity.y < (-velocityY))
					velocity.y = -velocityY;
			}
			if (autoAnimation) updateAnimation();
		}

		public function playAnimation() : void {
			this.autoAnimation = false;
		}

		override public function handleArtReady(citrusArt : ICitrusArt) : void {
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence) {
				view = citrusArt["content"] as AnimationSequence;
				(view as AnimationSequence).onAnimationComplete.add(handleAnimationComplete);
			}
		}

		public function handleAnimationComplete(animationName : String) : void {
			if (animationName == "hit") {
				isAttacking = false;
			} else if(animationName == "cocoAttack") {
				
				isShooting = false;
			}
		}

		public function setHeroCanClimbLadders(_heroClimbs : Boolean) : void {
			heroCanClimbLadders = _heroClimbs;
		}

		override protected function updateAnimation() : void {
			var prevAnimation : String = _animation;

			var walkingSpeed : Number = getWalkingSpeed();
			if(isShooting) {
				_animation = "cocoAttack";
			}else if(isAttacking) {
				_animation = "hit";
			}else if (_hurt) {
				_animation = "hurt";
			} else if (_ducking && !isHanging) {
				_animation = "duck";
			} else if (isHanging) {
				_animation = "climbIdle";
			} else if (isSwimming) {
				if (walkingSpeed < -1) {
					_inverted = true;
					_animation = "swim";
				} else if (walkingSpeed > 1) {
					_inverted = false;
					_animation = "swim";
				} else
					_animation = "swim";
			} else if (isTalking) {
				_animation = "talk";
			} else if (isClimbing && (_ce.input.isDoing("down", inputChannel) || _ce.input.isDoing("up", inputChannel))) {
				_animation = "climbUp";
			} else if (isClimbing && _climbing && !onGround ) {
				_animation = "climbIdle";
			} else if (!_onGround && !_ducking && !isHanging) {
				_animation = "jump";
				if (walkingSpeed < -acceleration)
					_inverted = true;
				else if (walkingSpeed > acceleration)
					_inverted = false;
			} else {
				if (walkingSpeed < -acceleration) {
       				_inverted = true;
					_animation = "walk";
				} else if (walkingSpeed > acceleration) {
					_inverted = false;
					_animation = "walk";
				} else {
					if (idleCountMax > 0) {
						idleCount++;
					}
					// Animacion esta quieto
					if (idleCount <= idleCountMax) _animation = "idle";
					else _animation = "idle";
				}
			}

			if (prevAnimation != _animation) {
				onAnimationChange.dispatch();
				if (_animation == "stand") {
					idleCountMax = int(90 + Math.random() * 150);
				} else if (prevAnimation == "standBalance") {
					idleCountMax = 0;
					idleCount = 0;
				}
			}

		}

		override public function handlePreSolve(contact : b2Contact, oldManifold : b2Manifold) : void {
			super.handlePreSolve(contact, oldManifold);
		}

		override public function handleBeginContact(contact : b2Contact) : void {
			if ( heroCanClimbLadders) {
				var ladderBody : b2Body = returnBodyIfLadder(contact);

				if (ladderBody != null) {
					isClimbing = true;
					canDuck = false;
					ladder = ladderBody.GetUserData();
				}
			}
			var collider : IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			var hurtObject : int = returnBodyIfCanHurt(contact);
			if (hurtObject != 0) {
				handleDamage(hurtObject,collider);
			}
			// Angulo de colision.
			if (contact.GetManifold().m_localPoint && !(collider is Sensor)) {
				var collisionAngle : Number = Math.atan2(contact.normal.y, contact.normal.x);

				if (collisionAngle >= Math.PI * .25 && collisionAngle <= 3 * Math.PI * .25 ) {
					_groundContacts.push(collider.body.GetFixtureList());
					_onGround = true;
					updateCombinedGroundAngle();
				}
			}
		}
		public function handleDamage(hurtObject:int,collider:IBox2DPhysicsObject):void {
			var hurtVelocity:b2Vec2 = _body.GetLinearVelocity();
			hurtVelocity.y = -hurtVelocityY;
			hurtVelocity.x = hurtVelocityX;
			if (collider.x > x)
				hurtVelocity.x = -hurtVelocityX;
			_body.SetLinearVelocity(hurtVelocity);
			lifeBar.handleDamage(hurtObject);
			this.hurt();
		}

		override public function handleEndContact(contact : b2Contact) : void {
						var collider : IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
			
			var hurtObject : int = returnBodyIfCanHurt(contact);
			if (hurtObject != 0) {
				handleDamage(hurtObject,collider);
			}
			super.handleEndContact(contact);

			if ( heroCanClimbLadders) {
				var ladderBody : b2Body = returnBodyIfLadder(contact);

				if (ladderBody != null) {
					_climbing = isClimbing = false;
					canDuck = true;
				}
			}

		}

		public function talk(text : String) : void {
			if (_message) {
				_ce.state.remove(_message);
				_message.destroy();
			}
			_message = new MessageBox("Talk");
			_message.set(this.x - this.width * 3, this.y - this.height - 5, text);
			_ce.state.add(_message);
			isTalking = true;
		}

		override protected function _createVerticesFromPoint() : void {
			super._createVerticesFromPoint();
		}

		// /when given a b2Contact, this returns the ladder, or null
		private function returnBodyIfLadder(contact : b2Contact) : b2Body {
			if (contact.GetFixtureA().GetBody().GetUserData() is Sensor && (Sensor)(contact.GetFixtureA().GetBody().GetUserData()).isLadder)
				return contact.GetFixtureA().GetBody();
			else if (contact.GetFixtureB().GetBody().GetUserData() is Sensor && (Sensor)(contact.GetFixtureB().GetBody().GetUserData()).isLadder)
				return contact.GetFixtureB().GetBody();
			else
				return null;
		}

		private function returnBodyIfCanHurt(contact : b2Contact) : int {
			if (contact.GetFixtureA().GetBody().GetUserData() is Cannon )
				return (Cannon)(contact.GetFixtureA().GetBody().GetUserData()).getDamage();
			else if (contact.GetFixtureB().GetBody().GetUserData() is Cannon)
				return (Cannon)(contact.GetFixtureB().GetBody().GetUserData()).getDamage();
			else if (contact.GetFixtureB().GetBody().GetUserData() is PassiveAI && (PassiveAI)(contact.GetFixtureB().GetBody().GetUserData()).isAttacking)
				return (PassiveAI)(contact.GetFixtureB().GetBody().GetUserData()).getDamage();
			else
				return 0;
		}

		public function getDamage() : int {
			return weapon.getDamage();
		}
		private function handleHeroJump():void {
			_ce.sound.playSound("Jump");
		}

		private function handleHeroTakeDamage():void {
			_ce.sound.playSound("Hurt");
		}

		private function handleHeroAnimationChange():void {
			if (animation == "walk") {
				_ce.sound.playSound("Walk");
				return;
			} else {
				_ce.sound.stopSound("Walk");
			}
			if(animation == "cocoAttack") {
				_ce.sound.playSound("CocoCannon");
			} else {
				_ce.sound.stopSound("CocoCannon");
			}
			if(animation == "hit") {
				_ce.sound.playSound("Hit");
			} else {
				_ce.sound.stopSound("Hit");
			}
		}
	}
	
	
}