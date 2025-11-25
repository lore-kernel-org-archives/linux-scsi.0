Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F11C5D72;
	Tue, 25 Nov 2025 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093729; cv=fail; b=jrErjWIlIpY4M1KI/xL5dKUKi9T/tp9KClG3zAEUAY+yAraoZl6D9b2A+xxVlPwOQtgElfrOLMgXvCJSak1R0PyW5bVEzOOo4WI5Ppj03/7HMOh3ggRUrHTEqmDCAggvBjP4+eYcOx40d2Bd5sAteLvxn+2tf6weDQCeA0iyKvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093729; c=relaxed/simple;
	bh=2zkjHU8ZjLQlWEOH6Bu0LqiSax1GO2EwSZoyFiiiF9A=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KFBlFl0JNaYq2K+ANL8dEfj2jzhJempka620/rWL/2rZQe1wDbocKxtQ3k4otTENDp7pBgZavac6NMEPS5BmGjJJazbcMyPou7lLAG1wW/YBg6UFaKsHikD/m7d41PUeIWOftb9eECW6y9ZEaRr4ve08vkR5lnyGQX9WTSPrV9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S91IAvYs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PuRJiHGG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S91IAvYs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PuRJiHGG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APGCDfD4052203;
	Tue, 25 Nov 2025 18:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iunMxBtPeomZBF/9EqpPhAPyHiXJeSDKtqD0BUQqT90=; b=
	S91IAvYsIZAnGWwP8mDJZ73imRBEvqsYhXMYkQX0hLEnlDfNXTgy+/QZkZbEgpuR
	zaJsOexbHx/JUJ9X6Mm+gCnG/E0hNSyms20xs40Obz91D88XBl4SuGmZYQok1fam
	dROPv7dnp4HWBDGGyrT7/S8qzWGpUR4DhEyOWZ7O2QIo6p7Zzfd80otjxMsu2KDN
	yhVO8xWoi3WbnBWQcci9gzAGscZzjk3buZ5ySZ1Cn6VwCmrq2j99QrQIeylHxs8w
	CNSUOUhd31eflPBO9jV1Mx25X9nvEj4TYBy++1G7G5zjELrrAzBosWIrrDD0ty/8
	6kabNBVadGhT7yOFwWeAwQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7xd75gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 18:02:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5APGrqW3018894;
	Tue, 25 Nov 2025 18:02:00 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m9uv19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 18:02:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHbB95mZLN1gNnLSkIaGQqGdJNVfUK//rIuE5bpGJCqNJ0FcqU+bC5pnVhTOyvdF67UCbxkjujQF+oAlh7Dn0cWsM/QmjesIY/I6eRVrPd02xImb4Q028oF1kn5rjIQuOP3oyfzXMRsxTeQ6l8FB/9M3qQxIAiqeo7z0qKSzGtT28+beh0gq7DwTar05K+GUJdzp64qInHkZKBocSX9/Yxnj3mUI6GhZSd51QE2p/o1yHsssdcGGEKdVTXgLMBiLlaFd0pMOGgNJD9k0WlVGC1nBW9KY9g6y7yzNdFQuZ21LQKMGoVyVXd0aq10We4oQLueyeHgXrADlDklcBhs0Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iunMxBtPeomZBF/9EqpPhAPyHiXJeSDKtqD0BUQqT90=;
 b=OAzih49/L+BSE1QfF1/s9XkPm7ITAm0A1SRIl9CD2D9Nmnhb/3Y406+XyZpNhDFmpN1Ae8pP6KYmpMiYKdT+LcQV2plMC6oi8bwr0RfM+6Yk2U/bPU0LI875RBvgMB3UHMM6sCIOvKl5bolfzD2RMfLKyDriYOvFnYDjeri8UXkjJ89if6ADBEcCarVaXCCzr39bOLeojn8nMDD97Vz5Ws6gSUWg4HhrlAhtnnCBQ1er2dW3ACTmhrdCl9f4ssryLoV6OosYpHn0pLJH+cI/BtmqMGilFrHkjdr8+0do4aY09gIaaYLGPJcHo5J4YG+gWmn2Ry7vpkrQo0Xa87QhEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iunMxBtPeomZBF/9EqpPhAPyHiXJeSDKtqD0BUQqT90=;
 b=PuRJiHGGL1CSjJVziARdTRVwt2MAVuz/zn6XbWr59rElTKvquao22NaDDGbZ02IKEsCFE61Iww1shWmIhDsziB5+Sym7h6KHlJP/8FlmZfVbtPWOXQqwFeDpXiqGt3hCTTzb+Ye0oOsvwX5l+9SV4r3jQAjjoKZsus6C/QM73Rw=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by IA1PR10MB8211.namprd10.prod.outlook.com (2603:10b6:208:463::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 18:01:58 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::a82c:ceec:cd7f:8c64]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::a82c:ceec:cd7f:8c64%4]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 18:01:58 +0000
Message-ID: <ba7e29ab-6900-4ca9-ab38-ca459442a6f3@oracle.com>
Date: Tue, 25 Nov 2025 12:01:56 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
To: Gulam Mohamed <gulam.mohamed@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20251026191309.34968-1-gulam.mohamed@oracle.com>
 <b3c28b7f-503d-4e83-b4c2-b756150bfbd9@oracle.com>
 <IA1PR10MB7240FA764470DDBC324840E898D7A@IA1PR10MB7240.namprd10.prod.outlook.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <IA1PR10MB7240FA764470DDBC324840E898D7A@IA1PR10MB7240.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0045.namprd08.prod.outlook.com
 (2603:10b6:4:60::34) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|IA1PR10MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aece248-7316-48c7-91f9-08de2c4cb9e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejR6YXNnanlRVDg5NXlweDl6UXJJc2F2djFEMXg2MmV5WnNhN21vME9TUktT?=
 =?utf-8?B?cFRHSDVqVGV1K3YrVkx0R29DemdWU2p4cE0yUWxab2lEODhRNnZMMURqOGtm?=
 =?utf-8?B?cUFwaWhiVStwWGI5Z0ZUYnc1bTFTYkZJM3BGRzlzZGlXRFRmZTlCY0krRGx3?=
 =?utf-8?B?QTFxeFlSVmJ1T1pzamQ3RDd0dVIyRUZ3SlZZR25nS01PSFg2ajFLUE1ZMnFN?=
 =?utf-8?B?V2wydGlKRTJDUklYWm1xaGt3TWdwb1dIMzFqNlZvbjB2OFIrNFhUMW5Dem1J?=
 =?utf-8?B?bWt3ZUt4UTJueFdpZ3BReW5HWUdoMDc2Mnh6a2grdVYwVVpRQkx5SXFxcjgw?=
 =?utf-8?B?a1BDN2N1VmxlNnRFK0k1bG5yOUNDSi9KRWVzRFFoL0w0ek0zU2JuUFB5YnBO?=
 =?utf-8?B?WEV6dmpHRVdZWmVrQVVITDQ2a1lYN211RlJrbElnZ09FWko0RkozS2gvMllW?=
 =?utf-8?B?RDM1TG5TVHp4a0YvZFBxTm1RR1hKL1NmVzJJc1AyUVZUZ0JlaGZ0ZXFnQW5k?=
 =?utf-8?B?VFdFemdKamh0d0lsRUNJaFAyT0VKREdjVHpLc0xMUmZZYzNmNnpOU25XTUFk?=
 =?utf-8?B?Q0d5YVZqMU5uV21EYXlyTG9JMldCWFpmNjc0ZTZnQmwwV2hnNkVGZ243V1cv?=
 =?utf-8?B?T2RvbEJzbHc3L2xuRGlyaEJmQStnNUtoZXFDckdkcjFpQ0p0TnVXU3pMUGVM?=
 =?utf-8?B?OGcxdERQSmRPWkpuLytjQXZqMGRKK2MvRDY1Z2tkbGlwdDVoNFJkS1NaaDlk?=
 =?utf-8?B?YUZOL1pRWnBwOWlNQ0Z3MjljL05TWHVaZkFWUWJ5bjl3bVNRRUR1aEw3aEU4?=
 =?utf-8?B?Mjlta0xUMnBFOUFrNllwTG9iWWFoaFlRdGVudko0K3JzQnF3dWNmc3N1MjNs?=
 =?utf-8?B?MlFqREtFMzlYcXA4R3R3SGJ5Y0tTamwxcmlYTHoxdWUwQnJlVnJYOHdQNHdJ?=
 =?utf-8?B?VzZPQjEyTUY0K0V2R2JFNmdLS1crY0NsUXltZlA2RlhQYjFXVEZmRWZnOHlT?=
 =?utf-8?B?ZDhaQ25zcVpzekY2WWx0NE41REd0bytsY1IydkdKUXU4R21pM2R4aHNPNHpX?=
 =?utf-8?B?Y05sbFBuaGlYQU8ySStxalQ4VjZmVGVRNG9CTFYvSDJUSXk2ZHlLM3dIWVRM?=
 =?utf-8?B?Q3k2bjgzRCs3WmQxWjUwMDlYUk9COXJtc3JBSU05cEliME1mTVBHYmlIczFh?=
 =?utf-8?B?TExyM1EwNUs2OE5WVUQ5UlJoelQzYTFjaUdIeWRhSktMOFI3RGlHcDUwcmFI?=
 =?utf-8?B?aFJoQ3FkUm11ekZ3WTI1Y09CbjZMNS9hUnFZSzVHaFE0ZlFpODFwa25oUUZh?=
 =?utf-8?B?aFBGdTlKM3lBU1pvYVk1L2tjNVpjQ2ZMNy9JakJpdG1tSUFBc3VRa1A3RkFk?=
 =?utf-8?B?Wjc5c2I2U3NRLzV5Ti9XYjY1TUp2Y0pOTkppR3MvZ25jRXFEUE9abVZva1da?=
 =?utf-8?B?dXpsbHZ3eWRMSEVrYXlhdjlFVDVvWDY1SmRzMkZ3L3Blb3JkblcrMkk0MjVP?=
 =?utf-8?B?eFo0Z3BLVFRJZXg0RGFkc0d4c1VrSEJWTDdnSU5VdEYzVE1nRVZSdXM2Vk90?=
 =?utf-8?B?UEhUWHZ1emxvNzBqZnRDRDZnODlnclJJMm5saHl6OHZQejBJK00xL0ZLVGZz?=
 =?utf-8?B?amxJMk9YZmszZzdEMlZJeWpBd1lydGFUQXQ5WHJWZk9iQnU3c3dTemJrWE5r?=
 =?utf-8?B?YnpINnZRbzdDb1p4WGpiVVE3UUE3bWNuMXRGa004RU91T09yVDA4Wk5BU1o4?=
 =?utf-8?B?d2pPYmRjVno1R2tqdmJqNHVnbmd2VVl4c2hhaGM3TmxHc2FFeHh2WGZKSGZv?=
 =?utf-8?B?QU1tRWZwL3RWQUR5WTBDZnQzTEdDNVFxOERlK3ZZNis3R0NlWDR1R1NETFpQ?=
 =?utf-8?B?VGFTSnB3eUd0WkRVTmMyZWY5UnFJcnNXc0ZXOE14V2RET2EwOVJqYzJ5VnpT?=
 =?utf-8?Q?oXbyM321FlxM75zMWzz+BmCgQ77Z9Xyz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RG5JaVM3TDJSTDFTd1hTRTJYZU53Y1NIbEM1dUpxOUFFYTgzNXJtVE1wL2xq?=
 =?utf-8?B?RkYweW5ybGtQQ01QcmVIY1pGWE80T2ttN0xBUFJOck9xLzhUa3Z4YWtpcEVS?=
 =?utf-8?B?NlU2d0kweE9namJjU2V5NjlWMFZxRllUeGVmeWVBdjZYQk4vRzlSTEFZMUxH?=
 =?utf-8?B?NisrT2s2Ym9wTTdRWEV2MmNJME1yZmFnQjZqcFkvellUcERPUEdncGpmMmNK?=
 =?utf-8?B?VWQxSkdiSVd2aGlXT2RWczhPbmR3N0lyMHFaTkJmYm5GSm5iNWFnUm5rRmRy?=
 =?utf-8?B?V3UveVZCK3FnR0V1Q0VCdHl5cEthc2FadzlwUzQyU05XekVicFk4ZDRNa1Ny?=
 =?utf-8?B?TE9yMWkyMWtnZ0VGVExPT2YvQWpVVjlEYlhrTS9lcXhPdU5jYy9tbnpsVmMv?=
 =?utf-8?B?cGRydjY4TkN2T2hXQ21nanJ4TGNvUCtFeXN2dHM1dG9SNW5RUlluSXE0eXFY?=
 =?utf-8?B?ZVdxdjh4dFdvSkdrd1YvY01RVko1UnE5cm00NEFNUm5oV1lybnp6SWx4Z25x?=
 =?utf-8?B?am1CV2NOVFRoSmovVUFuWjBKbGJOeEs2TVN6UlJJdDJsQnZCY1pJdGxtQzFD?=
 =?utf-8?B?L2o2VFU4aTE5RnNMZ3VGMldKZWhheTNabDVEZnJkT3ZZajZLNTZiS2RYcVBo?=
 =?utf-8?B?V2JyZjRDNFJjR0xoVElzT0tITGJSZkN4MGM4emNlcjFsNnNiNFdTZFJBREw5?=
 =?utf-8?B?UkpJZXJMeVNEVEVPeXlDaS9LdGw1NWZLS0ZSUFpRM1VURjMvbm9GcVl0bEsw?=
 =?utf-8?B?VWtqMjhrQnNwZXNtMC9Qc1BqWThtQWpuc0JoMjNFdW9GM1ZwUWhXME9IZ1pU?=
 =?utf-8?B?dFdaYWJycWpJbHFOWnltbDk2cVlZbjIxZjU3WU9qaGhZQWR3RDJjam5BLzFV?=
 =?utf-8?B?aTlaeW1DcmliN1haandybGxMMVlQSnpGTllaTVJjL3FaZEJiNFdad3d2dGFP?=
 =?utf-8?B?ZjJHU2Y5MDlsZU5lZ0VIL1FSSTN1MndpQUtWcnNObGJpdnkxMjRjT21rR2ZX?=
 =?utf-8?B?bmg3YmpGRTR3cWFrNTJVcnAybmxTbkUyQ2Z5aTM0NHcyZTlQekdDSkR5SEdH?=
 =?utf-8?B?U213OWNDWXVyNTFOM0lNSUtxYUp6VUFBUXFHVWtqalJDUCsxdVFEWEtvRVZG?=
 =?utf-8?B?dnUweUEydkxJeUdWbFV4RHNsTS9vUTZFcDVQTngzYW40MnFMZzQzZmFiWWtl?=
 =?utf-8?B?UFYvM1dMS1FXdzB4bzhmVXhpM3ZsN1l6UTRQYUdNVzFlcXpKNE9XakVpbWMr?=
 =?utf-8?B?N1Y2QnBjNHNrQmtOanc0MFN4eUZwY21lRkdxTG91VTlNNGRvSmhTbm1lSU83?=
 =?utf-8?B?dmdxNWFjeEJJaU1mSXpDd3VvUnI1RFRieEIwS29rQVFtZE91U05GSHB4a0R5?=
 =?utf-8?B?Ynd2ZkFZT25JNnNqRjZISXE0ZEtPaC9xYUNpa1cyam0rendXaW80b3FhdThZ?=
 =?utf-8?B?d29PektCS2hNQnpaMTE4UkN0cDUwU1ZoTDNkeHJqWUN2c2I4eGFDdHQvanhE?=
 =?utf-8?B?TG1QWDFHZW9nSDMyV2FpZ1dZRGVWbGt1by9zZktrblRPRE9OaDl5dkFUdkY5?=
 =?utf-8?B?Tzh0QWNuLzEyQ0hLb0JBZS94TkhuNStnUnZ6WlB4cThwTkcrLzZ1dTAwc2Zi?=
 =?utf-8?B?Y0l1Nzh3QWViU3NQUmNUT09qd21HMk5BU2FPZHVLOWpBOWFoU0dUeDMzaHdj?=
 =?utf-8?B?OW9XRm9UN2FEcEk3WkFXcG9DT211VWdUMzFHOTBhRSswYWRvTUs5a3lLUTVn?=
 =?utf-8?B?eWJiWCsrQm9nQXUrY091cDBBcWJzTVVhY1IwY05MQkF6Smc0M3V4THl0aEZB?=
 =?utf-8?B?MWN1S1ZqaUZtVFgvTTNBbURvZU9oQmxmOHhjZHd0dEI4aDRNcDVRY3RsR213?=
 =?utf-8?B?MmR5WWxZUkxTa3p2anJqZkpMRUt2MXJaSUQ1WEhtZXE3NmJsMlVnNVlJU3h2?=
 =?utf-8?B?TkNqRnVvSnhSak95ZGpNWElYY0FkR1lhYS94Q3RMWEgybHZJWFFPZEhRN0Vp?=
 =?utf-8?B?U3JsMnZZbTcxTDVFb2pZRzE2VElhQzJwYUlxNHBVYXpRTEtFUVF3Sm5CRnpx?=
 =?utf-8?B?VVlsbm9VUjR1M2toTEwyLzduQkg1dkxPNEZ0NS93MjArWm1xbHNZT1J5cTFU?=
 =?utf-8?B?bnpEUktEbGhSVHdqaDQyMklEZ0x5ODJMQkJPOWRRcVUybHNkVHhBMHo0MnJr?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6GEQIFddEKLo/WnjS2N2sDjjPRzKiWIYyQF0D45x3/J6jBy65gc7pD5oCjlJXqbdWSfwAzxi49idEJ4qAdmfgolaOwP9v3+zAjvLMg9BiaQ0FE8Cg5v+OmBEL7jA8chWaXrR4dPiR+zivZba7I3AAxRe+ccSGpfSrwLiiR0roH9HneJBqXsYM8fl1z3dnsGdByVlRwwvIYcwZ1FaQ30pWg5y36VM0hT6fpvLWYPi1eTwBV751uJR3VqVxnq+HgujkWPKQBDMoZgZmCYgMfvoNXKE3ZI2icOtbHTvOh6ab+Ntf7h0jos8V9oa67DrERuh9lE2XmskwGSjhngWJQV4AjaXQILG9e22+B/i9jeKiqd4rgn8rd24bakThgIQksMNYMhj5/Tr2EbXlB03nxli+8L6WJJGroOwIbZJZWgwLDFPV+sbpXZ56ysX+D2SONXqC42NV9wmXOqTHYXMIj/u9PwaoQCeLg6GEAWJB2yvGGFyIN2rqZToPVi+ToCQm3TII88AF4765s0bAGdQW61pbDV8H+BLhDcIl+xkx60vcyG/PS+aJdfcS2NaG79gv4S5jIDD30aXhJ/f5T9s5SGbNmlBDrCCmb/5mI3LBCB0kI4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aece248-7316-48c7-91f9-08de2c4cb9e2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 18:01:58.3041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8TT/Jsbby6y3qIRwpnIEyzyqW6BKYWbAYCRC6OxBEFVyPcloSquDRPR6JcK68hKAMyzF/FoYwhhc+yuefZfbksUBshDXoHOAx3QSiqCDpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB8211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511250150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI1MDE1MCBTYWx0ZWRfX7RwUqQLjMEDR
 9VjfKSrdkZs24Ugb6urD19IXR3jJhS2qPAxn8DSEydVzN2/+bECPMdmFnHUdxnLdTvHaGaQf1qK
 8BNzUVux8j9aExu6XHHgWBhOgdnLAZw07YUD6qNKGGBV1PeqNCLjKV3QR1WF3QOBVlXHEaiKg2J
 ts9NahyAB5KKGZYhFqXlzq8h52js2Xn6kq/FoX4T2YF9vUJ7UMiu1QtanTR7Yc/qyYuI+cELdw5
 CuW6BLXg2OBTr+ux/z+umIumXSYFicEddQenkxN5CEHQ7klJ+CZb4I4PLUzMjSIWxQd664xiw/A
 JRl4zCiWOSHkQatop9rGOq5tWNGdzeQQ5bNh3zvl8wVHgZQ+mF9y2yYhzHjHbtS0VzKE+wX2afR
 gUvJQpCcpt1UxU6Gj7uJKbZymgRW1Q==
X-Proofpoint-ORIG-GUID: eQ92QgokROvOedkYpHtgVvySdhgTxST9
X-Proofpoint-GUID: eQ92QgokROvOedkYpHtgVvySdhgTxST9
X-Authority-Analysis: v=2.4 cv=K88v3iWI c=1 sm=1 tr=0 ts=6925ef19 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KP6iQ-ul-HXGMeheaD4A:9 a=QEXdDO2ut3YA:10

On 11/19/25 1:58 PM, Gulam Mohamed wrote:
>>> +   buf = kzalloc(buf_len, GFP_KERNEL);
>>> +   if (!buf) {
>>> +           pr_err("Unable to allocate response buffer for IDENTITY
>> INFO\n");
>>> +           return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>>> +   }
>>> +
>>> +   scnprintf(&buf[header_len], buf_len - header_len, "%s",
>>> +            dev->t10_wwn.pd_text_id_info);
>>> +
>>> +   put_unaligned_be16(id_len, &buf[2]);
>>> +
>>> +   rbuf = (cmd);
>>
>> is it really ok if this returns NULL?
> I think its ok to return NULL.  We just don't send any information. I kept it like this because I don't see any information defined by protocol when the memory mapping fails.
> Mike, Can you please correct me if I am missing anything?

It's probably best to return a failure so the caller knows that
we might have a ID but we can't return it. It will also match the
case above when we can't allocate memory.
