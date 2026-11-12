Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794470210;
	b=tmX0amrZXZG9oA0TfR4Isu8JWhvVzZEoV0sLVvaTO+/P58sj4FblH3/P+w+19QzfODD2
	 qTmXeloFIenxKTFcGFvuJ7ttMY2HsAj0NuiG1YuZCZV9qM+Z60aClwhEh8VDCTrAK3f8d
	 IldGKqPT1eu9SrqE+uLATBPm4AADmZiAavwy2w5LswJZhJTaXG1f4/arqhi8/YTMrxYvX
	 Ba3FCXtuqGAiBOULCkR+OTEti/Wma1lSo8x7XczQAPEX3fZwLGTT/iVitbj6jRJf/cPUc
	 MsYOXWTQUDOlrZu4jZZyAadYSqZt5yDbI5ZjTiDS5TeLwT7sNo5yCQ7M7pI1wyULbzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794470210;
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
	bh=mpneNcSaP6RV3ovDy+MYo2q62YxnCbG2DMJ5CLFlav8=;
	b=L/BczUgUHTbqNRlGfWbFdm+Sy/5p3VufTyvPHZS5iqMMtC3nPIxI5M141MoH0aakncF2
	 sAMghij8kJDYslh+3AaCKnSdkav6X4UArbOdeJimWga5S/KkijjKE9PG/b0KCSsxmLHxZ
	 mvAVJWpX5cRpMTPWojWFo4rRdtSk28GexWIOza4+QJFYtUnbnd5aIe1AU9itD/RD8twED
	 a2u6hSZ8SP/V2W/KC4cthzvXh1rqjSuc6/dZ1XFdYAUYlKRmr6Vwoisi8CwjTxlgtaBAA
	 UFdLMrrjtf1RJH372c/m8NiQyH1VZPv+g3YFCEiQbI+7OYY5yHkFg1GyrDo/eK+iebw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.146.134
Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2134.outbound.protection.partner.outlook.cn [139.219.146.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E2C606A8A4;
	Thu, 12 Nov 2026 07:56:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0E2C606A8A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHcavxxlO7eFLibXAhxpvh7Gd2Ks2DVg2lBBfaabKUYq2LOblq7sZPBKGWPN00pqA3qraXlXILC0UyOEthQyAGSaVOep7oTiXOYY/FnLA4ElWGTc+p6P3l2uOm/WMrbO+36i3y9q6MIv6e8b/yy2dCmZI8pbQSxVOSKFOl2FrSIfRY2rc9TBHyWXZsRLPQKXXiaDZiBpVSYQjnn/miNIkfweezhwIswwXCoAHclqSZ4U/yQ9kx+1BkDwrlgy9sdt09dAknc3tZ4x756m1ukgINhWs7DLYDjMSi8+kIPtK7ZWaLYY46ZYuvRiYk3zXAxZC2lBc9yMXSfTIXFYviLNIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpneNcSaP6RV3ovDy+MYo2q62YxnCbG2DMJ5CLFlav8=;
 b=BYJC115QtiCbrVDciLKVVaYDv+6gXpyhb4iowKd05YKsqSiNi/hQKMIgcD5r9Koe7T3EL4ls2V7rPQejeuIfm/k6KcskR6U33WpQnRwrA6txM+wXcKGKgKTJdVH/gh2XcACLQ0tTVHSpHK0iFjV0Tv5KIfn5F0fu8hdrTG+YRPRe2g5lVp/he1th774TuhoV1aFKCuY3JHxhVAGTOHA1SIbs0PTkRNNPLbqaJQEJTdaGf+SG0Fz3+cnb9TRwfUa60vpzDema0PKIpPCipsryYL32Hv94C4kA0it1yYF3LY0AVyT46gBw3bcrvL6TbXMFbrJT7nBJd4HXUtoccc0CMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::7) by ZQ0PR01MB0999.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 07:56:25 +0000
Received: from ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
 ([fe80::d777:e23a:d111:5fa1]) by
 ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn ([fe80::d777:e23a:d111:5fa1%6])
 with mapi id 15.21.0615.009; Thu, 12 Nov 2026 07:56:25 +0000
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
Subject: [PATCH v4 1/4] scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100 SoC
Date: Thu, 12 Nov 2026 15:56:13 +0800
Message-Id: <20261112075616.118436-2-minda.chen@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: f4c0d4f1-12b4-44cf-6163-08df4092735d
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|52116014|366016|1800799024|921020|38350700014|261026140227099003|56012099006|10067099003|261022105027099003|261021121427099003|261026121527099003|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	DSaSPhSg1/oR1PrmCfh48Q/Zcifoh35W/gxvrEo1pkm6UqX+qWTrcrUsV965d3XKA0RPicC++DRyq0gEj7wT7c41SaLrBLB+oOBomLgBwAes7RvqYCq76VcPKldXRWwBjev5ndhFbxGMilXlvYWY5Duj3qROWt8Z91XAUYmolK+eB6z9RNCsJg/8YHMdlrayN/o61XTeVkUVNMxEKIdCw9zETyDcCFJc2VkmVQq9dwyKhpYUgCRR/YFttpZNZf50ZtVpyiMfChRevQCRFEF/mPs1GP08geTOUgV+XAAJsHi+EGd2hfUthPc4rLLvd24HfegeSEV/cNgwfKsKWpxlKrBZInr0EUtGJQh1PBgn/njzrJTQ1yk5Grb0P/r4eOvL0BodfhBnnO9tDqti6mHIv0owMxPAJTk9n8iZR9gv2PgqFsV+bSxw+JEwB6RjTkX8nuaXFu+QchH3ZKRuolfyKDeCT+7u8tm2IIeT9crAF2eLkl8o3L9hLEnB2h0YE8sd8T6dQXH20HFWcq8VCHE8YRbETRb7SBMeQjR63TbrkMkcNMHIytWqFYAcnSTlB41sc/GbDBs6cou1AqIVitC54Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(52116014)(366016)(1800799024)(921020)(38350700014)(261026140227099003)(56012099006)(10067099003)(261022105027099003)(261021121427099003)(261026121527099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YND4cp3FGCrkPb66FmnwGYH7arHJxMWg1vU7PWCmpuC49EjUgyjG0PWK4DP3?=
 =?us-ascii?Q?G6goW1zAa8YzinlOhxWLHaPtQ5f2rTyHxKlWbP3KslKL/mixTH3fJp7hXXGm?=
 =?us-ascii?Q?pkpDC2UZIQL1ty5V0lHeO4A5ouetJBIgkZfVRB+C/kdTPetZXH4y5SE/i/hW?=
 =?us-ascii?Q?3PyCBwsRJFjKfD/6W03AwP10qRylPtsmyTgOnVajicDjboOLdLV/H/BFNcQJ?=
 =?us-ascii?Q?jQzpEOztVFrjNJtx4gDyW42/9nBYIyuapCjobj5QB/xa3c60FA6nRBnN+jvk?=
 =?us-ascii?Q?7abfi5UkGbZa8jZQDfZfLXrdyYJgYXyGk3aUVdnbt3UG9QwQUggGk0xqQTD0?=
 =?us-ascii?Q?QksnFO9OmrdY4wgQLbQZL74kel6Cth5oXa9oaah7va27hzi3Br4LmfSQdyGt?=
 =?us-ascii?Q?XHoAqmevboyJ8SRK6fEG9rEfelhJw9UNrjPpjyUmiKmSOBJij0mvCe1XGGD9?=
 =?us-ascii?Q?pBeOLyV7yYSgVMa9Y+ioyb5ditmHkmDU5nbyBlfoCw4rnB0LfIhIZIbV+cbc?=
 =?us-ascii?Q?P1Hp61GPYnFRAQyL5FsCbP3z2CLaEvU0z/wWM08hquZezmxl4+/czYwkhyTX?=
 =?us-ascii?Q?PfCd7dUY/mZJjZvtOppakdDFwlda6ep6jjBkxmRCzscj85AOdPpRYxkI0mYq?=
 =?us-ascii?Q?2Ova/YNzShy31HnOILB+kaWyBSDWICeDnXudCdA/0liAwpHBzEKtzssGepLP?=
 =?us-ascii?Q?DheMV+kPDLyIIxtt56flpOFAUMS1mipSNLA1GBonap82AC59deOAfSFSA++o?=
 =?us-ascii?Q?UKzjkqrBL3zwdNqABHNlkWuHCfZQUyjwIXcDaNPaFlS0vCGt622GRmdjb9h9?=
 =?us-ascii?Q?osdnA87uRNPGu+Zn7HgNE9JTqvpDXLHglrp8Io0Of4UOk0duby5Os0fqPOU3?=
 =?us-ascii?Q?dVYPY9k1T//Tg/ZoIx+VrNXn+2qJJ8H6CzULEr3WdGK7aLaXOpln5f9t7Buq?=
 =?us-ascii?Q?zdMCSRpOebGOn5Q7aiDkdShZdADHOsIyqviDWbIE4csrrJvDJRkcmmVuDIfw?=
 =?us-ascii?Q?94RlBxsXJBSe379A55abRZEqBOiMat1qiwt2LN+X6l/F+24YPV2JYTZB91+W?=
 =?us-ascii?Q?4icQ6LkRWrTUHadVD7YeNCxP165axQeKGicLAiJrHwggYRJuM1LPUrIVFlcr?=
 =?us-ascii?Q?vkLFRfXLW5raovMabiFwY84c5+76Ji2QZqX30uEuuNoFeh4z7FmRbmemAgIn?=
 =?us-ascii?Q?P9Yaj4ochg2JJ42qZZcRm8qaZs8p3A/5ykt4yHoYQGoKfK1lriT0epA8DfK8?=
 =?us-ascii?Q?+qc3J5E02uifCC7odHJ1Lp1HoW4GF18hkyAlc9sg5G0tABpNO2kY+1is+65/?=
 =?us-ascii?Q?ZNuJl+hcixLiMrjZ5ku+lQZmpmgpSVNrwoEvHoB2YRaalh7+JEXgnL6P8/CJ?=
 =?us-ascii?Q?N/AWhaAZrClv+ROjAtuWY7w24iM709oW+wPyfXw0tRQKXuOL7beyeGpeW7JZ?=
 =?us-ascii?Q?E4CGD8V7zWrkz4aCvikIkLgLLSD8RGvxuL898WULr4+ovrqJtbqtJnFgocHU?=
 =?us-ascii?Q?OTGwAD7uETx1k4UdWr39k8M8TzRIfnUGlXe1wAuctM4QYCsbhZ3nBCLlI+gg?=
 =?us-ascii?Q?ObDVjRKWk8nj1t7D0/xhzXhSmMgxmNkdPB1VKQeHLi0mukwy0D/Llktomo/c?=
 =?us-ascii?Q?w1RCesx19RalmNpG/y8hBvjph9lhZG8I+ZaQtnyNoMU1u0lxqYaVyJ8kIr3v?=
 =?us-ascii?Q?Zu9HCJV9uaD+ogGJA/XY088iXdwu8c6H23lwLNHvu0Ks6EqCJs9jLaPQn0Wd?=
 =?us-ascii?Q?V2UiTdyQagHipNiqPxzo+TLfcRVAAXY=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c0d4f1-12b4-44cf-6163-08df4092735d
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1111.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 07:56:25.5744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWQLKnz5ny1i3Xb5BAPow/HxAEJpODINZLNkEdmt0xYYdjutFeXqrlOhEeEVmaXDwHA8p2XeZ0vC8hQP3nCjTdBknqWffP16dRC3DYNOFVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB0999

Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
The UFS controller is based on the Synopsys DesignWare UFS controller.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 .../bindings/ufs/starfive,jhb100-ufs.yaml     | 81 +++++++++++++++++++
 MAINTAINERS                                   |  5 ++
 2 files changed, 86 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
new file mode 100644
index 000000000000..7c0ab9bb61af
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
@@ -0,0 +1,81 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/starfive,jhb100-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: StarFive Universal Flash Storage (UFS) Controller
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
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: main
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
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      The phandle to the StarFive JHB100 SoC Peripheral-1 syscon
+      register block.
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - interrupts
+  - starfive,syscon
+  - operating-points-v2
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ufs@11b10000 {
+        compatible = "starfive,jhb100-ufs";
+        reg = <0x11b10000 0x20000>;
+        interrupts = <105>;
+        clocks = <&syscrg 4>;
+        clock-names = "main";
+        resets = <&syscrg 10>,
+                 <&syscrg 7>;
+        reset-names = "main", "phy";
+        starfive,syscon = <&syscon>;
+        operating-points-v2 = <&ufs_opp_table>;
+
+        ufs_opp_table: opp-table {
+            compatible = "operating-points-v2";
+            opp-100000000 {
+                opp-hz = /bits/ 64 <100000000>;
+            };
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..05e771a9a5ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28801,6 +28801,11 @@ L:	linux-scsi@vger.kernel.org
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

