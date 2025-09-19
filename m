Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A431F03C9;
	Fri, 19 Sep 2025 12:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758285563; cv=fail; b=mT2VXECiYyabbTSObS6OD/NVqeLIIMFSEUZahMXKbnpLc1Byqohq8HTAv662w2XW0U1sxmB6j3d5/FLYcNtWPKmeXsu0naDBhHUsYOsjMo2cO3SAI0u8DFSlfvJ6E12AlhHEM0sRZLeI8TuKioa6EtH0iJPZY2nBqmSAc/HHSFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758285563; c=relaxed/simple;
	bh=peZTPXUdwE7D2+JBciut5/Htr/l9AT5+uylliLdxGDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K6diuJthozWWS8ef33tPXxlqsFTrA9qXZ7uaKnlnZW1EFfcZtJow+IPPxm0oqAKMTr6fAOgdgg/v/xin8TyC8y/xqD8JW3lptIOIZ1J0e9TiNsFzBi6aD9nIm0O3KP7DE5byn9HMetAP0BC06WyUOFITIvdaXVqWo+oMosDYe3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=la0yegqw; arc=fail smtp.client-ip=52.101.43.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="la0yegqw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jxxAAe4oBR2n2q8+8L/eiT+RJ5BOrD2wDpxmE19dFD3GqPEYhVZBsN4wOYm4XdSwHPWI7lE7C+XC/3e/38UmJCa5ion4GRBfs4r1rY2FcwLHi3OC23qnHuZj46/DA2jpUg/EbiYYOsBBcNbmCwi5OkOT6OP3rI2zM0VdeKWiyTFBRZVHPGKFQK4mwdIT6cvIQqxxzr0QrpquMvKZd7K3IkYk5YHPc52wK11eMNIyUTMc/zBNw2ag+6j+PVvttUCG8f6fFyAdGVUFVCLEhDDu3ssu3/dzHdJMqZ1sdbyywGHdZkS7uJcYRIHrf1BQlXiJqS7CrsWLnV/vNYz3BaE7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lnfwyoj95jQ777UEHjD+yjAWlLfcrY9Yl+qb5xeevpY=;
 b=VoIWy9HieTittydJ+fjnHEKqTn42tGK2PY0o0UeZQpCeCRVtVQsz3TYWwiJiqWqYaLwF4LAN0cZKr/FkHNaVLC8UY56W12RDvHjYDrllluS5tlGsAgGA8EVeGR1Tkfmyn6Xi6taGxuBk5cPLfIwnZ8JmVMvMXdgKke+d/3p9OyS8SSU0NaZmz5REl5x98GNOu/Yhwat41B08iRFg63GvUyMgq3if+YVU/3NHeLrej26K8+SlJvnf8uNQ7edtVLEI52C5KhzPNqXO/tJtg3b7U657Yn9fSHCXpOyUGxxKlU/o6h0dWevAtJRZeewW1qs5OdI6QbN4yZfrH0+BjFhxBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lnfwyoj95jQ777UEHjD+yjAWlLfcrY9Yl+qb5xeevpY=;
 b=la0yegqw+yGoaLxBymRACXeK5px58MRyBykBkmJ83uEbSP6rlidrK8biPJuF2bGFnB54dm8e/8KRQgu8WUjrfkOYDus7UUsLAlEnalfpmcT+tHsid8Mdyc8MAcDSXtLqGQQevy/QxbCMgNCwdVo4+2kSaWhpbOy4YTCAQHZ/7Zg=
Received: from SJ0PR03CA0048.namprd03.prod.outlook.com (2603:10b6:a03:33e::23)
 by PH7PR12MB5806.namprd12.prod.outlook.com (2603:10b6:510:1d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 12:39:19 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:33e:cafe::50) by SJ0PR03CA0048.outlook.office365.com
 (2603:10b6:a03:33e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Fri,
 19 Sep 2025 12:39:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 12:39:18 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:38:50 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 05:38:49 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 19 Sep 2025 05:38:44 -0700
From: Ajay Neeli <ajay.neeli@amd.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<pedrom.sousa@synopsys.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Sai Krishna Potthuri
	<sai.krishna.potthuri@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH 1/5] dt-bindings: ufs: amd-versal2: Add support for AMD Versal Gen 2 UFS Host Controller
Date: Fri, 19 Sep 2025 18:08:31 +0530
Message-ID: <20250919123835.17899-2-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250919123835.17899-1-ajay.neeli@amd.com>
References: <20250919123835.17899-1-ajay.neeli@amd.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|PH7PR12MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b496a50-4f93-4aa8-ffb7-08ddf7798d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?enoF3izJNr9M+KVeRrIukjaGgGbZcvfksD8VMc9HKLaLr0mRVfSNj8o9Tomm?=
 =?us-ascii?Q?3LWsyOYdcD8eeArDy6xa8+17UlUk77AwD/I483zIzUMaveO5jH8XeVzcgKCM?=
 =?us-ascii?Q?hbs65OnsFjs5/bI2WBxSAX4BpoXdQ7aeL/iat5mXIYEcr1syloAsE3huGJru?=
 =?us-ascii?Q?IbcpCTGszl2BS+re7tIPYkTLeKwbCx/1khGJrl0bTWmODVn8tlDlXeJu9xI7?=
 =?us-ascii?Q?nckJ4gDLvMvoFtrcelAWMP2ULr9mIG5PyHNYC5pzizlqylCQowrquN1msF3m?=
 =?us-ascii?Q?1PLU8IHsBaXU31KKlkXwVSaqpDrFASTHvDddyti9Flq2GzVPvr2Sqg8W5aTR?=
 =?us-ascii?Q?pQbq/GUbhJnXhGvSgcEECyjTC0X2zGw+3sf7kJCXjI6Ns98RbgSzKInzhpMm?=
 =?us-ascii?Q?vAJwns3h3+e9p1KBbsk49KJZiWypuQymRZxrY3V2FqPEHpXg2TuelGNnwmjb?=
 =?us-ascii?Q?GnXxo3b9Ijo+0xJm6M5VZ7vNo57IgniBgTiU20DHsiOnIqroMr1cINuH/PY1?=
 =?us-ascii?Q?34im5mdxYyvwqlYfcc6VqBOrYCxChVf66cLUb60w1BCOyQVJ3cliN1tTDK5C?=
 =?us-ascii?Q?8//VrBGPeaSxiE0d8rAVuFGCBU0loG22xUN3Ffhs1Oe8o20s5T3/E59IIu6B?=
 =?us-ascii?Q?HLIWYv3WnB3COiEi5GJ/8/ugFnprGC91a0krwPq4dBdLW+UEVhrArgzirQr1?=
 =?us-ascii?Q?SSgqYbTbW3Dqewq9DL9vIE/PI2Ws4jwU8rFBy3Z275UfHot/O67Wu/Glrols?=
 =?us-ascii?Q?ADBhbWEPNZZHk8cMLBiPRvRpm6A0ULd7izBVp9X+WYjqVZlb759kKU6kSbHo?=
 =?us-ascii?Q?04cd8yRlHX1G0Ljy4+sv0OLCcGBzFIWkgtHu5FFKUYSQFuOYoqBXVPJkKS4d?=
 =?us-ascii?Q?dYLDCJZMu1v81jVxsDHmlJIdMvBL8Yce2ocD28Qa5oD4YSIrwdKI9RxGSx0K?=
 =?us-ascii?Q?kxQuPj5rA3YEF320NMhVelGacwr0RoTgnv4Gdxtby7UpjYaASK8Sg3/0oV/T?=
 =?us-ascii?Q?F31fhrkckWeEAfWr8HEfvGvwEP34lPuRyPGIXJ2yMfxYgwACMQ/bWFK/kWz8?=
 =?us-ascii?Q?gUtbwzFoZsprKVhaAm1yQSdsidIIC8TbmssKBazRD+jE2TRsonHMLjcYp1hr?=
 =?us-ascii?Q?l1Gf8tuUUyEtcy+H2HHpNXjHtchjvn0SUg0EABpKfCBq4yf4O4K+O5U6+fIm?=
 =?us-ascii?Q?UF5jniBtHXxCsfyUQoAt8es83HtSP50Laznf3LH+XPbgQjMSuwCsKKT1aAl9?=
 =?us-ascii?Q?dbuVzEky5Kxa+13H6QHaIJvMiLSohf1T8LaXo9sBTPTceow9Gm6/iU8z8kmV?=
 =?us-ascii?Q?ihKA8fT1eDeoGQkupm8rTO+Mb40VYpaTJ5tSEjwGf7weeVJEm38LcE7lRDc0?=
 =?us-ascii?Q?DkMUNl848TdN0W0QrpFifE/07Vu9XoAjzxqaoORxXi4lE2wQmlD+qxEpEJhw?=
 =?us-ascii?Q?2iBy3IDHIFN7dVlbzsUqhGT7CKxH+PSpLHrmD+IiPya8TA0RmDq1bQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 12:39:18.7178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b496a50-4f93-4aa8-ffb7-08ddf7798d32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5806

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

Add devicetree document for AMD Versal Gen 2 UFS Host Controller.
This includes clocks and clock-names as mandated by UFS common bindings.

Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Co-developed-by: Ajay Neeli <ajay.neeli@amd.com>
Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml   | 61 ++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml

diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
new file mode 100644
index 0000000..9f55949
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
+      - const: ufshc
+      - const: ufsphy
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
+        reset-names = "ufshc", "ufsphy";
+        interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
+        freq-table-hz = <0 0>;
+    };
-- 
1.8.3.1

