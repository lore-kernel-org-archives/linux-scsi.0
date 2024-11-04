Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2075.outbound.protection.outlook.com [40.107.117.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD7F2AEFE;
	Mon,  4 Nov 2024 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730730297; cv=fail; b=k8tAb290M7U4rbeeGSvY4rJBVCV+6DZJ/4nJ9hC3gNVyPo/3DrWgpQskX9Bb9XunmnHp5fvAZOTDHeQ4VyQ0k82pRbNwN7XBq9w/3MrG0axw0/moY/076vAiB7/4FNn/yPaTFdIREcHlTyNvGDaJyFu7dDNPiN1grlK/leG0wGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730730297; c=relaxed/simple;
	bh=m3ExSKuik3V9Al15agmEjxGbJNbymmHZlNZBDDzGzts=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=uMUlboYbXmTYSadFxu/LcAPsI9QRUT/vpoNN9eGRu2NXJ4dEEeEMU1aH6HlOyiVayCWrlESLSnzBIH7s4YDNR4UfhGWZ7gR3pDtFDmRPqkzpUcyE/VzVchfnyTS9EBOmFqeVOAzzN7BPrYxi6dsX6Y1BhRXKgdjKDVKoeX6fe9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jHkFbIwu; arc=fail smtp.client-ip=40.107.117.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="jHkFbIwu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wSBT5s8TONMvGO/lYuV4KutuZtr5RF2eAoJV3zf/2W2cQSvCvcm0h/D62swuozP5Isp8lYj2PCt5Ysf/QTL8JJNfzy759gVV12UuloHJY/hNIw+vnGrqrRntvE90ABK+SdnvGm6BJsTxtQkk1jfwX1VFBKMB2Ym2FFxlottjs3karsmdWclYKP4h2rUE3NyZGroNcbRGmmIofBli2k7wgzi+rqMXxGpNraqgTYtrxq2mY1LTYi5cbof6HNHqN8APRwMsOogBIQjW/YfeUAnNnNturehmi6HRNff4E+KqOWqGuvNKKlUUY2lrj2NCFSiKaUGSzgxWiVSaFtZML9FO2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibXoKhjpgZG83noa7+Kz4vS1WfsbZErpMjckOHHgklw=;
 b=SKBQNNwg5c4evH3UaFz7ULZfad0NfWUmx8CklHD63etOHqVzjaTBNHlfz5MrutYYxTk2TPGvK459IFbM8dNd38ghKQimcBTYzj0H5wH/avOXQn6Svaw032xhCNb/U3F6rsfkgRjhkv50lO5akVaKXIxnUgzdLp6wA4Cq0S5tRiemLhrgkKMQOJ1zSM80u5tBb6veZqLMMJSa8DHwpDc0jYXqwsds3wh+sn+cyZYnkFBAmQohrJk0II1xDNU/TKB6kBkVOffP/M40g06pg/yoysWPWplJnhFCfn3ErQb7tIp/mIfj34w/CYKBfoNecKPHK3MZ3SKLJwTLLDvPidnYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibXoKhjpgZG83noa7+Kz4vS1WfsbZErpMjckOHHgklw=;
 b=jHkFbIwuyyhA5/wjTa3IGEl6BGkgXC5P59OwZlZ0mdqEli07iGjtyqnrPfGtY1aVtk9cWFc/kybVKHVluZuyYlG+Ut11nIQG5uKNRbWHnAexjWLAhhVtP8aC1Rhcko8y4GsMYdAylMilZCAtfVWReB7DwCZeJf+aLq0n+wOnREPmCaK4SuSl67dutCYrbN+Q/vp1eWNYHNI5oJHEw/9yBFFBkx8gQcvNDnsUY2u3NPE38wKk6ZEmvGdUL4m0ePONi3lIflfSNj2dsellbV5AxeDFGUSmy1qcS39rnTpxHfmJ/fFaEt0nkJCJGmn0QJG4MeB6Wf9p/0gqD/Y/hHyW2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB5502.apcprd06.prod.outlook.com (2603:1096:101:a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.10; Mon, 4 Nov
 2024 14:24:47 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8137.014; Mon, 4 Nov 2024
 14:24:47 +0000
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
Subject: [PATCH v6] ufs: core: Add WB buffer resize support
Date: Mon,  4 Nov 2024 22:24:37 +0800
Message-Id: <20241104142437.234-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB5502:EE_
X-MS-Office365-Filtering-Correlation-Id: 930a9597-6ff8-482a-959f-08dcfcdc6f6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|52116014|376014|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VRMGe8E69jOt7OAVSYo05lAY6RCw9DlFkqsHDExJ2728qhWJWwWlnJtZaXiI?=
 =?us-ascii?Q?z5Kup77CxpGd4WewMD0vHTHe0M2MdhZv9pGFaEckVWwWrLKOp9/O6i8JJv0J?=
 =?us-ascii?Q?a908qHVf31C4gEz3+yu0uhoHeqmyg4Gk825zYEWVlAWc+j2Zf3vANNKtOX3C?=
 =?us-ascii?Q?wi/VmCzOkJXvaxLynFwBZM00exaQnzFBOFNl+NZ1IlJX8RT88lateABRtYCU?=
 =?us-ascii?Q?3xa3saKr6t3I+fprvjP+9lddJzVT3WsXTAGbIZMDW0EU9WYPkZakLVdKyBKf?=
 =?us-ascii?Q?Na1qZ8c2QwdhJMY7R7rOaerQ4tk+aAwTOiFnNnDxt25FvIXFxxVCUbSkdip+?=
 =?us-ascii?Q?i+P40sEPMKHoiywLS85bQGDwv+KcZmMwmsNUahkJvJLBZzxptjxvHI6g3qu2?=
 =?us-ascii?Q?WplxJnTAWy1ddyCi9k/t5W43ucbP9EIbTsZsOwUDQ1W12Wd274RXXnWfPXcl?=
 =?us-ascii?Q?t7gll1c288mxiJF01I3mTzQw/RsVnLHuHfxyY9E8JBC9+XLW7rhVcBy5humJ?=
 =?us-ascii?Q?ifYcE5xG+fufzkKDw52KLXajQysURJxHLACEcn8Wj0E7UcPEuqiFlOq/xC50?=
 =?us-ascii?Q?pd/1GEqWInbAWogsFL4qiakec5T0TnSlAn6ryAgqyP2ARHj0SHMWKFroORXr?=
 =?us-ascii?Q?i2GKZRwaxuEIVOQ7R7av6I8HXZYwO0kmBGvbEQ3ZMC5jiZmAJaGUoYAQSHzR?=
 =?us-ascii?Q?gCidFt6d2IDIYoj/0SW3n1d8hHfZttENPTO1Yj4FpLKJq6TaMZpwjVHOZGD2?=
 =?us-ascii?Q?5u0/8PcOqre4ndV30R20cUydHKJUPKGX5DJeMg8LOfEBJqUrA/8Z3dhHTB+y?=
 =?us-ascii?Q?nmASvXl9RKfSHmPw+AW2G3IQeLtpTnATjE5IsVHow54Wu3/Z3ybZOZrP4sH8?=
 =?us-ascii?Q?ho5dY+NslSkk332qsSPNeIaJcvXuCgvbb6mZ3KvJsap0Qw36XViRLBJUNb3v?=
 =?us-ascii?Q?ENcnRjNraZnHFNXl/ODD1/OIGktLEmXAliNY03ywQxcJMicwxYaCpMOcY0iF?=
 =?us-ascii?Q?hnVi2EchlN2xe7HnNG3Ih2N027+FQCQwckak0XTyoonasROdgdJDrZ/bi3Yt?=
 =?us-ascii?Q?AiQi+1Ec+aJZMVVLF0WbWKbe0GJzT/w+OBmONZDyoCWOhfK+yj54fDZPs2cX?=
 =?us-ascii?Q?VlilmkMKa/ne44en/Wv3DU489Gz84PP+JSaJu8Am9T1XUSz2Z3ox9EX5UfOd?=
 =?us-ascii?Q?vgHuN9Mr0ysqZ8zYCEpjCJcEejsRJHGrNCrEOJDM0FjVNqPhVSTrvNsf1SsU?=
 =?us-ascii?Q?I9wPRKsmdeeyYovC/5a3IzM7m1Rey6uUWjCZEgOhz/M26E493fQw5T38nrGH?=
 =?us-ascii?Q?Nt4xe/Kf4W/YN7SFSc3uLYD3U8NhhvtGVR4uRUeVJJPI7D8OvnHTV9ugFIja?=
 =?us-ascii?Q?Mv5csHCuxw5iV2pDC4PYvcF2LIRVnnBwZMDPDiL9foGMZkcmAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(52116014)(376014)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Bj1AhPTqVaqzLzk7G81e/I+dGSRFYrkXixyEZEJhRBT0z/lQdwNx4p4b3HH?=
 =?us-ascii?Q?+ouiXSdXt5Gf860rHwrv866zY7tM/XLqjabT7LkoM6yMS5xMrAPI+Aa7fiH3?=
 =?us-ascii?Q?Ric4nYmrieMVnEz5+5iFWI1HHaF4Uj5ZvWf7SKkMqOUynBuXJTxRztWwmc3h?=
 =?us-ascii?Q?bQB+gLQ4ovOgRx4IV2k97eKB6JroTF+gFlJ8dGKeXDtxPdIdstb0pD2KtCYc?=
 =?us-ascii?Q?iM4hPyELXc6JJ1G+mp8ekNwaGFGEmws+dkxNVJA3RqMfgzrlk1GzUclEFZpD?=
 =?us-ascii?Q?QvzgqPc6/3jJnToqkI7ukGrNW/g74xH8vzbzAxEEoLWUpFNk1gu4OWcZAbgA?=
 =?us-ascii?Q?Lmm2iAT+UTMQXiGbBM4F49reRkVdiuO9rts7ogt3+nGZ8g4Y4VCYraA7yeDp?=
 =?us-ascii?Q?Yy+waQPnWRLWS0SnwAQJaB8lj7UBW+2FS3DsMEo/fXesbi9HxQ/j1vzChyBq?=
 =?us-ascii?Q?AXUQACCjQ2Q8pVu3N28jxICeNfTmiIOmN0VCXEQr/0zJfU4BrpAMfI2PkJac?=
 =?us-ascii?Q?MBU7pkWoM0MpcfO8n2/a8ldIvDD4hiqCjDnCkJ21n7duaMEXu7phpHoawi5L?=
 =?us-ascii?Q?OdfhapSw1s3FHE6zBT1D3RcyiHmmjK6qQ3V1I0uL0bAjdsppsiFa0Oet5NWm?=
 =?us-ascii?Q?cZq95kwrLVGynVum3P2VCKJ8370nvh+j3e76x7jRn5aoKzvpK6MeKoY4uhux?=
 =?us-ascii?Q?lLfn9+SixgrMnDRcpQIZ8ZqxR5h+fo0CH6N7ykf3IkSBJ6uAw7LrkZMnk4Nz?=
 =?us-ascii?Q?ebRRvrNj87AaSZoEKWleKKsxaFxL0bVkJHSUyVwH/1VseB+J61uNqRflUT3M?=
 =?us-ascii?Q?sZO5Stpoz3J8ny+P/m3xjnY1MVK5x9AS/kgO+5zZ83FKnn0i1WI/Hz4YiDnb?=
 =?us-ascii?Q?KvV55R4U3pxJ/V2xmnFlunkShvEA5WG/0X4a77/eti9Un3vLDbZG1RE5St1C?=
 =?us-ascii?Q?xpDPz0+YaNO+af1aYu830dqPdu6r8RnvsscDCb4MVsZQSSXcjTd4ZZ0n97K4?=
 =?us-ascii?Q?mYyd3QlqwUTz/xiqOHHoOrzX1f/Yp6DVMrKspWYE9Oq62Q7G/u6IZwEcaZVJ?=
 =?us-ascii?Q?NdBFfSsxpoxT9p/5ntGZ68TWUrNY3nd27yo0EU2ZGdA77HoaMmO6AOHkunbP?=
 =?us-ascii?Q?Ym/nrNLA43ZbuKzyipKJM46en9bl+bdHhhBg2dcg8r0doPlOgHMqWBbTQALF?=
 =?us-ascii?Q?28/VZwExe7Z77OYTyZ8L7BsJf3eB1u2PcSyl2CF7dfPN2q8eSIfnoe6g1TVO?=
 =?us-ascii?Q?Flx1DxZCMCTzonSJF4JbhFoEeFzRA94Yl7R9YySpdm4eIt6H+IQisGSkXAqw?=
 =?us-ascii?Q?PG82PiiEdOaDYAIDiej4MGpxo6Qtk8elfyWwmZ5SrHLLCILXBfaZAOO6VLFX?=
 =?us-ascii?Q?raVTq5OO1vOeCPnAlhvDXTHbNZf1P+vpXxc6RP/k9eWcudOKf99IOkxWg4TA?=
 =?us-ascii?Q?v6gvPPzDf+eRzGlt911o+8BUC9miqlGWBsudwzGnDmNGyfd6NDRKFfWsk3mM?=
 =?us-ascii?Q?4EAbwW8XxI39+QPjjaRtLWheqXAznebYVF/X13codL30j3pQylPJBqHC/Dx6?=
 =?us-ascii?Q?ukGegIxo73ai0woLwjgvS7V3ykIoeCPC7cNEEUzA?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 930a9597-6ff8-482a-959f-08dcfcdc6f6c
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 14:24:47.4076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBpTXaEOV01t+diHR/FKlK6M+Z7xL+OTIaDoQOkdUEpUCh+htG8yMGESsvd2lcIUb3MqzOyAFaZZZiZWYaT6jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5502

Support WB buffer resize function through sysfs, the host can obtain=0D
resize hint and resize status and enable the resize operation. To=0D
achieve this goals, three sysfs nodes have been added:=0D
	1. wb_resize_enable=0D
	2. wb_resize_hint=0D
	3. wb_resize_status=0D
=0D
The detailed definition of the three nodes can be found in the sysfs=0D
documentation.=0D
=0D
Changelog=0D
=3D=3D=3D=0D
v5 - > v6:=0D
	1.Fix mistake: obtain the return value of "sysfs_emit"=0D
=0D
v4 - > v5:=0D
	1.For the three new attributes: use words in sysfs instead of numbers=0D
=0D
v3 - > v4:=0D
	1.modify three attributes name and description in document=0D
	2.add enum wb_resize_en in ufs.h=0D
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c=0D
=0D
v2 - > v3:=0D
	remove needless code:=0D
	drivers/ufs/core/ufs-sysfs.c:441:2:=0D
	index =3D	ufshcd_wb_get_query_index(hba)=0D
=0D
v1 - > v2:=0D
	remove unused variable "u8 index",=0D
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'=0D
	set but not used.=0D
=0D
v1=0D
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/=0D
v2=0D
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/=0D
v3=0D
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/=0D
v4=0D
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/=0D
v5=0D
	https://lore.kernel.org/all/20241104134612.178-1-tanghuan@vivo.com/=0D
=0D
Signed-off-by: Huan Tang <tanghuan@vivo.com>=0D
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  51 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 131 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  15 +++
 include/ufs/ufs.h                          |  27 ++++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI=
/testing/sysfs-driver-ufs
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
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		decrease  Decrease WriteBooster Buffer Size
+		increase  Increase WriteBooster Buffer Size
+		Others    Reserved
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		keep       Recommend keep the buffer size
+		decrease   Recommend to decrease the buffer size
+		increase   Recommend to increase the buffer size
+		Others     Reserved
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+		idle              Idle (resize operation is not issued)
+		in-progress       Resize operation in progress
+		complete-success  Resize operation completed successfully
+		general-fail      Resize operation general failure
+		Others            Reserved
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 265f21133b63..c12297bebdaf 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -411,6 +411,43 @@ static ssize_t wb_flush_threshold_store(struct device =
*dev,
 	return count;
 }
=20
+static const char * const resize_en_mode[] =3D {
+	[WB_RESIZE_EN_IDLE]		=3D "idle",
+	[WB_RESIZE_EN_DECREASE]		=3D "decrease",
+	[WB_RESIZE_EN_INCREASE]		=3D "increase",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	mode =3D sysfs_match_string(resize_en_mode, buf);
+	if (mode <=3D 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res =3D -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_wb_set_resize_en(hba, (u32)mode);
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
=20
@@ -482,6 +520,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	NULL
@@ -1476,6 +1515,96 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn =
idn)
 		idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
=20
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index =3D 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		ret =3D -EINVAL;
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static const char * const resize_hint_info[] =3D {
+	[WB_RESIZE_HINT_KEEP]		=3D "keep",
+	[WB_RESIZE_HINT_DECREASE]	=3D "decrease",
+	[WB_RESIZE_HINT_INCREASE]	=3D "increase",
+};
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		goto out;
+
+	if (value >=3D WB_RESIZE_HINT_KEEP &&
+		value <=3D WB_RESIZE_HINT_INCREASE)
+		ret =3D sysfs_emit(buf, "%s\n", resize_hint_info[value]);
+	else
+		ret =3D -EINVAL;
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static const char * const resize_status[] =3D {
+	[WB_RESIZE_STATUS_IDLE]		        =3D "idle",
+	[WB_RESIZE_STATUS_IN_PROGRESS]	    =3D "in-progress",
+	[WB_RESIZE_STATUS_COMPLETE_SUCCESS]	=3D "complete-success",
+	[WB_RESIZE_STATUS_GENERAL_FAIL]     =3D "general-fail",
+};
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		goto out;
+
+	if (value >=3D WB_RESIZE_STATUS_IDLE &&
+		value <=3D WB_RESIZE_STATUS_GENERAL_FAIL)
+		ret =3D sysfs_emit(buf, "%s\n", resize_status[value]);
+	else
+		ret =3D -EINVAL;
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
@@ -1549,6 +1678,8 @@ static struct attribute *ufs_sysfs_attributes[] =3D {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 630409187c10..47344d58d9bb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6167,6 +6167,21 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
 }
=20
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode)
+{
+	int ret;
+	u8 index;
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ret =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
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
 	struct ufs_hba *hba =3D container_of(to_delayed_work(work),
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index e594abe5d05f..0b806c938f57 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -181,7 +181,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    =3D 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        =3D 0x1F,
 	QUERY_ATTR_IDN_EXT_IID_EN		=3D 0x2A,
-	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	=3D 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		=3D 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	=3D 0x3E,
 };
=20
 /* Descriptor idn for Query requests */
@@ -455,6 +458,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	=3D -1,
 };
=20
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	=3D 0,
+	WB_RESIZE_EN_DECREASE	=3D 1,
+	WB_RESIZE_EN_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	=3D 0,
+	WB_RESIZE_HINT_DECREASE	=3D 1,
+	WB_RESIZE_HINT_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	           =3D 0,
+	WB_RESIZE_STATUS_IN_PROGRESS       =3D 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS  =3D 2,
+	WB_RESIZE_STATUS_GENERAL_FAIL      =3D 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    =3D 0x00,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..50e43a9f2530 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1454,6 +1454,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *=
hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
--=20
2.39.0

