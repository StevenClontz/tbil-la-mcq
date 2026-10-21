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

        # tall R^3->R^4 map (never surjective) and wide R^5->R^4 map
        # (never injective)
        injective = choice([True,False])
        tall = TBIL.simple_random_matrix_of_rank(3 if injective else 2,rows=4,columns=3)
        surjective = choice([True,False])
        wide = TBIL.simple_random_matrix_of_rank(4 if surjective else choice([2,3]),rows=4,columns=5)

        # (tall, wide) statuses as (injective, surjective) pairs: correct,
        # then flipping the rank-dependent property of one or both maps
        correct = ((injective,False), (False,surjective))
        flip_tall = ((not injective,False), (False,surjective))
        flip_wide = ((injective,False), (False,not surjective))
        flip_both = ((not injective,False), (False,not surjective))
        # conceptual error: mixing up injective and surjective
        def swap(pair):
            return tuple((s,i) for i,s in pair)
        swapped = swap(correct)
        if swapped == correct:
            swapped = swap(flip_both)
        pairs = [correct, flip_tall, flip_wide, flip_both, swapped]

        # randomly decide whether the tall map is S or T
        tall_is_S = choice([True,False])
        def choice_data(pair):
            t, w = status(*pair[0]), status(*pair[1])
            return {"S": t, "T": w} if tall_is_S else {"S": w, "T": t}
        choices = CheckIt.choices_from_list([choice_data(p) for p in pairs])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        S, T = (tall, wide) if tall_is_S else (wide, tall)
        return {
            "matrixS": S,
            "nS": S.ncols(),
            "mS": S.nrows(),
            "matrixT": T,
            "nT": T.ncols(),
            "mT": T.nrows(),
            "choices": choices,
        }
