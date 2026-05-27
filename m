Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA63A1E96;
	Wed, 27 May 2026 09:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779874991; cv=fail; b=rb/neJax+zzYC82lXHANLQF21BDWun3uLqsn1dJugBzDswN6Z9YEEdjhAE4SOHDclyGZmvT3ber5CG1E7Ga+i55OK+kEEAE56MRexqJcLxQzsjq/Wf5pGljQemf7muwj9fpng6ebFnEVgQLL1NobErXfKsULWRK76wOcgwJGylQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779874991; c=relaxed/simple;
	bh=nYs9SE64gJ6y8+arNxsVQe7Vw+sjpi73qslkvS/Qp+w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pUAeZj3/HE62gdOdV6FBnADsMixQUKGyPNWTZ8fEfXtjQ6/WMwZujYCpIk6VeWJXWOeZ49Oz2N0dzdCdt1TzRNXntO0hnxKfgIEiS243HiVuzsG73ZqQwit87enS0XAc1LBKqdN+p37WlBTtRMBREeD7ZtkRVC3RakmG30QMwx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qyAprTQN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QsW+TeIQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qyAprTQN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QsW+TeIQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64R3CFYw4164596;
	Wed, 27 May 2026 09:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RtGnMmgrJOSKg0brQhgLHc3l4JqWWODfe1Mle6LOOm8=; b=
	qyAprTQNDHAxrZ78MJyjqvDVhnLltsJbkEe3s1cgMonsdthErhMhpn96r7hmk6nF
	zeyQ6i4Iv2Fgvc2gnAk2uiD7dxz/Dla1cw6yTYIXuFhZDRwhtX5ywM2n2EdVDE9f
	zDHLsUyW/3abD/xQOjSECHTh3OqkZU4pOsSSe7neexyJVu4dT3a0racJaJh4qKl3
	EFF6ppuVldVL/LNzLLuWXrQMZL5Hh3zwtCWvQU187tUY78K5BxGDkrrMiTcq/Ytx
	4i4OUe2COgrup736JLRCYe3BSU1qs0awfOZU47NIIJ+2DSJmInzltf3sdcCF75RT
	azxjpOSPE3P7XhKyBrMhuw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb495n4j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 09:42:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64R9edfs010746;
	Wed, 27 May 2026 09:42:44 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4edjx4351c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 May 2026 09:42:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jb8vlti4WX0GncTcTtQp8+mIKgXR+FozFfuTWb3G8bowp3lUEkl4+/SXGR3erxnfjOs7HGu0+gzT6rpZBvJGPQdX2dKgfvI4KBX9Mpv0KC44KIw+GDvgg1n4rrS1dJlBlEl0SL8RephTTr7fIfVV3y3QhGkrexDOa4/EM6XIdgJ7DITSCw7evSNdaq665DeXXi6avNdo4TC6BMqWVZqFROY6UUOaAGjmUY/k+NcZuZz4WVBv8V+cQepaoKqZezFoELvFbwkpBQ2X9Lum71Z+UejNx0Fpo0JIOnFlZkp9dPQOD9DjgMCPiy6HEbf1jFQHM3bvagwraNdtvLOdqpLbzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtGnMmgrJOSKg0brQhgLHc3l4JqWWODfe1Mle6LOOm8=;
 b=kwUXp0qKFe8qnKYAOoJ3sAShZYzO7oPYtsAsFquAqAzXjdZ8BD6v5LZ+VqCjt1GGJKxjTg4q/GfzyrkO3gYUFanSNAht634NDR5Mx5ZQT6q9difP4bkKPdmo+Rw2bWdGf2pKFXWQbf4DCiG8xV3uDywJyD0qUYYls1XPLzeACLlQFtH2+b0qwkzXf5WPpDSFBqe1KvtC1ZqZFxh8qmXUx/g2vS436GU8piPYk7hBNYEiJgBMPfUaIrMKchVUggooCqXcxSzihWuYcJFWNmZLAsaKRoCOSU3bXNJc+L+U4+ioySELrrae3Yhm+LVbK4BnXxwYLQPuwjV56eo/l3M3BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtGnMmgrJOSKg0brQhgLHc3l4JqWWODfe1Mle6LOOm8=;
 b=QsW+TeIQOYX1QS6pIYk+yU7QwCVjtWB0mvNK4ONjdPpZT6Fwu1tRlpvpkQBNvzzhcAhL8MoDWyH0zlFuQdFHba3f8NxSRt3QJFzeO/uvHyMKRf8uNXYPU5CBh8ydsxmzuFJpjC3QQdu8TOYNgp3tPV4u2Im+f/n721oIvmpTpC8=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DSVPR10MB997821.namprd10.prod.outlook.com
 (2603:10b6:8:383::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Wed, 27 May
 2026 09:42:41 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0071.010; Wed, 27 May 2026
 09:42:41 +0000
Message-ID: <0a0f7284-8c11-4976-9377-d2fe9e0cf147@oracle.com>
Date: Wed, 27 May 2026 10:42:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-3-yangxingui@huawei.com>
 <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
 <5600f8fa-489a-9b81-9966-dc5d436c462e@huawei.com>
 <b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com>
 <be627116-acd2-c9c5-a665-b86e4f6392c5@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <be627116-acd2-c9c5-a665-b86e4f6392c5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0227.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DSVPR10MB997821:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aec0acd-34f2-4101-3e11-08debbd44baf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	bfJbj2eAzs75DD+nYS3gDIf4P+4fDsiJdH8LG8X89JbMX8l746C3Wp7hzVhbxJKXyE3XzvVveAg514UrEmdu7CbEDuJNs1uGJMeyHlFBo97A56mW+j0eir1Cj/k23KRKbHaY9yyAwy+6hqhJa3nJdkLfsrvJJ9km67dY4vfIXwm6advB5Odrp5TUDCSoI54QpqL2m6uQH5LXb4NB+oBzzJxzUutkrDxm8Mqfo3a11qIJJMhXOiSmrwwKbehKs1lz2tkMWlL6And0FtKR2q3WrDgRDM3SyJSx9EY8YJeIdqobMKnwggwPtF+2eiaOM8d1v+/UphH/rPIj6xFLg2iD0Nn5dNpykDCXdyyWjsy6ZcNnH+FrCcapsY47O2LdCrGPZ/9KcgrRioAwoXHrAQpfMdgu494n9FkYVvtY/2rXW/0D7M0rOjvHYMO3MLLcB/TH82OM8UG29bYYE/2IaVVuO7D1rbq3IVh0C4w16Ao6zXsLRI3nkZrnLk2DbEdFKR5T4ylnemqx/MUFuAd1TKgZ9yyPTSYBV3GYWsH4Rnpcq/bq4oyPAPHhPLfvzgJ4U+xjEIX5d6OgJF9srTD29pY4reZfT3woYxN0IEac2ALEUIxdQQfR/ufVs6UfP97Dymf83+0stvCnwhCeyBX2HBawdiir7hzPZGGqkQ0f8pM1MCcJkfN2PVX7CJYKOBrFgxVE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZCtoZEJSbElUa3g0SFc1RnhtdGdLSVFsR05DbGpJMUdTWFRxZ29rWVZETHVo?=
 =?utf-8?B?eGZuUW5BV0dvd3lWUE5oTm4vWHRaa0MwNGlwc292WDl1TEFtZ0hDbXpnM2hw?=
 =?utf-8?B?TzUyVGluTkliY3JhTGxmQUE2M080MjZZczJoMEtnQkg3bFFFSUFRU0xKUEo3?=
 =?utf-8?B?YngvWDB0aTB1OURvOHowaE12bk0rZGxjWlZnS3R2K2RRc1lkYXBsMUQwcW0x?=
 =?utf-8?B?RHdFSkpodGdtQ0o3NVVVK2pJWXZRWjE4R2JOTVVJSCtqN3FlN3h2ZGh4Wjl5?=
 =?utf-8?B?dGRHd0tnZWl2NUxwM0tMbnZ1aVc5dUt1WUUvL2xTYmhOSWJNSUhBMFVlYmli?=
 =?utf-8?B?S3M3ZW5YRzMzN0VQL0J1WkRzNE9ZelFxT25XSm05NjJTT2srRTFUNi92bGVI?=
 =?utf-8?B?bnJ3TUNLcjY1T1dPTGcxVTZuWkFJMUFhQzIrTWNSZzdVT2NmUXZVSTg3eWYv?=
 =?utf-8?B?M0NDbktha210bE5xTnpnTWF2SklZb2MxV3graDJrdSt5SFJ5OE93V2UvdXNH?=
 =?utf-8?B?UC9TRHNjQjJkZjdCcTIva0puVzI5UFl1WjQxWUtvUTFLaEwrSlA1MkRIZHJk?=
 =?utf-8?B?VFhPaDFWNXFxVUVFa015TXRKdDZCZGFnQnA0NTVxZFB6M0EvWTNMRnpIWCtn?=
 =?utf-8?B?OGJQWGpLTGJSNDdxZVB0M0FFdlVpUnFkdkFjVVBxc0MzM2dselRLWlY4OE0z?=
 =?utf-8?B?VVdQbVA0QTVwam1rY2tJcVhyc0E5czIveVptZXFjOWtSR0QrTXA2NFkzRno2?=
 =?utf-8?B?OGUxdWloRnl1anQ1NXRWelZhWlZ0Q2ZMNGZHU2p5YkIrOGhSc2JFcUhqa1Jv?=
 =?utf-8?B?eStKcC9UdURZNFVJWnJ0ZjVBemgwNU5IYmZsdXZWbWs4Sm5WNU5GM1Z0NlVm?=
 =?utf-8?B?WWFKWmNCTWxMdm1ZWGZnZjZldUR4RENCaVJzMjRzcjlNcTVaVjR3aW5kYXJy?=
 =?utf-8?B?UFd0UUluOTNTcGxScU1VbS9paEhwaWhjVlNWbDNvU2UzM2VzZFV4VHJ0aDds?=
 =?utf-8?B?UXRCd1hsdUxSZ204cnpmZXZVM2RQT3hBdFgzVlFlRHcyaUg2RnBnb2RBWHdZ?=
 =?utf-8?B?Nno0MW12QW1DYm41cXhZWk1qbjl0NHdCa3ltajFGNEt3VTFDMTJQNnJTemU2?=
 =?utf-8?B?RnExVkY0TS9mMUVyL1gvdWp3LzdzYk9kWlhzdU11RWFqcnlnb1RZQUoyMEZq?=
 =?utf-8?B?Wisza3JmZFlneUVxZUlZdnNLdGxxb2NOSUl1bkQrTGVaWjNrdHA2aWREU0VV?=
 =?utf-8?B?L0ltaFF1d0RsVHIveUxJKzdtTnZrclFxUmtRdWFuS1lQbXY2RFFOeW1KKzll?=
 =?utf-8?B?eGkwK0VNRjhCVE1ZblduVC84VGIwaHJ2M1NXa3Avd01PdndMV1JGcGtpUFNo?=
 =?utf-8?B?M3VVbC9jcmxuMndTVWc0ZGswZ2kzQUJndlVQdzdpc2l2Z05JM1g5VFRaS0hq?=
 =?utf-8?B?RXRJdEV1RS82ZGNaeWROMGd1eWpyR0hRZTlNell1b3ZxcjBLaXhBSGc0OFlX?=
 =?utf-8?B?Vk41RnRQVUdjQmY5ZkFTREZ2bTFncjZ1c2VhTzE3eVIrNVI0djh5czV1ZUhU?=
 =?utf-8?B?NUJPRURLcVRHdDdWODRTUnE5QkRpckFJamRwUThxUVd0cTgrcmRtOFhXZCtR?=
 =?utf-8?B?S2hrOUZFcFdoUDFLSEpwdXI3ZFJTak9xMk13S3R5b2VYc2t3TURsbk5WZTQ2?=
 =?utf-8?B?MnZianovZ3Y5dVErMzVwdHpKT0dXd3YvR01qd1QzMXViUVAzbHYvV1pZZ0l2?=
 =?utf-8?B?MWdkVngzbXQ2YVJENEcvVHZPWDVYYXBLcDBiZGZ1TXBlSXRUZ2ZINkN3bVNV?=
 =?utf-8?B?UVhsVldKV3lKelhxSVdJNnpKS29yL2R5YUpoWDhZZkc3T1hVQVBtakkzUlFG?=
 =?utf-8?B?c090amoycnpjOUQ1OEYwUEJuVEtuOTRRQys1VllnbVV3eGg5UFpZbkZDRTRI?=
 =?utf-8?B?YysxT1hLeDFTcFdNblNqQ3NKNGdaOEx5NkVNT3JEOUZoandrN2ZYdlBWT0dk?=
 =?utf-8?B?YXJKMGtEWVJERk1QUVVZMlkwRVgzWEhjV0dHcG81WU9vbURQUGV2aG8yZTZS?=
 =?utf-8?B?dFpwVW14akJQYW85SmdLMkR5dzBqWFRFTjNuUUgrTGtVNGVTR3Rqby9mUEI2?=
 =?utf-8?B?WHpzM28xdSt5ZjZJRGtHMVBXUXk2SmhqZDhWOWlOd0FoVnBJWXhwdm1zMWUw?=
 =?utf-8?B?L0t4WmRDWFBpc0xMeitNcXVJbnRhM0tpSHlJbDVwS2RCTHFFaG9YSzNteXZI?=
 =?utf-8?B?NXZMSDdiSVluQmVTUGtveHB0c2Q5cmJzd296ZjExYSs3aDdqazJIY0Q1S2Yz?=
 =?utf-8?B?a0VlV2llcGZuTDNhZXZMWXI0c0xkamcvUjJSYlh6WDZLUmNXWDUyb1NjVWZ1?=
 =?utf-8?Q?ecOy1P3eKcNvkQ7Q=3D?=
X-Exchange-RoutingPolicyChecked:
	aMA/7jVhaXYBWEZomdxMpQyK3QcaZQ01FJYC4NWDM9o2IxzppUZQm3sZt+TbABY/6NQ6DJoH2T9YPS3soXuYLCkJXnyAlN2toWCGHV2y8CWXKcS7+HL+TE+LQ0uqqARN65+TMu+qJYaoIIAhHU/p0Na0gei547FO/xAyaYddggujcvavBe3BkP9hEcFU960ktOTl7w3Z2d/GzTPFKOe9G9v0iEgyS46/hhcAn5QlO832SpEN1zM4aI5Fu1oCNLc5NcHkO4HhqUYmYCsDJA/3RG3qo3eWi5rJa8sqdEds/DVhylQiax05V2Vpji021ZETfH/5Y8d/B2+ODH4Mcp4SBQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VPP9eg5ziIaX9LGOaGz1sl54qbPBjzibuQhND2QMFGMIgoEj77Z0e6AIGUJ3mGaK82wfzwUKAiu3vE3bjzeguzNzqbJwdD4FFSN8XMqNzAxtmc3R3Mxspud10Daz4KOP67fxBL/u2jYtEnmpbtOyKe8lcHhc07TAmoX2hWzDjqY6ze/HVqv17sJ3PBUIR/U6blaGcifWlrex94+tFi3D879J9NJIrZBg6Wpbk1eMkWdPNIjfwL5Pxt9JKIpidz7G+Ei1e45cWrhFjlt+2AwUhjceID9MvxFoJGsQYkk1v0cYBoYTN/M7LYvRyxMeQJeODv1M1C4gQLS72G1j2FaBAYXwkzlDinUClgJR9sEbBMwWjYTYyN5nNnqq39+RGOxuNrRYWHTPk2G5WLAcmTp6RjwM2pGi7E/6g1rIjSaClUoUuntBnI+cFQWKA8rkYH1f4ugImpW76PByVcjX3qMuFuiSuOhafg3YuX4Yi3Z2/1D6iaykl7A/BJbsMiid/Y3CULRxMhUS6tvifHDmZx71+gtinmo7tVFWHzIRVldL+wWBTopXar+XjjytQ2MVoafoOcOG7G5AL6aLqTJSTAzi+kjwGN3YHw7/A3lWulQulk4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aec0acd-34f2-4101-3e11-08debbd44baf
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 09:42:41.1935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HCz78un4ce81l6drtjfaEQfzU0uKGipMLI/+o51qFVGYjtEkthK1MDTXtrWPZnEl3HJD4Bx4DPuxg1cWaZiqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997821
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=876
 bulkscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605270093
X-Proofpoint-GUID: X6RrDuKGFhxx8d-OFTlcMN9PA1htHK7O
X-Proofpoint-ORIG-GUID: X6RrDuKGFhxx8d-OFTlcMN9PA1htHK7O
X-Authority-Analysis: v=2.4 cv=Ld8MLDfi c=1 sm=1 tr=0 ts=6a16bc95 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=z_2qVX2gTRhCYtdSNw4A:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12299
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDA5MiBTYWx0ZWRfX/jxZmkssEx8s
 AvuPSQClsB9YRU06GKeKQ3F7OMrZ3e7fczidzNBnIOlF8L0e1XviP5RRO8dVaKplz7pegnUNuDV
 kf3zszuzT2yZfHj8mckjyNzmZZ99xqUYUD7h+RCbPYf/aZ6IdadsfpwZ4IgdZSy84qLykYR/9rK
 kaUYK27/7Kv39OpQdWPbYH4WvXzLSPMUcDDpFlN3CvxyUFxPiKGwYyZDL/O51YxuNnzqRkYvy6O
 xJMeCuMiQ0TfZAkXE8QRiorm8JuD5WSrvKPzBMvJDhLJQy+iio5xG3enI9SmBQtb+9gp7OtxVfz
 zaj1nbSf3pPx4z+DJF+nxjSNvWXCYj+WacdN5TO5XmDNbevRWenKEI/4LwR1vopz+KYM8bvesq1
 K9hjwu+gqpB0GNs3DhfbwSn4MXvSCjGytMvBS+lmCKgo9OrCMITvxV4vaSS23UoPxvXVJPIQAtW
 K/PHoPjKxl62ucCRRxxmnbIM9ctFQwYKG628cmhk=

On 25/05/2026 03:25, yangxingui wrote:
>>>
>>> Hi, John
>>> As the commit log. The existing pattern (unregister + 
>>> sas_discover_new) handles the "replace" case where the SAS address 
>>> changes completely, implying a different device.
>>> For the flutter case where we detect linkrate/sas_addr changes,
>>
>> Can you please clarify this: you say that the existing pattern handles 
>> "replace" case where the SAS address changes completely, and then 
>> flutter case covers sas_addr changes.
>>
>> What is the difference in the SAS address changes between the two cases?
>>
> Hi, John
> 
> The difference is in when the SAS address change is detected:
> Replace case:
> - Detected immediately by the initial SMP DISCOVER response
> - New SAS address differs from stored phy->attached_sas_addr
> 
> Flutter case:
> - Initial SMP DISCOVER shows SAS address matching stored phy- 
>  >attached_sas_addr
> - Linkrate may change
> - After sas_ex_phy_discover() refreshes phy info, child device address 
> and linkrate may mismatched with refreshed phy info
> 
> Additional issue with Replace flow:
> The existing replace code path also suffers from the same sysfs_warn_dup 
> issue I mentioned earlier. sas_unregister_devs_sas_addr() only marks the 
> device as gone and adds it to destroy_list. The actual sysfs cleanup 
> happens later in sas_destruct_devices(). Calling sas_discover_new() 
> immediately after unregister causes sysfs duplicate directory errors.
> 

So can you actually recreate this issue? Or is it just theoretical?

About this following code:

+		if (need_rediscover) {
+			set_bit(SAS_DEV_GONE, &child_dev->state);
+			phy->phy_change_count = -1;
+			ex->ex_change_count = -1;
+			sas_unregister_devs_sas_addr(dev, phy_id, true);
+			sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
+		} else {


Can we factor it out with other code? AFAICR, this can pattern can be 
seen elsewhere.

Thanks

> We need to optimize the replace process.

