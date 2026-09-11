Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11021080.outbound.protection.outlook.com [40.107.74.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088982F5337;
	Fri, 11 Sep 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138002; cv=fail; b=dZ6WLDGNVRc3VQYBwPoJf/hhSXPWA9G6U/Ac7RvjvvqhQA/yvw/uhHO/vCGr7Tsh4g8pODcGTzeDU4jD2LFW0cNu4xUP5FhT3ldcZ9x3rGABSXM1q5ElJIhuI98AgI7p2PNT8/PGXpUyT3aEkXJK2SIVC6s2slLvsKqPuvOW2Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138002; c=relaxed/simple;
	bh=oMXBhuzh64++8WZp8mSxyIo+uY9F4safUXbvfQLHA7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k7InURfZUXnZtnArG90k7q4mZmWCEdvRaxDxZFq6SWmHpUzvipVt0sNzHPvBy2Q11MgCYUrOMOm1jV3bSmE508COP9Qkqo7rMZ1LD7wqy2c2U8B6GiDtYp7QdtMiAf68srYO/V593XK1WAf/upYfODFF+eGX6D6sMDRHaIKzFHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=Wv0Q69ha; arc=fail smtp.client-ip=40.107.74.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="Wv0Q69ha"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHh57GvELKA/NVTkVeW/7o078fjLKy3uge5yMoCQUvKfHgGQl/Vg1GzLtffwLJF8k05RWYgCMks5oQyK5tQp88mcaFTiOo3N6/krF84lVE5Sp4C4ZdRzfHzeiRpdC4UcEGFOutw44F32QruAwgimgkpm1rXQyljKEaT+sT93inaqXy6jwDh2FSVNKtoREo5aXma9ju0/2HSXb0Z/cFjMVdk+9YGbzIAXqvZtRqwqb614/xLwzvg0AdcnsrOocB66ETsIJQ2zND/A4foBDESx+Y8tz8bzpQYX6MkOPJbju90whnXvsd1RvoDQwzSqnrPypTF58ST74ISo9ZasuXGDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGYvKuAbBLuNqb89b5jy0qINqvHJx4iNhZgLJcSyUms=;
 b=W72yf9lDTyS6sLVZi3i3Q7bWIEC4R0hoY74tvGnJEkUonC3/81B5ETgY0DHcYnHGY5QJaDTG9ga91ba7qx6mZ2G56WVJCZIiRgBVybch0rD//TNfkGWoBC4n6qosG0+rMD3ViUCB0+0ae+g6PNWlD3ubU6Hq9LpLdjISz/jPn77wzzXSc5EjIJTklDTx/5ExLTQLzfAK17Y4VuLlOrI9tczXYdS1nZUNrQZm+/lOyRymc/SnDb5Q0GXPWrT748w3Gz0AfHIzIeznjpDXfVBysVr81yWcEPTxuqSvd1UbRmlriVU4qxA9NtQ4s0laAJA6tM2JYyLaWn7pQBY/lb/5/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGYvKuAbBLuNqb89b5jy0qINqvHJx4iNhZgLJcSyUms=;
 b=Wv0Q69haJFXsseYY27jiCoxs8Ni5jOyhvN8jVYkAQZXjECMSZlhwct+1euTnIaXwh+RuglsSEcZaJZwBGARlUb421cq2mSz3O+IJjiRbDfudeamdoTJdVcQPFcyzP+FRjSOdPzfSZzXPc2dWoB8heJDV7hVhO4zIhdBqIDp1MlY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by TY4P286MB6621.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:342::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 14:46:34 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:46:34 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/2] block: fix zones_cond out-of-bounds write on zone report
Date: Fri, 11 Sep 2026 22:46:13 +0800
Message-ID: <20260911144614.39553-2-26066541r@connect.polyu.hk>
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
X-MS-Office365-Filtering-Correlation-Id: 32533c1c-44df-42d1-462c-08df101379a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|786006|23010399003|10067099003|56012099006|11063799006|6133799003|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	S09TzoWg7RGZ7XCoY570tWFpE0zM6I7Jx5TYFDnvrFdttsBFwdoBtMlz8uvvTdmwB96MoRHHjfdP3QqOieBpLiO0+VaRLnjv72rAkMSwR7u3RatEW9fLIms1CwnySUd9VwEysODweAMgXUp/GTFkUxRFpyvY/iAnYamwzxuCnQ9AoXciDMD6EeIkcxNBnCaxN3seZqLcLyI4/ZlQ3dmAdvgJnkAEiY3A8RnkA5fC486nQ32o8H0poOpewNj51IqzwP4a9PAklP4SIyd6LKB1jfFn5uOV2Jn8tCyBMVg+qHkhvRbLfVPAH3tichWKfDbhjlmFYBQNMVH0xSpm0I372il1SslYvxoFY0B0GKV7ymxfocvorq+1IvnmdsenNn/xwgcLKdxdgSI0XZaNcEtUVWiTM+gU1DUKzI7pim8JhjvoSzBd8rw475IdBO6g4S0sJdZPLLpe0F4ZprFXKM3PnESVcAcPH5oxINuChEqKYroT50HUepWm1C+bDjlC6B+eMwNvR382QuGapwHHqHUQ4Ei6QGGqHskNKv/MwRXvj2DRqEzFae29v/bfBtbSjxyX3Jc42i47psS2oXineNPJPAM5vrmA8s/JkqSXjohw0rlSODt6rfvakEnaaEs2u7FKs0vGYEXueOqJT9lgA6K/bCbVfoHO6v97R6m5IyE4XgTfO47sV8HWLy+PX0LC0bPyWwRtRd481zauX9a9hlzqG+PVnweegeMcoTiaVZiOJBo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(786006)(23010399003)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IJ9gmeIVoduAm2nTs0jdx8mcSB+9G+Iyd9xyKV5jL/0qMTx5FITJYpOrtm0M?=
 =?us-ascii?Q?+vXKTQc4i70UgEFiRw540YuaF/r+G4LWJ4SqmF0oIJVumh5tO6fvFu4KcRiN?=
 =?us-ascii?Q?e9LRJN86Jp5QMfqAIiBb58i4HdFo7+LqfWqhGvkrWm1zZrmqn0kFhKcfS3GV?=
 =?us-ascii?Q?SPw/RBLtKUwkX2SNAPduEhA4cAPe0qvLvAAV1T6JJjGUaIqZH8FXWOHvH69o?=
 =?us-ascii?Q?cCURv6h3HujQY40AERRIPFBc5UWnNdRtGpgOnBd5qstRozPphbG+5MyHoKf+?=
 =?us-ascii?Q?BBL9qJuEOHmEYoOsB1gcw2fX6IGAmdsfZhdzM0zsZTVa7zbp25C3zaspqI9A?=
 =?us-ascii?Q?qTQnCQofH6/RpRRGTjwrupVfw1vr1qu/hLYQT5KxfYg0tF7RC/sS+KmDU7aA?=
 =?us-ascii?Q?1i6Ac8b5o/j3kPT/mtPR4p5ZxoCpiTBEN0Px4MEjwSnyU4fezNSqcIg3QBXg?=
 =?us-ascii?Q?yfyMdrk4/3zcbrq/rXIF4MW7J4kRKBYKPEFzqX5+Q72UaOon+x5trKOxLLo/?=
 =?us-ascii?Q?a5bn2aRN3BrWthz+8YgalX+26d6VcBoqnq+TbuKVH9o46PilenjcWrXdGvHP?=
 =?us-ascii?Q?xzv8r0nyfPOn2xyE8bqzJgbshGmCQM+kIVouMcbuIzjJyg7eoFROLtWcFfsw?=
 =?us-ascii?Q?vqUHJQy8usEZSOUwk0cLJdB3aBNbsQGVEu88gcFRDNrgivaef8PzC4qaGhgU?=
 =?us-ascii?Q?MFNz273bJnf/NRGr9pG1kXc5+1YG40s8pbGBgG6j6nnroU9lWRuaHj48gLTY?=
 =?us-ascii?Q?ddbsW2Bj/GhkKNQ1dS/pUHfvr7AxHkSKcvVwwcvz1TMOVqfDmTFzHE1bxjUz?=
 =?us-ascii?Q?mVlsO3IuFZgeJrGT58zrOhYaKX1otZ2sSrdfKeCLPU15C1gbKh8lwgliUxKF?=
 =?us-ascii?Q?elVjv9OMH4i8KrV0ye+yzqJddD44wTIGsuh7KaizNoMu3zsNIJ4AwrAt7Ia7?=
 =?us-ascii?Q?q/JRNZa7BpyI+vvBWe0oyAiTbtD6lc7QL4I6ok0h5VFOVS042rUzRkxLPUwm?=
 =?us-ascii?Q?ArdeVdNuk6eDMMVWx+lCCL5L5hsKFrjFiGH7i0xM3LaaeNkzujo3eNXa+6L4?=
 =?us-ascii?Q?k6Ha40ZH2nynkMrWm1/XgOjKuaAZMdOAbyaSCjNZ21XRi/jykKA3run4vwcr?=
 =?us-ascii?Q?A053BknInWl8cxNKA3GWGjKBNi5J3F67ZCRa77InmxHT8I4CBZ565fGjvZPc?=
 =?us-ascii?Q?rh4JFkJKjiiTGWBubbnu5kF4ueTzTxqPyFgr6dUmdDxXKDAQ17snKyp0iZoL?=
 =?us-ascii?Q?Pw3kuAQ6htc2oO6QX5bTTAZz+8CeWfdki3NUbQK9IcNYbhn/9TZattIirNeQ?=
 =?us-ascii?Q?r042TnadccZz86Lpzi9W9knafLctD0GIxykVLEfddTeE65Kl+BR/EBDnT8TZ?=
 =?us-ascii?Q?AhEcV3gHkYHzSI3JyLkpAKyXDYczwapm/ROrv7xf5Ob6Wud9xAezCbO4g1uG?=
 =?us-ascii?Q?yYJh225Cypfv7V7Nsfk1jyMMu9myZWidSxLB9WqyVn8NZ7c3AVArv+dVrnxf?=
 =?us-ascii?Q?lUaUtpolbsoImmgJW+3AtHO+/ERW6A5XI7k3WZe4egYaCWAjcBA+68XX6JY5?=
 =?us-ascii?Q?MMHdkD7NG/LndGHZZ6VBeQCTJlLNak7yK/85N8JjavK7b59/qcxRH0ihKuhY?=
 =?us-ascii?Q?xbAsx5lXhaXe7q0TJNuPfTYHkjzrQeGNJ+BJlK3ju+ueuoBwuEnqo2rVviyp?=
 =?us-ascii?Q?LBywxmyDzU0OZ8kuljYF4wQ2xSN4g547UjzyPYnMliVgCbRXcfB3nejV1sjH?=
 =?us-ascii?Q?jRrsGhrCmg=3D=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 32533c1c-44df-42d1-462c-08df101379a7
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:46:34.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1F0ELWaW9MH1FCWe615Q9aXANUBtqt456r8JHoKDn0tsYhxOCp0UCyI1C4YGC6fC+y8YKmQbTSFyTXI4qKiMfJIzlEcvgdy2HhVeLiIyPlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4P286MB6621

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
