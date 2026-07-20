Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEEF3CB56F;
	Mon, 20 Jul 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538880; cv=fail; b=H3oFztz2TZGdF7QZhDDpvgOav6xOg6CkdPdh29QKfgsbMrNs/CKIM6A31sCrb6ILul83W4TcWhl5AG90H1XWglxTlZzOvMo7O6sjWz0iHIsl1rW3YDK/zYCgNmUMe16vqY8Wg6DxsLVabmGJIrJjaqwDDva5/d4QVy7iXHR8EK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538880; c=relaxed/simple;
	bh=CxFRkG7td0i7LgVOW7GOfdXZoefb0Mi9mTBD0t43cg0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qtm3PCre9jX81ykG+ZNXYpj7hXIyX1U2TbTnA2E4kdE8McRFf8+0wa+/9MrbZhURAS/X5yuqXzlNG+GUlKGpej5XmqjCoAjG5q6peuiUp6YXnP5GVEmh/zy97ILgdLq1cWflCJ5TSHhklr/zlu8jMkJqmOkKMIiKsBYYb1NM9Xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DmuTcjL5; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GbMjFShi; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DmuTcjL5";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GbMjFShi"
X-UUID: 694630b0841b11f18dc8c9802ae25ab1-20260720
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=CxFRkG7td0i7LgVOW7GOfdXZoefb0Mi9mTBD0t43cg0=;
	b=DmuTcjL5GF7LZ4pj0FSJ1Qt6KR9TKSA/dMASpYhE/AjYxSki3HH/c1udp8osymlQRn6QtaewDZ4dg2Diebd8BO9sxeUHwkMWH2V2zVFmx9+bm/LunreIiHcvIGnxqIdK3kzFfwDYHYzMyatkegvtcfNgKJMNbHvPhhDmF8xPHeA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:f2a97b35-4b87-4d81-8cdf-e46f2f7fe4fe,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:9c73b15f-762a-4584-baab-4eebe609beea,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:
	nil,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 694630b0841b11f18dc8c9802ae25ab1-20260720
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 531025350; Mon, 20 Jul 2026 17:14:29 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Jul 2026 17:14:27 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Jul 2026 17:14:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNQ61K0EpqmLbQ2l2GeqTGjNVwVZjv3TajEOyP3jtJURFBS84xDWp5qw3oiUsW77duOsFsTI+4sNTioCHu2/hglaEMvcdMycqRBCXqFsdn5JX37BxNzqiawAS2qpM03GZmHRkHC6o80BY1qRaETU3QgwnGi4gelRIMKToAsedi/HTMck8XcxbH6zklsY3ZzFmVUWWSDb3QwgYfO4BeXinZK1R5e9llJgc6+zvayc4KWMB6vkb2bjighez2Iuo4rKg7FJ8dAAqFjCMlwJLtTBvvAH6F7cv+YMXlmnRYolPkDcvazU/KIqaKA+1o1ZS743k+1t/6qbveY/P69gLnHx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxFRkG7td0i7LgVOW7GOfdXZoefb0Mi9mTBD0t43cg0=;
 b=LR/+J39S9su9mD70nYa1PL8f4xtN7Uxa5PNy8nEpAFWxY926eztZmh7NnXz4OuPk02l27eWDxJeEuLV61gDp/JmCaTyq3wnsmNiOd+h/F/VnSVtPIVKRkDg6xe3Qrm88mh9xcr9ZWFdsOQ7Lr8nINdFZrdsPTqhNr5B32Dv+SGMwUYPa9NZHpECZUFPsc9lIAkHCVYrg9Fbz45uPDRSIEQCCA2EDm9B9L034c2wZOuQ+j1Kpg0BXjAHD/FW3xeaefPEz+uZYx8DTpjOxcO9AE+Z0PyiBzaPWrfPBl+KJTiy9mpr4mFT8a6GrhbmUSNLXmpWvRAelQAEBqD469ceJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxFRkG7td0i7LgVOW7GOfdXZoefb0Mi9mTBD0t43cg0=;
 b=GbMjFShi+iao+DzMESEdZ3FcCxXDufv/oQKt9P6AOwLj8jB7yssFrPS/UM/OcWr3dRSFWbtfd+T/412HZfeKpO4GHqeybP8vIVcGYIMPRcclDEk9rYnP2LwvNlqe05K5vLLlkBYFStk3OWZtubssl9d0M1Soznk/ssYhNntqbM4=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SE3PR03MB10511.apcprd03.prod.outlook.com (2603:1096:101:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Mon, 20 Jul
 2026 09:14:24 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%6]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:14:24 +0000
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
Subject: Re: [PATCH v2 2/6] scsi: ufs: Avoid NULL CQE dereference when
 reporting invalid tags
Thread-Topic: [PATCH v2 2/6] scsi: ufs: Avoid NULL CQE dereference when
 reporting invalid tags
Thread-Index: AQHdFgKMq7zGv6mN7kuSkF0x+vAIXrZ2JEoA
Date: Mon, 20 Jul 2026 09:14:24 +0000
Message-ID: <6d48ed8f0966f372219da56663354dcce48f980c.camel@mediatek.com>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-3-liqiang01@kylinos.cn>
In-Reply-To: <20260717153914.26321-3-liqiang01@kylinos.cn>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SE3PR03MB10511:EE_
x-ms-office365-filtering-correlation-id: 5e0d7fb4-9fb0-4bdd-9b60-08dee63f4afa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: pSbUIwqxPM59E6/Ke83EP8Gcq0KnjuAInEc8/LrSIA2cQA/uU643wu9jJFdVtn9bB4adNvcjBG/L5F0v54QLTi0prA7mYNNEeSUijWmTaPJsWuqiGucW7Soj8gofFdSPXcBj74Kd3mqfl74ojXHzPm2bjvLl0NkYnONViNXgvnZd8Astxi1ri74ZsPIz0g7Ozk3EQ63439QXkk4znm5VRlPpS45m3I43jhI/Tv+9iXpHkzuCP7O1IJ64aRjTw+zIUmgWzlK9xy76HM/KCnuiRLP3lNIarwQILf7a4Q0Qg9yTUaS+RIyJk2Dn+TVKi2WmMTwRqY528ywIvpQZD4m4T264Jbh+5BxSFiKcANaVm2n6NeT95CRRZhGbMDKmC/yZ7LEa+EuMWwiSiljy0IfycQgxiRSiApMDPgQ9Hk2ihylK/Y7qvD83TbTZyUZzZLf4O/D5RWSSsKYUIzaeyWaHPtoh74CVU/cTo0HFQW9LUO4dK2TafELZjvfo0Fja4TdZSc4Y/v/pz89SELLxqxY5p14bj9xlQLaPODB4++g/bcCWhpb+8zlE/mvcr2AuxOm1T63/5mrvmrTt008xUEtw6v8HcZg1HPlvIOTifluMVz8ZzWECzhOF4TfScu/zK98YY6GyFSn/NTH/ajQaYUpRWM6onyIt8GOEkhBCdsx6jsc3XH6xeKOm+c6J7ANVPAK3vsQQ30qSqXDYGGMxOHQ9u4zh08KiYKbsy31KP61NQlI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmpSRHhZQVJHSjZGaTJ2cGFOeHEvTno0UTNWZG1oMlZGYnZoKzI5bFBsM1N3?=
 =?utf-8?B?dHJWeDdZM0pPTGFIWjc2RlhZVWdLSW1MMDZsV2VjT1RUck1pV0tFVVBURnNr?=
 =?utf-8?B?SlFVbDlVR2gxSzNuT0tWNE8xRUZ2V3plWW4xQktNUzU5Ty91cVJNZ0FpVDh1?=
 =?utf-8?B?dlBoajhDNmdSK1JyMERJb1EvVk9vUmZEcGJpbzBxRmQ2OWZncStZNWN4aHhK?=
 =?utf-8?B?S2pyQy9sejk0YkVtUDloNDQzcnc3eVRMMzhKbUNwTGRqTjlHaFE2cStBejZx?=
 =?utf-8?B?cDlvaVgvNm1pdW5Lc2VTUERQY2czV3F0OHZBMitWNm9iT09uY2hEWlNCb282?=
 =?utf-8?B?VzAzQ2xhZ0hMQm9OY3Rqc2RXQWQ3QklHRVZlZ0NmeUNPTGxaaUNZdW5oelZr?=
 =?utf-8?B?K05QUUNhclJlZ1NkeVQwanh3L1p6cVlheWpxL05teUY1WlFSWGZGL2hqS1Jw?=
 =?utf-8?B?K1V0ZENkSVBNcDl1bWQrLzZFaXdWeXRyOTFPQ0sxSG1RSUJlQjcxeHBxOTVq?=
 =?utf-8?B?cFdmUnEyMitzbUJiRUw5SjVRKzJUMCs4VTZldkt5dEhBOGZwcloyRHRBaVhR?=
 =?utf-8?B?R3lqdndTenZGRCtORHVSZnExN3Q1UHlTaHBET2x0V09rd2V2dmtBSk03QnR2?=
 =?utf-8?B?UVF2TG4zWlJFdjNwUUlaTXczZVdEVXAxUDE1ZC9qaU1adSt1VXdDMXBMdWto?=
 =?utf-8?B?NlZPY1RBa285eDE5RVZmeWlvNFFGVVZXclFFR2FiUHBEY0ltTW1yZ1VHdlZu?=
 =?utf-8?B?dFd1TDVWRWF5ZndhbWZ2WnNwZy9MSnhEY1lUWE03YmlRT1JKYzZBZ3FkcFEr?=
 =?utf-8?B?ME9FR2ZFMmRENlRuRDNxYW4weGUwSzk3MzRxK21sL0J6MXg4SUhKdWlrMlc4?=
 =?utf-8?B?b21uajl2bGZxU29yQ0NDUHEzZ2kySUVZaUhTaWkxa2U0K0s1eDhVZEVVTzRR?=
 =?utf-8?B?N0d5L2NyYkpxYU5QcTlyWk92NU1vRHMyZk1HZFJYNDdxMWl4YW5vYlBxdGY3?=
 =?utf-8?B?R051YmQ1djAxOFpWL2RzMUNmZmlRalQ4ZHk5Qk9VUjBNTFBzc2l4bjNQWHJQ?=
 =?utf-8?B?Nk8zcWtVVjdFeXVoYnRackF1dVlpTjFGSys3SmM3MzlPL1dLaGk0c1BHNmNv?=
 =?utf-8?B?K0g3ZGJOOC9pU1phaUlMZ002S2Vjcm55ajFGMEs0UHI1dFMrK1FkSXNGUkt3?=
 =?utf-8?B?dEtKaWJkUzFOUE83WXh2cW5BRjVxYWREVkpHYStsVVNvNUtmL1FLMW5vY2Qw?=
 =?utf-8?B?R3JmUVpVRlhvVjZXckYxU1A1eVFMZ2JoV3owaUhpNWZQWm9NMzZIc2tYUWxO?=
 =?utf-8?B?elZqWmFaejNoSU1iWlh5VVFGRzlGcWt3T2FiK1NvbU5NNmVqbEQ3Qk1NZmwz?=
 =?utf-8?B?ajNRSXlsQklMOFZ3dFJNNUhHZ1FxV3lZNDNUbjJuUHk2Qmh3Y2NLOEY0T1Mv?=
 =?utf-8?B?TVpkWTQyZTUxQ1Vyb1AxK0JsNTY4TlRKcjR4VVo1SE5nMXhFaHdVQkVQS29s?=
 =?utf-8?B?ZVoraGg5S2hRV1o5ZldxRmVEMmpDMUo0THlrU2Y0dFltM1pXbkpobFhrajlr?=
 =?utf-8?B?M3EzbTFyeWhHSDZObmQ2dDM4TEpxdHFjajhFL2g4c3hrN052WDhuN2pjR3Rp?=
 =?utf-8?B?MzhKWGg3Rk1DWE9NeHl5cUFBWHZySUYxWVFRYlUzUXpwd0pxajJSTkUrbURm?=
 =?utf-8?B?YmhybDF4Ty9jS2tHZm1jcEZkUDJmNTRJbm5HemhockJNS2ZCbEhNOG9ZNUxp?=
 =?utf-8?B?N0JmbkRVSVdWbUVmVHRTM3FnVzdKbkZJcyszZktZMEhUeE9zWUtvay9mVGY0?=
 =?utf-8?B?UWxFa0R4RWdCWTMwK0d4a3dGUHl0bGoza2hiN3k5MnhNYzZ0Q0dhbmU4L1d6?=
 =?utf-8?B?SmlZd2VXYzVjVFEwMHhwL2tjTFNXUVhnZDQzbTMvbWl6RGNlQmpWSGduYlJa?=
 =?utf-8?B?M3JmZDM5VUZvZkRjb3VCTHNoK09zWk9hUUN3UmFhazVRL0FKbmxFdU91ajd1?=
 =?utf-8?B?UzJBVDZXaEdoUTRna0NRMFVyTXplK2NFeGF0cnFaZ3lZa3hleFdIT0xSUWN4?=
 =?utf-8?B?SGl1MWk4N1VCaFk5R3RHdHlNeHNLQmMrUHJmZDJoaFRuMHJYcjF5N2VqNTJ4?=
 =?utf-8?B?eVUxd2twQnhha09qWmNOK0h1N2dWTlhZbnVsRnRVM25ra2o4eFN1SWtaSUhi?=
 =?utf-8?B?MERJS04yTk5Jem45NlVzNjFEcVlkUk5QT1hXZWJpSGUwVU5TdHpvYU42MEtk?=
 =?utf-8?B?VlFXdVg2MWNPNCt5dnp0R1lDa1IyWHRsYWdLSFRySTRuMEkzS0lJd0tsT081?=
 =?utf-8?B?T0tleGRUYlk5eDIvSlZNKzJoNkFvVkpIaDRVTzl5Z2VhUitqdEdNc1BFeVh4?=
 =?utf-8?Q?sgOcza6lTPxjxhuM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8836CA88ABF3774EA1BC1F741DF3FC8C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TnTC0v3CA8Y/89yozzOwdU0BDjHPIqqy42+ogsBZNECV4to7O5MhDDZ3pQIp4s5KvN4I+e/Uj9VlAEVQp+v4ByiL+OuNxkNHrMZtn55WONCXeZvmP1pMG9EdIwrbOD8YceNH0BdoLjpmItEx6G0cKpVY6a18faousplTkKFM2EOe5PFHHhnkF6+zZHQJaoKiJWEvFhkhlOUOAU9Mw3rNK3pvhrvOa/EN70Cvq9PJQe4uzKHqxD68Fg7gHIXdK3TokiG5dMHkSUp393F+58H3v9A6lj65EVU6ZV9RHEaPyoFwhkBtrlTKo43JA3mV/j+jFjsFrwqJsdOtvmgjEyFUDw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0d7fb4-9fb0-4bdd-9b60-08dee63f4afa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2026 09:14:24.8167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oaJh+nLPkkR+cjIeFdkwJzt4NkFjCbqpkF7Caq9ur8cWUh/F4Y/vY0+Uj7FIJELCv08xKmFfI+LpZqEWg1opgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB10511
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDIzOjM5ICswODAwLCBMaSBRaWFuZyB3cm90ZToNCj4gVGhl
IHNpbmdsZS1kb29yYmVsbCBjb21wbGV0aW9uIHBhdGggY2FuIGNhbGwgdWZzaGNkX2NvbXBsX29u
ZV9jcWUoKQ0KPiB3aXRoDQo+IA0KPiBhIE5VTEwgQ1FFLiBJZiBubyBjb21tYW5kIGlzIGFzc29j
aWF0ZWQgd2l0aCB0aGUgY29tcGxldGlvbiB0YWcsIHRoZQ0KPiANCj4gd2FybmluZyBtZXNzYWdl
IGRlcmVmZXJlbmNlcyB0aGUgQ1FFIHdoaWxlIHJlcG9ydGluZyB0aGUgZXJyb3IuDQo+IA0KPiBB
dm9pZCB0aGF0IGRlcmVmZXJlbmNlIGFuZCBpbmNsdWRlIHRoZSBpbnZhbGlkIHRhZyBpbiB0aGUg
d2FybmluZy4NCj4gDQo+IEZpeGVzOiAyMjA4OWMyMTgwMzcgKCJzY3NpOiB1ZnM6IGNvcmU6IE9w
dGltaXplIHRoZSBob3QgcGF0aCIpDQo+IFNpZ25lZC1vZmYtYnk6IExpIFFpYW5nIDxsaXFpYW5n
MDFAa3lsaW5vcy5jbj4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53
YW5nQG1lZGlhdGVrLmNvbT4NCg==
