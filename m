Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2C25FA05;
	Fri, 27 Feb 2026 08:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772181362; cv=fail; b=TOxlTmZoTddgl48u/p9SrY1Yervf+QHFFt2O1FCoTEmP3Rk6YqAzpIMcbKMLsft4EYMYOYXYsZSBLYfXenmOS2Vvnrlos59ehOhuuHEOPe9p50ci7W168EP0y/hb/K49gv1wDzAj2TLq5ICgJKfRqMJve5wn/P8tRUiDKCA5Uc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772181362; c=relaxed/simple;
	bh=jsm3oxAI2DvkFD44cRwxP1+cDsmy7T+jtGWrAtqSwfo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hI6umVsPs0xtilehIt0T7J+oPtm1A6cJxDrtsILTMKvhgLN/K1o04smTNIIMJIhjFTjw2dD16lQUgT7W/eaaxM87cWvkd4aQQx1LSGQ8jX4N50BxBBJ5HEj5rNqoiegivjbyFvku13hyZ7nSugHDfcMmk0nJ6qgTnVAhGpsqDY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DKy5fW37; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UcPHvxi9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DKy5fW37";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UcPHvxi9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QLtVNl727343;
	Fri, 27 Feb 2026 08:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CMeBKvAohzsHCC5FOYiyadMMX1JwEJrH18IHznXNIfg=; b=
	DKy5fW374Mo+7zROFnQyu+NJBnzCF4zA2VNIAuKquC3Z9XuWJnEgQF+2Mb1EL4wQ
	ILWxS0H37j0hgae5UeN/xdgukLLEr6W7aHXX1R4liiXDaH0jMOEr04vWeuvv3nDY
	9G9f1QCb4BzoHRn/+lrsbpUBk3GPhP3t3ApSi3bUvExPCNZK00my+3HL7APyMYbQ
	7p82QDfC+u9ZsFNbeKom+CwXgjh0wJ3VU0pigm8RnnYo+MRBL+9Y1UHJxxTzqGCS
	9iS2GWcNzrExK5v2yPUHCuyGnqQJVU0Z6XWpxMDiU2k0XTv19psc69htHlBuGm/U
	ubTjBH16Rtwmv/G3z+rfKw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjgppa39q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 08:35:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61R86gV9027807;
	Fri, 27 Feb 2026 08:35:37 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011043.outbound.protection.outlook.com [52.101.52.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35jmab0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 08:35:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fF5IUzs1FJqXQ6JAVNjteczEHsWoMhOXpiEcWlVPjc3EZyUiSdzPRTDwfwb/fRjHdE11YE/+xnWAzTLT8AVmx4A0B0Dak3XIIWazQO8tnFTSR3r9LppSAhfmefpuqXFd9+jjlGTnxuuoe1XYmRrrkpSoXXWcTXoGc2LFKDPqS7FUjXvesk/7/k6+UVV1K+TyxMk35wgnLRldn1Tp2VNAPWyzom6DN4kDp41FGWSJ2EPlH3vYltXILKnryTyI3BUZFhUEDp+QIIsurajdwU+aCoUNdcQqC0HCHYCutGLUI/xGAd3U7dzR+m0XKegZkJwhlJYAgrmlcJ5kBRhMP1VsvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMeBKvAohzsHCC5FOYiyadMMX1JwEJrH18IHznXNIfg=;
 b=RYu/upKYn9101EW2gRMhfF0nCsBzj8tb0mzuR2SZbcMpyi4AQAP5DMEh5x6XCdQhXMGbfYRL/s26YlZ812ntxo76z+9SJs6HTrSpbZqGceXDOfk06IwMySevhshwHhrG8vBBUz1tgOXm/6nnLK2t4sb7HzcgS+f8pGa2e9kWrNdMJDLhl85hhJk6Wq4vG3N5d5eu90a7BZvBDZhqQtY+EW75mjRd0SwvErEgZJLC7yD0+rae0AgnvWNjZ8JxCaj2eRIxTgPTWxAM8Fwe1UNJ3BPQl1wRGP1Sou1A/+p2ecpehBUk7pl+jStCv4CLMJQRbhz9hS59vJm55y4o81KTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMeBKvAohzsHCC5FOYiyadMMX1JwEJrH18IHznXNIfg=;
 b=UcPHvxi9K3gIXoiHPkXnunxUX7VC2IzRCgmVjefSu7AqaL+Cb1x8Bgcn0yZyv+tQc6Jogpe5N0dkkkPzIV/Sx9q2cStVR+Ycc9XtqBMD5Pb2iyF5uQ+SJ3olNReJK2LgCGqcaMiVaL17xgK/FqLpI8pJf8lnLDMEmxx3Flo/8Eg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7272.namprd10.prod.outlook.com
 (2603:10b6:8:f7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Fri, 27 Feb
 2026 08:35:35 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Fri, 27 Feb 2026
 08:35:34 +0000
Message-ID: <bd5605d1-3f2e-49ca-9807-e4819a8ddfee@oracle.com>
Date: Fri, 27 Feb 2026 08:35:32 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, pankaj.raghav@linux.dev,
        bvanassche@acm.org, dlemoal@kernel.org,
        Swarna Prabhu <s.prabhu@samsung.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
 <20260219043741.276729-3-sw.prabhu6@gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260219043741.276729-3-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0553.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 79f92ec5-2af7-48f3-36d7-08de75db2cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	9IPnSPZgYPLjTLoc0T0+8R8DcXltNkfgMKGsBKBaPqY4XoWIC6qckRpWwC+FOX3d0MmyhVLj3FHKh71R2uaoHsiG2f7Lqm1/q95jHTfTXepSi1Yj9taI/pFtOlYGwpiITT8/qJk4S6dBUygpLka+1HAcJYfFg7zyPyeqExH9V/PD7jhCFQ75O2FneeR2uLfMzr3nC53JrRIVRblMjMmwfqLCvFGEB0k5gDNks35wI7QZuLZt4kiGRacyzO3Qocs0EQM86uz1MhK3KrdvOMvvLdGms9RlXD9WPPHKzxuWbFXWOyLkKGFQCRCvhsCbiOaGhoXgp6L/uYOjsfLqQvGZuLmrvr1O+/b6HkQ0t5V/eQ4WrE9RzDdrYbciKAOtf6of09ug1ER6AmpIvk5ulYzGNOKrrnVkhcmmoOPCkfSjXIyL110XOXAvXUqMpTMjsqAXljrl07pdSCvCBPJsWLdDLMRZgClBk/um41ve4L7c26Y6Ozw0OHRLm3YU/Y9MAjYqrvjMsKL1N3W3lj0jDij19+HHdQzAMQGiSJ7fTyB5y/1/ejw8WPEqwlMw63ytw/vk1nPI6GgePwcez2cMgtsJ1wsHjC7P9TkSnfGyv2M647Bom4uVGniv7tXegNVi/U9EiNzPDwbbyFLLPdPW1pQ1HtbBSzgBZieUuyL3xWZuuLaRBVXUU7Ay4P4lAILaxS7/S2eispCNXAuUnriN590KlYaWq76Pjo3jGq7t2LKb3x8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXBaK285dENsdGdUMGxTWFNlbXZDak9JZnRpNGNDTkx1cEpTZTJTMlZnVkEz?=
 =?utf-8?B?THJYTStTaWRMUmx0cXdMcFdkY2JVbjlKbmZCeHI1MEJlY2czdk5WNUNtOCts?=
 =?utf-8?B?VlRSUWRtL3Q4UUdGaGJkbXRzN0VQMGJ5c1ZSMktHbk1WbGJvRHRnRE1MNlZw?=
 =?utf-8?B?alZjb2tDOU1uWm13ZXZ0Uk9JejJWcDlmN1d3VHZ1amdNZDJaSE9DdDBDdlpG?=
 =?utf-8?B?dVFlODRob254Ry96blZjR2tlSzhTeHcxUFArY1E3RFMwb0ZlV0htbWkvem5n?=
 =?utf-8?B?cFJ2T2xCSUdYWkxyWURqZXN5TlpJRk12NVVzaWFad0QvcHpGVnE2K2JOMTMy?=
 =?utf-8?B?ZGd0YjBSbExRVkNOZ1FTeXdIL2Y0Y2dtdVExMytSQ2xrdFJQVSs5K3Vxckl5?=
 =?utf-8?B?SFphR2RkNmVOTzMvM2hFanp0bzRRRDNsMmhXUVF1QnYvTVBPY3JjNVFncGh1?=
 =?utf-8?B?ZFlqME5obnNLbVAxMmYzRnRkb25uWUEyaFIza2lMdzNaM3AvbXBmVlZWWjMr?=
 =?utf-8?B?UTd3cWlhOXlQOUsrbkVYV1doeDZYOG5rNXFYQlZndVMrMEx5eUE1dDNXZi9D?=
 =?utf-8?B?dW53aktDd1N5OGFsQ3ZaMGw5MkE4WFI2UHBGUjdxd2NzaHpRQVJSTjQvTWFa?=
 =?utf-8?B?a05YdkhhemdlakxmU2tyRkVQSmg4M3BJbThuWlh3V3ZFQjBYbDIrZ1FqV3RZ?=
 =?utf-8?B?OWpIRkF5dmhBRXo5NkVEZU9BQ042L1FJTExNSktuQ041UUhhNEoxbkdqcGZ0?=
 =?utf-8?B?eEUya092WWNQQklRS1dsVkVma1BwNFd5WkFSS0dnMmp5RjVFMmZiOERZSmJy?=
 =?utf-8?B?aWV6em9DU2xxa2o2cnJhckxFVmF3RlRtcG1NNDg0b3dJYk1IdHdpS05wNHVh?=
 =?utf-8?B?Tys2dm5nRkV2TGNXUFI2NElNYUVmRXJacFpTUFJrVHdlTGZZSzF5L2Fyankr?=
 =?utf-8?B?eUtnN1ByZDF6YmlNdGNMaGRwUGkrM2N2SHZHL2kyK01BN3JtUjZLSW51T21h?=
 =?utf-8?B?V0MrQTZOUzhMOTd5dkphZXd4b3JDNHhHVStoOSt4NmVjemdjZmpnQUhtcXo1?=
 =?utf-8?B?QmJRNzk4R3g1dWRFVmI5TFp5VG56Tk1NOCswdHYxQ2VlV1BkR1o4WnEvRlh3?=
 =?utf-8?B?cDhKaVBUbk4yQ1BBY2NEYkNDN1Fqa1g5SlVQRGlwMUlnbDE2ZDJwSDJHZ1pm?=
 =?utf-8?B?a21SbXBkMUZLWlBrN2toRGszY2l3WlNsZ2ZoeXNzSklVL3AzNW5Fb2dpZVJP?=
 =?utf-8?B?d2QwSmZwekZ1cFMyN29ZOVB6TjlYeFVhOVVvd2JFTzZyblc5c2Y1TzRHSmJO?=
 =?utf-8?B?bENnTmp3MklvanI4aUdRTDROQ0d0aGFETWs2QXZZcHVNaHdUQnM3ODVXTUJY?=
 =?utf-8?B?UXQvSGcvMXFGd0JoWUNDVE5reDRtTklZdk9zQWNoUzVHY1NVMzR5anZWaUV3?=
 =?utf-8?B?c24vdnppaDhhZDYrelNyU3BOMGo1bjN2QVVKZ1BmMUl2cHh0NVJET2FpRjY2?=
 =?utf-8?B?aVNPdmJZRURKcmNQeDFNb0tTM1ZSUk9PRDc0VklyeXMyMzV1OGNWdEJGS291?=
 =?utf-8?B?ZU45dnROMlBvWGdBd2JuRDlyTVh1aVkrYzNsZk94Y1V1SkRma283MmJMRnFC?=
 =?utf-8?B?dTFiWDR4enRVV1NkS1lQMHpkd3dqQkJ1QzdaaC9sOW9QcjBzOHNYS2hHQWph?=
 =?utf-8?B?OFB3VEs5WFEvM3hjRTh6VE1Lc0UxOWo0c0c0bEwyTzdxZFJoYUFubEtJQnQ5?=
 =?utf-8?B?VFB4LzMvWmhIR2lHdTNIT2lkT0FIc293TmhvNGtWMFhYYThCQTlZVEdMV2tx?=
 =?utf-8?B?Z0EzTzUxYlh2MUpkZzdFbWluMHcxcC9obkRNUWRCS25IbGpiT0toelFMeWk0?=
 =?utf-8?B?enlKZ3hNeTArM1RYOVgyMDRFZkpwV0Y1SXBxaTF6d1lHZXREaHNrNzg0VU9v?=
 =?utf-8?B?TUdrM1BqektyempiWWtueHNYY0prT01HUWY1UU5qYmJ0L2h6dEtRSjQvc1U5?=
 =?utf-8?B?R3luYjM4blRiQVV4emZhaXluVCtLb0J5SnpFdE1kV0FBeUxiZHU2d041bHBa?=
 =?utf-8?B?K2V0TnVaZUh6SDJyclRWVUtjMFB2bnZJbEpPSy90ak5mdHZPbFhwOGRqblNm?=
 =?utf-8?B?WGpIdFlCdFFMbzUvOUYrc016RGtmMUQ3OGFUTGxtVks4Mmk4UU5XUzVWM1lB?=
 =?utf-8?B?MUF4VG1GYk9yYU0yb09UNG9nSTJBS1VpeXU5MlNzWWZMbCtIS1Z6YjRHUUFH?=
 =?utf-8?B?NVd1bVJITWljWHEvQlBBM2JzQUljblNldU9Tamw4aWpqcFg1MmYySENucXV2?=
 =?utf-8?B?aTkyMGsxNGxOS0FYRm5qVUMza1V3SlVNT0lHWHZvZ0hlOU5vM1Bwdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3340ISNH+qrRxIRosqUHi4EVLO6qp/1vKgABV1wACzXbBucrr/h8RQnBGQPArXk0XQ9oC80S9rCq0pUAs7czavXtipJvR5SIUF5UQ+hfxq+SOfLrZmGnIrNhbgynsWAQcYutBSTH20YZ6nLMT1eshfECYsXKG+6fsz3YUGN/xCjXUs40zaB6hfOhxQn8BRdppaQfrLdf1ooW1IazVSLwv13A/SP2ZdqgFfni3O+dQ2ENYYp+m/Dt0ZHYV8Dz/uQUyhAtHbSh9wQy8bq+s+fo335ZtXyKBIhz7uleBltIQKJbTtv6m7Kv4w+u5zyutYNecM30ArewnUtUH3/OGb6F1hlecfr4wZAGGpRrIy9POjCDP6tMq4BVLOc9UJt56RoPHSfI9IRHmgMnDEalc+JtLT34amSh6tKgdADCCZV4VMNGUgQqaIAeTT0nMAUp2Z4z/5R4DQFupghhLzAtfms5sXR/0rucVys8X6ga2MwzrEvNuTj7zXmTu09bqBvkZ7+Wln2ywSzlTa0vl5B2VjYrLMzm6gQUpj9nT3v1NMy9UWG6l0xyt5H5BGzfPgC3u41OpIxO9gFMDjSY9Ijfo7o3PRX3NEDahdjIoiDtfcxh6CQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f92ec5-2af7-48f3-36d7-08de75db2cef
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 08:35:34.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JprKtkd59O9FPuBGpuH+w9YDFbbwG0dgVEllfw0v+qdRmkF4cGbdiqMlEnUrf3ov6OH27hblNY+fe2V8O6YbtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7272
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602270072
X-Authority-Analysis: v=2.4 cv=evPSD4pX c=1 sm=1 tr=0 ts=69a1575a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8
 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=dxHcqQ39H6HHjJCoxbkA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12262
X-Proofpoint-GUID: nGXtcLAi-pqrXo_2RkSc1TIuTwJt4YVB
X-Proofpoint-ORIG-GUID: nGXtcLAi-pqrXo_2RkSc1TIuTwJt4YVB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDA3MSBTYWx0ZWRfXwPYkzb+RBUoR
 9ai1ikQHFJplS1oilTWHZnbd1xWuWW8nltIHQ8bXVTJnnaQD1SrOm2vzpj9ku5k712quz29LMv3
 2hq/vPvDbDKXUNs9km6BXiJlLriJgWWTGY+e/Hy7zaA0ChetNBoX5Tw+BrYEWmmb4wD0QY4iV7o
 KU766Ev/pNpdnTIfAwrfwPPdarC620YutRuHesyC5ypd/LJr02E27lALSO7d6KjPb8IqR5ZO/7E
 /FnfEX7T01K4GHfTLIfLBvni2C+QZZvHPmUCiKwjZLCmTbnTnE4OSjCp43zch47bNjdda4sQdmx
 LOzn+7rZ9nCUWaVtd+bH2FxAW2vKaO9gMP5nfTpihOVBsPKUeTSss++0pvNccWmEq3IcPUGeKMs
 x+ZqDpMOinggYWAzeEau9jf+UwF6RavqgesRSR7sUGKy1llmy+p8S7yyfSoqKb5L7WXrus3zoip
 zbmz3e4KAzafQqi9kuwJgiGFcwSLsGWhvFKHkDTw=

On 19/02/2026 04:37, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <s.prabhu@samsung.com>
> 
> Now that block layer can support block size > PAGE_SIZE
> and the issue with WRITE_SAME(16) and WRITE_SAME(10) are
> fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
>> PAGE_SIZE in scsi_debug.
> 

Surely the sd driver or block layer should be catching non-compliant HW, 
right?

The scsi_debug driver should minic HW, and there is nothing in any SCSI 
specs which mentions that the sector size needs to be limited to 64KB or 
the like - am I correct? The useful thing about scsi_debug is that we 
can pretend to be broken* HW and see if the upper layers catch it.

*broken for Linux or non-compliant wrt spec

> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> ---
>   drivers/scsi/scsi_debug.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c947655db518..4c6feee87f05 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -8495,13 +8495,7 @@ static int __init scsi_debug_init(void)
>   	} else if (sdebug_ndelay > 0)
>   		sdebug_jdelay = JDELAY_OVERRIDDEN;
>   
> -	switch (sdebug_sector_size) {
> -	case  512:
> -	case 1024:
> -	case 2048:
> -	case 4096:
> -		break;
> -	default:
> +	if (blk_validate_block_size(sdebug_sector_size)) {
>   		pr_err("invalid sector_size %d\n", sdebug_sector_size);
>   		return -EINVAL;
>   	}

