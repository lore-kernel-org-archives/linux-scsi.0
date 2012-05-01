From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: pull request: linux-firmware: Update qla2xxx firmware files.
Date: Tue, 01 May 2012 02:48:36 +0100
Message-ID: <1335836916.8274.50.camel@deadeye>
References: <alpine.WNT.2.00.1204271521300.1704@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JzWXQgJpq9gaE4wlFE3B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45912 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757762Ab2EABsq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 21:48:46 -0400
In-Reply-To: <alpine.WNT.2.00.1204271521300.1704@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: dwmw2@infradead.org, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org


--=-JzWXQgJpq9gaE4wlFE3B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-04-27 at 15:41 -0400, Chad Dupuis wrote:
> Hi Ben, David,
>=20
> Can you please pull the following patches from the "for_upstream" branch
> of the repo below to update the ql2300_fw.bin, ql2322_fw.bin,
> ql2400_fw.bin and ql2500_fw.bin files?
>=20
> git://avgit01.qlogic.org/linux-firmware for_upstream

That hostname isn't resolvable here and now.

Ben.

> Chad Dupuis (4):
>    qla2xxx: Update ql2300_fw.bin to version 3.03.28.
>    qla2xxx: Update ql2322_fw.bin to version 3.03.28.
>    qla2xxx: Update ql2400_fw.bin to version 5.06.05.
>    qla2xxx: Update ql2500_fw.bin to version 5.06.05.
>=20
>   WHENCE        |    8 ++++----
>   ql2300_fw.bin |  Bin 123170 -> 125252 bytes
>   ql2322_fw.bin |  Bin 132978 -> 136038 bytes
>   ql2400_fw.bin |  Bin 228056 -> 255320 bytes
>   ql2500_fw.bin |  Bin 199776 -> 252636 bytes
>   5 files changed, 4 insertions(+), 4 deletions(-)
>=20
> Thanks,
> Chad
>=20
> This message and any attached documents contain information from QLogic C=
orporation or its wholly-owned subsidiaries that may be confidential. If yo=
u are not the intended recipient, you may not read, copy, distribute, or us=
e this information. If you have received this transmission in error, please=
 notify the sender immediately by reply e-mail and then delete this message=
.
>=20
>=20

--=20
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.

--=-JzWXQgJpq9gaE4wlFE3B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT59A9Oe/yOyVhhEJAQrDqg/+OATiOHZZwspqYlrjlfvEn/IdbRE33pT1
WNDp0R0s7jqzKliyPO+drNX7nNIttZbKKXDwg96aCQN3LXIyp4laXqb6/nfIs4gA
ubM6GCk9pH6DljbYpsfw5doj5QnzzHJkmCDwP6ulKp0x3cqcNPxd63OwZ2PYoTLp
AWybPjAcN0Po7Lv/sE8CQWAE2hH4xvv9SE1wlGjZFovyN1ypgQ4OJDMe37ItHnSs
vp55Qo1ekKQDqg4xNL1HzLyWbbvI4AxfVNRsoBAa2DvnTpf2vq2So5Vg2CRdCt7V
nuEsR963QmsQQ+u3pmmjytDwmrvuLUCz8cidhAdWx3Sg6txCXyP0czhTnHL8TXIj
DOv4vewZnAD6AEn8PnweYMA+znh3xIOv2AVDfeqWAMQO1GleFLCvatyzR/5yngFf
yLSDejIuUajdPlslCVwtxNliPSKiFxWS+Q337LhJw3hBH0RzqpPWpnWFwjNZdrVu
Hmbrxi9rrNPQLesJ3ZWf0U+reg4+G1sLymadiT7C4Q9N5lvPemNBhfcWP3yJCUSU
R1pgX6Ps7sVJh+VShRs6PVenWcD+ynNsjOba0i6VQuTG3dxm6DxF1553HsQjsmQe
K04NqQG0JTKYul731H+ar0vgDa0Nqa5SpvFQgsm1q7PTTt2tFMpqIqaxGqqgYGL8
EJiIwujbB9s=
=9Vbn
-----END PGP SIGNATURE-----

--=-JzWXQgJpq9gaE4wlFE3B--
