Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820C73BD224;
	Tue, 17 Mar 2026 12:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773749276; cv=fail; b=B9rPx2E9hu9xJLuds1vIsfjZ51ePpblyHhQsSa7wPvJdUVJJWcnMhNv8HyNZ+OAhfr4jBb1AOrWix3xqRXlBNt2PSYvezIJp6NZqzt7DwDmvzPsnMFR6qET0HwM2U28Rfyxh3HcMVHNsQK6iSbwcjo8tRJj4hDjrA7GSDbD4I5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773749276; c=relaxed/simple;
	bh=R62RqGzE5Tjw6GAX3I9yVAdzQCRzDV6WV/ZchLoNr0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u0ONsEjgw60ps5YS4ZBlnjgPpz4cH+YbNTo5gn39yPFBroCwrYP9eKpVX49Y0JvOweMv1ACzGmRG8oapfaTzRv4pMip/K6xSGm25oHlBg0r2Y6bpVogLhL5+kPb+PDcDGurLlj1iCM4m/0DkT6rjC5S4tFafO6iu3jJAP+yJd2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a4J2WBrY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C01k+bI6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a4J2WBrY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C01k+bI6"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GLZkUr1061276;
	Tue, 17 Mar 2026 12:07:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+14gFPWhSSY6JLjHH4UJzAFhFa4yDEUuwhjPlF/9PE0=; b=
	a4J2WBrYALMh/A6DMPPhRalDnZ1hpoMYqRZCvGWAaZTptc4t4Z3KOKTKGzLuOWG7
	eCU07rZ1GDPLsMl9jaY0WF7UXyWW7aEFGaHmAn5tqS+3iUln9rCOxaBXz2VeHfMp
	0/nmA9XRygeKLLwTB5BzB3SYHgPwpd7pASzajaEbTmanu1vDD8o5AjQtlMn5EVCS
	rAkjYvR4MyzxnW08/yZPUZ3GejXpNa5F+zYEm0j4T0HzVVrbMFyOS+9UVN/AqBYD
	nwaT1t7/0fd3fqcVqsMHq/cJw+rD9DyGm0oTK/3CdDWcxgNfddRxW5Y73CiSvRer
	E9Lg5IKQnVcLgBX+Stxz8w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvy9rux09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62HBvIOk017825;
	Tue, 17 Mar 2026 12:07:45 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011027.outbound.protection.outlook.com [52.101.52.27])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4mh2a3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Mar 2026 12:07:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LjxySUYNKuQzjS++xi5IWK/sqBog9FnnBem/JzjoqHAYrl1Uz28PtKtItmH4bGUMRY8f01b2MTwSAUg918CdCo8L5EjR07+Bz/uFsvmWv366wvzcWbXYbZucEfvkrlCGbhE9YVXXOTlkSeibGfd+v8T9VkdlhiEfKUTpADFKkH9DzntnF2p/FSpmf9UxrLwpr0RMGEk8dEpDN3xX5oEVqzCu3Zp/H8BV+JNVaVa5NnUYfU2qc3Q6A5Lm9ok2tHw8Z/m7k19kP1NFJMf8EIJSbkJjyOF+DYNg0g9+TboKziVWBCT5VmSK44bZUl+rqRLypDjsqCxekjJ/CE3QRmTs3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+14gFPWhSSY6JLjHH4UJzAFhFa4yDEUuwhjPlF/9PE0=;
 b=BWE8BVD6u5aTVlkUhYdP8y/OxBVD3BI2bGspeuHzBR9Oo8kTtSxYADH9YbmAf5OG/mFaPj7LbkEJH2HRLqfveRB9L2VZqH3jERGpU/Bk7dywPID+SOF8qywqGHKZz/6reG4ToVTdRSBKRY8VXU4A+l/3xVxNKka9pvM8aUqQUpDt3d3W11JK1CARFtqFTOk9xnQc3O7vwCVlRgk1vH5RQXTomJkuGAx9oaodTx+ORfAfjG9LNZKbOh2XZQqq/rodD72tw42BnyOUbKlxkRxJyPTn+tdUZoFraV6spjD87OQzaL7gFH7SfF+C3+Ks1QnKqVZAnrF6edH30m2k4mDsfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+14gFPWhSSY6JLjHH4UJzAFhFa4yDEUuwhjPlF/9PE0=;
 b=C01k+bI6z3u78kBoYQpv+YB+6wo3a5cMOr5ODDDfKjbp/zRGD1MqwL0wOE3E4d2ySWIkwc/sU1AoD23HOA9RZKshNUkcGFQafH9LUWRHzg+L5el1znK734lq51hZlrNK/+DqCWBHgCEKFgHSWN0oaa/mAHyNLS1uXl36LOLnx5Q=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5976.namprd10.prod.outlook.com
 (2603:10b6:8:9c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Tue, 17 Mar
 2026 12:07:41 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Tue, 17 Mar 2026
 12:07:40 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 12/13] scsi: scsi_dh_alua: Switch to use core support
Date: Tue, 17 Mar 2026 12:07:02 +0000
Message-ID: <20260317120703.3702387-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260317120703.3702387-1-john.g.garry@oracle.com>
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0060.namprd17.prod.outlook.com
 (2603:10b6:510:325::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c773524-38c5-42bb-a8c3-08de841dc9b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bXtfspgtOq01qq99weMV836kclvbyTTmiSdvs0fnqqKrPhMxNE0nGHHmK4rJtIX2UEMyhXY+iV2rCkrAuvyqkjptF1W8TLGankWo9zLQKaH5L4HdmIgqbMgDMRW7Fq1kGxbfCqqbD2nvBAUllERv2dXDJM9du9pE2rs8iojjDo44JsDYq9fGMpXHGnmE+TeMUucbGADOeiKzKOxlTvFV3DwdUY3K34Q/QZNdFbIkfcJJmY1UUD6bR/klEtpYD2eyv2Ojn0GEcu4JvFkQ8BX0E3mg12XhpsP2+3ZHdFy66Uz4EGBT3gwKoJPSMOz+YDCaxHdHTwRkCSIGIZvOXbBkNojch4QtBTk2pOshPMoISRxIve5ixQln/4HsDT7W11RoSOaXr/IfKZ7Y5v3EzUzi52CAc5hAXp8SUwESmRvoNxpLjPNBbcMMCTxYliVSjCOL3RazN1rakfDwLtn7UyXvQyXPO18Yec9AeTSXGvg+CjwzgVZWcduRaQyNl5ZdlAjvGWc//k8uMhZZh7fjvaI23GQKpZywez7RMMaz96MM09sTKP+oRRL9no4lCZGqorLbLdz3hXFJFddjODOYVeXX0uasJEAPMyEl/svk8T38pV3i+B/LDle2uWdtXWGIJk5NiQY7doCoclXDaP1chGn0vsG7mbYbWwPTbHUFxkapkn2tczPzD0lKg3cfIhySlT0eb7+tWdFKjpvIZ+pImaeR1vUrSMva7HTpuH89In5Mo+s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lOkHeOu0m1ifei0Oy0PCgtq4ZY7y6Tw3JsONbPOrE1hwQ7NVARStKCVyfVF/?=
 =?us-ascii?Q?ODraw2rhvWPyYaXqicHga63hvG+1D1v4hk6br++M1KQfRf3X1yxZrQrXfhS3?=
 =?us-ascii?Q?Wl2iuzYTppa8yjBG6RIIdu0BhFCdXzc6iIBDgZE50/X0S6uNfiwr9MsSsb8s?=
 =?us-ascii?Q?Twk9aUY0bufJNqGqm2+W0Px5kv0PKYAZ0B7A5ignyMuRzC4pkRj6RXRUG9TI?=
 =?us-ascii?Q?qnO4NG1XKKSLiuEmzuQkJ6/56XwCeE+qyoorwn23PEi8zay32ngjpyWcJw3W?=
 =?us-ascii?Q?RW6XF2djsoSDH9ZsrxgEni47Z6mRBFma6kpn4oVs6rrqB8IkUpCjDtIDJD76?=
 =?us-ascii?Q?dzmxEWnPAHkt1Sykb2wWKR07/dok5hBA2kXz4v9U1+iYIB5d5jYzwS2IkkCI?=
 =?us-ascii?Q?yXfGJzfENSH0bntDZ7ZswXZStdMwIczFEnxPlZKo5d6C/5ehMZAvl6teU/Bl?=
 =?us-ascii?Q?oWUauDDd1e+pzPs+YMRLebY3Ye4c1il5Ti30vF2FAV68SR0CY4byi6kTKJP6?=
 =?us-ascii?Q?hnfVmny9gIsJA5zcXacQX9HoY6CBwGmSDqh6vA5S6cQIKM1PC/s7qbCXSakL?=
 =?us-ascii?Q?bJ2iYplX9Y0AjAvvBOoH/SuAGKYwQmS+t7pv7VnMHDdxSEwmae5H9lifggYo?=
 =?us-ascii?Q?pyTuSvYhDx5O+CUVlJGp/JCjYRFzVtJNWIcCzhb1Oz73/XNdqHiKNFfw8s4m?=
 =?us-ascii?Q?TE4WMeLkq67dA6kVEAePYEMqnoDbIrxOTnZSJwSUzk6wWRm1TGobYzh7A/In?=
 =?us-ascii?Q?GRoS1aYIlsoqq77iIWlct+cMXnei4UnTsoFRJbpQA4RaPQFKb9n6ZhNRsKlZ?=
 =?us-ascii?Q?IHeqvZHQMVpjog/kIb7khSEumrIKSUO1r99os4tlqwuKKoetgXyRCFFIfcQs?=
 =?us-ascii?Q?3vDud3kLImz3iMnSLdsApSyoT54bWR5dHPULPHCarRjob/5B0joz3fJK3F2O?=
 =?us-ascii?Q?B243FK2WO+z7PdSXpsYOkgk6Q4V7Sx2vCYkUpVAwIL9pHbbPlJeoCGewfM4H?=
 =?us-ascii?Q?MtBe2guytA5bizy2MtWtGsrXr2KK/W4ORTA0jULVfw/vQM7HYF1SPebteZS/?=
 =?us-ascii?Q?bwj2bfliCTp/YS5KeAus7iUA9DxsXhyfA0HOWsWH7/qV6sDbZ4iD6Mp5sStW?=
 =?us-ascii?Q?axJYpuIJWCS9YoyS0jotB2R/zrlRkMZ+UeFWq9syZhueMc9POwuSsKo9ssoP?=
 =?us-ascii?Q?dXOqpF8sY513PslANG5KXS0liwdTAJaMyvvG8cMCxXHM4lFFKYMjMfmGvpk1?=
 =?us-ascii?Q?PclCfkbkfCKjcOEc2DVw9ck+1aku79hWKlEkXXAQi4b0yXVmesEFWDgKeZgT?=
 =?us-ascii?Q?2/xPClqgh2SVOnGWRNOYu6YSPlKNe/bZgslMpo2sWXSRB6ZIHmOVxL6yrq1z?=
 =?us-ascii?Q?wonThfDqlBue2O5klGgygtIHNtJyPuKWPX8CvqzIbBgYBQtPaCNnP5GqYPgJ?=
 =?us-ascii?Q?t9CREqmGpIl6iraCBuAkJyApwWk2IpziRes2uRYdKGzziUEbbvSWFyVNR9ct?=
 =?us-ascii?Q?DfOmZbSJX0XHfWwWxN5AWx3+6LS/6epO81k9spwK7D48AppsTJ/9FvU89FG+?=
 =?us-ascii?Q?J0SZ7DkZt+xQ5R5RaMM6WfshsE8vbYTNeaFnTxiMiaHqAO+F67w74PVxvrpD?=
 =?us-ascii?Q?OFJRKJVYQJjDgF3jA3+0X46r6GfnWRf4Iw6Mh4bgiNXiRQTs8BSSbOnW9iqk?=
 =?us-ascii?Q?huQmrgcsXuMUriVMkqf0zkhpEhin9h33T4KluY0HSvwg7TcZv/p3+G4mhv77?=
 =?us-ascii?Q?7FoHBH0KDw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	uX7aKL3frYU404wUQSyGWfiiaV05VAPtKrB5OJtTJvoe+SO/foROdO6iWEWz48HcEu+fnIZyARCjg4kL1AzxlCtBC1APHNgIiFfMpLzp1qhHHlO5fWjGiUR0K2NWAT/2KQi5XsY/PoiawT940t/ZbNAFN3tdTSFf6h8wH7pGwFGPDF0k6owYortU1HXdFxoXIuvwCAHoQ6WpY9459JNrDKld4yWbQ0pYM1yrigmiua+1BVngG9pP1XjxdAb9MBQs3e1KQosi48b+DATtl1zN1NSEMYqclhHiHXWJyx4+fXqKzRFumrKqPE6KEWf5a+wLQEThS1lCVNKv8YBo8jFvSA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G10JxuTS83UyOk8KUaH30lrVIZhAqoIquxbQV+WwDnCo0BHtJ5Y3REmvnSc2gwgVhoEx2j0oswNFl17vwURbQYLEbYMaYuCMv8qZVTKUNfD+Hgy5ucG4RST0tOIZrODlU9IfeUP7c3FPwFdSsANEQl1okfSvUTX9+hm8avsgi0rkCFcjbg900jWlFej+66RZUSg4SIvJSba4v577pslDRaTQIDkDZJiNodqfJLNwfu2EanAZ6gW2IyxfLm3i8bEH8QQaBCDhZwIrWWZyJ7bZgcJBnBWFGmr5G++TslVkWzoPsMciq+FWN2B9D+tYNB7aQRp6XL1Kxw/0KAYR+MtR1hxz3ClQ/rjEkSENC4ea32lPpMHlPEOPW+7ADQ/n0ntM5lBAaQhVH3VL0M9E2BKJEwKA6c0RkeKt+FprPKERzt78rePLYco7hOuqSUBc+RZBeSNp8HKn/WUMRGWdxDlLMMaPtqgMYujGOLNbTOWaldZ+I/LIcHpulQmfWzVqybDwh0cMMaDif46vJNpdYAoNue+BRcWGspHzm0Kr76wTWkt3Vhsr7nbZZq2cCr+4amsk+rv5hPUCutHm2/nWF1qZwnbUdcCV4yFDYIkqUuaHjuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c773524-38c5-42bb-a8c3-08de841dc9b9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 12:07:40.8590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nJ60GfxjqU0nz9oG0XcmPv+vR9Wbb5kOQo2z7/KeIaQ0lhthSHj1/UCrgP4lwjUzNSqVzS4MVGa2EyNw55DwTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603170107
X-Authority-Analysis: v=2.4 cv=X5Vf6WTe c=1 sm=1 tr=0 ts=69b94411 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=O3QGT2ws4lNaYII34bUA:9 cc=ntf
 awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEwNyBTYWx0ZWRfX3Ju7+FZcoG4/
 VzWZuUyR1zbrF7Jp1GFVYewwJOdzVSWz6DD3YpILE9oEjGLqEdrwwXF0WO4omjYroXkA08BHcX4
 2IpDnb+VbOT1y+U2hgwuk5L9/56/SOxPoxVPY+8a5K8MCX9dKlCvq69qKA3oHyA0Oj3uS7DHNdk
 Q7VHW5yLdAruWC2HckXFt0MUhNabk/sv31Ghah5Bj5d9jkvfkhJ16Eqf5czHubuQnBVyVREZtMh
 86OqTuwDwGEbsSUDNb9N5Ls4LvGPsCCfFhsqOY3HRXLjIkkjVY3fCGuUzbVbgk+MTOAnpWd5wMh
 0KpwqGRpRjUU9TWtBh/zv2iu3J4uAht1b43GlZ6Dy+SPd9xfL4f8eE0IxjZ0S48EDY+ecgjZUBa
 Utw0JhbVQVjySXDRhFQHer+9MRJXTJMJAmMy2kBLEo6WzZavikcKJMeN2mke8JbODaadw3Up5GW
 ZoBK1COORvHpwHKT3vF5g9qyDr71fp/fKLxQe/RE=
X-Proofpoint-GUID: YOv_RkM-8BiPYFy5EM3pTTM3itl05yWP
X-Proofpoint-ORIG-GUID: YOv_RkM-8BiPYFy5EM3pTTM3itl05yWP

Switch to use core scsi ALUA support.

We still need to drive the state machine for explicit ALUA.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 580 +--------------------
 1 file changed, 21 insertions(+), 559 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 067021fffc16f..4d53fab85a7ed 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/unaligned.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_proto.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
@@ -44,7 +45,6 @@
 
 /* device handler flags */
 #define ALUA_OPTIMIZE_STPG		0x01
-#define ALUA_RTPG_EXT_HDR_UNSUPP	0x02
 /* State machine flags */
 #define ALUA_PG_RUN_RTPG		0x10
 #define ALUA_PG_RUN_STPG		0x20
@@ -65,14 +65,6 @@ struct alua_dh_data {
 	unsigned		flags; /* used for optimizing STPG */
 	spinlock_t		lock;
 
-	/* alua stuff */
-	int			state;
-	int			pref;
-	int			valid_states;
-	int			tpgs;
-	unsigned char		transition_tmo;
-	unsigned long		expiry;
-	unsigned long		interval;
 	struct delayed_work	rtpg_work;
 	struct list_head	rtpg_list;
 };
@@ -91,121 +83,6 @@ static bool alua_rtpg_queue(struct scsi_device *sdev,
 			    struct alua_queue_data *qdata, bool force);
 static void alua_check(struct scsi_device *sdev, bool force);
 
-/*
- * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
- * @sdev: sdev the command should be sent to
- */
-static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
-{
-	u8 cdb[MAX_COMMAND_SIZE];
-	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
-				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = sshdr,
-	};
-
-	/* Prepare the command. */
-	memset(cdb, 0x0, MAX_COMMAND_SIZE);
-	cdb[0] = MAINTENANCE_IN;
-	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
-		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
-	else
-		cdb[1] = MI_REPORT_TARGET_PGS;
-	put_unaligned_be32(bufflen, &cdb[6]);
-
-	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
-				ALUA_FAILOVER_TIMEOUT * HZ,
-				ALUA_FAILOVER_RETRIES, &exec_args);
-}
-
-/*
- * submit_stpg - Issue a SET TARGET PORT GROUP command
- *
- * Currently we're only setting the current target port group state
- * to 'active/optimized' and let the array firmware figure out
- * the states of the remaining groups.
- */
-static int submit_stpg(struct scsi_device *sdev, int group_id,
-		       struct scsi_sense_hdr *sshdr)
-{
-	u8 cdb[MAX_COMMAND_SIZE];
-	unsigned char stpg_data[8];
-	int stpg_len = 8;
-	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
-				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = sshdr,
-	};
-
-	/* Prepare the data buffer */
-	memset(stpg_data, 0, stpg_len);
-	stpg_data[4] = SCSI_ACCESS_STATE_OPTIMAL;
-	put_unaligned_be16(group_id, &stpg_data[6]);
-
-	/* Prepare the command. */
-	memset(cdb, 0x0, MAX_COMMAND_SIZE);
-	cdb[0] = MAINTENANCE_OUT;
-	cdb[1] = MO_SET_TARGET_PGS;
-	put_unaligned_be32(stpg_len, &cdb[6]);
-
-	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
-				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
-				ALUA_FAILOVER_RETRIES, &exec_args);
-}
-
-/*
- * alua_check_tpgs - Evaluate TPGS setting
- * @sdev: device to be checked
- *
- * Examine the TPGS setting of the sdev to find out if ALUA
- * is supported.
- */
-static int alua_check_tpgs(struct scsi_device *sdev)
-{
-	int tpgs = TPGS_MODE_NONE;
-
-	/*
-	 * ALUA support for non-disk devices is fraught with
-	 * difficulties, so disable it for now.
-	 */
-	if (sdev->type != TYPE_DISK) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: disable for non-disk devices\n",
-			    ALUA_DH_NAME);
-		return tpgs;
-	}
-
-	tpgs = scsi_device_tpgs(sdev);
-	switch (tpgs) {
-	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: supports implicit and explicit TPGS\n",
-			    ALUA_DH_NAME);
-		break;
-	case TPGS_MODE_EXPLICIT:
-		sdev_printk(KERN_INFO, sdev, "%s: supports explicit TPGS\n",
-			    ALUA_DH_NAME);
-		break;
-	case TPGS_MODE_IMPLICIT:
-		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
-			    ALUA_DH_NAME);
-		break;
-	case TPGS_MODE_NONE:
-		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
-			    ALUA_DH_NAME);
-		break;
-	default:
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: unsupported TPGS setting %d\n",
-			    ALUA_DH_NAME, tpgs);
-		tpgs = TPGS_MODE_NONE;
-		break;
-	}
-
-	return tpgs;
-}
-
 /*
  * alua_check_vpd - Evaluate INQUIRY vpd page 0x83
  * @sdev: device to be checked
@@ -216,56 +93,11 @@ static int alua_check_tpgs(struct scsi_device *sdev)
 static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
 			  int tpgs)
 {
-	int rel_port = -1;
-
-	h->group_id = scsi_vpd_tpg_id(sdev, &rel_port);
-	if (h->group_id < 0) {
-		/*
-		 * Internal error; TPGS supported but required
-		 * VPD identification descriptors not present.
-		 * Disable ALUA support
-		 */
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: No target port descriptors found\n",
-			    ALUA_DH_NAME);
-		return SCSI_DH_DEV_UNSUPP;
-	}
-	h->tpgs = tpgs;
-
 	alua_rtpg_queue(sdev, NULL, true);
 
 	return SCSI_DH_OK;
 }
 
-static char print_alua_state(unsigned char state)
-{
-	switch (state) {
-	case SCSI_ACCESS_STATE_OPTIMAL:
-		return 'A';
-	case SCSI_ACCESS_STATE_ACTIVE:
-		return 'N';
-	case SCSI_ACCESS_STATE_STANDBY:
-		return 'S';
-	case SCSI_ACCESS_STATE_UNAVAILABLE:
-		return 'U';
-	case SCSI_ACCESS_STATE_LBA:
-		return 'L';
-	case SCSI_ACCESS_STATE_OFFLINE:
-		return 'O';
-	case SCSI_ACCESS_STATE_TRANSITIONING:
-		return 'T';
-	default:
-		return 'X';
-	}
-}
-
-static void alua_handle_state_transition(struct scsi_device *sdev)
-{
-	struct alua_dh_data *h = sdev->handler_data;
-
-	h->state = SCSI_ACCESS_STATE_TRANSITIONING;
-}
-
 static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 					      struct scsi_sense_hdr *sense_hdr)
 {
@@ -275,7 +107,7 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			alua_handle_state_transition(sdev);
+			scsi_alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
 		break;
@@ -284,7 +116,7 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			alua_handle_state_transition(sdev);
+			scsi_alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
@@ -338,329 +170,6 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 	return SCSI_RETURN_NOT_HANDLED;
 }
 
-/*
- * alua_tur - Send a TEST UNIT READY
- * @sdev: device to which the TEST UNIT READY command should be send
- *
- * Send a TEST UNIT READY to @sdev to figure out the device state
- * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
- * SCSI_DH_OK if no error occurred, and SCSI_DH_IO otherwise.
- */
-static int alua_tur(struct scsi_device *sdev)
-{
-	struct scsi_sense_hdr sense_hdr;
-	int retval;
-
-	retval = scsi_test_unit_ready(sdev, ALUA_FAILOVER_TIMEOUT * HZ,
-				      ALUA_FAILOVER_RETRIES, &sense_hdr);
-	if ((sense_hdr.sense_key == NOT_READY ||
-	     sense_hdr.sense_key == UNIT_ATTENTION) &&
-	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
-		return SCSI_DH_RETRY;
-	else if (retval)
-		return SCSI_DH_IO;
-	else
-		return SCSI_DH_OK;
-}
-
-/*
- * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
- * @sdev: the device to be evaluated.
- *
- * Evaluate the Target Port Group State.
- * Returns SCSI_DH_DEV_OFFLINED if the path is
- * found to be unusable.
- */
-static int alua_rtpg(struct scsi_device *sdev)
-{
-	struct scsi_sense_hdr sense_hdr;
-	struct alua_dh_data *h = sdev->handler_data;
-	int len, k, off, bufflen = ALUA_RTPG_SIZE;
-	int group_id_old, state_old, pref_old, valid_states_old;
-	unsigned char *desc, *buff;
-	unsigned err;
-	int retval;
-	unsigned int tpg_desc_tbl_off;
-	unsigned char orig_transition_tmo;
-	unsigned long flags;
-	bool transitioning_sense = false;
-	int rel_port, group_id = scsi_vpd_tpg_id(sdev, &rel_port);
-
-	if (group_id < 0) {
-		/*
-		 * Internal error; TPGS supported but required
-		 * VPD identification descriptors not present.
-		 * Disable ALUA support
-		 */
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: No target port descriptors found\n",
-			    ALUA_DH_NAME);
-		return SCSI_DH_DEV_UNSUPP;
-	}
-
-	group_id_old = h->group_id;
-	state_old = h->state;
-	pref_old = h->pref;
-	valid_states_old = h->valid_states;
-
-	if (!h->expiry) {
-		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
-
-		if (h->transition_tmo)
-			transition_tmo = h->transition_tmo * HZ;
-
-		h->expiry = round_jiffies_up(jiffies + transition_tmo);
-	}
-
-	buff = kzalloc(bufflen, GFP_KERNEL);
-	if (!buff)
-		return SCSI_DH_DEV_TEMP_BUSY;
-
- retry:
-	err = 0;
-	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, h->flags);
-
-	if (retval) {
-		/*
-		 * Some (broken) implementations have a habit of returning
-		 * an error during things like firmware update etc.
-		 * But if the target only supports active/optimized there's
-		 * not much we can do; it's not that we can switch paths
-		 * or anything.
-		 * So ignore any errors to avoid spurious failures during
-		 * path failover.
-		 */
-		if ((h->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
-			sdev_printk(KERN_INFO, sdev,
-				    "%s: ignoring rtpg result %d\n",
-				    ALUA_DH_NAME, retval);
-			kfree(buff);
-			return SCSI_DH_OK;
-		}
-		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
-			sdev_printk(KERN_INFO, sdev,
-				    "%s: rtpg failed, result %d\n",
-				    ALUA_DH_NAME, retval);
-			kfree(buff);
-			if (retval < 0)
-				return SCSI_DH_DEV_TEMP_BUSY;
-			if (host_byte(retval) == DID_NO_CONNECT)
-				return SCSI_DH_RES_TEMP_UNAVAIL;
-			return SCSI_DH_IO;
-		}
-
-		/*
-		 * submit_rtpg() has failed on existing arrays
-		 * when requesting extended header info, and
-		 * the array doesn't support extended headers,
-		 * even though it shouldn't according to T10.
-		 * The retry without rtpg_ext_hdr_req set
-		 * handles this.
-		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
-		 * with ASC 00h if they don't support the extended header.
-		 */
-		if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
-		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
-			h->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
-			goto retry;
-		}
-		/*
-		 * If the array returns with 'ALUA state transition'
-		 * sense code here it cannot return RTPG data during
-		 * transition. So set the state to 'transitioning' directly.
-		 */
-		if (sense_hdr.sense_key == NOT_READY &&
-		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
-			transitioning_sense = true;
-			goto skip_rtpg;
-		}
-		/*
-		 * Retry on any other UNIT ATTENTION occurred.
-		 */
-		if (sense_hdr.sense_key == UNIT_ATTENTION)
-			err = SCSI_DH_RETRY;
-		if (err == SCSI_DH_RETRY &&
-		    h->expiry != 0 && time_before(jiffies, h->expiry)) {
-			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
-				    ALUA_DH_NAME);
-			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-			kfree(buff);
-			return err;
-		}
-		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
-			    ALUA_DH_NAME);
-		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-		kfree(buff);
-		h->expiry = 0;
-		return SCSI_DH_IO;
-	}
-
-	len = get_unaligned_be32(&buff[0]) + 4;
-
-	if (len > bufflen) {
-		/* Resubmit with the correct length */
-		kfree(buff);
-		bufflen = len;
-		buff = kmalloc(bufflen, GFP_KERNEL);
-		if (!buff) {
-			sdev_printk(KERN_WARNING, sdev,
-				    "%s: kmalloc buffer failed\n",__func__);
-			/* Temporary failure, bypass */
-			h->expiry = 0;
-			return SCSI_DH_DEV_TEMP_BUSY;
-		}
-		goto retry;
-	}
-
-	orig_transition_tmo = h->transition_tmo;
-	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR && buff[5] != 0)
-		h->transition_tmo = buff[5];
-	else
-		h->transition_tmo = ALUA_FAILOVER_TIMEOUT;
-
-	if (orig_transition_tmo != h->transition_tmo) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: transition timeout set to %d seconds\n",
-			    ALUA_DH_NAME, h->transition_tmo);
-		h->expiry = jiffies + h->transition_tmo * HZ;
-	}
-
-	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
-		tpg_desc_tbl_off = 8;
-	else
-		tpg_desc_tbl_off = 4;
-
-	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
-	     k < len;
-	     k += off, desc += off) {
-		u16 group_id_desc = get_unaligned_be16(&desc[2]);
-
-		spin_lock_irqsave(&h->lock, flags);
-		if (group_id_desc == group_id) {
-			h->group_id = group_id;
-			WRITE_ONCE(h->state, desc[0] & 0x0f);
-			h->pref = desc[0] >> 7;
-			WRITE_ONCE(sdev->access_state, desc[0]);
-			h->valid_states = desc[1];
-		}
-		spin_unlock_irqrestore(&h->lock, flags);
-		off = 8 + (desc[7] * 4);
-	}
-
- skip_rtpg:
-	spin_lock_irqsave(&h->lock, flags);
-	if (transitioning_sense)
-		h->state = SCSI_ACCESS_STATE_TRANSITIONING;
-
-	if (group_id_old != h->group_id || state_old != h->state ||
-		pref_old != h->pref || valid_states_old != h->valid_states)
-		sdev_printk(KERN_INFO, sdev,
-			"%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-			ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
-			h->pref ? "preferred" : "non-preferred",
-			h->valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-			h->valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-			h->valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-			h->valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-			h->valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-			h->valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-			h->valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
-
-	switch (h->state) {
-	case SCSI_ACCESS_STATE_TRANSITIONING:
-		if (time_before(jiffies, h->expiry)) {
-			/* State transition, retry */
-			h->interval = ALUA_RTPG_RETRY_DELAY;
-			err = SCSI_DH_RETRY;
-		} else {
-			struct alua_dh_data *h;
-			unsigned char access_state;
-
-			/* Transitioning time exceeded, set port to standby */
-			err = SCSI_DH_IO;
-			h->state = SCSI_ACCESS_STATE_STANDBY;
-			h->expiry = 0;
-			access_state = h->state & SCSI_ACCESS_STATE_MASK;
-			if (h->pref)
-				access_state |= SCSI_ACCESS_STATE_PREFERRED;
-			WRITE_ONCE(sdev->access_state, access_state);
-		}
-		break;
-	case SCSI_ACCESS_STATE_OFFLINE:
-		/* Path unusable */
-		err = SCSI_DH_DEV_OFFLINED;
-		h->expiry = 0;
-		break;
-	default:
-		/* Useable path if active */
-		err = SCSI_DH_OK;
-		h->expiry = 0;
-		break;
-	}
-	spin_unlock_irqrestore(&h->lock, flags);
-	kfree(buff);
-	return err;
-}
-
-/*
- * alua_stpg - Issue a SET TARGET PORT GROUP command
- *
- * Issue a SET TARGET PORT GROUP command and evaluate the
- * response. Returns SCSI_DH_RETRY per default to trigger
- * a re-evaluation of the target group state or SCSI_DH_OK
- * if no further action needs to be taken.
- */
-static unsigned alua_stpg(struct scsi_device *sdev)
-{
-	int retval;
-	struct scsi_sense_hdr sense_hdr;
-	struct alua_dh_data *h = sdev->handler_data;
-
-	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
-		/* Only implicit ALUA supported, retry */
-		return SCSI_DH_RETRY;
-	}
-	switch (h->state) {
-	case SCSI_ACCESS_STATE_OPTIMAL:
-		return SCSI_DH_OK;
-	case SCSI_ACCESS_STATE_ACTIVE:
-		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
-		    !h->pref &&
-		    (h->tpgs & TPGS_MODE_IMPLICIT))
-			return SCSI_DH_OK;
-		break;
-	case SCSI_ACCESS_STATE_STANDBY:
-	case SCSI_ACCESS_STATE_UNAVAILABLE:
-		break;
-	case SCSI_ACCESS_STATE_OFFLINE:
-		return SCSI_DH_IO;
-	case SCSI_ACCESS_STATE_TRANSITIONING:
-		break;
-	default:
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: stpg failed, unhandled TPGS state %d",
-			    ALUA_DH_NAME, h->state);
-		return SCSI_DH_NOSYS;
-	}
-	retval = submit_stpg(sdev, h->group_id, &sense_hdr);
-
-	if (retval) {
-		if (retval < 0 || !scsi_sense_valid(&sense_hdr)) {
-			sdev_printk(KERN_INFO, sdev,
-				    "%s: stpg failed, result %d",
-				    ALUA_DH_NAME, retval);
-			if (retval < 0)
-				return SCSI_DH_DEV_TEMP_BUSY;
-		} else {
-			sdev_printk(KERN_INFO, sdev, "%s: stpg failed\n",
-				    ALUA_DH_NAME);
-			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-		}
-	}
-	/* Retry RTPG */
-	return SCSI_DH_RETRY;
-}
-
 static void alua_rtpg_work(struct work_struct *work)
 {
 	struct alua_dh_data *h =
@@ -670,56 +179,41 @@ static void alua_rtpg_work(struct work_struct *work)
 	int err = SCSI_DH_OK;
 	struct alua_queue_data *qdata, *tmp;
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&h->lock, flags);
 	h->flags |= ALUA_PG_RUNNING;
 	if (h->flags & ALUA_PG_RUN_RTPG) {
-		int state = h->state;
 
 		h->flags &= ~ALUA_PG_RUN_RTPG;
 		spin_unlock_irqrestore(&h->lock, flags);
-		if (state == SCSI_ACCESS_STATE_TRANSITIONING) {
-			if (alua_tur(sdev) == SCSI_DH_RETRY) {
-				spin_lock_irqsave(&h->lock, flags);
-				h->flags &= ~ALUA_PG_RUNNING;
-				h->flags |= ALUA_PG_RUN_RTPG;
-				if (!h->interval)
-					h->interval = ALUA_RTPG_RETRY_DELAY;
-				spin_unlock_irqrestore(&h->lock, flags);
-				queue_delayed_work(kaluad_wq, &h->rtpg_work,
-						   h->interval * HZ);
-				return;
-			}
-			/* Send RTPG on failure or if TUR indicates SUCCESS */
-		}
-		err = alua_rtpg(sdev);
-		spin_lock_irqsave(&h->lock, flags);
-
-		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
+		ret = scsi_alua_rtpg_run(sdev);
+		if (ret == -EAGAIN) {
+			spin_lock_irqsave(&h->lock, flags);
 			h->flags &= ~ALUA_PG_RUNNING;
-			if (err == SCSI_DH_IMM_RETRY)
-				h->interval = 0;
-			else if (!h->interval && !(h->flags & ALUA_PG_RUN_RTPG))
-				h->interval = ALUA_RTPG_RETRY_DELAY;
 			h->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&h->lock, flags);
-			goto queue_rtpg;
+			queue_delayed_work(kaluad_wq, &h->rtpg_work,
+							   sdev->alua->interval * HZ);
+			return;
 		}
-		if (err != SCSI_DH_OK)
-			h->flags &= ~ALUA_PG_RUN_STPG;
+		if (err != 0)
+				h->flags &= ~ALUA_PG_RUN_STPG;
 	}
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->flags & ALUA_PG_RUN_STPG) {
 		h->flags &= ~ALUA_PG_RUN_STPG;
 		spin_unlock_irqrestore(&h->lock, flags);
-		err = alua_stpg(sdev);
-		spin_lock_irqsave(&h->lock, flags);
-		if (err == SCSI_DH_RETRY || h->flags & ALUA_PG_RUN_RTPG) {
+		ret = scsi_alua_stpg_run(sdev, h->flags & ALUA_OPTIMIZE_STPG);
+		if (err == -EAGAIN || h->flags & ALUA_PG_RUN_RTPG) {
+			spin_lock_irqsave(&h->lock, flags);
 			h->flags |= ALUA_PG_RUN_RTPG;
-			h->interval = 0;
 			h->flags &= ~ALUA_PG_RUNNING;
 			spin_unlock_irqrestore(&h->lock, flags);
 			goto queue_rtpg;
 		}
+	} else {
+		spin_unlock_irqrestore(&h->lock, flags);
 	}
 
 	list_splice_init(&h->rtpg_list, &qdata_list);
@@ -728,8 +222,6 @@ static void alua_rtpg_work(struct work_struct *work)
 	 * Re-enable the device for the next attempt.
 	 */
 	h->disabled = false;
-	spin_unlock_irqrestore(&h->lock, flags);
-
 
 	list_for_each_entry_safe(qdata, tmp, &qdata_list, entry) {
 		list_del(&qdata->entry);
@@ -745,7 +237,7 @@ static void alua_rtpg_work(struct work_struct *work)
 	return;
 
 queue_rtpg:
-	queue_delayed_work(kaluad_wq, &h->rtpg_work, h->interval * HZ);
+	queue_delayed_work(kaluad_wq, &h->rtpg_work, sdev->alua->interval * HZ);
 }
 
 /**
@@ -809,7 +301,7 @@ static int alua_initialize(struct scsi_device *sdev, struct alua_dh_data *h)
 
 	mutex_lock(&h->init_mutex);
 	h->disabled = false;
-	tpgs = alua_check_tpgs(sdev);
+	tpgs = scsi_alua_check_tpgs(sdev);
 	if (tpgs != TPGS_MODE_NONE)
 		err = alua_check_vpd(sdev, h, tpgs);
 	h->init_error = err;
@@ -898,34 +390,6 @@ static void alua_check(struct scsi_device *sdev, bool force)
 	alua_rtpg_queue(sdev, NULL, force);
 }
 
-/*
- * alua_prep_fn - request callback
- *
- * Fail I/O to all paths not in state
- * active/optimized or active/non-optimized.
- */
-static blk_status_t alua_prep_fn(struct scsi_device *sdev, struct request *req)
-{
-	struct alua_dh_data *h = sdev->handler_data;
-	unsigned long flags;
-	unsigned char state;
-
-	spin_lock_irqsave(&h->lock, flags);
-	state = h->state;
-	spin_unlock_irqrestore(&h->lock, flags);
-
-	switch (state) {
-	case SCSI_ACCESS_STATE_OPTIMAL:
-	case SCSI_ACCESS_STATE_ACTIVE:
-	case SCSI_ACCESS_STATE_LBA:
-	case SCSI_ACCESS_STATE_TRANSITIONING:
-		return BLK_STS_OK;
-	default:
-		req->rq_flags |= RQF_QUIET;
-		return BLK_STS_IOERR;
-	}
-}
-
 static void alua_rescan(struct scsi_device *sdev)
 {
 	struct alua_dh_data *h = sdev->handler_data;
@@ -953,8 +417,6 @@ static int alua_bus_attach(struct scsi_device *sdev)
 
 	mutex_init(&h->init_mutex);
 
-	h->state = SCSI_ACCESS_STATE_OPTIMAL;
-	h->valid_states = TPGS_SUPPORT_ALL;
 	if (optimize_stpg)
 		h->flags |= ALUA_OPTIMIZE_STPG;
 
@@ -986,7 +448,7 @@ static struct scsi_device_handler alua_dh = {
 	.module = THIS_MODULE,
 	.attach = alua_bus_attach,
 	.detach = alua_bus_detach,
-	.prep_fn = alua_prep_fn,
+	.prep_fn = scsi_alua_prep_fn,
 	.check_sense = alua_check_sense,
 	.activate = alua_activate,
 	.rescan = alua_rescan,
-- 
2.43.5

