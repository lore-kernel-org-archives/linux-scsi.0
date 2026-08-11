Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFEE429036;
	Tue, 11 Aug 2026 11:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447566; cv=fail; b=M8XsVJnlC2EF8UT5Go647qR1IoUJBcyKtpf+n8QNuQn7JX3MiSrpApo/dgEKD7tMn2JS5hrg24JQPHhkc9Ki2b0r5VcCxv7O784aVjGjJoHoQt0IYTHkho8RfcTO3shD5BrAlEN3KeorqJt5x2xc2ZOanKLAd5+83n3S6HvbMlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447566; c=relaxed/simple;
	bh=VyAIC3V6/WAOW3tVeawrvW1vMpln7w73HY4q43welDo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qDP596z6iLMEP8+p0zU+4SKeGk1AyIG4D014AK5zwE4uctN8q58boqghULe6PdVMCh9DityQ7TqBxbvcENEiWB7PnIeddxBr/BzaTcSmRKkQ4S3XhE7Uf4GoFrD1E25ck6EeGWoYtdWLKiks7F02z6qyWbAcK4PLx+QzfEfKC+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M3kdPHwx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zdPRXoC9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3kdPHwx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zdPRXoC9"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B9Mnt82022191;
	Tue, 11 Aug 2026 11:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VyAIC3V6/WAOW3tVeawrvW1vMpln7w73HY4q43welDo=; b=
	M3kdPHwxaHZU3rr4ccNwx+oPtvtPWpfOQ40adPqix/iJN27FliFxe9p+b8GZdCyB
	dG1QTD8UEgr+5fdFRwOT0wVX8Vb0NgfMkggy7BCNdxnuudbJkuvh3QQ2j9jM5tLu
	bU1FspmyLQG3rlrkJ3GQNW2Ckl8hFWYgjPL3s3wxzjr6Y6PZWjThdz3hADfkg28r
	iDLBvlzZL9+uGW1lNnAgfa4Feb4v2onNkdjhkBtkp5zECNTEPF8QJN1lpAgeAuz+
	84fmBw38PbLnZ0Ux5mppMabhG23MHDh9d5LvlYWmgIB+4gKBJGFvkoWxZ/peBwGN
	LyHbaU5Qt6DoIHD93Vlncw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvfxvntg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 11:25:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67BBPZne004592;
	Tue, 11 Aug 2026 11:25:49 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwqdfgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 11 Aug 2026 11:25:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bsv/ixuhtLcb0XkONW93UmP86Ln7h9X0RY5YIuyNGHbNqwGHLZ0oQotWEMyxypPi6/fR4MpzQcMD24fQUJn2HzuLNrbFnOW2VpPVgc3uP4ElPnSkfOb8TzVq3S+02q7bw5DTQ4pdVpVqGDX0fO3bXRQGgbJCna6x2T8MQklV29T2MtMdOXT3U/Qut340NTcNkhxMoaH5BlWDTttbCZZ+gbOJBQr17BGiUR3Pd8jgQMmZOHTnU1eKxksObyj8WJ1HVfdfRvDUOufYfm71zeoZlqMwiAvmo1dErixiXwtfCAhX3beaXchngt4Q9MfxVas6YWS4rbHxrUy6eaFjglbEtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyAIC3V6/WAOW3tVeawrvW1vMpln7w73HY4q43welDo=;
 b=Mudqw1wUSz3r/qJk5ibp49Adk4O6+gVRFgiovR0Dm2W1TI8LjcSEFtugvf4MQzT7c06GtWfcBI3vYWe50sVHvhUtN3bMDRBRXK465GCvzUfXhonSAg9fFUPQaeBSI0TR9k6FHZ1lTPCcFjSsdnQkJvNVGNzk4PPPqH7hjm2A07Inh1wHhnmSoLA66Log7XtHdRlOT9kPzqio2uKzDvyRDUep9qby5e1LzYLRs5oxWIR1xJcXxr53KulD/vrhTkgAfbslB74CSWXgWw8LaDCO6koYZW2IEnR6jlK1BxAxiv/BI+yfrFrhTU0x3wdkAkvJKsIssBwMXKEIGSYx7ug2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyAIC3V6/WAOW3tVeawrvW1vMpln7w73HY4q43welDo=;
 b=zdPRXoC9n4QQfiJ0Xh1VbH2NrbZhrfoDzEAL2sZnPZP9Hkg0vTZQWFZ+4YkLcQf/k0tIXMDos0C/g2ZY1LwA3OVN2GbC+gyUlV2EqMlTlhbZjH+R2hz2W8SZjF8Y2A4Xlkec8j1P/ldhwJuFcLrckKgy7N3x8yp7MzYdeQkJDRk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS0PR10MB997555.namprd10.prod.outlook.com (2603:10b6:8:30e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.12; Tue, 11 Aug 2026 11:25:47 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 11:25:47 +0000
Message-ID: <bb363b09-640b-474f-8f57-194f8d7a8455@oracle.com>
Date: Tue, 11 Aug 2026 12:25:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Handle errors in sas_ex_add_parent_port()
To: Eshaan Deshmukh <eshaan2031@icloud.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jason Yan <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260810210942.150617-1-eshaan2031@icloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260810210942.150617-1-eshaan2031@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS0PR10MB997555:EE_
X-MS-Office365-Filtering-Correlation-Id: aa743b04-e33a-47fd-afb9-08def79b4a0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f/3OqgzU6uUGSTmUVhcmMhmGRodJuQGlozJMMVISn3EVghL+SuYzjX0lyo3VlyaOa3ZJq9ZXxHt0YbzTWs6hhGYP8ZxwkmK+xNbAGjPWINDg8dww8DjCApIyUT0M4MTuvZEDz4r29jZrVmkdbcLY7suDKULBbnlTk5CMSdQjWN5WfTlzrfvMu3hekI8uUwDR+1hMkfyvZTXpVVrCQksQVGZbsL7pFVR5VBqXMkk1m6hOivwUcYR0QR5hdQw99h8olVPZGLCBxFfesdsFcAIHAt/POCoGHAknu9n3KJu3Gi71IZro2EFuu/YhnSwGNCcmCpdqDXsQA3kj21pqpQ/gW0H8b5NlgUVpwN1xBsOlxP/utE4mI2lwIN/VY3/liludne0F7u0BSHAeCSOSsCRpAdswXAI9fBXCtxTKVrROB/ddf8Hp9IrSBvgo7pT08Fphgc9H/Y+hCSsZSllHXgQnKlwXxoMXfSzshz+Pj8+kWImM9AFWAyrs7WEC/ArnOv6+SeOYlLBFZO5dPUdCEhiDi2UTPytRqtZotHgKUnp7JGzlW1ag01GLhcKttb6zOgmMbff8shiwgX4I08raAeO3/QfNrfnvog7zqO5Ho4N4vkREB9IPGrZfNxlnwTf/AmK/Flt7bt5bYUnANr50L4Kawn8dljQU3lSX5JWGLOdCnuE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjFhUFAveXJQVjBzYXZxMno5R0dsY2pJVlRIV0VXRkUveFBERWc0UEkzU0o5?=
 =?utf-8?B?OUszY05UT01YWVpob0JPeEI5OWtGZko5OVY1OE1SUm83NFl2ZHZGUk14Z09E?=
 =?utf-8?B?aWpDY21iTkRVWWl4c3F2dk1JSVVxZERUWGNMV0Y4STc5WXBrVGd2OHB4Zk8z?=
 =?utf-8?B?RXlXUDhMNytQOHYyTC9qT1ByZFk5ZmNUUUxqMTNoNmlPUUxFdEtCZE9mQXY3?=
 =?utf-8?B?Y2dvSXNBMVpLcGJHdEpDTjFnNENBTG9FamFiOHp6Wis2M25mWXV2YktpejFs?=
 =?utf-8?B?emU4UE9pK3c0ZXpLVzk4MkRCOG5RaSt4d2t4Qy9qUkRDaTNnNzRYYnhLbjRj?=
 =?utf-8?B?dC8xVHBVRnU2Z3RuUERhcTBhSUxHN2dZYlZnaVZ1QnBQSng5UVNkN0dndlVC?=
 =?utf-8?B?dTNRbEZGYXdkSVlxamdCZ1hNSXFlTFZDZlB6MUxhaHpzY1YrMm5qSEE0dEV4?=
 =?utf-8?B?UE5GV0FueXg0Q1F4d2V2cC9xTzJ6Z3lvSCtiVjFSeU44WVBTVWl4V3JhZDdI?=
 =?utf-8?B?Ym1oT2NicVpiaFpQRXVCTDhWRm0vd2VHbERqczgrY05ZcmJaT0ZxaFFWbXdv?=
 =?utf-8?B?UkhZNHVsbTllbitjc0hXa0c2dHJ5dTlWZ3ZBcEtHRmNaalVwVDM2VFVCT05s?=
 =?utf-8?B?V0piWkJ1WnVRdnVqaEdzejRXNWdvQ05NOXZpTUJmWS80cXJ1WnRxelhoSVE3?=
 =?utf-8?B?N3dBQWF5R1JWcVhaUVNWUjVOd1hBZzNLVTQ4SjlvZU9NOVRBTHJmZENBamdQ?=
 =?utf-8?B?aEhORDhYalJtNE55dHY5eWJhUjhpa0U5aFN6K0tON2kyTHhuL0dCcG1PR3Zw?=
 =?utf-8?B?a0RueU5mNWNnTWwzUTNSSE5CYjBsN0RFRzdvQWpVcU1DTW1ZUGtoa0E0amRn?=
 =?utf-8?B?RWZVR3ZVTzIwcVowS3ZGTGlaY3h4d09IWnJUWDYvT2xuVWxCUHRBclQ2SlVl?=
 =?utf-8?B?dzgvb1IyZk5XdzFQeWhrcE92ZDAzbDFqNkNqNmE1cGwvNlVyWS9rK3o2WlBB?=
 =?utf-8?B?WGNZcDMwVTZHMTljY2czUjcxTWNaT2xzbjZDVnp6SlFGRU01Y0krMXJVYmo4?=
 =?utf-8?B?bkd3NU5kMWM2aFF1c3FkUm8zTkpsK1ZmWnkvNGsrYmR0VE5pMTM3S0Jlem1k?=
 =?utf-8?B?MDZqWXllZDByeFNWN2hBWGVHeit3MXhSOGdzT0ROdXVRUmcySW1wS2dOZTNH?=
 =?utf-8?B?dk1RN3ZXUEFwZUplUmZwOWZncUt4UkM0T2ZuU3VNWkwrQnVBRWIzU2crc0hq?=
 =?utf-8?B?djY3MTZqSStwUHNlcGUxY0dVMnB5MDZsRmRvK0lNckdiU0NZUTUxajNGZUwx?=
 =?utf-8?B?M2dyUk5xWnBJaGdUMnNjeXM4S1o2OE5SbzFucmdJcnZhQnJJRldJaVFzWGxT?=
 =?utf-8?B?YS8vQmtZakRLajR1K0xScXdNbmVyQjN2S0JlMVh3WkNQMEJBUnhYam9pM1F4?=
 =?utf-8?B?d091VHFaUnhSTWZESkFDME9VREN1Zk9oWWJySTBYNnMrN2JaWjVTd1YvVUx6?=
 =?utf-8?B?MEFnZ0FiSnExNm5vRUxFc0FFL1lyZDVvUWNUUXFUdFBFdXRsOFFtWDEwdUlC?=
 =?utf-8?B?ejZnUTFnTUQ0S1AydlF3ZGJvR3BvTkNWN2pTdk83TUgrYVRvNVNKcUJnRk8y?=
 =?utf-8?B?ZTJPeTNWUUwxeTVMTUl2VnlnYlJmTVZiM24xUHJ4TWNEb083eEdlbGhzcXFS?=
 =?utf-8?B?N1l2UG5lRWhSVE9mdHhFdDlWcFNNTkxDOXBoM2NZb1FESmN0NGdCSWNRakUy?=
 =?utf-8?B?NUVTN0Q0dkNXcjFLS29ZS3pKTXk4ZjRNU1pwem1QRDQ4WWtUV2ZjdWFQbkVF?=
 =?utf-8?B?QS9sRTF3Z0l0M3RmUFpwSVpmamN4MnZLNE94VDMwNEhheFA2cWRHT3p6OFlO?=
 =?utf-8?B?bU9GVmtOMDFPWUdEcElyZ3lLR2NXUUZFenpEWUxRWlpISWpsRFJPTExUVmVl?=
 =?utf-8?B?NTlSejhwUVZOU2ZZSWRObTR5YzNYRnhvV1dRV0xUZmVxUnEzZ2xWcGxCcmxK?=
 =?utf-8?B?L3FHazNpT2lweXQ5MFRocDNuSnBmZ1doZDZMWVNGeGdRYUd6OE4wZGlCVXl0?=
 =?utf-8?B?VGFWQVhpOGdKQnliUHZRenFWTnRUcmVqSmtJbnMvY2xDWjRjSEd5RUY1MWJa?=
 =?utf-8?B?cnJkSkVWQjRvZ2E5SmpEOEtDb0t5dzRObEl1Zzh6ZTRNUzVlUGNlQ2tRRlBQ?=
 =?utf-8?B?L3ZoRzRDb3JqWkd1ODJMNWk4VUJJOGtuVWE4alZncWJTbmFjOGRja0hOU2ZE?=
 =?utf-8?B?NjBnL2N4MGo3KzZxc3R3S0lIYW8xb0d4azl6OUltVW80RHhDanh6bmd5VHc3?=
 =?utf-8?B?WTl6THBLMjdkYm03MUR3eGhWZ1Q1UndBbDhsRkNPcU96c2JKOXd1WHhrTEtQ?=
 =?utf-8?Q?nh3zjOU3YWCoW4EM=3D?=
X-Exchange-RoutingPolicyChecked:
	YW1WXCkETaVN01k8+1YtiyuEY91ugbiHjb5H4zE649JGfaF7d+mQQhbnfH+03UbiZ4jtpuBFerL5PXqBvQYk/lIW1ZeLIFnzEnzQcyNOgB8KN1nyHfGRDhZL6mqnRB9JCXcj2ZyiAI2QXXqQQSPStaJSLwvf5fAv8lAwxF6P9VGw3qm1udDaC48HdZr1o2ErFPsbFKM6UXz9e8yNCCpo8Qip0gUo77ApYc44pNqYFKMEcWVl/2jVWPKBPAXrQjprBbh/ZG5D64zfnNsnJ6W5OJQFY7AsMYQBZfEZ4PU4RuCRpX8qlO4keFpDae3+6VrVTIHIoT5CZfQCtR7ZsoXSXw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uoYftoT1E2pBi0a+TNiNduyiwRKWSthpdX0vPOMwIZlZgjKca0CQxrEtYbElaa920qnH6D82MVG/ylTZgnGTnlM6XWBfBeDvj8eK21X64CRiEdnPhBFVq2eYwB25jMukbdS9vTC1ti/NXRRUe13sh3bM4Lwml1FYPKFQvgXTI2bfs7KNaurZZwnWhYxIa8Zz8/LhcUcYqwMb74yNcpNEtqippudPy/I/9liAwXcGYzA8IQgG2AAgPJrYTh7LpdJ7u0Mfw7PLF4nv8zo+aHTcK2Y2Jr2gGtGVcApqCb0JL76bsNplu6EkU5C4Lvt4IqQa4NI3zdvLcZXEKrAKz21aSKdh/LGdRw4ZNSUbmC5C386qC1Nqs5C0QqN6KIQAObAuSHeN1oLvuyKJDqhnbeNrUhjEKCrN4XHn9yZVCKL+CVay+T4YWHi1jVVWc7FM07v1k+PeAKYXBVNAEczej6AzKV3+1A4wvs6+Ps409Jx7t6LIpqw5I0CB4W1tVzzoNMUJ96D/1he+u6dXyw0Nxi7+YHUecIwFLdtinGv2Fw0wobRP3lEzR7kwZU6bccuCblD8ca+UNJ3DbNPMGKURbwkLxwB52zBBJULqp/HTEzs8v6E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa743b04-e33a-47fd-afb9-08def79b4a0a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 11:25:47.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pe4i9Ld97QqxDdjmLwj0TxaCW4Odvivpyuyom2vskAzsOUj3FL/2bXzguR+63ygAOmAoFYIvc3918dp6e8UrqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-11_01,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 mlxlogscore=995 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608110095
X-Proofpoint-GUID: P_bu1kHFXm3vmt9JY616yxO-qrqGvrHU
X-Authority-Analysis: v=2.4 cv=K/sS2SWI c=1 sm=1 tr=0 ts=6a7b06be b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=pQJ4WbnlrDuvOUibVisA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12098
X-Proofpoint-ORIG-GUID: P_bu1kHFXm3vmt9JY616yxO-qrqGvrHU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA5NCBTYWx0ZWRfXzvtnP2p+4Fis
 5ObzTXuFW0FL1dt7pyAQta6uGkatDfJJFb9SNVRa8msmd5p2hW+MQbgCFMD/J7Nn0Rep3GsjAQb
 U8j3cY+hKiS1H0H7PmRgOuXkBFXZWCsRcVVEIRPUFXlo1P6R5NpgiH3xdBGawAAxUgF2qBWxle+
 4kGeM/I4NwUWQit3VlRHf9JilJ48YTmxnssM/NtvgEmYvLikCueU4NSuHd3/jsAZFSLzExRu9cw
 82c6EvXYGO7TnrBJDurM1Upbl2UbRbjU5/E2pC2a7cH256tN9QvnxABFLVRtP601WHwqFunuf6M
 pBt42rUs0BrQoCjDetsBSlEC2eeUJ2U3vgaPLVP0KsbfPcCAk3YnKhWc09GvxdLGsZ1fcJwpE77
 6rpK1PAi6/NgNuVtr7clq/AJmuLFLzLSXJZjZMsHVf8ne/D6szehhAFhE44Rm5yenHb6sNmOs7j
 vOi+WHxzAUS4+pP5Bf7Zn42pwtlWsBKXNWDVm5jw=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA5NCBTYWx0ZWRfX4coo74zezyV4
 Ps9cvsSJeRTI5tBZ++KJZs/YZiW0xZrZOrDiftRZVASSz37cHySkbej1sDhelhzZ3tYpj8B9q1g
 IguJuj50YAM+9ihudkWpg8rM/AG0nNBsE2fYN2TopcQ9dYl/cEqk

Can you out all these patches into a single series?
