Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1541B394F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752655032; cv=fail; b=qeL5hpnoqtSMmexE60Gd5tKQ7C0hFZXlqXGGizy/PHLWlYhzay7Ai2+fluaHh/s/VoWgOkOfY0YriFu1rGxnblw7bTkLHyGFYpMIVmMEf3DxCEhMTWAxnABNIL4eTkv6M045sPwtiIYN/C/d/G8kLLzaNX0mxy7Uj6zlaycSJ4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752655032; c=relaxed/simple;
	bh=8XY/b0YTVY8NeqOCfBpNxAwscLU+pW4bFzMGlxIn1oA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NoEDcLdxO9g87wJpb2D+ywZwFDu5k3TQsZ+chJYn8QSBLMUZaVrLOSn+juvm9RP0Wq5Y7/8aMaJ1h9KmrVOUmyas8oyB/2KrAl+Th6WZKO9lRrxe/oCjpsNNJtTcC6En5r7mq9kuFA/ggme+Q5DNywQScRqRVJAzjsmngi/zDgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SIglqDhl; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IyOGL2eS; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SIglqDhl";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IyOGL2eS"
X-UUID: 0c0bd026622011f0b33aeb1e7f16c2b6-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8XY/b0YTVY8NeqOCfBpNxAwscLU+pW4bFzMGlxIn1oA=;
	b=SIglqDhl/dxSsqDFe6EEyysWHB9QOt9hlqxwcjfv3eeFv/d15oaKbdMJepo3a+ybRrn1wcVqKbkQyNBGy6Y12clHDkC6gdzSmzQlOcz8jHms5pDZc2Fe6MSN0dmCvvlhaUDYnQgsjDfKoh8Uu/gbufBNHxvV3jvHPiESc0ZS4Wc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:f46f984d-baa9-4ac9-b005-eb9aeeb84ba9,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:99f442d8-b768-4ffb-8a44-cd8427608ba6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0c0bd026622011f0b33aeb1e7f16c2b6-20250716
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1532152573; Wed, 16 Jul 2025 16:37:02 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 16:37:00 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 16:37:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p69lYh3g+k2MlKlCvMIi/HlwriLWbU3IFxHvcZ+TfBsauUxCBGkpMMzPab9va4tC9Nqk8kUvqpJQLB/kcXqIPY9cyvi0chcYe3hJms1rZFarRNNYo2Ebyr4DQN4T9Jzui7GIPPZHzlXOHlUvjf91+Q1CcDgLebOIuF63td38d0rcnImNEfg3RXJfpr4HKP4Zro1xABT1sMI799fEO0juAAgyLFYgSAgOMIlEnx7jIGm1I0ZQHlTRgHrjYA/UwsXRxeswa5AbxsXBmju2AZF7B8SgmOOg9jVAEVcYWQGFnD8xiTTbZpdSX5TnP9N7is7zGaHx4KdJab6L0HD+OwPfTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XY/b0YTVY8NeqOCfBpNxAwscLU+pW4bFzMGlxIn1oA=;
 b=pZErphm+uOU0lRKzFrFzODGvxULNfSLqT9WpTXj+/wgk2t93wx6SLr5dnAdGEUTWlDC1H3KX/HDTc2da9S4ZCDEiajSvi/nNKvVO+1lwz+4XDGwA8DgU4n1kDmt6wtzUlazfyqFm1ftagF67Xgk1Aahe4plorVjQ6LCk58F2+Q1XQ9YQJ6fpnf5BRnvanGdn4rLQ6UvN1dYKutAahBBAsGZnqbZDdsJH3tDxQ29GtDT4WU0GBZd5OEBffxQZnE/iYZOIYmH6G7lznYXtdlBbPw1re4PxBlyzS5ePAJwmsgL72Sr/8VVG5/4FSYiRcUiztkdhJrwqn5aOg+0RT1vIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XY/b0YTVY8NeqOCfBpNxAwscLU+pW4bFzMGlxIn1oA=;
 b=IyOGL2eSZ8tdpIInBrRBF4+0YjCufKGfyrFn/P6pOq51GDvFXP7hg/iMrkd7BhFwAC36cQ1tBm/wvC1fVSvVXKeB58tuRfoyUkXFgeFHhQR9jPIN3lpsthCrLr/h7DSH/tOp4Ywp0DIsvuwEfkUrptqULvcy0wiJy2DhBydQIL8=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by SEZPR03MB8814.apcprd03.prod.outlook.com (2603:1096:101:24f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 16 Jul
 2025 08:36:59 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::93a1:adb2:3b4b:f93a]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::93a1:adb2:3b4b:f93a%5]) with mapi id 15.20.8922.028; Wed, 16 Jul 2025
 08:36:59 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1 00/10] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
Thread-Topic: [PATCH v1 00/10] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
Thread-Index: AQHb9hrb2lWtJdLOzUeWsmurT3Qa/7Q0bWAA
Date: Wed, 16 Jul 2025 08:36:59 +0000
Message-ID: <2aa1909044b47c9a76d2b4bbe0978cf25ec0b0ac.camel@mediatek.com>
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
In-Reply-To: <20250716062830.3712487-1-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|SEZPR03MB8814:EE_
x-ms-office365-filtering-correlation-id: 2e57bf45-fe64-41dc-e9ad-08ddc443ee07
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dVhleExIampTNjRjN1l2UDNnZ3lkSUkvZlRxRTBUM3c3UFg3VkNwUlBhK0gy?=
 =?utf-8?B?MXkzNlZOTEFjOElEM0tGRktNcitZdW9mNTlXWFU0M0dNMTBURjBhZzJTU3E2?=
 =?utf-8?B?RlhVV3ZSNHdDRXU3VlVxZWp2WGdFaW56UThpSGIzNUZCUXhrKzV0MVVPSjV4?=
 =?utf-8?B?cEl2S1cvK1hKSS8rR0xxTE8wQ0k3RXV2RXErejZ6ckRqN3dkYWNOUU9HZEZa?=
 =?utf-8?B?Q29xNFh4K0JrRThFUm9IbDY3ZmVYN1dvRDhrSUkyeXkwYXE3WDFDYzFpU1BW?=
 =?utf-8?B?bzlKcnYyN1YwaVl5R0p6L0lqbThVTE9sV0ppUDQ3bDdFd0h4ZE9FOHpZT3R2?=
 =?utf-8?B?N21YTDY1MFd0VEZMZnRhR09WTk1jeUIzSjNlZS9jb1k3ZGxqK3JmTVRyNE5o?=
 =?utf-8?B?US9qTEMyNEtacHRhOGwzdzZWS1ovVGRxSG9zd2F6WXFCK1p4Sk1aa2FCcjZD?=
 =?utf-8?B?b1lKdVN3Vzg4VTlXY2EwWmQwTkkxMjhMdTRQWUJTaDRtWWlPSXd4SDQ2TmQz?=
 =?utf-8?B?Ri80TlBTR2lFUEV5USthdHp3eStqUW5saXZkdjRyTFVJeGVhTzFBNWNsaHpK?=
 =?utf-8?B?QXAza3VEVEtlUlJ0QmJmOXVZU0g0bkpNdTlEMzhVdTU3RXl4VXQzSWJubURJ?=
 =?utf-8?B?SDJObEdlYkFVK24zUGlKYzZrZXFPNFRlT28rMjAydFlac1ZySmJ3QmVWWk5l?=
 =?utf-8?B?VE9GU3FFaHVsdjNsTHVtNE9RRk9QZEFFNGc2Q3NaOS8wb1hEeXhNZC8vbkwv?=
 =?utf-8?B?L0VDU2NkVFdERG5TdzRkS3dLclMyV21Ba3IyUmFTUjNPeFdQc2s2bis0NW52?=
 =?utf-8?B?bzhyU3hCREVpZGVuZ2xObHNYUklubWN6NVhLbmR4ZExKNU13MFUyVStSZEMy?=
 =?utf-8?B?dk84dUZuaHIzSU9KeUpjYm95cWQ0R25jOU0zMDBqbmJ2emptOGZzRUNnbStx?=
 =?utf-8?B?Zm9WbWdWSUpreG93aTdBVGh1WVQvci9XK0Zua09EVHFVUFl0N09ES1ViZ3Yz?=
 =?utf-8?B?cGo5K3NzU1NwQkE4R1pZOTBvVGVDYmFXL3R1QituY2xQU3dsTW5pOWk3T2FB?=
 =?utf-8?B?cHZtS2wwUG90QWNiZHBNc3JJUThXTXQwNHZXcFZSVkhMWGpTU0FJbzlBMi80?=
 =?utf-8?B?enViVFh5SldVaVZRVEN6MU9XMm8xMmdKUTFBdGZVWkFuZkNiRXpHbjU3UlZO?=
 =?utf-8?B?ZWxranRCcFU4eFJ3L0JjdWl1TVZEbFo4S1ZhMUpvdjN0VzRUQURSSDFoZFE3?=
 =?utf-8?B?c3orcmpwTkVNOTlLanBOaVNiRUduN0xFOTFQZFhRZE5qalYyR25WcjFEa1lH?=
 =?utf-8?B?ckZUSmFUUkdYMm9MRHQzRlVjamE4UEtEZXJ4Mzg2eHlGR2FRZGFaMzA4eHlk?=
 =?utf-8?B?Z0RjeTZQRThQWTdXWkduN0QyUEdmbDZZcTU5dkQ4RmY3bk1KelE5akM0cUpx?=
 =?utf-8?B?ejk1Qnk0YUJXWWZTNTNVanU4U2ZMdUZQb3pWb0h5MjhEYi9HMzBoQUJyeVJk?=
 =?utf-8?B?d01kc010MFJCdXNqc1IwN1NQVFhySjB0aHlRZ2Q2aUIxdzI1R24zUDM4VFQy?=
 =?utf-8?B?MEdHQVJieDIzRm41ME9sNnM0ZWl4L2paaUl3b2hQbVNpM1ZPRDIvdnlQenU0?=
 =?utf-8?B?Tkx3MW9zZG0rQW95Yk9lOG1JVlRkMlRlSENvUExqT3JzUXMzN3JTdEVZZVpK?=
 =?utf-8?B?UlRFMnBDMDVHbkJQWDQ0MzFVSjlSYVJjeVRLZFpuem0xc3VjaTJkRzB1dERX?=
 =?utf-8?B?VWFRZnR2RjZEcmpZSm5JTXBZYzdCZjBqWDBJVG9WelZOKzIweUlpTys4LzRo?=
 =?utf-8?B?VDBQbW0vaGhLV3pCRjRBdytJMjFEbHhyUnFjWHNTU0Q1Q3V3VkZOeVdjTUpI?=
 =?utf-8?B?M3BTcnF0dll4UFpkYTUyTDJ4RHJnRlJUY0Z3bmQxRDdhRFF0R1VqTENRRUhk?=
 =?utf-8?B?L1FLeUJRekprZjhlbjN6UVl3TldjZXNrM3gva0JhQ1RWYlNybmVuSlFzRXkv?=
 =?utf-8?B?N2dFWXdDUkhBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czkzUUNFTERRRkN2bDluTmZ0ZW9RaE1nZ3NGNXhPY25oKzFGSnl6NEtKSW9v?=
 =?utf-8?B?RWlXU0lqT3ZEc3RIdFlsQi83dFRmUlBramprdWxIVWw5cVkvcEprcE8rR0dQ?=
 =?utf-8?B?YzlLZmNqZmUweVRibnBDM1oxQlpJa05OODRYTTZTSlRjRGNtYUNNRXlLSGNy?=
 =?utf-8?B?eFZTcEQ4TGs4WUVOTkVWaUZJclJYajJTOXg1WUV1Z0UwalQxRTBqRlBCczVH?=
 =?utf-8?B?Z2ptUE5lblVHcmtXem96YmxBalR5dXhwc1daK1RUYUFIdEdjMnZ2RzlTRDFV?=
 =?utf-8?B?ZVA1TFVaSzFVc1UvK0JiRU50cE9RNTVUMU9DRXk2TlZyVlphSTFpWXY0RzI3?=
 =?utf-8?B?VDBnU1IrYjFkTXhKMHJnaW5IS1RVZ1lhZ1RrbHM1d3I5TEp1anpSeW9kWXVT?=
 =?utf-8?B?VnpQSkg2TFVEWVUzbjY5TFZLa2pDalh2aWFLSHhRL3pmSElLNmp0ZzliQlh6?=
 =?utf-8?B?WXZVWHd1Q0VhVE9yZUduYkZRcDZYSkZWbVBhblJNRXJKZ0x0UjBlWStBM2Ri?=
 =?utf-8?B?WXMrVm1GQzFvdkxCNFR2MURyYnNORGFNMHFNVXNSYW84bWpTRHNiblR6czY4?=
 =?utf-8?B?YW9EeDduN3lIeEJQL1pDWWlkWllENmhwa3N2Q3FoaWxXdmIwbWNScEhsYWpz?=
 =?utf-8?B?ZnlhazRNWTBIV3AyNXNlaHZzUnNEOG9leHlLVVpKL2xZbjROSC9qSDV5dWcx?=
 =?utf-8?B?NUJHbnFSNm1tejVaVDVodld0UTB1ZjNnRHlBcElOY083MGQ0NUtLUnYrcWtB?=
 =?utf-8?B?OWVkeUYrUFBDUGVGVnhzYmZPa0Q3VlhIdGFPazkvYUJUV0hKdkJyeERyL2Ni?=
 =?utf-8?B?UG9MVElLaDhrMGNTaUREbGpSVG9sNitlbVhsN1dWTVN1ZjZxZTVkOXlhcDBl?=
 =?utf-8?B?SDhoMHlSTGhXb3VKQjBHMzlEZVk4emtRaDNPOE15U1lNSys3U1NnMlptcm5W?=
 =?utf-8?B?Z0pCVFFNSW5jUFdXWFhyYzlaNVBDSDhseFRyWFM0VFIyR1BOaEZZdmp3dW1h?=
 =?utf-8?B?VGxnWlBub09qL2x1Nk5BWFlWN0F5TTJ1WWxmYXZKbHhpNllNWHk2R29ZOWNk?=
 =?utf-8?B?b3YyYkxtOXE4WUJhT0NLNE9PQ2xuSENXZXVQYkpXckZ4aExDVTg5VWZJeTFZ?=
 =?utf-8?B?QnNzWlZRN2tTY0JXSVVsVjhNZ2NDMmtteVR4bVRGYWRFSE9BYjBrU0tSdEgy?=
 =?utf-8?B?S3BscFU0VFJhdUIxckZLRDAwV2pEUVB3c21zSVNNbWpMSGtkTnZDeG5Pd01G?=
 =?utf-8?B?b3lpbkUxTm9rV3JvVmtjb0lOakRqNStrVDlDT0F6ZnltaU9xMXA0YUNDdmRz?=
 =?utf-8?B?cW8wSFFXK1l3NVNYTkhOeEU5TFN0SlBLOWRkMEtPcnlCczNJV25hVmN3RkdS?=
 =?utf-8?B?VHZDNjlCTStjUGl1UE1USkcwNVBMSzl0a1c3ak9YNC9hVjlvbExyMnlEYjBi?=
 =?utf-8?B?TGRic2U2YUhWM1hnenRoTXo4YmF2NFp1RFdHc0t2YS9jOUZlYVIzMGptYlR2?=
 =?utf-8?B?SElSa25icEk5SnFGUVlYN09QNzA4SEEwSTlrQjJHbEVncnk5c0VnenExdW5Q?=
 =?utf-8?B?d1c2Z1FMVGJCZVprZVVFTi8rRk0vNVpoTlZYc1VxYm5kdHdHazRWVi82Yzc0?=
 =?utf-8?B?U2cwcjhQMXk5Z0xDRGp2LzRualZxY0VBTThTUFJKQUd4SXc4K1ZHTndwVDB2?=
 =?utf-8?B?VDNPdjRJS05FcGtnaEM5TVBZQlRxMVFDOTBLd2pZTEttKzdtMUxUeHhwT05z?=
 =?utf-8?B?Q2tidXE4TTNXQXREbVBOZVhLUk9vaEJDYTlRMFgzWHQxdVRRc3VlTDE0L2xL?=
 =?utf-8?B?c0l0SmhLZzFmN1VFY0kxNUhGMWVPZ1Mrek9UOTN1ajd1OGVaRnZpOGJQTDk1?=
 =?utf-8?B?WVgzN0JqbWVCTnV1cEpZODdyVTUwM2p6eEhSYmRESWEzUElvdGZDYkhCZTlk?=
 =?utf-8?B?dXJWTVRTcHBxZHBid29ubnBqSStJRzh4THo1N1poS0RPMlBGZ2Z3aEhnd29r?=
 =?utf-8?B?VTRGT2ZIUXFRNGR0N0xnZ25GWEptZlVjKzYrNG02T28xTVJuZmNpMUJqTGt4?=
 =?utf-8?B?TXVSdkJRczlXWmY1MnNuRjB0YlJaUVZhRmcwNlUzck1acldRWC9NSEdpSm9E?=
 =?utf-8?B?MzFyQXdhekx1RnFnTnZYRCtsOTNNdHdsYXVMNWFmZzhJYVJpQUc5bXkyWmx1?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65BA2F702D9F8246AC63FC4563C39C5C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e57bf45-fe64-41dc-e9ad-08ddc443ee07
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2025 08:36:59.1245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6i9/e14yqTm8D37hmP0ZRUJkuY8dejp2K7+696yfzRcNd4TiEuiQ5/G6lAdSgd3qi30RlMdge2v1YDxF4bHkCyT3mMS6cIDaMo32AoSpIws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8814

T24gV2VkLCAyMDI1LTA3LTE2IGF0IDE0OjI1ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBUaGlzIHNlcmllcyBmaXhlcyBzb21lIGRlZmVjdHMgYW5kIHByb3ZpZGUgZmVhdHVyZXMg
aW4gTWVkaWFUZWsgVUZTDQo+IGRyaXZlcnMuDQo+IA0KPiBQZXRlciBXYW5nICg4KToNCj4gwqAg
dWZzOiBob3N0OiBtZWRpYXRlazogQ2hhbmdlIHJldHVybiB0eXBlIHRvIGJvb2wNCj4gwqAgdWZz
OiBob3N0OiBtZWRpYXRlazogQWRkIG1lbW9yeSBiYXJyaWVyIGZvciByZWYtY2xrIGNvbnRyb2wN
Cj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogQ2hhbmdlIHJlZi1jbGsgdGltZW91dCBwb2xpY3kN
Cj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogSGFuZGxlIGJyb2tlbiBSVEMgYmFzZWQgb24gRFRT
IHNldHRpbmcNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogU2V0IElSUSBhZmZpbml0eSBwb2xp
Y3kgZm9yIE1DUSBtb2RlDQo+IMKgIHVmczogaG9zdDogbWVkaWF0ZWs6IEFkZCBjbG9jayBzY2Fs
aW5nIHF1ZXJ5IGZ1bmN0aW9uDQo+IMKgIHVmczogaG9zdDogbWVkaWF0ZWs6IFN1cHBvcnQgY2xv
Y2sgc2NhbGluZyB3aXRoIFZjb3JlIGJpbmRpbmcNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazog
U3VwcG9ydCBGREUgKEFFUykgY2xvY2sgc2NhbGluZw0KPiANCj4gTmFvbWkgQ2h1ICgxKToNCj4g
wqAgdWZzOiBob3N0OiBtZWRpYXRlazogQWRkIEREUl9FTiBzZXR0aW5nDQo+IA0KPiBBbGljZSBD
aGFvICgxKToNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogQWRkIG1vcmUgVUZTQ0hJIGhhcmR3
YXJlIHZlcnNpb25zDQo+IA0KPiDCoGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCAz
MjYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKystDQo+IC0tDQo+IMKgZHJpdmVycy91ZnMv
aG9zdC91ZnMtbWVkaWF0ZWsuaCB8wqAgMzIgKysrKw0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgMzMw
IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQ0KPiANCg0KUmV2aWV3ZWQtYnk6IENodW4t
SHVuZyBXdTxjaHVuLWh1bmcud3VAbWVkaWF0ZWsuY29tPg0K
