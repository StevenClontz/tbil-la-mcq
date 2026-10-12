load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # T:R^2->R^4 or T:R^3->R^3, given by its values on a non-standard basis
        n, m = 2,4 # choice([(2,4),(3,3)])

        def standard_like(v):
            return sum([abs(x) for x in v]) == 1

        while True:
            # basis matrix with determinant +-1, so every choice has integer entries
            B = random_matrix(ZZ, n, algorithm='unimodular', upper_bound=4)
            if any(standard_like(v) for v in B.columns()) or \
                    max(abs(x) for x in B.list()) > 4:
                continue
            # correct standard matrix, and images of the basis vectors
            A = TBIL.simple_random_matrix_of_rank(n, rows=m, columns=n)
            C = A*B
            # distractors: the images themselves, multiplying by B instead of
            # its inverse, and transposing the inverse
            options = [A, C, C*B, C*B.inverse().transpose()]
            # keep entries small so no choice stands out, and choices distinct
            if max(abs(x) for M in options for x in M.list()) > 12:
                continue
            if len(set(tuple(M.list()) for M in options)) == len(options):
                break

        images = [
            {"vec": column_matrix(B.column(i)), "img": column_matrix(C.column(i))}
            for i in range(n)
        ]

        return {
            "n": n,
            "m": m,
            "basis": TBIL.VectorSet(B.columns()),
            "images": images,
            "choices": CheckIt.choices_from_list(options),
        }
