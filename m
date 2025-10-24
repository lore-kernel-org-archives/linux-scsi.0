Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1D8243946;
	Fri, 24 Oct 2025 17:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761326025; cv=none; b=XKonjzsOFL8uiCdcOKkJtJeMzclPTc51cdTJkhiMCy2YEMxkpsL3T1FNVcvNhkgvPgd05UZkkw/UAxnNOrYNXAo7ra3aPmRGlLph1MmnJBHvYS/PxFmlVMiIdkbb5DS7DRrF/yddm7A1f9M9VDJGGGyEwayVrTxJkaqGAv1OdN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761326025; c=relaxed/simple;
	bh=R8ei2+rtTjBZldNo1xDWoXq5kwYHchpeiJ1vuqrotkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSFlp57+hJWgd3rlLbee+lFm8MkKvydkuHK0VehT+Q5/+GPd2sTFrw6KbQnSe8u8vDVpkQJzPJxJxYPmueC2WXGP6EutmU4r9SD59YIolB+NTyFAEoM0c3ZyVBj1ANqeDJVtfESzMgbWsYlShpZ+jAwlBUeKEmGo4ep+R36S+aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKN/xz/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKN/xz/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF70C4CEF1;
	Fri, 24 Oct 2025 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761326023;
	bh=R8ei2+rtTjBZldNo1xDWoXq5kwYHchpeiJ1vuqrotkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kKN/xz/QtGADSPG/LXyoKlY+GTmbeYUFWlyLfHB/2pBk8eLYD2VW41jr381YkANwt
	 UjnW42UbfSQgX1Cjx8mvTsAOOynRRM2Yr+JK8HN59mvwnfmF+BdHZug9Db8Yop+Pko
	 TXifJM4opjWBFXM7gtFtX8Ut0XB4ImdLBc4q7OzRsZUr5T7KqWuUioXb3vGrB7foOM
	 Nph1xeIyWi+0w5itXmn8s7t1Untza2OpaR25IyKttkF4ctHMzEtd/w+q9/Gz3e5N3j
	 KV7t/rgEEoiWL/XgUYQWy3FOMg/l0ctqMtxENbx/jrc3gNGUr6klToMJESA6+LrVUx
	 G4Q2ZrZ0cSBtQ==
Date: Fri, 24 Oct 2025 18:13:36 +0100
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
Subject: Re: [PATCH v3 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Message-ID: <20251024-thrash-amid-d5af186c4319@spud>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
 <20251023-mt8196-ufs-v3-3-0f04b4a795ff@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jr8TZfrxyC1RMH9a"
Content-Disposition: inline
In-Reply-To: <20251023-mt8196-ufs-v3-3-0f04b4a795ff@collabora.com>


--jr8TZfrxyC1RMH9a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 09:49:21PM +0200, Nicolas Frattaroli wrote:

>      };
> +  - |
> +    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ufshci@16810000 {
> +        compatible =3D "mediatek,mt8196-ufshci";
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
> +                 <&ufs_ao_clk 1>,
> +                 <&ufs_ao_clk 2>,
> +                 <&topckgen 42>,
> +                 <&topckgen 84>,
> +                 <&topckgen 102>;

This is absolutely a nitpick thing, but if you end up resubmitting, can
you pick a consistent format between the two examples your series adds
for the clocks/clock names?
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

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
> +                      "ufs_rx_symbol0",
> +                      "ufs_rx_symbol1",
> +                      "ufs_sel",
> +                      "ufs_sel_min_src",
> +                      "ufs_sel_max_src";
> +
> +        operating-points-v2 =3D <&ufs_opp_table>;
> +
> +        phys =3D <&ufsphy>;
> +
> +        avdd09-supply =3D <&mt6363_vsram_modem>;
> +        vcc-supply =3D <&mt6363_vemc>;
> +        vcc-supply-1p8;
> +        vccq-supply =3D <&mt6363_va12_2>;
> +        vccq2-supply =3D <&mt6363_vufs12>;
> +
> +        resets =3D <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_UNIPRO>,
> +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_CRYPTO>,
> +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFSHCI>;
> +        reset-names =3D "unipro", "crypto", "hci";
> +        mediatek,ufs-disable-mcq;
> +    };
>=20
> --=20
> 2.51.1.dirty
>=20

--jr8TZfrxyC1RMH9a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPuzwAAKCRB4tDGHoIJi
0hLaAP4uJxkdce4PNxbIp4Rzr4024f32v9vwcNnDRCl9lOghRgEA/GmQKqp/HFtv
vmFIaYAOVAPddZvh3zO1MoucBgMwww0=
=WOoe
-----END PGP SIGNATURE-----

--jr8TZfrxyC1RMH9a--
