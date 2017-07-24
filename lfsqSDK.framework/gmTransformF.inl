
#include "gmTransformF.h"

inline gmPointF &
gmTransformF::offset()
{
    return offsetVal;
}

inline gmDouble &
gmTransformF::xOffset()
{
    return offsetVal.x();
}

inline gmDouble &
gmTransformF::yOffset()
{
    return offsetVal.y();
}

inline gmOrient &
gmTransformF::orient()
{
    return orientVal;
}

inline gmDouble &
gmTransformF::magnify()
{
    return magVal;
}

inline const gmPointF &
gmTransformF::offset() const
{
    return offsetVal;
}

inline gmDouble
gmTransformF::xOffset() const
{
    return offsetVal.x();
}

inline gmDouble
gmTransformF::yOffset() const
{
    return offsetVal.y();
}

inline gmOrient
gmTransformF::orient() const
{
    return orientVal;
}

inline gmDouble 
gmTransformF::magnify() const
{
    return magVal;
}


inline
gmTransformF::gmTransformF()
: offsetVal(0, 0), 
  orientVal(gmcR0),
  magVal(1.0)
{
}

inline
gmTransformF::gmTransformF(const gmPointF  &offsetIn,
                         gmOrient       orientIn)
: offsetVal(offsetIn),
  orientVal(orientIn),
  magVal(1.0)
{
}

inline
gmTransformF::gmTransformF(gmDouble   xOffsetIn,
                         gmDouble   yOffsetIn,
                         gmOrient   orientIn)
: offsetVal(xOffsetIn, yOffsetIn),
  orientVal(orientIn),
  magVal(1.0)
{

}

inline
gmTransformF::gmTransformF(gmOrient orientIn)
: offsetVal(0, 0),
  orientVal(orientIn),
  magVal(1.0)
{
}

inline void
gmTransformF::set(const gmPointF  &offsetIn,
                 gmOrient       orientIn)
{
    offsetVal = offsetIn;
    orientVal = orientIn;
    magVal = 1.0;
}

inline void
gmTransformF::set(gmDouble   xOffsetIn,
                 gmDouble  yOffsetIn,
                 gmOrient   orientIn)
{
    offsetVal.set(xOffsetIn, yOffsetIn);
    orientVal = orientIn;
    magVal = 1.0;
}

inline void
gmTransformF::set(gmOrient orientIn)
{
    offsetVal.set(0, 0);
    orientVal = orientIn;
    magVal = 1.0;
}

inline void
gmTransformF::invert()
{
    gmTransformF tmp;

    invert(tmp);
    *this = tmp;
}

inline void
gmTransformF::init()
{
    offsetVal.x() = 0;
    offsetVal.y() = 0;
    orientVal = gmcR0;
    magVal = 1.0;
}

inline gmBoolean
gmTransformF::operator==(const gmTransformF &xform) const
{
    return gmIsFloatCloseTo(offsetVal.y() , xform.offsetVal.y())
           && gmIsFloatCloseTo(offsetVal.x() , xform.offsetVal.x())
           && (orientVal == xform.orientVal);
}

inline gmBoolean
gmTransformF::operator!=(const gmTransformF &xform) const
{
    return !(gmIsFloatCloseTo(offsetVal.y() , xform.offsetVal.y())
           && gmIsFloatCloseTo(offsetVal.x() , xform.offsetVal.x())
           && (orientVal == xform.orientVal));
}

inline void
gmTransformF::invert(gmTransformF &result) const
{
    gmDouble  dX = -xOffset();
    gmDouble  dY = -yOffset();

    switch (orient()) {
    case gmcR0:
        result.xOffset() = dX;
        result.yOffset() = dY;
        result.orient() = gmcR0;
        break;

    case gmcR90:
        result.xOffset() = dY;
        result.yOffset() = -dX;
        result.orient() = gmcR270;
        break;

    case gmcR180:
        result.xOffset() = -dX;
        result.yOffset() = -dY;
        result.orient() = gmcR180;
        break;

    case gmcR270:
        result.xOffset() = -dY;
        result.yOffset() = dX;
        result.orient() = gmcR90;
        break;

    case gmcMY:
        result.xOffset() = -dX;
        result.yOffset() = dY;
        result.orient() = gmcMY;
        break;

    case gmcMYR90:
        result.xOffset() = -dY;
        result.yOffset() = -dX;
        result.orient() = gmcMYR90;
        break;

    case gmcMX:
        result.xOffset() = dX;
        result.yOffset() = -dY;
        result.orient() = gmcMX;
        break;

    case gmcMXR90:
        result.xOffset() = dY;
        result.yOffset() = dX;
        result.orient() = gmcMXR90;
        break;
    }
}


