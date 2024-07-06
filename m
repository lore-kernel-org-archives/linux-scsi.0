Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2068.outbound.protection.outlook.com [40.92.103.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347E117FE;
	Sat,  6 Jul 2024 12:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.103.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720267344; cv=fail; b=gL+7/bKVq4I6l9gHw4jHRWHMHRcpgCXoOCVnAJa19QYdMlEesYzrtwo5emNm1EHsc+Zolw4XN3qGZhW7ueL0VwGRWpCV2JPO8IRJabuMhomL3UQL9pVbJhACRpgGc9rDNsm1fTxiRcYmHEAyoZA7gGlCihmo4X9PNiUyHV30gZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720267344; c=relaxed/simple;
	bh=LUmI/lUeaYdxCUBTRduJCuBkS4P2VeNIIkAJvDp8XZQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=KIvkf+Zi0zW5NaRUnl3cXUzXsXPz3ItORm268W6QBfNy3/4ZCRz2hx7ClJFi9wdqfErIjSCScozLEK7M6eiWrpjRqIOWw8srNMIkNQ3B84LteFQTJFcjtwIAi/ROAY3UqcBD3W2lDNZA8fmmimL5SdGVsxzuJLTnjqhYDnDq9d0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=s0qAMrna; arc=fail smtp.client-ip=40.92.103.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="s0qAMrna"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSFXt+4rdQ3T1Kb0DcwWCT4W0uIDzw/57fU1jyjH6fRgrJ1m2Xhrlo7mBaaPZfQ6X2bXsKDUujUi/7YF1BI7ca8CaIpiWp5zoe7LfQfxm57ccHJuiADIOYtzMfhCR2q3n/R0Hfh3jcG3n8qI32tyJcNDkh5AEEh606x6JxDVlr6+8whG/g9MfzzzgH+dvrhDIRha4yGrfudFx/KPPInIunNZpGRwEOOriMJ06x7o65qDKTNn5AtLhhVCsa/u0UvXVFZD373v73674YpVNdaFrKNrIBwqQEDGnitVnUN1SsL3s0Tn5bJhiO4qMeFjToeUOHGLyD6L91zmwzD30zxZyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcwmIy1s5mnYDNFLF9tRxVZvhoEVtUpktw/Z2IyHYAQ=;
 b=YXUTZgK/Hmb5g1cXF48M/ekn5ovxg7tt0SVYByf160XH1MPsYZmduJ4QsiYFnOsQk9FAj4O87KtxJAanlUG5y0k5bCkDXmFSyRByy57QGMpUT/+M9z79+RHbSkp9pb7Uw0861gVn9Ws7iT9Exm4jAGF99sjZ1XGbYNHaMwOiXo0yNBMAmHAu7klsujKCBbQsnEvm4kXkDePa0XL791HrsgsSZos4QbnWo/srD+Sq9lHmYBcxHUHVgYGbpju/mgeIQ9rCaeOE3NbY9r75pz7kXwYy2gJGeQYK0U90XgfGwI8FoJsCuYVdRkmmVhz/lnR9WXauJG33gX9NJHQBPUBrnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcwmIy1s5mnYDNFLF9tRxVZvhoEVtUpktw/Z2IyHYAQ=;
 b=s0qAMrnaQsNXSaE84VZgBje7xTfJuCsqi1ZzJNoHpL7IHyki5MDxyyC/IRRr2mKW0wq1Rt5pZmFU88l0Zek/R2rnrhSWodbMyhbOms6FVH4pAzknxBhmDv5n7h86kS2fJuAjeArGG8TctSZSOK1oEd13Dif273DAtvwYJqwBl1EKuPiZ74xQJVZNmqBf3ChQ0VQiBXLU8Qt8c+P26d7i9sEq4vdYUL5/YH5RL28ymxgotDExNEtPNzKuRNDEZdu0/836I5scGeFXNrIun4vK/xoN1zkla+gKruLPVwM2aTgJLSFJhDKcGB1M2P3IAxLEbrsPPuFBMITPTJ9ZCTo+Ug==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN0P287MB1624.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:17d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.29; Sat, 6 Jul 2024 12:02:16 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 12:02:16 +0000
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
Subject: [PATCH v3 0/2] USB: Simplify running code on shutdown for USB devices
Thread-Topic: [PATCH v3 0/2] USB: Simplify running code on shutdown for USB
 devices
Thread-Index: AQHaz5xYCaKh8rcOXUKkG07dHSx4qQ==
Date: Sat, 6 Jul 2024 12:02:16 +0000
Message-ID: <58227E2C-1886-40AD-8F80-7C618EF2D8F2@live.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:
 [TcHWjMJezbKZKDwbCgY+5DeVQ8kO61T2NfnLOrVRCbOytcA1ygWRnA/8eKG+6g5gtFpXFUaveqA=]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN0P287MB1624:EE_
x-ms-office365-filtering-correlation-id: ce6f175b-995a-4fe8-7e8f-08dc9db37a99
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|19110799003|461199028|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 DMT4EelO0gtBiwjZAi9exG9c7mJLKBKsTw2UMoVgC42kWfMPvcup40VoCM3mSdU2rW1jVVMrw2zVTWT5MrujeY/9rEbgJI5yKmdUzD8UPv/IROxLTpaoCWQSxUBk/WGPkfD15ZpRt/m5kfVZ68HpDDCLKNPbpMWDULC5W5BhQ+JrdmWMbQBRVDi9tH+QxPS8nFfYH1hP91bu/QFPdaG1eMD6KRxow20WtqhbJWa6osN7KzPUr8uHhtuNo53OF4aedPzPVpqsfRz68OOWf8qABCnOsWTBNB2DntZFjQDrT3TgzpBhuqFqT/A+hrCPJwUjMufLi4iG6yS1SGz6PG8mxLOOr3DgqRzGdKQfg3T0z8TiEm7dYkvxaWLXmE+wbwdkm52+G9L5rGcidiD5EN9/oHhhp28EpcI9edXVARz/OygceFeNvKkME7EjrP5vCnszdOpm6CiIOZGaQ5PLR7RB++e6xm0Tf2oXmO4bK8IU6/GnfY257Z+qk/yovu62XJFARXpaag1j8W50WrcjfWGyBGHXEVbBzrV3oeGjtDHnGIx7NGGJ5f2JktBsDWq9Vsof9bbdZpklZRxkcAq7+afj+//N5IxdP2Mxo65RZDQ98J1kdxJ5paw4WXIb5Db+UvEAEPT+aQO+rCCrQSMY9B3KCg==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0PkQ2Y3n3JT38OPXO+05XEU+URXWb2N8owHJ3Tbna5plWH8i1foqHSFtX445?=
 =?us-ascii?Q?X3+LFST3cz7gVAMgYPkgMjAgP/gLeLAFOyHHA/y/y7MnE6Di2tfwDQAxEg9l?=
 =?us-ascii?Q?F6am6Jr/nspzJj0I7isrEW0/TEPRvis/zw85G6Ez6i37h5Jb8Ci+Xe5iwVlm?=
 =?us-ascii?Q?VlkB/e/WdpHu/xukV5m9eQd3TMEhW6znf4bB3o9tRIC3i7TX93KjOAMrPJLu?=
 =?us-ascii?Q?jWyC/pIvXaMjd65oFohRBzOGOAPzYhEkRqGeZyVgCVhi5NOWQKecUJIoqi/e?=
 =?us-ascii?Q?i3nje9XapPDPbzhvhWYLGu7P18tP5DNtYj8o1ik9WLkxJ2u0sE1gzYXOmVIL?=
 =?us-ascii?Q?FVQ4kQOroMU7XKAzZbXY+kCFpVbRSROrS5Ka1cFjzzSbLfxStrzjuju5Ukld?=
 =?us-ascii?Q?iOKD6MnOfsqXdOdADnwEq/JX+H4CK5gSw2FUYZSIWWCajShBsTm7Hcnswfsg?=
 =?us-ascii?Q?tlUEFk8rQ4qJd28pisHvUiIuOdhVhh/30hkW/Jov+tyiYGmhvnlAlO+Mo8YV?=
 =?us-ascii?Q?uo8zTfoeSxu5JbbbOXZTLrPjgYmy3HLcdNXAstufrOdco2joW1dkziVTwcYZ?=
 =?us-ascii?Q?tN5Z6gaaSbgfukS7W/EKn0wFthoRjtv76fdTISzEhEM6oXdnt8L3AmT0TMtU?=
 =?us-ascii?Q?60nz8okhxAldQ6vJT8yrQk53jLcGL66pyQntAhk9QYAqATGHpvt+Me5tR78G?=
 =?us-ascii?Q?yqs7Gy8dokE1dgo97OzPsso3DzBiAn8K0cO3xEBEFTjjmxERBbI5zjr/DT0o?=
 =?us-ascii?Q?PXh+bCFSgYiPgRvO3FFm7fjMFUhO58BeC/ZkxhsEx3lipHa4nP6AcEhiZglD?=
 =?us-ascii?Q?LL0Cj0SOdwPv9epR6gpWXnGctrJBxHfO4Pnja9OWzRUPoWvDACGNA43iEyr+?=
 =?us-ascii?Q?BaeArJSgg6n5+Te4FSOgpjzkKsDhCaoPvIXs3h4qtsfiIbooJsHPHiz3h30b?=
 =?us-ascii?Q?FvQBANcpGtngeFvkTssYvq6M9Awd5k0EGHe5cr3hnkKuji+AP6LU4434iCKL?=
 =?us-ascii?Q?BTrtDOVe5pfubm4KrSJaVEplvos+L7g03IbJ8NUEYVX0+f5UgqZD/xlAt5v5?=
 =?us-ascii?Q?ltZhSR8XlVzw49FB9SrWVIGJWT4wAK6zoxRTQ6dCwCHf+a6F/HkdpkQ4zNhy?=
 =?us-ascii?Q?PxtzFxuL4B8cVj8EI0JB/iSulm0lePYVadziKkspaNm879Ev7/UBSLBuFfsu?=
 =?us-ascii?Q?NoYgq37S83ft/PDivAaXqckFt2XXAGlS41M/6ePtQDf3nOVhqLg+914rCGrz?=
 =?us-ascii?Q?Td6k3/XFrOQXYs+7R/WAZa2dydgHSEKoYk16RkxfNBHKHX1iikuT56ce2i0a?=
 =?us-ascii?Q?bTi0EfVFN01bun1C4uFH+Xcj?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <60EDA1922212EC489F2A9E1C01DAFF83@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6f175b-995a-4fe8-7e8f-08dc9db37a99
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 12:02:16.1331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0P287MB1624

Currently there is no standardized method for USB drivers to handle
shutdown events.

The first patch in this series fixes this by simplifying running code
on shutdown for USB devices by adding a shutdown callback to usb_driver.

The second patch implements this new callback to the UAS driver

Kerem Karabay (2):
  USB: core: add 'shutdown' callback to usb_driver
  USB: uas: Implement the new shutdown callback

 drivers/usb/core/driver.c | 14 ++++++++++++++
 drivers/usb/storage/uas.c |  5 ++---
 include/linux/usb.h       |  3 +++
 3 files changed, 19 insertions(+), 3 deletions(-)

--=20
2.43.0

