Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74FA331222;
	Wed,  8 Jul 2026 05:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488006; cv=fail; b=XFeAyEV9FF0Tt/sZFvybri12t0kRfQ+YY6mPKs1+NB0tYF7BOE48G9inQN5MAjBAW/DZjBS8ejcVEGClWtD68I2GA7Ru8YLWCHZwYT8IIuwIzN4ZfuvdYrbmqC7yYsVx3SVJv+J5Cct9ODRmq8IMkHAEO7j57rq2fw1EpoORKMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488006; c=relaxed/simple;
	bh=aFFUB4CyqptMNm2UloFuLiMUb2sZq7zUORjvkHbgH0w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ar13vVt1NIl1YoOLixpSJSNKK0SI2+v/LP0Kib5oRIgSTgRmNxXpTYNf+EX/izgQAyq1uG/N0zVJYYHF4sWThAbREPw3QZ9grF4YSeIy4H8SOPz3YflDNE3aJfMnaTqkHh4ofQb4UAQ6AjOEitMT0Qu3MvOV/vWQQGtizOfnhuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WA1gEzE5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZBdjWVgC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WA1gEzE5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZBdjWVgC"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6681oiD32025270;
	Wed, 8 Jul 2026 05:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ox0iR+74mvWmFZGPViSM7wJCwvGwIQUtauD0tmNlfJo=; b=
	WA1gEzE58uVpO2BPSTkJGU+v6YJDkYuqN3BkAiNM58S96v5tDRM4YYtIzOr/x9Bw
	udghex8ph4m6A1xpMfDc5LVBKvReeDyzMzo/pemnG96+GIcpfLSQsoegZmNuFauq
	bGm/kINUTYiLaQcl65VXTpUWspGLyViJqg4/cB9hleZgdxVOyhSGPa4RNUt+tLfM
	7OIxleQLD6VDb1KfIeK1sqfhapFoHJ56q1vD9vG/gI2sP4C98CUOI0fivrNZtNgh
	vI4BAgg8zvvAVcDFaPCju1s+Mn09gKH6wwaMUMXzvxdkBk25WV4z8I7dK1uokE6p
	gNQTKwwbghTH696t6JT5uw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6rkbextq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 05:14:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6685DdIT008736;
	Wed, 8 Jul 2026 05:14:54 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f84w0520a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jul 2026 05:14:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+H6TkS63lHJreb/BY/jdhmKqoRRDXGArJvlA7h97Fzv3a7pBVJNZ3Yp+eYlxZHTFya74M7HH/CgkOFL+vF+cejsKlEt6XYnHbnDVcEpfTqXzvCBOTcGNxirlcHFsljYW4VdDUfDDM0tmmmAgJdqMXhruoyZJ9gT7QOj5hn8oPQISVn0xRG+5UVnQ0Y5kaqoDWaaWoBZnOAnDHpaDiqIdnWsIfmOswFfy/O10M0CbNs0M6TXhGoOHqr5TqIYhNW6JRVsqcn9aQL/IwQE0eQ93jx4VqJHX8OGCLkdBdW2p5kKDZsHh/jiXTM5nkid5yyBt5Zj+5uwoAK6Ov9uYFltaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ox0iR+74mvWmFZGPViSM7wJCwvGwIQUtauD0tmNlfJo=;
 b=OlUId2juHht3JyXDPesnrKlNe9bPmy+/g2qXwcqfdN9Eo6Hqox83GpyHY/c+KTP6DDpeK/zkl+HJ5lWoJapWG+Py4pZgKSSPaZnHMzOiclY/L4/u7xmUQ8tPIPGGrtPvimJGpaAFJpHY0ZswL+CrP0Y0umMq//gIROWWcqHb71BBTZICG41tULEnManbpROzQzdCT7KOCvqVmE7Vmjt+sKQ17nvCJ4jfNrsqALxxc2iFSP5XwVH92N6Z2jx6NCRjJ2ApNzxzTpnLb4w8U8mxMKrVtrYlkZU5poERA1eDxCPzX6KGJqsmCxtlhOSrTynpbJrh+qtycQQhKkDkNsxwWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ox0iR+74mvWmFZGPViSM7wJCwvGwIQUtauD0tmNlfJo=;
 b=ZBdjWVgCbQIa+U4zkxACGT3SgFdqD/zQqNNSXcnBAyQqpMu8jXY0APe7js79Lso9gJr4kTKm26IsrZNt5SanZEHcjLzqwMHMJ7Mn+o+pTlTW+uDQBogjOHy2cqQlXcEpeVE1YMKU5W3jMjQjP4+TxnN2Z+tQ9JYpR16FhFrdsqE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BN0PR10MB4888.namprd10.prod.outlook.com (2603:10b6:408:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 05:14:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 05:14:51 +0000
Message-ID: <fd2813dc-3db6-46a2-8aa4-30326b5deab2@oracle.com>
Date: Wed, 8 Jul 2026 06:14:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: fix error handling for sd_large_pool_create()
 call failure
To: Damien Le Moal <dlemoal@kernel.org>, John Garry <john.garry@linux.dev>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: p.raghav@samsung.com, sw.prabhu6@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260707105555.1382237-1-john.garry@linux.dev>
 <a19a428e-9e66-42ea-b95c-f4954b67ac87@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a19a428e-9e66-42ea-b95c-f4954b67ac87@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0109.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BN0PR10MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: 43039359-44dd-4653-beab-08dedcafd657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mHK3iNGehbNiY/eYIYjj+aJXi2ZufK2senPOIoPetzyA58yrjgRU0LwLn/YCW+hB8p4PbC5vFHrIEy7AoIlyP4vz2DnFQZpPxuzXGZsNbS34nS4jz8hXyEiT5ezBc8qfQePpRuQbZsrbM/5H8jhPmgHBsCOlnPkRTrxEJvqYNaCRwYH7OaHyu9QSsudSDd2Lb9DBXf1oGKuJyBogTiBTE90m7opInRPZfWuivo7BGRvdNqF/gBKe30o/rCVN94cNXZNL/VZFO/nHMIY014XWPv/hM4GPUvKHedxcr1Ok2u8uUxoXiESLPYoLg/OO+fq1qyqUOmCcxFSbcZLay4aecI7IgHmMQq0DMGSOvlAlJEKw3PXjF4HsfQsinFQHamGxFy33j5mFq5XN6uKEunWkVrqorMx1/R1AOuDhgjaGflpQd9XQSueF4Jw/C0v6WyY5jdRs5IcE00TGOXa5YTL0IstyGw9Yj6npoqapcP7wKqiQ+WW4ZbpA0VY1gsvtIiOKC6rGDueDbOkIXUXSRkiOW8GxuG6UVrlLH/nc0FpFFcCmExEE604DUab6QC9Nd/rUBVEeTkhXm8vKvucD882IRtkxHrD5GjYiI5iDtSF08/L+MDnAAm9ANZMy4dODcPOPgmVmn0p7rWJ74c0D9VLS/dZCZ+YnsMSMc6NK3X69sTs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjVKSi9XNDM2dFh0TTYwK29XaUZYRXFNTmo3eW5iNWpkZlc1YmduS0NUVDQy?=
 =?utf-8?B?NXU2SUFnNzF5N3pRRi9KbEdXY21WcEgwclBaZE1ZR0JzN3BwRDdhYndsUWhz?=
 =?utf-8?B?NjZjcENNelJNd3ZZMjEyaTFKeXMwN1RVVmRFOEovaFJ4RHF1VENBOVhZNlNP?=
 =?utf-8?B?WUppQTE0Ry95VUtzZDAveFQ0RkUwOU90cnVsZ1NnaGVpTTJIS2xtZXh0UDRs?=
 =?utf-8?B?WkVESE1nVFpPb016blZYN0xxalU3d05CSnhJa2tLTDFMU3dzR2VMRkVJUTFk?=
 =?utf-8?B?V2RMY1BtWUZqM2NPUmRWKzE2VmRPQ1c3ZUpnNEFhM3VCMk8zMFcxRUNSUS9C?=
 =?utf-8?B?OGZGVXJjMm8wN3NLMUU4eVAwbUx5Vzd6d1dPcDZlSGpCMVFVb1JBMG1XOWg3?=
 =?utf-8?B?STNLMHk2MWVsNmVxWXFGZGJ0UUxxUnRMZWNNMHNYNHFoZU9nY2I2dlBTR0NX?=
 =?utf-8?B?czY2anFZY1UyQTlCWnNmam5uUmlTcHRBZ2FEV3NvRkV6NnFzQWlSUnVqempV?=
 =?utf-8?B?QnM2d2ZDRm9ORXJPbVZIRnY1eWpjazA2R25UYlVPdGNzY0ZyK1pRV3BBRm1X?=
 =?utf-8?B?amt1ckNkMUVpYkFSUVlGU09Nc0dmKy8vdmhFNlV1b2kzTjFkVjBFWGhWZnZR?=
 =?utf-8?B?RE4wbkMwK0tiUks3c0htSi9saGRFc05tWjkxdUh3bFdpdnF6cUFsM1E0eVRh?=
 =?utf-8?B?eHY5bGlNbnNTbFJMRktUQy9NMGVNVGhNMFBqZzRxaHN1YjBCZm1aSVFzclNI?=
 =?utf-8?B?YjN5MWlGd3F3SS90MUMza1JJcWNXc3owNzlHQ1ZpUFB5aUdGYmpxZnV6Rlky?=
 =?utf-8?B?c2pUYU1heHhRMERqaVE0VHRMMHJselk1UWZoQjh1azFCY0l2TC8vOGRDTWVw?=
 =?utf-8?B?bWExeS91cmducEpHZUZJN0lScHVxZEhtMTU4RzV4dEpZRlJtam5UZ2ZHRHMw?=
 =?utf-8?B?V0JlSFl0QjB5STlzQjFTU01yTy9KaHNpRWdpQ0hWMm9YZzQ2NVZDeWpaZ1lD?=
 =?utf-8?B?VmhZSTFMVEFJL29QdXVJRFlHblRINE96TVh0OFFNdzJ1Qzhzb01RbFJSN1lx?=
 =?utf-8?B?aFRjYmMwWVlzMGM0NXNLRXp6Y1V3NHNRbDVBWGtQMENpYnp2bndpK2VjOUcw?=
 =?utf-8?B?WXgraVhQT2pYWGV2SEpUYk5qMHF5YmxkcHBoRnI1dkp2Y1pJc3BiYlM0QW1O?=
 =?utf-8?B?RU9aNHhyTGFOT2JoTm1pWVVESEtaRjl0VVZlUkRTK0FMTmlLbE9HQXoydGUw?=
 =?utf-8?B?bGxZMUducUJoa3djYW4xUkcyR01tZ3FKN0JMSUI0ejVOUGV5ZXZ4RlFjU0Ja?=
 =?utf-8?B?VEJWdnNuZ1B1UHFmQjduWks0VjBwNzQwQXRya25lUWkybSsrNm9vMkorZ2Ix?=
 =?utf-8?B?UEpOaUR5RC9BcllpVXdiQjR2S2ZDQkplOVBHVmQwTGN2ZWgvc0tiWXlBTkVm?=
 =?utf-8?B?Um9hellFTUZ2bUJKT28vSmlCY0M4cm9BY3d1eWZVMUZHUHppenQ1TnZnazlF?=
 =?utf-8?B?NVMyVE5UeXIzOU93dkhqQm9pNXZ4clIrR0Yzd1NZUEx4a1hCdDlxZkV2Z21p?=
 =?utf-8?B?YkhoeDFLRkE3dDk0L1lZa2hTNVk1UmZ5bDV4SFBUOUcvYU4vYk03S0l6ZlV0?=
 =?utf-8?B?R1c0YmdzYVhRV28xcnhRRlhRQ1BEd2lNaDNOamR2Y1lLbWYwbWZJWklqVEdJ?=
 =?utf-8?B?WnNwUXpwOHpEWU1rTVhyUWNldEFTL0VqOWNWRXNQV1R0NG1GY2IzNGVJYUVz?=
 =?utf-8?B?dXFpSCtvRk85MUtEMk1rRE9vaER2UnQvaVJoWGdETFF1QkR2ZTNaUXNCNGxB?=
 =?utf-8?B?S09GNTI0UXRtTGdSSklNa3BpN3FBeS9QZTJrNi9ENm12OUU5OUpLbUR5eGsy?=
 =?utf-8?B?Z0pQWG40dklCbEltTlJ1Q3NnM3R0cU1UdFhkaGlFSWNtYThLbFZtZjRUQ1pZ?=
 =?utf-8?B?SEs3TVZreFlRS2hkcXo2K3NYWUxSeGgvM3VHTHV6NDR0RndiNEs0cUZMV2ps?=
 =?utf-8?B?M1JUbk1sMXcrL0wxM2MvSjl2V3BSVmh4T3NjUEx6anR5UWFQSmJCU2dDMXJh?=
 =?utf-8?B?YlExMEd6aE4vRnZlR0Y0N05BRGwzeCtLaTEzZU5NZ0JyakFVY3hpRys1TGx6?=
 =?utf-8?B?M09aMHErUmVpUGgranViQnVLQUMxOFBCN0JYUS92Rmx0VG1lcCtjbmoxbjk2?=
 =?utf-8?B?bDVpVk1HZU10Q29aQjdVWmM3M09xNzRKMUtXU2drbCtqbzdVSDlmbGlUdXpu?=
 =?utf-8?B?ZzF6OEhmY2Z4a09hbVpERWdHVEpveEFDcHJhUGV6amtYQWVyV0FPTmI3WkZ0?=
 =?utf-8?B?d2xlUy9udllLczM5WGR2UUZyeFd5V0JQNE9CTXdDQWkrV2tsakFXZz09?=
X-Exchange-RoutingPolicyChecked:
	O3GelG++L4pA8hoDE66LtWLlpg0/L5CQ8qMgYBeegmsHm7wiMvU/pEW8wXZk6fjH9k12IiLsPllAk3PHGHEmEGXkoQE+isfIM8bDXs0nX1Rc/B47xLsB4BVddWZOIN0EDN0+paCCs4WADIprn2+9B54nT+8NIKV9b++Ul/k08nrzE27R3qB7QhQ7CRAiQuPr3eKj/Hj2HxswiqtkMMj/+kS7wsXMd5rAl7udw/Ny91eyZEbH0n1oJ/bwRr7/AeHPBYelNe28EgVKzrnPVZt0YfbYTC8bwgxbAV+AiXf+VpY1yEinMmyju32Jla+zCzChYrT3zzeC0DZJCd44ne+tdw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mEJh3twv7vUEfOgE8Nhx3i+U/MrJUKbScAY3xo8M9hBbRDmWAOV/kHl9tBsfTamEcr/URz08oc+dFrO43tJOQeo3AajzxjgR+UimNCygjUzTXVWyATpf4K7etHG3iqm549j2m3kQ0hBgNtQLs695vKqnOiYM7SzcE4q/txQy0KYRoD4vOuuTN1prVUyHINqLehe1o0lLR5dRLCY2EY9A6hfI7/IMyA2CioDszMXpr0pQzOTpfsV6iRPirt/iSmWLF+EMon+nQlJsL3jvLIftjepYFBXLSBMNQ7u1FTqZYQvoiWpcB7U2CuD0CzNyca/2nQQqmEK6IhLupH7+gbOcAoVh61PbNdOsQAmTxFul2UFNc033FPOP9VEFbyTUeXVb9BsltnXm0W8Kzqdomqn8tRlEIEtzQdgPIwgw3CAXwQIMxj9zJm9gTgnbj4500kNLxm6HpwVtFWbELxYlzsGfJb5kk/qzRfJMSvLlimXX5xKAZxOzRO/hxMqZD3wilcNMYppsfN0yCqu6XWDqLELEO4merhv0ogzeEBFpmqqGnJpO0nfOggjWkGrkcyk91mj5TK+Wy5hxPtjMKi24WADpxQqtsG+yK84lB2/MGKltWd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43039359-44dd-4653-beab-08dedcafd657
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 05:14:50.9176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YTeIAfR+oI+vQT6uYu8zymokNrIISLN/Jx6KpP5z1xBoWruk2bm+j4XgBTt7MJnAUCpHXEqQDJvaeas079djw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607080047
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA0NyBTYWx0ZWRfX2uHtUqAfWAXT
 ZyLb7c5YHmewmJ95m+DtFs6RjbtAtqbG34ELUsL2GpyW2TdglWaELYnYFcB8HzE79+6pj2i8F8t
 ul5aCpjXdh9QIjU8JlMdQzpT6uBP79dyptYqewzv6ypenA1i5Uat
X-Authority-Analysis: v=2.4 cv=QP1YgALL c=1 sm=1 tr=0 ts=6a4ddccf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=194aVUXmFnt8K8BkqJoA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-GUID: nVkbb1uXUQNgPMdF8JSJh3e6GVSHIbnb
X-Proofpoint-ORIG-GUID: nVkbb1uXUQNgPMdF8JSJh3e6GVSHIbnb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA0NyBTYWx0ZWRfX9DEqzxaenO08
 +T328y390nDqH5Z/gCBPEkcpDXQuQn3FULi+dGUPfN9/YNf/tTR8DkrN0rWfAlzfiYLvt6OYQDI
 6jOFHkVusL0JxF/Yvlvlukcqp7YLsNSwwUbXD5rypngvF2IIUkuag4NCNYWk0iq+xFS6KFTOcV0
 5W5a5/xDXwF7qzwsJJ9UxdfMZJNF+ki+ovHBQ8bbaksfuiEuNAvy5CMRTCrp0MlZQLkTpx1cg9B
 QXZV1hF3p+r+a/7l0mfs4XVhWxQNueoOwrltVqYmCKQR97WUYfdxRL9mBbTJfpwcml557yuADy+
 JTl4O/sBP2FJ+QTX3BclWYUSYTVvPkUjhRLhXmNGwJ3gj9EQ81GCHTMA2ERLLGFWb1qXwfBQLRn
 Q4+Mrr1vqoI7SczMaZNw6iE8gHAnVt4VU1vHxl8OUSsNIqakPTM2j6CImveANwUrz4mxGDS1rmm
 oAVltqusmNV24HUrw9pDVuziaIgXjYIWwaySLEMg=

On 08/07/2026 04:39, Damien Le Moal wrote:
> On 7/7/26 19:55, John Garry wrote:
>> If the sd_probe() -> sd_large_pool_create() call fails, then we incorrectly
>> unwind the probe actions.
>>
>> Currently for the sd_large_pool_create() failure we do no undo the
>> device_add() call.
>>
>> Fix this by mimicking the handling of device_add_disk() failure, in calling
>> device_unregister() and put_disk(). The device_unregister() call will
>> result in scsi_disk_release() being called, which unwinds many actions in
>> sd_probe().
>>
>> Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> Xiuwei posted a series fixing this already:
> 
> https://lore.kernel.org/all/20260707030333.22245-1-yangxiuwei@kylinos.cn/

ah, I meant to check that series. cheers

> 
>> ---
>> I do wonder if it is simpler to always create this pool when we can
>> support LBS. We only create a min of two elements in the pool, so
>> hardly large.
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 599e75f33334..d18693d390b2 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
>>   	if (sdp->sector_size > PAGE_SIZE) {
>>   		if (sd_large_pool_create()) {
>>   			error = -ENOMEM;
>> -			goto out_free_index;
>> +			device_unregister(&sdkp->disk_dev);
>> +			put_disk(gd);
>> +			goto out;
>>   		}
>>   	}
>>   
> 
> 

