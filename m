Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC5A439F82;
	Thu, 23 Jul 2026 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802880; cv=fail; b=m7yP9pCxtJ552bCcrWcEleGGNQMyKeBS5Vw3/q8yFiBvDjvh/0DDixVeDgd4e4p1IQBUndmimsV7zE0KCeazrALPU03fMar8qi+TgmdEYsh5jMOmHplNuX/irzrlFmKOUtjMQAcIj3jM2Nt/AsnxItLxEA6/2TLQyZshW0L9A7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802880; c=relaxed/simple;
	bh=/aCr/R4FBaw8MDUWyfc+XTkgmMezJ4SYeVEvbZLg9zg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VD8n2W3/Mho75erRU+2AZpOjSRL9T8ay7LY/Pux+c6S4/xB8rexbVXx4vvYXay2Y0ahV7tAd74OhuVDSmxhPynhesgmK39yJB24vZtiKxNo/P+oCnAWsb7t2WJUal8EclH52LcMkoRfes563ukYTkNugB5vwXAf8PFo4xXqxbEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IXwCJC1/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SPX8VPT5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IXwCJC1/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SPX8VPT5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtntM3404403;
	Thu, 23 Jul 2026 10:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iX5OQQ1HKCVI/yspEe9tvqG0W3/dUTjMvRI2iOz59NY=; b=
	IXwCJC1/okbz2IZ6TyP41WVOAVsuU/JyczE3XRcYEOdIctSIMM8Xtsu/HedbNu0t
	XXrnId97gQsNqMfE51YB5AMGWQqv1vbJgmX1QCWfb/wHy4xxbg/Dw0R1XjKpbBf1
	fKGfHXXzTdEYps9PRDK8VR86/AZKO4voiw7ZwQbqgRvgdQr1tsaGDKKIvq4q50qN
	HiJAYp0hexnyDZBTYpxgn/xzbr4qW+7UCGLqu6eoRyN6J0r9QYWi/h3pNiXgIN4x
	R1xDiCbPoK3oPG8DiZyxCfVGrKK7W36CFzeG0nmwDTjNhq2eGNmijxq45yv68ErM
	sCbPC7KdTMhpeiy8n0jm2w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3ppms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:34:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAX1ux038171;
	Thu, 23 Jul 2026 10:34:36 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxd74sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:34:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r76jD8enX9IeiFf0hHrlhs38yxNMF21z9R8OYo7jOUZflPGmGnGnGdA48e/kGo2Xz7i3M+GyLiT7AHtp7j2G/o4EJg8/zpteyJYhz3d3oI17dZ9q4agmcw4+Vfoj9b+9ermTf9wSIb5ICg61QSq3SuOdaHy9wAY0i92FJ976qrxL6wY8sSc39JYSpflZZdScpFpzscV9I9wUDe9aSsKfiMSamL/FFVTWGjms2KHwI5MnVa4BVJOcv4fBtSceu1y2GfohW4FNsr94C0RaM6L8T9O669UeY0jHNfQFa0W1FIBEFnv1fj2eHcgF5oZc59hq/Vs8sYSK/Hh5NBA8tWfB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iX5OQQ1HKCVI/yspEe9tvqG0W3/dUTjMvRI2iOz59NY=;
 b=BNQdEr9XJgQmXN2EGILt5pDKtfnaDMRJQeCuWLYo+OPC5uhDdLxFwGFKFgtKxp1TfnSp8h8yq2EWKEgM/i6kQ/hvCWGcz1Fz+2p2Cf2uxhep0Svk6jZR0yQyt+Ok27EFsaQLV38Z+ZJ2okKG8vZe2Gyqm8UgmdiSYIjo+6jDA9yfIjgSWkjnIu1bJ4NLdiLid6i/iSYfnZOUyL82fQzbG9PMhdlOi6/4jypYITxdWV1TJrPSIkM3kRWuHqanFbjjwg+J2xQ+j/KHJtsPGRfE2TUap+aVy/0tb53g05eFBlMphE4WEP8vyXEaiDJkv14OjkaGYo+ZZEAIOB+OXokxWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iX5OQQ1HKCVI/yspEe9tvqG0W3/dUTjMvRI2iOz59NY=;
 b=SPX8VPT5RuwzNQD4zSOtH2Sn4cOhxpuVelcFKkrJVW4BYQj/9oJcpYQeagTpSFJeheQsrdmF5AlBG7tjOEDoiSwQq2LLIuDNvDA+GRrlFVnoB487Mi3HyVvmrGpkpDU1mQwXT+yOw40mO3jKWmBriTQBfDEIBhALJZXXxDuyG3w=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 10:34:33 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:34:33 +0000
Message-ID: <26c24f1b-0785-4236-a8bd-08fa4464fc9f@oracle.com>
Date: Thu, 23 Jul 2026 11:34:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/28] libmultipath: Add basic gendisk support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-3-john.g.garry@oracle.com>
 <20260723095745.A90D21F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723095745.A90D21F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f3::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 638893fd-4bfa-4d61-9be3-08dee8a5fc57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|10067099003|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oDKz5GnH39X6d/wbhBhltIxdjzX7e1IW0vuTlUZcYxePZu5AmYAjQrn4+k3VviCxZKPSFi8yhDuVwblCuPO/XGOR0+j8O1hgLk5Fm3RXBL6QQ81yWoG4dertjSwcTvj0h9ngp9h3wu8Get3dEJLsh0+WkcSYwvdrJFOsdMLAPnGoU2mFbpxs2fRCaoiafKx5o8aS/0xDqq3y0jLYgXLjcBTCS7eRC/dtH4fVvIWarhuDaSCS2HzdOybvUcpcrBo5Dm6UmQ7RLNy3pp9y+BMISZ3mmeBJN6ASrPSE71GYNBOgLqUuTrUqGwVYwdGDKBcBf9K2aByctjknt2mZYhJ5zexIltb0XKikaUw01QM6phnR4TVXx6ijPuPUVagAcFsX/9H9yNxAa/ugukMNS0TmYa5eiTsTfusWFRj9KEzfGZr16DV1JmvpsOwMJtBuISX8hTxWjzrY4rnOmmOFdR1YC2UDQPny84LOtgZ+mCO3fwoh/X8xFvviPtnR4LYvhuLD5GmC1Qz7E+bXvU+ySq6Z8RfSddG1P27n15shFiiZipjghXMgpMJLqofngJ7EfhIkZ+Tram6NwPbXzu+fHrQwkUxsQHd1EtEH4eJYL4/sXPf3BCBvwbzcSUM7FN8n2qy1F7kdUeWIhZn456UIkXa1wXwtGMo5/1XgJ9nwmCB8bxk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEJSb3NVN2hqQTdjci9aMDBqdFg2RklCZ2N6UHd3bmI3Z2xsQkxFbGxaRURR?=
 =?utf-8?B?TmphbkJFclNKZ2Zjb0xlL0FiaGxhdlBzMzN1Ryt0aDM3bFV4bTlaVjhUVVY2?=
 =?utf-8?B?UHBveWZScjZkK1RSOUxmTTl6R0tuVlhVd3Y3T0tFanFtaklUTnZQSU1LMDY5?=
 =?utf-8?B?NWJQS1lhalR6RjRKQ1NTdEErcWlMMnhFU2ZHN3dHRmNwb0xidWxINi81b0kx?=
 =?utf-8?B?bXV5NmlkS3JRYVlZUW1DM25rMEg4UysxdDByaHZVWTcxUDFtVDBYRGNIVXRr?=
 =?utf-8?B?Z0FNcGhwZ2lLa0h2eHQ1YlZkL3pUUGNXRW0xbDUrdFdaUnJFNndQV2RCaVVZ?=
 =?utf-8?B?Z0Uya2xVQkkxcmNQdkxiaFk3azA4ZTU4eVowTnF4QWwyeEdxbXhUZVlUN2Nu?=
 =?utf-8?B?Rk0yc1lma0JraUtSajBhcm9YaHo1amEyQjB5NXpZc0oyb1U1Uk9nSkExVFly?=
 =?utf-8?B?QjRBY1d0L1BCdGJRalNkWCs2djhGMW1IN0FSWVE0clhZSVpmT0NvS01KSGxj?=
 =?utf-8?B?cTBHTVo3T1VoQ09aVlVvQVdwRE9SVmRMOVlaSEt2UU04OWhoSVRyVExtRldM?=
 =?utf-8?B?ZUZNK1B4S3I2bWYrQ01UK3I1Skx6T2twMEUvWmZ3T2pnaVZPNkI5c2VNSFZ6?=
 =?utf-8?B?SUwzS1hZdlB1Tzk3QzZyU3JxUVF0VVgwRWtMcFhQNXE3MWxlb0IxaWIwelUr?=
 =?utf-8?B?QmY5a1BGN3NkRjBBN1EyNlR3TWJkcGhPUE8wRlErTjcrTW1wbVVzcUVpb2Uy?=
 =?utf-8?B?OGxCeWtpQjB5SjVzRS9KSWNMYjBpSjY1aGppMDhyWGlnaDJvU3Q1YWEva1lH?=
 =?utf-8?B?b2RoWjBuU3BIYzYyeWo1c1lPMHU3Y3NDZXRyQUl3czNBQjNRN1J0UjVyMURs?=
 =?utf-8?B?a2grcEdzSFBGeE90Q1Fqc1pwTFBGckZ6M01GM0l6TmlGZ0dWSUhZTEY1OHlN?=
 =?utf-8?B?cGttMU5wN0gwbzVGU2laNHlycWsrZWR2WVN0WVF2WXBiT3V0V2QxMll6RldJ?=
 =?utf-8?B?Z1czcFd5Y3dzNGZzQjJCbnd2UU92T2dFN3lMalRqMjZpbjVpaXlKRmRtNk51?=
 =?utf-8?B?VzhmckNnY1JscnI2eVJFOUxwTTQ1ck80dnVsZmtUclBROWpQZmtRVE1XZkpm?=
 =?utf-8?B?a01rYTQwbmp0dlBmNldkZXplOVJlRWczOEZwa0lGQkF1MnJFMjBuRGp0bkpn?=
 =?utf-8?B?NEczZEdtNmR1eTcwTWN2d0MvRWR6dDdaazh4ZG5tSHR3SjdxencrekhRd005?=
 =?utf-8?B?VTFQajA5TXdsbGlCVHd3UG1yaWxCQTVBaWhtcUYwd2FEVUxMVFZZN282UE03?=
 =?utf-8?B?YzRlV2xmV05hQUdBMDRISmlqZGdjWm9GSkxTNlhMcURuR003cUlyMHZUeUVF?=
 =?utf-8?B?Q2w0OXJjS3dyeDZLL04yQS9Qdnk5dTNRR3M5SEJHLys4Y2ZMNmJIU1lDQW5R?=
 =?utf-8?B?Ulc1c2UveHM4a2FjazZ6WTRtK0hDejU5U2hJeWJWdGxkM3pSc1A3VW1IMXV1?=
 =?utf-8?B?SWxyc1V4L0dUWDVFRDB0RWZyV0wrbVF3R2tuYThKUHJQaWhmUmV2TldIZ2Rx?=
 =?utf-8?B?TlBRbUhhcVM1VkkyVGUrRHBDdm1MR21jS0JITTRzeSt5ZDg3ZXhLNXJPMEZj?=
 =?utf-8?B?blZHTnJIMnZTcnhOV0JEMDRWUHUvczR4bFEwR3pnczBzRExWL1hFeEVOZ3JM?=
 =?utf-8?B?VkFwdjl3aXhVYW5iQlNjTzNKdGk5ZXhwRVNHa2F3bFNQeTdFd0p4dE5PN1Bm?=
 =?utf-8?B?U25PQ2JxdFJMUWZVYTliU0tUTUdBaksxcktSbkdlVFo2eWk4THhjbWlibmdt?=
 =?utf-8?B?RXVYbUloOTQ1SktQMkQxNDBpL3ltNXZkVURSczRMN0duRDJUY2kwV2RpT2RX?=
 =?utf-8?B?YlBML3BSci96T0phc2pPc2MrL3dPT1FHSG1xQjBFdHV2U0ZOOXpiWG9TUUVa?=
 =?utf-8?B?Q1ppeGFBNVJWVE9Id3NQRkYva2FVcGZvTkRMbnZiY3hReWEvU2NHYzVGYU1y?=
 =?utf-8?B?S1UxbkU4QUEvUytqbi9zV3I0ZDViNGZreUplcDdIeFFCbGk3ZFlXMG52eUJZ?=
 =?utf-8?B?YnIwakIrWkRhRERmTDl2ZVk5NUlUR2tGMElXRTQrWVByM1RPRVBmRm5FcFZI?=
 =?utf-8?B?bFBrZDBmMWt6TUZKNDFleUsvS3VxbHAwaDRGMk5CajUrL01kK1FyWEV1U3Nj?=
 =?utf-8?B?bHcrNVR4ZmNqbE9EUDBDbmhGK09nY0JaYTQzVnBLV3YxQk1QSGdXaTFYWm80?=
 =?utf-8?B?dWFVcXBVa1hJRGRuOXQ3ZlJyUFY2Qk4xSFFoOWhVZGdVWU01a0dxR0lGdFNX?=
 =?utf-8?B?ZWlIWHNYdjJudHhGRm9jRXJZVXhPa0JuTzJnS2h4YjYvdEdyZUNjendscnFB?=
 =?utf-8?Q?Cg9NcmjnsAs0RHAs=3D?=
X-Exchange-RoutingPolicyChecked:
	LllzWYRMtsdu4f6OechZ9urUk8yjP5yeS1awWEifkiGafoCC5Fa5+LT8V+klFZZcXbv1y0b0JjKkoyL1151h9sGQK6ryKHoKLV1bTf6oY4EVXlgjFmJKBcKkiq5jwjss827DeI0uSlIbRKMcktnz2PMXh9Qd3qZJUUPIxlbQKXsav9f/YH1yyeulYTkRLimBot+szFOemjV8Qv8F9erzVim6EhVmzwZ9XbamyI0SBa08nlb2EawM57o7tytMcmz6CCm3zBqsOJUePW4YfHV7H+09e5i7LQxF08+H4++U3dsfU4ur6POhqM2r/lxqxdM9pD/S2lIb34vpcuD8z/bncQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VtL7pD6dWIpr76fs3i+pBxP2Y6WBWwvTkIpeFmqy9Gau/GPk3WqfYjHScxgXYbIRma0kDR2niX3VtLJZ+TgiNEzHDTDzbCFS894AoIiz8IYgcQ2QladYKKJ3wAkaQlTAPcjp/uq/ZgsXsyR0fC5Il7SchbWcKDfEdO6ZugLJ3/B1xaa39WWyD6IHCWGAckTTMifqs1yz1dZw14UO4AI27RYY6CP7r3hDH9E37bUBF04pnXKDNUVjd35GkdBra33zotfHp53tVoEle7Bx3rp6DDS5W0ISmtI0Y0gynwqLwNJ2wnmJ5UR63MPtTeNkEtng2//VnyR2MOiSAN0vc6HzA70upXUT+J9FrpI90iJWpUKQcloBMFvkMdKIY/rp8Ah3zCemnShdtrQhdVexZ5sP19HyRS62aB1RPqZM7xzXzo1AuqO9U94RzAFOoyQESbfiKR0NXhauvl614RajaeCjaW4SDDhwVrk3cVRPPWxxm4SAe9IH5ZldjHr7fvqi5KI/GJbaTATQfsKN7qaifzKlbOAqkr0RzQNGolWvDdhcwHymCwhYFjRJxBNVVQQEKUPVuIxn2C6FJ8YgPv26pBmd61tj2QvMmAjYxr3bh8Qg7cA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638893fd-4bfa-4d61-9be3-08dee8a5fc57
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:34:33.4999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRu/xT9tLpf6DZ5ZfzvFKLpaLX0bi2WQdq0p7X1XQxxY2ipRXuz3XJGwzQTHt3ih1xg08BECiQGt9zn8iywMCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230104
X-Proofpoint-GUID: QFL1KClYHHHRJIjLhN_XFmcVhTorm9AX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfXwkRlt9xzBh8x
 aNQ5mMT5wjn16OLtfwMiDOtFj0gFmHvpeNUDCqML/+F7WyH/tzcOvX51YXktPyZhJA96BWIYnEP
 ylD+UzHB0FZuuYjOhSiVpOvzP+B1dJFCg3HeuttGDIZfZXzMKJ58
X-Proofpoint-ORIG-GUID: QFL1KClYHHHRJIjLhN_XFmcVhTorm9AX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX96l1Rs0SrMdr
 Foa9B6ODTz+BldO8kRTtVMfrnlcr/LSofoHC085HOi1PTHz7C9OF2VUcQYgB71eiQi+OmgUoYQs
 ALaRXjpyNMa/1aHPery5gewyLoJmw1QhnzHs52wcPqZteQaj7IU8Zz/UUW74bZZeE/QD/aUyrH5
 2CtTIgnpJhpNi0seyXQt6oPkjyAMvN0ov8JezeKhPCAgjvllDxnX3C9RkDPBpq3Ers5yA987LCF
 EKPgRY7+uEdAp9sniISKUZyU23fVDo1ddJVCNSYprtR1xehV22/vp6YKyht+ytNGMr3l8UYBYam
 X4ce456ZbKNijbpMnTOjKu9zGyF6FJLkQABSBGocxJFf9M8SWCZmhMpcT/TNiARK8AmCr3IIWJk
 sDuyYHyKifwB4gM8U8ZUduNy3Fa+MzJrodrb1geGSYWkSiDWAlSW+5YG3vQDXgqFK5aRpBlEO9a
 hs0t5XhewwbWVRItP+A==
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61ee3d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=6MaCT8l2SitkBbY658QA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22

On 23/07/2026 10:57, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] mpath_alloc_head_disk() leaves an ERR_PTR in mpath_head->disk on allocation failure, causing a kernel panic during cleanup.
> - [High] mpath_head_init() fails to initialize multiple work items (remove_work, requeue_work), leading to kernel warnings and crashes.
> - [High] The mpath_ops block_device_operations struct lacks a .submit_bio callback, causing device_add_disk() to fail unconditionally.
> - [High] mpath_head_uninit() uses a synchronous wait for userspace file descriptors to close, deadlocking kernel unplug paths.
> - [Medium] mpath_put_disk() claims to clean up pending bios but fails to schedule or flush requeue_work, leaking bios.
> --
> 
> --- Patch [2]: [PATCH v4 02/28] libmultipath: Add basic gendisk support ---
> commit 8b695b95ebd074db05fc7130622e9ffd48786c4d
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add basic gendisk support
> 
> This patch adds support to allocate and free a multipath gendisk. It
> introduces the mpath_head_template to provide custom multipath functionality.
> NVMe-like functions are added to manage multipath structures.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 9cc398d266adf..916d01a285284 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -35,6 +35,102 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_head_uninit);
> 
> [Severity: High]
> Does mpath_head_uninit() use a synchronous wait for userspace file
> descriptors to close?
> 
> It appears this function contains:
> wait_var_event(&mpath_head->refcount,
>      refcount_read(&mpath_head->refcount) == 1);
> 
> If userspace holds the block device open (for example via udev or
> monitoring tools), this regression might block the kernel thread executing
> the device removal forever in TASK_UNINTERRUPTIBLE, leading to a deadlock.
> 

Yes, then userspace needs to drop the reference

> [ ... ]
> 
>> +const struct block_device_operations mpath_ops = {
>> +	.owner          = THIS_MODULE,
>> +	.open		= mpath_bdev_open,
>> +	.release	= mpath_bdev_release,
>> +};
> 
> [Severity: High]
> Is it intentional to omit the .submit_bio callback here?

check the later patches

> 

