Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2106.outbound.protection.outlook.com [40.92.103.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20003399F;
	Sat,  6 Jul 2024 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720260105; cv=fail; b=Ps2ZSn5HmREkwZYmZ1FTguqmx92XxGqZWmfGSkNp35XkJB8JSH8pxEercVQ7pr7SHzk8Dq7BQem60dJYhL9WNBcH3VGs5QLBEMZP+9ixFOdCMxHFQ/KO/We5w3pojB10nnNeOBhq7l1IklXSxeq2WgpcDgmQJwmmrMD8WufXsZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720260105; c=relaxed/simple;
	bh=YvUlN4v6Eo3B57Jw2+X0blCq2Htl1h7zf2cnPyOviC4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OcjOuV3XHmWHrLYg0nivbbpIH8CHvok8GCSey1CRCt0ccPC4akdU39RpgS27sBmrHdnoCvY0NQDBi3D2YUT4RmJVVHDJDAKEotf5AfoYtp3hPm9wlJpH3mZYKOTQhlYTYw+NlvyjS3E/xTpZm2RoDnE6S5pF/LLZpPp4bBJ2zg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=loX+f5yM; arc=fail smtp.client-ip=40.92.103.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="loX+f5yM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEhBBVq64vN+AYHzuGDwASBLA8ywxRLRb27FrywRUBW7+IDflwulfV2Rdl8lj2xJJEYEV9Hs5MTqBvDObq6kV/3z1VTSMXFJl0vX30gMDj5h+MhObGEpAYwdiy4EAGJisuigs0piKUkk+hkT+eCZhVHbHBDZ1nDYrVv044FFHwxosyuKjH27w/BE3tQNVqHDtzPdeURVcktFF3b/iA5YjuQiaYbZevsM2J8KcNP+qNxPoP1VGcz3rOditurcxl7dTnUFuLaV9umWSaHl4aOFWcZa1udMe8Yzvbux3hNRSDQsAH5VhjW2HSA3Jg7k7lS21HnIxqsYCKx6L3jKoGD4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFjMji8+ZX2RUdQlqvZpqojMNot+BRk3/n7pqXudwuE=;
 b=QzVYe9WANFrA39g6W9s3BThmVT5RP3/sQ5+teWpG72ZII7cmTtJmJ21RfwOx8BXNZEReHWRVe1sBHsetbNlmjT29SqEMm0ZN6N5IeFE3cIwYv5kMkJIv/B1XPPUr0egPKTx8D1XhW5DapnsN+gcB3hRBxuzQc49qK83cxGQJ9e1+gOKGS4OK8PZDccL1FLuAzplpnwn0QbSMruaL0Is5ezSW/Ima8TWRuBeuizDObQX8+cPBwqLwJ1xyOKcGWEe0qYR7NJoykV4iFM6e2mmvKxYg9KhYl71NgPOw6zGpcqf8aiWNPeIRAH3IoRaclboQJjjhYgnLhAaI2NTGr2EY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFjMji8+ZX2RUdQlqvZpqojMNot+BRk3/n7pqXudwuE=;
 b=loX+f5yM7hkpoLU3cBU/qvXEcx14f3vocOkj0MmETqgjxD/msX0QaI2QrVVTaJP6mwQIwjP+klVzy+FOPjJDL8pXyCWTlEJdG0E+rLFkrRQV9khAOyZrM/TjJWUNonGlVTjbuVWXk0Ns023vh2zCqFvxdVGdXLMuRcVtPLSk/JxTn2vvSmt8n7elv0SKay5aYePgpSRw5UPVTnUt3jCsMJkbBUf47yWTZrSyeiVJvS/MWeYBAqgeKLRmqAv3BumCBwGvo3ZXTEGr5w8XISp4PDp5cGK4wSZKj4GVV8UaWolKDT25i8tTIYAuhvIlCdCsdYOkgHdodmD7eaBicylK1w==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB1372.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:1a5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 10:01:38 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 10:01:38 +0000
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
Subject: [PATCH v2 2/2] scsi: usb: uas: Implement the new shutdown callback
Thread-Topic: [PATCH v2 2/2] scsi: usb: uas: Implement the new shutdown
 callback
Thread-Index: AQHaz4t+VjkiMxF+7kWm0GtAei2JZA==
Date: Sat, 6 Jul 2024 10:01:38 +0000
Message-ID: <BAC247FF-CDA3-4C34-A9CC-A429E3AD13C3@live.com>
References: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
 <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
In-Reply-To: <A53C580E-C0CC-42AA-B50B-F1B8A5756C9F@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [pwObd6efDSo5L+n51THClYj64pmXlzlR4hhgqZrXw9FvJqeYQkeQmecd4ZtaVn/g6yWNUeLNXQI=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB1372:EE_
x-ms-office365-filtering-correlation-id: c2ed1494-49b5-4d21-63a1-08dc9da2a099
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 Vgz5ZHmBuaGT7XnpoXYNu/xYfoh9fg/Lyro8G7QCKkEuXOErwxgDVF8yVXL+R/rHiBAD7iATI1TRDIjgLc2fcj3cWFFwLSLIgQtBYAxWkH+YNvNIWy+R4qsBV/LShVAIonrePMBoRCQGd1PPFtJwcdUyMFiSiaXX8faDrN1xLnd5AWB5Ae7DJuavqjQAL0KKmitQy4ESF2B9y/Bem8BReFcA0gFOvJmjW6Se2fTpwse4mcIz0qMVSU8OmEyRAH/wPNuMWDH+mRUJ+X3bwqkwmdhs7AmkAlE0yA58mFUXAUoSc7yXKzx5ER0x8BUdEKrwtaRBlrNTppk98WKiDjOAW3Pn31c65tPk/rtQQe9JO0HjAWoJM+Okyg2S+EbSUKhgAZqiUNf03+6y4uggZkcx04Gzh3b9Twgpb9MtW/A/Qf63eh67gMKSSSJwg8eF84C/YUrPy0zqLcnxwkzh4vfb9rF+jRhyepPb0hXfSJdMPaSFrUnB1jxbADNCyC0++Z7tc5/F5kAJwepdUlMV0Y0PY56jo1oetZkqC8U9zu7cxmXmsQMC3hxrEqSds6L3K5wKPrjMsJ7pRL8HNK8topy3VKPVKyikEQEEcrDfUACKnEyWlMs8e9sM86JBTJCB4wNCxPfaHVAoKGrVqPcb6o+O+w==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?9xfhOKjb54NR8NyRSbY6j4lohbxwPEe6e4l2Se+gtfbvgZ5Da1gzrTOGsE0i?=
 =?us-ascii?Q?JO2hIBWPfAq/e3kRoJ0myEkI+MiIyFxWYRl+Ino15qME50QKvT3zWP7zFFor?=
 =?us-ascii?Q?w9AbUhE5OHp5odj2kk+80yqJ9ogloc41OtaR3oIg+39rDZ2hlO+Bw5PWCFf6?=
 =?us-ascii?Q?sAzG3DGKDwFp+dlH3n+PM0DuQ8KSRxtmmlrpuDnvyrvPSGwIeaVOAcTnmJyo?=
 =?us-ascii?Q?xQNWIA8kdDDA9oTSvM780uBDD8VBzI4ICmkVoBHXmbH4fIldxuELnc07x/Ho?=
 =?us-ascii?Q?Tq3cRlF1H0GKOA3988u/QcxDn9tby4r9d8E/4asG6XzrsXGPYPyrkQ1Ovxez?=
 =?us-ascii?Q?nVaATszjBRxFaabu6vzWJRkIZKZEGGtGsPPVBXF8FZ992zJP9XsFq8VJ8/rY?=
 =?us-ascii?Q?49uquxV5S8vWHzO7w7aXjQl0JhN5Upa0vHmkVXIfbS90l6NQ5lEUJ3O/+2M1?=
 =?us-ascii?Q?Cb8R6Yni/IoxuTIKHGOQHiynuxjc1zRdyEstl2BsDnv1PYEvbSNRwj4Pgqx1?=
 =?us-ascii?Q?+8skArnsOwotfxfMYf3C/L7cSRPJCkpK7R6LkwzqAt5Efi7amL9FFGjiPWZw?=
 =?us-ascii?Q?MXRdO1xMjQYE+obpy/jpqYMRvYhXWQ5vZwScKMO5rVlt/YCIYarIq2xi0AUf?=
 =?us-ascii?Q?QSAHhDJtlftoPG6o1GjtAHstaXrUfSUZWZJy+dRAvTG956LnU42AxyR01K+R?=
 =?us-ascii?Q?Mk/2qUR+SQ9l07c8dws4QCb2fr/WmngXZfqHT4h1WjpbjLi4lOHVYZAOdU1/?=
 =?us-ascii?Q?H5b+37q0aShxPky7ZG/r1LUFvFEaZmOuTZr/6U9hSFL5q/Yc0OBDMmp2UtB1?=
 =?us-ascii?Q?svl5bOLQk47+c8xs4kn+CvkhMSJnpXRMF5WE5EMi53faUwVEu4dt1iQiT00D?=
 =?us-ascii?Q?SWKk1FRqxtTGZulSsBZaj/JryleeFBlXoUiTPq4XwHs1jynht68W5qtS2qDK?=
 =?us-ascii?Q?rhGfK2QXtEDbhqZCl2XtE3eibgN8DWKgDxYzRZIRVQWDLDZv7mYOv4EocHR5?=
 =?us-ascii?Q?/rlNANB29xSjdIJmuawiohoJnMoHlMu+6o3/z+9WD3CYVEvfL/SgAFr8xllZ?=
 =?us-ascii?Q?37WrZxh20zGhC9rQ2zEKyvjq/6tuNU7Q/UzZ7eR5nNBFGTcSRHgYi6bEMEqf?=
 =?us-ascii?Q?lbnnYLbGRb1YqboE3CUrKPM92+lSDP0Hs3g/uqDV59gjon4Ac2HmD9yAcc88?=
 =?us-ascii?Q?QBdeoVb0oG6d9+M+qhqNTu0gBsnauBHK/J7FOlYHD8VbMTP09tjisBazQyMc?=
 =?us-ascii?Q?mkJJskNj6JNKQNH/U69aZNIdO5SuYWxm9qJMwsY5l6XbpJ7vl71Rtsbe1hlP?=
 =?us-ascii?Q?WZj9y+hEXLDLrOg2QBejmn3E?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19EB418F74654444830B8815E68C0254@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ed1494-49b5-4d21-63a1-08dc9da2a099
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 10:01:38.4084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB1372

From: Kerem Karabay <kekrby@gmail.com>

This patch implements the new shutdown callback method added to
usb_driver on the UAS driver.

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

