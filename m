Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793003382;
	b=YFvGFQ2fE2T4FueSV/fCYFZItZJbIqn27BQ2Js4DjRwr8s02LVXyDMqnXGhaKGH1qm1a
	 la6nPDRzEBWT0cOwehOkPPxtr/COryf4RVGWsNDJ276qLzjPyNukD5nfovvYNII4VzqWZ
	 7Oqm+szGnAzMpo2LeIXt7HD7nDQconWhm6JHBnv5Gs6FSkf4L8iBf1pMokf5cC1OL9Fwq
	 RWFwxAiyaVbGgCH6TaRGmdGpPUE58beupanvxHJh4uXTT4axfQs9s9CFfedXCeF02P72O
	 FivcxNs9riSmshDgqS1dsBzpaqP2xrUr4DLaZxgcLlR6eZ5/vRnXg67nHV7CgbsV3lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003382;
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
	bh=7nAC9or8f8dFTxhc0MGLHPI9Xs5UM+rzcgyv6A34CZ4=;
	b=tKVG8fLtjeCFtnpVtjhRcQ49eaggnseVEky31YU5NWA1dSXwr2EwkXLWlc0S8VcCrG/A
	 LVD9w6uln1T2WzMZnpdQzKnSxWUmmxHQBQivJl3d1wUh04pTJNoP/PktsUdW6EO/sR+/C
	 9wYujkUx3CH8DcFdgIC5z+oElPZEGhgDSAxQHDYR5XVmEmLWRvv9Vlb6dgbNG1N3F+JCk
	 mXDPtADWkb1CRrbJMri+E97HPhZAo2aHKv+aO8M3iojRs1dOseKkluqM7h2ObdpzIVL8h
	 b4ivZIAPllaA0Cc6GT/7xK8gUl9nspGULRqPn66DCUgHhVzTnn8GEdhfIvtwnSe5K4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=PY6od29x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.12.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azolkn19010017.outbound.protection.outlook.com [52.103.12.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E9E606A33A;
	Mon, 26 Oct 2026 08:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6E9E606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=PY6od29x
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wCaJVA1/UEu8xzoTQK1xhJoQoTb3V8ZtIkH32SO4ZHMh+DBOOfvg1U1tadI+bTT7h7fObzFundwq6xoEHjEh0heY679NsXdR6PaC6csnBy7IPaRW3207qmNrhmCy/iW/KkMcRA2ulzko4CegPaqk+YK3rBzYkwlhDdYkOcrw/QEhRN7ZT80Avcx0IjWp2DK43RZ9zOtGRxyWpxxxdvyifp6QmWzBvLEQdt+dG8qr+lmD88nkrnbvuRRqxbSIzvBV8DgpVEtbGX++asKnSF3gOc2K/+75uFjeSkABQOraHYPybxpqK2K22hrXhuvRLE53uRngL6dUgR0l07pkNWJC1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=7nAC9or8f8dFTxhc0MGLHPI9Xs5UM+rzcgyv6A34CZ4=;
 b=tHtl+ojykjHitbDSHwpzY2DxdS7Y/c+6UDVu8QYQKptPaZPrfJYTnlTK+bgjkECec94OONjOWGE1tDXK/vSWoq/dR0tDKP7XS6xLp0NiB1oydwfLZLv+5dxQCh/aGkhhQoBsFNQdhBAPSY9JqjZUVOB+cl4HGdw/B+JkSFVN0PtL08A1Ohqry7q18plTq3cYm7G+9/VRllyhKa2eUN2rn748ggL1dWGJ5i9HfgJhebY6p2BQClybw4/l3mW4ZFSMQP1R3Ud+Vgs4RdAyrSx2QFg02Lh6bYQk47xuJefyCy+yz8mW6LhITEL/pDtQ82MifZkqUE0eSv/Jva4AQXOTcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nAC9or8f8dFTxhc0MGLHPI9Xs5UM+rzcgyv6A34CZ4=;
 b=PY6od29x3FqABA87deffPyzTMvP4PxT/LpSExyFgVGHRSTaiMzy6e0AipSZ0UTdRMw7y1GICx7E8t4zA9aydiTwKw8bKFO/Fyee7iu2rFX4FkSGBie4LG8A/qZjyqCKSoiTtMGO454+oxFwyydVGGULR6ixS/KdodttXngHPcYBeYwmImle2KasSbPqtALz2WVmHMNsAEjPb3sdoYFMQs7RlqsarYkKoCBX8/4WY3ZF5COxb+8j1gtNS/JsCgoHa6EcrHBCqEw1jNh2JQiXIFPtLqaCVQT+2svF0lhCKaaMewiey1ZlDK5zaHs6QHTPV/K6Yx2WnBKfatF3owF2Lgg==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DSWPR05MB998753.namprd05.prod.outlook.com
 (2603:10b6:8:354::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 08:29:35 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 08:29:35 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>, Yang Xiuwei <yangxiuwei@kylinos.cn>, Jens Axboe
	<axboe@kernel.dk>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 2/6] scsi: core: release legacy ioctl request before user
 copyback
Thread-Topic: [PATCH v2 2/6] scsi: core: release legacy ioctl request before
 user copyback
Thread-Index: AQHdZSQiuzI3S2MJbEWdnUrwZo1C7w==
Date: Mon, 26 Oct 2026 08:29:35 +0000
Message-ID:
 <b057b40d857945bc591f10e1659d6842f47e0509.1793003363.git.x-professor@outlook.com>
References: <cover.1793003363.git.x-professor@outlook.com>
In-Reply-To: <cover.1793003363.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DSWPR05MB998753:EE_
x-ms-office365-filtering-correlation-id: b8471362-fb9a-445b-d16b-08df333b449d
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|4140399003|24021099003|39105399006|41001999006|22121099003|22091999003|24121999003|31061999003|38102599003|8062599012|19110799012|8060799015|25010399006|102099032|440099028|3412199025|4302099013|1602099012|12091999003|26121999007|10035399007|40105399003;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?BF/88E6z4/uIGLDMsJyEQRFSAIl5oU18xZyGoWalaUHNN2h9TvXXpa7dF+?=
 =?iso-8859-1?Q?v9MZoonYFm3fRtAvqSPK0gpLWj/mKC1PS7HtYHROl3faBehnfGFkybktR1?=
 =?iso-8859-1?Q?eIRyiLBbciBkcupOhPaVdyHWTxb/xSEQ7kzK/u+OEAsTzrPyrZvcxq0IGI?=
 =?iso-8859-1?Q?iNBgigY8hFKv7im33Ho8F+RhpkmcKW83SX8tYSDAx1I6M6xOIOFbvQ0hV7?=
 =?iso-8859-1?Q?ioRffonjSCXO+BGW4A8RonZ6ssZ5X0ND/IPdgFLeRL02i+kptSXElZjC/n?=
 =?iso-8859-1?Q?vJVqKPJK0OLmpeokHIqkq94SazW+OUeLFewVl21tiibVFfnMcvxvwLHiY9?=
 =?iso-8859-1?Q?OLqAr52gtt25kHS4crf5vcUexyZvV3gkz5EUvHqUNjq2Oi53lxsXBQHPzi?=
 =?iso-8859-1?Q?HuoVegiHG/1qFOb8TZPV5rTbdtEZHQYVeH53plERLB3kBJ9i+qcuvAn+QI?=
 =?iso-8859-1?Q?E3BtufeBwGLpXY2OtECslLriCQ3lhFV8tsvAQf6n/mnf+vLgfc5KmYuhoY?=
 =?iso-8859-1?Q?cKdMU1/yRuv/NK/b1AWUTXMHoJsPio/XfEtYx9yZtH2K6voF70un2XHIL1?=
 =?iso-8859-1?Q?ZPpdRaJGqqbQR/ReZe1iO9a5biloiCkXA2lEz1cH4X7M90tMZhjaAa0RNP?=
 =?iso-8859-1?Q?Tf18ixdDh5QuXiyF7A1kpL5gmzlgRN94U78NUVjOyCl70KP4zNHcmba+Uf?=
 =?iso-8859-1?Q?KtYnw+WUOKUi3RdOX9E2Fm1Eeo0Jv4NhazZzGUzZE7CwqGYb94/XNqXY/q?=
 =?iso-8859-1?Q?Z+83TcUmh/WmiQO/lcYy8QseTeJxA7uNbaWGh23alOQvOobbG/Me209sB5?=
 =?iso-8859-1?Q?zdo+SIZiPlWy5K8n9SMdzY98LEneWHYzHuBSUeH44H1MJ0+srWiUq1fEYX?=
 =?iso-8859-1?Q?RUm8eFihFpQwS4a/yj8CXxm7f85PcEN0iEL82S7CZDvL5oc/ZZhhLEMq8p?=
 =?iso-8859-1?Q?9DYTkJWqDeKIYmDaiciRjI/riceFTqQBrkW9egrEpAWX1leG+qNDaSYHCe?=
 =?iso-8859-1?Q?0zlhFd267wrHroHS+CExxMZ8xd/fEEm40CMA633NKhVBXqhWiPwjJeF1bM?=
 =?iso-8859-1?Q?qCK57ZjdINVPA54NVR6JBPi9uEpnYrm7gwDqKtwVVxIMkk15VAlKuw8yx1?=
 =?iso-8859-1?Q?TcDxbBV17tHuB4s+m+z7iE30Y5pCZE0E/v/rb7hNmqJJvbwuaz++K4wBiD?=
 =?iso-8859-1?Q?v2asVZhOzTKm4LzeJ3NM7f8O9wwC7MaM8R47TLACw3vkD0kRXIxWpVJ3ek?=
 =?iso-8859-1?Q?fTTTs5rxa+uWVaA5F+BA=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?tFRsS5Ms7JmbbrDn+U507MB7YeColNkKf+tMbs9PpydsJRyEHP0PZmo4Lu?=
 =?iso-8859-1?Q?K/W0sgr3qH3cfhsrCvQ4EKuR0QgM+Umv5AuMcXEA6FLRg0N27oP2eF2B48?=
 =?iso-8859-1?Q?hv2z4e5MLN1QvvCP5/uLiLX2uT55Yomt2tAqdWMk1r5kSG7LBmC0jWXIXl?=
 =?iso-8859-1?Q?Dx7Wl7aw+n4d5nEpDLp1+YM05cyRYUt79UqHqphJerm9+9/IShFOlZUy0k?=
 =?iso-8859-1?Q?LrCuOYI7tfwOTJ+ZYYNOLXPJHJTvH5l2xKvRLvbE/UxPcgqVCnFHtXaCH+?=
 =?iso-8859-1?Q?tMldOQVoStVmY3iHXEfFPG8viIpWy18jQlsU/wTwEMhVs2+n6hlutzTA0v?=
 =?iso-8859-1?Q?M1Gg19WfIsNUAPZ5jPREpxusg2i8wCFwykPi/K1aNKg52VfvITx0+Nt2QN?=
 =?iso-8859-1?Q?tv9ZkB2w4gBfyf9txLZWYxgMjkp5+Tau1hQwPnybGQucyeL5bPWEkQ9X71?=
 =?iso-8859-1?Q?PxOwF0p+PwoKH320j4FfqPA4UOwTftHb8kCe7PABuSBOtT/N62fzItiyAA?=
 =?iso-8859-1?Q?63ahMQbIyUU9tWlElDy+zbBwalzLCepmKD+5u9Et+69QN6C4fFkix4ebVm?=
 =?iso-8859-1?Q?GgIYbpvkqnceta1URPu9M7fyZurx9uwGbbuImN2byX63GurdtZtIlv88uQ?=
 =?iso-8859-1?Q?73H15lePHy71/Cyb2qEOa6s7hYMTWniCm/Uf3WSaJkIFxq5W4VCleDarE3?=
 =?iso-8859-1?Q?D2UjzZJ6Zg7QLLMY+9BvnEd60HgUQF2n6+X5o+jLpJdaOoQwPTM9Ptr5cH?=
 =?iso-8859-1?Q?Gj0gRX98Xyz1XSB5kZybGXU7HwZb9tEuU5iXjzMqZqFCtqJ0/hd/5WJMjb?=
 =?iso-8859-1?Q?hpAFRG7OdB35yufbTGcISEbGGytsHtM+QhyvAfmIa6wDjPJOLVfasf1yvD?=
 =?iso-8859-1?Q?iO14PksWo/ZY5cEisdx7a8jwLxNyd6Bn8AlQr72iiRK9KZS4cgAR0vfFNM?=
 =?iso-8859-1?Q?lUhVavza7z5586S2bTFdf09rXMul1dX2gQMHthqWFR57BytJryLtr32Biy?=
 =?iso-8859-1?Q?EXEVDji/Gbtanxzhcu+kKrKRpNszdsH6hJEwuvuHvl3OHjEDoydV6E1q51?=
 =?iso-8859-1?Q?aJ6EEILKTuUXlR3xBQ8V7JU3fbE3JjxMIb+9QLu3KI8zXe/v9XF7ZC/xoH?=
 =?iso-8859-1?Q?JpF3LufDiXxdQvjTkDC8XZmW+cfGOhKE1hq8N66ScITFVNqkHWfrMNVjFo?=
 =?iso-8859-1?Q?TEhIPgfQ/0dq5S3vHRs2hR7gcyOBnH0mAsAi6wkz469ssmsHuSi2gikLX9?=
 =?iso-8859-1?Q?9zfF6q5oP2mKuD2ILEqsBiQ5NmUel6CZGQ1WBfXM6TdB8cStqvDMwbNSmr?=
 =?iso-8859-1?Q?r96JRpufWJG78hyUCZGf2UDDPmQ4nz840mM+gPlV16+DPboRHcC/HJ0KsP?=
 =?iso-8859-1?Q?VAX+z/1E7fzYGtIMooTJYJ0dbsk2bs482ck3URh7q5U7O6WCUAodOq33wq?=
 =?iso-8859-1?Q?NwHN8/4H/Coxjt5O?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b8471362-fb9a-445b-d16b-08df333b449d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 08:29:35.6948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR05MB998753

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
SCSI_IOCTL_SEND_COMMAND copies sense or command data to userspace while=0A=
the completed request still occupies its queue tag. A fault that needs=0A=
the same queue can therefore wait for a resource held by the ioctl.=0A=
=0A=
Save the command status and the compatibility-limited sense data, then=0A=
release the request before copying to userspace. The data buffer is a=0A=
separate allocation and remains valid until the existing buffer cleanup.=0A=
Keep the positive SCSI status and -EFAULT return conventions unchanged.=0A=
=0A=
This complements the SG_IO fix by covering the legacy=0A=
SCSI_IOCTL_SEND_COMMAND path.=0A=
=0A=
Fixes: d285203cf647 ("scsi: add support for a blk-mq based I/O path.")=0A=
Link: https://lore.kernel.org/r/20261022.scsi-copyback-review.31b8d6a70f4c@=
outlook.com=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_ioctl.c | 18 ++++++++++++------=0A=
 1 file changed, 12 insertions(+), 6 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c=0A=
index 68e84705634c9..95e91ae1332c4 100644=0A=
--- a/drivers/scsi/scsi_ioctl.c=0A=
+++ b/drivers/scsi/scsi_ioctl.c=0A=
@@ -533,6 +533,8 @@ static int sg_scsi_ioctl(struct request_queue *q, bool =
open_for_write,=0A=
 		struct scsi_ioctl_command __user *sic)=0A=
 {=0A=
 	struct request *rq;=0A=
+	u8 sense_buffer[16];=0A=
+	unsigned int sense_len =3D 0;=0A=
 	int err;=0A=
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;=0A=
 	struct scsi_cmnd *scmd;=0A=
@@ -621,17 +623,21 @@ static int sg_scsi_ioctl(struct request_queue *q, boo=
l open_for_write,=0A=
 	blk_execute_rq(rq, false);=0A=
 =0A=
 	err =3D scmd->result & 0xff;	/* only 8 bit SCSI status */=0A=
+	if (err && scmd->sense_len && scmd->sense_buffer) {=0A=
+		/* limit sense len for backward compatibility */=0A=
+		sense_len =3D min(scmd->sense_len, sizeof(sense_buffer));=0A=
+		memcpy(sense_buffer, scmd->sense_buffer, sense_len);=0A=
+	}=0A=
+	blk_mq_free_request(rq);=0A=
+=0A=
 	if (err) {=0A=
-		if (scmd->sense_len && scmd->sense_buffer) {=0A=
-			/* limit sense len for backward compatibility */=0A=
-			if (copy_to_user(sic->data, scmd->sense_buffer,=0A=
-					 min(scmd->sense_len, 16U)))=0A=
-				err =3D -EFAULT;=0A=
-		}=0A=
+		if (sense_len && copy_to_user(sic->data, sense_buffer, sense_len))=0A=
+			err =3D -EFAULT;=0A=
 	} else {=0A=
 		if (copy_to_user(sic->data, buffer, out_len))=0A=
 			err =3D -EFAULT;=0A=
 	}=0A=
+	goto error_free_buffer;=0A=
 =0A=
 error:=0A=
 	blk_mq_free_request(rq);=0A=
-- =0A=
2.43.0=0A=
=0A=
