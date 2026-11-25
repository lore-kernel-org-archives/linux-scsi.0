Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795598657;
	b=C93+xznrz/V/f3TZkFOBkgV0Ac4FQZFbI+VKdl5T9MK0jS5C89+UQTtmWs7KPYbwnfwQ
	 J0+rSNZ8ZkFnAIVybgiOBJRtuI+IGhtlGyDMvTFRiyjN53teSlqZiP15d6DbEhUxpM5RS
	 0FxePWJKsDHQmcKaA1dJHgMlk8i3AmeInr/YIilux/MYViE5T2NZOlW4P3dPVL203ofsL
	 NdSVZ1Zz+si/dv6gi6VBfBSosfoc+zO+G7kU8bRAVAVw/qfiX4idO06//pGddHbTNbvd7
	 k2n7cfwRCW6Y7SHDH8b3vErAyaOdzMrO34ej9okXtRLKLJu6YJ4V7XxT8MkPP637TTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598657;
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
	bh=h2dI6YnSF0pjjCEjvGz50pXHM9Df0o7ydu/8Yi1+DPA=;
	b=EwHSrQOeI8oaikNRtbEAd7gjDS8F+LF66IaaxMRVJYh+8kemWxltUQbwa6OuDO+1KHk5
	 Rk4j+PoYUrY2O2S0nFJ3qesWlRVsjjVL5gpoS73nDnqihbTb2RstAXW2vEi7tv7BlYY7V
	 CIVd9Gtnk8aIRU1enx0pmmGE8JPJMdoKHxcmBbR+7Bw7AsP33tz08UOiE9xF3iJg3s9Ib
	 RbbVeUL6xb2qGbP7KKhGCGV9MVnD78RP3OHImUUk3D5jYHK39/t7ULNoAzF5Ky3ttcVsh
	 rFWHvEgbCxhXsSFbr6yhh863RDFE6hRSy0szR/2r5idB/1x+zY09V2Rwe7jX2BKfzFA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Cjld4P6V;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.56
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A2606A33F;
	Wed, 25 Nov 2026 09:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC0A2606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Cjld4P6V
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kVYrLP5BIIG/LeR4FANDZCirp7zBVQLDqOxVG5s64eFCYqW4uYjvW9X9bCoC7gTLAF8M+lE+p7CvX2M8cnDjmVSyXPu2PXlkwn7EoW0014yWK4syILZjVWG3jxcizj2h3ozvB/wIKZyD86khNx1UumDkoVvgvAmoltXWKzZ5WE4cj/EbAnb2l/sNHPZL/BEVBiaPUcDVat5xcfpTaYoBtcaYH88KCCKzHWqMCXD0qWLmROPnCiCngisA3Z3eyXkjclTLrAaMr0OJi+WJ3iEomGHpZNULE6pk5GD8ap1hrmDvTRnDbohxKv7iocqDQAoc3hjdXxdrgO498Y4rhxQOPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2dI6YnSF0pjjCEjvGz50pXHM9Df0o7ydu/8Yi1+DPA=;
 b=f8JekeBddYgkAlMHqXfkNfb6XU8A50K7+r2fqtBsJFmFUq7NY8yjqjzVAQeabtLlnGtcVe2EGekpAWq16zTsCrXYy3lSMouoigeM0DEIWxG5O01H8kyKEcJJYFlfZaSXTUAFp5k3y0BQIveMN6dSe4VRhinryQBz//YJlQEgcr3ATyFBojc+tujW6It+HKHLyGvHNSGBJsFaqUNYzx4nlXeMtsCflAk7pnKz+Zw6PtkfyNjMQNb3kKqkY70KyvsttM0KRGGCbH1F3fAHNCS+elxaqx3fq8ntLFOsTNfuEWHLK2YbWUzYqdoDqNoB0ECA6mh8ba1gxR1lsutNjsZOkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=hansenpartnership.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2dI6YnSF0pjjCEjvGz50pXHM9Df0o7ydu/8Yi1+DPA=;
 b=Cjld4P6VdDJ/sboIswmGKDl4mhEeCShC4Loq5ygysCFIo4j272IZNgWeGF/VPt36WDK6Lh5w+YsJ5GHP2cOv8RGdenopjAkEL9kVb17o67GWS59rVX51x6oGTitihg4A3ej8p2fidYnJpSlycCuFZlil3U5gS8QN/f02XepiKhw=
Received: from MW4PR04CA0256.namprd04.prod.outlook.com (2603:10b6:303:88::21)
 by PH7PR12MB7820.namprd12.prod.outlook.com (2603:10b6:510:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 09:24:01 +0000
Received: from BY1PEPF00026959.namprd05.prod.outlook.com
 (2603:10b6:303:88:cafe::5a) by MW4PR04CA0256.outlook.office365.com
 (2603:10b6:303:88::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 09:24:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF00026959.mail.protection.outlook.com (10.167.244.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 09:24:00 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 03:23:59 -0600
Received: from xhdsivadur40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 03:23:54 -0600
From: Ajay Neeli <ajay.neeli@amd.com>
To: <James.Bottomley@HansenPartnership.com>, <mkp@kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: <sai.krishna.potthuri@amd.com>, <alim.akhtar@samsung.com>,
	<can.guo@oss.qualcomm.com>, <geert+renesas@glider.be>, <mani@kernel.org>,
	<bvanassche@acm.org>, <beanhuo@micron.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <git@amd.com>, <michal.simek@amd.com>,
	<srinivas.goud@amd.com>, <radhey.shyam.pandey@amd.com>, Ajay Neeli
	<ajay.neeli@amd.com>
Subject: [PATCH v2 0/2] UFS: Add reference clock support for AMD Versal2
Date: Wed, 25 Nov 2026 14:53:49 +0530
Message-ID: <20261125092351.2807658-1-ajay.neeli@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF00026959:EE_|PH7PR12MB7820:EE_
X-MS-Office365-Filtering-Correlation-Id: 555d54af-d8f9-439f-01c9-08df4ad5d701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|18002099003|261009223027099003|13003099007|261021121427099003|261021123027099003|261102123227099003|261022105027099003|261026140227099003|261022075727099003|261028144727099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	o4129kcIwVwSnlG+cfZDLvRobmgvjpI0V44G2Yqq7KmNEldrZxtx+qAuw1XVdp8v0epGQw7n7aF1ASXJraKGXFwZg88uyT8rQJywoIqSdqk7bMj+SnZpOftcUKlQrASHOf4G4Kp5tRH2bwDxwloORvTVowygHw1h/eGZ/AFrld2UwR2X4wlQbmbUrQkskLNkg6AlPIEEZ03NXeMMqWT9PczZbyJFAKs0IM7QicY2OX5ZwAYrYG85SIrJFoJMmaaP2QTz3AthMrYxUfmVb94HQ7Q+yurREYCN9v2lyTqW8bIdZlkxXlBhLKxv66iWjC6nfIfbAn9n+Xqz11FSHoZ9nex407OEPfTFWtDBbFLgICXSpUlsuLzTR8n9LNUn5kHK+awNljxXvfTWG0AAJ085s2e9cODs9ZYcsu1oydwsepWWzZfPVdy3w7jC5lt6VbTeryL4XAxpgY7d1E9pe+/voPajWajU+7nPhcckEpEVkuWe8kX4p190ribYl52dScOd4vdit6J9K/oSG4KZUx6yyiJ899nvDg3tqvRUoNmpAIBSn0G7BuPtlvoB94RwOW+ckSLa8Hz3jMnOMzlIe7r0OGOAmEE/zoTLRdOGmUZ7ryMG2uCeB4fW960ViwLibX8oCjC3jVBr5XFE01c+tzmqCnYRjrAH1t9jS9V070Y/dE0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(18002099003)(261009223027099003)(13003099007)(261021121427099003)(261021123027099003)(261102123227099003)(261022105027099003)(261026140227099003)(261022075727099003)(261028144727099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A4S3v0Bbry73nepaxVXchuRxlfeCvZHqc8wLmPfN+QhcByl3BE2P9GEfidBTiGSmFmWmVHUBQpilGT2X2XvYqudsNHhL5chy29/HsZrEQNJxTE7EHSD3IYWbi0D4S5uOH4G/4aocx4fnicQ6CMrj5CaH9tT3YJBLt2J8Ho6Zguu+mwA+OKU52eOMIpGqLssQ3Zm/kOcZUra3g7qW0p0Zi+GPsmA2+mpjhWdiMMdOEibV72jwmxUEOK+ak7JewHkKBySdOeE6hcq8G0U7IyARGEa2e28zeOqSQo3L72tqkKr5JIVayCl4u3o9EW7o9VXinJ5oce844PxheSxNPSrl/rlI/5P9EHj779QpEY5OOkaJF/BNG3FzJOWyqtAadzDxSeSFtWwdZJEEF16tYXU6ew0fvp68DP2EZBA++5cjpEhVlDPz2dWSx50v7HOZ/HcM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 09:24:00.4276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 555d54af-d8f9-439f-01c9-08df4ad5d701
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026959.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7820

This series adds reference clock support for AMD Versal2 UFS.

The first patch updates the common UFS platform code to recognize "ref"
as the reference clock name while retaining support for "ref_clk" for
existing devicetree users.

The second patch adds the reference clock to the AMD Versal2 UFS
devicetree binding.

Link: https://lore.kernel.org/all/20261111043840.906301-1-ajay.neeli@amd.com/

---
Changes in v2:
- Add descriptions for individual clocks.
- Use "ref" instead of "ref_clk" for the AMD binding.
- Update the common UFS platform code to support "ref" while retaining
  compatibility with existing "ref_clk" users.
---

Ajay Neeli (2):
  scsi: ufs: core: Support "ref" clock name
  dt-bindings: ufs: amd,versal2-ufs: Add reference clock

 .../devicetree/bindings/ufs/amd,versal2-ufs.yaml      | 11 +++++++----
 drivers/ufs/host/ufshcd-pltfrm.c                      |  2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.43.7

