Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013039.outbound.protection.outlook.com [40.107.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59988382;
	Mon,  4 Nov 2024 13:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727991; cv=fail; b=UFwzCZBGHfz4rXny6nj7W/jxCVA4VdcxDwXbyBBlOXj3StFDkYOgRyGaTEV3Vw1yGE5Yo0LF7nDbkl3HisTy9dd5sFGG7Rfsq0oauVk6y/5jSXLZu7RHvP0GtbWzgceGsA+4a0sUtkAyI+QSWQ7E8ACRUuIV/sknlppswJDHoMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727991; c=relaxed/simple;
	bh=blgdPr4UviA7fnLSPoPn01ZzFMzWyh6TY2ySup0HUgs=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=I9N9par46Rdc2F3OWtxe82JkUKEhNuor8/rzLu1HqqPWHMhbaoFABXOYITifOIiQVh01eV7NJkgX1bp9p6pt/0RAV4UnRdliQeXAY85n/3GKKjw7tSkVwSmMLBfkxW6lEeUMYbv2z1cEcvQf0xd/1AwPevwtepJ5pYEWob0KgcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=hb3EULOn; arc=fail smtp.client-ip=40.107.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="hb3EULOn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UoxL9okNXBwqHZG4Ttq14CJw3Lf06Yuzzwt9yScn4ISGPrXQ4TlfDyLPZzO/jKWLX8j1axWZ4MN2gDwPO1JEfb6t9iw/eh3ChMx+Iq5fLBbiRmP8p3agoXgGLxKOr8GM/hlwst604r3vCpdpSC2akfygtrGlYtdv8i0G1nAvuAlYbGBxgINlVhgKFadr2x7k6zWSMK8vq1zTB42mFLb+hekfdm+uybQZKX1BM1kzBO8AMpeiLtWT1s6+Jah/vmWScOdLxOiGOAfmgjNR7IJj6RBA45jPxVtDlVNYdMq7IbwmCW3Oqn4C1zXjcRz58GqTABUCyST2uN2nIYicNvgOgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JEPe5253n9uiqyFy4O+YdbatgX7C4zdQaYYaf66o1U=;
 b=vQHRfPJmPeIx3RIPmTuIpN6Nu3JrtLVNAbyprTMh2XIttOOICZ8tYc7ZQ3UMiQ3AMx5KknNs8Mw4N7cUR2gy6oAF91kvCB7YBnmljTaEPp0LfH3f9Cm76B1R4bh/kDLiQZIX/+5IA74UuWFAj6D1njBXEvZX0NkCHcHZohK8DoUUVAKhBFdtyX/EXNBn5gb2+hpZjxE9qWgdQtcOnWkCyJU6xQRVGyvxFPvurs5pqxEWZyykJWZWSxZ2+6AUdJvcRs3aBbj95qoxpI8qkIakR5LtwFHWgDeTbBpmaP8oAdNZaUq+vXy0EvApiRdT4ureOcqtGecm2B6HkAdZqEr2FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JEPe5253n9uiqyFy4O+YdbatgX7C4zdQaYYaf66o1U=;
 b=hb3EULOnokMNgbSy104tzgQL86VqIm/p/188BY6nUePO951MT3s06Eu0ZYjQ+13wjUMUMnyB4WhPZxL0FiRSw+1ahkK7uPTl9gbmmS+/RR4Fs4P1dsaDSPvuY50IIG61cUnIpFRvzDS5OIge+sZzapSRw+Pp6C9iy8S1mhULkzueVNOHe1WxhOH2xXtqICQ3osPF9zQSGZpBQT3Sr7trKGso4twd+plg28gGTazVHvbN6AsCsIoBbKmHS2wyscl5ujvkL5R+RZSutpNBFkH1FOqwwa0gZuN3k1vX+yN5lHW3Do2orksVE4xG2Mj+D1xMsWyMFMvdUwZtIyDGKAMqRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TY0PR06MB5755.apcprd06.prod.outlook.com (2603:1096:400:27d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.12; Mon, 4 Nov
 2024 13:46:24 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8137.014; Mon, 4 Nov 2024
 13:46:23 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	beanhuo@micron.com,
	luhongfei@vivo.com,
	quic_cang@quicinc.com,
	keosung.park@samsung.com,
	viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	ahalaney@redhat.com,
	quic_nguyenb@quicinc.com,
	linux@weissschuh.net,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH v5] ufs: core: Add WB buffer resize support
Date: Mon,  4 Nov 2024 21:46:12 +0800
Message-Id: <20241104134612.178-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0069.apcprd02.prod.outlook.com
 (2603:1096:4:54::33) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TY0PR06MB5755:EE_
X-MS-Office365-Filtering-Correlation-Id: 66541848-a283-47fa-d49a-08dcfcd71249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|7416014|366016|1800799024|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S+Sn2oqlOimXUB3ObxWYSn8OPdvsVQIm6kIgQvLTLKAzJ5UKAHpOMdLNja7q?=
 =?us-ascii?Q?jaav3I4CB8huvrwqK826+XOp7VhQkRsLKn7a7pu1GYk1MrJYEL9u4zmORkTX?=
 =?us-ascii?Q?nVW09YIoioqVGYhihii0cI1UcOwQcYhmsWRWRPGVYERp7nWkxZ2x9m22xgXK?=
 =?us-ascii?Q?kWMo2rx7ikmuiHROeGHmnv9iWLI0zkCWbDCM5aVHC+rKQLFABK11jDV7h5l4?=
 =?us-ascii?Q?9AkAoyoOAStGRuSYd/HxsgZo8UavplaCxaUIZ5yJ532jFyvcRaHNxG3HPtI6?=
 =?us-ascii?Q?l4km6qlUZnUCCw6Pvopy2ENpvmS3+Jj+N5lYkDDgNgdixi/Qq5t0t2RPdaEb?=
 =?us-ascii?Q?CPZcjdo3dfqcKglc4ycPfqRGcDva5WHLAfWJKP/M3yDoV8emZ7P0A6CNr/KN?=
 =?us-ascii?Q?7wSYqWURg/dMwhIvzpm89+DtJi37RHtuDmCI2+7+OzL1V0BfC1b/DZEr/I7+?=
 =?us-ascii?Q?qb4sC65ZcPrpsgUh+GLN/jKsW+X4iFE+LUSVvO2ESVi0JoYg3e+375SuHVCs?=
 =?us-ascii?Q?QfYbnvrPQCanob675F+7RI5L2r/Q+x6vbOnvNOsHyLtdhkX9yetk057pDcpe?=
 =?us-ascii?Q?9J9klFVNPPVepYVOwKeBpkerdkp+q4LVLgMcW6sh23YzRPkxcHVyho0+3aKl?=
 =?us-ascii?Q?SRfW3wlEZNThLcDQTP0tPFNkBQGX83b4jZ0jNz9baFyA9SPL8pdP5rYNi6mw?=
 =?us-ascii?Q?YDQy/h/QUTt6yROE2V6uxOlRoUZNLJkJF0W9HSkc7l7r/Rgj/cgoILskIiqy?=
 =?us-ascii?Q?WoSP1/hQFlGt85792Z1wcsQ352Lt594XptUiZUAwMrAreoIDkZXyUSBvTEck?=
 =?us-ascii?Q?K8OKAVWouOyMBVc5faiEJgiZsdO0jqoWRz/eiJO5fnclkqHTePBLdJg+WAB3?=
 =?us-ascii?Q?dBqK0m3KaMseONyLhFORniQrOIYN8CQFEot5lsMDzSITwze1R9S2j4GXSb2l?=
 =?us-ascii?Q?jXo1/IOukOkta7XIF5jgVOBX6d1p/r6Ti6ucwIIwOMLvCpEEKyo/kG4UJLJW?=
 =?us-ascii?Q?2g/fQcwBLC4y4SVmXIKdYPyicrkIQcDs0GM1Y4NarxsvkiIL6fQOujAR+q5c?=
 =?us-ascii?Q?Rb/q4uY3G2I4jXiTI+ajGd6UpvbnA37TAGvrSfteF9fAo3Z54Q/efJY14UQw?=
 =?us-ascii?Q?M+SWacz2pp7mh6DYmeVtgBWB+xjmhBp5JKzshkkSM1GHLHK3edSq098X2Iwv?=
 =?us-ascii?Q?pLn3VU8M0/AlHoYV5cc3gHWXUCZQY6uK5fx+6gpmTGH4151enmWbrxNHcYRh?=
 =?us-ascii?Q?I3dRBCeFmIZWJZauJiCeJFKAdM8JDs537ecZkRIx4F4D9tena2PzdRV8GdSc?=
 =?us-ascii?Q?iK8bTHcPoFmKMI3rMeAWjonzSOE/UwIQofIzn9bI2DMn8pA/pi6w/GPy3K0y?=
 =?us-ascii?Q?SobRpcMsKS1iP5V89YdmJ4wNuSGVSwcqF/SinayscYSfsJ63+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(7416014)(366016)(1800799024)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ha6cwjAENnPFo+Q9l+wr/u75z9SzKXtWVYgTN6PvpIEJf1CBuQHvVo4Dfnsv?=
 =?us-ascii?Q?w3cDvmBRX5BcQW58cdTXCavNvTJL5d+mP7f7G/KSJAgi4BTBgAehl2ttX5Jh?=
 =?us-ascii?Q?Uz9CqpO7PmNMrLElrrGlEaNFhYZgMQHsoq7X0gnaS1DygT2VQHocHoyvQO0C?=
 =?us-ascii?Q?KtuXamgJ3gwPTb/j1qRoXhZVEx5jvTx/vc+gwa6NC//zzhM4FX0c88RHMEcN?=
 =?us-ascii?Q?OjzOuFmh/q02VM0k2lK4Yw0fVbYUHP5HaxH7km4UI6H0SlWxqmuGvScLCNdd?=
 =?us-ascii?Q?D+LWS45sqtFsAQCd2E9Xm+CDOMpFBGmuuSPDbp0iM38yKNT4YI/tkPiuDw8/?=
 =?us-ascii?Q?MK0aFPK14TAJO7Z05ZLsrvbnjlg5qgxo5TKomlmE3FOs3M2vk/RrE5Iocu3q?=
 =?us-ascii?Q?p1JlS22RgdtZQT3WrCeh2a+Gx0vdgOUy8s1OE9fu5LSoJrPMIoF3fK9kFJi+?=
 =?us-ascii?Q?iEUiiJ7CYMGLTRj06lkW5OVZnFjORe0MD1gqtIIWBdPgD2/O+MsgsVZc0HUm?=
 =?us-ascii?Q?xPkr5WJm7wynmY8XLo3WRSdw9zT5SpQW3EEskS2fXFAA9WwIfU1voiE7LTtq?=
 =?us-ascii?Q?4sMwUoE9IWDO8gYM1xXZf5pstWL/stwoQgcyCXsP1Wvw1h7wk7qzF27A2WJx?=
 =?us-ascii?Q?7lbKH3NcyQFzBuinuAiev/0joSGR6Ye6U/IjFqr/dBYG8KY1wOHYYma0hHRv?=
 =?us-ascii?Q?u5LAloKtNFn6PFxT4emvn2/MFCmgfJk3u78CR4mNBCqXzOzjkrkHOtcV7g6s?=
 =?us-ascii?Q?knD1GiB9l3Y0pCGtO8V5NnSdoy4r9JkGmGSGOAquEtQgkE0c/JQQBdX1gyx/?=
 =?us-ascii?Q?jWBpPJx9FY2m8uRnQQ6gB17eQgbzOU4akN0jHKnfeOAWEu6OWVP2e6R38pRw?=
 =?us-ascii?Q?qvudOHZv5XvCIcHsbyKAeXRGCP7PG/idvQQaFeIWYtsuR59CGc8Iau8VXvCm?=
 =?us-ascii?Q?bbxRLQh4zLJ7BR4ECZfGzOM8I425Om/VRAs5c/fBbMwMeQdlrgTtQE6UQRrW?=
 =?us-ascii?Q?wf3DUyxhb40loQOewAns5H7SD+/SEDe+y7qIy+atJ10sw732L+9UwijAmZjg?=
 =?us-ascii?Q?MyUgZDtQ6Icwju34dRmio3OeAiucDAx9uor2712jx1/z3z67Fq2Mv1LrPBjr?=
 =?us-ascii?Q?NjV1TqUwtao1qteNlO7RKUDnJua1TLqf+F4q/HBPT07yN2zd/Dw8zgmh/jUA?=
 =?us-ascii?Q?PUCwvx41czAO9JFHM+6tnmCize0BzhN5wCo62dasCWXzATr1yoEqkInq2GrY?=
 =?us-ascii?Q?xIgptiEVB3y0BLs7kERt0EFxlf3eZp71ItdeHfmZK5hk9aGyFePNmz4Xt6zX?=
 =?us-ascii?Q?jdySkRzth/vdB4KNoX4/hmLfq4vz3j66+V7ucQw6c5eoSezpKr3aCfcOCqh5?=
 =?us-ascii?Q?la28naOOh/B6pLSQJHTG+lvJxhdo8HzQlbI6BGpgJVRjgC15ae0YepAbUZW3?=
 =?us-ascii?Q?p/ey4nZUxplxbWwk6MfxTar/9bxN2LZcqumqgtkawwZdAj6/R623jnBEM3Qy?=
 =?us-ascii?Q?vzaft8tBkTza7+rdWwQ7PLV2In0Sg2GLlzg9KfrYtwCo5byWUMKpmu2Alo9Y?=
 =?us-ascii?Q?JQ5q7hZNVyrpFtoieg+kKHdnF2mXqPbxcngk8MQK?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66541848-a283-47fa-d49a-08dcfcd71249
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 13:46:23.6877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GVpTnhDWdNEOHxyDTaVamEsrwHEKs/FACnFGyDo3OM2rj2I8VCaFw2qKOPQrdQ9D5POzrac98c0Tbo8iZU+I2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5755

Support WB buffer resize function through sysfs, the host can obtain
resize hint and resize status and enable the resize operation. To
achieve this goals, three sysfs nodes have been added:
	1. wb_resize_enable
	2. wb_resize_hint
	3. wb_resize_status

The detailed definition of the three nodes can be found in the sysfs
documentation.

Changelog
===
v4 -> v5:
	1.For the three new attributes: use words in sysfs instead of numbers

v3 - > v4:
	1.modify three attributes name and description in document
	2.add enum wb_resize_en in ufs.h
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c

v2 - > v3:
	remove needless code:
	drivers/ufs/core/ufs-sysfs.c:441:2:
	index =	ufshcd_wb_get_query_index(hba)

v1 - > v2:
	remove unused variable "u8 index",
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'
	set but not used.

v1
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/
v3
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/
v4
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  51 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 131 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  15 +++
 include/ufs/ufs.h                          |  27 ++++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..40204c0a1588 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1559,3 +1559,54 @@ Description:
 		Symbol - HCMID. This file shows the UFSHCD manufacturer id.
 		The Manufacturer ID is defined by JEDEC in JEDEC-JEP106.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
+What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
+Date:		Nov 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can decrease or increase the WriteBooster Buffer size by setting
+		this attribute.
+
+		========  ======================================
+		decrease  Decrease WriteBooster Buffer Size
+		increase  Increase WriteBooster Buffer Size
+		Others    Reserved
+		========  ======================================
+
+		The attribute is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_hint
+Date:		Nov 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_resize_hint indicates hint information about which type of resize for
+		WriteBooster Buffer is recommended by the device.
+
+		=========  ======================================
+		keep       Recommend keep the buffer size
+		decrease   Recommend to decrease the buffer size
+		increase   Recommend to increase the buffer size
+		Others     Reserved
+		=========  ======================================
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
+Date:		Nov 2024
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the Resize operation status of the WriteBooster Buffer
+		by reading this attribute.
+
+		================  ========================================
+		idle              Idle (resize operation is not issued)
+		in-progress       Resize operation in progress
+		complete-success  Resize operation completed successfully
+		general-fail      Resize operation general failure
+		Others            Reserved
+		================  ========================================
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 265f21133b63..db98c35e953b 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -411,6 +411,43 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static const char * const resize_en_mode[] = {
+	[WB_RESIZE_EN_IDLE]		= "idle",
+	[WB_RESIZE_EN_DECREASE]		= "decrease",
+	[WB_RESIZE_EN_INCREASE]		= "increase",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	mode = sysfs_match_string(resize_en_mode, buf);
+	if (mode <= 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_wb_set_resize_en(hba, (u32)mode);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 /**
  * pm_qos_enable_show - sysfs handler to show pm qos enable value
  * @dev: device associated with the UFS controller
@@ -468,6 +505,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_resize_enable);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 
@@ -482,6 +520,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	NULL
@@ -1476,6 +1515,96 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index = 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		ret = -EINVAL;
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static const char * const resize_hint_info[] = {
+	[WB_RESIZE_HINT_KEEP]		= "keep",
+	[WB_RESIZE_HINT_DECREASE]	= "decrease",
+	[WB_RESIZE_HINT_INCREASE]	= "increase",
+};
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret = wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		goto out;
+
+	if (value >= WB_RESIZE_HINT_KEEP &&
+		value <= WB_RESIZE_HINT_INCREASE)
+		sysfs_emit(buf, "%s\n", resize_hint_info[value]);
+	else
+		ret = -EINVAL;
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static const char * const resize_status[] = {
+	[WB_RESIZE_STATUS_IDLE]		        = "idle",
+	[WB_RESIZE_STATUS_IN_PROGRESS]	    = "in-progress",
+	[WB_RESIZE_STATUS_COMPLETE_SUCCESS]	= "complete-success",
+	[WB_RESIZE_STATUS_GENERAL_FAIL]     = "general-fail",
+};
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret = wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		goto out;
+
+	if (value >= WB_RESIZE_STATUS_IDLE &&
+		value <= WB_RESIZE_STATUS_GENERAL_FAIL)
+		sysfs_emit(buf, "%s\n", resize_status[value]);
+	else
+		ret = -EINVAL;
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_status);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1549,6 +1678,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 630409187c10..47344d58d9bb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6167,6 +6167,21 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
 }
 
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode)
+{
+	int ret;
+	u8 index;
+
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en_mode);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(to_delayed_work(work),
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index e594abe5d05f..0b806c938f57 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -181,7 +181,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
 	QUERY_ATTR_IDN_EXT_IID_EN		= 0x2A,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
 };
 
 /* Descriptor idn for Query requests */
@@ -455,6 +458,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	= 0,
+	WB_RESIZE_EN_DECREASE	= 1,
+	WB_RESIZE_EN_INCREASE	= 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	= 0,
+	WB_RESIZE_HINT_DECREASE	= 1,
+	WB_RESIZE_HINT_INCREASE	= 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	           = 0,
+	WB_RESIZE_STATUS_IN_PROGRESS       = 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS  = 2,
+	WB_RESIZE_STATUS_GENERAL_FAIL      = 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..50e43a9f2530 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1454,6 +1454,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
-- 
2.39.0

