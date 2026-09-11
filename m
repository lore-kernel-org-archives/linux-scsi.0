Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2132.outbound.protection.partner.outlook.cn [139.219.17.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09C14334C9;
	Fri, 11 Sep 2026 10:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122271; cv=fail; b=pODFmfusbCtRb/VlOcf9IbM57q7XcXq0QOjQlMwt+5ZGrP/5PFidtfcyzVzjP8vqL5BBeDaURdoTK5LlzJCPdF17ZNkWUqdXy4ehySyo4puoutoEBz15Or66T+MHyU1U74UqzfCYid7E9XWP0bVoeJsbhSZKUVo702rnjUpFX3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122271; c=relaxed/simple;
	bh=yt+1nhelVuAVzHS2JHV4ZCl/uJc32y61yUlPnQ6oAc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eao/PBZXkOh12b4MrO3psE6AxxkX2vIgGKwetdBW/h86qwnVqSmGgfYBYsA549EpvnAJ8UDkDXPQggF/zgY0W22z4LFPL9JcGydIzHVJHTnlAVZXg0FGk9Ktlf/vAFUk/2bhloDhK5FGKoP/ClshOAYmph2/BsK9RKiAqCgBxOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwEKyRUXCpc+N48+8JEXThxGvzBMtdXDY2Uft/UurWdmQccj/iTkLdUyLIvMNgVIaixNAHL6Az2cTAhW85uAkhJ/JnTar8ZYI5wa3GtU4vQhlwCkp/B6BLiD9Rr5kRtU7DWOCUpJZgLqyoIZa8YxhIOJc6B7bexqQ6zhfyQnCFcyRcR69XLeET1B8ErVYmM+FqcmfLhY5mWyAawuRXQQUqIxC0bdaYjH00l08eaIT+/WUABNoTtdSy4UiNT7kHLy1KdyEb2pF0rzvRT1WKt1gViyy6IYubiomgX/4LC9BC6ktfI3Ii5GD09VuJDqR7ik2fK6LG7yxc2KuKfy0fyP0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QrYqNz7vYwFjKRNPlRAWfsUJTdhpmpB/T9S6p39ROg=;
 b=Wdg3e6JeTIEsRfWo9FLjp8z+F5n24V9ncPGh6nrL0Y8hOioJEZofQUy8DbH+0e/tslToKTBv68QUPVT29yBSUOwLdB5uMifPGTg41BC4Yorn815GbSC6HnjkruuD49Axo4FTfxk1IBqRb/86WmI0cZ9y3/U5uRreDcEMVAPXHVYYZh69qn+2Kdpdxs1aeO0nVDMBccKa84OWzH+U+kXCVi4e1yJwVxNcA2LCelc5uJL2WB1tbOMFK0vS40wifr9ddH+lTt5KMQEjMTwxAv3lMnUlCGU96bLW6jwiflTb3E45KmIRjI/Nzy/bi+l3txL01A1gcwNdMEVfkIASN6UkAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:25::15) by SHXPR01MB0573.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.18; Fri, 11 Sep
 2026 10:24:12 +0000
Received: from SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
 ([fe80::9b99:12dc:a115:b90f]) by
 SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn ([fe80::9b99:12dc:a115:b90f%4])
 with mapi id 15.21.0339.017; Fri, 11 Sep 2026 10:24:12 +0000
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
Subject: [PATCH v3 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100 soc
Date: Fri, 11 Sep 2026 18:23:57 +0800
Message-Id: <20260911102359.83288-2-minda.chen@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7bfc42fc-ab8d-4285-2630-08df0feed2c0
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|366016|23010399003|1800799024|38350700014|921020|3023799007|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dBWx5PUx/6V5zMzrcl+/IV9A64q3xNYOX5/BmIiSQUpJux4gGeiirQnslmhus8z2QYbgdsTdJS9AtUaXMmA4NeXIXkdKe+oZRYCrwaAs79Ohkkbs+6LNvvDDnaamVC//Ch3BS7jUYnPRec6oiCtzyNcy/32pQqaXkbg3PsdB7TG2FsH9g8oqOYbJWq7V+tLSNZrdAjJJzLfIyTDJKKpAhlisL5xVbw7pg6aoN6gxunrfHSZshE8EQDbUFwyTOCY/iJQHTafn6In3zPtgJ90XwOMlVm2gZNgBxmRfn96BsNZtUQisNngID7FImtIbhpOrYSI3pDzYNb89W6M1LYFfT4eBGCAcJcskMQMuhGbBoW1L+lhz5L/flxNngPM0i0YEA6gCNRIXyDRjU7C/0s8qtEI+EctEy71pplegTjQmH0meTy799qXeTs1NmOKZLEc8A64ekLlMIG5+lwlkXRbjyeba2NFDET78FgJMOWdcv0ODlCbClznFA0erkvFI2AuYWDq3APFFmTg6FJrZeDszp+QDCxpDtGBf6yf5EKoxOy6vwDWsmLiQZCDjwKzRVSglkG3yaeDm2kq7qOyQ/Rp5WA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(366016)(23010399003)(1800799024)(38350700014)(921020)(3023799007)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h5pYUZVLzdlC+1SMgB+7/JiX8xTZnRlnfjWP9UI6eirZJonvKb3vJQcoSNb8?=
 =?us-ascii?Q?n4X0SLYZUB+EE9YxTS8a5obIFYOuPzVZgp9j8wAXr/wCxtoW4gpfogxxSMBQ?=
 =?us-ascii?Q?xUrkh9+zUyvcADl7G2VwXvaYN5pS3GLy1ivqzNrNxAzw7NRZ8gxCZ6pjmgxP?=
 =?us-ascii?Q?vaw5WfFxB/61CFueoGEzqPG2ZdbTx7YPBPGq/1d0v/3LwT7YW5sh+l3QxXPf?=
 =?us-ascii?Q?nEKvuKkCq1BINgOQX5u5Pjf/pQViz6DhbNr9ozTFuFj4Bj+P9UgAGu+UjeVe?=
 =?us-ascii?Q?LlULk/0akc600f6iEPxRTHH+HtN1PYjI+cOEYz2kfqhnMHrVK+d0AjVJwB+P?=
 =?us-ascii?Q?AkniwfxUx+4V16x0mID1rfSYZCX+TjTzDjw56TKi7AgH5pQ/3dZ6HjMWdFGi?=
 =?us-ascii?Q?ZWT3fNFx9XVughVhYB6SogxybXrSsu7ijO8NET4Rlxdb+zKWsQ/MSSU5f3jB?=
 =?us-ascii?Q?o4gp+ukafjHgMpn3JZ97ejtvn/FlaJ/fc0X3eTn5JtcuNbCSIAMj4qm/tKUn?=
 =?us-ascii?Q?5aeTMG9yBGhwOfdUnwCRkneEyDX43Xt+B5DKfFTVWFHlBacd6liq86McmSXN?=
 =?us-ascii?Q?CD2zJkVaTVkDtjX9E/J+Fa+7GseL09+6JIjC0pkH5jVeorYItLKqkfvZjk0e?=
 =?us-ascii?Q?Vtk4u5hbBa1//wr3F7cEX/TWWuYrm7gJzOvK3mqlb0Opu80gyZ/E7lGRBX07?=
 =?us-ascii?Q?bZz1aD1i7NTTvnf6Xo1tXBq4Y5c4xLj9EtwL2x1veHApLaWBJfQUrZ9GL3tK?=
 =?us-ascii?Q?8jdEuQXW50GTYBMWJQz5zQxQFHBzIn3yc/U6ggbfwohwlswMJ8o6lXKPPxv+?=
 =?us-ascii?Q?vaaMeLDN1HoNhrE1AzX6A4JzRQW7q/EYNJPz9M9d/wH9ytF2Z+FXQOgMBbU5?=
 =?us-ascii?Q?zjB6dWYgeIZm0cRLEblkx70Lo7yisk5HiyMk0hIWyUV2pcjXQbZezSNmNfHc?=
 =?us-ascii?Q?xmDGfw1Wyewwd6dWk98RyOV8B3wj3VxW5cgGviUO/Cn7t8Fi2opFWWNjkbo+?=
 =?us-ascii?Q?vtACDEwUdRFsPR6c1n6t1xhlYeLYLAfh+O2uFpeYIU1w2ANA92UgSj51sA9F?=
 =?us-ascii?Q?9PHN050P1y60kiGxm21PxMvsxIpjqs05MMMZLQXgkRRiFy+gnH1V3PrOY65M?=
 =?us-ascii?Q?OJEeOqtlHZj/EuTNL3qOsLEPU6yBYHzTmLEIhMe+6k2TzS2quBtGkIA3tHzf?=
 =?us-ascii?Q?Rc1uoazHxpLWdbY7qTO6zdq5Pg9NIqs6YcWxw+QiGUt4RHXmMGfSax4f3rYt?=
 =?us-ascii?Q?VzvhCd9ygzQStBVFxu0WUBT9M+pmZdRw/+CVdT6kYv08bh2FwJQZpXMZYulJ?=
 =?us-ascii?Q?jr/0NMK7CUKbq2S2fl2ElrbVccTpsM7wMX6afftW6OmpTAsFeJfw19tXpADO?=
 =?us-ascii?Q?j43Y2BZrl1SndXPueWTtn79FAaPLkFR1fmfyYbFWVAxy77G3S7eT6xJCJVST?=
 =?us-ascii?Q?s4scNM0kGVbjvSGmOAvY63Hq0IJUtYQvazaR1EpwsIxeZIq8DRko9ImeOwJc?=
 =?us-ascii?Q?kksFfR7cy1BYLwR7vDf9cxcJuxicX/Z5j9Gi3EBBK7T7vtUYsw7m23TYzpMb?=
 =?us-ascii?Q?5hTMOSOgO34eBcJex1785xG3U28Tmdxy3Z7PpO1vNNXgVOwLoU94ych8vv8N?=
 =?us-ascii?Q?JGgph1hY8Fct2YsnZng338pOmYEe7HvFMPQUw3BP08wsL2MI7Elgb2ilA0qe?=
 =?us-ascii?Q?HLXc8pmHSpgyl+ShZxr18naR0r87xSLGGWFuSBU0ggJbuDBWGguXSxWsKhXg?=
 =?us-ascii?Q?tuzPB/svZj7DqUeT5PwJLMNtxAv63/U=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfc42fc-ab8d-4285-2630-08df0feed2c0
X-MS-Exchange-CrossTenant-AuthSource: SHXPR01MB0863.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 10:24:12.3970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmkmrXPwgQuIzoNMv5Cwji9BY6Pr+x7StJ1YXgI8tFXZ3IUZ/5dTCGYUDBykV3AjWFcHphdIW83CG/J9u+VEDkgHcltWKrAp7Jd0tehE4ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SHXPR01MB0573

Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
The UFS controller is based on the Synopsys DesignWare UFS controller.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 .../bindings/ufs/starfive,jhb100-ufs.yaml     | 71 +++++++++++++++++++
 MAINTAINERS                                   |  5 ++
 2 files changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
new file mode 100644
index 000000000000..a65cc9455a85
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/starfive,jhb100-ufs.yaml
@@ -0,0 +1,71 @@
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
+      The phandle to System Register Controller syscon node.
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
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index fc320b373656..10b0d0839ca4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28095,6 +28095,11 @@ L:	linux-scsi@vger.kernel.org
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

