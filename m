Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E786D2848AC;
	Thu,  4 Sep 2025 06:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968791; cv=fail; b=KlXqS6pWBCpMVrs3nEwGLYOmqGJONfKe8kR+hoyWll0MzHUb2JATwTHEyUDEALdf69jCaU+f0j9zxcCaqZZyerU1lJxbe7lDibLD3YY2BWBdQEE7Jjo8fggxIL/sweqcCeMQ8xBqxZejpRGqclSQ5IrQmqxVRIdD6LLe+Ox7iDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968791; c=relaxed/simple;
	bh=i9aKGXGaUbdeM2vNrykf6zzo4bg4piKDTN6YzfdJXQU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ntxQNfn0rWwtwiT9V+XvEYhyfUzfzjiqVoLnXh3vfEq6O73ILlFgY0+Y2X9ZvCgYG/HQBSS6q2YsdsfHjR9opM20Jhs3Msjn56qz8Yz0v9/tLqhS3kmt8i4272YUvws+ATL2dFZolFYQ95ux3Ez7ShfKFMnUGPAnPwTFYoN0hIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JAXwAhS2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fM3mjWHT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JAXwAhS2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fM3mjWHT"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5846e2MK022298;
	Thu, 4 Sep 2025 06:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B993MZT2l702BUlsHUZZBYUMtDoxVuLNJY4xWnnXQ+I=; b=
	JAXwAhS2ev4JDkLE+7Y3sNSmaS3SsXWUCeK3hIOhwhzlGK1611BMRD9bcmZHqLE0
	EA5X0lcOtD1eiI8UBuKA6Emq6Foit0mfc4c9ICAGKUr14DAccxwX0+ZVcFQSqTDk
	BRaFCZXlo86IImhjcCiCfdglmAeuXPJdscIkRG6G6y3L5caf9mJmw8TG66Iyn/fu
	fWdM2cLNbfr/kAb8s7WOf5fFtdhe0iiC4jj4Cl4i3EHABQoI1u60GsEUbLawdJCh
	bi98fMwDA3cz7Y8DXc/980nY4FuYJFUZNLtvxqF6PyojuMm2+7gtd6YGoWCYJqd4
	dSPRjA0TJlnQiiFofqBrfw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y5pmr0k7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 06:53:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5846JCK7032517;
	Thu, 4 Sep 2025 06:53:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhj1aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 06:53:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EDPohqbkkwOk1v07qRw7++goql0qhQXf/mre8g9zNyqy5Xi0cfWyLdZivMrblvYbMtGDIfaMOq2RPrdGu63FP/r+08pOwrgkPsh4DCAYnlFUkp8RSTDdSirOtgGACr5CkIP+FMrl2bWTt4N7AGQSxuWYQ0WxBuksbnKG9LP4l3tDcvEzhocbjE/lwG0/xvBJzRXyN5T8mgqK7F8kb3gaDSVng4PREntcC+xZsvvLYLDcIw4neSJlNhxBDNB/p3T/L9p35LYNewOta+lCAnliC1rKHBxtQn6SF1pX+ITgaty5MVkY6hRWNjVyy8ZJA6wrFuHnKZM50ER4h5rZOM9R9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B993MZT2l702BUlsHUZZBYUMtDoxVuLNJY4xWnnXQ+I=;
 b=k4wGudwdpYVHGjrt5/yPvCpvyI4j+ZYted3LGIpQAVWLE7TLohzegZZcfOmf0eEAk0FFbfCsT6KoU7tyr1XGOzGrO2vGSx33Z8wPXueXxaQtI04M+2BbIevm5VvzdVyqYQ9LRwXeA989maR0RGYC4CFRaY11P/S48jZlj9/MgTkpxr7lxKPawmiAzaMgfiET0hERXMmRkqACyIFcC8NJW3MGPI4Sjaw1WEIKr8cMiSB0GxVJ2kGbG++H6LRK5zKCRjAujPj8m9g3/bkjSzuOn2ox08u+N3OVGgc1JKhweoxFSeqd8+LSF25vszzQ2wrpXlLzF+K4lPY7B+itlarNHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B993MZT2l702BUlsHUZZBYUMtDoxVuLNJY4xWnnXQ+I=;
 b=fM3mjWHT6rEm+QnOCVxp7CsHczTYb1QYAb34jtN4i7pG1j/ec5yMg3bMTXrbI4O3hznS8QqGBWQeVUTgPodxyoXuu/H+3BSosC5JxDGxXirlh9taic87GWUq3OCpMQABe0a5jWMCTzX1VR0JvgZKK1GeqJqxq3REfjWFMBwSrI0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS0PR10MB8199.namprd10.prod.outlook.com (2603:10b6:8:1fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 06:53:01 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 06:53:00 +0000
Message-ID: <7b60681e-a964-494a-a6fa-aba00086b7f7@oracle.com>
Date: Thu, 4 Sep 2025 07:52:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: pm80xx: Avoid -Wflex-array-member-not-at-end
 warning
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <aLiMoNzLs1_bu4eJ@kspp>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aLiMoNzLs1_bu4eJ@kspp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0154.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS0PR10MB8199:EE_
X-MS-Office365-Filtering-Correlation-Id: db2a38e3-52c3-4318-a88d-08ddeb7fb02d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWdKRThVMnFscTREOXU3MlFLclJwZGVKOFVuNXdpUmxYN0tDdUo1T2UrdTd2?=
 =?utf-8?B?Y2daVDhtVER0dUlqQ1UxVGl5K2hKV29Xck9qU1FLZ1lMQlNGYi9UT3owd3g1?=
 =?utf-8?B?dGlrZVN1bzZ2OTRhNnp2eFQ2U2N6VEgxcUpxeldReDJMUDVINFErZW9MTFlz?=
 =?utf-8?B?N1RYczdBV1dKc3dvQzlOczZmcUlxRXJiZGNxVmd2NGlSQWdzbzVqc2Z1Vjgx?=
 =?utf-8?B?a2VTRlQ1QmRJRW9Nelo2U3Z0Wi90Y1dyWGhyVXppazVyNDFOVUtwb01LVE1I?=
 =?utf-8?B?bWNEellBY0JxdjRNYUdMOGZ6eFFZc2pzbmdydnc5bjhraGFtZGEwa2hBUm9R?=
 =?utf-8?B?MFVLWTl6WCtRQnQraDlkazB5OGVCMUtpd0J4alhFWDJSaDI5VGx3ZmZ5bDdL?=
 =?utf-8?B?VW5oMDhhc0JzMUljRW9jU3N5K2IxSmtlS1ppZS91OHZGc2dITmFCemJ1WXI2?=
 =?utf-8?B?UlEvb1A2ZWZtK0MxcTVIalluM3R2RUFuUkpiUk5VdU81Q0t6WWFKVUlWM3d2?=
 =?utf-8?B?aGJaNXBIL0dvbnFzM3o2c3RRMHZtQmZhYjRmRktGTFIwOVlNa3Y0UUNJVXJh?=
 =?utf-8?B?d1NnaHBvc0pQL3lmUkFsNlRNSlZWMDFWT2xYaWhaZXdzTVVSL0VoViszc0Fj?=
 =?utf-8?B?VjVhTEE3TVVPNmxGczJDMkE2SFc5dW1kb1d5WEk4bklNZlEyMzNobkR2KzMr?=
 =?utf-8?B?Y2x6U2paUzhaRnBwY2VIdkRUaXJOTzY3ZWxreGZybHFkUWFiQmlEWVBmbFZW?=
 =?utf-8?B?TkNZa0lVc2twR1V6TGNFMmVRUmFPN0t3VE4vanJ1bmdxNmtsME5zZS9vSHYx?=
 =?utf-8?B?Nmo2M0xWbXFMemVjSlpoTnd0TkI0OStzckk2TEpNRmI5aC95Z2QwbU1SNGhx?=
 =?utf-8?B?UGZiVmNvOTFyb1B6RnZGZlRXM3RWWVJPVERFUXFCWDNnVWFvWWZrNDlHU0s4?=
 =?utf-8?B?cThJQllxWlZsZitDS1ZNSk8wcE9qSERMWkhKNUx4VjRHSURLVjdyU2dwaUZi?=
 =?utf-8?B?bDZQUE0xRk1oWGlHZTlTNUxGamdFZk5zRjdoOEdVR1dmVkhOYTk0djY3SlJ6?=
 =?utf-8?B?YkF3QTZSNThsTjVXWTlKVTVWTFBMbFpKRXZuSURjblVUWjVGTnBHaUZzRlBK?=
 =?utf-8?B?cU9ZSGtzYXNFdFF0ZDNhc0NFRmt3d0ZhbFhZZjdUZ21ZcDFLYXM0SWFiTXNk?=
 =?utf-8?B?QUU1Wkh2c0c4ZW5XTSsrMFNYdU11TmtqQUZ1Z0x5ckhHR3E4ODJUZzgxVWs0?=
 =?utf-8?B?NXJDZG5XdXR1TGdVcnhnd2swUUVNbEVBL3A0OU85QmxVOThLMUtpdjNyM3dL?=
 =?utf-8?B?UkY3YXZXOHFWRUJVcUVyd2NBdFBKb243ZTRMZGZDZHFkeURpQ3JFSXhsT2xS?=
 =?utf-8?B?WVJHeTBIVGg3blpxcStSNDRIYStXMm1FZThMN1ZZdGJpbUFTZE9YMTZ2SWc4?=
 =?utf-8?B?Ykd1cXFJSjRyM29JQXpiVEIrN0lDNytJRElBamxQaTZiVHpDNE1Za0t1TDVE?=
 =?utf-8?B?V0ozMEhsMHVKZ1poNnhmT2hBc29uV0lLWHdWSXczMms0a2xUS2VuMUpVZU9B?=
 =?utf-8?B?ME42TGYzV2NFQzNvdWw5MFY2dTRoZTVXRjJzR1Q0WlBRN1JrZ0s4WjRGRmty?=
 =?utf-8?B?UllPWFY0RS9ka1NxQ0hzQWlINjNGMTRvdkFvbGxGVEl2RXVHdjIyZldDY2pw?=
 =?utf-8?B?L1BCcjA4YlVuQS9CYTVoazFDRlhZZUZpV3BIRmw0NlJUczNmWmR1WFcvSjA4?=
 =?utf-8?B?SlRLa21WZENQNm5BVVZZWjNnTjQ4VUlEa0VUU3AwMnViWnZwczBiK09UMG1j?=
 =?utf-8?B?UURlZHVneFROK2dxY3RYdnBFUE1YYWZJUzI5S2xRbXdoN0hIcWxXSk9RYXpF?=
 =?utf-8?B?UnZjckpIT2crL2JUMHpSbHhuVVVNQktCVjlyYXYyVC9Ja0NTNTF4N0huZExx?=
 =?utf-8?Q?KsFIDRQBuPM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clZ0MitpWlFwZFpkdWhVSVB4SFZvUHBtZVhqQVkwZThUL2xCcW1KOUord2Ur?=
 =?utf-8?B?bHhadE1TMmg5Tk1MZFFONnRTdlNpbmZSeFhoTjg4azJhcWJ3WWcwTmthYm9l?=
 =?utf-8?B?QURxTTdKMGRNZ2NveklrWFppTUt3bEdTTVlmaWR5SlBPMEJ2T2tUdVNhVHph?=
 =?utf-8?B?NnJBL3YyYk9JWmdGcUJsV2g5d2dBRS8zNFl1c244SkZ2ZzNDT2EvdHM3YU9H?=
 =?utf-8?B?RXhzYTR2MTh4Q2l5bWxzV3hYOEJNLzRVUEFDVEFlUEFwMW82RGk0dzlna3ZI?=
 =?utf-8?B?TEh6V2JrK3JjRkgzTUxQRDN4c2t6SXZ3ZElnd1ZjT3AxdU1EckFqRi9MaGpN?=
 =?utf-8?B?VFJ4R0pCT00wYkRXY3F1TWt3b01WMW9MQ0Vnc3BKQnpwaWEvVGxGVWRVNDVQ?=
 =?utf-8?B?ODk4VXI3aWFPS1pxNWpEU1Bsa0ZsdGtZcG5RRE00dmNHNmM2N0d2MVZrNGxp?=
 =?utf-8?B?VlFOcGFNNE5IK3lIMGdmNGpYWkd3SWVkRzl6QVFDaG9qdEU2VUczeDNubG1K?=
 =?utf-8?B?RjVnS1BsK2VYQ1kyNmJUYUNqZGNYNUhkTDF6dzI1ekxkc25SWHVWaU5rQWtI?=
 =?utf-8?B?NFpaVldjMEtQQTh0VjNNNkdEQnR3ck5tQXBUbkIyK0x4Z1cvN2RoQ2lkOHJu?=
 =?utf-8?B?MEdoOS9TcnVrSGNhYldDV2ZMTlV0am1NRWdZMURIekRHYlZCeGREVWtvQnE5?=
 =?utf-8?B?amRuQ0VRdFZRQW5yVHo3bUxISVQ5V3U3L1NlNWxoN1FsSjIwNWZRanB6UFdk?=
 =?utf-8?B?U3F0eGNWQVBkeHV0UDZLWTZLZXNvYU1YQmU1M21uM2dydVd1aTQybXduSUZB?=
 =?utf-8?B?NUhobHpiQWZNbVFZR0MxWlZSWFpzRFV3dVRpVDVYNEswM1pHTGs5K2k2Zlp6?=
 =?utf-8?B?V1VGeGVoVmZXVjFkMXh1VHhBTVVibUMyazVjMlB1Uk1kTjFWaG8xUlFpSWxt?=
 =?utf-8?B?b3lnbWZHYjNGaDQrM01uV0VyMmNPZmo1aytodXNBNWYwWDFVaFl3b2djK0VD?=
 =?utf-8?B?ZGt3U3NjTndmR2NDeHdtNTdqWDhYSVVrYjNIUFpTVm1tbjg5T1hWbFBielN5?=
 =?utf-8?B?emtuU3dxM055REp2YUUrZ1JGU0VQVjRvKzNqOVEycTFDb2M1cHNPeFdxQXlV?=
 =?utf-8?B?LytYNVh1d2lWZXVpRjFNZnl2WUFQMkhvWGYyU2RqWGE3dnR6d29sY2l4cG5r?=
 =?utf-8?B?Mm4zNzd5N01FZGZSV2dKdTFoZVQ1ZkJtTmQ3UGpEa1AzQUFUTWRyUVMwalFN?=
 =?utf-8?B?cnMyY3JiTWdXdFlUOWdnMUI2azY3ckc3Y0hpa25wU0V4RTFYSmZCeUl2aS9Q?=
 =?utf-8?B?TmhjV3dVNHQzczJxVWZwbjloOUxEVEdYSXJYZExEdGRJakdoUE1uTHltc3hK?=
 =?utf-8?B?YmIvOWFMQmpmYjl3d1lxdHNmRWt5S2l0Zm12S2kxTS9aaFNKLzlxL3RBdXJR?=
 =?utf-8?B?WmlxVThhSXdlZU1aK3M5RGtPZUQxWE5mVXhGazk1UUovVXptbEhIRGh6OFgx?=
 =?utf-8?B?eHpwOG9KaHRWcmNzK2pIVkZmM2tmdTJZOWY5SzFZOXdab0Ryc1pPZkN2Tk4w?=
 =?utf-8?B?ZW54THZMK1FuOTdDL21yLy85NDVLajBVN21hdXdPUmlTRXByb09oN0p0RHBE?=
 =?utf-8?B?bDRUdmpIanh4b2VaT0hyK2s2NGttWi9WU0ZkTmM1aFNFa2NhemdCUy9KS015?=
 =?utf-8?B?TGJHQTBUYk5tbnlKSEtNcU01ZG9aUFp4VU0yU3E1cWlmemJiQ0ZoM0ljT3Bx?=
 =?utf-8?B?eXYrWHNMemNoMThLbGNCRVhNbUR0eHZiY0ViMDdmL2hYd3BMa1UzalVQOUMv?=
 =?utf-8?B?cUh1VnhSOTdjV2pWUXhremJUa1dOOEpzN2JXcUhGOGtDYzJ0Z1AxancxbTZs?=
 =?utf-8?B?d1hSTWFpUlYwYVpkZlhiSW5FQmxWYVp4cTRsWEY1cnBITC9OSmxrZGJEK1Yx?=
 =?utf-8?B?Nng5TWpIU1FpRlluN0pwakRXYkJ3R3VWQ0RzdVRrMjBZSTdqcHpVVmVoUnFz?=
 =?utf-8?B?Ty9EU0hDRXp4VHZubzI0NHpLckwyQ00vSmNxR1NCRXJ4QlgySUV0dVF4S2di?=
 =?utf-8?B?MWJnVUZYNlh6WWZ1OG1lMUE4R0VRSXlORGNLNEErMjJmVE12QmJHZDJMaWdJ?=
 =?utf-8?B?aUNKQk1ES1dpL2hUVmFEOGs5RURiR0RSem1HejFsSmxjWWVYOTR1YUZYWE8y?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MRuNrgLI+mb8ml5R68gv65iVm4oadV4BpSdSYxNmkkAqZlbJcQqK6JRgK5+Cs4Bl89H9RshwTNWkyVFoLcNvkLlMl0/50MlW56VT75GI2rR0vVSVmKaAOfDeFOANw8e7fXa2CsFZaX73OWz6vTYGC7ud6wNUJe9YNetGactVSoQ3Hrm9/Gi0zo1Gw2tzE+YxVgdckuM2BVoQMm+ya+Zkcqg1YqyD3sbP6/WRZUeq1cJt+ALrNUZ/jTa2LI1ArjCXl+aTZFzW/n0e5Mlbj8pWHDXxOAM6bu+sdW1dIR68zV1joV94ufHnPcRu9yw1dH+6scEJmiaYmX4VTafKyk9rZ224rEFckPurdj4i+5vUkMhz4RwLyGZ1unxXhSLZ/y4yKmahk9f5B3+VZy9UkAkUSHidlk5tBlpjqHCIfEQIZPiE13BOx8bDJ6qljUC0lhDkTNJube/eKNUE1Au8tosHtACae/WC11KWpdEm7qu2TAdepxSBmW6nXe/+x83Dg5tXkCxFr16H/x3xdeoheieHB3usN+GDuZ6RMD7bzrTC+6BJwj8IMYXz8D2S61iv9fm9dv3ewUQN4hhi2uE3+E4QE7VDF/wsHVwRlFKZWAo4HB0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db2a38e3-52c3-4318-a88d-08ddeb7fb02d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 06:53:00.8226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlNGkoDRNk+IC4JGk9lN5SCGrLtvnlXz8TKzK1KcU5TSQXfA29mAVf84sjjTiHaLz71K5g6ogF3q3FdSfZPGkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=978 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA2NiBTYWx0ZWRfX+UKBMd/37lQa
 BZfOwga9R0Fp4UKh7jHoc1brrzyhajzVz2hMqINbW4z24Tj6i9rqIJ/VC5a2/jXdEVDk//vs7cC
 w8SI3mDMmLn+nltiwLT5XGEItdtXE26iwg0qluYDzan0f49Wt3faCrKGNShgiAyHBy3cTrUECzn
 GOMkpZ1R4WmjxtFldYnhTKvt4givdtbRdIFPKmf0r7Rc/F93uksQb/FnKXnWeyxK7T6FjMEnHu+
 r++W/pKYc4v3tU0G/LEU1BRW0Y9apePHQ3pmh5Ua7DclJNcxXQFNliOcNYpE/cZPpT5NtJH/ziQ
 22c7O3CvFN6Fj2LNTkRBtDOupMHdR4WZFQgZMM1ktmYkgRYTGBfUR1+s05dF6LvL1Y0KJidP+57
 gmZv2ZUVkybbH9TiriyFHHKux8ld5Q==
X-Authority-Analysis: v=2.4 cv=ZdwdNtVA c=1 sm=1 tr=0 ts=68b93751 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=4e8un5K37ZRR6lRcyOEA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: dUcoG30lADuTY2frgBgVDok3iKuvouVl
X-Proofpoint-GUID: dUcoG30lADuTY2frgBgVDok3iKuvouVl

On 03/09/2025 19:44, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Move the conflicting declarations to the end of the corresponding
> structures. Notice that `struct ssp_response_iu` is a flexible
> structure, this is a structure that contains a flexible-array member.
> 
> With these changes fix the following warnings:
> 
> drivers/scsi/pm8001/pm8001_hwi.h:342:33: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> drivers/scsi/pm8001/pm80xx_hwi.h:561:32: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/scsi/pm8001/pm8001_hwi.h | 4 +++-
>   drivers/scsi/pm8001/pm80xx_hwi.h | 4 +++-
>   2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> index fc2127dcb58d..7dc7870a8f86 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -339,8 +339,10 @@ struct ssp_completion_resp {
>   	__le32	status;
>   	__le32	param;
>   	__le32	ssptag_rescv_rescpad;
> -	struct ssp_response_iu  ssp_resp_iu;
>   	__le32	residual_count;
> +
> +	/* Must be last --ends in a flexible-array member. */
> +	struct ssp_response_iu  ssp_resp_iu;

this is a HW structure, right? I did not think that it is ok to simply 
re-order them...

>   } __attribute__((packed, aligned(4)));
>   
>   
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index eb8fd37b2066..21afc28d9875 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -558,8 +558,10 @@ struct ssp_completion_resp {
>   	__le32	status;
>   	__le32	param;
>   	__le32	ssptag_rescv_rescpad;
> -	struct ssp_response_iu ssp_resp_iu;
>   	__le32	residual_count;
> +
> +	/* Must be last --ends in a flexible-array member. */
> +	struct ssp_response_iu ssp_resp_iu;
>   } __attribute__((packed, aligned(4)));
>   
>   #define SSP_RESCV_BIT	0x00010000

