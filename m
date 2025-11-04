Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BBA3126DB;
	Tue,  4 Nov 2025 09:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247606; cv=fail; b=bxVJiV2r19zk/G9YtA7ucS0yJJtshnCL63Ez/i7VqhRSmTnX+wVFlDVVU8KMQMi58bvZ0MtHTTegCCOxs/hMkIkK04ZEWIR9fFVlmBXQX4nXw3tvFldgi+RVLAb/HutqFopl74LYcAskHAMIe5P2F7l5lkamscNwizux1UPz438=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247606; c=relaxed/simple;
	bh=B+CyqonFCM6rrHHVkUMqPBWfp0CSCwLiI5xHHjcfVIk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mJl0LOgrnhwwlZ3XL0r05iOzi9yaPLGViyGAaKyGnBT9tzil3L46fHMEONKMfh6iWQhezf2xR9WV4ex6Ysd6ufuNHdpErTfC/eMaW+Lt/aHrW6M5MNwo6xPINuPPqLiGdXl60H9fN1q4Mx3+PpgZ7dea1gDKjTtDWDSLP8EJsNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RuP0thJF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zlhyxHU0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RuP0thJF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zlhyxHU0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A48xU6F013323;
	Tue, 4 Nov 2025 09:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=utiS3j7TiRED4N1z6a00eRArUGjBsA2eTc1hcHx3kNU=; b=
	RuP0thJFK9J1w8xot5eyL/GMFG6m4A7buVrJlJjk+fLoDZAEeB8npyk9DAYlx/or
	HzpRq3qN2OKVlQ5/kpg9ZIxLsNZw/AGQlHFEgtSsSRN7VCJMkTeqoqNPypopjJZy
	MLVnjLbR9andliO787J7GAJQW+uaSPDoVzWHbExAI/ALyZ5hviCg5W9mN6kadUSF
	SP4bNQLXXEjqhArpI75VAW0Usqp0LaVXTeMSSCf7SVr+LArgIA2nxD83gZvQ3GFE
	tulN7yinfHfQOncWaxTWBnJoPtPIHQLQnpkGJOkqK9EvIq3FI0XT1gAhIXyfuJK6
	Z3//sN2CZJU3mmNseWOALw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7ef6r17m-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 09:13:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A48KQRc017251;
	Tue, 4 Nov 2025 09:10:58 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n92q5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 09:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KAyMOKbKsfdcPX6WPz3qAWIuE7yCylbYlG/RF7v0OHe5aS8ImT8F5tPPcqNdb5e6e9oGHZ33zPvwZDyeeWHbwnzLejzpKK93oXhql2YX/MNJAlxUhGxJjqUbTxEbTy9+byPNbIUzdqUOhaUtE9UMn2jsFO0+adn5jHhDgzLRpwusZMI2waHQzLicpylGjqrasBDbAN+/+1ecuPSWZdv6EROFa32dVuRwEi41oCkvAJ3i9xJOfTNwlC8hj28zpS966Y2XPLybxGdNs1XK7VsKC4P1jss1M1Fh5z84+lf1hetLOmFiCgB/AmnTKBBjHS9NOz7SBCOYVOnVFw2d/iKESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utiS3j7TiRED4N1z6a00eRArUGjBsA2eTc1hcHx3kNU=;
 b=QVscDzhK/ysuaYLXbx9LrQ36xr2I7D8jYk1LucFsMamC5HKDE/jzg8+WcM7ajosylizoddXf1A6jR2eyNHFBXiFMZ8ZfnpA+EoFQv/MlmHPcv8f10petiGnaDscxmzjJOnZFRQsxcRNjcIItwyY/y7e2pWOPYiH8z0oAnsusItMm45xEFpVijZtoapZ+pzZJ+PrxZXavs2CEvLdsZXfvB2umk6ataoCfAhIhB+bnArAo2jVt5QhzZBMR+dj7H1mMM7Qu4c2iSmi5fvAZZWMMAdn+tiUbvdZy2y+wR0QiuvuPRvhj0pMIxfnTgdQs7MJrF+fP4tSqzfmQNaimShkhfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utiS3j7TiRED4N1z6a00eRArUGjBsA2eTc1hcHx3kNU=;
 b=zlhyxHU0whL4ZKRUD15/PirKqXdT3LL+wBAJTYfE0hMpPqwV/CMvqhcIiDnAtXD8sVBjsK9AEY/4PnCxdQGflNxllSB6Uy9/tQEvYdVhT4OLQdBQeFQ9Etn1HAqOkZDDeI9avFD+t8mKgpQal9/wK3Ew9pPBIYjYrB/v61gEY3Y=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB7694.namprd10.prod.outlook.com (2603:10b6:510:2e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 4 Nov
 2025 09:10:55 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 09:10:55 +0000
Message-ID: <c911b6fa-84d1-44a5-a668-6b46dbd00423@oracle.com>
Date: Tue, 4 Nov 2025 09:10:53 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: ATA PASS-THROUGH latency regression after exposing blk-mq
 hardware queues
To: Damien Le Moal <dlemoal@kernel.org>, Igor Pylypiv <ipylypiv@google.com>,
        Niklas Cassel <cassel@kernel.org>, John Garry <john.garry@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20251103170308.3356608-1-ipylypiv@google.com>
 <51db9579-f78d-4192-93fa-b252fe954d13@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <51db9579-f78d-4192-93fa-b252fe954d13@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0210.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: 207cb191-3595-48df-e632-08de1b820f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0JxQTY2MU1kWWZxdExrK1pCYWNxYlZwYnpVM2lSQzZMUVk4eVFxdDFkejcv?=
 =?utf-8?B?dngzZTFYUmo5Z01tSnZzeFArbzhQMTMwWVZHdWIyZnBQc3g5TXFhZUhJZU5G?=
 =?utf-8?B?bzZFeEF0MVVzSTQ0dG5WV2V6L2JjZjN3bFFOVnZ0ZzczUmg2SUVpeWVzUEc5?=
 =?utf-8?B?cUREaHA1MW5GcDRMSnVWczZoQU5sSWZjdUVZT2JQeTFhWncvTWV2K0pROHJ6?=
 =?utf-8?B?RUtBUjBLSm93VHFFa093dGV4ZG9KNDhKZ2dZdE9NN0NEQXRSNnJLOVZzUkpY?=
 =?utf-8?B?NW4vK3FuVTllaHBIWWlnaWMxRkkyYzlDVk9oeHAyU2pZMnRteHB2RUc2T3o3?=
 =?utf-8?B?WEg0eE1lT2NuTVdNdjNQeHhpWlIwWHBCN0xXVmdvdG8yMm1mV0ZQV0d6cUZL?=
 =?utf-8?B?cUxJRXRxckNJckl2eVpuVXEvNzF5YmdxZ1MycmY5Rm9WTHcrS29PL2k2Ti9V?=
 =?utf-8?B?NURIYWxKSmFLKzdrWEdUeVRSUTdsY1NhK3hzVnd4cXdWcXloSXhPdTJ4aXgr?=
 =?utf-8?B?RjdOblRsVU9DU0o4WWpxYW1Ia1M1WVR0MlZGWjRYYlV4ZytoTnFaSGVCcFF5?=
 =?utf-8?B?bGpLOHBQVFdHYXZRend1eUhnZzZtSlVEd213NDhBRUk1M3RkeUNQNDFzMEJU?=
 =?utf-8?B?K1ZlRStUNXA4SFoxRnZEOE1RL2VHTHBSbjdEWlc4RnhQU2d1OWR4b2RDMHdK?=
 =?utf-8?B?SldrQ3VnbHlHSjg4NitIK21QWTRYMXYrZTh2MjJxeFlsMlcxZTdlbUI3bGRi?=
 =?utf-8?B?MEI2enIvU253MW82T2Nnb1FHQy9CLzBVMzRrRG9ZMG9UUjBvMndua093ZXZI?=
 =?utf-8?B?Y25uZHVEdG5CSndsZTVXL0YrUVY1NjZ2bTExanlNK3oxYkl3UFhjdnJPMHJC?=
 =?utf-8?B?d29WZ3VCZk91UFlWMVFvYVFPMU9aSkQ1cWlMZSt6RVpqYXJqVm5nRzQ0a2RQ?=
 =?utf-8?B?eTBEQk9iODk5ZGFVbTlLS0ZWYXN4b3FiODltZkJPVTI1cGl2TTdBc3lnMkhM?=
 =?utf-8?B?Y2pHNVZFRmtPOGdOdlVWbDlnQ0tpV3VOMDJveC9BOE5mLzczNW1CeDNTWW1m?=
 =?utf-8?B?STJ3ZWpreTl4TFFlK1Q2SGU3RVkwV0FjWkNQL3BRSDlacXNodTlKRGk2S0Zk?=
 =?utf-8?B?V1Y3cVY0MElMaHRwR3gxbEdLb1lJNlFxdjQ2a1ExUnpmTHdma3Aza0RCVHlY?=
 =?utf-8?B?YWQrTzlEUnd0Mk1VdFZONlkwZzZzam1zZnBvQStEditRTC9OVnlnSnlLNEly?=
 =?utf-8?B?WE5DcXBQbEN5eEhtb2k0RzlxTGFiTTA3dVVSY1dQTmVBa3FzdkEzZFdaTGtE?=
 =?utf-8?B?OFFLdWEyRHZ3b3V1ODlIc091MjJnNEZNOWkwbEN5RkZpNFVzYk1OZ25WTmt6?=
 =?utf-8?B?R013YjJKWUFxY1JWa3p0aTdjYy9CWk1ZSzVxdEVIMElyN25BVmU0M09rYW0x?=
 =?utf-8?B?Z2dFZ3J0L08vMjV5Zk1LMmxZSHFvbG1uODZWOTIzSnovM3diRnFXVEt2UDZt?=
 =?utf-8?B?UTNpSkVUeVd6Nnp0cThpYzgydVJ2SGlwbXphaXNINUhTdFJiRHZlQXFFMGpI?=
 =?utf-8?B?M2dMSlNUWUhUT0lVL2VjVWJyL1p6S3ZUUHVxQTRnMEIyVm1RcWI3WGJ1Vytr?=
 =?utf-8?B?bVBUMVFrdmp1cm9BS2swNDZFZ0lwTndtQm95eHhIakQ1Rnh3QXBYM0I3NFd5?=
 =?utf-8?B?NXhFNnZDY1RmdEJmY0N5c3lRME5QMGZhb2RYeVd2SzFYeGVGL3JRRzlWQ25Z?=
 =?utf-8?B?RlNmeUk0SVJDaG00UlNlaFZkK2haMlZXQXRESlJNVU5HYm15UHg3SGJGRWpU?=
 =?utf-8?B?emtOOXgrSFJRbkhEMDJyeDhWSjlIeDQwS1hFRzNtb2JTcVRYU3l4SXhmYWh6?=
 =?utf-8?B?S2xoN28reUxuUGVOVG9HUVBqV0VMR09ZSjRvZldxaFJhQlNyYSs3MkUzL3lI?=
 =?utf-8?Q?Wthhmx4y26xDn+wkaM1r3FZJTDsW2Rxe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnp4a2VNYTdaak1oaUR5cHBVZ05YaUFraTEzL1FZYjhmK245Rzd0Zy9QVTBo?=
 =?utf-8?B?OG02eVZJcTJuUjRkS281SkpkTnpKS0tGZlBqeFZaeGZNUERkTFlKcFgyRTY5?=
 =?utf-8?B?OHFLMnVhUU1tK2kwZnpCVVBjVm5udFBWOUluQTY5MTlibjhsTTNjM0J5N0pU?=
 =?utf-8?B?NVZ5YUhJZlNPQ0dtM1Q4YXZvLytxK21oWE82UFRkNDJ4T2dkeG1BYXZUL3FZ?=
 =?utf-8?B?L2VkMzQxS3RiOC9EZjR4Uk1nR3l1b0lMbm1MV2x1dld0akVlY1g1aHBPM3dF?=
 =?utf-8?B?azYwdmM4OEZOck9xQVNxK05UMkh4aHI0K2c1aFByQ3cxT2N1djZUSG9RRHAv?=
 =?utf-8?B?c203eUd4WGh2Q3F4aXVzT3oxVHk4RSs2dm1vZHdtajBmTFpyTVVMRzBLNUxy?=
 =?utf-8?B?U21yNGtXeEZTbXFTQ1hDM24rSmRhR0xDRzFsZjk3Y0VEazZ4Tk5saEVWUWpp?=
 =?utf-8?B?MElQZTBKZUh4ZEs3bFdDNnJUQWxMdk5rQ0FMbElxdWFWVWVWU1h2WUNHcHBX?=
 =?utf-8?B?YlZMK3ZPc2tEK3ZOK0ZxN0kxZVNHR2lNMk90R0tFTnBiRC9tdWJvYVR5Y3RP?=
 =?utf-8?B?YkJmaG9tSFI0dlZKQTNHNGdFYXdVZDcyL3liWERqYTFXNTEvMUo2b1VUcWNr?=
 =?utf-8?B?cnZ3Z29USGNzaXg4eU8rTzFLYzBYdlhTWlFNS1lFTDlnTFdMczhqRXNLMCtH?=
 =?utf-8?B?NGtEaTl3S2JZaTNPZGdBOER4THYwTmZJNHJaN2NDaFh2TVhzMTRHZU1Kd1Fr?=
 =?utf-8?B?cno5NUdMNDNteGs3QzVjN2hjQ1d0WWpjbWUxNXN4SE1QMktUdElyNmg2VTdG?=
 =?utf-8?B?ZXUzaXduQ3FrbVYvUWRvRlRGM0tXd0U5RkxhSEdLNVB3bDg3ZVFGZnpmZE1O?=
 =?utf-8?B?cVQ2bW9HU2dTWHl0Q1dWSEwvZmZlc1Y3VGdWSU9FTWxWZ0dHOWp1T3J6WFpZ?=
 =?utf-8?B?eXJVckFtcStCRTRINTVnREg2NUdCTTRVdTNuRHZzMlZnOTdadks1bFJVa0xs?=
 =?utf-8?B?aUZOOWZyZGxacjdWY0NuOXV6WkgzMC8rRmZjQWJ5b0dsNGNzOEZHamdMb0N0?=
 =?utf-8?B?bXQvRFJkZ2JTVGVKeUl4Qk9xQzQvTUNtNnFmR29wRFVjRHpzRzgrVFUrVGt4?=
 =?utf-8?B?VGg2ZmowSmdEV2ZNb2dETEZwYjdYaUlhK0d5bG1GNmh2SDFacGlFVS9iVUFu?=
 =?utf-8?B?Z3kyMXRIRXhWbThqSkJ6N0E5ZER0aDJNN0dqQkhlVGd3Q1hnT0ZyaHRTWFRa?=
 =?utf-8?B?L3E1ME16YTE1dy90OGVQZkxSMldCS0k4K1lHUnZCZWlzbXkvVnVkbGtRNm5x?=
 =?utf-8?B?SDZrVllub3pqUzFMMEFiRlRJcFRGWHN3c3Eyd0FkR29GL05zdm8zQ2JRb3Jn?=
 =?utf-8?B?WTZzUkhITCtiMTZkK0dNVXVPSzBHZit5STQ1cFdhaTVLS05obHNQWnVrNUZD?=
 =?utf-8?B?L09GTlkwY2t3RG82K01Yb1oySUxXWHlLUHdwYUxvL1d3OUkyMGpraFVrZ3Rx?=
 =?utf-8?B?a0lzRTBwb2U4by95Y3FBNGR0SnlXTkY5WkdiMVV2MWhGTFh4K2g3NWozMGJY?=
 =?utf-8?B?YnAyRGpHZENPTDFPdGVZdkFNN2laclorV1NIMG5mOUVkQktHSEtPWUVEY3JS?=
 =?utf-8?B?R2VIVDN4VVJ6QWpqTW1pOVJNSUFEUzlQQjA2M3NNMUVzMSt6OS80SEpVSHhz?=
 =?utf-8?B?b05sS0FMNmxHQXZrbGU5RURPVWMzNkh4YmhHNkZ0Z3M1QUo5bEZVU1pEam5n?=
 =?utf-8?B?NUZ0UXgxSHJWbHNvaVA3U0ViYjVCeGc0QnROZVlxRFpyY2NBMXNmREtIQ2ZH?=
 =?utf-8?B?aTNGMktQSU9qcUphem4zdUVZSU5tS2llRFJSVXN1b1lzeUl3NGJKdSthVWRK?=
 =?utf-8?B?QlduUHVUNnFDRi9qeEx4Z0tiTU5oWnF5anBUdERJazlHY01UMStSNXhRREMw?=
 =?utf-8?B?OVFNdmZ2MXpFdk9ERlkxOGxhc3JDeFl1WjQ4aVpZTmRJakp5Z0hYL3V2R21m?=
 =?utf-8?B?TEEzdjA5aEFaMnRWZmpyT24ycnlqTzBDbVJEUXFsZHFDNHlhalhiL1ZlQTht?=
 =?utf-8?B?THNlZFBvQzdZTklkNFlUakZMZUwySUEyZVUxTjhuU09lanFsNy92c3pUeDcr?=
 =?utf-8?Q?8jchivM/T4cUqwmbVigDobmrn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	65kziKSdG9i/M6cV4Zyr/AVAxLnQM69Wy8/AhhL0MANNGRQ/tNhbyagCTw4nb7F2/Ik0QRIhZQ5UC841spCvpQ3ORVe9R6XmNriygIhsADu8Oe64KIUvh9mkoRD19gE1PZ+B8VMOzjjuCl6ib3B/94DXBnYBIvM7ZYKbzGLhTvFajk3cKdaEkQBDFflZ4pVOhX3cqqVPhMB61k6Xzrc64d7j3tdHCVIaxY4ip1/ivUX8+YN7zWLyJF82voYZtu3j6E0fSju3yYFzDr0YMNT+vsirsMaMJgk/3x5GZ6/XXQxz9tKh+m/PmbDcU1eaPKenx82LWLg16cT03MfX/6i1YpGBvMGLtonAXggyk/LIo72c6zUddmpHvYiw61FrXEymajajQf1pgqgOVoDkwLO7/gCZJhaSIuD8RtoxyNkxl5Pk+EXZ/X6o036BGTJ/ySNsZG86yE8tXsy+i5ErSCCdoDSw5lEU1I3Q248SFId/KqnhfxPZyXRrh30mfmHgyV5aF3Rjt2EJSVrgMWE9Oii382iQSVZnBZRyYqXo2Lsarx8erd7Jt2gweLc6JbRl263Z9MXIhEaq123faUStfnaDUA6Xi+kTQ1NtPeTD379lRp8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207cb191-3595-48df-e632-08de1b820f74
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 09:10:55.4483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NesceRxuTb1zPnI1CNRKPF1Hlk0oLOFuZI1id3jHDMgtIQ08QlvciKtO+3jh/hGPefDjC3hQo1DiydCFTigKkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7694
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511040074
X-Proofpoint-ORIG-GUID: 7ATdDsUGM2E2yQK8ZeGHRoD7wII49ksK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA3MyBTYWx0ZWRfXzbH8goikA3Fb
 3iG2zlo2uVJmPM2qv20AaC0egu6xx6WXbk62sRiiAUU36Sjd66i/iL/2Urd6C6PCym+tTmniDzY
 KQxQ6CLZZ6Dlp5FsvS+kfZu7h21HgkCm9ggtQ4BDS17l4+iDCtnxLlrGLvj4D2ckxbJlDN6GruW
 v/ijF8OwiWL3LDsO+2Jed314GCONxgNLjgoHLlofLfXnsb++gYYGdFnUzk2OZ+1PqaBJYsukLM5
 Z0ixD5+e2g8+7fIX58YKw9hXAA/TmsWxmrdE6Mm0v96EMjQWWJdMkpI5g0vb7SdAnQlTVFeA+KZ
 VOTTpx9JrNp1kYE69pK2tV8uL4JoVczh2x4TgFcUvIIq64yEBr03807YvIC6mYGg3hUWBT28ZrV
 uFEx4j1+c6i/tc02FCUEmZYFMKXoRg==
X-Proofpoint-GUID: 7ATdDsUGM2E2yQK8ZeGHRoD7wII49ksK
X-Authority-Analysis: v=2.4 cv=NvbcssdJ c=1 sm=1 tr=0 ts=6909c3aa cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=quxLGrKQVIPRd_lxYYsA:9 a=QEXdDO2ut3YA:10 a=HhbK4dLum7pmb74im6QT:22
 a=cPQSjfK2_nFv0Q5t_7PE:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22

On 03/11/2025 22:51, Damien Le Moal wrote:
> On 11/4/25 02:03, Igor Pylypiv wrote:
>> Hello,
>>
>> I'm observing significant latency regressions for ATA PASS-THROUGH
>> commands that started after commit 42f22fe36d51 ("scsi: pm8001:
>> Expose hardware queues for pm80xx"). It looks like the libata's deferral
>> logic that relies on returning SCSI_MLQUEUE_DEVICE_BUSY does not work
>> correctly for blk-mq's multiple hardware queues.
>>
>> Here's what I've figured out after some tracing:
>>
>> ATA PASS-THROUGH commands get continously deferred because NCQ queue is
>> not yet drained. At the same time, other hardware queues (other CPUs)
>> keep issuing more data commands effectively preventing the NCQ queue
>> from draining. Since NCQ queue is not getting drained, ATA PASS-THROUGH
>> commands can get starved for a really long time e.g. ~5 minutes.
> 
> We already received a report of such issue, a while back. But being busy with
> other things, it fell through the cracks.
> 
> Note that the issue is not just for passthrough commands, but rather for
> commands which trigger ap->ops->qc_defer() returning true, that is (most of the
> time) a non-NCQ command issued while NCQ commands are on-going. It just happen
> that most pasthrough commands are non-NCQ.
> 
> I think it is time to address this command starvation issue...
>> Reverting 42f22fe36d51 seems like a plausible workaround but I think that
>> driver might still benefit from using multiple hardware queues e.g. to
>> issue commands to different drives from other hardware queues. It seems
>> like there should be a way to drain/freeze all hardware queues before
>> issuing ATA PASS-THROUGH commands but I haven't yet figured out how to do
>> that.
> 
> Yes, we need to remember the fact that a deferred command exists/was issued. But
> that is not trivial to handle unless we introduce a workqueue in libata that
> handle these, draining the queue when needed. But that would mean that we keep
> on hand commands that are not being issued, which is something that the block
> layer better handles (with a requeue).
> 
> So in the end, I think that the better solution is to look at the scsi & block
> layers requeue path for deferred commands and make sure that these commands are
> at the head of the dispatch queue, always, to ensure that the next time they are
> issued, they are issued first and will eventually get a chance to run once all
> on-going requests complete.
> 
>> If you have any ideas or suggestions on how to fix this issue and/or what
>> things to try, please share. If you happened to have patches that would
>> fix the issue I would gladly review and test the patches.
> 
> Let me see with Niklas how we can handle this. We'll send something soon.
> 
When one of these special passthorugh commands is pending, can we defer 
NCQ commands? Or that illegal?

Thanks,
John
