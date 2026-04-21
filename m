Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2112.outbound.protection.partner.outlook.cn [139.219.17.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D33A451F;
	Tue, 21 Apr 2026 09:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762767; cv=fail; b=EGaTpzljqKwpLM4f7nAEfXyX4r2kGsLkmKy5zNLjUquqWtmFQu+CBoDGsvvFxJR7TBcWPsmDwEOBO6GiYRwfvCBHGD+XrIwlEJPIBxE+CZ7n43hi7j/bCvDN4Kw/E0FmzjXETBa0dGFLPf5QyVQPi5auN+ZFKVXFiREoC3AAkKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762767; c=relaxed/simple;
	bh=3vduIKgpvkAOabRw2EEx+8bHb2M2b0pw/Xm6w8xZ6r0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AyraI2D5/h8t1pdGJ+9gXedvYG3VJben9kPUQm5XVwgj7+vKPPtc2eoznP9hsWw4eVsM5j32OKZrnmwIg6e5nWdgZzzi+DGa00P7g55GSvf0lb6s714VwdQqXAGpexzPqRiF6SFd30tm/ETJ3rfQyIBaTc24INKh0H7oqb3T0/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWX4oYcQ74y5PbhgPIBZ2WTBkmseEFnS7mxPYZ5ONmQ0ZZ6PJv3jxZYMLfA14Uh0B7ad2Iu522knUC6uEiUJXgGzQQi0WUirt7D63bNKjh7po6AN+H/RSGjA+ouN8jLMDCSHf1Vk+0AfW/CKQMT1IUpXDRmotdj86MGbHOZhifktxYFu33Abf/bvAikUmQa5p51JPrSL2bGxWH96A8+Cct1xh0lxTp5dE2CD8TvAsPCxvM/+wj88zQ29zO9YqkV/oFq13S93udYvwppD/Nxw+mF67+rnzFQW6j07E3+G+ce3k25jbV9Ibn6FgTFRnEQL0Dvy0tedMQddLvNncju2mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ja/JsmqgHpiWXuGK/XAqGlElpsFQMUftnl2A5blXFcw=;
 b=bRQTP1sigGIbj9f1nge/6gpnECejkxZBJtBwDT+9DzFldNIWngGo04uoqXvBELSVqi/+zr1oB4jEVgJU+/8+RPw/V5OcntuEgsVPkalGx/fFQa9R5T62z6IvWCHqDeS0gizde5TpN2TX//mn5Pd5ieaOgYnGDswDO/eVdhTR1nm8rgEq7kes3VnS0jm3OhRCgQW9GIX3+QZFCKcOrEwCjXwaKgra7jjGGer4TdH1ZFRrWdLn9MnmyR2t78KQ7fp8o+x1VhDt7x7ra5lYzzjws8FUyDX1V83oCku1Tl/UinRBJWdgXVjPuA+e0O4ffAMe5SUMt6zpfYr+0C3OZStvbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0519.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:15::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 21 Apr
 2026 09:12:28 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9769.046; Tue, 21 Apr 2026 09:12:28 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v1 3/3] scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC
Date: Tue, 21 Apr 2026 17:12:15 +0800
Message-Id: <20260421091215.120632-4-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260421091215.120632-1-minda.chen@starfivetech.com>
References: <20260421091215.120632-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: NT0PR01CA0030.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:c::18) To BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BJXPR01MB0855:EE_|BJXPR01MB0519:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae20e48-3052-4265-0165-08de9f861c5b
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|52116014|921020|56012099003|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	ndu30Tlrck47y4+UX2Vxs8x3p5b+JttIg6R+ZjXNn9jUh9sj4z5jd1hiAF+QS+FNnGfuJDKxyzM9gcontgf/grFUQxbtrVp/fP58IL5Lz2o1ueLzULwkyyH0Vmb/05vq57KdW+qjU8ua7Gy5juKc6zNl2iuFetBL7uxvso8hURVvUhEX95Gpc1F1JLFaP2dFlluf6k82lA59cCitVy1jiaWhSK9ANT2JvTckbVyD9c5VWwjlaGPCrKDHTPMzbYjJJ5vamWae5PHXuLTgGf4h3jXygOHIVDI6VdT3xtqXRFXRFGD24FjL1FOnWpErCRj5DWbtQmq/shN4i270CO2rKkfVXgy2xlg6/9sp86kjMffUgXSbhR1njoqgt3jXRV1aGTtGoUsHU3PpXPV19pthWE1tEwFXkDx+Cs9LgnYd3KPX/yWrery5aSWY98+xbKxHJwvDTLGfPVLKs5/44NeyKNlEVylq9OTwUDVHpfP88FOGSpfwHz0LMkilw+ekaNTBE7HOom5+isHqruEdLTCwb04iQpQiI0zQMTJ8rarVq8bUDkYbHWCJ12FkBZ8HZuuBmnzVOKJVnWOGqYYq53Gh7ailVg1yFnixrx7v9iheprs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(52116014)(921020)(56012099003)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RkoF1lTBykgr3GL7zrYqy6DpjxjCk01X1PN/OjsV2U5Obw/QAJPYVg2N0bgL?=
 =?us-ascii?Q?J5nW/3lwV1HHuOafiNlMU5pT97PPHKmLMyk7tQiI9Zucyi1FsXuZdx6YV0UQ?=
 =?us-ascii?Q?wAWhptT+99l8PIIaXH9nzNUst6c70MOR7YOkdN3ZqwISOoC5U7yv0wBpRaUj?=
 =?us-ascii?Q?hc6+XDldzB68HfsYDkbWd60c56+D4vLjjt4B94NbTHx2WLTg+oGlP5SrUK8n?=
 =?us-ascii?Q?qtvONuj/nqU2I7M9XOshVQ7uRAushZDhtljEVIDCVUgNzsTADVpoObH28npu?=
 =?us-ascii?Q?PTlMNWV5bAFY/3CxRB0uu2r42w8FXBUW4HVdyFthc7H+yQmsFLZcuS6H2hJS?=
 =?us-ascii?Q?okMhJNjJmTK2BRg5uUK/Th0u4YaqyOtsBvqORZYW7f4UR9V0q09Hb2ufkAwX?=
 =?us-ascii?Q?mrySyg6cTX+Dnj5IktkWN6G1sA9ww8faKvjEDXGcoLmiZ1OzFHzC0OJ7NSM1?=
 =?us-ascii?Q?0d5hXc+OWzsto2IHxLmId1qt+2QCqs6wVBSIJZDoGdxieThypYvGyUp4CVx5?=
 =?us-ascii?Q?0bh9cTr3cCNW2WDVCdA+7dsjrl4c3mxlgnsRbkmDnaH2zjlOfUeuZSz938YD?=
 =?us-ascii?Q?k+ZtMYtnEsuCSbAYQnzjmX+YLb1skNnwcfEU5oZiWqXh/eWHJWicwnyaZfvI?=
 =?us-ascii?Q?hn06KWb6vBta0odDyW9Ryxgqml1K32KygU8ti+OmOFTTxH2GsqXx6gtdwcD1?=
 =?us-ascii?Q?AODUMLb3kQ73Ph1BSseVylvXKhCEZPR0arjwIMM07W+8D3s1Awldh8DJlddN?=
 =?us-ascii?Q?yAbJrCquj1GFga26HLHjiz+Ut+b4NycQlLCEb/cvf5Q3ydRyMilgRx0fCG1J?=
 =?us-ascii?Q?1zCIsHcjoua5A56aQrseuA9lGclFnGNBOngdREoskMRwgLv4vHjbjp06cciA?=
 =?us-ascii?Q?nJdsI8Dh7NmykPkceDLYweH72GHKtWs0uNQtu0ESrp86Q2PL8LS57ZwKGbdC?=
 =?us-ascii?Q?FpSco1aDPBNXAMI+lJhiTehEetWW1BcEfZQmkKDH0nlsHyJOz8b1aN+aLnqb?=
 =?us-ascii?Q?MiZf7n3o3aL39xUEpuIbyZlkBAx9zJt3ts9gRmiqXhfklARwfxXJ71Fa0kf/?=
 =?us-ascii?Q?P2swLyoZiwC5BGfOYXnHdkBqgbhtUbazcTFJKcjjaAFoFfbvm7Bm9NPYYcs8?=
 =?us-ascii?Q?QlYmtl/vl7rb/IO9J9AfCApUaukT4KwCvxzjQWnLRDZsdbPYShePSS3XYahh?=
 =?us-ascii?Q?0OWostwpY1WkW5/FPVI/bwKMWRQyyRuZENrNpaNgNFhhfUX2Vg2RCShy6YeT?=
 =?us-ascii?Q?bZVHwIEmzarCVGb0kPrMXdRmdxLZ1pNhx4CJ1RaEz0yI8XNuyBWGcohIIQ95?=
 =?us-ascii?Q?D3QJmv0rpMf/9PqXQ9EThI8wU/iIh/l8H5lNCTzhFYQfb5n+V7IdoeKTrmNj?=
 =?us-ascii?Q?20N5m+gYJDcTca/o5+c+cu26ctAVenw1qOetsf3qVUQHmku2Qho8suU2Khbw?=
 =?us-ascii?Q?ift1FcpwQWgLEnkYclA008iTxyn6J382LTWsdqzPLc1Za3eqLt99eEigrhY0?=
 =?us-ascii?Q?RUecTmv/sxiXPnvzG6LkMfFEvuRJx8zdxArf2UGdYEeBQtg3b0LiyIwOoUd7?=
 =?us-ascii?Q?QUu4wiZRb2341W5P/22DYhcvKKsKXbI4u+qYKUiFIiJzQOg+idX12W/Cp9Gk?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae20e48-3052-4265-0165-08de9f861c5b
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 09:12:28.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RD8OTgcPZdXCg3DpYBPPj7T2TME+ZlhxxTeHrcIs+y25YY/kTSa4IvwDvwfwhlNfHPNiiEY9h0Ezqa0WP4YXy01hlyrNNK0YifiMwBm5njU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0519

Add support for the UFS host controller on JHB100 SoC, built on
the Synopsys DWC UFS controller and using UFSHCD platform driver.
This controller requires specific configurations like
M-PHY/RMMI/UniPro

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 MAINTAINERS                     |   1 +
 drivers/ufs/host/Kconfig        |  13 ++
 drivers/ufs/host/Makefile       |   1 +
 drivers/ufs/host/ufs-starfive.c | 279 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h   |  17 ++
 5 files changed, 311 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-starfive.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3792c51da63c..658f65c78482 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27194,6 +27194,7 @@ UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
 M:	Minda Chen <minda.cheb@starfivetech.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
+F:	drivers/ufs/host/ufs-starfive.c
 
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 964ae70e7390..b742f7a2b0b6 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -168,3 +168,16 @@ config SCSI_UFS_AMD_VERSAL2
 
 	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_STARFIVE
+	tristate "Starfive UFS controller platform driver"
+	depends on OF && SCSI_UFSHCD_PLATFORM
+	depends on ARCH_STARFIVE || COMPILE_TEST
+	help
+	  This selects the StarFive specific additions to UFSHCD platform driver.
+	  UFS host on StarFive needs some vendor specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor
+	  specific registers.
+
+	  Select this if you have UFS controller on StarFive chipset.
+	  If unsure, say N.
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 65d8bb23ab7b..adfee2ae3b48 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
 obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
 obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
 obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
+obj-$(CONFIG_SCSI_UFS_STARFIVE) += ufs-starfive.o ufshcd-dwc.o
diff --git a/drivers/ufs/host/ufs-starfive.c b/drivers/ufs/host/ufs-starfive.c
new file mode 100644
index 000000000000..cdd5f9264cdb
--- /dev/null
+++ b/drivers/ufs/host/ufs-starfive.c
@@ -0,0 +1,279 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Starfive UFS host platform driver
+ *
+ * Copyright (C) 2026 Starfive, Inc.
+ *
+ * Authors: Minda Chen <minda.chen@starfivetech.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <ufs/unipro.h>
+
+#include "ufshcd-pltfrm.h"
+#include "ufshcd-dwc.h"
+#include "ufshci-dwc.h"
+
+struct ufs_starfive_host {
+	struct ufs_hba *hba;
+	struct regmap *syscon;
+	struct reset_control *core_reset;
+	struct reset_control *phy_reset;
+	struct clk *ufs_clk;
+};
+
+#define SRAM_STATUS		0x38
+#define  SRAM_EXT_LD_DONE	BIT(1)
+#define  SRAM_INIT_DONE		BIT(2)
+#define UFS_REFCLK		0x3c
+#define  REFCLK_OEN		BIT(8)
+#define  RESET_I		BIT(9)
+#define  RESET_OEN		BIT(10)
+
+#define MPHY_POLL_INTERVAL_US	100
+#define MPHY_POLL_TIMEOUT_US	10000
+
+static int ufs_starfive_phy_config(struct ufs_hba *hba, struct ufs_starfive_host *host)
+{
+	static struct ufs_dwc_phy_pair_data phy_data[] = {
+		{ MPLL_SKIPCAL_COARSE_TUNE, 0},
+		{ RX_AFE_ATT_IDAC(0), 0x8a},
+		{ RX_AFE_ATT_IDAC(1), 0xc2},
+		{ RX_AFE_CTLE_IDAC(0), 0x8e},
+		{ RX_AFE_CTLE_IDAC(1), 0x8b},
+		{ FAST_FLAGS(0), 0x0004 },
+		{ FAST_FLAGS(1), 0x0004 },
+		{ RX_ADAPT_DFE(0), 0xa00},
+		{ RX_ADAPT_DFE(1), 0xa00},
+	};
+	struct ufs_dwc_phy_pair_data *data;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(phy_data); i++) {
+		data = &phy_data[i];
+		ret = ufs_dwc_phy_reg_write(hba, data->addr, data->value);
+		if (ret)
+			return ret;
+	}
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYDISABLE), 0);
+	if (ret)
+		return ret;
+
+	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 1);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ufs_starfive_phy_init(struct ufs_hba *hba)
+{
+	struct ufs_starfive_host *host = ufshcd_get_variant(hba);
+	static struct ufshcd_dme_attr_val rmmi_config[] = {
+		{ UIC_ARG_MIB(CBRATESEL), 0x1,
+					DME_LOCAL },
+		{ UIC_ARG_MIB(CBREFCLKCTRL2), CBREFREFCLK_GATE_OVR_EN,
+					DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN0_RX), 0x01,
+					DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN0_RX), 0x02,
+					DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(RXSQCONTROL, SELIND_LN1_RX), 0x01,
+					DME_LOCAL },
+		{ UIC_ARG_MIB_SEL(RXRHOLDCTRLOPT, SELIND_LN1_RX), 0x02,
+					DME_LOCAL },
+		{ UIC_ARG_MIB(EXT_COARSE_TUNE_RATEA), 0x25,
+					DME_LOCAL },
+		{ UIC_ARG_MIB(EXT_COARSE_TUNE_RATEB), 0x51,
+					DME_LOCAL },
+		{ UIC_ARG_MIB(CBCRCTRL), 0x01, DME_LOCAL },
+		{ UIC_ARG_MIB(VS_MPHYCFGUPDT), 0x1,
+					DME_LOCAL },
+	};
+	int ret, val;
+
+	ret = ufshcd_dwc_dme_set_attrs(hba, rmmi_config,
+				       ARRAY_SIZE(rmmi_config));
+	if (ret) {
+		dev_err(hba->dev, "set rmmi config failed\n");
+		return ret;
+	}
+
+	ret = reset_control_deassert(host->phy_reset);
+	if (ret) {
+		dev_err(hba->dev, "Failed to reset phy\n");
+		return ret;
+	}
+
+	ret = regmap_read_poll_timeout(host->syscon,
+				       SRAM_STATUS, val,
+				       (val & SRAM_INIT_DONE),
+				       MPHY_POLL_INTERVAL_US,
+				       MPHY_POLL_TIMEOUT_US);
+	if (ret) {
+		dev_err(hba->dev, "wait sram init done timeout\n");
+		return ret;
+	}
+
+	regmap_update_bits(host->syscon, SRAM_STATUS,
+			   SRAM_EXT_LD_DONE, SRAM_EXT_LD_DONE);
+
+	ret = ufs_starfive_phy_config(hba, host);
+	if (ret) {
+		dev_err(hba->dev, "configure phy failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ufs_starfive_init(struct ufs_hba *hba)
+{
+	struct ufs_starfive_host *host;
+	struct device *dev = hba->dev;
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = container_of(dev, struct platform_device, dev);
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return dev_err_probe(dev, -ENOMEM,
+				     "no memory for starfive ufs host\n");
+
+	host->syscon = syscon_regmap_lookup_by_phandle(dev->of_node,
+						       "starfive,syscon");
+
+	if (IS_ERR(host->syscon))
+		return dev_err_probe(dev, PTR_ERR(host->syscon), "getting the regmap failed\n");
+
+	host->core_reset = devm_reset_control_get_exclusive(hba->dev, "main");
+	if (IS_ERR(host->core_reset))
+		return dev_err_probe(dev, PTR_ERR(host->core_reset),
+				     "Failed to get core clock resets");
+
+	host->phy_reset = devm_reset_control_get_exclusive(hba->dev, "phy");
+	if (IS_ERR(host->phy_reset))
+		return dev_err_probe(dev, PTR_ERR(host->phy_reset),
+				    "Failed to get phy clk reset\n");
+
+	host->ufs_clk = devm_clk_get_enabled(&pdev->dev, "ufs");
+	if (IS_ERR(host->ufs_clk))
+		return dev_err_probe(dev, PTR_ERR(host->ufs_clk),
+				     "Failed to get ufs clock\n");
+
+	regmap_update_bits(host->syscon, UFS_REFCLK,
+			   REFCLK_OEN | RESET_OEN, 0);
+	usleep_range(2, 3);
+	regmap_update_bits(host->syscon, UFS_REFCLK, RESET_I, RESET_I);
+
+	ret = reset_control_deassert(host->core_reset);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "Failed to reset core clock");
+
+	host->hba = hba;
+	ufshcd_set_variant(hba, host);
+	hba->caps |= UFSHCD_CAP_WB_EN;
+
+	return 0;
+}
+
+static int ufs_starfive_link_startup_notify(struct ufs_hba *hba,
+					    enum ufs_notify_change_status status)
+{
+	int ret;
+
+	if (status == PRE_CHANGE) {
+		ret = ufshcd_vops_phy_initialization(hba);
+		if (ret) {
+			dev_err(hba->dev, "Phy setup failed (%d)\n", ret);
+			return ret;
+		}
+	} else { /* POST_CHANGE */
+		return ufshcd_dwc_link_startup_notify(hba, status);
+	}
+
+	return 0;
+}
+
+static int ufs_starfive_hce_enable_notify(struct ufs_hba *hba,
+					  enum ufs_notify_change_status status)
+{
+	u32 val;
+
+	if (status != POST_CHANGE)
+		return 0;
+
+	/* Disable Gating clock. Auto hibernation quirk */
+	val = ufshcd_readl(hba, REG_BUSTHRTL);
+	val &= ~(LP_AH8_POWER_GATING_EN
+		| LP_POWER_GATING_EN
+		| CLK_GATING_EN);
+	ufshcd_writel(hba, val, REG_BUSTHRTL);
+
+	return 0;
+}
+
+static struct ufs_hba_variant_ops ufs_hba_vops = {
+	.name                   = "ufs_starfive_platform",
+	.init			= ufs_starfive_init,
+	.link_startup_notify	= ufs_starfive_link_startup_notify,
+	.phy_initialization	= ufs_starfive_phy_init,
+	.hce_enable_notify	= ufs_starfive_hce_enable_notify,
+};
+
+static int ufs_starfive_probe(struct platform_device *pdev)
+{
+	int err;
+
+	/* Perform generic probe */
+	err = ufshcd_pltfrm_init(pdev, &ufs_hba_vops);
+	if (err)
+		dev_err(&pdev->dev, "ufshcd_pltfrm_init() failed %d\n", err);
+
+	return err;
+}
+
+static void ufs_starfive_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&(pdev)->dev);
+	ufshcd_remove(hba);
+}
+
+static const struct dev_pm_ops ufs_starfive_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+};
+
+static const struct of_device_id ufs_starfive_pltfm_match[] = {
+	{ .compatible = "starfive,jhb100-ufs", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ufs_starfive_pltfm_match);
+
+static struct platform_driver ufs_starfive_driver = {
+	.probe		= ufs_starfive_probe,
+	.remove		= ufs_starfive_remove,
+	.driver		= {
+		.name	= "ufs-starfive",
+		.pm	= &ufs_starfive_pm_ops,
+		.of_match_table	= of_match_ptr(ufs_starfive_pltfm_match),
+	},
+};
+
+module_platform_driver(ufs_starfive_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ufs-starfive");
+MODULE_DESCRIPTION("Starfive UFS host platform glue driver");
diff --git a/drivers/ufs/host/ufshcd-dwc.h b/drivers/ufs/host/ufshcd-dwc.h
index 8091f186a9b3..ab8728f92b22 100644
--- a/drivers/ufs/host/ufshcd-dwc.h
+++ b/drivers/ufs/host/ufshcd-dwc.h
@@ -12,7 +12,15 @@
 
 #include <ufs/ufshcd.h>
 
+/* ufshcd vendor specific register */
+#define REG_BUSTHRTL		0xc0
+#define LP_AH8_POWER_GATING_EN	 BIT(17)
+#define LP_POWER_GATING_EN	 BIT(16)
+#define CLK_GATING_EN		 BIT(12)
+
 /* RMMI Attributes */
+#define RXSQCONTROL		0x8009
+#define RXRHOLDCTRLOPT		0x8013
 #define CBREFCLKCTRL2		0x8132
 #define CBCRCTRL		0x811F
 #define CBC10DIRECTCONF2	0x810E
@@ -24,6 +32,8 @@
 #define CBCREGRDLSB		0x811A
 #define CBCREGRDMSB		0x811B
 #define CBCREGRDWRSEL		0x811C
+#define EXT_COARSE_TUNE_RATEA	0x814D
+#define EXT_COARSE_TUNE_RATEB	0x814E
 
 #define CBREFREFCLK_GATE_OVR_EN		BIT(7)
 
@@ -32,9 +42,11 @@
 #define MRX_FSM_STATE		0xC1
 
 /* M-PHY registers */
+#define MPLL_SKIPCAL_COARSE_TUNE	0x28
 #define RX_OVRD_IN_1(n)		(0x3006 + ((n) * 0x100))
 #define RX_PCS_OUT(n)		(0x300F + ((n) * 0x100))
 #define FAST_FLAGS(n)		(0x401C + ((n) * 0x100))
+#define RX_ADAPT_DFE(n)		(0x401E + ((n) * 0x100))
 #define RX_AFE_ATT_IDAC(n)	(0x4000 + ((n) * 0x100))
 #define RX_AFE_CTLE_IDAC(n)	(0x4001 + ((n) * 0x100))
 #define FW_CALIB_CCFG(n)	(0x404D + ((n) * 0x100))
@@ -64,6 +76,11 @@ struct ufshcd_dme_attr_val {
 	u8 peer;
 };
 
+struct ufs_dwc_phy_pair_data {
+	u32 addr;
+	u32 value;
+};
+
 int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status);
 int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
-- 
2.17.1

