Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794420827;
	b=KBEolaPQKQu4BOUroc1g3iRs4+jPxjSixCz4w+8ahneAmztE5K4NP3h7jV0A5RkA6kMY
	 RA4EgGeIFRky7Uzlw66GSmhq7qX94IpRsNGD6beikCJoUMHVZgXC7MFHRtH0Llyn+38Jx
	 GKsilrHDpEdtvAx5OqsNCG729cfDHGOTgNtnndeCPOL7//EdJhaODRNkm7tmoFcqp5Y7Q
	 PKDyaS1HETVl4l9ABf2VpFNswBsU6EiXNSYRpJMssTht4dCVUXIMTQQ48Tz+jBm+nVDuW
	 R5dKnNk8KNMHeFuUkJ9cAjDCBJmdprF30ImAysesYQZpALyEzTGFVGl7Ojf1DMM7WTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794420827;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fBcjNQg9OrGtrGdTgn97aWGc2ARnhx02zvndHobzdWc=;
	b=Ytqm/561I1eSgWa4A9/wMZTCAvOn/yiVXI86+KucoY5xMYQswysQXFo4dVXGSwZsCggH
	 Hkdf/cmsK+LVaTAhZvETAIIwg//2nkSSbVWodtQ1tBatGp0a7fqcipdUo7JD1lORSu7fs
	 pC3rCTnb01AXFC90iLZc2nYgD3dFAnOMJmthAIHu8HTJkdUrZcJwVrWQnsj4z/0oVsEtt
	 DrswPm6HPrUH1k38xSplg1bF8tAJeaNMQPylV4FFQJ1IU8+UwNTkI8aK19i4TPOiHv9RU
	 jditB0p4vGYZY+tphn9ik3mOK3DghNa5O3697sit5r7wf1rcnGOAg0gyBFso0CUVV9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="R52Nk+r/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E376606A9EE;
	Wed, 11 Nov 2026 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R52Nk+r/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7B41F00A05;
	Wed, 11 Nov 2026 18:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420827;
	bh=fBcjNQg9OrGtrGdTgn97aWGc2ARnhx02zvndHobzdWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R52Nk+r/p+cRQIHVCOMtHTnDeJR4hqQfVzLNaAScKxEEOLOQ9nkPSdjtikEes8jhc
	 JAWVpzyQJji/DGNr031XHAhtLDcMrLeEoZWCuzcbgYyh64ka5BNubilEAxPoFoKkYa
	 Cgs1cjJbPpkz/zZQTdKRYv/sv3xY+qEavFbfdr3Ssr2eT9J3hApzCQjxLb1mGDDC6M
	 ZwQkmAUk8WMfPnmqwnWgljzLcawEJedvpPjF+E/GXfWT0fK5kW2cPI6ORVmMdz5Yeq
	 3w4Me/bO1boZPy1da6Gb8kB32Iiq+hnDLSfmr77EmsNah3Umfuc20oWmhDMcUl15XE
	 35JPaPvMqHCNQ==
Date: Wed, 11 Nov 2026 18:13:42 +0000
From: Conor Dooley <conor@kernel.org>
To: Ajay Neeli <ajay.neeli@amd.com>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	sai.krishna.potthuri@amd.com, alim.akhtar@samsung.com,
	bvanassche@acm.org, beanhuo@micron.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, git@amd.com, michal.simek@amd.com,
	srinivas.goud@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH] dt-bindings: ufs: amd,versal2-ufs: Add ref_clk clock
 property
Message-ID: <20261111-facility-pristine-82e76afe8d8b@spud>
References: <20261111043840.906301-1-ajay.neeli@amd.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5ASz0f9jieUGBupM"
Content-Disposition: inline
In-Reply-To: <20261111043840.906301-1-ajay.neeli@amd.com>

--5ASz0f9jieUGBupM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 10:08:40AM +0530, Ajay Neeli wrote:
> Add ref_clk clock property to specify the reference clock frequency
> supplied to the UFS device.
>=20
> The AMD Versal2 UFS controller operates with a 26 MHz reference clock.
> UFS 3.x devices default their bRefClkFreq attribute to 26 MHz, matching
> the controller, so no explicit configuration is needed. However, UFS 4.0
> and later devices default bRefClkFreq to 52 MHz, expecting a 52 MHz
> reference clock. This mismatch causes timing violations and link
> instability.
>=20
> Adding the ref_clk property allows the UFS driver to read the actual
> reference clock frequency from the devicetree and program the device
> bRefClkFreq attribute accordingly during initialization.
>=20
> Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
> ---
>  .../devicetree/bindings/ufs/amd,versal2-ufs.yaml         | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b=
/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> index c00ec342d574..e294c0f1b0ce 100644
> --- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
> @@ -20,11 +20,12 @@ properties:
>      maxItems: 1
> =20
>    clocks:
> -    maxItems: 1
> +    maxItems: 2

Please add an items list here.

> =20
>    clock-names:
>      items:
>        - const: core
> +      - const: ref_clk

its a clock by nature, don't restate that in the name.
pw-bot: changes-requested

Thanks,
Conor.

> =20
>    power-domains:
>      maxItems: 1
> @@ -52,10 +53,10 @@ examples:
>      ufs@f10b0000 {
>          compatible =3D "amd,versal2-ufs";
>          reg =3D <0xf10b0000 0x1000>;
> -        clocks =3D <&ufs_core_clk>;
> -        clock-names =3D "core";
> +        clocks =3D <&ufs_core_clk>, <&ufs_ref_clk>;
> +        clock-names =3D "core", "ref_clk";
>          resets =3D <&scmi_reset 4>, <&scmi_reset 35>;
>          reset-names =3D "host", "phy";
>          interrupts =3D <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
> -        freq-table-hz =3D <0 0>;
> +        freq-table-hz =3D <0 0>, <26000000 26000000>;
>      };
> --=20
> 2.43.7
>=20
>=20

--5ASz0f9jieUGBupM
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCavSwVgAKCRB4tDGHoIJi
0pe8AP0YTgA6km1sHyGxelK1EhuKylL/jltTDSK/d9xbo/oYzgD+KSzPYc4XoGWY
sXsty7VqEjXFiZQd5cYS8eGnpPecLwU=
=g9Dz
-----END PGP SIGNATURE-----

--5ASz0f9jieUGBupM--
