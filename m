Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794799994;
	b=mNPh8jNJY67lAuaK2T2ycx/tSDK9zVJIEI7EaeLqWIZ7tNPhCrq7EBY1qYmZbyammVep
	 fBY4RvZ636XOnVLKE7PGS2M6IVRGXLuKz+NZggclTsnSEUlAROJ/pd3nOWw0UbWMpiKlo
	 6QJXQtIBoh5hjGx8HcfkOZbb7PDWiYc4t+vX4IvEpmdlXs93M/4MgAhbT3FpRxTXawHJW
	 xDWkT6OhE/Mun1S2KIkQKwbj4/yPb+4RYMMN85vRxOXn2RQXDNy4k3T6lpuk72mLJmD0x
	 jlc86TXbruFgmkdxb32kpBCh3/FewBSRQ4Si+8Dl0EC0mh5A6Sw99XMAU5/w5U178qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794799994;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OPE33G7SD06+DnDSLnnFTSDvQB+tOQtgoL8bhY8tvWk=;
	b=kTTVMifDoME4jDRtn/WqtLcGGgCwk1oXyMzMUSSoUmrygbsJgFaQDuM8lAblqcN+eP01
	 QSfSv7MaVv3/L1O2ffo8/fRKAksVLFka+16YImyomy7PRQPAPqm9z4t4pdDzzL2bpJhpL
	 OqFqfiWVpSF/iW+d3XqmXKEImdbM04RQWIv9rrVaI4bPiKwPEFEmLFiCL9pcP1PO+HIKB
	 9bZulTs9aWtKHQ1dGPVK/UJY9+q5G0EagMMWERVra5U7ZO5eMQIB6I9CA4Lx2ZHk5tNGW
	 +iMArDh6E5H/3C50Uuv9Itew5QuHFI/vtXw+FMP5qUvbiu7gnDaHInQNbuqsvhRwxCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZ7uEN9M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA72606A321;
	Mon, 16 Nov 2026 03:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZ7uEN9M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8051F1F000C4;
	Mon, 16 Nov 2026 03:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794799994;
	bh=OPE33G7SD06+DnDSLnnFTSDvQB+tOQtgoL8bhY8tvWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eZ7uEN9MOKpfnFx8s84YYaOhtleet4CMC4iLiUwCaBB1dZWb4ZqsMjQpwwhpWDH0k
	 ncD/OBASmyI3a/HR3IfueunZLhQGHkMcec5lW7F8qMAG2B3ephI+QxoGsDRQI6zo0J
	 HFVqzbXtscM0nAoKVJ4gusbs3UpQL+n6BD3+bzVHxRn3TLlyz3nWkgOYesSBx7C04p
	 p5qc6W0SAhCi47cYmynCPoDig1hOOe4jFaueks0zPFPBhRcMPZBcSMxAEeOejKYSfV
	 SINgyGfOyObjhdN05qhtyOkOQ3vbfvwSKM4JFFxcMeIjXQWwBZKexi8HB7kN7d7/Rl
	 wAwfKRRrA/vUQ==
Date: Mon, 16 Nov 2026 03:33:11 +0000
From: Yixun Lan <dlan@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org,
	conor+dt@kernel.org
Subject: Re: [PATCH v7 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20261116033311-GKD100523@kernel.org>
References: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
 <20261002-08-k3-ufs-support-v7-2-bb39007ff9ae@kernel.org>
 <20261002091428.35D671F0089B@smtp.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261002091428.35D671F0089B@smtp.kernel.org>

hi all,

On 09:14 Fri 02 Oct     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] scsi: ufs: spacemit: 100ms timeout on 1-lane UFS devices during hibern8
> - [Medium] scsi: ufs: spacemit: bRefClkGatingWaitTime violation after hibern8 enter
> - [Medium] scsi: ufs: spacemit: simultaneous ref clock enable and reset de-assertion
> --
> 
> commit efcda2c96a818b5a53e91fa2558654c937a9ba68
> Author: Yixun Lan <dlan@kernel.org>
> 
> scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> 
> This commit introduces the UFS Host Controller driver for the SpacemiT K3
> SoC. It implements support for features compatible with JEDEC UFS 2.2, MIPI
> UniPro v1.61, and the M-PHY v3.0 standard.
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> 
> [ ... ]
> 
> > +static int ufs_spacemit_check_hibern8(struct ufs_hba *hba)
> > +{
> > +	u32 tx_fsm_val_0 = 0;
> > +	u32 tx_fsm_val_1 = 0;
> > +	int retries = DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
> > +	int err = 0;
> > +
> > +	do {
> > +		err = ufshcd_dme_get(hba,
> > +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> > +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> > +				     &tx_fsm_val_0);
> > +		if (err)
> > +			break;
> > +
> > +		err = ufshcd_dme_get(hba,
> > +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> > +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> > +				     &tx_fsm_val_1);
> > +		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
> > +			    tx_fsm_val_1 == TX_FSM_HIBERN8))
> > +			break;
> 
> [Severity: Medium]
> Will this loop always hit its 100ms timeout on 1-lane UFS devices?
> 
> It appears that on a 1-lane device, the state for lane 1 will not reach
> TX_FSM_HIBERN8, causing the do-while condition to wait until retries run out
> before proceeding.
> 
Currently, we have not seen any use case with 1-lane device,
it seems a false report, or even people do have concern? then I
would still prefer to address it in a separate patch..

> 
> > +static int ufs_spacemit_device_reset(struct ufs_hba *hba)
> > +{
> > +	/* Disable reference clock & asserted ufs device reset */
> > +	ufshcd_writel(hba, 0x000, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> > +	usleep_range(10, 15);
> > +
> > +	/* Enable reference clock & deassert ufs device reset */
> > +	ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
> > +		      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> 
> [Severity: Medium]
> Could toggling the reference clock output enable and device reset
> de-assertion in a single MMIO write cause device initialization failures?
> 
> The UFS specification (e.g., JESD220C 5.3.1.2) typically requires the
> reference clock to be valid and stable before RST_n is de-asserted. Writing
> MPHY_DEVICE_REFCLK_OE and MPHY_DEVICE_HW_RESET simultaneously might violate
> this sequential stability requirement.
> 
From the testing, It works so far, but I'd add a delay for safe..

> [ ... ]
> 
> > +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
> > +{
> 
> [ ... ]
> 
> > +	if (cmd == UIC_CMD_DME_HIBER_ENTER) {
> > +		err = ufs_spacemit_check_hibern8(hba);
> > +		if (err)
> > +			dev_err(hba->dev, "ufs_spacemit_check_hibern8 error\n");
> > +
> > +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +
> > +		/* Power down M-PHY */
> > +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> > +
> > +		/* Disable reference clock, keep device reset deasserted */
> > +		ufshcd_writel(hba, MPHY_DEVICE_HW_RESET,
> > +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> > +	}
> > +}
> 
> [Severity: Medium]
> Does disabling the reference clock immediately after confirming HIBERN8
> enter violate the device's clock gating wait time?
> 
> By not waiting for hba->dev_info.clk_gating_wait_us (bRefClkGatingWaitTime)
> before disabling the clock, this could potentially cause strict UFS devices
> to hang or fail internal state transitions during hibernation.
> 
bRefClkGatingWaitTime is a feature introduced after UFS 3.0, while it's
UFS 2.2 device used in K3 platform, but I agree to add a delay.

-- 
Yixun Lan (dlan)
