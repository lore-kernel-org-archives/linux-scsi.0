Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F97D21C175;
	Mon,  1 Dec 2025 12:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593546; cv=fail; b=qlsqHfhETsK7GInJ9lnoxJUkHCEAUMaYHmpVVEJaRPJVw8AUCqFNBcJ9jID29EqJehAoxK7Ck75g3WPlioidb2f5DGRoIaR1A7Dp/hSI4hE22ePF7oa1mo5cTe+eyMbaNhRrx+DIsQQKBfyrHFWXzmy4iPx4LpEB7f40JkPw2T8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593546; c=relaxed/simple;
	bh=eMuobVl5TVj0J6g3pb1jhAlF7UW9ZyIxqME22KE6L1I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f8GS8rtWg/VYONu7RHHxiWBfBrO/WP8OanUOVXaOt4j/FAW4hhmU2nrjwGHK9CI8SPwibtgi93Zv5WYmIfd+edDbUox1oy1q5KXGkXHwKax3D3KErIV9XW448wKKwPU+1RusnWnpUrYtGe88qsO1ts5oz/JwfHMiEGGvm4eYGQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jnjNTbMp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XnYyTVnd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jnjNTbMp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XnYyTVnd"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B18MsQx1525318;
	Mon, 1 Dec 2025 12:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WerApsdPcdaHupaAmbsRSAn+C6HvlhatLVcEHaNZcdQ=; b=
	jnjNTbMpI/PiOf3Gty4PLfszNHf3i41OhDVAvXONJT2AMvpS1QncD11pJxfBXrEc
	3GHJb29uHaRclfp1nu2C8ds/ejgo1y47ie9QhU8MOI5Q0+8PeHfeQkCtZf2wTVEm
	gpG06xv2erJkU+dHLRXSV3rpa5A685woJZ5/XtbM/Ugz2FJwZ6NTaepqvwizEjK4
	K6j1VelLf1e+T5Y5ZawvqTpzKQ78vXIpy2XT4W7e3iMYRHDgTxuEDea7O6c8VgcU
	y4Xy4FOeNkia6yADmv3uUAUxJCebU/1aBBaMWXVAGmsqENhY121hCqhdQJEQ5JcF
	9jRg2366W1zFFriqWCXePQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f20dnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 12:51:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1Ci0hH012016;
	Mon, 1 Dec 2025 12:51:49 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9hykna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 12:51:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D4Vkjtxx56iFKE9J0mMMmshrhzpsO5Imxk13MlFpNvEeM4+lS/8VxzGbEWLbp8kuRoYhnIdvMJKRm+nm2Q4rBRb2D9DFFs6MJuH4KdZ38qES/9Q1fBEeCOGTox3rgyJVQQFfoRTbpqqT5xq7sqOuI20WDRhjXo3bIXjfOth+YX5qQvji/6Y/1Knh2xD8XEZ/4kkogSWgW6jFl24Qw5QzknyQMWgQzKdlEFARSZRHKXl8ovF6DK9kJPQpOGhPSKYERL0cWG4cFpMykTSPLzaeBbpvXippMHn+OP6fwoA0+kGM2e7wv3lwrQiCyC1DQJH2dlsGb/G5Ps49d4OQizC20w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WerApsdPcdaHupaAmbsRSAn+C6HvlhatLVcEHaNZcdQ=;
 b=HhINyoKY088eZ4G1MIyN5yvuKGBQSCM55rwYaYDQr4dsW4lONPq5tGGLU1w8IWak3dGGQ3xmT2vS/D1HDX7TjC4w1npD51TOBdSQY/rRUzkoNcE8zU7iPPjRRuv0jhl5J575akUFDoTgq34RX9dk+DEIUq532GR54Sra8Ur7+KfW71CuP348b10Qc51ND/U0wMpvQT4KzsP68XUFvMky/JSa3sX7fUxT8aJt+1G5MWD/MT1AaifYl5LriYcJTD09zwzBAECPFQJ4qt8asAx69kuInRbPuMNoooSsarPTg7mKmgN6W/KUc7o+GYGmFjEHnLjyxTBdKeZxFzfRauIC8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WerApsdPcdaHupaAmbsRSAn+C6HvlhatLVcEHaNZcdQ=;
 b=XnYyTVndXMt8MU1uAQu/hSYCAO1iPDqDOmedWjeT8NC48hmIqP3iOOKPJ75a657RdW1s7JzGEvzBgVGkr8k7Au/Np+K1BhfFknhZbyF9fQ0Xf9p+P/Fs0LHYVGYIuHqxcfrZglVslam8RNpJ5g3i7BX5eUGKevYt5k5U5MVamZc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB7368.namprd10.prod.outlook.com
 (2603:10b6:930:7f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 12:51:45 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088%8]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 12:51:45 +0000
Message-ID: <1c2341ae-ffda-412a-af7f-5458e621fa33@oracle.com>
Date: Mon, 1 Dec 2025 12:51:41 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20251021073438.3441934-1-yangxingui@huawei.com>
 <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
 <ef93ed19-9a94-4652-b220-cf88e5b57b69@oracle.com>
 <8911e1d8-98d3-9c1d-1329-c9dd78cda45e@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <8911e1d8-98d3-9c1d-1329-c9dd78cda45e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0691.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 994590a4-e005-41e0-20ca-08de30d861f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzVXeGV0a0FNTklUbkRWcEJaU0NLRXdXYWxqaHRwbzd1d1dHYlJWeml1TkdF?=
 =?utf-8?B?Zk12VU5jdWxhbWV2djROWDZiK0kwYnJ6NlFURTRqZkswdDZVbmlURFJ5Nkc4?=
 =?utf-8?B?QWJERm96NElqYXloRFIxa0xrckZ5dVNDOENLU1pIN2N3MllkRkRnSWtIc2NE?=
 =?utf-8?B?cFhhWHRWbGlwRCt5UFUxTXhFOWlUN0JtQW1DbExlbm8rcXBlK0dXTXErNmhG?=
 =?utf-8?B?MmJ4RW83dDhXZlZEdTBTNkFuMnIxT0wvclZjL0hJczE5d0NBMkc5ZXRQYWNp?=
 =?utf-8?B?eUZlUUFwYm94VXoyRC9Pc3BaOXNUOFdjVGQ0QWxXVFlvbVFHL0F3TFRrNkdL?=
 =?utf-8?B?bXJhRmhMdGFTUVRHcGRrTmpvZU5xK1ZVdDk0c2RIZWRqLzg4TDFtS3p2L1dU?=
 =?utf-8?B?QjRCVGtWRElVM2k4NEJxNjd1VFN1dFl5VW5iQVRQZ3J2bDA0aXNkV0k3eTJt?=
 =?utf-8?B?UEZwYUNMZUpmZmJwVmptY0xWZExJbzl5M3BkcVBsM3dMdGFUSDdiemM1aVlY?=
 =?utf-8?B?anAzWTZvanY3b3pxUEtLUWQyNnNyeUlGYlpFdDBvRTM0MERoVkMwV1JTREF1?=
 =?utf-8?B?TEhjUUNHNkVvUUsrbFl0T056T3ZPbldyL01VZXRNNVRoUjRHUW9ObFh0MHRP?=
 =?utf-8?B?eS9sd045NzViV205d2U4L004ZGtnZXpRcGJXMlcyL3ExYXBNUDFXNUtZb3hh?=
 =?utf-8?B?TC9IVTB2ZXV4bGxMYlBLeVF6NGJiWUlRT0wyak9SYjFCZTNTOEZtK0RDbmpF?=
 =?utf-8?B?VjBIMENNREppQlZUc2RFVDhPNHU3dzV6blBtREdrV3cwU0k3Tm1TTE1kUjdp?=
 =?utf-8?B?NW5KMWZaaFlRUFRySGtUdEFwdUhrbzMrMm41M1VBaGY0QnlJQncwOExVZlIr?=
 =?utf-8?B?Yk1JbEVnMjhTYVdGbHlXMVFMcGRDTStTRjYzUzdPT0U0Y0dVMHpEb1JybGN5?=
 =?utf-8?B?OXFnbkJNdE14RGJ3bjdBdUlnRnR5WmFvTmIxYyt5L3dBdWpMR0lGSGNrYVVT?=
 =?utf-8?B?Z1pUWUVUU3RsREtXOU1pN0xjc0ZJYkxqSTU1YXc0aFExSTRFVHUzQ25LbUdr?=
 =?utf-8?B?YnBpbUY2MmV5eTlRTndlODJoTHRoWm0yVXlSSUZFRmFZbEtDdnNKTEFGL0Y2?=
 =?utf-8?B?dmdDYjdwWnphOGFJcmVHWFV6dlBUaHE1Nmc1MmFOaUJ4eGVNRzdJbDE0ekVz?=
 =?utf-8?B?TG5Wb0g5RkR2ZDdNWHdwK3ZESXpLek1nYUVNcWZpYm5TZ3dBaHdNRlV6eTJU?=
 =?utf-8?B?QVpJd2JFbU5mZUhqQ1orWHRkTUg3K2txMzcydGZQM044UXVSaTZXNkdIaktI?=
 =?utf-8?B?VzZtNUZvVVBXckdELzE1d0xhNTFxYlZXZUZWTnJzZk9QankwMzduMC9vZkF2?=
 =?utf-8?B?T0FOTGJreHRJWU1BOVhIY3hIRTVKMm90VGhCSlEzbERmRFZUbVRSUE1PZDNW?=
 =?utf-8?B?VTZKZm85cDhRTzJuS3pmcEd3anFuVUtDalJSYmQ1WWEzNnBrcjNpYm0xdCtk?=
 =?utf-8?B?ZkZ1Mm1lRUxNZENoNkwyODdMWGNMNUdXekJyVmFrTmNORFE1alRXWG1qR3Rj?=
 =?utf-8?B?cVRTSkNzR0svSGI3RFNUZEFGb0pZakhwOFFLdkFQK0c1M29uQlpqSUNYam5v?=
 =?utf-8?B?OS9DT3VnYWpOVFZwcmJGaCtiKzFJeHExNmZybmozckVQZENKQ3lJZWRlWlZX?=
 =?utf-8?B?dTZCTHZNMXBzTFMxYU4vQ09sZDJlUlhIc2h0MG1FVjNPOTFHWGVNZmllb0U4?=
 =?utf-8?B?MExybkxsT3ZPb3dUUGlBMkdyNUtESFRQc2lYbHA5d1duZForbjA2QUlDcm5H?=
 =?utf-8?B?VDV6RlYwWEVnLzRUUytwb3AvVStBQ1NEQURRUmx4ZHBPRi9IdHlsbkx2djNz?=
 =?utf-8?B?bTlGS1cyVm5Dakp2V052QXpKdDZSbElsYW1qQTUxYVEveUljTHZ5WDdrcUNk?=
 =?utf-8?Q?aAsEifIh+96F2mt93YrMzRt4urMYZuFd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bklneGwvQ0JiaFp2eDdHL054R3BCVE5nUzZ1SlBMWm5xRnoxaU5XYmxiZ1dh?=
 =?utf-8?B?M2MzL2dtWXJPSmFKdGtRVDhrYmRINE00Z0dBR01JL292VXdkNVlneFRqbnF0?=
 =?utf-8?B?cjk3eGJPV2FTZC81RGY0MmJuN1hRWFBoMVNOVm5sdWtReG5NWml1cFlUM3Fs?=
 =?utf-8?B?d2ZBZW5IZi9uQitOK0Z6M0lUZDNudDgrWlcydnBNVlY3WXYxcjJleDhhTkZR?=
 =?utf-8?B?NTZ4THo2aVRsYTFHS1FOYWRlamk0NldscFkza3hQRnh3NHlqSGFUUkIzV3Bl?=
 =?utf-8?B?QUVVdi8yTXBDemdzNmxtSFowQzA2VnNUUjRuNlZSbzhpWkZhaktqbkFvR1Nx?=
 =?utf-8?B?dDRBZnZwQUxqZXA1dTZHdlg2K1psT3E2M3hjYnYwM01HMnUxTkNmZ2lQdGVU?=
 =?utf-8?B?SlhzNldqMUNBc1p2OTBTT0s4VGwvbTJ1cnlKOTc1aXZ1YnQ2RXdEeUFPUDM0?=
 =?utf-8?B?cXZDaUxHMC9Dc3JIQ2xNc0hQVTB5ZDlNQ2VzdXJGd3FkblQzazlnSXNraVNV?=
 =?utf-8?B?bER6NWpLK1ZHWDNrZmtIZlZwREJnaVVLK3k3b3h2MVMxMndoamxlMFYyUW1L?=
 =?utf-8?B?K0J4OXRNbFJFS2lOcGZLcW1sTmMxRHlZSjFzb25aQUJmY3FqOS9FcmRjR1U4?=
 =?utf-8?B?czlQbGhKb1NidmZ3YlFWVXczaHVIM2VuSGhaUEtRTytkZkY0UVNyb2VtQWJs?=
 =?utf-8?B?Q3gyYWgvQXl3WGY0eDJvN0w0SmowZVBYRkpTWmZPMUF0ZGN2ai9aaG9uWkE4?=
 =?utf-8?B?d0l1V0g5Vm9VOTlJZ1JyNWpMcVZObWNORUdueTdyY1VGcGgvMlJzeHNmUlNx?=
 =?utf-8?B?Q1VyUnNmZGg1dWxvTTc3NnNWNnYxTFZsd0xCZEZtVGRWc01HY1A0a09uemt5?=
 =?utf-8?B?S1lCcE84aVpIK0VvZm1aMzVyYTdVZ2Q5WVFoYWZHdjJyaEE1RGxNTHhVVXd4?=
 =?utf-8?B?bmdPZ3AxUkI3Z01GU0VqT01IOGYvWUxTZU1IWGRxa0NWcUVMNVNUcTUvVHFI?=
 =?utf-8?B?T2UvV0VUYkRmd0dXWFhYL3ZMNTJKSXI0QjMyL04xaU4wQVlSbFpTNHlCQ0lZ?=
 =?utf-8?B?dnFCZkdYeW9NNllqbVprZU1PaHN1L0U1ME5kQ0Nwckd4dlQ4QS8zeGc4WFM4?=
 =?utf-8?B?ZXNBYXh3UlVkdDUvQmhmWFpac0trakdaMFpQVVdDQ2VJOS9iUVUxaC8xYU9W?=
 =?utf-8?B?RFdVUGdmNE4zRHM5dlZQZ01aSUlqblVrRWQxdWtIQURtVW9EZVUydkJ0NExh?=
 =?utf-8?B?M2hUM3JYKzBrRmtVeVFxSkRZdVYyenFhdVNhOFVET2xzYUoxMS9iWTMvZ2Ns?=
 =?utf-8?B?M2NDL3FZNi9NMHdyRW9wQXhvM1FVZjRpL1k5d01KTTdjSVlmdjBRWVFWUzlV?=
 =?utf-8?B?U29zdmZHa2E2MVhXQVVzTTh2L0RBa3RPU1ZxMFRQT2VRNFV2bVZwU2NadVdm?=
 =?utf-8?B?RDIvMWpJenZZZG5xa3hjYXIvcHoxazNHc0VoRGkwRWtIRXhxN2ZMMjF2L2pp?=
 =?utf-8?B?cUl4cGhja0szdXhHYkZkdUVXSjhDMFozVXhXRTJkSHFPZHJrVjFteWkxeDl3?=
 =?utf-8?B?VE5zVFl5aHN4VDZRenBwSEw3dDdsblg0c1lLQml1Nmp2UU12Z0dJSHpCVWor?=
 =?utf-8?B?bkVTZVNyb2JyMDloNzh3M0xGTVkxaUJOWlk0eUw4czN3bGRsVk5sakdkT0J3?=
 =?utf-8?B?Yzl4NVRFS21MMFRBWlFyQ1FxUStObms2TnNWUUVZekttbXFNY2o2OTVOSm0v?=
 =?utf-8?B?dnFMc2ZydWMyc0FaSVpzUHpWSm1vYU9VUk9CaDEwY0JmdXJ3TDkzTXgycDBN?=
 =?utf-8?B?czVWY29vblFLUlozU01lRTlwV00xQkRxSkZRTkxINU9lRTJJYUFtWnBYNXRT?=
 =?utf-8?B?WjdaWitxdk9XRGFrRlZLTDFFTWI3M2txaytHc285QW8zSkorY2tRaitHQTRv?=
 =?utf-8?B?WFhRWERIWTFrcER6c0Y2eHdtcnJKbUdxM1ZtTzZFSDRhNm81S1VnRGhBUG1V?=
 =?utf-8?B?ODRLWm8yVkQ3ZVdZYk4rZ2JWcVdDWHVIQ2lZNi9PNkxoSmp1ZnlOcFdyejFt?=
 =?utf-8?B?WHljc0tPQkl0dmZiWXY1a3M5S1pIN2hUWm5yWlQ0Vkw2c3NLYlV3VjhDSHor?=
 =?utf-8?Q?kjSMZqByW81Ah8Fe+3TljNnoL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XXmKaze6V8ZYKg2wyvY/12Ag6sbEdyi0SETQG9Al277tj11wZ5Ht56mrHm6NymTGKXwP1lIhA6hIILqysAuQGXa1dfhWNi3mpGVHxLCvA+i5kYJO63/mrMJKoDlmARPza9OxA4R2roN/c4DP7WiXsu7V0LJJo+CeqdYXefk/gXrIqRbH2YWRYQSVraPofjN6c+PIZnKmONY2oN8HPK20HImh4CD6nnowPswYiFh3DqkH0NNO/AJuGMToDPjq8RouucowaBi/oHKOLVemZnCh76+xktQqJuynknW31jkNDdEAhgzyfxY/+On8CiTmMq27rHlwa02svl6Xs6LPu2wlN32X6lsqxOKR6DFsJlJjCH4i22Gp5GO2KKguSW5QrMpcOrEpfMG0jauON6R4aOsb9zlHqdT9jhHxvZgWYB6NwN+if+ieyWvwemNT7SJkrkXGDfVFejWKIW6iVQUwaN2gj6G6CXd9oP0Q+d+5MX2dodE/JqJAbYt+hhV/ka9sKbMLp1LyN//6eGXUv3hPuuIjsz9E0xaZj59+prrOAKZxG6/gsv/4QAcx1g383/lvSGU/pyIxlB62kDSKt0FFbDekJFW5J6GsqZ44/LN5vsAxEGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 994590a4-e005-41e0-20ca-08de30d861f2
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 12:51:44.9870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BGR5gNVkx5BRpz93duVO7/GmUTado7NROYoEmVqu3iLcEteN48gE9mJphgH9EEDopnTCyT2OGYaCmFcN3phrUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512010104
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=692d8f66 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=TVPog8Zsw96518ORQcQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: fdX4rgxchU0WyyxCRUH88T2ajPv4gPLb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDEwNSBTYWx0ZWRfX3os7dPHNBqR8
 TQP/v/V6RRtxIPeG+ijuV1Ho5w806F0McDOTcyf5CvX+/5pOezIUWwHid1eb9lb2Pb8o1q9m8D6
 L9UydyOzn9vB1tZbrOAD99gR9yxd1Z37UYDPsFiG8E5yvMT5m6v//GfeKpiFVSWaOjW4x2aZjce
 vky9aieq+2DnnhzPJAIFN1UMlbUBz5nZh5Hnn0sb3TqjdMyl+UzD5fNAlrVINU4W3mTpFw3xY46
 4LaZDWQUq5BIdjK6QiGzNZYfu/k6KU+wj9ohP9LwmPSlr74szgNqFN3PW73oVomzz7W0Ob/BwtC
 oiTfmlQsI54Rk7zONqvXXlKmPCR+hX4f3pohiE9jnCHIhptAEdVo+sGIfPL5HGE5bpY3gLkpYul
 QtXf2J3zaaLxuWQRlq1sKCDgU5F4897iI7y3G3kJr09swUSUMkE=
X-Proofpoint-GUID: fdX4rgxchU0WyyxCRUH88T2ajPv4gPLb

On 27/11/2025 07:27, yangxingui wrote:
> Hi, John
> 
> I'm glad to receive your reply.
> 
> On 2025/11/27 14:47, John Garry wrote:
>> On 27/11/2025 00:59, yangxingui wrote:
>>> Kindly ping for upstream.
>>>
>>> On 2025/10/21 15:34, Xingui Yang wrote:
>>
>> Your reasons for revert is light on details.
>>
>>>> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
>>>>
>>>> As the disk may fall into an abnormal loop of probe when it fails to 
>>>> probe
>>>> due to physical reasons and cannot be repaired.
>>
>> So for a faulty disk we get into a indefinite loop, right?
> Yes, because a hard reset for SATA disk is executed during the error 
> handler, a BC event will be received after the disk probe fails, and the 
> probe will be re-executed on the disk.

You need to add these details to the commit log.

>>
>> What about case where this was helping before?
> A temporary fault injected into the disk or link, which can be recovered 
> after a short time.

I'm ok with this if Jason is...

> 
> log before:
> [49495.065650] sas: broadcast received: 0
> [49495.065661] sas: REVALIDATING DOMAIN on port 0, pid:318259
> [49495.066190] sas: Expander phy change count has changed
> [49495.068368] sas: ex 500e004aaaaaaa1f phy2 originated BROADCAST(CHANGE)
> [49495.068369] sas: ex 500e004aaaaaaa1f phy2 new device attached
> [49495.068434] sas: ex 500e004aaaaaaa1f phy02:U:9 attached: 
> 500e004aaaaaaa02 (stp)
> [49495.090453] hisi_sas_v3_hw 0000:b4:02.0: dev[698:5] found
> [49495.266248] sas: done REVALIDATING DOMAIN on port 0, pid:318259, res 0x0
> [49495.271115] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [49495.271129] sas: ata761: end_device-6:3:0: dev error handler
> [49495.271133] sas: ata762: end_device-6:3:1: dev error handler
> [49495.271136] sas: ata764: end_device-6:3:3: dev error handler
> [49495.271170] sas: ata765: end_device-6:3:4: dev error handler
> [49495.271171] sas: ata768: end_device-6:3:5: dev error handler
> [49495.271173] sas: ata769: end_device-6:3:2: dev error handler
> [49497.465030] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4081 task=0000000054417d4d dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0ff1 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49497.503517] sas: sas_to_ata_err: Saw error 135. What to do?
> [49497.503518] sas: sas_ata_task_done: SAS error 87
> [49497.503546] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4082 task=00000000972479c8 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x203 0x2ba0ff2 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
> [49497.542451] ata769.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [49502.713074] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4005 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fa5 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49502.752805] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49502.767384] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4006 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fa6 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49502.807336] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49502.821449] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4007 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fa7 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49502.861361] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49502.875664] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
> internal task failed!
> [49502.898556] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
> [49502.912015] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
> failed (-5)
> [49505.112967] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4010 task=00000000be2e16ae dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x203 0x2ba0faa 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
> [49505.153594] ata769.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [49510.137044] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4027 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fbb 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49510.178227] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49510.193284] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4028 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fbc 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49510.234190] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49510.248603] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4029 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fbd 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49510.288968] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49510.303156] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
> internal task failed!
> [49510.325863] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
> [49510.339230] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
> failed (-5)
> [49512.536979] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4032 task=00000000d6273fa9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x203 0x2ba0fc0 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
> [49512.577050] ata769.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [49517.561046] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4050 task=0000000070019bd9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fd2 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49517.601923] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49517.616945] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4051 task=0000000070019bd9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fd3 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49517.657745] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49517.672097] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4052 task=0000000070019bd9 dev id=698 sas_addr=0x500e004aaaaaaa02 
> CQ hdr: 0x101b 0x2ba0fd4 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [49517.712567] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [49517.726756] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
> internal task failed!
> [49517.749459] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
> [49517.762828] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
> failed (-5)
> [49519.960965] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
> tries: 1
> [49519.971018] sas: sas_probe_sata: for exp-attached device 
> 500e004aaaaaaa02 returned -19
> [49519.971039] hisi_sas_v3_hw 0000:b4:02.0: dev[698:5] is gone
> [49519.984864] sas: broadcast received: 0
> [49519.984876] sas: REVALIDATING DOMAIN on port 0, pid:318259
> [49519.985362] sas: Expander phy change count has changed
> [49519.987278] sas: ex 500e004aaaaaaa1f phy2 originated BROADCAST(CHANGE)
> [49519.987442] sas: ex 500e004aaaaaaa1f phy02:U:A attached: 
> 500e004aaaaaaa02 (stp)
> [49519.987443] sas: ex 500e004aaaaaaa1f phy 0x2 broadcast flutter
> [49519.987448] sas: done REVALIDATING DOMAIN on port 0, pid:318259, res 0x0
> 
> log new after apply the patch:
> 
> [70734.380100] sas: broadcast received: 0
> [70734.380110] sas: REVALIDATING DOMAIN on port 0, pid:311546
> [70734.380431] sas: Expander phy change count has changed
> [70734.382191] sas: ex 500e004aaaaaaa1f phy0 originated BROADCAST(CHANGE)
> [70734.382193] sas: ex 500e004aaaaaaa1f phy0 new device attached
> [70734.382262] sas: ex 500e004aaaaaaa1f phy00:U:9 attached: 
> 500e004aaaaaaa00 (stp)
> [70734.402596] hisi_sas_v3_hw 0000:b4:02.0: dev[18:5] found
> [70734.574064] sas: done REVALIDATING DOMAIN on port 0, pid:311546, res 0x0
> [70734.580049] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [70734.580064] sas: ata370: end_device-7:0:4: dev error handler
> [70734.580066] sas: ata371: end_device-7:0:5: dev error handler
> [70734.580071] sas: ata373: end_device-7:0:1: dev error handler
> [70734.580075] sas: ata374: end_device-7:0:2: dev error handler
> [70734.580076] sas: ata375: end_device-7:0:3: dev error handler
> [70734.580077] sas: ata376: end_device-7:0:0: dev error handler
> [70736.776755] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4013 task=00000000113fa417 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fad 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70736.813168] sas: sas_to_ata_err: Saw error 135. What to do?
> [70736.813169] sas: sas_ata_task_done: SAS error 87
> [70736.813201] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4014 task=0000000037bc53e5 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x203 0x120fae 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
> [70736.850261] ata376.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [70741.992742] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4032 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fc0 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70742.030820] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70742.044539] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4033 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fc1 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70742.083611] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70742.097548] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4034 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fc2 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70742.137553] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70742.151829] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
> internal task failed!
> [70742.174491] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
> [70742.187938] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
> failed (-5)
> [70744.392769] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4037 task=00000000fe3b3918 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x203 0x120fc5 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
> [70744.433129] ata376.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [70749.416741] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4055 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fd7 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70749.457819] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70749.472339] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4056 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fd8 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70749.513046] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70749.527425] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4057 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fd9 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70749.567887] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70749.582146] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
> internal task failed!
> [70749.604974] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
> [70749.618406] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
> failed (-5)
> [70751.816753] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4061 task=000000005dbdb66e dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x203 0x120fdd 0x0 0x100 Error info: 0x0 0x0 0x0 0x0
> [70751.856789] ata376.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [70756.840742] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4079 task=00000000e8bba149 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120fef 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70756.881620] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70756.896277] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4080 task=00000000e8bba149 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120ff0 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70756.937020] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70756.951407] hisi_sas_v3_hw 0000:b4:02.0: erroneous completion 
> iptt=4081 task=00000000e8bba149 dev id=18 sas_addr=0x500e004aaaaaaa00 CQ 
> hdr: 0x101b 0x120ff1 0x0 0x0 Error info: 0x200 0x0 0x0 0x0
> [70756.991856] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: open reject failed
> [70757.006124] hisi_sas_v3_hw 0000:b4:02.0: abort tmf: executing 
> internal task failed!
> [70757.029005] hisi_sas_v3_hw 0000:b4:02.0: ata disk reset failed
> [70757.042455] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: softreset 
> failed (-5)
> [70759.240774] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
> tries: 1
> [70759.250828] sas: sas_probe_sata: for exp-attached device 
> 500e004aaaaaaa00 returned -19
> [70759.250845] hisi_sas_v3_hw 0000:b4:02.0: dev[18:5] is gone
> [70759.264497] sas: broadcast received: 0
> [70759.280050] sas: REVALIDATING DOMAIN on port 0, pid:311546
> [70759.280189] sas: Expander phy change count has changed
> [70759.281879] sas: ex 500e004aaaaaaa1f phy0 originated BROADCAST(CHANGE)
> [70759.281880] sas: ex 500e004aaaaaaa1f phy0 new device attached
> [70759.281940] sas: ex 500e004aaaaaaa1f phy00:U:A attached: 
> 500e004aaaaaaa00 (stp)
> [70759.305377] hisi_sas_v3_hw 0000:b4:02.0: dev[19:5] found
> [70759.478056] sas: done REVALIDATING DOMAIN on port 0, pid:311546, res 0x0
> [70759.487508] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
> [70759.487522] sas: ata370: end_device-7:0:4: dev error handler
> [70759.487527] sas: ata371: end_device-7:0:5: dev error handler
> [70759.487530] sas: ata373: end_device-7:0:1: dev error handler
> [70759.487539] sas: ata374: end_device-7:0:2: dev error handler
> [70759.487544] sas: ata375: end_device-7:0:3: dev error handler
> [70759.487572] sas: ata377: end_device-7:0:0: dev error handler
> [70761.674270] ata377.00: ATA-11: SAMSUNG MZ7KH960HAJR-00005, HXM7404Q, 
> max UDMA/133
> [70761.696856] ata377.00: 1875385008 sectors, multi 16: LBA48 NCQ (depth 
> 32), AA
> [70761.713233] ata377.00: configured for UDMA/133
> [70761.725238] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
> tries: 1
> 
> Thanks,
> Xingui
> 

