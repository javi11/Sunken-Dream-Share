import flash.geom.ColorTransform;
import flash.geom.Transform;
/*
*Cambiar Brillo
*	Pone el brillo deseado al personaje o MC
*/
Color.prototype.setBrightOffset = function (offset) {
	var trans = new Object();
	trans.rb = trans.gb = trans.bb = offset;
	this.setTransform(trans);
}
MovieClip.prototype.setBrightness = function (offset) {
	var c = new Color (this);
	c.setBrightOffset(offset);
};