Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9B22010FD;
	Thu,  9 Jan 2025 13:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736428122; cv=fail; b=sndceV4hmXKN1bzZVCHyVl34tAGL3s14nWXgBEnGGED4T2iM2zi7tOxDlgI8emcU2a5qOJPTC3pKvKxfBY5hWEcGCZvkZYeNhO1ETvmhKE/cxKkNJFe0pg3srS+AHymuoIxUazE0gkyIp1adMQokJOrmmi2W902oxRL8y23XQDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736428122; c=relaxed/simple;
	bh=TYc60RZXH8ZLiz5pd8k/PdfgkCaFNLs5u9wTSjfQPPo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TjbpIjiaCmllTxMJRqXYO8X/9S7CLgQt+HgPHz10HzYwuEofl8+zq3nj+1HC8EGWr5YuFWLpPEuJAmgqIfFzaJSjUte7RdESGG1oJ0PJrOJqn4eAfoI1qfYQEeq29Zu+YSsuVR1T8zja81l7iwuoKTZkrtAu9KB2BuUY2M92pPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hSJ0GIXe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fs1uIpf9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hSJ0GIXe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fs1uIpf9"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509Cfn7T025918;
	Thu, 9 Jan 2025 13:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JcWwNiwHyVKwyGuv2yZ9C2OvtyY3FHBz8xogp/iFqRw=; b=
	hSJ0GIXe9Jd+qAJprSNIPj3RyVgyHqOE1W7Casgv8K606y6yFlqPAwfyMshg6xrO
	Qao0SvAbsXmDfwfWHwZetRcKKgEF+TiAniXu55dXB2sL4Pjehhn3PBTu0cy48lv2
	DDTf3ptjwMUuR6bNr3zPqTAnF8ntGkVAcfgSxTat+IPdVji1Dda1ZVniDA1nykXp
	M2w7WlLYqfzhxsby2BtCLo1LRPSc8Ait8cz1s332HBpkaB3co+Ov2h3CGht7STdT
	boPsJHDuOkDrvkdHqxHW0N0ulqBCx/rBJhInNwvsNK8neig7QHU5aryC3oHvImUy
	COScNWxxePUlP3Ote3V99A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442b8ugc6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 13:08:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509C3ZD0011166;
	Thu, 9 Jan 2025 13:08:21 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueaw6s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 13:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dPQny98b+6TTto8Gas3t7cfnUmrxp7oItifmOIXW11h0eaaiTW2xHcji0bB0U5LxnMLKWoE80v70N07rC7d9hlBfhhuP793cnTJqZOkAB+SkQF/bNmo9J/1D1PMhFLVP3Q2NSQG6wRSDBLyW/X9Jh2rkxjR6qJwcv6LKAy82dLkp27BmVVHk/obTzbXuht65GZ7C05Q1/crC3Vmzza1I8ldXWb+OC57lcYAoGfWIakawpwMELggOrOqTjwUPuUbxGrJDu6/mwMjLYdmj+/LIw+FFQ2O/4akdUrzYH3qf3bugsvzOMkrom+6YBGMJbmwbwALA44b4wHDz9l5/zhRpGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcWwNiwHyVKwyGuv2yZ9C2OvtyY3FHBz8xogp/iFqRw=;
 b=i5OMUNFizlVbDYLzrO9gYpIYFzwg/sBLBD6IAuxNpL1C+UfxzJbn0mVUPqxr7c4bCPtTBSZWT8wqHrWzj9ff6eNHLEzulWJXBSxlv1+//L7CLqwgJWyJl9dP6798Gq/83RUvABlcNOaPXhvq265501/YUKa+bhwsjMUwwM7eA2PLTOX3Vy0O/yC50Lo/e/YlM1d5AZv5ag6v+ng/VJWHV0MzIdZW8OxzRaCiD5cAgaEj4tggU0LdHgoefe+1acGNgqD9kxAlNxg7Ps9j0GmuBPDqeVlXCuauvC3g1Et/6PmWFcvpUmYL8+OEWEYKcBUOKyaSMur59MMj9ZedJDHcrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcWwNiwHyVKwyGuv2yZ9C2OvtyY3FHBz8xogp/iFqRw=;
 b=fs1uIpf9r0CrQKDvXirqmrGkMWMVNT3RSaVpLvLzKW8NkrESG/9orCk3ebxtueKyLh958S2ZfpqlkS+o3anjwLpUVWlXwub827pP/34r0UVMDlyWiDkU/toF4zSwO6Y7dpk3Fp1wZAEsTGan/sB9fcOpaHxYpfg84qqxmbPETfg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4246.namprd10.prod.outlook.com (2603:10b6:610:a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Thu, 9 Jan
 2025 13:07:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 13:07:52 +0000
Message-ID: <8cfe7690-0101-42e7-ba97-6c6b717c4706@oracle.com>
Date: Thu, 9 Jan 2025 13:07:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] block: fix queue freeze vs limits lock order in
 sysfs store methods
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250109055810.1402918-1-hch@lst.de>
 <20250109055810.1402918-7-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250109055810.1402918-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0180.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::49) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4246:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ac6104b-6b09-4d86-1568-08dd30ae9fe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2tRMHR6YnR5akJWSVo0cHorMEFZU1VxQkt5ZC80K3NzcmZJTEJMMGVyTVpy?=
 =?utf-8?B?STZsSTdJaXhzQzZVbFBySG5FT2Z4V0FZK2pJYnRjTU9pOThuaTg2U1dqaDVj?=
 =?utf-8?B?em9lb1NoNitWdklacjlDa2hnMGhSOUFEaEFQK0RWNDFVK003U3hUMXp6N2pm?=
 =?utf-8?B?dEVpRDdZVG5zWG83Tkx4L1pNVUpLSUxpbnNmeThZa1c4cjJxc29vbjcvdnVQ?=
 =?utf-8?B?eGpkRmRaT1ZsOUF1RGFRYkVObHVMak1JQVo2NWJsLzRLN1BkeGdDSmFHYmNj?=
 =?utf-8?B?RjlQK0cyUFpFbWNPMjcrK1B6eTkweXRYRE5PTDFLZnNpL0hQblpTSVJ0Nmxi?=
 =?utf-8?B?TXgwbjF2QlZTY2pHaFJtTFp3aVRMbU1pdFZEUWY3V2YrTTIrMjNzcWVmOEpQ?=
 =?utf-8?B?Q041QW1IdDMyU1QxVG9tTXMwdFp5RDdyUlJLOUtkWVJPanROM0llSVZUSWdm?=
 =?utf-8?B?d1RPQnBKSnlVZGU0MTNzaXkraEd5SFBFTlM1ZU9iOGhSZ0RwZG9KT3RoTm9h?=
 =?utf-8?B?MXRLaVpzT01rYlpBWWlnTTRONWFtNUp6eHFQYmtCdmlFcXh2akEzbDJ0RjAr?=
 =?utf-8?B?bW1iejRUSTBxWU5IamJPRkk0SytsVlEzSGtNZVdFMTlOQmZCM0U5eENrb1Ns?=
 =?utf-8?B?TkNHUlJLZTZnTm5DNUVyMm5HNkw5MWVneVdFS3RhTUdOY3Y1MWhDd0l1MlN0?=
 =?utf-8?B?MHdzNWhHbDdNbXNzSkZvN1JxWi9VbDJCd2x4Wjd0WmtwaXNHajZwU3QwMmdn?=
 =?utf-8?B?UDRiQVk5U0tmOHRpeld3NTFWc3ZqcE9MREhEUjV2bzEwb2xpbzhEdGkwTnRo?=
 =?utf-8?B?MExQc1B5SG9Va1N1MkgwWE92TFhZY3BWUjVOeGdwQVVSajlSdTBYN1NyMFpz?=
 =?utf-8?B?RnZMZENkVldKazlpVC81S3p3cXYxbGw1YlZaTVJDZEtYZktUNnBzTDNjUklJ?=
 =?utf-8?B?Q3RGVTQ3cEU3VmE1Qmw0TE5VbFYrdDFiVDJ5NUo1MmY3Q20xbU5na2wxWDdh?=
 =?utf-8?B?SVIrdEx0ZWxmb1RIRHdIYncwc2FEQzBBS2Mzeld1TG9Id05zSVJIeFNCRUc5?=
 =?utf-8?B?dEtxTytia1UwOGdFNm81cTZMQmRlaFpuT0N1dk9sdlVhUndDUkY5VFIzcTZ3?=
 =?utf-8?B?YmtiQUxoMzUrK2p3VUFxUDZsNkZJMzYraGZ1RVVCZ2Z6RWdRYVBrbUNDOTd4?=
 =?utf-8?B?VTVUci84L1BXSUtmaHFOdTJGNUsyNlNmWUM4a3RBaEszOUpyUWRUMm9ScGps?=
 =?utf-8?B?aTBZK2VERmhHS3g3QUpiazFYSVlsbWpKekllYlo5d0VJVThzNk1VRVN3YWtR?=
 =?utf-8?B?dGsyMmkybFMzeWZBcks5bDFKYlFMK3ZrVDI1NkNITVVXT201VjJIS1ZtM2RQ?=
 =?utf-8?B?VzhVTThJeG93emlCUnhhb25tV3lqb0p5aHF4M2JkbC9wbjRIZTJNckRGcnls?=
 =?utf-8?B?ZllTd1l4anN6NHVUQmxFSzkvS2xsWGVyV0lSWVNSeW5iTGhvQXJLTEVUMzhR?=
 =?utf-8?B?SE1hNFZUcGxlcnUvNXJHMWhtMDE1MG9NY0Z6emFNSi9aeVBROStXVWJwNDkv?=
 =?utf-8?B?ck5oQU9sLzFVVmc2NlVFbW4ySWl5aGI4d0FUM2VwR3FZa3VwSjJWbjJZZjd0?=
 =?utf-8?B?bFBwbWxJUHJRWjZFNEwreVAxSkw3ZGhMMmwvelprS1YrL0JiSXhiVzVLVkRT?=
 =?utf-8?B?MWYwMUVab1NpRHdXMm1TSFJpelpkVFRVQk5GTXVQZzNwNVo5TVVXOVllUE1T?=
 =?utf-8?B?NUxKSUtUdG91bVo3MmhSY1o0SGQxNTFDaUVCNzBMT01DY3c0ZVpNUmMyQU53?=
 =?utf-8?B?bGtkQUsrVDFvc1BUZk1pUmd6aXArMWl6QWJtUUZQTTE4cFJGNWM3a2tBR2g1?=
 =?utf-8?Q?GzspzeZ5b2eS0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODd5OW42bHkrNVBSNGFVWEVCUm5wd3JsU1ViR1BJcUJKNXhNYWNJd1ZVM3NI?=
 =?utf-8?B?SU1GWDRTamI4ZTE4eFpuaVNsVldZZzcySjBLNkcxZm95MGtXVGViajhtdkhp?=
 =?utf-8?B?TTVEdS85dFZmRytXeXQwMkJvalVOOXNPcG1hbW9HbkxxdXNYUnQxc0VmQUdS?=
 =?utf-8?B?NlhhM1F1aEJGQXdtQmFFUk0waUduTldLZkFWWitPcmxHd2o4bC9tWkYyUVN0?=
 =?utf-8?B?bXB1a25BUEM4amFTRmlvZ2JCb0RNa1ViK2pVdXl1K0o5ejJucVlpVkhLM0V3?=
 =?utf-8?B?MElqSUh5cE1Wcnd5VnpaQkFXa0phT2Z3cDZSY09UZlo4RTQ2WnBDb0dCaU9L?=
 =?utf-8?B?Y3JIM3hyMUhuVG1EWjZWTnliV0ZsTkwwT2c2Yk1OM3BMQjNlclBvWUNpbEtI?=
 =?utf-8?B?dkpoazFTRk9WWjdkZVdWM1hsYTkyUmYrM1Y0VnZEUlNtMStBK0hZYllLbStj?=
 =?utf-8?B?MDZpYWhwaVc3b2dMVlNjbnhjb1FVMU5iNUdQTWNPbXcvWGYyQUZwb0s0WmNp?=
 =?utf-8?B?WGlrREdJS3cvUXhVREQ0M2ZRUFcwVkR0T0RCczNtamtnM3daQXczcEk3SWZw?=
 =?utf-8?B?MGo0VkRmcUg3NVhBUHJYNWxsS0dXR0RwQmUzSzFuSDdUNFltcWwzd2YrcUZK?=
 =?utf-8?B?Tk00a1lpTWY2VEMzOThWaFNxeGZGZlNGNWFVL2lpR0pJZVFueFVzT0RJQjUr?=
 =?utf-8?B?MU92eHhLR2poWnhVUTg4dlJWaEUyY2NQYy80Zy84MzRTOWVCSXh0YnRlOFlu?=
 =?utf-8?B?NmdybWVZQktIK1JoemdqRlFGT3B1OHlUSm9sVVRCN1R4Q2JZcnVWenlxV2Jr?=
 =?utf-8?B?ZWhicmpoNnAyRUk5TG5NeHBGSzVwaGV2WlJXeVdJeTJqZ20vNG8ydTVibzdL?=
 =?utf-8?B?QUlEd0ErQmgvdE54SnJ1c2diSXQ0RUFQRmN2S1J5VkhaTFkzcG9LUkUwUUxZ?=
 =?utf-8?B?eURycS9HSlB1NjYvQzRIek5TOEh6VGZuSXBZRW9aR09MSHhQcVU3S1krSEh0?=
 =?utf-8?B?YU50NEh1QkQ3Rmd1RXJIVWtvclBXM3Y4Zi9aT2dPd0FCVTJjMlNkQ2RqZ1Bi?=
 =?utf-8?B?VCtSUHJZSm5ubUJVWlVxUlpjSFdhK3JmbVNGUjJtd05URi9yb21TZC9PNVVG?=
 =?utf-8?B?emFSd1puQkRWRm40R05YMmVVK04wbHRKTThjSTZJWmgrM1hCZmthMFkwYmE1?=
 =?utf-8?B?MHJSZVRDMUNWS093djgwS01yMDQ1S3ZBNEM0OFlpVzRIaGw0VHhYcUJXOUov?=
 =?utf-8?B?bTNHRlNjMmFZelZlSTlZVU9WUWFad1RJVkR2eGNkTU12WGZueFIrUXVncXJv?=
 =?utf-8?B?a1FLZGNwTm02UytXc3BHWWszN1RkZmNxRUJPMDJNOVZmZlVybENnTndMR1JB?=
 =?utf-8?B?OVZBZ1ZoMlJ1dGFIZUVuRUw4dmJnYlVqekZKK0g4dVZnRTBOTS9tVmRJZ0Nt?=
 =?utf-8?B?WGNNVzZ3SnNOQkdKN3ZWdVRsUWhrMHI0dkIwK3M3cVJBNzNqU1dxc3ZQaUlG?=
 =?utf-8?B?Tm9vV2ZHeUtGWmwyZ3A1WU5VdStLSDh3NjQ2dXVZYitLUWZZZE1ndlZUVkY2?=
 =?utf-8?B?NXFINU5KQzlnb1dBR2RSODVPeFR6R2ZQUXVobHZuY25oM3kvYmcxeVJtN1FE?=
 =?utf-8?B?eWpxSnBnZm1DWnBNZGdVeWdEWXVIQzMzUC9TRy9kdHA2SmN0aUxpVVRVRWJG?=
 =?utf-8?B?ME9HQVpNWVMxd01oSGZBaXFXQlJqRnMvR28zNStpSHloTnJEbFBnd2QwdkhG?=
 =?utf-8?B?dTRUckU4NjY4Z3F4dHIxR3lWSmRZVmpoNVNMeFZMcGhHUE5nSXgxQ2ZEdWtD?=
 =?utf-8?B?a2kyTVZZV3hEdndmN3RORHNMUkRRSE1DbFZKVlR1cXN1Q1lTdWpoU2pjdkEw?=
 =?utf-8?B?VURnb1BETStmQjlXRituZ1ovenlucWdNRFAxYldZWGpLUTVYNEZqL1UvdEN3?=
 =?utf-8?B?OFB5RlNqYkgrSWExa213M2VNYXJMemsrWFFTSzVNdk1WRzRSUk9kUlN6QXNX?=
 =?utf-8?B?Zm0xMW9HeXIxM1Q3Q3U5WkYvZ0lLYmRBamZSWXZKdzVLcXBUaHhPNFRSRmpx?=
 =?utf-8?B?S2tNanVCNzBNZ3lkYVdUWmpERHJ6alpCL2pNbXBhZ2syeE5GbmJpL2FXSVNL?=
 =?utf-8?B?QSs4UC9pZDQvSXhiK3ZtYkhsak1Hb0hzMnhkRzR6a2U5b3lOamxTb0VKRU9B?=
 =?utf-8?B?Y2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XS+3Gfd3r7JK6uf3vuXKpIhuwtY/f9zkUtdPEOoYAjJLossxZC9If5Oe/IIjcaY9dPIsYe9qmw3PiE8RfhldolbwiYyv2d6jLbqvKLGIArsSfo7ExH1h/huI102eUj4Txn4+S7Ml+iErCUciYud5RBuGzDpWx1qv6lToFad9+iUJYjELdm9MaYhrKqaKvfC2gmsz5dvfRoB0OlWY9qCfosbEN+FNy1+2OV/nzulxJU7klSak2HPzbQbS+B6PKUyjoRZzna33bhDS1oE0ug2iGVRnBps2H3dR6sqaiv7TWVqNkmvgxnFs4yy59zaSjYbxOSCDumRJOAOcoP7KNdAFVIMiloBcOIPadRsJoipVTbe5PRJ1w8IAGtPEMV+nTvtpwRB1GjEVj58yhLnIPPIshF0i4Iz6F5poxJpfRLtTqo8uKWNdi+6nAOvkH+QxoqErthcZo0hP8HE3ghon8NgGVUhgqKIuku00CbL4eafLIL6lfojJyEcpNMQT7Zk/afD8cPncHNR1Ev13RX5+SfZPwa8H5QVCzOoQhvk6vQUo4lEMBWl+Fxu3+J/GtaGia703RbCrZBeDNLZUWqNaUR2BBP8D3XZgKWjgMOmk1HDk0Kw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac6104b-6b09-4d86-1568-08dd30ae9fe7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 13:07:52.3857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBDS0/6fXhQFM7ZJU2agy3jfPLk87TcrFyxu5Nvpfn0MuypLReWNntpCeoUa0Lu0y41ItwDXJ17nXTfLnZ2SQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4246
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_05,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501090105
X-Proofpoint-ORIG-GUID: vWLadaaA67q0Fnfun_WlW2ZpCjV7PUfy
X-Proofpoint-GUID: vWLadaaA67q0Fnfun_WlW2ZpCjV7PUfy

On 09/01/2025 05:57, Christoph Hellwig wrote:
> queue_attr_store() always freezes a device queue before calling the
> attribute store operation. For attributes that control queue limits, the
> store operation will also lock the queue limits with a call to
> queue_limits_start_update(). However, some drivers (e.g. SCSI sd) may
> need to issue commands to a device to obtain limit values from the
> hardware with the queue limits locked. This creates a potential ABBA
> deadlock situation if a user attempts to modify a limit (thus freezing
> the device queue) while the device driver starts a revalidation of the
> device queue limits.
> 
> Avoid such deadlock by not freezing the queue before calling the
> ->store_limit() method in struct queue_sysfs_entry and instead use the
> queue_limits_commit_update_frozen helper to freeze the queue after taking
> the limits lock.
> 
> This also removes taking the sysfs lock for the store_limit method as
> it doesn't protect anything here, but creates even more nesting.
> Hopefully it will go away from the actual sysfs methods entirely soon.

Do you mean that the sysfs_lock could be removed in future? I would have 
thought that queue limits lock could be used for the same thing, but I 
am probably failing to see some lock nesting/ordering issues...

