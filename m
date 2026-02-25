Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC20433A6E4;
	Wed, 25 Feb 2026 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033849; cv=fail; b=RtpFl6u+otnIQ3hzDrCJ/mrOrIudRwPDY674HIBkfugHHTaz9TVvtrITTH8rRurH+lsomujcP98HeWvUXhqzMzeGWuSASDmTjR1KzLAg7VaZICkiNHomJ9zS0gHmEvQ4gwI3bgfgVk/vx/r5Wvq1K6cyav/L745mIzVh0vUr5oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033849; c=relaxed/simple;
	bh=56TxEmRZPWHGM68cODSfnsuoR8wm7PEkmDP3GivHXKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AZOTciEpkwwhZK6wBddc1T7tjKut+9n+Sv64QWF1twCZ9ERem4A78sJ2qWuj9MMxuI0Nfgkuz/OdDRqgQKjpjMzZzf99oDPpfvW8PfbX4yDFz/UOiKtQklv5+bdTNy05ayfIeYsJNlc9p1lp39djOs94qm2vZ4xIP3agQqzaiL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qRIKcKA/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y1A18bEQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qRIKcKA/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y1A18bEQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9mnNk553428;
	Wed, 25 Feb 2026 15:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SodcUmGCAc/YSjIQnnxV6Pwo0IMOyUFW4v6SeAPKKYA=; b=
	qRIKcKA/wMP07PsZ8R3/Nwhcb8kgOq7paMESMR6oHnvD5VVYTwLfP73KRhR/GTW2
	ZU5WJowwRmPLCmrZr/uZz5F2l6mxsQ1oLeMVRflmWr522ATM9WNW7AZavzeJF4Z8
	iBTFzA3HUyX7kCbFLXTe2F2wEuMvmI5DiSG9XfpuDgpAC3wHksYcC+14BK1WESrA
	fgwaK6CEWBDwoMQ1stGXI5QeLB9rDgqYYbqsqos5e97a3oId7Wxt7kZ4V83NSz5m
	bdr5orr1kgshXxvhu1n6ABvXCEbO5STkFx5f7ju7SHGyFxHfECDxWaAk63vk5BPf
	3PN9ItAqhUsm7QWSBdLJEw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3pg9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PE7QHU006382;
	Wed, 25 Feb 2026 15:37:09 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9h7-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecoEhZPPm5k5CERD4CTXNd/f9hzX696d0pEd4QsvxE9303ongOeFaaIEheZRJhUKex9CMNtEbN5ZPvixQy9BzmPrbiI8v7fyQO/bY0zHOb8FQ4YCmkeCHu8WVzlin553Dqt1VRS/Uh85NY3SBclMCltSjqgFTDB/zSVck8KLXApEOxDvpn9TrHmi2g2AyK9zD9pwiaS/ojvxPhPXfEZ3X4/89MXG/ZO0CVOldKp3gmkawTyYrpfxYGorT9tNWSuedAFi2fkLPzrfk+o1q0dHhPB9bL3zs14/UM2YaQ0Q4KNtMvLstqDRnUVTZjT+qGGXZ9JtgCjpRO6DGQxfawWJjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SodcUmGCAc/YSjIQnnxV6Pwo0IMOyUFW4v6SeAPKKYA=;
 b=yIXeaBeKXSjPT7c4wIwlWUIfgrJAeQVNXw2AUMHR+ma8gFmZJ8I6YoDBqgZSA+FSTzOSYfYZzXvXIu2pa0sD9u3NDK8RhHdKvHhLGajskUkohm26rEXHWD5NBttRnJpZpp6n9odT9Cc7zc+K29ikvJqSh7qQHzl6rU6oXeXjCsTQUp/nYF+Q/s0+9+0Byt9QKaaPQ1bUVy5damH06nRO3zXmEcSrasa0iznkWA68RVeagYlnZmb8MtRgGxKBr7y+xAcG0BrIV0vAeVz8eabkw9kgS5Hs65mZEo9kSJuukP2EOX4sOnFNOxI23yur2ryn5fpJwlyMyQFCt9YDXEjmyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SodcUmGCAc/YSjIQnnxV6Pwo0IMOyUFW4v6SeAPKKYA=;
 b=y1A18bEQrWhQc3N20s/oUUz0HMvwRAlOIzC7TClwTUgQllTbC1ptlpM6hRHoV7Con8xdBx8awfMtzx8Q9VjNLcvXTr2yH/pnUYdcJEzHwKxJEhXd0cnSnv43hXpVtJ8ITutdUz94/g/yhBkiF1T478q50P6Tul33q//FLRyEY5w=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CO1PR10MB4626.namprd10.prod.outlook.com
 (2603:10b6:303:9f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:36:59 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:36:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 08/24] scsi-multipath: clear path when decide is blocked
Date: Wed, 25 Feb 2026 15:36:11 +0000
Message-ID: <20260225153627.1032500-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0074.namprd07.prod.outlook.com
 (2603:10b6:510:f::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f4c639-20c5-4c07-604b-08de7483b6c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	fYX5KCgj9dchmVnIpvOCv79IS/MXsyqdApaHYg050jaYgWtG087/S5DmjCafzkiirhAH/SH39drbemx2GYfO5y0usXaJBc+22gbSbFWrPFgsoIAVTFBXi6L9gCUZw/WRlZ54U/4ABCCKTaEKrfi31wKAXocK98ITj39aGJer6UIZAORGvMK4RYyzFBAvdChnz3y4F4IQYSCCW/TBEV9qsIydmYyVKWTDz8f0DR11KybDAAfztTaVfprSvVM4PaoN1rROFtKy5tgZl0Qxedugm6Oe9b+RPRrGoT7rI+iYYW0UsC9aYFGR6bD7pwEwuzz/S2V3ejSiOgLMtzVyUyNpOvdpK4cHLj5RM6kqYzwbszLKjGzo83opP2SSN0oIeqbGlzCt+BPmVl+GkfoyEaHntxTFXlaBuGjw+lHkD3VIiH6wH7lhQo7UiEOrMTZLmaKoqLDECFzf5xVORKg4gw/vt8cAl4K8pNoO8lktNWzmX/ZXGD/n36fG8wZdyYBkUVhK96jHuzX8N3Cyru1zyGPBcUSum8IqMuHzfk2u0iNhpdKuGNuQU+GNEZar2Wpm6WkNkurSQytUmxZYM2Jkopa/PGN4vC8xWhkm/1p6tTAO4HFHRqYnGWXbbw5mpbZhgxCpEjARvBY9MW/DGaq1iGRxHDEuDM8U03Qdvsvlf4sOhnGVXGHf5M5YE2Zkw+FAf5RIA+0IzngjrAB5g3OpL8OtfyFLKLcP4Awn/WkEb5ZcN0M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AgK7u0oV+0bw9eaMWs5dWtdUqlgZ16A9wIvFZSOOeIvlNa7rNlC21TAXsp8c?=
 =?us-ascii?Q?WJtI/GsamkHqEOO83FwDZt4xu1qZnqDVpUf4bXUxZoNNlMqgrnLgpO/7dtUc?=
 =?us-ascii?Q?kJ8w0mq8SItPOFNhGTKN/mv5OQp/QlEYk0reRy+Mxpbll6OX282Ls6uqD0dy?=
 =?us-ascii?Q?rkxMEPO8DimIG61OZ7UEK1d1pOyrh2FrxwMnaKm7n3GLvWWMOV1i1YMiYaJo?=
 =?us-ascii?Q?VvSuMUSO1msUzjLbtHjFLzNrXlWxSv5hfA8q/B3ZJqELLjNzraIhbw0SPkW0?=
 =?us-ascii?Q?PBvaSCnM568N3Le+4brGmN3UrXZisJJMsc3MEvGcD5OT3TZJ4rY5d0SXuDZf?=
 =?us-ascii?Q?8Ecx/4dD2/Yv49NI8Xvjk+7Y7aZUJZAV54xM9W/mYv/ZEyuw0cuVP4Xj4BQJ?=
 =?us-ascii?Q?Lf0iCqdlqoijlaY6KOivFJ6yhpHPhPtRR4ZS10aThPTBxkrmG1uCNXarkiji?=
 =?us-ascii?Q?bVtXUQdp45+VV8YLkkwVGMcj+ZtR5c8n50g42C8Vcc+mym8JLXCcZmAlfDJq?=
 =?us-ascii?Q?wPlTcY/0Y7VdFXARel8OwDF/tlWi6Krwj3OmtRMO19/AvIaV7HO3vxxPSsWv?=
 =?us-ascii?Q?040UKMQBFLU37/Q9cvKB75RoLv51sd/FxC4pFOGJ7eMmIV0lXqZ/DPgos6Z4?=
 =?us-ascii?Q?XPGRF0xpRunXQPfKgc5m+NYqPk/yh+oiMr5BvmCj8hg9s8+YGEYjsLomwY76?=
 =?us-ascii?Q?N5uBMTY3WL/42ReRaIovvGbU9qzY5sPenSX4MXyQR8taQVMXk3Dg/sEN5Odd?=
 =?us-ascii?Q?rJAurAc4evr2LxbdDlmuTSNBy+lnlirKqkulTTnXCOl6GcbJb63Aje6XRHRG?=
 =?us-ascii?Q?+xwG8RoxWAyxCAJOw2d2I01hl0ZrEIZg59WvXGfLMw4iwqa+gtT/TPx1rG9v?=
 =?us-ascii?Q?zLmXq0Sdu6yeJUI67/1pck48iYgg3/2Y173kDFDpH5yRt2sg2YseaE3CuCpd?=
 =?us-ascii?Q?noCpPzyhQ0Kxo2UK+5N9T786LEp2jitnQ1U5tfoDBQQ303W5favIrUbU3orh?=
 =?us-ascii?Q?71xA/QYI+aDdfTUsYXvnU3PFWlBxIo9el50+ExS61Yy9PAPWn0hFeCNVBwQD?=
 =?us-ascii?Q?bvxcVXBKYAhgCql2dvP28ONT8ESldOI961BeBPxP+5ZlBOqTxpzOjHlIWic3?=
 =?us-ascii?Q?Wtdr4CfTqqPm7TpNhNik1s5d54tLnH1eexrCbkqGC5Zbn5tEw4CU3o4TQffl?=
 =?us-ascii?Q?reVQ7HCia0SeSVskEm28IlgTbFMj7IPJDxpS3HDqMIuWLYvQ7BnvvNg2DZlw?=
 =?us-ascii?Q?xhcvDRCNVyY92bh2Ur/yoKKM5ImCvqSyqI01ZBvL7MqnKmcK+qpD6h3CEj1v?=
 =?us-ascii?Q?TK6W9wcqLIj0cOlPGrc6HiFdWJmazbnbATH9nJxrXmJv2YEoQ+G0DO11OsMm?=
 =?us-ascii?Q?o+PpbW63LXoWQ3DLId20wgW9GBUYs0dMYFkdHVXOlVTikPI54sdFvlTqrpo/?=
 =?us-ascii?Q?sAUrtq9ohbIxUeOKjvBZcpDyfLdPjR8wcycSe+tcB5ngwld5XuynxPCiyGNR?=
 =?us-ascii?Q?86h0hBjPhT6zWx+6NCpsetRWzmQBWRGckvML0HpujALJfjLXPyzlu6grpKIe?=
 =?us-ascii?Q?7MPyph9VuOEbwM04jI0M3Xy82p+wbN/X3tBePLC0OU2u3ER7sdxTW7cV5Zzl?=
 =?us-ascii?Q?nlu4ekdGvdM1Dpl1j590DCQvPlgE6yXa+5CeT5SK5PhkuVYYZQh6/iKTTwkL?=
 =?us-ascii?Q?GnwPpttbMFGlcWF52KdMVZvwzcpMvOD6rtGZgWEfmkGdiuERCkkwlF8H73qc?=
 =?us-ascii?Q?cNJdJ91X1G3f0jM7/4VAlfVB5Z6itE8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JfUG0n9dwvV6NJPBTmmBgCxIDEHmOvaZ+8JyiaL8d2BosadlV5ajx4fhs0vyjBwtg6YCj08a0taXbTB4MTWb4N3G55nN4C+1qkO77QrphsZtvSIS22sIGzmkOB/6EGaepqmZePUrxy/642Lzv0PrDcUAcd6azZdd5jVnhD6gj62XXiIIcIgKrHoX9nIHeBU+viORVXz9gCtwExxD/QhuMbe9be3QadadZD/+DlY2l7xJj9jNQEaqbP88/WB3AoX2OjorE4Xx/2rZ219ffGhvUQHh9ku1/n6rutUx0jUKSfPgcwu4UQyTxBBCCDK/TusjJklFnQjb3lh/4Ay1IKZKY16fDbcSpiGX8HsbDYr1ePKpMNlQhYHrmiFNb/xD3LMrtOIys5LKovnYxG4M9lVfQF6+LBKSePiO73d52eS8VwN25fxe2Hg9BST1V/eUFTmM4rTnFH3KmH+BnEnhiVZEZldLuOKgE25e9+8U4YTCrnrX2hJu/PwNw+UEHDvDoQvJ1b2Ei5Os8yo9ROF5S71dux1foVOAb3yNiV3EQM9t3f7/3aegqcvGWkWYx6wMewdKSrpJm5klz6seX7ste6QubVy08LF82Y+T8b5yjelislc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f4c639-20c5-4c07-604b-08de7483b6c0
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:36:59.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DCfyBvdqCEGASQrdKipmEPgy2ZQFGtDRUC23dKxLdfvXtJy366Qu2WFlkcZ+koFo/IbhOwLBW3jDQwbCJKNLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699f1726 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=z3LZiCDobiYP66PUldYA:9
X-Proofpoint-ORIG-GUID: t1sy-ViBHsHhNAGxcjNwGnDStpjbOCgZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX5lCwZHM6W2vW
 KkU7mDoOkvsRj6z/kCgK2QKtt+Djt7AJ/HmFRf8G0s4BPcU/39ka8vy8S9Sn78lvupMwz6l5hMm
 V5qDlopw5qmXE55+U4yly6Yt1mNgcPk9BPwiS9ea4MsVvXKsnEVUBz50BFzEIPwwXYLuUQdneN6
 Vxy/xGnJdBRvKDflPNmp5PXlEMrlz1DAgBliJVg0wbvHXffcmDbvJAJR8ayUywh7oGVvIiJo85L
 lmkVbdeEurjPVk9BmvwVSG3KyIioOEyHZCpgqivsu8wUJY/VmdS6Kn6XKcgJlIU/oqqeklkuhOW
 mofjOhj7BgszhbhZRqTqMtk8BIIB9cfEmSG5ewnfn2vU+SrAEbJtIN23+5tHd6MGsRsWfLWTtxh
 qPblzKDiJHOvkFkfTB6t6qlQ0CNCCO9fcnlSpz0JSf1T5k9Qth5CXugVAfpdk+KX8fQVOpOtLzR
 1fsJGBHlr+VhPh60INQ==
X-Proofpoint-GUID: t1sy-ViBHsHhNAGxcjNwGnDStpjbOCgZ

Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
blocked, and call from __scsi_internal_device_block_nowait().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 11 +++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 19 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 93031326ac3ee..ab224cd61f3ae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h> /* scsi_init_limits() */
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_dh.h>
 
 #include <trace/events/scsi.h>
@@ -2898,6 +2899,8 @@ EXPORT_SYMBOL(scsi_target_resume);
 
 static int __scsi_internal_device_block_nowait(struct scsi_device *sdev)
 {
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
 	if (scsi_device_set_state(sdev, SDEV_BLOCK))
 		return scsi_device_set_state(sdev, SDEV_CREATED_BLOCK);
 
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index d79a92ec0cf6c..c3e0f792e921f 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -151,6 +151,17 @@ static void scsi_mpath_device_iopolicy_store_update(void *data)
 	kblockd_schedule_work(&mpath_head->requeue_work);
 }
 
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
+{
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
+
+	if (mpath_clear_current_path(mpath_head, mpath_device))
+		mpath_synchronize(mpath_head);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_dev_clear_path);
+
 static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index bd99ea017379d..79e6860243e74 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -47,6 +47,7 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev);
 void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
+void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
@@ -73,6 +74,10 @@ static inline int scsi_multipath_init(void)
 static inline void scsi_multipath_exit(void)
 {
 }
+static inline void scsi_mpath_dev_clear_path(
+			struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_remove_device(struct scsi_mpath_device
 					*scsi_mpath_dev)
 {
-- 
2.43.5

