Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1590415ECD9;
	Wed, 29 May 2024 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717014642; cv=fail; b=kWwLH8GmyCfaOx6kZCgnnIpJxEMZHX6jxjxRzrRckFBkgJs1o2uKIwGmyzboqDnJqxICSmZobe4jNI9zkUoDjDIQBqQEbRjDjeAnvwriE2ZBdHzInX6zzjxp6rUD7wvptebMus+Gk3oWTyA/zvZwzaOGuVDX7AYeUz4brN2CwwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717014642; c=relaxed/simple;
	bh=5WOmHo4qmODgxk+YDJl60neaBLrVAaVzmbG030bsLBM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IjYlj7NlbOn2aJermCKvVgJe1Ve6wSHDcmaeAdRrzL5lHg4Wm6HCkJD88dwtnLCgpmgvTmCzY9RdgDgl8E+Yt/bvbk63xYLg8HDxYGnGRyvkGrzkGa9zGBzm0nlSdwStBRSZHSFfS2NQGiZlYtF14ULi5s2hf9wHG+jJgvPouE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44TGY31f010221;
	Wed, 29 May 2024 20:30:35 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DI8vttJDm2CGjPrHidy8YcgJIOh/YkzeXrZtixyxdee4=3D;_b?=
 =?UTF-8?Q?=3DQYoaVhk5iPEJMsOBJFvjSoNFiY8xDJHk9uosNkFX1G1XRTlG9potxkGgtPZR?=
 =?UTF-8?Q?Jqqh6pVD_O1JhDzEWbO64K1XX6AKoZAT/DiZisBYjB08Nxox5ely1Nz4L2Cuhl9?=
 =?UTF-8?Q?G0BVaP4U6Hc/EF_I6BADt+RxfDATorY/7kLK6IRV3XfGDkb7m5yY/7D0AirB322?=
 =?UTF-8?Q?TUTKEMMcz6m51ffu2TAG_g8DVqZ1Go+JJ9ZH7/tbPLGgUvzpZTIySAX53jjgAI2?=
 =?UTF-8?Q?xjxSy9LTO8uDNjpuys+TqF72aN_4CIb71RsFTBnf1JXdW205hZsb0M66aRaO7A3?=
 =?UTF-8?Q?1deyNZGpRencHAiEdlTofg9HfTokjmG4_jQ=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8fcfk7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 20:30:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44TKO7RU016544;
	Wed, 29 May 2024 20:30:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50rptr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 20:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klEuEA3PFlrgIZbLJWtxCxafmkZnatEJhpunDUmsIO4ZDzQ1Ivdk8ce68KwG5x9Wo1HwNVcykC5hNs47zt9qoRRy2rUeimP5ElAfMqgipxP8KUsch2ORNv4BgIs+9jFqczdvAM5q+2Obl5PxSkf4/1Bt31n/mFfvB719B35VYyjRLUDRAdbpT1RleR4NVnwvoe7cKSOeKWWZiiaBT5JbnbzlhmG0ozmpqpgKZ2Yk5nIMYgash60hetATcNLwvxxl6OqMhS9xZycfiBJ1y1H7JJcQE0wmLjQOAOOU7EloMs5ao3x3iQdqTTtiSgRHjnVROKiPd7AuO+xYaTpVVnpSCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8vttJDm2CGjPrHidy8YcgJIOh/YkzeXrZtixyxdee4=;
 b=eXs5fSX1kP54HwZVg8gsqYs976qn2fS4FYp6k7+pOFhamZQPjqJR8bM8PXX8F5nWV68ap20Dkvf2elPVYPEVgZ1nW1H3z0lM+lNPa0m/+BI+9hhkF6xvSL+iEe7RdlPHEHL9zNaXRsJTKxzCs4sW/06AxuKocq7e6MfmCri+7b1ElWgZ0muDHGs0z2u3KzVNhCYp1ZyxQb1/+IJFxMMPcGkRaTgiY4HHig90JhT+2c8N+ikR9ZgYT4H8tE8apmUGsifh8eyTeaYfQnpA/vXP9Kl/wnEHwNSLDO/a/Qqllc6vEE1d6DoG0k6SjpExt/Pdy4lv8s5I8/Q0873gsQDDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8vttJDm2CGjPrHidy8YcgJIOh/YkzeXrZtixyxdee4=;
 b=zNmnqX7GXT5Spz9+qJ5gkJzof7v2VRppI6Gs64XKkPYp6gUdgjycKNgMKwQkuH2V5JrW1ACPHr51noKE9YX93EljCjILKJy3I567wmQqfenQXo5ikq+uFlmSzerMA173Xr+RxyWd3N/+azejK3P+92twZO8B6gPor4q90FbZEhU=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by DS0PR10MB6126.namprd10.prod.outlook.com (2603:10b6:8:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 20:30:31 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%4]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 20:30:31 +0000
Message-ID: <e092ced3-7c61-4548-84ec-059289ae1f26@oracle.com>
Date: Wed, 29 May 2024 13:30:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] block, scsi: Small improvements for
 blk_mq_alloc_queue() usage
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240524084829.2132555-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240524084829.2132555-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::23) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|DS0PR10MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: ed7e3e33-a4a5-4523-e329-08dc801e2f7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SmpReUkvbzRlMHdUOXNMZlB0ZWRUNEcyVkdCMlluU05ZZ3FkNkJrT2pPTDcw?=
 =?utf-8?B?SzFpYUJJMlh4cm1XY25nRXU5eFJuc3hrNmNaTFVCbGw4VTB3TnBNUzBXa21x?=
 =?utf-8?B?N0FOTk9kTmJ4TjQ1TTJUeGRLait4RlBnQmNqbkYrZk9tUXFLUG5YUzRvRms3?=
 =?utf-8?B?MHBWdytwNGV3WVJlc3c5dzhMR1h6RnkxOVBBd1BVOEFEUDJQWDc4YUlHSVRw?=
 =?utf-8?B?Zmt2dkpQU1RiSTRzd0NZSloxWENYN1pxUEJJMS9pTmFCODlTbXlFKzUvSHdF?=
 =?utf-8?B?VzV4NGg4TEw4TVBSQk9pVDBaWWdSbkZtMGdYcDVRc1NLa2dGbWV4cEtMa0lW?=
 =?utf-8?B?TFFmT3ZsWGZLUmtBVFEzV0FlZy9FeFFoZEVudE5ZRzJjU3VWYmRsVGRibm1q?=
 =?utf-8?B?UUxtdUc4dGZHRWQ1L2Vvc2FqQnJvU2g5MWNpNXE2YzJRM2lveGdCRWRHSjQ3?=
 =?utf-8?B?MHFzTlZaZzlmcmozdFhySCswQkZUNmk5UE5TeklEVkNkRTg2dnFVVGdXRzF0?=
 =?utf-8?B?Z1JkSmVjWlRTaE91bGo4eXZnN3ZWaW5sY2JYNy9MM3VXRlNLRTBWNEpxY24y?=
 =?utf-8?B?aGIzZ21BN2RYc0RxbE1GaXFkam5uT0pFL0FnZzJtcGtyZ0kyMGtSaDdsUWdJ?=
 =?utf-8?B?bHNySWxNelFoWXB4cjJDTkMweVNOcTFNNVJVd0xNOU9xTXZFaUV2QjRLK2tT?=
 =?utf-8?B?c3pEOW0ySk5pNUFlSGpaU0JBVUFHaWhmMnVOd0JONVNlYjcyc3lOY0tFNEZP?=
 =?utf-8?B?REp3eGJ1TXNZTEMyWXp4RDRGdTM1R0J6dlkxMHJLYXNQcmhjYU1lZnMvMVIy?=
 =?utf-8?B?ZW5BYjJPNHE4ZW9wVXB2SFM3R0YvaTZ4aE1ta3llTnBTQkpyWXFCby9lMVdj?=
 =?utf-8?B?aE9neko3dEZjMW9mK3BDZk51MHVrZ1B5aEJDeXJtWGd2Z3F3K0d5NUxFL1d3?=
 =?utf-8?B?RUxzTUl3b2ZWVUc5bUR6S2VBcGdSQ2FPUXBSdlFvUDRPOTBaMGpzQlFiUzF2?=
 =?utf-8?B?a2JIanQ1cm8ydTl3dEZobEdPMC82SzVkTUsyOFZHa3Voc0RyZ0tjRTArd3Nt?=
 =?utf-8?B?bC9lTjFuYWVETmlMY1J0MWoyU3hyNkxWenNkNTY1Nk9rWDFPdmNnRERMNVhW?=
 =?utf-8?B?c3hXWnVVc3RScllMYzhhOXVVMzNYT1hjUHZkMllYTFgrTGE3WEVaMFpnSmlD?=
 =?utf-8?B?WWlReVpNOEgyakZIN2NtZ3M3TWFjdnIxQXloSDg3MzkxSHduTTZ0WDdkZUg2?=
 =?utf-8?B?MVR3UXVRUVNjRm9QemhkRnNZOGJmVGJ0MjZyUEpEMkVGdTg5V0lyTHU2QWQ4?=
 =?utf-8?B?cENlVGhsZmRHRER2OVQyTnFlWTZUSk52Z29jM1VhOXVOOXh1ZjB0STVjMjF5?=
 =?utf-8?B?Z3lQcndQLzd5ZkdsQ1JSTGttWTJwcHBoTEl0cnB3UXduRVJrSzkyMnFtODhv?=
 =?utf-8?B?aTJBQkUvRitFTWkxdERpbWNVZFlSRDRDYVEzVTBBandxNVZXWDNIck00LzJL?=
 =?utf-8?B?OGIvc0FNS0tZODkvbzJjenpTZWlzcytFcGxmNm92QkdWTGU1ajF6cUozTVVn?=
 =?utf-8?B?OXZndE9JT3lmQ1VFeFpneXJMSmJVdnBubE9zZmxlTDdPdnBOZnNyOHRhZHRu?=
 =?utf-8?B?MksrWVgzeGtyemw1UHZiTnFIZGFpWGl4Y29RcEZyaXU3NG11VmVnNjZ1a0p3?=
 =?utf-8?B?Tlg3eVBiNUlaQ01IamZvYWJZTW1ON0VhalVlOEk5OEhucWhLZDZvcmdnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?L29vZVlnd3Nsb3pFRjF6OVpHNEFVWjhnT0xmeWJXK3FXTWpuK0tveTJ3VnBu?=
 =?utf-8?B?OW4yTkdUYjNtaWx2WlMwZGRrbFd0L0dLeHgvOFdGTDhKY2d2N0hsMzJWdEpV?=
 =?utf-8?B?Yy9LL01hYzIzb01tLzJWUWVEU0FtTnc2RFpuai9jSkxzbTRaNnVMUTFQMHJK?=
 =?utf-8?B?djRwcFRyZlhXSnh3cERCZWpYRmNPRjMzenJ4ZHFUVnhpRmttODgwRmNuNjdG?=
 =?utf-8?B?U01OL3FXYzFYVytHaGI3aEx0LzIrdVdiaDc4aE5jWjJwaVYza3hvWnJNWnhk?=
 =?utf-8?B?TUJkNnBZZEFQNFE5VlhoYVJxODllZE9JUHBQLzNaUzYyTXcrZmY2TGJXWFRF?=
 =?utf-8?B?QTJjek9RVkUwZXlpVS9kNmZEOWxkZjZYVUtaeitQZWRFaWN4dEV3ZFU5MlI5?=
 =?utf-8?B?SmhEekQyNE9BMDY0ZXhrakNlcW9SYmtaVG45dlFLdjgwM1k5MHUyczl5ODl1?=
 =?utf-8?B?YmZPOGd3MjcxUGtlMEhTazhXeVhQREUyMDUrMmVUZEpoS2E5NWtwcW1WVEFG?=
 =?utf-8?B?ZmF0QTRpM3ZVbXU1b2tzdVBwRTdhRTIrd2ZYeDdMWXFIb0xQbEJCeVFQTTE2?=
 =?utf-8?B?SnJIaXk4QUNEMW9Wd0VreG54U1huT0NtbU1TZGtyYmJKTnFGYTlqS1c3WUsy?=
 =?utf-8?B?bFNCWHd6REdzUlc5MmF6Kzc1K2gzR3R4cmNCNjhvWk9IRkcrZGRhOFJ2eDQx?=
 =?utf-8?B?dlpZdXR0SFN1RG5VSHlLSWJocG1GVUFjK01pdjVjdU55Um9pQWhBOTN6dnNo?=
 =?utf-8?B?dU5LUVJNQ2JiZFErZU4yWUlSSGNhbXBndFh5Rkt4WVlvSGZMZHNvQUw2TGxw?=
 =?utf-8?B?REpEVDdFVnczb0tyVHc3TERWTkxSa0ZWNllFUWoyVmhDRXdhb2xPd1oxZjJ2?=
 =?utf-8?B?NTJxdDladVd3c1RUeE14NklSZTFkbXV5ckI2QVNIL2VBV3krNUJlSno1dmlm?=
 =?utf-8?B?Q3hxOXB3T09XNEZCdVo0VEozT0xLeE54aUFZeFdMeCtJNDRrNUt3NEdSTm5B?=
 =?utf-8?B?ZC9LVlRrRS8rRzNnUy9Gd2VaMVVHNEtLQXNLMFovY1h1cHd6ZHdZOCtjazdY?=
 =?utf-8?B?RzBTSEVMY2NSOUlQTXNHQXdpVllQSklEcTh3T3dVQkxOWXpGbVN3L216Y1FL?=
 =?utf-8?B?WEdpVmhOVlR4em1nUDRDdzNMR3A4dEM5Q2g1Q3dIWEN6OUZZeEFwYmFyS2lW?=
 =?utf-8?B?ZEpGNHk3dWJqcHB0Tjd6bEdNd29zUjFWZWNqVkJzOEg4NVBWSXFYeHVneW9J?=
 =?utf-8?B?ZWp6eEpVdng1dWZVa2pwMkNGalhxb0ROcHpmVFVFOEdtNWRIYldSbytxblJ6?=
 =?utf-8?B?ak1KVHZXS3FUZGtNcU9VZ3dpc2o3NWgrdjNlcXROYmZYS1hxTzM0YTd2ajZH?=
 =?utf-8?B?UUdYNUpvcmlOMUtnTFRVeEp4UVozcjFwbVB4ZUl4TU50blJCZmljcStMSFNm?=
 =?utf-8?B?ZU1TUUx5dFJrQUpyTWpuNlZVdE95RHpkQmF6c0tsTHhtckprcGFzS3JCQy94?=
 =?utf-8?B?eG9oQUZ2Z3RXRXNheXhCR0ExRkx0bC9vdGRmdGZWb2Y0M2JlVzBSc3ovbVEr?=
 =?utf-8?B?WGFCOEUrR0ltaFNOb0pTOWtqZE5hKzl6bTJZaCtxa2FTWDRUbEg2VjVhM2oz?=
 =?utf-8?B?dHpTQ3Zrd0Rub3NWNUZMTkpDR3VWYzVlT2pBNVQzdHN2NDJHMExGNlB3VmE4?=
 =?utf-8?B?c2xXRVpqYjh3Wk5iZkZ5WFVZMlFoZGR3WFNFQVFhbmxMTUJpWTZmQ2JqcUlD?=
 =?utf-8?B?bFhaZ3hueXYyaUpZUzduVWlSTFhXYXJZQlE5TVZvT0tnZE1kcGRwaTdjb0E1?=
 =?utf-8?B?OWJZU0ZWRlBaU09DTlB6bHJRd0xKYmlCME9va0J5Qmh1NTFDWlh5WjN0WEkw?=
 =?utf-8?B?NGRxemNFVzVFOVRyYTRUalNQRk9ldndPZHowS1NyR3UvTktMcExwa2JWY1A0?=
 =?utf-8?B?Vmpnd21jMlB5QU5VeUU1UGNaTUlSQnMvVDZpbi9XQWhhWmVlS2E5Y2ZRaFJE?=
 =?utf-8?B?RnNKazRja3RhNEs5R0pRM3Q4UDA3cFZ0ZVN0MjVBWDJvbFI0QmkrZFFRYklR?=
 =?utf-8?B?M3ZLTVFsTmxiK29DUFFYK1oxUS81WWpLbmhJQUd5SVE1VzBoRkMyaFZWYWkw?=
 =?utf-8?B?NjBBYjZ6SktuYXNUZlJ5TElsSWkxSmtiMXZ4STJtNFFkZHp0S2xpSVU1cURB?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MA/oSq0QZW963S0VmqrzBHun+ZHA1qT+I33XLqYqAkQPfPHDnBc05QxTFGynY6vcsTPqE143LHeXiTXCibvdzs3GBqswrKwM03xapx7J7Tm159fM31Q19ybIwO6s7ZoYo6+NPxnnUbUagnZKUzh/Ivgq/ZNwdpw6wbVl8QyM7d0VVuZNERy9ijrSb7TsC4hySzuoTR/KxD4dULcWD/foqBG1EdWj7D2au89+gIQRsDSvmO1piDQN5XmAI28Eo4RT+haq5HYdeRfpvNiLl7m+SPn6jlFXrx6/Ge6H7d8XXkqrrxabx4f+VzLtqO98QzQPH12f04KsWs27/sODguDFAufejj6XfasPbH2vogzvH1WXPPRJ8+pD14chu8pmS2BQyCEfmr6sFRrXPwm91k8Nsx/PKeSKHe4UvRSz8o6y+PgH3sdH/b4MoGQ6I6bauUbFuJs5N1V0bENPyLBfHrZHGWKTs/N/gsWJTlEgp1FuTAhWMemEy43bjR122ABeYmgju6lMDYREW0x3HsV0r/x7XxzL7G24kKao+aoycEAiAAhMP3lgcgCWWVxJvlq6JPNTQIaDGJuhZ06SN46xhVHH2kWEJJZeUq5WE/T/MuCfFUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7e3e33-a4a5-4523-e329-08dc801e2f7a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 20:30:31.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNimTvjzpdHPCE951IOXHGr2eIhw8iv4ZzymaGdDmWLoS/2E9ksiKdnUgE25lhG72PT/VUa4dQjGLDFAd4T2TXItlXk2gCrf8CukDpSGQFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-29_16,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405290144
X-Proofpoint-GUID: vFUIcoYOlxGzth49rPgxa2RcDlywowh2
X-Proofpoint-ORIG-GUID: vFUIcoYOlxGzth49rPgxa2RcDlywowh2



On 5/24/24 01:48, John Garry wrote:
> A couple of small improvements to not manually set q->queuedata.
> 
> I asked Himanshu (cc'ed) to test the bsg-lib.c change as I have no setup
> to test.
> 
> Based on mkp-scsi 6.10 staging queue at e4f5f8298cf6.
> 
> John Garry (2):
>    scsi: core: Pass sdev to blk_mq_alloc_queue()
>    scsi: bsg: Pass dev to blk_mq_alloc_queue()
> 
>   block/bsg-lib.c          | 3 +--
>   drivers/scsi/scsi_scan.c | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 

Changes looks good for this series. I tested basic driver load/unload, 
as my setup is not connected to any Switch.

Tested-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
