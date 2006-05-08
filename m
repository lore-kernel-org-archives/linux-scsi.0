From: Alexander Gran <alex@zodiac.dnsalias.org>
Subject: reiser4 bug [was Re: 2.6.17-rc3-mm1]
Date: Mon, 8 May 2006 22:46:49 +0200
Message-ID: <200605082246.50332@zodiac.zodiac.dnsalias.org>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net> <445F64E2.3000902@dgreaves.com> <Pine.LNX.4.61.0605082214581.20743@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5390710.z7rVPEToxi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <reiserfs-list-return-28592-reiserfs=m.gmane.org@namesys.com>
list-help: <mailto:reiserfs-list-help@namesys.com>
list-unsubscribe: <mailto:reiserfs-list-unsubscribe@namesys.com>
list-post: <mailto:reiserfs-list@namesys.com>
Errors-To: flx@namesys.com
In-Reply-To: <Pine.LNX.4.61.0605082214581.20743@yvahk01.tjqt.qr>
To: Andrew Morton <akpm@osdl.org>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-list@namesys.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--nextPart5390710.z7rVPEToxi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

2.6.17-rc3-mm1 doesn't get up running  here, it bugs around while init runs:
I cannot login afterwards, and syslog did not get the bug too. So here are=
=20
some poor screenshots from my Treo650 (digicam is broken, sorry..;)
EIP is in clear_inode.
Trace:
reiser4_delete_inode+0x6c/0xd0
d_delete+0xf0/0x10f
reiser4_delete_inode+0x0/0xd0
generic_delete_inode+0x6b/0xfb
input+0x5c/0x68
do_unlikat+0xd7/0x12c
sysenter_past_esp+0x54/0x75
__hidp_send_ctrl_message+0xb4/0xfa
details:
http://zodiac.dnsalias.org/images/1.jpg
http://zodiac.dnsalias.org/images/2.jpg
http://zodiac.dnsalias.org/images/3.jpg
http://zodiac.dnsalias.org/images/4.jpg
Kernel config:
http://zodiac.dnsalias.org/images/config
System is my T40p, as usual. running an up2date debian unstable.

regards
Alex

--nextPart5390710.z7rVPEToxi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBEX646/aHb+2190pERArLrAKCZHw4d54UmacIuXocnACHDfz2gLQCgsHSv
vB/3Cr8ZShGqvM1MVumlJfc=
=Twk0
-----END PGP SIGNATURE-----

--nextPart5390710.z7rVPEToxi--
