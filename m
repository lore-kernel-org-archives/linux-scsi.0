Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180432E401;
	Mon,  8 Dec 2025 09:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765184903; cv=fail; b=rlu8YGC/Fv43WX/CrzlOTF8o21AnIBsOlT3eDwFr0m40gLtIc8YvxU2fJxybtc5Tsfl1SH/vMdvQVRJRAx6kN3U1CEFFLxJZlnBpVbRHYJ+iuIRnDayxwl3qr7MHYENoasjKH29MrJM9E71Yu16tU+P1g/P0hYr813eFouPL+cE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765184903; c=relaxed/simple;
	bh=ZnHx3uOwr9bD4BJyS9w2Vb5kXQj+2qFD+XWgP1cE9Ls=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cmMNrgEdKWUorHE/wis5nGbvieAF8oaTLgPKjdY59dWdPXvE5uzxT+sfQrmosC9KsnhXWi4dLwAL8kEAiSl/wl4jmUWKdtcYFD5OwblfG4dZny/PSyiRpdzvF18WigmKg9as+8Z7wPeKlZtpJUvUAL9Bo4umXe7m/ugdInafK38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BMI18jEI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q17AiV76; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BMI18jEI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q17AiV76"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B88u0dg2096825;
	Mon, 8 Dec 2025 09:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yhfVLRVgT2fuqvRcfWsThmhym9USnmlObYkhey1RflI=; b=
	BMI18jEIe6bpL/8C7DA0o5KkwPmFU8hLyK3T+AsjpmlStYqV59yUtHe09EBNyNBq
	k/HqbBZXskdsjd/93/UO0a5rEvz6tUbAY8HpzpTaD7wRLMrX8gwnadyIh2bnsMb5
	hlCFB9/kNZWAg/cYP5ORugtE4GxWv46l0MTCtRHo8Qh5/Qtsi5UWKZCVVk83i0l6
	/qYxp+8qtZJ7zspucp77u+C4ptBOIjI/x13rYvFKk5XVl9DuO0zxfP9ywAyz1ssj
	ButKiopkU9lx7u5w82VHc9uHPAx/skN6483wi77J9ZX1R6ysSxDXbyU3IDN44VpW
	WJWRs0mSUBM8sjnfCO4sgQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4awsde85sq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:08:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B88qpcm040283;
	Mon, 8 Dec 2025 09:08:03 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011068.outbound.protection.outlook.com [52.101.52.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxh8tfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:08:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQzHNB87e2I1wq7Z8lirly8G+ceuQidJtkVNwrz9TdYBr8de4iEHP6LsJKb6qe/HJD2kcgvzzxxoFQQFzMwyBrN19FF5DSTlyuNjxH8rS/AeaOq2qcMeZqIoDx/ugV72kSZVvCBD1LJU2Ry266gGd9kXAZ+P+sGqlxMRkM1omdvBMgucGFdicN/OvImpFUbqNYCbBjNdiNq9Daa0TkSwgA+1pmEgEnbBUOR2vSnouzSJxES3VVSaghckSigGY5rEIBFcuTSZ8gr5bXZJidxIk8bPXoqymktj5QriYDM97j69mtYMDcRgygmDh0QeoujAovsUuE8uzSne/jFt2U6sAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhfVLRVgT2fuqvRcfWsThmhym9USnmlObYkhey1RflI=;
 b=GnVwYx1I3+/+p5q4sDhi9AlJJFfWjQB7omOj2SiQCHCc2SSA9XAYWckmZgLGm5bZM1WRumAD3E1rdhk0cwb82teWpVe1kSkZy7S6tPMqkPto5/pOcPWiOeUYEC4UZgZLEM87SZGYxpt8P49bWzKROJEzoiEZ5IvCRLDeqtQ/K5wuBBTBUjzFBL507dtSSj0b6JZZU+kmK2IirtapRl+ObRTPp1e8XiMvU+8VU8sweD0vljqPic6/5cGakVwyGgWpj2eiM9VjrKK+FNFCjoG12/OndaN6pDBvudNaEJms6NA/l8oHtS2pjFDiMu0pO+G7MZu5CX75kOd5gSP7lPpl5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhfVLRVgT2fuqvRcfWsThmhym9USnmlObYkhey1RflI=;
 b=Q17AiV76M6hK9OBo7f4sdCQXph0aLyUW8NSNEQiRRFz05wzr2/qy7Zs4TdtttotzI1apTMzNfZUe/KxQQ27qzuU21+ZD4Z1YBuzk1hQ6rSGYyXSO0Zvw4ubOmSUlzEF1vAEXBN631v+BiM1ElhHfvHvAkwleTCoQc904wgk+8dQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by LV0PR10MB997662.namprd10.prod.outlook.com
 (2603:10b6:408:33d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 09:08:01 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088%8]) with mapi id 15.20.9388.003; Mon, 8 Dec 2025
 09:08:01 +0000
Message-ID: <0d863efb-cb8c-4dfb-8d52-c73ad04b93e0@oracle.com>
Date: Mon, 8 Dec 2025 09:08:01 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: Add rollback handling in the
 sas_register_phys() and sas_register_ha() when an error occurs.
To: wdhh6 <wdhh6@aliyun.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        dlemoal@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251206060616.69216-1-wdhh6@aliyun.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251206060616.69216-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|LV0PR10MB997662:EE_
X-MS-Office365-Filtering-Correlation-Id: 9789ae98-dc40-4ef1-15cc-08de36394995
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bGQ2bUdTZWhnQjZ1ZTQrWUc1VmJsb05QUXZ0cUtTQ0VIS1J6YzdvQTZTNVNk?=
 =?utf-8?B?RlJjUElFUU1sUWRNWTkyakZGRnMzR3NCUVNjOTE3dWZvQWMyUWpWaDBTWExq?=
 =?utf-8?B?dzNuR0I0cDdXdjRlU1Noa1hrYTNQRENKZE1kRDFPK0xJcnNLR1ljUFFzOTNn?=
 =?utf-8?B?VFI1VkdZZTF3Q2pLVFhDdjFucHZKTFNDb0JNMEhkclBybFdJdXV0cnBqR0V0?=
 =?utf-8?B?ck9PaWF2M01hTnNyQVJzTlZoVDRHVTAxdEFXUWVyK295MnEyYXFaSTVjdDJG?=
 =?utf-8?B?NDdmVTlPVnZaTEljcWNiUXdNeDliTVRzK1hubEdFa2t5dEhUZUQvQUxZL3lj?=
 =?utf-8?B?bitLcGZ0S0Fmaml4VnU4MURObHRWUXE4Z2VaU3dYNTR2aFh2dmlYdy9nWUtM?=
 =?utf-8?B?YURreU1qYjBFNXZYcmZ0aDJRcnpsRC9jMXc3WkpUbHJaZlJ6MzliVlBPSlpS?=
 =?utf-8?B?eHlpL1BCdUxYMVFmOUZkLzl4a3BLUnBRWEd3Q1FKL1BPaUtZcEdqcTU0R280?=
 =?utf-8?B?MENUMzROZk12ZE84eUJ2ejhFdFZwQUkyYXJ2RlZKZy83Z0ZqdUxUM21pTndQ?=
 =?utf-8?B?RUs0RXJ1SVZpcThtMWlRdU9ibUJGQVg4UGVTT2x2d0Z4TXRoTWRzWDM1OVAz?=
 =?utf-8?B?REpUSzJVTTBYVnlER3AwYUl3M1BWTjJQT3VSMHB5amRPak5KRjlHMjFkUXJJ?=
 =?utf-8?B?NHgweVgvOUJTTDV0NDRlL3VtbWV6ZHhmaEx2Ri9jM1N6eVE1SU16ZUpiZXBC?=
 =?utf-8?B?VTYzZEVicHpMR3JyOXNNRmVBQ3RxTi9xYzV6T3VtTHQramNKcVhITzlJQzNU?=
 =?utf-8?B?eThhTGpjWG4wSU9LS21qWmxZS3Q0bzNkNDFIWDBCdW8xRU9NMFNmazd2Z1Y2?=
 =?utf-8?B?MnhTcXlkeW8yRmVla2tQdi9ySHBjRDNFQzByYnk0OGFsTWk3SkpmaDM4dUFv?=
 =?utf-8?B?aEkyUE1Rc0YreDZ4dEpJQU9iRklvd1UxMmg0dmpMR0wxM21MMFR0eUdKSE4y?=
 =?utf-8?B?Zmsxb2RzRWk2QVVwa0NzaVJFOFlGUDl1SEgrSzdtbm9taVc2azB3elRWdGNk?=
 =?utf-8?B?QUZZN2xILzhjVjRSeFF6MHBvazhWM3hRNG9QejM1L1k1bzFQSGVnN0dDNVJr?=
 =?utf-8?B?TFVUY1pmSWxLd3FmODdkMGxkOU9jU09wc3FuRXgwdEFGRkRxN2prMHBVeWlw?=
 =?utf-8?B?ZnFoWWJMRWdXRkpBOERzYjgwTm40Q0YyN05MbjRhTElPWEhzazNnVVpucWFs?=
 =?utf-8?B?aWNEZkJhRnlZQlZ4ZGRHOHMxYjJsaHd0V0hiVTNQYlQvSktkbUVoUVBOWE1y?=
 =?utf-8?B?cWFZbTFHeVlEZXpRUXlsamZjRS8yMlFEVXZJNk9lVmxJa1Q2NFVlSWw3ZjB0?=
 =?utf-8?B?ZGxNK3VmaUc0WTBLQWhnZWRwQy9sL1dMSEdMR1hoa2dTdVNud3pZTTV5bG91?=
 =?utf-8?B?MWcrdkxaVjZlTnVySDMyVmdtRWt1V1hBNU1jR283M1NYMnpLUmc0K0lYOWxo?=
 =?utf-8?B?SnRFSTMzVVQ0aFZOMEFSTUZkQ3NjZTNVMHp2UmxLTGhCeDJNcWl0YUVoR1NO?=
 =?utf-8?B?Q0dHS0N1LzY4amcrYm5OWjNoUEc4enV5NnZDYllKVmVPKy9qTm93dFBlOVN6?=
 =?utf-8?B?M0tJWnp1MHRRMjVBYUN6dVhXVXlWMGh3N3JJRXc0V0NtUkVlbUZrTER2ZXds?=
 =?utf-8?B?Titpbm5mZ1dRejZ5RFJxSmxFK1ZML1VKa1h3MTc0a2pnWG1pUjVlK1ZGMndo?=
 =?utf-8?B?WHlKUVNqOEZFRzBZQ0tpVE9ra1pSdWFtV2hyczh0cCtTdHFLc0s0VmthRjlZ?=
 =?utf-8?B?UEtnUENtTTFnYUdtUG5aNDVaRzhNVklUNTR5dEdtQ2s3M0FCSE1wTjgyZ0ds?=
 =?utf-8?B?dGtmZTI5L01XVzBWMFZGQVVicStnUnd3RkNodkhCd1ZwZVkwdXJFa1NiOENp?=
 =?utf-8?Q?7SwyjUq2ZRUEqCnThf5u6ELX74eDCEGS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0VYNmx2dGNpY3pIMm8zcG9jSSthSlF4ZmNHY1JjUloyV2Fub3JhOTNyUjNk?=
 =?utf-8?B?K1FZWkkwdVVWS0JOa0tQL2ttSHFFeFJYK0hPOXNYV1I5bFRJejdDV2tTQ3BX?=
 =?utf-8?B?V1ljRkphcmd1S2sxSi9MMW5FMTFVOFFGK1Zqa2pqZkdhV2ZKU3k5Wlp5WDFx?=
 =?utf-8?B?VGhWWlBHbFRGMzVqek1xSXpWNFltUDlBUnpWclgzNm5xUzNxSHhkOGN4Wmd1?=
 =?utf-8?B?OWhURnFHemJtUkJvd1hGUkdDVVpxK0kxUVgxaHBFOCtuRTJ2elBhem9UWXhW?=
 =?utf-8?B?OUh2QTh1TWwvdGlMRFU2V1pUZktRb1VuMVV2Q0ZLd0RPVXZvdkE0WjFUR0Qw?=
 =?utf-8?B?bVpmZ0g4aENIbmVDMk1rMmZXOXVjTHJFYnRUSU5wWUhmK0FSdGVrL3FSWThH?=
 =?utf-8?B?c1hpQmQ2eW9naXhrS2I4dlh5ekxSbTAzUFJFcngwVjFYcHZVWGRxdXFPb2dH?=
 =?utf-8?B?ZEJDWHFqSzFCU0dodFh6alZldi9vQTN4cG9wYVE4aUFmYnNJSTNiMURtb0d0?=
 =?utf-8?B?bEVmRDJNY2VFVG1FQjh6Z3dEdG1adk1mY2N6R2VLU2FtTmdNQ284anZQcitU?=
 =?utf-8?B?RUVqTlYyQzFIMzRqcE42SzR1NHR6ZWRxaXlrMjNpZFlMRjNMOTlUWlhjejBM?=
 =?utf-8?B?SHNYVzFHQnZpZDhMODRWdVVJVUJObDEwVFhsTE44T1JjM0lwSUhuTkNQRnE4?=
 =?utf-8?B?T3U3czJYYnJicEc2OG5ha01OV2p6N0tBa0s3TXV0bHJaVituTXhoMUxvbm44?=
 =?utf-8?B?OVhMRWZkV29NM1JJaHFtVVo4UER5VFJCL2FBb3pPd3VTTXJzMlBJNEJWWFNy?=
 =?utf-8?B?REZCWnYyYXEvUlVWOWRNdDcvcFo2eGhQcDgrSDJUcEFlam5DNHFzNzQ0d1Iv?=
 =?utf-8?B?cEpaSmkvaHBVU014MVlmTWRibTZFUzVhbjNIOTJZY2ZDdnFRNjFxdnI2UWhR?=
 =?utf-8?B?TUxrLzRCWFREVm04YW0vQjRsK2U2T2pDWUdrWFBLSUcrRis3Z2JTTnBIb29o?=
 =?utf-8?B?WGJLTGYxMXdPZDNieTIyVVVZVjZZTjZqeDh2aXlabUliWVhDYnIzLzhlWGU0?=
 =?utf-8?B?eTkwcW1ScHJvQ3pTblM0NHJ1R1MxM1NYOWVGcGlwVEpJb001ZnB4YVJVc0NS?=
 =?utf-8?B?cFRxcUh1U3VBOE1ZZE50QzhVbWNzZFFOWWE0TGRMZTdXYU5pWVVSUE1vbC9a?=
 =?utf-8?B?cTNvMWF2RU9iMkZFT0FkYmxGTmJmV3FEQXFwQm44dWJGNlNGZzlZY0xsUW82?=
 =?utf-8?B?Qm9uSUNaUFZXN1FCZHgvWnJiL1ltaGh0cytsTmdTditpSm1RWlFTTkdzalk1?=
 =?utf-8?B?bDIyUi80THdsUU5Lc2Q4a3N1VSt3UVgrRGd1U0I2VEVER3hJUHZUM1pDa3BM?=
 =?utf-8?B?MHpZdnRqQmJBQ09NaEFseUN2UDBFL0VUZkR6THk2OWsvMVYzbVJienVMQlNp?=
 =?utf-8?B?aDg5SWc4VXo3NVdEMFVSTkVPekdxdEgrL1dPRVBRWW9LZEFzanBnY28rSkNl?=
 =?utf-8?B?ZjQvQVVFSjdBakpRK3Fwa2NqNWhBcDdiNUhLazNGNmc3VlJydDhRWmVlbU05?=
 =?utf-8?B?L2x6Q0V2OFoxc2JPL3g3dlo3enJjVzRoU2VwU0w4WWEvaWc5R2NseUFaWEVW?=
 =?utf-8?B?KzlDejZZY0VHY3VRZXZJbzQ4NUFnZUZPWnlibW5LejNYYkJ1MDY4L2lCRXlN?=
 =?utf-8?B?OXV4NzVEejZpKzVVdWhwS3FWeGtOTlFHbnZNeTlCbllSK2N5Yy83MnNRc0FI?=
 =?utf-8?B?YWQ0TUF3cUlvWGZwRG45dkU0dVUyOVlRbWR0UmhycnpOV1JMYTZNTlFUemdv?=
 =?utf-8?B?YnJVSUd6eHNIR3JFYXNLM084dnluWWZIQ0ROTnJUZU5kOHFZTlhRUDRBOFRq?=
 =?utf-8?B?RE4rMGwvR3dDQ3NldHUrblhsZE1kYlJjcmJKZ1lWVzhMYVBpYm92eHlVdEZE?=
 =?utf-8?B?VjYxS2FwNUlSaGE0OVpCZ2pnRzhMeC9qeUxjY1o4b3pPQ2t5ZHE5aG1jVDFQ?=
 =?utf-8?B?SE9vUnAyaXhqUXBERkw5dTduR1UvaXJvUVR3YzQvdWN6OHZTUFAwOHpkc3Ay?=
 =?utf-8?B?M3poYVFyVStKbmVnbTMvTzV1L1NMK1pYejFIREJjdlNpYlhJTTBaZzY1UExr?=
 =?utf-8?Q?fn6U0z1I2JrE46NmeJudlP1fq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dcMEeVDFTHsEWDOw0pO2SPEWfMlkDZNy7X7LSyYXdRnNg7rEfYNGpRgGt4fqS2hqJyjJ+7TBlXLISROpdwP47GSIWhfI7vh11C2WRW+cpv3Ch/xmgeJKvJ4T9GrR6lCFSk6D+BmziI8YYnmDFo2nBofMD4yZO/Bp3vKGb4wy8ZdxCD5PjhWwSAs8NnHwQ5ljnHkPKUUifiU5aolDvkQbhVteZT6QA87kIaTjLeHMrsoVzQo4TjC1pjJ3df61DKWGIg8iEscqUl+RBB8DNiHgCCLs+JRvgF44RgBFO99kOJyTPfiX+H+gKmTyqO4oSb8VwfZT9VS80haWM6rBMhiEzP5oYyBBr1jJLs+Bqul0QE2EH3YXlEKi4pk6yrHZD8wCLedjh8qf+ViENVRMppcajcGFIsajOIh2pMlM/NqhHj2jc2Ps0klG6ilCg4wnOoLmPXLk5jB5KentujlpNCeWRW1NOIHEsj+PoVYNhYQmJmgxbj2xZtZRlITHRX++9ZOieXUB9veaLWQtgtFoCr8BGgxxpxaOmKFUMji8Nup50b6t6tk4msXIf8a+w5W9dKMLr+ys/bLGkyZ8RMaZQzpvnpFau7rBhrX7D4XUo15Q3F4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9789ae98-dc40-4ef1-15cc-08de36394995
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 09:08:01.1858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJCZha6ouWSak2ZMfDLTn/u0I7QpXbhFNuDwlrwhN2+hEQQyyqE3m+hb7+WBqBQ1sE+aQxM+c4gkNacVf2ub7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512080076
X-Proofpoint-GUID: pwMEJKx3tldp5zztETnh3uOuwVloXxjB
X-Proofpoint-ORIG-GUID: pwMEJKx3tldp5zztETnh3uOuwVloXxjB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDA3NiBTYWx0ZWRfX7LNClZYTlyMW
 hS7NBD8ZbOE2oLz3kTClsEZlRDP2TeAokm6GpO/tqtZWc3GndplxXVWvxCy8aKXx9CV/k2uqc0a
 PMV2EFblzCL/EfI7SH48wckc04wKgTqhtJMC3VhP5V/FR3HYWlC3RaWCmCKJvFUybYTEvvfDHG4
 PlmvV8dWuD5P+nR7sQHkFmUpQbH6odCcokwfAnG1sVtWzpy6l2arG8lBnW+ZFZxBx6x6RabOaaN
 QbXHJC9gpVzTCYcMmhrvJ1QkLe78UKOjoZhZxm/+xDM/2nlnNs2CDhhDMR5Dumg9DPzctRlrMCA
 fMj1Ek88XTyhc7wlKt9V+/SquhuHPi6FbFQqT5fjC/iddxEpl3uAxJdoKQpr2Qhe6uG2hhi0z/H
 n5ZNTmpD9t6Rd/CxtfckSUCI6bl268eAyfcZynb0HarWemZwn24=
X-Authority-Analysis: v=2.4 cv=de+NHHXe c=1 sm=1 tr=0 ts=69369575 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=nTg3QbKWAAAA:8 a=yPCof4ZbAAAA:8 a=JV_227z3Mp3v0fk8pBMA:9 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 cc=ntf awl=host:12099

On 06/12/2025 06:06, wdhh6 wrote:
> From: Chaohai Chen <wdhh6@aliyun.com>
> 
> In sas_register_phys(), if an error is triggered in the loop process,
> we need to rollback the resources that have already been requested.
> 
> Add the sas_unregister_phys() when an error occurs in
> sas_register_ha().
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> +}
> +
> +void sas_unregister_phys(struct sas_ha_struct *sas_ha)
> +{
> +	int i;
> +	struct asd_sas_phy *phy;
> +
> +	for (i = 0; i < sas_ha->num_phys; i++) {
> +		phy = sas_ha->sas_phy[i];


nit: I think that it would be nicer to declare @phy within the loop, 
like how it is done at the roolback label in sas_register_phys().

> +		sas_phy_delete(phy->phy);
> +		sas_phy_free(phy->phy);
> +	}
>   }
>   
>   const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] = {

