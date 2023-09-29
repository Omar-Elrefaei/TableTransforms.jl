# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    SciTypeAssertion{T}(selector = AllSelector())

Asserts that the columns in the `selector` have a scientific type `T`.
"""
struct SciTypeAssertion{T,S<:ColumnSelector}
  selector::S
end

SciTypeAssertion{T}(selector::S) where {T,S<:ColumnSelector} = SciTypeAssertion{T,S}(selector)

SciTypeAssertion{T}() where {T} = SciTypeAssertion{T}(AllSelector())

function (assertion::SciTypeAssertion{T})(table) where {T}
  cols = Tables.columns(table)
  names = Tables.columnnames(cols)
  snames = assertion.selector(names)

  for nm in snames
    x = Tables.getcolumn(cols, nm)
    @assert elscitype(x) <: T "The column '$nm' is not of scientific type $T"
  end
end
