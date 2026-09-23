load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a set of n-1 or n+1 vectors in R^n for n=4 or n=5.
        # (n vectors in R^n are avoided, since then spanning alone or
        # independence alone would be equivalent to being a basis.)
        rows = randrange(4,6)
        columns = rows + choice([-1,1])
        number_of_pivots = randrange(2, min(rows,columns)+1)
        A = CheckIt.simple_random_matrix_of_rank(number_of_pivots,rows=rows,columns=columns)

        vecset_ltx = latex(TBIL.VectorSet(A.columns()))
        veceqleft_ltx = latex(TBIL.LinearCombinationFromMatrix(A))

        # pool of mutually-equivalent ways to state the claim
        correct_claims = [
            f"The set of vectors <m>{vecset_ltx}</m> is a basis for <m>\\mathbb R^{rows}</m>",
            f"The vector equation <m>{veceqleft_ltx}=\\vec w</m> has exactly one solution for every <m>\\vec w\\in\\mathbb R^{rows}</m>",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> has a unique solution",
            f"The set of vectors <m>{vecset_ltx}</m> both spans <m>\\mathbb R^{rows}</m> and is linearly independent",
            f"The equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution for every <m>\\vec w\\in\\mathbb R^{rows}</m>, and the equation <m>{veceqleft_ltx}=\\vec 0</m> has only the trivial solution",
            f"Every vector in <m>\\mathbb R^{rows}</m> can be written as a linear combination of the vectors in the set <m>{vecset_ltx}</m> in exactly one way",
        ]
        shuffle(correct_claims)
        stem_claim = correct_claims[0]
        answer_claim = correct_claims[1]

        # pool of incorrect claims which only guarantee spanning
        spanning_claims = [
            f"The set of vectors <m>{vecset_ltx}</m> spans <m>\\mathbb R^{rows}</m>",
            f"The vector equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution for every <m>\\vec w\\in\\mathbb R^{rows}</m>",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> is consistent",
            f"Every vector in <m>\\mathbb R^{rows}</m> can be written as a linear combination of the vectors in the set <m>{vecset_ltx}</m>",
        ]
        shuffle(spanning_claims)

        # pool of incorrect claims which only guarantee independence
        independence_claims = [
            f"The set of vectors <m>{vecset_ltx}</m> is linearly independent",
            f"The vector equation <m>{veceqleft_ltx}=\\vec 0</m> has exactly one solution",
            f"The vector equation <m>{veceqleft_ltx}=\\vec 0</m> has only the trivial solution",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> has at most one solution",
        ]
        shuffle(independence_claims)

        # one of each kind, plus one more of either kind
        distractors = [
            spanning_claims[0],
            independence_claims[0],
            choice(spanning_claims[1:] + independence_claims[1:]),
        ]

        choices = CheckIt.choices_from_list([answer_claim] + distractors)

        return {
            "stem_claim": stem_claim,
            "choices": choices,
        }
