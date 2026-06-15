Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3F53E4519;
	Mon, 15 Jun 2026 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522776; cv=none; b=LMt53Ljv5ksuuerlN5DyJAZVzhft1w1yxZC5nbt8mPDPR/I7RDsIbe8dabUSZI4wiJZyQpGaU4CQpNmRRb29rShFbANFWVJyWdHMuySRKSxlOZLI2c1STqjcm42qPQAtRfPTKujbVeBp2HZXCd+yH80odQQss4yC0dQtr5W2BkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522776; c=relaxed/simple;
	bh=50rTYE6DTwOfJ1L3FKIi5qxwqDTG+KHLwGsAAM4DvpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SQQss8Y9imFpTcX315YtJFK76A9ydGsHMU4Ah+heN013Rw+9SzU0/9MNQsWIzxgB5WSviM1hc0qI3w2Cc45Jz4+TLxPjkJ1a3UnYaXmAIW/sjVUrmccmOBJoeUvTfjHgnjR5moHWs6c1jE2h704haBHScfpQ7xhAQOFUUjamCP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cdb8kenC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cdb8kenC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87051F00A3A;
	Mon, 15 Jun 2026 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781522775;
	bh=4tfI640HQlxM02Fv4lCeLHOEUDwDAWi0qaHz5zFkTw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cdb8kenCBsj6o/pnQykpthWp/Cfru57Uh0g79UcGwxAg0bIPH3FUcLlzmk2Z2n3fq
	 hGTK3MgzkzUxh9+gVAFwwNsX7uyA+fkN5fwazanlBFTFJw9OzRY3y6kPBs12Nogwy8
	 Ee8qORkK/6qV4G3eHb/NqGb8KHcDTWweCHvU22TSnbmRaVjJpHngGEYfivw7HALS1u
	 MZTiFIKrGhDWlReOfICuu16uNBwAUr6AKNjsOgE8XEZzNBFjyqKsfX+9atC/41kpGy
	 turesqfJDWZJNapjyqQDOW8bFIRwhjaGze9IEZZm+xMMBS4CxUKrFDZ1J7ofKLgiGP
	 rLzAqpR5thj5g==
Message-ID: <8ee6bfe0-71aa-4d3a-a583-f7495a86fc58@kernel.org>
Date: Mon, 15 Jun 2026 13:26:07 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org,
 beanhuo@micron.com, peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
 Zhaoming Luo <zhml@posteo.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260615085027.2102882-1-can.guo@oss.qualcomm.com>
 <20260615085027.2102882-2-can.guo@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260615085027.2102882-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/06/2026 10:50, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 adds HS-G6 support (46.6 Gbps/lane) via UniPro
> v3.0 and M-PHY v6.0. These specs define TX Equalization for all
> High-Speed Gears (not only HS-G6) to compensate channel loss and
> improve signal integrity at high speed.
> 
> For HS-G6, M-PHY uses PAM4 1b1b line coding. Pre-Coding may also be
> required depending on channel characteristics.
> 
> Document vendor-neutral properties in ufs-common.yaml:
> - txeq-preshoot-g[1-6]
> - txeq-deemphasis-g[1-6]
> - tx-precode-enable-g6
> 
> Values are per-lane Host/Device tuples (2 values for x1, 4 values for
> x2). PreShoot/DeEmphasis range from 0..7, and Precode is 0/1.
> 
> These are board-specific signal-integrity tuning values. They depend on
> channel SI/PHY characterization and validation (host PHY, device PHY,
> package, and board routing), and are determined by HW/PHY designers.
> 
> Although UFSHCI v5.0 supports TX Equalization Training via UniPro v3.0,
> which allows host software to determine optimal TX Equalization at
> runtime, static board-specific TX Equalization settings in the Device
> Tree are still necessary because:
> - TX Equalization Training is not supported for HS-G3 and below
> - TX Equalization Training is disabled on some platforms
> 
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/ufs/ufs-common.yaml   | 55 +++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> index ed97f5682509..145a6416e1df 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -105,6 +105,61 @@ properties:
>        Restricts the UFS controller to rate-a or rate-b for both TX and
>        RX directions.
>  
> +  tx-precode-enable-g6:
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    oneOf:
> +      - items:
> +          - description: Host_Lane0 precode
> +          - description: Device_Lane0 precode
> +      - items:
> +          - description: Host_Lane0 precode
> +          - description: Device_Lane0 precode
> +          - description: Host_Lane1 precode
> +          - description: Device_Lane1 precode
> +    items:
> +      enum: [0, 1]
> +    description:
> +      Static TX Precode enable values for HS-G6 only.

My bad here, that was my mistake. I wanted matrix, but gave you array
syntax. Proper code would be:

  tx-precode-enable-g6:
    $ref: /schemas/types.yaml#/definitions/uint32-matrix
    minItems: 1
    items:
      - items:
          - description: Host_Lane0 precode
            enum: [0, 1]
          - description: Device_Lane0 precode
            enum: [0, 1]
      - items:
          - description: Host_Lane1 precode
            enum: [0, 1]
          - description: Device_Lane1 precode
            enum: [0, 1]
    description:
      Static TX Precode enable values for HS-G6 only.


I tested it with DTS and seems to work fine. Please use the same for
other properties, but enum will be 0-7.


Best regards,
Krzysztof
