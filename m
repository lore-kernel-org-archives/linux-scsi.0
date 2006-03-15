From: Michael Stuebiger <Michael.Stuebiger@rz.ifi.lmu.de>
Subject: Re: QLA Driver Error on boot
Date: Wed, 15 Mar 2006 18:11:34 +0100
Message-ID: <200603151811.41341.Michael.Stuebiger@rz.ifi.lmu.de>
References: <200603151653.05839.Michael.Stuebiger@rz.ifi.lmu.de> <20060315162234.GD1290@andrew-vasquezs-powerbook-g4-15.local> <20060315163032.GE1290@andrew-vasquezs-powerbook-g4-15.local>
Reply-To: Michael.Stuebiger@rz.ifi.lmu.de
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3366844.21DQxs8BeF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kokytos.rz.ifi.lmu.de ([141.84.214.13]:32932 "EHLO
	kokytos.rz.ifi.lmu.de") by vger.kernel.org with ESMTP
	id S1750710AbWCORLr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 12:11:47 -0500
In-Reply-To: <20060315163032.GE1290@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

--nextPart3366844.21DQxs8BeF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello!

> > This looks like a soft-lockup backtrace occuring during mbx command
> > completion polling.  This issue was addressed post-2.6.15:
> >=20
> > [SCSI] qla2xxx: Use msleep() as delay during ISP polling.
> > http://gitlnx/cgi-bin/gitweb.cgi?p=3Davasquez/qla2xxx-upstream.git;a=3D=
commitdiff;h=3D03ab2eabed74708c0c74163723007e8e72244219;hp=3De038a1be22bef9=
0795c5239d1563609b89c3aa18
>=20
> And a link to a local repository certainly won't help.  Here's the
> info from kernel.org:
>=20
> http://www.kernel.org/git/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=
=3Dcommitdiff;h=3D03ab2eabed74708c0c74163723007e8e72244219

Thanks for the quick response.
I'll try the patch ^_^

> --
> AV

Sincerely Yours
Michael St=FCbiger

=2D-=20
| Dipl. Inf. Michael St=FCbiger                   Michael.Stuebiger at rz.i=
fi.lmu.de |
| Ludwig-Maximilians-Universitaet Muenchen                                 =
        |
| Institut fuer Informatik                Zimmer Z 9      Tel: 2180-9137   =
        |

--nextPart3366844.21DQxs8BeF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBEGErNDzdO5UXqxjARAt9HAJ99YFE4XKCcqCb+y+bWXGoSizkgKgCgiWjN
uyhzl4093SStwWfmlKzCpWo=
=dBT5
-----END PGP SIGNATURE-----

--nextPart3366844.21DQxs8BeF--
