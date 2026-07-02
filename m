Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AF02D1907;
	Thu,  2 Jul 2026 08:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782982028; cv=fail; b=aDjVbAulYrOes64LTX3z0xxPjxRp60eN+DyqSw6taoDWY+fqwukUB/Nq1TEZGPqRuZUDtENmKiIHO0OEUZPeXVI05ZKOixtOpFuDtsfFPm8KkmwU9zyaBE8SyytmZ9Z0z4Nbe2RD19ezGmB+vD8MRRtsmixRwBA62mjilQZCTqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782982028; c=relaxed/simple;
	bh=7XlbygxzLqHVjBbe2bNj3Ej8rwXtjGEFcS1QGdsS7Vc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iZvZj1EtFnebFec0Oicdx6Ne9c+yqtj8+2NK0j/gL8eq1wOrL3Wgl/Sy5nCAeTIWfSECwBAKUSwicn5ogxYcqF39HykVfM56P2rZOo+QbzjhEhpHbsLlvAMBRijlU6WY5YaXGxgOoJ4YG6Rg02IlzAqbpQ4OHDOT3W/g/LVSFZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nvq5zQS/; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=aN368mdK; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nvq5zQS/";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="aN368mdK"
X-UUID: 9708d22875f211f1b1788b6acf885367-20260702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7XlbygxzLqHVjBbe2bNj3Ej8rwXtjGEFcS1QGdsS7Vc=;
	b=nvq5zQS/pnhfRxaCf6YhRd2JGiYA/wkYd/K/AQ3cl8O1Emr+eaXeLugJzx4H0GVvX7rH2eyhq6+s+Eiq4df6VHHDK77Zm8T+XLOUGnhXw3OzzsxTgVCJyiANH6tGHAha3lyXC8Mb51HI9U/sbc66hQIHu853ArapiyafwSV836s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:dfccfe19-9682-4f8d-b9a1-18f34cdc84c2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:15443604-3795-4a90-800e-68e9393a343e,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9708d22875f211f1b1788b6acf885367-20260702
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1018611437; Thu, 02 Jul 2026 16:47:00 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 2 Jul 2026 16:46:59 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 2 Jul 2026 16:46:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b9Ypoc4h1J4KbOc5cTCLxjhog/BxTJoL5diYFwWhZHMoQGvC0JjXvYaZ1jkLobSHdj+tRVe4uyVGOYpsirPx7dH44jpAg74sV20jt5V1DXsJ8u2PflXfq3j9qdjc1JkqF0JRbG3x8vEQnH2hcubqIrJy2pOXALzWPok9b4AZLEZ6f6LEGMk/rJf2MobgrDZ4P+4Y4vucZ+8kYTTskAbqF1tF2skQg6aAKv1TCxIBtK/4+80YJawj2uRzRY17MiLM2Tqbn3zYpPB3snfng02Q5SWk6ASpwyUG6aHtP0mIxsyysfZT2oQW/qoqjqrXzVQBpaCpdcei7eJqxojiIRQewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XlbygxzLqHVjBbe2bNj3Ej8rwXtjGEFcS1QGdsS7Vc=;
 b=pNUalDzzCRLVszsmHpz+Ezr5H2ZdTs8/0Ubo82c+WSLJwyJ8cqbmZbmZenLrBR0gKS6JtrfOguxOrybhmwcF+QxsDiJdoLohY1gaULtR4BPSFyGQrYD22TDDh5c8sa83P9HUzdSWw1Fc/H8CNiNzmLv8d/oDQ9ys8oholB6xx82BAlbt/VlYLoxqT/fUNhbCJK0UVihSLn0ka8m9QCL1zLEU9pzBrMDhXxoUfWVN/atVH8/g2SXjmAuY1NA/cIPA8rib0Rde5oraY4Gn4ALXWWjEK+KQJzQfryn2ShPT9bI0axzlaRYF9cV2Z2oX0Cy9+VEIbMdEP+Wpnwvh0Lbt5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XlbygxzLqHVjBbe2bNj3Ej8rwXtjGEFcS1QGdsS7Vc=;
 b=aN368mdKKWdyQrb8cttqC2KMIf0fNJ7VlUuvtFS2DAcAM47lQHoNQuM0KuCSF71jIQrQzPCEI48NSkJvWWsPHQgjx3EJskEb2n4kMPia6lpTnbYJfYjUMYLEoMe+Tp/DEP4AgauXU/Lja6sGSNQzKlABJZP6cF30PfUwLvH7CDQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY1PPF216A5C06A.apcprd03.prod.outlook.com (2603:1096:408::a49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 08:46:56 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 08:46:55 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?=
	<eddie.huang@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>,
	=?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?= <Yi-fan.Peng@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
Thread-Topic: [PATCH v3] ufs: core: add hba parameter to trace events
Thread-Index: AQHdCNLi94hno+2a0EKBFGOrIXb6GLZXoxmAgACMM4CAAHFzAIABTEUA
Date: Thu, 2 Jul 2026 08:46:55 +0000
Message-ID: <eea8453a5ea763196038b54ee3a31092432a007a.camel@mediatek.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
	 <20260630165612.3e21b510@gandalf.local.home>
	 <20260630174949.16a9d867@gandalf.local.home>
	 <e4c090a5b8402fe3db137d986f9a6639de73cc67.camel@mediatek.com>
	 <20260701085740.218cf4d9@gandalf.local.home>
In-Reply-To: <20260701085740.218cf4d9@gandalf.local.home>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY1PPF216A5C06A:EE_
x-ms-office365-filtering-correlation-id: 53f52f26-03b6-45d4-acfc-08ded8167874
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|56012099006|11063799006|4143699003|18002099003|22082099003|6133799003|38070700021;
x-microsoft-antispam-message-info: Bslea41xWSMyH32C/UouWyrEd0nowCYGVoTBaUvSavUSBXk+R3I9LD0TjGIcrE/PXfPU9BPD9abjbzddxme0eRupyYW5m1NZalg2QK4zCkoQEiwigNfgmUQ4hfNXdRTgpljTjZuzIQNKSWv+BsIuOakKQqPyzs4j2PYgU93Ew7tPXru1yOc0ECQWD9AboZThbMjme6rl987ExjSoLrkjMTVN/uYbXEF7fWmMhEDlAU8tXnm5ucPA4/hZCblrrUUv23eqUIiUoIp+mlhQONJrW1Nbvu6+BKQuRcvxoOYmFVYBe4yZcjK8tnLMYhwu/47Q57TYcNhlDOgRdmQDwF/QFoijUNX8FON5zNL7J8Yh/IEpRGOgFXTpTFRyZRfDbGCGKepq1fkUWPixXarFPyx1fHauvUlJb1a0Iajsd7ZDxnljE35uecDcaHmjpDhYflE4HJV3VurVvXMWzg27tOm84/KkDZd+nfx84P9xhvcDvRirkSbHMmPKqOiVKlYg1ROei2Stl8Vz+jTzCEoeTJQeLmtUPs0+y9gdi+eHAi088I1m59G1C/JxNttJ+/RY6s1HKDxJtUxWa5H9k6wgnt6GlPtVnx2W4Rg6UXVe75MV0SxH3M/bvGwXJ1F6DeXncOHNDSdp+sTETFHkvKOKEWO/Rdz4rQnoMj0Ydx0LMTngWZcg8GeBjLqpyR+CoPwbkGtR+YnTqTjrs9T3s5pPw3jk1BOpb4jEtZROSA2PP6NWaa4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003)(6133799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlM5Zkx2RDNwL25NMkh2eW41YXo0b1FLWG54eTNqVXhwSjNZZG41WHE2Z1dj?=
 =?utf-8?B?UEFTOWpXNDFJa2NNQlhGRVh6M2RKTTJVVEdTNU5QanpWSU5sOS9RL0F4aCtQ?=
 =?utf-8?B?RFdhUCtha1JwRFdvN0NlY3FGR2Q5ckh5bXBRSHFuSVBHK0sveHp1c3Y1K3F5?=
 =?utf-8?B?MEhBdWFlOFVGbXlQM1U2dU1WSXZKMmdsa0pNNlh2aWxkME4zMHdOL1Bkc3hn?=
 =?utf-8?B?bnF1N2RUcG9WRVo3S0t4SDZ4d3JLVHROTWJER1RVTzlycEV1UTRISnhqOFNS?=
 =?utf-8?B?Y2JXamt6Yndnbkx5MnpKdkZad1cvRko5eURKVVpVUFYrajJKZTdQRXhoWkVx?=
 =?utf-8?B?a05mL1Bnc2JFUmIrbWM0bG5QYXY2bVpRZmRocEJpU0ZmbG1VQTdHbHV4YUw0?=
 =?utf-8?B?RTJOWjJGS3Q0Qm1LNzZIdlZjSmJiTjhxaVIzSHNJUUFvV0F1cS9ZKytBSTEw?=
 =?utf-8?B?RDBrWVNqS3RqWnJ5VS9mRzlUbGk2UjQweExsQk1IVlBydGhjcml3Uys0UWN2?=
 =?utf-8?B?U2poeGZmVXZqdyt5Z0g4VEs2UCtIbVlNVnFubW4rdkNQU1p1Tm5pdWdmYzFo?=
 =?utf-8?B?ZERGZUtEd3FXZ3FFaFBnUTgrcm5LR3RrUUhaYVZqQy9uVFdBSTBqSlQ2R1Bs?=
 =?utf-8?B?a1B2aWlpZjV5TTNIQzdhUTJwQ2JoKzVaaWNoQ3pMYWs1dFJWVnBiTGhmdytp?=
 =?utf-8?B?WHQwOExaR0tEeFhxeWd1TUVBMkdNMmIxc2grRHllVk1qcFVhUlpwM2d5SEN4?=
 =?utf-8?B?T3RsYmovOVZ0NldpNXZzeGxxRDZtNDR0eVQvRmk0SkZvQ0J6ZWZCZTFoSXRH?=
 =?utf-8?B?anF2MEFJb2JTY1ZueWtSbWxiSGJwRnRQVnE0a3l5QUNVWkdNS0dMeGFhV0RB?=
 =?utf-8?B?dlpQNG0wUVloaWxTZFlMS1Y4NTNKTWtKMXNEMnJnQnN3RzdYaElQaHk4alY0?=
 =?utf-8?B?eWloVEFxTFRHVGVzZFhVMHlkRTlhcCtpWGFSQzZnalVweVBLcSszS09vNktN?=
 =?utf-8?B?SUhVcGFMNDlDNTdaTlI4QWxxeEc0bTJTQlR2SkJyTktyWG1jSWpDOUtBcUNB?=
 =?utf-8?B?SEl0dmNtYWVvKzFZUVEvV2dmTXgrWFgwblNvaVB5cGhBNDYvTFd1NUZGTVda?=
 =?utf-8?B?Vm1JTENYVTlDM0NRVDU0WDJsRWtNVUpxOUxpTkpoQWVZa2VmQ3dtRVluby81?=
 =?utf-8?B?NEZXb1gwVHVpREdPTTBWelVEMFIwQk4wdGhlVkN4NVAvd095K0trS1Z2NXhK?=
 =?utf-8?B?Z0kvSkpjcFRBL3R4TE92ZjROTUxkQ2ZOM3pUem9uZHlxWXFMc0FMTDFnaS9l?=
 =?utf-8?B?Tm5nVWorbXBQTWQrNWtYbXFWVTU1bHJtSzlNTU9ueDNja1VyUDIvY29kSHhr?=
 =?utf-8?B?NUtzZ2FaSG96ckQzNUM1NHc1MHcydGRYZnh2VGhPWU16YU5YT2Y4YUFSNDZv?=
 =?utf-8?B?dGhiK0p1b0FFOFkxSXNXL2lxT3F6Ukc4QjU5bVQvcDBvbm9rRU03YXY1NXJy?=
 =?utf-8?B?WjFnTVl1UzUvelNVYkdKS20vekhpazNzRWhHRUlSUHhJM054OEMvTWRvd0VW?=
 =?utf-8?B?aWMwZHJtbDhBeEdiUmJyNUloQ3RENmpWT2FZek1LSm1iNzdxWENQSEEzQnYv?=
 =?utf-8?B?K1pjRnM3NCsxV0dmT0xoZkFCU0p5YjFRMlRKRGFNRjBWbm9DbmxvWEZYYmk3?=
 =?utf-8?B?emV6cDhLeHFnL2VHQzRtblV4eFd0dXRlUnA0SEhRdm13OXd0TnlmbTcwZHZi?=
 =?utf-8?B?Z1VWaDNJNjMrSzcxalRQYUExU3hLcitYelJRUkpjOSt2MFVSNGRHWndOYmMz?=
 =?utf-8?B?VnpLMVBnNVRBaC8yQ0kwNW1mNUlkOG9IVnZmTDBHSG55dXhsSjhZYnZiUzlu?=
 =?utf-8?B?dXpGVmNFMDBDR0lJOWtuZTIzSlM1dHA3KzdhQ0pHdlJkQ3dNdnlhRmNwVWNP?=
 =?utf-8?B?dkM4RlFiRUVoaHd6aFQ2OFdhRlo4bzBtU0cyOXNNWUg5VXVycmY0TGkxV3Y1?=
 =?utf-8?B?ZWE0U1pQQmppcjMvTDRnMXh5aW80ajJMTXhZemJ5Q3ZtK2tGeWJyQlJla095?=
 =?utf-8?B?K0Ric1pnbFRKbzZINFVEK0tlRHRjVm5jblFHWjY4ZlVMQ1pVNlM0eFNiRFpJ?=
 =?utf-8?B?NjVyVjZtdGViSWdzaGtNcjgrd2JOTzl4ZncrWUI2R0ZtVjZadTl5NVB6USta?=
 =?utf-8?B?UnlpalU5M2t0QnNhd1BXbVJtNXFCUmdiWS9SN3NLYmg0SG44ZzUrTnFRZDBW?=
 =?utf-8?B?WHN4SFNLbHhPbWh2eEIxRTJ5THZud2UwYzk2N25mOG03WkRRcTRZZ1oxb3Uz?=
 =?utf-8?B?RWM3Qmp6ZXI4M29hRmx1SXdkdG12L2FPc01CQ0U1QWxMYkljdzV4dVY0SWlB?=
 =?utf-8?Q?JM7fY1jMMwSfKM/o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67A12515E662634EBBDD1C0DD2BF5E3D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GzUFEg1rg/3JPC+KCP4YzUkxc3vMiGNuZDoESUWtrbgqUfMzWCg9P8051WC9IZK9cBtKIYIrdLQF8dymJWrVCUe9XA727YWZkZnLN/udGKcjYp9j+Q0yrnO+9IrmpYO82ZmhQ3kZdeKgoFR4aHudjFkA/0z4sbmA7BaAu1vjrCqzVw3k0k0jA6nypxPzZcP7+ZksuV1cdDhFCjqoxSAzkXiNLrjY84MBIGSjx5nUHbSS4h4/iD5Lw+ewspLHKhDJslYwJi6KGFB14Jzc0CDsXYElayTZ5BPPH+So0G9KHjeAYMbyfQLc8alAjh3doyBPkVddcaF8K83tLV7oss4y9g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f52f26-03b6-45d4-acfc-08ded8167874
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2026 08:46:55.4864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C322muq9ei1nSAZSDgdVVSI06BIt+i8QgT6ecaJXtNNNk7xAXmqH17yRiw+o5Oa0adADGTFy148Y1Fg21Fvl9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPF216A5C06A
X-MTK: N

T24gV2VkLCAyMDI2LTA3LTAxIGF0IDA4OjU3IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gV2VkLCAxIEp1bCAyMDI2IDA2OjExOjM3ICswMDAwDQo+IFBldGVyIFdhbmcgKOeOi+S/
oeWPiykgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPiB3cm90ZToNCj4gDQo+ID4gSG93ZXZlciwg
SSBhbSBjdXJpb3VzOiBpZiB0aGUgSEJBIGlzIHJlbW92ZWQsIGltcGx5aW5nIHRoYXQgdGhlDQo+
ID4gc3RvcmFnZSB3b3VsZCBiZWNvbWUgdW51c2FibGUsIG1pZ2h0IHRoZSBzeXN0ZW0gZW5jb3Vu
dGVyIGFuDQo+ID4gSS9PIGhhbmcgb3Igc2h1dGRvd24sIHBvdGVudGlhbGx5IHByZXZlbnRpbmcg
aXRzIGRldGVjdGlvbj8NCj4gPiBQZXJoYXBzIGl0J3MgYSB0aGVvcmV0aWNhbCBpc3N1ZSB0aGF0
IHdvdWxkIG5vdCBtYW5pZmVzdA0KPiA+IGluIGEgcmVhbC13b3JsZCBzaXR1YXRpb24/DQo+IA0K
PiBOb3RlLCBpdCBkb2Vzbid0IG5lY2Vzc2FyaWx5IG1lYW4gdGhhdCB0aGUgZGV2aWNlIGl0c2Vs
ZiB3YXMgcmVtb3ZlZC4NCj4gVGhlDQo+IGlzc3VlIGlzIHRoYXQgYSBwb2ludGVyIHRvIGFuIGFs
bG9jYXRlZCBkZXNjcmlwdG9yIGlzIHNhdmVkIGluIHRoZQ0KPiByaW5nIGJ1ZmZlci4NCj4gDQo+
IE1heWJlIG9uY2UgdGhlIGRldmljZSBpcyBjcmVhdGVkIGl0IHdpbGwgbmV2ZXIgZ28gd2F5LiBC
dXQgd2hhdA0KPiBoYXBwZW5zIGlmDQo+IGZvciBzb21lIHJlYXNvbiB0aGUgZGVzY3JpcHRvciBp
cyBmcmVlZCBhbmQgcmVhbGxvY2F0ZWQ/IE5vdyB0aGUgb2xkDQo+IGRlc2NyaXB0b3IgcG9pbnRl
ciBpcyBzdGlsbCBpbiB0aGUgcmluZyBidWZmZXIuDQo+IA0KPiBXaGF0IGluIHRoZSBsb2dpYyBn
dWFyYW50ZWVzIHRoYXQgdGhlIHBvaW50ZXIgd2lsbCBuZXZlciBiZSBmcmVlZD8NCj4gDQo+IEFu
ZCBsZXRzIHNheSB0aGVyZSBpcyBhbiBpc3N1ZSBhbmQgdGhlIGhiYSBpcyBmcmVlZCBhbmQgeW91
IGRlYnVnDQo+IHRoaXMgYnkNCj4gZHVtcGluZyB0aGUgdHJhY2UgYnVmZmVyIHZpYSBmdHJhY2Vf
ZHVtcF9vbl9vb3BzLiBOb3cgdGhlIGR1bXAgaXRzZWxmDQo+IG1heQ0KPiBjcmFzaCBhbmQgeW91
IGRvbid0IGhhdmUgYSB3YXkgdG8gZGVidWcgd2hhdCBoYXBwZW5lZC4NCj4gDQo+IE9uZSBvdGhl
ciBwb2ludCB0aGF0IGNhdXNlcyBpc3N1ZXMgaGVyZS4gSXQgbWFrZXMgdXNlciBzcGFjZSB0cmFj
aW5nDQo+IHVzZWxlc3MuIFRyeSB0cmFjaW5nIHRoaXMgd2l0aCAidHJhY2UtY21kIHJlY29yZCIu
IFRoZXNlIGV2ZW50cyB3aWxsDQo+IG5vdCBiZQ0KPiBhYmxlIHRvIGJlIHBhcnNlZC4NCj4gDQo+
IC0tIFN0ZXZlDQo+IA0KDQpIaSBTdGV2ZW4sDQoNClRoYW5rIHlvdSBmb3IgdGhlIGRldGFpbGVk
IGV4cGxhbmF0aW9uLiBJIGhhdmUgbm8gZnVydGhlciBxdWVzdGlvbnMuDQoNClRoYW5rcw0KUGV0
ZXINCg0KDQoNCg==
