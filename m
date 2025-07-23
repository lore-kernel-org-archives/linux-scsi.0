Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE74150997;
	Wed, 23 Jul 2025 09:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753263234; cv=fail; b=JHciXTAmrdjyUAWMVtF0mxLOtFLas06Euzjxi/XTuVUHushooT7k4yhD8MsiBinR419ehPOb2oH6BP5Hek/lhRAuCdLgHyGw3fRuycxAM0NomCcoxIyFkUwORi2uq15kGXBnu/tCYPuKnupaillAFup3a1BS23b5Exz7+Wa3+Q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753263234; c=relaxed/simple;
	bh=uyTluSAGWPe4cFM8YpEXLHvONKvzTW4YMaAUWJs40jM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eACkcYeh0dIuOuOz41AeRa6BF0/xbQwCuA2B33RLYIVsii0ZTc2sZsTSmgQ/x53vX7JmwE7OA2ehgQhgI0VgBwkj/qTzDyZWWe7XOcWrOlq5a1zvC0tQ6bs1JJ6ItQZqgJTU+i2VlBGOevqdWutxZVBq6R9w/4TqfUJN0cmIjso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZM0D3wJC; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=h4nMckNm; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZM0D3wJC";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="h4nMckNm"
X-UUID: 20f3639a67a811f08b7dc59d57013e23-20250723
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uyTluSAGWPe4cFM8YpEXLHvONKvzTW4YMaAUWJs40jM=;
	b=ZM0D3wJCF2HRhmR+TSVgcGeefC2LeaVrakDE5qlT6r8fbowT2ArUqzjEYAdaUC6Deg7UoOBBEttFceOFtKoGQLqMo3SY7D/szQtEgaFl+76BzX6w06WHMg83nTXqmUTx0b+qdKWt9NVg4tZwvTYjCJkjzpOF+CMbSg4mpOJSi30=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:2b63f3d3-74b3-4bec-9bf5-eb5b3e21cc42,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:d9fc160f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 20f3639a67a811f08b7dc59d57013e23-20250723
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 584039029; Wed, 23 Jul 2025 17:33:45 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Jul 2025 17:33:43 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Jul 2025 17:33:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLOXE6RV1NbzyhXHIdbA1ZrmE74bImOZ783qva6mbzKytvyuQr+1DBsfWHxCvPLgFexHoqfdEaGc8E+l/lWgnS8nCTnqvuG4GsEaDC2CLEPU+omPr3yfRlKASvsLCHLSRBXu9yHj+JE6esiygNsCgKnH+HMeCrb9PrVEM1MapcT7Vztpt5lG/MOb17FgD2GxZre8+mwlBjn0E1yTnNTPH4aVCII0hQ5TTUgmoBT3s5awF9YG8uO15RBm987ckqaI+72EnPenYnms83QojUL/vymsg5XU6X+26Hf11UebkKDbmjembDdR6WvwJA2ItZqqW2NibIljOtKmEQ8pkLDf6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uyTluSAGWPe4cFM8YpEXLHvONKvzTW4YMaAUWJs40jM=;
 b=Dt6AwTzXJsCBouD4hUKJ/HK3QGW5ar2F2wKi+nlGf7v7u+7YyHlFEDtp46FMSjYGVEAblWhwpdlba5BAcw13aiXhmPhCGNqXxgttsvRvnW7RzcAldcD4P5AC3/BJ8vF3ut9u3KnAX5fgjR6msFH0F8PhkFZj4EVT3FiXp+ANGn3ieWZ873JHH76+OCy9s5AhgoyShIUjGtCmaxxz8QfFI+XV2VZrCNdf5xC74Vz9KuWTopO+ZMtPSj6rKz8b6R8YKN8HCSFNoUbyPq3XQNEkBpJ8SLu0pMN5tZWFfSEutJ7hWkfaLA6hfLg7ktGIDNAm58CUxpS6xyfppy7c9WmivA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyTluSAGWPe4cFM8YpEXLHvONKvzTW4YMaAUWJs40jM=;
 b=h4nMckNmVjQ2z3I9qPY2t2fVWTFx3X6uhtucvHedNFrzrNZLgCshVbRlVJ2a/loPZ31HWvQWrF7YAz/FlApIPm8rI460ov6xnlRPbTcPk+uT76/FqqujVbsXVHOFOS2SkHqd8FAqwJxQIFci9smyVtHTQivQsz2C9uZx/91oTEQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7562.apcprd03.prod.outlook.com (2603:1096:101:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 09:33:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 09:33:40 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?=
	<Macpaul.Lin@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "macpaul@gmail.com" <macpaul@gmail.com>,
	=?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
	Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
	=?utf-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
Subject: Re: [PATCH v2 1/4] scsi: ufs: ufs-mediatek: Add UFS host support for
 MT8195 SoC
Thread-Topic: [PATCH v2 1/4] scsi: ufs: ufs-mediatek: Add UFS host support for
 MT8195 SoC
Thread-Index: AQHb+ubXWLZBtpESgUSRcvTCuFOu0LQ/c/CA
Date: Wed, 23 Jul 2025 09:33:40 +0000
Message-ID: <07d55dbb1a92a2171b94cd75b8e524a7446807d4.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
In-Reply-To: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7562:EE_
x-ms-office365-filtering-correlation-id: 39c9fc88-e8bb-45a8-ab29-08ddc9cc0238
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TTdrSVNtd3lXbXZGMHdCWVRpNHd3SW8xVk5oN0thVkNSWWJrTXMyZUc4Lzgx?=
 =?utf-8?B?NWJvVzd2cEZJYkdCZjMwSWZGTTRmUjdkV003RnZINVArRFhNV2daQUNrT3JH?=
 =?utf-8?B?T3BGcUYxMlB5NEY1WnBka1VJOEJOSlFFRjErYlRGN2R6K2xTVjlnYy8rYnpi?=
 =?utf-8?B?MFZzK1FvWjdDM0VqK09VZVMrcjl2dkNFd1JaWk5UNHM3eGlhNFF6WVpFa0xn?=
 =?utf-8?B?TWJZSEF4M29GUWwzSWphcVdFcUJsRkswRVNWVDkvQkhnbzB0OHFSK3ZhaU0y?=
 =?utf-8?B?M3NiQXF1WGd0UWFtV2FRa1lUL1JJWGpSM2p1WXJobDNKM1o1RXcwZHpwV0I5?=
 =?utf-8?B?bnVoektoSWpGVTNGMFphSkd3WWozR0JjR1dSVExZVXYwdEpXcjd2UmtRNkhj?=
 =?utf-8?B?Ri83QnZsd0tqTFhmM25lUnR5MUQ0cjY5VlBlZzB3RTh2UUM3TTRKM3g5NzRB?=
 =?utf-8?B?Wi9POFdQUFNDNXlOQVduaXI3aVJLcXMrbEdqS3ZJN3BhdGZjRmlzS3hmNFB0?=
 =?utf-8?B?K0pmUEd5amxZcTU0SWxuUGx5K2xNUXRiOXhIbHVZcXUzQTJNS3QvU05TaUlx?=
 =?utf-8?B?Y2o4M0NOOFBYZXBFQnBCOXFQblFzMzZmbnMzZnFOYjF3ZUlDYTdFV2hvVWQx?=
 =?utf-8?B?aG5nUThwYW83K0JEMU9VOTRRRkErWmg3aTcvVzhVWnhhS2M1SGxWWG1PWDls?=
 =?utf-8?B?Q2NIb0R5N3BWcGpiLzlmaHZKekQrcDdzQzRZV1o0eVZ4dEZtYWF2a0tqT05W?=
 =?utf-8?B?dnhjUXoySXJFd2tldUFkU3ZoaVZ1eGxNSnZ5dnprL3ZoeTJJN29LSld0MEVy?=
 =?utf-8?B?cFMwSHlhaXZ4dWQrdG14a0lZN3FpbXFneDlvWXNWVFc3N2dUR3V6RTdNL3dP?=
 =?utf-8?B?bGk4Q1FlWXdkbE9kNVlTRzVwUU16MkpqVFNOcjBwNmpYK3FoU3kwVEF2bW1s?=
 =?utf-8?B?dVZTa0lrQ3VPVklSZG5DRGEwcGNjd2NyWTJFZDQxc1NhQlBLNHdkWFJJbXBI?=
 =?utf-8?B?ZlFudHhJV1BCWFhobjhHODk2emx4YXpZNk0ydkttdDdTRnl2K0JNeGgrSVZw?=
 =?utf-8?B?bzA1SXIvcWgvN1VKYU9CcElSb2orVXZQNWM5dzNwUjhROXFCa1V0MzF5NHVT?=
 =?utf-8?B?QTFKY3Z2THg5YVhkbk5ncjlDMzdPSFdWNzJ1blN0ZHRhSXA2UEhQMXh5SmUz?=
 =?utf-8?B?c2NKRkx5bUh6NE1WTjVuMzgwNVlHSGE3VUR6ZnBqaWxkbWJlbHhkRCs3c3pT?=
 =?utf-8?B?M0QxL0JZd0pGOGFkR1JQVHg0bFNsOWo3LythQnNjMHNMVHU2MXpkYjdldnM5?=
 =?utf-8?B?bTdwTXlsRkpvOTdkM2hxR0lZaUpzaG5mYzE1TkJyUWpoVHQwZGdZdXpaeHFk?=
 =?utf-8?B?RFNUVHZmK0l4Q2dDdEp1S1dabnJHZXFLOXFVZnp4djZablNqemtwQjI4Ykgv?=
 =?utf-8?B?S3hqTU83MG82dDFKLzFvdlRudjZSaFZJZEw4VXBzelNzRVMzdW5Ed3lKNDlX?=
 =?utf-8?B?bHd0aVFTenhwVXVrbWRBeVNuYkpKNldmWjIzVG5mRXBuNS9pM1hIOWh0Y2Fl?=
 =?utf-8?B?WE5qbG5hUENXZTJ3ZmxjTnhoUWw0alVpTEw5QnR3NVcrazRDdU9hR3hZWkxz?=
 =?utf-8?B?S0pmRTBsN0c0ZlJKY09KdldSeURreUtMeGd3emJFcHRka1N5MGtwNlJuU0tD?=
 =?utf-8?B?OXZld2NNcHRPZEtKY0ExV0dGQzMvRkozdDczNDBRb2l1VGxRYWIvUTlCekFz?=
 =?utf-8?B?VEFBeG5sa2FlZzY1MDZrTTNUZVM1clk5b2ZqR040KzhLVlJucjFmVzJVZzdS?=
 =?utf-8?B?eGswNEQzSU1lV0RKUm1tcytpd2NXUEwvWEdKWFEraDhic3Jhb3V4TXZ2bG9u?=
 =?utf-8?B?dUFwRlY1SlNCVG9yR05jR296U2JJa3FMZkxtejM5aktnd2JEcGRoWnVoUWNU?=
 =?utf-8?B?ZG1FRHRKWFd2US9ZVjdjZGNnaU9yS01aMlNsUm4xL3JCOUNJSVRBd2ViNklu?=
 =?utf-8?Q?Jtmzrx0cbd7ShRJIoZGqsieAHEye24=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGFhL3R6dUZZbndObEJFYnlwdkhVMElPK1R4RWIzM0U4MFR3b0ZHZXVWTFl3?=
 =?utf-8?B?WGp5UDZiVUlBQXZWYUxGZmRORFB1NVdpMEhyWTFLc3hIMlZGWEg0SG8yNkxK?=
 =?utf-8?B?M3MvaVpxVmdtSVltTjJRWW5pS0RsRk9FRlFKMnZCUmhYVmcxR3ZOaXFTdVlP?=
 =?utf-8?B?S000b0ltdWcwMXNWcWZCdmx0Qlp6em5iQ2dLTXBROW1hbWRFMlJ5VFJ6bDc5?=
 =?utf-8?B?STFBd09mZWk0SzNSZWFXcDM2Y2tsMkpmMGoyRzl6ZmI3WDJSZkMxS05kUVJP?=
 =?utf-8?B?N0dmREo0UnlQbG5lWmx2Qkxyb1RnVFdSeDRlL3hGK096WUk3ZEhDR0FQZEh1?=
 =?utf-8?B?d2phaEtkTzREaUxRekozTEtMTmRGMXpTUlV4NlVwbkpwU1FnZFpuWW5pYUpY?=
 =?utf-8?B?dDBmaWJRb1pMNytpTU83ZUdXVnlrM2hzaVVRMnZnSVpUazdFU0NkOFM1Qmtm?=
 =?utf-8?B?cnA3UndVWk5qT3NVL3NZaytFWTFTcUZhaG5xUEdtZm8yUGlqdFZhV1YxSjFE?=
 =?utf-8?B?QWlGRHY0TTFBUDVibXpwdHVNd1duV015dHhjMGNRdEZzdTUydjhDZTlTZVVo?=
 =?utf-8?B?bEVFVWg1RTg2Znl6NW9FdEpUdzE3NW43Zm5kODNodTlyanM3bEtNdkNUbEU2?=
 =?utf-8?B?L29KeERSNzBSL3FHMlBYM25TNFJ0SVZaelI0S1FHcXpZcFdZTG8rQ2lVSGFL?=
 =?utf-8?B?b2xRTy9KeUw3VGNiK21ZYnNKc0pGajFrSmQ4TTB1TWRneW1XMmFGNzRld2x4?=
 =?utf-8?B?dkU3cTloZUZIL3pBRjBxSFk3Zkx1V1l5UHQxKzY1TDYreEZKUnBScW9HNEds?=
 =?utf-8?B?aXkzT3YxdWxGZEZOVDQxOFF2VEtER1RtSHhBK3VsNXdVcWJta3F4QVFlOXBi?=
 =?utf-8?B?ZVM4dHVYZUNJUXpuT0VYdmpHWXdiV3JQdnBManFoYlkwWFlGbHNacnBKOG80?=
 =?utf-8?B?VHlGZ2dncEFhd21QbGc0SXdBV21XTVdYWUdQZUhVT0syakYwa3lvd2Q5bkZS?=
 =?utf-8?B?WEJLY0pIem9Kbnl5NExUcll4RFYzWmc0U2R6SG8rZGNUWDUzSW5VclZwQkVi?=
 =?utf-8?B?NlNkNDhPZFY2ZjgzWERMWE1VaHgyWFdWemwxV2svMW1EcnNhL2tKWkVkZlds?=
 =?utf-8?B?VHluRko2RndScStqUUZ6ck1WQXlSRktSSW1DNkdCS0kxK2NZYzBSbVp1L3RQ?=
 =?utf-8?B?N2pkck9wL2U5R29wRjl1ek45MkYyNC9uenE5ZmZMKzgwZm4yQ3lKVW1YTkdr?=
 =?utf-8?B?U0tlM2JjZDNBWFJyRm9BOFpra2Q4NkF6cHozNlBKbGdsQVBEZUVySS9XNjJU?=
 =?utf-8?B?RmROZk0ydTA3RVhHNURiSjlLdjVpd0RZaUE0cGloOE45NnY5U0NyeUNaTVJ1?=
 =?utf-8?B?cUZWWGRjSzFsanAwdXRrRXJSb0ZxYXV5aitVbTExUUNhVVFBOHpUNWloNDky?=
 =?utf-8?B?eFBhU3F2MjRCMG1XaitEdEd5VS9BZFQ1a0pFY3k5TkErMkI4Mk9pZ0tidGw5?=
 =?utf-8?B?NFVyQkFoMXdsZUttM0NPQlZBclFSVXRta0NCWWZIQW9VaUJPd0xYc3FZZEV1?=
 =?utf-8?B?V0p0NUVmSTBnci9pWWdBVmQrRWhzMFVLaXh6aXZqaDFkTFZNb0hzQ0prYmY3?=
 =?utf-8?B?eU1PcXFnbWVGZ01KbE9lNGxuRU5yaklyRkRoZVVPRmNQQ1diRGVMcVJHYzd5?=
 =?utf-8?B?ZDF1V0tJbitsdnk0K2s0K1VucUVCQmlEdzc0czN3Z2c5T1dSSEczK1lSUzFp?=
 =?utf-8?B?d3BGajBYczFrMlVXV3VZSDBMcFdXckw0OE9MTXBSU25pZzloSXJLQUhjWlRi?=
 =?utf-8?B?L3B0WkNSeTFHd3N0ak1JeEN0eEVqeUttL1F1b2txS0I0MEh2TGdsWGhzcmE2?=
 =?utf-8?B?S2dZV3NHYS9mOWJ0QXhaVXc1SkNWb1dDZEgreFd2K3RGaERJYTlKMFNmWXEx?=
 =?utf-8?B?RHdtdDMzY3pJNzZidnR4REx5NEtjclRjTWkwTTVLeXBHRy9KZHpHcjYvcUlB?=
 =?utf-8?B?L0dQZThVUjFsV3d6ZnVLaHZrQzUxeVFXVWMxdnNKR1ZXb3RBbEtTQVZhQ3ZH?=
 =?utf-8?B?N1EwcjU5cVFDcWJLUVkrSmlKYTl6MFJWdG1oRytBSVR6eCtCTStkVUdseFZ6?=
 =?utf-8?B?ZnZXS2ZpcnVWSGIwazU1NkJSMlJobVIydlFyS3NZQStwYzRqVk1QbkNGb0lX?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52543520FFF3ED468C833052692A7E91@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c9fc88-e8bb-45a8-ab29-08ddc9cc0238
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 09:33:40.4129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RGVfSIZ0BpucfnqntBOtEKIDlYsaPx5WDnMrgkgn27C2Fj/rGuh0PTGNkb2Gnv8CvPDKYsPEV3YVPZ3qkHAeHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7562

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDE2OjU3ICswODAwLCBNYWNwYXVsIExpbiB3cm90ZToNCj4g
QWRkICJtZWRpYXRlayxtdDgxOTUtdWZzaGNpIiB0byB0aGUgb2ZfZGV2aWNlX2lkIHRhYmxlIHRv
IGVuYWJsZQ0KPiBzdXBwb3J0IGZvciBNZWRpYVRlayBNVDgxOTUvTVQ4Mzk1IFVGUyBob3N0IGNv
bnRyb2xsZXIuIFRoaXMgbWF0Y2hlcw0KPiB0aGUNCj4gZGV2aWNlIG5vZGUgZW50cnkgaW4gdGhl
IE1UODE5NS9NVDgzOTUgZGV2aWNlIHRyZWUgYW5kIGFsbG93cyBwcm9wZXINCj4gZHJpdmVyDQo+
IGJpbmRpbmcuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYWNwYXVsIExpbiA8bWFjcGF1bC5saW5A
bWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5j
IHwgMSArDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBDaGFuZ2Vz
IHZvciBmMjoNCj4gwqAtIE5vIGNoYW5nZS4NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vm
cy9ob3N0L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVr
LmMNCj4gaW5kZXggMTgyZjU4ZDBjOWRiLi5lMWRiZjAyMzFjNWUgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91
ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtNTAsNiArNTAsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHVm
c19kZXZfcXVpcmsNCj4gdWZzX210a19kZXZfZml4dXBzW10gPSB7DQo+IMKgDQo+IMKgc3RhdGlj
IGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgdWZzX210a19vZl9tYXRjaFtdID0gew0KPiDCoAl7
IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE4My11ZnNoY2kiIH0sDQo+ICsJeyAuY29tcGF0
aWJsZSA9ICJtZWRpYXRlayxtdDgxOTUtdWZzaGNpIiB9LA0KPiDCoAl7fSwNCj4gwqB9Ow0KPiDC
oE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIHVmc19tdGtfb2ZfbWF0Y2gpOw0KDQpSZXZpZXdlZC1i
eTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo=
