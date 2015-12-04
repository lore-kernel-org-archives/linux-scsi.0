From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Fri, 04 Dec 2015 11:04:07 -0800
Message-ID: <1449255847.27077.8.camel@HansenPartnership.com>
References: <20151201202053.GA4753@glen>
	 <1449097101.2203.67.camel@HansenPartnership.com>
	 <20151203203656.GA9278@glen>
	 <1449176346.2187.19.camel@HansenPartnership.com>
	 <20151203222004.GA22311@glen>
	 <1449248972.27077.7.camel@HansenPartnership.com>
	 <20151204174616.GA28160@glen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-WOVb+VOibuueWwXNYlCF"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151204174616.GA28160@glen>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org


--=-WOVb+VOibuueWwXNYlCF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-12-04 at 18:46 +0100, Andrea Gelmini wrote:
> On Fri, Dec 04, 2015 at 09:09:32AM -0800, James Bottomley wrote:
> > Actually, that would be really helpful, since I only have access to one=
,
> > very old, enclosure device.  My ssh key is
>=20
> Ok.
> Do you need same PC/Kernel of the report, or is it enough if I plug the U=
SB in any PC and give you access?

I think, since we suspect the device, it's enough to plug it into any PC
running a current kernel.

Thanks,

James


--=-WOVb+VOibuueWwXNYlCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWYeOnAAoJEDeqqVYsXL0Mj1AIALtAXM9xr/8uEMjF4OgYcM4f
ttZd1zYECnaIE84A/TNkI7xHTk10WCKI7ILXBNL9STrKRIqLAAdUx5euGIBL2ELK
lAbhvUEad799m1xWgKUUWsqC4L+B/XryqXa9AYc/C7uIr02UM72sRNeU7TY+k6MN
J42GpUnqsxzS7XdtCW8sr7k+EZnaxL97RRJgmLKAsCl8dUXF7TNMDQCQcPacUK4o
bnf3SxF4F1ucJc+vVknQ0POnDrl8I3xxMx7n9U8reokTmm4e1fRv9MdyOoLilP80
vOTRsa+05X6TA04JpxAlwGTbYvs0clT7vPXuORl5Du3lADWpAcWbvvNjSKi9Ckk=
=f1iv
-----END PGP SIGNATURE-----

--=-WOVb+VOibuueWwXNYlCF--
