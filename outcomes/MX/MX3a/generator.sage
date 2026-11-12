load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # 3x3 invertible matrix whose columns form the basis, regenerated
        # until all choices are distinct
        while True:
            A = TBIL.simple_random_matrix_of_rank(3,rows=3,columns=3)
            Ainv = A^(-1)
            # correct change-of-basis matrix, then the transpose, the
            # transpose of the inverse, and the original matrix
            lst = [Ainv, A.transpose(), Ainv.transpose(), A]
            if len(set(latex(M) for M in lst)) == len(lst):
                break

        choices = CheckIt.choices_from_list([{"matrix": M} for M in lst])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "b_1": column_matrix(A.column(0)),
            "b_2": column_matrix(A.column(1)),
            "b_3": column_matrix(A.column(2)),
            "choices": choices,
        }
