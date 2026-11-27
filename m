Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795819629;
	b=tinW/sq830bci9oXIeuD9DxfKKN36uao0i0td4BdiUxFIF1qaDx/cl3RGWvbLWCbX+bm
	 6mBKrzmIzVc3SlkK0VwV3Tj3WxT3eIZfgsggCtMN4gV9B+Zyr42A12DXMdL3gV1qoT74p
	 zVeFBBWmy8yNSgXEg7rHeoYndYBkx3tfTXqWJ0pduWvfj/4SyyM5124jbEiND+Cwbgqqr
	 Qakli6ugyQPSnhN8U0EuMTBYZpw7Ymisv1jaR0xAN0lfNboNZIKP51yyAiksuzyBlB+4A
	 lBnNbwewOUZ6x3d66NQ75FaqNY6s0rQSp00Zv7cH8rpMSi3d+ZMqOsVE+FQnUtWSU5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795819629;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=hAYM/ukIYEilqCr1ED8CZ1ZOiSgPcwgoFFAIEI1WBTE=;
	b=SqjwEatX6+RNetLm0rTb2rL5p7T7gcZelNaonpQdMwe/x331MTWBbJ/9SCzEhP2pf1gh
	 LOA318kpIiy5jqqMCtQ0ybhq3M3Uf1H1ETcvQ0aM70rDRw8KPKOjfS0OytMtJn+znVXlx
	 IMl2rsiADlLj587yuBSmaz+5UripCR9XF0XaxCIxGvpp+fZYYOSZTq47Kkv8xKVBPst/n
	 YJ9mNdC3U0jlXh6nhUeY9VJ2jVYNf6pwuGrzmOJT+bWz4fxTQccdBk0FZHuFvKZJwNq4/
	 Ca35692cpmmpqTxISVh5vrf9NouAA3LgZtp06N/J0SvYqO5Lfe+pTwk+hU3KT96swxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nc9YfRyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B39606A31C;
	Fri, 27 Nov 2026 22:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nc9YfRyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BF61F00897;
	Fri, 27 Nov 2026 22:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795819629;
	bh=hAYM/ukIYEilqCr1ED8CZ1ZOiSgPcwgoFFAIEI1WBTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nc9YfRyEt5GitvZaoiC7yWVgTXDuGJC8+pNx5+3krPQzWnRp/cOqfRxdijYEBH0w2
	 cEKT+stGrgtqinu50yXXTkthsdd74sUpnu2ezW749zOnAi2YAySoJGg8UTzFvANJFZ
	 gr/PwbdNa/5zjijR8Z/Te0yCvZb6jm4eTkOpJwGSlCMJ/1rPfjz7DKGVK/QDAXOm05
	 xgGfTqMmruabft/lqn60QC5eHqVx51o4s8ENIzXvmk1Mu3JjtbsnA/BQ8ZYjG2/Ive
	 D8Si0vv7VLaucKcxTG7dw0oSiJVpDa1ZO2sLUeyE988Sw44Mj+6RwTm7Q1c2MWvt1s
	 /dJ4D3ERi16rw==
Date: Fri, 27 Nov 2026 22:47:06 +0000
From: Yixun Lan <dlan@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, spacemit@lists.linux.dev,
	robh@kernel.org, conor+dt@kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>
Subject: Re: [PATCH v8 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20261127224706-GKA27669@kernel.org>
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
 <20261116-08-k3-ufs-support-v8-2-e3b256972dd4@kernel.org>
 <sashiko-outbox-216168@kernel.org>
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
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-216168@kernel.org>

Hi James, Martin,

See my commets below for sashiko's reports..

On 04:16 Mon 16 Nov     , sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issues to consider:
> - [High] scsi: ufs: spacemit: clocks not enabled and sys1clk rate always
>   0 without OPP/freq-table
> - [Medium] scsi: ufs: spacemit: zero ref_clk gating delay in
>   ufs_spacemit_post_hibern8() on UFS 2.x
> - [Low] scsi: ufs: spacemit: ufs_spacemit_event_notify() logs cleared
>   hba->errors on UFS_EVT_ABORT
> - [Low] scsi: ufs: spacemit: duplicated ufshcd_init_host_params() and
>   unused definitions
> - [Low] scsi: ufs: spacemit: positive UIC error codes ignored in DME
>   error checks
> --
> 
> commit 893661ab0d45a5f00a091213a0890aea0386b457
> Author: Yixun Lan <dlan@kernel.org>
> 
> scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> 
> This commit adds a UFS host controller platform driver for the SpacemiT K3
> SoC, supporting JEDEC UFS 2.2, MIPI UniPro v1.61, and M-PHY v3.0.
> 
> > diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> > new file mode 100644
> > index 0000000000000..eb2ad50826997
> > --- /dev/null
> > +++ b/drivers/ufs/host/ufs-spacemit.c
> [ ... ]
> > +static u32 ufs_spacemit_get_sys1clk_1us(struct ufs_hba *hba)
> > +{
> > +	struct ufs_clk_info *clki, *clka = NULL;
> > +	struct list_head *head = &hba->clk_list_head;
> > +	unsigned long rate_hz = 0;
> > +
> > +	if (!list_empty(head)) {
> > +		list_for_each_entry(clki, head, list) {
> > +			if (clki->name && !strcmp(clki->name, "axi") && clki->clk) {
> > +				clka = clki;
> > +				break;
> > +			}
> > +		}
> > +	}
> > +
> > +	if (clka && clka->clk)
> > +		rate_hz = clk_get_rate(clka->clk);
> > +
> > +	if (!rate_hz)
> > +		return 0;
> > +
> > +	return DIV_ROUND_CLOSEST(rate_hz, 1000000);
> > +}
> 
> [Severity: High]
> Does hba->clk_list_head remain empty when the Device Tree node has neither
> freq-table-hz nor operating-points-v2?
> 
the board dts file will guarantee having operating-points-v2 provided, so
this should not be a problem, and hba->clk_list_head will be populated at
function ufshcd_parse_operating_points()

> ufshcd_parse_clock_info() returns early without parsing clock-names when
> freq-table-hz is absent, and ufshcd_parse_operating_points() does the same
> when operating-points-v2 is absent:
> 
I think this situation could be improved in ufs core side, e.g, abort early
if neither freq-table-hz nor operating-points-v2 found, but does not need
to be handled at platform driver side

> drivers/ufs/host/ufshcd-pltfrm.c:ufshcd_parse_clock_info() {
>     ...
> 	sz = of_property_count_u32_elems(np, "freq-table-hz");
> 	if (sz <= 0) {
> 		dev_info(dev, "freq-table-hz property not specified\n");
> 		goto out;
> 	}
>     ...
> }
> 
> Since the spacemit,k3-ufshc binding omits both properties and
> ufs_spacemit_init() does not populate hba->clk_list_head or acquire the
> clocks itself, ufshcd_init_clocks() and ufshcd_setup_clocks() never enable
> the axi or ref_clk clocks (leaving them subject to clk_disable_unused or
> unclocked MMIO access if not enabled by firmware), hba->dev_ref_clk_freq is
> never parsed from ref_clk, and ufs_spacemit_get_sys1clk_1us() always returns
> 0 so ufs_spacemit_link_startup_pre_change() always falls back to
> UFS_AXI_CLK_LOW_FREQ_HZ (409.6 MHz).
> 
> [ ... ]
> 
> > +static void ufs_spacemit_set_dev_cap(struct ufs_host_params *host_params, u32 pwr_hs)
> > +{
> > +	if (!host_params)
> > +		return;
> > +
> > +	memset(host_params, 0, sizeof(struct ufs_host_params));
> > +	host_params->tx_lanes = UFS_SPACEMIT_K3_LIMIT_NUM_LANES_TX;
> > +	host_params->rx_lanes = UFS_SPACEMIT_K3_LIMIT_NUM_LANES_RX;
> > +	host_params->hs_rx_gear = UFS_SPACEMIT_K3_LIMIT_HSGEAR_RX;
> > +	host_params->hs_tx_gear = UFS_SPACEMIT_K3_LIMIT_HSGEAR_TX;
> > +	host_params->pwm_rx_gear = UFS_SPACEMIT_K3_LIMIT_PWMGEAR_RX;
> > +	host_params->pwm_tx_gear = UFS_SPACEMIT_K3_LIMIT_PWMGEAR_TX;
> > +	host_params->rx_pwr_pwm = UFS_SPACEMIT_K3_LIMIT_RX_PWR_PWM;
> > +	host_params->tx_pwr_pwm = UFS_SPACEMIT_K3_LIMIT_TX_PWR_PWM;
> > +	host_params->rx_pwr_hs = pwr_hs;
> > +	host_params->tx_pwr_hs = pwr_hs;
> > +	host_params->hs_rate = UFS_SPACEMIT_K3_LIMIT_HS_RATE;
> > +	host_params->desired_working_mode = UFS_HS_MODE;
> > +}
> 
> [Severity: Low]
> This isn't a bug, but ufs_spacemit_set_dev_cap() and the
> UFS_SPACEMIT_K3_LIMIT_* macros set the exact same defaults as the exported
> ufshcd_init_host_params() helper in drivers/ufs/host/ufshcd-pltfrm.c.
> 
Yes, will drop ufs_spacemit_set_dev_cap()

> In addition, ufs_spacemit_init() allocates struct ufs_spacemit_host and
> stores it with ufshcd_set_variant(), but the variant pointer is never
> retrieved anywhere in the driver. 
I'd leave it as is, as for adding platform specific feature later
(let me know if ok with this)

> MPHY_TX_FSM_STATE is also defined in both
> ufs-spacemit.h and ufs-spacemit.c, ANA_EQ_CTRL_REG_ATTR and
> MPHY_PU_WITH_HB8_RESET are defined in ufs-spacemit.c while raw literals
> 0x00CD and 0xb7f are still used in ufs_spacemit_uniprov1p6_init() and
> ufs_spacemit_mphy_init(), and MPHY_RX_FSM_STATE along with several headers
> and macros in ufs-spacemit.h are unused.
> 
Ok, I will fix above

> > +
> > +static int ufs_spacemit_link_startup_pre_change(struct ufs_hba *hba)
> > +{
> > +	u32 value, sys1clk_1us;
> > +	int err;
> > +
> > +	err = ufs_spacemit_mphy_init(hba);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	err = ufs_spacemit_uniprov1p6_init(hba);
> > +	if (err < 0)
> > +		return err;
> [ ... ]
> > +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		/* LCC_DISABLE */
> > +		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0 },
> > +		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0 },
> > +		/* TX_Min_ActivateTime */
> > +		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x0 },
> > +		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x0 },
> > +		{ UIC_ARG_MIB(ANA_HSGEAR_CTRL_ATTR), 0x25 },
> > +	};
> > +	int err;
> > +
> > +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME) {
> > +		err = ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
> > +		if (err < 0)
> > +			return err;
> > +	}
> > +
> > +	if (hba->dev_info.wmanufacturerid == UFS_VENDOR_WDC)
> > +		hba->dev_quirks |= UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
> > +
> > +	err = ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> > +	if (err < 0)
> > +		return err;
> > +
> > +	return ufs_spacemit_wait_mphy_pll_lock(hba);
> > +}
> 
> [Severity: Low]
> As reported by Troy Mitchell on v6 [1], can positive UIC error codes bypass
> the "if (err < 0)" checks in ufs_spacemit_link_startup_pre_change() and
> ufs_spacemit_apply_dev_quirks()?
> 
> ufshcd_dme_get() and ufshcd_dme_set() return positive 8-bit UIC command
> result codes (0x01..0xFF) when a DME command fails at the UniPro layer.
> Checking "if (err < 0)" misses those positive error codes and allows both
> functions to continue past failed DME operations instead of aborting early.

Ok, I've checked again, there is actually one place return cmd

ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
{
...
        if (wait_for_completion_timeout(&uic_cmd->done,
                                        msecs_to_jiffies(uic_cmd_timeout))) {
                ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
        } else {
                ret = -ETIMEDOUT;

                if (!uic_cmd->cmd_active) {
                        dev_err(hba->dev, "%s: UIC cmd has been completed, return the result\n",
                                __func__);
                        ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT; 
                    ~~~~~~~~ here, return cmd, and override "ret = -ETIMEDOUT"
                }
        }
}

I think it would be better to return an error code here instead of "cmd & mask".

> 
> [ ... ]
> 
> > +static void ufs_spacemit_event_notify(struct ufs_hba *hba, enum ufs_event_type evt, void *data)
> > +{
> > +	switch (evt) {
> > +	case UFS_EVT_PA_ERR:
> > +		if (data)
> > +			dev_warn(hba->dev, "PA error event, INT errors:0x%x, PA_ERR_CODE:0x%x\n",
> > +				 hba->errors, *(u32 *)data);
> > +
> > +		break;
> > +	case UFS_EVT_DL_ERR:
> > +		if (data)
> > +			dev_warn(hba->dev, "DL error event, INT errors:0x%x, DL_ERR:0x%x\n",
> > +				 hba->errors, *(u32 *)data);
> > +
> > +		break;
> > +	case UFS_EVT_ABORT:
> > +		dev_warn(hba->dev, "Abort event, INT errors:0x%x\n", hba->errors);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> 
> [Severity: Low]
> Does the UFS_EVT_ABORT case in ufs_spacemit_event_notify() always log
> hba->errors as 0x0?
> 
> ufshcd_check_errors() clears hba->errors back to 0 before the interrupt
> handler returns (saving sticky bits in hba->saved_err), while UFS_EVT_ABORT
> is only emitted later from ufshcd_abort() in SCSI error-handler context with
> the aborted tag or LUN passed via data.
> 
Indeed, hba->errors will be cleared, I could think of logging out with "saved_errors"


> [ ... ]
> 
> > +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
> > +{
> > +	static const struct ufshcd_dme_attr_val setup_attrs[] = {
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
> > +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
> > +		{ UIC_ARG_MIB(0xdd), 0x57 },
> > +		{ UIC_ARG_MIB(0xdd), 0xd7 },
> > +		{ UIC_ARG_MIB(0xe8), 0x57 },
> > +		{ UIC_ARG_MIB(0xe8), 0xd7 },
> > +	};
> > +	int err;
> > +
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
> > +		fsleep(hba->dev_info.clk_gating_wait_us);
> > +
> > +		/* Disable reference clock, keep device reset deasserted */
> > +		ufshcd_writel(hba, MPHY_DEVICE_HW_RESET,
> > +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> > +	}
> > +}
> 
> [Severity: Medium]
> Does fsleep(hba->dev_info.clk_gating_wait_us) gate the device reference
> clock with zero delay on UFS 2.x devices?
> 
> ufshcd_get_ref_clk_gating_wait() only reads bRefClkGatingWaitTime and sets
> hba->dev_info.clk_gating_wait_us when hba->dev_info.wspecversion >= 0x300.
> On UFS 2.x devices (or if Hibern8 is entered before
> ufshcd_device_params_init() runs), clk_gating_wait_us remains 0, so
> ufs_spacemit_post_hibern8() calls fsleep(0) and disables
> MPHY_DEVICE_REFCLK_OE immediately after powering down the M-PHY without
> satisfying the reference clock hold time.
> 
Hi, I think bRefClkGatingWaitTime feature isn't mandatory for UFS 2.x? 
and from my testing, the UFS is just working fine without the delay..

I need some advice from UFS maintainer on this, otherwise I'd leave it as is

> [1] https://lore.kernel.org/r/DLLQJDEA91FU.18Q1TSX09AUR3@linux.spacemit.com
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org?part=2

-- 
Yixun Lan (dlan)
