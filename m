Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2101.outbound.protection.outlook.com [40.92.102.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D313399F;
	Sat,  6 Jul 2024 10:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720260027; cv=fail; b=qq12yFGLmVrOit2jbxR+5xBylKLU4zuObLFK4Z6lEftGD7cxWt/VeDYXKcdrL/8JpZ14Iur74z74ippTp5cdnR76f3lml8ijFOWyxNomtLGMw/VuQJGcPabx1G9Xz3HAr2j9WaF9USnMSDZj5PQBx7vX8pJc9qzS+drYC6KxNS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720260027; c=relaxed/simple;
	bh=OFkKgxXvXQfLZf6Ayy/9sggFpDnWcjmfVYgIhHtU4ak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=brin4cH1Uc+67JnnfJRKW2tbaEPxqltb/fTfEYtV/P7xuZztaV2fl+SXOM4b8BpR8ooxxG905lucfA3Zvr2O+qeO8fwNuityQF2+11CnpVvJBzSlF44h2krZFxemdTlH2RWNoZGMrcvNZ+q6WgCSBTYeP0ndakRh4hAgV938tek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=Gx1eHaev; arc=fail smtp.client-ip=40.92.102.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="Gx1eHaev"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdDG6PrkQ/fw8ZzKmQX8W56Nx/iAE/KsK4pk1SMcDjwbGRC79wac+978J/HXVrj6aWvwZg3xkyWA+Vtm0n/GMouJS77q+32A00BE2IoUqOyb1/XG5+xqn4OIN5h82e7ZxtakkcaQa3ewRWFAZFzciCzJIUYWHp7xCKhGE1/gKpw4u3h9KPzkIJxdSv60bbo0KEu8SKeiZe+lG6xHtFc3PsUJeM2QELIRqOmSyFGc0/xf5xv+sUBbPFlWjElwCGfr4Lhym3G88lRqBCIZW9A8QaATOArje9cswq5c2wvgh1lJE7ZFzzZwbc/AUXj6vZyuMVhr6ASSb8zf92inM7VNVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwcLnKkbwNtSh+Fo870t0RFr7qhod0dYfmejPREligA=;
 b=ZGUvHgTx6kcWVj9GTEt5qkJbSlp285Jx/YJXWB/4FZCU1n2TxKmowepjpvE3vI0yGC9Xb4t8kvfGKvOt6F/v3nd3ypvfTd0VRir3UZPH2GHdfIR6rnUkDqKTpiGQbZTTlTDu0Y81x3oa5J+SgQdfDOBEaFAXOyYUHEZmCsOTjndlny+rahJxEkokhCzyENqPW6qS3BKT82i5LjHesSnttcchEucWFIuaodtVfNv3c0F3hGnjHH8jDcLkOQoo70634UbET+vTaJf0+1iSMh9nk/BnU3RdYkZzGrsiB/6KaJVxtchnhat0mvi39x4frNsbCXTPIYNVveEkBzC/0ReaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwcLnKkbwNtSh+Fo870t0RFr7qhod0dYfmejPREligA=;
 b=Gx1eHaevctBWFjaujoPZAi6QOlIb1y3YMq8tsCXXlD5mqmxpwSSJMBj8Q5qjj/ZEQf1u+TKUJEE/UzukPf+e83fAv4/RHlyfCxMzzI54wwaHPaEpJbLrfCfX1VfpR1SSq1uyDSSp+PwrK9OPeDZaSNarKpRewjwpPmlF//SiMCnUY9JGCV8Pje42/ZzMMaPrkQGBKTnbF2JV2l7fZQPJhmcqgxxJGwH3mqx5sVfagYZL4kylvBdF6l05kDXXUfBxHACMrw1DSzo64OYRhETB9IIzmyo5pkYsypNCiwdQwnRkN3oT9tZyaQAJ2qXb+4W/OJ8R5lNGrB+CyxiX1kgD4Q==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB1372.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:1a5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 10:00:19 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 10:00:19 +0000
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
Subject: [PATCH v2 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH v2 1/2] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHaz4tO1SR07ZiOs02hIhmy4nGDzg==
Date: Sat, 6 Jul 2024 10:00:19 +0000
Message-ID: <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
In-Reply-To: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [4EiUMzB2V+nZeooo+yOotsRAE7uv42s9oIloJ29GFCul71g9/mfMIFvbPiDFBsDPMipJedcTzJc=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB1372:EE_
x-ms-office365-filtering-correlation-id: 71622f64-c780-474f-cc9d-08dc9da27157
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 7N4a8d2ZZR+ibRxGY1hAe6ieqlVB/N8snOTfpvPXl5CU/bVJAQbSnILdqG2SmxKBfJ1tXqj7BIUpByRecxkbB9333mUSFPfNtOjHwBjAzn80UDdWCG+CnnmVsk+3lzlADAzPty3fGwmm8KJ2GmPYmtZIyXN8jSaa+SrOjAqXGzRwfyOg3kxwu2FIb18IcYfbp778RDlQIewIjh5yp+479d3pGPU94HIBCmKrL9mD+2geVvS0ASpifBkw1ZNvxPqr6YDPtQotes6N7xYCypSLuTxTIZVzqmcDLW73She7sw9WzQLcjIa5+yfv2K9TYptaB7rnpk30CPLArbzO3qIxnhWYN3P31tf4nNSUtcp33fxQT0HTbMSSdemxeVUMl83WDnUjFaBT5xFkwkpDHMQEnKkQ8Lb71fsG7OcbpNECIjkw7GwCBwSwmsS+odMWpX87PMRAVu0B9BLNXEp3HhanGLsW4kxwgTqZ/sra+5MqDalupCPCjdfawnoGx4XAMQnypB6zKy6mgsVJZIfeJb4Gs9vmEyfq4WO1WHEmTWvTP6iDVUEl4zGt+jcvGgTNb75/Nrmyd1RFxYoraUsy5SDrSQMs6wFu4S4iu2ktaxwlpBXT1riw6zdKnckXetjVKBFC4pEAlC56+vJl8wawhmuuEA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?unbaERjSnIjFaiIrp2IRwFBtV+jVaCXgdvE7uCEBU8Zj3vbDTtfNqniYHJkU?=
 =?us-ascii?Q?4cFyvkuHuFf76vJ+h6Wen4VWIS324lBImp1ZEqPpRtVKEY/YUU0H7DIwWkqV?=
 =?us-ascii?Q?U0hoJLbqEq4x2PiphjUuHw0iuTiWZh8vnSCsSA2P+wLvkYBxnQ1UWbnLSuap?=
 =?us-ascii?Q?lLqf2uesNrWaBXQJhSoyyPGUB+B2J0f3/PDyzK82U7lJe3JVHmFdktv3FL4j?=
 =?us-ascii?Q?wYedCMWSZ2nYVxjJIUwD71k+SfT6JvX0GMrSSXZMBD4JcrU3z+uYL2EVfIwP?=
 =?us-ascii?Q?YsN89+lYEhgxKCrQVHielhKR1Y9yNy56Mtg++72v65Yfy33gXGrXLMDv7JxC?=
 =?us-ascii?Q?w9F394YkkCtnz0WKbITkQzEz3AnSG8N9LxrmTelPWnwDZxhbcA+VvxEFRTfc?=
 =?us-ascii?Q?OR4Aw+OW3ssS0kWVxczmEhQaIpvFpiPPHP2MJz5oix9A4j1rHq+hiOxz7lUK?=
 =?us-ascii?Q?UyYtkX+Mid2a+NnnhJTmWVgTe/loXUKOO5+1mO0mJJGBjPu4XbiTGfHlBQJH?=
 =?us-ascii?Q?cQkij+T+rU5Qtn/xaLgrgx9b92pApapTr6LScqsixftzTq4Vspqj579zKGsM?=
 =?us-ascii?Q?VfTG0Zs1Iba+1QPBEHnhl8xloPjfLzmXyS64Be7A2UPyPEZG/zAIr6VxGvAY?=
 =?us-ascii?Q?9ku2J/w8f4zRxvEtpYX5ISEIBhGunNunm4UPqCzW8z04zi7PDRJYlsVyNKQO?=
 =?us-ascii?Q?Ae4BW6NUkvw24k6y5dgZxvn1/gcX9RS5VOz/MdxprfPOQUoIFGRtvQlNLQ16?=
 =?us-ascii?Q?fC7YkguPz6Bw8zMmwvkKZyDyUwS8a2nHazfar4DTacJj3B4c9V0ilPKYsHw0?=
 =?us-ascii?Q?CM6htOXEKQlPS1TTxVrEWMrojWHSMnh/a8ckAEezcgy6BU2iHl0wCkqOPTLw?=
 =?us-ascii?Q?7iVkWmzK9tO9Wklmh6uMFoym4EEluEzBxZgxUxd4StoE9JZp94E00IsPNdkj?=
 =?us-ascii?Q?tdYLeCoLRg5WyBLpC4VqOCbA2cC8DD53Fgaft6ugLiIN0KR6PP9HMlEN3JVr?=
 =?us-ascii?Q?GeKLV8LtDowJy4woCKxVJ4RNPRgXJFPCV/hh66h58SEeFASnxvLLUW7KGrmM?=
 =?us-ascii?Q?TNlgPyWiGiwUCYl7fCq1bwaHLVu1o20jCF0kaABaCNauMAIaD28KOoXGu9TW?=
 =?us-ascii?Q?Z6B2XyY7BTyJdQebZE6z79LFoni0S9/eJdeiQMwNdgXFbsuBM91BirMrG2FD?=
 =?us-ascii?Q?xG5z9NTSeuWaKjFxiQZ7DngfmV4BNjXqawpzQfzBBG0GEC6MIa8340ys0PZc?=
 =?us-ascii?Q?rambc4HyguSXyNr0wzV0JetlUUpBBUulEaM8y8DT7c8ATTpp1NKeW+eyRwcE?=
 =?us-ascii?Q?FKEMfXjWvxyns4tfNjF0Uyq8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D1E6FA22EA4A94190EA2BFB9BEB0E2B@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 71622f64-c780-474f-cc9d-08dc9da27157
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 10:00:19.1584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB1372

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

