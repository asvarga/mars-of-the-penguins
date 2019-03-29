
var MAGIC = "unicorn"
enum Modes { RIGHT, CENTER, LEFT }

func rot_phi(v, phi):	return roundv(v.rotated(phi))
func roundv(v): 		return Vector2(round(v.x), round(v.y))
func pop(d):            for i in d: return i
