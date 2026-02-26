Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077272DAFBD;
	Thu, 26 Feb 2026 03:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077380; cv=fail; b=iug4c0Jg7dSVe2gZHU8YFSQ2I1/3rytPcqbbOUI7aq/iAZlPaOsdX6l9wdpUbOg3BJoRBlAqOoRXJwtB0x1U9fDvywEkDF0NjuJEUY6T8tF58tWBoFj2G/zLTiuU/05UMLneM5T1DhcZQxR/qXvV8IScIqTU2Ck9dIk9XXlNvbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077380; c=relaxed/simple;
	bh=i2dmjM523oIbG2+iICf5JP6Idn4mIM10ViR7LywFkuY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DL/BNWONOW/e2iyKNwOsCEBzwaYWLKEwHAli9k6a75vZ4EWpjZ5uAUmzKZWIkTjh2b9s7hYE86Z2yBfFYOSeBp3cZ4cdICsGpwOhHtj3ccSrKex7ZXFTDD9u77HuqzaW3aLoAcv/oPZ9Kszo9B4A52GAX2kqWQsjEM40iXac1nQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AfMPnsAs; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=URiE3tw/; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AfMPnsAs";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="URiE3tw/"
X-UUID: 3597934812c511f1b7fc4fdb8733b2bc-20260226
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=i2dmjM523oIbG2+iICf5JP6Idn4mIM10ViR7LywFkuY=;
	b=AfMPnsAsfLt2h7WU31MgLpaeauGOH3vrNesvj7yUGE9cB7VVCO5IKJoJ+UUCv6I6dFoPAV49po/pR+oFvQIfNr73Yd4uOEEwMpN84ocvdyq0h/HxVR34VZArKnroDB3bnb8hzeTyfwG7Q/oACIP19qC7BgnY1hD6eZ8mFJ6RHG8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:57b395af-3a7f-447a-aa88-edb0f49fca50,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:cbc305f1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3597934812c511f1b7fc4fdb8733b2bc-20260226
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1616286318; Thu, 26 Feb 2026 11:42:44 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 26 Feb 2026 11:42:42 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 26 Feb 2026 11:42:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BqtyQkjcL1yZoQjPtsD6tTmMU/C5BYk4gBbvZ770yDhA06hThoKXNlKahfjEGH2rFQMU6n0ToiYtu6ayUyrLoeov36v0eWPUwK6PFp4mO8e5XIYGBMCd6yrB8f8x8a+yqv5woBO4bGXglxUoqK9fgjMBGay6t2Zxaw2SP79wBlHTu9u6xtG2JVeJcNzohJiHbEBFhbzT0+Rx6kZpdnr+wHQEWACOapug6H7MNnBr2aF1ZiHVyb8EX8uLCgAYLgjNioqtZsN7pbGAMkb6IwAVm/17ySdY0g1CbLGSznSMAR/aihy1QmL52gR3SVhqI48UeQnaD5m7i4Y3SSij6qfqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2dmjM523oIbG2+iICf5JP6Idn4mIM10ViR7LywFkuY=;
 b=JKyoONYwPek58hbhA5i4ewxZFG1NKSGymiN0HhJhV7udqr2ySpqbUHZHwX74VJdALVuBBB2QjGKwbZHWgZqkjTtC32ULG7i45dIlbHUNZMz1KU9bLt9IaslAfZ7lT9ipkCAPbqiik/q3sJG0bQ9iX73Ob/VpuXL9J54YPVvsDkGZ3ur41a8dRxIICkAl65UupDM6d8RzS7x1F2ZkAdrybjoGvdDdXpqqJVh78JBPryQtpmX+jvamjBTh95DTodyMHqzvPwcKEnJVnLCrjWyVYG6RpDoy0liFFxEesFQrYBaRi7CnL1zsdQaMDWMPeNGOYXk+/E8d6G+0G6UCbBYw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2dmjM523oIbG2+iICf5JP6Idn4mIM10ViR7LywFkuY=;
 b=URiE3tw/yWQLuCJqeQj9fpLBWziHjsIT6mwT3r1r6R9GM1f5umzegP9qUdmiBgwfus95BE71I97WgD5IyBQnRC07nUc8eqRdvlh8oZrQKc0ZfLWZ6p9bHl/akAz9gLKaaeA/+AxPyrhgVpuM3K0t3R2Ntbmk+P1l0ESg8r4/ZJA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7060.apcprd03.prod.outlook.com (2603:1096:400:337::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 03:42:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 03:42:39 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 17/23] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Thread-Topic: [PATCH v7 17/23] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Thread-Index: AQHcn0nYpvPFSDho/kOoNfzP7/KCjbWTRaEAgAAhwwCAAP3vAA==
Date: Thu, 26 Feb 2026 03:42:39 +0000
Message-ID: <0ddec4b93fe9cdf38eeb6f7c37bbb0bcfe1e3d28.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-17-b5f2907c6da7@collabora.com>
	 <dd895595dbd4cf855ef4ea53aa1b5a0d30169f6c.camel@mediatek.com>
	 <5e61f0d5-d168-4d28-8a68-eb1369e7cf8b@collabora.com>
In-Reply-To: <5e61f0d5-d168-4d28-8a68-eb1369e7cf8b@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7060:EE_
x-ms-office365-filtering-correlation-id: 9309094b-5969-491d-9599-08de74e91724
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: qDatXdsAf6sVATQtxC5y+eu9WSzTpLv4QVsRQqb3P5Tmw2UD16RUyfgzPx++uTPLgX5BVV/hGMR2M31TPFxeaTi9ci8OiZjtqtoa6qo4QfrjHK6CJd0ILnBKa5zeRqn2LlLdJ38yigZUcIPws2ZdxLY0l31I+Joh0xNi/jPAZ8iFzjSeaHPUtBRs1BA4TGh3QI31B1lrv0lUXC9DFn+ma5N31H83JfE+dZxNw7oFgSQEeZvL6qK/j96MMQ0lDsxOjE7fWtOcAYeHN2BVwiqFjP0li8QaSAOwx7LJygcH68kcJequBGANNRDjQLH4mAaFSlHbvBqRC9YyRclh6P8nb8XtHesLaUXnOr7808EcE2QQM6RudKYrihkYXy5HzrXmWUuxkR0k+DXdtHrx7j8IT18JqyvdLkazrDBossnoc8t6XKz/cU9Ddd48BE95PxGgw7cj7S7FBfJu2e1V/pLGuxW4bOh7XsNFR9Al9ZiYMg3rASTBfnOlQp1M3VKWjIEIv9H/qNvo7k0BiZ88Tl/3GDk03WweHOuDkUvmzK7TlyVjiPt1yruA42pes8hLnunrI+f1WvvmQvB+xYZNaecThLWy81TN1e1Ar+cpTa0nLXDegCU9BJYvx10RxHTlbXC1lRcMDhSOnuKTUMk0E2+a5svSPQHlLdVkAl18V149AEMOEHP4yUqhRQCr4EwmU47z4/dGc37mipqOkjSBXFF1Psd5/JxFvj4TXpEBYAEii44xOC11C5/hBFY7nQHeiR5I7a8u2boAr28CPtFkzu6e1PYrfUz7w26ctV62U6nHdlBQK0HtNwfezPZEDZfUypkD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2FVMUYrUnFRcy9XVVJ0YWdzMXNweHRYTUlyWnVqRDFOQVZFazFJSG1aSXV5?=
 =?utf-8?B?RVF1TjVDVnRqYk1pTUFDeHRGb1JLVEJQVXFoWi9CQThXUkh3bFlraHVuV21t?=
 =?utf-8?B?cEd5MnphbmExN2pFQXY2S1Y2UGhlM240MkNHSDZJcmlJSXhjaHltZnlETWxk?=
 =?utf-8?B?RGVzZ2NiRHoxWk96dy9JVXM2SndCQ093QW5NVHRzYlUzYVMvSG9ycTErcndo?=
 =?utf-8?B?VDZjTzRQMm4wQ3BtUEpKTStQVU5qSzBFWVJML1pQYTZ1RVY0Zko0UlBPT0sr?=
 =?utf-8?B?MWIwejlQKzdlMkdidWo1U09YUEh1aGJDOFAzNHVVWSs1VSs3UDVqVFd6VEw1?=
 =?utf-8?B?bXlqbmdWeCtPWVlFamk4K2NNV3hYNzV6VTJVck1taEQvUXJ6MXF5Mjh2RDhP?=
 =?utf-8?B?ZlliMUg5RE5CZkNmUTlTYkV6bnhqaXVRUHdSRElqTkdtNkFKQktwNHRkVmpT?=
 =?utf-8?B?ZFl1UVV3bkprVzgxZWNnR3R3QXlIYnpTKzBaaVAxbm9CUy8vTlNOZ2hpNzM1?=
 =?utf-8?B?Qis4clBTT3VOMVhIR2E3U2dpYU5GY2E1MDUwL2NRS1ROc2xPaHZFZVFneTBI?=
 =?utf-8?B?d2xDWFRKd0h4ZEFRa201YlVNZUJzVlBnRUZUQWEyVmM1emlkTFkwNWxaSGZP?=
 =?utf-8?B?a0NNR0tIYnpJVE1JMDVBQXRiUE1OZjMzaS9TV1JUNytDdXBhL0RackpDWjZZ?=
 =?utf-8?B?TzBCaTJFNVdKdW1JZ1FtNjBBOENPcWU3M2pMU2Y4dVZLSy9KR1NFT2diakZD?=
 =?utf-8?B?RmlSaVBueGg0bkdjVzFOcGxSVzBWbytkZm9yeU05OVRMZTlnRE1XWTljWGI4?=
 =?utf-8?B?dXcyak9haW1kUWZiM05wYzc2RkJPTGlHYmJkbzZ1dzJJK2phcHRkNHhQbzhu?=
 =?utf-8?B?S1dSaStzSmUreXBkUHduTVh2K2htRTlQdkNRbC8yUnpQNUpPWUozWkFmY3Vr?=
 =?utf-8?B?NWE1aExMeGtjWUFkQ1ZTRTFqRkFoT0Fady96cVlBdWptV3hQTEhScXJBMWFZ?=
 =?utf-8?B?ZSttdDFWUDFPcmswdGdhbnRUY3FqTi9IUjFEN0pEOGl1eGZhWWIvbDBjMndw?=
 =?utf-8?B?K3Q5WmF2bW9XSTNLaHJlTDF4WGhmcUkvNGlUSzd6ZzdJNEgrdDJ4Sm5yd214?=
 =?utf-8?B?cEdNeUFTdG5CNDNERHBFRmM1ZS9aSU9zYUJsS0VnYzd0OHJuM2dEY1Y1c0dO?=
 =?utf-8?B?UUx5L1VnYkJmR1FjdlRMdnRUaytoYTlxVmpqbnoxNDUrbWxUNm5oUUdiSEow?=
 =?utf-8?B?a2tjWWllUjkvdEdHWklqRzlYTkdRMmhnNUtGTGVnd3RKc3FUM3RnZTN4WEN1?=
 =?utf-8?B?aEN4Y21EU3BxbE92YStkcEIwUVAxdG1TSEUwalYvYUNLZmo4cU5pck13aDBQ?=
 =?utf-8?B?V3Z3dHU5bHBVekVVbGRqM3JRZjFnRXpoS1dlZUtYM0I2enVTaGtKTEZucExo?=
 =?utf-8?B?MmRJQXZteXMxdkRneVpWRnpLVHJVNHBhaGhKNXZVTW5ZTDFURVBpbmExQ0dG?=
 =?utf-8?B?b0d6ZG1GaUZqRy9iOHV2Y1l5ZkdTSlF3V1NqcjliKzROcUwrN04wYXBIazVm?=
 =?utf-8?B?UGJUVnl3czdXVDNiZExaNG0rcU9RMnhGaWhWcWxxcXNtN2NiVTNTUWRpNkpP?=
 =?utf-8?B?SEh5aUpMcnNIV1hOK0VhZEtVOWpVZnR2aU4zcXppK0kzMUo1TGRQaEFaVmd2?=
 =?utf-8?B?Y0VXL3J6UEo2bW5pN3Zhb0doR1lud3IvZG0rVkZjTkQydG8xQzZOUm8yKy9U?=
 =?utf-8?B?RVVvK3VIblRJblVzczBteFY0ZStIZ1BNL2d6dmdCTk5paVBtcVFYV2wxVWxt?=
 =?utf-8?B?OXgzMVJ5TkdESGxpbGZVUU4rMitVZThVeXhMdjJLQmhDSVZ0N2ZZelpkblJw?=
 =?utf-8?B?d3VrMGhlLzFJbVJzN0twK3JJVnZaN2l4azFUNkpJdk9UcWpiYmtXcGhTampJ?=
 =?utf-8?B?Wm8xeDU0NmM5RUJuMlpUcXdHKzZTUUUrV09tVnpDc2diN1Vzd21VT1RFdDB5?=
 =?utf-8?B?OFdyNEdlalNFM2MyWnZBeW4wWi9GSXpnY09BK3FVZXpGdkM3NURmQW1MdlZO?=
 =?utf-8?B?YWRYU2RnNXVYeHN1SmQxc3hiY2U1QkVLNXlMWmlKODU0Z0NpTnA0Yy9kVW9x?=
 =?utf-8?B?cDgvclJxVkZqcFV3ZDZJbGRRaXZSTzhZUTVqRjlaSUlJQzc2SjdtMGIwdXlU?=
 =?utf-8?B?WDJJSFJoaUxZWlYvRXA2c0lpQXJUdnN0RUovcXZlbmdyRmFwRDEyUXJud2Rz?=
 =?utf-8?B?ZzBBSjA0aHlnNHVNdSt6QkRRdWZ4alhNRlh5N0M3bnp1RTFnYzZ1OFVmc25h?=
 =?utf-8?B?dTdWZnFLdS9GNFp3dHZwWlZVNlVudDRuakFWU1FhaEtIL241WHNFWml5TXA3?=
 =?utf-8?Q?44mQCFlC/s4ZeFho=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <020C0A134BCA0745A67E05CB39698A20@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ggrmYFYO0E5jWoQGZqGucqXRdDbrD5CnBTnp1HUVP6QDYWBE8qra55c6eZZXmnWxHjQgS5eHrhsgMZRFg8bvzQv0tamdEA6GBw0BwZQ5rmxPleRh+t6qmQFVwhvpVO4sTqvjc5YgywTtKX9shw5X3kPPVKVnQ5oshri3A4QnEMtDs1M+e9BcjJzYKPYpR9us+bpeSB73pnDTaE1SgHvsEtimLnHsbSP6ErhEQv+nIsXKjNEDWsgl/fKowFJe24kDPXTqF2+Y5/MORucZUY88FAHsxq2bj7mtUANkzS2tIzwzfTMYHTtDI4nRn4ELd7Aem+3NpXOxN5YiOHokuQcCHg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9309094b-5969-491d-9599-08de74e91724
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 03:42:39.7079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wjiqt2kPAvwqO1Nk/Ly5qIRdgKFaKMZI9o2IizCTcOArueTe3K+9RYcUdsx+ipQBJD3yg/fVrsKayweLI0e4fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7060
X-MTK: N

T24gV2VkLCAyMDI2LTAyLTI1IGF0IDEzOjMzICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gVGhlIGxvZ2ljIGlzIHByYWN0aWNhbGx5IHRoZSBzYW1lLCBleGNlcHQg
aXQncyBwcm9wZXIgbm93Lg0KPiANCj4gVGhlcmUncyBubyBuZWVkIHRvIHdhaXQgZm9yIGBzbSA9
IFZTX0hDRV9CQVNFYCBpZiBgc20gPT0NCj4gVlNfSENFX0JBU0VgLg0KPiANCj4gSW4gb3RoZXIg
d29yZHMsIGp1c3QgcmVhZCB0aGUgY29tbWVudCB0aGF0IE5pY29sYXMgaGFzIHB1dCBpbiB0aGUN
Cj4gY29kZToNCj4gLyogSWYgdGhlIGRldmljZSBpcyBhbHJlYWR5IGluIHRoZSBiYXNlIHN0YXRl
IGFmdGVyIDEwdXMsIGRvbid0IHdhaXQuDQo+ICovDQo+IA0KPiAuLi5iZWNhdXNlIHRoZXJlJ3Mg
bm8gbmVlZCB0byB3YWl0IGZvciB0aGUgZGV2aWNlIHRvIGdldCB0byBCQVNFDQo+IHN0YXRlLA0K
PiBpZiB0aGUgZGV2aWNlIGlzICphbHJlYWR5KiBpbiBCQVNFIHN0YXRlLiBJdCdzIHByZXR0eSBv
YnZpb3VzIHN0dWZmDQo+IGhlcmUuDQo+IA0KPiBSZWdhcmRzLA0KPiBBbmdlbG8NCg0KSGkgQW5n
ZWxvR2lvYWNjaGlubywNCg0KWW91IG1pc3NlZCBteSBwb2ludC4NClllcywgaXQncyB0cnVlIHRo
YXQgaWYgdGhlIGRldmljZSBpcyBhbHJlYWR5IGluIHRoZSBiYXNlDQpzdGF0ZSBhZnRlciAxMOKA
r868cywgeW91IGRvbid0IG5lZWQgdG8gd2FpdC4NCkJ1dCBpZiB0aGUgZGV2aWNlIGlzIGluIGFu
b3RoZXIgc3RhdGUgYWZ0ZXIgMTDigK/OvHMsIHN1Y2ggDQphcyBWU19IQ0VfRE1FX1JFU0VULCB5
b3UgYWxzbyBkb24ndCBuZWVkIHRvIHdhaXQuDQoNCkJlc2lkZXMsIGlmIGFmdGVyIDEw4oCvzrxz
IHRoZSByZWFkIHN0YXRlIGlzIGJldHdlZW4gDQpWU19ISUJfRVhJVCBhbmQgVlNfSElCX0VOVEVS
LCB0aGVuIHlvdSBzaG91bGQgd2FpdCB1bnRpbCANCml0IHJlYWNoZXMgVlNfSENFX0JBU0UsIG5v
dCBhbm90aGVyIHN0YXRlIGxpa2UgVlNfSENFX0RNRV9SRVNFVC4NCg0KVGhhbmtzLg0KUGV0ZXIN
Cg0KDQo=
