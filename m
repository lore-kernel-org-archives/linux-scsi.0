Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C86930C60B;
	Thu, 16 Oct 2025 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633588; cv=none; b=X0sqfCCmIvqzABWFXwuPIeagyQpffGcyOU2xErnePVRSNrhfEkR6pzn0wN0O+tcpIrvkp/rTw19Y0IIwR0RO0HkOAitLU3ojUg58V5VCVAQsIBz0N07npo6gc7cxtizcCisTljGKWncgAHG3H7UoE6rk2SwOBczpBrqc206mTnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633588; c=relaxed/simple;
	bh=V0XeLsrus8KECI87ceClSS9Ua2YHT9amab2xtIElHn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNH9W095BstghaM8Ka/Kr/8gJ9biOYaAU0daH25eBeTSsJjgtIxlH9WTNVIrLYDggxF1LvtjuyC4gE75vT5MvI7pj4wcQOfq0mskwdD/8g1V95YIVKQ+3CNCoklIUMbpkwgpE+K9on5JtJaOY5u3jMW4fEeJLjF/v3qgAALZXZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOzuwVdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOzuwVdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E9BC4CEF1;
	Thu, 16 Oct 2025 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760633587;
	bh=V0XeLsrus8KECI87ceClSS9Ua2YHT9amab2xtIElHn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DOzuwVdTXLn0+8Ej93lFB+fLK2eYomM4FTuckTk8E1gLRFXid41R9z27ZK9GxmYoW
	 BouffLeBYHSvO1lcJdFtVdMEU4q66IGzhUBxJUMAk+vds2/usxoOf0sNWKUcweD4JC
	 VVAi6tCfKw6mrXePdKyz5U6rdaDzRermtz8yn95c1bSISmN48VO7dlTuLeYFWIVmL3
	 ZpITLnASax7y1WHGcynaB3nDNvrY23MPhtxR22EAvnlGsYRCVZ+BJQzm0bHBiCr5Tb
	 G+uHzCSf2ztJ7Vh0o5XhcLeePbL16lzRjc7dEZ06EtFBBS0KiT+1ILy/OaHbCbHknL
	 XhnkWcMeRlwsw==
Date: Thu, 16 Oct 2025 17:53:01 +0100
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
Message-ID: <20251016-kettle-clobber-2558d9c709de@spud>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
 <20251014-mt8196-ufs-v1-1-195dceb83bc8@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8ALsO+QMwrOx/G+O"
Content-Disposition: inline
In-Reply-To: <20251014-mt8196-ufs-v1-1-195dceb83bc8@collabora.com>


--8ALsO+QMwrOx/G+O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Tue, Oct 14, 2025 at 05:10:05PM +0200, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC contains the same UFS host controller interface
> hardware as the MT8195 SoC. Add it as a variant of MT8195, and extend
> its list of allowed clocks, as well as give it the previously absent
> resets property.
>=20
> Also add examples for both MT8195 and the new MT8196, so that the
> binding can be verified against examples for these two variants.
>=20
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
>  .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 134 +++++++++++++++=
++++--
>  1 file changed, 123 insertions(+), 11 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 1dec54fb00f3..070ae0982591 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> @@ -11,18 +11,30 @@ maintainers:
> =20
>  properties:
>    compatible:
> -    enum:
> -      - mediatek,mt8183-ufshci
> -      - mediatek,mt8192-ufshci
> -      - mediatek,mt8195-ufshci
> +    oneOf:
> +      - enum:
> +          - mediatek,mt8183-ufshci
> +          - mediatek,mt8195-ufshci
> +      - items:
> +          - enum:
> +              - mediatek,mt8192-ufshci
> +          - const: mediatek,mt8183-ufshci

It's hard to follow what's going on in this commit.
Firstly, this seems to be some sort of unrelated change that isn't
mentioned in the commit message.

> +      - items:
> +          - enum:
> +              - mediatek,mt8196-ufshci
> +          - const: mediatek,mt8195-ufshci
> =20
>    clocks:
>      minItems: 1
> -    maxItems: 8
> +    maxItems: 16
> =20
>    clock-names:
>      minItems: 1
> -    maxItems: 8
> +    maxItems: 16

Then all devices grow 8 more permitted clocks, despite the wording in
the commit message being 8195 specific. (Hint: you missed maxItems: 8 in
the else)

> +
> +  freq-table-hz: true

Then you add this deprecated property, which isn't mentioned in the
commit message and I don't see why a deprecated property is needed.

> +
> +  interrupts: true
> =20
>    phys:
>      maxItems: 1
> @@ -30,7 +42,15 @@ properties:
>    reg:
>      maxItems: 1
> =20
> +  resets:
> +    maxItems: 3
> +
> +  reset-names:
> +    maxItems: 3

You cannot use reset-names if you don't define what the names are.
Please provide a items list with descriptions in resets and some
names in reset-names.

>    vcc-supply: true
> +  vccq-supply: true
> +  vccq2-supply: true

And then two new supplies that are not mentioned in the commit message,
and again are allowed for all variants. The commit message talks about
extended 8195 features, so this is starting to look like there was some
sort of squashing accident.

> =20
>    mediatek,ufs-disable-mcq:
>      $ref: /schemas/types.yaml#/definitions/flag
> @@ -44,22 +64,19 @@ required:
>    - reg
>    - vcc-supply
> =20
> -unevaluatedProperties: false
> -
>  allOf:
>    - $ref: ufs-common.yaml
> -
>    - if:
>        properties:
>          compatible:
>            contains:
> -            enum:
> -              - mediatek,mt8195-ufshci
> +            const: mediatek,mt8195-ufshci

The commit message says:
| hardware as the MT8195 SoC. Add it as a variant of MT8195, and extend
| its list of allowed clocks, as well as give it the previously absent
| resets property.

I don't know if that's meant to mean that only the new device has 16 and
the 8195 only has 8, or if the 8195 should have had 16 possible clocks
too.

>      then:
>        properties:
>          clocks:
>            minItems: 8
>          clock-names:
> +          minItems: 8
>            items:
>              - const: ufs
>              - const: ufs_aes
> @@ -69,6 +86,19 @@ allOf:
>              - const: unipro_mp_bclk
>              - const: ufs_tx_symbol
>              - const: ufs_mem_sub
> +            - const: crypt_mux
> +            - const: crypt_lp
> +            - const: crypt_perf
> +            - const: ufs_sel
> +            - const: ufs_sel_min_src
> +            - const: ufs_sel_max_src
> +            - const: ufs_rx_symbol0
> +            - const: ufs_rx_symbol1
> +        reset-names:
> +          items:
> +            - const: unipro_rst
> +            - const: crypto_rst
> +            - const: hci_rst
>      else:
>        properties:
>          clocks:
> @@ -76,6 +106,10 @@ allOf:
>          clock-names:
>            items:
>              - const: ufs
> +        resets: false
> +        reset-names: false
> +
> +unevaluatedProperties: false
> =20
>  examples:
>    - |
> @@ -99,3 +133,81 @@ examples:
>              vcc-supply =3D <&mt_pmic_vemc_ldo_reg>;
>          };
>      };
> +  - |
> +    ufshci@11270000 {
> +        compatible =3D "mediatek,mt8195-ufshci";
> +        reg =3D <0x11270000 0x2300>;
> +        interrupts =3D <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
> +        phys =3D <&ufsphy>;
> +        clocks =3D <&infracfg_ao 63>, <&infracfg_ao 64>, <&infracfg_ao 6=
5>,
> +                 <&infracfg_ao 54>, <&infracfg_ao 55>,
> +                 <&infracfg_ao 56>, <&infracfg_ao 90>,
> +                 <&infracfg_ao 93>;
> +        clock-names =3D "ufs", "ufs_aes", "ufs_tick",
> +                      "unipro_sysclk", "unipro_tick",
> +                      "unipro_mp_bclk", "ufs_tx_symbol",
> +                      "ufs_mem_sub";
> +        freq-table-hz =3D <0 0>, <0 0>, <0 0>,
> +                        <0 0>, <0 0>, <0 0>,
> +                        <0 0>, <0 0>;
> +        vcc-supply =3D <&mt6359_vemc_1_ldo_reg>;
> +        mediatek,ufs-disable-mcq;
> +    };
> +  - |
> +    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ufshci@16810000 {
> +        compatible =3D "mediatek,mt8196-ufshci", "mediatek,mt8195-ufshci=
";
> +        reg =3D <0x16810000 0x2a00>;
> +        interrupts =3D <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>;
> +
> +        clocks =3D <&ufs_ao_clk 6>,
> +                 <&ufs_ao_clk 7>,
> +                 <&clk26m>,
> +                 <&ufs_ao_clk 3>,
> +                 <&clk26m>,
> +                 <&ufs_ao_clk 4>,
> +                 <&ufs_ao_clk 0>,
> +                 <&topckgen 7>,
> +                 <&topckgen 41>,
> +                 <&topckgen 105>,
> +                 <&topckgen 83>,
> +                 <&topckgen 42>,
> +                 <&topckgen 84>,
> +                 <&topckgen 102>,
> +                 <&ufs_ao_clk 1>,
> +                 <&ufs_ao_clk 2>;
> +        clock-names =3D "ufs",
> +                      "ufs_aes",
> +                      "ufs_tick",
> +                      "unipro_sysclk",
> +                      "unipro_tick",
> +                      "unipro_mp_bclk",
> +                      "ufs_tx_symbol",
> +                      "ufs_mem_sub",
> +                      "crypt_mux",
> +                      "crypt_lp",
> +                      "crypt_perf",
> +                      "ufs_sel",
> +                      "ufs_sel_min_src",
> +                      "ufs_sel_max_src",
> +                      "ufs_rx_symbol0",
> +                      "ufs_rx_symbol1";
> +
> +        freq-table-hz =3D <273000000 499200000>, <0 0>, <0 0>, <0 0>, <0=
 0>,
> +                        <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>,=
 <0 0>,
> +                        <0 0>;
> +
> +        phys =3D <&ufsphy>;
> +
> +        vcc-supply =3D <&mt6363_vemc>;
> +        vccq-supply =3D <&mt6363_vufs12>;
> +        vccq2-supply =3D <&mt6363_vufs18>;
> +
> +        resets =3D <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_UNIPRO>,
> +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_CRYPTO>,
> +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFSHCI>;
> +        reset-names =3D "unipro_rst", "crypto_rst", "hci_rst";

Putting _rst in the name of a reset is redundant.

pw-bot: changes-requested

Thanks,
Conor.
> +        mediatek,ufs-disable-mcq;
> +    };
>=20
> --=20
> 2.51.0
>=20

--8ALsO+QMwrOx/G+O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPEi7AAKCRB4tDGHoIJi
0sanAQDHpXuANi3k6/gN3+lkhmI3czcu3dk1enN4zyJvkxK79AEA/K8sbjFNf4iC
3n+3+vohgUp9LMrdTmZdpWUNTJXRSws=
=oqxK
-----END PGP SIGNATURE-----

--8ALsO+QMwrOx/G+O--
