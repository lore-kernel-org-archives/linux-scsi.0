Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794371942;
	b=H12Nbg2nU+FRPjpGLLX1A2PP9GvpxqmQlJVfg3GkyzS9CiA9oBt/ZueYHIWykCLqyL3q
	 Q0MxwP7hugDJTLsckkb0ibKLem4Gkg6jVllzYdPsRn5dldL+sCppwdqM5E4XUEHKfkha2
	 S/5sQq7J04pPdofT8VLO50ST3Ve6liCwTuTlZ/QbX5YUK6i2cIoXH28eNrwxvDoX6ELGJ
	 PZP8VWTPKHi73tMDMnAWSw/yqBZox5UpebU1kriu0mWFLVgmuEXgUxPkItOwygX0cJUjf
	 Bz0Fgx38eGTMXfk/vvRrpeBABGfKUfdMSDc/mKcsHhF85+KZ4VX8AZVcaoLpzqN57Rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794371942;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=gaNeE5fMhBNC4kLC5Iqncl0C68vaDQbtYP4485AbZ/g=;
	b=tEdoH2qV92Lm0KRt9lZbzn8iRUeuiokTS/5Yx8XwKE0D9Th/cPQENQxgIHu5vBAD40jI
	 RdsB/0SlY40+JF6vVdsgX7dEOQR9wDr7jILt6IjQmE3odaLYU5Y/SmrLszee7bnc8rHD+
	 dZEk+rthYG9soubfcCR0ucjSjx+EUrnsSAO3AVwCuU89ivYWfz6DB1mYGDFA5ErLvU2qx
	 kbUBBQVEAycI2TMfRqKKc9IniIGr1PwhhSR6bkFHozCJ2D/Tmr74i9d+QVTXUG261OYlu
	 J196zuC9ZP7WtbGM5MSbzGoWft1+d6HC7NmwDVTP/nX4DtZ3yTJmHcxMlyMdKD3jqkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="g7l7abw/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.21
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012021.outbound.protection.outlook.com [52.101.48.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD13606A31C;
	Wed, 11 Nov 2026 04:39:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AD13606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=g7l7abw/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mlEpkGLhJx2WmHegSP8qQiTM20eNtMgNWObbpQ172dVmzP+Yla86W3JZk8Yvpa1fwLWTWG24RahPLLko0MrURTy+ErnzV8HJ/trYRU7anmyepeuCbKWZmZ54bQrOI0dmm6GMm1LED1DC13VVAwbWCqN/HrJa9MpdHAdspl8EY3JuXjHbaeUilbxE73i7u2aAVg9PaP7zuQv888zrbt2ynBfLRT6oJtpmmwlGWEySPiJCBBtlNjipS0MQHTzNDeHTsBSTpIir9xp/fkUBCjm5V+RYA6yVwZonoMMTYWVtRx3FdGJP1tt47y7FLVz24T2bC2IjjWSspTy/lQJNFSh8gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaNeE5fMhBNC4kLC5Iqncl0C68vaDQbtYP4485AbZ/g=;
 b=OT9tcUgBlLfm8VJ8U1nIvMW+ry1Vt6EXdP1Af6f8IwmIP/IJNwK9eLAuJtsOx/6U0dhnG6vHr7JFYNd6WF8sSmAHS3hg9WlvT/PGHh7ZKXqzyxeBGTrOZtazZzGNdCpW74XzzgLxWzXlpv4JilPoHTPNrIOl+AmCQM0vXYsbG0wbDoFkDlwF/n0p2pWV6DnC09UmHP18/e5KyHjX9WmEcvVfWben3FGvlHtz+iiU0LoRzpRrsRN7DewdVgPlEU/yfQLvVI+u/EOk5akVbVyaWSHQ+QjkvOCdDoL4KGXlwbI6E3cvmTJ4/C9fgvxf62f/QokcaJkjUnCFtK+7YkyJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaNeE5fMhBNC4kLC5Iqncl0C68vaDQbtYP4485AbZ/g=;
 b=g7l7abw/M0OQQyVmbRUevYbOIdT6LE45DL98MX6ZLgnvFhNhNMSSKydJvDZle6FQ/F2MiXTlFWcwpSM6IhqSREqtd88/LYs/ODRjxkjfCwLKvOe8KntzsbDfRT/mn2jNz2Ln29xtXLWlu5pjJurBDpbXCjiB3Sxcmht4+liiOJE=
Received: from BN9PR03CA0546.namprd03.prod.outlook.com (2603:10b6:408:138::11)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Wed, 11 Nov
 2026 04:38:58 +0000
Received: from BN7PEPF00000093.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::ae) by BN9PR03CA0546.outlook.office365.com
 (2603:10b6:408:138::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Wed,
 11 Nov 2026 04:38:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN7PEPF00000093.mail.protection.outlook.com (10.167.245.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 11 Nov 2026 04:38:58 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 10 Nov
 2026 22:38:57 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 10 Nov 2026 22:38:53 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <sai.krishna.potthuri@amd.com>, <alim.akhtar@samsung.com>,
	<bvanassche@acm.org>, <beanhuo@micron.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <git@amd.com>, <michal.simek@amd.com>,
	<srinivas.goud@amd.com>, <radhey.shyam.pandey@amd.com>, Ajay Neeli
	<ajay.neeli@amd.com>
Subject: [PATCH] dt-bindings: ufs: amd,versal2-ufs: Add ref_clk clock property
Date: Wed, 11 Nov 2026 10:08:40 +0530
Message-ID: <20261111043840.906301-1-ajay.neeli@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000093:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: 24e35e30-dbd6-4436-edc3-08df3fadb39e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|56012099006|261009223027099003|11063799006|261022075727099003|261021123027099003|261021121427099003|261022105027099003|261026140227099003|261028144727099003|261102123227099003|261026121527099003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	JjsvmIn0Qnj7FT//wE13DorX4yUkgYvjZueYZJFGZOiBMAhSHRZ90A/Cyt/lb4mP03oIe+f+d6hpT4awfqk4tZ9GuaMMoZTr4GbPyluoaV9SbzeqS+Cpp6tjVQyYvCbv2HDNhLYx1gB/gJi/btMoRcZRp+L3PRjYlZbxR/3TEqd9cC2mhU7hIfSIMxzRHcr1rRPwNTJV9haBJGmtnLHD02zzPadjFKW5go/MKNzVU1KMktIK93gSOP/AvKp/1b2w800G3tpHRmCARxIlcWddTeSf1xryFGMWO2IzpZQ0CbNPH2mqIdpA942YjroP1aFYOV7nBXnZex8tq0vbwjie0Q6chvFyIaV62Uy04VjXn+4i0/L98oJCWtzF3EvOMC1UVwf4ksYNSivQbDtITXFXNtrUIQ0JtUpG7ByH4kUWvip4HKuZZVUtiX5U/bZWWUyedtszdcNW1LT9UuEuabtQ/Z56C818eRTGNRs9MD4DR6ISTiDAZ/ciFIU8IZJDCeJJ6TSZ+bhddFujjSh3M81S/mV6N4q2dx9lyiuTMybXSYzIHZvndK/+nKa/cJFl+iAKaoe8YTL6cZIBefuTYJEIQJ20aBg02N3MZU4fpajrZvZv/K1ZiDaaJmCbOetn1y9NGFOisKdj03pFe+QbpaUtTHSWlF7eBX8OR6eULQiZu6c5nU1o9X0/CFLQ39LPb2xPg828fyACztSBB0lMkwCuAQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(56012099006)(261009223027099003)(11063799006)(261022075727099003)(261021123027099003)(261021121427099003)(261022105027099003)(261026140227099003)(261028144727099003)(261102123227099003)(261026121527099003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WDNEF/CJ6W+nZusEDIjx+aytVbJP2jfC+s3RYdJlO5NFY7mWMeQGD50PTFTeqP5RGibjE/LU1yQViYMlcf9N+H6x2rNaDt8JJ8mx3R1LyU4uk6Y55EH12+sLJUVFO2nF/AwHFkSFTAaAK4Xpuuh4atmrnZOPr6XxaTncl/d4UiWc0NYk382n1NiBIXaMWIIQKSPXh20TBdflVuk4wLhv78uS4iOIIfXMiolWKiFIIzjzmPozH0CcbgZS5P2Xxj5EGczoSKXUUVk9etviksyNkFf8D0aRr0UwtBInlLgg+n3ui6cPXRD/Na1LI77Zm0uA7JnArfrF06MdSmLn0UHzJAW2WgzDv1Y62sw6vPhMfhbm/JNbqWPcde6XumJox3X80czeuykyKwDFeT4KGIneVHku2Z91mY59GXpngxbBjeRheDAGIstbpSi8MP6ittzI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 04:38:58.4896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e35e30-dbd6-4436-edc3-08df3fadb39e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000093.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520

Add ref_clk clock property to specify the reference clock frequency
supplied to the UFS device.

The AMD Versal2 UFS controller operates with a 26 MHz reference clock.
UFS 3.x devices default their bRefClkFreq attribute to 26 MHz, matching
the controller, so no explicit configuration is needed. However, UFS 4.0
and later devices default bRefClkFreq to 52 MHz, expecting a 52 MHz
reference clock. This mismatch causes timing violations and link
instability.

Adding the ref_clk property allows the UFS driver to read the actual
reference clock frequency from the devicetree and program the device
bRefClkFreq attribute accordingly during initialization.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml         | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
index c00ec342d574..e294c0f1b0ce 100644
--- a/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/amd,versal2-ufs.yaml
@@ -20,11 +20,12 @@ properties:
     maxItems: 1
 
   clocks:
-    maxItems: 1
+    maxItems: 2
 
   clock-names:
     items:
       - const: core
+      - const: ref_clk
 
   power-domains:
     maxItems: 1
@@ -52,10 +53,10 @@ examples:
     ufs@f10b0000 {
         compatible = "amd,versal2-ufs";
         reg = <0xf10b0000 0x1000>;
-        clocks = <&ufs_core_clk>;
-        clock-names = "core";
+        clocks = <&ufs_core_clk>, <&ufs_ref_clk>;
+        clock-names = "core", "ref_clk";
         resets = <&scmi_reset 4>, <&scmi_reset 35>;
         reset-names = "host", "phy";
         interrupts = <GIC_SPI 234 IRQ_TYPE_LEVEL_HIGH>;
-        freq-table-hz = <0 0>;
+        freq-table-hz = <0 0>, <26000000 26000000>;
     };
-- 
2.43.7

