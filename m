Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792655537;
	b=gfui1o1us44bQ6tLKOnRAqdOpWs10a3zuUHOZIeRUlKjcRxbQIVGebY1shEQGJcVY8KW
	 XqW4W8BWSbW1ntIBuT5hZ1CGUXD3pKjxArCpaDcHtExkxK552gVrEv2hsgr3UCDXyzVp8
	 y1o27EMeJFiDAkAL5w4CWKixJSnAJhwMAMEcEppQoB/aDce1Uf08SraoCk0iW3HRoXuNE
	 KN4dp8fORN7zABXi0mlYuJzL6aSR3gr4CJuHSGI39uQkBwtwlEH+fMLR+GCH+RBx6PS8G
	 fVdVqccBDh35Oln/wv0X8d5zENyXuD9GomKg83wtY1xbgA10urugNQAgb43g8HSCc8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655537;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=XUawe5AuYGVXNvZeQjLIQKZ1QZnokLmZKOx2Kwovvm4=;
	b=O88mA+Vaqs0ZVd0uiAeIhO8pjfYttgqBTzHEG5STPb9gV7238eTrqN2Q9NRVDPrlZCRu
	 w0rbYYaYaiUfNcEjIifFiPnrtHczLaAQmcsfeeGab1fTxWgM6OiAsae8VfBVoq8/BrWO8
	 u38jEVsUlQyW2X/LYtWemEiczBgYWXOSBW940iNckjy7kEComqBcptGzIwoN7U7/+r7kF
	 f8ltAPdamCiwYAF+t9+AfvPbSKQnPjCLL4ItA0FUXOGJBBpQVFXScjarNrMbnjClS9jR1
	 M4C3+GlgnD8JiSSk9D7WNitxzNKem/n8XvkWyOt3ALr3rfmtUjHUMLFihECzKc2ca/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=nO1Yualf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.31
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azolkn19011031.outbound.protection.outlook.com [52.103.12.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B848606A31A;
	Thu, 22 Oct 2026 07:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B848606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=nO1Yualf
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AzPSa7MdewahBPJgb/XQ8tgt0iWgvPkVM/w0YhW++5PsQzkr6MZ9TA7H15Ho2k/Zb3Gg+ePyetV4TIhVVUkRmSD28bRhIeHgNBFwOuLFUZwwN2NDx8tLIJH1DwgDxV41hreCJ6KrdVd5y/HDM2l24QRamuWC91C9MhweLvfRcbuzdbux5NHCb0otl3qO6Fht7tGkXrD2Ms74Nxk9+srORW5pOXjJlZ6H9bhfu2jodWKc8IyVyne/Q4uvgQ3SKBxQ5aKM5OBa5a7K+e6cWlNkYaxMqqAmvyoTBNqMAtdaWrMeNlRtxpXysyMuZ8cwDc3ugQEJH28fFV6qrDRv9Xms9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=XUawe5AuYGVXNvZeQjLIQKZ1QZnokLmZKOx2Kwovvm4=;
 b=sHW5mX85U1FO9r3LAbsnrdbmw1pPQdHGBl1bmUPnVW+0uLjIvwE2rtWb36vkmSCVm6tWy4QmBsvjkoaA5DTnNA/D2DXiXZEEfUC0kc3bhF+YAzLAfYqhvp4W+zXmQyFkIWTaF6ZJ/XFy4CQjxFXrPUn6Cm0bRfOfZ85/dY8u3/2o5baSeB+KCisl0twg49vLNdZzcSywogb8yKdLmEoJnxVrNNyKNXGfCMWg4hLgKI2i106rwiEvicrbd22RlOM12W9at+Ote4MYBwCeEXACTDpBBzyVs6RtIQ1S3HK670tGkrgHSahcFyKYX7w1fMUEAg6gbgEwyDDITVTxZEc53A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUawe5AuYGVXNvZeQjLIQKZ1QZnokLmZKOx2Kwovvm4=;
 b=nO1Yualf0ecJ9HV/hiCB/Yygen/iKny5SebSbfan5b9eymTEtX3IzWco7fe/baYp/z3KQXYtLZOymnLH34OjDkXVTxDC+1+EChOSqrt1/VNx5x7SNvRgH1rh0V4FgxKrtVVwtWTuCWmKtJynG98Cpg8kjCLpcOylHjkkj1hqMeScA24h28nMyCYjIaHyG5oXIWxdzVOACYKRtsY/nlmj294HL2x0EecBUpOub3m6FD7OYtJGDLyDaMbMhsd2DvAFCs5kcCCxgMVJP/prASluTT0xmdGAUZOHJgviS9YjkqaVL/Gi/Uo7Zr6NnGSfj/ax7OsJHj+/R4RxlnIlxoH3SQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA1PR05MB8014.namprd05.prod.outlook.com
 (2603:10b6:806:1a3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Thu, 22 Oct
 2026 07:52:14 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 07:52:14 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
Thread-Topic: [PATCH 0/6] scsi: make SG_IO user copyback failure-safe
Thread-Index: AQHdXxcV4d7XNHMimUKXaFSWzkcXt7cDgMwAgADoMYCAAPWbAIAD17mA
Date: Thu, 22 Oct 2026 07:52:14 +0000
Message-ID: <20261022.scsi-copyback-review.31b8d6a70f4c@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
 <cc4cb53d-51e4-472c-8e4f-6243100198d2@acm.org>
 <20261019.scsi-copyback.9d2bf936038d@outlook.com>
 <7a2dfdd0-812c-470a-9b31-402dc601f05c@acm.org>
In-Reply-To: <7a2dfdd0-812c-470a-9b31-402dc601f05c@acm.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA1PR05MB8014:EE_
x-ms-office365-filtering-correlation-id: 38b37f83-c9c8-4bc8-c9cf-08df3011633c
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|15080799012|41001999006|39105399006|24121999003|19110799012|8062599012|12121999013|31061999003|22121099003|8060799015|22091999003|25010399006|24021099003|4140399003|102099032|3412199025|440099028|12091999003|26121999007|40105399003;
x-microsoft-antispam-message-info:
 =?utf-8?B?T1JvZFZQTXZ2T1Fkb1J3UjlNK1BxZ0NYNE03NVl0bi9qTExiaWtwc205bkRo?=
 =?utf-8?B?c1ZtRUdwMkNKTFhnYWtmNTJiclFJYis5Nm9oM2FqNy9ZZnpLUnh6OHNYcjFH?=
 =?utf-8?B?RkpKc042Q09ZVCtKZU5iMndpbm81WDY5QUpMSis3VUMwcUhadytEMjdMRjRL?=
 =?utf-8?B?Nmxob0k5WnhiS2R0RWg3UFJheE4rdnZhNDhQazNPMXpSTEdaeUg0cmppSHpD?=
 =?utf-8?B?UVU0YVF2K1J0VnhBU0k4a0xyZm12aEZidjRDQXViaGlqaklhcDdlTlhQTWhO?=
 =?utf-8?B?UHh1WFQwcUUvUWtYRzViZ0taeGN1alhqMjZvcm1zaWp2NUFYb3VOM0Zwb25K?=
 =?utf-8?B?emhKWlNWdlVPUnl5elFmSXVNZ05QNXBxd3JWSHErMDM0NXp1alR1VFM5M2NE?=
 =?utf-8?B?UmpreUVYTitmRmlmNlEyQk4rNFRrYzRibjRreExVYVkrcFhHd1NZZ0ROaGE3?=
 =?utf-8?B?ZklXK0hjbXZPRXdqMFJUSVJ3cDFBRFA1S2s4SCtpcmZtZUJKT2JCaW1NWUpy?=
 =?utf-8?B?a1lidEszLyswM00vNUZ1bzVTTW9heWVoejNsZExQamNSSG0rZUVlczdKby8v?=
 =?utf-8?B?ZDJOc1IzTUxJMUY4U3RVOUVkcEs2ZWt2WEVNSjdDYmFwTkRHVUluOWxwdXNS?=
 =?utf-8?B?KzNFZmxYcjhIckhXMm9Id241d1M1SjNCaXNSNjVEc0xRVHluYVhYZFEwYjZv?=
 =?utf-8?B?ZHpqT2RQaEIzWmN5Z01RSDAwMXJFdWNPZ0Q0YStqeHFneFhEMWtoV2dmT2JB?=
 =?utf-8?B?aWpGWEQyUlV2OXRaek93eVBxZm1QNVhmV2JCU2FpanNJdUxuUFMrQVR1ZEU0?=
 =?utf-8?B?UDh1dHVtdVpRZEpYVm1UMTVxWjVNT3c3SDh2N2QyQlZtSktkeFhON2RlcmJV?=
 =?utf-8?B?RzQ3K0pMMGsrblQ5Vy9rdmF2MHRrdGljbWxVbDNoNW9mVVNZUGhLSTFkN3dm?=
 =?utf-8?B?SUsrWXpDdHJ5dFFEdjVIcEp2WE03TWZHaDBFMWF0WmRtY2V3SmdYR2EzWnpk?=
 =?utf-8?B?NDlsc29OblBpTnZKMlNhTm1sMktJL0g1YUFVUURCeVlNbzUrTUx4cUU0OHdt?=
 =?utf-8?B?Yzl5dGN1a3JRL1BPd3pmR0QyMi9XQ1c1QzM2M0dLSlhZV2Nyek0vTVF4NTJl?=
 =?utf-8?B?ZUI2UXBPNkw0aEk1MitkNWFBOGpSVDhqcVM2T3V3czY5TGozcTFzYk13Y0pa?=
 =?utf-8?B?ZEphV3dJTHJnS25HZW0yYjJPL25KQmMzRTh4bGlNQ0FnTVZkUFg2RGw5eU1m?=
 =?utf-8?B?aWg2U2NyY2ZEME9lWWUxWlJ0NCtQYjZtWXRXUGJ6N3ZHaXFiUzhPK1g0TVd0?=
 =?utf-8?B?dkdhR3FoclVkVmhnNFc1UVh0ZmxpTVJadHM5QjVyT2J5OERtb0w5NDI2SlRS?=
 =?utf-8?B?Wk9DRFRLaysxTnJtejRQVy9PQXdkb25BVmpsdEhoVFovL2poRlpuZDdXSjhR?=
 =?utf-8?B?VFVwS1BadWVOV01Hai9SNENHRFJhalZrR3Y5VWdsKy93VEpTKzhnTFF6R1A1?=
 =?utf-8?B?YXNuSDZXeUdYNGxjT205eWpNRXh0NFFqNGxFdlNwZXBBM2diSXFsNzRqMHNn?=
 =?utf-8?Q?P9ertfahUrVbS7lpncpjWQxH4g/iRTmfBPupTF1RwMNoKi?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z05ZSGdqbDdLeXNXWVpNT0R6dTNvRFZHdXUyandpYlFycUl1M3YvNnYweVFJ?=
 =?utf-8?B?eGIya2hhUXdPak5QOEhPWllSU2F4dk1FYXljOGJ3RW55cjllUFlONTJFTkpU?=
 =?utf-8?B?RE5CVVozZ3lHM0VreUhIQjhQdWc2cHpQRmEvL3U2TmZVYkJ3NVVtWEplc3hG?=
 =?utf-8?B?OGFXdWNSeHlMY1RjR1JTOCthTzF0YTNmeUxaK0ZjR2t6UFVmNVhqMkdjYVg5?=
 =?utf-8?B?OUdyWlBQMGowM01JUm1VYXIwQ25Ga01LU0M3ZUMxNU1RQUFkOWZUNlRhSXdW?=
 =?utf-8?B?dzY3ZG1qWUpjTTlFRWhaOVNMU2x3ZkhqNWQ0bUZlZnVaZVo5QkdHRElkR2t6?=
 =?utf-8?B?bjU0dm4rcmlpOUE5elVvZnR2czVucngvZDNsN0NpSENTSkFEVWJtS1p4UXRk?=
 =?utf-8?B?UmJxMGt1RXJseWNYdDRYbmxRcDg0T0tFblJIb2JJUE1CUDBINjNoay9HK0FI?=
 =?utf-8?B?QXQ4K05Rakh1Zkcva1NtVmhUdFBweFBTYmxrNllNbS85SU5mODNoMmJhdXht?=
 =?utf-8?B?ZVk2ZEVHQncvbkVTK0NneDZDV25oRmdTQnMvQmV4VWhsQUpkaWhJR1JpZ2Jn?=
 =?utf-8?B?K2NHd2hCa0k4c3NKcXpDNXB2WG1nTUJiZFlveVhkcStMWnJDZnl6bkx6RFVy?=
 =?utf-8?B?YTlRWjh1cE4rYTVib2xXaW1PcVB2T2VXdUtlOFp2bjZUWGJWSi9vMU1Sd2x5?=
 =?utf-8?B?YlYwd2JHS3R0c3ozV3NvSWZlZVEzekw3UUxRcjNLL1ZaWERjL0YvV3Z6TFc1?=
 =?utf-8?B?M2ZVYncrNTdRSW10NjRuYzI2eDZSVmZqeW1JM0pZUjQ3RzV3NFNSZnJVcFZB?=
 =?utf-8?B?MTQ2VGlhTms4ZWtiSmZIdnlHQkQ4M2FOTXgzd3lleFA0cTRUMzR1RE1SaDhN?=
 =?utf-8?B?a1hKdjRZZ0x5UWMzekh3REhEK0xiTWxJd2xXRGdVVmx6c0wvd0RsTnFPOVRq?=
 =?utf-8?B?OHNvekVtWll1UzJhaitiV3prbjJ2STlWS3M2Vk1mR3RLSFgrV3M4VksxM1Yz?=
 =?utf-8?B?ZExzK0VNRURqS0RrSmZwUE9VS3dJc1IvQy9rRWVoa1NkZzFyZm43MVJyN1h5?=
 =?utf-8?B?WGt0L0FjZDgveGZpZk5la1o0VFN2NW5nazU0SWxqUHBMYWFtME8zUmdVTWNz?=
 =?utf-8?B?VTYydE5IVFA0NkpmY3A0eitxd3VrR0Uzdm5rUWtaTzV3T2xTUFl0S3JiVHht?=
 =?utf-8?B?TS9WRVRtcEtsd21GeFZjMmo4WVBkMzVEdHVTQjNqNUtkRFdBYjRnYUpKVkVx?=
 =?utf-8?B?MmlrTXJjZUJHV1cxaVI0UmROdWhKRzdyeWQ1Vjd1SXVSTmFpcmJnTGp6SWJk?=
 =?utf-8?B?WlhMYmU4cjVnd3N1V1VLbFVmNTZZWDVSbG9pVE80L0NTUmN5RE53MWk5S1h5?=
 =?utf-8?B?ZURmeHVtVnVONC9RS2ZjWGtBSXByb0JzeFNEZGpia3RJU0tNcEg5em1ZMEl1?=
 =?utf-8?B?VkVUbkF2OGErWEFBYzFOU3pvYm40S2paK1YyS1JKREN4dTNtMU9tUFVNV2pQ?=
 =?utf-8?B?YzlNSm9MZ3NpSjJOVmV5eHNGbWxrRnVZZjcyR3UxSjNBWURxeHJ4RFpLVCsw?=
 =?utf-8?B?MFhXbWRnMGR0bHFPaGZHcDRsVndKRjVlVzREaS94OHFRbFlrY1ZlemYxWHph?=
 =?utf-8?B?RXgvdkd2QmYrZ0EvOUZrOTN0UlRtT00rRk16dFhVSXAzWUFSN2lsenBYUG01?=
 =?utf-8?B?REsxbXBzcm8vZU5NMUtUQW1OMFB4dlA0ZCttQm9acHdWcXNDL2FHNG1vWUhk?=
 =?utf-8?B?MjRWdmFib3Jkby9vNlEzNjJVdjR1Zi9ZaU1PUjNYbWJNN1Yva0JyQ2NnTkdZ?=
 =?utf-8?B?c2lWOHp3bG1kV3Z5c2R0VmU2OE9GK2xsZGhnRjNIbjVHRmZXQjNOSGppVUFC?=
 =?utf-8?Q?Ai63905eBnAsQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB531A2B629D5A45BE77CDC1B54BD997@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b37f83-c9c8-4bc8-c9cf-08df3011633c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 07:52:14.7218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8014

SGkgQmFydCwKClRoYW5rcyBmb3IgdGhlIGRldGFpbGVkIHJldmlldy4gSSBjaGVja2VkIHRoZSBy
ZWxldmFudCBwYXRocyBhZ2FpbnN0CnRoZSBzZXJpZXMgYmFzZSwgMGZjYjA1YjcyMzQ0LgoKWW91
J3JlIHJpZ2h0IGFib3V0IHRoZSByZXF1ZXN0L3RhZy1yZXRlbnRpb24gd2luZG93IGluIHBhdGNo
IDUvNi4gSXQKc3RpbGwgcmV0dXJucyBSUV9FTkRfSU9fTk9ORSwgc28gbW92aW5nIGJsa19tcV9m
cmVlX3JlcXVlc3QoKSB0byB0aGUKYmVnaW5uaW5nIG9mIHRhc2sgd29yayBkb2VzIG5vdCBhZGRy
ZXNzIHRoZSB3aW5kb3cgYmVmb3JlIHRhc2sgd29yawpydW5zLgoKRm9yIHRoZSByZXJvbGwsIEkg
cGxhbiB0byBwcmVhbGxvY2F0ZSB0aGUgcmVxdWlyZWQgc2Vuc2Ugc3RvcmFnZSBhdApzdWJtaXNz
aW9uIGFuZCBzYXZlIHRoZSByZXF1ZXN0LWJhY2tlZCBjb21wbGV0aW9uIHN0YXRlIGluCnNjc2lf
YnNnX3VyaW5nX2NtZF9kb25lKCkuIFRoaXMgd291bGQgbGV0IGVuZC1JL08gcmV0dXJuClJRX0VO
RF9JT19GUkVFLCB3aGlsZSB0YXNrIHdvcmsgaGFuZGxlcyB0aGUgdW5tYXAsIHVzZXIgY29waWVz
IGFuZCBDUUUKY29tcGxldGlvbiB3aXRob3V0IGFjY2Vzc2luZyBycSBvciBzY21kLiBJJ2xsIGNo
ZWNrIHRoZSBhbGxvY2F0aW9uIGFuZApjbGVhbnVwIHBhdGhzLCBpbmNsdWRpbmcgbm9uYmxvY2tp
bmcgc3VibWlzc2lvbiwgYW5kIHJldGVzdCB3aXRoCklPUklOR19TRVRVUF9ERUZFUl9UQVNLUlVO
LgoKVGhlIHRhZy9mYXVsdCBkZXBlbmRlbmN5IGl0c2VsZiBpcyBub3QgbGltaXRlZCB0byBhIG9u
ZS10YWcgcXVldWU7IGl0CmNhbiBhbHNvIGFyaXNlIGlmIGNvbXBsZXRlZCByZXF1ZXN0cyByZXRh
aW4gYWxsIHRhZ3MgYXZhaWxhYmxlIHRvIHRoZQpuZXN0ZWQgZmF1bHQgSS9PLiBTbyBmYXIsIGhv
d2V2ZXIsIEkgaGF2ZSBvbmx5IHJlcHJvZHVjZWQgdGhlIG9uZS10YWcKY2FzZSBhdCBydW50aW1l
LiBJJ2xsIG1ha2UgdGhhdCBkaXN0aW5jdGlvbiBleHBsaWNpdCBpbiB0aGUgY292ZXIKbGV0dGVy
LgoKRm9yIHRoZSBzZW5zZSBkYXRhLCBJJ2xsIGJvdW5kIHRoZSBzbmFwc2hvdCBieSBpdHMgc3Rv
cmFnZSBzaXplIGV2ZW4KdGhvdWdoIHZhbGlkLXNlbnNlIHByb2Nlc3NpbmcgaW4gdGhlIG1pZGxh
eWVyIGNhcHMgdGhlIGNvbXB1dGVkIGxlbmd0aC4KVGhlIGV4aXN0aW5nIHNlbnNlX2xlbl93ciBi
ZWhhdmlvciBvbiBjb3B5IGZhaWx1cmUgcHJlZGF0ZXMgdGhpcwpzZXJpZXMsIHNvIHRoYXQgc2hv
dWxkIGJlIGEgc2VwYXJhdGUgZml4LgoKSSBhbHNvIGZvdW5kIHRoZSBzYW1lIGNvcHktYmVmb3Jl
LWZyZWUgb3JkZXJpbmcgaW4gc2dfc2NzaV9pb2N0bCgpIGFuZAp3aWxsIHZhbGlkYXRlIHRoYXQg
cGF0aCBhcyBwYXJ0IG9mIHRoZSBsaWZldGltZSByZXJvbGwuCmJzZ190cmFuc3BvcnRfc2dfaW9f
Zm4oKSB1c2VzIGEgc2VwYXJhdGUgdHJhbnNwb3J0IEJTRyBxdWV1ZSwgc28gSSBkbwpub3Qgd2Fu
dCB0byBjbGFpbSB0aGUgc2FtZSBkZW1vbnN0cmF0ZWQgZGVhZGxvY2sgdGhlcmUgd2l0aG91dCBh
CnNlcGFyYXRlIGF1ZGl0LgoKUGF0Y2hlcyA0LzYgYW5kIDYvNiBhcmUgaW5kZXBlbmRlbnQgY29w
eWJhY2stZXJyb3IgZml4ZXMuIEknbGwgc3BsaXQKdGhlbSBvdXQgc28gdGhleSBhcmUgbm90IGhl
bGQgdXAgYnkgdGhlIGxhcmdlciBsaWZldGltZSByZXdvcmsuIEkgYWxzbwpuZWVkIHRvIHJlY2hl
Y2sgdGhlIGxpZmVjeWNsZS1yZWxhdGVkIEZpeGVzIHRhZ3MgYWNyb3NzIHRoZSBlYXJsaWVyCmlt
cGxlbWVudGF0aW9ucyBhbmQgZmlsZSBtb3Zlcy4KClRoYW5rcywKWWluZ2ppZQo=
