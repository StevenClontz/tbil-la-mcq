load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        def yesno_choices(spans):
            return CheckIt.choices_from_list([
                "Yes, this set of vectors spans <m>\\mathbb R^4</m>." if spans
                    else "No, this set of vectors does not span <m>\\mathbb R^4</m>.",
                "No, this set of vectors does not span <m>\\mathbb R^4</m>." if spans
                    else "Yes, this set of vectors spans <m>\\mathbb R^4</m>.",
            ])

        # too few vectors to span R^4: guaranteed not to span
        A = CheckIt.simple_random_matrix_of_rank(2,rows=4,columns=3)
        tasks = [{
            "vecset": TBIL.VectorSet(A.columns()),
            "choices": yesno_choices(False),
        }]

        spans = choice([True,False])
        rank = 4 if spans else choice([2,3])
        A = CheckIt.simple_random_matrix_of_rank(rank,rows=4,columns=4)
        tasks.append({
            "vecset": TBIL.VectorSet(A.columns()),
            "choices": yesno_choices(spans),
        })

        spans = not spans
        rank = 4 if spans else choice([2,3])
        A = CheckIt.simple_random_matrix_of_rank(rank,rows=4,columns=5)
        tasks.append({
            "vecset": TBIL.VectorSet(A.columns()),
            "choices": yesno_choices(spans),
        })

        shuffle(tasks)

        return {"tasks": tasks}
