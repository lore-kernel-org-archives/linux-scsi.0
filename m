Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E33C2782;
	Fri, 31 Jul 2026 08:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486540; cv=none; b=JELsuyKH9Y32zrDBCyhFvg8Mim96x+OXYd1D/CH8WE408zKQri2I2nZQHDvT/Iy5Nx2B8AFP06xUHQMnUWLHMe2NAX7cEo4M0iC/wEcRT4z7/2jtVk6oncczbsBS0uOBa2u0xkbwHHRVDe5mmKp9CwPbqjUPKvfvsEpzpbxAV8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486540; c=relaxed/simple;
	bh=uhnemfUJTcLe/+hR7xR2wNNCDkBngfdKbleD8QygFkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dupCl3K1hBb7wGMrDcOgDfaKSqJPeDhTqtL+zcxqkk9E5ff6Py879xBdUZVmDlncbxG/X5gWGXBsb485pyViZBQQb1hA1ME6/r7QXlOPWvJ9AGGSF+Nh+uImvWSPLOnVVqMYhQmurjSmWYcP5Pq1IYnO6JGMwuW7+Ha4JkWnUBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZuPFaCL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZuPFaCL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3EE1F000E9;
	Fri, 31 Jul 2026 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785486538;
	bh=RW5kVziQTvjwkaw1oQsd8tnJ2xMtqtixoMGra8Klios=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZuPFaCL9b7sQa5RwzaGkHA3yu+ywn9HIYZ+JoGm8T4pfCYXJay4OVqX3cVT004HPL
	 GeLIcVt4vlua8WLztiEeOiWnSv/HKW1j4dgSWUIG+egyqYBINVnoGj1wMouAvWAgBU
	 lVN3SsRdFZRHPIqam7TjSx/p2ANomVgMyHE4KTiXVkh/ZlTEfJmFzvhjh6lY+9nTCM
	 A9HUIU0cOR12gdhODdym06G14yHHP7doPVRAnZ/f+wQiGb3KfVf/vzWu9AJ251tsYc
	 dlUGbX8xcHj74YtGN+WNvVJURdConBDeEW5PB3F06vQd2+7lK4iFWhDuZ0k71HVY7S
	 UMdGlZK9XZ8fw==
Date: Fri, 31 Jul 2026 10:28:55 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Cc: Chunfeng Yun <chunfeng.yun@mediatek.com>, 
	Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Peter Wang <peter.wang@mediatek.com>, 
	Chaotian Jing <chaotian.jing@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Stanley Jhu <chu.stanley@gmail.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, kernel@collabora.com, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: Re: [PATCH v10 24/26] arm64: dts: mediatek: mt8195: Align ufshci
 node to dt-bindings changes
Message-ID: <20260731-curious-unnatural-octopus-cef3e9@quoll>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
 <20260730-mt8196-ufs-v10-24-bc5ecef202dc@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260730-mt8196-ufs-v10-24-bc5ecef202dc@collabora.com>

On Thu, Jul 30, 2026 at 11:49:20AM +0200, Louis-Alexis Eyraud wrote:
> The MT8195 UFS host controller dt bindings now describe several extra
> required clocks that were previously missing from clock description
> and deprecates the freq-table-hz property use in favour of
> operating-points-v2 instead.
> 
> Currently, the ufshci node declares the freq-table-hz property but all
> values contained in the array are zero, thus converting it to an OPP
> table is not needed.
> 
> So, add in ufshci node the rx_symbol clocks in clock list and remove
> freq-table-hz property.
> Also reorder properties in node.
> 
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
> ---
>  arch/arm64/boot/dts/mediatek/mt8195.dtsi | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)

DTS must not be combined with patchset targetting SCSI/UFS, because UFS
folks were grabbing entire thread. Please follow the same rules as when
submitting to USB, serial etc.

Best regards,
Krzysztof

