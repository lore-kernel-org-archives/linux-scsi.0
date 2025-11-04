Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257A0286891;
	Tue,  4 Nov 2025 07:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762241310; cv=fail; b=hpbuGTd6oVPCGeezdfiOdvWql0R60MMqUnKK4xRz2iXytVZ68vlHkZSoEK2NHQrYifmD6ckCM7NMhSnbYmhC14pf3yYM7b2TLJOMBh9wfQziZzbFcrPNfRl/QTmlSHy3mKooEQjeA7p8EGfE35g4MXT43oTAX3Y+7MOhNj+Welk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762241310; c=relaxed/simple;
	bh=jKMhm7L4+bAkH+hQvBDE/hpqwYM+ArWpqbGU+uF8+Hc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y3KrHIAgpQPp4+mtkEV9nRwzl7DhX++N6RCDoOs8WNbk4GgdTEjIRmpxRXQqg4iuaAOjO5Mo02pPXiUZy5OXBHOWzg9udPudHgiJ95hkxWlqjP2IgQWtWWOS2v/0ZpiD4HcdB/C80UFX9vRw/+wAX7CxZ0xmC5tSzoqa5fntgCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cr6wMBLc; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=DmlynacS; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cr6wMBLc";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="DmlynacS"
X-UUID: d812d382b94f11f08ac0a938fc7cd336-20251104
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=jKMhm7L4+bAkH+hQvBDE/hpqwYM+ArWpqbGU+uF8+Hc=;
	b=cr6wMBLcSyyu1MOQBc783y06BfTmnvgw1j/BxLhyP14KEe7Jw4Sqm3rzcvLk+CtzSn1czwI0DkMHxZrAawtXZQQSGtPjd3KO0A6fpD7o/q840aknWUNP9AWBD6V6LedMm7vO02s1pb7c6iFZX/Y2r0ar/GRvM7TQgizsN5PfAyk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:1cb77272-6344-4cf8-9746-d783ca20efa8,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:487de518-3399-4579-97ab-008f994989ea,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d812d382b94f11f08ac0a938fc7cd336-20251104
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 34191511; Tue, 04 Nov 2025 15:28:22 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 4 Nov 2025 15:28:21 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 4 Nov 2025 15:28:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAsUcRrVkpOLN1H783YYkVzbLciAzAdY4PM71Js+gEVOovCYLuA6HvFtVS/KSiFuTmFsj0NoxyQH3LRL4daUaV+fswEPoGC4hh8psweZjeDE9UDPrPlTH7mZ6VJxswiyCMVmHu8Ap+5dP/FUqislFfbHg2YABar+aN8IBSfyFzPj7mcJkZ6HjZUGLdD4411BCTbZg6f2t8UqR2qLBB8miVwpWJ1k7XGKx1JmbMkrFVHp2dk9EgMy93WoZ02nRuTt2bF9LHEnSeJr4+dl+uQRWw+LPiTGTDCQ3gTzchrBitIdUClyCKDGmxWY070KdtjIhGJVpnCCj0gSQwknru/61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKMhm7L4+bAkH+hQvBDE/hpqwYM+ArWpqbGU+uF8+Hc=;
 b=hO1iwm2mbsz177I3MpNnPC1naEA4wryybMZFTezm5U/Fk0DDwaWmfU7ESCVNWV8xDX+A5b6N7Ha7zyC8OfwZl9/BUK63mIJRRydYgOD3vbZtL1C299FBmk5xJ47Z+VhakNZDmh1jxW5AshN5mqsC7ng+BSiZm9BPXXyUKVcIwpKTror8FpomXar6XL2TdGsqcZXqJvuzBdBhy4UNKtyUyRXHbxsEjJP5+tq7xWiaMbaUdmf3mXdTEvPKDEkLIaLhhNBJMQ9oMmL9MkoX8lDGjD4i2d7oWrehv8Qob1e+rgTG/Ub7YXvKlzUFGjlQssj75AjqY3kkOXs+E7y9qQ7pEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKMhm7L4+bAkH+hQvBDE/hpqwYM+ArWpqbGU+uF8+Hc=;
 b=DmlynacSHnEHA43ZIiiS8ft88L+zH+CGuJ5onEPhQUwsfFUls6EWLViM6BoAXgTdprRkmH6bdTd9ofsjcrOEoWZgCBDNjI9+0FvlHAWAbjfHbmNZNgxBxm1v7ZVYmkrta/FGtkPdvNkMt/ylDiFIK7rxfgrOQiVCiKbT6dv5PkA=
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com (2603:1096:820:8b::7)
 by JH0PR03MB7545.apcprd03.prod.outlook.com (2603:1096:990:8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 07:28:18 +0000
Received: from KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7]) by KL1PR03MB6032.apcprd03.prod.outlook.com
 ([fe80::4e46:b38a:9317:deb7%7]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 07:28:18 +0000
From: =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	=?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun@mediatek.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"kishon@kernel.org" <kishon@kernel.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "robh@kernel.org" <robh@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "lgirdwood@gmail.com"
	<lgirdwood@gmail.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"kernel@collabora.com" <kernel@collabora.com>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>
Subject: Re: [PATCH v3 09/24] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Thread-Topic: [PATCH v3 09/24] scsi: ufs: mediatek: Rework the crypt-boost
 stuff
Thread-Index: AQHcTTo49ypGQfrPO0eMepv5B6/WfbTiHriA
Date: Tue, 4 Nov 2025 07:28:18 +0000
Message-ID: <9ae7495023a8562566ff57bd2dfa60524194ee30.camel@mediatek.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
	 <20251023-mt8196-ufs-v3-9-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-9-0f04b4a795ff@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KL1PR03MB6032:EE_|JH0PR03MB7545:EE_
x-ms-office365-filtering-correlation-id: 0cb1a420-3d3b-410d-de72-08de1b73b9b0
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OFY3OVIxK0gxRm5qL2c3NSsvY1RveXhsam5XWUIwSnZTTUUvaGlXaTBtWFVO?=
 =?utf-8?B?RFdVNnZjamNTKytRcmZOSDc2aDh1VS9tdVpDd2MydzlnSFBiMENITTZQbjVG?=
 =?utf-8?B?SWd3MmFCbnBwWWkzaGlzUC81aG9UYktqb1RKZ1U5TjBOWXdHVnpDS2dOSndw?=
 =?utf-8?B?QTRGbHl0azViTkU1TmhVRXFhLytyVHBjVWFYMkJ0U1pQZVdqT1E2MzJtTXVQ?=
 =?utf-8?B?RGxCc2h3WGJRQkJZbFo0bE53L2FMOEIwVy9VaURXcE4vYzluczFIV1NWOUxH?=
 =?utf-8?B?cVZ6MzFUWVBVejN5R016cVhtajRhcnplamVBcytwZnJrM0dmb0NaTWFZUldG?=
 =?utf-8?B?ZWRyKzNGM0JTSGlFZEZwOTRWbDVxdnR1K2tsYnRlM3d0K09JaEFGZVdoUXdR?=
 =?utf-8?B?YlVlbHY2VWFWbThldUlGQ01SdWlRbFdsMG9LV3ovdUZaeVZYWGZNK1hhMmZs?=
 =?utf-8?B?QXBJRW9sL1VoTDJqUGR1NEs0bmJCUGFhbUNCNmw2VWZKMnVuWU1pWEdzcW51?=
 =?utf-8?B?YkF5VU9XQ2lJb3daNUJhR1RGeTZIZlhFWit1SndHamp5eUtLSlVBRjhteVZh?=
 =?utf-8?B?cUV5b3JHZ09MN3dPZjM2bmZkZ1lDYlVkdnF0OHVFTVhjWlMrbitOa2xZc0d5?=
 =?utf-8?B?bWNNUWdibG5peUxRcU0vWEthVGQxYjlhNnc1OUF5dmlza0FIT2hCcUZlWmFj?=
 =?utf-8?B?NTFpK08yL0xSNTR3YXVIZ1RsL2E1S0VDeE9TWnhsdDJCcDB2c3NuRENINnR0?=
 =?utf-8?B?NHp6UGdCeDBzSHJwaHBId2xjc1Q0WTZoeEo3YmRiVDkzMDkwSVBxbG9ONVJt?=
 =?utf-8?B?U0hSMXM5S1U4Rmx4SXZTSU9OeTdqemovZlpkaitqeXFSM3dmTEw1bklyd2Q2?=
 =?utf-8?B?SGJ4MzgzZ0ttb3liOTBwR01ObDVKbjVqNHE2TkFiUlJRemJmeVgrMU01NnZo?=
 =?utf-8?B?N0VzZmhuendNV0lKQitqL1ZnaHMzVjR0M0JQaU40Z1dqaW1nQVdCcTFjWlFm?=
 =?utf-8?B?cUduZVJtMkFrN2FaRnpaeXNxZ3AxdnhVN0RoMDh0WEY3cmdXVWVMSzJPUXdu?=
 =?utf-8?B?NUVsaTRLMWtKUXJadW1Bb2hiOFpoQzBXLzhRSHdKbkVoNnFBQ01aZW9jeTdw?=
 =?utf-8?B?bmUzK1NJWi9FV3FXR1UxeWVteExJUk8vYktQWGo2NGJSWERJb0ZNbnZQcUJX?=
 =?utf-8?B?eENXUEpRQ1p0N2w0ZEVKMlEzZDd3SUdSYlIrQ3ZVVzB1dzZZZTdtS05kakp4?=
 =?utf-8?B?dCt0bHptcnhPYmZMVFZoMWtBclAwcGEwWmtiV0NJb3Z4bXJwZUtQZkJMMVEv?=
 =?utf-8?B?VlQ1dmVZWWI3b3g2eEMwMDRhalo4NStKTHFVTTZ5RTFXSHpoY1hleVRrTStr?=
 =?utf-8?B?TXJjdVVZMTB0M1kycjEycnBXd29WcVR0YVd4YlZrMFF5U2I2S2xvcHJnamIr?=
 =?utf-8?B?clNCWlFwNERZcDd0ZXVyWm5LcDRtUHhTS3YwUHZnRUJ6UFZhNEwrWWN6UTN3?=
 =?utf-8?B?cXA3NWJZUktvL25zMndyVFRqdWxrNTdDL1d0Rk9ITHZFdFNlNVhTZ0JYNnBY?=
 =?utf-8?B?dnpJZlVZQ2xjUTBQaEhCYjd1aklUYllvYjJJNHZma1k2L0lvSURQTTNPTkVv?=
 =?utf-8?B?NysybnlrUFE4MFkrdUE0Y0s3N284bTR0VDI2RGJlTWlkOHBTUkY5Mi9yMXhF?=
 =?utf-8?B?L3Z6TVVRcittcXllNmZSdm02cHlzZ25lMDdBTElJQ3hwWXFyOHBjSStCODkv?=
 =?utf-8?B?M3ErQnlPK0ZtRGpUY2lXTHgwOHN6bjFQTjJ6UW5rMjVmZHdwL09zOVJHV3Fy?=
 =?utf-8?B?OHdLKysrU3pxSlhneE5yakVaK01tcGFlRjdISmtCNklrTWZNYWpRYXFlcm1z?=
 =?utf-8?B?MElwREkwVEJQeDQ5eVFuTGw2eGVNVmJkRjdJTVhxSnJxQ2dlVGQrb0lFdSt3?=
 =?utf-8?B?VHRtKzlRZVZienl5OFJYcnNlSDd6eHc0S2g2S2I3MitOVndTSVpVRmhKNHQ5?=
 =?utf-8?B?bm5DaDFSc3FveVBld2QyRFhnZ0d2Z1JqOFk1NFRFd1piSmkrZWVVclVEOUhH?=
 =?utf-8?B?WFNsRGpmc2Z2V2FRcDRNUWJSV1NxNkFYQUFDdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB6032.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blFqOEpZeTVyRURWeUxUL1Fnc29IcTBpVG1ERDVpZysrS09WdXBLc1YyRlVj?=
 =?utf-8?B?WCtPOGx5OFh3WXZ5UE5KczRPeWxzS1FXTTF1eVd4V05Qa2R5Zlh2YTZTVDAy?=
 =?utf-8?B?aHhVR2hlM0V3T29HUGE5dnUxLytSUUFteWhnYXpQSXpZQzRtWFVRZjVnQk5K?=
 =?utf-8?B?QVUxeFBCT0dLYmRYL3N6NFZJMlpwSy8wVTl6Z1VzYUJlUmgvNDlGckVIeGx6?=
 =?utf-8?B?SU1aTGlRdTVEZzlRUnFlYTRhSDduZGEySkh1WnE5dGR1cXdHaG1HYUZ1a3Z6?=
 =?utf-8?B?dzFzWndFZE1wSEk0UjlxdVpEamxOMWJCNWdST0Z2TE5veVZKczB3MzdJTDF5?=
 =?utf-8?B?anNpS0V4M0RxTFpEYmJKSFBNdjFaUVdqTjk0bHk5SENoSjVnV2tnd1Bmd2xY?=
 =?utf-8?B?U2dKTlh2N0plQ21kcVFnYzdIZG1xdUZHZWpCRStuWVFBQ3dyNjFRdzlxNXZX?=
 =?utf-8?B?MjRxR1RaZlMxblZEY1hZZzhnQjJhcDEwTXZrWjgreHNlWTQzQkdmWHg1SzB3?=
 =?utf-8?B?RGIxL0w4SE5EMm1uMG0zNmdNb1lVbWRxa3JBK2gzQnFJbWZaT3cyZHVnN040?=
 =?utf-8?B?WUU3OFVqdzlhTlk5b2QwZDBTR3hPTXhUMHJicFJqcEZwaDRteGRRNjRETUMy?=
 =?utf-8?B?K2hMdUFPNVB4Yk5hVU1RUHR2RXNMdXBnNEhod3ljSUxNRk9LRjdhQlFFTHNP?=
 =?utf-8?B?b2Y2QWNHYW9lRyt2TlUxRVh4TitEU2F2WEpGbEQzS3FRYzQwY0grb1NjaW5n?=
 =?utf-8?B?SDA2V1VBLzFIWU9jSytnVjNRREFaK3EwTVNZcTNmY2l1ZklzOVF6aDFiSm1a?=
 =?utf-8?B?cUtsenJjT2hIRXl5OGpJVnFxRFliWEJGOVdaaVppUUtaOFFaRVNIcGhOZHg3?=
 =?utf-8?B?V0FZV1pnSDQzdXhTRHBEWHN4S2EvdjNROEErSXlQOGtEcTFmbGhSUXlNY0c1?=
 =?utf-8?B?azh6TjZDR001azU4QlNKOTkwU1Zmem56VllCNDdMWkxKY0Z5T1l1LzFlZVRk?=
 =?utf-8?B?M1N2VG5vZ3VPUnpHNk92STRFOHpvMWxJVE9vR0ZmdmVXM3lIcW5vdFM2S0RP?=
 =?utf-8?B?czJOTG1sV0xwUk9uZEJMKzRhcHR5VmFXWW5mcTJIMFlDb2pWbWhxVFpBVHFo?=
 =?utf-8?B?dSt6RThqMy9oanc5eE85NGdDcURLMDlMbnFOaFFTV24xbHk3YnNOS0t1MExP?=
 =?utf-8?B?V1FLcmpKL1M1TTNXaXBNTHlhZEkzdGZ2bVY0RGhsZW9KdTZZRjcvN1dHdGhF?=
 =?utf-8?B?eEx0SkV3OXlVS1JEVDJqNk5NSnQ1czlBa2U0UlR5aVF4emR3ZFpzSWNEV2Rn?=
 =?utf-8?B?dG5oZy9jOWVERWpTWHhYS1B0YTd4bUU4MnU1VE53YVE1dExQR2M1d2wxQ1Mr?=
 =?utf-8?B?VldPSW91QmRkNERmQnhMY2U3dldtRmpXdjlycWdlNFhNbzYxN1dFYzZwb3N1?=
 =?utf-8?B?ZEpTdk4vYVV3WkJKS3ZqeE9IbEdnczZWOVNScWhScFY3RDk1ckFockRyT3p2?=
 =?utf-8?B?ZTRrT3Y2L0NOQ3Yya3VhZ2NmemRDYllpT3YvZ0Y1YlgzdGsxOEJ3VjBzSXA1?=
 =?utf-8?B?a2Q0Y1VNY2lBRU8vRUp3RmxTRFlYdWNhTTV1czBZUFliUCtzV0pVMFNSWnZM?=
 =?utf-8?B?eFhOVVJwMlI3NW9xNGlaTERIL2NTU2ptY3J2MGFuNm9kWm1FYjRwNTkxcW52?=
 =?utf-8?B?aWk2VDdwNUlBQWRBdUdQTUc5R1N3dHpIWkg1VkdpUzJBRllxRkFJVFBSajFG?=
 =?utf-8?B?d0ljd3JsOUZTcVZVTlhwZzF1VlJtZE51QzVybzRvZmJUQVdLMFhOenorNFkz?=
 =?utf-8?B?MmswV01pdXRpKzA1REpnRXVmZzdad3lIdmxUbjg0R1BUU2d0WlJGMkNJcnI0?=
 =?utf-8?B?YlZCdGFHMjAyYlZFeW83c1k3ZGdPM3hQL1c2bXgzRWk0V05IenhBWHJZTHdG?=
 =?utf-8?B?Z2hLLzdxNjFFdWRGejV2NklsNFdTQ2Jya3dQand6dTQvR3l3SzN6MmtpdjZs?=
 =?utf-8?B?QjBDekRIOUJTRFJIcHRqQnZsblJBWE1mMlpEUkxnb2wwTDNVNWtiMVRDM092?=
 =?utf-8?B?NFJxRUhiQlIvdm5YOStCeTg4QUtvQjBtcm0vN1JJZ1U3NzBlbjl5RkZMSFlj?=
 =?utf-8?B?RUt0NDhUMXo5bG1YdFlJQVF1NkNMMUF0ZmFBVkE1R1RST055U1M1dDVUTTNL?=
 =?utf-8?B?R2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05053CAC8DEB6C4AB8D7D5CCDA215855@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB6032.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb1a420-3d3b-410d-de72-08de1b73b9b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 07:28:18.3363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LWfG5OyhHS+nnU11GiHu6cOpPAc4SM6vH+cmqxdVWCIh4yNrTtfCUsELhmtLesXriti5rJfHlDbbOJiVTF1G2FPVPo2J1RCAgGfJhoX490Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7545

T24gVGh1LCAyMDI1LTEwLTIzIGF0IDIxOjQ5ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEkgZG9uJ3Qga25vdyB3aGV0aGVyIHRoZSBjcnlwdC1ib29zdCBmdW5jdGlvbmFsaXR5
IGFzIGl0IGlzIGN1cnJlbnRseQ0KPiBpbXBsZW1lbnRlZCBpcyBldmVuIGFwcHJvcHJpYXRlIGZv
ciBtYWlubGluZS4gSXQgbWlnaHQgYmUgYmV0dGVyIGRvbmUNCj4gaW4NCj4gc29tZSBnZW5lcmlj
IHdheS4gQnV0IHdoYXQgSSBkbyBrbm93IGlzIHRoYXQgSSBjYW4gcmV3b3JrIHRoZSBjb2RlIHRv
DQo+IG1ha2UgaXQgbGVzcyBvYnR1c2UuDQo+IA0KPiBQcmVmaXggdGhlIGJvb3N0IHN0dWZmIHdp
dGggdGhlIGFwcHJvcHJpYXRlIHZlbmRvciBwcmVmaXgsIHJlbW92ZSB0aGUNCj4gcG9pbnRsZXNz
IGNsb2NrIHdyYXBwZXJzLCBhbmQgcmV3b3JrIHRoZSBmdW5jdGlvbi4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFyb2xpQGNvbGxhYm9yYS5j
b20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDkxICsrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0tDQo+IC0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDMyIGluc2VydGlvbnMoKyksIDU5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy0N
Cj4gbWVkaWF0ZWsuYw0KPiBpbmRleCAxMzFmNzExNDVhMTIuLjljMGFjNzJkNmU0MyAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiArKysgYi9kcml2ZXJz
L3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC01NjIsMjEgKzU2Miw2IEBAIHN0YXRpYyBp
bnQgdWZzX210a19tcGh5X3Bvd2VyX29uKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGJvb2wgb24p
DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBpbnQgdWZzX210a19nZXRfaG9z
dF9jbGsoc3RydWN0IGRldmljZSAqZGV2LCBjb25zdCBjaGFyDQo+ICpuYW1lLA0KPiAtCQkJCXN0
cnVjdCBjbGsgKipjbGtfb3V0KQ0KPiAtew0KPiAtCXN0cnVjdCBjbGsgKmNsazsNCj4gLQlpbnQg
ZXJyID0gMDsNCj4gLQ0KPiAtCWNsayA9IGRldm1fY2xrX2dldChkZXYsIG5hbWUpOw0KPiAtCWlm
IChJU19FUlIoY2xrKSkNCj4gLQkJZXJyID0gUFRSX0VSUihjbGspOw0KPiAtCWVsc2UNCj4gLQkJ
KmNsa19vdXQgPSBjbGs7DQo+IC0NCj4gLQlyZXR1cm4gZXJyOw0KPiAtfQ0KPiAtDQo+ICBzdGF0
aWMgdm9pZCB1ZnNfbXRrX2Jvb3N0X2NyeXB0KHN0cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgYm9v
c3QpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFy
aWFudChoYmEpOw0KPiBAQCAtNjMzLDY1ICs2MTgsNTMgQEAgc3RhdGljIHZvaWQgdWZzX210a19i
b29zdF9jcnlwdChzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIGJvb3N0KQ0KPiAgCWNsa19k
aXNhYmxlX3VucHJlcGFyZShjZmctPmNsa19jcnlwdF9tdXgpOw0KPiAgfQ0KPiAgDQo+IC1zdGF0
aWMgaW50IHVmc19tdGtfaW5pdF9ob3N0X2NsayhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBjb25zdCBj
aGFyDQo+ICpuYW1lLA0KPiAtCQkJCSBzdHJ1Y3QgY2xrICoqY2xrKQ0KPiAtew0KPiAtCWludCBy
ZXQ7DQo+IC0NCj4gLQlyZXQgPSB1ZnNfbXRrX2dldF9ob3N0X2NsayhoYmEtPmRldiwgbmFtZSwg
Y2xrKTsNCj4gLQlpZiAocmV0KSB7DQo+IC0JCWRldl9pbmZvKGhiYS0+ZGV2LCAiJXM6IGZhaWxl
ZCB0byBnZXQgJXM6ICVkIiwNCj4gX19mdW5jX18sDQo+IC0JCQkgbmFtZSwgcmV0KTsNCj4gLQl9
DQo+IC0NCj4gLQlyZXR1cm4gcmV0Ow0KPiAtfQ0KPiAtDQo+IC1zdGF0aWMgdm9pZCB1ZnNfbXRr
X2luaXRfYm9vc3RfY3J5cHQoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gK3N0YXRpYyBpbnQgdWZz
X210a19pbml0X2Jvb3N0X2NyeXB0KHN0cnVjdCB1ZnNfaGJhICpoYmEpDQpZb3UgY2hhbmdlIHRo
ZSByZXR1cm4gdHlwZSBidXQgbmV2ZXIgY2hlY2tlZCB0aGUgcmV0dXJuIHZhbHVlIHdoZW4NCmNh
bGxpbmcgdGhpcyBmdW5jdGlvbiA/DQo+ICB7DQo+ICAJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9z
dCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiAgCXN0cnVjdCB1ZnNfbXRrX2NyeXB0X2Nm
ZyAqY2ZnOw0KPiAgCXN0cnVjdCBkZXZpY2UgKmRldiA9IGhiYS0+ZGV2Ow0KPiAtCXN0cnVjdCBy
ZWd1bGF0b3IgKnJlZzsNCj4gLQl1MzIgdm9sdDsNCj4gKwlpbnQgcmV0Ow0KPiAgDQo+IC0JaG9z
dC0+Y3J5cHQgPSBkZXZtX2t6YWxsb2MoZGV2LCBzaXplb2YoKihob3N0LT5jcnlwdCkpLA0KPiAt
CQkJCSAgIEdGUF9LRVJORUwpOw0KPiAtCWlmICghaG9zdC0+Y3J5cHQpDQo+IC0JCWdvdG8gZGlz
YWJsZV9jYXBzOw0KPiArCWNmZyA9IGRldm1fa3phbGxvYyhkZXYsIHNpemVvZigqY2ZnKSwgR0ZQ
X0tFUk5FTCk7DQo+ICsJaWYgKCFjZmcpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiAgDQo+IC0J
cmVnID0gZGV2bV9yZWd1bGF0b3JfZ2V0X29wdGlvbmFsKGRldiwgImR2ZnNyYy12Y29yZSIpOw0K
PiAtCWlmIChJU19FUlIocmVnKSkgew0KPiAtCQlkZXZfaW5mbyhkZXYsICJmYWlsZWQgdG8gZ2V0
IGR2ZnNyYy12Y29yZTogJWxkIiwNCj4gLQkJCSBQVFJfRVJSKHJlZykpOw0KPiAtCQlnb3RvIGRp
c2FibGVfY2FwczsNCj4gKwljZmctPnJlZ192Y29yZSA9IGRldm1fcmVndWxhdG9yX2dldF9vcHRp
b25hbChkZXYsICJkdmZzcmMtDQo+IHZjb3JlIik7DQo+ICsJaWYgKElTX0VSUihjZmctPnJlZ192
Y29yZSkpIHsNCj4gKwkJZGV2X2VycihkZXYsICJGYWlsZWQgdG8gZ2V0IGR2ZnNyYy12Y29yZTog
JXBlIiwgY2ZnLQ0KPiA+cmVnX3Zjb3JlKTsNClNpbmNlIHRoaXMgcmVndWxhdG9yIGlzIG9wdGlv
bmFsLCB3aHkgdXNlIGRldl9lcnIgPyBhbmQgd2h5IHJldHVuZSBhbg0KZXJyb3Igc2luY2UgeW91
IG5ldmVyIGNoZWNrIHRoZSByZXR1cm4gdmFsdWUgPw0KPiArCQlyZXR1cm4gUFRSX0VSUihjZmct
PnJlZ192Y29yZSk7DQo+ICAJfQ0KPiAgDQo+IC0JaWYgKG9mX3Byb3BlcnR5X3JlYWRfdTMyKGRl
di0+b2Zfbm9kZSwgImJvb3N0LWNyeXB0LXZjb3JlLW1pbiIsDQo+IC0JCQkJICZ2b2x0KSkgew0K
PiAtCQlkZXZfaW5mbyhkZXYsICJmYWlsZWQgdG8gZ2V0IGJvb3N0LWNyeXB0LXZjb3JlLW1pbiIp
Ow0KPiAtCQlnb3RvIGRpc2FibGVfY2FwczsNCj4gKwlyZXQgPSBvZl9wcm9wZXJ0eV9yZWFkX3Uz
MihkZXYtPm9mX25vZGUsICJtZWRpYXRlayxib29zdC1jcnlwdC0NCj4gdmNvcmUtbWluIiwNCj4g
KwkJCQkgICAmY2ZnLT52Y29yZV92b2x0KTsNCj4gKwlpZiAocmV0KSB7DQo+ICsJCWRldl9lcnIo
ZGV2LCAiRmFpbGVkIHRvIGdldCBtZWRpYXRlayxib29zdC1jcnlwdC12Y29yZS0NCj4gbWluOiAl
cGVcbiIsDQo+ICsJCQlFUlJfUFRSKHJldCkpOw0KPiArCQlyZXR1cm4gcmV0Ow0KPiAgCX0NCj4g
IA0KPiAtCWNmZyA9IGhvc3QtPmNyeXB0Ow0KPiAtCWlmICh1ZnNfbXRrX2luaXRfaG9zdF9jbGso
aGJhLCAiY3J5cHRfbXV4IiwNCj4gLQkJCQkgICZjZmctPmNsa19jcnlwdF9tdXgpKQ0KPiAtCQln
b3RvIGRpc2FibGVfY2FwczsNCj4gKwljZmctPmNsa19jcnlwdF9tdXggPSBkZXZtX2Nsa19nZXQo
ZGV2LCAiY3J5cHRfbXV4Iik7DQo+ICsJaWYgKElTX0VSUihjZmctPmNsa19jcnlwdF9tdXgpKSB7
DQo+ICsJCWRldl9lcnIoZGV2LCAiRmFpbGVkIHRvIGdldCBjbG9jayBjcnlwdF9tdXg6ICVwZVxu
IiwNCj4gY2ZnLT5jbGtfY3J5cHRfbXV4KTsNCj4gKwkJcmV0dXJuIFBUUl9FUlIoY2ZnLT5jbGtf
Y3J5cHRfbXV4KTsNCj4gKwl9DQo+ICANCj4gLQlpZiAodWZzX210a19pbml0X2hvc3RfY2xrKGhi
YSwgImNyeXB0X2xwIiwNCj4gLQkJCQkgICZjZmctPmNsa19jcnlwdF9scCkpDQo+IC0JCWdvdG8g
ZGlzYWJsZV9jYXBzOw0KPiArCWNmZy0+Y2xrX2NyeXB0X2xwID0gZGV2bV9jbGtfZ2V0KGRldiwg
ImNyeXB0X2xwIik7DQo+ICsJaWYgKElTX0VSUihjZmctPmNsa19jcnlwdF9scCkpIHsNCj4gKwkJ
ZGV2X2VycihkZXYsICJGYWlsZWQgdG8gZ2V0IGNsb2NrIGNyeXB0X2xwOiAlcGVcbiIsDQo+IGNm
Zy0+Y2xrX2NyeXB0X2xwKTsNCj4gKwkJcmV0dXJuIFBUUl9FUlIoY2ZnLT5jbGtfY3J5cHRfbHAp
Ow0KPiArCX0NCj4gIA0KPiAtCWlmICh1ZnNfbXRrX2luaXRfaG9zdF9jbGsoaGJhLCAiY3J5cHRf
cGVyZiIsDQo+IC0JCQkJICAmY2ZnLT5jbGtfY3J5cHRfcGVyZikpDQo+IC0JCWdvdG8gZGlzYWJs
ZV9jYXBzOw0KPiArCWNmZy0+Y2xrX2NyeXB0X3BlcmYgPSBkZXZtX2Nsa19nZXQoZGV2LCAiY3J5
cHRfcGVyZiIpOw0KPiArCWlmIChJU19FUlIoY2ZnLT5jbGtfY3J5cHRfcGVyZikpIHsNCj4gKwkJ
ZGV2X2VycihkZXYsICJGYWlsZWQgdG8gZ2V0IGNsb2NrIGNyeXB0X3BlcmY6ICVwZVxuIiwNCj4g
Y2ZnLT5jbGtfY3J5cHRfcGVyZik7DQo+ICsJCXJldHVybiBQVFJfRVJSKGNmZy0+Y2xrX2NyeXB0
X3BlcmYpOw0KPiArCX0NCj4gIA0KPiAtCWNmZy0+cmVnX3Zjb3JlID0gcmVnOw0KPiAtCWNmZy0+
dmNvcmVfdm9sdCA9IHZvbHQ7DQo+ICsJaG9zdC0+Y3J5cHQgPSBjZmc7DQo+ICAJaG9zdC0+Y2Fw
cyB8PSBVRlNfTVRLX0NBUF9CT09TVF9DUllQVF9FTkdJTkU7DQo+ICANCj4gLWRpc2FibGVfY2Fw
czoNCj4gLQlyZXR1cm47DQo+ICsJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lk
IHVmc19tdGtfaW5pdF9ob3N0X2NhcHMoc3RydWN0IHVmc19oYmEgKmhiYSkNCj4gDQo=
