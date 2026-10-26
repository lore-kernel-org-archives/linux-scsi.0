Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003385;
	b=jmcLWcCj6G8hhvgw7FmLrzClxD6XmiP2LoNZiV6KP2spd9+0OumXociDSpphRP7jRDPp
	 QYMRH1J6IwRqxMLZMdvcsEIB5gdfbOSISdEy4pzsQTmBpHo59j8XTFle8blSI4diApp9c
	 x0HTNk5KsO70Jcyuy4BDBIncMjvX5omiUCE+9Yu0z3Q8bmC3JPLMTWzqyDqEWo39jHU8I
	 /VfoQ2sABzbIVHc/vn+E5mWRUR6cFZsdK6BRNRI9DSZiglsF5T9skJ+K/ka1EBufbR3P1
	 zg4hhRQd0eeF7vqeQNnOVfSIG8UENNrNMob75lBIvhtSnaMrAtR5BAh4SRHAvvejcSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003385;
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
	bh=1NnfTiZifvd6YXbXdopTDFngx+b/l/B3BkHXqH+b/gA=;
	b=yUI0LkzdM+uYhxTFFmp2Fi3Ftas4RpwvcWh8xTj4pThQIPsqeTkQrq7BHgXn1R0fks+X
	 4vOid3UXSeW7fIwChLHBGBOdipd9UaGa5XlQig/Zn3NxKYqXFUr9QttybOORS4zqW95HJ
	 aaWR1wf4zw2nEXWFMIlZdTka2pfFhz4SjF1lUhlXihcQng2Q4ob1BbCmaaPf2Bg5oj3ba
	 +O0N1TVvZgKRTv8LBWxZ2gwdS8p8bZq3CHVEtNuv5L4fxks/6HADLhQTC5wg9xjiPnU2/
	 iSTob2cjIn6cVgT7BYWJAasWugVcEgjhTzUGZKe895Wro30srIpI9ZgvLlLxbZaDg7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=EeHiMdyH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9286760A381D;
	Mon, 26 Oct 2026 08:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9286760A381D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=EeHiMdyH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AIGYHELeXZvQQgkHGLygAjYGDN2Tw+Aj1C+k/8vUD4OHDlRgLy312mh5glROM6E69NaaLK6Abl13DaEEkTKe/nRdGHNMq0wfIqqRZCCAjdSoCEbVOzFAYNiNBLIRyLhmWqawg5RRBBCNdIewpfd5JBW6ZRyphXrcdI3nS+NrRSxDCZ3pDPrasXPP3tOQ8U9DxCKNWNNqDj5sGOlgelrUI88R9sqVvuYkY0CYphDYCccFDj0fzpbYdYT7DOIulZMyNjvm0+Kl6ZRztHs3VzkBGFHyYNiMWQA0vZqEIrveKrLoDpJRyt4uD7AybBGpD1u4P0SaP8gDu16mGbcyMmnBKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=1NnfTiZifvd6YXbXdopTDFngx+b/l/B3BkHXqH+b/gA=;
 b=u+x4mH3fyEdpE6h4YPYs526TpnJ4xX8M1kyfC1h+/o0B/+13Yf6pbv2jmGC/v5kvhZ2unXfrTH3IoiG3zlg+J4ApdTXtCfQmKHfZMlJDt7T5VTuOk9LsN/+svJ8J9kUblPeRdbRpc8YmkGhoWH/cINR4IiaVcbPMtKyUq/hId6rkaxjKKZS/uItcO4r7mEYKWg3ipQuQSoGssCayltM3tLgsYNy5NCWaKbRpNhx3/ZCiA6g0qAql1/GIt4PwuVzt3pK0sr0lzOfz5wMyPYJsf47LtbMO8FTJGv2LCtx2RUXuDe1BUsVGKuuJ4S2QRib0xOTzUji7/mOOol+wNmeaog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NnfTiZifvd6YXbXdopTDFngx+b/l/B3BkHXqH+b/gA=;
 b=EeHiMdyH7nD1qpbkx0b6nzclXHujXunC2FGOenNfNZajr2IIMtURd0nYSTqiWJ+eVYs9dTkJdxi1mWevNIZIDpTYOdAzfDfv0JzyMSUARVQBEwEPB5IkeZZfPBsqUlIl6+d17qVfNpAwt3NthF3W0xeGcI/oQDnFtBHMB0iphKfZ0TJ5rRjHIBh3bS6BOi/c7G4bMkdEjB5nj1aL2HLII8zWZpS1+rxEz1gp6LWdfwzg8OzYOxlVsXl310GMbMKZiTWVncCW96alIErlBKjTWHGQkSSbfeIMFKyo8h9CkzedQFLjsfo2NJpyXeAzX1ULi0PMsDrBS9ooNtbjeewryQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:41 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:41 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 6/6] scsi: bsg: release io_uring requests in end-I/O
Thread-Topic: [PATCH v2 6/6] scsi: bsg: release io_uring requests in end-I/O
Thread-Index: AQHdZSQlwL4bxblsuE2dHhgQENbwtw==
Date: Mon, 26 Oct 2026 08:29:40 +0000
Message-ID:
 <8f30e238d2b169702308303687e9504c7513ecc8.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
In-Reply-To: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: d33776e6-8a79-4bf2-222a-08df333b47c4
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|39105399006|41001999006|22121099003|22091999003|24121999003|31061999003|38102599003|10092599007|8062599012|19110799012|8060799015|12121999013|16051099003|25010399006|102099032|440099028|3412199025|4302099013|1602099012|12091999003|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?f567+3EHpC7dyQjaZpeGWCUIe/7aBjZZliXXlFGE/kwQF4J4V4yqjVOCCm?=
 =?iso-8859-1?Q?cdn+4uL0O01+xesShGNC+hP8aI9o5b8CLanRRV+5JGPi2IMKfiYtA3zCCf?=
 =?iso-8859-1?Q?K6KZ63O7DB99IVMie2zC1FhaYPdjxzWPPFlp5qqYyqihOsqzyOFIA+UzAE?=
 =?iso-8859-1?Q?5WFfeJOnPHYn6Sr/qPtzBwc5jXtLmeNyOmonN1nzNg5EvQyOjk7qqohH8m?=
 =?iso-8859-1?Q?CbKT3poHpNGUEIp1xoo+dmZJTInFxk2jSwX8qe0rpQdjajTTtwiWuO+tXq?=
 =?iso-8859-1?Q?RMCQVGMBE/S6V4adspWgRxoHZAj8Pdbt4Lsh5bFWmHiO/qWbYNL3+wEO8v?=
 =?iso-8859-1?Q?4lH2JpYYEsAa8lw8q9BmwvE8zhq3isfL6EXIsOR+wwwJg1FKgKt537qIQb?=
 =?iso-8859-1?Q?7qUQXL1CHvHQp8RuDxsq6eAPLCcEDAL4t/QRUv58rqXzya8Omhpj7ST3Uw?=
 =?iso-8859-1?Q?GG1yFcD8ce/9rF1VkLuz17kLk6+2DmC6rhX/TtH6JReNye1u8ZIrGomK7A?=
 =?iso-8859-1?Q?kEtcK15PBorNDtECfgngna9LtuJtgFTKeGcZEga9Les7wfHIpv+OE3jzGe?=
 =?iso-8859-1?Q?t8oEIQIvJZ6kfOxmcTEQAYB16x3Tvv7sVbhkNh7wdfv6EyhXf69MmPVGOG?=
 =?iso-8859-1?Q?pcth276/BMBzPizDj08ORt9TtAIGekvFZ2lYeZ9QJ5/vP87GnS25lcA/Q9?=
 =?iso-8859-1?Q?f/PY5+b5s+PnsufwQa/0FsJteuczwzl0pfWs8DUCn6L6VNvL78hLy0VVO0?=
 =?iso-8859-1?Q?Wk60YZfNpFuM1fbJ0nwgyUK8sY/Sa4lw2R/yJYrubDLjeO3rGZYkd7BJB6?=
 =?iso-8859-1?Q?//XRLlU1069gPcoWBdEcMhe6JCmzJ8ImlteIXkh9JGlzeXA4aJSDFNryHa?=
 =?iso-8859-1?Q?8jeluegFvh791mb4RkBRM3XyuA1uW9lmWix7KsazwSZUtXJ0i6tHwHKjJn?=
 =?iso-8859-1?Q?3ZPfbwejElQYgtqOu4R8m8TuhZeqMJFZjyOYiykxoqIV3ilju+IKvNTaQF?=
 =?iso-8859-1?Q?jvD9dhCGoO5NY8gA0EFyvyvGMqITf2w+5y7haWhj6S+YGHTYFoSMKCL4lC?=
 =?iso-8859-1?Q?Ww3Y/akXx+uGJYLNp9eZEpWCslywgnFPZAd0/15NmPa3r+eVLCkDT01AUw?=
 =?iso-8859-1?Q?8aPQvSjb0GwxoNXAw0scuWd6VSnIqcM9kmtumSJtix+Nb79tMwPR55CZNz?=
 =?iso-8859-1?Q?WFYrODB+CZHNfX8jec1Gz/cor9nc7wm+SCfJTeEjO+SduvywgGmjTa3kd7?=
 =?iso-8859-1?Q?2HPObCLrVWcipsKtE+oWQei8cO4pxADQYdE5U9sHyqUISQ9FWe5GGya25q?=
 =?iso-8859-1?Q?fq1+O9qaz1a22+vSlUWRBvBUPor9hx/Ah3RlP2pmFEEP5Qk=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?gMq3lC7gJIBnY5Bc/Ffmx5vHsxpSAAyxg59CkfV0Fl3Jvbb7QCUwh/WDpS?=
 =?iso-8859-1?Q?44VWiFcxD0mRuABjOR77i1K7fsNMLeMypXJ1rdGflegrKeh8G3n5uOFMEr?=
 =?iso-8859-1?Q?+XB1Gzw320sUpLydfAp3+055+ZbiitJT7hLGlKB6E9gcPp7vQ3+N9X37pu?=
 =?iso-8859-1?Q?VCRFNN/xynKQlW8n3qLBMQTcf9NN3QFufC9v1q/bL2+S0cbsGW0mesJ6s1?=
 =?iso-8859-1?Q?XCMPKuoqqTPepi/NWB2UKLqNjJpp8Zv2/mOiDZDdLgcBasBaAPyS5orPYe?=
 =?iso-8859-1?Q?pPY4gJ+kYA0tcZQdjMf2yZBi2qhFsg6+KEH0YddKaUd7tMC6VQQMQULatU?=
 =?iso-8859-1?Q?exC8W/BTaT0vhF7UCLFwnUO3De2dNneKgrfJ+mROKQ0ybnK1jTAY9tqquP?=
 =?iso-8859-1?Q?eOhbxXyaXMFQu/0vAQ5t1yL+Dt7z+Jl14tGh+Zvw5qgvAVfmAEUkG+LvYz?=
 =?iso-8859-1?Q?ikGsqFybNyxbqGM+yyIRpF+EUTmO4P+QJnKuuudayVpj942CQhKe8SLOvz?=
 =?iso-8859-1?Q?zt9ySvPRKmQPGYgeptkBb8hEgNwRny0cUCMQ+80cISfYZi2QA00GO5bNk+?=
 =?iso-8859-1?Q?82RzWHoS2kqGBq03YI7yoPkVOQqLpXisZseCYv8KqCixMxxibitHmnt1V6?=
 =?iso-8859-1?Q?RdBN7zjTmFiX4yJWRtTDlTFSJynEM/wx1DnezkErOmcYbZaWVmEIcR5Y5+?=
 =?iso-8859-1?Q?rdiUYjvIvW5hoVmSWzLfbZCK4o7wyXMW5/G6eLXSVibHBr1+350KgRAJ4+?=
 =?iso-8859-1?Q?aweGCqPNE0HPD4iVyNNJqYXnQcA7ag+z6+mN3/PHzbxl/PIyuzo/G60bcy?=
 =?iso-8859-1?Q?ot7KLi1nV/Q2+UPeHszCNtNihmkpApTXs5A3k++rek8LgCIjmTEkYQVA9N?=
 =?iso-8859-1?Q?pof20Im47ZiJcB8yJewROwNjnC8T2KROlGAh4LBQQmfEonKrzyvROIqboo?=
 =?iso-8859-1?Q?fIbEhux8jlS8czZT69kcVQbBssCsDNiqP9hakv0u9JLb6TdPbjWqZNbPRx?=
 =?iso-8859-1?Q?vWG4iod1r6IyeBnOkDHpP0uv45JqeJNfdPdfGmxMvx4KkYOEfxvOdCNtBf?=
 =?iso-8859-1?Q?Js7Eh/yN/wcYHGH7nh7ABmEAuueBePo6fX7C7v/VGCM5tTqCt4dy5gbDXK?=
 =?iso-8859-1?Q?Weo/gerXz0hn37r0Xm1ciIrmEDZgh6W5UBiiND4O8hzngEjnebakGi8PvX?=
 =?iso-8859-1?Q?ksnjKCG8l9QNhJ93KZT7BI2NJU9xPEqMDKow8RnegEI/DWniQKmvEUiNs0?=
 =?iso-8859-1?Q?/Whnphbzy5M+4SaaRbCf9GD/0uHxEEnNbqSA4SB1k6W4kxvj6cJ242kuPx?=
 =?iso-8859-1?Q?0avdPbejGmzZKXOTltOISRGYLChVxKXDC6FfItJA4yMmGixNWtQYg49tM2?=
 =?iso-8859-1?Q?Sq2rM7/4M5qntSCfd0z+K1zhn7k4QJjTp3fnFWiDfr6WuPlfPIagYztlao?=
 =?iso-8859-1?Q?5qH9UrBT6e9vivJD?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d33776e6-8a79-4bf2-222a-08df333b47c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:40.9512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
The SCSI BSG end-I/O callback returns RQ_END_IO_NONE and leaves the=0A=
completed request for task work to release. The request therefore=0A=
retains its tag before task work runs as well as during user copyback.=0A=
With deferred task work, completing the device command alone does not=0A=
make that request available to other I/O.=0A=
=0A=
Save the status, residual count and bounded sense data in end-I/O, then=0A=
return RQ_END_IO_FREE. Task work can unmap the saved BIO, copy the saved=0A=
sense data and publish the CQE without accessing the request or scmd.=0A=
=0A=
Allocate sense storage at submission only when a nonempty response=0A=
buffer was requested. Charge this user-triggered allocation to memcg.=0A=
Do this before acquiring the request, respect nonblocking allocation,=0A=
and return -EAGAIN for an allocation failure that can be retried in=0A=
blocking context. Free the storage on submission failure or after=0A=
task-work copyback. Reuse the snapshot-capacity field for the packed=0A=
completion result after the end-I/O snapshot, keeping the PDU within=0A=
32 bytes.=0A=
=0A=
Preallocation avoids relying on a non-sleeping allocation in end-I/O=0A=
to preserve sense data after a command has already completed.=0A=
=0A=
Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 78 ++++++++++++++++++++++++++---------------=0A=
 1 file changed, 49 insertions(+), 29 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index 98c9db1cae653..fafa5c2cdac0e 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -1,6 +1,7 @@=0A=
 // SPDX-License-Identifier: GPL-2.0=0A=
 #include <linux/bsg.h>=0A=
 #include <linux/io_uring/cmd.h>=0A=
+#include <linux/slab.h>=0A=
 #include <scsi/scsi.h>=0A=
 #include <scsi/scsi_ioctl.h>=0A=
 #include <scsi/scsi_cmnd.h>=0A=
@@ -16,9 +17,13 @@=0A=
  */=0A=
 struct scsi_bsg_uring_cmd_pdu {=0A=
 	struct bio *bio;		/* mapped user buffer, unmap in task work */=0A=
-	struct request *req;		/* block request, freed in task work */=0A=
+	u8 *sense_buffer;		/* allocated at submission, freed in task work */=0A=
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
@@ -28,41 +33,30 @@ static inline struct scsi_bsg_uring_cmd_pdu *scsi_bsg_u=
ring_cmd_pdu(=0A=
 	return io_uring_cmd_to_pdu(ioucmd, struct scsi_bsg_uring_cmd_pdu);=0A=
 }=0A=
 =0A=
-/* Task work: build res2 (layout in uapi/linux/bsg.h) and copy sense to us=
er. */=0A=
+/* Task work: unmap the saved BIO and copy sense to userspace. */=0A=
 static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t =
tw)=0A=
 {=0A=
 	struct io_uring_cmd *ioucmd =3D io_uring_cmd_from_tw(tw_req);=0A=
 	struct scsi_bsg_uring_cmd_pdu *pdu =3D scsi_bsg_uring_cmd_pdu(ioucmd);=0A=
-	struct request *rq =3D pdu->req;=0A=
-	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);=0A=
-	u64 res2;=0A=
+	u64 res2 =3D pdu->res2;=0A=
 	int ret =3D 0;=0A=
-	u8 driver_status =3D 0;=0A=
-	u8 sense_len_wr =3D 0;=0A=
+	u8 sense_len_wr =3D bsg_scsi_res2_sense_len(res2);=0A=
 =0A=
 	if (pdu->bio)=0A=
 		ret =3D blk_rq_unmap_user(pdu->bio);=0A=
 =0A=
-	if (scsi_status_is_check_condition(scmd->result)) {=0A=
-		driver_status =3D DRIVER_SENSE;=0A=
-		if (pdu->response_addr)=0A=
-			sense_len_wr =3D min_t(unsigned int, pdu->max_response_len,=0A=
-					     scmd->sense_len);=0A=
-	}=0A=
-=0A=
 	if (sense_len_wr) {=0A=
-		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,=0A=
+		if (copy_to_user(uptr64(pdu->response_addr), pdu->sense_buffer,=0A=
 				 sense_len_wr)) {=0A=
 			ret =3D -EFAULT;=0A=
-			sense_len_wr =3D 0;=0A=
+			res2 =3D bsg_scsi_res2_build(bsg_scsi_res2_device_status(res2),=0A=
+						   bsg_scsi_res2_driver_status(res2),=0A=
+						   bsg_scsi_res2_host_status(res2), 0,=0A=
+						   bsg_scsi_res2_resid_len(res2));=0A=
 		}=0A=
 	}=0A=
 =0A=
-	res2 =3D bsg_scsi_res2_build(status_byte(scmd->result), driver_status,=0A=
-				  host_byte(scmd->result), sense_len_wr,=0A=
-				  scmd->resid_len);=0A=
-=0A=
-	blk_mq_free_request(rq);=0A=
+	kfree(pdu->sense_buffer);=0A=
 	io_uring_cmd_done32(ioucmd, ret, res2,=0A=
 			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);=0A=
 }=0A=
@@ -72,9 +66,24 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct=
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
+			sense_len =3D min(pdu->max_response_len, scmd->sense_len);=0A=
+			memcpy(pdu->sense_buffer, scmd->sense_buffer, sense_len);=0A=
+		}=0A=
+	}=0A=
+	pdu->res2 =3D bsg_scsi_res2_build(status_byte(scmd->result), driver_statu=
s,=0A=
+					host_byte(scmd->result), sense_len,=0A=
+					scmd->resid_len);=0A=
 =0A=
 	io_uring_cmd_do_in_task_lazy(ioucmd, scsi_bsg_uring_task_cb);=0A=
-	return RQ_END_IO_NONE;=0A=
+	return RQ_END_IO_FREE;=0A=
 }=0A=
 =0A=
 static int scsi_bsg_map_user_buffer(struct request *req,=0A=
@@ -139,10 +148,23 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc=0A=
 		gfp_mask =3D GFP_NOWAIT;=0A=
 	}=0A=
 =0A=
+	pdu->response_addr =3D READ_ONCE(cmd->response);=0A=
+	pdu->max_response_len =3D min(READ_ONCE(cmd->max_response_len),=0A=
+				    SCSI_SENSE_BUFFERSIZE);=0A=
+	pdu->sense_buffer =3D NULL;=0A=
+	if (pdu->response_addr && pdu->max_response_len) {=0A=
+		pdu->sense_buffer =3D kmalloc(pdu->max_response_len,=0A=
+					    gfp_mask | __GFP_ACCOUNT);=0A=
+		if (!pdu->sense_buffer)=0A=
+			return (issue_flags & IO_URING_F_NONBLOCK) ? -EAGAIN : -ENOMEM;=0A=
+	}=0A=
+=0A=
 	req =3D scsi_alloc_request(q, dout_xfer_len ?=0A=
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);=0A=
-	if (IS_ERR(req))=0A=
-		return PTR_ERR(req);=0A=
+	if (IS_ERR(req)) {=0A=
+		ret =3D PTR_ERR(req);=0A=
+		goto out_free_sense;=0A=
+	}=0A=
 =0A=
 	scmd =3D blk_mq_rq_to_pdu(req);=0A=
 	if (request_len > sizeof(scmd->cmnd)) {=0A=
@@ -162,9 +184,6 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, =
struct io_uring_cmd *iouc=0A=
 		goto out_free_req;=0A=
 	}=0A=
 =0A=
-	pdu->response_addr =3D cmd->response;=0A=
-	pdu->max_response_len =3D cmd->max_response_len;=0A=
-=0A=
 	if (dout_xfer_len || din_xfer_len) {=0A=
 		bool is_write =3D dout_xfer_len > 0;=0A=
 		u64 buf_addr =3D is_write ? dout_xferp : din_xferp;=0A=
@@ -185,13 +204,14 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc=0A=
 =0A=
 	req->end_io =3D scsi_bsg_uring_cmd_done;=0A=
 	req->end_io_data =3D ioucmd;=0A=
-	pdu->req =3D req;=0A=
 =0A=
 	blk_execute_rq_nowait(req, false);=0A=
 	return -EIOCBQUEUED;=0A=
 =0A=
 out_free_req:=0A=
 	blk_mq_free_request(req);=0A=
+out_free_sense:=0A=
+	kfree(pdu->sense_buffer);=0A=
 	return ret;=0A=
 }=0A=
 =0A=
-- =0A=
2.43.0=0A=
=0A=
