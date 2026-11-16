Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794802599;
	b=GgeH3PU+pYgw9GBytwnEbUfD8EJ4kPtT60UiP3UwrbDs9debSyVsIwvzv6zE59Dl0Z+D
	 kmGHbEvIaNI8jy1CJ8fzGGn3VzwjgcAg8MLDnazisMA5EmNXX4tOKCvbV9KgDKIboPErB
	 euue4W7G8fEn80obKXqFn9LATLrey+tbSin62Ol5LxmqkuCaXP/41FX/OLv8qpf0KhwPs
	 Zy1/lpPclY25O4bhLJrzxFbone7mYrLH87tAXKKMlJgFO5VcyekcDaVQ4QQH/3800hBzd
	 i8KsoWZfWkRn93rv+e5PV6sSUhTtKFynzNXa+/PEcZ9/pypd6H/G81MLkLxG/3d/kwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794802599;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uzbrnHdlZO/Nl75AkoaBKnFpLs1p4dTsORcxzJmfA0w=;
	b=lwKOyrhWOwkyyFKlk4zl5I1aYb4VAw9esgabJEiSZeQpCKccfTGPX0E1HBwHRqjMvKgy
	 tsKxRBGdJ77hn82q+Ypv5NeX8/8VzIRnhpOQy9lWLMuDTVFtD6TGkTlpdsY0x4U1BmQ/N
	 pgdkQNNUtU9siTwwTJ71I7ZZADLuHHwjTlphfrZsGpf04HGojkKaKkAiWlcK9dv/oYGAf
	 YGwMsXfLIPi0yoTdLZDj7ZisgZmbwr5SOrBXSEVvNeApvPsCId5GCiWRkTZMu1x37GeeQ
	 Tpc4CqFBJHdUrHxQ+bbVn3LB04K3UIr3s2SFe7XEZ5om2ywdUtXTyN2DE0p761RBlGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1kpMp96;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814BF606A31C;
	Mon, 16 Nov 2026 04:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1kpMp96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AA91F000C4;
	Mon, 16 Nov 2026 04:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794802599;
	bh=uzbrnHdlZO/Nl75AkoaBKnFpLs1p4dTsORcxzJmfA0w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S1kpMp96kMjmpCpi8Upj93cDAKYOtDvNRyFuT0u26t+nUF4rYluB01Pu484KU8kit
	 r0SNf2I58IEC0cmM43KDcV0KpPQCnX8EOFqDClgFf+A74zWxDIsqeGo6BeL9AfCI0X
	 QsWg6FUdtFMdG7CC5Z2qmsV4gqHjhTtdVC0RJe2N5VJnx4tXP/q/O2WqgUcLHvcCtj
	 fysxBKKspnimTip2pFvX9CUsCPq6pbru3hUhbeVMx1AKIYGhSPQPz8ibcCwFPMPX5P
	 8ouZagWqte9NJWPupjHWkbO2yBDRu0++QmEOzgxG6RWLrP0+Ui7TlMQ4SfuLsySc6S
	 qgLA53UZMpJ2Q==
Message-ID: <sashiko-outbox-216168@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20261116-08-k3-ufs-support-v8-2-e3b256972dd4@kernel.org>
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
 <20261116-08-k3-ufs-support-v8-2-e3b256972dd4@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 04:16:38 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] scsi: ufs: spacemit: clocks not enabled and sys1clk rate always
  0 without OPP/freq-table
- [Medium] scsi: ufs: spacemit: zero ref_clk gating delay in
  ufs_spacemit_post_hibern8() on UFS 2.x
- [Low] scsi: ufs: spacemit: ufs_spacemit_event_notify() logs cleared
  hba->errors on UFS_EVT_ABORT
- [Low] scsi: ufs: spacemit: duplicated ufshcd_init_host_params() and
  unused definitions
- [Low] scsi: ufs: spacemit: positive UIC error codes ignored in DME
  error checks
--

commit 893661ab0d45a5f00a091213a0890aea0386b457
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

This commit adds a UFS host controller platform driver for the SpacemiT K3
SoC, supporting JEDEC UFS 2.2, MIPI UniPro v1.61, and M-PHY v3.0.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..eb2ad50826997
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
[ ... ]
> +static u32 ufs_spacemit_get_sys1clk_1us(struct ufs_hba *hba)
> +{
> +	struct ufs_clk_info *clki, *clka =3D NULL;
> +	struct list_head *head =3D &hba->clk_list_head;
> +	unsigned long rate_hz =3D 0;
> +
> +	if (!list_empty(head)) {
> +		list_for_each_entry(clki, head, list) {
> +			if (clki->name && !strcmp(clki->name, "axi") && clki->clk) {
> +				clka =3D clki;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (clka && clka->clk)
> +		rate_hz =3D clk_get_rate(clka->clk);
> +
> +	if (!rate_hz)
> +		return 0;
> +
> +	return DIV_ROUND_CLOSEST(rate_hz, 1000000);
> +}

[Severity: High]
Does hba->clk_list_head remain empty when the Device Tree node has neither
freq-table-hz nor operating-points-v2?

ufshcd_parse_clock_info() returns early without parsing clock-names when
freq-table-hz is absent, and ufshcd_parse_operating_points() does the same
when operating-points-v2 is absent:

drivers/ufs/host/ufshcd-pltfrm.c:ufshcd_parse_clock_info() {
    ...
	sz =3D of_property_count_u32_elems(np, "freq-table-hz");
	if (sz <=3D 0) {
		dev_info(dev, "freq-table-hz property not specified\n");
		goto out;
	}
    ...
}

Since the spacemit,k3-ufshc binding omits both properties and
ufs_spacemit_init() does not populate hba->clk_list_head or acquire the
clocks itself, ufshcd_init_clocks() and ufshcd_setup_clocks() never enable
the axi or ref_clk clocks (leaving them subject to clk_disable_unused or
unclocked MMIO access if not enabled by firmware), hba->dev_ref_clk_freq is
never parsed from ref_clk, and ufs_spacemit_get_sys1clk_1us() always returns
0 so ufs_spacemit_link_startup_pre_change() always falls back to
UFS_AXI_CLK_LOW_FREQ_HZ (409.6 MHz).

[ ... ]

> +static void ufs_spacemit_set_dev_cap(struct ufs_host_params *host_params=
, u32 pwr_hs)
> +{
> +	if (!host_params)
> +		return;
> +
> +	memset(host_params, 0, sizeof(struct ufs_host_params));
> +	host_params->tx_lanes =3D UFS_SPACEMIT_K3_LIMIT_NUM_LANES_TX;
> +	host_params->rx_lanes =3D UFS_SPACEMIT_K3_LIMIT_NUM_LANES_RX;
> +	host_params->hs_rx_gear =3D UFS_SPACEMIT_K3_LIMIT_HSGEAR_RX;
> +	host_params->hs_tx_gear =3D UFS_SPACEMIT_K3_LIMIT_HSGEAR_TX;
> +	host_params->pwm_rx_gear =3D UFS_SPACEMIT_K3_LIMIT_PWMGEAR_RX;
> +	host_params->pwm_tx_gear =3D UFS_SPACEMIT_K3_LIMIT_PWMGEAR_TX;
> +	host_params->rx_pwr_pwm =3D UFS_SPACEMIT_K3_LIMIT_RX_PWR_PWM;
> +	host_params->tx_pwr_pwm =3D UFS_SPACEMIT_K3_LIMIT_TX_PWR_PWM;
> +	host_params->rx_pwr_hs =3D pwr_hs;
> +	host_params->tx_pwr_hs =3D pwr_hs;
> +	host_params->hs_rate =3D UFS_SPACEMIT_K3_LIMIT_HS_RATE;
> +	host_params->desired_working_mode =3D UFS_HS_MODE;
> +}

[Severity: Low]
This isn't a bug, but ufs_spacemit_set_dev_cap() and the
UFS_SPACEMIT_K3_LIMIT_* macros set the exact same defaults as the exported
ufshcd_init_host_params() helper in drivers/ufs/host/ufshcd-pltfrm.c.

In addition, ufs_spacemit_init() allocates struct ufs_spacemit_host and
stores it with ufshcd_set_variant(), but the variant pointer is never
retrieved anywhere in the driver.  MPHY_TX_FSM_STATE is also defined in both
ufs-spacemit.h and ufs-spacemit.c, ANA_EQ_CTRL_REG_ATTR and
MPHY_PU_WITH_HB8_RESET are defined in ufs-spacemit.c while raw literals
0x00CD and 0xb7f are still used in ufs_spacemit_uniprov1p6_init() and
ufs_spacemit_mphy_init(), and MPHY_RX_FSM_STATE along with several headers
and macros in ufs-spacemit.h are unused.

> +
> +static int ufs_spacemit_link_startup_pre_change(struct ufs_hba *hba)
> +{
> +	u32 value, sys1clk_1us;
> +	int err;
> +
> +	err =3D ufs_spacemit_mphy_init(hba);
> +	if (err < 0)
> +		return err;
> +
> +	err =3D ufs_spacemit_uniprov1p6_init(hba);
> +	if (err < 0)
> +		return err;
[ ... ]
> +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		/* LCC_DISABLE */
> +		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0 =
},
> +		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0 =
},
> +		/* TX_Min_ActivateTime */
> +		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0=
)), 0x0 },
> +		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1=
)), 0x0 },
> +		{ UIC_ARG_MIB(ANA_HSGEAR_CTRL_ATTR), 0x25 },
> +	};
> +	int err;
> +
> +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME) {
> +		err =3D ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	if (hba->dev_info.wmanufacturerid =3D=3D UFS_VENDOR_WDC)
> +		hba->dev_quirks |=3D UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
> +
> +	err =3D ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +	if (err < 0)
> +		return err;
> +
> +	return ufs_spacemit_wait_mphy_pll_lock(hba);
> +}

[Severity: Low]
As reported by Troy Mitchell on v6 [1], can positive UIC error codes bypass
the "if (err < 0)" checks in ufs_spacemit_link_startup_pre_change() and
ufs_spacemit_apply_dev_quirks()?

ufshcd_dme_get() and ufshcd_dme_set() return positive 8-bit UIC command
result codes (0x01..0xFF) when a DME command fails at the UniPro layer.
Checking "if (err < 0)" misses those positive error codes and allows both
functions to continue past failed DME operations instead of aborting early.

[ ... ]

> +static void ufs_spacemit_event_notify(struct ufs_hba *hba, enum ufs_even=
t_type evt, void *data)
> +{
> +	switch (evt) {
> +	case UFS_EVT_PA_ERR:
> +		if (data)
> +			dev_warn(hba->dev, "PA error event, INT errors:0x%x, PA_ERR_CODE:0x%x=
\n",
> +				 hba->errors, *(u32 *)data);
> +
> +		break;
> +	case UFS_EVT_DL_ERR:
> +		if (data)
> +			dev_warn(hba->dev, "DL error event, INT errors:0x%x, DL_ERR:0x%x\n",
> +				 hba->errors, *(u32 *)data);
> +
> +		break;
> +	case UFS_EVT_ABORT:
> +		dev_warn(hba->dev, "Abort event, INT errors:0x%x\n", hba->errors);
> +		break;
> +	default:
> +		break;
> +	}
> +}

[Severity: Low]
Does the UFS_EVT_ABORT case in ufs_spacemit_event_notify() always log
hba->errors as 0x0?

ufshcd_check_errors() clears hba->errors back to 0 before the interrupt
handler returns (saving sticky bits in hba->saved_err), while UFS_EVT_ABORT
is only emitted later from ufshcd_abort() in SCSI error-handler context with
the aborted tag or LUN passed via data.

[ ... ]

> +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_=
dme cmd)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
> +		{ UIC_ARG_MIB(0xdd), 0x57 },
> +		{ UIC_ARG_MIB(0xdd), 0xd7 },
> +		{ UIC_ARG_MIB(0xe8), 0x57 },
> +		{ UIC_ARG_MIB(0xe8), 0xd7 },
> +	};
> +	int err;
> +
> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) {
> +		err =3D ufs_spacemit_check_hibern8(hba);
> +		if (err)
> +			dev_err(hba->dev, "ufs_spacemit_check_hibern8 error\n");
> +
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +
> +		/* Power down M-PHY */
> +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		fsleep(hba->dev_info.clk_gating_wait_us);
> +
> +		/* Disable reference clock, keep device reset deasserted */
> +		ufshcd_writel(hba, MPHY_DEVICE_HW_RESET,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	}
> +}

[Severity: Medium]
Does fsleep(hba->dev_info.clk_gating_wait_us) gate the device reference
clock with zero delay on UFS 2.x devices?

ufshcd_get_ref_clk_gating_wait() only reads bRefClkGatingWaitTime and sets
hba->dev_info.clk_gating_wait_us when hba->dev_info.wspecversion >=3D 0x300.
On UFS 2.x devices (or if Hibern8 is entered before
ufshcd_device_params_init() runs), clk_gating_wait_us remains 0, so
ufs_spacemit_post_hibern8() calls fsleep(0) and disables
MPHY_DEVICE_REFCLK_OE immediately after powering down the M-PHY without
satisfying the reference clock hold time.

[1] https://lore.kernel.org/r/DLLQJDEA91FU.18Q1TSX09AUR3@linux.spacemit.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-08-k3-ufs-=
support-v8-0-e3b256972dd4@kernel.org?part=3D2
