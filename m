From: Kurt Garloff <garloff@suse.de>
Subject: [ANN] scsidev-2.25
Date: Tue, 30 Jul 2002 14:43:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730124347.GD1499@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nbkurt.casa-etp.nl (nbkurt.casa-etp.nl [192.168.157.3])
	by etpmod.phys.tue.nl (8.9.3/8.9.3/SuSE Linux 8.9.3-0.1) with ESMTP id OAA17498
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2002 14:43:49 +0200
Received: (from garloff@localhost)
	by nbkurt.casa-etp.nl (8.11.6/8.11.6/SuSE Linux 0.5) id g6UChmV02090
	for linux-scsi@vger.kernel.org; Tue, 30 Jul 2002 14:43:48 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I jsut released scsidev-2.25.

scsidev does provide names for your SCSI device nodes based on the
CBTU/HCIL tuple and optionally on meta information such as serial
numbers, wwids, or just the std. INQUIRY information. It also=20
handles permissions of those files by removing non-attached device
nodes, but backing their permissions up.

New in 2.25 (compared to 2.22):
* Major cleanup
* WWID support
* Sane handling of permissions by using .shadow. files
  (instead of the nonsensical minor=3D255 stuff)
* now parses /proc files (partitions, ioports, ...) to collect
  information
* Uses the /proc/scsi/scsi extensions if present: if they are, we can:
  - Support many disks (more than 256)
  - Provide reliable information [1]
  - Work much faster

http://www.garloff.de/kurt/linux/scsidev/
ftp://ftp.suse.com/pub/people/garloff/linux/scsidev/


[1] As discussed before, you can't get reliable mapping between sg and
 and other high-level drivers. Unfortunately, you can't just open other
 dev nodes to send down ioctls, as the open may block (think removable
 media) or has side effects (think tapes).
 Hopefully, driverfs will provide all the info needed one day.=20
 For 2.4 we need one of the patches from my sd-many collection.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9RooDxmLh6hyYd04RApbvAJ0d8bEmpnNJ3R7E/I97Ffxbty7zAQCguecQ
64pejrszD7s0shYEuWAyUzE=
=t0QP
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
