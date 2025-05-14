Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EDE272E4A;
	Wed, 14 May 2025 10:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747219679; cv=fail; b=tS/bqPb8f+rNS2w7ZpkG431tgjXnU0rKqGzmuPzmAg4bgNfiyZ+tGnZhRzOgUizBcMYxe7sjHvq5rs7mtTpSJfBhjiJUhf7cJTNSHs4+SLb5JT3cSqaMxLLtkntS8lhxax4e315cO6lYfQ1CN64zwros2xb+wLeMlNI9gNMuq/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747219679; c=relaxed/simple;
	bh=UfDJeg3fLcahYnfWg+17sGstDGVFHGhiR5Fm1134L1k=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nGN67mzsGI1R/F1qnIGbP8wxTUWOJcCsoghLizBn54/IXyN0BhF4DeasbnF2EzRh4T0fPvdClh8edSF/eBKC1Y3GHKbmyf9ZtLp+iYhjCDC1rNNsJQVDGiHRbk/I31USBB/z5OpoWnIVNgLpE8fQZaFyyXNw8JhJI2YfhMUEQ1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gYeWvHau; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ItANo0or; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gYeWvHau";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ItANo0or"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0fre1020272;
	Wed, 14 May 2025 10:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Eq/8XBfv7pfAKsKT2xkJy9E/J9pwd+jLgyt+/snvHa4=; b=
	gYeWvHauHnBO42Qsg/Msl/ypuW9PryVeH+/NYgFjV2tQc0xdhC1JQFzLZ263DB26
	UCdiIrxLSPCfJLbV9JE/cAFKNfA+3s23Jc6Irbzwz+1y7cUa8bQqlKQSTHg4fdon
	1HxdZqSm/WfGQ87MFH2twAqmeMhMepPFGS68KVrUN6qInF9IqNYkgQGjuvahlgj/
	FuMts3S80+sldRBc2ye7za+qquzjjJ/z5vai+ir7B7FXamtEZ7iqqR7LpBD+XKiQ
	NdXCENAx9kJELG90R9739DZ2O0pbJZniBkSP0J0bJSYtwK2kXjRalNZxcp7OJf2A
	TNi4ibox2b/sQGGTOBBpoA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcds9nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:47:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E9SD3E016163;
	Wed, 14 May 2025 10:47:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc338rth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:47:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wNDZ36h8+3J1fLbWfz4Y8rh7YlV1gLpuXIss2BHY3RI4ndq+te7LZGOzvmgPhpC7xIjW4WKz9l2yNxFe9fUuqH/5SsZA7FRCd1p0bRNR9NKuwA3PerzQe4XeEqbSk6FydDJO/JwLCQ0/OIHvqj9J9tJWFMCkBRTs+bshxYrYHjXHdu0uLNYot8xDV/zj6DvC0nqaSlIDNLHon/s6pEl+dXE5iIHBF11URFxRFvIKE+jhuRdVts3Wf99sw1uEtGj5nD8pxvLAaCCsOmu95gLh0EzkiLVUAyxFAN86w61AqCVtRsLdXCQvAQQI7AGegg9RO07euWH2ath/3jCJFDB12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eq/8XBfv7pfAKsKT2xkJy9E/J9pwd+jLgyt+/snvHa4=;
 b=uuzwpBoMtz/dGrktyzJ6KCXYoD2g1z2hAb2ivjxVwV0fQpyBwliGLTeZ0h9MEAbvjOJ8ZzK9rIF9waDbtKl8+QsJJO0dQXe7D/Yy7CsIzbHerIQ6Nanz4BQkhUiV7NxahijnS6HSENazYirpW99FBsRpeYb2dMCXGr1FsIn+NGxSluR4rvDyguUUDZ+Vf0m/lW24k0lUxf6r7YkkxF8mIt7iRDQlB68C9KKpZKuInEW8joRMm8+wdwAdhZuBy/zd5G5KAKGWvPfb61FlEiFFLd8A/4Ry7WLfx8G08ic03e2e2Rc+5J9exFf3iaRwDtA1AkcJCDDHTuax9JF3LRXtSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq/8XBfv7pfAKsKT2xkJy9E/J9pwd+jLgyt+/snvHa4=;
 b=ItANo0orpnmKGZReb6bBIz0RHtK6fxyGrl20/RFUi6sdtLIrbVwug4QQ69LXNB8iMRaRIEILH75kR0aj0Vjp9m+SkR0WNSqdrTmfNhkIEIJ3pNp88QKIj1I3R97HFmClgYpjZOP/ffeVqKUYTTbmnGXp3UglGNw7A4+ndqzvaec=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6920.namprd10.prod.outlook.com (2603:10b6:8:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 10:47:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:47:53 +0000
Message-ID: <7a756a07-b70a-45cb-83f7-3126ca22e1eb@oracle.com>
Date: Wed, 14 May 2025 11:47:49 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-5-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241008020437.78788-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0026.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c36768-3719-4522-241a-08dd92d4c749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dS9tSnAzUHY2RVV1N0U1TUJ3eTJUWWZmNEpPSEgzdUUzZzFBTXpzRkZNOUUw?=
 =?utf-8?B?VUN0aFRNM2pLMjllQU5BREFVSHpRZDhEaUJ2R002eWU3NzFpK211TUlDTmNa?=
 =?utf-8?B?SHJ3N0Y0bnZ2aFhScHNSeklyN2tKK3ZqRGVKRVE1NVpTVWgydmRUbzN4TEZq?=
 =?utf-8?B?OVpKd2d4ZVp1L1BBZVR1NFRjZlRxTGRnN0gzaUxjTVlIZUxVSUo1U0hrLzMv?=
 =?utf-8?B?T1RJU25xQkdWNFBYT2tvMWJaQ1ZHRnd2ZkYvWS94TWErVnZMMXlXTGdHMkxo?=
 =?utf-8?B?Y1MzaDg5NHlRN2JybXpzbG1lWlJCUllRQ1ljVVhwdzlLcHhUOHN6bUVZczBo?=
 =?utf-8?B?djN6dFFJbVFOL1JJcDdaTjFrZWc2Skk3WEo5Ujk5dXNoeXZVa0QxNGxoSDBI?=
 =?utf-8?B?MnBmNHBnTkM2NElmQ3ZOOEhqdlNrR3RLTGxHYWNYOUZUeHhSVjhINE0vZGpl?=
 =?utf-8?B?dEZSQmJUVks5UThoWjhvN2pDclpHd29PUFVycHZBSUdYbjJ3ZVdpbHNHRHpY?=
 =?utf-8?B?Rnc1WVZsN1Mxb24ya0IreU4vQnoxd2NZV0kzYjZONDM5NGtJa0YzSGtMeTh1?=
 =?utf-8?B?RjBEZVFsTGVxbnNRUk1SenBwSTByZ2JvVW9Ma0MxSVZEbmlLamZLNFZHMEl2?=
 =?utf-8?B?YVg1cHhMdjhocnlnNXk1SmE5dXJZa0JSMUp2ZUxEcmFic1hMTER4bHY3aUlU?=
 =?utf-8?B?akJsd1lmNVNsUTd3c2pXN0JsNFV1VkY1T0ZwVjlLWG9jY0x2RTRhNFFvdmVn?=
 =?utf-8?B?cTh2WVJJRC85ODJ6WlB3NU55VUNacE5wdk51Y2xCR2tvZSs2emdJSE95cnJ5?=
 =?utf-8?B?L3VubCs1RlFQaEt0bmpjWENqSWYxWjZ2M0tMSFFKYlJzOUpGQklseWx6M09o?=
 =?utf-8?B?NG4vdEpOMGZldEw3Y2ZFSWh4dUJKSHIvTzk3dVJOQk9yNXBKYUlGRTlzRVhi?=
 =?utf-8?B?QVdaSTRNVGlSYW0xSnFmM2xOWjMvZTV2TjhrbElIOHFlejFaVDNWOU1ITFZx?=
 =?utf-8?B?S2dBeTZ4OFlRUW03UFErd2hkVVhPUk8vQllzK0NxVW81TVBHMUZnRzZ3Ujkr?=
 =?utf-8?B?WktuNUlkci9tQS9BYTZzMW5CSGtSSyt5bEJWTzI1M2MySEpNeklEdW1tSHdD?=
 =?utf-8?B?N1FISjJWME4xcUFGMWVJUENPVGx3TWkxWEhiZzZWVGxVM3YyZUNMcXBBSS93?=
 =?utf-8?B?NkxyYUdhK2IrOXpqYS8yeDh5bVZZdVhncDlBRmJxc3J1WHFMQlBZMFBia1lw?=
 =?utf-8?B?WlBzQmdVQ0wyWXVpMllKbWwxdGcvVWtvRThaOUZMa3dESjRRZmxia2gzS3lB?=
 =?utf-8?B?YktwWG5wZTZMQlBYMDdZc2xOSktBQ0ROaytQWmVnSVNRNTRNVWh0Z3VkV3RT?=
 =?utf-8?B?ZDA1VEdwZjYrSzdnYUxFOTIrQXdsdnI1ZzFxM2ZkMzhXZ1pQd3hBSml3RHBF?=
 =?utf-8?B?WWN6blhQM2hRK2JKY05rT1NZc1dDQWREL01aVVRNZ3lNaGFMUDh5bzEvUmU0?=
 =?utf-8?B?Q1UzSlFLb21SVDRQNys2UTFWZGRRSWRBMnV5U1BrT3Z0Y2x6dGxPOWQ3K0JZ?=
 =?utf-8?B?b1lzcXhrakgwTTRjVlRIYU9YQm1qZjArVzRjcUdjNytOUFNodGMraU1INzhn?=
 =?utf-8?B?anFjQTBwKy94Smd5ZDg5Y1FMcHQ4a0trMmlpK1V3RWdnendEUnJoUjZIRTRY?=
 =?utf-8?B?TG1DUEhXSjNGTGZMRGk2aEdibU9HRWp1OEdVTlZ5amRWZkFaVitVTEI2YmVE?=
 =?utf-8?B?K1FLSGR4cUdKbk9CZUEwbGU1N3hMWFJ1U01XMVZMbFRYeFJ0U2JCTjN6S0xK?=
 =?utf-8?B?RFdDeFVTaDFDODMxNWQ4eUtIN3dNMWJrcVlLNFltU1VlREtTR1BqRlFUNjZM?=
 =?utf-8?B?SUF0cW9vWjBCTUM1QU0xS2FxbWFGbkNVWDQ0czhYVlJNQndWYW53eGJLZDlC?=
 =?utf-8?Q?OwtIL9I/6vQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkdjdU5sNURxVjVRalJFdERtem1leUFLamgyV08wczVyYStJM2VRUkxxaHJT?=
 =?utf-8?B?eUQrdnFPUXY4ZXdrQy9lTFFWY09YNFBaVnE1WnpLSG13YkRlNUJBVllNSEIx?=
 =?utf-8?B?RTlIa0ZJSmltVUxSS1lxNkxSdFU5SmlkNWtacTFIOG5MMEpycWk1MXF0bXFi?=
 =?utf-8?B?aFMrSFFNRStWVE5lTkVLYWp4ZXZFcEpsR3JhUUxYdXBodkNjQnp2YnRhMXdP?=
 =?utf-8?B?RjR0emNZYUxHcFlqdmZjdEFqZlFrMWkwa3p1emR5MFVXMkJUcGhNZzBXaHZQ?=
 =?utf-8?B?RHp0SENTd3JDd2ljUW1yUC9FdWFUcUwvb3VBaVB2WlEvenVLTStxSGdGNWJk?=
 =?utf-8?B?eWNzejE3SGlIMTZQSGptQ1hHWTBxdWRkZ0xtTGVhY2t4dEtWQXJvVWpCZjVo?=
 =?utf-8?B?VDd6eDJZTHJJNitVelpoelJIV0FHV3ZMS0pobVdjMVlscGh3WmQwQnJjUjZs?=
 =?utf-8?B?cDFuTjRRVXlXZXRxVm5UZWFlSDhPRnFGck5ES0NyWFdVQUtHMFEzdlVlS1kw?=
 =?utf-8?B?bnBqMTJuMDdJTUtHYVFmR2lrd0ZsUTg3T1BtbU44ZUFQWU1Vd2huekVIcDdo?=
 =?utf-8?B?R2d2Y09KRGl4N0R2WklnTUlwVTRQdXE4TktmVXlKTjJuaEZOeVIyaVFQY01i?=
 =?utf-8?B?REx1THhMblZzeW01YnJrSmJnNlZITnRKUTA0SHBUMTNsUW1EMitSSElGYzhX?=
 =?utf-8?B?YWRPam8zSmdGUHdLTk1ZUzh0anljM084M1dkcU9pM2ttRENTdnFtdERpbXZM?=
 =?utf-8?B?aXN2TEdrWS9sbkVsSWNRNkpKVklzbHhqaFg2Q2ZRYVRZbUtBSlA1VjgvdFVK?=
 =?utf-8?B?U1QrZTJlb2RGdU42S1NNZkE4MjlmcjlUaFQrdDFWUEF2RU81QW8wWTliR0oy?=
 =?utf-8?B?a2VVdkM5N2tnK09EZ1dsOGhtMklKVUM3RGlZWWprWTRDb25VRGc1b2gxVjRY?=
 =?utf-8?B?RFcvUDFzQk96ZVlGOFRHR29GUGh1SDF1d0NEUGEzenkwbGpFaXVNNXFnRHIy?=
 =?utf-8?B?QnZaa0pqTGIvdjliMThuMEN0RHEvZTlJekhEb1NVV3I1dnBFTCt5aG1sekJ4?=
 =?utf-8?B?dytXWkMyNTkwTEJEcVRodW9rTGNZcWFGRTE2MmlUWmRPOVhrc2toTjZ1ZFJa?=
 =?utf-8?B?TEgvYXE2SWtOQ2pES1QwUDAwMDZVeG9yZlIvcjZVOHBFZ0RKV0M0RzFaVG1v?=
 =?utf-8?B?Sit3MEt0WVE2eENKUm5IL1VOUWx0UkdRSUp6anAwQVZTb1VlUGpLOEFiVVp1?=
 =?utf-8?B?QlVJV0lJVytCLzY0cmtpcEt1UlZ1ekNra3BkNU5RSWVQeTFhM0xqOHhBcElG?=
 =?utf-8?B?T0Zhbjc0bE9YUWxjTnBMeFYzSHQzVW11OW0wRi81c21ncjNkcWFWR01jVDNX?=
 =?utf-8?B?eXdQZUZqM1o2eFZ3dW84OGFuQXdwaHZnRlB0b2h4REFlcmphcWQ1MllsQWhQ?=
 =?utf-8?B?SlJmYWNDVi9yUHZGMUNlSzRoaFVreHprbkEwbVpPZEJWcEtuWk9wMHlha25x?=
 =?utf-8?B?M2lwaXh5cmJMd1lKOWJPMzh6NDJtcllsVG5Dd1ozZjhwV0grNWZBQzgwNXFq?=
 =?utf-8?B?SGpJT05SbERIK2xBYmZzemFxdXFJc28wTWN5cEhjVjNTSm8wY3NTZ2R3L1p6?=
 =?utf-8?B?K2Fpb1FUWXJTVHo5c1RwS1JhQS9uc1RZRE5zWFZJMnh2UU9lQ2R2ZUorWWx3?=
 =?utf-8?B?emRkU21jTWVQZWdScnN6dENpV1RvajBRWWhhdFFsRU83Q0pnSFBiVkZnTzln?=
 =?utf-8?B?ejBoTCtJS3R1cEVqUlFrcTVjTEljZCtQbWloOEFhSWRYQ2FjbFlaem1ycXdy?=
 =?utf-8?B?d1oxSElYdUhlZXJSTWdGdXJZUUJaT3puTlFCV3R2QzA4U0k0OXg1UkJwZ1Vl?=
 =?utf-8?B?aFVvTGFUc29qKzFycDRPOU5wK2RkUUJtRnhob1BXYXE3Z1JEcjY4UEpzc005?=
 =?utf-8?B?RWtIMUhuaUJ4T1NSd240ZjIyMk9nVWcwWEVqWXcxb1RPcXpIOVFCcEVnZ0dL?=
 =?utf-8?B?UDJnY2JJTnkyK0NsT0VuR3l0YWwwdERyQ21nZDRXcy9KTWFTU25TWnVKWEd1?=
 =?utf-8?B?cmxZUHlpeERSeFZ4RXlFYS9Ec2p0dFIwQWRvTlFFWEtDaTkyZ1dxdlcvZzNs?=
 =?utf-8?B?UnpKS1dOTW1mS2dQVmlCSk0wTExRZlhma255ZzBUL1FGWTVJNDk0T2JTcDBx?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	11ooWVy8Z1VODnLMRTrS181FTxciF7UbubrjCWYoypGHgUDVYT3II+4eYYpCAn1sH0xtfhDljEmoSkU+8+ntoQ/XgABF3qxYs71TR83XCzTYViY0MQVuJeJjGAMtc9uN6vTG/xH+w6zSdP41mZhOoNX7tbtVboXEiRMlxin9yCmHklnX+d7pmNHNPRWAh1lsAxw5BIWANKAtFji2EP5efonu3sVSjr8e3Bd4zlrBsDrmSm90iQy1KRqZx33F+55YeSPfgAebDraISVSsIPkatVXe5D74GK4kAeKf5h8rdIxLsPiraozyrJeRrgXgxIEpEp7aMvm10NnGMsf8dBhINOJtrEBznu6bkJQbVs1fuOhTSIwHuFs8AQzhbIyCcHgCCjLIrSdMOs5cKm9g4rx238XDsx31NXhZS0GJ2PjpoWCM/+X45KAqZmwYGjJlxXd0ydAWFxU6l+qbmo5oAjU4ZOC3hQBSUSKmmxwdZOCZygT8vvZJWU03LecYVkzWs6/P4CYSFmjT285/i5HbG8pexJw25481xeYz29m32TQ8LaEIhZYCxqJ8XbeKJA75H5KcQq36CXxg6bvwd2jjZ5/GKMjDcLKC/EucLeC0Rs7BoBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c36768-3719-4522-241a-08dd92d4c749
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 10:47:53.3342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bjayk64LxzD/HHUPgr9xeK3J7qkAJXPysFq1MbwQb45NcMdLviPinQyXVGgRdPb9ijKKDOWcSPgi2D5IbGhIFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_03,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA5NCBTYWx0ZWRfX93X3xssPephZ b2YjC0npY/aa7LfOmAX9H/fb0Zp95Gocllt5vfzgBIo956jn2LVC/wksF9vAVVdRf4u2l2uyZNW hh7Y/i6/6PxhDutib+PxZ/QLziSThNk3A4dHFQQDfFIi5+rjGVDsAylwsR60hL7LpcGJyZCYsHu
 F/R2wmSoRTiDM/++Hn2E0Y9eghRY/oCvdgTWFJ7+dinLwXAT/GlFTTjgakIka3Bx6PTsgOk0Qhp NmfuT+npaZUaOhQkiWFPrXpOFsmo6BcnZaAeIjaxXsU3qRmvOhS815mkqWJJ9VUkwXJ3IvzKaPf l9dEri36VyXDKnyz4mFVYa+HTD0q8O1A4BhcCkN5m9AZ+EtaxMQ94djbIiidsa+XQgUQ20RB1+h
 pO8M+JYR3HTNjbDTswW6tSgSCLjmHVw0OoKq8TKSkybqxBGtKP9SDVpBRQEvhjgWTapbP0dd
X-Authority-Analysis: v=2.4 cv=Y8T4sgeN c=1 sm=1 tr=0 ts=682474dc b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=itErcG_SQMq79rPpW1YA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13186
X-Proofpoint-GUID: n0Z6gOGVef-kl4grdPjx5D1397lxoYz-
X-Proofpoint-ORIG-GUID: n0Z6gOGVef-kl4grdPjx5D1397lxoYz-

On 08/10/2024 03:03, Mike Christie wrote:
> This adds the core LIO code to process the WRITE_ATOMIC_16 command.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_sbc.c  | 48 +++++++++++++++++++++++++++++++
>   include/target/target_core_base.h |  1 +
>   2 files changed, 49 insertions(+)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index fe8beb7dbab1..0ae0d4ec0ac3 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -764,6 +764,46 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
>   	return 0;
>   }
>   
> +static int
> +sbc_check_atomic(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
> +{
> +	struct se_dev_attrib *attrib = &dev->dev_attrib;
> +	u16 boundary, transfer_len;
> +	u32 lba;
> +
> +	if (!attrib->atomic_supported)
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +
> +	lba = transport_lba_32(cdb);

should this be 64, not 32?

> +	boundary = get_unaligned_be16(&cdb[10]);
> +	transfer_len = get_unaligned_be16(&cdb[12]);
> +
> +	if (!boundary) {
> +		if (transfer_len > attrib->atomic_max_len)
> +			return TCM_INVALID_CDB_FIELD;

from sbc4r22 4.29.1, the key is ILLEGAL_REQUEST and sense code is 
INVALID CDB FIELD, but is it possible to have the field pointer set to 
the TRANSFER LENGTH in the CDB?

> +	} else {

earlier we have no boundary support, so we should reject any IO with a 
boundary set, right? From a glance at sbc4r22 4.29.1, that's my take

> +		if (transfer_len > attrib->atomic_max_with_boundary)
> +			return TCM_INVALID_CDB_FIELD;
> +
> +		if (boundary > attrib->atomic_max_boundary)
> +			return TCM_INVALID_CDB_FIELD;
> +	}
> +
> +	if (attrib->atomic_granularity) {
> +		if (transfer_len % attrib->atomic_granularity)
> +			return TCM_INVALID_CDB_FIELD;
> +
> +		if (boundary && boundary % attrib->atomic_granularity)
> +			return TCM_INVALID_CDB_FIELD;
> +	}
> +
> +	if (dev->dev_attrib.atomic_alignment &&
> +	    lba % dev->dev_attrib.atomic_alignment)
> +		return TCM_INVALID_CDB_FIELD;
> +
> +	return 0;
> +}
> +
>   sense_reason_t
>   sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
>   {
> @@ -861,6 +901,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
>   		break;
>   	case WRITE_16:
>   	case WRITE_VERIFY_16:
> +	case WRITE_ATOMIC_16:
>   		sectors = transport_get_sectors_16(cdb);
>   		cmd->t_task_lba = transport_lba_64(cdb);
>   
> @@ -872,6 +913,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
>   			return ret;
>   
>   		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
> +		if (cdb[0] == WRITE_ATOMIC_16) {
> +			cmd->se_cmd_flags |= SCF_ATOMIC;
> +
> +			ret = sbc_check_atomic(dev, cmd, cdb);
> +			if (ret)
> +				return ret;
> +		}
>   		cmd->execute_cmd = sbc_execute_rw;
>   		break;
>   	case VARIABLE_LENGTH_CMD:
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 6c87bd018983..7b8ed21bea03 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -157,6 +157,7 @@ enum se_cmd_flags_table {
>   	SCF_USE_CPUID				= (1 << 16),
>   	SCF_TASK_ATTR_SET			= (1 << 17),
>   	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
> +	SCF_ATOMIC				= (1 << 19),
>   };
>   
>   /*

