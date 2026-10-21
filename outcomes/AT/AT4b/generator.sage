load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        def status(injective, surjective):
            if injective and surjective:
                return "both injective and surjective"
            if injective:
                return "injective but not surjective"
            if surjective:
                return "surjective but not injective"
            return "neither injective nor surjective"

        # two R^4->R^4 maps, each independently bijective or neither
        bijective = [choice([True,False]) for _ in range(2)]
        S, T = [TBIL.simple_random_matrix_of_rank(4 if b else choice([2,3]),rows=4,columns=4)
            for b in bijective]

        # (S, T) statuses as (injective, surjective) pairs: correct, then
        # flipping one or both maps
        def square(b):
            return (b,b)
        bS, bT = bijective
        pairs = [
            (square(bS), square(bT)),
            (square(not bS), square(bT)),
            (square(bS), square(not bT)),
            (square(not bS), square(not bT)),
        ]
        # conceptual error: a square map that is only one of injective
        # or surjective
        mixed = choice([(True,False),(False,True)])
        if choice([True,False]):
            pairs.append((mixed, square(bT)))
        else:
            pairs.append((square(bS), mixed))

        choices = CheckIt.choices_from_list(
            [{"S": status(*s), "T": status(*t)} for s,t in pairs]
        )
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "matrixS": S,
            "matrixT": T,
            "choices": choices,
        }
