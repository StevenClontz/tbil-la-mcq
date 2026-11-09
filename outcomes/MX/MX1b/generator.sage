load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # A is m x n and B is n x m, so both AB and BA are defined
        m, n = sample([2,3,4], 2)
        # column of AB to find, and a different column
        j, k = sample(range(min(m,n)), 2)

        # regenerate until all choices look different (A and B have different
        # shapes) and every distractor differs from the correct column
        while True:
            A = TBIL.simple_random_matrix_of_rank(min(m,n), rows=m, columns=n)
            B = TBIL.simple_random_matrix_of_rank(min(m,n), rows=n, columns=m)
            pairs = [
                (A, B.column(j)),                     # correct
                (A, B.column(k)),                     # wrong column of B
                (B, A.column(j)),                     # wrong order (column of BA)
                (A, identity_matrix(n).column(j)),    # column of A
                (B, identity_matrix(m).column(j)),    # column of B
            ]
            correct = pairs[0][0]*pairs[0][1]
            distinct = len(set((M.dimensions(),tuple(v)) for M,v in pairs)) == len(pairs)
            if distinct and all(M*v != correct for M,v in pairs[1:]):
                break

        choices = CheckIt.choices_from_list(
            [{"matrix": M, "vector": column_matrix(v)} for M,v in pairs]
        )
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "A": A,
            "B": B,
            "ordinal": ["first", "second", "third", "fourth"][j],
            "choices": choices,
        }
