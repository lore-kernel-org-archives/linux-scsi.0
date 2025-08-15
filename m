Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013047.outbound.protection.outlook.com [40.107.44.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FE9303C82;
	Fri, 15 Aug 2025 12:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260203; cv=fail; b=n3ZSX/wHTSG9lbMHtlr8nGPX/oezruDKVcbfR4woj4Tmndvjlz76o0l1e4tleWlEGDl58FNAUK2sWcGPzyIlEF9fxp2Dfqn3lnWc4V3t3xt1Q1LD923sVqbhAMXcpCNfyczHcGlzSROZZUwcYo52ib/lc7B7Im1YUN+dX/gXVc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260203; c=relaxed/simple;
	bh=xX7Rc8gr5iJiLt8mWA+H8cyioxWg/deX486ngbF3j3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iYvi3IMYakm6iZ88YUt5d51kDVJ9GbgG3hEdQ77vuO+ZLqHsUwUzpPLqAHtcrV6usDg+63OxH2g0UvcdvvQOThfBIrjJKGVq/a0HjHFiHPGqoheiqDWAmuwuHjnyUY2EWEAeVAvrPkjTlawjRQq6ghSanI0+54IiESTEDH3VXUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=UkzdLYv6; arc=fail smtp.client-ip=40.107.44.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="UkzdLYv6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCVoMoxW8y04SksMFMN2u7VyaUj0XEzT+5git665PaZKxEI43UZDwpDs4v7C1ogYRX9rgwr5Ru0t18Ew5eHIYzaofgG1yVKXlcQaTHCii/Vn6S6h7jUgpRlW01qknYQHLT426BPbp8rJhiRQL590ag2DPkzcuQe4++8Wi1qv/EsPWXCBsk661mESs0/Y1XYQoD6TsmgiYdlRP7YDzcmcXrRIXKxxgZKTtTrjichhhktkIOa25v3anQdh9x37CVmbnO43i0+CDE3vFWjTO+5NCsirVqO4d/W/Bi55CYidy0EeynKyzGhyb2gVivUsdmRLu+he32DALK6TfqHBQrUk8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbVvJY/r0UpmxKloU+ya0UHzxCjJRn5+ldmbh+2r8yg=;
 b=CfcN8EWy8aYTeq3OdoW+SxMtv+UesQgEMq8DyCCRxwhvJFccUqDgtt9TG6b9Y143DPxfccEXSPRIwypzwHDfpKhZRt1JCK0PSUogyzq45CpyLB7G2vZLcgt/zfg02M2wjC8N+ITDHAp0qu5fbZHvqIU46hGimsy8SP2T/+e/o/oC+6OtYrGhh/D4aUnv7JjdaMVlkjbLZeTub1Gtot2oKN2wmJnyzTxCtWL52I2EphgVF3M+4LWdNXWi+Eqdht+6SLI1hPTpig1DJZMuBaEWp71kfqXqfrAH7brtZvlMpzFs+MFjSCbCxxjuODZo2QDdqLDcmY/IhmPIk4nEnnGbwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbVvJY/r0UpmxKloU+ya0UHzxCjJRn5+ldmbh+2r8yg=;
 b=UkzdLYv63iLPRw9GrB6OouKzs9Wa+lkY1N6jcE4Rr209z8GNvwnghZYiXifWaEaMFHtwR0e+0B3N8Cd+AvW6xBoyOkxjYT4AJFAsxyOiB6SzndBM8718/0FkfseSmaHBqK86CuMaICa004OvWyAUTy6MD4udXlTGtobb2Eks+Lok1zEOAZt4TaBVrxNXggErbrpC0rGtKUX796fTZSHiBnGwBo2dFLDRLEuwVtFBjX4KP2113W9HuyOv14d3W+3b0uW24g9rdvdHlnPkZBsEaByjR4ZyoxlmUXcr/dmABaIN4POS+V2tUgpBHPzeUhRdK/GbnZ5NEUD0A2dWctfOhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:39 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:39 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 6/6] scsi: qla2xxx: use min() to improve code
Date: Fri, 15 Aug 2025 20:16:08 +0800
Message-Id: <20250815121609.384914-7-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250815121609.384914-1-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0196.jpnprd01.prod.outlook.com
 (2603:1096:404:29::16) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 01664715-a6b3-488e-cde8-08dddbf5961d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ernj2l3S9oJRKMT273tKuby1SxXrF4slLEraYYoHuRYwdx3OSCcqFZuuIBJa?=
 =?us-ascii?Q?cvloAt5ObhGXfMZwH5fMCStjSJ1wBDN7FembXLyNz+bt1+zhQCKNaP6SjE3+?=
 =?us-ascii?Q?CmMsXXzhGYcJQRuBOhPcks7yJcB6ea99bdJ35IkQ7f5Ez9gMj/41XOEgdk2u?=
 =?us-ascii?Q?P2/aVYJPUw4ZrGJ3GZB9N5IWAVGS/8juTMNJJojtxtq84Hu/RmmIyMWda03G?=
 =?us-ascii?Q?23K1RF29QcdJ4U+NSFjK0llaBGYuKvOwMQlDnJ2LB2uBLJ4q1q4ZfhGjPJ99?=
 =?us-ascii?Q?eyBsCZoKbqUqecfwSt5RAZ4luMKyiQjiwHmmTbtfaXcIN60steXVhix2vSvl?=
 =?us-ascii?Q?rQDcMiuLEz7Bz+FmdUTXvhQa+MH75PmcjpaGXCQapemklbVS6E4NEmg1sU73?=
 =?us-ascii?Q?21cF7tS4rqe+pAqpZXc5CZt7W1AwCW9Rpzxyb6hhcA1uZ3eTh2IcOWx7JU0/?=
 =?us-ascii?Q?0WmIQZw+2lJYE0W0TL0lOqTtAju5eOC8p5bT6Ae4+qrZOCyl+51yE4Zyc1Ui?=
 =?us-ascii?Q?ftZG+hZhHNmRI/v+rxF0C1cRabQwrwfU5j16bxO/0LUMOCoUlpP65R5/f7S8?=
 =?us-ascii?Q?E9wiqTMJRw+6IH1uf2l7x6eJKAa0fPrgBM9eyF7wgC5KwtQqwJ6DDg4ep2Pm?=
 =?us-ascii?Q?sx77Jg/HCiIttXGyWvp+9pRIjBEpMm6KyZM88zSuu72ySItcr/n3+FHrhvbC?=
 =?us-ascii?Q?s3gOksGas2nrSwyoJYQ93u0HA13BTqk7dyedvdVVHdM2X0rSLo0WdoRhQ01p?=
 =?us-ascii?Q?00y2mJVS2eC93QDJ7ChDoRc0swTSR1NvRqnfymrZBdqrN01+LVjQc03MNVja?=
 =?us-ascii?Q?XtRtAID4j4ER7gyPvjMk0+A/ii7C86G5BHLsLrLxawn27N/kZ/53SP+FKuUS?=
 =?us-ascii?Q?rjwdwrlucTX8X2uRtctuGBChsCeORVHJRT52CRu/ciwF/nJowr0jW7vyxeRS?=
 =?us-ascii?Q?rt07CSO13N+fX2kVb0u5beeMR3dfHjNC2nuroPXXvgXqrxN5nGt+5rouzFIp?=
 =?us-ascii?Q?iwp2mtDGm1dUnQ3OV69iFufv7BixG/TSGMLEc7PkoCPe0bVBe/En1Bu2fSKX?=
 =?us-ascii?Q?Fww4eYVcfhsoGyP9bvRfKEB/C6m+XZeMVuxBaKOP+TinC7jmNu2T78aigI3f?=
 =?us-ascii?Q?tXsbNL0PcmQaLe0gPtWZWx1A2eMyJZGSbQTkgM9QUDRWv6grufbcAd45ZDZZ?=
 =?us-ascii?Q?PJJttPkbrI3WYIkNXMQc2JFpIu7TNahefQo6w1aBeHgim+0VTVsNhbKUZnUP?=
 =?us-ascii?Q?vCTfwtCCNHcpYWlbCK194f1ZuMOIBo7zPLP73z3tq+TY4lWlh7m1gPj8VuoB?=
 =?us-ascii?Q?p86uV+3pgoCdsqp9pQ7Gs4/73foa8HCEwH6v2l2D/b4fUJMFC95WDSGeooDf?=
 =?us-ascii?Q?3MJXDKV7lRj/QYEDGlWSnFBA8QHpN/iS1ND136T2xNEIXyLRvjJlD1Rt/R1Y?=
 =?us-ascii?Q?bD2gBk6j9E92o5dR+9No5iQP0hDPYJpoQ0HH7GiCHauiGLLtObVSNA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SpfR7KlF/Up5/hUwc8lp0Ova8rATdRhyPRIQbQQcvqAhny3l90/azeoYS06B?=
 =?us-ascii?Q?tCrSMKUkC86zPVekpHy33whD4XnvGKnsGR4O8Tby77W6bd3DwViCT4guuTNr?=
 =?us-ascii?Q?78ulQFR6v6md0SBpHyngS+eBiQ0wovJZtlW9kJHdiHTQUGTcFAAtolaAmxNl?=
 =?us-ascii?Q?hYPsAeHAZAblkvQv0AN+RuUhqRrWNiSoQfHF//DRNkB9OPFkJaks1Dd7xEVg?=
 =?us-ascii?Q?eQTl8gTYF1+W9d6dW+cWF/BiOfzTAQcONMYSYiYlW3bORq8bZaoiFraGwPZM?=
 =?us-ascii?Q?CrPWosQdLynpm0Tr9EW/mvSZhhn6jsucspWUIkOgynP3tZuFJOokhpKPJXpS?=
 =?us-ascii?Q?ij2deLLPhUzy0g+hMgBlag3jSbCafVMGNHUY7Yt4JHgZo87nTxpsAsG/3ylr?=
 =?us-ascii?Q?j+PtUwMusr2/WwtqAyjB+N/f9aM+72aTC4lDhJwQvjo+0ezhjP3JxSDijEKH?=
 =?us-ascii?Q?p2J0UbAmjkLdMpS1ihA+QaRjscgB67dmQGiuk+SbBnBLx/0+DegSDFUPcH9v?=
 =?us-ascii?Q?YXdxN59B+ru5V0c7usT3ZUn6ceLzhOt9ZIN1KlJVikLHnuJTcEqbV5TGiMRq?=
 =?us-ascii?Q?8Wa+gDI1ctzpSf7Dxzem+A7IsvsNjS5ME2lC4j4L8LbQrD18/0YmMQcozBza?=
 =?us-ascii?Q?m2VtPUyniNEz75et8Y5AqFZIXYdI2ScCEtj9534khiONb+5HdnOepdRQe2vv?=
 =?us-ascii?Q?e7bw2N8YpepKlH8ziGu4vWrjgbjT0w3ovpEmsRkjBeDGhyOv9gtERo3vvStl?=
 =?us-ascii?Q?YCJ2nbIRLCiX+AlLLRU541hjxkfDCNzeCfSlV7nmRGT/8EvDvy6ctKvuaztP?=
 =?us-ascii?Q?yj6gOwfLPsfmciJbBrUMKVvEfFKa5sAeGYA0mznvlC/Q6EC61EmUwV3vONmr?=
 =?us-ascii?Q?8x25ZH1zAyIJR/9CQY6gJE3XOcOtY+NXcxhJReoL/DnpbYmoBcJzSQkVGXIs?=
 =?us-ascii?Q?BNE8i9Lei/gLcdlkaZFuCzj/3szuo7Hp/mZJDa4CPqjG4tbQrkWmsO9Eor3Y?=
 =?us-ascii?Q?lTcfcdCBOggxWtr6WAkWLmPBmNy0R/z/SHIvl3q3N4aoMzcmduL710pZ/Sqa?=
 =?us-ascii?Q?bgSzJ0oM+xivlfYFQy+VbLkQF72MN8onTHEdEwML9cIAAEMMgqHjJhB08nmR?=
 =?us-ascii?Q?5YMZnj3z0dn3LS4FRxCiBBE17TYyQ/4LqW/m70+Vi5/70XWb2aB9zOPJEKUe?=
 =?us-ascii?Q?ioAUnjNMID8WHOfApPdln4H2gfZvUvijV9pVfDJQyCE/ZMXq1FVBifT7lMbU?=
 =?us-ascii?Q?d1QbaZSIa7HLss9CMfDqZ5z7na5+RbZkjv4/t8wwM34gnOC0LguYx1cevJGB?=
 =?us-ascii?Q?u3816mdhCGIdSJIP2Lc3R+3Aix+oqkZsaIUrC80QXQ6rKf87KV5D5HxqG1Az?=
 =?us-ascii?Q?ul3eSaZL6t3sFbNdOle4v10dyskvYtXs7wPr5JPUUaO3Xs2nd73IYMerTGCD?=
 =?us-ascii?Q?AHfJXz4OtzzoEyS1JDkuOzPkahMh73ooMI5qCfv5HbU+C2q2+OciEiDHwtfD?=
 =?us-ascii?Q?Y53h3yDwfVGEcMbYwQgMtvqmYRk9x+H3LaWXntC5ZxG3wXwLrHX0/y6cCYC8?=
 =?us-ascii?Q?hykd1RD10riTbmvwE9fVYKKGVN00ndJl1J0RWlS1?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01664715-a6b3-488e-cde8-08dddbf5961d
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:39.0371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVuV2CJuFcAMikX6w8zNJI/Zr5+TI2pjGfc4STqGuOZsTdLjM42OuXibu89mZKQeSn7FIZ38QlusIjN00icwrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use min_t() to reduce the code in qla2x00_alloc_outstanding_cmds() and
improve its readability.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index be211ff22acb..52fc5b8932e3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4020,12 +4020,9 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *ha, struct req_que *req)
 
 	if (!IS_FWI2_CAPABLE(ha))
 		req->num_outstanding_cmds = DEFAULT_OUTSTANDING_COMMANDS;
-	else {
-		if (ha->cur_fw_xcb_count <= ha->cur_fw_iocb_count)
-			req->num_outstanding_cmds = ha->cur_fw_xcb_count;
-		else
-			req->num_outstanding_cmds = ha->cur_fw_iocb_count;
-	}
+	else
+		req->num_outstanding_cmds = min(ha->cur_fw_xcb_count,
+						ha->cur_fw_iocb_count);
 
 	req->outstanding_cmds = kcalloc(req->num_outstanding_cmds,
 					sizeof(srb_t *),
-- 
2.34.1

