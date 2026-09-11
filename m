Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11021080.outbound.protection.outlook.com [40.107.74.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D097A357CFA;
	Fri, 11 Sep 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138004; cv=fail; b=R4iXv0M3OOvuse7aC7i5BvnvTYbffTPmqMk1d5Kv7Qz7uYO/0RfxzRpMSswWZR0VeoNfJgJ2sRWgmGnXMxBqm1q0lEhHg/36GCOpd+GXMcUeb2mwotZ0EbZMT//XGm2jhwcELBcV9fO/XqxEpkYsu5GA1xV/JP2LVQ0X2+kUX6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138004; c=relaxed/simple;
	bh=Vv9hMuo/SvkHtR4F67LKRSNASyWMmBUCnSYawKeOp6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UNRjsou7lRvkX1glY0ScLwhFC7RvmkCnbDw5TYs6urhKnva8TO0g+s3CiFOTFpJZ4fETgSEEDTDbHlgprltAPHN3PzNeRUQWFBLlLw+ZJgDkxLNFnndADTakh6/eiEdmgkkDIDXfOL+4fZXk0Us4Y1Pd4sWA3+CELXYLUobrPdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=o2rV1VDZ; arc=fail smtp.client-ip=40.107.74.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="o2rV1VDZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eoy3L7lQQsdIWYT/GT0MPM3qqzG4zNMuaM2dspvoAb3rQjgOFvDTc9ZE35n+Uts0aPCJobFhOMModCj8AxmdaHgwrf53hB/wGH023X9eaV+PqBKZ3kDFfI2zy4C0kZNPcPWFU1r479yHef2PZsvr/hNGSI+0jTd/bbkgyonE1pvr/MJWbJ1y2v+dXAwhr/JzYl/PUdgZb1IF3djgEuRu8eQLVq5RXrCxNcGB4UHji9WjVo+rNISiJtad4ILawnNpA7KP2yd8wFuVxjv6OH/mA5EbC12LfiGJNOfBS9lZ8Di4XvulWrCPHoKltBNvhiYR9vndWxcqwIWR2BBkzO2EXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHMDTek5DpOj+A8dfH5uc4w9p0mutg5/BxJ183f6tn8=;
 b=xmW8c+FQWrg4AZxx8lr3Ue1gEF3u5qJG43Ao5Lukx3mcMgB5Cb/W/VPiCFNvPqcOEeE/SLWzhFcekc8wMpH7vmiYr1ok7z879ign3tIFZ4QyKLu/5lDM3bg1Qv9mk2J+o8nZrC+UU8XFaO6vQ3FrH+wuvnfS6+pdZjblCTAwptJEYDh9LdH3WxoqWYKiP+6ggXe+N5Waa4OfL844331vYc4bZPRs1YeCWL5ZvqoPtdvP1SdvS6KzeIQpHV+5npBe/WaI8kD2y6Fh8EKqEtDAslMYmA+lckc7tANSwnP9YJ5WDXxSZlVMBzVpFRm9/GttenaGDFB+EYw5zvAaJt2xDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHMDTek5DpOj+A8dfH5uc4w9p0mutg5/BxJ183f6tn8=;
 b=o2rV1VDZKwDG7iYg1t+Kzm0eQal7zEJLGIZKipzP9iT2gDeRO/XjbeVcM0SrcQ8b1KWcPjwkOBunfRWFxmSv2a/Etgw5qumT1oYRq2SjBXbQEiDDlbFxXOJaw8+1o3D+hqxpM+clnt84II0DGXCZoJoELfkjy8UWKFOgLS8xqbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by TY4P286MB6621.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:342::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 14:46:35 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:46:35 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: sd_zbc: reject disks with too many zones
Date: Fri, 11 Sep 2026 22:46:14 +0800
Message-ID: <20260911144614.39553-3-26066541r@connect.polyu.hk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260911144614.39553-1-26066541r@connect.polyu.hk>
References: <20260911144614.39553-1-26066541r@connect.polyu.hk>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:4c5::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7P286MB8049:EE_|TY4P286MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: f9662b1b-b962-4aff-4f5f-08df10137a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|786006|23010399003|10067099003|56012099006|11063799006|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	QRW6bQTpFgabFuYgYNmN3h//dr7sxSADBDf4QKsciQY6h8//jztSeyPunURMm8I/+vSjiwxz/s8JSrbXdrJ76b5hgmIUKVorwJSYdJ3z3dDsBmDlCTikl2LZiyXAVU36Xuvd9RiQdfOaGYL5EXRAfQTYmQLreWBVrLjEzKYAYei8cZrePGEAXn5NEpuif7WdMljwSko5cDZ2m95FeFWzZLIAD+nCWA7zAKvBxIUvNMev231g5EPSPz4vU8NxJ/huQH/k2UZ82ThMbm+DPrjEUqsHVD92moFn/4pGWtHdSJYIJl0/Fo6uqrR9MxLr7lZ9BUyzGi66HqHufxsimgikiybCIkrmUoXSEf45UW6luqW4Cme5L5m9cRqo8lDIuzckFU8ZO4vPe5i6wAiHexLS6NJZgGWihUfC6Y+XAR0OHYsKemZd2Zp/rnxnnhDGW+k57u0ZhwnTQsBkfbX4uyAaPYhyN9967csRIfj7WCtclCfTX/glDlSRcxAQufbsNUPO1Chb1TPpyAL5sY142JKiCRVst1E/BEZOMSN0DSW/3eko3zOa4Ou+0bFRCUoe4rK1s7NhYQFWcx884FPHiKelLEV3kumay3hEKA8m2ZrhYIW4L6v9LcMpYCRb9yoaVbJTfCykXkU6k2kQBNa3ckwG/6s8iLtlvfeEU9TrJsmrGhyQCCD3/0yjXWz+8ic11RbZormY0pxGH0GtaJAGcxYiKm7VxZjfL3gcCaioc0JSNgE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(786006)(23010399003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PQ+l+7HWGMk9IHOAQ7gNHUIEMZl96I3Sqb01YVsvbOtIxmpGyOY5aGeCC+iq?=
 =?us-ascii?Q?Fm+gB/XnHQO+hr8dSpm2QONh3ial2rVSvVcS8UDHN7z0uMw9676lSJDKWX6D?=
 =?us-ascii?Q?RNc7BmeDTKss1fHW0Z9t1VAoUFs6qHRREmBVY1X0seI3R+kJdYn94mXA/jaG?=
 =?us-ascii?Q?3OR+Fr9Y1gpA1sKNEqC+8kaMtDIREhIBvRfINxIG956iDDBZZ2wk0WlM9TLU?=
 =?us-ascii?Q?SI1hztnLIEbRWRMt9CmP2f1d9tLthTTR7ocuC03Fxt06qHunku1oNrcxqH1Z?=
 =?us-ascii?Q?reh4rQhWN6+aEiNNEPNlhxHLfWBMIbW3P5XcBOe4sTYUuOwtkcBg3yW4lnUj?=
 =?us-ascii?Q?b+ZHzC/xDqYISIsxR6A+lB/uFSnR4eFyWC4s85984+tSFA/ZNslIr6a5waAd?=
 =?us-ascii?Q?VyCrarBQXLvfuRXrr3Qpi6xXfkArfsd2yX2/EMIltsD/KP4qbAoIwhSDu0TW?=
 =?us-ascii?Q?0Q59HhsA+EnzU8esmeV25UHkmmDRdo7NlFVWQH28lJbhAiSh30iLqqr2GAcY?=
 =?us-ascii?Q?ZFiVd21vt6DZVU3AnTeIfO01ISUM3NaeSk6ZWyeKMSYxyxZUPE7uPBmNBSc/?=
 =?us-ascii?Q?64WXGs4jIveyFf/QDQMfxE7uEOeOlasOhYJZhB8Wm4AHRd/PRguQHQwrWNyC?=
 =?us-ascii?Q?2nOt5HAeqsvQyJMKPkCv0Ss1SG0qwuYhnyH/DitpXpstLJJb16RDiX06C2Ub?=
 =?us-ascii?Q?xJ2sGYZbKcjSa2EWQ2BsVGQ7dThd5pVdJNoxAS4A29LUfparF5bZUUQ7Sc/b?=
 =?us-ascii?Q?MGwXLfsLLUr1Y2O/M9DgwyQ783O4GieFi5PYpjzEuDpbxCIPdzWI+v+PxX1U?=
 =?us-ascii?Q?yw+2VNuuynb431WeO/dCcL6WBFrpnbI34RTXXdjRdZRXx0VyymIg8/9WRKWK?=
 =?us-ascii?Q?LY0di+Yu1vkF4uE65aUi9Ui0kFuYCxH+08v+BUu7CtNk5wdicDgxgFKqlHKR?=
 =?us-ascii?Q?veDlxLtOFRk2uYACc9ItIuMD0aK4085uIWBjC2qLRdanUfmMYDFVWnpo0YJF?=
 =?us-ascii?Q?2lSboSTlAnYqtTfcFSRFKW6dDd63DpHTn6cngbq4vtmJOxuN7TG2OhQR4Cfs?=
 =?us-ascii?Q?uwMtV6ZulpLCuAlXQr3inm9UCzH3RL3snlVmcyl8L5B2jdRtn8rLzU+WdTYL?=
 =?us-ascii?Q?Vx+lLV9b5UBH1eol9MPJTJ44mqbtxnSgRwP/L2LS+tp35JaidZbpN1mq3jmO?=
 =?us-ascii?Q?X/qHYrpaiNZYDaqdOK0yK9NwTHomqntZ/BsvMlcAkiuZwar8tPD8twUFZZMU?=
 =?us-ascii?Q?YbQMzohWUJGuaRMhpc9DI1GOSsXPipBfKO/IzEhcrXE6diANdZpjitPsp2aM?=
 =?us-ascii?Q?1EWAjIGzLRrhlJGHcpjE5RUt2Jc794Og6Ok5LA9NwWk3B2OXbrlH1pkQTf7q?=
 =?us-ascii?Q?ceczSndWIVds8EUXNrvLuFlgGdr8O8W/mgWQ2+kdEvI3p8EO31SkwAJA+4L9?=
 =?us-ascii?Q?opnyI1jBmwTB6O4KQ+K7gF1RCKnXHHPzS75BOinYQ9bc/J+asqKWzuLQmTCH?=
 =?us-ascii?Q?rdvEpdi13ZJNB2aF3sKpapT6J3hJujBDc+uDy69wwRe96n+mZn5/TlqBe878?=
 =?us-ascii?Q?jdjiQWqJ48KMuz19WhyrX1ROF5CI9NFX1UIG4ElTVFL+NQPmqIegHF2y24c3?=
 =?us-ascii?Q?fNTS89qxVZgdT1gJltuamktTdokd31cFN2Gs86wIrX4uAMcUIrxnrXHebrND?=
 =?us-ascii?Q?r8pxle7Xc2mG6drqdA1Acb/Ch3h7rVu8eCRmfo//rGUIpII9BQFepYaZcmBm?=
 =?us-ascii?Q?E2S3J9dOTQ=3D=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: f9662b1b-b962-4aff-4f5f-08df10137a5e
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:46:35.5022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cpD7Vn6JcBZvZd0OaWCYeZX2Z40BzVhK9SQ8qMtSRKB+jZ8MzTHgA8as71bFGYctjmiMpUFppxBfiuwd+Z0NgV7dcxRl/taQSOBpJigWO+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4P286MB6621

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
 drivers/scsi/sd_zbc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5..f4570bd94 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -589,7 +589,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
                u8 buf[SD_BUF_SIZE])
 {
-       unsigned int nr_zones;
+       u64 nr_zones;
        u32 zone_blocks =3D 0;
        int ret;

@@ -621,6 +621,12 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct q=
ueue_limits *lim,
                goto err;

        nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_bl=
ocks);
+       if (nr_zones > UINT_MAX) {
+               sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
+                         nr_zones);
+               ret =3D -EINVAL;
+               goto err;
+       }
        sdkp->early_zone_info.nr_zones =3D nr_zones;
        sdkp->early_zone_info.zone_blocks =3D zone_blocks;

--
2.50.1 (Apple Git-155)

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
