Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9605F12CDA5;
	Thu,  5 Dec 2024 05:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733377966; cv=fail; b=u4lEiHf9ebRQj+sB5PmF2ZNQVTXJDVKM95UTZm1qvMrSw3QJ1thrIiEJGxcpj7GV2XarS3YyNu6EGIU2oO1razVDHMPpGUWRrW/zcSWNlAIyQ/GWLH7O3+grJ8clWfndmziyMDbf3zC7J6mPqpG7jl66MYXYwreV0gDV3LBHHuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733377966; c=relaxed/simple;
	bh=RqzgAdapSZg2DkWV8DDD2mpjCszJSiky0bcjGcl0zRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eluBxVsVLZeKhGvmrpwLXIhjh3EaKHn5tL6kfEgXK0Dwp133XeMM8jRPsonqJ0i7O8Gwp7xU+O4PZ6mc0nrIwekQQ/FJVS9A7gaswM6570tqj3Fm03sO2lQeATYqfL/IsazShI6OwSSK2ZmbWdeheZ9BMMbsFvC299YlNoGWGXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IgiPdHSa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ihbSF+Zt; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IgiPdHSa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ihbSF+Zt"
X-UUID: 21e8ab92b2cd11efbd192953cf12861f-20241205
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=RqzgAdapSZg2DkWV8DDD2mpjCszJSiky0bcjGcl0zRg=;
	b=IgiPdHSawv3mapNZlq3DwF9cMHpzft5G+2DKezayc56lKE+OBKSQWIkdNjsBkRLJWSfSe6d2cK2pm1FrIzs0bu70lHerAD3y2veLp7Qz9pcK/nn/23BFguxYntuWhOWYbhfsTKwBheuWYWo/X4OAOsf7h+x2LEoXex5LXF32S5o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:ea791ffa-557d-4dd2-9bd1-118438afc0ca,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:41fcf5f5-e524-4511-b681-7d630745cb54,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0,EDM
	:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 21e8ab92b2cd11efbd192953cf12861f-20241205
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 481196503; Thu, 05 Dec 2024 13:52:37 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 5 Dec 2024 13:52:36 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 5 Dec 2024 13:52:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5t6bmrtbUmemeIA2YximzDbsfDUmTEeoAYr5X3/qVffrhtmmIFHFJNuFsAsNn3EJRsHBkjoCHDn17m2VX6r4cfuiiZ2tDHebDKx/hm/R69VwTK5VLg9tjquQp3opiLXPStBFpsbwPQS2VTM9a7kicly1KEuUkHFELUgid6DbpuLN29YiWTMDUkc1EdVIzb35jS88FrXDAzjHojI4/AAMuwzI7WcJ0T1S90p9MBSKnppwqsi6D4zm4uVSOk0LhzHYhdF3VjLBslTmt9pOweqEgevij6mokLRWWh8WxSR6P0FN5dO0nDi3Pq1l3q5IWG5C1qTtjf852Vpazljw+DPIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqzgAdapSZg2DkWV8DDD2mpjCszJSiky0bcjGcl0zRg=;
 b=bUWFJ5mRt534Lqmh2IJNup3z7V8UMyTAsTm+dF/sf1K/3O+++kAH2Ycxm4DSnvCtamO8IV51F7ZEqBvOr5pGpV+ALdYfRRMugajdqRkY0qMjcxPlD+mZUdK5WM5SY2/sOulAspICkz3nKp25C0lxXw6Rf1RlwLAtVSNvlBLf/PnHnTmmBMt7Ka68lQZx2xZfYYPD2oKTPiSqcZkGotWM9GXkfXkU1qxnBr/X49g0V6gYyVmYwz+KmkcJychzqbQS614WOI31158E22FLiEwP2uqQcUV2JDqj6ezwjEJOcQobOpaRXmC0SG7OeXp7EKU3cuN5wlSmXO3orkCZ1JTelw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqzgAdapSZg2DkWV8DDD2mpjCszJSiky0bcjGcl0zRg=;
 b=ihbSF+ZttGRz96bIkQFw4QAVtn3PJrUQTwy24r6qWRwT/VpKz7VSa8fWoV5fwcDbu2AUk+YbNQSPC2m6x0Lp2IWRcCwaqomtDkFEo5sEb2Y7WabG1WMHcEg0cpaVWNp6uB8QJDZVU90QtjVSoPiqtk5Lk/yWtj621TDvqLkX7RI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7890.apcprd03.prod.outlook.com (2603:1096:101:178::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Thu, 5 Dec
 2024 05:52:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 05:52:34 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "ahalaney@redhat.com" <ahalaney@redhat.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "liuderong@oppo.com" <liuderong@oppo.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi:ufs:core: update compl_time_stamp_local_clock after
 complete a cqe
Thread-Topic: [PATCH] scsi:ufs:core: update compl_time_stamp_local_clock after
 complete a cqe
Thread-Index: AQHbRkL7hBn3G8WCD0SljFhE8z5QEbLXJzuA
Date: Thu, 5 Dec 2024 05:52:34 +0000
Message-ID: <febcd6eb3565feaf09d21a8c78fd7412be88e0c1.camel@mediatek.com>
References: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
In-Reply-To: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7890:EE_
x-ms-office365-filtering-correlation-id: 05bc76c4-5847-4adf-9c69-08dd14f103ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VzFwbmZWRS8rVVM2cEU0SDlQVTZXbGFXWEdFWllJdFk1cU9UemxSRXdjd2N0?=
 =?utf-8?B?RG9ZcjdUclFCL1MzY0VXSHhDVE5Qb0orTk5wMDZWRzR0VGllMU5EcnozVTIx?=
 =?utf-8?B?UXNpTWgzY1A3Ym14MmxOanZDQWNTQVBHeUJsMm5FR1UxQVdyRHBqUXBVUkFK?=
 =?utf-8?B?L3g2SmtCbHlxQ0pNd201V0dWMDEydGFtK1NpK09PK0RKMXJGaW95Zi9KVCs2?=
 =?utf-8?B?eU9BUEtpSGlScTc2L2dOcTNRYk1PNllzbEZTNUVtQmJaSnJicW00bEl5T0cw?=
 =?utf-8?B?NDlrVU8zbFUwUXI5Q3dzVEVnSXEyU0J4M1lIaExBalRQamN3QzRrcVovWkNG?=
 =?utf-8?B?OGlMamo0ZE5qNTlBY3JZWmZuNzJrWjc1aHJGZ1hzN0FPS2k5Njc3TzJzS0x6?=
 =?utf-8?B?U3NLMGNGTitoeWRzVnpWTFN0d2J0NHEvbm9MY0JYRkZ4WGQ0ME9kVVRCckNT?=
 =?utf-8?B?dXVEcVVROGcvdmV5eUN0U3kvSGxHVWdNelhkVDBYVm1wOUovdHJhYVJHWWVD?=
 =?utf-8?B?RVFNNEhuZ0RWK2UzNE1HUUFIcTRUWWN4cFpxUStMaW5zUWlEWlRlL042cnhI?=
 =?utf-8?B?SGlUNWlzbTdWYTVvc0swVkRxcDJ2bEZGYWQyTENpZk9WdTAvMzZEV2lUREdu?=
 =?utf-8?B?U0N6SlhLSHpaaE92cExNZ25mWVhJK1grN0w5NjNoVW5HMmRQOHhwMExEWEw0?=
 =?utf-8?B?bGdCMGVVYkJRTXU4eU5KT1RIMXdPMWcvYk5vK1JNVHhVWXR4OElXYVNyYzJL?=
 =?utf-8?B?M1NKMk82dUtrYVNkYlB5V3Jldlo0eVhYMFNRL3JqTHZXekVJWkgvMkFBVHlj?=
 =?utf-8?B?dEF4UUl0cEFzTys0NnJmVHhrUnRibWJvZlNZOGRHRG5xblRHLytvNXdIUTli?=
 =?utf-8?B?VDRnSFJEWmxyUlErY3pZRDB2TGd0NnJ6NFRDdCtBbFg3djQ3eDVyQ00vRXc4?=
 =?utf-8?B?RzJnSytESWJEMStZbzU1S3I5Snd1bWR2eEdUb2pOU0FYUVFYeHhqSjY5N21N?=
 =?utf-8?B?bHVpVG1IR3pKYXNENytaYnlqTDdiNEc0d1l3OWk1NnBWdzBtTmtBNHNnVFRJ?=
 =?utf-8?B?VUx5ZVdjWm1ONks1Z1hOTTZteVRjVWZmWTZyQTFPMFlCZ1JyRndhR2dVVW5U?=
 =?utf-8?B?aHUvNW03SW9rK3J2ZHg5WjY3WGtQS0RQZnA3WXhyeDBsMFF3cWF5L1FNY25Q?=
 =?utf-8?B?d3Z3N242OUJRT3FCSk1OYlRVTHgzWFg1ZTdjbTdHdDhvSFN3dHByU0tRTGxD?=
 =?utf-8?B?QldsWTM2Q1RHNW5hK0doOWY1b0FlL3NYL2IvNHdBM0xjYldDTmxEQ2tKUXhW?=
 =?utf-8?B?bFFaN1Vib21IbzFhSDMvT05SZFp0ZjVoTEp0NUpkWVR4NVBaUjdwR3ZwUkFy?=
 =?utf-8?B?SVlRR05nQU80Unp2NngvZ0RVYUlseGVkbi8wTEJVb1FrbHBRSWtQN3IzMHpN?=
 =?utf-8?B?aFBJQytJNDRNb05vcFI5QXJRNW80S1BOdGhWaVpIVUJmQ09wWkRsbHdFNURN?=
 =?utf-8?B?bHFMSkRWbm43NEZWNTBpMENLKzBiWHJQNlRIRm5lQkJPb0UwMmpVTHgxZVFE?=
 =?utf-8?B?RUxFekViU0dzN3FrSjZhU3RZeVd3ZDZGeER6T3JNUVFVMkVlZDFYRHdGdkVS?=
 =?utf-8?B?T0dLZjJpa2cwVUFzb0hHbUg3ZkZ1ODhEZTBGdEI4TFlVT08wMFdIMlF3WXJk?=
 =?utf-8?B?R1dMaktHTWJCQ2VJQ2FRU1VLNzFTVDc5MmlNejdIV29PdDBuRjhVZ1ZsVzhj?=
 =?utf-8?B?ZjhpaGovMldMcnZXSVFxZjcvb0dxUWwzTURIdis2b0Z3eVZ4emszVWwyVUFk?=
 =?utf-8?B?WSswaFduU0xnaW9vOGthV1doTXVUU0trZEFjVzZLZ1JLWUtqMDQ2K0N0eEpY?=
 =?utf-8?B?RVNIeFZFb1ZIM0tPZDFxWFJjcmVwM3NTdXJQMldXNS8rbWdrbVAxVGI3b05O?=
 =?utf-8?Q?aiaZ2qEcohg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlJmb1N2V0N2ajl3ZTc4ZFZ4MEE1VlBTbU1lYWJSV29vdk4wbDRyZ2FLUUxX?=
 =?utf-8?B?c1Nob0FrN0szek1sOUZPOEN5N2d6Rkk3ZWlkVXI2c0N3dXh3cytEcDNSa1pM?=
 =?utf-8?B?QlBUbmhnT05ScDRwaVNPRmpQUU1OME80aVd5dktXeERZa2pWdGp3RVNXREFr?=
 =?utf-8?B?bHJ4a0lSVXZjMDkwWlRWVllFNFBxT3Z1T3hVMDRrZGdYa0tWanlJbDdWdGcw?=
 =?utf-8?B?bE8vazFDUTFYVWNFMFNMRUlmOVk1bzlucXcwaS9DNlptOVFGYzFVL2ZYT1hI?=
 =?utf-8?B?N0NTS2p1S2daOGtycTBjRjFiL25LTURSQVJBTnBTK0NsUTR5U1VFellBa3JY?=
 =?utf-8?B?WWM2YWdpUGlKSTd0aUUrUW9lV2xVVVNqR3MvYUF3Q1p3T3dMejQwTmRseGJZ?=
 =?utf-8?B?VGJpYkdOc0pMQ25CZ3E0b24ycUJhNXg1aDVic0xOT2dFdHptNDFuZ2oyR1lU?=
 =?utf-8?B?eFM2d1ZMem5HSDB1Q20zSkF1dGNLMU5KN2p6K3c0aFg1bjR6SWF0L3FJRVBE?=
 =?utf-8?B?WGNGTm53MEpWN2hKTFQxMk5tMFRxdndyZDh6bnhwQ3R5SStRdzg2aFBNUHVU?=
 =?utf-8?B?ZUttdUxqcXl3V0R1VWJHZTVralp0OXFIRFgxNEc3ajdtK3Q4SGF5b29vU0tO?=
 =?utf-8?B?a2NwR2NaTjQ1OS9pLzNTV2FQYzlDSHkrekdyTC9hbU5vb3JXd3oyRThXc1g4?=
 =?utf-8?B?MmlGT1BGQkV3SEFieXR4Y0FHdWg2dDlLaUx4MTRXbm1Uamp3d0lOT1E0YlNt?=
 =?utf-8?B?dmgzYzRMNHIySjNONHRsSUxZaE9ka0k4M3l5MEZ4a01iY1N5Um5kSFhWL1BG?=
 =?utf-8?B?VDg2N205WFJnVFA5L1JNTU5ibU10U2lpTGdjVE5SWis5Wm5TakErNWdUaWp4?=
 =?utf-8?B?bmR4S25TckpxaklwVmY4ZnRsWjJQMXNTQ040SCtKS2NLRWtGYzZqRlM2UnNs?=
 =?utf-8?B?OXUreVNBSlV4clBYRjdkcTQzWm15UXU3Z2N2UFBLVS92Nk9QMVFiZFluMkdK?=
 =?utf-8?B?U1M2eDR6TW5JTTZmR3ZwT3ZENUxPNWRmQjlPRDRWL3NDV1BCY1lpVTFDb1Rp?=
 =?utf-8?B?YWZqTXFZVlFhQXBpWElkdElpZG10K2RZZHVJVmhsUnNyb09QdUlNWHhnWTF6?=
 =?utf-8?B?RjhPbnJSMHZjOFg1TDRRR3ljRkFtV1pCNXNtY2NUTVVTZjR5U0kralV5Nnpt?=
 =?utf-8?B?ZTg3TEhoQzBrNXJnQ2k0YmtCQzVtTnAzcHNwZTAxL29Ec0tMZGIvTkJWZS9I?=
 =?utf-8?B?bUQ0RWJkb2VQZXNBa3dIK2dLSndsbmtBZkxkUW1oRXZDWkNSNWdKRi82aWVW?=
 =?utf-8?B?UFNTa21WaDlSMkZEYVExQmVtbFBFUXphQ1BsbWRsNGtiNTlNUi9vd1N1bDYy?=
 =?utf-8?B?dmNKYzc3bng2dk9ScGxNUHZIaVJFUTVlaXJTcmtRRFJaSHFNaHBKUVkvVUFv?=
 =?utf-8?B?YytUei9FQzBGMzloWHl6aHZQV01GZFBBKy9LRlNtNzY0YU10M0FoZDBmWnkv?=
 =?utf-8?B?ekZpd2FVL1hndHc1SkJwSkpodzJ1eDZDREhIVlhhMEVhMUlPVXRzaUExZC9G?=
 =?utf-8?B?ZGxXNGRleXlXS2ozMlFhT0xxbkM5V3BwcTNxa0VVUDBzUTY4bVdkR040UXRZ?=
 =?utf-8?B?ZWgvU1F6VUptWXUrUXlNRjNhUG5DMWFRVzlYT3BoK2tSSEhmck1JMTFhU295?=
 =?utf-8?B?WUxEUS9uL2t4T3VmalFyUWhiNGlUWEFRaUZ6MkQ4UGZHeFRVbTl4cVUwUkxU?=
 =?utf-8?B?dUFjZHVtLzRvZEV1ck5wdCs4azlVUDBwZDNPdGUwWmxMRDB6WTFXR0ZUeVlN?=
 =?utf-8?B?NG5LdHg5SUFBb0k1RnJ2S3ZySVVDNTlxOHdZSUlTaTNaNWszb0hFL2FpVjEz?=
 =?utf-8?B?aDN5dGx3aW1KdVFCdFVlSnBTTlVxaTZmNUJVaVNjRHNKQ3F0UG9xeGl1VUlP?=
 =?utf-8?B?cFlzWDFLRXlTL3Y0VkZRcmZsdy82UVltakRhQ0crblp0aTNYYjByeW1mbFNX?=
 =?utf-8?B?SkdzcGxBNFFhVTFnZmtMajFwZmpwdHRUVFU1cjY1VktqZC96emZyeVFuZDVu?=
 =?utf-8?B?M0hPRlRvbDFPQjRDc3QyWUtEenNtU3lOTm14R0poVTU0YnFmRUNiWG1xRTlK?=
 =?utf-8?B?M2lwN0dVL1RCNDcyaWgybEszSEZVTWJpSWtFd0hGQ0xsQzNiSmhBMVdrY1Nv?=
 =?utf-8?B?RVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AABF3A2ED0A1C0488ED8ADB59DAEBCB0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bc76c4-5847-4adf-9c69-08dd14f103ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2024 05:52:34.1220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 851BOrDYVOnQZ8OYrEymtARQdnft0JGOypUWVPf8S7lYxw/OqInD2UnejsYhvpk84/rQnRn4lbknRXn/y4VFqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7890
X-MTK: N

T24gV2VkLCAyMDI0LTEyLTA0IGF0IDE5OjUwICswODAwLCBsaXVkZXJvbmdAb3Bwby5jb20gd3Jv
dGU6DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhl
IGNvbnRlbnQuDQo+IA0KPiANCj4gRnJvbTogbGl1ZGVyb25nIDxsaXVkZXJvbmdAb3Bwby5jb20+
DQo+IA0KPiBGb3Igbm93LCBscmJwLT5jb21wbF90aW1lX3N0YW1wX2xvY2FsX2Nsb2NrIGlzIHNl
dCB0byB6ZXJvDQo+IGFmdGVyIHNlbmQgYSBzcWUsIGJ1dCBpdCBpcyBub3QgdXBkYXRlZCBhZnRl
ciBjb21wbGV0ZSBhIGNxZSwNCj4gdGhlIHByaW50ZWQgaW5mb3JtYXRpb24gaW4gdWZzaGNkX3By
aW50X3RyIHdpbGwgYWx3YXlzIGJlIHplcm8uDQo+IFNvIHVwZGF0ZSBscmJwLT5jbXBsX3RpbWVf
c3RhbXBfbG9jYWxfY2xvY2sgYWZ0ZXIgY29tcGxldGUgYSBjcWUuDQo+IA0KPiBMb2cgc2FtcGxl
Og0KPiB1ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBVUElVWzhdIC0gaXNzdWUgdGltZSA4NzUw
MjI3MjQ5IHVzDQo+IHVmc2hjZC1xY29tIDFkODQwMDAudWZzaGM6IFVQSVVbOF0gLSBjb21wbGV0
ZSB0aW1lIDAgdXMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IGxpdWRlcm9uZyA8bGl1ZGVyb25nQG9w
cG8uY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAxICsNCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4IDZh
MjY4NTMuLmJkNzBmZTEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMN
Cj4gKysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBAQCAtNTUxOSw2ICs1NTE5LDcg
QEAgdm9pZCB1ZnNoY2RfY29tcGxfb25lX2NxZShzdHJ1Y3QgdWZzX2hiYSAqaGJhLA0KPiBpbnQg
dGFza190YWcsDQo+IA0KPiAgICAgICAgIGxyYnAgPSAmaGJhLT5scmJbdGFza190YWddOw0KPiAg
ICAgICAgIGxyYnAtPmNvbXBsX3RpbWVfc3RhbXAgPSBrdGltZV9nZXQoKTsNCj4gKyAgICAgICBs
cmJwLT5jb21wbF90aW1lX3N0YW1wX2xvY2FsX2Nsb2NrID0gbG9jYWxfY2xvY2soKTsNCj4gICAg
ICAgICBjbWQgPSBscmJwLT5jbWQ7DQo+ICAgICAgICAgaWYgKGNtZCkgew0KPiAgICAgICAgICAg
ICAgICAgaWYgKHVubGlrZWx5KHVmc2hjZF9zaG91bGRfaW5mb3JtX21vbml0b3IoaGJhLA0KPiBs
cmJwKSkpDQo+IC0tDQo+IDIuNy40DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53
YW5nQG1lZGlhdGVrLmNvbT4NCg0KDQo+IA0K
