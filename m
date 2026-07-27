Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251982771E;
	Mon, 27 Jul 2026 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169289; cv=fail; b=gbArx9vMwcwkgM5qjiicFb0Pj0SXue5RdjU4F5APwFG3V0et734T/6N/QikeDKlXk9Vj7vCI4uTGMVjlW6aqDzrtLNKJi/qasGaPYtCp7TjXjn2vsMOF6L6R0es+XCw78XLMqJf+z8HWq11jQmb39T1RyOkZZ6E+mpIAFjU/rO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169289; c=relaxed/simple;
	bh=HWkIGH5t+nhtyfHhxMZn2YKvZ/SeiPQ1G3ssCE+RNds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uD4p2X8syWCjWrmJu5nb/ivGrQhy3PtXEZXGa46ZBByHPDLFj5QksYTyPHghMa/9CXtXTmR3bctycfS/RmK5QBECVLA//NcDun4yWr5DNerh47/Z9anqAewbfOXnkwlvHjDbIUOvrBmNGNxvMOtEF3o50uW3fsgU8s+WuX/10Vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kUv3Gvhz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jFXSxtRU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kUv3Gvhz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jFXSxtRU"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGDvOr2504599;
	Mon, 27 Jul 2026 16:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vOVszNxjzH6sD4FNLg/xpvwLFlfW5O6rhC8Ru83nfv4=; b=
	kUv3GvhzlidIZYI6FA6+PHCHvD3LFcFm02/Dcbxz1Rn7B3BLFgiR5a/kKykD3IxO
	wwfHCdFnonXNpYyL4yYrqbdZxAQtxk2ML+Tlcb1Pie+YFh3Va/TDwtwi2trU5AQI
	hjy9kI0IGz9VWMlMvkmZudnLLi/zC2JjixKT6FtnrjUqmc/1/booCXfvkvupp/ZJ
	oSufikx/VZxhyNIyd4+UpgCTH9XlSmWwNyTMRQcVrUSe8t4RKf/2WWxW9nuGqOqs
	UsE36m0yvudhxXrOQHldKcqhoa0UZ+g+QLsw1N3vTDJgosnDejSLNo2euZH5QQuQ
	HqCv3Fyjh/h+3aplZ02u3w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nj4g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:21:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGKfRm012453;
	Mon, 27 Jul 2026 16:21:26 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011043.outbound.protection.outlook.com [40.93.194.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6bn19k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:21:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABY8J1e5mebYH4JJx76CQY6go86IIdCwFurj2Al8O/Mzgkou/U2nnFsKyCeyMzUJ0PsXThyCE0TLvD3HOuWxSZs2Tnm8wsa9tuBr/xJq2C+Q3kR46X+A9s9LT+h5mHX3SAm8eCgzsmdhXZJbxRcdNhsnBaeBhE9JEeS6PyZcAMmsM7eeeYrDwDnp4SbTeOGjveB6sfFaJXIwWcXp8LjWVOtmUQLCCQINLcCC+jkM7mwwfzTF7rVdllaJT2NHdISg74AGqCX/afI5TEbYdEWSsylN8U0Xtm5Wm5BApMDIqLWPbWLRFW7g1b8+s+0vfFshxOlQ6Wyx0syXNV13NMwLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOVszNxjzH6sD4FNLg/xpvwLFlfW5O6rhC8Ru83nfv4=;
 b=cxcgyX/lfai7w7UowAzrCt6QIGF18SQ7RqyPNr5PcdTC/SgugCWYrTZwDV5sjf0RoTbTi38ZnqOJBw8GRpRKupbxeozbGTU+tRczVbAYebP/FplGl5UxRCuzxgUpIysDEJ++/DNvl/BF3jeoGGh9z5ItjzscFZvG3Gqco9NX5vW2yl645Eh0KXZVR4tyZX1OFu1zTAeVPKjhgOWa1M3QX92KDXswPoe52ftZuHkJ1Tgwj2X2pRYxLjP58yZQSHIohVjZYgK5WbvEavxvi8TAu0v0x5nLzGT2rFKNAw5c1FuCzmBjRDlmHSXPY9hqTCkWYMWfuWqHCoM9aoYNEELStA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOVszNxjzH6sD4FNLg/xpvwLFlfW5O6rhC8Ru83nfv4=;
 b=jFXSxtRUVhJcMHXvkGA7MqfPMzO4D2ko+YLcDRipxma+zWcjVMIJceMQlfVBkbpK6zgmpmYPS8S7nsJ30i2hn+QtS5h6JjvEu2sU+kanF+JLOKOqM/gOirlkMpPV1Ouy/hCTj0yFRvGfn6JJjE82r/cY5egbvcET4hKMxXEKYss=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN6PR10MB7422.namprd10.prod.outlook.com (2603:10b6:208:46d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 16:21:18 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:21:18 +0000
Message-ID: <966806ee-a9b2-4e68-a0c0-83c5d6fc6a04@oracle.com>
Date: Mon, 27 Jul 2026 17:21:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/27] scsi-multipath: provide sysfs link from to
 scsi_device
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-14-john.g.garry@oracle.com>
 <20260727150727.9FF041F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727150727.9FF041F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN6PR10MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: 13fd3271-256e-45de-6897-08deebfb1654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|4143699003|5023799004|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5fUv1yWGHKkhKtvrSAGDx+zbX1AY5y4FIYS3kqNPdyJpZImpxRvDiUn2n/fFraNEurHMEsZiLZgbmFpecZllJJWRyveOb4kNIph4Ge5kw1sdGRkL81MJ1NmbcX1lH/sZaDnHrMc8mkdu0G0r9vUG3A2lAusOJT/y88SMXTDScTNFyc78SCuOLwVx6TI/xc7QzafRsJ3n5B+1gUMz4yzFpUCzVdKMk7CpT9mOdAIJDywSUJxfB7gSjIQKm+558YDFWe4IWlw+vQZNma81XzAceaYhbTlm9xM8Z0MsfuD4GivDKNl8JZqhWZ+AcKYIb/u4k0PG3UpvUwEzJo2T+U8vGcURJcWtwHqfggbGCoE5K3AMfvAfi9trUbnD34jpklkzql+qHPmjyNXqxa94BWmoXQChIFVlRPvtdtvDizPNorcKRdGF1xSJeYQWWVxigG1h4SYoTDtrwxpIDHBWeIlPeZQUpsI6FP6iw2uDEoaxADZlnRadHZp2ZEpy+SwauiXdF8IjVWsIUK3DhuICiOagh6UlaZmjkrgvKwOyyUIfunGeO9R0RWaxsDQ8TXBghk9FIcnD2l8pnlb6Z+TS9RmVk2QaBzaud1B1IAOJaoEyq+iGe5qbB86+bY0V7P3oPTxwXzP1GAHg2U8N3ysxmTF8lIe71bSbdubjUtnay/5tTh8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(4143699003)(5023799004)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UktZVEpkM1p0WHErd3gyL2hYWGNlSFYwNWlraTZENG1IbU81YWtSU084N0ta?=
 =?utf-8?B?d2o3cjM5Kzd6MTA2bWh2REhBSkVuUjgyVmJzWW9HN2NxQm1KNlA3QlJrUW4x?=
 =?utf-8?B?cWpRWHovRnczSVgwZ0ZEK2pSZGlLWEVwWE84Y21BVHp1clhOQkR5Q3N1QUEz?=
 =?utf-8?B?NG1qRXJYNHJwTWxtVHlJMkVOSGRvZnE5NVV3bFcrMm8zVUZVOVlYZjhxOThZ?=
 =?utf-8?B?MTkvRCs3dzNJd2t2eFJ6YitjUyt4NWpxa3BRWUdzQmo2SHNMdkRadHo2K3Y3?=
 =?utf-8?B?MndDTmJSNDhha2IwRjNONDZFYjIxc2lGM01Zbm1wUTZYM3NvbHhSYk0vcG56?=
 =?utf-8?B?dTRMbXZyQmhicWRQdjVBaWNDQlgxZGVXVG1odUQybHVjNTExUTZSZm8yaGtQ?=
 =?utf-8?B?NXhObXFmR2QxcS9IOWpsbHVuWHFhOVB5VWpWVVpZbmNvWXNwWU0zZGdtMG1S?=
 =?utf-8?B?b3JQc3ZnVVZPS0dTUFVaRWphNzBJc2hSbmdoUG5xL3RabEtKU3Nta0h1ZjZx?=
 =?utf-8?B?YlhxbEhnenhJVjZFSC9zd3F6TnhlSnJMTWp3WksxWlA4UjA1QmozaDU3WUlS?=
 =?utf-8?B?TG9naFE5empWaXJtT2tBbEM4UFBwVXo3Sms5Mll4MlRCU0F1NXk2YmlUb081?=
 =?utf-8?B?MjBUbi8xdTZTc0NrUVRYM2FvSlhuV3VyVURlVWpsTnkyaEREQ2RCZmFMMjlh?=
 =?utf-8?B?c2hvTVg1b2NTT2FJQVc0V2JKSlE1Y2MzaVgzL0Zrby9saFRkMDU0UERLc0ta?=
 =?utf-8?B?RWloYzVtV3VEUkNxdWRBUThOeFZhQ3pTaEt5V1E5MytFTzRHUVVhMFNNNWFs?=
 =?utf-8?B?aGk5czZHZWNVcHNISEVNUzJ1Mnc5eEREdG9qTmVDOGFJZGRzWFd5QUJVSjZJ?=
 =?utf-8?B?Nm1LR2FoNjZBeFBJaEQ3b3A4eTU1NVdWT2Q3dUFJSUJoaDZXdWdyZlR4OTda?=
 =?utf-8?B?T01TalRTL09ZTE9aWWFlbjBaaWUzMnFzR1JlQ09PeERJV0h2R3BrRlQ4Mkps?=
 =?utf-8?B?eEdFQzMyQkFNTUM4MHA0TjlEN0hURnI1T051a3BrbU84THpHN2RxSzhuK29V?=
 =?utf-8?B?bHZpU2FxUWk0Yy9MYlljQmpXcnF3cEd5S3A0Ym11NWFtOFp6ejJXL24zL0Vo?=
 =?utf-8?B?blN6a1UxWjBWMXNieDF2MVhjY1dNNXA3SGpmNUVmc2VNM2xYQ0lpWlkxOWdw?=
 =?utf-8?B?OWxidFdnaTZYemg5SUVBcW1YVHVuREFyNzRBZXBoSi9nUU5NMFlnN245dTVs?=
 =?utf-8?B?d2dJOEVXNFJ1dndLTVJSMkV6eG5SenY3ZUlZZFg3OHF1V0szWCtJeHZJRlJn?=
 =?utf-8?B?aHdHdnVSUFIzS0RVb3RGMHRsY3FHalRtblc3VjF3Qi9jU255T2lhdHh2UHFw?=
 =?utf-8?B?QXl2UFFSTWx3S0ZVL1VjYkZUcm1ZRmtLR1FoMmNCaFFhQ1hxUVV6dXBvWTlp?=
 =?utf-8?B?cTFFdUxSR3Y3N0oyeVZtNTEzU2o5UW9iVm5yd3FXYmdzZThUTXlVRVRzMEcr?=
 =?utf-8?B?bmtuMUdUTDBGNnRpY09jdEYxTTRYdEYrRkRVcmlCWkZKbzN0cXE4V2xRa0dh?=
 =?utf-8?B?Zk5TNUN6RjgrQkpUMDRYR0MrQ01rSUVSTFkrQWdlcWdDOC9PeEo4TERkL0kx?=
 =?utf-8?B?R29EcjgwRG4vTnU5UDR1dVNyR1dxQ0lTdlZQNlg3VmhrU0dlcnhZVGRDSTBL?=
 =?utf-8?B?M3ZYcU0rUlVoc0JGMitMN2RpUDFHSjh4TXN4ZVg4S3VUbURZUklkaEpIbXdh?=
 =?utf-8?B?M0VCOFFzLzBjcUcrdjNqbGNNQVRkWVZDdTI4RzZaNWdVbmZ1cXF5OGJiQ0J5?=
 =?utf-8?B?SHpQSllCd0RWbDQwZys0V1crUnFuMFA3eFNyblJMcEdTVzJwSDRVbDdoUGlm?=
 =?utf-8?B?emRpMUtRZWozdUVSQ2NRdkpIQ2FQSXBVRnJ5MEdiWXpGTFplVE1STE5wTkQ3?=
 =?utf-8?B?dFpLbzRRbGpLa0ZIcjhvYXNrVW9mRkdyUHdLa3pBZmp2UDhIcy95SDdLdDZR?=
 =?utf-8?B?SE9Fb1Q1NkxJYzF1YVplbElTcHIxVVM1UTdxNnIwblNSMUZpYW9KeTEzODFv?=
 =?utf-8?B?cGMxd2t6M09PTWtrZ2s0OXhoSStWUWVwaStLU3BvVE5tcVlZbkVqL0RWQW5R?=
 =?utf-8?B?VFF3eUlkblp2anpFMEJPd05seFZNUVpLaldDemlkWVVOZnRINE5SUWNlek9t?=
 =?utf-8?B?cmJWYzlIbTEvclA5SGN1VzRuOTJadTc0NFRxT2JtOGRTMFBMOUlrcGFSdkJq?=
 =?utf-8?B?ellRS0VGZGdXKzgwc1JNemNZZldBQm1pNWNEVGdyMXZ5a3MvZ0w4c1lBK2wr?=
 =?utf-8?B?ek5JcXVVVm9FWnNqVzNkSXptT0pPNHBTdVh6YXRPRzhVdWhiSnJJZHZFaFp0?=
 =?utf-8?Q?IHQCh0zzcuyG09pQ=3D?=
X-Exchange-RoutingPolicyChecked:
	Hty1TTvrorRkT34jtVOHRJjA0FyCIV5MsuVMrBmX/CXtYMwIAN0EINYyewg8sM6k7EQ85F/ocif5eL6Lxvz2kMJ6XOjgFfj7qpXA1Z0wySfNH7NW1tJq1/Q/mXyiF6q5KRk9hVa52GT22/Xe/8e8ZnRAUIzQpM1ODCUdlj8yKE0IdFtKYXsSjVP5dmevxmGagTUhdnI2MUzPHw1jcO78KjwCTcFOugSAaDo1ZCdYRKBTEAhELuWAOKLxLxA6HilH4XPODSYfcb9YtqqBH/ERXf1JKl1RFGGn5/d12YzlNIXazXJphCwHB0A3zL35P42ccl/dak5JQJJhBBkNrbMElw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xku4f/ohjmAKLKOLPt+g/4ziifG0tllfZZ//RtI8YfeH/na9NNv6yaqd50mszowR1nfihjuLoUdBfx8dXaGqaVve5UnISioUv5wU1ANKhfUYP8/pkEaHdPQsUMMd7KqyMkNoIKwVvahD6asMZz/t6ZUD+J6V1T6IQMbe0SJOqbxzmrGr+FNbc6qYqOkpnqaOzJk8dJiodTS7et8+fTwEnJF3M+YrMC2Ve1T5FjfLHgAhIlyWBlcLXbn1PVuMq5n8hRhwbsyiZ/8CQjZ4tzOysszVMtuNfY4YYQYQPjL/KmcmIp0PHTXgV35s7W2l1OCr+aLG5/VFnNdZoUMVXc7NQww8HHzZXBKXdhI50lyln+JvHP1XT+PWZTMp3lEVBlbmj7CdlKBQwApfMQsTRX0N0bI/q4VidbYyh9zrRfsGRxxbVNMTqScOpbwTeMu/wd45fwC1742B9astgHyjL2V13ep30kiJ27X/auHaXscgoq3I+4/Ur3ZgbBwQdhnEOl2un9XLqVuR1PhO/U7To/56DSlNw+O7dAshFLeHzMUrvcvkwnohjvNWF0hxFv61Mr/PTODQ7mQFZ3SdFc3wOoc12FSX9GthlAMEoUEJxcvib7I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fd3271-256e-45de-6897-08deebfb1654
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:21:17.9342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: esjlxi/RuEJF0xjvMV0BQlG0fvq8lVPQeYOeXC2VHVYDGqM1m88HMvRNWw71tsSdzqs9uqmUXZLDVHZfZuKrIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270152
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a678586 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=70Vr12rJA-j-fSMayjEA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: 3TfTBzY3XCokjexmOzB5NqpZ6I6SunGs
X-Proofpoint-GUID: 3TfTBzY3XCokjexmOzB5NqpZ6I6SunGs
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX5UG/jJaZKrnF
 90A+mE5/5O8Uz4HdqB0LaRfisfeihNXk6jMaiBnvh73gsaqPkqHcqPvSnPIdTH6c/TZaZM+2ODx
 hMFs4xSM6XFBsFR3jhx7tsDaSfyZlPj3WZ0vl5b4yNUEFui1CoJk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX7jhQcJ5i595o
 4bEswphd+FPfdu55fq59ltsHNafN015sjyPpn4bjncmviErraHE3kxZg4PiTVUcO4LQNv7NI2Ic
 vyUUCSoIVKCO1IoSsVj+m1Khn+rbRCvDMZnVFq7HvcUsN7XIglsFT6drjUmrHEM8jx+XJxlbzvI
 Yjsj/TgfNySrHZ8cjnmouEWKw8HsZebyZRnBXx9LYq3aVc2c6KwSP0jXF2SJWyELyB8XS3404wj
 xJ79zPe2poNDyvzLVDbqVeTJcJnJL237Nbzr3ZFGRoAFJvkLPmhGWGyl+VGRRz77cTkwmSqlzlP
 xm1Z6DV9o+bhIKvg/jwFV1V8QAk/oJItSKMH472Fku4zFSGPhAlLpyrgu278mfwJqBudJ4JliBQ
 +TUjVta+82nS1aSCKReAbI6EbrGrDb1cG42l/zkOf4juEnBEYC8rb2QEINZ/mGQCnH6GJ8Une4D
 VLKDjtUEqS9jIg0V+hMWt5M69bR/gdaDWFCYgNzY=

On 27/07/2026 16:07, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Missing cancellation of mpath_head->requeue_work causes Use-After-Free when tearing down the multipath head.

:(

> --
> 
> --- Patch [13]: [PATCH v5 13/27] scsi-multipath: provide sysfs link from to scsi_device ---
> commit 7fc63465ac8f13d95c759573374eebed7fbf19d2
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: provide sysfs link from to scsi_device
> 
> This commit provides a sysfs link from a scsi_mpath_device to member
> scsi_devices. It adds functions to create and remove these multipath
> sysfs links.
> 
> [ ... ]
> 
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 799569b74b535..ce51fcc002bbf 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
> 
> [ ... ]
> 
>> @@ -1495,6 +1498,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   
>>   		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
>>   			bsg_unregister_queue(sdev->bsg_dev);
>> +		if (sdev->scsi_mpath_dev)
>> +			scsi_mpath_remove_sysfs_link(sdev);
>>   		device_unregister(&sdev->sdev_dev);
> 
> [Severity: High]
> This is a pre-existing issue, but does the teardown of the multipath head
> during device removal miss cancelling mpath_head->requeue_work?
> 
> Writing to the iopolicy sysfs attribute invokes
> scsi_mpath_device_iopolicy_store(), which schedules the work:
> 
> drivers/scsi/scsi_multipath.c:scsi_mpath_device_iopolicy_store() {
>      ...
>      mpath_schedule_requeue_work(mpath_head);
>      ...
> }
> 
> If the SCSI device is removed concurrently (triggering
> scsi_mpath_remove_device() and dropping the final reference), the release
> function frees the containing structure without ensuring the work is cancelled:
> 
> drivers/scsi/scsi_multipath.c:scsi_mpath_head_release() {
>      ...
>      mpath_head_uninit(mpath_head);
>      kfree(scsi_mpath_head);
> }
> 
> Should mpath_head_uninit() in lib/multipath.c call cancel_work_sync()
> to prevent a use-after-free when the requeue work executes on the freed
> scsi_mpath_head memory?
> 
> [ ... ]
> 

