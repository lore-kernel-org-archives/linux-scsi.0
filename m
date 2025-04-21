Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011026.outbound.protection.outlook.com [52.101.129.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16807320F;
	Mon, 21 Apr 2025 13:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745243502; cv=fail; b=d/pYUgCo+SflgSKcnCjlZW/jFQp+oqa0QsrAgnNPc1vTR8+P5z6ggzwhrXo3b0yy2p2VbSv+vSGc62VMzNjcQsl9Tm+J9cVnbfBVyXp6iD7MjGpLTEsYaFiDy2VpChQt3cFpfPQ8kod/Hr20ygk+JNUnboebNTXVt+K8qwMIe8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745243502; c=relaxed/simple;
	bh=yc0d3WGqg0qbEvkcxxYh9HZHf/jD3IpLdlfnqx7MuJM=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=hJsHqMuUQHC57//NQa5+NcN5o0uHSq2KkPvVfJnVANNjWOb+P7P8NUXQrTQUPM0WXGol2yLHi57CIKSCpB9dGtQuKaPhjeBNgWOqcxg44oYQpuDm/qUshjYRM2VSEdxe8YF9IE4UzDcwZ6UeFDDRxV3ZNKEUZF/tVM1Czgfk0/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=KnG8UUBO; arc=fail smtp.client-ip=52.101.129.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="KnG8UUBO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u6ytPSX3g9bTnQOwAcUShY8P2Vimx0PK2xDCUn7STEnJjRQjsSvhFGieiSDIjYlPsrfTmqhJwG7B0dDn+TPQo1yWBoqePgkWnRVTNGtVXsxxcfPfTftydoVQ+BuXkZo+5/ZhDI3a0IAjZGQkMN21CS1mIP8/WvOfK9iH/sZK2rs+hhqNxZ5ISYB/OCqITBjYljJYNILHU1wW1ns0Nk4yqeu7GwZ9aybwHuI/LYtU6422KmWGYVrisfnMJoLJQTV7eRWKW8V96AQFJel6tc7xMzTMZIWuEGgQ8kUYn9lTYIOMYiBSCrodD5odDEurhyXgQY0slun9om6M6Y7l6bmopA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aXRnt9BpycCt6wdV2bdWn31ZgHIG0s+2FJYkBj7haE=;
 b=gLMFTnGRIy2omhCWqgKIZSog8SuzesgS5l7NzRTJcfnrBe2zZiizcmNcJr57PblrqbTb6eKQaUPrymewr+Z6uAbn6UYqpoOWpk4r3NH/Yrf3QXl5NsOCLOBkSHQ2RpT0EcLQxuxMHERZeBngyk9gkbqk/gKdn2SDgted8EWshZZBDq2Ki6x2h9vA0pAvFItg1YgWXCsjpn76byI93WztAuF3smzDQLOUwqjX9yaZfYhoaJMNthtZG/23M+vQluvuH0LYMuVRyJlBvWuYNQzc2oe+OGCELpNF3rHuWCGzd9yLcuiClZ7KqtmTomF6QsEqfiO3MOuQDPWJ4aPmkp9nWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aXRnt9BpycCt6wdV2bdWn31ZgHIG0s+2FJYkBj7haE=;
 b=KnG8UUBOidBEbRyB52AFZuuEg0im/HfZZWZqJSorKLbYDQlh2SRAlhedaV0TB7WmDwWD2neUUBriVkVqxt9p1yrzYCIOyo1lOfm4Ml6/EPVb9t4zZ/ifLhWkklObCCFV1wWCPxs+NsGXnNB/Y/+9zMxKMp2Xi+RPHshs0nQv92vRPu//GrrpO8xtI7nv6mUmrqHv5k1o2dCSNHRkok8+E7oAK02dccEBxKA+MuX50gxxbaR5ErriWC6UACavSs2XUolWGB0lIdwkMsqBoVZVSsq1i/IFkYuU6SUrZpRJEjQow6du3poeyrB9mNUHCOB8S/VapgJSYKEhXMpXM2D85Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEYPR06MB5349.apcprd06.prod.outlook.com (2603:1096:101:6b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.34; Mon, 21 Apr
 2025 13:51:32 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8632.030; Mon, 21 Apr 2025
 13:51:32 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH] ufs: core: add caps UFSHCD_CAP_MCQ_EN
Date: Mon, 21 Apr 2025 21:51:23 +0800
Message-Id: <20250421135123.594-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEYPR06MB5349:EE_
X-MS-Office365-Filtering-Correlation-Id: ff29f7f5-5c18-471f-fafb-08dd80db9fdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?35vbo2FZ8r1Ml+BGl7Jpqs3EdvtZVLqqy8kcPvVLH73JP4UHdFFy2iL55FHP?=
 =?us-ascii?Q?NwMETDaOx8yMeckvU+Iim346sVxI7THHtS38N/MzH0vkGwJBOkCcJZafAXYc?=
 =?us-ascii?Q?rfw3KCDw/cUaR8RpcPV6LgFVBYN0Ysm/avdqDr7BkolXR1mZmA0IAq7fEHSr?=
 =?us-ascii?Q?JuzgqfQKNZOD34AHtfypnO/dlExdzLyAMSOAqLX+zaRL53tnM3+ZiLlUOQd9?=
 =?us-ascii?Q?jmlmiaqkaJtNbbBwXn6YXVw7DteUr/FLV2DQNRfvQS1yoTFlXlBsHF+Ba2MM?=
 =?us-ascii?Q?szXtSnIpRz7pSZSWTTupA3XfVTWflftceGF7M7hTZwV5SdpRUmLOopS64Ywc?=
 =?us-ascii?Q?kIo5P8zi66t8BmYbrwcgjR6edZ191ZsxB1t53pJEL+J2q0ybAeA9rZBpxN+L?=
 =?us-ascii?Q?OEkepFCNQ6CqIKXNHpU/3GsaPnF8M0b0LqriLNgtkRY7WMXn1HgwgXs10SG6?=
 =?us-ascii?Q?/jn4yd0P7PY+j5oyVr8EFjYZoaZZDWpxCTmaU6ZK2io7A2Ax1bmywmpf/8Y8?=
 =?us-ascii?Q?xYvXy70IqAZoxH2FmbY3NSlkCLbqTwzj1gxdC+wlb3m29FbnPw1EP2auOrJn?=
 =?us-ascii?Q?JkU1O8ElzaFPK9iL5U/DSQcxEXupp1oApv44hS38STLXN9so8sGybDB5cyqn?=
 =?us-ascii?Q?8PJnrTKUGo/pFpZz2xvVtkYFpOuiUO2AcHERAXDkXgIG45Fa8tPIR79HjCdB?=
 =?us-ascii?Q?MMno+q2/rT4p1vO7FIaQgOvIk8QraI0YVM97GVtb52lzjS8KifFXa0HpdmuW?=
 =?us-ascii?Q?4/rsPvV8f6HfeGGXo0GSNHghsyUZDPUdXyDNXqw1uOYtH1/rWezYlvdWubvf?=
 =?us-ascii?Q?7W1R+Zx0xYVE+gutd3FgUQWbfaNcCX6gAg+eo+/c6RlOdqZyEkc2rT1xgWKC?=
 =?us-ascii?Q?SiqGm5VIc3dUIXU4Kn0mt9Tz7HholmPw7QdcY8tQFKoqcnQHo5+Q75d6cuCQ?=
 =?us-ascii?Q?5ZDZ3160//MqZzJcPNq5KBhNLSyNkflI0jYEMtFHP+tjZAwYBIncCg/uus1F?=
 =?us-ascii?Q?19oCnOlT0wXo3YOC9MK0hYazHyZWL4i2vursRs8i2LvHbWBoXHokwRI9DTTU?=
 =?us-ascii?Q?CEYg8PJfq+AwSRsNxyTYqoD6XfnOu+bHSA0zAkJtmtKXLM8MECPrBGl1Se6g?=
 =?us-ascii?Q?N6J1CJzPC7esqrSXql0x4dcsbzsiYQjdBWleQHzDKem7W1yB1CDLWu+ZJbhv?=
 =?us-ascii?Q?2ScOTrZjqCpuwThw3GYYQ6i3O59FjajNXDJblFrv9MEgSfRmlPJv8MpjZt1j?=
 =?us-ascii?Q?3eG+D4Fe0TLwwAAQmMVr8fH+or/TXrRUSgaDqu3wDRH/Jk95h9KnHqFq+SD3?=
 =?us-ascii?Q?6MSHfP7/a4D52sX6re1uQnBGsHabKuESKDwSJBa9zZsgoeBZdk687ajA6Ah8?=
 =?us-ascii?Q?HYuKLUoycmPBvNrC3grPCGQROu/cldspvTvTzAHtutRkUPZ2V89k838x/7cn?=
 =?us-ascii?Q?tPozt1yobA/sa+PU6rDpG7EiVkHr+dtjy5wnawet8wa6xU3A4EhzuRf6lzBV?=
 =?us-ascii?Q?TL04hSRDO/2h/HY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NQufYw6K2RI9CYrnqGDM6N8AKkpYx5YXXLSh1lJti0PkZqcHbHh0mPCR7pKa?=
 =?us-ascii?Q?47W1nWm5N30GlWNRibIqLTwPp3U9PTU0nPrNOBvwHZFLPlcsd5CneJ2ufnvL?=
 =?us-ascii?Q?uZa3uD0k7UjMgeAscXyw+BJ1Wtrj7KN21KWk1Wb+05PzkhqT9KtU3RG8Ou9I?=
 =?us-ascii?Q?4kK1gv34TqgoJgxwj565rUmnQbh/QuTwyee8TB9OGZc/VJzIK4bpSPnnWIDa?=
 =?us-ascii?Q?4R4OLBNtzbZurOs85Mb+yZMqB1kdHgjVVdcDP2SGCbvcymldKdvo/hBleVrm?=
 =?us-ascii?Q?ABlG9IlRKusxYksiTRV3SUiXiFSDqgi9hIPvdOZKFIYKpW768IH3e+qIz9Xs?=
 =?us-ascii?Q?mKp03eC+vkaAlWDZFCdSokY5wkQFQ+LoQcmpUMuSz2cQumfZnJaJEiHSjXRD?=
 =?us-ascii?Q?QVpAUD4NkBjB4O9ODHry3qSvZZ1+z2pMQUWneU3Y18LJdWoy84x/HsuzMRm3?=
 =?us-ascii?Q?lygP/XaVPmyLOzFetOzt64b9rU4SPsHDsRHgcsQKMJuoDtoUDRNDWc2pDv5q?=
 =?us-ascii?Q?o0ablaY4nD262QbGS7kE8c5XPGJYRnU5GoBF5BzY6r7GIedfZZWdPwNkBDRi?=
 =?us-ascii?Q?V3oSSJ9//mqeO/d1OOnj7qyN1iezg3rdMPSSxiFop8lOIB4pSOE8HevbYn3V?=
 =?us-ascii?Q?H/N/GRbT1zPMtPef9RG/4mRl1BEqPoHeUOEo2+R1Zw93RTyY5UgdpHEd0LCz?=
 =?us-ascii?Q?Wbx+KCC/NKFhZKzWaAA9yjjoF0+7w14akggHZOYlZUBoI3qA5ydeLxG63vvA?=
 =?us-ascii?Q?4GVre7qa2Wr+ZNwkiD+YszyLWdt0LW9iXHV4EyRzGqbaUqDoLrrsXK4jaPkS?=
 =?us-ascii?Q?kGz9NcQ0wf5hkGiBp2PYkgV1F1nxWkxVIya4H/Ydi5pf0q59hT0pMLrJRiSx?=
 =?us-ascii?Q?AARxm8fkeabHS4xrTZhFwhJbWMBtAsa/rj/tI6nGClwfs6+5ZsL7UTUAbm5w?=
 =?us-ascii?Q?PGNS8yarnttcz6BnSELArINdfMO9AoDNsojR3oy8L090s2z7uzQBQ09HD6e2?=
 =?us-ascii?Q?Fo8q+kNcLV5SU4wUps5yV+k0GeHQOtUB5xjFx+c6rHBVC/OEdIZp5FFbEiZ8?=
 =?us-ascii?Q?Es6laeB1/3Wy1DVyY6tP7MZAEfzmGv5WuzMg6dguyNJWKz1OQI41nbT4jtTL?=
 =?us-ascii?Q?rNnhpW1q647REsCQzkohUdFUIqz45urY17RC01h2CmxmdQ4FeYJmFV6o0e7V?=
 =?us-ascii?Q?UrOeWfm+FHiSuVHMckskRydtwIh0eOVlGOX0RKTK/BFg/dakLLy4oIJsOBzA?=
 =?us-ascii?Q?XjnVP3I4CBbrk+CnHBn8VQ3TYTUVzhxO3s+XdhiTKLk8xDVxMrmLRtTtne1I?=
 =?us-ascii?Q?FTgamJYry7lTY4p5+zRKjptyKACxV6UYhNZU/+qRyattgTbpGUrpccYtwJKp?=
 =?us-ascii?Q?PTNFfGI94eX/3GR32MN8cir26AEy9UcDlvedLOslsYzkBtlgvU7Qp1a0xdOx?=
 =?us-ascii?Q?zoS2lBJWAShTnfybvw6cpwpGY2B/wiRuaqnOL4mx0QgAZXtBl+ywuMs/DGGq?=
 =?us-ascii?Q?i256b09aSWWbY2lbPp2u8p3J+gNDLdi1R2usB8OLDNSepKD9FduVC9KcDQ1k?=
 =?us-ascii?Q?mNygykHcGKi9I0IPxCsVo2nztF6bv+koascyQINP?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff29f7f5-5c18-471f-fafb-08dd80db9fdf
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 13:51:32.6449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YAJ+NJVxutUEROAVSFCJpUrwZiUNaad/dfu2ZtqDlZdPRO+BC7wCfMdQ73m2fpaSe9SlUH//LqOfQdhAFUVI/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5349

Add caps UFSHCD_CAP_MCQ_EN(default enable), then host driver to
control the on/off of MCQ; Sometimes, we don't want to enable
MCQ and want to disable it through the host driver, for example,
ufs-qcom.c .

Signed-off-by: Huan Tang <tanghuan@vivo.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 include/ufs/ufshcd.h      | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 44156041d88f..b8937f85d81a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -112,7 +112,7 @@ static bool use_mcq_mode = true;
 
 static bool is_mcq_supported(struct ufs_hba *hba)
 {
-	return hba->mcq_sup && use_mcq_mode;
+	return hba->mcq_sup && use_mcq_mode && (hba->caps & UFSHCD_CAP_MCQ_EN);
 }
 
 module_param(use_mcq_mode, bool, 0644);
@@ -10389,6 +10389,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
 	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
+	hba->caps |= UFSHCD_CAP_MCQ_EN;
 	ufshcd_set_sg_entry_size(hba, sizeof(struct ufshcd_sg_entry));
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e928ed0265ff..d8547bc6bf79 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -771,6 +771,12 @@ enum ufshcd_caps {
 	 * WriteBooster when scaling the clock down.
 	 */
 	UFSHCD_CAP_WB_WITH_CLK_SCALING			= 1 << 12,
+
+	/*
+	 * This capability allows the host controller driver to use the
+	 * multi-circular queue, if it is present
+	 */
+	UFSHCD_CAP_MCQ_EN				= 1 << 13,
 };
 
 struct ufs_hba_variant_params {
-- 
2.39.0

