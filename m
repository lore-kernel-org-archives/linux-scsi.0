Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB1F2C3251;
	Fri,  3 Jul 2026 14:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783088364; cv=fail; b=FtVQKFZvmuZn+CjjScolbJagsvNmW+BPEGVCyKPMFyrdJHivAwVk/nZ0a/qo+mOiV6XG8IyetyPh2DG9ze5or7BOcFAlhIaLa8+LtZZjvZvaviCkjxmcoYihwwxXvTe2mwhzwwoECpLxQCxeR86vXA0qwd5lzif/OBhrLRz96OY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783088364; c=relaxed/simple;
	bh=rLWsdAvyNYgWWQ5pCmuvzkLGUbzGuC7O5JtAAimLA/E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KG1xHSNKjCYwA2OzY0xCNkePkm180JIHKNvGfCq47F7vpSozNG7pYYD/8x3vxaHjgTKYP5p4o0vvEjrFFwj5cyC+ghN4jxfJHR9QJhBX5QIc4Pjkvwrw56MBvTli3LPtVK3dNe4scH9mhkXmaHoDIVWBYHPwSLVENsxu54k8nmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RicVMI2q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BDM3lv/T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RicVMI2q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BDM3lv/T"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tjN63062793;
	Fri, 3 Jul 2026 14:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dkI8ssB8zQ+uvMTMpXJAvnX60NUT46Nn80aqp7FPRGQ=; b=
	RicVMI2qCqyarVDlJ3wKvsUAiGI0PIQlaRIXn6sL95y9tpjo1gpInfFmGkip+Lqx
	D8XpRnbD+iWOvqD3uAGj80ZBiWMiTxPNumdc/5eHBt2SN3d2fYdGwmYaFhiZ0Vgo
	LZyrrbr7ftV3XkMlqlyHEgQwzSCZDIimvicf1u9//JRdhjyThT8YHwPpmQ/glRti
	OIrAGilcz0Lw70a5sGMTPhElvncLuvdMVYDCFOo0FYqOEkCgTELL0J4+cacYfqCj
	Qwnenmm94wcnkYD0hTc6zS91Io0qAnu6CmKTQEIBPu2Y7FjfAhDWddiK7KPWFHXp
	i+f1lmVdVwPgbYTObh2Z/A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1awm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:19:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663EIAKt037342;
	Fri, 3 Jul 2026 14:19:20 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yv4my9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 14:19:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnEGAKT3ML0EuGkbUsRq1YYK5ISMKptPf1EM7DTNrkblO+FVq9NlFbeM3wklpPfRecK0wOz+pK2KXxN/rTsGxaUT+TQ7DXZkAtX50JvjfX4lo5MnFpDKseQRiUN1n/hQUT5/jUgLqRETrnZ3nNGLx4VlFE1K3P06dFynjAqP9OF82C3MnxN+GIQJpekWGqrVm1R6+r2cK+Lr/LkA3MKPTVrQDivRCQH9D5cWoGtroOBK0R1ZOtIKPw4WXcGW0f9kCi8kuNSKiBK49GNVbL+mXAcsc/1PhO6geJgY1AKUZR7FnjkokWlXk5s16bPL4nPiG4/PS3UNM3D8S4RDpz2T/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkI8ssB8zQ+uvMTMpXJAvnX60NUT46Nn80aqp7FPRGQ=;
 b=OYpnRnhgMcDVYZyDQ9b6B59rFv5dSFI3IScc4PptG2Ghca/VPZdL2TteMhiQLmapjNDUJ886FbNPSKwC6nb2emo/mVA7bryeB5ByeO4ZFnQoWoxgEnt43/YrUBMrGkWqO9W4L2xiWBZaR6IOQh9DlpXaxqNb8pF4S3zTWzw+jFVP/bc1k+BDsJLaydagoc5/mAT51CWIT1lZJ3HuY57K+eoQoSesjk5uFiaZIOlcr9GO//WKCvF4Mpjn4ctqr2MDkcJUYrbAr55bjMszF3vADkGAGICWPxKs8SO+v/c12Lvc8NKfr9AGdTepi0ufSpROpUES+PuC5apWfRsHRgBSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkI8ssB8zQ+uvMTMpXJAvnX60NUT46Nn80aqp7FPRGQ=;
 b=BDM3lv/TjPifOjyQfSU554s3TAVR2rGyzQu9HkEzyAyXht6XPDMZTo68CrvOkMtPtSZhD7Fvcg9OZXsvMF8YydClvrv5/DeAR9Su6Q8DvhdoYiywe6cicNUsZU1QGFXmbVlU+qwp5sXeOiyozW+QUXpd6DxHbIF+7iOBSTDJHo4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA1PR10MB6390.namprd10.prod.outlook.com (2603:10b6:806:256::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Fri, 3 Jul
 2026 14:19:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 14:19:16 +0000
Message-ID: <05c64aa2-ac5a-47c8-abac-0f72ac503b92@oracle.com>
Date: Fri, 3 Jul 2026 15:19:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/13] libmultipath: Add basic gendisk support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-3-john.g.garry@oracle.com>
 <20260703105132.44EF31F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260703105132.44EF31F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0377.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA1PR10MB6390:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d2b9a21-1a55-48ad-5693-08ded90e108c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|22082099003|56012099006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	LCVrq96uimuER0ThVBsTtaEwofMU1tQDkWmJbYAIYewivK3UTg6pzFjvT9dc+zmPa2vNUerAGWOSfFVhVRZAE7xoB57F/9SmRklZe59PMqxC42e8yKSkCCF9TyXEF9I9eeNc+LT6ReJPKMsa8Xh0ShFQ/61no3+x9nV0eKL/d0Mm1a4svRkC/65/obss1QyqjznRKBJuSSPJMOyyVfTdpmasqdOZm1PHjqTSG8XVSZ8X5RUqyslzwRPYFpFDfgqP9tPuBiAFku7ZA9ieQvNaTvcCL2TTi83JCMbqU5Qmf70A3cCLjLleU/t7tpmIc8RIj2RUmPGnFjNScq3eC9LM9KN7pyRjRkTrJPYZpirEHDkF2jsSyDzJ5uvqxNCs8qDIvwxgG0XHlPpkcyrbRmbGrDeklO0k9sOnvA8/nAw4WFreRG9+RylSeAlXeJSEsDZ0w7P0srxSwYBImX97T3Jz1sTAtSqzTPL3LBVrAKNycnCNpwU4hRRteMxpO5GkUgosmmyANIn/qGg9TLuXR1FEwwnuKxos5Z++WODDLbA2FuQsZlBkwRM80WlldiPl5fS9Pf8wq3wrGNwoiCRkLjlvOwIqrWGdq9mJnqIDDOrSok/8z7JAJ+kFY3mA76EL1frxfv2Lp3pPKsI4WCUv3hOWBYThU8Sh+QHijwt4/uw52Yk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTl3aGErMDRkL2hDRDNMbGN2SklMV2FEUS9rQWR0MFEvYVNqY0hRRmFDVG03?=
 =?utf-8?B?cm5jb1gzd2UxUmZzY0lWclY2Tk8zVjFoNkJscyt0dWNkK2kvWlI1d1lJUjIv?=
 =?utf-8?B?aTlwMldydFJyRUUwSlgzc2FlWE4zUGx4dmxtd05ZQ3JTbHZuRGNUbExMd2o3?=
 =?utf-8?B?aDBXSUg1WHh3U29SQkpIeFVCMlZrbUx1SGtBSkVjb2YvaHVJbDV6NnIyTWtC?=
 =?utf-8?B?TXRVUHJDZkIxL0o4RE84QVJOWkZUbCs5MDhWTitPZ3RyTFV3M0dMWG1WSDVt?=
 =?utf-8?B?by9qa3JhMGxPRExRVkxFWmxURXJhSzBhaE45QXJEaTUxWnozcHRXajFkOVBN?=
 =?utf-8?B?eVVYeUkvNGNiR016SEtFSnJvcnkzOENDb29qdTFIVFhxbG9QdjhjVUZtZU1u?=
 =?utf-8?B?eGlldnJPcEtFV3lxZGx4bFlGWHkyOWg2Ri9tb0w5ancybGdFaXkzSnZhU29w?=
 =?utf-8?B?VU9Wekxla0swQU5vRzk2TWtlM2lKSVZ2bEEzdmI3dzRkTVA4ZjNLQktudEdF?=
 =?utf-8?B?V3A3a1ZkL3JoWStQZDlZYW90NW1OcG9TR3RNR2ZROVk5RUZZemVRV282N3My?=
 =?utf-8?B?cU1MWVdhQUUwd2d6TGU3V3FNTXBOVmtuclVXUENjV2xXek45N1JISERkb1ZD?=
 =?utf-8?B?Mi9hNk5RRTlLa0I3bU9pbklVQ0h2S00wNjZsS1UxNFBOOW1sbE1GU2JiVG5N?=
 =?utf-8?B?VWlGNUlVMWRFZVN4UTFWcnpQMnRBZE1nbG9icUtPTUIzVWNSSjZuUGkvaHdP?=
 =?utf-8?B?dk03aTIrT1ZxM0IvUmhlZHViR0NzOXFhcW9qV3YzVXo5aXhSamhjajJIQjBY?=
 =?utf-8?B?S2VrWDBmcGV1UGZ6TWFBcnplbmZYTVJuWC9nQXR2eEYzb05qbmF6Y0Npb2lr?=
 =?utf-8?B?MkpQSFlYREZzNzI3TE10N2NNWkdZc3RLMWlsekJZVFZ2Skx1cEhwZU4wVGdM?=
 =?utf-8?B?NXZsMTc4bXdGTlUxZmFlaDBWSWRzMGgyWlQ5WXVYUDNuN2JuUHNaSnozeFEr?=
 =?utf-8?B?Z3dDeDNheVoxZTZWQm9mQ0ZGWE5QbHBLK0Z0aElwMFIwSTJpL3FSanNBNlNw?=
 =?utf-8?B?b1Q4ZnZ2R29lT0VGb1QybGM0VDVueFFkQjAwK25LRzkyVHJ0RmlhWVZFcjY0?=
 =?utf-8?B?V3JBVWR5ZEo5QTNYN2srQklsOGd2MWhZWnZEbXJhdi9EU1JVc1lmZEVjVVR2?=
 =?utf-8?B?cWdHZnVUK0pwS3JFUGJPSWtCZ0kvNEp6VUY1RjFkeW1SRXY2Tk1rTGlxbko1?=
 =?utf-8?B?U2pobXRnTGRZQTBPajUvV0NDcGpyY09od1ROTWQwc3FYRGlhSHQ5U0xlV3FW?=
 =?utf-8?B?anQzYm1uN29GclB2UzdIeTZhVk52d3RvbXZGY0drY1laUG9sTXozeFYwT1VB?=
 =?utf-8?B?SzYvb0pnL3h0eUU0c0gzcjZSL0VHTlhCdmdJSkUrZHBUQzU2QTh5a1ZLemlC?=
 =?utf-8?B?VzdoaDBBcjV3bTUwYW5mbzM1OXVrU21OZXBabWVIMlNLbWwzdW11VFdFVHNV?=
 =?utf-8?B?cVdkd0NSbCtxY3c1WXg5aVpPbG16bHZDemdiRzdranVEWU40YkZrTzFlZ291?=
 =?utf-8?B?Kzg0SXJPOTBmMlMwUXpxOElqSGI0aWo0M3ErQm5vT0wraUNWbHRVaGZPUTNT?=
 =?utf-8?B?VURvbTNwMlBseVBqZlovWG1ncDNSdnlGQUlONW1Oai9aWk9wUWE1Zk1zcUNj?=
 =?utf-8?B?M1dDNGl3d0JPanF0WlBtYUVTdUt2UWRVTGlpRTgwMHE0YXdNVWlUTVFlTGdD?=
 =?utf-8?B?Z1gxSHBRczc5RWRLSWt5ZUU3TFRlYzYzOUMvbE9oWDVrSHIyZmpZZXk3YWwv?=
 =?utf-8?B?NVdhZkxwTERNMS82cDJEd29mSXgvekx6eXFrcVRQS1poRU41RDNkNzhiaVFV?=
 =?utf-8?B?aWZOWHhOeS9nZkxNbXNyOWZ4NC9vRmpob2xtbmdoLzh6YlVLLzZLUlU5UGJt?=
 =?utf-8?B?cGVPNE9EWXUwSFl6R0lVRE44TUFweU5GbXJVNk1iZjlPWDVXZDZDTDNHY3Ex?=
 =?utf-8?B?OTRyR25hQlhGbE4zcldBa1dOOFlGS3JDWEx3NThJb2FXV1FTT1p2WU83bmhH?=
 =?utf-8?B?alpSdEVYZ3lwdEtWekxYMlVLRkZxMTE4Q1BZaDhxR0c4SytzZSs3cGJZc3Bz?=
 =?utf-8?B?R2I4QzBYRTZJbS9FVWk4TGNtSHJ4ZTZLcDl2RTd1K2YvR3dBMC9saVV1b2pl?=
 =?utf-8?B?WUg4UFJVeHJWbVROT1pmejB5OUowUE5NSkpmcTdpZXlJWVBzSzlJUmpyd3RX?=
 =?utf-8?B?bG5RSEZVaG1RSWZqL20vSU8xZzI0dkNnV0Q1UkxUeHE3Zy9iQ3pwdXBucWRN?=
 =?utf-8?B?aTZETnBibHBSWU4vdmE1dW4xLzhNQmo5UnVkMjJ0SzB3R0JIbVBraTZiNm1R?=
 =?utf-8?Q?0BfEArRSxm9N2kmk=3D?=
X-Exchange-RoutingPolicyChecked:
	MONlwwKYDiKXny+OQrJIzR9dMTpd5d5XX1JkWbAja76naKWKgPQf9aU25PD4SSJFGHoNLZJlzU6wyB7f6d6X5WCmRMIHoC/2ueCJkjz8mmYIQAX8l1Fe1TNwaIXQ8Ez0iScnWDuuC8vJOM6PVgI9SUR36gS5dDPdVayzhEySIU3wruBLapAI/67w9Z0/KdTlIaIvrnJerbq23+7uXIrDe2aPYcWmpttN2IWtjNNST0X2ffYEv2zmbhl1H89WM8yXS9Yh6qB8NZDIjg4OUM0oU/6vyCGasfrjuR5KtjsMERKk0yibEP+JWUCxAaMKMghBG8W+0IebxbLkcwzgx1ymVg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0nocFwa0eFDilm9EZanRdr21NXPfjkHAaDqslktEjzkZ/393T93XaAsAwi++MSy0LUwze9kruA3dtAfr+BpzQ5zAtj0xtDPYAsskK+/bZogVpz9rZkVWex8rMgqsahdvEGoDKG3mk48u2lFRiry5syT70p73N5T0DPkCabx+N7PhZBCTKMwLXdxAk1aXSR1PT8zL7dszQBTvQTd92xiziUeQWUjMqyvpvBFqN04r7w+95fjOLJlBUhFkyJS2mnp9VgZqOi+B7zEwRmJRG+jwuN8XqWHyIlJ7kgT0kVOcjZI/1jbhrkFR2z8bgSL2HIRbmEEFt9TL01M6vldgo2X2oS54PV7CS2ErRkhxRMak7Rmc0RjjW6970bdNag5zfjffoRzB5EzxSKmbzzWnrsyTe0Wsd19FGbebmB2wOdGt79/9evUJ4MZ3CY3Z9pMCCBQt/44AOoq6i7/iD7L3OUgMf++0iECJLA4ByK1Ae6gX6WJevP1yjY+2jjnRShwHUVNFkbpqhM4hXWHHwA41aY6K7BCyik0gPO/OYRw6VXkCSPWU7t0r96PZ0WlJ0FoeqJAWDWVy0zzUoR+pImLReloPcTQtdVIiy/UVSv/XRfUHxv0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2b9a21-1a55-48ad-5693-08ded90e108c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:19:16.4987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okVzDs4SsdbEP0lgY43oAYYJrWt8apuAcKuPxQUuhpD6wDnhWvYbFjrJcK7WhrBi7Wb7VbW9E/QdUGEVrDmUVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030141
X-Proofpoint-GUID: JOHd9YxQnhvzf_bAv2dbLcjCTiATfoLE
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a47c4e9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=cnqsXEoGuH8jo6duWb4A:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: JOHd9YxQnhvzf_bAv2dbLcjCTiATfoLE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDE0MSBTYWx0ZWRfXwlwo8TvLu3rn
 fL1IcUmOGuNb28ttDTFK3+FPbMqK6HeSJrDST2ZSP0LPDNSH3pViukghInMgdCSzHkx82zRfPaB
 GFL+RgwHYRxyoVsMwlcwPc82mBd/jE3CXqDdkDcS3Wj6iiKZMm9a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDE0MSBTYWx0ZWRfX3CvUDmLcWeKS
 7TM6orKq2/UE3VwVcKw94pE5uLuWOBQBKGWogV3V53TQBojl2cQffqCXz9DoRCac5GpNEevk7eu
 qWEhNFbEfa7AeW/kumkvw5uFCCSsMHYDrnM8QRzs++CjzTs8mTVR+XJTq8qvUZor9U2aaL98enU
 PeYtZUsAXimmTYtiSVGzMeSuJw1DGwzmJLBy+z7ramvMjzOH+yP8MSpC3Q3GVT+TwTD52xdNad5
 Bt+6AIsWTEMqkQQziXS1xlMEhs3jVvsObDOovbcsM36qgrZsOnCtGWLZubETcYeVZtRioCbopWA
 AFjE+ktNyXS+fM3FWGwaTnBTnfpC44aE3m5k7BVjZvqapTe3OwvfEX/YwXUIXaWB8ou/jhH87lk
 +yQtuDcsoU8XYZRQQPOyqKNI5RmcCr6TnSkY7szcbOpBiPVJ4X2L3eUIUmo2TDCzc//j9pws4IS
 IVAcq9L825UJw4ClKWg==

On 03/07/2026 11:51, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] `mpath_alloc_head_disk()` leaves `ERR_PTR` in `mpath_head->disk` on failure, causing a kernel panic during cleanup or state updates.
> - [High] A TOCTOU race between `mpath_device_set_live()` and `mpath_remove_disk()` permanently leaks the gendisk.
> - [High] Synchronous wait in `mpath_head_uninit()` allows unprivileged openers to block device teardown indefinitely.
> --
> 
> commit bba05c007c446cdb19dbac857c9ce717ca5f2a08
> Author: John Garry <john.g.garry@oracle.com>
> Subject: libmultipath: Add basic gendisk support
> 
> This patch adds support to allocate and free a multipath gendisk. It also
> introduces struct mpath_head_template as a method for drivers to provide
> custom multipath functionality.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 009d4bb875c6f..79be84d3d4f75 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -44,12 +44,111 @@ void mpath_head_uninit(struct mpath_head *mpath_head)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_head_uninit);
>>   
>> +static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
>> +{
>> +	struct mpath_head *mpath_head = disk->private_data;
>> +
>> +	return mpath_get_head(mpath_head);
>> +}
> 
> [Severity: High]
> Does this increment the refcount on behalf of userspace openers?
> 
> If unprivileged users open the block device, this calls mpath_get_head()
> which increments mpath_head->refcount. If the admin later removes the device,
> the driver calls mpath_head_uninit() which synchronously waits for the
> refcount to hit zero. Since the user can hold the file descriptor open,
> couldn't this allow unprivileged openers to permanently hang the kernel
> thread handling device removal?

Userspace can still issue a syscall which can reference the mpath_head 
structure, so we need to guard against that.

> 
> [ ... ]
> 
>> +void mpath_remove_disk(struct mpath_head *mpath_head)
>> +{
>> +	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
>> +		struct gendisk *disk = mpath_head->disk;
>> +
>> +		del_gendisk(disk);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_remove_disk);
> 
> [Severity: High]
> Is there a race here with mpath_device_set_live() that could permanently
> leak the gendisk?
> 
> If Thread A calls mpath_device_set_live() and sets MPATH_HEAD_DISK_LIVE
> locklessly via test_and_set_bit(), and Thread B concurrently calls
> mpath_remove_disk(), 

That should not happen. The driver needs to take care of concurrent 
calls. In the NVMe example, we remove the NS head structure from the 
list of NS heads before we call mpath_remove_disk(), so no new NS can 
call mpath_device_set_live() for the same mpath_head once the disk is 
being removed.

>Thread B will clear the flag and call del_gendisk().
> 
> Because device_add_disk() in Thread A hasn't completed and set GD_ADDED
> yet, del_gendisk() observes the disk is not live and returns early without
> doing anything.
> 
> Thread A then completes device_add_disk() making the disk live, but the
> flag is now 0. Any subsequent mpath_remove_disk() will do nothing, leaking
> the active block device.
> 
>> +void mpath_put_disk(struct mpath_head *mpath_head)
>> +{
>> +	if (!mpath_head->disk)
>> +		return;
>> +
>> +	/* make sure all pending bios are cleaned up */
>> +	flush_work(&mpath_head->partition_scan_work);
>> +	put_disk(mpath_head->disk);
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_put_disk);
>> +
>> +int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>> +			struct queue_limits *lim, int numa_node)
>> +{
>> +	if (!mpath_head->disk_groups || !mpath_head->parent)
>> +		return -EINVAL;
>> +
>> +	mpath_head->disk = blk_alloc_disk(lim, numa_node);
>> +	if (IS_ERR(mpath_head->disk))
>> +		return PTR_ERR(mpath_head->disk);
> 
> [Severity: High]
> If blk_alloc_disk() fails, does this leave an ERR_PTR in mpath_head->disk?
> 
> When the driver cleans up on error and calls mpath_put_disk(), the
> if (!mpath_head->disk) check will pass because the ERR_PTR is not NULL.
> Will this result in a kernel panic when put_disk() attempts to dereference
> the invalid pointer?

We don't call mpath_put_disk() for a failure there. In this case the 
caller should tear down the mpath_head structure.

> 

