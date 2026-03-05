Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6264D39E17A;
	Thu,  5 Mar 2026 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727843; cv=fail; b=rWZG2nimHxF7l31UWsdst7/QM7fxnxq/5vKxMgPt1GSEvXhTlvvjtLG63lkTa56ZvDNUxPsvucnwNFpmpJs8LbvzEYPWu79gTO02esxF8sWsNrvKwsjrK/Vpoumweur2DPHkZwZZFXc6aEcG7lSUn67Niw77KWOwGsNND0jQjvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727843; c=relaxed/simple;
	bh=ux96Xka5fe7fPSVNsjsrjKmUQAGE4pkW5HT5HrwAdp8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TZay9hWud9crDQ6kRjKnOkGLjMjhvr3+apwfNxboVd4QHYbWrVuDlOdMzJ9V2a+DNtJjfGjuExrIKZ7FDh+d2YCcdF/r9F1l8U3Nc3PVeU7fnRUhK+GbgI71JqVhnVTxSCOqhtbqmKrkRDQeFpTtZ6C7oyb/6BqcFqHYzMpZReM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UCwYabid; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T0hWdvOd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UCwYabid";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T0hWdvOd"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625FcE811304918;
	Thu, 5 Mar 2026 16:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=V4fatFBSy53vF75AfWMraKNgf0LHavLmtsUc5fuEOIg=; b=
	UCwYabidk8EXek+x0AbgtCikO/6NnevDtKeldn//saSs/CsRsnwjGMJQqC1q0aS6
	rhaAbxL41Iknl7bElblDuJbI9aUvoPjMYgA6Gsbi/bo+Zm8CXuzhUMCNbXDLjjfR
	vS0L1ycyB4DVpk3e0bht/5/AfaAAetoAd99Pe8vAMr47R13bzw0TLxhGsPOfrgpq
	pe+PL0za3Fn7G15YJ5SoN/18tSvgQgwgDv518zcTAGbCjw+xxq6Rc5O1TwYCVKe1
	ErNZ3LghrizhTBFClb2CftqK4bLLn0B6cHq5GIXrOpuObl0Oni2uzaYhd4cb09QI
	2orGrPchaeRGnxQSfzGWew==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cqcn902h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 16:23:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 625GJ1ue029873;
	Thu, 5 Mar 2026 16:23:40 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdeetx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 16:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CK6Qxq5AZuLRB3rmRwjoZ3utl2BMxszNVjM/CL1dlSxqVqISmE07MjRJv8EjW9VVxVXKe9F8ofLlLFj3A7gZFdftF4nSt4QahGvIaCq0JpwsdnRbIr5d5h87NiIO17vVd/ekY0mRwNle1B9MHaqDfYGmgfyLlSOHcfGpXqA85MDnWhGAJwia7dFRIsnGTKqnG2HeOZr/54pOy7q1md2m97GPAMAOrS/IT5j1c00iOzhOAq02XjIh6B2V2ZZYyKiXPaEmgSUHtvqyPZbzFkqzXcP/XGGz69fkbJMlUQbe0iYP8r34NOaHvJXTrp8GO/QRUkL767WOBOfXXTMQhdUk6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4fatFBSy53vF75AfWMraKNgf0LHavLmtsUc5fuEOIg=;
 b=fj1OWrS/DhJiZmaA2CcT8ab1d0zl1kyXd8SX2IDiGSZalS9s8njRaJwUGO85e5ui1Tw3B4aJGIFEoyGXJ/6cthmEMhYaHBCLMdurBrJxeLnS8FykWZ6EOAFg9oDon/5PObEify6J2K1ufSqmpfIUp+slM0ryCngbyhP+kmt9h9S5Inl/TtbLo9zfN1Ngzu8kOyVxiJVzPUGBY1bgf7XQHfBzO5Lglosra8gDoiCm46in/9BiC6Ji7+UHeweD7aH3d9TGtucz2ZkDh0NlsbS5COM2EQRA80FnNi8sD73CD36vnMlSYvDHPSZTouC4Rkb728zCTylAxr9nQoI8pyr65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4fatFBSy53vF75AfWMraKNgf0LHavLmtsUc5fuEOIg=;
 b=T0hWdvOdhk5cT0lH4X9Xu4ujRcxwwi/rA9PwxUg7+OHi+hMZeA618KDGWkrjytgyu+8Sfn9wTs/KGzf7UI4NLy9JWxLB3n0A1BaDfJ4I56alvhi7G4uMEHxWyNEyuUoElNaV2fQUCnFjyn8Ft/wwoT65Txp7aBL+BMryyVxKlbc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4983.namprd10.prod.outlook.com
 (2603:10b6:408:121::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 16:23:35 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Thu, 5 Mar 2026
 16:23:35 +0000
Message-ID: <c6119b95-d750-4037-b157-000dcccf3e87@oracle.com>
Date: Thu, 5 Mar 2026 16:23:32 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: core: Drop using the host_lock to protect
 async_scan race condition
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, dlemoal@kernel.org, bvanassche@acm.org,
        hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260305025125.3649517-1-wdhh6@aliyun.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260305025125.3649517-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0338.eurprd04.prod.outlook.com
 (2603:10a6:10:2b4::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 50280909-1af0-45e9-559a-08de7ad38cf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	rwz9OQ31ZVDql4SNKQClIU8WAuXX7vZ1imUiBIsyoo3FtmyXZdDOZADLGbB+Od9R0oFIeBiZ1dVER8Cf0g+pd9iSClQfuARA+3QVGKR9KTk9g9eCrfxqejHPcROenHdXaTm+i9MTYUT0QpTM2gfasuRdwyje3uQ/cn0QD7rI9jx8odesoj3eAEEChTIvnS09CBPx9xOhQknDQy+CZTtB7KDI8dmJiYRfvKKPXYSbaNwD467nx79vSijATsPm9diY3AvIHa8vE08Rpp48r3eHXo4ehxYPLqlKpVhyWpaPRH9SA37OeIph2Br6tgUFWKYtB+tiLytBcD6lBMpt2me9eLCrkx2JRrb76Ci1xJNUbyWrtpiVzxNcpzaWUUYEzN6UQtVbU985XFzaQWRi9nxIy9bSXuQKHeg79kiO9Bfw1nFS66SDfng/WcpXFfochEF3o2+OQjlN5xgOnhr2xp5RAfeDV+qqhDYJRDY0acskmlsbo5QwtfwGu90jvsJNwRwWBJ+Rr5Jw/hx7xy8QfNokJtIQ5hDacNuVI2UITPRwUiWU9EzCC5O/akoUNCbe2mD/lfjRdzFpDpev3NCzh1SwNgxzqcUA5NLVZ+b71coRS2+p6e6wK/w6gc03lrS6dyaeueCKEk2NvX11gNbeJw8ejUkAohhJ35ZlTI/dorKleF2RycNtEO00tB0Ypgj1/R28Fdg+5fO/87tt0jS9XxlMoPllTXlA0HqJIgqkO5wubuY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emxjWFVDdWJKZ1F1K0FmNFFPNkx3amNDT1liSW9Gcm9xdEVTQldncnBQOHFQ?=
 =?utf-8?B?Nkp5SjNzc21zNzNlVk4rem91K0diVG9tYVovZzNMQXQxN1JBSTdhbFFhSWkx?=
 =?utf-8?B?N0tWZjB0b3oxL3RoTi9IRTZqczVvOENWQlU4N3l3c3lJdm5mbUxYd3lCSUVD?=
 =?utf-8?B?NXBJR1p5ckRPVzJML1RPRyswMVErUTVLVmRWcStNeDVPTURMQ3RlU3FSZDQz?=
 =?utf-8?B?aWhZck9tWUJmMWE4QlQzMnFyZlRsUmxPaGR1eHRJVlBkcCtDTUp4VUdJblVW?=
 =?utf-8?B?RFh4aUh1aW1tN1ArWnBod2hjOHNkWG0vTnVod1lSSlFMaG1yS0d0OHA2NmVo?=
 =?utf-8?B?bnFjUjhrZm02bGIrWXJJWnhOV1BKaEtLNTBBd1V5TFhyeXBiR0NQRzY5ZmE0?=
 =?utf-8?B?VmlmV3prempha2tOL1ZMdTlsa1Q5T2gyV1F0NHNNV09NbkllY1dZY2tyVE9W?=
 =?utf-8?B?b1NzRVEzc1RDdUsxQWtkNFlmZGRxbjdUOXFYTTVlWDBBRWVGVEJQNUNudzhN?=
 =?utf-8?B?SG9IVStSenVmc01hWkd0aXc5enZpOEFNdFNoNXdDa2xEVkFlWG5ZRkFndU9E?=
 =?utf-8?B?NWJTTVdNandVcHBaM1dzNFVCNDNkS1MvbWI0TUUyUlluN2swSENhcmtwUUkw?=
 =?utf-8?B?dDA2YThyaEVkK0ZTSkM5djdSY3BmOGpJMEUvUzNNNDh5OXRtRTk3V0FVdFEr?=
 =?utf-8?B?OWl5eitDeFQ3cHM0MTdZWVZuckIveDZFdHVSam9MVlFwSkZBMEdlcDFvUnhH?=
 =?utf-8?B?TVJjWklXZGZhaUZCZnY0WjdqRXFPcW1pL1NBTXFucmVjMTRkc1NrQ0x5ZUkx?=
 =?utf-8?B?ck9helo0K051QU9ZNTJoaVFzZDRtTTdwTFBYNEpsMlFxdy9sSDZjWFEwUjdI?=
 =?utf-8?B?UmRUQUF6b2NaUGxSTFBsWGIzTTdMQ0x4T2dVLzFmZXdlSWxNQ0kycFVDbXJX?=
 =?utf-8?B?SlgrY1YzbG1XRmprUFFWYzJla2hGVlFVdmF0Qk0rTXlZTDlCNWVhQkdiYUt4?=
 =?utf-8?B?WkJza1JodEVCaUVyc0pocnVQVEJEMWgvclpRUEpCZjJMUlgzalF3MTBVUGor?=
 =?utf-8?B?WGdYdTEvSVMvK0hlUDMrc1FUdGJzY1ZSeExpQUhoRmR3dHZpU1VZTENiZlhZ?=
 =?utf-8?B?cmNjTjd1NWt6L3IzWjg2MnErV0dkcmFtTGtHalJIWjNWakN6ZVBqWGJCZzBn?=
 =?utf-8?B?aE8wZ2N2d2QvRnRWaUZGcDd3eUZQQ1NaWWd4bTc3Z0R5TE9hdjhNZG1iTUZa?=
 =?utf-8?B?V1NWT3hrL2lwNXdSV01aTzN2TUVYM1FmcTZUaVUzMXJFU1hQZGJZRFl2aEk1?=
 =?utf-8?B?QThpRzlPanZjL1kxUDdUem1GeFlzc3NmSW4xb3BqNjl0bU1CZkRsQmtYZkkx?=
 =?utf-8?B?SWVIbzJNZ0phcTNpZThsZ21RSm55WWVJcVBzRkpGMkxKMVNjQ0x0T21QUzFz?=
 =?utf-8?B?NWxEdUt4RGxwNklUZm9iVzc4QUFOTVZGZWtlTEt3SkYrREhFdWtiZmhQaGpE?=
 =?utf-8?B?RHdyT0t6SnNwM3RyL2lFaVQvcUgySWQ3NjFOMnJIaWZ6WVhIZnNZWVVON0Yr?=
 =?utf-8?B?dEtlWHFCQzFCd2lDMml0SVlXanVVMnF2cjE2emNmdkdMMHNHUnFod0dwaXc1?=
 =?utf-8?B?VmVPaGFNdGhpeUc3d082Zm92QTNuUUlmdjVuTlJrN0xsbnJ3UG1kOTlGajBy?=
 =?utf-8?B?NFdKMXZxQ1dFaWZ6c0dxRTU3NS81cVpmUWtnMmtlY2FnQjdDK1paR2JrY2VT?=
 =?utf-8?B?OTFmazFzeUtWWkhoa3BXajBkOFRza0d0TGlPOHRpMis2R1VtdmVTMU8vYzBY?=
 =?utf-8?B?bFE2R2Y0eFpGd2tSSnp0RzVQSytOd3R2MEgrVjdWVXh5dllBMnBKZGovTVpY?=
 =?utf-8?B?WDlVOHBYamNQRUswbGYxNnhzejdjOWZmRzVHN29mbXhqc01qZ0lVeFJoNGNI?=
 =?utf-8?B?N1pvMUluN2Y3MytlUjdZbDJncVhMVDAxMkhDYnJCUmovblh0dVdCQnNtRGRP?=
 =?utf-8?B?Q0Yybm5RdUtWTWs5ckNhWFIrVEtGV2FiTVZ6Y1ZCak0wajNYeW5MbU9pNUJ2?=
 =?utf-8?B?UFdmTW5GZEZONDZpcmRZdDU0bFhNUDRVVUpscWxOSHlUR1B2QzY1bHFHejNO?=
 =?utf-8?B?cEpNeXppUE4xR0JxK25TS3BuaG9TczFRWkNLZWpMNGI3d093MmxPZ1dFMTNG?=
 =?utf-8?B?MlAvT3h2aHlxRUswUGtHRTJ3Rkp3SElIdStVZW5GZnlqR0Zlb3FDTWZMR3lE?=
 =?utf-8?B?blZoR1J3REpjd3Bnbm1FYkszTDRPTEwvRGVYTVF3dnV3Z2k5Z01HVS9Taiti?=
 =?utf-8?B?TVFzcW1EbiswTDEzN0tNOThGLzdsR3ZHcTYzR3Q3VnUxSWVaQ2xhZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QWosU5PagLx0K2mJao4hRwW9RqrzWDGMH/xFAS03+OjlYOpDokABidl0UuDwtS8qPKfMVf23TJ5YWVgds7Y+LszA7NiRNuhQEkyL2E2mrgltARORjW99ufE7erfdZSszKev2dsS4jZ4NlCogr/ByTf5haUgFquCJqhjvH19ervRygLlHNwmCuljVGAAbYJQO2udhIXrf5knVbB3mjryQ9WXMRvvCv/cKKOEbFZ67fgIWDeZMLRy+Ho4rmGpbjwU7sWiBsxfNHmLQZRjuQzAnfhu5/qr0Eykbf9UEvK14F0DMeWwxbU3R3OO32fCC0Y8BOs9EORtNSKDWd7qAf0zEC3M3kkTdJW1LjypfQurjbU2aBXNLlG6e/cAaTxs/ALMtwPPp+SsKLsjp9evwWTcpJr+SjNFTSOnL+7pL6Y3gvDhR2OS3MQxgK75ZH1XZUPckrpsU6A0aiTuqOcfBOfc3XX0eWrt1Si4iR+4ggewMjLdiW9weSQBFI7YnIfvg9PHqs4V49MZ7wP7p/hdkMLrhJjXD0cvnzZ16RVvbjjCal/bc+i16TFos4A5R8VS8z7cmooIguCqTFo/rvbfeFvVp+arqjOuLv09X5uuhAVafYWM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50280909-1af0-45e9-559a-08de7ad38cf3
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 16:23:35.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYf8U84M4AsM4cahtnIfL74PQgCxAkAIGGNZbR5WZZF4Q6ftcc0BsdDDeHiHks5F+Tr1kfzzj+YitOnFPPNg+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603050132
X-Proofpoint-GUID: 0pwHzW9DIXtYZKvrrs2qzll8R3L-cMR3
X-Proofpoint-ORIG-GUID: 0pwHzW9DIXtYZKvrrs2qzll8R3L-cMR3
X-Authority-Analysis: v=2.4 cv=B5O0EetM c=1 sm=1 tr=0 ts=69a9ae0d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=nTg3QbKWAAAA:8
 a=yPCof4ZbAAAA:8 a=cgsp_6E_B-HyTdSHA08A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEzMiBTYWx0ZWRfX0ShlIjHBbL6V
 o+f9ZPGCN78fNXgKzQ0oAB9dHwnGnWQDAPuT36kmCgtMjkwmcLspAmgYbSyaZ2Ywa4IMHIlWh+v
 w2U7bg1c03iPJkkMIlsNZT6nElJjQrf95A7pplHrIwcJdBfsZl0TFkLF6H5iLChjBnKeMvBahj0
 cro8XKRVO4Omw/xUvK56SKZ+hmqWS7Dx+wa4p3qfzE8Vg+eqwmWh1v9FtJeynyph/HRyCtLPEtq
 to2rPEIjkPqPRwco1G6h53YZMGBWrTWj4Fjb9+SRkVktNfUQbOp7QuAqJZ48QfKZgk4WV5HXVFL
 MePZN8MQd9upFrWuGqB7F3fgWHHXeetaJVePll74XqoVqV+wWyqagpzJ3VtzIecPzLSlPddvfXw
 gCW2x1ob0JSP+cXOLS9k1HTOS8chd+3xpZruOcJHgPSWJgRVt2g7Apx6q6jm0MtZv+lU1KeDV2R
 CAOXNLfuZo4MFo7f5Xg==

On 05/03/2026 02:51, Chaohai Chen wrote:
> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
> but this approach introduced naked reads in some code paths.
> 
> Convert async_scan from a bitfield to a bool type to eliminate bit-level
> conflicts entirely. Use __guarded_by(&scan_mutex) to indicate that the
> async_scan variable is protected by scan_mutex.
> 
> Signed-off-by: Chaohai Chen<wdhh6@aliyun.com>


Reviewed-by: John Garry <john.g.garry@oracle.com>
