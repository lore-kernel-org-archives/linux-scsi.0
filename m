Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BF045BD41;
	Thu, 23 Jul 2026 11:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804626; cv=fail; b=eDKEgDIV1Or0ES9dmcivvmopzbEJEFMPJNLua80WWwa6LX61eLp3lZD4bG8nhgIvl3z6GmQCUGN1oWSu43THkn3Cn6Sqq1b21O82orwBmUDnJ0nWodHoltAGaGA/akysx6+V3Qt03GmXRgTMqtOf/+vk0MlLO+EzTFM+E7hMz3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804626; c=relaxed/simple;
	bh=96MgU+yaN7mM6o/eHqbcpA3GRnVXNNzPS1VJUwa8WgE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cC8SReJx2OfoBeuInr/V+tt7zlcp8MHMJ1dmXKwEoicSNgqWCJfOeZrDCYlzjgon2svFim9sIt8FDYUo5VGdboqnCuXohLMqJgWBC0sPjjx0LVR+2Wz8tm8xawZKkY+KSSjUy1FFunEDRlQdI5uPbCDUyUy9W78CoGYe4N0akEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FiAah8rA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qg1998Vj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FiAah8rA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qg1998Vj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtmga3353564;
	Thu, 23 Jul 2026 11:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/i/udIVkwg0wTnAmNIFpvB5vCxV3WH444o+Y4i16z4o=; b=
	FiAah8rARX0j0GYPnZXLEnc+sh8N+O6oD9lQLEy+gerElH9RJXvmD5CbocIA4EZZ
	Llqq6myYBf8S+lKYNc468YFStXdeOs2eLUcwEGj7oAAWJ0Wmpph6KRv+/RU56GI3
	h6H99NykzQOeNIrEYEEm2Kehk/rSQjxVpjEXtFtGq2xfT55mhtkiTyhHcbTedEpb
	f5CHFS4TNgkQUKHbUSUz8DM6Zezj2DFKuVNqAPYotxOI/8jjfP6UPGOJd372o1Jy
	vo5VJYqKHIc6ivj+bYmhTMwc1j4InhRTEYbw4k7riAzH5vPK/at8XqkDJX4zA38V
	YCAO+Tcx9V3LzspAJmdSDw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6pfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:03:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NB39i6005003;
	Thu, 23 Jul 2026 11:03:38 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxd7t2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:03:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/cviXrP7i5aE5XuhV7akwfcCglDnj/CpiGy9IiUvSkAMjlVac76YPnW+ZTZxu1ard1LYHaOsk7kv6qJQes1xq5lzdmImsp7QI1bdeAmSpOXaNhiwdFW3DlJmQywy3oVfa9AqI2H5S8FY2EtLw3oZAM/+6r1CNJc4woCzZjSz/lNsoanrDfXFcl+1vuO/g6fDsVvMsEBMAb7GEbDE1NmuGIhIjUmy9mUuJIBzy9WJ7QbiRiHyaZu/4Yh9gEz5h1YP1pVfBfbThZ5KhSVV1dy+kpFHs9g/gum7zwKQpZFn4QMA38MU6CEnIPh/vSmsN0yap79nNGWgSM+o7KHOu2jlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/i/udIVkwg0wTnAmNIFpvB5vCxV3WH444o+Y4i16z4o=;
 b=hkxHXt8ycOeI4uGIlsE+/Zb4iR3DkI5GPzpzs/GfAyDwqV1i2VHGMZRAUvpNl4SNuhxQQz+Ya5AuQVtfe+Y6U0jAetd71DN4wAV5kdXI/scgbhJ0Oigcw0hoxbv4LsWYvCpDlV0x41oupVwFW3RBj/QvM6Mze5SCStX/0reccBsnbcODfRaktpgt85GwUX/1XU/AKUlXPmyiwkdyDlSYrGkD9ctZkvFn3Gzvh4gtZk+4nMBP1Rgf4yBbfg/Yhrd9gpGh7Nt9z4djU3w0WiRvZLJmOM8PtAOHyNZEVazrwKtxePzAVZ7RS28VDK3awEfPOZLEFeW3N9lryZlAWOGNYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/i/udIVkwg0wTnAmNIFpvB5vCxV3WH444o+Y4i16z4o=;
 b=qg1998Vj0ozcciJaNVkN8VozkADJnOXF9UpZBzQmeUN9U0sU1pXhvpVu6nmXIbVcBTJ1lcL+NeiKWYJJ7NQKD2Oow/go5/QFznDZU7CqHoIS2f8IMQIdaho91TJ9yXhb0AdZNOwf4/5sxSL63eV3+0xLZ0HMYuP97GxHGAWwuHY=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by IA1PR10MB7486.namprd10.prod.outlook.com (2603:10b6:208:44e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 11:03:33 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:03:33 +0000
Message-ID: <c647b265-1a37-4e74-96c6-5d77adbb49e6@oracle.com>
Date: Thu, 23 Jul 2026 12:03:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 19/28] scsi-multipath: failover handling
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-20-john.g.garry@oracle.com>
 <20260723103620.816C81F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103620.816C81F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|IA1PR10MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: a473db1c-abb3-4ee1-c190-08dee8aa08c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|4143699003|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LD1hkkHiOAtG8O6NfqRYxsTQ5CB6XDpaV1hrVWLdvMSqhxifoyKx30AujXUlm10iPH9qPQS+qdXyk7fUFcZm6ah+KIvs7Tss8PSMDEjMfrAeYmK2FwY/iovRIbVZG46ibLtqblkxBz5Prt+xXI1XrjHtBgT/lbnbL9zucAEbk/7jcrQSCdA5CRR8BPqcnpxDGsx+13EVp1r6f2Tnobf+uaH4lKnkNy9PNeiEbbzqPKPoR4Qh8ip1X/iOTWxvQQGt5wSrQeJJDAP3njl3BggnhfNdYLCROHJRyz6gwh32hxSVhYinNoZ81jvrkpqOY0yDK2Bt5hTcPEOzvnB0+2o6bMW2D1zj+QVgZpDHN9LBock+6OmZ+KGlavpTPi8jLn7WC7FVLumrR5V5WZyY6IqVAfn/HNDLq5BiQedwNTWyYm1VvGvw9k8/92gDwilg2O7y9zS4h+SnDq3nzbTx5pqYtEeWMcLyJHLu4yi39SHRCrOShG5qM5bXOSvT+gnVzTnWcs+QCPxIPlA+y1ydn0Wd1yz13sDoC2EBqPfeVD7xB2Wnyc9Y8wD3TrlWfS7TdU4NLc3xOzi2WFsPA9Yoj/Eq1hAeNYqUTKQZBPpw2xg91gotkRZE9sgYi8c3bPkkWl8E6yav3QIh55qcFEj6AynSNWwa8F4DNXVZHpD2Zs77e7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(4143699003)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHNDNmdqNVJ5OVlTdU84ZUhObXVzTjBPRmovejNBVTlheFArM1JQSSsrNS8w?=
 =?utf-8?B?a3RRaGtUZEZZNUlqV2NOWGNqdlZGR2pPUE1GVm5PSGFnT0RLRWhOVWxIcVYx?=
 =?utf-8?B?Z0NESkNoa2RYWDRKTndjd0lNd1NsdjZjYjdnM0pyUDRsVVJ1RTdHTzd1a1J4?=
 =?utf-8?B?MUxLMENYSlQ3YjBNbFZRMFMrV3pLTFhvK2luSVl5K3ZSTTVYaVQwWmNZdExY?=
 =?utf-8?B?dmZXMXZxcERNUSszcUJJajNNTzdvcHE2WVhxZUNsSXgycHV5cUU1MlZaMVlp?=
 =?utf-8?B?VllIcjFCT0VzRk40a09VZ0ptdUU0bXJBMjMvbGxBNWlML0I2YnJOK3F3dHpW?=
 =?utf-8?B?TDk3Y3BSd1U4VThWaGp1Rk81amFBZUdkOGhwOHNHaGhJancxQXY0MHh4dnRO?=
 =?utf-8?B?SjJHdnBXMWlEcVdkQlZBNDIrZWZBdkthTDNLNXdQTmcwOG1BQ3puL2pPTXRw?=
 =?utf-8?B?Z21IMlh5TWlSNzFjUDhPcy9maXlQbTJiVDdNQzk4WThhM0xidWxTOXVjc2Rx?=
 =?utf-8?B?QWM4RXRKY0taWXRnWTdlcWkxVGI2eDFwL3Jxd05EQVpxclErUEE0V0dSSitS?=
 =?utf-8?B?Y0NLUXI0elc1cWdibGF6UXZVMXpYcGk3MndVb2xPSVU4cm9DbHhJUEJ6NHU5?=
 =?utf-8?B?MWc2dzdxMzZHR3VuaktpYmRGekdmRmI0M3hJSkZxbFJEZnJKSDNNZzl1MDE5?=
 =?utf-8?B?UW1xaTk0V3U0ZFVRUGEzT3hjNEtTVDhTUi9MT1NJSmJGcnRIQW9HSGxiZmM0?=
 =?utf-8?B?ZzBxVGlvMlNyOE9IdFdnTWNCT0llT2hRQU95Yy9UeEhZcVNLSWtJWUl5V2dZ?=
 =?utf-8?B?bTMxSDRiQUtZbW5VOGNZN29lYUxFTk84cVM4Z0pycG9ORzAyRFdtY2dwSktn?=
 =?utf-8?B?S1VveGVYNndma0d2ZS9Uc0t6OENiR0dqSUY5L2k1bm85eVFjM21sS0lsNUJi?=
 =?utf-8?B?ajNDNU9BS2FaR2g5Qk00bzRMODZFN0xBV0dvZERHdGQwTDdNZ2JXWGF6Y2Ns?=
 =?utf-8?B?OE5IblNPdS9vdDBjSWNmRHduN0xGRzhTOWhoZy9tTWtIT1YvNFFSbDNkZ1ZT?=
 =?utf-8?B?SjM1TlVDQnA4cEVrTjNOMy8vaE1qNUMwb2l6M0FFMlVIWktTSStLbjJmNGFV?=
 =?utf-8?B?ZWNpaDRKamhXeThyWUcycEdYSTREMWpNd0dNcmFVQXQ3L0lCN2dtbERSVkFK?=
 =?utf-8?B?bCt0TkU1em03ZFJGN2szMmxJSEFQZ0I5RWpVVVZUY1FTbFVST2xzcU9MOVEy?=
 =?utf-8?B?VFM1QkFFQnpmK2QyQjhUZWtSRHNNVjRuajVhMldLTXkvbnJRbWloK1BTUk1k?=
 =?utf-8?B?bkRodGFZdm1YTk50MFA2SW1UbmVpa2wrWEI0bWFrVU1nSHVRT2ZiRW1FVEpK?=
 =?utf-8?B?czM5RWxTSlFzRWwyU0d3Z0EyTXBIMkJEYWU3S25FTXo2OU9SWkpJcFU3SXI2?=
 =?utf-8?B?Vmh5ajJVMnFFcU45NXRPN2YwSDU0YTFQZlJQWVBoSUE0eHE1bjZCZlRrbFZY?=
 =?utf-8?B?cE5pTjYwZ3RWUTZnNmNRc0ZycWIxQWZWaDZQT212VDdaay82bSttOUlVRCth?=
 =?utf-8?B?MTIycTd6Z0gyZmpXWnBmaVJ0VS82ckFFaDgwRjYzVGhGUUk5WHVqSjY3ZWpK?=
 =?utf-8?B?Z095TC95VXJEYkYvY0JNL01ZSU5UanF6MmVRbzE4MHZBV3Q2amlwU1FtZWNF?=
 =?utf-8?B?Vk8xV0t4MitURUNhNnlpSzNhWURGekZvK0ZkNnhtZ2JHdER2N2x6L2pvaVdF?=
 =?utf-8?B?aG9ReTZiTnRWemVrazFzVDB4VkpBWU9oT3JyVFpKRUVvWkJjdktNTktPNktT?=
 =?utf-8?B?bjQ2ckxTOFJqQ1A4WFI1RXdwVmRaYkhvdk1salBIZ1hkNXlzTnN0Ni92M2Ro?=
 =?utf-8?B?bWZLYUlkR0MzQmFZTzNpOG93bGpLd0dIYi81eFdPcVVoaTlJV1VrcFdEWXll?=
 =?utf-8?B?bUNqaTdpS0dVUWMrQ1NnWkYzMDRXbHl1dlJMYXl1THdreVN6dngzc0o2MkxK?=
 =?utf-8?B?eG41d05WTktoM3VPM3FKeHZKYmxmRzVYUWxwOVpVV2lSdXFSRTNHZ1JUUDhV?=
 =?utf-8?B?RUxQTHVESEwxYzQ2RmFEREVnZWYrNTM1ak5xZW90T05EOVE4YUdkTGRnbnQ0?=
 =?utf-8?B?aEVVZnlhRDQrMktwMXhkVjZ1UEd2V3pRblZ3QWxZWjREelZIWWhTaUVlNWtR?=
 =?utf-8?B?cTZISzlISW5tdGF5WGdsbXFmNk00bHFMOEE1SGJtYnBPYVFTMGpGY2Frb1lP?=
 =?utf-8?B?VTdGSFFaYkh6dGxrdlZOa0g3MGdqVFdHSCthc1czYjBoajhEeGhMQ0hFMVZn?=
 =?utf-8?B?MVNaYTJoMkJDYTNCbytIT2JKRklRdXJrVzdPbGhHWlhCYXNFY0hWSDFUNzJV?=
 =?utf-8?Q?JAjdchTz3aMTDsRI=3D?=
X-Exchange-RoutingPolicyChecked:
	iKjSxtURvCh3RZ+kBmPL4qC1LUWFHvlCqF3VFLmUAENQDCLuF9MSC78pPpm9FChHHuv9S7TrgBB80jt4psjb1d1zmxt8lNjl7PvzcGpYGS3siatAtjE2C0Y4pdgWd0Hg346Siv+0gk2SLSXUIZzkhS311s9BPLXOE6TRoxGeAHiqltPpwiG7ai1YQL+BiJu0txoamgN1NvAxCVDeAJVBoI/stPrxoOU5ML0vq2CK9oQsRrTmPKLAJxaGjgNRMrlClBBBKijJFjsXloRP60bHs83BhLzzhIIl3oQxKqDgFsHZWgjZ2a7WRNq1M/LRCabh8CYxO4vSGSuwp99Z4I1ihQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PxhM+D1ZL6MWKSUyRbkF4reFEUryNmd8If+3OVUx6cc3ri2fRyhg7iZcm1C+C3q3YATf1aF4FT6l7539lPGOPYYOHjw1ZVOVqkCBGIAFBGXnJrTFiv7SDoIOJjJPiUZdOAU+AsHV3i7g7Qqrx/An8cr0WbRwxLuLmVo7yFaxcdCmJrJzQoB7CJhBtdXNe/64AZLmvM63pILxOuzq4DY6Wtz1Qtal9txe3oL37zrLLnJIUA7R2NOfDQQ8FTo63IQwI6oKTHPr5Z6pk5PGOQD445QTD69xEC6ernp+RQYjrITobVaMC2/3SKVdlPrGnfHK25t8qUdqVSVEfUpXMr2GVO2encWA3RFD5WvtnBi0FzcdSEPQVXJcowwUTWtH40tk6MKMdzEg02RGVn7czxrFEWZOockhtUCxWOlev6fbDGz1HtYlrI+40lxReXYeessT//FiwL0EQF0EztYlPkkF2BBmZ+nHJquAgN+TLGCGDUmpYBPTxQSgoir1919S2Pmsr7Ivay4fEfiZBXJsGsZ2IR31GfWpFC602X/f0CDB5rGR6vzIm6XpI7pzz6ed7nUUzvTbZ1mnpJBFs/u+TbxQANMWnkXR+pI4yzs3vbe1Mgw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a473db1c-abb3-4ee1-c190-08dee8aa08c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:03:32.9885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQSF94XWvswwzWIaV4BHNKhCR7tC7s79vFmoFCPlKXgxVyKlVB4ieJaoDqlg/20f6MvD1AT6Bd0ix2aRTd15Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230109
X-Proofpoint-GUID: qdHfKY8HHsdxS0pFTZgS4uUfyDy09Yyr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwOSBTYWx0ZWRfX1x1FfEalrbq1
 QztyUz2YhRvBxoWe5jdpqxyDNyEq4DqDipcBpbqBbuICGYGj9WnzJGc528TrXOO4YBqG+TwmPHq
 ZO6GHL9WtWc+xBwUuXpAfTXWohawwRiT9Ze5D3RN8eoOxKl3aTkl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwOSBTYWx0ZWRfXyY5gr9pLZRHs
 CkkwGxTVFW1FfHVgmvlos6nAqEMaK+03jCQ4nzU69JibMEcjx5ZDo5HusmSw6GosVuVN//pQsG+
 OScyGdDDXpBMUCTS5p+tXCtCXJFtrH6+Ke659rIIKWNOvbVciksrd0MYDwqZ1ND2/lltuUrG9vF
 dzZCy2z5Ch4snTNZvbeaTLjhfev8TO0qrltYYcNY4QLlEmUu9Bf76a8+drHcdBqfp49lMjFEsfg
 pnwWfYL3PNpKQI4x04FdtdGarov61evJD2RexHPcQdgt7GjKfhaupxjDPa9mAseNxl4mfo/FO4f
 Ld7O1VQkZAeSXn1Yw3x/hu7TuZHQtua9Jc9BKQ1oHyngAhMQFlTyj2O6ALD4ro/emW35mMkqOQi
 nE0kSwWae03MzVs1LqNTOSB6yZ0vp2nHldxYPljwOjUCGu6dOTADlp1yCmi92qhSA2nz5r/znEh
 edWVnhPVsHJLo5MNhLg==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61f50b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=gxEt_xq-nmEh6hZY-YAA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: qdHfKY8HHsdxS0pFTZgS4uUfyDy09Yyr

On 23/07/2026 11:36, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] Missing bi_next clearing in bio_list_add_clone() leads to corrupted bio requeue list.
> - [High] Releasing the SCSI device via scsi_device_put() causes a module reference count underflow due to mismatched API usage.
> - [High] Uninitialized mpath_device->mpath_head leads to a guaranteed NULL pointer dereference during failover.
> - [High] The scsi_mpath_clone_end_io handler dereferences mpath_head after it has been freed during path device removal.
> - [High] Missing cancel_work_sync() allows requeue_work to execute after scsi_mpath_head is freed.
> --
> 
> --- Patch [19]: [PATCH v4 19/28] scsi-multipath: failover handling ---
> commit e8daaaa500b47bda767344af0f467a56fa0a6095
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: failover handling
> 
> Failover occurs when the scsi_cmnd has failed and it is discovered that the
> target scsi_device has transport down. For a scsi command which suffers
> failover, requeue the master bio of each bio attached to its request.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index b896d28a7dd9a..a482b6ede21aa 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -248,11 +248,53 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>>                  mpath_synchronize(mpath_head);
>>   }
>>   
>> +static inline void bio_list_add_clone(struct bio_list *bl,
>> +				struct bio *clone)
>> +{
>> +	struct bio *master_bio = clone->bi_private;
>> +
>> +	if (bl->tail)
>> +		bl->tail->bi_next = master_bio;
>> +	else
>> +		bl->head = master_bio;
>> +	bl->tail = master_bio;
> 
> [Severity: High]
> Since master_bio is appended to the tail of the bio_list, shouldn't its
> bi_next pointer be explicitly cleared to null to properly terminate the
> singly-linked list?
> 
> When mpath_requeue_work() later iterates through the list, couldn't this
> cause it to follow a stale bi_next pointer past the end of the list?

will fix

> 
>> +	bio_put(clone);
>> +}
>> +
>>   static void scsi_mpath_clone_end_io(struct bio *clone)
>>   {
>>   	struct bio *master_bio = clone->bi_private;
>>   
>>   	master_bio->bi_status = clone->bi_status;
>> +
>> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
>> +		struct block_device *bi_bdev = clone->bi_bdev;
>> +		struct request_queue *q = bi_bdev->bd_queue;
>> +		struct scsi_device *sdev = scsi_device_from_queue(q);
>> +		struct scsi_mpath_device *scsi_mpath_dev;
>> +		struct mpath_device *mpath_device;
>> +		struct mpath_head *mpath_head;
>> +		unsigned long flags;
>> +
>> +		if (!sdev) {
>> +			master_bio->bi_status = clone->bi_status;
>> +			goto end_bio;
>> +		}
>> +
>> +		scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +		mpath_device = &scsi_mpath_dev->mpath_device;
>> +		mpath_head = mpath_device->mpath_head;
> 
> [Severity: High]
> Is mpath_device->mpath_head guaranteed to be initialized here?

same as 17/28

> 
> If scsi_mpath_dev_alloc() initializes scsi_mpath_dev with kzalloc but never
> assigns this pointer, wouldn't this cause a null pointer dereference when
> accessing requeue_lock below?
> 
> [Severity: High]
> Could an in-flight I/O completion racing with path removal extract a freed
> mpath_head here?
> 
> If scsi_mpath_remove_device() drops the reference to scsi_mpath_head and
> frees it, but sdev->scsi_mpath_dev remains valid, it seems this could lead
> to a use-after-free when accessing its requeue_lock.
> 
>> +
>> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
>> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
>> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
>> +
>> +		mpath_schedule_requeue_work(mpath_head);
> 
> [Severity: High]
> When we schedule this requeue work, is there a corresponding cancel_work_sync()
> during cleanup?

there is a flush in disk removal path

> 
> Looking at scsi_mpath_head_release(), it frees scsi_mpath_head without
> cancelling or flushing mpath_head->requeue_work. Could this allow a
> use-after-free if the background worker runs after the head is freed?
> 
>> +		scsi_device_put(sdev);
> 
> [Severity: High]
> Will this cause a module reference count underflow?
> 
> scsi_device_from_queue() only acquires a device reference via get_device(),
> but scsi_device_put() drops both the device and module reference. Should
> this use put_device(&sdev->sdev_gendev) instead?

will fix


> 
>> +		return;
>> +	}
>> +
>> +end_bio:
>>   	bio_put(clone);
>>   	bio_endio(master_bio);
>>   }
> 

