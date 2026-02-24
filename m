Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEE037FF43;
	Tue, 24 Feb 2026 12:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936849; cv=fail; b=NpJAtMdEvMredj5e7Qbtw1vOnoSYUk9CfZYe588eKeDbzLf+L8Oqbn/l9k/ziYNZHAplf6hMjF36mwiwaVObmhrXouJoxqILoSBZw/U8ZFqO3P5+UPcszWWztjv7zZNeOq3kvTmS0IJf3KxMcNSaohrahv4Xl7jcQwJSl2YRKHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936849; c=relaxed/simple;
	bh=/+q/IsLRODeIjUONRdn0GKdML/tdPctfq9hv90iByP4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BrLHLmHckxYgbksAjFKkqxsK+LNyHv4BhFeruRZr9CHSTE78JUTQRCVvXoG4Ujn/Rqrcon6QHx1jKdL8MgjzsJXkrCMWzqQTr5Fu+y4EP1XrDd5IRJ/5B/DwbWeixN05WF4bV1ZBGVTrS9MVugz70Nv7MFyWOiknCkw5sWrxMJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=trrUIU/o; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=sNR09GM7; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="trrUIU/o";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="sNR09GM7"
X-UUID: 06255282117e11f1bcd7499a721e883d-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=/+q/IsLRODeIjUONRdn0GKdML/tdPctfq9hv90iByP4=;
	b=trrUIU/oAVxfVmlqM0BqbVanhKm4BSwlHl0eHfHYNTj6ZW9XyXKVjWGww1RI+poeHN6LtqR9sLg0H0KXajoEUCQHdLHu6qtXPynGLM6ojTUgAl9oitql6WGnxXUA4LVaiEowYkCuYRYnZCfaEZ086DlfT5VTSWut1iJr0DW7Sdo=;
X-CID-CACHE: Type:Local,Time:202602242040+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:b2b24fe8-3eab-4026-ba08-059057e7cbf6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:5ec5f4f0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 06255282117e11f1bcd7499a721e883d-20260224
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1694282976; Tue, 24 Feb 2026 20:40:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:40:38 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:40:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezP02sogtGcO0qUE43ZFQRerBJKf1MAFyWDwbMeK69eMLZoJbrLTivHZSYZ//vL0B/PVaFmpdr6zoAdpY1uRwj+JlA/PBoWPvS7QPrmIepzPPQkzrwbNqbneDixzDJE+cNXEapkHKyE98eyIaFXfNdeuQqsIWesaRglVVZpKld4kDp+UBku0knc7vkUssQF0x/Qu2eHfEe0CMKF+AUVyHoJX2bd2HPgSXqXI80GZnwoqlu42kuEpiW+zCMeFTuEIN9oK1+i04K6lZAKmgHB7M7DLtm9kooca1xWVp90wh7etMUF5mf0mkMvv4mXXQm8lwz86y8GfjNOFobgFcsoQGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+q/IsLRODeIjUONRdn0GKdML/tdPctfq9hv90iByP4=;
 b=TkZe+/mkzFwL/D3bUL8kwzJDAAJOTu8Hw6ARIoOCANu7BHNJ2ENrVAxBfsHvU0WtumhtOjPyH5V/HekoiY6v++bgDl2QEybeMfyYRIWjDjLqP0FQJk7NVG8bkYl3oroPn62VaeatqS1UWxZzPbnjRY/+SS3IxVW/YwbUIVIjqwOL2Z6SB6tbrDrvBA6zn9s5pZBrSprGvC3yWEEtWRAl8JMpEe11hvoidc94Y1irHshodEUgMfYNOylSirE9Jp5pJx67tIROeX54zWMGaDr8KpbbY44Ex9Fw/n099MVMbdctxGuY+hCxmfSCoY2EOlBII4FfUH+07A+YBOhXKCFw+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+q/IsLRODeIjUONRdn0GKdML/tdPctfq9hv90iByP4=;
 b=sNR09GM7vGyrL2JiKWw3TzZme+VRiGES7IHPSuHnRxCxaFDAOTIMW9BRsoRpH7N2SL6Wp86z2PNfIryWBMxZJa+rJij4ymybQKX1NSKUsvPu9ZJWnckSkJAMpAd5K3hUVMET2UPQ9cW10hCZc9ON8oZKmtNUIk5wmh0NuugF0UE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:40:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:40:35 +0000
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
CC: "krzysztof.kozlowski@oss.qualcomm.com"
	<krzysztof.kozlowski@oss.qualcomm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "devicetree@vger.kernel.org"
	<devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 12/23] scsi: ufs: mediatek: Remove vendor kernel quirks
 cruft
Thread-Topic: [PATCH v7 12/23] scsi: ufs: mediatek: Remove vendor kernel
 quirks cruft
Thread-Index: AQHcn0nUom8BSMnu2k+5QUEStmX5v7WR1vUA
Date: Tue, 24 Feb 2026 12:40:35 +0000
Message-ID: <428c4789ed51b911d325fabc1e52dcc7e8ecb8d0.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-12-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-12-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: e7fce28a-289f-46b1-8b52-08de73a1e812
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?dzRoVHphWmlDQjBkbTAvSkVzWFFKRW9OT2NlWENibk5ObUhwSm1VM3YvcmxK?=
 =?utf-8?B?ZG5wZWhTNHFDdVlTVXZVWi9MU0hYZUFWbVg2Wk5kZTlHY0FBLzVMRDE3WVBs?=
 =?utf-8?B?UjhhMmJCbnBLbndmQ3Q0VXh1Wm1RNHVldy8yY29COWs4YlZmOEV6eWhacHVU?=
 =?utf-8?B?S2lwajBhd3RRa0RsUlhPZXk4VGpUdGtFRUgvQnZESE84dlBBb1FMVG54Z2lY?=
 =?utf-8?B?MDljWERLOTZJYWc4NUMwVytvVE11TEE2MHRoY2Z3RDVZNm5mdU9JY0VOSHpp?=
 =?utf-8?B?ZjE3bnIyU1J6Rk13UWdwTGJYRys1TmljdXhtRHR4U3BPeUxQbjArS25SemRk?=
 =?utf-8?B?anRjenBIdFZSdFV3NmNKeCtXWERSUzdMbWQ0MGhFMXRQWkY2MGlSYWRCQ08w?=
 =?utf-8?B?OWxHanlwNlZjSmxYSytxUTVMb2dJL054QnNYK291dG1kOGM0aEVMUXVwOUIz?=
 =?utf-8?B?UCtQZE54Rk9IeEhoM1BWTmtWMWdMeXl4UkJ4Y3NVdHV0NWNManR1WlIySDgz?=
 =?utf-8?B?YldKblo1dENieTZQeGlZWGJvZmhiNXVIOUdFMzlCY2ZJMWxOczFHR2JzdDJj?=
 =?utf-8?B?QU5RakQvd000a3VNOFMyZlROV3BqWkY4WWxZQUtiVHRsU2ZTSjNyeDFjQ1lK?=
 =?utf-8?B?bEZJb25RQnNOcnliMXpZdEp6MjlvZFVuL2lhaGhNNStvTUlXQkhpck1Fd3Fv?=
 =?utf-8?B?RXNraDNaWDRYcm5qV1RIWTlsVFBRSzdsNnR4T0lxdWdTYnRsc3JPOXFrWi81?=
 =?utf-8?B?Zmo1ZnNKN1Nkd3ZFUjBHTFAwU3RZTTVBTDVlalNZcEFzWFBnc29VUEl4MWUx?=
 =?utf-8?B?RnYxQzE5N0Y0SE9KR1o3RWdaZCt5UTlnWWI2RVBheUU0TGZTUktPdmM0VmVl?=
 =?utf-8?B?U0lveFhnNC9QcHp6TUIxRDBjUnRXYjA2NEtqL0Z0cmFmZkprcHZhUHVEaWZJ?=
 =?utf-8?B?WnRaNXZ4cVNsbGdXY2pTWHNTS1czVXg4MkdVbXF0SjQ5RXBJNGVoUFdIUHBw?=
 =?utf-8?B?RVhHR2pYVUhkN1g1YmlpVUVqb251bmVVWkcwcTdmSFRlWVluMVpDRzZOdGsz?=
 =?utf-8?B?ZDJLNUJTeVhRMUtxSG9id1QzcndINWxIdm1wQTBOakQvZGNCQS9vR21YVU50?=
 =?utf-8?B?STVJK3BnZGNHTUd4T2t3b1pPZHkvRVRqcENia21YeDYrWERGd2NkUFhPY3lu?=
 =?utf-8?B?MGFRbFN5ZjJ0eVNkUVVEOXh6TDNXOGw3R053WUU5S2dHbDE3M3g4OE5KREZO?=
 =?utf-8?B?RHU2eDRkZ0FsRUVHeE5JajZiekN5NTFjQ3BNT1RjamxDZDR1bUN4UWZuRmxH?=
 =?utf-8?B?REZhMFhLOXNNL3pzM294R1dzMUZDQ1hmdnJ1d1gxRGlSdGtHR1p4MXVNSHVJ?=
 =?utf-8?B?akJuRW1DY1VQSUhGdTd6OTRUczROVDJCdEEwZE5JQzBFcUlKaEFMNWJURDhw?=
 =?utf-8?B?K3ZWRnk4V0RLYWdCbUk2ZWE5Q3hHdXE5TDJqeHlPaXhIUERqRUQ3ODMwRDNG?=
 =?utf-8?B?ckRhYXNBYW1lSjhkdDdEMnhEei90RTBTUXN4WVlLZUVJUlk2b0o0Mkpxdi9n?=
 =?utf-8?B?R2JzRzNmT2pIMlNHaFJnYkFvTXJVWFBOa09ISGJiOGxsNlozVDg1b085eTFH?=
 =?utf-8?B?OWdPTjh3UGhvZlZwQmtodEFpOUFoVkJIV2hZMWF3ejZ3RkxsUHpvTnMwTnBJ?=
 =?utf-8?B?dHljQkJ2MFRNaE5OV1J3OC80N0NUejErYlk5MUlmdjhpOFVEYjkvRzJXaUZV?=
 =?utf-8?B?Y3I5YllvVitqV2d0YWRybW90bDVsNzVWdVBrOXVHZ01DcEgzQXN5cUxVdGJw?=
 =?utf-8?B?VzZLVWtTM3AxeTVLMTlxWHBjRWR0SFZ1S2F2TXJ3MVhNeEI0WDhJdDFMMWxi?=
 =?utf-8?B?WG5ZeHBDLzBCb3kvd1g5UzBxUHplSFdFU1hUREgrM1Fob1p5dTVPMytPMGhk?=
 =?utf-8?B?bGdBazlsWUh1ZXRkaGQ3Q0V4RVRTcm90N0lzTkNvcVh0WnZETWswYkdIYUtQ?=
 =?utf-8?B?VTBNRDduL0FiaE9yMnFjV1poV1NacTNUTG0xV29XdVhZZGpSK2VsT0ttTzNu?=
 =?utf-8?B?MjV3RC9ROWdrOFdZUThEcVJEL1pZRnFmQzlKaUQrZGlUcEZXc1cwZGhaM3BO?=
 =?utf-8?B?OVVvQ0pLNVN3TW9HNVNmQ1NHVFpFQW5HZHhDelJSOCtWa1IwaUkvL0JEam05?=
 =?utf-8?Q?4nL5Qr2mQG9Nl7Tejp8EhHuaTVZ9qyIrhsq4dHielO75?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHBjQUtWNWR0dUlCUnlNTnR3WDBGSUVNZ2RiS0tVR2VUeHd0T2E4RFl6NHJR?=
 =?utf-8?B?WnErVE1SbnZZbEh6MjRrNGFLQ0prOGhBQjRhTDYvczVDUm80dml1TkZ1VzZ3?=
 =?utf-8?B?VEQ1VldNSWc4cXMwTUZ6TTE3a01ucER0Z1hQL0w4OTZ4U0F6VGdFOHdlSGZv?=
 =?utf-8?B?WGpIczN0bEJoZXZ1OGhmYzNBS2lsbG5oTG1rblJQZG1RdEpPV1Z2RWl6b1Vj?=
 =?utf-8?B?V1ZDZnFRY3JLaVBoTkphT0lhMUVzY2Y2YjRQTWVtUkdjbENjSWM2d3IvcUdC?=
 =?utf-8?B?WHZrRHhWLzVicDhOWE5UQkkvU3hzd3JxV3ByR2NyUkIzNVdPUHBER2NUOGxB?=
 =?utf-8?B?cytPWkRuNW5UcTh4UWdkUmUxN2ROays3Nlh0VE1uU01KL2E4UWlYb0N6WDF3?=
 =?utf-8?B?V1lHeHNJRGh2UTkzNjNjaEJYK0RzMmt3YWpYYXZsM3NVN3YvbEFMbkVvMXAv?=
 =?utf-8?B?WXRiR3dhMHhWUDgyODNKMnBjSEVFYldRaHo4cytoMVgzRVZrUGtNSjRrcUZX?=
 =?utf-8?B?V0ZTenhzM2IxTWRBdGR4QkpwOGZrTXhCcGltbVBzSm1BRUFxZENMU2E5a1hE?=
 =?utf-8?B?VFoxaU5la0NHQm9jMkpMVkIxTTJHWGZhKzU2MlBwT3ZDeU0vUmZxNm9zS09X?=
 =?utf-8?B?Yjg0a05kcStwRnFWNzNJM3k2d1RhMG5OajdXQzExK1hqOXUrK2hUSHhHelVY?=
 =?utf-8?B?ZENZdWZBR3FnRCtDYmJVanplVDdGQVNVT3NORG5vK1BQSG9idFlXRURMckVF?=
 =?utf-8?B?eDcwVktPMC9zbXNEeUtBd21GUUlJSWRYVGVZRXk3UnY2cjJTRmlwWFFMdkxn?=
 =?utf-8?B?ZWJRd2g4Zld6K2x3aXN3L2JwRFYzVlN5ME01V2tySllZVCtzNUtTZHAway9k?=
 =?utf-8?B?clNEeURNTXh2RHFCQ3krbXk1YnlGbmhuaTJlemdFdlZtbEY0L3VPcDZxQTE1?=
 =?utf-8?B?SzB1UHhRaUpvUFN0R3oxeEdYbDF5VENIRERPT0FmOTBtN24xWHRlU255ckRs?=
 =?utf-8?B?Rk0rZG04UVZ3WFozWG9IYVdtaXVSK3poQXpBUzZDYU9GSStmNFB0OGtzNCsy?=
 =?utf-8?B?cHBLMW1wQlBrZlZqbTVzbVF5a25Xc2ZIQVBXM0ZsOFFCQUNtL2dRRjRZS1B1?=
 =?utf-8?B?clFSY2JOWHlaSHJzQkt3MUFWeGFuRVMrcHkzNnNNZnFqRVJQRGJVb0c2Qi90?=
 =?utf-8?B?ZVVraGk4KytZMEtuL01SZVFZb2pOQ3NaU2UxYm50bmFQL3JDbWc3MmFaTm5o?=
 =?utf-8?B?ZWl6YTJrNlFJeWsvNnBsWVZjSE5IK3VsZi9OTTZjbjZyOWx4ZlRnTE1RSnpJ?=
 =?utf-8?B?L1Y5ajlxeHhQK1ZQaS9oYlVTZVFlRlE5a2xaTG1VUHZGRW5YTnhNRDRoajFh?=
 =?utf-8?B?ajRmTVBEYWNCYUJVT0MzS29uS3U4Qm9Fc2FMV052UVRacWthcEdBM0hWWlov?=
 =?utf-8?B?RFpRY0x6SHJKa0xXTGlkTk5iUUVjU3BhaFk4RkpDandSR2EvNW1KeDV1M2tR?=
 =?utf-8?B?WE9KOG1FVFd2aVJ0bW1XcS9pc2U1Z3k1eWQ2QWFwallVSkw3ZGkwZkhDc0Ru?=
 =?utf-8?B?ajdiYllMOXlheTNqRTVCSGJ4VWptYUV1SCtVejRHY2t2RStWWlRYYitMVUhB?=
 =?utf-8?B?eVBRTXFJb3BXaEIvc3AxUXdwdng3YUdTOG5LNFFmUlpjWjFLQmJIOGcvWHQ3?=
 =?utf-8?B?dVJJaHp3Tm1ubUxpN08xd3RyejNzVkZ1RytkelprSFNZbG82NkdNa3hiTmIw?=
 =?utf-8?B?V3ZocHZxZy9ySG1PdWRtK09TZ0d5U2FsT3JkQ1N0bXlObjFoLytxck5mOHdN?=
 =?utf-8?B?VWRmNER1aElheUwwcDBsT1A2aExXZUE3NFYyRXFwMDBIK055Uzloa0tCL2Vi?=
 =?utf-8?B?dkRCVG5NWEdTdzUvUHRWVmg2VmowL0hVeDdCVVVuMzZNY1VUUitmQ3RpRzhZ?=
 =?utf-8?B?YmNGUHpSdXBBOTBNQkVvSE52eFI5emFKZlpqTkVVS01NUjVsaEUwOUxVZkxH?=
 =?utf-8?B?VmE1NUxzWU04aXVUN1Fsc0llb1oxOUF3cTg3VE53QlVBLzB1SEVOU0ZCSTU3?=
 =?utf-8?B?N29NSWpvTVdrOHViUFpBNExkeDltYm8rMmhHdjY4SXB2TWxyN0tvWWt3R1Ey?=
 =?utf-8?B?R0l4VkZmaUNhTDRuVWdqdU8wa2thMWhDcnJHbUNISE02czduZmtaWStidHYy?=
 =?utf-8?B?YVhnOVFWTENTdlhvYWRGekRNcGxteHhGNk80SFk3eDFRWUEyUTB4RTF6bitK?=
 =?utf-8?B?aHZnWloyN2o5WDIydXNxSWdNZXVzMXNBZEpVODlKSlFnb1RPUlk4bll5NDFB?=
 =?utf-8?B?ZTRBSUFhdzZWc3NHa1pEanVUWUN3RXVOWmtveFUwaFZJMXFXZS9hbWw2M2U4?=
 =?utf-8?Q?sB6O5nzYOUJL+KvE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <74D1C52196D639458E55765E6FD0110E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VhJj9STKzJ7R9QzEVJK8GvKs67H20rllIVcBt7SUXFokrLHhQBvE3Ko6uzSOGEQQbjOI3pt3WD+f3YwzovfjaPalvvn94DGBFZzyvWMQUVfLj5fn6Ty7aXVBb463oe2KEWezdb5qiZgwKGdkd5kBB7V4Ae3eGU/kBjYD2CwSJi6RvgXfCWqvUk986uaqI1z/nBYyYHacj70jGihn2baakpLrTEfGTP9QoesKdAJvXeOFpUfZP5ko7eBgW825r+5OdEBwyW+6p2w4btBFy776z4hquPo0ZA7gIB3aOLJ7JNpHEwRevY3xUM83ssZCALfELzmN049kMgqmBIAg1oDr1A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fce28a-289f-46b1-8b52-08de73a1e812
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:40:35.3062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hHKnI611Gh/6mH4vPxhtspeyJfk5/lTelLV7mRskdNXE0RlP2N0VcXAs5ULmIHJkBm5b5cY6XC3lvalmTlWjvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEJvdGggdWZzX210a192cmVnX2ZpeF92Y2MgYW5kIHVmc19tdGtfdnJlZ19maXhfdmNj
cXggbG9vayBsaWtlIHRoZXkNCj4gYXJlDQo+IHZlbmRvciBrZXJuZWwgaGFja3MgdG8gd29yayBh
cm91bmQgZXhpc3RpbmcgZG93bnN0cmVhbSBkZXZpY2UgdHJlZXMuDQo+IE1haW5saW5lIGRvZXMg
bm90IG5lZWQgb3Igd2FudCB0aGVtLCBzbyByZW1vdmUgdGhlbS4NCj4gDQo+IFJldmlld2VkLWJ5
OiBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubw0KPiA8YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdu
b0Bjb2xsYWJvcmEuY29tPg0KPiBSZXZpZXdlZC1ieTogS3J6eXN6dG9mIEtvemxvd3NraQ0KPiA8
a3J6eXN6dG9mLmtvemxvd3NraUBvc3MucXVhbGNvbW0uY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBO
aWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9saUBjb2xsYWJvcmEuY29tPg0KDQpS
ZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo=
