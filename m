Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795598661;
	b=h49p9jQ5/Yj3VfE/iE2md1fM+IG+Ml8l+9ypxZHLGh7UnYCBtZoG8hG8bzNya6Z3VTLh
	 7KD4wWT8eY+u/Ta9C4ed/v8fLSlXpbxhtm1wF+E7M6HO3lhtf+MhwSFrnJcqaRJ/XqlNr
	 NRCxqgTkKT9uPwdx+5FiisSs7YjphFtHbdg/5lYfq6sR/GokWZ1+7Ps8LDhwUWGH8w3ds
	 2XDpowgvQ4x1NFAoS09vmOiUZLnuQlwBcU8nAyEe+VriIm4CzfS4bERVAX+pfw/LrJdFf
	 jCFMflKMOVW6r3FS5RZKnobThmpclrc5bnw3jU5NXCJUPdj8HPGOdf5anCO4JBpr6iA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598661;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=K53aKp4HqenhZP7UrAYUI++QU+JFPOoJeoBnHbYs9pI=;
	b=xTyJXzuWbudV878I0nFdNgjMLXuBQDfTVv/hYtqsgzoEJxz/O+PpeuEV6cwVzRb8o4vq
	 lD+5I/P5g9N9NI5XGq6hfpBBous0iEu/3WIOAd4utsHPFrezcXvLBezarDD9jWkJokJ5D
	 K+p7Fh96X9YoQP80xFekPBqIAWM4BuOOH13HCtOxPvpgsqLaKS8/364kmmVyW/dt4Xsio
	 nIxjydRdT5+1/N1J+WDHdJUwYN7kwcg7jijjm57kXILFEU9we+XEFtKA/BULGuo+OQM+2
	 cMKdFO6K+XzygSzibREsUGBBPfZ1Z5xaETMZzbZ1LL+VMbaHlcWfg5uqj6ce8Ly8lnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Da0Synfz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.42
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010042.outbound.protection.outlook.com [52.101.61.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED8E606A33E;
	Wed, 25 Nov 2026 09:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CED8E606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Da0Synfz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwr/RHVquc+j/K6lQnp+sBocr4APSqt6yMgkEcheykwWyRZ9NfN9cmo7s1lgXZ6hyaDph/RnnENmcHn8PdG+0Z/OWGFMqDEm5hEkt7NQOsaGurWZWvIX+jvnar0e4pLo1BSnvquNKSa6Q0G4vs2w4MvXBM2SLA2L9R3YNKSN4nRSLlspO3t9Ru2Vex7vqrYxuDMZLsqXTSkWlO7uU07RyWploN+BekiFrh7CLh2jqDT3USj1uF79c8J6G5+Raa9IdIe194DInMt69H2TFF991Zl7faPSE+fhR4NHFZ08Y4RNiE3o/ZY1YIgNZqJBjn78qbaP9FuZiZfgTa15tko0Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K53aKp4HqenhZP7UrAYUI++QU+JFPOoJeoBnHbYs9pI=;
 b=JRy12viXq00vgkuXRXZzkUCF6eJ217VwiBJlyBmgQsWkT5VxfNBnYUBFVhD8mAPaSXL//DEOXkOL+GrJYDTQXWjEGZWG/7Yby3VylLUP+V4W6khrEmSm7pmEXrMqufyj1E/BNfNXvLwhwJmdmHIceqzfokVHq/z1Psu4LN2ZDupVetCb9NGf8Gb58GpTwxuO/jlYUVQCI0agCyo4A27NTEEcsKT8lYAhu0UwylpX0WRYrnNDL3CeNyV3Gq/exTdbC+dehLVADB2viikQXMMl4XuA4x9gnPWdAhrP8tgbmapmhpph8VCKjF5q+naEml5y6LGmewXdZhO7vRwBkLC6Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=hansenpartnership.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K53aKp4HqenhZP7UrAYUI++QU+JFPOoJeoBnHbYs9pI=;
 b=Da0Synfzj/pbortEeMf9DsP2g3Un30RvnkES53Z6E+l4q7G1xxTiqS3Nq+mu1yWR64155Cid6QxjT/EFQEtjJzSB8ajsk7RgJtaw7r4G7x1Xzv+vcY6FAap8NBYORGZzS+duLEKZ1csInF7xGA7hlU7XOkyssWJ7pWsMVn6l8YY=
Received: from MW4PR04CA0212.namprd04.prod.outlook.com (2603:10b6:303:87::7)
 by DS6PR12MB593576.namprd12.prod.outlook.com (2603:10b6:8:412::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Wed, 25 Nov
 2026 09:24:11 +0000
Received: from BY1PEPF00026956.namprd05.prod.outlook.com
 (2603:10b6:303:87:cafe::ac) by MW4PR04CA0212.outlook.office365.com
 (2603:10b6:303:87::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 09:24:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF00026956.mail.protection.outlook.com (10.167.244.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 09:24:10 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:24:10 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:24:09 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 03:24:04 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <James.Bottomley@HansenPartnership.com>, <mkp@kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <sai.krishna.potthuri@amd.com>, <alim.akhtar@samsung.com>,
	<can.guo@oss.qualcomm.com>, <geert+renesas@glider.be>, <mani@kernel.org>,
	<bvanassche@acm.org>, <beanhuo@micron.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <git@amd.com>, <michal.simek@amd.com>,
	<srinivas.goud@amd.com>, <radhey.shyam.pandey@amd.com>, Ajay Neeli
	<ajay.neeli@amd.com>
Subject: [PATCH v2 2/2] dt-bindings: ufs: amd,versal2-ufs: Add reference clock
Date: Wed, 25 Nov 2026 14:53:51 +0530
Message-ID: <20261125092351.2807658-3-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261125092351.2807658-1-ajay.neeli@amd.com>
References: <20261125092351.2807658-1-ajay.neeli@amd.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF00026956:EE_|DS6PR12MB593576:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b739c4f-699e-4ac8-5106-08df4ad5dd44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|23010399003|1800799024|82310400026|10067099003|56012099006|11063799006|260925022911599003|260925021911599003|260925021311599003|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	d1gdgV/1ph5id35KKnDn5AQcK6SpiHwPr+4abTU7xoLVbmcWJ3iMKphzVYy22eptlO+4W2NrilEqUpDDfXEtaWqpa1Sbf5uddO5Y1gZWw8j/bD32QdZwj68Vteh5ILRXZBPG5nVCVrtsT4HmUbqlLW4jK6FdbWLLe9IHMJ2iNvzoIzw23z/72Vybf3sv+8ocX8jPMryBoZybFDd+yjG6j/LKoMvyJgw81h6rUgaKt3lfpGH4rgApZ9DwBBCt6uE0Zvr5ikRIZ2JduKPiT4fQWVrB52VAMKwE6Lirm63MjzifLNB/ilRPkFqTcGRKWa/s0gDLLvzbw90blH3RLhGKxXZNrk52/pFRGk0ZLUAPyony96YAyuXeS379RWepbnYZ1rqSvor2d/o8Cc5qCANau7mmLiaSTEfODq/E7sbKRnAn3QkJCGIFlxRbMKpeBs28Mgpa98OHMKP4TlX14LuwPRooU+eXZSGuNgsBcEWjPn2Fb3g83fzZenPfKCJbVhLqmeJnMitBizqfUNAApcE+d+wqCfxAahcARLt4Z3idPKdPhq1pPfRVvGnM5/l5PIXe8Otnpe0pX07hOUjEKeQe2HSqlrHdJdgIuVvKn5csMV9UJosxzbU5khUoBXZJ659kAaEVOgYmCgFOiloMLyShnez5ksKmKmZSG2KftoKCsif7kX8GX+/LHR9bHgl/crIL2AQXBFy1hSmerP1KoFXH2A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lHcwuRSyrzxJg0zL8ZQTu4EJaqjJrFrKbggqa8O94+hBlzohhyPvJLXatA7Iv3nUOnox2nC+s1QfoPigwMCw1eRAiGMquw51vQw+VheCROklUMHc86xXsIT1thlPZvb3/qrp0PxLjorRPh8YyKASfs9Xv0xzaE/GpqhQ/cRLa6eUmDct5BM/YnqK+Wk+LO9bQtjffJKczcoJQtUgoLeOJk77cqxeWJyxBLn/5akriEOcLEI4LurY4XlW6fhks7IvR37rv1r/9CKmWPCHkl8sbMz57DgDiHX3A7zdll4pfZsTIQqEtmeDJGyqZCATMbHycB3KjszAoMR6vD420FA0FhYCTSL62YTTQ/R2gJECWuRdmghQ1iiEpkDwu+CQHvl5c69ZY3qq82Xg2ngHKKeg47wVvQ4ejwZpjqDr3i38k2YSgUmVhgHGKpIkdZvf/NHj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 09:24:10.9369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b739c4f-699e-4ac8-5106-08df4ad5dd44
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026956.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB593576

Add the reference clock supplied to the UFS device.

The AMD Versal2 UFS controller operates with a 26 MHz reference clock.
UFS 3.x devices default their bRefClkFreq attribute to 26 MHz, matching
the controller, so no explicit configuration is needed. However, UFS 4.0
and later devices default bRefClkFreq to 52 MHz, expecting a 52 MHz
reference clock. This mismatch causes timing violations and link
instability.

Add the reference clock to allow the UFS driver to obtain its frequency
from devicetree and program the device bRefClkFreq attribute accordingly
during initialization.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml      | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
index c00ec342d574..11138578975f 100644
--- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
@@ -20,11 +20,14 @@ properties:
     maxItems: 1
 
   clocks:
-    maxItems: 1
+    items:
+      - description: UFS core clock
+      - description: UFS reference clock
 
   clock-names:
     items:
       - const: core
+      - const: ref
 
   power-domains:
     maxItems: 1
@@ -52,10 +55,10 @@ examples:
     ufs@f10b0000 {
         compatible = "amd,versal2-ufs";
         reg = <0xf10b0000 0x1000>;
-        clocks = <&ufs_core_clk>;
-        clock-names = "core";
+        clocks = <&ufs_core_clk>, <&ufs_ref_clk>;
+        clock-names = "core", "ref";
         resets = <&scmi_reset 4>, <&scmi_reset 35>;
         reset-names = "host", "phy";
         interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
-        freq-table-hz = <0 0>;
+        freq-table-hz = <0 0>, <26000000 26000000>;
     };
-- 
2.43.7

