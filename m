Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B491B6541;
	Thu, 12 Sep 2024 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153881; cv=fail; b=PNHgiOtR3Mf+nrFVC99VPK+6Ml4+ZaTFlKuLuZIAFdUyxJRFHiSuG4exu0Iv8JRzSD3fneWsU8aVsIEyggGD3Fbc3BHkAE0SIyuEsC5QbUNIVavegadv1S2RL1jS3of53UqpNVvIk50GBmD/uRgVRgOp7Hi0B6eAR2pMxX7DmqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153881; c=relaxed/simple;
	bh=quYFo21VqzCaOY0YnqHsvV+XN4JIwvetg+Jr4krlZtI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qMmshHB6gPZ1HD2sVH3N8/Qumn4rD6TbYaq7DuglfiAfzeT7O/pflove5CeyoHKRbLkBuDJP8pfgyJm+r1F+rV43cPtE2W+ytsnj9CsjrIbLxt4DiV3UfukPWQ66kGVT9iJD0hsMDNL3lb3HSYQcMQdA9Gb6BjZiVowBzWrJ7Bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eagn3euZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EZIk9Hn/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eagn3euZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EZIk9Hn/"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtYVG001510;
	Thu, 12 Sep 2024 15:05:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=OqavyU1GA599oW6WjwlsS/EBM/ch2xyKtrr4xpc0LjI=; b=
	eagn3euZfpQi5crDXyAdk6EHHRotID3AR/AOCe9hnLHgjwPviUFNesrsCL/JWMtU
	Dk5KCOaJ9c9R9xXqgZLtBUnpqXqO/iiw1Z0u+PpIpjqsxLQEV62XCKQifD/wpnV4
	6CnTLjgzvT7CcpWTz5TfQYEOeLR/ZnKVDAHB1I6goHmovkYwYzxmUiC7R/SlWcD4
	cgftvS8vg5RpryVtoTU6Q1QVHJekZe8/GuxFJTAms3DTcWfMSj1wCN+2JT3mk3Bx
	AnVv39kPgkMOiV6p7DmxtE2hdCYj2/YUB9vf/OJ2zlE/O2EfSanlWbdq1fip7/Cz
	VRmwbaZ2cxovF8GEIcJ93w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d2ydk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:05:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CEuSG7019848;
	Thu, 12 Sep 2024 15:05:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9hy2hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:05:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BMCA9hILLFl9gCCgAB62JTGYkjKN7qI2PTowONjqdrib/PfjXnTkhW4G0se3zJ5vXECrR9bnXPqrgK98VZzJLBdmuFAP0pmb6k/ttMIXs0vbEbO4xMjr4DLkM6PrGTI8MFPSSII10X3rVAif/AKmYyLvXd+WILE8upfHd+y/zESlp8sgo4YvrTzNT1hHVN24XGkK+XrCM2ziyhyIMvDH3EVRZ4r2VLIm2S37jnuinYfdo+x7gRoFX3g9cizXSNMf2UxmMJL85YQny/VS8kBR7oqV01X/Yf6gGV7DoJ42XD53obKnm6EA3mso9XkAMSeCoYNggf8JzqEK3rt9yxyPnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqavyU1GA599oW6WjwlsS/EBM/ch2xyKtrr4xpc0LjI=;
 b=FDNFQ5GnZX2ADHdAcBjyK2yJRsPeMY1GOuN+I9Nwo4rnu6olS3faSpYmFYJ0ERbYkIXrMKFpBeImTeVhKjMTC2/3Hhbhb9EeAmsBQNlBfKallPRW46n+TTlLXNr2gT5zWWDvoYqXXcdKhea/louo5eqzHPv/xfWRHqTIuyHwQZMAzC4PG76ogvP645YaZqPFqI+S1tIPbrH5XNnKyH5vLbhYP263wqNj8u1Rt1ncX6CVF//dQSeKIBpqCW0j3vvX8DXam0sS74Ym1zNvxDTXZ5mchd6OXnGu3Ao2N6LPvGzXkm10eSzEBgPTj2jbUsUhDHR7PCSNvaoBM2ucf2praw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqavyU1GA599oW6WjwlsS/EBM/ch2xyKtrr4xpc0LjI=;
 b=EZIk9Hn/0UiXzlmh2ZrYrWgZOOY9E8jsD4EmxR3H6seqHCyd0pgAZ6SyxixjOG6pV8PVNXi0E9NeBKrbOrdQMM13KPxPa+CxkJ9tmzKZ5tgzOE9RrBRyzPinQ7iQiAlQM95aYp6CbmzHzHeI/pH5OJGPUpP898U+Pc1DI8CWukA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7300.namprd10.prod.outlook.com (2603:10b6:8:e3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.17; Thu, 12 Sep 2024 15:05:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.008; Thu, 12 Sep 2024
 15:05:51 +0000
Message-ID: <17d16e35-9911-44c9-99cc-a2ff82f16482@oracle.com>
Date: Thu, 12 Sep 2024 16:05:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/4] block: Support atomic writes limits for stacked
 devices
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-4-john.g.garry@oracle.com>
 <20240912131656.GC29641@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240912131656.GC29641@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0340.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7300:EE_
X-MS-Office365-Filtering-Correlation-Id: 929854a2-405d-4366-47e6-08dcd33c641d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0pYK2VKbWt3VzMxNWVsMGNtUnFxNXhyb20wTDFBbk1jdEt6N0NBck1wMTBw?=
 =?utf-8?B?V3NIRVZsdHBocVc2Y25ySlVSRFkyc3RKdGZVMCtIMWU3ZmFnYXgrSUxwdURK?=
 =?utf-8?B?Mzg5cFFneHJjaDVUTTRzRFVFQmFGZUd3OTNYYUYrTzJnR09QMEJhUlZYaXFj?=
 =?utf-8?B?djZvZGgycVdOeDhSN0t6ZVJMV0lMaUJJRU1NS0w2VVlEWi9jM0lJWGZZRmZw?=
 =?utf-8?B?UVB2cERnMUdYZ2NvSnJ5VVZSYmpKTE1LZ29zRE8vZ1lTeDJzT1VVR0VpbGpR?=
 =?utf-8?B?aFdjWWRYbGRpR1ZhdGdYbStlSmtWamZLbnBTWFJwanFxc1ZUaTgrM1FrSWMr?=
 =?utf-8?B?eU1mc1VERVI4MjJFOU9LQjZ5UXhQRDdZZXI5WlFkRC90SVFNSzA2VWcrbi8v?=
 =?utf-8?B?MGVlVDBtbFNjTGRBeUlycDc4d1Q0RTh6YmlkUG94Mmk0cnJKclNTajJ6eDdx?=
 =?utf-8?B?bVc2a1Z3ZHhQL2Ztc0RScFJMbktibUxWWEtsTy9FdS84L2phY2pZRC9HWGF0?=
 =?utf-8?B?K1RqS3JSVldxUkhGODdPUkdzYzhEaUJLVHA1YncwRjZiWk5UUFFGdVErZHlX?=
 =?utf-8?B?MEJpc0RXWDk4cm0wSlZVRFlXTDVXUlZxNStyZ29PMjV3TWhaK1FuSmtleGpp?=
 =?utf-8?B?eWZhODdkeThMVzZsbXR4VldzQll3R1VMV3BWKzRET2EvUm5FcXFCYUJveGw2?=
 =?utf-8?B?bVpsQzBDMFBIaENMblo2SVhCUEZvS0lwaEdoTlZQeHFiazBNUFBzT3lwNjlO?=
 =?utf-8?B?aDVWK3kxeGpRU3R2VTVCUHF1NTYwS1ZMTndlRHRCU2V1V0F4UUg0dG5MUUpO?=
 =?utf-8?B?YU1uVGFvQW1GbWdIRm0wVUxpVDBZNzM4cTlic1RaT0p3MzFDeHZadEdSeXRF?=
 =?utf-8?B?OE9nV3ZOTFhzTnQybi90c3JFMlVqdWVydUVRN2lFejExR1BvZXJPenI1NHRY?=
 =?utf-8?B?bFRHb2ZkaGs4NnBrVDM3a0pPNFoyNHpLUFFseGh1Y0dZczVGQjUvUG1OaWJw?=
 =?utf-8?B?L0xSM2V1WjI3ZGs3S2p4Wm1oU3oyWEM1VERkZ01zQ2xWRENYOEpDbmJQMisx?=
 =?utf-8?B?OU1sK3VtVVF3UzJNajlFekdUR21lYnhJVStENEpWakJKbzlSNWxDZWJyY0hs?=
 =?utf-8?B?TEh2MUROb3pSRHVUMEhwWDRid2g0c1J4SnFoK0t5d3lvT1g3WHBQR2w5TFpq?=
 =?utf-8?B?blgvWHFldndBdjVuSDhzaVRDZkl1N3RCNXNqQTM3UmR0d2EzS2ROYWdSd0Rh?=
 =?utf-8?B?RUxyYXUrMk51OUNSaXFqMnU5QVp2VVlkd3pBMlBxeFpiTHkxNXcvVTR4c3J6?=
 =?utf-8?B?dWpTRXY0dTRReFl1TCtzTng4bVgzck1LTDdaclB5QkNST3o5Smc0MVlrcXdR?=
 =?utf-8?B?K1U4YUtiYzdWOGJTQmY5aSsxMjI0OGpVYUtoZlR3QXU5TFpPbHVuM2dFTzRi?=
 =?utf-8?B?QlNJMUhZcEhUZVVhWWdyMmg0bVM1VXphejVLTU9aS3NLbjMzZVpjcVhGMFFX?=
 =?utf-8?B?NUhoR25rSDBnL0hoTVkxdklxWVVFZkFqb2tZMTNDNEU5bnlxelQrME4yRXpr?=
 =?utf-8?B?RXRIcm9ua0ZKRXN5dUQ2NVVIZUtEUjhCbEluQVV6Vms4NkhxNEpNdms3dzZh?=
 =?utf-8?B?c1o2MDUwemQyeEJlbm56SERRaWs1bmxrYjlSeVNjNWg0a3Bkb2U4RVBKU2Jw?=
 =?utf-8?B?MmRtZnZrNHNzWFBJSG5tem5kb2hjWWxoTjQ5amp0eU9uU3didTZ2QjlBbHBU?=
 =?utf-8?B?Ym1vZWZsOEplK2RhakJ6S2J0YUxxMHpuRDZROC9WeWVKRjh4dUY1RVYxbWVx?=
 =?utf-8?B?czVBNkEyYWdmSWZJQmRNdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmFrQmZ0M04xak9tNitTRTBOTmExckVUT2dIZnRZMTBqV2RIdFRiY2NuZWZP?=
 =?utf-8?B?a1JZSkU4VkpueURLVmRscUFaSnR0czMvSlhNS0c5WTVOeEU2SlNhYXdLTmxx?=
 =?utf-8?B?ekpaYXpTVnZ3SnVvQzRUVzM4eGVuQnhhM0hIcmROU2hRMVdibmZYWEpnRnRK?=
 =?utf-8?B?ajRWNXhILy9TSjBlWExDNXhwMEZjOEkwZjk0NkRtQUFUb3A3MXVlYUwxRm9a?=
 =?utf-8?B?OUR3eDZsVjlyY2xHUmU5a1Q2QkVSMUtBNjNqd3VBYWlaSHNqVUR0cnVJdzJU?=
 =?utf-8?B?dTMzZ1RwT2RMTzc3d0lVWVRKUUdGdTMyVG1rSFhLZWtMSmNaZ09wR1ZxTmZ2?=
 =?utf-8?B?MTRVcDl0VnNNZC9IUlVMTWdZU3d0MHRCR1hYT0ZENXZnQlVwN3YzZWlYNG5s?=
 =?utf-8?B?VnZncG5FcGNyRjlKbjBJcDVVeTV3cTNaMW0raW1hWmUrTDZ3bm5jSWdObVp3?=
 =?utf-8?B?Zk9kOWNiR2J5cTlFOWVTT3dJbEVJbDd2R3czTXJ5Yy9Pd29xa3NsMWFORTh0?=
 =?utf-8?B?L2JWN2w0ZDBjNjJDWmR0Z2tnUHp2ZzlxejdrazlxWk5RZ1pSSEdsMy9xcENE?=
 =?utf-8?B?bDRicnVjeVJST1NPdlJmRmRBdHY3TzZqNWZJbzhaczFhbnd6MzRtQWdzL3hT?=
 =?utf-8?B?VWVYL25adEE1QmVPeGRxTllOSThVUE9yYkpTcmNDclFVaE5JcUEvQk5WUGVw?=
 =?utf-8?B?eG1pZzlGMjlETVZpWWEwMlMrd01uRk5vSUo2Z283cmZJdE9GOGppQ0NBd1I0?=
 =?utf-8?B?WWZVN0VUTU50THdPVHZDOStJTU42ODlQZWd2WUdMZ2o3U0MvbWlsSDA3SzJP?=
 =?utf-8?B?SWpCZm5LOWVqNWFRY240anFXRnNVRGZYMCtKNWNFcy83MFhBSDZiM05ZK1FI?=
 =?utf-8?B?d1l1MUJGcjJhUGIzeWtwT3ZiODVHMGRhdC9sSDY0UEhEd3NrbU5ZbHZVVE5P?=
 =?utf-8?B?NzgrcXVXQWlFVFAyRklyTXZpN0tlS1BWOTBERHY5RE5FQlBkakJvbXp4TDRN?=
 =?utf-8?B?K3hMOGJBWFRXK2R0eHVyNmlmV1h2cEI1NTQzdjlJSHg3NWV6TFQvQUxsUmZ4?=
 =?utf-8?B?dEJ4dUV1Yy82UlpydVRzVmFzK0tFK2YxcjBFcVZRYS91MHJOUzlBUTNqcy8w?=
 =?utf-8?B?RGs0SlJ5ZUpVYzBtcjQ1NXNoRGRWam5lVDdGYXRMUmhiSVVxM29WUk52SmVQ?=
 =?utf-8?B?eDJqV1gxWDdCenhpcE9GNFJDam5RbC84QjQxT2owVmVCV2JHQjF6dVRDZzQ4?=
 =?utf-8?B?ajhZTC9SSmhsZGc5UFBtRlVoWkxranlHSnhldStRdGlvOTU1bVdSYTJYdi9O?=
 =?utf-8?B?UnU5YVpsTnFtM0dSMVRZUHVKK3h3UXJkNmE0MFdnMlRLQmMxZXI0aVRoaWFX?=
 =?utf-8?B?VnYzUmtLd0xlZ2lRR0dudjZIZlk0MFUveFYyZ2Z3UEx6K0owMmttRWdYSjh5?=
 =?utf-8?B?VGZvTU5wQ2RSVHpYbWhFUFNZbGkyQm0zSlhiZXorL251ZGJlZE1IamErcnl2?=
 =?utf-8?B?YVkzNmpFaFFEVFhpRjRqWWRQay9HdUU3YWdlV1FRVUpjeUptU3h5OUQyOEJL?=
 =?utf-8?B?K0tZQXVxdkdaZklEQ2dCM1ZlVEpNMVVlSU1pOXNsdEQzSXFJVDlYaEZ2TkFu?=
 =?utf-8?B?ZHZaZkJUaSttdlFCdUZVTUs3UjdGUm9GQUp6YnpmV3BwRHNrL3Y0L3Z2VG13?=
 =?utf-8?B?NHJ5MEp5YzBUN0c0RDRvYzErNGFMM0lQRkorR2sySHBkK0JVMlBqbnFZWTlF?=
 =?utf-8?B?ZHJwUVV2OERGc3dueGJjUEsvN1IrUCtlYnVNRGxWUFFCVndDOWlEcmRIMFh6?=
 =?utf-8?B?NFhrNHIvdTVDejhVZDdCcmhXb1JyU09uaGp6ZUxBdlU1Rm1rd2VpanJybnVJ?=
 =?utf-8?B?UkhYTWd3TFpxejl1QmwzdGFqcjk0U2pUSTg4YlcreWYrdmJ2dG54NnJwcDU4?=
 =?utf-8?B?Y3dMcU9UeDd0RE5ZQjBFdllUc2dRUDZLQkI4QjdDU09aVkV6dmNzTWdqSWI0?=
 =?utf-8?B?bDAyK09EMkZTdnFZQjZjdDE5Qmc0VGVGK3Q2WmlXdVlsdlROa2poQllud25p?=
 =?utf-8?B?dXdHWlNZTWVkVWwvcWxZWkRTVzdTc0JpbGFuaFdUMWIzOXU0Qm9pVnNoTXlQ?=
 =?utf-8?Q?5Q641R+uGCOR4ZZyYPqG2/Ai4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uq1PFqba9vpsF8iItFAvXLiV82D4RZOf9/0nkb4T9eBGwKbRJVUxFj/F84xPHvztDRjOC6eAkEh+64IMcfX3a19iBCnRAOVo92uknCVw0HVcv9V6Lv+OFWHXYPczIFobp3rahQsuzLMoxkpQ70VgXHD90MOpyPmmc7frwB41a2ypfcSwZFWWeA56Y4/VX6Tj0PJkcedkbWw4J3IVQMtpdWwzglbdp3Vg6jt3heUZZdTSvm9M+5dRUd4E5GoWVO3uuZQv6Lo7HP4EeroZjo+RoQy7aMhQcRhy+5+Ma83ItXUGRY3Ebtoy0my3lxU2r4lvnrPpYS05dBcljEjtIcS7uELS8MQUGg/9r4NZokEjLUmFRzr34zALsGLXUHUgupN4tYH03ahS/riC2r/H5WRcspldRDUKZSTks3NgurwSRCYdtRePWAPMcnYjL0WzwqvR7pwpItGKcaJiosIGdZ2rjOtibeFnhY3BLnyxQT35JkBuysuiOr2G0zXfDJJfJEadpnIzGptN2lqPWwww9yxTxbMUmwCESeSY91TVqZe16sTPlNAfH2tA+2H8uwvQjpf52VlFF/2jfJTn1bF24MOdMnQDgV3i8CVnnE/NNhBzrmE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929854a2-405d-4366-47e6-08dcd33c641d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 15:05:51.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9+aV1kdcA4RUM5PizZCyXH4WIxpzjubg/aOLakFx5UT9MyEt406W1pZpyuf11jQy3kZrRpKtwZa4rT4qaJAFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_04,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120110
X-Proofpoint-ORIG-GUID: k-MuBnRPL9QBsdxZEO05-yCzX6q_7Z16
X-Proofpoint-GUID: k-MuBnRPL9QBsdxZEO05-yCzX6q_7Z16

On 12/09/2024 14:16, Christoph Hellwig wrote:
> On Tue, Sep 03, 2024 at 03:07:47PM +0000, John Garry wrote:
>> +	} else if (t->features & BLK_FEAT_ATOMIC_WRITES) {
>> +		t->atomic_write_hw_max = min_not_zero(t->atomic_write_hw_max,
>> +						b->atomic_write_hw_max);
>> +		t->atomic_write_boundary_sectors =
>> +					min_not_zero(t->atomic_write_boundary_sectors,
>> +						b->atomic_write_boundary_sectors);
>> +		t->atomic_write_hw_unit_min = max(t->atomic_write_hw_unit_min,
>> +						b->atomic_write_hw_unit_min);
>> +		t->atomic_write_hw_unit_max =
>> +					min_not_zero(t->atomic_write_hw_unit_max,
>> +						b->atomic_write_hw_unit_max);
> 
> Maybe split this into a helper to make the code more readable?

Yeah, I will do.

I was reworking this anyway.

So far I am not supporting a stripe unit with which is not a power-of-2. 
But that is too restrictive. And lifting that restriction makes 
calculating atomic write limits more complicated.

> 
> Otherwise this looks good to me.

cheers
