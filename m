Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263A91F666B;
	Tue,  4 Mar 2025 09:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741081768; cv=fail; b=XeYvGBS1TQpW0XwmN3AKw5rV6/VzdVJWOaxa0++q44j3PbrsHQiLcfHs5lSTxyi6eGZIISbm6WtcucXYF8AhBso/BMOBgmmmnlhJJbF+5Ug7+Uvc37xpXRpyZ8JuK4pZ+aXbEafGCUX6yVQl2LWdDjHcXQ+r1xpXk6/UvU/rBW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741081768; c=relaxed/simple;
	bh=EKWs9dTSiO7bB8Kp0ljG7HTaJe9W6GPBORVjZiySJjY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MmMCeGJCC05D8WUdYLf3oz9w7quWqk40F/siG+GJmUolzU3kjZJzs7OCuq7XHSkgcusxqJ0H4wC4tMVR0sT4zLTdxvpEWHF8921sPPJpNglhdrC9yU+c3qkU3rmY29rqfJXIzGrrZzfMiJJbzcXTvKw9xtbX/JMIlH4cOEpJEQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VA4eYPMZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DI/MJb2A; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VA4eYPMZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DI/MJb2A"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5249ftNk031386;
	Tue, 4 Mar 2025 09:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=FFwkGl0amFDOIHfxKw5gEzROAbYByVEvAWiqtAEMPWs=; b=
	VA4eYPMZjo8JC+tz/SR/uMkJF+n+NzxAsESo+aY0kHcvobxj3krF098cLdQH/KIk
	uEXVBU9DXk5H/Xlz75q9thC6JOzPYnQ2+kslWyOhdxuunkOdkQoIzu0rZvoThKZf
	W72d0s3eMD5v5XfUt/zNHt/WJuIB40cOvaD6XWDKJKi0wtCahUS/YoPMfS/rbxP3
	/VK8ZjKaUORLkNyQcxAAb/0E0kAiYfu1DoQg3VmCTjzDhmKHLFa3ZeOHnLAkoxr0
	1/nH15KTkK3undungxnlEpXvfymD6KHVdMQGa9w6WZh2SnLJ52LrSc8qB3qOcRV5
	M0XciXMEgxEHhH5vU6kjQA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u86mtw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 09:48:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5248A3G7038319;
	Tue, 4 Mar 2025 09:48:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpf08tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 09:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRnXnaKw0NXgghsOz4OGUV6MpKPRe7Fh/tDHV6EDslIFya0HGwoHL5+Npl8ZENZopqpUZqW55b3LW75ceUDObLtJyHsWpsjSRk1YqDUWJbC8E1uygVHkVsPmYFW6Hkw7Y/GU0Y3Zhub2KblELZ6MkaWQcQlfF+gJcen53udtBEqwsIt70VwiC3W4QfUm7vl+OZJJs6534mk/u2pvGwzga/shCgNsIpalSZmzqJ7NTply3+R6zFi5Tqf+SRrvYTdGwU2Dmfg6gN3pDnEcOazcBkawM5S6tjeTtA27NEpLgBiQVPMe6broi2oimxwCx+KY75o9xam6kuZBUZTbIlrqaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFwkGl0amFDOIHfxKw5gEzROAbYByVEvAWiqtAEMPWs=;
 b=W9AOitSu66LAJPix65Cdb5J9ntlMxRxljfPDLAgamoXc31t6YXKIUMzFiHWkfdM4J7rvKlrDKOL8LMN6RJ8Lp+HmTNiZE1N2JzWvZGuoDMEtP+z6uol14dZU2G18SjG67YJRVi+ZSwZ+UKqMwTUQVK/b1FgYL6pmWLpmT5J3dWDqFJvrZIgHO8m9E9E7Mhh9vH+IRfEP+Xvsr/Hpu+L31jK0/tuhCrMjFlSfH4iqJ8oD77Zl+ZkuAwL2sBdX73BcNVtDRYF+odRWt4RaCCqmRN5EOHhlY7B+HP1GJDdtJfQqWtGsHRmLxXwFW1Sc0CNJzkmNU0ySFGAIqn/4TIAaCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFwkGl0amFDOIHfxKw5gEzROAbYByVEvAWiqtAEMPWs=;
 b=DI/MJb2AGUZjrS9M07NaAx1YsXt8I6IsFO+OYpm3QKeMeeQHIqJaXcdOfDwjF9EEKM3yrAS6sGyNOIHxN9rQC7bFdAV+1uIMdZjIGNIpvWt9YOdb3/Pc/8psFmox/4zSmG3mFyrERGBOHFKGUdrhgqru3MfBHyDk0nu4NA+xDCQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6629.namprd10.prod.outlook.com (2603:10b6:303:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Tue, 4 Mar
 2025 09:48:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 09:48:48 +0000
Message-ID: <4279fe21-6db8-4deb-b5f7-663720637cf0@oracle.com>
Date: Tue, 4 Mar 2025 09:48:44 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: yangxingui <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
 <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
 <4f287a32-d24f-47dc-bec5-a4b94895e135@oracle.com>
 <9765d9c7-959f-3611-4093-89f7e941e2ba@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9765d9c7-959f-3611-4093-89f7e941e2ba@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0395.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: eafc0ec4-6222-41ab-ac87-08dd5b01c2f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWNHaEptdm5CV0w2a1hGNGRiOHBIalhZdG1SRWQvcU5IeDFTT1RkcVBFWkkw?=
 =?utf-8?B?eVdOQWFabkF1ajBHRFBrNmRKditPQWFTTm44dk03a1pCWmVRWi9wZERueHJY?=
 =?utf-8?B?aitWUWx5YUxIa3IyRHZyRzRtSDJ2N09FUkV3K2hkMzZrbmN6Vm5QZmFYMjc2?=
 =?utf-8?B?Mkd2RCtORVpPai9zbmxYRVQvS2o4aHpmbWdDUmZ5aFVKM0RVVkQ4aUtYZkpm?=
 =?utf-8?B?SnhnMnViQ2FTZm40bEVxcGdQVXN0SzFtUnd0dmVvcG03WkgydHBNZ2tHZVpm?=
 =?utf-8?B?cEllcDg0dXBJcmZ1RDBSSmlYejV3RjJHVkRGcDkvOEU0eGZoQjZhQkdoWldZ?=
 =?utf-8?B?OTVhUkdVTGJabFNnSHRpbmZVcHVSZGlIdXIzR2JMWjZpSFVrWDhmOEJHajFJ?=
 =?utf-8?B?M0t1RDNmR2txbkJEUTVQMCthZDZ4Zzg3aGlWZmZjMDlkRmJxbml3WkxIWFFj?=
 =?utf-8?B?c0NENWhuaWxyM1A3WFh4T1pac0QxMkEvS2FFUWhMeHF2RFFCRGZZNit1aStC?=
 =?utf-8?B?TmtDN2ExSzZRYnRvREJRcjNLYy9BL0o0YU1ycy9XMkp2MkJUT3RxRHdyWC9h?=
 =?utf-8?B?UXRPc1dVSzY4MHNEbEY5N3NsMzF2VEpLSTR0R3pwbE1QNHprUnBvdnlHMmx3?=
 =?utf-8?B?OS8xTjM4ZHNWcVhwUXd0bzFvQTlvcWthRDNmTS9uUVpRZlUyMWhLSmFwdk44?=
 =?utf-8?B?VmZ1T2VwNDNCOC9zRkI3L1M1SGNsYVo0QnlIRUJXazN4dmNZY1hWMlhEakd3?=
 =?utf-8?B?aTkxMnFhMlZ2WnM4V3Zaek45ME91NjF0RDUxM0N2RjU4TnBFZUdxWHNENDAy?=
 =?utf-8?B?WFlsNmVQem8zdUh3L21jb0E5TXBlUmpSaWdKN3EwcCsvZVVtSTA0dVMvT01Q?=
 =?utf-8?B?MzQ0dzE2MGtuNXdpdFNqY0hibFNsMFJXenU1bzllNy9odFVTQzh1b3ZlbWQx?=
 =?utf-8?B?WEtFOUxQcDdlTUF4MmdXQ1NvbXZYSEFLVW0ra01udnJyZk96TkREdXVxWG45?=
 =?utf-8?B?TkxzQ1J3cVd1TGdmYUtDaVRvWi9Qek9ZU296Y2QvU1MwT0hpT2FNWnY0MjN4?=
 =?utf-8?B?MFJEMVdVaHNkTnpoQytmdVdVUjZGWXBlTHJhWVpUSlNnSkJqaG5vQ1d3YitN?=
 =?utf-8?B?WHJzSHZCNTl0M21wYkl1Z3hweUpYbkZFQUc5SUtEUk9pVFdQNGkxNzhPT3Jh?=
 =?utf-8?B?ZEhhUVkvUlpFRVdZNlBybTdsOVVNdElVV1FZL092THNZSmw0ZkVZK0t4Vm5Y?=
 =?utf-8?B?dGVybnA5djZDdzE0RTMyMU82V0ZpRmpJc21UMnFTMFVQRCtaSWtCakxYVk1t?=
 =?utf-8?B?TStkV2djRnBkYUlTR25GNUFzRmZRdmFpZHpGVWwrVzFlTDUzU24zQUFXTE5C?=
 =?utf-8?B?VW50QnU2ZDBnL3lMWHF6OThFbmpSRzV6Zno2SVR0TFNLdXVhK2xXOFJBTytB?=
 =?utf-8?B?YTNyMmZQdnBtTlErU0FMeHRRbmZ2dmRCM25INzUrbDByZTdUWkxHU3VQdExM?=
 =?utf-8?B?MUdrc2lNL1o1MDIvQ3A1WU1LSjd0RjF2dVdIMnF1RHRlZTQ5cFV3L3gxMVI1?=
 =?utf-8?B?U0NiaVF3MUdzMjB5WWpydWdzbXFYYXg0ZVFxN0VDQTdPcUdKaFkyNktteHBv?=
 =?utf-8?B?Z01yZytyS1pYamZTRm4wR1FnNWtVS2J2MkJMUkwvUVNPN3FZdWhKbTVTTU9Z?=
 =?utf-8?B?VHdhZkJjZDQ1TlJncFBaWjdGZ3VqNm5Nc2VodFJOeEYvUWdxQlFGOStQSll5?=
 =?utf-8?B?YmtkeFVFWUEwMlJtSjFNbXhlaGxaYUJoR1VmMUdDcE9MNUxMWmhJQ1ZFMGsy?=
 =?utf-8?B?NlR4YnRuTWd6QkZXeHZBdElLZTF5WlVmL2poSXM2ZG9JOEtucEZNNTZyVE9h?=
 =?utf-8?Q?YrNXV0hZg6Uhg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkxjdFdvUzg2cGVzbGtyQXRQd0xqNzFzT3MzL0Q2Q1R6K3NRdkl5Y3ZCT1VI?=
 =?utf-8?B?Wk9SQTRGV2o3ZENuUU5MNUVISWtqSlNFS2FkZ1dGOXZuTzN1KzJFZFVnelpa?=
 =?utf-8?B?b2NoeWpTSWtSUlpqaWgwZ2FKaGFLUHBMRDJKUVdZQ0xTNFRQcFJ1bnVxdUlC?=
 =?utf-8?B?SGYzZThJZnBmdEhNc1F2eC9oUVpvZktJUVNXRVRodmF6MjUxMFpJU1Z5enVL?=
 =?utf-8?B?OXVaU1VuL2tCQVU5UHBZUEhyWWxqb3JQUzFhY05sRWNmL0pzcExYcTZRcTMz?=
 =?utf-8?B?N214cmloTFlwZVdoVlA4ZmFTQkxXUXNrK0JueVEvQkFCWEpqMUdMNnpqMTl0?=
 =?utf-8?B?ZmxFUWdtSjJONU50djFxc0F6aXV2QXRveXN4UkJBUWhoSVRCTy9EK2R4VFNJ?=
 =?utf-8?B?VkVvNTFkSUtmQWE4UE5YRTYzcFhLOVlpMTdjdTNuaDdMT1pPWnppZFkxKzE0?=
 =?utf-8?B?YkZDVm9HWWJ2NFhUcC9DREQ0QjdKVWxISjFFN0MrTExQcndSVDAwQ0VmZjZt?=
 =?utf-8?B?MVhpRldVVHFBb2VHTFFjSEhFVVMrakhIajl6MVZZbzE0dzZUNDJXZzVyWnpM?=
 =?utf-8?B?WUs5cmt5L3NCbVU1MDdJN1VETW5wTngrc285RmFCOHArM2QvUlhXM09XN1lO?=
 =?utf-8?B?ZkpneVJYeEE5cVVaU1hyQW9wWXZ1bC9xNG5rR3J3OURGb3hVSDJKYVFvREd1?=
 =?utf-8?B?YTBUZDFqeFk0QzFQK3Izd2JUU3BpOWR6ZE93V2tkRmRrd1AwdzFqOVAwYTZ0?=
 =?utf-8?B?NnZSNHlQcHRaU0RVRHRZeG5BMUY5Wi84VkdCa1VTTno2Q0tFTllteEhhcXFU?=
 =?utf-8?B?YXUyamNLKzI0ajMra3BNSFVYZzFsbjhhNUQwUWZEekV3bzBCLzgrWEMrNHlx?=
 =?utf-8?B?TGtEb3paTEJaZWxXTEFUb0owcmFWd2krUWlCanJyaUlRSUhjQlB4ZUdOd1ZZ?=
 =?utf-8?B?ckVxdVhUYWJIVXM1UmRGbW5DQTVLbmlsNkFncXJPRTRYeUxESmdkY0VIeEJ2?=
 =?utf-8?B?bkRVdmlFRVdtRFpoQkdsN0RnWGNabWtBSnZZRHNyOGt4RnlwTTQ2S2ZvVDcy?=
 =?utf-8?B?K0lKZFhTS09NeStURDJpQTJqVG1COUhvUlVndk5SOWVlRWRxR1lhN044WWpC?=
 =?utf-8?B?cWI2WXFsdm9LZ0xVcGJFaS9YOHVVL0VOQW5rTDFQeXBMenkyYXpIMmNNd1ZE?=
 =?utf-8?B?aUdQU1FaYzBYMVprajNPM2trOWZPakVHOWxYZFk1TWJpcmRjY2trS0hKdXo2?=
 =?utf-8?B?VTdNcTcxeUxRd1BlMGppYkhlWnB2L3V6NWVpM2hDemNDWEZubERQWExRMFBH?=
 =?utf-8?B?Q1pGK0FpQlBubUhCajNpdDl6YWU3S1pzWXE1bk54NGtYYWdYZEdZTHIrR2c2?=
 =?utf-8?B?TEpvb0NPQ1RDTldycnpiRWwycWdZZFFiTC9PY2hqcG9HOFZJS2tuRDVKaFps?=
 =?utf-8?B?aHRVN2dzTitpL2ZDZi9JcklMcm0vVk91NHJZMEhGL3JWK2hBU0FlMlRpUHUr?=
 =?utf-8?B?Sm9NaUFHbzJoNjZZUitma2h5NHpGRklaZTlTSHA1U3JSMk8vM1NBTXhUNVg2?=
 =?utf-8?B?bjE2cHoxTk85ZWJqVmlkK001a2p0MVhFcmVRSW44Q3VMNGFURzJaUlpWUkJt?=
 =?utf-8?B?UHluTjV4bkowbzltSnkyeFJlR3VwQmtvZ2xvVkh2T0hUemZXMTdGSTdjd0JJ?=
 =?utf-8?B?bDlBVFVQVDRIcGtkL05TandmRTBFR1lhNDNkVTFwTDBXVVIyeGpDbCtFbWJW?=
 =?utf-8?B?c2JxUkNYSG5ub3IwZDN0Wm52c0lYK3hTQlB6M1hGNkhGTjZHQkpUemFaVzda?=
 =?utf-8?B?bnBCNzNBM01henpmZnA2cXZ2eit3TWJseklrdXcxRnlJODJZYkpUekdzSWQ3?=
 =?utf-8?B?Vk5PT2ZyWmF2dTljSm1id0JvUVI3alNSMWh5ZG1GeWhqenJFaW1Fa29jK29T?=
 =?utf-8?B?dW1DQVZuSkswY0QraUV1dXFCRTJSOVZrSmlFUnZmYjZRblNIQll6Q0JCQURE?=
 =?utf-8?B?dTFKQ0FySCs0S3MxZk05VXQzUEsyT1VDNVN6bnJtVzVXd2szYnNkR2pjTGtZ?=
 =?utf-8?B?bXBEdlVsU3haMzBVQnBhZnRJQ2tlcVRDZ2ZRNVNnNU1mZ1VxanJubUgzUWZj?=
 =?utf-8?B?VUJ5UjR4RVZHTzNReVpmZWVKdzM0RElUOUh0Qng5cXRTSnRNbDlZeVFLZ0J3?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nNa2eR8hRTKJEuXAw09maeCzGddR1I7PMxGp0QT5TmWvx3R68/4zOqSHEKWalAbjbRfkGgbf3BefuZkHHiMgHdqKvVuY3Vg59BcsHgo4EUfDowKYw8njl2lJTBgm7pVhO7vUaEjfUie6w30kXenQpFOSvaysP85+wsYMO00OF02ooiFjonG2eu3+NbLaVuex2vf+26B6+wOZCmyui33V2iOkKKowsH1YcAynfUVI05CGgPPwYiUcLn8AsXaSPoqSH5ApTh1Wb6YQEOLsa193F0fntWgvrOlIf7X7+tca9x8cBj3fp1Rx3NVTNKRfW0jOsn6X5J88XahJRgZMGkp7Yzsy7ELIwK6s8eKhMJ1tldy3N8Q7CDwIX78Iax6ith9s8JRl2dCuhTMWojCXHWGfFQSgWigWcS8jhYcjujA/VFC0b6+2sbYlE1Fy9V3Y8EmrXtO96yr/6K/a5C/wjaeg7eat4mnoJylZsAvhnk4cWEKi3IVY9Eqi3F5FDsx+Vj2XDPYCB/2Mt5IpC0F3Sro96Kc6FZ/a2C55o8m8v5SecH5T0tAsoA1u523waS5wbAnTuJjLUrZOH2odrCKGGbCq8ltnhjGrHDInx7yXXI6DcnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafc0ec4-6222-41ab-ac87-08dd5b01c2f8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 09:48:48.3461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSGDhAgWtKngV8m48W3aKdspDzZQ0H+mkDl7Q28BGdgr7S/t+gHynyi02VyjZTuF3YJL/vCaSI65xY0A4aOl2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_04,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040083
X-Proofpoint-ORIG-GUID: gPBrPXM9K3bkxJC6XagSZceGTvgS_sRb
X-Proofpoint-GUID: gPBrPXM9K3bkxJC6XagSZceGTvgS_sRb

On 27/02/2025 08:33, yangxingui wrote:
> Hi, John
> 
> On 2025/2/26 16:57, John Garry wrote:
> 
>>
>> The lldd_dev_found CB is where you should set the itct, and it is only 
>> possible to do that if you report the device gone first. So that seems 
>> like a simpler solution.

Sure, something like that - you just need to get libsas to trigger the 
proper hw port id assignment for the device. As for specific 
implementation in the LLDD, that up to you guys.

Thanks,
John

> Solution as follow?
> +static bool hisi_sas_hw_port_id_changed(struct hisi_hba *hisi_hba, int 
> phy_no)
> +{
> +       struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
> +       struct asd_sas_phy *sas_phy = &phy->sas_phy;
> +       struct device *dev = hisi_hba->dev;
> +       struct asd_sas_port *sas_port;
> +       struct hisi_sas_port *port;
> +
> +       if (!sas_phy->port)
> +               return false;
> +
> +       sas_port = sas_phy->port;
> +       port = to_hisi_sas_port(sas_port);
> +       if (phy->port_id == port->id)
> +               return false;
> +
> +       dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
> +                phy_no, port->id, phy->port_id);
> +
> +       return true;
> +}
> +
>   static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int 
> slot_idx)
>   {
>          void *bitmap = hisi_hba->slot_index_tags;
> @@ -856,6 +878,14 @@ static void hisi_sas_phyup_work_common(struct 
> work_struct *work,
>          struct asd_sas_phy *sas_phy = &phy->sas_phy;
>          int phy_no = sas_phy->id;
> 
> +       if (hisi_sas_hw_port_id_changed(hisi_hba, phy_no)) {
> +               sas_phy_disconnected(sas_phy);
> +               phy->phy_attached = 0;
> +               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, 
> GFP_ATOMIC);
> +               hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
> +               return;
> +       }
> +
> 
> Thanks,
> Xingui

