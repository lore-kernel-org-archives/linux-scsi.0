From: Kurt Garloff <garloff@suse.de>
Subject: scsidev-2.29
Date: Wed, 9 Jul 2003 21:42:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030709194233.GY10137@nbkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJKqlw44nclc26Ih"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([213.95.15.193]:22286 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266107AbTGIT1z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2003 15:27:55 -0400
Received: from Hermes.suse.de (Hermes.suse.de [213.95.15.136])
	by Cantor.suse.de (Postfix) with ESMTP id A7D96146DC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2003 21:42:33 +0200 (MEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--IJKqlw44nclc26Ih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

scsidev-2.29 has been released
http://www.garloff.de/kurt/linux/scsidev/

A few bugs have been fixed, most notably the robustness against
unexpected responses (empty controller names ...) and a file
descriptor leak.

scsidev can be used to dynamically create device nodes for SCSI devices,
providing means to handle permissions and to create names based on the
topology of the attachment (path). Optionally, names (aliases) depending
on WWIDs or serial numbers can be created, thus providing really
persistent names.

Currently, scsidev does use the information it reads form /proc/scsi
(including the enhancements from the scsi-many patches, if available),
/proc/partitions and the ones it gains from ioctls on the devices to
collect the information. For 2.5 it should use sysfs, but this has not
yet been implemented. (Volunteers?)

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--IJKqlw44nclc26Ih
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2-rc1-SuSE (GNU/Linux)

iD8DBQE/DHAoxmLh6hyYd04RAkjvAKCAHmNbathw9Vyss0WD6c7mQNAWOACeMWZG
mlPvahi0Q0Gg8keE6dD5HZM=
=n3E9
-----END PGP SIGNATURE-----

--IJKqlw44nclc26Ih--
