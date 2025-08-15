Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012047.outbound.protection.outlook.com [52.101.126.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C23009D8;
	Fri, 15 Aug 2025 12:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260190; cv=fail; b=Tw/KPQWCQ/jGI3VSqgkB63GGETxAwW3bo/WmZV9I8RmIeS8gVXDqPTQE4jzr5pWhb81coplGwkXRrnJs6sd0Gh6XHYNGHEW5tBSAfEA8HF2CE7mP8g6qsnLnhcsUGS21NuD5vOH77xOlugTc6OpRFkSXXGOEPVUM7ZWsB22gkyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260190; c=relaxed/simple;
	bh=k7JKhxtIqZc4mqaco10lg27fe151cGWsaK7Aaud3zzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TwI4LSc2rOeUGDJCTVD2n9GDurZ0ypdVH3QKnc937ereQbzRycW1Ag8qQNU1BanpRPCGAgnh3GCSUGVhResppLEJA6BhEwbHo9c1oFBvTt6abSmpPQUNMtctLidNcoUEqtMONmNMxw4axGYueowWti/tXD3l4NMq2ol/So/82DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=XjcOAUEl; arc=fail smtp.client-ip=52.101.126.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="XjcOAUEl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FImlKqQfnL3XyOpqVYo4O3hUQb6YNAX2nxuHZ+58PSUgGJ2Cw29qJK0I/GE8J8iv0Sz3+XKLGndYdnl15OWI5okyd3MZKOzLf29aFqnBG6JNEIyteKaurkHKnhvhpd/SBHNn+FoLC1IhMJjo9j5hsvzgxCBGekwjHVjclXwKvEGZN3dEzY3Mr/ybqNg6bP/wP0tYZ7zgXfgZ6Xir/Sj9l1NTDO/z5sP1fU7ohYL7+iceOAJfJWhMJrQijWbGl2pbBS/Nxsj1K4TaL7/lmHCFikrnPbvmWQ9DFlJ4U+TUsQd8PblLLGpIbEOnUQ3VG7kLKRvYsqlp0Sw6lBmeGLWT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnuKLl5DtKbNyDxj8CQc249+GrBYEbn3yZOXxv1WO3g=;
 b=ERVD30dZ1Q+bnb0eMnkeO37gciCyXYzs++nonLIIGFf4b518HT9r2SXiqv8Qia4p9EwYc5JdBEVEp+eKVdaB57aXpxH3Zc2wOk/4IlCyHe/GqNF1Fu8AhHz9giAp00dy3p+bcu+39P3GaMjwGwHvtVujKMOpm4N01RvmU9Ni4lO0Exg+oNLs86twG1n6bj0+x3GLf1NrxXNFM1mFIf6C0TYus5LaPIlRVC0ppNaqAirQlAusalBmginTZx7gnzIK90Oeyyjwz38QNebhiAV1+pRKrCnbiPeFtoXjC1UN88kmaXCg30XWxdwMXZVLp0j48JcSpTusUWuYiShLCJg+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnuKLl5DtKbNyDxj8CQc249+GrBYEbn3yZOXxv1WO3g=;
 b=XjcOAUEll2yTGfdtwmOLncJt6ElUoB5OxkxLQ4xTuffJ3FRTfO6kJ3qCASW8NB8agLx2aUlBsX3/ihQhyIzDkSHvqD7yyHHU5E86vP53Edz9kaaTrHPmTHepmifftfkgml/KwrQLWvZ9Mg/EuK3aHLENuzsZUtvnAz0So9niQdRR6Nsg0M0dLPBbXnyZlpxVg+FI3c1rXDVkn/U/pukyMP+0fRnyB1hPHNldIEJmTV+dbiTuit6CY0yWrgvvio/EsilagP4d8gbtkQ0i5ycAFBAjQqLgYguVMmiDxFlLPmxuLCVP6/8Ym6yp79iN5EtCZ3XLt1gb+J/AcbIhmZsALQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:27 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:27 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	storagedev@microchip.com (open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)),
	linux-scsi@vger.kernel.org (open list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
Date: Fri, 15 Aug 2025 20:16:04 +0800
Message-Id: <20250815121609.384914-3-rongqianfeng@vivo.com>
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
X-MS-Office365-Filtering-Correlation-Id: 69d0535a-4106-4426-fc8e-08dddbf58f69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6I34Rxh8VWXhSCXeXNlEUsS9SHygmqAUK5/NEjpw8nrKT07filDj+bXSRlsE?=
 =?us-ascii?Q?LIMR++se1ZZmL9RcZpTk0F4LhEtKxy+JVGPXvEIqBjYQAwwrOT51WgbtESUr?=
 =?us-ascii?Q?0KqCNfQN+wJeemDvLaFRpwP4kGJAVbjzXfbKIM6NA9N2V6WXRVZfqUKPnApY?=
 =?us-ascii?Q?Yy3SoOvTnP10qbcfthcGE7kJtDD8EhdW6o4uADaHZXuOsHZZxfK/mvMeAgi5?=
 =?us-ascii?Q?mDclIWYP86M7qQf2EbaBX+A5RKjX7BTBuNUpdACl+kqedkDstbDK7+DmaPRo?=
 =?us-ascii?Q?vSa0u0wiueh+BPDs+KSfViN/cid3qiWdWHU8qBUAbCU4eB7W0wIfE0QkFEO6?=
 =?us-ascii?Q?7qbMbKMwBDY6A8Hhb5tke716U+XBP36LDxxIWOkTvGwmAHPKhOWxc3DdVexO?=
 =?us-ascii?Q?+JlG+3OAqui+NSSEzmRIAtgaax40Iq6Y/g8FlRHkcwDeSSVE6TRapeXYrdmG?=
 =?us-ascii?Q?VvQXKlumNiHTZ6VUCVqc3wnw+BcGNL8zLX0VrofsE0gALugSLFZAljInUh9T?=
 =?us-ascii?Q?az1pdQ/10Vkm7MAgBUH8wMt1zMC+Qod5ROYjizGm6chgbvcDvZVDSSmyO+/3?=
 =?us-ascii?Q?XuXIbsbySW1D0T39PrcT+Afayz1AhXWj7O/eroU7ZMD9i/QZiZDmJc7LiqkJ?=
 =?us-ascii?Q?PJDrBRinvQ2GUYJGgJUaX+VmISFHOaCSu7exOh+iqtukiVZhZOzzK4jUBK3Q?=
 =?us-ascii?Q?9QkxGu3fvAt7i+JjSmZoXkhsO9JdKoSPiKGrxgZE51ckt4PxRPjupbcfaDRn?=
 =?us-ascii?Q?nUvQc8vM25e5DHSah1YQBBh3bJ5BP3Y8NbyrcmEbi/kTxKAhlqMnjMYDXkN9?=
 =?us-ascii?Q?SeJpFdOn20vgNBibAOK3tsXhQ9ljstVaFLZOS+fxOVFTY5EB+KSxlZyYXj/V?=
 =?us-ascii?Q?uzLqNQwyN50tJX0rbMArGCR7OHW3Gt5YxbEpKV7Z7BqYxynDuCsFPIOd9xet?=
 =?us-ascii?Q?1U0nKOms7KuB/A7QPt00FXDzXW6ay0BwvDZPIu8b76L3prHJ8X+XJhCx/iBv?=
 =?us-ascii?Q?ur0fBloxbF2BcnNTnM4c4XvQ85FoXiS2qfWuaV9evvEEeL6v26u33W6jLJsT?=
 =?us-ascii?Q?sggYaRry3C270OHE5RXmIE6/UUdHgpV52U3RpdTzDXuyJ+HCeK9k6PVytuPa?=
 =?us-ascii?Q?mtYLYlscB7WWZ1Nqsiy53wfnxmvr+iZgl2JYyURizbgoBQLZGK014R+delI0?=
 =?us-ascii?Q?o8oevXevf5F0BzyWD5gP+F0iVr9Tw2AEWBhHOakUM+QE3lVnfyZQc04imqmf?=
 =?us-ascii?Q?ryPpzHN4IzdJH5i7kqLWbO2DpyMb6NuIDJ/pHUmPa8jM83HlMWrAlmd7NAlv?=
 =?us-ascii?Q?z/TIQrSQ2SoqtGJyAOEPbINxDMcno3HhyFndXzeJ7o35SHpXDj8z2lKJVdLL?=
 =?us-ascii?Q?wNUIZypoOyKg7DAokKayFH9qJ1AIumqDqKas95+CMXR94Ih4RhhvAT51Q6Re?=
 =?us-ascii?Q?EOt1jLomV6RwcUviyjBmx456jY9J/GErxAvRIPf1p6foLT9nnLBg+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oh760LzVky2Y1DoMhaaDZzLaS6ALIk8iGsKFk6npZMRwApU+9hATPzOK4o57?=
 =?us-ascii?Q?PE7bjWDue1DiNi8cflhEJt40LXMSqXwAq2X/hgF1sc+uwR+jK182wQQYXk/R?=
 =?us-ascii?Q?b/mRmGzONOKUDfGtGqlkD82rijtYlMSyUe+2JOzh20f+c4EWZ2q05CLDBtKf?=
 =?us-ascii?Q?+fksBY5kaxXtYrDVdwVRQelt0j9ALC0qfjPmwD1jI8eZZiLjXfxa+Oq8erix?=
 =?us-ascii?Q?+l2wf9QQZhz+13/IJPHqzEraugODGfpsa+vqTuHBYVf0rE6x8mB6nR2X86wY?=
 =?us-ascii?Q?5ItR/QRFEET0qB1DAk16c52IU4bp8nMcnWJiZ48Y7tyQxb2e+qQTMiqN7xH5?=
 =?us-ascii?Q?Whjph8F8keNC351D70nQlHgydmljN0zPI5v0Dl8JgrRDi/7fY+eJ7JMwL1Il?=
 =?us-ascii?Q?vWsApON8GFvsQKFxi3456AFWJT7LoQfCwCgfUPTn2rST8FE/SE3bFMzP5As7?=
 =?us-ascii?Q?eYclgParSqiHN4RBXYj6bGqfR7G8WIqBA7W3UcqSAQA8F8uSGMOd5KArPE35?=
 =?us-ascii?Q?6kKgoTA+bquXunwG1VmNTf+339Y4G0k5FmwM7qWLkcjpbPxBlSzsGxVPBfLd?=
 =?us-ascii?Q?MGyv3fu0RoxLZPzwfpGXCnoxpz+eOIeEzYiN6mdsqyIsXI3f1bNSfjg8xsL2?=
 =?us-ascii?Q?nsELBuEBLy09qUdnRdmEeaq4DcfniDgRNCxdgTWhlf9Rf8x+vx6MABUysfbN?=
 =?us-ascii?Q?imZBXjGj4w6q0qf1ivcd//FwXt6/fueY0zpa7O2xAULblH83SfDUO+9epksU?=
 =?us-ascii?Q?ZRA9Ai4xbgNpxKpRbQaMqd6LX+Yp0mduDIkH0YuvwA0JBhawq2OcFS0aDAbS?=
 =?us-ascii?Q?wNwjMItE6cBb/XabpdZNVcslKVsT/C/ngz3bFnbtjEClFc8EPhJOevKE1THz?=
 =?us-ascii?Q?06bWPKODyKPGYJJrBGgiEMLMoMzuxpavO9LxG6oNniaoBjCTxtYp4NjPW7VR?=
 =?us-ascii?Q?qfFq4mc4oxKbbUBlrsDDPZ6NsAcSw3cs4o2qfstBjuRfmvm2ZfX4fVgNnmT2?=
 =?us-ascii?Q?NHiEz6h0dOf9vB08wh+wulvsS0PlcwrSagqrTFBSJJtqGRIKIUmdz5TvrP7O?=
 =?us-ascii?Q?oJm2MR8icnK3WdgV+QZobylpRG3l1gwTM3aAYe/KbcoorAOF3z+WsjrjyWQd?=
 =?us-ascii?Q?2t2PPx0HCE/xSz1PPQGpIktbc7/faOsEL1ALKmH/+FIQL13/1woaJ+/ac5SG?=
 =?us-ascii?Q?/kilEulmaH/AI880+1X5gesB+aYRP3VPFF8R40xGtvR+6oEhxWfDNRNjRamv?=
 =?us-ascii?Q?c8Ke/RI8a+T2IIpfg4vzLplTyRRfiOAaZjorLCk2lBbvytoUIbmVeKTcXQGM?=
 =?us-ascii?Q?G82zDFFZHDDyg4y1x1cyD4T4+8ND4PLEUHbwWwc5ilCAkhaC9eW9YGYxXwEj?=
 =?us-ascii?Q?D7VhRReorTDYofvPrWCfTktX/IzrRYGWsyNjcNlMrS3+o7m3UdtsXYdEg7AY?=
 =?us-ascii?Q?TOH9eoPKUuuZlBGfOgzJj7N8fIyQl3wcTTgNVmkJY6d3kA6Jpavxe9LPL+o5?=
 =?us-ascii?Q?SEZ1eq96lb2Zu6IkWJGkp1NGVO5aDnaYpIQ+5LjOTP9JZRAe4sEr5jmoLia0?=
 =?us-ascii?Q?b1do8Fa3fFLjHjvcU3pvgLl0xQGzmo7KhiTnMqFP?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d0535a-4106-4426-fc8e-08dddbf58f69
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:27.8251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVkaaXtf9rJyhpjwIvz8lO9Nup/QenAf7/fkmuB8aD26ZuYjsCjnoFQCVrz8c2InmxNHLgiPuclOdHM9LZKVeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use min()/min_t() to reduce the code in complete_scsi_command() and
hpsa_vpd_page_supported(), and improve readability.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/hpsa.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c73a71ac3c29..95dfcbac997f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2662,10 +2662,8 @@ static void complete_scsi_command(struct CommandList *cp)
 	case CMD_TARGET_STATUS:
 		cmd->result |= ei->ScsiStatus;
 		/* copy the sense data */
-		if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
-			sense_data_size = SCSI_SENSE_BUFFERSIZE;
-		else
-			sense_data_size = sizeof(ei->SenseInfo);
+		sense_data_size = min_t(unsigned long, SCSI_SENSE_BUFFERSIZE,
+					sizeof(ei->SenseInfo));
 		if (ei->SenseLen < sense_data_size)
 			sense_data_size = ei->SenseLen;
 		memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
@@ -3628,10 +3626,7 @@ static bool hpsa_vpd_page_supported(struct ctlr_info *h,
 	if (rc != 0)
 		goto exit_unsupported;
 	pages = buf[3];
-	if ((pages + HPSA_VPD_HEADER_SZ) <= 255)
-		bufsize = pages + HPSA_VPD_HEADER_SZ;
-	else
-		bufsize = 255;
+	bufsize = min(pages + HPSA_VPD_HEADER_SZ, 255);
 
 	/* Get the whole VPD page list */
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr,
-- 
2.34.1

