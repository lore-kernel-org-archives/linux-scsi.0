Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E254399E7;
	Thu, 23 Jul 2026 10:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802989; cv=fail; b=e5uVf4fhH0N0MbjmbSB9QMnG9JYvLEJBY9h7EZ4QT/qICRJU1UNRMc6mCkpusTrH0r4L8pKu8EEExXkvOcPsO1sNJ954ar4ypKbVjqLbbUsrS4q28pORHE3AHAxjPi1/8+gGwKLbSIS3RzwN9zyz9cBI7yLwlE1Z06QhKnWJR0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802989; c=relaxed/simple;
	bh=ne9h4xECJv9BEwJ/ZvFPVzspJ3SVIZK3MEoor32Gk8A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kXrszBACdULacQY94RP22qzt33Vb8dwahVwwqs0qqym8LfEOtgVrW0QeBdedEvzfBzqcfnlnNTFPXohzB+1USnvDwpZH1Wx/blzH7PHcL7CoErQ1qpnN0TMgUABU9zD3rtvNiA3pGnZaTlKM4mbvn2TacQu8TUDq7NMvhVKku/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EzyX/fYZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Flvrlemf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EzyX/fYZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Flvrlemf"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtXDZ3495187;
	Thu, 23 Jul 2026 10:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JJs7F1Jv56H6j/qkSgORH2U33Z3NojQS8aDO0p50XJE=; b=
	EzyX/fYZf1rDQH8pxfQegh7Xwn7jn5juh4XKyOxJzp64vops6/XqOV2cAM/XbE/k
	ccKuAHVhc2y9Dh7COjaGBsyWFSoVdnarMuR6zf7SO1TdzWiiAAP/F5/b1139uAPt
	gUNfu691a8DJhTxbnq79ofPlB+14kGsHh3ZTbDJpiUVBoYJMFJMO+kyNZEGuSLf1
	DueJsj/IWC27PoutHlZpYrJjSXg2fNgDXK1PtHO2tWVWxEb41Un7+gm3YXEldYIS
	VqWTU2+dRT/6D6W9jgvG+cha/O/5eJjzE1/X4EC7rtDzgnQsXSXL2NR3HftMYEvA
	EwDM7D3plg+8+yH1WVvvjw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpxpyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:36:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NAX9sn018226;
	Thu, 23 Jul 2026 10:36:21 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012026.outbound.protection.outlook.com [40.107.209.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts10ke2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:36:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fprU6BVtJywDOsW85jp6AxOTxajZNqgk94H6yTJHV/jYOutv5WbBvxPrZd/lPOfOPCOAPyzWJ9mRpaCCLxaVUwdL7mCylaBJ4gd1dRk4YMaUQAOMdU4CA6KtlpI7K77WK0mEU1kkuaMA4p31mF3lRq38b0L53ScYxUn9WKTScEo+NqwZ2oNl0bIlIJ4PkeMJk5+alaP0DErrjL6M6CVff1wDlAW3bcQgQuPPm4Vwzs92odGh9/AVQ6QRMEILL6DjZ7p+TG1Sp7J6ItC720hMMFfT6+ETIx622G+l3fQEasyJiTEgZxsTc2CczrQMVI+mQV+5xLVPRxLo8/qyqfWdww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJs7F1Jv56H6j/qkSgORH2U33Z3NojQS8aDO0p50XJE=;
 b=nXhLYI/2gEY7+/XQwbyJY8LgZCVDcCvJ4HB3HjorYtHu/FjW9uhbdCDqF0/+BtAlnv7AmI0eshc8f5TIQkGA57x5qWIChfMDoPt6hYLgIPAcH1vZoSNg+AlLGLOPI0pWd1eCNFZhwu4OnQehSK8M/XifJSTRbY0rMcMgUVlPh/wCI9bLbqMBc3n74IDpOJlJx55n58aV/1rV4TxY++i71RsZBi7DzYmTCTSs6825VgXqlcMe55ky3IeWN5b8v58XLbmV+7NRX5t+s3DR/OAXEyIU3/sjqHsyXF6hQvGBfO/S+kul2EfQyfNMMHRYaJ1Nd2gwL7pwobDDpjaEP0u5AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJs7F1Jv56H6j/qkSgORH2U33Z3NojQS8aDO0p50XJE=;
 b=FlvrlemfB//yC79JaqB5V2QWXRhNDBTHXMtZCF0FlTyktunX9bpCKb3YlZE5k8wefIvAnkuKGyTQ/nCGqzOVUep9BApTSAqQ5cWMD+1Z2Ehk5eFPUeSHji75oatHqbs49fHxCUrXiOzRgO32PymYc4jhOIOXe+1r+8A7tc9ggCc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 10:36:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:36:16 +0000
Message-ID: <418a50ac-e4e0-428f-bf55-a20dc8929ceb@oracle.com>
Date: Thu, 23 Jul 2026 11:36:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/28] libmultipath: Add support for mpath_device
 management
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-6-john.g.garry@oracle.com>
 <20260723095834.326961F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723095834.326961F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0020.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eac6677-6ca9-48ad-6a5e-08dee8a63983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1W6E3JkvU9N6usGVeMRTLrMQObBbF7517JTHg30oT0GOk5kaAIZUfYo207BBjRJfi9w/LNInuC+H9/X/5i4oDTT0P7A35IWsCuhwfvNkdgCB6aZ2Iwf1TuPwboglgmm7uwoO5W6XoRBRl1dnSOS3unmvs/kM6PfEzq/8vl636aGvPEiOohGw4P5ROxsKtVVOaYcDjiEN35ZwfT52aok2SQ0Arsz9OH7E10zr/SF58PtG0yjWd2Zf12tmJH8UhHO0Xrvv5W0unMOGvYoVxgAtMtkQchs2cG5AYMzkm75ecmhBmvjHk3bWAvT+QHZM2Xaox3LYJyXyXOdBTXliuM39QyiRzVOFgxk07ymM52B+/eyvb0zOg64juPcWOzsTsc0yNwr1WtFdl+QQxeUlqvIQhIPclRNvjm1DQAFeUuhpuVAPrgxuX7dVVQ5RvxYBKetX2BwAj0kol7KG5nXDRI8GbpfISicoAcmaqFTe0SzlAQ9Bn0SgrSRTiKwqG6XghHYbpT/brobA5wJXygoAbLA+tHybI9nUTWb7yQ6Zw8KmuylBNXS2OUsdgOxTfw4sreNT3vCSSB2FHOKXOd9PeGGxlrqDgwEgVymxmf7exn5eExba7DaZqoUROym0xGBKnK5vI5gOHVCSLw8GTkKSQsSnFEucDQQ23h8MB8u4otGzsTY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEt1WVhiR3ZZbVVGRkVMTEZMWmttTmpqZWFWYnBSU0lRdkFvbkRMdzlKbE44?=
 =?utf-8?B?QVQ5c1ZBLy9ZV1c4SHVGc1BzMmZzSjBMcWFZL1QzMXR6Z0VrSU0rVGE3K1ZX?=
 =?utf-8?B?czhRV3F6cUE2TGcvZDRzMW11VFczRGQ4TTJxeXhiOWp0SEhCdUE4dzU1czRJ?=
 =?utf-8?B?cWtsemxVaWZidXJpS1dvVlJYQkNrR2V3bDBrSEtDRVFzaldzdW9CcExnZDdo?=
 =?utf-8?B?MHBjS0VjYnBZYnNsNXRFek96aFV2c1R2dTlRSkNDWVJMVmk2YnpaTmE3TlRX?=
 =?utf-8?B?cjh1d2V3dkpZQ3FFZGdURkY5WXJJc1lBZHdCTDRxZlA1elNqd1pwcVlLaUNv?=
 =?utf-8?B?QVkrZTVXMUNueWVUNFhiT1pYQXJnNHA4TjJ0eEJSeGxpTEhtdU4wZDdvdzhs?=
 =?utf-8?B?NDNXYjdJa0M0RHNCbUxUdkxWaUs2UTNWWm13MFFSYzA3dWlVUENndWVLT2Np?=
 =?utf-8?B?SXdJL0lMU2c5M1M0WjJ5RC9hakdnelNBcGFDcDF0QzFFRlJ2Tm5md0VLYldM?=
 =?utf-8?B?Wi8zdERyYmtoQlkzUHhVRm0zWFpLQ2lMOTJzS0wyUXVJZWpSMDNLTThJSmU3?=
 =?utf-8?B?cnlxamF6OUcyWkMwTlpNMWNPNjZXc3ptMHplSHZrVklBUnA4eDlabHpzRDhG?=
 =?utf-8?B?RW9xdHBsQlpSbjlRUFlKZjFNaXZmeklVenRCZ3VodFFEcS92bGtSQzk4ayt5?=
 =?utf-8?B?NUJ0VmJEY1JidWNtVERLTE55dkczMm0wVDFOVm85N1ErT3l2WEp5K3phMjVq?=
 =?utf-8?B?LzVMOFQrRVV3ZjJ2OWVCQWZ1ZXQrb2swQVlZYWlCQWRGSHkrVzNBVzNjTUtL?=
 =?utf-8?B?Tkp6S0tSS241eklGL2YzdXZLdVk2TnYwMU1aZ2YyRm1RVFlzN3oyY1J1cFQr?=
 =?utf-8?B?dlFHZ2tpYlBFZXFtdDVkSFZHemE0cWxmTWFLM3NucGVITXdHS3pURFIvU2xT?=
 =?utf-8?B?VTJBU0duYS9zN2dUSWZZUE1Xcy8xNGlNWVdPNUxWM1hUZlFncmN4U3RWRkM5?=
 =?utf-8?B?ZHAwekJldGJPdm11QkZnYlpKU282NXkxT2J3WnR5Vlc5V1FEUHJsa2pjaGl6?=
 =?utf-8?B?MUZjTVA5NGsxaFIwbktKWlNwb0t4K1FNd3FocHp0dlRsWDVrdUYvYTF0WlZm?=
 =?utf-8?B?WkxXRUQ5bDVRSlcrR3NJMVhxMWVobkc0MHRNaFhYSDVMV1NHVHlpVUNzU0xE?=
 =?utf-8?B?Rkl0WnVydVRvd1FDbVJCRHlRMGVvR3I2akk1Ukp4Q21pZi9SVUpyc1JjM2pL?=
 =?utf-8?B?ZDRLWnJGS2NyUXBjMDBrOWNUb2N1L003cWRlOCs4TkZ2Sm9zYW5GRHhHemZM?=
 =?utf-8?B?V2xjTDR3eHdoWklCcUwrc2pTOUtCOWZVNGlldUJsMHVqRVdtVERUZXh3NVZz?=
 =?utf-8?B?TWhGaEZldEtzdXlVbW5ZVWplU2xReXVqT29pNzgxdWpEQnhYVnU5UXppYngv?=
 =?utf-8?B?TmJsbnZNUXBJMmE1UlhxK3prdFVrRWJUYk9yWW5jRWw0T0FrdlZWYytNWjN1?=
 =?utf-8?B?d1JLTDdXK3Z4bG90TjlUN3lQd3VOMi9WY3M5eXlUZnE5Q1NINFNSaEx5YzBH?=
 =?utf-8?B?a2RXRERpZmFRd1hoL0VXS0tZUkh2T2NPZkQ5UmplOXlsQTdDSTR1RmtJSzd5?=
 =?utf-8?B?b3Zsais5UENROTFwM2FzbmdUZ1hIbEJHQUhPeVVXdit4RXpYZ3FUTkRDajVL?=
 =?utf-8?B?ZVAweWNETDJONTR4ckYzaEZTUDNNU216MGg0eVN1eDlYT1A1STROdlM0YzVL?=
 =?utf-8?B?R29rcTVxRjFQOHhwOGNMdUEwMXBlR1J0ZkhNUmVneHI3NlFKUkQxb29YUjhC?=
 =?utf-8?B?WEFpUW9pZzVpSkl0emF2SW54N1FHTDN4MmNLSmloUU5CUUJObklHR0t2TUd6?=
 =?utf-8?B?Z0FsRFB0b3g2UzFTMzdLc0kyN0RGZTVTSzlmeDBRR2kvTXZtbUxNR2JBSW5Q?=
 =?utf-8?B?NSsxY0R6QmRrOXpWVEFFV0N3K09GRHF6QU5HT1dKMnhvdkk2Wnk4bGxRTzZE?=
 =?utf-8?B?Zi9LL2pqd3ZhbUU4aSt5TzJJWHZJNGFZWDV1TFNxejdiZ1o2S1dLTU9tUEVv?=
 =?utf-8?B?MnRGaWJSWmkrWmMvNENSamE3V2NUWWQ0VnFsaHp2SEpMalZSbVB5emx3N241?=
 =?utf-8?B?UWRDdzRpSjlSeUlvMzVxVFpXdnJ5SU9aQS9yVEg4aldRUXdxcmN3RzB0K0Zu?=
 =?utf-8?B?elJHK0gzR3I0bXlEMnEyVWZTcFpudVkzc1F0aTRUMTl0UHU1aXlHa0xocWxh?=
 =?utf-8?B?aHFGVWpZZ29Ja0UwUUlQdHR2YjBjN1BoUGxXUEhvSGl1OHJ1UDNFVExJU1pD?=
 =?utf-8?B?cTI1d284VmZCVi9tYWxPYmRCMFN1U2V0VTZudTFnYk1sSHNGK05uVWxaWDBw?=
 =?utf-8?Q?ITemHs5anCmIGzwk=3D?=
X-Exchange-RoutingPolicyChecked:
	rjUJJqR2G/A3+KwtJTaxti98x6ZCbq9bvVxso26kxT45o+2+uVzcaa9fqCNXQgQyGuSsSbqlCSZ+KMImz5g4bknwtHNwWnVeCZzNTaA0MXFHLkvU0xwPJMGdgO8Y353I2d8lu3MnYqfWPlkAJ3xRv7cyLTq6Vd5wPFWlgIY6lUM0G2hNh92mGwoHFktoSmf37NOy5TY0M0MI2IR7C+Of1fNnaUrc69PUPnRht/nv83vkhtD7Jax2LPRkB2n7zJNlLjPy1J+FobqYQBkn78frcP7WVEWGbc6U+OtWG/x6zBdBMPwTAFGUuJGzefNmXHoIpBCiW417/zHFqW1UK6pBgQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HwoM/c505q3yhDo18FpSozXq7JyYgndTP6PW3JoHH1OFm+nisB6L8CICfVtAFXLivqSHuziRF0y4/cvSeNUlKNEzGv4GSA22nbRH/ovgSm/9/i8PZGHKVCbU/qtRSWAY2TKwA+vcb1AIyRESCsJ8cQiCh7/4Km3gCeIJzrAWGz+zuX/SPHRC/eC0f1U1vX8NtxPx2VPurmnc5S7ScWgowWmgpOlNi2TZFnb8oVfxl2s5HthVT3L0+ulN8HbpBfSuc+k/TJKP1MMOqHQZ0lOMDmhRBScDIAwwGxuCQisvSFPgeqneZiwWzxHaqpJ/AwHCFMFTNqWyEEE0NwQ0zlnQM4F9k62CQodwHLEmDECSPdwUTcvRezN8XrO2aFdJcFxSuNK/rRK+TmnvG2Y7qTlwAl/9AFqvAGv4th/JuF5WUZplNZZ/incVjBvsNZpDbIfXwagL+QkAEqCzoyp48tcenC76JcUhqL8jeZHHZZsIL/7evJY/iZi2kF9AxhfIZu3zx4Z63WpRdzE7i7p5/cGanVl86Kdz9hCblmc8wgYTn9XIwwCYA/a7E+Eixhnz+ODnWEAYQAoQyJl40laanHCOgtvg5BP9rtB98M10J+JRKTM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eac6677-6ca9-48ad-6a5e-08dee8a63983
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:36:16.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuTecvSKwQpSvGYfSfw63osiCYFQwLJHOgVAN3dfDTH9WokPR89dq+LQO7ZVYfVMQ6b1ydlIy1KWglB39innqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230104
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX1w9MssN/KsB8
 YLwwmHOLcRo26S+kKKY95xJyOVk3JjYomuJXMvN9SLD9wlgcp4iFUoaauu4mIs4aZBbmLF5A1wT
 DFRN6WIVnIhdrfx4kPLRS+DJBIZFSlyu4IIiu1EZ7FkYTVBQ8Nm1
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a61eea6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=VKVJO9tJ8nASwupeWdcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Z_hyYLz_ZOx0hI-HZb4tEM2yZNh6WJz3
X-Proofpoint-GUID: Z_hyYLz_ZOx0hI-HZb4tEM2yZNh6WJz3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX56veI5ssasAX
 nLD5aVzoTNrH08I88oY9+HEqw5DBdTCCOPaxfsSWCbci2OeTBKeFgK4PcGx8T7NqJLXo2Cv1v4S
 FZmbE0hTO4wL7Y9dNV7NpJhgvIGxQToegE9nhyocAY825ZSGa9aHUAsFqaKUXdkcuWP9oLYMM2d
 KUKluXizTfBQqMW+me7Jgczcds4SFJsBbc05nr1smc+/rZUP90Kl10dYCedp9wRpsCfDdVRA0rd
 tzlPIekLarkGmMlCO3LAaswu8/AFo5yxrSnktyJjGwLU8Ha9Jiw+o7x0wC9vinTKS4FBwnoIodv
 FUhYI3ak+Xz4ectEC3k/uxifDjxjO68+8ZO1HKeCGTU3XsaCQHo2luqg/FFYW+SdzrmQAKrw1tw
 4R3xpexq/F9McxQr8DcLDfvJK+oB5B8mWyZSdA7LMs6X/mYSQsNLP2tIaeB9kxlZEQIMpj8lnhH
 YPGu5iRbkOZLteJEQTA==

On 23/07/2026 10:58, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mpath_delete_device fails to clear the device from the current_path array before calling mpath_synchronize, guaranteeing an RCU Use-After-Free.
> - [Low] Duplicate function declaration of `mpath_synchronize`.
> --
> 
> --- Patch [5]: [PATCH v4 05/28] libmultipath: Add support for mpath_device management ---
> commit 729c9713b67dacb1c3c3c943a84db42ae105702d
> Author: John Garry <john.g.garry@oracle.com>
> 
> libmultipath: Add support for mpath_device management
> 
> Add support to add or remove a mpath_device as a path. This implements
> functionality similar to NVMe equivalents for path management.
> 
>> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
>> index 57d13eb1450cd..6915c2a979642 100644
>> --- a/include/linux/multipath.h
>> +++ b/include/linux/multipath.h
> [ ... ]
>> @@ -89,6 +92,17 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
>>   void mpath_synchronize(struct mpath_head *mpath_head);
>>   int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
>>   int mpath_get_iopolicy(char *buf, int iopolicy);
>> +bool mpath_clear_current_path(struct mpath_device *mpath_device);
>> +void mpath_synchronize(struct mpath_head *mpath_head);
> 
> [Severity: Low]
> This isn't a bug, but should we remove this duplicate declaration of
> mpath_synchronize() since it is already declared just a few lines above?

will fix

> 
>> +int mpath_add_device(struct mpath_device *mpath_device,
> [ ... ]
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 448d879abb354..20c633ad7e1df 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> [ ... ]
>> @@ -50,6 +50,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
> [ ... ]
>> +bool mpath_delete_device(struct mpath_device *mpath_device)
>> +{
>> +	bool empty;
>> +
>> +	mutex_lock(&mpath_device->mpath_head->lock);
>> +	list_del_rcu(&mpath_device->siblings);
>> +	empty = list_empty(&mpath_device->mpath_head->dev_list);
>> +	mutex_unlock(&mpath_device->mpath_head->lock);
>> +
>> +	mpath_synchronize(mpath_device->mpath_head);
> 
> [Severity: High]
> Does this leave a dangling pointer in the current_path array that could
> lead to a use-after-free?
> 
> Since the deleted device isn't cleared from mpath_head->current_path[],
> new I/O submissions starting after mpath_synchronize() returns could still
> read the device from current_path and use it after it's been freed.
> 
> If a caller tries to avoid this by calling mpath_clear_current_path()
> before mpath_delete_device(), concurrent I/O could potentially re-select
> the device from dev_list and place it back into current_path before the
> deletion acquires the list lock.
> 
> Should mpath_clear_current_path() be called here, exactly between
> list_del_rcu() and mpath_synchronize()?

sd_mpath_remove() calls mpath_clear_current_path() and then 
mpath_delete_device()

> 
>> +
>> +	return empty;
>> +}
> 

