load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # span of 4 or 5 vectors in R^4 with dimension 2 or 3, so there is
        # always at least one dependent vector. regenerate until neither the
        # pivot columns of the RREF nor the non-pivot columns happen to also
        # be a basis of W.
        n = choice([4,5])
        dim = choice([2,3])
        while True:
            A = TBIL.simple_random_matrix_of_rank(dim,columns=n,rows=4)
            pivots = A.pivots()
            rref_basis = [A.rref().column(i) for i in pivots]
            nonpivots = [A.column(i) for i in range(n) if i not in pivots]
            rref_is_basis = all(v in A.column_space() for v in rref_basis)
            nonpivots_is_basis = len(nonpivots) == dim and matrix(nonpivots).rank() == dim
            if not rref_is_basis and not nonpivots_is_basis:
                break

        basis = [A.column(i) for i in pivots]

        def claim(vectors, k):
            return f"<m>{latex(TBIL.VectorSet(vectors))}</m> is a basis of <m>W</m>, so <m>\\dim W = {k}</m>"

        choices = CheckIt.choices_from_list([
            claim(basis, dim),
            # uses pivot columns of the RREF instead of the original vectors
            claim(rref_basis, dim),
            # keeps every vector, even though they're dependent
            claim(A.columns(), n),
            # uses the non-pivot columns instead of the pivot columns
            claim(nonpivots, n-dim),
            # confuses the dimension of W with that of R^4
            claim(basis, 4),
        ])

        return {
            "vlist": TBIL.VectorSet(A.columns()),
            "choices": choices,
        }
