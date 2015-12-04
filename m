From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Fri, 04 Dec 2015 09:09:32 -0800
Message-ID: <1449248972.27077.7.camel@HansenPartnership.com>
References: <20151201202053.GA4753@glen>
	 <1449097101.2203.67.camel@HansenPartnership.com>
	 <20151203203656.GA9278@glen>
	 <1449176346.2187.19.camel@HansenPartnership.com>
	 <20151203222004.GA22311@glen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-iAX8eb+/9xaLca6k8xg5"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151203222004.GA22311@glen>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org


--=-iAX8eb+/9xaLca6k8xg5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-12-03 at 23:20 +0100, Andrea Gelmini wrote:
> On Thu, Dec 03, 2015 at 12:59:06PM -0800, James Bottomley wrote:
> > sg_map -i
> >=20
> > in your system, you should see something with an inquiry string like
> > enclosure.  It's the /dev/sg<n> of that you need to run sg_ses on.
>=20
> root@glen:/home/gelma# sg_map -i
> /dev/sg0  /dev/sda  ATA       Samsung SSD 850   1B6Q
> /dev/sg1  /dev/sr0  HL-DT-ST  DVDRAM GU40N      QX23
> /dev/sg2  /dev/sdb  WD        My Passport 0820  1007
> /dev/sg3  WD        SES Device        1007
>=20
> And following Douglas' instructions:
>=20
> root@glen:/home/gelma# lsscsi -gs
> [0:0:0:0]    disk    ATA      Samsung SSD 850  1B6Q  /dev/sda   /dev/sg0 =
  1.02TB
> [1:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GU40N     QX23  /dev/sr0   /dev/sg1 =
       -
> [8:0:0:0]    disk    WD       My Passport 0820 1007  /dev/sdb   /dev/sg2 =
  2.00TB
> [8:0:0:1]    enclosu WD       SES Device       1007  -          /dev/sg3 =
     =20
>=20
> root@glen:/home/gelma# sg_ses /dev/sg3
>   WD        SES Device        1007
> Supported diagnostic pages:
>   Supported Diagnostic Pages [sdp] [0x0]
>   Short Enclosure Status (SES) [ses] [0x8]
>   <unknown> [0x80]
>   <unknown> [0x83]
>   <unknown> [0x84]
>   <unknown> [0x85]
>=20
>=20
> Well, if it's better for you, I can give you root access to a machine wit=
h this device
> connected to.

Actually, that would be really helpful, since I only have access to one,
very old, enclosure device.  My ssh key is

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnSsL4HoG8CXrJKA2CDAFJi+Ry8EUYgLluzX+=
zQ21iShnlCelp8djuoe+q+96WX2VGTnxQPJGAYUXNIW+rT9g3g8mgbjLAxYec4AHOgir/LlEBCA=
RHo4SWue9L2if0nl6nLu1PudCQIKM747Pfzj1R4VfWboMU4m6KvkaFgP3rwJkZ96aNHI4ssRDh3=
EXvlD/vix6DZx0T7UEDpD3icc6ZyA2kmymtGCg1+nAWRTWImsnyhRFTIJvVw+xL7iR6GBoIJND8=
2SpzP13Z95owuLm6QGPWow5Xgp3FLgoh+KezU7qXZh17Wh5ANRbgCNZJDc4fDBhXO+oNZmaU8bc=
0AW8R

Thanks,

James


--=-iAX8eb+/9xaLca6k8xg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWYcjMAAoJEDeqqVYsXL0MvQcH/RxnNZUQl/5V72XWsmPmO8AR
tH/L//U6AztS8vSMoyn1nAgXhMODoH0cQEVw1N/aCOJAp/kIyDIJHmLfZV/tw5MN
IWRnuQ61w/K5SRvsEW7st4MK219Ur8i1Qh3DKHkxyJqDEmJLndNtfpuKYT4Q4BYN
3fENluo8K4KTDLj8/AMxJI5w7UUj2kGOoxIROlrNP6sCKk8jkxd2ZChWr/iNad1D
YLeQ8+LMt7tqi9wAzaH+5hLlJ+BoFiwfwBzK/ZAj/+8YQ0Hc04iAYDyp/XXPiiha
tRvRISGolj0Hpa6vSqBAqOF8WiS60JWCYjIITk5GEbqFL1zmoJ5XbA/OexEPavw=
=Q++T
-----END PGP SIGNATURE-----

--=-iAX8eb+/9xaLca6k8xg5--
