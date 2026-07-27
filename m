Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3C838645E;
	Mon, 27 Jul 2026 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168322; cv=fail; b=Ps35Jw94et/u3Ylm2S88OWkU+sjTmCfq5A44XR8vnMBzwZqo/qp8+xjkZk8uuAPPzY3XiCS+h8l9kHSjpyXPRgzm2RnlbrVBC9daN1cH/OMGb4RgA/38GFQWG4bK3DI8zqef3/ULrb4K33q2DcOMn0Np29UC7WzvLYJTBUU4lT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168322; c=relaxed/simple;
	bh=XpaHijtjjqsOepknvxbs3L0O99TxVngLKw+6A8dj+Jw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JBjGWDxRmBkmi+YDC2Wc22tVgc1AVfVF4QcJfEGx+jsh5CoBOq5tzccGQU49xzoQxqJAHN4Snh23S7L8hwCHH+2WBu/mjRrwWU0EwvF1Ot5MeL4FR9VoWN4d2aDsfgqtYRmiXZVUM4nH+L99Fl6m5A5yb4fvMI9XG8XxSKTTuM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e9AFdo2L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o/jiH/Wa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e9AFdo2L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o/jiH/Wa"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RFtbwX2424890;
	Mon, 27 Jul 2026 16:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/6syXj+3DwVfY/wFP7gsmzE9Rh8wHe+xRGlwY0/CgQM=; b=
	e9AFdo2LbvzegCImOr+GW8lSMdxhQr+t9kPe8HjXW1XNKIdtQNBLO+XoyOz06nxa
	0mKgdx+X+wTiRvWYCvZZEX+D1u8dgY4KLEBrmcl+/xX+2acDAWyiKOCOUSZd45ZL
	wAiQFoYLlre3qbn8yL7zqsdKXLmNKA8ANDLzsWrM6Dz9n06eaZl0vPrfGU4bnN9N
	xEBewJ7i67O2HpWcxhDvGzZE+cmAPNyikxNvKsUe4CsxVSQ8shpMq4bIKmQpZb/U
	eMir0x7yTQatugtAd3DQeyOLyHxj70me+FJN81BD9A6e9JOzpcaWwrhmi0FNh1Rr
	0OGN/DCfMW+FTWa2mHIP+g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq23me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 16:05:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66RG57nP024101;
	Mon, 27 Jul 2026 16:05:18 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011061.outbound.protection.outlook.com [40.107.208.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85vgvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 16:05:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVFIPNRA0lR9DxalbXQGgHlWRICF6FOP34dh54iGvE7fza1VjPk0Uw4U/ZdZPKPcQC0Nv3yXrOfPlw+XHe/Nk6+hPzbL9BfN9KF6mKss0eOUH97dtS/5mdZxvgWqPlNPCx163+37VZe35dDn0DUXMFhPMn9Cdq8CZf7UsEan3MlM4CHlgGUsFqYFnDHtz4buawVY0MdpwnEWO8gweb+pMdn41Sk7EJUKSUx78xEaEf1twQ6JZQbxA5084KnGjZLU572SIqpr7trg8sro8POtaOMWXDpcHdsk64nrtP4mVeggB2SEgJt6l6rW7sKr11m87IKZ7ZbbVszeCex6606Gdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6syXj+3DwVfY/wFP7gsmzE9Rh8wHe+xRGlwY0/CgQM=;
 b=KlVWMChALvcO7dGltbk2mFumSDo7mVTaww2nAR4P6etSRPutBPIRAakQunX1eYY66/yqgfUmQCVctFP/fsag40nHC2mDlqcLBThDAs1YAZkpSVcKcVLhyuoDfD/vX6WC+2G54ExofKOa1vv+LPVDP22Z9dqkG6++96LGCkUndY/5JCma3aDfcZYQP/+/5nvIEm8Go6wgVLrh1ugoZqHHg4DOdJAq6wHkl54UrlAT6ZfJ36OQdWQW2Kk77nhlsKp7hwJlHLEdSdG+psSAoMvbilVVaBNWmo6RwkkhfX11tvxdymoGbSBz5X9yq96l1fAV9qVnKCDa4sVps7ARhO7FoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6syXj+3DwVfY/wFP7gsmzE9Rh8wHe+xRGlwY0/CgQM=;
 b=o/jiH/Wafj/m4A6MjIY2+4YjhfKLJEkCyGIMro0s2KFWwv03jYavOAa7ngnvB66F1QoU2pydKmtJP3Iqx251ehwtD+t1oKvO3nOKnHzASexU7mG1v1heMBQeiSGKxMldv90s76piq1UkxXgnb0nE9Hvm2+c8FItZjOfNt9/OYMg=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 LVUPR10MB997810.namprd10.prod.outlook.com (2603:10b6:408:39e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 16:05:05 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:05:05 +0000
Message-ID: <31dc5bb8-22f6-4dbc-beb8-a141a115d2a8@oracle.com>
Date: Mon, 27 Jul 2026 17:05:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/27] scsi-multipath: revalidate paths upon device
 unblock
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-18-john.g.garry@oracle.com>
 <20260727151719.3ED9C1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260727151719.3ED9C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|LVUPR10MB997810:EE_
X-MS-Office365-Filtering-Correlation-Id: 6529e851-8150-44e5-f1cf-08deebf8d28e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|6133799003|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	O6forEMW0XGxlco/LUluQbIH829InEQYTxWSvFarWCx9B+C9rPx+aLFAjFoVITCAH73lPnNo422JI3y62Dc85Lqk2Xq5ECp45nRU2ii7/YevoKJsOeFjqxkWhjyNuw6FYpa2+4r/yhf7VygXZZ/kWTDL3gQjVdlUafj4GiD//fxMdnNunwovX9ZRR/BLlrUw0xE5+Sk3g7oW8Pd9o95+oOHXN/B+WeyXl+h4nsoPaFMbSsMVlvlrX0CYoZiHJ+KV/Yf5kKvWPKQh6b0OxwhzeBQbvCGm0Ax4zj1UDHrjQA/hGTd2k3N8ScljWig0syQfl3E9tcQbTXKlSDAbg+bSCZ9olse2ehuXdcmA6k6G0Jlz8Y+7q3VYuSTcWf8Ck/lvvS7sAM9t6keiOTCu8hA//Fm4MJkg10gBhA6otoPEPnUTEG/eD9ikVLCIrti/01UQM9U9x79GwjdxqNeYNuJpqOouhe5gu+M62Ss3RdaJNK81Je18ygi5IDhHLrSkzk3ng8K2RNsIlpunHwO5etya7TVb/UY0yKv5z8d85XN+gDceIkti2DwMF4RoBmq+zoVI104iwH+FoXWF+nU2mXo68W9XuE12HPAXxqVrbOmvssLhnMHEaB682TfdndsJolM6tTDJrNttSxcTPU042GKg+pO8NyQgZagzH2QpDRCR6gU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(6133799003)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NleDlEd3RKbVFYdWFOazhGKzM3M2wwZndINEhia0pwb3BqMXJ2QWdyenFS?=
 =?utf-8?B?dmFVRU9iMHpLVTBJemdUampyektKdytWSHl3K2RIa3RHbUVNNUhCUUpUY2Nx?=
 =?utf-8?B?STViK3ljQUMrblh1ZjFjVFYwa3dnM3ZOR3BTUFp1M21naGxJaTRWUXZMc0N0?=
 =?utf-8?B?S09KeDF5b2ZPZDhVQkUxSUZjdFNZYkdLcUlGc0NXUGl0S3hkMlpMMmtyUXZ1?=
 =?utf-8?B?WVJ1ckUxTlJPYlhiQm1QRmpDNHZYbUlBSjFEQ0FIWHRqN0dMMys5eXVjekNs?=
 =?utf-8?B?R0tkM0s5REVJUGFvekszb3JPb1dFM2t6L1FSdWZjZW0raEhXVmI3Uk9weXMw?=
 =?utf-8?B?LzJqYmN3TTRMQ3N3Z0tkQWExSlRIaGowaGVoTEY5aTFYMldMZzQzeWo4TzNZ?=
 =?utf-8?B?OXdUL25MKzBKRjRFUlhzU1ZKQitZN1RkLzlaT2tiQnB5eGR6ZlVBNGw1Lyty?=
 =?utf-8?B?SEUwZnRjblBhZ2RxOUN1b3ZmazJhZ2J5dHZvL1hEaDUzb0JNcHhGbUVVVnR4?=
 =?utf-8?B?WmsvN3JQaWtEQXVLTEdrZHI3bEo5K2hYcjFDY1dRMFR0Mk5yakMzOFNGbTlq?=
 =?utf-8?B?eWZOUVd0cEw4SkZXK1VPZzd4eCtxZ3hEa2I5UUJUSUNwUURSYTdPb2lWTzdW?=
 =?utf-8?B?QnExK3ZhVDdNWVRiSml3eUVRQjNBd0lzZnRKbWFjY1VDbUtOS1VwQkV3Z05a?=
 =?utf-8?B?TU9MZ25jZjZHZU56SjBmMkwxVktmSDZCR25uY3lVZWErc0tFd2FXTnprNDJs?=
 =?utf-8?B?NlBGNXVuczU4emtMaTh0dnNZamlhejFZNDgwUlI3bXdYZzg0WmVxcjUzdWtz?=
 =?utf-8?B?dFk5cTVjVXEvbTRvcmFNK3BNemU3MU1FOU14ci9LN1VmRG9tVk14bjNETkp3?=
 =?utf-8?B?a2hEeUpYQXBIOURGTTB5K0pFbllzMDdhcW5xb2hUd0hWbWdXSHhJZGZEczBU?=
 =?utf-8?B?NndBTTBTaXdzL1Y5ZmxISVB3d09RS2tPWnBJL2UxbWx5NHAwVEUydW45NUVK?=
 =?utf-8?B?SzF0eUlWZVk0M1RKb0Q1S09COStoQ2psRHpLbWpPNUx5bmlZS1BKSTNOZ2pV?=
 =?utf-8?B?cDhORlplY1FDemdvK3ZmVm01WDNIWUpPajBtMGwxdnRnTW9JMmZvUlhRb1k3?=
 =?utf-8?B?YzdVdjdzVE5vd0lHQ1JxM3JQc21QeFVxdEYzdnZ2ZDdOTWUrTjkyQ3ZUbUZB?=
 =?utf-8?B?YUUwclNCS1dkUGQrTGkrQkdVd01NMzY4UTBjZWFJWW81MlpWS29USHpqTlhM?=
 =?utf-8?B?Z2hMbXI2cU1GQmNwZzcrVEpvdFkyNXRLVHFOUlhQdDVhQVNYMk9peGZRZUw0?=
 =?utf-8?B?bXp5MjNaUXZNOFVpbVNucGVGUUpZUzdLMWZpMjZ3eEpJdFhRdVAyMjVMMkMz?=
 =?utf-8?B?YTlDcjV1VzNCMW9EVGZmbHVLWG9lNC95clFNb2VGeVFhSzVrNlk1TlgvOENO?=
 =?utf-8?B?alFXYklKNkN1SHAvck1EQzFtbmxTMUJMeDg1UTNuMU9lV3pEc0Q5REdFSXVU?=
 =?utf-8?B?clRzUXpHbmRycmVveThQeXlEQTd4c1Joa2xwOTd2VmVXMjRMTitZQkZIVUUr?=
 =?utf-8?B?eVZnZGxjNXQvUC9XOWN3Z0l1ZHdwV08yMkpBVHpsSEtWdTZib0hRWlZubTVM?=
 =?utf-8?B?Zjk4eVdpdVg4dENOTUVyUGlKQTN5QjRmTTZMelcvM0ZnYjNydEFQY0d6SEd1?=
 =?utf-8?B?Q2VaOHZ3eHhwbEhoalpmUDFYZEEzUUh2ZDcwMWNFeit3QVp1eGNoL3Njanl0?=
 =?utf-8?B?bXFFcnRMbkZOMEFBZjQwVFExR2xVK2YxTC8xc1puWThlY0JLRE9SNHg0U3My?=
 =?utf-8?B?elJFODQrajk3RE8wOXp1ampnU0dkMlVBYlg4NlNFRjdrem84MGZZd2EzdkM1?=
 =?utf-8?B?allIempmSlRDNFpCeGZFcklwdEpBKzBESEtqY1BINHZZVUxuZXZ2Vlo2QXlw?=
 =?utf-8?B?MTV3VnJXVzhjYUJkaW9HTUJLQmsyUHdLbjhnNjRXblBjRzZwOGhZaHV2ZEc4?=
 =?utf-8?B?WE1kQ0FUenZERVl4YkNXRjE0UTB4RytrOEllVUQ3ekFGS2l5R0Rvb0VmamN5?=
 =?utf-8?B?Tjd3UE9tSk53RHVxYVY2TWppVWpubW1PN1hkZ0E3NSt4VktCOGM3MWdzTWlH?=
 =?utf-8?B?U08zZFlCbVFoY2xMYlhLWVRMTkU3amJMOEdRbTg3eUxiaU9TTjZoZ2tpbXkz?=
 =?utf-8?B?UEZ2bU52Wmszd0RyMkhxRkZtdlRKM0dPTWFxd2lrTzMwNjBidDFHM05BS3BL?=
 =?utf-8?B?UnFoTFRkUnlhK1hNS3ZoUlBLYm5KN1RUTGJhbjVlWC8xcWQwOEhxZXQwVkxq?=
 =?utf-8?B?QkZ4Y3Vmbk04dVlkeU00d1JPZTFjRjdveVJHSmxXTFpLeXFwdXFEK2k4NENr?=
 =?utf-8?Q?n63+Yszdxe5pz1BY=3D?=
X-Exchange-RoutingPolicyChecked:
	XCVFvqaReE91BNtuNnP1RqKsyf8cqTDdO4Qr0/3jtZU6EKpJ8BZ5lpprd6FhFyyG3PbJ9RFVlSW2gZ3BkbM6k9s8FOrDSIa81ukw09HjRnRLeVcrApJGE+gXiHQ0QoOot1Nexk/xk6MxQBQuWkTH+l8oKY2sc1jGokahjV9rGv7fVkpQtDK4GKT2lnbl2CVhcUqFycbWVR/IDwk2lXN073i0AR94ppSrsMAzoMuIfaaXVHS6GTLbQZ/FdN1dThOJMW4H1DWApeNecFf3vH9VT8z3CgjvibVI1B/J+mvrMSIvbDPIEV/JTdzNaS9mhVqnmPMjKkIRgAVMAFDE+ebnNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jkj7pVoemkpgJGagSk3/GFvay2qKntUHyohlYH9TbDeU0CfHZK9s+O6alIWTYyYu0Bu7ryGz07ID9OABgZEVqSdiFo5zM4rgfTEdOzhc13B0VaPK66od09ZWC2ZIwj96sroxwF0ObE4HMjHc4XIRBSbGlkYvOqIFd994is3jwNessJ/BHMOGqxhOFR8LSN6DUyqsjuV1Ny9SfpMXRLkWWQddqD0sogYxOdI/XTAoIDcArm21frrJyQi7F121G2p8FDkWnFqQoawXPVn2BZ81mJOuES95fL+Pc0EqaQifzpZ3i6S3E42q84EEfOWR+fvIcwUkIyLemVk2GWhyccdQZUbuzRKESqNkl+uF1tXSr0z1IU9aF9uQXcUU8V7C0nK5BW94tuEUKSYHL2a9yHbbKfBqMEvOUW+3OX3CP6hJEeU3kqUWUpC76emzBZgl7Jr4LgpGrUWozr68pJn6yKpoOY4bjTJzCD5Hp+2WRsiyVqr7eypNxbJ2e/YL1NQvCZELYH9Zpnc1G0F+z7gJSIrs/G82tOCYv1SoRw4XL1C30QQ3dxl2MLZTaHt0BCD/aPE5mWTe9MGPokqL7H2X8jas3DWuaj4nVYuFN8J1cJQDgdE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6529e851-8150-44e5-f1cf-08deebf8d28e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:05:05.1587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZjsueFmsVmppnT4s7EoLyjO2I42XSqUJduBPiNLrryVpJSlgiMgKayk9GkbnwlaQ6D09qGtPusFlvo3XYluKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE1MCBTYWx0ZWRfXzXPiLb2j+JlF
 n2FE4wFCLZ94OtZdoJuw7QYrEajygRDk+U2Z/vVSl1pRaW9xBpZ2V7UqMn0p4yDeCix9zX4ErLI
 942FDBHDAEJEx8ganB3yFBnyUhLvB47mfvoXJPUVlL2DxOClSdOyxpl6cqsLKPnAkYIaAYjZte+
 JWPPuaBuPTvjDkWJp9qsKB+z7iqDZuI2iDjz8W0/7KXHeGow1d9njrkex2hkeaKY3JRaZezhE1M
 oK7aOhdBIGz6HbCSjQ6THoU1S1xMgdjtLDymnPxAhw4Hj61RFBkJGArcOMhu5wc/MiOdVkFD8WY
 Zf9XbBFZEye9fNam/8/U00OBt4MsQHpLZjpKZHzEaRpzYhZB9qhmu7Enx9FHEIwDoGbYlDKSpN9
 feVy4DjsPT1T9UpaRsy02BcA6opUA3ua95zPnmHaczeZA84FmVlxGS1kOodijIzmZPDqhsjk2Ac
 u1rvuiXZri7TWlagHCQ==
X-Proofpoint-GUID: Pc9oNUIFH7JaYkEuv1RPKNxBy9W-JjyP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE1MCBTYWx0ZWRfX5a2Q0zRVZg/e
 1yQYD/9pmI2SqrsJL5ynRjdJmNz2SHy24lBFzL+xANpy5T1pPf7KQ+nz4ELejhROypZuKb5M6w0
 HaJbZpafLZoOIaYrWAbkVkCE0Smnvzc49UHiicuu2zI53DwRHMRl
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a6781c0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=AnIu8HxzQWnwhnYvw8kA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Pc9oNUIFH7JaYkEuv1RPKNxBy9W-JjyP

On 27/07/2026 16:17, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Race condition in `scsi_internal_device_unblock` and `scsi_device_block` leading to NULL pointer dereference.
> - [High] Concurrent execution of `scsi_mpath_dev_alloc` and transport block/unblock leads to Use-After-Free and NULL pointer dereference.
> --
> 
> --- Patch [17]: [PATCH v5 17/27] scsi-multipath: revalidate paths upon device unblock ---
> commit d7b8727956ce248cf872dc90fa72742ade627f54
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: revalidate paths upon device unblock
>      
> When a scsi_device is unblocked, this patch clears paths and requeues
> any queued bios to revalidate the paths.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> [ ... ]
>> @@ -3092,6 +3092,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
>>   	mutex_lock(&sdev->state_mutex);
>>   	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((ret == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
>>   
>>   	return ret;
>>   }
> 
> [Severity: High]
> Can this lockless check of sdev->scsi_mpath_dev lead to a use-after-free or
> NULL pointer dereference?

Last time you complained about having locking. Now you complain about no 
locking.

> 
> During device discovery, scsi_alloc_sdev() publishes the scsi_device to
> shost->__devices. After this, scsi_mpath_dev_alloc() assigns
> sdev->scsi_mpath_dev but can fail and jump to out_uninit where it frees
> the structure:
> 
> drivers/scsi/scsi_multipath.c:scsi_mpath_dev_alloc() {
>      ...
>      ret = scsi_multipath_sdev_init(sdev);
>      if (ret)
>          return ret;
> 
>      ret = scsi_mpath_unique_lun_id(sdev);
>      if (ret < 0)
>          goto out_uninit;
>      ...
> }
> 
> If an asynchronous transport event triggers scsi_internal_device_unblock()
> during this window, could it read a freed sdev->scsi_mpath_dev, or one where
> scsi_mpath_head is not yet initialized?

Give a proper example of when this can happen and not just mention 
"asynchronous transport event"
> 
> Could a concurrent device removal also trigger a similar race?
> 
> If __scsi_remove_device() executes after the mutex_unlock() but before
> sdev->scsi_mpath_dev is evaluated

Again, this should not happen as __scsi_remove_device() should not be 
called before sdev->scsi_mpath_dev is evaluated

>, it could set the device state to
> SDEV_CANCEL and call scsi_mpath_remove_device(). This sets
> scsi_mpath_dev->scsi_mpath_head to NULL.
> 
> (Note: An earlier patch in this series appears to introduce an identical
> lockless pattern in scsi_device_block() checking sdev->scsi_mpath_dev.)

Who is calling scsi_internal_device_unblock() and __scsi_remove_device() 
in parallel?

> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -231,6 +231,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +       mpath_revalidate_paths(mpath_head);
>> +}
> 
> [Severity: High]
> Does this code safely handle a NULL scsi_mpath_head?
> 
> If the race mentioned above occurs and a concurrent teardown clears
> scsi_mpath_head to NULL, would this assignment dereference the NULL pointer
> when attempting to resolve mpath_head?
> 

