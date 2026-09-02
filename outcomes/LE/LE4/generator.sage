load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a 4x5 matrix with 3, 2, or 1 non-pivot cols
        rows = 4
        columns = 5
        ranks = [2, 3, 4]

        def random_consistent_matrix(rank):
            A = CheckIt.simple_random_matrix_of_rank(rank,rows=rows,columns=columns)
            image_basis = [A.column(p) for p in A.pivots()]
            coeffs = [
                randrange(1,4)*choice([-1,1])
                for _ in range(rank)
            ]
            lin_combo = column_matrix(sum([
                coeffs[p]*image_basis[p]
                for p in range(rank)
            ]))
            return A.augment(lin_combo, subdivide=True)

        # correct system: has (columns - correct_rank) free variables
        correct_rank = choice(ranks)
        m = random_consistent_matrix(correct_rank)
        correct_solset = CheckIt.latex_solution_set_from_matrix(m)

        if choice([True,False]):
            system_label = "system"
            system = CheckIt.latex_system_from_matrix(m)
        else:
            system_label = "vec_eq"
            system = TBIL.VectorEquation(m)

        # distractor with the same number of free variables as the correct answer
        same_free_solset = correct_solset
        while same_free_solset == correct_solset:
            same_free_solset = CheckIt.latex_solution_set_from_matrix(
                random_consistent_matrix(correct_rank)
            )

        # two distractors sharing a different, but still positive, number of
        # free variables
        wrong_rank = choice([r for r in ranks if r != correct_rank])
        wrong_free_solset_1 = CheckIt.latex_solution_set_from_matrix(
            random_consistent_matrix(wrong_rank)
        )
        wrong_free_solset_2 = wrong_free_solset_1
        while wrong_free_solset_2 == wrong_free_solset_1:
            wrong_free_solset_2 = CheckIt.latex_solution_set_from_matrix(
                random_consistent_matrix(wrong_rank)
            )

        choices = CheckIt.choices_from_list([
            correct_solset,
            same_free_solset,
            wrong_free_solset_1,
            wrong_free_solset_2,
        ])

        return {
            system_label: system,
            "choices": choices,
        }
