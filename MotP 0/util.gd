
var MAGIC = "unicorn"

func rot_left(v): 		return Vector2(v.y, -v.x)
func rot_right(v): 		return Vector2(-v.y, v.x)
func rot_phi(v, phi):	return roundv(v.rotated(phi))
func roundv(v): 		return Vector2(round(v.x), round(v.y))