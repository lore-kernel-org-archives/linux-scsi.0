Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B4937E2E1;
	Mon, 13 Jul 2026 11:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783942027; cv=fail; b=SG9mvt3WrPbLc11rokHyqwJN2TwSzFB7kGwyw8CqzOXV/u4aWBd89YOF7EVD1skLkA/8LVx8gxvhrE/0I1NZfcKugyVJUcgQBp3ZExR8irFVytpPubJ5s55FWt6fhxYMTQS4QJSyF00CovcW9QFVYraQ56DHSu5eUOVgrQHASMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783942027; c=relaxed/simple;
	bh=r4FvQRN2yWkz03n0TRfs9FCDM3wHobTthns+o8yj/Tk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W6NNGDxk/Hc/i301J8BBbdO59WAvKBZJ0WT20TYFwMdZbyPPpRJW78A5zgzYw62cfWG5z/C4MQuG0nHYqKSpfPrMHL0gt+oxnBA8KrmqHLpVR57M3AEgySI4QoSK5iD7Ek/BxRrG6DCwgIGcVwE1WNn2t6Pc1m1n1ZAcJPzvUIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VbJSoxgE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zfHNw8Bx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VbJSoxgE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zfHNw8Bx"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DBNAdL1306501;
	Mon, 13 Jul 2026 11:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RBhRYq7xiACaVU78MY+oec5RYCFKi2bxRTb+upcvbCM=; b=
	VbJSoxgErjFDsh2o2Um3FdcekLlf9dXnLGiuFRFZXCzcFq6kWnqoa7r1S6K52YLJ
	a8VmgPisyjxe3XGe0XVI5rpy3f1PNWbuiKZFWxq0UIjvWf2s6zGj+IzLWC1mSVb/
	K43TMsTWxtL/xM1PDVX64FUn4NkB+2irH/8y3wk25Y6Wt1RvMcBpYXJRoDVdjJ/5
	WBAslP0NtprnGrbYjLFoBhHRD9vh+o02ec3oB4lUwKuLXl3LgOmPpKN3KLo4x8Wa
	ZHtRFHeMwhKbD1Odxm3GLjLWOavazkmfwVt/olPM2dlV5sR0ypa7GFwh3hvUwEqo
	sIJK8W929m9Yz31BdENm3w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbepn1yyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 11:26:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66DBN6GU010270;
	Mon, 13 Jul 2026 11:26:53 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011016.outbound.protection.outlook.com [52.101.62.16])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9ch4sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 13 Jul 2026 11:26:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8liVX+z83eoC8U/PZqySuE0SwLLZ1xsoQY3T2JceaFsft1UbwxRQUDxxW/iokhynHRVaTKSKo9e4zYP6x9jMpPJfrRRQTT2SrhtGaPlBy3DHXZVzvXI6hQZfOj8SuaxgRlElDMhR8/ETXr5f66lpyyJ1Q8oRVNJwB4tD72bdxMCqxuj0vrl6yQcVaSeKt8Ogz2y6E294TaHRd36MZ/wt+cMYIF8RP4Z/hslo8v44cGtzAPyDofV2KVqMiLi5s+nubQ3A1KlrNxyWmupmfVZ4GBDCSYwve+NLj4k4o4l/43rLBAiTwSov4xpx3+/r7x9TJBh3YJydo2Vu8HVa62+Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBhRYq7xiACaVU78MY+oec5RYCFKi2bxRTb+upcvbCM=;
 b=K9XHq3nbk7S18lP5CfWvrV7tk3YSjJ/tVWd/stDRPQ2OQZ/tXx7w88HhQSBFL5Hh8GT+8TbmJn89Wqj+HyoPMLGqT8rVqeWbJlg/u8M7zAMD9mSmXWOyr6ISmKQEJ4CFvo5repAfUhD4MmbyrqeevaSF+nRpIvQCW0O3ZuOky9AfQKjpKYWUGDAA5lozxs+YKmxZuSNxKOUbkxYjaZdehLpe9UaTxy/OiBthgWRyVL2wljdt97cU0XgLS/EZ0AKyNRawvsgpIV9yC3UsOKH5Riph7sApe178nmuUZ/iH9llrqp0Rz2di14T9HSqUDP7Bl2GkO2D9ht5cIJsVyFQPSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBhRYq7xiACaVU78MY+oec5RYCFKi2bxRTb+upcvbCM=;
 b=zfHNw8BxT457624FkxB/h6OX9ui+5ECVvS9oKrYgDXcam1BwXt0jx3+gCRwFONBMTWEzsg9KlHvEs8XxIkySGuMcYGmM9FjHu0bv6tTwp7LkNIsHJ9mCW7ZbJAg/0bTwMn3WyZ97UDUudu6A18pwL5n4JvMUqluv/ohNW5NwHEE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7720.namprd10.prod.outlook.com (2603:10b6:510:2fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Mon, 13 Jul
 2026 11:26:50 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Mon, 13 Jul 2026
 11:26:50 +0000
Message-ID: <56d1c5d9-cb3f-4bef-a099-304ef0c49837@oracle.com>
Date: Mon, 13 Jul 2026 12:26:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260702033211.1743313-1-yangxingui@huawei.com>
 <379091c9-3cd2-7599-baae-8c7f278e7ec3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <379091c9-3cd2-7599-baae-8c7f278e7ec3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0318.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::18) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: d3ee6a46-39e5-4efa-a196-08dee0d1a107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Cr41hD3VQjxg9h3gdtzTdhBMMFJWjygmNxueipQf42YV6SdWDOGWNG7rGnTzyDfkUpQfzxlnHV/xPIXnHRMkagYpbO1eTqdwKR90pjbfEFmhnhEBs0UUJh2MQ2cKjCVY/Lw83ljYeB9uid0LgBt6UMTlz6Qr1zyE9IcPOEWq2M4gXSrnd5c9myCC00JWmqUsNV7k/2940O7Ag3tPOjNuwYLb/Vni7pVxcMs24lPSGzIBxDH5xFbKfDTkn+KkhNCXdnxBwh3Zfh2Ma5Y+f/2+Bon8QgLtV8S/SfM6wRqm+7QkgdDemedFHqBvOKZMLYRdUv8RlMIOjK6G6hx1Jtwzq2f3vDNlzG+uZnIa7fF+R7d3ZXatoXUqq6/EwZkgMDmZMN/HP8ObOGHY0bw/nSSZDQsro5yFovUpdAWwBV/W06MEORo6CmIsKnvmWI3LgFnKK6WYKY2dzGIVer5ceBMwUX/1TmaOgJnwpR//f2dsO7Ngc4iPzhIol1LBSaKTpffpMQwYT1N3P745qcG2orihHuLu/TWucJ7s4tnv3SHaBc3qsgfAAJbN+JGlrx/ef0D1HkD3nKV+/hZnsAvGATqMggJWZKESAgsyupuvQ60Ve9x3z/t/aTQbgL9PvrxoaDaiT0ML9UdT5jn7zh1qmpuMdMDydrN8Dv/bapO2UmDeKPA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3J2STUwMisxbzJmYzRMN0QxQSs4RFRkUXR5MW5kK3FJeGV3dmwxdHNlV0NJ?=
 =?utf-8?B?eEF0YU5XUjRrcll4eXQ2S21IYmJTd1lHS01Cb2xWMDVCSkJRM1I4RHdDVktO?=
 =?utf-8?B?RFE2VTYzcEo3TEwvakVNeUlQdmdFSmRGcDYramtaZmhpWlpVRDNtYlB4WkJN?=
 =?utf-8?B?NjhDbi9wUGtJQnJpSkl2Qm9BVGJYeXZ4U1Q4RVJTb3NLeEU3TWlrU2dhWkZi?=
 =?utf-8?B?MDNwYk1KbXh0L2xqb2NBUURjcXczTmtpQ2hMVlB4Y2tnS0xia0h0UVRqZWxm?=
 =?utf-8?B?NXAzNjE2VE4wTG5SeC84RnZNdnpIRlc3QXEyam9BczBWTmRDWHVYWjR5VXdD?=
 =?utf-8?B?eW05cFhHVlFoSEh2Y3Y0UXU3RFVWbEs5UE5GV0RLVkJpNUhsV0dqRm16a3pD?=
 =?utf-8?B?NEVRekJITnhGZ0FDcElHeGg3Y2FHcmxaaFhTdmovNUxXeVo3V09QRHRabGN1?=
 =?utf-8?B?S3VKWGFNMnVpNEkvak8wOUVMTCtoL0lybmQ2NjJYZUx2d2FVeDRSQnFURi9Z?=
 =?utf-8?B?elF2dVlabzNZQk51MWF3bkpxVHFpMk1JeTBhRG5TaGRXa0NzYUFiYWdENHg4?=
 =?utf-8?B?WDRiYmFNTkhablNDdFVtYVBLakt6Y2p1T3RMeWVObCtxUEl6aXJYei9PRkI3?=
 =?utf-8?B?WHo4Nno4RDJIZnVNczFMVFJZNHBpd21vU1RyUDJ0RWJQR1djRUpXTXJCQlRZ?=
 =?utf-8?B?em1adEtJdDc5b2tYVGtFVTlzajAwMWJDMDB3MU95dDRYbVk4ZnZJYVlKaFAz?=
 =?utf-8?B?OFJKaXh2eDhzV3VOQTFrYjF4OHJ4dGZsQkE5SEcrTk5INk1NSGgvdUFuM0lQ?=
 =?utf-8?B?QTV2b2drVGVEUVlFZWNJdHoyUzZmMmI3czNlU0Z6Z3ZIbnVadTRjeTFwOGJP?=
 =?utf-8?B?QlFzVDhoTmM0NnBoUkF2RHY5aEI4ZzdrbDdvZThnYXVRSFdNSDF0L1luU3I1?=
 =?utf-8?B?aGd5dFV1anpZVTJQQUd2Mmd4SlUxQndKZnQwWTNIUWhwRy82UzZZMitQYk1r?=
 =?utf-8?B?QTZZT0l3L2Uwc3IzNlM4VG02NFVtaG9EeVZkSTQ4TE1GTFlvU0RKZ2dEVnFi?=
 =?utf-8?B?U2xtdE5QeGNybENkTXJNTGU0ekdaeEU5UUVqalVVQzBGcm1ST3hPK2p3YVZx?=
 =?utf-8?B?bi9uNEJQUnl5TWk2dEl1bG14NEMraC9aTERMb2JLL09lV2k2WUUxNGxGRElF?=
 =?utf-8?B?dTRrdnVXaDVDQUk5S1lkUyszOEFQQ0t1Y1UrMzlBVitCK3RPaDJFd0VIMG9X?=
 =?utf-8?B?eDRGQWNVeVRUY1pCYm9LOXZwM3lFQzBmWjNEMEJnYlZ1OWx2KzZCZlgyUjBQ?=
 =?utf-8?B?STgzYnZKaHdRM21KdG9TamhveW9QWmsxQUg0U0lmSXFKcVFQQk1XTGpTRmxT?=
 =?utf-8?B?T0JpcnVXWW9KblZvN1ZsbEZkdmRnbHFWSFlJVTJJcDd1QkpXWVNOUWplcHVL?=
 =?utf-8?B?SzVkOWtWNnYwNkM1aGQ4aXlid1gweVFwbVZBZE5kV0JZeDBITVhXWU1DYmxV?=
 =?utf-8?B?ZTZ4Tk1IMWZnZXFWTmNwL0hhcHRtWUxuR21KZzNFUGV5ZGZHMUZ3SlQrQnd0?=
 =?utf-8?B?V1lvNFdGaUZjbTNJTElWcHZqK3JUd1czL3RDVDMxZ09vcHRldEFxbFdZb09I?=
 =?utf-8?B?NFBnUjJEcWtsbk8xM2lQQTZCcWZUTzRLd0dyWU1DVExORVc4RnQ3cndRN2Mr?=
 =?utf-8?B?MWo4K0JIUlpmR29tTzNNczRDNzZ1Mld1WlV3eWE5NXJQNjZ5MU4rOWN5Q3hu?=
 =?utf-8?B?TUtDNkRnTVdQUkdlQ0w5eldVa0NNcHZFbytybXBHRjhDZ2hubmY0YkU4dDRh?=
 =?utf-8?B?eFlub2U2OWhyaTI1ZWhJemx0OWpCdHNUZWZHYnN3UjlldExhcnlmTURPU2xJ?=
 =?utf-8?B?VzVRcjFYZXU3R3BnUDFKUDlBVnlNWHFxQlE2NG1SNzZxZ1o2a2wwYjZRQUFE?=
 =?utf-8?B?OHJEU1F2aFYrdDFZTG9jbkhZdkh6eC85SVk2dGhDRkRlcncrd3BiVnp1L1J5?=
 =?utf-8?B?UWpVQ1NUZXZmZHhlQ1BUOHRNOVVIcHI4RURRU3QwZ1ZLOGVicnVpU3NHdXAy?=
 =?utf-8?B?aFQxMlhuRnY1MER0akc0cDdWT1BmZTA5Rk5PZEVQcmdNQ2N6Y05FV2RzY3E4?=
 =?utf-8?B?b1p1RnJTTGx4cUZNMkhXNzc0SG1BYzJCbEtZVWx1SXNnMjdhRUtVNVVURHJH?=
 =?utf-8?B?SDZzM25rOGRpVUZpazNOWERsUFAycHdabkVBd1B2TjFZZWJ3KzE0THFLLzRE?=
 =?utf-8?B?UTRFNnkwcU1SdW1zODc4TEpEYXNjMzJYdnh1WFcwa3kwajJJeUp3VnVmcEor?=
 =?utf-8?B?QmRPQnN1UmpmdUswMjBENGZqNFh6VXQxNVFsVno1VzJPc3VlelR0N0taTkFo?=
 =?utf-8?Q?7FheOun4/15IrVkc=3D?=
X-Exchange-RoutingPolicyChecked:
	X4+EKzL4waR6jBZbkrIFobeIh1HJ1rWb4u9p8buWcfLcKm9seqEZsNBHEnR/ShVVwzc6jhP3heNDWNv/22hQxMSLVxcHYih1hvBBpUZBiKQStCR3finyi3aaHmWJr4ELZtdtnhsdToUVM3pmwJAdUFtC1sSMj5jTAbjBWqXfg7yhICAXNfh5SaynraiLWRa040he8uC3BFiKv7FwnEqtm1aN4eLbzbI4/6NTT/soT89y/PvmtarV+MIZgbivU4tPYKTBAeTtTczrV/24YsqDTEZ9pzuelIJOMp6c+qLo9aByO9mBiB2adoO1UgK6FIM8b1SaGp2tUCBpzX28f2H8Cw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lzfXcevIrPaxJpfE2q9IkU+QUAfsjHIOoyeODKMM8YU9hlQEVmhg0aioPzxKf4bD33JfAHm02dO+NlFjuE/dlB0QfHQRQCijWS6DgQH7259WrxTCl7lIY63924aOkZIGy9uaopqVGlmE//eITvBgl/iBU7MkF9SxVCUpWAlZG2coZyQyY8of69+iyRKTztKV7Z7i3RBEZopTpxtAGUcGATWh3s/acxA1Xww44/t6HWduEb6H6BbYYtaKI0Q0SVEQsTwLwAqqN/hPjKrSNMae4Btcb2WbDyti7KpkzhPU5xY7nCP48v9MvW32f+3flgO8+keKooDY6+DEJQiQC7prTHL9MDXIXKToUIDocnavbvStbf6+GaQyU7W9cewZTthgvh8u0F6XtsPObD0/yBWvCAZjPFlf6C/J6SvnXebK4Lgee0U9FInw2sLyUZXslPtZbXRolfXiSAlHNQpZs6ScIlOw+5Y5ehA49AP3ERZV9sA42N/bM3phdiGouTnv78y4PmjUk9XBspRlCYMsikByMaObfheeg7y8RnewxstqmnNOFATUvMqc3hXxAirr0s6/acKExwn1Xsp1r6KakVotTrQE3HjY/glC21Af7pncUys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ee6a46-39e5-4efa-a196-08dee0d1a107
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 11:26:50.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9frVsqsGb/MZcMnYzXKTM5kDUnu27lfUpN8fCCPEdmkPqA4HH7385cZz9PCRzltr6WzClryMzaNyTilSUAT19Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7720
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130119
X-Proofpoint-GUID: Qsk5LM3e2D6ciUPmaRKvChtR3wSSEFUc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDExOCBTYWx0ZWRfX/uOKpFHcmvyL
 3ng2U7FJhW+66RHSBuIEyvf/C/iyoW8gi0gtQJNz+TSxFAr1dq7R0L0KJ1iEuGEiQB5FxHIIcT7
 A1//ggd6r5JzIm9lRtPfEFDvbXzuHtjlyfTKq9G+16D5HJ/iLhGl2hPyXt81OVJPcIDjwcxzUY0
 WFLTs0RldrTmh7O7awILjKKIlnHQVIH09iILlBQkYXdA2Hi3j0uyjcEr+uFi9jdiJrKiJ9W6bNJ
 kCTN83xN1+hxrTUrzuqPq9rqepu5wnJvPs+cfuRwJGfHILcN9swtQchsSOPt5Li4Lmm9QCi8Rrg
 nIOWDKhHj06F/422ZJIIbwtHD6zhuJXHN0GAmiB7WKv4f1MTDVDzzK1PA+ub4n4XlZJA1MiiXO9
 qB6eja77R7a3/SCEVdhOIhxaqLWoel9nf/FjVGkArngysXBVWdgSVIcNbS4b/67ngEVZozYcEe8
 26+lBrZalpS1pp8uS+g==
X-Authority-Analysis: v=2.4 cv=bJom5v+Z c=1 sm=1 tr=0 ts=6a54cb7e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=i0EeH86SAAAA:8
 a=rvkPQbbOBUp34ZFAL-UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDExOCBTYWx0ZWRfX+sxpwwz8Lk4g
 xaaWDUsskhQw9uK/THxnNCM4C+c3bwHueU9XLCD2Y41bOEmbmFIXv6dWGKun8WeVhno8aG7EpyI
 MfL2/p8aMCmaZwwyOIHD1HuI1wRvxsYseX5c7zfaghiDcfdYhL3c
X-Proofpoint-ORIG-GUID: Qsk5LM3e2D6ciUPmaRKvChtR3wSSEFUc

On 13/07/2026 04:10, yangxingui wrote:
> Kindly ping for review...
> 
> On 2026/7/2 11:32, Xingui Yang wrote:
>> Commit fbefe22811c3140 ("scsi: libsas: Don't always drain event workqueue
>> for HA resume") introduced sas_resume_ha_no_sync() to avoid a 
>> deadlock: the
>> PHYE_RESUME_TIMEOUT handler, running on the HA event workqueue, calls
>> sas_deform_port() -> sas_destruct_devices(), which removes SCSI 
>> devices and
>> waits for the host to become runtime-active. But the host cannot resume
>> until sas_resume_ha() -> sas_drain_work() returns, and the drain is 
>> blocked
>> on that very handler.
>>
>> However skipping the drain reintroduces a race: hisi_sas returns from
>> resume before all PHY UP work and libsas discovery work finish. The
>> controller may then autosuspend while disks are still waking up. The 
>> disks
>> issue IO to a suspended controller, the IO fails, and the disks get
>> disabled.
>>
>> Fix the deadlock at its source by moving the PHYE_RESUME_TIMEOUT
>> notification to after sas_drain_work(). By then the host resume is 
>> about to
>> complete, so device removal through device_link no longer blocks on the
>> resume and the cycle is broken.
>>
>> With the deadlock gone, restore sas_resume_ha() (the draining variant) in
>> hisi_sas and remove sas_resume_ha_no_sync().
>>
>> Fixes: fbefe22811c3140 ("scsi: libsas: Don't always drain event 
>> workqueue for HA resume")
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>

Any idea why this problem has only been discovered after 5 years (from 
fbefe22811c3140 being merged)?

Is there some new test case?

>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  9 +-------
>>   drivers/scsi/libsas/sas_init.c         | 32 ++++++++++++++------------
>>   include/scsi/libsas.h                  |  1 -
>>   3 files changed, 18 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/ 
>> hisi_sas/hisi_sas_v3_hw.c
>> index 0687bdefcd63..c8673ae4e472 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> @@ -5263,14 +5263,7 @@ static int _resume_v3_hw(struct device *device)
>>       }
>>       phys_init_v3_hw(hisi_hba);
>> -    /*
>> -     * If a directly-attached disk is removed during suspend, a deadlock
>> -     * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
>> -     * hisi_hba->device to be active, which can only happen when resume
>> -     * completes. So don't wait for the HA event workqueue to drain upon
>> -     * resume.
>> -     */
>> -    sas_resume_ha_no_sync(sha);
>> +    sas_resume_ha(sha);
>>       clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
>>       dev_warn(dev, "end of resuming controller\n");
>> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/ 
>> sas_init.c
>> index 0bec236f0fb5..624850f1483d 100644
>> --- a/drivers/scsi/libsas/sas_init.c
>> +++ b/drivers/scsi/libsas/sas_init.c
>> @@ -410,7 +410,7 @@ static void sas_resume_insert_broadcast_ha(struct 
>> sas_ha_struct *ha)
>>       }
>>   }
>> -static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>> +static void _sas_resume_ha(struct sas_ha_struct *ha)
>>   {
>>       const unsigned long tmo = msecs_to_jiffies(25000);
>>       int i;
>> @@ -426,6 +426,21 @@ static void _sas_resume_ha(struct sas_ha_struct 
>> *ha, bool drain)
>>           dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to 
>> resume\n",
>>                i, i > 1 ? "s" : "");
>>       wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
>> +
>> +    /* all phys are back up or timed out, turn on i/o so we can
>> +     * flush out disks that did not return
>> +     */
>> +    scsi_unblock_requests(ha->shost);
>> +    sas_drain_work(ha);
>> +
>> +    /* Send PHYE_RESUME_TIMEOUT after sas_drain_work(). The handler
>> +     * calls sas_deform_port() -> sas_destruct_devices(), which removes
>> +     * SCSI devices and, for LLDDs using device_link() PM sync, waits
>> +     * for the host to be runtime-active. Sending it before the drain
>> +     * would deadlock: the drain waits for the handler, the handler
>> +     * waits for host resume, and host resume waits for the drain to
>> +     * finish.
>> +     */
>>       for (i = 0; i < ha->num_phys; i++) {
>>           struct asd_sas_phy *phy = ha->sas_phy[i];
>> @@ -436,12 +451,6 @@ static void _sas_resume_ha(struct sas_ha_struct 
>> *ha, bool drain)
>>           }
>>       }
>> -    /* all phys are back up or timed out, turn on i/o so we can
>> -     * flush out disks that did not return
>> -     */
>> -    scsi_unblock_requests(ha->shost);
>> -    if (drain)
>> -        sas_drain_work(ha);
>>       clear_bit(SAS_HA_RESUMING, &ha->state);
>>       sas_queue_deferred_work(ha);
>> @@ -453,17 +462,10 @@ static void _sas_resume_ha(struct sas_ha_struct 
>> *ha, bool drain)
>>   void sas_resume_ha(struct sas_ha_struct *ha)
>>   {
>> -    _sas_resume_ha(ha, true);
>> +    _sas_resume_ha(ha);
>>   }
>>   EXPORT_SYMBOL(sas_resume_ha);
>> -/* A no-sync variant, which does not call sas_drain_ha(). */
>> -void sas_resume_ha_no_sync(struct sas_ha_struct *ha)
>> -{
>> -    _sas_resume_ha(ha, false);
>> -}
>> -EXPORT_SYMBOL(sas_resume_ha_no_sync);
>> -
>>   void sas_suspend_ha(struct sas_ha_struct *ha)
>>   {
>>       int i;
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index 163f23c92b41..36d4cb567837 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -680,7 +680,6 @@ extern int sas_register_ha(struct sas_ha_struct *);
>>   extern int sas_unregister_ha(struct sas_ha_struct *);
>>   extern void sas_prep_resume_ha(struct sas_ha_struct *sas_ha);
>>   extern void sas_resume_ha(struct sas_ha_struct *sas_ha);
>> -extern void sas_resume_ha_no_sync(struct sas_ha_struct *sas_ha);
>>   extern void sas_suspend_ha(struct sas_ha_struct *sas_ha);
>>   int sas_phy_reset(struct sas_phy *phy, int hard_reset);
>>
> 

