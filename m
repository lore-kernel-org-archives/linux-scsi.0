Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE9230C60B;
	Thu, 16 Oct 2025 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633681; cv=none; b=RYVG+T0ZC6wJeXCG7GynZWMO87Xxag6bKG3cG90RBGIy0la40CZ20FrorCXFfu9iyoQ22AVrJSJ1JvyUXDvd17AX+b7z/BoSWE/HBgYrnhOqR6dA7DriSrRTzz6Zd0t0TPMgY1pUcXMZBQl5fiKLEaMuvrRuZMeExuB+eWsMMug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633681; c=relaxed/simple;
	bh=P6z6MpZ3GyLdgUiuk5OCeZbUo2ga95ouA7nUg4Q6aj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HFNSl40D6osgDopWNBqVzkf/Q9Pb9qSWV+XvmWmMPHd15UDL6Y5sZ/761b7OXCQ7wTUWeOFXHg5zvZJbXTNCnF0ddZkInohqeSwvErpu149L/YF381LO/DFTIux9oWWg4GA6iS8CvmSgf5V1dpN2EGk1xeMzGxiZ7D2vu3OPa9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozI6wj+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozI6wj+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83354C4CEF1;
	Thu, 16 Oct 2025 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760633681;
	bh=P6z6MpZ3GyLdgUiuk5OCeZbUo2ga95ouA7nUg4Q6aj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ozI6wj+mVED3BwR6VvJe1HkiU6QMx0LrkGAcqVEuP/lkCLmnLHzzm54D+zom70e/0
	 TAZk/V46RlVvu+cGZ9PLP97lhv0DGYjBtFV6t/2FHKGlvvavoHAbHs5RTEdNcD3nhp
	 53ZGGshZZlevE3Y0ZRQAJcy5RmqT4jjV5nNgb1Kh6QocmEeueWbSvyPd4h71JHlSxD
	 w3YsGIJjuIlU5O8byeeGpEvT0qwbBav6vL6ECWuZyRukZXaJlfJIp+WLaWlI1fRcle
	 +WnsqyzZ6JATGqkq9Nn7uMqraI5qgHYPSX/hpaHQyw3vZdsIglDXIQD9v0DGCRqA/U
	 zt9C6TqsMbuLQ==
Date: Thu, 16 Oct 2025 17:54:34 +0100
From: Conor Dooley <conor@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH 1/5] dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci
 variant
Message-ID: <20251016-spookily-finisher-07e0240a11f2@spud>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
 <20251014-mt8196-ufs-v1-1-195dceb83bc8@collabora.com>
 <20251016-kettle-clobber-2558d9c709de@spud>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LGvrffN0k+9EYx8j"
Content-Disposition: inline
In-Reply-To: <20251016-kettle-clobber-2558d9c709de@spud>


--LGvrffN0k+9EYx8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2025 at 05:53:01PM +0100, Conor Dooley wrote:
> On Tue, Oct 14, 2025 at 05:10:05PM +0200, Nicolas Frattaroli wrote:

> > @@ -30,7 +42,15 @@ properties:
> >    reg:
> >      maxItems: 1
> > =20
> > +  resets:
> > +    maxItems: 3
> > +
> > +  reset-names:
> > +    maxItems: 3
>=20
> You cannot use reset-names if you don't define what the names are.
> Please provide a items list with descriptions in resets and some
> names in reset-names.

I missed that the names were provided in the if/then/else. Please just
define them here, since there's currently only one possible set and use
the if/then/else to block their use on !8195

--LGvrffN0k+9EYx8j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPEjSgAKCRB4tDGHoIJi
0hRAAPi8N6sPfeV1Bi3I///Ot3yTtonRd3989x6drtQm36IVAQD69kpquARZkUPk
oMdifIXnmA5UyWpnpgSGOKCPH2daAg==
=AjY2
-----END PGP SIGNATURE-----

--LGvrffN0k+9EYx8j--
