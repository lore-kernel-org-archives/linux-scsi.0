Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2125.outbound.protection.partner.outlook.cn [139.219.146.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDF7244694;
	Sat,  9 May 2026 06:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778308105; cv=fail; b=L97oXjEqMOvct3XvNzQtuNf3fYnnDiU2pgAsmB+MJucktSWjwZMYlg4sKIfTuIiwnq2ZQvNkpgMgRgWjAjSK94pP4Dc+4NRNnEto3hSzzCmaZ28dxjTUIyxnoC+vWttP49kCMStk+uUM9cI1VxPnvmLEcZ7EaZSnae2cTxp38Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778308105; c=relaxed/simple;
	bh=KH2WwBgT5M1OMIHWGDCjd7bS8icV/0/8jVb7eSxe09A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rJcZITk0tiMqdYkPk7mnKY1o/41EbGHSITbEYcqfnECdfIiu3xwXS8rP0ABoeWUsnXlZTsweq215eguHeHY/ZXk/6RDcE84Npa0WiJHmkYGPx2jRyrY1Atf/oTZuZRmW2kqIeYCMM42dEvLMDoctaayGuOSqAZmyt1yr7etjvBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDv9U78AB6H/ZcUurAoiR0ZqXmbWmFKE+m/cQN/f+AoxdhLMPq6oqM3voyewXsgocTUZOALyeK7BcP0MwCu1aeYLZugy+fBuoad7iJ4mUbYZQj6txwNnKpmosCQgATtz71Th1ZrsklmVIn/l6WDFDEjUbyv039Y2SSDtSZ7KYEPIHM9V7P3EnkNa3wJBxseimgXTzY+/FBDl1Ox5YJcLQk9FoKZ3KL+OFhxLkG1rJe3xOckGNPf6P2ds5HOH+fimRHFvz4jKNBLjvEUdiR9DP//EJdgha3inBLB4A5BzsWwISD0VeFU3/Zxs9Yf2GjcYieF3T9oIiisZ82Spm96eQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOYYnvqivLTJBFFJ0ZUxl0csnxVkAajLtI27wO0fQyU=;
 b=AIopRFroEP4Ujz+dlnYkezmiCVEyoxjU64cMDIHwwjMu5wnTFAkhztgPKJzJMog5ccRdtH4Shu3vyLXs6a1tRx1pEfPvggURYChrn7EH8pkE4BZb6h230nzjPi8TG/YKU1wZp+wp776GN+AErZAWXUsbZKNZ+/b91rGir2tBcEUf5oY+JdrsqK8Sl1PHVjiqlgIa+nL/8rawjR1jmuhBgHdqS/syzzAJ4k5hV6tuOaxIW0TBBJFKZ3pMtmByF6wCCTm1XNqabbuPUIkTXAKzXrqNXmn703Nb4aexL60aXIXHBrwcNM/ymz0G+ky3C2mx9BCmSrbGhauFN7P5Xdyx9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0632.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:16::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Sat, 9 May
 2026 06:28:08 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9846.025; Sat, 9 May 2026 06:28:08 +0000
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
Subject: [PATCH v2 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100 soc
Date: Sat,  9 May 2026 14:27:57 +0800
Message-Id: <20260509062759.125472-2-minda.chen@starfivetech.com>
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
X-MS-TrafficTypeDiagnostic: BJXPR01MB0855:EE_|BJXPR01MB0632:EE_
X-MS-Office365-Filtering-Correlation-Id: 71c031cb-6573-4162-77b1-08dead9422f9
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|52116014|1800799024|56012099003|22082099003|18002099003|38350700014|921020|3023799003;
X-Microsoft-Antispam-Message-Info:
	vp2nd+dDFGRkv/XzhWr1js6YmcEz1kneFIZafFKrhIR4zxVpYGp3LGW+3J3qZH6SdWzOHIso2ZMaT0MGvufQMDkDZCdA+5LPs+tPYIKrsZC+zkc1Pt0tQG+7TrIKNVVS4BgcocNlwVt6N+XR1l7h8BkVXxnZD5aVe29GeqJ3wfej5DqLGSHzuglUZXw3ViPFqz2XIGj+Yrg5Jg//FLBYqEF8wSkcol5qdav8kUyhM7MKQ0Q7INCrxGUlkYxZTFsTHfhhPVZ66KGZhEdh+JxqnUV5Zx77DquAoirPQHAorMj3xx+vdhGD6b79DKdBKTaDWkmiSDwGaIHhNK6AVhVJXPDSbqTeNfQ2di2j9YroWarmZSR8XN2+YepS+rcnX1nWSjPjfDxxKCzlR2Hvk0eoRMqGPl3Aw77tnIxmGhnL67sTuHk2kufsihKE10jMApSu2pc1WnfmFS6nTWA1jRIHtqyUeBOlyg2ufxXU12l3nOpZno8lDdiyuls1bE1jVxHFEFPwxOCBFR5QzfOFsErPOCHeCxhaENeK/uAEv1l/q9k6O1ibdcvHTrJRXYNFy9bR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(52116014)(1800799024)(56012099003)(22082099003)(18002099003)(38350700014)(921020)(3023799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1fnFvezctDCScNaNMv8RNonBkZ+IHLVNt4tJ7HNulpOfTNMwJ9eJrKO9NZIH?=
 =?us-ascii?Q?u+hjgMsPft910dxmz4JONu6cpsruMPSVMtR12VnkrUFLrM2Mp8L3FOsXwilk?=
 =?us-ascii?Q?7DCnq9jh6/oBEzkYq6OdclRnK/7Kghyxx1Mn34Gp1k8L6d+RokccTYRqDVwv?=
 =?us-ascii?Q?q+iIX3n+E2Od6UGzD9HzphkCDy7T32vPdR8EDapaJFK0/yYzuyXtGlintsF4?=
 =?us-ascii?Q?eWBOOfDqR6N+qwOUH27SaT9RuGUFH5yHSYDlXtpMDBvmNVfSx9vj1kR9+2q2?=
 =?us-ascii?Q?hjZxMkN/PZLue874YHdLLiP0o3/dVlEJd9FpPCbD3nMal2IcMjZeLooDEjwR?=
 =?us-ascii?Q?fJ+iRaptak8vAY8ru7lkpaKyLevEF9WUEJTl4oyKOni/rPnti0+sn283NvHF?=
 =?us-ascii?Q?wcdfG3k6YSF8Exni8Gt83yCbZ0AB6jiHTiMEhu8xMsHWZ84x1FOUbBpPDrbZ?=
 =?us-ascii?Q?5p882fV5Q/PICRroN1IFOVlnYWYwOlVcCb+1kPeHH35odi9krAEWoJKaBsYh?=
 =?us-ascii?Q?O6F1cYtWnBQvgX+C7I/DJSE64xVSpLG1Ycdg+uS/oE4QQO6UBL8VHhKHOLop?=
 =?us-ascii?Q?poVDuTXgIPQoVSYGaWWbaxmB8mzdL3bBTeRJUnoeZENV6HF+5k7b6LgxiiFv?=
 =?us-ascii?Q?PAk9+ePif8bpm2MVexUhV+m2OtR9GD65CKZJZnzHxX/KAkcsoH1SDohYjm53?=
 =?us-ascii?Q?kc5wgkhXip3Hp11rNyH+UDCeJWUQs4JzMLlgX8R6/VOrj36VZCJQDrPXNkph?=
 =?us-ascii?Q?YUE6v3yUfiu0gs9H/PUac0CVVN8O77xh2KEd+r4OzWZuL6B4ZCxAyAn18XLJ?=
 =?us-ascii?Q?9i9fJwTEwCJ8c1TZQXzQAjtLDD60vGD7U3kYU4osgNeyxn0MYpv/FhN3uLpY?=
 =?us-ascii?Q?lCThLwGX2WX/Ln+W81OBj6Ek5Z75D7EZTWsDVr8KIhqP4d19I6xL9r/SFHPn?=
 =?us-ascii?Q?5QlVSNb47/wdyiQr+Lt5wumQYOyXdek7GaCwxEui/vGH3xTm65mx5S3Vnzu4?=
 =?us-ascii?Q?g04v4c09T7GGP1uv3w8hX/5gJ8me65Ru3+ZIga62huizEVFA6p8c9GRT2kb4?=
 =?us-ascii?Q?yFHL3AqZoKik38J2HDp2i521ZAOBQLrwGMnfdp+4QvVwrM3cN42ilEE6ryIM?=
 =?us-ascii?Q?63HzZmargwvpQWu4nxyBfo5UsPZjaVCzqK5A0DSIsWgqx1g50DXvgoFHcPK6?=
 =?us-ascii?Q?FuXaD+lVQMSVXR/+rL74Q/zgtpW6irTVcQJi87hYTsJbUec+sNZx72N6xRw5?=
 =?us-ascii?Q?irnDgGmT0XuSnrm8XP49ObCk/k4k8VQeZxVeeaIQRW2y+2WOlrI/sj1tkrrU?=
 =?us-ascii?Q?zHBDqhin5YjL+xfMntS1QwJrqt8xjoiFrxuAGlRMbol0Jeqi8UDYW7hMiBm+?=
 =?us-ascii?Q?wuL7v78eKFpB2/hVzhykBFeqqfK3UfHvcAcgPxCz6t3FmNNXJmRxXI7t5nRv?=
 =?us-ascii?Q?GKstzzldNC6qQhixr8WWXx9DoTNa0W965vaUkp1pKRRyIvvlN8JXi+m8X4WC?=
 =?us-ascii?Q?icAltfUjSyHF+q0TPFEWdqNKNVwGUOhlLOCwjZcqz86m7IdsvYwa1Mtf6FkO?=
 =?us-ascii?Q?uEsGDnXZPeIRMgMVKnxQ82Zke2umgttPwtPKNaPikIdugEIlfu58TfJl19pc?=
 =?us-ascii?Q?KMghuDMGkaZoBVVIT2klsqs0RWw7pmZrP3D2/27WKJxuHlLv+r6LtvK2sh03?=
 =?us-ascii?Q?WEVDuJIblL5ZicEIxhvF8sVwWBJ2O44kbPeNh8jlHiVsTgXqbDIyo7jKPbA4?=
 =?us-ascii?Q?03L/EJhE35ASoWjr8r/qB2uSPdOJqBY=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c031cb-6573-4162-77b1-08dead9422f9
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2026 06:28:08.7878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3G8N5hbBrn5rxiP1suaRSRZ7KH3ZLiOFKcDC3jRdzjpBNW+9qBABeEV4cAYfBpOFf2+ZiEp5NGd5MjiIjecaSKLW0HnM/gm7hcpXEu1KbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0632

Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
The UFS controller is based on the Synopsys DesignWare UFS controller.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 .../bindings/ufs/starfive,jhb100-ufs.yaml     | 76 +++++++++++++++++++
 MAINTAINERS                                   |  5 ++
 2 files changed, 81 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
new file mode 100644
index 000000000000..4773f1c2670f
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/starfive,jhb100-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Starfive Universal Flash Storage (UFS) Controller
+
+maintainers:
+  - Minda Chen <minda.chen@starfivetech.com>
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    const: starfive,jhb100-ufs
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: UFS reference clock
+      - description: UFS main enable clock
+
+  clock-names:
+    items:
+      - const: ref_clk
+      - const: ufs
+
+  resets:
+    items:
+      - description: UFS main reset
+      - description: UFS PHY reset
+
+  reset-names:
+    items:
+      - const: main
+      - const: phy
+
+  interrupts:
+    maxItems: 1
+
+  starfive,syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description:
+      The phandle to System Register Controller syscon node.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - resets
+  - reset-names
+  - interrupts
+  - starfive,syscon
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufs@11b10000 {
+        compatible = "starfive,jhb100-ufs";
+        reg = <0x11b10000 0x20000>;
+        interrupts = <105>;
+        clocks = <&syscrg 4>,
+                 <&syscrg 5>;
+        clock-names = "ref_clk", "ufs";
+        freq-table-hz = <26000000 26000000>,
+                        <100000000 100000000>;
+        resets = <&syscrg 10>,
+                 <&syscrg 7>;
+        reset-names = "main", "phy";
+        starfive,syscon = <&syscon>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index b9a7c6ef4788..5d222150e015 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27478,6 +27478,11 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
+M:	Minda Chen <minda.chen@starfivetech.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.17.1

