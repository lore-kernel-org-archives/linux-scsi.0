Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5F5128376;
	Fri, 24 May 2024 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716539828; cv=fail; b=UdM0LKbKTZoVMporArqC5zqDX1V0a+qTA2evCsBHRfQ4Azkt6+rkV+zSgwRrFcw46zN/rog/WNxsOVxrvX6mOuncTKzq0HmZxr8jpu4n4Ky+ikzWYhmRMlLLrP1nOk4cmr9L18ekwprh/I9q12v2UFSIQzUHDMYjvQBmt6Tgeg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716539828; c=relaxed/simple;
	bh=RlaGNl5jGSihkSffz71EzUmUZRS08aWUWz4hBO7j0jY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i7QcaB+I7Dgpbn9x7ZdpSxnQckNCqETZygJe/RG1NzRCqAD2YDwohkOnKHuMEM7vMhRpwaNFS3oDSkMWerDzMxRDQC55sj8U+R6csfZpi+tvpK0F/GU0XlP51FKB8ITmgsHZN5tnqk9Ilky18IzBUY9T21arYNUfWxeAf/0PnUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U2E9rWRo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u7MXn7GI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U2E9rWRo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u7MXn7GI"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O2U1Uu008765;
	Fri, 24 May 2024 08:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=CqKLKw1whcMf2llW0ysG6Y3xYYjHmXazdCAaRT6piOs=;
 b=U2E9rWRoxJL/tQxyEdG7huQtwXsLLTbu8w4x51GEcNz2O6SkTnQbY6UePoP5Xg2WkV/o
 hLyQfb7i8sSGkAQdDERwUCpVgue9qYiTp97aAX7iZ+ASxg/lD7s5xWaF0EagceAiTxBZ
 F3nrohILNEugtLQmfTUMtNTMvGYcqjcgEJC2P1wpNpIIxGf03YkhdfT8tLKmUphZi1HH
 vDVL8WJiapxNTp+dWXd0Ks0kn2bAeXlT3jzkUsBaUgg0RP9sTl2Oa+b3BPqNVbmjnQj5
 hDkyAJqghYkaFytg5bblyK2jjwjcrPt5odQeEFkbKKwD004RTCBz7JYpB6ug57A7Uv6B UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvvbwm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:36:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O860F6005079;
	Fri, 24 May 2024 08:36:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsc1r4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:36:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKFXKcEBj4qiJynKGWSBGwhRhVTIm+1TCM2J/YDUOmeHS++tu4pALKniTawub4qW/kYFc2yIkvmmjoRLa8G+Y0sgrnhQ6B1DnWWG0vXw65VLCnVQQ6vfnAbM6t1uEICPqAm6M0fiP5eySH87xl6qfpCvO/CTZ5cFnFCtxtxZEozayY/xRid5fy68E5USgibxbghhu2viViutmE0fnmxLtcgPRXcOH7tAnwve2PC4AEVitKZULDdRaxjn6/xCYGG/IKq72pghiqeMBh/oJLv55tU2zxEYIGpAfwdTQLnrZ+uHJYTraPwywQ+aZ6zpwNYUnzNOMhBXh44PNy73SeYVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqKLKw1whcMf2llW0ysG6Y3xYYjHmXazdCAaRT6piOs=;
 b=AKfwXhdkUjdGqoP4qwQtYnGCpLbI+ccMdewRGIzYuIFmajK2rJe5LwxFxduh1Dw6AKoufqk4sh4XkJiE8Y+2P5lhhaITKBUzfq0PsKUgBErDTMXrSi5dpnbj5xEngOTcbvqm8Iihi7GOHLMrys2K6xAbXby3tGA4BJfH+HFV87a1JGKEU9PgYA1cHp/jg9ZW/LSJBJWNzYblxWXlouUKGIKtps074sGqfgJHpxSfeaN1hFutDZzD8aUl8C905Wsjyj3JkBNLLR4EspKjXGjWlnBR5fQnK1TVwSkWLxZfecYulX/O/8hgbG/8kQG2YV0NqDYX+RWF+O/1K8bsPnJQvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqKLKw1whcMf2llW0ysG6Y3xYYjHmXazdCAaRT6piOs=;
 b=u7MXn7GIIAx9oiI+lQOh1r/MAX2v5xizl8Vkbzid0h9uMb74vCJrNENJo5tAggG4Awfjr6YBO2Wnh+MF6+OrYvffq/nkSc3DZIPS7g7YUXb9pEQBLSSov66Aygqro0l6gxxNVCEXqItBSYcxyg55a7rR7xVuFRkLLZkPKI1RRCk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Fri, 24 May
 2024 08:36:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 08:36:45 +0000
Message-ID: <824c34aa-7c4c-4edd-b41c-f9b5ff5aff03@oracle.com>
Date: Fri, 24 May 2024 09:36:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240424080807.8469-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240424080807.8469-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0004.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 60ac42dc-737e-4f45-4e42-08dc7bcca51f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?TmRYcTdyVzI0bWp5R0pTNWprM25XUzA1YTdoWVQrS2RuLzhVY3NGeWllbVZK?=
 =?utf-8?B?Y1FWU1p0WStzbzNHcStnWEhzZTh6S05OcGE0bHF2QWZqZjBRSndIblhOL01j?=
 =?utf-8?B?RUZkaU4zWUc3MTlhQkJGY3IwMURJZi9lbFRxc2daR1hvQTdxd0dweXA3eXZo?=
 =?utf-8?B?RHdicHZPTXV0NER5VHRKTEZ0Qi9ReHBSL2FFQ0w0VythODhyMjcxS3p4S1Vx?=
 =?utf-8?B?VHd5bFBBSDFtRGE0UG4vN2hKYnRnMS9samhkYlNkTWxOOXFGRjkxUlNnUWpn?=
 =?utf-8?B?M0xOcXM5Ti9lUHhqK3prdkhSNGlKRkI0V2MvY2tKK3lmV0FROWtWYnZLWEpF?=
 =?utf-8?B?V3ZrdVdoUTh4T3haU1dIeDM0N2N0Wk1HKzVhcXFiVmtXdmVwVnFnWXN4TTgy?=
 =?utf-8?B?Rm5LN3FjM0szakdXVTdDWFRITEVJS0JUVUE0aXBnSStYYUsveXl6ajdkSXdJ?=
 =?utf-8?B?NHExbXp1UlVKU3AyYzlWSjZwQ05Hcko4REJ6ZmZZT1BteUJQWmxSUWxtamIv?=
 =?utf-8?B?VXVmVWQrU2FiUXFTL0c5OFVHallId1ZYY3YxOVd4TE9uZ3ozL0xSSGVuMytz?=
 =?utf-8?B?VWhHVFBrbDIwSHlHQlRUOXhlWThobGpPaGExOEdXRTN2b21TVEZTTXRRamhM?=
 =?utf-8?B?dk9FbjMxMG0xTFZpMXVZZStIajI2V3o0dXdsdDYzU3UxSEpEUE9oaWVLcE9X?=
 =?utf-8?B?V1lOMUJkM0ZvRlVHSFNMNlhsTkhoUjdiN1k2dVB5bnQxQnJ5eEpRZSt4eUhY?=
 =?utf-8?B?UDVLUlRIMXBRQXNvaFpKZHErNnFYbmRHNUtmdTBlZG5ERWx5cWhNMmFDaktF?=
 =?utf-8?B?akVjVVJoUUkrQVArVHFjRHlPcG1ha3RReDNZbjYvdlpmYWVIdmkyQXc4c1Nw?=
 =?utf-8?B?b1FmV1pDMVJzODJPamNoNndFS1BPdjVERXRKcjhZWVFVa0U0cjQzd3kweEdD?=
 =?utf-8?B?N1l0azNoaWlXZUJpemdLM25iVEFoeEFFWDlJQ3FCREhZVkdBNXhtRGhBemEy?=
 =?utf-8?B?Z3c1NWI2dmJYSEx5RFY0cnlwdXZVa1NMN2xWWVhkZ25wQlZ2VEx3THRJZEU0?=
 =?utf-8?B?Zjd5NzNqYzBpcEZaRlJyNlIwbzBxNUJUaWhOcmNFbVZ3MUI3WlNXSEp5ZHJR?=
 =?utf-8?B?R29JdzhpRTFTSWxJSlAxTzRUQzQ4aS9GcFNPR0FkelAyd3NGemtwSXhCRHhi?=
 =?utf-8?B?SzVjY25ONkFOTHI0bmZybFAyc3RzWldaYXJWSUlPU08rMlJHV1FFRFB3R2FH?=
 =?utf-8?B?bnVHOFhZcjZ0eWZLNzFWMjZTeEtuQjlwL2VWRGZMRjUxOFQ4U0xidHFMdTFZ?=
 =?utf-8?B?VkpUamNUK01sNnVwTEVFdTU1eWNkTHRWVzFidzNPZjBUeEg3TUJ5VzAxaFdq?=
 =?utf-8?B?NFE4SXZVeDlPTTZNRlZuVnlqZHpvTWZBc0pnNThQUkw1NWRiN0Z4TWV1SWVz?=
 =?utf-8?B?SnhWQk5FKzN4c0poM28zWlZ5TGRrb1ZGSFNtbWFpVmJtOWdTTEFQZytvUTkx?=
 =?utf-8?B?U2UrWk42ZWl1Szh1ZDhETEFNNlhES1cwNzBrSUlVbHlrQWZ6a3dkRlBYWVlT?=
 =?utf-8?B?bHRnSFJlbEFZQWtwV2oxOG12blRCMno3MXQxSUVhZzEwMExKWk5pc2JJM3Zw?=
 =?utf-8?B?OENFOUh5MHhWdUxBSUpaL0lsNXYzYlBnUEU1Qlpudk81ekphMy9Jb3E3bFFl?=
 =?utf-8?B?OFlGdXVGb3hiaUJlOTJESUdSZXpwYzNqRWFJZXAvZTFEcGtINHREVWtRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RVJLR1oydHgyblhHeFpSOXFQbDl4OVZzK0NmZ0RPczgyaklmZVVMS1VtN1Aw?=
 =?utf-8?B?VXJoalZFc0EwMXJHM1l2RjQ1a0wrak8yLzJWUzZNNW1zbUg4NC8xdmFDemgy?=
 =?utf-8?B?TmxiQUFQYXoxbmpaK0lqc0hObzNHaEZVZjhSMUhzb09IVXhCQ1dZSzZCVnZZ?=
 =?utf-8?B?N2dTaHlPdTIxb1NqSEVCWGdHOFQ1bkVpRFZMVC9mM0NDYnZYdTFJVmpSRjN2?=
 =?utf-8?B?MnQ0RS81cFdDWEZvL01uMUNNUTdNRWIxakZGVDdXTERQYTVCRldlK3ZFOG9T?=
 =?utf-8?B?bUduWUp5bDlydHd2NHdvYVh6Y0JTdjc2WW45UERUUU8yd2VkTVVsL1M2S1g1?=
 =?utf-8?B?aW5ubTE0ZDl4dmR2cVFhakdFVnJtWXJsSkJ6MVROTXp1RDhOT0VwVUZXU0d1?=
 =?utf-8?B?UlRQSUVjbGlHTDNuSEkrSmVJQnpxdHlQa1NJcCt3QStYT2FOa0VPYnMyT3pW?=
 =?utf-8?B?clM5eXBNSFEzTmt6bVZ4cStoa2VXRjZNNjFLM3pubkgzL081ckRGZjRGeXc0?=
 =?utf-8?B?L1g2UGZMOVJiTXhDZm04bXFmZFRsclRHZmNUNHVxQ2xuMTl4a0ZDUWt6ZnNj?=
 =?utf-8?B?MkdheHRCK3Q2cmY4eHdQODBpYVhWTkx0TWFaTmZtck1ORzhlZzhRMkUrdE1L?=
 =?utf-8?B?MERFdCs1VERPT2llSnJ0bkNRNVVLVnJsYzBaUUdCUzBVRDllRkowTWVvMUlE?=
 =?utf-8?B?ejV4MmIvSUNDZ2pjM3ZqTDVaMkJydTFmckF1NCtrT3BkYVFVQ2xTTU9ldEdQ?=
 =?utf-8?B?cWh1Yno0WUhtQktUcmRRZDRtR3kwKzJVT2gwNTJpV21CbDkwVXBQSTNaZG1n?=
 =?utf-8?B?WkJmOHdlbEVITk5ZNlVrRmdTUmliaStPUzZHMUJhREJGL2NBVExIck9SSFNL?=
 =?utf-8?B?Zy9YUXJjak9rMEZyVkV5a3FaaVE1MjR3WmtxR0t4K2JwcTBYM0tUQTZhbHNr?=
 =?utf-8?B?a2l4YXIrMURHTWhRVkozRjZweWk0Q0FHRS9HdlhLdXZCRVNyKzlqcnllZlpK?=
 =?utf-8?B?MUFFakw0UC85OEgxNlJDTzU0RzhaY3ZYaEZ2VWlDWDNVK0srNHRjQnYrWWJK?=
 =?utf-8?B?Y0hKS2t5c2RpSGRFamh0Q1g5TjFBL2ZaYWF4WUdabFVPa0o0a1h1WExHSXlN?=
 =?utf-8?B?WmorMjFhQWFGa2hDeDcyUTR5aTAxT3U1SDZiS2RBazhYRVNhSVpsZDE5WXpr?=
 =?utf-8?B?QVl3c0RqTTRuNldTeVFqWXBJNVZLeHdoY01waTdGMi9uZmd1V0QxcUttS2lo?=
 =?utf-8?B?Ly8zTHNVZjJwV01FdHhwT3VpUkw2eHBxcDJ2UjQ0T2xjWU5JMFY3UTR4Rktz?=
 =?utf-8?B?MThuVWxMUTN4WVhFZWM4ZHp2MGlIcDB0UjY3V3lMTis0Y1l6UlVtVmVCUVpq?=
 =?utf-8?B?cmRxNmFlM0hFdlZEamNicnVBbisvOWxaTDd2YXJQRmozRll4VzFhc1U5WXRt?=
 =?utf-8?B?REVnb0diODlyWCs2N09yQThZZk1xY3hyQ0cxWkd5WkJxOHhZM1NCVVBSSHdD?=
 =?utf-8?B?ZjcrcEJNYU1DMkVUSnVXWGxmUTNyL2E3S0ZsVWZsQ3BrNWVLYklWd0pYY2Rq?=
 =?utf-8?B?Q1k5RkhHUy84RGRVbTc4ZUdmSi9OUWlSTDBiaEs2b1gzOURYV09UeWJjeis3?=
 =?utf-8?B?MGVvUUpCd0d4bEEzcSs1c3hTMno3RXh2Z2cxeVZFRktwVjZoME85MWRkMVNG?=
 =?utf-8?B?ZlNrVWJ4SUxUai9VNlpGcHljVDUzbW9tWVptSzhGMVFQR0tSWi8rbEZJRFpO?=
 =?utf-8?B?OUYwcC92c2xuKy80eTY0OXVTS2dEbzlseEZSalN0U3JiOU5SUWhIbjY0ZW5k?=
 =?utf-8?B?UTdJNEE5M0NheWdoWkEwbzhWMWFFb2VvMDJQV3JDSXFyaW5zb0FjWHNkcEh2?=
 =?utf-8?B?UENDa0grM1JkWnlXOHFOcEExZ2JFUjk3L1AzRE9YMDY4RnV5QllZZFN3U2hr?=
 =?utf-8?B?K045emVDNlpkdzNDUEd5bVkxMjYyckc3cCtjYVZ2R1hOUWhERVVFYmRvblBh?=
 =?utf-8?B?dGRFeS8yY2FvOGFSeUVwMFlOTGdkdDNJVGprVWFaZ053N1NaYmNXc2lDdGkv?=
 =?utf-8?B?YkRuUTB1UmoyRE9GZzQ5bGJ6aXpkU2liY2o5RWFQQ3FCNzI4REJVMCtJaU9j?=
 =?utf-8?B?RWxQbGJZZFErYzJPWGZZRGpIZEVLcWV2RHlBbEkyK3RSeU1RM1FteEUwRjAr?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0nYDaGlRRAtk8PN9NQKMNQCwcXn6fULpLxGhm6nc43KNOmsZ3Yrf6xMeOpw+SKeR8kd6EVx5Ol1B+r06BvUKWdYaMXPHsA/0RlCqfqYjV7BiQ5orG2aqql/o82pZK4SbcuN9PBCJdZcpq5gl1iR0bQZk8jEVCd4X3v5MYnVlGQXTAu+wL7fuDbLypo1UXmI6bv7c4vGrPJvpYOAcAswZDvtldS3EOhZ/SUgn3jVDN0cw/AuvIPPTM5OIxV/mbv7fD86USy9FxTgJm8BCCRl/DJu34Er9UzvcsjlBMxFmT8EMSvNnolYNp5G7Un9CARPU92pbqjd69azERk1x4ScxYcT1OaZRnQaZL3EUR9wn3ZfRBVYCC+b8P6QUGHPPhklVIdqWyX19GUy73ZC6K0UfZakiT16fhOvG8ZQGGnZT1J4E1TTqU+FTH5sb3R56fMDodwbAyOIR4cUQGRZlzKILnFQf4+eRKkhAf8g2Bp4MBhHcRJN6n2zRVDLW1iYZFWafsM0TYOkVrsZe0ChO/shsFvJb3gQDfREcOjAu96O00R7xpayh7Z3l9iwED5Y3mAao3dkJpT72OzwAE3YhsGEyZmQsYnsCUNfGREDu7j5B2DY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ac42dc-737e-4f45-4e42-08dc7bcca51f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 08:36:45.5702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7shxQEaPfLkTXJ0wx5w8ViSPXyzytjpluss9Sa24TcIoP/LFHe//kYH5HNNkD7VtM66pwC5hBOAoTxu68rVkBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240058
X-Proofpoint-ORIG-GUID: ao8bZh7VLen_vNbSHM2xzWmbFZTRZRad
X-Proofpoint-GUID: ao8bZh7VLen_vNbSHM2xzWmbFZTRZRad

On 24/04/2024 09:08, Xingui Yang wrote:
> We found that it is judged as broadcast flutter when the exp-attached end
> device reconnects after probe failed, as follows:
> 
> [78779.654026] sas: broadcast received: 0
> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> ...
> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
> [78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
> [78835.187487] sas: broadcast received: 0
> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
> 
> The cause of the problem is that the related ex_phy's attached_sas_addr was
> not cleared after the end device probe failed. In order to solve the above
> problem, a function sas_ex_unregister_end_dev() is defined to clear the
> ex_phy information and unregister the end device after the exp-attached end
> device probe failed.
> 
> As the sata device is an asynchronous probe, the sata device may probe
> failed after done REVALIDATING DOMAIN. Then after its port is added to the
> sas_port_del_list, the port will not be deleted until the end of the next
> REVALIDATING DOMAIN and sas_destruct_ports() is called. A warning about
> creating a duplicate port will occur in the new REVALIDATING DOMAIN when
> the end device reconnects. Therefore, the previous destroy_list and
> sas_port_del_list should be handled before REVALIDATING DOMAIN.
> 
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
> Changes since v1:
> - Simplify the process of getting ex_phy id based on Jason's suggestion.
> - Update commit information.
> ---
>   drivers/scsi/libsas/sas_discover.c | 2 ++
>   drivers/scsi/libsas/sas_expander.c | 8 ++++++++
>   drivers/scsi/libsas/sas_internal.h | 6 +++++-
>   3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 8fb7c41c0962..aae90153f4c6 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -517,6 +517,8 @@ static void sas_revalidate_domain(struct work_struct *work)
>   	struct sas_ha_struct *ha = port->ha;
>   	struct domain_device *ddev = port->port_dev;
>   
> +	sas_destruct_devices(port);
> +	sas_destruct_ports(port);

We still have both these same calls at the @out label - is that as desired?

Why do these new additions not cover the same job which those calls to 
the same functions @out covers?

>   	/* prevent revalidation from finding sata links in recovery */
>   	mutex_lock(&ha->disco_mutex);
>   	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f6e6db8b8aba..45793c10009b 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1856,6 +1856,14 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
>   	}
>   }
>   
> +void sas_ex_unregister_end_dev(struct domain_device *dev)
> +{
> +	struct domain_device *parent = dev->parent;
> +	struct sas_phy *phy = dev->phy;
> +
> +	sas_unregister_devs_sas_addr(parent, phy->number, true);
> +}
> +
>   static int sas_discover_bfs_by_root_level(struct domain_device *root,
>   					  const int level)
>   {
> diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
> index 3804aef165ad..434f928c2ed8 100644
> --- a/drivers/scsi/libsas/sas_internal.h
> +++ b/drivers/scsi/libsas/sas_internal.h
> @@ -50,6 +50,7 @@ void sas_discover_event(struct asd_sas_port *port, enum discover_event ev);
>   
>   void sas_init_dev(struct domain_device *dev);
>   void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev);
> +void sas_ex_unregister_end_dev(struct domain_device *dev);
>   
>   void sas_scsi_recover_host(struct Scsi_Host *shost);
>   
> @@ -145,7 +146,10 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
>   		func, dev->parent ? "exp-attached" :
>   		"direct-attached",
>   		SAS_ADDR(dev->sas_addr), err);
> -	sas_unregister_dev(dev->port, dev);
> +	if (dev->parent && !dev_is_expander(dev->dev_type))

This check looks odd.

So we're checking if we have a parent device and we are not an expander, 
right?

> +		sas_ex_unregister_end_dev(dev);
> +	else
> +		sas_unregister_dev(dev->port, dev);
>   }
>   
>   static inline void sas_fill_in_rphy(struct domain_device *dev,

