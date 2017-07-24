#include "gmHeader.h"

inline gmDouble  
gmVectorFDot(const gmVectorF& v1, const gmVectorF& v2)
{
    // A.B = x1*x2 + y1*y2
	return v1.x()*v2.x() + v1.y()*v2.y();
}

inline gmDouble  
gmVectorFCross(const gmVectorF& v1, const gmVectorF& v2)
{
    // A X B = x1*y2 - x2*y1
    return v1.x()*v2.y() - v1.y()*v2.x();
}

