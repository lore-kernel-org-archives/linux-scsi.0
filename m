Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4833F0770;
	Thu,  6 Aug 2026 10:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011532; cv=none; b=MMpS3UCdTjuy7A+NfjDyM8Vtpg0kHfJxrRiRu8+83yjgbm8bw3Ey3noIhLIEA7fpK8jE+y2S9K3rlZL9ftbRmpYmh4KACvBODum3outkAc97+vIXdRj1LlA0UVfPMS7M/vfCNrM6qPcuwsm7c51H1cHUqfV6BaLQdUYhg2DLNB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011532; c=relaxed/simple;
	bh=G0vDmtfRsFREBsT0y4jBYXSz2h9VBWZpsjxIOgVXDdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElTjvDm5Pvg/rSM7qmLvRymzKrgwOawsvXORn7s9m8TJwCWv1gK0RNpT6Dp8uRPIx8zPZzMMy6J1mk9EKsLIrnV63ck9MsATThANQSsbH4Pl4k5gmdul4x6g5RATwq15r27GmwtktFE07K/xlzo/osy6Cl5jrWPLoXAhAve4usI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLbfudQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLbfudQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1664D1F000E9;
	Thu,  6 Aug 2026 10:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786011530;
	bh=d5+BfjrEj586Zl8B6gP6KpwVxu5qt+ur0FYZiUxu65s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kLbfudQFL2Ln9puUnNS+roz2YKwwkLruSoTTgdy0Yu9iCLCllMUywowomDwyvFcG4
	 c4SI3N7kE+QJ87zFvAG9JdRYvEAJXuCRJ0u2B1NsqMcByMzt9f0QzhQLlkbqPwwK6K
	 3kT9nCGNV9mPddv/LrWkVoyhIBuc+TRcxehLEUP/ktzI+4Uegb84EEtAVs+HCtZgZT
	 Wtrs0ljMsmn4ryyKL3kqraWJ9XEkxMUS5QzV643QpKkYxV3ieSZ3sGe7Mt7PanQ+1+
	 m9cVbMAtlI9IaFNd4lAsFmJDOJvSVzVGD3jdwYHCZ4X1RJ6DXmUWOfStVAviaT7TDX
	 0HTGGTBbRNkDQ==
Date: Thu, 6 Aug 2026 15:48:47 +0530
From: Vinod Koul <vkoul@kernel.org>
To: palash.kambar@oss.qualcomm.com
Cc: neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, mani@kernel.org, alim.akhtar@samsung.com,
	bvanassche@acm.org, andersson@kernel.org,
	dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
	luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH v5 1/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Message-ID: <anRfh9Pk-IYdVq27@vaman>
References: <20260803130852.1432714-1-palash.kambar@oss.qualcomm.com>
 <20260803130852.1432714-2-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803130852.1432714-2-palash.kambar@oss.qualcomm.com>

On 03-08-26, 18:38, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Add the init sequence tables and config for the UFS QMP phy found in
> the Hawi SoC.
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

You guys should have caught the mismatch ...

> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
> ---
>  .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
>  .../qualcomm/phy-qcom-qmp-qserdes-com-v8.h    |  13 +-
>  .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
>  4 files changed, 212 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
>  create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
> new file mode 100644
> index 000000000000..e80d3dd6a190
> --- /dev/null
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
> + */
> +
> +#ifndef QCOM_PHY_QMP_PCS_UFS_V7_H_
> +#define QCOM_PHY_QMP_PCS_UFS_V7_H_
> +
> +/* Only for QMP V7 PHY - UFS PCS registers */
> +#define QPHY_V7_PCS_UFS_PHY_START			0x000
> +#define QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL		0x004
> +#define QPHY_V7_PCS_UFS_SW_RESET			0x008
> +#define QPHY_V7_PCS_UFS_PCS_CTRL1			0x01C

small case please :-(

> +#define QPHY_V7_PCS_UFS_PLL_CNTL			0x028
> +#define QPHY_V7_PCS_UFS_TX_LARGE_AMP_DRV_LVL		0x02C

here

> +#define QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY		0x060
> +#define QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY		0x094
> +#define QPHY_V7_PCS_UFS_LINECFG_DISABLE			0x140
> +#define QPHY_V7_PCS_UFS_RX_SIGDET_CTRL2			0x150
> +#define QPHY_V7_PCS_UFS_READY_STATUS			0x16c

and this is small!!

> +#define QPHY_V7_PCS_UFS_TX_MID_TERM_CTRL1		0x1b8
> +#define QPHY_V7_PCS_UFS_MULTI_LANE_CTRL1		0x1c0
> +
> +#endif
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
> index d8ac4c4a2c31..d416113bcb3c 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
>   */
>  
>  #ifndef QCOM_PHY_QMP_QSERDES_COM_V8_H_
> @@ -71,5 +71,16 @@
>  #define QSERDES_V8_COM_ADDITIONAL_MISC			0x1b4
>  #define QSERDES_V8_COM_CMN_STATUS			0x2c8
>  #define QSERDES_V8_COM_C_READY_STATUS			0x2f0
> +#define QSERDES_V8_COM_PLL_IVCO_MODE1				0xf8
> +#define QSERDES_V8_COM_CMN_IETRIM				0xfc
> +#define QSERDES_V8_COM_CMN_IPTRIM				0x100
> +#define QSERDES_V8_COM_VCO_TUNE_CTRL				0x13c
> +#define QSERDES_V8_COM_ADAPTIVE_ANALOG_CONFIG			0x268
> +#define QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE0			0x26c
> +#define QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE0		0x270
> +#define QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE0			0x274
> +#define QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE1			0x278
> +#define QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE1		0x27c
> +#define QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE1			0x280
>  
>  #endif
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
> new file mode 100644
> index 000000000000..5f923c3e64ec
> --- /dev/null
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2026, The Linux Foundation. All rights reserved.
> + */
> +
> +#ifndef QCOM_PHY_QMP_QSERDES_TXRX_UFS_V8_H_
> +#define QCOM_PHY_QMP_QSERDES_TXRX_UFS_V8_H_
> +
> +#define QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX		(0x34)
> +#define QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX		(0x38)
> +#define QSERDES_UFS_V8_TX_LANE_MODE_1				(0x80)
> +#define QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE2			(0x1BC)
> +#define QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE4			(0x1C4)
> +#define QSERDES_UFS_V8_RX_UCDR_SO_GAIN_RATE4			(0x1DC)
> +#define QSERDES_UFS_V8_RX_EQ_OFFSET_ADAPTOR_CNTRL1		(0x2C8)
> +#define QSERDES_UFS_V8_RX_UCDR_PI_CONTROLS			(0x1E4)
> +#define QSERDES_UFS_V8_RX_OFFSET_ADAPTOR_CNTRL3			(0x2D0)

:-( and so on!


> +#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4	(0x120)
> +#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_FO_GAIN_RATE4		(0xD4)
> +#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_SO_GAIN_RATE4		(0xEC)
> +#define QSERDES_UFS_V8_RX_VGA_CAL_MAN_VAL			(0x288)
> +#define QSERDES_UFS_V8_RX_EQU_ADAPTOR_CNTRL4			(0x2B0)
> +#define QSERDES_UFS_V8_RX_MODE_RATE_0_1_B4			(0x324)
> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SA_B7			(0x3B4)
> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SA_B9			(0x3BC)
> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SB_B7			(0x3E0)
> +#define QSERDES_UFS_V8_RX_MODE_RATE4_SB_B9			(0x3E8)
> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SA_B7			(0x40C)
> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SA_B9			(0x414)
> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SB_B7			(0x438)
> +#define QSERDES_UFS_V8_RX_MODE_RATE5_SB_B9			(0x440)
> +#define QSERDES_UFS_V8_RX_UCDR_SO_SATURATION			(0xF4)
> +#define QSERDES_UFS_V8_RX_TERM_BW_CTRL0				(0x1AC)
> +#define QSERDES_UFS_V8_RX_DLL0_FTUNE_CTRL			(0x498)
> +#define QSERDES_UFS_V8_RX_SIGDET_CAL_TRIM			(0x4d0)
> +
> +#endif
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index 0f4ad24aa405..d4aca22c181e 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -29,9 +29,11 @@
>  #include "phy-qcom-qmp-pcs-ufs-v4.h"
>  #include "phy-qcom-qmp-pcs-ufs-v5.h"
>  #include "phy-qcom-qmp-pcs-ufs-v6.h"
> +#include "phy-qcom-qmp-pcs-ufs-v7.h"
>  
>  #include "phy-qcom-qmp-qserdes-txrx-ufs-v6.h"
>  #include "phy-qcom-qmp-qserdes-txrx-ufs-v7.h"
> +#include "phy-qcom-qmp-qserdes-txrx-ufs-v8.h"
>  
>  /* QPHY_PCS_READY_STATUS bit */
>  #define PCS_READY				BIT(0)
> @@ -84,6 +86,13 @@ static const unsigned int ufsphy_v6_regs_layout[QPHY_LAYOUT_SIZE] = {
>  	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V6_PCS_UFS_POWER_DOWN_CONTROL,
>  };
>  
> +static const unsigned int ufsphy_v7_regs_layout[QPHY_LAYOUT_SIZE] = {
> +	[QPHY_START_CTRL]		= QPHY_V7_PCS_UFS_PHY_START,
> +	[QPHY_PCS_READY_STATUS]		= QPHY_V7_PCS_UFS_READY_STATUS,
> +	[QPHY_SW_RESET]			= QPHY_V7_PCS_UFS_SW_RESET,
> +	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL,
> +};
> +
>  static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
>  	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
>  	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
> @@ -1307,6 +1316,11 @@ static const struct regulator_bulk_data sm8750_ufsphy_vreg_l[] = {
>  	{ .supply = "vdda-pll", .init_load_uA = 18300 },
>  };
>  
> +static const struct regulator_bulk_data hawi_ufsphy_vreg_l[] = {
> +	{ .supply = "vdda-phy", .init_load_uA = 324000 },
> +	{ .supply = "vdda-pll", .init_load_uA = 27000 },
> +};
> +
>  static const struct qmp_ufs_offsets qmp_ufs_offsets = {
>  	.serdes		= 0,
>  	.pcs		= 0xc00,
> @@ -1325,6 +1339,15 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v6 = {
>  	.rx2		= 0x1a00,
>  };
>  
> +static const struct qmp_ufs_offsets qmp_ufs_offsets_v7 = {
> +	.serdes		= 0,
> +	.pcs		= 0x0400,
> +	.tx		= 0x2000,
> +	.rx		= 0x2000,
> +	.tx2		= 0x3000,
> +	.rx2		= 0x3000,
> +};
> +
>  static const struct qmp_phy_cfg milos_ufsphy_cfg = {
>  	.lanes			= 2,
>  
> @@ -1845,6 +1868,119 @@ static const struct qmp_phy_cfg sm8750_ufsphy_cfg = {
>  
>  };
>  
> +static const struct qmp_phy_init_tbl hawi_ufsphy_serdes[] = {
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_SYSCLK_EN_SEL, 0xd9),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_CONFIG_1, 0x16),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_HSCLK_SEL_1, 0x11),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_HSCLK_HS_SWITCH_SEL_1, 0x00),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP_EN, 0x01),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP_CFG, 0x60),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO_MODE1, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IETRIM, 0x07),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IPTRIM, 0x20),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_VCO_TUNE_MAP, 0x04),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_VCO_TUNE_CTRL, 0x40),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_ADAPTIVE_ANALOG_CONFIG, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_DEC_START_MODE0, 0x41),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_MODE0, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCTRL_MODE0, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_MODE0, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE0, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE0, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE0, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP1_MODE0, 0x7f),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP2_MODE0, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE1_MODE0, 0x92),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE2_MODE0, 0x1e),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_DEC_START_MODE1, 0x4c),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_MODE1, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCTRL_MODE1, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_MODE1, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE1, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE1, 0x18),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE1, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP1_MODE1, 0x99),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP2_MODE1, 0x07),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xbe),
> +	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
> +};
> +
> +static const struct qmp_phy_init_tbl hawi_ufsphy_tx[] = {
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_LANE_MODE_1, 0x0c),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX, 0x07),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX, 0x17),
> +};
> +
> +static const struct qmp_phy_init_tbl hawi_ufsphy_rx[] = {
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE2, 0x0c),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE4, 0x0c),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_SO_GAIN_RATE4, 0x04),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_EQ_OFFSET_ADAPTOR_CNTRL1, 0x14),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_PI_CONTROLS, 0x07),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_OFFSET_ADAPTOR_CNTRL3, 0x0e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4, 0x02),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_FO_GAIN_RATE4, 0x1c),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_SO_GAIN_RATE4, 0x06),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_VGA_CAL_MAN_VAL, 0x8e),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_EQU_ADAPTOR_CNTRL4, 0x0f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE_0_1_B4, 0xb8),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SA_B7, 0x66),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SA_B9, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SB_B7, 0x66),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SB_B9, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SA_B7, 0x66),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SA_B9, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SB_B7, 0x66),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SB_B9, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_SO_SATURATION, 0x1f),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_TERM_BW_CTRL0, 0xfa),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_DLL0_FTUNE_CTRL, 0x30),
> +	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_SIGDET_CAL_TRIM, 0x77),
> +};
> +
> +static const struct qmp_phy_init_tbl hawi_ufsphy_pcs[] = {
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PCS_CTRL1, 0x42),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
> +};
> +
> +static const struct qmp_phy_init_tbl hawi_ufsphy_g5_pcs[] = {
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PLL_CNTL, 0x3b),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x05),
> +	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x05),
> +};
> +
> +static const struct qmp_phy_cfg hawi_ufsphy_cfg = {
> +	.lanes			= 2,
> +
> +	.offsets		= &qmp_ufs_offsets_v7,
> +	.max_supported_gear	= UFS_HS_G5,
> +
> +	.tbls = {
> +		.serdes		= hawi_ufsphy_serdes,
> +		.serdes_num	= ARRAY_SIZE(hawi_ufsphy_serdes),
> +		.tx		= hawi_ufsphy_tx,
> +		.tx_num		= ARRAY_SIZE(hawi_ufsphy_tx),
> +		.rx		= hawi_ufsphy_rx,
> +		.rx_num		= ARRAY_SIZE(hawi_ufsphy_rx),
> +		.pcs		= hawi_ufsphy_pcs,
> +		.pcs_num	= ARRAY_SIZE(hawi_ufsphy_pcs),
> +	},
> +
> +	.tbls_hs_overlay[0] = {
> +		.pcs		= hawi_ufsphy_g5_pcs,
> +		.pcs_num	= ARRAY_SIZE(hawi_ufsphy_g5_pcs),
> +		.max_gear	= UFS_HS_G5,
> +	},
> +
> +	.vreg_list		= hawi_ufsphy_vreg_l,
> +	.num_vregs		= ARRAY_SIZE(hawi_ufsphy_vreg_l),
> +	.regs			= ufsphy_v7_regs_layout,
> +};
> +
>  static void qmp_ufs_serdes_init(struct qmp_ufs *qmp, const struct qmp_phy_cfg_tbls *tbls)
>  {
>  	void __iomem *serdes = qmp->serdes;
> @@ -2259,6 +2395,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
>  
>  static const struct of_device_id qmp_ufs_of_match_table[] = {
>  	{
> +		.compatible = "qcom,hawi-qmp-ufs-phy",
> +		.data = &hawi_ufsphy_cfg,
> +	}, {
>  		.compatible = "qcom,milos-qmp-ufs-phy",
>  		.data = &milos_ufsphy_cfg,
>  	}, {
> -- 
> 2.34.1

-- 
~Vinod
