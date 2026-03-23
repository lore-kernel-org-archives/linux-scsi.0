Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3BE3B8BDB;
	Mon, 23 Mar 2026 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289116; cv=fail; b=oJa/mpkWpx7fh88LDfpBbSUFsy+tzRz96xn0u/BuCZsPpef50688mHACt4yfE4VKjjvGb5j9PWUzlwRXPd65y+Cddj1Rt5ihxjkS8CXPng/V2GdcAYG4giKPEvG7XrK6m98RnUT+soAizPJcedLZkX6J6V91ZoQ8Qgyac7xclNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289116; c=relaxed/simple;
	bh=9EXtgRP3TisT7fYLs4sMx2+6DC3ItSu/kE8bWyfNjj4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eEPV5GJGsb40/OJT3nDEVdOM8na+X87Qb4SITqKtxBsiKk6a4qd+xdWVAK6npdROuc8wSG0TPi8clPFiSx/IxqJ7Ji/8M1phtkfFbjI+Omvl8oiOldKEc2ytpod10GV7t/+vCTNvKbRVARRaS8YpiYLUsD7IFANLoIUpi91OwdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VShloZTP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WHSEEgWP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VShloZTP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WHSEEgWP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NHQ6xr3476456;
	Mon, 23 Mar 2026 18:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Kmrf+iDfLrCtSVX5v7ETELqV1QaNzlFos1q6uO5X6rQ=; b=
	VShloZTPH1aKALv3dYuzmfe+9N2xqHM5tiZmzaKXEDNBNiVQRz/31//LGPSypDt6
	46GIexMxn9vD9FPUCLv9ErF3i2M7IE/kgASW1aJ0WRhOelyFV2vKSLJLVOyMrQvS
	HnQEdSo/cNWBuXkmr0rUrH9cNiGoK/Z+4GKuLOeBFvoVlmhx2xCWTxcKq9vSC4Vd
	VP7COGvjNwfosW42qVCo86tPeNP55PTxJ4p9+6NA51GziO1hCxN6qPxRefON+J0F
	uzXJeNPINKOkofJ8capGOwTcjCScJvDF/MLOBSgwszxk7n1XSVnSwBLQXVBC1iZm
	H0iOHYchVCztwilGoUPnWg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kgfjumx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 18:05:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62NI08je016392;
	Mon, 23 Mar 2026 18:05:03 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs8tpyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Mar 2026 18:05:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nH5viisHrNgraqTAFf8vwZ7RosCOntJbwYIAdiZDINCOw/3HCibFuOGlb76Qh6k4kspr0zWikfrOWjAvG5gJLP8lT0rKJXOJZzr/uAEBTxu+qFBd75BCN8yJc+t+7rEIlczPDowZwW/ERvPf7lyXRzZLRQ0oaWsQYzYW2kmBlUjpmQw/cy8I6s2mBCCc4nujKmneQTntWiGEnLsnmViVcoSWPbcERN3T6e+fkZ3umMAZOGjIxSeRog5OWHoAS9zJiRdvp4xyNPvRjgXmGb0GcjNJj2JOvYs1i73fzVinns42nVnVE9DChA2d9JkDc0fSfKAzIdXSprC/N9erH9ommA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kmrf+iDfLrCtSVX5v7ETELqV1QaNzlFos1q6uO5X6rQ=;
 b=TPuJRkN+AJYaeJ6lYxtcjA3YaXLdaSzSQandvIVtw1qCJLCJk6QPj/QpqvN4DMdrd//nzHAs9xsTCkuzjf4zPC1j604xkT830GyH8+gUMEvJVUj3cH5cjGo1YEGscPBiJlTxWxWo7piG1qCGQDMyEhZcGE8rHsvePq+JnEsG9G2kLKUQYsqHPBD/CaRbZbdW69zK7XauO5yJLDvJAq5VsdaywNwxMRztAWojWDquKkcjd8MVTAm5EYp8TJBlmgO8z+BYvhbGI+2vbmwNkflwiMBpwoslMRPJNYg5mjojbbJYHZ3uWkkbf7uMMOuVOJaBLuuNvQAgWaLS7BfiWgt1ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kmrf+iDfLrCtSVX5v7ETELqV1QaNzlFos1q6uO5X6rQ=;
 b=WHSEEgWPdW3hnO0ebOmI9pEWtMYcw09bxU5WHFXgTGdnp1u1Um3uGymwksVceGPmEvrbIMlrk0QAp4tKgzpa1wOgMQKgz+o0ymr+H2Ix5VpEIUoR/ADed27IgabiWFeVWRmfamQj+mc7W9DfxqP/uPt1LofqWNFwd2UNzBtKIeA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4534.namprd10.prod.outlook.com
 (2603:10b6:510:30::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 18:04:59 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 18:04:59 +0000
Message-ID: <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
Date: Mon, 23 Mar 2026 18:04:54 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acFpYuaL-_9g90RI@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4534:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a157d6-5ec6-40d9-83e0-08de8906b2d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	jXCpUwgJg7UogrZDUBRqwcf/yGdF8DMyaSd291g51seUICLRPPVjORtqoZ+hIp+1GZdFIej26lQYlTdmKpuQlTM5PbhzNmuLunMwYrSQzoXRz8n/cPoGvu6/nqbGDT0UxLajS+EnmLeCQE48NwxV7CWyW3250N/ts5YTbW8kk9jLRXd2XbOKkF4HsTB3rXofLH2CdAT5IYCR/N/c1Dit2JGQPiZ+nZ5IV1baHk0zSzvE5pUKg9lK9uRT1OTM3xVeP2rlghx5Jx/AJJtmrX5msTolhyjXysWAAkY7PreQbMTVsBK8zFCtHfj+YYtZzn9A9SVwa6pkhmIAHRQ2OjqkbsPKO/VMJ6GU8FbahRD//XnRgdBPle9HMPWwsGsUyPEiFmfC8mTSByCF5jO7KfoJMoJtKtx9IbAG+9LABm1z7hiSUxNX9ha8L+zIWLd54Ln8wFzva8gHXfI/iasazH1Kf+CbaSQwh46vIIXCXLHj/h7KUXfbnpSE8d6VrbYg7Ia5Kzdq4lqW4jPirY+0VWN3/fYHC4nmXJd4vXP69rP+J6k+x9aqNDZovZIwivTh8KpLF7O6JZgG9mYFrlEO9+LyKOx7MgQDOmUaGkbjkEgyasmgOjyLJxPFIB6dLo1yIKIhRRESRcHhw8Ft3pj1XWaAbfZgBVw43ylonaIr6HCGFqTijjaYs7nwkgu5PDcVssfLp94rsj1VOwHo+FDaOuQ+LRl1ABrC56gYn4nlu8qVQWU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUFZRVJEbXQ3ek9IRnBUZlRIaU5hZ2RtcW1yb3A0MFJLaEVLRjlMeWdEekVt?=
 =?utf-8?B?cHJGUDR0ajZjSmNXcXhTbnlzRDFTVWFYWE1xK3dFdHhWSEJ2UXZzV0NhaWZn?=
 =?utf-8?B?MTBFOVVtTXR1b29RZS9MT1NUUUozVE10eDVkQjBxUlJQV0hhZHdNdjZnZkRa?=
 =?utf-8?B?aTNVK0ZYMlYwVjAwYkRSMnR5TnBia203NmRSNjFQRHJKbVhxd252SCtTd2hL?=
 =?utf-8?B?ZzI4MGs3TndOem0xKzk3bURnU0xqWVBDQjQzaSt1cTRDd05qUTQvRlU4cDUx?=
 =?utf-8?B?Z0V0bHMrSW8wRklrQlQvWm5oM3h4SHg5WkFiRVBIQXVtWUFYYTlWNXAweDVK?=
 =?utf-8?B?S1R4d3A5RTlNUFNYUVJJS3VsbmdVN3pXRFBXY2U0eUhMMFczSGZ4WU1KVjBz?=
 =?utf-8?B?SmtjbE8zaklQa1lKR0ZjSVFocndNYUFYUUpOaEo4SDVLNU5ycE9QUHFrWTNM?=
 =?utf-8?B?ZGtrblljZVVzUm1vNnFpclJ5RlRrdm5PWjU3b2M2ZkdmU0EyaDZGQnllZ1hw?=
 =?utf-8?B?T1dDZEtQVXNCaGd1bWRwMzRFOHNyeHorWmlKVmhycGcvcDZESStQU0psY3Ur?=
 =?utf-8?B?VVdYWFl1Nkt6aGFEaFoxOUozc250YjBicTB0d3drY0F6R21YM3pybFBqVmwy?=
 =?utf-8?B?ZUREck5zdFRkMkpqNU1hZWVqTmxuQzh5YXRsc1kvRkdnZjNvT1NLb0lwN3U4?=
 =?utf-8?B?aU5TZDlkV3Y3RE5wVjNzMmV1L3FQcElHWjRLVDlCeVBBVDRqZmUvdUdzUWNV?=
 =?utf-8?B?TXJRUjRTbFozd1AyQ0UyUklCWVVEdEZmVEpwTjFMZk9FR0VQMXIrdU9VKzgw?=
 =?utf-8?B?R3I4Y2tVSnJjQUlrcjBsU0pyQWxtdWVob2hqRG80dVlRVG9vbHJKUDI2c2hH?=
 =?utf-8?B?S0swaVBya0tEbFU1d0xwRVdsdEY5UFN5Mk5nVzIzV1lJYmRhWXFOOHlXZTRK?=
 =?utf-8?B?ZGxOa1ZNTW5JTnMyUUEvKzRSM0JicUdQUkxrTVMzd0Z3Tm5yQTlxNEx6Qm41?=
 =?utf-8?B?WXVkbStwaWRiL2JZTDk5eWpWZHhDbFRWMlhLMlVObkUwMkFYYWdqeWYvY0N0?=
 =?utf-8?B?QlZ3ZGxFYmFHM0ZaRGJrSlpiY0d6TjZ1RWwxL2Fkb1VwUUJFcGRMbklkU21Z?=
 =?utf-8?B?MkM4endIT3U2MjVGVk5SMGtjU2dhcGF0K1ZyUlZDNldPL0t4WC84N3IxZjF2?=
 =?utf-8?B?QjhabEluVXRnUWVBdU1FZ2l6S2FCU1d5S2tSa0ZHek9VSVZxcmx1L3VNWmhl?=
 =?utf-8?B?ZGJsa3d2Zjg3cjFmU0l3SENzamdaakx5b3F2L1NXc3R1bWhkd1M2L21rdUow?=
 =?utf-8?B?WWU3MEExVXEyTTEwTkkzNkt1Z1BkVXc1elR5OGxKalpPblp2bWxMb1pidVoy?=
 =?utf-8?B?L2VCWU94UXlVWDJROVhocWRucHdLd1NtTXFZVURwL3RNQ2FzSDV4WU1JMGh0?=
 =?utf-8?B?anFWSjlzSG1VSERXdndMV2x4bS8xZlArNWRoMEozZ0IxeEpKY3k4ZWF2RmZ0?=
 =?utf-8?B?OVpRUkQvS0VyR3hOYysxekN1WTdyUkJveGk4dzFHQ3NTYnAxMHpyUFJmK2E2?=
 =?utf-8?B?QmtFNENSM2JUSzk1OUxXT09hc2NnQksyQkFIVm0vY0pBNDhpSUl3N0RsMllS?=
 =?utf-8?B?VHQ3cmNHS2R5VTFaWWRieFVOUXh6MnUyU005MkxDNG9mQVR1OEcrQjl6bVdW?=
 =?utf-8?B?NmtyZEd5OUNEY1l6ZzZHaEsyblpPR2Z1YXJHYXEzSTRzbWIzWnpCeG8wOGtW?=
 =?utf-8?B?TXhRbzI5M3RxYkhjWnhiNUVWUk8zZkxpdGR6OWFycmFLL0xLeXV0NnFjS0FF?=
 =?utf-8?B?QjYrSGxpcGZPQSs0WWdFWmJIbVZKMFhibkxLMzhYbEJIQXlESkhuM2xoWThU?=
 =?utf-8?B?dVdIV1QyVXBiS0N5SXp4N1h4b3pwYlR0NXlTc0VMd2ltelNBUUpiR1VmWXBo?=
 =?utf-8?B?LzJLSU44WWFORFg4WEZ1Z1BQZlZYTkRESHBsNzRQV2FKN1NjbmVHRzVuamp2?=
 =?utf-8?B?a1pPUk8walVjMmVWRkl1Q1lBMzFCZzlkTnR2UnU4S3ZpZEdZTEtEMDFlZWNu?=
 =?utf-8?B?Z3B1TjBZMnNkU3c3WEFWUlRyU1RQNmVPMUc1N01wTzg0bDc5bXBaek00c09S?=
 =?utf-8?B?SnlKdkxabXdoby9jYjFCUG1iYTFXNUl4WFQ3N1NMYmd0NzZVaHBlMDhsV2VY?=
 =?utf-8?B?VXgrWmRTLzlxYW5UWVFVQ2UxbmlCOXQxLzRwL0hkazZLZ1kvZVBkSnF4NVZn?=
 =?utf-8?B?V3RMRFYvYzhsSVlxL0NwdlIrbmhQMkU4Mm42R1Fqa3NXMFZRM0JPWTVqS2lt?=
 =?utf-8?B?K2hkTmxJaTVGeWZLOHVyK0ZDSVNqeWd3RGlWNlRiNWFKVTdndld2TjB4Y2pQ?=
 =?utf-8?Q?pxFqklPxKqBJE2Mk=3D?=
X-Exchange-RoutingPolicyChecked:
	CuTUlr4yPNDOom7grQ9ZMOV/kwJJzhXJ6chIq+6PQkoDhSdffmQkpRr3nBccQpuxr1H7SZgcXKKVqgFtaSfjtBey+HOGxHf8A/G0CvRu/HuSiT+rV2OsxYZ0jTFblgBDWTPv/RDbW5Z30JtZSU3WnaN9ZypglqjK9O713TFXZMBKCC3NI8nJORxyUuL2ml2fP8xcB35IsU854kOUyxM50KCy4UIuN/r8A0poZP0gVN0/iG76sobb1p45Gws9qCE7KsvKAs/e+GD++yU7qz2hzmobu7APdNklKDaoeLTndrVIadDt2Wd/80VPF6Aw+q59Hf+dTobKHMcvNB1jqpM1Ng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gvzKGsFsA7lS3immrHy8YCm6aWcgmHikET0rYLmb+9A55ZGI6DvnAB7rr8nHJbhisdUyoMYrwlNvVR55iXslDzQ9h518UHhXeSEnjqagAOnSP+yuhOx+v7w6CIgcGRIrgJT2OcK5bYHT/4LJw3N1loCifnIfer4m5tMBdvIIu23dA6PHIi4LZDEpTYg5ee8Xhz4wywQTXzm1QIUddrT8pRXRB1/tUMh0TT9LIzmuaMaaNHKKDr2G5q4eMwE1Pd+7beLtc9Li+8u1WMdmGDjOhyTQmb/T37gcKMWfGF5SQ4uBg+2kBJYvgW0hoiv7HGT8aKpDq2F9vL3JhN7xfktOAlcfMC0/DTFbqpNfMJgHxY14J5oAsfJSJQfE3vJpHRN348Z65+Ivrg87yp76xuj9g4iwlIxthdMSrONRY+ONpG3qGbR1rn959YWh3WoZEB6uGj7Rlof7M0izuEDs7Se60VsqLKqzBWnPNfMQDeFQEdF2fX5rE6uLwF96oJUvwdXwU+koOslbpOBHy7z/xmyu+DJ9YttOGzhr/WiayROwwOA6IdEXUlp+5F2yyWYQgP5k14JijCAeHSejelFlF+ROeRGv959t6obpTMY8dAR836k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a157d6-5ec6-40d9-83e0-08de8906b2d3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 18:04:59.7532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7K1rmmgU6guBIvbLFrFpnP0am+5hAsY1ZiGZpOiDrtu3x2ax3gSoNw5FmjsN0Ns3K3DXHIG+iCAJ1ATFxzibg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=783 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603230133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEzMyBTYWx0ZWRfXxsbAAxvHChlU
 n95sNIjvlNBG+fhHE+4R96sKpR8fIPsWvhz0ehZ0w15OKlGaZCZuikwKHWTUWt6heplLu+19p4X
 Lwgn2k/jFbqJTPZYVA9BNdNM9pwXdBgliZadZOeKzjpRm7yTx1kUn3sXMHScX2Xh6WKjDLrVCQ8
 URBkgUl05EH1GEGK6fXD6W0ioLtujTcUfSEEpmPTXRFG/A9Q98qkWtuISesrEWcaL3zP2TRChId
 zN5sDjUPCV/BO6AtViXGhSZCgSXwevJQyotRjWxtq+WhGhQ+jlHEQSzGGmvxUHGsaAw+ZBpqpoq
 iRn+v1Uu5s+T3mF4+tbjBl1jfJgZ3w6OwulYGI7ZPhqa5mWZIFapgtKUe4BfbxrwxNjRAJxJP0D
 IUTbfOjKHupww38B7zCRVf9N901bzGDL0Od+53qaGxjmCgNtWVkITP0RPr8GIwuukqObvLlYu1R
 cn6gy60X1oT7+eC4+Vw==
X-Authority-Analysis: v=2.4 cv=aq+/yCZV c=1 sm=1 tr=0 ts=69c180d0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=p-bf5W-q-U8n-sQW_XwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZpIP-Z-RGHotr4SSxBtcescRG6hAUCDA
X-Proofpoint-GUID: ZpIP-Z-RGHotr4SSxBtcescRG6hAUCDA

On 23/03/2026 16:25, Benjamin Marzinski wrote:
>>> If the goal is to limit this to IMPLICT ALUA only, I was expecting that
>>> you could just leave the scsi_dh_alua code completely alone. If native
>>> scsi multipathing didn't disable the device handler, it seemed that this
>>> would basically just work. With the device handler attached,
>> We only get the scsi_dh_activate() -> alua_activate() call from dm-mpath.c,
>> and that callchain could not happen for native SCSI multipath. But, yes, we
>> do the alua_rtpg_queue() call from a rescan, but we should be checking if
>> the path is available first (and not rely on a rescan).
>>
>>> when the
>>> array updates the ALUA state, that should, at least I believe, trigger a
>>> unit attention that will fire off a RTPG command. That should update the
>>> sdev->access_state, which the multipath code could use to pick the
>>> correct path. Right? What am I missing here?
>>> Is this just a parallel
>>> exercise to overhaul the ALUA code?
>> The SCSI community would rather not see more usage for device handlers.
> I guess it depends on what you mean by using a device handler.

My meaning is anything in drivers/scsi/device_handler

> I don't
> think the Native SCSI multipath code would need to actively interface
> with the device handler code to support IMPLICIT ALUA. IIUC, looking at
> sdev->access_state should be enough to pick the correct path.

We also have the functionality from alua_check_sense() to consider.

> If that's
> right, then it doesn't really matter to the multipath code whether this
> is getting updated in scsi_dh_alua.c or scsi_alua.c. 
 > So refactoring the> scsi ALUA handling code seems orthogonal to the 
adding IMPLICIT ALUA
> support to the Native scsi multipathing code.

DH support is considered legacy. As I understand, DH was originally 
added for early explicit ALUA support and other DH-related standards, 
and explicit ALUA is considered flawed. So that is why Martin/Hannes 
doesn't want to see more users (for DH). This is my understanding.

Now I a need to try to separate out the ALUA parts we need from 
scsi_dh_alua.c into SCSI core code. I'll talk to Martin about this 
approach again.

Thanks,
John

