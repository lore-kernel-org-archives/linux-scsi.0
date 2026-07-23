Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D963BCD3F;
	Thu, 23 Jul 2026 10:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784803717; cv=fail; b=jX8pvO+kKK9mv9EY4MyZgRM7JzVXraceFMNAONfkNd0giWBmReW80BkPL1gXRWAq6bKVqZnyfoSlWXCr6XNs0MeKw+ztD0v4jI6ppoZMYpuVRBpmPv2U6bbNOGkSvgca6+72iMTY4UylTqAP4cF0WpxuwtqnL2s5AiXX2IK+DW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784803717; c=relaxed/simple;
	bh=EnTtwDOqLh3BAv8SpIDP3o/tqnA+WIRCz/0Khkg4QP8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W2Dtw/Vwf+Q2csMsA4oSlgqE7gqqguv+Io9Pdwub2P2eXra9gBAKuW3f4vIciA6YSt9ujTGv3Sgn/H6m4pHUVVupxETkKcTF7IJU2MIgD/dHSKxi5vtseJci7bfaBa7xhZ5rHAIfSle8yPUq1CnJiHlhnEAc7L0AvKPw5BZpBUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p8VZR/Nb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jmbNkQ4f; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p8VZR/Nb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jmbNkQ4f"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtjaq3404255;
	Thu, 23 Jul 2026 10:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pvk1w0SxEt8kXJOCzpgl7V1IIWe075STObSF4cFmG7w=; b=
	p8VZR/NbD72zQLQrdrASuR8n6d66qoTPlkPA+oj+Jup5TTeBz0Qr7kDUFzz6j9uP
	Y50T/LV68jIyf08RJIjI67iSC/XwpEgqVjWghGBknStEOkZA1T7IJom46sIjQhIu
	0oRDkiCi4sUiloBN58nxHjL6x3ljEGDvebvRYfeQWwbsJCnLJcesApRCMvcT4z1s
	asod8X2+uWnmX7hACOhwLoikPptGSUJoRruwxfWVoP7sEohyqmXXxMvi/lZNa3Vu
	nICveyoFoLXA5jwedvR46D2AKSxxCUc2G5CdjXVzlwcF9EkuLWFFWQBsHYpgYMM1
	+IkbPtJ6BsFCzAhVZgH+tA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3pq20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:48:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAmXou029381;
	Thu, 23 Jul 2026 10:48:34 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxryaum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:48:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjxh+JR3/+3uHsFBgLZkg29SRvRJtmKKwbiwMmQKrNl6slHc7RJaUkQ8bvX9k/CuzXQQ7uY6dzTGyG4CbZ1wPyKBb/bz94RXWJp72KXQhll9xNBJtVtdxq8G6AYaC/9LA2qkLAv2CI+WZwL46cNpONFTZhY5Ft87XmEw3dElcho6RVoMuzkHR81NVoxsIFqefVo3rEW80uepFfhbgZxmnAN7tfqsFYvvXl5dG4b9VcC/KqGRhgOBU/OgNfaXcA48D/ueA5sOoTqcOC2ACnFbVeY750Bw/97SBQseHFFJHQBhT8WZEmUbY3OQ0ixaKXiPYDfKUCMyEHLjthDu4JdiNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvk1w0SxEt8kXJOCzpgl7V1IIWe075STObSF4cFmG7w=;
 b=TAe6fSrLbfef9G3LGarpA8ZMuZtgrj3iTNsPOK3qbjrnhSNRtjlErpyXaqbg2+JPIrjX/GhhQ+5AihXQubyRuPNn3xmujQKpzWbbkyT0IcZO/5gSZV8+yE9pmoaDaJTGHZ+ogjmTjiTS+maiuINKJJVXTlO8a8dzzs8TiwlQhtDphG9oFHSOb3rimiSb/0gOlZP5xf/86IdC7RpnpQ0a/Z7cSqK0ElOkH3TPdXnCrAZEf28TxrfEQ4X1mmkjsRZ/x0rgDJRFQF2e8+VhL7C4i2qyLED0Ef82wlLtkhNndzVturPdAkJPuHk2PBWHObu1Hhq7sW5ViEyfqGIVNlVMIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvk1w0SxEt8kXJOCzpgl7V1IIWe075STObSF4cFmG7w=;
 b=jmbNkQ4fCXBbM62uM4UUJzWC6vZnA+pYYjRdNwJteSjD7sgELMqEaSxKWF2l/lG+HKCCHBRF8ClNYyWJA0lRsR8JUKrwG1ktzuvvGTu7olk5fu/s5n/yYD2cRNrfQx1CrcKd6lXpnAhBn+mDo9d6TteRis1X05TmqkIjjU7EJwo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA3PR10MB8162.namprd10.prod.outlook.com (2603:10b6:208:513::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 10:47:39 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:47:38 +0000
Message-ID: <7fbd4420-1619-48d7-acfb-d779df6f4b1b@oracle.com>
Date: Thu, 23 Jul 2026 11:47:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/28] scsi-multipath: introduce scsi_device head
 structure
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-14-john.g.garry@oracle.com>
 <20260723101656.C50091F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723101656.C50091F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cb::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA3PR10MB8162:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf09993-82d1-457d-2393-08dee8a7d059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|6133799003|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FuyiBww9ve8dlNXlgmKDCuRAz7c5VIvEHqb80LxgNz8YGibvB09INIFWIqk4xQSrPP7GDtfIziBNAwqcdSVwv0skZlC9hakPXMgm56kZRXS1nFmMO5UTFIE9sbqz6YA/xNq5O99MAwNJ07P3EzM9dnri1q7r7ZSZcbypviLDroG7PMaMtDMMoRJClsp/v67S0NRLXWLOReUUUvyWwE53C5fvJh5VupsaomPtVRGJxTbprYeB+WfZ00uTZFNqbVj43t4VR8oo/ddMfeLhXOyls3Ko0nscN7Elo65wnWDKe4EFNbR3MeKW5K3p2ZPWG6Kwoy1VgHrrYGoqnXYSgOGNaeSFo1DYSnzvvvGpJsJ6TcKq5xMoMxzqiOFkXXFhSR2Hf+kH5pb/JlSr1+oqxIrG2Q+/RNRmzmOhyJq5OKgI7Inu0eJD+eQNusfGIUDu2a2yrin0Sw+pY1KRjSSuaszVq+PS7HE8FOpMmyxu3xBaMiv2/S/B9n2ajHHLWkzUqunQ4ockEw5DTcAG3IMTZmxR6DmngaW+PjkmdxUmgcRLJz8J80Ue92D2Jq9WnQQ9+TwiAXM5ngcE3TDtaj14urO71zG2tzTqPyhayYtZzPGgIBatsGRl92ZbrnTAp3n6akyq76qU7ZPOWn9cfnLuXrHqEt5uQQI69QIeTm0lEmcQXJ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(6133799003)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkVhUnF5cGlwZzhzdFpUQkNNZmFKQmZnemlIbzZqWDNlS3lLM3A5UXExbVZU?=
 =?utf-8?B?QWlzdUJjWXJmZzZiTXRSdDgvU01oUjdzVmZHMlVNNHh5RjhXdXNLOENQQ29G?=
 =?utf-8?B?U2R5YWJtbWVWai9FLzNyTDA3LzhxNEdHWmdsbzU4TDl5M1F2eDZsRVNCZUxr?=
 =?utf-8?B?MnhYaGFMK0hUMStkTEswaWNCMU94cGNyaWdsbVV2S0JKaTk4NzYxR2ZqbUZ5?=
 =?utf-8?B?Yno5dkdxbEhIaHdGeDlubHR4cnVGeWtzRWxCTlJnNkhMYjBxa2NRZ3BiTm0y?=
 =?utf-8?B?elY4eGRtTk9OVjExMVN6aVN5MTVoTms5S0t1a0plTytQOXdnaW9sYjVCUkRC?=
 =?utf-8?B?VFJiYndFb0JkQTQ0OU1aZzdKdytYRDc2Tmg3RXViUUNMVzZCNFVwOU9ZMWxQ?=
 =?utf-8?B?T1JQZWI4Mko2dE9yS3pxSHFuUEMxWFRGUWxLb0NxRVpXVkt3SWtTc2JYWXFm?=
 =?utf-8?B?MzFXL005dk9hMEJUbFc2N2JkUm1DWTFYa2owUWlnV3krek5JeEhmSWJmZXl3?=
 =?utf-8?B?QlZUQUc4d094TnIveC9FU2c5RjJvcXltbjJZWWJ2emZabWdPTlM2eFFrbWFB?=
 =?utf-8?B?ZFMxK3AyakVCdHkybjJxU0hxWXUwUDg2Ymh5RVZGai9zT2thY1MrVWxwVDRG?=
 =?utf-8?B?NUkwMzNwREozK05OckcyaFQyc3JOK2FpUWlKZkN0YWRjKzlJV0VhYlZLdFdE?=
 =?utf-8?B?b2xiSTgxSFZwazgzMXYrMlNXUDZYZFdlL0JUQTVtVGNhaDF3TzlydUI5VXpy?=
 =?utf-8?B?VmJWSlpvY2g2U09ZY2w4U3hSZlhHL3dHUVpGWU41MmJHQTdiMUdNSXpvbzBn?=
 =?utf-8?B?SG5rek9JRWlyREorWmxramFuOXJ3N1k5WGNab0NnNlQ1aUxib1c4MlhpS2h6?=
 =?utf-8?B?d3ZQRm1yWW0xYldNbHFZTXVWRU9tMXdpTEFhSDhxYjBLVDR1M0RhTU11T2Zt?=
 =?utf-8?B?L25YdDg1UDQrM3JYNkh1M1JRT2QxMHYrVGNLZFlYZ2ZCT3FDdDlKY1owNkZw?=
 =?utf-8?B?M1ltamVzbEUxc3FsSkIyNFdWUzhCa011bGtCejhsNXM1U1JBWGc5bDZVc1pK?=
 =?utf-8?B?NittOGdYYlc2Tmt6Q29oOEpqMEVVMU5EVlhwMWpXMTNxcDFwazFQQnBJY09x?=
 =?utf-8?B?U3dLLytzYnJLT3UzZGtIQ1I4c3ZSTTdXVDdLTy9vTElYMzlGM1lKQXowUGtF?=
 =?utf-8?B?MFZUbmFDeTAvMDhXaG1HRWRKb1VGQWxsM2RMZVcxeHA5Wkhrd0pFdlFzMW5y?=
 =?utf-8?B?VTdyS3BNM0tPRzAwbHRYdm0xWnhNOTRucFFmVG1BSUxpTGZvbng4OTI2eVJJ?=
 =?utf-8?B?L01BTS9jYStNd2dFaXBhR1Vid3AxNitSYTBFZ0d2L3VvTUs5cE5DTU9iUDV3?=
 =?utf-8?B?R04yR1RFaHh5S0piS0h1alZWMEd1ckFPMHdUWlRGRE8ya3dLSVgvaXVDWW5I?=
 =?utf-8?B?eUdtMklvdVZ6cU1wRFZ4b0NUV3M1Q2NsV2FhdFlUTWtKcWVQUUJHR0hocFE2?=
 =?utf-8?B?cVJkSm44S1lLWDE2NU9RSTh5ZkNQNGdIK2M0ZmRPUlNVODhuMmlDZFJvY0tJ?=
 =?utf-8?B?Tjg1WXNoNC93bE5BbWtab1BlNHVQMnNrLzhldG1KNkF1dWh2NzNaWTdBOE1m?=
 =?utf-8?B?VnVBZER5RjVXQVUreE1ObzRSUGZDckJXZ1RsRzdrR1NPUEQ1Q3JGN0VMN3JM?=
 =?utf-8?B?cmJidWxzYThpK01FQkowamowcUhEanpSeG8vZ2NudzlVK21OZXV6RE50UDA2?=
 =?utf-8?B?S2N0ZnBHeEFDOVRDZHBNc3BrcHhMdDgvK01yVVpkS2VGWVBJQ0JZSGlXT21z?=
 =?utf-8?B?SUFmU0U5MlR5NkR0YUswRkZIbGptNFpEbmpJTS9JQmVGTVVZMlFRQ1RrajBa?=
 =?utf-8?B?SG1Hc2JNN0JTc2NteklmSFdWTDhTK1R1MkxkK1B5bnZobGd2d1ZhSnovczZx?=
 =?utf-8?B?VlFXbzZpdnU2dDVCTE9ySXl0S3RHb1hlS3JQS1BrZkJCVytTMjhGdmt1VFFU?=
 =?utf-8?B?Q0poakJJaUN5L21EU0dpSEdPdWd4d2pvZ3h6cVV1QmdFcmwvdWprN3dXbSti?=
 =?utf-8?B?T0Y3NHR2MDBTUEZZaXZXc3ZXN1lEenpPWVhOaXVJT3ZOQTFKaVR2eWNPdklv?=
 =?utf-8?B?ZkRLZVN6bjA0NjNtK1N1UVB6YWxDQTkyZGozcUNOMWpWZmJPeGluR3BiMUFL?=
 =?utf-8?B?VFRWRy96RVNubnVtRXp2NVFDTnJUdVJEeGcvNitxaHgvbXRjWHgvZzdmS0ZC?=
 =?utf-8?B?c2ZJNG1KN1VXMTRGRXc0NlhWQytMaWRFOUFGdFh2M0lURVdMTTdWaVhXSjJy?=
 =?utf-8?B?U0h6MHdkWlVwQXRMN2ozRWszVFkyanZUTmsrV0NMbGpMM21qM3lHSjd2OVhV?=
 =?utf-8?Q?tnyRRkxub3fEYYfM=3D?=
X-Exchange-RoutingPolicyChecked:
	XrfuqbDEcLAnPqxMcJgyLGAtC0dPLX7MmSKiUZjAFlqDZejZSMRviOIpTKVK1nZL6Ebuem2ugFVyI6CeU20QjD+b3G4nVrNuxPn90LLw2uXlOZikMLYSshMuSRbeafzg9INj0Bz52x/+VgHMopINod6YST+a7O+0uuGSAUadIyynJtIGgmSmxV7QBEkico9vbdgM55yqUTp1Db2urqolKpJYHbRKVm8cOOX1cResygymTYkOTwWn9LFsEdvzLZ9rTdXpqDIUlPJs1EQZMezwJiEpj7pIPwMa+HLsdTw55a5o14xg92q9vYav1KdM+6xrzX2uJOGveQOFMtgpld2hZA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RjApYiClEOlKj5SWFc8Ajoi4mRTisUxTEJ+e9ZuMsrUxO0rBT602oR3qZ7oRSKYpJ1q4l6dorJgTdvuUawJG5NJ3KCYOgcVbdF02njE/bSyEkg6VmEC3Mic901w9aLOlDn07tmBI8KcFkAAQCkrl2fxqjJNf6Tc7JKSBADjPXA4gj1KVwtuY+byk7EN2HpTfygsq311Gx8IX/jlvBxeNgo+g3ldvCEaimgBClfUW2HmaaUrDd0r16FObgqjW5cW1Bf5NUmrDM3HW1txUtnVMwS0jFUmcXH4djR1QfZgEGt3yROWnO4CCmwPQhtLzl/lCsRnoRc+sizuFGeyOktD8/5mMYEXueysLrUud77uFMl4UkZwVhTGbW908RlqRJwpoVUfl3U4S7pDDLkaI5IsCcUCtqOOilLFDWcEa0AqSqUNqwGSEbQNIG1bbT26C0Au+aZSB7dE39WjZpxg2KXYI5uT5kXKcDs+r2C4dJg4uDm2ZoIVXPK1AbX8SdfkLQ0UlIaL2WTkO5ovkeFCTPB+JjR2BLcjVCaLTxM47J1usU2toJ5pGd+YpmAejJLsd+y5Axo/H8mVsIl4yulp/Wq+l+9EtINXs3AJoef4JJsCeFfM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf09993-82d1-457d-2393-08dee8a7d059
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:47:38.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5z03RuYhCu3upI9HR778TQVV43IPl6J9M+SaAAMN/BGTF9lkT4pCuCXy9IvJql8GxUDEQYSDZI1ZaVVBCJdUxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607230106
X-Proofpoint-GUID: Bp9wgabCE_Y8JsgZfnwE22XnwfWML96h
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNiBTYWx0ZWRfXwm7Chf9xng10
 blk5rzY4fBBbEa8ya6wPkKVPvpWJzf1ClFslcbTsgXmaz2Of6HIdxC31brzgk5SLn/HoGc2iFiO
 5FS5yXrqAbrtAtHz4ytfJY0tsrnjQ7oM6bwJczgB+C2KROUi694V
X-Proofpoint-ORIG-GUID: Bp9wgabCE_Y8JsgZfnwE22XnwfWML96h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNiBTYWx0ZWRfXx/6oz0sF1BS5
 gVP2+XvX4cIPXGiCxUx+Bcr+3qhK2veZfjQXZFE1JhW0qWYAEt6JcYBiqUZPHhLh4QgRlb5SIV7
 kO4EwLwCHrSMRjb2ut6EcoS+rTUT61UBa9v3cNoKG3n6H639ohqDNQB1xl36Pw/C/SwSpB4TP+u
 qmjwGhptgcvf2QYK0SRpfzw3KfR5WDRHtl3Y2TgLr43aIipQGJU/PkVGJqiWS7PHpyka2yjKH38
 im8BL1g6ryROXFSrnodicc68W4TvO6y1xGSaETTFRrFuFhwidgejIQVHaq6LMKBgeV8Nd5/Xf4N
 okzmmCCXe3jzfa3hvje/daglr61NoT/wNtDTbdGG/tBGuHEgOUd0FTlzC2jsOp/CL5HIOknXxoq
 UW6H91NsB8donZf0F9yoJbngn337rsdlnWJTQhpoEsARlJt2Ho7v58WeXEXNh28b6J70fp3ENU1
 AT2BxjlgXJHstOZ8IaEiQ8hN5XA2/FZBXolyMnY8=
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a61f182 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=PEQhC39VvKkh1DZ5X4kA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114

On 23/07/2026 11:16, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] `scsi_mpath_find_head()` prematurely aborts list search on dying heads, leading to split multipath topologies.
> - [High] Double removal in `scsi_mpath_remove_device()` triggers a NULL pointer dereference.
> - [High] Premature teardown of `scsi_mpath_head` causes a Use-After-Free on inflight bios.
> - [Medium] The sysfs attribute `vpd_id` is exposed to userspace before it is initialized.
> --
> 
> --- Patch [13]: [PATCH v4 13/28] scsi-multipath: introduce scsi_device head structure ---
> commit 11c848a95f46ee71e21d42eee402d581f96c8055
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: introduce scsi_device head structure
> 
> Introduce a scsi_device head structure - scsi_mpath_head - to manage
> multipathing for a scsi_device. This is similar to nvme_ns_head structure.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index b9b58a3641aa2..609f8009e4ac3 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -89,6 +141,71 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>> +static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
>> +{
> 
> [ ... ]
> 
>> +	ret = device_add(&scsi_mpath_head->dev);
>> +	if (ret) {
>> +		put_device(&scsi_mpath_head->dev);
>> +		return NULL;
>> +	}
>> +
> 
> [Severity: Medium]
> Will calling device_add() here expose an uninitialized vpd_id string to
> userspace when the uevent is fired?
> 
> The vpd_id is only populated later in scsi_mpath_dev_alloc() via strscpy().
> Could a concurrently executing udev rule read an empty string before the
> string has been properly set?

will fix

> 
>> +	return scsi_mpath_head;
>> +
>> +out_uninit_head:
>> +	mpath_head_uninit(&scsi_mpath_head->mpath_head);
>> +out_free:
>> +	kfree(scsi_mpath_head);
>> +	return NULL;
>> +}
>> +
>> +static struct scsi_mpath_head *scsi_mpath_find_head(
>> +			struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head;
>> +
>> +	list_for_each_entry(scsi_mpath_head, &scsi_mpath_heads_list, entry) {
>> +		if (strncmp(scsi_mpath_head->vpd_id,
>> +			scsi_mpath_dev->device_id_str,
>> +			SCSI_MPATH_DEVICE_ID_LEN) == 0) {
>> +			if (scsi_mpath_get_head(scsi_mpath_head))
>> +				return NULL;
> 
> [Severity: High]
> If scsi_mpath_get_head() fails (for example, if the head is dying), does
> returning NULL here prematurely abort the list search? Should this be a
> continue statement so we don't skip over a valid head further down the
> list?

will fix

> 
>> +			return scsi_mpath_head;
>> +		}
>> +	}
>> +
>> +	return NULL;
>> +}
> 
> [ ... ]
> 
>> @@ -133,13 +290,47 @@ void scsi_mpath_dev_release(struct scsi_device *sdev)
>> +void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +
>> +	ida_free(&scsi_mpath_head->ida, scsi_mpath_dev->index);
>> +
>> +	scsi_mpath_remove_head(scsi_mpath_dev);
>> +}
>> +
>>   void scsi_mpath_dev_release(struct scsi_device *sdev)
>>   {
>>   	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
>>   
>> +	if (scsi_mpath_dev)
>> +		scsi_mpath_remove_device(scsi_mpath_dev);
> 
> [Severity: High]
> Is it possible for this to trigger a NULL pointer dereference if the
> multipath device has already been detached?
> 
> In __scsi_remove_device(), we call scsi_mpath_remove_device() which sets
> scsi_mpath_dev->scsi_mpath_head = NULL:
> 
> __scsi_remove_device()
>      scsi_mpath_remove_device(sdev->scsi_mpath_dev)
>          scsi_mpath_remove_head()
>              scsi_mpath_dev->scsi_mpath_head = NULL;
> 
> When the device release callback runs later, it will call
> scsi_mpath_remove_device() again because scsi_mpath_dev is still non-NULL,
> leading to a crash when dereferencing scsi_mpath_head.

no, it's does not.

scsi_device_dev_release() calls scsi_mpath_dev_release()

> 
>>   	scsi_multipath_sdev_uninit(sdev);
>>   }
> 
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 2f80d703ce640..d6bbaf424bd4a 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1501,6 +1501,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   	} else
>>   		put_device(&sdev->sdev_dev);
>>   
>> +	if (sdev->scsi_mpath_dev)
>> +		scsi_mpath_remove_device(sdev->scsi_mpath_dev);
>> +
> 
> [Severity: High]
> Could tearing down the multipath head here trigger a use-after-free for
> inflight bios?
> 
> If this is the last path, the scsi_mpath_head could be unregistered and
> freed before the request queue is drained in blk_mq_destroy_queue() later
> in this function. When an inflight bio completes, its end_io callback might
> try to access the freed head.
> 
> Should the multipath head removal happen after the queue is drained?

it does as we drain the mpath disk queue first

> 
>>   	/*
>>   	 * Stop accepting new requests and wait until all queuecommand() and
>>   	 * scsi_run_queue() invocations have finished before tearing down the
> 

