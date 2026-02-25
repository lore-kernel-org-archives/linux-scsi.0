Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EBF392C4E;
	Wed, 25 Feb 2026 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015860; cv=fail; b=mW/Ip6P1Ozzr1FDwSVykvCVYF588gOQWDKsec1o1GG4TTyBS3XnoLCzE/9su4pKuWZ9/rKdSmzJ2CHyHNyA6GnlBSsSFUjM1U8Y1UUyRqBUUe5VdSYzeevJYGk7ciXnyxZKeRyabL1iLW8jq6PN3og7Lk6+GN1eg3yfKbFtB+qU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015860; c=relaxed/simple;
	bh=7aqABBVGV/k/lDp8B0UeZV41HKM6Tov5J3agBJYXT08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CWEdKZzMoNi+c0SpORZZx6C9qVtmr01Mt3IYkb3wcEIm+Ax6T59rNxkAq4hp8ChIiHrYjlBIQGFej2iMT9ZT5P+65JWyJTog61pphU2SLq/AXrdgP9tCtE9YIVPCEBXFe8TMKmL+1woseE+FDYALVNwz59r7Tr6Taj+1qFtGt7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Af6CrRPR; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=k2a9Xd6O; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Af6CrRPR";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="k2a9Xd6O"
X-UUID: fead9556123511f1bcd7499a721e883d-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7aqABBVGV/k/lDp8B0UeZV41HKM6Tov5J3agBJYXT08=;
	b=Af6CrRPRuk/3BXtlja3ghFfy+1K1GGO4qx7DXn917l9IyuFWEtW/ByaMDgvIXFxaz6P+Qk8zcqAZo8B8qEVlfdv+rVPjoQTpBiRc4T4SxaoQ3Cz2GcyzrP+XSTaBQMxSC162js9UoiP0xUJsvjuRIJy31DhmaX7jeiqrpkul9+A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:c7623c82-a812-4831-bdec-635756329d02,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:03b7fae9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fead9556123511f1bcd7499a721e883d-20260225
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 469994323; Wed, 25 Feb 2026 18:37:34 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:37:32 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:37:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FATQs0cBzACGvy0Eif0StM6hAiyPd+f/0DhFytKQWIgYl9Lo0+Ntw0LMij4cklnO967ZKocq4lW2TplGVSlQ+I0Q+QcBquXLiq2kpxzavZc3xS0s3umsoCl7W/E1pIm7VyXkYZmibamyAJPDgdrzTvuvalCUzAbJ8Sf765BPh1BGcZf/3QMFCy9z2f9QL+qr46s1jbuuooWbfdxa+DVq8tJp2gt4+QpCZdDoIwuhwPu8iXOSZIKeHMIfZF6kIctyJCH25+B5Qru1VZ6iReXi+hFA3JGPfOVrpn8VNwbpMcu3JtjijrTSNTVIU1WS7jQSh8IPkolJg/iqYRdncOqWTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aqABBVGV/k/lDp8B0UeZV41HKM6Tov5J3agBJYXT08=;
 b=X8LHa1LCYIlYD2rgflDUSTwKiQIgJGh9yCLx/GRJD/wM8p5JwJhNfGeGzNRiNe15U3OauQ4dK1JeEmfQRVd6qE9T6Okx2DeXQZHtE8be7ZqAIM2cM+e79A51wBmub5CFsFkkTRfG7aHBB2a38NTgQbRFSzFpfkyCDNOAGP0KUb26Ef1fWLYq/eWUTSm3PoaoRjvOEGxDSHkCdQVPp9VKskDK7QkOJNWPlAuQVxg0rTTInmfCFkscyU6y4oSYXBjsgd8A1VqLqtiipEKheO1IQsHVqbSWHg4KBpzrP2L+fkLTxnw1Az+O17jLco1oKDiKX4wKeXwp11ftcwgOJpkg6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aqABBVGV/k/lDp8B0UeZV41HKM6Tov5J3agBJYXT08=;
 b=k2a9Xd6Oi3wvXP/weLQVdmQzh5ie4QH6vmhcZZwtnfMUUK1j5eT05Ckgy8kFo7oN1Ucx8/V1E+OzHgKe79bnpFs/tMCNB3VO1gOUV3SKa5mMKE+iFnBSsWRyFmiP/Wzp9Lrg2JM5GCQI1dvRojBcbjWFAvQQBVgmjoow3/+SVo0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8472.apcprd03.prod.outlook.com (2603:1096:101:21c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 10:37:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:37:27 +0000
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
Subject: Re: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Topic: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Index: AQHcn0oAy9P0aKXVVkSCKhBIuR1jYLWTRuMA
Date: Wed, 25 Feb 2026 10:37:27 +0000
Message-ID: <e452951498ae82433337ca428bd49c7358194dd8.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-22-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-22-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8472:EE_
x-ms-office365-filtering-correlation-id: c829f977-ade9-4b7a-64d0-08de7459def5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: j7Gqi1/rUB4JBVFnwh/lI8li7XxX91xGQ0zY5ZZilkXKo/GdUyrJFODoScObyJ3OiKbIcfJYIx+eTmBJg8Ilvv4UxWhma52iQ8Abr0bIiMu2i5CJb7USMab1Dz/PlQQ949DzR2YhPXx+ycrIfGaTImSLsi3FSy1Dv1puFw70WkvOC7EeDuTN5CR19nzv78A7RZXC7fW/0vvDbJ/+YyFwT+u8KR+3M0qhlddXfg1CkIh0sb5OYi4gzChr5hOJBE3jUBqFyzQnQpTEqHk2LoLbWUwPDrPOzvbMdPBayT1gYYvxuAgri/xas1MuOVJJMF7PCxoZ+Gb0zLrOQlz+Mth/GB0JWk/2moPyPG0FL0cx0a3RMgEp0I9GSfVZitkgOcUC8aYr4PVBqWzJ9tOQOfaK3yQITjgfLIE2ggcqGhFCyrUAaZzWJGWVlfOLMQ7Z/6dQzJOAiSaXMAwVDYhzuDkJnXTHQ/pTQRKu4tokyXQuDyqbCoycXgYeS/MERaEJyujJ+0KHKezQhWFvwohcHHsILg7JDB05DjN+wgca2cQMfytMNkuJ3uBWrPIa+/el5Ym3NligDVr+w14nQ9/YxP9a5DaC8fmqzAS1q+DekBbQT+Ta8O4uv7mRRHXiT+ZY6SN1Ju0Njord2BFohoH4P79Z0c78+JlyD89ocvF9MYUWR2nztBeQUJXueb4nC3a182XgjqXgBpR6dGJbSGF7Am3DgrG8Y3znO7S8c/0JG1OAc5AAR9sBWGekaz39AVsvK9V6uAkysExHHC8JeZWP/t5T4TBaf9QkRDcyb/KHUgVrdqbj3MN7TvU/K7nfd9kth/B4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnZrRDRzbVR0dy9KamE0Ly82US9VOGV2ZWg5cThSQjN2alp3VGV0aHFES1g2?=
 =?utf-8?B?Ykg0Ky82TVJHRzk5MGh3aGFYSTNxbDNlakV3NllmSmFLSEQvUWFuTFhhMXJt?=
 =?utf-8?B?VXp5Y0xLcUM0NG10RFVLK001eWF4Y3pTV0NFZHJQOUhYUitMcmcvNklUek15?=
 =?utf-8?B?U2dMQjNEOVhZT3V6Y0hMMnlvWkpKSytBZmhkWlZyZlUzQUVxeFR6WmJWVHB4?=
 =?utf-8?B?RTU5OC9uYjlOcVkwWkR3M1JpMGNIcjlNVUIvOTJ5a0dySXlzVWdMZmVzL3hE?=
 =?utf-8?B?Y1l6ZWgwTlZ0MENFaDkwV3ZCZklJSkM4TmtzWkpIOVZQUUx5SFIyQjFRMTdt?=
 =?utf-8?B?cXI0WVFIaUZJTjVzUm0yTE1lSzNXNENxQW4rYW9ieDMrRVZwSUZOTy9hR1Zo?=
 =?utf-8?B?S2k1SGJZdW9XR1EwNy9iTzZwRVdCVFYwc3hyNUlwQlo5VXlXQnlPbk9QRGxu?=
 =?utf-8?B?cGJ3d0tPeVZKendOZi8xUFFTOEJZQVM3V2lBcG1oY3JqV0xENmI3OUVRSUNP?=
 =?utf-8?B?MUNzYW1BeVRBZDExdTZZVUJnRU1VUzBKeDljSHhSTXk4WVVXNC90T3V2MHBH?=
 =?utf-8?B?VDVDT0EwYi90dzRqbTExU0hqeFJjRU9DcWM4dDlyNFB6NjU1bG5ldEQ0TW1U?=
 =?utf-8?B?TDdmQXI0eHdCTkR4emZjcmxNUDVyckFxazJvbUhaWW1zWTIzaDRaVEF1UWxl?=
 =?utf-8?B?V3JmR0JySkx5SHFLb25kK2ZWYmN1V3ZiSlQrVHBKOUp4S0VXZU9jdlgvYXpa?=
 =?utf-8?B?K2tIUUtGZEUvcTFBTzhnQWdKRXRRaS9ZU0NIZTNFQmJTcEJXM3FOcnRqK25q?=
 =?utf-8?B?UU1ReEcxRytON2xUMWx2azZ4ZzZUNU5zUnJVMUo1M2ptYTV6OTFiWXhmem5m?=
 =?utf-8?B?c21RYjA1VVI1UFZ4b294bFpnM1FnbWpld0dRT1luK1VHRDNVcHd4bC93S2Vq?=
 =?utf-8?B?UGFwZUlOamp6eGN6bCtUZDJwdk1TRDBHWEtrYWkwV0w5ZXJ3YkZXdzJwT00w?=
 =?utf-8?B?dnZxSkFUZUY3OWFCdENtWmpDUVZ6RUlDUEZjTVNjOGxBZnFZcVZiSTBwZ1dw?=
 =?utf-8?B?dWtPWlE1eTc3bTRudjJLMEV3TjVMS09VSitYL3V2emcxNVovYmxseTYrWVJk?=
 =?utf-8?B?YUI0MVZhKzJWcGFQQUIvZXJPc0tzVTlDZnVncWJaV2VqbnVQWVZVdWMzSEg4?=
 =?utf-8?B?VlozTFRwT1ozWTg1b0prYk51NGwzKzhEa0ZlYVJNbnYvOVlmMW9qL3RMSXhW?=
 =?utf-8?B?S3picWVQU0JlQjIyS1VtaG9GUlRteFMzbDcrcDNOZHhDdFhpOEFML2trOW5I?=
 =?utf-8?B?bDN1ZmlJTjhKcVdOdVlJQXo0TTRkbG1pb3IySm8yMStNRG9XczZraFptNU9H?=
 =?utf-8?B?ME9xcGFSS0VWemtQa2ZnUmEvNlhDRGhYS0E3dXFKdFZtK1MrbE0rNXJ1WE5H?=
 =?utf-8?B?ZThIY0REa05hV2oxekU2ZmFuenlncFpzanE0c0NTRnZGaWNoMHRJc2MvR2Fj?=
 =?utf-8?B?a3BMaUZ3OHZDUnkvWjZxbkVYWTBBRDdEdDJUZXc4aWMzL1hCRnEySElFVE52?=
 =?utf-8?B?R3Z3OXJlZ2orNDJhbGlidWJVdm4vN3crbUlnRG5XMUFVVTZrdjdhR21Sa3Rk?=
 =?utf-8?B?N0F2dFpxcHkyTWtwVzk3L0kxTktHQVVWRVlhRFlaMG1xNE9mYXJWZk5nclVi?=
 =?utf-8?B?L1FERHZmdGdXZlNOMkxyYkxBUTlLaVlDdll0SEtwVFF2WCt3c3Y4OVhkSEti?=
 =?utf-8?B?TE5rUTNIMzA4UGo4b1U4RC82ZUR0aFRDaXlQZysxUmdjRFd5Nll0VDJleEFj?=
 =?utf-8?B?a0h3OU5mUXMwM2hKdnFNbU9lVGdwdGNuNDBlVnlmNHhxVzNNdUNLTG82OENO?=
 =?utf-8?B?L0hkbVVoL3NWTlJsclJsTFZFNWtlRlJwdHdoaFBhYVh6UitTYzl4N0hvMXVT?=
 =?utf-8?B?WW1KKzNSaWFoLzVqajEzbHpvUGJGVjl0Q0FRV1M0TVNVOU9tZ3FFUkRqN3hn?=
 =?utf-8?B?OEdGQWQvNG5uUXRhVDZhVUdYdVBrWVU5MU0vYXAzYktmSUNjcUhlb1gyeDd6?=
 =?utf-8?B?RTJueHpZWmNBalM1Tmg4eEtML1hDY1ZML2NCZ0dQTlBMeXoySnRnRzZ4OGpx?=
 =?utf-8?B?U3dEbjIzM1VwN3pIT0hqdmlKejJFSzZFclBkMWJYeTJWdEFXbk92NzhqSFNi?=
 =?utf-8?B?UWVSczNOYmRsMzlxRysrQzlsd20rVFUzR1lrRFU2eXFYR1EwQlNWZUFSL3Nk?=
 =?utf-8?B?UWxzTkxaTTk5SVQzSTV0T0lhb2tFQlJXNFJkKzlUQlBGSStndExBYnJySUs0?=
 =?utf-8?B?NWlLOGlXM1NrcTFFN21mWXhUcVVrZElGeFllRjZIMmZaTG5NVXVtSlp6bVlq?=
 =?utf-8?Q?aUUn4j/dIj5QepTo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <812CA36A0BA52144A10296466846B9DB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QlHuEzoVZAxnWNaZf81h1TsVN1+lRnrjZKAfY3yiOEcW2FBGCSZxFHJ46p+fAL4G1FQlL2sjtN7a4XJQxdZdai255tZXGA6BAUt6iRryrFx0TozK34kZ05wcd/yk4TbWmxiQ1TIVCtF7roJsygTfkKeFEwAxJOSopsp+Cjy7Lkn6cbWR16UJbqZR4Y53bLgUsBUyAI8QE7gz0f/gIH+KpGvg3H7QNVJtUX6zZUCtEa8gsPVGcf8LUlLOkSXo9TN1LGcqh9L640Zrf/ZL/cKc/1sOS3LI+VSNF2wJsgW7ksBJjmkvCh58em7WdSNrQ7U2ddZwTUxUg0YCh2jgAfo5Lw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c829f977-ade9-4b7a-64d0-08de7459def5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:37:27.4696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bbR2dyeLViA+JRtF5dt8/c4VJLBvxXcjrh/EP+u5c3cKqky56nldP8XxvgRiNbkHC6fAmxOrBUl6P7L3Jl92RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8472
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBNZWRpYVRlayBVRlMgZHJpdmVyIGNvbnRhaW5zIHN1cHBvcnQgZm9yIGFuIHVu
ZG9jdW1lbnRlZCwNCj4gbm9uLXZlbmRvci1wcmVmaXhlZCB1MzIgcHJvcGVydHkgbmFtZWQgImNs
ay1zY2FsZS11cC12Y29yZS1taW4iLg0KPiANCj4gU2luY2UgaXQgaXMgbm90IHBhcnQgb2YgYW55
IGJpbmRpbmcsIGFuZCB3b3VsZCBub3QgcGFzcyBhIGJpbmRpbmdzDQo+IHJldmlldyBpbiBpdHMg
Y3VycmVudCBmb3JtLCByZW1vdmUgaXQuDQo+IA0KPiBUbyByZXR1cm4gdGhpcyBmdW5jdGlvbmFs
aXR5LCBpdCBuZWVkcyB0byBiZSByZXN1Ym1pdHRlZCBpbiBhIHNlcmllcw0KPiB0aGF0IGFsc28g
aW50cm9kdWNlcyBpdCB0byB0aGUgYmluZGluZywgYW5kIGp1c3RpZmllcyB3aGF0IGl0IGlzIHVz
ZWQNCj4gZm9yLiBDb21wYXRpYmlsaXR5IHdpdGggZG93bnN0cmVhbSBkZXZpY2UgdHJlZXMgaXMg
bm90IGEgdmFsaWQNCj4ganVzdGlmaWNhdGlvbiBmb3IgaXRzIGV4aXN0ZW5jZS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFyb2xpQGNvbGxh
Ym9yYS5jb20+DQoNCkNhbiBNVDgxOTYgd29yayBvbiBHZWFyIDUgd2l0aG91dCByYWlzaW5nIFZj
b3JlPw0KSSdtIGFmcmFpZCBpdCBtaWdodCBjYXVzZSBwcm9ibGVtcy4NCk1heWJlIHdlIGNhbiBh
ZGQgdGhlIGNvcnJlY3QgYmluZGluZyBmb3IgTVQ4MTk2Pw0KDQpUaGFua3MNClBldGVyDQo=
