Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58AF2E1F13;
	Mon, 20 Oct 2025 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760948012; cv=fail; b=X4tPcvlOYSpyEDeFIq64xx3PJZgLXp+wm75+K23gnLGXQKAjqcj9DtmSzGrJsFi+brg+7NzhFyRkSby3Ctfb2HkSBN+DjgmsIMchbjXS88XhANqOHF46Y5R279DIA1bjxMZKBj+TyPM4SvV1H1u2tZ9LZo0cwE2blaTswkRQOO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760948012; c=relaxed/simple;
	bh=4eT50moFZCM1m7nOBqKbg2jM9vpPa87bHa+ASrqjtLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vws08w4zhAOS/Q4uZGPQWOiK3pWnJ5vrB/9IpjYdio5Hx5XnEyxZswDJUVwJJ9Sx6MkERjjd2Uc8EUAzb6EttA+GRQqtqqVI3rri7HDLbk1RQTN5LU/MZjs++pS94ulzzisK8fZMDuZCNwSVfVSlCZBuMKnP0U5PgRWQdkvx+gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=P1Sl//CM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=R9IPb231; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="P1Sl//CM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="R9IPb231"
X-UUID: a648a27ead8c11f0ae1e63ff8927bad3-20251020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4eT50moFZCM1m7nOBqKbg2jM9vpPa87bHa+ASrqjtLo=;
	b=P1Sl//CMi490aAYKbHWijzWcq1uZukwtSq3qeECmWTefcdyAC50U/Cx/sQXBhWhOQ0ilQRdKlqjlZ6ZgI6weRCG1PR6Qj4+QkouSwxI1im7I/Ks+cc6OOMPJ2YSA8aZ1+3z30v574MXGHIbvAN6K7HVk+dEo+bM05niIx6mR6Rc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9e05f357-6eb1-47b4-844f-6ef009f651ad,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:5d305bb9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:130,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a648a27ead8c11f0ae1e63ff8927bad3-20251020
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1850804892; Mon, 20 Oct 2025 16:13:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 20 Oct 2025 16:13:18 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Mon, 20 Oct 2025 16:13:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B4QhKSIG4p/Kf/UU0iQNLJ8kb5/bhbDL5JJFTnLx12BL1U1YKex73QY5V/xyKZv48VkPfnsyZHvP4aBan1bUplD10o+gBbKzerLbDo/r1MprzQC1IIpwfbkGG0fDxXfQieKTV9C+m7YDns/cHNM+EL3WBOo2exQcvfTeSJGuS0f0HErwYS1nzifY1MuRxhFR+2OsW740zJH0EyKx9kdVeZOJwOjGuVG5cyzrskp0tnNT4iPFCY8I2eO/FGTHyk4sDqBx0ihJgQF8iNpy5reN7Wkqzgh9BmgMugZfCa5QpYaTBao4mNDcsNT6qxak+eOz9Pum3kEoI1tZkxLJKKgtPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eT50moFZCM1m7nOBqKbg2jM9vpPa87bHa+ASrqjtLo=;
 b=cN6eok6mvpseVR0muN1dQ6RzgiORrNFO+xwjl9cr4NKsteHccgZRhacaYL/EwHehvxj7toNdS3EcuEgSGuYToGlGxBmpRDMEDNRYPHP7RsXC7EYNCuGWpGEY/NPxHc4i7YAIr+/pzGFWVtHzFNH6rxTa6eE67o6cCQjx0rI15v6fYb/874d1ls7DMs3NIVJhwx1e6YiSFHSLYWJRbwVnH4ixoUjQQEgZWpP33P06Ks8oKIN98icyzarXawIVq3fah+bky6ojd8+NHFqtc+3ozX8CwxFlwD9NtGYHE29BdPeTjnQw42jRk1pUWjwwx10R2JLUCroVEzfCyKUpm5H7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eT50moFZCM1m7nOBqKbg2jM9vpPa87bHa+ASrqjtLo=;
 b=R9IPb2310U8Wpov9QYsOTpjOF0yFkySMcRgQawfL8T/BUdGUSVuDAvFmkR8Jakg9cpRK61bfi2gttl4SASnrkmJ0P5QfuCV72xiysVEFyrGe7xVP2IyqYSjnEQg9um1agZb4GGCt1UR31HeEPlUjLVkg2I6SyH99RqasScKjSHs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB6975.apcprd03.prod.outlook.com (2603:1096:820:ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 08:13:19 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 08:13:18 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "robh@kernel.org" <robh@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?=
	<Macpaul.Lin@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "krzk@kernel.org" <krzk@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "macpaul@gmail.com" <macpaul@gmail.com>,
	=?utf-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
	Project_Global_Chrome_Upstream_Group
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?utf-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
	=?utf-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Thread-Topic: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Thread-Index: AQHb+ubXEcM0idFfNEe1g+HvnHp2OrQ941oAgAGSzYCAileogIABbykA
Date: Mon, 20 Oct 2025 08:13:18 +0000
Message-ID: <a9bf15e48afd8496ca9b015e7f5b03821863a0b2.camel@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
	 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
	 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
	 <438077d191833bb4f628b2c6da3b86b3ecfb40e6.camel@mediatek.com>
	 <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
In-Reply-To: <cb173df9-4c70-4619-b36d-8e99272551b6@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB6975:EE_
x-ms-office365-filtering-correlation-id: 888847a6-9d80-4b16-10f6-08de0fb086d9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?VEF2aE1abjFYR0k0dTZab2RXZXpwZmhwaDZ2aVd5bWgvZS9BcHBld0dnaUZq?=
 =?utf-8?B?Z3pENUZxMUhSaUYwMWFrRnBqc3h2dDhMb25aNndiUnZMWkJwL0VJbzB2RzUy?=
 =?utf-8?B?MEhVV094aFhNWnVjNElrbnlMQlVHaG9jNEtKcHBVdVNGSmREVGhzRlZzVXVy?=
 =?utf-8?B?YXE3MmdFQ3pjUFVHNEREZElGYVptMHN4Q1ZUMlE4UTI0ZFlxa0tWa3NZSzVD?=
 =?utf-8?B?dzU1QXhDVmtlaU9oczhnU05NMEFqNDVURm9sOEo3akZOSlAxRmxKalNUTk5T?=
 =?utf-8?B?TzhkQTVVdmZycC9CT1hibGVCZlUxMWdyaHZaQS9OZ0xGRHAvakx5NW9xb001?=
 =?utf-8?B?bXpyTmRwK1FsV2R0NGpFQW41dlE1OWlNMm80WllkNVNCOC9ic2FZY3dCMGRh?=
 =?utf-8?B?SWFWbjlWeGV3bjhJeWJINVptcGNadG5YekRXeEFYK3o4cUcwYit4emlDZHUy?=
 =?utf-8?B?cDh5My9lb0pjcit2eGU0T0c1aEZZZ29VWUFmRWE0MkhHRitHMlpiUWNoalp1?=
 =?utf-8?B?ZlhOSHpnQmEzWnFhdkM0RXUyQlRQbnJ2U0JUM084OHNaMk5vczhzSnB2bWNr?=
 =?utf-8?B?MEs3T3ZkR290RGJ0ai9BYko5SFVHRFg0YUIwemljaThXUjNLeU54d29DRWZ3?=
 =?utf-8?B?K1NvdmRMZEhWb0FUbSsxMzZGL0JaSzlDMWhnemlBWUljOE04NTlCN29vSTBk?=
 =?utf-8?B?NldJNWMzTFdLYTc0ZVVrbEk4MjFUSU9YOWI2S3JTR0JpWTR2M0FkUEJQS0dY?=
 =?utf-8?B?VWtTZ1JXNVZQd2MyMFo4a25YUlYySU5qaDVNTDEza3NnTXRKeFVuazUxMThZ?=
 =?utf-8?B?RmFTT09Lei9OeFZna0pTUVRsYVFCQXVEOW5xZVBpalhSVWE0QW5LWEZab01k?=
 =?utf-8?B?RjBzdWVvUnBTZVhGaUsybHBZY25SYlJVSzJhR1g3RExTRjNYL3ZYSzlQZExq?=
 =?utf-8?B?V1BPK2VNV3RsRE5sMmRCQldDek5MSE5KTUEvNVl1ZWNheVZ3Rk5LR2FDbUJ2?=
 =?utf-8?B?UnNJZ2t5b2Z6aXIwZnV6OVJIY2N0U2F5WGpGRVNtTmtTSGlCT2Q1NENNa3cw?=
 =?utf-8?B?YzZGYms3dUVtVGk0R3J0SEhGdXBSeDhCcitFR0JlaTJyeGNXUzl4eDhIbXFY?=
 =?utf-8?B?MmZYeHBmWWN4T2Q4TkpTQ2xTMTVnN01sK3RLZ3RkK2FrZ09XT3U5aGhnd2l2?=
 =?utf-8?B?SnFYejlPdTRqU01QMEVhZzk2OXRHQXNld1dDWStwTThHYVkwTEtOU1RQN0Ix?=
 =?utf-8?B?RHNvdlp6clVxVTdsSldsbjJGK2xJbzZiaWYySDFDUkZvWi8wTXk3ejhJV1VM?=
 =?utf-8?B?Vmp4Qyt6RUFuVzNkZys1YmtycU1BVTZDRjBseDZtbGsrTmlzbTlyV1ViNFJu?=
 =?utf-8?B?Q3Q0RDRZSk1YWXo5Ni90cm9FeU0rdC95U3U3QWdiY3N6bmFGNklPZThyVzht?=
 =?utf-8?B?bUJieStSemZDWE9YTzFXcDErNGNXQWFIMjVDY0FKWmNKODkzNzJYOE5GNk15?=
 =?utf-8?B?UW5LNnBXNDl0OFh1Qzl6YmRlMElXVmpxdHA3Vy9iNUUxMUpoVG5WSm5OOWtQ?=
 =?utf-8?B?UmMwWXNMNEgxSTk2ZnhkM25Wc0hHMGJycEJMd3ZhUG9CRHVWbDlDQnZ2SnZx?=
 =?utf-8?B?VXpHWUxlVllpajRzb3N6SEVCalk0V3hQV1hhQWszaWh1Y1hzSjFVcVgwdnVk?=
 =?utf-8?B?ZlZiQXJsSnRkOURycVNHWWxlRFhRVjFDZ3M1UW9abnBHQ3lLTHlucW5BWG9B?=
 =?utf-8?B?M0RrRVpFUGJmSEFqc0U3RmhTMHZZb1d3RitkcHhVbDh6bWx5NHAxL1AzSXhX?=
 =?utf-8?B?REJidU8zaDJpVTZJYXdUdnpUVWJOeThTelpjSlJveS9zRVA0VTE5YjNhdmY3?=
 =?utf-8?B?Q3BEenorQlZCeDRyOUl6aVA3Z25jRVJDQktXdVJtWENwK2dQb0wyR2RKdnVR?=
 =?utf-8?B?SGF5dElZMGZ0NUF0K1BKa1NLNHcweW54ZzdNSk9PdndJeGtjZTNUMjhIQTJH?=
 =?utf-8?B?dnZpY2ZEM3N0MlloMWpPaXgvclZTQi8yUXNIb1k3ZVhzWG9FcFJaNUdSN0R0?=
 =?utf-8?B?UHgyWjd2VWFwemZPdURRanlUZkNSOENWWlI3RFdhTUY3bW11N0VHdldGTzJH?=
 =?utf-8?Q?9tLU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1NMbExCemZTZUV0TXpCWGllWmE4bnNNL2c5Q25FSUFJY0x6YzBwakJYcXJt?=
 =?utf-8?B?RXJHL1htb1RqUlU4OFgvVlNZLzgwUS9IZE1KRGc4VktqVnJZR3R1Z29ZVHBr?=
 =?utf-8?B?TUFPRjdYS2syN0NwWU9SMnZEajN0ZjVEWlh0bmVwZVlLaW83d3hhd0J2SCt5?=
 =?utf-8?B?eld3OUQ0blNsd1F6UjFuSjE5RVJlRWlhSUEwNkhZVTV3eWRZb2kxNjU4V1JV?=
 =?utf-8?B?MVVoT0dqZUt4bytJbmhBZkM1YnluVFNJaHJsTkZnWS9yQ05xazRUeXRTRjhE?=
 =?utf-8?B?L291SndobDZqaC9xK25XS3l5cFRyTFN6amxtUHhUN1RuaGY4djVXdHZ6T1lP?=
 =?utf-8?B?T2ZhaHYxQmxoRW1lYmxTczkwUXEyakVrajAyN3VxT3lNcy9EYWZ5ZVBYKzVt?=
 =?utf-8?B?NlpEbTg5REMwYWJtSUFkMVV6T1BZa2owbXRBdzdEWGZpQ3VrZi83VlZNTEpl?=
 =?utf-8?B?STJNdnpJTmlYUFhjRG5PVVpqbjhma3VVczVNYlgvYWhtcExycTRmZGx5Z3Mz?=
 =?utf-8?B?WVN1ZldIRk1NRVZJS0JDaTNiYXZtR1F4RWg2MkNGVVcxNTJSakxhOHdLb1RF?=
 =?utf-8?B?S0cyWXpWVXJrM0M5eXJBZFFXbkM2Uk9GNlBUeWphNWdobUtScTBVNW40ZWIv?=
 =?utf-8?B?cVFiK2M3emt1aVRFbmFtL1lqL1UwTzY1VzVLaytIQi9xbW41VzdaNzd2TVJs?=
 =?utf-8?B?VHlzdEFuOG9tQ3BHbEtZT0FNOVZtSWtzS0JtZUx1ZnIvblNBMURqYWFDRWE0?=
 =?utf-8?B?T3NHamF1RC9aRENodW9uR0VPMU1Vb3dTdG5hZGFHVzROL0NwaVJBa2JmbTl2?=
 =?utf-8?B?eFU3TnBJYk1iTjhlTWNkSnZwSjJQQW5VN0xsdUltazB4SDFRbjEvUTRncWJ2?=
 =?utf-8?B?V0xoSVRiMTIzQlFqUUJGSEY5Mlo4ajlwNm9LWTdzZ1VzZ3VtbHFEV3NYdlor?=
 =?utf-8?B?QWVFKy9EK3pISWVTV0o3MzFidDdZT2g3dXFYelo5cWdycWRGc1M4b0xDQWpX?=
 =?utf-8?B?bzdtQmwyMzN3TCt3Nm4rd0xrYmF0aUhkRmhRZnBBOXptRXNhWGRPU1ZCSzI4?=
 =?utf-8?B?cVpPdUNrY0c0WHdoME93ZUZmQWIxQ1lhZ1pBZ3VxeXBkRXBueW1SK2VZZFN2?=
 =?utf-8?B?TVJtcWN2d3FNSXVkT2NDdlhwMU81dXBScE5uRzd2MFNhcWtQUFoyVDNVdTI5?=
 =?utf-8?B?eGx4NVdvcE5iYXRCZG9mSDF5Nm16RnRqOUkwNnYydWtCdnJlcm5jOVRVWldR?=
 =?utf-8?B?bWpNWTBidVpSVFhVSjRUZGI4U3pvNlBWQnlNTTBVMUFSdFRaVmZkK3RCMHhF?=
 =?utf-8?B?OUgxVXhycllDRDBOYkZuekVMa1MyOU96UU1iWFNkVGZEdHZIV0JjWGZCbm9j?=
 =?utf-8?B?eXN2d3NiTDVJM1Mvdjl0NHhFdkZJb01UMWNKR21vV09sYnQrMThIb2RmZ3B3?=
 =?utf-8?B?SERjYkJUdUdCYUtCaFB0VkVtZzlLTzA5N2hqRnE2a1hoSHFjVmRwT3JlZmxR?=
 =?utf-8?B?MXlCNlkwdmVHc1UwdHZCeUkwNUF5Vi9ubEg0cEw4ZWI0eWtLZ1JyZHJnMnBr?=
 =?utf-8?B?YkpXcTBJcVVHTXRpVTRsbjN3U3k3c1JobUpyTXJuSm1RMi9MSGVMc0xKeHl6?=
 =?utf-8?B?bGJSVnZuSlI2M2lscnJGYmt2S2ZVek1PT3A0VytnVkhWeFNSZFhmUGs3b2Y3?=
 =?utf-8?B?STBlUDNEaGp4ODRoY1cySldrd1lURFhQbGJXTEJIb2pvRXNJR3ZZNHRRWEs2?=
 =?utf-8?B?WFp6bkdnMkNLb0toWnVHU0RtUklGK3JVWXNya0g5QXFremY3cHNiVGVLZGxn?=
 =?utf-8?B?WUt2a2dmSFNLY3RiYW9tVUZ0K21IQmh2b1QzeGxBZnJSc2VkVkJBbmJiMlpM?=
 =?utf-8?B?UGZUak1yT1o0akV6K2Q1Z0Nhb0lxOWJML0JtZk5lRDh2czlEWEZyS1AycmVh?=
 =?utf-8?B?QmNDMGJFTUVuRXh6NUg1aXJYZWQ2Wk43Q1RvOGQrcHRDcGxhejdaMm5EVzdj?=
 =?utf-8?B?ZmZ2Tjd3NUI5Z1piTTNxR2pDN0JMUUdkWXZ5SDErSUdGTUtPa3JFUC9nemRr?=
 =?utf-8?B?WFNFVWE3SXlrZlhNWVZyUlVUbnpzNzBKMVdwVFpodG9RcVlBbWt3Z2JnSFF3?=
 =?utf-8?B?bmk2S2h4LytNRkRLUUZ2MVJ1NVcwVWU2cDIxc29yV3JObnpHY2ZmU0RKNkMw?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDACB65014ACE64B9C6903F521EA6297@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888847a6-9d80-4b16-10f6-08de0fb086d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2025 08:13:18.4108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUzwljwb/oOIe7LTM/oyyP0Lbrjhwi1DYam5KagA6MT+xkd+lOfrv3fiEr/YCCR7sI9WrCiwqkxaC8mqAiGYFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB6975

T24gU3VuLCAyMDI1LTEwLTE5IGF0IDEyOjE5ICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiANCj4gWW91IGRpZC4NCj4gDQo+IFlvdSB3cm90ZSB2ZXJ5IGNsZWFybHkgaGVyZToN
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2ViNDc1ODcxNTk0ODRhYmNhOGU2ZDY1ZGRk
Y2YwODQ0ODIyY2U5OWYuY2FtZWxAbWVkaWF0ZWsuY29tLw0KPiANCj4gIkluIGFkZGl0aW9uLCBp
dCB3aWxsIHJlcXVpcmUgTWVkaWFUZWsgdG8gcHV0IGluIGV4dHJhDQo+IGVmZm9ydCB0byBtaWdy
YXRlIHRoZSBrZXJuZWwuICINCj4gDQoNCkhpIEtyenlzenRvZiBLb3psb3dza2ksDQoNClRoZSBt
YWluIHJlYXNvbiBmb3IgbXkgb2JqZWN0aW9uIHdhcyBhbHNvIGNsZWFybHkgc3RhdGVkOg0KInJl
bW92aW5nIHRoZXNlIERUUyBzZXR0aW5ncyB3aWxsIG1ha2Ugd2hhdCB3YXMgb3JpZ2luYWxseQ0K
YSBzaW1wbGUgdGFzayBtb3JlIGNvbXBsaWNhdGVkLiINCknigJltIG5vdCBzdXJlIGlmIHlvdSBh
cmUgcXVvdGluZyBvbmx5IHRoZSAiSW4gYWRkaXRpb24iDQpwYXJ0IHRvIHRha2UgaXQgb3V0IG9m
IGNvbnRleHQ/DQoNCg0KDQo+IA0KPiBBbHNvIHlvdSB3cm90ZToNCj4gIlRoZSByb2xlIG9mIE1l
ZGlhVGVrIFVGUyBtYWludGFpbmVyIGlzIG5vdCBzdWl0YWJsZSB0byBiZSBoYW5kZWQNCj4gb3Zl
cg0KPiB0byBzb21lb25lIG91dHNpZGUgb2YgTWVkaWFUZWsuIg0KPiANCj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYWxsL2NlMGY5Nzg1ZjhmNDg4MDEwY2Q4MWFkYmJkYjVhYzA3NzQyZmM5ODgu
Y2FtZWxAbWVkaWF0ZWsuY29tLw0KPiANCj4gSG9seSBtb2xseSwgeW91IHJlYWxseSB3cm90ZSB0
aGlzIQ0KPiANCg0KIlRoZSByb2xlIG9mIE1lZGlhVGVrIFVGUyBtYWludGFpbmVyIGlzIG5vdCBz
dWl0YWJsZSB0byBiZSBoYW5kZWQNCm92ZXIgdG8gc29tZW9uZSBvdXRzaWRlIG9mIE1lZGlhVGVr
LiINCk15IG1haW4gcG9pbnQgaXMgdGhhdCBNZWRpYVRla+KAmXMgaW50ZXJuYWwgcGVyc29ubmVs
IGNlcnRhaW5seSANCmhhdmUgYSBiZXR0ZXIgdW5kZXJzdGFuZGluZyBvZiB0aGUgU29DIGFyY2hp
dGVjdHVyZSB0aGFuIGV4dGVybmFsDQpwYXJ0aWVzLg0KV291bGRu4oCZdCBpdCBiZSBtb3JlIGFw
cHJvcHJpYXRlIGZvciBtYWludGFpbmVycyB0byBiZSBpbnRlcm5hbCBzdGFmZj8NCg0KDQoNCj4g
VGhhdCdzIGNvbXBsZXRlbHkgdW5hY2NlcHRhYmxlLiBZb3UgZG9uJ3QgdW5kZXJzdGFuZCBob3cg
dXBzdHJlYW0NCj4gZGV2ZWxvcG1lbnQgd29ya3MgYW5kIHlvdSBwdXNoIHlvdXIgZG93bnN0cmVh
bSBuYXJyYXRpdmUgd2hpY2ggZm9yIHVzDQo+IGRvZXMgbm90IG1hdHRlci4gWW91IGFsc28gb2Jq
ZWN0IGNvbW11bml0eSBsZWQgZWZmb3J0cywgYmVjYXVzZSB5b3UNCj4gYXBwYXJlbnRseSB3YW50
IHRvIGNvbnRyb2wgdGhlIHVwc3RyZWFtIHByb2Nlc3MuDQo+IA0KDQpJIGRvbuKAmXQgc2VlIGhv
dyB0aGlzIHJlbGF0ZXMgdG8gdXBzdHJlYW0vZG93bnN0cmVhbT8NCkFyZW7igJl0IHlvdSByZWFk
aW5nIHRvbyBtdWNoIGludG8gdGhpcz8gTXkgb2JqZWN0aW9uIGlzIHB1cmVseQ0KYmVjYXVzZSBJ
IGRvbuKAmXQgd2FudCB0byBjb21wbGljYXRlIGEgc2ltcGxlIG1hdHRlciwgbm90IA0KYmVjYXVz
ZSBJIG9iamVjdCB0byBjb21tdW5pdHktbGVkIGVmZm9ydHMuDQpQbGVhc2UgZG9u4oCZdCBtaXN1
bmRlcnN0YW5kIG15IGludGVudGlvbi4NCg0KDQoNCj4gVGhhdCBpcyByZWQgZmxhZy4NCj4gDQo+
IEkgdGhpbmsgeW91IHNob3VsZCBzdGVwIGRvd24gZnJvbSBtYWludGFpbmVyIHBvc2l0aW9uIGFu
ZCBmaW5kIG1vcmUNCj4gc3VpdGFibGUgcGVyc29uLCB3aG8gaXMgd2lsbGluZyB0byB3b3JrIHdp
dGggdGhlIGNvbW11bml0eSwgb3INCj4gcmV0aGluaw0KPiBob3cgdXBzdHJlYW0gcHJvY2VzcyB3
b3JrcyBhbmQgdW5kZXJzdGFuZCB0aGF0IHlvdXIgZG93bnN0cmVhbSBnb2Fscw0KPiBkbw0KPiBu
b3QgbWF0dGVyIGNvbXBsZXRlbHkuDQo+IA0KPiBJIHdpbGwgYmUgd2F0Y2hpbmcgY2xvc2VseSB0
aGlzIGFuZCBpZiBzaXR1YXRpb24gZG9lcyBub3QgaW1wcm92ZSwgSQ0KPiBiZWxpZXZlIHdlIHNo
b3VsZCBtYXJrIHRoZSBkcml2ZXIgb3JwaGFuZWQgdW50aWwgd2UgZmluZCBtYWludGFpbmVyDQo+
IGNhcmluZyBhYm91dCBjb21tdW5pdHksIG5vdCBhYm91dCBjb3Jwb3JhdGUgZ29hbHMuDQo+IA0K
PiBCZXN0IHJlZ2FyZHMsDQo+IEtyenlzenRvZg0KDQoNCk1lZGlhdGVrIHdpbGwgYWRkIGEgZmV3
IG1vcmUgbWFpbnRhaW5lcnMgaW50ZXJuYWxseSwNCg0KVGhhbmtzDQpQZXRlcg0KDQo=
