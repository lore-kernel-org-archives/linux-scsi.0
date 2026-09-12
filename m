Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11020102.outbound.protection.outlook.com [52.101.229.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA0C36BCDE;
	Sat, 12 Sep 2026 08:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200204; cv=fail; b=u7cbHiDDXQ+C/PGx2Obtee6KxuOyGIe6qsmMAOml+pYQxQJFb7ZzP6vNq663qpahquRkcJw9t/8Q5AmmTu9Mhi1YNVmEdl4KlXwR8VI/B9g/RPA5uAa2W1Dpa95hkRkQGpNNe1XjHJqiKEw4Jo5krrh0Z93NRWMl1SN1T/x1bMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200204; c=relaxed/simple;
	bh=uxz2H58c63nB8lr3Y3IdvEjlc8ZO9DYOcPqq9bs4URQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kt4NbM6t0fEIVRqNtwVzE0+vuP91nRm7CtT//Yj0LiFAPjtmdQQ9sX8dyUjO7pstO4kR+nnkQ98/gg0jzwAa9MbLoIDSDof3iIApaB1DobhabczoBf8a9XSmKZ5C4CzoUrX565EMjvwv7uVODwiO3bSHy274YCsILVUuCGAqEyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk; spf=pass smtp.mailfrom=connect.polyu.hk; dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b=oLh5qSzI; arc=fail smtp.client-ip=52.101.229.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=connect.polyu.hk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=connect.polyu.hk header.i=@connect.polyu.hk header.b="oLh5qSzI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bW7qzyfBmA1UvskdOUi42HSalpTMc1hK4ENI9PVDiah6DnGeci6JoIpXJ23VSneEZzhGdFPaF1pm3uFD7EKD/kpB96Yz9h0975r9NBwWDdI3gCPKk7SWuH+0Dt33SAGH9bqBn25Z3rGovJ/RBH6jFJ0q/NZQS73OP4dyX8zK6iF0uSyuE5HAn977VuJOwONmg2xQCQoL60UqdVBm9uVn/OoBpi6SC8G5FI4wU9iujMpB+BSZ0zHvXQtx4cFwvcCBe5fo7hKdDOGA92gRIAna2ss/FdB9fJdA8NYYS+9iYLDU5KW0jeXSiKxXOIQXHuvLtBGdDz1TzaScifORQnMgYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwoFEmMCaRlUE/6t2bQw4n+5q09Zaf9m2akoKOvAk8w=;
 b=QkZAjzVeVDYMLAP8++eaR7tN/BieDgk0XxqH+pD8bg9NHPYfHJUpWmL+KhKIkY7leNgxXv6lLX3VfCBQw2uapZk5tgAwwSFhS2eCzoMR1ctXSczf09SV+QitmMa64qrjXQscJt+earJ7ADgi4tVBywjkO1zqqlz9JRWwlwtYa9AX0m4pQ5N+5SbSp8nwtQavuc2oqv+2ma1/74YRZDuafW7MtFZoFHnlYpqwZ8Y0LmiVecmwgSde0zAFLavKotefh15Jg2gTklFq15bGV3LGQvbJ3EVABQH+ldHBFH4bczVo8/yjsxccFsTtFYIKWUICOAvc3yUrzQ78KyPbT5/eXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.polyu.hk; dmarc=pass action=none
 header.from=connect.polyu.hk; dkim=pass header.d=connect.polyu.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.polyu.hk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwoFEmMCaRlUE/6t2bQw4n+5q09Zaf9m2akoKOvAk8w=;
 b=oLh5qSzIcif6sRGhFZR2Y6YDHhUy8TNE1xJ0Ab/DKjOXX5KZHTluoOsxgihc/JfimycOTvZCs+acijLCYrdhwcm0MLKgciPoc3y6eikeIc1fVzFhK6rVc3W1h4MUeiMas3R3Or02Awsz421018+kBhXOEU+RXwrm5n+Q5HTxNMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=connect.polyu.hk;
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:4c5::7)
 by OS7P286MB7475.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sat, 12 Sep
 2026 08:03:16 +0000
Received: from OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa]) by OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
 ([fe80::e267:139c:d5e6:d4aa%4]) with mapi id 15.21.0406.007; Sat, 12 Sep 2026
 08:03:16 +0000
From: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
To: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v3 2/2] scsi: sd_zbc: reject disks with too many zones
Date: Sat, 12 Sep 2026 16:03:04 +0800
Message-ID: <20260912080304.78535-3-26066541r@connect.polyu.hk>
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
X-MS-Office365-Filtering-Correlation-Id: ea983086-b05e-44e8-e6ba-08df10a44d28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|52116014|1800799024|786006|38350700014|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7a7yCL8REd9ZpTFsQ/RwMDHavS5F2QiRZP+Yx1pDzUOUnd0MIST+wqmE6vkuNn3cIC++BE8YfsAECJXI8zuu3OXt+cRgIDz78TLcVkyDux03XWUUuf89MehcbwY2+Gu9KE/f7sXLgcphMfHAV8Fdt4PeZiXlikfQ6NyQpI0DgVvUNfGCRw9XWU50jpWs64z40ZsPp79aH716rwOGEr7WjM8Z5T3lKKbphtMXnaFYpJHOw4STVSzhaDdgieW+fbGMsMecB6PMDLYBnWYzNKr8wRqUUDJhihkSmGkfReischMCnhRxpD/oKOkVvHIvjuCBL+Fp58Ru1poN9hJVMgeQuQQU4U3VfA7bgJX3Fcgfmk0NFQehSoWMHr+bynZtuDLOTnkE4ouwF7CtaslshnUbEhkTYOMxQRcXH/tjrjqOkqrzR/8WoNpKljILGlepNuLNoWUYGZkxUkoVmJwYqA+QXwAwkKfW7DQfzpABXglFcC9zMjjD8W0BtM35FRRT2bbCRK6mDE4zBpo4n0dH2+z98MqDdKtieULeB5nVcBvWQm9T+MDBHtKNkq020vINBj3xq9gXEtaJ+bR0ZhxLSm0yMNaXW2sTz6VFJMWUVXxX5+4sBcieAG3QUbP0uZF6jsLT8FVsFcR43fAtFfrkWhBOjKISDDI/8bQqK5JX8QUaVccgJRW4lJwQd/geROkvBRyN+zdribtrDXYcrh+SSKJlElgF+bYInORoklQrpASurss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(52116014)(1800799024)(786006)(38350700014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GWdauhQDEdnGrm30OjD1whHQTZmrFihuq9N+gAPa03lxJFAcD5wfk7WghBa+?=
 =?us-ascii?Q?2cDi26VsHDYDfCVpeqiFQWLktxyQNKD7HV2mrCy5ScVuR1tBQZcuy2bGQWHb?=
 =?us-ascii?Q?qMD/8KgfG/yGovQ5bBVJ80fZFz/j2WKwW9WH8DHnSf3x8tkEtTJ3B3pFBRI7?=
 =?us-ascii?Q?1Udqxl2loFZTBJw8KT3yyn/dvpqFj/NDi3G5CgNDu0SSAPVA500X+4rErBxB?=
 =?us-ascii?Q?zrobrHHU06ZRsWQcOfvtwIioTn90QDCauPjauVe3bpmketDY1EOxK4Gwk/Xs?=
 =?us-ascii?Q?JrEGnebyXiHIoTJzUg3vk6mu+NuCY33ieD5j4UXNmtjOYevg4YIv7fTNkQsv?=
 =?us-ascii?Q?VSKABjG339yS0ZYXD7OqGKzdwnxhHJq54b0sc+dBKw7n14Dn39S/Jl0TY4M9?=
 =?us-ascii?Q?nYqRCve9JuvaawtdSvx16KP31vg+ZfpoY02Iy4tWCUjma9XZ3n4wsGpjZQBL?=
 =?us-ascii?Q?irkXbGFwC6lFSpGgFnuoq/IBdVE+9WuV6xxVibrfvdvv/p+TLkd7EVfbp2lz?=
 =?us-ascii?Q?45LyCZECsTfpZFZkmGr61lwpANq1MbqrjUq0/iXRjG0bDbcg0eeACJlSQEHV?=
 =?us-ascii?Q?9qai7p493g027BG/+OEUg/qqXleY8TGQcx5nFDi3F7xGVFwpBbtQIT3vglkj?=
 =?us-ascii?Q?VJGXQXrlbyIDODbAwaInO21eIEk08Ru481JQspSZCmQ+Skgn47aEb4SHFSXE?=
 =?us-ascii?Q?UBTLjDsPZQfvFSKXut5RPtCe2NOVRdDfQTQCzBvQ/OeHj8zLJXMrTZa/NmQY?=
 =?us-ascii?Q?TstkWKMc0xmHgAqs+4DPg3E9ppXJSJr/68BJku06Tac8XVzE+b3MwTLXErOS?=
 =?us-ascii?Q?BqjVNYisYJMK2m5qOvgDQN5wBpo0d0OzFV9XDdZD6cn2etqVE1HBq4kBmoXp?=
 =?us-ascii?Q?1X5HYyCnFazcGRE+s0lMnzn1r5720linzOucYnbE+g6/xqLtKUm+1O9snmYV?=
 =?us-ascii?Q?mVrH6U27p8mT1Cc1/PwzjOm3Vgetamb9Fr3TiMDwmb6yPU2Urgp09XJlL6bd?=
 =?us-ascii?Q?e+XxWEIeXuua/ZrBGa76Jy/isrnI1Uc8m2jTTPdAUYHOBx8OVD49UskBd7/U?=
 =?us-ascii?Q?i39xBoWPVyJ+gjqnb5//asscUnA6GElUv5u0n1FRNbJVxBlk5n6D3GKe1Lhj?=
 =?us-ascii?Q?j3g3o7TC0Kjvz83/TSAmqJXXCxDKHFd3kDCMALmywedbt7olHE3dV1g29+as?=
 =?us-ascii?Q?LSusNR6NMSeXH9xZnlHwQHrUAUX9VgWQhpMjg6GjsDl6imQR22GUFg/1KHFo?=
 =?us-ascii?Q?6dkzJdUBsy9qPvSBpQmbolnnj7tY8lAjJu99hak0gMard/8TFW9DN7Z16FCT?=
 =?us-ascii?Q?KMA7KpAt9Ac3As/E60tmPwUDY4CJxWDSb9Gyt/a0tS9/p6z+H/PPLExlxLa5?=
 =?us-ascii?Q?rORJytqg+W8EUZMMkLLW8uhiyd3ap2s1YXwPIY6UvPbKgUG3EQ81452yDeTB?=
 =?us-ascii?Q?JwQaPlbrBY1a4kwCERuqTqL//71OOSrY7J2jdFl5nzKMxOq0L/R5PMS4Ux2E?=
 =?us-ascii?Q?4Ic4RAEQgow0pnavrChH3Us8MJv1Jw7jC76M2qP6loO/7Rs5Qh2DykN48dgg?=
 =?us-ascii?Q?Rmn4eiM9kvSFBIKBAox4tK3gA60QBuLYeWVppaQf9J9cKwcxmDUDmcqIl6eQ?=
 =?us-ascii?Q?I6zq92KzvcSwEBFnu9BCzBzOk/GFUs+s8i6K7iFcyagqwWAwTOh5KFW9G3z0?=
 =?us-ascii?Q?WAHWqeyBkVd6wiSUzUIH+10WYuYqw9x2T36Brkt+l6TlOwVl5uSvPUstKeQC?=
 =?us-ascii?Q?x3sPFXcJtQ=3D=3D?=
X-OriginatorOrg: connect.polyu.hk
X-MS-Exchange-CrossTenant-Network-Message-Id: ea983086-b05e-44e8-e6ba-08df10a44d28
X-MS-Exchange-CrossTenant-AuthSource: OS7P286MB8049.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2026 08:03:16.6232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: ec09e4d7-3d0f-4eff-9c1e-7ba8060c5417
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDVvL92VkyI+7bXnl13JXbS4FbzDcPgQ1AlDqNP0kvoklTpe3RvgpHP9h+rnUmBr9GNcmmyXK61Thkqx8/VTr2FHs0rF0Wci+7RxaQAguPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7P286MB7475

sd_zbc_read_zones() computes the number of zones with 64-bit
arithmetic and stores the result in the unsigned int nr_zones field
of struct zoned_disk_info, silently truncating counts that exceed 32
bits. The truncated count is later used to size per-zone resources,
while the device may still report more zones than fit.

Reject such devices at scan time: more than 4 billion zones is not
realistic for any medium that exists today, and accepting the
truncated count produces inconsistent zone bookkeeping.

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Signed-off-by: ZHOU Jiaxiang <26066541r@connect.polyu.hk>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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
