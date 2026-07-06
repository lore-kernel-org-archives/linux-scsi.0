Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68A0430CCD;
	Mon,  6 Jul 2026 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783353489; cv=fail; b=Siw/4629DXhrDRPG010P/UDFw50VBuZ6HlClWMR8is+iseXJKnxy4dfBDj6tFx4eIcGcbH+A2/a32uBicTD/KxlWsQmWe9aNBI68aleV1SYzyCP3RzN/bLNMbYsWvfq8ANW/tg2sc0DSKS2M+yU4krAjMqUWrp1noli8Z8O+h1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783353489; c=relaxed/simple;
	bh=A067Th4jVjm/SLCx9i1b0b0bmVLB0rOnAZ5YkBLNyls=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UmLcK5SPAeEMX3v9IQB1Qdaj7nlrhsETNcn6+y4HKL7XKi48fYBtm+cMt3IabBSRi3NnCz5lRqaHsPEnLT6ajPHXB7LYYKoWN6XkV7sGoRN+G+K72yAFtyHAZxNiqDlmVN/r1WNOtKAlPwRwmYsyW907p5lENyUE5wzFNtsBISg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sdeuMtns; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dHNv/cIt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sdeuMtns";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dHNv/cIt"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666FPgil1595326;
	Mon, 6 Jul 2026 15:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KrJ10KEOlTK1ge9Se7HfYSqXuKSCCt0hADmB3YSF6Rc=; b=
	sdeuMtnsRRRhmFGJphqb9dYnLrCS0VV5uf2fUYmMZiwHOdcUJifbdNvkFxqZ0M8q
	gxAt4dwOAyDNtYut0j0+2aF0ZVJmrHJ0jWEDxDVR61E3Cb4n7ALgfrkZr1tPpulr
	Z/hB8g5kRfKNVG1Rq5EQSuc9+0SehMqkg97B/HuQ+b3LtrciEFOtIKknSn4MUV0y
	koFlyVHjJVqEL3UISomACo+UDQVe60WLuL+V5a+N3e0WAY8f7EMp66P2N7K7IlPQ
	lpfxNgFsRPB/zbkU9VEO7xufMLVkL6ZBo5+i6XN4VXL/P+cnHLI+iDtUKTzDge6I
	x/gQtIxOuyz0VRy9YWWJ3g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t2a3v89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:58:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666Fw1IN024004;
	Mon, 6 Jul 2026 15:58:06 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmc964v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:58:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxwmTfUdCCm9LjRlZ14/N9K6bzfUVsupXdtJN0BDHN3nFNQyh7u3/9whzA9Ok6P4GRj1XGPIzFjN9ur5aFnRS2AmDsZYLljIXVUrLKxmQXdGGnKM1o3k5ULedCvD17+mu6k1kQCrGK/NtX632/xbGaotg4P/TLoLHk4fOz1ZhgGrp39d7Rl1cCwUAbK5lHWS5e/2oC2+6eDeAVl2xtl1JYy0fLbpSLUItOu2CthJvt8tBCLu4F9OtVTQFld3N575HPtSRao/gO8W0mT84DSkuwbDH0RZk44pvoezxzj6TJ1ZcG1+6we2cdf/SXpI88P+MFV1p51j+BE6emRzmITBiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KrJ10KEOlTK1ge9Se7HfYSqXuKSCCt0hADmB3YSF6Rc=;
 b=BoM0Eh09v9gKdMCsipeQ5ldRZwEhSIBFB+wMxi5gTH+HkmO0KKMTAjl5kCu1Rd04K/cXwcuv5eIYKGeW5ilxVGlnutB/xy/ew2hz7cr2bZDgzAPWILqkk152nEPUXRyIpA/yDYuox5kyc/ApiQRpP6vjYkLzuP177mPEQHlnB6mnwGwJA9/NXI4jrZoV0YW1TraFL0FKvAwdbCKKlbR6b6ZNOCLK5Vp5QwW338Rz/CVOlhLG2zyxGyVCYtUW0LbJrj6WTERlfUZCBdijppioyqVmz/a+rgiDAwJ8pKTLeLRoaqF+/kB+bWknFnAIfVbkXnL06+ewmpTUAYG295dkaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrJ10KEOlTK1ge9Se7HfYSqXuKSCCt0hADmB3YSF6Rc=;
 b=dHNv/cItXEQ94siEK/hUSPJQNedLL0nr2nW9FtPGTmg9pYybEOfi+A5h8Xt/EjCWuhZNEojCzwNgtpwYVWtkqxrbJIbfBGEoQdDPoq2/+B1P2vfUejcbrF7i+jIvDDZgZQipiZGEvEXNt0CAJ/U+5WxFV1jBlIVHJSbzYxVpZ7A=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ2PR10MB6991.namprd10.prod.outlook.com (2603:10b6:a03:4ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 15:57:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:57:33 +0000
Message-ID: <e89beb73-ae28-441c-a409-89e9657c702e@oracle.com>
Date: Mon, 6 Jul 2026 16:57:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/17] scsi: sd: add mpath_numa_nodes dev attribute
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-17-john.g.garry@oracle.com>
 <20260703124402.6C6251F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703124402.6C6251F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ2PR10MB6991:EE_
X-MS-Office365-Filtering-Correlation-Id: 53bdd432-1795-4466-dfe5-08dedb774a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ktKxehfMdg28FBjgXzdOAKQUAvbee9kCDPZ91jIQ2PpTT1GnaHc79lrLLPcdMboaKhd7uJQ2A964e35zJtTA2v5Kl7zd4pt1Rae2DSpKMmeBKQ9cGHL9oOh0TtF5NoYCQe7y1iwWZwOy44hjJiPDvV+gKM9EaWRDJxr2W0MhS+6XFNydNSvIs86v90jucTrJE1CDAcNmUMTXiKASTRgHWgm1Rc9Gjp3TAC59w2w+zYDTQ8OCKdSGKfeTJ7ZNmErgwQi97UYmmaouWbxdNsDyQw19Z5/y1+PGibZctdVfsFl6u2u77Ze5sgmdZsAkre6BLocvg009GjdJWw37jEXZhksknjrN6iImO6Ow6CGfKrRfkp0z6GGGvf35ZhckRcvxfVKBbCYm/9bIbd1FNkzBZxjSfdGlS9mVqeo1MHGQBB2mNWX8AXZOpVSmbggaWX4vmNuOpYofAy+PKr9suIfrd8ryEfBFxXg/LA97DRFkOaB+GzKqnBb92wtwL0oHkJcpucQXKC111TL4LGxFZPzOjTEavsPhoUEFK5Numyqcxkjn1egr3jP0IBP2b/zJS49T82Sxh1CaHUtBheKgduzsilJFNXP7mbbYOMBZxcRP0lh1pVVLjZDAc5ixCFVllWACcWwpJLtJGNVccoQXkBW9HEaYaeIvjvPAyxgi/gbAMKs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aldxanV3dmgrNjhnQ1hnQmRzaTVvLy9JOGZlUW41SWl5WHlwOFZLWmZQaGdx?=
 =?utf-8?B?dXVIZEVvNlJxSU5UT0YxZmFxeDlhbW41M1Q5SmVlblpMUmxDSmpFeDR6U0l4?=
 =?utf-8?B?QTBiclJOcVlkaVRQVzdYdm5TOC9PcUdhdTdEVHhPSDBROE1hdUdIUWhudy9h?=
 =?utf-8?B?WEt3bmg2eHFZN3JZNDBJbWwwVTZ0Nzl4Ukt5eHFKQW1oV3RaWDBxRmU1RXVo?=
 =?utf-8?B?Y21NNm1OdG1xc09TZjBWOFVOeVFSV1NmeHcydkhGODBvQmN5bnVMU3NVNVQy?=
 =?utf-8?B?dTQ2NTcwU053UGw4SnRpSUVnbkRKQU83dGpiVjBaa3cwTjBvUlEwa0U1V0hJ?=
 =?utf-8?B?Z21mREdHT1ZlNTBCMXJpcWZXUENMWnFBUTdudGdpNFNIZ01vOUxQbng0R0JE?=
 =?utf-8?B?VHdoak1QblRnWHJuL3l0UEh4WjQvY1ZBbHZHTUhNcno2RVdRblREblZabjJl?=
 =?utf-8?B?dldSbVJ5UHBHR2YwRWpZMWtPRmdiUnBmM1Bpb2RzejV3QktVYnNZbFVPQ1hW?=
 =?utf-8?B?MmpONkFid3ZEb0hQbWtGUytQOFJKWlBRTFFER3NwalBkTGJVRHVFeEQ0SStY?=
 =?utf-8?B?ZnRmSzVSOVdtbkdSS0xXa2k3eUNGZzJ5OXdYTE1lbEV5T094ZDBobW41R2xQ?=
 =?utf-8?B?OHhpNm9UOFpxeTNRQXNFVmpWUnlSc2xwZ3E1dlFrRjllTnFLUnE4aURsWmJl?=
 =?utf-8?B?TVZuRHBGa2IxWUJHNHZORS9yYTlUTlBLMGhLbkFNS0RkbTMvamwxUkI3WDZN?=
 =?utf-8?B?dUlidkhVQmFrVmNzUEJEY0l1MTJKa1ZhYWVBUDVYVlpzams1djQ1UEFpbGkz?=
 =?utf-8?B?UUgyNzdoa1RiamVwR3dZT0czZUdQdmh3NGYvY3YzSjNJTW9FT2NZMURYODFj?=
 =?utf-8?B?cU40ZGlhLzJrWEJBRk1UVTlrekhYOEFUdWVFemVPcmNtN2twNWFHaytMam05?=
 =?utf-8?B?eHVPbzN2bUVrckFCejJobHlKWFpzVDhQVDFLemE3ejUxVFFVNlNBbm9WVm9I?=
 =?utf-8?B?azhMQUhSaU1YSGl4dXczNllobis2aU5uY2VBZTlESzE5MkNZditDdlRzRTNm?=
 =?utf-8?B?ZTdZSzFxdHlKditLMDBJRHpvM2labkx2bEs0M2VvOUFLU0ZTeElHU2hKcm13?=
 =?utf-8?B?cW00YjJsc1BYamtWUG9hT3lXOStaY2FmNzlyVXZML0M4b3QvVitYc2tPVk00?=
 =?utf-8?B?UTliZFliSTQrVEJQUE5SN1ZhM0REM2pGU0hSdXlkOXJZRlQ0UmhqOG1FWnZI?=
 =?utf-8?B?NWR0SHdXTVJQYloyQWdIMXpNNU96OEJoOGoxbzN6OXJWa1V0UDIwbHJYL1ls?=
 =?utf-8?B?SG90MCtuNXdpTTNUdFF3RW9TaXplVkJ4SmpueEtIOU8vTnU5NVNGMVM1WDJL?=
 =?utf-8?B?VHduMHorV0xnT0ZMNW5BZE5lZWRHUG1Yd3U3ckNTR3VLWFo1N0hhbHREQnVG?=
 =?utf-8?B?dzZDSWY3RytwWDFYQUZXeloxcVQwOE4yVlRwRG1Ram1OLzFTZGc5b2dzRFl1?=
 =?utf-8?B?aWsrMTZrUE1Rb3JNNmFvM0luMTIxUDJsYlRkSDVDeWFNRi8vNllXUGgyb2Ry?=
 =?utf-8?B?RzllNFlmbktYNzd6NWtYeVFnb0xvazViYlZFNzd2T1Y2V0lSNS91Y01sWHYy?=
 =?utf-8?B?Uk9MeC9OdkFhVlhsRnFaWk9tWXpuV2Z2a1lyNnI1bVNja2hpNFFNYi90VVQy?=
 =?utf-8?B?N25wTzU2MzExcDJIS0lUWi8vdWg5REhsdDc4MENkeG51aU1LZVJVcFBoYzNs?=
 =?utf-8?B?QjZ5MGhtclRiZ2o5OVhhR2RnTWs4djc1NHdka0FHMHF0SVpKektrMmlTTXRo?=
 =?utf-8?B?bDJ4dU8vS0lFdllDVko2QVZ6aGFGaUlvTGc0VVlTR0NmdGRtK2lTZUxhRWpN?=
 =?utf-8?B?WTFzeVJjYnByRGJaNm02U2RLczlVaVhGWmR0L2tPay9HQ0gza0dHb0c0dHZC?=
 =?utf-8?B?NHVROE84bEI3U2dmcnQwZkd4YSs4cERBOWhyaGlTTDk0VElZdHFmbmI3ZHdZ?=
 =?utf-8?B?V29SQVU1UVRyUzZsSFE3cWY5eXVyOXhLWWhGd21wRTdrbjVHUTZPNXh0dG1S?=
 =?utf-8?B?M2ZpUlNybEkwN0VFRHNVYThRRlR4dmZuUWI2RmxHV3VyRkpjN2tpQVNtNTBk?=
 =?utf-8?B?bjk2WTR3eDBjTCtYbUFPVUZrWS9ZVzBwM1dBR2Q5ZVlMZ0wvL2NYY2R6Zjhy?=
 =?utf-8?B?NmpubEdtZEdQWHNod3Y1d0JtRWwySHQ4S0VFSFhid2kwai9VRkF3K2EyS05M?=
 =?utf-8?B?S2RhcVMycllDM0xCcUF4V1JHb0FMSXNMUFB3bTgyb0Q1MEFnREVLVHpVdU9l?=
 =?utf-8?B?NG15Z2tkb0YvYVZtQzBmS3pUTy91aTBjNjhJek5meDlmZ1lPb29zTnZxeHdi?=
 =?utf-8?Q?4z2BbhuaV+G3QzuA=3D?=
X-Exchange-RoutingPolicyChecked:
	jrzxOeJvik6cim4CSfr96fTjVLw8MLJXQspZ3zxTQrhXCxaDowBm071SGged42SpAMFBgb+5KCdtCXghDZNGAqeqiu4JRCdo7GoM+N+yV1NxPuqN30pKmKuHZX1GcgBX97NtYoU4DRlEzmIAaNbcxmnmqGpVzs+gOvhxJwDDkfHmAkQYQfD6dnYcNb/Hf47MBTpPzaFewgEdRWPRzIWxldI/3e+3I9GNmB/jS44vdULMu50LXyjwS8ECNVeynoiwk2gz0G3zaSmxR2Zxiuoa/EqYMPBdvlvlc9cH8/pY3bUAE82hhO49UzwlsrmxoB+XJwfIqFBBxxsY7lzvag56qA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bhgx58m71V6nY1p8qszGIeslct8AeNfvR3/2gH4q+hpbvrdpyq3GDVusSZLIOBDyuHIcPjSqmwhzE0GhRs/aL6iqApfvSs7obvEdve9pioICESqSi8b98IkfqNsKRGA842OErO7eGxtGCisTrHO3WSZCovPkoIuDYxiE/A39ZFeoItAY2OmwuA2amBQpYbqpkFUdUiZccH/NWPFZ7Jpkko66oafVj61cDOXz+XU59BldtXpmkfY/nLQQFnU8NO2ur6ra4y08nymxsfHTspnQLjqIUBmwb+B5Xzz63It34u5XZjp8RlHJao/FLQTTvCgUyn9/phtsSNkxiEjj87bv/Pjk2dBHdaXOBAvsI9n/bcRa8E8zNqocog6lJHN9YPJ0KLzbfdB3+mvGXte0dchKz+7QmBza+eDeWMIsTYNsFES6J2us+EGFReYiOcy+K8ns3OwN93X5ehxR9bfXiVg3J95l6TGyyBJee2bBSQc3GxiPjZK1+VtGBzFCqi4lG/de8BP9+45DLGlglSwxXurmRj29ZSDEbcOIPhj1g4Erk0NJXsxTU+TEWzaDTE7X/hQ16w6iR2f4fyYcyRxP6/UW/+WgQYKF/b3IXaV+tB/NlxU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53bdd432-1795-4466-dfe5-08dedb774a66
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:57:33.1634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zH6nzuqiGjsw+WEfFGu5OBZl/5vR88g5Br2qveP5M3PR0oZcu7B40G1UBBwqoynzI/X+QB2vJtQeWdqQWzRsNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607060162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE2MiBTYWx0ZWRfX7TArJ0rlP7l4
 7e6/DUp5Uc6hFYa8TJruY4GpzP8nczEix5JneI+4pY6NyqjR9CgDWAhOuUI5YdYVXKAkz5kpoKu
 XLlYTNhSf0/WLgL1/oGWO0AkAmKa0VdkRce+uuER++KrXgGrgvIAaE3M9twm3G+TtsCIOp7Vduv
 OUcW+IC4L/wAzm4DNf9MMNHbsZ/GlUooaV5JfJUxoETHmRyenFlQUw+CPMwOq8LAE2YMqCOkXEW
 dc0bFC3n45KBBXSghsqgbdHwYtTUmD5ruiubxEsYKcfsAAKf2zBRqAgUV+5ImF5YFIHd5tNJHSg
 P4YjSkbTJlYAnMwJ4+9s+UdmEtUq3qFyqhOzAZvpHge0cCJpCQn0uWNt3HzjQvNL/oXmBPjd7Yy
 4C1yYOtgeATs38BQWSBzGH7dhxdj+MmGqVP/Myf3iHRtnaKMMFmGKqadOS4+Ixr0NTc/v13KCFe
 tq8wOyNw3m/5C1/Vnag==
X-Proofpoint-ORIG-GUID: Cev8Kz4KSaOrbM--8Mt3tR3UTlAQu-0g
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE2MiBTYWx0ZWRfX12Q7UhDAhVkl
 jib5oxiMDICLXb7uFjlV4hnXOx4ebuXs48oeNclL73eCv4LFRw43MJrgJYm2OT8SMEpXxQZ3SnY
 jz3WyN+SKeYwidNZQwawRcYtje2I4ikMPj/PNLMQogKQXlRgNSFC
X-Authority-Analysis: v=2.4 cv=fdmdDUQF c=1 sm=1 tr=0 ts=6a4bd08e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=1_ysvZdJ0aog_IP55M4A:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: Cev8Kz4KSaOrbM--8Mt3tR3UTlAQu-0g

On 03/07/2026 13:44, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Low] Build failure due to undefined function `mpath_numa_nodes_show`.
> 
> Pre-existing issues:
> - [Critical] Race condition during device removal leads to a Use-After-Free of `sd_mpath_disk`.
> --
> 
> commit 90ab5069ccf099a5f4cd42027fac637f7869d718
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi: sd: add mpath_numa_nodes dev attribute
> 
> Add an attribute to show multipath NUMA node per-path (scsi_disk).
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 0c77466f8291a..5e0514304d81f 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -4075,8 +4075,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
> 
> [Severity: Critical]
> This is a pre-existing issue, but does device removal race with sysfs reads
> and cause a Use-After-Free?
> 
> Looking at sd_remove(), sd_mpath_remove(sdkp) is called before del_gendisk(),
> which frees sd_mpath_disk but leaves the sysfs attributes active:
> 
> 	if (sdp->scsi_mpath_dev)
> 		sd_mpath_remove(sdkp);
> 
> 	scsi_autopm_get_device(sdkp->device);
> 
> 	device_del(&sdkp->disk_dev);
> 	del_gendisk(sdkp->disk);
> 
> If a local user concurrently reads the mpath_dev sysfs attribute, won't
> sd_mpath_dev_show() blindly dereference the freed sd_mpath_disk? Will the
> newly added attribute suffer from a similar lifecycle problem?

same as 15/17

> 
>>   
>> +static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct gendisk *gd = dev_to_disk(dev);
>> +	struct scsi_disk *sdkp = gd->private_data;
>> +	struct scsi_device *sdev = sdkp->device;
>> +	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +
>> +	return mpath_numa_nodes_show(mpath_device, buf);
> 
> [Severity: Low]
> Will this compile correctly? I couldn't find a declaration or definition for
> mpath_numa_nodes_show() anywhere. Could this lead to an implicit function
> declaration and a subsequent linker error?
> 
>> +}
>> +static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
>> +
>>   static struct attribute *sd_mpath_dev_attrs[] = {
>>   	&dev_attr_mpath_dev.attr,
>> +	&dev_attr_mpath_numa_nodes.attr,
>>   	NULL
>>   };
> 

