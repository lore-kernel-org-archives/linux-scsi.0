Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795598652;
	b=K46t74C3Nc4A8XGRRZzxtf0bjHPBItMfOZtNh+FP9uSrxSUaFyr19jFg3pwUoIsjsOJm
	 peqdo+UFkFehrnIMkWEN6ykMWQFXic5PXRjlLkS3LqjvmskUSl/GtTHzeC1dNJ5fUVThh
	 +DLVnX3OW0YJILyZhX9oICytai9QeZMeqWWipnsRgp2zRSU24LqNvVhKIlAR6JIZzZD8X
	 nef1DgYFVmaav1fG99PUTO7h0ITAluTeTiclc+ra2s7bJQFtxOo/ajTosyBWzS65PCU1/
	 JJBKN+6g/lQxtZ46Th7BCnTLBnzBR39Wso0vtv3qS1TAdeB1IHnCKfNJE0T8NeaNAug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598652;
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
	bh=oc0pw8fHquQ2EFI2B61eyXHUbNkH/0MMNrT91XYIVk8=;
	b=DLbeSIrKGYO++QVeioi06L+EI4WSEmls8ymXrC6By22NiemNHPuSyql7zyVAhOXudyID
	 G9Jl+nq4GfzzzTG9aSqjxyXm1ezHyvJ1lndJ0qO0/0jn6ZYzHUkr8VOVgBzqphJ7mJViH
	 VKN7y4/Hxjwxmd+4N4U3dL5ULo7XtoCp6Bf0+/19BROSBXiTMcJM74XfzguCkAMRIVcr/
	 JIxoA+NgHTM7znnm0/GEsZhijQwmMjqOj05DQynRj5Rj9vyWGLtY6d62Q5pFaSipO7pSY
	 8vk8+HTaUx9SqYD8jyoa/IpXI/ZwYHpw+1YCXrTG3YJZlAGcRjvFRai4Wlc7WhUZ/RQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=14GvkXMS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.47
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FB4606A337;
	Wed, 25 Nov 2026 09:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1FB4606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=14GvkXMS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEKp/e6O5Lo5M8HjfjgaxXVfb5fUU1wEkiAWOKNPRvvir60O6s37FIvaWrrLOm/swpDE2sPr047VHAvCrABjOttgW3FJJ2KnC3ZlPt8T89GYXDH7QHPjR81brJU/Vwll+ir7iQilR/rU3I6g1IyOs8U+Mxb6AIJX5Hl9wwfKeZHj4D3oZdts2jRY8+ncaag8NwsNH8MU33A7A1LInGt1wGFBwwsd2fFdHP0YzHJCL5rXf1ioHtKKHyUIPKabByVQJn6bMzeSU/Ncx7290Ikv+GnXSXLyXeVFZ/mBFXAvdz9b0MXLTuREoWZP+J3jcI2cf8vCECAhR1u8w7rELCAMUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc0pw8fHquQ2EFI2B61eyXHUbNkH/0MMNrT91XYIVk8=;
 b=dZkVUN4q4Yryoj4xQrNybi+iUdi51Su+ks4qUOzDY0whERio2WmbnWNei7Xz8BsV7E+48mbGJIVS39p2LaCwmjaMUklEkLe++Eixtq9mz0VB0Tg4NzZY4q5j0kHVzgtjDBxKcx6ECxktpoMJsBkY9MDZbYykTYgznJuoJAZv176oa955FHwc05+fe/EgpWv9LqDUZj/pSJZfH93ABCTtA0ApU1GNGYVPx0yjw+icVpL7+IW92hB+F6FjhgLc3RwhN7F7JPeG5cXRuAqUVkk7JFU82JXvSdFJ2bXPXgURxguWeFg4Sdev1Lb6ryzwi6dAXdNEkCy7XsRlA6S2vgxaMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=hansenpartnership.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc0pw8fHquQ2EFI2B61eyXHUbNkH/0MMNrT91XYIVk8=;
 b=14GvkXMS5ev8SgVE3zjJHMSifOPSL+JC9s2R9ybJhBq14i8fSaGOLlIGrjlTgHerbUAEQ1OceLkt7L3ILQRNAVIgOPbIVYmRpYUfxi1eWVtc97HOtCzLpiIxiA6/eRsecwFHDPfx7tPsJ9fGVCEUFOlParSB9G2r0g4N54BGHPU=
Received: from SJ0PR13CA0219.namprd13.prod.outlook.com (2603:10b6:a03:2c1::14)
 by SA1PR12MB7040.namprd12.prod.outlook.com (2603:10b6:806:24f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.5; Wed, 25 Nov
 2026 09:24:06 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::b) by SJ0PR13CA0219.outlook.office365.com
 (2603:10b6:a03:2c1::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.6 via Frontend Transport; Wed, 25
 Nov 2026 09:24:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 09:24:05 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:24:05 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:24:04 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 03:23:59 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <James.Bottomley@HansenPartnership.com>, <mkp@kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <sai.krishna.potthuri@amd.com>, <alim.akhtar@samsung.com>,
	<can.guo@oss.qualcomm.com>, <geert+renesas@glider.be>, <mani@kernel.org>,
	<bvanassche@acm.org>, <beanhuo@micron.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <git@amd.com>, <michal.simek@amd.com>,
	<srinivas.goud@amd.com>, <radhey.shyam.pandey@amd.com>, Ajay Neeli
	<ajay.neeli@amd.com>
Subject: [PATCH v2 1/2] scsi: ufs: core: Support "ref" clock name
Date: Wed, 25 Nov 2026 14:53:50 +0530
Message-ID: <20261125092351.2807658-2-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|SA1PR12MB7040:EE_
X-MS-Office365-Filtering-Correlation-Id: 05a9c81d-b0f2-4591-1b54-08df4ad5da2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|23010399003|36860700016|18002099003|22082099003|261009223027099003|56012099006|11063799006|261028144727099003|261102123227099003|261026140227099003|261022105027099003|261021123027099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	AlFfXfi18WPaY8RZZkzbZUGuXJuEPuUFl8yf+FOo7gcqonmFY4fTl3MmbsKQZGLyVttMF0Y46GwjwIsp/ukVCrcSgjBbuQ2gOkeaQL0dozhdg/haHhykqLCy7piqA4QXW4aNBhDm/HI3bvunC1YUZFtRMruyEG5jeZsAlMGZrmIYj0GKhP7j24tft6XVjjRcAwncbI1EG5GSGXDIgA+e0O0qJ7kgk/K92v433Vb2QsxKBkA9PXOahslc+wSg/w5EWD+nxo62KOX21YadEkzNtAxSKKaFfGkcHKyUptX5pDZmMe/5fM3n8l1v1o0SqHAvEW99HRe2RLCMa09DgEXSmbCMeW8ecDey0X7fsIMtW9c3x/UQOruwy6tXfl9o+BP2KfVwLWHkRpt7st5N8aX9ssQ4zSHNBcvGjv1dpKA4yeySsPZLAQetSaWhnT6yJIjUmn9OxdwUCU9hgiIvQ3UPze/3venWRRMINHV5cgF+0x3O1Wk+yAoGWVaZd6b4D0x2DEH/MkvEBKCNUv8rDss4A81r995TYkqBepWkgWQenPqlq17jzdDsHUuTUw8ZYfjCNJS/WtnKXr1u8iua0JQhiYTj+w0zEAk0JKkAWGiXCtDqP+izMKbeOzwUFcfaV9bjajP0b8MgmeTsV86kntYn0wXyaWzeZX/ugLYHu474dkX6ljzCc1wYdrmG464+CCiNNpUfrMNfgAIQwXYRhjSWFQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(23010399003)(36860700016)(18002099003)(22082099003)(261009223027099003)(56012099006)(11063799006)(261028144727099003)(261102123227099003)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oIsp2qLIYU000csmNogYvzEj7k0nxHbkeGMbMCH4a3DVytrRb2MtQckXGs6P/iKQjTDnAZZlzoM+HQgVV1p461XHTnu5kYqN6hERM1kTbR1eHXZoJo4ND/9H/hpp3Dto7Zp0DV/B+Mrkgt9fCCheBx9fXsMz9l1b3xbWoe6FjBbl+3I85FFYAlXMmlV46kBuu4xGQeCMwl7F2k/3W9TgHkX6TYjvL3Z5NZOgAMpQkulOfPkkNO2cN6GWVAgnXaJY3yEDkZOOu9akjDpxzVMRHD03X8z3TJ/mkFC7qNgvzmcWo4c4f0j8R2HTsvKR6joHyM/aakyu8efdMZHF+8B5lQ/9NegOfK/KXBaNbyHhgx3X/Ek88y++3TUWW1A8J+7LTOj6JMHZOBXGOfPvVEMmhMwV0ZkLMf0FWlKH0oI2w8zaN+XWLXrkJDxaPrAr4z5T
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 09:24:05.7588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05a9c81d-b0f2-4591-1b54-08df4ad5da2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7040

The UFS platform code identifies the reference clock by the "ref_clk"
clock name and marks it to keep the link active.

Allow "ref" to be used as the reference clock name, while retaining
support for "ref_clk" for compatibility with existing devicetree
bindings.

Signed-off-by: Ajay Neeli <ajay.neeli@amd.com>
---
 drivers/ufs/host/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 169dbc1a75fe..947edcd88668 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -96,7 +96,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 			goto out;
 		}
 
-		if (!strcmp(name, "ref_clk"))
+		if (!strcmp(name, "ref") || !strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
 				clki->min_freq, clki->max_freq, clki->name);
-- 
2.43.7

