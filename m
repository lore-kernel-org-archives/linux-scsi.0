Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003383;
	b=TO4fL+b5f+5G0p9bDYozFeplA+dijJB/kqmjDzrZsVxIm7mOoUMCow521/kTDmsnxrWi
	 6M0BiJzGXnW+Pa6A4/G5SPyOh0dgez3ls/dpdiUkyflCLzqbu7aBfi0N6nXZEZJ6qETaM
	 bpcKqeBXAOHmyrwjD90dSl6kbGE0I+MaX9OJBU6cWlOgIuMwDXbnneaHgZINb0YvMRKBT
	 o9A2VCFzfsjF4xuztwLoLlFQlA0xtYlB8uDEDyN8VqSq6EnNIZK8d8EpjRRghnP06bAm3
	 OXKhjrLBE5m4P2KLRT9Yl1guRfmhI5/nIQLXLJ1OqKTLF+kLVZw0xBaEWp5F/dIUgVg==
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
	bh=kMhx2uOpdPGEEs3JGHCXemnE0ZSHLV0oIvik4GaguNs=;
	b=WS8oMlnNUQmgqkNPrlnB5SV7l5HmcfRPzJ+pPv5rErH0fePZPXOrR499tuhKjzA65KCg
	 HN6zZbbXakmzL9+cSL7GdVC4T3Io8mo7ppXwwXbuxkH1UvKBM5HCUaaHKrBf82+fsD0ow
	 aQtfTKUd7Em38QzNanqjWqkobnKKEWgYu6cD/X5E2GT9rsa8rwYxnRcG1pcsCSBR2x99n
	 0aTXX0WBiOObUrTkV3E7kC2Ey4TivomOD1dq1cBmleChx0evAIdTCgBaBRSUid1ofXJxy
	 6fLe/6gs+ibPpic5IoMaKQLkX8LbdRK0XI6KjHRgwCyytE3Mw25MVd0hHgxr+hMmpvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vFvOSUsV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8924D60A263C;
	Mon, 26 Oct 2026 08:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8924D60A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=vFvOSUsV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AJ1nJEjutTP6RE81pSBKzcv6J12Wc3aNytwkaFB3VSs0ZOKdUDNiwYcgyeLwiu/fJ3uzCL97C34q2JzigbghfCuYL6EigEWW2hjg7QLTo9muitJDXeDLxbyyQFBH73hgn95pddOABuKjftweITl2GoFqRb0ctVAdGpz9ZUr1in+HHKAaNGJHssOfVpQ8d4dRCATPHJcIVSEf+J6XcxTNucb+jVTaEgLVXUcaGohwBw+GyCKoqt6x4EXNxt6b2lEZxftrzo+vvfuTkP/5bFNlWB14aX52+rBn7dzgYTfx5y40tpSHIwnYy8NeYr9luUxhW13pkY4CVncoEp0VBZ94mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=kMhx2uOpdPGEEs3JGHCXemnE0ZSHLV0oIvik4GaguNs=;
 b=hDWEokebIM8bF6Poa+E2DU6G5Ov0X4cJPJ07o9FLrcr9jpGQPxocyh5gp9/dr1ZWPDmjeL6Xt8V9fduVEeTOPiEvxz918GE2YmhH/ahWb1ftpPubVw+Z0Do2aaOVlcwgBeT9mQ2VNpq0RhzxtJ8b08E2yNgta8eoaSrS1I0SkwKbgDa4CSkyqmmjRxoGCbEyJTHEdGCgzjmjwaABf2HlouAGq3ECInyboXCBaZwW1ZgAtM4kd6DwHLVYDL9HEqW/IZuip4UK1w+ieVZdgN2DJmI0oYVRq1Za4NsvJY5RK4Ekb5zcWsvk/kh1A7TEejNPTGq/ioQvFLv/jmZPG7gPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMhx2uOpdPGEEs3JGHCXemnE0ZSHLV0oIvik4GaguNs=;
 b=vFvOSUsVAoxlyLXl0jH0AKeDIc5Ru1Vb9aKxsrPQrzG4vA8C6//BafHIgytIjvX48atb6gDvs+Wb+RpAmueKx0BhjfBP0CooAc0WDyjHsM7ZljRfMM+oyCNiUQwudVDkehMpgxab8+OKHkiiho/AO1vYCw5gscO16wwXCNk6hxLUPMOiIAEf2+RJF2nYacMHW6HVbn53s9OxRDxwzUU8/FMmfUYLGQ7j1+cpsvLGTxMFugzxzONt22nha19FjQ177meShcYT3UuhOONslDaivc+xXP2+Elmy09Fhe4vTV4q6WnOCkYgI2Vm7N7wCiaOIVvokJHSxJ7eoVhsgwVs3bg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:37 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:36 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 3/6] scsi: sr: release CDDA request before user copyback
Thread-Topic: [PATCH v2 3/6] scsi: sr: release CDDA request before user
 copyback
Thread-Index: AQHdZSQiahEeF//Ick2P1k77WZ0zfg==
Date: Mon, 26 Oct 2026 08:29:36 +0000
Message-ID:
 <2cdd629d5bfe284041f3410391154821c19fdcf4.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
In-Reply-To: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: daae2cfe-9818-492c-9840-08df333b4554
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|39105399006|41001999006|22121099003|22091999003|24121999003|31061999003|38102599003|8062599012|19110799012|8060799015|25010399006|102099032|440099028|3412199025|4302099013|1602099012|12091999003|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?zY8cXiDMqM2GNOZou364+31ChuqyVnPlMm3krgkUQ51v+Afi2SDo7z9ISj?=
 =?iso-8859-1?Q?525HGv1YtHRRvZI7CJxweMpweK+tmjupgza9NdrDMv6IYERL0+O+pi6U5I?=
 =?iso-8859-1?Q?f6F0dYsxhG1SUWuM3xtTHwtn3ML8iUnOP16vqizJhii83sBPprEkKkofBG?=
 =?iso-8859-1?Q?QdLuoP1La/kjglDRgfvE1NaDNrFfub7WfgP1oOK6zDsqzgLbZ+AX44BZfE?=
 =?iso-8859-1?Q?mNXDX412urX9OiVfcjuFhIMahmpnh/IFV7j9+RUjyzUABIMg28NmVNjhLQ?=
 =?iso-8859-1?Q?K4Dr3qJgQjbsMk5lce/4WupxGAiQ0Woz2LvYlO0e+C5gLdoxqhA/eAscCv?=
 =?iso-8859-1?Q?9XbopOcMHxk1DMr+5kXZ7EAMpMRK/AqFYHtX1gdAKo73sSlEaJVt1yGms/?=
 =?iso-8859-1?Q?koipZe+LQ8bHzXrLbB0CBdhd/x3ZVlGMJ+M4CYdbMOh/lRbRPmOSmBxC9q?=
 =?iso-8859-1?Q?Kma+3pU9TOQLjDvrlFQ5CoJIIefhEVkcomIC5cpZW7i4qnQorPkWIUSV0Z?=
 =?iso-8859-1?Q?BMg8xsiP/sAYwWqOOxPfNbPRq6p1Z9qpxXgsi8L67qPK05PNl9Zv8VMHjk?=
 =?iso-8859-1?Q?7dZ/StQII7XtZmKIfz0uA3mDejUxo/de71KROA382Vvb9Li/gW+MKoiNH+?=
 =?iso-8859-1?Q?eJKQNPV4qhtDSlLMFHFnwaYnM5/Fpu2stv42XDo8Ux6pRMBFNx+EncGF5A?=
 =?iso-8859-1?Q?cN431pzL/IQjPcmwcJzsPADJQLdm4lkjVComUfy9n3c1ZiXqcUG9BfcoqK?=
 =?iso-8859-1?Q?0GnQ+Gs96537W/5npSD17tGl1K0d1pusnTbQKNMCmTbYlgdRmCiJgiEPn9?=
 =?iso-8859-1?Q?idchU5sPSHup6pjnhf4rJY0avYVDVZtWlVQSZWHsk5LPwn2V4HrOjbS9Cm?=
 =?iso-8859-1?Q?Rm1yFqSA9d4PtO/KjyLNQbgChLhwrg1ijjT6h0tPQVkE5Fu3cymfbyFNjt?=
 =?iso-8859-1?Q?b+SfFguHF0jUb1dqooEVYrH85Fqv6LO75xbTw14+4ppGpi1ooaDpRQEkYi?=
 =?iso-8859-1?Q?Iu/6kB12N5srG2eybuZ3P2cSiH8gJ3Cx1mpVtzLDjFZ+fowQjpNKf7Yz7D?=
 =?iso-8859-1?Q?uZ89jIyPPHhOFz0ZLOmf5aaEpikCdIi9Cl5ODPf61rHsfvzvTIVQaFsqMU?=
 =?iso-8859-1?Q?wgnJDyFfBpExuVE0mjidyC1U5giZ7afkNrZUuOxrQCmB2Jrf6oKioBCWzZ?=
 =?iso-8859-1?Q?acVDBSF9Xrv17eZT07RJbU5Yluc6csVUXza4GuxeaXXfiiqXNfoUAmoz?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?GO0WZQ4KM38ZboyMt9PnRNR1uYtgauRH5qcltfFVJ/2+I36rK0rNIuzbnL?=
 =?iso-8859-1?Q?igqdqSS19cDS2BCa5RidBBgLvna8FmbffYr3BEa90OtIEL4EDhf54IQwgs?=
 =?iso-8859-1?Q?75Ouk84v8xSCxOV0oMFOfzTXIpsntVlPkB3Ye3t/RIBApBHtWZEQ3e9/Xb?=
 =?iso-8859-1?Q?OTnLOrwtZr2ZJLXSjAMDiPUFaodyqrXyXR0o7XjzTTT4Y0TNqTW4nBkv6h?=
 =?iso-8859-1?Q?Sanw7T7tO4uuqs6kldD6PSZnYtDcKPlmyRwQqHEscl8sjGA79nfRJBFp8j?=
 =?iso-8859-1?Q?sgCfqUDpPDeWyQ3Hmy2yvfVwAFXm9Pu9YaLG/kuT6P95ABn2TyZnMe6o9o?=
 =?iso-8859-1?Q?9Gk16CcIsUKPY4FYO1mvQueBd2TEPPPaF8QBnX/zSVG/o/TIyOFeoWSBH8?=
 =?iso-8859-1?Q?SWT6hzBBYS3Z69K3e9SAosdg2nYmE6HoY6QxSVMBJGwg+xuW78gPdSyaJ9?=
 =?iso-8859-1?Q?JG1LwyAGlX9lUPI7wVxe/SpPXfjV3x5LQIZWGuXX5oJlVOsKF/BGQ2cyTF?=
 =?iso-8859-1?Q?MiyKtWbGrdUdu9x5+GFMLrQTaUz4U9bw+y8T50eBu3MMHfJRZjak+z2xrR?=
 =?iso-8859-1?Q?7taucpcvDV6CMaDmSMl7cqjKu6zBZ0nAtIlgEjgsZqsNuASa6SZrA+VME/?=
 =?iso-8859-1?Q?u8jABqZoAVI/1zAIoGfiz1JW0fbIp7U/RGaW/CLxBPx/iFcaCYVAbTz/a0?=
 =?iso-8859-1?Q?pqUSW5QxxDXcP+DcBdClnygLwYWfzuA9ovrHTQoVSEIOYHO1dVy22umEl6?=
 =?iso-8859-1?Q?H+iZMuKl58vZSC+vjXAC2tycHKXX6L8bY81vPXg0eO1pfabb9JHZby8xca?=
 =?iso-8859-1?Q?zpxiPxLDZE/xsDp4p9UunwVP1TVv6mko5urHUpn8HZC45eYJ8DZaVRXt+v?=
 =?iso-8859-1?Q?uOTF4F+w9JwZzQXlSQ9/hhCIV5yaCj0FUAKB3woOOJwjmzpGOY9YuDNLR4?=
 =?iso-8859-1?Q?3LBr+c93SRTa9SI0rVJfrXrb9l6kfRLPrAq84AYaGpKr1Z+CL218q5UYTT?=
 =?iso-8859-1?Q?C1ItBq14d3S4St+HlHseZDADCKBb0xFVENCoIuNWfwU+M/p5lREClHXQ0q?=
 =?iso-8859-1?Q?T6gCNS1uSovHeoJDMeUqm32g0vFTZN3GcqlJKnuZWhAeUfyZHCMyl1XgYf?=
 =?iso-8859-1?Q?ojedqBisHCUTdztldIZD7KTZLWvj0e7SH//n3XE6QPWrw61oL54a6jsPpu?=
 =?iso-8859-1?Q?89IWrvffeeHhAHqNb78MgWoP5I498wXOLKsSpkyLW1tsel4FVwSu+jJfI8?=
 =?iso-8859-1?Q?X2g8CSSQDZWA6CEBm1fiyjTfe9JG5sM/WumMbebQYhNqZW7oMbgFy73Y90?=
 =?iso-8859-1?Q?gJ7B7gkKFeGeRptWHv63hjxMKKLyBorc9NjqrH6AsN78x6jVoZdjVlCU4U?=
 =?iso-8859-1?Q?Dnn2fe+TrfNfa71VATVJsdHqAS7liHLXHlTSFfyDc10bdWsM55nMuv5G1s?=
 =?iso-8859-1?Q?LIZHEmj8YGwLKTX1?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: daae2cfe-9818-492c-9840-08df333b4554
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:36.8417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
sr_read_cdda_bpc() retains its completed request while unmapping the user=
=0A=
buffer. For a bounced data-in mapping, unmapping can copy to userspace=0A=
and fault. A fault that needs I/O from the same queue cannot progress if=0A=
the completed request retains the available tag.=0A=
=0A=
Release the request after consuming its command result and sense data,=0A=
before unmapping the original BIO chain saved at submission. No request=0A=
or SCSI command field is accessed after the release. The mapping's BIO=0A=
references remain owned by blk_rq_unmap_user().=0A=
=0A=
The scsi-mq request pool introduced this tag dependency. The later move=0A=
of the CDDA implementation from drivers/cdrom into sr was a relocation.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-cdda-lifetime.8f31a2c97b42@ou=
tlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/sr.c | 3 +++=0A=
 1 file changed, 3 insertions(+)=0A=
=0A=
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c=0A=
index 4f2e8d1be6da8..c64c25e9f4047 100644=0A=
--- a/drivers/scsi/sr.c=0A=
+++ b/drivers/scsi/sr.c=0A=
@@ -969,8 +969,11 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *=
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
