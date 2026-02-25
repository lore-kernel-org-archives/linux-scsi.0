Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AB33EDACB;
	Wed, 25 Feb 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033871; cv=fail; b=A0yrV8ObibIoRMk7R3KxzeKVrd9CPEGOAWqKdOX5X/p7LNz/4EbsP5HBY3aUyhhTJOCRRJODXrqclTCzEdTt4sJcIDMLsvOyVhXs3kWA1dP9rBdfrE3LTvkh8oKaqPyla5uTQTKOqoXuD9eBFkAX6yu7oZFWbUdRqNuDdg90Ko8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033871; c=relaxed/simple;
	bh=H9yoZSB/FQak7vZCoTNb9+XfuINk10B3mTlYkTuRrnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b4o/5Qh5sRpOngfEt7LuN23SHCpoBUGEgvWK2LKPMtfosluniN5wq5ojUdULKfM0ruSmDN92F3Nps1TQfUaKfDyseQ11PBAHoEa5v1Qa8+U2OKC1M0mkQcqyPFjxzCczLNW2hcrAXM8R7xuYoS9dln19n6p7rTYS01WyernIUU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HSuHWCEe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZhyqitOr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HSuHWCEe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZhyqitOr"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PAXlWl369450;
	Wed, 25 Feb 2026 15:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qxb48zFszR7Uo94G8PaftFzIWWw4y6QntVuS34pj1lg=; b=
	HSuHWCEe8O5bSLrTLvUC+R6puYn8kOxZ4JR6pPRJ+wmqhUUV5g5jNTkIqBkBGO4s
	cmZyURtIhZ2SHeeTLUsrDwqK4I5S9R3479pTlMZIFr2UvoVtVPItNngcGAumEN0V
	3nw5o8c4lo4yCCg0seeXt+kqsQidb1C5NWUTGI++RHI8lIZyvQ0VqfHrtpQfbkc0
	5Wa2MzSXUwPTRQe6Mv1OCA8pJEozb/gHTPuaGea1P6sNHphFvkGiK+vE906vzEpt
	B9pZP9ORur0irMt/xJb5gByL7Lm8+yPgNcvB/FNFdnxRbu1UW9s6OSRzEcGhgmKF
	sEGBM3iPCBdzVvbVO28wBA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5xdp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PExufx006258;
	Wed, 25 Feb 2026 15:37:32 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35bg9u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:37:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYAHFw3OG7OYKHs+Xj7l7srvEWyhRNu+TZszLn3puAd9/7AR430ci4xrQdlTSeUC6xwg6E+42TIRfL1YgUwvk8QhVhYIAnW0YXBBZkt0To3DqrrfYnWb9sSONcB2wib0/CriWPRLCKseXv48dVdL4Gi67Dwgd7fCl87jRDgmF4RTD5fW0hC5DgQVgmT01o6gLgW8TRGiNG4IynxoCGQ982l4bao56DCrd9RPOI/yQkiYb316Cif9N9hXcZI/ffDyL4k9D8yGWDI1vYY2Qmk8i76GBxJkhvr+jm2dFgnpPIWnkNdHopl4uCazDz5xiEiC1fOQtqbgGW9Nuh5+o972Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxb48zFszR7Uo94G8PaftFzIWWw4y6QntVuS34pj1lg=;
 b=I6Poxej+JmQF0wZ7Qye4bwCxGTupiGZfkKii8t92eooROg8PHrKXGctqp7iFBjezy3q71Ruhqd7nyZyxCsEMy9uxdUCOJfvGcD0BAxLWapfWnmqNLuaz6yUP8oQ6Q7bwnnHMNH/zLmiAavoTBBl3GxDdWh3sNqGhDzcNixT7C9AuOD3bk/D+Tn74JrK5DS0z+RjR9x+VGI/hmG5VEhURhDKFxKPlP/FaFcNlcvzww1vshFJT+vZtOv5E27/tcU1u5knYgEWPBm4v2NkJcfjaEhw5IGWouN/wJPGr3cVNGDOFFBS+0HdhFBX3xoLHlibaoVJhZ5PUKbsyolRl2L0BYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxb48zFszR7Uo94G8PaftFzIWWw4y6QntVuS34pj1lg=;
 b=ZhyqitOrCa+8lHUsIriPXYx8VOVDAKDp9BxEiUdIB7cy9geJT5lLcrdiecCrYq3gq13E7bEHsgJRFhznhKwU9W7owjJrVqa3RCfM6dWNpV4FVRmo+z049l8+WKWresgQwxPr5OYkV4VyhylVzvjIS5vPIYwnlrbu4l5/6Th2wR0=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN2PR10MB4285.namprd10.prod.outlook.com
 (2603:10b6:208:198::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Wed, 25 Feb
 2026 15:37:24 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:37:24 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 20/24] scsi: sd: add sd_mpath_to_disk()
Date: Wed, 25 Feb 2026 15:36:23 +0000
Message-ID: <20260225153627.1032500-21-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153627.1032500-1-john.g.garry@oracle.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN2PR10MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c78adfd-a690-43b7-4bd1-08de7483c5df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	oQdbd0gUIVUC9MPcJY5RCg2LkkcwQ4C4XY6jEI2JtjKH9qxLmmBt9919xhlIdDeLsJmNC6UD175Sz62qnycwGQ6eJ/vHtUjT5nHgOyBT2XEyn5kiEJ53vmAEkkocAZg1EyI/MNow1gsHRoxsU0dzEwJacJC/gWx+gZD3QNpSLZaJQ4hHHWejeNsK59q5BVnLI5UaiGpmc1UP16JJHKBjFkOoS+F/iYjeBvTpEPJJpd/uKhKXDVsxfFcCVERSOyHOblqcreLUA8Y4lNLvJYo//M9cBaJczHLWUGkWtaK+5pHPjFtLkroRJm9IKrWUHnWXgVwtoUtu/cT2IYM7TZYhnvyxJn5DReBghuCfsoczhalDDSOMb5PWGcrsuywBGolT3EQa8e7ireBUM8Ovs0c5P0twlTXCOjyjvAvG3meGNtFaAY21sxppx55VqyauVFW6nIaqbeLF+juVaK9CuQUVx1hdXNGjbmq4sxA+mJfu4dQaYyfx6qL+/eUfpguZEQzVdd6JzN2j2rVWSR8tx9wKRiOinjLJ4Cj4rSDIKN5Puv+gjXMyiGIkTUXzIYiaE7ok6PUbWGMwOn3CSao4FMEqbNPK+S39C5dKRAl2DuqAEvgeyAGJo4N5dKfuRZQbJcwgmnfq6PFJI+wWys+C+QdcDAWHjUv/b/FyokYenZYiRD5WYG9e4G8m8q5ncL1SNsbaxQLKzv2Df8Qn1TD/OAFpyqM+aUgZdmnHytrBlQ4rEus=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3uDWDli1IEmdEL1CkVr4IACqfW8yfBjIrllKxuqbbBso03VuWuPi3MOLOo3A?=
 =?us-ascii?Q?cItsP5YsYRUCQkNCxHROQ8HpzUpU8qqD6YtiXGFHLi15fqsjspsKn77HcX8M?=
 =?us-ascii?Q?me719rGwSJf1Zdbjil6BekVWrA0Jk9hbWFqpvcO/MmGK0JIa1dvVRud0uGth?=
 =?us-ascii?Q?JCforVGmvHg5RyVTSsji57t/+EQilCtsB9y4GB1bj1QGmi+uuGFLfdttwQSM?=
 =?us-ascii?Q?EdJDbSertSVrVv4YRly8gG+DL+kBbmjl8S10WAa16XnL1CeQ+NEDLkQBK3Ij?=
 =?us-ascii?Q?zIQ76Ignf+I2yHGLHYbz9oLGZ6Roheys2kzyiMx0axvdfRX7RXsPHcLu36q0?=
 =?us-ascii?Q?Q+KLSmq1dV8fJhmTp4+H+eJ4BI2bBnUZ6czzXkPpC1GrklQibA+8cmV/tmCZ?=
 =?us-ascii?Q?EGOt4+PynjScinTDg/rb822zsCW8emY6Mp+tyTTCLEl5dYdRx8MY8VCY6nux?=
 =?us-ascii?Q?3y5ltsRKK6J4/p37VMINK2B/xbTTKopbXOAA4NGYzefn4GawUygrb0YXwMgV?=
 =?us-ascii?Q?7bfsvC+wo7rDXzeuF7hGf+53DJ+OZPqaTV/6nl/zwyw4zeRl0QiNsZG/SjA7?=
 =?us-ascii?Q?0/TE+qEaqvfyDGQnwwG2fJE4WX1ciCy8CYEhhk1EXuV/kWGY/oDf7z2vHkAJ?=
 =?us-ascii?Q?q969Npet+VfNqtBT+wzhoVxhbwv9ziwWB5sKmLKbindGyqO3Ymvl7gLPt3bT?=
 =?us-ascii?Q?+s7M08xnHfumYbnP2+GwfP5dIUOF8MMay2UE1/jpeaFoXkzK2sNC1+rtCu3z?=
 =?us-ascii?Q?ZyEmWxeiowqvTYsZy0dp5aHBdTosOV/oYAtQ5f6k4mJx0m41klRamIa8YX/I?=
 =?us-ascii?Q?gPufCMqHdb7HqpwCXxyFBq8DjrhU0CuRfgvSlGTmn9LKHapHrwWFtoARW5Da?=
 =?us-ascii?Q?sdCtCU3Z7hJ/RNSDqOXT+5ikXVj6Zuq/viGrws61N6qXKGHiZ4gdngpmyDs4?=
 =?us-ascii?Q?PeT1OF+sE2xZEy0pvKNojwF9Umi2jmvCFTHcAvglPZ0fB8lMbB1m+s4TjUj5?=
 =?us-ascii?Q?bFjdY5qh2z/D1vvDv2DGPjefkyp+dm0zy9P1Ttc3rRGZk3bKXYQlTDLxx+Zr?=
 =?us-ascii?Q?N4QkNr3EQQ5neaoSGqzeQt6dbxOdDVXN12K/GPj6A5eg9joMYMwYEE+x0HyV?=
 =?us-ascii?Q?gNz7cfVpbwAOZrw9Ll2rCMsod9DqXYojy6JE2S34S2tgczc7jk3bjGp2FrDN?=
 =?us-ascii?Q?6n6NQfF6bHHPVwD2nak60fjYWmWpDKRZOhZVnHg1giUFxuA1/Xp78oOTszIE?=
 =?us-ascii?Q?rF+WyKlIbMsK2ghu1fN0InSovvebLaE7+4T2xzUoZghnEevoedUj8V8fTOiL?=
 =?us-ascii?Q?DR+53kg5GZ6wQadoBFA0P0MhiSRRQ8+Wgup/OwMShJneez+x4FJXcABnY9l1?=
 =?us-ascii?Q?G8VKhv+wwZNorUXODf4JtMUgQGqLgNbrzr6rkXA8D6ddQ/ZqyXdBkFnCWlo6?=
 =?us-ascii?Q?Ia7q+CsxXGmizMqpX3MGJZbD6od006NTmIAWmLMGVmLTEjEalWF+vw1Dm3cc?=
 =?us-ascii?Q?8O2xZfFW+WTUVA6U9yI1hqz9k/wuBklkhCfiDHoKRrz2UxtYHdgAQji7O05G?=
 =?us-ascii?Q?uMeFrSwcPLZ4t9Pci/BUQ0nDNiCO4b3q75y0HjiEHBPN3Z25og8toAhYwv23?=
 =?us-ascii?Q?ckhplITfW81CDceic9xaUtlDVZCH/unu7+2T0XG6Cv/pmC08WP9FRXwTQQYg?=
 =?us-ascii?Q?baPo4BuqJoKUrH9iP7kjRrKueNbt30+Yd8AMGYyhTZhPfw5Jvv4L15qG482H?=
 =?us-ascii?Q?RVWbl08Fa/5XPJFULJ5tl3UdZEbG9Ag=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GYjSV9+4LRMeoDtgEEoULiZyXcjq5hVX5mTiA7wJZY3JJdcn0bG7IQbYa2Hqbj59fXW78i9zGHwu86swHQ+f+d+QoFnJ187PN8yUhZpuU0yt+B/nNjbWfeR2naoUanlXCjxVnLDvYdKN44kJdmRhkBzlYhUZVKn7Ii3PsTk+UG5yK6A1sar+EuHRFmaaw6dw710zqdDVsFlDLsCR75ZakHWqwOBA5/pf3LimM5C6ifB5R5TQGjRCNTI15z6FmH9hwWtxlebTP8TdVLeYZn7H6DgXa+IhZ5nOisC9cAIswf1ySaAOorowWU7o2uLEqrmLPqr6EDgnQUjUsL7YltZPk3iOYHnV3tbtaRG7Q1ZFy/H0WiDc5+P4Fg/hsvefZAfuE+7KB2+kmQL7/aDnTwo2t6nRqkV2pHPXqNNj2XsC7EZydaqLJdaNWBcAOcIdtjRJizEF+p79gd5h3Z+Vdq+Lpn++62um7j0SUBAkMb/uMBQNpHFsl7vzEadQBBgw5pJqYNFnW0Oc4Z19VR6UZr2ryo7jbrKM+PD7dU8CAMIhFOpEV8Fqn/vt6LBQL0zaoxbC4Nem3+K5t6KNPlMyNmjcQ1LixwHbRfZYSGN60PqvVPg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c78adfd-a690-43b7-4bd1-08de7483c5df
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:37:24.4024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdF/V5hO10iyP4HKqdCPXaWo/g6zjOJkmbjTmUqZOgE502FWILZxQX2nGKwm/sQZ8TqJujx2RARfYLI9gsVQYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OSBTYWx0ZWRfX/XJY53UE1nOD
 vqbcSuE7SpXfhuZdij4rnT6vYg5PRzG1tjo/FwgA35pxsJ+qyFY2suyEmVP5f552AVtJX2vMMNj
 fnXNt2kE3hNgZ4zaak9jPFfN4BRXR9YH6n/pi4Ec670Y8D5sHnUwMnQ9RbG47aEhfw0cTZ/uXYN
 CXjtZdzjSGm+OXr2pzBtvM8Vb2eYDuP157FJG8FA/hug8wWv2MO8hYE+Y5Az7ktd6oGA3YgzFjb
 1I1aeqmr/npDn3oTVdbUE7mI0Dp1uLB5z+20uD9ROFnhGYmUtYN9uBr7cWiXAIFHxrYcmzbDTej
 rZ2WV8++bo/FzKG1RPnIiKHMybk6jD8I9VwAD88dWDvCmaT59obIf6z72D9SauYi+of+Lcymf51
 CvY7AoRcEptBmEpdqrPCOuX5rIYISHyImzXP6+l5KYH4JWVcMubjSC6eWIRkAnbb8EK0tlX4uGF
 agOdQ1rO1sCkvyf6WCg==
X-Proofpoint-GUID: KOSYw9myPWKRG4TtGg3ohKSq6ZZ6EGsx
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699f173d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=v5Mwit03CL4gI8pcBxgA:9
X-Proofpoint-ORIG-GUID: KOSYw9myPWKRG4TtGg3ohKSq6ZZ6EGsx

Add a function to find associated mpath_disk for a request.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f94a3b696dcab..9617878b53ec6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4081,6 +4081,14 @@ static int sd_mpath_ioctl(struct scsi_device *sdp, blk_mode_t mode,
 	return sd_ioctl(bdev, mode, cmd, arg);
 }
 
+static struct mpath_disk *sd_mpath_to_disk(struct request *req)
+{
+	struct scsi_disk *sdkp = req->part->bd_disk->private_data;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+
+	return sd_mpath_disk->mpath_disk;
+}
+
 static int sd_mpath_pr_register(struct scsi_device *sdp, u64 old_key,
 			u64 new_key, u32 flags)
 {
@@ -4592,6 +4600,7 @@ static struct scsi_driver sd_template = {
 	.mpath_end_cmd		= sd_mpath_end_command,
 	.mpath_ioctl		= sd_mpath_ioctl,
 	.mpath_pr_ops		= &sd_mpath_pr_ops,
+	.to_mpath_disk		= sd_mpath_to_disk,
 	#endif
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
-- 
2.43.5

