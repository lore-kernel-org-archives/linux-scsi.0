Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazolkn19013070.outbound.protection.outlook.com [52.103.20.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE78E3AD51F;
	Sun, 18 Oct 2026 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338074; cv=fail; b=rjznri4h//ATSCRxt9GPwfgdCHL4vGuBeYTyQY5QfvC+qjz0JQAiwMq8GS9D1+QxgCJDYo/XprGWcEXEUw0iioBJLivAy46nJxj1uCUrv1T+9gEPB+IfEerHZ2GiK8IvX25dfu0lv8oqWWcd849AcxqDD51alYiszGrPWuBadL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338074; c=relaxed/simple;
	bh=Wx6z6rF30F1OS0+sp/LUJi1OatSBl9oj/cwLAu3hPB8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iRH3fRifgYBgdMu4m5B9I7o1i196bmolm3DvlGy41I2+a85IA7infyZ0PYoNIccpe9AC6kWLYNQjjUexljrgkNY+3lxO3sI61ImTyt5Wc8YruapTrN+h8Rc7FTafL8Yo90Vg8WoH+Dn4Mjm8wyS3TqsurhWCIBYd2Ie4GHZl7J0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=UI31l5C6; arc=fail smtp.client-ip=52.103.20.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="UI31l5C6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IdW69xXQmSbuYngJNLk0s26eWpv1bQj7Z9ETBTuXG5UBFSkjkl5Nmgu8WRpnu4JOrC+JhO/Kz7ge5Bt0GQ8tDf+n4/ryJQ0mJ7YxmnIyiw8A9HqZIXVYRmzZ8FMn1xObUGEnxB0j27XRoxg4sy5dvHEorJG7lDrCUoV2RyBlSW4U56XAoLeEdPhLKwDdO9rRqXFbFjS/1fFgu0LAGNFaWD0zzDwJLKv/6X7R0Ze1yA1yyLKJoXDLqmgHtJMJmeVduOmyEgkbUZ4HeDdzTzuiHmDiLNyYIaXNqDGNJkvolgHskiH7ll4iJB+5/Y4TIjl9bqyfsO1uuKg+RdxldQZGpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=kEpaZyGf5OiL8LG+LW1+7P+x1AxaEa2odJYzdg2Sha8=;
 b=fOOjDGHrr2Qh9pzimMihYhgfRH4GyTAs6+LLJFzJzQ2lnmvpnWZ/SguP4cLaJHIosGCHKuaoghlAxM0sOhm1iaL5A23C7vcnUDaIb6SZco8ckycD72XKpjzVYCQ6lbLb9kStp7sMlgUi+LVRBrKAGWIsaw6Sv9ZQsUm1sPR9JbCJgjCsxfYRdIS6Vawn4xAWyUMkECst0WzQxEaR2zHiRzwJIqCNL/J3HNo0RMvwHAHIxI+aup0dHfkHaaaspgXA5rsqLr66Pmp9HMhX6Kkt5FouC9SUYm64noMz39F0QtYTIwlyQcIyxNYU/aCDTEP2E7OlU2AHWshF4plUdmwnPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEpaZyGf5OiL8LG+LW1+7P+x1AxaEa2odJYzdg2Sha8=;
 b=UI31l5C61lPMUNsmee4qikCyMMHeoyJ1XlavZoJLHi/WtGW57Qq7GfwpazvAlCj72RiDIZRM4GvFKJ4wTy4t50j7AGqo625QHAlIW4GzodhD1bdMmVn/WMSCAX66LLwcJYYFHVkqJSTwApffFquJkrSFBNnJBSNIi+uKF+8Q8kzVV2NR67cWQeovhvxtGWsitNnUP9OZBRqsOz4wTRhmyrC3g17faMBuextElG9RovQcgh+403whqkI2D9CUJ1sfQ3cQgCOzQEte/dWYNda6Ao5+RUbgZISPbRA18CpHmbXyELaOD9CIk2lO1YLoAIXBVQcFercgQv8cezVKkKlOwQ==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by FT1PR05MB999137.namprd05.prod.outlook.com
 (2603:10b6:170:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Sun, 18 Oct
 2026 15:41:11 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0522.017; Sun, 18 Oct 2026
 15:41:11 +0000
From: Wang Yingjie <x-professor@outlook.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
CC: "yangxiuwei@kylinos.cn" <yangxiuwei@kylinos.cn>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Wang Yingjie
	<x-professor@outlook.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 4/6] scsi: bsg: report synchronous data copyback failures
Thread-Topic: [PATCH 4/6] scsi: bsg: report synchronous data copyback failures
Thread-Index: AQHdXxcZDVcndQrsGkWhjt4u59QucQ==
Date: Sun, 18 Oct 2026 15:41:10 +0000
Message-ID:
 <73dc7f9bd94295f265fcb81c145c73b6778eecbe.1792237341.git.x-professor@outlook.com>
References: <cover.1792237341.git.x-professor@outlook.com>
In-Reply-To: <cover.1792237341.git.x-professor@outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|FT1PR05MB999137:EE_
x-ms-office365-filtering-correlation-id: e71a427c-9bb8-4ae1-22bc-08df2d2e3c1f
x-ms-exchange-slblob-mailprops:
 AZnQBsB9XmrTkIzDOCxR6E7nJ4I/6XZ7Xrc5cI9tXxevVWHhyLi6NlzsU1VDp1n4eXFAvU8gHhIOv7PCIPxic2tV6N7joicZb3vUF4PjmRS6hTP4kkywQ1dwk9Tq+Ozyigd0s+r77bcRrtwVRZdxe1Cul6aEmNyJeZeKqq27Int1yCKsBQOdCf14e7AIdvfpVWB+eT4JuCQ3VPWLlfFRgAQAxxgM8JGbVHPEpZFuG4e7AHmPOQdn/g+3XL1DfiHFjjBOzQxvNBRm+FiG1jxeayOigk7EzjLLxF/5Qaly3Uxd58SgPWI+5uk9qgQvUrmoq9czgAn/laincx3/ffCXBnI5tT6T4HYi4YkTXMYqD2aP7YUjcMexVmBjrO0g69mlEuTyu/p2f0xa4YmiQqfJEsTXdWuOXUbJisAk1gFEe58dBJ8X4lXDInst/DOR7d5J57ZRvDaKMVfroFucN12PxhDnz1WGu3E2QDUulnHTIdkq8sOCM+XUdkU9yp7KpIGsKlcytDONMuevI+P4gF8mM4J1ae0IApN+XxrawIODoHh2x6zHXccrgVE7j8/vRyWZcZOwkPmHU3+KxOVvWb+m78Rycw4GmMg29RLqZLIUwGMApEQVE8cLgdMK4/LkyZ+k27fWmJaOKIgcXlar0GWyU8zdDAjVjrYqCYuIP0PnPBDcg8mGlEi5EGz8crAo/xtUqdGCRpK8upKLs+B0Ohc/ZLZh78pjEhnRKFOpEu+3L4XwI3GSQxOBdNRxKV2t3BoWK22Z+vQZkQU=
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|15080799012|39105399006|22091999003|22121099003|41001999006|8062599012|8060799015|19110799012|24121999003|31061999003|38102599003|4040399003|4140399003|102099032|3412199025|440099028|53005399003|40105399003|26121999007|3430499035|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?WUme/4VSApJKCF+KteIeY9Ukbo6oX4DqG/aG4rfYZF0cGQOQ58siB9CXCx?=
 =?iso-8859-1?Q?MYlEMyerf+dIrnxwHSnudrfBnSLvaQ+szcYzyL4+zencz468BzVRSVH58/?=
 =?iso-8859-1?Q?CaZzImiW7S4brSenWLGKjxTO1383qDFm0ShaNoYmeciQDlW/nNTQGZf+dg?=
 =?iso-8859-1?Q?dXqEcetnsEVnumaBuWkJsycTuETcDSKz0VZF97wY7BqDKQaARqfqOqBouX?=
 =?iso-8859-1?Q?VfRuzcYd+lWMRIGFQZJsQ+ertGp48RJa14vU7iYtvu+TCgrnSoJaZVD1ZL?=
 =?iso-8859-1?Q?DDsRTmHqVBEDT9IEBDhswz88OECKsCK3HG8l5gzyACimz8eieMnCJp2b7W?=
 =?iso-8859-1?Q?LYYVfChZiv1+hHk4ro0s2uuqYbKqzfNTc4wbX4r+4CR11omUMZxAkL6aKx?=
 =?iso-8859-1?Q?xZUSE22HJkpapJRHDBfuZ0Z1RXBwLVjwxJq8+cGrb8ZbRL+U4VQ/j9xHUB?=
 =?iso-8859-1?Q?ROn66FmdYApTMNGzRVDrayTAWZtnvBHbDpK5bmB4JESpJ2iafWBdnmY+NN?=
 =?iso-8859-1?Q?ew7uwuz0X3rQQUfIYSYWhza9ZU7ngiN6OT39kowNmgX3HH9i7bVX6Ngd+C?=
 =?iso-8859-1?Q?i/1TfJwmY/0M4imTjkEDuQ43WFuUPPEqOOPdWArXdIOq6cYONSXnPsVy7P?=
 =?iso-8859-1?Q?Cc9pCYumqs+Cl5wHq1Xenwl6n5m9yCfWma3N7Wntr3YixFwq1xtyi3J6UW?=
 =?iso-8859-1?Q?yAxE+dVcf5C20OqZHxIN1COsjdJ6AxlkRElFl72vOBYjeCIP0XdCmrGzqa?=
 =?iso-8859-1?Q?6fefPT3oPO9/0XIm1bN3huv/VckzBNq5Jg4Ym2fTqoeLEkykn6qUM06XyW?=
 =?iso-8859-1?Q?Prxuis5XrnI4fmZiI6XfgQF5DY5c9yt74N5HITDldtOoRLvWgKpky2rsYf?=
 =?iso-8859-1?Q?J9dziWck+4U6GLViL6dqysVglYzbETsDzaXUq7aTXeFiDcitPplqOAuEFY?=
 =?iso-8859-1?Q?Zq1LKT9Ryaf+Mc80NgC5OpCAfhA7/14ifm/RUM9pLUy5zfqDG8ZqAkbdEV?=
 =?iso-8859-1?Q?zngdkmjTIH4rj2UMmHNtKapxzWY9YtA+EmddCgsStJRbym4kT/xi4aBuHx?=
 =?iso-8859-1?Q?WLvdElCbm+/LkxAg73n2pwOL16pqEshsX842F1NmQ1AsPX1GxpjL8Y09El?=
 =?iso-8859-1?Q?wSvuamb2GrjO2l3/Yfol14uKFEcmOJHWkksjZ4yI3CWIMKwRTQvSBCZhFI?=
 =?iso-8859-1?Q?8p0HWn7+HqlJc1lrTHh3ZqzgLjJn9rGAKU0kBz5TExHX6VgLy2UMgdB9?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Zz6kA6XRve5MnBTw0dNhYBFUoEt4NI+EadK5sQzozTz1ueT6GzUXVYfutR?=
 =?iso-8859-1?Q?KuKc92K64MqpPN9bjIK8PT345wHOETMjVMaKfNX66SE83cwB0YN4bwLXAi?=
 =?iso-8859-1?Q?2ee+lzcphcOE3bGKhOIoYCBmjlqOkqc0I29ScUQ/Zks1H4asWR6ZPUdNJW?=
 =?iso-8859-1?Q?EtGlIr1BqGJLFpE+WwCUHvx15b1Q9mYac9Oj8CfsWpB4j4oIt9HlpqV5Hj?=
 =?iso-8859-1?Q?LoZxgmIxqAdfLnPU97bmj/axiWI8RG1liLrLmetpOY3zSUce2fJJ60tOFO?=
 =?iso-8859-1?Q?XvEg8xeASh+1DDp/q9zYjtUb9INs5WNWbzERJfm5LZjT7nMgRMaDt3+WJn?=
 =?iso-8859-1?Q?paNtPLM4i2FcVUmYou9mlIX1Y1TjtHwXG/Yek7Qz7GAnEVSBvoVtlKE58I?=
 =?iso-8859-1?Q?QhCSnLzEH52+oc11A6r8iQJvH9grbTr4NGwRp8s4cGsTCFWZqsHyV+LR4I?=
 =?iso-8859-1?Q?Z5ipkmp+4gP2tmEFnVjea2JNzidnaSND0IJm7Tn6Yf+8rj/iCBmSL+fCEc?=
 =?iso-8859-1?Q?n7swP7cI+p0spwJFBudLf4EXH9k105qzXJkwAXfG88RgR8iwM6tXikdRKM?=
 =?iso-8859-1?Q?0eOMyn62vx8qYt78ERHzM/1/RRdG0LiHdhQtFdu6vrIvIGEvUabhyIJj5r?=
 =?iso-8859-1?Q?73PPDB+4U12d6a/pxT5L0MsU16TLQZBAyaCb7QbOS+Y2H8El+YOZZd3NrQ?=
 =?iso-8859-1?Q?4LhAUfNdn97ZFWHnVi64PBGgHRhSySoMHJkrhiBvSbyXq87/M42qIR0GYX?=
 =?iso-8859-1?Q?d+M84+g71tM1zwtL8dS2fydRePbFt9342Lh+WBap6UNr5Kdk4U4MDVmq7l?=
 =?iso-8859-1?Q?oSAIHN+nE5x0zH6YAxutRlttTuR3lEb+YSpJ8yVSk0s1Ts8+fdoQWSbFd5?=
 =?iso-8859-1?Q?vCK+Fb4wX+lUeWJxa3KlCDGaOssRFd+MNp3PAf5eduoIjwxE8TI/mkN608?=
 =?iso-8859-1?Q?XPUnzSWuEkTxS0Dw3XxMclvAb6SUpehpA/0NumhSrtEGxs0z9ilVMddDO4?=
 =?iso-8859-1?Q?f4dv6wVzlxF0y2ut/2d7Uie0eN07wLug56pIpHAaNsGxZrjqWlXiz3hKZX?=
 =?iso-8859-1?Q?VOxAM4QMySa9z/kjgh6yywiDyPA5cWTAbA7xzyxdnbJlrT1gjGnm/8D8kT?=
 =?iso-8859-1?Q?NL7O5NOT94JXlnLBgcnyPfkkjRYANJcUGtgYgYoKM5hSQuIujsek9LzaK0?=
 =?iso-8859-1?Q?WnSHza4R4OIdC5xtHqdP1akUOzv4ZxcdQ0DxmjJzwkh7lIroPf+i9vgdjM?=
 =?iso-8859-1?Q?0N6+AIMfK1a1mvvAvmNh1qI9Q4bsxLqxPVOv2eghnn/o6tRo0nuXvv/NQW?=
 =?iso-8859-1?Q?BmxGXh2gkUft42FANDo7tsRcjN6KjzPRaI0NCcFIy2BEEpLWEtSrfmppE5?=
 =?iso-8859-1?Q?zBCjulcd8UX43bnGnjnY6lqp8dfLmYsWlMSVSW9P3glt8mhVBmU06du1h5?=
 =?iso-8859-1?Q?koguewJI8oJNcPvx?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e71a427c-9bb8-4ae1-22bc-08df2d2e3c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2026 15:41:10.9122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR05MB999137

From: Yingjie Wang <x-professor@outlook.com>=0A=
=0A=
scsi_bsg_sg_io_fn() ignores the result of blk_rq_unmap_user().  A=0A=
successful command can therefore return success even though copying READ=0A=
bounce data to userspace failed.=0A=
=0A=
Preserve an earlier sense-buffer copy error and otherwise return the=0A=
data unmap error.=0A=
=0A=
A virtio-scsi INQUIRY with an unaligned PROT_NONE destination returned=0A=
false success in 20/20 runs before this change and -EFAULT in 20/20 runs=0A=
afterward.  Writable controls continued to succeed.=0A=
=0A=
Fixes: 10e8855b9451 ("bsg: add SG_IO to SG v4")=0A=
Cc: stable@vger.kernel.org=0A=
Assisted-by: LLM=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 drivers/scsi/scsi_bsg.c | 6 ++++--=0A=
 1 file changed, 4 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c=0A=
index 4937bc494f79..f95dc5da7480 100644=0A=
--- a/drivers/scsi/scsi_bsg.c=0A=
+++ b/drivers/scsi/scsi_bsg.c=0A=
@@ -203,7 +203,7 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, s=
truct sg_io_v4 *hdr,=0A=
 	u32 scsi_result, resid_len;=0A=
 	u8 sense_len;=0A=
 	bool is_read;=0A=
-	int ret;=0A=
+	int ret, unmap_ret;=0A=
 =0A=
 	if (hdr->protocol !=3D BSG_PROTOCOL_SCSI  ||=0A=
 	    hdr->subprotocol !=3D BSG_SUB_PROTOCOL_SCSI_CMD)=0A=
@@ -285,7 +285,9 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, s=
truct sg_io_v4 *hdr,=0A=
 	else=0A=
 		hdr->dout_resid =3D resid_len;=0A=
 =0A=
-	blk_rq_unmap_user(bio);=0A=
+	unmap_ret =3D blk_rq_unmap_user(bio);=0A=
+	if (!ret)=0A=
+		ret =3D unmap_ret;=0A=
 	return ret;=0A=
 =0A=
 out_put_request:=0A=
-- =0A=
2.43.0=0A=
=0A=
