Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794990789;
	b=dcyUb4Wpkjr5FbSjKR5hnj702TeL5T8F6rymPkvs/8Ve5ks5wrnVqHw2kWCu1AqEV9pj
	 s3mx3TVVOpmgI0P4v9KF9VUGSgkXDMWu7fea3qpis5dH3VjmE0EuNbhIAaG3kbfzZq/yZ
	 NkmBOEJ46j+TLIDrfnZVwl5RikQbt9hVgocBHVAiFLQEtRpbWHtXBABAFyORYMLodI+da
	 A9sckhQkaRJKYFacN0fwNDTUl0mdPJrajWNQtI3D4WajLPlJB8EZG8xqgnsai9ul9+KBi
	 7n3vWpC+uYVJQuZajbqaufAlRzynNeZbQllmdbAALeT7B04ryYGR4+l3O4Ow2exgmMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990789;
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
	bh=WhXktsGM7nVS8d0Of4wt77VXcGkwbwyCwgsXvIEAFag=;
	b=JnF5imTNvdGr/QzVbf/i29/x2Zy1+bjxOt52ctoBwBA990qVj3kKxxtraHE4PtN71xhI
	 qiZYQkkvooy2FcmBXwRpaBZpJLaILrSCrzgH2P4UVJTxbaLPxwUQAX1mWwSP8x5+bfr6/
	 Evdd9Urjzf5hpPPoPx3KdUk5w5NNcQPRSRkD+lWYGzACD/3HvE4+BLc8mBCTnfsZRmLfk
	 05q8pFMvfutWTNBbasKXbDTM94Ujai0FK1shPurICN4qBxI7r0qUip/pTXFCWg04n58KY
	 nCaikbFqeOeE09MqgTkYl/1fauzmrDkJI42eZGHl428RHfDl3t48LiqIyMCbMr5KE0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=OO83a2Qz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.5
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010005.outbound.protection.outlook.com [52.103.12.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B7606A890;
	Wed, 18 Nov 2026 08:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 539B7606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=OO83a2Qz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Za+y5QiCMPkadP2t6rzcm9qeI79lkvKBBB9370PrkCRb7E4HdNRVGcAwzopEzC6mXv/j4jAMKIMZqKwP3+OAvA2hQLMn2t1tER5usbh7VMhduB7JcDjwgBcH30LKWRZjww4yoXIVYVoeDaliADt6/3QzwCdCZIYRLa7VoqmNrvbtUYGEgUynkIT+2iaqp84makdg7nnNEg4afqWLyzsoQr2U+r5dl8KBB9tmGIihfzcqwicZOPeq7vvnweNWRYIpycFuGPWf/nPp7s51LnYo3AY+c3qiEOR6LGX89gHusPCzsx+6BwvZ8eq2akUxT8+ijGIXiXQWg4MyteGI+MJ1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=WhXktsGM7nVS8d0Of4wt77VXcGkwbwyCwgsXvIEAFag=;
 b=a4JGYlQv1k0aCpGlOCWoWkrNoiYEYdH262deqZAcjHSbbI9u/0XcMQ5ljbeEO34y/l4H8tb/JfvV7eEk0JTa31E7CL1d+L3CLqjxSBuhhUE7hcU3Pex8HnAYDDH2jAIaW7+AY8CLC7YwmY5BGyAivyg6KeHYz/YgrLBx4mRjnlRamqZgOOY2PGaODdWCz90NGBuPA9PJhOebm85JsuxT5Mb1PhsCzEpIkm4OGwhZrYbtiY65rpQXTIvH8eJ+6S+JCsYuNjDRbhnQ2hxd076Ak5dV3Zsn17dURsSDIDPaoofUP+ltIifWPZakGHyADg/uLch7X0ZU8TTRHkvZn1kSIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhXktsGM7nVS8d0Of4wt77VXcGkwbwyCwgsXvIEAFag=;
 b=OO83a2QzyPvejZC1r8QkMQf09XJ+3kxOoHVz9E+gMd/gTtU9JfBQ+h60LH9ThsUl0NMbz56Z4f7wFc837ajgKFlnNw6cEXPA1Y0uj9apBLyZbc8skdkVTsD1m3GaW/jA3JRuNfEG0rXfJvK0KVtIqPaDASWO9URo7W6daiyd82vDEqPykJ1dC3SGFqLX2dSSZrTuWIqh25DhsJ6ixdL3HN8j6WcHzmyaurYbFU7+ehKf/c/bzM+q8TLZnnE4qFSnP3FJE3Dl/L+Z9KofCCRs4eqSzC9cJ7Uv0xi5AaaaPOOTibY+eKKUAYb31hTCfJ5U0qdg8Mx6tUr5fxgbaGnevA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by PH0PR05MB999481.namprd05.prod.outlook.com
 (2603:10b6:510:116::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:33:07 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 08:33:07 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/4] scsi: core: release SG_IO request before user copyback
Thread-Topic: [PATCH v4 1/4] scsi: core: release SG_IO request before user
 copyback
Thread-Index: AQHddzdvkbPC9caVMEGc+ao7ABrkOQ==
Date: Wed, 18 Nov 2026 08:33:07 +0000
Message-ID:
 <1fe63161bcec115131d7004cfd59f465f0de4f69.1794990780.git.x-professor@outlook.com>
References: <cover.1794990780.git.x-professor@outlook.com>
In-Reply-To: <cover.1794990780.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|PH0PR05MB999481:EE_
x-ms-office365-filtering-correlation-id: 6957f817-e1ca-4316-add1-08df454e9285
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|25010399006|4140399003|41001999006|38102599003|24121999003|22091999003|8060799015|8062599012|31061999003|19110799012|15080799012|3412199025|4302099013|440099028|102099032|10035399007|12091999003|1602099012|53005399003|40105399003|26121999007;
x-microsoft-antispam-message-info:
 =?utf-8?B?dUFtSlNqYTVua1pORjBHd25kTFlkYWlKaXNiVzJLN3lnL2J0K0pyUHVXVkg5?=
 =?utf-8?B?RnBtd2M3NDErVGdhK0lpSkFBWFZwWk0vM1BmOHF2VTZJYU1LT2hFV2NOb3pB?=
 =?utf-8?B?UlYwR1lGd1diQnNFSjJnelVSKzNKNGx3MmM1dFlMc3RNUlJZYjVnc0hFRWlo?=
 =?utf-8?B?VGlCMWpJRUE0VW1OU1NibHI5eUpWRytuaGNhY051NDJ1d1VTZVhqaXIwVDhv?=
 =?utf-8?B?QmJtTkVMVmNqUG1EYkJKY0dENjlOSXZmcXltdVIraXJsYjd3cEZTV2drTzJG?=
 =?utf-8?B?VEJIV0NtTUtYZ1Y5WVduTUdxaEdFK1lyQ1doQ2Q2Sy9Sbk1NUktuQWN1Wm1O?=
 =?utf-8?B?RlRoUmVQM1c1TkxwcThTaXlaMHJXbTVsaFNsQjB5RnZyTjg5Q3M1Y2FtWXdo?=
 =?utf-8?B?d1RXTFNqb2hxNWNCejZyTjNVUGdkOWU4VmRLVlM0NWlEdkZZTG9LZjRsN0Vk?=
 =?utf-8?B?VjZLUlhpc2EyMXREdHRHVEpoSGhPK0RzSDlFZlFyeWZ0NHFBSnNWTG5ZRlg3?=
 =?utf-8?B?Vm93Z3BCZWlKU0gvZXBmL2JoM3NxSGpqQmpsYVMrUzJBWkdBWDVrclRxa0pj?=
 =?utf-8?B?OEZJRUxad2tnM1NIcS9tNFVEYlJvMm5SSk1uNDYvKzNremVpVE5PLzVra1k3?=
 =?utf-8?B?ZDBJZVZubzB0UFNiWEJvaXVyVGc4cWk3b2pacUkxRFZYRDhQVHZ6NThjVE4w?=
 =?utf-8?B?U252dkZrZDdLd1J5YXZLbkFaVkh0UTFHeGZzSW50c2ZsWmxBc3RSTDJVdTVl?=
 =?utf-8?B?M05rZzhISjN4UWNzTnRvaXU2R3pzRGg3aTd1c0hqR0ZaT2R4c2xNK0xaNlli?=
 =?utf-8?B?b0wrbGZtV295cmoveUxSYXlJb3lFMm1DbnZrZGlTRXdYcUxMQ2N2YUI0ODA2?=
 =?utf-8?B?YVAzM1Fwd2ZnSzRxeGlRaHB2SEZudVRSWHk2ei9rbTBRUXkyNGNLbWNMdlNT?=
 =?utf-8?B?ekFGS2NWeXAwaXpEVER6TERKYkNwTlVibDZQZjRMNnF0MHNVazlPL0l5UTlz?=
 =?utf-8?B?RlFTNHgyLzdZZ2Q0Q3g3aHJwRjRJaEtheFQ0N1VZbm03ZW01YWN0aUs3ejNp?=
 =?utf-8?B?R21FY0RJT05OZVlCVm83UEdWNmdkVUV5VlJtM1IvY09hRXJYM2xGK2wvVjlY?=
 =?utf-8?B?VEoyRFdGcHhncEVsZ2llTk9MUDIyVE1UNkNnVURuSUNjTUVnUkJCU01aSEFK?=
 =?utf-8?B?ZnJxbXR4VmY4VWN2ZitONWhuL3hzTklBc2QzbHFsZExmLytvWmxnSkk5WUY1?=
 =?utf-8?B?NEQ0S0FzSTYzaXcxUXVKS01EdlYzdUFoczRPUEMva1hYSWtWL1RjY2FBUkVS?=
 =?utf-8?B?THVUTXlBWW1abWthcDV2NDk2MHpWcmNseDdpemZGeDI1N0tmd3AyUmpkc25F?=
 =?utf-8?B?V2Y3ZEVrR04vV1JZUE05c2JrYmVDSFVUdDJ4Zm5wZ1VZMithaHBlUTNUUDBo?=
 =?utf-8?B?WXBTRjZHU1g5Z3hJbkFDN04zUW9kalIrNmd0MkRJNk1SQ21nSDFEVlRZWm82?=
 =?utf-8?B?TFE2V1IzVEdha056QVFCQnJHZ3daMmVZQmw5S3Y5RjRBeXRPcVlWNlVEMkJw?=
 =?utf-8?Q?UT5zF0MU/dnrLLibyvC+YA+Ew=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c2lzdEEvdWdhSnZCNjg3U0krakY2WGFhUVZLUHhyNFRUYjQyTVNFcTV3M0gy?=
 =?utf-8?B?cEQxNlFMbzVFNUQ0K1p2dThleFZ5aG5lTkJ0UjVhcmM4ZWw0TnNrbld3Y1Jl?=
 =?utf-8?B?N2RMVCtPc1VaL0J6cGZHNnBNVlQ0a1ZwUENPZVpuYm93OXlIaE14dzU0QlNH?=
 =?utf-8?B?ek5aaVMvc2orcUNUcGhlc21VaXJzYXFLTWUxaXhmWXRrRCswbzlUS2xLM2dK?=
 =?utf-8?B?N3ZVc2VTSStYMXVWZUZZRmprVDJBaUdKMTRRMnIvNlFlbHdHWTZmU0daUlhX?=
 =?utf-8?B?N0l6Rm5uWThLOUZra0x5L0ZqT0xTc3hhKy81L2RTN0tpYWFNNDJFZDFPUWh1?=
 =?utf-8?B?N2lTQ3pOM0V4dmJ3dlY2blRwWlJZL2hRdEtkMmdTZFlrRnhZMWE1eWZIdDQx?=
 =?utf-8?B?bU1xNndhRWNUTjFwbFRydWhVUU5HRUhnUzFWZ2dLc292L2hjYlJIbmxzQnht?=
 =?utf-8?B?QnRxa3U2L2t4bC9ReE1WU29wSFZkUi9GWGdTTjlEeGl0VHZveVAzUklYaXhY?=
 =?utf-8?B?TndLRFNwTEkyZTdsZkkrWS96RC9lWTdCanRiaUtlRVByQitEUnpNbFhWZUVY?=
 =?utf-8?B?T3UyTTdScyt2YUszVnlSWVp6REtRVEF0TUtxK3lzNzZvNVN2K2NrZ2M1aGRQ?=
 =?utf-8?B?QUJXSUY1TjFYZEFzNjNHWmFpTlYzNjh4NzJCZmF0WjdWZUYxbHR0ZlVqWHRs?=
 =?utf-8?B?SEtFT1NDMGlubkJCdFZYTll0L1ZSc05vSFJ6Ry92STZIK0dOQk8zbHdTcHRX?=
 =?utf-8?B?SXA2blRRWE1ndTZUWFR5WWU0Q2xNM3pyQnFOWS92d3RJaHBsK2dEMXN5RndS?=
 =?utf-8?B?WXh6MzJJV1M5aTBNRlhPbTZuTWlVcU8yYmRlUHJMaGdrNVFTQ2NwMHpLVnZt?=
 =?utf-8?B?YjhCKzZaZEFxLzN3SUg1MmJXSmp1WVVlM2JET0pQWTNXU3JiVFVxbktkQkph?=
 =?utf-8?B?K3JQWXNGdDFSUGw2SHBCUitKWjZBUjY3Nk00dlM1NklDQmFRSkR3ZUZUR1pF?=
 =?utf-8?B?TFE3c1BleTBid20xWjlrb2MvZkdFa3F5dkJmcGdUWTRyWFNaT2s5M0pDYWpM?=
 =?utf-8?B?UkhpUjNSdnF0R3N2N1ZHRlNMNmRMSUdCekI2Z1VoZUFYVVRDblZHSDhjeGhL?=
 =?utf-8?B?MVIwNWI0bHRWMFVnOGpyTS9MVXpTc29aQjl4dW1ERGt2ODNKTnNrZFJkdzlG?=
 =?utf-8?B?SDhXTFZMc05hMkhPTjhXUkZteFRjNUJ5TGcxMlAzR1NBMEhVRUpEbUF1RGVo?=
 =?utf-8?B?aC9BYURsOTJEeVFGdEhCSnZIVy90ZDhhVTM5RWswWG5OUldrelczNm1Rd1Fo?=
 =?utf-8?B?N2xtT0Q0OWlKMk9RMEFPUGZ5TE1Hd1NGdzZXejRuRHhEODZOcUpiZjN5b09H?=
 =?utf-8?B?emRWTnNndVl4Y0NPK3VwMDNMWXF2V24xMFE0L0x0SGpHQndWVnRYR0UxZk9y?=
 =?utf-8?B?RitIamtVQmlRTXhCaWhXdDZZSGlkZGVqQ2ZNSS9KMkxSR1lmMTZtTDYyOXBi?=
 =?utf-8?B?eUt2S29WbFlUQ24xV3ZkSlBTazhXdlZJK0dMN0dEV2QrWkFraDRYNTIvVm9E?=
 =?utf-8?B?Vm52RnVPOE94TGZ0bFgvY25PTnNBVGFyNVY1eVI4ZDRxbWdXM1JJS2dGeTNY?=
 =?utf-8?B?S3JPUXBTMDBJaC9EWFZ1TDZpVENZdmIzOGtoYmVCMWNuc1pZbUs0NGVwSGRR?=
 =?utf-8?B?d0NWNXZUNllWNitaMWxMRmpGN1c1eVVDdTAwR01XQUpYdHF4QU9zS0MrQ3hl?=
 =?utf-8?B?WHQyVnZVWi9JKzBZUFFQMGxRTFNUYTBPOG85eGlHdWxXcXZhOGpwTmtrWTgv?=
 =?utf-8?B?cWVWOHZLcll6VmJjMnE5UG8wSE90d3hObEdDMlNjZGh5WGc0ajJ5S1Z2bFhV?=
 =?utf-8?Q?7fe0hGxUtj97o?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6957f817-e1ca-4316-add1-08df454e9285
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2026 08:33:07.6740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR05MB999481

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
LmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCmluZGV4IDkxNTI1MTAzZDA3NC4uZDM3MDE3
MGY5MjcwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2NzaV9pb2N0bC5jCisrKyBiL2RyaXZl
cnMvc2NzaS9zY3NpX2lvY3RsLmMKQEAgLTQxMiw2ICs0MTIsOCBAQCBzdGF0aWMgaW50IHNjc2lf
Y29tcGxldGVfc2doZHJfcnEoc3RydWN0IHJlcXVlc3QgKnJxLCBzdHJ1Y3Qgc2dfaW9faGRyICpo
ZHIsCiAJCXN0cnVjdCBiaW8gKmJpbykKIHsKIAlzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kID0gYmxr
X21xX3JxX3RvX3BkdShycSk7CisJdTggc2Vuc2VfYnVmZmVyW1NDU0lfU0VOU0VfQlVGRkVSU0la
RV07CisJdW5zaWduZWQgaW50IHNlbnNlX2xlbiA9IDA7CiAJaW50IHIsIHJldCA9IDA7CiAKIAkv
KgpAQCAtNDMxLDEwICs0MzMsMTYgQEAgc3RhdGljIGludCBzY3NpX2NvbXBsZXRlX3NnaGRyX3Jx
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
NTA3LDcgKzUxNSw3IEBAIHN0YXRpYyBpbnQgc2dfaW8oc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2
LCBzdHJ1Y3Qgc2dfaW9faGRyICpoZHIsCiAKIAloZHItPmR1cmF0aW9uID0gamlmZmllc190b19t
c2VjcyhqaWZmaWVzIC0gc3RhcnRfdGltZSk7CiAKLQlyZXQgPSBzY3NpX2NvbXBsZXRlX3NnaGRy
X3JxKHJxLCBoZHIsIGJpbyk7CisJcmV0dXJuIHNjc2lfY29tcGxldGVfc2doZHJfcnEocnEsIGhk
ciwgYmlvKTsKIAogb3V0X3B1dF9yZXF1ZXN0OgogCWJsa19tcV9mcmVlX3JlcXVlc3QocnEpOwot
LSAKMi40My4wCgo=
