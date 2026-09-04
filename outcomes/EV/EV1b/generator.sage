load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a 4x3 or 3x4 matrix
        rows = randrange(3,5)
        columns = 7-rows
        number_of_pivots = 2
        A = CheckIt.simple_random_matrix_of_rank(number_of_pivots,rows=rows,columns=columns)

        # genuine linear combination of the pivot columns
        coeffs = [
            randrange(1,4)*choice([-1,1])
            for _ in range(number_of_pivots)
        ]
        lin_combo = sum([
            coeffs[i]*A.column(A.pivots()[i])
            for i in range(number_of_pivots)
        ])

        # decoys: vectors outside the column space of A
        def random_decoy():
            v = lin_combo + vector(ZZ, [choice([-1,1]) for _ in range(rows)])
            while v in A.column_space():
                v += vector(ZZ, [choice([-1,1]) for _ in range(rows)])
            return v

        decoys = []
        while len(decoys) < 3:
            v = random_decoy()
            if v not in decoys:
                decoys.append(v)

        choices = CheckIt.choices_from_list([
            column_matrix(lin_combo),
            column_matrix(decoys[0]),
            column_matrix(decoys[1]),
            column_matrix(decoys[2]),
        ])

        return {
            "veclist": TBIL.VectorList(A.columns()),
            "vecset": TBIL.VectorSet(A.columns()),
            "choices": choices,
            choice(["linearcombo","set","span"]): True
        }
