Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D2F33E347;
	Wed, 29 Jul 2026 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345891; cv=fail; b=jMk0PYiMHYKRg4Lu5Y8eazvLe8y7s3q79pmRTreZH+Ajs9GuFBro1XIVLbzVGzncERZy509mbkv9U4HCSAbEIUtvL4U2ZFUzv99ulPTOEZhdqu/Lclo67np6zwVWfbldTEJLJo+4vhjExHgk5B6d5DyfFKvM+KsUb1fb8M2Z6t0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345891; c=relaxed/simple;
	bh=X0Al03h/Xzp28gssUL314BNBtL53Zl/eBBlsZBy3YD8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AJ0wXEOLitX+6zcwQ2nzVH8Z6/9SEbgYyeOaoVy0pqUPLyCS4cnz/k6diqNC1wuvjd8O38sprPbbi+AA0Jxan2GtWjHY6fOwVDWETw/3w9Ma98K3GKoaR8ytt2+xGFY1ZnqZiRIqrtSAgzx6cI/Vv0U0ESkkLZDBIk2/0+FvciE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eVoQfjY+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XTv19L/2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eVoQfjY+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XTv19L/2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTJr64018842;
	Wed, 29 Jul 2026 17:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D520K+zfdAaQLBXMBXvymmHEruES3vL5XgHR967izZ4=; b=
	eVoQfjY+XcwwIAm8jIrKTlZRzq4yg1h9zzq94fwsh4Spk35XA46uzBgY0RTjiXIQ
	4gWEOMjeOPk7fTOlVyeT10Iv93/+BgiENWG7/I0FCPzOzcc7SASXGo+jzLpY04m/
	Xr2kX65K8O/hR+EjXu3Whsi6Krf2pd1/Ug9GxHPYPJi4tx7Gaovyy7km8sNFAkc1
	+8f71wnX/P5hZuzN4qrhQRPGOuW3Vy7emqnmHdEAuLTVA9BMU5ddokaV/7bw/BPk
	mj0HY91a4GrQkAkIor1wQNOcPO8N98rbHl0huThRuaTjRzfvkrjAHZjIf5+1PEM/
	ugJ9QKupm1P9JahuW4UZYw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyyefdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 17:24:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66THK7uu008879;
	Wed, 29 Jul 2026 17:24:47 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012054.outbound.protection.outlook.com [52.101.53.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh88g27e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 17:24:47 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PMPYg4CW8tIKwE9SocBT9Oz8iweP7/TBidUJ00T7wwZ+ak3VN95XayoyJyeKhjORse0/UHBZyyZ1vwO/6ZX8B1iKl0lIT0iGfn/DItvjGn//5BkQyt8GmjgrwXyXEwhfGagnP4mWns0HlS6wYb4yeCzms/CyKz/MLxw5Ttx1jYZNUlQuP2IO8D14BYXT4LtGna+TsOrD8LAZ1LdWMyzk1cVrKhw6kTQ+N4PTChCPt7Xy7xX+ULdTgCrHitje2dkumK/12Hy21kLpvho+xAPTBk0uCpLZvTrBX+ZKshJH6J9OkhkInhe0WH9LUx3X8bJPcHxg4ynztfJzaYB6ygG+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D520K+zfdAaQLBXMBXvymmHEruES3vL5XgHR967izZ4=;
 b=yMLOOalvsSscBePRBvEp3AUtS0ycnjBw6mp94YVktD3iZhKZX7kul9oPi5atIdI6EzLQj7bcCq315VJ5qZ5IsQtCmPXvkfTTrB72WR5xjStfNtwk7WEi37L1sIwsLxnerFrfQfev6YQ/mDcB9UIOeyOZ5Xc4ERjQRZzWLK2EsVwM1BgsBEzyRxahqmYsOs8AxPs5Yrk5si+sasuWDb4rZxs5ragi0l8Amdp1ThwWhblohcXvYdtQ0bTYsjfE3rtdHkoG6X8sqOoapVR49liq91vv9i8KlSm1NMiwT48jaqfC9gi/ly+d3Z4vUrQZwX9B30RsSR/cHDvEGl1UtFdakw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D520K+zfdAaQLBXMBXvymmHEruES3vL5XgHR967izZ4=;
 b=XTv19L/2LoC35vvuRYYZ46R5gpdW114krtYYamobKZ25EQiJ9mhjGcBRNZUxPXpolIHQ092Vz4lBckkki02oJbtu9fyy9kbXTOkOJ3E6YAf6dvvdNpgjaVuO0y/q3flIXl53wLEMOeLAZbyI/44rWJhQiXh6T/gDXRlkh8m1jBs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB7401.namprd10.prod.outlook.com (2603:10b6:8:188::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 17:24:43 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 17:24:43 +0000
Message-ID: <6f2ff971-c3f2-4cce-93b6-6d4f32ea3809@oracle.com>
Date: Wed, 29 Jul 2026 18:24:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 24/27] scsi: sd: support multipath disk
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-25-john.g.garry@oracle.com>
 <20260729170140.87D7D1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729170140.87D7D1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0029.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB7401:EE_
X-MS-Office365-Filtering-Correlation-Id: edd943f2-e2b2-40cb-aafe-08deed964787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|10067099003|18002099003|6133799003|22082099003|5023799004|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	2CojosQl+G9qdTwvivrr0hvvN/brpDh8Oe3ZDoBxWQ7Ui2LlGTqj8ymjWdK991Auqsx4C+a3gW+XYolo4+Duqa5Q4k39anCHQJtHkYXnoHQVBfAeYCX6cixrvL0sYsdQEHNCChjqKj5HB4BOIMmYa99WfgPI3RS/SCzFBkgBh6G4qKumsx1coaeiOoTvNvPEifvGvg5egV52zZD4LfWP3Pwn6ZssFK8+vDvSx2O16hPbnKuz1P7qZ+KjU1aibh4FnHijkGAzAmUaEAwkSo0FJVJdXxe8LwJ9a2k+H0JW0JGLxV/sAZQde3PcwJhXxJbnWGlZHufsg7fLS3Sja6bX7y5XBRDjPOF/LvPQcJp8Ij77EjfInMfk6ZFoA3/7Ge0YXJ77qOHLF/ZVVZj4WPNqhAoaLfa7EJpampIsU3/OOArQF6an/AJtdyxmrcD5HS/aG1qKxHPvMURBv9eASSdujy4QK2hpQzAURHJ7OVDaprjxhZqzf1dtsQUdruQkfiYQTn51qRJRZHCT9dfPaXGD5JND6ZD47pApgw8yo7I9gXJcyUbH3wzuS3TFF2uENRv77+4HWEiT1v1goE6ITcl6ZubdciF4+RarybNKMKku8g4krLugqbSw+/xNFtk7Ump5FqkcBCb1y086uL8bm0hF6xy1CPBiicfotXi7pnJ9PEM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(10067099003)(18002099003)(6133799003)(22082099003)(5023799004)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjRvcG5oaVo0dS8rOEdXY1Vxc2hoaXhJOHRFRm5JOTN2alFsNm9SRnRZMXNX?=
 =?utf-8?B?dnhzNVlPc2J2Tm8rWFFyZHNrVk45THNjVWFlSEpTT1BESVJJcFVYZm1JRGF1?=
 =?utf-8?B?WU9lVmFxK0NtaU9EcEhlcFVGSkw3SHM3ek82eXhCMTdGZXhIRnorUHBBekhy?=
 =?utf-8?B?WjNwcUhvSjNBemJCTi9LZUpjZ2RzaDFLQUxOb21Ta2JSdHA4Z2VJY3RFVzQ3?=
 =?utf-8?B?ZFYvYjQ3WU5DZzA0L2VKMk5lNng4VlBIZWtSbTB1V3pVczg0YmR2a3gydk8x?=
 =?utf-8?B?cWI1blV3TWdLVG1Yc1p3SkRNLytKalpWaFZYT0UyVVYwdlNUZXduQVoyQ2xQ?=
 =?utf-8?B?aVVQUFVlYm1ZeXdkdWtCQ3NzeHVWSHY2VXMzU2VzMzRFZWpGQ1FxNk5BZlVr?=
 =?utf-8?B?UEhlTnFqTDRJUHpVTmhoNkZPUStEbVUzeTh3cXVHNGw4UXdrc0g5RXZFY2Nx?=
 =?utf-8?B?QTdBZkk0NXJQV1VjYVY2SG1XMDYzSFRuMEhLMEJ2UVIxMVEzQjhIbHljMC85?=
 =?utf-8?B?eWRoa29RdnowOVdRcURWejcyTjE0YzRJemQyVVRjY2I1YytzRXJZUElPMW0y?=
 =?utf-8?B?SU50Q0YreHNNS0JCUCtZZEo1dkt6MlhUaHNVVzNxZitmak5CV1VpaU80eVNN?=
 =?utf-8?B?Q0ZlRDRsWUN4dVp3OFdBUlJyNnNGWXVsekN1VXNiTFpuL3BqN2J0V2VwbHl0?=
 =?utf-8?B?bmFIVTNtNE1IZVBwMjVOTitkem9idkpPMnZHRUw1djBGMmozOXQ1RnAvRlE5?=
 =?utf-8?B?UTVuWWkwRDdkWGYvNnEwZjNpZExCS3FlZ1IxV2JXMWsrTmFZMlJzaTAyRmU2?=
 =?utf-8?B?d1BNZmlCS1lDR1VpL1huSUJ1L1lVd3ZiNThaVVFrdkVYNE14NFYyUkg1VnNh?=
 =?utf-8?B?VHVCUzlSbzZ4WVpiU3FETHY4UnFuNHk1N0krNGNyR3dJSWZDQXpZU1MwNzFy?=
 =?utf-8?B?TmlXUlJJWk1QOElzWWZCYVorQTVpYlVxS1U4b2k3aUkvb0xmU0c1RUtjWldQ?=
 =?utf-8?B?RmE1cEhNM2swRy9Bd1ZVYmEweFh5QWc2ME5PRjNMWVYvNXBUeXc4UjVWdkpO?=
 =?utf-8?B?U1hDSFNvNWEzL2p4UkM2bDBVdGt2K1daL0ZoRFMwQkoyNG9sMHk1VlN6TUZk?=
 =?utf-8?B?U1FRZ1VRaEhnN2ttR09SWDRIYTl6ZXZ1cGQwdW92YXlaUFU3ZUdyM3BRdkVp?=
 =?utf-8?B?dHM0c3dPTWc0clpnZ0poalcxRzJkWXBJUXdNY0NPQXFDNHVoVldvaDcrS0lD?=
 =?utf-8?B?TjIrT09BUDhDNFNQTlFrOXVldE5GT0t2dFRhdDJxam0zbzk2UGpYZlBxNmJj?=
 =?utf-8?B?aDhZekFVN2RndG1aZDB6VCtCMGpVUk5zYk82eHFWRUhRZXgxaWJQT0ovYi9O?=
 =?utf-8?B?bGVqajFSVDRnUEp4N3E5YmNnT3F5WVpFTDRVcVhkNFFkcndRVmxSYnBnRHlL?=
 =?utf-8?B?ZlZlcjVlbjBEMXhtWUFPRlpzeERvOHFrZXZuS3FXNEpaeUF0WFNySS9ld0pC?=
 =?utf-8?B?czJYMHhtVFVvMjRUREdZWnhpRHF2UmxlV2ptZHhydjZKTXRiYzFCd21UTUc2?=
 =?utf-8?B?TzhITy9JdTI4Mk5QSWl4NEg3OGo2WU83OE5sUjdWemlYNllCSWRLZHJ2ZkZJ?=
 =?utf-8?B?RXM5ZitBczVkSEtoUVVRVDFjakZDZjJMYzgySlNGV0VEMmgzZkRFWW9lRU9I?=
 =?utf-8?B?MmNLRDRxMWZQN2hIcEcyME1wd1ZVZ0hRMVFNenBHSWF4ZEtIeDNaTzNKRmNK?=
 =?utf-8?B?d1Y4NXQyWmtzMC85cW9jTmZTa2ZTT0dyRCtRemtDaHk5bHl3aTl2Y0VhZWRi?=
 =?utf-8?B?U3I3T1JNRTFJWnZXVy9raWdQa1FqVFgzaE5Hc2J1VkpwbWpxV2RsSzVBVVll?=
 =?utf-8?B?MStGcDR6NC9LdGJJdlhDMk50aUY3QnAxcHJsSElTbWVmNnJ3QU9JQ1l2NWVU?=
 =?utf-8?B?L0dGK0lVWVNiNysrdlgrWTBpVzQ0NEVhM1BOMFNiWUVnVWNIT0UwL1BCd055?=
 =?utf-8?B?ZVdZYlpwOXd4cTNHN0FmZ2o0Y0tsa0U2R3lBZk5TWFFObjRwWGkxUWl0MDM2?=
 =?utf-8?B?Y3k3VHJOTDZ5L25Za2RDNTJBOU00UGQvTE13SlUrN2pRWXBXcUlsQmwwS3B4?=
 =?utf-8?B?SmZETzJ2VzdjVzlpVDRVRXlsMSt1Q2twRTdnSElpckR1N2ZCR29ndEpiMTkr?=
 =?utf-8?B?THdubGZRcVBxYWJRbnRReVdjTTh6WmVZVFJ4QWZZNXpHdzZaRHliVEhaNzZQ?=
 =?utf-8?B?OHlGNFF6Z1Eya28vcUpnOW55ZWZRR2FrcjFSUnFJQ0JiTnMzUkw2OEhhY0hl?=
 =?utf-8?B?QzVhUWR3aFBNTGV4dHNITmd3b0xmdkc1cEszcXhld3F6Y1diNkpCWndwUzdX?=
 =?utf-8?Q?S0mTNNRTWXLMYZGA=3D?=
X-Exchange-RoutingPolicyChecked:
	UMfrjI+KM2kidCR3l3iYmWAoeARU49vnPPwKnSqj9PanQb8pDdj5ykMI/3F7CuMb8xnuuqvteYrQ6gxZf7FHtDGs6KOf9gdLs+5ZmqxeXzCoJzZLW1jat79Cf8rmkom0ZXslJ5mLoCpYfWuh1mPvbHn/yHEQ1XZll9vQZAmAgJq0PMaWJsYA1bPsAOt77bCIOuao9Sq9hA/FP4T1B3iDZFFq8x/0EY6Vm+L+iKyiUNhqr+txlIwe7WhL66L2Vrdyse6qnTx1pRx/eNX+HQkBDNeEspgmYInOx2Sifl3/NXCtp8fi39Q1VnxA2mmaOXTOR1dFqkPW0jI7dKMExPh46A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R9CSbKGUqsvoAqgMl0QFmrcEfODMkui7ojk1tLu7TDzf4DApw0Q6f69kMcPyXi5RiEBmvMfqX6fLDeFp5QwsgpMdQpxnETFWNjq6BWJG+NSRgcUuDtj+qQjwSPUfivNBdzac8HCqy5zj272ToEj7lkD0Wgr23lLybJZH9hIwkEq17ShvKIHKokT0Ix8z2l9MvYQhVExPzSIfi9zcfDQbECroXszD2wnvnyzcpbCnNnjq2foLMdSQe40JDV8i347gwQVpsOTdjdUhO3weW3f5codoT89Yn7GxzQrwTcl1Y6s14rQ8zoIR5T4zZHlATzc/sMU9OfwXxiAEEcSk60k1l829vtVMyx9E1f+/jYtckm4X4NhzhEKIIli1i3i8zhemOnSF8d/x08GNhAaydq/LTTsLIrqw153WvAsI14mIh7nj52dnZ/HUXd7hae/+kKsmOZ4atlM8+ZBCOBoEo8+40Cs32wiONb0hSANYvyiUh2dwKAKII2FNfJKR2Ln5R7ivRZi0q3/95ejwAFgIfmoMufO3YHD43hyarJBViSfD2xJLijwxNmV3LuGwObMvKfdpO287u2bAYlTdgshh9DTDjX40tuwCzGDD443MbBaeKxc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd943f2-e2b2-40cb-aafe-08deed964787
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 17:24:43.7336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n6uC/diDrjk0RxRjM5E4UEwIOttZl72fXtRVvgVrCjRI5cV/67c3KdPV42/EgtYXsWr7BDEvmP46V/m7GD7tJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7401
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290135
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEzNSBTYWx0ZWRfX+x+tpmuTC892
 klkB9JXPx+Y45z59ryVkSlAUV4VJtUrnEcxC0Kcmpy39NDHOp7GXc4CI4cPR6bBE5XXPpcA6JGt
 MqkWVOLSbtl91ArBXaI4mVj5aC8DsdhzLRWqckOfCyD1Ce4/apfh
X-Proofpoint-GUID: Z1PEbFXidQiEOR-dWKx6NDaokICUfgnU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEzNSBTYWx0ZWRfXyotIRbPBm8k0
 GH3PSLVEaShU8MqeYdr71Ongm3xB53Gpdj7YDVHtadDAHf/2fUzmrEFdhGWZzBCidw8pJwIZtld
 C76Nnn+PrV8TasDpAM2rsbQ2AiQVIXO/hfS20siRME6vDO1L82unoIRZYKrVvL/35ZJJ7LBCUvG
 LVig4IdvkAWwDWquMQtTF/ljrasXvdLTAQDyOaUuCskjooz/1N7tAnuVZdCDi4xFs8yEAA/uKHP
 RHJ+zorxqR5QtY84Ak2B+audpS0LrJlB3rzgqzsZ8irAbRDNx9MVIss7Y/XeSrTDLXREjKRD9oV
 6/6PCHFBMYYcfPr7qaLcKnieLIh0FUc6+8sPmcXzGsEyWzc+AFmdLqYAU08Z64Kvcld0dG5qT4g
 DFuwPSPMs6QnMxBPBTLTbn1bvVxlYuIMnbYl/8w3Lu2fRJdQTMjIQ+yuCtmsDOLdUj7DmtYOx4G
 yrb97wytRQk970ODK+g==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a6a3760 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=A5Bp3fRWhNMWBuA2IKwA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
X-Proofpoint-ORIG-GUID: Z1PEbFXidQiEOR-dWKx6NDaokICUfgnU

On 29/07/2026 18:01, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> 
> New issues:
> - [High] Missing `put_device()` in the `sd_mpath_add_disk()` error path permanently leaks the `sdkp` structure.
> - [High] Inverted device teardown order causes double `device_del()` and sysfs warnings.
> - [High] Cyclic kobject reference between `sd_mpath_disk` and its child gendisk guarantees both are permanently leaked on removal.
> - [Medium] Ignored return value of `scsi_mpath_get_head()` leads to potential kref underflow and use-after-free.
> 
> Pre-existing issues:
> - [High] `kfree()` is called on an active kobject when `sd_large_pool_create()` fails, leading to UAF / Sysfs Corruption.

That needs to be fixed in mkp-scsi tree

> --
> 
> --- Patch [24]: [PATCH v6 24/27] scsi: sd: support multipath disk ---
> commit 1896d58c043437e813525b463ccbb2249c843f33
> Author: John Garry <john.garry@linux.dev>
> scsi: sd: support multipath disk
> 
> This commit adds support for attaching a multipath disk in the SCSI sd
> subsystem. It allocates gendisks per-path but marks them as hidden, and
> maintains a global list of sd_mpath_disks to match with scsi_devices.
> 
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -115,12 +115,30 @@ static mempool_t *sd_large_page_pool;
>>   static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
>>   static struct lock_class_key sd_bio_compl_lkclass;
>>   #ifdef CONFIG_SCSI_MULTIPATH
>> +static LIST_HEAD(sd_mpath_disks_list);
>> +static DEFINE_MUTEX(sd_mpath_disks_lock);
>> +
>>   struct sd_mpath_disk {
>> +	struct device			dev;
>> +	int				disk_index;
>> +	int				disk_count;
>> +	struct list_head		entry;
>>   	struct scsi_mpath_head		*scsi_mpath_head;
>>   };
>>   
>>   static void sd_mpath_disk_release(struct device *dev)
>>   {
>> +	struct sd_mpath_disk *sd_mpath_disk =
>> +		container_of(dev, struct sd_mpath_disk, dev);
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		sd_mpath_disk->scsi_mpath_head;
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	mpath_put_disk(mpath_head);
> 
> [Severity: High]
> Does this create an unbreakable cyclic kobject reference? The child disk is
> created as a child of sd_mpath_disk->dev, meaning it holds a reference to
> the parent. If the child's reference is only dropped via mpath_put_disk()
> inside the parent's release function (sd_mpath_disk_release), the parent's
> release function will never execute because the child still holds a
> reference to it. Will this permanently leak both the sd_mpath_disk and the
> multipath gendisk on removal?

I think that the earlier del_gendisk() -> device_del(disk_to_dev(disk)) 
drops that reference

> 
> [ ... ]
> 
>> @@ -4035,13 +4138,259 @@ static const struct attribute_group sd_mpath_disk_attr_group = {
>>   	.attrs		= sd_mpath_disk_attrs,
>>   };
>>   
>> +static int sd_mpath_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	device_initialize(&sd_mpath_disk->dev);
>> +	sd_mpath_disk->dev.class = &sd_mpath_disk_class;
>> +
>> +	/* undone in sd_mpath_disk_release() */
>> +	scsi_mpath_get_head(scsi_mpath_head);
> 
> [Severity: Medium]
> Is it safe to ignore the return value here? In sd_mpath_probe(),

the count must be non-zero here

later I can add try get variant to make this clear

> scsi_mpath_get_head() is called but its return value is discarded. Since
> scsi_mpath_get_head() explicitly uses kref_get_unless_zero() and can return
> -ENXIO, could a failure lead to a refcount underflow and a use-after-free
> during the release path?
> 
> [ ... ]
> 
>> +static void sd_mpath_remove(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> 
> [Severity: High]
> Is this device teardown order inverted? In sd_mpath_remove() and the related
> sd_mpath_remove_head(), the parent device (sd_mpath_disk->dev) is deleted
> via device_del() before the child gendisk is removed via mpath_remove_disk().
> Does this cause double device_del() operations or sysfs hierarchy corruption,
> since the device model requires children to be unregistered before their
> parents?

maybe it's a problem, but I did not experience an issue. There is a 
later put on the &sd_mpath_disk->dev in the sd_mpath_put_disk() call, so 
the parent is not gone before disk

> 
> [ ... ]
> 
>> +static void sd_mpath_fail_probe(struct scsi_disk *sdkp)
>> +{
> [ ... ]
>> +	if (remove) {
>> +		device_del(&sd_mpath_disk->dev);
>> +		mpath_remove_disk(mpath_head);
>> +	}
>> +	sd_mpath_put_disk(sd_mpath_disk);
>> +}
> 
> [Severity: High]
> Does the same inverted teardown order apply here in sd_mpath_fail_probe()?
> Deleting the parent device before the child gendisk violates the device
> model requirements and can trigger sysfs warnings.

Same answer as above

> 
> [ ... ]
> 
>> @@ -4158,11 +4515,18 @@ static int sd_probe(struct scsi_device *sdp)
>>   	sd_revalidate_disk(gd);
>>   	if (sdp->sector_size > PAGE_SIZE) {
>>   		if (sd_large_pool_create()) {
>> +			sd_mpath_fail_probe(sdkp);
>>   			error = -ENOMEM;
>>   			goto out_free_index;
>>   		}
>>   	}
> 
> [Severity: High]
> This is a pre-existing issue,


Yes, mkp-scsi tree needs fixing


> but does jumping to out_free_index here leak
> the active kobject? In sd_probe(), device_add(&sdkp->disk_dev) has already
> succeeded earlier in the function. When sd_large_pool_create() fails, it
> jumps to out_free_index and eventually calls kfree(sdkp). Should this error
> path use device_del() and put_device() instead to prevent sysfs corruption
> and a use-after-free on the active kobject?
> 
> [ ... ]
> 
>> @@ -4177,6 +4541,7 @@ static int sd_probe(struct scsi_device *sdp)
> [ ... ]
>>   	error = device_add_disk(dev, gd, NULL);
>>   	if (error) {
>> +		sd_mpath_fail_probe(sdkp);
>>   		device_unregister(&sdkp->disk_dev);
>>   		put_disk(gd);
>>   		if (sdp->sector_size > PAGE_SIZE)
>> @@ -4184,6 +4549,19 @@ static int sd_probe(struct scsi_device *sdp)
>>   		goto out;
>>   	}
>>   
>> +	if (sdp->scsi_mpath_dev) {
>> +		error = sd_mpath_add_disk(sdkp);
>> +		if (error) {
>> +			sd_mpath_fail_probe(sdkp);
>> +			device_del(&sdkp->disk_dev);
>> +			del_gendisk(sdkp->disk);
>> +
>> +			put_disk(sdkp->disk);
>> +			if (sdp->sector_size > PAGE_SIZE)
>> +				sd_large_pool_destroy();
>> +			goto out;
>> +		}
>> +	}
> 
> [Severity: High]
> Does this error path leak the sdkp structure? In sd_probe(), if
> sd_mpath_add_disk() fails, the code manually calls device_del() and
> del_gendisk() but entirely omits put_device(&sdkp->disk_dev). 

let's fix mkp-scsi tree first

> Because the
> initial reference count set by device_initialize() is never decremented to
> zero, will this permanently leak the scsi_disk structure and its associated
> resources?
> 

