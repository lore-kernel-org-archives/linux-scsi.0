Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16063331EB4;
	Mon,  3 Aug 2026 07:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785742605; cv=fail; b=YCrXtkgO2MdIxHHsW4MVWpgY7+PA6ATc+xX3OCkG8eFZaiiNtGWHOah0tzkKL4bJqZbgyuwZBLfTUSh7ZO+piBpvsGacXf+DcuJ+RuOLLA6qXJ/pjR1U4wOHoBDnFdhKtBtqXEQ9UewLU5x4blMi8xIoaYOpjbc/gZteVfUHfl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785742605; c=relaxed/simple;
	bh=oxR05GesXMGJ8R3f3ZDip2VGyECsbwpDPLxWKKTw7Pk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nSVietyvXKbgZLSugy3pOBef3CgoH8zXVWzorfVBK7OaLU8I1JPlbNYFhSiRA7G4BVLIpUhnU3BpXXZtXm+38EGwSedfowGt59vMsepUPP3dmPwXvZd92AJC4YDHn1bWrbfgPztNuMgLOOgNz71tyyBIvyMjUA3TGvc39imLTjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Imo8NbPP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CNFcON8T; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Imo8NbPP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CNFcON8T"
X-UUID: 0e0f3f4a8f0e11f18dc8c9802ae25ab1-20260803
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=oxR05GesXMGJ8R3f3ZDip2VGyECsbwpDPLxWKKTw7Pk=;
	b=Imo8NbPPA8NgEHi5QcOP6o8q3Gj/ve0ke7ubPQEtSBjDT92RHix0wv7C6APNBIQXwmw+2qTNdwH/OVZ5CBAhZA596FDJEeJifm9FipXgmX65zspR42C1UehacT+ark9N9ir/TBSEmkx8V5yCtEyFZz5SNKPZURcznD6j17UfLV0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c400e727-ef8f-45d1-948b-15e6c04d688d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:1315b3cd-1e1e-41fe-8474-552e0064a2de,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0e0f3f4a8f0e11f18dc8c9802ae25ab1-20260803
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1590381756; Mon, 03 Aug 2026 15:36:35 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 3 Aug 2026 15:36:34 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 3 Aug 2026 15:36:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XjAaUdiuB6vlBeXkM09kJw+rBEpAcACTN8pM67v/X5OiUh4A/ISkydfJU2hGv82uWpstnn0txTm5Ln+8HPmdledgNd6LqOJrVOyGuqAgpmpdM0Hf7YnkE/7kV00to7pU+BvzDh7PseAZ47j5fBHWrbVFtwr1AaA1GW1InOdCV2Xg65B+2z/k7XFLJgHULRImXpeI9fVVnjM3ACzPQgQsfwZKid0N8KY7FhwX4lF4NE3eITSauBlsaHEWzAD3ZVmrjupbiP8qS9ARukO+LLbMbP5JHNiYgJZ/fPcNTI8VrmyGKjsRMrZJIjZ+UEr8nykjxH6tIgRg9QSJqDRQG3qF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxR05GesXMGJ8R3f3ZDip2VGyECsbwpDPLxWKKTw7Pk=;
 b=X5mUl1xRDGSgRIJfFotwKnj3eLjwKSg8cpJLyzfSuv3fa1ufg+a4WDsZDEqzjXtH1g3oCPRvBFN8alyd/mP6MhlXJw1EcnRw1pPESIJBZa/c8BTDJozK96ER34cvzgUPOaC0uXs8x1Wx93f+zYxTQ8P+yb3FAxqtiKMZt+LgFYhsRjMEJO9e1yibScj9m1WK+IM6jYbiPhzu+Rp4GsMuvRSSU4bJ+kgLUvH2N1awre7Hd8rd0Tn+ogNLWc2ESjgvVem4xvAiz+cQ77S4jqoEGAB/6iF4xuUk0yDwdANJTR4KYG1umjkBo/1h5AVkoVweU08y7hmDPoI0esgHA1/hbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxR05GesXMGJ8R3f3ZDip2VGyECsbwpDPLxWKKTw7Pk=;
 b=CNFcON8Tk1N4HsMnpjG3urDZpLMDUUxCRO7Qwqy72aqrPVHSv7mitZlLDbmQ0HPMnmelQTE7ysaqVOMAMoMwBkOwVfn7a2KYLkIrzwtgQNZJreejtRUujQLdOqsYMBlVpSvanZ0FRJ9nfbxWHjF2OU4mLBJRCzSR1WxhwS9wvL0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYNPR03MB10065.apcprd03.prod.outlook.com (2603:1096:405:3ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Mon, 3 Aug
 2026 07:36:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 07:36:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "hongjiefang@asrmicro.com"
	<hongjiefang@asrmicro.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "stern@rowland.harvard.edu"
	<stern@rowland.harvard.edu>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] scsi: core: pair EH runtime PM get and put
Thread-Topic: [PATCH v3] scsi: core: pair EH runtime PM get and put
Thread-Index: AQHdH0vI1Qy6/W5gkEylJWf5TUHPobaL9wEA
Date: Mon, 3 Aug 2026 07:36:31 +0000
Message-ID: <2cb29545a977497af17fe3ac5346b203d59b9bf3.camel@mediatek.com>
References: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
In-Reply-To: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYNPR03MB10065:EE_
x-ms-office365-filtering-correlation-id: bdaa96cb-9272-40ee-9ef7-08def131efd3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|38070700021|18002099003|22082099003|10067099003|6133799003|11063799006|56012099006;
x-microsoft-antispam-message-info: QGRzvyhl+FcfUQQHlNPmkOm1sXl4xWyNq505+hSn82YsgX5NR5vUvfEfQ1FuM4PT+dfSigNtXTDpMX1vw8tI0WcAY90gn7ewXt40Ng4c4e3d3VyGgccCIEzfKRt3Zo9WQwXWNx+fyiAdfGOi7lHLxUUoH7WOwgLaCkDgvn7KlenfzZGgAXXL6DhduGKTTz1VGWUFXv9om/ojM/lIeelODhsm/Tz7IZXtxdtXrfJL1QAqOv3nldhuxtXObWYfqOVivC1/6Ih413wXrIkfi3SSplWJygSA7SO9ImflRj74vICbhjYEySLUHMcZX2ffJopCIzdKwu0MArnAiBOq3XFDop6eGOalT4STfNrLgD6Bw+cDFdQMGu7EUO86HgbGIunE536vH8pPruWTa7lCyrnE7azTAHYuvqFEb/+zdp4uDgzW0QLwfHNm2NzCEAAK6nRPZDLHStx3RTD2yZu+IYW1UitXE3KdJ0Gw16oX62VVubrV8t8v7VfKdx+EF0hEzKY6J2kAlZdBAZP8mOwH8c/uiS9N42HiuCyddMJN/LBAdcpbdfokKz9KoZrwT/XvsuZQYUxTtft8ixntxO5RnBE0VU8uW1aKkDKlHJtYMJ8vKJZ25PJOUYOn9ljnbG3nrxT7xZw2z1AHDW+D4ZHcMmaKFpyY9Kg6FrtG8ZtpxUk+2TVjnljOSWTYJOjMrB5a73/tQL/WzOjUqU/fV/L2Ys5HTof6LhehvXTWXpOdOfyOjD0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(38070700021)(18002099003)(22082099003)(10067099003)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEhRZXhNeDQzMzhLcHpZSk1VRVJrMmtad0UxTmNWZjNFR2x0WUtuVnlxbVRy?=
 =?utf-8?B?K2huTVFiaTdZU3kvQmZlcTl5dlNZKzYxczJxbmZBODc4YnlhVkRzL0RCc1RN?=
 =?utf-8?B?aFJjT3BKTHEwcE1Ec1drbVlKa1k0cmp0YVMvcHdqVnA1c1paWU1ldmZEUFVZ?=
 =?utf-8?B?bW81U3JwZHhRcXMyanlYYnh0M0VyZkdBd2tkaEhNUXU3UXRUaWJSNDhHQVl0?=
 =?utf-8?B?MEk1UFd4c1dTdm1MVGRLVWExZVJVeTg5Q1lXYmlkS0FJU01xNXZhWDRmVFVi?=
 =?utf-8?B?ajhYcUpINGtvOC82cWEwMGZjcTdiRlJ5RlpLVEE3UXhYZlpmbWhsT081MGxJ?=
 =?utf-8?B?L1dYY1NHVFBBL3M4SlNmK2swM3hwWVM0S01GbGFZY2RCNkpoUXdXR1FaMkV3?=
 =?utf-8?B?V2lxRGZXUE5lTUVDNHhaWmxjdGNob3BDZWVBbGVMdkxsU0R0Z29kci9lOS9I?=
 =?utf-8?B?OUwzRlNDaWJ3c0xDcEVsRk1oTVJ0Mk1wVGdMeXRzclNnRDJoQWg5Vm9LdlpL?=
 =?utf-8?B?Q1RZa0RCSFZCRDliUFBiMmhsdzBlNDJHQXVTYW96b0lUTWVEb2IraXYxekNr?=
 =?utf-8?B?eHdPZWRsWExGQVlBMXArcmlmZW1nLzFKN0c5NVVybGlkd0xtbnMzZSt0WXV3?=
 =?utf-8?B?OVdxSXh5dWUxSlBEeHoweVh4RThxck0xKzlGbUhnY2crY2E2UmNmRjZmL1Br?=
 =?utf-8?B?NDRZUDBNays3U3BGOHo1dlR0Tm9Rc3FXTmlIV3phRk9YendOWCtGcnk0RWl5?=
 =?utf-8?B?NDZPYm96VTE2UVlTRysrK0J6ZnIvYUFsakFQMWwwQmJWYWljYjRWaDJUMWVs?=
 =?utf-8?B?cG9JR01wWTJTOXh0MTd0UFh5MHpaaXZBU1YwMDJTT2ZoZ29wMFlLN1hyM1NU?=
 =?utf-8?B?b1poY0RVckg1RnB6SUlDeUNwTkNVb3ZaRFNPaENnL2w1QTZVSGlhdzZUYlgr?=
 =?utf-8?B?WjZieTF5T1RhRi80Nnhmc0lZMEJNUWRnd2RaQW5qQ2hucU1SZXluNVU1Z3Bu?=
 =?utf-8?B?VTBSMmEydGZBK2Rja256eCt0d1ZxWU95M2g4Q2oxMFF4SzdPb3lzWldSeUJS?=
 =?utf-8?B?ZFg3cTdUb0FWNFdURjdTNWxMQ3I2TkpmZUgvQTUySlhMNGdCaUwzQUF4NWtw?=
 =?utf-8?B?a1ovN2xBN293U0FVc1NPQkVIZS9HOThKMVZRUDBMYktkd0FRdTUrR3BIUDhP?=
 =?utf-8?B?THhyZkJCaTVKRCs4MWJUOEdLVU1hQTh4MTFBazlBUHMxa0VNb24yaWxKbXhh?=
 =?utf-8?B?VnJLQmVTTjJSd045NG9HSFd6ekFwa1NRTHA4ckg3L3dKWDRQV3R6ZHBSSzdZ?=
 =?utf-8?B?SVBVSkhjU3ZwZUtKUVNpK1B1MXVzcGQ2LzdQa1ZBYzZqWERDZjFzcHNGbklW?=
 =?utf-8?B?eTNFSzdCdTZkR1NCamQzai9aa2FGd0VoTFd2SDhYMHZnWFJNSmNQQUVmY2Rt?=
 =?utf-8?B?MzhSR29tU3hmbEtVMXZHeVJ0RFFWVHljamd2ZWJNYmhIOFR2TGFNSXMzR2Mv?=
 =?utf-8?B?eUdSQUlSOU5Jd2ZPVmRCMk80ckNYTXpoOWxJTEJjSTFvZnVtWVJ0OEJtNFVj?=
 =?utf-8?B?UlZtYm9pWjNWZmZpdEdIK1VxOWtOdkdCUWo0WEt5VUt0TkJwMVpkRnlVbmtv?=
 =?utf-8?B?NW9tM0xPMjAvRkMyMzhBUHJLNjNweVRoc2ErVzdMK2VOd3pVT3J1YkZ3eDZv?=
 =?utf-8?B?RHo4UHpaVGFiUXh2N3pFU2wwWGVTN3hHbk8zcTU4NDAvQUdBcTBxK1lqOTRq?=
 =?utf-8?B?T3o4Q1l4OEtEN1ZnZlVhcCtzT0tBSEkwRHgxQTBkTFBtS2Z6NndYY2dNS3VG?=
 =?utf-8?B?clhOS08wS2FMTDUrSEU5aU9Cai9qYXpRYVo0S3lqOWhISHArM2VvbUlwR2tt?=
 =?utf-8?B?T2hqUWRDT0FDZW5lZS9GY2QxOVhPT1ZEZWpkbk1WQU9yUGxrYzJyNWNzVVRY?=
 =?utf-8?B?d3VaUy84SmpvUWVEZyt4MFU5RU9DQy9ueWdpNDRIS0xvUXhEZjVRSEc2TThW?=
 =?utf-8?B?eUVhWkVEcElpNDVrSzdDaTg5d1g4SEtSS1JIRlVLSXFLZlppNmZXME1PZy9z?=
 =?utf-8?B?N1FMLzF0Rkh3V1kzOEVJN2ZCRTZRb2lBdEZoZFFaYi96VUdUcE5yZytMVXVq?=
 =?utf-8?B?MkwvU0x4aTJ0M2xGQm91S1NRMU1rTmlXMlhKVU4xa0J1dTBCeW5yU1Zwa2Rr?=
 =?utf-8?B?eGhLOCtJK1RMOFpsOFFyL0tvdkNhNU1FK01DNWdPb2tIekE5VVZ4L2RXbWNv?=
 =?utf-8?B?SFkyOXh6OVNZVWwreHl5U3c1TUl4bGxjRTdaYjBRUnR5MTUxZGNEbVgvSnRY?=
 =?utf-8?B?SzhPbXhlQ1FVc2s4TnlBQ0tucTlWbTlFOU82YUcyZ2JGRUptRGt2Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4A56D0F7A583649A8FE2A530E79628A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Wttcf05seMrmkSo38fOgE6EqKnzNokcjYlDltODOQemEuKn0gcVFKSDUEjU609mts44nNg59MqvQg7QZCoL+puODa2YLYycxCp0/keQg6FbQqt/72ZuJMzuAfOylTSPvtNrYMnRpKznqGNjCCIICthPl62DjTSmyH03nrOEQxs2Yp85OTiuJPQ9+yK32odnhR9f8kG5smfdCHq/BmTYYQTdOEYn9Lr5M4gFVXLpvi3s938VHf4HMIAi7PoRMgg28Ik37Day4be+XjCUMkXJhH7np6ViW9JORXtmDYjcarDcVX8bU0gHdfMemH5G1bRwBBCxdEGUBRCvFQRtbzAaLYg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdaa96cb-9272-40ee-9ef7-08def131efd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2026 07:36:31.1933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxqPs4qb+HIipwHt2IMPbLK8KkVIbArIdYbDNaBVeh9TpkCL6rc7CviApZoTPkt9ja7STeLTkaOuuoJZlrjsrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYNPR03MB10065
X-MTK: N

T24gV2VkLCAyMDI2LTA3LTI5IGF0IDE5OjE2ICswODAwLCBIb25namllIEZhbmcgd3JvdGUNCj4g
c2hvc3QtPmVoX25vcmVzdW1lIGlzIGN1cnJlbnRseSBjb25zdWx0ZWQgdHdpY2UgaW4gb25lIGVy
cm9yIGhhbmRsaW5nDQo+IGl0ZXJhdGlvbjogb25jZSBiZWZvcmUgc2NzaV9hdXRvcG1fZ2V0X2hv
c3QoKSBhbmQgb25jZSBhZ2FpbiBiZWZvcmUNCj4gc2NzaV9hdXRvcG1fcHV0X2hvc3QoKS4NCj4g
DQo+IFRoYXQgaXMgcmFjeSB3aGVuIGEgUE0tdHJpZ2dlcmVkIGVycm9yIHBhdGggZmxpcHMgc2hv
c3QtPmVoX25vcmVzdW1lDQo+IHdoaWxlDQo+IHRoZSBTQ1NJIEVIIHRocmVhZCBpcyBzdGlsbCBy
dW5uaW5nLg0KPiANCj4gVGhlIHByb2JsZW0gZmxvdyBsb29rcyBsaWtlIHRoaXM6DQo+IFBNIHBh
dGgNCj4gwqAgdWZzaGNkX3NldF9kZXZfcHdyX21vZGUoKQ0KPiDCoMKgwqAgc2hvc3QtPmVoX25v
cmVzdW1lID0gMQ0KPiDCoMKgwqAgdWZzaGNkX2V4ZWN1dGVfc3RhcnRfc3RvcMKgIDwtLSB0cmln
Z2VyIEVIDQo+IMKgwqDCoCAuLi4NCj4gwqDCoMKgIHNob3N0LT5laF9ub3Jlc3VtZSA9IDANCj4g
DQo+IEVIIHBhdGgNCj4gwqAgc2NzaV9lcnJvcl9oYW5kbGVyKCkNCj4gwqDCoMKgIGlmICghc2hv
c3QtPmVoX25vcmVzdW1lKQ0KPiDCoMKgwqDCoMKgIHNjc2lfYXV0b3BtX2dldF9ob3N0KCnCoCA8
LS0gc2tpcHBlZA0KPiDCoMKgwqAgLi4uDQo+IMKgwqDCoCBpZiAoIXNob3N0LT5laF9ub3Jlc3Vt
ZSkNCj4gwqDCoMKgwqDCoMKgIHNjc2lfYXV0b3BtX3B1dF9ob3N0KCnCoCA8LS0gZXhlY3V0ZWQg
bGF0ZXINCj4gDQo+IEluIHRoYXQgY2FzZSBvbmUgRUggaXRlcmF0aW9uIGNhbiBza2lwIGF1dG9y
ZXN1bWUgb24gZW50cnkgYW5kIHN0aWxsDQo+IGRyb3ANCj4gYSBydW50aW1lIFBNIHJlZmVyZW5j
ZSBvbiBleGl0LiBUaGF0IGxlYXZlcyBhbiB1bm1hdGNoZWQgcnVudGltZSBQTQ0KPiBwdXQNCj4g
YW5kIGNhbiB0cmlnZ2VyIGEgcnVudGltZSBQTSB1c2FnZSBjb3VudCB1bmRlcmZsb3cuDQo+IA0K
PiBGaXggdGhpcyBieSBtYWtpbmcgZWhfbm9yZXN1bWUgYSByZWd1bGFyIGJvb2wgc28gaXQgY2Fu
IGJlIGFjY2Vzc2VkDQo+IHdpdGgNCj4gUkVBRF9PTkNFKCkgYW5kIFdSSVRFX09OQ0UoKS4gU25h
cHNob3QgaXQgb25jZSBwZXIgRUggaXRlcmF0aW9uIGFuZA0KPiB1c2UNCj4gdGhhdCBzbmFwc2hv
dCBmb3IgYm90aCBydW50aW1lIFBNIGdldCBhbmQgcHV0IGRlY2lzaW9ucy4NCj4gDQo+IEZpeGVz
OiBhZTA3NTFmZmM3N2UgKCJbU0NTSV0gYWRkIGZsYWcgdG8gc2tpcCB0aGUgcnVudGltZSBQTSBj
YWxscyBvbg0KPiB0aGUgaG9zdCIpDQo+IFNpZ25lZC1vZmYtYnk6IEhvbmdqaWUgRmFuZyA8aG9u
Z2ppZWZhbmdAYXNybWljcm8uY29tPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcg
PHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
