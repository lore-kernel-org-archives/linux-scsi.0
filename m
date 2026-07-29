Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F9E3E7633;
	Wed, 29 Jul 2026 14:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336718; cv=fail; b=JSn9r7Xd02HcAVnpdf0I7d73Sy1+oUXc83PwZYqszVSeo5HJaSO6KsjoSypH9MIRSPbF45oOBqQcD2glqNFyM2kIx0qQ7mwUmQ8/wfP87UYATV8MlpbTnwj15XjEPp6AC9LD/CEdKjC1eu8JMgN2NrehMBmwfy5nABnpqr9/fTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336718; c=relaxed/simple;
	bh=kxxZhtSWP5xHM1nx1dClX6/GIkbKFutkkM/iQwt69Dk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cwdGj/ljOEYG0GK9OYJeGvTx4KMBz6GE8lrgt5alFjENPviRWWE9ckNEdjuZsYxAFNEHghFCsxevXfyYqSf5XANoaGWt0VzlMPy0BaDeV/U8n+Oj4rsMvLKsnFoabMh8yuauQvt53hX8BCF62bBbbhQ6o/lX5oOr2+8PrhoT8Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RPnwlNF1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KVFN8nhf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RPnwlNF1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KVFN8nhf"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTJJW3035319;
	Wed, 29 Jul 2026 14:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pZpSG6MSS+vnyzxnbE0xV8VSjTRKEbKwyTmK98VXZS8=; b=
	RPnwlNF1r0CswsmFqsvAzz0DSHalmmoZI4rFXbRne0c6+A6q5VM7n3o/t3SKe2aH
	fRk+RIqR/ftwtaXViqNUMd7AsNTV17p7yJZNMaXoHHJWz5fwpVqT2ANSFYjbSCgN
	VjJWR7Gyaec4DhPBv2PJzIzRCjQQuqkuIlpyzgmoJk2eo7S3mJTHZFor4L0qD8AE
	gkBPA4fcD3rGZ1mh3hUqOXre9WcfEQSTx5hQn3Y8xA2bf4MQc7Bs0qOIuB0bXaQ1
	gEPU/nsDZtR5hufudwVJdDUyRsQieNrpYUFbDzEDZMXMrbMq7ut2rUtV+CBpOP3p
	w6pMNcoR17bYL9XjCIdJhw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5np262-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 14:51:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TEjFmK024843;
	Wed, 29 Jul 2026 14:51:50 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhem14cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 14:51:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mv+cq1lOYdCJOfxn1IrseOhGiLKWX07pCLt9xj3vhr/AE7eFhkxST83kvQta7qpyE+C8bwVnI1B/AX0IrfwGoWUOK7usxcJx4EUbc91vF7PEakdss709xOCSPNdutINKqRZ5a/lndZAfJtBpTtfaGKAkest/zHIULC5dyGLO6K2nQWnODfzqzvsKxQMDs3HCJPvaQnVDnCjZwZa2j0EHRKAV7Pfh9mVzdU2viUyzOUWcnReWqg2/QIwI9bKGoVrnJU8z2f/f+OTbCMKzyiELJj1ODBKradQwExX5D48a5ZFemxsDfS903MHOohBrQuMQ/BvS2+YXVnP3UTSfAfZt+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZpSG6MSS+vnyzxnbE0xV8VSjTRKEbKwyTmK98VXZS8=;
 b=VgMzG6IVbwK6MRGhtlaoZ/n5p094OdWFlXXJSXNXNm+vaqk1MBCCHVjjrJKdT5wLZirpWV5YeK9YWDJAkKfcb5inEGm1z3fs11X+1Xs1CifdcN8c3JCmXwl+z5UxcgzBbJGTRbKCHMBrvedmuTG51L7WQHynF15EZsLy6n80D6Z79SGS6hAuyOQRSNm6UojQea5dpKw5sjHxeNLsDrXjyFWV2QWmooImQoccV310abr4NoMTL0F4yUzSLZ6jphfQcn6aVzLxyt+i8x90crRsWAn2azJvcMzcyTLMBtLlckhskLHmKwHf6OE6m+WJ009ffaCFGCMpmRG0hY7VpeGVww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZpSG6MSS+vnyzxnbE0xV8VSjTRKEbKwyTmK98VXZS8=;
 b=KVFN8nhf83vcbe/U1Oo4hpIig888Go0jGP4e336y7LglPF+P3PpxfDkWTWRbCSbnMVNqrEJos1ykHUOXilxga/B/1PFg8wtzklH8f6URMSCABeERweJU+aQ1yiLY7nrzObD1OgLmhFekYi+1G87LgmVX1ptFsXjEMKA0tpsUW9Q=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH3PR10MB6833.namprd10.prod.outlook.com (2603:10b6:610:150::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 14:51:44 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 14:51:44 +0000
Message-ID: <fcb7a590-0a00-4662-89d2-58f6a03d221c@oracle.com>
Date: Wed, 29 Jul 2026 15:51:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/27] scsi-multipath: clear path when device is
 blocked
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-17-john.g.garry@oracle.com>
 <20260729144230.4BDF21F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729144230.4BDF21F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH3PR10MB6833:EE_
X-MS-Office365-Filtering-Correlation-Id: 787bcd50-e406-488d-f99b-08deed80e873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|56012099006|4143699003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	I04gVaeF6jrM8435u45Y8Kx+hu5M/3+q7xGAfBqGVdnAbOVgicKu2u8n9xRBTt4nbXBpuQeXBSFem1p9jMQkcfclJZ4K3dqkOXBS5kRQeioSupF5CsNetSmXDOtxc095lFFrwhVFpVNQaGfqX4UxtSCjxcB1zDTdN3fvRK6Pug4/Kf2l7HjEaUmKaKJGs1gbHzj9xa/hiMYIa2HKIN2hIhyfoPY3DF8jQ/goGVerkucK14X24eQ4hnLN5uC2PSZ3iPF6nazgHHefhYJ8cLgW0YFBuypGaxTf0eT2fdh7G67MCpM1wMWXhmHTQhWOj4sAvSEBvyqTzDVgWDuJX07u5beBbvMiemUc/UZoPs5fagrm9hfL15K+axQtWQz26fXSAaGasE9oRwqfxsGoo/YQ/JaCaEuMsC7I9OgD2V98qj2g+mMbJYADekHKk3J3phRZvMfMCkn7sOlR4Skbo8dnMLaGuZ70Y3lifvPdVRdFUF103jU/OMBzrqtjRyBTfQvskaGLqcFOu+1h7Tz83mr5uwi9YEXhLnUnS+BS1jCGmKo+39Z/L2TEI+oq+u+dxatFMJS6weqvzFHBASywlMsWT/m+fDwr5gNVV5qUOTTsysaJgtNlj7Bno3rcAv8IszrqUUMoO7kv2JbTmaGFAdxWhixysKufkD7+XISFkMXNc8A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(56012099006)(4143699003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RE5OMHdEaDN6ZDBmRFMxR2JrRm5aQmRNYWhIQ2FRU2JuR0lTMUNPUDFnR0FE?=
 =?utf-8?B?M1I2VlByYVpMOXRFekMrQnhkdmlzMzAwRmkyRFFMam5Zd2RMb1IvaHFORGJS?=
 =?utf-8?B?dC80RFR4MXZPMnIwUEpST3Ntb0c1NWpIS1N0QXNlN1Y5ejlxaWlxTkNYZlFQ?=
 =?utf-8?B?VG9XSVVKU2ppZm4rMjdFdWVNRnVGRjJYYUhPZnB6SFFMaWtqakoybkl0U0Uw?=
 =?utf-8?B?dm9oTldEdmtBRC9YZWdvTlZ6SDlsam5XWUJuTkpwa08wa1dDM2lDVkRXTXZE?=
 =?utf-8?B?aGJoQllQcmZ6aldTcEdlelBRcktWREF3bnEwMXJZSERBbkdpZ1JWVk1kdEZl?=
 =?utf-8?B?WEZBM2FwZmQvWVVNVnJDRFFPYzE0TngraGhVRVlwWFg2ZjhCcDZUbXE3VE1a?=
 =?utf-8?B?MHJPTUpSc3ducFdvOHlieGlZUEhmV2N0ZG4rZmF4OVlodkRMT3RvSXRKV3FK?=
 =?utf-8?B?TTBTNGFUTWNWd1ZSM1RNZUdjN2duSTdkQnNHWWc3djVadUM5Y3p3RW5BWXpq?=
 =?utf-8?B?WmxYVmNUVGhjNVFjeWFTdXpQQ2VwcVNBZTBIbjl4eThvUkRxSFZRNG5ueVZ0?=
 =?utf-8?B?a292bGJucVg0MlFkS2FlSU42RWJocVcwUTBtMkl2Nm8xdWVLUkUxRm5ONEo5?=
 =?utf-8?B?Y1A3QXBocEszWEVwcmE0OEMzQWlvZC8wclBjU3hzRFY2ZldiUDVvV1kvOUhY?=
 =?utf-8?B?ZDAveUhyVDF4Ui95Q0hpSHVQQ0t4NjlPTzlzd0pzc0wwK1lLdXZCTWt1cGVZ?=
 =?utf-8?B?TjZXM1dDNEt4eHUydTRsZWdyWlI5SWFRZXlUc01NVnNwYTdxTFhzMy9qTGEy?=
 =?utf-8?B?QlJwZzh1blRJMUZpVitkeEpiVHVDNlZKYzZ1MDYrQnR3MEJtWXRWY0x1eG03?=
 =?utf-8?B?aTdsaDlNZkNYRExaR2kvYlZ6bXRkaDBLVzZHQk1QNXIzQjV1TGJsWlo1OFNR?=
 =?utf-8?B?cndoeG0vL0t2VWVMeHIzN2JYM0xkNW9nK2QrOVR2ck1iZmNGQWhJZjRLcTl4?=
 =?utf-8?B?RHgyU1lyc2RpWTRTT2xTUTlPaGRCQjlLT3VGSGg1UUpqc2d1QWREMGdwblZm?=
 =?utf-8?B?eDRkUnNwTDNteFpRSm9KcWNoMnVlM1p4VXF2WHFWRzdpZVlZbGRRb0pFTHJy?=
 =?utf-8?B?R2xmY1ZGTXhndnBpVnozck5PS1d4K3RXNWxUb2N1emtoS2VFeGpXeGtWR3E2?=
 =?utf-8?B?bjFJYVk5bFhrWmlzNDc4aU8xZW1ldXZlWW5JbkZSNUtDSmQ2WXhTL0xHMzN1?=
 =?utf-8?B?OXp5ODRQaHVybkxMZmdrOWdBTjM2T2I2TXF1Z2FXSWRaaDQ2MTBRbjh0Qk11?=
 =?utf-8?B?TE9MZ2VKdVlnUUdxMisxZ3ptV2xOUXRNaXVjbElYSkhqWWoyTERHcGRxbXp5?=
 =?utf-8?B?TnpOcjN0UnpnbTVoZ0ZPRVptWnFYN3NJclpjRUo4KytWbzhkM0JBR05saUNj?=
 =?utf-8?B?eTlaUk5hTmlUcGtsUzJYTUI1NUJ3bXhoNXN4TW8vaVhwNm5DakwvSklvbm5k?=
 =?utf-8?B?ejJDQ1g5TnhEcVhmZzFNeHo0UkNMR0lvVDNFZ01MMFJmcXYyRENqL1I0Zkw5?=
 =?utf-8?B?VUhiN1lvdk9qemh3TzRvK0dxNmYyc1gyRHlKNGU1VXRuOWtXLythVnNRbkxr?=
 =?utf-8?B?Qi9GckFON0lPUFVmM3ZUL1dZcGVzK2krSnVDaXdQOEFDeTQrS0xyUjNnc3FL?=
 =?utf-8?B?UDVDK0cyR1hocE1SZDVjVG11TW1XdXVneURjVERPaitYTEVxS3pvT09OSnQx?=
 =?utf-8?B?UFpIb3lVeUpPUUZ2Wmw2Z29BOHhIMXlBOEpuR3I1YTVvMjNVS09MTjB0RGlw?=
 =?utf-8?B?ekVNU243Q2FWMHcyZVMyc2NSR2c3NzgrdE9NOXovQkt6Unh3RlhNSWdlR2Q3?=
 =?utf-8?B?SHE3L1BGeGxYeFlpVXd0OHVuZGpJRlRkWUpIZWxETUxZc01EL1I5UktraEti?=
 =?utf-8?B?SWNzNkhFeTdLdWxZN1dCQmt4aC9UeVBON29wNFcvOWMvOVRiSWloZzlZWlhW?=
 =?utf-8?B?L01sS2ZpcU1uOEZHaUExTVFkaVpXUy9tVWl5REUzRWxLdGlIMTArdjR0Z1ZL?=
 =?utf-8?B?VGlkUW5iRlpXbUlBMHRSaExDdFdhd3hxSzc5RHZ6cVZmcjZEWUpoaVJBWThV?=
 =?utf-8?B?NlRyQ25NejVhVlFvUkU0SjNzWDJZVEI2SjJlckl4dWtIRHA4WVpTYndOMGt0?=
 =?utf-8?B?RUpqU3RqZHR6aEEzWVBaK205a3RxcUIwM1VQNzdnTHRyUHp6Qlh2S0lhekRM?=
 =?utf-8?B?emhUTkpUV2JVL2dYdkc1TUhhRkxqZTVVbDZZZkJsM0pQMUl4TXAweTJqazQ3?=
 =?utf-8?B?OFh4ZS9mK29LamFkRmt4VXZScGNhUC9IenZYUHc3ZkVlWVBpalE5cjN4ZFQ0?=
 =?utf-8?Q?ZPRkVvQQOWwuGv8M=3D?=
X-Exchange-RoutingPolicyChecked:
	kqYwdN7vWRfb/u9D8fZkEOMsMglvk5mt/EjRV/E6SskBSajEZFf7q2hRfPlKUx26/emwVIXVjo07AYjmmN7UEV1IIpjjKEI0SRXapMZe57dgfcsbhsSN5sel0fMJWjT0gOZ+pRQaXF6w/zU/p1hyezwP4ODt57Kb3pj8pGwrX1ylaRTDulve9oz7VWgduxh6h+ceOeutmV03Ch8hozglzpalkGdQesgtHiT8mvWc/54DFHFPkNWfOMB2WLJRteYB612zy7xqmrrgfGjyElBXXnTjqRUafzYfLkQnAhejaBnv3djZL3D0t6fTHC3NH+XxnFpJn3QvYVTIf4nd87z3cw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jNfpHJqHnO2E2DA0Prs+88Kl/+4eZehJsXTCH5OIZ5Ead2d9uSfb0n2DClwOvh+zS9idHb82aoFz3HWT7WQbnecNsyfiR5O/VJF+2u0/n1kwwbaSCGwtWvvAtdzV3MCtnEYz8DsSqx5gbUwyJgyYhMobmopfUNKUSx2GDdWxamqTVIbqiY+WET+GKYPRyukhGDnhRoiz9Uxj9WRygG3irXwtPRspHiiaFtmqTs35Be1GSgZlesscKUKa0xTl4i8qHGzzknFHuXPHEXokF/DPx2ZhV1fGubTSlNp7XchWoSrxQZK+GDElhm5rdSoD+D2LQlhMijOfK1wkqSDV/620HAqInC6pmJu0Ihg2ez6YKjn0xM6Nu7/WbApbb2QtxnUIG+feCYO7tZvfE8UOl4XJNYW8RR5ynysIepzGh1AEgUUKH/o2YreNzofwEahyXYt+AjXiHhwyB8jhBzrBPTtT4h6Hr76hTkNvZLBle4qyhF/2pwV80JFAjJjNzl5jZww0HC6/IM/Gs/Efy+Z1elgIFHq7/GIUqviuCTAWY0qcdocQaYhuPD9l0ytJNxpjAC5Ch21Puw4PGsrq5YS+DzK+rTSQpstgV5rDcPEGAxGKFCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 787bcd50-e406-488d-f99b-08deed80e873
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 14:51:44.7424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/AuShqZCp+V0EBcEQkwFibiFlZH50n3W12TLoYFBS4KlPphaeFK6yTLcBTGEAdfLRWfxwAPKtW4yAeh4sAf+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290120
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a6a1388 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=NxYuY2e8b2wDofff27sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: n13dUXKepeWbm5tuCuwtz1DdKvoMgzYG
X-Proofpoint-GUID: n13dUXKepeWbm5tuCuwtz1DdKvoMgzYG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyMCBTYWx0ZWRfX4eFLIzPvigEC
 bbdG26HWS+k9H94EbNxKA3GrC87k6sju7sEZeXweUrpqPYWmo0j/KF1fQAtte7txkkXoB3RDH7T
 amhkAXlqFzO1EfTYxB4u9N8UzmDFwM5Qj88DqSYEuUWGhWv60xpn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyMCBTYWx0ZWRfX29eXUW9KFZBz
 ZMDjyNxUfII/RI0UGr9wo5jSv45N0DeUQMf5ZNcJVkjWj+993wInQOKSPjBBXiD3j04X0US4S3J
 Obx14kWe56KE3SCrIE0+Qt7Lh5zbvbp9LeF/GyGxCLk0V8CKebTwwq9hwM6PrGGighmy5CDja5t
 Vrv+6PjJ1zw/lw0vHVnYXkLtl1726yqUX+RUAXpJqtcRqYIvnHA5RyuONihCFUwdnQpZKjVzQiu
 QY7zSMD4eHt86ekBGtqdTs/8mGvbE4KV1/HdeoeoqnPJr1WM9PVLpfjRFTFCAC/qe9PTC/PEESq
 SbQXOwNDjfL2hCSx8VF4apQ2O1uLWxGHBFaivNqvTPvENBPObRmj29etG87qoIv4vDCvUYwmvDn
 5M60FTkaBdyDYo29/fpIlxnn50ls3Ep5oMbx64FpGGjYwFmG8PCu8ibDizlrZdb17ANtgIGqYDA
 XkJH/uImHwKN/DqaBvQ==

On 29/07/2026 15:42, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Unprotected, lockless access to `sdev->scsi_mpath_dev` in `scsi_device_block()` causes NULL pointer dereferences and Use-After-Free (UAF) bugs when racing with device initialization or teardown.
> --
> 

Same as v5, there should be not races

> --- Patch [16]: [PATCH v6 16/27] scsi-multipath: clear path when device is blocked ---
> commit 8f07d9f873129f9ecc9b8d3d02fee5bce667c745
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clear path when device is blocked
> 
> Add scsi_mpath_dev_clear_path() to clear a device path when it becomes
> blocked.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index daeb3693fe559..a1ec11050090c 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> 
> [ ... ]
> 
>> @@ -3008,6 +3009,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
>>   		scsi_stop_queue(sdev);
>>   
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((err == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Is it safe to access sdev->scsi_mpath_dev without holding state_mutex?
> 
> When scsi_alloc_sdev() adds a new device to shost->__devices, it becomes
> globally visible. Then scsi_mpath_dev_alloc() sets sdev->scsi_mpath_dev but
> leaves scsi_mpath_head as NULL while issuing SCSI VPD queries.
> 
> If a concurrent error on the bus triggers scsi_device_block(), it could
> read the partially initialized sdev->scsi_mpath_dev here outside of any locks.
> 
> Additionally, if scsi_mpath_dev_alloc() encounters an error and frees
> sdev->scsi_mpath_dev, could reading it here cause a use-after-free?
> 
> During teardown, if __scsi_remove_device() is called concurrently with
> scsi_device_block(), the teardown thread might set scsi_mpath_head to NULL.
> Can this lead to a NULL pointer dereference when evaluating
> scsi_mpath_dev_clear_path()?
> 
>>   
>>   	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>>   		  __func__, dev_name(&sdev->sdev_gendev), state);
> 
> [ ... ]
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 0d439cac6447a..b23cd6f12c602 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
> 
> [Severity: High]
> Does this code dereference a NULL pointer if it races with initialization or
> teardown?
> 
> If scsi_mpath_head is NULL due to the races mentioned above, deriving
> mpath_head from it will calculate an invalid pointer.
> 
>> +
>> +       if (mpath_clear_current_path(mpath_device))
> 
> [Severity: High]
> Could calling mpath_clear_current_path() with a partially initialized
> mpath_device lead to a NULL pointer dereference?
> 
> If mpath_device->mpath_head is NULL, it will trigger an immediate dereference
> in the multipath code:
> 
> lib/multipath.c:mpath_clear_current_path() {
>      ...
> 	struct mpath_head *mpath_head = mpath_device->mpath_head;
>      ...
> 		if (mpath_device ==
> 			rcu_access_pointer(mpath_head->current_path[node])) {
>      ...
> }
> 
>> +               mpath_synchronize(mpath_head);
>> +}
> 

