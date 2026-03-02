Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E747B36E48B;
	Mon,  2 Mar 2026 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455098; cv=fail; b=aaXx0FFrLfRDoddacVfw3u5wLjD/7dH2awrLVZbhT0dMBwYi5d717JB2k8oSL8UayrH/u/Z/E7e5Pc5EtOYCh44hEOG8FS+hO8YKnuC0yi8MnzQRLdmhe9NiYJDXHluMSLiSYVeKAxNLsiqz7f1HAcNj6Y/aPlRKkFpdTSAKRQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455098; c=relaxed/simple;
	bh=TRV9UkeXD1w2DQe00r/t+QBXXHJTqpcSYCjiIdiFcHc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KAMQM1iMwrucc0sMOGzsmqnan7mHFK55apZLLHb08P18y1qcDotyt6JSQZf9R50PCq9YyKrh0EpVmIQivtPLGj8I1ck5AXAukCyWggWFzpB+BCtawF3KrZ0a/eIDxoSLxsoNSkrJYo1qBsqAdnb5A0/kcDcwVUo8rat6OT8ODSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hn9hUlBS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QKokmAmN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hn9hUlBS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QKokmAmN"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622CJAdp1693361;
	Mon, 2 Mar 2026 12:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WZm0CZYSaLfWmhMgfKA/6oqAXCC+MJ7w1af6/yfCf/g=; b=
	Hn9hUlBSlPN3FeVbQJ1hFSMI/TIwFum6YrLJE/9ZSchddpeZBLVgY5O2y4NKobmy
	i5NVhOdlWQrLjRgWwxusKs4EUjBMbLHULsRLYE2lLoybqaaWJ6aRuK7ENUXEmOUB
	QQ3IevO5FzHXbc/IiqkH1CNHHVwI+7Z6y2Ks4uL7atifv1E2pRVn4IBbbwTan0eA
	fy36oSxfIVdIahq3ezTYqMmSsgNlSPIb10RLhThV3KIBtRXtSHkRS2hageeYCy1p
	i5gVoYQal/uX87appNjDFpuPp8S3IOlGClAeaAOkqLimYvZ1rMhvfp/ab2B0800r
	K8Y5ucEwgkzdd8yiT4q+ZA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnaeu822a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:37:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622BpleR037789;
	Mon, 2 Mar 2026 12:37:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd5sbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 12:37:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNWWpSkvm+02DsHnbSRxbT7OtQ8+Xfrr30SpkdxTEFaHJhLUtzqdaDfLS1EkPqw2+JEk3ad0YbZ8eSxx5h35oa7WAFL/mpv+jrmhuNx01ueoGusLvHgV8j+SGw7G/pSkLcMoNvRVrGSisGo67cYSLCRF7MlqYqrx487A8JkuiByZRCTkHztSv8K4a9hK7IucOl92swsPlhudLyR5BYFGeaPi2+0ujCnMIhZIQZJX44kMTbpCgIkU1HfsiuZZw6Z/+XQkftMQFbqUar/EDWkoMF66IVQrLG3tb/3DDmi2GBdA/BBxzI6cNO5Ot3fwIxRPzTBY2/aNOPBbLfaZDZI/Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZm0CZYSaLfWmhMgfKA/6oqAXCC+MJ7w1af6/yfCf/g=;
 b=p+8haw4wUoVyM+KIXngb+VsrhGAraq4b93QUPgymEiE63ox+W76OEjMoZmIM4sszOg+t/LfLIjt/JCeTFjLjn9Yklh5bup2Vy9Ks+yOlj9gU7/5mRO5+y2ZwL6VDXCj9Zfz2jT36OlnaH1M+CnYHb1r1ASgHhMQ3ajDdN7b8h6vDlSB2E3bChCSEJbkpxdqInFA2sMfPihtYWeQu6qGD07csZOY4Xb42ck2ffuiVigyZ5Z/SDjaLc2eXJNero6uWVCuvAO/cnYi/qMGQoPie6yJTtepaUjJoy2IvfJFiSpFjoeFK0CVcmt/OIoSuvF5tPI0IqITceQD8Cp2ecrWyyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZm0CZYSaLfWmhMgfKA/6oqAXCC+MJ7w1af6/yfCf/g=;
 b=QKokmAmNJUD86nPDdnzE4jbAZeoHcHrkV5YwzUMRmhay0r8CYp5Pg1dcJL8474NFRUVd8Gev4Wq/ELJHsf3irkWASNsZPpU9WNQPQWppO6IItWnzVbtb0tdD2iR7hq9cJcB08qT2Zr3wO3aePkbiyOw3NKDJ7XVV0FABbJbC4wQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DM4PR10MB6888.namprd10.prod.outlook.com
 (2603:10b6:8:100::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 12:37:37 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 12:37:37 +0000
Message-ID: <4323fdd3-8007-4fcb-b90a-1956a47883bb@oracle.com>
Date: Mon, 2 Mar 2026 12:37:34 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: enable sdebug_sector_size >
 PAGE_SIZE
To: Swarna Prabhu <sw.prabhu6@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mcgrof@kernel.org, pankaj.raghav@linux.dev, bvanassche@acm.org,
        dlemoal@kernel.org, Swarna Prabhu <s.prabhu@samsung.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
 <20260219043741.276729-3-sw.prabhu6@gmail.com>
 <bd5605d1-3f2e-49ca-9807-e4819a8ddfee@oracle.com>
 <aaWCI69aQAWEgjv7@5163NRD-SPRABHU.ssi.samsung.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaWCI69aQAWEgjv7@5163NRD-SPRABHU.ssi.samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0098.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DM4PR10MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ac343e-bd97-48b9-ece8-08de78587c97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	C1696UOWS8wOHUHAeKCHlVUTzPULEfPgPtEwJbbk5q62FtlEnTcbqgFRla48POwj1SRPSN62uaxmMx1nS9XfqNGuYMGOAzp/Ml7ltpPhPpxdeYJxF0NHZbXv90pikoPWVhPMJEnrEdnL2kOwgpihs1DdQXShU6EZLTCYOE5ASawzeYh6aFc+rs/ll1haqyYMueSlS6iDnGpr8jq75SKbEgH05dyajLoo8u5NooI2T2OqJJEs0glvLOu8I93xR1INavGyHU7CaaRkk17hJ15pGsfzKkL5vGTFxAIDLXXZjxmM7Ed+K/yTHSSykf+LO7mmhbIRgT96d5gDIUOcz7sMC1UG8Hyif0M8HRjMK0yN2hLfGkiARqvxudfDJwt4Ves8ovD8wjNvG+1QT28n4bwGF0t5mr6JGec2Of4dXgr1pAVf19Wi42LvCc7e7G6I6RuvBPYB3EBYsuiuAq32DL7IcWt+4yjkTPw8l76boPW1+xoGrkWgBwsGB4YI26ZeldEbJgIyP4cACoQMqojlGJoelrkypX1RH59Yl0kutgHSJ0rMdwZ1kYBCU1yQdz0j5H0Z01cKGMi8NRdY4v1druvIi0gJ7RhBImA6/eO0WGiW7ZPQz3FvKjLHSxlzdZ6/kMEyOagmE0OPjqbzA1eKOAOtsyaJfM4YXnfvRZUR2nLwL4ztjEQFbGCTJOiS+7hih4/Es2rvKQ3wsx4N1FfS8GBYZ7n5UEbMDd5NbvdwWf+SZ5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ukp2ZWxYNzkxcTRGNDBmQ2kzZkdrYnpjWnk2R2p4S1VYZ3JxSFp6WW55V3Fl?=
 =?utf-8?B?T3dmTytOb3Y5eFgwU1VWMVlsTmg3eU9lakhIQ2daYTBaNVl0M3J4QWpIM3li?=
 =?utf-8?B?ZWFpdUtpNFRaRXdxUmhPckNqWlpzMWpMc2VkckhEWmx5T3pUT1FaRjEvTzUr?=
 =?utf-8?B?dFJVOENyTXBrZ3BRWTE4bGFsZ0RwL2pwZGJtbFp3VkVnY2Y0Y2xTbTI2bGE4?=
 =?utf-8?B?akozYnVqRVRIaDBXNTd5OGxGY2NYdm8yaUZBRGJWUjFNY1ZaQVpqWG9FNXZq?=
 =?utf-8?B?dUZOTHIzUzM1Y2hwSVpleWc5K3FLQzRIQWNKL2VmdGZ1ZUFWOUdDUFk4MmlX?=
 =?utf-8?B?aGk5VU9ZdlJnRnFHWWFXM3ZFYk1WbHFWZVplK2FXRnZ6Mmd2ZUhoQXdiZ0Mx?=
 =?utf-8?B?TGxONVNYOWJ4YjZpZVNVb0tmdStweGh5a095Y2xLc05xL3pBTkRPTWZ0ajU4?=
 =?utf-8?B?Qm5ERWdWNVNRZkZ1Mjg4ZzV6VlJUWDZDcFJaalVVbUxkb3luZlN2NEU0dlh1?=
 =?utf-8?B?YUFNdlhINmNQQm8ySWtVZklsKzFvT2dvajVLODRDTVBxN0d2bGFJSG5vSHFi?=
 =?utf-8?B?U3pveHArVnVVQ1FEemZvNUltMW1VY053emgxSmVYUmZiTXRoVm5hYXpXajlw?=
 =?utf-8?B?bUpXRGVlcHpHZTFUa0E5UFF5Sk9EZW9hck5oQ21jYkVoZ2t6ZnZDMzFSYjUw?=
 =?utf-8?B?R3RTTXZpQ3B1ZGkzR2IwaXllZ1g3M09yTy91WjdoK1RsV0crS1NDWXJXbGpn?=
 =?utf-8?B?amMxcnNpVUR6OXlSZ2MweXNHNCtlUXVhUy9nNnZhWU1TaHJsS3Z6VmttdGFq?=
 =?utf-8?B?UFZFcEZlQ0hMbEtHaDJEcUlNUWQ2RGozbkY4VWdib0RjbnpUQ2lkVHgvVjUx?=
 =?utf-8?B?ZVFJdFpTaHoyTzgxbVp4QzVYMUM0WngwQ3RtNnQ3UjlWN3FWdzllTEFJODgx?=
 =?utf-8?B?azhodVlxZWxBelZVNHJ3MWxQblVXbk5JZVE4MzhMaHJiTitxQ1RxT2NLcDJI?=
 =?utf-8?B?aHpCbklzYTVHODVsN3dNeWxHd1ZQQTJ1MzF4WnA0TW44eEZGSUN5SFNQQWM3?=
 =?utf-8?B?dzVXdGRSTW5kVFlYN0V4VjN1N254R1kvOFkzajhHWVNqV2luK0tNYTdiamdP?=
 =?utf-8?B?MkJvc1FQVmp0RXROZzBoZHRCVWMxK2pZTFhBaElZajY5WVZXcGNqUW96a0ZC?=
 =?utf-8?B?VUUxZ05sR1ZoeURhSHZHUHdkQ2tpUVhyQW8vRFo0bHNUbmxnNllKRlVnQUh6?=
 =?utf-8?B?NVIySVE1RDIyS01uUGhMM0FTaitiY3ZlVEZsRklIWnpIUDZxUUQxekNGamtU?=
 =?utf-8?B?bkZaa0ZGTzJIMTkrSEhxUjdQQ2lIaUZBR0VKRlNFWm0rWkpEQ084aHl4Y3VF?=
 =?utf-8?B?OWFocVZ0TmV6RkQ4OHRPV3JvU213ZXAra0pSclU1cjI0eWhMWE9RTE1wQ1ll?=
 =?utf-8?B?MXlwRmVLeFphSXJxMmhjamtXdXlnQzRDYlh1RXJ0NzJaUk8rbGdtcEJYelBv?=
 =?utf-8?B?a0l0QmdHQlZnbDlybzFXWlBZWFBNWWZlMnUxdWxPbjVjdG9vV29RdUJzMHFs?=
 =?utf-8?B?bWFCVEpBZE1OVUkrRmtWNXFhNnpxdEt1bXVWQVozRDNmS3k5R21DYU9XdE1S?=
 =?utf-8?B?ZGJCOTNtbStFb2xKR2ZaQm1OVktod0J2WCtuNWpxSW50QksrSWsvUnVaS1BQ?=
 =?utf-8?B?Q2FUOHA0SHIrUVpuMy9QM3krNGN1T0tVTEJIbzJoUEJCY1pVenFsTlNTUXJi?=
 =?utf-8?B?L2Q3ZEJqemM1Qit3K1ExL3RCTDhJd1dUVGZXZ2Z6cUpUdWg0MmtZSldFd2Ja?=
 =?utf-8?B?RVNUZXR4MTZTakllSnFVOTIrOTNrMHo3T1dxaVRDN0Rpai90NE9xc2N3Rmxq?=
 =?utf-8?B?cXFsTWFkNW4vQ3VEZVQxWklualVMQXF3RmFOcEI3TDF5TUhiK2JGbWJPRXU4?=
 =?utf-8?B?cXpVZjBQMHYxbDAzYmg3S3dST1ZpQTZ4M1BJeWVkMWZFUHFxYU5PRVdvbG43?=
 =?utf-8?B?c2x5dktqZmpoQ0ZQTU9FTFZkNE1odit1VjRIVHczRmN4RThRU1FQUHUrQlhI?=
 =?utf-8?B?NEt0VnltZEljOFhyZk1xRmx0UC9IYTlhd0NaUk1qSVB0OEMzcytYU1pGeGxl?=
 =?utf-8?B?Z084U0FnQUxib0I2YlZCRnlaWXlCdW1ORjFTa0tMY0ZxMGhJd2RuV2w1YXRu?=
 =?utf-8?B?eUsvcFVDMldmbEZpMTJ6VmNYRVVydVVwT1NjSGdqK3hOamNZWjdlVmsyZnZp?=
 =?utf-8?B?R0ZOUWliTTZ2bDJDNVhKODduQzlXS3J5YjBPZTgxNXBnUlZWNVhzQWNLSEQ0?=
 =?utf-8?B?ampPUzU1MW1hUkN2NUR5UkZWMG0vSnVzeXljeGdKUjJwc01zSGRJdVEvUDFw?=
 =?utf-8?Q?WS7XUN2XNRqwdZ8Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xMrh+jQV7UeN0YG9Jxf0edZJHCmXaKpuwv4OXVlJqKqEe3EpkDB2uwghT+k9hHS1FOPEsCZ3xZejAGiXexKqIv40BU+oAOyJgJtzKuK4U+jP780YnUaMzdxthQUtv6NGn3MYYVwaJjj4aaYCmZt2BHguednRULwSc2+qXobt/+gxuDQr86T5ODGMNBTeQ0qLog23u4bRBPDxdCyYGV22E+plCsfUMdPsg3X3uxVseQxUXoRjEBXK0PcnHbBM0xKuZ1CYdn8jy2U7CQ8qq5L97nF7Fez0F42/V11525nc37KP0PENEMRhlcMzSsCehJGA8Q7r/uv+vm6T8lelB8hiBLqqN0+CRff6aaj+QwQSPooYvaNxKWFKXIprVbZHubeGiaREnjdBeWBSIQcEIjDjAnR2hBrDYvHzn8DOIdEIE1UfKV2wfDyRHFczL6cXv2eQR3h6u0qQaVrXGTnL0vWLnDw38DpN/p0RAJHFsMVWn4PW5ixdEoCEcbJc3OFusTEBFUOCIhdN+bzw11gGfikksnZXcq+gK2pzc6uDAOzCHJOjSNCg0SyNyZudJTSKdbRGebmV3sDxcWY3eFIn+jBiqsPcbxw9VNa1dRc7xPOVffM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ac343e-bd97-48b9-ece8-08de78587c97
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 12:37:37.7336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJ3EvrN6XXng/cUi/Ws0+UQhA5eSvCHeU8BcaKb6zdg379/QmOX0L5diy+fXdur+Ucfx065fG+TS3+OlcSShGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020105
X-Authority-Analysis: v=2.4 cv=UJrQ3Sfy c=1 sm=1 tr=0 ts=69a58497 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=hD80L64hAAAA:8 a=TwRSjI4exjwdc-06lcwA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: qXctKnHvg_FMnVbJVs79sBCXElRHay_J
X-Proofpoint-GUID: qXctKnHvg_FMnVbJVs79sBCXElRHay_J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNiBTYWx0ZWRfX9EVYZlqJxu3h
 ANjRbPRbi0kcz/e522YEynfhDTQKGtY+TEVLvJ+gLuD3VC8/W3p0VPU+WbsyrNTXu/l9StTVwS1
 ZhyQf04SAsWgfKQnYSTozkXNwc/oBgp/+A2qDG+lK6hq/V9fZDkXQDuMqBYjQBYK9DBh32KcEOi
 W08Ca7nKcQlr/oB+9tXogsSzkcHTbdG+UXUx1C/SC5y7cS2AMTV72q88JWXXIaDSPog6ogSfDT4
 khbApYlA2Gq/cHxqZuoAIG6bMjdYrtdIfBkJ916YiZ+ZDHkFCyIwARTy2rU8DXHZIn4SnAKGcVX
 DVHEgdyRcVzcZD4nbiP7Q5qGDOyJ9Mu44nZGsJAjNpKpFULyIfOgs8lCbKeZ6PK50ArgdGENx2+
 YuWn5QU7OFheJ6kK31L8Aq+LePdZBYBfcau87fjyPde+uQdtj7IBxVqyDE1ugq4nrNG0S5AwBS6
 du/6hOdV2Kf3PmPKPI2HehV+/zkLEpzGiULTBSgs=

On 02/03/2026 12:27, Swarna Prabhu wrote:
>>>> PAGE_SIZE in scsi_debug.
>> Surely the sd driver or block layer should be catching non-compliant HW,
>> right?
> Yes, the sd driver and block layer will catch any non compliant HW.
>> The scsi_debug driver should minic HW, and there is nothing in any SCSI
>> specs which mentions that the sector size needs to be limited to 64KB or the
>> like - am I correct? The useful thing about scsi_debug is that we can
>> pretend to be broken* HW and see if the upper layers catch it.
>>
>> *broken for Linux or non-compliant wrt spec
>>
> As you pointed, the SCSI spec doesn't restrict the sector size to be
> limited to 64 KiB. Earlier block layer had limitations on block size
> upto PAGE_SIZE. With that limitation being addressed and sd driver
> change, sd driver and block layer can handle large block sizes
> correctly. By allowing large sector size on scsi debug we allow
> emulation of spec compliant HW.

Sure, so is there any reason to have those checks in scsi_debug at all? 
Would removing them break that driver and be unsafe?

Thanks,
John

> 
>>> Reviewed-by: Damien Le Moal<dlemoal@kernel.org>
>>> Signed-off-by: Swarna Prabhu<s.prabhu@samsung.com>
>>> ---
>>>    drivers/scsi/scsi_debug.c | 8 +-------
>>>    1 file changed, 1 insertion(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>>> index c947655db518..4c6feee87f05 100644
>>> --- a/drivers/scsi/scsi_debug.c
>>> +++ b/drivers/scsi/scsi_debug.c
>>> @@ -8495,13 +8495,7 @@ static int __init scsi_debug_init(void)
>>>    	} else if (sdebug_ndelay > 0)
>>>    		sdebug_jdelay = JDELAY_OVERRIDDEN;
>>> -	switch (sdebug_sector_size) {
>>> -	case  512:
>>> -	case 1024:
>>> -	case 2048:
>>> -	case 4096:
>>> -		break;
>>> -	default:
>>> +	if (blk_validate_block_size(sdebug_sector_size)) {
>>>    		pr_err("invalid sector_size %d\n", sdebug_sector_size);
>>>    		return -EINVAL;

