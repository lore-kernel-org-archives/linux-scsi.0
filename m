From: Kurt Garloff <garloff@suse.de>
Subject: scsidev-2.30 released
Date: Mon, 11 Aug 2003 02:50:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811005050.GL2543@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="egxrhndXibJAPJ54"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([213.95.15.193]:40465 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S270805AbTHKAw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2003 20:52:29 -0400
Received: from Hermes.suse.de (Hermes.suse.de [213.95.15.136])
	by Cantor.suse.de (Postfix) with ESMTP id 1BA6C14EC7
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2003 02:50:51 +0200 (MEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--egxrhndXibJAPJ54
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

scsidev 2.30 has been released.
http://www.garloff.de/kurt/linux/scsidev/

scsidev provides persistent device names for SCSI devices.
Standard naming for scsidev is the HCIL tuple that identifies a path
to the device, but the device can be inquired for serial number, WWIDs
or (new) HSV_OS_ID and alias names based on this information providing
persistent names in case of path changes.

New in 2.30:
* HSV devices are detected and HSV_OS_IDs retrieved. They can be used=20
  to build aliases (Contributed by Evans Felix, PNL).
* The old name for sr devices can be switched to scd (despite being sys-
  tematically illogical, it seems to be preferred by devices.txt and by
  some distributors). Option -o=20
* Support for kernel 2.6: Instead of using the extended /proc/scsi/scsi=20
  information from the scsi-many patches, we use sysfs to gather infor-
  mation about which path corresponds to which device.
  Unfortunately, this is currently only available for block devices
  (sr, sd), but not for sg. So, some guesswork is needed again :-(

Are there any plans to get the char devs supported well in sysfs?=20

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--egxrhndXibJAPJ54
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/NuhqxmLh6hyYd04RAgIwAKDNEChfkZmQxYWmYAL7vnBbohMciQCgjthF
33pWtZONAyj3JsshP4MjvG0=
=CTwo
-----END PGP SIGNATURE-----

--egxrhndXibJAPJ54--
