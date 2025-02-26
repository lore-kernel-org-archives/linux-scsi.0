Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC82258CC6;
	Wed, 26 Feb 2025 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560272; cv=fail; b=c/R5IQqpWiZwsJuC0XPqdcuS/F7+3G6J3VErAbEPDZLMgFC20KqMmhqnv6/rHg4Av7BYdC85LAkdIWKKCqb+tgXwhO8dI3LnUHHfq9CXmBxGeVHVjW6YAfv02WJaJA9cZqYyd+XO3SE8j7V+jfIqK+3ZdVUaxjdL8gvTvzwx+WU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560272; c=relaxed/simple;
	bh=f3XI7B7rcx2oRwG7evmAey/fQTRfOhiZITLmTDZkq/w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K78M7Jj+RxKdVnMKs8eCzO0385WhO7CIDSoUr+muysLCGY9fjA4ABtTISQpFNmHEwjlhitBh+2Cid36VkkqQmCB77qYXoUrEoDrNOLXWlyZbLLjWo+95XtIrP+QqCuttG7nrA+I77r5WFXCRLcPBgm4mGXL+Z/o4WvLbEb9QaG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A5ACD5/q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DXdd9G2z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A5ACD5/q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DXdd9G2z"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q5XeG6019658;
	Wed, 26 Feb 2025 08:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=e45uAgucUZjTdhUHjuyQ5V/XKuehWpMZWC914NnqsDI=; b=
	A5ACD5/qd1KVtADFMDuY2uKSJEzahNFOIAQVReudhKqVDcRQST6UUZ6KLy9dtvAu
	vk3M1BzSoYQFWPC13bsAYZzre5cTQ56Pct2B+ngsHpO9MbEf8wGt99KlD89V1CRx
	rxmkxUIZwGILhu0/FaTP0zqbwRLMmCXwQlpqtChh1vf6rVvARayEWC1PDX1XKV18
	EZzxNHYJie32nDiw4d7wkk7Ced8rJ7+cQYwVzRxcwY7ssh1ySwlIBZe9K8cEjyYQ
	2cbdJDhnGvH/skJoBy5so/l/wp8vtd5m+Gd0L0+Ur5TPIUm3+8cMVF1yKzZ4bBU9
	9W6KQkApYe7WFOOstoenJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451psf0n79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 08:57:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q6soRl025484;
	Wed, 26 Feb 2025 08:57:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51gxsfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 08:57:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=az5zhqJisB6SlP04qfg6qD4m4FTN4jvwL6Q9sYSDSJimt919b3ixDm7FcjFuOG1HRu7GIeWJl5yOAdreJYHPFgo2ShGzIzFt3rTU7hfnHn0at90zfmlQrKM9VUFgN8zh4pTbqt0wn92K6V8WrDzJ0N/WWgENgptrOz6YKb9N7Qccs7CdtxQGY1v3w48Y4vDYhKawxaa1B9MTlZ7fu/fKhhZThv6BmDyJULIBXJVfD57pjGUC5u4VH5osIU+oYmfI0OOHRG4gP0l3MlkjMz9dZCC2W87lhTYDxoDiFaARvRJP/5ODJRg9B2upuJK2zshEC5Kz40HOFXiU6UgHoxpA8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e45uAgucUZjTdhUHjuyQ5V/XKuehWpMZWC914NnqsDI=;
 b=E+V1eHbqX2Dn4osfCavMyDyUrFamJSlMKoDLbvucNSKmXVHdv6KED/pYikdJFrrzRBKukD0ANc2WdD7TqwpLEoi8my2qUdhdsJsLejLmJGZ3m2sfKzEJyMh7/TIEtTOcVn9QBqzYm+59kDJzXcRYD7aSE5Btcdj0wkawILxWPh+uV4dMhZIuxQQF6G4U3a7kTqmNPjMjhOOT7yNnoEcmg3XKVvcaFIpHDeeOYG6PskUjO0sxSvk+ekr5bV2FxVDbNwGXLrRzmtJig0+us7AMcQvkLyApgzicdnlV0RrpSuT9ss/9SQEGMP1OIpM3zo5j8pcmemJBBSVuVlWldjGtLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e45uAgucUZjTdhUHjuyQ5V/XKuehWpMZWC914NnqsDI=;
 b=DXdd9G2zgp8j+Aoau/tz4xTTyajjzUnaZFcb+gIaK/4LhkJuEkewv9bjAvpbERtPL2E/FnG0nnCihE5jeVelgSNUZnE7tgWI1CfozU1koNxCjXS7zngkgzCBMrBiLSSiFghGgMCng7ZcTOew8O9eSRwKFPZRkvVq3iJT3VMPKgE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 08:57:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Wed, 26 Feb 2025
 08:57:21 +0000
Message-ID: <4f287a32-d24f-47dc-bec5-a4b94895e135@oracle.com>
Date: Wed, 26 Feb 2025 08:57:17 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: yangxingui <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
 <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0250.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fbb10dc-1a25-45e6-f746-08dd5643949d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWJOWlRwcGkwNVRiNjZ6QlJQNGp2TStCYXZlOUNYUjk4ZjRUbWR2Vnl6K0Jx?=
 =?utf-8?B?ZXBLZ3oxQWdLOVhnZkEvZ3NiWkdVYjNVRDdYME9DU2ZNa3RpVnY4UWVMU0Zn?=
 =?utf-8?B?OFlBRXpkeURPZEFBdnYzTng5QVgxL05iVXRmUmxEcUFGU3NnOHlyUm84QnQ4?=
 =?utf-8?B?aUJyaHJqbUs1TlYyeXNRVFgwaTRqWFh0U1pPaVNNMnltM0t2L1VESEh1aGJr?=
 =?utf-8?B?V2h4eVM3Zi9URTVoSC96TndVVVRTeVIxdWZoNnZWTG5qR1NwU29FUGhrR1Az?=
 =?utf-8?B?cGhjaTBVbG9HYmhzN1ZNekhMY3EzcnV2cFZPemNoaG12cmh4dFp2YVRta3pk?=
 =?utf-8?B?dUhldjRBQmlXbnpNVk1id2lnWFdkSitITFcrWnIyWDhJS25ZY2dIVlhrdWk2?=
 =?utf-8?B?NlZOLyt1UU03YlVFNGtTQTY4S1dndFVod3JMZWc2Ni9QYjBHRjNUWjNHU201?=
 =?utf-8?B?Mk5LWWl0NXkydnpmL3N2MFFaMkRLKzRYZFFGY0t6MGZGZXhPWE9jMVhUMjJz?=
 =?utf-8?B?eTM0SmI5ZnB6QnJGMlYxemYvTFBhSS9vMm5KM1MrNVNONDhpZ2dSSDRlWHg5?=
 =?utf-8?B?YmJ3MTBFa0xJTVdVV2RNRVFVRUhZK25xNklBL2htZ3JmVE01dUQwV1R1d0s2?=
 =?utf-8?B?cVA1cmlOOWFuWG1qWTM3c2xPK25hZldIZWxKeWgzNjBveUw0ZWpudWt6c1hz?=
 =?utf-8?B?Q3VXblk2VVhGcHJmaVFYVjBWS1Z3b1UzVTJnQXZBRytIUlZ2V2hIdE91K29B?=
 =?utf-8?B?a0h6VmNtanNJQmhOaDU4SGpIc3ZVd0VRc3ROdmtiVGZhaFFDNExtdkVnVFc3?=
 =?utf-8?B?U1JyVjQ0ejRmTGJUR2tnZXRNcHAwWHM2S212cWxseHkzM2hLbk8zRmJub2tL?=
 =?utf-8?B?UFh0SW1JenJReUFaQ25wOFZlNFM1S1RrN3NhUmZONXlvdWdmWll3a2tzNWhH?=
 =?utf-8?B?cCtWSFhUMkRWZmFhRE8wdmdvbHZYK01YTW1KZjF2cHpQOTFQK2w3UlRGNS90?=
 =?utf-8?B?TkxUSWNkamtDWXhQUjBFYU1NZ3dMMndvaDVJN3A4cnI2ZlNaUVhycm8wODJx?=
 =?utf-8?B?RXArY1VLcGxSaTMrRkZpbmxNc0h4YncrdC9RR2tIM1NQQ0Fzc2hUMG1FOHV6?=
 =?utf-8?B?OEpSdG5za1hWclRFZW9MUEhqZ3QzMHh5MnJJK0RqVGhmVXRjUE5ZWmlkVzN3?=
 =?utf-8?B?VllpS1QyNjBtblpSKzBHU3NvWFU2d3JTTHR0WGQ3b1dScEZaVHpoYlZheGI5?=
 =?utf-8?B?MVhyazYzYjVKM0xMK2pNd2c2YzFyUi9oSFdQOWRQQ0s0aEtlVG9LS1JhWUkx?=
 =?utf-8?B?RGZBOTlLdGc4ZFAwdVVFWWtXN3ZvckZhdFZTQkFGYWwvMHhUL3JoZzU0SFZp?=
 =?utf-8?B?amZCT0lKWUlkQUc2UUdhWnRXbWFhRXJGekdoSkVCRlRxSVEyMExJOWc3Q0o4?=
 =?utf-8?B?QkE0a01ZUlovTzYrSnlrcnhTd2h1c0RBUGNUZkx0WGNtNlZ0WlpkTUVld1Ur?=
 =?utf-8?B?MldsV080VldKU0kyTXdaTDF0dEd6OTRjY0VtcWJmejNOelFkbGJJeTMwS2hV?=
 =?utf-8?B?dkNlTXIyMWhwZ0FYakkvZDhWZUFwVktwUUQ5T0NwL2tUYmpaWHhQZlVOS1dp?=
 =?utf-8?B?NlRRYWpjQ0tvdGUwaGRCSWcxWTBacEtYWldhc3BCMXJMVnFGQStZTzA1R1lu?=
 =?utf-8?B?OWgzVm1MdUlCTHRJVjlNcS9XSlduckRiNkx2aFZ5cVZlZE0wYVpLWTdrS3FD?=
 =?utf-8?B?cVNIeG9oYjVHbVh1cnRPUTM4dDBjU0NVNit5Mm83ZS91b1VFVFYxL1F0aDJo?=
 =?utf-8?B?TlAzdE5BSUJlMUVkR2RkU3FFS1lEOGFHQkFPU2F6UXg2RWNtaWpmdTZ5V25D?=
 =?utf-8?Q?Y543Z5PHkG+B9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnJKdXVFckY5L2tSZWszenBDcStEcUNmcnZnOW1ydjk4eEJaL2xsamE0czVX?=
 =?utf-8?B?aS9GSWxkVkplNkFuTWpNQjlHdzlFWE1UZDF0S2dkQnk1ZFVibFZSMTgvdjJV?=
 =?utf-8?B?ZVZERjVZaklWcGg2UEtNc0k1cWdkZURUWDd6Y0J3QmlrcThTREhtMnQzU0g0?=
 =?utf-8?B?ajROYjZvMjU3a2ZHanJjYmVtaE5DK05vR1luRXdXNnRyN3psMUprTjFkWHVa?=
 =?utf-8?B?d05QeGl6RnNjd2hyRDhLaTVvK0xqSVN6a0ZVMGtIdm9NSDV4NDZFNmQ1TUdo?=
 =?utf-8?B?Vld5eG5sbXA2bWRTK1ppbEF5OHJWNVcvUnN6dTIvb2ovWC9SbmhlUGhuZW8z?=
 =?utf-8?B?d3BGblRNWDJsVnl2NityM3pkTGpnMmlsYmo3VE94eTIzN0x0MFhmdEJ4ZW84?=
 =?utf-8?B?V1Z3TVJmNnZMTy9qU294Q3JQU3QwTGJ5UDRHcFhMTUhYVEVnWk1YZWJKd1hl?=
 =?utf-8?B?dW1qckN2Nm15TWJFL242YkJ3OFROcUY3cTRvSHNZbkNaNFZlcnpLZ0Q1ZDRM?=
 =?utf-8?B?TzhqQ1ZlV1N3SVlIUWVCdDc3bGJ0N3hSQ2k3Rmk5V3FVVE54Nlk0cFB6RDRq?=
 =?utf-8?B?d09xc2xVTy9kWUFqSlQ1OHJYN2NIL1FWTzB5cmt3OGJiTlpJWWp4R0NEdGRn?=
 =?utf-8?B?R29aTzNUOWRMR0VUb1hKTlVUZWMvUUo2OVpmQWRFQVlQVzA5aHJGZURRbXly?=
 =?utf-8?B?Z21taS8zVTRLdlA1S2xVZXYyTENSRUlFOTExanJ2TlhYc0YrS2NQN2d1bUtq?=
 =?utf-8?B?bkRDdk0vanBvemNmckJPOEsvWjFjbXZ1MENuSWRNdUQvaVAyZU1RdERRd1Qx?=
 =?utf-8?B?M1gvTUx6b0haamQxdlo1WjZpeGN1aUd1SWxGZDQrMFZZZmw2WW94WlZoOTZx?=
 =?utf-8?B?OWxUVGFPMU8vUjhBMFdsalZ5WkJFeWpkMWZuK3pBTnhhL0Vhbm1zbnB1M2ZK?=
 =?utf-8?B?Q1dMaHhrRmh0TDl0TzRnc3oxb21ScEs3aFp5azNkczczemRaRFJNT0dXWlNF?=
 =?utf-8?B?bXQvNnZ2WjV3S3RYRndsalg3UGtZZ1RZUUlEajQrUmh1QXlCcmJCRGRiMDZ4?=
 =?utf-8?B?QlNVc3lWTVA2UWp1aEkyWlgycUZoaWpCaUJCMW9XdnlXMWVoSkJOVi96c2xl?=
 =?utf-8?B?VTJZWk00T09KL3VCczFHcXVuNVFzajV3OEJhclA2SWtNTCtrc3pBOTZXRlNl?=
 =?utf-8?B?Tm9tR0dmY3hRNFVBeHNJcU82dGF5cUtLazdsMEUzWjF3ajgxeGFnak1JR2tQ?=
 =?utf-8?B?aCtVZU1oVi9wMDRGZGZDZjBzQ09WSnpteDJPeFYzeTVxTjRGL1orb1NoL29a?=
 =?utf-8?B?K3ErUVBNaUc4cjAzaTFHbEVoUm1jMXNYZXZ1eCt6T0N0QkdocmFpRWFRQWVy?=
 =?utf-8?B?MWdXK0ZrcEpndTJsNmhmYWRoRFBWOXJydFRYUndmR3VieFhxRUJTLzByeU5G?=
 =?utf-8?B?Q1NDWjZzMUtKeFMyNmxSai8xcStEUm5iYzhVc0oxZGtoVWR4TzFkdjJWVTJ1?=
 =?utf-8?B?UG5hK3NUS0k0QlZJQkJYV3Y0QWpscXl6Nkc0OFBRRTJQTWhFNXhKTDhsZkMr?=
 =?utf-8?B?T1d3bVpZOWxNRFk2ZXJmTzF3VC9VT1p4SWhaN0g4TzNuL0J1ejE0MmhUaG1S?=
 =?utf-8?B?U1I1alJjOTVKbUZHSW4zWEgxam85SHM3V2dpTjZNYUQ1a1VhYmhJUm9MQTFy?=
 =?utf-8?B?d3pjN2YzNUYreC9BNWR5UHY0V1p5REdNN0JVQXdtUVYxOW9oSWxIa1AwTWFE?=
 =?utf-8?B?Q3FkeTF6YlZXRFpiWDM4YmxTUGY2dEgyM0VOa2Q3bkhhMXFrcW9YeTRPY0RF?=
 =?utf-8?B?ZmVpVExoaXVRelljbWFaUTZSL3IvQlFYT0NSUkEzMnJNTlEyMVRVOVNxbmlU?=
 =?utf-8?B?S0dWSkFpR1ZhSWt2TUhQRzFXeDJWR3dlK1FvcCtrQmxkemowQy9WLzF0K2pO?=
 =?utf-8?B?d0h2UE14dk5qSzVQZXNheWtiK3A1VVAvdE9WbUJIM0JWOUVjV3NMRGxxQXB5?=
 =?utf-8?B?aERiMEtJVGxkWEdJNFNDQS80MWVZSElwWGNreTAwWU9hVXNkcjBoVkJEalR6?=
 =?utf-8?B?cFdXTjMvMXpNY1JGdmVGSEdDMXU3TCtVU2xXZENhLzZIei9nS3hGTjdHRmpu?=
 =?utf-8?B?TktleCtRQ2tPMlAwM2o0cUUwelkzcW5GcTFjQUtlaUF4VE1xOFpNQzRLU0tG?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kqv1lgPxHofagbvOBh14Ahw/MSmMKRIeHT4OeH4oWsjDbzKmZHkpC0w4uIeehAd5+kUtiQJAoUMnzs1CE1nhovZV/a9Bmb0O0d83hM9jw6GYF+K6ff8AXUbVllmW6pirmfmuXtmJ8ZzShpXsx+oITz9uBXaY7mYzisP4YRALtVnO6kcnzEUGvKg9oxfjvjTq6vqIf9Oqob/NhZQmkVa+JJapYb555L4JExQDVlXu4GD9U8YwXB+G7gy3MTLza8G60JYe71zPf3Coz6OXhJCnYAp2/TeRV9DQLoa84Yo5OMydNvDXNTn/ZprSvPQg9MVnrDvSl08TXFZshnFs6bH8G7prEeGCqWZxfDf+OAeciZI8VEsg7ttamEAdr5hSDdQ+VRWlSC5r5hBPtKuPlWs2OboOnXkmIAFP53nZJfK4oNrXBc3R81RwKmGqS1GpUXSxkRrrS5Kq6JKQYLYFzalpd0y+ayl2Pl1jUA1174sqpdeXiSFacyuxzR5COhXaF6xC/N5bgtmNpz9WLE7EiFoO9Jw8tORgvz9oU/hzTGum1Vc3Wp2eVCN9k52WhON/D1ntTuuzqnJLGKi6O8pywanGhmILkUFsba7e22zHqsxNq5I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fbb10dc-1a25-45e6-f746-08dd5643949d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 08:57:21.4894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGm6IPxBYNsLSKK56vjLOTLdvFvtVy1C11KrNjLRr9hVgAD2bzM38H/41ltdHBDDBfwx/ijGKfBNpbKhBPMaOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_01,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=631
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502260071
X-Proofpoint-ORIG-GUID: 0ra4d5nmvyUAF_PpW3jOtF4ZVqlB88O6
X-Proofpoint-GUID: 0ra4d5nmvyUAF_PpW3jOtF4ZVqlB88O6

On 25/02/2025 09:35, yangxingui wrote:
>>>>
>>>> pm8001 sends sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,) 
>>>> link reset errors - can you consider doing that in 
>>>> hisi_sas_update_port_id() when you find an inconstant port id?
>>> Currently during phyup, the hw port id may change, and the 
>>> corresponding hisi_sas_port.id and the port id in itct are not 
>>> updated synchronously. The problem caused is not a link error, so we 
>>> don't need deform port, just update the port id when phyup.
>>
>> Sure, but I am just trying to keep this simple. If you deform and 
>> reform the port - and so lose and find the disk (which does the itct 
>> config) - will that solve the problem?
> 
> 1、phyup ->form port -> eh -> ata reset -> found hw port change -> 
> deform port -> let dev gone -> refound
> 
> 2、controller reset -> phyup -> finish controller reset -> found hw port 
> change -> deform port -> let dev gone -> refound
> 
> I also thought about the plan you mentioned in the early days. The above 
> will make the process more complicated and retriggering phyup may result 
> in a new round of port id changes. Lose and find the disk will cause the 
> upper layer IO to report error when controller reset. It seems that it 
> is better to make the upper layer unaware of the hw port id change when 
> phyup in reset, like ata reset or controller reset. ^_^

The lldd_dev_found CB is where you should set the itct, and it is only 
possible to do that if you report the device gone first. So that seems 
like a simpler solution.

