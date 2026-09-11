Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11020100.outbound.protection.outlook.com [52.101.229.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D353033E3;
	Fri, 11 Sep 2026 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789099916; cv=fail; b=ZgRrC06HNK23oHzGS8ZnQiz87VvYcDsYID5jo3xmmPGjJNvo9IwUG5TtXWHoyJr7ZVKzUaXFmGEprZuTuOwnOwFMWVxSa0qXy+2a4NHTV3zP1neoOkN5lFf4YQ+57wiaQtuhlthHZUAF5cTiMD8y9atqPdqAURlr2IRmCgOkb8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789099916; c=relaxed/simple;
	bh=Vsfhdus2Etc5nd8btO1JeC+dCLoqWC7/KAFktMIz3As=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=REkxWTqPW17gTeEaH54vMrrgPq+KsX3RRgwwP4nYOWDaNMic1UDaFvomTcnGCMjXC1WkG1ZkIs4pSfIjhIsuJaoPYgrMXiq5zEilDFsMRpH5IpUy1ikHN4N7RRPC+xGzBNy1CqeM9+FKFfrDBNKwN62TxX7KvHEfy7PErqOY1Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=QcUUcuBG; arc=fail smtp.client-ip=52.101.229.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="QcUUcuBG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sa1yYHbs+Q3DTET0AdZud2Got45VzltFhbqbGnpywe7PTrJY/t3OkLzl9A+50Gh6ywlguXiQtJSvQ7RMM6STziyn8X0Wv4my9TaN4dYsVcp7fze8zbQjbh3AiiuUCP+AcT2LJjGuRvLG8bNYpQoUOnWP2Fyrwa+PJjnRIUHV7N7fmtSvlVfOwOB6+pKL0dwxZZSam8YzC7MJxGTnzYOOCaKulXHoKIMFkmOp2J7jJ7Pz2gMs1VsQn9QHWr5cIJP5Yg23VyqfoIh5rBtfDlMRWKpPCmMIbwQD5caF8L+/+BUWnADjW3+4W665WyWzD3/pTtYw/EMHB72wN56zXq86eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jdc9JumrcnfJWzv45y/4D3vb4UOenlsRPTtJhJaz/HU=;
 b=SFRnS25j0Fr+jU8uW4NYzXJEL3WqatjY1jfAjMun5zWlxq5n6D5VqAKvkCyjuHHhu2zsaJ5MdoXBrrGFk2KYCAAXtCqdHRYtPTYzWCZ4KzjiSQvB2y7RWQD6aXvPXFJljIWQsWPUVThtthD5w8u8yWdglFoeCVe03/xROH6/fsQ+tgGgyjuJcoTDmfA4mr0eu70P4shcir7UjTjegQ01+GrLoSpaI5++dirs8H2MnE0dN+z9AD/s+kBdsQ5Nzr1Vq/1QptDrwP9SA5ZEx4IycJsR3APZ3FIANaEWsKtfL/82BPav4KO0NKs7dp6hXaBg3DVwCjmc41W2e8reu3Ujlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jdc9JumrcnfJWzv45y/4D3vb4UOenlsRPTtJhJaz/HU=;
 b=QcUUcuBGWdWlPWnB9PQ5NV29Nvwvd9EkeZs06VQgf3E0Bx8yC5Edycbj7hCrS0EPzbD6VJwWMTvzkOBYGL3gPd6mK4kfe3jWZX5uNHGlAf3v82npI8SnY5MvJNALwZ4C+pO6S/V3HUeO2FncaiClts5Sw+/p2GNFmwd7T4HglO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by OS9P286MB6583.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:416::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 04:11:51 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 04:11:51 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] block: fix zones_cond out-of-bounds write on zone report
Date: Fri, 11 Sep 2026 04:11:28 +0000
Message-Id: <20260911041129.128280-2-26066541r@connect.polyu.hk>
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
X-MS-Office365-Filtering-Correlation-Id: 692e6da0-7955-41a7-6fba-08df0fbacebf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|786006|52116014|376014|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006|38350700014;
X-Microsoft-Antispam-Message-Info:
	ZKqzC8q0mQU3I7CyDIb8qY0kerFtD1KPls89I96fRaA6/ANaMvw1n7Zkjkv0JTw6uyFphU7k8qFJ6NS4mD9VwGPAkK2eNPPQ/XBBfII76fxSytszsVPacYvFhvg8a1F4Z7BlsIxyJVjvBHrJUacxdxTTtJ7/6Bb8O/ccII1JgtVOfb/EyFYLcLXo2nr5riWzapYxmC5lL9ujHpuJ8CWM/VxnFHAmD2vc+TEY26cHXLxiM7J4cbUMpoMQ5e3YZ9Fi30R+XIcmbGPj3tsFS2rFzHPed9DDCb4XoeRdX3fIgXtDm+9b8aE3xx6ovSLI1b/reV6hYtGyhWUas3/EaFRojGGUMW+XeHYdNI2+hBNwmhJbO8uurGIXQzuNFMApzZfQTVDlPEgCpTvTFZIwUAi+HvMAmqgNn1j2+gHya4ylXS01YjnLq5m/lazKWOYQmF8obkVUcXTVczJ+9vFondqecqmTgNqDV9SPXC8FFku4E6hZ/GO1aSYMF3McE1REu078gZt+AGxOFqtzkCsmcEjMr0pad9aN+y0XM7CnmRbypgHvtVNh1K6HBZe1zJVaAUMnZd2BJdvoUDiKcSMHYpXoMYWmNw38ZZL7DYZGf//TL2qR787ZGo34eQOAVaM9mIIHwr1twec9lMZIZ4eho+u3iXi6b63B2s0YGvq2zaLioUbslwt1BdXktf2pEjmGSL9nZlJLSolJX9yk/Yn0qhOzJumVAoGB3HSf5Bh/h0pxWNM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(786006)(52116014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QK9At8f26aRTjSFweLOvYtorskdlD1Ug1F3A73z+ttN3MwnykIh0PKqo+aPD?=
 =?us-ascii?Q?4QBocXoJ2V4EMOXFddSrRQFJ2hn9bxN+wqyzMdmg3XzFE7IjtofsA4U6fl3n?=
 =?us-ascii?Q?yTVb9rPyX2ZnwX2baDoD/MBVoM2suBXmrs1aEP6A6lIoh4MGwGd0hEXd88Tx?=
 =?us-ascii?Q?VwNUHFtZPC97JVFELQatBhiQdJOY72Vu7siU6IsEb7+e0qV3Pgwm78mCbaUl?=
 =?us-ascii?Q?01V8Q69QqeptdaaMfyq4re+ftl3T04WQ3vnLBmWlT+eOWMlJaA/9PlU3JtoW?=
 =?us-ascii?Q?thAqN2EzW7ldHs8bGvj60RyvLHFYZvkmhFw4YmXj+bztKokWYjzyiP7P4pT5?=
 =?us-ascii?Q?u+x4H741lsVu4qrDhub285z032smUl9H/P6I9h++huGerwisfA3DJ0ik3OBO?=
 =?us-ascii?Q?Vh0naw961MeK5sjKvgjJRN46tmvQSTGSW1acEzNlKwtWDhoUlRpKl3X76gOM?=
 =?us-ascii?Q?sPI3N58CSY9kKVb3m2K0okUTze0FSwEmnm4fOjnrRcvo7ru6N8BCoo6ObXLJ?=
 =?us-ascii?Q?rlomCjHDc7Pn6UQGtbHl8mZBRDCsNg1svIsWHyoqpQdU7ZqI3GEqQa5220z/?=
 =?us-ascii?Q?NbXs6u60VOZ8sNbkWVR4RzWAjqei4HpMvj7lrNGRiqqkC+08ED+ZFxYwuqNy?=
 =?us-ascii?Q?W9cDA8liQGIp6FJuErt7nhVRq8bOVHw/tk/CvfncltoLDOAfLhlytpQ/dom2?=
 =?us-ascii?Q?02t3xP/oLcPexMcRqgcPoBTrlV6mzPDKeHHwMjrSlZbfK5VbGoJ11ZUQ8+22?=
 =?us-ascii?Q?DcYk8FZGuOXR+gzAhij4GxKw93LutEInuxHfqX6SWk+VwAO91UkZ9eysihHu?=
 =?us-ascii?Q?VOz0SmUJaML3GaVxSspbdA0RIp0kj0Fbx5158ipXLBGMkeOEJcj8pez58Ymg?=
 =?us-ascii?Q?w5yCoG4SqHTKN8B1K/eI3/SjKJ3nHtNDb48btSTrvMQEhodNDtq3+RTUBa+B?=
 =?us-ascii?Q?cGN5x3CqBzipNb4O6cRlMfFxCdUJ48FcmQDXYaCX2ExHoSdZZ8lZ2lFCXYih?=
 =?us-ascii?Q?R28TAY5+UzwLu1yJo+RvgyRpUsxFs7UeHt28LPoX/f/ETzClMtzFYq+xwYnn?=
 =?us-ascii?Q?2EB9OgcUsfRAuFvrNPKbANvzlMg7bhC0XniKYXqLcE4I9B169yUWBGlo5R4d?=
 =?us-ascii?Q?YXo8C7xJ5d9VL8FvtRPHdwp2jLQmo+uYgzXVRwMGjamSEg3mSpXBOWmqnes9?=
 =?us-ascii?Q?NqvzTzRPxdIPDnMpRKoJKOV8HzN3JMrBbxEx7l9c+xvYbyysvYA/QZMi27+O?=
 =?us-ascii?Q?slDNsqJbbN1sDIOMI1vfCPUBmHJtcCBWC8yMs3zvMkRBqphUjt3hrOThH9+b?=
 =?us-ascii?Q?QhfOGcpv6iVEeif2CTg9MxrCURJJ8yKfJGlDGddI+h3fVpaldLdMqlpKLvCs?=
 =?us-ascii?Q?wOoUC5sPAFMlH3B/eK5kzmy7YcWjcdJx1KKeVQbI5bKX+7/ZsAYZa05ZPkUy?=
 =?us-ascii?Q?zGRZBJoghaYBvEI54K1TkhAaI0eO97gRXxDsktyZ7T4P3K2xPjhzw6jXNOEu?=
 =?us-ascii?Q?LWmuGeFU6fH1wcH5GWMyp+XHxLj+nw2nvW/0IMukSoNRxv+u6Amvxy5YYSbt?=
 =?us-ascii?Q?hCRiedexIEcFqxi4yyz1E90TJFUFksHIK4gO/zVOhZi8qNDoEEnb/Nan7D7v?=
 =?us-ascii?Q?FePvw131RY6upzAG7el0RgdptxTbeN+BMto9evU+qlWFK1OQOx0ERJDDOkqY?=
 =?us-ascii?Q?Gaz4m93KEktotAjTcsUN7PbF2f1e0A+ryR+bKPwrla4Lu4DJ+9RQ8pLJMiiH?=
 =?us-ascii?Q?ZrEuuyEOitipc0oOrt4wOMVxaEqaIGI=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: 692e6da0-7955-41a7-6fba-08df0fbacebf
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 04:11:51.7335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HB3+h4QuoHqEh2vMWYmpnOXDeO5QdxSbKWH/UqHy+yupsIy0eS+Y9RmhSmeK6hajGI2XiL8T5oB6XzJRhx3cORkVOlmfLBQddNEVfbt3naA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS9P286MB6583

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
---
 block/blk-zoned.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a5afb842bf35e..475aa16bc41a5 100644
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
