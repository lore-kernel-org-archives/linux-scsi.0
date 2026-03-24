Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505E53E5590;
	Tue, 24 Mar 2026 10:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774349392; cv=fail; b=SYlaNoTBRO/X9//h27HUjBcJ4J9ggphNrsq7H7XLL/Gk1zV7y5/HaG4v/0gs8ppcxNwTciuVmdUjwKVFrCKYWXjzn3l6y86woxOquIxPvK+GrSEUEQtbU6tBAtgM3BV2EPRE+pCPITcpeMQ0BKDejOHPly3OBojTf7+6mSzo4BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774349392; c=relaxed/simple;
	bh=4HNmGOr40BzTewB3mIinkxEZfnA545D5VbGcReqcRUU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X2TyLOk/jlW9lgY+k/y68pzCXt09AcfEkiqOYp4WHINZ4KSt1x0urhn2AGHg8adBavMYwJzR+c+adAEwlnMaeRDHf8RV22k1F6gNwI9gcjlC1fLk30w+TQzpFN0QJlTnK4lLbsv2Ob5fx/+0RniDl8myw4bU53V0/GV7fQ2F4b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V4KDM38X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rhr3GLCq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V4KDM38X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rhr3GLCq"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O2e2J6074619;
	Tue, 24 Mar 2026 10:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/ZY1hR1rRuwt6NTvOuYLyE9FCJLvHEFDSS1q3DTUeN8=; b=
	V4KDM38X8rOiHp90PbV40ZCV1WxnmJEHlN/X5fZ2nyRsris7C5c7i0zE11EPJCF2
	ZbWmUbxVJxELWRif6NyBL2d4NTrgO79dSKymq8namChNH4WghtrxC4PhFMaIOA04
	saNulHjrLM8rYDgAVPXlhYQeepT4YgzUB2ynavPwKdpPPa1GaCl/ouSbkJuDmSW0
	EUOfcOapD3EYRNqHCQJreGXul5YThAsOaiQ+Ri4jJ8/o591UOOmhd5FU8RrCHLhR
	4oYandmcUpegAAYkANnghjpu880yF1O+O+TQ2o63YwtuW+KRKeCW8QjVNNrG2DlW
	75VwmX0VKMeCXJWhmpogLA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kfpkyfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 10:49:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62O8v54U000598;
	Tue, 24 Mar 2026 10:49:33 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011035.outbound.protection.outlook.com [52.101.62.35])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hs9rm8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 10:49:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULmhfHDDQJhhkwgA6RUvrFJ3HPBY/GcrAeyS85P5eRIuiMoXPegIQz0CtD7eDKhg7ujd0xYbAqpDNGlrYZxupGknpDvLU57Fdg88nzcxfTL+9uYRTBAaEfoX9VE1DsAlOEsxjuWQuzjW5yJT4LqlFe4LeOZlPQrOFmJVTE7D+0Fx9QDVTTcJrBAuVFtrR1Xc45kg+I9QgMi88W1hqSjxkGcRo0H3gCyQp0Fh7HuYoS0wKWi2F+Y2kJPNkkcamGPOALoGOR+LX9Utz5AktOcBJL6fBB87OlXFC5/kJcGl2a1lO+4w9VPQLXQrkKH4LiIfIY3k9CoKiIS2+9+2oHc8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZY1hR1rRuwt6NTvOuYLyE9FCJLvHEFDSS1q3DTUeN8=;
 b=uW04BSRzdU7iIm+6znCHt4y9jpn6PToGsek9kYcKSwiO7vXgVrfx0cqUzLXArLgNaJbBBJ3Jg87PEqgYf0HbtD9CgZBItx9GT9PtfOxS6iIHM7X9PIRXWBWQn2WMTwNCHiuKikuDULUQQhHgL2HXx7qGdk1JwKYrEMF4f7kLD3wCghbtGWy2VZ2uLgsv4ZMQbMvcfLiOFv6t47+eMzDWH2bi240203LPKZA0E77g0v2xOS+19i0j6Fc4Xnx1frhaoHv+rV36bs8OYNNMfAv6u1DJHtiFONqtmpPyyR8sxgRErhb4z8BKJX2CdA2NGlC0dvCoCNKkmrdGuxUfmKXcSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZY1hR1rRuwt6NTvOuYLyE9FCJLvHEFDSS1q3DTUeN8=;
 b=rhr3GLCqHNcEW115+py0QuOpKcwMtv5cGmgt3msJMvD4o9g5DAGwR3tR+VPW5wJA2Zu9SL87oLqEdwWLPLiBoRjQZHHxkZJ5sdrM8I4R51TdPK3wE3wKqvEWA91SJLp3ZVJew4db8zqQf1KxK7ZPaX8YPxINGt8Vb6RmcZFU7kc=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SJ0PR10MB5671.namprd10.prod.outlook.com
 (2603:10b6:a03:3ee::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 10:49:25 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::e515:6610:798b:9d8f%7]) with mapi id 15.20.9723.030; Tue, 24 Mar 2026
 10:49:25 +0000
Message-ID: <d2a9c76d-885e-4b2c-afe9-3178408cffad@oracle.com>
Date: Tue, 24 Mar 2026 10:49:16 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] scsi: alua: Add scsi_alua_tur()
From: John Garry <john.g.garry@oracle.com>
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <20260317120703.3702387-6-john.g.garry@oracle.com>
 <692a4803-743e-4146-a48b-2a9e65326907@suse.de>
 <649e8a2b-b0b1-4eff-b2f5-56e37b7da980@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <649e8a2b-b0b1-4eff-b2f5-56e37b7da980@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0089.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5d::13) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SJ0PR10MB5671:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3897dc-329a-4244-81e7-08de899303ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|7053199007|56012099003;
X-Microsoft-Antispam-Message-Info:
	KC/1lfWZLXp669KTD1Xwn6leORb2QV+DkXdYzGctnsC0rRpTTTzUetcbstbuQA4Ca9fqeEtA3nrrWrjEQfXo+XjXGZz4pJa7ySuZfa2pseOY6VaTZxwss0Cuxz/6qjs9oVdE3x58L74L5rwaE3A+SjMTf2cwC2vcRj+MHBmoUJN9WElA0zhsnPLhaoZNKPLxC3IWIti3LO83h1ma9DDSuAMMhN/mnXb7am8Xx/EWUpEZBffKGAJszaV52lCMLrBxJx3/+VTgQfbA84nY0+YCAZo60k2GIl66xzUCx0Shk46WlXUhitINhRBZHm0aKmREfNNttUs1fTrF4FVUQt5cFTsHLZXjKy8hgxfHDBTdCKb/cL5ZtvyLKXw0AueOP+mLGv4/j5W2iXUMFu4eFMxEYuWq6FBxKB9c0FVBBQzPI97CfuW13sSSNNuK+0DxyO7GcpviOtSNjKL30rxZRld+/lKtRFPeGI1dQQzOq5LRjLq1/gpcv9ZKiXXCPNGcCnWgd0uKCk23HPp6B+jwwYoacKWE9kzYbubOtecPo0e4iSW7bLNwXFYzZM2ktpzwaFoGMGzr1aUemxBw9KrMheasl/OXFmZct/eN3MEs8kgUO9g4wj15U8Llv8cZwZDz2g/YbO+wlGq48N6GGB/j5SeIBavKz7jhYvQn59DNx+l8VCp/d9x0cQvDu1TolZq/+RpgNVF4dieUe/MPDjftaRF3lfFecvtLL8eF58jWGFBiSno=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(7053199007)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y1ZxMm5lQjBNcUlWZ1JQK3dLdDV1ZVc3MXdBQVBPdUNiMHpSTkIzVDl3WnJH?=
 =?utf-8?B?WUJselNIVm0vclBZbHF1aGF1Mm9KUW1UZ2R4R0I3QjV3cGRGVERaZ3lVUkJV?=
 =?utf-8?B?eVc1YTJBOWNqenNHNHZPM1JkL0EzeHVGWHNWVndpdFFobzZZMHdqUm4zYys1?=
 =?utf-8?B?QXFpdUgwMkNLZXYxazVJQU1XbjN5LzlIV29raUR3UFRoUFdZVzRSNjREbGR4?=
 =?utf-8?B?cVBDdFpONjRiTXgzNkhRdVQzdVJhc3daRStvSWtwUW1KYmtSWWVqMU11ZWVT?=
 =?utf-8?B?bUg0MUNGazJVUFZGeHgyU2pMdkh5Z015eTM5L2d0ekNjT3NhT1BIN0wzamZD?=
 =?utf-8?B?MGQ1c051d1BIL0QyaENnWDcvK1VPcFVNUlZXNVVlUzNVZkwwdWc1Q3pDNmIr?=
 =?utf-8?B?S0EvekY3YzcvVHRwaUhaQkJoWDA4ZlZ3SG92Yks0U1NpZ0tuNHA3QWZwWVds?=
 =?utf-8?B?Smd1UG45RzREUUVIc2F1Y3JtZGUxbGdsTGEyTG5oWUhiTGxrQStOSmNvZ0dK?=
 =?utf-8?B?eDNiRnUrQzk2OXBKcDZXS3N6TklyUGF0VUgrb09vUEtiUHFvTWNVMTlMWmFX?=
 =?utf-8?B?V2pMMXJPWFlvQ1c4NHltZWp2Qmw1VlpHRGVmcTREZ2pFYXpOcVdmTXRtS0Vj?=
 =?utf-8?B?dHdpdlFEcXd6Z04zSFk0OFRrcVFSWFVwZmZsU1l3ZDZyREZ5bkJadzJwQWZ6?=
 =?utf-8?B?ZFBpUDh0TUxaUGttOWJkRWJZZ1ZVWWpHRGNpb3UzUUV3RlV2SHZZQ1dDRVZk?=
 =?utf-8?B?SE9NRmJxa2VJaUZmL2tpL05FREJLVjk3UlhPL01qeFFibFFyOW9uc0RBcDlN?=
 =?utf-8?B?cTliaFMyaUxuQnFwU002c0RhNUtCcTA0ckFoVk5EdG9iUXg3OWVFTnZtQmw5?=
 =?utf-8?B?SlAvc1Z0anJ3MWNSYjRsUThqZE1jeHFZaDNzc2d0Vlc0dVE2SzdJY1FCYll0?=
 =?utf-8?B?RmpoVnJIRlg2c3N6NGF0emQ0ZndrMWErRFNFOXJvOUtJN242NDkvcmVkSklI?=
 =?utf-8?B?a3RxTmd1N0xVb3g2T2taNmU0WVk5REZ0UWdMWlJPcld0eE1ib29pVHBJNWNM?=
 =?utf-8?B?cTZsLzMvTTdIQmF1WVBBcCtCTERiMUZFcjRUbkkrS0FzQlNGZGlTU3lhcTFY?=
 =?utf-8?B?ZFZYRW9pVXF5UjhUMUsybkRKeHJRN2tWRnVKNDRJNWpheG5FWVRoOEpJMVoy?=
 =?utf-8?B?R3hEN2twZWoyOStqZUhiQmU4ZGVKM0dRTmZnbjBuRUljY1BGa2JaT083RGdF?=
 =?utf-8?B?ajR6YUZrbHh3L00zU0loOFBmemJhSXFUSTlGdUp1aDRjOCttSTRaU3M5WmJj?=
 =?utf-8?B?YVpXV1JuMW5aWmY2VHVDTzlseFROalRTbG85dktMOFVISjhiVG0yT3lBOHZZ?=
 =?utf-8?B?Vnl1UU1xYWttZjFITlNZYnlTL0JjV3JtQ1F6U0ZvdHA2Qm5CWjIwdGJFdHZE?=
 =?utf-8?B?MWU5ay9Ccm9JMjh2ZjZ3SmkvRk5sOGM3WmNhSnZqd1lrQW1wRy82a1JZRUZ0?=
 =?utf-8?B?ZkF1d3l1eVJPd3hsRTBWaDY5RjNFMkZ3RFpiZkhjNVBzUE9haHp3ZStaVHNN?=
 =?utf-8?B?L3lUeERjUHVNU1JncUlmaEloUEFIc3oxNVNCaGhsQ3MrOG1FNVlTTTl3VFph?=
 =?utf-8?B?cTVGdmlmYkh4SUpmY05DZEpwd25OTnZUSFVnblFGaTNNakE3NEpXVXFMMnpl?=
 =?utf-8?B?UnVQZkJPNnJNbTlzTnNJVi9zc3pTaUFmWjNlK2pKUkszUExpSG1QRHpCR2ZZ?=
 =?utf-8?B?ZTVCUll4Z1J0Mlo3L1EwMHZoWjkzTksrVWVZSlAyWjRIeXNHL3pVK1hNU25O?=
 =?utf-8?B?ekp6Q2lQd1RmcHBoRGx6NC92WW81eGQvZlYreWxINWVlZDBlaldvMVBwY1Nn?=
 =?utf-8?B?S04xUHA3QXo5YlR0U1l6SmVXeWRnQzdhTE5KUUM3NW5PRFQvVmZNTkJiRGZZ?=
 =?utf-8?B?ekIreTUwbk9pdXRvV1J1Rk1OWE4yb2RlNTlYTHNwd0ozSml3VjJoTUIyT2xI?=
 =?utf-8?B?V3dyZUFNMEhuckVVSWx3bWd1YWFxYVhjRm5CMmk5N1VSMHhCTklYc3NwTmpQ?=
 =?utf-8?B?ZDBHU2JmbEpEaWsyRjFuemlzYVR1MlRzOXhkS1lOY2I2ZjJqZlE4cVlSRkYw?=
 =?utf-8?B?Tmo0L2VyZ1VDbnJKVVdhQytsQzJyOEUzaU1jc0t5VlNkSEV0QzY2OTVPcFpX?=
 =?utf-8?B?QjVIOGF6cVVYb0dqZERVaTUxQjBrVVo3SVhjU01yMGZDZE5rdjBGeDFTOUtt?=
 =?utf-8?B?ZEI0SDhKeFBKcllLK01DMnB4elNEZnBlTUgvSS9FVnBXSkdsckJER3U5NU1R?=
 =?utf-8?B?bmF1dXlaM2dUME1zUW43Q3F3WDRrN3Q2czlyOUJVQlpTOWIwaG9VN3RnUXBv?=
 =?utf-8?Q?IGDX3ngYFj5fQIjg=3D?=
X-Exchange-RoutingPolicyChecked:
	gWWnCE0t1uGxcpxaymN7QjJUujo+WnwVdE49YOMR2GHa49tN9/BsL0VzUb64hMA2e6has4Iho/xGw72pz+zECCbsVnxf4wH3v3qOVJK1rrxQhe2Yq9uHQnAkzNTPdPYgCvXyvw9QdpcJZgHNT9fFlRyFXep1CqCtFzM+8ohks8NsFdJ897Wpykp+RzedoA67BZQOFJUnPTh8Zba6Arp774ia75K8+Zd7/xhdX9rJxKz9f50AFbGDvj9wknYX6msVygzgeunNljpFVE9M4zPOh0lXLPclzAK2xpLvxVoADX6Wk3nNGx9DxDc/sQrBPnn82b+ZHp0y5GYpFVmTNjVIUw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cw647eMTKHL5Yc73w/nlL0zhoBfYEzHenynNFbnmKTRFbtbRvHPjLrB+4I9ZX1rKkqmK0XpUhXnqvLDwp/psVa+RpAwjfV1AvpN6T0vwP4B14Rpy9uGrpg6X6dFdAXV8XVO/PoMFAU1Cb+x6bLSo2B78MvTmiKEIRFMfqtx8ppgp4DW/TExhXpSN42FLzvRjYQ4X6KyZryB+nG0Yt4R4gJn/1DsuAKZvma2NTga+gvDM1eP6on86lUvhWOYX+KYu+a81ejfkxaUFcfJQYSF+d2mISXjFNMxsdfX27ndplOR4VMxYQRtmtnbPezmiNfpXeDqEj4KMLWBaQJDnjKW48wpil3XtAJY6WQRWEvS+b2kXIiaiZLCh9sMjd00uuFMG4nnklNZqDiosUqTLIPYgA0+Bvx2j+9C4Rx01zvNirIYodd9J8Pv0aZ2tY3caMQMRHEGbFrato7Y7uN6K82fKF5upy7w/czuuqSed+EPMYk9APYzspoHHHBNFOFlNjb10MaI6Ydwh3qIK3bpbj/pKwtZFT5nigX0SLeP49dBxRROTWhfAdNua6mDzIclUT6UFRipAcfCx/UfIQYkxlR3DWWmfsTgo0g5RS/36E/w2iGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3897dc-329a-4244-81e7-08de899303ad
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 10:49:25.2120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwOcrWLtltnRugzK2jyXiT2zIcs1v/3M4M60TFKnqyucmUxoMQZFR6lTSFTG+9hTLncltgG2gr9ga6EiG/ZiJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603240086
X-Proofpoint-GUID: mB8DhyvYHFPUrt5pTZddbjfiyDkVnf2b
X-Authority-Analysis: v=2.4 cv=VKnQXtPX c=1 sm=1 tr=0 ts=69c26c3e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=b8zn4VCPTkzp0Y1Wa7gA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mB8DhyvYHFPUrt5pTZddbjfiyDkVnf2b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA4NiBTYWx0ZWRfXwSdpllUhswuj
 mEIlC6v01pu+UgDjwAhYs8Uu83KXgI6vIuFsb1sJ+tTzEPeM6kanTdDs2nP6wlfnMvzfnkQYP9d
 fmwIgXq4qnUTjj/iH9u1PX6/b0wC2eujer/NUMlyZG8XA+GiriLwSTd5e7C4EF/bCKGONpgITAC
 IzF7TmtrTmDBna4Iyn3TYjCT1f4p30BtXOSFuY/8w0lfqQMyTKSR+kas+O1G/J7dCj5lPFb0CFY
 gNAprEL1nuZpgSCmOeCdR90MVeJZz/F0NPai9riNAXGcu7toD3/WGwzI1g3jMbQAOUt9Ox0SgeG
 5VNwSjanmYm5P9QJmEkh7dztoIu/t1cYPFxOpxztFjOr3lzJeJP8Zg3wms8e6/Ns0xYmHD5MWBy
 k+OsYCPXuLif4eT/aKCr+wzsb/LFKs4k7JwHAS7xHtLMcRcnKb7NexGrACPz6umpENoLFg7uQZx
 g6Brr0i/sa/NFJx6JuA==

On 23/03/2026 13:42, John Garry wrote:
> On 18/03/2026 07:54, Hannes Reinecke wrote:
>>>   /*
>>>    * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>>>    * @sdev: sdev the command should be sent to
>>
>> ???
>> And this function is useful _why_?
>> We're just sending a normal 'TEST UNIT READY', it has nothing to
>> do with ALUA. Why do we have a special function here?
> 
> This is used in the STPG code, and I added the STPG code to scsi_alua.c

I meant to say that this is used in RTPG code from the following:


commit 9d2c30395213166e0b5614fe97576a789864e5de
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Feb 19 09:17:15 2016 +0100

     scsi_dh_alua: Send TEST UNIT READY to poll for transitioning

     Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
     as the array has to gather information about all ports.
     So instead of using RTPG to poll for a status update when a port
     is in transitioning we should be sending a TEST UNIT READY, and
     wait for the sense code to report success.

