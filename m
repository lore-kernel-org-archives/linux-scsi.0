Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2044.outbound.protection.outlook.com [40.92.103.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8645550246;
	Sat,  6 Jul 2024 12:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720267410; cv=fail; b=tGe9yplNaZey69t5Xm2b9wGb3vcxtACW8K1omAhSN+WYhSaQs533yaqujPBokvyO9t8lpxKwM3Q3fVZAzEIqOe4M+ZVb1FSG5QITkxHZcwePCZzQgrBIbhcjRLH7gTUZCVWEWTlj64t/PwyWUkQNQlLP2EGGkgulVtIVpQX9/go=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720267410; c=relaxed/simple;
	bh=OFkKgxXvXQfLZf6Ayy/9sggFpDnWcjmfVYgIhHtU4ak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eq6NzWqIt0I1nD6R+rVUsLXXjMT6SpWVM+NRmHGLtwrl+zRetQTNMM9XmRhw5RqGv9uVFY/KFbGsiMGogs5PFD/oWitmKvb28dSP3Jz4pEdfH5T3eb0ARelrVIvcoqgtld2Y3SGm3LVDBk9PqeyOWah/iePlUe1i0Nw17yzy6MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=fwDHqypy; arc=fail smtp.client-ip=40.92.103.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="fwDHqypy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUcq6yBcdXvafI7m3dkUPYgnFQtibjsDWF4z1I2rXq/KWDOhWclgwR1gfYFW+b55+32AL4YSoj9SmqhorXLeokQW2/o4ZpR/X49oo606o1o/zA3B0Dk35jkPGCFc45a1eYViQhnTyJTe2qsf66ufGhkEivWVbu5l5jMecS/eydeLKDJ7s3jSuL428SI10gClc1gsipQdPKCKR+2cZHjD7VqnvZhjofCjolwP/7swc2v1HNSdPkUoW1eGE3vaetWsRk9e3iWwu4Kavb/KguESRl7KcskVHCnAP0/0MfrygXSgqCK/zCHodwTuVBR04zMxIs5cDn8rvbua+ark8I5PRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwcLnKkbwNtSh+Fo870t0RFr7qhod0dYfmejPREligA=;
 b=BM2ea+VbJt/3x57rzWp/B03Z8MZ/QewYCgX43PahAIl9t2sYhp4Sj0vLcOs1w9DBMzWa5E2tbbWEcSflf7UWV+fIfuz+0dmM4XN+hZhau28ItdAR1XV4z55s15A7ReK6sduJesZwswolFU0+vwHE1HbgADztcUizwlcpj3VVu0ZBn0+kDrvqLwCj/M5xLeuUZFM3/MCryBAQ4wUfRX/Y4w6t6QkwAXMRXbEfUDjCYez3T1+l6qOcX7q+BkqQcbSzrid+ubdLgmNYaFDykLPU6DzalHkzYftdRHDDT+vU+zivB4TEzA2zfzW2p//uxD7XxvMbJVoOX+nBrpAoWBSMvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwcLnKkbwNtSh+Fo870t0RFr7qhod0dYfmejPREligA=;
 b=fwDHqypykkSOgVb4QVwmJhORFiSkuaoyLh/Bx3+zn3gvjyb7t/6UQRwKZ8dsY5BBQUeKSDHysW3G22MzruLgNwX1wn1qM/Z8eAhYKuSIAU3Cm9VJ5FwywUOjq48fjCN1MK1FnJJSgZ+ZcE149OUYgGzYa8Ljtxa2TCg+iJLtU9w+Xrv+c7QSeTZBe8pYtYCEhfPkHowZyIht4d/xHnDPZKtQt+yK8avJDF84//BQ3Syn0tiz+H5llx1znlx/M1pcYyvi6p1SWMWPCtuV8vpLN2prYnyEH2FxNxWm5ElUEdTxRbuVZO+L5TMHa6Xg3y5i8Kyk8gCQC20zM/Uv50NTbA==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN0P287MB1624.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:17d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.29; Sat, 6 Jul 2024 12:03:23 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 12:03:23 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>
CC: Kerem Karabay <kekrby@gmail.com>, Orlando Chamberlain
	<orlandoch.dev@gmail.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>
Subject: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH v3 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHaz5yATQSWsAoR5EajX9/4d1hpBw==
Date: Sat, 6 Jul 2024 12:03:23 +0000
Message-ID: <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>
References: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
In-Reply-To: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [U4rtLmwegwRIHk+0PwiZxhf/nvZs8+RJq4PD412TrtedcSJXzEzQPGwLXhHna4urC/YGCPi0ktw=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN0P287MB1624:EE_
x-ms-office365-filtering-correlation-id: a11fb56b-9440-4ec7-74c7-08dc9db3a297
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|19110799003|461199028|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 AUQCQOOfy/usDIygSCWcZEFJkbh3cl9fyAPghxReHdVgkuWQGwKpRe+jwolSE+9BhhnytmK2tomuNN6aQKQVnd8LTlq4uRfJjEVIGf3VWpkWtrUEfS44grNrrdC1bqEKAfQsG4xztnfmDsmcs95wzQ03522qS2XEJdsM/qCM6YQiMHo5wjTGsrByyXwWGLkthsnjs47LsC0zpt2zUDM+2f1LoobVbI98jUzHt8eBTN4K3OBTQO5ibQmzHNbA/RuGZPX1yqKPiKoVQVsEqKN7CJvU/m4VEwZUAaL/6qGcWQ6wq0/hj7p+jlpm50bhkK99hilYpltKVP2AzDfD7t8IO8EVwVkqwTwwwnX1aem0khNO2dJiEl6P8ZUiZhkpBH0MO8BgmbiuRC5v8bzcp1XSxuMNmr8RKqaO7sIu1tDI3REqKwDmHRDGgggO/tp49PmFKjUymQWFiRyNC3SZWKw3Cq0yFeJbu7Tf14+v7xkba2vV6naUs0Ff5mIPDhKejzNHDhern4c1A1gfQhQy0oUFkheyoeg/UiyHYMbOmU5Pb6Oau2TEeOQrTmE+XFEf5IWflirt0QoqhvAmwdlEjKTYIh0/msIFl4EmWEmF9IZEFCnsjaYmmfBPpbH/yqGEyIbOpm3KH3uX/hiC5vxzJFHOXA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?C7zhr7j4Qy45FJSVAKp+ukFF/pGhMglvqaCwsaXme2Z7+zKYytjauOfT60OJ?=
 =?us-ascii?Q?qX992QlcTmJFdNFsh5Stkbo2K6dvazukGLZ8usH9SwoA9bPa5vv5RlLhqpyf?=
 =?us-ascii?Q?6iVzLMF8Sy1wvsmU+JuxgAIANSzRqKr+NOr1YBjBOhEi1XPNX0R1EK5sHl2O?=
 =?us-ascii?Q?OHOXvdgP4buRqRVZgUlatSN4L2fFSSBzY28pXfLxUyq+ZY0XrfFgk5Eq0WL5?=
 =?us-ascii?Q?Ivyw4X14zI2xBoBaBn0VWuQoI5LYl99QoS5Pjco7sA171hH9C9aR7SJbktTE?=
 =?us-ascii?Q?vfwigocv9WsZvGapG0wqx2vhOmMVyY58cgBcabwinR1B0D5EecrP20wim/2q?=
 =?us-ascii?Q?rHkazNixos/A/vZyh09GJxAyz6vjAeiDLtVUFNr1/jXLE+RUfI/muGoqNrg3?=
 =?us-ascii?Q?ofKLEFEUkJ4YQ2CDXHfrhe70b+LXTH21XP7h6n8/KWvYOIhqYsT8x5BeIHcN?=
 =?us-ascii?Q?od+sVHGqIeukVTz9X9vhYdDuUPf7AsmLKZWUoLGkfxE2iIuOfOO+ADQNp/nq?=
 =?us-ascii?Q?OSQMNyMVHYuvH0rL1NvrSZdobjtGu1wSqZdwHoSTguY3LX+LSCLqVu9cMsiD?=
 =?us-ascii?Q?79BNR2NYbGyHfpHxCNWTFRC0yBxgGJwiVENK5vClueB+IAJVOxEOyLGjwjrj?=
 =?us-ascii?Q?kZ9xTl1iJqjj8tX59qbjy3QGgFgINHzFb2oaubpBwV3JV5KMk5w71NgUVwjF?=
 =?us-ascii?Q?Lo4Enw+3Pu6JMl2NCiy01osd0WKxftSBKxjG6tQoyCOjhg2nZPv3PDhdNTmw?=
 =?us-ascii?Q?WhgGEP2V5xWtazHhUvebXsYL3/xwFfiGN43wA9afODR8qULf26ebBiumq5VV?=
 =?us-ascii?Q?bdF2gYZ8C2KZCbVwzXZDDkqhuwvi9nz1RYq2nR317HjToA86apT6suLzP+l5?=
 =?us-ascii?Q?OYuez15dfPAJsNZ9s097yI19vWyw3bURToGPxUd1p+BunmpZStsE3XNod7vu?=
 =?us-ascii?Q?JFKv5Zmejp8d9/p9+cDJJu+dkz+/Neqg+RxBtsIHXIVe6PHGbwT8vjKGNorj?=
 =?us-ascii?Q?UFC55rXWDBjbu88DPrbwLS0WsEEs6Qbkv/gPGlmjmCPvdbYRpxWKP5HqHEhA?=
 =?us-ascii?Q?4zPYHyahX3N8UZ90W5Xx44fyT3TEdJUVP6iMLuf6LPZJ/LqBRPdl+9tXeRBs?=
 =?us-ascii?Q?XZ14ySD9VcWSak6yq/lWuaWTx3jhJeq51ytkuTPHBzhLKMnRVqfBdU41sFzC?=
 =?us-ascii?Q?XruqVpbQhgyG2NbVxepQdgMZCqqB9U5UNC8I7r57mRZ7jHOJownW3x86Ox2w?=
 =?us-ascii?Q?1wsfzA7S4LkDTjHGW7ehsz/GSZMsg0/4uRmALVM8NCmLifSE+lp0IpohcT0P?=
 =?us-ascii?Q?6JWEATExR7CqsEB+TN58SVXa?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0E6B6729E4CC4C48B8BE0511A9813B06@INDP287.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7719-20-msonline-outlook-24072.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a11fb56b-9440-4ec7-74c7-08dc9db3a297
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 12:03:23.1677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0P287MB1624

From: Kerem Karabay <kekrby@gmail.com>

Currently there is no standardized method for USB drivers to handle
shutdown events. This patch simplifies running code on shutdown for USB
devices by adding a shutdown callback to usb_driver.

Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/usb/core/driver.c | 14 ++++++++++++++
 include/linux/usb.h       |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index e02ba15f6..b35734d03 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -517,6 +517,19 @@ static int usb_unbind_interface(struct device *dev)
 	return 0;
 }
=20
+static void usb_shutdown_interface(struct device *dev)
+{
+	struct usb_interface *intf =3D to_usb_interface(dev);
+	struct usb_driver *driver;
+
+	if (!dev->driver)
+		return;
+
+	driver =3D to_usb_driver(dev->driver);
+	if (driver->shutdown)
+		driver->shutdown(intf);
+}
+
 /**
  * usb_driver_claim_interface - bind a driver to an interface
  * @driver: the driver to be bound
@@ -1059,6 +1072,7 @@ int usb_register_driver(struct usb_driver *new_driver=
, struct module *owner,
 	new_driver->driver.bus =3D &usb_bus_type;
 	new_driver->driver.probe =3D usb_probe_interface;
 	new_driver->driver.remove =3D usb_unbind_interface;
+	new_driver->driver.shutdown =3D usb_shutdown_interface;
 	new_driver->driver.owner =3D owner;
 	new_driver->driver.mod_name =3D mod_name;
 	new_driver->driver.dev_groups =3D new_driver->dev_groups;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 1913a1383..832997a9d 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1171,6 +1171,7 @@ extern ssize_t usb_show_dynids(struct usb_dynids *dyn=
ids, char *buf);
  *	post_reset method is called.
  * @post_reset: Called by usb_reset_device() after the device
  *	has been reset
+ * @shutdown: Called at shut-down time to quiesce the device.
  * @id_table: USB drivers use ID table to support hotplugging.
  *	Export this with MODULE_DEVICE_TABLE(usb,...).  This must be set
  *	or your driver's probe function will never get called.
@@ -1222,6 +1223,8 @@ struct usb_driver {
 	int (*pre_reset)(struct usb_interface *intf);
 	int (*post_reset)(struct usb_interface *intf);
=20
+	void (*shutdown)(struct usb_interface *intf);
+
 	const struct usb_device_id *id_table;
 	const struct attribute_group **dev_groups;
=20
--=20
2.43.0

