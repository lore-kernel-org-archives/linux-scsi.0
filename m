Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7483D333B;
	Mon, 20 Jul 2026 09:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538959; cv=fail; b=m70D93bVsMJ+hdh6xV9fPL0cV2948plQoNcrRXgRh+lEq+YLbTB5cfSyxnsHV3Jrt8k9tzRIF4F/PzIUHlv4lYf1P7JZ8JxBEwh6RezZYrO7ct3xQCZBMcUYOdXCkfBOkIkFcYYyqeNseGD4y9waiz3kPN2wwa2555vjzvIXwhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538959; c=relaxed/simple;
	bh=xx9k+5EzMuokzIvG8qyjnIggNjzz6dtTPy1NuVNzKus=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JavJ6GVC0iva17Gdvma9iqIQKVGYUwMp/qCZbi+Bm1vCkCmZeklP0Oa35cXAPgh48Duup81/A5ZdGvlL54d1YNCms7DBPRUz+RupFR22dnyV2H6c9jics8BNXOscvGAkIYKvmAZOXan+O4WPgTd+8XZCZNLYG1VKM+o73e4Tpuw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QRFkNP1t; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=uJt5iQBR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QRFkNP1t";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="uJt5iQBR"
X-UUID: 992093b6841b11f18dc8c9802ae25ab1-20260720
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xx9k+5EzMuokzIvG8qyjnIggNjzz6dtTPy1NuVNzKus=;
	b=QRFkNP1tpg4mGIRYFz3IQ3KSGHcXYChicf+gcUg0pFDhLIBFzBnPp9MnOuJab9zQyxJSUUb2SZyTAC5Jwwrd06X4EgMJ0HlxxBleMhR42gMoDyPfR72c/CdbBjXxUtnbleRJaaCEkCwDnBDUqkpukJCOpt2hAntIHD7a8XkymEM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:62b78180-4ebd-47a1-9172-45edef18a155,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:cc15d113-9783-4648-a7c6-8d1b40365792,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 992093b6841b11f18dc8c9802ae25ab1-20260720
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 158869522; Mon, 20 Jul 2026 17:15:49 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Jul 2026 17:15:48 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Jul 2026 17:15:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNqFlaiX44dUs60hfbRcIN73hmcNKGye42ycVncZbvwIRAzz9cDhr2aul5FIBNx7BI9Yi/A3nYachjM2DoBv27kZ7rUuFwW+KsluJp5nClvsfv3fl1c7yP2cM8PlljqBrt0p9umk/fEbbNfcXCKqbXvGUFzvUrEC6w2IUduvouYmOPZzSYu3fHzLvW4wYL71n73GNo8OsIH5bOjtieTpOe7sAwahmgRSOUChRVzbIfVfQOITSXGzYIM3vQdcJrFPeQL0yXTFSu2ukhQ7cGNQcO+rEs5uJ5DhztBLp2LXFmX4xojKOEEuXO4Y6FLxwbUeI/NA+EZ1NSFPaYTP2A+6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xx9k+5EzMuokzIvG8qyjnIggNjzz6dtTPy1NuVNzKus=;
 b=dB1k6qvwm0gGtKVXTdZpsdhaJuxAVZm9C4z0exExvRejokuh1nSDaoSLjWtUcMRIb+IBTNHKMMojbIICe8PZdrXFwp0MQGit+fmRdb1JkD07lrsjE9cCJ7QfLscuj1AjXHwLFtntJkPWeaMV+tJ22DytH+j1SrvW+RqJwRehHdVu3UPkYxLgerwHNjNGyJbosQgS5+5hTcXrNnbRCbNBZ1HT6QYd1gg6MzRDkxEZEU/99PeJ+1jQOihvBCLt0LZ6qiqDAU4YxdRmN4k4gOhBrSxn9St7S41Ds3CtTOA1q5MRm4AByJuFrH5lwqlfYgdEXB3+7AotzD8J8xrlX6AaWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx9k+5EzMuokzIvG8qyjnIggNjzz6dtTPy1NuVNzKus=;
 b=uJt5iQBRJLrnNJ1vZJ8JWQdNXAB3uRBWKZaaQcc+3Zb4nqXj/ArY/ieyIieJ6A8V6wDCoF/N7zmTMbXzpeS/0oTGMoAZ1RZsO12ocLCvozCrrdTJoX8xYYRv5CJHIjv9A7g3MpjIiZ+WU6asDOmurv3gUKTEwEFoArD+5GTHWTw=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SE3PR03MB10511.apcprd03.prod.outlook.com (2603:1096:101:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Mon, 20 Jul
 2026 09:15:44 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%6]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:15:44 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"liqiang01@kylinos.cn" <liqiang01@kylinos.cn>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for RPMB
 frames
Thread-Topic: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for RPMB
 frames
Thread-Index: AQHdFgKrvbns8myTi0W6aEEAYqaRubZ2JKoA
Date: Mon, 20 Jul 2026 09:15:44 +0000
Message-ID: <eb621daa1a6017c209e18c1f1a52b2beaa0ba7b8.camel@mediatek.com>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-6-liqiang01@kylinos.cn>
In-Reply-To: <20260717153914.26321-6-liqiang01@kylinos.cn>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SE3PR03MB10511:EE_
x-ms-office365-filtering-correlation-id: 87c5ee74-411e-4154-f101-08dee63f7aa1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: kSqNrb/63QehrS7GpmYb+C7RYb7ce/J3VGdUhS8f1rhtyqwqdrJSJBFZzsqGVC/nM4fdpzuhOY4jJC2KKw6L05rxhrTS2hsPjmB8LXUiraj7jQA+9K6z1gi1xaYLupO8b0oveNBRNeaAHgCvXSwmgT6COIrVxBUQdP8PryEO0FPsEpjSas62DqZ+/pw8IfXp+ulz3Foj9pxpMleI1IW802ERMpS4XnR8H3uKqe8UhHOULXvvP6fh72IzcCrMI8ZxqzxdKoBYBrmtYhFt9Wo7HIvZdacVAM8ASgf9e/FNAU+gMViPlZssucQ+pucKsFqWgIvvgxmM58hvaa789C7ojcZUbQDE7BTj12M0OWq6dyScPoaQsI5H1TX4ZFtb3wIFzGobDPQa4g/r66kKVzvkS8SJNOx2HntgJJzTgdNlOK0VEO2pmnbfBNhuCc8KmV5MJJiIYHWt/Su+/pvxwgc3heg3a84OybEMTuxCuWaMSsXY04zWMAgOABA3W9+2QEcMIa26rqHTYU9xpHqX/c0fepOhiBzb0aTtaXft7nPiM5AYyebiiVx7o14YzQXWSeRVft/XlRuK/MoEq9cYzqnsHcP/RV5ip5pEy83dqsefzymTQ6I7AO7MtNLqt7Zv5jgChVB9kP8mYTPnZ2jy3XlUvsLvhdOeKg2mIDCyelX5O3+LrJXLZqWTnAVw0dz/HRGogiupCAz/5tjp5gM4R5LOEn/3dNQABO2R8x7ia8p05dw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDVlZXpDUnVsWnN5UDFaUUpubWRnVkZkTDcyVTJyWnlSSWtMUDlTeW1ocDdR?=
 =?utf-8?B?bnh1SXpBL1k4VVJXNUhvN2RKWnh2VUYxWlpOL0xlaEQ5OGU3SzRhb1V3RUtu?=
 =?utf-8?B?V1ZUV2tKYkRaYnphVXlHWEUreVdaaVU1MXhHMW5sQkxaTmN2VUpDRGZJc21V?=
 =?utf-8?B?TERJVHU3TlBFUGhtL255SmtIZFlOdHdXMzZKVXNTcVNmZUltRDk5UUtraXZL?=
 =?utf-8?B?SlFzUWZKRDV0Wkp3V1oxRG9ZakZFbkdaaS9LTTAyY0diaU1QNDFpdVNNb3Bw?=
 =?utf-8?B?R3Qwekt6SWtRNWJ2R3MvL3UvNWovTGVzM0pXdUhjSlhxcy9XNHNEOVNuSEti?=
 =?utf-8?B?cFdVMmhhbGpkZjJURlZTY1N4NU5WNFBJOE9HVVQwOEVWU0FoTkpzNmsxY2ND?=
 =?utf-8?B?VUJsQ21MSXdRcU9HRWwrOWlpbDZTT3NqeDV3K0Frc085bHdUVDZMUmgvdDZv?=
 =?utf-8?B?L0JycGdveHZKUGw4N3gwWnVUTkNhUmtKdnlrdFZTeG9YbmY1aGMxNVBpb3Nu?=
 =?utf-8?B?U0tWcFpHTHZ6OXdZR0owYWhPaHJCeG9LazFjWTgzclJ1OTM3VElMWWNaMFVM?=
 =?utf-8?B?MHIxMmhOYjFXMDI5T25DcHJLSFdHQ3Mzb1NPV1cwRzNIRWNwZnhnTmtldlNj?=
 =?utf-8?B?RmN6NmZTN2JhaldKYzVpdkJtZUFnTGNFTGUzUWdhYnFNY0VEOWF1ZjNzQ0dO?=
 =?utf-8?B?RTZGdlJHNi9hQTVRNU9RcGdUL2cxaTZGeW1KeXd5M2ZmWVdqVW5QMnhueEVr?=
 =?utf-8?B?Q3NYZmNzMXMzdDNBTXpzdHY1c01TaTNWYVQwZ3ZwVVU5YmhldmpDelcwbXU0?=
 =?utf-8?B?anZxbU9RcmJybkpOTnA3YlJ5YmpKb2xxSlVDenRIY01nbmw0WXZLTTQ4K0Jt?=
 =?utf-8?B?Q244bUJoVFhiQUxRRk9hdlY1MFpucUNWTSt6NS8xbFQwMU1Wb1J1WkNjOE8y?=
 =?utf-8?B?bFFtZ2xBZ3pldndXQnFReEtJU0dBNVVSYmZDbUxaNEJPNUVkOCsvSDNoUlNa?=
 =?utf-8?B?WUp0WEFPcGRQeHlON3dEKzdvaVZSUXFjYWRzeFpEV2RPa3ViNUtWTWR3b3Zk?=
 =?utf-8?B?SkZTcUdDN3o1Ull0VVFkQ0J5dm5xdUJhNVcxNHpqbW1DMi83YVZReEdhSVhn?=
 =?utf-8?B?SzRDdFg2Qld5UWhDNDduMXV6K0t1REVBWUJHMmNkaHdjS1JXNm1UWWlKbTFE?=
 =?utf-8?B?TFhFKzlxV1Brdk05VXRsb2JWTVBhWFFnSWFsd2k3NTQzakhsTk4zdjVnZjE0?=
 =?utf-8?B?ZEZqdjRucm1XN2l1YjYzZTQ3NDJjWFlyWFYyTlVJTGt4cy96dE0ram5ZN1d3?=
 =?utf-8?B?SnNCSkxsWVJFZzRaWm5SZERGbk1VaWhvZmIxaEdBUkxBVVB3WHFBMzBMS1h3?=
 =?utf-8?B?MDJPbTFwWE9XTmlJemtoYktoTXNSZUkwSGt0R2paV29JT0djSTN0VFI0SkhR?=
 =?utf-8?B?bmRhdllmNkZLU2Zma01yeHcyOGlSeFFuVzMwWGs4N0lPcEJBVDEvWDFqVVRw?=
 =?utf-8?B?Mkp3ajZqdkw3MWM0VVhheUVLWXJGTGxDaExrd3NtdVp5TVQ2RU1zZUhneUp0?=
 =?utf-8?B?QitZeVZMdllVWkdIaG1WZ2xwempXTFJHZHN5cVl2QVMwcGdkSSsrR2k5UVpj?=
 =?utf-8?B?bGJPN2NKNTlSZ1c1Mi9mY3QxLzFHKzd4WExxOEhWMG9abFRRc2ZqQUZYRFVF?=
 =?utf-8?B?M2Fod2g3STVrWTRPSFByMmljNlBlNFlCQy91d3ZybEk2VlFhL1R0Z0hDbEFC?=
 =?utf-8?B?TkRvSmhPbElMdFV5VFlmR0w3TGZ4QjNpTXN3QTFuVEYrQUczdmRqZ29SV20v?=
 =?utf-8?B?bHZyMUhySmk1OGY4R3VJK0RVZ3lJdGhxWHBETlB6YkhRQ1hrQ3gxc3hMQnRr?=
 =?utf-8?B?K0hWMUNXUkg2bmN3RkQydXBxQUkvUFRVVzNFYXNjMkpXQ0lRR1M5VDY0UVdV?=
 =?utf-8?B?cGE1UnZBcTNUNnc3alNKbFI5NytiWXRzdzk2bGVNeGRFaWlReGRhSlA0VkF6?=
 =?utf-8?B?WWMzN21vTkFHeGtYYkI2S0dGeEJMeFAvVWxNbEkvVm9jclNZdlc1ZVB2NU5o?=
 =?utf-8?B?N3RvbDdsYzJ3WXhjWjVQb2NINnRmSWsrMGFFYlNkQ04wbEV3RTA4YnJxa3F1?=
 =?utf-8?B?dHdubTYzNGE4U1lna3dwUHJnbUNRbXFDM1N0UTZFcUoyNnN6bStmcmt0V0ti?=
 =?utf-8?B?bDBQQWNkekdUOC9ObmlkZU0wRGxmTyt4RlRxN0QzQU93NUxMNDFVTzNkOW9J?=
 =?utf-8?B?NW9Bc1FPNkMvdUdCSUNuSGRWeE1OUWxHUzgrYmppZTJVeWNKVCtJejUyQ2d6?=
 =?utf-8?B?UEU0R3Y0RFhKU2tMWUg5VmNSSDNqeG1ESWwvTXRKSlMrdDl5cG5QVjJFalRF?=
 =?utf-8?Q?JMqoRZ7shl7PyxTc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2847BCBB32933C41A31B2F579B147E93@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: AME7lPtkHaV/qjv67EqNwV1L7q8YC8BId7qkFwwHbcK74YqpoLJ5jJp3g3b1NVpScrl/5O88PZoGx6QvCblSBOjGNk/7Z5gXp81fMnucfqwRFkpJ0BZClVAMeSF2srcgMqDNuQUTzNG3YEzROuHu2IkIwYJsV7BRFGu2x6dwgKDcXZOeKI3uxxZAbyWgskgL4OVbbx+XOlRFH/hvAWWzwQ6g80nQoWhFK/zZOW49Vld7RSio1hwmoq5qqL17WORGa8ox20A6c/wGWLybu8wppyU+Cl066XrPHiocED4HjO0dZ5gIPyyZBpB7V1M+bPrCNNtlMo0fp2L/8LLw4UeEZQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c5ee74-411e-4154-f101-08dee63f7aa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2026 09:15:44.7756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFw16ZU1Gqr6RKtCJFccbybht5C8CsAh9PhwZLpHTyYdCK3i0iTOlM3dstEsrXZKPs1TSq/8bypyHp3wM80cJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB10511
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDIzOjM5ICswODAwLCBMaSBRaWFuZyB3cm90ZToNCj4gUlBN
QiBmcmFtZSBidWZmZXJzIGFyZSBwYXNzZWQgYXMgdTggcG9pbnRlcnMgYW5kIGRvIG5vdCBoYXZl
IGFuDQo+IA0KPiBhbGlnbm1lbnQgZ3VhcmFudGVlLiBVc2UgdW5hbGlnbmVkIGFjY2Vzc29ycyBm
b3IgdGhlIHJlcV9yZXNwIGZpZWxkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTGkgUWlhbmcgPGxp
cWlhbmcwMUBreWxpbm9zLmNuPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBl
dGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
