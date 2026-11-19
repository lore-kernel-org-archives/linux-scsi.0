Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795101935;
	b=d1GdE081K6jEfAZKOXddqKw3sUmHApZoeOxclPwqyMl2IanIT3XKOVhs9GAW4reqUQu/
	 JA4nqjc7a+ybThed4l52gxeoqz3ii9dwwKQK3/UPtKjCO6q+Xudc7g85g9n3J1inwJequ
	 q3bO10QeEZj957jESsOw4cg0I9miQaXopiflXIW98gFjo3guj+F3o5xo9DVc62XlgA+dr
	 GV5H7ZGKctyX4q0P0pH+WWZckDEzd+79ahKjZLF8wLO84J2B7H0vpK/jETh21RyGi1RQD
	 z0bZoTloDresAr8RGsiuqErRbvw6/p8/oUZtRr4zVs2LRTu20892BDj5r9qm9bf1Sdw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795101935;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
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
	bh=5WgbvaZyOgEFAObRYYkjKslcnRu2MKxyP5fwQvIZeAs=;
	b=KLjx6J0eWq14DJ6SXPSxjBjmQuCKBpA6W6VTQQnWV39+MBciqKpr0onEjUyWGvUhvx43
	 fDHEVERvAjXEXTyofspcHIZjIE2/t/MubGZhWuul25frX9rA2sw/RceV4DbrwRGgTqZWa
	 A8KPGeukqXbOAt8xD27T1IyJPLtRvcRLGA3bBNdo/nk8AiIKK7fMP7meGeSFohs8A/oi4
	 wh7fWCKOPRq0tMwX5Q9XxzVuW1G5LJzROtyIoBLzfkghUd3thuB+X1ElpdyvZkvmfUj4s
	 aAo3OKAlgFV3VGLfvCI7XILDMIL1QeN+c85fMKc8fisJkUZfGnDRzaO6J5HAYG3iamA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=pEXrx8yW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.25
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010025.outbound.protection.outlook.com [52.103.23.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FECE606A32F;
	Thu, 19 Nov 2026 15:25:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FECE606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=pEXrx8yW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fKRymJMOqX0jlLKUg2wBfPn3GPbfJD/yFgi06mS8YQpBFmg6BWbDHCNYJFev8XH+CcQjyKo5MCSDWUZQj+JfRE1sOETn27x9uRPyTv+syl8bpLB2tGACEN3ejLXygjKQNuy2NMBlXmPUUG6h9uny2erLpxV2vAF2hWpPksJsEcf2ANBH9qI1xYObTPCuimzAGI5AB16EU9OBCNjzPAbk7NKvz07d9VA1ILJCBwoRbvMPbYfDh98jyQzdKLSxiiQKRhh2A6pI8ap5Q7AS9YOUap0Wj3bsd3NurffziIan/CsfPRRuPvokR2qDYVIthT+Tu3jVDhyXRH2RrD/FAwukQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=5WgbvaZyOgEFAObRYYkjKslcnRu2MKxyP5fwQvIZeAs=;
 b=fxOIPyQGNtZ0apwSJNp4Y6f7wAuTnREwEhgX6FH8G2VybcsqqQfmH2+rabGDs3+UYQALx0QMg7I2pDiAP3RzzDsGfdrIO33PqdHws7Fq/Tbz6eGm3Hda4HLQRYy/8/TWPo9fARJKrt/rjGW7b5wrEg3HuHvNFN9ONh324snO5TQVvLABffRPB2/YoH48Z9vBFShl6xKqOSKRuMIWwVjTBYfqJCkmEnJmlJ4/cWNxckV9WVC/wnAhdO3jsHyZvGo4NIf7ttQgPcRpsU0I+tbmEkgMUuw+0rlmorpTAgJSxLpMNA7SuobqYXQLR0yGXizwcgoGPrpEgzUekHdH/EQSJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WgbvaZyOgEFAObRYYkjKslcnRu2MKxyP5fwQvIZeAs=;
 b=pEXrx8yW6Xi37EP3df695JJ5MLtxhBIouBmimhNFkQpr0zMNoyGUiugvpOkkHVn21Hqf4xA5Jdu/NcT8sFF5WRS8jLTbv0TIkfuoePDW4j2xMMwl/HfSJEDjqjd1Of7T3PXAp1iaoKHTvaBQpgdK2/SnyKBXYoEknfeVrnNsT9pFhIctjaYs4Um1ao0IYHq4CAqmu84ie+r2qpv4GHM9DbmnW6/wOocuEtXY9t1mcgjDt/siCQOFqoS4ij3vx+6XLCLdYUaSQIRQ6Y3YTr1/nS6BOXUQwwysx/NvoNmJoKoCfdqSo0WtvzIC71xPigSJPcAelO8Gwx55HrlRS3nasg==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by DS4PR05MB998429.namprd05.prod.outlook.com (2603:10b6:8:326::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 15:25:32 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 15:25:32 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
CC: "Martin K. Petersen" <mkp@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, FUJITA Tomonori
	<fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, Bart Van
 Assche <bvanassche@acm.org>, "jthoughton@google.com" <jthoughton@google.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] scsi: bsg: release io_uring requests from end-I/O
Thread-Topic: [PATCH v4 0/2] scsi: bsg: release io_uring requests from end-I/O
Thread-Index: AQHdd3K1Y5LmvRxLyEKEoISNSoO9fLc0ujaAgADLT4A=
Date: Thu, 19 Nov 2026 15:25:32 +0000
Message-ID: <20261119152529.2431724-1-x-professor@outlook.com>
References: <cover.1795016239.git.x-professor@outlook.com>
 <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
In-Reply-To: <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|DS4PR05MB998429:EE_
x-ms-office365-filtering-correlation-id: 53b5ea1c-398b-44f3-ddeb-08df465159ed
x-ms-exchange-slblob-mailprops:
 ZILSnhm0P3mCYd7/icPJlj+s+m08RC6kLUL1TivRzPTXgz14yvNlsZ9Q7K+30OVjXZ8wXv6pCihhyeVt+1MlA5qPlAc8qdLbw+OfgWTR9ReXkFKpA4D5XELgNJj8UO69Ul53iUpqEPpgve9AVqZrJ5noUsAUHcjEhIYqH5leWvMqj6OGzxR8zbYH0qHFdyZTQO7NgBx+ZwbcPc2ietfS2hJt9wQTDWktWInhQhVcHtakkPGo6/6exZ4fTI9f9rPmnx/G8nnobHmGIPzTFJtnvmh2TUVQWa3iAa/a0ZBLU6w3NHF0mqmspVbAHN1rJNEtt+3upkFgRPZgYhWBmPqkmdS6dYrg88i5RaItGoE9oUpKOEv01uVUH0hYVUzmPg/5LpaAy9ZjDh2WdGmC2kTFnT6AxjG+0NJIMWUEpy3dd8MZW4Wp79eQrJveeb6qjtEcT9mBV6apYXaYJSPp63FroYDgoiMP5fQ/0IIUgM300EgJR7BlrddQbDQlH1YC6t2lcd9Fa1hIGwUsKx3aXkpqLG7EI0RO2Aw6BPih3qJfzbmAlN1g8jc/eQ4iz+gnrBm4vy+mm2B5gdcezKyUt1Ee1GM8FAXVNw1spWPeIURQyMSmmu3VFypxeTjWnMqV3zZ1ljwJ8b+44Yy+7cZhGmNkeeGq0lU4hPt8X4p2F4Hd9txBoCs2EcrbTuh12nrLazho0XD4eu7q0BjsJMPi3nlcHDf04Hfi3BD9Yugh2IPGXWBabI7xVgufeVv7iX1f0f62BrbDnGCogmhsSwLplWTCVpaUj11FrUaC
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|12121999013|4140399003|25010399006|38102599003|8060799015|15080799012|19110799012|8062599012|24121999003|22091999003|31061999003|12091999003|53005399003|40105399003|26121999007|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 =?utf-8?B?YVNRRTJ1aStrMlZKai9VNUsxdWVsMFNpdmJYelB2RU9DQTlXNHFqU2RJMVBO?=
 =?utf-8?B?MTZ0eTEwaFEveDJmMjM3aFFTREVOSnJyVlZUajRzZ2VzQ1pxdHJ0SDV3V0FM?=
 =?utf-8?B?QVIySVdXV2dCUDJWMEN3V21TcUtIWmg3dmxBZzk4VHppcmRwSDhPUHcranMr?=
 =?utf-8?B?aFh1QzZtc2l6T3VPNHdnbDFzRVluT1oxZzc2L1c0czNpdUJFUjlYL3Y4clR6?=
 =?utf-8?B?Mkh4dG9POERwekVnOXoxRklUcUpEbnk0cy9XaHZTbW51U2RIZnpzY2c1dzBq?=
 =?utf-8?B?cGE0SDdyKzBKUlhpM2wyaUR2OGREZHNiN3ZPTk9neWJ4cVJsNWtDQ1VNaGpt?=
 =?utf-8?B?d2xwa0x0VU5CblQ3RkFqTjY1alBMWXdZWmpSMkJ5SDJSaFppMDZDVlJiVWw2?=
 =?utf-8?B?YXhFVm1zeE1Cb3hnWGZNSzhKOWRzOXNhbFdMQUJGQ3FkTkRScEpWZlRZd056?=
 =?utf-8?B?WUdKNFExWjZmSUNqTGdvejNBZjJ4SXZ1ekFWR3Rrc3dmZzY4NUtXbEsxcmtO?=
 =?utf-8?B?TEc4eTI3WGRDNkp4alh1aGdEYU4ra2cySTZkZXIyVHh0UlUzV05zTXBMV25o?=
 =?utf-8?B?a0lKUXBmM3RwcUJlV0gyaUJmVHR6Q1lJRFoxZjV3YWZQekN1ZDh0MVB4RFMv?=
 =?utf-8?B?WWhIU3ZDbUdyS1B1TVpOUkNhU0dwTDJRY1R1NHArVXgyYnczWktoRklERjdn?=
 =?utf-8?B?bW1hSHhxVTd0MG0vU0huN3BIc2sydmt0MnFEbjhTb3JiQXlOYlBodmdmWmdn?=
 =?utf-8?B?VFZlTktmcDlLbVFOUDVHN1ptYWNObC95SWZDYVFrMlJJNVFXSGpyOExPWjlv?=
 =?utf-8?B?aHhWRXVWYlN3cEtnMjVlMW9qU3podnFaTHM4eUk1Q1J6R0hITjl1bWwzTEhW?=
 =?utf-8?B?L1BkTzl5MXRkM1JIWWpGeUtaYkkveDVEYzkwSFU2Tmp0SlMvU0ZGOU53N0lC?=
 =?utf-8?B?WjVNdFZGQjlxZzdDemF3eDREL0N6SW12azhkcWtYbzQrSm1CVU9FbVluYWp0?=
 =?utf-8?B?RENNdGV1NGV5VjFxWXBNTHpqNUhEOEhzdjd1bkExVUlnOXB2bXd0a1U4andX?=
 =?utf-8?B?VkdVaTlnMlFhei9LcXJGckhKZUdUTHh6bHc0ZG9UWFVybUlHcWtHbGpYaTly?=
 =?utf-8?B?NnNhNzJYay9wYmtFOXBaR29wbFVUYnFlQW81KzFpR0tDRlBvalJxeDR0WDM0?=
 =?utf-8?B?bGo2NHZER0gwZml6NmtJYXl0OU5EYkM0L3BTK3VtSHhTZG1FWjA3SnA1cjNn?=
 =?utf-8?B?SXpXSkJjck44WlNrdU4rVmthU0RTZ2RIYzZDNW1FOHBoLy85UUVSbFBuUVRU?=
 =?utf-8?B?T0I1ejFpRW92VFovYUEvbXRkQm54Vm5VREtUS1dvdGZmQUFvS2VkcWE1QzVl?=
 =?utf-8?B?aDhIUkRjQWdrRVBLZURaUG82ODN5cit4TVBUR1lUWXdGNmFySi9VY0UwdnQv?=
 =?utf-8?B?OHQ4S29peGg5aWwyR3BteVZuYzUrQjBaV0R6L2Y4L0w4S1dQWUJqZTFUK3cr?=
 =?utf-8?Q?8jnfjfnxVgPkrUXq5J5jh5GpnW8?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RXQyVXkrOEZ1RFhhNUlPbksxWDFzSlJhWWcvVFl3V1A2QWIxN29scnl6QnZk?=
 =?utf-8?B?N1RqVEIvdHhvcy81VC96YVE2aTJTVC9SQ05jUmFaT2U1ZEI2VElaOXl1Qy9j?=
 =?utf-8?B?aU9PakFxSTBYVWR0dDMwazJ0RlpzQjIvdFdmc2xMTWJ6SElEbFBMSDBSbGFG?=
 =?utf-8?B?WGtSNkdFTm9UcWRQdlNvVTVYeDFFQnNaaW9md0JmQTY0aSt0d0VmZ0hHRFhx?=
 =?utf-8?B?VFN4dEdiamNnZUFlZ1lXeE83YUxaV2hMbzB0V0VtczVxRHE0T3A2UitnN01m?=
 =?utf-8?B?UXVnVEpUTVhUUHBsa3I2UlVQL1FQVThyMjB5Wi9xUlNhSHM5TG1lNTlPMEtn?=
 =?utf-8?B?c2kzQkhYY0tuVGluZjUyNDZGMjlrTFRybEdkK2hvbGNkSGlqd2MxYjZYWmw0?=
 =?utf-8?B?SmFKeUZYc0tBeUhGVXhPVnJuZEdDWWlWZ1huTXFqMkM0QWViOW4zMy80MGph?=
 =?utf-8?B?bEozTEIvczRvM0FEZjBvYUx5TDVyaFcwYmlNNHgzRDFTYjFYWXBpVFV3UUlZ?=
 =?utf-8?B?L0JwS29VeldkZ2ZwNzdoM2FxVEROSTlFc3BsUTdRMmk3Y0pHWnRZMktvOHNE?=
 =?utf-8?B?ZGtwVk9uQ2FQZGxIVjZzZndWVzIzWGU2dGhlRWMrYStMRXBQYkhwNkdEbUlv?=
 =?utf-8?B?dENhdi9BZG1URkNER3lRcHAwZWlNWGZhc2lGSldHbDA2Sm1QNVRQazgvUmt1?=
 =?utf-8?B?T0YyMlpuMkVVaDVBbU9aVS9ZT2R1MGNLcnorVUNkSmszZDMxVFAvVVZMRU1Z?=
 =?utf-8?B?akRuM0ZYRU5qZWhmb2Vub2k4U2NkOUtXUHdzaGF1Y0llTXZoM0pldjZHWjZG?=
 =?utf-8?B?S0xpL1VxM25GYmlrbjJaQzIxYzR6VDRpSDFSM09CSkNreEgxK2JONWxQbWVl?=
 =?utf-8?B?U1p4NUMyc3hlTmtjUkVpenNBVGdxb1IvWlVhY2dzZ3kweXMwSVBvazlDQmUz?=
 =?utf-8?B?a0luRkZOa3VCK1dYeXRQRGhVRWdUa0NsRTI0Zk1STTBFTnc4S3l6TEk5SHRh?=
 =?utf-8?B?V3U4SFBCdzlLREJyNFVlbkhidWNJbyt4YUxDaEFVWjkzaGVmYjZzMHR4OW5s?=
 =?utf-8?B?Qjl5OWNSNEZpR1VKa0toQllNVjNvNnNsQUprbGthcERoTU9nOWh4OFJPajV2?=
 =?utf-8?B?UGFZY0ZXeTlPMjBMNHBUZ3phU3lIdjVKQ3ZPN3IxeDJNVHZtQkNzVDBJd1dp?=
 =?utf-8?B?eC9OdmFka3RBRUV4L2k1QVdSSEdZa3V5YjhBaEM5QVZ4MzZPcldkbnpWMVpJ?=
 =?utf-8?B?d1EwVkFkYjlTZ1JIUFVrNTZRVlFEU05SbWZzbzgwVFFCRVNpRDlYTmM2Q2t2?=
 =?utf-8?B?YmV2YzZHWHd5QmM2RmJIbis1WnFZd3hDQXRtaEF4RlNkWEpPZ0hLQWt0Tjln?=
 =?utf-8?B?dGVOK2ZLU1NLMkRDamZqZGxqZ3pFT0QzWkIvUE9nQVZlYjA2UnNtU0JOa1pH?=
 =?utf-8?B?NmlMaHVYMys5NFNpR1QwVG1oRForNGpDQTIzTHFVK0VJUDJkeVRhQ1J6VzA2?=
 =?utf-8?B?OGFPb1lYa0NrTWFYclZuZllVYVdCYVZBY1RoSjdFRHJtVElkWElRZ1N5eTZs?=
 =?utf-8?B?Zis0MU1lN2c0b1YrbXZWcEcxWkpNRE5CUHJpTUp5c0JZdGw5TCtrZjFvbjhz?=
 =?utf-8?B?cFZMK2sranZTUmZwUUx0Q0hPMHkxOUxqTlhqZE52cGdXUDBya2kyY0YrWjFM?=
 =?utf-8?B?Z0dScFVEZCtTWk42QXVsR2NFeFBjZ0d4NzBZWmloWWN2TEVLWTNUT1JaS0ls?=
 =?utf-8?B?NXNhZ3Z6TXVFcGhsZ0R4Z21xc2V3dlVSb3JPTVNZeFZVR1ppa3V0M1U1WERP?=
 =?utf-8?Q?efDfY+i6jtabsd3TkxVjLRtLB8No/NhJXSqM4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0432ABC8EE70E44843A49A9682AF607@namprd05.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB3281.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b5ea1c-398b-44f3-ddeb-08df465159ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 15:25:32.4927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR05MB998429

SGkgWWFuZywKClRoYW5rcyBmb3IgdGhlIHJldmlldywgYW5kIGZvciB3cml0aW5nIHRoZSBwYXRj
aGVzLiBUaGF0IG1ha2VzIHRoZQpjaGFuZ2VzIGVhc3kgdG8gZm9sbG93LgoKT24gVGh1LCBOb3Yg
MTksIDIwMjYsIFlhbmcgWGl1d2VpIHdyb3RlOgo+IDEpIFBlci1kZXZpY2UgcG9vbCBhdCBic2df
cmVnaXN0ZXJfcXVldWUoKSB3aGVuIHVyaW5nX2NtZF9mbiBpcyBzZXQsCj4gICAgZnJlZWQgd2l0
aCB0aGUgYnNnIGRldmljZS4gQXZvaWRzIG9wZW4oKSBjb3N0IGZvciBTR19JTy1vbmx5Cj4gICAg
b3BlbmVycyBhbmQgZHJvcHMgcHJpdmF0ZV9kYXRhICsgY29tcGxldGlvbl9idWZfc2l6ZS4gU2hh
cmVkCj4gICAgLUVBR0FJTiBsb29rcyBmaW5lIGhlcmU7IG9ubHkgcmVzcG9uc2UtYmVhcmluZyBj
bWRzIHRha2UgYSBzbG90LgoKVGhhdCB3b3JrcyBmb3IgbWUuIE9uZSBvcGVuZXIgY2FuIHN0aWxs
IHRha2UgYWxsIDY0IHNsb3RzLCBlLmcuIHdpdGgKQ0hFQ0sgQ09ORElUSU9OIGNvbXBsZXRpb25z
IG9uIGEgREVGRVJfVEFTS1JVTiByaW5nIHRoYXQgaXQgbmV2ZXIgcmVhcHMsCmFuZCB0aGVuIGV2
ZXJ5b25lIGVsc2UgZ2V0cyAtRUFHQUlOLiBCdXQgYnNnIG5vZGVzIGFyZSBub3JtYWxseSBvbmx5
CmFjY2Vzc2libGUgdG8gcHJpdmlsZWdlZCB1c2VycywgYW5kIGl0J3MgLUVBR0FJTiByYXRoZXIg
dGhhbiBhIGhhbmcsIHNvCkknZCByYXRoZXIgYWNjZXB0IHRoYXQgdGhhbiBhbGxvY2F0ZSBhIHBv
b2wgb24gZXZlcnkgb3Blbi4gSSdsbCBtZW50aW9uCml0IGluIHRoZSBjb21taXQgbWVzc2FnZS4K
Cj4gMikgZnJlZV90b3AgKyBzdGFjayBhbmQgY2hlY2tlZF9vdXQgb3ZlcmxhcC4gQSBiaXRtYXAg
YWxvbmUgaXMgZW5vdWdoCj4gICAgKGZpbmRfZmlyc3RfemVyb19iaXQgLyBfX3NldF9iaXQgLyBf
X3Rlc3RfYW5kX2NsZWFyX2JpdCkuIGRlcHRoIGNhbgo+ICAgIGp1c3QgYmUgQlNHX0RFRkFVTFRf
Q01EUy4KClllcywgdGhhdCdzIHNpbXBsZXIsIGFuZCBfX3Rlc3RfYW5kX2NsZWFyX2JpdCgpIHN0
aWxsIGNhdGNoZXMgYSBkb3VibGUKcHV0LgoKPiAzKSBJbiBlbmQtSS9PLCBpZiBzZW5zZV9sZW4g
aXMgMCwgcHV0IHRoZSBidWZmZXIgaW1tZWRpYXRlbHkuIE5vIG5lZWQKPiAgICB0byBob2xkIGEg
c2xvdCB1bnRpbCB0YXNrIHdvcmsgb24gdGhlIHN1Y2Nlc3MgcGF0aC4KCkdvb2QgaWRlYSwgdGhl
biBhIHN1Y2Nlc3NmdWwgY29tbWFuZCBkb2Vzbid0IGhvbGQgYSBzbG90IGFmdGVyIGl0CmNvbXBs
ZXRlcy4gQXMgeW91IHNhaWQgaW4geW91ciBmb2xsb3ctdXAsIHRoZSBsb2NrIG5lZWRzIGlycXNh
dmUgb25jZQp0aGUgcHV0IGNhbiBoYXBwZW4gaW4gZW5kLUkvTy4KCkknbGwgZm9sZCBhbGwgdGhy
ZWUgaW50byB2NSBhbmQgcmVydW4gdGhlIHRlc3RzLCB3aXRoIGxvY2tkZXAgZW5hYmxlZApmb3Ig
dGhlIGVuZC1JL08gcHV0LiBTaW5jZSBwYXRjaCAxIHdpbGwgbW9zdGx5IGJlIHlvdXIgY29kZSwg
SSdsbCBhZGQKQ28tZGV2ZWxvcGVkLWJ5IGFuZCBrZWVwIHlvdXIgU2lnbmVkLW9mZi1ieSBmcm9t
IHlvdXIgcG9zdGluZy4KClJlZ2FyZHMsCllpbmdqaWUK
