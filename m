Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A0374735;
	Mon, 16 Mar 2026 09:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773653135; cv=fail; b=DhtrGsBxWQwl4ryqxnUeRxnTZufIp+6INvAA2pjrazRWbs5VmkRdgglLbyGJvJ85/ivqzpTX9swXn6K25f/uZLrAiIkdUYdEp2Ru8kr/+epizWyU0nApojssReu6acYBPzeO8d/o1GcQ4vxo9+GX0z62TxxefKWD59g4ujXmXcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773653135; c=relaxed/simple;
	bh=OIiztS+GU/3692Hz5BXXfVugkSLGa8HiS58BXMZJAhE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aQ+8CQDey58gnLifKMf1rRYTvI5mzvFCUJt+zxZRbpOSwWBA9RLqxB6I/Zb0p6d4Avf/KiyOASgfjKyWRJitQ7GGzwpwkpTko3bnGsOXFEnIW6t4XIb2LlChSYCb/6c7K2ZFixRWrckmCjez2B1pA5VlJb5vHGgxT7Yq/zEPaqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CKdxP0ij; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cu7btDES; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CKdxP0ij";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cu7btDES"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0Q0i61347797;
	Mon, 16 Mar 2026 09:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+U9/tUfItyDKXP2PNSJyX6iFm1KmDo6rUNHWQQQL5o0=; b=
	CKdxP0ijCs75OIiqw30eoApedD2+quj0dpRuukQc+W8zZZQn6zlAsA/+a6X37Pjq
	Tkc+fwbCPGf08AMw6W+ys0FgSw5JFHbv5yy2pmebEw+R9Rh7PxqkxYQHuy0T/JFJ
	pduLP2LdPRrq4M48h/lot54uratx7b7aO6bs9ePl1CK8ryj/4MBY/0QZzG0wYdmf
	f+NcP1ihFX0IkDDISyBwp7ny96fKszHe7rjkL0bQgOq5jN/OTPLduN62EV8by+eI
	Go49B6F/gDmYq1gcMjZudX36MZ6d3a7gzpqI6kgfZoTxhyQYdiYB70nwqHY94y+C
	7cM+9pfg0UfJ9RfVnOx+Lg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx3b1vb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 09:25:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G77haA030802;
	Mon, 16 Mar 2026 09:25:13 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012071.outbound.protection.outlook.com [52.101.48.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx48bbn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 09:25:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WS5b3Cr2TBgDrgi/FK+7Eqbk4ibtkeTap0au95iJvNzjawL4KvmyePxpXLcElGZZ439+6brSwhs5rmzqCXMDgAWYuhi/F4TBu/uUCE1onPlBlnKDV1wYTodw4bSouARzLa6bc+7xPvqX/au5+HldIkf9eFxhsqna8kQRrfVgdp9PTRThEmhGXj3zLxACtufbouVj8kJEvl3g92bsIBVw7PJVqJifLInutqDwpQT349q/ZVVaoi+gaVInnBGUFG7vHVCgVeLlYvo9obO4C/vkNLbPUQzoHPxvuoPdWp1oaL/ZhNdqAdITMRk8388wdQ4zh0miLYdIJ0c77a4a6rStiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+U9/tUfItyDKXP2PNSJyX6iFm1KmDo6rUNHWQQQL5o0=;
 b=IO0psrtHpa7IYj4IwKOIHLQDP3+WhJ54ZG0g5Q3vZ6fXM0LiJEZgLLyuLOWpe+Yl7gMHV2esZlHh4P5ksR+nXlnx/sJFsS5ki0Aqc+8W7ARiGp79rbmcJqrgvEO+LFRJK98uZf8hsKqTTm9U0sChDuwBdnDSniTmcNL86iht5faRsKhk+k8bq9hu+natBdn6fHqZV3oHgef0rTfpfecZxH57JLOTa61kg7+4iR1PfeiEHPvdgjuSytetR46dIwCfMpgwnUurmVLKn3o2/AtC6ceTL1oUdTzVXBdcuZxFGGfF+n2fp6r9iN1LJHnQ3V1wRXQT2MGu35sAIXhUwg+sxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+U9/tUfItyDKXP2PNSJyX6iFm1KmDo6rUNHWQQQL5o0=;
 b=Cu7btDES+nPg45ZvvgZFpBRT7UG0Pqt1i/Nsvv9cr0IWBp9AO1cK0nZsMOt0qq9ecK7wARUDInyfxNTVjGf38nDLTmhK0liTUi2rucGavQswTcrn4+p6xT3/Yn/LCDgrxn4/Lz+JFNMUEVoIj9NvpEyA0JzowqT+KSb4ME6216Q=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB5124.namprd10.prod.outlook.com
 (2603:10b6:208:325::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Mon, 16 Mar
 2026 09:25:10 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Mon, 16 Mar 2026
 09:25:10 +0000
Message-ID: <4bb3cff8-92aa-4635-a423-96c6f6294c77@oracle.com>
Date: Mon, 16 Mar 2026 09:25:06 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-6-john.g.garry@oracle.com>
 <abTokAgL5B8NS8ae@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <abTokAgL5B8NS8ae@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR06CA0009.eurprd06.prod.outlook.com
 (2603:10a6:10:1db::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbeb5f3-5e26-4856-4e23-08de833deb9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LAV7OrfFHkaj379Q0oM5MaCCe2vUlpUq4dSmufOlPyc50+rQ1v3+fb0cgPGA9nsXONTRAprNmeAW3C8rtdYZkMF6PyROEy5bhiY65XpBZqH6+NPster9lK+1oNLjIj9/3bQ5ELfSRfY04/iGiLLpGS1cTDBPEu+lrbaddHtK6pHwudxFbTiCgS6LjYjDO9cb8LAyl37tUXIfjk+Dt+0HYVYtjox0W7ZOllVaBxVo3P3fpiSaqIJkz0JkmGC+7qr+o1y3ND/mC7y6pteca//HUcedoUCuewSlSF5BhHdwG43VPMcUpSRJRdZEFVPfJsmAEUGaKj1gbtwPG0YWEVhjQqmlQKgCO3Z55mPcvGYMMtVOjykIKbBnRaI8ae3PdmDGUMZTTQtihc8piDjMTTwHAp8yFclCLjRnsUpcC1BJlZLDV1pB4eX65FgPJWQdReAqb04V48lzwhHCe95E/5MfB2JH7Ii2xRQo9PhZa8Y0xyYSglwOynuOybGKsdVrMY1P8mIq+JhB8y/dFEEZlnMSonEabecdFXtcTWflevfFOX9px07qel/q+Pbr6BWdgas4pHic13vYeryynWwg9KTlNwmN4X0waf9ZRrI/w99so93NpOFHcXBujKug+J5EmHktK4c94afaWGoGuCPNTIJxK7wP1sty9in0/M2lZT8ejIh7lqg/AS3dbaP9Fi2LblbXVAczuScHK/t6hwWdSUHdWDBoMYnDJQDdpL0e7tasn2E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGlsdVZKVTVaOHk0SEJJeUdKczRPdlh5aEgyNlAybVd2V3hpSUwzcmxUOEdy?=
 =?utf-8?B?NEMxZGkzaE83eW1SbW9FdGxOMlVhaTZZQ0x3bitXL1FmbjJiZnJtY0xQL1By?=
 =?utf-8?B?R0xiSHZnMUZJa09BMkNHN1hMUjVJWVZIVnBpTmpMTHhWNVdub3dENGVUZzUr?=
 =?utf-8?B?ZzBxRnpNbHZoNUxrTmZOeWNqUWptbTdhMlgwZ2ZNQkRIelNsWjUrdnlUNklF?=
 =?utf-8?B?MTRVZi9jVU5VZmRvY042NzNCQjhjTW13aGFiSE5RcHZScTNyZDBzV05sOGFE?=
 =?utf-8?B?M0hGdVRQU1V1LzluMXNsWEorb2tRT1VRTktMVTFycFhxZ3NrOTc3bHljYkpT?=
 =?utf-8?B?MGlmWkxXUEJlenI3dU5mYkh4QW1ydERaOWRQampuMTMra01MNVJOQU5UdzZv?=
 =?utf-8?B?VkNFQWlPdUFrbGRnTm9qTWl2RUQ1Q0NPOUptQk1HVXpkSDVQWlVZSTBPRVo3?=
 =?utf-8?B?Yk85MmhVeDlEWk8wMkV5ZTY2VjhXYWpKR0NyOVZDRlQ0eCtrUDUzMGRUUks4?=
 =?utf-8?B?ck44OHFiRjdXV1NtQWJ4bWlHZ0lYVDVXamcyb1NVQ0RGM205TmZMbmIrTTZj?=
 =?utf-8?B?L2FhaWRmOTNmb0ZDZTMrNlJubkR0dzBQcnJmMENZSzh6RVhkeWFOM0lDTi9v?=
 =?utf-8?B?UUl4c044aDU2MzcwUWxERHBTYlp6WGEya3l6bWhtQ3hwbTk4eDFodUZINGc0?=
 =?utf-8?B?T0pHVjJTUEZHemtwbUpwVWJGSkJERjRuRUpKN0FxMUdHWjRhV2QwckdwUjZy?=
 =?utf-8?B?ZnFMZnc3bWJFNTU1bDBlTHdLWW1DeDUwcHlySTA2QVN1ZDUrV2p1dVF4VGFw?=
 =?utf-8?B?U3VHQSs2bUZXZXBOWVpUL1Z3RTRUWTZWT0tKb0h5cG1Cak9TVTB1dHlyMDBq?=
 =?utf-8?B?UlJVbk90eE1xZkxsdzlBVDllWjU2OXNKallCM2dSL09nV1ZkYTFMWUd0NWdp?=
 =?utf-8?B?Ni9hQzBUNEJBK3VneUkxTzk3RFp0cnBJTnRFSVJUaGl2NHdjNVdWRFVFSWwx?=
 =?utf-8?B?bUVXUHZwVHJmWUF6eDZWTDAySWorQUdxVWNYRnBNN0JLdXUza0t4Tk1kNkRC?=
 =?utf-8?B?WWpVTVl3ZEIwN2dEMnJUZERnR2FDWjZnaUJJNDZTcGgvamk4clBQWHRiMkVo?=
 =?utf-8?B?K2pjU0pVZldyRGpoUmM5YUc0cm1Id1R3TWltbkR1dTQ4UnR4azg5a0hEUlVs?=
 =?utf-8?B?eFJDU2pFS0tkQ09DY3JNUjF6WHpGQ2h0a1RoTTVFdy9DWjAwK3B1VWJGSFpB?=
 =?utf-8?B?WUxNYUdhSjJnbWI1bWt0UXIrNzJ5blYrTzRoWXJNS2xtM1E4REx6aHRwUHRF?=
 =?utf-8?B?RFJ2NzNiVXdqc1FhK1MzMTVULzNGNExBVlpRNVRuekw1MTB6ZWFZR2g3QTJ6?=
 =?utf-8?B?RWN6Q0hBUm9QU2tLUjVrWHpyWGszZ1NWNlRGemJqYlZ4TlE4MWw3TnZ3SjQr?=
 =?utf-8?B?d2JQWW5xQ1NYQkhOSUZ4ZGRrZkhMTlgwRTY2UW1pUVFyYloxMUV5T3BpeEFV?=
 =?utf-8?B?S3diamQ3ZlRpcWN2RkM5YUFVVVcyWFZZWnIyeG1scUpKMm1ibXRRT2VJTkc5?=
 =?utf-8?B?NWR2WUY2Z1dtVU1kR2hjZGNjWjR0RWdMT2kyZkhqVUpMSmw0d3ZrR29lNGw1?=
 =?utf-8?B?eUE3bTdUdDhham5uaDVzV0t2V1BIVmJLMk5nNUxLWnhFWm1XUDF1aE4xeUFW?=
 =?utf-8?B?UlM4YmZaMHBZOXdnY2crN1hhc2tBMjJvQ0h0SjR2UkoyYnNGNDlPNUwreU5U?=
 =?utf-8?B?YTdRaWxYT2xJZTF0eTByL3BCQzdGbUd4b1d2QTdla2RHWmUydlZoUzVPQlA5?=
 =?utf-8?B?Tktnb3pnVHRwTDc0b2wyMUJidklPZjFUaWJINGo1SFMxZDBUb00yeWRGSTlu?=
 =?utf-8?B?U2x3N1VET3pBOGdsRU9XODFTK21JSHBhekp6YnkvZlMrY3Z0WXVPZzV1RUYy?=
 =?utf-8?B?ZjloMVZyZ0hBYlZsYXdNa2piWmc1ZmRZYWxETSs0UEtZTWl5YUdrcnpoQS9O?=
 =?utf-8?B?cFJYQjVWVWwwK3I5K3Y0UDVaZ3VMaGxRemYwaFJaYXRCMldDMitkMzBTMm5r?=
 =?utf-8?B?VUQ0RGtnaG9kWEZjR0JtYzZjNG1Fb09uVTFCMVBNbjJTakd2Q0FxcWJXWWx5?=
 =?utf-8?B?T0JQdGdUajhEcCs4SzZyT095cytTRDdiaG1uTmlhYlZrRjhuU3JFR1hZZnZG?=
 =?utf-8?B?VnBHL052cytOUTVaYmJCcTYrVFgwcGI4WU8rNTI3TmpHL3ZlOUIzK1pYY1Fo?=
 =?utf-8?B?cS8xc0YyaGRjYUxsMk1zSTNQWjI5WlRka1BNR1BhVmd2MmVMMnVwWXlEVFd1?=
 =?utf-8?B?LzRxUWJuaDRkZ1JoRHZJYkZPajM5MGIzY3BRbGxmcVhyMitEdkxjMERQYzd2?=
 =?utf-8?Q?k8cgBtEbgYG5Byso=3D?=
X-Exchange-RoutingPolicyChecked:
	AplJYANVMyvEDESRL9bH0udP7ioccCUbl8A0fBOqKaXLmHpTBEIZNwBoqN0vTnU57DqOrzEmGTuRhzk7pNJkMaJW8UDMyjMRUI0toa6TKk+BqYffZFp7eBvUVhDotX+vw9viVtmq1ty414qRMwAhKN1uP+ZufUdhp/N5bOyA62GijCbmnc6qjj0fQ372uY4X8pgSd5yAGPwA/jqZIBVl3qBL2MV5nqC6jgCQOkwK0Fh1drwe738c8aaxTANRIc7FZcYLEP5AzK+mF8G38nDYhpaBjTtTuOG6BHjZCYFj1pIu8XP6eMU95cP/OSXyLBJmVKMdMXXgjlq2UzJ6a0OAYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tbkfWEpJOr3hnmzA9QkDXdYFANJw2fVuKlZZxOFzcVKHi1ryWi3c0wLajHyNLpKvceUcsWxCP9pgja8tA5RHOAryhHKoeyb0/nVVqfdHOS572mYH4n6ogA1pC5Zz8TS9cpz4siotV61ilhgzsrd+Q7ACLiSFzwjWnrcARqiPCjpSNjKPXuWWT+LIVjKqifCQrIwhTLEh/Llk0jkgNn2nWKF2m/yZeYxKgAuzAd+LTBn+d9lqsEZdDnYvs/a6NdR9TIRZykmWchmxwMkBIzf9/OyeMW5RdPHdTCow0otDQb3rBwD+CGQXqDOCKGeB3Cmw6hhyATTVH8JClG7DMm3GltByXdHSDhWrC5OGxqtz9l4SEnBMaVZQsjWmbT9kxcXVV6rT3e9dXjFdvakhvHjNv+x+/ww4DSctoU0l1oHjLhYLOqvurJWfHohTE90QV3l/fCGLfLDdWyrAngdtUKXgto/Pyreoz97TZRnI81vB/a1VgK8Z+SBN9jdigtnqJVvDD2qpiuMtUJeAGQF7TiCvANuUglpe7YkuyXN9Syar4smAw6yjeqwPAnwj2YhcljR2EEUmACbAUD1WKdNWN305h1w02vwkc5ew2Yy5Y71iBt8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbeb5f3-5e26-4856-4e23-08de833deb9c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 09:25:10.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkmwjBjAVQIoujDkG3MPKUVFOOIEpluqVjgHUkrFLT4U2eMFjuVS27CW6tGk0Akc3x1FmXdR3WCSZq4ZYtjerA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160071
X-Proofpoint-GUID: PNDNirAcsXefdNC2MwEkkn4wkC_hYmz7
X-Proofpoint-ORIG-GUID: PNDNirAcsXefdNC2MwEkkn4wkC_hYmz7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA3MiBTYWx0ZWRfX1zSS8Ou1wyNE
 UMKgu4Wq2pTMV+mLoR+0q/XGKjJy6bXjUn8kMjXNaWP7FKBK/yAqa+u7w3vgIydrkRb5sd8/5i0
 ZX76U5KAm58cxuZBRYieumuF7Xh0FhfDstBwUJ+zY5neMOPw20Dm6kh6AnQDI896QzidoEiO89M
 M7WcV1bx855QPXGipgxK77jh85u5U8R6GQH6iYNPnWwciUWYlQY64WjuH6jMi5rpF82ikN+TbO/
 FPT+rfuT65O6GvOBGm8uJYIE5AZwEwxfM6xYKh1vc1olAPqPH6YXLboYY2Upnem88a9pz+K/sSV
 GBh24dw489O+W7bw0CTFJXEkR/5rP2vJ9dfTH445J0qUTqKEEhLUkIg+kjtIGWktmz7Etcfddc9
 sJPd26XRSFk4sK0enI3eGRzOQvfeOE8zrJlRCFm7GVVNXg0GPy8OoFj3Fxq0ptlnrklk9XQ9xy9
 prJLngfjkySOyavCJzA==
X-Authority-Analysis: v=2.4 cv=IN4PywvG c=1 sm=1 tr=0 ts=69b7cc7a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yGkTersQ7hjGTnEMKVkA:9
 a=QEXdDO2ut3YA:10

On 14/03/2026 04:48, Benjamin Marzinski wrote:
>> +			ext_hdr_unsupp = true;
>> +			goto retry;
>> +		}
>> +		/*
>> +		 * If the array returns with 'ALUA state transition'
>> +		 * sense code here it cannot return RTPG data during
>> +		 * transition. So set the state to 'transitioning' directly.
>> +		 */
>> +		if (sense_hdr.sense_key == NOT_READY &&
>> +		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
>> +			goto out;
> This check is odd. First, we don't set the state to 'transitioning' like
> the comment says. We don't set alua_state at all, which ends up meaning
> that it stays as 0 (SCSI_ACCESS_STATE_OPTIMAL). It seems like we should
> explicitly set it and make the comment reflect that, if just to aid
> understanding of the logic.

Yeah, I have to admit that this is all bodged the a bit, as 
transitioning is not properly handled. Instead of "basic" ALUA support, 
this really is limited ALUA support.

I am now looking at a way to have a core scsi ALUA driver to handle all 
of this, but it is challenging as we need to continue ALUA DH support.

> 
> Nitpick: Also, this is the only place where we goto out. All the other
> checks individually free the buffer and return directly. I realize that
> all the other checks that exit early are errors, but it seems like we
> could just return a variable at the end of the function.

Sure, I can pay attention to this. However, as mentioned above, I am 
experimenting with moving any ALUA specifics into scsi core code.

> 
>> +
>> +		/*
>> +		 * Retry on any other UNIT ATTENTION occurred.
>> +		 */
>> +		if (sense_hdr.sense_key == UNIT_ATTENTION) {
>> +			scsi_print_sense_hdr(sdev, __func__, &sense_hdr);
>> +			kfree(buff);
>> +			return -EAGAIN;
>> +		}
> If we get a UNIT ATTENTION, we end up failing scsi_mpath_dev_alloc(),
> not retrying. Aside from the comment being wrong, it seems very brittle
> to fail here, just because we got a UNIT ATTENTION.

Ack

Thanks,
John


