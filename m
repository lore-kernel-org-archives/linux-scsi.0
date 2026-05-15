Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97529DB6C;
	Fri, 15 May 2026 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810398; cv=fail; b=UX5Dry35NQu3maFFjK150Y7ld99BFX+fmXrEHh9Ap/322byr0XBtJS8MaRXHCo8ojDspujjtZHHqsXvBw+NTLO3SngG8Ras3jGjkgGK2p5exoBflIFQx0v29wEE2vNGRkRTYm+k2Gs2JyKMJyvQ+gmczIZDqJI9Aad0VqKbPh9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810398; c=relaxed/simple;
	bh=NopV8inQdPylJWJGjC7f+sSKlIyblMS/YW+4HyzQxLI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VO8pLEbeDIRhrfjrv4yo53fJdEyoJrtmgffBytsCEDTfscShN0NVIXvisIBGlif6paQazhTObtasMavRfhnPDhv+Z1xcAnTaH4hTszPYHLr2feOs/FvkqOzZfgxEhSGOp+n7xo2efZH2AnXLmp18PEM2eobePF6hWQ0M0XIXKbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Whtvkzea; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XvCsoRaX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Whtvkzea";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XvCsoRaX"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0Tloc3097569;
	Fri, 15 May 2026 01:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PDbf63UQzlVHb0rosp
	X/L+arMGnXTAzy0ayKeEZXrHA=; b=Whtvkzea8uHcfPv+w5j2VeHCEroB5jgcHC
	eVKg2ug0G8FnImToe1iEBxdC9/uPBusmV6BXu/6szS2IEyek/IV9IzUZ6XadXQFQ
	qhBGwkGjbTzdqIRgmOWkHyiG7RhxGQ02ZGsQXjWXixT5aQcfgPmTfrXbVdX1XsXC
	71OCLzPQ5XuCOLLSj2po4ieJBgpuWYsgZ5PAx89kfMDgGkSuSv9fk6Zkigj07cG7
	LdYUYHAK3bz15Vtth8SYQLjf7VSXoyd46EDqf79+AGSnS6TAFAGG7o7Zkk1oqzWS
	/GPGWbH/WuvFCiM3QwT9fd7AdppltHFxfZ6eL8ByEgKIN64pXfTA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m20gdg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:59:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F1xj0B039009;
	Fri, 15 May 2026 01:59:47 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw5mkeh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 01:59:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WF/oVIcf0gDAI907oEGqCvZzg8GlzEKiY3aUYyv8xJRyl+XyJzrPuoF7gErNAehC7fHPlvFD450P/31yZg6p8vbwZ3PESyiUMjyqv9/tasX/oA9r2E+U1SpyjYnoysQ0niJCY+U5NpRi5f+P/LX2bpbLbTnoKdy3L8ZaGw0V+Usxw18J3FNDhdPAxZMHNCXnCRP77D9hKJiHSm/ZiT++5A3IP6j+wCniq+Jb0hvIl/NXVdl/pYhDnWSBxHxxgrKFdjH2fLWfB6NcEuphsgbaNMX7ALP/SmcCkAZa2XcsZCLafpVyI+nwzTHIuCv57t+sTRLxiTCXD9JKuoGTq8m2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDbf63UQzlVHb0rospX/L+arMGnXTAzy0ayKeEZXrHA=;
 b=adxbA9MJ7aYOjk++GnKBM9N+UTdzf7x5Zay0DzaM0221wlTJg5AZ8tBA4Q6tRtcg1QuR3NXXMj1v/iZdX/fdcuTx/FWB6bScc4gfhQKKowOBj0RaKDlp9qXE1gbfO8u7WJTNBZcNmoWDqu2J+5QkU7CA1qVITSaepFqvPa9IE4iYWm9NRzKh1IVctrzPCQs8p54TQVjuctBYNDREjjwOSO1+LXD2h+yo4jGR/83D2LRKNP7IXiIpFNhUW9aIg8jyqgybI4WSMGWqUwQNTp18iAaSeMloh9j5tkLLRTjW/iy878BqATnJuGAqG28TWPC6AsNwQ15Ji9HtFMMvpKEQFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDbf63UQzlVHb0rospX/L+arMGnXTAzy0ayKeEZXrHA=;
 b=XvCsoRaXhS+axwGKRpwjBbA1pA5t008Yhq18bL+JGnY+ixNJL83OSZU/HgBv3srWgiJMdQlK6UVW8/A0UNJGjpuZngd/l69vEZvcLIBk0RdcRpLup25gduFN02wJjRk5fGAWcB0iQqQU9Vgfc1GxxOljqccRJsVUMNnGQxLAg3Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6179.namprd10.prod.outlook.com (2603:10b6:510:1f1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 01:59:30 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 01:59:30 +0000
To: Wang Zihan <jiyu03@qq.com>
Cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] scsi: st: fix typo in documentation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <tencent_818C822F215676B9B14011B88848609BD309@qq.com> (Wang
	Zihan's message of "Sat, 2 May 2026 14:07:03 +0800")
Organization: Oracle Corporation
Message-ID: <yq1lddl8mbp.fsf@ca-mkp.ca.oracle.com>
References: <tencent_818C822F215676B9B14011B88848609BD309@qq.com>
Date: Thu, 14 May 2026 21:59:28 -0400
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:610:33::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 370d9a5a-ccb7-4470-05b2-08deb2259a18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JMQfXZp5Kgtyzt3Xk17wpVn9mNTBPq0hgT+JTe0/i2uNNAch93JRC0NwHnIdqBQUYfIX2qo1Kncgyn/YlaY0yiC9N8Y3ez0PLKmC/WjheDtGeyVR6QhAZZb/lAHI6KFOlYfwmFvQ1AbZo3WT4Z0Ofdtv8iEjwaMMOKMr9qahsWQVdAYeWYv5u0hwB64xR51LF3LvdIyplh5EsJ0630xqPRn2fU9o0CQ0d97T9yCXLg+MOvf/azhi8fTTt2OuB3L6Gwjgqutg+mzQa09NlH74kCE/Tk4P2Y/jXsPydN+B78RRrf0aOi156AKA07lLIhxhRqLG0r28y2R67RQ/xLmwJtS7HAAGjsrjIOsDVCwmusN3W48Ibl1Cwd0C4wiLzeLlyYNOLo8ogtrSbTWlszFYVgUKGwc5C0sU2gNC8jOfj+6sO9AdcOJ4pdPdStrHqn5hbRFgIW1hIWJO2nfHvX5Qv05t//WnQXrgjYyJEsHZnnGgdIGTF8PLW0NT95Qkv38BG54N3SB8VK7G0wd6wgMw1kUDbUvH9GUYrGpWy0px5HkCYNaFuo2iA+Z+tBLrAeSnX8Y/zR7MXSdxU1DfsE2G7g+skyBCbOTElMs4E63SK1j9G2Xh6fRL37v2asssav5Xmvf2swVDnwLCUGVLNeRi7bruFv4ZKt5iklpIiT5qBQBPZLgahnTWEG/3l1Cdbd74
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?88tTH2y/LUXyA45i9peY1hoAzYt5Qv2E7lkKe/0u6fQsN2EXZy9ryaHyzM9w?=
 =?us-ascii?Q?WXt0qbqDlGhdcx9w7w8/ZS1aPDTzMF8+/Vg5fAmfKSJRc7Llgg+jD9iBav8j?=
 =?us-ascii?Q?x0O1U2i6V5j0SpNuYm07wvAFhwAjAvKH0qoRLJDK01azfclueU8Nbc8hl6tr?=
 =?us-ascii?Q?egMtgMvl5g6718Ax8XZY6nrWEo4pxwaW6dmy+UOFZz7oe4Q/yruD30oEpCXy?=
 =?us-ascii?Q?LfKIE/K/HJHJzrUMGe7X5ue1sAZhl2XrxT8x0bjT1hNaTLOkZvj+9S0uddI8?=
 =?us-ascii?Q?+2HINB5vE0PA8kyOi2lX0JHuaVXeVS5l8rpEVCspG1FpDz+DbSjX9m5egYz6?=
 =?us-ascii?Q?7FNVg8cpUPkCYkT7SA1ZMAVkQSBb0m4VGjg8S4hL6XRnsPXSL74gN1ks9es8?=
 =?us-ascii?Q?FhUWDBfUV6UKvKLlGZMeKLwu92kH+5+/EzPgVOTMTMM5mb4yeWxHduIHY7QR?=
 =?us-ascii?Q?/2lqWfu6wAg1lkXFUV/z8M0KL/8MdUvGvzQLxnoyLgJ2oH/EVYFsJsZfnmX0?=
 =?us-ascii?Q?N1PfHIHJ4cA1M2vmLIEAlfZRDl72iNIizakcKkY/CC1N2PYL7C/lwsstm4tl?=
 =?us-ascii?Q?Z6DKwqb4UFxs3bZARdFn6g9HpSaouibRv4ZTuTMHKY8OJ9PNBH1ybjH3SA4e?=
 =?us-ascii?Q?CjXETSgT7AQcB9rQMb6CSXTAIavrCIJ4Y63SbLxBpH0ar/2g/kpxUvILn+H2?=
 =?us-ascii?Q?gmVzaPAADwDj/dR87/A8YXYpfJdTEo3aXukpnsEcluG1Mxyd1RsJ/T/JnwVo?=
 =?us-ascii?Q?tJ+UwiPHxKzCDH1qOxMNlnjQWyIg7EpNgcJDGiROLHTraoPSXHE3Ls2DrqN9?=
 =?us-ascii?Q?S2vuWBvbPLfvTglSLAjnE5/Ob2EhaH4pUcp1xuS/T+OxWTvNNsQUXVsn7Y53?=
 =?us-ascii?Q?6jPw2nLvxm+HMnT7SnPkQ1yRmNsyu0yBVh9Bv/EbYIVV2ry5GLd1pU61sj8j?=
 =?us-ascii?Q?XQqiY2HdJvFFyY9oN1Pv9pB1BZObNfqqNsDd51yYt/PbXdmlmrkD8i1SXDmp?=
 =?us-ascii?Q?96MlMT1xXWPDPe6x+RQqev7VtxnhFH/3rEwMRQOusPGAmJyUlmG3eQhRnTNP?=
 =?us-ascii?Q?XapNQjGJzaZ1TrlfLR3wTNNjd5nGDpMzApB7lHKy8dz0eLzSRu0accyJJCwV?=
 =?us-ascii?Q?GOd+/P6re+BYOSrAA8MEiQG+pDyIBtwuqGzPAdyEk1e49WVxovtFDq1ydF7t?=
 =?us-ascii?Q?2SlGxx0c+OgKbO8xlhAR264siYd3BlDLe2Oxy6rj5zW510/lUeKXDAH2ZIuV?=
 =?us-ascii?Q?obJfxbsvFkd2UR1F20gi3W0FPP5R2TGs/H+thy4axxLoxMZztMo0UBcgLs9/?=
 =?us-ascii?Q?9N4YqJbazi92CNRHGFkwIrQEr3s30ozhMydoVAEv7bLVcVUBGNc9Z+C9a96G?=
 =?us-ascii?Q?BFOkkNUFshp9XMv460ieZ4GpoAvb9CdHrsb5HthXvG5UgmWtVjf/nAbzlBCf?=
 =?us-ascii?Q?L0gtAHeeK03ZalfIEC/LWE4irombPeJ1Y9yXk63owfx+81RTaCQJrAenSWhv?=
 =?us-ascii?Q?2fEs5n1srj3SSUhDtDus3NSYfqqe2EyQbIZj5xPnuDlBzchb86owU3i3NFbR?=
 =?us-ascii?Q?DcJueim6Cx27f7XoE6huPIdT+GZAWkmwDMHKpDeZ1z9qpr+bGmJzZn8mun24?=
 =?us-ascii?Q?gcwU5US91xEQTsG5Jw+XpfVI1A2xYzIRrukc+5Bkf6hoV7hSpebMtMzZ3TKd?=
 =?us-ascii?Q?M3l9mt8rLCF6C7z7WQQ2KDDpPhBmAPDKVe2ma3EM+Iz27ge7QlqWVCzCImwZ?=
 =?us-ascii?Q?Pqp5pVo27HRRD50w99pGeNZ+B0wGzC8=3D?=
X-Exchange-RoutingPolicyChecked:
	fDQ2msMDNeDVPnJLHwskogHx6/Sym03VX9sMuysDQWivRQvyloDgutSs4xWhIKMVpqTKy8AYKfWF0uuuYswIBoL3FlL8iIjoIFNX0lQTPdN2MvJJuf3ucxnUYGZKt9u+K8Xit5ri1+/9wmInJcN2FI3Q1EHxL8caeMIvdFgk2YDhI3CmpBHGib87Q5ybk8hZcLKbuXrMsAwCT2AgOD3mkv55TpPBUq4Jt0YLISWSO3H7YfrGbXXw+41rZfQLgixeCZJMXLzz1r7Xi8xEcnha2gJCCovLyffjOFrgMdkZZFiuS18a3lGSLwB/LVJhFAoTPQpuldc7vWGxcTq6xBVt3Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PYTFlW28WXAx1P3nDl52ZJ7PalnrQT+K5UjqsIkhxnSG4i5L32icbQIwBwTSYbM6Gt1vBbdfloq/x2HoPIMx6NaeXv3N3Y+SJQB6g71LrtL6lkPJtQJbP2wiMkYRfRUACZMfHtQIwSgrpD3MoVsfSWnEq7v4pN3cc0p/YpzFOeksHrkM19SrLeOv7dRG9EgDbekTultrVYw3CN341D8hBmlWT7UVE+FMfXIUIFd/MpdUa/mP1DjDl7EBrvJv+5CBcqkzcMcQiA3nUF1DN/YqNIcmmIQAmjG+BnE5/MI/dn1WCdHie9IgtudgPl0GqnL6mv7aRzrp7GuAhU1sU3FuV0+I+VVWumJV32+5JIMg5Q5jY6X7ekeqL4OQaecFJrirTmzjI0mFVKKRGhiBPVjuo43yLelu/2N7QPyfKTZCmfc9OYtc35Q1Ss8I7Zd/1K1g6tRHnejAbkTBfZZEzndAg8bgxKg5lkLv/r5MGUnLdr3nYTJLEw1DmIt1505JWWXc960b347+24adwHicxXIxiaY3KfNmsZ8kJEJH2tBUzDoQ0t4DRmVZ72hzuOuE9z+aI1RicsjbjgYdZ1opOTX73Ju8iTiGMLQn7DkhqcwZMm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370d9a5a-ccb7-4470-05b2-08deb2259a18
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 01:59:30.2983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVHts5gt4aeZN4FY00LuqOkv3deQhd3ommSM+sMWMkS/9xL+/1gC8TJRIQLRVRSAkDWhhoTb90N/GYXM3PddwfsXgmbRjQpI8JvFfWlaPPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_06,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=976 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605150017
X-Authority-Analysis: v=2.4 cv=DeMnbPtW c=1 sm=1 tr=0 ts=6a067e14 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=uYIBx3HiBieq-hr8dGkA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12298
X-Proofpoint-ORIG-GUID: k1C9IzGyeheejhkv4IXvi6hEl45CQVLi
X-Proofpoint-GUID: k1C9IzGyeheejhkv4IXvi6hEl45CQVLi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDAxNyBTYWx0ZWRfX+d9exPA7YJMs
 tWNOOZwqBI4aG/ya3oVOUDYrdEtR0PFT8y5F+EZOnEgIcZdjv9tbXzKh8Q2ZBUp1ceGIIcYxxtY
 MTj6ZCCPspJV3kH1e5iXqaLfwjR7pKp8Yra2YeKGdPSTjwthaIzgSw7F0d2nEg1SirKnYqepuCb
 kjZCN2A/QTBeAAmYmjDfxTlk8d9wqqPiAY77pRNFE9bZpyF+qP1Dm1uLirWQ4Q8OokLeWzR7/Oo
 E4ymG3ndn0IddNRlb7JehOlmtMSypyC6mO4Xi6p2uJbFDVpOQLDp7s8dXQQJxCszqORa4+ywLvP
 hqtMB018At3SF/Rug4u+dcShhqPBWdUXvC2Lk1QB1M5exS5AVp1ylp1QQvvItFmptAxyW0eACmk
 jSqX8eLjfKnrzGkwOudVO9fWzkKP4rnhWbT2BOebECBvYEqn8SkBc4X3tWvp3OXAa7Lb1UXXcaS
 +mniTgVsG8ve4KlLyYwJ5uCDjWz47Rh+NtcYm5qs=


Wang,

> Correct "form" to "from" in drive buffers description.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
