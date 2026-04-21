Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CAF27BF93;
	Tue, 21 Apr 2026 02:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776739154; cv=fail; b=jCYT5VRaomDMYnf4v3lAO5Edutj4++qQIDUozPtget+H8tl1Lc4XeJfxJb3RY/YbUivpmoUhaZlYr3xtnls3PnWUroPmAGA8r9khMFT3Isr1ms/vUHzCRgvD0UsIIY0bmJhA+SHzhecMJ83VhSZHPuoMtcYIGPW9l8SCK8Fpi6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776739154; c=relaxed/simple;
	bh=r5vRqQtQwbiji82IrSN6yGaifgJSMrm+whzwO7W28dg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TbMv3xegdKs+64V9TyIoD6svh34YiDxj/EB5B2uXBHh6woUSmHl2spdjDSMoVT+I9ysMC56lmJC5MlyF3mgUAHnibIVll+MqHDXF5Z8ryFqzBhO1H4474d4Uz29Ob+IJ9/m1+nKB2+51YencF5iu+FkqpHUPxaJkrKxEypadQ6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CLXL1P1j; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oS8i/xLf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CLXL1P1j";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oS8i/xLf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KLtMvj208749;
	Tue, 21 Apr 2026 02:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AHuMRqiZ6gs6Fo7OBC
	i6ZMl13dNcwL5Jz1jFLFpm45E=; b=CLXL1P1j4f2x4NOEKEmzGpFdqPYFLnj2tD
	H//vC5wDrlxGedT60id8H0pPMr5VXgOdHIFQnYuAQHug9kg9nkblEIRWi/S/9sP1
	2t/gDld4jq+KgX+rIdnKxjaIeiuGYeMfP6cLfCoz6xBE98H2zm4jZlJJPE6WeoOR
	lnWiFvkgqHq+oMs3ztjW2AJBXP3SOQBsUmU6eWWbiVQFPA8IXDR2EAqy318Wb/fF
	qBgJzg/WVT7uiw9dDrbby1ZnSVBYERttHFenLSg8wUVtG6NXPW1U/TT1OxbOIljk
	rbX4cQ8UPcdIZZO+YDB80hiGLuAIWRMBtbdv6gwCGEXSKYQbtgNQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2grch6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:37:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63L2aFGi036717;
	Tue, 21 Apr 2026 02:37:37 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn176y1gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 02:37:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5OUBAy1cSgKt4ugaIs5CEO8D656Q7fkZvygXCgytkysuw6BW1enCvreU4r3am4HarqNxWGOEAXad1FgYlU1GefgDv+7BEmh+uWye4ZuNrZ/pKOMTkJilKpD3WyuqbmNHi3emXDBBBlpFyfNAB+p9Sm2+RBjg2L3L477FQltT3FKbLen4kvaF3ph4MqjeN3VJ+zQI5Jw6qZm184pjNUS98k6f7F+/R1nNiFL/2tqDRUMtpGKF9bYuNvwGyPSUoPq9fvc4XyQyEo1RwtwSCZhubaRvyn+n8RhAP3YkVdw6epLlkhAJuXHDydQ9tnVxR+chjXCgUrYB6I3syC2CCtEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHuMRqiZ6gs6Fo7OBCi6ZMl13dNcwL5Jz1jFLFpm45E=;
 b=vocgDcwVIyHaxgRswnhCOeZKWnC1ov+REHacQumMKlolf7I+6ybd6C7hyy4tcfInAMHskbJESozbaQNGhChbU0HfUTU7VXsJgNWM2EmTOjaZCO7SRGGleq30QcNGLznwUJeGYVq+HNgmidKhXeSsjzN3hHnhEU2wL5Y3X3K4cS4MTJ51uOE8FhfpZvD1qrjDAIB6MDFcnkJggfVTC/EU52DpQYNmAXuhHnY1JaqY8y4rvQzHRSmkTRjsKK4km1f14viuwRtTkinAcuCAdmXRvwXe7Qq0qNGon/vkj/NIWW87AY5ujY+WXUOSLUTCiFJlEmW6bKCIirrj6o2fUPNZkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHuMRqiZ6gs6Fo7OBCi6ZMl13dNcwL5Jz1jFLFpm45E=;
 b=oS8i/xLfMZPSgxhtbtf1ixf+lxQwYPo4bKEt2My098w5w82BMjRgZbQ4gyudmwWVZBNenuGIAab10D1U951gdxKkeGQp51Tdt2Z/WSoCiRxRXLDeLO+nlhtrI6kY+JhqfPfX44WygsV7QadBx7jXp+X7Ln9lfESPC/k3hN+t4Tg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF715E13019.namprd10.prod.outlook.com (2603:10b6:f:fc00::d28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Tue, 21 Apr
 2026 02:37:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 02:37:34 +0000
To: Yihang Li <liyihang9@huawei.com>
Cc: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <liyihang9@h-partners.com>,
        <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
Subject: Re: [PATCH] scsi: hisi_sas: Fix sparse warnings in prep_ata_v3_hw()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260420021044.3339459-1-liyihang9@huawei.com> (Yihang Li's
	message of "Mon, 20 Apr 2026 10:10:44 +0800")
Organization: Oracle Corporation
Message-ID: <yq1bjfdox7g.fsf@ca-mkp.ca.oracle.com>
References: <20260420021044.3339459-1-liyihang9@huawei.com>
Date: Mon, 20 Apr 2026 22:37:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::32) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF715E13019:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a97bfc7-0065-4e86-3683-08de9f4ef1d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EZVBi0zVXH3UyzX8+WdgQLFr0jKcLdNQaVLZjTh/K2nm+2iHXCdmHReIYDqinE6VS17k6pruzP4v6pB5o+K+wCi/XPFie3V3F6KwsT2hizB53kyNSZduW3Jrz6+0gZ6xM9pAXERTS7o4D7Pv6fdofBlvkYzljcPYGUeZGPZdt18UDWmh6tbbE/jAzxKSoptsms2QtLDT+G3Ifv9eQfBOrX68Onjiw0+ST0/txI3Hqmj7eq3poWPt/eqRY2ew96cdruXXKvpvKW7aysDDShts6GO0jW9ZYX856aQL3ZePgTKTtg+SgXz9Abr/KiYDIEY1cMshUflJr9Dt/SpR0nyOgoXou39Z/PqgLiMMPEWuEDazdwO4SjdxT+Ia3GaS7uqSHhFfA/BKXu2QDpPAxXio6YfokzAWMg8vU6qZaXnMlesxHkt7W3CGN5Xm1CJ2zrpCOmM8GQAg/6GpckbDIpaJreX6bRgWPvnwZCt1ZPeg3MQXAGeGoMEiEvo9FQwW26c3uIi8M5zSDrswETMYmiFZp11TmOuUrbVz+iE5TqYOFHqKwRGMfWYtyDUysDPv7oVbCHdTdCVBlHmIUPXDcJ4fKAs4/CW410XwTJblyRSIcZ8s6LcAzia1QQl9dBdPc1iWuLtzrpI5v9ylJ/9qO7zcvKeBKl3FGUGdfFgss9cfbkzlG2ka0ufjFDXhCOJ0pdwCxH1FtgdClo5fyR8rTW1QUdLTaz77fJ7NyRGVwh9ywHI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Iw1WM/xYU5b2HRdCnebd+hhcjnpicnw3N5JUj7oDUDUQ0nnSt6cXjq6Cti6v?=
 =?us-ascii?Q?b6x/NYISL9x6SIiGs4O2/jDWGCYbxTS5aVgM2ZEL1TGWWV9N9s+q7mbBEEMe?=
 =?us-ascii?Q?qOlvOxMLQK8UvaCNEREj/7amo6dGqU8eIekSXNl6o/boaU/zmjERlp7GQbky?=
 =?us-ascii?Q?dswkRCDBvYmdu/h6o5xUCOpi+YT1FFZr2PF5UQlh5A4KSscmbafzEWDxp99j?=
 =?us-ascii?Q?gt8LBiKFN9rAIVx8GQcnN4CNcYKoCUR5GdLJIHGf9hSfwASmSGNOcrVrkn7c?=
 =?us-ascii?Q?P9IPKaxCHVmvfnAAHhVBA99ZVGgABVRx9EslurHGvWjku2Lq2vFzjtwuBK1f?=
 =?us-ascii?Q?8ze7rRe6AwBFR80ZP34YsRiRz/Lrd1e+ZFoHMLham0flG04DvxOG8ptquAno?=
 =?us-ascii?Q?Jns9SB6Nh7CenWngWUXU/B1tVzJCHN3sopvl6kQRRtgDLbApT1O5fk2LdOOQ?=
 =?us-ascii?Q?SYr/Fqa52nrFTaFcl/7YAkNvxDYa1gwAE3bUA1U2QwQGUx8qieb9jfCTJVTx?=
 =?us-ascii?Q?NBBnvvEc9i/nflhtgjb0mqUkVctuB8ATinshg1Lnul2qHt3bWxZsCjQ78nfC?=
 =?us-ascii?Q?P72rgbocN1j6ITJ320TZq8pfVcfmcOQiNM/1m9LRPzBbBFJjg6GMv9V7kzzG?=
 =?us-ascii?Q?p0zwseUTjg48fzNt7fN1sbYycBvd11Ck/ScRUYf4BpTAE6ZMYl1qkAQL9Fqr?=
 =?us-ascii?Q?uEXHqEbFzuvj79PZHxdwjfxxc0ed2L/UqgQlJnPQ4NRe8xGYEFfR8LCqsdip?=
 =?us-ascii?Q?8eiuYkVwCPFkMz3x9zNSANlvI0l/Ov8hX04KLW0gIyGYM7TmSH8KKqirZGzG?=
 =?us-ascii?Q?amasavpyHdzqwoVvFkrZVSTJNl8wds3JQaSWS3qaeao4RYBleQN0AlhABEfP?=
 =?us-ascii?Q?pM+0gXxFjhn/JusFg7Q5+Q/27vPCLbV1u3Pr3kvRTK7Oqf5u5vaO2wxbuGdh?=
 =?us-ascii?Q?anKtPUh2Yv/HwMT25EP5vPnS+S/EUcAXJRPgmYqjwJxT7/v3nXPCXojmbVnB?=
 =?us-ascii?Q?pGzpE17lKR5mfLUBadxUgGXZlE/ZRFLqBDJ+wq/tG6EadXlk+QezH6eM9Qi9?=
 =?us-ascii?Q?oyNVTRkPGdA748PhMXJjjPI5pVponQ2bB0C6hvwODW+SwgmF0Banb8ib1LfC?=
 =?us-ascii?Q?PTDEeL6htdeyPn4/SwKZEbxYE6jINRwUFUZYGd3Lvs6yj1yezbZZvBWsO6Ao?=
 =?us-ascii?Q?1YJyAYb/+v5Ml033PX7ELtaU8BYG8fqN4zKzxm5xVGkykQQItoDc1OzcIEQO?=
 =?us-ascii?Q?AZUVpzV5oCjcDWRRiiT94jfKF2Z6sJ1faDgPN5CALdQTSEG+n9kWpkcvSs35?=
 =?us-ascii?Q?3SgsEy4RQ2yKqzsr5b9z5ZEjvP1rWuz/hxvkjLlPMiO3atW1Ovx+pUjparjy?=
 =?us-ascii?Q?ExRNiteF93V36nLOTec48sApjEss0EGlcRo822I8OW7LQf3qlUxOm2nqF+xC?=
 =?us-ascii?Q?Ld4RkJIGlLTEYYBG2Wzix6pyYcI1+2YlFH7tKkGwqDQ4+VE9XNKCSap7yVo0?=
 =?us-ascii?Q?msv3F2RVl7VyRzbh4Bvwferc/vxq3PDg1DmMXKoTYZ9Ursp7/AmH0M1iuIZP?=
 =?us-ascii?Q?1e7U1Bylrv2pnaZDwtWDE5/ErHoUw5+xG5awh1yApodZmFMxr6Freas+ruag?=
 =?us-ascii?Q?eTv32DJNqcE6wkzWZI3IECljM5Sd7El4nRxd3eW5KemDszJIxWoOrKYtZAA0?=
 =?us-ascii?Q?zgKoHYz/DnrLHNu8II93h+6Y6iMykkhxfkZNnZNO6kf9F0q9MF6y9OkzUWQj?=
 =?us-ascii?Q?0aX4tEsvoYpQN8CEjw/4FJTWCcLfkIg=3D?=
X-Exchange-RoutingPolicyChecked:
	eOok+BJXhQe8yoP+OFfewdzeK3leicz3tfJeJOdVMmNGJegL4swCip+MsZrysXbKDERJoc3MTGpP+h5eBU234H5gWDRJkTdy4WBO5Mdfs85UBRfAxmYtAjwxZDm88EE1e6y4sBrroLUOiMu8ntm7xEVb0gIGqlJXZQ4wk9iniRpaRkxW9N7BZBF4aKQ+jrx8DXE03IOl57Q6nGVTJus/MSwbejKjHdfyKx9Fw+7BZ2k9hIgK5Rrgsyng/X10C5HL80S6psU2GjFm0cGKRuy4htsZmC29ExRGBKyR4iqxdWvT7/ChEnblGhcLDpN3NnJx+OQ6KhMoSSCoqqKbaiWH4w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bfHi2xc77+lXBG2f1wIzGq8CUKTquQSU5gsu4GIWi9DVLz0T9d434S9goenxz5gOMlcyY2cro0WrUxUAyL7M6NVPuI6Vo/rxbIq88blUonYatmk1iUGXNRa+UtoF6hGWKtf+hVf80WQQhUf/xICJX5kN2vWhhjBTGqy3DZj8qJZc6ruS9B09wJmQgcrJxwThobXuQpyNDNP4E/ryKT73nYx3bE1Lb2tjzHAxFoEkep8TWy1PsbJH833Z+EhyuX8mFUPYOpOA7ttOPWMwi6hO34kvoRcAQnhwqxiwdjWYFTTgfUvITzSpuqyLd+USFgS/D0c8SCfWEDJnLxSsR04TsKU8deTUfk39RaK1MFFM30yIaLselbv03Tne1f5JjGbH8tOgMgajTKxFrkZ6i3Jzdb6DWUjb7YuWe4ZZLk5ak0DqX4WNljIkNPb+z3L5gH4AGG4yJ4omMtEWas3FnzpxtJSj7MqCVRoJ1pGvx0YCRwNgsFL6QQG5wEUwkxlfuPfAUWmd+COVlQ+klqkPJ8eyIDdeg+vYDx9EBP9hkzg0JcP/qsz+Dp9u3IlAHG0uG7RPO/ZvcbSyMVreH3mxkBPCA07Pupk0jhxsZTbMlBm1Yzg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a97bfc7-0065-4e86-3683-08de9f4ef1d6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 02:37:34.7809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdUxdfIFf6Dfip0zeFtmJKMcWGwecHz4KOKS7dPdrk6OFXHzJqYjZh9lmZXxTJ5Ap+QyFjK8rRUbAHjhYIJprL4NVPoaLA4YITih+kzqZcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF715E13019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_05,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=956 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604210024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDAyNCBTYWx0ZWRfX1o7tOEaEnvRx
 arCwhzhLx/CpmdGg+I6VI14veP30YrMntthDkaJkOS2K9PpGDh67/l+VD6J+NZ5dC7Rls4de8kd
 gYJ8Fxu8/lV6TOYDCw3bJ/OzAjgbs0EUbD82XDluaQ71CYFEs7gBHt5Tdvay+AhNIrtwA1w46kG
 ImD1/qQC7/E9m6JX4M7mMvGv1fUBi8NRG4iXYylNouflR0//SClMt9E8NHbApUevbWqYxbvTu8W
 G2dtZyV0L38u3XhIQfI2OBsjEvov3mW2VVFoyyKDTD7qFmqdk8M2fFyObyBqyrjRf7jNHubqfFJ
 iC7bdP7mHhUYDgevZcQp0E7VoFNzBwphBt73SkGTjdKhuphS7wAowJvR+MdL8ugzNO4Pzw3FeWV
 sAVDL9KXODQvkYF4/cBIwwnI4kSI3+68MpyvqGQuEExFEFxVNw5i70vdDF5aAx/TRkv4QT5Xfno
 JK1vuTPD64/y6XQ93cQ==
X-Authority-Analysis: v=2.4 cv=TN51jVla c=1 sm=1 tr=0 ts=69e6e2f2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=kETcfR0omgg9jHqpsmcA:9 a=ZXulRonScM0A:10
X-Proofpoint-ORIG-GUID: BlYeyyyjCW9LPslCO8AIBG4NgFGAZu1V
X-Proofpoint-GUID: BlYeyyyjCW9LPslCO8AIBG4NgFGAZu1V


Yihang,

> In prep_ata_v3_hw(), add cpu_to_le32() to fix warning:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1448:26: sparse: sparse: invalid assignment: |=
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1448:26: sparse:    left side has type restricted __le32
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1448:26: sparse:    right side has type unsigned int

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
