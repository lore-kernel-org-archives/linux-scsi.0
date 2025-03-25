Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A123242A96;
	Tue, 25 Mar 2025 03:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742871814; cv=fail; b=KmWViHHD+gnV4tOt1ji63voLE6ZfgQG0g0YimTva6TGZC+X6MfnS/gd7dBK80/RPt31aWlNBRhZeAhXmx6Vka8LV/qYXuYm5uhbuh4vNb5lNqu1QKQR7JMn9jk3ZByEMU913ImnHnOduD1lWO3NR6HVhnk+5W3GJzsERp58+qfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742871814; c=relaxed/simple;
	bh=muITXWMGuTojU1jCx7iHX66uaQzhFlu8Ef6zrcd74x0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AtEDsffLqSQKBhjwnO/U0tSp1BgYuuqB9jefjZACkzDfyQJ2MOM3FiReU26mMu4BRo2o11vrT9iOEEq7WWwJOwpw4YYZ2yLmDUu7S3Yvegxpr1VQuaQ7GvpqjY0qYJvQQJr0s/6efFPLUE7c+aj6F5QlL47F2PUg7WoOI+61e/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UawYpWz7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r+Aklprt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UawYpWz7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r+Aklprt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52P2twIf002168;
	Tue, 25 Mar 2025 03:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mg6tt4xjPuYc2sYSXZa2Y8pRnMYroW/Bpd0mylDztms=; b=
	UawYpWz7BTzom8z45uWrbj5Xa9DrxV7h0MYu/DgdPH7m4aQ2qbiQuHWEljhtt4Rj
	0fYcdGY0PTjhYd0vDz5x1dtPDQzXNA0jH/XClhXzP8H05dqV/QFtCS4XE2xQctuQ
	rx7BBj8yl+YzKwqqHRmk8qI8fc9mNEJKDU5l5+0OE0Vn2EiLIb37eokapD7ol0Du
	UwIoszLzXNdOWMYi9P6q70LL1bOt6YB2Ie2Z0Ch8dKd3h5M+XHq3Wk91FkKchSFB
	pW0P4ueqjEb918FTCUbmk0fVf7L4TX++yMxn51z1zKD33NRVqPnucnD0u6hkYUEN
	k0f9ZoqgSSpu1U5OOD4s4g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnd66076-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 03:03:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52P2bqMo015130;
	Tue, 25 Mar 2025 03:03:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj917ept-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 03:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zj2GpXTyWZusursuhsYoVMQsIsgfo3Yrbdh85ZmtFDx5cQHvOKLCpdXQaPT1nAcE9Mi0a+/rijDYYXN+UP4AlyoANe3ffOsmPBe2kUGpgHrMOcE6Ds4kW8WX5awDxcIFnUVnVXq/tBk8LeZrapQR7tPsEqPNO58e2NhT/Yn+VcnXncsWixl/wpbC0RAuN3n+Uz/d+whLz99p1DKc8CMFyuLzZSw08Mv8Id2oRRqEXJgesHclfPddhOCUmXepcTcPDs/PinECk0ZuFWnwp3gl76TMzpvbd8/iUB8V8ljfI+hdslE/KRCS+SyLvs8XUyhUscz1tCO/GTh7edFZ8rkA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg6tt4xjPuYc2sYSXZa2Y8pRnMYroW/Bpd0mylDztms=;
 b=m/JKMV0IN2c1D0tp6vsMKrBX0BawFJ6nPAafSSztAM8EnmfU57FJwZEfwQxQqgozuRtlQmpDPz6czRptL76OiL+ZtZmJ/LM3lfY/Px9jGUYRlGjWi8/foQydxsouGTBh3/vyeSc3RyVY9qMUKHFxnxCNzgQfkOFsc3ErfqbsRLfrGzIIEBjj2TZwD6T419nrgMeo1znPB+bjD3GEj1Qj8hh4PgFMPpmgCFWBRgyBMTmJgVQPBCu2GHmKWacUh1ycF13CB9emAPMJFHU7Df5+3lmBBr69NygeE5VqdwGMA1aN9wfb0cJK34tFeQdR9bbKSr9mtEQkku2i4khpTm9ugA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg6tt4xjPuYc2sYSXZa2Y8pRnMYroW/Bpd0mylDztms=;
 b=r+AklprtMoG8V+KDAPPzwUrqGSUDFXfX0lFZ7c1Mt6MheRKPtvC9wd23yTjSt8P1IG63Pl5fSO24KyLKAM22G72XDwPsRWf856WQglVJMEzjTaW9D3v5//SglhVcVkAvXFbxGLaekvog0mCEgvcv1J2mMjbfOMq+6rWtXPqOxzI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV3PR10MB8177.namprd10.prod.outlook.com (2603:10b6:408:289::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 03:03:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 03:03:25 +0000
Message-ID: <9dfb46b3-3dfe-40ea-9eae-c6a2533ad950@oracle.com>
Date: Mon, 24 Mar 2025 22:03:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: iscsi: Fix missing scsi_host_put in error path
To: linmq006@gmail.com, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Lin Ma
 <linma@zju.edu.cn>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250318094344.91776-1-linmq006@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250318094344.91776-1-linmq006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0314.namprd03.prod.outlook.com
 (2603:10b6:8:2b::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV3PR10MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dfd085d-d9c2-469a-0003-08dd6b499c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enZ4YUxuU3k2K1ROajkrNFlzQnRDakNWek9kKzRlRTZpMCtoWTZRcFFxQjhD?=
 =?utf-8?B?eVlkTVVFQ0Q2enRjSGNSanRKMHBDQms3NDdDbzNxL0NvZFRTYUo5dUdlTFQ2?=
 =?utf-8?B?S2tYbUFXK2hiTitYbkNJUzZ6bzdzOFltaXBlUytMQXBrWnFTUEVkWjcvWitw?=
 =?utf-8?B?REZQQnVqOXN1cUFQdGNVMlAxTGxWbkcvUGhhRnQwS0NidW9XOXJZT0I5cjhK?=
 =?utf-8?B?RDhiY1ZPekY3M0RHRUcwTEZkMDYrdlhEUzdmelhmemorNFh5YTdhRjVyK3NU?=
 =?utf-8?B?ZUVrV0FDaFN3M2Mrb0lNaHFVUG9wRm00OW9FN3JENTNjeGpHRUVybDlCNmdj?=
 =?utf-8?B?QTBHeVZwUm1IVEU5TytiSVdpYjkvSFlVRThuU254TVVRbU84OGZTQlFCNjdL?=
 =?utf-8?B?bHNCdHJ3OGQ1U2hITUFYTlVUL3NvbkJYZW5XM21ZL3NpSjRYRHJ2b1pNTEZF?=
 =?utf-8?B?M3AvWElDaFFLV3hkMEo5NVkvWk9EV05uRkoza1cxV3BDWjU3ZG5icDN4MEZn?=
 =?utf-8?B?WkxWNTlZa0drTE5HVngvaXhmSHAxcENoWHZUMFdKNktXanRQUzBPWUxXbm5i?=
 =?utf-8?B?TVdkRU0wMng2bStGaEw1OGRNdlNFMmdBMGhTSGs3SnNiS01yYWVaeDY4Mys3?=
 =?utf-8?B?OUFGdURRekdUb0dXdStKZ3JyMWM4WUswZlF3RVFPQmY3bWpNcnBGSDV3RFlt?=
 =?utf-8?B?MG5Ba2ltbmxDb29RbUVZbnYrYUxGN0wxamJrZm1aUC9GSC9tUExWTG50cHdJ?=
 =?utf-8?B?SEdFVXkwQWFEZ2ZtakZjcXhialFXSGxVQTNSSGFMeTVCMzNHa1J0NnJlTjh4?=
 =?utf-8?B?aC8rNDRNaTNkZXpWUUwrUGZ6L0xrVnF4MnpocUw5VDR0YlE4Y1luYXhsbW5L?=
 =?utf-8?B?YmRFYlZMRXFjaVNHbW93MVdVa1A3cXFSS2hMNWVONHNLR2ltNXM2Ri9lelZz?=
 =?utf-8?B?YzhJek5abjMycWtqMzd6N1dWRzRhMUlINFZMTDZYcUhjVUpsb1BUc1NlelpT?=
 =?utf-8?B?RnlGQlo3QmlKSUFwL0tnczBMSnhvWnc5OVNHSDhwYXdTcSs2R05FeGdqOUg1?=
 =?utf-8?B?dFN1NVBTcWd4MWdrbmEyakxWK2E0YW52MUFKWjBpNFZpSVBEVzFLd0xqenVw?=
 =?utf-8?B?QldIWVEzaFI3UkR1TSs0TDBqV2RPZWVoNXRXczRXVHU2TGF0OHBqNWdrcVlE?=
 =?utf-8?B?VXpwQTJzbUl2bitaeWVwbTYyTnNmanNwNzJObjNodXBXbmRyUUVieGVqL3dG?=
 =?utf-8?B?WG92aG1Yay9Sb3lJOVUwQ0VPb2ZpQ2RvQTZlUGJaUDRIUWVvdjZMOVlNQm5u?=
 =?utf-8?B?a1JZeFNtNTk2SlVaS3BnNWZFUUp3dkc5ZExTVG5BNk5Damh5VDFrOWEzcWlP?=
 =?utf-8?B?WmZneE13WWxidXdxTEZwVHcrQ0pMNFpEdkFVbTN1YzU1TjcyTG9kckJ3cUE0?=
 =?utf-8?B?RjVsdXRnNE03aWZtdm5EWkIxZnZZRU9XdmU1QnprOXE1UVJhckJmNEJuamFl?=
 =?utf-8?B?ZGhkVlByV0VqUnV1UUtQOEFQSHhwbkkzQjNNMUFMbDhEMkNkREJhVzA3MDRG?=
 =?utf-8?B?OW8yRzRMWVJhMmY4Vk1vUFhNZEk4RzJzTDBxVHE5NkN4N2VCOU54K1lBZmFm?=
 =?utf-8?B?RmZINE1zdEFjeGVaaytkcUo5d1RZQlVLZmVMY2lINC96bWVHdUE1NlpGLzQr?=
 =?utf-8?B?NTdGT1lMZzl6NEVueDJ6WDJiVUZvcFM2UkN0V0VvTm1UR2s2YWxqVnVRWFlE?=
 =?utf-8?B?VnorQWZvc1grQ3p0NmRsWEZjZzBkZldzRDNHNUxWMlI4UGtKelo4UWRGMUp5?=
 =?utf-8?B?VGZ0QTdxdUk1UU5PblhxSGtub2hjWUlURnc1Y3F2SXJiQVRrRnEzRmxPS05l?=
 =?utf-8?Q?Sw5LooOsF+DGw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkVqOWpoa3dYcGNzY3Z4THpJMmhFNU4yTnRuWVJFVm1FMURVM05rbmZ1T1lT?=
 =?utf-8?B?VlA5bmd2RkZRNnpSTS9tb1k1MEZyTE90UU5JYlZ0SmUzM05nZkJsdXFJRmlN?=
 =?utf-8?B?ZXZQL1hJTW1BTFdFbk51dStDR1JnQVJqdTNuMlRYRnpzeE1kZHRxZTlxTVBP?=
 =?utf-8?B?MkZiOVdybG5sM2Y5a3FvL0pLb1d0aWhrZk9hM1poTWVrd3hJcENqZFdidng5?=
 =?utf-8?B?ZmltL0xBN3JKLzVOaGRyNEVxUHozeWd1UmQ4dFFsbFhZVERJWUxkZm9aaXpr?=
 =?utf-8?B?K2xQVHUxRldLbVhvei9SaGh2NWpZQ2xOS2tRcDVQY0xNLzlMRXpVZFFOMzFY?=
 =?utf-8?B?MnQrbmdWajNCRGJSL1pScWh4bSt3MVc3SEFmMDBielpxeklQejdldVdSa0t3?=
 =?utf-8?B?aHBWdmh5N0VzSzZpcGQ5VWliRTZZZW56akFGRUhTa0FjQ09SRlU3Y2xOTGdw?=
 =?utf-8?B?RzFWYjhvRmxKd1ZiWGxFaTlPMUJqWVRmcjVWRjI1dWczak1ZN3RTR1pvbjI3?=
 =?utf-8?B?QVhTb09MNVJwNFl5eTlRdmlEY2tqaFk0SjkwRHM4SExuLzZldmxPN3QwQmZt?=
 =?utf-8?B?alFXZDNTUzJrWldEUVRKQXdSSnk0MlljUkNnajBCeVpnQTU2MWhBV0hlWVl4?=
 =?utf-8?B?UEFVdUtNc2ZjaXpYa2hSMlAxZFQwQm0yT3BKdlp3YkRUY25zWEV4OEp1Wk8v?=
 =?utf-8?B?cTlqR2c5Y2tVbSthaXB1MS9VcUdDSlNWSHZHa0NoaFliOVJ6Nldlb0VGWnlX?=
 =?utf-8?B?ZkcwSEV3U3k4akVlYlZ5enJwL3dtQ3RnbS85SFh6WnFQT2E3RW1UamMvV2wv?=
 =?utf-8?B?RDJaYWJybnJUTlJkQjlXTnpwbWp4SmRrUXFPQlpSeXFaNXZLWTQ1L0cwd1pz?=
 =?utf-8?B?OHhub2c1SjF4a1d1RGxJb002S3JaNk1pOFpyZEZXdnhLSG9wTU1IYkpUOHZI?=
 =?utf-8?B?d3VyRTRIelN2ZStmZVFOR2JaeFA4Y1VHbTNhYUV2bWtZNEtKVko5blo2ZFJ6?=
 =?utf-8?B?b2QrYUdJTkI0NmpzUFE0citZdzVqQW1BL2RLOHY1UHdrNXlkRXdrd2swWnRh?=
 =?utf-8?B?RUJicUg3SFRNTlZ6OHBtZE90RWIwTlpIMW9objByZnpscGU2dDlFMWtrRk4w?=
 =?utf-8?B?WmNmR3lGUWpLMUNKS1ArYVZjUHZ2MTROQzBwdVF0SnNqdUtaWXhXenV6ODVv?=
 =?utf-8?B?V0JLSjBpbW1scFgwaTVHZG5ma21pa29hcjlHU1BTQU05L0ovemE0OXZXTzF0?=
 =?utf-8?B?NzlIa0VHcmtnc1JNTEk1TDNQSG5tUEQ2TTRtc2M3dUp3eTRuMVFFejNsRXJa?=
 =?utf-8?B?K0JLWFYwUHlmempjRDJkMWVBRnpwdlJnQmJncmlnTFcxSlR1TmRFdFR4NHZM?=
 =?utf-8?B?TXNqaEZmUlBTS0Q2WWVpbFhTQVFPVUR1K2l4TlMvNndrUTVrb2tCS0ViQ3k1?=
 =?utf-8?B?UG45NDZtcEpmU0dhZ252WGV5UWxYTEtSZWc0cWpxM2xyalJBQWh0WUpXTWxJ?=
 =?utf-8?B?WFJTK00vUzVFR2s3Z0ZLMGtuVVo3VmNXVEthckpja3hnK1ZON2NTSHd1VlAv?=
 =?utf-8?B?L25RTTdPRDQ3UkZtcmdvU0pVSmRPekRPeWtqS3JaUDJuQmE4ZWtZV2ZrSXd5?=
 =?utf-8?B?ZVlNbUJOaFBvWVVLK2FjMGhyUHBQRGhheGJpTGdidXFQR1BmMGR4Mmg5Rjlo?=
 =?utf-8?B?aDNuMVQxRzFGaHlkamV0NTVNb2VUOGJyQUJBMmRmNUs1aVZiK0owYjdITS9Q?=
 =?utf-8?B?azJzSzlQTlVnWHQzNUlUVC9pOEczcHZpV2ljVmlySm15Uk9MOHNja0NGb0NC?=
 =?utf-8?B?VTJkUVJOdXNZbHJJSkFvcEt2NjNkamd2bHFTcXdrWjFGOFVCVGtxRlZZekQ5?=
 =?utf-8?B?S3djY3I3QlBZd25FWHNLMnlhaEdHVjMyK1BpV29FNlVEdHVIeFgvem9NaHV5?=
 =?utf-8?B?NlI1YUVSMjhVOVlZbHNiZ3ZWUi9SY0FOd1FZYmd1cHBjczlmT0NKRmViQ2Jq?=
 =?utf-8?B?R2pBUzVsN1V6UjBGcEFHWExoTUxYV1N4Uk1hVitFcEJGYU45ZzQ3WW5CSDZQ?=
 =?utf-8?B?eHRoSVJxcDBaQmxLdTZsWXdVM0h2djlMMHE3RDNIL01Rc1B5aXVQZlZwbEdH?=
 =?utf-8?B?Z2Q1L2JTa2V3NjByU2xOWGhEcWRSbmJvdytZTTk3RjUvZ05RMTBmc29tRjhp?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8veM4gI19o/3LmyJAadILFmdTtZp5jeERl2wt1cp7NMudySzHXvSNHa3KBIkUdCjsEA/f7JpAcJ/yLMpHD3dBE5QhVFDiIVjETk4caepO+edSK7+NE19JbJBfdEdQihIK0mRo1aFpRkl3bgS0NGPRQnWRUQ3LMwWWn19uLQ2N1QLGDhGpGrudeorhwBtCwkkecyZw4HeLQfD3wZvbiQyYULr6rYJwo2+T8ptYyjKGHgp91q8Acf1tIKsttnOwAYFFagL6wf+LaZUj1f5s/R94ZUilihmDRmwRVKkYoeoVHyUCWRPp8PCvmwgbDXMFbmlOEqMa+C2CVjDrfvIsJkTWpBvCDu9yzeSbnhfhl+NZGJxMRaGVh4GRPT04uDxw6YUwr+gYIlUlr0wqoXGwGpxlSy/4pvjwd2KnjtK6qfQie51tPvgMrhiCgEV8k/1BU/O29NfWEZoETxVnRHewAwbncTRhIgw4xODZqYLNUSuupdKHQWDrOIqfKZ0c7xMXIw2ONzJjbkBcecnCfO/3nQ0Qq0prXiymwehh6Z+JiFPzfeCAvMNg9aQCy9IooizlTehUih2MzbVrJMlqWIFXrE04uDuqJNWp4q6Ho8ROiPCcf4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfd085d-d9c2-469a-0003-08dd6b499c1b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 03:03:25.3403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfsU/JWiJn8408Wphxsxc2iUWPG9emjuV3ogNPWWl1RMfXrA6i3Dwux3YFQRHdMNu5xAT6RIRpewYX/K6wj1vdWX90JigyHWeZA8I+RioFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_01,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503250020
X-Proofpoint-ORIG-GUID: ihCelEMjo0gIu-kDoacCZZIJdjxWPKQ3
X-Proofpoint-GUID: ihCelEMjo0gIu-kDoacCZZIJdjxWPKQ3

On 3/18/25 4:43 AM, linmq006@gmail.com wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> Add goto to ensure scsi_host_put is called in all error paths of
> iscsi_set_host_param function. This fixes a potential memory leak when
> strlen check fails.
> 
> Fixes: ce51c8170084 ("scsi: iscsi: Add strlen() check in iscsi_if_set{_host}_param()")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 9c347c64c315..0b8c91bf793f 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3182,11 +3182,14 @@ iscsi_set_host_param(struct iscsi_transport *transport,
>  	}
>  
>  	/* see similar check in iscsi_if_set_param() */
> -	if (strlen(data) > ev->u.set_host_param.len)
> -		return -EINVAL;
> +	if (strlen(data) > ev->u.set_host_param.len) {
> +		err = -EINVAL;
> +		goto out;
> +	}
>  
>  	err = transport->set_host_param(shost, ev->u.set_host_param.param,
>  					data, ev->u.set_host_param.len);
> +out:
>  	scsi_host_put(shost);
>  	return err;
>  }

Reviewed-by: Mike Christie <michael.christie@oracle.com>
