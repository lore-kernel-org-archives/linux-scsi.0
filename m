Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795753628;
	b=wc0oZ91Gx59DU9ybhgGTPeoEShrF9E761OAHqZJZUrMUMzJl+fcPjiasEERjAJJn9F2L
	 fCCz6HzPK/GihgGFVHsnVo1fRx9PdTDxssBpqEVe9n0nZA+/fCmKWCJCxlPSKfGyWKlAA
	 fQ5gjYPBIeKEtpfFhuuUr9Uveqphw3yxcn0cfr6iaRZcPmgbNpthjwaTFfFjN+x8PX5X3
	 dIqDvFS2yu0xnqtDp4TtzXy0MzT0AifUIS2OOtvAoxL52MD+7CpgtKX7hmqvoCEEHblwq
	 nHiNVh+TNFr1wfm08OXN4AgfTS8VFVGbBqXN0jVRWs6dJ5RfKu9gETygT7Ty+Lmiqzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753628;
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
	bh=laIQo1T2y4hu/GA0uRuErD4fUsX75//OWsGlGhuja/c=;
	b=3zqZaYs3J5krtFqcmvNUlr/Dkus6j6lpPi0YezuUvb7n7DuuTlF1i6fGK+dlMqpPzuab
	 AArf2qtmRrjxj8idnCM75cirskg5j+KBedbbEW3JPoPuM7EBDwz3a9DlBYO2nPaSXaF6y
	 RSdgXhN/DMIVvRtF9DuTRzsic6TZrNJXYeCc/ToJru5K12V4SV8AyBwc/t96YF8TmRBOP
	 q6wkYzJn/RH+aDL1lT6rVKuTU9ef1JEdJU2Ky7vYwlrnMYUAGkDHsirkCVcN7/nxnC6Ti
	 YEdr+dgPVaB5JMvCPnTYswXT+CYm4hwAHX3BteBZXGu2PqSTAAUu23e5cii2jA2TnvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=rhI3ddWo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.49
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A43606A695;
	Fri, 27 Nov 2026 04:27:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21A43606A695
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=rhI3ddWo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZawq7LeLavcxvL1qBUAxjaQT81qiLp/RXmBqQ4J4JajvV68fLy4C2P5MQIQ2tTM70PvgBQG5RYH8bEvfMFScN7sTVQD46QuQ7Epfenj3o40IOz8qcZ+xonVIbkhBRRiGMjhgAZo4+iWA4B61IesE8g5mATBQTVXZCH+y0208ISGtWoyHoMkVovR3c2IvKfB5NsSrg9bQ5r0mNiz1f7Icj+pB2dh9iDIPf5BiDX4SrEqdQV85fJjNrZwk8KKzdeOQa96uka5/kWNYZso3Kmv10DEQ5OlmOk1tk1H2K0/xv1UVeoW9eOqAavWtL4KXqd5ARrezvTGqDJm0B2upwebAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=laIQo1T2y4hu/GA0uRuErD4fUsX75//OWsGlGhuja/c=;
 b=WZlxPBAQ6JrhFZgIc7weQDDrCVinnyhcxhcO/Gov57DLKUEaDg3Chf5c9J6nh/nH200DPNJnEVdcMBH1tEzZFtf8e5t30d77YmbEuuggcqpWotU4ePw1XFCxkwQmYL8DVLMNfAUbIWBHk/pHCKg9YzdGEc/MYDcWLA4liJlRvjAPR/DrmvFC1Q04FevXJW3VNcbumVZzsNIVjLATAQbvcaO/fXkntENq1zXnz9w6NcUnouC/uzMsFWkpo84NZo1jeIOdPmT/hnqWlDH7fnTGvSuvoBUGhtB+TdOw++p2BYoH+DxHkv1ChmVd8Tt8cAp8HSWHrtCeHsn+vUmNfMDirA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laIQo1T2y4hu/GA0uRuErD4fUsX75//OWsGlGhuja/c=;
 b=rhI3ddWoZvEb6K5X34cgAySUy18BlPM26stCDlJrR3sttOKgML/cY9U4e/5vZTvPf/wRSN3BAigCCzYgnqvAUT5Qmv698rFZA2KtkuTRbNa/ibO6bL8ZlqFWZ/62EZMCeBW90Nxw6Az+M/yoMY8VCvtGL7iWezHAUXre/2yg4Gc=
Received: from BYAPR07CA0042.namprd07.prod.outlook.com (2603:10b6:a03:12b::43)
 by MN0PR12MB6341.namprd12.prod.outlook.com (2603:10b6:208:3c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 04:27:04 +0000
Received: from CO1PEPF0001885F.namprd02.prod.outlook.com
 (2603:10b6:a03:12b:cafe::a9) by BYAPR07CA0042.outlook.office365.com
 (2603:10b6:a03:12b::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.9 via Frontend Transport; Fri, 27
 Nov 2026 04:27:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF0001885F.mail.protection.outlook.com (10.167.249.248) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 04:27:03 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 22:27:01 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 22:26:57 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <mkp@kernel.org>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <alim.akhtar@samsung.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
	<stanleyjhu@google.com>, <peter.wang@mediatek.com>,
	<can.guo@oss.qualcomm.com>, <sai.krishna.potthuri@amd.com>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v3 1/2] scsi: ufs: core: Support "ref" clock name
Date: Fri, 27 Nov 2026 09:56:48 +0530
Message-ID: <20261127042649.1449496-2-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF0001885F:EE_|MN0PR12MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: a3327646-74ac-41f2-a919-08df4c3eaff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|23010399003|10067099003|11063799006|56012099006|261009223027099003|261021121427099003|261102123227099003|261021123027099003|261026140227099003|261022105027099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lkQkmtHRio0rJkgHPxRduoxWplQFAJghbf33szJ8nDa8emnRJm1mbUtLlg6tgR7jaQDSBBEGkNFtD+up4yQSlix9xb5L86HaYeLKPEMITy+tosE8uWiHuqOibar3VCZwpLxc7oYKXX7WSpXNy7nVrzmviBHR+RrIUhyqwYqbIhpMj0TVfF72yjrvWrDrtG0JbQ4HNOr8iaN/5NzvCsDrx1ij8ECUcrjKs5lNnSBFjXdx54zfOp1hdhDA8RON5RrOalmDTWym4A4c9h/epg5MiYCDRkA/OSwUM76HDVQANoxt5wfrt7y9iIS62LHtVIIpAD7qatkyKrfFuIKZNGrW+WSFi/r+hDeWOY/Awize5xzkDwpqN2sU4vPkGwt+a5KRg6jNidjsJAaaRoSA2a0fzoZHYVnQXoF1A0akGlN8I5yhBdfALkEFBIujnlket9LUWw+sAGJxq/fR5W6FRnYz0cG5a5ukYFRvCnm55AAhcfu9sPIFasB4n35dg3k8m97CtE7y8xKtYQAQE6Paa5n8V4mskM2jtsgX6eHKfV3YvDMMU3rtI57iOzZWoCdvK6ZNrNqwGS5zjzqt+2tjLlfXtEzj3PW9UbI5VWY74FXGQ1nPjZzDzlb5ZonrRxTaiLuLfdaPZNi7gXx+3oSRvnImoBP+NP4obwvdfJtLxcXX3C0/SL/37q3GteWBSFXXGzH5Bu/rvFnwQvBbhlG42wQclw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(23010399003)(10067099003)(11063799006)(56012099006)(261009223027099003)(261021121427099003)(261102123227099003)(261021123027099003)(261026140227099003)(261022105027099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GW06kHL++ElXctwEB4cDR0FZlWRkniE4qdBKxwBEd1i1YdJ48+eMtD4SYYi8zkfBjJ/o49iH1NyUKoDkEFuGXJZUiUIbfsrfvKiQPXqUJFYVcMphY+GjVGOVY7UKbJnU6UwxMtFS7Fh64w0ZR+XjwpbtapXuEEc6SdQiNIWCDlGlOC9/i5Be+1SpedLRD7DyRQmzFypspfPHJ3QskEdBRJhEvvu/KZJE7uTe9J//BMl2PhJKpWb1kAEn6hKD4AmL/4rSPyab6/U1ohMxXXLxO9BegfQN5suf+BPZU9slUEZ9XKN0wJ7z9dKa2AC5Lmyv95oFO3+2Gv5L/tG8GLzmZ9Ref3y0M0Bjfz1UHdrjcIx72gw6/oHx0a1QEImFM9w+CZmHuadTeYh9W8LWnRZRraGklmnUEcOvHskNKKZ8L14hThYbN0eZeig/zYbOG4Wx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 04:27:03.2068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3327646-74ac-41f2-a919-08df4c3eaff1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001885F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6341

The UFS core identifies the device reference clock by the "ref_clk"
clock name when determining its frequency and whether the clock must
remain active.

Allow "ref" to identify the device reference clock in both the
freq-table-hz and operating-points-v2 paths, and when determining the
device reference clock frequency.

Retain support for "ref_clk" for compatibility with existing
devicetree bindings.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 drivers/ufs/core/ufshcd.c        |  4 ++--
 drivers/ufs/host/ufshcd-pltfrm.c |  4 ++--
 include/ufs/ufshcd.h             | 12 ++++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ee643830a57a..fcc65e30cfc7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9992,11 +9992,11 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 		}
 
 		/*
-		 * Parse device ref clk freq as per device tree "ref_clk".
+		 * Parse device ref clk freq as per device tree "ref" or "ref_clk".
 		 * Default dev_ref_clk_freq is set to REF_CLK_FREQ_INVAL
 		 * in ufshcd_alloc_host().
 		 */
-		if (!strcmp(clki->name, "ref_clk"))
+		if (ufshcd_is_ref_clk_name(clki->name))
 			ufshcd_parse_dev_ref_clk_freq(hba, clki->clk);
 
 		if (clki->max_freq) {
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 169dbc1a75fe..77ea84a28975 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -96,7 +96,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 			goto out;
 		}
 
-		if (!strcmp(name, "ref_clk"))
+		if (ufshcd_is_ref_clk_name(name))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
 				clki->min_freq, clki->max_freq, clki->name);
@@ -462,7 +462,7 @@ static int ufshcd_parse_operating_points(struct ufs_hba *hba)
 		if (!clki->name)
 			return -ENOMEM;
 
-		if (!strcmp(clk_names[i], "ref_clk"))
+		if (ufshcd_is_ref_clk_name(clk_names[i]))
 			clki->keep_link_active = true;
 
 		list_add_tail(&clki->list, &hba->clk_list_head);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index be62165b785e..1b8193de27c9 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -20,6 +20,7 @@
 #include <linux/debugfs.h>
 #include <linux/msi.h>
 #include <linux/pm_runtime.h>
+#include <linux/string.h>
 #include <linux/dma-direction.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -267,6 +268,17 @@ struct ufs_clk_info {
 	bool enabled;
 };
 
+/**
+ * ufshcd_is_ref_clk_name - check if a clock name is the device reference clock
+ * @name: clock name from devicetree
+ *
+ * Returns: true for "ref" or the legacy "ref_clk" name, false otherwise.
+ */
+static inline bool ufshcd_is_ref_clk_name(const char *name)
+{
+	return (!strcmp(name, "ref") || !strcmp(name, "ref_clk"));
+}
+
 enum ufs_notify_change_status {
 	PRE_CHANGE,
 	POST_CHANGE,
-- 
2.43.7

