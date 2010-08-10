From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Wed, 11 Aug 2010 01:17:33 +1000
Message-ID: <20100811011733.16243ddb.sfr@canb.auug.org.au>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
	<AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
	<20100802233128.GA21286@kroah.com>
	<20100810154337.006a0df9@hyperion.delvare>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Aug_2010_01_17_33_+1000_Zx2XhMZSWJniZd5n"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100810154337.006a0df9@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, James Smart <james.smart@emulex.com>, Eric Biederman <ebiederm@aristanetworks.com>, Benjamin Thery <benjamin.thery@bull.net>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, linuxppc-dev@ozlabs.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Nick Cheng <nick.cheng@areca.com.tw>, Dmitry Torokhov <dtor@mail.ru>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>, Liam Girdwood <lrg@slimlogic.co.uk>, linux-scsi@vger.kernel.org, Alex Iannicelli <alex.iannicelli@emulex.com>, Guenter Roeck <guenter.roeck@ericsson.com>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Wed__11_Aug_2010_01_17_33_+1000_Zx2XhMZSWJniZd5n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, 10 Aug 2010 15:43:37 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> Related bug?
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D16544

Yep, fixed in linux-next today - hopefully the fix is on its way to Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Aug_2010_01_17_33_+1000_Zx2XhMZSWJniZd5n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYW2NAAoJEDMEi1NhKgbsDHoIAKI+LxF3i365ZTQjPgodUhMi
fyVQUKttBZBHDK59URtJ6NlLEUspb7iLiOCqbmu6HSq+7wZsax0/7Kq8FKjD87/s
uko9t9WELvZCtNhQ2PnehUYUOWhO5SCnYgJyzZOCrFZWDpmA3Hl3MSpxNs5drOin
QiKtx2x5ldf03I205RHYDbBy/w1XZegG4fG/M/nTrdzO1B2EfLStYpjY5G49C+Lw
qP120VrFb7BsCs7uHIl9750MV0GHiVfGNpQDcaIGJv5TNPAyvoZhUyC9C0eTQfj6
xHZnf32ihT9Ugrx5qRSpjEaR34atvkQwaZGC+BejZzrfvhl8/3WnAYegvli/zOk=
=Qznw
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Aug_2010_01_17_33_+1000_Zx2XhMZSWJniZd5n--
