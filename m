From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [ANNOUNCE]: megaraid driver version 2.20.0.1, now 2.20.2.0
Date: Tue, 27 Jul 2004 17:38:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040727223823.GA2485@lists.us.dell.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC8B1@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:26787 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266683AbUG0Wio
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 18:38:44 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC8B1@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 23, 2004 at 06:02:49PM -0400, Mukker, Atul wrote:
> All,
>=20
> Here is the patch for the 2.20.2.0 as per suggestions made by James
> Bottomley. The details are available in the changelog. As usual, the driv=
er
> package with kernel patches, complete driver code, and this patch is
> available for download from
> ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.2.0/ as well.


Something else to clean up after inclusion: every instance of an
inline function is actually rendered as a full function call, because
the function is always used before it is defined.  Atul, please
re-arrange the code to eliminate the need for most (all) of the
function prototypes at the top of each file, and define (not just
declare with a prototype) each inline function before its first use.

Thanks,
Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBBtlfIavu95Lw/AkRAjQ6AJ4/Feyq+lEowzeRT48IeFtXgq2PMQCeJg+C
U8dNMYMFrgV86cRMdkQSsRE=
=tI8p
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
