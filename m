Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3B4D90A3;
	Wed, 29 Jul 2026 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338999; cv=fail; b=T4qH1aO+aSZVQBBrlq1fOAf6VAETalR7d0UqNoBfE1gknOVPj4QFLfLCT97MKoUDdO0yInTslb/v09lsSKqozDDiCJ9rDQHoMEckjg0kJO5e6HdXMX79fa0oznT9QeeOOtZJ2rJ2ayxXqdZnJFhSetwz0GhqNvqo11uYMtRhWYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338999; c=relaxed/simple;
	bh=LN3Qq42rDCQpcVeaW6pOfPmluM9r7ouylhtE374+f7U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PI+E+J43eiKCfotChU19lPu4Gv/lJZPW2d0PDm9lx1JZrMOvNlZisbwYzWGWrtRibqh8WIOOlOTdWBzi4b/cpO/6wQldwVa33IhYL3HXpnh0HyrLEW+S/8fmZ3M5ld39IdWNg2QUNnhwYPutxn2mPIndH9Oqc3fYSU13Ii0k9X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZBpRchMk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MgFNvuhI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZBpRchMk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MgFNvuhI"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTMbQ3322293;
	Wed, 29 Jul 2026 15:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xBKJ8gxXnSAooc36NRz4qVh1y0EkbpizsBxCBacHims=; b=
	ZBpRchMkzltfjx2FqqXx9ZCTiFh020ugLLKKojfQE4zxxzLDxQFWDl2Y3Gu4op4t
	PsR7stZ9FElmxE/Uv/K9gNx1pLYYCpijf6Og7B/WAPsT5CkAbZL3iQe2rpHf5Zot
	NcDc8DbSAI21eCGeJ6p62j0Vdy4wMHu/q73G6D9czlv71HYqXTWudrgWm+eB0Hg5
	7k9NKzJw6c//8CFVi9KinmpEJtNMRx9p1uUZyTkvH7KFeJhWM7bGRgZNa5EVaUMf
	c3HM+06Nw4EuN8mcTqei644YqnQPiNPPA2VSekriD7V9prkvNAwbxBeTjJl4tzzw
	K627RWyYxN2suVSp8dzFXQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0166n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 15:29:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TFFJT9027020;
	Wed, 29 Jul 2026 15:29:55 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010031.outbound.protection.outlook.com [52.101.56.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fqjwu2x5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 15:29:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJ6YycqFnHiMhc8yjHCf1UCQIUC6P6Zr7tZZTiESNnzYZCjJEgv8MrvC5Q+tziy1lg1PvTiSSEe6dFs9lKoL4sSDG5Dfc/nf5cpJziEXJQrG9vVy8zWyPkllCrLTIOtI8HCoHxnWfuIV03T6rGHS5YokuqFKhw1DscgwecipEh5dpaDB/mPYk9BUW2dqZgnyNpTmFZEErcrBd3L/6NSvcfAM5lgl8lnWWKioYGCAh8V+oP9zXcst99pxBnyFRXkdRXpP/XBEncfH8vnA2JK903D42Jxn52n/E+16gbWdxSWN5QXdSThSSADR6LwAAPOY0Jz+Sx1Ajlsauo0HQstd2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBKJ8gxXnSAooc36NRz4qVh1y0EkbpizsBxCBacHims=;
 b=f6SnC67tcQu60k/QpbefDifudnbFgg6yo3B+asNPbKrhPs79M7xk/su0d726/MM/X/DAEk3v0l5enuAHCkM8ftqT0gZdk6wgSuetPZdRNGqQdRuGoTVOiFawevMeNXBxYPaCiOUOHsIy1IlaWDNryeM+EPm4UnewElZnS4eoKmN00tdAI0ilegr13QffAC5C/zNYM9eCxCMkjeVaUl7XLhWmOhcgUN3et8wOho3dmUfEe9BhRuKyIIZM2thUdOU2KOlbHAVtan5msRxIqyGnBn4VgKh6Yx+x5AIKDO1lFvKy6Abv0bEEb3eEKt7raF4y0Q3JBLrMzVRgjNsDgQSUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBKJ8gxXnSAooc36NRz4qVh1y0EkbpizsBxCBacHims=;
 b=MgFNvuhIEh8SMRkvk+RGzlZLdxV6yrP5AwNxu5mLI3RGARTGvNANcSroAsduELnbdhh7mp0Pb7nplv+mrhjKFcwFDTmlOVfAq6a+YuS6xgEGoK06/EikJnCPaCcaDhc1PrUCeE96O1e262hzOCEkwa95N4Vs4e42S4M73am5ZzE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6282.namprd10.prod.outlook.com (2603:10b6:510:1a8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Wed, 29 Jul 2026 15:29:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 15:29:45 +0000
Message-ID: <54f310c7-3049-4d7b-9fb6-1b85ed87bda8@oracle.com>
Date: Wed, 29 Jul 2026 16:29:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 18/27] scsi-multipath: failover handling
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-19-john.g.garry@oracle.com>
 <20260729151403.2C1F01F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729151403.2C1F01F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6282:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ec4a19-8f40-4848-795c-08deed8637e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B2v6SZjc/QzffEKF0c6MPXAFQYM4aHJ4qYL9cGhVFO+n+9OgAScuhjrdD5QrVKupLEy1k/7JqLgPDKRycjNGvFxjHGBYSd7fpxJCLmSz73tUhEDy/uYD/tFgnO1kf1memH+NFOnwR5EUniHxpq1gcTD/WUdYjYAhqcHlyFf7K60JHv9tBfylN3LkSh4SOhK05SaZ8/JkHAtbFc0nNvTzjGUC/gmVfZ98wj2WZQKGQHBWYzCYqDkeNB2gjNNZciJPqx27HzZTyXeSMCIs1kLWhHFX/t+C42Xz6ld8jobUIQU4redFgChc5bqrnpr7NUZvuitedZzxMgeHnjxaZDPzKAGEvkOaJ/1yMXN13isQAaoHhBIuSy/GNHHc1vBvGpAZGmzQoYBJLBgLIdnsaMjOV7v9wkDlEClL++hKDYIyoNH8KBLlexXL6tT7+YciJNgzBkNNTS85wFioOIVvN3A8oi1sG/zNFZ65vdpXXb1ekARofLgKKIHzYmBmsRjWwuuipdGYVKB4KRBG6QfD0XqjVEhNU+1/fBIa/uLcL9JI30GiHHXt34mOrqcz/ZekfWTt72F1ezKCn6Kb/ry1tkl+WIJb20g1Y1zactc7K1n/zplBr3MsTw2k9hEscK6rAvl2P9+K+ckIZBJ3Hz2mF5LCNUtyjnstrpKGu84myVbK7IA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2RMR1Bxc2w0cFBDOWtYZ1p6cVQ1akNBdjQ3cHlPUEhUZzBaUGFoZDBxWkty?=
 =?utf-8?B?c1dpZ0wzaDg5Y0VtbVVzd09oWGYwdGc4WXI0TStEd2wxdXUraUE4WFhEMFo1?=
 =?utf-8?B?YVRpMnp2V3h6NDMzNFhsRXFZc2xuN1B3YkszanhpQlFoM0padFF6cVFxMm1q?=
 =?utf-8?B?RzdLeTJhMU50My9xUkhUQlpDU2QxTHUxUyt0dGhUN21UcnRFM0ZORlpwVkVz?=
 =?utf-8?B?US9hc3lobWl0VzJYNEtIRXdlVFF1ZGRadnFLbDZJK0tRQVdVekZxWDg3dTh0?=
 =?utf-8?B?eXgvN0dUVDNiRkFWNHNLRXFPZ1J6U1ZqWktQUDFpd0xTVXgrWWJZRUhLOXNs?=
 =?utf-8?B?S1QxTVhtM1VlYzVNUU81UUorL3lQdXNWaWN6dTRMRHUreVN1UnVlU1kvcnR1?=
 =?utf-8?B?dkliSE8zNTB4T2NkZ2d4dnpFMjY1NFJUVm1GbXZDQ2JGdXgzL3B5dXJYdXhm?=
 =?utf-8?B?TC9kRDllTUsvdVp4WFlVTWttYVBrRStXeWdTQjMwc1V5STZIM0Zza2xGeXR5?=
 =?utf-8?B?WCtnaGpkR0t5N2szOHlMM0FnZUorSzIvYXUrQ0dFZW11SkUvV0JHQ2s0NTdO?=
 =?utf-8?B?UlFJRll0SU96dXZheGhUQ1NwNHJrSFovRFdwY25rZEJ5eExJRGRJV3BSKzZV?=
 =?utf-8?B?aElUSk5OaEprM1FWREdoUG5OMUNET3NOOU5TUXQyMVdUaHRvRk9MMFJFNDNP?=
 =?utf-8?B?dXllVi9GM1h2NHkwU2dLYk5KMlI1dEVFaE9vbzVtV2ZodmJtY0FsQnZraHRw?=
 =?utf-8?B?MTNsckdpK29SMUpNS0c3dXJBaHNPMHJXeEFjd3JGbjA5RW15ejM4RnR5bXly?=
 =?utf-8?B?cy9yc0VwQlNUckhWSjA3UlUrNWd1ZUtmSW5YbUM0THVRWDUvTEVxeWY3VGZi?=
 =?utf-8?B?ZCthREd6WVFqWUJOcGJrN1ZlUDlmbmJmeGFFeXkzeEw2SlBobEMvaGdEdW1x?=
 =?utf-8?B?MFhLdGJaZFA5dHZqYTBmSzhQQnhOSi9Hbnh6Q2Zhcld4NENrSHNCRmxhSzhX?=
 =?utf-8?B?SU16L0JhVTZrTklvdkRYeHh4RVRmUERHNk1uVmFEYVN2ZW1odk9FZzdaU2Nw?=
 =?utf-8?B?b05BYlZGSSszVnBtQTVaRXdwQVErSHJqL0RtRGs4VVFzNEFTbmxRYlZMWEJa?=
 =?utf-8?B?c0FPSVIybVBac2ZHQktQWVRQMjNIb05JQ1hvSWxTZXJ4UTNSNXRuRUlzYm92?=
 =?utf-8?B?OURvaFplY3AxQmNveFE2bHNuRUR1Qzg3alhmYzR0SFNOUWRMU2MzQ01BdEJy?=
 =?utf-8?B?N2tzU0R3UWR2ZCtnZTdDMkxJTVRlVEMzcEkzNHRnMEZGV3QvSlN4bkMwVWYx?=
 =?utf-8?B?bkdkcjZnaHpQb1hPcjlmanhmQjk2Si9pUWlxRkVNOUNJdUxVY2pVTkRTUWw0?=
 =?utf-8?B?enFiUWJlR1hBQkd4RG92ZytkemJsOUUzQWh5TjlIM0xrWWFTRXZmOGlFdDZT?=
 =?utf-8?B?KzNiWE5FMTgwQXJDYWR5ZlJ5RmhEM0d2Wm4zcmpSOVlpbnV0VDBkem9YRHZr?=
 =?utf-8?B?QVJRbTUxNjlpRGQvc2dBN1Z0bnFTaERJT0lOOU83NVBLd3pnM1hmRFVsbmxX?=
 =?utf-8?B?eE9yNDM3WUU0U3VCS0hZUmNienhtUHRtdWRtWmdRckVIMlpFZmthR2FMbGdM?=
 =?utf-8?B?eWtmL3BTWEQ2d29ONThKeXNtSHQ3OEJzUTJyQ0dXV2R3N0ZQdGs4L1BaZk1D?=
 =?utf-8?B?TzNVZ2VtajAzSmpiSlFsUGZ0RWpJM1p4UTBPSFBrL3ludzVtNVNYdmwxQkhu?=
 =?utf-8?B?SEZIRkpqUlRvR2NBY1V2WjcxM05jSWk5VkVKNjhnbkRMd1AyZ1NOVHVsazhI?=
 =?utf-8?B?VE9QdnpXREYzTk1CRWpiaklKZUJCVDNnVXI2QlhDVjNSYXNHbk1PeVVjM3Q4?=
 =?utf-8?B?cGtIejFXd1BrRVVEdXF6cDdCVlE5RlZ1RExrV0x4VzdoYXdmdk1WN2lVMVl4?=
 =?utf-8?B?WlFGNXIyc0F4ZnZrV1lTeEVrWkZBK0QyTENXR2hLb291QVlOT2xYLy9qM0Nh?=
 =?utf-8?B?LzFhcURkbnZNZjBDNWdwYkFPam5Td0xpUDRPdXRpbXc0SzJ4S3cwRjJlV3pS?=
 =?utf-8?B?RmI2bytBMDBaUVIzY0pJd0NrVlg2THdSMHY4UHppWVB5VFozaUk3Nmh3UTlo?=
 =?utf-8?B?UmFwZDZ1NU0zbVZ0TDN4aFdHa09rMnlxWEJORlM3RFR3cEV6VkZwUmtBWk82?=
 =?utf-8?B?aEJzblZuMmp1UWZPZUh6TmJqOXM4OUJZNmVXR1ZyV1FHNTBYa2tCR1JRMmlu?=
 =?utf-8?B?Z0s3K0YwQ2NUUWxFQXhVV1J2WERhZ1hEUVYxZUxnekRYcUtCcG45WkpnSEEw?=
 =?utf-8?B?RFBvUVhjSzdTRFVHaFM1YklBZTJxQ2FSbWdLdkJ2S3NSNWs0SU9YK0dKeHlH?=
 =?utf-8?Q?F3riz83VsJgwsK3Q=3D?=
X-Exchange-RoutingPolicyChecked:
	mn7RaodXS/yjpSnXWM5SUJu/e1Hi8SrRw0P65ACuKrrfuoO+o0to8J4eNb4cmB8/va09VyQBz3UaEBh6Y6I4Xe9wbdH9H/O4XvurSeNIXY4uRf7+3+JjitclDLcbfXVxoDJHrkzfWGT1AG53ZO3fHP4OzOX3sc68yA5vGy/m80cl7p/ox5s3zlr+ylMXdrPPwJ5l34Gf72ZE18h0frSHadoXBR6SYZXTThDiS+K7svNx/zCfM+wGHJZCbhGbRX7V+7jWnmg6QU5rrGEs8yK9lv29BDcryh9WURi5d7VzFDVL18WaUHee4Y3RozMTRrwwVfWPF6UtpjPTtka4X7LDsA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lMnrScxnHLV9llHoTvDl1jU84d7lb8jBp+7TxzwMmh/epGchaDBTvEEy1fMLEl3K9VIo8Hvfs2x7KrnZ1GHMf9DEbG1vahfPnry0ifh2ud0GTcS1xn95j6M+VDSCqEutj2YQjdGbDpJ9MgtlAc1fq9pbLl8ngue4uvKnf8+HRgFmizHVIyn24TOVUdFbYTVy1KBRpOjG5vj0Mbhj+5bgYSVaaZoQ2lYFaT4D3IBsYD5GEyDW4tjrDy+MUOAWRsbe44SguGuK2gSnODduTXieWBLna4ynRgx/N+3o0vX3CrCH4VStGlWR7am4f9PsqnHIkG5jyG2sL5+2sQQMBL8jbsj+ZZMdsPveSAONy85VRWtPIdaOZfWjLU3feahOAVyloPt92dF2QNnSlhRBT4qRR/85fZO8ov9+6nC/OVIHIHFUHJXQkQneDVVNCynYD51gP3GBIfXCbXvhJUoWH8TdHJfxmYnUwKY8nSksBOPa0SvyQd7KJvnU2+h3OWYnUyLt2Amuvpdjbm23zCTBeF4MfP8/4VxoFZa6OO48utUSqUrgM2JISlGu2VxfRe2pXN/Dvh6PA6h6xqj65zr6Cdkyar8gDsJGDxsSjHqS006V+tk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ec4a19-8f40-4848-795c-08deed8637e5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 15:29:45.6401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPB3iSsdRAC9TEYP43iULtrgzj07r4i0A7l5Flg6w3EzOfi91rbgCZm6mZdNOiRw41aDVK5hO7Hp2HciPAdziw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6282
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290123
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfXwk4O/PSfjaMc
 kX/08p9vyBllwrmJ064XKs3CHQ6gYKLWSpIoqB4ZgZEZQgR2nABDhGgKtjb61qFEfWsCu+9Tgnv
 H51y+A/Uprsn7dRVp+hSyeoXV3DSFlDqr0HzemTwEDUZErk1LVxV
X-Proofpoint-GUID: z1CRLpYslylgTsTctUZuSewBsQU2Y6gJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX+nmO/R8Z3myI
 tUEFbGSgf5ygnszK3d5SocLqa0PMtldP5RZbpf/aktuYRcF8nlPvaLW1SVKZRXtsufQdugFjE46
 WQnWU/cXZIeYg6XcqAmsRR1OsAtd3rPfrbadV1P+qzwtLBfP6uKjy+dzf7n3dto3qXT90ZoMWTg
 Fjr8/2GU+7TQ1tOAW0ISPZc7gB1GNudmwX0ajyHq5uHetkhlCG9V3WkGtP1IUFtQvNgLVeaPe3L
 q6ExxS6uYI20Kk+/F3Yl4+7I1QEja0aJauq4yTK173My3xulSALLpSEIX7HkI/dKUsx57EO98gM
 HeRBFVL2Df6bvW9R2d+oE7BkG2Ow6L9Dk4br+b+KqV6wwRfl59X4I+olkHplDb2QD4L8iz0vN3H
 Kx+tuJ/Six3NHpfZErPFjsXvGbuR02YPR8lOnjtSrlQb/vxRuKB11Z1qoPkPXobnhFESqGd6+ro
 EK3CsHjRzeH5ufOeDag==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a6a1c73 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=y1GWYGGvYlcVIVM3eioA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: z1CRLpYslylgTsTctUZuSewBsQU2Y6gJ

On 29/07/2026 16:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] List corruption and use-after-free occur due to `bio_list_add_clone()` failing to nullify `master_bio->bi_next`.

master_bio->bi_next as we never create a request for the master_bio

> - [High] A use-after-free crash occurs because `cancel_work_sync()` is missing during `mpath_head` teardown.
> --
> 
> --- Patch [18]: [PATCH v6 18/27] scsi-multipath: failover handling ---
> commit d3d46b0330ddb0dc22577a7546f9765b9e1a4651
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: failover handling
>      
> For a scsi command which suffers failover, requeue the master bio of each
> bio attached to its request.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 12750621a7fc0..6ced89576368c 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -256,10 +256,49 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
> [ ... ]
>> +static inline void bio_list_add_clone(struct bio_list *bl,
>> +				struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	if (bl->tail)
>> +		bl->tail->bi_next = master_bio;
>> +	else
>> +		bl->head = master_bio;
>> +	bl->tail = master_bio;
>> +	bio_put(clone);
>> +}
> 
> [Severity: High]
> Will this leave the newly appended list element improperly terminated?
> 
> This custom insertion into requeue_list appears to omit the standard
> master_bio->bi_next = NULL assignment for the new list tail.
> 
> If master_bio->bi_next happens to contain a stale pointer when it is added
> here, could iterating the list later result in memory corruption or memory
> being accessed after it has been freed?
> 
> [ ... ]
>> +static void scsi_mpath_clone_end_io(struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
> [ ... ]
>> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
>> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
>> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
>> +
>> +		mpath_schedule_requeue_work(mpath_head);
> 
> [Severity: High]
> Is it possible for the scheduled requeue work item to run after the
> mpath_head structure has been torn down?

this flush is done at the disk teardown

> 
> If a device hot-unplug overlaps with I/O path errors, requeue_work is
> scheduled here.
> 
> When teardown proceeds to remove the device and drops the last reference,
> it appears scsi_mpath_head_release() frees the scsi_mpath_head structure
> without calling cancel_work_sync() first.
> 
> Could this sequence lead to a delayed kworker executing on deallocated
> memory?
> 

