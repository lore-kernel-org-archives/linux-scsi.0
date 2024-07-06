Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2022.outbound.protection.outlook.com [40.92.102.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5F442A85;
	Sat,  6 Jul 2024 09:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720259944; cv=fail; b=d/Ws7IniTppI5/E/yT4oOme4qc6NQtJohKRGtFEhs80WHYIH1QMihMOrK82/8nai7xyS7jsM+t0oz2GA2Z4K29g3jUcV8zMema0O50HfRfIGhOgd0usg7xJLNxqLnY1LjU4qA9yv/lr14wEACK9EbqWIsMgRXY0sfKNgsLtGKBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720259944; c=relaxed/simple;
	bh=YZwR/859sw+WXkTr18l8gD69JdcuIbDYYsThtlzS/xs=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Q/Nu/0XEVNU+QAPr0UJMYZyTn3bWjxW5oHOTsOCUliQjG1Os2XwlKbf+7BTEWbr6bra/CTYdwiIXs6DdOV0HNuYTL56iDIOVuIInW4YRaNyn0w9T/WTavVP/aQ8L5TEBmwl4pZqiClhxCqSQDCnPlRfTSkZcNgQDhPiCyO4srak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=m6UvwPZC; arc=fail smtp.client-ip=40.92.102.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="m6UvwPZC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmQJP6fZZrH4zRGhToEDSvTIuc0T//O4LN4RZrZFqEEktGjATwyumCW79qbSw9vhs/8B2g65/kxvKIXL6ZqWg8DUDuUsZ6I/JyTp/vxn638V0m0LzZWPKLwIy6f3cWtLcQ2Eel1BBVDBwY4GCo44QqobOgR3k4I7Vk5ezbPs+e3YyYp/qgw1BroWHH5CZ9fLJlAzEe2Y+CK7MN0couAEcUqneAY2SjCIk1YKQslbpNuFDNX0GBWZ4Y5J9djFtZ+xwrG2s7d9TVCetQUerKSdWbSuCqI7IJMs5bASNMqCt2Eu15Jscu52Hr3rpTBtmmdWGUUN760M/wTxr9VhBraYlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wh2zNs3cKcVyJAC/F4M1zOnme3wwGIfjwwpyRNRM2d4=;
 b=R6h2Esoh0BhbSpCDgWsTZhFqCFD/pepNtnelc3NhWNkngaeSHayOgs2nfU3w9IleeAsRLCRU77JpXx9GMsozcw6WLqXJxJC+wLlB0teMNbstuuV24F0RYe4knv2CPFrh/dMRQS/BcYGseTAXt2Gbms7evc5bfJlv5t+LujqY9lPB+IDkahmp+CFzxHCZGB1abfqBiPcABqWIH9hIjEl3bfkuwDG0JZZ28rZBaqjLsGEgyi67gT+mGlG/OvZ9R9+6KWntdp07juteAhfHrV7K0hbXFikeV58Gx/ocZFY8LFa5RFeFPus5SP+atNcuH/lLySwex1Wus8PgHwJFJ3kdGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh2zNs3cKcVyJAC/F4M1zOnme3wwGIfjwwpyRNRM2d4=;
 b=m6UvwPZCqSilU90kAL+4HrA7avxfqtGfoxG+RZEtsamaTjL6EycZ2jL0j+074Fw3HDgYXVgTEFTfX3OIK1feLbXb+93n0twDkoALPw2FaKAWNqJHdomz2rJWX2aVj2CcIynzZm8IiHT4DM48tU4VSjguyWETs/EDZnCN3fDgUdZ3LUZq0b80DdBOih2YcS5r+z5sksPMjUT0B3JdN87F8doZIn0VDqNhBua5g+uciuVXBDYPAg7AUU83w8MeQv6HO4anZx6A6IwLI448K8AK2SQ5xi81dfQmSywMac2X3pFTOQJiH/NAf7niAyvhuuLaBOcHfXCrkPqbN4EdSGDP1A==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN2P287MB1372.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:1a5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 09:58:56 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 09:58:56 +0000
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
Subject: [PATCH v2 0/2] USB: Simplify running code on shutdown for USB devices
Thread-Topic: [PATCH v2 0/2] USB: Simplify running code on shutdown for USB
 devices
Thread-Index: AQHaz4sdXbd38Jb4D02b+7GJAoiXFg==
Date: Sat, 6 Jul 2024 09:58:56 +0000
Message-ID: <A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [k2F9qNdhN5r8SyyZCaaH90iIm4EJerhg6WV0wmQ4c+KlzuS2156GVHvEKpBI0uhT/8IeXutWSwQ=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN2P287MB1372:EE_
x-ms-office365-filtering-correlation-id: a77fdb62-ab88-4c4f-56f7-08dc9da23ffb
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199028|8060799006|19110799003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 94XNpBLdmbUU0pXUhN50qLnOGYHPm6m/HF3VjOndUbOrcKUZ1QtDVINVcA7UAK0ERRXPsipjU4QKu0wXsLCwuJX9ZFJah9Kg4oNksTrze0GmasgkS/uu/xIU2V/RsXCpIP4rcyjEA75BHgX4bjKwq42Bn1h+0O32VAWyPXOnqB4RlC4ZzI6C1o+/nHGKyMWfp9ErnQQjaqUt9Cz021dvsIjAU7WD/DYpu8Zkz0j0nGImwkre7NOB61kbxwEVHLJNf6aiqgXvkByDx6Y8ipSUbI2dqZv0rEsJ4gHq3A1ob51xaCKa86wz8Umg60plVWP178+wpQCxHa2ydOE38VOATGeNC0d+wpVDDyS3sK0Nz/1sRRo2p4rM20J4UP4zXC/7zWNWyqYd81s5dsRzuCR4HU5DHr06cxMnYfmQ2iDJ9iuweDDu4ABAAhg8UlGPVFrwgIcr+FoV0H82Mo6AsM8MH7R35+Ohqrmdi74xZRDkmG0o/P8PIt9tjDpTQhE0M1bFqxwT4R6P2COVBAjWnDm/UpESM+7NLYWY88qGKFLO0Qs+yObRmhAiucDbGkCTOiRjvxdJpEByjo2+YW3oKiNOeHu9v7qW2hrY3viU48N9Ngn1YF/JPHBoOrSlmjVcKYhv/5fjoJjYDqsUmo2fkB0AAA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cMOEM2nOnJPgamS4Y71u81IwwSrPRFumML2kJYsAjB7HkxFIIotttVAzw8G6?=
 =?us-ascii?Q?qC0TXlu/ts+QwVtDsjIK27KUE3QLMDneDMmBmSSO05E5ggE4qXl9ZXObSnU3?=
 =?us-ascii?Q?wn++pGwn/IOpsZQLfwBrV+XV51OSj+9DXCEfwGlXlnPHrCR8hnWLmmt4udMm?=
 =?us-ascii?Q?ye956U1dpulPzIhXkc9R4bpL/MEmwuHj8Z/hh2RzFiSS2Pyka/gxiwUBNScm?=
 =?us-ascii?Q?4D0gXcKxvZzigzPg/fZCHnA7Pwf6hRItxfjMrmtKAeYOU9qmVp8e23LpHEaW?=
 =?us-ascii?Q?ooVGzEjJF4+6RgubYr/XabH4NKmLbme+y+HoD6rMr9yQyVBIMOCE1B/Wt2ix?=
 =?us-ascii?Q?XQOzo7xVgZbJXnjoSSDkpr0K37ZB1BWINIHPc1UnVLAj5RY6VaSkvKaWXQNC?=
 =?us-ascii?Q?WpQRAJpBnAOL54e3j+CVyfPxkBa/Jv6wdacQX5WRooXee2O0lt4HCov1fD/9?=
 =?us-ascii?Q?YKBbxdArhcbwPOwIUUZ3daEOP8Df8bJnS5MM8MoIJy5HlR3gWH4KxpfKw9FD?=
 =?us-ascii?Q?0qKhkEZzib+gImS9JroOYxAtTxvylEK/Fc1moCAlLItOUfPh1wQfoISsOkT7?=
 =?us-ascii?Q?3KvWWwjlTE0lSz/BWWGAnpmvEt5+1gARmEM2l4d4ju0aO0iRDzmxdGI3JPMW?=
 =?us-ascii?Q?Un9/51/IgZq9sbDKl8mo9wC/+Aied1A2sdnnPa/gEjgH/v1pA9vZxKzJhMPI?=
 =?us-ascii?Q?VmGkQBsxbQRabp602UzItyiu7ZHNSDk3d04XhVPg8rl5geTx/xxQHwyPOERC?=
 =?us-ascii?Q?DF4C9xa74E2BpXjXZYccmy2jJIaJioVfvGWNgiJ+4D0CEb7iheguwnCfX+ml?=
 =?us-ascii?Q?LJPGP64rcMvgIqwo0IgMukCF/8+YNNibEMG6uL1GfBC2OJfEjuQSTU4q28Yi?=
 =?us-ascii?Q?RIC1LNZ5TUc7kpw6ij1SeL+/eZPSHQZQwu6xpkxzVO3DFGoqjgkGtS9VVdS4?=
 =?us-ascii?Q?dlZetyAwX7dJ/mm0JVQ1bLxEy81yvT0PdijTG6rFS9keZXZFfwDkmckZNfC2?=
 =?us-ascii?Q?/f9+Q9pGn8szmJCC8GhxWKfafc4H/G/0Q/Jf3XSyeq7fSk/XstQR0fW2eiHh?=
 =?us-ascii?Q?215QiFf28Wt/RAe50M5OLZuidkVqN0w758aJT51yrgtovRM+ZG/WVweRl/El?=
 =?us-ascii?Q?3fHdcswDmGGNs2z7tlxfOPsOVKq3j+iAKCFSCVR0cWzSgglKrNuT9S5++RMA?=
 =?us-ascii?Q?456BldywGBpmP7hDZBJK2Jzf1gTc1iwAjsxFFs6YVdvDAUmIKncCXhFaw0X0?=
 =?us-ascii?Q?FbSUAsrWjNDnu57697xOBE58c80sJ9l9IwTVBuusb83J2xn9xt1AI6rqWDr8?=
 =?us-ascii?Q?X0XrOVW8F6vvN+v0Iw+YQYBY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4CFE333EEA19A4C873E79AF9E7AB990@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a77fdb62-ab88-4c4f-56f7-08dc9da23ffb
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 09:58:56.3281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2P287MB1372

Currently there is no standardized method for USB drivers to handle
shutdown events.

The first patch in this series fixes this by simplifying running code
on shutdown for USB devices by adding a shutdown callback to usb_driver.

The second patch implements this new callback to the UAS driver.

Kerem Karabay (2):
  USB: core: add 'shutdown' callback to usb_driver
  scsi: usb: uas: Implement the new shutdown callback

 drivers/usb/core/driver.c | 14 ++++++++++++++
 drivers/usb/storage/uas.c |  5 ++---
 include/linux/usb.h       |  3 +++
 3 files changed, 19 insertions(+), 3 deletions(-)

--=20
2.43.0

