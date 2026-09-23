load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # every combination of independent/dependent across sets A, B, C,
        # excluding "all three independent" and "none of them independent"
        patterns = [
            (True,True,False), (True,False,True), (False,True,True),
            (True,False,False), (False,True,False), (False,False,True),
        ]

        def label(p):
            letters = [l for l,independent in zip("ABC",p) if independent]
            if len(letters) == 1:
                return f"Only {letters[0]} is linearly independent."
            return f"Only {' and '.join(letters)} are linearly independent."

        # sets A, B, C always have 3, 4, and 5 columns, in a random order.
        # the 5-column set can never be independent in R^4, so exactly one of
        # the other two (3- and 4-column) sets is chosen to be independent, and
        # the choices still offer plausible "two sets independent" distractors.
        columns = sample([3,4,5],3)
        candidates = [i for i in range(3) if columns[i] != 5]
        independent_index = choice(candidates)
        pattern = tuple(i == independent_index for i in range(3))

        dependent_ranks = {3: [2], 4: [2,3], 5: [3,4]}
        vectorsets = []
        for i in range(3):
            rank = columns[i] if pattern[i] else choice(dependent_ranks[columns[i]])
            A = CheckIt.simple_random_matrix_of_rank(rank,rows=4,columns=columns[i])
            vectorsets.append(TBIL.VectorSet(A.columns()))

        choices = CheckIt.choices_from_list(
            [label(pattern)] + [label(p) for p in patterns if p != pattern]
        )

        return {
            "set1": vectorsets[0],
            "set2": vectorsets[1],
            "set3": vectorsets[2],
            "choices": choices,
        }
