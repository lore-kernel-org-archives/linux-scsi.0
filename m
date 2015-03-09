From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/5] Rename regulator_set_optimum_mode
Date: Mon, 9 Mar 2015 18:33:19 +0000
Message-ID: <20150309183319.GX28806@sirena.org.uk>
References: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KISHs/FnjYvFOG5B"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Sender: linux-doc-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Liam Girdwood <lgirdwood@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--KISHs/FnjYvFOG5B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 11, 2015 at 07:35:26PM -0800, Bjorn Andersson wrote:
> Changing the name of the regulator_set_optimum_mode() to
> regulator_set_load() better reflects that the API is doing.

Applied all, thanks.

--KISHs/FnjYvFOG5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU/eduAAoJECTWi3JdVIfQjvkH/3mqcGHt5uJfgH8ibYfrGV9w
UkPWVq/AXq49+q7a7JDJUmnp+hTSUFIfEj8sClnv7WbPSo9ZjiXrYbTgaSj2qy1A
kb/4p4SbHQ/UB33KwP0KGzrZUYPURGEVSeDUf7RU6xx/H9FlN80lKlSWf+Tkf+We
rAmre98IplNOFtFNCS7VycBcjDoau89n8J0so0LvXsF/O1OBgp1OBB1ONsHBouki
fWAsjBq5GyGywxSjA029seyYFkU0BibYjPe8QliRvw7CEoQGnCwPIAIolVLUZqEZ
/EOMOkZCJnFogTz0a41cS7qDxhaKL49BV54JqCjHUnaqfN2nXn5RrQ91AznlySA=
=dQhH
-----END PGP SIGNATURE-----

--KISHs/FnjYvFOG5B--
