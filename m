Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC018C930;
	Thu,  1 Aug 2024 09:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722503530; cv=fail; b=fJxoIha81qjyYEpBrEhwVaoS+ndk1f4ImOINq1/zGh518d4r/BwUc4/2h5ZtTUIXmn4Bv8fqMXeLSByEsNX7lZ1kRCz7fdcn238uuzj4kKaN1D5b34njzdOaGlYzEtQWDcMnRAq9ymAoM197obNm/QBEGY62U1fn6sjrq2yNQ8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722503530; c=relaxed/simple;
	bh=KhOZIK/16BNQPwHPAAQCLqMjHFF2vltVsyGIOfprx+M=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J5Xba6moC/CzyiuHv991Hrza5GuEXaue7ZchIgO37NT0qpsSoNRm/Z63XAIgQcwmFK+3sCuOqNdStSl6gOLf8hU3QYmS7YQaMNFv66etS1eORLlfbKxoXE6JmWO4ymqtZE4uFwFi3X+XSsrSoD9o3IsjQcAToUt9wXxJFdAC1M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g6U9q+0M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fGbBU28o; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g6U9q+0M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fGbBU28o"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4717tUA3026988;
	Thu, 1 Aug 2024 09:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=WqC4HhKA083ezJNxs6Ch/O7yz96+Fv7ayAPtM3f65q0=; b=
	g6U9q+0MHjDdtZ1C8QnEHIROyyElDwuuP5YIOHSxC7s/vahw75NNil3hP30tyuF+
	rgFQT0BiYGR1AHjeFapJw9MWjxSefpOB/RNrQHSM+2DVImUy/7le3fKEdRDgzdbV
	OrD4dPnSX5sUz8ag4gxxX0h6DgWuzeB/ESLXkJKzcfpEMQ9OrDz2JN8FS6LwAhW9
	gSZQ0KzJJaKx3rBgDRLIhGvIKHsnQdNd/fFw9ZoiGjvqoqWLtaiTTRNo0p1RaKNX
	u9os1HwyBGgeBPUOebuRY7mNglwyAUfc30aGs3bVaiDXSr43OHpAAQ7AWnJT9v+N
	A07OelJZqdiYumOxmcHEOw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40mrxc1ff9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Aug 2024 09:12:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4718XZJw000732;
	Thu, 1 Aug 2024 09:12:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40pm85qdyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Aug 2024 09:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Er7EZMcLLJXk0/hsvL+aA+pD+HMQgunJp8+MUAHaWFqACkWpdZo7vBYZuC+W/fzVgg5+hQxep2poUY9kxwXzhHrlHRaYq3HQu53OlnnEMP1Q9gydfjXye3YTy5jJhWwzwS3MrZDkW2tYOVb3oo/a/uFxkX3jruv4Q3fXY5I4ov/En8Snnd6TxGBQJiYXRtjHKMHD3IQalW2AxvDdGdACCLmvmuZyS/kTnsr2frsJdsd+KUxX/y273V6DXRh5WEuebhP1uw/EXUvj0K41zNQH8jZI1KR+hz2JNzSvD4ET7AIfG/m4e7q+4kmSM2Ovp+kTlye9oElcI1FLNf/6Q5/rHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqC4HhKA083ezJNxs6Ch/O7yz96+Fv7ayAPtM3f65q0=;
 b=ZjVBj9lrPbCFYcEn+lEmNli/FLCQajqQgXZtMiYrApxct+UsUX0LIGgOemwu8tw2mudcTWd0hkkyjBBow10X6MODEuRGZKtFZuzGcuPDAKnXH8zKsXJTd+xVIklwTp5bfy8hl1WowVoWiqfSrX0Fz0VfEcYlYU9RX0vD3xCCrbohMjK8v8gvlnaT/mTwm4XA4q7mWPfxaJNzLu4CXvIbuha1NmJY5DDViAjS45rW7BebmbE4zG5k5s2CWjSRD4hdDSyvptql2IOhIxc4VKpBZBCO+FZXmmScMaQ5LO4GBu2oGzm9lmxGsWqmDT+ZBY+eXq6P5KS0xttNVEvNvwaBqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqC4HhKA083ezJNxs6Ch/O7yz96+Fv7ayAPtM3f65q0=;
 b=fGbBU28oln9gn6X4hcXRlP2NDRhtbwuIqgB1aBYgfmJgfDwph5t9IwZW4LuiUGOY9ynWxoDyAVef05W2LfEGxu+bEuVUe8aTUD9zSIfsdvfZcTaueSB/Ja8ue/MjHmtLqRigLBKCu83KH8u/UJ51ia0ACqas835kgx/SaoeOvrU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6706.namprd10.prod.outlook.com (2603:10b6:930:92::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.33; Thu, 1 Aug
 2024 09:12:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7828.021; Thu, 1 Aug 2024
 09:12:01 +0000
Message-ID: <46ab2af0-fccc-4836-a246-b50a88025c19@oracle.com>
Date: Thu, 1 Aug 2024 10:11:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ata: libata: Remove ata_noop_qc_prep()
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20240801090151.1249985-1-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240801090151.1249985-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0190.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: b9fcf9db-9dbb-4950-eeaa-08dcb20a0084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjB1Rkt4NTE1aVVCdjZKRVU1dzFqdlAxbEk1LzcwblA5TXhpNFcyN3A5ZGFJ?=
 =?utf-8?B?ZWMrR1VacVk1cGRPblZJVmovSGFrS2VSbWtsUUJDYWloVENyOGgzMDhrQURh?=
 =?utf-8?B?SExnY3BNcmVmdVlEeHk1azUwd2ZoRWdmd0xUbUNEUTIrRGZEenRZcnZzUFR6?=
 =?utf-8?B?cXNqa09KN1VZUjBUVUNDKzRUei9teTlnZ2lVdVk0SGdMUGtnTkFNZ2h5d2xM?=
 =?utf-8?B?SmxhV01Jb2p0L3ROOG1pNUhQbFVIT3Jtb3MwUmNRRnFYUlhtdEhPN2FCSURY?=
 =?utf-8?B?QUtCN3gvUDRtT2d6RXREa1RvSjByd28wbk5RR0t4OTNKMnFWUXJGWmNlcjln?=
 =?utf-8?B?NjZwYTNCbnNEQ3JXTnhtb1ZIZkFEK3h1d0d2TDdkdC9hSDEwUzBZODNManhB?=
 =?utf-8?B?U0gxUHN3amxPdnFPUnNxMTdCalorUG9URVB3VWhCdUlMSTl3bGdkT2kyOVEx?=
 =?utf-8?B?NjVZSlNoR1kvTDlQblcyM2h4emZMdEVId2JadTNEdXFudFRXNFRQQ2tneDJ5?=
 =?utf-8?B?cmJXZDZndGQvSkozb1QyQUVad3lqVTRuTThIalc5T05KcmVDQ3BHaWxPdGY4?=
 =?utf-8?B?dVJEYXFDNmlFN3ViaVFvQ1loeW4zblFFS1A4Q29idk5SeTB0bDVrSDMxNTlH?=
 =?utf-8?B?eVRJUmNnWmNhc0FHS1ZMZUtWS0pNamdreUZ6eWo4TmRPSFU5TzRYakgvTUxx?=
 =?utf-8?B?aXV0L3dQamlFRUpNSlJYSHdUU2NDemZ3SC9oK2c0U3RQVHorM21tTi9MRkZV?=
 =?utf-8?B?ZDJFcmJIWXkwUWZPTURKZU9hQ1ZCaW1wcGxlNGZYdzc2akp4a2JIOVJlLzhw?=
 =?utf-8?B?a0NNUU9CTndLMWtMa3BLZHlGOFF0VTB5NnFWZUNMVmNRWEs3ZzlMYU5sQjhO?=
 =?utf-8?B?cllrQ0JJQTZkVTBZUUxoZEJ0ay9uLzBNSnZzSDkwNndZR21qdlBvUkk4MWtV?=
 =?utf-8?B?ZjAyNlBtT0ViU3dFZzMvbFM4OHJTU3ozR2hWa3dCejVCdDArUnd1K2RBQ2t5?=
 =?utf-8?B?ZmJpaUd3V2ZJSERuNGcyWUlxcmg0VkovU2NkNXpWSjdNNC9rNUVQdTdBRGtq?=
 =?utf-8?B?SWZGT2poQUVja1VGMW5IY2dJdUJFWFBlNmoxNS94Q2hoZjczbW12eDhqMFBP?=
 =?utf-8?B?cWxHc1dsTzlKNTJhRGI4SVVlOTFEMzRudiszZmxaelBhNlViZkpEUDd4MmhQ?=
 =?utf-8?B?Y0M1K2xrRHBiV2xDWGtmSHl6aFNBMERobkRtaU9lTXFNd25lOFpDblYwaHBx?=
 =?utf-8?B?TWRWV2djMXdJUFNweDhUREV4ZFVtcWJjZUt0cGlYK1o4ekF3Ykt6Y1pkRTRV?=
 =?utf-8?B?MTR3dWkzcUtWWXBHOVUrbWo0TVFudGJEaUNCL0tDZkhrbFYxZ1J0Z0lDRllH?=
 =?utf-8?B?dWhYTTgzT3JYb3BrUWNOK0YzMndjN2hIdkt4c2UxNHNLR3pESzBsZEpYVHlP?=
 =?utf-8?B?aWlMd3NTbk4wcnZkSEt2bW1MOFcyQWJOZUZwMUtJTW1IQ20ydU1adTAxWFYx?=
 =?utf-8?B?WHd6UjFEdU11UjljYWIxdmkxNUl2Q01DeGpWblFkZm5HUkJ2bndmN0U2cUxX?=
 =?utf-8?B?UGZXL2JoT2tQMndsRE1UT21DVXM4OTJrSkFaQUx5bkpkZytVWXFDNk9aOThO?=
 =?utf-8?B?UVZzN3FtZ0ViRjJMS3dscWIwclVvdDNtbnZqcEZmb2lQNU1sdE90Vnl6MU9n?=
 =?utf-8?B?Q0dsRVdobCs4dEt3WmF6clVmZVdOaUEyMndMSEhNdlcvd3BqQXNoRkdqdVAz?=
 =?utf-8?B?dnJNUWJ0UWJOc0JOZ1hzazNWRldob0VnWkJjc1p3eDFiWnBkaGRMcTN4WGIx?=
 =?utf-8?B?OWw1WHE2emZJQXhtWFFWdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R29OeFNENlh0UFBnZ09tcG5QNnQ1S2RaUFdZb2xoYjIrVTIxNHZKVXRtaUJZ?=
 =?utf-8?B?RE54ZlBJellxSE8xWUMxKzhsNWo5K0Vzc1RwUjJZSTVGNXFKbjM1VmpaL0xL?=
 =?utf-8?B?ODVyaTduUTFwWGlVTzJWdkRFdnFZOWdMdEwwQmtxMXBKRHZJT2drOEVwQ0xW?=
 =?utf-8?B?ZnUyMWNmNkthN2NTN3JLMlJUYnUrY2hXNU9tdDBjbDZvaDZESEtTamdFUk1s?=
 =?utf-8?B?RHlaa0xQcVdXRk5XRXVMZTVWdkdpRjRVelRSdW9hU0E4R1dwQ2dFeVVhbWtV?=
 =?utf-8?B?SlhOZXpNRlpPRGYyNFlKZzhuemMxdHFucm0vanMrSVdjMHhVWFRJaE94U09F?=
 =?utf-8?B?cCtqRmk5d2lPZThZQjBvUUlWaFp5K25kWmtGUURpSGxFQjlZWmNJdmw3aEt5?=
 =?utf-8?B?Q3cvRzdSdUhEUHNBaGg1aE1jSjRKK3hNb2NZN0UzRlQvTTNkR3dtY09jWmlG?=
 =?utf-8?B?SXFEYUJsbGMxN2pvakIvc2dJSW1reFIvOGtzWlZSRkl5a2pEbzdEdXJ6UXpz?=
 =?utf-8?B?MWwrS1ZkUG9WM2ZwbS9ZUTd2UXNTZlVoeWxFd1ZobkhNY1g4OWVQdmtuc3Rh?=
 =?utf-8?B?VG5wTjNSSFUwMStZY00yQVVKekRKNjl0c2xiQm94WTN4YXBmZExWRUgweU40?=
 =?utf-8?B?Z3BZbTZrNWNHQVRNNTR1T3BDOG00SXVWcURqM2c0YmpFR1ZBMG9VTUQ3MkxE?=
 =?utf-8?B?SkFDdlVLUWE2MWZBYkJjZ1psZHdMZ3I4R3RQRGZhRHRrVFQvYUFFMHFMYUJZ?=
 =?utf-8?B?SkdEM2J6dktHRkNRQlcrckszVTRZa3QxSEMvQldQUG5QOFFwWWx3WjJmMCtV?=
 =?utf-8?B?S0NMSGR6MFozM1JHbmtlbS8vNFd2OHBjczFENHYwdkhDMFVzaEF2d2ErNlEy?=
 =?utf-8?B?UEtNdVRBcXhtRUpadmdsRWpmN3VXUXN3Z29OanMveDEvZDBtQ0ZiTFQzMzlq?=
 =?utf-8?B?OVlpb0NKbDRmQ3dJcFBLdlhya3J6dEJ0NTVQU0ZsSFJodXBQaGIzNkNJcEti?=
 =?utf-8?B?cVZLdHY5RkJFQzV5SWlVMW55V1dUS3l0NXdjTHhUR0huQlRCWFlsc1pHZXFi?=
 =?utf-8?B?OHZ2QUkvRjdkc0tCTmFkcEpYSlh3NTlTdlFmWFdjWXdUWWYxMkNlT05adGhV?=
 =?utf-8?B?UXkwalFpb2JBdmVxR29oRGFXUS9oMTMva2V5azF5QkgzV3MyV2YvOVhnY0Y2?=
 =?utf-8?B?dzNrVW9WMWQwaUR5a3lLOGoxWUFQR0ttU2YvVXdYMmVLSG95NkFud1hJc2NE?=
 =?utf-8?B?YXNPVGZuWncyQzhpMGdzWXN3Q2I5MjRqMUgvWW5TRUs4ZFZ6Z0ZQWkZZbEsw?=
 =?utf-8?B?TzJWeFZiSUpoUHJ4VFloWjI0aEcycnZwYnNhNHUwSVlxTTF6Skt6UWVNWEk0?=
 =?utf-8?B?Znh3dGxFMDRBZW9ZN2UxTzUyS3RsN0dLWVFpVURhTXFIdG41MysrWjhWdGRK?=
 =?utf-8?B?ck9odjlndThRU2lGaGdveEZTa3JUdVE3SmxZU2ZPeWROTmFrMDZwbEVEWmR2?=
 =?utf-8?B?bVRjR2pHK0dQTVB6MmtoKzdLUVVCUEhtajNzeGpwOWs5Y3FhcmE0amUrMjNP?=
 =?utf-8?B?RVNST1lFZVFBTGpUVkY3ZEExbDdabTBzd21tVHhLaUZLSHo0a2w5aVpUeHVD?=
 =?utf-8?B?N3d6TTVSK29EUktLRnRybHJTd002eGpHTzljUERoRzgwZnpEbTdzRjI2ckxE?=
 =?utf-8?B?MFRHS3paTFozcXhGS1I5RGNGRFhrRWRnQVJpS01kZnFkV1puK0RKZUZ1ZUZ5?=
 =?utf-8?B?ZWk4KzJVM1R4NS83NDNsRFg2dTA5S3B6cFZJdzZERENvbWtiaFJPdHluc1V0?=
 =?utf-8?B?djlYamJXN09FbExzUHpERlFDUmZ2SHlMTXVXTEs3Y1A4UURiaVVyM0FHdmJQ?=
 =?utf-8?B?am9HT1R0YmFUMStVY3JBcG95TitwV0o0YWRsQUdES2lQcXYyN3VZNmZKYWlZ?=
 =?utf-8?B?L2U1VEYwbjFCVzJKdkFNRFJ0MlJGcklVTktoY0Y0VmtFYm11SS95OTdoK2pP?=
 =?utf-8?B?emR0QTh4V1ZRVVZBUEVZMnRBSzdVditzK3pBeWxDNTZJWExnZC9td0FJMlB4?=
 =?utf-8?B?bTRHZXJmaGErVlNrZ29Lc2dKaVpaeHhzVDBmZThTMCtKV3FWcWNwT0VKN09h?=
 =?utf-8?Q?v6RBVH52FDuithydSP9hXH6ob?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jwKTkdNFqLakkbz1VlTZRasNy0l3OEkwm8/kxsTwre63Il94TWHx7RZLtSRByWzMZjOudYy93E+iMF5Ti/Zun9S38aOWHNljVKy2eTtCfEo3JezE3bPYlb99tI7mYkXZu2vvNbHPowY6y//NsgHnIUCS2ueqPauyybUshiYqZIDu3n7cgFJ02is+78nGzNNFBj5xm4gktk31CEgengk66lIaw+mUM4piN5DathDQ7UUDPGRujKg98Z2ASAxJYo8Bh3rHfSiGZYZkhvVxEzsAgo42YCtGEl0N1dUg59kD9TZa1K+wttbjZlY9NF78CJikWbjfsefo1l9CukZxXoYp/AhcGmhE+gLXQh/SycoEiMrhkcwgPOzZk+IonUHICE5t2jjVMDCU6oAlekdXqpE8Xh2V+HFNIBvTl2xCYzHIVHCBPEMZWv+Kyu1r5yOORJ/oaTlkzrVGu7Ac/BiSYL41PelDny4+RJuPEwFF8bZCpFuB+3EA+2Vu/igv/qeeAhnrEg5ETWuc8jN7AqWf9fCe17TSOzYkPDmlQU01Y81oNZKvMcnPtSomjBQ7PFQX7LlbO6DdY7+9njW00boPmxNmytvTK/JgZeXqcgbObmt6TXs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9fcf9db-9dbb-4950-eeaa-08dcb20a0084
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 09:12:01.0200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iG9s2uvE3K7y6upNn2j7RjfassQlH9RVbYqDxKuRp0Ta6rbAtiyE3vEp09InCmoB1WoI2ba3km42Ua1DASWYLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-01_06,2024-07-31_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408010055
X-Proofpoint-GUID: 97lNGC_I2HmLMoXwiQzeXu_rdwDXXr76
X-Proofpoint-ORIG-GUID: 97lNGC_I2HmLMoXwiQzeXu_rdwDXXr76

On 01/08/2024 10:01, Damien Le Moal wrote:
> The function ata_noop_qc_prep(), as its name implies, does nothing and
> simply returns AC_ERR_OK. For drivers that do not need any special
> preparations of queued commands, we can avoid having to define struct
> ata_port qc_prep operation by simply testing if that operation is
> defined or not in ata_qc_issue(). Make this change and remove
> ata_noop_qc_prep().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/ata/libata-core.c     | 18 +++++++-----------
>   drivers/ata/libata-sff.c      |  1 -
>   drivers/ata/pata_ep93xx.c     |  2 --
>   drivers/ata/pata_icside.c     |  2 --
>   drivers/ata/pata_mpc52xx.c    |  1 -
>   drivers/ata/pata_octeon_cf.c  |  1 -
>   drivers/scsi/libsas/sas_ata.c |  1 -
>   include/linux/libata.h        |  1 -
>   8 files changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index fc9fcfda42b8..b4fdb78579c8 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4696,12 +4696,6 @@ int ata_std_qc_defer(struct ata_queued_cmd *qc)
>   }
>   EXPORT_SYMBOL_GPL(ata_std_qc_defer);
>   
> -enum ata_completion_errors ata_noop_qc_prep(struct ata_queued_cmd *qc)
> -{
> -	return AC_ERR_OK;
> -}
> -EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
> -
>   /**
>    *	ata_sg_init - Associate command with scatter-gather table.
>    *	@qc: Command to be associated
> @@ -5088,10 +5082,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>   		return;
>   	}
>   
> -	trace_ata_qc_prep(qc);

I assume qc->err_mask must be zero here.

> -	qc->err_mask |= ap->ops->qc_prep(qc);
> -	if (unlikely(qc->err_mask))
> -		goto err;
> +	if (ap->ops->qc_prep) {
> +		trace_ata_qc_prep(qc);

