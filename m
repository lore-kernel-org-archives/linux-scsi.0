Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003376;
	b=lRPAMJMt1qF/w/5kBmGT9ln67LH2q8DZJJWnPRXOZ1BHY+Vt1tx0qAOJxJVa/paxNHwf
	 iPaQt82OlH92gZYi7qCG867sDzCdW9Hd2lJKyLdkD3sRUdqSpd6YstiFuG5NIOC0axWuo
	 gzrNdl67qnps0pCqQDJxwV8BLp+ChJ7mrze82e6Awqqen/UnchMzLm9wNEFMf8c0y16U4
	 jwY+ceW99YnpGG0kah9n/RpUOaSlvC4Uod+5YLLfZhNtw6qHfS3uvs1S83nUEdCtha7WI
	 YOjHcLaeMu2sx1M2pj2ATo2GF6oDUAia5h9EjWVlHsvoy7Pk+J+iJJ8LjSEGClYrLkw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003376;
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
	bh=uqiZ+OS5WuKF3Jj/9+43ehfU+xlaXoDXGv+WTIVxFig=;
	b=ZEBAOo/Ww5uErVMAJH0dLJOiLGGVSf0GVy3AgKK8sLI4SvT/g8FJQCqe/Sx5Ob+8mx7/
	 gvZoLwnHYmptXLpDwQQOvFtYSmwwKYwsNcM2au3w4svJe7MGey9eWGw1bFDAb7awUmHYe
	 mKVHxjt4hVuxFSzHOOpJYbwA6HXYi47n2chJRHwRaLFVCjvRvLN3GkuN3RTzqS9S65Izg
	 o5mFs7J7Ne3zQ+/f+MEaSN9Ij9p1b0mqEYnXxmJxEeRygWG1CQnPJJhZ1Cree8KvsmGxE
	 1t0DPs2zhPSCM07VJlF0jUo9AcKcd3Oc0K5UkAibNccNQje3roU+JMMgce4U4GY75Jw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=crs5dIwi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA10606A328;
	Mon, 26 Oct 2026 08:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EA10606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=crs5dIwi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjCA23RMzX9H/2qtIorzWIq0NMIfe61Bw8v1r3dfk73jBsNQYVVUTNn51bovLMtxqkZQD1NW9299hPRYbk1z/V0i835MN3vX4hn//yvTKjZ+Qby3xs2IKjWXM0QmomIHTT22a4dvt8uwjTibEDWtU7lQ1nM0EcfGizhMyj9/lpWwArqggHISg+C3XfM/sKRghvoVg/3tU64zKsxWR0dQxySUs9ALbuPx06Dg0H8PHTs6pAjPF0nIsPxQ+c5jLB/2NfHYrmob+Xp9PQ7as5QLDrZ6MdN+tZrWe6fptgyGctK/3pT9bOjMm6lpqYNbBKNEqdYG2cMqbj25mpv6apDhTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=uqiZ+OS5WuKF3Jj/9+43ehfU+xlaXoDXGv+WTIVxFig=;
 b=H5mMy7pdBT1Oq4l4GcTxRmOtPR1wTtzmT9Vu51i0qGY+dBzer7L6sABHlS7jpef0JiyjIBZFPvG2OYH3zFjjndHGcBfiS62QwU0H3Nm7CXw8cVtVYWHTmNvuawEuc54P931GdGofJWxNuDD1QUyRGanguv5dv+WGeAB9BSmaWh+EHRwgbEoNwNmyrLX7VxqdOjRhDjYbzIHqrHHkxilnC+AW6zuu8qze2Ezt0fukFoAtcCuvFo27kmSDEpedlwjEeniUiNtSN5jewWDY3sxEcNKx9Wwv6NPUBfq8hoMxFROsEPqQc7zXqkx3+t3+cv6VpbusHJChzRxQ4Oi9XCepaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqiZ+OS5WuKF3Jj/9+43ehfU+xlaXoDXGv+WTIVxFig=;
 b=crs5dIwiUI0LOJxGEi3TBQiSb7e8EYXSZn727sHV+MxfjgoVD6OGtpV9+DC8iLg5vB27573cRX7b/VHGpcrS4Jx7R7+tBomTM4i5gyRaa61RNmHZd5Z+fTZbqwCIZm4ewEWULiGxazoxtwrwn1exI1QsNqkqyIBlEJCHbAlvaq5K2cJ277EKL43Q3bU5GMNgoiAsxt0bGE26WEOGWfSevF/STxKbxmuVc9UNRM7nmQDiAdFvemOt5IvRYgUtkuKXbWL5JMC93doQ+Koq+uy9ELZFh2zc0ZLlpYvisYXk1bW8+NJCsweyh3uf2kD12NcU3B2083d08cFBrw7flgVH1g==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:34 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:34 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 1/6] scsi: core: release SG_IO request before user copyback
Thread-Topic: [PATCH v2 1/6] scsi: core: release SG_IO request before user
 copyback
Thread-Index: AQHdZSQhB4L1ra/HOEm2b4Dhx7D2wg==
Date: Mon, 26 Oct 2026 08:29:34 +0000
Message-ID:
 <6dd19ee01f7d2d677ad1b2a9adfb82d663475b2f.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
In-Reply-To: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: f3c23132-27bd-40cf-ca94-08df333b43e6
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|39105399006|41001999006|22121099003|22091999003|24121999003|31061999003|38102599003|8062599012|19110799012|8060799015|25010399006|102099032|440099028|3412199025|4302099013|1602099012|12091999003|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?tFCssKUahzdQ61E6SQIl2BKdIt216EBm4E+zA7nZtl3T2EVC5cWJYsIIMd?=
 =?iso-8859-1?Q?9T9WHtnMlU4bgA9vDkkOXNvOrYGcfA1Vy/hR/oqhMrfs2L5tXfvHOHwtpE?=
 =?iso-8859-1?Q?1Z4J+u/imLMMEcZmSG5PA2Ea+CP81p1U0oqwPNZ0ndOJAS4ItxPwu89WBZ?=
 =?iso-8859-1?Q?Q8nGgpTZcj+0/GSWetm/ohYny3i+/F29v5aqL+ETgcCN//9pNPISzQ5NXW?=
 =?iso-8859-1?Q?M+hqGqpN57tAhoAQZ1/+RtuL3uT0zHAbcIKdvh6X5m/5/9joGtPa7RVB10?=
 =?iso-8859-1?Q?cBlKEhBcbgY5e2nSC6QnY2YFhh4bPVRr40GKhAp/tPEK2MUfuk9g38Mh/Z?=
 =?iso-8859-1?Q?8aFmPre/LII2lC14ZJjdS+q60wf/nqwMC1SpDbieH/e348itQJ0i1M9Rmq?=
 =?iso-8859-1?Q?hjTfEoe4EiDqylkqKcBuA5cxkghG5v1wn3VkWswS/RAQKpD0xFDqyo3B6i?=
 =?iso-8859-1?Q?l5x1tdfwXPq5vghgBL1IOc9ZlePhvbH0+RFDS1qmWp3+EWOWhqjs57GIl4?=
 =?iso-8859-1?Q?SiVMytP28arbkUcRmvz4jJF6BISOC8fCYZLG+KAWihON5ZuvOWfMOIgnlv?=
 =?iso-8859-1?Q?1jAj7rOG5drtGSWq+49xzkxnRHkz56FHbgq7RsxpJvplfd1Ilw8nmoFZM6?=
 =?iso-8859-1?Q?xnJJfn0jOlNYWS8J65bYA0XnP9Xtzw5BlA9jT86gRIVk4hjMQHrhH1k4St?=
 =?iso-8859-1?Q?eLPh2OqyGqjho2zJQ5U/9CWzqklhhQnTQbkCpTcKP5BLj2IkiL3lvDKysI?=
 =?iso-8859-1?Q?I8c7G2OJPhoAHQbqyX+4FxowNc8CfsJAj66HystY+Sp5CKjNVwlM+Z7oij?=
 =?iso-8859-1?Q?+bQKTcz3cb3NXT9eroORS7PPB5IC5dz7o1Q1PGlt/p9Ruz+m5d0WwITdPY?=
 =?iso-8859-1?Q?saT+ZWNErpZeHn3b3vcFK4YXrgKjNBNPUEGkyvGnL9a7Ir7biVsRxfPOoB?=
 =?iso-8859-1?Q?1xX9ZozbtVGhSQDepcpIDLv/bhh1EJG6jLdCbfJk0YlSvfEv28StMWiJfa?=
 =?iso-8859-1?Q?4N9/p9mF7sLu35ptg/6hctO5DUxE4S9WDBBN2I0c6tvSQCw+ywTV/kHlHZ?=
 =?iso-8859-1?Q?lHeJrJLu+chBDYKnJi+bYdJ9PHMpRjwu6mdcOpu6x0CamcUJR/S70d6ykX?=
 =?iso-8859-1?Q?tLm5J1Ih9ZNNA43PmP8w7eOFs/B9FOoWBkEV0bKhXAxqhkCKxa8tsJ+D0P?=
 =?iso-8859-1?Q?Y3qSjep+H9+mZ0T24Pck0vOUMulX59l0MG9wMdPL/4tiR2ePIw2VpeC2B+?=
 =?iso-8859-1?Q?/+n+pTHB2cJjT+SvdbDg=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CJaMkpvo/MQEXedfCmmIoTJ+87vm4Oj+fTuj2tAB1WMk2mqry4OZ7MCQAl?=
 =?iso-8859-1?Q?whkmqLockV6kGIpUmSsM18xBM1StZzdM0r2Q2a7HQD5YHAgh2TGuLEYylO?=
 =?iso-8859-1?Q?tVSd+N8srA4barzp7l+tbBy9sr3yUhqOQL2QfP6ytshB8ztWHTjX+VAOhw?=
 =?iso-8859-1?Q?0rqovNTbxhVeCYlHLtD+QzDp7qWSaTZSyO3Z7eJO1JR3qMW2Ft7wY4veyS?=
 =?iso-8859-1?Q?hnvYTMqlA1HFlqOwgKHr+u3hHzhtYTVvu2LhEZErpsNdS/nAsYfYXw5bIU?=
 =?iso-8859-1?Q?O2AOvDsWJPGLcznM02BCceiQTGdLlzqT5cly3exYh+q8Z03k4g7honV+EZ?=
 =?iso-8859-1?Q?Rl60iQ3z2KHNVja6SENCn9ruWKe2yNxa63Pd1K3Mf1aNiCxKTS8jt2x+gL?=
 =?iso-8859-1?Q?lzBvw3qn7If5ElqVoi/86+9UfwCFNEo5/cmgDYiBvQY2q1jj9ezgEjtTsm?=
 =?iso-8859-1?Q?Wmyrb/F0pMFLXBtp4Ox5B07hiPBv6yMHw17SeTJvHeKd0ZWVN8yfZobd1k?=
 =?iso-8859-1?Q?9ChiwCTYI57Zhdmx/doyJ0PAAOIh60SH6VJOZVAsyIsytX1F1AtXCvTl+D?=
 =?iso-8859-1?Q?m0Mu8lnBVVs1pZIu41ZaKlGEsNS/NghXK8VfucPuD4yc/jqbhWycNLNcDT?=
 =?iso-8859-1?Q?aQf+UVW4xu2oawnxs0mWy1nYU+vDmsFvU00YhmFusXi6DQLjDuLhIJxb4O?=
 =?iso-8859-1?Q?bfkn9FSDiLDC5i5cdTOLssRfS4XdBYVMNpk/ziZ82mwUSNZWh2I8qIIov0?=
 =?iso-8859-1?Q?ev47x1n6BZLLzbSg/gPn0LqNjWNaK0TARemPbwjvjFDcJDvcYVr+x1ZRLr?=
 =?iso-8859-1?Q?QrmmcBWOSIvpQhIcayJhihoN+Lx9pNiQ4gB3YTkL0KUxIYlzwqvDr6kNpi?=
 =?iso-8859-1?Q?TTYvRN4SLvcM8OwZCuCpYwKG5N/GTU4RcPsQ1bulvJagNAAJEpwLR4UwiU?=
 =?iso-8859-1?Q?3LJ/dZPii60WNDCWgiFomoI95sHfOfgXuhPWx2Kjjr1eDmnFw6eEJnidG4?=
 =?iso-8859-1?Q?2GuZHo37eJunFV8uKDQGYJMwQx6DS/6Sc/VizZAI7n05TjSetckEl/5+yP?=
 =?iso-8859-1?Q?v9hDi8euvlxgsTy950RdpgE2RdCTJHWRQqfVWHtJ6YZqOe7EigMeLchRif?=
 =?iso-8859-1?Q?AOppm/62qGnD0JHTqbgm3wHj3SH9twH+vrwShaCQxbxZvvi0xfmt3raxn0?=
 =?iso-8859-1?Q?gwHiKBaF52butex5P+m5/akjxLeIG0kDSfytvA8ZleOwklSofsCh/zVZCS?=
 =?iso-8859-1?Q?tjQU64o+JAClGk2TyJTjp1tizryzu5dWD1/+ATHGdElKIH4u0mvTr0YO0a?=
 =?iso-8859-1?Q?69t/HOTXPz2w2+1cH9hG3mUqI22tu2V6Q14DLH6cnLPXsYf8P/XiFzlI8A?=
 =?iso-8859-1?Q?fXm9UIa7VgGblJmGuxv24lFc/JAQWBU0+RQKnqXA6HexmNW0r8/7R0jmFX?=
 =?iso-8859-1?Q?uvzxFEdYRAVKLcTw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c23132-27bd-40cf-ca94-08df333b43e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:34.4738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
The block-device SG_IO path retains its completed request while copying=0A=
sense data and unmapping the user data buffer. Either operation can fault.=
=0A=
If the fault needs I/O from the same queue and completed requests retain=0A=
the available tags, the nested I/O cannot make progress.=0A=
=0A=
Fill the kernel-resident output header and save the bounded sense data=0A=
before releasing the request. Then perform the user copies and unmap the=0A=
original BIO chain, preserving the existing sense-copy error precedence.=0A=
The saved mapping owns its BIO references independently of the request.=0A=
=0A=
The fixed request pool was introduced by scsi-mq; the later move of this=0A=
ioctl implementation into drivers/scsi did not introduce the dependency.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_ioctl.c | 16 ++++++++++++----=0A=
 1 file changed, 12 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index 122403ec3ab8d..68e84705634c9 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -393,6 +393,8 @@ static int scsi_complete_sghdr_rq(struct request *rq, s=
truct sg_io_hdr *hdr,=0A=
 		struct bio *bio)=0A=
 {=0A=
 	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(rq);=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	unsigned int sense_len =3D 0;=0A=
 	int r, ret =3D 0;=0A=
 =0A=
 	/*=0A=
@@ -412,10 +414,16 @@ static int scsi_complete_sghdr_rq(struct request *rq,=
 struct sg_io_hdr *hdr,=0A=
 	hdr->sb_len_wr =3D 0;=0A=
 =0A=
 	if (scmd->sense_len && hdr->sbp) {=0A=
-		int len =3D min((unsigned int) hdr->mx_sb_len, scmd->sense_len);=0A=
+		sense_len =3D min3(hdr->mx_sb_len, scmd->sense_len,=0A=
+				 sizeof(sense_buffer));=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
+	}=0A=
+=0A=
+	blk_mq_free_request(rq);=0A=
 =0A=
-		if (!copy_to_user(hdr->sbp, scmd->sense_buffer, len))=0A=
-			hdr->sb_len_wr =3D len;=0A=
+	if (sense_len) {=0A=
+		if (!copy_to_user(hdr->sbp, sense_buffer, sense_len))=0A=
+			hdr->sb_len_wr =3D sense_len;=0A=
 		else=0A=
 			ret =3D -EFAULT;=0A=
 	}=0A=
@@ -488,7 +496,7 @@ static int sg_io(struct scsi_device *sdev, struct sg_io=
_hdr *hdr,=0A=
 =0A=
 	hdr->duration =3D jiffies_to_msecs(jiffies - start_time);=0A=
 =0A=
-	ret =3D scsi_complete_sghdr_rq(rq, hdr, bio);=0A=
+	return scsi_complete_sghdr_rq(rq, hdr, bio);=0A=
 =0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
