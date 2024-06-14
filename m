Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477D565C;
	Fri, 14 Jun 2024 06:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718346767; cv=fail; b=DgYBfLPM6qpQEawmm9vqKrJI8Jh9rLPiBLnVA5yqgNO5+x6qTkpmoZ4ayMMmGfL4cFnQEtJc1pR7B5Kl2tSnQ6NNToXnhbd3havMLp/jOXvlgPzMVSkCjl8cGOkIYcUnxUN+vDGd+OhQ0CE4mo80dtq0wC8vKX8byJJzT617T6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718346767; c=relaxed/simple;
	bh=HEr9dIVb307ki0FaCZ6NRXPRUIlL2WWWJgZxncJQpb8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nSyrBuZeVhyu40ZzLXJIcFHmprNyXeSROnbDjdPrV79qqcY8SCJUTzXySHUx1af7yVzvRBAm9gWZAP1Sx7DxDSz1VCAgZSvwo94ia4Yb1LSSCmpYzkJdPpjJH6fTAtacPZli2yCcycLcFlhC9eucbW97qLzG6I2yQxj75+vdEVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=q0QO4wt+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BncB7ZyE; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="q0QO4wt+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BncB7ZyE"
X-UUID: e6d92ca42a1711efa22eafcdcd04c131-20240614
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=HEr9dIVb307ki0FaCZ6NRXPRUIlL2WWWJgZxncJQpb8=;
	b=q0QO4wt+Cu9SSDbiDwOs0+DObWql4jB5gpMnTyJ3aw/DfyVW18ZiBPr00f53rqkLS17pEqVnbe7nY22PddD8qPU8wwrV4tPXxtPsVN/k5DuIq208H2HoTf8ZyH3HDUDsuAvJJ13z5ln7UueOgqj+VJv+harW2YEQYeT3gD0NrcA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:db684caa-98f9-4d86-821e-942a03739899,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:7a51fb93-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: e6d92ca42a1711efa22eafcdcd04c131-20240614
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 128319270; Fri, 14 Jun 2024 14:32:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 14 Jun 2024 14:32:40 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 14 Jun 2024 14:32:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B60z+ntbgbIoItzwFfcAZ29r/2k76x1AUf4gMeaKUKBwoDmNSD3cabEvO1d1aCMzQtcnAm0aLhMk4tKIeXb1hIcMcKHXDazslUHboWoY0hvjxnqQFblND0Zr81nmRXxLpMyebq6YJmdI4gQo4yrHm34dzf9CsgcJ//gsfY/U6k/9jj/O6ZF0s9EOV74VGlch/gEQDl6+efjRuWOlfsIxNF13i2TOwX6AQi3Jbvzp7uam+6ETtbudfv9oHuvFGdjS0Cps2cgG1QE0T/sv1DyBLDB7G/gRTpSQji5ASX9v6evYMqpsfxE92HeWfKy/WFQHalzhPdzkHSSGKNkyfsctgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEr9dIVb307ki0FaCZ6NRXPRUIlL2WWWJgZxncJQpb8=;
 b=dVlESFir3P/X0iKjDf6Z4rb5TgYmcwQoRra7f2G2CHBitGcNvHdP2tbOy24y52E/Ui8TQA7a8G9Q2aNlFu1LkQn2RfeQOdktjDXbs1HQyx8vC7zSzfmEoTT8/4Sc3N98sHCgW7WNpyu2PLcNeDXNGItIvW998V5FIkK8ZZ+SEV79iS0sJ8cMVRg5sVzUuBWPFyi03bjlGis6rIjXOjIKhKXbu+WaYe4IqdIOgF2ccDkOR6nWLfD2sHRAUJfPPkX1P7kIMu5FA3r3vNZZYWDNsWn/kjZVVlRBbIUVqMOwkx5BIMBP7nuAZynySBoQlKOqF9qqp9RJsXLyvmS2+msD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEr9dIVb307ki0FaCZ6NRXPRUIlL2WWWJgZxncJQpb8=;
 b=BncB7ZyEg6nIrixtUttIcv74bLT1K+3IPf4rQGM1uMn9UD2dMV4y/MX0qsKZ/jEkfQk4pFsmbaM3UT6lOPxbwo8EUWqJHQzY2aAg/Q1WDGKoZzLui8svk0UwDN22Ynn7/mLX4fw1tbxKvAlcGPa36gsJkJGAw41Rt0J+eMRCuwE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6597.apcprd03.prod.outlook.com (2603:1096:400:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 06:32:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 06:32:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"wenst@chromium.org" <wenst@chromium.org>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "conor.dooley@microchip.com"
	<conor.dooley@microchip.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "michael@walle.cc"
	<michael@walle.cc>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"robh@kernel.org" <robh@kernel.org>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>
Subject: Re: [PATCH v5 5/8] dt-bindings: ufs: mediatek,ufs: Document MT8192
 compatible with MT8183
Thread-Topic: [PATCH v5 5/8] dt-bindings: ufs: mediatek,ufs: Document MT8192
 compatible with MT8183
Thread-Index: AQHavJxgTRl8oIqIukmc2aVUOBJ7qbHG0BKA
Date: Fri, 14 Jun 2024 06:32:38 +0000
Message-ID: <ce0f9785f8f488010cd81adbbdb5ac07742fc988.camel@mediatek.com>
References: <20240612074309.50278-1-angelogioacchino.delregno@collabora.com>
	 <20240612074309.50278-6-angelogioacchino.delregno@collabora.com>
In-Reply-To: <20240612074309.50278-6-angelogioacchino.delregno@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6597:EE_
x-ms-office365-filtering-correlation-id: fe07d89c-b44b-4000-53ce-08dc8c3bc921
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230035|366011|1800799019|376009|7416009|38070700013;
x-microsoft-antispam-message-info: =?utf-8?B?dm9jUXlqMWo1cDhnYWNxTFVCTE9XL0ducXF0UlFTWkFXVTBjd0MvNzgyK3Jm?=
 =?utf-8?B?RlFRc2NwWENEUWx0cjJRMXRlMXN1b0ltUXE3TDRVa3hJemlBTVU3NVh4bFZ4?=
 =?utf-8?B?UkpOVWZFVmRvMytQS054Q1JPWERkQjN5MnRTTGtSNCsveDJCa0NnYjQ5V1hn?=
 =?utf-8?B?NWg5K3g1MEljSit0d3ozeFlPazlLRGFIQU1VMFBVc0xma2YzOHIrNGUzd1JE?=
 =?utf-8?B?MEFYYlEwdEtPSVpUNzFKejJUVk9jc1hEWHJMV3V2ZXNlejl3YTVLNC9Qemdr?=
 =?utf-8?B?eUZ5ZDhPSVRBSGRDdnZZbVIrRzNDdlU5M1p5Nlpnek15TTAraCs3RTRMSW1T?=
 =?utf-8?B?dFdzMkFnekdKVkU3NkNwUUZ4bnVVelNYa0FzZ25sZFdlL2xRRlBKWkVzQmtt?=
 =?utf-8?B?TDJ4Mk0rcXBiZ3JwSVBBMHNMZ2Z4bFczM1I1MExoY3ZWQW16MUhmWWNGckFa?=
 =?utf-8?B?dUJrZmYvblVzUzU3U2NRRkVwVHp3cXl6d0tzTjB1QW5GQlp6SU5EMFFBZlp3?=
 =?utf-8?B?Qnc2RDV0ZUFnNkFRb2xPWGdCZmc2dVhPQmJLbXhOZ0dKSjYrR2tTQSthcjly?=
 =?utf-8?B?U0ZBZS9MZGlQTjRRMDBMTWtOY05NeXRZU28xb0k3U1ZlSWxaaGZlZEFZMlZG?=
 =?utf-8?B?TDM1TFJsVk1sTDhvTXR3SnVvYW9FQld2TDkwTDVSU25Fc0hhbzNaVi9BbHFU?=
 =?utf-8?B?K2ZsZGVhbXRYL2JWQ252SzJ1NUlXSEx3TWdMWVRZcE9sVGZGOUFkV2VmZEFZ?=
 =?utf-8?B?ckJ3WXZKYWJ3SHRmdWZySGZrWWpnNTZqZi9NMUVqaVhnQ09abWdWMThCYVlU?=
 =?utf-8?B?ZGJrcW1KVmdmSGZXZkRwVDQwVTdRcGhYbE9sR3Nvb3FRd3Bxa3YzbktBMWxJ?=
 =?utf-8?B?M3ZYbXZIMks4T0wvajJ1YVRmaVhMNC9jSHBiSXhyelppR1FjS21BS1c2cWVa?=
 =?utf-8?B?UXphM051eWlrbXk2V2pKYi84aXhVdU9vTzJXQy9HK2djR3B5RkJNMmRoUWFv?=
 =?utf-8?B?M0tKVFJ6U0thSnNnSUJhdlYvTDNnQ0draXhIWEtyUHp1T3pXTktvRVBLMC82?=
 =?utf-8?B?Kzg4TW5uRjREaTdFUUI1c29RWlhEV1lsbnc2RnFENjF0NERSVnBtQUk2ck4r?=
 =?utf-8?B?bmlTN24xYlBQcXpFUGpSV1BTa1laeTd2djJVdEZGMFhmT1BYQmg5a3pIRFB5?=
 =?utf-8?B?NTlNQVRGNFB6ejdtM3VWL0lXTzY3ZERRdHhWczQ1cXl6c0V0ZndIZW1vSUcv?=
 =?utf-8?B?QWU1dVVkdHhmeVFCYWZKVmVCUDJ5bVhMb2cwamRCQjJsalNJcjk2dng0ZnRt?=
 =?utf-8?B?bjVVT3BOaG4wSWEyYVM2WTNVY1Jac1ZNVEhMYUR2eE5OcWhUUHdYVjFJZG9G?=
 =?utf-8?B?K25kRjFTTVdnalpEd1k4WjJvZHpxV3Nkd0tyWDBmWEtUZDF0Qk5YeEpZdEVT?=
 =?utf-8?B?eU9GLzNhODBsWmV2OFpFM3FWTjY2Y2FRNnJMN3JaRVZCMkVVcjZkbUx2aTJS?=
 =?utf-8?B?amIzYktWUnp4OGRQK0ZWSlhpZy8zSEpUQUtwYy9JRFRrWHhlLzF2TVF5UWdW?=
 =?utf-8?B?cmlqVXZwSUtkVnNjeVdrWHNGRkNVcEt4dmZuck1WdUMyK042Z2oxT2VreEls?=
 =?utf-8?B?OHVMOUh6VGxFMlhUUFZwb2ZoU3RLRFl1cjlOZXdPcDBaSERkdEp1NXNwSHhC?=
 =?utf-8?B?c3daeWhwV0VpSXFYU1VrakNITVV5WEJYR3c5SCtGVEFNekRlQ0JLWEdBNTBY?=
 =?utf-8?Q?s/7aLM2CIH6wyQGajQBSHC4zfKMPqPYAqLB6MBW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(366011)(1800799019)(376009)(7416009)(38070700013);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2MzbkRPYUxrdGgyR2RGUXlvcHp3eU5IUFlINUZVOVp4U2ZlL3huUWVJVG0r?=
 =?utf-8?B?TXRGb0tnbHJsTEVzbXZuWkVxRnRKSFF6Z1pRM1d2WTMxdEtvUFNRRXN0ejhX?=
 =?utf-8?B?R3BkTWwySXl3MWcwSThHbGl6YndkRnRtNmtaaHpUM1hIWm5LaEVyNE43UFRN?=
 =?utf-8?B?THNtUjBrWnMrV1dvVDFYR0JYNTBTV3ZPU3hiS0hjOVkrRVZhQ3l1WCtVZnJv?=
 =?utf-8?B?VVJ3WjFJYWx1QnN5SkQ0Z3BlblQ1Q2NMWXl6Tjg4UlJGdmhiMmFqUDV2WFdU?=
 =?utf-8?B?MkkvUENyOUhjZTJlWWtnUTBUaHBxZzZpZ0tmR0tLVTdtSVpPNm1MUW5GSzZq?=
 =?utf-8?B?Y0gwbXpORkxia1JVbm95bmRHelR5WEZCR1VITVV3bUNuNmJWTXZtZ3F6c0tp?=
 =?utf-8?B?a1h5Mlc3dGJzbHpSd0xRQ1JiWml2RUpMSU13aG5vZFlBc0dodzhzL1RuWlhN?=
 =?utf-8?B?dUlSeXlETzlTYWVCN25vWXN6T0ZHRW00azFhdWJ3QXdRTnQvTHBHRXl2Z3Bu?=
 =?utf-8?B?N05CamNrM1dROUNOb0ltd2R4cEVzOXpobEtvV0k0cGllMldLZmRyUzNjSXEz?=
 =?utf-8?B?WUhTQ0kzM1poQU5PWGR5a1ptQkhGSW0zRkREdmd4aCt2MzJnd3c5ME1oc3NK?=
 =?utf-8?B?TEZ4enFUV1hMMXdpa0tEZUhFSzA4bmNtOGxicElRTUR5RE5WS0F0OWw3cWRJ?=
 =?utf-8?B?YkE2ZzZGUm5UTUpVRGRjY2lTUWFMQWtGOHhobWF1cmlOcjloQ0ZmV0dkcEND?=
 =?utf-8?B?SWlhakFhbkZweExHZDQ2cElLTEphRHZVKzVmTmc4bndqWGxVUmNLeFU1UGQ4?=
 =?utf-8?B?WGRyK3dFTVlwdzh0YWlyenR5Q1Fwd3V0N2xRRXdJejNtanJlRXZIR2dMT2ZB?=
 =?utf-8?B?Q3p2Mnh2NmxIczg5S29kYTBBdXJ3SWI2aUI5elAzSzh3eWhPSFVMdSs0M3I0?=
 =?utf-8?B?TFp3Nm1ZRVYrZTVjTHdQWDQwbUp6SkdxMU9sZGdvYW40cmhxRUVETUROM2FQ?=
 =?utf-8?B?NGNQWUR5RmZreFNEcUlxRWlJL0pEcWlxQ0ZTaGtzU2lFVFpidGtycHlyakxi?=
 =?utf-8?B?QWFOMnc3RjJxVzlmT2NWdnh3bXZSelk1clBndVppOHFIZGdmSm5reUhKNmJF?=
 =?utf-8?B?WEFKS2J3bkZIbHlsdUtSZm9iSG16WXVna2Mvc0FuTlJPQ1dIbXkxQXA0UXEx?=
 =?utf-8?B?N29jQWFNZVYwQXF3NE1BaHZZY1A0MnNkYUo0dW5nQ3RtQjlOZGFpM0lKUzdp?=
 =?utf-8?B?S1ZyUTQ4YWl6WVVHTFVNRmttV0p0bk1uWUUwOG1nanNBaTd2Q1kwejM0Lzh1?=
 =?utf-8?B?RUdUcDB5aXNBNFNXRFl0UGpYNTdVdllHTGo2bG5reEFnSkUwOE1rajBBTG5F?=
 =?utf-8?B?T2JqbXdrbkZBOGFTQWI1NnpLUStLS2VFWFdMVjJ2T3hEQTgwNG02U0Z6Rkw5?=
 =?utf-8?B?b3N3VCs5RW5LVjZmMWdZSS9PT296RUlHYkNkcTBaQkhYSjlnaGRNL2ZaWG9M?=
 =?utf-8?B?WHc2RVhHM1lUd0xJMlFIVDVsUzNUdGRvRWtjRndMQWFlWkcvbUVSZ3BNQ2hm?=
 =?utf-8?B?SzRiZ0NFMUpQQ0JVbVBEaEpvWEJLUDZYRWIyRUhxMG5Jb1A4dFRCRHc3anZr?=
 =?utf-8?B?bGpOcE5lNlZweS9qNmRPNGl1bWNWQmRJaGpIaUpzRklGWTdXWGMyVXk3OUZx?=
 =?utf-8?B?ckEvZW5RZzkxd25QMFZXRWtwWG1pNXpwbFNqbC9rQzhmeGRXSmFGbnRjT000?=
 =?utf-8?B?RVl0Qm5tUEhDYTFicjlPMytaOWZBWFBNaWRpT3pOY2FZR2dCY3ZHSmVWYlds?=
 =?utf-8?B?TEM2NVB6c2E2SWp0RXh1S2hPOTFCRStxdno2Zm14QVVEMHAxQ2h4Rll3R0hB?=
 =?utf-8?B?SFQvNGpYWUw3RmRHa2V4YmZMYUREWU9yOUlMRHgwd0FrSzZtZ3NuMEJUUUdK?=
 =?utf-8?B?MFYvU2NYR0VYeHluZk15ZWdJejRIbWF1RVdWYkdRNmcrbkdsNS9oRWdNTTI3?=
 =?utf-8?B?OVcwMWlzOTVnOUJtZnZMd0lJT2NrcHp2VjU5REtGU2xuMEpBVFFId0NIKzl4?=
 =?utf-8?B?TkhmUVdFVEptdFJRRVBManJPQ29MZjJoMTRjbStxUWdHR3krMXcwZk5yOEtt?=
 =?utf-8?B?OWc2VzBaRUxQV29YamdxOVdsRGtvK1JISnlpYWxnSmFXT3V6VWt0R2JlNWNZ?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA09D33B71163342BDD67E6C9659FFC6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe07d89c-b44b-4000-53ce-08dc8c3bc921
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2024 06:32:38.4963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oSSX+mJV8thVMGn6hSIljXYcw8WS/2M3MOvfceymUk07GqXStjJoPq3n9JOxQZAqy16dqIcQYm1z/HliKCcNQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6597
X-MTK: N

T24gV2VkLCAyMDI0LTA2LTEyIGF0IDA5OjQzICswMjAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gVGhlIE1UODE5MiBVRlMgY29udHJvbGxlciBpcyBjb21wYXRpYmxlIHdp
dGggdGhlIE1UODE4MyBvbmU6DQo+IGRvY3VtZW50IHRoaXMgYnkgYWxsb3dpbmcgdG8gYXNzaWdu
IGJvdGggY29tcGF0aWJsZSBzdHJpbmdzDQo+ICJtZWRpYXRlayxtdDgxOTItdWZzaGNpIiwgIm1l
ZGlhdGVrLG10ODE4My11ZnNoY2kiIHRvIHRoZSBVRlNIQ0kNCj4gbm9kZS4NCj4gDQo+IE1vcmVv
dmVyLCBzaW5jZSBubyBNVDgxOTIgZGV2aWNldHJlZSBldmVyIGRlY2xhcmVkIGFueSBVRlNIQ0kg
bm9kZSwNCj4gZGlzYWxsb3cgc3BlY2lmeWluZyBvbmx5IHRoZSBNVDgxOTIgY29tcGF0aWJsZS4N
Cj4gDQo+IEluIHByZXBhcmF0aW9uIGZvciBhZGRpbmcgTVQ4MTk1IHRvIHRoZSBtaXgsIHRoZSBN
VDgxOTIgY29tcGF0aWJsZQ0KPiB3YXMgYWRkZWQgYXMgZW51bSBpbnN0ZWFkIG9mIGNvbnN0Lg0K
PiANCj4gQWxzbywgd2hpbGUgYXQgaXQsIHJlcGxhY2UgU3RhbmxleSBDaHUgd2l0aCBtZSBpbiB0
aGUgbWFpbnRhaW5lcnMNCj4gZmllbGQsIGFzIGhlIGlzIHVucmVhY2hhYmxlIGFuZCBoaXMgZW1h
aWwgaXNuJ3QgYWN0aXZlIGFueW1vcmUuDQo+IA0KPiBBY2tlZC1ieTogQ29ub3IgRG9vbGV5IDxj
b25vci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQW5nZWxvR2lvYWNj
aGlubyBEZWwgUmVnbm8gPA0KPiBhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9yYS5j
b20+DQo+IC0tLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvdWZzL21lZGlhdGVrLHVmcy55
YW1sICAgICAgICAgfCAxMSArKysrKysrDQo+IC0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbA0KPiBiL0RvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91ZnMvbWVkaWF0ZWssdWZzLnlhbWwNCj4gaW5k
ZXggMzJmZDUzNWE1MTRhLi5mMTQ4ODdlYTZmZGMgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRp
b24vZGV2aWNldHJlZS9iaW5kaW5ncy91ZnMvbWVkaWF0ZWssdWZzLnlhbWwNCj4gKysrIGIvRG9j
dW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3Vmcy9tZWRpYXRlayx1ZnMueWFtbA0KPiBA
QCAtNywxNiArNywxOSBAQCAkc2NoZW1hOiANCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9f
X2h0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sKl9fO0l3ISFDVFJO
S0E5d01nMEFSYncha3lqb1ZNc29sSW44VXFwSVN4VkdTb0RoRF9iUkJYMEpFQzBPT1BiNWUxSnNY
ZC1UZVBHNk9wVGJLNk11eXN0NWRnMGdyT3VvTmUzX0gyNUM2MWFqQkhndk5rX2RZT2JXJA0KPiAg
DQo+ICB0aXRsZTogTWVkaWF0ZWsgVW5pdmVyc2FsIEZsYXNoIFN0b3JhZ2UgKFVGUykgQ29udHJv
bGxlcg0KPiAgDQo+ICBtYWludGFpbmVyczoNCj4gLSAgLSBTdGFubGV5IENodSA8c3RhbmxleS5j
aHVAbWVkaWF0ZWsuY29tPg0KPiArICAtIEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vIDwNCj4g
YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KPiANCg0KSGkgQW5nZWxv
R2lvYWNjaGlubywNCg0KU3RhbmxleSBDaHUgaGFzIGxlZnQgTWVkaWFUZWsuIA0KSSBhbSB0aGUg
bmV3IE1lZGlhVGVrIFVGUyBtYWludGFpbmVyLg0KDQpQbGVhc2Ugc2VlDQoNCmh0dHBzOi8vcGF0
Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC1tZWRpYXRlay9wYXRjaC8yMDIzMTExNzEw
MzgxMC41MjctMS1jaHUuc3RhbmxleUBnbWFpbC5jb20vDQoNClRoZSByb2xlIG9mIE1lZGlhVGVr
IFVGUyBtYWludGFpbmVyIGlzIG5vdCBzdWl0YWJsZSB0byBiZSBoYW5kZWQgb3Zlcg0KdG8gc29t
ZW9uZSBvdXRzaWRlIG9mIE1lZGlhVGVrLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCj4gIA0KPiAg
YWxsT2Y6DQo+ICAgIC0gJHJlZjogdWZzLWNvbW1vbi55YW1sDQo+ICANCj4gIHByb3BlcnRpZXM6
DQo+ICAgIGNvbXBhdGlibGU6DQo+IC0gICAgZW51bToNCj4gLSAgICAgIC0gbWVkaWF0ZWssbXQ4
MTgzLXVmc2hjaQ0KPiAtICAgICAgLSBtZWRpYXRlayxtdDgxOTItdWZzaGNpDQo+ICsgICAgb25l
T2Y6DQo+ICsgICAgICAtIGNvbnN0OiBtZWRpYXRlayxtdDgxODMtdWZzaGNpDQo+ICsgICAgICAt
IGl0ZW1zOg0KPiArICAgICAgICAgIC0gZW51bToNCj4gKyAgICAgICAgICAgICAgLSBtZWRpYXRl
ayxtdDgxOTItdWZzaGNpDQo+ICsgICAgICAgICAgLSBjb25zdDogbWVkaWF0ZWssbXQ4MTgzLXVm
c2hjaQ0KPiAgDQo+ICAgIGNsb2NrczoNCj4gICAgICBtYXhJdGVtczogMQ0K
