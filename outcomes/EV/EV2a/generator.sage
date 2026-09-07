load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a set of 3 or 4 vectors in R^3 or R^4
        rows = randrange(3,5)
        columns = randrange(rows, rows+2)
        number_of_pivots = randrange(2, min(rows,columns)+1)
        A = CheckIt.simple_random_matrix_of_rank(number_of_pivots,rows=rows,columns=columns)

        vecset_ltx = latex(TBIL.VectorSet(A.columns()))
        veceqleft_ltx = latex(TBIL.LinearCombinationFromMatrix(A))

        # pool of mutually-equivalent ways to state the claim
        correct_claims = [
            f"The set of vectors <m>{vecset_ltx}</m> spans <m>\\mathbb R^{rows}</m>",
            f"<m>\\operatorname{{span}}{vecset_ltx}=\\mathbb R^{rows}</m>",
            f"The vector equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution for every <m>\\vec w\\in\\mathbb R^{rows}</m>",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> is consistent",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution",
            f"Every vector in <m>\\mathbb R^{rows}</m> can be written as a linear combination of the vectors in the set <m>{vecset_ltx}</m>",
        ]
        shuffle(correct_claims)
        stem_claim = correct_claims[0]
        answer_claim = correct_claims[1]

        # right idea, wrong dimension: not equivalent no matter the numbers
        wrong_rows = rows + choice([-1,1])
        wrongdim_claim = choice([
            f"The set of vectors <m>{vecset_ltx}</m> spans <m>\\mathbb R^{wrong_rows}</m>",
            f"<m>\\operatorname{{span}}{vecset_ltx}=\\mathbb R^{wrong_rows}</m>",
            f"The vector equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution for every <m>\\vec w\\in\\mathbb R^{wrong_rows}</m>",
            f"For every <m>\\vec w\\in\\mathbb R^{wrong_rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> is consistent",
            f"For every <m>\\vec w\\in\\mathbb R^{wrong_rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> has at least one solution",
        ])

        # pool of incorrect claims which confuse spanning with independence/basis,
        # or misuse the "for every" quantifier
        confusion_claims = [
            f"The vector equation <m>{veceqleft_ltx}=\\vec w</m> has a unique solution for every <m>\\vec w\\in\\mathbb R^{rows}</m>",
            f"The equation <m>{veceqleft_ltx}=\\vec 0</m> has only the trivial solution of all zeros",
            f"There exists at least one <m>\\vec w\\in\\mathbb R^{rows}</m> for which <m>{veceqleft_ltx}=\\vec w</m> has a solution",
            f"There exists at least one <m>\\vec w\\in\\mathbb R^{rows}</m> for which <m>{veceqleft_ltx}=\\vec w</m> has no solutions",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> has infinitely-many solutions",
            f"For every <m>\\vec w\\in\\mathbb R^{rows}</m>, the equation <m>{veceqleft_ltx}=\\vec w</m> has no solutions",
        ]

        distractors = [wrongdim_claim] + sample(confusion_claims, 2)

        choices = CheckIt.choices_from_list([answer_claim] + distractors)

        return {
            "stem_claim": stem_claim,
            "choices": choices,
        }
