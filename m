From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Additional BLIST_LARGELUN devices
Date: Thu, 27 Jun 2002 00:07:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020626220724.GH4818@gum01m.etpnet.phys.tue.nl>
References: <20020626164744.GH3023@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ecMC0kzqsE2ddMN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020626164744.GH3023@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>, Dave Jones <davej@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>


--3ecMC0kzqsE2ddMN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

sorry to follow up myself:

On Wed, Jun 26, 2002 at 06:47:44PM +0200, Kurt Garloff wrote:
> Hi Marcello, Dave,
>=20
> here are some additional devices that need the BLIST_LARGELUN flag.
> When I sent the patch to implement the flag, I only knew about the EMC
> Symmetrix. Some more have turned up ...

A related question: It might be useful to such a flag at the kernel command
line. Like a "largelun=3Dc2b0t9" parameter. Would people consider this usef=
ul?
Would it be accepted into the std. kernel? If yes=B2, I can code a patch ...

Regards.
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--3ecMC0kzqsE2ddMN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9GjscxmLh6hyYd04RAmVKAJ9nuZ/26nchcHPHLsc2idkL/16TZgCg1Soz
aTReomSKfZzQSv6ads1haLE=
=6+VK
-----END PGP SIGNATURE-----

--3ecMC0kzqsE2ddMN--
