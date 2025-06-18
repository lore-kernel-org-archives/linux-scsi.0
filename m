Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBD29443;
	Wed, 18 Jun 2025 04:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750219699; cv=fail; b=uGKi6Lkq7QJYBuko2uy0uyDxuaaSB/k9ee72cCElGWBvku0xZywh29qxe3sFG0w51ElBroJkh7Yf8ZWWNYPe5xbo7rla79bWKtaG1R6iffdCjuAXdxudwwnZM1qkI5NEJiBIASZg5f1plkbJO7KZq1+f29M8vadHTtV4/WOS4tY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750219699; c=relaxed/simple;
	bh=jxwjPkTMjGyy6VQwVqs3XHgkQEFbGGcS9OxnssXhfYM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d9YMQY1lsGWHxKKWFomD9QH4w1sv7iEdZlZ611InN+OuWc9XpFzkhtRE4xdCMMzLte//VQFwpjfyKqU2TuEmY45fvb1YGsnbDPm7Z/8l3qrwmzFYA8jKx0w1D5e9Qft/BCSHRpRwqSSsLdZh8ILPw9+y9NkFbW7TjDwp2rlEtSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EGSLa25h; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=LIfZNp6p; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EGSLa25h";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="LIfZNp6p"
X-UUID: d9d9b62c4bf911f0b910cdf5d4d8066a-20250618
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=jxwjPkTMjGyy6VQwVqs3XHgkQEFbGGcS9OxnssXhfYM=;
	b=EGSLa25h4odOtmWds88E/9WvJf0kWzTxBSiQMZwKKulI6ONdEw5tctfoQmmyMQ3shqLVnEa88qstdvpRlPfKf8pbDEM+Y+jY+E15oTbYfKTeLIXnYaH8S6dcQbyDYhHL8ClA1A9Ex/6XMeBVPBnyZALxucA11QBBbMMByajQyFE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.3,REQID:567a901b-87a1-41fe-b98f-15485ff66681,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:09905cf,CLOUDID:ba229428-fdd2-4021-9c0c-83548fdcf243,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d9d9b62c4bf911f0b910cdf5d4d8066a-20250618
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1525336889; Wed, 18 Jun 2025 12:08:12 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 18 Jun 2025 12:08:11 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 18 Jun 2025 12:08:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOZmGZTOqOnHHWgjx1vG2DkcBpz6k2xOLzadfApLdvLIhdrTsTpjx4F+/1CgkHkpL6T7tWc/C7vwibP1beYxs6tvIzZ2nK5ewjZUCl2TpDxSjZ6laZ9UyF0v33O1CmMS0fAaVnPxO/oYX4h0Os9ZliIzcXkUPTiN248rfJ1rDsGAlQqNQRbZbPsGgARjxwqaN/0orIlO9pp/NmaHiIqZvirDMpiwgQ9IryEPriPDAEVZjFx50fJmN8eOguJ5uoYhzjGdhatz01jBehf9vQ6EM0Vj4r5pSYsrpiAOjC8/2iwcfuN7DuzvkKL1nG01pyNyOnU8X2/Tx4zZB1h2MO24Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxwjPkTMjGyy6VQwVqs3XHgkQEFbGGcS9OxnssXhfYM=;
 b=kumpv5HcSxrjXwD1qxSE74uJpQffC1HSs8itS17Gw+chQawsfb+CUpEyKp28zEvSjyPOWeDTMr29A5HHDHZ4OuJ1w5bSM1TGLsaYuD9hTZx5VDWdHIXglVDGfk+kxXKy7pKuthulTTxeELfiq1krkUGdlJ9uPiisZuzVvKE3sqQuxudSXNIS43JkTFFS6zcfq3IEMhTOf32LYaGu+Ga0R21/HwTL+nGP611HIeRmmLuOpRVOh9AHkxe6M8lk966bfnrl0nQtR16OnfO5jcXx2I+7FF7kIxAMNOkSE6dUhlcfAbAAWrpAPn/9sfN64NdIlfHzl3Ggtne8NMus6Tpx+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxwjPkTMjGyy6VQwVqs3XHgkQEFbGGcS9OxnssXhfYM=;
 b=LIfZNp6pecCcCGZShGvFCnL/OA1q26aKWSgnd/dP2Dcb+9iMdd/yy55Me/OFuxy0RB/jrR9NpAmhwrqS2CJOYfj3zfIkMmCuwZKhhkLpgJdgnG0rHBrpI7OegvUZO77kwNmHZ2ZpNFwjyNfl+/jfHxw32gncSqTmCo1ZLH2VbR4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8765.apcprd03.prod.outlook.com (2603:1096:101:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 18 Jun
 2025 04:08:09 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8857.016; Wed, 18 Jun 2025
 04:08:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "mrigankac@google.com" <mrigankac@google.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "mani@kernel.org"
	<mani@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manugautam@google.com" <manugautam@google.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ufs: scsi: core: Send a NOP OUT to device before
 disabling AHIT
Thread-Topic: [PATCH] ufs: scsi: core: Send a NOP OUT to device before
 disabling AHIT
Thread-Index: AQHb31q13oiNTZkLoUiirfbplqRGALQITnmA
Date: Wed, 18 Jun 2025 04:08:09 +0000
Message-ID: <2699d51bce81bd68fd1552a1ea17bc4bd773c7e9.camel@mediatek.com>
References: <20250617073702.1207412-1-mrigankac@google.com>
In-Reply-To: <20250617073702.1207412-1-mrigankac@google.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8765:EE_
x-ms-office365-filtering-correlation-id: 3b57f7c3-ac99-46d6-2e86-08ddae1dbc81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YjA5bVVua3lpZHNNZ3BiRnEra2Q1MGI2YkppQlJSMVZDK2l5UGZ2YkhNaDdh?=
 =?utf-8?B?TFltZlUzK0xUY1p4U2E3eVh6ZlJXMkp4WUxBdndsVEREcUhrS1lIQk9tU3Mv?=
 =?utf-8?B?Tks2MW44WnR3NTg0K3BIbDd5bWhyVm1MYUtTdVE1bVlUSUFSMWxQQ1JZSmtM?=
 =?utf-8?B?bHVXVGtBVnlJR2hCUHNmSStoU24zbFVZWmdMQnQvNUx2ejVjVlZja3VUYmlX?=
 =?utf-8?B?bmJ0QTlqQTRJUnNNenY4NkNUUWluSXZ0Q3UyQWQvWkxWb3dpUVRzRm9Wd2dp?=
 =?utf-8?B?aFNEV1hlQmkyTWgvd0VJS3ZMSUp0RmpROFdNWDV4Rk9xN1JKaDJhRkZVOE92?=
 =?utf-8?B?Z0VaUVNNRlE1RTE0d2RqNkM1aGRycHRnWFVNdGJsVU9INTU3bjhDeWxDTFhL?=
 =?utf-8?B?OVBaRnpSZU02SjM1ZEhEaTArV2g3cEU1VmpaVFdqckl4N0VCYUdzaXhsTnVx?=
 =?utf-8?B?aFlBZWs2Qzh3cWNrdEtyNkZ0bGM0RXQrWm9jQXNiaTg0WDdwRDQ5eU1DQVEy?=
 =?utf-8?B?NEk5RmM1dUV4Q0RGa0xnSVo4T2J1OWJUdUg0OGhzNEFqaHdzU0w0SkVjMWt5?=
 =?utf-8?B?dnhtSGtkTUw1KzgxMHpzT04rRkQ2bm05clk5VFdZL0ZOUjdwaGdxU01Ubmhr?=
 =?utf-8?B?cGtvK09TQlhYS3RaYXZucU1CMjRJc2E5TzFodkRZTVN5MkF6OGRhQ0R1UGFm?=
 =?utf-8?B?djlKTUxvQUUxY3dIa1diUktndHdib3hQd0xJNFdLMkErUkpBRkZ1K0JmYURZ?=
 =?utf-8?B?dkMwTmVWK0VoQmlmdjZ6MnlRbmg0WGw4Ump3aUdLSDFzNEhQcnVXZlZ1U0NW?=
 =?utf-8?B?V3Bla1dBdUVCbjFNempTdUx3Y1FsdzdXc3hodW5YMjA0MTBtQWtYU2s1cE9L?=
 =?utf-8?B?cERZZTdQazd1WHMrT21ldEV5NFBZU055RllOd0RTRk9XWjRBUm56MWFUbTUw?=
 =?utf-8?B?d2UxSmRoSnkyRmdpNDBGRFkyZjZqcjRib3Z6MC9wcHJkbXRUZGJLU0pvWHk3?=
 =?utf-8?B?amhyWjJQM0hLQ2RLYWFRSzUwdGFDbWI0dlZGZFlicGE4RWU0UVd5U3ZsSjJl?=
 =?utf-8?B?M2R0QXFKdjZlL0Jic0UvTkxEMzhpK3hpaWZxZTFGN0tsT2JLenZFMWhET1pG?=
 =?utf-8?B?KzZMOEhDNi90amJiZE5BU1o2S1hjdEVOcHdKM2g0K2xXYWorUmtobWNuVEl0?=
 =?utf-8?B?YUFqay9GZjA1OTZnM1dodG5FVmdvUDdKZXlpeHZ5N0dyV3RiMmMvY1d4RUE0?=
 =?utf-8?B?N0xPNWNLMHBBbFV2YUVPZWJmb2JwWUl5STd1Nk5KY0RmdEtNZ3JObFRqVENF?=
 =?utf-8?B?QUJoWkhWbWFoMm5JenN4ZlprNm1Xb1RrOFludFFKU2JtVVVNWG53RHZnd0xY?=
 =?utf-8?B?Y2pTN09sNXk0KzVZS1VpbXQrNUNhYi9BeTRtTFNmQ28wNFp2cmhMdnVZTkl6?=
 =?utf-8?B?MzdGZDlVWGZDU0czYzFacDNFeVEwOE9lRlo0SGZMQ003UVRXVmRWR25NMmx6?=
 =?utf-8?B?aHR6anhlRzBxT0gyOThBTCtIbk9TTE5FMHBKRlRHcmVQYlR3UjJhVEpOVEpk?=
 =?utf-8?B?ckc3S3cwc2lsSWcvcGtxWVlnamh3OHJlejhUQ2w3eSs0TXVUcTFpL3l2TWFh?=
 =?utf-8?B?YjBsbFR0NEdaYmQxUkY3RkFocFkwVmNXcnk2WGZJNjBodjNMV1RyUm42Wmpl?=
 =?utf-8?B?ZFFWNjlnU1ZUNTcweGZoZXFSK01WL1EvU0hURGl5N1ZiWVFJcVh3ZU91QVhM?=
 =?utf-8?B?OTExVXh5RHVTdXZyUnhueC9GM2lueHpCMlEwL2kwODJiWHhsbng2VWNLa3My?=
 =?utf-8?B?c29KbWdVYXV2VFBpeEhCeTU4RTBzam5pUDQrMWdYeUpZMTRlQm1uZmVGUGRn?=
 =?utf-8?B?dEtRT3ZBNnNkMU15bFZmbjlBQll2SlMvc01ZclFZMEJCTDJLcDlPWmNjZktX?=
 =?utf-8?B?TmhnYUtMVzFzZHQ4ZDhGQUNReC9EK0RPSGJraVY5SFAxV1puZnk0Q3I2UGJU?=
 =?utf-8?B?UUpzZGkyQnBRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WitGQURsWTV6QjBpZi9XeUlHWnF6SWZyZS9EL0MwbVNCOHpIeXU4UEFQNXY5?=
 =?utf-8?B?bkFOS0FNV1oraG1oYzJvSVU2bGFNc1NpcFNIQkE5aGpCY3J1RVg5ek4xejZ0?=
 =?utf-8?B?WGhMMjhYOGtlQW5ldy93Y1E4UG5HRk1MaUx1UjRFOVd3YUcrOE5Fd3pOQkhh?=
 =?utf-8?B?eExVQlJ3SHdQTU9mc0FqMkh5dG96WE81azB1UGxpWXpoWWFQUFRuQWdhRjNI?=
 =?utf-8?B?OXhycFJMckpHSy9ZaE8wcG5zYUdzY2F1YmFYRU0vTG94QnlHeDJCWXZBWTI0?=
 =?utf-8?B?TjdXb2RhSGo4eFhFdE1FWW1aUXF4d3Z3TklvMWZITjFxVzZMMXNOK2RjNGc4?=
 =?utf-8?B?ai9pbjk4aXZxY09EUS9abnJpdnRnRGZpRFc2WktOZnZ2dFRDSjRFVkNtWkYz?=
 =?utf-8?B?cjVhU05QV3lpM3RXVHd6NjJaM2RVcW81VGF2a3BTNjNTbWJ0VUl1T2hVREtT?=
 =?utf-8?B?dzlzMERSTlFlb05qOFFCeVVCbEtLRmVxRHJaSUIrUUZzd3hrMnFpVWNHTmRL?=
 =?utf-8?B?OENMMWZGbHJBa2haUlJoaEFJVUZGck1JTVg0ZjdJN25EVjRBQ08yVWh5Mk16?=
 =?utf-8?B?TTNOWGpPUHk5bWNnVkdqdnFLUTExTGtsWWNra3Jzc2x2MU9pc1AxYlNQeFMy?=
 =?utf-8?B?TWdudkkzcFJmTTRRVVZkeWdJYjFwT0xIdDgyNnUrQjV6WU9nZWhkVE85OFlY?=
 =?utf-8?B?bUFsVW9ZMjVOaFhIU3d4cm1IcUg1UjR5eTZtTE1zcDhPcVllM0tNVjdhUXZG?=
 =?utf-8?B?bXJyWFNlcVhXbi9Fa3RQMndtaTZjOUwyZkV0YmROMkphVzB0THZRV2YvZHlD?=
 =?utf-8?B?UXdNUUNsZ1ZWRVl0YmIrMjR0ZG8yUVpXOVNvV0ZGbEpocjdWT0Yyb3drUC9T?=
 =?utf-8?B?b1kvaDBsS2lac0pZUkxueTFqRG1vKzIvMmpQYkx5QUJDZzVFbkpJa3hlVU9m?=
 =?utf-8?B?U3JXRkRyTjZGSDFVRUdzSE1ndTNFWVR1YURjUjlZa0JiQ3Q3MEVORytWbWNQ?=
 =?utf-8?B?dTRTdjBCeW5lUDBnQnh5N2tkZTJNTHhvQkw0Y0RJdVJZSFhqK2JVK2tYYWxQ?=
 =?utf-8?B?d0s5RjRTeFFCdnNBZU82SlVSbzlaT1RvR2VQcmc3RCtuRjRCTjVtdUJNSEVR?=
 =?utf-8?B?T3VDZk5ZbW92WFJUK0VmNjd2OU5yUDBKUFhDazk0STN0bVdLOGxrRzkrQ1hF?=
 =?utf-8?B?aHVaYjdmTnQ3QUZyOWZCaUlqU01JRlQvN3lDUmV4V0NXT05FSFhYQVRPaG5u?=
 =?utf-8?B?RnFZOVJwazVEYXN0M2cwd2xRTm1BQUFpWWlWaU5TQXhaWVhKd3pocVgxSTYz?=
 =?utf-8?B?N1dQSHY5ditKQ1AyeUZYcE54eVBQTHBtVTZKdjNzZnE4bzk5Y1NjTUhBdzVT?=
 =?utf-8?B?SUV6Vm1xdlNDSG5yeHV0T01nQ1dVT2c0K0lYOXpNUVZCZXEyTlFlMGxKVlJH?=
 =?utf-8?B?NEltL0JHNnArTG5kaFhubVZFNm1KTS9FenhCNDBnb0hsZTNGNkJlT1Z2ODhY?=
 =?utf-8?B?ZlBNb0IwS2VRblo1UmVZNDhJT0FxUzZiWmRTUmF1R2ZZQXZkSkhrNHB0Y1N1?=
 =?utf-8?B?V2lZRUphUFNEa2NveTgxTzIyeVpzNlRDN1BEVWJ1cytVa0NhTWN4VTZHU25G?=
 =?utf-8?B?YW9UK1pnb2NGdVd4TXJyS2M2VHpPVUpjcVJJM1ZVUHBFSjlaSWwrbTd4MElN?=
 =?utf-8?B?TzdRMk5wQWZWK0NDVWJBM3FHdlM3bVJrdFhSOWh6NnFnZHJlbXdaUGNmRmtK?=
 =?utf-8?B?M2d0VWYzbGpNR1dqZEJtbzZXRUc5N3dLZEdNZklyTXhMaVVlcTVXdVo4UmY0?=
 =?utf-8?B?aEFqWFVIR1hVUGZEdVpVVFdxcXdobFVndWNIYVNXNndwcTh6dUsrb1JCb0Fh?=
 =?utf-8?B?QktySnhyM2FqRjZRMSszUEt0TWxuRnc5djRTVjlncFpLNjZlUEZWQVBaWXN0?=
 =?utf-8?B?cCsxY3haREs5UGJZaHhOQ2YrYTNoWFVUNFlNSExCcmhDU3BNV1VSNnVEaHFC?=
 =?utf-8?B?NUxITEgrVks4aWFnNFNCQkNsZjNscy85ZDVEdG9waXpaYnd2TE9iVTB5VGpG?=
 =?utf-8?B?elVsTDVVSmZsVjVzVmhzeldMditxNmQ3QzRQdVVOWUJBaHFwVlNDWWU0WG5P?=
 =?utf-8?B?dmVHWCtpWXpkTWt4RysyUEZZWU9QcVdqZWVzUGx6VDlOR29LUm9yS214OUht?=
 =?utf-8?B?QkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4DB88778D48504184A062A27C20E074@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b57f7c3-ac99-46d6-2e86-08ddae1dbc81
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 04:08:09.5957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qcG1J3pwJKzcfUkVXsoi/lB1VYP/pIGlKSBhGlP18HWjweYk821tpd8eS8eTcJkr22HT7NTNwK48tescZ0rtPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8765

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDA3OjM3ICswMDAwLCBNcmlnYW5rYSBDaGFrcmF2YXJ0eSB3
cm90ZToNCj4gU3lub3BzaXMgZGF0YWJvb2sgcmVjb21tZW5kcyB0aGF0IHRoZSBob3N0IG11c3Qg
c2VuZCBhIE5PUCBPVVQgdG8NCj4gZGV2aWNlDQo+IGJlZm9yZSBkaXNhYmxpbmcgQUhJVChzZXR0
aW5nIEFISVQuQUg4SVRWIHRvIDApLCBpZiBhbHJlYWR5DQo+IHByb2dyYW1tZWQNCj4gdG8gYSBu
b24temVybyB2YWx1ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1yaWdhbmthIENoYWtyYXZhcnR5
IDxtcmlnYW5rYWNAZ29vZ2xlLmNvbT4NCg0KSGkgTXJpZ2Fua2EsDQoNClBsZWFzZSBkbyBub3Qg
YWRkIGEgcXVpcmsgd2l0aG91dCBhZGRpbmcgYSB1c2VyIHRoYXQgbmVlZHMgdGhlIHF1aXJrLg0K
DQpUaGFua3MuDQpQZXRlcg0KDQoNCg==
