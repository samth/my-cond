#lang scribble/manual

@(require scribble/eval
          my-cond)

@(require (for-label racket/base
                     racket/local
                     my-cond))

@title{my-cond}

@defmodule[my-cond]

@defform[(my-cond my-cond-clause ...)
         #:grammar ([my-cond-clause normal-cond-clause
                                    for/cond-clause-form
                                    for*/cond-clause-form
                                    (code:line #:defs [def ...])
                                    (code:line #:let ([var val] ...))
                                    (code:line #:begin [def-or-expr ...])
                                    ]
                    [normal-cond-clause [condition-expr then-body ...+]
                                        [else then-body ...+]
                                        [condition-expr => proc-expr]
                                        [condition-expr]]
                    [for/cond-clause-form (for/cond-clause (for-clause ...) my-cond-clause ...)]
                    [for*/cond-clause-form (for*/cond-clause (for-clause ...) my-cond-clause ...)]
                    [for-clause [id seqence-expr]
                                [(id ...) sequence-expr]
                                (code:line #:when guard-expr)
                                (code:line #:unless guard-expr)
                                (code:line #:break guard-expr)
                                (code:line #:final guard-expr)])]{
like @racket[cond], but with the ability to use things like @racket[for/cond-clause] to iterate
through cond-clauses like @racket[for] would.

@racket[my-cond] also allows easy internal definitions with things like @racket[#:defs [def ...]]
and @racket[#:let ([var val] ...)].  

As soon as one of the conditions evaluates to a true value, it
returns whatever @racket[cond] would return as the result of that clause.  

Otherwise, it goes on to the next clause, if there is one.  

If it reaches the end of a @racket[my-cond] expression where none of the conditions returned a true
value, the @racket[my-cond] expression returns @|void-const|.

If it reaches the end of a @racket[for/cond-clause] or @racket[for*/cond-clause] form, then it goes
through the @racket[for/cond-clause] form again for the next iteration (if there is one).  

If there is no "next iteration," then it goes on to the next clause after the @racket[for/cond-clause]
form (if there is one).  

An @racket[else] clause can only appear as the last clause of a @racket[my-cond] (or @racket[cond])
form, and cannot appear inside of a @racket[for/cond-clause] or @racket[for*/cond-clause] form.  

@examples[
  (require my-cond)
  (my-cond (for/cond-clause ([i (in-range 0 5)])
             [(<= 3 i) i]
             [(<= 2 i) (number->string i)]))
  (my-cond (for/cond-clause ([i (in-range 0 5)])
             [(<= 2 i) i]
             [(<= 3 i) (number->string i)]))
]}