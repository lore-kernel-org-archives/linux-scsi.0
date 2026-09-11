Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2132.outbound.protection.partner.outlook.cn [139.219.17.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F123430309;
	Fri, 11 Sep 2026 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122277; cv=fail; b=JAUPWXoDqa7j4z9Fat/dL7Mn/Vd7t+zWq/PjQabjPLKdUhTAY7UwzsX5jIYq96WypV4DxuHnHNOTGiyz9PUcmjNxoEh7NwpJd7ACC7YnMi2X4KE9h4WArDZU5uyyjZFsRA6fPmC0s+MzhRr77cZJFwdT6JkpnHs2+s8oNOh4FxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122277; c=relaxed/simple;
	bh=7jXBIchFoQhZdYUX+FMUwr2OOE+Gk47R3gLg9n8TWTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B1HcrvyVPelSa0reYkOUwRt0BUtuHWdb5L+7pQbaGe/W812nT6zHmMRubqZ22mINwT4z7xPB6fe4M44YWN5Xu/ci7M6M8Zkb6dymzG5I0NqdJ6Q8o9mAHvA6SC5WbGWzuYAiP/O/gwgunBkK8jw4UIkgkyQxTNbvJ5Ywc32UPzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W83k7nl88Xfq+moD0wixGv73JC3/Rm3WDSq3DjNE3JQySeqUh4xJPohRHOLmytXltK7rvjXzlXL+9LDVoprQjUQjDn07RPmOPzVVVlujgxbpYtTpxxPkBMZW7y6MjTe3b7JK3wPHsUQ5DzYDHLS+UVP1Y6U495SBmLTOm0uauntAWH2fE1cbllJva1V3lzPinrLRcJ8aTttPJes7HzneSf9/DNORVGpjrp+HkP79Z01MJkM9BnUctB1xjaNi7hfdME09mEegc1jo5VGl3FRy7OztzKWohNhEFzxUa2HbXrDyqYUe8fubOojBxxLylATf2jnDEmhIg2ZEqS5/NMRcKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7pFBtxc8vj5Rn3u0QX5IrAI42XcfMuWLWiuVSrhHNo=;
 b=V2fOm6gUMQiXhq5o1gNWKlC2VX9Th6/yl+ir5ejcb3yngbOZSLIjftUaXkNKWlUORXaFJnzIn5GQaLqmC8PQXyxT1/7CHp0EDnEw/FwO9sGYIfxF+xsIR4pHnh8Z1tZKJ0AcHuq6BMRrJniciOvdmU8H5s3O7GPLFk9IzCPrmEcwYWVJQRCpowSn3LYfGYJqHk1wEPrIFqEK7bSa757kzX71TQZFRJNmMeVHM7j2CuvRMkmZLWIVnp+4DNexn5qQq3VMu26Ebbfx9wk8xvTKlsncV7HExVEZEhY02psRN/HumVuDC8pzu59fyaJ8OkeRk5vuWDYHZzPWW5RzlZQnKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15) by SHXPR01MB0573.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.18; Fri, 11 Sep
 2026 10:24:15 +0000
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 ([fe80::9b99:12dc:a115:b90f]) by
 SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn ([fe80::9b99:12dc:a115:b90f%4])
 with mapi id 15.21.0339.017; Fri, 11 Sep 2026 10:24:15 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v3 3/3] scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC
Date: Fri, 11 Sep 2026 18:23:59 +0800
Message-Id: <20260911102359.83288-4-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260911102359.83288-1-minda.chen@starfivetech.com>
References: <20260911102359.83288-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: BJSPR01CA0016.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:c::28) To SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SHXPR01MB0863:EE_|SHXPR01MB0573:EE_
X-MS-Office365-Filtering-Correlation-Id: 5576a1a5-3d87-4390-7687-08df0feed476
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|366016|23010399003|1800799024|38350700014|921020|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ofXG+xTi5AfQrheXm4KO67wnVzHMRWIFn6KC8IWUAieFDbUvhvZBMzei4DUgcyT8nNaBBBZ0oxRwVIm3y/uy5G5s9d3cCDjXixYqKXQaSvlPYYY3s6n8QOg4+gBghwGv5nDZIPA+MEMPtlunvsc6En95cDBS/Hyg+vWqwaQ+B4Qy4GLCR2hbl8BY1zH11k/Q09q0WYLcjz2oitI0dA3bQfslHXi6KajkrkUUdL1s8bZ2IvGqazmOCUtzprMAaqiSSDGhahTaPPb4fgWHdmyOwI0rMYu8QLx1qME632HB1DnPH5p8bhnsygzyODPtDiTH2bhplrVMfSigxHxn8kcJc4SKYBHvMA0IeOU9KzxwV491KCtntVDH6+N3RiYwHLizWqWLvyelk6xbHMLtY4eCcpdstnY+EzubIVl/9oO89Ea3Z9I8Od8tqdbVjgkjh1p/lE9YmG1telJFA2uv1lrYR5nUDgJikkQlcaGb0DYoFk9fGC13a4esINfL3dEZB9PUyqNNB5b5puIbs5ngw2RnSWqNRiPo3iUd1cwBaGofLSSvupttvJSgTmGbcmuvcwY8xbEUZLTW1v0qq073DK8J5g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(366016)(23010399003)(1800799024)(38350700014)(921020)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E4vUZ14ViIT94A8GaPnI6N9ffBDpPqVsGvBZ5VBe9KY5Dv7P7ACVirAK4APt?=
 =?us-ascii?Q?rgJFswEamIdjXsBw3IN8MW1sMI4Fl9u0KEYuyOj2qP5BvvWVqxmReMmQxNZp?=
 =?us-ascii?Q?8OcIJPFy4fMfl1+NUQotSzVi0tt1RZtlEnTLIj/8cO1yvd3DQdbLg/jgFQtK?=
 =?us-ascii?Q?GZpatC5V1ul9wqqkJ7vI0wFvpa12t8iAtGAJdLXfK9HFwHKMvgCFsjLMPfRT?=
 =?us-ascii?Q?1k/nhDhD/2+xm7DZ6d1MOUji543QtTApfuNtyhVfHT0IyHQ4hUQhtPL4lHAl?=
 =?us-ascii?Q?Y6jjGZHyqViBhx10XFDEHpLnaTAvRZ7vygif1suWN9eNaDc4zJd3/iWn3GL9?=
 =?us-ascii?Q?YUHGNOSvW15p4Pu2V0QZC4V7GU3BsM8aRw/qlhZrrqifDtNpbWeS21229lsd?=
 =?us-ascii?Q?xY2idfKcjLDlZe/56i39SMlh1LJDbeXa3BCffaEL21PxklFYpsXN6pWNiNDd?=
 =?us-ascii?Q?5zvSbH+e+jQQ7hCLPoSSK2jZkS+PkfXzWki9kKCnNDHgiNb5t2Pl7jbqTcJF?=
 =?us-ascii?Q?REsjfGtioWrvn9yB1C0qaoJAnARj/XS/q8i0ZpcRp3AQW77MUYKiKe7mhtyN?=
 =?us-ascii?Q?w9d0Qz3L67yZJ2nyH4eXEAWcm6Eq2zVGk4TxksCuneWAZRh8CWgw0P8Y/bh3?=
 =?us-ascii?Q?JAHMGXDNhiWCe508vOy2hUMODDKk3fj3NXrD2dsMwq/Z7PiskgxvATPvTfcK?=
 =?us-ascii?Q?itUn7QaGZHLdrTgzfZnUNmGZqDcmcfmbXglBBTnbInhkI1wOOaImC2n1wAcl?=
 =?us-ascii?Q?TcrHPyG60VPkGxdsWCHsJCx4Snbonga/A/lQRQyBP2S+qn41ixt/tVLHRtZY?=
 =?us-ascii?Q?9TTjKVsC9565Ly/nSD7UYJK+0uJldLzjD7V3BGRgTQLW/oDlh6a3qQhIWP8l?=
 =?us-ascii?Q?ioAu4N1MrlqOyBUri0mJMghFtns0hxjZinIWF5UxgEOWyNqtkj9e3mkEacua?=
 =?us-ascii?Q?CT5XuMh1WPHpLxV5d53eBDuoIz1w63CkcpxZh6bQjKmfkL3b2emMnb1ncjiA?=
 =?us-ascii?Q?n/P+z1JULZC1bRZAdYN0XAwCrBSQX6VBrxS8Eb4p7Mwi++c/q3nKdpMB2l4V?=
 =?us-ascii?Q?CXOGzfiGHNHSy3Yg4ILeQsnFAdBD40NFgVT8XNzwcZfvLTI7QglFYfmVIx4v?=
 =?us-ascii?Q?sw/HSHx77KriY21qtxuwdRFl28nn/d/pI0KrqC8dV2I4ayYzmAVrtSmLVnA6?=
 =?us-ascii?Q?XSTyH/nDIok/dSPmeBqXYcVSTOctGIBKPJlEYKvgN0IasJdkekjfGvIq2UKz?=
 =?us-ascii?Q?1Hs+zZo2Mzcl3mMNFhQFQ+s4HVYf+dSCQp9pPIgJLichkzN6FBGnyKGH6uDr?=
 =?us-ascii?Q?3Jf+S4p2BUEbwKnsiLQSvBK4nl54uqW49LyZ24vyTPOBWo2YRU+ZjDcFZ2cd?=
 =?us-ascii?Q?rsw0LoO6B4ALdKimUNp8lcCtzviX5Z8u6+bG7ycuyZSuHmsbCJhR94Lpdixz?=
 =?us-ascii?Q?x+/wPQKHNGppU5qm/3NVLfbAhdJ6dWz8mrPQZyXV12KNtumMlQUgqgSvsZV9?=
 =?us-ascii?Q?cPESbXq9EfqYSMIM2PKi3V32iF3v4SS2trxF02KemSDo44itqXJ2CPD3cyzI?=
 =?us-ascii?Q?Bm7pc76bZFgPRcjkjpgB61fntsxbpibZS/vlTpLwOJQebFJpBN4yH99qBlRX?=
 =?us-ascii?Q?XnEpAxt0y7Ocd0dxLidLKdoQvuaeUlIz9wtXGRbb/vGrFrYq2ASiHn1Tun85?=
 =?us-ascii?Q?SbeHt8TWUZX2MXaz/zx+k0w5SA0Cv7LpFQC8peMJpHYL2MHvZQCngB/ReUFq?=
 =?us-ascii?Q?K/CEYrJrIDoHAA/Y2jiv0Pq6Bm+Mcu8=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5576a1a5-3d87-4390-7687-08df0feed476
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 10:24:15.2332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56drpEQxeyA5enW5RjKF2i65yHVqkVZbIXc5xw1fLIPo4iC7g5zkEXMeYNMsEYutQqr2R9yyiUcV6uxXmfxtxZP6mRmfh+oN36reRNKzixU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0573

Add support for the UFS host controller on JHB100 SoC, built on
the Synopsys DWC UFS controller and using UFSHCD platform driver.
This controller requires specific configurations like
M-PHY/RMMI/UniPro

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 MAINTAINERS                     |   1 +
 drivers/ufs/host/Kconfig        |  13 ++
 drivers/ufs/host/Makefile       |   1 +
 drivers/ufs/host/ufs-starfive.c | 297 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h   |  18 ++
 5 files changed, 330 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-starfive.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 10b0d0839ca4..de81bd15f3bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28099,6 +28099,7 @@ UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
 M:	Minda Chen <minda.chen@starfivetech.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
+F:	drivers/ufs/host/ufs-starfive.c
 
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..9d96f5bb92ef 100644
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
index 7d8db67eb23c..9c6c2897692d 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
 obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
 obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
 obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
+obj-$(CONFIG_SCSI_UFS_STARFIVE) += ufs-starfive.o ufshcd-dwc.o
diff --git a/drivers/ufs/host/ufs-starfive.c b/drivers/ufs/host/ufs-starfive.c
new file mode 100644
index 000000000000..fab65da0507e
--- /dev/null
+++ b/drivers/ufs/host/ufs-starfive.c
@@ -0,0 +1,297 @@
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
+	bool	phy_init;
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
+		{ RAWAONLANEN_DIG_MPLLA_COARSE_TUNE, 0x51},
+		{ MPLL_SKIPCAL_COARSE_TUNE, 0x51},
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
+	if (host->phy_init)
+		return 0;
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
+	host->phy_init = 1;
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
+	host->ufs_clk = devm_clk_get_enabled(&pdev->dev, "main");
+	if (IS_ERR(host->ufs_clk))
+		return dev_err_probe(dev, PTR_ERR(host->ufs_clk),
+				     "Failed to get ufs clock\n");
+
+	regmap_update_bits(host->syscon, UFS_REFCLK,
+			   REFCLK_OEN | RESET_OEN, 0);
+	udelay(10);
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
+static void ufs_starfive_exit(struct ufs_hba *hba)
+{
+	struct ufs_starfive_host *host = ufshcd_get_variant(hba);
+
+	if (host->phy_init) {
+		reset_control_assert(host->phy_reset);
+		host->phy_init = 0;
+	}
+	clk_disable_unprepare(host->ufs_clk);
+
+	reset_control_assert(host->core_reset);
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
+	.exit			= ufs_starfive_exit,
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
+	ufshcd_pltfrm_remove(pdev);
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
+		.pm	= pm_ptr(&ufs_starfive_pm_ops),
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
index 8091f186a9b3..71a60ede6805 100644
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
 
@@ -32,12 +42,15 @@
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
+#define RAWAONLANEN_DIG_MPLLA_COARSE_TUNE	0x7014
 
 /* Tx/Rx FSM state */
 enum rx_fsm_state {
@@ -64,6 +77,11 @@ struct ufshcd_dme_attr_val {
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

