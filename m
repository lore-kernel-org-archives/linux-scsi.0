Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B313F1AA2;
	Thu, 11 Jun 2026 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781184740; cv=none; b=t6iZCJgY2zh4nTVTMdAXVx65SbjtQ4W8HmzNN9aE9NWeG8NKPG8O5xseKCB0oIaZ/9rfYxUXJ1efdrVboobDiStmHXoNXN3p26jkgO5kBSLTDHH3RpdlkaANloWlDhLgT/k/SjEwD3fygNTuUFaY86szoTOHsrVWVPh2xXqcNkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781184740; c=relaxed/simple;
	bh=8K88X6Tpy2PUuNDPzIMi2sx6p+wjeczgy9PIgrKHjzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cl/ukAHISpuNeWys955Ugw4WPYRWVfwAXpDWImmFFTZd/oWh/T7HkEj+D96Bj2myU++p1J0oocgMbH94hxO/rV6Gtitiom8+aOBcgMbtIIxpRwOC2uK/b+3mBwkqP1lFfEpUFZIr3dDz2tH6nLPjuf5P8DXJ98P/7WyMgHSBqv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZKtCYX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZKtCYX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7B01F00893;
	Thu, 11 Jun 2026 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781184737;
	bh=t6ygODEcYQRK3LRl7Bh7Ro1VxZWR/umueHAQE66vTro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SZKtCYX6inzgVsELbyLK2Ps0br8TUhBVEuPwkE1URkmdB5Z0j7LCeltY8EDuwcFKO
	 P1C1DSBemMAZ/i/ZegedjKneaJyQc40qG0Oxj1WL2FrGB60bWSi/3+BQH5r0ty8V7E
	 0xxyroMJZN49IX+qoy3H067d4j/NJvNWRHXQa6WLjYBWHwCO9Titf16HMQ22VMLjJe
	 d6u8Sj7K5GNFUVmW8yFaWwKGi8plR0T6IHM1bc0W5WLBuPFtDIJk80F9gOQKC9GWq9
	 TxwS+8V3wmIaQByuZCelHIU9u9PwHRJ7rVQDT6sX50wDse0QXaBHYD9cFRmL6Ap8ts
	 LNCz0ChnPgYdQ==
Message-ID: <b62e7f1a-bc13-442c-ad7b-0969e3b9073d@kernel.org>
Date: Thu, 11 Jun 2026 15:32:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org,
 beanhuo@micron.com, peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Zhaoming Luo <zhml@posteo.com>,
 Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
 <20260610071516.3763916-2-can.guo@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260610071516.3763916-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/06/2026 09:15, Can Guo wrote:
> UFS v5.0/UFSHCI v5.0 add HS-G6 support via UniPro v3.0 and M-PHY v6.0.
> These specs define TX Equalization for all High Speed Gears, and HS-G6 may
> also require TX precode depending on channel characteristics.
> 
> Document vendor-neutral DT properties in ufs-common.yaml:
> 
> - patternProperties for txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6]
> - tx-precode-g6-host-lanes
> - tx-precode-g6-device-lanes
> 
> txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6] accept per-lane tuples:
> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

Instead of repeating the diff, you should explain why these properties
are needed. Insufficient explanation was also pointed out at v1.

Why this cannot be deduced from the IP compatible? Does it depend on the
device memory? Who determines the values here and what do they depend
on? Also here you explain lack of auto tuning for example.

> 
> PreShoot and DeEmphasis values are 0..7 and accept 2 or 4 values for x1/x2
> lane configurations.
> 

...


> +      Lane indices for static Host-side TX precode enable settings for HS-G6
> +      only. Listed lanes have precode enabled; unlisted lanes are disabled.
> +
> +  tx-precode-g6-device-lanes:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 1
> +    maxItems: 2
> +    uniqueItems: true
> +    items:
> +      minimum: 0
> +      maximum: 1
> +    description: |
> +      Lane indices for static Device-side TX precode enable settings for HS-G6
> +      only. Listed lanes have precode enabled; unlisted lanes are disabled.


I need to reverse my opinion and let's go to v6 implementation. These
properties look more consistent in v6 with respect to preshoot and
deepmhasis properties.

You want actually matrix, so:

  tx-precode-enable-g6:
    $ref: /schemas/types.yaml#/definitions/uint32-matrix
    oneOf:
      - items:
          - description: Host_Lane0 precode
          - description: Device_Lane0 precode
      - items:
          - description: Host_Lane0 precode
          - description: Device_Lane0 precode
          - description: Host_Lane1 precode
          - description: Device_Lane1 precode
    items:
      enum: [0, 1]
    description:
      Static TX Precode enable values for HS-G6 only.

And similar style with items also for preshoot and deepmhasis.


Best regards,
Krzysztof
