// I2C device class (I2Cdev) demonstration Arduino sketch for MPU6050 class, 3D math helper
// 6/5/2012 by Jeff Rowberg <jeff@rowberg.net>
// Updates should (hopefully) always be available at https://github.com/jrowberg/i2cdevlib
//
// Changelog:
//     2012-06-05 - add 3D math helper file to DMP6 example sketch
//     2015-04-09 - add more function including rotating from north frame to body frame. by Jianqiu <jm838@kent.ac.uk>
//     2015-05-08 - change the class as template class, and add array so that the data can be read from either e.g. q.w or q.data[0] by Jianqiu <jm838@kent.ac.uk>


/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2012 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/

#ifndef _VECTORQUATERNION_H_
#define _VECTORQUATERNION_H_

template <class vq_type> class Quaternion {
    public:
		union{
			struct{
				vq_type w;
				vq_type x;
				vq_type y;
				vq_type z;
			};
			vq_type data[4];
		};
        
        Quaternion() {
			w=1.0;
			x=0.0;
			y=0.0;
			z=0.0;
        }
        
		Quaternion(vq_type dp[4]) {
			for(int i=0;i<4;i++) data[i]=dp[i];
        }

        Quaternion(vq_type nw, vq_type nx, vq_type ny, vq_type nz) {
			w=nw;
			x=nx;
			y=ny;
			z=nz;
        }

		void getData(vq_type dp[4]){
			for(int i=0;i<4;i++) data[i]=dp[i];
		}

        Quaternion<vq_type> getProduct(Quaternion<vq_type> q) {
            // Quaternion multiplication is defined by:
            //     (Q1 * Q2).w = (w1w2 - x1x2 - y1y2 - z1z2)
            //     (Q1 * Q2).x = (w1x2 + x1w2 + y1z2 - z1y2)
            //     (Q1 * Q2).y = (w1y2 - x1z2 + y1w2 + z1x2)
            //     (Q1 * Q2).z = (w1z2 + x1y2 - y1x2 + z1w2
            return Quaternion<vq_type>(
                w*q.w - x*q.x - y*q.y - z*q.z,  // new w
                w*q.x + x*q.w + y*q.z - z*q.y,  // new x
                w*q.y - x*q.z + y*q.w + z*q.x,  // new y
                w*q.z + x*q.y - y*q.x + z*q.w); // new z
        }

        Quaternion<vq_type> getConjugate() {
            Quaternion<vq_type> r(w, -x, -y, -z);
			return r;
        }
        
        vq_type getMagnitude() {
            return sqrt(w*w + x*x + y*y + z*z);
        }
        
        void normalize() {
            vq_type m = getMagnitude();
            w /= m;
            x /= m;
            y /= m;
            z /= m;
        }
        
        Quaternion<vq_type> getNormalized() {
            Quaternion<vq_type> r(w, x, y, z);
            r.normalize();
            return r;
        }
};

template <class vq_type> class vectorJMu {
    public:
		union {
			struct{
				vq_type x;
				vq_type y;
				vq_type z;
			};
			vq_type data[3];
		};

        vectorJMu() {
			for(int i=0;i<3;i++) data[i]=0.0;
        }
        
		vectorJMu(vq_type dp[3]) {
            for(int i=0;i<3;i++) data[i]=dp[i];
        }

        vectorJMu(vq_type nx, vq_type ny, vq_type nz) {
			x=nx;
			y=ny;
			z=nz;
        }

		void getData(vq_type dp[3]){
			for(int i=0;i<3;i++) data[i]=dp[i];
		}

        vq_type getMagnitude() {
            return sqrt(x*x + y*y + z*z);
        }

        void normalize() {
            vq_type m = getMagnitude();
			if(m!=0){
				x /= m;
				y /= m;
				z /= m;
			}else{
				x = 0.0;
				y = 0.0;
				z = 0.0;
			}
        }
        
        vectorJMu getNormalized() {
            vectorJMu<vq_type> r(x, y, z);
            r.normalize();
            return r;
        }
        
		vq_type getdotProduct(vectorJMu<vq_type> v) {
			vq_type dp=x*v.x+y*v.y+z*v.z;
			return dp;
		}
		
		void crossProduct(vectorJMu<vq_type> v) {
			vectorJMu<vq_type> vr(x,y,z);
			x=vr.y*v.z-vr.z*v.y;
			y=vr.z*v.x-vr.x*v.z;
			z=vr.x*v.y-vr.y*v.x;
		}
		
		vectorJMu getcrossProduct(vectorJMu<vq_type> v){
			vectorJMu<vq_type> r(x,y,z);
			r.crossProduct(v);
			return r;
		}
		
		Quaternion<vq_type> getQuater_v(vectorJMu<vq_type> v){
			Quaternion<vq_type> qr;
			vectorJMu<vq_type> vr(x,y,z);
			vr.normalize();
			vq_type dot=vr.getdotProduct(v.getNormalized());
			if (dot!=-1){
				vr.crossProduct(v.getNormalized());
				qr.x=vr.x;
				qr.y=vr.y;
				qr.z=vr.z;
				qr.w=1+dot;
				qr.normalize();
			}else{
				qr.x=abs(vr.x);
				qr.y=abs(vr.y);
				qr.z=abs(vr.z);
				qr.w=0;
			}
			return qr;			
		}
		
        void rotate(Quaternion<vq_type> *q) {
            Quaternion<vq_type> p(0, x, y, z);
			
            // quaternion multiplication: q * p, stored back in p
            p = q -> getProduct(p);

            // quaternion multiplication: p * conj(q), stored back in p
            p = p.getProduct(q -> getConjugate());

            // p quaternion is now [0, x', y', z']
            x = p.x;
            y = p.y;
            z = p.z;
        }

        vectorJMu getRotated(Quaternion<vq_type> *q) {
            vectorJMu<vq_type> r(x, y, z);
            r.rotate(q);
            return r;
        }
		
		void rotateNtb(Quaternion<vq_type> *q) {
            Quaternion<vq_type> p(0, x, y, z);
			Quaternion<vq_type> dp;
            // quaternion multiplication: q * p, stored back in p
            dp = q -> getConjugate();
			p = dp.getProduct(p);
            // quaternion multiplication: p * conj(q), stored back in p
            p = p.getProduct(dp.getConjugate());

            // p quaternion is now [0, x', y', z']
            x = p.x;
            y = p.y;
            z = p.z;
        }

        vectorJMu<vq_type> getRotatedNtb(Quaternion<vq_type> *q) {
            vectorJMu<vq_type> r(x, y, z);
            r.rotateNtb(q);
            return r;
        }
};
#endif /* _VECTORQUATER_H_ end */