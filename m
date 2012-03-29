From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: recent scsi patches causing 2 warnings per compiled
 file
Date: Thu, 29 Mar 2012 14:22:24 +1100
Message-ID: <20120329142224.3fe3ca8d68b580f5ce5b7262@canb.auug.org.au>
References: <CAP=VYLoXHVrFnKyRjG3sSgosqRs69pme9B=8r4H-uwb=3_2XaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Mar_2012_14_22_24_+1100_9ZS+dD6FqV+gf5v+"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAP=VYLoXHVrFnKyRjG3sSgosqRs69pme9B=8r4H-uwb=3_2XaQ@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Thu__29_Mar_2012_14_22_24_+1100_9ZS+dD6FqV+gf5v+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Wed, 28 Mar 2012 20:16:03 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> I just noticed that the alpha (and probably other arch?) are now
> getting two warnings per file compiled, which is kind of ugly.
>=20
> Here is where it transitioned:
>=20
> good: Mar 24:  http://kisskb.ellerman.id.au/kisskb/buildresult/5941020/
>=20
> bad: Mar 26: http://kisskb.ellerman.id.au/kisskb/buildresult/5968296/
>=20
> Screens and screens of these appear:
>=20
> drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM" is not def=
ined
> drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM_MODULE"
> is not defined
>=20
> Missing an include of linux/pm.h or similar, I'd guess.  Can you have
> a look please?

This happens because the affected architectures do not include the pm
Kconfig.  I think it has been fixed today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Mar_2012_14_22_24_+1100_9ZS+dD6FqV+gf5v+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPc9VwAAoJEECxmPOUX5FEF9UP/iNqqGIaYzNp49BQfVhJ4XkA
HFHsZ5Ws9yHnnKVME1sM3XhRMrjze7eX3GE6nCWU06xxXji06c+ouHZ7caXE1tk1
1yOoAJY48ho1jIs2V/23c8kBIMPJVL7i3/tQis82rx5plyt2aC4wFRPbRcOlgTTV
RvgAgetaf8RYLRx7w11jofib9tzrW3hKcD6b6Nu8uVLmL8zozHyVIZJMGvm0qkyV
9/DLDEJ5mqX3nMU5+LZkmrTxpa+rKwC6yxu3qvPkdjh/WcFuAQe6dt6yl7QyuC7B
B8wgXtZJ/kFczxvvaRdQSgAhlTucXCVt1OktGeQo/9OgksRFjlTOhLY/E2pLPsCz
yIsxRZ/uvcuP6vcawZqlTYURANoryxdcfMUrOZ182ELApTD1eovYjBKrAONK3vEc
XrKFbiEckR8KYeZ2PXgj2A4NMz7kQg3ojZu919IA5y/369lkSlQOAuygVa5TPz1/
sv72PQskkpfbD6N2n5YgK6VPnxAHzYiVvAnw6aPz0y4i7N1cMVl1SQcsox0P21a0
RcwcGq59km2xVdjDl8lLDoabl/GERAbaj6LVlrCgt4G1Ee7T5FS+Q7yDIOKju1Y1
0UqQwv3qnqI3FlbcxtAuqv/rbF56pSb84I61XC3gcVVuCHEvVC66oysfTOzVv+PT
wNADaAC+ygzcmRtE2uWt
=4Bhl
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Mar_2012_14_22_24_+1100_9ZS+dD6FqV+gf5v+--
