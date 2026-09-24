Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB89403E9C;
	Thu, 24 Sep 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263590; cv=none; b=iVJeVpTd19mzOg20fTYNffch13EffJgYT8NTfd5a+oenZxtsr2YFf5CxNXkfXZnvNOQDYDMaZYhj0en7TigjqXuxy0XD+7AP/RHcCnV1J+NRxBr703Yu5aUxUFrMYvNtLO+agZppWUOw3DFWKqefwYl4DKCy8IAKAIao4H+yhu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263590; c=relaxed/simple;
	bh=sqa6heNwqq82HXn3ZvSdMB3JNnhMkau2Y8tXg0FJADs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6YgXkZaAh+hjbDjhQZAydIMQG5FeanYYuYHcGbUcn5ZPp22n7KzZjqM7t9Syi/5ZE/x6QbVoBSEaWnK7BC9TOakgVsqGJb8ZmyqokYCFCTj7l+vT1rKDcljvTgj1iDozDcgtgDkTDYJgg14BaYJ2gY/JuQgpZ5Hc7Y3glfxE40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmWeZ3ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmWeZ3ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0631F000FF;
	Thu, 24 Sep 2026 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263588;
	bh=BtNwmCpwlATZL6+yLaXsqKa6VUJAOpqf/gk0N1LtqfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZmWeZ3udhfVDwkbdG7hmbVUamlOdwN1xRN6b1DIAHjkrRNINpNAEntqN2/gYcb6+c
	 DNyY5UcnsTtJXa4wSzaKR+XVzMSK/YPdatgbzLblwj05a82siMPo+H9MBFRXq0Muam
	 eMgLhELKWHIhSpr7ysCvDQi8XRfD3XKwJfozlir0/9nzPNNDpXYlC4pRB4nhZWrI6s
	 h7dti4Co9Cr9IQI+b/4fsC+pahOTduY/nbbYLzEBYHvhGp3XEuUUKq8utqAbOGLLBy
	 cR842xGOsLypHmxaSz5ICKPqqSruMiz9dMI7BjjRzP62l641nWHjsBIcXIXEb5Sxdj
	 n4v2zzcv9buTA==
Date: Thu, 24 Sep 2026 10:26:26 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Cc: Avri Altman <avri.altman@sandisk.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	linux-arm-kernel@lists.infradead.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>, linux-phy@lists.infradead.org,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Conor Dooley <conor+dt@kernel.org>, linux-scsi@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Chaotian Jing <chaotian.jing@mediatek.com>, kernel@collabora.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v12 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Message-ID: <179026358626.149119.4739305859668993061.robh@kernel.org>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-2-9279d7ef814d@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-mt8196-ufs-v12-2-9279d7ef814d@collabora.com>


On Mon, 14 Sep 2026 13:38:48 +0200, Louis-Alexis Eyraud wrote:
> From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> 
> As it stands, the mediatek,ufs.yaml binding is startlingly incomplete.
> Its one example, which is the only real "user" of this binding in
> mainline, uses the deprecated freq-table-hz property.
> 
> The resets, of which there are three optional ones, are completely
> absent.
> 
> The clock description for MT8195 is incomplete, as is the one for
> MT8192. It's not known if the one clock binding for MT8183 is even
> correct, but I do not have access to the necessary code and
> documentation to find this out myself.
> 
> The power supply situation is not much better; the binding describes one
> required power supply, but it's the UFS card supply, not any of the
> supplies feeding the controller silicon.
> 
> No second example is present in the binding, making verification
> difficult.
> 
> Disallow freq-table-hz and move to operating-points-v2. It's fine to
> break compatibility here, as the binding is currently unused and would
> be impossible to correctly use in its current state.
> 
> Add the three resets and the corresponding reset-names property. These
> resets appear to be optional, i.e. not required for the functioning of
> the device.
> 
> Move the list of clock names out of the if condition, and expand it for
> the confirmed clocks I could find by cross-referencing several clock
> drivers. For MT8195, increase the minimum number of clocks to include
> the rx_symbol ones, as they're internal to the SoC and should always
> be present, and should therefore not be omitted.
> 
> MT8192 gets to have at least 3 clocks, as these were the ones I could
> quickly confirm from a glance at various trees. I can't say this was an
> exhaustive search though, but it's better than the current situation.
> 
> Properly document all supplies, with which pin name on the SoCs they
> supply. Complete the example with them.
> 
> Also add a MT8195 example to the binding, using supply labels that I am
> pretty sure would be the right ones for e.g. the Radxa NIO 12L.
> 
> Finally, remove the 'ufs_' prefix from all clock names containing it
> and rename 'ufs' clock to 'main'.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
> ---
>  .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 115 +++++++++++++++++----
>  1 file changed, 96 insertions(+), 19 deletions(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

