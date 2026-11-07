Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045028;
	b=iHX5C71V4Lwm/WqRsIQhMgYY+9zqDHSZP56QHR19TRLH4UH8+WdpxaIdbDqRrfVYTDr/
	 TA7JRTc2z98Yhkphs/vNqtLPuraFog0Ra1Vra3qumGb9W8slCZv6i3fbwMTvqI72KMb2S
	 XqpVU5ceI2OoaVxaoQZnlQo5vXNnkRE+P64CRx82lOmwCGeAsrP0X86zDw5HDJBbnLyyd
	 cL1FB+yiLZPeZCbrm8D3kbOU9JZ2iug4CQW0JcqQZY0wPwmcWwn2eLfGsnS2TubbrDXQA
	 LxETwTBANOEkNzD4aW3Tj96zheXacoQbq+srVu4dnwES196jOEY4utrlxyHD6tmsCgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045028;
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
	bh=C30RN43YjAxJKJyRImkPGMNh7Py9Va3CcLmkzbGPU/0=;
	b=GaNdnJ1U9lWMCokxveXSHvwhQuIbu7tHwBNTL22b+qe4yHx5+hlLR++y0KjjJmwGgJEz
	 MvOXzeC0jG8uBdYt0ffG81dfmYxzADDKOw9oPINN9v+mjcPk6zHZ3yfApCAiTCzFllou0
	 sHm1FMC0w1BDyjMSu85X2iqYR7pZ3dy6MotaWAuc5Se8ltEySFdxYm0XfXWauol8cBS92
	 vzgC7udMAmGp1SW2WmJkA+WyrIhLNVQcV5XWPKV/7Iw+0PnppmyX95B+GFvK7EqEV9yRk
	 Sqr+gjkrkvKtvyAA2vtAQ36HC+OZsthf5I5qdtSWsfRT9XpgM2VqV+2c0UURLMM25tQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=nGPEsx4T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.23.46
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012046.outbound.protection.outlook.com [52.103.23.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4389606A331;
	Sat,  7 Nov 2026 09:50:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4389606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=nGPEsx4T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DqJi7oBV0vNyxbj/9YX74qPMMr+yYxM/6Qj/iL0hM1sGS3cc3a4TY3aLeWbKXXgeyyOIHpo8TCbHWk0jxfwPANcUXikzd5/UuefcGhaffZkj4nV7lhq4D0rv6BK24YYF9CVI4uyiMiWR5bjYGI6JadWx3exdWdyECEQ93CRMkRtr7FgCZ8W4PkFJ6a1BgUZoindAEAA6J7ouWQhpqgf3zG7ELsYkFO7NCQQ0imKLHsi8ObM8OhOzu5u1CHEe0MHDso4Paeule1SAGtgvxIaNmbtWKSnsk73atvTXnfJTYscBe3ZXIkOJCd0BjiFOi59IB6Wiuu5+DtIbPA9OtT/UNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=C30RN43YjAxJKJyRImkPGMNh7Py9Va3CcLmkzbGPU/0=;
 b=o7IoPjuGmjLicG33RgS3YXAUoRdzGl98Ai+uPB3ZZAw907RFLtdaV/sYAj7JjShyjRGSeubih7/DhWs7+FLCcc1SwVzjM2VYdi8XKSaSXzDh9PsmKlYs1ajasz+QhRpcz5+itxm1bNoUwGX1LsFafUa+yTo1rpUSRwG3U2V+anhwID66lKSz2RK3ClzbX6lF+OtR8nVu1YgZfYYqzjcMDWxRDcSQVFpEkKOmZRY/7hJWVySpDW3xvwpFcbVVE23VBA5cwjlwrBVFptphwCBJM0im+Epqlul3U19+Axr21I/kA6RdroZKtIkzRx+yqMVIo6HBIQWGbUi9Ot+3MENOXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C30RN43YjAxJKJyRImkPGMNh7Py9Va3CcLmkzbGPU/0=;
 b=nGPEsx4T/0M12yB+e7bYFZhxmAYnAsBWbpR6DDws6RZq8SbunkF/VDL0zcSeDF2KXPmJaqO+wCxxfZDgYmh87qF4t3LJbFm1NRLA9gWKa0pNIZ2Z7Gy7Tu2coEaWI8izONdvDx6n/qqmAlYHO3rmxAnf5TWgma2rhfBGKFap8PIWOu0Uv8bgHREvKirJN1+LrUsExuNlvTHOr9Jcpfd4RfUy5geLbRdV7htW8w2ZMmvtQ8eIOpePIWqNKBWoKIxl+qYTokoZQS5fbgLPBlAIuT+RhEAXRxDxdBfa3a1+yeAALShNa0a5ocZr3Wev/McW1h3mXPbYanmPny8RdIVA1g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA6PR05MB10700.namprd05.prod.outlook.com
 (2603:10b6:806:409::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 09:50:25 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.010; Sat, 7 Nov 2026
 09:50:25 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
CC: Yingjie Wang <x-professor@outlook.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Yang
 Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 1/6] scsi: core: release SG_IO request before user
 copyback
Thread-Topic: [RFC PATCH v3 1/6] scsi: core: release SG_IO request before user
 copyback
Thread-Index: AQHdbp1oEILTLrwFJ0iyvgJFt1PY6Q==
Date: Sat, 7 Nov 2026 09:50:23 +0000
Message-ID:
 <a7a066c901218b5dde6586943b69947dbd9ab014.1794045010.git.x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
In-Reply-To: <cover.1794045010.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA6PR05MB10700:EE_
x-ms-office365-filtering-correlation-id: 325d3160-7c4c-40a6-fce7-08df3cb48c77
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|19110799012|24021099003|41001999006|31061999003|22091999003|24121999003|15080799012|8062599012|38102599003|4140399003|25010399006|16041099003|10035399007|12091999003|1602099012|40105399003|53005399003|102099032|3412199025|440099028|4302099013|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?OTVudUJpbTlnc0hnSm0yRGo0RkNZS1dHNURMWmJBdTBKZ1pkYWo0S3Z2Y2xE?=
 =?utf-8?B?S01vV2hqbGhuTnlZNGIrU0paaGZvWmV2NWJpNjAzdWZsdlVqOTZ6NVBQSHdy?=
 =?utf-8?B?N3FaU0pRcmtzRnExRDBmMXJOYXB1Yys4ZFcvc3NBdFRDYkpVbklZWGxWUmRx?=
 =?utf-8?B?YmxVZ2R3TFY2d2pHSlBBV0JubzdmOGFHTHZoMGpEUUY3K21mM2JBeXBXSkRt?=
 =?utf-8?B?MmNPeHNwcU93UDVhUEE2NmlhYndGSlE3VkhOT0pJVWJDaGhrU0hWajIza3k4?=
 =?utf-8?B?ZWp2VXFCYWk2WVd4eEkvQWN2bmxXR2xwM2hnOHNsYU1yc0JVVnltWE1RWlFE?=
 =?utf-8?B?RnBiVXUzeHNNTjVHOUxKUDB6YWtIL1dmSFY4MEFSd1doaHp3eHJuOW9DVzJq?=
 =?utf-8?B?QnFIWFc3Mm1ORm5rMFBuNXlNNUIzQ0JYV0tEYU9iOEhyY1c2dmFha2pSbTZv?=
 =?utf-8?B?LzRPWGNhMzJScnBjS00rWldLVzB1RTRqdlJlMmNNemhBVUUwREVsWHFFNDRJ?=
 =?utf-8?B?c282ZmJVSDNHNWZOVjl5L1NBTWN6M3Qrb3VDNHp3a3ZwZStVa1p0OC9LQWNJ?=
 =?utf-8?B?SEd4VUkyTEFZaUk0VE1TRHBjampXUW40RWZZQnh1QjZKdlJxTVhDVlQ4eEdj?=
 =?utf-8?B?RUJuN1ZiamR4cTh6VGtubkUvdWMzaFNoZ0dlQzNTd0h1SHRZOVdlemlXZy9J?=
 =?utf-8?B?WHhlZUdyUFdzY3ErTGhNSmVpdUs1aU4rUXB5MWZhTVBNYlZoSmllcHY0RGJV?=
 =?utf-8?B?NVVpMEkwdzk0SFZCQ3FJME5HT1ZicHMrOWlEclpHQVNyeUt6SGRVSldYcFFR?=
 =?utf-8?B?MHAxRkRhUVFadjB6enk5aEYrVVZxSWplTS8zVDhFQThUL3RMM3VvMDJrL2JH?=
 =?utf-8?B?Q1FmanBSYmZKcTI5M2hwcUx2RXFEL09DOElBMnhPR0thWWpSNFNDS2s5ZTZS?=
 =?utf-8?B?QTJKUDJyVnlxWjcvblpocEhzSmNBMUhrRDRiOG9nSFZIbnF6QXZBVzFQRG80?=
 =?utf-8?B?L0paRVJldFNScE1taytPY0tDRXZ6WFk0THVhNmMxMUY1QjFiK2pWQXpJenhB?=
 =?utf-8?B?bUVaQUh4Y2hxWjNLdjk5NGQ5RDVTdi9aZm1tUTl1dmUzRXNZSHRIL2VHWmRQ?=
 =?utf-8?B?ZEJNREhBYUF4ajhJWFRDYW1MSUYwVXh6TEVlY2JkRFQ5anhEOWhGRXBLRDNu?=
 =?utf-8?B?YWtpVnd5YlQ1OVR4NWRETDU3TFN5eThPVktPckVtWHd5VkxoQjdvdXBNdUUx?=
 =?utf-8?B?Y1VSZWJCU3JVSzhxRGRpTG02cXh4WFdpbGJlYUgwZnpMY2pkME5oV1MzUk1I?=
 =?utf-8?B?cGtoSm9HOTFlN0VraTVYcGd5NnRkTEcxanliQUhGRllwcktWMDhocHZoejZG?=
 =?utf-8?B?QUhMWDByTzEyeEMrbDhrSnd0ZHhkYnc1dGNYbXdINmgvSVdFVStsaGZZRXNC?=
 =?utf-8?B?djhIS3dhZmwydzhVNXFLQjluWTczY0RWQ3lVV3FkTjhQMlk5RmVlY204YW8x?=
 =?utf-8?B?VEpaeEZ3eVJJTHdpaEQ2MTJiSkR6UmI3WXNqdUJLMndkSVczR2R6ZHZTY0hZ?=
 =?utf-8?B?V3NHVVo0Z0tmZkVHVHNFMW1DQUU4M0x2U3JoNFZSbU9lU0J2NHpzNi9JcWQ0?=
 =?utf-8?Q?tNKsM09sDk78yV2Cye2ANfvagYudh4sMRQX4hbMg+l48=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ekRRSVZDalNKdDU3OENPRnVtaXFWSnc1TGkrYjd4SDVlUi9zTmhzOHN1QzFD?=
 =?utf-8?B?QmZhL0I3ODUxVDJ3VkkxbHN6TzJNeFQ4dk9DZ2F3ck5tbXlITlpTeXRsY2Uy?=
 =?utf-8?B?emR4Mk85Y2U1b2k4YUl6T3d3SzlTMmNTS050QzR1QVduWExsNlN6eENaVEZU?=
 =?utf-8?B?bnAvcU5zbzVsZHdNWU83VVRiZndJaTdiQ0E3SS8vQlBzaERkRUs2LzZ2b2M1?=
 =?utf-8?B?aHJWMiszRWxCR2tFaXFVeCtIdFJ4Vk1pMkdBNUdjN1kxU2lnQnRoVXJHYXFW?=
 =?utf-8?B?U3ZSYXhDdmExUjQ2bFljeFlYb0FIZmN4Qkhvemd2UDRpc3JJSnIxOUFrR1VJ?=
 =?utf-8?B?dXYvZlI5RGxYMlp1cW96U01aU3FUZlIzSUJ5UVAyRFFoa3piUlNnKzJIT0I4?=
 =?utf-8?B?VGFPOGJqYzlSYmdoeDVsRDJiNk9jS2dBTGFNZFJHVWxLSFVQSmJaaUJXZTZM?=
 =?utf-8?B?eWNSWG9obG5SNE9FVUt2dFdaU0YwWTE5YXdDazlPUVdhbnZLd1ZCSXdrdmhD?=
 =?utf-8?B?L1BsTGtSdElkYkFxaHV2R2p1aVdIdWZ5TXRLOU9ZeUl5NVAwZ0FjV3pxK0lK?=
 =?utf-8?B?NkN2WG1hTnVsYVM4N1pEZzl2L2tOZlRUQy84cmtwUStnQlUrbWltd0I3N3dK?=
 =?utf-8?B?WXovZ3VYajBHdGNsbXFUd1RTUFY5SVlEQ0JZeXlJaHJWcVVhckdta2VNT29l?=
 =?utf-8?B?ODdXdHR4T0xGNm5SVTdxN092OXpiTXU3aU9FelpRQzBDMXZMMC9JQjlBYWJD?=
 =?utf-8?B?VmNTeEo2WGpneGZUV3p1MEMzK0l4R1BHa3p4OU5vUDcvZTB5Sjc4ZDhPc3ZC?=
 =?utf-8?B?N0lSYjJpKytRajh4a3JPN2hGTzdtOUZweGgveUVJRXBoK1ZHU1k3NUY2T0p5?=
 =?utf-8?B?UU13T2E3aGdBTGNyRmhKYktmRDIydjN4NWE1K2V1cWdrRjlka05yek52cEsv?=
 =?utf-8?B?b1dmZGMrODhyVTJuRko3OWZaVUUzRTlPYzQ4QUFnYkt2bkJEWk8zS1BSVXRQ?=
 =?utf-8?B?Rk5jZ0N1VFhML2V1RCtWUEZuY0JCTk56Y0J2V1JIYTQ5ak5NUlA2dUtGRDBm?=
 =?utf-8?B?bGdtMU8reXQ2TGMrTXlsRU15NVdPMGZzaitvcXpEeEYvdVpkTE9CakRHOWw0?=
 =?utf-8?B?aXBlU0JWOTlxWUp2eW9JcUczTzlTeVdqUGxOSlQ1a3hxdGlmU3dmSEdlUFVi?=
 =?utf-8?B?bjhjN1Rzc0xhSWozOG1LdnJ2TkUyWWl3a2YxQXJraXg0TEVDc0RndFZZcjVV?=
 =?utf-8?B?empka1hGRlkvbkxrVHVkaitMVlpmMkZ5U2dDOExaWkcyOTJ3d1BpS0FzVXRu?=
 =?utf-8?B?K2I2OGlSRXVRQWFtVlQrWkFPcExkQnRRM21Ed25BMkRqeWl0c1hvV3FneUkz?=
 =?utf-8?B?WFVhTDlRZkNKWU1EVWE5NUZXV21pUlJyMlZzRnBHSVZPODRkVXJ2UXlBazda?=
 =?utf-8?B?eGFQaVhZYTcyOEhEaGRnNlY2WXFhSU1tRGlwNWt1NkpVTHFYUDBVTFdHbGdL?=
 =?utf-8?B?ZkZiWTltUE5teDhTZGE5QngvcU41MHJEdGx0L3hjRHBJWWlyeENzdjFRajAz?=
 =?utf-8?B?MzU5ZFQ3YldtRmJqbHo2eXk3d3c0dEF4eE5rWm1mK3NFNnJOelB1WUVJTHQx?=
 =?utf-8?B?bDNNNlE4WFZOMnhZZHdMMUZsL3VGcjFsMG5WZkMraFVudThUYkNVdXlXc2pI?=
 =?utf-8?B?VUxhcmo1dk16anR0VVhzZEtrd0E2ZENzSlVzbkU1S1VyMEpWRDY5WFBRL1U3?=
 =?utf-8?B?OFZxU0t1NGFuMHd3UVJZeDJoTVB5SUpycXNnRzVYdVJZREZrM0NxdUZCYWRm?=
 =?utf-8?B?bHhHd2VNaTBMdU1XcWcwcE5GdmZXM3pPc0czci9RcGFXRGQ4WnZXQzNEWUlF?=
 =?utf-8?Q?aALAAKsM7B/aE?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 325d3160-7c4c-40a6-fce7-08df3cb48c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 09:50:23.8748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR05MB10700

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KClRoZSBibG9jay1k
ZXZpY2UgU0dfSU8gcGF0aCByZXRhaW5zIGl0cyBjb21wbGV0ZWQgcmVxdWVzdCB3aGlsZSBjb3B5
aW5nCnNlbnNlIGRhdGEgYW5kIHVubWFwcGluZyB0aGUgdXNlciBkYXRhIGJ1ZmZlci4gRWl0aGVy
IG9wZXJhdGlvbiBjYW4gZmF1bHQuCklmIHRoZSBmYXVsdCBuZWVkcyBJL08gZnJvbSB0aGUgc2Ft
ZSBxdWV1ZSBhbmQgY29tcGxldGVkIHJlcXVlc3RzIHJldGFpbgp0aGUgYXZhaWxhYmxlIHRhZ3Ms
IHRoZSBuZXN0ZWQgSS9PIGNhbm5vdCBtYWtlIHByb2dyZXNzLgoKRmlsbCB0aGUga2VybmVsLXJl
c2lkZW50IG91dHB1dCBoZWFkZXIgYW5kIHNhdmUgdGhlIGJvdW5kZWQgc2Vuc2UgZGF0YQpiZWZv
cmUgcmVsZWFzaW5nIHRoZSByZXF1ZXN0LiBUaGVuIHBlcmZvcm0gdGhlIHVzZXIgY29waWVzIGFu
ZCB1bm1hcCB0aGUKb3JpZ2luYWwgQklPIGNoYWluLCBwcmVzZXJ2aW5nIHRoZSBleGlzdGluZyBz
ZW5zZS1jb3B5IGVycm9yIHByZWNlZGVuY2UuClRoZSBzYXZlZCBtYXBwaW5nIG93bnMgaXRzIEJJ
TyByZWZlcmVuY2VzIGluZGVwZW5kZW50bHkgb2YgdGhlIHJlcXVlc3QuCgpUaGUgZml4ZWQgcmVx
dWVzdCBwb29sIHdhcyBpbnRyb2R1Y2VkIGJ5IHNjc2ktbXE7IHRoZSBsYXRlciBtb3ZlIG9mIHRo
aXMKaW9jdGwgaW1wbGVtZW50YXRpb24gaW50byBkcml2ZXJzL3Njc2kgZGlkIG5vdCBpbnRyb2R1
Y2UgdGhlIGRlcGVuZGVuY3kuCgpGaXhlczogZDI4NTIwM2NmNjQ3ICgic2NzaTogYWRkIHN1cHBv
cnQgZm9yIGEgYmxrLW1xIGJhc2VkIEkvTyBwYXRoLiIpCkxpbms6IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL3IvMjAyNjEwMjIuc2NzaS1jb3B5YmFjay1yZXZpZXcuMzFiOGQ2YTcwZjRjQG91dGxv
b2suY29tCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnClNpZ25lZC1vZmYtYnk6IFlpbmdqaWUg
V2FuZyA8eC1wcm9mZXNzb3JAb3V0bG9vay5jb20+Ci0tLQogZHJpdmVycy9zY3NpL3Njc2lfaW9j
dGwuYyB8IDE2ICsrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2lvY3Rs
LmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCmluZGV4IGJmMDQ5ZDljYjcxOS4uYjU4OGFh
OTA1OWUzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCisrKyBiL2RyaXZl
cnMvc2NzaS9zY3NpX2lvY3RsLmMKQEAgLTM5OCw2ICszOTgsOCBAQCBzdGF0aWMgaW50IHNjc2lf
Y29tcGxldGVfc2doZHJfcnEoc3RydWN0IHJlcXVlc3QgKnJxLCBzdHJ1Y3Qgc2dfaW9faGRyICpo
ZHIsCiAJCXN0cnVjdCBiaW8gKmJpbykKIHsKIAlzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kID0gYmxr
X21xX3JxX3RvX3BkdShycSk7CisJdTggc2Vuc2VfYnVmZmVyW1NDU0lfU0VOU0VfQlVGRkVSU0la
RV07CisJdW5zaWduZWQgaW50IHNlbnNlX2xlbiA9IDA7CiAJaW50IHIsIHJldCA9IDA7CiAKIAkv
KgpAQCAtNDE3LDEwICs0MTksMTYgQEAgc3RhdGljIGludCBzY3NpX2NvbXBsZXRlX3NnaGRyX3Jx
KHN0cnVjdCByZXF1ZXN0ICpycSwgc3RydWN0IHNnX2lvX2hkciAqaGRyLAogCWhkci0+c2JfbGVu
X3dyID0gMDsKIAogCWlmIChzY21kLT5zZW5zZV9sZW4gJiYgaGRyLT5zYnApIHsKLQkJaW50IGxl
biA9IG1pbigodW5zaWduZWQgaW50KSBoZHItPm14X3NiX2xlbiwgc2NtZC0+c2Vuc2VfbGVuKTsK
KwkJc2Vuc2VfbGVuID0gbWluMyhoZHItPm14X3NiX2xlbiwgc2NtZC0+c2Vuc2VfbGVuLAorCQkJ
CSBzaXplb2Yoc2Vuc2VfYnVmZmVyKSk7CisJCW1lbWNweShzZW5zZV9idWZmZXIsIHNjbWQtPnNl
bnNlX2J1ZmZlciwgc2Vuc2VfbGVuKTsKKwl9CisKKwlibGtfbXFfZnJlZV9yZXF1ZXN0KHJxKTsK
IAotCQlpZiAoIWNvcHlfdG9fdXNlcihoZHItPnNicCwgc2NtZC0+c2Vuc2VfYnVmZmVyLCBsZW4p
KQotCQkJaGRyLT5zYl9sZW5fd3IgPSBsZW47CisJaWYgKHNlbnNlX2xlbikgeworCQlpZiAoIWNv
cHlfdG9fdXNlcihoZHItPnNicCwgc2Vuc2VfYnVmZmVyLCBzZW5zZV9sZW4pKQorCQkJaGRyLT5z
Yl9sZW5fd3IgPSBzZW5zZV9sZW47CiAJCWVsc2UKIAkJCXJldCA9IC1FRkFVTFQ7CiAJfQpAQCAt
NDkzLDcgKzUwMSw3IEBAIHN0YXRpYyBpbnQgc2dfaW8oc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2
LCBzdHJ1Y3Qgc2dfaW9faGRyICpoZHIsCiAKIAloZHItPmR1cmF0aW9uID0gamlmZmllc190b19t
c2VjcyhqaWZmaWVzIC0gc3RhcnRfdGltZSk7CiAKLQlyZXQgPSBzY3NpX2NvbXBsZXRlX3NnaGRy
X3JxKHJxLCBoZHIsIGJpbyk7CisJcmV0dXJuIHNjc2lfY29tcGxldGVfc2doZHJfcnEocnEsIGhk
ciwgYmlvKTsKIAogb3V0X3B1dF9yZXF1ZXN0OgogCWJsa19tcV9mcmVlX3JlcXVlc3QocnEpOwot
LSAKMi40My4wCgo=
