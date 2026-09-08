Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554AB4F0538;
	Tue,  8 Sep 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788890361; cv=none; b=t+rCEBxqkgTcZwMcBV2+63SRbBC1/d5pUIA5FxBdxSTP1c8c0lMUBeUqsuHfepGiXUGL4SUYh1qibkDKaPoQUXefkGdTFG+VBhSD8fZszqK4QCtZcCKOFuqUXeEjh1VtUsu9Qudp+jje1KYam/XXZR0HZXWdAn2NGXAwZRtY8TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788890361; c=relaxed/simple;
	bh=GDYCE4PZTmcZfWehm7a5xohHYJ2AxhYAMjFzKQp8J54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRh6g2ukqHbxP6nbbYn1q/DntPgp/4/B+N++0pNl/9L77fBQWHWDVKIdFy9UP4X8/RhHSFKbdJ7w5XMisR2YHk/N2+64xtGTeMj3H9guJ8PVxxamLoPB+/tZRFjegvQTisHCTAARYARqP30xcBxuRclN4UhSsSwgIemKFXTQAEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbs4qpQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbs4qpQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98401F00A3D;
	Tue,  8 Sep 2026 17:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788890359;
	bh=nS58VD+9Q5pUHduSFMUnW1M4pyzzqHU28MfvtzrJtek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kbs4qpQxvXdX376nnnNxPuvV8rLbnpJ1kViaBYc652qP/5z3lpl3UkO3OmVmfxJRU
	 0o9rApZyZuGN2KMCyW78xaiM8OguNwZAA04OZU2/2OeZLqXAmfTbPx3fUvY8ABvPTs
	 iydkAhXo/Li8VHzzniNoA611yAUhT4/5ne98fZsDiptcnmOUuRHj+XZ07BDNyvmcLN
	 /oAItnsbMJZgvRIUu3hRIYzh3cu/0Su2I8L9b4x/DgcQIr/kv1D8BWUZdjqui5NPp1
	 bA9NgdQMGwiAgSP4RDEnJK5nZHYsjymNjS2moWCYM8f3LuoDqKHtPW+drHJX1Ftkuq
	 nqSe1S6TQYJ/A==
Date: Tue, 8 Sep 2026 18:59:13 +0100
From: Conor Dooley <conor@kernel.org>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC
Message-ID: <20260908-carnival-curve-5762bb5cdb92@spud>
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
 <20260908-08-k3-ufs-support-v4-1-22aa2bd97d3b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jQbfg5+DHEnMgPgg"
Content-Disposition: inline
In-Reply-To: <20260908-08-k3-ufs-support-v4-1-22aa2bd97d3b@kernel.org>

--jQbfg5+DHEnMgPgg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 08, 2026 at 07:42:03AM +0000, Yixun Lan wrote:
> Document the compatible for UFS (Universal Flash Storage) Host Controller
> which found in SpacemiT K3 SoC chip. Its features are listed below:
>=20
> - Compliant with MIPI UniPro v1.61 specification.
> - Compliant with M-PHY v3.0 specification.
> - Compliant with UFS HCI v2.1 specification.
> - Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
> - Supports standard low-power hibernate to reduce power consumption.
>=20
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++++=
++++++
>  1 file changed, 56 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> new file mode 100644
> index 000000000000..dda533c852e8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.yaml
> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/spacemit,k3-ufshc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: SpacemiT K3 SoC UFS Host Controller
> +
> +maintainers:
> +  - Yixun Lan <dlan@kernel.org>
> +
> +properties:
> +  compatible:
> +    const: spacemit,k3-ufshc
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: aclk
> +      - const: ref_clk

It's the usual refrain here, about having "clk" in clock names.
"axi" and "ref" perhaps?
Otherwise, looks fine to me.

pw-bot: changes-requested

Thanks,
Conor.

> +
> +  resets:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - resets
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/spacemit,k3-clocks.h>
> +    #include <dt-bindings/reset/spacemit,k3-resets.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    ufs@c0e00000 {
> +        compatible =3D "spacemit,k3-ufshc";
> +        reg =3D <0xc0e00000 0x40000>;
> +        clocks =3D <&syscon_apmu CLK_APMU_UFS_ACLK>,
> +                 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
> +        clock-names =3D "aclk", "ref_clk";
> +        resets =3D <&syscon_apmu RESET_APMU_UFS_ACLK>;
> +        interrupts =3D <135 IRQ_TYPE_LEVEL_HIGH>;
> +        lanes-per-direction =3D <2>;
> +    };
>=20
> --=20
> 2.55.0
>=20

--jQbfg5+DHEnMgPgg
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaqBM8QAKCRB4tDGHoIJi
0oK4AP938kdQirfMN6NRHa+lTPVj1DNNJ7TbVOQGbjOSg3a1FQEA/tuljdiVQH6H
wm/nMVyuuDsuFyLk4tuZ9ZZ7EEwhwwk=
=ZkPf
-----END PGP SIGNATURE-----

--jQbfg5+DHEnMgPgg--
