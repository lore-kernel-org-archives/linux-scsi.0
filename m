Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AB82135D8;
	Thu, 20 Feb 2025 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740072971; cv=fail; b=MNzEUjNBCyy59Qh1+k1GsA9k09LqVFWg/6f70hKb1GAOsrbKCenO3JNC7DfVc/AkItHRBak6gy1ULBBDgCdaz6hiI9o9bO9xj9PB4Y4LROJqT0L4BJWcn57bImsMHuLBaiqwlSHRywRTUoWk38wzNhSJwCefecN1XZFEXO2KTc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740072971; c=relaxed/simple;
	bh=r94W+Kkl9vn+ONm8vO9XklKF2mzegD2uHX76VDnkNLo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oMKZdl99cn7clm2UrAHD9h9oxz8DQbMlTemRl0dzNtXEjYP2TaSYTdb6zZpvllD8AIOqJAUymGlE9X5y3RB863tkTdIo7wVETz9QsbQ5t23mp3MQUZfB2oenLQz4vkm9yxNjWyCiHxpDz0gzkw171GIvDTU8uo9eDzWtUNgqYoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EcKDc8xS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kGIFmrd2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EcKDc8xS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kGIFmrd2"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51KFMaFH016961;
	Thu, 20 Feb 2025 17:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=C7w0YkPfc1FrHj9OJ9f3+CE9TzoqeUjDRivvKROlEa4=; b=
	EcKDc8xSpUZnejJRl2ioHzqWNEz2guFku4tUku3et5UX3r425tZQXCQTPMT4ARKh
	SiyP8UeyFOXUwm0iGm+CsCBYcNbVG+XXjkUeFE5/v4yZSGE01tdGLDh4rDle8PFV
	+NY3ERJ9XxlUbU6JvcyF2jJ+DiKey3L3zy69g3ZNSsDcIZIkJ7omqToaw0mSBOYX
	ntozF5hXZE4GDe7UciWCmgXUcIwpih6WTsnvqalsdHABwnHPMP8kOgKUGX2PKozm
	VycJlJqedUprYiqKhG3fNFHFIJm18ENxlU858ux5W5iDq2ylWxFUOqxl7swidu88
	E8+5FrJ8Q9ZY82ww6HZtHw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00nmqrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 17:35:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51KGks19009760;
	Thu, 20 Feb 2025 17:35:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09e7n18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Feb 2025 17:35:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6dHTUiQuWyiBQbDM55zn08a6JGQkqlhkVnkbVOrWK/HM+JsYRTfOGrhvYgTArBDqbfZA1xznHNdba59a2vEPAzsrZaL1FseIYhiBOohfiyD7nHuh2P8rGxL7KSt3vIuHES8GZ5PNIJKhz4ZQ7LpDjI5pnj1QQIdLTS5XGm6nkntdOTxnylN+dCuy940pZ1rOMk1tJhVpPiElhSPv9cuZ/KNz+w2cD0aFwg6UjrRmaz10CltXeeOS7Duaz40dOx+qBj8Y/3nu1KGLi5fgFEp8Z1LXv++lg3uHNwMZBRZHezrJIWDo74W4ll+sRzkb0c4copof0Z1VUBb5q9XRWg/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7w0YkPfc1FrHj9OJ9f3+CE9TzoqeUjDRivvKROlEa4=;
 b=rZeaS8yQBuLS9nykqDK1/CnL9D/WQRLhCYRYBElyBxmkXQNEPGFvERPxTodmNa/Ai1LKfTi8eqJyVgFo+mLog8VaPQZc8qOI7SyVAR0vpAxCgSTM1VUvYof4kDxw3HYECnD5H9wQ5V4oqkHw1kePvm9agee5bAv6os4gPUvtfpkhrY0YmGfD9fSOL93thvVCJh87wVTcQEaGHBhkeIadrPYTSp27xQlrgDAbmK+aKLcEdi49VT3k2fEUoIs+sBakDmBaPArV6dzeP08nLkWxkeMk8zJaZbnFvgSm4EWT73ird+qe3P7y35AXPq0cjv/Q/YnWYFvWScETxW8MmLCwHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7w0YkPfc1FrHj9OJ9f3+CE9TzoqeUjDRivvKROlEa4=;
 b=kGIFmrd20XJyu3lPGB3wB5yr+9L0nxqkQ/dzPJIx9DlDj+vFdo+881okeCv2eMl4Ko6fNHptkPLqPosEDP8wlgdTdDmIWjMn1wa01XjQ74n9t82IgDWgO4kE4bMwyWGfOQ5hUr8OjFDeqQPOX358iv0yONR6JGgCKpmKpEFMhoM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4798.namprd10.prod.outlook.com (2603:10b6:a03:2df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Thu, 20 Feb
 2025 17:35:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 17:35:41 +0000
Message-ID: <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
Date: Thu, 20 Feb 2025 17:35:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: Xingui Yang <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250220130546.2289555-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0341.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4798:EE_
X-MS-Office365-Filtering-Correlation-Id: 9931148f-93ec-4f5f-d262-08dd51d4ff65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTg3WEYrWnhaaWtHcjBubHMwbFJnSHBNMHhTUHBMc1hsLzRtajdWTTJGdXFN?=
 =?utf-8?B?Z0pnMHEyQ1pKU04rVnlGT1VITkQ5OGZLTS9NeURPTktzSUJ5RlNBQ0xDdlI2?=
 =?utf-8?B?QWJBTnlNWjkwWTRtQ3pMWmd6WUc4U2ZmVkdjWklxQmhrWUlxeDBGOVc3OWk3?=
 =?utf-8?B?cklqWVRmSTE0UVNQWUp2emMwRWtOKzBrQmh4QkJrOFhBaWEvM3ZjWlRPZWh6?=
 =?utf-8?B?RllXTUlWNVJKS2wyZS9jbW9LZ1BlTThmUzZvUHQvVnlUMHUyS2REaitXZFpi?=
 =?utf-8?B?OHc3alZraWw5UXFFcjZ0Sll4TGJTVWhZdE1nMnVmd1pxWk96RjJHVjJoRVFC?=
 =?utf-8?B?QUdGaGdyV1p2Vk8vN0VXL2FkMVlIMURwSGFpM0pCelhLaDQzKy9JQVZZSzFW?=
 =?utf-8?B?ZVZYaVZVdGRsY1d4cW5MUU82R3ZWa3lKT1dDcVNBRDVXZjM3Y2dJaFJRczZh?=
 =?utf-8?B?VTBzUGtPRmtxVGVBcS8zRFpITnBTVWJxU1A4Vk9LMHByQmxubmpSY1J5OUpL?=
 =?utf-8?B?N0tvMUdsWnZ2QXNReXdnQTdxcXdkNzQ2Q0Z6RSt1THJGaHprOHA0ZkNTeHVL?=
 =?utf-8?B?azB4cFZJQlhzL3RkeUpGSzdRdUFHNVhaeFYwZ2Fka0x3elhRTE9XYTBEOUFz?=
 =?utf-8?B?Z0JyZVNIUzNSRGJsejArbXY3cWh1anZBbisvTG5qTTBCYXlRc2VpZXd6V29F?=
 =?utf-8?B?alNzZm1pQUJTMUlYcnlnN1hlWjlWcllxanFTalVZQXhXRjRWL1ZZTFdmeXds?=
 =?utf-8?B?b0g4U1pzbnFaaG5VMmNpd0RxNENUdldTYU81bGd3VlhJWDdZTmtKM0loeENY?=
 =?utf-8?B?TXY3YmhSWElNZlo3Y3JWdThFNWVnZHJoQ05iNDJaaWIzeTZkMHQyWUFFNHpv?=
 =?utf-8?B?L2RXZ0hFbFh4RjIxdEpaR2R0ZGh3eXR2eSt0VXBPQUdVeFZaN1hISHdWQ0Uw?=
 =?utf-8?B?Wmo3OG1YM2kyeDg2Ym0zc3VaZTFMNnRady9oQzdyamswbnA3VS8vVTJaQ3RE?=
 =?utf-8?B?V2NvREpaTGc5KzVlQzBENDRldEdBUHFBbDlpcExtN2g0bkZOR05mdDViZTRm?=
 =?utf-8?B?VmgvVEUzc0xyUHhGb1BzeGsrRWd0N0g0cStZOGVVL0czelE4SW9vcXdQVTdW?=
 =?utf-8?B?Z3dxeTdSL3lEWVJjZmNrVkFJaUk2TlVZVTRESXRTWk9WZGlpN1dpdXYrSklE?=
 =?utf-8?B?WW5ZUVh4RmRYcFVSSXlqeGlMdVRqZnhyUnorK3JEVjNrUXE1MWN0VVpLTHYy?=
 =?utf-8?B?eFp6c0l6VUw3SkZqMEVmazMyQTJoNGZ6RTR6ajNDWGwreThQRGpiRzd3RUJl?=
 =?utf-8?B?OHgxVUEwejRLV1FuV05hTDJjK3hzT3pGWDJIT1hZa0d4SktvbS9BNUtzRWIv?=
 =?utf-8?B?M2JrK1V2WWo0bDhiWHBPU1lnMVNhSmwwTHZIS2U4eXk5Rkw3TVFFYktoZExY?=
 =?utf-8?B?ZVVMRUhsM0FJdWdzZ05JMVlFRzYzcWlmVk5JMmpBWnZ0ZjUxb2x5dnhVRExp?=
 =?utf-8?B?c05pL1I1Q2o2NCtrTGhqRCtjcWZSR1VFcUMyQXZOVE1kTVZGQnVManM2S2Y0?=
 =?utf-8?B?THRWbGY5cTh6N3VLSWpMb2pPVWJISmk1QWJnRG0rejhyT0QyZEF5d3JjeUI4?=
 =?utf-8?B?RW1BWW9BZ2p6U0l1YWdVUXlKQjhuQno5QmFKZ05KL1hxQmJnSWVFS1FmT0xI?=
 =?utf-8?B?NmM5elBBQmRaZlFIQkJYa040NUhiRlZDMXZiT08vRnQ1M3FWSXprVllFRmYz?=
 =?utf-8?B?ekdvdWR3aWVJZHFjVC9hS2FGQ202UFZHL0VJcGNyTVk3UWpnaWt5MERyMVRK?=
 =?utf-8?B?QStKc2dCM2Nkd1FUZm9KRms2a0pubWFlRHgxejd6S1JZdjliYmU4Wm45M0w2?=
 =?utf-8?Q?oz0QPxSmXN8cr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnIzazc4Vm56Ni9HRHRwTkpRY0hGMklWTjMrenYxOU85UWtYdDRtK2dnSkh2?=
 =?utf-8?B?dzJxZkdxeUZ6SzBMcmVzN04wSGprNlRTS2JJOGxmN3N5ZjJ5YUdHRlphb29C?=
 =?utf-8?B?K1RlL04wYkpCa2F4bExnT3ZDMHM3VGFnT2ptS2IzS3NHSVNVa2FWdTRhbUs0?=
 =?utf-8?B?SEwwdDVhbVBJYnN2UWJHeG5rbUdEV0pFN3hUOEtHaDBqOVhtbWpFcGpQaGc4?=
 =?utf-8?B?N0l4Wis3NS9kblRBZGNmR0d0Z09VU01PSWZHMkdtS1JUSVNGSTJTOUtvYmNa?=
 =?utf-8?B?bTNEejVLN3dUcWlzczYxTjVJNXF4UmQ1NXNFVkNveHlCR0JpUmsxajlJTlhr?=
 =?utf-8?B?MUhpNVE2L2xBMXd5K0JZWThqVksxMWlNeFZ4RWg5ZkVtZUZrWkxNNjZIQ0Rl?=
 =?utf-8?B?dWlQYldyS3lNZWdRNkhqMzBKZEZRSTV5L3h4T2UwaGJSYU9IRmpVVTRQWkZ5?=
 =?utf-8?B?TEpYMXFGSkUyRmFBaW4xVVFncTNMWlJKbUs2QTNNNUoyS3Y3YzBTRUR5Wndt?=
 =?utf-8?B?YUxuMmh1SW9PUU9kVUJEVklFSDU5UGRYUStaN0YrTjBoQURnck9RYWJjSHpx?=
 =?utf-8?B?bllmWlg2eUpSLzJUdDJ3NUNycGRTMXpzeE0xMWpyTDlKTkZvNmNrZnhYeTNm?=
 =?utf-8?B?QmM4M0xmNUhLNGQ3T2pTVGRrUUFUMU81bysvMUFMYWVpSXlWdGRUcW1SdW53?=
 =?utf-8?B?SjcxQTlNUS9FTFVucmQ5K29YT2RwMmk2UHpWSENJL2JDNUFsREZnN1BiWElu?=
 =?utf-8?B?YW9XSGxrdlJBdDFUcGpXdzJSQ3ZkbGhHT1BFV2dabmQ5YzkxWUovUXBlSkp4?=
 =?utf-8?B?TjZ2UnlSRHNZYVBPS2E3RE00cExscm9Tb3lIMDY4TFlVUUxoY2NMaHFJc0tR?=
 =?utf-8?B?ODJrZ05STTNVTDExNnZ1MVUvRUZ3bUJZUzZ4bzVYMVR3enkxaUhCdlpnQUpB?=
 =?utf-8?B?NWl6Q0IxK3ZpSWx5ZnNHL0FZQ0VBSHh3TVFHK0pmSkR3cGVBektOQ2ZoQ3F2?=
 =?utf-8?B?ekZscG1HdVdOWlUza285cXlDUjZvMTY5Z29Xd3pVdUpjQVFwOFN5MVljL0JB?=
 =?utf-8?B?cC9qa1RlNVZJODlrRkM2MjNIVG8veUdLSHhBT1d6T0huUmdXUjNjWEY0dW9u?=
 =?utf-8?B?K0t6NGdRMEJFNkZ6c1BSUm81YUxDUnZCOThPYVNBRTcyVnprVGw5RmRRdE1s?=
 =?utf-8?B?VldobFI5WnprQmFCbFB1TUhBd1p1cEkvTFF5dHhhMCtxanlxUFpmYUg4eEFJ?=
 =?utf-8?B?U2M1ck1PYVRlUG9pRDB2cmdvMFd0cFYrL3hMRFFjNUtveUpBSzJEZHhwVUY3?=
 =?utf-8?B?N3hiQUh5a3F1c1dkUTU1Ly9xMm9LVmNvR3kwNFNDa3JOY0dNbWsya3AvYmVM?=
 =?utf-8?B?UlhtS3BLRjBuUEJkd0hjTmcweXNWWXVPOUk3QkJ6d1UxaDRvY2hYL0g5Z0hM?=
 =?utf-8?B?aGZjM0xhaG5pQk9WL3gzOERZNklOSCtSU2JaeUdSMHA1OVdIT1daallJM3d1?=
 =?utf-8?B?dFIrNlM2RE9aWXFnZVJYSkMrSWd1NDFXTG8wcnF5QTltN25EZndHWGZUR09U?=
 =?utf-8?B?cHFZYTJJOWtUeTVnci8yZ3pnV1BaLzliVVVnL05mdzdieG5CYURoL3VHSWti?=
 =?utf-8?B?NFhRRSt3U29mOHpOSXM4dGNOWm43bWR2VFhtZkhPQ0VsVDc5a25tZEZsUm90?=
 =?utf-8?B?UVpFa1RhQWJXckNVS1FWN05ONnFodjB4R3JZRktaOEdLRlR4ZHpNS3dUNXlF?=
 =?utf-8?B?NWF0eEpMYjhJN3lFcGJBcVFHOGNBVGpsS0Ridy84TG9wUGpZU29ZTHhJdytm?=
 =?utf-8?B?dFVnS0ZFNXE3dUljOS9LUUJUdEZreUhVTThremc5SEh2Vzc4WGFEMGN0TnVx?=
 =?utf-8?B?UFNUd04zSFVLeVRkQWtwNm4vbkkzcjFvWWNkWktTeU5VcFRMUFJybVJTbnVH?=
 =?utf-8?B?NHdLYlJkb0tZemFqTEZBOVRXTGE2Tk4yNjV1MlNuQ3VYT2IrR0xzNXVKQ2c2?=
 =?utf-8?B?eEwzelQwcStCcndHRGNsV1AwUUI0M0d1RzlLYzJyU0RybHc0YmwrZkdkUVV4?=
 =?utf-8?B?OEg1M1IrVUZFV0gzY1YyVzFJY3BEZmVBL25BWk9HM0swVXBXMXZHbEI3KzVN?=
 =?utf-8?Q?PdMlGbhrYPPwmDS94ZxWM4xsx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0+ieu1EytnALGLNgR89sc6Hkdonsx9YPr5FqjaOKVZyq+xmqPvtlf+XrKAPoxImoIvW3tqCsKaDsq03WyKNUAzBBmtKehTA4e72U+Ro/fwYExnL7lt6oCpIm8/FHwJoqmxTF3qBhMluMobo+GKnRXIW8MEnC5YsIsMjDLbfQ4DJUO79vKasrCEyPOyqW4M/LplWyQ9DZ+X2waeyRgN4tb1XAyQcTahjy7GYuRm1Pgukigp64GwxXhXhEKQnB5YRGft40QaDBNplImYwQMb4pB2BDjhrrPyKCzfVSZHhKHAMzRuSEk6DuaEYol46b3Sn8D+uPrr4Vtd1Ve0+i0e7cBoargBhfWopzNwwD6O6BHAa80vjzm3KPM+oS62DpPcPQrqxJVSrFVAkoW7W1Z3U/px57/1bz7n7wRaYIv/QwdTK7Cb9KHJL5BB11IuZPRb8MELM9RGdBVGpn2HkQXEhypW8ZYGPgEd+i7aWAcqCXuU7peOOzkrCWGupsq3cbaiILEbwjncpz2i6YY5WMDBqYg2PJjVbL8eo9ATU8AxOLmdg+ou8JaaZFwuPHiKln95cA+IKFjX/v2USqfvgMUKk38ORYhAITWVqTkaVslSET/mE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9931148f-93ec-4f5f-d262-08dd51d4ff65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 17:35:41.8775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDye5S1Nng/oOW6kLb2jSQ2YHfJWaKpGiuknMXmzSQ7WMTgZPj6wKpgNqQ1EQXZh2fNo7P6Aiuj1n3ECeNEhHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-20_07,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=965 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502200123
X-Proofpoint-GUID: FBW3ZaVyv2nHmqR45OogmEejeLHZQg5P
X-Proofpoint-ORIG-GUID: FBW3ZaVyv2nHmqR45OogmEejeLHZQg5P

On 20/02/2025 13:05, Xingui Yang wrote:

-john.garry@huawei.com (this has not worked in over 2 years ...)

> the SAS controller determines the disk to which I/Os are delivered based
> on the port id in the DQ entry when SATA disk directly connected.
> 
> When many phys were disconnected immediately and connected again during
> I/O sending and port id of phys were changed and used by other link, I/O
> may be sent to incorrect disk and data inconsistency on the SATA disk may


So is the disk reported gone (from libsas point-of-view) after you 
unplug? If not, why not?

Thanks,
John
