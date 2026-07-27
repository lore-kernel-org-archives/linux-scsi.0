Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2872420499;
	Mon, 27 Jul 2026 16:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169140; cv=fail; b=e6ARAYYgotnuOX1mCfvjJ/glVpribHgHqWNR1rOv87E4JNJZAikEpa5AjJbtu61VJeJYccTCW6n200sE/HK8oH6dlwJUkV1+twjAMxJbHflQLNaoTZ9VIey2SQBzlSFxHMgCSCkn1t0ao+Lc6loJsiypyYBXkiTA/ZBmuOwDUB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169140; c=relaxed/simple;
	bh=Ur2aGr20OUQRpLgIwlhctG6Ysof7D59vdsQfgijSzos=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OPm1fKEo53WXnTgV3ZO10mn3+jVImeYqdLY0QwyGRCYNyYM12pOzwJUidHv65QhR0T2wz5+8ZBihIRZNdmnOebKGXDVOWXtcHnooiUQKt+zH0N1N04vS6frQ9TCaE1Lw8c89DdPwurYsvdIQJanbx4ij6wxbPp8bVm4bXTnOsPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WJmT/jp9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wB5B3UZg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WJmT/jp9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wB5B3UZg"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RGEVhl2481750;
	Mon, 27 Jul 2026 16:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T0ePMPKmgN0IDgU6aZTtV0nDgI0dMBZR24WG81Q+k4U=; b=
	WJmT/jp99KCTaMOImbKfCXHvkU2r2rG4oE153rHlCQySIfP/Vudl7C2FW1YPIx0n
	8OLnCOnJD2r+VW/zkxEmdA+Xp9AV/7aiGwW+Kg+q3BX3mZBGrq6/gLkMtHnXfNUB
	Bjq2z7AH1CN9b3pDFQ6gTIEbHtmlvqFzlJZqVL8p7xD50mctGcQqP4IcGt9eEmCP
	PNUVkJqf6SPeAF7k5CK+0+3v7hN7nHdnZjot2FAlEVuXe8POv5VQODSlvnPKPkZJ
	JjIoqytSmLl11tduH1mPjv/VJm0qTd8Dgt/smcUOi0DAkBLU8VrFpdWlD/9ki2Ek
	cr7V+H/B/Do8/6ZW3qLXnA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym24nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:18:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RGC3gf004177;
	Mon, 27 Jul 2026 16:18:57 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6nmv5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:18:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lxnKeLqnB26lQALnDA9DdUyek+y0FDheS5TUpAsetF2RFnmnjOZzNUHw0r3S6VG69L98jeBGOngtZN9NYw4tK98BMw/Ub0hYIiZT3i1M9WNl+VvpQtqRIDDcEa6dDbr1A1hpEUDNCsYlpSlpmzz3XrukLiwOR6vGH6svy00y+qpQinGWjYVyCqSQoruvZA4pd7bHVTM9m5UqLDrhozZ7h0s7rk5gf72C60zz56miWJ3DDoLmyUNSBwxIU4YUvnPkePTYe5K4JRQ2JwgrNXP1M2pQjSd4+hpOOQ+yQMvHMdS9P/wmtYQlQc+KPZuxehLPG7/X+Etxry9NbrJb8W/kgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0ePMPKmgN0IDgU6aZTtV0nDgI0dMBZR24WG81Q+k4U=;
 b=hxGR9lUnLLF46fQAoyKtveIyJaEYh/M09Yo3jv+i93p+diPHOq9MZRyc8wy+kFbV4gZjsEDBr7ZWCin7BKHaeKnUUbwCHHXoGiznRKSXaliNKCHpd6rUi3gTNGVt/VdCwgeQvbmcMmv92J1RnUX1/ba4AMuyKxE9KGJZtsbgjJ9mOk9boRxM2dBFIXCg6wN268+k+/dQ+mMGw4cCSdFS/5DomaKyvALtSsMO9+90yBJZ/jgnX6y60tXIkSKqTXlfYd30MlhR7CusPBMNiMsiCUdRSrEin+sKDJat6WQ0JMGndLzz4KlfiSx9Ev0edPmzcYViPvYNzpY0qEAcOVysFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0ePMPKmgN0IDgU6aZTtV0nDgI0dMBZR24WG81Q+k4U=;
 b=wB5B3UZgxLfjbyDjGsyrTxEdwfNM8OV6BtbIFFW0I31TZlBsJ2Ru/VymuOZ4FSyFFo6FZMEZYdZAdcCvHpJjMOywVpz0chzdhXh9Jmx1eUmJQdA/JYawP2ohif+yBBuhURpTuJLWFLeJFvVLbuBC1DLipD7ouOaROCsGuliZz9U=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LVUPR10MB997810.namprd10.prod.outlook.com (2603:10b6:408:39e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:18:54 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:18:54 +0000
Message-ID: <227ebe84-9623-4f76-b8f9-5460dc67503f@oracle.com>
Date: Mon, 27 Jul 2026 17:18:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-21-john.g.garry@oracle.com>
 <20260727152558.3565D1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727152558.3565D1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0179.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::19) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LVUPR10MB997810:EE_
X-MS-Office365-Filtering-Correlation-Id: e737d51f-0b8f-46f6-c038-08deebfac094
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|56012099006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MGVMiJoSznuvc33ejT2tbXudPdlbyWwH4hj0QDaj9Rn2QpLBvxgcLcXR2u/UzRXNoCdEv4QZzwfs7EXg2aAfSCWgXJNi+ik5xkXK0yRo36+x6ZnZhWaNzPrj+cpDfflmjifXjAEIwOq8XVdWDsnIJOReRHlgdlGJ1ksvyZSNjy9yQ1QsnpLEd5Szz8FZo7v5QAm3wUJ60ffxKYqiZxn+ymKcC54est/r8P6cHNBj4D+QHlyeGxLZm2iuWaZSKui3W8dWhknNkP/WLdw+rMSu+5+5oVUguTgLE1Mt8G/f/eszeCWkakLTVP0BS6SjCK5G17y+i21sQr+l+ZVF4WAVRPsjNw4IymHckRdzSi8q/RYQkori1bj471jIrchyXcNbQUvbREtweH7lPE/F1lo7ycPgdEaAPOOlvwkW1xYCYLHOfKw+9XeIe7PygzgxQz2fOXnK3T76ECdRSachHriPawx3cbH1qOna9li9aJGeqaKfx12lBKdKBZZfgs1sTlT2W/oyHObpT4sUwxz7a6BcToNMewyZfR6zLTz2rhVvj7nSLp6PELma/6pocliRkgYv6TKs+4cD+BT5Z6vVPwnwj13LELq9H0unSvu1xNBI1okGncTsdhDlQyOPqud0I31lyMBJoApeV3I8rTMvi6zbhs8wSNyi+tjkyHz+3IvkD0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWFHWG5Cay90ZWkwdmx1MGdzM093bnNJc2IzR3E0T3BJQkhHNkhWZ1krN29o?=
 =?utf-8?B?M2t4NVBVK1h5U0xVajc0czNITFBlNVQyN3lGQ3FUdENlckgwVFhCcG5hZjJl?=
 =?utf-8?B?MUVnQXlrTWl5ZG1yTWpyYklGL1ppY1VhTlhzS0FGNXFOOVhKRGxzNFpvUldE?=
 =?utf-8?B?UVg5WjVjV0VtakhxUnliSmNpVkQwNlRXaTJLL3JIZTUwcjdkQzJnOWUra3VZ?=
 =?utf-8?B?TC9xRlNNa1FUSWY1Y21EUWpaRWdRTkprS01JWkZnWmJlUHp3amxXT1pBL25S?=
 =?utf-8?B?ZTBnbzVtQUxKelUrNUdscW4yU3FCamlzWHhZc1lBSGdlZm9SUzNybVh5dEov?=
 =?utf-8?B?eGFtdFg0UStqUWVqZWJrTU1RckY3MVFRdmhMenVaYzJia0g5citZOXRVRG9u?=
 =?utf-8?B?YkhEcGFDV1VXa1IvQ3BVRGZTMmFjLzlhYm12V3FERm9yNmZ0RlBxajRRWGoz?=
 =?utf-8?B?dWtULzBteXhzb3pIZWhZUy9sd3VTOHovTElIWHh6YTM3ZzVlOUNFcmdTU3Vr?=
 =?utf-8?B?WDJKbUxaUnlQaDFEMTJKa3VteTd6VmhwU0RHV0R6TWxQSFVlQlBmM21ScGt4?=
 =?utf-8?B?SzFteUlESnlDYitIWC95UGdpZXFNYW4rTHpYR0Y5dHBGdkJxVEhmM3c5LzVl?=
 =?utf-8?B?ZDBscDJUMnZpMVhhL2FRVVd2SG1BQ2laSEhZK3E1QVZ6dHU0eWd1aTdXdnE4?=
 =?utf-8?B?b3BNYjBtVGZjdVIzd2JXaDMyTzQzNm43NWxBb2NacE9CSEF3MDJmZStUSjFB?=
 =?utf-8?B?SDFOZnBNMWZQa3BYK1J6ZXdTT1o2bkk2UjVlWTBrYmdYSUZwdUg4WW1UUlZM?=
 =?utf-8?B?bGx3blNwZ1Q3MFkvZzFTTlE3ZksvNTNPbTBHK05qYXVlbHBab3lER2hXMVlZ?=
 =?utf-8?B?OEZQWWZnNWJaTjI2M1had2pDOWlRelUxRUo0RTI3SlZURlhzUWZsc1RoK2NG?=
 =?utf-8?B?K0x1R09tUER5NE5jODI5anBNSmRlelJyQ2lNbVNzSTc2K0x1MEJLN0N2NktH?=
 =?utf-8?B?MkVvRU1UWWZVelQrS2xWbVFmUHU5aHgrR0YvQ0htYmhaeEpwUEFkejkzTFIr?=
 =?utf-8?B?eElHVG1XdTVlNHM3OEFJa1FraGdYTnBCSTZnSE0vYVQ3STJMeThCa1NxZGh1?=
 =?utf-8?B?YTg5aHBrMVA0cE9YeWlPMHIxUnR1Uk5MTFNvWEtjb0ZJUnAvR0krY0IvaTk3?=
 =?utf-8?B?NThvYUREZkJZRGMrT3dST294WG82NzhkSnVYNzJIQUJVamRCakRIQ25hY1hu?=
 =?utf-8?B?Z0JpWklIYUxwSmk0UHBUcTFRNStCSmxPZjF2L0JJblJRaGFyYXdVeHorQjgy?=
 =?utf-8?B?QzQvQU54L0k3TTVyVmUzdnFsZmdBaXg0YkY5MEdGTmF1aEZXMldwREo5K0Y5?=
 =?utf-8?B?dkNPeXg4Tjc1RlF1VmxpMTVnUVF4S3BqVnFwNVN4WVU5YWVhQ2x3T0duNndo?=
 =?utf-8?B?akpzUHlObjVocjVWTlBYb0NzbERHR2hzQVl5VTZiUFhNVFZhK0lVamUreGUz?=
 =?utf-8?B?b1lCckxDemliaHhSa1piUkNnTHcrV3ROVjBHWW9hRHFnK0thODJzMGJYSk0x?=
 =?utf-8?B?bFZpV2JoUm5kM3dyMjV6SmZmRWtETS8wQTFBZ1RGbXphbnNzMzMxLzVoSUpq?=
 =?utf-8?B?emlrOGRtRmM1TU1sV0t1MDV0UzJhZ1Q3UStaclllRVRiU2FlNUFMdEFOVGNz?=
 =?utf-8?B?dnhHcUlUdDRWZXM3Qkd4OWNBeG5yMkRYc0hYL3d5UkZXMUhQb0lWdzdmL1Q5?=
 =?utf-8?B?eTNTZTkrS1BPUWZPM0VjclQ3cVBFZC9ZYVpjcUhKbkUyOGxHTEJCTjE2bXFY?=
 =?utf-8?B?R1hWSkhJNG1qNTJHL0kvZFRMRy9taEc2QXNoY0J2d3pKeFVDQUJPcHpOSmdj?=
 =?utf-8?B?eU83dTRZOTJvWG11S3BDS3J1U3NvU0Z0T2lZUkZXNHJaQmVhZHQreUhKR0RU?=
 =?utf-8?B?V3lmSXNFSng3d1dMYS9uTG1xWXlXWTA0dGwyeVB6aHhMWkVXak9HVlRRbEE0?=
 =?utf-8?B?ZlNSdUdoMkMwQzRFQ3AxdVlyR1RVV0syTDNiNnBsbVQveEttT1RZMC9tYmcy?=
 =?utf-8?B?eHVwdmJpNzdKK0h4UjUyRVh4YTFRZGxpeDRMWjQrcGJZZGJhZ1gybkhqMjdL?=
 =?utf-8?B?WDh2R0N1clJIaFh4QVRYMmxZRThnS0F5dWhVcmwwc1VBWm12TU0zNmhWWGVH?=
 =?utf-8?B?b0J0WEFkSTBWSEJLS0lERFAxT2NBc1k1MzYwRHdoZ2pOd2JKN2taeHQ1c2Fv?=
 =?utf-8?B?dS9mV05hNFNhOTJKRGVEMXgxUTJyUG51Y2F3WmhFYVB5SnBCazNnZERkZ3JN?=
 =?utf-8?B?S3M5cTVmTHp5WlJIYXBNSWxSZmRaNkE4U1NBQXBTdUdsdi9JSTcwMHN2K1NI?=
 =?utf-8?Q?br5Qbad6cgVJ/SrE=3D?=
X-Exchange-RoutingPolicyChecked:
	ezqDSTWvPpdutOKJo8v63wzxAPp2SlD3b29sofo+yIsEwpjo+GkJeBmVj4g3NWt0aq8gducobJH6TIb9JgtEroL1F2FcSYMaUHi/xbkmMS4RaPmi1QQqu310cTk+GXgeSc9n1KYNkrfDY+VTyY0YQNVSSGbljBXoVTxHCAWp7pNMYwlOdYEG8IhjndoMNaiuBt/vClxzZV+GZa+qNCs4AtBpUOAZ1vjGKigkJIvUR7DclrOkXJunZh1BT5eiN5YsU4jMeDOqaoCbUeSc+0FGXx3S1XzbENAH8TG3X6d/rXhNHdiLBYt4zkP2BgFzdULA2W8KM3ygs3Refvr31Kw2bw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6oJ+4WpeZXac54JE8XoWFmiBnq/0kfjR6y31I7pc8ym3ro5S0qaVek6U7Wv7aPaEvosEeV7O/czWKTjNrlbInrCOifJW73DycmX1FvMQ8mk7bZ0FhsE5dIuSZJ7XoQ9mP0AiY5sE3goTFvLFEUkiB8Kmg7zAbNppql/+4kXMfGVTtSCa9GzBEzmdFoxeQtDsacSI+9cYfCNsMK8cHm9MlyMQSqKMay+9gEijVZBaE1nYsRQi9Kjhy+huy/ffLGtB7H54IpBzem9FX8Pf/mtC2qChiBf6sXrBSaSkkdqDug5XPe6TLxXksner+7Q0PahE/Jv/yYHKrd8BtBloIoQqTifcMzZ1ZYCyxkseEOS/qtJvDppoW4n+2xgmfvqIQcPotahdjT67cWJ8E0XFv/pDBtM1QegBuAItzg5Ycqdcp2r7Y+XItPb5DCEAamI2ShghtLK5prvBIgSx3tsQ8s/r8CAWCGxETB2uIsUWXT+nH1jCSJmZ394Vl0n8VsETwtQTfAy0y/uRGLFjiVIGjetp52vy4Dc3N6BbdFv5rxO2brqmtJSdWo11hVbVG99tYQDfx7YdILdm1V/XrQd3YTtyk0V4TWtapc8gQjmrFZwksDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e737d51f-0b8f-46f6-c038-08deebfac094
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:18:54.0671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7K2XLE48WRYYKNZUx4v+Du0aYdfTMVAq+ExmYaysBtQD7C1UtYtfxwaA+Io3ZETReR8gYgGzZxM8NYZjsv+lFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270150
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfX4iE6dG2xcjfu
 BIsvcQKN3am55nlWv34l3fpLtPWDd2ok6/Bo3EkAZCOEJJ9xkyGCeb+Prs6NIqBjOxTP31ERX4e
 SlIn2bcLKWAhRh9sfwbV801tRtHrXcj4endpZGBuxNpFiNDmqTTx
X-Proofpoint-ORIG-GUID: SoWEqUL9dYU_MKYSeGPh8orlye_8XRAC
X-Proofpoint-GUID: SoWEqUL9dYU_MKYSeGPh8orlye_8XRAC
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a6784f1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=XhJ03gSbaCe4MoQZYf4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MSBTYWx0ZWRfXzSniyjnajh25
 KPtN5vsuCPI7bTZH2W9JvnDzr7sCcmmcHQcLbkixF76MnKxlAqa25UcI0Ota3QgpYcLx7FBED0b
 iRnbB9ZR2afTQ7t3bYMFJsyfCqLq134pg8McUtNYNTUYpvIQvjd4UQ/Fjt1HVJNqcRrP8e5XQMC
 ykKRzid5ufd03Vb6uU32sM+sDEa0ejXc1U1cqA++5TpXN2AT82Pa4ncLr9bHnXNKXQjHB/YpU/Y
 H96uoHjWO5ApfH8XqALo5C1U+g1afPp/EsaO/DNPH/lSB2DO8fu0T2wGxpvwIkpOb0EAPzv1MOY
 IPZNOFbIbu/qBFgExhiwznCMhroSt6TDcIEMFYenQ9DHFUewLAanQuXuX4I1Exub0yvAndA13+H
 xgX5B5cZsO8hY9yb8Gn1ziXrsd6GVEX3xwSVpIgT0EVIWiZktwRxDbgxIWozBOtx7/Rykt4apK8
 o2ElKaBUI3AlHG58YD7/Uni6K8t0426D6WnytIFs=

On 27/07/2026 16:25, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Synchronous dispatch errors and request cancellations bypass `scsi_mpath_end_request()`, permanently leaking resources and causing NULL pointer dereferences on recycled tags.
> - [Critical] The dummy implementation of `scsi_mpath_end_request()` skips `blk_update_request()`, silently dropping bio completions if CONFIG_SCSI_MULTIPATH is disabled.
> --
> 
> --- Patch [20]: [PATCH v5 20/27] scsi-multipath: add scsi_mpath_{start,end}_request() ---
> commit 375ed243ce77c97b0b6e6eb569248a68ab42aec6
> Author: John Garry <john.garry@linux.dev>
> scsi-multipath: add scsi_mpath_{start,end}_request()
> 
> This commit introduces scsi_mpath_start_request() and scsi_mpath_end_request()
> to update private multipath request data. It also adds mpath_nr_active to
> Scsi_Host to support queue depth multipath iopolicies.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 6a2d7dbfbe8c3..36e5c5543754f 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>>   	struct scsi_device *sdev = cmd->device;
>>   	struct request_queue *q = sdev->request_queue;
>>   
>> -	if (blk_update_request(req, error, bytes))
>> +	if (is_mpath_request(req)) {
>> +		if (scsi_mpath_end_request(req, error, bytes))
>> +			return true;
>> +	} else if (blk_update_request(req, error, bytes))
>>   		return true;
> 
> [Severity: Critical]
> If CONFIG_SCSI_MULTIPATH is disabled, the dummy stub for
> scsi_mpath_end_request() unconditionally returns false.
> 
> If a request has REQ_MPATH set (which aliases REQ_DRV and can be set by
> other subsystems like Device Mapper), won't the else if branch be completely
> skipped?

Nobody else should set it, but I can check this

> 
> Could this result in blk_update_request() never being called, leaking bios
> and hanging the submitting task waiting for completion?
> 
>> [ ... ]
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index d79e1b7b90051..eae5864ce5826 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> [ ... ]
>> +bool scsi_mpath_end_request(struct request *req, blk_status_t error,
>> +				unsigned int nr_bytes)
>> +{
>> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
>> +	struct scsi_device *sdev = scmd->device;
>> +	struct block_device *bi_bdev = NULL;
>> +
>> +	if (scmd->flags & SCMD_MPATH_IO_STATS) {
>> +		struct bio *clone = req->bio, *master = clone->bi_private;
>> +
>> +		bi_bdev = master->bi_bdev;
>> +	}
> 
> [Severity: Critical]
> If a request is requeued, SCMD_MPATH_IO_STATS and SCMD_MPATH_CNT_ACTIVE are
> preserved by SCMD_PRESERVED_FLAGS.

Yes, as sashiko suggested.

> If the request later fails an early state
> check in scsi_queue_rq() (e.g., the device goes offline), blk-mq ends it
> directly via blk_mq_end_request(), bypassing scsi_end_request().
> 
> When the tag is reused for a dataless request, scsi_mpath_start_request()
> returns early without clearing the flags. Will this cause
> scsi_mpath_end_request() to read the leaked SCMD_MPATH_IO_STATS flag and
> dereference req->bio which is NULL?
> 

ok, I can clear those flags

