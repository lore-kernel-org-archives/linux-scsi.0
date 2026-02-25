Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC2E3EDAA7;
	Wed, 25 Feb 2026 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033870; cv=fail; b=rVGhN8EMvv5rGHRxZjCW9Nbfhn3QKzvRVxxYdKqLcGNXHX3PUPF1eKv7L51ST7uL6CoUOdQ8GtPzVehdg81H8jv/pZu5Ubs2UG4IRMD3kEyZZhyebfHfC7zLRXxzbKzZq0Ltaciga1Hig8d4CNYHMICvkXvtVynp4UzbwiFGmnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033870; c=relaxed/simple;
	bh=eTB+qE36nmn+UFhbKSf9G3cT5D/POUYYNrnTmAuwFSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KzurTE8ygQhwGbTvXlwRFzuAL087s7ju6pKBmql6VU0faNrL2297Vzgp406PZVbr1SeCwHzpEi1Raf0xfb+BXMhs4TI7AyLrkabjlYchjW05vo28/55QsRnk1xyhajrDNkbkN9tqF2m8NtJR7YJorixjz/NFb3ZoPsjIsCXr0uM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EP2/MzRG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nsCE0pXI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EP2/MzRG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nsCE0pXI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9pPXO3928883;
	Wed, 25 Feb 2026 15:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ezE1yPdG/XvgDJAO0s72hQuy4ghN50ODpRPfQMA7eLw=; b=
	EP2/MzRGlEuSMClOX7bxVNng/HMs6mBQHCGL3l7N+OiJQPVVheqJu/HP7oX9wtTd
	kteqmr8S/oyzCid1ZbgGw609oZka386ehtekzyolJmBjsMEcDVbfAZsOVxKmybHC
	2IBRQ2HGfKL+pm8TOl2zm4WPUUxy9SBT8Bj8taBatC3gsztXAq8MiW2KZdeq3ZmH
	OMc1q1iYJvcdjaRvpEuVONGxL81bLZAM85V340T8EQLAcVbbkAfBfzeLEoqqh99z
	wzUAkfNHFcTE6IbsdOhG2phF+mFdzgLYnP+jWfYMUYZDatzwcvZydhDkDepV7urg
	nuRcVKpdzKvjFpMlxtiNJg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf58qedyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF5ciN015907;
	Wed, 25 Feb 2026 15:37:22 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bfm0m-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Huq6+FJ8yCyjRJkzTmkMxMtVyaTgxHkG85yRBiEO1ScXQVOrRC9P0IaHT++64H4vo3xZgF1pGWN/kxVjlg0Kb983B4xB7IcQ9wT550R8NL0b3rZGdEQtwmh20L4LS4TtIaZLqCqeqGCT6Y5H0g8/40KjBgR68pj8BhneK4yIeNWA9VOkkpLKUvuE/ORRfveHB5viz1boVnbmzITJ73NoSf7ZvB1F70FqqUX3XqX5mQfRqru6iTVMraRf4f+SiHPrYTa58XgOQRTskjpbHWEcMNw1Lnp6jkpSPXVSNzmFbiodZgg65L5Fj5iGXX0luRRcgOb+l40uvV01BBMXap12jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezE1yPdG/XvgDJAO0s72hQuy4ghN50ODpRPfQMA7eLw=;
 b=X/odugoY1/nF2n2FDlKcfw+xyxIdKMvZawfU86+3D+xO006Lr42tjKeSnpLDPBgMcp47dm+fwwjAkc/kX2Se1puLSwhq7EMIE8nKgIRpnx4ifv5mlfx0DilfuTQj6vTypcdR8n+X766w+FswG8en8mJwMcjL/UJyFPco2m07K82cbz/TyU7JMv0AHWW76x+hi7FmH378Swrjr1JwDirQVM0Qos/Rn3KJcbT948e1m9s6sWmFEt4z97IorPoZRCTiRfhB1FAXx3OWuAkAghwVWPo/EPqDttSVf7OJ7t8GIvU8AK4PkkkQdfR20WTQSu/3ZP5dQ029CKLrkJXvXXQKQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezE1yPdG/XvgDJAO0s72hQuy4ghN50ODpRPfQMA7eLw=;
 b=nsCE0pXIkBcSZyG/iwL74IQaDtmM9HRAeyLXzm5jvQ0bfcB/wDTxS2tAzREMNeU/QRFLhL/wGJ/oZ/cnKMmNJq+mb2iM+l9QxlqG+oEr7imICJxpBZrLSH04oTLI5x+Ppx2Gx0GsnrkXo6m5Gyvb42jETRDJwMrkVZuoIe8/RFI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:18 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 17/24] scsi: sd: add sd_mpath_{start,end}_command()
Date: Wed, 25 Feb 2026 15:36:20 +0000
Message-ID: <20260225153627.1032500-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF0000409D.namprd05.prod.outlook.com
 (2603:10b6:518:1::50) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: fceac4ed-52f6-4b49-27a5-08de7483c247
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	VdWpg/yQENCIVZUQM3v7MripljpauSc3fFvoSoWgisxDkoxofB1ROs/+sAvQoyzgwdvFg/j2j4bMdiB1O7BqJhOlGn00/LWmmq5KnGJ6CsAxyeW2UMYU0mnOQ+8R8zikg0x/ffh1ILGigm+u+1gWVFo5YHtOAHXUTk0RkU2dTrh6DF7xO3EOVUeYA1l0L/oWd5BTda4WsDMijE+q+inhB3hb+iS6qA/x8svbi2NrLbK+NRbUNj793NFdUNQ/p62jGFJccGdBAXhJnYxhJObdXQqqrdsYMDrS44O8S7kPyGN4Yj9GTxME6+5nBwtj7Ezw86SlVptiChzan6ZUH6TjVhbkJiVbhUepbgF5rfd7rt3E08rs/LUg3IyEcErdamlH2CkdlAqOlG7dOJL4H60jdrognWVUWkIueodqget5OAOHCoRu22D/w8JnLNXDlGCKmcINrhS2hsRHZIWfgYU0JIFcSxdhBpoLgDfmmgNSqSli8IcZd6l/GgqoRfgmk/v7m0U8PagqESnUE6B0Q5nZJSbwCbIkmFHBe8ndgJPxESXckuCQ26HD2ZnE8M7inEWdZxFZueMqH0qSstJZFu/fMiNp+k+FZPQlV2Hr3u0wrWzkzQnmZeD8Vi9QBy7RlBUN7JlFl9nCOV1L2k+8gw1qknnjn8K648BijLTuypFpDXPt5STU6ExroQnaHvRpd3Uc7eVtSfYQCXudnzEa99TRFAcSl0XOOmZf/f6h7GIKwhI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iyrGq9cyGRHkXdJ/JIntGW0yBNwN2ClqTrw/VNn9cHIdvtAWDtjrgpntFRG9?=
 =?us-ascii?Q?hJ9Q7MWvAEcwtFmcJ+VaSJMJum963KzrgtFTMsjvCbOTBdan0G4aFo/oBOXF?=
 =?us-ascii?Q?gXTulnlAplNTWRPqOL2XAGhyeos+S8Ca/XqZ7EhZh9A+A0d/BMlv2tuUQm05?=
 =?us-ascii?Q?bFEHfIx2UxjDiQKyNxfXr03zV8QzJtcRBxaGayITvjCF48VfqOVOzfjCEy+j?=
 =?us-ascii?Q?e8SSCOFAW3Hi8lc2okkmU2xUfvz45kLReh9PXSX3x0/YLUAt42CJk3fckCs2?=
 =?us-ascii?Q?zQNsyVqjjR5zYdoGYu5wF4seYlph9hrEULWwCdRfyhbzzLyFon5yBYsRkXnU?=
 =?us-ascii?Q?tsRfO8egFs9+inFX9NZo3rqyDVRy8oVeE0OdAWG47CQLgiLU7R1HbONIC68G?=
 =?us-ascii?Q?4Rt9niEOgZIjJPxEcBzBc5mR9DUwVxVBUHNC+JQh32Wa9zQIeNT7iKOpcNYX?=
 =?us-ascii?Q?Bf2KKiM61T3Rxc8+vgo/2ASiM1TbyWNiKt6DSlyAOC7FaEFrn0AipJE9CFDc?=
 =?us-ascii?Q?rvJZK2TDbRQHNkkLSbiqDqAcVf1oSI99zRTbTzHlr78g8WSiWERy5z8UazWZ?=
 =?us-ascii?Q?P9F7lLQqmen3ErsA6xbOFPlsUjcQMeYVcR3mkwoaUZnlBIfN32l+R8DE973b?=
 =?us-ascii?Q?MWmM35qXskO77Gm9lO7yxG6jXvlaxxkvg+hZ2VcemAo3REeTnyQf4vd+sGZQ?=
 =?us-ascii?Q?f77OxISn8q4RlLBdvFYQIBTwBHU/kISv8YmrDtj88pAJLHMJPJkooeMsc9UG?=
 =?us-ascii?Q?xqwOk4F3VBEZvpc6pEsH42b6LKG9xcGYQSKONS8zgWgch9g/cimWsyjb5F6f?=
 =?us-ascii?Q?0OyqbOPwBj6KuJ+wfft4CneJ51HeIktodqcFHWJdcjvLsYkBUekPofCl3lAf?=
 =?us-ascii?Q?65EwYyVhaAxkXspNJ/VXGAAos8fv3YNYR5TTiGNFTba58EEeVolTj2+A5AeK?=
 =?us-ascii?Q?ek2GkYXXuL0iqxxwOcNxJiixBJB2Tg+1kwAFTE4RQHLW2mz4H1yAVgDxUwFW?=
 =?us-ascii?Q?LyYqQwFw2sb5U4e4YZIYfADB80sNfpEMia+y/OqC5KxKiTsxpO3ebgH6LZL4?=
 =?us-ascii?Q?aX8oqGSjdC5ePjNw8SRiwEGqi+Y4K63yrQNyIX24NqFhPsO9Da3RdUwluDcM?=
 =?us-ascii?Q?da43vLu7em4AI1Fk3RNBvTvrNJ3zkYnxZeRmNxFYIJ+DnRewvZr+psBStelG?=
 =?us-ascii?Q?EkdndmVKoOrUlgobMK3A8Oopvljzpoc5w/euvoHpCWoD7hEkuYOxk+1xiKFc?=
 =?us-ascii?Q?o/j4z9+Z8UQQxNMWPSsGnQ1AIM2JtCmRpqGEoo24QWpe9dw9Qh+euCkjDZHP?=
 =?us-ascii?Q?Wy2O4JVFAhZupD648xcqr7SCYCbpLTWFPLv5J0m3tiSz1IFWicgusJJyFydy?=
 =?us-ascii?Q?psgEhj/3/zyLCtfZEvvq+1ilSManD1qgyCbuANkOSvxJFpKwvkVQl7Ll9vxB?=
 =?us-ascii?Q?S21BgcxMXfmgkZwgjSP9wnSz7XHf3qiatMfCgjXKOcUQNpwJ76uOjU1PfKQ+?=
 =?us-ascii?Q?nr1PPJp4KRhUl1z93AQOS2/HSP3nKrRBI7UbvgLioAnGXG3jkpdSvN3FTGBx?=
 =?us-ascii?Q?kqhVzncAI1G/LrzG3/g02Fzaj/e3yl3Ob6WCPXMRK8DzO7CHu5aQ3gTtRL8r?=
 =?us-ascii?Q?ndMgSvPW3j0ROuI/i5ZeHvw9nqFB8GjTDZTAfRcVJ1ygy1iGhWWhiQzDc6z1?=
 =?us-ascii?Q?H1zojzqU7lJc361mDVUglFexwRRIgJw+1AgPz6NYIeLlYt90LvEEDQCdbsil?=
 =?us-ascii?Q?2rZVamH4RywgddrxMxkIYSy+2tBzQmo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w2+AKNrC3RMrhqiqSYwOCkTV+XL7G9wGD2Li+4vdNI2t2Ai+POZstGTCKjkKp1iz/qu14bsDdY098HneOIXZwGQ3U3I4yFTx96ONOmPw4JNSdxUY5JENY6Po6HA+vs4Z7OwulwzsLCfjypLisxPdW2HYxxckMV/K4AgA2yQJv3tsntO8fGsC3GH4tRUrSpsMTPzm2zPBoA0ahWOWZD/owwq9NvBKa+kIfyysgF7xa5+Bc0rpSPEah/O1e0YpNSfX3/C7Po4J/2Pgqt4TLB0emt+vv/SxkR302Zx2fuO+llwSRCd1pFk+DWLGm4UtYe3arcJLZiUJEFyCcMr0C8bLwmWQDvaZdv2HqeoiSNPZdgHuk2THnARNEqZgWcNLq5hVr0vNIxvG6cvshNSJXoJ2kj4Y0BBHsfqWugcPKM/LP0kxHm9IP7QuPdOPaDcUlkZF6P+sJv27bQsTtGHONX99XWnYAsPZ5xW1CHRTlCh3peQWv710JoGRhFBQXyITzCZqqsfjr11KEiZNwTRBUzvYXEEi+64y+5P1qq9bfBKmUuJwd8F0jvX8Vh8/tyTDDD5qkOKRp7+gDnfBFotVziM60DCEGYfOoTGw8zXH/MtHVzY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fceac4ed-52f6-4b49-27a5-08de7483c247
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:18.3558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8r+wakE/X7OImuaHXxrJ/cCbffPAl72cDAkUH4yMIb7x9zGT2cvEgfMgzZbYobOUuEQJv6ldweP1EGJk/j/tmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX9Gp+OMpS3BkD
 DS6tRjT+fBYdtLIV//xP+1m4jUDwLd6zH8Sb7RXQW9oXqvx1D08Zi20Um3GdHU53yvK0S9h/CVd
 4FpGG4A7Q129IZmOngWu6qljOymEgvFRat/a+1aDcGVsvoBfJbtZIKuOOzEQMNjo5NeHAFc4CaZ
 wwquGplwWI5KkY8lrZmtU7wETs6+mWWMgngxGmcf4sPH4NmYYz2KniksGZqKCMxnwF4UBp1aZV4
 JWw5+RWmfsfjqGrb3ggS//YhhbNZeXgmc4h81p1Wy2Xy8IuZJxsWSwMkDgkiiOIUAYAdyqkgrQa
 0EXUwqxwh++riB2rgmUIBw2rsML/MoCur0mY64vQWXPt/h6cfm9IpBkcXJ+HZhjW17bjtGuMTUA
 meRnYkuTU/x7uY67dWkc5U5EfsIIKN2x2wrjwhyaQyS0saBqM6wE7xg0RZs+ZeIipKE/2FLUjX2
 MDejKt3c3GHooTfP3AA==
X-Authority-Analysis: v=2.4 cv=XNc9iAhE c=1 sm=1 tr=0 ts=699f1733 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=XpjiT_gqlVZMTlU63hQA:9
X-Proofpoint-ORIG-GUID: EScnXCmbvRLDMAnjJoTSzNVzQEWeQugz
X-Proofpoint-GUID: EScnXCmbvRLDMAnjJoTSzNVzQEWeQugz

These do the same as nvme_mpath_{start,end}_request()

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c             | 55 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  5 ++++
 include/scsi/scsi_multipath.h |  1 +
 3 files changed, 61 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 222e28ed44e9b..845d392456549 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1546,6 +1546,57 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 		mempool_free(rq->special_vec.bv_page, sd_page_pool);
 }
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static void sd_mpath_start_command(struct scsi_cmnd *scmd)
+{
+	struct request *req = scsi_cmd_to_rq(scmd);
+	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct scsi_device *sdev = scmd->device;
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	struct scsi_mpath_head *scsi_mpath_head = mpath_head->drvdata;
+	struct gendisk *disk = mpath_disk->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+		atomic_inc(&scsi_mpath_dev->nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(req) ||
+	    (scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(disk->part0, req_op(req),
+						      jiffies);
+}
+
+static void sd_mpath_end_command(struct scsi_cmnd *scmd)
+{
+	struct request *req = scsi_cmd_to_rq(scmd);
+	struct scsi_disk *sdkp = scsi_disk(req->q->disk);
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct mpath_disk *mpath_disk = sd_mpath_disk->mpath_disk;
+	struct scsi_device *sdev = scmd->device;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+		atomic_dec_if_positive(&scsi_mpath_dev->nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+	bdev_end_io_acct(mpath_disk->disk->part0, req_op(req),
+			 blk_rq_bytes(req) >> SECTOR_SHIFT,
+			 scmd->start_time);
+}
+#endif
+
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
 {
 	if (sdkp->device->removable || sdkp->write_prot) {
@@ -4468,6 +4519,10 @@ static struct scsi_driver sd_template = {
 	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
+	#ifdef CONFIG_SCSI_MULTIPATH
+	.mpath_start_cmd	= sd_mpath_start_command,
+	.mpath_end_cmd		= sd_mpath_end_command,
+	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 	.eh_reset		= sd_eh_reset,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..c6571a36e577b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -60,6 +60,8 @@ struct scsi_pointer {
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +141,9 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index cb63c6536b854..2011447f482d6 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -36,6 +36,7 @@ struct scsi_mpath_device {
 	struct mpath_device	mpath_device;
 	struct scsi_device 	*sdev;
 	int			index;
+	atomic_t		nr_active;
 	struct scsi_mpath_head	*scsi_mpath_head;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
-- 
2.43.5

