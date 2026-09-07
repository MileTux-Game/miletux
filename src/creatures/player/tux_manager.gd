extends CharacterBody2D

enum TuxStates
{
	SMALL,
	BIG,
	FIRE
}

var current_state = TuxStates.SMALL
var direction = 1
