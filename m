Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11020102.outbound.protection.outlook.com [52.101.229.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8477D2931FB;
	Sat, 12 Sep 2026 08:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200199; cv=fail; b=XKv4OuG9bZX/Hk1Ljm++BWfQlvQkrEDup2KqzZmVBnVoeo/ORoJ9BWazqY4i65t7AQKZKob2v1iRGGygNMeyF0/K0mBnKJivbJauICTMi1sWlymdpeso4s6DwQynBkKhNDPE8dVZ1T1Sixmjr06oO+J+Aajx6Sa8b3p4IBQ9uK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200199; c=relaxed/simple;
	bh=I6UBxWZlUByswBD5ocIgpbMdyzGQ4SW7zb4FCdpRU9A=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gpMn1O9fofvAsDCmKIdRZG+l9qMi1A/BkjXtIA835UpwtsvxY9li5q827OAJb1nzLmwGwVsPrZZkVFahD/fsPJkia8fm3Uuk79H7Nl2suxhsDZX42ayh5g3yxf3BDBKcbdIeUs8e6i3aaTWVJVOHHMMSNFYAX3bgcIKp+jMvnog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=d4S83ADZ; arc=fail smtp.client-ip=52.101.229.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="d4S83ADZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pe9ebza3XUFoEZWn6hyV8e6PH/jeMzc//1h1VvePeDHXkmHqZYpjhIjbxtyodDqRHM3U6De/o23LZMPJlg5Qeh6rI3EDNzwSHmBfS8zyC9U5G9hBvF2PqF2zE/r3huK8UeZj4AHrn6qbPdRcIF2C8p+H8fnXsUOdYHUE2s7iJqDCjGJRg3LZIa+OvIPawiFzw2Dtd9FoECHrcmOffuBzUaMFbwOgGBKetbLRPUYTF+qEIiuH3q3pwfqjja+pHPGNNtz4c3Y2HhJFijhF6KKANxOUhXexr6IqwdLTiPXcXC+e1beBuw1Uta1Mh4MW6TkSN53Q6dntsuWqKan5xQoPBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyfPyPx58pzLTCC2RzJOjvMEhzWei2AL/R2vuTlT6Uw=;
 b=StM9xqWZ05aLbI5cn/t/gQzJHaHYdphOUJYPCjG3YDAo62Jw/vQFmkgkDxdF/T9/N2fC5pwsdiS6r2wQDdplk4/Px3n2FedbrpFcKo5zxsdl5UFFZrym++jPlow/qxenIp+vMKn+o2w4/FfjvE1ytEDhYJL1K0+Fivji0iPLlCCiysSn6tJFiSSCDoZGHSA5H/J26lAA1l1EOsTgPbcYJUIVdtDQfh8maMasiTpFF5+3D+LxtcgaGTE+qVHRgSBeH/gtrF4PlhtFChGPFIlItq9+FAJufG/FGDaibaxTT6galmm0eHBSoOTrqfsV2PR+VG/cESnPrG66sEkivFnWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyfPyPx58pzLTCC2RzJOjvMEhzWei2AL/R2vuTlT6Uw=;
 b=d4S83ADZ01UAO2Sl8yE3I51XURAxAIL2aasnt/9R0/Ukfl7teJ57b6HwuOjR3LJJc3LddFjZxdUJJGwoy6LtNYNJueclV1YKUNaJ4i8r8Qh5rw1ZHeY0IWi/EUIICfxvwHYFPj7aE/x/Jg6ULY/dEiV1NXWIVfcBnrloO/v2Bi8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by OS7P286MB7475.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sat, 12 Sep
 2026 08:03:13 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 08:03:13 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 0/2] block/scsi: fix zones_cond out-of-bounds write on zone report
Date: Sat, 12 Sep 2026 16:03:02 +0800
Message-ID: <20260912080304.78535-1-26066541r@connect.polyu.hk>
X-Mailer: git-send-email 2.50.1
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
X-MS-Office365-Filtering-Correlation-Id: 2753435d-12e0-4903-012b-08df10a44b6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|786006|38350700014|56012099006|11063799006|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	0HMxIOP9sIJ6ikRNZj9kKSMay2x5+/Vlp6AVf0Z/RWiqzAdeGhcnF7RHlaWjwn5aCPbQ3cWBTs3yczZeCawe8aXsJn6s66d5z7xXNJ19tZK3OcpdbP2LZLmvTuyJdjfkAYLi/uIXhfBj/wASOI1+S1KcPEkgffnZvXtYemdFuKdpkaSPRz0ry98OQ1wHWxbhEFLUsl7iqM6HHvEsKWk3FEfvNaPLictURbbkLykidk3o6ca//wddI+OmTcaCzuh29JadkYoLXrrM7yW6Y1aOURcgg/Q3Hw5pALwrG3rE+y77tcohnh1TmHSnXQYBz56HD/2JUWAidyOFACvfCjRj8sLyzZ54Ak7a60s4tjBtl2rcIFzjFAVhqtQeoj/VIgk5VsMRfx5281qiDpz9SKHCnBCgf4SHn270G8bjS1YyXGqJ7dfJ6EI9qSoU0vaMaIcDNtyingSwDToPsefXhPRu3VnfQy36+nw3sij5euLl12AeOeEI4z1x4rwbr80V4LDjVGmD33tUyoRrxfU7p8I5FOAQJ/eQdNtrMqTFXAptFupvtmsL7BPHnoOb4FtTZvvCHUqGa76TnWH0RZP7RbnWbSwLVyE3uQbagSso3d4Z3z79UfJoXYKadK/zyNlHBkbNIy8IRwJoisS6lVzavkKB6YJro576khvzIP4l1S24+c769B8irOoTL9/AYBFA9ICkR2QDrNM+mTIsgB7olEtYGXIe3JR94srqloeIPjneuKQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(786006)(38350700014)(56012099006)(11063799006)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kLO2PNULnLAXuqLPI5ctzX5kIkv3ammAWkmXEIXAGBRGjr1uvM2ICYk2rNuZ?=
 =?us-ascii?Q?qTcdd6F5503capyHNE868z8EDFE9o5UTM/emM/1rgCL2Ndbzqq1tP3TV7EYv?=
 =?us-ascii?Q?51brBnhvqLyp7SMI4NYatwXPF7EC1XZgX0zfnz+bfAC6/pO8sYV7QGo29mQ7?=
 =?us-ascii?Q?pfElXKT4yugEiS/fLhPgzAdyS3b8W40eWL42uV9xA4v3npXz0APCpD7elPoH?=
 =?us-ascii?Q?uPRtTN9Sd/cihPZhAu4hQkBROOwl1JYU+9Wegcx7gIEpbNU6ajeP9L6GhuO8?=
 =?us-ascii?Q?caGLJNOlKO7nAHdHgeSj9tiVQI2BQVkodyfjMdUzycdnzvj0HDjXMfaohFjn?=
 =?us-ascii?Q?ZkJ2GvN4WhXlFuZ7GEbmXKi7NuMfU1zncc07APLaa+57R7ns+bBJIf5iCIph?=
 =?us-ascii?Q?t1VQe3yioNqqW/k9kIbq965Ki77/XFtYHoU0N09RKnrDd60NVfgy7W0xx4sN?=
 =?us-ascii?Q?YKOlEqmSAYm8HkbpdFGhAKnO2LB5qOZFAIjjR/AEni1xEmMhIDDhRJmFY9mi?=
 =?us-ascii?Q?h0FifWmB3nFm3QcPfauFCjdqKE0J/CiLrBoAA5n1GgCEx1KDb2tA84dvJ4ZB?=
 =?us-ascii?Q?AGftgV5WgcJPrgYukZNRnxoxPOat+bC8DL/Gm8+xbCDLFLhAFwGgBGAGfs7J?=
 =?us-ascii?Q?uNJL9t4JSaENCbXXN+JZuThKgqITsw7hxlwxg6aEPkJ0BkaefJf/j/ZCLIlO?=
 =?us-ascii?Q?+bLq/515/LkefTAtbe1VP61gO4h5WoqiXwumq3HNTLnqsMCGulMMBwG8hTG7?=
 =?us-ascii?Q?PHAsqRnadlI1fD6F5zKe50WeVGGJqopOdunGFESKlEz+UqZnaaDkpAzkaBEC?=
 =?us-ascii?Q?bRzSdX/pseSOuriQAWm1wxqWdiuTQ53V+8Wqj4PAiew4jpWJxFdvuB5S9Bw+?=
 =?us-ascii?Q?sYasQo8sh3Dzd6Yu6FXlTTg6Ab9qwQAsSb24JdO/4inI3RpvWhyno25+1Bd0?=
 =?us-ascii?Q?S1mxcROm7ERDsUUvU3l7vNDIB++32vr51nksAFn6m7cNZ7Zb6n7v0mFpj8tb?=
 =?us-ascii?Q?UwzB1SJzNnls9Tm6OVFfAfURh1Je5BkXjFYA57zyBuYpHS8SOPoGB54rKMcM?=
 =?us-ascii?Q?bZwUyl5CC4eI4rC48FCCKX22v734x3ObjQveGha5+gLJbj+hXAx9Xa8+ilHB?=
 =?us-ascii?Q?WiFjt3TlCJREtrO9gbJ52eD+T0VDjOr9wqqkrmwFLtXfSwMhOx3LbF9IoK8l?=
 =?us-ascii?Q?+oKypNzGYjPXdx1HNPFev3OLm+2RjVo5GF6jX22XxC8GYi3oKBxEuCdNU4p4?=
 =?us-ascii?Q?GSCM3dyi34avSqQyoKgFGoGo0g5e4qLxYEh99mESW87JM/siF3usnAVbh7Tv?=
 =?us-ascii?Q?MHA7iWGRYN6fRMnmX+DKJsnz2gkWvJ6HeIesQfMF628ZsYzvVWKcZYbYoxVC?=
 =?us-ascii?Q?jqkndQ1va7y8NEcSUIdFsb6ZMhKqBu0yU8p84dRB28+KpGPqY4tLdYkCd6Km?=
 =?us-ascii?Q?agc+/fv39EXvKqth2f1k6YrmhwXcKwl4Hu0TFu5Zds1jCf5xttaydaByqIpW?=
 =?us-ascii?Q?gsqui/4/0V5s8r+eTorFBftoafkrYHpQtQGN34x0JLutBxVaxxjupqXorkJZ?=
 =?us-ascii?Q?XGundIHfwHSDNDIuFdW+9lZNURhOUFXIMmCdkZOlbuXJHhfiGApUR5cLwnhG?=
 =?us-ascii?Q?rKfgZHizN8P5Mdwp14ryjn8dhdooiSxK61rryQPsaBKymsXG7d9qr01mMzs7?=
 =?us-ascii?Q?zGYvrG34QHSM6Ep5b+vsEkNaQw+xx2/gnMpG+7Z/6bJr+esOYjF+rSKTaQdo?=
 =?us-ascii?Q?ghku6SOrkg=3D=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2753435d-12e0-4903-012b-08df10a44b6b
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 08:03:13.6479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4rzyR8H0bFWUT5V9eEsYFPvzqF6druiAo/Lw5SE8iyo2KaZuagFrTkP2j3aRQdF/MuVqe/jOievUT8fUfS8zwtDPAlGvJ+uTm9Tqk0S0kQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7P286MB7475

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

Changes in v3:
- patch 2/2: add the Fixes tag requested by Damien and his Reviewed-by.

Changes in v2:
- patch 2/2: keep the single nr_zones variable, now u64, instead of
  adding a separate nr_zones64 temporary, as suggested by Damien.
  No functional change.
- patch 1/2: unchanged; carried Damien's Reviewed-by.

ZHOU Jiaxiang (2):
  block: fix zones_cond out-of-bounds write on zone report
  scsi: sd_zbc: reject disks with too many zones

 block/blk-zoned.c     | 15 +++++++++++++--
 drivers/scsi/sd_zbc.c |  8 +++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

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
