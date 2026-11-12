Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794470209;
	b=VeLCp2+qHUwjj+t6D4CF5d5vJ3aiVmrfqCoZFN+PLKCSYH64yGTYIT81TTmvZ8LsYnXZ
	 Pi4DDJ8tuvKp4kjV1ByZ9uVxL6ed4AEAHwESalWQT3ER2U0JOZM9Ew5rJ7XZPvG6Zs57V
	 mZkOhtxLwL4zNU3xRghsmacOWwsS9zP7xz+8wpx/R8KOXKNC8Rx6qsDoKSE3igg1F1qgH
	 jicSdkAZmCY/OJ6kjryBNCrvR/YoR2J+xT1kkeQbFUDg/rzl4pUeM0TvPwMjnrqRa7lL9
	 LYIOlHasmaR1VwyvYgkN1UCf9GuuPBUxmAEQS7PHetyu7ITGBVVmt52neGm8iZnNrhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470209;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Type:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=JlFuRtkoE4OEKSsYwrKNmpt3e9RTsd7Q1vWq5b4IQpA=;
	b=M0TW8SnMBvEJMxM/IFpdWu8GAUjYD47qtTiL9wsfDYSo10f9J+CMjsyJYOvBIUsJB34n
	 xoQIa5/Trau6QVYAXYUzSNR4k2S0IxOBKHZZkcqdjfcXW7lzIoT/mDaySJUY4uK5x3ltU
	 8ZdOjf5xc1qIiG11Es3GZhhVaQg7rXuKtHx1l3Z3pUaIJxFm/naP+aWdoFOyF/mRoPB8u
	 zpz+D9yOFHvuyHXMPoMU4C55oGjQJfVoyp2/SxtpQXpxKUouH7m5sAYmFkQ59rlXP/02C
	 9w3jz01HbJ3BGJOkIhR0GeEqFaSE+zCZHkR/qZv6qcLtVcjDun6X0t+xaNBvnnQolnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2134.outbound.protection.partner.outlook.cn [139.219.146.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA7C606A889;
	Thu, 12 Nov 2026 07:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCA7C606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCCAkE0bbkyL3PwVzjNyGbKMOpUPu9MLwjWI0tPbFI60kc6wFwWJWgGCvb3gdSAY0tR6WmKVBlBgGL/58X/tfHT+YCrVqjijtMaKzr/N0VGdKoPL+gkFCMUo8b2/FK494REG62+vXKpcMiGLPM/CMhQN5q/xP8NTfYU5cun8ewDUzZ3i51wPIzU54mkqWNeiiuy++OCv5VFoEgaF13+R04iUE539luaw5sGj1c6316adoDkZZB3fRAn6MKvdlQ9H8GB0h6ZXUi1lzsi3DsdwBx0PEp81i5Em3riBqtQwsaGIJmT1qFYIMNMeus/XcFZ9eTIWmj4S0NKukyx/6XFnRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlFuRtkoE4OEKSsYwrKNmpt3e9RTsd7Q1vWq5b4IQpA=;
 b=BmNImcSeJvGgigpEiIIXeay/jOxZdEZ1de9+oUgSSfrlCyfzFDJmqJCCWVNmW9G2thTVuJkB4QKXo1OCqfGJ4zcfRKnqp3qNsKODKIul4Xy0wQxtEEZc4F0lFS1K2EnzEkKvOfejISjpIT20i1Ez9yxtrV6G2L9WzYuRMi1LgZB0v/OXBmkghzxonV8Wh5xm56sWyQZ1+BTyBVaYAeApA6XWSUAPlWEf4RZD+qqijcUNtBK9bWR8u0PKAqbjqmrD5OORMH27DI1NDiwY6Xlyb2yELzSJ4Z4Ir4ARzSbSsWimpPRXyD8doCEjgdTn2fnKVXDslZOU752Ot/+ZGrcz/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 07:56:29 +0000
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 ([fe80::d777:e23a:d111:5fa1]) by
 ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn ([fe80::d777:e23a:d111:5fa1%6])
 with mapi id 15.21.0615.009; Thu, 12 Nov 2026 07:56:29 +0000
From: Minda Chen <minda.chen@starfivetech.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Minda Chen <minda.chen@starfivetech.com>
Subject: [PATCH v4 4/4] scsi: ufs: starfive: Add UFS support for StarFive JHB100 SoC
Date: Thu, 12 Nov 2026 15:56:16 +0800
Message-Id: <20261112075616.118436-5-minda.chen@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20261112075616.118436-1-minda.chen@starfivetech.com>
References: <20261112075616.118436-1-minda.chen@starfivetech.com>
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0035.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:2::21) To ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1111:EE_|ZQ0PR01MB0999:EE_
X-MS-Office365-Filtering-Correlation-Id: 210c3cfc-1b2a-4a3d-c802-08df40927597
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|52116014|366016|1800799024|921020|38350700014|261026140227099003|56012099006|10067099003|261022105027099003|261021121427099003|261021123027099003|261026121527099003|261022075727099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mq1L3W8QRAG9I2VBb7qJj6MkjnkEp6sLQGg7Uc3FrU/R4uLEboPs/RywZHfxVKPMcshf3ZGwImoO7/j0TW3tChHTMF3Iur5dpWtASlxdu+fTbcfhOWu+zRzXpuo4Awg5q8/M0xZwgjua0/fZNRgQj611hqnP1L+cwWqndQp+vPHrZ6frpWAhyDHecDbZlvIEE4icMbevUKWTN1ihDdMkaFv8kaUJHazdT/rUkeoDp9jaI+yhcDx67ru9/G3H424xUygF1O6ZdxRdb8tpuDGmbHDftkS8Vpru4JYAFgzvQirKAA0/tTY5Y4UBFpdrN0ctTAsrLN2nrKD+X29jzyW+jGAJDVjmTFk9yVDw+luhjsQAfpN/TR3qn2JW5+TfzcWQMisg7ZLvLbEKWkl7OWrhHKw5pLH2HF2TitGJAOFW1h4cengBNQXOK+zjlp4jfAFEUoV3Zo2TnvW2hTEWNamQvAo/nsC6AnZ8SAlCsISXbGwndyu3Gj+sDCwbpl4lVvuFwVLRlrGf4ngq+w5ajt1bpAZ2E85Jt1QznQLhz/tH3Ta3cANfRoDJLEcJrBT1m2vPlteXryTX+CaLcCJwfWVyjA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(52116014)(366016)(1800799024)(921020)(38350700014)(261026140227099003)(56012099006)(10067099003)(261022105027099003)(261021121427099003)(261021123027099003)(261026121527099003)(261022075727099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uhT1uYBFxqLl7anZWS+ZcuoLCvgQNEKx62B38F0LtATNpJbqhDdHy9l3azzZ?=
 =?us-ascii?Q?7opeLWTT1wrHX+tsV/lPtkRnk6L42BLq/Dxr2rsuws0AfVl1tIrYU9KwR78Y?=
 =?us-ascii?Q?0j731DP+hieWHW/DAyNjAJgd/MSLa2RQ0eCTdggXvSiwAx/CpyE3tkFXVo3E?=
 =?us-ascii?Q?wHj+Xvn99sFebDcMt05f3d+2GTH5gJCM/26Kzb237TGY3bSC/Bp3ATEZR/kf?=
 =?us-ascii?Q?K0VxwHT12652ZhZEFHIQxpifz0VdGSOclWELpcXVCfJGXA2MgqS7SnHx5Gh9?=
 =?us-ascii?Q?8+21Ds2VBcj895T1IBD+Iddq02CZmB4FZLIrkjdSXf2tgRZvvW0uNFugMzTV?=
 =?us-ascii?Q?Wdj0+0WMC/LWjNQtMnuxavwqMIwPMMBUL2uyp1xrFb276O/4WBkgqCXwrwJf?=
 =?us-ascii?Q?FEv4C3VkC3QWn/L4K8+sf8DO64RFn9PR4VVII/hMZWfLfBeateKte237nMb1?=
 =?us-ascii?Q?FQ129neaC1xf0lPaPKYgGs+gEPTvMIzPvHcI9goBJN0O1Gy8K5BPLpPjNMLw?=
 =?us-ascii?Q?aHtCZHkzUYbtFhw0cbyyZQJEf398ygmVx/b2nyXEkIPRdYljqtLuwrtYFvT/?=
 =?us-ascii?Q?/ZwKNa1eekhANu7BnwyksWpTEWTXiufXZbVbk9tTwcN3KxKclYB/BeZftkPm?=
 =?us-ascii?Q?WhPYHTJRhTF9l74CJimcqArUxoHOZ9wlewB7x9gl+3JPX+fy2vTC0E8XKdmD?=
 =?us-ascii?Q?40SE4QImQdpgg+7wKVwUBG9fkgLQ3RV7C0Zr1pw2xSQmSa7xzEt5eUzpClWU?=
 =?us-ascii?Q?1P+t6Sm3PWmX6GwOiTqj1UQdFZWN45j2sSiLEidNwH9b5x27mIkcPUCWLRIV?=
 =?us-ascii?Q?sAIXvLpVGm9Pdd0GUfrz65lkHZqc/p5wm8LJuF+x9m5+VonsWhkhdCIw1vxA?=
 =?us-ascii?Q?abvP044KOlLSAhV7DY0g7e7vvugq2NTgYl1F6UT9Lsxks1r3MrMT2wqBLMuH?=
 =?us-ascii?Q?d8MxqvmpJpLn/Vm25a8Nap2nmqCPNP14gETkPLY9R2cQl44OB5atRn7tylFT?=
 =?us-ascii?Q?e8Ys00eTDkk5DXDVStSgG+AAv9453nTj5/NRjEPE/Yg8DSkMpDIxAKASZyr4?=
 =?us-ascii?Q?/RK6nBc7rhtIMMLmYEEngNddfV/swhHQ1FQw1Ca1Lm6by54dNukU5BgHvJkU?=
 =?us-ascii?Q?6Jfprct/9Or1Hv3Dssey8E4E+XMe//WNFnzq97QX/MgLBP2QYzBqFcpVvj7B?=
 =?us-ascii?Q?nwAO6+Ep1eRVW96PeVsAdIw2YmC2QrRDbPixRIIBkleFXugQDXy3j7dRuLZK?=
 =?us-ascii?Q?iGtj8h+r7uc1L1qvTAOPA9qahgM/Y05TCafywSQShHhXxqbve1R1FQnjL7Ye?=
 =?us-ascii?Q?423xC+bhcFj45rGYr88xRoza791WCtUA+8QD9Br8eCZURt3+bCC31vy5tFe/?=
 =?us-ascii?Q?6sNVVlO0HfMrD72pw342notYfrldnow7lOL97MbdF6YnVWC89hrI+Ej24bfx?=
 =?us-ascii?Q?X/p4w4ZwFk1U+Nqbs51jsYN38g3TJgedk9lGiGsGK1Z1G1hrYBNUproSwu0X?=
 =?us-ascii?Q?Rt7+699msJfJKqYDvw5CNa3ewxDgx/Sb9tOwB+zTFmJuOxXgcGqC90sTOxWF?=
 =?us-ascii?Q?tIKobzERMWzQkEMxkUKvLfUGZ8GS/kaa2bCpIil1jKBQvR2f/sUMCpIB1AqX?=
 =?us-ascii?Q?n6P+kRydrfHsQynrKKWgmUBVEg2rZiC/MmEhMcWzL49tqJWXVAq3r6An20bb?=
 =?us-ascii?Q?qQAraw/M7cX4vApK/Liw1eolwftmoQQ6uaO1yV95XVplQwBMEAbyUHjE4QVm?=
 =?us-ascii?Q?+DlcTegn6IClG06BW7ENNAUuO1shSOQ=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 210c3cfc-1b2a-4a3d-c802-08df40927597
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:56:29.3250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zSl5jPTfutIea0Z8gP69hl1Hb/4EebvBBW+2WtHElpk7hOOJ+kUVf0mNXQdZ/SAPDAyeRcoRuNZIWrrddClid8VClG9+XDIuXmAbXPwCfcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

Add support for the UFS host controller on JHB100 SoC, built on
the Synopsys DWC UFS controller and using UFSHCD platform
driver.

This controller requires specific configurations like
M-PHY/RMMI/UniPro.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 MAINTAINERS                     |   1 +
 drivers/ufs/host/Kconfig        |  13 ++
 drivers/ufs/host/Makefile       |   1 +
 drivers/ufs/host/ufs-starfive.c | 283 ++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufshcd-dwc.h   |  18 ++
 5 files changed, 316 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-starfive.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 05e771a9a5ab..d362c2ba6e77 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28805,6 +28805,7 @@ UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
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
index 000000000000..de7a882d29f2
--- /dev/null
+++ b/drivers/ufs/host/ufs-starfive.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Starfive UFS host platform driver
+ *
+ * Copyright (C) 2026 Starfive, Inc.
+ *
+ * Authors: Minda Chen <minda.chen@starfivetech.com>
+ */
+
+#include <linux/delay.h>
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
+	bool	phy_rst;
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
+	const struct ufs_dwc_phy_pair_data phy_data[] = {
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
+	const struct ufs_dwc_phy_pair_data *data;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(phy_data); i++) {
+		data = &phy_data[i];
+		ret = ufshcd_dwc_phy_reg_write(hba, data->addr, data->value);
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
+	const struct ufshcd_dme_attr_val rmmi_config[] = {
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
+	if (!host->phy_rst) {
+		ret = reset_control_deassert(host->phy_reset);
+		if (ret) {
+			dev_err(hba->dev, "Failed to reset phy\n");
+			return ret;
+		}
+		host->phy_rst = true;
+	}
+
+	ret = regmap_read_poll_timeout(host->syscon,
+				       SRAM_STATUS, val,
+				       (val & SRAM_INIT_DONE),
+				       MPHY_POLL_INTERVAL_US,
+				       MPHY_POLL_TIMEOUT_US);
+	if (ret) {
+		dev_err(hba->dev, "wait sram init done timeout\n");
+		goto err_phy_init;
+	}
+
+	regmap_update_bits(host->syscon, SRAM_STATUS,
+			   SRAM_EXT_LD_DONE, SRAM_EXT_LD_DONE);
+
+	ret = ufs_starfive_phy_config(hba, host);
+	if (ret) {
+		dev_err(hba->dev, "configure phy failed\n");
+		goto err_phy_init;
+	}
+
+	return 0;
+
+err_phy_init:
+	reset_control_assert(host->phy_reset);
+	host->phy_rst = false;
+	return ret;
+}
+
+static int ufs_starfive_init(struct ufs_hba *hba)
+{
+	struct ufs_starfive_host *host;
+	struct device *dev = hba->dev;
+	int ret;
+
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
+	if (host->phy_rst)
+		reset_control_assert(host->phy_reset);
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
+static const struct dev_pm_ops ufs_starfive_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare    = ufshcd_suspend_prepare,
+	.complete   = ufshcd_resume_complete,
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
+	.remove		= ufshcd_pltfrm_remove,
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
index 076076903730..708206814900 100644
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

