load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # sets A, B, C, D have 3, 4, 4, and 5 columns, in a random order.
        # exactly one of the two 4-column sets is a basis of R^4; each other
        # set may satisfy one of independence/spanning, but never both.
        columns = sample([3,4,4,5],4)
        basis_index = choice([i for i in range(4) if columns[i] == 4])

        nonbasis_ranks = {3: [2,3], 4: [2,3], 5: [3,4]}
        vectorsets = []
        for i in range(4):
            rank = 4 if i == basis_index else choice(nonbasis_ranks[columns[i]])
            A = CheckIt.simple_random_matrix_of_rank(rank,rows=4,columns=columns[i])
            vectorsets.append(TBIL.VectorSet(A.columns()))

        letters = list("ABCD")
        choices = CheckIt.choices_from_list(
            [f"<m>{letters[basis_index]}</m>"] +
            [f"<m>{l}</m>" for i,l in enumerate(letters) if i != basis_index]
        )
        # list the choices in A, B, C, D order
        choices.sort(key=lambda c: c["item"])
        for i,c in enumerate(choices):
            c["letter"] = chr(ord('a')+i)

        return {
            "set1": vectorsets[0],
            "set2": vectorsets[1],
            "set3": vectorsets[2],
            "set4": vectorsets[3],
            "choices": choices,
        }
