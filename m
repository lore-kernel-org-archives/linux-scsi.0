From: Kurt Garloff <garloff@suse.de>
Subject: DC3x5 SCSI driver 1.40 available
Date: Fri, 10 May 2002 22:02:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020510220231.J11690@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DozTQjXnjm3C9Xhk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gum01m.etpnet.phys.tue.nl (gum01m.etpnet.phys.tue.nl [192.168.84.65])
	by etpmod.phys.tue.nl (8.9.3/8.9.3/SuSE Linux 8.9.3-0.1) with ESMTP id WAA21084
	for <linux-scsi@vger.kernel.org>; Fri, 10 May 2002 22:02:31 +0200
Received: (from garloff@localhost)
	by gum01m.etpnet.phys.tue.nl (8.11.6/8.11.6/SuSE Linux 0.5) id g4AK2VJ12791
	for linux-scsi@vger.kernel.org; Fri, 10 May 2002 22:02:31 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--DozTQjXnjm3C9Xhk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I just released the driver 1.40 for Tekram DC3x5 (TRM-S1040) PCI SCSI host
adapter.
It should work on 2.2, 2.4 and 2.5 kernels. Except for the very latest 2.5,
as I still did not convert to new exception handling. But that's high in my
prio list now.
http://www.garloff.de/kurt/linux/dc395/
ftp://ftp.suse.com/pub/people/garloff/linux/dc395/

If you have such a host adapter, please give the driver a try. Please test
it before you rely on it. I occasionally get bug reports that I can't really
fix, because I lack understanding of some details of the chip. (I do not
have any documentation beyond a register list :-() If anybody can advise me
on PCI errors, I would also be grateful ...

Since the last versions, I fixed a number of smaller bugs.

Enjoy!
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--DozTQjXnjm3C9Xhk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE83CdWxmLh6hyYd04RApf+AKCDalJcVIUZUCifiFdWmN4jgq82qQCgjc4T
pRpRkAxLr48VtPCWZ2xsNFY=
=RSkx
-----END PGP SIGNATURE-----

--DozTQjXnjm3C9Xhk--
