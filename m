From: Kurt Garloff <garloff@suse.de>
Subject: Re: Mounting multiple LUNs on a single SCSI device
Date: Thu, 30 May 2002 21:07:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020530210708.A19109@gum01m.etpnet.phys.tue.nl>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com> <1022719300.4124.312.camel@irongate.swansea.linux.org.uk> <3CF5AEA4.4050404@metaparadigm.com> <1022762307.4123.364.camel@irongate.swansea.linux.org.uk> <5.1.0.14.0.20020530102405.01de87f0@adtron.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5.1.0.14.0.20020530102405.01de87f0@adtron.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Dayley <adayley@adtron.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2002 at 10:30:25AM -0700, Alan Dayley wrote:
> I am having problems mounting a second LUN on a dual slot PCMCIA SCSI=20
> device.  I can mount the first LUN by typing mount -t msdos /dev/sda1=20
> /mnt/card.  When I try /dev/sdb1, I rcv a error message stating mount:=20
> /dev/sdb1 is not a valid block device.

Look at the kernel log: Is the second hard drive detected? If yes: Is it
partitioned?
If no: Did you try max_scsi_luns=3D7 boot/module parameter?

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE89nhcxmLh6hyYd04RAsHwAJ4ot1Xyp2t9pmMPc41EU3T6jW1BEQCeOrxh
767lslazatXhyBG50sCD/eA=
=gJtf
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
