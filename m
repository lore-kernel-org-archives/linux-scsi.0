Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012060.outbound.protection.outlook.com [40.107.75.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D6C22AE65;
	Mon,  4 Aug 2025 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754289430; cv=fail; b=GqGcMCkgkGwMIwZpaYEM0mEU4muw7aTCTQgMMRtW+awvL6OUYpYEubALFfF3X7r4t0gyFZ57+tcikdCL7ulLp4IY595c1u+49iPKUl8LTBLlvpjbllvbeOu1I+GZSGyJxnrGaUqEBAPjR8DIOUoVmRoa4sm9zOcC5NpsGC7BUvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754289430; c=relaxed/simple;
	bh=clnBbShbtrCu/SAjiDHxB8Tyado6pRiQVLdpVmEwBKo=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=QTgAcxlHQMh1JQQBLUWulyYDizCRafJ3e8U8HefV9CHApYEcljksCijsjhUs9TCypFnBaJ8+KBhIxmZDtaNIh7hwDXBnY7KHKdfWtQosD29CEutgmH/ET/0BTMu0GXYt1O/NF0iRhDxUh2R72YeXi3X4XNeqSpPxgr+usNVpcLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=ny/NehVn; arc=fail smtp.client-ip=40.107.75.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="ny/NehVn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=il0+VFQ+Fmrc8SP/NVZs0Z9Q2/WQBw/e01irhntBQpYH5BkqyQOSThwZpj5e+tzW6GfQR4KfBFPfa6YB1SUJG+ECzDaiEitFKkkGGGaNqvUE9CYyzH9516nkWiATIi/tVumlw5vTPJtoxQbTmqGkerhSn3b5fmwSZXaV+FVpIoGcCH/vvvnCDTj0tu4R+dPE9iwY6Ld7k17mIYf2GElrmlKxXNSEt3IZUs5k3vTTdvOpLpcMf5okTqdi/tNyuU/bfpplJ/qLl3vzEGqMGsO2FYm4N/E7Aupg3ZY4/pjZNttgMeC0tqyDc3yPoTZQR6QRL23lRBSSm7vfpJ+NmWn1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MM0pdc5Y4H27HLoINhCwzlYUAQlMAw71ooB6wJqw6Q=;
 b=mvWlla6nIKFnTQoZlit7o+1HPNmBV98CYbO2K6/b25xrjU4YobV6unHKeS5MJYUM2npyr6Y8jKML3ndmvL9l9x6K39cTTWF2HELbIPL4hZNiKkldq0DtPSbTJYefyVZzeopD6Mo1wO0sYrTgzkU093DNs+ztSoTmExO+DWVB2hetE7INqjHlweWNYvDbsMFuCVdzH0/ScdbXE5Zt12dG/ecCQeg95Ihinmg4rUAl3RStNuOpLOjEbb++J+92mblE/CfGpPwnekIPXiWd/u5FbSMZM6p5JV8Dmohx3N4hPhOy9/JriNwqKnwlCzLq9NFdU/3Bg42wj5TBVpZauGKSzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MM0pdc5Y4H27HLoINhCwzlYUAQlMAw71ooB6wJqw6Q=;
 b=ny/NehVn83uRMQcJPwEaZaFpErsWdh7Uju7D55m7KNPqxVVb6XjXoONdRbZ2mSY1zr8k+bV0YzydYZZ5or8kNhDRoQxYaSrMaoDousDNpxpb9BODKp2Coi575C1VmR5RJYZMEHqs2WiTkXLQrcG3v7gSZ1t9I3eU0nEeqyvtVy5REFPlPvkswI+TKWFd5CWrSjDipJ1UoHHMzYoEUSuI2PQW32M4VkFc2OInPEaCMQJNnel0vpHmPNXJyF5lDUXjcXRsWdjtNtykvPYFg7YHa0pwAC2Rz8waO61waI8Zmjse2Dq8u0U3KSDv8i6alqcXEB+k31sicYggLz1ayg+SSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 KUZPR06MB8075.apcprd06.prod.outlook.com (2603:1096:d10:2f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.20; Mon, 4 Aug 2025 06:37:03 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 06:37:03 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] scsi: Use vmalloc_array and vcalloc to simplify code
Date: Mon,  4 Aug 2025 14:36:52 +0800
Message-Id: <20250804063652.104424-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0063.jpnprd01.prod.outlook.com
 (2603:1096:403:a::33) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|KUZPR06MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: b0406483-5df5-4783-9e8b-08ddd3215275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FSgcjpenAwTUO9UyfSs3vwblu+Imav2a9mpN3/eFMIKyJ5TzNm7xAOs8rV02?=
 =?us-ascii?Q?WHkfPQvE5e4bMdHnqZR9Gv4qULnccYCX1ryCSH09DaHnph01hSLeSr058Oz6?=
 =?us-ascii?Q?V2es+V4nGleIys0ao7tk+yFD4Jt+fCg1ylnxjxKU75LR/cc5Nc1+d9m9/G1h?=
 =?us-ascii?Q?m2gN9nhCod0DdmT6zH0xXmtic13iuMPtwWi0kf3+LNJ5aCjvCqr2n2EJrnhl?=
 =?us-ascii?Q?ty8VXtC/G3gXN7NCo5HsZhMjmxm6s0ljKnx94lQSnEjOJ4oibetPWsbuXDC6?=
 =?us-ascii?Q?knWmd7wi21YrKihf7X0GL1cCqlrQHngaiqur98hFqMuoYplf/f4OkvFa7ahw?=
 =?us-ascii?Q?i7g5lU5j+cizB9Wbv6nnkvqBNPbz5jEj6dcaFo43sUEdo1ZeUR5Fmht/G0qZ?=
 =?us-ascii?Q?dIwxocSHkrH1WarNVOxHRnxjIQIJ8KgTjJunAhDUgL8lckyrMOvKNaKNxpHk?=
 =?us-ascii?Q?EhGmRsITiqVZmdYlKfSYXEJ1BiqI9g4LMFhbZDSP9EZtN4l2dDYwvZLj6l1P?=
 =?us-ascii?Q?aNozNrws8yKFh7pTvWijCiqollvFNNiMkHQWQ/K9GQ35OK3BvpznVkrz48A0?=
 =?us-ascii?Q?PaDkKG1E+ToLhZ3xuS5YVAC2i6Vn35ajSngmKt+URnhlV3FGrKS6dlmX97BG?=
 =?us-ascii?Q?sLQt6xJU3RkBU5Bx/mpYziZ/hYrRMl6gROTcCpjR1Gd3hIGDn2eg9d39E2T7?=
 =?us-ascii?Q?ae8PAmjrsiieSvETiyiaWrWqD0ScHEqa+MFSzqS4+r1ALxIkV6J3uf8lPrxk?=
 =?us-ascii?Q?vGhwJ4cUjy4EKYYdoRQn6ac0dAR8UZWHPOn93mn9Oxjs4lSYUrumOietWrv+?=
 =?us-ascii?Q?9pd3QGdkL9VgJ9zWljZcubjfClklRLa9N8kNGjfe9V8cVxfof8WZPzrWd/0g?=
 =?us-ascii?Q?qPgF7p4m3LysldH0zWNPbKS7UdxBpU6ir6rKpbKcp9zp7NyPS54ulNjZQm17?=
 =?us-ascii?Q?NHHE3P8JIaBwStzGsHXgPiX1yMSqTficaUaIiVuiWixQcypDIyIQsvVo7PNl?=
 =?us-ascii?Q?U1sFosUD3ylieR2I13+td7wBBOjNTnOgWZLNI7hukVVzFDXrSj6NtIe1mSOO?=
 =?us-ascii?Q?pfQ0KCzsK44WZVj3R9MxNlEfk2i5rmw+gmZcs9MSiokHKZnSC7uH6919CUC7?=
 =?us-ascii?Q?fy3eaX8QQTBI1jNzWnbLTnZdntncjMYN5L5NG+t8wj2eosBM/yZZjzmkoqkc?=
 =?us-ascii?Q?lMDGS/gA/efowY5NzNcctY35yofL43UUOqAPm44kWyrmaH5NuSiUdWhAGH+j?=
 =?us-ascii?Q?ih8IVATuigNVhwLevrHmneRgA3QLxpjvY7FMTKt4PSs1QDdvw8wV1HpQMYUM?=
 =?us-ascii?Q?v+z88F8ciNknH6Xq3r3AgCN/nT26URAN+WpFFiyuFto3KgrYAEseR54LDEuu?=
 =?us-ascii?Q?wWOQeCenNifM56/5DRYmk2bZ9et/AAhvX2eSgmjftAA5x4/2CbaJUkm/9Kvj?=
 =?us-ascii?Q?PfNzqDX75rIc+Flrn0gZVuG0Pu46cnqGoef28MSN00DN9V3VRBg3bQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SMA1dIoL6vFFIKp+De5zPaZ9fHvg3jFtwVvurZjEdAfSF2smtp6PxMV51Uo+?=
 =?us-ascii?Q?7yUp7YWKTyITLIUry+NoF5m4jKeG5N//iOD4SxlnRXkLb0YNXmDWaWF/OwY/?=
 =?us-ascii?Q?S4XFpL80G13WHm6uMfhjSpbj64tIozoPKsPZaBGhtjNMwI0rpQgnEYXXfnsX?=
 =?us-ascii?Q?VFiB4dxu9yC6Yi8KXa2iLI/8/+q2zxwtJgBmTJENeA64jHMzD9azVwd7RY6o?=
 =?us-ascii?Q?Rd5dmeJnU0yfOGO9gctnLAdp32UgImjNf60yJDuQxqXOz6HcnUYL0dIewDpn?=
 =?us-ascii?Q?rGhaIaP1OVUY1dj+pbIyeswP4I5AY8fUw0KrIB4jWS7ztJJMeH1ePigUQ00B?=
 =?us-ascii?Q?eVVS6Zc9nBsZ+EK2rp3l+Qt2+rMPbAIkrD1MneKzEc26Ds/oqNaaDOXEfhdy?=
 =?us-ascii?Q?dO7i77O3I5X2YaJ5D5CutDKppY40Vaavig4tZZOcZxUnVfod1VuoOAoUH3gi?=
 =?us-ascii?Q?MbkKxWYiJ7k5EbcWV6Ia1Kj9bu/5xTE5TKycfvCkl9ruFxKzeaQgXlmxBQG8?=
 =?us-ascii?Q?OR7KEu7wZrL5f7PQK3/16A18V7Kd4SS9HBKwL/yuhWpfs4OIWZRQ1TrHF/Am?=
 =?us-ascii?Q?5pTIkeuxJemGbbEAAAEa3bbBkgihFKjM37JHxG95jKbBBPf7RFd/o8GPvTPJ?=
 =?us-ascii?Q?64I7v0CG/qXKK101CrAz0GMX5YMD4BAMFEU80kpK/MPxGT6XSUr0kDO47wQU?=
 =?us-ascii?Q?mF3nE+K2LWJGQZy3kqwpokzpIMyn0ezlhnvgyhMwSZJV2vIgcjHG5U5ECCbT?=
 =?us-ascii?Q?sJhdxVL+bLuwYgyLYOCnQfekNfeo0yhSysmwA0QVmwvHqHRGaqlpAAl0zP3X?=
 =?us-ascii?Q?uYUwoogSAHegY9SiT0/glKJmY/ITzo59EHpk4eAUeSzn2ny7V29RQwG/6d3q?=
 =?us-ascii?Q?o5nouebw+/4sq0DC0v+ajTpTePiU6aiaVmolrn8S4dPjETfPgFUmvryc0uvg?=
 =?us-ascii?Q?ibCUYIzORsuvhddcXBu5ZzZXCnW/51PdTasLA1W/Ce0gcDauMuuq1r+Njhfp?=
 =?us-ascii?Q?UsprgI8knwDbP6BMri16AOpBSaiyV36PJ7KL7mrJmrQhEkiTZ74dIN2xtkSS?=
 =?us-ascii?Q?6zkHnq6Ap0m8vrOInkUx3cBxTErYJJLbOi8CsnNGjp1wTJqKLlQx6I+KYm67?=
 =?us-ascii?Q?aFXZRTav5TqpIUxAbYdVN79HFhQV9N3UYx/S4pU8AKaGnrhWg0Ai6IrUGWw3?=
 =?us-ascii?Q?WsrVxhR83avLnz1azFxRg5HT6N9NJ9/z63ar1u0TSFb5D78VBtSv/5Db4Nid?=
 =?us-ascii?Q?O71QqT8Rg/5oSILoDRPk2s8frF4oHcuT6Yh7cNkd5+JgiDWEyevPaLPNIYGR?=
 =?us-ascii?Q?YpbUYHft1TZiTmM5LA1IYl3BpPs4T8Itk72lbZjvMDHhnq9IPjKCojh5k9c/?=
 =?us-ascii?Q?zutIctIf4UBOlFzuyKgUgox0/ZmLRqbVTaLXYablS6psKkP4wMqwpj6buCIC?=
 =?us-ascii?Q?BlaSXr1JXumQlmNmKQnxeDyipl8OOqh2RJMkeDplnwvCyhu8+8yWnsejZWKX?=
 =?us-ascii?Q?upfMJT3TUxDxWQS2mqfBeSD/4cGgFsxOvB66H7WhUbMJOxtdV6AKBeGAiZK/?=
 =?us-ascii?Q?ibATHgo7VpyniaG7DLI6iTcmGpl12OYTqZ1wbdKl?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0406483-5df5-4783-9e8b-08ddd3215275
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 06:37:03.0709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FWxjVJjCOVRFHK2my7W5FcSsknnHPxnuB5/e32wmg3SL7I9YEaEB8vZFtgVDqttssQtDPGDWYaqVP9VrgZIlRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR06MB8075

Use vmalloc_array() instead of vmalloc() to simplify the functions
ipr_alloc_dump().

Use vcalloc() instead of vmalloc() followed by bitmap_zero() to simplify
the functions sdebug_add_store().

Compile-tested only.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/ipr.c        | 8 ++++----
 drivers/scsi/scsi_debug.c | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d06b79f03538..4fb5654472d8 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4281,11 +4281,11 @@ static int ipr_alloc_dump(struct ipr_ioa_cfg *ioa_cfg)
 	}
 
 	if (ioa_cfg->sis64)
-		ioa_data = vmalloc(array_size(IPR_FMT3_MAX_NUM_DUMP_PAGES,
-					      sizeof(__be32 *)));
+		ioa_data = vmalloc_array(IPR_FMT3_MAX_NUM_DUMP_PAGES,
+					 sizeof(__be32 *));
 	else
-		ioa_data = vmalloc(array_size(IPR_FMT2_MAX_NUM_DUMP_PAGES,
-					      sizeof(__be32 *)));
+		ioa_data = vmalloc_array(IPR_FMT2_MAX_NUM_DUMP_PAGES,
+					 sizeof(__be32 *));
 
 	if (!ioa_data) {
 		ipr_err("Dump memory allocation failed\n");
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

