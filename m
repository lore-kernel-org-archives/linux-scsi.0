Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CAD34C154;
	Tue, 23 Dec 2025 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766511571; cv=none; b=MDIfGQip+pGQ86t1r80LeT+lI+/hCSSYYGWUVvqcy0TQXBbnJLhtKJTZq44txNLsq5w1LKnDnm+oChiy84+DvmoZvsijbVUh5g8b6kyU8gEpztheEKR3NznlxhdTppJhMLqf73VrZTXFnKRPoecuYV4qAz5uq/q1EID/k08wCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766511571; c=relaxed/simple;
	bh=KUk687OabAJl/uv6mcRXHoNsZi+kIRMZGZV2/PLoA3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4m3FQbdzBgfplbGWk6SievSFfmkssAXKCJBoUqIkxKsFVYca3EmfgSbWsHJGUCttYJLAT2+Cap2Wm72SOj+JxeDsitW/zQJ0/h2kKP7cL4vukVZDL+EXIQM9Po2bUoUbNKxdYAYTqVVTI/fQmqUlAwwn5xUNaye2yo/Y2azlXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKRE5Mhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKRE5Mhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F404C113D0;
	Tue, 23 Dec 2025 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766511570;
	bh=KUk687OabAJl/uv6mcRXHoNsZi+kIRMZGZV2/PLoA3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vKRE5MhpHI/17lN/HmYIJFtu6YXP9mbJvZs8xoNaHfOkMrbxLUvbY01T37bKsudwt
	 127ybJiyP8FthMQtjDRE8NjBH8CSVjuK6lf/tLOqe+tNfBfU2rAsJthByRcCGLuPCY
	 JC1pRmYNPzmp24DAGdCI3m3BGv2Dn60Hk6TXgtzHUfYfYe6o7TyOJMRpsaBTOgE5To
	 /34UrQuETQtkD8rUcjJVhqXD150mzcKDau6/GZ5YDg46H/NGoPz3/X5j1jD1R+Fdnh
	 lmKf5jvPiWdeS18wGHiWJj7AaTHseV+PrmrbDrsYZNML4RPKKdqP4rualafwHcIM11
	 eD1ZX8BXEj6Lw==
Date: Tue, 23 Dec 2025 23:09:27 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
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
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH v4 02/25] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
Message-ID: <aUrTz1xf0t3uxoJD@vaman>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-2-ddec7a369dd2@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218-mt8196-ufs-v4-2-ddec7a369dd2@collabora.com>

On 18-12-25, 13:54, Nicolas Frattaroli wrote:
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
> the crypt and rx_symbol ones, as they're internal to the SoC and should
> always be present, and should therefore not be omitted.
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

Acked-by: Vinod Koul <vkoul@kernel.org>


-- 
~Vinod
