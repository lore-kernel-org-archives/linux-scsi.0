Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0516A265CBF;
	Thu,  8 May 2025 09:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746695569; cv=fail; b=M0J16FT0viGpNWF5luYKwGyBCIuEGqcYIFFN+Ol+md2TefYsEml35hA5braorCNHBa5hpUKEGjkrxebYkFxHzFz2VAa3Ceh6/nHyZLyDOKXZc9pMFS+8+8lzaDSCRwDPuS+HFwiSLTWq3S2Y7v8+SW8EmbQzO4DILitg4uezAxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746695569; c=relaxed/simple;
	bh=fG4vgTtrEC4VAEFhaMZg8gyKqbnloWnOkXJs9wLILTI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PcwqXn02vVGaN58HnKcbNfsWr+rH9Yjv6yGOx0SiDT95DFfEHfg1J1LZ2zvZOy5qcrUTui4+L6xLs10/lfBjEeSA2XfLryGXb5IBZJks26FzI0nhT1alfnMZdbGZJJllx/dbpBnwv1WDLtzCSlhhMHvahgS9hpl7b1OLn87CoUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dW+sKSAl; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=kQxaHWo4; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dW+sKSAl";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="kQxaHWo4"
X-UUID: 981ea5da2bec11f0813e4fe1310efc19-20250508
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fG4vgTtrEC4VAEFhaMZg8gyKqbnloWnOkXJs9wLILTI=;
	b=dW+sKSAl7ueW1/HxGn43PGWahbXbhIPC8DEyXxwa8ozwucdBXVhYy1yULMuVTr3QUe1uVx4mOK2SaOR9zlL7Q+q75MlNCqVbhmCgH+xiFqvEB10oHQve35A8avkRYezUkhztID28v/EbufBE9CeOhfUOHoEYtORL6mBcr8TTbL8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:667464ff-1944-4c09-8091-08280c0d0ffa,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:8f916e80-1eec-4f76-b81b-944fecd9abcd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 981ea5da2bec11f0813e4fe1310efc19-20250508
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 323523808; Thu, 08 May 2025 17:12:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 8 May 2025 17:12:39 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 8 May 2025 17:12:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pQvVPjnFwwhELkBd/P+RRA8zutJMG8TbeTQkjUv6Le0h7VH/1XCelAOCC4Mk1H/xBPCyySYbRhcsF50wN/DL8f/Ch+S8+M8h7nkC14kgsaSlqZG6EUaq3Jq+MJna3H7P9og2z4dZzL1z7m/egZC8t5iBV04OXSLqLn70EdQ/4H9ff+kUE98UG/YK5Pdf4V9l2M6RmgTC9kYfAyjXBoYzLT0pCnoKl727rrGUmJRI3nZtXuVMq3S40mHBEDY+ZbX4z3TiwFAKtQEHdNpjKfZU3XTfcj7I0pkbrngab4nEHbxoiSSLMaUEcEVRSva5dINiSJL+Sd+h9uznhLtG3LXLjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fG4vgTtrEC4VAEFhaMZg8gyKqbnloWnOkXJs9wLILTI=;
 b=BKN+EWVQM0h6dtvl4qugDwFiApu2xQqUjrHQCbXDp/w7cWzfE1cTD/T1QsGz+ZLndJ064X+5MTMfs1xI3DlOXWHMLD9A+gN08VHZHKnBJyyZU24YxDSqw2CfwdttzKa3MZrzRVmKU0QN74oOIB/fw4niyvJksDuSNL8l5EQcRguTVwuWi64bwsIgKqcJJwbn+tW7JBAL/lDAID9uALS1Gh5jjLyeP2dJU91xu59CWZthBbnzaIH7MZC4ZpKP4gtml5lecJH4nRu7s+K3ERaXgpWmETPWbkfoSRifpWPuctwNzz4VVRruhx7zYZdN/xODDwM3NIP/zrjBs6Bu710GYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fG4vgTtrEC4VAEFhaMZg8gyKqbnloWnOkXJs9wLILTI=;
 b=kQxaHWo44HMCkdrNueKrCaIvogjffqQpPZiloYGC2/2evHDhcbMikXQBWK5UjsMvIFIyuKYQfGgc+bWOf4fFRQeAwOkakMf8gQ7FUOZPrXo7i8bNR0hrxSkjlCbU6VMd3iwiDigrBOhQ8TnJYUG3NsH8MRRV2Pz46/9Lw2Bhf5Y=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7258.apcprd03.prod.outlook.com (2603:1096:820:be::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Thu, 8 May
 2025 09:12:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8699.031; Thu, 8 May 2025
 09:12:36 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?=
	<jiajie.hao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: fix hwq_id type and value
Thread-Topic: [PATCH v1] ufs: core: fix hwq_id type and value
Thread-Index: AQHbvoQWPkIUMOxC50OqQ55NExCIJbPFxwIAgADF6YCAAQIHAIAA5rKA
Date: Thu, 8 May 2025 09:12:36 +0000
Message-ID: <5adddae8a46a5dd7e1feb6e0cc9bcd76e91d0611.camel@mediatek.com>
References: <20250506124038.4071609-1-peter.wang@mediatek.com>
	 <04fc1549-0fa6-4956-b522-df5fbc26100c@acm.org>
	 <6c9e983154ff8d9b4a1e63eb503e8b147303eb68.camel@mediatek.com>
	 <95235015-270d-451e-989c-9fddcbfcb97e@acm.org>
In-Reply-To: <95235015-270d-451e-989c-9fddcbfcb97e@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7258:EE_
x-ms-office365-filtering-correlation-id: 5f0f523c-efbd-45d3-c8b5-08dd8e10794f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bXFPTU9IVXorNmdHdnlFUUtTeG8yeHROT3BwMGFwc3g5SUVhL0owK2NKMm9v?=
 =?utf-8?B?cjZUd3FGVkZBbEZPeDJFbERpNkR1K2gwb1FFZWttbG9wcFIrMTFjWGpJRU94?=
 =?utf-8?B?WXFUbHZKbHdCS3VGN3RHaXNsajhzTjkxQ3lpVFlVejMwR290ZEFoMnMyOHBn?=
 =?utf-8?B?bWw1c3VBNnhMZEk5RjB3SUlNQmhoOXB0V3phNHZqY2MrMmFxY1RrMHUzZkNp?=
 =?utf-8?B?N0lwSUdyKzNCbUozWWNCVXRSR0J1Y3JmNUdPY1BPczNtc2dwdDVNLzlSYkxl?=
 =?utf-8?B?UTQ1OGh0SzVwN0VhcFBpL084RkplK3R5N2prRHhyNllTM2dscFlvTE1vcEdt?=
 =?utf-8?B?SXUyME4vcjhuMSttMkJjTEdWRmRUZWpMd3NvazQrUXluL1RCTVdUeE5lSEpZ?=
 =?utf-8?B?UTZOa2lwWVhOQStCOEdCRDgwOG9BbENHR0RpcHBKamMyOXdLYWJ0dVFzVk1W?=
 =?utf-8?B?czJuTEh6WVp2UGFKV3RlSDlBNFJLRkFhM1EvOVpuV1BPdnVUSFlmN1UwekFT?=
 =?utf-8?B?TkJDNGlmcFViVEdSWFF6UCttUmRpY04zMVE0bzI1SFpZaSs5aHJpNlFHcndz?=
 =?utf-8?B?S0ZNQ0tEUnVVcXUxZitjamxlcGFvZWdEVlJpbXRUeDRJU2VmMXBiOWZSbm12?=
 =?utf-8?B?ZDlUOTNxTXJEbHdaZnpqdUJxcVlDbjlobzBxak1hZGNINzNjaFNJdzNtbW95?=
 =?utf-8?B?S3dxWEpJSXB5TUdFMGU4ejVIVytvUVFYYXJFczVrekt3L2lMTWZyaGd4M3Zq?=
 =?utf-8?B?c1IzL1lGS3gxdTE4c0hMb2Rpc0JDYzhEMmMxaTJZRDRabmlLd1ZSczlYR1My?=
 =?utf-8?B?L09rVCtxWWpnWXo1YlAveExnblFUWE5qREsrbVRWZlltczJzcjZMY1d4aHlW?=
 =?utf-8?B?ck5jbncwL0NPdFlxWWVoRUdkWm9iV1R0Z3dVeFU4Y2Z1cFVwTk03YTVzOHNS?=
 =?utf-8?B?akNYenAvbEZVaHd6dVh1cGRyTWoyanBXa2RqKzZzeGpEbm1rTW92c0xlQ1lv?=
 =?utf-8?B?ODEzUytRRjhlQ1ZRcmY0UjNxWG5POXM3T0NOUjRqMUVTZ2sxUUlNeGxXSXNC?=
 =?utf-8?B?ODJBRzNOaFhBTWkra1VoVnVJbndCUWREUUxTTzBZeW9Mblgya1llbXNLaE1w?=
 =?utf-8?B?S040STFDQ3VoQkJOODJqbWdFQXdjbCthMmVoMGxlakF5ZEE5T0podjhnRUE5?=
 =?utf-8?B?Ry9NdE5jbVRmQU02VFNCa3IvakdiRXZuY1oyRE5VV0FNUlZSUFZ6bVZiMXlk?=
 =?utf-8?B?WFlmRGxvTEIzaGNaam0wV1VUVjFHREI0VU8rUEZoYWJDKys0VDllWmFTVGt6?=
 =?utf-8?B?MnZLQkdwNXQxWWIyTUkzSVpIM3U4NjFrbFBENytCbFVwVUNYZkcyRFFxbHVM?=
 =?utf-8?B?S3VRNVhVV0g0dkk1bHA2MEFqemVrTnd2dk5pUG0yNGpGVHdBS25CQzFWSEZN?=
 =?utf-8?B?SkR4S3o1aVNrRFNuRWp0SytodFZ2dzVORmYrdEdhWnFwMm9PN002ajY4YlMr?=
 =?utf-8?B?amhUSmFoUTVxR2hTMWw0UzdLMTBwYkxnL3FyMkV6L1N6aTFWZXFZbDRnODNZ?=
 =?utf-8?B?d0dtZmthL2dIWVloWm1CKzlodGxyeXZKQTI3WUpYbUwxOWxTc09XTzA0b3Zp?=
 =?utf-8?B?ZFA5SThlUVdhWVlpTWhjZ0IvdjFzdEFYYnBNZ2d3eVNRM0RFRXJXN3dXekhK?=
 =?utf-8?B?Q3YyMTE2dGNEaHRCUXp0YWxEQzVNdmZFWEkwS0oxdmpiZGhFcnZTWCtYTk80?=
 =?utf-8?B?VDFsdW9sczVBZHhYMmZ5ZlJLOVpDZTJycmUyaXdJTGhkQm5yQklFR1BvM2Fi?=
 =?utf-8?B?QjN5djFOZnBMa3Zra3BzK2ZhTjVkR3UxY3ZVSEdudWdjVk56L3lCaTFOSEo3?=
 =?utf-8?B?VnlKWlNoQ2ptc3VjN29rSU4wY1NlR29xdy9WN1ZieWp0aEh1S01GS0xLU0Jv?=
 =?utf-8?B?U2lia0JPN1V2ZmlaQWM1SENvbkpOOUZvamMyTWFOSVk5WTgva3YzcGhOb0VD?=
 =?utf-8?Q?7hD+3frq47NyWI6qwxBLpunq0EjyE0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTNyUlJmVW5OdFVDNll0RWgvZ3pQTmJXcC93RFhyNkVQZnFkQXpUdndZZkEy?=
 =?utf-8?B?S3RpUWVINStrN1dsalE4RmV4RkcyOGwyV2lFUWlQMllZc3NlRnliaVNta3Fr?=
 =?utf-8?B?Tlhlb1c1ang3YW5PMnBIeHZUMDc0ZHhPRFkycmVqSHZ0Q2pFS3Y5eFVOM3Nq?=
 =?utf-8?B?NkR4aHdaZDYrc2RYWXpNR1dscGg3WXBoay9aQnJvSDJ2YkFwYTRIYzVRVWtk?=
 =?utf-8?B?VnMvRU5kWmxnZW9ZWUZ3S3FGaHI2RTl3V0k4YTNrcEtBZlVVUVh4eVFNZ0JY?=
 =?utf-8?B?Q1lsOXVjVEk0cDM1enFYNXgvbytaNmh0UDl3R1lTZXUrN1pqQzREUUJYVVR3?=
 =?utf-8?B?bTUzWTYzVnhiRGFxNm1ONVNEUnRFSVJHajkyV2hTWnRyN2JXbHFnYS90ZTR3?=
 =?utf-8?B?SVVOM3ZXdVQvY1JrQ1NEQldML1RPTnltYkpZT3JQbStmbXBwWGpWQ1Ruc2di?=
 =?utf-8?B?MVVRRVdLSW5YQ0I3QjVmVW9oVmtXa29QczVHT3o5Ym1pQ1ZkN004dXF2ZSt3?=
 =?utf-8?B?OHJvaERteTROV1E2ZmZsQnNyTHhOWGZqUmEwUGVtZVV6dTBtb3RhN2hmY21X?=
 =?utf-8?B?V0lSL2F5TGg2bWxQeEw4R0JGK0wxckxUdSt6OWFvQ3hVT25UcFlFVTQwK2ww?=
 =?utf-8?B?K0FtdkV2ejVNV3o5M2VBeXpNOWpjVjBWSnFwOCt5SXAzMjBXTHBtL013K1B1?=
 =?utf-8?B?cDh4QVJvaUlrT3FLYzJwYXBuWW94MWlhdUtYVnNyYW9Xdk5kb01zQ3pQZExZ?=
 =?utf-8?B?WVQyMG9yMTFCOG1NWDl4QlIweXRTZXZNbVA0c0FPMzNkSlVZR3hQcko3WXVa?=
 =?utf-8?B?K3U0bHBjb3FLSFhXWVR2RDdoT0hKajNvVGd1QWc1b2JpY2hKeWlDbXpJTnZ4?=
 =?utf-8?B?TVBkMUZEOVE4QWpYREllcGRNZnFYRjZFaVlpRFk1OFRmdHcyc1JheHBBL3Qr?=
 =?utf-8?B?dmR4RFRxcUZmQXo1b0ZEZjFvZjUvc21tRGk4SHhWWXdnTHA1bGx6V2RNK21s?=
 =?utf-8?B?dGZsdlp4eDJGY1o5V2prVUxiSVBEMW9xdEI4Q3RTdUVTd3JiZldHK2VXT3M5?=
 =?utf-8?B?L2xCOWE2VUhMMjJzb0l3QnRCRmJ3bUNPK2UraU40bTg5S2RndndVeE5mUkhz?=
 =?utf-8?B?eVB0bDA4ak1JSkFuK0lkL1k3elZLSXZraXp4dHJ4TTVWb1pGbHFDd3VXNmhU?=
 =?utf-8?B?OFJOdFh1UFE3TjlNMkF1YklkMFNRY0hGM25QOVFaaTExekE5VjBFVCt2Y2Ir?=
 =?utf-8?B?T1RLMVdsSEtqVnhDcHR0dXlZMzZNWkdIUDN3N1NOMTAzWnN2VUZsQm5XL3pD?=
 =?utf-8?B?NHZmMDNSc2Z1Y1R1K0dPZzlqSE1IY2djRlovQW5MbENYQVc1b2ZmY3d5NXNQ?=
 =?utf-8?B?cGVTYms2VjYxTmVmSWJTeXhYdUp5SzRGdmxOMGRsQjVDaXFNSitncDhhV2RX?=
 =?utf-8?B?T3oycnVIaHIxMS95SGZSWGwrTXdPbWlodGZjMDRvVUVkeldJV1BVQTlJTGJL?=
 =?utf-8?B?WHI1UjdKTkRIQVFXZHJaek1TcnZJUSt0aUgrNGdDaXEwc0VXRm9wSVNVZmph?=
 =?utf-8?B?Vm54OUFyS3hldExRZWc3N0lESm1LK0hrNHJwcnB2TDVhaUNKdmtvazdXSnI3?=
 =?utf-8?B?M0c2b1g2Ti9PbFA1SS9ibTNtc0hPSFYrQnBGY2hKby9KMityNDFXTDRYZ0VP?=
 =?utf-8?B?Zkl2MnhOaXRMTGoydDBPYUljSW1qZ3hLbmN6b1owY3l0amR6SjJEYmplZmJp?=
 =?utf-8?B?YjIxVGRhMlJYNFpJaUI4YTZhNHBQQWZWVGttaHVmN2tkUE5vZ1hwdkZaNm4x?=
 =?utf-8?B?dDFZak52VXQ5UUIxVHdOWVZ5R1I2emh4UE9hZkYwUzZmQU9jb0FtOUlpS085?=
 =?utf-8?B?Zml0Q01RSlM0RlBBNFUzeHp3T1hiN1IzQjh2c0VJMndySS96UjBlaFJPdVE4?=
 =?utf-8?B?dFZwRDA2cDIrVmVKOG16d1liMEloRUJKMzc5TXBzM3FYME9SVkluR2xzZmxB?=
 =?utf-8?B?L1MrWFgrU0VRNk1FSUd4ZUNaVlNKclRZVDZvUGNxQkw4WkhPVExwdEZhYTdT?=
 =?utf-8?B?MmM0d0EwMkx0RG82S09DZmVpQTRPaU1JampXdFM3V09Jb0VtSEV5Vm1CeFJx?=
 =?utf-8?B?bEExMXN1b3dkWUF2ME50bWhpZHhHeVF0bkdwUFU0cmhzZDdqMk82cW5pcm1L?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD046255C9D35B44803AD8E4BF5C6864@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0f523c-efbd-45d3-c8b5-08dd8e10794f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2025 09:12:36.1957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aq8vwgXb++5VXmbY2OIRlR4pcgfM2DivxdGXTrpym1dDb+z0lfF+jiZo/hxngbIiDQuYBnSJbLbWSWL7grGH7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7258

T24gV2VkLCAyMDI1LTA1LTA3IGF0IDEyOjI2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBJZiB5b3Ugd2FudCB0byBwcm9jZWVkIHdpdGggdGhpcyBwYXRjaCwgcGxlYXNlIG1h
a2UgaXQgY2xlYXIgaW4gdGhlDQo+IHBhdGNoIGRlc2NyaXB0aW9uIHRoYXQgdGhpcyBwYXRjaCBp
cyBhIGJlaGF2aW9yIGNoYW5nZSBhbmQgbm90IGEgYnVnDQo+IGZpeC4NCj4gDQo+IFRoYW5rcywN
Cj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNCk9rYXksIHRoZSBjb21taXQgbWVzc2FnZSBmb3Ig
dGhlIGJ1ZyBmaXggd2lsbCBiZSANCmNvcnJlY3RlZCBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpU
aGFua3MNClBldGVyDQoNCg0K
