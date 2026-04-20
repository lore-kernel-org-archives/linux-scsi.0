Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33B12E8B71;
	Mon, 20 Apr 2026 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776687035; cv=fail; b=koLoX7zl/PvFWt4yp4EPW9YswqgPpA8jgb/szuQP/rwv+Loesc44qUBvYASx/ItGmRWTrIev9Hb40hDcr1sUiQQ+x0YE14eOI8/uXUfpD07OvgnykWaVYnGlBG/A140kMdPjPQBEA4bwn4pZCnOzSP0sf0uNlPmhqJlrvYHvLMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776687035; c=relaxed/simple;
	bh=NSuop8p3gmfTBMRqPipP6ly5WbFRBTrrwWQ3ZTRAwKE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i9nCw5uul0bNudWNjV5ga2PNQyp1ORwrCrvmg8kipRm5KtYZiuQLKC+77PuQ31QjZp4uLp+eIS+MRLCJn5E+k10QSkPgDQb0MznxGsuxmHmO4dEvvE4nDEJwQhrb1rCwc5gkDgx8iGYh+BlomEwHnV4mQLR4JUfFKOcdQDFLoCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T3KmJQb2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zY9VnVhj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T3KmJQb2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zY9VnVhj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K8QqdH702718;
	Mon, 20 Apr 2026 12:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kyEsA/rguYYWP1wHkHAaSwxQGHhWduLBOeRRcljB5Ko=; b=
	T3KmJQb2btf+OitDR2XNLva/x8F9vy2klNaL7rBvQGvKu1XkDpNQz8v9kfdBXnd5
	qYyqIvDp8gKHW9ElnCKZcC/wEezJeocJleha8bARPaHTTut0AAV0LGfeiTYF/2Fz
	WMi73gWc9kjoMRIne3LOrLFUgAIUIG0oBgYRCuFANeI6ts3374Hj7TJmcHjE2gsK
	Pr9NTfJW0IACWihoyjEo/Y0yhTFizmSkvs3Pq2NDAWFwkiv4L6w6rE3Gk5l4SK9x
	ysW8Tn1O3wGRO1VNSOkXnQkiV+TJ35SBJIN6XGIUZbvlD8O3YyUXLzpu1WJxqqMY
	de90nd1TNP0buu9StxCwfg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2a5u74c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:10:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63KC6pf0001087;
	Mon, 20 Apr 2026 12:10:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011042.outbound.protection.outlook.com [40.93.194.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dn19ejmhj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:10:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wAIUQnZm9PirczczwDC7OiI3GdZGxz2nq+kZJrCNQb5Y8NQr/7HYC3eWU2xnKtdp1homDwYE6OZPNSTtChRvoeiVBwV4ouAY1de4YA9jqMp+Om8KYq1KqAqTqCP8n9OQhWNhN4I9pFgp+hgWgPQhgr/0Qm5LxK4qCEeBfccn2kmHVJshAA8fotm0lZt/RBwCKNp7yyKxIFnIOrooFgczdCZua66WO1JyV0gOrdwIkjG5tb6J5J54/4oQptrFKrgE3ES5feCP2ZRJxoDglMquvCc02Xu0s6f37vMmnBp2Mwp60UtCkylOQF9GVVXsfiZqj292Imj9Wmwh50ftyo5Pxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyEsA/rguYYWP1wHkHAaSwxQGHhWduLBOeRRcljB5Ko=;
 b=OCXsrIm1vln/NdlXmp661f2sr9Yfr40qDQOhSgP8czs23k9xfEPDXQUpGOfaQD8NnkijHZXjQ4iNQvBqlPfMrMDIIswZ3epf7/c+kj9iC1kqfyViMfw7oW0cVs1nUxcqSS8xLRncVawunovZcfy2w9bKmMLQCIoLUUFHKuz5E8tfkfohd7FRMVsOXs8EuHupE/rEaivQUpUsLVO42/qzniTwSFwCw1Vx7/ZfXu1UGzMkwGxNJwVqeelP5FPTwSYweNOMKSSM+J/2kbIgpzajCAgZ905kYSKj2r9+vbfOYyxqO/lKLjgX44nBYjbckUE194mWWCUoS5urnQRurlv4qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyEsA/rguYYWP1wHkHAaSwxQGHhWduLBOeRRcljB5Ko=;
 b=zY9VnVhjANDIYBdLeScDzczzvVzZZTCoUTcN1x3vM1wZs0HvKqsxfk29YyTsUZXjpJccDC6EIuY3Tl48QGlxxS8Iov9AbYWvURacu6MEi3dl/z4nXE0kIjb90BNii2VrcGIzlIs8kRxtHzHXDU/wsgS+DG09aZmlSNUrJi2dHGI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4727.namprd10.prod.outlook.com
 (2603:10b6:510:3f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 12:10:27 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Mon, 20 Apr 2026
 12:10:27 +0000
Message-ID: <a27a04be-6c41-4d7f-b697-b04c4fe9dc8c@oracle.com>
Date: Mon, 20 Apr 2026 13:10:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: scan: allocate sdev and starget on the NUMA
 node of the host adapter
To: Sumit Saxena <sumit.saxena@broadcom.com>, martin.petersen@oracle.com,
        axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        James Rizzo <james.rizzo@broadcom.com>
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
 <20260420113846.1401374-2-sumit.saxena@broadcom.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260420113846.1401374-2-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0441.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: f67e4a1f-f675-488f-a522-08de9ed5ceb8
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 GNz0c7NnBatLLnEOpaAkWH6xhy5BTZeo5EkZb94Gnn46o7BhuT/Qan2FtkoacRTBwpZt8wO7yYI2Q9caEWLO6xKkrmlOctmwr5hhF88Ji/1YPCLvXMK6XfGf3z5Oc980mLzDwh7QdtpFLP4i4udnhtIGxAT6Uua1GzuNON+cT2Xr0QbvJ3B1ASXFdV3v2jWUgV22osTkNtYtWvyIxPGl2sczA+hRqX77SFWNiHDoiMcuI0Om50LBcbRV1Y9+aQaoeyv2H2HG4x3A4CT4NZrvVU9FAuUf4zKN2yct3bqG7PNS0IR1yHu09pzjWlfR88+waJvVBd1pNUbwJkpFB0f7Vu76Pcb0L5mp0JgTnTaZnB4Axz5Jz5GOazpshqreClvT2EgMWXVIKAh3hr6KX05aa2aXY4h7WK0P2LaqMxLNZNYF9Gb3Dv3foCCssOsIhi5rIpKbaCFoHitidUMtJwAh89lP2oAGOBnchDVs3M8bJDE77o5gN129Zwj2nz2VHPv4zK4t80EbwI5YW1CdenX5KLFcC98ZnRV6rQlSCCXnnZ9qnkTSJvIZZYkrDsz/YI0E4jiQMtD1sx9AEIEx8N/DDGGedUo5rHytxY+dL7vQedI8PZLBytVFnIvdxMZVDO7c5Mxs/aOABzc6TFKVxBqvC6WDpVOqMzqNaMoKi8sJjVh/nnRqKkIwGCNUEVsb1TVasMBLYK+h/4bRJhtU04bTkMKSKJhnIDhQQO/JTQjzkJE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?NVFmWTdmUDBybFEwckhhK2VXckVXUHoyT2o1Zm15M1hEeEhwYXJxVFQvNXYv?=
 =?utf-8?B?Z1Q2eDEwYzVsTmN1SHlLYjIyRnRPaFM5clVqdTN4RFlVcFJvb2tXR1Q1QU9t?=
 =?utf-8?B?a3o4TnBKcWFGUTBBcXFvQklpenZ3SHdjbGpKa0ZHNlVCbWxyZkxWdnpEUTJU?=
 =?utf-8?B?RWhpYnJJaUozc29uemxvUlVNdmdqbmIxaDRmYnM2b0RvVVhwVm5wVVRVeURn?=
 =?utf-8?B?NGZVenlFWHBXN29oUUVWUitkV1lQV1RCUk5QMERxM3JFSnY5YzIzQUFWQlRE?=
 =?utf-8?B?dy9ITkE1RG1CNThNS3N1bTRxMFg5dWlab3FrMXJwWFVZd0ZaQU9RMlp4MUJq?=
 =?utf-8?B?UDZkdE9XbUE3SVdXTnpZMVNyNGQ4cDBUL0sxOUxEc2phWERSWkFKa3J4d0tr?=
 =?utf-8?B?L0tzTFBDRmlzcFVOZWc0Q1NnWnE0UXZrU3VSdWRZb1NVNFRsWHpKZnlqeFE4?=
 =?utf-8?B?VEZtUmJNWThncmNpODh2RENCQjVwbGEyVDNpRGJ6NlJ1NXJROFN1RGFUZUFS?=
 =?utf-8?B?ZEc0aTFBcEhaQUlMbFpveFk4YVJSbll1TStjeFpIVFhsZHh1dk1FWDZzajNs?=
 =?utf-8?B?bTlLQUhJazFhYnFUb05WNVRoZkJ5Z0hrVUY0OHdRRDdIQndWenA4UlpCV0tZ?=
 =?utf-8?B?MnFzaW93bVZMVm91ZGI0dmhwUHBDRThpZUpGV21WaDhOSFAvbktxYVFNMjFW?=
 =?utf-8?B?QUFWV2J4Uks2TzRiRHJSMzZkRnpWd0FoOEFQNVFtK2hldXVVbDRkMjNvaVFh?=
 =?utf-8?B?cTVua0lOelRldzBIb3lzN2Y2VURIZzhDWEpXRTRoRzFuR1U5S1VyZW1Bb3dW?=
 =?utf-8?B?UkcrV1hGZ2h1TGtWQ1VYVVlyTEhkUjhoVVltc2taSE9UdlQyVXpYZEpjOGhR?=
 =?utf-8?B?WnFjUHluRGQrdUJOOE5TQ2hwSmJBa1V0T3QyKzN2MjViRzQ3dkprL2lWc29s?=
 =?utf-8?B?QnV2Y1VzQmlWM1pUZmgvZEZzNXUyV3hVUlhweU01RmVmUWNvbXhRWHpkQVFT?=
 =?utf-8?B?YnJGOE1pQjNQbGJDYWZSamo5OWxFL1hVVDlkQWwrbjNVclFWeS8zTlYwMzFS?=
 =?utf-8?B?NUxYNWxEZUFaVUFXQkw0UGVrVmQrSmpFZk40dmdDVkhuQVpQT05PcHNSY0R1?=
 =?utf-8?B?Y005Q3hOZUZyWDVHell3T1AydWRWSFIxZFlhdjdTZ0YycDBjNjFQQlVNbWZs?=
 =?utf-8?B?OW02bzNnRzJEYStQdjZtbXMxb041OWJKcVFlTGR3LzQrYkJRdFNFRzM2SHhx?=
 =?utf-8?B?WDZ4UXpla2V1NnNCMTBGV1pONUtMdHdIN3VlQXowTHZENFI2ZTRFQ0N0c2Fz?=
 =?utf-8?B?WC8rcDJnU3hmSko4ZmlSdGpCMXRJNmZrNkh2V29CWFhDVzNyenp4cGFkTktO?=
 =?utf-8?B?WUprclhVdHkxQys3N2lZZmpwNHlVTVB0TkNUYzBmYWYvUWZ4L04zT0gyRzNO?=
 =?utf-8?B?VnVLbEM4b0duZXk0YWhGNHVIZXhtdGN1Z2wrSlFQVXB3aUxPVnE2aVlVMFZX?=
 =?utf-8?B?ekFOa3dxMFZHd2c3YzNhRE4vNzNmOFFmRWxQdlZ2TEUxQU44SlpUMUJEVmdJ?=
 =?utf-8?B?TDhlM1NEd0NXUm1jZUVvSTU3UHN3WDVNKzlqb0hKOVR5bjJPSXRrdlVWWExz?=
 =?utf-8?B?MWNhd1FiQUx1TUxMWEU1OFVMKytBY2RNQUlHZmd6TGRQRXFVYko5RlFFbS83?=
 =?utf-8?B?OUxNejZVeHZyMkx6ckI3ZHNxRmJobDhqdmdIRzFGME9IOUdFMDVVVmFKUjFL?=
 =?utf-8?B?TjkwSVIyM1JEYUJrNnJxZ0JJcVpJRlJCL1RpNitSZVhwN0crbzN6czlsVmd1?=
 =?utf-8?B?V2xsYWVQcHZqZzZwOEM1N1R1UVhueGk4ZWl6czZvZDQ3UndpaGJJQlBhejBu?=
 =?utf-8?B?QjlodElhQjRuZFZ5S1d5cDB6eTNYUVFPNTZWd2IxT29tZHJmektjd2tTSHZ3?=
 =?utf-8?B?U05NMTVxamZNSGsrWFBGWEVRS0FVdnkxZWJwVjZEQ0QvdlRFSm1BUE92TnRy?=
 =?utf-8?B?MWc0WjRGU1RIc1ZDVVlpYXhJY0d6bUZ1VDdxUnJCMVN0Q2VwUjk5Qzl4L1JT?=
 =?utf-8?B?ZURNU3UvUTBVYUhsUGRnWWRZOE8zNGVHU2M4N09PRmhybmZ4cUJIUHorMkxI?=
 =?utf-8?B?NnduSEZwVWZ5a1lKOGhJM2dUWVhQOEJzSUVuNi9BMkltUGdSTnJGVTBsb2lS?=
 =?utf-8?B?WjJJM1FPREg1UGwxVmFOMmNoV1AyL3QvQ1R3bWs3djZGV213TW1wQzMwNUFD?=
 =?utf-8?B?WXdDOUp2QVpTV3JCWG9sR1NxSGE3MVFOWmVTL1J2cWhSL2ZzRkhkTk5LZVJn?=
 =?utf-8?B?N2kzcHBKL0dVaEtJWFNFRkJqS3gwNzlucW15R3R5SmR0OVp4REh3QT09?=
X-Exchange-RoutingPolicyChecked:
	qmWOWRt0giQJJAjoLJAqTpiepDdzaichPs7K/D0Ky4sP5+2Sc6KCD6LlFZ9vHNjoKK21agP/ZBqUTWl66SXTjFsnSvFuDBWaH+cSJIHgFNlBfvV8mEdKVmqJ1zWoW2NLomUKc4T/o3j8SCJby4FnloBc2Rl3ciJT1J3KcY0jN9pQLcyybNzjJ7X6n2EdYs3ErOD+Qxu+GVIRmZ0FE+EHVXduqw/szDOzHwzrWpDp3Qdg7Y80S+KoLe4McCXVICJZQGeBcJTAAb/4nFrcqKTwK0bTzQ7lNtLRWOduUKhbGhHFcj2x1rkbLOjbUqwro+3OsLOzsYM1WVgMlZiXNERi7g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	re8iM6wR9u22mmXpTMBo4PeWSZGNqFLb9HjcreF7tBvbH+DRsfy5zuX9cq9edvlLkHGsVcRP3S7HA85GrWDy5z6hBaCP66eAOfa3rsLmwSlVQh8yN+Pl2Z58Xma6BtRNo5h5Ur77iskfxVy42VRlCAlW+jvWMSA6UyW4uCby10AS2hN6qswa7c83Jl2yJudgLPCvpXiSV6KNah37IPXFmmMnqsKL9+OVtN8NYxX1a2DhjZ1UneXUm54qVoNmn+Rd1lzecmGB9ElgyhV10L1/IgYrYrz4oMQZQjZDDopzk6TR6nShCU7Ahc/mAjfvQmxAyXPzkX4AGLvGu9KlFEIJSiFvsGT6IWJ+1y2iUKVRYOxyHptEIJWC9ktON+d9dlet5BDPFB3fW7r/jcbKn85vXftbNKSxi7+WTNO6yvzjjucKEKbhCk+YnYY6qbnWD+uUn9R3soEWrGhbN97wavT9+FyUSUIRDEevhWqB6oJnN1RBeF+MMuAppQyAgpk47A8l5LNusgq7fOFd8KNsQ30KxLbZtrZXnIc5dzeLX7CnnfjxAsajsUMXf3+VRdX8Odaz9pApSC0U1omkGpr/gjTwOhIlM9RNO7aY7m4DvLrnNW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67e4a1f-f675-488f-a522-08de9ed5ceb8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 12:10:27.0007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +T18xk4EunMWRFpAVyvheyqWQiIbgzcAhtCa5J9pFHXZQM/18QR5gcfo1s97Es2RkdTLp3zWWkOuW05cCMGgFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604200118
X-Authority-Analysis: v=2.4 cv=U46iy+ru c=1 sm=1 tr=0 ts=69e617b7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=Q-fNiiVtAAAA:8
 a=C2zfXlNybLjEwdOSzakA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12292
X-Proofpoint-ORIG-GUID: KKh7v868trWvl9wALChRAB4yKNbddFre
X-Proofpoint-GUID: KKh7v868trWvl9wALChRAB4yKNbddFre
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDExNyBTYWx0ZWRfX2lMigs+9d6YV
 gkN5YgdQBTg1v7AsVoudx3N5N48DTW4X1z2QcTCgh1Q/w1Yp+SRfR4Tb2vBqiQ/ath22NYPW7Ka
 lUkGI/weupBAAMlA5xby5Mw2IaI6hVYZb5+b3uiAaw59lunQlsdbeHozOtu4DkNtjwagqN6kuLN
 KB0uYNz8Bhe46YQL8rEJTdh9Vy8j2fYoSrjSLLHwsVEK+MKopK9aLOZQ2flfu2/+IzWt9dOHPoB
 cG4LP2a5DHtt8YfKB86cR/v4y3pOmcXjFgx5CgN3a4sx5ygnYGMolOrmtTRWigVLRiB26OrcdOP
 UIy186ia+1cyHlTKMlL4RqDhpIxQgpmmb9zwsWhELOGDruEmsOhVgCqcXlXILTlKIP27AZF73M9
 2NLPv1PqIEbIMmVaSq2fSTFApBsQfwx2jtd1Q6QWeba4tOcALj3HYRdPiNpddNNR7GAkvsxlJwU
 +F3k+9UiXYcbA7cJOFiBzT4KkIvQTSG+LdcRNNLE=

On 20/04/2026 12:38, Sumit Saxena wrote:
> From: James Rizzo <james.rizzo@broadcom.com>
> 
> When a host adapter is attached to a specific NUMA node, allocating
> scsi_device and scsi_target via kzalloc() may place them on a remote
> node.  All hot-path I/O accesses to these structures then cross the NUMA
> interconnect, adding latency and consuming inter-node bandwidth.
> 
> Use kzalloc_node() with dev_to_node(shost->dma_dev) so allocations land
> on the same node as the HBA, reducing cross-node traffic and improving
> I/O performance on NUMA systems.

I suppose that this makes sense. We already do this sort of thing in 
scsi_mq_setup_tags() (in setting numa node) and 
scsi_realloc_sdev_budget_map() -> 
sbitmap_init_node(sdev->request_queue->numa_node)

For the actual shost allocation, we still use kzalloc() in 
scsi_host_alloc(). However, shost associated device is often a pci 
device, and we probe pci devices in the same NUMA node it exists, and we 
try NUMA local allocations by default, so nothing is needed to change 
for the shost allocation - is this right?

> 
> Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/scsi_scan.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index ef22a4228b85..9749a8dbe964 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -34,6 +34,7 @@
>   #include <linux/kthread.h>
>   #include <linux/spinlock.h>
>   #include <linux/async.h>
> +#include <linux/topology.h>f
>   #include <linux/slab.h>
>   #include <linux/unaligned.h>
>   
> @@ -286,9 +287,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   	int display_failure_msg = 1, ret;
>   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>   	struct queue_limits lim;
> +	int node = dev_to_node(shost->dma_dev);

this variable is only used once, so we can use 
dev_to_node(shost->dma_dev) directly

>   
> -	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
> -		       GFP_KERNEL);
> +	sdev = kzalloc_node(sizeof(*sdev) + shost->transportt->device_size,
> +		       GFP_KERNEL, node);
>   	if (!sdev)
>   		goto out;
>   
> @@ -501,8 +503,9 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>   	struct scsi_target *starget;
>   	struct scsi_target *found_target;
>   	int error, ref_got;
> +	int node = dev_to_node(shost->dma_dev);

same as above

>   
> -	starget = kzalloc(size, GFP_KERNEL);
> +	starget = kzalloc_node(size, GFP_KERNEL, node);
>   	if (!starget) {
>   		printk(KERN_ERR "%s: allocation failure\n", __func__);
>   		return NULL;

