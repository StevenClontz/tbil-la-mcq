load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # invertible matrix, regenerated until all choices are distinct
        while True:
            A = TBIL.simple_random_matrix_of_rank(4,rows=4,columns=4)
            Ainv = A^(-1)
            # correct inverse, then confusing the inverse with the
            # transpose, the transpose of the inverse, or a power
            lst = [Ainv, A.transpose(), Ainv.transpose(), A^2]
            if len(set(M.list().__repr__() for M in lst)) == len(lst):
                break
        # non-invertible matrix
        N = TBIL.simple_random_matrix_of_rank(choice([2,3]),rows=4,columns=4)

        matrices = [A,N]
        shuffle(matrices)

        choices = CheckIt.choices_from_list([{"inverse": M} for M in lst])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "A": matrices[0],
            "B": matrices[1],
            "choices": choices,
        }
