Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776AD2141C8;
	Fri, 11 Oct 2024 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728654991; cv=fail; b=jyDnMcnq2HsO1mQhJsyGl84btje2Eckn7HFMh27e4ClhRr6bFXUzivth2p2h7T0rgDiCPr3PqW0eepOZ+Olq9VtL88IKzgpPbQpEb0G4Z59lNmtPsMDsmffjGrduzr63WC3DpFrulEiCXT7v9IXSFqCmEqN8ncvCBJ++M2y/63Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728654991; c=relaxed/simple;
	bh=CwlMTl14808FtDwqiKvc9u1tkYJHQpVUDxH2kvagG5A=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mvZQ36+AuK51Hn40EX/GJMsFvhv/+3XfZYge6gRuKkv0dd1OmH6dtmrTxOd6MNZ9M7T71ycZpoAYIYsjz6LcUFNfGwGm5Gyrw73rCVUas1bw/zUvUK8zeKQz3bb6QDBb/yT/JJLNHVmjf7+Lb0AFSWoSlVJAsyjohTM0EFsNUc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dloUm8md; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Pm0osAXK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dloUm8md";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Pm0osAXK"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BCpd2l019639;
	Fri, 11 Oct 2024 13:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dUDiqi/28jBMtqOKJrYNPo3tZrnYMHFMxq3YmGvBa3w=; b=
	dloUm8mdL9jlx0TXHO+MuMN64bG0AZfCarEPg6CmermXVBbvOEKa8Yn8e94gjRXm
	jmCE3BmFRRQKcu8arBSHz2uL+1jkJ+4bKus4/s3q8GtgAL8EmeliW0eyE2v8fp80
	1e94CLjghlWaeWMvvBwJcNbe8X4hmBmeWSnKcN2F3RU0wqKPg1+AIDxmjPqLBQkH
	irmHBAcHlaeSyZtpCOwXZzi/CEdo26GudwJIiqch+PAIV1Q/D5TvkWmfB0BlI9kI
	uX3CTHyJD41p+MR4MJ1TjcqYXwzrLIyW/uqRjAr17DYMQNxnjGYLG66YHWpzLgfT
	SBfKDWgh2Jo2TgSRs9z4Mw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 422yyvcxkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 13:56:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49BBPSSN040261;
	Fri, 11 Oct 2024 13:56:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uwhnvrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 13:56:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ux9dkQfWba4Nzh3/SGvadykiYUxZDEUosBbYU2x/LNKKwKyE96re25YZ8HF9M3wx1eZ88BCyrUOqXidsqe4swnkqI4R4rdixtf9/2qtp7Dc88oLhBe77ek2bIW8jQZ2jIjBh6a5fjN7bXwlEaBJYCtPyTv5ytiYdI5jNiRhAQ0SABGu1rHMA3m5QZ3BMbYJXwEF0KvfU8ZD//WqRHObqkZQbNRbBuX+OytTE4GTj7YN3cHce3p6l9B1CvbCPdF3Y8kTZR/RDXqZ6dG7ZENM+MWlsC18fp44WgQQKJu0spN5RWFW9EBHTs8lAwG+52dL5D0ezgK8Swn2Gnnl8EWdZpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUDiqi/28jBMtqOKJrYNPo3tZrnYMHFMxq3YmGvBa3w=;
 b=bLsE0DEP4VYm+NLkMc6NDApfCgS85Rw5Vyz836ASArc6u+EGmLlFsoH8OsnVo13wF9SFctRnyCGtz1zeb2PE141R5Ld90M/cRkx8pDcYhVGMI5LSugzHpGhFXXSxtt+US9L9QlrKTat8QJzFlOfQ0RUOuha3AgGzkzwu0G0v4R2zat17K9GHK1+6kqgBik1vTFkFQUIjbset2c5AyRIoDwQiwslnb0RvnkBGNP/FEznYa23A1E53t+K17OiUVrwEMzH98ahDhdmCdccEzjhiLrPtPfP7wuCzThMA4AMfQzhh2sjm4odYh+DhK1JEly0zIL15E0MaY1f8lYz+Nv2pwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUDiqi/28jBMtqOKJrYNPo3tZrnYMHFMxq3YmGvBa3w=;
 b=Pm0osAXKLFFZP1GxaieluzS9vXZCTQ0wDdeWnwq1r5YB9zRGo0szowEfEi6H2Oo+xiZIw1i9YPuUdUuq3YndUNIL8vAOQtXkbtUA8F0jbHFNQ6tFcyJs72z4DP3V8ga0GZfL2TKjfquNxCnwNilfmWEhOE86Fl0QoCRE4IjyR3g=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Fri, 11 Oct
 2024 13:56:17 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%6]) with mapi id 15.20.8048.018; Fri, 11 Oct 2024
 13:56:16 +0000
Message-ID: <73007761-533f-43c3-a721-3dbaac741d41@oracle.com>
Date: Fri, 11 Oct 2024 08:56:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: core: Fix null-ptr-deref in
 target_alloc_device()
To: Wang Hai <wanghai38@huawei.com>, martin.petersen@oracle.com,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241011113444.40749-1-wanghai38@huawei.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20241011113444.40749-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0037.prod.exchangelabs.com
 (2603:10b6:208:25::14) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cf97c24-2cf4-4b75-2307-08dce9fc79eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFN4Y1lNS2FDcEV4WFpoQ1dYeEJjK3NXd0JacUNTNXZDbDJVOXdkZlZwN3Rj?=
 =?utf-8?B?UmhpM3NuZFc2SzdOcEN6V1pOQWlxWE9naktuNkZIV3dHQ21CL2RzQW1VK09u?=
 =?utf-8?B?dG91ZmE0ZElJcXgrdWRNK1RRQ0FKZnNXSEhwd0hZVlVndENLbkxGZTFyY0xN?=
 =?utf-8?B?ZVZmZVNFOXBkN3BIczdPUWowZzEwd2tIdkljZi9iWklJQ0dDVndxb0pGNVNW?=
 =?utf-8?B?bWhET3RLbmZmV3VLNDBPZHRxNFBhdzRpSjdWL0xDNGJCS21NZ0RmdTRHbG1k?=
 =?utf-8?B?L1ZVdGpsL3lyaC9tWHZUUHJUSGtGZEZRS2pxbjRHc1cyT3oxVmEvL1locGdK?=
 =?utf-8?B?NHcvRnlQcHV3YTFiV29aSlJpaEc4aFhBWC93YmJJczhnZTdCem5jZGpYMEdC?=
 =?utf-8?B?alQ5a0hyV3NSbFdXb01uL3Z0Ym14bFlqZ0Z4TzlEY2g4bVYxSjM2S3BaYXFt?=
 =?utf-8?B?bUdHWUdJQkpuam9FSGMwaU8weDhRUm5BdWlYQVByWFNZb2o4UEVwNGQzVUVU?=
 =?utf-8?B?NlV3UnV3REFLUzFqQmI3dXVMWDBRN2lzWmFYVHZNRGc3TUI3QUs1M3lSM0Vk?=
 =?utf-8?B?cmVIcjhwQ2hvREZaRkpHdkRhbmZxVGc5ZDNUbVVXMW4wWGdBZHNRTTd6VkM1?=
 =?utf-8?B?YVhUckorRStNR3dNRW1mbTlBUEloWHpXaDBHMy9PYk51ODFOdEtoV3U4Q1Vz?=
 =?utf-8?B?VjExSE8rMkswbUlkNCtSUXg4RXZaU2JBMXFmZ0t3NEV1Wnp1Y3ZBVXJhSHpC?=
 =?utf-8?B?Zm5WSHUwWWxSZi9adWpjcm4rLzU5bGZudWVNclpzRjZuZ25QYVNhc0gwdGtX?=
 =?utf-8?B?NXBIZmk2SitMOXg0UlpBcEhkNzMra29IYWdLaUpHT2pISmRuc085Tld0Q2kw?=
 =?utf-8?B?TTBmQjU3cUxtQndVTmhSRVdyZE5ESTlaZW81clhVRXo3SCtaNzhzeVFtUnJy?=
 =?utf-8?B?MjRpa1p5VHZpZlZjdWY4ZFNnMmRoWnV2NHNhbEs5RHJZaGM0b21UTWMzZFcr?=
 =?utf-8?B?TllraWQ2aWN5bVV4cW9TRFdWbjhPc29LTjdTV2Y2cHoxVFBlNzIwZFVqOExk?=
 =?utf-8?B?QzVZeWF5TDQzRnVCSGQvcHBzdnR3cUJjK0Q1NHRWMEF0OUtXOEFhRmRGUDd4?=
 =?utf-8?B?NVBmQkE5NUdTby9pT01SLzRYdTdnVFhDQy9UcW1xRndSZENzbHpLVkUwVkgw?=
 =?utf-8?B?QUIxWjZOdmp2ZEpJZEVTZVBGRURvN0NCUGgvM0JyV2hyY2dHTjQ1SDlsTy9x?=
 =?utf-8?B?YnZpQXUzWllHbXV5aGtlTE1NN0RyMGhiZXVQZ1l2NHZmbW9SNWFUS3hLVHp5?=
 =?utf-8?B?c2huYVBvYWRoWXY1N2p1OUIrQmVkWFd1V201ajczQ1Bra3FJODFOSW5oNXdF?=
 =?utf-8?B?bUFQY2Ztc3BkNFFwd0ZGenFiUHpGdGVVaFVTUnUwWG1YSkwrZTZjN253MlpV?=
 =?utf-8?B?UUNRZnZ3KzhUQytjYlRqS1h0Qkg2L0FTVEpVTHpFenoxcXFQL2p6R1BIZktT?=
 =?utf-8?B?RjgybWpsNTV0ZWRodkhMeHk2bVBmejdVbVBDMkVtVVZjY1RNWUY1cEEvRW5Q?=
 =?utf-8?B?R2N1RGdUZDNTM0ZCZEh1SDBubEZUbnF0blR4eGhFaGNJRjB0UlYzc3dkQ3pZ?=
 =?utf-8?B?SlZqZ28wdVFaZGZLU1NueVFzdTlnT0xRbFQ3T1pPQldQdG5nbU0zaDRySVRB?=
 =?utf-8?B?OVJHUUg4SW5yUTJQNkhlRnorZklWUGVwVE5UeERxVVNYR2hXR0lNb1pRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWpDSzRyZW9ObDZ1MnhYS09JUXBIRHpyZHNESkcxaDVTbk95cVJ3U2lFbFVy?=
 =?utf-8?B?L2FkY2djYXdtc28remFCQkdrdFVpdDlieW9pQzdrVTZ5SGlwVFdFS2hmU2t0?=
 =?utf-8?B?TDM5ZEJlZWQ2SjVkdVdCc3FEeVVFSUR4T2lndFU2c2IyNWpHV3dYTkYzaEhO?=
 =?utf-8?B?SUlWaTlCdDIydzRhS1ZUdnY4MUxHRnRyMHg5RjdPMGp4V1NhVHBpb2plYnQz?=
 =?utf-8?B?dFpZSFVSdXVrcEdqVTdmRCtEd1g0KzJmM1BXUW1QZW1QRFpJaE1va3ZqOXhv?=
 =?utf-8?B?TFZxYm1Cd2c0R2J5R1NDYmFRbEcrako0d2ZucW1yU2Jma1ZjYS9lS2k1Zjg3?=
 =?utf-8?B?N1NsS3B6OWpUVVhTL3M3UzdTdWRpb3ZMbzhXaHpDMVorV0lyWlo3cC9vWFZT?=
 =?utf-8?B?RndVUWZLQUl4WXQzaU9GTnplM2krNmcyQnhGditxem5udU81Q2hhTFNWQk1G?=
 =?utf-8?B?Z2dxT084OUxia3ozNDVmNmt4M1d5Umdma0NUMW1hSEhDbDh5eFZiWDljM0dB?=
 =?utf-8?B?WVIrUDRVdUJiRmZwY3dQVU1GQzFjR20vMkVyajN5WUljUG13QlZFREpjSmx2?=
 =?utf-8?B?dUJVZi9GRzZJV1RkNTRibXQ1cmZHREN5d084WEt0Q3M4YmhlOUIvcklQQzd2?=
 =?utf-8?B?M0RKelpaaWpJakR5eFlwMFNFNGhYMHhvWkdFSm1IUzErQStleG1RUEJEWUp2?=
 =?utf-8?B?U2g1TXdiZ3Fma1pUUkoxQ01qZXdBWE81Rjd2cmprOE1yMW9CS081ckFTV1dn?=
 =?utf-8?B?WTRzazdQSS9hQ2hzV2pxUmVNYnBRRSs0bkpTekFONGhmVkhzcVk1UWRYR1Yy?=
 =?utf-8?B?RHdKVXNxeUVqZ0Uxbmp0dVd2NnM4WnhzSTNTTDZreXZmMlg0V01tanVncUlv?=
 =?utf-8?B?Q3MxWGJUTVJYYVRjZER5MW1MVE8rRjlPS2JsTmdySDJ5T2dKb1RnRVgxYjNS?=
 =?utf-8?B?LzJ4VWMrTjhGUFpCL1BOMkdUZUtlOGlxa2I4VGpZaTZmY1F0Rk5jTHpDU2pE?=
 =?utf-8?B?RklYSGYrV3QvQ0ZHdWxKMWNzVE1EaWozM2cyQVFGR3B3SmxTSFdUUk0vdG5m?=
 =?utf-8?B?TkNmZkNvR3FpY1krTmMxdlNOc1MwM2o4bUVoWWdCVDRTaXVyMUpPa0xHSnIz?=
 =?utf-8?B?NUVHVXdIcE84OGlUV25wMXJ6bzFxQW1hcUJyYnlMdjlxN21yY1RMR3NlWE5j?=
 =?utf-8?B?dHJkL3BJeWExaVlzcFE5Z1FxN2lSZHp6cklIcjhHTks2VzJBRHhNemIwNHNB?=
 =?utf-8?B?b2VReFhKVVRJRHJlMElWdFhzdDVHcXBxQ1J1TDBNYUpLNEpoVTRkdlFualE0?=
 =?utf-8?B?WWZKV0x5WjV4OEhmR1FuUVlpclhiZWxjdWNrMzlZVldrSzNkQXNEYjRxM2xG?=
 =?utf-8?B?bDhKbldROTV2bVlCc2c0VW5RdHRvbytnRmtiMExEUTdCRzhJd2xaNWVaVnBs?=
 =?utf-8?B?UUZwakNubW1NNmtRYVE0YTFGUDVhYURKak96L1FiazBHVndhYmlwRTBTV3JY?=
 =?utf-8?B?ODlyd1BRSko2VDBid0dubHczWDk5V015VGo2blRKdVUyeEZQaE1yelhGbmJ0?=
 =?utf-8?B?UzRSRHBYM2tZWHBBNG9BU0NzbWJzNHFNOE5nUWFkZTVaTlRwME9jYlcyL1Zv?=
 =?utf-8?B?QldhOStEZnNobUtJOU1WcE9ZOGRoM0xuSG1NT2JVNjI0SkdiMXdVYzV2NS9z?=
 =?utf-8?B?WFROMElRUVZEbll1UkMxdVNkN2JCWCtyR0pReEkrZTI0M3JSM3ErZTF2UHNk?=
 =?utf-8?B?bHJmd1JTL0JtdzRERm9vVWZXdkJkOUJ3YUlBbkFEQ0R6NWRZWm90NmtYa01B?=
 =?utf-8?B?ZjdzU2hLa3A1TkFEU0ZOMFN2SFlTTmlyc3hjN21IMDhqZGFzN1Q1NEZFc2FN?=
 =?utf-8?B?dGdHMFIvandybVR6VnlhWmdmbENOVkw4Wmw4eks2dlAxOXZNcFJRbkRVbHIr?=
 =?utf-8?B?T2NBRVhkWncvZ1JpajJJT0RNNHI4cUsrYjQ1YzBGaFd0Q3JBbXdFWGFLc1J1?=
 =?utf-8?B?RTYwcmlXak5PdExJRm02NitDQmlNYWpabmtMSjBxM0pFM2JZaHhGV3h5YXdC?=
 =?utf-8?B?SGhKVUlKdXZEWEpvQWN0blR0QnFRYmxCK2QrajhjVy84SitCaCs5RmhyZ0Jq?=
 =?utf-8?B?ZGJZMXNWNGVzVzkzR2s3NWdTYUtKWlI4bzhUVUZpajBDeUc4UWJFMTBMZnRO?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0QRiHmOIJRkWms1zKNTvSIRtDW/eXXy6/eLZASrSFsV1YqMVzM5TwaPBe/h2UNvtlJfiKS1RHVplVE5BcDUL0ftsbOHC07wir9SYTrkaa/nQVF452JCQsQg/BZ3KjYADoGPxIxHwzaxIsSLiu+GfGmKCm6G8DJXECvvRoaeZ/Iy34dZRtf3TfWYkFXZUg/to3e+9URi1CrhSfqpuN+Dfv7AGuxbIApqHix75lRuOVsIMjWe0RP358zjLmHoFBVjFnpMCyR/gRBF7NmysKz4Uttmnxu0nUEiKs+QxIvIcNWSWqftsIlmqDPgFk4fUajgJXL4T/5l2ZQW2Kai42IsfJQSBVRkQle8oweIgP/S3tg3KOGA3we1Dz46t9uTnprnl0eNE8qWxZw2KfCuH2OcrA2hgNuZA8EyimUmcN9qy4gFxwqUDw7Rjw4K3Z5CfWD34Y3bLaKlRD8oyX9frMJiWBObgvfMMNtPChN7Udb8YmZL69TR6B4StPRINpkX2h6yhG4w+fIn17ogQnNmAVXN+q80+GL2OxBYTVaRFnmz1wT6kuOZOlW9ZDDYCxQOkhh9+enDf+kZ0GVO7+lE5SQsHbUPHqb4FZ5Bhw2Mo1TCtYag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf97c24-2cf4-4b75-2307-08dce9fc79eb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 13:56:16.9331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEQDY34/WnxTOqVVQjT5opXMAkptomuq1AVZg8V5L+V7OtHmF5G1JVnxzCrcSyWb+Zkl+vO9kTZxdx9kLbCYJdkUc3hiGZ8Tl/7eh9WFYqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_11,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410110095
X-Proofpoint-GUID: g9wMH0PbpBXPRMmF8_1IOuoNLlnX3meW
X-Proofpoint-ORIG-GUID: g9wMH0PbpBXPRMmF8_1IOuoNLlnX3meW

On 10/11/24 6:34 AM, Wang Hai wrote:
> There is a null-ptr-deref issue reported by kasan:
> 
> BUG: KASAN: null-ptr-deref in target_alloc_device+0xbc4/0xbe0 [target_core_mod]
> ...
>  kasan_report+0xb9/0xf0
>  target_alloc_device+0xbc4/0xbe0 [target_core_mod]
>  core_dev_setup_virtual_lun0+0xef/0x1f0 [target_core_mod]
>  target_core_init_configfs+0x205/0x420 [target_core_mod]
>  do_one_initcall+0xdd/0x4e0
> ...
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> In target_alloc_device(), if allocing memory for dev queues fails,
> then dev will be freed by dev->transport->free_device(), but
> dev->transport is not initialized at that time, which will lead to a
> null pointer reference problem.
> 
> Fixing this bug by freeing dev with hba->backend->ops->free_device().
> 
> Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/target/target_core_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index bf4892544cfd..bb84d304b07e 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -691,7 +691,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  
>  	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
>  	if (!dev->queues) {
> -		dev->transport->free_device(dev);
> +		hba->backend->ops->free_device(dev);
>  		return NULL;
>  	}
>  

Thanks.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
