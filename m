Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795249908;
	b=n2XLXC9s7TTzgmPB3xoMZkHw57YARCbZyfGLl06kouZHUbzZ613qSwrijqO2D0/D8UxY
	 A6bbAuAmUaM5oKLAloTNRXRbmwABgF5m4kZj816iJevmDgtZqgi1+u1bv2qmJDCJ1jT+g
	 jCerpAZhHt6nx2txbHq+35yT5J79gi5/0zOJbr0Kr/T+suGEADRIKwhJuxxwZ1Lcur/v+
	 Z/KWa6qc2hgE1wgsrlOQ0M4Pj70dyWLKEjP44N08ivGwqSHTyW3Pg9nZPhY6J14qsVx9K
	 p1FXOp94efXA9530tIU5rYzY3Vl5ZqsU6mTxLXsT9T/3R0WvPdLPZLRtE6kIezhpnCA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795249908;
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
	bh=0uvBPOrMJ1ZQ9Jn1UG6EYaPF86La3ppEqDldFxBojns=;
	b=DYS5DQuhNk/yuCFTcva+pmWlpX22GkgfTep5GJ/Pbqp+/6wFJJ3oYIoeeoSR486mAWry
	 b3Y/ikTbdB70rRGZ4LCNA3ILXhs8Xz5baUntmFW9gvok6+wz/dILBva5zDkFOoEEWcAtw
	 /C77efifSvvYgon/hpR11jiB1SCnUhCurGT21wPwLV7kco531rBwwfGm6LNCIpVNhp4VY
	 XptgVwX7hgq9NG7r3rHNXThRUcRX9K2Ohicn4fR/+7Yqqaxf07y3AW3geZNpEAARQ+29M
	 p5yUMTcOGBnfB/0i8U+VVZhrY2TNwgUXWjiDyKRtqLMqNQJpf8XTSqefDVd57VC9xhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ESTwExnF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.1.7
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011007.outbound.protection.outlook.com [52.103.1.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D62606A32C;
	Sat, 21 Nov 2026 08:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8D62606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ESTwExnF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4SneST2w52XFRe9B9BbX0p2FcrWHl/iOLJFJ8syezWhcVNPkL/fyNJ3unWhGdMsLw/aqtwomM0aHHUYdNCd1EAOxvC7GNZjxxtAzt6w7N5q2l23JL17fUxdaOrsIQcFFfngPE9JIK8K+9RX/GOIgHTzSr6GhNJtHuA8Z7T2pCphM5AdaDgqRsm+wTq7z3zJQltwWOZzCVjmpxYeneXBkgkgj4f7hy6n+TxC0GJLOYt0bNPSh6Oi/+aO3nzzr79oVDanlHphmLyreI2t6XUDAkqyeL6R8mq8K6kgiA1YD8cnz5lPvTiWPkWsulDoWx9MVVK0TQDCOvGb+HKK/jcRlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=0uvBPOrMJ1ZQ9Jn1UG6EYaPF86La3ppEqDldFxBojns=;
 b=X41MMtdiL0GFJ+7uLYk8k9wa4on23cRY+hNfO49ZJNYJpyEucaHV8xLAp01KtSWGlliR/gNcJSauvRimFbZ2uHXxjXKzbI2L5hTQqnbxxT2TAhTQBLniNZexs/CjvKSi5fy6n32MDPZ34K2kw7LuZIKa9HoinKZbKKm3U9o3IoVFik4HOD29Z+aswWKprGke02EDfslzKownV5XfdrOxvxMCcddk6ijwFPHFJuxPnyZ1vufxlTJrCfkAt4YyUqKFZvldnBi0R5HqE96S+9B1S1hZgkxhSj6pttUT7qR8tmQTa9/VUi+LOpSKAi3gyReFqzf9aVBV6WVLbdNEqRl8Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uvBPOrMJ1ZQ9Jn1UG6EYaPF86La3ppEqDldFxBojns=;
 b=ESTwExnF9aT35sfhf6JtLaapSe3j87tQyrf+ip6ZWOAmFD5oQ+M5ZClKbJOJKICWknAF5+w11i+ycB1zp7YavwEliFBzP4osbbj96ahSOUKIzpxRFqS2wDhSJ9UPsgPg4wX7NhDN/XEXBPn3fhxYY42N2mouI/epK4KOGUS6PZtH99fTC45lTvH3oOVWeshqMSOGIN0Po5sMEIZmN5cRdeXjr9FKR/nJaySsK0DL+v1ol8ehpjLP4MaZUYyXtMCIZ8PoR53OsvxUIC1R3w9xUXbuximHdtZCeN6ZTmuZ1KynmdSO18R9WuN9Esxl2Y7rG4jEr+7xB1IvKt8fu1cScA==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by SJ0PR05MB7838.namprd05.prod.outlook.com (2603:10b6:a03:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sat, 21 Nov
 2026 08:31:45 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.011; Sat, 21 Nov 2026
 08:31:45 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K. Petersen" <mkp@kernel.org>, Jens Axboe <axboe@kernel.dk>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, James Houghton
	<jthoughton@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, FUJITA Tomonori
	<fujita.tomonori@lab.ntt.co.jp>, FUJITA Tomonori <fujita.tomonori@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: [PATCH v5 1/2] block: bsg: add a per-device pool of uring_cmd
 completion buffers
Thread-Topic: [PATCH v5 1/2] block: bsg: add a per-device pool of uring_cmd
 completion buffers
Thread-Index: AQHdeZK9vNMbYnl+PU+kUvIbC0D1ow==
Date: Sat, 21 Nov 2026 08:31:45 +0000
Message-ID: <scsi-pool-v5.1795249365940711260.1.x-professor@outlook.com>
References: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com>
In-Reply-To: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|SJ0PR05MB7838:EE_
x-ms-office365-filtering-correlation-id: bbc19732-1fab-4c45-fc42-08df47a9e082
x-ms-exchange-slblob-mailprops:
 Cq7lScuPrnrlC5lHdFGci+YUsdS3F/CIU43HZX6+Yvz+JjMXAbonYJ29x2rHJlNOPoSaN7dlklWkr+BLsPmdTgvHcDQ98Z1gsTjliVw7zT3a9Ec3KzQST3Rl5EXE/eEmAJSALa4Uwau3kaKXf4+Q+QSbM2a1oMHUX80PTaSJdVGSNbMp1CSJA840Ti6XfbXDmUU2E28SJdSQ2pUzupRu9C9RJk16+i1iAX5gLffwzQcqjbYne3wJOj6EBIVMpWwUei3rIM+TTwQ4eNdv5VYOPZiLlFUGyYRQMe9FGBMe+onJz+qxYDuOeIUfcGDOYxtku4GtX9zzkQzDGLT/bl3FCca4KKf1Q3xCrx8teXNRTYtwnSzbV/dnQyKav8b0CynudyErR9m+716HuMTJjtCpAHwuM1aqkxPJr6qhrsRw17KyadxOGWdu/uOY8LQJ6ugIXyDR0/XCxZUswcWRGJky8CKXeMCbWYSMFMF7PurmWozMfvDk100xnDGQ2y5ZK0j81uqy+rUaSyapJwKzXsGYyykC4mom2yGVm6iCdTBMtwlqMZP5iIMGUdBk3CxMlwi1wcCQcm83jHNiF1tupW75Z/32UUTDOkuhj2dz7X2z64A5e9NsOTRXijXokI5qQsAN6lQPbfuPQF79Fe0Rs3iacrp3Ow5hLOaYGf1KiGCZ7uwwVaQCd1gjSVyAPmFyluCdpWqw8HjmbgcrSU+s3VshfFtOdIkVvqcHAKdzq0mo2fcaN/KlPwKsRF1TFn5PCUOmKDEfvYVnitM=
x-microsoft-antispam:
 BCL:0;ARA:14566002|24121999003|38102599003|41001999006|22091999003|15080799012|19110799012|4140399003|25010399006|12121999013|8062599012|8060799015|24021099003|31061999003|440099028|3412199025|102099032|12091999003|40105399003|53005399003|26121999007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?A59g73k3aZ7VavZ0/L74C70W/qPm3yxmtdq4JXQGCjdTR2R74swIOZz0fs?=
 =?iso-8859-1?Q?j/bFaHFvm83s6LP9IjU4yWTeIuF+qGM5QNS4vXNqtHy8SZqR6C1A1wH6jC?=
 =?iso-8859-1?Q?mNYLLzZFUwI9N+fwiU22PzRWXPwQ4j9ebsoGZBHpuVHZGgKT3SV9pqoYTX?=
 =?iso-8859-1?Q?MwCQq7SXPEhe/2dqqatWfrPeoerSJMGuv2BTYJj3m9e7/gOLv8Zxn/KWYF?=
 =?iso-8859-1?Q?Uf8ayMkjTAoEmt87Q9vIJdIE4cIJueNhMKENerGLBi64b1J9DcDPPphkQy?=
 =?iso-8859-1?Q?WErOS+xx0AgGut8etIh/T11pnow10tFmrkMrJWMhCKxX4shj7zfH5Bs8UG?=
 =?iso-8859-1?Q?w5OEmWFe3dI1TRnII2vuPJu8fDm6WmdfAH98FCOw3DNHKNaVGQQKN8zuN+?=
 =?iso-8859-1?Q?uLJouQAAxLdi9XSDAI8XemZUlKWV4mDq5EpyAXXZguaHvq6b+V+ijQXuD1?=
 =?iso-8859-1?Q?uA8dM3LBYnJ2IYY76XW003/RDIRKpmY74LuriiOb7cBIivxxDClfScoVAc?=
 =?iso-8859-1?Q?XzrA7/4nt2fJqrNuG7XShnINB1N01G8gK7Ib369zhX63jp2jlxxfRmyJrl?=
 =?iso-8859-1?Q?MEGU1H09rPnyjpi2wWz5LpOvQTzc8WSLJuglsuBizo9LaNjqWz4bvALrpd?=
 =?iso-8859-1?Q?ZgIOmUj6zxtWQHUyVc+R5++v4Hp3PC73nGX8vtV06+rIXJzYw7TClKFN+n?=
 =?iso-8859-1?Q?1beYXtxuff9/X5ifPQZZS+Cni88AVcdYNVHScnGIYDenjbFMxe+WRqbs6Y?=
 =?iso-8859-1?Q?n5Wxm2qTfT2LE6RHSsa7r1lpdfBa3fKB3X8LAS2bHuyYaEy8XMmoYtQqDq?=
 =?iso-8859-1?Q?n9oLBciT/w7uYJHDCh9vt89zVGeIHtky1syVLiBSRTCsNK/zOheVVbL9Ss?=
 =?iso-8859-1?Q?0xulzUwSMle5X3nZ9/jFbFPGLM+Syf2g3JdnFI3TnIA4n7GHj8CJhOpjbq?=
 =?iso-8859-1?Q?FGm8gzZrbpzV/BO4rasjvx48cRCASsEoVKgUgixKEH8tHUrId0/Mg1pRPV?=
 =?iso-8859-1?Q?ZBVkXJctSX9/vda+xSFDPMkVF+29rCKz5m/MF0ctGSK9f2uo/CyHsQezbE?=
 =?iso-8859-1?Q?KPzm0lNsUYmOcTJdtx0mZggKA67/ajWudvo32QPQwflTy/GLGrqP1kz2YM?=
 =?iso-8859-1?Q?IVRF5deeZQaS1qEVHMMHXlS+GLuaB+wQvuLnxZfmAAZPais9h+G9fqrjyW?=
 =?iso-8859-1?Q?6rs9+TpWGT7H8VP/WqchdAUKydTmysYnqWM=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?DpNTi6VN30P2M3fMpU5XmkNbQDDEC5Dp5d///6B5aZAVvGbLVWwWWftQfN?=
 =?iso-8859-1?Q?TXAOQuHN2idaP4Ro/S7JgVU02x9bDE0NMB33V7jexMy7FD+1BpdZAzy+//?=
 =?iso-8859-1?Q?OJBcdgtt+Bjz89rUtLA/s7VRO3ppSWxtuTkuQHGmxOEaouGg3/VP/NtCOK?=
 =?iso-8859-1?Q?0IXlgaciDQO1sqlaPXSQyQSI4Lkk+sKLKHbPyN4KTA3wy/t2eJZ7PIoKgO?=
 =?iso-8859-1?Q?PvZXkAkR2WVGH0HHvrsCKOY1ymIpfn7hGm6U3XL3HG0ks9/P89G4wegcDZ?=
 =?iso-8859-1?Q?hFb1xPLwQ9dmitQIreg6AhEEBghYt4WifhpCD6I4blu+AHtJbaxoGmQUop?=
 =?iso-8859-1?Q?saPMUxll6XGo18hQNLKS1RO+Yc9DSH9bU1fHeV2VVAP3J0Uw7o9TLBmp8m?=
 =?iso-8859-1?Q?5sDcGw+lKyh4d6nGmcv4HKXkECRgAuMu9H3s4Xl2gRf4ZCs7mWyx1bS9nA?=
 =?iso-8859-1?Q?l5gASQaHlfEiPnHFQ5cyM7DU33mjz7rFLn6fZnGQYn8DfOTsTcFuTnKcPx?=
 =?iso-8859-1?Q?VWu1gyf38g+mmHFWVczOV+3qAGHZod0EYCBBaSLED6JMuDiGZnBXj2HRHU?=
 =?iso-8859-1?Q?iYk/zz1D+vaRtCN/KIFw8zMiNt9KCjUg6TBGRpwy9RBwvkJcouQsUqn2Ed?=
 =?iso-8859-1?Q?UwHvy60aZVyjddmPOQFbRGViVX7XrNrDYZ0VXSDzo/vqgKP53DXxxQJQVL?=
 =?iso-8859-1?Q?LUHZG/1F83nXk75Y8dZs2sPGK69sO3cDScDp0j4YEI+sy+pJy+sx+azAO1?=
 =?iso-8859-1?Q?YguvBu/f1uHdjyBMcIA13As5Q+bR7mBNWLA+7njtvqvufh9+7JveaQtSsr?=
 =?iso-8859-1?Q?XTH8DvAfatLXJXzxna+MYWAl9uk3a+CHhjI3czE00xPIo1YMULMNyvGfW7?=
 =?iso-8859-1?Q?UXq/wdHSNhnCGGBKHwUqRnQt55j7uxHhd7CAnI1LsS0KWBTICBP5ArVy8W?=
 =?iso-8859-1?Q?YkVVhDLzISjqwkpOxznjvrFwmk8Te3yhILUBz03+XkosCcDuWnBi78Z3K8?=
 =?iso-8859-1?Q?uQgEGzcAGX/b031yyksojPs9DfXkdXhzMz3H1QPbaxVlsksIrAhKDL8Yt3?=
 =?iso-8859-1?Q?kKkniA7KrpVjr65Zb4SIWjwXFrWQBRSfcDuXTiTkQhq0MhvJQC3XOBcqh3?=
 =?iso-8859-1?Q?wBOkRlEuaH/RSv56+IqO591QqJYk/KVgD8ij9J/ewJ+HIqZnpLnIaqoaot?=
 =?iso-8859-1?Q?HSmRwoVvj5k7SUznvZXtiGDbbUmia0EbuZG//BDdKi427wLfPCqML9MF1H?=
 =?iso-8859-1?Q?7b/9OERC9vCvqh9g0Z90jzx0CO4gBnAaE7aB1WGj1OAitEcP/bnJJ+hbKH?=
 =?iso-8859-1?Q?9Xjk2+uR3gDEDqGv50AKNivs8DrID5MFNJtsqtqDP+Zgdq3HTqrT6LaWxj?=
 =?iso-8859-1?Q?bVPYUG+f28Lt6uM0xbOoEjvDXU41vxBQBZXTUzX/6TRRetqGahAJg0huD+?=
 =?iso-8859-1?Q?IkBNvFktL4mpNZsp?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc19732-1fab-4c45-fc42-08df47a9e082
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 08:31:45.0589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7838

A bsg uring_cmd driver needs storage for completion data which outlives=0A=
its block request when the request is freed in end-I/O. scsi_bsg needs=0A=
to preserve sense data until task work can copy it to userspace.=0A=
=0A=
Allocate a pool when a bsg queue with a uring_cmd handler is registered,=0A=
and free it when the bsg device is released. Each pool has BSG_DEFAULT_CMDS=
=0A=
slots of SCSI_SENSE_BUFFERSIZE bytes, for the only in-tree uring_cmd=0A=
consumer, scsi_bsg. Transport bsg devices and kernels without io_uring=0A=
allocate no pool. A bitmap and the buffers share one allocation.=0A=
=0A=
The get helper returns NULL when the pool is empty so the driver can=0A=
return -EAGAIN without allocating or waiting for a buffer in the I/O=0A=
path. Slots are shared by all openers of a device. One opener can retain=0A=
all 64 slots, for example with unreaped CHECK CONDITION completions on=0A=
a DEFER_TASKRUN ring, causing other openers to receive -EAGAIN too.=0A=
bsg nodes are normally restricted to privileged users, and sharing avoids=
=0A=
allocating a pool on every open. SG_SET_COMMAND_Q does not resize it.=0A=
=0A=
A checked-out buffer must be returned before completing or failing its=0A=
command. io_uring retains the file reference through command completion,=0A=
and the open cdev keeps the bsg device alive, so the pool cannot be freed=
=0A=
while a buffer is checked out. Protect the bitmap with irqsave locking=0A=
because buffers can be returned from end-I/O as well as process context.=0A=
=0A=
The next patch makes scsi_bsg use the pool to release completed requests=0A=
before task work. No caller checks out buffers in this patch alone.=0A=
=0A=
Cc: stable@vger.kernel.org=0A=
Co-developed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>=0A=
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
Changes in v5:=0A=
- Replace the per-file pool with Yang's per-device pool: inline bitmap,=0A=
  one allocation, irqsave locking. Return quietly on invalid get/put=0A=
  arguments and trim comments. The subject changed accordingly.=0A=
- Add Co-developed-by and retain Yang's Signed-off-by from his posted patch=
.=0A=
=0A=
This patch is a prerequisite for the following fix; it has no Fixes tag=0A=
of its own.=0A=
=0A=
 block/bsg.c         | 109 ++++++++++++++++++++++++++++++++++++++++++++=0A=
 include/linux/bsg.h |   3 ++=0A=
 2 files changed, 112 insertions(+)=0A=
=0A=
diff --git a/block/bsg.c b/block/bsg.c=0A=
index b296fa373292..73ec02ee8c23 100644=0A=
--- a/block/bsg.c=0A=
+++ b/block/bsg.c=0A=
@@ -12,10 +12,12 @@=0A=
 #include <linux/idr.h>=0A=
 #include <linux/bsg.h>=0A=
 #include <linux/slab.h>=0A=
+#include <linux/bitmap.h>=0A=
 #include <linux/io_uring/cmd.h>=0A=
 =0A=
 #include <scsi/scsi.h>=0A=
 #include <scsi/scsi_ioctl.h>=0A=
+#include <scsi/scsi_device.h>=0A=
 #include <scsi/sg.h>=0A=
 =0A=
 #define BSG_DESCRIPTION	"Block layer SCSI generic (bsg) driver"=0A=
@@ -30,6 +32,7 @@ struct bsg_device {=0A=
 	unsigned int reserved_size;=0A=
 	bsg_sg_io_fn *sg_io_fn;=0A=
 	bsg_uring_cmd_fn *uring_cmd_fn;=0A=
+	struct bsg_completion_pool *completion_pool;=0A=
 };=0A=
 =0A=
 static inline struct bsg_device *to_bsg_device(struct inode *inode)=0A=
@@ -40,6 +43,101 @@ static inline struct bsg_device *to_bsg_device(struct i=
node *inode)=0A=
 #define BSG_DEFAULT_CMDS	64=0A=
 #define BSG_MAX_DEVS		(1 << MINORBITS)=0A=
 =0A=
+/*=0A=
+ * Per-device completion buffers for uring_cmd. These can retain completio=
n=0A=
+ * data after the request is freed. scsi_bsg is the only user, so each=0A=
+ * buffer holds SCSI_SENSE_BUFFERSIZE bytes.=0A=
+ */=0A=
+struct bsg_completion_pool {=0A=
+	spinlock_t lock;		/* protects checked_out, including in end-I/O */=0A=
+	DECLARE_BITMAP(checked_out, BSG_DEFAULT_CMDS);=0A=
+	u8 bufs[];=0A=
+};=0A=
+=0A=
+static struct bsg_completion_pool *bsg_completion_pool_alloc(void)=0A=
+{=0A=
+	struct bsg_completion_pool *pool;=0A=
+=0A=
+	pool =3D kzalloc(struct_size(pool, bufs,=0A=
+				   BSG_DEFAULT_CMDS * SCSI_SENSE_BUFFERSIZE),=0A=
+		       GFP_KERNEL);=0A=
+	if (!pool)=0A=
+		return NULL;=0A=
+	spin_lock_init(&pool->lock);=0A=
+	return pool;=0A=
+}=0A=
+=0A=
+static void bsg_completion_pool_free(struct bsg_completion_pool *pool)=0A=
+{=0A=
+	if (!pool)=0A=
+		return;=0A=
+	WARN_ON_ONCE(!bitmap_empty(pool->checked_out, BSG_DEFAULT_CMDS));=0A=
+	kfree(pool);=0A=
+}=0A=
+=0A=
+/**=0A=
+ * bsg_uring_cmd_get_completion_buf - check out a per-device completion bu=
ffer=0A=
+ * @ioucmd: the uring command being issued=0A=
+ * @len: required buffer size=0A=
+ *=0A=
+ * The caller must return the buffer before completing or failing the comm=
and.=0A=
+ *=0A=
+ * Return: the buffer, or NULL if there is no pool, @len exceeds the buffe=
r=0A=
+ * size, or the pool is exhausted.=0A=
+ */=0A=
+void *bsg_uring_cmd_get_completion_buf(struct io_uring_cmd *ioucmd, size_t=
 len)=0A=
+{=0A=
+	struct bsg_device *bd =3D to_bsg_device(file_inode(ioucmd->file));=0A=
+	struct bsg_completion_pool *pool =3D bd->completion_pool;=0A=
+	unsigned long flags;=0A=
+	unsigned int index;=0A=
+	void *buf =3D NULL;=0A=
+=0A=
+	if (!pool || len > SCSI_SENSE_BUFFERSIZE)=0A=
+		return NULL;=0A=
+=0A=
+	spin_lock_irqsave(&pool->lock, flags);=0A=
+	index =3D find_first_zero_bit(pool->checked_out, BSG_DEFAULT_CMDS);=0A=
+	if (index < BSG_DEFAULT_CMDS) {=0A=
+		__set_bit(index, pool->checked_out);=0A=
+		buf =3D pool->bufs + index * SCSI_SENSE_BUFFERSIZE;=0A=
+	}=0A=
+	spin_unlock_irqrestore(&pool->lock, flags);=0A=
+	return buf;=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(bsg_uring_cmd_get_completion_buf);=0A=
+=0A=
+/**=0A=
+ * bsg_uring_cmd_put_completion_buf - return a per-device completion buffe=
r=0A=
+ * @ioucmd: the uring command that checked out the buffer=0A=
+ * @buf: buffer previously returned by bsg_uring_cmd_get_completion_buf()=
=0A=
+ *=0A=
+ * Return each buffer exactly once, from submission error handling,=0A=
+ * end-I/O or task work. A second return while the buffer is free=0A=
+ * triggers a warning.=0A=
+ */=0A=
+void bsg_uring_cmd_put_completion_buf(struct io_uring_cmd *ioucmd, void *b=
uf)=0A=
+{=0A=
+	struct bsg_device *bd =3D to_bsg_device(file_inode(ioucmd->file));=0A=
+	struct bsg_completion_pool *pool =3D bd->completion_pool;=0A=
+	unsigned long flags;=0A=
+	unsigned long offset;=0A=
+	unsigned int index;=0A=
+=0A=
+	if (!pool || !buf)=0A=
+		return;=0A=
+	offset =3D (unsigned long)buf - (unsigned long)pool->bufs;=0A=
+	if (offset >=3D BSG_DEFAULT_CMDS * SCSI_SENSE_BUFFERSIZE ||=0A=
+	    offset % SCSI_SENSE_BUFFERSIZE)=0A=
+		return;=0A=
+	index =3D offset / SCSI_SENSE_BUFFERSIZE;=0A=
+=0A=
+	spin_lock_irqsave(&pool->lock, flags);=0A=
+	WARN_ON_ONCE(!__test_and_clear_bit(index, pool->checked_out));=0A=
+	spin_unlock_irqrestore(&pool->lock, flags);=0A=
+}=0A=
+EXPORT_SYMBOL_GPL(bsg_uring_cmd_put_completion_buf);=0A=
+=0A=
 static DEFINE_IDA(bsg_minor_ida);=0A=
 static const struct class bsg_class;=0A=
 static int bsg_major;=0A=
@@ -203,6 +301,7 @@ static void bsg_device_release(struct device *dev)=0A=
 {=0A=
 	struct bsg_device *bd =3D container_of(dev, struct bsg_device, device);=
=0A=
 =0A=
+	bsg_completion_pool_free(bd->completion_pool);=0A=
 	ida_free(&bsg_minor_ida, MINOR(bd->device.devt));=0A=
 	kfree(bd);=0A=
 }=0A=
@@ -234,10 +333,20 @@ struct bsg_device *bsg_register_queue(struct request_=
queue *q,=0A=
 	bd->sg_io_fn =3D sg_io_fn;=0A=
 	bd->uring_cmd_fn =3D uring_cmd_fn;=0A=
 =0A=
+	/* Transport bsg devices have no uring_cmd handler and need no pool. */=
=0A=
+	if (IS_ENABLED(CONFIG_IO_URING) && uring_cmd_fn) {=0A=
+		bd->completion_pool =3D bsg_completion_pool_alloc();=0A=
+		if (!bd->completion_pool) {=0A=
+			kfree(bd);=0A=
+			return ERR_PTR(-ENOMEM);=0A=
+		}=0A=
+	}=0A=
+=0A=
 	ret =3D ida_alloc_max(&bsg_minor_ida, BSG_MAX_DEVS - 1, GFP_KERNEL);=0A=
 	if (ret < 0) {=0A=
 		if (ret =3D=3D -ENOSPC)=0A=
 			dev_err(parent, "bsg: too many bsg devices\n");=0A=
+		bsg_completion_pool_free(bd->completion_pool);=0A=
 		kfree(bd);=0A=
 		return ERR_PTR(ret);=0A=
 	}=0A=
diff --git a/include/linux/bsg.h b/include/linux/bsg.h=0A=
index 162730bfc2d8..f5560be80c20 100644=0A=
--- a/include/linux/bsg.h=0A=
+++ b/include/linux/bsg.h=0A=
@@ -20,4 +20,7 @@ struct bsg_device *bsg_register_queue(struct request_queu=
e *q,=0A=
 		bsg_sg_io_fn *sg_io_fn, bsg_uring_cmd_fn *uring_cmd_fn);=0A=
 void bsg_unregister_queue(struct bsg_device *bcd);=0A=
 =0A=
+void *bsg_uring_cmd_get_completion_buf(struct io_uring_cmd *ioucmd, size_t=
 len);=0A=
+void bsg_uring_cmd_put_completion_buf(struct io_uring_cmd *ioucmd, void *b=
uf);=0A=
+=0A=
 #endif /* _LINUX_BSG_H */=0A=
-- =0A=
2.43.0=0A=
=0A=
