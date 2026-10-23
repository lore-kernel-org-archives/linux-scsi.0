Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792772588;
	b=RG5TUH+Rg/KS4P97PxTcO6mGiJPGVoNmoqsUxD1sb1aieVsFU2IS2T6cmQ/GdPIgbZpW
	 1XHB/WgzWgNoMXa+gjnkeNQO5TCAhoJKYnLVtUh79N3tOTfKagz6oD6IvwQ++1LV4pHEp
	 +PoxV3Yi0pEcva1S8xx9cHv0fHarS92CrGbGmIbr4ZB6V0nDCj21uv1aG+EKFwR38E9x8
	 JVlKiuwliVYA2qGPHidoYaaEz+4FHvCssDszq8oUA8VQesSxzeXBXDJAGKGBpwZxBnl92
	 fNugGuIvBoipYg4NoZZcDac9FEDCJxbsdpYd2Ht7pNXmHgneftQSxdBm28JN3TqbmOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792772588;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=uTq0rYZnePu1bDpmNe6qAwHAmr7W6jNfBwOUC5NYSZs=;
	b=dd4aJf9bw44ZuJKRLguipJTYuBkGTyQ5/3DGSJztywb2aax+En/DTeqUCTruNmXhDqCt
	 610ydImL01uYMQ0ZGGjFca+oDBHLA9nf5bQyBnid7T60MxWwn/oAdH9ho3Lf1w1bTIydV
	 izaGxPFkvfEm+QmQGHapbjeWjAJmfCspYIeQ5oWgj4v7DB9jQBpfb5dXmZU872UXmE1wT
	 g2CL0WXg/D6ORy1XLb3wqDaWxuTkqdUDrD2bNYyhb5eW3mrNhMDlIXlu68yOmNgJqrWOO
	 KsSpcqe/HrLbpBagh23+pP13FbRxKIl2X5Ka9F0UK2iGxxrWQEtA9zRE1rMag70KLVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=P8gQGhFy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.27
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010027.outbound.protection.outlook.com [52.103.23.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33528606A320;
	Fri, 23 Oct 2026 16:23:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33528606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=P8gQGhFy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xk8Dkw86zSMeoNN5tnk/wGWwTv0TOneQYvffYQo9JHndACmjutjJrcMrj8UIww+6Kk1+ErksErHcjUBdvddshk6z2gpOCOuDxtoupJ6w9TEi7gZzRqzuWjlUS2NmuKm3+2xQjcPw+8f74gBOQ5TqoRfygNdhNZfZqPnKM4aHi1Mr53qtDH5ujaBfXzqkBt0A2ARGFCrpnO2ZL7vf4Aw9ZdE3SCsEl2PpO8rJVaOA87B4Ld4Mwz+gaaS2hCJjAPcdCFSdDYYrFFFiIHe6xEyFSU+IvqWTD/LkeXU3HywI/z48yhBjwHQnqrXQVP+rG8zw6wsRUzH3/A/8Gfr0eA/UpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=uTq0rYZnePu1bDpmNe6qAwHAmr7W6jNfBwOUC5NYSZs=;
 b=P+rnRaX7j9PAH9L2Jw6Gm3xIrmakulUkZlZ+ggfXpdUpxl1GMz0LzFXigK/U0Keo5aZ88lQHaOyJFu7XO7Y/7tNDeyc25oFowvz3Rc4DjPFUf7Mw+26Z9AqEVdCB8eexoZAp1US6ncCuDLvJe8KNLpDBQtCxPdenKF8nRV3NEqK7MMeyi+COdNXIQ8sPUrp6NMbrTOgL9FsZ0j64BdBSiAOBNDRAQb3a7Nt+PkuLFmZGZRnafY913jhsgazyI/seqKfgj8AFRdeKvN02s16bTEgMMdh6g2z7GohSFIwdUydLCuxaXMqRkAnFxcTx29LDI1TS0yXPCsa/9PAyVF5Kmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTq0rYZnePu1bDpmNe6qAwHAmr7W6jNfBwOUC5NYSZs=;
 b=P8gQGhFyp8zyoJIV3hpWdUnhHp+v7wSniTHvQNHFyYXMbtMcP1IEF3AWepOt8p6ZepHZqutKl1/0dsqrDV6dyqkghXHMZvBk27HU42sIW7NDcs/JluBDgLU/ha2lFWrFCCYPeWr2Cm0S1X2zH7dYVs1++Klz0omDGSHYV1U0EYG5UL0eJUuUcxsKnNwqdsdB4zK3YSCHCiQbP8WwCjyYfC6qdg8DcLgT27dlAM5zYQQt2aUmH+JMjfEAwS/jJSWWf5HAZkpRP6I+z0s9jZLdc3rmrZf77o0Ki+Vfbrgfb27Q7yqN5zTlJ/PRY1KSrKdRjfHpa1+HwwMZRQ1oSE/2AA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by IA0PR05MB10120.namprd05.prod.outlook.com
 (2603:10b6:208:3df::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 16:23:04 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 16:23:04 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Bart Van Assche
	<bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Yang Xiuwei
	<yangxiuwei@kylinos.cn>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yingjie Wang <x-professor@outlook.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] scsi: bsg: report synchronous data copyback failures
Thread-Topic: [PATCH v2 1/2] scsi: bsg: report synchronous data copyback
 failures
Thread-Index: AQHdYwrHlYBA24BlJkuiyy5GiQf4YQ==
Date: Fri, 23 Oct 2026 16:23:04 +0000
Message-ID:
 <2561d633cc8cef513d75eb1df260046a4971e783.1792772194.git.x-professor@outlook.com>
References: <cover.1792772194.git.x-professor@outlook.com>
In-Reply-To: <cover.1792772194.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|IA0PR05MB10120:EE_
x-ms-office365-filtering-correlation-id: 40b4dffb-be3c-4d97-2a42-08df3121ea23
x-microsoft-antispam:
 BCL:0;ARA:14566002|41001999006|38102599003|22091999003|25010399006|8062599012|31061999003|8060799015|19110799012|24121999003|15080799012|8022599003|24021099003|12091999003|26121999007|3071699003|102099032|440099028|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?TkFybjJYdUl0YVMzWTdlaGFkSjBieUpnbkRaMW91Nno5SklEOVI0ZHdyTGJI?=
 =?utf-8?B?QzAydGExOU5Tb2x6dWdnbHpHSU9GWkVLUm1RNmZCd3RtNUFFRWdDQS8yZW4r?=
 =?utf-8?B?R3Ivd3hGNElyajNHVlMrU01DOHJjZVlUZ0tGdUVYTkpwcElPN2NLV3cvMmxn?=
 =?utf-8?B?Yyt3Vlo3VTlhVkNNMDR1R1JDREVhNVNQRE9YQk1LRXFhdFJOV0ZPVTdGblNS?=
 =?utf-8?B?SXRaUlNiQnRZZHoxMWFZMmZPaVlOWVhKYU1sKyszdExhek1YM21QTFB4Rmtm?=
 =?utf-8?B?VUhENGtmS0hNR3NYV3o4eERlUHdLY3d2TlBINXJVZmVwZEFTM3dEYnNnWWVJ?=
 =?utf-8?B?QzkvSEhEbFc4MGVMV2txeFpXMElSM29lMEdUb0RCdSs4NTAvTyswK045by9C?=
 =?utf-8?B?TjdPcVR1akh6emJoYjgyeHdia2lETTg3aXZzc2dTR0kzMWc2cVlWSWo4c1Iv?=
 =?utf-8?B?b3czRlNuRXVlaVlwd2Ztb0Z5dzRmYmo5WEdIMWJaYy84Nmt0Sm1XelA3cEdP?=
 =?utf-8?B?K1MyU2VqSzcvY3JIbktrYm9VSEJHdkhkUk1pKzlmK0lWT0R3K3dIM2lDWk9s?=
 =?utf-8?B?Y3ZmWTV2ZUgvYyt5cWN3R1JrQTA3cFBJN1dRU1g3Z3pOb1gzeHNDMWQyMDdD?=
 =?utf-8?B?WWV2c25YSzZLN2JtVVhEVDVoZExyV1puMC9EcnpML3lYZ3VSQ2VLY09la056?=
 =?utf-8?B?Q0c4NFZPVkJ6cU04ZXd2NXJJWk1hRWpMS3FOQXU5WlBGTFk1RjRrT0ovWTVS?=
 =?utf-8?B?QzFDdE9Rd0k0Kzl5R1BvQ3UwQy8rODRWM0g3NDZCcElCRkFKbi9QaTFyRmcy?=
 =?utf-8?B?dzRHMVRsV3dRTDRWTmovVjQzVU8zMEVIYTRNd1ZLMmdKbDJQZis3d2hHaG5y?=
 =?utf-8?B?VmlZQWxaNUt0aGRuME1DVXN6ZFVjcEFPSTk2SVQ2a0RQTXNFanVLajNHQVRN?=
 =?utf-8?B?VDAxN0c0SVEwOWVxeGtBc3VRZVdnZTYxNGVlUnVxeG4xYUdtRTBsV0ZzYWdw?=
 =?utf-8?B?WWExRDlzYVZMV2kxbWV4SjVUdHR0MWdQV1lSR01IOGdiTnYvS2xDVWFOSUVa?=
 =?utf-8?B?MW5kY2RPQTBDSlN4cDFyeGg3Sk9TNXRlYW9vME53eVJJUW9BRnNMYUxkMFBs?=
 =?utf-8?B?K0M5bHkzUzAzeUlPYkxoVkxlUmxkYkQ3WURMVjhIQzhUSVpEQXZVYzUyNXpP?=
 =?utf-8?B?UWxxOTFzRnZkNlU3SzNDZmpNdC9CYTNaQU5pdHB4WjgzcmUrbGpYK3BLR2d1?=
 =?utf-8?B?emJaa24wWGNyZkdsb1Z6OTRNd3JFQXQzRDhicE54RXJHWmZ5NmVXeCtsYThG?=
 =?utf-8?B?ZFQ5K1RxSy85NkdoU050NWQ5UVRIMTdHV3FLM1NyUExhOWxnUmFyQm43bFRk?=
 =?utf-8?B?bzg2VjJjM212djlJcG5jVitQa1JlbTVkRHU2SUVGc3Y0ZW5uc0tsZ0VlZ0pW?=
 =?utf-8?B?VlJLZXorZGthaWpJVXJkbHhLTForVU13RWVtNDlJZkJPUW9CR25qUUhhWlk2?=
 =?utf-8?B?RHZTM1M3dHVONml3b1FOQys1eUVVNnlJVTI4cXFocGJpTys2TmJwekg4b1hq?=
 =?utf-8?B?Zmg2dz09?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SUkvSnh6czNkQ1FzejNFZXh4R3dqTzZpdFRwOGg3T1JPZnduU0lGMHRpRzFR?=
 =?utf-8?B?Uk03RnRQcVd1ZWxZRVBaN2JJaXNOSWdXM0ZMTHNuSWpQUEt4UWhxVTBJaFRX?=
 =?utf-8?B?RmlCeFAzcnBzdE0vcTExRkRZY2YxTVpiMlVVSGJNS0xhblMvSyt6ejFLVEgy?=
 =?utf-8?B?dlBWaDVEREsybmxITzNmZjdPRGxNc0dEYjIxMndGY3F4aDl2TmM3S1dTZ1pI?=
 =?utf-8?B?UXU5ZHZRZmZGaGtiRWtSUUR1ekMybkpoM0psWUt1c2JJYUpzRnJwcXR3WVRN?=
 =?utf-8?B?dEViWlIvNGhoTUFzemlPb1RUQ2VBM0lXaDNra0FUUXlxODA0VE45T0lkSVpY?=
 =?utf-8?B?ZjRKMUdsTnpPMGpTR2FGVyszQldIeURodWQ2MmdCOHhDNHBYS0JDSUxINnMr?=
 =?utf-8?B?UEZKUnNrZEtFeENpUFNnQS9IT2d3TkhwcVlNNVQyQWhqaUxsTWI4N2ZkbkZz?=
 =?utf-8?B?S05mWlVreTV5SHZLNGVMSDdFMDI1V0N5MlRKOXBFaTdXVmdraXppQm8vTk03?=
 =?utf-8?B?N2hocW5Sb2ZSaVVjczhtSEdqNmRpS0hDZFBKZ2tJRWNtMGxpK2FOYnkvalpX?=
 =?utf-8?B?M25FQ2YxNUxHeXQ3VWVGRHdiSHlEc2hzQmJCa1BOS29TdkkxUllVRml6U0hJ?=
 =?utf-8?B?YklUYTY2dzR4STVUUlBHYW9zVG1XM1U5cmxXaERQMTNOdHdUT2FCcmU0UTI3?=
 =?utf-8?B?TnBxWUJqR2QxeUZjQ1hiVDhWYzNPNlZ3dWNub1BCeGxtK09sRDlCMXN0V2l0?=
 =?utf-8?B?YTU0OEhHdVoxTVNDcXlaR3FzbXlUL0dZQW4yV09NOGxxNDJVbEdCa01yeXlT?=
 =?utf-8?B?SUJiTG9XY2huUUlWckJHK1lwalMwcFhWeTBsZWs5bE9FWlZNVExQL3A1TytB?=
 =?utf-8?B?YzBRaDNyVHZObXh1aEhiZTBsZXRFVEFqT0RPbmxROHp6ZnZmcXRtcmYvalQz?=
 =?utf-8?B?dUNtdjVMOGtNbVNHUkt1L0MrR2lXM3FPcVRWa0JZeE04SzJURFA2dnZEa3Ev?=
 =?utf-8?B?SFg0ZmJXZmM2b2dOK1FtSWR1Y1NSVkJ5ckIrTm44dVE2UE15VUJoRnJ4Nm1M?=
 =?utf-8?B?aUNUSUxQTWgxcnlQRlB3ZjNVQ012Z3pESTkvRVlnVmVVSE1pYnhNUUhRMjNu?=
 =?utf-8?B?R0V0Q3YvL2ptSzFqT1pwazBETmJJT2xMVEdvaDdjQmpiam1RT0Z0eW50Sllj?=
 =?utf-8?B?Z2Z1ZURlTW9RQUE4Z2Z5V0wwNHVJaTM5enBvSm93S2JVYnRrTkpISUJweDRq?=
 =?utf-8?B?eWZnNkE2WXBvRXlyTkV5cHg2RmtsU1R4TmNMQTZpZzhLaEZPcVZYWE15VFdh?=
 =?utf-8?B?bnZlYTBybWNwQ0xmTGZrR3I5NUpRbDhMbmdkbk9yMG5ER1BtU1Y5UWhQU3BB?=
 =?utf-8?B?WkNhQlYwWjZIRmpLbERsQWZ2NFZtVzdFYUpZUjNKUFJROHlMdXFXcmJqV3VU?=
 =?utf-8?B?Y212RDVzR3hGVTZ2WUxkMzgreUF3Q0M5WjBPR2lCT0dpQTdOdkhqL255cGpk?=
 =?utf-8?B?NTl1dzhibjZEalltNHlGcGlEU2t4UXZtaFJkaytPQmNleGxLMDFPYnlGSGVB?=
 =?utf-8?B?UFlkYktwTTJHdlVzdWl6S2R1dEVPQVR6Wnkva2RsUkJtNHErN0lNcGhvb2lF?=
 =?utf-8?B?cVl6bCtuQnZSLzB1Nkg0V1Zta203QWRyN3E2M3E0alppQnM5M1ozV3FaRHMx?=
 =?utf-8?B?SFR4bnVMTVh2TGJDcHpxL2RWN1dsU2U5OHZIT3dKS3M1M1VudWprb2dIRnlD?=
 =?utf-8?B?NFByV29RQWViU01pUmZQMnNva3MrbFQxeVY3cXdJTTRsT2RrSU9aUXA1KzBQ?=
 =?utf-8?B?dmMwVE03YjRiN0ZQQkdvNlQ0eVRRZHpyOU51NzA1cU1qTi9MWlZVQkg2bmww?=
 =?utf-8?Q?pkpqpHrEOL7HG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b4dffb-be3c-4d97-2a42-08df3121ea23
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 16:23:04.1734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR05MB10120

c2NzaV9ic2dfc2dfaW9fZm4oKSBpZ25vcmVzIHRoZSByZXN1bHQgb2YgYmxrX3JxX3VubWFwX3Vz
ZXIoKS4gRm9yIGEKZGF0YS1pbiBjb21tYW5kIHRoYXQgdXNlcyBhIGJvdW5jZSBidWZmZXIsIHVu
bWFwcGluZyBjb3BpZXMgdGhlIGNvbXBsZXRlZApkYXRhIHRvIHVzZXJzcGFjZS4gSWYgdGhhdCBj
b3B5IGZhaWxzLCBTR19JTyBjYW4gcmVwb3J0IHN1Y2Nlc3MgZGVzcGl0ZQp0aGUgY29weWJhY2sg
ZmFpbHVyZS4KCkNhcHR1cmUgdGhlIHVubWFwIHN0YXR1cy4gUHJlc2VydmUgYW4gZWFybGllciBz
ZW5zZS1idWZmZXIgY29weSBlcnJvciBhbmQKb3RoZXJ3aXNlIHJldHVybiB0aGUgZGF0YSBjb3B5
YmFjayBlcnJvci4gVGhpcyBtYXRjaGVzIHRoZSBlcnJvcgpwcmVjZWRlbmNlIHVzZWQgYnkgc2Nz
aV9jb21wbGV0ZV9zZ2hkcl9ycSgpLgoKT24geDg2XzY0LCBhIHZpcnRpby1zY3NpIElOUVVJUlkg
d2l0aCBhbiB1bmFsaWduZWQgUFJPVF9OT05FIGRlc3RpbmF0aW9uCm1hZGUgaW9jdGwoKSByZXR1
cm4gMCBpbiAyMC8yMCBydW5zIGJlZm9yZSB0aGlzIGNoYW5nZSBhbmQgcmV0dXJuIC0xIHdpdGgK
ZXJybm8gRUZBVUxUIGluIDIwLzIwIHJ1bnMgYWZ0ZXJ3YXJkLiBXcml0YWJsZSBjb250cm9scyBz
dWNjZWVkZWQgaW4KMjAvMjAgcnVucyBvbiBib3RoIGtlcm5lbHMuCgpGaXhlczogMTBlODg1NWI5
NDUxICgiYnNnOiBhZGQgU0dfSU8gdG8gU0cgdjQiKQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
ZwpTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHgtcHJvZmVzc29yQG91dGxvb2suY29tPgot
LS0KIGRyaXZlcnMvc2NzaS9zY3NpX2JzZy5jIHwgNiArKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L3Njc2lfYnNnLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9ic2cuYwppbmRleCA1ZWVjMjQ4YTc3YTZi
Li4zNzM5M2E4ZGVkZDg0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9ic2cuYworKysg
Yi9kcml2ZXJzL3Njc2kvc2NzaV9ic2cuYwpAQCAtMTk5LDcgKzE5OSw3IEBAIHN0YXRpYyBpbnQg
c2NzaV9ic2dfc2dfaW9fZm4oc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBzZ19pb192
NCAqaGRyLAogCXN0cnVjdCBzY3NpX2NtbmQgKnNjbWQ7CiAJc3RydWN0IHJlcXVlc3QgKnJxOwog
CXN0cnVjdCBiaW8gKmJpbzsKLQlpbnQgcmV0OworCWludCByZXQsIHVubWFwX3JldDsKIAogCWlm
IChoZHItPnByb3RvY29sICE9IEJTR19QUk9UT0NPTF9TQ1NJICB8fAogCSAgICBoZHItPnN1YnBy
b3RvY29sICE9IEJTR19TVUJfUFJPVE9DT0xfU0NTSV9DTUQpCkBAIC0yNzMsNyArMjczLDkgQEAg
c3RhdGljIGludCBzY3NpX2JzZ19zZ19pb19mbihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3Ry
dWN0IHNnX2lvX3Y0ICpoZHIsCiAJZWxzZQogCQloZHItPmRvdXRfcmVzaWQgPSBzY21kLT5yZXNp
ZF9sZW47CiAKLQlibGtfcnFfdW5tYXBfdXNlcihiaW8pOworCXVubWFwX3JldCA9IGJsa19ycV91
bm1hcF91c2VyKGJpbyk7CisJaWYgKCFyZXQpCisJCXJldCA9IHVubWFwX3JldDsKIAogb3V0X3B1
dF9yZXF1ZXN0OgogCWJsa19tcV9mcmVlX3JlcXVlc3QocnEpOwotLSAKMi40My4wCgo=
