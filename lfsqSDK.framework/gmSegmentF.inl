
#include "gmHeader.h"

inline
gmBoolean               
gmSegmentF::operator!=(const gmSegmentF &seg) const
{
    return !(*this == seg);
}

inline
gmBoolean               
gmSegmentF::operator==(const gmSegmentF &seg) const
{
    return headVal == seg.head()
        && tailVal == seg.tail();
}

inline gmDouble
gmSegmentF::getDeltaX() const
{
    return x2() - x1();
}

inline gmDouble
gmSegmentF::getDeltaY() const
{
    return y2() - y1();
}

inline void
gmSegmentF::set(const gmPointF   &head, const gmPointF   &tail)
{
    headVal = head;
    tailVal = tail;
}

inline void 
gmSegmentF::set(const gmVectorF &vec, const gmPointF &ref)
{
    gmPointF ptF;
    vec.addToPoint(ref,ptF);

    headVal = ref;
    tailVal = ptF;
}

inline 
gmSegmentF::gmSegmentF()
: headVal()
, tailVal()
{

}

inline 
gmSegmentF::gmSegmentF(const gmPointF& headIn, const gmPointF& tailIn)
: headVal(headIn)
, tailVal(tailIn)
{

}

inline gmDouble &
gmSegmentF::x1()
{
    return headVal.x();
}

inline gmDouble &
gmSegmentF::x2()
{
    return tailVal.x();
}

inline gmDouble &
gmSegmentF::y1()
{
    return headVal.y();
}

inline gmDouble &
gmSegmentF::y2()
{
    return tailVal.y();
}

inline gmDouble
gmSegmentF::x1() const
{
    return headVal.x();
}

inline gmDouble
gmSegmentF::x2() const
{
    return tailVal.x();
}

inline gmDouble
gmSegmentF::y1() const
{
    return headVal.y();
}

inline gmDouble
gmSegmentF::y2() const
{
    return tailVal.y();
}

// *****************************************************************************
// gmSegmentF::isHorizontal()
// gmSegmentF::isVertical()
// gmSegmentF::isOrthogonal()
//
// These functions return true if this segment's slope is zero, +/- infinity, or
// either respectively.
// *****************************************************************************
inline gmBoolean
gmSegmentF::isHorizontal() const
{
    return gmIsFloatCloseTo(y1(), y2());
}

inline gmBoolean
gmSegmentF::isVertical() const
{
    return gmIsFloatCloseTo(x1(), x2());
}

inline gmBoolean
gmSegmentF::isOrthogonal() const
{
    return isVertical() || isHorizontal();
}

