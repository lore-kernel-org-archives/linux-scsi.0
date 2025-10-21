Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0932232D435;
	Tue, 21 Oct 2025 11:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761046239; cv=fail; b=iKONP7BrUBmJBl+NqX40cD3YprQq+1ANPonTmfxxME/cKKq3nO8vaIBBZYRM3eMbgFoWRiga0jNbtXM2vBC+QCbspJzFjY4mImGxhJl3j2bGyjZ+YK7Cr7juU5eqN+6MpniA1Jk0/x1XOb3jAhqW8ImSIk/wzRLw4ug+njqTOz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761046239; c=relaxed/simple;
	bh=hYnXiAZxFelVy+BhMPrA4PvATYRZNEfYq+KnacwCrM8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FM71MxRxLvf6egYzDk596g8zSo4BHqUv8q8juqALaTfQepJg1orz1wi5PYsY0k90CsQjyTpdbQFONeagg1lKTXZyNbP38q3Zoea6r6EzG04l5GODFRwoVVnjJYgdH6wpyErPMGWXGMvzyr1lp1jgm578o4fVdc9eV9Q69EE/vNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hd92iVAZ; arc=fail smtp.client-ip=40.93.194.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hd92iVAZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rjnD5HinAhsW3kfvje2jCZUEZ/NSADixgwS571porZlgRXTYdh8ttg5dRtk1gEyDleL7PbaGQlggSi5+f5+gu3cTdFLnF28UxmiLaEBl/3f/3DlwQ3oyOfDfOMRKaPw4qoG8gUtQmj2KcNIXTJ66QED3mr38sOMekAXhd+P1XGOMoG7YZN3+bT64tSdsaS1fdd02CtgSOpmrcpErn8QMYE0ci8IkkfzYCtvl/p87agYxLSVzpjYNSEOYngnd5ixOINB+F7FdGlUIc+/EWiJwNDpjpr2AkNIrQElvsR/P+4i4H9TM1aXXIy/UvD/hAlrr1l1xyS7BWJzqt5H/UObhcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1BLwIM+iImP7lkjuVGgZMIa7XRobYtUuwq+14GWL5E=;
 b=WeBJvzh0eZNe8we6DBhIwOTrieP6iEK4uNuZit+6B+acxQInrLIoUMWT6gWwfvgFu2b9UbIc8XeY82laHVEWbs/5zXWYARrPZwlUCwQgifRbNXMLbTouUEBPmvpiDdMnBI2e1wbRJZWZXFVHsc9v94meM64eTu79P+BImTa2ri1KEdY/JBiwbcfXcsq/11NPAEIhG8iQAtI3mzribt+QXmm+XuUXwDDZ4hAK/lKgpp75yVL0D0tPzBLhCJd9NyWJbyWtX3Xvj0GXP/PiD6Xex8SNdcOOVBcMMzk9nQR20kvO36Ayo68pS4P8c+0itjAZAx+EToE+08Un7xzTqcfD7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1BLwIM+iImP7lkjuVGgZMIa7XRobYtUuwq+14GWL5E=;
 b=Hd92iVAZBOYE8q4Rv72qG7O4etTMJduod1sRLIKKb5KqHn2O1FRrJS1t/gy97+K8OhFSZRY8cNwnLjymV9rYKxCBPB4EVVR19mqLspnhbziFGfINjKN8utGTVB9mkmUVIqk9BLrpdYpyLiODXXpUCqQc+8JI9mKA8u5gi/vC+1g=
Received: from MW2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:907::23) by
 SJ2PR12MB8782.namprd12.prod.outlook.com (2603:10b6:a03:4d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 11:30:35 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:907:0:cafe::be) by MW2PR16CA0010.outlook.office365.com
 (2603:10b6:907::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.12 via Frontend Transport; Tue,
 21 Oct 2025 11:30:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 11:30:35 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:16 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 04:30:15 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Oct 2025 04:30:10 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v2 1/4] dt-bindings: ufs: amd-versal2: Add UFS Host Controller for AMD Versal Gen 2 SoC
Date: Tue, 21 Oct 2025 17:00:00 +0530
Message-ID: <20251021113003.13650-2-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251021113003.13650-1-ajay.neeli@amd.com>
References: <20251021113003.13650-1-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|SJ2PR12MB8782:EE_
X-MS-Office365-Filtering-Correlation-Id: 12613b4e-9392-4ea0-c496-08de1095408f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5hiJSmejn7SJf5jLO+3Z0vNnZzIb02nCVUJ4Yi/E+mczLPlESK2dLoxvMeKi?=
 =?us-ascii?Q?9bt9BWtudP5wmRK2dSfTh8FWOLxZzuc7XA2NNnjKqRjsOj/skuv9vJ/cbPp6?=
 =?us-ascii?Q?jC21C0nacGLwkuO/fqNNx8lc2x4PceVtI6+1UuvS1scuBysLsxTZdog7Su6q?=
 =?us-ascii?Q?Hz0uMPvYtD56chgPjrxb972T6pZSm3jRAZiLgSVgOwUG8ylzFy9ww5lMS8rv?=
 =?us-ascii?Q?/ZteU7NWfPaPbWe+N39+4/oVrVTLECjV1BFtxCkuouCPlGWgUIxb6mYwcA3V?=
 =?us-ascii?Q?kfaLpxHL6Td9Xcu93PCo5m/5u/WlnMBUScfupezmaf94KAvRmL7kNcV6Nnhr?=
 =?us-ascii?Q?0w3y5dTuEHbUFAzs9SCAiljqtvheackAikTTv6yPF0XPrzjSjFS9jm/px3Yv?=
 =?us-ascii?Q?Jz4ZoAd7j46B7iF2lsBBbmIvs9M8/IWwsy5B+xyNeE3cjXl7QIYEGOIdKzea?=
 =?us-ascii?Q?bUZoPNHwiD156S5l4vgV66idY6jYzqXatCBuL/c6dC9jYAecj1f06/MbQ/rG?=
 =?us-ascii?Q?J/6f770VuDCYsMO1Yx+1baeEo2chKmJZa3hVl9g5mqp6IvYZL7LYoyC7D9oJ?=
 =?us-ascii?Q?0N12Vc2RMRaIquvygeAsm3NFgu7j3UaKMQfkQJexbqD3zwf62rFZ1WAjHUzi?=
 =?us-ascii?Q?pqGnGoNlRIVSW7px+ENTV5IYfyAZb4c2BQmVoGNpm5xvLQDihd/Qg+AKLO0r?=
 =?us-ascii?Q?JnJhnm0q7F6k7+C5bUHqNUscBmNoHEeTAP2jTzZdDz5/qDf73eXY4kC6MxBe?=
 =?us-ascii?Q?V4KBsRqsXLoaZojprKT2uBE7HRFfF11EZifTki4gHu+T+A1KD3tXXcgU2rvX?=
 =?us-ascii?Q?IW43JAol+9Y2yWCJJ3IeB2VEq8JMB+gA0y5npMMaY8VpAxRmz3CRcEU7bwd5?=
 =?us-ascii?Q?VFxuxXICewwaNKiUhAmcDF6108jqC0OqB8F3FHjKAkp7XcDJtxsrB29U1yV8?=
 =?us-ascii?Q?KAoKcchqLTOVklocNdrefDZ1/V/pXFRVeudej70moYMy3TW5SRZeVzEBZyay?=
 =?us-ascii?Q?7dBYenpPi7MyvdW8VFZ2/Sz7RlFX1pjS/L7pWJ3htut8U6jF5uok0VplzJv0?=
 =?us-ascii?Q?gTjh0zWZi7XgbVFJ1QDS7NEReOtGfz+h9kPk6pz3e657pYb/gJQFOfq2FeMJ?=
 =?us-ascii?Q?BEANSryGQdjSKaQ7U4TIePG2fRXBCfhF/9wYXwgSG5lbM7lCby0CC0lrKLGV?=
 =?us-ascii?Q?3wAWrRkA17E3Rr04sdkHZq/FddSvxmovmfJbJF3MMYLgQlzDfirUGjLECKsx?=
 =?us-ascii?Q?GVpwiDxWvCnzT5OKoGQlsmqiArkekzAsgLw+w+sHvViAgHZUvoCWwOfTBOko?=
 =?us-ascii?Q?71rpBX1Tk8whCiqDFuIjnD/aGOzvIqMsjxVKvQpsQqH+Bm9U0m7aA7A1D3Uu?=
 =?us-ascii?Q?yotZAzE3dub4drcqEwGLkleMxfEK4/35+tscj+/efxuEM96NsX2wfgQMYfgW?=
 =?us-ascii?Q?2rvRdg+Qn65V1O7QCuFoh8rUpT0NpV89BDicGo5o/XUwtSheAm51f6A3glB8?=
 =?us-ascii?Q?IMwtwREgCB2Jq/9B3eLlKHTphcwFZ5uT069y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 11:30:35.1187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12613b4e-9392-4ea0-c496-08de1095408f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8782

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

Add devicetree document for UFS Host Controller on AMD Versal Gen 2 SoC.
This includes clocks and clock-names as mandated by UFS common bindings.

Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Co-developed-by: Ajay Neeli <ajay.neeli@amd.com>
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
Changes in v1->v2:
 Rewritten commit message to clarify this as UFS driver for AMD Versal Gen 2 SoC
---
 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   | 61 ++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
new file mode 100644
index 0000000..c00ec34
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/amd,versal2-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: AMD Versal Gen 2 UFS Host Controller
+
+maintainers:
+  - Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
+
+allOf:
+  - $ref: ufs-common.yaml
+
+properties:
+  compatible:
+    const: amd,versal2-ufs
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  clock-names:
+    items:
+      - const: core
+
+  power-domains:
+    maxItems: 1
+
+  resets:
+    maxItems: 2
+
+  reset-names:
+    items:
+      - const: host
+      - const: phy
+
+required:
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    ufs@f10b0000 {
+        compatible = "amd,versal2-ufs";
+        reg = <0xf10b0000 0x1000>;
+        clocks = <&ufs_core_clk>;
+        clock-names = "core";
+        resets = <&scmi_reset 4>, <&scmi_reset 35>;
+        reset-names = "host", "phy";
+        interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
+        freq-table-hz = <0 0>;
+    };
-- 
1.8.3.1

