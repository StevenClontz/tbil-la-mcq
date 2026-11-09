load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        solution = column_matrix(
            vector(QQ, [randrange(1,5)*choice([-1,1]) for _ in range(4)])
        )

        # regenerate until all calculations look different and only the
        # correct calculation gives the solution
        while True:
            A = TBIL.simple_random_matrix_of_rank(4,rows=4,columns=4)
            b = A*solution
            Ainv = A^(-1)
            AtInv = A.transpose()^(-1)
            # (matrix, vector) pairs: correct calculation (inverse of A),
            # forgetting the inverse, using the inverse of the transpose, and
            # then the same calculations applied to the solution instead of
            # the constants
            lst = [(M,v) for v in [b, solution] for M in [Ainv, A, AtInv]]
            distinct = len(set(latex(M)+latex(v) for M,v in lst)) == len(lst)
            if distinct and all(M*v != solution for M,v in lst[1:]):
                break

        choices = CheckIt.choices_from_list(
            [{"matrix": M, "vector": v} for M,v in lst]
        )
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "vector_eq": TBIL.VectorEquation(A.augment(b, subdivide=True)),
            "choices": choices,
        }
