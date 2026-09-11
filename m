Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11020115.outbound.protection.outlook.com [52.101.229.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA1C3033E3;
	Fri, 11 Sep 2026 04:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789099922; cv=fail; b=rx7IoJOdJmqxN17bL4ftTLyejlOx4hoqk9S3d7Nv802mnydIZHcp6jYsP9s6nfwiFTA+iYNaQJiE6f9FSWI/d9AI75xcKzCBnUVN/+ib3sJca+qrXrkBXZIbSkgIdMm7cktFb7oTW000qPEbBlBUmMhU0p8T1MOJWiqnxSV8c/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789099922; c=relaxed/simple;
	bh=Sv+gMb+RumlS9QpKuAMS2njBu29so/ZqfTtpTp5oLwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QHh6H9AeUvOgemgZj09URH7z4o02CqgvSFJBJ6GaGtxgvf1125UYh2pcYqLLCBHeipeJDQOkYjKEs/UUYuS0aq9/K8Mc+DtYtIDmlCp6eeAIZ3UGAjH275NB2N2FtF42aLIxnJ6+fl7gooWjFF4Ijjnvi+cWcjsp2/XGNHtSg7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=nN5ve2fW; arc=fail smtp.client-ip=52.101.229.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="nN5ve2fW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Km1ShlcpJHJU4QGldAUHmSkAi8c1xxY8m2T6JaVidiNVxGUUZUkOvHV+4s2rcKhe67i+xGMpdaOXNnS22lTPMCOsXZv/dSbsGJ2euldEXYZXMpV70AP3FIRCtVuvxSgzcNdX4JkcQsWWpQcMX6o1U7u+45c24Efj2V9esn9AXwMpZCFRvxY+3bliUXCsUnnHU2atMetDROZHcngjq0lHxG6PUyiPTy45y0AUCoEXUhwFl+B7dBKo9pD/ertkg0jwnfi2XzCp8uY87pPMBGjtxCVfcntJ4bTqvZIlrkgfPcHuUUqJV7xlQoULGth4B5WgKFT/KvCZHDMdN/fN18hOjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkDf7NwP5RhFQYgIIM8PKABpnyG9h0xbrd8Gvn9JO3A=;
 b=i4/NYHfoCnQkHGOBcTZJECNPpouNCwFZ4Da1Mm1l5A0eB1gWOz136sVcGQm5Q3e7QVL6m/4OSmbtOX8KAD2o/Z7hKTVKUK2EcLRC5BU5G2rmp/URcsNxFVA3hZi5AXg5/VhMARjDQYQ3HWGkjojobMtF/8dqQ8fK2atRRDSKQqJGtPWB3tmFWn9vDLLEOzZe97l1qd5fPdC5HhSW0yiH0biEU8VxiJUnSYe+zlPSLOE7ZHnj5ALJDM9s3bNPQqkLy7S9OrDqOjV8b04iL03K3NOtLFPy6PNc6uAMYWaGVwHRReJbnaK473i8PUR4S/8QiOUdj4EAj9bQVsF4nqJMpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkDf7NwP5RhFQYgIIM8PKABpnyG9h0xbrd8Gvn9JO3A=;
 b=nN5ve2fW5SwhnoKgvgq1KGarWj3lhZ6+8Xwt62HEnLTxNXL/+owwRcpuDvH88rPtDvhJB7VIKq2zeE8doGMaSupsaxvDD43oBymA80johLifeKMLkWrRSVRldRiPwwiIy/7+O782g4p2KNCY/h47BLfGzQtLfY1bk8G8ME96Tt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by OS9P286MB6583.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:416::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 04:11:56 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 04:11:56 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] scsi: sd_zbc: reject disks with too many zones
Date: Fri, 11 Sep 2026 04:11:29 +0000
Message-Id: <20260911041129.128280-3-26066541r@connect.polyu.hk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260911041129.128280-1-26066541r@connect.polyu.hk>
References: <20260911041129.128280-1-26066541r@connect.polyu.hk>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0023.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::19) To OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:4c5::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7P286MB8049:EE_|OS9P286MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: a57f69d4-050a-4a6a-a9b5-08df0fbad173
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|786006|52116014|376014|10067099003|22082099003|18002099003|56012099006|11063799006|38350700014;
X-Microsoft-Antispam-Message-Info:
	TC2DHEvAicKy6TKIum7FuuCc41kWLFjWuYOKdN3fuMOELAW00R1MWRb44daoabXu8kZlpjLv7w3R34HRGNOzgOm84Ps9LyVi+M8sYcfohi8AKbInJIvr5AAq8AbwzsFDTZrWPJc/qH+8bQeSB+tE59W1ku8e94fiAr7MNp1B+XcBc4LHtEIWRsiPfdcRVatO0oJAl9o39jYwsDhGYjm72B7LT8LhP+Von1bcDscF71YRRwRoSuzGi3i7YiW4ADM2OitUa6Lyg1dRHbpEsfilbZbR8HKtE8WIbyWGfXEcRZCuimozFdjqDHhI9G4p7BJhcFix8iTYtQVIsFkv3IkiHsc+dfnNnpepY4/BkDgtB8e2Qe8v2dQG2iqQ0ZG0TY2//q2JwPHTrKH9TE/P3F/Ryy5JI7RSzAEx34nAjG892C8vPtZrfrTNt1QjYx6H5cfFpm/AR4KsdtsSFTSkAeupj+wPlAFO6njKLnehQCiqS45B4vumkv7CZTivQGZPyz9NdOOS6m8oCQYnrekoXvAdEfGKkTvbpyOQr02XZ4GdmSz9cOmLYgF16jNtPUoDuZnHJd41QYiQxrET9/7aSv/+R3EeSZav6xHx+/+k1A7CVcKsXa/HLaP66U+Gn9Nd2IGwSborxy7gwS4zI9t9BJoJa+cL2BereQCjj0mgxl9RMmb4DXEL7UOgg1DMnosx8ftjQno653Us+TjuFGYfsBKR5lvWsjyki50i/1HEMTDJc3A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(786006)(52116014)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8UbuKkBYA7/RdVQPx4hz0JfvdsWOx8IOrUocGRPcnWK85xshXslxQrF2a/XL?=
 =?us-ascii?Q?waTDeuq3GBI98hyj2d8+pvbKUjMdSBeYdZNW3pZpNAJNRzLT0pzNrtix5D0C?=
 =?us-ascii?Q?WsDaNhjoyr0bz4BeGrZqFQOYRaQ/e8ktuZnkFx96Q+Y1neZrgiTaC9cBEzdl?=
 =?us-ascii?Q?9YEFSwE7U59i0JeY5UwIBFySwkubO9KKQWJ7JY2j84Y/Crze2H+1/YM2oNEw?=
 =?us-ascii?Q?0w3GFHhphC8GWGLOpyqmOBPGVHSgkH2iA3JkJZEUUXkzL9ENTxxE5YhxBWgU?=
 =?us-ascii?Q?gcOrtsiKSdfIiOoW4yDmvz+a0553puH74Nun4G0A959EvD3kQej+FzBOF7Pg?=
 =?us-ascii?Q?P6TpZ9c16N8P8hiaEF+APZwzG+oAtOBCohOrLFOsAcyQEdETwZ2TTbZIrYT1?=
 =?us-ascii?Q?Oez0sCIAe2Sv7lfRzk0xmeHOIfu5F3w45W3GCpEaLZrrXKQ+3IBKGvXVOGK1?=
 =?us-ascii?Q?9ElRxiMgOj87jLRgdvuXsGDd/IVof78Mf6mm9lFXanld4m5l66KMlpO97jgb?=
 =?us-ascii?Q?T7J7F5hlbeoKVbr4RjGUUvHJP/9pgFi6JrYlTvHqbK894Grnuki0DldsQCu/?=
 =?us-ascii?Q?DrjS9cgl8mOtP9B7S0d2NpdCDaDhvq6DaRxSIxRbp1I6LFdXDWqY3XGyLHHd?=
 =?us-ascii?Q?62L8WoZxztm8968x2ceBNKbvuajyRfxZx2IVRXv3hTbANktDodqnBccTQF4F?=
 =?us-ascii?Q?8ALHuDwArNbEehnlTlUAm+jM6Vgt9ECg1gKG5NXtz7CqD2NmN8zTx8UV7wTO?=
 =?us-ascii?Q?X8DgeqLiiLVTlntUVNfnHiDrnVg07U9A62i0jeU/g9p5kKtbgPoATz0pv9Ja?=
 =?us-ascii?Q?ZYGxjGgzuA9U7Ir8pjniI9vXX+waoCy+v5n2hwGMSUEog6QSII+bmvMf/8eJ?=
 =?us-ascii?Q?s7MeX/PEmKKlbvigNXAM0Y9C+vyZFVomHd90o9UxRnClKOtj5JBUjaJ8Fzje?=
 =?us-ascii?Q?XkdFa6ndTWUkGYG00gW3xn6Xcj3ERo4WNKskdddna/ocljQ7tHkHBCnqlsbE?=
 =?us-ascii?Q?zvwzopcLFoOUgjf/iPXqdDo9P+DpYaxUS+3O9JSB9zotrV9jmEi0YLIGcusz?=
 =?us-ascii?Q?33+JApkItbeEBR+ehU67UQj+CXqMd8Kzcx+6zF+aNBZYBpoSTraBHL7nDoFT?=
 =?us-ascii?Q?qcExmBDhkyscLSDT395Er5JYUheszA2OZaYZvZ9q4vVP/iNQErDoe47knASz?=
 =?us-ascii?Q?tn0KZ73KmrFKtHd8U1fX8Vrru8LLiJ+yYSi4kfVtbwcz5+aMkU4dW4nJk+Es?=
 =?us-ascii?Q?IIA2D7B8jOn7f0Uhj8hP632A2eDM5sZshXC5l4TuE5XIFdg+YFjBaUMXugW2?=
 =?us-ascii?Q?Eq+um6WH/j7tuqzlxb/3H+/shVB5ZaspPZd6J1O0u6nbXwPC289Kh9yuvxMF?=
 =?us-ascii?Q?x22liPCBvifcsmGs+LWAI3T/PqXhQ2/86RQDBEAFNeQKBsqugIi0sqIemplH?=
 =?us-ascii?Q?+bRz2xMLvTm+l9gMD4xzxgARWgOzONp/36tk9q8n9Pfkm/WDFrV/I9W2WpCJ?=
 =?us-ascii?Q?nuE8YQhGaADSpDmv/KbvyBw0bXL7UVt0+nCELUJCRWIxkpD0H8pvmGHb7qlU?=
 =?us-ascii?Q?SA0GnL+Qp0m1HmFeZOpyemFGUFRTcRH8l8ueKfMXw98RJBUcmfhv5scSyoLN?=
 =?us-ascii?Q?zLKvD3v708s0sALWvOppFQK6GJVx1yuWotPdPR6pXPYleqO0Yd9hStMIz3py?=
 =?us-ascii?Q?lCL2Fspe6l2Mo8ZhW+BwHq2xEnEOh8IS3GB9SRSGBvh7mRuqLMoen7qbgyHY?=
 =?us-ascii?Q?L5y1jj7aHoDAuiYDfG4vFP23FYhVctQ=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: a57f69d4-050a-4a6a-a9b5-08df0fbad173
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 04:11:56.2752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9UgKRdloX8WkNOxsWQZXj7p7U4RZrpmMzfHwoObjR0/PrEh+kLoAXc/pfCdaDEd92jqXNpybwaPYHhe5MYjM42I/OH2I9qgvPAN/i9m5Ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS9P286MB6583

sd_zbc_read_zones() computes the number of zones with 64-bit
arithmetic and stores the result in the unsigned int nr_zones field
of struct zoned_disk_info, silently truncating counts that exceed 32
bits. The truncated count is later used to size per-zone resources,
while the device may still report more zones than fit.

Reject such devices at scan time: more than 4 billion zones is not
realistic for any medium that exists today, and accepting the
truncated count produces inconsistent zone bookkeeping.

Signed-off-by: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
---
 drivers/scsi/sd_zbc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5addd..446628cb3db02 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -589,6 +589,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
                u8 buf[SD_BUF_SIZE])
 {
+       unsigned long long nr_zones64;
        unsigned int nr_zones;
        u32 zone_blocks =3D 0;
        int ret;
@@ -620,7 +621,15 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct q=
ueue_limits *lim,
        if (ret !=3D 0)
                goto err;

-       nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_bl=
ocks);
+       nr_zones64 =3D round_up(sdkp->capacity, zone_blocks) >>
+                    ilog2(zone_blocks);
+       if (nr_zones64 > UINT_MAX) {
+               sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
+                         nr_zones64);
+               ret =3D -EINVAL;
+               goto err;
+       }
+       nr_zones =3D nr_zones64;
        sdkp->early_zone_info.nr_zones =3D nr_zones;
        sdkp->early_zone_info.zone_blocks =3D zone_blocks;

--
2.34.1

[https://www.polyu.edu.hk/emaildisclaimer/PolyU_Email_Signature-v2.jpg]

Disclaimer:

This message (including any attachments) contains confidential information =
intended for a specific individual and purpose. If you are not the intended=
 recipient, you should delete this message and notify the sender and The Ho=
ng Kong Polytechnic University (the University) immediately. Any disclosure=
, copying, or distribution of this message, or the taking of any action bas=
ed on it, is strictly prohibited and may be unlawful.

The University specifically denies any responsibility for the accuracy or q=
uality of information obtained through University E-mail Facilities. Any vi=
ews and opinions expressed are only those of the author(s) and do not neces=
sarily represent those of the University and the University accepts no liab=
ility whatsoever for any losses or damages incurred or caused to any party =
as a result of the use of such information.
