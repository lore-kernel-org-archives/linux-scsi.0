Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8552E406;
	Mon, 21 Jul 2025 00:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753057595; cv=none; b=IZZu2R2kyZD13s0ZtwpfjliHjxfU698ioEWEjYJ78bk9e4oMyrHTnoBUfL9ysQ+4Jau3I2Sr+JNokrmZm/eb5FCLo5O6M9xlxrIzX3R02M5yE+1P+Wrh11Gb5jhBdyAaD3S4czw/qa6xsetq734OKp8k07A4IDYyIXlDScGlr5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753057595; c=relaxed/simple;
	bh=2jXD6fV2pi4XdodBU4IjziGtCooOyqc6QbykipInwFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCam2HEPPUcVJTCAweVx8AbTgKVh8qtv0xVtQj0ANWCa2ALjZoaCXnYLurkofrIXqd+vZkw886qcxfiddih/RS0mV8rpvovEtGIzI6NA8V/a5Q+3EDaXTAaXhlBAqa/LORkyhOjmaZHOcRa5RisOiYNn0ptq2Tlu3LOLliZMCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdcfoYAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdcfoYAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CF0C4CEE7;
	Mon, 21 Jul 2025 00:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753057594;
	bh=2jXD6fV2pi4XdodBU4IjziGtCooOyqc6QbykipInwFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XdcfoYAMJGyOpwexECJfGYYaLJpKEJYaYhR7Ve456pp1Mu/xlx0GKy77EaNihR0qP
	 bbNTuZ8BdR8SrB7V52lvnWlaWytC0BjVLaKfuxfcrSlflGZfDVJ6uQjJDyfd26XiJi
	 fMa6nsR62qdGsIU+RMMsX1MTLVFKYZXHrT8eF36Hyv0351dK7+Nd14tTw0KWxznmaW
	 Hy0UXyrAlM0GzSVNTcvup5NX/GBBqXfVt77RpIkmxeK52AdeepglwFzNzr+f3/QPAW
	 XC89vjEWEpVDy8wdkBiDimVW/g9fiPtALjYmQYNvSslUw06gfM2CWvRgQtzjWaELm7
	 OKLrf9nnyB8Qw==
Date: Sun, 20 Jul 2025 19:26:33 -0500
From: Rob Herring <robh@kernel.org>
To: Macpaul Lin <macpaul.lin@mediatek.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	openembedded-core@lists.openembedded.org, patches@lists.linux.dev,
	stable@vger.kernel.org, Bear Wang <bear.wang@mediatek.com>,
	Pablo Sun <pablo.sun@mediatek.com>,
	Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul@gmail.com>,
	MediaTek Chromebook Upstream <Project_Global_Chrome_Upstream_Group@mediatek.com>
Subject: Re: [PATCH 2/3] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Message-ID: <20250721002633.GA3083612-robh@kernel.org>
References: <20250718082719.653228-1-macpaul.lin@mediatek.com>
 <20250718082719.653228-2-macpaul.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718082719.653228-2-macpaul.lin@mediatek.com>

On Fri, Jul 18, 2025 at 04:27:17PM +0800, Macpaul Lin wrote:
> Add 'mediatek,mt8195-ufshci' to compatible list.
> Update clocks and clock-names constraints to allow one to eight entries.
> Introduce 'mediatek,ufs-disable-mcq' property to disable
> MCQ (Multi-Circular Queue). Update conditional schema for mt8195
> requiring eight 'clocks' and eight 'clock-names'.

Don't just describe the diff, we can read it. Describe why you are 
making the changes. How is the new h/w different (or the same).

> 
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> ---
>  .../devicetree/bindings/ufs/mediatek,ufs.yaml | 49 ++++++++++++++++---
>  1 file changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index 32fd535a514a..9d6bcf735920 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> @@ -9,21 +9,20 @@ title: Mediatek Universal Flash Storage (UFS) Controller
>  maintainers:
>    - Stanley Chu <stanley.chu@mediatek.com>
>  
> -allOf:
> -  - $ref: ufs-common.yaml
> -
>  properties:
>    compatible:
>      enum:
>        - mediatek,mt8183-ufshci
>        - mediatek,mt8192-ufshci
> +      - mediatek,mt8195-ufshci
>  
>    clocks:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 8
>  
>    clock-names:
> -    items:
> -      - const: ufs
> +    minItems: 1
> +    maxItems: 8
>  
>    phys:
>      maxItems: 1
> @@ -33,6 +32,11 @@ properties:
>  
>    vcc-supply: true
>  
> +  mediatek,ufs-disable-mcq:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description: The mask to disable MCQ (Multi-Circular Queue) for UFS host.
> +    type: boolean

Seems this was undocumented, but already in use. That should be a 
separate patch.

> +
>  required:
>    - compatible
>    - clocks
> @@ -43,6 +47,39 @@ required:
>  
>  unevaluatedProperties: false
>  
> +allOf:
> +  - $ref: ufs-common.yaml
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt8195-ufshci
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 8
> +          maxItems: 8
> +        clock-names:
> +          items:
> +            - const: ufs
> +            - const: ufs_aes
> +            - const: ufs_tick
> +            - const: unipro_sysclk
> +            - const: unipro_tick
> +            - const: unipro_mp_bclk
> +            - const: ufs_tx_symbol
> +            - const: ufs_mem_sub
> +    else:
> +      properties:
> +        clocks:
> +          minItems: 1

1 is already the minimum. Drop.

> +          maxItems: 1
> +        clock-names:
> +          items:
> +            - const: ufs
> +
>  examples:
>    - |
>      #include <dt-bindings/clock/mt8183-clk.h>
> -- 
> 2.45.2
> 
