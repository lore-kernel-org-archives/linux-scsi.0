Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249911;
	b=IZYm2YFn/sroOJd3JnqaRa1nArJ5eHwEZryZJ2jFMVW684aULJ0VI1p7b2tGgAlWupts
	 SRiQy72nhyCaxoyjD97pe++lwn+9DUnUl4OkE4srGialJUgOEvJBvnQPH+TJlaUlNXyr+
	 GWiw8SPkn9CpHj3jILubYTOzeRF83QryEwc20JNf3vr4Pg/exic8zTmNi+11UZ/M4TA3U
	 XYD0psHa42WHuEbVLzCMiCVyMkcj5WDqVJMVTATNc3m52YbHTvc83xXgE+mfUId4XHxR2
	 ixJ7GpaJz/KQyqVHC/0f2vDl+gZFnr4t7vh+kK2PRzKtJ+VM8spwg+P2Lmm0zRd9jPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249911;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-slblob-mailprops:x-microsoft-antispam:
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
	bh=p34vhcfddy4HPEPlI2+XOfg0t3kmffiAXjj3H3IcPBM=;
	b=1njCqY7JIL6cP2bzrfx8qo0xO1VcVdbbK7I7bTtQZ5AiroSqdv3pRRvd/2QuzRSfRmot
	 9qvRtUBEuX+C+LVi8psbsrOYF+hBjHg+Chi+XRbEiAwB/Z4yXxMCGDFL2PFfArvLCg/EV
	 ChUDoqVknUIPSd4BWDz4ybqvTViwDNoZk8XCQrS3FsaXfWA0vxlF1dnJZgjgdIWiM7N2r
	 yFEmfLcXmxHEb9aaP/MQcDJ9w7KkYAT0f6XsjxBROIF3NxSIfgbz4IoXx3AmWgKmk7O8q
	 crSXIYr11q0bggebWPDIax35S6J0euxJsU9yGFgniLR4e8t/c5zs1R2UBU+4HvzCeyg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=bTB6aYgV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.27
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azolkn19011027.outbound.protection.outlook.com [52.103.12.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A224606A688;
	Sat, 21 Nov 2026 08:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A224606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=bTB6aYgV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEOcevB7CWo/IwgrY25aULxWmfQjKoNM5eC2GCIAZ/S60obz3MTifOOnKUpws650mltLLLw5DmroR21bda/GcJJT2Mj/ECIio1Smaarlz2si9j6j5sEz4DQUzBvyyOH24mHrGzQHnPRvcu5BLV1cbaZmqD8QDM1GkWoMK2FZBsLxC8ZJ3Uqf9za+z9pluBOGSoaKwGCxM+H54Tqw+wi54unD63zAd2qHCbv3jrhmnc70vH70U15hTem+fHrXBw8kPuYo0O2fLygKolzrQJ/klJDNmW96C8nlzoTxElRSIgeTSLQgpo4Xcu38ZwqaGbnhqvTy+tI+HLCKi66O3v3kZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=p34vhcfddy4HPEPlI2+XOfg0t3kmffiAXjj3H3IcPBM=;
 b=CN26JUFeZaNWsWADNTQntqjjpi7A8CGwBLxfD5C1lXwQhOYcDviC55K8gCRWK7+SyI6+dSRIZ5VMaGpoQgFkbAxtf1Jao8U7F0L1OF1x3yibFlwfH1WqprL8qbGXG6cLa7cSEVQBy6vhWi8WvEnq0Q63tQ1dgzebFSsnSx3VvLzfZrGLtSl9y+PQpMgWkbBpFWC9NtoMiXr0pcqMpXgVyY15IoxaIMsd9g8L3z05CUsvsNP9d9FlEmIFsobSUAj1QtlBSvg33dZGfSGgQBRjLupKAr1TrkVtuBAAyyC/Z9ZP+0Na8ZStS8FRxMez/DwOpDsNM3PUGxHeKu2Umsiylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p34vhcfddy4HPEPlI2+XOfg0t3kmffiAXjj3H3IcPBM=;
 b=bTB6aYgV/aIoDd3oW+050pk2rFajeGD4qFTLJfXbbljdE6rRqGfXWzQb8ZIkecJ2VfatXMCXHadXfd+XmiDxG4Qof9jv/MFbij/w2qP5T7rt3qtKZnH2vOBdj3BUz/6R7Yy5DpFFM10bEhqn7DhglqmkiyA5DzlVW+jcxIDxyBhiMpgNTwFDAKsrSuaZpypfGd5ya2mCeLrDfYq7o6kHwGENJHFec4LQCdApUo4BZHATzrCXBR9StJoW6RkOBxEuKYquJc+/gJA38bmz3lXZeHiNJYUP13uBAhDi+ynRqpPRSXkaLAo1q78xwf4xe/QI6+2PD+Ry2gbqVq3LkavWgg==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:31:47 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:31:47 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, Jens Axboe <axboe@kernel.dk>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, FUJITA Tomonori
	<fujita.tomonori@lab.ntt.co.jp>, FUJITA Tomonori <fujita.tomonori@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: [PATCH v5 2/2] scsi: bsg: Release io_uring requests from end-I/O
Thread-Topic: [PATCH v5 2/2] scsi: bsg: Release io_uring requests from end-I/O
Thread-Index: AQHdeZK/aVRUIRXL3Eyja3cmKC99Eg==
Date: Sat, 21 Nov 2026 08:31:47 +0000
Message-ID: <scsi-pool-v5.1795249365940711260.2.x-professor@outlook.com>
References: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com>
In-Reply-To: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: 1989a156-13a8-41fb-e5fa-08df47a9e1c4
x-ms-exchange-slblob-mailprops:
 Cq7lScuPrnrlC5lHdFGci+YUsdS3F/CIfto/bQICpMENGU2O+JVvkEXC7yxCyzyuJB7dkhoj20O6+REc3wKp6Az7NNYHeSfCqB6bEBqtJjcDSX/O+IQ2qvBIdCXXYEZQ78YIbpscvtw6Ie8M8LSNaihXOTQER5g+QSiQjnn2mMDzZMLMPR8srtIVgxF05rmPFvZ/ITw+o9OIXMimDiXLK2c5Ct2yCMSQUgl2M7oovwK8iUhDRg4Nb1ugm/w02aUrzEy/qpNWIGyzP7jUIbNEeQPSUe7lTW6PVOZtTN8ZVjLh1ffwD9GrGDaStRfY7E/vxngR6o7J/aygxusTFUYfi2bCiz4aQj69EhIYV30TvlTPEuYbkN+8JxvnGv4jlVAz3+rCReF8LZcBjnrXFV4UMq17MvSJFkL3SNHhnPHCcI8aLb2E1dwvR/6TKB67YDPSgIR1bQfk+We4PDPM81c3JPbQzPZr8/BY7JKRePlDyrDYgYjuIhvOwYjvP8nV1UHIB8J6aeyBqZSb5WzHmRnQSAOnkhuZSIDkfha6tQZdhEMyqa2+zSjwC1Xsc5uTJST7XDEi9BvNA1UpxZAmLbKzt+BEzH0lxdGzjZqsIQKIOnl6jU/h3pn2USWkSM+wgSMCMTdzH41uOC7WAx869fOHLvAyHW3WxJEL9obS6BuhWXoW0CMgLF06PSqsEFAi0K2QOaoO7YEqRrR6cwQR8kECLrMwEYQdVYgxB4ItoOyoq1qdNqXeRT3oSTtfQbtOoyccUZOcAbyZkQA=
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|19110799012|4140399003|25010399006|12121999013|8062599012|8060799015|16051099003|24021099003|31061999003|440099028|3412199025|102099032|12091999003|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?VQ0Pbs2Uub4qU1yZCqHakyhjd92CU2v6YTimbjMssemu3o66GxsUVm6u3v?=
 =?iso-8859-1?Q?hqY6bXmW8EVDGVDsy2O0dv5XH9ogyokxPH8WXr+PhY0hkBuymBNUDK7Th1?=
 =?iso-8859-1?Q?OPVbyTjXnDZtibhaR0cgwwTjoELBlnBEuoJdzhXMrzVY0WNtXjF0bsPUWe?=
 =?iso-8859-1?Q?Z1gH1egTHdbt1nKraavp7KFpQt++piXkRuYyJu+27erM4roiJgwFtc6aGR?=
 =?iso-8859-1?Q?/oNNp1XXsEUJl4TNGgmc1fWmfrLl8FMRI4Z4RsBiY+HeaTIgrbtBDLIEGA?=
 =?iso-8859-1?Q?fuew5w5yf/PEQ5nO9gulwneEiVAcoZC3W0JuWszrKyam3o4vF9oJNDPXrk?=
 =?iso-8859-1?Q?Gtv6hZlVUt92mOUXlBwXHSVM7pghmiDcWv0We9qZiHwX9e18AeLi3rZhSA?=
 =?iso-8859-1?Q?yh71OdXX3JagiSqxHXO/AMkpmAKkwF7Xb8lvvGIYjhvauDrAKV/Tpxm3v6?=
 =?iso-8859-1?Q?MVV+j8TV5Ho2O0l9WLgysoRDs0uwgn2kam5VCkuX11eG43LL9uJhOzlYX2?=
 =?iso-8859-1?Q?TwLzSFCgQIaAhYoihBeLkqqvocj5K3FkbZne+m/k1AT8MyfqBSWgSUMJOX?=
 =?iso-8859-1?Q?B9fPdhNaIM6+7J5If3bB3r1ZAf56aCcdCAVFPQhysC82k50ueLFaWIcsZZ?=
 =?iso-8859-1?Q?FS++0Ba0pPI1cPl2XVOVqkydZEA6z1DlijKGjteJ2OqBVnAtcydcMBW5sg?=
 =?iso-8859-1?Q?lJ30MO74dhw4DpPnMbzHMaNVKRFUxnXoSLRaCa8xGVrLAIpzHjYVmPPdMs?=
 =?iso-8859-1?Q?hoCu4I1isqz2V/1CBEQn0frFc4bjRr/k9tGOZM5wMh9bDmqKYFfiUi+ucJ?=
 =?iso-8859-1?Q?PD/4PFt8ia+T+NK1bcYqESq3Ilu4fSzbYRyjdDsZ0p6Rev4d08mVTeWoMx?=
 =?iso-8859-1?Q?ZqVOZYIB5voJD1wiUN7oWw05W0VTlvJC7xwYN/dZJP09jMG1JG+/ETVThN?=
 =?iso-8859-1?Q?HaNfp3i4VtpAYY1pJA3R6OPEfpIc8l8vMWvrhNg6Vu+2BEX9hHcSwTvZI6?=
 =?iso-8859-1?Q?oyHC1BpMWSqPK+CTSIhpyd8sR3r8D2AE/NSB5K8QYuD6uZ8V7e41rvG6x2?=
 =?iso-8859-1?Q?BqXqzD4wL1TBVnyDXwBVViiiHmonYliqQaDE6TmttXtIPfClNIbYHW6jlu?=
 =?iso-8859-1?Q?MyWqARlKpQ3SGqQixR7yizNQ6N3Alqa3AkPs3u2e0BI+HTLffxdJemB37z?=
 =?iso-8859-1?Q?nuhmX4P9hDc9k8UWjs9MSU0Etlo4y/I89+QXVDNs4Ld9OLDZDbeekjbW?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?bfcmJ9Wflm8McdX7QpQ5I+mfA4zw4Z6YGVCoct37gzVgkFwJEDO3J1F/cD?=
 =?iso-8859-1?Q?xt9K7lQlY0ojAKjcttWGxzn+itW295chVEmUCwLEbZSNUM73WGgNgIBD8Q?=
 =?iso-8859-1?Q?uD99554tLz7mneG/nvbCO7sNrmCD6G111OgLA11ISHUHAwU9JS9qT2dksk?=
 =?iso-8859-1?Q?hZ2D9qQuyHp9FASbRCrfxAnhgjytMoPVv2ZLvpN+Fo4zG5z8y/n/zV0bJs?=
 =?iso-8859-1?Q?sggSlLoJuN0bTcexuA170lYaeq+4Y9y67oySzUWFXQI4HrxgkVgQfErphx?=
 =?iso-8859-1?Q?OVcfWm8SNUJJblfYawXyL3MpyEWw8V2seJWybW7RaLeSS7RTNRRalRqKUw?=
 =?iso-8859-1?Q?soT7mt/X19U49GlsMWJaRBuLdasrgjS/UFkKXCPpBkmwrY1vXKjMXKDKDe?=
 =?iso-8859-1?Q?J90XLj0sqd5XR85Tc1i31aZ3yCgOnlYr4uS342IBpEj5qGIfhsQvgEOQom?=
 =?iso-8859-1?Q?zpVeHgIhcmwCJ6/tkiMJjVWA41xVHRTYX/iQ6R5yND6aw1ec4POVOuRADW?=
 =?iso-8859-1?Q?H6Kt91px3dVhdYXr1LW9KqQiIU13LIQ9Xj8GQhL499/8Nw5E/14fuVBw3A?=
 =?iso-8859-1?Q?5oeUzn3xOIJHXWYedtdg0DIpzgkWdBjY7L7/o6/RJrfIwMaDsxWDBLMgGD?=
 =?iso-8859-1?Q?KTChPbKEFZz7OX27y/YYuh5rfcrdTak2cyXxfexlksSti3EIIGwJ82zEcR?=
 =?iso-8859-1?Q?ypDfsXrL3l9zdoIlXyuw3MrIqth9v21F7k9JrJv+RZMdkNfGjm4opnDEv2?=
 =?iso-8859-1?Q?kiXyRNPyevG/N273f5xUa4FTdTVCMY6Io9n8RCHBDtsYAAb4Do3NP/kU+S?=
 =?iso-8859-1?Q?I18G/27MFt17sTb3ysPf7r9RdNiFEsxUi9yZEBnUNObOvxXlN4vjWlXnRt?=
 =?iso-8859-1?Q?rHq6LqqbvMvFOXHA6Lu9V8ApyOscJFF9CQsnYW51hKrMpR80TV9yp+ldNw?=
 =?iso-8859-1?Q?jKKTLF7yNoCoFGdw/yO1IZEUSlxWnWEvnZPQPon/MlKwH5cvnOTSjIQO2F?=
 =?iso-8859-1?Q?6eN8bSc42bNWMnu0N9otgNx/2sI6a/fHuNlvwCugOFi2r2nl8g+YtL0ZGO?=
 =?iso-8859-1?Q?KQ4e4lEglZdDSsoND697PEUmzvfsEx9P+StyFGwdv3kWqhNk4ylVCeDn7Z?=
 =?iso-8859-1?Q?Ef0CMahJuTu6/MCEPR4O1RTSFxfB8Nx2lL/JhRUiBatBKPdZpwRzOfbT4E?=
 =?iso-8859-1?Q?MSkk1lsnoYmUVSn3KVm3tVOw2jXUy0eMixOWkZTw44UqmZge05POExnPOX?=
 =?iso-8859-1?Q?3S4nekIalE/P4hjA3JPzDZX+QHM9JnIX6H3RVd4nAYTWJLZQAxUqealiLs?=
 =?iso-8859-1?Q?Kgl+KazPujfKtjt4zWgMSY1LVa91nOysNZ7BBhcNpkDxBk/NE9L+JdanyR?=
 =?iso-8859-1?Q?0DULi7NFpagXAQ6R20ixu/Ty2CTzFaowfTHAgtGaZBRmiH0UQCPVfnovS6?=
 =?iso-8859-1?Q?bwcnHe1pSgje/X/l?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1989a156-13a8-41fb-e5fa-08df47a9e1c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:31:47.2159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

The bsg io_uring path keeps its completed request until task work copies=0A=
sense data and unmaps the data buffer. A DEFER_TASKRUN ring can leave=0A=
that work pending while its task faults on memory backed by the same=0A=
queue. If completed requests hold all available tags, the fault's I/O=0A=
cannot proceed and the task cannot run the work which releases them.=0A=
=0A=
Save the result and bounded sense data in end-I/O, return RQ_END_IO_FREE,=
=0A=
and let task work use the saved state. The saved BIO chain holds its own=0A=
references, which blk_rq_unmap_user() releases. Canceled task work still=0A=
unmaps it, suppresses sense copyback, and completes with -ECANCELED.=0A=
=0A=
Use the bsg completion pool for sense snapshots. Only commands supplying=0A=
a response buffer with a nonzero length take a slot. Take it before=0A=
mapping data, because unmapping a bounced READ copies data back even=0A=
when the command was never submitted. If no slot is available, return=0A=
-EAGAIN; io_uring may retry a nonblocking attempt in io-wq. An io-wq=0A=
attempt that finds the pool empty completes with -EAGAIN, requiring=0A=
userspace to resubmit.=0A=
=0A=
Return the slot in end-I/O when no sense data needs copying, allowing=0A=
successful commands to release it without waiting for task work. Task=0A=
work returns any remaining slot before posting the CQE. Clear the saved=0A=
sense length on cancellation or copy failure so the CQE does not report=0A=
sense bytes that were not delivered.=0A=
=0A=
Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")=0A=
Suggested-by: Yang Xiuwei <yangxiuwei@kylinos.cn>=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
Changes in v5:=0A=
- Use the shared per-device pool from patch 1.=0A=
- Return the sense buffer in end-I/O when no sense data needs copying (Yang=
).=0A=
- Drop the unrelated multishot rejection and timeout snapshot.=0A=
- Rebase on synchronous v5.=0A=
=0A=
 drivers/scsi/scsi_bsg.c | 109 +++++++++++++++++++++++++++++-----------=0A=
 1 file changed, 80 insertions(+), 29 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index c17cad798326..d1ad956df9d6 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -16,9 +16,13 @@=0A=
  */=0A=
 struct scsi_bsg_uring_cmd_pdu {=0A=
 	struct bio *bio;		/* mapped user buffer, unmap in task work */=0A=
-	struct request *req;		/* block request, freed in task work */=0A=
+	u8 *sense_buffer;		/* sense snapshot from the per-device pool */=0A=
 	u64 response_addr;		/* user space response buffer address */=0A=
-	u32 max_response_len;		/* user response buffer size */=0A=
+	/* max_response_len is replaced by res2 after the end-I/O snapshot. */=0A=
+	union {=0A=
+		u32 max_response_len;	/* maximum sense snapshot size */=0A=
+		u64 res2;		/* saved completion result */=0A=
+	};=0A=
 };=0A=
 static_assert(sizeof(struct scsi_bsg_uring_cmd_pdu) <=3D sizeof_field(stru=
ct io_uring_cmd, pdu));=0A=
 =0A=
@@ -28,17 +32,22 @@ static inline struct scsi_bsg_uring_cmd_pdu *scsi_bsg_u=
ring_cmd_pdu(=0A=
 	return io_uring_cmd_to_pdu(ioucmd, struct scsi_bsg_uring_cmd_pdu);=0A=
 }=0A=
 =0A=
-/* Task work: build res2 (layout in uapi/linux/bsg.h) and copy sense to us=
er. */=0A=
+static u64 scsi_bsg_res2_clear_sense_len(u64 res2)=0A=
+{=0A=
+	return bsg_scsi_res2_build(bsg_scsi_res2_device_status(res2),=0A=
+				   bsg_scsi_res2_driver_status(res2),=0A=
+				   bsg_scsi_res2_host_status(res2), 0,=0A=
+				   bsg_scsi_res2_resid_len(res2));=0A=
+}=0A=
+=0A=
+/* Task work: unmap the saved BIO and copy sense to user space. */=0A=
 static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t =
tw)=0A=
 {=0A=
 	struct io_uring_cmd *ioucmd =3D io_uring_cmd_from_tw(tw_req);=0A=
 	struct scsi_bsg_uring_cmd_pdu *pdu =3D scsi_bsg_uring_cmd_pdu(ioucmd);=0A=
-	struct request *rq =3D pdu->req;=0A=
-	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);=0A=
-	u64 res2;=0A=
+	u64 res2 =3D pdu->res2;=0A=
+	u8 sense_len =3D bsg_scsi_res2_sense_len(res2);=0A=
 	int ret =3D 0;=0A=
-	u8 driver_status =3D 0;=0A=
-	u8 sense_len_wr =3D 0;=0A=
 =0A=
 	if (pdu->bio)=0A=
 		ret =3D blk_rq_unmap_user(pdu->bio);=0A=
@@ -48,27 +57,22 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_=
req, io_tw_token_t tw)=0A=
 	 * has exited, this may run from a kworker or in a different task, so=0A=
 	 * don't copy the sense data to the submitter's address.=0A=
 	 */=0A=
-	if (unlikely(tw.cancel))=0A=
+	if (unlikely(tw.cancel)) {=0A=
 		ret =3D -ECANCELED;=0A=
-=0A=
-	if (scsi_status_is_check_condition(scmd->result)) {=0A=
-		driver_status =3D DRIVER_SENSE;=0A=
-		if (pdu->response_addr && !tw.cancel)=0A=
-			sense_len_wr =3D min_t(unsigned int, pdu->max_response_len,=0A=
-					     scmd->sense_len);=0A=
-	}=0A=
-=0A=
-	if (sense_len_wr) {=0A=
-		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,=0A=
-				 sense_len_wr))=0A=
+		sense_len =3D 0;=0A=
+	} else if (sense_len) {=0A=
+		if (copy_to_user(uptr64(pdu->response_addr), pdu->sense_buffer,=0A=
+				 sense_len)) {=0A=
 			ret =3D -EFAULT;=0A=
+			sense_len =3D 0;=0A=
+		}=0A=
 	}=0A=
 =0A=
-	res2 =3D bsg_scsi_res2_build(status_byte(scmd->result), driver_status,=0A=
-				  host_byte(scmd->result), sense_len_wr,=0A=
-				  scmd->resid_len);=0A=
+	if (!sense_len)=0A=
+		res2 =3D scsi_bsg_res2_clear_sense_len(res2);=0A=
 =0A=
-	blk_mq_free_request(rq);=0A=
+	if (pdu->sense_buffer)=0A=
+		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);=0A=
 	io_uring_cmd_done32(ioucmd, ret, res2,=0A=
 			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);=0A=
 }=0A=
@@ -78,9 +82,34 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct=
 request *req,=0A=
 						  const struct io_comp_batch *iocb)=0A=
 {=0A=
 	struct io_uring_cmd *ioucmd =3D req->end_io_data;=0A=
+	struct scsi_bsg_uring_cmd_pdu *pdu =3D scsi_bsg_uring_cmd_pdu(ioucmd);=0A=
+	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);=0A=
+	u8 driver_status =3D 0;=0A=
+	u8 sense_len =3D 0;=0A=
+=0A=
+	if (scsi_status_is_check_condition(scmd->result)) {=0A=
+		driver_status =3D DRIVER_SENSE;=0A=
+		if (pdu->sense_buffer) {=0A=
+			sense_len =3D min_t(unsigned int, pdu->max_response_len,=0A=
+					  scmd->sense_len);=0A=
+			if (sense_len)=0A=
+				memcpy(pdu->sense_buffer, scmd->sense_buffer,=0A=
+				       sense_len);=0A=
+		}=0A=
+	}=0A=
+=0A=
+	pdu->res2 =3D bsg_scsi_res2_build(status_byte(scmd->result),=0A=
+					driver_status, host_byte(scmd->result),=0A=
+					sense_len, scmd->resid_len);=0A=
+=0A=
+	/* Return the buffer now if there is no sense data to copy. */=0A=
+	if (!sense_len && pdu->sense_buffer) {=0A=
+		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);=0A=
+		pdu->sense_buffer =3D NULL;=0A=
+	}=0A=
 =0A=
 	io_uring_cmd_do_in_task_lazy(ioucmd, scsi_bsg_uring_task_cb);=0A=
-	return RQ_END_IO_NONE;=0A=
+	return RQ_END_IO_FREE;=0A=
 }=0A=
 =0A=
 static int scsi_bsg_map_user_buffer(struct request *req,=0A=
@@ -123,6 +152,9 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, =
struct io_uring_cmd *iouc=0A=
 	u32 dout_xfer_len =3D READ_ONCE(cmd->dout_xfer_len);=0A=
 	u64 din_xferp =3D READ_ONCE(cmd->din_xferp);=0A=
 	u32 din_xfer_len =3D READ_ONCE(cmd->din_xfer_len);=0A=
+	u64 response_addr =3D READ_ONCE(cmd->response);=0A=
+	u32 max_response_len =3D min_t(u32, READ_ONCE(cmd->max_response_len),=0A=
+				     SCSI_SENSE_BUFFERSIZE);=0A=
 	int ret;=0A=
 =0A=
 	if (cmd->protocol !=3D BSG_PROTOCOL_SCSI ||=0A=
@@ -168,8 +200,25 @@ static int scsi_bsg_uring_cmd(struct request_queue *q,=
 struct io_uring_cmd *iouc=0A=
 		goto out_free_req;=0A=
 	}=0A=
 =0A=
-	pdu->response_addr =3D cmd->response;=0A=
-	pdu->max_response_len =3D cmd->max_response_len;=0A=
+	pdu->response_addr =3D response_addr;=0A=
+	pdu->max_response_len =3D max_response_len;=0A=
+=0A=
+	/*=0A=
+	 * Take a sense buffer before mapping data: unmapping a bounced READ=0A=
+	 * copies back even if no I/O ran, so rejecting it afterwards would=0A=
+	 * overwrite the caller's data. No response buffer means no sense copy.=
=0A=
+	 */=0A=
+	if (response_addr && max_response_len) {=0A=
+		pdu->sense_buffer =3D=0A=
+			bsg_uring_cmd_get_completion_buf(ioucmd,=0A=
+							 SCSI_SENSE_BUFFERSIZE);=0A=
+		if (!pdu->sense_buffer) {=0A=
+			ret =3D -EAGAIN;=0A=
+			goto out_free_req;=0A=
+		}=0A=
+	} else {=0A=
+		pdu->sense_buffer =3D NULL;=0A=
+	}=0A=
 =0A=
 	if (dout_xfer_len || din_xfer_len) {=0A=
 		bool is_write =3D dout_xfer_len > 0;=0A=
@@ -180,7 +229,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, =
struct io_uring_cmd *iouc=0A=
 					       gfp_mask, is_write, buf_addr,=0A=
 					       buf_len);=0A=
 		if (ret)=0A=
-			goto out_free_req;=0A=
+			goto out_put_buf;=0A=
 		pdu->bio =3D req->bio;=0A=
 	} else {=0A=
 		pdu->bio =3D NULL;=0A=
@@ -191,11 +240,13 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc=0A=
 =0A=
 	req->end_io =3D scsi_bsg_uring_cmd_done;=0A=
 	req->end_io_data =3D ioucmd;=0A=
-	pdu->req =3D req;=0A=
 =0A=
 	blk_execute_rq_nowait(req, false);=0A=
 	return -EIOCBQUEUED;=0A=
 =0A=
+out_put_buf:=0A=
+	if (pdu->sense_buffer)=0A=
+		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);=0A=
 out_free_req:=0A=
 	blk_mq_free_request(req);=0A=
 	return ret;=0A=
-- =0A=
2.43.0=0A=
=0A=
