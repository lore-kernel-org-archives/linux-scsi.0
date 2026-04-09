Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7F2175A71;
	Thu,  9 Apr 2026 01:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775699813; cv=fail; b=F5c/hxYOf58Zac0aEJ4QVZ9BPhH3ShxZXA+tZ6uCLwaRAy8eUd2kESYIYPYnEAdFnvtdINgI8smnaBVTCRIjeh0yFH1XUISKTw8GzmSavzTnFcuniNH4xn2G3YxIMOTuhOS5hW/+bdIUSV3Db+m662AGPt6dNfLf9gneBUcek7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775699813; c=relaxed/simple;
	bh=wpu7IjL27oP1MqkUspS+cQu2dWCoOZU87c+Ua+WrD/8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Q4styyBTgUMQmf68a8EGDKIWF8WHrDMJg9GpyNuEiryzrWdN9TP5XEDzjOACeluBfxwEIGx3SJ2Ho+jucafxfztBp2ARMlsANpVHDaDWM9+CRwFpCrg9G6vKRO267mijngSm62NPujM9Cct9KM/I3tHlkRNx46RnlP6+ibsAoJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fuv4tUtm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vKHF1nnG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fuv4tUtm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vKHF1nnG"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638NtaI53249958;
	Thu, 9 Apr 2026 01:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WnY/sUO8GHwM7LNMGx
	DARb6C0s4CtSvzkJe4uxRKCss=; b=fuv4tUtm/hF6NhH+orixApeh7BUcqQUz0W
	bMSDXSC1Z0oJdh7ftXOuPewr+5KXTmwJ2lCudRUt8/mgtvWUagYEfu1l5GNl8RqD
	xBKT4LAaV26F75xNIwSGqVH7SxBcHdAhEpQ/Dz3OLdkQBcXJV8o5Uaqxmn3ZcE7h
	cXPpM/+1SdDd5f225IjIzh9at2uK5Gbx8m1yWitzANKbsESmDH842676uJcpvssB
	RKqy7keToLGuYgcL6k7I+ajWuYvE6eRXikBpKJnyD9BtAaCTJqHsupzL8jpO0f1k
	NVjnRfQVtqcJuujqr17XViezZDNRLpjILXyCy5k9tReeVMblDOZg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqbmvp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 01:56:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6390Or6j026155;
	Thu, 9 Apr 2026 01:56:44 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmec26d0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 01:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rj0tx+M84Qardq7XQ0fadRG6J0c39UOcIDln+PUbqb7Xvxz2kn2Y6zzv5EXdig5bRd/p/13lHV9SCrp6cm4jvupXIBBPB+MunUpAl/0BwhJRzbkFQnwscQsGIcPt8PUCphEGouIZ8FHPRI0fk75crQBT03iSk5cov+vxrYHPw/HWUHS/iIcJJ8E9Tfd33VlPGl+eNWAMu2xmQItkgKFVCCSVMfThm6WnbvhN1xTu2T/I4rsO2FE9U/KUC0qg1C10+QhgVMvBPs7B0GUs3vL3Voinij6e/tJ25zuzizxVHvr20r2T/L/8VeQbVMLj0vcfpPr1JjIWLV8CcaCpEuWIoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnY/sUO8GHwM7LNMGxDARb6C0s4CtSvzkJe4uxRKCss=;
 b=kBMBFSQNAaI4yKxkeDbRldJfaA7NerCNSn9UZheKbPXK2Qg1I6ESecYdJ71l1HxY1dexVe6AY3fi+M6RieGBrHqH+Hm/MKUg0VKKCc44u7VTW1azmVRsOw0ZCdR8vouazjBkNDgRzsJXgFT3uLKYM0BQWC7RNyeOloF9noD8RHGyorXCksoBngLQS7KsCPpWsAoWkRXbYMxE2t9W6M2p1ooj4jijjfqU7mJf11b59fB9h96QAYUKHALP+IT9drtdZYsg5y7kONB7C+YNe1Rju/eruvXH2PJGGajvFUS/ZRoMJ3wtjmICQ9HRjox541DuIah83bnH/ieHs6T2WQAt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnY/sUO8GHwM7LNMGxDARb6C0s4CtSvzkJe4uxRKCss=;
 b=vKHF1nnGIVwj6/eNGsEC6CRJ26J+Q/BFUKUjzh/HCOt6/4Cr64clReRyE1QLjr6bmwyhPqDx/bCUcAhZFWsBL0KybceyL9kg70aFE0hRWfqgx2Jl/j3T2AoUlcROYYfLcaju4boVpiBkWlrt/UTJwoT9xm7Y+vPoZFX97khdiTo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB5770.namprd10.prod.outlook.com (2603:10b6:510:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 01:56:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 01:56:40 +0000
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Delete unused to_dom_device() and
 to_dev_attr()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260408-libsas-cleanup-v1-1-826325bbc0ba@weissschuh.net>
	("Thomas =?utf-8?Q?Wei=C3=9Fschuh=22's?= message of "Wed, 08 Apr 2026
 20:28:00 +0200")
Organization: Oracle Corporation
Message-ID: <yq1se94yjzl.fsf@ca-mkp.ca.oracle.com>
References: <20260408-libsas-cleanup-v1-1-826325bbc0ba@weissschuh.net>
Date: Wed, 08 Apr 2026 21:56:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0037.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB5770:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f32f54b-4c98-485b-0ba7-08de95db3e13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	x5RbQob8SqxwZLleXn5IYLk9Vx9+NSVtwm4IrTUr52nKpKeV73quLBeFy0iDCh2pZcHpYG6Ex/sA6igKzXzkT+g0IjRcngjWgDR/P0VULofP32Cdfn9DEaD89lXahSeMdlKHFTC/YbIIjBx565QlN8KcLM4flz6St0Olf+jUv5MkUXf1+2gBr5xGrV+gzXUXYjKfn7tRh4H30aebgk7yDDAGYYLjbLm+FIY9aD+6Yp2TeEwFQVWM7OZovrqhugdDhZ7FQGFcXPwDGgfWzB2zwbkZix2MNxIhF40eh76J/u+loHvyqLGL9frPOp2NbG3Bq9u6WnZ0gzusAeW5BWPgBgk+dpbEG804bloQ+swAfLmIw5ylWg6mfnfy+CY7vEPpCOZSEasdDFqgP1y6BPOjL3Os0d542VRt0jipK5icT/pb9kbURuZNUbfiCGO+M3+RNybf5p1eVNdJIfsxF7XWnP83a1qqxjC6w5YUxvwrzX3xqF4ALeuKEs/hKb2c/eA9KdJVqiufIG6uT05ZrrDN15RSim0W1gUdWwN78dsQR/t4q4PwZcm7F2sog6k+6Mk+GqbERoY/XhD9tP0MULnRWcs0H5WOwiOAksyh9ZDlCJG1Edwxf8qIqF2VivftM00zAZqif6OFOleqiu9hc9DpgqJbE8p/KXXUNQ1nVQ1eX7dyCbz0TKZtkSL24Akn0ompW98QJFv1unSHowZCuJ60GaKdWDksesUMSXLsBlkk3DY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xb5QnibshbH9bFNaZsTLEmfgdfZGXtTqVRH7zNcWr4CZxq0O6nrXtGepvfKw?=
 =?us-ascii?Q?GNUXt6MpI8NOD+NPnnyuAc7AABhZ58qmrgHqpkrJ6BMac03xZAeTgrhcPQv9?=
 =?us-ascii?Q?D7h/BX1HESKtHvfENdSYnWDjAfxuGHMIxEBHQ8taTneDU5TwQDaYanozJbWD?=
 =?us-ascii?Q?4UDQ2fRysEdOCYV2G5xqW6iFlmUdyb51SURZD10cDVKwGoALY2ogrToy1nAk?=
 =?us-ascii?Q?oCtrjX90slbDvUeOJ1HdY8bF7mdow2C3Kplbdp4mlu6snDv4WT4/7C1iCA9p?=
 =?us-ascii?Q?SaoyZIzv6qq+/uly4JrE+lKPh0IFgETcJmaV/D232uh3m6DDlOrMN4+/Abt6?=
 =?us-ascii?Q?NfvMXIL6X6b1Kk3AKlmFw6SkG0s0xGG9JLDuNjxdQCEWCfs8gNRsp+gg7UK6?=
 =?us-ascii?Q?Sl+f1X/BGK50QesmNjcIaMytnwi59M/wk0qx535fI0nR7zTJDETCl2auePyS?=
 =?us-ascii?Q?dM+fSqAnhSr5MOP+G/k2IyBVe20w024sqZp2MmN6QSNTF3AzS82WCowFiphn?=
 =?us-ascii?Q?LeQUJuj+Jmr/2ZxGGaOLI28lSFY+BiVhCpFXvZmw00ml2Y6Cr4gdnHGl+gqa?=
 =?us-ascii?Q?JRHcJITYxVwMJAcXdUYGwElQkO38N83zQJjIriaPPOW5BkSwyK1i9+NNdmcl?=
 =?us-ascii?Q?nQ56/+FHTzb0MEuV5f+q/fHgtrHq8osmaFYm8nsaZw0jdSkownxKN+E5P654?=
 =?us-ascii?Q?15mPInJB3uWzZhdyP3lJYa9wLhXGxbT45pJJfOa0Fx7vzEZXTkWN5MbgnF3/?=
 =?us-ascii?Q?6kamX5Q4jKLKVJtAPvXy6xumwWQ+gv3qYUyUQafefPCdrxMaFvW0Gh5HlUw0?=
 =?us-ascii?Q?ufDxwwU0Yp7XekyBbilh/VYuwQHjZAWtlT4qfh8ecErN20CBoum7qFhvIeP2?=
 =?us-ascii?Q?VmtZqNxGbdei4jufFWZH6I+p2Bg1W3IDhmN/IaiuSTqxAhb2bc3S0LfYoRp1?=
 =?us-ascii?Q?YH9Vorl3zhhlPTWiFm7rKHP7B5jBNP6lccP3S6cvWfsUV2zWPEtQJoVlxt8y?=
 =?us-ascii?Q?V0rn/dWuIAwlKmKJ4SjAI9KPwMsVDVTdXR80rbpq5JRynOKMeX9wxUAI7bQU?=
 =?us-ascii?Q?8Xbff7mSWxpMtHcex2kafC9lZ2QsihEIc0h1YiocHixWwFZxIHxlCjMh1d5o?=
 =?us-ascii?Q?atB+E1eGYMknfC+v1kf7vyJH89zSrTbYKXpbuv+kjFQPlkPISB3l3lGfpjVG?=
 =?us-ascii?Q?BGOlfgL3cyY/OrHcU1KgUkSdVCThIigzycJvO0CRNTEY1UfVc5V5OT0aqroh?=
 =?us-ascii?Q?2cP6eK6qZDowPTrHOat60cEU0Qhk5NR/IkCDU6o8yrS8jJqwJYKMECh4xvRx?=
 =?us-ascii?Q?FNqRsMlgzw/TiCkab+OHSCbhmu3REY+EeJYPmxc3uizTDDl6fdWgShxhP15W?=
 =?us-ascii?Q?S1ESQ52IDAg0PXNvLaTTxpIMJtnXp6QmU/FiCJRmq2li6U9tt7Sa7KZerCT3?=
 =?us-ascii?Q?frKhl2pQWDVS+ZUvg9z882xS1S+3Qhr8Zt3B58Nsg/1btQShlrGfpMKFdufm?=
 =?us-ascii?Q?n77ltH8Vl4fMAIM/k6R3DahOtyVR1+P40CvzeUddyRH9ijgokNfqiltMpRQs?=
 =?us-ascii?Q?oF14ezMu/7CpKzopdqNl2BeDK7wPtz2tzRE3hzwVpJZIu1VvhN3u05Y00mAy?=
 =?us-ascii?Q?9mFQcH8ZQCgn8okhgHfXuAhfJsTtvpGGfxakk0xG0FNjhYhrNNcDYV7TB9uk?=
 =?us-ascii?Q?97boJ/pb8SrR3WeEux9s5OWBL3QtqGf8D0ez7btuIyL2QvRexrW1PN4buRBD?=
 =?us-ascii?Q?oqJuCVzeCliCwtrYRS5oCn6k24CDzHU=3D?=
X-Exchange-RoutingPolicyChecked:
	bgLjiVxjajw97igi3ejLayFvduLyYTxi7TV1pZmeG/uC2G1iPO9Tjmls9hEKJf99UsuC8RH4vtJaQ/nnz8Fgq7qBJqaw68Q9zkvsY5m8TmWsAXuR/3i7z99+TLtW5bvs19ECeG2188QLL3TVMfRMSeuSoaz1VOlO/algOB06QmASCFRuEVHTmhwcdWue4fzRFP87NnxtWCQpkN/NOuo70qipsBG2OZlUvUCDQqEhyREkrmy0rqn96+rwR+n52+wsUhZm098j5p6pEo4FB3eFG39cGBdRgrZG59HgL8RRPJKRC71f0FgBL1DGVPY+ZPOMm7w7bAY8yk0Z/T21alO2Og==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YBI0O+ajDDh8dsBzS3vY30erIPxr4xYKAyXplL+mzzRctj+w1Y+vol0M7xYW5/tVzYpW+S9AxAWdcJTbLpOwM7DIvWtVReUHlaPkOuPXOxQaoy98RcSv/bzLHxyKewSHAqskRWSPPXRHvD8ceVIgE5cABFZvMFzLnDC6TpvgaXzTc39Uje0rDj3eHN3wLr4qlCE3QeTSXnI0jVf8YpLtshojmW7hIy74ecvy83OppK0/Hahaml3ewI6hILIOTdUWARGWi6BCSAdDM+Cs3CziUrz4SlU5NnkHg60iGvMKqO8Jdy70DimOlkH7HSigb00nsQrbZaSuLa0FspbqNVKsXgs8xec0V9r8F3Kv9IDnSCotQQEurt4wXUWwbGs9dhWukmn8p/U17kTNSCFIyAJ9GTiP2TTPfjC/XMa5Qg6xKpACUjmogIjocrVdVEbMM67X2jXQBk0Zbtr6coFKdEhH/iLFj44KDXuqRnrngcczMp4SKii7mmb9IfEu5XzaKedWwmRRVulgHlAKWTFyCIc6RAOOHj/FcfiqA57yGeqXvemaMmqbriANvPnhEWiX5/7GfrF3I0U+KKP/M5U5KH4lrHnsA1teALOtUm0h8o4bmHY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f32f54b-4c98-485b-0ba7-08de95db3e13
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 01:56:40.5959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Myz7FVPM33D6Bc3KJugAe+P2rNS/TMzhAOWEp4yj9BhdWj8bTlyqOE8iDyEKlVU4CpujvLDXqJMgFOp1jdxLgHP++u8dbH5oofuD7gCh+bI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 mlxlogscore=861 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAxNSBTYWx0ZWRfX7J0ZUW+APwBR
 e9PMeMi2w/5Z0sKeVyRMG1tOW44b9Ir/lgrj0NozV/oPkTosqHfw7MngwjOG3e+qgo1rgc7pAOk
 hR0bUmyuEki67IotRM2IOOjW1EIBAomc8LBJjZUzwxxJLPuuHypzQGbzosZm4aA4G7AGPmv8Z5c
 ddH7nSVgG/NuXy6Vv7TFQU8HtjxC7q4ymY5CIaNFDzPNAdtJ0v2iAUl5Cg5mPCEbUPjLyTR5OD6
 lm6gn61SoOdfW25X1BF6DZikSBuUUzCdggMai/huaehjowWH7iwpzF+9uicA8PqhDyQcTulBG+h
 ORGAqKNzZKJn2mSqlcU1EIsk1okgUXFNLy1RjPXX5auyfudIkcd9B2fuf4ekUymRjoVg2EnEFUs
 GVI3oDqdmfBmP/KKRUKWzQC3P4ocK0ohYKZoQphv8gI9M10PdRM6JbOf0U8mW5JNIIOplicInHa
 7qD3LMHyZFzo3x9jcDVUu+/9e72YcDHVtFvE5mPw=
X-Proofpoint-ORIG-GUID: c9bsEvoYXB5plECofyH5kKGr-ASayeOB
X-Proofpoint-GUID: c9bsEvoYXB5plECofyH5kKGr-ASayeOB
X-Authority-Analysis: v=2.4 cv=KO1qylFo c=1 sm=1 tr=0 ts=69d7075c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=anrGc2dYs3bqXeueZeAA:9 cc=ntf awl=host:12292


Thomas,

> These macros are unused and to_dev_attr() will conflict with an
> upcoming centralization of general attribute macros.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
