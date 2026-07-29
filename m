Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998EF47ECDF;
	Wed, 29 Jul 2026 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334318; cv=fail; b=sUMiuECYkcNd3rN5NgZa/zGvl3LpMhDuckVHT30McBqU03ho/ugUO1oZAmg7la0QSbaKAYD4QyHKN0mfKq/wrBUpAcw2adC3dCYUF4a3FvUaqh2a1gQBgWgD2Ah0mAImuYCcgGLWaIwqKSuhs6jhbJB0cUDw8AWl9aoCCiT3ZzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334318; c=relaxed/simple;
	bh=ALjah2qWqmawuPnbEI2Tz5fFivAwu+lbWkSxls1Gzrw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c31LvVpHn/ZEu1Wl+cuxVLvlFqLeyA/hbBMOH04X5H6s5lLN0qA/RHzkoMYCCPgCTgVfp1Ckiuk5i4/aCksfI/Gou6zFtmhQ8x6c0qzazVw0LyHX3Q/Hk73PK4ep5Pyzm/uDmLLrjWmJ7Sn8EMn3zEuphkhEJ+pIAq9ZCp8sKBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BqnNTvGv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YBX1ELxZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BqnNTvGv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YBX1ELxZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTRP13322801;
	Wed, 29 Jul 2026 14:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ib8UAkVzcq2w82KnLlmm5jV2E01Orig4sUdf13bMRSw=; b=
	BqnNTvGv5rUQrHewDWjbtLkgw15eaR5+KQbQvXxJduBII9DeZkGAA6CfVh0ulbYa
	ESQhJymOeQKIyoe5QA9UolyPjnodWMNfLUW/GFJHftJFSGqazOyV9PY6yjNhUZb8
	+ZYPQvQ0jJBVN5RMeBGEtPGO+O55qEf1IInX4E1fwN2eApZCMkNimWUBOyChYg7U
	X2wkt1Hq+/sZU0W/m+ASB/97vlN+QMCOOyLgK5wydbrzqI3g49XLnSkV/xxaiGsA
	PKb98VY9Dz+J7to4cUKJDTJ8gbi+xZAON6pNyc5tCWw8XqRBaJPoZXszYDEwX0yG
	0JexjkXtpP2XYvzcx1KR8w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0161ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 14:11:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TEAgb0010587;
	Wed, 29 Jul 2026 14:11:54 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6e1253-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 14:11:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wKDvmEyL+8dE2OCO5V8fbRSXLq7R7o0LSx0DSHuXQz3Cq61bt2tgOnUvNupUZNySMIrP4VsibIw2f6Izl3wjIR8pQzQ7eu+i7GhQlxQd+HXUCjvZ91m7SscC6rlUg0RTGxNq2ieuWU7oPXmGLhxvHvkD+9orJEvThPGMct7flJWK57zCWwj164B+jQ4bXEPPKpRcOgkQZNzmst8aBATEiq7khi5uqWnUFZrL1JremQk+lHW8+ptqyFws3FXZe0iP829PzTQHNrg2EgxHyJVfEb5nU4CN35LVwd6CCNR4PD/p+AFwZkzVCrf5EfDXm3n6iHUoTh3BvANvwaJaDlcNbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib8UAkVzcq2w82KnLlmm5jV2E01Orig4sUdf13bMRSw=;
 b=DGCX3m8HXJ2h+cEZXgpeQwJKPP4xxIxJQRfQHIAF1Fa8q/tDOJlXXp4nekKPHKZkjwmKxktHsYk4ssx9Hhv6wMPEw2aIlbQQTrICgMk4bgArTKZ5d/HFdX+H12qsIBdZ1yOiZZxMPqZ8RQhGI4tNeYA+JFQOHdoijX+KY65Q1s5F+hbHCRXwyXkKMbfiHofyWgfCo0nvTIPxDv65kuJKECILXkWbllAF94M5CJXnCvuu5GIx46/Vh6uE/SJTYOXGHJthigQvMxpWM681Q3WZ3Z3b6hOHP68JxWeq6N9emJ9nfLTw9Vj4ZZKpkGVLTsFOn5LufrAMw4bZJ/4r2PX9kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib8UAkVzcq2w82KnLlmm5jV2E01Orig4sUdf13bMRSw=;
 b=YBX1ELxZ7ECLrmD0ZoTlhL6UREOadNyIGcBinqhbNY6eZgv4MtXNoGwlzoMjvCrhJ1Y/7iTlxAY0zVg5fpvfaz8ZsKStJ95a3EgMW+RSk2b3jLr+uE1s8LCeJ9ok2Q5GepDjjratHqEYsxnsORVy0tqu0AMN23pLHJVY37+cIiY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM6PR10MB4266.namprd10.prod.outlook.com (2603:10b6:5:210::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 14:11:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 14:11:51 +0000
Message-ID: <fe2e44a5-a77f-49fd-9ae7-21370f14b22b@oracle.com>
Date: Wed, 29 Jul 2026 15:11:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/27] scsi-multipath: support iopolicy
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-15-john.g.garry@oracle.com>
 <20260729140733.162A61F00A3D@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729140733.162A61F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0366.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::11) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM6PR10MB4266:EE_
X-MS-Office365-Filtering-Correlation-Id: 470ee0c8-4187-4af6-81a7-08deed7b55a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|18002099003|22082099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ukj2j/YqbioZlx18Ljq4FbWg2TWcjmGh3hojWqUVKlErFu7SIYQDgesVmzcDDtEhR2PqfdNkVJ6IcDSKRK2WF66MpIL+YKFHuIvDEAgJosZt8Mf1c01y72ZSTEaQQFek1dmY8kLeYws5KAbmChOYA+aFgq1ul8kJzFjTtqOCEgTmJMBZFTDX0bUoXf2NUCoo5yNeQ/i1YCARWI/YU2TJrum3Le6jyJ3ktB0OBNC4TBCul301Rmhfc3CJS0VpHcqXhJkgJdn/dEMSJiVUu7b8B60NcqXtXRmlpb9zxD072pSSlRKnpYV4h2Ka4GCutVhZqI1EPJYGKln3MJ7REbvlGbjkrKNiK2CGazPytHaj1jvk7yPtlVPlKiAcx60DYe4rs3/GYPnX+gvFrduDWZY36kk3d8VJgRhTcylc9vsbk+ObiaAsU62EynIttEwBiXwHvBiquNxP/BaIAErfsHmEn6bSnluP1eNQCbVxa//XjMlyICbf/SLVCL/zhImU7YCkV2wsjrkYmLe9KgHit8QXf7bmEt916NWpjVvUOmg0aagnuZI2+ab1ExMMG/xJdmaCioBPEpjEmlVLz4CjNuxjKPX+/zX+Ld73qjww7lwRyFccKKr3/32crqS+YfXTARMNSDho15X3dxpGLkS37mfQSW9rLQJ/Ha0SPJju6dZhNm4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUNiajBsSExtT0NUWnY4RHQwTnVZV3pMaWhBTHlNMkhxcG81UXBiODhmbVhw?=
 =?utf-8?B?cXVQVndva0FkUFhjUjFVTmVlTVBOVXhUTUlDZXJDOGZkS1NoUzd1amZwSE9o?=
 =?utf-8?B?VVliMllzd1ZRalc0R1Fsa25VZVIzaFdML0dOekgwcm9aVFUrajMrS2pSYzFj?=
 =?utf-8?B?T0VOU2R5UFh6emt3c3AzNDl4ZnhSNTdNcW4xK2Z2cEtlZWs4ekJ2TzFNbFM4?=
 =?utf-8?B?OS9WcTljSkR2UzkrK3JycVlmWTRSeVFoM0phWTA4Qms2NnlEOFZXNVordmpl?=
 =?utf-8?B?TkI4MTZwU0k4SmZrUERlQzNPMm9LNGI1Yi9vYnNMSFN1SEg1S3gvR2dYQXRZ?=
 =?utf-8?B?akpEbk1DZURpRlJnWnRKc0d1U0FabFFteC9uQWlBeEhFZFJYMGpMUmlvZkNJ?=
 =?utf-8?B?Vmt5Q0kvUkk1QTZobEZWNTZiUlZla2VhclVmeFlGeWxXb2JIVEJKTXZCS0ZE?=
 =?utf-8?B?ajJNN0ZSSndRM2hjNjdDRjl4RzVEVjFhTjIwWGJDcTVaa1dzNGNYMnN0RnNv?=
 =?utf-8?B?RHJOeFpWZnFPamZvWU1vM25CcG1zUnFaWG91V3JXanc4MEY4dWo0bVp2cVMw?=
 =?utf-8?B?TDdFSDAwUlRGTlhQaDI4N1ZOWEV0dlFCZlFYOWVMUU9lUnM4cE5WRE56RnVp?=
 =?utf-8?B?VVZlR3lDYkVScTZnN3V1dEdHNEkrMDlUd3J0ZjFVQjd5UTFPRGJxemhFOEdv?=
 =?utf-8?B?Y0FwUzVFM0MwQ2pOM1VMOXBWTzFZbkFpNWxKOEVKZW1UZk5Vc21jeXNkbHRt?=
 =?utf-8?B?UTJndk9iM2hyZlRUKzNpR1ZEck54cnVEVDR4Qm1JcCtvTEdGZm96MGVOTGJY?=
 =?utf-8?B?R1N1czdXckVZTXFrT0J2Q204TGJZc3MwSkRRNk1ybjMwbzNBSVlsYmhkOE9i?=
 =?utf-8?B?djVBdVVLMjVHbEpZVHo4TFV5VnV5WEdCaVI5TWtFbVI0TGFNSDBkOThzL0sz?=
 =?utf-8?B?SlJMYURDMGI4ZHZYVFYxbjhjWUZ5VkUwWUlxNkxGRUorRHVnb0ZOV0tMb2Nn?=
 =?utf-8?B?SWdjOURkQ3Q4bld4bDg4NmVBZkdBZzUxd1dmcXZNVjRCUUNFVE50eXkzTzlj?=
 =?utf-8?B?UGpYL2ErYURKMUNkOUErS0J0SjhXZWZOcjZ2UWRMWWtmZk9XcURRSDVGY3Zh?=
 =?utf-8?B?a2MycWpHYnE3WkRVTWcyY2dxeWJDemRLU2ZQbVRxZTNKb25CM1A0cDRQeGFG?=
 =?utf-8?B?VFlRcDFPemtGQlhSVWdDbHZGREVKK3ZTeENaUDUwR1kwc3cxVG81MHRITDZU?=
 =?utf-8?B?c3ZaR3RNenB1d29hUFRSKzhXd0tLRUNKelJib1U3L1kyMklPNDM3QTluZHZx?=
 =?utf-8?B?cGN4cmhvK0xEdFlBN204a0VLSWFvYllLc2JNbHNXTVJKY3lUUTdrRTR3RTRO?=
 =?utf-8?B?d2VONzlpTDNkZTdLWXJoNldON3FiY1RyMzZyNGhMNW5JT2xuaEprVUdETWdP?=
 =?utf-8?B?VDVIRHBmNkVId2tWdW8xeEZsb3VOVk82V0Yvc2J5S3RvZGFEMk44eVYyZTNn?=
 =?utf-8?B?b0w4UVZkaE9wVVRXRzR2NzdaTjIvOGcvVDRXbnRDWjExVlFjeERtc2ZFOWxi?=
 =?utf-8?B?RkRNWnpWUENtWFkwN2JERUltR21mb2lkczJheTlXS1M2NitIbUo1ZDRwWDgr?=
 =?utf-8?B?ZWNpVkFzSzRMOG93UmEwYUFlYi9ETm5aazMvVnRPenFCRzZpM0owUkROc0pH?=
 =?utf-8?B?UWRvWmZja1JLM0ZMUk94MFczTGpBek5hRlU1eVBCWE8zUDRlZ0NGUXdING1Z?=
 =?utf-8?B?OUFRbm9XNkRCcUJCdTdjT2VOWll4UDk2UjNTRVd4RkxlQmZrQTcwUVhlM3dW?=
 =?utf-8?B?YjdPQUVQU1ovZ01JNzRDWVVMMnhaMjFXYndad1g3SnkzL1FlSldLbUVtaFdv?=
 =?utf-8?B?cmZJME13Tm1MaHh3SGtGZ3EvWjcyMUtWYUowRFRISHg3ZE1EdmpsZ1MvTjJh?=
 =?utf-8?B?MG42T2x2Z3FYREQ3YkJTUVMza1JZR2owcm42TW9ydGIveGhncFFwemdlZHda?=
 =?utf-8?B?aFp4UkRIb1lWWUFrUVhMRlgxbDc5K3NUdUtLdCtBQlJUeG5yUmRLQnE0MlRG?=
 =?utf-8?B?UW90b2k3TFlrK0VnSUR5OTVjdnJWelRwR0pCbEY2WHFPU3JTeVBGSDRvOVl3?=
 =?utf-8?B?Nm45MzJDWGkyYllmRXMwTjVTdEVBK3NYbklCWmN3bWdsVFhTdTB2bVpScVRX?=
 =?utf-8?B?MEFFZUE0U1pNNkFFeVFmYVFLMWxGRmlPUTF4QUFnSjBsdi9ja0hEeTByTzly?=
 =?utf-8?B?YVoyNEFhOHFWRGhrMDh6VVRRY0R0V3Rkd3lRaG5xQ28zczd6NnVNM2R5UEhi?=
 =?utf-8?B?b0JhWHliVFNkSDNnYi9Bd2E5QVhaU0h2M1hTZXNXN2w0dHZ2THZnV2w5Nk5D?=
 =?utf-8?Q?KNQX58FwLutcLG1c=3D?=
X-Exchange-RoutingPolicyChecked:
	CphkLIX2y2nWDV3VRgEewoGaRTMdAel0QOm9Lnmt+DHacg2irRsU+npnKEDbNaWogOVeaTeXAFvDDkQkFs7jQiXEUBvQegchvBGKV+h+lfhmRthinCELRv1F9D0jE4eKnsjczZAUAi24IunFlRgZzM/WW1uJhCAzOEQIJtHxYa1U/iv/ckgnHkOYHUW3K7ixMDLJweuRnv0qJgY+O5h91cZUygIwV0elwc7uQCiWVCo7t6vBqyrTl7o6C8uhVcDqF/gXRhmaHOwK+/XTqcvw7gsAD0V4ilxvjWDb2F3AeW/BMxl0ti43F3j0c7HX7MOtWdU8XjgJrlnFrFyCfjIMlg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2ajyGW7jyDU4+GiArEaIkWKZFnOlFPw/mY2nW9U9qrAQAqxTHVk+2TFli3/cpdNcw533syRhVBcvGOF9EwKI28rTDecznD7pRGWpaJyKgUvcCbHEk6xAUAzEO+B0wwOaplhHayHHex1RPcb9v+PZam8JUDKIBUaNO9ydTYgxzC8pY4H5OUYHh2lVydz/C9mCI7N3XDBS647/AucaHR9+jv1xYTNTua9XSEqhnVitzSCGlB84C+HMuaZuc6kBcKqwJMeHipnXV8djwT37Zdd+kRu+WE2wMTEwwPqjNUTKaq88t4RhT9pDzq758u2PxpE2LJjrUQgRKnKoOIdkxKY8IU9Cbyt0wmh3D7y6nC+yDrSjutUMwgqSC7nV6wue8TVzDkhaExYAt69sE2r+sFNj8KHVY0ICfNtjrrlIGJOQ0ouBJhlfdLUdGL0UX6TDW/T5S2Acjo+1UqWJv20V2eRtnsIUavj0EMrgIXOnancqV3UBu6VRpXySOt8v8wVFOlLExupnA6AbeRh1KGNaRj8kdQ1yzVUrgOldv4DYUH6bkQ/DqBm/Jb8C2WRabegd3dwtYbCpyxVVoh7WGS1vSEMRbWgjiilmRIEGj+/fhVp2szs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 470ee0c8-4187-4af6-81a7-08deed7b55a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 14:11:50.9309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5OuCLW8fsN6cgL7pf3FXov7mqZEl0/sv8wdstoy3NhxE9Ni8G42OPz3l7U9WtFYol9CUCcIvWV6dAiPYZZnkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_05,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290116
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDExNiBTYWx0ZWRfX7yQT9hfncQ00
 HzptzvAAGApjKgJif0SmSpNlu9MHh+8kSahD7fDjTolsM98TQWXFjF8SNOVD7bDKvTLTtrZFNNi
 3GyzH3CnmBv/daG7jEWLfJvCRyoDPBySCwuSpHvm2s+voyizt+nq
X-Proofpoint-GUID: RVVxJpCe-SMNDutO6e9NHyxkcm6CVfC3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDExNiBTYWx0ZWRfX0v+E17WyhpSm
 aBruldn9z3h1xWUCo5Wo/aWsp2ScFyoIfQdn7z/VYdx2XofKW5/qLvoMveBurfrz/u/DfiyoU4Y
 DAz/y2xeX75bNThhrn2fnE7cwNxsx7MENuONZ+Yu21tND9SBhXEww++hPAdIyHH9QkaoioDzCzH
 g+lkgwPfMgcu/dA76luUrSW+NFdPiwcGfVZkvWeUi2cIt/oDWNS7uehozsmYmx8OgwxV2Evcgow
 WvTlZ7Hh7qr0UwxVbPQOngYTDOc4b00sWV0AWcmPiRCVk319FUyooPvHXIV7HU7wzUQacj85VLm
 +hyosmP0WYGxCZZPvMHNxcGNMN0/K6k3r7ZsgSuexJbb2g2F/5Koph9odR1S4sAxsO8JMmW3Oll
 tqMFJ60VCuRjH/SMPQ748ESPg+LzwiC/zUL31QzU1XuI6s98WEnYbQYtOcJmYMVf1QHoRudeTed
 U/9aEkUFgu4fNQDOphiXcauGuNb2qwCLUV0Y4SV0=
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a6a0a2b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=LEZjX5lkH713GuRjnFsA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: RVVxJpCe-SMNDutO6e9NHyxkcm6CVfC3

On 29/07/2026 15:07, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] The struct mpath_head_template 'smpdt' is entirely empty, lacking implementations for logically required callbacks, leading to NULL pointer dereferences.
> - [Low] Missing READ_ONCE() when reading the global `iopolicy` variable, leading to a data race.
> --
> 
> --- Patch [14]: [PATCH v6 14/27] scsi-multipath: support iopolicy ---
> commit f1795dc3e5eb8bb57ed7783aab4a6563ae5c3b62
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: support iopolicy
> 
> Add support to set the multipath iopolicy. The iopolicy member is per
> scsi_mpath_head structure, and a module param is added so that the default
> iopolicy may be set.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 1ec7bf1835de0..593f94aac70e9 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_ops = {
>>   module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
>>   MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
>>   
>> +static enum mpath_iopolicy_e iopolicy = MPATH_IOPOLICY_NUMA;
>> +
>> +static int scsi_mpath_set_iopolicy_param(const char *val, const struct kernel_param *kp)
>> +{
>> +	return mpath_set_iopolicy(val, &iopolicy);
>> +}
>> +
>> +static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_param *kp)
>> +{
>> +	return mpath_get_iopolicy(buf, iopolicy);
> 
> [Severity: Low]
> Is a READ_ONCE() missing here when reading the global iopolicy variable?
> 
> mpath_set_iopolicy() updates the variable using WRITE_ONCE(). Concurrent
> reads here could lead to a data race and trigger KCSAN warnings.
> 
>> +}
>> +
>> +module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
>> +		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
>> +MODULE_PARM_DESC(multipath_iopolicy,
>> +	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queue-depth'");
>> +
> 
> [ ... ]
> 
>> @@ -204,6 +254,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
>>   	if (mpath_head_init(&scsi_mpath_head->mpath_head))
>>   		goto out_free;
>>   	scsi_mpath_head->mpath_head.mpdt = &smpdt;
> 
> [Severity: Critical]
> Since the scsi_mpath_head is initialized with smpdt here, and smpdt appears
> to be an empty template, could this lead to NULL pointer dereferences in the
> core multipath library?
> 

It is filled in later. And that is not even related to this patch.

> drivers/scsi/scsi_multipath.c:
> static struct mpath_head_template smpdt = {
> };
> 
> The core code unconditionally dereferences these callbacks. For example, during
> path validation:
> 
> lib/multipath.c:mpath_path_is_disabled() {
>      ...
>      return mpath_head->mpdt->is_disabled(mpath_device);
> }
> 
>> +	scsi_mpath_head->iopolicy = iopolicy;
> 
> [Severity: Low]
> Would it be better to also use READ_ONCE() here when reading the global
> iopolicy variable during initialization?

This won't make a difference, as iopolicy is only written once at module 
init time.

> 
>> +	scsi_mpath_head->mpath_head.iopolicy = &scsi_mpath_head->iopolicy;
>>   
>>   	strscpy(scsi_mpath_head->vpd_id, vpd_id,
>>   		SCSI_MPATH_DEVICE_ID_LEN);
> 

