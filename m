Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002DF49F127;
	Thu, 24 Sep 2026 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263628; cv=none; b=jMMFDUkZmsva88u8Y98CE7/Du3I4w5wsC/10oyYsUefEEdw4M2pJz0rXjOA0BtMNt1YJOzVPpP29x/gg1+PABNHwKPkhfHpSJjG3DVS4ZJbEX/yFa3y4HaFk7N1/8NbgwqdyfjzWw4FaNR9C0gLfla3/4z3tI1VPxpg8ysFQHXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263628; c=relaxed/simple;
	bh=8T+UNkzsMwwowRrOcEQQAEsxiHQ7E7NXDy9aJLksLaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knb6V0IHvHnyl9w5Og0Yy1ifBmcns7OdU61RVnvdASm66kZaCeAP8a8Iz23wGdYk7l6H1f9SGlKhthRb5PXxXjyslwjoNlwO6MYAmXL4bGU38dS379ryLPQUH87DoT0+YofMiT7BQ0Avvo95aEfF8S6aCT+5KVDmksBp4f6exvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a5dqRwRL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a5dqRwRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0431F00893;
	Thu, 24 Sep 2026 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263626;
	bh=zBgNSeAKy3V9+glxTJ9u0MSNETvwYObNm1rdwrrdkBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a5dqRwRL93QqwgSHbhAUOu0m78/vPnTDAi1chRy/CZASJetpaK0ln2X/uA6nAQEGT
	 I6dqVGptKhE4GHYQE87CvdqAESw8/56C81+kdUytU7UweHHXRH5yiARqKM7BYH3n2J
	 g6s7/zuIakZpPv3k518q2O7MdoVwP6cINUxbsf33tPPl8Mrm1134kY92zahoMwdA4t
	 elbQGOLDh+7+VqaWR9xVRZdVcPDx8DP7jxt98ujI2mr8Y2gCqvTIHNeOOfpMCQpcoM
	 UO7Ey57hD1iUhSRoIDaau/31H87iRlrLIUOGGBX3qIYnhQzuDIOFWBwWl+xsLXkreu
	 Oj1FchTVG1Wng==
Date: Thu, 24 Sep 2026 10:27:04 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Mark Brown <broonie@kernel.org>, linux-phy@lists.infradead.org,
	devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Stanley Jhu <chu.stanley@gmail.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	linux-mediatek@lists.infradead.org, kernel@collabora.com,
	linux-arm-kernel@lists.infradead.org,
	Peter Wang <peter.wang@mediatek.com>
Subject: Re: [PATCH v12 03/24] dt-bindings: ufs: mediatek,ufs: Add mt8196
 variant
Message-ID: <179026362398.156393.9411770952322426875.robh@kernel.org>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-3-9279d7ef814d@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-mt8196-ufs-v12-3-9279d7ef814d@collabora.com>


On Mon, 14 Sep 2026 13:38:49 +0200, Louis-Alexis Eyraud wrote:
> From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> 
> The MediaTek MT8196 SoC's UFS controller uses a different set of supplies.
> It is therefore not compatible with the MT8195. It also have an additional
> 0.9V supply pin (AVDD09_UFS_1), that is specific to this SoC, thus not
> currently described in the binding.
> 
> Add a compatible for this SoC and new property for the additional supply,
> and modify the binding correspondingly.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
> ---
>  .../devicetree/bindings/ufs/mediatek,ufs.yaml       | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

