Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232252E3361;
	Wed,  5 Mar 2025 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741191414; cv=fail; b=g8TGE+XDzKVDsMF4TDZ9XM54bhE4d4HC60qnGajmY3LQyFvoQHcAVWC2Cq8YxvPqY0WknRCswlp71ohBkE+3hIb+90HcZqjL1yAcgOlv5R7kQaI8029dbQtXWLrM/XEU7EMoODCoCDza+T+LkT98va2jWPIJykN1ss32IVstspc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741191414; c=relaxed/simple;
	bh=OWJbHCEr6f9o8287emq3xruddN1g+uNQoaJq7oSRKds=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pcsY3W4iFxxlkF1zLlyoxnhljm9iREqltuIlJvfjjUWrk59soOr08T8PI8GgN4xZ4etkldkYcjroffWMCXu8mqJI+WpCBDVfh87a0R3XnlanNFMQOAR2avtXb1cXoUj5NLTdjjzypM8U2jjwxASHcPfPQtk7tMRioaRu2uDZxRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lz9LwtOX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=weQDc0lx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lz9LwtOX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="weQDc0lx"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 525FtwPO030460;
	Wed, 5 Mar 2025 16:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Dtwjs6U3wET04RN16+Vws7GJblOqdUIjI6MNwAqGFWc=; b=
	lz9LwtOXOnF+tS6/ohBv1JJnj2U8nF0M+O4UQaz1bOGcTTLMTYFez4pzV+70Mqy1
	ScQ85DOAwMM26TgaqKFwSSHYOWNsBPzNONcTpuUfRgARkJmXU0lj5GfCZ41fAuhi
	cKmgOLcnq1HI4loigLqv2+EvrZMu8294dGWtagW4l87rvIRCnjZ9EhzjeGOnes5+
	BV5Dul7V1aq36bP9yc3FPs5eIdrsJfpbizWMoYL7mx8nuF6SbP4Yo/vrR/XfRuDK
	Mr21k2XVobhIjliNHroLIZ/E0uB2bCP3AIV+QSFhs4u9snDtKsvxFw8d/69ybCGP
	YfPyQJ0sz47TljmoAEdEmQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub780ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 16:15:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 525FuiYo040417;
	Wed, 5 Mar 2025 16:15:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpgvkxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 16:15:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NmozK07STEQSraPdfMFxNMjsZnnD5P5LAz/54OoU4eIFY8VyyADGENqvDqaM5zpU6h4vyoZ1b74QLkDCwg4EEb/v7bMgn08iEhUxPtBBWYNr0gZ+fJ7oJbF5wqUX5D4CIfpxme+2qoseiQAvbeW6REsbyj9+QADKwGZrqCLAGzrvDVDusyzHWHK0MA/xXd/3g34GMWZDriD995jSXaxcRFHhzIlwaEfnDtugK/F9c5uvxMCqXcDaeiwFdBOW77dLHFmmm1jPcT4Uj9BZV6VWnMBfUGt4bqmpzCrKuOmZ4v1F50gA2IWN55MllPQfx8OpHUA4Ax9kou05r8RplAL4vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dtwjs6U3wET04RN16+Vws7GJblOqdUIjI6MNwAqGFWc=;
 b=wUWfulAPk0gjBcJaPLjww1HVt8W0JCCY8acIBTD5irH+uMg6KvUfQvrqqoJeRrIXhWNrtVR7sEvFeOHHuUHB/hYvWd3VbK0Vu2/vluMP3CF1rcWc24nyX7pAmMwqfe7jqavHGRE+tGM6ItZaLpwY1ixIujsHzj7QuUeEaytaq7OndHxWtAhU7PsauXmhmu0tRBgo7H+o/Yjf7svgcTw6xxtJwkjNtJv+55AzBxZgwBEc+xmmYS9igUyjP3vki8qaMKzSYAbna+wkXperavUTYsAgmdspuy0m5xY7SV3UmFJ8WMzmMLSt8jr3qwZcf54+vLuhPFnICuIUZ3LitaMpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtwjs6U3wET04RN16+Vws7GJblOqdUIjI6MNwAqGFWc=;
 b=weQDc0lx7lSQnzA77xKuO5NlF1N5vd8ZyUR66fap3VPZTAbSsHN3qJpmcsOmN8fsLZY/jqiCVpTrNT/bAZvbBNnnL0YYfoE4osBWRK9Rs8/gewjBpQNyhDXVzh9s4qu9CYDDo4F0//4f3AO1J35DYK749Qa4I6OC/UPuomuTsdo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4604.namprd10.prod.outlook.com (2603:10b6:806:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.16; Wed, 5 Mar
 2025 16:15:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 16:15:46 +0000
Message-ID: <cfef9d7d-adf9-43d8-9244-66f4eda081d2@oracle.com>
Date: Wed, 5 Mar 2025 16:15:41 +0000
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
 <4279fe21-6db8-4deb-b5f7-663720637cf0@oracle.com>
 <2a59bb5c-797c-3745-384e-791a74858930@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2a59bb5c-797c-3745-384e-791a74858930@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0093.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::46) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4604:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f01528-7c99-4818-abae-08dd5c00fc6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjVUS2duTExYV2RDR1dEVUxuSkZJRGN3c2Vac0M5TUVTSXRzMXU4Y3NuTEhC?=
 =?utf-8?B?R2o2OUxEM0tIVDJKYzFWSGhEclp3VWRiQkgrandWT1BOY3N6RkI3UE1ZY1VI?=
 =?utf-8?B?NFBSNkF2S2hmTVBXT3ZYRG11MUNnY3VacDFFM3ppN0VwYnEvK2tmZ1dvdkxH?=
 =?utf-8?B?czRKdVJUcVpmNXppa1hab3JsMTZuRm1ZbytoM0dPV3NSNjdvTlFwdURIdmNC?=
 =?utf-8?B?ckFCaHh2U3pXeWl3RzBCa1FLcUdFeDRmcjdzK1ZwdHZiTDNoN25LNnNGTSsy?=
 =?utf-8?B?ZWVaOWZrYjR1Qm16YiszK2ppRmZYcHU5bU93TFlTckdXcC9odlRNTjhuWE80?=
 =?utf-8?B?eHUyTGFDOXJ4RmlycHM4Q2hqdjNoWWtyZlZ3UmZiREhaVDN2STZySEd5RWxK?=
 =?utf-8?B?Ky94dGE4ck5hWkhLN3lVYmNDTksxQjFVYjFYZlNRaVk2cTRlQjlZVnBHK1Zy?=
 =?utf-8?B?QkFmeE5XbEZYejhRZ1hQZGlFL2h4Sk56UmdxcFFvYXgwOWxVNktuU0Y5WTVJ?=
 =?utf-8?B?aTd1M2Fqblppa2NBN0ljWTgrN0RDcWl4SEpHYlRwbDRRZDhnUjhaZ3JseEV6?=
 =?utf-8?B?QUVjMllnOHVhQnN3RlN4RU9ReGg0UnZNb2tERnVUMzF6YVZYbk5GMldSeHU0?=
 =?utf-8?B?cXIxS1pEOFFHcDAzeUtTWjlhMklha3J3cDBHZ0FVMDNOWU53bTBBUlg5ZjRk?=
 =?utf-8?B?K3BGSjBPZXR2ZGZrNzYxem5pUjhLTU5jWFJSWW80UU1PSFZMN1NmQkJDRnh4?=
 =?utf-8?B?OGhtUXVqeFREZTNmVi9IejdXd3dwVkh0NVlucHoyNFR4SEdrRDg2cXpOVGVW?=
 =?utf-8?B?NXk5MVlacW1NYTFlQ2ZqemxFei94YjN3VEZBcXJUVzV2WVh3cjh1aC95cnI3?=
 =?utf-8?B?TmtwS2xvdkRsOGErcDRyQ3BJckZ3MFRxSG55MEFybWl5UTYyOG1JRjdMNUpB?=
 =?utf-8?B?M2d6WVJiNVpMbThRenNIK3NuQ2FTenk5dDRpRUJEekg5S1o0YXlURzNvYkZL?=
 =?utf-8?B?WW12MFoyOWc1bnpQdFlBNDBmRVlWeXlVYUJzTFNGTW52UWZQMjZudklGSUJq?=
 =?utf-8?B?bnJiMGZ1dHE5NDZ4OC9DeFYxTWxpS1VpUzRIY1ZsdjZ0ZjdXZmNxNzh5T0E3?=
 =?utf-8?B?djJESlhHbG9RUVdBZXhWaWRLWmVSdk5kY2c2Q3JkbWYrbXVjeWZ1VE1GL0lp?=
 =?utf-8?B?TytrSnRJYjdQTVFwY1NkK3BmcXNvT251ZXQydXNhUGZ5VmtDRW55ZVM3c0hk?=
 =?utf-8?B?ekFCSFdhbVFrQW9YalRSMUtNNjVURlovZjZmMHo4VEp4OU9wWEtCTUdZSWdt?=
 =?utf-8?B?MDQ1VDNJOEVQN21OeHFwTk9EbnVaekoxdVo0MjBHbzBoRHIzdEhNelZiUytL?=
 =?utf-8?B?eE03Y25KeGFMaVJBc3BWU0s3SkZhbkRRamNsTmRORWgyZ1ozUVBPWkFCUjJM?=
 =?utf-8?B?bzRGRUdERmJkUS9aRnFrVllaRmtSUkw1SWNDKzhSSmZ4bzdwSyswUC85R1Ry?=
 =?utf-8?B?cFZpUkNxYjdZMXpOV2hjelhFemRlY0U3QzJmMUxyZU5vUDA0WTIvbHpQWklQ?=
 =?utf-8?B?ampVdFZUVWZUbUprZ0hRdXVzb0ZZSkVXT20xMVVoaGtGUGR1ZjNaU2FIYUYr?=
 =?utf-8?B?Mnl1NU9DTlFLL2tpaTZ1K1JnYVBqeFlkWjhwOXVNV0EyN2ZPRGZBeGcxcnBG?=
 =?utf-8?B?VStuWEptcGNKTUlvR3Z3cXFSeW84T3NwQU5XOFBCM3FkNG80TEJTM1hZQVkr?=
 =?utf-8?B?eitYK2lWanNCMzVtRHc0cGNvRjZUYjliaTlKdC8rY3VrOVBPZmM0dHRXODZs?=
 =?utf-8?B?QkNrTzRvbzVodlpaUkllYVF2cml6eDNqeFV1UEpmcmhUb3Z5M2VXVUVqSy83?=
 =?utf-8?Q?/4NzEmyZEepcV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmxKaTl2bUVNdFF3S05uM1VrT1BiTjkwZ3RjMFlFZFJlM0g3SG1OWENmcFlp?=
 =?utf-8?B?a01HYmgzS3NVQ1pVVXRWeW5RK2NSL0VvTnJTWFBQYUU3bzQyMzZZU1U2R0E2?=
 =?utf-8?B?N2RpMUJZU0JsMzB2YVVxWS94MHp3ZkdiczlERTNFTHZFWXdvakFpdHgwS1dK?=
 =?utf-8?B?NXoyMnUzL1pOTFRLaHlMbVBwV0hPU3RaZi9HOFA0RmhaOFgzNXVsTG1hcFZI?=
 =?utf-8?B?ZDZNUU1aNWNLU2R3TVB3akZQWXB0TURya1E4eU44ams4dXNoOU1IQlpJOVUr?=
 =?utf-8?B?em81NmhQNUFuTWdqR09IYWRXQ0FobU5hMTV3Mjd0LzFLcjc3UFdyU3FrZE85?=
 =?utf-8?B?alI0aS9TaFMrWS8zVExiL3lhd1hOaFROZksra0hhMzVyTndhV25tWk82OVpB?=
 =?utf-8?B?bkJnOVpqZDFZSFhEbnBkeFNoa25Fa0lldjhFK2ZhVWpHRDZpZ0gyUnAxa3FQ?=
 =?utf-8?B?djRjMnpjOWpYZVFOaFVTbHVSUmtoeXVxTnZUa1A4WnJRVEUrR1JSVS8wcTBL?=
 =?utf-8?B?c3YvOE5lcVZQMFZId0V0ZVNkRDlvbTgyNkhsejlzbXliWnpCWjgyMnRSd0R5?=
 =?utf-8?B?Sk5OMXpmRG8rdVZYOGorZjVBSGxoZFlJMlFtcjV3Q0FyOGthRDdVQWRBaUJh?=
 =?utf-8?B?eUVBbTdDQVdzb1lRbVJ5UTFXZHpTMWhyNHZDOFVnQmNLbnhyUmswdW05dHRs?=
 =?utf-8?B?aythYnZlQmJObXA0SnFoU25tM2xJdXR6bU95K0lkeGpFL3lhbkVXS0VrWENZ?=
 =?utf-8?B?MFM2amhuOGxCSXNsenVjbDlTQUZ1dTRrQ3A1cHlFVkdhajBVUHV0UUxneis0?=
 =?utf-8?B?TjNaUGs2aXlIQ1lkNWNVQk8yc2FlRURNdUplTE5KWURHb1VQWVltLy8vSldk?=
 =?utf-8?B?T2JXUi9WeVlsMzYwSThabThkTWduT0svNUVWU2JYNUpvcmV2VE9CcTQ4bFhu?=
 =?utf-8?B?RVJJRGRZeGthMHZMdnR5VHpRWUc2SXBGam5tWkpZYUI4Z2RzYXU3Qmovekt6?=
 =?utf-8?B?TXovWnpLQlpDcTJpbHNsS1o5N2R6YnhONzg0b0U0RG9tdzdJTXpjRjF1dXRz?=
 =?utf-8?B?ZWZwOEF0L01jVlhSQVdmR3dvOVZHMmMxRW5EZFUxWE5kUEt1MEFHWnFsVU1I?=
 =?utf-8?B?OEtKTmE3SXlJRnNlaEdNWCtMNlBpUUxDaGdkNTFvMXhkVDgwMDBPKytWTm9N?=
 =?utf-8?B?RDA0VkNRZ0tjbDE1aGJDZ2VldGN0Vlh3QmVWamY0RC9HTjJYUFluK0pSOE5w?=
 =?utf-8?B?dVRaTmV3K0R4WFVwZ3JWK0pLcU1NdUNXdndVc1F6ZU5ucGsvYlF3S3AySTRN?=
 =?utf-8?B?UGttUzhaU1E2RUFRb0llSytaaGZtbGJVSlFTRFgwUFN5RW96eURZMlMvYW9z?=
 =?utf-8?B?emZVS1lLM3ZBSTZGVFQ1V0laT3I0RzluaHNOYjdQaDIvMFhDSUsza2lHRUc1?=
 =?utf-8?B?VmNVTnVJdmF2cFdKT0d2aWE3dUxMUSs0U29DRTJLRGlwK2FYVXdQQWZGNXAw?=
 =?utf-8?B?cU1ZR2JUUVBrNzdaWTE4M01leVJzcUswa2UyQ1duOHFlUzZRR0xsOTY4bTZx?=
 =?utf-8?B?YW1nU3ZLZjZHWWplcWNWL21xMTBJWFRmRkdnZWZpZGk2QlFUNEVSVGdJLzFV?=
 =?utf-8?B?VkR4RFR2K3NwRVFCWmt2Q0xLNHFpdXM4MkgyZE1YalRzVVQ4MW9ENVBvUzB0?=
 =?utf-8?B?U1VKN2cvSDJrTGlFU1JBTU9uczBMM0VrRzhzRHM0VTYzQWh2ODArUmcxRmdB?=
 =?utf-8?B?bUdEWnJYbmFHRjJHUFJnMy9pekRHNzRncWdVZUtLRWp0ckFYK2JXcW1SOGpS?=
 =?utf-8?B?TXl2eXNWcXhKdDlLcUQ4VFppZGIwOFgxbEo4bityZnk4c3JkNzk0bzFjMERr?=
 =?utf-8?B?V3JxZWNuWFV1SC9SdDBocHFvRlVKLzBxNlFnV01jMi8vNzUxZ1dTYW1SZFNI?=
 =?utf-8?B?RTh2YlB5Ymg0aVk4b1NLb3VrY0E5RjhEc01GZlJvQkRJM2FHcTNqc1E4NkRV?=
 =?utf-8?B?TlhWa1BxZ3V3Ukp1WXpWOXpqM1RUWmQraDR3aWJTOTE4bTRJRGtqZFZSQjc2?=
 =?utf-8?B?YmFtSmo2eFl0djZZeTRHeGhqbkMyMEI1UWxlcEhoc3ZHZEN1NjIwKzlHRzMx?=
 =?utf-8?Q?LzUq7sZRrBwVQ27+D6P0DsumD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gLRDF4yYj2ZDJRZBNhH0G+5J7NLOndDYNPKuKT6+SJsiwSwVXmCduEUUzvynHsoWEJbmxrFPsEHwIRIrZUEpwkXOkJUEjURc50b1rRCv8JRDckZzT1uACP88pp/P8K0JpcQyWawtdmgOQMRy9hRV7sbQDNvNQbWOxWk3NEz/G7x/unDoHZQMe5lYAGN/HyqZbqwBYSZEN9ZSUbEs4C0WCypK5fV1o/ywMG4MQ+fgQ3kIShGj3FcuvwEfl8MlCLY5D4YBc2oXFersGP26GnqxHVUjYapEAHtjZYLvHOKHl6cZJYbQHpJkN4oVslyXS5LqqhX6XYL9nYXhrxvlBo79UiknoJHOvlxmy6h2J+hBAUhheKv2ti0udsX7U0k/NjNO3Nhob2pCDcg6uIBOXRu9ahK9NC/SLO5+7czt6i9Q/AQuN43Z/wmWROyTpCkRFarV3aL657r55IT8uBmr0gezmxsNaUmhTPxTNE7MnVeiqaK5CtGuiQF8Mi6+IldkAO0FJfyyCzn/Mpf4Bzf/Zyr6M5qBUonP6q4shQNWCwwV/iXiQjI1HkVXg68ak8dZ115MQr67y/glT81couGhZ3I6GCw22FozUygv2hBKsh1gEI8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f01528-7c99-4818-abae-08dd5c00fc6f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 16:15:46.4360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PVAtrSJf9mlWhKNTVi8xZH8Jqobf9NnwX6AYHf2iiDx2PFDGVAQEzIAq8MTtMyQ0lB4Blf+tqIDDCAi8AtHBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_06,2025-03-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503050125
X-Proofpoint-GUID: _2lPB8DGbfFIZHxVCdffub7km5g8OvfV
X-Proofpoint-ORIG-GUID: _2lPB8DGbfFIZHxVCdffub7km5g8OvfV

On 05/03/2025 08:16, yangxingui wrote:
>>
>> Sure, something like that - you just need to get libsas to trigger the 
>> proper hw port id assignment for the device. As for specific 
>> implementation in the LLDD, that up to you guys.
> 
> Thank you for your suggestions. The disk was finally restored to normal, 
> but the error handling took a long time. Since the error handling would 
> set the host to the recovery state, other disks on the same host would 
> be blocked for a long time.

But that because you have IO inflight for the disk which was unplugged?
