Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79E5349CF2;
	Thu,  2 Jul 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783012933; cv=pass; b=UCnpsioRfjlHJzqGKY/X4zeiblILh+m9F0FqixAehAf1l3qLFDElJglA9dDBMs2AZ0rhZdQxqQ26Rz6qhcjMkjG8/iCJ7BuDLB0rnHhraXunUaYiRlRw20BMa+fkG1jgeZL+i4xTnFXM4B6OvDE4eRBCR4FNNQlp9fNYBFX+ao4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783012933; c=relaxed/simple;
	bh=WKXl5DNRTgzt+SOnpU70QjMbXzXMWWllLiITV91acYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I90mUcbihD88arxiWEGQahu/yi1alfpsFb1je28qasaRA6ayVPh1o5TFQNL9sSzzoJ3ijwgJvbs9uZHTpuNrlpLZg4wC+WQCvgiAR3Xezbwd8oGLbv4WC9lHtEGiIFzuSEocOJA42R8MsBvSJX95kHzcF9oJHS5nzUjSQNRaMeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ziyao.cc; spf=pass smtp.mailfrom=ziyao.cc; dkim=pass (1024-bit key) header.d=ziyao.cc header.i=me@ziyao.cc header.b=GyeG/Lbv; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ziyao.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziyao.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ziyao.cc header.i=me@ziyao.cc header.b="GyeG/Lbv"
ARC-Seal: i=1; a=rsa-sha256; t=1783012899; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=JHbhhu4+gy/a0FtQBodKmH8tfye9dtnI1bra6MNmLaCFkNqrb6FXQm+VYdeZBVT1XDPEzGR+7i/ylQHeq2Oa2tgpQ+uOuURs5SAAeZPLdm7RqW4j6QEIvUgCmCfb/emvoiH8kDK4XAD0liQ4DojFCNT1i018rJGIqegCfkqAk2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1783012899; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=3pNo6VHmqaTxuE9Yer6GmVl/yimS+PJKHFrww1qNWgY=; 
	b=OFguuJ8cZm/Z2FXaJI8Xjy5LXQWg71bg1+t2pLK8ialmgDWF5vwlUBuZlJJpApz39jT27oiMKHfEFibUxg7grafkn3BmhAsgpuNMOFXAeyCuaVhJeqmUtYNJNYBZDhyc6AvIhXR4nuPA/KqLbEBvrkQjQZlHzxr6FbBgIpdpP7U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ziyao.cc;
	spf=pass  smtp.mailfrom=me@ziyao.cc;
	dmarc=pass header.from=<me@ziyao.cc>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783012899;
	s=zmail; d=ziyao.cc; i=me@ziyao.cc;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=3pNo6VHmqaTxuE9Yer6GmVl/yimS+PJKHFrww1qNWgY=;
	b=GyeG/LbvT2GVo1Bb8LvkcalxaeCk2VKhcP9DZy7NKFE0TZ3C8Uokxn91yfyBo/RR
	aK45+fEeyVHJXFO2ePAQhUUZVr3s7ZCG8b+XbFNxhaVerhRczGNuJqZTER5j5zOWOUr
	+AG0Va499glfZqqM6lkE9WYO+Ab1ZBbhbqC/nNKQ=
Received: by mx.zohomail.com with SMTPS id 1783012895431464.9970225222668;
	Thu, 2 Jul 2026 10:21:35 -0700 (PDT)
Date: Thu, 2 Jul 2026 17:21:08 +0000
From: Yao Zi <me@ziyao.cc>
To: Yixun Lan <dlan@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org, Yao Zi <me@ziyao.cc>
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <akaeBJv5T3YmlfpC@pie>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
X-ZohoMailClient: External

On Thu, Jul 02, 2026 at 02:31:36AM +0000, Yixun Lan wrote:
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
> 
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  drivers/ufs/host/Kconfig        |  12 +
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-spacemit.h |  90 ++++
>  4 files changed, 1034 insertions(+)

...

> +static int ufs_spacemit_wait_mphy_pll_lock(struct ufs_hba *hba)
> +{
> +	int timeout = MPHY_PLL_LOCK_TIMEOUT_US;
> +	u32 val;
> +
> +	while (timeout-- > 0) {
> +		val = ufshcd_readl(hba, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +		if (val & MPHY_PLL_LOCK_BIT)
> +			return 0;
> +
> +		udelay(1);
> +	}
> +
> +	dev_err(hba->dev, "M-PHY PLL lock timeout\n");
> +	return -ETIMEDOUT;
> +}

Could this loop be replaced by read_poll_timeout() like

	read_poll_timeout(ufshcd_readl, val, val & MPHY_PLL_LOCK_BIT,
			 1, MPHY_PLL_LOCK_TIMEOUT_US, false, hba,
			 UFS_PHY_MSG_BASE + UFS_MPHY_PU_CTRL);


...

> +/**
> + * ufs_spacemit_init - init phy and prepare clk
> + * @hba: host controller instance
> + */
> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> +	int err = 0;
> +	struct device *dev = hba->dev;
> +	struct ufs_spacemit_host *host;
> +
> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	host->rst = devm_reset_control_get_optional_exclusive_deasserted(dev, NULL);

"resets" property is marked as required in the binding, but the optional
API is used here. Is this expected?

...

> +/**
> + * ufs_spacemit_hce_enable_notify - Configure HCE enable sequence
> + * @hba: host controller instance
> + * @status: notification status (PRE_CHANGE or POST_CHANGE)
> + *
> + * Configures host controller enable with proper sequencing.
> + * Handles crypto enable if supported.
> + *
> + * Returns: 0 on success
> + */
> +static int ufs_spacemit_hce_enable_notify(struct ufs_hba *hba,
> +					  enum ufs_notify_change_status status)
> +{
> +	struct ufs_spacemit_host *host = ufshcd_get_variant(hba);
> +	u32 enable_val, val;
> +
> +	if (status == PRE_CHANGE) {
> +		enable_val = CONTROLLER_ENABLE;
> +
> +		if (hba->caps & UFSHCD_CAP_CRYPTO)
> +			enable_val = CRYPTO_GENERAL_ENABLE | CONTROLLER_ENABLE;
> +
> +		if (!host->first_hce_done) {
> +			host->first_hce_done = true;
> +			dev_dbg(hba->dev, "First HCE enable\n");
> +		} else {
> +			val = ufshcd_readl(hba, REG_CONTROLLER_ENABLE);
> +			if (val == enable_val) {
> +				ufshcd_writel(hba, enable_val & (1 << CONTROLLER_ENABLE),
> +					      REG_CONTROLLER_ENABLE);
> +
> +				while (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) ==
> +				       (enable_val & (1 << CONTROLLER_ENABLE)))
> +					;

Shouldn't we set a timeout for the polling loop?

> +			}
> +		}
> +	}
> +
> +	return 0;
> +}

Regards,
Yao Zi
