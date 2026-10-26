Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793013108;
	b=ifYRuHGOtXRcncwEpE936SsvT0BmZtvpOVJ8IZg18sU1STv1iTi8dH8Ot5xVX4EumCr3
	 EoeDDz/qNpfxkzvKWzM4D8R3xNjysJV80di6EfFojx17ZymErOH8nPjvZJkT3/0OUglky
	 8cVXTdRti1fZ9/uOy/lNWfyVzTe8Y3x3DOZIK3AAXcu2LTCkS+8AZe06YzUH+zZ9nWM6I
	 C+s3BCGnKDxL+qKFVDJWftJaAsFEGCBn5tXKRhCGZnLtFGWe6oYFMW7zQ2KyutaiBfl/+
	 c2i26PGefSgJbIGyiWz+ApWPGSYwsGH/gpcIk/iu6xQfxo8joPOZWVJQ4VeGuGD030g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793013108;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Yd6kellBkouNmavPCTxgbbG4MTt15mCuT9lyTCHnvh4=;
	b=XYcEB317XiqOU7ra/2Gh0ZLHsBwe029v2T/Wwe9cqfCQfqsXiNmXm45039IA9JLItFXa
	 Oi65Vx2wlxy3JcKRYqriZA/vFlu9Kx1zYbMSY1bLx5HQKK5hTKEgcA7ruKr9nsCOGNHK1
	 0mtwEbH5BgNNUrtYVB2wEMMMHL/pAq7QcpeB/FMiC1YbIjxJeDREaBHNq4L2n4RAVHx+b
	 /h3z+l2UDZuHosZG1mMViYCYOzfzw6ozScK5DPUwD6sKTqTldEjt34WHP5sSvdmrYAEVJ
	 VDVVdaNPhJrSfq1ljDLbe2OSTwa+RbRD0NVXY1yrSN5xYzzHpZocp+codf3BxZVCHjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WOl9N+s4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AB5606A946;
	Mon, 26 Oct 2026 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WOl9N+s4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511A81F01342;
	Mon, 26 Oct 2026 11:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793013108;
	bh=Yd6kellBkouNmavPCTxgbbG4MTt15mCuT9lyTCHnvh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WOl9N+s4DFgHhLromnYQt6oF5JKpkhFm1SXjKN2A6YDEmiC263KVR9PrIDCzSeJ7J
	 LQlrtz1WSJpeA+WWyRc+Cx72IJNEtj/RGsdqEH0amOb3CmSxcRqdL3cR+JePbDdGP5
	 4CjEp8+HWawtAAfMuDoOvJoFoX0+vcM126BGtjRlpYwSYDljQWebf3WO7w74Tad4wR
	 PIeE9yTGoOPJXgFhK9jCqrzlk1j4MzcqXQKvaENqdzdiLFC/PvrpFF7/BwUAcelgKw
	 jOQei9Tvju6qHw8Yj4XdijooVmJH7NVYvlUvMquQDLHUOBfItDp9HF+eEy3XSdnUhf
	 4WWGxbr5IwPIQ==
Date: Mon, 26 Oct 2026 12:11:45 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: NXP S32 Linux Team <s32@nxp.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, 
	Joao Pinto <Joao.Pinto@synopsys.com>, Hannes Reinicke <hare@suse.de>, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, imx@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org, clizzi@redhat.com, 
	aruizrui@redhat.com, eballetb@redhat.com, echanude@redhat.com, 
	Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 07/10] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <20261026-beneficial-authentic-bonobo-a59b7c@quoll>
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
 <20261024122533.3609180-8-larisa.grigore@oss.nxp.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261024122533.3609180-8-larisa.grigore@oss.nxp.com>

On Sat, Oct 24, 2026 at 02:25:30PM +0200, Larisa Grigore wrote:
> Document the UFS host controller on the NXP S32N79 SoC.
> 
> Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
> Reviewed-by: Frank Li <Frank.Li@nxp.com>

How this could appear in v1?

Also, your SoB is the last one.

> ---
>  .../bindings/ufs/nxp,s32n79-ufshc.yaml        | 65 +++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> 
> diff --git a/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> new file mode 100644
> index 000000000000..14291c5506f1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
> @@ -0,0 +1,65 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/ufs/nxp,s32n79-ufshc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP S32N79 Universal Flash Storage (UFS) Controller
> +
> +maintainers:
> +  - Larisa Grigore <larisa.grigore@oss.nxp.com>
> +
> +properties:
> +  compatible:
> +    const: nxp,s32n79-ufshc
> +
> +  reg:
> +    items:
> +      - description: UFS Host Controller registers
> +      - description: System Control Module registers
> +
> +  reg-names:
> +    items:
> +      - const: ufshc
> +      - const: scm
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: core
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - clocks
> +  - clock-names
> +  - operating-points-v2
> +
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ufshc@4ac80000 {
> +        compatible = "nxp,s32n79-ufshc";
> +        reg = <0x4ac80000 0x1000>, <0x4ac40000 0x1000>;
> +        reg-names = "ufshc", "scm";
> +        interrupt-parent = <&irqsteer_coss>;
> +        interrupts = <211>;
> +        clocks = <&clks 0x92>;
> +        clock-names = "core";
> +        operating-points-v2 = <&ufs_opp_table>;
> +
> +        ufs_opp_table: opp-table {
> +            compatible = "operating-points-v2";
> +
> +            opp-0 {
> +                opp-hz = /bits/ 64 <0>;

Why is this empty?


Best regards,
Krzysztof

