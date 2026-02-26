Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431253876D1;
	Thu, 26 Feb 2026 03:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077516; cv=fail; b=mGn/GIB9ax0o8xh0P5+eU4W7eESlzXPbUsGuQrbkLwetW0k77D0WCHZ11raWPwDpMd3B73PmwW6OFucZ1CyT27nk3LIvgNRXpdze5SmSaAVDgJAtEcDKhSxpozpsUp4C6fqhg+iA5mMHSw0WpRI8z/a79JDB67BY2xZ72ARA2tI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077516; c=relaxed/simple;
	bh=R47lpp6xpVpoJVL2AP9SP8AvULtWnA6MgVSpZrfshQM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=anRvjpuXGK30ygxroHpEujM1tLjfKHXvFGz3Httr8lCGiM+9Udm6VlecRdLxsLkBlqZ0aWnhzbqqx60fAkBOATrAex8GVIJUZZ4mFkh6XxgX/tvXcExB7NZvyDqtlvH9GZcwd3CAnnDhK9fpAjmpt3uqR4mXIdZlitDH3iw5NoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ivJ2EVOZ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Hf7w7O7d; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ivJ2EVOZ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Hf7w7O7d"
X-UUID: 8b734a5012c511f1b7fc4fdb8733b2bc-20260226
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=R47lpp6xpVpoJVL2AP9SP8AvULtWnA6MgVSpZrfshQM=;
	b=ivJ2EVOZXzioJGHkct9kltDDlT1lG/gqhYJR6S+iq5X8nPMt451XksmDiiOPeXp4Rln7v5vB7tQzvb4A4bBu3N0u1QQ9pdxmkpWQhPDQ/SGJMpqWGnikDJZpGWwtZKgPHITRZn/PLFSq+dgCnO0SkFXZC9TGAGsuTfoYXV0+0t0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:26175f27-32a2-498a-b4ab-20e2fd05cd10,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:49ca05f1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8b734a5012c511f1b7fc4fdb8733b2bc-20260226
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1918422320; Thu, 26 Feb 2026 11:45:08 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 26 Feb 2026 11:45:07 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 26 Feb 2026 11:45:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pb96i7dlgCo0Orx/EnyknPo8p/B9Q/Dhh6IOF5xFvROMkrQThtGwMUSTZfafmNsJ593Yc76lbnyfMfpiFnoG60Y4ez8dzo/VF9JkETfp95QdU+sN5YWLzIJTO2CXRDL/fotIBhLKtZScE/sFJmwGAsQtnOhpu6lSg6WwTYsor1uKkbN3ZvZL+lH+A5vAXSIagrBFi12IClFLOReXM9P4ikLe4Y5KlTx3xQYqQ8t/iNVV7HoiuEgzaGLoOz0Yy8ZronsnNtGIRODAtswPrqwqFbVX39RG4QW6b/haKM7Jc4b7dmPk9PwlmHSOBRHwLWypoVkJeUK4XjPh35HVgsgWmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R47lpp6xpVpoJVL2AP9SP8AvULtWnA6MgVSpZrfshQM=;
 b=KG1q3LspNgrfPV4mjorzYcJm9B6isXqcCpp3PNuqidKSa85tYQajstzbrw3jfwX6e4tQyXI8LA7jvmDrfbuxrJ47YYxddoGTJvhAq6yFeKJrdJ1Zi7IIp7+7bIKQPxS0j65c8+yzO55Vb89hepagWLRW27uQEbodvzK5vldjGi4y8K4e0ABiJgVbRheGITOkoSfyFmGaWADZvFjgKCJjnPuhESP6gNj1x0nTT1Qx4eESuv0A9qAxU2vPuM3mU2mJjpmE414FQWtMC4/4ebvc+z6g6FTLDN/WT7Tw8ZUHjh/ZAoVUjrPgeOQpvgClkf/wy1K0wrw4XGyrs+H77NEJIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R47lpp6xpVpoJVL2AP9SP8AvULtWnA6MgVSpZrfshQM=;
 b=Hf7w7O7dWLtdNfKPubYpZM15M8hluNgCqZkAeXWQSlBaEb9qlp6wDNxgapeWYbo8X2BGUF6P3CRTnuKZ/AGZlj1V43df3M1iyZ6tZI5mn9CTZRiT8vbD5XrYUz6PBf64Kmu0O144gxTbTD/KO9E8xHDHMh51WDlXF/6q7TUqWik=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7060.apcprd03.prod.outlook.com (2603:1096:400:337::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 03:45:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 03:45:02 +0000
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
Subject: Re: [PATCH v7 18/23] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Thread-Topic: [PATCH v7 18/23] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Thread-Index: AQHcn0n0HrdpPO0pSUqq1c5Zt2tyIrWTRfIAgAAigICAAP2LgA==
Date: Thu, 26 Feb 2026 03:45:02 +0000
Message-ID: <c7214effa728b74e753abc0dee8d655e036ca7fb.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-18-b5f2907c6da7@collabora.com>
	 <010d77378b9cca477439b92d92c8f5bfb2d4df65.camel@mediatek.com>
	 <edf07a47-77be-4acc-8825-b14a5d1838df@collabora.com>
In-Reply-To: <edf07a47-77be-4acc-8825-b14a5d1838df@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7060:EE_
x-ms-office365-filtering-correlation-id: 282d0a70-1304-44ff-e1c3-08de74e96c0a
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: RvU/3Rcwuqr71U9CYdg/y2leb4czHKEtw7FBq7hRdVlC1NkSAL3hR+9pY6OL/etwfSfYNT4HjEF7NAj8AjjLJLjinHMKPuiZep+GMSl586HH4NKCbYm+O17xlP9n6GV1BwdsLWf8DQR5fVHHsMNjIeuISsRnHUm8AjOuw3atNAge4b9sxUl42hygfoDod0GutTQNZ+x2vN+PH2U+Hh/LRvwvx9M3UrQPuLNCw//3Mct6S82eCzv3hmwz/0izH3Gwo4Frb5Nkmt7YMDQuBBJpanlvpeaYwca0m3tXHMn4tGb+8Y8L1cm/aL/DiVRdkgR+DllFYaPUt8Pn+mWmkzNPNQ1fT0j5i4zO/dIIUKVxYHoUBJVAChb08k0n8DADn0fsF5Hl9nENQ9MHikn0eMEsK5A0DqnDGSsSYz3w187bmFWRsqfwLsjSLYSH7pE3MFBGry4R5wlnRpH5vd0EsdI0b/weyveiaCJrVmEZx8i4votlAY+7+yTr3u8Ei8bPjrxVMGYTGleLY/MR8+OGQ9lDAc+SzDh4ipRANzLOU6Zm+vqfNkr2VIyST8mooiMdWZeS3oPRAIbn3qT399Jm2Uznkfo701Ttn67Q1Bx1sy76jAwilfbBQzLToazEiTEtJhE9ysvuTwHiOAeYqtkX7ne6z9E9t310qZyF9SLndnzwfDpPf+2cIUOfyM3qgOTw6zVv77TurbYwRYe1Plx50d/oDIZog2MG5K49SRnXvy2Vcf6+uEo8bBXM0wBYNiR4tAdXkf7FYzogE1Cu6jchrXeGjkPaXjcOwW9mZ/raQtn45D8ZVWmzhfb75tC9aTvZk/ff
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHdPbGdtTjVTMlRTK2R3M2VVYVRNMWplWFY5UjhvTnpXcm1UaGNYRXNsMTZG?=
 =?utf-8?B?ai82cFFld0JscHE3VXpzQTZZUFRtOC9ISnErM2xsQU9WY3dXYXVobzdWVmJn?=
 =?utf-8?B?dkNJVTVEbFBRSXo4MGl5azdqZXprazNqejdkWTVnZGNRZlQxVCt6c0gvS3pl?=
 =?utf-8?B?MC9hd0pDZGN6bUxPWFVLcnRFUEFXUkVYN0ZVcjA4a25BNWlJRFR3eXQvVitm?=
 =?utf-8?B?R3VLdThkWUJMaFAzL3U4UVJvYTloNkt3MFlsdFZIVTJ5TS9WaUlOemZhZkV6?=
 =?utf-8?B?WEZxVTdHeG5xeSsvUG9kR0pjUUN0c3Bsc1FuSm8yS01wU2poUUsxcmI5SWhn?=
 =?utf-8?B?MzMwanJRcHROcVh3TWc0MVdhV0h0Y3JNTS95OE01NXFtQWdPeE13UlJNb2Fk?=
 =?utf-8?B?Y3l1SXJnblhhVER0UzY0UmJFeWU2S2FvRFpidCthT0NTNVhTVzhJNTc1d0py?=
 =?utf-8?B?SWlyQUE5NlRyb04vRlFIMnlISTZBOGhRN25IWHlqQkR5MWxta0QvTGhuODlq?=
 =?utf-8?B?bEoyY3BIUUNUM1NnZ3dlb2xuM3pFRGZJYzZwNGsvRUplVkVmQ3FlYkNDYllw?=
 =?utf-8?B?QThtU2tQODVCb1R2WXFNRCtEd2J5clJuWndvMG1KVDhrM1pScHlLME1ST3hK?=
 =?utf-8?B?Zll6TnBpNGRrZGp2eDJ4SmFvYS8zamRlcXlMNzZURmFGa1dodDZHc1hvNVNy?=
 =?utf-8?B?YnU0cjROUmpEa1ViQVZQN1lLR1l1OG9vUUNiVVNFOCs4dUc0eVhvK1Zldlkv?=
 =?utf-8?B?Tm45TThkc1NxR2RLYjBtUjZjR0txNUo0cjFRM3lnMERIc0l3VnNCNnhsNUl2?=
 =?utf-8?B?QUdOZGFFRUlrNU5sNDVGQ29nOFNjZDBOR0ZuRFJtNkhZRjZzRG9hYUVkSmd3?=
 =?utf-8?B?MVh3ang5SEE5M2JQQnhVOW9wbXBjakZiOUZkVHlqa1BleEhkL2ZDY1RLb0N2?=
 =?utf-8?B?Rm5BamN3U0RVdmZ0ZzNwNDhBbEtNM2ZYVVBJWG5VVm1qd25Ba0xJTm9LK290?=
 =?utf-8?B?a1NkQ05BemUwQXkzR21xbzNPcmJ3NWQxUGYzS2krYThyN3UvTGFSY09QaUFm?=
 =?utf-8?B?dEluQmV2ei92ejVZOS95T3hBVDV0WHdLd0hvY2Ftd3htUnBjR3NWQ2tyYkJr?=
 =?utf-8?B?RWg3VG9IMTdOOEx1dS80ZlRhOE1RVnluaHRDSVJDUmo2Rng2eWhHU0VtRUNK?=
 =?utf-8?B?QnZ5a1BtUEczMlJUWGlBWlA5SDNMdkYzY0huUXVjRTRpR2laMmkydC9HMmVV?=
 =?utf-8?B?TTVvKzBZcmZQYzBwa0hjRytaZURNOGM4ak1FNlJWY1ExWnA5dWpIMHNKOTVi?=
 =?utf-8?B?TkhadlFpRWEvYlp1UjBTR0lWL0orZGloR0pZR0RMbGhsU2hvSFZHTWxWS0d0?=
 =?utf-8?B?SmFnL2FURFVjKzdMYXREcTVIVHRIaUxSZDU0cng5VGVjazRMOVlOaDRHWE9y?=
 =?utf-8?B?YzQ0SitFVmxkTmpmbVRqaGVJb0w2WFM5VEFsZXFhUjV6bTlSaG1CL05FLzJS?=
 =?utf-8?B?dUtSdDZzSUpCSzl5bHFWTjBoaGhsU0ZLWTJnaFoweDJDQnk1d085UW5mYTJS?=
 =?utf-8?B?VEEyYk83VHBLM2VsUmN4citDYVU0NnpPYXZpa09pUGlFdEx0bHNBaHlhbkdv?=
 =?utf-8?B?bHB5ekF2SFFDL2tIZmJ5U1VETTcxbVJIWkhYZ3k3R1RtMmFKWEN0UzFUeFgy?=
 =?utf-8?B?ekt6NFRQRzI1RWFpdGxxWVFhQzZ0S08wb3h1WS92dVlCME90UjdKeXk1Ykky?=
 =?utf-8?B?a2ZSQWVrN1FRRmwycjIxMzNKUW1jMmovUUZMc3phR0ttd3lvTW9MemIvdXhD?=
 =?utf-8?B?M20zQjVFSnIrU3YreGFzRGVTb3FTVjFIMU4vZENRSjFhTHJqSXhzUWJkb2pS?=
 =?utf-8?B?R1VlL3JmOXdVak1CMlU1bjY4UHdFcHlPaldIK3gvb0lNZjVPbnJ0RjdHV2Zv?=
 =?utf-8?B?a05ZR005Ums0K3kyZVpMQk4vNEVuWGJkVEJDUEZaNFA1Y2NMOTVyUzJwbG9k?=
 =?utf-8?B?aDYxTUV6eGs0SXBsTVBWSUYyTHhMc0N0RWFYK01WSGVNdHU3d2NEMzZFMU8r?=
 =?utf-8?B?ZUhpQmd5elIzQ1lNRGlsNlh5N081b2ZjWlNpR2RkME5ZMXhzNW1FVUtHd3VL?=
 =?utf-8?B?MzRvdXZoOC91YWdRaE42YzNpb040L05jdENCMXBWS0Fyem05bzgvWHNPSHlr?=
 =?utf-8?B?V1p4dzZIZS9CUFJlZXRYL29OcWFQL21SNjR6OXpITGFKTFJnVFZhYmJ5UjNC?=
 =?utf-8?B?cjJ5MGFiNTFBUitDQ1ZEcFcvMUFYREpaV1dLbytxQWhHaTdsRzVhd0tWV0xZ?=
 =?utf-8?B?ZHhPV09obnhsbnVnczk3anRCS0FnYVAwRTlBYU0vbjdrcGJsT0hJS0YvRVdJ?=
 =?utf-8?Q?nVizlS7sCLlRhscI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A80681F9007BEE478E1DA5F2727DB3EB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sVYem31Nqs+DBEyzjlnVRz0iLhlhQ69kXD2i6Ci9rvUUGEygvq7gC0ZQ3JM8NzMhbMli4CIEtWrvq3GKGnfg/LWHn6wY04I0G2pKwR42Vyy9CkGqbTO4ynXmPA/ElaaigsL1cKEjUHeP4KzvIL1+C7skPnIRiQ4B+ftLIz7CWnoXmnRArQknkEAUnOpnnenX3IfAd6/QnUybcLvc9O6ofyiCEhXcTQEzZASPz0ymCynMIM1+fA1XZxawojCn/TWkk++cwLnQquoE8Bdijc6o4/njbK/sJiItXEKXWel4s1ga+qOIf5l1fm2bb34LaogaYbpN9JghEk5we7i7QbOGIQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 282d0a70-1304-44ff-e1c3-08de74e96c0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 03:45:02.1553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jNo7jNYlZFNs/zz6oBuKQe026ykHFnqP0yMQU4fwuK0XtqtAgt9OqsDJm5loCoTbTZsK2msqs/YPspj/ohdYzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7060
X-MTK: N

T24gV2VkLCAyMDI2LTAyLTI1IGF0IDEzOjM3ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gV2UgbmVlZCB0byBjaGVjayBib3RoIGJlY2F1c2UgVUZTX01US19DQVBf
Qk9PU1RfQ1JZUFRfRU5HSU5FIGRlcGVuZHMNCj4gb246DQo+IMKgIDEuIHJlZ192Y29yZQ0KPiDC
oCAyLiBjbG9ja3MgKGNyeXB0X211eCwgY3J5cHRfbHAsIGNyeXB0X3BlcmYpLg0KPiANCj4gRmFp
bGluZyB0byBjaGVjayBmb3IgYm90aCB1ZnNfbXRrX2lzX2Jvb3N0X2NyeXB0X2VuYWJsZWQoKSBh
bmQNCj4gcmVnX3Zjb3JlIGhlcmUNCj4gd2lsbCBpbnRyb2R1Y2UgYSBidWcgdGhhdCBtYXkgcmVz
dWx0IGluIHN0b3JhZ2UgY29ycnVwdGlvbi4NCj4gDQo+IFNvIHllcywgTmljb2xhcyBpcyBjaGVj
a2luZyBib3RoIGJlY2F1c2UgaXQgaXMgKnJlcXVpcmVkKiB0byBjaGVjaw0KPiBib3RoLg0KPiAN
Cj4gUmVnYXJkcywNCj4gQW5nZWxvDQoNCkhpIEFuZ2Vsb0dpb2FjY2hpbm8sDQoNClRvIGNsYXJp
ZnksIEJDRSBzdGFuZHMgZm9yIFVGU19NVEtfQ0FQX0JPT1NUX0NSWVBUX0VOR0lORS4NCg0KQkNF
ICAgICByZWdfdmNvcmUgICBBY3Rpb24NCnRydWUJdHJ1ZQkgICAgSWYgY2hlY2sgaXMgZmFsc2Us
IGNvbnRpbnVlDQp0cnVlCWZhbHNlCSAgICBUaGlzIGNhc2UgY2Fubm90IGhhcHBlbiAoWCkNCmZh
bHNlCXRydWUJICAgIElmIGNoZWNrIGlzIHRydWUsIHJldHVybg0KZmFsc2UJZmFsc2UJICAgIElm
IGNoZWNrIGlzIHRydWUsIHJldHVybg0KVGhlcmVmb3JlLCB3ZSBvbmx5IG5lZWQgdG8gY2hlY2sg
d2hldGhlciBCQ0UgaXMNCnRydWUgKHRvIGNvbnRpbnVlKSBvciBmYWxzZSAodG8gcmV0dXJuKS4N
Cg0KVGhhbmtzDQpQZXRlcg0K
