Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023DA22F76F;
	Fri, 24 Oct 2025 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761325748; cv=none; b=uLMzyyzpC1oRRlhcNBWLpyUQRWhW1kXNg1OfMTwTLtFQn+AKa2gWzvAJnhyrxC9de1dzBKKerQcgGBe6VQysE8tirWTN9YAMufxfuB1hLjSO8928LxpV6u8KxnfmRdnJweO52mtlRXPv7Vgy3A4aWbFfrfcFd7F5hv+HBX6Qga0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761325748; c=relaxed/simple;
	bh=nEsdPzi/tI01PeUgGVuo2zqDEcBVeBbnMqQ68PWLzVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9TFB/9X/8qyYoCYaUMUbUL47zfWB6swV5pj2v1YJ901ucskpc9Srk93tqmCBagHB9huz0KIAYRrQ9+86n6bqzWZv0nwnUA+9ChoOgAAiqIi42W0JGUgqqSNo4yMEL2HCGnbNefgvpEeaP0hal24KW6eY0fzj/FpXLG9H7mmzaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QamugzSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QamugzSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69DAC4CEF1;
	Fri, 24 Oct 2025 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761325747;
	bh=nEsdPzi/tI01PeUgGVuo2zqDEcBVeBbnMqQ68PWLzVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QamugzSLBu5WaDeDpKXu4OBuo2iT0CBGV4gsQNQieHyIBXMKIEoRrJoeARLexzznd
	 s0Jv5aVIYnZUz+9cX6dEIlPuyltqWfS85b0qGIAMbS/29Jvpd3zhro6HTjRyjC0ALl
	 /FEhzqwZ9g/P4xNmU0baHCs8viygjcFDwnYx81rEinu0bfEs3ZeXJq5gi6dTGRv8js
	 xHWAS8qqJwYsxi6B3Pv8dRR4bAyW6UGBIPAHA8AQgwnwIma+suj9Upc9ZTrXkI/Wlx
	 nfx9mW+0t5M+h/NdkjyPFxEoodFuQABjnPlbXrRXO+gt86g63Pr2r/QIFib8KfWOGw
	 vWzsgrucEU6HA==
Date: Fri, 24 Oct 2025 18:09:00 +0100
From: Conor Dooley <conor@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v3 01/24] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Message-ID: <20251024-spilt-deviate-e3f6bfd3642c@spud>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
 <20251023-mt8196-ufs-v3-1-0f04b4a795ff@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w3wlVB5ViarihM4q"
Content-Disposition: inline
In-Reply-To: <20251023-mt8196-ufs-v3-1-0f04b4a795ff@collabora.com>


--w3wlVB5ViarihM4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 09:49:19PM +0200, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC includes an M-PHY compatible with the already
> existing mt8183 binding.
>=20
> However, one omission from the original binding was that all of these
> variants may have an optional reset.
>=20
> Add the new compatible, and also the resets property, with an example.
>=20
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collab=
ora.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

> ---
>  .../devicetree/bindings/phy/mediatek,ufs-phy.yaml        | 16 ++++++++++=
++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml =
b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
> index 3e62b5d4da61..f414aaa18997 100644
> --- a/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
> +++ b/Documentation/devicetree/bindings/phy/mediatek,ufs-phy.yaml
> @@ -26,6 +26,7 @@ properties:
>        - items:
>            - enum:
>                - mediatek,mt8195-ufsphy
> +              - mediatek,mt8196-ufsphy
>            - const: mediatek,mt8183-ufsphy
>        - const: mediatek,mt8183-ufsphy
> =20
> @@ -42,6 +43,10 @@ properties:
>        - const: unipro
>        - const: mp
> =20
> +  resets:
> +    items:
> +      - description: Optional UFS M-PHY reset.
> +
>    "#phy-cells":
>      const: 0
> =20
> @@ -65,5 +70,16 @@ examples:
>          clock-names =3D "unipro", "mp";
>          #phy-cells =3D <0>;
>      };
> +  - |
> +    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
> +    ufs-phy@16800000 {
> +        compatible =3D "mediatek,mt8196-ufsphy", "mediatek,mt8183-ufsphy=
";
> +        reg =3D <0x16800000 0x10000>;
> +        clocks =3D <&ufs_ao_clk 3>,
> +                 <&ufs_ao_clk 5>;
> +        clock-names =3D "unipro", "mp";
> +        resets =3D <&ufs_ao_clk MT8196_UFSAO_RST0_UFS_MPHY>;
> +        #phy-cells =3D <0>;
> +    };
> =20
>  ...
>=20
> --=20
> 2.51.1.dirty
>=20

--w3wlVB5ViarihM4q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPuyrAAKCRB4tDGHoIJi
0n3qAQDuISPZivWMxQqyWT7hptpBU8VJakYcV1f/3Uook67DEgD9Fuw/t0xI+buQ
vy1+kgKQvO/lTUze9oKFvo5TZQgdYAI=
=ts27
-----END PGP SIGNATURE-----

--w3wlVB5ViarihM4q--
