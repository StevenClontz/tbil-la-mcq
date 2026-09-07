load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # every combination of span/no-span across sets A, B, C,
        # excluding "all three span" and "none of them span"
        patterns = [
            (True,True,False), (True,False,True), (False,True,True),
            (True,False,False), (False,True,False), (False,False,True),
        ]

        def label(p):
            letters = [l for l,spans in zip("ABC",p) if spans]
            if len(letters) == 1:
                return f"Only {letters[0]} spans <m>\\mathbb R^4</m>."
            return f"Only {' and '.join(letters)} span <m>\\mathbb R^4</m>."

        # sets A, B, C always have 3, 4, and 5 columns, in a random order.
        # the 3-column set can never span R^4, so exactly one of the other
        # two (4- and 5-column) sets is chosen to span, and the choices
        # still offer plausible "two sets span" distractors alongside it.
        columns = sample([3,4,5],3)
        candidates = [i for i in range(3) if columns[i] != 3]
        spanning_index = choice(candidates)
        pattern = tuple(i == spanning_index for i in range(3))

        vectorsets = []
        for i in range(3):
            rank = 4 if pattern[i] else choice([2,3])
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
