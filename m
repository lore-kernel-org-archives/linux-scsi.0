Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D636364D6;
	Wed, 26 Jun 2024 08:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719389292; cv=fail; b=N0eUM+IGVIX34TOOfcwvGq12ZgYlDIFB0YoPwtHDQNW+iCX7LcIil9BMdI5VQfBp2t9pC0p8+yrViRo074AK5pVcEri4mHi6Ca6XMqq/F7Gi9vYx2Iw2IQEiZW6EfSbnlNiQMxDEL4yWoaA5/xyTqOXZpMZjhz3qcEYsoMU0zvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719389292; c=relaxed/simple;
	bh=bWVoaOzZx3+ZIfeP9LGzzLXrdsofkfFa8AandJaLBbI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p8nKnBO2IVpzq7A0rWY3eaYvUqoduNqV0LcfpeCUs5e4FMl4xwm/yhY/Q7GYsIT++r3jER4gpOlNRDhHotG5c7sjSjIg20zIo2rEAFyStdl3KTBmiyKO0WfnWtO5oMRErQ9vP4NF4FDLk0vWGj67xz+rVjU6hVmvGzc7UZzwATY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J4+DlJ7t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jXoV9lNM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4+DlJ7t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jXoV9lNM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45Q7tXD5010719;
	Wed, 26 Jun 2024 08:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=bWVoaOzZx3+ZIfeP9LGzzLXrdsofkfFa8AandJaLBbI=; b=
	J4+DlJ7tBWKLQpBva+Fm8vRd0ePmvLsxkrGSw6h5HOGLuazMbdaMi+HLCKYkOEMP
	o+e/JcsS+muFNJQFIFlF+Kq78IzO329n0NCN9/ryQVT3e6GH3lLMNDxZV/gwY2DB
	SSPjw5viYsgKd8aQSb8iFjT/SnHX84WVUHqfogOrEX++QhgRgs7L0oAHBZ/Hhiwz
	OaF4+Nn3dziTrYYhIPfmsFlCbDpRq3Ipi/RlbKEogoRtdj2GFCodpsM1kLRYKLBj
	27POXtzKaQv7H8kRd3wcu28G3SQTe+a3KEfDI5/7MP059TVIHqIlKWnweSzx+BXB
	ZcbESxOnUsFOuCIbwc25aw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywpg9adu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 08:07:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45Q6M0qG023305;
	Wed, 26 Jun 2024 08:07:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2f80dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 08:07:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6Uj+/CeC9n4jWZ2is8ArUMUzqNXyoEKv23QFVg2qHzkqSmQtvXwYzYY1dKTLaj0f0jfhTIoDQ+IrYZq06/MBoD+0qQYRx777Py/dgWRuriv4UqGyFqMNL7qlatqfDyij5U0vZg2bA8hasPS0D6VWXK5IDNa0JC4UllCliLleTT/4h119+U5DBWiX/BFH0d4EovQKc3vdAIfz70cnrJd1km3ru2ETxWD6s6hXvWqyHuvxdJZSZFYFnCxVPAB8UfwKsVGi6PHgHgy25RAHZYugEdmLyAo6IcPF50JTf8iT/YVyQ/tvENCO9h8WcdY5mcbsaTO8LauDgZ/h1Qaugribw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWVoaOzZx3+ZIfeP9LGzzLXrdsofkfFa8AandJaLBbI=;
 b=W6fu4/+6LGKQm4b3rh3gYlDcwkXSrfqcY9OzRjvx7/erjKDwEKJ0w5BgDRfUkpAp/okwvWZAvo8xlGLfToxGbg/g2J4Swu1BLJOHaLmxrfZhWVbytkdNhwpQJCqC2m2kbwzze/XP8pQ9s2dUrE5VzpuanfSOSF6wD71jBFZzA50etXTDxnKqcLeASSnKbhe6MSLO7vTR7C7imEMlnpTD4lbtY1bikOr4IEKGU8m8Ck/QkUdBlPGdAqsWEZHb/S8y1Gd6Qo9WEt/8u13y4mHXnbhP6rEmZLYFr54TgO0Zy5Oo+oolimUGvKnPl8s0OPYxZYJioK0QYADO4AukBfBLfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bWVoaOzZx3+ZIfeP9LGzzLXrdsofkfFa8AandJaLBbI=;
 b=jXoV9lNMfYOJs2KMyl0bn+YBBWkIGlTaI6zSdZuIKPeuRQlfibYE1gMaRFxnaiyjdotgYf5bXmlG4bdTd+H7fVp9V/ES3LQ2TJ7udM/CcjuJmF5jNINM58Xzu6w55b/PUEwV4oPViDnbmKQXb07LFQDK8IkOPhY28MrCuAKjCf8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7230.namprd10.prod.outlook.com (2603:10b6:208:403::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 08:07:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 08:07:51 +0000
Message-ID: <1eafe403-b94f-4c19-bd56-de5d95d13a14@oracle.com>
Date: Wed, 26 Jun 2024 09:07:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] block: rename BLK_FLAG_MISALIGNED
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-4-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240625145955.115252-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0186.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: 061f7761-8a2c-4da5-1aff-08dc95b71357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|1800799022|376012|7416012;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?QzltcnhUVmpnWUZvc2tEemxZN2hncG1sTFR3dW1wM21CUm5jOVZkcVlzYjVZ?=
 =?utf-8?B?U2tBTGdhRnBmcWxBZDhKNkNqMlJvT1NpNUZkQW5OdkZuTmhEb0RxMzQ0SjY2?=
 =?utf-8?B?dnhtWHhZTUFGcnc5SFliRjlEenYwcm1DeWdsbFJiSTNwZjl2ZjdHS0ozaUlJ?=
 =?utf-8?B?cms4eENkaVZ3YWE0RDdMMy8yUzEyQlhGc1N0TTRTUmdTcURCWjFyMGc1OElC?=
 =?utf-8?B?eHg5MnRMeVY3YU11UVZvd2QzM29oblRIMFdKcTlhMVplQll0YUpsWFd2Nis0?=
 =?utf-8?B?YXNDbVlSTkM5bTMwVU5GdmsvSGk2eHhsQzZnc0M4MzdSMjVYdlIrdEV3eWxG?=
 =?utf-8?B?NjExbXlSQ1JIb2U4OHNEUU9SRU9lSGlVQzdwb3lYUnZsNllwZFlUaHlHWXVi?=
 =?utf-8?B?b3U5UFZjZEZRdE1tMjNaWndJSi9KbjVLTzNyZVFBUDNLL1dKeWJGMWwreFE3?=
 =?utf-8?B?UVdqNkcxRGpqa1RsUUdaMzRjcE9idjdnak55RW5FTmkwc2xVQy9tMGFWay90?=
 =?utf-8?B?MVVTaHZDYVpBNkx5UnQwSDl5UXJWbGhrNmFlSzM5K0NzZWsxMHNteHBWeGtl?=
 =?utf-8?B?TDF1Mkw3bGxPZ1VUMlNpaHpETm90L1JkakRNYy9MUERWQloyek4vdE8wbW1p?=
 =?utf-8?B?aFBmQnVFcUV2K09wQTRQYytnRW5wNWpNbndKQVVwR0I3Z2E0VUVuMjZMd1R5?=
 =?utf-8?B?WnRTWUV0T0FPRW9SU3RmcU40S0lQMG0razBxcnBzQmxLRzNtZ2RZSXFJMVBW?=
 =?utf-8?B?MmppRVBkYS96bmlHQVJGV3FRKzJFNFVlWkdnK3NmdWxkTXlobkQ2SjJPdTlu?=
 =?utf-8?B?OUV0dXo0SjlYNEU0eFIvMGFaV2lBZmR2WDJhaGRvZ0Zoa2QySm44eGo4WWZp?=
 =?utf-8?B?NjVKb2ZpYUFyYzFWalE4cy94eFJ2OVFncjgvSHNiLzNodFVrcy8zWEZMQWho?=
 =?utf-8?B?eVBKaFBqUXQ5UnFVKy9hTUhQbHFOS0ZDMmIwRGVvMVZFMER2REN4aVE5amdj?=
 =?utf-8?B?V3JWV1R5NEdhb0N1dXkxSEVTUk9SOCswRVF1d0lRUGxNTzlXN0FXZVFhTzJW?=
 =?utf-8?B?YjBLZkJsSk4yYVNjTy95ampiNTdPMkNCaFV5Tk9QNUhCQ1R3SWE3T3BsVjM0?=
 =?utf-8?B?dWwrY2d0M1FjejY4SjhDQTlGUzVKc1pHMGJYajZxdUVmK3gxNlBac0ZxdnBE?=
 =?utf-8?B?K3VKbzNxU2Z3RFoweTBnRC8xMEdZQ3F4K3lZTjlMTnlzeWhRcDlUQnkwMEJO?=
 =?utf-8?B?VkNDUitKaDVhVlJMQk53K1dOS1hTRFRnU3Z6SWp6aXBMZ1BZcVZST2ZCOFNm?=
 =?utf-8?B?aW9Ia3lLaG1ydG9YYkdFYnNFWVo0WUlXYXg1eXVmTmMvOXR3Q1h2OEY3MW9x?=
 =?utf-8?B?cEQ4WEdXNUw1cEhpRlFQWXFDcXhVeTRNRjQzaDJtWks5MjlPNFRtTW9YSDdC?=
 =?utf-8?B?VnVUYW9TWUNCRXNTUkNuU3pCeE1HYnlYaGZ1TWQ0dUF3TThicjV1NkJVUEwx?=
 =?utf-8?B?NDFEWG1oVjNzZzQrdHJxQVBUa21hS0tDSGJXelRYb0hqQVIzMnZwTHBQbFRz?=
 =?utf-8?B?R0FCVHJlVW9KdFZobDRPRVB2TWx1Z2crL2x2SzdRWkdsV2FyYmpEczdmd0Vh?=
 =?utf-8?B?UFJPRUp1Z2tnVDgxVFdEWUpEcXZDTVI4QlFkYjNNVzFEdm1WZXYwc3FQQ0VD?=
 =?utf-8?B?ZW1wM0Y0ek0yWmxHcStJYitUcUFxbC9pR1paTnk1eElOWUhFS1RiUklMblJN?=
 =?utf-8?B?OEljSEVqbWVsUC90MHNCMXd6RkpaZmFTbk0yWS82MW9JWk1FcVlleXk0d2Ey?=
 =?utf-8?B?aHUxcndobGRRa2xIY096QT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(1800799022)(376012)(7416012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OVhIaDJuQkJBcno4UjBVSTVxanB5eDBUTUl0MWo2SlFPQW1LTWdDYlF1bS90?=
 =?utf-8?B?bnpUbnc4WkpPajc1SVBkY2Q0MVlmd01TNHF5MnNJQzRjZ0FLWDRDM044eFFo?=
 =?utf-8?B?R2swVGlIMWsvMElGYnFKaitBWTZOdG9LdTVBSlZaRjdvdDc2eWJlTnk5NmIr?=
 =?utf-8?B?UitJeDUzblFJc0Q1RFY3WUxnMzg4LzRXTlBPTkVOKzhmbzc3Q0hiS1JvNmFF?=
 =?utf-8?B?aitVSytldGx4MDQvcURodEhxdk1pbENhNjlKaDQ5T0FzZUd5R2J2VG95aTJl?=
 =?utf-8?B?OUFLbDc2NUM0bE81MlkvNktpR2ZkUTgwd1laNnV0VWM3RlhSRXNOSWR5dXFa?=
 =?utf-8?B?Nmo2cWRzVWhOQUlET2E1NGFRbzNYMlgvdStiakdsaWVkTEw5c3JHd2IzYmM0?=
 =?utf-8?B?ajVyUDZleEE2NmdOdW1LakZnTi8xL01oa0NlWDRnZHFvWG9WVXBvL29iYy9Z?=
 =?utf-8?B?UHZYaWtvaW9RMDR4S2J0WDdzYmFyNy9ad2pkTkRrNFB5eHRjZVNKRXdNejdF?=
 =?utf-8?B?cWtuOEdEODE0aFpqc29BZWNRL1BLWiswZk5qb21qY3JzNVhjcUh1QUEvVkNN?=
 =?utf-8?B?a0RVVVdCalZmakkyeFBNek1WZ096eFBpWmNINUF2ZnR5N2d4WUlqRzVtYmVD?=
 =?utf-8?B?eG9QT1VDcnhwNHhGTE9LdUtTRHhiUDFxN09CODhiYnJ1aDRDZ0hGUkVySmky?=
 =?utf-8?B?N3RScFBMZmtmTmJVV3pTM1lHdVZJLyt5dGFnRzhubExDZHA4Q3NJK0c4OHdy?=
 =?utf-8?B?bWVyeVR3Sk1UbWR6UnVaVmlBeWNBeVQwTzdDVFNVcHp5VG5IQnNWbWVLTUJV?=
 =?utf-8?B?Y2p0SUF5UW4yUzN3U3Q3WTYwTEIxT2NERzlLZE5Ia0RIbURLOHFDNDZ4N1o1?=
 =?utf-8?B?WWt5VXkwNmV2NzA5MmJmeFlwVEhmNzJrdVpTaWNlU20rNDhLaEhDRVpVendn?=
 =?utf-8?B?d21CZUNIbGQ0aHQzU0d0cCtIOUMySFYyTXhSelhPcVc5MEYrc3Z5bkVIRy91?=
 =?utf-8?B?UGRlb204QVNSOHRPRDVzZVNicUxBdU5QbUNORjhNYTREK0EyeVJWQURVanh1?=
 =?utf-8?B?Z2k4SEhTZ3cwVzFocEdFN1ZlQmUxcDhXdFJVdFJ0Tk16TldnSnpjOG1SdHVu?=
 =?utf-8?B?MEFTY3lRMHlySnpYb0pHS0xzR3h6VWNDTnhvYnBPWmVpN0lpTURJcnVVRUJK?=
 =?utf-8?B?UUhDSVFrbmJHNFluMjdXdnBnMDlVZlpsNUVHQWdsRmwxUmVocm1QS2UxeU4w?=
 =?utf-8?B?T3ZLQklOVmplLzlKV3NqdzYrR1BRcFV4QWlHcDc2eDRJNlRTbVNoaTZCNFNK?=
 =?utf-8?B?ZS9OVnZmbThFdUZGR2pZcWhCdjBiRVpTMlF4cVIxeW1DejI1V1VsakxuRENq?=
 =?utf-8?B?OFNRSitid0JZRjFrMFIzeW1SVzI2aU1iRDdSbFFRSnNCdXA0Kzc3YTNDbU9O?=
 =?utf-8?B?MVVEK2phTWJGUVRnWGlhaUV4TUowcDhoSVFLbXdQSzArdjhmeklOenVyREFv?=
 =?utf-8?B?OVFteWVCaURVUk9Hd01FNG9SR1BOait1TSt3UUxNclc3ZWFiR2NoaXB1NmlQ?=
 =?utf-8?B?aUphUTRZZDE3WGNYUSt3MFpHMmJ5WThNUkoyUCs3eXpaWFFjWDY2eERLTXo5?=
 =?utf-8?B?L0Q2NWpXYkM3ajY2Rm9QaFpocXBkZ25nUWZkY3ZwV2sxWEdaRVJwUlRkcCs5?=
 =?utf-8?B?TjZMazB5NlR6Y29PZmtRODFOSmhRY1p2NTBNdUxabU5BKzB2NEhRZ29XWTdT?=
 =?utf-8?B?c3J2bjloRVJjODdYRTUzbWNSRmxRZmJoZkJ2bHpBRmF1Z3FSZVZVeVVQV2kz?=
 =?utf-8?B?ai9mV1UveDJLZDk4NmV3VDBoYm1ldVRLclI5bnVRMzJoTytaS2s3bi9BaDlr?=
 =?utf-8?B?c3RiZ25ydzRVdGdyTzU3cnBRWHU3cVc1Mkw2dGJBOW9GWEpTanR2a2t3YW9y?=
 =?utf-8?B?MHNpWEM5NXl2R2krRDl4dk80MTYvbjZXV2I3UlFtNVBUYnR2WlY5YVR1VGo3?=
 =?utf-8?B?M2dSVWxPQi91d1RzN0E1Z0M1dm52ZE1MZ0NqOEVqZVNjdlc3WkN0M3NDYWJ2?=
 =?utf-8?B?d2JkbEFyZzlIUDlLSHdyMzA0WDBzQmlmMXVrL2tYUUw4S3o3NGZKNU16aGJP?=
 =?utf-8?B?dGl1Qk9EbU1RTjVjRXh1cWc3MTRPSjlxMG1pMUxtcFZ2VFQ0YkdOY0dBSFBi?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UAJW1P0jEtwzyatdflmD8TeBaB06uUjZaeaSF4ffe+zJK2xVgeaHvJEaWkCNlSG0fVtRMWU4uomLsdGSh7nMRGeCNimWqh4gUzcUDhSfC5ixP27MdcYEmaXQYme3vVjLyLoCuMpyRbl4uaSFmyut8MtcsR0H8dIE6wvEm69al6G5PdAwYVwCfSebUFT/+xL8VLJBzK0Ldk9x5D/oY/jbFBs5EdfTxrsalDTtLE4OBFJrL6aPzkYObkbE6ZwVUEsQbMaqwUUflvCDbT4gVySvnLnTTcbU/koAjAfJ5ECP9tW5fvpduEwzccqykJhVsKbCDcxm4NJj/fHwFGzALbmwJyILBp35rAQQ48vK8nzAe1rraoeu10rgDT+Nw6VkXD4FlUefBxyhYR3CYfxFEcKRBA9l2HppotqyzuG4N2QcxMcz0mOzw4+FAGUhwJB9Vk+Un19YK/qAEiaUTifpeKM8PI4kpieSLmCMskQFgzeRMeoXKVcQwMgqDDjc7ZjwvT+2zfelGv7aO6i6HOgqN3bJ7d9InNFu5J6xD4zLUrVL89lYXQ2GZHqXtjM6HjHLI+cUyXfygzceQDrhcF5ygAiZ7HP1d6/yP/7mDBGLf9IzxJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061f7761-8a2c-4da5-1aff-08dc95b71357
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 08:07:51.8385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wOGvrwve/otAPjIwoZcPb2ZsMLjXkhhbd4QMyW0VzPK0id1RoRXOKejKZKHIm1GKtaw+ZrSP/O3rxwj4khKabA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_03,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406260060
X-Proofpoint-ORIG-GUID: mxusDT9mxXI-2jbPt2GN9CQ9J-TuDk0n
X-Proofpoint-GUID: mxusDT9mxXI-2jbPt2GN9CQ9J-TuDk0n


Reviewed-by: John Garry <john.g.garry@oracle.com>
