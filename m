Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713344ADD9D;
	Wed, 29 Jul 2026 14:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334005; cv=fail; b=dFxVLM0msHcNnWXAZNWzq25jz9KWRW+SMHSl0uYbISEce4T3NLy3spJ9CDO+vMVm/aTDcweTqS7rknnw1ZZnU190ltz7YPrL0Ayhn48WsrkPNgnvBrjxeh0wZMzDhkaTZGXDQDXoainiQ+V31PJpGPnv/KV9uXfj7oE5AW/fGuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334005; c=relaxed/simple;
	bh=Gboww4ZgLug+0L5VPMVzIsP5/OREhZcSE+vOED8CPWA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XL+n88RUKB5fcEZNEJ+q9xZiT3wXXFRs8sIkApUJp2q2LL/BIbYcm8aOjU/AquJ0N645zlIB5VKkV1u3xlZ2bbIqqbX0lO2IFAzOukGS9ubJSdgnfZMN1wZLKLqudlgl17GJQouSM4xYJg/2cBRqH1LPjzZYCmNQTyWoVtlbWS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UiPjmkMw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Fmp8ifGA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UiPjmkMw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fmp8ifGA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTKcL4018871;
	Wed, 29 Jul 2026 14:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jkz+2B7bNmsFjFY6IssH7N05/HvZBfqBcPLmVFaS/Mo=; b=
	UiPjmkMwUsLPZEVnhjlXpf/o0AJ56lXJo8jixQEfwuQ/comm8h/Rnxvhn+tJT2ye
	x64U5EQapYT5hFlc10u4Z/ctyV9oKKPsn6Ch1UEU3eMQ/pXdakZIYLXRd6EU3d7a
	ADtktK/SSTj1k1nNKAr/yrBG3R6s6/M7bBPA3lohS2jXM4JeJRL/+ZKRnDO1u6oG
	NFgrXUSffKz0N1pxlU2dZONSnYbx8gsGoA8VHtrTrIl+HduMAH5K7Btg796wFm8q
	MhsgA7UfBtZKcB4eEWCZoAtVXR39jQiPqPHOhi6wPwv5BTlw5661lckT+9RzyCXr
	YjQDKuxlIAeS+lV6adUKoQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyye2td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 14:06:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TE0dc6005702;
	Wed, 29 Jul 2026 14:06:41 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010059.outbound.protection.outlook.com [52.101.193.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6e0vpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 14:06:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEaAroeQtvj7DCMxptEg/HlzSFejbRZCaPlEZdcOz8T4mG0O47gkp1CX/JDbSvYYVlSG0mDQ3ju4y9fY4JiF8It4JbkMThks/gU+OwBQQerHc9TaKENgosPzGenRZyPknXB7uaM5B4of33BUfv/Idf5zwjmdRbXfE+KB+xzRN6dHijrIQh9rBiOU4ahFy6toyYG0qFZFk8HKn5zwAUu4CFnh11In9qwOOoQ/xrdyYN2Dr2gtwWpecyMhYyTftAg8AH/SJOwttGxhk2jD4fGO9IeHzx4cCLdqkaxWoa0E5GkhUKJqhQ75rJiBLjM0eXQfnvNZTGMBWyTcSJHKGfOfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkz+2B7bNmsFjFY6IssH7N05/HvZBfqBcPLmVFaS/Mo=;
 b=DyFf1onegFwCPmE++ATkoFyLCtPzGSrBFxpC097Ne1KBP0KPm8fAAQnyFkEt4gEtMYMne+1mViR5/XPdK6XRFTU0KKdeoKrZWyJjwtdk9b7NjfRwaseceUhMOH1Fl7CZisvTxQu5KOJqbXPvgh5NXF2DRHaqALK3X0U5TqBctI+wTDeffl67g0dhdkODv4lnYCMrN2jZPfmG2R1ELmPE4XMN1sIXd5o6W9ZY/or2JUnJWTNkahYZej6EN9zmRV+ITJWbQMxyYzdWj+w3l8R/ZcIoRPpD+oa/hqZzWfcCc5qBthPN1o/eI7HPJKNMPv1ginPa2S3fj+D6uYUzkuwOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkz+2B7bNmsFjFY6IssH7N05/HvZBfqBcPLmVFaS/Mo=;
 b=Fmp8ifGArTvpb8M16a3DkWV8eDI5w2K0Uq0+kMUCde1t5BIo4kC7PYgTnCazznnZeR5+fTXZxrXtrZyjYaKe3ktfff05WyvvLDjaJ8W/B7YmAOwYUJgG3lVLbJgbvsKPtfqQWuYyi1Tg49aCaQ6IeCgju92h0jiTu0/KyYpRjz0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA3PR10MB8441.namprd10.prod.outlook.com (2603:10b6:208:581::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.13; Wed, 29 Jul 2026 14:06:36 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 14:06:35 +0000
Message-ID: <b5779fc9-f4d9-4d59-8ce1-732d24c120bb@oracle.com>
Date: Wed, 29 Jul 2026 15:06:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/27] scsi-multipath: introduce scsi_device head
 structure
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-13-john.g.garry@oracle.com>
 <20260729134645.0ECAD1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729134645.0ECAD1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0628.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA3PR10MB8441:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8181f0-9604-46ee-2279-08deed7a9983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|4143699003|5023799004|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	onvdWYchevVLszvznlyJZumvcCcmC/IS60F3VyQ3kFNTBsTsFWel8XR/LcVyeFlHar0Fd/kte5kIdFKuDABZPT5ltLcaY/m04Nm074AeFXA7VwPGc85gISH1JQFQmN0qx+rQl0sC5MsweuKZAw2E7JZhj5PyNaqpKhUUgl5N6Rr0waLgprjb9w9uGFRCwRWoBnldE9EA4sEpxy39OWKUjZRvbgD2oqaCbT7BBG1WZ9ueuQBVH7sUhTy6KffieyqZ6BF+oZ1LePpCm5dbEde+3I7QncOaviqIrZTmPovlYpZzfNfTVS/CP52SJCCRNCk+3EmF6ZKUIehNzAHAagLgYY1IHbpZl7kZNcBPaRqMjtCkcYzdKbbTWVMAAkoix/a5HNR/+8GU7nrDDl2jT83NHnnpUMoXzYv6liD4sVpEWkIoN79sNcRIy0wn1NQe+A1EKlWZpn0beLSjLtQqMBnnN58rW/haTX+mWIdBiOgfiID3JkMstV0Gle8pEk70BkieWugNpnDAdifhhHLcAOA5+oAnW/+JcdQVuYtrN/aFN7b036/QJ410NRjgX/CZyUvyL7RmzU+BZTSYlrWXU9rLIp+IujyTX5wESHjD+YhJcjX3gV8RsYFYdfdC27HLBpo7Shsdq1GZJkXmaAIuQt43ZTWE37Z+eBX2Z1Sbel22GbI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(4143699003)(5023799004)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmVZVlZJTXBnWG5VMnp5cXduQjZ0c1pWQ2dwRCtXUmRmeERVcWFTTndlWW4r?=
 =?utf-8?B?ZmYrc2JVeGI3KzNnWnFTdXM2VnpYc09OMElzdG55UmtWOUVrMndWMGZ2YVlU?=
 =?utf-8?B?bXhJb3hScXNHTVR4QUQ1NmlKRUhJSDFkK0hncGpqZkR3VmdNNG5VNDJUYzRv?=
 =?utf-8?B?WHBTMWVpaUVCWWg1UXdKenFsT1hhNHMxRDFmOTlKVkFOMlp0TmRvOEhQb1Y5?=
 =?utf-8?B?K1hsVVF5cVJwOGpKZStMQUpxMEN3YmFTR0xVN1RvRnJNaHFVUkNadlpyQ2Ns?=
 =?utf-8?B?VGZvamVjeGdMZUpubUtQTytyQU4xN0NYenBOdVNEcW1Udi85azFHZXk4MmVa?=
 =?utf-8?B?dU9XK2VGQXF1dVpPOEJOZHZ2Tis4bUJmNGlHVmgzcGQwMllMWHlZQzdnMHgw?=
 =?utf-8?B?TGQrL25NN2FKaFJHOEw2RGRWanZZVUVrQnYzNFBJRTVGTFA2NHdUK1RhVFhV?=
 =?utf-8?B?akNMdlZsWXV1b05DcHR4VVNRZVArYzBFRHNWY3JUMlJYYzV4NEtkdC9pdG0r?=
 =?utf-8?B?SWxhRDhKN1BKTzQyc3JkWlNkcFgyYUhKaXN4N3MrSk5aVjJJa2hjY0ROOEtO?=
 =?utf-8?B?am9sZ21vSVBybDY1UFZ5UVgyQU1zU1VmMmhYYnVsSk56dlJ3QXhYUWFjb1ls?=
 =?utf-8?B?RnZXTWtOdStQUE1jOUM1V0dzZnEyZmdIekI3S1R4YTBVdmt2dHg4UHBWcmc4?=
 =?utf-8?B?WmVEc1l2alBGSC80ZjY5S09JTkVYZ3FTVituYWZQbVhrdFhMQzlMRk1DM1Mv?=
 =?utf-8?B?SjRVMk5lL1h3dU9lbVcwMTJUNGRrMkdaaVpzMlRRd3dmSFk0eG9XR2drOFdZ?=
 =?utf-8?B?T0plQ1AvRWd3S3FGSVhjaGJhQU9NNERac2V3NEZqWm1Fbm54VWVXbW9RR0dK?=
 =?utf-8?B?S2ZDY0x3TmExeDJKWWY0bFpIUTBNT2tjWjM2ZDJiamVRUWlMMEx2d084azkr?=
 =?utf-8?B?RlMveE5BSE13RVM2RmMrZU9PeE1wa0JpaXZ4TEpXRkh0UkpHbDRubENCVEds?=
 =?utf-8?B?RnduaUM1RE1aR1o0cCtYVDUvb1J6cUY2Q1BwSm85UGhIVXBqNWJ4UXhUTVdX?=
 =?utf-8?B?V3ErS3VUV0EwbXNHREMzQkI4NGVwZ2RMeHhsYnRVTE5nSm93N0FSWXRJcTdN?=
 =?utf-8?B?aUtKcko3UHFUaWJRK1VpZW9MT1VVc2NwSzhvZDZ0MEFUSkluV3dCK1Job3ox?=
 =?utf-8?B?M0t6UUFYc0ViWUxkcnpDSGpNZHdqbGNqOFFFM1EyRGpyTzF0UmpURUlBQnM5?=
 =?utf-8?B?dDNDekRTc0wvaFRseGwzcU5pSG04bE1kd2piZktzRXRIY0g0RU9oeVdzTXNp?=
 =?utf-8?B?Q09VVFVmSm83ZjVNQUZwQWxIUUwzVFlaR3pObGh0eldkdmoyUEV3UHNNZytz?=
 =?utf-8?B?LzQ4dzhmeHVMelZUMzVQT3R4YjZ4WnNnQ2p2T3hwQkdpNnY5eVhTRDNNSHVl?=
 =?utf-8?B?QkFKaDFYY3RzOUsrSmVUWFk0SElURThuNGI4VDdxWC8xejRnbm5Lak1BREhI?=
 =?utf-8?B?NkxvOFVXTG15TmVObDYwd1ZMQXZOeFBkMXNuamIxZVBhQ2Ewc3pjY3Q2QzBK?=
 =?utf-8?B?UzFJMGU5c2tXaDlOVUJxMXlVcDBBVG1QdTl1dWQ5bVBkNCtacWdrcFVLamlm?=
 =?utf-8?B?YUhqVmlVRFZRUXVqbWVhM2ZIOUY5UXFGbThhcGhQM0ErSlBtbHI0TXdHZkxE?=
 =?utf-8?B?SWYzaGFEZzBXZm13dmtjQWlhZWRjaEVKNWFkcWxlQk9pdGd3djkrS0JNbjBE?=
 =?utf-8?B?akd0RkJpbHd6ZXlzbjhjelBLWTZQcjc2VmVnOHNSMjJrb1FJakJvRTlKRjdi?=
 =?utf-8?B?UkNBS3p1MU9WblkwZjRRdnhuWGRPcUdsYnlxd1JQMFJVUEwyaGNHMS9kcGpC?=
 =?utf-8?B?bW1HSENwZ25ZSDJZRTJiNHNVcDVITE9kZm4yVnMxek4vQVZyaWJzbXpySDlT?=
 =?utf-8?B?ZWZmUWxKQXhsTDREbTU2Wk9aNENPR3VlWXhvUTJ3emljZHdQMDdDQVFOQTFo?=
 =?utf-8?B?akNFZUNkdEY4ZzdzdTBPWnNVL0JuZXY3UEwrVWhJTk1XSUFwdWM2MU5sSmFG?=
 =?utf-8?B?OG5tMG8rNnlSQ0J2bkcxbW9tSGROZ09qN1hTaC9lZzk3WFBabG1KMkNUSWkx?=
 =?utf-8?B?UThTdjYvSnhWVVdzaTVvTnNyTEN5dEZVMlQ0UWdZOGl5Y1NnN2M4ZGVha2RE?=
 =?utf-8?B?Kyt0c2g0VnE3WHlIUHUrU3JianlNUmt3N0VRUU5KTFljRUhsdklBc3ZlZWJ1?=
 =?utf-8?B?NkhMQkVFVVI1WnJSazBZb3pUWCsxL0FMQXAraUl4TUxIV3Y2QmFHVVJVUlBV?=
 =?utf-8?B?YUo2RWxaSTNXdDEra0VxZkNoVlQwUW1UdjkyZW9pNENpZXBqWnlxaEhlcnVC?=
 =?utf-8?Q?V8uAkjNCzph9icac=3D?=
X-Exchange-RoutingPolicyChecked:
	dqxwf8nxzJSIFMn8qZQ2vD6COxSkyNPbgDaf8e4rw0HT9BcFIVo7kJYqsJ6j7YagjGM+knHLJCNLGEnEJIcXJdMiYtNOitBvfaCgLJoc6L2Dx9CpnU48sW40NMghf870mkeryJuEMw6xZOGtmenAPiYDuCTN96VxERRxI7gNvH3bhGmk86GfI4Mq/kzfPf1c2OOayasMzjZ5grY9jfmvsfF2wwc/HqtZaf1qtQQ9+ciG8ulVq4y1bQ5jTEQWWtTXwjLT5jqDQfT//6XPV21zGZ/+LeU+LDDGcLumyi5QockOM+pllsHYImDAL4bsGLfB0WoVImhi+sMBCg+YsxtjZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9fqcjqlqyRk/xigQ4ZH89mQaijZT/ToWjcOI4w+NP25yRpEoojXp1OppWZiofQaOviKXkxiYyhDqEuTE1Smn7EardLHjwyKBTcgpQYWHAnBfuIdiSJkouuDC5FCcpKdgbfhUm9Qp+rw0R+EMMZfOUSoEUdvj55RPuOpV+AlvU/8kXtnbR9yrApZDtHlu4c7wdN4ymFuNKy0ATp2ZP2CdUwn2vaR1+e7fqsVrS981ei4MxtlvyQpJCkrnLKaM5CY4mVrxI6J/sZkC4OHMO4bxlOuaM/9ry6iSGkauI/ybM3op3TWm/fFk//K7NBzW4jPd+DMUWOVezh4B7bshBae/HOpkDv7T5Nvse2eBo5e+kgdJOd0ejzMXa2jcRfeSVvotCnXHzCp7COfEvSbt87h6ODlYRgHsjXdP/eXNnjxJT1kPQPiR59uaErt8ZUxXJ31pakCaLClc23UByRBWod3XaRTI8HSPmlGx3cMshq47XZXBR2zu1UbX+Tgi/I3MIxqyJxgm7bw5YV/25KZ21V8FwneQDdhNvyDZ8WZh2pSX0wT4Z4hvRKr7D4JBGtOFqEel8oChGzaHSajSUXMa7ZPGtDOF8G0B1CyNf3QPcUnmle8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8181f0-9604-46ee-2279-08deed7a9983
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 14:06:35.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KnR3/mabxS2KQmpRyJIgWT2yYThRnS2Ilc5WymoEobfRVr5Wd/ROuOsL0uEnK3bQp0MoJKh/uTi4qG42NV1+DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8441
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_05,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290115
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDExNSBTYWx0ZWRfX10gudNhE6ukr
 Sayv4JKvCHrjIGm4al0055sgdHIzbc+KiwLENZu0odCnrXA+DylzGmGzKWY0nZXntWe8iso2EGV
 c10LmUMYLdZY373dvn3MWlxNORib8gzt9hj0nqQTP8tBVEq8PAzM
X-Proofpoint-GUID: x3tOmRkv8Fyv9Yq8p3Kne6AgD-zJCBcC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDExNSBTYWx0ZWRfXznSshOaZdboH
 O0ypVpBcsboa1o4j8xC/i/ALK+q9z/w4L8PTDT0+FZaKff8206wN5lBtrCQVnVbFma2F2iFVE1c
 1SJry52Wy6JP4vH7Qe/XM/97q3ogkIX8nHduUbfZfLo3vz3DKRy8OzFv2l2jBdsZ1lRQN12bm2y
 /x7pajoDIu/OafIGUgIKJfIKCPL81lpvYBTJx7JTBw/tekKi1HvV+pa+kLLh7F0GZ2HvXPhp94+
 QQFvMAhH6pIdhICAMzOwyANHmjiNS7ZG1gkFB5DlZa1J4m0EEOOJM+G1AeHEAFPDzmUu92uof3R
 dOeZjPWbwkRHQPSvfGzX2t5udETbbTqR9cPkSzcF9lEZ64G8agGdMY5ru6Msv42qzUxBiimYO4L
 UVBJm823+x6sUMQkY92sgQqFvoqsK8Koc0Kxklu+u91tusKZOlqbZgfvwGeKWpSXETKmyMhONtd
 pidR+IJBGN9f7JvNURrym2sC7qtRUpdM1U7SWAqI=
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6a08f2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=-Xpt8GhPhioOkdYb0YAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: x3tOmRkv8Fyv9Yq8p3Kne6AgD-zJCBcC

On 29/07/2026 14:46, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] The struct `mpath_head_template smpdt` is defined completely empty, lacking logically required callbacks, leading to NULL pointer dereferences.
> - [Medium] The patch omits the logic to create sysfs links to member `scsi_device`'s, contradicting the stated commit message.
> - [Low] The function `scsi_multipath_sysfs_group_visible` and the macro `DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)` generate unused static code, causing a `-Wunused-function` warning.
> --
> 
> --- Patch [12]: [PATCH v6 12/27] scsi-multipath: introduce scsi_device head structure ---
> commit 41b0248171de9edac7171ac10282e0c5b3f1056c
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: introduce scsi_device head structure
> 
> Introduce a scsi_mpath_head structure to manage multipathing for a
> scsi_device. A list of scsi_mpath_head structures is managed to lookup for
> matching multipathed scsi_device's.
> 
>> The sysfs device folder will have links to the scsi_device's so, it will
>> be possible to lookup the member scsi_device's.
> 
> [Severity: Medium]
> I notice the patch doesn't seem to contain the code to create these sysfs links
> to the member scsi_device structures. Is this implementation missing, or is it
> planned for a future patch?

future patch

> 
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 5559e2e8d64a8..30a2d01be8aaf 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> +static const struct attribute_group scsi_mpath_device_attrs_group = {
>> +	.attrs = scsi_mpath_device_attrs,
>> +};
>> +
>> +static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
>> +{
>> +	return true;
>> +}
>> +DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
> 
> [Severity: Low]
> Is this function and macro used anywhere in this patch?
> 
> It looks like DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE generates a static function
> that isn't assigned to any attribute_group.is_visible callback, which might
> cause a unused-function compiler warning.

yes, it is used later. For me, the compiler does not complain as 
DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE uses inline in the function declaration

> 
>> +
>> +static const struct attribute_group *scsi_mpath_device_groups[] = {
>> +	&scsi_mpath_device_attrs_group,
>> +	NULL
>> +};
> 
> [ ... ]
> 
>>   static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   {
>>   	struct Scsi_Host *shost = sdev->host;
>> @@ -91,6 +144,74 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +static struct mpath_head_template smpdt = {
>> +};
> 
> [Severity: High]
> Will this cause a null pointer dereference when the generic multipath core
> attempts to evaluate I/O paths?
> 
> Since smpdt is defined completely empty without any callback assignments,
> function pointers like mpath_head->mpdt->is_disabled will be null when
> dereferenced by the framework.

it is filled in later

> 
>> +
>> +static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head;
> 
> [ ... ]
> 

