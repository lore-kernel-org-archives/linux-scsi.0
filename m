From: Kurt Garloff <garloff@suse.de>
Subject: tmscsim (AM53C974) SCSI driver & 2.5
Date: Fri, 10 May 2002 22:05:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020510220518.K11690@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpocKf6TCvdC9BKE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gum01m.etpnet.phys.tue.nl (gum01m.etpnet.phys.tue.nl [192.168.84.65])
	by etpmod.phys.tue.nl (8.9.3/8.9.3/SuSE Linux 8.9.3-0.1) with ESMTP id WAA21225
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2002 22:05:18 +0200
Received: (from garloff@localhost)
	by gum01m.etpnet.phys.tue.nl (8.11.6/8.11.6/SuSE Linux 0.5) id g4AK5Ix12818
	for linux-scsi@vger.kernel.org; Fri, 10 May 2002 22:05:18 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--PpocKf6TCvdC9BKE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

The tmscsim (Tekram DC390/AM53C974) PCI SCSI driver does not work in 2.5 for
two reasons:
(1) Does not use pci_map_X() interface
(2) Does still use old exception handling

Fixing (1) is easy for me as I have done the same conversion for the DC3x5
driver. New EH takes somewhat more time, I'm afraid.
I just wonder why nobody complained to me, so far:
Is anybody using this driver?

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--PpocKf6TCvdC9BKE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE83Cf9xmLh6hyYd04RAnm8AJwNeuM6iIuV5avVaq9p0hYfJDQv6ACeLE4F
GtT4YBNzHn2PgNy8zuIRVUM=
=MkR/
-----END PGP SIGNATURE-----

--PpocKf6TCvdC9BKE--
