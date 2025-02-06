Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598BA214209;
	Thu,  6 Feb 2025 11:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738842485; cv=fail; b=mTFyMIbizxr8KLU23SI0CN1oqzCgUU/ZH2bMH4fXdMTdqQZx+a+m9/MxD1oQcOHzWuOdUD3Ge7ExVmjKrf4oLDLnIaKPPHQEZq/1MqlgPebAtVyZDudBLFVSy2jpyPbfKBvpYfYlCspQ3hm31wOwR7C6BMFwtihx2WPhD5drLQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738842485; c=relaxed/simple;
	bh=FC8OYXfT/lxlObc8eZUllejoFqRzlyclVTKMuybziXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ov/VL/I2YBwgeKBGAFvEVSrTupfi2OR6UAA4WosySj8tgpMYWK9/jJaq34X3m6exSuTYdfMtlr2SsHMTf9V3jw0lk0CkO6HXB9arZKAS0gLo/Bq08BrjRHRY9tIj7OtYmlKzuIcQXws7f0LeKQJML5hBM9Y9qe3oZ+lrGXsj2Ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l9e+gzhB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XLcFouWG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l9e+gzhB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XLcFouWG"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5166B4uo032554;
	Thu, 6 Feb 2025 11:47:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8YVTy5rNJ6+tKOfdx3fQMfzzt8soFzSJ13CY35aZUpg=; b=
	l9e+gzhBoy3HcMnfsNmrV2yuRro5MZTYpSeO6fL+Z6YdvT7Vux0rRd6S8bXSXeS7
	yDtig5RB4qPCA33A14ZYhBhlZAdV0T1PoLQ+g08jYV1TOOugTT0wet0VwHuheVXP
	aYdChtnrcQ/3YMHe1x4EkrS+UQ9KmoF6RSi8NfJ15WNuLhCFX2OGsiPRInK8nl41
	A+jh6yWqdgygVu9iWyXjhhdf+smGZQZW+8MG9vkboIZHDjFIf+AfD7gNS4drsjd9
	2ykap7FXuHjag/IMGukHqSbXq00R4DTce/eC1jTrd4A17OEBFFWwhyUN0nrASOw0
	YNxJQ03V84a6guMFmYjG5w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mqk88es4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 11:47:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 516ARlVq020686;
	Thu, 6 Feb 2025 11:47:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8frqurt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Feb 2025 11:47:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4ZYlUalYo4MfbEd8KpN3pgd9IWx3VGP/YBICW8StHWbGz9vmh1wInAmqexnCShl/haEaUFWHS7G1dBgaP1eayS2yI6wJgBd8OVE80yXxg1gp0ToPyLaeAcpKbIyRlo+CqWDs4VYTVPme1EFABpMwdigqQmX7fL8pv489hTWOqXctd8J/6j3hDukSfK+xoWc6710tGOjwWC2gXdL3hOq4Cek77dJd/kaHt7D99sGQV3NS7YT8KwpDE1i/P5ECy7bBcOeWOAzXZwzoQRTDoCgY9CYlATcQ6VIX4RAkzVLh2nhgtY+spuq50gqt6mWSCqZMEHRxwG/XbZ9oWjn6SPwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YVTy5rNJ6+tKOfdx3fQMfzzt8soFzSJ13CY35aZUpg=;
 b=fMmPLdFEp1AkABkrRhXLXETG9PXTIVaPktjrhXEaYsOJ78Itz5gUtTwoMQWwfjMyPf46Yq9hX7EFgaUz7VB6PyXrXA7UXB7KubqISIGsh8QNs3z+ZGPrO4uuv371vB943pNyEzptNAXkgHYU17718sdNzREukYufi8FIKw0FPTo0L+9oFvlktCgKTY5Y/kUeffJ3c+llGhvef+DaOVd8WiLVl6Ixj9GECP1kKGfm8ogIrykL8M9S+RgXqUFjeSSsmTSCkmn7+NV7eoLQcRay9DdakgmUs35jVEt3Sm+B/xWkP1tKQ20xUB/TjzFahQb65UGit2zEovmRPtvU4IxJVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YVTy5rNJ6+tKOfdx3fQMfzzt8soFzSJ13CY35aZUpg=;
 b=XLcFouWGdFdP2/hKZ2NIK6r5LW6YhOPgJ937Qa92xtHzzRXl0BlD8RUDTJvgw9rLDDgbWJd343KwOxnkXHGzFsVd+sr9Wwq8pRe9NANkJSuydr2N+BfAAlHjvw9/Jg3Djg5Eco7O71z5aav7jQy8xm0gClDwRccdjoGnFsHFEWI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6447.namprd10.prod.outlook.com (2603:10b6:806:2b0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Thu, 6 Feb
 2025 11:47:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8422.009; Thu, 6 Feb 2025
 11:47:54 +0000
Message-ID: <8f6c298d-6870-430b-8db0-6775750ae80f@oracle.com>
Date: Thu, 6 Feb 2025 11:47:51 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 blktests 2/2] nvme/059: add atomic write tests
To: Alan Adamson <alan.adamson@oracle.com>, linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        shinichiro.kawasaki@wdc.com
References: <20250205231100.391005-1-alan.adamson@oracle.com>
 <20250205231100.391005-3-alan.adamson@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250205231100.391005-3-alan.adamson@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0414.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6447:EE_
X-MS-Office365-Filtering-Correlation-Id: a124da49-f6a9-4fc9-69af-08dd46a4175d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0hyd1U0eUJGa3FLSGxLOHRpUy91NEdyaUZHUkkwcSt2NmNuS2toOFN0K2ds?=
 =?utf-8?B?OFQ0OEZrQ0RkYUFVenRHejMrVWxPZFV4T1VqQUdxT3BBaFJaWnprdmFRdDdx?=
 =?utf-8?B?R3Q4YnNKSmlaMUhnUjM0alhSTTdUeEF6OGNFUzZJVHhTeGN1WWxWWGh6bEM4?=
 =?utf-8?B?dlpkVmdrVmFZUWZsMlFXOC9UOWF1QUFBa24yclZBMzZJaDdUdm5IRHpSNm9P?=
 =?utf-8?B?UncvUUZYMlZTY3NOTEJsZHJtQk1lM2VjNzY3WDRONUxZdHllT1pLMVdaT0o1?=
 =?utf-8?B?aWFZOGZVV1dyb2NPZzF4OWR3Q0kycmpZektYNDNPQnJtYlB1cmFYODhEVGlR?=
 =?utf-8?B?TDdRQ2svc1ppc3pHUE1VbFNXaTdjdVFHM3BicjQ2aDlWa0J6K2c1aWxieEVM?=
 =?utf-8?B?QnRBc05qVWVXRXJWVU1DZ3pNVHIvd0hzQkx3cUZ0TE9WbkIvZEZnTXNNTm4x?=
 =?utf-8?B?eGJURE1KYkN5UUQ3alFBeEN2cTd4T0RvOU5saEtrOGxwUTE2STR3d1p5aWRw?=
 =?utf-8?B?b0NWbjB1QXJuS0JXQmtMRDJNOUhmZ0FEb3QrdU1IVFNQc2hGdmo1SjFodTdn?=
 =?utf-8?B?ejN5Qk1IN1N6M1NSUmM1VEdoeFhPMFk0MEs0bXd3b3dxczF0Q0dvbW1XQVln?=
 =?utf-8?B?b3BXMWV5b2lUREJQM3BaTWw5Yk0zTGNuRmxkMmVIbjM0UDNrTS92ZlB1WUlX?=
 =?utf-8?B?anJCMXE4OEkyUm9zS2dwRWp3Mk5DaFNxM2VVTXhucFhLYitydFpUbHR5cXRO?=
 =?utf-8?B?NGhkMldOcktpRkVaTE5qMUpkZi9heXdQU1V2UEVwYVJOR0FYaWg3Ry9hdFVr?=
 =?utf-8?B?ejJhcytzYzh1RjNQNUhrNFZvSkltOXRFMlBEQVB4ZGVSdkZ5ZXBPSWZiQkt2?=
 =?utf-8?B?cTdkRUIrZFlaTXBrMXI3OUU5Y2xJYnJvRmVMNFkzVW1nZ1N2OGR1cEFvbnVY?=
 =?utf-8?B?STJ3ZWc4VlNoMlpoQi9DNlJsdWlWOXhkbG8rQ3RJSms2ZDQ4ZkthOTEyOG4r?=
 =?utf-8?B?QzJWeWJiYWgydUl2dVhzUTU2cTZ4aEdldVlnK3ZqZGtxeVo0UTFORFh6ejlD?=
 =?utf-8?B?NHUraDFiMFdNZGxpekx3eGNCVERDdEZRT2VCVDltWGt0eFk0NE96dUR2bjcy?=
 =?utf-8?B?UEhKTHFXWHBLQkRFUkJLc1lCaXlpTXNMRjI4ckhldDc3NkpxU2tHNTNWd2Iy?=
 =?utf-8?B?L2lWdzYzd0FtMTYrckdNSnBzb1hFaXZOK3VwS3I5bjZkUHdtOG83OWl2cFNS?=
 =?utf-8?B?dUhmcklyZkV0eGVRaGJISVpFOCtvRDZGMmhHS0RUSGlmaWVrS2Yzck5Fa3du?=
 =?utf-8?B?NFpaaEZDenZjY2Q1ODNNYzNvUi9EY0pQaFVvS0RETHp6Njh1TXQ1V0hyb2pZ?=
 =?utf-8?B?WWs3U0l6UkQ1emJXbTMxSklEcTUyS254UGxHSWhVUUptLzBHeFhZUzZyWm1k?=
 =?utf-8?B?eUhPcitBaUtVeGZRTlZTY2o2cGI5WW1hb0xJTHpKRkZhWXlSUkx2OWFUbjVR?=
 =?utf-8?B?TE5JeFVhd3RVMzJablNDZGg0VEgvV0o5QXJYMFpmV090dUhXMmhlZVQxeFIv?=
 =?utf-8?B?Uy9SdHdid0dIa3Vlc1pWbkh3NDFKaFRiNThxdkZNWjJTdWx1NEpOZXlwMFVs?=
 =?utf-8?B?NWxNQVUwNXNRekpYQnFrM1pPM1JxTkYrRnAyOVZXemNZcFNjMEJHa1FvRlJ0?=
 =?utf-8?B?MG45UTdJYUlRTElyYlNCMS9qTjVzQ3k4WjAxRklpU0dyTjR1NzV2b3VId3NT?=
 =?utf-8?B?ZXFQcE9JVytWMlJvSExpbmdtRmFCZjRNRjBjOVFiSnVrQnU5UzdmR0lVbU0w?=
 =?utf-8?B?Z0JsSk5vVzFBME9vSnpDOHFDVno4bjFETkswbWdaK3Z3cmlaZlRDc01YWXZB?=
 =?utf-8?Q?ScKO45wc9B4+w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWRFNmkvd0owcG50SWdweG8xeHgyQzJiWFRxcVZJdUhweFZaMXhzOVlRL2Q5?=
 =?utf-8?B?MlVHa3dCTDJkbzN1WG1hMEFVeTVBTmxySVpkZVZJYXlFOXBVb24yTW8yMzNp?=
 =?utf-8?B?QjZMSWFoWVd2L3AzaHBPMEJkYjhYdzUvdkcxODVtZGVCODBCa3lyMG5NVlhW?=
 =?utf-8?B?SVgrZldLS2FSWXcvQ0d5SWlnNmMwcXlQOCt4SGNmYlN5RmN6dlBlZ1dhUTFq?=
 =?utf-8?B?OGFuLzlieEdZckROVHZvdzNOZDF0UVNha3ljc0lFUE4rcWltQVY1bElNdWFJ?=
 =?utf-8?B?ZkgvODllNnNnUU5nM2xNVHZMWDdPbFg1OE9Wc01OZjZhalBMMWxzdDh4MWFz?=
 =?utf-8?B?byt5TGo5c2h2aE52MlBOcUY1emFpSlNBZmtaSlZVbkIranVubzVNbHRaMDZR?=
 =?utf-8?B?SjcrSm4ycnhKTjJaSE5EZXpMKy8venZqTzJCY1hvQ1BiU1E5R2g4SEdBeTNX?=
 =?utf-8?B?Qnk1djFJZlB5MWZHQXY3R3lVQXhwSUlvb1VtNUJ4TmI0YTY0c0NiVzB5R0NI?=
 =?utf-8?B?RDk5cDRDcHdXdkRodXYvdUZPL3U0MVBGRWhWcnR4M0VKV0wxMzY2WGlIN2ow?=
 =?utf-8?B?VEtxT2EvVXZnQlFxRWMwSWtHdXFLdnZwSlZ5M2czeW00UFpwc09jVUdvRng5?=
 =?utf-8?B?bE0yTHo4cTFvclFPSitETGxTS25BUDN3VjZKQjhzWU9kcGk4aTJLWHhSOHVD?=
 =?utf-8?B?N1ByT3BCWndVY2d6UjN4VmlvVVJaQUxVbTRFRVdWQXV5dE44dk0rTmRNdTd6?=
 =?utf-8?B?SUxyMGRkSk94emowSTYwbEpvcUIyYjN0emxLZDZFdFlrMHQzdVFWa3B5anFI?=
 =?utf-8?B?bmFhS3VHcnhkRERpdzNLM0pqVzl2VmNZZXZhdmFBZC8wNHpoUnBDYjFsRits?=
 =?utf-8?B?N3NvbG1zdUx2aHNORE9pb2txNTJFUjZMSVl3S25nR1MrclhyNG10NWhRY0Za?=
 =?utf-8?B?aUZ6Z3ZFc0UyT2hOb2xZYml2YVhGZUZkeXd5d0xtSFI3Uk1zbG42ZFpJQmUy?=
 =?utf-8?B?b3daNWN1V2dKcG83MjAxcGhoZkl1Z2xoYmhNdXk2ampZa1JtUXR2R1ozenZz?=
 =?utf-8?B?R2krN3A3QlN1cG1UZG5nekFDQ0hOLzNKL0pqYkgxUE9lZVpMNi9BYkVZU1dX?=
 =?utf-8?B?YjArTWRjL1QvMWF6NTZkeWJaNk1YclFBVHIrWWZPMm95SmhaOTlhNEFjN1R2?=
 =?utf-8?B?THZQQlZKZVVpLy9JNnY1aDN0SHpzMkdtM1lpY3EvUDQ4NW0xSTdFYlgwV3hO?=
 =?utf-8?B?L0Y5ZVJnNHRENndKM2Z6QkcwalFYeUFlb29NSFliQWVtZ3BMWWNYZ1Q3ZzhW?=
 =?utf-8?B?SWZBbGRGMDNjSXpaV0w1RkVFdGRMLys1MElISndMNWxJa1QyZFhzUTI1SDNF?=
 =?utf-8?B?S1QxTXF1RE04NnFvM04zVVpXUDNha3VQelEwQldSbHRlOEE3Rmd4czEvSERQ?=
 =?utf-8?B?SHU3VVJZa1N0VzB6Yk10QmVZdUxnSnBVS2N2aEFWVFc0VWo5cjIxVUxsblFL?=
 =?utf-8?B?SHFhQlBRUnZZU0dHWWFZUFkxcFlmMTZvaVMwRHBDVGFtR2tOdzFwZ1RZSUtj?=
 =?utf-8?B?WUhZQ3hRWlAwK01pNisrMEpGWUM5bjQ3S1UzWkF4bjZZcWZ6V1NwSEZpVmVj?=
 =?utf-8?B?a3QxVU1kQk5JMGxod3Nmc2xxcWhBUDBPRUtWM296ZGw1ZFRMMEFEYmc2d1Y0?=
 =?utf-8?B?NE9IQVpxRzNRME03MTBvNUk0L1VTR0ZteE54QWQ4S2N5cTl0RkprSEFWK0d2?=
 =?utf-8?B?aTNBUFA4MCtlV2lLNXE1L2NLZ2k0MWRSa2x6R2ZjcW5VSzJxTlZFSWRDYUZ3?=
 =?utf-8?B?SURLVHNEaytSUHVnQXY3UmFxcHE1cVhtLzFsK1B0emdGK1V1YlJjTEtmM2RQ?=
 =?utf-8?B?TXRGVGg0eFhjTFFoUzFvWUdHV2FjZ29PcUR3QlhpZUU4MjVMMWdLRTJJNGRR?=
 =?utf-8?B?cnF2bnZGbUJveWdMZTVCRVdBSmxzT0U1T0FIaWwvVWx1OWVPOFdnRFY2Lzlq?=
 =?utf-8?B?ZG1PNEhmbkZRRzZmdXQxQTRENEgxSWR5RUp2ajRnOGZKU3o5WXJXcVFCOW5v?=
 =?utf-8?B?RDJiWnNHTGs0UG8yQjVCczFEdlQzSjhJUWthaUpsMWFFRHBEcUtXTmRNYlo5?=
 =?utf-8?B?Z0d3cDc5b0xsUmgvY0MwM01lNkpoVXdQSEZ1SS9KOWQ1TWJxOTUwSnphc1FW?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+dUMLaDOW8wuB1OpmV4CRr3UXSfAdza88fMb74BAd4GDVUqob+a/y8zZby+tsn0hPL6Gu9fk/ppTRphWLfZkMpbeMJgIByrxVUOmubp3AMm/8pSBULoH+UUEYrKVbEfUKdCNXrixgoMlYMXlrDSsqouixPBC5PA1bH1YiIlRf+URaPLKi0lEijJt3ytDk8Rv1la3eacXGAV/MAl1Aquj0MMJbGH2La8hVBjP77qimQklyFgqoK+0qIUK5vaGrWb1b7PcHB0CoDuR4vNAsIMbp9J+iekimXiRGWw+xq+BY9z2weALWpjn4wViKmawE76ghZZOwcmbRXMyFpYusUKJivEpfpXOrwFYyubfRlH2gridIJMpdj/opJXDwLzK5QoePWGIsEkKzvuxl0dmtUqHIStBzT5iSq/sQbYrWJzbMZnt2DyUnjHhlYMmQHZudLetLG3s5mvcjGtT7IHwhXfTUIHYlg981rhliHFcU6ZR9DisjaJeJh4yvraZdFwUTCKtieIUrCCUgpKI7Sf1fRUaKgJ1oducAILgyyWuCr9cLKLhYyl9l+u7Nv9iU6zvPxAbKbi2RnPbluVpZPI3fZ5+YGmesIBPkOuurqSdAHv+HF4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a124da49-f6a9-4fc9-69af-08dd46a4175d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 11:47:53.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YHEkrvka94V7APILah33py//qgPZIJ1TFOA1By7j94Ar8rvUDSH570T/9REOXV3L44Zy1wkm3tFfgCNOGI4RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_03,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502060097
X-Proofpoint-GUID: OHzdux9WZZhFPgMoojG5XmZspUbe4_sL
X-Proofpoint-ORIG-GUID: OHzdux9WZZhFPgMoojG5XmZspUbe4_sL

On 05/02/2025 23:11, Alan Adamson wrote:
> Tests basic atomic write functionality using NVMe devices
> that support the AWUN and AWUPF Controller Atomic Parameters
> and NAWUN and NAWUPF Namespace Atomic Parameters.
> 
> Testing areas include:
> 
> - Verify sysfs atomic write attributes are consistent with
>    atomic write capablities advertised by the NVMe HW.
> 
> - Verify the atomic write paramters of statx are correct using
>    xfs_io.
> 
> - Perform a pwritev2() (with and without RWF_ATOMIC flag) using
>    xfs_io:
>      - maximum byte size (atomic_write_unit_max_bytes)
>      - a write larger than atomic_write_unit_max_bytes
> 
> Signed-off-by: Alan Adamson <alan.adamson@oracle.com>

Generally this looks ok, but some comments below.

> ---
>   tests/nvme/059     | 147 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/nvme/059.out |  10 +++
>   2 files changed, 157 insertions(+)
>   create mode 100755 tests/nvme/059
>   create mode 100644 tests/nvme/059.out
> 
> diff --git a/tests/nvme/059 b/tests/nvme/059
> new file mode 100755
> index 000000000000..24b2bec645a8
> --- /dev/null
> +++ b/tests/nvme/059
> @@ -0,0 +1,147 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-3.0+
> +# Copyright (C) 2025 Oracle and/or its affiliates
> +#
> +# Test NVMe Atomic Writes
> +
> +. tests/nvme/rc
> +. common/xfs
> +
> +DESCRIPTION="test atomic writes"
> +QUICK=1
> +
> +requires() {
> +	_nvme_requires
> +	_have_program nvme
> +	_have_xfs_io_atomic_write
> +}
> +
> +device_requires() {
> +	_require_device_support_atomic_writes
> +}
> +
> +test_device() {
> +	local ns_dev
> +	local ctrl_dev
> +	local queue_path
> +	local nvme_awupf
> +	local nvme_nsfeat
> +	local nvme_nsabp
> +	local atomic_max_bytes
> +	local statx_atomic_max
> +	local sysfs_atomic_max_bytes
> +	local sysfs_atomic_unit_max_bytes
> +	local sysfs_logical_block_size
> +	local bytes_written
> +	local bytes_to_write
> +	local test_desc
> +
> +	echo "Running ${TEST_NAME}"
> +	ns_dev=${TEST_DEV##*/}
> +	ctrl_dev=${ns_dev%n*}
> +	queue_path="${TEST_DEV_SYSFS}/queue/"
> +
> +	test_desc="TEST 1 - Verify sysfs attributes"
> +
> +	sysfs_logical_block_size=$(cat "$queue_path"/logical_block_size)
> +	sysfs_max_hw_sectors_kb=$(cat "$queue_path"/max_hw_sectors_kb)
> +	max_hw_bytes=$(( "$sysfs_max_hw_sectors_kb" * 1024 ))
> +	sysfs_atomic_max_bytes=$(cat "$queue_path"/atomic_write_max_bytes)
> +	sysfs_atomic_unit_max_bytes=$(cat "$queue_path"/atomic_write_unit_max_bytes)
> +	sysfs_atomic_unit_min_bytes=$(cat "$queue_path"/atomic_write_unit_min_bytes)
> +
> +	if [ "$max_hw_bytes" -ge "$sysfs_atomic_max_bytes" ] &&
> +		[ "$sysfs_atomic_max_bytes" -ge "$sysfs_atomic_unit_max_bytes" ] &&
> +		[ "$sysfs_atomic_unit_max_bytes" -ge "$sysfs_atomic_unit_min_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $max_hw_bytes - $sysfs_max_hw_sectors_kb -" \
> +			"$sysfs_atomic_max_bytes - $sysfs_atomic_unit_max_bytes -" \
> +			"$sysfs_atomic_unit_min_bytes"
> +	fi
> +
> +	test_desc="TEST 2 - Verify sysfs atomic_write_unit_max_bytes is consistent "
> +	test_desc+="with NVMe AWUPF/NAWUPF"
> +	nvme_nsfeat=$(nvme id-ns /dev/"${ns_dev}" | grep nsfeat | awk '{ print $3}')
> +	nvme_nsabp=$((("$nvme_nsfeat" & 0x2) != 0))
> +	if [ "$nvme_nsabp" = 1 ] # Check if NSABP is set
> +	then
> +		nvme_awupf=$(nvme id-ns /dev/"$ns_dev" | grep nawupf | awk '{ print $3}')
> +		atomic_max_bytes=$(( ("$nvme_awupf" + 1) * "$sysfs_logical_block_size" ))
> +	else
> +		nvme_awupf=$(nvme id-ctrl /dev/"${ctrl_dev}" | grep awupf | awk '{ print $3}')
> +		atomic_max_bytes=$(( ("$nvme_awupf" + 1) * "$sysfs_logical_block_size" ))
> +	fi
> +	if [ "$atomic_max_bytes" -le "$max_hw_bytes" ]
> +	then
> +		if [ "$atomic_max_bytes" = "$sysfs_atomic_max_bytes" ]
> +		then
> +			echo "$test_desc - pass"
> +		else
> +			echo "$test_desc - fail $nvme_nsabp - $atomic_max_bytes - $sysfs_atomic_max_bytes -" \
> +				"$max_hw_bytes"
> +		fi
> +	else
> +		if [ "$sysfs_atomic_max_bytes" = "$max_hw_bytes" ]
> +		then
> +			echo "$test_desc - pass"
> +		else
> +			echo "$test_desc - fail $nvme_nsabp - $atomic_max_bytes - $sysfs_atomic_max_bytes -" \
> +				"$max_hw_bytes"
> +		fi
> +	fi
> +
> +	test_desc="TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes"

I suppose that you can also check atomic_unit_min_bytes

And min can be checked in other tests (when applicable).

> +	statx_atomic_max=$(run_xfs_io_xstat /dev/"$ns_dev" "stat.atomic_write_unit_max")
> +	if [ "$sysfs_atomic_unit_max_bytes" = "$statx_atomic_max" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $statx_atomic_max - $sysfs_atomic_unit_max_bytes"
> +	fi
> +
> +	test_desc="TEST 4 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes "\
> +	test_desc+="with no RWF_ATOMIC"
> +	# flag - pwritev2 should be succesful.
> +        bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns_dev" "$sysfs_atomic_unit_max_bytes")
> +        if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
> +        then
> +                echo "$test_desc - pass"
> +        else
> +                echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
> +        fi
> +
> +	test_desc="TEST 5 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with "
> +	test_desc+="RWF_ATOMIC flag - pwritev2 should  be succesful"
> +	bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$ns_dev" "$sysfs_atomic_unit_max_bytes")
> +	if [ "$bytes_written" = "$sysfs_atomic_unit_max_bytes" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $sysfs_atomic_unit_max_bytes"
> +	fi
> +
> +	test_desc="TEST 6 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 1 logical "
> +	test_desc+="block with no RWF_ATOMIC flag - pwritev2 should be succesful"

I don't really see much value in this test. If this doesn't pass, then 
something is really wrong.

> +	bytes_to_write=$(( "$sysfs_atomic_unit_max_bytes" + "$sysfs_logical_block_size" ))
> +	bytes_written=$(run_xfs_io_pwritev2 /dev/"$ns_dev" "$bytes_to_write")
> +	if [ "$bytes_written" = "$bytes_to_write" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $bytes_to_write"
> +	fi
> +
> +	test_desc="TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + logical "
> +	test_desc+="block with RWF_ATOMIC flag - pwritev2 should not be succesful"

nit: I really don't think that "succesful" is the proper spelling

> +	bytes_written=$(run_xfs_io_pwritev2_atomic /dev/"$ns_dev" "$bytes_to_write")
> +	if [ "$bytes_written" = "" ]
> +	then
> +		echo "$test_desc - pass"
> +	else
> +		echo "$test_desc - fail $bytes_written - $bytes_to_write"
> +	fi
> +
> +	echo "Test complete"
> +}
> diff --git a/tests/nvme/059.out b/tests/nvme/059.out
> new file mode 100644
> index 000000000000..e803de35776f
> --- /dev/null
> +++ b/tests/nvme/059.out
> @@ -0,0 +1,10 @@
> +Running nvme/059
> +TEST 1 - Verify sysfs attributes - pass
> +TEST 2 - Verify sysfs atomic_write_unit_max_bytes is consistent with NVMe AWUPF/NAWUPF - pass
> +TEST 3 - Verify statx is correctly reporting atomic_unit_max_bytes - pass
> +TEST 4 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with no RWF_ATOMIC - pass
> +TEST 5 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes with RWF_ATOMIC flag - pwritev2 should  be succesful - pass
> +TEST 6 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + 1 logical block with no RWF_ATOMIC flag - pwritev2 should be succesful - pass
> +pwrite: Invalid argument
> +TEST 7 - perform a pwritev2 with size of sysfs_atomic_unit_max_bytes + logical block with RWF_ATOMIC flag - pwritev2 should not be succesful - pass
> +Test complete

