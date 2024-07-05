Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2044.outbound.protection.outlook.com [40.92.103.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43741154454;
	Fri,  5 Jul 2024 11:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720178473; cv=fail; b=A0ib+5vX9uzYHp8qJnxJgDEtEUuUzaKopQtTKUR+3MebDGTD2pW8n2SKHPbzQxddW8ySfuSrTdjxZiEmkWJKLPGj50BYKYx440021x5m8dsrOxMLvbskobHk/s8XimUYxgQ3qLx7x1VggeAjiLXl/v6JNM96B08LRX8P8XYmSxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720178473; c=relaxed/simple;
	bh=VsQA3btIOyyN5eTQG5sE76+DCPEgKGpuFW8KD4X7rGI=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hMz+tiJ2CB6cBkBQTxbvogVWmdJ607UBkBZrfLiB9VsaySwNltJUUFvxnLMT7GFK+M6nEekkXx25Jkz5px6xdKjDHv/pqJWA52nt9BJ+m9yye439n6bGI0L1FrNP68QosTqz9ZbmEQP2h78scYAyt7APRMDJimZjLE5NOXGdaTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=MQs3KgpX; arc=fail smtp.client-ip=40.92.103.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="MQs3KgpX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X27ESOq0FE9R9xjw0psLUGoWPSH9lMYDiWVWMiv3sQ+hZi8PTA2owMsQELlwUT3cj31Ik18SmM67hWnekGJvNr9PuS8CFyCkLSpnpq9+ntUdsrt9V3Tj93JvRXCOqYvENAp56fRcd3giH35dsl3i5axWVWc5TBS18AHv4q0FTfu8vP4xArdk1JPU3WOfmAU9EGILfKtSxS3H7ha/+GQIVqDT5//gteT0o0eUF8IdkUW8kdMIoeFogs7gIQuubRHZDDhPY3wDLG5M0+cRGqvSOyMN5BEUnaTAeEPgmRlRFoTPU43pWW8810wrY+LvnvjpPAOZGIIPRyzRWnF5pGlLRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXIekOKKIRkBWkz9TBaQ3jRxcRXC31sJlxol7kFnw1Q=;
 b=jteogqHVydjCjILTXEurUSBVJKs+lpWR/loZqjd6QFmMwXb9Uw8+BcEnFF/kBoSRwlMjrscPTeL6Zdt27Ihi/7+iaxxu3e3Mi42NpLzqjNMFaEpqRV9wsZ1HPXEsZ7Z+OoGoxask+Jkcay5gv/TXrgCJQg5Gn00XpGdRqdDFna8H4jyYpsqD3fGt3cKNXN+BZT6F5C70bRchAMk3IjGgQRyehRaNsbvgZJv/o2NRUVp8rE+VWERKBECFzlA7BqTa/KOLGl6gTsSRymbHBX/xbEhjaBGzOkts5sdkP+4ur8TKWgZJ/XJKmUpmpOPe7B3ij+XPCT7puaDXdwkXNBoKeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXIekOKKIRkBWkz9TBaQ3jRxcRXC31sJlxol7kFnw1Q=;
 b=MQs3KgpXfEqlZhoz337szERNZEYfa95QkTjuIn5VktYd9OCvR3DD1P411iAPWUZeSf1wfLgMpw2HHMQ0ZBAY1bmekRZd3Y5rGt982Rp4LyUdjhcW/sC23WyTlKtzVgijanc7eL38k4W0hrFYhY9TtisuVm+xZibeWiSYM6wmSpgb0wdtFtnh36l6NTJVcwmtawabRbIIJT3KseMMLxszbk9wh+H9na550umvFnvRZRTVxzs1E9XbI1MvpYxbRIBAohBiR8hRvlUvGxO9AVvugpmldIvC7GewwTdx7waQ+FR+yoRfbHVgiR9D5772DM6dncaFyyyjGWdoqSnJJiZxmw==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB0940.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:136::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.31; Fri, 5 Jul 2024 11:21:06 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.027; Fri, 5 Jul 2024
 11:21:06 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>
Subject: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHazs1t9chFUYSBMEexlQB4J+o1vg==
Date: Fri, 5 Jul 2024 11:21:06 +0000
Message-ID: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [HfcWuuMloIhumeMI3AVFLSw3fUg3ojAaJTnl0GkqE1zR2b+7x6/1Qarme6/K4xNi]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB0940:EE_
x-ms-office365-filtering-correlation-id: aa1aa1f9-e67d-44d5-6b9b-08dc9ce48fed
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|102099032|3412199025|440099028;
x-microsoft-antispam-message-info:
 YhfB6oeE6c4Bij2eKi0N1fQ+KVzdFJHj7mbwPVuXDWzRg/SCQvYHaTpwuvqSavpPuzusQbxZp6kEcZxsFaB/c6QPZnh0F6FarMPwOt7KYCXRLgGtVj86QnbTpu3z5osMJ29FIAuOlmbkx9k5kM2xHdseN4hGJ0QQPzbTrLzLJRDJ5qLIij7XOy6kmPe9u7JkiErqyVBoj+JwVstTAegfZjkoV/OvdgM3PJOtJXOwGpktWmmhvo7m9+9PzvBKnYwJhAaUuBMWV0fau/UJj0Yxtdq8Mb8bEEVYrvBLC9qS00iKL0A1IB2iqbD9YS79wJvjRubFTW/tjXD9Cdou4RSfPKqmFT9wKunmvO83V98+HvXNAPW9WWyvMI1/lZB0wCZGgZ4WYmB0SkAbb2VaExoGr+ezr2FGrbw9RXWBEZVpf4jXXkoSxJiHmu3v6sVx8pW/FDeDy1porwTxZ5OkULo9ymtm5fs2rEPwxbUlCkk/Ni3F8Ckez25YZStmpAYgQNieUrax/vp4Rjd3AtHO4YHhf8RspwO6img+5YCcUT8A6wHddSOwZJrAWvczCcvUVIOek60LT9nRcxa0hUwoSm7GzY8qqbhEugTd0fog7ykI/dd1cPyh6fCDDvsi4L04AXsu1wPNRHnvLlqcE1QzdcrOjw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?CBUlz52HZbzzA8nZOG6di8fd7azQQX73RzFR14zCxUYyMRY+zLBs+9XC8jEp?=
 =?us-ascii?Q?6+IwLMJljhSmDNClLx0lo+oQvP+jC6idmWZbmlomgtwEhZwjRVn10uJrE46U?=
 =?us-ascii?Q?RkpgTewqjoPqF/RwGQU2RnRzO+vnulLMg5lzlxxeRkRqo3cLXe2B5YMaofmH?=
 =?us-ascii?Q?abGqFiEnKgbhdNwjjJJL+ZschYwQpMnPmevgn817tMUseSFSd1wvlBDH5ZnD?=
 =?us-ascii?Q?IBkozmD3YEutvocAp3OuOcatya8BBJEVmfM5xzTaLf8erJtu9tyEcHuADDcH?=
 =?us-ascii?Q?iY22vvuse6ihaaVPP3GRS/piRYziU9/Svm5rxiyKLt+Olz+flJNK1yKtAqf6?=
 =?us-ascii?Q?+UlaE9eyT9h2f+NOnD8jvFgTsRrZTo4m4EfxZOvs8qMqK69TwJjvePJ6sjyE?=
 =?us-ascii?Q?Zj8sgPUMendB5/pCwxjoqqXkBR7xCy3dOfx/ABFPdGS5oLzMsWDc7uaiCXl7?=
 =?us-ascii?Q?a3gkzYWNk1M+xqZ+ZCPbnTWooXzvnVrnbcT7Qt1wvCx3nPcbTtnCrErDVXEu?=
 =?us-ascii?Q?OOUAgiyhlUCYv45N2yJxE9YFyuBnKh2xsHj7yJl9NrK7PdmdFxi5hTH62YHP?=
 =?us-ascii?Q?WATi9SIYQIfHFlYkn2IGcPP6UH4EkH4cdRHj1P2gmyZ+IwxknZBbVlOj6XTc?=
 =?us-ascii?Q?EcCHRcfR72Vo8TRHaJSPAibe/+Crh7V8YTa6GnygevYD//dbtQK7CCHDdcgZ?=
 =?us-ascii?Q?J+wd4CrD345B9BWXIQiF3hhiyIADGbWcjbIHsRy3goE8rzAwqnXfCKiwbOBh?=
 =?us-ascii?Q?F/HVM+mUifEgzjBOv7n2KGaSsXymUC5X2JiRkYSHxlCi2lOFmrpRiZpLNb09?=
 =?us-ascii?Q?QLGGDc2Wl66lJAL9M3nT24M8y0SjWAPuyI/INVGZVvx2ZurmthYWBACnweHQ?=
 =?us-ascii?Q?UUrNywRjCsxSaK3YM13FFBtYUHwevKXwRmwrVrTbctcdivSlvCNffYd7LPdE?=
 =?us-ascii?Q?CfgCjL9NvOL9grc4ct0HwboIoFcEV53g+Ch5VpvUHSOU2fZaMEfyvLtFh03e?=
 =?us-ascii?Q?koTs0WpJAgmC88Plkv/Wn+/I/lZBG5CYtiEIifB1wV4oupXcqS/SZLQgOGQ+?=
 =?us-ascii?Q?AtI7Cu1thwo6PPxqO/SAiqqVT0CFR6bWL+eSEf9C0RMu2l6MbtyNoMSXP/Ny?=
 =?us-ascii?Q?gBUpCyLdBdeTKnuDR0MXrLQeL3m8uC67Vg4XkPTndNntDa072RViXyg+8iBv?=
 =?us-ascii?Q?vAFakyVixcSXFhN+hthsbupRl7fBro6T684MEsF/BcpHhclyAyiPPCba79WK?=
 =?us-ascii?Q?ZhHJocL+oAaIOaJh7SC1XwvvxNA8UTM6weaMAZyujLKg9wIyP6bxETqQZ8Sh?=
 =?us-ascii?Q?9H//KKgcIFsgmW9x5Ly2eynp?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61328D1390137845851B653BB91240AC@INDP287.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-bafef.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1aa1f9-e67d-44d5-6b9b-08dc9ce48fed
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2024 11:21:06.0328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB0940

From: Kerem Karabay <kekrby@gmail.com>

This simplifies running code on shutdown for USB drivers.

Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 drivers/usb/core/driver.c | 14 ++++++++++++++
 drivers/usb/storage/uas.c |  5 ++---
 include/linux/usb.h       |  3 +++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index f58a0299f..dc0f86376 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -514,6 +514,19 @@ static int usb_unbind_interface(struct device *dev)
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
@@ -1053,6 +1066,7 @@ int usb_register_driver(struct usb_driver *new_driver=
, struct module *owner,
 	new_driver->driver.bus =3D &usb_bus_type;
 	new_driver->driver.probe =3D usb_probe_interface;
 	new_driver->driver.remove =3D usb_unbind_interface;
+	new_driver->driver.shutdown =3D usb_shutdown_interface;
 	new_driver->driver.owner =3D owner;
 	new_driver->driver.mod_name =3D mod_name;
 	new_driver->driver.dev_groups =3D new_driver->dev_groups;
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2583ee981..591fa0379 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1221,9 +1221,8 @@ static void uas_disconnect(struct usb_interface *intf=
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
@@ -1246,7 +1245,7 @@ static struct usb_driver uas_driver =3D {
 	.suspend =3D uas_suspend,
 	.resume =3D uas_resume,
 	.reset_resume =3D uas_reset_resume,
-	.driver.shutdown =3D uas_shutdown,
+	.shutdown =3D uas_shutdown,
 	.id_table =3D uas_usb_ids,
 };
=20
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 25f8e62a3..5f3ae2186 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1194,6 +1194,7 @@ struct usbdrv_wrap {
  *	post_reset method is called.
  * @post_reset: Called by usb_reset_device() after the device
  *	has been reset
+ * @shutdown: Called at shut-down time to quiesce the device.
  * @id_table: USB drivers use ID table to support hotplugging.
  *	Export this with MODULE_DEVICE_TABLE(usb,...).  This must be set
  *	or your driver's probe function will never get called.
@@ -1245,6 +1246,8 @@ struct usb_driver {
 	int (*pre_reset)(struct usb_interface *intf);
 	int (*post_reset)(struct usb_interface *intf);
=20
+	void (*shutdown)(struct usb_interface *intf);
+
 	const struct usb_device_id *id_table;
 	const struct attribute_group **dev_groups;
=20
--=20
2.42.0

