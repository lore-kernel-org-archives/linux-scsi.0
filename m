Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795796224;
	b=EeAOnhg1ibIYUxshBS151YRWsr+ODn1PfAvwEoPmgWGWfHnBPoLkvKILr58CIwu+35bP
	 mC6yXGU9RfNRzokVgOPWfS/mhK6vWF7x7cxIXKEDsBAYn+Zao8Kr23jpfi+X13n7qpme9
	 Mv5QLatTgSB08ojnNavwlL3uTUFJUQG4wrBjJUO2L4mLOsq2nifeFs2EMwVhE3Hs7o2AZ
	 uuNO/Kc3CUROyzHaaX8mSqliXVASAy6xYdJ7P3pOZFOymGNos1x65QsxJgAzVLGjkCtoX
	 +5GniJtwLXHpOTH6DrK+cZJcaUOxhgSJk7FRJM68JDH+eHwbS5eWzdx+6UknKx/Qdhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796224;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=h9E/Yw/XiRcNTmIHpnLOrEiseMqMVpa53c4l91nHw60=;
	b=L7eYxw1tHiH+zOJGkV/addvVnPvOjdeFSrshXPMIswqbQ8S6yJc54kfByPzgVEmZPWMP
	 05O6RAFqFryo4qR/WJ8jraY75D2e9eF87bt5vP7zbMSq0W6FoukauG+k6hlEfRqxg0fl2
	 nbEZjlCQKBd33Q5okV0POhGTsf+0KEtrRgPIDItJuGVlTeaiGi5vYCJXXus4CNnNKojxC
	 l6dvWzP1oLqatHsvNxMS+hn45Gen191WG4oLPck2XfAYEK4BWktoc4tNh5yvDRJxe5GXr
	 7y8Lfk9kPnT882sfP5cWmlhRsMPm698KRpe3G64q+5fQqbj75C0i/iCc09aGzFiYi+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K+2VETt1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4FF606A31C;
	Fri, 27 Nov 2026 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K+2VETt1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2EE1F000C1;
	Fri, 27 Nov 2026 16:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795796223;
	bh=h9E/Yw/XiRcNTmIHpnLOrEiseMqMVpa53c4l91nHw60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K+2VETt1gm8yx4ZCYHW1v5Rqz8yP+PAnq8Qq54b24Av0PRL4Cqt8F6sNJeEveVFOA
	 6bjp04QE8cFSmxESOSoDMnwcGM1GjefBXdtkGsOAJNz2a/GtLv6zH5ArIELzX8/NS5
	 N08YdAjNHWJbE2cPkEBwG99Nakm1TKgUnvYTL6i+PBAclZNXH5Thmi21Py+wDpJpCF
	 RqSUl6uCZEvzW4D8TkMuqzIvMxZ7QcBppWPf7eCc0UMQDYw6wQq/HNPCJmMK5BqCag
	 RpX28rHLVMBmMQACJvRrxFhG1suRMWtuBp5Huvkgisy/LVU/LVugaAzGYAI8mRiC2A
	 kyvmYM6bOG+Lw==
Message-ID: <sashiko-outbox-237859@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 02/23] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261127-mt8196-ufs-v16-2-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
 <20261127-mt8196-ufs-v16-2-6f2568f7c119@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 16:17:02 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] dt-bindings: ufs: mediatek: incompatible schema breaks
  in-tree mt8195.dtsi
- [Low] dt-bindings: ufs: mediatek: MT8195 example uses ungated topckgen
  rx_symbol clocks
- [Low] dt-bindings: ufs: mediatek: non-canonical property order in
  example and schema
- [Low] dt-bindings: ufs: mediatek: redundant word binding in commit
  subject
--

commit e2ae6fefa9dc14389b243b607b0000f77a86ab97
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Complete the binding

This commit expands the MediaTek UFS binding with reset properties,
additional clocks and power supplies, operating-points-v2 support, and an
MT8195 example while disallowing freq-table-hz and renaming clock-names.

> dt-bindings: ufs: mediatek,ufs: Complete the binding

[Severity: Low]
This isn't a bug, but the dt-bindings: prefix already states that the patch
touches a binding, so repeating "binding" in the subject line is redundant.

> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 15c347f5e6604..945cb986b06b7 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> @@ -19,11 +19,25 @@ properties:
> =20
>    clocks:
>      minItems: 1
> -    maxItems: 8
> +    maxItems: 10
> =20
>    clock-names:
>      minItems: 1
> -    maxItems: 8
> +    items:
> +      - const: main
> +      - const: aes
> +      - const: tick
> +      - const: unipro_sysclk
> +      - const: unipro_tick
> +      - const: unipro_mp_bclk
> +      - const: tx_symbol
> +      - const: mem_sub
> +      - const: rx_symbol0
> +      - const: rx_symbol1
> +
> +  operating-points-v2: true
> +
> +  freq-table-hz: false

[Severity: Medium]
Does renaming the existing clock-names, disallowing freq-table-hz, and
raising clocks minItems to 10 for mediatek,mt8195-ufshci break DT ABI and
dtbs_check for the in-tree MT8195 and MT8395 device trees?

The commit message notes that the binding is unused in mainline outside of
its example, but arch/arm64/boot/dts/mediatek/mt8195.dtsi already defines
ufshci@11270000 (enabled by mt8395-genio-1200-evk-ufs.dts and
mt8395-radxa-nio-12l.dts) with 8 clocks using the "ufs" and "ufs_*" names
along with freq-table-hz:

arch/arm64/boot/dts/mediatek/mt8195.dtsi:
		ufshci: ufshci@11270000 {
			compatible =3D "mediatek,mt8195-ufshci";
			...
			clock-names =3D "ufs", "ufs_aes", "ufs_tick",
					"unipro_sysclk", "unipro_tick",
					"unipro_mp_bclk", "ufs_tx_symbol",
					"ufs_mem_sub";
			freq-table-hz =3D <0 0>, <0 0>, <0 0>,
					<0 0>, <0 0>, <0 0>,
					<0 0>, <0 0>;

>    phys:
>      maxItems: 1
> @@ -31,8 +45,36 @@ properties:
>    reg:
>      maxItems: 1

[ ... ]

> @@ -94,9 +148,32 @@ examples:
>              phys =3D <&ufsphy>;
> =20
>              clocks =3D <&infracfg_ao CLK_INFRA_UFS>;
> -            clock-names =3D "ufs";
> -            freq-table-hz =3D <0 0>;
> +            clock-names =3D "main";
> =20
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
> +                 <&infracfg_ao 54>, <&infracfg_ao 55>, <&infracfg_ao 56>,
> +                 <&infracfg_ao 90>, <&infracfg_ao 93>, <&topckgen 212>,
> +                 <&topckgen 215>;
> +        clock-names =3D "main", "aes", "tick", "unipro_sysclk", "unipro_=
tick",
> +                      "unipro_mp_bclk", "tx_symbol", "mem_sub", "rx_symb=
ol0",
> +                      "rx_symbol1";

[Severity: Low]
Should rx_symbol0 and rx_symbol1 in this example reference the infracfg_ao
gate clocks <&infracfg_ao 91> (CLK_INFRA_AO_UFS_RX_SYMBOL) and
<&infracfg_ao 92> (CLK_INFRA_AO_UFS_RX_SYMBOL1) rather than the ungated
topckgen fixed-rate parent clocks <&topckgen 212> and <&topckgen 215>?

In drivers/clk/mediatek/clk-mt8195-infra_ao.c, those topckgen clocks feed
the INFRA_AO4 gates alongside tx_symbol (<&infracfg_ao 90>):

drivers/clk/mediatek/clk-mt8195-infra_ao.c:
	GATE_INFRA_AO4(CLK_INFRA_AO_UFS_TX_SYMBOL, "infra_ao_ufs_tx_symbol", "ufs_=
tx_symbol", 22),
	GATE_INFRA_AO4(CLK_INFRA_AO_UFS_RX_SYMBOL, "infra_ao_ufs_rx_symbol", "ufs_=
rx_symbol", 23),
	GATE_INFRA_AO4(CLK_INFRA_AO_UFS_RX_SYMBOL1, "infra_ao_ufs_rx_symbol1", "uf=
s_rx_symbol1", 24),

Using the topckgen parent clocks directly leaves the INFRA_AO4 clock gates
for rx_symbol0 and rx_symbol1 unreferenced and disabled.

[Severity: Low]
This isn't a bug, but the property order here does not follow the canonical
DT binding order (compatible, reg, clocks, clock-names, interrupts, ...):
the example node lists interrupts and phys before clocks and clock-names,
and the schema properties: and required: blocks list reg after clocks,
clock-names, and phys rather than right after compatible.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-mt8196-ufs=
-v16-0-6f2568f7c119@collabora.com?part=3D2
