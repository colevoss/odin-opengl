# Vectors

## Math

### Scalar Math

```
Vec3{1, 2, 3} + x = Vec3{1 + x, 2 + x, 3 + x}
```

This applies to subtraction, multiplication, and division

### Vector Math

Operations are performed component-wise (x and x , y and y, z and z)

```
Vec3{1, 2, 3} + Vec3{4, 5, 6} = Vec3{1 + 4, 2 + 5, 3 + 6} = Vec3{5, 7, 9}
```

This applies to subtraction as well

## Length 

The length of a vector is done by taking the Pythagorean theorem of the x and y (and z)

```
length(Vec2{3, 2}) = sqrt(3^2 + 2^2)
```

Length is denoted as ||v||

### Unit Vector

Unit vector is a vector with a length of 1. This is found by dividing a vector by its length

```
unit(v) = v / ||v||
```

## Vector-vector multiplication

### Dot Product

The dot product of two vectors is equal to the scalar product of their lengths times cosine
of the angle between them.

```
dot(k, v) = ||k|| * ||v|| * cos()
```

This is affectively calculated by doing component-wise multiplication where the results are added
together.

```
Vec3{1, 2, 3} * Vec3{4, 5, 6} = (1 * 4) + (2 * 5) + (3 * 6) = 32
```

### Cross Product

tldr; creates an vector orhtogonal to the two input vectors

The cross product is only defined in 3D space and takes two non-parallel vectors as input and produces a third
vector that is orthogonal to both the input vectors. If both the input vectors are orthogonal to each other as well,
a cross product would result in 3 orthogonal vectors; this will prove useful in the upcoming chapters.

# Matrices

## Addition and Subtraction

Matrix addition and subtraction between two matrices is done on a per-element basis

```
1 2 + 5 6 = 1+5 2+6 =  6  8
3 4   7 8   3+6 4+8   10 12
```

## Scalar Products

A matrix multiplied by a scalar just multiplies each element by the scalar

```
2 * 1 2 = 2*1 2*2 = 2 4
    3 4   1*3 2*4   6 8
```

## Matrix-matrix multiplication

2 Rules:

1. You can only multiply two matrices if the number of columns on the left-hand side matrix is equal to the number of rows on the right-hand side matrix.
2. Matrix multiplication is not commutative that is `A*B != B*A`
