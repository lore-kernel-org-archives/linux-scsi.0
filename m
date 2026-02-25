Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46363921C5;
	Wed, 25 Feb 2026 10:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015896; cv=fail; b=RaaYg5IIU631bE9qRHK1E4b4VIlt8VcUGwRmtpP4cZuviMK5Uf3gWCF5kSziRl2dV65nb9icLfj17UZDJVjdpIOXWdfV6w+Eb8tlIZlkeyuZj/lfNAqpyWl030F2QKLNo2LsdIgAbD+qbB8OVrAj68xd+PZZYWLGOaxLpO/vzAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015896; c=relaxed/simple;
	bh=qlG7Syi76x9uFj+w99EYfaEfXTDVy+sQXZ+naTorSfo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KPl+xgyXgjNsniTetCKXvmjRzDKMeZlopqeo/kDpI7va682d9hhf7AzMklOzHdU8yfkTDodDNYJcYp5KlHXhuFtwjOdVJw5+4TPrPfYVig4Gm8YTBTa5EAuHKE0IO1ApxnwFqnqiiuD0PMDDtJISwFmWcBlDd/bGQK1S5/lpMPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OcjUn0hh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=W3taf2Vr; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OcjUn0hh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="W3taf2Vr"
X-UUID: 143402f2123611f1b7fc4fdb8733b2bc-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=qlG7Syi76x9uFj+w99EYfaEfXTDVy+sQXZ+naTorSfo=;
	b=OcjUn0hhtpficFlhzyrHwMArOX7mpEnTgJcLrRtl635Q+1ICYKkA5ucUTrRmt7T5PYLS9FFu0ez1yH+JaCIQG/pkkSxwfk8TCm3raMKH1lKW0Y/Qo8Ee1hmuqpFozlPLcf9gesGUJNRM+3AwEScY+rkxsRFoMD4eLyAIKnj+1rk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:c3ff6d7a-5c82-404f-9ea9-f2f28f6aa736,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:ecb7fae9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 143402f2123611f1b7fc4fdb8733b2bc-20260225
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 928953786; Wed, 25 Feb 2026 18:38:10 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:38:08 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:38:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DazSebo4PjSUHhwOuUeY+iHNe87t5iMZfeb/xXFziBXKbYmAHDf/xXAbcG9rdJr9wBptcZdcRNQrUoeKVAmYrLspB5X/zzDisQDhsEYJDKSJDHB13QEQizDvkjJhxA3dm6dWdEZuY0l+7D9FI6sb9XhEOirtubOIMNiGgnu5ux4s9BojFD/Xsh0gaXJ3P1jegFz4IXsp/IuOrV13pnPKFtBWsmiH5ryWdc1i0EFeepLiLoyamwtf8fo9jQgilG5gItypwM2Tuog+HiOmTwvPeYHCbkeb7pzW8sxIzGuypqV0PULCf5gje70BENdjoGASujO828A4zjrquRDSKVboaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlG7Syi76x9uFj+w99EYfaEfXTDVy+sQXZ+naTorSfo=;
 b=uhpxJepSfs83YKGMxnI1E2RRrOGbNHjy7mRcUZaJWeQahGhbaJsQ8yEJ/CqnpywwzrRR4qZigY4v6xF2xDw/qNVKbd4sjq37M0oyg/GtbiuS1gJ0wpaT22Ox6rAsQYDYjx8p9Qnx2udx3UdVSnWKpI7DmdwqEZ1wcZq5TQEGVUbLWkZzAgO/cOUhX0PaIJ3ylOLqVYow5S3cB8poXnlKwUIPQo113/k8USk+fCfM46HH7CphX9Z1c8+fU6KeSMQ7wT/8Ki1kuYmIIdg2YyCeTNXtMyAraf9ymXGZd0j5U0cYeelJdIgckmEhWC91sHlnXlzv4zT8xJ4Xw32ty5+JsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlG7Syi76x9uFj+w99EYfaEfXTDVy+sQXZ+naTorSfo=;
 b=W3taf2Vr0Nl31tXs2Up64H/Z/ja9M5hwKB3fiPDjDqXS0p3KQall73Rb7hhzvbBIe0DwcPGJulGsGvagOS+ZfEtNcbxm46mPmSlQMAH+aZgXGGIM/2WyDWYhX0r2jS/om/bga1a7JNxqR8cqh+5WGsSeaFWjJmUAV5NOdCkD5FM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8472.apcprd03.prod.outlook.com (2603:1096:101:21c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 10:38:03 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:38:03 +0000
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
Subject: Re: [PATCH v7 23/23] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Thread-Topic: [PATCH v7 23/23] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Thread-Index: AQHcn0oBqLDIzlsogEqcvmdccX1lTrWTRw4A
Date: Wed, 25 Feb 2026 10:38:03 +0000
Message-ID: <b18d98dcd4d5f7478be0ec8c67f9d58c60c08d72.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-23-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-23-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8472:EE_
x-ms-office365-filtering-correlation-id: cb461c6c-d389-42a1-1c37-08de7459f473
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: QAtGB0Av6DeoEHoef/NNkDyb2PZNstFGn2v7RDBlpa+MBDXEA3yp0fBZr3L5avfbV1SvpVaWkmE+eUrTHFiaDGJAmFYN2k1EKp2akrST7PzAwfXE/QHkUf8Y5aTTjP4mNwDJT5B6d5KzPcqYjtfn7vi6QPK4iEAuw95azMDNGG8ZK725IABr8RqTw5yT1FssWf5hzq3aUbJyVOXuE2mc3sHEZz8/WMcoOeIiLde9MwR/6yfcAttlz+HJ1j4+SIoohUCarNTVT85+8PrK4Ra6mZCYZ0yMxezERKho2ukEeDedJ7+l23nFCk+H3viFYJhcfisAOEg1byGogMXrNzlIhS65eolaF+TH1iyn2ax5ULrG05qYHe+ZjdVVrbuuE6vxPj7BK1v6wXakGSbZHkI+t63N2tQnyd8Q2ura2i1yMum1Rkko7S1NplyDvWzUM5MhipnsTcyDyvvnnC5MPyZwKwGWTNzhsYk8iPLAclBta+MPlLskR3y/lQobhhuI1gXJ3bdyomhrp2KtjNnyQV6cRdbqVa7CRygkSxpo2hH0WjaGLOL2QzYbmG9qDRQeJxbK97UFr1X/Jqxb3CcW+aYdNJ9TK158+C5TACF0QW9vLZuPDPrZNYacWRDXAWDvENZ+tFdTVGzf9jodXFQxZURsZDwrwZjosO5p2eZ/DEQbSg1oIXfVxARo81Wiylz09xX+fhLAyGUlYaHY+EE2AH+mCnOaEt9OMvu/o5ELMKYU9SocCIAJRt7zjKo/gX84BpVwldv+jIPEkB90JbZPbwTGmKJTPYL5sXXTKxW4MDx1jYO2Ecr/1p8Hl6Gw+b0bye+q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUJWS0VqOFFnMmhkR2Z4U0ZCUG5oNVNwTzN5eXpmYnRPcVBYZ2dRNFpoa0V6?=
 =?utf-8?B?SlUyRzdkS2ZLcCt5NWROOHprM3JwQzlvK2IyWHVQYmM1UDlmb0t2bTQyaytL?=
 =?utf-8?B?TW5iTDEvMHVrMEdDS1lKdU4ySVY4QXRaQkNpN1g2ZWgzZjVocWhscGxxK3Vj?=
 =?utf-8?B?L05RTXloOC9lZWIyenNFdkNMcDUzRTBJV1NuWmlPQnp1NnpkcldyWnZWa1dp?=
 =?utf-8?B?QnF0eDdaMlJxQm53bnY0MkV4TWlMWEtNQkZrWkhkR0lBQjZhZTFqdW1xK0hU?=
 =?utf-8?B?OWcyTWZlQ1pRWWNZM0dLczJHNmpLZUY4QnJ5YnJERUFuNG5LSEVoU1JKU3U1?=
 =?utf-8?B?Q1B2NkNIdGVnRGxwWlhLdUJKSkVsTUVjRXI4UVhJZmhBN3c0TnJpbFdGUFoy?=
 =?utf-8?B?bGVhRU9rdkJCMnRjNkhNVXFVRVNSRnNJVzFOOEhzUE9mMUhPV3BVQWJpUDFR?=
 =?utf-8?B?VmdsK3JlOTRYUkFweFNpUDVTRlFTWHpKRnFRc1lKM1I2bW5KTWhKcmJOQW02?=
 =?utf-8?B?RnEzN1pTU1pIeWtOMkFwNXdTNGhZZ3ZIUXRNeFhUcldSN2J2S0lCYy9pUDlh?=
 =?utf-8?B?cWlneGhsSVRVSnB6V2U0Zkd3elRMRUZMd25Gdkl1bTZMRjlyOGg0dzhyb1Mw?=
 =?utf-8?B?QXlYbFZmUmVLclgzQ3ZZaXM1bEQ5MTJsRGt3bnVDditiUFFvQmpLdWVHYnFw?=
 =?utf-8?B?TVBJQm1qNC85YTdKVHFFalVTMzlUQW9tZnVnMmFxZ3YrZEpTRnQ0R2Y0T1FZ?=
 =?utf-8?B?Y2s4L1NraFhTUFkwTTRrTURuUjJiZ1pvOXRJNXNhMWdLbTkxYWw3bWQ1d3Q5?=
 =?utf-8?B?RDdxanl0ZG14dm84bmo4ZTU0em5NMitOdENNLzV2NTBlZFB1TWtJZEplWWlM?=
 =?utf-8?B?MUJhTExHRUxrcXU5LzNSYzQ1NnlXSjJjd1YvZE5xUWNybmRwRHQrMlNNWEpW?=
 =?utf-8?B?MSswOFhzb0gyN2V4Ykd6MmYraFhyMVRCYWJhSkhOaFR5alNvM1gwd1hmNWw3?=
 =?utf-8?B?N25FMlp6NGphSnEzUytjTFM2eGlBQzlTNlF2RCtNUVdwSDNhOTFvZkZuY3Z3?=
 =?utf-8?B?VkVpZFkzT2N5ckxveHJ0UkNHanlYNHVUOGp3VnpxZDczLzJES00yRXJ4Wkl4?=
 =?utf-8?B?WllYckFxTWVwby9ocnZLQWxLajNzV3Z5S2FpVHE2SWhTMnZEUlBkRGtLZDc1?=
 =?utf-8?B?SFo0N0tjb0ltdEZXbWoyRDlHUDBkeWY0VUF0U0x2aXBhR0N5UkxaYmtXdVEr?=
 =?utf-8?B?K3RVRjR5Ylhnc3IvLzJ2dHB3M3dIUnlDY3RZWjduelFtVTVnWW96R1YybjZv?=
 =?utf-8?B?WWc1K2JhdWMvZWVPaW9tQ0gxQncxYmpJSEk5N3ZReDk1RkIxL0VmRi9YMml4?=
 =?utf-8?B?WWliMDZFZWZySzA5Uk1INjZUT2krckdIdzJiQlIyWnFSczNhcGFGd2pCcHAz?=
 =?utf-8?B?TnhzcjJIYzkwNTRwRmFsaHdYS0pwRGxCdk92RGkyOWpwUUJLTTFuc1V1K01Y?=
 =?utf-8?B?ZHk5aW5mVlA2cGVlblZaUWxXRWNTSGd2cU1nYzFualE1a3gweGMzbmpBY0JT?=
 =?utf-8?B?WWJCNVNCZlJVOE1ZN3BtQTJ6aVVYYmZ0SFZDbzNiekVFUkRiQU8wS2pHK2wz?=
 =?utf-8?B?SEJBZ1AzRlIxM0ppREJtWWZlZitwZmhwY1gvTERpcDdlY29nZ3dFUTEycmdp?=
 =?utf-8?B?Y2dzQUlVOGMwMkhMM2c3M2cydnAvdytrbG5LNjU3WFJqY1RjdFNESmlkQVR6?=
 =?utf-8?B?STBmbGovMGxiaXdVaDluQmN2RmkvanV1NjBLcHpOcS90clhiVnJLN2Q3WFBD?=
 =?utf-8?B?bDhWUDJvNG55SG5SbG1OS2lBZlQzci8xNWRqeml5UlNWMnhsczUvVWU2NjJk?=
 =?utf-8?B?WmF3MmJaTFJvbkRQdWltMnJZWXZLSWNoRnYxSTNMVHVkc1BhaUZ3YU1kQXUv?=
 =?utf-8?B?dUM0M3dFVzNpd0trVVpXdHBXSFRxZEZYQ3AzelhjbjN3VkhacS9salRVNWN4?=
 =?utf-8?B?MWdnQ1FXZnQzRnk4K0NJZ05kV2FMV3BKdklsSEJhN0FVWXllaUdUcXRFdkFa?=
 =?utf-8?B?bXpYU0Y2R2cvODZmTHV5eGdRSmhzd2FTMGU1TVlaQ0RZS2czUkxQUUZaMGdz?=
 =?utf-8?B?LzA2ckVQUktUVDhmK2xoZ056dTFHb3p2TlFZUzNRWmpDWFVPNEw2dmlML3Fu?=
 =?utf-8?B?N0VNUUlidzhxa3VSYnB6NHMvclAxUzl5RnM0NzZmTzViMU5kV2IzS1c1RUk3?=
 =?utf-8?B?ZmZqS1FzVFZGc0RpWVdyaGpOcXE1bVdQU2lzNW82N05ORlQzZDVDa2RJTVZN?=
 =?utf-8?B?NEhvSGVMbEZ5ZGdOMmVid1M2WVFRTlVIWEI1YmlJNU40MWN6MmxYTitUR1J3?=
 =?utf-8?Q?FXgkx14hiNNPLLGs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F34F9D0B5E0AD44288D2DF0CA40B6C70@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: awCnfBYRH2EQ+2A0BovkflGwJgfYLjfyGmWNIKVTSf3XQAiEUF6WV71cbSv3ERSNUkVcTRCp4aWNs9uizC/hDzHw8UbN0E9e36yypzBu7qcWBjp+EcsMpPr3AyUgHFNrgU0AE8BnN0vOREEf1RagPsa6pG6FghcJ+Zrym7rnMpXvIfbWNDWXKyAryqhIBRLK/naXxYxpD4vfzVsKAuIleaaLYvYmZ03GzRvJkA5NGKRLvLc/IAPKghBRYQeFif5y57GDo6yhu1xNhGQ0/U0xvuSdQEbLysZuVl4RXWf3mPKORyD52Jjhtg2x7b+9PNKGxy6rX4+cirQxCxQ4b925pA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb461c6c-d389-42a1-1c37-08de7459f473
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:38:03.4807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nvcJRRHyByk59Tq0SSmCTrgXXRWaZMzQOFzpC7skAS/5IDLpKIEPTiLTw/T3IozMZWlorciaeaTbdcY2e/gIrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8472
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRIZSBNVDgxOTYncyBVRlMgY29udHJvbGxlciBoYXMgYSBuZXcgY29tcGF0aWJsZS4g
QWRkIHRoZSBuZWNlc3NhcnkNCj4gc3RydWN0IGRlZmluaXRpb25zIHRvIHN1cHBvcnQgaXQuDQo+
IA0KPiBBbHNvIHVwZGF0ZSB0aGUgY29weXJpZ2h0cyBhbmQgYXV0aG9ycywgd2l0aG91dCB0YWJz
IGZvbGxvd2luZyBzcGFjZXMNCj4gdG8NCj4gYXZvaWQgY2hlY2twYXRjaCBlcnJvcnMsIHRvIGxp
c3QgbXlzZWxmIGFzIGhhdmluZyBjb250cmlidXRlZCB0byB0aGlzDQo+IGRyaXZlciBhZnRlciB0
aGUgcHJlY2VkaW5nIHJld29yayBwYXRjaGVzLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vsb0dp
b2FjY2hpbm8gRGVsIFJlZ25vDQo+IDxhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9y
YS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0
dGFyb2xpQGNvbGxhYm9yYS5jb20+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53
YW5nQG1lZGlhdGVrLmNvbT4NCg0K
