Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4387D17993;
	Fri,  6 Mar 2026 05:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772775575; cv=fail; b=HsjtP+TiASQPQjwTsLlckr1V1LP0JwG4uIBDNTT0YTDO7qUc7aohzdKtaKkuO8aRsT4B81IinZaM86tBYADZo76AMP2EFAPB2rvfXlcxSn6qS8HDx9UGFir74Tl3g21xLocPySBEeWkmfXVSqXnnd2hvbwPBirrBX93mO1S9EnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772775575; c=relaxed/simple;
	bh=tQ3hwBNBrbSbUT6CXdE2XeDiKhlwKqs6J5sKwzgDqc0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IUBhkxjRRrUzRuv9AyXlvHjZKz7+FSAQuIEYDM5JuhlehUJqtNpz4xRDiGHsplupS1JwhY+sk8paQjmrej+MEQz0rw0Xkqx0/TlkYd2Rx0DCxn6JVEak9Sk9Y8ojJYjE4dqP3q/edEH8wNtWYaVJCCCH2IiXzU6FKHz012UkBzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=r0Qg74Tw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Hxqo4zzt; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r0Qg74Tw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Hxqo4zzt"
X-UUID: d7c14b46191e11f1a02d4725871ece0b-20260306
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=tQ3hwBNBrbSbUT6CXdE2XeDiKhlwKqs6J5sKwzgDqc0=;
	b=r0Qg74TwyWuZ+MsfX1tYre1RYXbuKjuk/5yYNnwl+xmCRyh3hePhDIqJNk6hk23O6PH5bhSexA8c/4JPEbqadLfRZVXO5GFViQtGWYJDadbroOo3V385SE9yC+C8uyeVGIVpBl1XrmUlxMwJawHYhKT1j0STSJ+kay7DNhvKXRU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:a43e4d85-904b-42c2-b7ef-d2c3e46a055b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:e5154fea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d7c14b46191e11f1a02d4725871ece0b-20260306
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1690786240; Fri, 06 Mar 2026 13:39:28 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Mar 2026 13:39:27 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Mar 2026 13:39:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSroepFvi50i7ivrXQey2aW40eet1Wqx5FT8s7lhwdi45WLGNjPxYAqRRZoyWGssbyg8bEdMUfTeieTVasnzZ5rDTxmndrMl0MHp2u0ZYabxRPcnFNxGn+rtBS8HLRRV3AaXg0KCSMlz/vPaPjFzhuY08MjFftQw+bIzcrqIeo6NJVOU+nfX8L7uqf8mz6p5G2b0WTHdb8sPP7D3qkDweUgKfyjjjl4xjfbbnKb+h7U+3P3aXzNQ8M4LI7y/aPWym37yYePXYgcrgoRrcg3+Eg1pns71kYz8KuLITQSRbSa7NI7UsWkUgsZHbl6EKZAHk8RuYPDgBnXtXxO152yDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQ3hwBNBrbSbUT6CXdE2XeDiKhlwKqs6J5sKwzgDqc0=;
 b=ltu/f8xU663sPRKGqmZBTfAjgiuXLRAzX2wXl4g7su/EdT7a25YDhNCJt9mCHdH2RP/aYsNh49Jrey+9bQankWqCsE8guzkVZRwFgRYI1zATN7CK06MNseOrY2UAfRJtivgjPVUSO/3qQUwtu/inJt8udc9MFIQ4ad3qePuJhIyjWOJwonbkMJcg/Q70qLFjnfM849GtcMUsL4kC9dY9nXQYwd4TmgRQYqhKVWLP+/xh9ZEfLuqCpuS6ltgbHjbbN1bnOhOIdaqoxhIDb/mdL2M2TX6msoLwEf8rUTJHwGNalQtwFNTkWfRRNLk6UNapvYkg9V5TS7u4/P7nu8XHAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQ3hwBNBrbSbUT6CXdE2XeDiKhlwKqs6J5sKwzgDqc0=;
 b=Hxqo4zztucudpvnhNOdgoCaagXhFQ50vEykLQ0Wp7DNO3jItQ+3gJS5M74W5FBmQs3Knbvf/nq4KF0nPrWmKTqZ94OH1Pp9B6E09EFBWpWUx5C/R2ZM7sbIPRrQTyX6Mz3UtBJ4nl/YU8dFNblYh5Gegv78eRc3+SRimlQvD5OM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9697.apcprd03.prod.outlook.com (2603:1096:405:397::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Fri, 6 Mar
 2026 05:39:23 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 05:39:22 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
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
Subject: Re: [PATCH v8 11/23] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Thread-Topic: [PATCH v8 11/23] scsi: ufs: mediatek: Remove undocumented
 downstream reset cruft
Thread-Index: AQHcq+b6PlWf3exVv0qNnn0g4WhUMbWfqTWAgAAMDoCAAUoZgA==
Date: Fri, 6 Mar 2026 05:39:22 +0000
Message-ID: <2a68eb32987c21b6a48547ce044ee38d1eb01fa5.camel@mediatek.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
	 <20260304-mt8196-ufs-v8-11-5b0eac23314f@collabora.com>
	 <3aeee75e78fed2be92038c776463a231b94462f3.camel@mediatek.com>
	 <3472277.mvXUDI8C0e@workhorse>
In-Reply-To: <3472277.mvXUDI8C0e@workhorse>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9697:EE_
x-ms-office365-filtering-correlation-id: 3d948339-c611-46f2-4846-08de7b42b84e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: l+dKLB/UFO9+8uWK3hlpbZJzbp2ZvEUTnv3kI+ylmpCZPf9VF9CD1aECtUMy4A7ldzduuCbzAWT43RHyduipoasPAUONSX4Ib4lWDt5EMc4wFb2iVQUI+FWb6yd0/DTrg3FQ1Cx2zvnGN40rBQdXTp3CnNNTwu+MZyydmw0UE5g9gkCFpMjk6FD/5RievP/SNVfqlDY1ujI0fwXDjt2r5K87GvDdRJ8ZHfYnZPfneITwLJ9nGko0PXE/ItZ7Yg32wjAXsODMMTnOSpg81nHnYutRmCfCHQ5/I2gVMjsyF/tpb1lqxM+2SwNfEomG/ublUjOhOis4+Ni9fwdkq2yuucTzyMjf2xYws/0QewAhr96qVDuq3/Kg8DYLHuUtluOcx6Yf8vAjkYpfAiyjk08SXPn0jkTfbb4bAcUd+A04igHsJA3VklgSmjaOyOSbd2NL80XWA9XzNtMrLsOJ2lcKSO+66qJSF53nDwYRZ91Quwzelq9y9bvIejERfT1JgfprE2bLeNVGsfGKWgWtV9Oj04BQWuos3p46Z5h72gQ3j/5aQHkAFFNNDPME8YkozV3O5qu6k39HAJyIhGYqApNDZSVOuyRym93ugwQnKTNv/jt3DOFgBiil9/cfNzvs95hW+w4GNP7RwNlXcAwhRx1xGxUy55Y3lcEH6IIc5IeRp7aRdBQmRCBl9i9c2UMcaz6oJFu/M8w/dhZ+dlKOk5+ITOd9NFv5Id3qeH+Gl0ToQBJIwnnIZA9w/Xs0K5cnzqwJov8d/j51M0zAOupQvFwMkohMUzlvkYk8fnI3d4v4Jvc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aW9LZWk5TkR6UVF0ekZuMVNZbnVQSFpqMWxnMGJnUVRVdnhiTmhrSU9hTDg4?=
 =?utf-8?B?aWYzQlh4bDNpOGJuTmlwdFAyN2YweGNnR2Fab1U5QW9mQ3lMMUZmbWNLQnBo?=
 =?utf-8?B?WWd4eUU0SFVOWEZULy9FSlA4U2FBdzJ6b080c2xReHRiMzl1UXd3T3dJMUxz?=
 =?utf-8?B?end0bkJXT2MvbVRvUTZ3OWJHMm5UeEJzTGtKUFZmRUlzY2xkdGt0NUNLVURr?=
 =?utf-8?B?eVNKRi9LSkhzdi9QOGVzN1dKZEVwUWRMYXNnKzB2aGRyNUhsZUR2eitqWGpC?=
 =?utf-8?B?RjU0UlVzdEJMU05UNlQxbnZJUDQ3TXBWbDhjM0hId0pYWXRnbGpSTTdZazRH?=
 =?utf-8?B?QWtCUlNXWGx3b1dJYnMrSDhLZE5iLyt5K0NIa3NuUEtFNVdySkw0cnMxTUEr?=
 =?utf-8?B?RmZybHFQUk5PWUxTQS9yOE8wVjJORmgwMGt5SXJMQ2RnUjdTS1V2MWJVOGFh?=
 =?utf-8?B?ZTd1TmUzVEdwVlBjSEd4ZFIzTmZRR1dFc1JaSEViS0pzKzlWUitBSllhNEJ1?=
 =?utf-8?B?bFpSK1RGeXlWWEljZWdwS1JXZWdiZE9GQytuOFI3eFZnN09uSkVRcjdoYXBy?=
 =?utf-8?B?WklycFdNRnc3c0RHekV6L2xQSEZqMFgyUHBTVDhrclE5b0lVQVhSK0RGaTdh?=
 =?utf-8?B?TzlvWWcwYkMySXdJa21UUEdJS3JYODd3WTNwK0h1V2Z1MWY5NEdGVmM1U3Uz?=
 =?utf-8?B?U3BGdGx0Qm1QdkttQXN6Z2lYVWpHZ2E4NWdLWXZybURYWmdQQm45TS85TTNY?=
 =?utf-8?B?ZHNEaWRjRi8wZkg4ZVVqTkwrSW1IM0EyNWV3aWdhU0xsTVdSZDhZTGJRRWlT?=
 =?utf-8?B?R1hSaVFGcEFuODk0RnZZYlcwVnNIemJFQlBtTC82Rzh5Zis0aENrZzNlWHdj?=
 =?utf-8?B?bnU0akNFWTVpd3JwbGFsSUh0alpPQzNhTFRteDR5V2hyaG5rVzdRRVFtU1cz?=
 =?utf-8?B?TU9LMVNiRGVRS2Q3M2VvbjlEc3ZNRG4yRERuV01HZ3V3eVozUFVOU3U0dHI0?=
 =?utf-8?B?UDZENVpKUzhEbk41UTd4Wk5jL1BTWkhJR1pURGZnVmk4V2pYOW1sVmRxWkhj?=
 =?utf-8?B?djNYVmJhOCtiRmZHNHdERFMwamtaT0ZhQkNaQ1BhenlBaEFhdjNuZHhTcDhq?=
 =?utf-8?B?dm1pL1ZvNmdyK2JrWTAvNnRDZlZKdUtmazBGTW91VzBoN2s4UnNkNDEwWTgv?=
 =?utf-8?B?eVhoMVd2ckZVZ2Y2OFlnbGlMbS9rVmhUK1hIbUZlOGxlbWxWVlNRVlZ2QjFO?=
 =?utf-8?B?L1lqbk9XTFN1SU15RHpKYTlJdkEyTjRTQi9tRnhqdU0rMjNuNVcxb2FvWFVS?=
 =?utf-8?B?M1RpQnlGcjQxNkc0MnYrZU9wNjByOHllSUcxcjVKQi83VGdRN09FQ0JxRTBU?=
 =?utf-8?B?Q0JjNjQwUzRXbUV0cFdWZC9vbXplOW9ZY2xOaUUxSFpmSi9DZmhqUE92V0s5?=
 =?utf-8?B?NWh1M2p1Wk1BWXV0S0xlTjBhWU4wYndBRmd4UkZWY0tXbGNWS2dtWGkza3hm?=
 =?utf-8?B?SERzU2kzYU13M3M5YzhXSUJqUTM3QjUxbE5kcFowSmEzWVVqK1IxdlhUa0VR?=
 =?utf-8?B?elgrSGg4bmNqckRMOFhDU0w5YVFGQm1GSXRUMld0SGlEbGpqN0xDcDRucnlN?=
 =?utf-8?B?cHoybDZHNFBHZVJNcWtQaDc3Q0t6OHkzTG9KSDFOT1BQTEIwelNKZHVZV3d5?=
 =?utf-8?B?Q1R4QktnZFVRVFdhMFF5alVUOHdBTlZxejgrVE00aGs4dFphWUVQOWVrMjBX?=
 =?utf-8?B?S2VnQkszamxPYldOZzV6ekxpREJNSXVDUm9hc0c4V2FxKytYVGJhbWdBN3Nh?=
 =?utf-8?B?VXVKYmpualN3bVl1WDhRQmxMRUFhLzJ0SGR2bjJWaHZOSlJuR2JkQmJzRmVM?=
 =?utf-8?B?b0RqZjZTSGV3MTBnQ1dZMWsrL3h1WnVId3V1NExTNU9FNDQ0aGF3QUF4YUR1?=
 =?utf-8?B?clZidm1xVWo5S1AzdTBtYzhGMjB0Vjl0bkFuWS9za0tzRGxMdWFpR3RQYTRC?=
 =?utf-8?B?UW4yckhrSU10L0tMdUJ2U2syeWwwRHdELy8xMnZEUlpObW0rUzVkZ1dDL0p5?=
 =?utf-8?B?ZkdrK3ZZa1RpSUVzQWNuVnMxR2VIT0xqVVlmS2lwRVJ6T1h6K2IyVDl4MzZa?=
 =?utf-8?B?U2dJaWlEUkM5RU9kR1RQMmhSVmk3cjFzNllCbmZSQkNPd1F1TWNiL3RjRGI2?=
 =?utf-8?B?U3Z3UGlqWnY2UTEwaGViZ0R0eEdLVlFkVC9LVDd5bGgyUEZhUG96eFVNN3ZH?=
 =?utf-8?B?dlJ6eElVUzdjT2ZZbTgvdnFZTzdncU5RaG8vdWtvYTJ4WVg3cDc5V2ZuWFdk?=
 =?utf-8?B?QUxRQnpVeDBnZlBYYm1CMWJYQ3ZzU1RrMUtnbGFLUStKQjEyN1VuS3NIZW9B?=
 =?utf-8?Q?LLOjVfmRY7AzKgv0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1866723AEE81C468C046914DBA376DC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: rNBcI3lOgRiJSlcoOSUcr5Bklsa6Sg6bl3nhCHjLMN+Y8gPJFKnA/wDW7NDNR7aOlzUePhy8InxET5tX4tp2LnVKMpKE3c7rrpN6cmz54CiOUXPMzObDOZTFl1dgzjRUqMn3gaJ6g7NUnmaybAYzQskGZ//WAoMjXyfFWrHXNSr/K9hCpWp8ce0AMP8ZC38gfm/MmXTigquRf6jeG275wbKVgRVAnogxiRATXFyX8Uv2RvZ5V71v18i0S/2IkgiOajSJovzMmhT0HWD9SUwVj/SDDraC5rQElABYdGjtVbD9Vp0iYYgUw/828AgSZlzmopkTueM3EroAD/AQKmCXXw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d948339-c611-46f2-4846-08de7b42b84e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 05:39:22.3101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PRiyb05iIPS/ri44W/m37aGRkU5XIgAQ+w+APd2kDem15Xz6kVaZZo0DXKCBb4X0uXIhiwJ4e462yM0Aa7QSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9697
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTA1IGF0IDEwOjU3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IA0KPiBZZXMsIHRoZXNlIGFyZSB0aGUga2luZHMgb2YgbWlzdGFrZXMgdGhhdCBoYXBw
ZW4gd2hlbiB5b3UgYXNrIHNvbWVvbmUNCj4gdG8gcGljayBhcGFydCBwYXRjaGVzIGZvciB5b3Vy
IGRvd25zdHJlYW0gY29udmVuaWVuY2UuDQo+IA0KPiBJJ2xsIGhhbmQgZGVhbGluZyB3aXRoIGFu
eSBmdXJ0aGVyIGZpeHVwcyBhbmQgdmFyaWFibGUgbmFtaW5nDQo+IGNvbmNlcm5zDQo+IHlvdSBo
YXZlIG92ZXIgdG8gQW5nZWxvLCBhcyBJIGNhbid0IGJlIGJvdGhlcmVkIHRvIGRlYWwgd2l0aCB5
b3UNCj4gYW55bW9yZS4NCj4gDQoNCkkgdGhvdWdodCBlbnN1cmluZyB0aGF0IGV2ZXJ5IHBhdGNo
IGJ1aWxkcyBzdWNjZXNzZnVsbHkNCndhcyBhIGJhc2ljIHJlcXVpcmVtZW50Lg0KDQo=
