From: Kurt Garloff <garloff@suse.de>
Subject: Re: Maximum  disks
Date: Thu, 1 Aug 2002 04:01:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020801020120.GG26560@nbkurt.etpnet.phys.tue.nl>
References: <20020731233404.87984.qmail@web14005.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020731233404.87984.qmail@web14005.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org


--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2002 at 04:34:04PM -0700, Mukul Kotwani wrote:
> If I have more than 8 disks connected, I dont see more
> than 8 at any time. The /proc/partitions shows all 16
> , but if I look in /dev/sd*, I see /dev/sda1-15,
> /dev/sdb1-15 and upto /dev/sdh1-15. But the
> /proc/partitons shows sdi1, sdj1.. as partitions,
> which are not listed in /dev/ at all.

You need to create the device nodes. If your favourite's distributor's
MAKDEVS does not do it, you may need to create the nodes yourself with
mknod. Use major numbers 8,65--71,128--135 for the sd devices.
(Refer to the devices.txt on LANANA.)

Regarsd,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9SJZwxmLh6hyYd04RAuAHAKDOyPwCisdO08FTun6liUGHi2hAjQCguMVR
oMW4HaS7jAXppXHgp00XckU=
=MUKr
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
