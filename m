Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1983D288C3F;
	Wed, 25 Feb 2026 10:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015769; cv=fail; b=Pi/pQt06gjGdEfZL7BS/l82Yo4VOS8Tq58m/wn3Zn9NDVeOuaaxf+6d3WHkPVBN1WbvHpETpV8cnuZmH5X5PZLZVVpIOwLGlS3MZJ2vlX6KrbjoPhBY8U8wi5AGQnjOGudASKs+pq0xKGFbdKxDLzyQYRK61e9P4d1OaEU+HLHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015769; c=relaxed/simple;
	bh=BSFeRBUD7PcA3K+Iwm8l1Nm8cfeKRY0ypbJpWtaU3F0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B7PBUXGLqveAf+IpiANFT0lcZg0iQchTq8MW0ZRbAuGROfZNMXncC4mMcTsM5rBjb6RrSqcln0ToqwfK9t/gkA7F+k/g8TUxANgJzX/RnrfVAUFT3VDsg8x1+4N8o+G6EOaMVAcB7QM56pEcsjIL27PDp9k12sE+rhsWj0fS4Ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XKNo7Flk; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=skdp2cGq; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XKNo7Flk";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="skdp2cGq"
X-UUID: c72a4e94123511f1bcd7499a721e883d-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=BSFeRBUD7PcA3K+Iwm8l1Nm8cfeKRY0ypbJpWtaU3F0=;
	b=XKNo7FlkeDsqGYtJ4806LHRJ4ViJ2nvlTm06TPPjPspkvnWDbTGSe0W4/qnP5btYWt0Xrf6f2egwU7rP7wnBSnDGBOWcGpny2nsI5jPh46knDUMTgcq0GnWyF8Cln+BsOnFEhcGnWtHzgNzlsQ5zeVmjOpN02YA2i5YiRXG5cqo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:6150a7eb-8ec6-4db2-975f-34e9b32f0a7c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:4fb4fae9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c72a4e94123511f1bcd7499a721e883d-20260225
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 557950333; Wed, 25 Feb 2026 18:36:00 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:35:59 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:35:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxT1zhgx+v8qAEZcGp2pgcWk5kIXTAziNZlP2w7VA+xZKsR7j2MiNvmknakRBCAe2aOg5e+HTorOJgGT6ak+IRQ/lwZKq2nQFcbTOgdxeSTpINAGLjdB2mLj82Rjsck6K52m4qdvu5+pvgQyR6S/c+5xS5+WKh2dkI+vmhnbVTIKgjyIOn3qViu9H+xn1UgKkI29NoMmZ4UWI745zt/KScBAusXfzCQPiehE2Ay/vphH0rKps9ZwKnpgOgYAlmMIw2M8RSZT8RnbAC58t/pGHpF/yo+Q3tqyQCTT7lRenrSkn9jEa81YWC6AS+ehZZUH9bFK7yzEunpnrzUi5JzoNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSFeRBUD7PcA3K+Iwm8l1Nm8cfeKRY0ypbJpWtaU3F0=;
 b=MHI7oMu97r9TVQujRRUfoVFENaot/egvP4nAWav9smUtkR03JJUBRpBHJ4PplDgCqUW2e65oKv5hWz7LbbwjGYunxpVqRoUB19jGs7Xs/kB86hZt+KUQZvIu7eqL2HNT5kZNwfEjmdsVYo5yswxjXuS9uOtha+gO5lj+kH6cuEyKOwQ7ZJP++g2wRmaAZJzVnJQDwCwxMLz4lIAahG5bP5CykGpCFszOJjsYBTn70jOCgE8yAvk8s+V+E0xRgXzpMn2dOG3bARkVDS4i6GiBVvOZRkcXVLBJjGA7tqGmRskPZX/vD7w4f7ohQ6BIBwr0jxU/VtlLDZfq8ib0TRlvAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSFeRBUD7PcA3K+Iwm8l1Nm8cfeKRY0ypbJpWtaU3F0=;
 b=skdp2cGq4HnO+GTuohiPDDe7YMic+5s54VmVW6OSdrIoB57fvREQc/IUYsRJI8fOY12b0jcafwBPde3Of3aesMuW0twJ+cCAoZUVXSMgjVjzTO3XenQDLaMn6/J1DtI/FZfNS+7JgdSkJ3eAT1nMPGCSD88A0NtppgPnAgn5HQg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8472.apcprd03.prod.outlook.com (2603:1096:101:21c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 10:35:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:35:52 +0000
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
Subject: Re: [PATCH v7 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Topic: [PATCH v7 20/23] scsi: ufs: mediatek: Back up idle timer in
 per-instance struct
Thread-Index: AQHcn0oP6tEnScLyfUKovG8pABVQS7WTRnGA
Date: Wed, 25 Feb 2026 10:35:51 +0000
Message-ID: <5d9723fd6b4ff8430889efb33e0fc93a10c4a880.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-20-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-20-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8472:EE_
x-ms-office365-filtering-correlation-id: 87cf1171-7b4c-4d5b-e22c-08de7459a604
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: 4mP3fejSoK2TWiZYS2bt30R55eNAZJAWFHvdpjp69QzExanCSOVpzrEl0+BUBkmLFsdJrHqxQDlubrz/8DSdtqFFhXK0hFDph/OXqNtvgHh2r5aNkVX05mz/WItVnNE2muAmw9p/Maje10jN7RziyAYweBjcP8M/gk/gH+/5XRqo+A44KwtuGCxGgcWeGdIiWsOuu7O4lzGlvHl+ratmMqyLoVrt/zUhpkv56snMa/v30E5LGSD4lce3uM+NJSX+plNhyPQ7j20wXEsm2veFpbw9SAZATDK5qTWMfpeet/ae6hReclBoDYukdGq6py1hu0dgDydDwnv0XLltXo8qq7mfeJIRqrevwCeTP7wChY2nUs7a4usJSItsblHmU/WqIn8o7nmAhsVSKCkYPIAtsI9VRRUAcR4vdNgPUvhQfJw2NbNFKU+hmR3DqiHBA0TijEWbAmOIflbc4qkGg18DLyQ1SGuP/g6zmPiq97zbzTT8SL5BH7vdtIfVMG7Nt2E8lpMgPyhsbdD2neae5GacvkMrJAXo4VDR9+6UfoGBm9dAApJwjRkKe4chlAfEX+s7JIuhFn7AMINSfPyT1oHdFm76MKRB5au9S0jMnucUYgjg0GFga7Zj5W2mww8rsBBNFEZISOcGz1PsdEjc3GMcgpL4qK2ME1Sl3IU6OCelK7KnssGPs4iBszLI4EuT80G9dmwSs5lU9/qpASNYoQ2W+N/zz+Rib+Gh7zB7aBUy48nJvroLLx9aVIbxBiHzv9UNoM2jEqCLyR9zP3+MeahoIu3gR4ziM0EEk9sDtLIXz6ps4H16+di1NrCHOeZqPd8e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVRxZzVQMkhLbmZ1azczVk4yc3lPNDlzaU1ua2xYKzVGL3ZWTzFicXlaV1NC?=
 =?utf-8?B?YzBkNWNmOEs3bWRBT0wyOHJkZDdsV1BWQnlONmRncFRyUTBOUkdNYTZpTUZU?=
 =?utf-8?B?MURYSk5OTTZ1WkNyb1B3dDJuYnFnTU11UzRDYWQwM0IrWmxlcW41VUZIcHpS?=
 =?utf-8?B?bzlZNG1qSXkrNHZacDVaTUhOczJUT1RWNWt6N2JuZFgwTzhqcG9GK2NrN3pp?=
 =?utf-8?B?TnN1WENZTVdWeUR1djNXTi9rM1dlRkZxbDRRL2piem5PWEFJVnkxVFRLd0s5?=
 =?utf-8?B?L2Y3YnM5VkVSNnNFYk9ibjNJWjAzWTRTZU5lc3plV3BUaFRua1ZjNmc5RVhm?=
 =?utf-8?B?b0Y5bXN1L29RK05oK25TZlhTOW8vZ3M2RFNzUnkyZk10RW9Db0FJMVpkdTRo?=
 =?utf-8?B?RTlDaCt2MHF0bnJwdHNUcmhjTEE5U0tRS0Uzc1h3SG91eEpXMklBc2VKNE0z?=
 =?utf-8?B?Z0crd0ljcjdPMlZoOGxEd2NOU1AzeDlScVVkUzN2MkoxRUhBdTNaZFUrL3Vq?=
 =?utf-8?B?RXhUWnErdEZtOFllRW81SGRYN2JGNGZEWWJoTTBEbFRsQm1GRjZMV1NYSEpH?=
 =?utf-8?B?Q3RTTTJqWEZNUzNGT0dGTTc3Sk5uVWNzUmtIZXhRWThlUUF2U3FCY2xUSDdQ?=
 =?utf-8?B?RnIxaVFEczhQL3I2b2kxYWdqRU5sOUIvWGVZckVzczhTVTRFL21JRGZsMEtk?=
 =?utf-8?B?SmNwYUhGdGZ1QWFrUkJZRHBKd0tSTkFIUTkydjJwMndTMXlnekkwMFZCWFVt?=
 =?utf-8?B?czU3U3FMMWRzc0FVOWtpUTJPcGF4OFlMMUJEVGYxY3dDRnFRVklFRzV1eE5v?=
 =?utf-8?B?YjhoVGVTSklBelNPdXVtSlBRWFZyaS9JTmE5Nlh3c0k3SkNRRERIK2ZnaXo4?=
 =?utf-8?B?MzNFQU5FQ20rVFprVEMwR1F5MTdoVUVaYmd4UFZjbkg2ZlhNMTdYT0gwUS9w?=
 =?utf-8?B?Z1cyc2lHY0Y4WWJHRXZZbzk2emo4aGFQK1NZODhaZGh3UFVjeXpuemVYWmhX?=
 =?utf-8?B?bmFHcWJUa2NYOFlUREF2Nmc2cUxadldwM1phamR0bEdUcVJ6anZQNDRheU8x?=
 =?utf-8?B?YmRoUEN2eWhDdElrU1paNTZGUWhpZjBlWTJtUTY5NWdZTy9IL2VHUGFJZTFy?=
 =?utf-8?B?OWJWSDh1emtwcHdhb244cWFBRXRxcWhBdTdBYm11b3Q4L3lRWm5SLzAwcnFx?=
 =?utf-8?B?SUJCUCtIV0ZpS2lqYVJmdk5NMnFrNW9TNUtPbXBZOFh1T2M5TDBmamhsSE9G?=
 =?utf-8?B?bHE3cVQwTXdrYlN3dXMzdmY4eGFyZS9zdS9YSmtrZ2x3ZlJjOVRWelpKUHFw?=
 =?utf-8?B?R0tPU3ZXSmI4RnlRSVREVks3cHNkSjZMbVlMMnRoREZzREVHSC9UUno1MFRr?=
 =?utf-8?B?WmFnbzJ1VjBVYkJIWVFPYzMzVXFmWHFxYWw0MnI3NDI1a3owVUU2R0JPdEE0?=
 =?utf-8?B?UWs3UW85ajhwZ0VTRlNHanlhb3NoS1k3SkQveFE5MXJVQXNldlBhZWFwWDBH?=
 =?utf-8?B?M1JVejBYWFg3bmN6cWNiekExVXZTcnpPTFEzcjBZVW5qYTlSUWVwZnJrdExn?=
 =?utf-8?B?eU1pM0lGUlVhWVo2dGJmc291MlNOSm1kcW03ZktZenFaeVBtWUIwTGFIZXBT?=
 =?utf-8?B?ejFQUHZoZFhWcTg1Y2tqcVA1OEM3TXJ4WHQzRm1LQXBNUHB0Nm5TNzVydkM4?=
 =?utf-8?B?ZjlodUFDSVVsTGhHeFB4REhYUW1ua2Rwa0JjenZqRGVHeFc2QmJ2Y2xJRVow?=
 =?utf-8?B?UHBwUlFSSEZLSk52RGE3T3paR05BK3RiMy9IekVuREl1cDJYZVh3b0svNElM?=
 =?utf-8?B?UjhuYlk1MitrY0NQZEdTSkw3MVNkcHFVUWhLM0FGKzRHakZLWFF2eDRpVlZj?=
 =?utf-8?B?TEdycXZNbUVrMmpkSFBDWUlXbUtOWkU4YzZBaG03VU42N2NSclQ0eUlqY0Zh?=
 =?utf-8?B?MHBtcERuM0w5QlJBYjhPUFJjTCtueFdVR3dnM0xDY1Z0eCswVkxrcFJyZkpS?=
 =?utf-8?B?UzAvMmtCMW42YzJTZEliZG1abHRVSUk3cS9jMFdqbG1yWmh5VTRSRUFUdU5q?=
 =?utf-8?B?UFhYQlJRZ0IwbTBUaVdNVUtKc09hT2pNZWFYN2pHRy9pMzdXOXJjV1I3enNP?=
 =?utf-8?B?THMyaWRNaWhDUEF6RGtrY0x2M0YxYVFBSjdSWUwyd0kyS3RQNTZUdXROVGpQ?=
 =?utf-8?B?eWh0K2pZcWdLVDJNa01xNXYyK2d3VTlRVEJtTlg4c0tENmF3MDJMNmF1cnJH?=
 =?utf-8?B?Z0RxV0Q2ODlRMFUvTVRWb2JEMTNiZlpLRE5BZDRaUlNxVUczRHdFVTZPZnlk?=
 =?utf-8?B?MjFVTUg4Qk9yYlRHT3JYYjRnVktYYVd3SWl4S0FpaVdQNTlVcExENXRIMXhk?=
 =?utf-8?Q?lcBznqs2plXOqHxQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B92546EFDD8AAA4F8B9D7675BD9D92DF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: AzjOqdQxsAauVDfZFr6fbPCrHnb8+23fqEDxSEfLMvKnVgC3tkgELUSqw0orpx/Va3T3vdJmOT7MTNAsARZ3jPoNIX9PAYqmgOq9ZnamtEXFuF9vLO+kMJP6C14ITCn0nbrhfynUgRxJcjozGMymP8mzKb4yk+SqipIykoiVjysqSJC17MHnBEI3HuH27T3BupA5t/UtWF8EtMWgkCMIpKGxurerXdEVDb1WYJ/rP9gW3OzjDfCNvL2KfU90qHSQw7P8aorTX8NMrqTMXr8bAjvys2CDNq/nPfVcBq9LiDhMrWeEX2GXQgH14eLUHludzj2IF4CMMSvU+49T6dA1PQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cf1171-7b4c-4d5b-e22c-08de7459a604
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:35:51.9155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3A9nhbaH6IvSzhS9UWbIu5m1HPHY+ks0Kwp3VY2O9ZGMMXS7N21vdgGZaQTzB9sK4zAN66t+qJ791a9Izf2qmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8472
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEBAIC0xODcsNiArMTg3LDcgQEAgc3RydWN0IHVmc19tdGtfaG9zdCB7DQo+IMKgCXUx
NiByZWZfY2xrX2dhdGluZ193YWl0X3VzOw0KPiDCoAl1MzIgaXBfdmVyOw0KPiDCoAlib29sIGxl
Z2FjeV9pcF92ZXI7DQo+ICsJdTMyIGhpYmVybmF0ZV9pZGxlX3RpbWVyOw0KDQpUaGUgbmFtZSBo
aWJlcm5hdGVfaWRsZV90aW1lciBpcyBzb21ld2hhdCBjb25mdXNpbmcgaW4NCnRlcm1zIG9mIGl0
cyBpbnRlbmRlZCB1c2UuIEkgd291bGQgc3VnZ2VzdCB1c2luZyANCmJhY2t1cF9haGl0IG9yIHNh
dmVkX2FoaXQgaW5zdGVhZC4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
