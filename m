From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] Midlayer initiated START_UNIT
Date: Tue, 17 Feb 2004 00:04:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217080446.GA23112@one-eyed-alien.net>
References: <401985E6.8060603@us.ibm.com> <00e301c3f528$b0ba4440$7d074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:10438 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261909AbUBQIEv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 03:04:51 -0500
Content-Disposition: inline
In-Reply-To: <00e301c3f528$b0ba4440$7d074d0a@apac.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>
Cc: linux-scsi@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Umm... I hope that the issuing of START_UNIT will only occur in very
narrowly defined cases.

If you just issue START_UNIT semi-arbitrarily, you'll break most USB
devices.

Matt

On Tue, Feb 17, 2004 at 01:06:00PM +0530, Sachin Mhatre (smhatre) wrote:
> Has this patch been included in the linux 2.6.X kernel? This patch would
> also help the iscsi LLDD as it is also facing the same START_UNIT
> problem.
> I would really appreciate any help on this matter.
>=20
> Thanks,
> Sachin
>=20
>=20
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Brian King
> Sent: Friday, January 30, 2004 3:45 AM
> To: James.Bottomley@steeleye.com
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] Midlayer initiated START_UNIT
>=20
>=20
> James,
>=20
> This is a patch to issue a START_UNIT command from the midlayer error
> handler. The ipr driver, which is currently out for review needs this to
> function properly. Any time the adapter gets reset, the disk array
> resources under the ipr adapter require another START_UNIT command. This
> causes problems with the current error handling and these devices get
> taken offline when this occurs.
>=20
> This was being handled by the ipr driver itself, but Christoph did not
> like seeing a LLDD issuing commands to devices, hence the patch.
>=20
> http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D107462193622673&w=3D2
>=20
> Patch is against 2.6.2-rc2.
>=20
> Thanks
>=20
>=20
>=20
> --=20
> Brian King
> eServer Storage I/O
> IBM Linux Technology Center
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm a pink gumdrop! How can anything be worse?!!
					-- Erwin
User Friendly, 10/4/1998

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAMcseIjReC7bSPZARAlLBAJ9Utq7AYQZTXk9lVAcgP7t8SePiJQCg1AUR
OBzGDFzfOSCM2hw/qtl2pEc=
=6nUE
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
