from godot import exposed, export
from godot import *


@exposed
class demo(Node):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		print(f"Hello world.")
		pass
