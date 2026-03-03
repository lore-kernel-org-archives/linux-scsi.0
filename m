Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA7382387;
	Tue,  3 Mar 2026 08:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772525211; cv=fail; b=CztsUfMkdnAOenuycScS0aUE12W/QQqWHa99xUH/npApRs3tul9gbTvSdSD1HUbKovkJK9/9ErdWfzg10jddbfOzSTyPxFX4Fd6fmqZGUAnV+YgwGuQUn2mIspzuflSzTJZ94bDE87LlrXtzkfUYDVVfZkT7Wf1TUh2/EOPTbc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772525211; c=relaxed/simple;
	bh=PNyTSxHP6F99vc4hcQsIfnPOGqdDhQaA5d32CRR3b3U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EJiZoQWitqsVoXsSXACL6RFcmndolJKLtSYVmrykpFseI40xSi6Q1JyRECamFt/LOvznmnQ++Fktyrtu1TqBZYocR86di30Z23cU0tmophpEIJo2fMnwugb5eJiklFNQk/t9CGhbBr0WDY+rTTbCAfK1kWDnOh/LfU/GA0mi7u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=V10cxy2L; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=sE5c4Cpi; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="V10cxy2L";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="sE5c4Cpi"
X-UUID: eb38381816d711f1b7fc4fdb8733b2bc-20260303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PNyTSxHP6F99vc4hcQsIfnPOGqdDhQaA5d32CRR3b3U=;
	b=V10cxy2Lu27Nf0yAGDTw/4asSryxkeYGbSB2GMK/wNQ4jx0FXSMBjmyVlZJME+ElCT1NpEXSf7a2jb23AvYcZUSdRh0s0HBgbPyl8v8/IJLKAd30jMYJ8DGB8PZCr1lC/3TG68Uu3/Po9holoPvz59J7qI59bFcVsUa7CE91Si8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:7d35cf1c-cb89-4582-b2cb-0af628359498,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:08a033f1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: eb38381816d711f1b7fc4fdb8733b2bc-20260303
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1733544609; Tue, 03 Mar 2026 16:06:44 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 3 Mar 2026 16:06:43 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 3 Mar 2026 16:06:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yT9mMpxXSK55wp5G5WI5Gu3kRpHxPvEILV0/tDLKpfj7Q4KP4vgLe72m7UtSBlK70yVfYXHSJeSfmYOKmiiAjmxHKwhg5kd+ULBNdjcaHvET0cgK+taYZAqW7OPmVlLU5Q+ZRzTLeTpP2wiF87lnB4GuCGFd0yxMp9xjl7RVNvG5veeiFw8aZFnZWRR+WSZxCouWKcNc7aj94HIA1bxJKbUxpPxeqLm32CD1Ig+Ft8qiQhhIyn7cuD42oKMXb2Yem/+JuuMaYu/NWRWYI/ZP5ejS5ckwAyn+u9SXb/KS8NZe3CJh/clWXdjiLzsd0L4av5AHrvd1AzWmQCiOQl6vKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNyTSxHP6F99vc4hcQsIfnPOGqdDhQaA5d32CRR3b3U=;
 b=x/QEVISRiR3WA2uc0J779WKglEpOojOv2IEP3BPlGw72CL3njfI7tEJEQYTP3RZbuBcOIYC/MzsOZnvg7LfQztCW3mENrUGlrvMv7GQphaU48d1bI79YMDPm4ZIWGFu1lHwgZVlQGWBYmc3KlOQy5wgbTc9inzwDuLD7qEF5yyRocGQ7kNpy3faD5WdDfLvAQjzLqnaMFoteo7unAE8lRiiCtjhHxtAO6J3I1k0/s47se1RUVmiZymkQhHUVV8LuojNmVk1NrM0ca7sjpJOLz0R3VorOiHVgTVEcGfPsKq98CCxNc/mF6PzBiahA63B4Da5oFb69So/Ix3qFc4PI2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNyTSxHP6F99vc4hcQsIfnPOGqdDhQaA5d32CRR3b3U=;
 b=sE5c4CpiyZS2JeMpXpiLdnS3R2Y9fZjX+01GhDgS+iWhtQ6ICf5m34bRGr2e5+XZ77ukGS+YzK0mVVHuOLOUzpIwuXJw1EmsXHpm5jWw1q9qHSU+XekoqQ+xtrMrfKinpMpUBLHRFwXy/QiLqXDIiQIvUP9oMKnSlkocPPeFWFU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUZPR03MB9712.apcprd03.prod.outlook.com (2603:1096:d10:61::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Tue, 3 Mar
 2026 08:06:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 08:06:40 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
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
Subject: Re: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Topic: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Thread-Index: AQHcn0ncDWW9D+zkUUupEOV+hOFhPrWR2OKAgAGXfYCAAAN1gIABKM8AgAA+2wCAB69BgA==
Date: Tue, 3 Mar 2026 08:06:40 +0000
Message-ID: <76e49783820e2d9dcd3ad5568124a9396da9b37d.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
	 <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
	 <2575185.irdbgypaU6@workhorse>
	 <f0e97a38-a11b-4e69-902a-e0ccd0dc4540@collabora.com>
	 <259b24885e5e721ae562d27dd761b02e6a68c971.camel@mediatek.com>
	 <84f22f00-e3eb-4ea5-999e-260c81f29338@collabora.com>
In-Reply-To: <84f22f00-e3eb-4ea5-999e-260c81f29338@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUZPR03MB9712:EE_
x-ms-office365-filtering-correlation-id: 7ed6da82-8451-45a8-f0ab-08de78fbcccc
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: AZa4TJmYRNsWN1jAwmsFII0Z0cGKmgbW8LWP5okoGuuruKk/KTScWFgud+ffM5xFLq/tHQfBq3QpvxT3PdvkB5eq3FGo+HvG0wjHB55vWL/kbV0b1Xj28cwemFzULI5YppSUmQPeDwDIF6hOiIpqamNOsRPkY6nsjKPK48S601AsuQs1tjsSSVYL8fb0iYDjdcbtd93UXmvySUo8gRjZAHO8aXyCIfUVKv31mkP40nX0fA1D5tUfRAp1PZOzbs+l10HCDig6AowE86Gu7so+0EkJucpSOssF/ays6T6wjeuJs3B4ur2TqbvvAfiFmSXi07518OKMaeDkpEz8vXzaaGj7ughhpV8lAkT93H+VeAUBmJSw1qtCDKfczra5oH9qqX12u4U4O1n6BPWLyszeCVCZ3T5Ik83QXZ2XDskd+uIuy7JjjFfcHkgTGtdHFIeytERdqk8V76TWTVI8JP/UzNiJ1LtuaWeU0ShdBVZD63zBTreR7HlGAJ/Ag+Cdk+C0ET5XNC87PD5O2pU5+eqnPFrjcN9WRtvg6xj61MwmrVQADe5TcDYg4RyHVHC4MJbdlT6v85PiQLMJ8YB0aJOavmrnXo0KPE0grkM+VaS1M+zDDH1kjsxg3dVRX31meH4BchW/XmgMy3Em6rtACOQqUUaJ5gs9zOP81pSwtVdLnhWJigr945gPS+Is7K3sTytxqfXBjI/3f2Pnqq0D8I7YnGTx75OZpUbE/r2ZRus+QZ5Pn7AsMByTS9fCAjOfSKvGXz6p7yJf/vCoRFw0U8CVUW0R9tPggeDMW6IUySoidqUEJ4m8TlEi5aVgsCV4K286
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUpwOXBQR2xEUWlhNjB3WEpxN3FYQmM2YVJpNHBZT2FNRkdjZVFtQ1paYkkx?=
 =?utf-8?B?NFRtSlZiam9tWjZxaTMzSSt6NFRkNVVJaWVhZFYvMDlaZVpST045TWxISUc4?=
 =?utf-8?B?NDF0WGQ3RDhoOEFQNnhuNUl2WkNNOHN0OWE0S09CMDUreXd0aCtCZm9PaDhG?=
 =?utf-8?B?eXpUL0tTOEFxdWpZbkpWUXVnc3R4dWlSS3dhZ25PRTF0dndCYklTZ0xUTktU?=
 =?utf-8?B?V3hVMjFmYlBFOGZJSDNUTXNQVm5Dc1NMVTYwRW5pSW5YRXh5ZG9NQlBJa09I?=
 =?utf-8?B?cVkwQ1drbUFoNzNYSzErZkNGTFl1NXhTd04rampTSlpXUFdHbERzaldjalMv?=
 =?utf-8?B?Yml4L2c2Ym9SMndTR2NtK3p1VThJVGQ1TGJRczJVZ1dpZEliK0ZBWS9CVjZo?=
 =?utf-8?B?V2xrYkFDZVc3N0ZOWkZvQTZub3pRQ0oydmMreGpoL0dmdHBVVGxaOWkwUktp?=
 =?utf-8?B?RDVmL2tTM2RhaVh1Zmd2R3JMUkpuZVpvZzdnbG9vUE9qbFdVdXh1V201SzAx?=
 =?utf-8?B?TkZDc090SHZpc1o2ZXVBOGxPYkhaRGF2eTlaeHhJK1JaVzRQelpPT2ZiU1FP?=
 =?utf-8?B?YVdLUDg1T0pZb3dudThYNFM1UGNIeG9HcmI4VWJPWnQvNGhSZjdPaTFRanBU?=
 =?utf-8?B?ckhYazNoS0kxRjVpQ3o5ZjVrYStOL3JOL1RIM3hrZU53Mk9ibjZmclA5UXUz?=
 =?utf-8?B?T1hzSzBvNS9NK2VYTmtDcXYyODZLOVdLcXMxdTlTK2FTOE9aZjRDMFFuMlBk?=
 =?utf-8?B?ZUUyZWVaRkhQNjdzQWM0UFlMeDkxUWV2d1p4WUtvMEJ0YnBXRkNyK0Y2YnYy?=
 =?utf-8?B?YWE3ZDVnV3ZwYlBJVktuWTJtcEdWUGhiM3U2MFFlenFjMTYzQm9uYXJtd2NN?=
 =?utf-8?B?cFNnSng1V1JlR3lUbnE3S2F2aTFRZHZwN2dEdmxsTDdjL3p4eTJlUUlvdFFy?=
 =?utf-8?B?Wm44bWhvTDV4b3Z6bVNVOFFCbEF1U1lNVitwSlR4YmVTVmpBb2RocG1aMHZY?=
 =?utf-8?B?ZlFEV3RzUG1RMkEzejM3bjA0NlVneVhnNy9uYUlQcmdiTFhxV3VmK2IycFFj?=
 =?utf-8?B?ZnQwV3kvRlQwZmxnVzlFV2NBZmI1WGcxYTdaSk5RUG1UTXNsMWFWRkRTcjVE?=
 =?utf-8?B?T2hZMWEvU2hFeTdUbStuRjlRclZ5Vm0ycW9ISlNUaWVNcnZkTWpOY2JwK05J?=
 =?utf-8?B?MERGWVZNZm5hSmhUUHNOU09QVmRoazJpUUdYS25lL0pVL05OR0RrQk5pcjdu?=
 =?utf-8?B?VE1wa0M4WDI1U1A1cGdXZitpUnRjT05vcWlrQmY1NmZuaTBSUFRCM0lsZFBB?=
 =?utf-8?B?ZWxpdkpJc2RTeXhBbjN0VGFsRGRaSm5LdGVRWGMrV1lTRXNRcDJpcldmK1lu?=
 =?utf-8?B?WlJMS0JDeUpvNHNaZXErZGsvNlduU3JyQm1ZcGVtVERhWDYyZkVzbWdpR0x5?=
 =?utf-8?B?V2k0NVlheVNXRXIzc1pTSlc1bXpzMnBOSkZjZjZ0RXltQXlPdVVWTE1hY1Zp?=
 =?utf-8?B?WWlSdDhzbzhnaXdtRFJXZ2NHWGJyQnNSc3AzcWppT0VDdmtQRXFxTVJYeVBy?=
 =?utf-8?B?SmF3NTkzY2FSaXJGVk5vOVo4dzNONzlLLzVHb2V1TFF6NWdhSE0weVBFTExJ?=
 =?utf-8?B?WGhNZzRVNE1SQUNCS3BaclF4QjRVbHB6LzhEejZyYlBqY3NXSnRlWWJqZkRF?=
 =?utf-8?B?WUpCVnVPZGc4WFNPUnhFdllmN1RoMGxhWUNaRm5JQlNDQTJsakdja1IwZGFR?=
 =?utf-8?B?ZURRdDZkSU5tRHhIU3N1YnYwVEI3R0lnSmd2dUpPYmp5cHE4eEl4MyswNHJk?=
 =?utf-8?B?RXl5WTdIUFRVajNWMHQ4TVNYZ2FJSHE2ZHhTOGVNbTlLb0RDQ0ZNVFFuVGY0?=
 =?utf-8?B?WWVCZTdNRnhZRk9qY0l1RDIydWRQY1lJL1ZXMHkrZTRYbFpnMElCQ0t0Mksw?=
 =?utf-8?B?N01qT0lwMTlKbzFkcXN4ZFFvMG9RaXdwNmczV3NjYmpDbnJGT01TRlg4cGV6?=
 =?utf-8?B?OUJXbnZVeGVNMW1tVVFxT0dvTnMyb3dBSGdGNWVNelJKVkV5STB3R1U4ejRk?=
 =?utf-8?B?NThOSVRQU1lRWlhsVDAvS3g5eDhEOFl1OFpzYVBiSGhtSENvR0NFWi9EYmFj?=
 =?utf-8?B?bFJIVGJtYzFybDlTQVR4azdkVklCMk9xUXdpSlord0hrUXA3OUNDbVZqWEJh?=
 =?utf-8?B?SytRS1ZLVE8yNlNDQXBVQ0xPMjdZc0ZMZCsxMFpyVEsvWXVpRUMrTE9tb0ll?=
 =?utf-8?B?QjkySTd6Y0IwVmdJNit4TEVxRStYdUsrTkZ2SjBMa0JwYlpRMzdIcXM5RVZF?=
 =?utf-8?B?cmEwODRTQnNBSzMweFNxdUdkTmUyL2dVTDRBQ05JWVJCTEhxMXl6OGdzczJn?=
 =?utf-8?Q?kEld6JVZ4IyYDras=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9546035E42A8A14881DC2886B009A9D8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: NqA9Iu2wsyoE6A78LQdqVcmXQpVTJhIq5dzLxWR0iTqBP83jV+KBMTsjnfX9FxxAgzgjqOW7FaKIaxYW/II8tXPXxYL9K/DudTesXhyj4Ye0bFZt0l7BfszihpUbQm38p0qOXIPFuszhoSk7AAE8NwcaIaX5vOvLztnTmcYsFcug32xSRkCGxLhwT/7SWcwnHq+4uNRnwh7XrSG5O3tP+4DGV0qKQ5219Ye68NGrFnkWzvFxu/54aQZv3jeSNjzhu6q0Vg7OaeIZsYXBGbjVBnyWdzuf+WDAQCP6FY0ElFSzgrmne0bowi38TiZe5xVgMB17bXHHJ4MH0yZZVmONkw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed6da82-8451-45a8-f0ab-08de78fbcccc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 08:06:40.1201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YfRRd1uHsE8kWPncElnWIl/RYOL9dREGthAjt/1j9ViQ6l0hVOReK9GEzFd/9cq3zDZiqzyMUhl4u7iNjMEF8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR03MB9712
X-MTK: N

T24gVGh1LCAyMDI2LTAyLTI2IGF0IDExOjQ1ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gU29ycnkgUGV0ZXIsIGJ1dCBJJ2QgYXJndWUgdGhhdCB0aGUgdXNlcnMg
ZG9uJ3QgY2FyZSBhYm91dCBob3cgbXVjaA0KPiBhbmQgd2hlbg0KPiB0aGVpciBVRlMgZGV2aWNl
IHJlc2V0cy4gVXNlcnMganVzdCB3YW50IHRvIHVzZSBhIGRldmljZSwgd2l0aG91dA0KPiBjYXJp
bmcNCj4gYWJvdXQgYW55IGltcGxlbWVudGF0aW9uIGRldGFpbC4NCj4gVGhlIHNwaXJpdCBpczog
InJhZGlvIHNpbGVuY2UgYXMgbG9uZyBhcyBldmVyeXRoaW5nIHdvcmtzIGdvb2QiLg0KPiANCj4g
UG93ZXIgdXNlcnMgbWlnaHQgd2FudCB0byBjaGVjayB0aGUga2VybmVsIGxvZyBpbiBhIHByb2Js
ZW1hdGljDQo+IHNjZW5hcmlvIHRvDQo+IHNlZWsgZm9yIGEgbWVzc2FnZSB0aGF0IHNheXMgdGhh
dCAic29tZXRoaW5nIHdlbnQgaG9ycmlibHkgd3JvbmciLA0KPiBidXQgb3RoZXINCj4gdGhhbiBk
ZXZlbG9wZXJzLCBub2JvZHkgY2FyZXMgYWJvdXQgd2hlbiBVRlMgcmVzZXRzLg0KPiANCj4gwqBG
cm9tIGEgZGV2ZWxvcGVyIHN0YW5kcG9pbnQsIEkgZG8gYWdyZWUgd2l0aCB5b3UgaW4gdGhhdCB3
ZSBkbyAqbm90Kg0KPiB3YW50IHRvDQo+IHNlZSBkZXZpY2UgcmVzZXRzIG9jY3VycmluZyByZXBl
YXRlZGx5LCBidXQgd2UncmUgdGFsa2luZyBhYm91dCBhDQo+IHVzZXIgaGVyZS4NCj4gDQo+IFNl
ZSBpdCBsaWtlIHRoaXMuLi4gaW1hZ2luZSBpZiBhbGwgb2YgdGhlIGRldmljZSBkcml2ZXJzIGlu
IHRoZSBMaW51eA0KPiBrZXJuZWwNCj4gd291bGQgc2F5ICJkZXZpY2UgcmVzZXQgZG9uZSI6IGhv
dyBtYW55IGRldmljZXMgYXJlIHByZXNlbnQgaW4gb25lDQo+IFNvQyAob2YNCj4gY291cnNlLCBp
Z25vcmluZyBzdWJkZXZpY2VzIG9uIGEgYm9hcmQpPw0KPiANCj4gT2YgYWxsIHRob3NlIG1hbnkg
ZGV2aWNlcywgaWYgYWxsIG9mIHRoZW0gd291bGQgcHJpbnQgYSBtZXNzYWdlDQo+IHNheWluZyB0
aGF0DQo+IHRoZWlyIHJlc2V0IGlzIGRvbmUgKGFuZCBvcGVyYXRpb24gaXMgb2spLCB0aGUga2Vy
bmVsIGxvZyB3b3VsZCBnZXQNCj4gcXVpdGUgYQ0KPiBiaXQgY2xvZ2dlZCwgeW91J2QgbmVlZCB0
byBoYXZlIGEgYmlnZ2VyIFJBTSBjYXJ2ZW91dCBqdXN0IGZvciAuLg0KPiB3ZWxsLCB0aGUNCj4g
a2VybmVsIGxvZyBpdHNlbGYsIGFuZCB0aGVuIHlvdSdkIGhhdmUgdG8gZ3JlcCB0aGUgbG9nLCBo
b3BpbmcgdG8NCj4gZmluZCB0aGUNCj4gb25lIHNpbmdsZSBsaW5lIHRoYXQgaGVscHMgeW91IGZp
bmRpbmcgYW4gaXNzdWUgdGhhdCB5b3UncmUgaGF2aW5nLg0KPiANCj4gVGhpcyBpcyB0aGUgcmVh
c29uIHdoeSBrZWVwaW5nIGFueSBtZXNzYWdlIHRoYXQgaXMgbm90IGV4YWN0bHkgYQ0KPiAqc2lu
Z2xlKg0KPiBpbmRpY2F0aW9uIG9mIGFuIGVycm9yIChzbywgYW4gYWN0dWFsIGlzc3VlKSBhcyBh
IGRldl9kYmcoKSBpcyBhDQo+IHNlbnNpYmxlDQo+IHRoaW5nIHRvIGRvIChhbmQgb2YgY291cnNl
LCB3aXRoIGR5bmFtaWMgZGVidWcgaW4gdGhlIGtlcm5lbCwgeW91IGNhbg0KPiBhbHdheXMNCj4g
YWN0aXZhdGUgdGhhdCBvbi10aGUtZmx5IHdpdGhvdXQgcmVjb21waWxpbmcgdG8gdmVyaWZ5IGZ1
bmN0aW9uYWxpdHkNCj4gc2hvdWxkDQo+IHlvdSBoYXZlIGFueSBpbW1lZGlhdGUgZG91YnQpLg0K
PiANCj4gU28gd2hpbGUgSSBhZ3JlZSBhYm91dCB5b3VyIHJlYXNvbnMsIEkgdmVyeSBzdHJvbmds
eSBkaXNhZ3JlZSBhYm91dA0KPiBoYXZpbmcNCj4gdGhpcyBtZXNzYWdlIGFzIGEgZGV2X2luZm8o
KSwgbm9yIGFueXRoaW5nIGVsc2UgdGhhdCBpcyBub3QgZGV2X2RiZygpDQo+IHJlYWxseS4NCj4g
DQo+IFJlZ2FyZHMsDQo+IEFuZ2Vsbw0KDQpIaSBBbmdlbG9HaW9hY2NoaW5vLA0KDQpJIGFtIG5v
dCBzdXJlIGlmIHlvdSBrbm93IHRoYXQgd2hlbiBVRlMgZW5jb3VudGVycyBhbiBlcnJvciwNCnN1
Y2ggYXMgYSBVSUMgZXJyb3Igb3IgdGltZW91dCwgc29tZSBlcnJvcnMgY2FuIGJlIHNvIHNldmVy
ZQ0KdGhhdCB0aGV5IGNhbm5vdCBiZSByZWNvdmVyZWQgd2l0aG91dCBhIHJlc2V0LiBJbiB0aGVz
ZSBjYXNlcywNCndlIG5lZWQgdG8gcGVyZm9ybSBlcnJvciBoYW5kbGluZyBvciByZWNvdmVyeSBi
eSByZXNldHRpbmcgDQp0aGUgZGV2aWNlLg0KDQpJIGFncmVlIHRoYXQgInJhZGlvIHNpbGVuY2Ug
aXMgcHJlZmVyYWJsZSBhcyBsb25nIGFzIGV2ZXJ5dGhpbmcNCndvcmtzIHdlbGwuIiBIb3dldmVy
LCB1c2VycyBtYXkgc29tZXRpbWVzIHdvbmRlciB3aHkgdGhlaXIgDQpkZXZpY2UgKHBob25lLCB0
YWJsZXQsIGxhcHRvcCwgZXRjLikgc2hvd3MgZ29vZCBJTyBwZXJmb3JtYW5jZSANCmluIHRlc3Rz
LCBidXQgdGhlIGFjdHVhbCB1c2VyIGV4cGVyaWVuY2UgaXMgcG9vciAobGFnZ3kpLg0KVGhpcyBs
b2cgY2FuIHByb3ZpZGUgdXNlcnMgd2l0aCBhbiBleHBsYW5hdGlvbiBmb3IgSU8gbGFnDQpkdXJp
bmcgdXNhZ2UuDQoNCkkgYWxzbyBhZ3JlZSB0aGF0IG1hbnkgZGV2aWNlcyBhcmUgcHJlc2VudCBp
biBhIHNpbmdsZSBTb0MsIGJ1dA0KSSBkb24ndCB0aGluayB0aGVyZSBpcyBtdWNoIHJlc2V0IGlu
Zm9ybWF0aW9uIHRocm91Z2hvdXQgdGhlIHN5c3RlbS4NCkVhY2ggZGV2aWNlIHNob3VsZCBlbnN1
cmUgdGhhdCB0aGUgbGlrZWxpaG9vZCBvZiBhIHJlc2V0IChlcnJvcikgDQppcyBtaW5pbWl6ZWQu
DQoNClRoYW5rcy4NClBldGVyDQoNCg==
