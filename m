Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8274429B781;
	Fri,  6 Mar 2026 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772814787; cv=none; b=KO6ozikKAnzDchMaKpu8IY4fBOEgDhLQiS4yVxlqZf3L43moiQVf1V5fx6aiaIbxQXitzioR3E9DU6HDG/59KMGxg2O5AFSzLxTBdRUwJaZcW1CsMOCxLLcwxo2gask5+Gxls4qbNL4LBp5w912fcNPcVlid0z0HQDzPFP/sgzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772814787; c=relaxed/simple;
	bh=CnQoePDGbm0PHXBOJYOu5eMNk8PFbwki0J91SPH+ipw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBPwdKtodLorY6HcUUXGS3AN+ihWeSLB/DweI5yv6hoxg00DbtSRXh0zLqGh5UwsziPDSvFw2LIfudY6rJr4G1AjzoubkT7bPXxhL9m/UGcgD3ky8XgfRwgFNmsB6itZNJvIUtFoF8RznKgBCj/pLFiqlhW4XVyAapxcAFK5NH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfhEK+zV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfhEK+zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC168C4CEF7;
	Fri,  6 Mar 2026 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772814787;
	bh=CnQoePDGbm0PHXBOJYOu5eMNk8PFbwki0J91SPH+ipw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CfhEK+zVvjIgeRlPT1wuB79AM2+Dd9id+GxlsrUhswzSVDVUu9UDDm4qe2NH9faZG
	 9H1TXikDsT4sJaDwGccf/iVUWw1WaLTxkkO5CtoF6payK6po9/yuH3tALljqDQBrnh
	 qI+ZmpGDndHmXj60/uJMWHmrWkVwRhNHKVIlSOnAE0ZEXhW4QnGHTpdcm29b5sKceW
	 wS58IrVfEBLrFojjoFgbGC4bvmXP2TJCpE3FfalC7meebPH8WyEfQpfGAtVd55i5pf
	 B8FYa3oY6Sgq+SWcqf1mDZ+H49BzKN42/3/e03c0lTfooVRXt7laYoN6DoDk/6KRYH
	 fOJ+dWIRF9Yog==
Date: Fri, 6 Mar 2026 10:33:05 -0600
From: Rob Herring <robh@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
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
	Chaotian Jing <Chaotian.Jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	kernel@collabora.com, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v9 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Message-ID: <20260306163305.GA2680515-robh@kernel.org>
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
 <20260306-mt8196-ufs-v9-3-55b073f7a830@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-mt8196-ufs-v9-3-55b073f7a830@collabora.com>

On Fri, Mar 06, 2026 at 02:24:44PM +0100, Nicolas Frattaroli wrote:
> The MediaTek MT8196 SoC's UFS controller uses three additional clocks
> compared to the MT8195, and a different set of supplies. It is therefore
> not compatible with the MT8195.
> 
> While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS pin,
> it appears that these two pins are commoned together, as the board
> schematic I have access to uses the same supply for both, and the
> downstream driver does not distinguish between the two supplies either.
> 
> Add a compatible for it, and modify the binding correspondingly.
> 
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Acked-by: Vinod Koul <vkoul@kernel.org>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
>  .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 58 +++++++++++++++++++++-
>  1 file changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> index e0aef3e5f56b..a82119ecbfe8 100644
> --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> @@ -16,10 +16,11 @@ properties:
>        - mediatek,mt8183-ufshci
>        - mediatek,mt8192-ufshci
>        - mediatek,mt8195-ufshci
> +      - mediatek,mt8196-ufshci
>  
>    clocks:
>      minItems: 1
> -    maxItems: 13
> +    maxItems: 16
>  
>    clock-names:
>      minItems: 1
> @@ -37,6 +38,9 @@ properties:
>        - const: crypt_perf
>        - const: ufs_rx_symbol0
>        - const: ufs_rx_symbol1
> +      - const: ufs_sel

"ufs" is redundant as all the clocks are for UFS. Same comment on prior 
patch.

> +      - const: ufs_sel_min_src
> +      - const: ufs_sel_max_src

"src" sounds like a parent clock? If so, probably shouldn't be in the 
clocks list. 'assigned-clocks' is for dealing with parent clocks.

Rob
