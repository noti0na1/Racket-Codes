#lang sweet-exp racket

define add(x y)
    {x + y}

define mult(x y)
    {x * y}

define fun(x y)
    if {x < y}
       add(x y)
       mult(x y)

fun(2 3)
fun(3 2)
