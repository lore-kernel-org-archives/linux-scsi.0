Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2053.outbound.protection.outlook.com [40.92.103.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C389D4D8BD;
	Sat,  6 Jul 2024 12:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720267497; cv=fail; b=I2uZjpx6imIug4R3g5oT3PHjTgiQHRSWtmwfte32Scd5EYvLd62joSmO3KYiJKwUl5kYS/p1nrMPNbLt1bwcXfGJJc6BgneadWuvw2yRt1vP77gS+pdTuhZQGePQBhSlf2HqdB0TNJT8qNV7roo37Prt2q7b3lh2XSWXB7wvdrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720267497; c=relaxed/simple;
	bh=4GVtqrG6YOOrKej8NeCw9MfDv4Lqn6Q4011D2PQlaS4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fV4dPIY8fiE397W63YQxZGwLU1O3ZcsXumjCuap7Z9wP6wba65VTGZ9v+7TigeokPNVDJcMB81hcGN7pbfmum/aMnPH5ZVK2j1w/ffluCX1MOVL+IuPOvOnxrCqCrxuWodsSVeEULMTzZFFgSY0FgrXzlHbkygKQnqecxKrHnUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=jbjQ5m+L; arc=fail smtp.client-ip=40.92.103.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="jbjQ5m+L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWao5yovabtbV7ht9rg4q/GcryseKSljCvD1bb/tdxqgcFdm1XInSb2u+Uw7yZYWDoZsJvYagdIP/wWol1UQPBabpyxHGxjzzqiO37JhM+Ocr05mBweKSgl9stKL3Tw3zH5DLZA1r7d6a2aDL3b0yAXhIvf4Z/efjNtFJBWW3ZVWuBCixO48WluuYB2BLj7fh/dobSIbYkOMr3y9hthl1kofwHAYkH1Qk1glh1DaVd8+5F8GprcLCDJVEGO7EGKvyBichFOfKq8ikFGvZLxHa3hm0vrQJnbu5MfgbHD1RORNe29Q4pU1hFgqj2wm12rATLBPX5eZ0nfzveBPWRMdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s0+HzOAKgOSOLCTPB+HgtrTZfYPWy1f2kawCiB4UfQI=;
 b=X8ax/Ee3uJz/4HDRjbgXudiN416UDi6/QzUNVuEA0DfqZkM64Fe2LSB9E6nIzzi9+F6A9N3RypQzIq+HYy+3TLK9SJKEpJPI7PGK8c6rrpcarBlon5jUrQNvIJpmDh0hO+e55Z9l9TI9tthGAfWEvIFEwl/7jNuvJth42XXXWpwr4a1tflM4brnr5uKyLdxA4HrEzoo/M1ZRYHXqpO3jdVfro6j+Q0MFLWqN/2hNJm9LbMc8BzCHBOObhRMHAE8dlS4BejLb/fHWzajwCglWIuiDposloLnzYRQrSTv67V1JjL1NJzTCWyl7L+YgwnYcTXwmuDwDBNzq8IyA3Yf3Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0+HzOAKgOSOLCTPB+HgtrTZfYPWy1f2kawCiB4UfQI=;
 b=jbjQ5m+LSWVZnAp30sKl2v6sjn6itbBxPX2HCbHCESwAlbZZRT5A+w5RzuN1IqCC9UXzVIXa4WUGHMvylsEpRYxTfXQOG7RkYIxOLONuJT0NQcp8fee6rZSWyoLCEj1X5zXj0K1BXq6CksJSFr2OKZ5UVqVzAW2efzH69yVbA7AUAWEZk1T6qCmtDJzDJkU5oYKj8orInv2gIwPACNfg/pdpC4WvyoNNfbLUkuK7/hda+h+Fglh7oalz1UQZDicp6TNRDdiWtQ2jc5JFkVWqZyKYC088w1xfVo6f12xRKI9GHgfgyztKc/8Z3g99QArU456zza7TlQaQ7hz5Gw6bzw==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 MAZP287MB0611.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:10b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.31; Sat, 6 Jul 2024 12:04:50 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 12:04:49 +0000
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
Subject: [PATCH v3 2/2] USB: uas: Implement the new shutdown callback
Thread-Topic: [PATCH v3 2/2] USB: uas: Implement the new shutdown callback
Thread-Index: AQHaz5yzQFDokFeVvUid6lhswzVMIA==
Date: Sat, 6 Jul 2024 12:04:49 +0000
Message-ID: <E3A502A9-6572-4F1B-9EB2-2F6F0C4E6EA8@live.com>
References: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
 <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>
In-Reply-To: <7AAC1BF4-8B60-448D-A3C1-B7E80330BE42@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [ddM8LUVMufN/Fhdntw8EyoUfkzl7a8mxYB1LVr4WCWg95ai8GIKjYnFTeZZdWt3a2myn3CqqQps=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|MAZP287MB0611:EE_
x-ms-office365-filtering-correlation-id: 8811a9fb-7eaf-4b37-af9a-08dc9db3d64c
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 OagswoGEC3Nztk1EowYWjQLRpG++/2m9tac8Z8woiQWhpbhJOcW/hfsamM1EZFkxLrXa6WW7UxInrsZJOviKfVsHRXXUvI0/Lpe+Y8gu8kVQKtHxaBua86wn99ilUA3WvAJkMlfm491FAW8Kr0RpmZNSXorZwSfZ0+TZUmv8OCfSoXklfYiqquPCliQGyPb3B1re/hdtfyW0z2JmiOaAxXC/jSAdj3qjjFtljBj79ZYUkGn479wLNpvl8eIDFw1mtTfPqYXrht7LOUtSseTj8XVf1Fg00Ydbo6igiG9o3u8YMEMRUWb3I6+yUNn8Z+7Jqjgia5HLrtxROFhrBl5GYm6Q2xj7MLclPl222iQmJ179xynUJ6Pzefz3xuZyTa/peFxFr34LT7eSB99VRK7/ll6q3Ymtb1zdhnN0kZzscA8o+NsiPmxPIlPvKkVRbfe9D+XdCVK/7DMEwQA9pilwk3QJTjj0JRgYGiHgrwC40KtypOw3LXUZzGxpdwMM4WwtdW9J+4afnTokhThugTH3XCnUNZqISUHElsjIroU+1VMsKh5s7BTbn4s3dgjGjA5f2RnNL3xNuDEHNoCBleTdYkD1RnUAgSE2kEhAoI3ZbGhEGKnsVrUkDJE3DV5pHZwbohutk7rXWMxv0dxFEaZ5sg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KVXD6XgDduyrxcbCiNlfx/5BYR8i/H1z1msb7uS76UUEJWThkN3lEWnrtWC1?=
 =?us-ascii?Q?/fVrjtQCRdgnE7mOShOIkujxPo+ubEWbVqzcAzWWdpaTTgRDNiET5xPzrR+0?=
 =?us-ascii?Q?3Mh4p+7H5JLko79tCW9x2ZhSyH+6tB/YkDshLd4Jbhc6n44b5hPIff+Qxo1+?=
 =?us-ascii?Q?6cGPlq6XkFcRrrD2tvXHMoSu3UNre38MW/r0OSwzJDB1f/dUV+obvLUHEGKH?=
 =?us-ascii?Q?8VPmnogy3ta5bGrX0QC/c7OUYzQOY5blrOzOCWY3dxAneaYCFtrO1+IQL6Y8?=
 =?us-ascii?Q?8EGOC+nNyjivGU/GlaUmg3lgC5XcawTCfxwJVsdIScIqBUh0O7my5Ywxho4U?=
 =?us-ascii?Q?Hp3ID3YrsJokH/cCGou/YtQd4CmrLtZwgWFnvGMF3x8NqOzCqkURofXWH/J6?=
 =?us-ascii?Q?jZdBaYFIZBQfks+rswBpnxX7cq89eVVdmDcQT2JsLO0T8Q1UGMfO0WudABVD?=
 =?us-ascii?Q?8r3BJOOM3inchfwqrf6n0uPxYn0fte0EWdiamDAz4Lw84eF1m07YOXt9ij/z?=
 =?us-ascii?Q?U1MyKGl6pSRiK4CNR6G3fDrhRf4nYc8djMg2UziWySyQtVbABrdfnkOdxBMg?=
 =?us-ascii?Q?tXHYIvzigXBQk3s3AgXzBc6KBJt/AJS+FNVH5baDqxfOIgeFp4GGogIb0bvu?=
 =?us-ascii?Q?UkVbM9rD5getb79KMwrgvSTKOP3jKROWHWXEa1LQmLZNSOG/0RPn0exL5xKO?=
 =?us-ascii?Q?XhkQmbK7t6h1ZnpkHecgIkQNnjFnpgrT5RfCI09EdPFohXTeuur5EMShgPA3?=
 =?us-ascii?Q?aTI2smsNLXdp8J4jTD3I66xub3EXeTqqcihjnQzkiF2FIiVFLAm0N+tZUH2k?=
 =?us-ascii?Q?Uy28UqHL1AU9Kp76St0iw3VuciHQupw2yX1X4vsekmvdoPicb3OlgAmuaiLi?=
 =?us-ascii?Q?K4huCZlCwOBwrucNdNxOZb9bGK6wTxZLTLcnaQqGd2NHgcVGUiQ8zUKYIPDd?=
 =?us-ascii?Q?bz9wWF4JkuxLHuNNGaLADMuKCWOXyDZ1az3kO+eCMRyhRTCU9outmysn7Pzu?=
 =?us-ascii?Q?xlGBnbJy+Roykj+9PxcUynvr2e0Xz6JNnvX8bzTJuDIUOSDqfBmdsbcqHasZ?=
 =?us-ascii?Q?jJ4rwtbgb7DDVB4Yo1Uflr1aEbOJGMsDCS/EhBkYAtZvBX+y4/O6Qvr8u++y?=
 =?us-ascii?Q?53Gl9REOR/IBDgwEzC2F8vIAnRMKNk1279R326TgjFIj7g57ohX53Fd1aVIH?=
 =?us-ascii?Q?1U9E/mLUFb3M1w6E0+dXhhXiNLu/T372wrPOfYB57xnZTLaqS/s4U7atQF9q?=
 =?us-ascii?Q?i0ZHs1y7Wg2XhcIN1mkTCEZui3kdSm3jWeiVBAmkT91OmeMeaUk/lqA05vfD?=
 =?us-ascii?Q?fkT+DVBPjBqLKVWQoyuaMPsG?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4066DB1C1A0D2B4993C86A646AAB16B7@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8811a9fb-7eaf-4b37-af9a-08dc9db3d64c
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 12:04:49.9232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MAZP287MB0611

From: Kerem Karabay <kekrby@gmail.com>

A standard implementation of shutdown callback has been implemented
for USB drivers. Since the UAS driver implements a shutdown callback
this patch enables it to use the new standard implementation.

Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/usb/storage/uas.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b610a2de4..0cdbcf825 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1232,9 +1232,8 @@ static void uas_disconnect(struct usb_interface *intf=
)
  * hang on reboot when the device is still in uas mode. Note the reset is
  * necessary as some devices won't revert to usb-storage mode without it.
  */
-static void uas_shutdown(struct device *dev)
+static void uas_shutdown(struct usb_interface *intf)
 {
-	struct usb_interface *intf =3D to_usb_interface(dev);
 	struct usb_device *udev =3D interface_to_usbdev(intf);
 	struct Scsi_Host *shost =3D usb_get_intfdata(intf);
 	struct uas_dev_info *devinfo =3D (struct uas_dev_info *)shost->hostdata;
@@ -1257,7 +1256,7 @@ static struct usb_driver uas_driver =3D {
 	.suspend =3D uas_suspend,
 	.resume =3D uas_resume,
 	.reset_resume =3D uas_reset_resume,
-	.driver.shutdown =3D uas_shutdown,
+	.shutdown =3D uas_shutdown,
 	.id_table =3D uas_usb_ids,
 };
=20
--=20
2.43.0

