Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11020102.outbound.protection.outlook.com [52.101.229.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0121A35C6BD;
	Sat, 12 Sep 2026 08:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200202; cv=fail; b=TlMDLdziN0BcIkXZ949C/AJkIUzX8/Fjs/e8Y6m3s8Q6IfsQYqqKdeIUsvpHcCaKbQCNwJiaSXP4SYtYWjd9cIjuzI6dTx4w9ks9JAW6jaV9W27VQ4PipO/cyBJSdrreyX5kKjkxHEw0dpjWSocP74lBBMat4s3bUJwKoZJ++/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200202; c=relaxed/simple;
	bh=oMXBhuzh64++8WZp8mSxyIo+uY9F4safUXbvfQLHA7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ae0KmKtwMbrYS/DD5nFbJ0MoZ2OLgdXsVHFrQ265V/m6wnht8TwiQ993/xzJEPvqEqUCjdOh7xm0/WpzJqBqbzkKwUroYdidsziJOeWikGt2XWCWuK4oJZVIwOjpt92p3M+t4TJlt7YkAMV1u6Kw1DyFkVfsfw/NmTA9F1jWiWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=VeF44VpO; arc=fail smtp.client-ip=52.101.229.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="VeF44VpO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSRfmWdqM09L7u2WFf2T+iMQmEfJxTN1Spd32J2Vp5m10X14RAal/05xLrqws9wPex6IhagVNP1AuFH3gmHrsp8ArUr/GlPiDCvNhsqLBxwdthFWCGS2R6o8dXYOUJDRh3jjt2hcaSV9GM6d2aDrgPU05PoiDBvpnB5XGl3/Hxjarto9yTyiXLIUjy+b2znwP0t9gKYMk1yKmQwcaQVM2VpK+LpICOOxOTlN86geL0on4+jySGjxdu2O+N74apYl4vc51Ox7ygoqef7EWG6wE6udjgdM6oOCwnWkGYzaE8H90VQ5kU0bvWD8Ca4qFJi9D75o1oKVjuR+bsruit5Dkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGYvKuAbBLuNqb89b5jy0qINqvHJx4iNhZgLJcSyUms=;
 b=tFY5nYnakAfApBl4vaVwRtYLkzbwUqf3SbfijG8uilwf1Iocaf5eBrRUTacfEQmqzIPwvIIZjUO7DHLpTU/NW/aUXl2PvHwDZM2DNrEkpnz8eDbz+SeV6qDU74NjnwNZjMNzBcHPXJni1KSNMAccM9OM4pV34v/tdvv1F86Qiq7ariW7Nqjyo7w4ZBHfmyYygJCJBEC5nalDLq5pW3LFtpzgC3az2jOhfwVbtImb5TjxTdBCUgHT16LBIV/pkgLQ9sABX9xNJiByrB5qq2rVEO2xUMkX4BMP35q24kLxWDUhJVlkf/dmqpu8Ju2gEkI2+MhBbDLno/S6qJFwbz5E2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGYvKuAbBLuNqb89b5jy0qINqvHJx4iNhZgLJcSyUms=;
 b=VeF44VpOoa8S+PD0pSeKtq0f9j9BgT70Bb6aGd6w+HVYjFMekpCxp+8Ed7HJlPXET74EiYm0OeKwZuxg+mIscprREKCRqVRj00HxaNhe+Tk0alYJ7N3NvzxEEaDlxmqTFsaAd/M99+nzqsOIXM9DjKqsGT6ZA7utdisO59vea6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by OS7P286MB7475.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sat, 12 Sep
 2026 08:03:15 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 08:03:15 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 1/2] block: fix zones_cond out-of-bounds write on zone report
Date: Sat, 12 Sep 2026 16:03:03 +0800
Message-ID: <20260912080304.78535-2-26066541r@connect.polyu.hk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260912080304.78535-1-26066541r@connect.polyu.hk>
References: <20260912080304.78535-1-26066541r@connect.polyu.hk>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI3PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:295::17) To OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:4c5::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7P286MB8049:EE_|OS7P286MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 92299c6c-cc6c-41a6-bcc8-08df10a44c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|786006|38350700014|56012099006|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	7vBzlM7MgaZMLRNMRBlc3X1tobgDDfJ/wZ0/0RtJi6niS55mq9YcFDomwN8BeiKPmELBoZd4vFjpaPJ19nXrVX2BUv9Y0Yz7SbxWjvnb+oJXSgWCc+FdIOaVix1t1Wj0IL3+f/rk2qHuivIfu4ZsrR6cMnEDf25qH5hx4FH9i5BVQeALHtofPZ3qpL93YEyq5KS1oXzgG3Q1c9uRzbDrMsjdwOF3PRA+oLkFJaj51/HzG0yHd/fEshaDqX4zEXfmJEMzEJCkUHvXQTEWs7dDCSYzNlqDOhq/vpFOn3QK5nE3FnN4QVoPb1IMlz2aVusIOzIV0h6lfd/3b3forRhIX/RrW43gx09GqT7lq5KRDPv8VM1XzPeWyrY3R6p2ukO3EhHcMVhDjBkq3Kh3d5s3hx0/RpDND07LbW9W2/U2sj8uyGUprmK8ijEvpHlH6rQxf07g0phaTtZWHH6XPy8Q+6CptYrztkbVUIZqtlnsDwmwF1qvlhnmN8Kk7tHYEl+Z3SKmtuZZk/UlndvE0AFUS0FAyoRmPGtvRc+ETyZGkwenjvfi8tioMISzrz6gVvKtpew5r5zAiDARpWuACfu0d6boXksYvWFNHkUJh0jfW2/9iZaVdqDctQFVYF/fAoHF4Tn7idbh/J43OcDCxdqsE717bXJPpJ0bV9f9nlP77qUIhPE2QdtEUxVM+DDznsu9hWV2fTo3pTM55WVWBmpuxZ4LbDl7xjBAadR5g/7kSjc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(786006)(38350700014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MGqE6pWwdOMTUHVCqo/ejcTTS6QZ0U8u1i2xLODS3PcXe5vokU1wu8EOW61B?=
 =?us-ascii?Q?YxDunjY9gyB0ZXjgmOhQ/cNdA/auOeE+WPW2keTkV9lLNceAQDh+2jpciF4o?=
 =?us-ascii?Q?5YvTiATgrPG4A7GuP2JPJzDYK2pC5FXbXTjFO+9g/xhXiSPf9Ohgj+2s3RSI?=
 =?us-ascii?Q?DdN4BUMYrs17xeQf6mQ2m6RiZtUqrS3lsdYLc6yS496fBHXM12ij7SqRJsYv?=
 =?us-ascii?Q?gF6xwmLuWZEDv35QxoQgAh/IZPgb3PxFyDSDupPCe29Xj0gpGJcqhydLWNcu?=
 =?us-ascii?Q?Ah5AOECNJtkp97OpdoCA+/bgPMJ/AyCnlWZj2u28/mBdZo7nUD5fc6QyBNsN?=
 =?us-ascii?Q?f1hdIvdKcy3Rdc2xcEfnJXQOELH2nEAeD4TQbfM12/qz++SZAxsYcYRLYRY0?=
 =?us-ascii?Q?2yI7ulvG7TqRe6AIRBw+rQiFKW1VU39y68JOwIclXJhRDOROtSCRYqz7n+aV?=
 =?us-ascii?Q?1/SfJ/torMp1Nhjm3yLgL9zqR7A7yo9ersFdbEJqtyhDlnm7c9qL64mHLq1r?=
 =?us-ascii?Q?2+JP5mUE3jK9GKuq6Dx44LurAoEDn1BU7HE5aHojyprp0yZ93Y4gfShgBQCA?=
 =?us-ascii?Q?T2xfWeKsO0iIWL/6APaOD/9s11D6jTotLxEpVHpXRfuuNi6wyaVcAwsMf4FF?=
 =?us-ascii?Q?+9mQ+Z3vV/hjwmJZrSYWl31Ur/aJJSW00AAYBIoHUsuocGhGIyBfYu4VZKgi?=
 =?us-ascii?Q?dc9K00562A0Wsy1aSjqr3Brs4rXJhSPCVVgoMxgZvSiABq9TrNsWl+XuVITT?=
 =?us-ascii?Q?4DmvGzd63PXLO9Pdp19Pg2/ZplCCBV6MbbIpM2yDRDhGfR77JoIXS8Qb/JGH?=
 =?us-ascii?Q?E7bYN+foxXFx59jOeOhGLlEZJ5DrO0emzdUx7a2RzCfRuLhnNpjtYqAajhN5?=
 =?us-ascii?Q?NBhYUg1nZiQ2DCwqreLtEtjZTae2A9AA6QGVNbG/f9cVabQkq7FVLLvZrPIt?=
 =?us-ascii?Q?JRGj6QRJD2chCXcGmy+UdO0kB42ZWEZCsNFgLQlqLCSCx5JNWHKn+MKyXYPE?=
 =?us-ascii?Q?TrbgdOJhWB6NhJSNQJ39mHGkgdrs3oWQvCrT4w43YkMzpTlgsQBI6FI63G/x?=
 =?us-ascii?Q?mfMi1P61xXSpsXQqgbcH02a86Ut9w+ZIKpBYR/Dyut/xae1pvDx4+QKBXYSl?=
 =?us-ascii?Q?ixBxRSB1CTg4QZTdtjJPx/VGNPew0uKx6DI4m3QOJC3usRUHoXdtU/KGoDJB?=
 =?us-ascii?Q?fNtxEtyrSpxaTmkhxWf+4+sqMGDKJvC5b8nEYesXhP2asQmGBVaBtJJpZtR9?=
 =?us-ascii?Q?5BbbYtBw8ATk1GnwmTpwR+uULgv8L3w8QJkImjXSN8KPMK2wpgxKY8vVRvzH?=
 =?us-ascii?Q?BCrVH/HbKpEbFdOWrufP48h1JODYF54h7luc2tvdNZn3IUiB2l+UZInX+vlv?=
 =?us-ascii?Q?Mo8ZttTrtD0Yq95Il1cFyjDEmoydAXYWpPxDAmJ6W7STvw6iXSo3Ewd+QDg8?=
 =?us-ascii?Q?3QoobzNrr9byKpGnffUoVKdi0qxOc5AZFhJWlreK39wVGcT3R8aYD6/GIMYc?=
 =?us-ascii?Q?F6SecPZ3IakVD6Jyyw0IznPIFOJnSOqO2xgLN3U9IJuPQpsk09klTxNKARIW?=
 =?us-ascii?Q?3kpIsKjUTLBzhBPBT8tS2pzmJaYgIQt1or8YYmbEBZI/8yuW8NF6alZgUQa1?=
 =?us-ascii?Q?TgFnIcHey3/Sk2LgcYVyJm9PeszHpK57rbr8RmFfwKH1KgYJTum/8Qc9xGQ5?=
 =?us-ascii?Q?GYLzNJZL+FWOSrkb2h8gnYrbZRzEvV901SP+l2c638Vg/dg/hJMD8/g9pJSc?=
 =?us-ascii?Q?6uprZ8nfvg=3D=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 92299c6c-cc6c-41a6-bcc8-08df10a44c76
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 08:03:15.4348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+p/a1ZZAR2auNJ5rzc5T8si1PIi5pfTGJpNpGduywNJtTvTEUJa6mfTxA0lTohnwVZzEXVAn82TzzhK7Lkzz90MuZoMJ4eAp3LKlJ3KxpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7P286MB7475

blk_revalidate_disk_zones() sizes the zones_cond array from the disk
capacity and zone size, but the index used by blk_revalidate_zone_cond()
comes from the device-driven report_zones() walk and is never checked
against the array size. A device reporting more zones than fit the
array makes blk_zone_set_cond() write out of bounds.

One way to reach this is a zone count exceeding 32 bits: both
blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones
are unsigned int, so a disk advertising more than UINT_MAX zones (e.g.
2^32 + 1024 zones of one 512-byte logical block) gets its zone count
truncated to a small value, undersizing the array while the report
walk keeps counting upward.

Check the index against the array size before storing the zone
condition, and refuse to revalidate when the zone count does not fit
32 bits.

Fixes: 6e945ffb6555 ("block: use zone condition to determine conventional z=
ones")
Signed-off-by: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a5afb842b..475aa16bc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2018,12 +2018,17 @@ static int disk_revalidate_zone_resources(struct ge=
ndisk *disk,
                                struct blk_revalidate_zone_args *args)
 {
        struct queue_limits *lim =3D &disk->queue->limits;
+       unsigned long long nr_zones;
        unsigned int pool_size;
        int ret =3D 0;

        args->disk =3D disk;
-       args->nr_zones =3D
-               DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+       nr_zones =3D DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sector=
s);
+       if (nr_zones > UINT_MAX) {
+               pr_warn("%s: Too many zones (%llu)\n", disk->disk_name, nr_=
zones);
+               return -EINVAL;
+       }
+       args->nr_zones =3D nr_zones;

        /* Cached zone conditions: 1 byte per zone */
        args->zones_cond =3D kzalloc(args->nr_zones, GFP_NOIO);
@@ -2131,6 +2136,12 @@ static int blk_revalidate_zone_cond(struct blk_zone =
*zone, unsigned int idx,
 {
        enum blk_zone_cond cond =3D zone->cond;

+       if (idx >=3D args->nr_zones) {
+               pr_warn("%s: Zone report index %u exceeds zone count %u\n",
+                       args->disk->disk_name, idx, args->nr_zones);
+               return -EINVAL;
+       }
+
        /* Check that the zone condition is consistent with the zone type. =
*/
        switch (cond) {
        case BLK_ZONE_COND_NOT_WP:
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
