From: Kurt Garloff <garloff@suse.de>
Subject: Re: New model for managing dev_t's for partitionable block devices
Date: Wed, 29 Jan 2003 19:00:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030129180006.GT12690@E2.suse.de>
References: <OFD9CDB238.908E6C3C-ON87256CBD.00070A30-88256CBD.00095D4B@us.ibm.com> <3E380532.2010900@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpUp1egui7PDlNtH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E380532.2010900@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Douglas Gilbert <dougg@torque.net>, Christoph Hellwig <hch@infradead.org>, Joel Becker <Joel.Becker@oracle.com>, linux-kernel@kernel.vger.org, Linux SCSI list <linux-scsi@vger.kernel.org>


--lpUp1egui7PDlNtH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Wed, Jan 29, 2003 at 09:45:38AM -0700, Steven Dake wrote:
> This is a problem with hotswap of course, and shouldn't be solved by the=
=20
> kernel putting the same device always in the same major/minor.  A=20
> userspace application should query the OS and build the device nodes=20
> based upon scsi serial number, FC port WWN, or access path=20
> (host/channel/id/lun).

scsidev can do exactly this for you.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--lpUp1egui7PDlNtH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+OBamxmLh6hyYd04RAlfpAJ0cFdnOg82sb8sZHDk1vUFCGY5aDwCghavm
OP76m8w/Qr/tkz0y3B5tU5o=
=i6wW
-----END PGP SIGNATURE-----

--lpUp1egui7PDlNtH--
