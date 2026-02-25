Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291B2314D13;
	Wed, 25 Feb 2026 07:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772004053; cv=fail; b=el4I2fY6ZNJO9FLjEL4dD9iqW380NF8y7hbkkW/BGky9VRrCAdnibYwdGbqGpvm9kehpIANHXBqqyX4HtuYhIAInCMFzfPxpoaJAYItkHbM9jXUaTUl7OjK/EBq8UE+5zRdEWmBUSWiEcwctknri5Sa16AZRqaoHH97QIkLQ5gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772004053; c=relaxed/simple;
	bh=JSsVxXVhD0WxonJy5EwB0poZp2By8i9qo6rX1o8zhqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ec+/hb1y7VPsF1tZuzaqJj5hZuEXksJ14XznleliW24RcaTM0ae2yiaTZFxmRixalUHJYguD8aUTXGC/RNxt5PbTYYbH8/YwUyYyIjShXkNEqpcePm9dWk3sHLoxfK3rAvuo8uv+Y1B3Ejq63qRN8XvH/UNIYvpVycn6lYlIbpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GI3EL6Qq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=e7+T5MPf; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GI3EL6Qq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="e7+T5MPf"
X-UUID: 7f8a1d96121a11f1bcd7499a721e883d-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=JSsVxXVhD0WxonJy5EwB0poZp2By8i9qo6rX1o8zhqk=;
	b=GI3EL6Qqjk8V32R2TL/WHgaTdNDOL28YCVykbt98nu2AZyYM/Ug/cO+weYTK9CDpD4stVqdBSmNRb629m7+3TMDtNijeyXEVHUZeZ0af9r0iRdbTLRmWVrK+3ROWCNwnWerGZNbwX4xfjsEk6EyWzA+r9OoP3cIW/l3Tg7i9iQY=;
X-CID-CACHE: Type:Local,Time:202602251518+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:f725eca8-4eb6-476f-b465-720e131a2639,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:f65c3f7b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7f8a1d96121a11f1bcd7499a721e883d-20260225
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 568809100; Wed, 25 Feb 2026 15:20:44 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 15:20:40 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 15:20:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdHjAD0ZsQvQdtBKFBZumnMRl0vrAQ+hzo/FLAOO6zmu13MpWDvZMHvunelGcEaR3wQPt++e1khLlDMmKNha7cI+NYz8dIAf/DXmOY/XsWQ1IbuTnYomKPRT9M3YMXA47ckhPJeg42O47Y3jROpirZi1D/1+UCdZz58gf2UjvvTUbaEhLiFog8X+LzPLALqKk/6V0llJCH2fGwulLm/LwQjlqR63SOSJ/IiTqZQdBYyS/xeMxp8gPxZq2nzVawCfkPyblXlXfRbzkV8LuySumxFgA9pWGm29HH6B6vaL5FmeW7NUZzqVWe5SiJjFLabO/CCygQv95ffYV1KPaASO+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSsVxXVhD0WxonJy5EwB0poZp2By8i9qo6rX1o8zhqk=;
 b=URbL1N/lbxQBE9u3/EVRjG0x+GPeVxjE8X2l8MlYrG0u55Blqy39NjjN9JSl8fIHLXo2ouRFJYJei0Ul+9BVOEj0x/vNYUZptsGYZefNhPHsbQCQvsUETkf4DySHgwD0ImvSzxLhSDCw4QKivw9SU2ZJ2hxuWuLoHoTbCOGGBqTbNy+nQY/23isVIJk/beZB7kJ36Wm2gaqSnbaI1BsZxSfdorkYUNHNjVzQl67lbnqCmGRHZKKkU8AkLtMPi3h2JdjsLkGeDqI9jybnWTOqRAkQFYWiZFC/LfXHgJRMZR9EJ7LPCTY+NWAT/a7y8SwJmwsDQfQLVSGCNKP74XB6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSsVxXVhD0WxonJy5EwB0poZp2By8i9qo6rX1o8zhqk=;
 b=e7+T5MPfKv6/Z8daIEwKG9tK+vl2s/aZhRvpbntRw2N7MdsScfImaySV7yNz2AimCtjE+5pv3nqZeGEFMJ6YNspSxoEVIF/Wt0pDrOWd/knJ0Rm3p1b4TOe6F00UKrRBTFTjQ755I14J5SsKGRxwRLwBptPu5qs7i3Q16BuJUTM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB9573.apcprd03.prod.outlook.com (2603:1096:405:39c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 07:20:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 07:20:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Topic: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Index: AQHcn0nPvDFB0gw0KE2BmOLle5gC1LWTD+QA
Date: Wed, 25 Feb 2026 07:20:37 +0000
Message-ID: <e719d75f583106fff6330e8b84736afc2fec09b4.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB9573:EE_
x-ms-office365-filtering-correlation-id: 4c37095e-165d-4fc2-2e81-08de743e5f7f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NytHODhxWFB6SW94TXU5R291dzRnZG5wK3pvR2ZCU0pERWluOHRmY2lxR0sx?=
 =?utf-8?B?NGczS2QvSWl3Q1lUUGtnQ1pLVnA0QktXU1Bnd2ZuUW9ObXR6dVFEazZkSXNL?=
 =?utf-8?B?aGdmYlVJdmdPaXUweFppUnA0YTM3R3RXVGN1RFNGK2ZRWHJqT1g3Mi9LaElP?=
 =?utf-8?B?ZUY0Y3pGRHB3Qi9kUGkrbGU0RVhSZVlVYTNVYW0xdGI3QXFBM2RPV3B6SmhH?=
 =?utf-8?B?a2lJbkFJNHZHdklSQnkvWGRXSTVJaXp4VGo4bmw0dG4wYXYwcjVVNzZXQVpI?=
 =?utf-8?B?WkZNd2RhQS9VcC8yWGJ0MVJaU2s2c1RDdTk5UTRhQy9lNGpVNUpsTkh1QVhG?=
 =?utf-8?B?MVRBUkJzRm9aTWlRb2FsZWxBTldsS09lVlg5WnIvYml4N1NmbkNxQzFqU2Vj?=
 =?utf-8?B?OEVTT3RtYWgzc0xYZUhXU08yaWYwY2ZWc3U2Vzc3K0htYThJVUVTa2h0V2xt?=
 =?utf-8?B?UDk5MC9kd3FSZVlUWi9jcnZrTFV3aXdDc2dmeDRTMmJwS3pIRzdNSnl1bHBV?=
 =?utf-8?B?V3ZCais4Q2FkUG9aMVNsZldSbmFXTUtwYVFjb2Y0SkhBTWFoNGdqRWN3VXFm?=
 =?utf-8?B?RGVqRHZ3M2I2eDRZV2E0aVNINzBjMGRqUTdiNkE3NDNpUCsxZXlmRkpGU0Nk?=
 =?utf-8?B?L2t0ZnQ1cFBQL0huTDhKL3ZKNHhPMzlWcGtLZ3Ayc2xzbWFhNS9wZ3FqeVFX?=
 =?utf-8?B?WHZsbENOY2Vwa2ZqbTlqKzFRNjhtZ2VlaXVDZGlVVHh3UVZoNlpaanlVUzdh?=
 =?utf-8?B?V2lWWk0vQjhnVnJoMmFZbUJEc2FKeW5YWStJTmxmeERRSEZQOGJSS2E1akVV?=
 =?utf-8?B?VlJiRS9pRU5aajdDNHB6OWk4VFhXSlZGdTVxSnUxQ1VHK3pYMFZYVTNrYis2?=
 =?utf-8?B?MGt5NStJMmFQN2ZtR3BVS0p1ZXpxa2IreVZ6ZjF4QlprMmNrZExLZ0lGZ1JM?=
 =?utf-8?B?QThEa0w0QWdZS0hrK3dSQUxPQlF0cmdFTmluMmhJT0tRamwxTm5QZzRFa2Fh?=
 =?utf-8?B?aWdzSzFDSDJjdFVZbHZQT3Y3bmxWcUxLeFo5dzk0Sk1sdnVkbXNUMTRYQ0Mr?=
 =?utf-8?B?Sjh2YlRBWWpzbWtDenlqUmJSUENxTFZsTTViK0Y0bjBrR2RXQ3hKSHJkZytl?=
 =?utf-8?B?eWpuYU8vTTZoYmIyK1ZWdzRjTmFheWJHYm5SdjZMUHFtZDlCRFh1dlJIMzVB?=
 =?utf-8?B?Wkk2eGg3Tks4a2RIR1ZMY0owV2hISjlaMmgvbGNkSm04QXdHajRjampoNUd2?=
 =?utf-8?B?ZlR0SzdhOHM4b0FnaEkxSisxVlFvcHdSMUJmU3ArRWhjdGFBMUNjZmtWeGdq?=
 =?utf-8?B?bFpOakk1TWQ1bG5hOVVLRzZzMXQyOG42Qno2WHpKdDFBUnBzTDdIWGRVL2dK?=
 =?utf-8?B?WHl5WlNTSldJdlVjc29YRWRhSHFVWUx3MmlJKzVPNjdiZGlWMEhmQ2szbTBD?=
 =?utf-8?B?eVZhSWltczI2d2F4Z1lGa1pBNEdlbHozMUNZT2FBK2htb2Y5WGNueFpYSGhL?=
 =?utf-8?B?dE5HMUZpSGRoeldnOXNCWEFzeXo5dGtxS1BJU3BoU1BFSjIrOS85Z2dKOTNW?=
 =?utf-8?B?azI2VkZIU1pkSVFUMTNuMkV5TGdEcExhQmFhak80Zy9RMURibHFVR2o2VGxF?=
 =?utf-8?B?OWpQa0ZzT3NJR0VmNU8zcGVtZGRPZ09QWk9jUHBzY3UybWVGN3gycTJRdzNH?=
 =?utf-8?B?dzczaWpkVXp4R3JVY043Um1pSmtBcFo4aTluSWVvSCtOeFZVc2J0dkhsVW5k?=
 =?utf-8?B?LytkVnYvM042SE94Y3VOTVFRRW5HdWI3cENVLzcwams4YXJIVHB2YjRuVzRU?=
 =?utf-8?B?eUhQOG44SHZreXFIVVRQT1lSTUJoL2M3ODJVeUthRG85WWhrWU1TZ09jWmYv?=
 =?utf-8?B?aGhWTzAvU2hrcnFJa3JPUDVOMDZESks4OVBXcnZWWDFlTnl5Q0hiMUFxdXVp?=
 =?utf-8?B?WGlmRHQ4aFYwdnkyOWJqN1h1aEhxdmQ3MXFiN0hUR09nQmJ6OEVZSGNsWjI3?=
 =?utf-8?B?OE9HQkdyODRyYWNBZS9OUEZ5ZExucHRnMGJXZkpjQ0ZBQjJjdTU0TDNPV2d6?=
 =?utf-8?B?bXZnYlVCaUFqVVp5Q3VrS1VzTkdjVTNyL3BZNTl4a3RDbzIzUmNvajRCUmh0?=
 =?utf-8?B?RG5LV0xGZjcyNm9wU0pSNFg0UlpOL2FtU01VQ3VpYlRqWWdtR0NNZlFpY2Y4?=
 =?utf-8?Q?zYyk+sqxO7zDGS923dU1d4zi5T/9V0pd5u10DjEeptXm?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1hCNnRtTll4aHp0NmtKam1tVFpxWnFtT2dZYllLV2h5ODk4djc0TFRBZzVx?=
 =?utf-8?B?a0U0NHpkQmdub0RRQ08vQzFZeitVQ1JQVDFRdkhXTWcwam4yY0dXWmluZWI4?=
 =?utf-8?B?bUpQNWFjL3pUTmZPcVpSUm5ZdDZQQWgvUDd4TTJIMVk0T3VRbDFIUUpGQ2FV?=
 =?utf-8?B?d1QwVjVTaFFaNStGWGxMVmF1aFpZM0lDUUdPWGp3N1BXc1owSmlpcXAzbmh0?=
 =?utf-8?B?QXhQY1NpejcvWlJEZ0NrdURSTkF3alBrSkRNK0d5TUhqcm53UjJqSngvSFJD?=
 =?utf-8?B?K0NlcWdYY0RSbzMySDFYZmE2S1FrNDFPcmxmWEkyNG1WT2R5QWJHZlJVNS9W?=
 =?utf-8?B?TlQ4UmM3S0RrRXQ4UTlYZmJHVDdlVmdUR0JiN2ZPNGpZT1ZlOTVUYnlZcDNX?=
 =?utf-8?B?YWVuWWI2SC9FRGpERVAxMVM0UkhFdTk0WVZIVnk5TEhjckNLdnRtakgwNmdM?=
 =?utf-8?B?dlUySHF4QnRBK0pyTEVvZk1xajlZTTdtdFZJaStuYTZaTDVtNk1CTUh3UFJD?=
 =?utf-8?B?eEtQejYvNEFUUTNQSE1EMWVKVUU0SVJ6ZTJha3NaSHVGNE16ZDdBbCtOWlFI?=
 =?utf-8?B?NUxlRXlZazEyaUx3ZVRRUmJnUUwvbEdyNVFxNjVYc0ZHVWlhOGI4N21yK2VU?=
 =?utf-8?B?OHNSNjJ5aXdHb01vOWJzNXk0dFc3UUR5KzE1SSs4czd4Q2l1alltRzV1T2Ur?=
 =?utf-8?B?R0pWbUxXbUdGQjFVSzJESll2dW5zUmYzSFFrL1RJVlVhZlFzOEplSWhTS3M1?=
 =?utf-8?B?cUk4dHVHelBrUzJKV3h4eHh5c29WUmxWc0prZmczL1RZSU1OMzVMWXU4VVVt?=
 =?utf-8?B?dmd2NVJBTm10NXY5SzFvNUJpVVdwcVgxWnRRQ3ZjMTdwajJHT0lDbXVFdkpO?=
 =?utf-8?B?N055RVEyRDNPSGlmU1Y5SS9URU1iRjdoRTl1SzFPZHBsNEVvcTBDY1R4eUF4?=
 =?utf-8?B?OVJwVGU3UktCdWg4aXg1YmM3OGMwWSsrNVppRlUwYWNSOGcxYzJQOWtrdmVK?=
 =?utf-8?B?eUFlbmRXZUk0eGQ1WGlWckozL2VubGVOdUViUlNFZURrWkdDQXFSY09vQkRY?=
 =?utf-8?B?cE9sN2o3QnZYMUJIVDd1MGE0cDluVVZKZUlDYVdnUDJyeHl2YWdsZ2JQQXh5?=
 =?utf-8?B?NHU0Z1g1OUJuTWtsQ0owQXZhN0d6VzhrSENzM1E2YkpnMVRZTmdGb0VHRnlw?=
 =?utf-8?B?UFI3OXA1dEdOdDFFSVJ3a2VEeEtZZUd3NW9qM2dFbmVUemp5eUhsbmFnemlp?=
 =?utf-8?B?Wkd2S0p4dDlhb1FOc0tLTTN5T2lBUUFyTkVzOWpZT3FCOUl4YWdSRVFENHBn?=
 =?utf-8?B?R1BhY1MxNVgvdFNvVmhGaHphVlpHdDhVQmkyRDUwQk1XYXlpWEpMMTdVbWdL?=
 =?utf-8?B?dTgwQ0dKTlVrOWh4Yy9nVjRaeUZUSElQaTNPQkp3T3RHa2tkVGlFUEFZOC95?=
 =?utf-8?B?cGVzVmltTGExQXlZenN2NVZQdWFOMXMzd2dNYlhvbE1rem84bk1aaW81aGxY?=
 =?utf-8?B?ZWhUNUptSEh2eU15cFc5T0JTL3FJdW5NUzlyblBkOXFoRmJLOHJSUkZkQzMw?=
 =?utf-8?B?bEVMUmV1dm10RFBvUjdPV29hNWt6cHlaT3ErUWw1dHR4V0J3R3dUQVNodzJK?=
 =?utf-8?B?U0paZVAraXR6bmxwZ3ZhWWUxRm5TZzJ3OGRqNW9TYVd6RnZOblZ3bFJIK3FZ?=
 =?utf-8?B?dHNCK0RjeVJFR2VNZUZtbmZBSlJjMVgxMU43akhHV3dFRjlRUU80bW9hNE9x?=
 =?utf-8?B?eFRjTFFRbCtENkxKdWVUeGxPd0FqYklzUXJSMjRzV01JbUd2Q1ZYQU1Vd3hN?=
 =?utf-8?B?ZE1yYlY3YXNXdXpxTm5YcUV1N0pnWlJtR0xTWHRlb1VxWVBVY0NNTmNEd0Z0?=
 =?utf-8?B?eU02UkM5MmNtZ3RSaXFJT2YzVkV3bnl4SGxzNG41MVJNOEM4aDdPemwybE8x?=
 =?utf-8?B?aXpWN1VSd0FhcUVvTlV2Yk5zM2N5VFBOUGdXL2QwYjRRY1lQVHFpV1Z1Uy9z?=
 =?utf-8?B?bk9RL1YzeW1DN0NvYjliMUUyMnNnc0IzWmdIUndrTFJNYVBGajVkVlBLN25u?=
 =?utf-8?B?NFptU1FYaHZIS21WSE5jc0NaU093OHBIVzY0SHNIQmxuTUZkU0x2MXJzQlF3?=
 =?utf-8?B?MWNjYU5ZL3lKb1Zua0F1N2JYQjNrS2EwVmttOG43NTRtTFZZT0dwRitNeVIz?=
 =?utf-8?B?TUpZK1FPSWJTOFE0QU96bDkwQVVzd2Y1M1ErbjZTZ1FhVDRpeFhwRVhEcEJx?=
 =?utf-8?B?ZWZYSWZ3SzlPUFhibmRnbWx4YkRjVWFxU2swb2lHY2xaakk0MkVDUDNXb1VF?=
 =?utf-8?B?emVyT0dRRkZXWHNjSjNhTjI0OVFMVkFsdytCWHhpQjVlcXlGcDB2SFdXMCtl?=
 =?utf-8?Q?KxWsbcWfgzY3ziro=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21E0F4824D925D4F8214AF645C9E8864@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GsuInCO6q0sRv/ldSvNIBFXyGr3lWTHoHAOGoxrN0tRPJx6VBplpNcRVXe2IkbX6HBouvF8koFuWWgm3EfR1iWJv1+3dU/PG6W2YZ2LDySCLd8Dfd1bxqnD59p8nCejn8ZQ+4MWxhmfgIK4jPeP+yI2effQPq2dsCs3R6foYi7fWpQDalSWxvYQe7kByY3jB8q5xzinqWaBZow0qzqOO7YleQCtNBC6LyLUCvrnXZnGlzHkDbHPj7v7LlUNZBfIYFMQTS7rnOzvTin5ZoUOqD6VgLmUoMUyqKfS+3ZJ6AmwGQ0jwIOlzrCOvB9sTz8ekPwtpgH1xgeZ4UTtkYMlOgg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c37095e-165d-4fc2-2e81-08de743e5f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 07:20:37.1855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q5JxtvtuzEOTgNihKqQWz9JJpx5vr21xtZgq3JzSg/rdSgky+YPEUEE9gX1A6Tgyj2iZ0/DmuhAKGeyDT6zSFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB9573
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IE1lZGlhVGVrIFNvQ3MgaGFuZGxlZCBieSB0aGlzIGRyaXZlciBjb250YWluIGEgcGVy
LVNvQyBzcGVjaWZpYyBzZXQNCj4gb2YNCj4gbWlzY2VsbGFuZW91cyBzdXBwbGllcy4gVGhlc2Ug
ZmVlZCBwYXJ0cyBvZiB0aGUgVUZTIGNvbnRyb2xsZXINCj4gc2lsaWNvbg0KPiBpbnNpZGUgdGhl
IFNvQywgYXMgb3Bwb3NlZCB0byB0aGUgVUZTIGNhcmQuDQo+IA0KPiBBZGQgdGhlIG5lY2Vzc2Fy
eSBkcml2ZXIgY29kZSB0byBhY3F1aXJlIHRoZXNlIHN1cHBsaWVzIHVzaW5nIHRoZQ0KPiByZWd1
bGF0b3IgYnVsayBBUEkuIFRoZXkgc2hvdWxkIGJlIGtlcHQgb24gZHVyaW5nIHN1c3BlbmQsIHNv
IGVuYWJsZQ0KPiB0aGVtIHdoZW4gYWNxdWlyaW5nLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vs
b0dpb2FjY2hpbm8gRGVsIFJlZ25vDQo+IDxhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxh
Ym9yYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5m
cmF0dGFyb2xpQGNvbGxhYm9yYS5jb20+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRl
ci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
