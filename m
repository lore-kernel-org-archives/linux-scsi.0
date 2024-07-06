Received: from IND01-MAX-obe.outbound.protection.outlook.com (mail-maxind01olkn2060.outbound.protection.outlook.com [40.92.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC7B1804F;
	Sat,  6 Jul 2024 10:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.102.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720260269; cv=fail; b=r3J/+uoY87wh0iQPFlyCBuOV5euO+2BO5+dYBUHzOeq3Z2cTon8Iqc5df6wSzeYaThxGM2C/gcZgGbMPAls0OoSxUAdQhc63hP2CEK8ZLoA11hbOb+4I+OyGZ/IjSuHPh6b5NufdIj0ohQ9i6z3FppKzYEzmZxV+5c0d16+XBZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720260269; c=relaxed/simple;
	bh=PpOLJC8VSaXjwvdkmdxbtT4n4G6cWnRzEEm0z37smUI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gxbxa5cp8oGnms/hM4ts4exrnSrcA8ezaCLqVSTYXvj6IiCk9jZeNpLj8ExmWLI8x5zRObhW8pfk3MtecduKCI4v0T2imuhJ01ul9bAqPHbP4fFZZGn5aAp6gvm+wYph9KfoP6Vc1FDvQx5xTm6mU33no9P1fQFpbU1ZiIcp/+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com; spf=pass smtp.mailfrom=live.com; dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b=KebdEoiG; arc=fail smtp.client-ip=40.92.102.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=live.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=live.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=live.com header.i=@live.com header.b="KebdEoiG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJaevEIzfThGlCokaq1nNYO5mCQhy2EBK0atQy6FiL4ELQZUQZwi7PwKeeP2MtFZjiRR6IWGKYbLQ1255ToSeDogIlLDwRra2RqMy1STILJYI8IdGgpaNXBbsvAg8Do47J2TXc52ujTRUPZDz1BNurokSGOZRgz11Tf2tJ4OqYhb4S7ktpPHKeFkJNyAu8X0DmV1/viGEx90qNPRZfUi/ijlemz8AYHnXrgnStdVXANkiWJ+wS/2j6Hxn1Svdf/rG/RGk0bMEsLL3J34UHHLsf1bxM1Jke/3D/6A4Q6pSranPMXBaeElND/jtEg/+FEUKz6LAhyPswCLYsYQokhJrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpOLJC8VSaXjwvdkmdxbtT4n4G6cWnRzEEm0z37smUI=;
 b=YKX1pFgfIFgpSkwsWdH1RN7I19feibzZk1Ui4yN+dgB0SXuRtlGpwrWNRJwOCKtq75qS8MO8F5JkJSWsfGU3wR3VuozcOiAGlxTfA5MRzuhqxN8mOdO3+b4JYYNNAF08jYv57BQC9Ilus0C4I9OBB7aTGvbQ0fZrN05YVAj94inRWKRsJR80QStr4yNYdvtt5nk6gFmdWOcSK2WjyKo1VJS2PE8S8Ihx3bJhTolPXKgn/F0x3O4a+ZUwlFpCqd3qFY7KDiYeBoHqMpZym7nQZoBCz66/+19qycGOQzI1LW2hIPHN0cTFXYBt6CYUY244B5kzf0Nn2Y4STbPq6URIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpOLJC8VSaXjwvdkmdxbtT4n4G6cWnRzEEm0z37smUI=;
 b=KebdEoiGgVzNgG0dCG0lqfYjw9GBVc0tgbj5KN7JiFLWCoTVcsG0ANIb/JopJlVP+6DK8rMRsUIsfOkhQoP15qqAM4MXurP8sGjrXZwsMOfvzbTNcolWaosBMlbhIip+ZJo2LPhSo7ECkPEh4cqqph6ouOpaSyhduO7XhZkjVARuES99ZUsv3ETDnTYofOQgMbkHm1sdgIWsQWSJuT3h3XMZBD/B1m2tvkLSxzzORrxlo4/dfj0Hcu3Vz9RgOzJDOe7VRjIBgJc4Li4IiFF9ufPQaeG/O6Bq7pFKYgyMtIIRAE5L3l2f8F0dvivP7a0CnmJCQ7g1oMqUaP4bGKpzog==
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM (2603:1096:a01:b3::9) by
 PN0P287MB1781.INDP287.PROD.OUTLOOK.COM (2603:1096:c01:188::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.33; Sat, 6 Jul 2024 10:04:21 +0000
Received: from MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a]) by MA0P287MB0217.INDP287.PROD.OUTLOOK.COM
 ([fe80::98d2:3610:b33c:435a%4]) with mapi id 15.20.7741.031; Sat, 6 Jul 2024
 10:04:21 +0000
From: Aditya Garg <gargaditya08@live.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "oneukum@suse.com" <oneukum@suse.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Kerem Karabay <kekrby@gmail.com>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>
Subject: Re: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Topic: [PATCH] USB: core: add 'shutdown' callback to usb_driver
Thread-Index: AQHazs1tjVgoALhhKk+BKEcu0nmxn7HpWxaAgAAL54CAAAHQAIAAEUeA
Date: Sat, 6 Jul 2024 10:04:21 +0000
Message-ID: <D568E439-68FD-48FE-8F9A-076F7D33C9B8@live.com>
References: <7332D45F-9BD3-4D0E-A5AF-9845353415A9@live.com>
 <2024070649-nuzzle-movable-f383@gregkh>
 <C5231A8D-C529-4BAC-9E2D-32F00321A294@live.com>
 <2024070622-alarm-kissable-f446@gregkh>
In-Reply-To: <2024070622-alarm-kissable-f446@gregkh>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [JuuZVz9PzNXhuGKDqBKLv4cYVOXSyy4LLTJiojoQk9NsYSuiH47KKQjlOz04GAPC]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MA0P287MB0217:EE_|PN0P287MB1781:EE_
x-ms-office365-filtering-correlation-id: f26b63b6-066e-4f26-877c-08dc9da301d9
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|461199028|19110799003|1602099012|440099028|4302099013|3412199025|102099032;
x-microsoft-antispam-message-info:
 C9Zo1eZF8YAID+LJ+1OZBCYT2Xc0A5/3EvJcERMrlCnG8DUhId6KrOQFX+AXEuNIJhTTijHFTM8UYnqCMsEi8fV5HfhBUiQY6BetH8piouCyPxBDDlSCxkDM30phEA8dlpM97bfQtqbzsmWeH35G1ma5YkLp0quzBrvMRpTr3hFvCoKSU1z/wVSu8o8/9yq3BsOJalwvkTdb3XJiElqTjlqEm7ZFYF0HQQrSVt2uXaSbphGQ8c1heXkj2WYXGNq7BKMP3hSOty+Jlk8szIsSDugBM+pHUXBZ88U0JWHKIZwq0fHas8JsSA9jqwoG7BN+hcul3dhSGn4CCejh+Y80he3qog0UYPhDBWsY6LlSoZQTjUUc4CevljZ2oVnmWr7S6a85y5tpp83/7TUx93S2e6tgbmqEbctQcHTGWJ8z5MEWDRDzsJ4qllu423XW4SzlcYbHAV0rnURK8Q9xGn5DM8C5o72B3TORPA1Hw5fAI8bY+M3eMurz4WhvXyTgM/8Yno7XHAG30n+mGeqYAnMtCm295kQdGm7wt48V8TyOWjwZggNoVxcQ2f2wS5xuq9Rud2iVuHnOksxW0rMRhOGGGHiRQLsI0JMGWg5+Iu4E4Hrck85pYKg856gbkQKR9HGffsFy8k6KbSyKC/MFGJkkuXRgAw2ApZ+XTY5RfIBoWzH8AmX2CMrzZ5SE2xmSk0hwJmvTFef448kmczE0e3oqEQuqIs/Ic1nGdYFfZle510WpqUB0qLDeFclyZBuX+62L
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?3BtAKEKnLYTuUxOtzq1xBsHKMlUiDSQq3WtSOtrRf0hSoNEmsSOn8UsBGBYb?=
 =?us-ascii?Q?DKO+R0hBdVtVTkoSfK5S84fDB8krywEm71vdJVl5Vt3KD+G/YDxS2RxM3ggT?=
 =?us-ascii?Q?fGJ4MqAjxOLixGuu4dSjkFUiJnEoijNhi4ptYhSqlE1tw2sst4avNNSKmygO?=
 =?us-ascii?Q?NUF9VzUk0fdCHl7WM4rV4Rl7bTQng/AhCJzh1hWzVG1D0DdR4aTULNJ2WSM1?=
 =?us-ascii?Q?Qotx8yqBs2LsfAr1qWn1uizptASwQ+h80WBcATpp1BQElxR30+PBDTuB5iJT?=
 =?us-ascii?Q?MHlStS9XvXLPZh09UH3HRgRXAyfWI4ovDRVB5Mr2LR1EFHk1BrhvPb4THMQu?=
 =?us-ascii?Q?D08mW+NnD/0UkPvVILKrfnZUYMHK889WtGsyPN9EaT6GOicmQbwnjVvC2hQg?=
 =?us-ascii?Q?X8R+Gx9hDAp9DSEFhnvqBXsJkLHqGvdwJzCgCQ+aWgup+zkFk0ZB98bHUmS8?=
 =?us-ascii?Q?AsveAynJNzB251cHHdv4F/ooo/FVcgbaKACJ1NW3aZnD0jNnXn3xIf+pCDgq?=
 =?us-ascii?Q?38BEr8EdpZlcCbnTiQJyYihcxxtItEEj5TWpdKMPIdILzxXZUAlA9jdfuAN7?=
 =?us-ascii?Q?1py/707JwdCVghctXyzmeE8kOv3OdfNK/CtR1NJmVINaOc0UErpPhv5guja/?=
 =?us-ascii?Q?yxlZNycr1lhJZkbTAL7VvpV7TBaZZDJRT+6i86lQ0efyov760T9HOpdMV9o3?=
 =?us-ascii?Q?9z3PK841+bzI5vTIyQRM+GL8PyIU7WwdNTD5SbV3gDBXAuLvBPRV4JVSdEog?=
 =?us-ascii?Q?bvdaXHKkuV9L757PHK9AiWQGHguhgKAG7rkqkpUWNfkchanKWtdt9eVR32o+?=
 =?us-ascii?Q?Jgz1Faw2Se189+mKKaQJ8RjBz4cpnwg/7QHHiwymuwzO+N6apYDBn6989Agc?=
 =?us-ascii?Q?x4MdxATHQkzW30a6Vx4VMMFCodmfRN0zDaaUPHpKF/H2NroZ23hRz38K7Zds?=
 =?us-ascii?Q?1uRmcdXKl31ygLt0zRqDRq4uysPGYR0arsv3FfWhCmW06slW45r/gH0+RIVs?=
 =?us-ascii?Q?OH6C6GUoUMKB0OmoMz4eXwwHK00HuX/UmMWGk9Ghsw4BgRSSBIyVqrco02CR?=
 =?us-ascii?Q?prYouEOJk8lpBV6M9bdyNKbPanOU0v/V1osc6sAcqjjLfyIuF95Mmgt9XI6E?=
 =?us-ascii?Q?vz8QQ3e5viydJ01oR8ThoakXG9bmHunqjz1YK7BICSmnM8kJP6NI4hFCIfC4?=
 =?us-ascii?Q?ktsOCErNag7JYD1CrSp8wrBplgQAsOAItplU23x6tJHL+SrpQVxVjpKgL6HN?=
 =?us-ascii?Q?LlFcs8EkjfjXox3KcWvIRjE80xTlm5VGl9MUOkTBlQrH5XkdnoV4SZA+WWu2?=
 =?us-ascii?Q?uWxKKflKAp/aSx/34Fvme9Ax?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B127DEA5556EC94F91E7F6F7AC3C29C3@INDP287.PROD.OUTLOOK.COM>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f26b63b6-066e-4f26-877c-08dc9da301d9
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 10:04:21.5769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN0P287MB1781


> But as you say "also" that means you should split this up into at least
> 2 changes, right?

Sent a v2:

https://lore.kernel.org/all/A6C4519F-852E-4B5C-B791-7396B515B8A6@live.com/T=
/#t


