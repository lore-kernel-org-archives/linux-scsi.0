Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.92
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249905;
	b=rT2hPuzep8A5Owm7pu06E03/E8UaWZSlcxXvqAWtrKw9BnNwb/NgGRh4kb6HL7csEUiF
	 5ajrSxebKP/LvlAFbPQ4GWuNXzfCpt1wpfMfMq00vcz/BlX8m7sfOMJbgHDQP+H2p0Lqd
	 S0Szo47QYh4M+sWeUfH+kDbFybT1UyOYPNjajny2c1pAAIDW2fkK3hdwketAEQ4fVs6aq
	 jbANYpBTdP1Viz3l11vr0a4z3LblZUQCl6wXx+psgMkmKIa0AAknjsQwTNwfaoZwLw1AI
	 uu0BTDlaCJ2/MIfSsV7y8xsyOY0ZbXLA7+dy5xwBvfyQnsBXT/bc85i12kn3AGh+8Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249905;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=9hhaK+m4+JhqG3LefLs2B1Fo9ZX6tXtrncg6SPaUQ08=;
	b=mbS8PUF8btohEOGyXdcNpFOlTZjqDjIaWNoOg4W2cmR3w3ZprTtrD7jzek6OogY7Mxw8
	 XuvvB0eYgb8qeyKl6OgthpvMoPtGaoArxSinzspeU6/RV6k5XjE5UbcPlFci5f4Zm4K8O
	 CDiJPxloiexXQDUUXruMpVChWHqbiOrBD1DGTsZ4nLdIPTuicAAFRkTbzz6/jwwFawIrf
	 tkSGH7iWTnd0uMxSlIjdVc5cbwZ9+nOBWxGy409B40rcmmP80zasJ/hF47Fj7iQkrdh6Z
	 tKs3h/59WQp6eJr1yIeHSJqMy6zvHREDBoS3sIB46iNL0290AUy2MNS52FUSbrhPDCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Pe3Is7q8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.20.92
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013092.outbound.protection.outlook.com [52.103.20.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA3F606A320;
	Sat, 21 Nov 2026 08:31:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADA3F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=Pe3Is7q8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JbJVfYE0bWpg6uK/RQNiZ6vD1x+d+kg4jbeVTUw8iUkM5aZt99HchuGHBsexMcvzSoQzewIMQyKaS5RA7cjmvl9KOR/HLGapMWV+xKnvAJBPdBph+o9hBhUJvuJQDP7AQe9vME9qdU2zaYYtt0obBgvVCRAOzNWvJEJlRdCH1JXsUM2R+AgJyJKAU/Pd80XLI8q4poQ3hgOo7pbkgCbKzyi8x1KLkBsPu8fFjmvfbfQUIYS/RhgcCOyFLZdwkCActMJR6qldDsrHJxQNMvXr9dA3dy/Uzb97O5Hqkhwkzysqhc6WRBHgBAvJT9n+cfHuQEG3wbYhBZGG62HEtbK/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=9hhaK+m4+JhqG3LefLs2B1Fo9ZX6tXtrncg6SPaUQ08=;
 b=ld1scWnQYGbT31UVAdiap7QLj0+4WEpADIwj6f9Ag4syMriiBMFlbHtKXbTmNAGSjfqCxBEw7H1yKoeoMLSIdJaw6HUnqFllNAwiHa1Eq83Z7NPg3xwPhUPsfNOcNMYzMM5JKq/IwL3ZzDutO/8JbcdZ8ry9izp3GUmTyKPgTBgZZe3Mk6qNs7fIDFlZvwvWB5fVOwxxJqXDHVpdDIDuIjJv7X6b3fcs6FEeVZGuzgPNGEql2MkSVSezFbo41UzyZmDzbZdAdAp9xJZAlgIEoMq3oPp2jT/VayKm3Ftai4LtdDY6FvcKI52WPxu2Wzh2Va6uTW7gSHyymokLa09WHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hhaK+m4+JhqG3LefLs2B1Fo9ZX6tXtrncg6SPaUQ08=;
 b=Pe3Is7q8ShgtpeTLkOseoYRfRbMGWJK8/2fMyUmSZ2vRJK6G2asUkAnRHRswsz+Zau7uOaDCoSL3H9BiFVW8/Yt983qGi0odOXoMzADIT2egfnd24bc4Y0qfheU3MLVMiAdwZQi1K7o9sBz9CtIZia1/V+Tno1lt0BF7a2D8nUARDD17Bx0+aJIi3GOSAEc3cGNVpEwJxXNGWL6kPRYwMo03BQImTKUsbcbshCuwYK/BcrNJObQ2mNOKoFLf+FWF9E8s8PBaQXpfnFYWeJ74LwWcgqw+y7nQnXFbvk/s6/e7yHRqRsmT/SFQqfaJbZUu5QOEerS22yRmcNHxWfqpKQ==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:31:41 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:31:41 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, Jens Axboe <axboe@kernel.dk>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, FUJITA Tomonori
	<fujita.tomonori@lab.ntt.co.jp>, FUJITA Tomonori <fujita.tomonori@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: [PATCH v5 0/2] scsi: bsg: Release io_uring requests from end-I/O
Thread-Topic: [PATCH v5 0/2] scsi: bsg: Release io_uring requests from end-I/O
Thread-Index: AQHdeZK7udGfR+FNIUyr+P+yp9nEKQ==
Date: Sat, 21 Nov 2026 08:31:41 +0000
Message-ID: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: 96771470-d745-4048-858f-08df47a9de6e
x-ms-exchange-slblob-mailprops:
 iS5pQZgsAQDZd5pLvsexcGXRgbvG27NWE/23ZhfMaHmrqer6NrAclKSSbOIDFX3GPdzCwViZb4skAE8M0mjLFxwlZC9e7Jb4jMQ7cXkKySlUQjWdvuNrahPf1nHshgzagDRx+71cSyS0M6Fm3IPOx0GSPG/pWyrLAOLiCQmGz0NSSzwQfq8azTZxLnk5oo5sInFv4LYF/SnyBAt4vaZ1nntYTinakewRffGZIbln6x6ok4y4MbcMp3Z4nsrOVXUsGYmfAlyqjBdxDO0GrXqr81Ze3KfSXiaGxMTfQS1tJD3+bL2e8qGrXx9Nsa1dYWrJwm1vwhp3RtGf5r1TQUuV4tEMkxoqfvgNmo4yHuEQ62d4CJDwpeJUn7A7PhXQ17q9shygBRf23iDYAgm3hb51io1bnATgXcGNK8FrQwYR4HrJN+fxS9Vb9EGOYZF/S1MUeMcjsAGPiIVAKNJnlNUZa1anjp3CpPLjMn6pr/tFprGO03/R/0VpNCtME78ehUI+5KHblbrQNBGjgT84L5oeRl+c3dFZQPGDUjasZlVUJ/rUj/2r8UHUqZFDXzglzZnGiF8i0Bf64LXDI/KPt1EK/4pUAvsKChjA003nvxBJhBZ5zQtAxuVMsBmOIxGl8w95Se9OSViLJ7zYOcaTYYL9HcBfPriYFVhssYD0wPdSsxSCaMadZpIpdDR5F8idMqBbZ/Pqr4+lOCdxOhkLYFsW1QPWdohkuZVvUUU9wvG2pXkXzHfgadXIA8Vf+FOSGI5JMSv2klhg65rjX0WAgccF82O6779P+6XUnt5OCnMIK79brLcqCm26cQ2K5NdCPhOA
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|5062599005|19110799012|4140399003|25010399006|12121999013|16041099003|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|4302099013|102099032|1602099012|12091999003|10035399007|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?8FX6EVYLDYyKFPkvlQGetKdjwss4gmQ0qF42YT7fwtPKYE1gYqneO7kCcE?=
 =?iso-8859-1?Q?H4XL35HYr4TDo+56z0BqGYv1S0B27VRfe051nc/iFaZ2fU5MVQvHqRTsPY?=
 =?iso-8859-1?Q?RfLNgqARZiUrB8Y+K95IWSItxkIMeDFm1ghU/y1ZGaiyEgYqhAqg78F4Ey?=
 =?iso-8859-1?Q?AOzZl2R/cPsf80wgW2b97R2jfm4x4g+dDnU+kYndve2h+rn2ZkTnQDMixo?=
 =?iso-8859-1?Q?0pYo/zS1ccsd9UXOX0xgtBfAokhmJAp88s4Aub69SmsFEGSj3ImbF+CqbH?=
 =?iso-8859-1?Q?c5IeJB1XICQuxnFpc3l1amKXE+GKXy75tbk/+vzaRk65sQrXL82sReXjlW?=
 =?iso-8859-1?Q?HRTRGjrm0LYxiJGj+J7Tadu5YR9JNaw+SsfdzKZO/ZXXHxJnZwlKxfVknS?=
 =?iso-8859-1?Q?gQXMTqIKAVPmIKuMKiAIIpkEJ27RI6hvX2RIvDuaga0WPvPh69IKfsxbg5?=
 =?iso-8859-1?Q?c937+pZHniu1H4AAOxE2w/W2BbBN52Ri6uuNSnYe7taruOXYhhMfNBjcJS?=
 =?iso-8859-1?Q?tLlYymcqzm6uSK8K1a42ftE8b1ijGPoOnEhncOt8MfpherwfHYnbDYSvOx?=
 =?iso-8859-1?Q?hmMIryi/dLg7bgDE7sVIiZm5f7aTzERa8Go2TAIMpNEsVXlHXSHh8fLr9/?=
 =?iso-8859-1?Q?4BhMTGX7n1qGzEdrsNxrDsDEEV+DAzTC1St3pSNSto10MlYMG0JbEZLrse?=
 =?iso-8859-1?Q?K/CehhYKuYWIVhlsr3m0e/8dY7kufpsneCB/JjbcL7Z/xp0KXXq7rsuBEv?=
 =?iso-8859-1?Q?ZQysz/MvVSXEYC8rRk2cMp4Rv+4OL9tkgingU9FmsDGOEIjD+oqAxbwhbL?=
 =?iso-8859-1?Q?AUyzD8NwOePa+bQYQJmldvZQiqKw9Cdkv9PmoYzbo7r8FrqUl0eIu1oTQ8?=
 =?iso-8859-1?Q?ws7Nu1jNxY0IIfXy7sxZWNA/vz8dLvJS/knb5hIcPK9aKJntwU1T7qmKcZ?=
 =?iso-8859-1?Q?+PBAdQrTcvGhazlffhGpfpXVe34XzXpDhd4s5hKLxfvDUGcw5SKc0Qgvsa?=
 =?iso-8859-1?Q?XAFoayc8EoH1ZRxcjhbXarpcsAIUSE/K/7tyTtPz6+2Zz+Txg2M3WEIkRq?=
 =?iso-8859-1?Q?//2/AmlINaDa/+nvnPRBe/XuHWHxr9/aygQPq0J4ypZiQTbCaorUfVqJ58?=
 =?iso-8859-1?Q?rfl6b6U5PwddUYAMVg5MQ5EcPjADOjlZcPnJ26bDM4s82yU+sqTNxRPYJt?=
 =?iso-8859-1?Q?0ICJDSkjgh87SKVLSUEihvelEswtjyk9VB1abKr34m6ILyLjKOyaiZjrkU?=
 =?iso-8859-1?Q?8UEXTtVJmTmDQvvW5Wa/ZK0aI1S+SvgITJndqpFE2iRRE1XLo1sTchJ5n7?=
 =?iso-8859-1?Q?0lhs?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?v0bidxpiJoJ9H9ktcmfrzofMelaVH3JMMkvPNDiN6KwzPwFuiBFWqJ1wJE?=
 =?iso-8859-1?Q?69bp0yUHneNmjtRkeYvCJj4oZiRU0do8K0nQl/WHU2VHh70C1V9SeN1CBw?=
 =?iso-8859-1?Q?Xj2CZXxbhecMQ+ePLZPFzlHDjag3OUWdoor+yhn4sYYVKKRWwtYZj856Cv?=
 =?iso-8859-1?Q?pGy67ccs874k19EilGol5ZcGdPiI5yJCKUMsr3As0YmEeVda2wWfIlKxWx?=
 =?iso-8859-1?Q?YSyQOWoSt8G+9/ogA+Eew38iRTaZyM1kxumRgTw/MkTbqsmx6bQgJwsVS6?=
 =?iso-8859-1?Q?t08oBHAnad6PFuDSmthI7wTSOvRwTV1nLFNVTNYXj7xkSOxjWhCdN9THXc?=
 =?iso-8859-1?Q?okHN1BdS9vG7NImN6rVQSvOGB7Z6ZHzUxPsr/K4R5a/gaZTAVJRL6l9Oo8?=
 =?iso-8859-1?Q?hhjcJ7T8Q5le/fFQaYhqPxCl3RODMqKVIe0c8Uti4K49onu0M9P53Ccixb?=
 =?iso-8859-1?Q?IRgyPD00Ww8spOR035/GZ6V00rsnl9qLcAcSIC0rT97ElkPGYSpwYpwSIf?=
 =?iso-8859-1?Q?LAeZtHDBWQKHNJQ8kkExqHrVCGgWP+P5ZmblvhYKYAsQZ67xg3FgXBUxoV?=
 =?iso-8859-1?Q?GIgBGWIJ6Bl+PBz7EBFZ77aOwN5b5eesfyQW2XiZh+npD4nQLwYE72zdx/?=
 =?iso-8859-1?Q?dDUBKBOEfwznA5yCRYBcBmoopuVJ8/K++76zKgKu+AuZCpAmqBL+ZStSR4?=
 =?iso-8859-1?Q?i8DWPPYrXkd8Y6kIUTnFPZbYnh5SMVeP7WIRw16SydRrB2rh66alM1PpDV?=
 =?iso-8859-1?Q?xL0U6F6JXUfiMFD5Q7Z7R1eez82K4Ia7sM5cHimQV5SL5DX5sYYvHLJIak?=
 =?iso-8859-1?Q?O8L9rmqunYTK+hWxknHN0GXguKFoxZJs55wdjzkiwaGDoUeXfrBGS1SSmN?=
 =?iso-8859-1?Q?KybhWNd4Qvte3cIByV66HIfq/j4RBCm7QADcp7WXpRcmZO4jgZlm+m9jO5?=
 =?iso-8859-1?Q?IjXhqnkRSPW6puVsPKzkOVgzsZTXT7nZFNPPovP5g9kHs+YdEomafQ7Vdf?=
 =?iso-8859-1?Q?iMBoqfqtu1GVn4BGi1y2U6v7EHDkfJTYP+flnobIo2rHaD4wUz4Wojdorx?=
 =?iso-8859-1?Q?UnYph8bZwUFeGhqzI0qoGNzpnJRnPNOh7m4CAAQ5mmbAUF45uQK8bEdxMn?=
 =?iso-8859-1?Q?Nze2Z5xfxtZv6Wr9wLTPtR9O+M3ltM5lhRB6EfXwMUjuByXGGXCuie5Reu?=
 =?iso-8859-1?Q?+HOD3w1OpgzNqCXF9AbVZrwgJ234VFvRzAVYldkZmhUb6u1yDJI5QZCl8u?=
 =?iso-8859-1?Q?dqUUelvczXsd4kXcE7Hicfl5uxkfm6G6unFqPDPReKB6AWJygi8S7EZCxT?=
 =?iso-8859-1?Q?cStwk/r1ARBwuhPz2WVFJePTRWT4uetVZnHC4C40L40Z6ki95ShlMkrQ5Z?=
 =?iso-8859-1?Q?KCkt3h4rsYJYYuzLwu1/DxtacYv1V+XM31SUzwUHExTYSD6zT065Ym3Xf7?=
 =?iso-8859-1?Q?5w0Br7Eh6yDX7Q4P?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 96771470-d745-4048-858f-08df47a9de6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:31:41.6497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

The BSG io_uring path retains completed requests until task work copies=0A=
sense data and unmaps the data buffer. With DEFER_TASKRUN, the submitter=0A=
may fault on memory backed by the same queue before running that work.=0A=
If completed requests hold all the tags, neither the fault's I/O nor=0A=
the task work can progress.=0A=
=0A=
These two patches save completion state in end-I/O and release the=0A=
request there. Task work uses the saved state, unmaps the independent=0A=
BIO chain and completes the command. They apply on top of the four=0A=
synchronous request-lifetime patches posted as v5:=0A=
=0A=
https://lore.kernel.org/r/scsi-sync-v5.1795249365940711260.0.x-professor@ou=
tlook.com=0A=
=0A=
Patch 1 provides a BSG-owned pool of 64 sense buffers per device,=0A=
allocated when its queue is registered and freed with the BSG device.=0A=
The bitmap and 96-byte buffers use one allocation. Opening the device=0A=
allocates no pool; transport BSG and CONFIG_IO_URING=3Dn allocate none.=0A=
Patch 2 takes a slot before mapping user data and returns it in end-I/O=0A=
when there is no sense data to deliver, or from task work otherwise.=0A=
=0A=
When the pool is empty, the command fails with -EAGAIN instead of waiting.=
=0A=
io_uring may retry a nonblocking attempt in io-wq. An io-wq attempt=0A=
that finds the pool empty completes with -EAGAIN, requiring userspace=0A=
to resubmit. Slots are shared across openers: one opener can retain=0A=
all 64 with unreaped CHECK CONDITION completions, causing other openers=0A=
to receive -EAGAIN. BSG nodes are normally accessible only to privileged=0A=
users, and the series accepts this shared limit to avoid allocating a=0A=
pool on every open. SG_SET_COMMAND_Q does not resize the pool.=0A=
=0A=
Changes in v5, following Yang Xiuwei's review and example patches:=0A=
- Replace the per-file pool with a per-device pool and a bitmap.=0A=
- Return buffers with no sense data in end-I/O; use irqsave locking.=0A=
- Embed the bitmap and buffers in one allocation, remove the redundant=0A=
  buffer-size field, and trim comments.=0A=
- Return quietly on invalid get/put arguments while retaining range=0A=
  checks, double-put and outstanding-buffer diagnostics.=0A=
- Credit Yang's pool implementation with Co-developed-by and retain his=0A=
  Signed-off-by from the posted patch.=0A=
- Drop the unrelated multishot rejection and timeout snapshot.=0A=
- Rebase onto synchronous v5.=0A=
=0A=
Tested in QEMU on 9f9e0b1e5399 plus synchronous v5, with KASAN and=0A=
lockdep. The 960 regression checks and release-order tracing passed:=0A=
completed io_uring requests no longer remained allocated before deferred=0A=
task work ran. Cancellation, linked commands, 256-command pool exhaustion,=
=0A=
64-slot recovery and concurrent use through two opens passed. A rejected=0A=
bounced READ through a second opener left its user buffer unchanged.=0A=
128 successful commands returned all slots before running task work.=0A=
No KASAN or lockdep reports were observed. These tests check ordering=0A=
and behavior; they do not reproduce a same-device page-fault deadlock.=0A=
=0A=
Dropping the multishot rejection restores the base kernel's flag=0A=
handling; the tested multishot-flagged commands completed once on both=0A=
kernels with normal, DEFER_TASKRUN and IOSQE_ASYNC submissions.=0A=
=0A=
Each patch passed affected-object W=3D1 builds. Final configuration checks=
=0A=
also covered i386, CONFIG_IO_URING=3Dn and PREEMPT_RT with SCSI=3Dm. Kernel=
=0A=
selftests were not run.=0A=
=0A=
Successful INQUIRY batches were measured on non-debug kernels, with=0A=
three interleaved boots per variant and five rounds per boot. Both v4=0A=
and v5 used the same synchronous-v5 base. The table shows batch time=0A=
divided by command count, in microseconds, with a 96-byte response=0A=
buffer supplied. Retry time is included; base has no io_uring fix.=0A=
These timings were measured before the multishot rejection and timeout=0A=
snapshot were dropped, and were not rerun; pool allocation, locking and=0A=
early return are unchanged.=0A=
=0A=
  mode    depth   base     v4     v5=0A=
  normal     16  1.587  1.593  1.646=0A=
  normal     64  1.158  1.165  1.195=0A=
  normal     96  1.066  1.231  1.165=0A=
  defer      16  1.582  1.589  1.643=0A=
  defer      64  1.155  1.166  1.198=0A=
  defer      96  1.065  1.228  1.161=0A=
=0A=
Compared with v4, v5 increased time per command by 2.6-3.4% at depths=0A=
16 and 64, mainly due to irqsave locking in the control measurements.=0A=
At depth 96, early buffer return reduced -EAGAIN completions from 32 per=0A=
batch to about 9 and reduced time per command by 5.4-5.5%. These QEMU=0A=
measurements do not establish performance on physical SCSI hardware.=0A=
=0A=
Both patches retain Cc: stable. Patch 1 is a prerequisite for patch 2,=0A=
which fixes 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler").=
=0A=
A backport needs both patches, in order, on top of synchronous patch 4/4=0A=
("scsi: bsg: Release synchronous request before user copyback"), which=0A=
changes the same file. Both pool patches exceed the stable rules'=0A=
100-line limit, including context; if that rules them out, I am fine=0A=
with dropping the tags.=0A=
=0A=
v4: https://lore.kernel.org/r/cover.1795016239.git.x-professor@outlook.com=
=0A=
Yang's pool patch:=0A=
https://lore.kernel.org/r/20261119031751.3471968-2-yangxiuwei@kylinos.cn=0A=
Yang's follow-up:=0A=
https://lore.kernel.org/r/20261120021604.2648220-1-yangxiuwei@kylinos.cn=0A=
=0A=
Yingjie Wang (2):=0A=
  block: bsg: add a per-device pool of uring_cmd completion buffers=0A=
  scsi: bsg: Release io_uring requests from end-I/O=0A=
=0A=
 block/bsg.c             | 109 ++++++++++++++++++++++++++++++++++++++++=0A=
 drivers/scsi/scsi_bsg.c | 109 +++++++++++++++++++++++++++++-----------=0A=
 include/linux/bsg.h     |   3 ++=0A=
 3 files changed, 192 insertions(+), 29 deletions(-)=0A=
=0A=
=0A=
base-commit: 9f9e0b1e5399045982788a954d3461de894e40c7=0A=
prerequisite-patch-id: ef4b390580d84500ee98fcddff0a34e5cd95e40c=0A=
prerequisite-patch-id: 1b98fea4540409102179bfccd2905a686c7f1b5a=0A=
prerequisite-patch-id: ce66c68fb99ef813e5506ba7f3de512c1fd0c832=0A=
prerequisite-patch-id: 73942e82ea57898fb0af8ee1db909b0dfa8b2b77=0A=
-- =0A=
2.43.0=0A=
=0A=
