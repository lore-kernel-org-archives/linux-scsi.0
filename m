Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.133
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792445440;
	b=n4NmsIntsXL37Udafzb8B56DiiyYutsG+zrCmHO2EfpCYOW7dVsipqSa1z9Kd1qUU6RC
	 cpE0jSdbLZvMeZW+3g5e7br54D5fbJt+OVCNY4Y8fVLPgbJXoJeY40sCvpMIPRripL04X
	 Hwf2FeiUErc6FF5AN4Y9uqBLOWlIguk6YQahjNWZKUVsXZ5lGXYMJEEdqmH9WN9R0hfSV
	 J7MX0JufsPk+rrEnpOguBKZaMVI7JH5G6nrIv7J+N28f26rC0BvqlGdmJGUv2Xe6kThjg
	 Zhg1JKmHlH4VQSgZrv+mAoKqHWE8/mRBvcaKuzNKYW0NiMUhvjoRXwVRuQYnlOXGqXw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445440;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=s7/OQxx2Voq/eZcjZfA+WjwVy42tQ6ypCEN3aHUo/zM=;
	b=IQQm/5y5pIVps29Ti7r91+lkKtuh15QkGPQRH3ksVpM1LL5uuH0UrK/hJVpK3JZBFDwf
	 x9aHISHYwDn94slO/QzYGPVrTfKqRhrBoLB7DT4gOZsqa2S6BfUbTgPBxv7yD3NBO2sfy
	 tu/k0d/uperD6oNBGOlLtBke+tpU5aVsMWUF0GTTyvUSrJsNeyLEjTjIjzbwPTM8fOavp
	 xfxuBoyW/W+bqZPrZxZK8UzckRzeVSGtBD1cKK2ZGPE/sKrpfcSLyq1NaBHCJbV2d5/3r
	 hmy6+XetR9cq+dlgpiBWLWAXDS84dmtH5OT38OjW644ejCNJIP6bcJ8MS8QlYHHxPlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kuleuven.be;
	spf=pass smtp.mailfrom=kuleuven.be;
	dkim=pass header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=hGVpvnbY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.66.133
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022133.outbound.protection.outlook.com [52.101.66.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C8D606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 21:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1C8D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=hGVpvnbY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ehry4zxUrUWF6t+g3i6yyQHp0UN2xz7Vo18e1zo4X1HJXEylMUZmEsFivZLYg1cu2hH98P4dDlMHIb9bZwd5+VEbNmDp0MUivPIeLKZxx9WAIj8/2WS19i2QQWkO1+6DtNH0wYTQTLpY4/NXfMjDg7e4BCn1UVUUfe9SzMCGuzzqJ2oMIR8jmlkJvqdc2S7T4qX3QifStZjt4O9II95xVu5Dw0q43y0c6CrDlRfdjCaAefg1mKakredZ8TDknffREugdbDjmFfbR5XEWIzGUFerTQYc9WpdZs9SGMO6CKGxikOjffS7eObdQdbLkgSZA51OuGWPGKh1hPy06Oq0LCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7/OQxx2Voq/eZcjZfA+WjwVy42tQ6ypCEN3aHUo/zM=;
 b=s1ge/pRzYRyEJO9uXOWGWSL6KFG+F+oZokPywesORVN7e0XgblBlBKL3PDhmPO+ByMhHuEFobitCJM5uqnSgnyHcYnf8JiFLzRuQcOWoxhv0eX/FZ6VHWoCRsalT+sbOOFvvuILk3w8AeJWL7RBJMPdIRnxQOjLzR16e8xrNP/3PINMyD33JTSrwISUcxR2cGFaHSl5HlpEyFTF/mZEwJrtfWIBmN6PNUH+kFhymrVYLSUuDmxhZbcK3f/wrpPmOeD/yk+qxqCDR8owF3NOXlmnhkPCSepW/QZtupF3rKMi5CSLAtdNzvwyx/MqpYi6vTJEuFfFKA5kL+dOjN8fnzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7/OQxx2Voq/eZcjZfA+WjwVy42tQ6ypCEN3aHUo/zM=;
 b=hGVpvnbY1f0uwl9k5YGLIb1JLx3G1M1CvX8EF6feZhQ68b2XbE/v8DCBdELVfcc7puGL0guMwias3SiV1LSyTi8cbjvOdu4MrdSm12HEpegpqVhAygyYSYp6xguSxMLUg6NMiwYcfDEL6X/hm6pdx07x5z5Gr7z0JliNdoNiInk=
Received: from DB5PR08MB10062.eurprd08.prod.outlook.com (2603:10a6:10:48f::10)
 by VI1PR08MB10148.eurprd08.prod.outlook.com (2603:10a6:800:1bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Mon, 19 Oct
 2026 21:30:34 +0000
Received: from DB5PR08MB10062.eurprd08.prod.outlook.com
 ([fe80::cd17:89dc:ddbb:2f38]) by DB5PR08MB10062.eurprd08.prod.outlook.com
 ([fe80::cd17:89dc:ddbb:2f38%3]) with mapi id 15.21.0546.012; Mon, 19 Oct 2026
 21:30:33 +0000
From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "lduncan@suse.com" <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
	"michael.christie@oracle.com" <michael.christie@oracle.com>, James Bottomley
	<james.bottomley@hansenpartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
Subject: [PATCH] scsi: libiscsi_tcp: prevent R2T range check overflow
Thread-Topic: [PATCH] scsi: libiscsi_tcp: prevent R2T range check overflow
Thread-Index: AQHdYA8X481VvdMLvEuJaviy+sv/+A==
Date: Mon, 19 Oct 2026 21:30:33 +0000
Message-ID:
 <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
Accept-Language: en-BE, en-US
Content-Language: aa
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB5PR08MB10062:EE_|VI1PR08MB10148:EE_
x-ms-office365-filtering-correlation-id: fb8a5cd9-a8d4-4edc-9711-08df2e28350a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|786006|366016|1800799024|18002099003|11063799006|10067099003|261009223027099003|38070700021|56012099006;
x-microsoft-antispam-message-info:
 jgaB/SHbihWSIiJUkGbtP2pkjjyrb32N6RX859IOV0UrZ6zPRc76c++3AuWZyJKX05F2N4aWuzvycOZf8Ywa+2wRIeUG4iAsnIpbzqnP8iaXXARKQ+XqnMK3lXDQ2RDQuWIT9x4tMulDma35sJyZowYC5/fHzmmv5Pg+XcbJuJoyWcAcIh/eM4AhPU8ko5jNy1aj4TxKp8Ak2okV6jBpd1nvOjwjdiGVT3l1P0/xhi9/KnxIB6fWYF8zzlGLctX/LQ/K4Bj0wJ7BO4t8EOjAiK8slGUt8n8cbYsFWz/MzfkWd8pJU/8Y3tvy+CsB732ERKTafZO+v4FO6Wl+oTYdem3MWqkGcKfv8NkTjBurAjlABqtFa4QA+YvW8OChQIdM5wFYHmPE9gH/NflB7cUOmgZ8S/+W3tDVd8jcVjsHRIPf3O6TMD0GLn7Y1JEvrrGkgRlFaPe8lxkNVJ9foI5YpqPAsvI3rx7X16/SKlJTxMrAD4QaecQyX0Jr6WUB1vDvztoiIgy89JL9UfC7reevlyba+Qe+KDsJsPr2E9X4oQLvOsi5y8dnpwMwJ3OpWWHeUEsjosBhkaA54YgXmj9EjvZ0G28yt1jbe70/twjD7S3bUbkIhSH92AZo+MOW+b3iINqPi2gSFVt7CffyK5iJcNiMhtuX3jWEuQ9Db7he844dUXdTIQXl9I70KMXK8Z/ngT8SlthnmBIRYroiJqMmeeZsr+NeJ9r3/wl2oVrfcFU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB5PR08MB10062.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(786006)(366016)(1800799024)(18002099003)(11063799006)(10067099003)(261009223027099003)(38070700021)(56012099006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?JEciv+Xq31oMtWXiH2icBPR/4PUXhQ/wPBB+EqiCy/6tpnWF2xFl10v5mVjD?=
 =?us-ascii?Q?p8XavVXLoyfo1XUkNGsV1CoVrVIxbyaRdGSTvVRjHHCFelPWRwqsMu6C+k2Y?=
 =?us-ascii?Q?40iEzPW/Lxf6h/FA93aQ9+QRvNekXkHGbsVA/Ibh9Z3Mlns3VL94TLnnR0dY?=
 =?us-ascii?Q?hidUWniNrOXxUIxPCxGfM1LgIbuaNaLYlAOxNGZ3IyScfTGFEtuYNYF/ZSbP?=
 =?us-ascii?Q?SCKOers8I5rdC+IeOyicO0WV9HlBjUu8Yq0DUNNwhtCQYHQ/5S6angFVzQ4n?=
 =?us-ascii?Q?PGGgYxWt2bcJ1KfCvwaxxa0FXxfBiwYgqirtwM3hjRIbWN3yYVv8Bqj4rkMO?=
 =?us-ascii?Q?iB2YEgcwIwiLmnKlvpoS2dbmY6ZGFIHZm6hpAkvWzjfD+3P0dt47eJmg/6Ar?=
 =?us-ascii?Q?rUhTNsGXCFABWgTZCVAU473JNaGpLUkgVV+KTegXSzT8vszrD8vtnXGjsyPG?=
 =?us-ascii?Q?axp+ngLErAceofP3IJcYuj4ZXYCFFBZ2B2miEps7yIHcrFMg/xwVQfZxdEZU?=
 =?us-ascii?Q?K8dNW7xezZFZWqC2y9uP68H4F5Zz4VzkkK0eVEREcG99r0o8q/frbIi9wbt6?=
 =?us-ascii?Q?QJOt5JNc9RL1Z8NWgk+cVw06LNZ1tuwVJQjuSnOpv866jFtj/432bDNtoSEw?=
 =?us-ascii?Q?RxO2cuv2UEBAYQ0CLPPyShravKsBOB5mphNlc45IyYUp+rS9I6cS48HpLtns?=
 =?us-ascii?Q?gXZxaIldQV8inMEKvAdXONptvHnCnuGpm5giOqd4ZAH2DhwlWfWKBCnPlB5l?=
 =?us-ascii?Q?1Cb977KYzehPxtQjSuGWdWG19dLm+cJH7LHDF6ZZN3EaaMqpo8Qup6Xb0Xry?=
 =?us-ascii?Q?YDMkHGXH5QfjHgrG6sL4rCpX5npo1AhrEZ7ENUvtsuzbA9X0KQfTcvH2O6SY?=
 =?us-ascii?Q?jjtyEK0YHFsAS32eyvZxBVG+3oMX3T7lZ4zNsZ4Tf4PNWriprxHomReyLMu5?=
 =?us-ascii?Q?1rSrQmYLYMFl+JUrobau4bxcJ0FaNaFEi+9XtWc5FV0P/fJe9mB0xorBDroR?=
 =?us-ascii?Q?Kh3hGV70U0ztBEdydfXfbCvB0lX1QlD6Z3PassoQhdPK1Hpwi4LCrbqcyHXg?=
 =?us-ascii?Q?pENiABdvIg/fgm+2ZBaCYhtNda7G9X8p58cxq9bggSo05LGcZkSIzZYFDlm2?=
 =?us-ascii?Q?syow7AYpO8d3LPwMPDz3MJyyUsl1pgFmONkUorOpm0RQgHM71JMBbHX0LYjl?=
 =?us-ascii?Q?go18ber3oXND1HlahmMXVJv4EGa69yqpVXxKRTlneePOlWkXj0wGje3Up4rl?=
 =?us-ascii?Q?mcKqkFh2sOjnhWdQOrFNI1rf8CeLRQp3t1cYkPSWIn13FlMBaTzF3lOFKGsl?=
 =?us-ascii?Q?GXSNhy7HLfvgxAxcRFvtTEa+bURsUa5GPyjznDRz2ysAJP+YCww2pQRcPHQy?=
 =?us-ascii?Q?TRzsM9KQ1XIO/O6xIgxAgB3YNncx4cl7TeuK9b3UL2XMtSof6yIB4QwqOXSY?=
 =?us-ascii?Q?aGevgtgIUEx/nDq3YMn8FXoR0oTw2aaGd69Uvn3guqXqhR2XKeH63WkLjJy1?=
 =?us-ascii?Q?7bqaAPdiT7jYdT6sMZWAXMIwq73IOhQTqKJlydX1K/MuWueX0viEwx9XZA6r?=
 =?us-ascii?Q?VxMgak4u3g/NG8l/WGs8qKXi46N6dZxFmDVtrtu6hhc6Kt6NnOFU8Trj5t1S?=
 =?us-ascii?Q?ovzwwaCk88AYauXDaU0S2aggS0Rkahbr/e29ER3U7Rxbs2UYkPn7Q2u5ZTR1?=
 =?us-ascii?Q?JtRn3ZqbUBmjjAH9Xnk9H6853CAuXOecOgIWCBVdphK3wZXrqK4FEgjiIrB0?=
 =?us-ascii?Q?f7GpfNPiqg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
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
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB5PR08MB10062.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8a5cd9-a8d4-4edc-9711-08df2e28350a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2026 21:30:33.2953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: doMO16+DEorhS/SXbZOvJO8jb4YbMFmPizijbqO3mUSl7n8ddW4ID9oSb1pgufmScUypRfJp1Cevs1kNA8XH0PAH0//NnbqT+6B0ODJna8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10148

An iSCSI target controls the R2T data offset and length as 32-bit=0A=
values. Adding them before comparing the result with the SCSI data=0A=
buffer length can wrap. An R2T with offset 1 and length U32_MAX then=0A=
passes the check for a 4096-byte write.=0A=
=0A=
The transmit path treats the wrapped range as valid, exhausts the=0A=
command scatterlist, and dereferences the NULL next entry in=0A=
iscsi_tcp_segment_done().=0A=
=0A=
Check the offset first, then compare the length with the remaining=0A=
bytes in the data buffer.=0A=
=0A=
Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>=0A=
---=0A=
 drivers/scsi/libiscsi_tcp.c | 3 ++-=0A=
 1 file changed, 2 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c=0A=
index d35f93451ee9b..3c9e736d45e7e 100644=0A=
--- a/drivers/scsi/libiscsi_tcp.c=0A=
+++ b/drivers/scsi/libiscsi_tcp.c=0A=
@@ -601,7 +601,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, s=
truct iscsi_hdr *hdr)=0A=
 			      data_length, session->max_burst);=0A=
 =0A=
 	data_offset =3D be32_to_cpu(rhdr->data_offset);=0A=
-	if (data_offset + data_length > task->sc->sdb.length) {=0A=
+	if (data_offset > task->sc->sdb.length ||=0A=
+	    data_length > task->sc->sdb.length - data_offset) {=0A=
 		iscsi_conn_printk(KERN_ERR, conn,=0A=
 				  "invalid R2T with data len %u at offset %u "=0A=
 				  "and total length %d\n", data_length,=0A=
-- =0A=
2.43.0=
