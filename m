Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795753622;
	b=q7EZ9ZlMcVyBPL5wkPjTz/rZKnos30MnqFdqX9tCnwdtEy1hxP6u/2n8191XPwwUunRw
	 K6CWROfPEDvsLEMcBZd/EwycW4oYG0PqnjNk/HUZDhCiguQwlS4cf4cxGGLMODz+zxROI
	 gXirhZEzRd+fTap1Fb3z6ZqjLB/L0ICKX4LwxCfMp/Dz0ECrwbyzyBbhcogB6F1yMXGEM
	 MG7eF8VReDtYoPhKC6wPVfFRi60mrPTOGTrlnK84dO25cX2mV7Uttq0Pq4nwPgHy0Wx1T
	 tmLY6Gk2BU4HRRRB7Qm+A8WmnVC4EUeqGwT12vKoM+8kh4513h+i00RJCs+/4ejR+rA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795753622;
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
	bh=4WV2mTap6piHsQN9M+ehZ4GrK7s7qKSenHHUsHABJdg=;
	b=zrFiv4Q9aEvIAxj/upnj/KAU+p2u3mZNOGTl/6Hhmb1rpU1G+geNquQ+Y5KwUOG6+dKq
	 2300Xt3NpifdePQAJ6FXhV3Wy+et+RTNzM0MOihWld3BqIwdnU7GjbCtKAYZy+RJxsWnU
	 3mFeY4VCc6VrBzaJ1B3Z8Qf06sGwCjM1t+8L6PLeXalxO3byNlhnKdwfs+c0FY4sTsJ2c
	 hkBxP2xhxjyfHEoP5mLNurfIZ+1VZBvUyY9SxvGy1QDvilEYSYXCp614ZF02WI3hcWDJl
	 +tPiN3KFLIq5TubswdSxDdyfdueGSbYi5OWb+VsZmczSrTD+wOEIIDUmJegyBkW3Eyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LNq6mEf4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.43
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010043.outbound.protection.outlook.com [40.93.198.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26429606A329;
	Fri, 27 Nov 2026 04:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26429606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=LNq6mEf4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j9xtYsWVtEOP3aY1ChvZ2I5N7fa+DR6RT7hnNMXY0eCIkkm1prdwci/hXKoQCUhiY89XtRIi7JZ0JhpRd0QTkOC6m9tti9LfjfxIQ9aGrvqspQz0XGnzx8ueBe9eO1/WQUXzY/FMpKED14OSdoJHyH/PX8C+ABT/p6FJuWgHpayELrpkkt2StRDKYS+mcgasJC1c2YH8lHVG+i8D5j7IEZlCpuYv+A9bHijYpn7iPbw2Fjvu+7Ni55jGYYY1dJ3CXYVcb+C+zZ4xUNm9rMDJJSuQTZSaZoRhbUcxquHZZ8NCgvoZBx1l30nM3fneQ5X1dwT0qeCHig8E8mWyK+/rwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WV2mTap6piHsQN9M+ehZ4GrK7s7qKSenHHUsHABJdg=;
 b=Cxd1AD2NVZa11WvCnDuza6c3OuQufdoztbOgHN1hLEqd0xcTenbEa2ayASTfrLMhVXj0ksr9l9PWZO09KEXvirN6rTA/Ix41fI1c7VX5n4iGTe6QwkM1lzu05Oza8LNZJcmDceAaZUtR7C36Bo8rPBeSWcLEdmGiH2A/kWOYhoy88Wkht6OY6W2nqLvgkyHLMsy+awevMpTaX3Zg/0IuE8jmXbbC1e8bEzc4EntmzMuiZZo9ePK4H8VB9RRE7j+WuiPkCrLjKg5WC0V35B0YRYaDbAS9PrMJxmQ8+GHwteyeoZcutP5Yvz4g4k8s3cHycgx5tJ+oauBHGtZGGG5AxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WV2mTap6piHsQN9M+ehZ4GrK7s7qKSenHHUsHABJdg=;
 b=LNq6mEf4ox0kiQON0gZ2ojkyMixDaOAv2nc2shza+4aU3rcRVh56JEi+9FTwxHeqZL7Fmi9i+PhXJPilyH9gfoEGTvYNAAF+bxmMRbsM85Qmm9aLnVTDTPfw3+XJ+qIHhLt91ghE2Uqg/34A4xYi/WpFAgASuAiY5MnocnwmyaM=
Received: from MW4PR04CA0034.namprd04.prod.outlook.com (2603:10b6:303:6a::9)
 by PH7PR12MB8594.namprd12.prod.outlook.com (2603:10b6:510:1b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 04:26:58 +0000
Received: from CO1PEPF0001885D.namprd02.prod.outlook.com
 (2603:10b6:303:6a:cafe::a9) by MW4PR04CA0034.outlook.office365.com
 (2603:10b6:303:6a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.9 via Frontend Transport; Fri, 27
 Nov 2026 04:26:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF0001885D.mail.protection.outlook.com (10.167.249.246) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 04:26:57 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 22:26:56 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 22:26:51 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <mkp@kernel.org>, <James.Bottomley@HansenPartnership.com>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <alim.akhtar@samsung.com>, <bvanassche@acm.org>, <beanhuo@micron.com>,
	<stanleyjhu@google.com>, <peter.wang@mediatek.com>,
	<can.guo@oss.qualcomm.com>, <sai.krishna.potthuri@amd.com>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>, <git@amd.com>,
	<michal.simek@amd.com>, <srinivas.goud@amd.com>,
	<radhey.shyam.pandey@amd.com>, Ajay Neeli <ajay.neeli@amd.com>
Subject: [PATCH v3 0/2] UFS: Add reference clock support for AMD Versal2
Date: Fri, 27 Nov 2026 09:56:47 +0530
Message-ID: <20261127042649.1449496-1-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF0001885D:EE_|PH7PR12MB8594:EE_
X-MS-Office365-Filtering-Correlation-Id: 8058bd8b-a29c-4b9c-8723-08df4c3eaccc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|7416014|18002099003|13003099007|10067099003|11063799006|56012099006|261026140227099003|261028144727099003|261021123027099003|261022075727099003|261022105027099003|261021121427099003|261009223027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	103graP+W2lq+GVVD0bIzmt61+R2TGNp4uQHsxtHcJu89yH3VkjxLgme6YqDFtIft+wGBQQ+LlfnOPrNVo/qeb32q0mTCAC3dbp2FvpoK6yNQrTItWdT8DLKvZTaVVQsRJmVnK5JQ4tGAk4//d9rwDDw7fI6FGo3zUI1KYb5gra6XDzM4JQK8UB4zQh/iBfqKlwhzazoGddBaicxieYEX850kB/essJd8XkeZXwbbP1JzAv5Kix7k8mGr8fHnRiRgsehBOzaeEJ3mIYFE56NAI8SthzHIXHu/vjTLBs/8mbI9rViHR2ZhHwNZngzsTDjHkf1OJthAyKRSVTOtakHmAzyhfOZrZwbs4ha/WlfBOyDEGPKzekfA4gOekYUqGODdb40gWN98u6yWEYOyW84tX2iLLqsjbvi6QYF2bOhQxnjcR2uQtm13QGRTmqc6S+n8KR0s2oGS4VqvLZElJIb0emJE6WbSMVzcVSMgvA2zTWVIhkXuT6IaHAi0XjaY/cWwYNsw4jLVbBz0c5ja+1PPW9BA3TyLEOim2jIONtBDe3Va2NzA55P8o2onyCHzl4NaaQkCu4zFnbL7AgR9/ZsuZtNCi63oyJ1ulnuRjMaQnRsQzsLDCwlUQ4o50vUlr91G21aPENpp8bCURtheUKGzw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(7416014)(18002099003)(13003099007)(10067099003)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261021123027099003)(261022075727099003)(261022105027099003)(261021121427099003)(261009223027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	M7ouK0/8+Y/SuOzuBKr6ygwBfvw0owhXogJs3zG7sp5OejbLGriiDJjmyS9zVXj1IWE4aV2AjRq1QTd09DbUZQdoJVfPb6o0H3mhkK96e1Ht2wVwoyyf7h78xKL75E8zttsIBhewFel/mIU1Zec0uvC4fAxsJUlDpDpeHN/8QkrqImdiwfCK5GvzrqZ1FeZiZbcC9YcBj0m69Ja5bhy4Um35uBX4qe3KwNmrW1RCA5h7sZ0fABUQuD5TSZmZz6kGtVZj3lfszb2+rSuQ2EkmxP5tVpGN5VxEeEkwQ6ptfvj0VBdVS/LUpAHK85FzOyXFQFT9Q97rsTbXSziwjStPfYqCFEu6ldsDMOVp71jqX5FBjzN2nsQX7CrilIVZ60DDrYX1CTPIQ0vTsehrJc9UytpizFtMWpaQgd19gv7zI0L2IQUeZ4YutyCeZ3XhjfH6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 04:26:57.9294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8058bd8b-a29c-4b9c-8723-08df4c3eaccc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001885D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8594

This series adds reference clock support for AMD Versal2 UFS.

The first patch updates the common UFS code to recognize "ref" as the
reference clock name while retaining support for "ref_clk" for existing
devicetree users.

The second patch adds the optional reference clock to the AMD Versal2
UFS devicetree binding.

---
Changes in v3:
- Add a helper for the "ref"/"ref_clk" name check and use it in all
  places that handle the reference clock.
- Keep the reference clock optional (minItems: 1) so that existing
  single-clock devicetrees continue to validate.
- Link to v2: https://lore.kernel.org/all/20261125092351.2807658-1-ajay.neeli@amd.com

Changes in v2:
- Add descriptions for individual clocks.
- Use "ref" instead of "ref_clk" for the AMD binding.
- Update the common UFS platform code to support "ref" while retaining
  compatibility with existing "ref_clk" users.
- Link to v1: https://lore.kernel.org/all/20261111043840.906301-1-ajay.neeli@amd.com/
---

Ajay Neeli (2):
  scsi: ufs: core: Support "ref" clock name
  dt-bindings: ufs: amd,versal2-ufs: Add reference clock

 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml    | 13 +++++++++----
 drivers/ufs/core/ufshcd.c                           |  4 ++--
 drivers/ufs/host/ufshcd-pltfrm.c                    |  4 ++--
 include/ufs/ufshcd.h                                | 12 ++++++++++++
 4 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.43.7

