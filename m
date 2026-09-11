Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11021113.outbound.protection.outlook.com [52.101.125.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2673033E3;
	Fri, 11 Sep 2026 04:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.125.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789099910; cv=fail; b=JMyf0kSJkU3DegRG4ZrquBgJ4cC4mUTdIRd12TDsLr55c3pIeJVPC2m/W08U0XMHqiLv2dgUKWuSPu1IAwbSPRzXw0GadgcFHdw6Vroln1O6UYAg4tknl0iZ4XyXbiYs+3YlHde4WDy/fET5Pws0E167aCZic3E5PVP1CJ5G6dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789099910; c=relaxed/simple;
	bh=fn4I3Gb3ZXjOafIqaBzFOOc0RRxvEyTEdlrBF9o3HX4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=nm1oqjFvtkaUXenLX1BOeL5uOLeZJ6G/l+sfyrsyzqXo23Tz6OY+WYFgWRLLAx0uTA+IT5rA1q/AxIbzYGRSBL5/zWWeYKbl7TIc2LwrL80n0hZgx19X0WO3yMEBNp+SVcUZ96A1JUNyqAGORlHJBo/6RzBQVwt/Go10VZIsyCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=ppdF/VdI; arc=fail smtp.client-ip=52.101.125.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="ppdF/VdI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AGt1S98Bq5ChkiRy6aRanFbDTzUUyN3yYw94dhVRbQB8gsNw88PPjzqRw5hezreRtwKzJnn2+Nga/xnxqzE8KpUv7aTAufeoI9p9CFfpsov8R1+Ov08krWZ4lcuhRjKi5RMpz1CH1HWBDbt99U0DIcowMVf0ZJDtlaSDpqq7RtEcK9NQdJ+M+9PDcwuhsRYCsSgoJxtmXmXfJ4Oj3Jzi8OZOpEICN52+C9nbLDOtLNje5Gh/KMMVEigiJy/Jzst+C9zD74DMGFG65V8jTp1z6dkSGuEtwZ3tNq87mOLD3OudWNGIrlK+Zwdtdm3HyjB0FrB00nSv8inSS25YzSanyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pB0IfzXw8RKFA7uge9HJVmoEk+3JKwH+dD1cASZVLM0=;
 b=ekHbc6VD9+im9xVFgFSsh+p0lwweypJ35P4LH/ZBEDU30MFzTet5xFtn9Ih/0OEgd0P1OGmfzVZ7Z2cx3Cdm0+Sh8IVNMRx8gSW5XjoREgJBOr7ZtcNq462hZ5iUYMLE1NPk2ih+LNWm4dVI9n4tc+DoMEZUU9ECW5XQG8ORlKa8d/4Gu4m4dOe6WedwAF4J7B0orAr4O0hLw1zGXwSqdZRuzDnsGgUfx5TwdE07PPo8PgjYU47jr/DW4HuCZPXQ1mvAaNXqQDRUQ2gWIG7PBbiGAAVif06qquZleOwxyIRhVMVewrkxx+kn0CYm9LPM1JGWMGGRUARNAgSsStN7bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pB0IfzXw8RKFA7uge9HJVmoEk+3JKwH+dD1cASZVLM0=;
 b=ppdF/VdIfjeqUHWO2QqrJr353j45rKHLFlYFcZEvRqbhr2p1QkwJ9Wa0t5feiyEL4LSMyUNL5tDK1EB127hSEajuxj4AIdFuKBntLGAu6IgTId3UAUkp93GYpi1BFJ1pgMeKv0oOQu95M1PL4cpiXFrYYDeiYPPvwgLqHVRZ0jo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by OS9P286MB6583.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:416::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 04:11:45 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 04:11:44 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] block/scsi: fix zones_cond out-of-bounds write on zone report
Date: Fri, 11 Sep 2026 04:11:27 +0000
Message-Id: <20260911041129.128280-1-26066541r@connect.polyu.hk>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: b7c5b029-0be4-47d4-d5dd-08df0fbacaa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|786006|52116014|376014|10067099003|6133799003|18002099003|56012099006|11063799006|38350700014;
X-Microsoft-Antispam-Message-Info:
	iAiV577lpvTmMY/NfqlpcDgfDQ7x1c/Rd488q3eyHMC2eQnKry2HyazlkKgM/D46bNFP2yljUuKb9w825xlhb0ZZLF+cSz9HqYmJEeEeQramEfIsAno50wZlter3RwX6DHQFFtefAbjiVg6SIrrKnSbgsnVCJ1unp8NZyPGH15+cpGuxRcicvExVNhtnlNyKTXo0Xg+/3e9ttEYNVlvU4RsZw93P8HepsZKDDI+YT3E/mm9Qu61rIG9y8bDtJVH/6yHfhaRYMxY1PTGsLiYekVE7OZyLRB2M0L86n7VuVy5HZsZORUwDgz+oIL7GmXaQQ6pAKdqTmQcQKREESfusZRra1/9vgqmclCfUyemF45i8PYAL9djJpMK8ICPV1CnaY4amNcTFWooblbQtuAGp595hYRUfPEBYqH8UcD/B7GCKN7iUYGabMB2/DQqwMJIjk+LjNi8IFKA9NmO++ynIusXadFWwRJsUIHiJclJBFezVn7OmBintIlAxmkr0oDBjkq//ZNX6yy8tYb2DYkOJkK9k8U+4Em//tIDaNID50FWDcROgpenwX9AGD9+2WwHbDorfUa2uMdTWBY06jPQhegIqyV27LQHxtWoyiSCAViGoBzd4bHWVLKINL8QyWOfuMVHw+p8X3F9Wm+Asy+NcfDrOKkldar6hPvyhVtceV5KFT5pTQZ4jN7sX+8JZziIcE9YOOweKq9B2mMqW1JR/ioPpjXXYc4oWsjXkYbugUs4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(786006)(52116014)(376014)(10067099003)(6133799003)(18002099003)(56012099006)(11063799006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qUCiIptQV/FbAYPrkbFoRIqxcEW/yEqANrYEB+pGY/lKhLyEtEzv0zxs5iwq?=
 =?us-ascii?Q?O69GGDz7ozVXb0O8jI3OrWp0DilCv3L3oktVEw6EhBeaCfFX+PsNcKNOSaKd?=
 =?us-ascii?Q?QncoqLgTy9PmYFagbiFuB7uod1LfMiGJ55naQdI7VLT3QuTQ3WQq/oCp16C3?=
 =?us-ascii?Q?+tN3LTCE2dznGDjWHWZKS+WBOeGS5Xusb4djTnBbbcCqRVdbR5vyFFApowi7?=
 =?us-ascii?Q?3i5ZdR91oTRu/YOmRteQ1nupAWq9CxfwGauugos5KeZs65iyesqoj4gi/Rrd?=
 =?us-ascii?Q?3oFUJ+dE9AgdWsQEuLRYwQbmPqeIb6OriZKiymKpbjlbiyhCl+cFYr9XmKuM?=
 =?us-ascii?Q?i8+/MMl2+5KMBBikRhrW5oKMhk0RsttCmambEXA/vOGLWmb6fdY4LdVWGKkj?=
 =?us-ascii?Q?yTtopuLvUWwSfYZB6ky2PFu3v2nRuZnWrj9j9nqtNt/DeqSoGQNZ8lpqEpZo?=
 =?us-ascii?Q?mc0NRv+Je8uK3v3Bq/CUSSkPXK1Z/Y8i5Rn8IejS7FRd8q1vPBwj44GAG06G?=
 =?us-ascii?Q?wmLahH/dHpEf0pfcXOYv/YOEd2cFagGU4ZBvBcWUVJgUym7l/dnuImtqPZtN?=
 =?us-ascii?Q?PFrO5H1WYzVZQy3Fp7+JX1p/6pBBxT8Y/DI2GpFh1pNL4De7ZlvrjT6fY7RS?=
 =?us-ascii?Q?Rw0/N0xZhTJ/CMsOY4quMPLo8eI/tCKnTKjfJC+mhHQWjEQtt7qmPUw0cO09?=
 =?us-ascii?Q?ZPnflURG7hYmzSBMTsAdAO1WNuFIMnucin6MSzKANne3kdedGfGnrQ/BYf9k?=
 =?us-ascii?Q?T5FsfvdAcFRGIOuNMK1EBQFaeY0sNRfbaxrYxYLp5+AqS1WS0/7YCde3wHGa?=
 =?us-ascii?Q?60Oy5lJi85TlVjP9DoaW5ZV7M2UuRKhqVlpHlBF519O4Vr7qz5bxpru3DJwX?=
 =?us-ascii?Q?t39+R1mMPYnzfFSR7NyfWSt8JGW0yEjJ7M/V/LUkVbjEEH4AGnViCyum3NEP?=
 =?us-ascii?Q?JBeVnoqoNkuzk8zhi0WL8kmoCyZXs121loV0jXHOLCPpdSUAj8Rj9lnJRlrG?=
 =?us-ascii?Q?9oNGoL4V9iUPUERLDh6WaBLaKMMohsriPd9jd9NjyFOqzLJzK3SSL8Jgb2TV?=
 =?us-ascii?Q?gShCKwHcmefPcsN8kcX3R+x7cOnLSTUzYGPx8sV7MClwdQnZ46tqLAo6QSLD?=
 =?us-ascii?Q?SsnW5tcMgSMpPXT6ytkIr+OU+lCtvL36zUkFmAXP4MAWtpbn3EsqSOnQuSMc?=
 =?us-ascii?Q?i5KBuqiqhVZcZ9HUzz+jbMLhBpJXWjP419RuWwplSfnx0HaB44sikb2B9lig?=
 =?us-ascii?Q?LNwXyBT8GMzsuO2345MhJ6vXIYFpQ5rl0dusDTTHLVAGF0RmTmQN5twwPZaN?=
 =?us-ascii?Q?NI+y9xDwTMQ6Q24AyqT+xAWkDhoPSs834ZFsbDFMHMdUMyZSEtNuH4TfjZ5z?=
 =?us-ascii?Q?dGX1mQHzvFQgqHmlIe5kL7qMV9F8NusdKE3hXRS/BS9il04pjCDi1YP9+N8B?=
 =?us-ascii?Q?gE4vlc5QNIm1uliX1d1+VWMrqgcEBtUecTkNtgzMfCA7rWAqryHww0D3zk8U?=
 =?us-ascii?Q?el4ozzegVKJ0BDjSHmVke346rx7B8p3yfH3LNk41wqwRo3kSlSnkLe/rLIi+?=
 =?us-ascii?Q?PJHpQik/gG2s0AJmPYAf6TsRYmMBGU7dcWNL2M4QUVMPodg9OJR07jn9FOMS?=
 =?us-ascii?Q?Zn365e3iGXJsc/TO5fT5qRXhWMAHVHgILHs8SGpez4DEPDRadhlXjS2M7VSY?=
 =?us-ascii?Q?tlfpPFXFwnSE5b5ZVDuMZ+fnjBjDYi4blGr39wv/CrDVQ5HxY448guLZamX4?=
 =?us-ascii?Q?4r6SvzSAkwbBc82TjTQFbTkCG0vUe1A=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: b7c5b029-0be4-47d4-d5dd-08df0fbacaa7
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 04:11:44.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vyVCsxU+xHE5MAO9CINPOvBQL371nE7SjNmMg6dllLQfhc7S//MWUg+tO3txcpy9oniXFppoL0k1q3sfo8WMFAFy3fIBg8Q0KjU/Xf81Caw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS9P286MB6583

blk_revalidate_disk_zones() sizes the zones_cond array from the disk
capacity and zone size, but the per-zone index used by
blk_revalidate_zone_cond() comes from the device-driven report_zones()
walk and is never checked against the array size. A device that reports
more zones than the array holds makes blk_zone_set_cond() write out of
bounds, one byte per extra zone.

A concrete way to reach it is a zone count that does not fit 32 bits:
both struct blk_revalidate_zone_args.nr_zones and struct
zoned_disk_info.nr_zones are unsigned int, so a disk advertising
2^32 + 1024 zones of one 512-byte logical block gets its count
truncated to 1024; the array is allocated for 1024 zones while the
report walk proceeds past index 1024.

This is structurally analogous to CVE-2025-40345 (a device-reported
value exceeding a capacity-derived table corrupts kernel heap) and,
like CVE-2024-47682, it is fed by target-supplied data in the sd
revalidation path. As in that report, note that sd also sits on network
transports (iSCSI/SRP/FCoE), so the malformed geometry can arrive from a
remote target, not only from a physically attached device.

Verified on commit 50d05c7c76c9 ("Merge tag 'landlock-7.3-rc3'
of git://git.kernel.org/pub/scm/linux/kernel/git/mic/linux"), which
is v7.3-rc2, using KASAN builds on x86_64 and arm64:

  BUG: KASAN: slab-out-of-bounds in blk_revalidate_zone_cb
  Write of size 1 ... 0 bytes to the right of allocated 1024-byte region
  sd_probe -> sd_revalidate_disk -> sd_zbc_revalidate_zones
    -> blk_revalidate_disk_zones -> sd_zbc_report_zones
    -> blk_revalidate_zone_cb

I have a working reproducer (dummy_hcd + raw-gadget ZBC device and a
minimal initramfs) as well as a full privilege-escalation demonstration
built on the primitive. As this report is the product of AI-assisted
analysis I am treating it as public per
Documentation/process/security-bugs.rst; both are available privately on
request.

Patch 1/2 fixes the write site and the block-layer truncation, which
covers every blk_revalidate_disk_zones() caller (sd, nvme, virtio-blk,
dm, null_blk, ublk, zloop). Patch 2/2 makes the SCSI path reject such
devices cleanly at scan time, before the truncated count reaches the
block layer.

Before the series the reproducer triggers the KASAN report above and the
escalation demonstration reaches a root shell from uid 1000. After the
series the device is rejected ("Too many zones"), there is no KASAN
report, and the demonstration no longer progresses. Each layer was also
verified independently (block-layer guard alone, and the write-site
check alone).

ZHOU Jiaxiang (2):
  block: fix zones_cond out-of-bounds write on zone report
  scsi: sd_zbc: reject disks with too many zones

 block/blk-zoned.c     | 15 +++++++++++++--
 drivers/scsi/sd_zbc.c | 11 ++++++++++-
 2 files changed, 23 insertions(+), 3 deletions(-)

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
