Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22CD30F813;
	Thu,  4 Sep 2025 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756998741; cv=fail; b=Z0JcwrNLflvxpdZp7ORsmsPYCYNY8gnmro7S3yllu/3E44DeMYmJBPHWBQb511cwNMX0m+lIlNSNhIxpiTROtixgBCfVAGZKStE/+68ftj75/jeupgTYA+3vXx3YKgK7RuHA2IHX21f3asnOK2QxxprIonFT/o/HEiRQAhLeuZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756998741; c=relaxed/simple;
	bh=bqSzXJplhjpupQScn/tjJ3/pKW5P6l9eVMVf+WQzYKc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I5eOfud7Lk7e+MJRVdQfC69JUtD4oHwhzn3iKmYT3ry2S2v7D7cNIoWHQurXpSB8zBsYCLP00+nRAEz5MiJbwbh4IR/5TFgAUYCt+XPu2G9PbO2sENrxUzWhAd4A8JxztP5L590bOI9/TJ9v5kqdGJWJllRQN8wHAxUfNDdHIog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CBBR7oF3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N4lihK59; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CBBR7oF3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N4lihK59"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584Etokc013472;
	Thu, 4 Sep 2025 15:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TsrufeBvoHOGq6u3taQMGZI9Kl8TofcF9cox5IB9Rz0=; b=
	CBBR7oF3urLczB1o8jK8tgOSuluL8GXW5vmbkKC1XBV/pNumGczNXVFEfMArNUXQ
	95ngP1EIpbuOrESCyjsyvT5OMhsllwnR7jeG88kN1Xq8lxsy3ObqDPoHF+FhzVi+
	84xqp8bSxLoH/b/mHqX9BKVem5W26n5dXQ5DF2nKBM5KhhgrJtbG+bSzIHza8cQi
	gEeklQ5UArzrzljNNRHgRQvSClfuj9jD2KdRJu7s3kH+0wEuwXihomTEhDLQDwH8
	+Dx0TvvC/yvyUqIszRLvWuMPQcW3qwpuPAebCw9Cin6xmtki075G3uFRGRIhSZy7
	YjM1rgFeoX0WaJ5JOWTLSg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh08xk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:12:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584E0iBO040016;
	Thu, 4 Sep 2025 15:12:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhs6xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:12:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L0pznoC/4xIhGblfBhuGA9USQL2TI1Y/7n5GExIx0vosmqWfiTh9OJ2l8S8SGf5DonMuqoljCHZjs03lF9nV8GSj4whWF300Y8tmzgzvgngbtOMTWS9ftDjA6PPBY5XALi1JpCUNTIfMSgECy4HM1M/FGJZktbpkSaPhtblAaVd9x+rW81Sy2ah5DbPG4/JJ3Sav94bwwTmSMwbsOouNEJWZ+ZDBq3GpKpEBk1Ht/82dcGklwHS6TTznZPdlVrBiN2nptE+WpvXcSAxvHC4q2zEEHGRflxFpDrS1eSwSQHaW9aiR2LY7lsUkyHkVqJx+Jj0bAUthlVcKrQVit4RgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TsrufeBvoHOGq6u3taQMGZI9Kl8TofcF9cox5IB9Rz0=;
 b=dBFxexsccrc4Su3Cv4UE7+7F5G1J5kv6sPNgC7qbkJmvoVTXWdIsuTbw2rb2M9pZ4WJEgWSxggznMj3Eq7DXw0TWyUW27M6H98cwCZ8baaCnxATDqd/ZfvywOFhgDoX12KED7d2I8YZ6HF2vHLSZkBpm81V/7xQ/knlxPxFex9HV3KXCTOzdNOiX0PXJIkMfhS9mpvocztxAif2qomThmWGoQD9N7BP+9NSNuCpNNQq0JiPpjX0T3RImTg3x8z0J0eG61H68LLehpBVDhRGyQ56+cSrWQB+t2nkL9e49R2Irj15YdzhCUyupOMhFmUSpH87Mlw/Gdc4C3ymKLvIGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TsrufeBvoHOGq6u3taQMGZI9Kl8TofcF9cox5IB9Rz0=;
 b=N4lihK59H0IHPGgy1HSeCLtEeILTqHXDpuXtO9rREQ1ZM1qS3GMpkZ/cWLZE/9UAPWi1TIDKHS0GP3dzRZiB43y7MzU4/boYGGkfyEvDxvit/3lgSpM+jeXHNNM85gHyOxa+LpMPoqeZlHgbmp1R07aXHu7NK6wEWJW7Bx1/pos=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB4982.namprd10.prod.outlook.com (2603:10b6:408:12c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 15:12:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 15:12:14 +0000
Message-ID: <c487f4b9-10f1-44c4-955e-c64fcc0b25d2@oracle.com>
Date: Thu, 4 Sep 2025 10:12:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: iscsi: Use int type to store negative value
To: Qianfeng Rong <rongqianfeng@vivo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250902125017.41371-1-rongqianfeng@vivo.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250902125017.41371-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:5:3af::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB4982:EE_
X-MS-Office365-Filtering-Correlation-Id: 3752a9a0-57de-415d-ca11-08ddebc56da9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHZwNEppQWJWQjl1RzBDL0Zta3dOSDhyTE43Y3VwdFoxYkVwUHBUTDVuQkU0?=
 =?utf-8?B?VVpSNC9vbmpvbWRxMmp1WkxDRFBUQ2VKL0Q4MkhnV2xsaXNETEZyMGV5S2RX?=
 =?utf-8?B?Y0c3T0ZWdy81NWR0T0lLcExBa0lwb0haczBRdXl0MCt0dTROcUdQSjg4NnNR?=
 =?utf-8?B?YXo4L1BoODFRYUE5RjB1aXYrUTVYTWNVblpIRDVhMUZXVWZHU1BLM3VUU09B?=
 =?utf-8?B?ZEZRUE1VendnZk9BcG9PbFV3a2cwNmpvSExOd0liUWxyRUpCa1o0ckEyL1hE?=
 =?utf-8?B?S0hpb3c2ME9rd0lhNjhhczZNZ0ZIL3l6dE9QQW9lYzliekJHakFNb0RTT3dZ?=
 =?utf-8?B?NHdsUXYvWXVDNmcyRzA3LzdQL1IrOGRRT1lyQ09NSVVLRFRpOGpiM1lsaUVW?=
 =?utf-8?B?c0llVW9JK3IwOWNkTHAyYUV3eW53Vll5Smo1OGVtVVd2b3pMc2NTQU11RERj?=
 =?utf-8?B?bWRhNVpiQ2J4b0Y5dDVEOWtMbU8yTnB4VHBKRHh6USs4VTl6Q3JsK29iK093?=
 =?utf-8?B?SzVaNVFYK1BESEJyOFRobnNvTm5VSGRFM0ZBL0hkSlpLaG1wb1J5YW5lVTZW?=
 =?utf-8?B?ditjMUhhdWk3OEU3SFNwQVYwbHUzVmlISDVXajhvT0ZwZnJvM2Vnb1VpZkJY?=
 =?utf-8?B?V0ZvZy9HYlhpZVZpZzJ4OUlFKzduTHZxNWE5T000LzNJUmplZFU3ejlTLzUv?=
 =?utf-8?B?RDRsdlZYYXBicFZJbmRJSUxmYnROL2hJbW11QnZnUktzVlhVVGVESytXNWdj?=
 =?utf-8?B?RzJ3ZnZpbXZYdGdTVVRWSmp6eHJ5cFA1R0xjVUlqcG1mK05hQ1F1K3RsT3NL?=
 =?utf-8?B?SUdKS0YxOUZoMXFjTmlXMHJIR3dad3FHaUJrM3dDaWJlTWl0a1V4QWFqU1hD?=
 =?utf-8?B?SkRPa285aTBlRStSV2RFZXM1VkorZ2hIRE5sT2tMRnJwVXRDZWp6bjh4aG9j?=
 =?utf-8?B?UWVVeHpLV3FxQ3V6TnZRU2xoV2ZOamV3ci80akRWU2dqZXJoenNjR0QwMlVs?=
 =?utf-8?B?Tk5PSXNzK1I1L0x5dGdDUVl4R2p6TTlBamRRTjA5eU41Y2tMdVdNc3pzbW00?=
 =?utf-8?B?SXFJOUVBcXBUZ0NWYmY3U0dvZW1DeWdQRlh1Z0FVZXR2MDdhNlBVeXpXMWpn?=
 =?utf-8?B?bmpVWmRJTytUSTBEMmJBcEVLWXJNTHQ3N1cwK2ZzdWd4UTFQNjUrRnFLMUZj?=
 =?utf-8?B?UVdLc2kwUENSNmgwUW04MWNzdnl0VUdHM2xqRGd4SGxOOEloVFpmM3NaOUZW?=
 =?utf-8?B?QVo5VTk5MG5OQ3FjcnRKUEhJSGc4UWhBYUYxajVGWFhlQXVxOUxCWjA4VllB?=
 =?utf-8?B?SzVMUmlYNEFvZVhLd1dYSGtocUh6dXEzSVprL0d6aFhmKzh6VUduTytpM3Nx?=
 =?utf-8?B?bHVzL3FDZTR1NmRNUWIzdFpiN0tSU3d2aldvYXRWNDFXVDhlazF4cVJ0TGNB?=
 =?utf-8?B?UXZrUEJ4MEdIbkZHMEdFVWpKLzR0MWluVDhmQ0hGYkUrL3ZhMkFwQ29IVG1U?=
 =?utf-8?B?U3Fjam52TnYvQkdzZXVzblhWNkJCMkNiYUw2T2xiOHVYdHpCdGYyR3NDVUE1?=
 =?utf-8?B?NklRZml5cWxiN1VZNER6aHozOU5FUnZ0M2dFcXA1ajIzVTlPZjJtRTY2WUsx?=
 =?utf-8?B?eTZqYWwwdWR2QjVBVWRzdHcwWk5YeUtVMlFBTWx1bEpaeTM4ZDIxWFJiRVR6?=
 =?utf-8?B?OWJ4dnVoSTVUd0ZERzVRcElkbUFablI2a05Zc3VwRGJIYzVqblhOMnRlOEVj?=
 =?utf-8?B?Vy92OVhOTHFCVFUvSVVJRlo2MlI4QkZWWFdqVGdrcWk3ZzhyS1l5bVBYUDRY?=
 =?utf-8?Q?u0OQK7CE/1deEt5EcuhQZ5uePaJQX0HYq4GVE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXV4bFk3RVdhR1VkYWs5SmVwOHZlYlM0L1d4WHNQR0pjUjV5dXNVeFRkRWJY?=
 =?utf-8?B?RjJOWUROSDJJTTN2YmtjRHY0R0IvLyt4NElXQWlheXQ4VGpzOG54RUwwZEcw?=
 =?utf-8?B?d0h3VVFNRDJXME01NlpYM3RWV0ROb3h3OVJxK0t4aFMwaU9ZVEVtSWhCMHlu?=
 =?utf-8?B?dXg1WWlvOWo4clpkQXM5YWRPN3o4Q2d2aUpQM3BNVGtIWUV6SVZRaEl4WjB2?=
 =?utf-8?B?TjZadGloOE1TcEgrZFEyaGtvMGhSZ1FlemJDcDBTbmVCVm5GcTRZTlNtT2kx?=
 =?utf-8?B?aWhwWlhxdStoOEdVbFk2ZjZ1dGIvWGFiTDJ6N0F1RkkvQytkOHBlL3Z3VXdP?=
 =?utf-8?B?U2JaYzYzZWVKaFdHc2xrckhIb09GZDNza1Y3dGNJRUE1cUdSeEl6L1RvUktW?=
 =?utf-8?B?a3lwemJmUnJtVklTMnRzRGxWVEd6RVFxYVFSSHUyZElyanRWcmlxbXZtMEtm?=
 =?utf-8?B?dkZlTC8xR213R2tRVXViUnVtSm52WXhwdlhVSVk4WWNGd21mRHJ1VHFERndh?=
 =?utf-8?B?SGpabFRUMXJ3dmNOTkJSTE8wYzRUOUJDZUNER2R5QWNTb3F6bnpHRFFRT3lj?=
 =?utf-8?B?bEF3bTNzSGN0Si85b3FpVjh0bVVLaWpZeHVuNjRNNjFINXVFRWRHWHpKb0hW?=
 =?utf-8?B?VllEUEswaXlrMUZ4bUtpRjJKUFhlNnJBY3pZd3MwU2g0bVAzdnFsaWh1blRi?=
 =?utf-8?B?VWhTenYxYm1HTGs5QXo5eEJKS3UzbUdhaXRJRWFJdXdkSnk2Uk1yNUo4K3lU?=
 =?utf-8?B?cDRwU0d3UEg3eXQrZ1lLTDJoNzZ2WWI2blp3YmdoQ0lnZlBOV2NIS0RTbG55?=
 =?utf-8?B?MmFtNHJ4ZEJMYzlMaWtQK1dkZU84Lzc3YkZMV1E0RmpEaFZKaVdEcngva0JV?=
 =?utf-8?B?TVRQOThRbTlhOVBxZWFuY0N2ekZzdG5NUVA2T1VrZHY4Z05STEpXVGd4Rk9X?=
 =?utf-8?B?UjJDQWpDSFBsVmFxazlsaUJmMGdxcTdDeVFYelRVNmI0clBXKzZCQTE3TUVp?=
 =?utf-8?B?YjZjamp2WndpWC82dHhuZHJ3OHZMRWhGZjZEM2FWaUxtSVEvSkEwUDFSQk5K?=
 =?utf-8?B?V2RUWkUxL3FLcTFYV1dUdE4wUDU1RTJ5bC9Wd1JoRWNEU0h5bCtQQ014VTlI?=
 =?utf-8?B?azdmNDJ1dzJyWks2Y0hiVEZVMUlKbnJnc1UyY2FMZ0dtclc3R1RYUk1SOHBW?=
 =?utf-8?B?bWcwZmY3L2xEMk9TRzhxb3RXbStSRzhwSi9zeXV1MjVPYWpHNUtKZ1JyYlJX?=
 =?utf-8?B?aUpVaHhoSEpwSzZKTGhpTGFDR0IwMzNvZ2dtQitlNGhzRFIxbkpXajdmNmhy?=
 =?utf-8?B?dTBPcThCVnkyZ2Q2THdCdFFVd0JBMEpSWVFIQ25QUTM5cGJCb0kvR3ZpTDA2?=
 =?utf-8?B?cmJJRFFMNU1lT2ZvMHZ0dk81a0ZqbG9mUndyQUtjcUtGVFgrL3VtVkxwYVNB?=
 =?utf-8?B?NHoxeWt1NlNjWEVZMDd4RnZWd2crMjV2UGlpWHBKN1JBbVZrb0wyaUV2MDV4?=
 =?utf-8?B?dnNISzJ3cTdraXR6S3QzYVdwOGF3Q0lobWNDZEs4Uy9EaEl6Qy9LL2NQNlRj?=
 =?utf-8?B?T2lqWkYwMjZ2Z2VERGE5L2s0N01CLzlhc2JZRDZQWURzNVVGMWY5TXBJRkk2?=
 =?utf-8?B?QW9KU2UvVGwxQTB4czNBemtncEdzdWNZUnlEM1k0WnA1WEhwM24rMEtjM3ZL?=
 =?utf-8?B?bWhhRkt5Uk8vVHE3Z3FVMEhpRmVzbFJackx5UG9VZ1prcndwK0xJcmhkM0NP?=
 =?utf-8?B?YjBlTm5ValJuMzFESllxUFNXdWhyT1RmOSs2Zzg5Wkl2c0dOVVR5ejJsRlV5?=
 =?utf-8?B?VWV0d2ljQllFS0pWdDlpL1c5WDJieEQxeUduamZDbzhRSStFZUVUTHNUanFO?=
 =?utf-8?B?aUFUellDUWI3SFdjNHBsNGkrTDgwV0lRaGZKbm1mamRtUjRpQ0o5SnlKV3VE?=
 =?utf-8?B?UWY2WHRzVXJzRHVLWDdtbnBsdEN5dWVvZFRlSE9zTEZUSDF4QnlUV1ZudC83?=
 =?utf-8?B?R0lqeDVwZ3lYNHZ6WThwUEpJMVp6RlpkenRVbG81bTBMWDdiWmFjM2dVTkYx?=
 =?utf-8?B?WjZiTWgvdjVzSEdHYUM4b0FWQkRMRUxteFRDT2F6SkhYR1JyS1A3cFFGMmln?=
 =?utf-8?B?dTZtT1JHcm9HMGR6OGFkeXhIMW5xbCsxRGVXZ3RsS2Ntb0JWcm1ZUWFJZFBk?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dcZYa403pNT+E2JrP+mhQUV+YGSRD+a6CiccNKevxWVFp6zm6uwqkiEe5GXGVa3l2VTd0CDiPMpCEoTknlYBLP1ZGZcUYOfijgYSo//3aGNw1kYtBL69nZrTYkXEo+wWNrUKGwozcsvBJEcL+9B7Hh3Xs8e4V9tnX6aXipHTtrY+0jks5jm0xJ2GPbDt/pK5ewqm/BNYXm0aj4/OpYJcoIlynj/ekGpQL1eSDt3feOaPOH6uuEztXWI/B/V8+22Od34LTXSTM0Qba8gViDjalc4S7SADlx7uHU0HcwfqDrM49307r6k4tKmQ1qNpOr/EX4UO4fHOMSMVK2NLWhvzazHZ8ql/wNiGT4IDrbHDfF/vPBMHZwRirtF2WcpEkc4mOQMOQjLt+1k8YXEPdlTYtEQ86z8UNXDkLYVeUSPF3nPrkMlz3EVJXt6w/fyVo5cy2k3BkRMDt0sHBpymaw8PadY4ILSQ3L7CgiQAt3FXYQyr4hKsIxETe+TjJu4rsbLuUPVsgnXVkwrib7kzfnVGvQ+RESyXRBSZpqMXeX6GrvRg/4YcFJ3syX4NzjJchA7z9U2pARx+8Ncxsa0J1jAm6Ubq3KX1UAlQryBiRsWN0T4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3752a9a0-57de-415d-ca11-08ddebc56da9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 15:12:14.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/RtiuEGIW22eslLdW6Bu+0HLnsQxGx6k1b3RnivlHgC4L79ENGl+2qdO4zDe+QX6zr6tLUuMf7vZhYLQtNHx2Al5ezLVo2LpwiWm+gd7no=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4982
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX3RnXmHD9l34K
 brC/aFrIOEPxHyJmFQz1xhravasoX3BRyi1rrhNPcb9KfPVHTVqRxJJpSD+ysfvfH/NgQ1sDIXl
 e2yg8MBn/qvvxMcdFLulUjx35eQQ9/sQknh7OlUPOWdn+hgHpQVUvKXZG+y0CXpjFybG3gh2LSV
 BBpqNJAHb8nEOYw/FjjQt60QwgMlevtetwflSwfwE/tCGdIBcXz19QPo7GfyAgNm80JKbVntDtd
 Q5JngEAqhB6swiQXiiBpBr3YjcVJFM9jC4l0iQmofaQSZVIsn/Qrmy5NYUp70OCdqtfdoxdHKGo
 DzZNWzODG5BtUFg0FhZge4fTeCT1EG0BKxsTHdSFVlzsP8Cc9ExqEVwM5yleCkxdxL1YrNc78Yq
 iqpeLm254Wnr2RtMepTfHr4QmjLjgg==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9ac52 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1WtWmnkvAAAA:8
 a=yPCof4ZbAAAA:8 a=o4FbD61fh6jK5bU_nUkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: FmgY5ESB_iuCuwIUVERU4SHkmfKPpcui
X-Proofpoint-ORIG-GUID: FmgY5ESB_iuCuwIUVERU4SHkmfKPpcui

On 9/2/25 7:50 AM, Qianfeng Rong wrote:
> Change the 'ret' variable in iscsit_tmr_task_reassign() from u64 to int,
> as it needs to store either negative value or zero returned by
> iscsit_find_cmd_for_recovery().
> 
> Storing the negative error codes in unsigned type, or performing equality
> comparisons (e.g., ret == -2), doesn't cause an issue at runtime [1] but
> can be confusing.  Additionally, assigning negative error codes to unsigned
> type may trigger a GCC warning when the -Wsign-conversion flag is enabled.
> 
> No effect on runtime.
> 
> Link: https://lore.kernel.org/all/x3wogjf6vgpkisdhg3abzrx7v7zktmdnfmqeih5kosszmagqfs@oh3qxrgzkikf/ #1
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/target/iscsi/iscsi_target_tmr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
> index f60b156ede12..620de3910599 100644
> --- a/drivers/target/iscsi/iscsi_target_tmr.c
> +++ b/drivers/target/iscsi/iscsi_target_tmr.c
> @@ -112,7 +112,8 @@ u8 iscsit_tmr_task_reassign(
>  	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
>  	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
>  	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
> -	u64 ret, ref_lun;
> +	u64 ref_lun;
> +	int ret;
>  
>  	pr_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
>  		" RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",

Reviewed-by: Mike Christie <michael.christie@oracle.com>
