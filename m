Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F7024466C;
	Wed,  2 Jul 2025 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751450271; cv=fail; b=sLTkjL2oz1AT+QsbsKHxRk2qjRJZGMclcXnMViPywgXWI1IgTTXEs8RMpEqhVmzVuJGMm/b2xI/Ju0hYk5ToqWGVBV+lcL1ZP1a8bDXpH5GiELw/uEuWPuDKc8Ft7N9YPUtReRsmhiHsnQKCwpIu7teqccaTT3plqAn4GIJpwSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751450271; c=relaxed/simple;
	bh=mQXXsdKoaEvVYNyCh1dUag2IyDPropiFBYoy1K9P37o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XuRiNGtrUyzFy7y0aRDaMvRO7KfdSO+artxyqO6pfWy7w4dfHBxTpHO8+WN5NRpWUZonUr0vT+ljykMrufXJwCk+onqiz/xwskoUPjolFC1FeOyrwvolHRIdCRG8DuTl+EOHxV//0CdFxKK4pV8cz3UqkPfwq6tRYdoabNopcKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WSpiwvni; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YVQVSyJn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WSpiwvni";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YVQVSyJn"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MgOt023055;
	Wed, 2 Jul 2025 09:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5k+rTduc0hC6e406atFGBuSudBDX+bkSUXPr+og2bD4=; b=
	WSpiwvni89jDr2JAJTcUle7k55MCgX+/p1aHmYVe59IGjJubu+EjNhlvTzKkOnwq
	p6E2pQMEMoMMmbJBrbwCxzw1AvshSygD/lIczA8KV52ALuXFUOv5vSIFuTeYFzZM
	+RN+/bK+A9d+UU/AUZV5idDeG8d8c3sNIDU/HU1yaXL5ZYFAQ7asdtVK1PjXwjE2
	XvV5KbGStPIUxT5Nt3IWGnscH0gu65bpXksdOIIcSIbbwZRPwh22fCYKRpBkE4p6
	+2ZVWWAtbZ6L+0am4vNqI6TENVzwl/agvZVVh6UZqm5SSzAxllAMoI3nq6PoK/oA
	wbmhhD+Z/mfe95xYd7kCsg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j80w6j0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:57:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628cABa019602;
	Wed, 2 Jul 2025 09:57:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uarh6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:57:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Db4C44FufbkzFKjxtKwj8WsuvZhj2V6PEzt7FrajlMfOeJXjGvgb1NU9wUZS0Z2o9alTXrAs7sqN4GuB5My/cQs4Oo14bo7LUIWn2bA/z+O4v0bqRX5dxDD9eb58271u6XhmP+k/8tkHK3g6yxJm/jnTs//oiV5LIyA3p3bbmLy4xdZxB5hOOGgpWalFOIexm743xhPuIWUhhKOzVgk/xY4VKfXnNvRlmwOuw9+wHM3ByO0fIUYH2x5F9PWEinhimKcSq+Fm4tLEF8M1MhNir7EY8ECckOTOtYJNzCUMIDQLrQkdtlJmmfXQPCz/ivPAag6v6gQUd9GzHiYw13XiSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5k+rTduc0hC6e406atFGBuSudBDX+bkSUXPr+og2bD4=;
 b=aB/6yBJtT7DIzCovMcFQ5kdagDVW1Gn4atAOuz3dnKaMtvXJh51Glu8e7uMAbjkcySWoiVRQR7vvkO2r6E1pceP9lVHdI5VzG8Ebv1Qk4LIezBmXKJs/H6zU5safy+sZIKN3tGTrkYi+lt2Iq5FPDknK4Y0VODmRPjlQFZ8G7kr2DNYMks57OZuAIc7M9IN4RyZBvCdv6OsUWB8Cgc2QSkDyS35gPjokJ9bTEYZzXdNrH6AE1LR51Kfv5mOBcAqzQl1ovoiygzfgFz6DhR6Ky1YGEEOY3qDNgI1UMU3nsA0xtLYRXD7P1MOsMmiIYXtRMj0K11arJSwU7ZEcYGLaHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5k+rTduc0hC6e406atFGBuSudBDX+bkSUXPr+og2bD4=;
 b=YVQVSyJnAtdd9hZMGUiwh0lsJVG1flPG6m9UHu2sDHSUSDKm9ss4LbNrzTDZp7pj2qHN0qf4wlgLk5XFCCShSYiI+ecZG3XMLrRFzZoYPP7XMbnr7JOF2N9wdipavlOmBh8TlFIzIl8+IdltJGOAaxY+xgIV9wUeehnzyEZqUA0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB6267.namprd10.prod.outlook.com (2603:10b6:208:3a1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Wed, 2 Jul
 2025 09:57:39 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8880.027; Wed, 2 Jul 2025
 09:57:38 +0000
Message-ID: <a44a8b7d-c8c8-4bc1-b9f1-b8becb966db2@oracle.com>
Date: Wed, 2 Jul 2025 10:57:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Fix shared UUID issue when creating multiple
 hosts
To: Luis Chamberlain <mcgrof@kernel.org>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: gost.dev@samsung.com, s.prabhu@samsung.com, linux-kernel@vger.kernel.org
References: <20250701220234.1605559-1-mcgrof@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250701220234.1605559-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 0780e95f-7bf5-4823-3cc8-08ddb94ee0cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTYyc1Y1THpoY0dvSUlSN0JTYkRGZDZHeFQ0OEJiSXFpcVRTNHhFS05rUm8y?=
 =?utf-8?B?TUdpQ1JlZW8zS3F1NDdIc2tmbFdCSElBRDUyZm5SemlkNWxFYmUxYkxXb1lw?=
 =?utf-8?B?blVreG1DN21tSVAzWm5rb1hJcUp3WERkdjdTRGh1dFFWSTVwck5pdGxPRWdQ?=
 =?utf-8?B?YnYvdTBkay9KUFVGcXNTWVdhT2JrdXNKaUtvZVJncytOOVRmY0R4VlJjSlRz?=
 =?utf-8?B?NDFub0N4RU9XUjVOendZRkFjblJLQUZNWjRNSTBUZzN4U3FFNm12cjFXSEdl?=
 =?utf-8?B?V0tBblhaRnh5cTBGT2RuNFZPSGNXaWIyeFVQQzI1V1NUSHlRUXV2NnFNVU5i?=
 =?utf-8?B?U3RXWjZYdklTeDRBYUQ4R2YyckIzWEhSbmRZYndQWUFzdGZSWnpIb3B1M0tq?=
 =?utf-8?B?bTU0ZFFadTJNSngvWFVucmNralpMVkNmamlEdzZ0QVZVREpIM0dGRTEzOUZa?=
 =?utf-8?B?VGYxS2lPUWxKZ255UEJUT3RmYTg5ZDdzdnE5Y0lzajVraTFtVGdVeGk4RGVR?=
 =?utf-8?B?aFF1TnhScmxOcFp3ZkhRcWozZnF6N2lMd1gyeGV4ajhhTGdPalhVUW5nUFBw?=
 =?utf-8?B?Ri94QWh1QVcrNDMzek92OGova0pLeUs4enozUXVoUkpHQ0QvQThjTlMzUHFw?=
 =?utf-8?B?OW1jb2lzWkhkYjAwMVZzRXJsRVB5L1ZDWk1kRndUMmdVZURnOUVDQmZxT2Vr?=
 =?utf-8?B?WGdiSWozR3FXdHY0d0V1ZG56cUxhQTAxSWdEZzY1Sk1nSnNDWHpoaUZLTWdF?=
 =?utf-8?B?VS8ybmlMVjVid0JSRVpsdE1HaklYUVlxSEpLOWJkbnZwMjI3TElQeGc0dktI?=
 =?utf-8?B?SnIwWlpMU3lQbUVDZ243Y2JwajZRNWJnREN4YkRJM1ljb2RxeHVxZWVDUCtx?=
 =?utf-8?B?Y3g2YS9MR2dPWHkveGp2MEJLNXkrWkRMYUhLSVl5K25DUzZITUJLR3grMHcv?=
 =?utf-8?B?V3RCTk1TME4vbnQvbHoxbk4rSWZSSmNmd1YvRktQY0NRdnF4MGpXeDNaU08x?=
 =?utf-8?B?cVE0YWtvRHJiYlJOb1gxOGt4L0Y1elB0eWtXM3o0b0Q0SkwvK0twUGhJa3ZP?=
 =?utf-8?B?MGcxUkZCTVlLenY2NnkvVVJPWVBibjFINCtUaHc3ZExXL0lUUzJZUXgrdE9l?=
 =?utf-8?B?MnRwMUhNZ0FncXdDUmFyVW43dGxGNlNNT2ZCWDBmM1dyUTFISlBCM25mUFVu?=
 =?utf-8?B?cU00WjJzaEx1MjAzM3NGZVYvSXVuc0tsQ3FuejJrM1NFbUJ1Z0NDcE9Sc2gv?=
 =?utf-8?B?eS90T0NQS3hBZFhValE2SEl1SGJCQnpTYXB6V2YzNjNmMzFHZy8waDREVmRk?=
 =?utf-8?B?dUVwU1FGRnlhSDF4cmwrbXIyU09wUmtOaVJHZHlQd1VqSGx1RDNGRE0veFpV?=
 =?utf-8?B?NzIrNUZKb05jUFpLUWZlM3hhOUkvclVpRGR1UVFCdytRMzhBMnN2ME1qaVE1?=
 =?utf-8?B?MnRmWDNCWlFlczlVaDJRZHR4cCtDdlo0UXd4emswaEI3d1Nudzd1dEZiRVFq?=
 =?utf-8?B?MS95TU9aNFVDMWhoeUhjYVZaVXVVdzBEVFJ1SU9xRWUrcVZReXpPaytrVys5?=
 =?utf-8?B?dHl6cG90eHhTWEhSSVBzYTN0cEVTTnVyczMxZ0F2Y2I0UW90bzMyUXBLai9I?=
 =?utf-8?B?K3MvR1VlczVVOHNFQjVadml4ZUcwdzh1MUlXMmFtT0gwTnU5UW9zVnFPZ1dG?=
 =?utf-8?B?aHl4ajhsM2FNTEFTVU9MeitWN3ZlbDdVdGlDWU1Qck9McFB3aWIzaWtSMmVa?=
 =?utf-8?B?LzJvS0M1Nm42VkxxK1dQUTBSRGdLQkdDSjliVjFqS0NYU3RLSmUrcjRNN1dK?=
 =?utf-8?B?b2YwazdyVlFUYSszTXEvTXQ5SUFhZXc3dklsK3JLZEIxeWJvcUpyQThjTURz?=
 =?utf-8?B?NlNQTzRrZXBmWWZaSmRacFFGK0JkeSt5Ly82TU50Zk0vcWE3OTNwdXNsVm5z?=
 =?utf-8?Q?zFBWZjEoEAU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bk40cVRTQ1FFblYveENGM3IyMlA5RTA5dFFRbTkyak5UWFJnbURsZERaY1A2?=
 =?utf-8?B?OXFSNk56OEN2MVA0VzQvV2J4UlAzV0ZFcWpGQm5uYm9HOFhCL0NwelpRM29G?=
 =?utf-8?B?NnZCQmRFcVUxYkM2NlBiZk5DMVlYMXNRVDY1dmJRblVKbGVaZU9JQ1BOc2pn?=
 =?utf-8?B?Um1lODFIV2Vid0FEV3Y1a1dYT2JEQlhzQ04yOXMwSkR0Q2M5bkhnZXV4NHZ2?=
 =?utf-8?B?aXpWcjgzWUUxNG1keTVtT0lvRmxxV1UrOVhFczJrMjg0VW1TdVg3QVYweS9O?=
 =?utf-8?B?YnBEditHZUpkODQyNFVpQU1mWm5PbHlveDh4Qm01aDQvNnpFOHVON2NmSk1J?=
 =?utf-8?B?ZjV5Z2ZUM1hsQm5SYXFqS3BQbkpFRGt3R0ZpWnYyaElmTUl1Wm9sR0tsNjY2?=
 =?utf-8?B?ZCt4RFNHNlphc00vNVBhNzZpUjB3RnpGaU9qT3ZxVDFYN0krSkhFbmRhSHZO?=
 =?utf-8?B?N2s3enFBcTFTTG55TGhpNU9ZYTVSY3ZsdS9JUFZWajBDNWk1VmdLdC9FVzFm?=
 =?utf-8?B?R1Izd295emFrS2VTYnc2bHFSWFBvMFpxTzF2eTBxVjhaakplYlhuNWpxZUFU?=
 =?utf-8?B?MW44dWQrVGJ6WGo5YStqMFZvc21hSTdHb1ZML1FnMjJZY3ExN29GQk1KblVO?=
 =?utf-8?B?TDhHRmJBNG43QUZMZlZTM0V4Q0pVMjJkOGFLSDVQSkZVWVN2U3hsanBZY2s3?=
 =?utf-8?B?eWpTZ1RFeTI1Q2xjbjM5MDNyZ3pVV0tXZXZwVFlVUnlzUXBST3BGUmErbEFw?=
 =?utf-8?B?TmJEMFIzOERWRktOVjY3cXpzS2ZkMVBSVTR4b2tXSDJSUkFucGRZQXhsbUlD?=
 =?utf-8?B?eVZMTzV2OWU1TW1ydmloamNvSkVjVEtzNDJqWEtsSmYwRXExZEVnTnpWZTdy?=
 =?utf-8?B?S1ZhZ0k1VklZSjdLZG9jMllTMTU2UGxMWlEzYWZwY1NZenBMQ2Z5NGVDT3J1?=
 =?utf-8?B?N2Vwd1hQRWVwVnMwT28xeXA3MFZSc3l0TU1nMGQ2cWFpV2k1T0ZYM2lDRFRT?=
 =?utf-8?B?Z1g5RWtXbHhjcjV0eDN2OUwxZ2pna01CNUJUeDI3cGNheXJtR0k4clZ0RTNO?=
 =?utf-8?B?cHgyYnpieWpYazNSYUFGcFk4c3RhVnV4OTRCaWRpaVRaeTFYVXA3RGQzbGpU?=
 =?utf-8?B?MzVYV1Z3RUZqSHorV2FhL2NaN1FuS1hxV2FYSUhFaFAwak4yMVd4TjZUdkJ4?=
 =?utf-8?B?YVJDK1FNVEhNL3YwU1pqVXp4RHRvbE1yVkVKaFZXcjF0WVhvNUh3cE0zK2I2?=
 =?utf-8?B?MlpGejhzeFF1T3hJbFVLU1NoMGROTDRpQVJML2x0aThXdWdCclhNclc4Ly8r?=
 =?utf-8?B?b2JKK2h5VlN3OEk4aXNwQnlraDU4K09jVUtjekM0V24zVW53dml6YUQwNVND?=
 =?utf-8?B?cFE0SEJvY2N5SDNibWxLb0hmbVA5ZXEzTG5QajltSnVNbXpYUHB6RXpWb054?=
 =?utf-8?B?SG9tTUtTSjc4SDMxYWtIK1VCazZicy92NWpoKzgzYjhoM2NycGRHZkRjM0Fy?=
 =?utf-8?B?MHZ5MGl4TE5VaTFTdUdlTnlUZGx1ZDlaaFovRjM2NjhEME1XYkI3SzZnVVEz?=
 =?utf-8?B?QzFhVlA0bVFpSno2U3dSRnVicFJOTTNITzlTTllIcFVxWUF6akxQb2Z5a2NO?=
 =?utf-8?B?Z1Ezem12aFBMd1RLL1VYelp0aFFGQko3emptbWRIZFdYTjIxa1NDeTAyY2c4?=
 =?utf-8?B?eDdDSUFyZC9GaHE2Mit1SG5RZlFPQWlCekJNLys3UGtZNW92TmVLQlZJQXJT?=
 =?utf-8?B?R0FIRXYxUENpWDVWcEJReWRDejdUM2RGVnNTUzY2U2hiWUlqWXgrQWJtZUJm?=
 =?utf-8?B?RnBySGJQcytpTmdtdTh0WWNzNUVodzZ4YWJrQ3h6K1J4VU8yUWw3OUtnMlRn?=
 =?utf-8?B?QlBrcncrRkZUOUhIUjJ6ajlXZHVlcDB3Zlpnb2pSQ1c1bFBrdzJtOEJCRU1M?=
 =?utf-8?B?L3crQ3IybzlObU9WOUtzN0c0UEtJK2ZoaVJ3dlNKTksvVEpwVnloaHFiZEk4?=
 =?utf-8?B?VkU2UzZMQ2hNVUFjMjJvN2pJQUplb21MbjVwakpmTEoyMWNRK2hMVVpDNW5z?=
 =?utf-8?B?K0paZ0NEaERTWHBQb2VYRElpWnJrQnExelZOVTBmdEd3Und5TW1WOEhzUklh?=
 =?utf-8?B?Q0hMN1pBOUUrcUYvQXVXWU1aamZlRDhGNTBvdlZjdkVaVHZyMlFGVUg5WU0x?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OLgNH7YK1qGS9lBFkm0vL3Z25edSdqb9Vh4Bvoo35plnqtAql2foomR9pEfKvOJZtCiItDirQa7ZZ2UV/OrZu5LzV5d7KBcWN1QwOKIvYMZONHlXwwlu3eigctCzvMX009U0lQbHDUJUvjaGMIWSdcvg2Nm6SLsbNNrY2pFQf8sIiTCf+/ZBrItbj4OnDvVvFgzN5+ItPje4thvFAhoPt6/Pe9TRpLAGSOPfcl+1P6/5cpf86du5LXCLF77pc2xjtNgDw53sy3Udkdb2CbKUfCKb8fWwG5F04n602/GyUBjsvaqzRhVS8VgOmNLdEi5D/kBSeTGyeGEbloIN1Vu07+HkbN2JTQAO5HpSSPxw69dbs6BYKNZ5hnWqlWj3yu/ngodiDUU0zeSg03g7QlP4dqB4mWjcrFNz3Eti5Pl2yYRToiV556pW0r5vbl9BguUsxxE4YDdVHUFGUF1A2PCvzhdsEXNMPHfDM2hyEViO2TclEWkTQK0vS+lVYPnlqhTe7xkO1YVR61ZrKI7UmS4rGLjSVuz3c8phn1nrfOKP9TGlFiLfA/F59bzq0YflcyZa3dbdOShGGhKGN8Tw0zxcjmjLO2GsTqXqzRJvq/QmGvw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0780e95f-7bf5-4823-3cc8-08ddb94ee0cc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 09:57:38.9306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fj2GuAT4TnnsOJuUmCARi4UUPSntzRYuivYsAjUJORBTrLGvWzX0Qw4UlElv3JY7+MdLOG8oWZPsvxzXKOu/uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6267
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507020080
X-Proofpoint-GUID: VbwskWUiYCYaTi6wCDdY3CR_TK6ELAX8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA4MCBTYWx0ZWRfX9q5AH9OPjOkn T1IzmC+VKylmWU5mIDnbmq0NZDb7Kg+izGZUjP8dB3uiHG/lelBYehVVNaXbYQlueIkGKcvakPv jnyIhKtsdcC3s8d/OP2qpX32MHW+bb3/cdAfjc4OwzrTaXyy47vNOCd9uf93SP1JU3b9ot9czeN
 QNSjcFEBw8yMDckSvqN20b8k+cd6MOYQOJYXBNQhhungDGbb2EatGvjoZn9vRKZBv71uyYpKVxQ 5XXbM1t5s/Iic3hGjvVT3xWI/aKIayVcRpnr2tzBtN15l9oa2r8kUKijevP3JwmgKHth3Q/Dk19 vedv7jq5RVSR4IWRCabeJX5pjTDF9R5y6inqhne5y9vVjl0v/tbikx9oNSEzUPDufUbdf2j/M6P
 GX4Cm4EqBdtqPvxmNp6Zsjfi3jRugnqaRjb8ww3UE7yviFIgwmcOVtrcT153mTJNQvkXBJyv
X-Authority-Analysis: v=2.4 cv=D6hHKuRj c=1 sm=1 tr=0 ts=68650296 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=H7Sr59gZVJZzYRzzpL0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: VbwskWUiYCYaTi6wCDdY3CR_TK6ELAX8

On 01/07/2025 23:02, Luis Chamberlain wrote:
> When creating multiple scsi_debug hosts (e.g., modprobe scsi_debug
> add_host=2), all devices share the same backing storage by default.
> This causes filesystem UUIDs to be shared between devices like /dev/sda
> and /dev/sdb, leading to confusion and potential mount issues.
> 
> For example:
>    # modprobe scsi_debug add_host=2 dev_size_mb=1024
>    # mkfs.xfs -f /dev/sda
>    # wipefs /dev/sda /dev/sdb
> Both devices show the same UUID, which is incorrect behavior.
> 
> Fix this by automatically enabling separate per-host stores when
> multiple hosts are created, while preserving backward compatibility
> for single-host scenarios. Users can still explicitly control this
> behavior via the per_host_store parameter.
> 
> After this fix:
> - Single host: Uses shared store (unchanged behavior)

Does phs even have any affect for only a single scsi_debug host?

I thought that phs means that each host has its own backing storage 
which is shared among all devices for that host.

> - Multiple hosts: Automatically uses separate stores (fixes UUID issue)
> - Explicit per_host_store=1: Always separate stores (unchanged behavior)
 > > Reported-by: Swarna Prabhu <s.prabhu@samsung.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   drivers/scsi/scsi_debug.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index f0eec4708ddd..4d0b17861adb 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -8034,12 +8034,18 @@ static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
>   	bool found;
>   	unsigned long idx;
>   	struct sdeb_store_info *sip;
> +	bool uniq_uuid_required = false;
>   	bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
>   	int delta_hosts;
>   
>   	if (sscanf(buf, "%d", &delta_hosts) != 1)
>   		return -EINVAL;
>   	if (delta_hosts > 0) {
> +		if (delta_hosts > 1) {
> +			uniq_uuid_required = true;
> +			if (sdebug_fake_rw == 0)
> +				want_phs = true;
> +		}
>   		do {
>   			found = false;
>   			if (want_phs) {
> @@ -8054,7 +8060,7 @@ static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
>   				else
>   					sdebug_do_add_host(true);
>   			} else {
> -				sdebug_do_add_host(false);
> +				sdebug_do_add_host(uniq_uuid_required);
>   			}
>   		} while (--delta_hosts);
>   	} else if (delta_hosts < 0) {
> @@ -8383,6 +8389,7 @@ static struct device *pseudo_primary;
>   static int __init scsi_debug_init(void)
>   {
>   	bool want_store = (sdebug_fake_rw == 0);
> +	bool uniq_uuid_required = false;
>   	unsigned long sz;
>   	int k, ret, hosts_to_add;
>   	int idx = -1;
> @@ -8578,6 +8585,9 @@ static int __init scsi_debug_init(void)
>   	}
>   
>   	hosts_to_add = sdebug_add_host;
> +	if (hosts_to_add > 1)
> +		uniq_uuid_required = true;
> +
>   	sdebug_add_host = 0;
>   
>   	sdebug_debugfs_root = debugfs_create_dir("scsi_debug", NULL);
> @@ -8593,8 +8603,9 @@ static int __init scsi_debug_init(void)
>   				break;
>   			}
>   		} else {
> -			ret = sdebug_do_add_host(want_store &&
> -						 sdebug_per_host_store);
> +			bool use_store = want_store &&
> +				(sdebug_per_host_store || uniq_uuid_required);
> +			ret = sdebug_do_add_host(use_store);
>   			if (ret < 0) {
>   				pr_err("add_host k=%d error=%d\n", k, -ret);
>   				break;

