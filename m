Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC40F26CE3A;
	Wed, 20 Aug 2025 03:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755659352; cv=fail; b=AgWHU8kmHgZT9waK0HRCcqTtXI8/wqPhTGPxtqQhJ5rlWEl+P+O+m/4B+1u+dk3sscjhVNPRhBY7HQWFXuGWfeixwsQpZ+/s9JUTCQhFuVR+YQg3LUAqehFqTN9F+9S3P/lTSONPf4xPyVZm3wWYO6Qg34evtOOBZ64XMNbfwv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755659352; c=relaxed/simple;
	bh=DTKzTOgh3xt8SzqzmhhEMZaQPq7S13CYo2hJ0q/pFy8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=d2PN9xPzvS0BF8YfGFuzmO0dIXJ6trRLruuLpwvKXfT2Wd9jFSHFd9lB2kkFmpwKKo86eZpyk2KBNKG44qw07mYSYnuZ3Bs50DZzOQg8Y5xufGkG2yiX0Wttxv6QhC5EYZw3S7m4K3sRD4kWgnnveHT/LRmGlGqACl0jS2ObPb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DCQW8ANp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R3uR92zr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DCQW8ANp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R3uR92zr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCEvd012242;
	Wed, 20 Aug 2025 03:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cpBnGSSzzIBV4IduW7
	v9UYifMJgfYopHxRDGBoJn5E4=; b=DCQW8ANpiElqKQafHHAt9V3yMNl93NiFzk
	Sw2nAff8Lk1dwDFwRIIahbJkyFYJDY9T4mE7wDJx2laSL/qSELnZXK+hEQZKagQL
	n4dTmG3Y9aPySCeoszl9bLHO8CnUpDyoqSL6N3Ph/4QF+FpX56K+IIGazGD/r1An
	qecxI6+4T+7k+zbkaGWzuNJZUhuvc5Jqzwz7nDChCS/Nes0kzu+60X+6hhWpJNpm
	WkafYhgx3otDYKS8HXmEaXSKlTT0CVpV0Wkz6AKHjvwdo1CnwVHHAgGmR3Y8cg0Q
	W3YR5Xz7w/4QQMOIBML8LygDlEhm/u6MurXrcY7sAOSUUSQqkZhQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0trrbpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 03:08:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K2VkRi030225;
	Wed, 20 Aug 2025 03:08:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3tdhng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 03:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Heoa3UTXGbBc10feLuQDjWAcy/ZH+fXao3GS8HQBys6Fcj5IxpzKPk4o0FQLDh9uQNtTP0YWHEFQsLrkmA/mRhyA920MOZ3U75BcIbLW/q4nl8GXoVKtUZjhc6TBMfsGFDqbIXIfpSaYmr05Ti5VyTxpodXlm/JxdtT6kIKV/PGkF6JbN80wRM0ZERD+fi4jSR2aCFw1+I9R6WXTazs9oIICMAtyTya2iHLwSH2vadz14TBSHN4VirLvhleirICVQEXSKUXMvXCfxckMFQ9FmtCP/VzmnhJnj1rCL6fwc4R5STGZkl9EuyuFtuDbhxhe9mArshgUKcCkNrtlzCCqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpBnGSSzzIBV4IduW7v9UYifMJgfYopHxRDGBoJn5E4=;
 b=YEvffZgL9K3cjY4CmADAmwxKfk6tgjcuFF37+wyJvxwh/wqBxjtfiqe+bb3aiKhyN5fgK3PPBPkGCpbHgtiSV/ZjHnmytocFwckMmvyXc+5kwTS/HtzoTOhx9WMlukM/f5ufaDnWMjXw0FXgHBXk+jLTkDl/5hcSU6gnRLQeR8whIGbfay5D5bVLVc5PQDB/JRaYWM924weOCBpivL+f9lcnu++7KED5YIWuENs2xt3G8mOCj3331bPJsVwiUgu/QqdpNHCIse6zG0oE6Dopasu2MDzRLQ81NEwVH5VoLEIpFTur87IRCxSzI6J0FpyEoKL0zImqU3bGREvC6y+2hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpBnGSSzzIBV4IduW7v9UYifMJgfYopHxRDGBoJn5E4=;
 b=R3uR92zr32vszyW7TbMp+IbCVBuTHMGuTtqNVOa30ox8yCzcp4Spm6xc57TokYxobeatk2MU2w1GFdM6a+gYANPAIw0OhQlCk1anIIZhcaknMNgKHZKFW5phlMBl4EFjgAecxgHWLUnr6WfmEQBhSj5dSEafZyhOll15S7ahT3c=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB7437.namprd10.prod.outlook.com (2603:10b6:610:193::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 03:08:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 03:08:53 +0000
To: liuqiangneo@163.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Liu
 <liuqiang@kylinos.cn>
Subject: Re: [PATCH] scsi: aic94xx: remove self-assigned redundant code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250819023006.15216-1-liuqiangneo@163.com>
	(liuqiangneo@163.com's message of "Tue, 19 Aug 2025 10:30:06 +0800")
Organization: Oracle Corporation
Message-ID: <yq1h5y2vh09.fsf@ca-mkp.ca.oracle.com>
References: <20250819023006.15216-1-liuqiangneo@163.com>
Date: Tue, 19 Aug 2025 23:08:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0040.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::26) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB7437:EE_
X-MS-Office365-Filtering-Correlation-Id: cdcf687a-2d7c-4ba4-22ce-08dddf96e4e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bHqXIMkuBVoLA0sTry+Q1/Ov096ct+7t4K+nIWrdAco8uG9MQlduTjCtW/j5?=
 =?us-ascii?Q?aB7QSJEXsE8prwNPJCld8ZLj1G8IzLvtxku3psSdYwFKiMuqAbifr0oYyHGs?=
 =?us-ascii?Q?6ldXPkLimC9keto75zK/thp4IwMoQCOgMAvP9uPqoL4AQ5IOznDF3uXIgFMa?=
 =?us-ascii?Q?7LH58BzcDTzd7otfZFOoLYy9PqwDEUmK5mkDLW/tCePW6ztQQiAYMzJC28wX?=
 =?us-ascii?Q?fGfbXbMVDUtnbslakoBuT3La4ro/lOevUZ91bpBRv383yWGpxZiz5+rjx/yF?=
 =?us-ascii?Q?WZy2z755Bm6+y0bL6xiGOvqWv/636a19I17T3crnVvTaKFdD0JdinR+NAOyP?=
 =?us-ascii?Q?/WN6k4ELBxUQeXUhQ6zZkkiB6o/Z+wrRBnDq/N8olHFbXU0A04mSIKYokHkY?=
 =?us-ascii?Q?sUc/F5OxxyKfSvCkr/GCKAJB5Rp7DX3w2qF7mCTZDr0hFGKVJH4fNF1qrUHx?=
 =?us-ascii?Q?sWagMSDtxb2NDvcowKhHxIxfH6v3rMXylrfDTqFSnuAn/YWYJdTVj8ubPQ1B?=
 =?us-ascii?Q?NQguBT2nA3n6D0JI3GwCsdRBuHLUEYxsNekteloNsd7OR9eVayE5DmCfdncb?=
 =?us-ascii?Q?FCvgbFqds/PTp7A3yD5PxRcv0Qf/TrfMCnMDueZqBrulhZekiSTosdO6UQsA?=
 =?us-ascii?Q?rcdFhvH0EIjKh4UZtDSt7axszlPX7xFF41g7N9TEK61nZ27ZivhitmO/YdAY?=
 =?us-ascii?Q?4gjc2uRPTzvcvm7+7klFQJ8obtHFv3qn/Oric5THCmgc8K7qxzocWhpmLU4o?=
 =?us-ascii?Q?C1SCdY7SQh8DgXY1ELv8gH6QfA+hx26wMQiZ6cvofky2exM2Ad/t5UWCYdP2?=
 =?us-ascii?Q?OjJTMPhMIKTLfieNTR4Scx8YIw6mrOD4skL8+H3PPqluoPkOk9BVN6ylEN2z?=
 =?us-ascii?Q?CSBtL299iYDy/0sUxKpTVMRjoX4VypAj+bgT/QL0Qaenc2Ook5dJGC9SIiMU?=
 =?us-ascii?Q?xr5p65bPYf9u4tq7iOIyBD3BG0TFBLuoWUl58Nswsa0Gk6UyG/AbJwvCmL2S?=
 =?us-ascii?Q?SA26/U2fW4A2ediaYe6qC+z9OKyVXwDRyQNIDOPzUC0dh++rYFYiWENH3Ptf?=
 =?us-ascii?Q?pZDIk3dYj5eh6ibnO6eZ77j8LwHBmzmOaw+2uwjd4JOiLbsRO/sQfp3YnqBb?=
 =?us-ascii?Q?UKU2qkv8EsWx8CV4C9JSczcq0kXz4Js/oaJlQR4tG1iVrtcLgILRDE5lAwB9?=
 =?us-ascii?Q?bwFQs5gkNBCuXR5pvQy+pjSdj1yjxQ+EnFIwcJZaFslNienheES0jAjkatlz?=
 =?us-ascii?Q?0nEwRoHVsz5Su/OqlKzciWd/t3zapJpyXRyZZLabA9gDyYU490Z6LJzbjU7k?=
 =?us-ascii?Q?wwq73DEMnt65TA03qt33zl6VMqZ8GbXQzvq4LH1YARgFdYtgcUV/B79NUSb+?=
 =?us-ascii?Q?l0AgeT8qiYsG1chb1hOYqpu4HARADec0f3DojHxoh1IWY4SnqA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0jQFA2V/REYYYRXSgks4TYJOjlS8snQCX4RpRf46UKEBvT4TGfUa+HkqdLoR?=
 =?us-ascii?Q?2s9wycoY2rSna+Sy4paodqPg8ed56p1wy9zRDGEeZJI1AzyxuE/B8jzuuq67?=
 =?us-ascii?Q?Ze7UFKwe+OV30/l3K6vvx/iZxpaldpyCJl/+im1kIwiXu5zLjbbWaGWmi+kk?=
 =?us-ascii?Q?uXAUatZl6iH8Fi72ufuH31+rN350GIO/8jTpuZIb1fclpXH9H1Yz3vAW8/2O?=
 =?us-ascii?Q?rnhRy8NYob7Svv9pAXJqEkpbO+BG82r68s3FJo9VMRWdv1JiP9ZnXjbWLtxL?=
 =?us-ascii?Q?+jKUorFcy97X6EIoptujM1j2HpgsPxFiNhyC3Sox9G4SQ+KcfrJ0sBGEz2+B?=
 =?us-ascii?Q?sBvgLXbv08gqU6HalgICTC+Cf9w8lRhzKZ8+nXgRfGi1p2Fi7REdKrswV9/M?=
 =?us-ascii?Q?phBIWW+TTZ3hs15ATmXvUjaGz4p5Gms4TBnWPtGNlZk/gXXvz6BVfVWHkEjq?=
 =?us-ascii?Q?3BUbyfy7h0Yeg5cCX1q6gYFWUb6l0/JDdVMWUbVgpQ4qoOlxY6RYYAUnz5Yj?=
 =?us-ascii?Q?mhFF9mQ4AGB4+o/5AcsXQkC0cHtlelxuOmqgFsJWStJejN+YvfLlrEV4p5/U?=
 =?us-ascii?Q?EegTgp/+yPM8YxWpn8OgPfa+B6z8T90epQ02vDUuFVoqDXqWdlDUWOp25dn5?=
 =?us-ascii?Q?zvLshAyvZJIhrlLYiHxkHaRv+aykrkg889phBJyGsAsCnSQTCnCVgVpiYGk3?=
 =?us-ascii?Q?NzbGkWABuKltZfLuRYcMfAYCDc+jSq7ASCXhUp25U2YFhksTTKYHnrV8VSlJ?=
 =?us-ascii?Q?h5MyQd7kmYA8txzqewCMzg2bWGwCm1DNkWg6su0YMt+4TgDWMd848Z7dNCpc?=
 =?us-ascii?Q?Kd6a1vEwHdc2uVleSBWLqyQ36OCJRHHLzZ8gCo50nqLmzBje3gXPIFlseMlQ?=
 =?us-ascii?Q?0dd8U5XiB8RQ0Z7p7rOcOxIaL3rKIfrWGkMGk+AH2hJClyoSGvdrZ15IZF9w?=
 =?us-ascii?Q?JT/2EWxKGyC5qrAG8Ftn4VrCTieQWHuz9sXkY1SMUIW5mGyjOmv+qYSUqKR7?=
 =?us-ascii?Q?8ezN+Zg4yPffPYy6m/4z8WQqWI7OcmeGt8TI/O7u5hXeeRgJ+rKdgoruanLx?=
 =?us-ascii?Q?84tTZddV3S4mJRItKJHBcA85IeAtoRRHCTiCGm3mMsjiyWpd5FLwss5idSrn?=
 =?us-ascii?Q?OXqaEdPCqS5TdlsbCtdcRvJ5VXZm6wslaSQ9S2N4bxK+GpmTvwl7NzuLa50Y?=
 =?us-ascii?Q?zPvBpFUzx9YAMYOdO0vZP4A9lnIYEIHLcSGQDrsVFHZPsl0U4vysoeRvrT/o?=
 =?us-ascii?Q?O90sdCyo+zWqsw4gur80apMM3G9wCISetOVIkUz5OxnjReu7IJN48XKRhqDq?=
 =?us-ascii?Q?d275YyHWv35FBhHX8PPAi1zw2cZSfwEfSM1X0xnjTZ/3XYqWwrLsGLR7gpw5?=
 =?us-ascii?Q?mxpBj2rOl9QFQs1gstKsTiW/21ORS9LQRW5aDa0z5R3ocJrvNbuefPkZybSd?=
 =?us-ascii?Q?mDGZRut1v5RNSzEuiBDRMU19YabKyfXxiZzoMmTtEeqmqfrqWvN4ffRHyu1l?=
 =?us-ascii?Q?ZgoGYeS2V64N6sRv0jpXXSV3kmhmC1kTpgOO1+vgVyQGVdPC4ra6AXI0NtNs?=
 =?us-ascii?Q?NW4PePfMgfNjfk8RdGaYoNLRaJG+mKxl7oakNCpr6L8OZixiyFM+xRNml1Ff?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k7pfcN5Vl8f767cX73PECcTYVgkYMI+sR1+ndv1IhjlTiO0WHLteQowXVDOohr5nAFdHloqlSTUnRQsbl8BhOP2l25iCPAVfRGPQa2xSoXg5KBNsYXqyKQucwFmJ0rDx2yurABsKwYxpsGe5bXOQKwahKkZUfR8ROJdCnPjn1Z8UfkwlZojvHEPQd4ShElodMGf7rDMZr6E1I3TEF75o65PR4+VLjmZUt2JfSFE+sWSn+kKaQy52PRc93p2R5mEJnBiRtxogucavUpnrTHXokrlj2PoewXHXP0yobNz6ZO2eJVTjGQeKqivKllgvs046VyoJ75I6mqyoqdBH5hCLmTuyAMCMxpBCHEqeeYkYN7QxoZx9EdI12uiQ2eJ3XGPbYwllFh0RYnNH7WS94kJvXF+EHNB0nm740LY87LvORv7Ogv1fMvSgI0jm2cxEEgoYRWxQ4d/ZnXaeemXSzBDKgEBppXwL3A4cdwdNMvNw99evX56wcMIAm3Hwjl/cnveH3uzFSHIt3ZmP1mpbypStMQKOCGirDUCY3NMjmjz1JeLwQbtou7nefpUhcqd9Ast4D1OuQc7t5G6qCc/DkMMGtT/WRYcJm12Wr2QdEZzeaRk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcf687a-2d7c-4ba4-22ce-08dddf96e4e8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 03:08:53.6633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GcIzAIEM4erkojlZsou0aR4ILsyNybpdbEDHy1/t4NDqgKvDNaQ/0WnHae5QcIfDYTuLRbHR6MsKedm954eaEvd0uM4vTGrw7MLjrL0YpD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7437
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=808 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508200025
X-Proofpoint-ORIG-GUID: o4FOtkvFL99Zcsg1uzdkJT65puwUfapw
X-Proofpoint-GUID: o4FOtkvFL99Zcsg1uzdkJT65puwUfapw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX7NuP77g6vRcm
 gUXgu2R9T6Jqj0PhHCLq6u9FWDKQ860BGYuqJ2OIKPnsV+pOnF3BmT/Wwf/Kw4Z1MMo1Bc6O5wI
 s/Kt5ziEDq3YFy2cH7oo8Do3qayg/J9lqxmlKo8vf0P83YXFRc4Kky963FKDpMRWlt7hV7BQBbq
 LAa8roGUVC0zNFR18NL0y8aIGNNrRaiuaKYusZmbX0owrzuM5ZU5u8lyesqgJluXNCWfNz2ctr9
 jckkBev0k4a0ilqmgEGMpzf7NwEM5HGxCqLWCmWQnYFJXwbQRbgHoJq393EdUJ/jEShKFTqd2gW
 DDXTY5PuZYenRSNZQ2HCajrf0RHqrVIbfep2fqyPp3QYofMVi+HHi4q4aLACPLVLsaq0xxnwpJ/
 h9jtTieQbUsvRb/SBRoqrl3zcZKMqlelrK+mB5CWlbzPLVpqKag=
X-Authority-Analysis: v=2.4 cv=Qp4HHVyd c=1 sm=1 tr=0 ts=68a53c4a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VMc2hXFIwiQ8uEzf3LYA:9 cc=ntf awl=host:13600


> Assigning ssp_task.retry_count to itself has no effect

>  	scb->ssp_task.data_dir = data_dir_flags[task->data_dir];
> -	scb->ssp_task.retry_count = scb->ssp_task.retry_count;

This begs the question of what the original author intended to write.

-- 
Martin K. Petersen
