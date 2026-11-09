load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # column of the inverse to find, and a different column
        j, k = sample(range(4), 2)
        e = identity_matrix(4).columns()

        # regenerate until all six equations are distinct
        while True:
            A = TBIL.simple_random_matrix_of_rank(4,rows=4,columns=4)
            At = A.transpose()
            # correct system, then using a column of A as the constant,
            # using the transpose (finds a row of the inverse), and/or
            # using the wrong column
            pairs = [
                (A, e[j]),
                (A, A.column(j)),
                (At, e[j]),
                (A, e[k]),
                (At, A.column(k)),
                (At, e[k]),
            ]
            if len(set((M.list().__repr__(),tuple(v)) for M,v in pairs)) == len(pairs):
                break

        choices = CheckIt.choices_from_list([
            {"equation": TBIL.VectorEquation(M.augment(column_matrix(v),subdivide=True))}
            for M,v in pairs
        ])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "A": A,
            "ordinal": ["first", "second", "third", "fourth"][j],
            "choices": choices,
        }
