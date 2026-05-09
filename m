Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2111.outbound.protection.partner.outlook.cn [139.219.17.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBF233F59D;
	Sat,  9 May 2026 06:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778308106; cv=fail; b=UqwJSDyHQInFJeP6NfBxamXHFW2FK+ft8JFD0/NJO7NVLKEtgWCQfteC6ytu/kIu28yMO/7RdihyaW6VmeZ53dLtywUWBRKeYxpBvrIx2MFKBprkPzAzWOjkzhz9EJUGU21i6CulJ2Ib570TN7PgzZ53YfIHI29wR2/LO+jEJW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778308106; c=relaxed/simple;
	bh=tUxwTxQgXJBtpcTpARP8lZDcgEdYlKYKR8WfJWElDoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H13NH3ZHLgIu+djVVnHrQ4bvUfwpJJ/kh64p5jOhfkT3hudA+Hz+SpmyN5T+C2WxQM7VgumZqSMiK6QXpPvpobTqGGmeWutJND5gQ6N94YgrSBS2kyyOQTsPupSJlBv6aUFQV0PwuNJn3DkFElE13c1GjlE/XJlyoAzs1tLqWpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uh1II72/lL3uvcMiWHRKBQLveTeWvYK1NIFyl6DkGK/Y0WOMyrB6u8qBG5q7VvgxBnAU4uY87evsnerAmsAZ3eRbNwIZTE9KZY9z1SKJtfWIAPDGvzAl5E88F8XBcTaRMyn3pn9+R57O/FaNCiL2oeDB3KKa7vCIAggZtzS6Vf0s3ewONQ/6xDl+XQXHvbEex8+Mu2S5pUrpBKdH1veju1fnzvzuw9wNEjk0gYWl2W5Y4YWt4/or0G/WdN0sEohomhwEJZpwX2SkE42JE+KfVVaAWywdrPxe8nYvwejSG7t/0WoPADK3qjrqnJr7eEcsGS4yzGyV0pai3UXUtUx3Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/amF1DATFZG0ALsRmZkVje3jjMOUAXqZjPhfR64xRI=;
 b=LRxVo+gyT2wZsupFAccT/YikrOBAH/dKJUxemT1MZVOnxLDwVtWKMXawliHyr9LfqR8+6fO0hCWixqB+hjAOqBmgAEun9xj4FcOPjGf+4y/f0cHhVXDEBzEojkcxTM6p2eMhWDzJ0AndU0c6xUQkD/V5wyi7+wS2IjLCk0j07F2f90huDCKZIvlAlSw/qXIumGU9Tm7sa8B3twa1KdLUUe8VwEdno8TPIrXPqdEceAa1H8wJ1ZzfLA2c3WFZJvca2BaDVnBTF+Mm/VVCPnmAKfnr/jyqWkcmZUhTTbHqI1hDy5aMkiDxZEbnSPbBZMww8OjHl0c22IOKSeGjwIgF6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0744.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:1a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Sat, 9 May
 2026 06:28:11 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9846.025; Sat, 9 May 2026 06:28:11 +0000
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
Subject: [PATCH v2 3/3] scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC
Date: Sat,  9 May 2026 14:27:59 +0800
Message-Id: <20260509062759.125472-4-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260509062759.125472-1-minda.chen@starfivetech.com>
References: <20260509062759.125472-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0018.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::15) To BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BJXPR01MB0855:EE_|BJXPR01MB0744:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c68b00-2a9b-433c-646c-08dead94247d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|1800799024|366016|921020|56012099003|22082099003|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	hJmwBNEcXHy7kDR3/HRA2S348NKqyuDtj0vVJQy2GSmfWgutjdwsjtcLFaN16q8emZCqVlZNbHxcimHr99wRpTIZe0oF0IDFyLPh3nl3k7dD3snwL7hp6Ryy9XQfpG9C/6P5iWmInww7bfp1TZa7gF/K0zTa1aS4v8QGIJt2lGbM/tv2Y/TRQBH/JqJY+Jy3ARZCi3xO3NNHF6HGVeZQsnpvy4iiIX/JYJiM6m10EOd2hsjho63OSvZPIcs8KB39kTC4LDE4lnxdF2N2kaJOH7/T4Yk7/sPNxS3BwuG7eqKXLCLgzH5NOPf3hEldy/OLOnf8TRBYg7+PiJ5A3fqCbm8a8bfa05UBIN21AayuxNtF5PWWzKEk0ZTPZu29CwiH331B8pf+WUvfdBjq1iMJVZbi1axcuAolQEaPNiPVzTsS3ftu4cuLU5+GkU38Yi6Vq8J9MjhCGk/IcOWqqiT4znr6tg2tgr7qGAkMGaNCnhIjP8pLIWcDSP3RdduohcAbXbYZo+UaUPX3w12QzDsGeJ+c0wyuYb8Tsu0g4aZojSJ2UPd1AsQrHzgGOCFlTB1F2hiDfjwgunWn86ixFOfGjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(1800799024)(366016)(921020)(56012099003)(22082099003)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BShD2qmNa2STdocOi/QZR+YtoHNH/xUC4scFUrVZRv4TWd5FTyPHoQjHW1/4?=
 =?us-ascii?Q?EOV/mKUVyOjmHo+Rn+NSaHZEzOcnlh0DKebv/6kqON0AeHMFg5Z0rpiTZ7Qb?=
 =?us-ascii?Q?lo+G6h0konVj2yNeAd2kLtyvd29XZmiCMimJAC9quKN+YEHJSMM/C4tRtyYT?=
 =?us-ascii?Q?/5ZYpr+89Z9DmWVbzn0M1YKzf5N4OSVsc0dWD8y1UN8WDRpbLGuIvSFw3cYd?=
 =?us-ascii?Q?ny6GLjKOvDc3lgn+og2/hKof2TRzYCDbS/ooW1DhBOwyNe0a+R3UXlhTGNEp?=
 =?us-ascii?Q?DxNVEwb7Oby6DMJ7c0M40JPNTqzZp0LBkKFL4ZXNlJmxCUPShmNRSrb2t6Ok?=
 =?us-ascii?Q?xCAeUZx/6TVZWE446frP689MzmBB2vTrziLAQOtwk8zBMkOCNk7iYENXdzi6?=
 =?us-ascii?Q?azz0QYkGuPKYX8s78lRr4K/FNQC1MxeE97zIxeiPpctTxLEPfomrsFnip3BZ?=
 =?us-ascii?Q?XcZWtzB77E8iOcV8n8FCE8clF8qEBaL2HiZQtOglWM1nOVmQ0FWw7IbxHfmZ?=
 =?us-ascii?Q?jdr6J36sKvSFJ1yKPU2Cic7BqcGOc5BnbncNQac5BZiNO1KsI8QYwlHsx7s2?=
 =?us-ascii?Q?kWC5slNjiQzRqu1jNYToZPUhwSbfQ0RTmu3Mzit8t+IRa98CUIN+fWERqmi1?=
 =?us-ascii?Q?IYeUn03Tz1716VOesATd6iCWfy26RplUNWWYMG/bO+JM6j1s6ZABe04VfbWa?=
 =?us-ascii?Q?LK73pQolzpFFLYW9xhS2sjaH2AKklKOiSnCcawZ2+X5dRwfqnDUiGKr5xmTE?=
 =?us-ascii?Q?3Z3wC+MSRML9CTvCOhHiH4td7Ox/Scn7pSPUChPX6H1+wlZKCA1M/LVb+DB6?=
 =?us-ascii?Q?zOvRokbRv0/mrLCw8WsqKpcIEcm8pN71Epyep6sZm2BgthC456ZbJyI+mxar?=
 =?us-ascii?Q?BnpYSZKyeidRcEADyB0oLQRxn8dySWJuFPCSaQs7/03/G3y4Z3eKKM61lWPz?=
 =?us-ascii?Q?eNh2aZjTF/Di6HZO/fC+2aFyfui98KNPyq9O4tm4P/RSacDnnJNpR6nSuEpx?=
 =?us-ascii?Q?qNh7v1Gqpn+IbeYtcEqEtns0PNOL6fny7tEbBPi+GtOHszqtMUwUb1qa3Dut?=
 =?us-ascii?Q?gznCTxFhIrAa7dQBYWQiywejn4cX5z1YgZzFBhyfM2JAgaC0uLLbeugypbQN?=
 =?us-ascii?Q?vGfXD0n8ix2mfx/AbXEGmg9vhYfrHci5QjyzTxmW7WXfs9ThkyOh11O2g4Hs?=
 =?us-ascii?Q?6VdJG+CIQ2CrJghHkRR9920GsOp0A0E5nXCnwagL0c0PHYClZZ43hLm2++CL?=
 =?us-ascii?Q?qVo193NxJ6YcSFnrWW/n/6ShNgvPMcLoo7hEHBm68j0ybLS/oyq/zvdrtEgt?=
 =?us-ascii?Q?smIH+CP5OWrcZ2XQMWIEn/HpJlIM1lhKjkjfFy5Kq27rH1eZXX908SXXr/RU?=
 =?us-ascii?Q?aAlrqOmCL0BHzuRcllRmBR+Fn+x45O1wEprv3NVCYQ/KGPAM2X5dgOxmn2fb?=
 =?us-ascii?Q?KQvuv/rDvB1EumiFb5koqMXBd16jimLFwjQoyHQVprJC8veGFhd8zpLc4h5d?=
 =?us-ascii?Q?Hacc9PyaL0OPsjUmSJ419h3HPXDRjaOrSfwHPUOEeQKCRZ5I4IID7WJymwtG?=
 =?us-ascii?Q?PFCCb1zsIZXMCjTu2jX7umQK1k+ej+33sqHFM96bSMrJ40EpZGsRp841/17J?=
 =?us-ascii?Q?zjwHtrC6MJ40hzkPY6LQaUe/5/5qrOZoTMLfH9megdojVp0jUw8ikXpZW3r3?=
 =?us-ascii?Q?usxkJ3yrmnFrGh5aRk+6JyzoRyNNaw9qfGj36o5wevYAteJiB36vJPlhpN1F?=
 =?us-ascii?Q?pBe3kTFCqkSPeubxkGDgFlcNlctUNYA=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c68b00-2a9b-433c-646c-08dead94247d
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 06:28:11.3573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yuFSeDj74YH0IKDX/8xiOYNUbDvn1oivncqwDplCYPYAEDpbXIoKS9gZMueLY7bT78R4db5c3GlipCtd+ilf33vu4GMy0fLqGPHNnhC2xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0744

Add support for the UFS host controller on JHB100 SoC, built on
the Synopsys DWC UFS controller and using UFSHCD platform driver.
This controller requires specific configurations like
M-PHY/RMMI/UniPro

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 MAINTAINERS                     |   1 +
 drivers/ufs/host/Kconfig        |  13 ++
 drivers/ufs/host/Makefile       |   1 +
 drivers/ufs/host/ufs-starfive.c | 280 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h   |  18 ++
 5 files changed, 313 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-starfive.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d222150e015..8021fd8a3fe0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27482,6 +27482,7 @@ UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
 M:	Minda Chen <minda.chen@starfivetech.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
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
index 000000000000..3e91461aef75
--- /dev/null
+++ b/drivers/ufs/host/ufs-starfive.c
@@ -0,0 +1,280 @@
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

