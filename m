Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEA512F59C;
	Mon,  6 Jan 2025 10:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736160040; cv=fail; b=KqsOUeBitg94xzUtmvqqPilzMi7PvcOuViS8ylCe9x0A/NfMOxQvnGIRgkk5JDo9ix9czqwhZbfxJr+O4MJ/ifJM2ZwEdLgnn5Knc4BpGfeEobbrUYXmoqGUIsWPc6PfmyLyOM9Vl0+is6YOqCYIbQ8APNHoHeJfXCGyCpoSl4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736160040; c=relaxed/simple;
	bh=OKejZdebz4DU637Y3ZzyyVdxUrHMJBMmWFuXw5QcyFk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jz/ZG7Tg/0skHRmxPPlJpVbvcrRnVGAGTUiUQKm4RcQWhfr++SHeR+KYnxK7CmXOwiWugmv62XmHVLe3LG1j0p7eFdXtBXAucl6CRyxnNstPtF2c/hSFgKsIrxdXrb64iEcfPdBp9Rxec7hTkNF/jI7hLqLub650LEYftjia8OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AQBtSY/f; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=we8fkTSJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQBtSY/f";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="we8fkTSJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5068uO1b012151;
	Mon, 6 Jan 2025 10:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pGtaQCtV/OxRdUw3Q2EAaQOVB4uNHMjWVIKSc/jWnDw=; b=
	AQBtSY/fRSTlWwu3/QiYZX4oO5ljP0N4NrHqUJwFfnThEt6ly3lWXaErjMnpcj3Q
	JwTVonxqV7VDo3Rij08YOhdDv9lAf6piBUCIVfhP6DuvLa3nhxxrBthSfnkhvx7O
	+D4B1oU+jqAwPHKfneHTHe6dKAgfWiw/ES37Z/q7FyTPyR7PK+MpJNILtWutd5nN
	na7zZXQ2AkIYsiB3QOIVlMbyOiXRRDQ1L0nbVZwjK9eDJ8ZUcfEP6ZM9dtX0CtiT
	t2RxFLaltKTFyxn+8xaD/qxRUH4TiGkBXDAQHMhOEaVZE0xyYVRxb0MLsqawGzcH
	J5eysbyD4bC9tDyU3OmZFQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudc2grp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 10:40:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50681bic011203;
	Mon, 6 Jan 2025 10:40:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue6w408-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jan 2025 10:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yexMHNj9vlHMvlzs8AuY1VXSFGGojnqmLtawK1z3oI7TZyaZGEBUZ3/j+ld3YoXFzN/2p9Pjw0oaxZAGcEhptI0s9KEYC3P0yCrhWLeoadCBYPw0LJBT8EO1KEa8filsSeXrsh/Rt335Ij2YIGiUZdx48Ml4I0kwFg8dN6OvpDuMSvgpY1DUa1/lmIhoJ7UPNHdQVmKdHK4qUNNMTh0pxHdVhS2xHrvpON1/YE8XAbPkj7mGYBefz19ezsFrxvulCrjEU8gEhLfO9/nO3sGbg4PKSa5KnqCqCyj4N4h+Zomn4z1/kkwFT6BDuoTVHcom3nmJh7I4kUEjGkHe8YLyNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGtaQCtV/OxRdUw3Q2EAaQOVB4uNHMjWVIKSc/jWnDw=;
 b=ohhRyec9ADSfS+ZPD9MikB1SMfpMDO51PD6eHSJ2KLC4HEgtMRuf3Ubiiq3eYBZvGcw89goEKYxIWvbuscmS/aYDQs343Mp+hqrqVqFi6uh4TT6/+msvxR4BMiarBr+1Hpw5LrHLKT3t7P/nJTSnFd4Wr6NclVRaKS6j7H5QA43C0UVoDZOXX4xr+Y9nuPm/wHDpNoMNortDiVNpuSVpsww2WGY46e+4HrgmYCGJIWyiormZSX0zrj28EGf8cIAT8nX8pGZeRGrbeYDb6YBRBuiINhLVfb7WLD/L1s65lTEFJY1DHoahKYSHIryvk8OT9mpdWZU35MWe0rwOv0CjSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGtaQCtV/OxRdUw3Q2EAaQOVB4uNHMjWVIKSc/jWnDw=;
 b=we8fkTSJgHpe+Zvi0+asX1dnbUVKGKeLvzNCsipzqPzXZqDKqtgfLb0RCfumZhLiAQebHTYm/X8f2C9NJEwg9tuN6eO2dgx7P0zisI0nUbld9jxfYjoqWctIlyR4Mo5CTCGV0T0Lw1WUaC+lf6grcpTuVU3AWZ9Pw3skL9KOxoU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 10:40:24 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Mon, 6 Jan 2025
 10:40:24 +0000
Message-ID: <53fd9bd7-101f-4cc2-afa2-a87fbcc3bce9@oracle.com>
Date: Mon, 6 Jan 2025 10:40:20 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] block: simplify tag allocation policy selection
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <cassel@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250106083531.799976-1-hch@lst.de>
 <20250106083531.799976-5-hch@lst.de>
 <10f1383a-fe7e-4cf8-a15f-14cd4385a7de@oracle.com>
 <20250106085554.GA19343@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250106085554.GA19343@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0279.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: 69df3d42-1097-4705-0d13-08dd2e3e86da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SmJWczVyL0hDWVc0bWZMSkdaQlRRZm54RVpJTng0VThZT29rMk05UHYwN3Jq?=
 =?utf-8?B?bDRFT0lQMlp4UlFScW9UdkxERWdRSWYza29zWktVdHMwK3pyRm5JNnRmaCtp?=
 =?utf-8?B?b0RJc000Y09NVTRxT09MS0FCVlNETlBCZlRGNUx3VE15REJrczlKeDgyUmNW?=
 =?utf-8?B?Y3kwb3kxemF5cFR2bk4ra1ZxZG1uU0lYWFQydXB5aVNrM3BRdi9xYnQ3VWg5?=
 =?utf-8?B?M0pJcEk3TGRZU0dKN28xVmd2U0FxcjE2Q2ZRQ1pHeEQ5VjA2VThhSXZHZUJQ?=
 =?utf-8?B?V0YyTWp6d2VQV3Mzalp2TGc3Nm01TWQzcWJldXkvMkdLekkrRGZ2M1hWSWhY?=
 =?utf-8?B?Sm9hV2lxdXZjTHZqeUtRN2xhWkhORnR0Qk42WFNUQVIvTlErVUZ0UkFkWEdO?=
 =?utf-8?B?clZ4ekdzYnFjeWNUaG1iY2tCQ0ttRXJiYUJDVVlBMjFhMlAyY2tkVTcwVE5t?=
 =?utf-8?B?YnA4K0VnTnRMdjdTbnVqVTRDL1dwZ3Q2UDBSVjcvdjBnd3ZXejJZZy9rVC9w?=
 =?utf-8?B?ZDR4Y0JPNnJkTnBRYXJwTGZpWktKekxtdFp5bTR0WmhwdXdmYy9LMjEwRlVy?=
 =?utf-8?B?RFRHeXRGSkMvSG1PMXdmVjR1S3BBTFNyS0Q4WnFXWGlJQmJoKzFIOWNGeDhw?=
 =?utf-8?B?MkJFbmc4bitzb2d4cEpIeURnajFoc3NVUzBtb2JDaWthWWRwbDRPYUROYnV2?=
 =?utf-8?B?cDhkN3ZpWXVjRFBRS3hFbkVZK2pjMDd6clNxb3U0WUtrWkg3K0trWm0zaWZV?=
 =?utf-8?B?NUVXY2J2MzRtQTFhNGkzazZyV0RpZ3VrMnI1VVhSM2poUEMwYVlKVitYTEN5?=
 =?utf-8?B?dmlsdTR5cDVrVUIzMWxiWXFibXFwaDRYWFZNSHlwRks4MEd6VmsxeStSeEli?=
 =?utf-8?B?VzRuSS9Ed0d0cWxQd0wzZ1R0ZGV3YldTeGI0VVFOTmdPNmRvczVKWEVvQWht?=
 =?utf-8?B?cGtISFdRVTdyU2JLSWxZV25ZMlV5VXdEa0l4S2hUWFEzaWJzMjZtdXlzRllH?=
 =?utf-8?B?eEI2WkNTWkQ1RmloMk4raTdtSCtoc0lqdURGN1FPdXYvZFVMcXJ2T2VnTFVX?=
 =?utf-8?B?VzRFcE5oQTBHckJHVHRHOWZFZFJYam9xbXh5MXJTa3VpMW5uUUFDVHhFK0Jt?=
 =?utf-8?B?MGp0ZDk4UVo3bXRiVVljVXBwaWtYR0FSRlFzZENEN1AvbEpwR3o1Snowcys2?=
 =?utf-8?B?UVBhNHI3bUZHZjBTdkVMRTVLMTlQeHJ1UDBLY2ZOd3JOcW92QkhKWjhKbDJJ?=
 =?utf-8?B?cUR5dDNFQk9NL3dOa2tkY083L1JVc0NwQlN2bVhIbkJtZnEwU3MwL3llekgx?=
 =?utf-8?B?bHU2eGdnQnRnMk9SU1dJWmhacld5NU45Ym9hVEdnTUxkMnVkSjY3UkZvaG9K?=
 =?utf-8?B?dXE5V1c0UTFIMDRJVEg3MnFiT3Z0QitGeVExdG0yMERma1BUK0gvUG1Ealhr?=
 =?utf-8?B?SmlqdWZlTnRUTFZydzNQRXl2M2gvN00xeWxZTGNjU1VkdkU1aGE5ZE5QSzd4?=
 =?utf-8?B?SGI5OXBPU1pKVkZ4MDkrYm1URVFNcXkzT2JiZFpqdFljMHI0TzJncW9OQVlY?=
 =?utf-8?B?b0hOOGNvRExmYW5wK0dhSS9Qb25sV0owdXBlMGVYOHEwNkVRNFcxTGNvTDlK?=
 =?utf-8?B?ZWFXcU82Ky9TTmdIb1NXN2p0ZjJteC8ySk90MDVXWW9pVnV6a0JRajBPaWVO?=
 =?utf-8?B?cGhTck5UOFhDR2hWRXJ6aHdna1BnNkdiOUgxNHB2KzlxSnFwOUQxN0paVEJM?=
 =?utf-8?B?a3dLZ0dZSFdsckk2K0ZFWXhacXBZNUdmL01xS3RLWng4eEJwT3VEMm5qVVNN?=
 =?utf-8?B?aGsrK09MWmZBdW1IUjBKNk1QekdBeTk0VWc0M0V3L3pQaE5TOGZSdWNDZU9F?=
 =?utf-8?Q?Tlp5eDjn+V/9g?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnI1VHowK20yZ2F0bEh0RlRZai9oeElBQnd3VUlyQVNvMWloM3RCVDJMVEZF?=
 =?utf-8?B?WFUvSGNZei9CQVFBSjRSREg3MThLSGFEUTZXVmY5TlhoTnBDdGxnNHJWdHkr?=
 =?utf-8?B?Unk0VHNFTW5BRW9ITEdYWlBjYjZnV25JMmViRmZWeE5aWEZMU0dyS2hvdkFk?=
 =?utf-8?B?VG9Wak9zV1p6azVSYmpFZWtGQ2RkV2ltU2J3Ry9RYjYxZDJPRytNN2tYNm1t?=
 =?utf-8?B?R1FhYU5pSlk2dmhuOU0wOVRCKzM4MUJ6ckplU2xnZGxrOHpITTFxUG5QQ2V1?=
 =?utf-8?B?WUtRTjB6b3Zaa2wwNWhUTExDYXFWczRIV3BjV2RQMW0zbnkyNWszTVRGOXBx?=
 =?utf-8?B?SUxXVitxcG9KOUdZWDFKRkJiQlk1c09pUlFmSldDU1dPTEEyR0xuRWUwSERR?=
 =?utf-8?B?dFNLK3plUzROMWxVKys5eXVQVUQwdzV2Tkl6Qzg0L0xEOE5xRkFxQUxzdW1R?=
 =?utf-8?B?S243ckdSOTNWNE85QWl0UTFKUjJ6Q3lVYVFJV3ZwWlU0V2lkbUVuY0VNajZz?=
 =?utf-8?B?YTkrdWx6VmZwUE1GdkRiNFRPbXNabCtvUHQrL3hwWHBZYSs4b2ZZTTE5UkFo?=
 =?utf-8?B?UlFPVS8yc2xtVUN5RklKZDJ0VUhRNXIvck5LbnVyNEFYcTREaVRwMUFuU0tv?=
 =?utf-8?B?a3h0RnR3RVYxRUtYaVI4ZEFFR1dGOTIxNm9wSWxiUVAvTVJGeU55eUxpZ2FZ?=
 =?utf-8?B?Qy9EUThBdTJDajAxZkhpNkZOOWFONjVIWHFpK0NBQ05VaUU0NUJpQXAraVhG?=
 =?utf-8?B?YzUzdVd6UWd2c1cxMW05VmhtaitHNExIM0lsYmdaMmVNZDZGbitwS3J1V2lD?=
 =?utf-8?B?NTE5dW03dExyTG1oVWJkV0dobUZzSG4xYllPcTkvbHkyRUxjRHgvSEtkam5X?=
 =?utf-8?B?b1hpMnZxTHljNWU1WEV1YThvRVZYRG4wK1ZOTjBta1VtZU1XRStybEJGcUg2?=
 =?utf-8?B?SXVnZUcwdTEyS3Y5YkYxMVZjcEdLb1hoQ2tSVTdXY0twbTl4RXNlR1FOdjVR?=
 =?utf-8?B?Y01ZMTRsbGp2R1FBTE81NGc0ckxldkFhL1BlVW1zMGtJWng4N0RDaFQxRzN4?=
 =?utf-8?B?SVlZdmdyMDA0UlVLRlZONHhKenZsMXI3MTZMdjRIVWZ0NUFGbTVUNlQ5OEFs?=
 =?utf-8?B?L0FCNTJaNmh6UUpqUlRSWXViUXJPSk84WnFUZ0RxNjV4cG1WU3BEQm40emV5?=
 =?utf-8?B?UFNiUElpa0JZOTh6MDdmU3BWRU1hMG04NWZyNHE0ZnBQRmFjT3Q1RThUU01r?=
 =?utf-8?B?WHd3eVd6NHJlYnpEUG5WbGlQVlA2WkdmTGswdk1zMHVZc3JaRFJhUGU5RkYz?=
 =?utf-8?B?NXBEemkwakpuMG5CN21lODBtSUthVExEUWdXUFdxdW1WNklLZ2ZOdE5tOFdV?=
 =?utf-8?B?bjllZ1FnYW5GV2VOT0xhRGNFQjFMeFZNN1pDN0VGNnNuYWNlZkZKNWFsUTdF?=
 =?utf-8?B?YXNjSVhDR01PTkg0WXhtcXdOcUYxRWY3dE4rR2FZc0RaanZDdWp2YTZZMHBq?=
 =?utf-8?B?cGdyeGRzSy94NThiVDlKUlg2YWFac1l6ZHhqOGZ0UGdURFhidEdiNHJvWndL?=
 =?utf-8?B?VWxPV1N5VmtOa3BQUGJ2MVBEd2RKZ2hoWmhNc3F1clhQYmh6TTFZamVjSkJG?=
 =?utf-8?B?Yk5RZkJKU2VFbjhoYVpZeFlrTWtDYkhOZDNsNVNmUkxYRnlGSUxWRHBnM2Vi?=
 =?utf-8?B?cUwwZ1RLOGZMZUFHTWsyUFhVdDB5clc1ZlEzWkF2dXlOTGp0VHpKRGo5eWpm?=
 =?utf-8?B?eXFDOW9IVS9odWNtaEVmK29vQWhnSS8vKzMwaEg1dFZDTXVwYWZZQkNsRlRw?=
 =?utf-8?B?VE95RUU0Q0FESTQ0NE9XV1p0SGpSaGxzajdtaWpqTjk2dFhEOWdxZFZUVGVL?=
 =?utf-8?B?cUlORTlUQ01mL3hiSyt1L0dETjhxUHhYV091eDJYdXpZVW5Sdmt5K3ptTm5a?=
 =?utf-8?B?Vk1naDV0eWtjSHBsdXZTSldoZ0kyOVlXZlBFRnBvcmplM3JyQjJ1a2xLSmJN?=
 =?utf-8?B?ZGhCbTdFd1BFdkFvdTkyQ2U2M1QyRThmVkV2UUZvc1picUJyZ3l0cHduOGF6?=
 =?utf-8?B?YTFYUGNKRWtYdEx6VFZJcFZ4UXdsTXV1NC9zdFZvMkIrMXo2cmRXOWhUQUR2?=
 =?utf-8?B?UjFZdC9xNFRlL0xaQWJlUm4zWlFsUHYzTWNXVllrVzFYL2g4Q2NvVG9QVWxa?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j+Z25t4NSG8w0AIcVmHzn+NtDGyOyvlEJwjWg9q5t94JL97PR9uS8Zm2ncxZcrZBkGTPi/FaQssGub+Qfyyh8eGT99Jsga3wK86eGNgqzpY2pnPi7YcjOfrM6+PKVFnObuoX4/eCFfcmEsJ/Yv98MSVEvorbAzQEmH1WYovIFuyBo3J+zvYErGEAHe0x/lI+kNriKVdslkgXzB0rbM0B2KxXwQBt5FGdZdkvl7G9V/oGe6sxSOYIeHBXy/NSjTLtgQYg7G7vVoekzFrtMqi7YzwG0X4lo3zBTVFH7PTQNhR+1DwEQYGTYGXlv77tZ8mIRqR2g0Bn7JTK7xJX+1H/C99jFYRpnq6hWU9Gwcwahip+Z72gayi38oGWDjJUwgj5WTbxoV5XIXgaczmaFhOiCqKk4nXn4gijIArDaIp3ucLQ9BfTmCxwai19PolyZDoL2Dcai4Pyi1JOo8uZKwDjCi7U2t9btvJI79ATc8H+X78FjEfoA8+Q/JSuOBxA6q9bVTL/r+A8xmTxWpMRA6Utd7VLEs1HC0kjQ0wwEQLnFR0VIVN82H1O1zUd0xVEuhoof85oHIjBTRhEedPA4o0MfVi4g776f9VdawsWCPg+VII=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69df3d42-1097-4705-0d13-08dd2e3e86da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 10:40:24.3648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHpKEjyLBZ5d4ttq309TJ77IsGR9OBiAwdprAjINJAfE50ybMaySLxOJ4zV/d2ZQFQmslZBYebRi8KsBGnbp2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=823 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501060094
X-Proofpoint-ORIG-GUID: nMWpBA2_fpRU5bYMf12_nMB88FDGZtO-
X-Proofpoint-GUID: nMWpBA2_fpRU5bYMf12_nMB88FDGZtO-

On 06/01/2025 08:55, Christoph Hellwig wrote:
>>> bool tag_alloc_policy_rr : 1;
>> Is it proper to use bool here? I am not sure. Others use unsigned int or
>> unsigned.
> Yes, you can use any unsigned type for a single-bit bitfield.  Most of
> the existing uses just predate the availability of bool or were copy
> and pasted after that.
> 
>> nit: coding style elsewhere in scsi_host_template would be to use
>> "tag_alloc_policy_rr:1;"
> Yes, but that's against the normal kernel coding style, so we'd better
> stop adding more of that.

I suppose then that the rest should be updated afterwards to be 
consistent (with the kernel coding style). That should be easier than - 
for example - removing extern usage.
