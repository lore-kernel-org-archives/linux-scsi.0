Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2059640F8D4;
	Wed, 25 Feb 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034076; cv=fail; b=ARkp+N+QXfSCzgLHJTHEbfa1BYWGGnQzo02488r11gdED+NN41fi7b6q399WWzdzNFdjs8nBxxwt786VDgW+ld0Uam4Tz02VeTsl9e0ivs19MDy8VQiCso/k14ibqzzVC6+tDj4E+eOW0C5uAFpbFuCeBZnB9vZ5sMQfBcoGS8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034076; c=relaxed/simple;
	bh=q2WbskJMYJYAyZ5aR1R+4oRP5aKNGWd7SWraObSWRYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LnE+ZgqvJqASLeybG6wNVuVvBt/NM6Ftln3MeCqcmOje12UBXXQimiub/7iLTF2Ng5aKemWplpMV4LGnSxEPKObiWfKKPM+eSTEs07taL6s5Xy0TboEHOocgeEoNEoEKnK2msLBRzSGa9Vo8d4a+Ju8Az4rSmbMX+oewCDyCU7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SVXUSBR8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mnCAOTmK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SVXUSBR8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mnCAOTmK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9nIsp817326;
	Wed, 25 Feb 2026 15:40:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ei9ppH5zjJhmivYRCmksOU8Uu3DHpvl0YTXTLJVfTiU=; b=
	SVXUSBR8BDQtOe9DvCC2TDwsPyXNgwIxGPZOr3KSt0dED1G/EXBUhFKjiANebwoK
	JGCe65JzOns/R82e0EKmX2BcwlE9F8dj5yWEiv2pgXEg032iE4M1rnCzjTgEHREE
	5M4iVoA5PtfdIdJBnCB1ElUw2KEZBUM93dWrHxg74jJc4y7LcEGNx1k26H0s03ov
	2DkR1grq/eTAynTTRjdOQtM4sVrGB60mGdocIUMMueMVOQYphP5yH6k67U/Dcg1o
	gZl7xQjhR9tdVMEWdTXIwjyBgceszPEGDPnEDgMw789jc60Xcw/ws6s1d0LUD8I0
	I+NcJeEG2sZV4nK9uu//PA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4areetg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PF9PNU012757;
	Wed, 25 Feb 2026 15:40:38 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012051.outbound.protection.outlook.com [40.107.200.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35fg4uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:40:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Co6sEOJV2SKsI/6qj0jDeChZaPHQCjm+wNX6BWPh++4iPzJ2XxDHMKuKniGZaa2B+2vDmw4Xfm7pYb35v1ggaoX/8ZHZO9iFF0UTYTJrd3rq7pTiG7qTPpy0lVhZBdsDyhoTKmZJFgURrNJumQ2zfgeC3ew/NH344PKhw++Hz/ia4Q+NLwz9UeN1agpS1tSYf0T+Q8sXyzlZwB++QOEMgLb72lY66lve0dFxYzW45aYLZfcbTUexRC0uJlv8v0K/M+hRedK81v1YASRrsEguPrpg1TPtwuVfwJKdm3numReQHcuSQwZ21/uoJVjvVtfRK0f0kFWqnVJu7Ess01IF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ei9ppH5zjJhmivYRCmksOU8Uu3DHpvl0YTXTLJVfTiU=;
 b=RXKpbIUTR6zRn71ADMNVQj5e/T3Px9ad5Q24d21Y82IXGuCRtk+89Uhn/KTCIn80bILL69x0zYpkTp8HXukU4++1af62FWYrvYn5zklxk3yu0zALxjuUopA9OLQ4Qbu+H+XfkDtm0U6KAADLSXZTGJWaoTrwlavqEBIyTz6pbY0GoFsfWqMno2ubnh/OCqY0/xp5xWrvaVrEoipdyW/KkSCdXH9hAqrCrbQmloLaAnX4BhB0pERa/O5Awsq4/LxNTmzWHxHlUhr2NAnZUVcJyqTjTFfmgz2t31hz2DKBybaWexRrbHvW40r65GUEHylQWrM893eWiyjkYu62IuT59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ei9ppH5zjJhmivYRCmksOU8Uu3DHpvl0YTXTLJVfTiU=;
 b=mnCAOTmKLAUgmwOsHiPY6ZVBUwyH4uyA7JX2HSJUG2uKNm3Y//qc7bDmZ/ByABE6UhhFc6GGCpvbroEw86rw+YEK01JrO5lb6tlE5vciSUNB64sacR0Q0zov5hZBdVCj4GytKo5Q7N6/19NEt4yM70V9GoGY0fsZsJ6TkmXLdZI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF34C504C55.namprd10.prod.outlook.com
 (2603:10b6:518:1::793) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 15:40:35 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:40:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 07/19] nvme-multipath: add nvme_mpath_is_{disabled, optimised}
Date: Wed, 25 Feb 2026 15:39:55 +0000
Message-ID: <20260225154007.1033735-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::35) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f9ceb35-84db-4b76-5fd5-08de7484377f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	NN7vjBbfk1X3zr4qYm4wWDkXBWOwQUnENTriFQMZD9KII8hHSrJXVus0VEsLFkV8g0W/8jTArrf+TZSA6myNcJP6roM1Kjp7CzvfU7iyW/TPLEtBVmr0J1SjffI1eQ+5Teimo4ICOhJ8ecFL36B6eC5Ru3ieHbuNrGXbfeESFSRcTaLhMwj0Y0A3U86aR2tjOhsp6ZEk4yefOPTEip3qLbDfA3U2Tdsda7VQyr75M8cHQQUW/22+cf9L0W01rvZGjfoTjldU5hhjcODpqUE5yYnLySuBX0F3/4ZxuzPjXXTh5s/LWnBMks9I4RTR7/pFNhuv76mlSZWTHRZpBgScVdWA/HQftHU5Me5J+X7N9VQxFd3dkqAYT2NZo+W9NFJ0iNiXy3+5kEr3Z/KBSNMQi7Httn5a4IV2x7UGXPoM1zFLQgsym+afUbrwriHXv8McqgXX8wTO4omB27odm9q3rSSVqjfgdwPJJBJym2IrVG/EDWp/+GcpaiyMA4t3PK7pZ4SViK45PrQG9gWJnAaU8ByLK2sWR1w8FxplK2aDPeyX2JcotpkHxuQBX4UNqQR7wJNyUoQs2zz3pEtagIpZI6vscrYzzMk6mdOCnm9MWTw/GfM+lE6RQZ7Z/tPOWapTVpsJUJZbpnMI9Bccb39+raYmLV7X1MoA7TRovQhCgbNcCl4wCNQZIdP1rbj85ws6Yfc/E4c+Hj1lwQ3tBpBw73l94EEZNIoCe0rsg1B2CpY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6tPuPLAn5k257+adzIDdNg7BiFCYzSXaH2LInmK4NhIToNqi/MxM5Dds0b7N?=
 =?us-ascii?Q?s2TCKGJfVCxohJu+FG+sSORG7vME0FksX3Pn21zDZNr3GhFsKuPcvf78vsmN?=
 =?us-ascii?Q?9Zp/+uPj3V+zElF0I9pxdcoXFUM9N+sWDFjgrNvutHeNh+3lkJ2i01Agp9Yq?=
 =?us-ascii?Q?HB/CGyi+6VCOBEG80e8r25Fzd57SHQ5mfLeE2zZyKEZTL73GP+mWPZAnVC5E?=
 =?us-ascii?Q?6x3pJGZtOtYDxSI3in6Ji9c5t1WL/ah7D+VU2qrsglfCbFhgGBWeu9ZBEoSd?=
 =?us-ascii?Q?unpm0EZa5YEGG8tRDgQmv1bulyNfPk7lJm8p/ySv9tXpaVjiKeF58Y/48XjI?=
 =?us-ascii?Q?JHhYXCTlz8d0KVH/UxDWCR98ZEAKnU6EUHzXRG5vwzv+IeZmFx1Pft0asj/a?=
 =?us-ascii?Q?lgycJw/wNTgq9ey0qHXTQMZg7prUtl3H9VQDfbBM6T+NLZ7FWy/4eyRxA6ZB?=
 =?us-ascii?Q?PI4Z3Namsvq8PeJJAEC2za6JuMRa1FhlDVCKiDcNbOA82VLDhA05Z4+pFxDC?=
 =?us-ascii?Q?URyav2bxytdAgsMqt2MwtqUUNfqgMPO4TKssVZgtiXHMcWM6PgCja5qZHlxN?=
 =?us-ascii?Q?XlL5p7Yxozgzr7a6Iaer4eAx0wvrpLWsyRVjqrAuGERVsHbeks/Eikvr/P/Q?=
 =?us-ascii?Q?8cCmaVZm/HQmvZPuw9CFx7WefbeeSGVv1QeMi1tGjDeQ4F0Aoqg0qPpFICEn?=
 =?us-ascii?Q?lNgC28ZuNxW3yddM7kPZjNig5Q9qC9C2iFLnmosW7jUz5jEyt5QEYTrkAPqj?=
 =?us-ascii?Q?fu6GHS9pW4K7HRF/+1bUkIbMxnIR1DJ54JuW5VGwlSW3irrJXIT4ZRmhVg0m?=
 =?us-ascii?Q?ZzO5wITCQ9N0bDkPNYGfGywk5b7mC27DKPUePS7QOwSUPwbx6g3/30hscACx?=
 =?us-ascii?Q?XnTkiCDq72FgQrewQsAlVu+uSXuPTeKvqZzze41dmXEHaxb6so82+AafbDBr?=
 =?us-ascii?Q?nfkoPY5w1PWYk5ZczYZTkZHFPqDHf5SFsQtvtqxtpJG4IY1xtt7y5ljPmfTt?=
 =?us-ascii?Q?Qg8EcxtRvBZ6+jIqcFA5BbKUBkAgGjHmyUUoY87T5yYUYhWye6uicNEf+07j?=
 =?us-ascii?Q?LijvtO5i4WzU+bcPDlRjhsdZFxDJ3GslvXRXLJFcgeF1zZzsxXcixR19XPce?=
 =?us-ascii?Q?RXWCizW8uUzAebpTQ+wPn5bEdsEFPudZp/SMkbcAQF4VgS+iT8+mmNLf8/ll?=
 =?us-ascii?Q?dxtwEfnUhfLtjb3VtJnTdI6zmMDGn7W0ZSJIZcdFwLFuwA26GPLCRudTxtvQ?=
 =?us-ascii?Q?LZna/idlb/e/Z8mOG6ChejKpXYjeYgqPSCc2+5zoFakBJ/OIHKDvX9cbck63?=
 =?us-ascii?Q?n2p9xChJ+MgNdwLIGluFNwUd/4RgwDo3pcCkhyXenm+lTkX0TAoQqmsS0K14?=
 =?us-ascii?Q?AZF1fhenMtcJ6LjS/nHm9Gr534DHYCfFDy7nQz8RYeGdWaoojirS3AgwVt96?=
 =?us-ascii?Q?hV34ydkNbnF07m98lmtOfto03mMx/zdmG9zqRbeLxSOIiUqs1lAm/aqaQTRS?=
 =?us-ascii?Q?rOBJSu8UcQRGir/RDoMShbTkdfMe5ptcxYQ1ChHudQnF5ElhYpG39YcyAkjz?=
 =?us-ascii?Q?viFNEStjtEsassPxrGwhMR2Rw1JHJHQNQC3ad1694x18UWnE010RYv5pcDrZ?=
 =?us-ascii?Q?8sD/tyCkWjJk2OpZWXs2Xtd15OcPEyBaWjaZ6ZnBiKA11Dn8urEhCW5yVkni?=
 =?us-ascii?Q?BQUrUupHeB3w9sHMTMn5ONEGse8U0KRX/fR3LQtvWJqvO8L7/fFGOJiJ6df/?=
 =?us-ascii?Q?azSHl5pPBfy3xm2OEM+wkf64+0GsbHU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1nr/hwhlhTSJCNzGX8P1x5WroNlA+u3CylwPHwSqmmCLAbtF2KFgE9pvAREWc0muy5wx8+Gygn9b859lqD+n06lpj4EyaCrmLrGGOQXjhCmbAvyksK0R2M5DSs4jZPW7OUGfXeGUYp2OU7H6fyspqwPNJrT+JrrciraR2QgDkLh3Tp6cVo+uYuv4jV5tbtLY+3poaHEwE4mTBf/m9d0WQ+pdiAGE2atPhVKkn+mLONAAJ9z8qMhYKQB8kkmV8kqLHSGgTPXnJFMf5oo/Lk68KT+jpiIm2duF7t+xzaQc8uFIcP0DCqeZR9n+br0I0pn/EbTHTNYM08bG7C4u+2AmHNdLKgVKXfyOXX1Xa0QDgjjHQghkXlX25YUmtIAWfVGWv641wKP8BJzl/apLMS74BuBAUDeKsXHpxREpG0bxcG0SIPJu2rlkM2FqxBQh/Ytd1uWxLxJqo19pQHcoKshEe6nq6YYEOCPN/rN7/HS8Lf7hnwyx6m22A+l4oA1uSGPpvtRrAjKy1t5WTR1t+mmElLLNtl83/WWpwjoBZiRBIpdsXr/KV6TJvmNKyGBnX0zwyzATicrfQz4qFUuRlH6hp6e2yyHxLHnU+Y0RnGG0wT4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9ceb35-84db-4b76-5fd5-08de7484377f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:40:35.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBuwfGXF78GDgEhvFvcwxcQ4Hs4OtolXwQnm3qQTUNGU2vWFhKturZvpNhBY3Rv5Fe45Ak719YyQCfNRz4J4Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250149
X-Authority-Analysis: v=2.4 cv=La0xKzfi c=1 sm=1 tr=0 ts=699f17f7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=QNd2FcQEdVqeu-mTEKYA:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: XGv0PF88D0bPOj_9DmXP5d2EPgB1oGW0
X-Proofpoint-GUID: XGv0PF88D0bPOj_9DmXP5d2EPgB1oGW0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfXz/lGhzUzVAAs
 yF+Y6ydP8ofWjLQK+YAenH4kaVVuBkyiWwP+LXY/lxKeiYZ3yle1Z//VuZcHwWf6PfpqJ/lXtNA
 mHF9kPHGDud5gS+CQaUewduLtw9EJeuUPtlx1BKmiQpaK7QiwsONba1bflRRvpslCKWUp/W/zpA
 o/LbFcBI0uu0cPwQER3D3F5pzPcq284todvCCJv17VBjXa1qt6vF4nbNYGU052R3agieAJ+BIO+
 UCmlGA0bimfqKDTFrnbsxj8rWKl/7EV3UkchMbWwNFlKKcz1So9fBPFTAHL1qkAT4xsYkIo9VXv
 WBeyxShV8lvJNvktyXV48b4fiKzuiQFfq9pMNFX2xP1IA77XU8+vXKlxL/x79ZOYev9pZfg6JLs
 dPwMIqH8nF1dv4wCQ+u5y0mlSTgoVxKvloLIaAQLKikXzof8oK9k7i0djRighsFspUIgxVWs0bl
 Xh4u+3eCVDrN1qbBitcO9KZpkHQzPVqQPzTx1MuA=

These are for mpath_head_template.is_{disabled, optimized} callbacks, and
just call into nvme_path_is_disabled() and nvme_path_is_optimized(),
respectively.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index c90ac76dbe317..07461a7d8d1fa 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -310,6 +310,13 @@ static bool nvme_path_is_disabled(struct nvme_ns *ns)
 	return false;
 }
 
+static bool nvme_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_path_is_disabled(ns);
+}
+
 static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 {
 	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
@@ -452,6 +459,13 @@ static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 		ns->ana_state == NVME_ANA_OPTIMIZED;
 }
 
+static bool nvme_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	return nvme_path_is_optimized(ns);
+}
+
 static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
 {
 	int node = numa_node_id();
@@ -1455,4 +1469,6 @@ static const struct mpath_head_template mpdt = {
 	.available_path = nvme_mpath_available_path,
 	.add_cdev = nvme_mpath_add_cdev,
 	.del_cdev = nvme_mpath_del_cdev,
+	.is_disabled = nvme_mpath_is_disabled,
+	.is_optimized = nvme_mpath_is_optimized,
 };
-- 
2.43.5

