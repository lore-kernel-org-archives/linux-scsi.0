Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C173A5431;
	Sun, 18 Oct 2026 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338071; cv=fail; b=menRl939Ynq9MG13IAj7zhQ7u/uixnrPRvlFcziIGA8IgtygbA8DZZeAMHzmEKLJjIM5ubkmLokgy6YrhauEq77oYgJ8C9Bq8YOUC+gFV+VzFUkBYYxUtI5AtLRVC2eD7P4YgHZzBcPo6sv9FwpKLG81RvJK0ZwTglPQIriiPTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338071; c=relaxed/simple;
	bh=8X8RxpWcBO5Da/xeqGk4SUtah3lX0HmEhPCqoIP9Pp8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZYRxiqxrqnpddUs8+rbI16X4yK0GrNOtpq+c1YJoHAFMtDN95W3FeTt816kuyR0W/dVLyCxcqHkm/zNTIjlFUm16oFYpUHCDc2SGG0lO7vJ/Ng+3eBNZ85ewb923j9G7PP8fGoe28puMsuBLRU4f2JJNQDilddxCwmMvFhCYVOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ROX8xBkH; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ROX8xBkH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nxatvu3BT0cUIH2iETgt4mf7yD+jFUxtH53B1FDlb0knkK4o8213gV65FrgDCrVS6f/xyBpK8c3KNizldEQYpwKfwSVPqNv8JaGxxwKkbpxJ5Qagmkuns9LgVjOf6ehn5CBikSQbVQkbJJIe1mZV6oyF2x8g2zCzp/dkmApjwZOl7XPADqpfGLB0z9rSp0esj0nY7Z6WvOUIbWGPUK0ijFwO6p8hmws5nPit50ICfsqXCgGCrIKJXzNX1La0kSqljZQ88G6+EhpCEBfgFpYFnr9gQ1e8fWu3Q3Hcml6ysGwl8l/Uh0JyyxJWO+yWMHT5vnCwKIwwEc3qreDnlp4RNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=rWhVzzQgmuR3kWfHtKw9Q6j3EGUwA+2/4nXeP+eX8nE=;
 b=BX5k5vEjkopYmQzR3BG/xJPyTx6hSUi4qoP6huacU/bfOUGDnWw+/4EinXdkN8gDzCS0PAtR8d79xWTwNoLJbZJ4uao3o9yBYSeKdvymOk8ppFI/Z3bniNc6ZKRIghFCbkdL82r79RAyBjKPv7K3vzvkSqBvsQgaIRLSYhX9i7YdcgnMh+wQcXSiKMCvF0W6t1YBx66F6f8xZ/rJkpH/jhZnBAFYsd6cZbz469jvkDWKbpEjoXhoI4lVSg4mpu26NP5um0W1m3zO3dYSFSvTvY97NH3yEk6VpEjLHATooP7rkle0LBhbhVm4oh7lXdfMG/61VRkcGG5SLBY5kuuVCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWhVzzQgmuR3kWfHtKw9Q6j3EGUwA+2/4nXeP+eX8nE=;
 b=ROX8xBkH+m/c5oi+BW/cp0Fj27uKoA1X+CtF34mAKpaf03GEzdnvF3H2M8DsGYnOy/APIGVEQOrbZCTCR6wiRjp4ia/tzpnIcIw1ObeKhQiaAeKPslsi+Yx2rJ/c3eujbe9vjbPdoWzV+FpsT14oEVFlOx26eNbbqynZs9G4XXODBarM8DF/vaTGOPFzOa6LxEsxME2QV+9ekjFvEtFTePUsDAF5FCC2dzIoui8Z+L+wLYqeyMfwknogm0x55N0D7DDZrAfPJzKkrR1o3zi0Po937bLNCTQJVZFUaFb5E5lSbJcRHjtioLYGHZ+EXsJkbPPiV7I2trM2ibPr3sivTw==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:08 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:08 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 2/6] scsi: sr: release CDDA request before copying to
 userspace
Thread-Topic: [PATCH 2/6] scsi: sr: release CDDA request before copying to
 userspace
Thread-Index: AQHdXxcX460T75kswEWMB4lVopRdpw==
Date: Sun, 18 Oct 2026 15:41:07 +0000
Message-ID:
 <94d7bdf7391f208b74ba98988c2a52c939d689e6.1792237341.git.x-professor@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: 42e0e12d-6b50-4d6c-49f6-08df2d2e3a40
x-microsoft-antispam:
 BCL:0;ARA:14566002|8022599003|24021099003|15080799012|22091999003|41001999006|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|25010399006|102099032|3412199025|440099028|12091999003|3071699003|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?1DKWo5G87Mn50nzs73g+UuEOOOqk6Bi8te0UI3oJ4VmZRzDXa77jSTWt9F?=
 =?iso-8859-1?Q?SZBEpmEerzfCb7R4lvjTNKZb99YuRJ+bJf/8BGiAPTxHEsKOsjvHb0cLcW?=
 =?iso-8859-1?Q?2r+BvOGxycdfp+3ELYg4J+45OCE6b5H9UDqaGJ8r7Z+trrC5Avw4ihbnBx?=
 =?iso-8859-1?Q?zhcYsdTshgxzSS3O6ElZk9OQtoU/S02ukWMhvXPyq0ItMlE9v1c8J66Fr9?=
 =?iso-8859-1?Q?l/RrVw7GCKWm583ckRvf4Xw+NaXwo9R0+B22ffjf0HGa0wnpt8mnLlYEBi?=
 =?iso-8859-1?Q?EmDrJYhgpOQCBkDiw85XXso/KCcCDZ8BiIWVi/ZjhyCCRupdqpuyaaNbyh?=
 =?iso-8859-1?Q?uXx76pH/plFvFr1Ficm45YROV3wdGx0kFS0X9W6i1u6WRmGffCgJaK/Hj6?=
 =?iso-8859-1?Q?1CiiGgiGL/IXoFKjCsOFKogVNoLfHw8scSd0CyYxKi5lHUOjWk+ErjuuhY?=
 =?iso-8859-1?Q?OFs8i8O3kHDeTqs204rOY7jrmZET5ezDz7kduVPVnAUNkR2qvFWjxoTem4?=
 =?iso-8859-1?Q?88xMAtwyDNfAgzhfhATQGR9w5lqCV67IpP4PXyBH7+oN2MfxfGUExXZ4IX?=
 =?iso-8859-1?Q?mD3YWOKrtEBRil6eqkf0ZRu9dF6UWAn+BgPvq15OGKAGV+CtjOcvDJehkz?=
 =?iso-8859-1?Q?/ALF9O+hKv+VA0e8jeEbMRFhnebbl3ihMSzMyi9kqV8pB4Lg33QXF+sO6G?=
 =?iso-8859-1?Q?U3g6QoGwjrOGzIU+0t0i3sBusQOldgt2M1z4dQtxlTFR+yMbJ6ROSHhTdN?=
 =?iso-8859-1?Q?juhsC1o2w04RJwLHqUEXNSXHly4euCfiq0MH41HbS8ituXPQj+opsrONVv?=
 =?iso-8859-1?Q?Mgar0oELxjGW4YhmJ9SB2+FmfMls23fdYi2I6ZV3GI/e24mqZaK2HYtNK5?=
 =?iso-8859-1?Q?E7lGZkuNu/EytExbEyzQ3Mkl2dRHhUNCpzvGAPZ65YCbpp1oJvLYGo3/Bu?=
 =?iso-8859-1?Q?mzEDauzjIu9KzJw1Ypd7fCoReqVit6xPv9uHhIUYnFFjSkYj1w5OjD5vYK?=
 =?iso-8859-1?Q?ayiuHGD0q7C0NtrFqJOCDKQ4rMQ4/kcQELGlPODZNcQwRAz4wA/E6p0LXb?=
 =?iso-8859-1?Q?ftr1MIar89AQfBTS/9bCbZp9i1EBA8hcR3wCM9M7jWt2bfxrTQGKVL6syM?=
 =?iso-8859-1?Q?T3tYBrJMXhX6+DgTN+z+Q6vp05VtkIqPtsKoxa6r3FcAORIQA5qCMsLqL+?=
 =?iso-8859-1?Q?tyzHjMDcTYpSYg=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?SIkRpm9jLT360eLIWt32VbH16o6gNQqKAVdkizX4+FbofXEjzOE+BN/74j?=
 =?iso-8859-1?Q?J8cR4GIpe6PkqGIioAtEU+y+zpejaVr9OfTqUbSb+wGNbhynADcqRGK2d2?=
 =?iso-8859-1?Q?DSCo6vWe6hVQyobOvoItY1n9FAiV6CxZrupc/5N90jdcAedZ7Dnef/PfW6?=
 =?iso-8859-1?Q?2VhFrs37i03mPkFniMtr5KoWRy1tBIdFpgBIWSGRtgZHaqUa4dkD3G8YKr?=
 =?iso-8859-1?Q?CY+c4yH5Mc7G6wn5CKIwJumjbtPnqcuEYnymEVFOaJNxL7ci1xKbjsqaYu?=
 =?iso-8859-1?Q?zxIpjOeGhg79G46xVCmz91cvQcqw5w17EOW3D1JlXRMSaixbqg3fsR6ahg?=
 =?iso-8859-1?Q?vFji/r1Jn3Wb46ZtFW9+g/tHJACtpZOLCq6e5Igqbk2oZD0brMz36WZ81S?=
 =?iso-8859-1?Q?N3DyJkbeBktUYTSjy3pHekCCX/v1GvbXsah5zGUsmzRBGQCC4WMXxMcv+S?=
 =?iso-8859-1?Q?ASBooLFMIWx2M955MzS88Hr43lirkQvmnJoQmJAVyJNdmPSe2GHyRp3teN?=
 =?iso-8859-1?Q?AMxkqJkjv31P6YOpwKXs7I1F0tSFLBG8Zlo6RelUk7PXhtflVTlL3A85Zk?=
 =?iso-8859-1?Q?4Nill60bmQ4+C9TzFX4rpfqM20GY5JhJZuBa25od+Ly8E0kQt0m7/qxoa7?=
 =?iso-8859-1?Q?S6kXJQ6s9Za77WcTpqnJ8wMY1OTGQ4wZFfQXBgbO8sID9F/qlZnie5k5td?=
 =?iso-8859-1?Q?gP10wTlAVycjIhRheE/sjnBavMij7v+Bl5yUpCFUYeMDJfo01W6TFDe6Fk?=
 =?iso-8859-1?Q?XmOc/PLHYabtKMYPhdCsZYAmsJeaLfl45pB4GQCwrfGFMPhmzFJEJcCUZe?=
 =?iso-8859-1?Q?JoBpp57CaiY+0a2kESKpEPuS/XKC2caj1gLOfG/sz6WElpLPMGNoDMGZi4?=
 =?iso-8859-1?Q?5zWefvpiiwG8G638sjQfoLfrg070XMCpJ5niU5sFuH17imkCwNQbUXeEnM?=
 =?iso-8859-1?Q?8R7MhqehgXejYYC3bmNks76PFkn7BeadpIoiDZDXxORVW2oeQ8C4UeHNOa?=
 =?iso-8859-1?Q?VFgGHO2ltGHcqRVQOUvlKtAqJYxV85LRTPLwKk17Uqc+WXVcfxp8bnfX3f?=
 =?iso-8859-1?Q?GsUWD+TLAWxjsgZ87HiUeSU+DyV1IbnpnaL2tAZlZc+xOGQ2D54e1c7e95?=
 =?iso-8859-1?Q?PTn9qne1LAAuiJY4GL76EMJxG3i/EH6frriTohFzlzcPJ4jqJynTl+syzu?=
 =?iso-8859-1?Q?rucNukPvU2UlsCOq8shoE4hN4d2AZt9DrhZzKVepxA7IdMHzV7LIo7j5+0?=
 =?iso-8859-1?Q?JaBX2BxiWFKcBJHLKqtM/ciGjtOiTNHBB70OmReC9IAUjqtMU1/MXGnPHK?=
 =?iso-8859-1?Q?HBvKl6+OCqf2EaeAvdQX2srH/hdJawQZmWyr5MFGvKz83fVRHYLbQ/QdiP?=
 =?iso-8859-1?Q?zhZDhHxQh6F/HDRX9tPMbE7hFauaKOiNcdmTsmBeNiioxGw6JnOVJ5h5M0?=
 =?iso-8859-1?Q?GK1nl/NkRjZV5yOr?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e0e12d-6b50-4d6c-49f6-08df2d2e3a40
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:07.8416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
sr_read_cdda_bpc() calls blk_rq_unmap_user() while its completed request=0A=
still owns the only queue tag.  For an unaligned READ buffer, unmap=0A=
copies bounce data to userspace and can fault on a nonresident mapping=0A=
of the same CD-ROM.  The nested read then waits for the tag held by the=0A=
outer request.=0A=
=0A=
Free the request after saving all request-backed state and before=0A=
copying the retained bio back to userspace.=0A=
=0A=
The standalone CDROMREADAUDIO reproducer previously remained in D state=0A=
in sr_read_cdda_bpc -> blk_rq_unmap_user -> filemap_fault and blocked=0A=
the disk-events worker in blk_mq_get_tag.  With this change it returned=0A=
immediately, left no stuck process, and produced no hung-task report.=0A=
=0A=
Fixes: 31151ba2cef1 ("fix mismerge in ll_rw_blk.c")=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/sr.c | 3 +++=0A=
 1 file changed, 3 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c=0A=
index c36c54ecd354..de43d6e56479 100644=0A=
--- a/drivers/scsi/sr.c=0A=
+++ b/drivers/scsi/sr.c=0A=
@@ -968,8 +968,11 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *=
cdi, void __user *ubuf,=0A=
 		ret =3D -EIO;=0A=
 	}=0A=
 =0A=
+	blk_mq_free_request(rq);=0A=
 	if (blk_rq_unmap_user(bio))=0A=
 		ret =3D -EFAULT;=0A=
+	return ret;=0A=
+=0A=
 out_put_request:=0A=
 	blk_mq_free_request(rq);=0A=
 	return ret;=0A=
-- =0A=
2.43.0=0A=
=0A=
