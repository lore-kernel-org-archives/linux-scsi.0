From: Steve McIntyre <steve@einval.com>
Subject: Re: Is it possible to support a sector size 8192
Date: Sat, 23 Jul 2005 21:29:42 +0300
Message-ID: <20050723182942.GR27104@einval.com>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <OFC69A050A.B893AF16-ON88257046.007534A8-88257046.00754AFA@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lpbaaqEfWJan1gxl"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:13071 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S262388AbVGWSaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2005 14:30:09 -0400
Content-Disposition: inline
In-Reply-To: <OFC69A050A.B893AF16-ON88257046.007534A8-88257046.00754AFA@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: jhml@gmx.net, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, smcintyre@software.plasmon.com


--lpbaaqEfWJan1gxl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 22, 2005 at 02:21:08PM -0700, Bryan Henderson wrote:
>>we've started shipping a userland filesystem
>>driver for UDO based on FUSE.
>
>How does the userland filesystem driver talk to the device?

Using sg. It works quite well...

--=20
Steve McIntyre, Cambridge, UK.                                steve@einval.=
com
"...In the UNIX world, people tend to interpret `non-technical user'
 as meaning someone who's only ever written one device driver." -- Daniel P=
ead

--lpbaaqEfWJan1gxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC4oyWfDt5cIjHwfcRAlLAAJ4iJxzhabKS8NDXW0BwxmO5XcOezwCdFnmm
xljH32yHK4QbhHVMO4F7jtQ=
=rJlQ
-----END PGP SIGNATURE-----

--lpbaaqEfWJan1gxl--

