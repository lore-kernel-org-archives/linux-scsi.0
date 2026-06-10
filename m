Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8049030BF6D;
	Wed, 10 Jun 2026 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781084294; cv=fail; b=T8vb4kaOwhFawwz8Vcn1FzrGZDhrxOSgc9zbyO2V1samormA/C5SOaLy0eBBryu26toEjs4twekvjMILKBV8QKDEEglYYtYXZXRjfIQ917pDfFJCRO3OkHMThvHyuz7KXrW9TKBlhyQ0+mAYACeIX445jWRx7o4MKxLEjNC9cIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781084294; c=relaxed/simple;
	bh=X2MwNVRvWvWt8mpd1fZlQIvA5DHPKAB3Mz5zfeFb6Wo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uw5s7Ro+35J8PejuOJj8mK9nYHoMNJUErAc/peOVb7iJp0zk2eD8l0tAE0gCWJSEI+P97VzHlOqqPRP048hCFiew/I2Zhj10vIJ5ijwMjWLiBA3etRVH5xvrkl/Pioe1SkxvJiNIl68MCQV1oVCPZ4kzVuLiewHztiyBktO0enQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a06/KZVX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YelHbKhQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a06/KZVX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YelHbKhQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A6MUkH2826196;
	Wed, 10 Jun 2026 09:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AD+k00bCpxMiV/g4k2tbO308Nag68oY55tF/EpbDdFc=; b=
	a06/KZVX6oXXPBrwLbuPI647eIzVf8jFgpGWhwm4qWmci3IryBL8Dp0bvau645cP
	/Ol5LM+iBXrxWBteCoElnsle8yHVUBfnJdfugflRa2IV8E9lkbpHDGCqhbqhMzBo
	ZG96JrIRtPtMJ40V7Z8eMDOG8ewcy0JgqcrQ1hJrJWS5hZy6XM/5zSORc+7qHbUO
	1pZdyW/QH8iVEeDSY8LcEiPUEWbDQsIr6wJ1kPJeDXdpc7aGO6w3CXb68fbM9/ON
	V1Dmn2afvcMEaUsjRwppbw81si1G7CirQ61CvdiSmqmK0tttdo3tOEwyoEn9aF2W
	4rZvQC2lx3pll16m35wxpg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emc3rp6gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 09:37:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65A9XaRZ022859;
	Wed, 10 Jun 2026 09:37:47 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4eq4j8t0a8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jun 2026 09:37:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jcoZdKTQaq/neyzhiLbI1V4AzVAxQP52hI+1okeZpdBBi2jZ+BmfQF7H3fBlGCPFxxLmEaiDEA0iza/v4CBcNiHqQnBqZOp9pveQnbtnzpMix3caDXh/n49eZNp1eOKTCiIqkRyGA5VZsQ0HNoFlIcZ0KNSf0ygH+wKA2wT+2P4d/QQzrdgbso20aPmnqnBjBwIpitUs9k2bX7KQkr2THD2hnBERHRfKUbqY6H3jOBebVfeuSccyF1QDDpChQFzzVmkkNM3JPnvIX1CX1OK6xYGBZOrOf/9+KecvlPYOn+jadmF8HTS6JS8pSXk/VPngc50ZWGBIA9o1aehfSgmOQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AD+k00bCpxMiV/g4k2tbO308Nag68oY55tF/EpbDdFc=;
 b=X3LvmzyoGVl7lF4aOt0FfrzYccym5AkM0T9gmSMTLshcL+ZgQPImCgBXkcbEwqrSCtwtxOexpJEWQciP0ha5BkpGwtoQPpoCvtWU7f19VeTHOid/Pd4MtMl/9eeI6CismY/jkiXRdxYnllNQkioyqmJX1+tKDcgXuUtWz9uJMsBaltSIeHRYVEf2YEdO2umap88nby2Ye28vO9k7zYkmJ1yamCE2CpmCFOv+QFzEUecGUNF5lTclj9dvqDJiKmA/37LXogBCx5ec8whmidQY6exbHsdp0juwch49WFLFpaYWCWEPnickzjNPx+ctI1zxkCL6mOyvXXFKvFFDb9/fww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD+k00bCpxMiV/g4k2tbO308Nag68oY55tF/EpbDdFc=;
 b=YelHbKhQpwqmhC49NKkUqn1mdZ71b1ZWTDlfpQkk8S+M1BYPM7Kjkj3IcrgcyWk2+PJMsXQKTx/O5gvaVL0B0ICoHc0NKdLGDwkj39ZrgtPeRLeyCF+nKKt7noMB7txQhZfVuM/Hdxtq1irhfkleZAuvdGVTnP+ZBo9Fk10UcKA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB6981.namprd10.prod.outlook.com
 (2603:10b6:510:282::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 09:37:40 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 09:37:40 +0000
Message-ID: <f51b19e3-0848-4384-85d7-8fe7a7b11754@oracle.com>
Date: Wed, 10 Jun 2026 10:37:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260603092124.2221524-1-yangxingui@huawei.com>
 <20260603092124.2221524-3-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260603092124.2221524-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0003.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:26::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: b1fa11bb-76b2-4885-3ef5-08dec6d3ea35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	w/yrDO/BwYfPb1teualF0cGGfVLozlqgOzypY3J9QxyHNIvkH3JNYKeHpvVhQ4wzkzChBv/OddUB4K3UhAqXVaprM6OVt9/da9Usg7yx7IAKd3m7wqlk43cMdaS1EAiHxNfA6IL0jsPxYj3c94l8FwF2K/pA97PuvJPmVRQSNzCU8DBhy4ySiYcSgSb9xY6y8rPLZQGTLw3MSQywjV8BdDVmhVWDcgOGK4bnTKCDY34vJKoIq9Ipncsj8vPMkZoje+RFsD6J7T2GqQwbboNJgeOImWz41XLBb1tjF7aAqFf8+f6pz197Lg05VPRfoIZkKGeS9o2fiC2R4jUu0bqkjKO5h9NWja1WClwoMazjeXxF795Y+jA4KnuoqHc1ri66Z7CBgOwdLr6MmswVcwXgvBPopXU0ZRA8CSqzE3dsB3qQ7sH/ACKUKAxnbFVyLDtDnqa5EhDAlTPzAYPe+P/DgYukyjYgOgLquRn8IL8XHU8GLHiQP5H1U5dfNY0CisylmhDQUhv96l9Zui61Z1qZAa2ltchQjFbYKjxBKfihKGPK+aoICDPPsF3Q4Z6etlqeg2kCF5ek4UBMmDE7/sTsK6OHtQFaloU8Vn5Fc7uw20fQbAyChPsKK/G/pY10zvxDkZLUoJgMrnJUEYi+b9Qbx0ZvH+ykEHpvmHP0j3hwHzn/2da7HT9AAJ0186EuXERd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDZQSFFETTJ3NENsN0t4dUZIMWhJYXVhWHBWMSs3TkVqVXpFNy9MT3NUSUMv?=
 =?utf-8?B?Ri9iWmlSRlpuTUovdjUvQlB2azU0dllwbTdSdTBwQi9HdGlGVm9SV3VoL2xp?=
 =?utf-8?B?VTVBOHlIejU2VE1HYml5RUMzSjdDdXFEVUgwbndUcGUrUzNnVERKRUFvb3A1?=
 =?utf-8?B?Mm80SC9mejJqOXdhbkR0aWNDQjJaMnVpRW5SeTVzcGxNWmFidW83NWFEMElV?=
 =?utf-8?B?a1ZwMWZsWjMrMjhBSGMreVNCdWxRbFlua2VXT3MreisyMnB1a3pweEpKdHpl?=
 =?utf-8?B?eTlaYWJoY09WQm45a3VYZmdZYkViMVZUMnQ2VlU4RndHUjVhcWFnTXU4bndw?=
 =?utf-8?B?WFZBM2ZOTDA3NGk1eEpMcnBKeTRDVVJmMjU1VDJDcFBrZmI0ck02MWVEZGE5?=
 =?utf-8?B?QVp3ZlA4Wmt5SkJnRkV6OGtZTnBtSWFjMG1qT0RQT1p4OUM1L1ZLVXU3TnRM?=
 =?utf-8?B?UGtWWDhBK2VReUVTdWhNakZKclhwNDd5RzRRQzZSck0rcGRNc1dld1NLanYx?=
 =?utf-8?B?alFnV2NjVmc4ZTh3T1pQKzY5YTZ3MFhZQ0lORFNTb1lDNS9SVExmcVk1Y2NF?=
 =?utf-8?B?SnFNUENnMkNPL2w5Tmhqd3h3L2g3Y1NZdzFRUE9vbGp5Vit1aEpDaFE0S2dT?=
 =?utf-8?B?OUlxdzliN2RVSXN5T0QwbWpLS0Y5SURBRWRUMlJaQmJuZkM1TWZJODJLNWNr?=
 =?utf-8?B?OTdoY0pzYmppSnVaYlkrc084SEFBT2x4YkdZWEFVd3psVWZjK0xlVzg0YklL?=
 =?utf-8?B?MGxmUDRHV3B3WHdGVXVHdS9XKzJQK1l6MjBCVXVFejhEWkpJMlRGbkJtKzlT?=
 =?utf-8?B?R3NTOHpGZVNNQks3M0J1dDJyWHZweVlWOTd1VmNyVklYaUdrZ0dZSWhpbG9S?=
 =?utf-8?B?a1pEVWNna1NZc2UwQmx4Skp6VXNNYVJjZHFFR2NndGFrWWRsOUZJUGI2d3pQ?=
 =?utf-8?B?YWpCZFB4TXA5RUJDUmpDcmg0RWI1TDVLUlBHdGlScVcwU2JhaDYrbFVIR2Fk?=
 =?utf-8?B?MlhObmpFbFZDVkRFL25HbU1RU2p0UWdSQXhIUHVKZWl4T0RBY1lVd0FuRGJN?=
 =?utf-8?B?cnB2MThucDg1WVVqVk5vMklpUGZjS0QwYW1YbFQzZ2x0NkN6OFZGWDFod3hr?=
 =?utf-8?B?dnZXbmg5a3orbzlpdldIcElWTm5JWTYyR0g2OEQ3cytQOUw5NjFSNVJ6NENY?=
 =?utf-8?B?NXRVeUFsRkVoMDFvZVZPandlazlYNnFkSnorVzFsV0RNS1paK0hxSUpXZ0dF?=
 =?utf-8?B?YlhwZWpYdmR2VTRKWDFvWTFJcC96NlhyMzYydnNUbnRuQ3FFdW5TNGZNVnFs?=
 =?utf-8?B?Y2R2MXVaUjU0MXJvcXEvVkd5ZWZxOGkxY0JTOG8ySVNkcURtLzdaSTRES24w?=
 =?utf-8?B?OHdLZG9PSWl4azkwOTVIajRZS3o0K2xJbzVSazhwMkxtMXBKeG5adTRETEZk?=
 =?utf-8?B?N3FwYnNuYmlRS0kwby9XY2xLSGdOU1hPUDlsS0VNWlU1Mlc4OGszbW5CTHpS?=
 =?utf-8?B?MmFNeDZIVktnYXpHOW90YnBVcVlZWnQ3NnA3dDNZOWQySnRFMmw1OEdhUlpp?=
 =?utf-8?B?cThpK0NFQklDckFUbThCRnZMNmppeHJMUEZPTzF6bUVwa3RPbGs4c0twcW5l?=
 =?utf-8?B?UVo3RFlUV01BTDBvbXRBb0NXZHRuN1lPL3ZHc0FPV0VEM3diaDFWRUtpWTRY?=
 =?utf-8?B?bFc2SUcxc0x4Skp5YUlBNHFHQkRLVy9ycUFEL1UwMEwydTg2bDVydzZDOTlE?=
 =?utf-8?B?ekpiblJzZk9naDlORXc0NzZBMWZiakJ6SCt0V1lDNHJIUXdOeWR3UWFXeDZY?=
 =?utf-8?B?YlVmb2hzT3RHc1NYZEI1ellpMC95aFM1UWZ3bEpEVkxzL2tlczd5WnFhSjZn?=
 =?utf-8?B?MExjUzZaR2M3WlE3NUE0ZzRLbUh5dHNVaVlZVWkwd2NhZ3YxQTh5QjZvMHhJ?=
 =?utf-8?B?VEQ5OWhDSnV6aHM4OFdEb0Q3Q1dML2RxWTh6cDczazVwbDE5WmJicG8ydzR6?=
 =?utf-8?B?eDRaeHd0RytEOWVVNWlTTjV3Z2RWblJ6aTB4Q3MvaEkyd3JqaGNhSVd1RlJE?=
 =?utf-8?B?Yk9RaVdDRjZPTlg0b1ovUm5POUJzYVZoM1ByUFJnS0kyU3Q2RERUTjRqQ2N1?=
 =?utf-8?B?S0ZQTFI1aE1nMDdrazQ4R2t3cTl5ZFBLVkxIWlU4QXNGN1dhQllRQUJJRHZW?=
 =?utf-8?B?QnpNOVI4eFNlSmFzZE9UUWNzZEloZWhpZWxVUkNvWDFZL21QUzF3Y2FXajJC?=
 =?utf-8?B?c0MrYkV3WHVidE5ZK1VJb0tORGVINkwrc1plSmZtNkZDR3A2RHE5S3lBSXJD?=
 =?utf-8?B?cXRCYXljU3dTWGJOZXFWMlVQNXYwM1VaR2VHRWE5ZXpXb2wxQlk1UT09?=
X-Exchange-RoutingPolicyChecked:
	EhXVndGE3+1Y8u81HDt7KThM7DkXPx+I/2tMwkO8u502wP6NJd95CjYQUvkbc3O/JrpJzPHsdm8djpLRBzQR/WUpkFUfzjrHoYIYtfcAeNNQQRan/06D8hIxIlXTcER4nSofW90m/sZVO+VjXhSUp8LO/Whuk6GJTrG9hhO0ifFB2K3JnFuxxp/hC8XOytsz/b2ovj5tMZOL0814awYGrWwaZMOn43dt89NmoAdm8/5CsJBvVcewJJPgVETm944+hzfWGneI9SPyk/D1kzgLW5IswiKXe1dwXSFLHIqk2rrud1bNj+equuL3VDHP7vUVIGGcpU+D9MEvoLI0Uve8cA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1jsVr43S0Jv7LoIF2lhdtCWgwvGydZrWy9rGLvbbUDmzmqnWNSupwm/lmrDk0yMtRr5nwl00++mBSMtvE1YkburPnJxMr43fXdcSRDRZr954OZfH9CznTsgdWJVMUhbGt9TDwJyVOC2TiDB0Ok7YREz9IVmr5nlFV5dCLbnMtK/Laud2cSpFwjojB4lgcZCNqZdbQ+WyiTPfonscsxBIOdPtNv0isNXO6ne5UCM6pAfIuN95KaWsyWpxjGTbxGInIAfw+7htmtkRWguudQ9VwXBmaO5ts482rCW8NXg6gJQmzLgtvwmwTtEY6pBdZTS92WWIdoHacv6rixzsu1WEfpHXEj/gzjgVIX9pabwHXwvoCtUsZDUnl/Qk6OqiEq1nqcxMOrS7VP8VdcBGzFxjj2itL9Kzy2kKcYog15xicSx26VC6a5s62nU/Ju6kDai9+o2vmCSSekg86fpACT02fw/a3R70tNvARWD03xpAtfAQRjT3tdRL4Ed9XfXXqT4Ry0Oo8vv9L7DVTkNQEdWHFs78Ij6tG5MzrCXCnnP+1C8zG5eJ3JUhunKVZaEIhhSpNMfILICPl48/CQsEjKLGI4tvawG4hHs2FAUqdWoGoUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fa11bb-76b2-4885-3ef5-08dec6d3ea35
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 09:37:40.5057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CUsQr0cy6prp8csJyAFnUswQOi2USB+q6KlXGMcLS5L/5ulmlwymQFLFBCZRCME+FRQs8P6ES5OrReASn1UA+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2605130000
 definitions=main-2606100090
X-Proofpoint-ORIG-GUID: lGJqmfOSIcAmT-6bX8POjEEY46YXb7ws
X-Authority-Analysis: v=2.4 cv=crirVV4i c=1 sm=1 tr=0 ts=6a29306d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=fcgfppVIOv0AmPHSFeYA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12312
X-Proofpoint-GUID: lGJqmfOSIcAmT-6bX8POjEEY46YXb7ws
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA5MCBTYWx0ZWRfX9cF4jRFjWZYY
 mJ/J0tCmJq7MVcMK6EW2A0s0pZwtf1pW3DDBeeszy6bNGnknzeAggtR+UqgnKGhsonyJm7W+F8A
 /4km++LZII64l9nos+FPcmOM6wMjIyY6HsyNDsd81RPgvaABwErYa4nXKzqY1UoSPssOfpxMKvA
 QbmpK2qsZnx1ShuGveB6CSzw2SLMTSRxA22Z8axAsmRPBS3Ja26wjX9FrBTX/I5TDToGAYicf8D
 b5GnuMNb+GS827NB8XRmqFVTp4uN2fFcOSQcjozQ2wDEjVMSpYuu98jdpF1KpfUtXak+s80NUev
 KdJXUXQgmXb55YquSCduLAh7yclyESU/iZ6ZvXmTXfRKZcg/5AVQLkFm29p3lUmjyG2RWtuoJ9V
 2WWctLeabemvQZOc3pa0cMdnbLc+B+Bd3ng1b6jlwwAQblwCG8QfapKFuSK0bzhi0MOuyYpuBZk
 UkwfrjKSdLAv84nxOy0UxZvIAoMpyXZRHlVakZmo=

On 03/06/2026 10:21, Xingui Yang wrote:
> +		return false;
> +	} else if (SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
> +		pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
> +			SAS_ADDR(dev->sas_addr), phy_id,
> +			SAS_ADDR(child_dev->sas_addr),
> +			SAS_ADDR(phy->attached_sas_addr));
> +		memcpy(phy->attached_sas_addr, child_dev->sas_addr, SAS_ADDR_SIZE);

can you comment in the code why you are going this?

Thanks

> +		return false;
> +	}
> +out:

