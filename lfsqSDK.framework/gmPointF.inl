
#include "gmPointF.h"


inline gmPointF::gmPointF()
{
	xVal = 0;
	yVal = 0;
}

//////////////////////////////////////////////////////////////////////////////
/// This function creates a point containing the specified X/Y coordinates.
//////////////////////////////////////////////////////////////////////////////

inline gmPointF::gmPointF(gmDouble xValIn, gmDouble yValIn)
{
    xVal = xValIn;
    yVal = yValIn;
}


//////////////////////////////////////////////////////////////////////////////
/// These return the x and y coordinates of an gmPointF object.
//////////////////////////////////////////////////////////////////////////////

inline gmDouble& gmPointF::x()
{
    return xVal;
}

inline gmDouble& gmPointF::y()
{
    return yVal;
}

inline gmDouble    gmPointF::x() const
{
    return xVal;
}

inline gmDouble    gmPointF::y() const
{
    return yVal;
}

//////////////////////////////////////////////////////////////////////////////
/// This function sets both coordinates of the point at once.
//////////////////////////////////////////////////////////////////////////////

inline void gmPointF::set(gmDouble x, gmDouble y)
{
    xVal = x;
    yVal = y;
}

inline gmBoolean gmPointF::operator==(const gmPointF& pt) const
{
    if (this == &pt)
        return true;
    return gmIsFloatCloseTo(xVal , pt.x()) &&
           gmIsFloatCloseTo(yVal , pt.y());
}

inline gmBoolean gmPointF::operator!=(const gmPointF& pt) const
{
    return !(*this == pt);
}

inline gmPointF gmPointF::operator-(const gmPointF& pt) const
{
    return gmPointF(xVal - pt.x(), yVal - pt.y());
}

inline gmPointF gmPointF::operator+(const gmPointF& pt) const
{
    return gmPointF(xVal + pt.x(), yVal + pt.y());
}

inline gmPointF &
gmPointF::operator+=(const gmPointF &pt)
{
    xVal += pt.x();
    yVal += pt.y();

    return *this;
}

inline gmPointF &
gmPointF::operator-=(const gmPointF &pt)
{
    xVal -= pt.x();
    yVal -= pt.y();

    return *this;
}

inline gmPointF
gmPointF::operator-() const
{
    return gmPointF(-xVal, -yVal);
}

//////////////////////////////////////////////////////////////////////////////
/// This function transforms this point by the specified transform.
//////////////////////////////////////////////////////////////////////////////
inline void
gmPointF::transform(const gmOrient& o)
{
    gmDouble d;
    switch (o) 
    {
        case gmcR0:
            break;
        case gmcR90:
            d = x();
            x() = - y();
            y() = d;
            break;
        case gmcR180:
            x() = - x();
            y() = - y();
            break;
        case gmcR270:
            d = x();
            x() = y();
            y() = - d;
            break;
        case gmcMY:
            x() = -x();
            break;
        case gmcMYR90:
            d = x();
            x() = - y();
            y() = - d;
            break;
        case gmcMX:
            y() = - y();
            break;
        case gmcMXR90:
            d = x();
            x() = y();
            y() = d;
            break;
    }
}

inline void
gmPointF::transform(gmDouble scale,
                    gmDouble angle)
{
    transform(scale, angle, *this);
}

//////////////////////////////////////////////////////////////////////////////
/// @note   This function get distance of two points
///         d^2 = x^2 + y^2
/// @param  p -- the point #2
/// @return the distance value
//////////////////////////////////////////////////////////////////////////////
inline gmDouble 
gmPointF::distanceFrom2(const gmPointF& p) const
{
    return (xVal - p.x()) * (xVal - p.x()) + (yVal - p.y()) * (yVal - p.y());
}

inline gmPointF 
getMidPoint(const gmPointF& pt1, const gmPointF& pt2)
{
    return gmPointF((pt1.xVal + pt2.xVal)/2.0,(pt1.yVal + pt2.yVal)/2.0 );
}


