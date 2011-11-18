From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] bfa: dereferencing freed memory in bfad_im_probe()
Date: Fri, 18 Nov 2011 16:55:29 +0300
Message-ID: <20111118135528.GI29436@mwanda>
References: <20110729085306.GH3752@shale.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l0l+eSofNeLXHSnY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:28367 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab1KRNyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2011 08:54:17 -0500
Content-Disposition: inline
In-Reply-To: <20110729085306.GH3752@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org


--l0l+eSofNeLXHSnY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2011 at 11:53:06AM +0300, Dan Carpenter wrote:
> If bfad_thread_workq(bfad) was not BFA_STATUS_OK then we freed "im"
> and then dereferenced it.
>=20
> I did a little clean up because it seemed nicer to return directly
> instead of doing a superfluous goto.  I looked at other functions in
> this file and it seems like returning directly is standard.
>=20
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Ping.

regards,
dan carpenter


--l0l+eSofNeLXHSnY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxmPQAAoJEOnZkXI/YHqR5CIP/29HsqK/v5RoS+9SDfXCR8Vv
A2TdX3bhNGXrjAv8zhm0nFAGaez5QHd5DkCCb6ep0MJtZx/qHym7CN24iLI8tSwA
dLB81fSTpXLb9vHrftpN4g3bANFGN3z36v93JHt8IBZOjQ0WOHjfijAfzJlaZ2bd
Hr+UvezKhBJit3hnDqa+6OjAOv5vTWGDQadcSbXfcp9oeGnFRo481ADHJQQosIiC
+Q7SyaMmykeLjDOmXaOe/8IMlrsCCyYIBkMrg5uMoPHtMysStVV6AjxcU3eT48tv
dgiWTYT6FsMN/vIbENhp5xs0toT8/foDjpaao4vLvr2r4oMgZ8JS00SP3oUTzQb+
sTJDV8PXW/LPJM2VRVPX1yZIqadnLU+DopFJSiHJE1/Pdhs+jqPYwJX7NrWWpuBb
ncc1PfsL1JyTUGkf3CHClgGgkMES/KuP6RRUJVC9ikrDlr+eu0VgHZJVOoMEAw7E
/Vjd5O3ci8IIsslWm92fTuiDe7hciB4I00zsXtS8e3LFJSkGb9v3Dz+80oCwrvEn
0dfzzdHQFq9I9qBnN6XSEVJwGs1t0LNkltlHpjKdP/t0E6XGF/8ZLlXbUoF7TlGw
UqMBbuCcYgBPd3gDx7mfYzCvKQKp2YQnGh898HsRbo4qTUxC0dCM5s0v2AKIlZBI
FPGS2CKZYOKrdfJVIGt8
=dBUm
-----END PGP SIGNATURE-----

--l0l+eSofNeLXHSnY--
