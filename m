Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9072EB86B;
	Fri, 17 Oct 2025 06:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760683966; cv=fail; b=S3oZLxMZ2nkCY0yt3dmZLYTSweeV+24qROzgQv4v5Y0vi13tmq+Jld72PnQgC7h3IX6jRWY5B2bPdvgETdOEAuP2n/5BVGKfC1l0ythE9EdygnrSYwM9ZB7r1jgBkYDHCrAgIx4Tdu3uFB5IG+8hBxQib5jY3eTXHmz0oTuWm/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760683966; c=relaxed/simple;
	bh=O9exOz5/ANQVaQLKrQy866+zEQ1fZsbQvE8kWWRxYok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=smRSxuHxY9tE/bGQtySGGnKXfmzvq8ZY96pwGrENeXqP2KKTFH1tYa/z54hFV31oWJQaTu+3xhIJMnXVdUpC4vAh1nwJDx2u+arZVpi3vzh9RJxgbkmDu1XneT+ICuqWILkJbZmrPC/V/6QKJsNCm7XVG5XPcwnVNx6QpNWEFl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=fail smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=kkjj4Gxz; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fqXumCNK; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="kkjj4Gxz";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fqXumCNK"
X-UUID: dea8720cab2511f0b33aeb1e7f16c2b6-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=O9exOz5/ANQVaQLKrQy866+zEQ1fZsbQvE8kWWRxYok=;
	b=kkjj4GxzEhaT7AFbA+2o91rbHnY1gwDRoptvYVc4pDzkf883Qi5FMt+ZkuzgXnZcLRZmMQ5qkq56Mn2a/Yk1xfOJ2XnpJxKayUn2Qp2Kb8SDALwdHIxPw9TJNuEnYP9n8oxO2I8DVivkaw7nAUwGHyy0P4CGebGijX7AhPU80Qw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:e1d34013-eb5e-4099-8609-15c01d34bf58,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:6e412951-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dea8720cab2511f0b33aeb1e7f16c2b6-20251017
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1787921990; Fri, 17 Oct 2025 14:52:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 17 Oct 2025 14:52:36 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 14:52:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kp5d/o1W5UnZdTr3h7LFIii3BCiVpoAic9Oqd7onKT+eDfXlHw6k6jkiojO25tsYByndTzVtUBIAlpzD2EsCBnbNLPXBtDAaWs0e7RX2JZduGOJuu8q3znXy/a65JX41huoVFIJpcgIoXpksb+MSbRjqmePDeTEWvnTFeyECEZ9UNk2pXBZowMonMDr+ubp4sIJ81pxy674cdPJh6PMuXXcYusywOlhRy1IrtHU6m8fVq2dTjFzXzw2l9OAvFDNy8//A0hg8d2XAm/pSJuja0nFlZoVrPrSd8ExYi8LolFQZQFqoCh25EkIw1j0DMY1lsH09Y8n3aEyxMBCnFiefyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9exOz5/ANQVaQLKrQy866+zEQ1fZsbQvE8kWWRxYok=;
 b=AQDl6i47YfuEgHBIir+V+SvldpKZC66arU6VVT7V2aDb1+RjUSTTJ4zjeZqbQbgwfuhX77XqT9pyEcKo7Y/jPW91bx81XMNMK8VR7xclvCW+UvljaySHuONhPJU/7WpnbAxsqFZ5P5FTl4YIo9qaUGmVnm6RPiD5D92VI7PNKYMmYmu2jGCNDlbmFVKN+97904AKAuij1ce2Kf6sFqbQiKZyB4ZG7q9P+6PeQeWt8GMr4rdnsR23Ib99N2X3LUfLRS/hGxLUIis6Jm6kwaQaI6x80bQcU4kC6ppTBePRAYdcy4h3r1VAZrI+RKDb0tLuKycXj1hyzo/23jhje7uXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9exOz5/ANQVaQLKrQy866+zEQ1fZsbQvE8kWWRxYok=;
 b=fqXumCNKCLqVOaxKqeWgZxcFxZ1/s/YA/sVlnmrKZjqQCREnKpALu2+9y6dFqhR/3n2WzG7C5nwsh9YnLkCHfJZHtBtfRAbwnTChigM/5WVkYoEGI/Ze6x1oMu10Zo2MGgrhNXE3xh/B+1zWvpZEv2q8bwVQVSXoVD+aOMOaKrg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9367.apcprd03.prod.outlook.com (2603:1096:405:2b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 06:52:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 06:52:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "conor+dt@kernel.org"
	<conor+dt@kernel.org>, "nicolas.frattaroli@collabora.com"
	<nicolas.frattaroli@collabora.com>, "vkoul@kernel.org" <vkoul@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "p.zabel@pengutronix.de"
	<p.zabel@pengutronix.de>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v2 2/5] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Thread-Topic: [PATCH v2 2/5] dt-bindings: phy: Add mediatek,mt8196-ufsphy
 variant
Thread-Index: AQHcPpWEg/8+UVNVp02GbcgD5FrWLrTF6AyA
Date: Fri, 17 Oct 2025 06:52:32 +0000
Message-ID: <36e21001c868c47317b56d5aed86b5207e6e981e.camel@mediatek.com>
References: <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
	 <20251016-mt8196-ufs-v2-2-c373834c4e7a@collabora.com>
In-Reply-To: <20251016-mt8196-ufs-v2-2-c373834c4e7a@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9367:EE_
x-ms-office365-filtering-correlation-id: 65c15985-124d-465d-879b-08de0d49bf03
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?azRQQ0lNcy82YU1EellqZGUrMmVvZUQzQkVnQ3dMVHlCMTFOV0ppNW1kYnQv?=
 =?utf-8?B?K3dkZkUzQXpIb3FCQ08va1cxUERtOTdISWxBT3l1TlYySTlpVVVJelJuOU81?=
 =?utf-8?B?Q3ZGN29wYWx2RDA3bG5lR0kzWldOc0dCblJId1hrVTEyR2pWZC9xVmhGaDBN?=
 =?utf-8?B?RDc1WXdPLys1d3pJVCtCU2pJYytqR2RYU3ZzcStCNjZEUjVyTUxuc0hUbHdz?=
 =?utf-8?B?MmpWaFMyQndsUVEvalE2RFdwWHJnOUdwNUE0TERLTTRWa3ZpcjdGOXcvazFj?=
 =?utf-8?B?N2dUZG5UM1FUd1NXY2dBWDhHb1FRZ1YyVmNYdWdYOHNuVFZxZzBlWithbGtG?=
 =?utf-8?B?TTBQZlhhc2ZZQnVjQ2JZZWUrMXVjd2NBMXVLZXNxL29sakYwcTdZSWEwVlJG?=
 =?utf-8?B?ekVETHY4OHJvWTJCRlJqdCt4eXN2ZG1YYWV2ZGlRY0pWWmtBNUFGNEpKOG1j?=
 =?utf-8?B?TE9FRExaQ3pHbWlDc3FLeDlwQU1OOVN1VWZlYWZ2TWFWbEF3V1ZwN0hvd3Fq?=
 =?utf-8?B?YzNtV01XNHdNODhJRTg3OVZqMktTUGRNR3Bwb2prN2Voc1ZIVHIyYW82UjFw?=
 =?utf-8?B?TmoxYk4yTmVNVjVpSll0Q0N0eldiYWd6ZjA2bUc2V1gwc1RyRFZQYi9QRVlT?=
 =?utf-8?B?Qm9wWVVDMlZXc2lXTk81WHNpazJ4N2JoUFQ2amVPSWR2bHFsT2RFZEhNc3ly?=
 =?utf-8?B?OUl6N1FYbEM4SlB4Z3RiUUtnNVgvcEptaWNnWGRtNTQxV05kSVpiS2dTbS9G?=
 =?utf-8?B?YU5iUGtKbFZ5dVRadUsvYkdMNjdiTUtRYnpqOTJxNzhBU2g1Mm9raU1WN0Ji?=
 =?utf-8?B?YVUrWUlmN2xTUlJSSkdVci9aUXVjTDQ5VFdGMHlQTE9FNklGVTRORFpnRUJx?=
 =?utf-8?B?RUFwZlRVM2lwZmxLZ0VpZ25WLzhFVi9kMFpPTjlSNTNBdnNTYkJ6aWM1a0pC?=
 =?utf-8?B?anUrYS9McTk4WlBrdW51WXhCQjU1Q3UyQkJCaCtPNTJiYldIdDhiTVhiV0ZZ?=
 =?utf-8?B?Rm9vbVZGUkxjRlJJWWd2TnVhMDVSK0VFcFBZcFIwSDY1aDNTRUVDaDdNRTZH?=
 =?utf-8?B?SEhnSDl6T1paV3hkUGp0VGd4VkErby96UlhHUXN4bnNtbC95bTRibTVnVk1s?=
 =?utf-8?B?Q096UERTdmNsYVpXWTNYUjlCQWJkSDBqK2NGRTgrWEZFdzhVZWpKTE02N0pE?=
 =?utf-8?B?ekk5QkZGV3llNFNzZlR2SktNWVppSEdEanRjVDlNSXBmazZXUU5xMDFaVHJy?=
 =?utf-8?B?TWx2V3crTHRTL21sQnRtaVZhSUllRUF6YmJVTit3cHJtbE9kdGZGS0F4bngr?=
 =?utf-8?B?OWkvOVBOYjExaW0rRTNhakRzWFRuYXUxUUZTaGNKTXJNWURHbktyM1VXMTdB?=
 =?utf-8?B?TGFEVEp5cm45by9PUHRKTWRRaHBHV2hmMXVxbnpseno1RlB1ZldRSEFqYnVz?=
 =?utf-8?B?OEV0VzZYdlQ4NnA2dnI4bTl1cU1LZm5SQnRrTUJFZmFwMzZIa1pTRldQVG5C?=
 =?utf-8?B?dW5aWmVkSmJQY3dsdzZiWks0TldiK05jb0VsWE5SSUVnaHA3SDFLTUxWKzNY?=
 =?utf-8?B?YXdOelNxai9JVkdiSW1BNklXaUU0UUZXajRwc0ZncTY4UGFIWjVkdFNmVUpE?=
 =?utf-8?B?RUNKZC8zVTFid0szcFJuM1BTVzhzanRySUt4YWZvV3FuTStTcUJ4SWcxb2ox?=
 =?utf-8?B?TERTK1ZPMjFWM3VLNUVvYS9XamxtMHpQS3pSblhpbDEydGxFTFVWQmpaZTZt?=
 =?utf-8?B?dlA1c2JrKzZudXVxc0p3OWp0TzdpR0k1K0EwTi8xd21rVnhFcDNiWjI2RzN4?=
 =?utf-8?B?Y0NkYWl2YXc5Nkk0OTFNUWVwc1VacS9wWVQ5eGxOSjhVci9ja2U0M09tS2wr?=
 =?utf-8?B?MDV3MWR0Y2c3ekxyQ0ZrWHhoOHdsdXZkRkRuelN3elZUbFBMZ3pTSDVqTUJT?=
 =?utf-8?B?SHRRZWZCeFk4NWFjcVZkUXczNHNTa1BmaU1hckdwQXFwRUw0MWQwZ0pUdFJn?=
 =?utf-8?B?SlpxanN4aG51d3VLY3dXNk42dGErcUxPakZEeWkrNFRwdVVjTDdGWGpqNWNZ?=
 =?utf-8?B?RjlVam5tckFINVY3T0NHck8rdmdJb3RjbTMzZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a09YWjVITnhJdnV3TEYzWDdhWDgyK3VDN1QvQ2ZRNUxqbURyc2I5NEtQVUNB?=
 =?utf-8?B?MDU3eldmbDRmSHZnTkRxTkI1bzNocFVuWkFzVUM2LzNyRll4MjBJNzBHamti?=
 =?utf-8?B?enNWRlk5bVNmb3djbjBheTZ0YmpCSmdxdEY2TWkyK1RHVGRJbVMwTDZ0bGtB?=
 =?utf-8?B?bXpzbURGTUw1a2t0ZGZwNXpSbjRaMGQ3bmlsRms3YXpvZzJqQkJvWmhWVlN2?=
 =?utf-8?B?M2w1a0ZweVFKUU0xQjArRkJjSVJqMUhxZlZPQ1ZGZDlacm5IZHREeWJ1MFZk?=
 =?utf-8?B?c2VSQTZuNWwrWkQ5VHp0bnlZd0M2dTAxSERVTmhSQW5JSzR5SDcxbWprMzkv?=
 =?utf-8?B?ZEt4cy9ielowQllCUkVvTzlRZVljampwdGtYbU16R1cwNDV3Q1BGY2R6Y1Iy?=
 =?utf-8?B?c3RrTWtiS2RQeVJiT2VRWWxlaEZONm1yalZmbjJhT0lvYUZ2VWxKMDdlZTM5?=
 =?utf-8?B?cGU1U2RSU2NpaURrdkxLN0w3bXI0N1NNbzZhQ0t2U3lWdmRsVmlkQ0VWbFE3?=
 =?utf-8?B?YTFxbWhuZC9jMFdvK1FndndFY0h1b1pTNnNLSEFFN2t3M0VzQS8xMWkxZFdU?=
 =?utf-8?B?VDhYbTRPQ3A3SkQyVTBEM29yVk9aRE0vaDYva2NGUG96cHg4VmJva3ozM2Q3?=
 =?utf-8?B?RFFwVjYzc0FrQ1piRjdCNEROOEFRSTl1d21FTlF5NXlsK2dQb1ZPcHhJcVBU?=
 =?utf-8?B?YzVYL3c3dmhGQmptYzR6ZG8wUHNYV0JjSVAvTWw5dU9oVVJTTnJDV3FVR3hU?=
 =?utf-8?B?VmRQUG1LanBvTzN5clBTN1pxVGQ1QXY3OEFDaVhTMkhWUzdwNWx0R2IwaUxp?=
 =?utf-8?B?eXMzYzI1OWRadGdlY3dlMGJ5Nks0dllVYkF4bDRUWnhYbEdaM1Q1NzlWcDBO?=
 =?utf-8?B?TzRtaldTSks5LzdVdEFiNEd2N25PMEgzUnBqaUYySXl0amxZdGdhbm9hY1k3?=
 =?utf-8?B?WXVLdUZhNitSN2tJeGR2eDZubUYwQi9SMEdBVWtPWDErMURtOWs3Z0MxMUxl?=
 =?utf-8?B?K3JXVEFLSjkxRE93cmErWU91KzQwYUFWVEEvLzMrRWdJRWVEMXV1M2ljOEZG?=
 =?utf-8?B?MUJGTndJQ0owWFl2UER1cDBkbTNoV2RFV2JUa1RQazg4VWdyQlppMURqRFg4?=
 =?utf-8?B?ME83Lyt5bE9HUW0rYjlxQ203M2NFVmZIWDdyL1J6MmVHbXhsRzJaamd1NTlV?=
 =?utf-8?B?Mk9Td05meWRVdnVhajh3RFcvTDdPalhvQnFCclFRQkJCUnVhdExPdnozSjEw?=
 =?utf-8?B?cU9YUWZuUlBpQ0JhNEE4WG1uUWR3andIcCt3Q01zaklEanpXR01wMXlXK3Zj?=
 =?utf-8?B?dEh3bXp3WUV4NDZzb1NSSEhzYUJFUzVKUHZkUXUxeUtaaVVLQnYwNGxwZU1o?=
 =?utf-8?B?Z0JxR2JTRmROeTBvVE1EU0xWUlpqSmRBNlB4dmlHN3hIRGRMQlNjWGJDeXhh?=
 =?utf-8?B?YllzNExVdHdRRVh6dy9oUjlqSTF0bm5aeHYyTzdFdkZWN3dIT2ZGT3N2SnVX?=
 =?utf-8?B?MVE0RGkyT1dqa0VHQWVXRFdkc29KWE02dFNCYlkrQTRNSGUxbWJYMlNma0pq?=
 =?utf-8?B?MGwwQ0lDK1hVdXYzUVFrYWtiWVRzN2R2L1lpRWNXNkI3a3lUMCtWQ1lwaFFh?=
 =?utf-8?B?MGNMc1p5bzU5THQzNmRGSVI4T1psWU1hTzNROUZORW5IQVhCYm1sWWdFSjB4?=
 =?utf-8?B?NXJKN0JsNFcxbFlaR1FFRlE1YWNpRW5ZNERzZnZyQ29qbmJJdHhvZzY4dExC?=
 =?utf-8?B?eVk4a0dkTVR0eFkzaHZmNkwrMXFxVm1sei82OUR2WVlMK1hPTDNDK3JpOVVN?=
 =?utf-8?B?Wjd1V2FwUmoyRzhVZ0E4dWluNnZLckxDbXFzQ0dxdXRvRk1JOCtjdDh4UUtL?=
 =?utf-8?B?NGs3dVV6UEJMRmN3d3BrbHdERXBQRWxkZERkMlJuaDJyUEIvWmhMOFNyVzlS?=
 =?utf-8?B?YU8vT3daQ05YV0tzVzdLSCtUbXBWNEF3RWRrbnZ0a3FxSCtvQnZzcWlPUzhv?=
 =?utf-8?B?Q015SHJkU2c0aU1QMGY0S2N6VUQ0OGtIY1VpaExwRUFsNGhDZ0lab1p3STVY?=
 =?utf-8?B?Y2JGbkl6SERXamt0c1NtbWdNeWJkNElJUUZBYll2NVZQYy9PYnhubEx6VnBn?=
 =?utf-8?B?UmtUYUp2dHhFbEx4WnRXa01oNzJhNDZGUE1aOEhkNytlcDRWcjhnYlpVWWVh?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FB587A305DC3B41A832A84AFBAB43C1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c15985-124d-465d-879b-08de0d49bf03
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 06:52:32.1510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vzz6HSMYawVigHJbgBvTigGXwUCpbW2N78XdWA5Lt7rWNVLi3vpBCFvSRrMHy7UX5IPD322zZlg6MA6hF0yrFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9367

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE0OjA2ICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBNZWRpYVRlayBNVDgxOTYgU29DIGluY2x1ZGVzIGFuIE0tUEhZIGNvbXBhdGli
bGUgd2l0aCB0aGUgYWxyZWFkeQ0KPiBleGlzdGluZyBtdDgxODMgYmluZGluZy4NCj4gDQo+IEhv
d2V2ZXIsIG9uZSBvbWlzc2lvbiBmcm9tIHRoZSBvcmlnaW5hbCBiaW5kaW5nIHdhcyB0aGF0IGFs
bCBvZiB0aGVzZQ0KPiB2YXJpYW50cyBtYXkgaGF2ZSBhbiBvcHRpb25hbCByZXNldC4NCj4gDQo+
IEFkZCB0aGUgbmV3IGNvbXBhdGlibGUsIGFuZCBhbHNvIHRoZSByZXNldHMgcHJvcGVydHksIHdp
dGggYW4NCj4gZXhhbXBsZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbmdlbG9HaW9hY2NoaW5vIERl
bCBSZWdubw0KPiA8YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KPiBT
aWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xs
YWJvcmEuY29tPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdA
bWVkaWF0ZWsuY29tPg0K
