Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2112.outbound.protection.partner.outlook.cn [139.219.17.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F068B3A3827;
	Tue, 21 Apr 2026 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762763; cv=fail; b=GzNH/VzJEswi9HnD8Fi9nvP9Rj1QgyDHzF7ogYOzE0hPqbF1waWPt1jROyNMglTEPRZDS0KmOYg1kUBeu3df2ivRPJF+WLJc0h7UUYNHQqBUs4PYSYnmLe1oYNzXQb/OGDGPb05EQgirhk3nmMp6X3xPTY9NvKChbY2Omn7P8M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762763; c=relaxed/simple;
	bh=mMRp5hW5MUcaYN2oDO5o/51YmgZgZibwdEwEsUdz5NU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=guzZvt88GWiq0YPDGN8GoNpW5Qz8l+a1abjFRlikv3vkK4jYcVdPotkamDgtlRcaEbLN1IGS2WaBlLj1O1SI+4pL3/bCnr7GbCsWvR6GlHjv//aZ4oPjOgg8P0ELxHsnm5GeJouliGeyfwX/6GcIhpGSIJtNqFwNbiH2IwuEwpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oId5cDEobIa+CGHd3AUdI/pXw4HjWTHdt+7zu7fwhY7/tGu4L8xAWKO0O7fw04Km77He/mIjLPTZmE94lu9d0VXTZfFkHpZe3xNxy7uDVAqDxNtayn7A23RyINol9qCNBw4TlyXqs1zbMpUHzv2IWyoOmq3zdFCaJ0FMjiX53wc+AVziBV/ospF0/2v7mc2ww8+0WhzqQU8mhiJZF8uaUT2RgZ1bKwp194gHMJ1p0lSJ4Bb82Q8DgpQifKj1zrX9GGYE8vIPGdVNqEvd7vyl+6SNWmhqliW+qDRcM3/5Uyf2E5m8WOIzHxG1o+rTMdbDMq26sxAzzRbnVBjVFPPOuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhFA2WKGVKBKOjT5Mm8kBEN1E6WrezJ5cgjrS0UFdLY=;
 b=McObAoRVdBHPy96AJiNDLn7TttDeQxOlXMXCxCJ1xHOSPKzeccpE3WdZ/HXiTukLaNBRdFmAQCERCVAvNr0y5RMli0gUYurMqVU7SvbhkXBUM1wFy/8zzTLP0aAUoM0tbJlK6bpeFmCzC7evOKH5mpBzpxiTgCmrAdw56EjMq3pFnwN8SgeJ0x7Ca7vYkvQfyO+luZl0qGW5o2jV6n6sEKQahipwe98nk6UQ38SNkbn0X/6VF37bJaV38TTDcOxm/5xAao+1YPgG310IxeE5lxOW3b3CL57Pzv74FiLJY2S9rDzLlkIHaNou0eL3k5XCJn+K7zlAoSl0eJw5woNmbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:18::12) by BJXPR01MB0519.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c211:15::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 21 Apr
 2026 09:12:25 +0000
Received: from BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
 ([fe80::e2de:92aa:4c1c:a829]) by
 BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn ([fe80::e2de:92aa:4c1c:a829%6])
 with mapi id 15.20.9769.046; Tue, 21 Apr 2026 09:12:25 +0000
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
Subject: [PATCH v1 1/3] scsi: ufs: dt-bindings: starfive: Add UFS Host Controller for JHB100 soc
Date: Tue, 21 Apr 2026 17:12:13 +0800
Message-Id: <20260421091215.120632-2-minda.chen@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: fde321fc-48b7-4b85-eb3f-08de9f861ac1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|52116014|921020|56012099003|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	PkYtuNcmdLZ+Oae1Mke3O4vbPR/J6QyEZsPEW2cVl/kCJnVKByn56FImSezbZMJ5WMstiEMtwtQ0PjqjSC9HY3dqp9oOs7lIdkziT8Poqo/smOKbHwb2CGrUjZgFjaXq8AwqAQbde5nfNWcE9zd4oeRRaiGAfVyvaYUlJCykB6lzvXwOdXB459mWN7/EODBxqy54W/V34pXHKZJI3avgJwQUDKZTZb15FExkL80SdpUlCamYSyT+9H/RUbjXRdRVIY77F6jK+iFeZzfSZUehrbJnQwJdJfnn5D70m44CHHYeeOvDuQH61uo1yslMJWMhpHI98FReWUxdr78RVaKcQBPZHArxoegHWUhE2dgKlPkMzpX0ijpfb5XYMbGSTQyeUY3J6nzdNxbNNrPFjtOXOuTAw8ql6q2MEs38no2HIG32lPtUBEogQu9KtFCwKeXC382U+NjG4KhULDcFM6Im7Yf9E2zWowpnmSxIE0N3CBgbsQshszMG4kszr5yxT2L9Q8q1kUIu0JcuJ9teEwLhAOmrGBCQOdGDBvpLqjEXsMCxzYzBXHCoNVEvyNUmLKPk1HqhwAO90DJmefWeBGBrnM7/KhrYNhul6zFCoFmpV1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(52116014)(921020)(56012099003)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FnWwfJEX6Se3/OaXHr4bMMErj/RFnNlbmjwt1hMAWaYpHD0uo3kAnFuiqFKu?=
 =?us-ascii?Q?C1UKTAjSpLhMhIqPjTxADilmQzWRvlONOK6sev7MDi4asivKMwmfJJM4E5tM?=
 =?us-ascii?Q?7LK03bAVovrG4LXNgo/bOIo35iU4FR0FhPiQ1bvDfpI21M590f2UOc3VAURa?=
 =?us-ascii?Q?g/VVhxG8tt66HFZMQEGZC6O8opu5w9sCZBe02u2KlTJpnQb19Bm5YBbftT3p?=
 =?us-ascii?Q?FXCZBcPGRP0MBDJbAjut3kq5fuRqUZiSVlE5n1vK0f3wYIy9s3KOgZnLbjzu?=
 =?us-ascii?Q?lP31lwCAxZq2I7Dn52T90Y51KNsNhhvXd3JddyIh/n7d4M2NpDapMuXM8+EU?=
 =?us-ascii?Q?kytCxyjzd5tFHbHC0qf/26vcbgiQ0XsFfMmmRy59HUxM4BeoDF7RaZI6MD1b?=
 =?us-ascii?Q?fA6meIvt1GfxOyrLbPV+desOs6gBzQBZu9SxVm1HjAwpK1E4Ftn689iPBQTc?=
 =?us-ascii?Q?6iJCgQRDt8w1roTuqgvl3XLBcdTUMxQFta2MWsH4VcnJaF3jhZxxVERO9QNZ?=
 =?us-ascii?Q?euUFF1UTSdL5w0WUHpWVX5DabXqq8vvMm3m1lio+IVZA4elG6E2BcC0Ec6vQ?=
 =?us-ascii?Q?YLbXDtajcpltw9t5qJgRqH6YuYe9JptJ7UM/E6SE+qX/nIb+TjTGVp2Gjx9j?=
 =?us-ascii?Q?WwkJBuhaYBU/CINEwhoRe0KznkgkY2pu/e/wyZeEqMOx6pbfFj202s2pUUK4?=
 =?us-ascii?Q?7Yz5HsV1i8pOeixoFyCXxTkExZS9S88XEab4y2und+g19luc5mJtG2Czk0kq?=
 =?us-ascii?Q?TRUhBSkQtweUcprpFu6T40A5GdGKfApRz4j/tqhP7GmjSpigeLy9cA+aSCqw?=
 =?us-ascii?Q?+321ta9hU+SnI+qtDSgDUaCE64P43JKKHRwlmdAWA7fHmokvBOoCBsQlSk3M?=
 =?us-ascii?Q?qLXe6JDdv+M0pfk0nuIwYEW9fPE4/FT1QU9yk876/ioIrWq0ZSAxlo1m/pMM?=
 =?us-ascii?Q?Hlcr+clEKdrQcI9uWOhfNSkgyC5I0oNsAdelHrFe7rhKZSJBSJaHuzdspcGQ?=
 =?us-ascii?Q?yw3x4W+dL0L464t1XT97FUkiVhOpFCX5Q0XI3CXj4Jlii1H90+PhLbWDrolL?=
 =?us-ascii?Q?dc3jTutWlw0osicW7uUW9klu7KTY0kbL4t//aEImcOF7bLU8LlDgbJYrjG0W?=
 =?us-ascii?Q?tS9o6sSaNYz8SqzDT0jE7NLZ5oMso6kxoyOXzTmEhfQIEHJAlURwpwKnKGal?=
 =?us-ascii?Q?9/mgvuCO/wblG/6havJyn5Zj18YaP7a4o73Dr5ZMH1D8qmkbfV05OYwpl/Oa?=
 =?us-ascii?Q?0WaOlXh9RiH3WFVwLGNIi8AIIzpoNPbFRPbFut0VxfzqlYXxpAbTi1vFMslB?=
 =?us-ascii?Q?Bpq8NgQCF+DFwRLI2drl+SoXYDoVtE4a/v6MZgtV/gPgxKdb9NrJvkNeX0HL?=
 =?us-ascii?Q?Nm2gsf+8SG+Gi/g3Ey4ixXa+kBrgEojZ8sCv02rZ8MfVn4nYo9Gn5SOTTtOW?=
 =?us-ascii?Q?MHdpC6WOvVjfeLsrhZzd683Jxg5Xs/J7brCMHf6/kRlBov1UVPPZ/OnQAe+o?=
 =?us-ascii?Q?guZzZq/oMC7lS04H70GviP9zZuR7nfJIlhEUsLc/GSteK/IXB+ebLs6dlwnh?=
 =?us-ascii?Q?NjXceMB/tOjnr4mLsKhGlAuEsnRsKy0Lid+rKoMgPDLi4CPiuckuzmP8Dt+9?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde321fc-48b7-4b85-eb3f-08de9f861ac1
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB0855.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 09:12:25.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzQfAxUrt8SKlfcfJv34+D4Ft9eOv7VYFNcIs4nF8GmbAK8Gf33pnEXHWLnG5APuevohNSO3B/Pv4yDktCy04HpMn6d0t4l6qCFH57FRD8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB0519

Add devicetree document for UFS Host Controller StarFive JHB100 SoC.
The UFS controller is based on the Synopsys DesignWare UFS controller.

Signed-off-by: Minda Chen <minda.chen@starfivetech.com>
---
 .../devicetree/bindings/ufs/starfive,ufs.yaml | 76 +++++++++++++++++++
 MAINTAINERS                                   |  5 ++
 2 files changed, 81 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/starfive,ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml b/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
new file mode 100644
index 000000000000..c408973dd0ce
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/starfive,ufs.yaml#
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
index 32bd94a0b94c..3792c51da63c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27190,6 +27190,11 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER STARFIVE
+M:	Minda Chen <minda.cheb@starfivetech.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/starfive,ufs.yaml
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.17.1

