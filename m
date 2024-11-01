Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2073.outbound.protection.outlook.com [40.107.117.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B84158845;
	Fri,  1 Nov 2024 09:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.117.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453617; cv=fail; b=i7tpp5vWGKiQv6Gpl8nJULvgp9F68OJK5ll8kXTcAsj5zFAox0qdHqmiLVKVExYmBE6PZ72dghnWK6bVk5GvmpoGg7CRogrtNc3dkaaHHihIfiKRglOSVLqEs45gGGIgGMcSU3SbKYqJ8br+5jAauUSbemfly0Nyr4V49A3klDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453617; c=relaxed/simple;
	bh=Gxp2vn354EP2yKTUbsf6J4DXuXiZ2eMRr8r2xr43F0I=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pQIaeXkCyBwfOr6/UgtgIqpYej8WRVGPs0j0Vt47p2LeCPxLz1JMbF8Tu55er8FDFDPFIUKGM7HsV0IC7Hp+OLHMLzJFD5AbDnYHyL/v4pkM/rgEt0RLfUgHX+LKXLkG4aHy5o1Rj4VRrDoKyilavCrXztJnuiG36lvbgj+V4VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qmss/zAt; arc=fail smtp.client-ip=40.107.117.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qmss/zAt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fh0VJyOGlfYl8XNsmK+Sqqv2LAUCfk9AMgKgojv6KNGlOtmwjhCVcAXdJPJaosGuoT3MCp5zJ66dRq32NjQfVxz7Hcn1N4pcNa4pILkTxSZK9WWv05cdKoJ+ZD7y9bLKMJU+leNVKvMDWdpKHJv/dDaYKolrpDkPBTgNRBF2yyBNUoeb6J3Vay6A4VialRnnvTeE9VZtCg/n8Xn3Z2VczTHLU9vK0mFRgNOtQdr4zGp94BBsCmvddItyITMu63RWsQXyOnynCCXg+RxBRgIxuRhlN0GvQbLCN3F/3UVo4BRuny5SEvlO6ShqMHU94xqi57KMbKxnTCFy3LYuphmoPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bX5NZCDOg8lrUUjSdvfzt6AISx/Ma0gT+hbbdjtgiM4=;
 b=Kx1x7zu5EUpTApWFc8h5uiTC9Q8GruznM3SRrTpFQaH0gXwJRQhtO1F67IwshHuiY9lZyIsA7ggpoBa8pjHp5Wiv9OdUxqZHha3DVN4pia5vKqfOxVVIiem3teP9/njzrneHyydAtmLk8IpU1UqFDdNkSMZnPaOIuNfgzu/BfTeQ9hx598oTawZUPo9brj3iNkfYxEWOj8c3lX2017aJuLADqYLusXB3fY8hm/KHeTEb8NBjVrKuHmYJrtMEbHklAsFKSluM60UB0L7Vsq5zpJSVYukuOXcFqoEDQ6yRWsgZrPipzRkPv7Mo3RdEkGAIuoJQyTIufpqQ4aNjPRd+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bX5NZCDOg8lrUUjSdvfzt6AISx/Ma0gT+hbbdjtgiM4=;
 b=qmss/zAtyZmD4iBVTFqUEQnA7obgfiir+zb/RKsP5jAP6DjdudfD2MMOXZ6r2Vgy5CBnqZwwqhFPY2weHMuptMNKRoPXjyJr3goWiQ2ASGz/n3AU9wBCuzH5kR9rEXQ/EbpUVIauk608EROOmYiwepcsWD0s8XZqU3n9xdGU2Xkjevy6jVEo+W8lU9CgHXvCpUkqCGu/GU95NEf+LCIE8K/OO2KiI4cQ9jAico9gL9BcP+aVaQo9adjqKhbjIZqDdxqMOGrzmYmSZPVFHnfeLaNiHH1xVcYNfhgOf2V6wCysDc+m0j9lDj0zyE/6pLr/pYwjPAc8CvewGNcT2EhO5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYSPR06MB6923.apcprd06.prod.outlook.com (2603:1096:405:35::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 09:33:27 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%4]) with mapi id 15.20.8137.008; Fri, 1 Nov 2024
 09:33:27 +0000
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
Subject: [PATCH v4] ufs: core: Add WB buffer resize support
Date: Fri,  1 Nov 2024 17:33:18 +0800
Message-Id: <20241101093318.825-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYSPR06MB6923:EE_
X-MS-Office365-Filtering-Correlation-Id: f6aba4ae-fe65-431c-178a-08dcfa583d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zX4nEyuAVMuTNipeNAERZO2ofZjZ1oHAKTqdsbmn92/PR9bTCm13abW9GuFP?=
 =?us-ascii?Q?VOGr+x7u0dajgL7vNcUCUCiguzDGdFofeli6ml1Oihw+MuAfe4raY8WILscc?=
 =?us-ascii?Q?4bvjTvqfLt5PfWdUP+W+dvxWF77+72YimyfsTLYwdFOGp2UXkU4Ip4KnTwVY?=
 =?us-ascii?Q?lH09MFnPlFkfUaIum/SUvJm9Gag4aA9+OC2Gt74fYgRLKTQ747hY/Oe+ym85?=
 =?us-ascii?Q?74TQ8aLmx72AnUlNpHpRftuFdXqD1Ft/BB5VB1WeDUsLu0JYZZaZYWGRieFt?=
 =?us-ascii?Q?IgJcxtjac5Pz+y8hFBIk1bdO4pu0UD6AKmcLnq+C8u2PFa5Q3LRSk8B/D9Vy?=
 =?us-ascii?Q?fThAZ7e07oVfDPIPJ0epc0vacvxkvK1TO3iNZ1L5bp8ljX4HwXowXs/C8qVh?=
 =?us-ascii?Q?BxRw/kDlH4XL2hy0GWY8HvmMjbi1xBbm61oaWvD8+igXA+7MXQypHf1iJdqm?=
 =?us-ascii?Q?atKYJqi/V7auGkmeFKx8iN6obSW/OFLwWA/JFhf2Inr5Z1W2Z7x7wcyjS1ps?=
 =?us-ascii?Q?QBb20RqLIQ6pRmo4bSN8k4wtwdzGdhXBUXvd9CpYwPNcnmqp0fjPmDMLVZdh?=
 =?us-ascii?Q?ybO9XJPGMz8HnGhxu+WVo+aGn7Nxyb3nlSuRdlPzg441oOpJKJKGscOuv0ON?=
 =?us-ascii?Q?YzkS6mz/D4dkO+zMhV5+tjiXNj21Wg+rjuyzd5AFqdu7aHs4iDk7QGGg+Guy?=
 =?us-ascii?Q?I74P3xJyEXiv5+1wx3cqg812cT3Cz5xi9Te4fWt3TrY5fqJ6wWnsk6scVorQ?=
 =?us-ascii?Q?smG0A62DTl3fXSBSAsxYfE2XFqlEaHNOoNaniyh2jCAuOv0nvNTh2kLF9yz3?=
 =?us-ascii?Q?xuxDCw57AOJr5CL8r8N9Qkxz/o4lTk5uZ72pOImTI6a8x7VgEKoQ3MmQdOe3?=
 =?us-ascii?Q?+n/Rjy2rQ0y/zM8Ev5D9cweMzS80a7LEkYsn2OlRvfhZ9TjoCEndOI7CxW74?=
 =?us-ascii?Q?TRlteRCWQlsTjfr7b+4RiVungo2N7e1NjQB8qYUW6Li+bV3yLZGR6/6wEX0e?=
 =?us-ascii?Q?hIUQ/ECXgOovo6MDBCAXeXH/6Cb+1UVMej/ZpNUToIcxJ1naxlvwwZ33rl+T?=
 =?us-ascii?Q?DnVByC5Rk72LCXsQ5Dos3sMIi50n+33uz/mmdW6SWwEOBr6+FHRXABV/v0e+?=
 =?us-ascii?Q?0jo1GBAI3HoJAnWORTP0QzAIICr11SqEmfazY7mPz/4PCX34yPqId7ojfxdA?=
 =?us-ascii?Q?+MS98waXn7Hbm2ZJWoWVfxP5CqXsMjaj21Tn0hFKsFDcASkOgtSwduAPdxx1?=
 =?us-ascii?Q?Wq75Caf39UuiuBTq8ee95iFOiohHheXfdyptJbnPWdvPdOcp/Lurhgji7s6C?=
 =?us-ascii?Q?LZ1iE4ezXoGYxOYxrx3BNNjJMtgdp3ac0yXFSBbMXsF/zi9Fv743VWxEKrZ/?=
 =?us-ascii?Q?I/q9JoyMX61gnz4PJMHokWzOD+5QRLK0EhD9pdWmJz3ZhTdnxQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r5x4wuQtJ0AmtdcLSSHkrgKcV9Jc3AC1QvNstKOuklpn7oGZBzOOeUkjTvb2?=
 =?us-ascii?Q?F69MqvBys2tkqIHhG9CDkTKyeJ0Z42bvzrYizav8AWS7dw0zTCV5uER4NfmG?=
 =?us-ascii?Q?wYe1F906m+yG2jNRHF0jT+bxp7uXmZPjOKBXVA+tCcc6wGXx9ZP3axit4cb0?=
 =?us-ascii?Q?L6hcpusBPg0aVrAt1VsHYSRirejDwe17Ppy4DFTzwg8xcNhU4/AaP1yXE6V3?=
 =?us-ascii?Q?rTC4HDLAro2zh7Y0JtuvHRpln7/3U3sIgCtxddAklJmKHX1EpVn8+IMdGye5?=
 =?us-ascii?Q?ZG7tbRoWpQytyi6N/lypjDCov7FwL0gXIZe4OLRi/JN0Kt58KH43cRsAedfM?=
 =?us-ascii?Q?rIRE9Ba3Ymvc4dlP+wCXi+maMB81sI0+cjkaGlHDbUrfo24DDPCGt9/XnJ20?=
 =?us-ascii?Q?hWmBwPSDY7+LPLJMdJ66Od8t3h72qTIbgVJPqzoF+AzJdCso5qzR3s4+Qvq+?=
 =?us-ascii?Q?X9oX1n6TP8tKAz5+tkQPtBH2BBHQ4LRwfCmulkplgP7WaAE+MDtX0Vgk2cM0?=
 =?us-ascii?Q?ELTFqslQ4xdKjhlnvL/zoXMF9EEnZkWdtUBrnnm2gkuOuGebLqJdk5WNFhjy?=
 =?us-ascii?Q?a6LMGPLTts1+fSTZbSYjtlqIu8FALmitLEv0YwG4dqLth6d914VDcLxpDvGM?=
 =?us-ascii?Q?YI9cZgpjOD368f9K06ENvuxIBU3Ibrs/iAGCn0gSTWuJJ8Yc0qNoi6dzFj4a?=
 =?us-ascii?Q?PShoU3jAo7/73wp59NiTMHSopPe5svnQDeknH6DWVHVylmCxSnwQ4NXjavnJ?=
 =?us-ascii?Q?8BH1UGaL/+OwUbDPUPoOC6+4tomNtUuop9hjvHvHHf/sXpcJjDV/yNNnvksW?=
 =?us-ascii?Q?aFZKss2ZnZF0uxmik6qZ8RKLO+k9tBAjn06QJ+ogV8Z3mm5gBFBalF5YdgxA?=
 =?us-ascii?Q?PY5fx8oWBuR5SNUwBiVGT9rjWxkImXzhBj2fUmT6dP7/+3eSsCkzteOf4100?=
 =?us-ascii?Q?J4szwcgF8kst+w+iSi4Z+IDSI0bwbUCG0IsDxD22v8GKCPWxVRP2iWff5Zct?=
 =?us-ascii?Q?EAoITTKia2Wf68gR7f22h6Sk0bGmCtmQ2KDjYAaZOQ9NIKLX0N2bnrfsha/b?=
 =?us-ascii?Q?wj0czNuOa+PqPTco8PZHb24w4njpaSysuXTcdxbzOsb4FCkSv1MHCw6k3tLG?=
 =?us-ascii?Q?IQ2eCjcniVIPm8BeMAEplsIKzMgeghvDV3MLlxU7Ud8zXREQloIhPJxmi92t?=
 =?us-ascii?Q?vxhaUUl9ao2scb5DxfwlmWU93yDAmbHaciRsxCZ1H9umCBrjsYBQg+82RoN6?=
 =?us-ascii?Q?gYioozGSZFFOvVNE1BKaAJHt+fIULBVhhk7NkVkhm5Jw8iBfBl9hq1m3HxZq?=
 =?us-ascii?Q?qn5srtov1I+TUh2QjxMsKv8e7XxG/I42TmyyqS/QoAj7CwKGBYZWZ11fhyhT?=
 =?us-ascii?Q?J/ZtB9d/xwxa3bh23960R1PG4ot4q4qCHkO3DpLJEOapb9qLyD+vF2H0nwBe?=
 =?us-ascii?Q?UpZBgYwKoFkCzfTdZfjkSD7w9Zeh7w0cIYZ2JG9fW2QvA+IGocvVSnB3g4i2?=
 =?us-ascii?Q?3/6Kcs6a44CtRiTDJY56VzaQi8W6+7qB1Fwkf6Xtb6b2FraUmo76p3U8ozLG?=
 =?us-ascii?Q?XKppj6k/TBvQyIY9/V7YF4Dtf/fvT+ecNKlJDEUn?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6aba4ae-fe65-431c-178a-08dcfa583d43
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 09:33:27.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DqqyT1jpE5Ob3XXPEby0b4PA7b88MEq7UKSO+0w+4PpnYkawOE4Q3vGAkA4IWQIV6B46nG6P4UIpU+45NeR2Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6923

Support WB buffer resize function through sysfs, the host can obtain
resize hint and resize status and enable the resize operation. To
achieve this goals, three sysfs nodes have been added:
	1. wb_toggle_buf_resize
	2. wb_buf_resize_hint
	3. wb_buf_resize_status

The detailed definition of the three nodes can be found in the sysfs
documentation.

Changelog
===
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

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 51 ++++++++++++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 43 ++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  | 15 +++++++
 include/ufs/ufs.h                          | 12 ++++-
 include/ufs/ufshcd.h                       |  1 +
 5 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..5908a45cc7b2 100644
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
+		======  ======================================
+		01h  Decrease WriteBooster Buffer Size
+		02h  Increase WriteBooster Buffer Size
+		Others  Reserved
+		======  ======================================
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
+		======  ======================================
+		00h  Recommend keep the buffer size
+		01h  Recommend to decrease the buffer size
+		02h  Recommend to increase the buffer size
+		Others: Reserved
+		======  ======================================
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
+		======  ========================================
+		00h  Idle (resize operation is not issued)
+		01h  Resize operation in progress
+		02h  Resize operation completed successfully
+		03h  Resize operation general failure
+		Others  Reserved
+		======  ========================================
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 265f21133b63..0399893f3245 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -411,6 +411,43 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static ssize_t wb_resize_enable_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	enum wb_resize_en resize_en;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en) {
+		dev_err(dev, "The WB buf resize is not allowed!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (kstrtouint(buf, 0, &resize_en))
+		return -EINVAL;
+
+	if (resize_en != WB_RESIZE_EN_DECREASE &&
+		resize_en != WB_RESIZE_EN_INCREASE) {
+		dev_err(dev, "The operation %d is invalid!\n", resize_en);
+		return -EINVAL;
+	}
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_wb_set_resize_en(hba, resize_en);
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
@@ -1526,6 +1565,8 @@ UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
 UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
+UFS_ATTRIBUTE(wb_resize_hint, _WB_BUF_RESIZE_HINT);
+UFS_ATTRIBUTE(wb_resize_status, _WB_BUF_RESIZE_STATUS);
 
 
 static struct attribute *ufs_sysfs_attributes[] = {
@@ -1549,6 +1590,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 630409187c10..ce62dfe58e9d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6167,6 +6167,21 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
 }
 
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en)
+{
+	int ret;
+	u8 index;
+
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				   QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en);
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
index e594abe5d05f..5aedc3db2943 100644
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
@@ -455,6 +458,13 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	= 0,
+	WB_RESIZE_EN_DECREASE	= 1,
+	WB_RESIZE_EN_INCREASE	= 2,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..1b84cbd24879 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1454,6 +1454,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
-- 
2.39.0

