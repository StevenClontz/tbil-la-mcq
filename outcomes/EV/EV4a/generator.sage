load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a set of 3 to 5 vectors in R^4 or R^5
        rows = randrange(4,6)
        columns = randrange(rows-1, rows+1)
        number_of_pivots = randrange(2, columns+1)
        A = CheckIt.simple_random_matrix_of_rank(number_of_pivots,rows=rows,columns=columns)

        vecset_ltx = latex(TBIL.VectorSet(A.columns()))
        veceqleft_ltx = latex(TBIL.LinearCombinationFromMatrix(A))

        # pool of mutually-equivalent ways to state the claim
        correct_claims = [
            f"The set of vectors <m>{vecset_ltx}</m> is linearly independent",
            f"The vector equation <m>{veceqleft_ltx}=\\vec 0</m> has exactly one solution",
            f"The vector equation <m>{veceqleft_ltx}=\\vec 0</m> has only the trivial solution",
            f"The only solution to <m>{veceqleft_ltx}=\\vec 0</m> is the one where every coefficient is zero",
            f"The equation <m>{veceqleft_ltx}=\\vec 0</m> has no nontrivial solutions",
            f"No vector in the set <m>{vecset_ltx}</m> can be written as a linear combination of the others",
        ]
        shuffle(correct_claims)
        stem_claim = correct_claims[0]
        answer_claim = correct_claims[1]

        # right equation shape, wrong property: confuses independence with spanning
        spanning_claim = choice([
            f"The vector equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution for every <m>\\vec w\\in\\mathbb R^{rows}</m>",
            f"The set of vectors <m>{vecset_ltx}</m> spans <m>\\mathbb R^{rows}</m>",
        ])

        # pool of incorrect claims which describe dependence, or which
        # hold (or fail) for every set of vectors
        confusion_claims = [
            f"The equation <m>{veceqleft_ltx}=\\vec 0</m> has at least one solution",
            f"The equation <m>{veceqleft_ltx}=\\vec 0</m> has infinitely-many solutions",
            f"The equation <m>{veceqleft_ltx}=\\vec 0</m> has a nontrivial solution",
            f"The equation <m>{veceqleft_ltx}=\\vec 0</m> has no solutions",
            f"At least one vector in the set <m>{vecset_ltx}</m> can be written as a linear combination of the others",
        ]

        distractors = [spanning_claim] + sample(confusion_claims, 2)

        choices = CheckIt.choices_from_list([answer_claim] + distractors)

        return {
            "stem_claim": stem_claim,
            "choices": choices,
        }
