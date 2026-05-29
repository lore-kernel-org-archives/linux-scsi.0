Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F507E792;
	Fri, 29 May 2026 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780073908; cv=none; b=ux8Y1ePy569IsqK3BKaCxeFLupNbaqogWrvs3SaN6Eu0DGzHXG/s6MFr+99kYuH3dgIwYWl5Nv2E1jGTyJuURw+VVgnZF8qktXxX5yLqYuY+tp7vc2BtTHSJQOc6mAtmgcwQPlmOt1MGzx0f3Rz/14Ss1P6FFYKZUsHxLikatzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780073908; c=relaxed/simple;
	bh=DI5s+Qlb5cV8ThCHfzB7N3JjJbgH01aqV0lO9k9vKPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpS6Id0WkKPJxEUxjbBjxapBweB1/nLpSaAMuouFwFj0B4vavKEOB00wm9TCQAuPuEJVgXh9lHVmbEl9ToKEdlj4l/lZf6SvaiwA0babFpFjYYEahDTIh7ctrRI/n87u6S/euejagngml5mltqQHYQciD20ouaOB9RgECKavP6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcdEd8KI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcdEd8KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794101F00893;
	Fri, 29 May 2026 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780073907;
	bh=Rr93txAorkGK4w7kSiV9wcRvir3FWXid5u8/S3kOYh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YcdEd8KIrgqEjIJyzfEWp3wxA2BOaPQFdZlliH+hhKlBpjybWVcwk0zVC6bgK5YTR
	 RmnqI08n1+vYEJMy4t8kaL28I/0vBbs8kisVrBWt4MBPRPPKVXK8zs4hov/GJ/al6F
	 AHt9PSSgT3oGgXaSXqe6NxsSK0q4PYe4GSO/3OyZMhBdkmr5XdhUmDf/OazuTy8zIM
	 pZmWz+Hx9kJHzKe6wH3BejyNDN0Vzad/IOXlRwj7othy/nDthuEY4IAlgp7pNCl3Zc
	 +eyfImujLBctVUARngY8my0TXcuI3qqcT5R5XiB4jgJHik3fElcHZ3O35fGpKUW+Uz
	 j1DqtFpAdUTVA==
Date: Fri, 29 May 2026 18:58:24 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com, 
	martin.petersen@oracle.com, mani@kernel.org, linux-scsi@vger.kernel.org, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Zhaoming Luo <zhml@posteo.com>, 
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>, 
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>, 
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v6 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
Message-ID: <20260529-neat-bright-shellfish-eab5e8@quoll>
References: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
 <20260529113338.984301-2-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260529113338.984301-2-can.guo@oss.qualcomm.com>

On Fri, May 29, 2026 at 04:33:37AM -0700, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro v3.0
> and M-PHY v6.0. In these specs, TX Equalization is defined for all High
> Speed Gears (not only HS-G6) to compensate channel loss and improve signal
> integrity at high speed operation.
> 
> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
> required depending on channel characteristics.
> 
> Add vendor-neutral DT properties:
> 
> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
> - fixed property tx-precode-enable-g6
> 
> Each property is a uint32 array of per-lane tuples:
> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
> 
> Accept 2 or 4 values (x1/x2 lane configs). PreShoot and DeEmphasis values
> are 0..7. Precode enable values are 0/1 and only applicable to HS-G6.
> 
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/ufs/ufs-common.yaml   | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> index ed97f5682509..d90cf25adfa5 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -105,6 +105,51 @@ properties:
>        Restricts the UFS controller to rate-a or rate-b for both TX and
>        RX directions.
>  
> +  tx-precode-enable-g6:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    oneOf:
> +      - minItems: 2
> +        maxItems: 2
> +      - minItems: 4
> +        maxItems: 4
> +    items:
> +      enum: [0, 1]
> +    description: |
> +      Static TX Precode enable values for HS-G6 only.
> +      Values are specified as per-lane tuples:
> +      <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].

You need to include them in any of applicable examples, otherwise
nothing here is validated.

Why values cannot be on or off? Or even better: why you cannot just list
all the lanes which has it enabled, assuming disabled is by default?

> +
> +patternProperties:
> +  "^txeq-preshoot-g[1-6]$":
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    oneOf:
> +      - minItems: 2
> +        maxItems: 2
> +      - minItems: 4
> +        maxItems: 4
> +    items:
> +      minimum: 0
> +      maximum: 7

What is the meaning of values? Nothing here refers to the spec, so is
this driver specific?

Best regards,
Krzysztof

