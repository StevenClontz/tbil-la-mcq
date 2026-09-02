load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a 4x3 or 3x4 matrix
        rows = randrange(3,5)
        columns = 7-rows
        A = CheckIt.simple_random_matrix_of_rank(2,rows=rows,columns=columns)

        v = vector(ZZ, [randrange(1,7)*choice([-1,1]) for _ in range(rows)])
        veceq = TBIL.VectorEquation(A.augment(column_matrix(v), subdivide=True))

        v_ltx = latex(column_matrix(v))
        veclist_ltx = latex(TBIL.VectorList(A.columns()))
        vecset_ltx = latex(TBIL.VectorSet(A.columns()))
        veceq_ltx = latex(veceq)

        # pool of mutually-equivalent ways to state the claim
        correct_claims = [
            f"<m>{v_ltx}</m> is a linear combination of <m>{veclist_ltx}</m>",
            f"<m>{v_ltx}</m> is in the span of <m>{vecset_ltx}</m>",
            f"<m>{v_ltx} \\in \\operatorname{{span}} {vecset_ltx}</m>",
            f"The equation <m>{veceq_ltx}</m> is solvable",
            f"The solution set of the equation <m>{veceq_ltx}</m> is nonempty",
        ]
        shuffle(correct_claims)
        stem_claim = correct_claims[0]
        answer_claim = correct_claims[1]

        # right shape, wrong vector: not equivalent no matter the numbers
        perturbation = [0]*rows
        perturbation[randrange(rows)] = choice([-1,1])
        w = v + vector(ZZ, perturbation)
        w_ltx = latex(column_matrix(w))
        w_veceq_ltx = latex(TBIL.VectorEquation(A.augment(column_matrix(w), subdivide=True)))
        wrongnum_claim = choice([
            f"<m>{w_ltx}</m> is a linear combination of <m>{veclist_ltx}</m>",
            f"<m>{w_ltx}</m> is in the span of <m>{vecset_ltx}</m>",
            f"<m>{w_ltx} \\in \\operatorname{{span}} {vecset_ltx}</m>",
            f"The equation <m>{w_veceq_ltx}</m> is solvable",
            f"The solution set of the equation <m>{w_veceq_ltx}</m> is nonempty",
        ])

        # pool of incorrect claims
        confusion_claims = [
            f"<m>{v_ltx}</m> is the unique solution to the equation <m>{veceq_ltx}</m>",
            f"<m>{v_ltx}</m> is one of infinitely-many solutions to the equation <m>{veceq_ltx}</m>",
            f"The solution set of the equation <m>{veceq_ltx}</m> is <m>\\left\\{{{v_ltx}\\right\\}}</m>",
            f"The solution set of the equation <m>{veceq_ltx}</m> contains a unique vector",
            f"The solution set of the equation <m>{veceq_ltx}</m> is infinite",
            f"The solution set of the equation <m>{veceq_ltx}</m> is empty",
            f"There is only one way to write <m>{v_ltx}</m> as a linear combination of <m>{veclist_ltx}</m>",
            f"There are infinitely-many ways to write <m>{v_ltx}</m> as a linear combination of <m>{veclist_ltx}</m>",
        ]

        distractors = [wrongnum_claim] + sample(confusion_claims, 2)

        choices = CheckIt.choices_from_list([answer_claim] + distractors)

        return {
            "stem_claim": stem_claim,
            "choices": choices,
        }
