From: Kurt Garloff <garloff@suse.de>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Tue, 9 Apr 2002 02:48:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020409024832.F24465@gum01m.etpnet.phys.tue.nl>
References: <20020408091844.L7333@austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CEUtFxTsmBsHRLs3"
Content-Disposition: inline
In-Reply-To: <20020408091844.L7333@austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: sullivan <sullivan@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org


--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

just reading this discussion, I hope you all are aware of scsidev, which
provides some of the functionality needed.
Apart from allowing you to specify devces according to the bus topology
(just as devfs does), it also allows for aliases, based on various things,
such as names, device types, model or serial numbers (got from INQUIRY
with page code 0x80).
It may miss some mechanisms to deal with devices without this serial no,
e.g., but in general I do not really see why it would not be useable.
http://www.garloff.de/kurt/linux/scsidev/

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--CEUtFxTsmBsHRLs3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE8sjpfxmLh6hyYd04RAlECAKDN5FYGtuFiiIQLAdvnl4skYSOiZgCfaMgO
ZeNxOFe4hParYBjzB5aQjmU=
=btYs
-----END PGP SIGNATURE-----

--CEUtFxTsmBsHRLs3--
