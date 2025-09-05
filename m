Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673C82F5329;
	Fri,  5 Sep 2025 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058907; cv=fail; b=luZKpZIRultHvwzOaUBpF+SWCa+vtnku7wwVkUMMHI+DWDssDOxp8QkilVAcJrAskgHyafU/yJSidYSySPnXwnuqMp/ADsOr5CVe4719Ff9FWFKhP6Yoiyg2nxtFXtqwf54kywp3Z3srFQ5tBbkX12MJ4OyU7KGLzbwzTkZtVRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058907; c=relaxed/simple;
	bh=EAK8HX3JYC7Sm+A3eIhzCyM/5GtjF3T3s9mWiiAgYzw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NPFMNKuWBlZ1laSs/JQxLKvSRp8NmrQt1i48RNW1BxREEleuiR+VZWye1WV9WcIvLRuuoxqmGBNYQamoqiUmUwO4uMN5KoRQCfyNvBPr3GCrG+NxVndzrUwlno6vHa/FXHNje29+ZtL/A8fuRguifYiwVWgtTHuw0lXhg+NZe2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=EgUfDgFX; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="EgUfDgFX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXJvaoVvdAO255E3l1sfkLeZYN6t1aBSsimxvyMDyyS3tOQ0niy84NC4R/bpb5YJK2K41IZnD/42V8x8B/rzaiHZMCJSlweSOboKmJOXN42xKVRsSJfMH/L4gpeiUDPqo+EcFoT0t9cFYj8hjaVz7R/UbW75bfvIU7u9F9XEN/ddkjxbCf1J0qvBAjyZ2skN+XKGaDDtlyqGHBInfLMi/iTKaDfE6AeSZXoJh2mB2YIvzNxLXWmPCblVgDx2whf24BmJPblnlDVx7d6npib+CdDuVof5qnFk+rGgPH1qRFz9RGZMF6lmYg6b2IUS2vasSTY5tl2VY4gM2Iotqv0z5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+R1q1/hqUDQPnaJZsomyiIO68i/Dl0J7bKMx6v7+JPQ=;
 b=UI8CKe3ldOx7LZSXV+AEHeHMnQiHbxHOWV+j1qhqJyPwl2DaPe24MsP+mtdh1nmRemnqAHmC08gX+xQq5KtoilgHZxRi/fEF+1Eg0JeD7wvbOlWLwLHXQDniUuIZPWAtaOtvyytPTmCVe9jSV6DpqBBVnYTOei/zVafJCZJ8PocWHU8acDB58Wekjf5uGh1WBjlho5AthIn7gaXEuWTs6pdt5b4mRXwqvV6svGpFqoNfshEZwCFakujaL8uWvNrcuADrmO8qVxT3BIjlpuH3Nd/FxsqJBIs+Ji6Ag+heu2sZx+25SqVNCIdzk7F+IkfpqeuYzskKEnENwBo70aszQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+R1q1/hqUDQPnaJZsomyiIO68i/Dl0J7bKMx6v7+JPQ=;
 b=EgUfDgFXhKQOv2Zti5Wire27Ml/V0rwBWxuzOZnS+/bswfjtWZ5CcLXKbC+2QXBlugD+TQUJXiMtHwCI2LQ4M7XZDTOisJwD9+T419SrrLBqn9XYpH65aXeB6UPwk2ugAux6IBL5snqWGv+WmKOkoscHIrZ5Jw83ytsf4f9xbY7+f7vcW017h4N1e8sHWoI2Ln8hjv+7hftPDQgxUWzA97gGTbm8aj+ZVRcbi/Ls35Jxg1FvVPSlM4XbZN8448x0wMt4NtSd111iLOSoGsoQYPCWtQHWNRHQM2aUOslTcNKKy1j9/b64Qpp8YdX6AxjbVYp2mF8RAe7LkvXdGXBK1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7282.apcprd06.prod.outlook.com (2603:1096:405:a1::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 07:55:02 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 07:55:01 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Quinn Tran <qutran@marvell.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 1/3] scsi: qla2xxx: edif: Fix incorrect sign of error code
Date: Fri,  5 Sep 2025 15:54:43 +0800
Message-Id: <20250905075446.381139-2-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250905075446.381139-1-rongqianfeng@vivo.com>
References: <20250905075446.381139-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0244.apcprd06.prod.outlook.com
 (2603:1096:4:ac::28) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: 35473fd8-7621-434f-8b3d-08ddec518453
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZQR8rijBzr1Sb3rqe8+81qse1WfHLdvIYx/n3hE/o8EsBCe4aosg4rWfd9C5?=
 =?us-ascii?Q?dSF38aKJb5tvUjsas3UfgoZEGzvUi2wiqG9ElUVGDJLZcARVlIcTvH64mRi/?=
 =?us-ascii?Q?fWfXUSIEaGgyShgxphFA5R9vtQgBp89/GtNFwhpiCeYptEDd9CVADYbFeNJ3?=
 =?us-ascii?Q?EwG/aPZ3/cBQFXf0AcCoVFRBp4Ig8yMCafOF06SgmGtbXIMJ4asVrJYw7Eod?=
 =?us-ascii?Q?FcFqGIDEurHN082Pci/J8Dz6MDqcoV4kWvqK4WK6dlgI0Fw4VrW4Nprewq/J?=
 =?us-ascii?Q?vcf2EZbKWZqavuex/zsRcF6mzsI/rJYV6iTdRKlm000OhgnOsVIqLjYcaIHl?=
 =?us-ascii?Q?2q6gJSkXNvNzUPQmUcmr4pPTOZRuNX+HmW9+LHUOjc8slYNKfBmWYUy9GhzI?=
 =?us-ascii?Q?qPZXwCIh2zpjk6QkphCSCaY3s+PR0xgfo9gbqevn7cPOIe0i2zI60ZHgiE3r?=
 =?us-ascii?Q?0aSbu3R+Vqx3WSMdFfwhGuNTG28f6elxC7f50xzUv+8+oQRAjNyk8ww1dSYM?=
 =?us-ascii?Q?b93Nuu3emRj+hE4EitvG8jPQZQvQ+7KoBEEaNvuM+cmIzYlXf2CxPCy0UnIf?=
 =?us-ascii?Q?IG3QX3RiCE3w1pO/AYfJywncVShxfWFrivS4TxaUq8gYnvRG+X2F0EtQAfUu?=
 =?us-ascii?Q?PrjpnyNMM8MVRrHVm9aOc23cxpLZ2WZcITYF2HjMs3DXJxZwSCvld9B5Ur6d?=
 =?us-ascii?Q?Ogf/mhoIAHDTUxTMJv50oV1+5MUkMYCMJfzDbEE35nBU7jQn61uZ1Wq5+zFo?=
 =?us-ascii?Q?snlKLTS0hYxb25/TMrndqovZfXerZ1lxjDPOBwtQlo88nCQahd4WmTMiH+CB?=
 =?us-ascii?Q?nqZhR0fUTJ3OqfM5Qu/fXZdTm+HTBhS9NAsO6QY1lYG6jZqjiDlzB5624kBl?=
 =?us-ascii?Q?iiljnmd5cqIjr5QF1A0QSFxHR3M3LKP0NlenoZtOe1ww5ofFL3wCsAWX3dhF?=
 =?us-ascii?Q?JAAu5fFqU/zPAAHKqRwyoEx6S0oMQjAFphQCNDmhHTUA1U/4KVMafz74TPUL?=
 =?us-ascii?Q?YliSCM+CmLFlX0YZ7Csil7npsFIuN8u51Ms5wrflsKtBQc4kqq5FRtjizKOO?=
 =?us-ascii?Q?jT1sebqFOwou1+BzrvfOG4sTKpl3sIC1PJPlb6C0/P6GoiAlc+OTnCtDr2FH?=
 =?us-ascii?Q?pCnbPKhm0xD6omM4IaJ6rksbv2cbXjq2fdKzWHQgJuCL7qHe1X6ZyKUgIld2?=
 =?us-ascii?Q?AjETEvjLBgxhcV5D5PuXsCXeEH3X9uiUhUUyIiU+Cg5N+W/mCKxGRLepi7id?=
 =?us-ascii?Q?vwdwdH65KLzRxaj7LZBE5nrnfyoWcsphzin1kOUtJbyb8tvS6lH+F44EKyzF?=
 =?us-ascii?Q?WkzWg/VeMLy8/ssQLRAu89BGX03IvdWCSz1RucpO7WlMgvHuD2ZnCUdKm17c?=
 =?us-ascii?Q?HYWl6Gp80z3v1AjyDTvz2w369wzwk4wcD9Gw0f13cpn3qnTQmMCW8QlZaYGJ?=
 =?us-ascii?Q?95l1P4Z0ac65FoM3u3rmnfn9q08/aIiGAmhL4LfSwuxZPCWu+QTS2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PggXAO0u6TF/5fmWrQy3LBqsrNGijDZz0wO6O9EWEFYofKnxF24vgFmruagm?=
 =?us-ascii?Q?cVSGtZjwqs4s/J/z9TfHSfiIbx71/r4EyupnmE2vyRLmNCWRP6V1krbMkkrL?=
 =?us-ascii?Q?wCqwLGliQLb9zpUzvx2f7tETiD/SVnnaHd420ws/4VpyE69XGWmpGKzsZ5X1?=
 =?us-ascii?Q?FTDIzEF7dYIOFqvdZYy92LbgxxE3akCxUocq9mJwOiIPCrumYfaXGopzMGyV?=
 =?us-ascii?Q?OLrdy9CCPGvEFNpVmDiJdYLI/JRc7G7v3m3Lb0U4IfiXP+kDPFzEyoQ16f7H?=
 =?us-ascii?Q?zC7v2OsNiFh8f7CeyZe8UZFY01vcuQo8V0rOLPv+BEAr7mb6x6sZ6ivg7+B5?=
 =?us-ascii?Q?/FjI6PgUh/6d/ZnAudGcFSnP0UOhucZZmB5RNNVqjsPn6Xv3yt/N2qyFEA/H?=
 =?us-ascii?Q?lAl3tV9xkWZghBCMeUbBdHRMVCmxxlU3rDiEzbP2n6W/WOeLBpsZu7WWjXkS?=
 =?us-ascii?Q?2azAHOHSuXLF0zQZ/fk7EAhcSU+HhdlQjMJJ3UDtDzBJwni+I3bW/9lv6jv7?=
 =?us-ascii?Q?MjDhMmW+gxM24fH0HzNlIo7is8yG9VUGDkYOm/wz4+wWHtUJMBktaJKlhhDu?=
 =?us-ascii?Q?ktJ3VhDYSdS7AgtaVlKuPSBJ/CTi45piminkjSPhaxwlROxCFFkYdzfda6ol?=
 =?us-ascii?Q?dU+Xi50c7tlEoEnXuZJed8x1SJ6G7Ioqj++8OrmqqAMsZHOO36gMJr9vlioO?=
 =?us-ascii?Q?UPMiXZ9maHkjAjR2fWrGk/1sAfkmGNkrAiuUXT4GyaSoYbUFj1zHGwGCjVEx?=
 =?us-ascii?Q?kB2Q19dG717daRQnB4wjj/ysLz/GDyj1bCs0A6Y785znv+o65wicCRPgOOnj?=
 =?us-ascii?Q?aBsetFcb1zznnfrRVBv7q+YFAep9DE8bZrQ+/uE7+DqeyOxWqBdRMfx6kE5+?=
 =?us-ascii?Q?D2C8a9HF7L6rt8lFIzmnT+kN4SLhzgS7KPNAwwLPH4IULOUJHjmo2YoTxsiT?=
 =?us-ascii?Q?7J9oDCrFmC3LxzlgBwalLTsRj2dPnAi4a7jxIWuI85P+FM+9m9Vev1NuNnVl?=
 =?us-ascii?Q?Y4qr3c+EaHq4euePi3BNjWaVCHlXL5aRkKgKfVsbhzz0yMz+tg0FhquI6uIj?=
 =?us-ascii?Q?bQg0CurhxBeHj+xJfUAPB5Q7Ct7OAcxLMLkPHJa4/AKKCTHsANgIqjOpajz4?=
 =?us-ascii?Q?FN7zu4Ymgs1SxO5GVF2/OW71Pu5uphtUpjsiOb8JdIx9XBp3pxPDct6KxyU5?=
 =?us-ascii?Q?c4PSk3Td3+O/Lr6jk4c05yfG7QTGcnWgc/XUWaxodrew4ZwBhAyrKErGFcZJ?=
 =?us-ascii?Q?TmpldHVJXuqE+W7dftIz6DIxQIB/bJEujbdLqR0YWkjeqwGLYXL0j9mbuboO?=
 =?us-ascii?Q?B0YEL0ym6AExAPYVN/Z7C3vHGJNVEMmEob8MZxS3HPeUKuZhDyUdnh3te9aN?=
 =?us-ascii?Q?DYmy2Gp6l0nQT/GImuz1bqgvvt0xVHmh/kCDWgGj6fOF83tJKW1CbF7zwpaY?=
 =?us-ascii?Q?q/W1wqqdk+snQgrYyhohWC8LuK1Ee/Jf2GmBADAqgCcAwvZuma+P7oez0vKq?=
 =?us-ascii?Q?wLKkXijM7vk7Lv6uKR+QgVUU4x68cYR9iQJ5p7ewCvqweHj86LjqOzkvAZRD?=
 =?us-ascii?Q?+1DcLI+VrnNpSOK7irG3nwUE31qV9IdMIGQo0u6j?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35473fd8-7621-434f-8b3d-08ddec518453
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 07:55:01.4470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIi5TsuCfkyDDlpsrHFm+vLlRtOEKNNSNLmf7KdPebGC3bsGgyCxuVtrGeYM/jGI82rgEevRGsOE3ThNugpbHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7282

Change the error code EAGAIN to -EAGAIN in qla24xx_sadb_update() and
qla_edif_process_els() to align with qla2x00_start_sp() returning
negative error codes or QLA_SUCCESS, preventing logical errors.

Fixes: 0b3f3143d473 ("scsi: qla2xxx: edif: Add retry for ELS passthrough")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 91bbd3b75bff..ccd4485087a1 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1798,7 +1798,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 	switch (rval) {
 	case QLA_SUCCESS:
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
@@ -3649,7 +3649,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 		       p->e.extra_rx_xchg_address, p->e.extra_control_flags,
 		       sp->handle, sp->remap.req.len, bsg_job);
 		break;
-	case EAGAIN:
+	case -EAGAIN:
 		msleep(EDIF_MSLEEP_INTERVAL);
 		cnt++;
 		if (cnt < EDIF_RETRY_COUNT)
-- 
2.34.1

