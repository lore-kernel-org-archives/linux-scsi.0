Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43E43E63AC;
	Mon,  6 Jul 2026 15:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783352995; cv=fail; b=aDq/q3HZRxZ1Ge9ipPZdjCRBKfIf2+5UkTzgkterR/nq7GFioQtbiJdb9bDgsRTymEdybpnrwiYZQjMfAWNOHyRiC7e273XfghZJ836HJI/TaxyMleTNc9EmNw16UHadFFEuQa38yuMHen9o8nwjxdtV3BnRxPzrxb5Xi5LriGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783352995; c=relaxed/simple;
	bh=bckGMVTcwhbCRDhfCMdVca4Qn9yalUHaGGvHDERFUYU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZxloJeVuan6HULA1aFTbV+JVHfon/p1NNSvgMZ/Ugb8urYmZIfgqz1GvTZxNfkteS7sc2wTVpYbAGk3+/H/UBqW5CF3vJwXh5HBS1VpDkGFsJgFb8FomL/2oclyam9jtSlAwLTK6utak85LMNn3vPx+vaSIhrxZj5BBkO91nm6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fdUqVZU9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Jl1GKfSD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fdUqVZU9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jl1GKfSD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666EwkDF1258442;
	Mon, 6 Jul 2026 15:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=k4c6qzBnTT5Ox7agh4yHyy13wcuoPhGftinnl0XbrsY=; b=
	fdUqVZU9fwXsZBiLA969Mue5OTmzN2CmFKAhLsRxDRQLodR1lwUK2zTTHb84TO8G
	+gQzQo2yPzZm2T7paxB+LrKNs9Yct7YGufTpE06O73o6Wl6ypWVZD/VLwcvCwhUH
	ZYIC1OeR8x5TmBp1nMC0SLBleRrQOWZUgyCqlKeUkrchxMy9KJX2Q/PbMTJ87fWR
	uOfdDOXi0y589oFf0ChLQ2n/cX70+agpcBxZtaCmvMuChGjXjo52JTsT6muDdh5f
	KZJQIh1PvxRj+jwWgLZWAoHaKq/aV82B9PVnhpa1nDHi42BsxAheMf9etWh0MNns
	klISVpOGQEoi7S/aTWoIEg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f6t2a3ufn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:49:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 666FmYIh000839;
	Mon, 6 Jul 2026 15:49:51 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f6rmpa4nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 06 Jul 2026 15:49:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e0N6UJ3/S4vDCW5hkDv7DjcerVUXMTgFqbij6+YGZ6EMsKvgcQrKBHwUB4sG/t+MZAk/kdW7jFiNhbaSi5DS9TrTsn55Q5AYXyV8JzaSkIxqoyELt1lcfSI/FPoFVNTXuiAixXhR2VRD3YuRJ02/i+HFzY6jETXFdYSk+BQKS1E37OjPp9b1SVof2H8WHdQiCvNkJQ250Q4PFpDLnmOcBL4S/J6jziERE4uBBX49SC9x8LRNx4rZ9dVUjFjjf/p44qA6txSXeMl42iqVoDYAYkQgkA2DD1lrk1AQjIyPva45ba2fZMIb5ac1lNQ4B4c5ZRH0J+rlqVba2QveKurd1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4c6qzBnTT5Ox7agh4yHyy13wcuoPhGftinnl0XbrsY=;
 b=LbBp94/0aVO66EWAuQWS4lgcfYKltXIcvjD8DWLNbI9wTIm6fThiJm07nByQfpmrz6URm0mG/mpus24EQ7ygFXBj7OSCemsXPkkRtlQ87d24oJvkSA7g0R9VmO7Ku+JxFyV56VWbRDsCNiRo0qAGxXZKTZrUUUaTEsJC9eAyQM1RNcCnJb7FyP89DkrMEcptCz6shAk7o3mnVd2eyDcekPRLpuQx45IFr9pXQfxmt5h4+/tKJRpABbNCONt/Izcil/mjgar97NUgZzPFojVJjzVymcb9cgQt9el/bQXeUF1Ojh9qORAAsLq/X8xtMRzZtSuAhUqjIYkoPbJ3p6OELg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4c6qzBnTT5Ox7agh4yHyy13wcuoPhGftinnl0XbrsY=;
 b=Jl1GKfSDcHAgrsKjdLaURn9f5gGSZiuTcaZ7NdFXPmZnKM8T0ohXHiKu2wI3tRVRyj24IrIPCclvbk/iPtvG7mlbEn5nYHvnut2ViH5R066VS7hbXyUlMnbWIW7XESU0/MikgzRQRoB9kxnALij/r91Fn8Rk2s9nRuw82kNoW4I=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH8PR10MB997931.namprd10.prod.outlook.com (2603:10b6:510:3d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 15:49:49 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 15:49:49 +0000
Message-ID: <8af747eb-634b-40b3-a41d-853891581e21@oracle.com>
Date: Mon, 6 Jul 2026 16:49:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/17] scsi-multipath: add delayed disk removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-12-john.g.garry@oracle.com>
 <20260703120837.6C6661F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703120837.6C6661F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0074.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH8PR10MB997931:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9e89fe-8a79-4cf6-8ca3-08dedb7635c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|18002099003|22082099003|56012099006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	YnRq0IsgAJ8F0VmUIDjORmCB5l/UC2HztkcJFkRa+TWZJ+y3vxlmYLpifqIFA7n4kn/gtV0lOh4YrSlZ+QYkzJ43gfkx7ha66AYi/0DAGCMmuCQ22M0iEgi70Wnt0FSciyvc2LYhZy5jNzIbctfD5OedltSMLtZqdLJQVgfa5JUswiSb7g+MCHqsKWaNDAYAU1pI3UeMC9JQgVU6DtCczksceETCjCimnQtPJa5OxH5dFbc0bCHYRoD7cvaYUsG2b1vAtbI2geYVrTJ+BrNIuzkB2TW4SkH/gauS22yJYhWcHtprCCGTbNG9eHsO36TdML2WoZd3ZIMicDC0+Uot/MOeEUcNP/18X/TOPlBc4KcUm1zcXCg+1HzXvFqzTXVAeoHjqWY3T1HAbjlhz0shBOjWqoyDUASFnzrLACfSTVrjbV2duOoccW8dJWOPZaa1jpFnVDUCqV9zpNfGWdjXN7yAZGALgwd3RGCmVrf4kIOsBATtZfGmUwZVgbHE5Bx3zdiPv/1m6Y6uC0Jhl6A+lTFui6yl2Uv0IfleR/6UYmfCxyNThEcYkqycvEPvX/EqyclS9CdehiBRbswJIY0FhstSDeDhfgVmK+Mnat261CyAT4+qgzOI16tlf55h201GiF6tGqCb+gFpWwjXX01Yv0Bo/ONCY0/3Tzr78oHzxDQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0thVlp6MHVPY3Rlb0FrRzdzUm1kOVIrQXczWURkSXlTMVFTWll4c3BtTWFO?=
 =?utf-8?B?cEZwMDVjM2djczFiOEtFM2w3aE51MjJkR2laaklEcmpXZC9XZXpnVXNQUDJm?=
 =?utf-8?B?M1VEdEtYV2h1MCtOVEpDcHB1MW9ra2hFbnVaeHZMQmFwTkZrZHR6a1ZBME8v?=
 =?utf-8?B?eUNTYUU0WG9TenVEMDFuZ0k1ZEpmZER4TGFza3B6MWtnT2RNNVJEWFBHRVlR?=
 =?utf-8?B?ekVrTG5DY3dNQ0s3WkxSVjhpR3g1aFltcjF5Y2NybzZadUwxaUQ2MTU2RXpr?=
 =?utf-8?B?dkVlM0dYU2JYRTkrUmMvbC9SVTZsdktBcTZQQXNxT2lBek1USnBJYmF6UVVW?=
 =?utf-8?B?ODlvSWxIYU44MlpFLzNlOElPaDJLeVFKK25QSFBsODJPTHBCRFlNYnQ2WGc5?=
 =?utf-8?B?Tk56alN6bVpBaWVrckVFTFprK1dtWENwK2luMTN6ZGp2WE16Z0J4QzhCZ00z?=
 =?utf-8?B?QStVZjVaRVJ5cHRtTGNRaTVWZVJnQ1pkQWd3YlpBRHVHWTc2cVA5U2poSDhW?=
 =?utf-8?B?T00rYkhwemJJMVExWHV5b1E4NDRUMzYrejZXRENUM0hwbnhJVHdMMWVhZHpi?=
 =?utf-8?B?THpDU3BYcWpZbXhDSFlvN05XODhSYzUwUWdKVHQxY0VUYVZ0VGIxemp0YUtM?=
 =?utf-8?B?enczK1UvUGF2TFFqVTU1QWZMTVJ5cDZ2NHlFQXpuYktYU25wTjZUbzRtczFm?=
 =?utf-8?B?bnZzS1YvQ0lyRVpWNnZqdU5YNjhtWmZrUlRHb20wbUpRd0F3MjEzRkthcDRj?=
 =?utf-8?B?TjVQR0RjWEhaMXNVYTZ6aVRCczV4Tm9VR0dGeks5YnhpMEpaZVg0VFAvNUNO?=
 =?utf-8?B?QTU4bndTL3RPU1R3dDd4MjJHeFN2bGZLMkZNeHBKeWhCNjdmc3NXTkwwbHB6?=
 =?utf-8?B?djRjOWc5TWJIL3VlNWpaUCtnVUczOFMyWVZuWTFTK0k5S3R3ak50bWx6bUhG?=
 =?utf-8?B?bDcwQmhqNDVnNHRGZVdBc1dWUEVsL012WVYxL2JRUkJQKzZpekFpeGhGUzhH?=
 =?utf-8?B?QTJsbU45VmwyUytCQytTZEtaUXRONVlIUU9LMFA4SmExbEpQUUV6Z01Hc2ti?=
 =?utf-8?B?S3FQamVZZ1BPeWU4ZEdrNmw5SSsva1YrbmZwTVpUS1FheXRXM24xWjlhWXlC?=
 =?utf-8?B?aVJQZjRpVnFnOFgreHBlWmthRU1UMVFoM3FHWDhTbFR1Y2ladVpPSFB1WFQ2?=
 =?utf-8?B?eVp2RVFlU1RTQUtDOWxDWjRBYnpybGM3MVN3eHRiSkNsN0ttWHdhbzRGNUJN?=
 =?utf-8?B?VUdFelVZNHc5ZDJCZXZwcTFWaUIycjJ5d2cxK05KM04vU3pvNnJCaXRRNWdi?=
 =?utf-8?B?UEVHZjFoT1RrSlZyT095Z2JuRGl1NVhQY0w4NUN1dkN5Um5SK0JVRHgrZzBi?=
 =?utf-8?B?SXk2TVA1Q0tPOVpNc3F5UStqVUE1cHBWUnZ3SDVXa2dUdkJ3RnpFYVJKeTBu?=
 =?utf-8?B?SnRNUEIyYy9ZdTd0SHc5UlduaUwrWEUwMmZrN3J3MnJCNjY5dWJJQkJoMFVn?=
 =?utf-8?B?Vld3alRmS3gxd2k0M29YMHQvYUdSdDkxU1BseFFRV2VzdTM4SFgxV1diL0Jt?=
 =?utf-8?B?WFJrOVphRm9nWVY5c010SkhIUlVwU1NwS2FPRWdiVFQvVWpaWFVPNHo5YjlW?=
 =?utf-8?B?cENISlA0Y0M2L3ZxVTIxR2ppRnZybTcyak5td1R2d0JPcytKY0hxem5jRzJY?=
 =?utf-8?B?c3g1MWRsTWY1YUxqUlFaQllSRUViK0tpRHVRdy9MM2pkRTg1Ykw3NXRldERV?=
 =?utf-8?B?ZDdZWkR3d0NKQW5uVmEwdnE0TnZwWlU4a2p5NFNFNlBkamcxdFQyZU1JYXpy?=
 =?utf-8?B?eDRIVTArUHBGVEtTRTNEV0dhUWVYWmxtN0lab056VHIyWUNDYVB3K3lvRlVU?=
 =?utf-8?B?dUJJd0JXVGdxWXlaNDRTMjhVNTV0WGxIdk5TTHhKMFR6NEcvSkcwdTZDTFIv?=
 =?utf-8?B?N0pGT3RZMjZ2NUJxRnVneFp3ejl6SXdXajdROWRXR2k4b2hhTWlHN0VvTjVx?=
 =?utf-8?B?Mllnd0RUMzNOYjVCR01YNFJHd0QyT1N2aFVoV25iOFlPOU8zZDNVelBnUjNW?=
 =?utf-8?B?Rjk2bm9CTWtUVUI2OTFBbWxncnZPbm5nb2lEZ0JKdjNEN21HcmhuWXA1ZSts?=
 =?utf-8?B?bENOMnhBVlZYdC9TSmdjb2JLUm1MbU1wbGcrcFJsSmFTcG1icDVOTFVXZjFG?=
 =?utf-8?B?QWQyYjNvYitnQmh0aWhrZHFEbTQ4aThQOTk0bFJmcEpVbTdreWoxdlVydlM1?=
 =?utf-8?B?Q0k2Z3ZEbDIrc1hMdkRud0ZYNkczS3ZiOVROdTJLcVkzTWNXdThPNS9hd1JV?=
 =?utf-8?B?VlRUNE1oVFFUenBOYjZsSUUwSFZWRnFpcDdqUDlKc0Y2SXFLdUF2MXJRYlAw?=
 =?utf-8?Q?Ak4u27YyiOFwQwBY=3D?=
X-Exchange-RoutingPolicyChecked:
	CJjiTkRodY7ZNyUjisKNOBB9opodCdERL2Br3HxBdJLIlOeqmHS9fag9BJAZ/Pjwg69G98tzS8W/8Rq6KTKKgDfZDViW8zPKKOjt5slhZ5HXJij/8mHcD4/RL9/Fs9fn7vwceIhKY5A9+2jaWbJ0sKqwdKu6i5JdOyhEMjC7Uvcp5Gv/1wRlAQgkjgYui1kb9ygAIipjE4K5l7uaZPQd/fFpsWwNL/meqAqmTSzCZfj7ASlYi8euguV/2j+C+kIlSG+VVzGL6/mnMTu340noXpvxfxWUfOJrbTeUT5Yj5g3jHBTnboOize0eEnTaafy9rRpTLYsoXZX4FwjH4ooJBQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i/DK0L6lskjEz6z5TBqk9p4HoiEbhPMIf1bXXYDxSMdymfVr2CIUdOxVhpRMmuk8PLU0igmqA9neLlu6aWUVzDRZuaIBMcENMTLUgWAHCpCdXgWoJI0tR6lCz0J+fyJj5kd8P3vf2fa+ROOjWsAhVJympAyfJmraQXLPYTAqX6KHi8SU6QtiX1pV7IQk1GR2m3BTxyN0X4ky/f5AH+Oe1J9UBD5QYwDTJ1uFVFQhCIroRAcLHMcOdCvzU9xgYTD8gkQG13FwGPlk1RNMzO3skF7JGggLwlVDyQbdRf20ttWl9T7v0a9NGa3pgt7dCpyKvW3vAdtflm2iu+ItEaER3ULyp1GMl6MpoGRgvV4oDCjBaKBcfAVeedcoP8Ns1t4rYqmMtim6kmt+XRNrlQjGZLD8j/bvBJ8GuExWqhNCL318j4xpyKfT67c8F8B4sitCnKevNvgXlyOfHEhPnDslVjbrNz/++YjydizMeSP9eJZQ/gZs6FfmKElKRvjKbXJOtjxmAiX4zENGFh9uXyzg7+v/mDJ4kf6KdZ5gQJgReH6yNWCI74gUAZoU0Az7Yh6AUEIM+HZ0I6IHtmilirmamihuHQ2SByggllAsOfyCfps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9e89fe-8a79-4cf6-8ca3-08dedb7635c4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 15:49:49.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/vkJpC/8F//yrJpXeOPXyLQab/XO22oiMX3ayE1GFwSqT+nlxhRFkDfYG/7qkqGmGD65oKNwjwMzYa1aSKc/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997931
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607060161
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE2MCBTYWx0ZWRfX2Vo5Nj336jCk
 RKRGuBHCi9MfRipunq72cTDG8C59HN3eMU6mOibqBops+7dvSbTQHjZ/i0kJpnkvsI5ypbD784A
 P8qMLVcz3FW+t37J4aNFoCDahHC7lk8LnHj7iTK9C8lyxagzSqFMIlvBv3SfWoPZKqmXNgCVIA7
 0HXEQvJoVBjjUIMeUBS/dQ3U20srXKSp9BHuEWok5ZH+9w7AmvzMPhp0gk2qkz1eietaon96/MU
 V8rHKpEWDkukInAx8GTumVY7C7DhlC5YGDRIg7zxTBvp6Hq/e58bG7vEv6Yj3BrEFt6CRJ/Y1U5
 dBEgizTLohxJfoZXH31ehgkTLXFfXmvvxi9SCM0RoC3JRY5915glp3H8bA/oYozdhx4PZpYYzpl
 UVE61nzthHb2klxBfYjG62q4AVCYdJ9qvBYT36/H19dDI1oTpilyUPEMXgPe9LQpBoqKpVVFj0u
 nFfvRpx1qABvqcCdmuJ6JgVcgycKvdGP0EOaHGcU=
X-Proofpoint-ORIG-GUID: BI5qJKdvXEMnvXtrKEgw-MsiErNDEe2N
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE2MCBTYWx0ZWRfX93EoPR1SU3jM
 tghEHq7Q2/KbKiN385Nf+Zk5oL5sM+MdpHR3LQPxnOJaYSU59m3ZMIvXV9ImmzbMLFBkPgxR48H
 oVi9gYjM8bna1jYGR8JXWxROmDNqokpvKZkKE/T23hARX+kds4WJ
X-Authority-Analysis: v=2.4 cv=fdmdDUQF c=1 sm=1 tr=0 ts=6a4bcea1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=m4bCsaS2NxWQmZtdMUYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-GUID: BI5qJKdvXEMnvXtrKEgw-MsiErNDEe2N

On 03/07/2026 13:08, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Memory leak during module unload due to flawed bus driver broadcast for delayed removal.
> - [Medium] Use-After-Free (UAF) hazard during SCSI driver iteration because the iterator continues after the structure is freed.
> --
> 
> commit b2a49437af44776426456e634c1ad321526ae49c
> Author: John Garry <john.g.garry@oracle.com>
> scsi-multipath: add delayed disk removal support
> 
> This commit adds core support for delayed disk removal in SCSI multipath.
> It introduces a new scsi_driver callback to handle the removal work,
> ensuring that the driver maintains a reference to the multipath device while
> active.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -355,7 +355,25 @@ static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
>> +static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *data)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head = data;
>> +	struct scsi_driver *scsi_driver = to_scsi_driver(drv);
>> +
>> +	if (scsi_driver->mpath_remove_head)
>> +		scsi_driver->mpath_remove_head(scsi_mpath_head);
>> +
>> +	return 0;
> 
> [Severity: Medium]
> Is there a potential use-after-free hazard during the bus iteration here?
> 
> When a device hot-unplug triggers delayed head removal, the sd driver will
> process it and drop the final reference to the scsi_mpath_head structure,
> freeing it.

scsi_mpath_head should can or should not be free at that point.

> 
> Because this iterator callback unconditionally returns 0, bus_for_each_drv()
> will continue iterating through other registered SCSI drivers (like sr).
> 
> Could this result in passing a freed scsi_mpath_head pointer to subsequent
> drivers in the iteration? Should the iteration abort once the target driver
> successfully handles the removal?
> 
>> +}
>> +
>> +static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
>> +{
>> +	bus_for_each_drv(&scsi_bus_type, NULL, to_scsi_mpath_head(mpath_head),
>> +		scsi_mpath_remove_head_drv);
> 
> [Severity: High]
> Can this leak memory during module unload?
> 
> When the sd module is unloaded, driver_unregister() calls bus_remove_driver(),
> which removes the driver from the bus's klist_drivers list before calling
> driver_detach() to unbind devices.
> 
> If detaching the devices triggers a delayed removal of the multipath head,
> this workqueue executes and attempts to find the responsible driver by
> broadcasting to all drivers on scsi_bus_type. Since the sd driver was already
> removed from the bus list, the iterator fails to find it.
> 
> Does this cause the targeted mpath_remove_head callback to be missed,
> permanently leaking the scsi_mpath_head and sd_mpath_disk structures?

if the sd driver is remove, then the  scsi_mpath_head and sd_mpath_disk 
must be dropped via normal unloading paths

> 
>> +}
> 

