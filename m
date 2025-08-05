Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012014.outbound.protection.outlook.com [40.107.75.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68E1D63F3;
	Tue,  5 Aug 2025 02:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754360818; cv=fail; b=q1dss9La3UhXxF6Ofhl39PEWckzg38+K+WYFgLiNMcpeQ4nTSbWbAgYGB5v0xplM+8B2PXFMGT1vvB1Epr6r5sTKT5WQqbGuJUg0/U3REAKaewB1y40ujIUnRE/T6kOGrr7IpLzJaBm9TJWd/rSuRoOezeQZbm42ZAN8mCL2bek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754360818; c=relaxed/simple;
	bh=tes7HHzT3+jDWTl5PELUbcDD9zV5ULnDJCuIU9EZEpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fOvxlUBDNGRVBJLLH4Z6NSXpkT/yt1L11ZwlQvH1zK12qQgsrTXNcH/032NAmzTFyKrPWZ25dqIpVgBLsJseYrvGIttyH1s3aOkyWNAV8AqtqWqk3Ju3HyMbECOPg39P64+pEBaVtQ/5OfXZ7jLC3BXCH3QHIYZAvlIP+fsX23c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=V2+IInFh; arc=fail smtp.client-ip=40.107.75.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="V2+IInFh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vL5Du6IW/fV7SYUjKO6VRuS5xsC2xSPhGrojXLex8KFHO1aIuTJpGdb+UhS2KjuIf1/i3UIK06d6Vhfg/Hrrjfaf5MFykmHfDcJbEACzk6KQXZFpd3kLpC060CnR+VRgcRbdnLVsqY+NL28r4G9ffvY7kE0S3tL/L/nd5lObI9sSjHk88g0/AVRQgDsvgitYMtWjElIj6FTnUl4jRO+q3OKxTCdeeyixbxz1gghJGaQ9VTZPJ/wpN9kC0bRzAOP/4eeN0ChxHEICd6umsX6cu/hNewGkP0xDa6PrMrse+/9A7Lhr8Ql3Yv+0AbKPWMHJkvnsHv0cPTTKOqRLOm4M7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za/MY/jjAkNrIDeh2z2GrKLssq3Av4k1FkyyaSDpGMM=;
 b=t3LIZHOkzVxJe1Ai3jkSc+kRFdgIC+09k+9y8Z3RAQM0AWZCGQMrN9SpV4zuAAG1KU1BU6hc8V+ocdBp7I3dqaAWBuCHshGgieYoOlUvLTMAPeDqUOdpKSmxaLrbh/tA1IlO3Q4sWsQDLV4IbMpm02Q1h29Dp8FLVnNy8lqjLDtr4G4KsDnJro3wcD2/SeotPIOxOYQdaLikdYK11NCK0BBcKeLk02YBgIBh+p4bZvX17dZlXiT9dZfjCF8n9BzDRi1xp9OU3hqov41mKEC6ig5fpJPUTwJ12zn7tyccsBZnQ/RcVdMVDWhKNYqflNzlPRB2oB75OLEpNzu/QYqIgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za/MY/jjAkNrIDeh2z2GrKLssq3Av4k1FkyyaSDpGMM=;
 b=V2+IInFhV/71lD+2mwD8ZZZWIs0setZwYz4nk2VtkXfP+iGKdUcLZeREPhRXzzN2Y76Gh4knQhJOu93WwM6IWVI1bFHpvziCCRHQ6gGa3grKD/5e5Z7ZFBkGF7xcqJm2uXlT2AgsYOeac3SP3xaYaKOjDa7CqaPkrFqdPwnoOEO4tGN8YvNJMVG27qrezGpkboQawaZvYQS95xk8/BHfvsyQWC7Q8ePRU/5/7y5ti3nm2vWtRySIaMBn9PoMRdjgUwSXCs7+844SToGGH5eE85oA3itzFQd84gnGqSgsKt0g9v/fyX8L6bYx4YrN9jb4kMTn9lGOCOT/2xZiTjarbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6588.apcprd06.prod.outlook.com (2603:1096:101:177::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 02:26:52 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 02:26:52 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: bvanassche@acm.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v2 2/2] scsi: scsi_debug: Use vcalloc to simplify code
Date: Tue,  5 Aug 2025 10:26:36 +0800
Message-Id: <20250805022637.329212-3-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805022637.329212-1-rongqianfeng@vivo.com>
References: <20250805022637.329212-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11)
 To SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b1b156-7e72-4f9a-79c5-08ddd3c789f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y/JqIYYCDzG3RQUfuTOmVshr1No0eZWQLb2V9h/f2GzJUgdlM4PewOxlzQBa?=
 =?us-ascii?Q?aza2GUxzb1K+TCNKxMPWXjcI2CYzhqo8QKvXqCah2j9xbUMVfOVya6bJrt1g?=
 =?us-ascii?Q?jVVKkb7symoRN5gCxDcZJu5NHmPhK5yImNHoxoB3VQdnnkx4bloPPjJVA7Eo?=
 =?us-ascii?Q?rZpf0g6ACmlCW9LKQACMSUAVm6lkNpxv+GXm+YAx61nZXcAzF+FBtgJjFgsI?=
 =?us-ascii?Q?utVXl5cghJFvNz/clRdJbcFgt7GwFKb78ymQYDuW7mOQm5IPxrr2dZm0satr?=
 =?us-ascii?Q?MRj1KfI81MfDvtYhVoMapTS0TkR278Ogk8ViwyE+2kVIRK+1UXQDV536bdQ9?=
 =?us-ascii?Q?NOb7MdyXjogXpaEWwq9P6Bhc/SKTcs0lgHQG9qJv8uz39JC4uh9rYsc+9RCA?=
 =?us-ascii?Q?4iF/wjySeUolG5PTwabbxhDIEBYZ4VYQxKDfVWxWPRq0C/RuwwmEhsbLHOpw?=
 =?us-ascii?Q?D5DAFVXChDskjfqAVg4YBt+XNzHbizLgiw2MBWroS19ZT7LsVE1lpEpgOxEJ?=
 =?us-ascii?Q?i2YSAkhkgycklcQNTBvz//veM3QrFLLDryuMyWNeJlJaP/lJyk11cV6iOXGW?=
 =?us-ascii?Q?pyMeoSck56ec1Q13QLZMKPfv9bFeChCEQV0TZnf9FR8vHI4Zdk5DL2J5bxeK?=
 =?us-ascii?Q?2FcNuOxFuGrGN4UDM3GtTUBJZH2pSl9PipaoqfXMxKWat7eT+jKUyJmHalSL?=
 =?us-ascii?Q?xmyGuEESoFjt3//yZogkhusXmVN3O9SJVSSmxQeiIsuC2JYhXCWBq5n3y8Xl?=
 =?us-ascii?Q?OpOiJZi+Tnh+Wcx9J/jltSj/B/C9XKm710S3/jKyeW/vldKjFLhr2PSMxmkS?=
 =?us-ascii?Q?xuL9mNBFXQvRVgoGAqygjK8o3+MI5czzke3ZQRv01/g2QZ3LhKPdO67SgMv1?=
 =?us-ascii?Q?9OdjeK3r11eROyRNoPpG46zoNM6c7Je4PzVTs/lPXJ+I+3C1djwlkIayXc5H?=
 =?us-ascii?Q?laLcTSySt/1j9Ag3oAzOAcIkn7+nEtjIIVcbYEGI5WmUwn1dDpDWmqTaZ94e?=
 =?us-ascii?Q?W9o+OO/paVhtAGeBdteEeKdlFbEOenbVtmxhIxJ+gd0OmrRfPkp+wGNUOYJm?=
 =?us-ascii?Q?AfxypY4mC9r9v5+av5qzd62E2maDZBtHQ9egAdvsAVlyAgCV4IaXrSrimKSL?=
 =?us-ascii?Q?35WfEn/7z2P7VsJxf8KFPgDNd+6SW9QAa1O2Wog0oT4I/3+CGaF2lrsCIi9s?=
 =?us-ascii?Q?FRg/+AxTDa7ob5+969Iv1aXBGD6tmEBsslq7dS2kRNERU6srMVahXRL7184z?=
 =?us-ascii?Q?bUx+JQjHKL+IDuV5KLAAuf9AFHCGXDgB99jpokogJE3bedEs1qSqz3WheY3p?=
 =?us-ascii?Q?HtbmW6eYZ/+vnoRaBlsFJjd1hPQt7912V45hmi1ZlAmtYRH5JeJTRYV7GV/Z?=
 =?us-ascii?Q?vEFm0vIxuVYjK/NKejuDZlWbS0VBpgTJsxLl0JcSxi2CIt1LJiYMC2b6PDju?=
 =?us-ascii?Q?o0ZN/MgPcASmTAly85aInu7M5E/5lfyG38Do2p8Yfhk+tmT8TMyCRw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qTqxSi54XiG4QE4nZJtmMgh6JggMwgtidqbGlDp1asG70CZgjZb60WtmdiN9?=
 =?us-ascii?Q?CtpU95R+NqkiFwKUhpyllER4c1xCJDoiFRZqiP7q25B6lhVaXUZXPcOZiYBy?=
 =?us-ascii?Q?wh4NPfi82gJ3Jyv2nIlaZWQ7d+oBVv7KNrf01ixnq6jzz/NUnflnXeK/cQn/?=
 =?us-ascii?Q?vWoBUmeuvmd/fAtusB1FVQjuS1obcKmgO7u3GEtwsIAnzTxR6NFUfYab7NZC?=
 =?us-ascii?Q?wJBywdkJK4GH3BebKCLtZY50GxKhIkZOmnV6gQpZl2YM3KXgnBJA9LCaHuCE?=
 =?us-ascii?Q?TckQqMWHBi1wDriJe4daHJUEjVwyMiGzOiTZZdvfm9lKa+xyAgwQZ9u7jI9u?=
 =?us-ascii?Q?bd/z9iZ5jqNJqWpsbiKzUMOamIi/eUabxgT1Kkt5lIuF6YNdxYJdT+E2b1mN?=
 =?us-ascii?Q?wtfghxiYXCjmlijDUJVud4W5CkvWzHMBgqVgG0wUtIwkmipuf2dw5k16nrMr?=
 =?us-ascii?Q?1uiMxtbSlzmsW3QR1ZUH7PyIc4WlHz0LGaYf6hXfftGt48keP970AEvz23gj?=
 =?us-ascii?Q?cErPJSG2QaHTyL1ClTUnQK9wb9ygi8sb7SDF5lzI6qJLyfLEZsnrq5sGufR2?=
 =?us-ascii?Q?HrubfKWgXpvs23gt63+HZ7zlYMvkd1e/U/WcXYF8c+9WbEK0L93SsqP3hmF8?=
 =?us-ascii?Q?tbg6dcAY99P1tqv2c4b3X5WtKW1v1BDc9PYcCKYuF28hIf2o9vegftY7RZhb?=
 =?us-ascii?Q?sCH7TV3BQl7ek5Y6pztOdPx8flTxb54QjR9AhAJXGDfLCazv9xtteDta4sTW?=
 =?us-ascii?Q?dXQbQKh4Dh9Ruv+RY8hOzA1DBeDkD0N6+B8SW7X2GLjhlRDKaKcOl6O1tMmz?=
 =?us-ascii?Q?HB3F8UhAnJ/O/VG5eujU93lVxP4Ry5vUm1bLcurJ2B1BRtAFRXVZ0SCBeKu6?=
 =?us-ascii?Q?6BkJUUv8cH2/zDr5oOG1zpir5a+KYjAZXSf/4bIQIH6GwNxRWnOeaerkeo5c?=
 =?us-ascii?Q?qrPcgQfi/S3eCgGWSEgKnQUMnrJOpfOOJIjxQ1T3pKlIxssIiB+hNL1NFvpA?=
 =?us-ascii?Q?ofBJjI+OzWnllb+iWk7Wn9nV+f6V80uO6Ql6zXmqpNjZOde7zcAT27gsLCgn?=
 =?us-ascii?Q?tl5iag1fo2cQWsySxIzDrHo8cn1YB0BEilW+l1nF06UIQIE9ieb99c6LIwxe?=
 =?us-ascii?Q?A3iG+9kw25kquDlM0AA0cXUVl8fmALrPzTiYsYUXbUcQAPmirztjmtNA+8mi?=
 =?us-ascii?Q?a+LOojdKLU2aumxAItY9dUS7LRMe9fQXB1D6829x2bPOOLpoy/ttqdxHg8fp?=
 =?us-ascii?Q?+XkqWBssxG86DL7s1ZA7NaOggWHpOz7pSJTAfoIswjxARUQaSHlaayopVVb4?=
 =?us-ascii?Q?FOOXNSCzRaY3N4VzksGJHdoHeRP9SPaNm5rRHx/BhLDuzeBmkxzuQ0dMcG/B?=
 =?us-ascii?Q?Hpd/XO03Qk6tf+/yeXgFAw2BxVOe1ej9JxeF70uPkUAUD1AnXJbLyAs/PNU/?=
 =?us-ascii?Q?GOxX5dtS1PpbKastKnTgpxTA1C3Xhdf+690e3/F623FbSaS4WMr3UTu51wid?=
 =?us-ascii?Q?0Wu7J5y4W8nNi6cA9GIWa8crGxBFZ/yD61g3ZQymeIrVEkOqyExK564CaDWT?=
 =?us-ascii?Q?mINjPWa9ojes1dqk/HpQ11fMgWCGgkexmMGc8l1r?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b1b156-7e72-4f9a-79c5-08ddd3c789f0
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 02:26:52.4530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHf+mvvCHkxkJoXPox/sNcJ1Vuq46Gww0AO31CbQO6lu7cBmp4IBshNfkctCBwYkipXa7Rj+C7ElYx20nFaQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6588

Use vcalloc() instead of vmalloc() followed by bitmap_zero() to simplify
the functions sdebug_add_store().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/scsi_debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..14e2d6e94dd2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8805,8 +8805,8 @@ static int sdebug_add_store(void)
 	/* Logical Block Provisioning */
 	if (scsi_debug_lbp()) {
 		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
-		sip->map_storep = vmalloc(array_size(sizeof(long),
-						     BITS_TO_LONGS(map_size)));
+		sip->map_storep = vcalloc(BITS_TO_LONGS(map_size),
+					  sizeof(long));
 
 		pr_info("%lu provisioning blocks\n", map_size);
 
@@ -8815,8 +8815,6 @@ static int sdebug_add_store(void)
 			goto err;
 		}
 
-		bitmap_zero(sip->map_storep, map_size);
-
 		/* Map first 1KB for partition table */
 		if (sdebug_num_parts)
 			map_region(sip, 0, 2);
-- 
2.34.1

