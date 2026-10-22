Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.10.90
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792637713;
	b=dCU+nxSsvmvqVHcJASQz8VppmsT1pZclaKexTca0ZecjNDakrZtJAhe8WX60SGYdmbif
	 ls4IcHlH6o4YTOZDdKt5RjatLr+33Od8c9QMRC9s38kV8SnvPcB76u/4LcYaW5BldGutb
	 OM4mZEV6W/jwJjmaNRwu9TBw+IEBj8X6/oKY8i2uAp87PUFuZ69I+D6Ufdlj103AfsMJG
	 qxL+Ie9wTVxUuMRgkL5U2YILnscfU5hF6yd9xYtWFX1mE2066qvas7f1Eh+cLvats3i9x
	 HwbtK+8IdlPwsubBoSBrW3TmvoDU8RWM/Tp1B/fD91U1hkdIcJmo4F4jMRkOWJwtTDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792637713;
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
	bh=L1z/+g7eyLl25a5kEV9dPZfR4ME4wLnhepX+seQuUNU=;
	b=1clN3xTPdIos6T8z287c2lES6ood5KJ+0TyLu94e84TchJF7LuVHdploOGlY00ELe1Nk
	 9yPuP439VSrnobFN8Rguv+YCBbvt2gptfnaVxJKQYjYtNcPX9568uBEgAf+JEDR16F2sA
	 6n1toWwPEvgy6msQoGLIKQ4qqyD4H5RoNiVksGRYJtHJKFUfDrtwDD5sYkwM1+VAreEjD
	 rDd2kuEgfDYKMmB/l2J+OFryTyHb6Imst7SWAlgVFMnWwFYDKl9YcFGCoPgk3HgopybX8
	 0Q05wtmpdF4smiIAcmXlHxbMEwWUVwhT0lkopYuZkz/gGDKBmRy95Kz+z3ISd51Q8mg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=G9qcuaAq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.10.90
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azolkn19010090.outbound.protection.outlook.com [52.103.10.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4BB606A319;
	Thu, 22 Oct 2026 02:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF4BB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=G9qcuaAq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzbY/eWYQeczeQlDg1SzuOXjSZaqcWv55CdAlPPpZvYxHBd15sMLbRmSKNDQ1uGdYW5Lx7/YOol1bjDO6KO7GluXDejQABSBw9yXZIZyA0Ic0R68rb/F9az38+xCIz8ywOmpr1pFU6Ufn9FYewxxpmpCHybg8av0PI6bbTt65Fs0eoQAtykqPX5wX3mpIQcFQISaixNih/+5qJZ0eyQVz0cDFzZU3mi/kR81YRQ9K9HZlgJqZulUnhC5/ZUxZBiH5s/vNz3VXSqphEaX0DOGyEvNKSXwEz5K+bxXhHiVZNeUv6f6ha/G8P4IO5LUf2iPeqnRUq++tXaPlavcOiz/QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=L1z/+g7eyLl25a5kEV9dPZfR4ME4wLnhepX+seQuUNU=;
 b=w8qHZr8z4c+84ZSNRyB97mkbuU93nfB0c1vtJGA/co4DEhuZOoU1OLz3rdd93B9x77UMAB+NyAsS6bBNAediGNB8VPcIEu663Zot9A9XEAJyBXW4dzCwHmAw2s/WijU83Nrx2eO5GteE8Zq2O3wuNLB/YOd2YB9op+M0u6A8TVtFBB4vlQOwIhxWxe22eMPwZikPotbr+dDuEvIshu3Q5F+bDMd49HgDRDYJ2o24QWQbQWcqocwhHNcDnVuCnnLVtCsggPlhDL+ZbUC0YnSTfC5z3BRIYzvxFZno/9vDLbER7dIWpo9NG55ARoKfHT6gj3WpziXa8z3V31NOoFYk8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1z/+g7eyLl25a5kEV9dPZfR4ME4wLnhepX+seQuUNU=;
 b=G9qcuaAq4bfqjOknfSRTSreLJiLjHBh3GrWJxR+2zAyoBJPivKvMbGaGBa7O5UByeT6ztziP/7K3q8QAXRRNZJoXQyij6enrQZK6JHUQF3JnhXx0A9P0hBOlO12Ix/hHWYlIagf1t0lsiLDMEJZ4EfN+ZhGjfAppt46+/Xebt3nrYz8q/fR01hmz3x5rrwjftoGfgG88NrR8jZsmq+vzFPnZ0mV15cYXWsCz4i5KL0GTX0Qf7IwapyzsbSTDoMYJBdWRFc3aXW2XQtFu9+bnla7JBEYHO1PMvhLeuTs9JS5hSzJQD6l3AMPzbiSO4p8SHardgpG5yC/o2c9yrCEN5g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by CH8PR05MB999376.namprd05.prod.outlook.com
 (2603:10b6:610:32b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Thu, 22 Oct
 2026 02:55:11 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 02:55:11 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, Jens Axboe <axboe@kernel.dk>
CC: Bart Van Assche <bvanassche@acm.org>, FUJITA Tomonori
	<fujita.tomonori@lab.ntt.co.jp>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3] scsi: handle out-of-range SG_SET_TIMEOUT values
Thread-Topic: [PATCH v3] scsi: handle out-of-range SG_SET_TIMEOUT values
Thread-Index: AQHdYdDBJGl5uKAnFk+VBOCapEos+Q==
Date: Thu, 22 Oct 2026 02:55:11 +0000
Message-ID: <20261022025508.294713-1-x-professor@outlook.com>
References: <eb20226b-cfae-4b10-b42c-1b12c2d17687@acm.org>
In-Reply-To: <eb20226b-cfae-4b10-b42c-1b12c2d17687@acm.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|CH8PR05MB999376:EE_
x-ms-office365-filtering-correlation-id: ddf27e42-c7e3-4e04-af42-08df2fe7e383
x-microsoft-antispam:
 BCL:0;ARA:14566002|38102599003|22141099003|8062599012|25010399006|19110799012|4140399003|8060799015|24121999003|22091999003|41001999006|31061999003|15080799012|24021099003|39105399006|1602099012|40105399003|10035399007|26121999007|102099032|3412199025|4302099013|440099028;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?YuXRIo0xyH4FDxb+Ze7eLNfwe+FdSoS0IORCxGuTk89vbBQYwgm38jbPkU?=
 =?iso-8859-1?Q?otL/SSVybeJtNhbbDN+P+d+qrU4U4Yx8eUf4k+1UmukOeE6zVcEg9gIabI?=
 =?iso-8859-1?Q?sy+7Dlsntznqh3ICiYAUkXQKErdT4rErboUhse1Vy3c69Gp68H94Tnd/li?=
 =?iso-8859-1?Q?yF0zGDSECm132LUJ2IT2zK/zx4J4RRMCj/+k81fODukoQHKrst6TfVXWC7?=
 =?iso-8859-1?Q?wMrwEEr+MikH3Kky0ro953hAiH70iA0vAZj8/Y9TYgiB3QA5oV8678umC+?=
 =?iso-8859-1?Q?LpbekLvmk0EPyLADOWISVHOjCvU4njuZwSS+99hXf7OgFM7sT2/1AvJeHc?=
 =?iso-8859-1?Q?OzNojwwghghEGrabAXSKOmICXal37/h2PLsw9829lE7VMug3dn7ce3m0dF?=
 =?iso-8859-1?Q?7PIldVRShgnCQ7YsxCgGRS/+gqr8K4QPyKTJcoboL9pTsrIypqMoJPM6c8?=
 =?iso-8859-1?Q?mZF6KzQqzfV2JYV48ben25OsvkBBuAmweydmRYR42MuGwiJm8ycnZx+u9r?=
 =?iso-8859-1?Q?24ED/q/JK4aGpwOqZWHpfWdK0H62nbpIzTlmK42dWRdypnvBPTnk1D7Q5E?=
 =?iso-8859-1?Q?j2ez1wq8rqSPdL8HxpaB7G9g7pD+epMsQ40F4qQVZVjZCWQ4RE54P2mu/q?=
 =?iso-8859-1?Q?JYD/q+i5v5hqRYXX7X+ft6sT9n2oNQGUOi+dy/0T4uMKoBQ0BAGjHHsNHo?=
 =?iso-8859-1?Q?zSsphj6TSvgMKdRBfrKCoIPhpU8O52uLRbTjlxza7QdjUX8okqXuaZL6Gk?=
 =?iso-8859-1?Q?7tDNeVNKo4dUX+aD9I1XhjoPoS8l8kqbQctcL3Vc+4Zh6nfieLwea/01EL?=
 =?iso-8859-1?Q?0dvCS4TqiSUs7pwsogXCgnUXCA4ZBs16bgaS49ihlanomls8r1NInj1Xqf?=
 =?iso-8859-1?Q?psJ58/FxcTY2DrodiiENPSXox1ayQXnn/ReBecFZ9qlrIvJuQ6lyDKkU78?=
 =?iso-8859-1?Q?FD081cDCA17OzWuP91o/6CgJJqtleI/5VEXekLA7hP8OJXtyFAY+k43MK1?=
 =?iso-8859-1?Q?aH7t4FuGQ/5WdQBHFrlvWW5Rgxoej6mveL2pPcrC1YkxZW1Bt8Xe+miuj4?=
 =?iso-8859-1?Q?HWcd9G0YG4JnnxZKwq2y4h+OZnRTATOC/Z4/vIVtVanrCqBQsbCFE9tRE1?=
 =?iso-8859-1?Q?Y76MLDA/8DMcIO0O2ML3Z5JkKnMemE2XNd8w8NGQIRr4+/gpEG0dpTz2ab?=
 =?iso-8859-1?Q?8SG/DpROtYFYUyHUiSUExhjoPvM4F1BQY2c=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?1Q9riuRVMqXS1dZvi9yzklT+FJ4nxSLt7veWybXIKukUvzErh9+VZ8mBhI?=
 =?iso-8859-1?Q?IRSRRJosKDBfh5rjfVfcOJXn6ov5T4aAu6JzqDtGxacYLJ82RtmXS2XkqF?=
 =?iso-8859-1?Q?/HKFngGGdHp1FmykvAvefIpa+IcfQintRReWN3QvwZltwcG6xNh5yCXl7+?=
 =?iso-8859-1?Q?BhORzRAuUNdt0Bv96rg6QUEdJxp260QHf+8w726mf80imCgJxLCApLK7cp?=
 =?iso-8859-1?Q?OUsjl6xm1H3AWA/MsgNLJ4il215Itkp+dHRQdTT8HZOyZU0EQPBamgnGdE?=
 =?iso-8859-1?Q?tTRZvOcRDhq54NGJXkTruyTJu/AvGgiW7z8MrBne7xN1nJAChclQbb3Crg?=
 =?iso-8859-1?Q?FqJptPf4T+IiiNPruizQCbsmUUam6/nXLoIMZ5R7CHEwIzMpDElTOKaepy?=
 =?iso-8859-1?Q?zqM5eR2NPMxJ8h4o8SgM7mu2SnvJ3juLXv76YexG5GZTSDUW/UzAR5Nege?=
 =?iso-8859-1?Q?CMKtMv8cWac8EX/YkEF1+Ix8q457+GT4wjRlX8cf8xJsNtCv/aBBjvsikz?=
 =?iso-8859-1?Q?GP7nTTLsXTyTFWd92uQ3REtOnfja7obI+cEZkNUAgV3V/iMhyO9DKUr52P?=
 =?iso-8859-1?Q?Jns5PRadsfd7p7BJkFPTe6Nl4g6OFNFh9QmB7W+C2t82Yn83iD/tEVKppi?=
 =?iso-8859-1?Q?MO/gcW/9/BKEhR5gqG1961yuGqEvHmu/+tuSsdIu7pdyItjFORK/y39zOR?=
 =?iso-8859-1?Q?riRw56xDthaeb79G+0/7UgebLBcjNYpjBt3Ff2bRdRPtmzJsaVvKfwFo4m?=
 =?iso-8859-1?Q?C6SYpVeTjf83y5qwOVfkv6qMEIRh3UlakI46L95toEG/hf5lZcby/Br3SM?=
 =?iso-8859-1?Q?eZToFKeK0YYDyZYandyuMa+kFA8XUSsgfeh2YyK+78cpxmT8Lip2er4YF1?=
 =?iso-8859-1?Q?2i65rO4buut2stmY2qEcCige9t/KVBJbwEYdRJYHwcD5CucX7zKpK/FdOB?=
 =?iso-8859-1?Q?t2FfxhC1s+ScLIeKVyn3SGqE4d2EllnSVqLfYieuqtbyG38AiRvaYAmOxt?=
 =?iso-8859-1?Q?P4nzLjVon1EbSiWBIpeKaFSt25H4cKvWqci2MgIqqSZRIwqY+hZL5riEpu?=
 =?iso-8859-1?Q?yG83nVyf8hWqkDdixcB0eMe3z6CGK6CIuyZWUh0QwbmS0AL/kdwSwHSSqJ?=
 =?iso-8859-1?Q?zrl49MH2BnmM0xTPJxHBfWgGPNxvKk3y17iCzPO6yMND8eABbRXpCMrjU0?=
 =?iso-8859-1?Q?OYcMfujZlwuSrOBhF9rq5KGU+HFN/bmL96qvwiGxrczSRhyt5hDiHVhT60?=
 =?iso-8859-1?Q?aq9VcaJ8yYk4ksWVSyuFKOdhr42uR8Mx89es7AHPlltzidJAAEJcb5tA1P?=
 =?iso-8859-1?Q?bbO99/xPbuItz6ViT+xXsvpZ2m9ypvjVB+yaY9SBqnzZNtTXf1XmksuR/9?=
 =?iso-8859-1?Q?4/IPvH1szncj0yqjzpL1dR6r0zLKgdHSxyM8VmtuRHeriNz1GbAr1qykzW?=
 =?iso-8859-1?Q?81Pb8IfiQ80bWx9C?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf27e42-c7e3-4e04-af42-08df2fe7e383
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2026 02:55:11.0688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR05MB999376

SG_SET_TIMEOUT accepts a signed int in USER_HZ units. The sg character=0A=
device rejects negative values and limits positive values so the converted=
=0A=
timeout fits its destination field. The block SCSI and BSG paths instead=0A=
pass the value to clock_t_to_jiffies(), which accepts an unsigned long,=0A=
and store the result in an unsigned int.=0A=
=0A=
Negative values are converted into large unsigned timeouts. On 64-bit=0A=
systems, large positive values can also exceed UINT_MAX after conversion=0A=
and are truncated on assignment. With HZ=3D1000 and USER_HZ=3D100, for=0A=
example, 429496730 clock ticks become 4294967300 jiffies and are stored=0A=
as 4 jiffies. On 32-bit systems, an overflowing conversion becomes=0A=
ULONG_MAX, which is an unsafe relative interval for the block timer=0A=
comparisons.=0A=
=0A=
Reject negative values with -EIO, matching drivers/scsi/sg.c. Saturate the=
=0A=
converted value at the smaller of the destination field limit and=0A=
MAX_JIFFY_OFFSET. This preserves successful ioctl behavior while avoiding=
=0A=
both narrowing wraparound and an unsafe 32-bit timer interval.=0A=
=0A=
The block SCSI behavior predates Git history. BSG has exposed the same=0A=
behavior since it was introduced.=0A=
=0A=
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")=0A=
Fixes: 3d6392cfbd7d ("bsg: support for full generic block layer SG v3")=0A=
Cc: stable@vger.kernel.org=0A=
Reported-by: Bart Van Assche <bvanassche@acm.org>=0A=
Link: https://lore.kernel.org/r/9321a59c-c560-4742-8b71-5b0ec1f30c2f@acm.or=
g=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
Changes in v3:=0A=
- Use the type-safe min() macro instead of min_t(), as requested in review.=
=0A=
- Keep MAX_JIFFY_OFFSET in the effective limit. It is defined as=0A=
  (LONG_MAX >> 1) - 1 and therefore is 0x3ffffffe on 32-bit kernels, which =
is=0A=
  smaller than UINT_MAX; the i386 HZ=3D1000 boundary test exercises this ca=
se.=0A=
=0A=
Changes in v2:=0A=
- Add the pre-Git Fixes tag for the block SCSI path.=0A=
- Saturate large positive conversions at the smaller of UINT_MAX and=0A=
  MAX_JIFFY_OFFSET instead of allowing narrowing wraparound or an unsafe=0A=
  32-bit timer interval.=0A=
- Expand the commit message and boundary testing for the positive and 32-bi=
t=0A=
  cases.=0A=
=0A=
Tested v3 on x86-64 with HZ=3D1000 through both /dev/sr0 and BSG. Values 0,=
=0A=
1, and 429496729 round-trip unchanged; 429496730 and INT_MAX saturate to=0A=
429496729 USER_HZ ticks; -5 returns EIO. Zero-timeout SG_IO requests still=
=0A=
complete after setting the timeout to 1.=0A=
=0A=
Also tested v3 on an actual i386 HZ=3D1000 QEMU kernel through both /dev/sr=
0=0A=
and BSG. Values 0, 1, and 107374182 round-trip unchanged; 107374183,=0A=
429496729, and INT_MAX saturate to 107374182 USER_HZ ticks; -5 returns EIO.=
=0A=
=0A=
v2: https://lore.kernel.org/r/20261021181804.136336-1-x-professor@outlook.c=
om=0A=
v1: https://lore.kernel.org/r/20261017084547.2880694-1-x-professor@outlook.=
com=0A=
 block/bsg.c               |  5 ++++-=0A=
 drivers/scsi/scsi_ioctl.c | 11 ++++++++---=0A=
 2 files changed, 12 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/block/bsg.c b/block/bsg.c=0A=
index 82aaf3cee5825..b296fa3732924 100644=0A=
--- a/block/bsg.c=0A=
+++ b/block/bsg.c=0A=
@@ -132,7 +132,10 @@ static long bsg_ioctl(struct file *file, unsigned int =
cmd, unsigned long arg)=0A=
 	case SG_SET_TIMEOUT:=0A=
 		if (get_user(val, intp))=0A=
 			return -EFAULT;=0A=
-		bd->timeout =3D clock_t_to_jiffies(val);=0A=
+		if (val < 0)=0A=
+			return -EIO;=0A=
+		bd->timeout =3D min(clock_t_to_jiffies(val),=0A=
+				  min(UINT_MAX, MAX_JIFFY_OFFSET));=0A=
 		return 0;=0A=
 	case SG_GET_TIMEOUT:=0A=
 		return jiffies_to_clock_t(bd->timeout);=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index c14f81403a09e..81a0519a2984b 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -9,6 +9,7 @@=0A=
 #include <linux/blkdev.h>=0A=
 #include <linux/interrupt.h>=0A=
 #include <linux/errno.h>=0A=
+#include <linux/jiffies.h>=0A=
 #include <linux/kernel.h>=0A=
 #include <linux/sched.h>=0A=
 #include <linux/mm.h>=0A=
@@ -195,10 +196,14 @@ static int sg_set_timeout(struct scsi_device *sdev, i=
nt __user *p)=0A=
 {=0A=
 	int timeout, err =3D get_user(timeout, p);=0A=
 =0A=
-	if (!err)=0A=
-		sdev->sg_timeout =3D clock_t_to_jiffies(timeout);=0A=
+	if (err)=0A=
+		return err;=0A=
+	if (timeout < 0)=0A=
+		return -EIO;=0A=
 =0A=
-	return err;=0A=
+	sdev->sg_timeout =3D min(clock_t_to_jiffies(timeout),=0A=
+			       min(UINT_MAX, MAX_JIFFY_OFFSET));=0A=
+	return 0;=0A=
 }=0A=
 =0A=
 static int sg_get_reserved_size(struct scsi_device *sdev, int __user *p)=
=0A=
=0A=
base-commit: 58161ead29e50d70a317ea26b472e0c7508e69da=0A=
-- =0A=
2.43.0=0A=
=0A=
