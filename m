Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003383;
	b=ga0dgvA75J58DaoBTsozuC9VDqobj/MNTCEGn5VD3VT1di7WQNr1aEMnV9YtZcoqf6jQ
	 iVCcaTzxpSTdW0+UznOQb2CFSQI8ApPXa/gjpSxoIpuqRhZHfVqaDogtyuUkZMYUg5h1O
	 GKkbMWy+cWgQyuq7aU/Sxsix4dKvVymj/9xbsCmN/GicodcVmtMRLBN6gdRUGmeX/5bM+
	 QkvLLONQEnGJT4liNEuzNQ18Z7EyH2q9/U2WbHtj4tUuHyiQleUN7wYMRoY0dkftYGbWZ
	 8jP2rXBoECT8HoKuANZHEebMdbdRcYex9miYjc/QyWNNA/Jw0HBtc6Q76tckB11naOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003383;
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
	bh=qoshreT3brOPPQnPQD4LgDcqmscw1mD7DzJezjPs0tU=;
	b=3d+aDO65LvpxRccrBaOQZ9i8KGFWTHk5pz7NsPp0rgqUXtJDlf+sJy8dje5U892oizJ7
	 AUb2ajtwQK4I8T9Jl0pgjEWwTx2Vow0RKsqlyOGCQUfFYNULBdQQHbaumP4cFUIaFNWbJ
	 7Ea6YDtSVAIIPkQyn+fHjaxO+WX7OrXB9tAcwfRtW6ZpwCCMOxmej8boIGKw60bekBNoY
	 NoXNaTxZUWg1WTPluZonUCjYzy9bahkHeW/ovDkB7l+CrEv44DYgMJcFzNleWPGsq9tG3
	 1smM0GgRAHXboM5NEibIEks6QTDd5O5tTs2l6InO9Cdz52ZHjB6JkrKkTOLzKPOvB6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ItfNEzIF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3871860A260F;
	Mon, 26 Oct 2026 08:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3871860A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=ItfNEzIF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfRI+DHw8E6t6ZkzOKVUOQE/q9v610/KN3tNuTd8a3MAiiypsXHQp7HNINtqHLvpA5EG/yD9XiO1HgXS+xzWnDh5LbFBaMogxxN0LBwdjoQL7JcZ7jnrbzirGelqIDrqWqSu+w48k/ylKg9F2qRBl0YdyPmtxCrhAd5JOmhAJpI7a2SdmL4UiQwGkFNVbnCsHlGWWSfEfQYrRhMqIWRz5e7dqx4heXPgefrd3VigAK66XxJiFlzn7TVvPXTlzdruMWdob/DB2vT6ALVd+AbrRT+KMbwh18Q0dxn6ibrE0Y08XLcVUiFSpvusBGkSnLa4kOZoZsqh6d0WucyEHWOBBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=qoshreT3brOPPQnPQD4LgDcqmscw1mD7DzJezjPs0tU=;
 b=qxLka2q9RD9KQASjxYg/yfvti+6Fv1tyPe38m+U6nF4GSKMQWuksXg5R5aoDZ3GJXuh7WjVjnY02ZeF7Uzs5Yxm73oLQ2uY9++RXa57qYnZhtDxHIWXCwpG+UQ/jTG0pWleYHEKuNmsk5x+ZSwspPV5WpsX0BsT888SIa6PitzkxHjB3WqTNAQZXN55NfZXdXrjuHf7XjVJ3+tNxlB+gxiIjOEpcsTDLLyHw1FKPv8mGjfblm0WDc9S8p10FRLgmTCQH/lTtHRW6BDgMcnRD5oFi13hyv3hhvuMud/zlfTGo+0ClFoXer229BajJVb5GfWwLfwkHjcMTgg5T57yfbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qoshreT3brOPPQnPQD4LgDcqmscw1mD7DzJezjPs0tU=;
 b=ItfNEzIFWzpbYTQzSatgRK9cNFpzOFOS9BuAoWK1VbS9ZHAHKoaeW/zbbJTHp5XQ0rCtJXQu6N7cNEufhrO89syfPQXLQa11hJoltbMkVtf8M7uIUaSeNDmuhsFF4uTXy+CmKiRPCGMXi5dKFmEwlmniz+HetWD6l0paIfkRN74IIW0k2EnaWRtHMHyUNZdNomJhPizJ+QR8sV297OhjjOltXXYjEuALkNI49999oJOeKOwtcjaNTjYXrrA2EK49f4rlOQ/f4HtTKHsHbKC2D7GVpB/PKtvQ4B5CdCUrI234/Lo7x/fwrpM7Qn/ll6fAjf0KXxqtlY3jdN7TyoPt9A==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:38 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:38 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 4/6] scsi: bsg: release synchronous request before user
 copyback
Thread-Topic: [PATCH v2 4/6] scsi: bsg: release synchronous request before
 user copyback
Thread-Index: AQHdZSQjfToCipMwWE+HY9my+qQUXA==
Date: Mon, 26 Oct 2026 08:29:38 +0000
Message-ID:
 <b8945a10ed3c70050d57822e39da5d8c96994cc3.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
In-Reply-To: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: 997ca39c-2008-4b48-a365-08df333b4625
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|39105399006|41001999006|22121099003|22091999003|24121999003|31061999003|38102599003|8062599012|19110799012|8060799015|25010399006|102099032|440099028|3412199025|4302099013|1602099012|12091999003|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?XD7W8rbP/xoT2qjartRJ/Js7bBQJSw4/qVjWGMXqljDiuZH+iZk0HckOFU?=
 =?iso-8859-1?Q?u6ahHQsFPAE9msZg5r7uv/hZL9fnn33deAWzCuKAuohE6e1KfTcJqriV79?=
 =?iso-8859-1?Q?+LbzW4akvY3Djshb8bTcOo/cM8o8T4qnCPMkbORc1X1doKMsncXG/PCzjv?=
 =?iso-8859-1?Q?pWTTnfzWmHMvgbp+oKI4+6J3phw1ahkpk5RNcIWctTzGLMgqC2ZIuT15Sl?=
 =?iso-8859-1?Q?o54iIEtKFPAudLKl3r37ziDjPhj2ntQg0QiVhBqNHlPxdV+Q1QSdiFc52c?=
 =?iso-8859-1?Q?a91HJzqnLtPKr8LcLbcpj3g0Lp5BwVh1sSDgRqJt5xwJNkYmVLAvHYdDQD?=
 =?iso-8859-1?Q?Ve0x7Ta+B6BcElNPZaSOQanL3fWmetJK5U9dKlQv1qMkLomm8V8bneK+dY?=
 =?iso-8859-1?Q?Aonf1vO0Dely/MguuCnAaoaMe5AEH9H7iIAkYalJi5Pd9Npda/DBv0ws+S?=
 =?iso-8859-1?Q?mQZ7yL0CqkBsLws+zsnN5ZRmt2k3qvvRcxHJyjeve7sJrrFaosAu6rNKc7?=
 =?iso-8859-1?Q?p0FOshl4ffZGbr8YG2CdG3C8O60z489FPY4l/RhcUGfNwfEE8iaOmoS5Z4?=
 =?iso-8859-1?Q?VGvMuhCfFtApTH1JZRLr/pYoAF/0wyIF7XrQOO8gsDkwlDE0XOUNdr6FaC?=
 =?iso-8859-1?Q?ZxCUmmq5jxPFb6QrBxyszu/oDJ3DireTeyWE6X7l7FcALclAK1es6w6GW3?=
 =?iso-8859-1?Q?qZaZqKcykxeO1rMlGVTP34W74h9Q/a+5rYPZMPBvAu6XJ8sjACwQSgx1mS?=
 =?iso-8859-1?Q?1h1ztOIpXD/kg8jgpuXyFIU+Q2OCaoKCnlHLFPh8a0a9C903NvAjs9bFSB?=
 =?iso-8859-1?Q?2zvUCipElbmVHtUYIGqC7QNHT0eIspKKPyDYZXCaMU71awEO/qTwV4WDmH?=
 =?iso-8859-1?Q?TBWe4oaNvN6HlCWk0+3PTBhnbn4X20Sfue/SbXxcoOO5/+qjbGYomSss/W?=
 =?iso-8859-1?Q?V2dWsnJPn4Hwn4xuUwhgJfFEvJcF6I9Kcll5AzjbxXCoHX7DJIEZLcXVzB?=
 =?iso-8859-1?Q?REXrsuhwDfHSvfLJDvDM4Z1soqeHL/Txcw1avucWuaXtvDv5YbytFIIPLR?=
 =?iso-8859-1?Q?GEXvOzk+WrikmngzPP0OuLbBi85mXjIEv8OnGdZsoXUVj/egCWTR57gJV+?=
 =?iso-8859-1?Q?A64pLxv5jjSJ5aiBxoo2DsUmwayDYCiQGxDT/0LVpWlZVshJzQjFu5Oet0?=
 =?iso-8859-1?Q?vO4kSpWiVPq9GCjtfRlC1kUMPFiqF/W21J4p4phSDOp6Yp4kC4/QeWkPz9?=
 =?iso-8859-1?Q?35TaFynVltbUCEBed79g=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?7OzxEUubOde901Aq68dlKIiF8xyKoW0VT8EysLgH0mlzZjsZyeT+iRTbZT?=
 =?iso-8859-1?Q?8nWlgM55tOyIcRhiZUR4dAYC24J1ORftkSeGyVZqtlzROcSAfBZ3lJiNxM?=
 =?iso-8859-1?Q?HhDW7/zc+m9Ir8KgMRNwJ/PdEzWpk3y701ozfcq8exkPS0/c0N553oOhxU?=
 =?iso-8859-1?Q?ctGSd9CBm81pc+2wWUdGZz2FJTVeo6q5MxNfTKg/zQUVHOUuwvilHRD8DR?=
 =?iso-8859-1?Q?ZzA+5nBUNSGlmPJC5P1N/mCiA9oEVrB2UixZv7iOvPYJaydPduzaEHO41f?=
 =?iso-8859-1?Q?FptYKybw1P8Etb2eqE52pOcOJzEdNtQyrJTSwt75q+gajzXUyyqciQjCLw?=
 =?iso-8859-1?Q?6HqA7ew55rAGTw5tD7/QMDaM/rMfoE8Se7Z7EYrwK6h+4k8RvlrHVNcImh?=
 =?iso-8859-1?Q?8RnfXhG2DKY7aLzswQ1cvDDtmMjmLIuHGGR001z2NyBdE+m9nAkBRgXrYD?=
 =?iso-8859-1?Q?0yRaCW+Ht21rEqPl6bcqrWv0iypArZu5bJsL21tlDvhG6otj+dv0N7XjFM?=
 =?iso-8859-1?Q?CD4l5QVC9GiNYrFNK05kPDwwcxOmmzMHGYT/KqiEqTWWg7d++CpaGWyNig?=
 =?iso-8859-1?Q?Y4n0R4ziy3fjAKreidXiy8fkTJ6sr+3ePrFl4IBohmKrMyPmzd8DFTB3wG?=
 =?iso-8859-1?Q?KiaAhWDdYx6rItR1qcEhKkwfKLU8fB/FWV8vdX5W2iWREFJyW5VqOaSrxT?=
 =?iso-8859-1?Q?ErJ3Ec5Qsn9/Gd/pOCR2GvBVpmYx+5QywQoqdY4+T+6Db4V7/X/QsZEOv3?=
 =?iso-8859-1?Q?ln12PzLgUOPQCTAqzUkIGzIYQT9fz9P+On5iKVvH+ctzDGbF2SJna1mLu6?=
 =?iso-8859-1?Q?m4qji4RyqxaYbXSNreuPmUiqnITuC7ARWfp/1ychkccyxi1VcGMQq+cOBl?=
 =?iso-8859-1?Q?TuwKzuHQymx0xsqqOuz4CBKc06vFk1qN6c/Z6VsgULGT00a6xqArSNQJXj?=
 =?iso-8859-1?Q?+oaHfXOtrvXVZ83WPJBjVYfTcXlj+Vqh3GCYW87rsU1WHZh6Iatysmb2UO?=
 =?iso-8859-1?Q?xkCQ0Swftn60nIArAu3ZZsB0o2bt70juHPYC9ePtRqgcD9KjrCa1lB/W0y?=
 =?iso-8859-1?Q?Ru9Xm9nMBAlJFKT8R3KosxRv5QH91P8uSiOpAopceFjqFG5CJ7NQSh9VYA?=
 =?iso-8859-1?Q?c96qPecjt6L2vlwmOWxwpkNN0cxXSU1ZDsuXX3QnETKvxsVuYSd176i+Wb?=
 =?iso-8859-1?Q?ajayijG/xJLeeMZs7BtKHclJjbf3LxxC0niUDYsT9KM7DuP8VjhVlpUbLX?=
 =?iso-8859-1?Q?xH0o1Qq/pTXQmkBLM4slUrKWcLZbyOroIkMyD4TXCBk1Dnj+RgmxI4UNoL?=
 =?iso-8859-1?Q?ksKFAJxkx17b4Al/UzA+wwP0VSe6uCiQSqOv4Tqb53VRrR3F0LGi5m4AFk?=
 =?iso-8859-1?Q?uywJ0kFXv3gBce7bWcAbya5QNPQ96qfGKXsAD6LZCLf1wE1arzMo3mHpDX?=
 =?iso-8859-1?Q?fhtesN4cEVkCc47p?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 997ca39c-2008-4b48-a365-08df333b4625
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:38.2520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
The synchronous SCSI BSG ioctl copies sense data and unmaps its user=0A=
data buffer while retaining the completed request. Copyback can fault=0A=
and need I/O from the same queue, which cannot progress when completed=0A=
requests retain the available tags.=0A=
=0A=
Fill the kernel-resident output fields and save the bounded sense data=0A=
before releasing the request. Perform both user copies afterward, using=0A=
the original BIO chain saved at mapping time. Preserve the copyback=0A=
error precedence established by the separate error-propagation fix.=0A=
=0A=
The SG_IO v4 implementation predates scsi-mq. The fixed scsi-mq request=0A=
pool introduced this dependency; moving the callback into scsi_bsg.c=0A=
did not change its ownership ordering.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 22 ++++++++++++++--------=0A=
 1 file changed, 14 insertions(+), 8 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index e4a65d7a23742..650facb16ed23 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -199,6 +199,8 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, s=
truct sg_io_v4 *hdr,=0A=
 	struct scsi_cmnd *scmd;=0A=
 	struct request *rq;=0A=
 	struct bio *bio;=0A=
+	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];=0A=
+	unsigned int sense_len =3D 0;=0A=
 	int ret, unmap_ret;=0A=
 =0A=
 	if (hdr->protocol !=3D BSG_PROTOCOL_SCSI  ||=0A=
@@ -258,24 +260,28 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q,=
 struct sg_io_v4 *hdr,=0A=
 	hdr->response_len =3D 0;=0A=
 =0A=
 	if (scmd->sense_len && hdr->response) {=0A=
-		int len =3D min_t(unsigned int, hdr->max_response_len,=0A=
-				scmd->sense_len);=0A=
-=0A=
-		if (copy_to_user(uptr64(hdr->response), scmd->sense_buffer,=0A=
-				 len))=0A=
-			ret =3D -EFAULT;=0A=
-		else=0A=
-			hdr->response_len =3D len;=0A=
+		sense_len =3D min3(hdr->max_response_len, scmd->sense_len,=0A=
+				 sizeof(sense_buffer));=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
 	}=0A=
 =0A=
 	if (rq_data_dir(rq) =3D=3D READ)=0A=
 		hdr->din_resid =3D scmd->resid_len;=0A=
 	else=0A=
 		hdr->dout_resid =3D scmd->resid_len;=0A=
+	blk_mq_free_request(rq);=0A=
+=0A=
+	if (sense_len) {=0A=
+		if (copy_to_user(uptr64(hdr->response), sense_buffer, sense_len))=0A=
+			ret =3D -EFAULT;=0A=
+		else=0A=
+			hdr->response_len =3D sense_len;=0A=
+	}=0A=
 =0A=
 	unmap_ret =3D blk_rq_unmap_user(bio);=0A=
 	if (!ret)=0A=
 		ret =3D unmap_ret;=0A=
+	return ret;=0A=
 =0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
