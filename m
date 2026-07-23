Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C7146EF76;
	Thu, 23 Jul 2026 11:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805712; cv=fail; b=t9w2HfsNQgffuOWTEcxjNDKje6cPyR+nYE7Cr3vZD8h0brhwlai237AA8xgVltOU3X4Eh8pqbuvZlCiQT/RTgLfv83VdopE0T2dJ5a94f80hGB2DSn9HvG/aMozBmDO9G3xv/ciUn4xvjEai3GfcDxEoYBIlL7uT/rY/BfsPOeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805712; c=relaxed/simple;
	bh=A81YcCV4dkGb+bgB49kfykLLWoJzOZQFKLpB2kbJFSg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r/QhLKBF/6nvM9cBbzjeDbpgbX5grwe/UcGQ9XavGIsgrPKXlYIctzsIpa1YN672/0vks+XcTlwn9w+9w3a0C6o9u9HZ/Lfl5bfmSYimWVIqgZHNHNW1abLsKOsu2REjlRN4i92z4/QE5yyF1nkOjgswz0WKdwlZyIiIERh50ZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ChsqA384; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QCMJmb/t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ChsqA384";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QCMJmb/t"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtZ4W3360304;
	Thu, 23 Jul 2026 11:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+jbQQ1AVTp/6GxRTMsITjB3hy1tqnJkKXDxgaNYiyPQ=; b=
	ChsqA384KIp5hfPWg5YiWIsHySvPjR15qYWOCe+MnFAQXXodhepQVwwOdjB/JjUu
	IH5ieOYsfmCxLgE6rn28CakIXHt4niB1BNPtAUtVpCcVMcnQLCrhXwUrhiNfqpP9
	bEdpukefd8UzyhnCwGFAx8q/EgJ3jrYF3eUVvNo0ycAbeoiZBI1nKleQxKZn149S
	uOB3x5lUJj5CIrPtSqKQXTkgGTY3bO+54aYCXwOjJH2QzOV6n/EbUqariszQULNV
	WhqhndZj+NtnGFsj/UXmLkqoZE0n876jH+J1ENw0fO9NUyEyvXg3uI+OtRYFxhEt
	+LTJiWS6xZ08/M15Cm3aew==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6r46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:21:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBIO5V010109;
	Thu, 23 Jul 2026 11:21:48 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxd8756-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:21:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRZnzs62PeL8E4QbcUrUC0bET4h8W6gnIZd5LapVkV9RkK75l1iE8eqSVc+ePUEx4xDYXZMK3bnif4d5vkSqraVlRXwNzTk3lipaMtYtPadLS4d2w/y+szKfwhEkuze9bGCK9+Tb1YRLFm2RmJ4jSIJQb5otYXi2GX0ET9B8upIgnOHTgB3N+e4NodOHs/2ButxzGzLYcvWBG01xi8dbxYFO9Azwl6Dx/9daTXNx2LnhJUWVTDFsC7rlJSRBDpxwcGOBAY/SUgIeAxC1zlYZSehpAqtpfSITDANBMIOTbMox7QG68kHNMa5j6t7WNEczmT40kiJn6+FqPVzyntW/mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jbQQ1AVTp/6GxRTMsITjB3hy1tqnJkKXDxgaNYiyPQ=;
 b=NOFRRUdBXtfS3x/1qA9IqdE6NuqbAtalUZ6hWbp50t0B0cq86jUix7t43id93TdXFh/2biuF7RC8g+apMVm3UZv0W4DeppN5yd+J2RQLpRuTnCld3XmVuFcrWxMX141fN0iF6NbGYbAnMZ4UlC7zX0gSZ+mwdM/cDGVPPJnt1xTcfm0KhQfKQZXYkK2/GIKWmEhNen1Je2qMOsJrB6rz08SW/nRHeVpRDANkiNFXS/F5KnzI5r7VA3E/TPR6bbx5a6TliQM2f0yEYbvk8N1PZezmDSckVdHnyuICRHizwmgMXjA5j2BA6w+GciNtAozCJk0A2ZC+jQdOgjPdgx09Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jbQQ1AVTp/6GxRTMsITjB3hy1tqnJkKXDxgaNYiyPQ=;
 b=QCMJmb/tQyLZjDIDzxjvsj0MRYgPnYQWVA9TNod6za6Q/ZZye4WExT/jmq8ojNVYWb64ESJ4OZD3stxeOZsL9Fnb6+J8bJqfhzkOqBZxUQWIGVfRYxT//SUgJSuJSVtQyN9LNqsnvoMl35t5ytAlprTkuBkwOBCHBPJzKxVx7qo=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH2PR10MB4279.namprd10.prod.outlook.com (2603:10b6:610:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:21:44 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:21:44 +0000
Message-ID: <8e36779f-8378-41be-a6bc-9ea1cda2f911@oracle.com>
Date: Thu, 23 Jul 2026 12:21:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 23/28] scsi: sd: add multipath disk class
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-24-john.g.garry@oracle.com>
 <20260723103920.250931F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103920.250931F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0148.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::12) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH2PR10MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dfad9c2-a088-47c0-1fda-08dee8ac9340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|4143699003|3023799007|5023799004|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Pp4Uv78Z6X/hudintzwgNp54uhxlX0isRJbFuFgF95JxHFlvt3UZsnZe+OMJeRydvGbkXcVIoY6ED+OkuTUM5RI5B0N6aZbwgVR160MXRS/Q4gsnHQahsvlZ8J9JhiHcUH1QqxPTzxiKcX6OmWIDlO0NKC1d8GH831ssvRLZPU7TwStbRd6WRI1VqufysFz8HSzHtxWB8VvitxIL5l3DoG/yHDT7pYfBQIBkSN2Jprya99F2Ps9Ny2D7H7KAfuyLZUJMijyASs1KjV0tudWsIe4V70N1S2Bsxr7W96HluL2PSEUeZC+kifOkqS9WtIOFP+MyYdyG5zP61JrqmOg+fxWCgKt5jT38P/4X2Q5tmFw5trfCot4wlWLWxhNSQ9iS12MjI3czX89m6txQZ7lUaGpx8msqKTSo9oeBHdWgCfR6jMrZLT0LKImMfniKoN1zDreDTYTu+sZabxBr3gIaXGgO3jzNOVNP8gBCJ6kr0oXw2ynRUMT5kCI3BQa0JIaIzOExQgcW77ajFeN11T/qx4oj+3EwQAjRf33KHDg9kMNVJX6A6LKYxOFlEJ9vUO/wZJG1R8mzDq4ZsCdfN014oN0lvwHchjGXXDlbAZq3wx4EcUKNoy3BcdXNdtOoSYxy60UTcSRz3V53BPtehq/KCqGFKSgxPpyHlovMj50toM8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(4143699003)(3023799007)(5023799004)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0M5eDkvb2dIRWM1aXdnYWRXM25RN3IvSHVWRDhQUnlyZml4UEVOdlhaY0sw?=
 =?utf-8?B?a1hDTU1lQU1BNVQ3aGFEZHhkSW5RaGZ3UHhodDM2eWJlOXFtbW9yajRnK2d1?=
 =?utf-8?B?WXVHcXVzSGRPVXNGRHVXRFJRZFFVSzhVQW9aWVJwTjBZT2RPcDR0Rjc4cFJ2?=
 =?utf-8?B?VTdiM0ZPOG5Kem0rajdSRlBOejhmdnZCcnh2Z293RkNMS0N2MFRlaWdkRVpp?=
 =?utf-8?B?NHVCVzVjeFJPemlqSW93SUVMOEo1OFZNdGZ3NkJHeGdsaVpsaFdjN1lTNFk5?=
 =?utf-8?B?UnZocDFneEU3d3F3VVhFKzFxZE45TkhFNTVRa1dOem9obmR0REdnWmhtRmJv?=
 =?utf-8?B?S2krYVFjOWNXSUdlZlpjenhRY0pEN1M1S1k0bTh1MjZCU3lteWdSdExlcmNh?=
 =?utf-8?B?SUpIZkgzdE56WWFsQ1pqR0tyamlaWjU4WE0xZTRPKy9sUU92TGhDSks4dENX?=
 =?utf-8?B?STd4M3pLT2xuamZWOWFDTkhENFFWUFlaaURkUTZ0Q2FpdTViNDNQMVB5THNO?=
 =?utf-8?B?aXR6TGp6SThrOVZ4eWJSYjVpbkJJeXdncDFwUzZzaXFsOG4wL2tYcW5LM2Zw?=
 =?utf-8?B?aHdhWnJqVkR2OW5lYmc5SHVZV2cvS3hBYnlORDErSGFHVWRKTllJdUQ1RlQr?=
 =?utf-8?B?TDVOcnh3M0R6N2VaZVlyNFVDNVQvN0htbkI3Umk0V0VLWitzdG4wRE5nN0R3?=
 =?utf-8?B?cUtnemx1QmdNc0hqajFGYW5xamR3NzhNcUZvbXNUdHpXb1FrZVk1bysyYjh5?=
 =?utf-8?B?dFJaTXBXWm1MSldFb28wcm55QVBvSCtZZFY5R3J1ZHEyUVZna2s3RjVBeW4w?=
 =?utf-8?B?SXdTdnljc2R0MHYwejNmd0h0N0MyTm05RFNyOVhUSlgyQm1ZSllSNGZFSDdE?=
 =?utf-8?B?NnJLWjQ2RGpZd24vMXB1akNydk9BMS9Zc3YrM1krbGQvQ3VLcVhWMnEvd3Ru?=
 =?utf-8?B?dEZmMC9NOHpyNWFILzlZSlpZWlk1MU1NMyswRkkwWEkwZFFYakRUSmI3MXli?=
 =?utf-8?B?bklSQVdWUEV6K3dpalVpYzU1QW9GZXIrRVBWaG1MMFo2ZDVPMXl0OUYxZFFo?=
 =?utf-8?B?N1QvZWtiVmQxOEVSNVB4eGNXNUF5OTRuckQwMU5Ia0Z2K0p2WEZZZWp3ZEl2?=
 =?utf-8?B?Nm1Xb25TTkZrMXJwWFd3bzlUQjU0RHl2bmdnay8vc0pzQWhZaHpwSlJBMFVC?=
 =?utf-8?B?M29jNDZCZ2F0TTZ2Uy8rdEpMUyt6SWdaVkZJQ0c5R1I5REFjMHZDSmRPaVA1?=
 =?utf-8?B?Z1ZYajRFOUJBcGF2WC9KZWMwVGd0S0JDNjczdHR1cjNBeHlvaytTMkxQUW1r?=
 =?utf-8?B?RkpoSXFEbnpUV3N3YjFCUmtXdHdGWldnWlo0am0rZG1kaEE2K2ZiQk5sM3F3?=
 =?utf-8?B?TmVVOEZrVW5GM2hyZ3FnZ3JXZXRRZnFWYjhleGlYRTVQK3lYQ005NTFzbDVB?=
 =?utf-8?B?VVJmWHBmNzhsbk80VGVUaWFVRkJhMEh0Mm4zRWI0cWpwbFJSOXhVSStpRWlt?=
 =?utf-8?B?UjRIM1BDOXdyNnlBSzdkeEJROGdoZ2JENWYyeHNNbzA0QUF2WGpJZ2VxenZq?=
 =?utf-8?B?UmhQYzNkWmYwWlowdlptRzkxVVFHRWdFblFhWEx1UWdoQk5GNVBSaFR0ZC85?=
 =?utf-8?B?ZmlkT3RXdXNCbXAxeTk3MlpGMUc3UUZScmV1NjNuQkxiMFd5VGEyZGVCcS96?=
 =?utf-8?B?N0R4eENBUmtXbWVvK2RxYzdZWkZ2dEhLRTVEN0tCMDlrQmhwblNSUm1zNmtU?=
 =?utf-8?B?TkNrZUdhbTJod0NMUnlpdThNTmVveGE3WjhtODM4U09UNE1SRDRYOWlVaHBx?=
 =?utf-8?B?eUlKSjIrRGFROGk2aXVuYmIvKy9WZlBXQXdqcFp6NjFYOER4UFFtOGxvdUVo?=
 =?utf-8?B?QlBubU9RODZpU01VQzJXaVNxcHpUU0ZBMmZpZFk1SDFGSXdvektmRC85QUR4?=
 =?utf-8?B?WWhhd0VRQkFJTkZsN1ZFeU5nL3I5ckFkKzBObEtWcWI4YnJuZDRkU3lJcGk3?=
 =?utf-8?B?ZzhXbnk0eXRYcmIvM25aVGptVFN5R3R1VGRZb2ZMSmZra1pwMkx6bHd0NW52?=
 =?utf-8?B?OFFLbUtRVHF1NDBuZEtoUXFRLzcvaHlPNnVTZThtS3EwSHJaRlNVMG9peURX?=
 =?utf-8?B?R1BuODRVQjdSUEFpZlpKOWdOS2U4S3Izc2hpNk9NU2syeDhjL0NDRHNhUlI1?=
 =?utf-8?B?TzdxNkJGL0I5L2FEUHhVbUxKbHk1TEtGQzArcVBONkNpMVpXcDIwU1c4cXZ5?=
 =?utf-8?B?ZVh2VFYwVWREdWZQNjdhbFArK3NTMlRQR1RSdDFOWXVqb05aQXV5b0I2TktE?=
 =?utf-8?B?eXNRUVFLMWg2VW1CRnZyN1ZNbjBwVVo1b2lVMWhieE42aE40OEJhZVV5NFh4?=
 =?utf-8?Q?7KQTMfEIsLfDP9jY=3D?=
X-Exchange-RoutingPolicyChecked:
	hOwQFMeX/9LOvkm4FncYtOyBBCFOdkDvhT1vu3OCGvxndqMcfpVNz+g0snIgckZpWbIZwf5V4emW1EGydGKOPWPMhABofs0XtVpobnnziS9MpPJeFWCu0bANmKJjiZLjkwKPw/FFUWLflVWceMVKHO8behULi4jvLBQn9Agg9lcC5LvcP+9If3KngZwNoRaOS0+k5LKTD6quvjqSvlqnVDS1ETHYHl1jEU8k60wAePAVms6Ielpj1WDgEaLUd06JoeVjDPPA2kKgQ/r/FTaFJW1FmS+Yw+nY/I8BgqAW9o66G48cRWu+zJvME2VFKrrz8u5qbpMoeGzi4MukWLHzwA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kZmXWp+5iQK1271n33YNUZQe1rJpoIeixI7Cr8P5ULIwYKqNCb5Vfkq1JsDIRGNLyBq07zSWZTDHEzcCqhzW1a2nhBHs2nu4MLwE7ZFUKam89KcJ2GsA/Ts29YJADImnbTlqgtOkV76pY2RNGo9mI1n2rKC+PVAypEL6Ek0JqqV3ezeu8K9QwCD+xYVLiZ/UL1GWZ3lhiB0Fncn2BOWnNFeNfG0caM9F2jkXewIRqe1m1wgGTEQq+Fp2owexy0qPRR1xLap18FVJRJkEnfrJl4zVBLLxvwfCN2DN7kmkUjDpBr+R8b+i1vqrhm+n6i2Mb1qmpQ3RGiY1r5URz48JHUu43aHlQu21DRsX83h9p22CefulYcAWvr1c+PyKwEB5rWJI8QimSAYwoqJrXSe5hXhv6kbK3kZYUtORcbkMKnETjci1OTwekwEuVzijEkGtH0/9xoroYGWnam+LBjOgojanhqhGZ45HzaIKyYZCQGCKKduakZsGiJ/bGCy6pwSRKqj7w1s5Uuk1SDJ7XG1+8k44mPTQP5RxKOnzBKW4L+9rD48ysEkrjrXzX8OIJSlA50E9+OYSzEnmcntwYSLxq7S8qJbxsuhGCRzXUnLB4NA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfad9c2-a088-47c0-1fda-08dee8ac9340
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:21:44.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1hGoLy0I6TZeE1LsJ1qs1/jF3zJY9Lf9nWSlVs60JSAkh+JzrA0KZ7fo/0qCVcFe60bAE8SCKC+Ta2ocXY6/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMSBTYWx0ZWRfX85KnqU9GIXk+
 /k+Hd7gF6BHbO+OvuRjpLBkU9MX0PzYhQPAUX9gWha2CO6DaVK3QWajOpfEkwM7IEXaP23No2YG
 /WBOoi04NIDmRmwFLQNV+gfS9nGUjr6nLXwuqw9O+5DFioijewhvL5Qm1oIJi320V4RUtTaOvqG
 zPznCelG518YuSraRJtB90IQRVOUMvuUl9aHbb/OGlLOpujmx86nMBCthhuLhS7jWzG8dGVu5I+
 MevlUKR9Fhp2CltqlJHCigCmjAJzZ7NSwmkD1jywnKamdYWQxq5V178+KuzM6QkUTS0MywsJs9x
 0B6F0wbNVqd3VFXrYeIMHoqtOcZaMeJbJP3+IlzVVnv7gPC9s1RXHr8CcrNqv3TK7RDI5owpo1L
 6OdfqqWjvOeJAEbagi+nK5XQM5Rprx60hSOo22OIkMJbWVOwjbkMeojlsxXiUPgA2YjQ0/06tVy
 GvojMXY2ynHFiAwPqJQ==
X-Proofpoint-GUID: YEqDtJ7nRGgVzCCpg6B_OcBXPkubR4vK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMSBTYWx0ZWRfX7Rt1p3AlbQIL
 oOpLJNTDX2HaazYZh2A3OB4mFVlunXzmusd4q/HOOXiWBXeyFJ4VfXBISlcriuKNdijgW9L/u73
 /pijPh6+K0SJSb2uGZ3+mxi/AMyBARCEpDYRDkHvU2x/SU4VOFSz
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61f94d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=1SBMvRhb5qWut1LrzVgA:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: YEqDtJ7nRGgVzCCpg6B_OcBXPkubR4vK

On 23/07/2026 11:39, sashiko-bot@kernel.org wrote:
>> rs/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -83,6 +83,9 @@ struct zoned_disk_info {
>>   
>>   struct scsi_disk {
>>   	struct scsi_device *device;
>> +	#ifdef CONFIG_SCSI_MULTIPATH
>> +	struct sd_mpath_disk *sd_mpath_disk;
>> +	#endif
> [Severity: Low]
> This isn't a bug, but should these preprocessor directives start at column 0?
> 
> Indenting preprocessor directives inside the struct definition doesn't align
> with the standard kernel coding style guidelines.

will fix
