Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010051.outbound.protection.outlook.com [52.101.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB1415D5C1;
	Fri, 27 Sep 2024 06:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727418321; cv=fail; b=AWIz8SYGUM0YX/v9YWnPnOJdvuqlbJCFtT3hqFbLekgqL1iqIah8f0E7qhRxE8tYlyf1yGYgj+H9B8fmAVMKljvRzj5qo4k66LFGwn+MH3tU25BB9+byFLOnLOypTuudzyZejPrsOlikz/xQ3qoNwJrxumTlY0+B70WHMKcuEJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727418321; c=relaxed/simple;
	bh=ejonOMdnpEiO4rF6mJ1OplDO07IknpHrJ7UbOGUD2y8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=EwA5gzF6LT6CPkRRdlKHdNTvEvmlOFdMest5Ozw1YyYVowL9YwxflmRVRsmWvkbcbZx5YmS0sKyK0ZqNAY2X4xcJiKSlQG4cw5g+ZlljhdJEbRTdzW+ANXhg04Nh65J+eRI1HJ/qURNgi/Dnr3hun8iPOlxqdAVHm8DFeeUZo4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=SYSVYC5k; arc=fail smtp.client-ip=52.101.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="SYSVYC5k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jh6eYgfO8ffZAptUeZmMBC8x1KFWAA/NASU1bZnMxjUc/gKoHo6zmuJveGX12IwvZnFDiMC6xHnq/GoX+jTMGEjWaiE7ixwNTJAbv+mJ61XjT0dVjaNggxdCIV5emFfQYOIBEQJN8HbO3ps8lktJmGKQF2oFca8HixbfzjUVKOYbgcJNV4PQWyrQrkeV9WOzwj4NQXvj/3/kLoMQ0bgCSTHiHHOSjMFnbVYBiMSNpRG51VJRmVYR9esepqrJq8OrSee4XfxRqitJVPcSCo5SZ1k4RqzMMLeLkBlq+tIU6bpU/JVPPqQsSaDwlz8iAPmXkB9nBXrp389YtASgMF68dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9b/eZ3lq19txGrorJHN1TOVDVl47hbdZ7SP/F99VGM=;
 b=xgaeQcBAUoQisBCuf2SpSZQ8x016ZtSS4Ux3gnszkMywyQVphHHWW0ec1A2N89Y2fUEPgNFxojjrhWyDrf60X/aITmmxJ+jDQr7TSuog5bswdQvzf1ubKq/nJzbyDbHd4W1cogfaJFOZ3TKpsusWrmpp8NB9xu1qeDIIrSkpAyMWDk99bUEtqcKLiv1UifzPBEP4gv+tuB7WVRB3GKSsSWlrYCcFonmdspP/cSObdmhoCCm3ijfOLOAzoE4+wN/jXdQOVaZpo0DRGiU+FtThErKAmRH7Ka2KyIo7O/SlvEhJXDWt3jUA+DSRRO4bFLBjz20GO4eJuARLLUVdMedyDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9b/eZ3lq19txGrorJHN1TOVDVl47hbdZ7SP/F99VGM=;
 b=SYSVYC5kUew3v0ynZCVhOgduVhKACGgcVy30cC3K3vlO913K0Eaz8rVX1iyuSDy49XxpVArYxrBVmnkPBouUAMsdeyPNwPfDv2V/09Z+gojcYCyKk6xfYMFg1rOWOL+L7Ce0zJEU1lXIIql6q3Yc2XVLNjPrFZz/gTSVGl8XbXNXg7IyLNmttyJPG8UiEBZoynHYEhDyNaWxEF196WUafox5VAdeJM/EmfOJp2VLB7ppjGsOD2z0vpYdx5eJ5V9A6Rjl+dWCWxBesnRBVwPFmhRtjM+7nDwdaCGWcZ1sFFUJLJGmZbxH8rWkquWU/gS4Ijx+JNZHws9emTpb7VAwog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4461.apcprd06.prod.outlook.com (2603:1096:400:82::8)
 by TYZPR06MB5148.apcprd06.prod.outlook.com (2603:1096:400:1c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Fri, 27 Sep
 2024 06:25:12 +0000
Received: from TYZPR06MB4461.apcprd06.prod.outlook.com
 ([fe80::9c62:d1f5:ede3:1b70]) by TYZPR06MB4461.apcprd06.prod.outlook.com
 ([fe80::9c62:d1f5:ede3:1b70%5]) with mapi id 15.20.7982.022; Fri, 27 Sep 2024
 06:25:12 +0000
From: Yu Jiaoliang <yujiaoliang@vivo.com>
To: Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
Subject: [PATCH v1] scsi: Fix tpos in comments across various files
Date: Fri, 27 Sep 2024 14:24:56 +0800
Message-Id: <20240927062457.223066-1-yujiaoliang@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::15)
 To TYZPR06MB4461.apcprd06.prod.outlook.com (2603:1096:400:82::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4461:EE_|TYZPR06MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f44516-c284-447b-9753-08dcdebd2420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|52116014|376014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q3N4IsA6ub+2+kvMWFPE2iQFH1mQ+lSzCxmIyIyzHg4s3E3av2ZQ1p+v+FlJ?=
 =?us-ascii?Q?sRJ7XP4z0GD7IXn86yecOEq0nZYZUNzRwa7FkOyxFVNyiLRpXiLhux5Nenma?=
 =?us-ascii?Q?kyYg3sjYri6wxp1Tire3RzldnAyVJQ7QbVSpF9Ccbg2A93xgSHarLj8f5lor?=
 =?us-ascii?Q?6GN7x3kwQ03M8vH73VOm7m3i2iStalBEEshpH4QjvRIENo0OPe4W4dw6saj9?=
 =?us-ascii?Q?470kGyzFV49eExv/XNmjRVXtZNSmCDgcetZe3jR6RUqNLQWdog8oiQXxNlaW?=
 =?us-ascii?Q?igfiioKt0hy6hI6YZ49yAL/4eeq2ycb1CcmAsTrfmhqBBWM72GzQCF2NRMX5?=
 =?us-ascii?Q?UZeetcRriz/vW7JEg9+4TgOatRTtZZ9PaBmrcjFlkn4v+c3ChuP99NCMB9ZA?=
 =?us-ascii?Q?PSI97LgcbpF29MGmDzHkgb1MN0ixm2S+OTv6dFPWCd5cs87ckBFefh+3lAzR?=
 =?us-ascii?Q?zu5bL+Y2vZzQFFMYNm+RLF7YH0LzB50pJjOQyhwerjRJqpqNvaYPU5fYe3O/?=
 =?us-ascii?Q?k6YL2DFG3gcxPZsfIBr3VH/EhMDZypu5QH3YVhm9k1R+3K9xuIhdwdog0Z3/?=
 =?us-ascii?Q?TDeuMBYGDtTVK/jNnp1OdLq2psAKNmXsaPl1a+DE9mcPRazqsEu57tapqare?=
 =?us-ascii?Q?EGl4TLdK3dHrDyrpb7k3tvA2Idc+n8Vns7P1EtAapfNHw3xqLzw/Vrm89dDf?=
 =?us-ascii?Q?9+4OiZV3brWuKRHMmSnaZjkKF25Zy++LhvsOmerqbcxQPGI6Rvo+zKZofqnk?=
 =?us-ascii?Q?SBV0sKKh9jjaRKDnXS98A0h+uYHNH6qwzdBA+g5mE1pWCC6znqAt9Ekj4GF7?=
 =?us-ascii?Q?siniFhQ/lhpJTvl4G8pIiklHwwDDMW/tuWwitEH97TJTXZgdAvZjms90tKwn?=
 =?us-ascii?Q?IF86dUghHPgAM33hHOk8LaVpITdiYaZzn+298OnzAkx4QdvF0mfWQk5efKNa?=
 =?us-ascii?Q?9jo/ICdgU0uEJ6g12+/paUYKz7rAfEn3OkzhRwFXFko/YinxwrEO928mzFYz?=
 =?us-ascii?Q?r4pz1WuShGkNs0ydrJW7kXbhZpEEc2GP7XVZ57D3tgiSHQTxiY4hwFVJLVMd?=
 =?us-ascii?Q?npRt+mBOUUaf5lK3jDAjUET7Hsq987JNspuqOfC29bYtYNTiM/PuAE79W96h?=
 =?us-ascii?Q?BlW8BfGRIQOqmTite3cqy7avI3u4TmA+wDRI9WIo/27O63m9wuIu3/QiLs+F?=
 =?us-ascii?Q?1enK2ZAYWS4f4VsarL9/vbr4GfKqXd1C+2gfcgtjcfYZdILeifmhmIQkkY5U?=
 =?us-ascii?Q?cSUjH1sld9l7e/ibeePrMfd7zl5JuRHglZ8MI/p4/MIh9jgGgCoE0VxanqJs?=
 =?us-ascii?Q?gr9GUGjFp/s+V58zdpcfXYRpmAS6/oe6fJWfzYBz8BuhjmiP+b2YxNbBY58v?=
 =?us-ascii?Q?EOGcuwDegoIokYDlKpXdNblA9YmOeNL81ZWuG1E4ujT0VHgGXRtXPfz7FZs1?=
 =?us-ascii?Q?gV1059j8urs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4461.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(52116014)(376014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3g3qpg5g5OCosUvhr7pV61UfJap8JWeHEfgQYCIDTeFMmx7yFP1TJStoav2J?=
 =?us-ascii?Q?bATtAHWN+8y/8Hg04eUYBvlZF0HXhY9bSmKwItArsOjd93GiO0Vh52dij0np?=
 =?us-ascii?Q?fjM8HkL8MM1gZnRCmt4Z8Evd1+3iyuCMkp0peHSiMaSyDhEzHyU8iO0RYxp0?=
 =?us-ascii?Q?w0UoG6DYC6q5wg5uYtC7GUWcvoSxWk6HG6k3x2PEqzAq9ffXvkO1YAe5QqIf?=
 =?us-ascii?Q?TSwKggLOv6nhqRS3dP0r8DvdUWquY6IC652AAlyjhDz+UZmUpV3jlJ8a1F2s?=
 =?us-ascii?Q?S5IP33fWu70XoMRhRIZQIuRvQ4nrn5hLp5jLgIscp7P5PGbMe2Vz4dtDsS7M?=
 =?us-ascii?Q?fXlvqE/DLcvcXT6nMHsnV7kN6Rev7oQE1waAWtS1vUTvv7XZwTkcJBRQeywT?=
 =?us-ascii?Q?/FqsFvsCIW3eWB5PihHz/E73XoYHuipfzxnrdtvYqON5g1QppJ4sFvXr6vyA?=
 =?us-ascii?Q?2bZcj60lyjMTY7MsM+kPGW8NpyfN6mc8aROJTyzU+NcB5Q4rAFWxNoj43iT6?=
 =?us-ascii?Q?V+QabyvGYi0MdB+yndtUtDEYOqFGLXfn2LQSRLgIiFxfB4Ns05q9XF4ORpoK?=
 =?us-ascii?Q?EhQLy8E+t6UxE1eJcehRtCTi3Sag5vlV7dXOfaLlFgz9EPltmxCKkJQaIvBz?=
 =?us-ascii?Q?k+MK2q8JNd3McwJRYPXiNMDLlHcd7vG2w5RdX1FrVh75XOBEjvKH70UtVDrd?=
 =?us-ascii?Q?HMS/y+qlAYM94gncI6JBi8HLW13pqlJ/I7kn6Uihg9f58wSrJ9wgl3NaaQ5H?=
 =?us-ascii?Q?KrNOwZKiwdTzTI25xvLAyGkL0pBZj+SKJGhxHYWXhaBYVWD6K27jz0+5DRSb?=
 =?us-ascii?Q?CNKw1vcsO44SWxKC03evzkjyP+7PnCzABhJ9mP24SWm76wZss36sdZJtXfcH?=
 =?us-ascii?Q?lt+vKGJ7Kud2XmY1IGDyU7sRlKGVdwAaNAkp/KVRbk/GraUW37QM9DezNeAu?=
 =?us-ascii?Q?+0m1fVyjBKqMsEOuijmuFi8sLf0CEDNGesGhq7eDLAhmNc5wu0nI9pjxWPqh?=
 =?us-ascii?Q?2GtwRF2Bk/xAQCHmVqdJDWk9ZeOF7ai8GZ/OVDszVFBZeh3jmgK9lVarTIYw?=
 =?us-ascii?Q?lybW+Kk/mhit+rqUjuCe0+jijz22qeKUUrlRJg634uszr7Pw5sYCdgupRvNt?=
 =?us-ascii?Q?j1hWizF4hjRo9mdIKWjSZISN2zf6raJYsv4jXSj3hhcsV0MJ1ET1MeaFSyI9?=
 =?us-ascii?Q?zS/cbDiaCsCTkj5u/AbyoxZNgVLG/7tpf/VY23+2OvTFI+Y2d3RT8O1XSrCk?=
 =?us-ascii?Q?Rr0MNmKkDUUJoFUCEWxL24RZEFoQRBFuT19ZmNWAo3q9NY1BDl6Ee0jVkPN6?=
 =?us-ascii?Q?h7TGz82lUmFPuCefeqAutJhCW1huAeTo57NQT2GPZ0pedsZPgWVF/SD3zMhY?=
 =?us-ascii?Q?FaeWkcqTjidtWvmjXv6noYkCUoUDc5Hs1fJyLgybUdGWO6cv/TWPyiB1qJl1?=
 =?us-ascii?Q?N1B6LolOZhsp0SpKSuLbpymjonSPWG5Vpt64OySQEPqh2g+QvYVUYmjROm18?=
 =?us-ascii?Q?0CsASalL5euUe1yq/kWsCPSUuUttlfsAZIHa4pEBMChEjMCb3DNLG1hEzDjI?=
 =?us-ascii?Q?6ORLXZ2qi+Jq0GvkVKwwNg9IQwIYQqTin7L52S+G?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f44516-c284-447b-9753-08dcdebd2420
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4461.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 06:25:11.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5Mz97lD5iBFZPQ9uVH53dod92QZbCq/8Vc2ReFjyM/yau5vC+bp9ZvB5+46K2lV/3o9ROKRUJDSB3IDLhENug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5148

This patch fixes several typos found in the comments within the driver/scsi
directory. The changes are purely cosmetic and do not affect functionality.

Signed-off-by: Yu Jiaoliang <yujiaoliang@vivo.com>
---
 drivers/scsi/3w-9xxx.c    |  2 +-
 drivers/scsi/3w-sas.c     |  2 +-
 drivers/scsi/FlashPoint.c |  2 +-
 drivers/scsi/advansys.c   |  2 +-
 drivers/scsi/dc395x.c     | 16 ++++++++--------
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 6fb61c88ea11..895eb17ff402 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1694,7 +1694,7 @@ static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
 	return retval;
 } /* End twa_reset_sequence() */
 
-/* This funciton returns unit geometry in cylinders/heads/sectors */
+/* This function returns unit geometry in cylinders/heads/sectors */
 static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int geom[])
 {
 	int heads, sectors, cylinders;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index caa6713a62a4..c7e242aa7e20 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1403,7 +1403,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 	return retval;
 } /* End twl_reset_device_extension() */
 
-/* This funciton returns unit geometry in cylinders/heads/sectors */
+/* This function returns unit geometry in cylinders/heads/sectors */
 static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int geom[])
 {
 	int heads, sectors;
diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 9e77b8e1ea7c..e62653ac497b 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -6472,7 +6472,7 @@ static void FPT_BusMasterInit(u32 p_port)
  *
  * Function: FPT_DiagEEPROM
  *
- * Description: Verfiy checksum and 'Key' and initialize the EEPROM if
+ * Description: Verify checksum and 'Key' and initialize the EEPROM if
  *              necessary.
  *
  *---------------------------------------------------------------------*/
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fd4fcb37863d..3e7755a3d020 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -5575,7 +5575,7 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	/*
 	 * Each ASC-38C1600 function has two connectors. Only an HVD device
 	 * can not be connected to either connector. An LVD device or SE device
-	 * may be connected to either connecor. If an SE device is connected,
+	 * may be connected to either connector. If an SE device is connected,
 	 * then at most Ultra speed (20 Mhz) can be used on both connectors.
 	 *
 	 * If an HVD device is attached, return an error.
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index d108a86e196e..a8651669ead5 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -106,7 +106,7 @@
 
 
 /*
- * Output a kernel mesage at the specified level and append the
+ * Output a kernel message at the specified level and append the
  * driver name and a ": " to the start of the message
  */
 #define dprintkl(level, format, arg...)  \
@@ -115,10 +115,10 @@
 
 #ifdef DEBUG_MASK
 /*
- * print a debug message - this is formated with KERN_DEBUG, then the
+ * print a debug message - this is formatted with KERN_DEBUG, then the
  * driver name followed by a ": " and then the message is output. 
  * This also checks that the specified debug level is enabled before
- * outputing the message
+ * outputting the message
  */
 #define dprintkdbg(type, format, arg...) \
 	do { \
@@ -788,7 +788,7 @@ static void waiting_process_next(struct AdapterCtlBlk *acb)
 
 	/*
 	 * Loop over the dcb, but we start somewhere (potentially) in
-	 * the middle of the loop so we need to manully do this.
+	 * the middle of the loop so we need to manually do this.
 	 */
 	pos = start;
 	do {
@@ -1027,7 +1027,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd)
 	/*
 	 * Complete the command immediatey, and then return 0 to
 	 * indicate that we have handled the command. This is usually
-	 * done when the commad is for things like non existent
+	 * done when the command is for things like non existent
 	 * devices.
 	 */
 	done(cmd);
@@ -1940,7 +1940,7 @@ static void data_out_phase0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 				DC395x_read32(acb, TRM_S1040_DMA_CXCNT));
 		}
 		/*
-		 * calculate all the residue data that not yet tranfered
+		 * calculate all the residue data that not yet transferred
 		 * SCSI transfer counter + left in SCSI FIFO data
 		 *
 		 * .....TRM_S1040_SCSI_COUNTER (24bits)
@@ -3429,7 +3429,7 @@ static void set_basic_config(struct AdapterCtlBlk *acb)
 	DC395x_write8(acb, TRM_S1040_SCSI_CONFIG1, 0x03);	/* was 0x13: default */
 	/* program Host ID                  */
 	DC395x_write8(acb, TRM_S1040_SCSI_HOSTID, acb->scsi_host->this_id);
-	/* set ansynchronous transfer       */
+	/* set asynchronous transfer       */
 	DC395x_write8(acb, TRM_S1040_SCSI_OFFSET, 0x00);
 	/* Turn LED control off */
 	wval = DC395x_read16(acb, TRM_S1040_GEN_CONTROL) & 0x7F;
@@ -3530,7 +3530,7 @@ static void request_sense(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 /**
  * device_alloc - Allocate a new device instance. This create the
  * devices instance and sets up all the data items. The adapter
- * instance is required to obtain confiuration information for this
+ * instance is required to obtain configuration information for this
  * device. This does *not* add this device to the adapters device
  * list.
  *
-- 
2.34.1

