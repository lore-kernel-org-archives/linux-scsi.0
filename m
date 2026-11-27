Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795753636;
	b=VuQXEsqWj3FgWjXYRReQdXxxl0rLHSjydbQ1NDNJEMqhTmi//R9A7l4sUaDTwiokpy87
	 AU+W81chJMaPFGxZyUyeyFEM8UNpd0d/wnDJecpOHQ8Uei48Dd6QE2TElzwFogbZwo2xt
	 lToQ0ZnvtbtCGVbNQVfqDdVfje2yvfYTByZwjvi7QbmhQGTIAL5E5jLVRZsdXcmSld1r7
	 2cHKLz7Ac64IN54RPrHo1nIDGrus2gDSa853iQ0XdkBKNotYqH+9yHxVJS7doVwv17gVG
	 LTxRNzkOf8iaBNBrmqPT+Swb3uG01+5kWYkCyy8UmMDboIsfDi7kFCkZnIND4R822tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753636;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=ZijAmh+eHXalW3/FoniHwx9bf77c5CMVNw71elur40s=;
	b=P7FE7p7JAd6hKol0XUj3QEukLrqKl9diCied5No6YmTkeTS7uHpQkXL1KI5KIDJPIeS8
	 TeIZ7z6CFNG4vv+QFqzrAAOc4SK75inhu1BjYxjtybPSs4X6yY0EWKVz4KWrP8OOsQk0v
	 EXW6yuOsTz6N6/REwfNZa8GcMl/B1/sxnzXo5DdswYO0xhZM+GAkAWxiII95l631oQloj
	 QFiZmEeoxG7sz4gXZtGST9+iuAbxAESPIsJpex8vYyvjCYBE+00eercnxChu5vHdidu7j
	 7tvyHY70oTHCJIO/6OCMDw/qTxsv17XZxW37OIlSiNDtPSyWF0qoDWiQZTYZe8oN3Pw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5f5EJ6Gm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.28
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61940606A68B;
	Fri, 27 Nov 2026 04:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61940606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5f5EJ6Gm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sl020xnehrRKHwse7dm+RFoVd+SLV9VtklEwyMnnvB+kyoSWnuMZis+5toPnJwmKVbt94FEqSTBtSVthzi12N9IaK6BUXMb0CEyRigbjs4DNhzAH3pVlvQDqeQKsnWea3GEUgECaCDviNfkgEI75W101KUNwS1UQXUfTraGBylfV3NQy+a2DwfJXJX42E3CCK5BN5edOkUBWuV8O/ff8RGkxPIERMjZUPMusQQFOMi1eE5UXgRoBJ7uuK0gn2awDye+nf7qfT7Sytnvc8oG6uqdcUKEKgg23vL4RGsizY7O7/eaphsENdYfpAmQtTfvddOgbR1TNgD99NZCNPpzPGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZijAmh+eHXalW3/FoniHwx9bf77c5CMVNw71elur40s=;
 b=UGwjiCLP67116AkjMRyQNX1BqeLVUEH1UyvLA8SGfddybAMjy4w12mxd8pZScbxnmOZoOT+8GK2ZGN42Zgfobzv/tPrykdo+F7lV94qiFaVJtDSaLsQWx3WfVe3Im/yuINWcVagkNJzjsh3v/OzLTctt76tHzB6T/g4G1dJ/pZ1/GyqptgKZAIAXZLFmvLdlPyWvhAB8PahK3KSt0cl80fuzQW8gb0gLW/2cQ0FuNC7kwzfo9a+3qGt9YXfh0XZrB0UdBqqNvzy4s5+VgrH+Zd9cJhrjSi1WayPiWV6dR+IqusIeD0EhaP05DzFcn/vT1VXwclbGIoONDkmE1m3KPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZijAmh+eHXalW3/FoniHwx9bf77c5CMVNw71elur40s=;
 b=5f5EJ6GmFToEWSt/58EnEjnWK18bKrl4LDxdHC8Lr8B8EHR4XOu76dJ6EA68yMq2ryp/kDyLTgcs25k7oSFLpSed/DjKhzoIfPcHZw8ftOrWcf7DrkpzOHWhquuFx4UN6j92nyAxTfBMK2Imm/y1WbojsRwB1l92o+IFCh2zFlU=
Received: from MW4PR04CA0100.namprd04.prod.outlook.com (2603:10b6:303:83::15)
 by DS5PPF7B9F1F8E0.namprd12.prod.outlook.com (2603:10b6:f:fc00::656) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 04:27:09 +0000
Received: from CO1PEPF0001885B.namprd02.prod.outlook.com
 (2603:10b6:303:83:cafe::17) by MW4PR04CA0100.outlook.office365.com
 (2603:10b6:303:83::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Fri, 27
 Nov 2026 04:27:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF0001885B.mail.protection.outlook.com (10.167.249.244) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 04:27:08 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 22:27:07 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 22:27:02 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <mkp@kernel.org>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <alim.akhtar@samsung.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
	<stanleyjhu@google.com>, <peter.wang@mediatek.com>,
	<can.guo@oss.qualcomm.com>, <sai.krishna.potthuri@amd.com>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v3 2/2] dt-bindings: ufs: amd,versal2-ufs: Add reference clock
Date: Fri, 27 Nov 2026 09:56:49 +0530
Message-ID: <20261127042649.1449496-3-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261127042649.1449496-1-ajay.neeli@amd.com>
References: <20261127042649.1449496-1-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF0001885B:EE_|DS5PPF7B9F1F8E0:EE_
X-MS-Office365-Filtering-Correlation-Id: e73cfd3e-4300-4db9-4bab-08df4c3eb328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700016|23010399003|6133799003|18002099003|22082099003|11063799006|56012099006|261028144727099003|261026140227099003|261026121527099003|261022105027099003|261021123027099003|261022075727099003|261102123227099003|261021121427099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	A/b6Asmzo10hQzsY+XztF88i4GEfipK3+evC73CuX7l3wUeoLAmGVO0TGralWx8KO4cdyhCrrrbPD/3lb91+mJpHkOtK/1BKCWxBK43WFZgMxhXaZAHxrznMve5f9SMnGyn83jWaHXgB0CnZ7kCbzY8nDxoWeSE4iYxHypAcXSv3f6oNqT5fMYSXzcMg+CToULRnN6BWHZjtwvIBgHg3S7f6NKk4EQVVvmKxBzmCiT3HX1m8NYnUWN6MRZyluU2pB3yoWJVTClebhhXcZAL8I4c62sMkbtX+vR00+0BoBN9X1d1vsuRazRWadygqDE9SpNYdUGW10L+bVI7CpOi8dc3HzR6ZtuW1botr5lpNaFYjpuVFwTPNH5WoY30Ql1fvzeoPIUDRXiZeAPoFGGoRriKkHm6/omnqaVOt4yWwkdemSJRG7eNHe03EuGHDt8UL+4rY5Kedvwl7ID2X2guQ5IaRp+iRcQdv0GHtjN0hcIxi9s+n1ZkDbDR3mv+1jkwTpSdBHuJg2CDOZOPR7VdzJxfu+bPvW/3H7Q7sJHNoFAWDFkes02rb8ndqLKVAGz8fn++oCVPLp6JC1UwLwBpq3WvzD3W2ndjZuFexBYAlZuWSXKsTiYWPiKLNoILsaoXPpBdxhaNWQ+yREg61qrH8oKUdHOi+bHf8YJeKsl9SPeBF/tAYsx1AGBZlzrIe2vZ7z/WJijHSrmRiTWzHf4w9jw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700016)(23010399003)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(261028144727099003)(261026140227099003)(261026121527099003)(261022105027099003)(261021123027099003)(261022075727099003)(261102123227099003)(261021121427099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/04frav2trPpZeNgFcopGUsCrr2W9ZPTYwQF0OfGtLche54NvXbvgizYArffiEZrIgVOfuPhC32a5BjPGO7mLPSyFe7nAArpn39DLuJAPfNSK7UvLsFO3JjsD2AzfzAOtrn1UDe/BOhcla8rRNp/iqC/25Y/GRBE8mBWJcK1SlV9gMJ5EMALPji54igTQHZI8+chMKMKdBxzG6Omjka8H4EMtZpjwkQQQshuoOu2z/Gd07CxbDt1CFJk4fxSGVWcTL/Ykfa7m0IZDQ+W1kt+CwH2mPCntwfaB7UKs4B1YPO3PP6WUTFvC5wDrMjcondy1owx4L4id99ngCAaqfmVhPBiKuKdF+7+zHL2MPqRQOMiPW/dJhaJvoVVFcQU1fn3eDryQaoCbNl+AZQa/dGgH448yCC4LxhnU9wu3uyZZNLmdtPsvvt0HSP0FUeAv1+0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 04:27:08.6555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e73cfd3e-4300-4db9-4bab-08df4c3eb328
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001885B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7B9F1F8E0

Add the reference clock supplied to the UFS device.

The AMD Versal2 UFS controller supplies a 26 MHz reference clock to the
UFS device. The device bRefClkFreq attribute must match this frequency.
UFS 3.x devices default to 26 MHz, but UFS 4.0 and later devices default
to 52 MHz. A mismatch causes timing violations and link instability.

Describe the reference clock in devicetree so that the UFS driver can
obtain its frequency and program the device bRefClkFreq attribute
accordingly during initialization.

The reference clock is optional, as the binding previously described
only the core clock.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml    | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
index c00ec342d574..1f44df93c9a5 100644
--- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
@@ -20,11 +20,16 @@ properties:
     maxItems: 1
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    items:
+      - description: UFS core clock
+      - description: UFS reference clock
 
   clock-names:
+    minItems: 1
     items:
       - const: core
+      - const: ref
 
   power-domains:
     maxItems: 1
@@ -52,10 +57,10 @@ examples:
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

