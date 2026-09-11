Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazon11021080.outbound.protection.outlook.com [40.107.74.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B23515D6;
	Fri, 11 Sep 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.74.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137998; cv=fail; b=HgQqehx9d+l/OUq368nwu8iSsAPmV3nthGMvSM26mAHibdvgETmV191asQ5vYIGoHIB9EIJRbj4oN5BABbWL6/v+HZebqRVCGL+A0o3ZV/IHPr+TVA6P9tceNq9d4bwB+u5kWCnwOKpOL5AJSOrwxE4OFVlW0jx7GpNE71fyo3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137998; c=relaxed/simple;
	bh=kOvClclQY+f4GUxHsUh1Ogrgeapl1hsRd6+KgXRiZiI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rLmmOd5cYJi9A1l3HT04am42TunPncNBor3twdH2WUchn9tnIZfQQhoRXjPN0hWrqPee13KSLwSurcmLv7hc1kHjMFXTrIIGp9v8ZfQJlERZkaFeCVvGbsWF2eo0VW1gl/zSlWmjx3LmzQLiBPdJFKwE5Vuh+Q+nbRRZ1QCg6WQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=NH2KPY89; arc=fail smtp.client-ip=40.107.74.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="NH2KPY89"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PbUXCm6MTbFY6fEtXmNcFFC9sofSMeIfqHMSGKc0KyCgJyRke5AeJEUViEL4O+QZSBumzq58Of8Uv8D+pHdmzUoOoZcaTtmd7p3Z7+8+J4k9LJJAuSEzZl5UJ2F0GTNd2mXfICUKj9b3/y40yehRV7cGoMYVg8MvACxP77SI1EO1ws8SHUBJP8inoQ4vFX2WNZ/GAxQuKbHohypzREaNvwdmeYnmD6FKM/EGh+OiAyXLq/XlipLhQHwjjjfMW0SNBb+ukhnBktMBbtYlrlexTn6Mj3yu3GEM+JFVkoGrKaP0Q01Vp4PdKwOq5RTmQacufxmMdCKq53bOrvUX8dxSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ErMQj5ubJbhqIRvOK25nzD8mYm2rcyPV324FoghWDM=;
 b=r5wSg8fe/Zrz93Kyz6NaeIJmAjV4CMk7h1tQVXBVtrYkBCLnl1REs/y1a9uMhVplhSL3h049yFax7TpRON74V+19uoeSE//G3c01zqQqXebYpYy2bx4QzO2aIDFsTiTxxaBZ1ScnHiJnA7m585R5GM52COHdxgPnVtG/x76LdrHloJ7yIXSUedIabGPaWTTY94e3LFGI1eqUnH/R8kAZGUTa5J0NLrksyQTkA/0n7nK6+qUP/xpLs0yqKoRBvUIOPKWuELMc6KXJn29uIfPLeXBxnJrR9P10v87W0AnhxjCG0YezSMdK7AuxvOGW1Zf3yEIsHUWG3sa5/NNPXVcBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ErMQj5ubJbhqIRvOK25nzD8mYm2rcyPV324FoghWDM=;
 b=NH2KPY89o+oXq8oq15h7rBuTDI4hAU1aQTyEkE0HsqO1heorgjxPeGX4CU+oEN9ZQAOcvbLksC10+KbJauUMvw1IiyQ2Z7/7GXS/VUUPLy1asLSNqIiiqod+i8S9jM0LJTeF1UcyJmuDqS8UL8qm867VYGYF+ivQFa9YpPODVWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by TY4P286MB6621.JPNP286.PROD.OUTLOOK.COM (2603:1096:405:342::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 14:46:32 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:46:32 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/2] block/scsi: fix zones_cond out-of-bounds write on zone report
Date: Fri, 11 Sep 2026 22:46:12 +0800
Message-ID: <20260911144614.39553-1-26066541r@connect.polyu.hk>
X-Mailer: git-send-email 2.50.1
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
X-MS-Office365-Filtering-Correlation-Id: 0407a45b-cc57-40ac-104f-08df10137894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|52116014|376014|786006|23010399003|10067099003|56012099006|11063799006|6133799003|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	IGjz5KMUVUnYeR32NScIxGVoObCk7fIFdqJfTfrWeh8oNMd5CrxyDVmZr+JSY7mnEfEKe713KVRw4cqamM4Ox4XNg7bP5yGO8jZF/GZT0nWKlVbvLmPxUJZc1GGqU5sjry6t3se3QYo+bcRmOB7T5W3blZ7UIMl2E48PfQUnK4u+FwcaMEOCV1ukq3psJT9lxTY7w32l3E1GZe51Ggd3q1zUeJDzpzlgzjVDRx2sqVATWRASkO0OHsQO6IboeqPiEJLQMNG+ws0atB96hGdpW8b4cmayU2XHcCr7hRZFF0gyd9nPp5bfbhAQdNodn6fbnNLLTj2cA0P9PiQ9CZ/9yVht8ygHZwRTLrFXgjSfdnNNt5zvIOXbF6iLZ7NMuBBjaV+39SFgXAoDeSjak4rdsvztGgXHbD37b63pF7mIlknYQwYEh9SFOGJptJ5g8tO+FpUZukMmu32fG3vbZ8q8YAK6DU5iJap53R167k6NSo1YdUUibDjQJMctlEewZU3PDam0uOBjqbpLAIm66gGwrIIEaOR4key3LVyE5VytDy4tt9jIDqkAVzHTqFNA9k0L9V7WaUURC4oWQFEvuiJ8qpUv0+t2qMnX/Id1RRePC0zwF+8ME/pP7GjHF/sRLFZ6/CyupfTYUuDmYGeRg1BVFxAEv6In2gg1JqJwRePhvJ4PJ9IcMCXu2NwAfifiFDbI43xPZ1pqNUPkwVO0YA+L0BIgn/GdPbTdpyJWFlN5WdE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(52116014)(376014)(786006)(23010399003)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MZ1tBY7Wq1MlPkFvphNDqqjvKZr3zRkj96vqSyo9oeylpSVQeYrNB/itgGfS?=
 =?us-ascii?Q?Qv9Z5x2sSH9hG5bv8Dl+XryrAuiLB8r1yTcaF71yRujKTWNDtsO7hBK05aqU?=
 =?us-ascii?Q?XXFta9idquobjnDcBS604SiYeQzsc8AkKQz13K+JIXQZu85Qt+9TE/HTM4/v?=
 =?us-ascii?Q?DG45fSq3BbqgVcmR0VQZolBgyJehWSArnShssUag41z9573OTNvAybVE6Ih9?=
 =?us-ascii?Q?TovgzhbbFCbvLyADfqEwTCnRhdzLCqqik4OSs0ObGFZ8xf6GO3HXMUu8bHFo?=
 =?us-ascii?Q?SKKx1E6eZ+60H6r/cqG4b5XWayMv3WOW9cBSPTF4iBflKlNE8AjCeYBUcFGD?=
 =?us-ascii?Q?v/QhGPNGY6cV/23pi5kqGO+hbwzU9XkiX5bCS7GIOT6q2MCZoGFxkiy6vJdB?=
 =?us-ascii?Q?tJA6GMUOb7TE+ROPO81qJUcdroug4eldBAwzIWPOq2TchQDYUUl4ZE6v/MSw?=
 =?us-ascii?Q?Jkd51Az/DMs9zc4TVJKZk/bi3c7sHbOJjeWF+AEGT8GrKGEI0k2BmP6FUqXL?=
 =?us-ascii?Q?pRWrmy5FGQmaCiLeyo66v4TbCR/iK51dTVQFtPeUdJGlI020wEsdIk7eYCdK?=
 =?us-ascii?Q?hQD4gw/cp3KPK11qPIa384qm8+UAdaMRRcCloq7f55kmNoJWfr/hYCr0kWHv?=
 =?us-ascii?Q?uRmU+JZSSRrRXJiMDVaLOlvZMcsxVyPOk84II0hfYBr20uZF6tGNOX338QqY?=
 =?us-ascii?Q?svP8JEPnO/GpCaTYSSbuIxuSl88y4eiRtU+tiQPqsYvvaZ3495Pme/gsh0Vu?=
 =?us-ascii?Q?LPP3CYSUqu4XYN+wd7HwsYt3FQI5C/b7IE0hn9qCHW3PxrZ+uKT1ei4uf761?=
 =?us-ascii?Q?lKeByz76thL4r5v9BIw7dBKMcFNdpmRoE5ffr+6cPARAJfjc27Gz1XGQCNmb?=
 =?us-ascii?Q?HycsxTxPj0FHMXGSWl1nEpdWKZYZfyIlJkkAfamurUbtqBT+EURSV2cFKSJK?=
 =?us-ascii?Q?I4PwN+2fmoFzxq0DgCck24iOhBVTuqxmnn7CkWWVvfUT8LOIxPfzFGAm/pW4?=
 =?us-ascii?Q?MFCXR9GfHe6owYh9l4Jbzaqdxz1zWYmHQVTqLRDNRT0GvPvlIFY226Oz+OK0?=
 =?us-ascii?Q?0/w76C1e3KH1XQZjOHsrrFL+3eRmbtjLz0kZuRM4wVB4PsJZNNmXdbbmIOGP?=
 =?us-ascii?Q?ebocxN9KYHy2HodRCvBDqL36y9Xfh/4dZQoGPjaKeGY4Bs3tbe30GcJ6KiIl?=
 =?us-ascii?Q?lxijDupDUq796Q/WkSlwKq2deSuq6V+nmIpkWhfe4rbdAxeB3C4SRMRZIsGt?=
 =?us-ascii?Q?8bCc6oSYkkSP/rgoDwm4jqburJsDgVAUAO8GtoB/HQtNpwHz0GzfkXW25JHp?=
 =?us-ascii?Q?RnyAJVsQpPF/inGkWM5fDRAJy0c5zJxCL+iLmsP/p8+GInDQTRbeCUWdsT4H?=
 =?us-ascii?Q?eIFQm0mlb5ue3sQdY9khroi/LwsPV9v4piWHalR6E3VeMk0UyVDDZvm5HeKN?=
 =?us-ascii?Q?3DBzNbhJ+AxdzMEYSTD72nr2pMax3ubOvmR5WzV7Y+7JJbaJCJkR8sweFSsC?=
 =?us-ascii?Q?WLeomvO1zJEDvx1CYmtda4FajQ2jLdXXZ3QJl0sgjTgjrGeqjGBG8Mv8tYew?=
 =?us-ascii?Q?fTDFpkgJjfc1fi6CFrMbGJvEg1HpfoJ+v8OIUtF8bIgAWvSW1nBs35lJUg1W?=
 =?us-ascii?Q?yRPznbt6vjraYLkFbvrml7hlK5K7AqXm0uWT1x1S/W+GxTdFIrHafRRdLE+t?=
 =?us-ascii?Q?twO/JjTxelwPjAGP5iqOZIRXW+zMV1sAGiwykchBhSfnDSIqkSF5+aSZ8y4r?=
 =?us-ascii?Q?q2ec8Qgklg=3D=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 0407a45b-cc57-40ac-104f-08df10137894
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:46:32.4726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLv2aKKdnd74NmmHGn/3zN3Mit7Vt46g3di14psdclC08HaESbj9EYR8YOieEYSM5LvVRKj5ezitV7ggyqbErTshsX054TdogsZ+K+IkIC4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4P286MB6621

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
