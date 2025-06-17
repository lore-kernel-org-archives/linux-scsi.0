Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE131FF60A;
	Tue, 17 Jun 2025 07:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750144737; cv=fail; b=mbDkOQLFm0MfuCbCdYqNqBHPMKVKSCYhgpETDT16gfN4rmzNZ/y4bxwqsaraoyBLDZ18jJ16dF6q5FXqIGa65bKJDRbVs2RbAGTGhQ6GQ5ad9QhhRo+nn9/DyhPxfcIhlsHVgRWqme+RfWDLGtKoMlVfjn2oy4p7uIKS3CLnPow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750144737; c=relaxed/simple;
	bh=BEPnKaLksxZUwrwy9sQ2GTIdGJ52EIpScrMQw8CpL6A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XQl8XZ2/RHWbC7Md3u2o9QrvTMJpGqD0YJel2EaeA9f7kktKynyT++G+XwPRyIJMkbY4nlgY+t2eNhDkL5/w2aZLQdctWuVJ0sxtLfBdLZWg4pU9ZkwEB9oNAecQhb77mUuzYmkPz0+aPM9q4iOEJJKjSi83TqkMHY9kJc3BkFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fVtymyYp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XF1Vo7+H; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fVtymyYp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XF1Vo7+H"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55H7Buvk000841;
	Tue, 17 Jun 2025 07:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hs7brpjwpLE4ItXhtGSef0WgowApCCIxOuwzQ9kK9jw=; b=
	fVtymyYpz9hFpqSt4RwtWJyQRyYaT4b8s3XBonCGGJVdE6/i0ZXyBX8AOaiM8SAC
	c2FUoZpHnhkqEAYE3bT55ARhTp+Vc+ca2gWIBrMwwX3oHr/3rmOsbUxCDI9+rznz
	b2weP9qJyvURffbYdeX1RB6ipBnrINRc9MlljdMVdS+tMamO44Z9k5mg2+J7Oshf
	O9U3vivDXfFNSYsFGDzVGnZKSQB2Zh6CLYGCy1jdm4RMGpL2N2T2agvAuA1zPXvn
	2JFFDs20NeXDVtulAmNbnU0TbkqmTkwpTWzyORbK99tkvJNql0ZPGDVTfHJaPgNf
	6sTHt+3YGWYVMqO5mwVlGQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914emn5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 07:18:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55H6aQPT026045;
	Tue, 17 Jun 2025 07:18:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhf4u43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 07:18:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzaF4ml7rweOsD9cOvb3hCR+mTxZ2dbRmZ6GjEzc570O1Tb5m8JBb5x8bPKLXeJdQiCOvvS47iOgt/t43HlNuzI+79sKoGM44TKm0ndoqaJqYiDxho4Od7kheQYvhqNV4uEtCe47AEtNGhlit/9CoxJdfiYHEiw5u9vkiAxuoW4v8Qbfe4F5u2F0ntQ2fc8A3txIjvw9uHYRqWA0fpYa2MsbmyMqoV1yBJcTU4VPE+KoatrCW1ed6Em/JVvuRMDpIvU03T1j7Mx9lUi1jK+BSWHvBO7oE4+SMhHvDuLqb7S7Ud79ig1gjHCjXEaBlEsyrwL9UTGjDRhZ5OuceIUmiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hs7brpjwpLE4ItXhtGSef0WgowApCCIxOuwzQ9kK9jw=;
 b=lqBv/3jzVLO7TM9E2DVQrCvVgGyrpM8oWqEFw0uLeK54j80nMEBQP2PIyixpT91Wq+RocGAA448JHDivX0pLqk6ZqH73InOd4UAJhg78YjedPb9BlrLLIZzqDt1t1PCnFlXWT+Qf3wupE+Fc7K1//HfjN29f4S/GmjnbRlwnSrI3P+KOSHPcMbMt04rQ7vzAYU3b71JMkFz+jKVVwAWzKGGiu05wBcCBIMX4DboXaoEoLNFEKg3i4bJbII3BMp701ucffy3j8SJ3Y5n1jtbJv13v8EOn4tJfBdAz3vzemjZRfSrJj7YaEeSWMuJQu3vs7w6AuHKwKKxUROMvHwHUaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hs7brpjwpLE4ItXhtGSef0WgowApCCIxOuwzQ9kK9jw=;
 b=XF1Vo7+HhR79jbBdMptAHYuEWnM1jGJk0ti3zeSWwGkORE7SOQveEwcHIyAZfe4HuQiSN37m67ch0vXHmTI+3GZZ/9PfKv1j7JJ11KsJNm3sCmBFm6nsxkTP2LtBFFKu23ztDzXxikBJ6GKjNExrMZnL7MtJ17MNV45ohn4dpos=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6258.namprd10.prod.outlook.com (2603:10b6:208:38d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Tue, 17 Jun
 2025 07:18:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 07:18:45 +0000
Message-ID: <282d9766-ce98-4350-84e9-f6d2d7081408@oracle.com>
Date: Tue, 17 Jun 2025 08:18:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
To: Aaron Tomlin <atomlin@atomlin.com>, mpi3mr-linuxdrv.pdl@broadcom.com
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        sreekanth.reddy@broadcom.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250601014056.128716-1-atomlin@atomlin.com>
 <20250601014056.128716-2-atomlin@atomlin.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250601014056.128716-2-atomlin@atomlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0250.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 626bad7f-28d5-4fdf-313e-08ddad6f3232
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UThVNlE1SEdpeDhLOVdIUi9iMkxkcUpUVFdPVElmeDhsNTZ2dmkxVXV0bmJo?=
 =?utf-8?B?bnBoT0dqM1g4Q01lU1VwcGdKZ29BSU9iMlIxSkhaMjRkc3JpaDRkSDJWRjVX?=
 =?utf-8?B?WTd0K0FzMlZNdkFvZ3ZZU0ZTMkNTR1BxbUVNRGFmSGkzNkw1UVk2cnd6SU9I?=
 =?utf-8?B?N3crODgrYWd1L0djQllJclIrUlE0ZWVHSzZIMm8zVGJLbmFkQjlBSmU1MWR1?=
 =?utf-8?B?VzFnQzFOKzc1aFVOVmtwRVVIV0dVZnlVa2w0c2lzWi9Vb1dPcW8wWUREWVlt?=
 =?utf-8?B?M2w5TTBrb05keGF1ci9LYlFacjhMRnNiMlQwMG1OZzd1ajRVSTZKMlNxd3Iz?=
 =?utf-8?B?YW1yRXA2NDd2S2VLcUltK2syZGV2NXNPU1U1MElSNHdVWDhIZms3K0xUdDVE?=
 =?utf-8?B?dzdUVllwUEJEalhIbVAwa2RxenNpekNuaklpL1BXdzc4bXJVcFNZVlBBaStS?=
 =?utf-8?B?aDh4MFBCOEFNOVZCVS9zZ0wxQ09TVTlTQ3p4YjBJRElDL25JbE81ZEMvY05X?=
 =?utf-8?B?YWlEMFp6OHViRUxVT1paYmRJM3k1YzlnV05nWmVGUElBUHZSdFY4QWl0aU5s?=
 =?utf-8?B?aUJwdXVqS0E0aEE4ZVRUL0h3OFFJemF6djJPNk1JU2lMRTBQdGxuZXphOExn?=
 =?utf-8?B?TTdmTlc5am1YME13Uk9sL0F6bXEyZkZydzJCZUVOY3R4UFpGOURWSWZzTktI?=
 =?utf-8?B?d3RMaWZmNytiRkpLQjBYRElKamx3eVU1NnRqcWJVVE1Zbnh0SitvRUNvWjBL?=
 =?utf-8?B?QWVITzZ1dFJYejk5ZzMrSDN5RVJwUjVvN0Fic0lLT2ZFdXd0MEZxbi9mbW40?=
 =?utf-8?B?QWoxdDNZUWg2ZytuUnZWZ0ZoYy9tM2tqcGVYUzhwMC92bkgzKzhyd0krMEo1?=
 =?utf-8?B?WlQxWjBucFVJcGF4V1pYODlUMHp6Z0s4WHlyaEVuaFgzbjZDcVFEdCtBL0Jv?=
 =?utf-8?B?dmNCYWl6MEkwb3ZSZ1hPcFNTUnd3amZVNWYxeXRGVlVpSUpVYjF5bVlZQk9t?=
 =?utf-8?B?aU5CMytRSnl4S08xWTA3eE0rRU1FSkR3cCtTN05LNk5ZdlZneElLSjV5VE5X?=
 =?utf-8?B?TEtOZGEvcUd5VUxIL2xDMkRTaCtsU0VWVFRUeEVBR2hzRGRnVzhIb1lINHlI?=
 =?utf-8?B?cGhQaHJObXVhcFFQRkpidVVjQno0WGRhdVpNb1NLQzU1M215QnlLaU1TMkdZ?=
 =?utf-8?B?VUlzNXZGNHdnZUM0WlMrSzdWLy80dlNHeTVxOEU0UEQydU5XNmpMcDFPQ1Zt?=
 =?utf-8?B?WDAyS2VISlZqQXBaNHNTNWhIaEZwOFlRZ2JqQjgzL3lsSFprVlg3bDhUNllv?=
 =?utf-8?B?U3JNQ0piRURhb1JScEc3UEZCNjM4a1BGYVJobGJtSS8vc3BWejBqTVV1ek11?=
 =?utf-8?B?MEtJV1FoS252VmJjUSsrcDZrVnAyak5VMk83WUZkNmd0OEUvRDFyc3FYMERI?=
 =?utf-8?B?T095UXJqL2JHYWsvTTdPQzlKY0txcTFJSnJkemc2Rkh0MkZJclRoY203Ulpq?=
 =?utf-8?B?cTE1QW94LzRVeVZmWFh6dk13SEY2S0pMWkdDbndPcVVmWEJ0MmN6SEY1UDh5?=
 =?utf-8?B?cU1oa1JjeUwwREV6N0ZiQ2lzYnR0OStMVk9KYjRlcDlwUWcrS1RaSEZ1Y3V4?=
 =?utf-8?B?dFB6S3RkTXFIejJxVTNCQ05QZ1JmZHZDVU1KRVo1aHRLVFF0RUY0d1FBT2V5?=
 =?utf-8?B?YzljaXNHY1dRYzYyYTJBRnVWc1ZxazA2UXZnbkdDVUd2RVMzVmE1ZUN1Qzha?=
 =?utf-8?B?S3hCNXV2anl4V0I4SzNnNFVSREo5L001SFdrUjhaWUlCMklhUi9iQ1N4YVVS?=
 =?utf-8?B?a2FocmhSQ3BJVkZCdHBCZXlXdGtaSXhSNzhPZFMyek1HalkvTCtQNE9FSStT?=
 =?utf-8?B?cTdKSk1MYnIvb2Y2TUtDNTJZc0xrRmxOWm9IcTNUM0YxUEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czFDL21jMlRsd1hkQXV0NXpCZmZDYTgwS3JjQlRpR0dTOHhoU29zdmhMVXNU?=
 =?utf-8?B?eEkwaGZRWnRtNStxVGJXQ2FOdzN5dDcvVmlhM0ovU2ZmaG9SUTdMQXNwNFVT?=
 =?utf-8?B?dkVBRGtRdFUyVVd5dmNUVW11ZXVtUGdZN2U2eFZBa1NvbVNEL0dhb0RLN05S?=
 =?utf-8?B?OEdPSnZjRy9nOWZwSjN3VXp2WkJ6OWppWHkwVVJMdW9PUWoyK3FEMk81Wkky?=
 =?utf-8?B?RXVZazJjUTUrWXcwWUxuNFc0TTFoMVk5UE8wY3RtY3NYbjFuak81S2RxRGQx?=
 =?utf-8?B?S0MrN0ZOcjZGbEduMTRNZjVJaUtLb1VTYlBFak1NcTJHdSsxOGZwT2FFZDFp?=
 =?utf-8?B?RVpvcDJ5ZllIZ2FiUXNPcWhzS29idWI4YThzRkd4Tmh1VEZaeE1PZ3lXTERP?=
 =?utf-8?B?UlpiZTZXMmw2TytFWGVTYmlnVzdHYTRPeUtuQmtqU2pUMXFENTlSMUN2WVBp?=
 =?utf-8?B?S2VwYmtEY0hTcUJHbDg2Q1ZTOXJiODF3Y1dpNUQrRTFBYnRIaklXdnJYUERM?=
 =?utf-8?B?M0FheTc4aFJsVVdNM3hGVWE3TDN3KzZTajVKV1lEc1U4Q1hIS3Z1ZSs2eVdJ?=
 =?utf-8?B?aHBvWW4vZUhnL1NlV2k3U1M3RzdPbjFnUGlMUDQySVZjOHRyZ3lDd21KclZP?=
 =?utf-8?B?Z0MyYWFwNy9NK2NjQzFwb0JnNGx5YnNmODF1YS9CN2Fyc2hDSzlCZHNyclJV?=
 =?utf-8?B?WXVtZ25ROEUwSG93R29WTVp5NzNPTlVWQkRMNExsUWkwNWtrZFBwVDgzNThZ?=
 =?utf-8?B?MzFJZ3VxMUhhbjd0b2gxaDRBUlF1L2FMYWJaZ1pDd2tKOXRCWUdGRGdoN0tv?=
 =?utf-8?B?YURGZjI3ajVKY01UTVFiSXpOUlRmNEp3QUx6bmZFVFl3TmwzcnJTYlJnZEdo?=
 =?utf-8?B?RUJWZlgxUm9yZlVSYURhMWpXTTcrbXBTKzJTdnNvWjE4NTV5WkRpYTEvL0Z2?=
 =?utf-8?B?SEhjMFlsdVU1WDZKdVRzSk1GeWlNSUtDMHBhamwwcWRCOUNxYUNQR3lCR2pC?=
 =?utf-8?B?RHI4d3hGbEZrTDdEeHJ2RFlBdTBucFhPa3BtWENRZkNLSkFYYkJLQzJWRnVx?=
 =?utf-8?B?RzZKcEg5TzJQTlA3MU4rVkE0QlpZcDBIdTcwdFNTWkkvTEM4aWRGeHJjS3ZS?=
 =?utf-8?B?V1hsYkV5anJQZm4vOEdCUXYySklXNmwxUHJlQXF6a1UzUDI0S2dLWWwyV1VC?=
 =?utf-8?B?Y2U2azdHMFh4RG5qREdaN3ZkSGNwV0xLeVVoQWVSYzJPWkJpNGZsRFczVDY2?=
 =?utf-8?B?eTc2M3JXVTBJYjF2SlhZUWNrcEFIR2M4cmxYYlNmRDFNWkJuRkFlK3dTNjFj?=
 =?utf-8?B?bUJ0OHNPR1hPczdnVG9lWjVqS0lXTW9CaWhVRmdob2lJK2JYdW14bXpQR3RV?=
 =?utf-8?B?OVNDbFNSNldzV0pTUGpaRnlqcVBySHBVK3RiRGdFd0FnYUNsQWoreUJSUUF0?=
 =?utf-8?B?ZVBFNEtvWUh0THZJemFCdjZvQzdubGpBNXlWRUtxTXVIdVFpVFF0NkxZR2pk?=
 =?utf-8?B?RXJzVnEwZWhKKzJaS1Vud1o4ZWZ3Q2JrZFF0MTBPemEyZTBYK0lWZFE0VXEy?=
 =?utf-8?B?QkhudUM5bkthdXFwY0M3MHJ0YkQzT0RXRlZtVzhiUlhUYUYxQnJPcWNDa29n?=
 =?utf-8?B?VTBhQVZPTis4Y3lpM2QvdVIrSWtQOTk0YWNNTUFReTYvUFhWUVVLSDBSZ2lM?=
 =?utf-8?B?SHhQckJBWkNrM1NaeDRuR0YzWmUzYzUxTHNCMmZlaUhkSXdmYXMrd2djV1VE?=
 =?utf-8?B?TGtzcitqaC95WDhjaXRuK2hCbldvUERxVDRpQkFJeisxTHFsT0lBcENoeWUx?=
 =?utf-8?B?MFFXeU5iY0ZtQWlyMTZ1dncxN0U3QlVMZkFjR2V4dDZDbDVnZm1UcXpkRm1a?=
 =?utf-8?B?azIvUWs4dXNXUmZvenJQT1g4c0pnQ2c2ZUNkQ0dWZkR5VXBra24wMXEyNWNy?=
 =?utf-8?B?QWRpU29RWGd2QzlldFR0YkhLOGlsNjdjN2h3WkNVY3BhSUZ2dHpEcTZQQS82?=
 =?utf-8?B?bUUwektYdnRxQzN0cGRjVWZIb3FtQWlpb3hYZjJpOSt5czhqeWhFUkl0UkQw?=
 =?utf-8?B?emxZeUVUL0JOMmxHT0RnbUtsakp0Unk0b21WSnJ0UmhrSmNJUDBGN2tQMGsv?=
 =?utf-8?Q?P2gfKNCivD81LtOEzlliLVRvb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TpJmkTkyQgKWwwSAZN+9T7aLjTAxcr7gPwPDOCKx8WugMmtvbL6jZPbKM1rxh+aoKnRlzNq/+0dYQy34BOnL+0ZZ5HH1cozBYbi++9Gm1bv8Nxuk4BQ7hNfhnNAUQuPZpXSFzZb9laNAm6Th3wx3zqXBYnE4Db1xOzV4y2woe1fe8tXjti3WsCcl5iLScWr+ZRZbxDc1Maw7sKtRZylbd4qQHyqu7vgtDwukqX0ruN7+00hT5lREDOkwSVmBN1eFhPYfuk98QSpCblKIQxydDw8Sg7Q927u4VQ2ujBAyjJAngY82GfVQFAfNC8nxjQsZnTQ+RhtRS1ujWUgrKqQ2sMTi2+2IKOt1hjYSUmePB/lZ2Ic+/k20Kr+8We6SeoLxUYSOAXys8wwsu/GK8PQ/QZxxEW0TSn1uHJ2PlQ/r2HggYU9unl2jH2eAhHWMwDmsjtIiNvGSvps1VuvGuuhIyvs8yu5UUqs5w5nBdq0Jw1KTuLeoyRSPL/HvNJbYoh+H0HyUgxPcd+xNHwOzqi5jx9Z9yih4htNWDtf+sd7Klhhed/q1t6VuU87eCUOhTQylHUVj+gSss6k611nTfanCcKReJYoDs3+2F+RRS1YBiFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 626bad7f-28d5-4fdf-313e-08ddad6f3232
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 07:18:45.4796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAwHWCR+wqqBYsyjXDtozJ4AZK73yy5fhaXRe8rDq2Xnr6dj/kLT570SloGGbQOuUM14Wx0Ra0msPlgpyNgqEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6258
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_03,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=982 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506170057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA1NyBTYWx0ZWRfX3k3ijkH8AXCn ISkq2l4MOh20HW80i5jSRuvmZyP3vkBJ4F2aE9xoqMsggG+GkhWqenB68RYe9FYbrNRi8yZ4g44 QkcDgTuotTARAXAn+HoOekTiwgLWIw6RIhR1KLlqhFFpWEnkOPb+G7D/lbPWcOXJTPXMh+9ut3q
 YqAA3udw/DmIeJugGAw9A1KAp9YFcZwGulPGbVBOb2DJgv3V8NqJFGm2IgH7d5zQZFA2zuGRoAD aFrRx0IeIwZ2rraVmrI5SSKKj7e3rhuN6I/+fKXcJ8lABlHCROrZCy7/6Y7TQGUxL4jCSquvpGe qEzSZuqc/cWh8fUAqBuQWjwCBGgV0+j4ePlZ7yvnanPtULcixoON0n+9f8c1Iszyi3uonX/mu6N
 Z18prUlLCiAqd/V59KpvGtJXzCbdVcECApBAejUI1dKsS+QmlgoMnPO86vxvzWGpfltUZfU8
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=685116da b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=LYj2wnbMdLeu6cyAY7AA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: WaKlWHsNGI8255GpZbmReA6x-ORJ0zX_
X-Proofpoint-ORIG-GUID: WaKlWHsNGI8255GpZbmReA6x-ORJ0zX_

On 01/06/2025 02:40, Aaron Tomlin wrote:
> This patch introduces a new module parameter namely
> "smp_affinity_enable", to govern the application of system-wide IRQ
> affinity (with kernel boot-time parameter "irqaffinity") for MSI-X
> interrupts. By default, the default IRQ affinity mask will not be
> respected. Set smp_affinity_enable to 0 disables this behaviour.
> Consequently, preventing the auto-assignment of MSI-X IRQs.

You have given no substantial motivation for this change.

On the cover letter you have, "I noticed that the Linux MegaRAID driver 
for SAS based RAID controllers has the same aforementioned module 
parameter ..." and " I suspect it would be useful ..."
