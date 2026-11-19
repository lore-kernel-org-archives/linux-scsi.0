Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795101931;
	b=gc5LBw8fz00k9ZXYmDYeSHzpPBFJHsY/fsx0gKE6LQyC5OqUzh9uPAAupoGeu1hP4SZ/
	 rsHMs1HfbHauSFAoiIlJfVbhKFFHnVQGP+qzi7q/6P9g+PgSxQ6KAK/E/whoelkLJKWQV
	 vbkZXBFNCf3WX2iw5yMQECk0g2uitOFBhkmA9/4GbTf6KcrZ9zVx5JcRAIe0ilWKbACe1
	 QVMOaC4Z7mC5AN7wMBHfp9fqKvo/HyT+xujL68DXuM5VrlSr1RyMcTOhX7P4jegoM5aeJ
	 OG7OjwY5K0fWLBthhNkoT9bMc2aWdl74i6Rr6bXqxgzWTcvz8e9QssevlwW4xf0e5lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101931;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FD3RnR70DS7Vh56jSG2faYGsDQ14YnTWsdAxJXK9pMU=;
	b=dJTTTG67PYkfXs5W2xEAYxDtCCfLMhvfOeUg+vPn6A3FKM8B6eXNIWeFgDeOsuR8IG18
	 CMwUfFOyoll+2/z1hlf00tE4OQTmANbr1LEgOgPDlPcUwqn0v6XgQkftWsYSL/W3u8B7i
	 p+Uh6PII8So7xRK3bl6qc3t8gzNfWyFwvLUKBkPl1hvIU+zO5LisNbUZNPqPVcHMD2rGb
	 u1+Uea9CDba3jIWOmAa+sLmovqBelhUSZdzqWJ5fNBP5wMFENqXBVrF4SRnd2AzQijBh6
	 cjNVUR0LFScBt21al0qOeqOlnt3vfgnxHfmQmJgAKmgQq+dVFUNlrwGDxkJjfoEuiMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mo4y319x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4315606A324;
	Thu, 19 Nov 2026 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mo4y319x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6CF1F000C6;
	Thu, 19 Nov 2026 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795101931;
	bh=FD3RnR70DS7Vh56jSG2faYGsDQ14YnTWsdAxJXK9pMU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mo4y319xiEI+SrY8JcTnFeEnDM8QFDu9zXwN6rehRD5cfXHZJNGjTkM4F0PIsIiGa
	 oUEoBlWwKoq6u+c06IvEjPBx0mNN1VBDwS+Ae5LwNV7TiujzMChw47+CivsAuJB/E1
	 /Pn/Ppe7rSr64jWx+FXuRUDuu0RFq8W9hZ34plZKhTpjgk8BuIaIF4L7qJ7MTWF+Na
	 HqEbLI41B1AhwMDZ77RcyUwLKUt9M68PTtkzJliNYQYvxoWmvbrjoVbaOM5qQB8wba
	 aVkf9vqrihYfrWzyWwTzzBLNP0Fyzgo58+Md9+6bPSP0pU1NwdAyWTlvCvf+cJ7cTt
	 3gRerxqsjx5tQ==
Message-ID: <sashiko-outbox-223380@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 02/23] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261119-mt8196-ufs-v15-2-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
 <20261119-mt8196-ufs-v15-2-aae1eb0382e8@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 15:25:30 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] dt-bindings: ufs: mediatek: incompatible schema breaks
  in-tree mt8195.dtsi
--

commit 897f6726f17b6227ef961cfcc71c9c313c14a3df
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

dt-bindings: ufs: mediatek,ufs: Complete the binding

This commit updates the MediaTek UFS devicetree binding schema to add
resets, controller power supplies, operating-points-v2, and updated
per-SoC clock definitions while disallowing freq-table-hz.

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

[ ... ]

> @@ -54,29 +96,41 @@ allOf:
>        properties:
>          compatible:
>            contains:
> -            enum:
> -              - mediatek,mt8195-ufshci
> +            const: mediatek,mt8183-ufshci
>      then:
>        properties:
>          clocks:
> -          minItems: 8
> +          maxItems: 1
>          clock-names:
>            items:
> -            - const: ufs
> -            - const: ufs_aes
> -            - const: ufs_tick
> -            - const: unipro_sysclk
> -            - const: unipro_tick
> -            - const: unipro_mp_bclk
> -            - const: ufs_tx_symbol
> -            - const: ufs_mem_sub
> -    else:
> +            - const: main
> +        avdd12-ckbuf-supply: false
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt8192-ufshci
> +    then:
>        properties:
>          clocks:
> -          maxItems: 1
> +          minItems: 3
> +          maxItems: 3
>          clock-names:
> -          items:
> -            - const: ufs
> +          minItems: 3
> +          maxItems: 3
> +        avdd09-supply: false
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt8195-ufshci
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 10
> +        clock-names:
> +          minItems: 10
> +        avdd09-supply: false

[Severity: Medium]
Does renaming clock-names, setting freq-table-hz: false, and requiring 10
clocks for mediatek,mt8195-ufshci break DT ABI compatibility and
dtbs_check for the existing in-tree ufshci@11270000 node in
arch/arm64/boot/dts/mediatek/mt8195.dtsi?

Contrary to the commit message, mediatek,mt8195-ufshci is already used in
mainline (and enabled by mt8395-genio-1200-evk-ufs.dts and
mt8395-radxa-nio-12l.dts) with the 8 previously documented clock names and
freq-table-hz:

arch/arm64/boot/dts/mediatek/mt8195.dtsi {
    ...
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
    ...
}

Because those changes are not backwards-compatible with the existing DTS,
running make dtbs_check fails on the MT8195 and MT8395 boards.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-mt8196-ufs=
-v15-0-aae1eb0382e8@collabora.com?part=3D2
