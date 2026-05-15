Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA458351C29;
	Fri, 15 May 2026 08:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778834776; cv=fail; b=p6aucHNaCZLJTNDYjp8nDd4w4lExUPWwwSH0TfsuGph1ykztQb3CjuU1idv3w5xFjA4jFL5kQFt64n/AQSUtukm/Blpfiw5e+V4KgS1MazGd7g6g1dMUm5pXQ/lpKk+gnBKvv9vOBjbEJBz8C86A81GAdQoAF4K8sjRCHxlI5DQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778834776; c=relaxed/simple;
	bh=9WdziBgyBlQuSSssxuALvH3sagR986R1vWEiM/xRUx0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gl1y332G2bAHKbh/5AaMarv5j2AEHs9UgR/sbt4VvpwoiRjQZ+gCqiEGnxE2EtyFEYNL5nevUTh/om5uEC/vzBgooEYNsHFajCUWf7RJomfnH+S3pkhAzsLOmTrTGfYs+SZ9sEfWy9Yaz6XykLw7o/LSSHhjEW1OxAocECGtk1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZRLLCQcx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LEZR+A7X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZRLLCQcx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LEZR+A7X"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F0Tctu3368529;
	Fri, 15 May 2026 08:45:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Lnvc/yWQkkAnmvAtiPPqRsumN9NsbysRdqqM/2nOlGw=; b=
	ZRLLCQcx/NLiQwvVec4QoN2iG5pusvt47q8FbBix4lZr/mRaTT0QTLDng3OgGNKq
	W6wezcPQOC0OwXuTMpNqYMRC2ur7TxHOdY8uPyaxMvNqf5fvShseaF3cEammdbtB
	IT28F7FzpbwI24E7gPSKrNPw/4rInO+TyFSpK5jCRsma7zMpkBp2nIyjQPR1r/5D
	e95noTPGN/RjND9NJ56k6XWVp88FU4XB6NzMfWz6bPtByKifUa5Z35EnjkENFhbx
	lkxr/5Tg+uMLMOo2yZxmCRJXSYMNSdfGVJdFlWgCMPl3ymqs7jwwnVLAxq43sfDB
	0n7l2eD1boSmeObQJf0fJw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e5m1rgvdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 08:45:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64F8dqka003168;
	Fri, 15 May 2026 08:45:49 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e5kw60kb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 08:45:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ijrs6FAg2tj3QsqxON34oaly72eSMar6phcNV6NVQznulMOlnEXxqu3cWRiyzFGa6JDE3XIMQnSgVXh5y5WlAm/Mrw/7BXkzduvCgQsgbvUuVLHvaLstOL7zULju2vBGC8zQkaK+sJkD6xEqi0euCOeUXewEauY/Ewsimkg0M3r1Yp8hHofLVAsgZdNcCk0g2jiyDTlIqoyOAgDkQShEbsRkIrcNubIXoHNZWV7VooxPLWkTbaBXyRWofINETitObObPXugT6cT1SP6gSynYJOa2gsVH9u+P8C2SzDkzeadgAGyis5m1TWAufYKN8ML7ElKzgJ3WQa22bPs83zF3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lnvc/yWQkkAnmvAtiPPqRsumN9NsbysRdqqM/2nOlGw=;
 b=uqNL4GSWEmetHvKhcgfmUI6sno1FUvmTaDmu2IGEeRHs1w4eo5KDnetv7pxiUVwr0xzuopJzaRXXn/NSc+GfiVke7ePawftofosImgP4jZb/qRo+lEaVmePU9c9IhWKQT5azSdNl/EqQdUONtwW5a+Mr3LNO5aFYnWe3N107vJb53x5FyYkCGRzJTUASq9JqXsrPZknF7ELrPsk8nkHsdGVSKZ9ozLVw3/sBXxqxmBBkqPkrlICGsnIA6eQkjvSAYYKyVOyzjm1IPyJD7LOHUVgAwJAHpMXLNrOlecp3LpAJRLdN4dy/b86TPpfzVeLVoXtvn8Ap4TcloizBPKE8Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lnvc/yWQkkAnmvAtiPPqRsumN9NsbysRdqqM/2nOlGw=;
 b=LEZR+A7XPaG6wRGYu6lJGci4x5CVikxg5J3KamZtNl5LYBYxkLxJC2zgUzTNgmm0UtDItGfY0z2eHPpkaD//sUs4HNHRfnLhJwmdfRrfC0dMecirBKDpXbU9eK7qrP4ZDHLXcv5v1kYOCS7XufLqTdatKfrvupipyqVJJX6bbpo=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CYXPR10MB7924.namprd10.prod.outlook.com
 (2603:10b6:930:e6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.12; Fri, 15 May
 2026 08:45:46 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 08:45:46 +0000
Message-ID: <ac95f746-7215-47f9-b307-b0aacfc04d2b@oracle.com>
Date: Fri, 15 May 2026 09:45:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] libmultipath: a generic multipath lib for block
 drivers
To: Mike Snitzer <snitzer@kernel.org>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
 <agZnwW64PHRew_5l@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <agZnwW64PHRew_5l@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0023.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CYXPR10MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cb6f611-6669-4a08-7616-08deb25e5b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|4143699003|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cLtM3+f2E7HviSg7RZ8M8sBNWdQ68M9mpvB5H3weD+EpP8FxZZJbnhddhUi8LeFBmLKVHLkH2yEoQwv+ktW/2TYdUHYtnnhLQZ5QrHVWBa3ie4MZM7OYHn9ug9zoWxSe+Xmw1pRZnEDi38nODbMwOr8zn7eR60jWeLLd4kAXmbU87EqaB3DUd91vFsX5cJV6WG9rnyrYbWcuyYCdYH8QkTCTPCCVW07o1ed8fXjElgsOxdpiC0OmnwTZYmniQh1ri34Igot1iLmxadsjrSV4Ln8/MdFZYOLmd+Z8/XO+9BX7GES1BDEE/kjf/j541hr/QOln3pCEc4rpndzn+NrCfpSrj2oFtlvp09pSdVhqXtnW/6Ft8clMOQpT4m7twgqSVW07P8HOfu15LGa75Whr0TbBIw71llq01YuCW8KktD2rHCqmuS9lDQlyqxQDVjfblYonzFhS6A1EqEDSUCPsi4r6dEMtIqB8CWefVL3H2oxC86eSnfPbCLpEdCfL+VsjZ7xHV6iIomjIQcw5Y2FMPkU4Z3xZXBfyAIb3jLCNr2AzyCvbgSNQtXrw6Ll+vXjMqcgfaJDUlMgNwYlVoTFHOiYPbhaKi9m6NXj4bK5JVU5IadFIHu3pVdAL6MTLA0GbeicES5GGw1Qlet5lNlHCETKFmQt3/qAsBSXIK9djC4Os5HiuBfKc7M8wqg24R5r7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(4143699003)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXFtM1k2TGJsM01SUU5KaEVtaUppNFdaYjVpTGROaTUvNmVjaVh0ZmJYUzFH?=
 =?utf-8?B?Ukp5SlV2dWF5clVKNmUyd3hyNERNaTZJSUR2bEZGbHd3UXlsTm9mUHBnZU96?=
 =?utf-8?B?a1pVaTJuMDQ0NjZZVmZJREtZRUxaaXlSaDJSR1IwYU9wUE93S2pxVUdybFpq?=
 =?utf-8?B?T2pKc2dJOG1PZk9ZeUVmWFFQOVc1OWtBV0tySTFzUmdLa3V0Zm5VMDgwUmw3?=
 =?utf-8?B?Wk5TNXYxZmxxNTd0bFl0V3J0OHZMNlp1czZZR0hEOEczTlVGRENzMnViQkdh?=
 =?utf-8?B?N0c5NXNMb29wOXJYNC9mclVTbURFSXUvSDYrK3VKenpieEtYOFdqTndULzJo?=
 =?utf-8?B?Y0VWVE1ndFRXbnEvcWg4YWw3bmlld3A4bWhyWm1OSm9ZMUFDMEh6cW1IaVlW?=
 =?utf-8?B?K3RoMHFZZmRtYXhHOGtubGwyMnlaYWYybHg4LzFEdXFRRVEzSnZiMjYyTVQ5?=
 =?utf-8?B?WFNVaUNoekJIMEphRjBzV2NPYU5aY2w4SXByZ2hMeUJNaGJuK3dEMzdQeEpU?=
 =?utf-8?B?YnVSdGwzRHJzQ2orVGtCR2lLTTBKSXVsU2RUOGs4SnRRenljU2hKa25UOHlY?=
 =?utf-8?B?dExYU203QXJPSy9ZZ3lPWFYwa09sWlhUd1RncC9uNU5mNnpVdGt4MXY4UDFq?=
 =?utf-8?B?UGdaOVJsNXZIb3pPczhpSUVMb01lS0NpTmhTWm9OTVRFUGE2V0pzWlYyVmli?=
 =?utf-8?B?Y2JGVUNCa3JmdVc3Z0ZGZHhSaVF2MnpMUWxsSzIrM3M4b01UVEYrQU8waDRr?=
 =?utf-8?B?OHlnR0RyY1ZHTFNnVXVjV3V6VkFXUFBhN3dYclEzRmRXS0FIRk1KM0JSR3kz?=
 =?utf-8?B?bjNTWnQzcHF5eWdCUEtyR0E5Y0NRemRFbUxiMlVqL3lVbEE4K051WkRNanU1?=
 =?utf-8?B?UXpaOWRtemZBT05aeXZkZ2szNHc0OWRTS2l5enVKRFM0NkhIVWwzaW5URm8w?=
 =?utf-8?B?dHljTUFqNHFKM05uRGRCQ2lJd1ZEUmVoZDMxMzZFZkxOTmpMemhyQmJHYkhE?=
 =?utf-8?B?VGdiT0FCNGF0RGJnZmt5dHJGVFFBNWs3dHJTdFlxOW9keXh3djBUajBTT1U2?=
 =?utf-8?B?Q1U3cVliTTdHWDk3K0tpYjQ1UWN1dk1IZzFhRGVsU3M4L0ZNcDdTamlDRVVC?=
 =?utf-8?B?c0NpTUIrdWlEYnJUZkpxbHhLRlREQ2owN3NYVzg0QmRESmlqSVhoeFR0NGR5?=
 =?utf-8?B?cW1LKzYyL3UzSnI3R0VvZERzNjNsTmNabmFRUGdPVjVlVjczbnl1VVJ1UVV0?=
 =?utf-8?B?cGRqMmlmc2FqTDczRURscGlsVHBnMUQwOUZLWXpQTEg5UFJlTVdXeXJVRlc3?=
 =?utf-8?B?VFVUL3M5blA3UThyVlBadTRNc2hScmFDN1hSdndjemg2WG9WdG1kdzFIdDJk?=
 =?utf-8?B?VS8rUW9CRzlSc1BxL3JEQ3BrNDFxSDA5aUEwellkeWdTaVJOTFk5UXZzc0lL?=
 =?utf-8?B?aThRQ2lDUXUyRXJ5bGJ0M3pWV1N1cWRXK2E0c0ZkUkZQQ1l5S0JhZ3NjUzJF?=
 =?utf-8?B?ZTBFU0VUSm1TVDJQOHU5bWthdlE2OEU1eUxya2RIZTZsaXpBaXhZcENNZ0pn?=
 =?utf-8?B?YnNoN3dGQTN3N2pEQkhtSFdLSnp1TVRRRmJDNmZuNkgxRUNXTzRKVEk5NlZl?=
 =?utf-8?B?TGhMSDR2YktqOXhybTEwMGtlbG1yWVA4MEVsb3p1TVlkajkxV0sxMUloMW9t?=
 =?utf-8?B?WUhsbDVvM1VwZWVTYTRIQWpRVk00YmtNWDlabk9nRDVHMUhjWDhjSHFYb2ps?=
 =?utf-8?B?b002Nno3dlVMSzduZW1BWmxmTitxRTlYczdGYkJYRDZJYURBbTRXMFJZUk5K?=
 =?utf-8?B?VFErVGswQXlzdWRVck13Y3dhdG9XYktGc2NNQXpNNDJwQlorRHBTZkVUTXpH?=
 =?utf-8?B?RXErejE3eVU3M2hiK1lhT2pmOEFyYThaTjRWNGtML2EvUkJhWGNqWHJ3NE5n?=
 =?utf-8?B?Z1Nkc0E4VHlZSXpoaU9EVStucGVSaFJEeE1wOE1MZXFNMW5FeWROaU9qSlVq?=
 =?utf-8?B?WCs0VW1ZS2pjcmpUVE80Nnh4VWtXcHJiangwUVVOY3dxbStjcEV5UmhtKzg0?=
 =?utf-8?B?dEM1RnY3eitMalc5Q2x4UXo4NjZETFhRanRNWWd5YmV4Z3JrRXg5Ym1Ed2hQ?=
 =?utf-8?B?alJWZ3VVWjdpbkxXNnI1UmI3UnVEZW1GUzNKelVsZUxhYTNHd0ZVNGhZcHky?=
 =?utf-8?B?cTFlRG84eDhmakh1SkpsQ2F3enQwQnRjWTBkNVJLY3pDaDRncmRwSFFIdGF3?=
 =?utf-8?B?NkZDeE5iZ3VncmZMbmVPdmpjR1o3TytXMER1OTRQaHJXYTV0R0gzZW9uejBX?=
 =?utf-8?B?aFNWOFEweURON291Y3hpcm9lek5uTm96ZmlSRWV5M3VQdTJ4WExQdz09?=
X-Exchange-RoutingPolicyChecked:
	AE/a7flqc/axM2hb3iq3MDvfgkmGKVDKC3NwdP7m3VpeKHeS+OpZRohwmiLtXhMF/Gc5qGI9LzLm4c1ET/lzVWx2ksZ1SddIaBGrLt5fOX154MaOW57cA5T5Lh6SR/1q/aKA3dcVNqEKPUN7SzYRRlKYcQFXwiWNQnsmNhXZK4sEq2aJkRO23nfm8o/O5ttac8ghyawnMFJ77vl/yy6L9gudl7FmRnLPsyW3UFawzYWOsZ1pCaUpIx6ePQhhEZFBBvXSX66S6gRhxMiKppGMnmbpFhJNcHxO4/5LdcvOJAeJLxN0l7oBk11O76acDD81RLsM5jZczYp5OjflxqoVAw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qqUiaWdmi59TMgjP7FZM22i+cw2FK77cWe8iDGWsyPZsXVc8rsbRSPmhZecSRpp1D4ABdLl22w/g3OyFPp/ag5MKw7IePOuFUXXrfpuqA/gPvjo4Q6sVOdFWJX4xRI/XzlqLnzyVDfGAjylDVGKqdppoiy8sqxYgwPtH/XfpsubB3VaN1baOOnJOs7J3PLqpHYmVqmBIcryzEp3ezf33iQlhdgVmNgyd6PYNPo4GuPCXd7ApTFARD6fXuC4IXLkc/0wCeZGvH0Sv/mXkGCITBjWlWxSHwo6pqqwinYQ7xgEulB3Su/UdpQsG7DF63KPp7qBBsrbnxulvws0MDDC+mvKUKstY/WOCWl2u8T2Oib454nqRplRN4wPNooDU2nM2Beo4TJQeCc86TgEPMjIYmGOzN4n8zBlDRFQ4KZO2bYzoZre4X4UvKsxR1+FUP3VRp2RReUb54VwuEmHgpmkLrWpHemi2imXYKno2VcwxR931seZlQRGEbIyrPNTwce4qFifVUG+IdDieBIm7Eq/Jr+IkfIjxo7sQPfu4Ah83cAkkyxloIPSbgWI37kf2aruQLullAThutYHtV8RbPTEAERFYeCUuxCRDNfJoJk1VPTA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb6f611-6669-4a08-7616-08deb25e5b5e
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 08:45:46.6433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRuqujrErV/ES1H7REuk/ItfVPkbcBP1AORVVpAgp+qwrflh3KWtKS5xtdhCe+aXcMFA8uMPTrN5OOjA37QTZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7924
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=720 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605150087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDA4NyBTYWx0ZWRfX9qf3vXlTlLIu
 dpl8JAdwurX/31VpbD9EbFpqtFe5bKPxInNGXGPY24EewniKZTR38VEJBk9AT4PWaEQm+jTbvpl
 L04JoqDn3JPV8VHR3yjx/yorHeguB+6OwPyQ8z3EqoDKO+2qjE2Z9Kt32nPJjRR2E2fIcHpbC78
 E7BsZlIndxOryMEEAS4wXmsaf2St4nI+cSNcHsQh6lUkhx0six3PSc8VsFsH1OK5Ig99OEq+5lQ
 xcfMc/qJLAPRqP7oZvgMxF+fYmMNUW3ua3v4UUP3yjH+mfC4BRB8VzZ6dzQFu1ONTeKWh5QH1fp
 sbHqSzeWq8KSO9+0T5qh7l/vT01WteaX77ZkF4BUM9ufxryMQ0LqNJLPobNnV8KUYThBEgFEHVZ
 BeOBQKV+xjbKSD3AcNjvCypFEsz+RPcqKJ7RvWwquqw3aamGEcOb94bTiEM3M7BdjbFjYC4J0jm
 hWmjfzKIxz907Myw7Rq95IoJ7M0dcnUgRffYBjWE=
X-Authority-Analysis: v=2.4 cv=cfDiaHDM c=1 sm=1 tr=0 ts=6a06dd3e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=xvdGyioFEyY8Oukt2u0A:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12298
X-Proofpoint-ORIG-GUID: jcYIK14U6i2GIQtkd-vSNbY4lrgbo1Q5
X-Proofpoint-GUID: jcYIK14U6i2GIQtkd-vSNbY4lrgbo1Q5

On 15/05/2026 01:24, Mike Snitzer wrote:
> On Tue, Apr 28, 2026 at 11:10:52AM +0000, John Garry wrote:
>> libmultipath: a generic multipath lib for block drivers
>>
>> This series introduces libmultipath. It is essentially a refactoring of
>> NVME multipath support, so we can have a common library to also support
>> native SCSI multipath.
>>
>> Much of the code is taken directly from the NVMe multipath code. However,
>> NVMe specifics are removed. A template structure is provided so the driver
>> may provide callbacks for driver specifics, like ANA support for NVMe.
>>
>> Important new structures introduced include:
>>
>> - mpath_head
>> These contain much of the multipath-specific functionality from
>> nvme_ns_head, including a pointer to the gendisk structure and
>> a path SRCU-based array.
>>
>> - mpath_device
>> This is the per-path structure, and contains much the same
>> multipath-specific functionality in nvme_ns
>>
>> libmultipath provides functionality for path management, path selection,
>> data path, and failover handling.
>>
>> Since the NVMe driver has some code in the sysfs and ioctl handling
>> which iterate all multipath NSes, functions like mpath_call_for_device()
>> are added to do the same per-path iteration.
> To get upstream this library needs an in-tree consumer. So at the end
> of the series, it'd makes sense to include the NVMe and/or SCSI
> changes that uses it.

I just sent the SCSI and NVMe series separately. Many devs would find it 
off putting to review a series with so patches.

