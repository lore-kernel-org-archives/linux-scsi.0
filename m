From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/6] Remove owner field from sysfs attribute structure
Date: Wed, 11 Aug 2010 01:20:01 +1000
Message-ID: <20100811012001.6fb50655.sfr@canb.auug.org.au>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
	<AANLkTinM+m15QbAg+J3YyHWnObsxtHYYU6p6C89p8wjp@mail.gmail.com>
	<20100802233128.GA21286@kroah.com>
	<20100810154337.006a0df9@hyperion.delvare>
	<20100811011733.16243ddb.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Aug_2010_01_20_01_+1000_p628nrvSadM=jkIG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:47538 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0HJPUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 11:20:08 -0400
In-Reply-To: <20100811011733.16243ddb.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Jani Nikula <ext-jani.1.nikula@nokia.com>, Linus Walleij <linus.walleij@stericsson.com>, James Smart <james.smart@emulex.com>, Eric Biederman <ebiederm@aristanetworks.com>, Benjamin Thery <benjamin.thery@bull.net>, Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, linuxppc-dev@ozlabs.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Richard Purdie <rpurdie@rpsys.net>, Nick Cheng <nick.cheng@areca.com.tw>, Dmitry Torokhov <dtor@mail.ru>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@samba.org>, Liam Girdwood <lrg@slimlogic.co.uk>, linux-scsi@vger.kernel.org, Alex Iannicelli <alex.iannicelli@emulex.com>, Guenter Roeck <guenter.roeck@ericsson.com>, David Woodhouse <David.Woodhouse@intel.com>

--Signature=_Wed__11_Aug_2010_01_20_01_+1000_p628nrvSadM=jkIG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Wed, 11 Aug 2010 01:17:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 10 Aug 2010 15:43:37 +0200 Jean Delvare <khali@linux-fr.org> wrot=
e:
> >
> > Related bug?
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D16544
>=20
> Yep, fixed in linux-next today - hopefully the fix is on its way to Linus.

Sorry, more info:

Fixed by commit 690e85a3957291f4cfe0cac22d97994ec7e5ee45 ("olpc_battery:
Fix build failure caused by sysfs changes") from the battery tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Aug_2010_01_20_01_+1000_p628nrvSadM=jkIG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYW4hAAoJEDMEi1NhKgbsGMgIAIZxDAUh17iEyQwHYE64/aJV
OEP/MbMbHFwhFIcmUqv0lPpMJnPN1FmJbPg0vVjtMJlmp+BQxtLCXD4bwd8IE8mz
uIImBQ8eALRAIKoXAN2mr9ezYzJ4zxvHhPg1lkN9nRKnaHYoQoAOaaD9Xv83QH/Z
badkXo0KNXHeP7aUv67+u5g7yaNO5eec4kLaaBL520s/IZWCNKSYK/ofN4HE5Hd/
QSGgfYYHGtBjpMwaF+ssYpEN7AB0dni+mYoGB9eRvxlCLaQYKTJoop+3UQDe/sAy
bHrI1fbbcMul3Fsd0sDjYV2TQ3Uin3WJbTT3u1DiCP4PV1OZMbyYSgctIcPnv0k=
=IGCR
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Aug_2010_01_20_01_+1000_p628nrvSadM=jkIG--
