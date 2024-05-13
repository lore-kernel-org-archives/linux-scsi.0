Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33714D2B2;
	Mon, 13 May 2024 11:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715601473; cv=fail; b=qcF7T08QCRvNX443imXNxOzvWyjYA9AWDU79UwiXzzMKlRWKFORXGPMMnO8CulHxtUPTb0H6ShTtfHDQAZLjOeMdcDocNVdT4PNgffLIhLT9cpeFSmt86MEV8b4Nvj4edPx+I+pNYSz47nFgaPjxS5nKjejp8oHreTnAGGAbRfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715601473; c=relaxed/simple;
	bh=wyBod4g8i8Kolm5Nm0H2noOg6v3bPE0kC35QB0b2/yA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jcjem+NMc0xeLkdYPLmT+CL+VEujzmqU9RCWCwqLCHF4d+iGSMwdaXgINZkikLV9ZB1zjveYNhl630jDS7oy+yuRmorq0oK1SQ9fPCO0KXE8jrJZlLDEJB2ePRyxvUM4qWUosqNShHYILdLWmyI6GCb3YDPLXW8709NylJYpeDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pn0T9ATS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=v7E8O2oz; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pn0T9ATS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="v7E8O2oz"
X-UUID: 0369e0b8112011ef8065b7b53f7091ad-20240513
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=wyBod4g8i8Kolm5Nm0H2noOg6v3bPE0kC35QB0b2/yA=;
	b=pn0T9ATS6Riv2+hWcSgRFEnKD7z1lKdvVt6XV2PFN5gN9ikQyVGYHr1Js0ChC+olMJ1ei7DkTc5Gm8gaQaCO9N9LHyLIraRxXBtLpHAmS3WlGStd70/NvlofFsTQwV3bO7T6dP46+d9bQulUwCCek21RApE6RNHvIFB1Nh/skBI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:65e153b4-591f-41f1-a55b-16d9cf88f18d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:82c5f88,CLOUDID:04efb192-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 0369e0b8112011ef8065b7b53f7091ad-20240513
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1999965995; Mon, 13 May 2024 19:57:46 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 13 May 2024 19:57:45 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 13 May 2024 19:57:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSroB9bNGGb51FluIJttUr+Xi2LvKoNKrJH+k6yFP57AKERYvj9G0S1IfmhIe1PgpkYIW1ffYzyqGDnI19hlH2QiKDCuKr5QOq/OWnPFeQqKbprCtCYVIY8daugpsAE7cf8eoArK1tIXezqrgcnytM4wcVI+6dSkglgN1JzauAgMXxDpMYcfND1YDbQ1zgIfZIW7m3b3+rZ+3CYlfZPF8jWz6R4ZbC8VMLu6vaCRF58frq2B6QNDC9xkzFxdvFSYtN+fTebLWN5xCv4ukxMovkVkw2ThR47JhdekClC5OGZw4GG7Glir13etMyMdAEFeGoSnWg+iMc58wmootKuqCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyBod4g8i8Kolm5Nm0H2noOg6v3bPE0kC35QB0b2/yA=;
 b=jDYBHvN6AZ8Q+6blZrer7cJFrp+9MISbzkIy4jifW0nkZrGel3otLF7iHo8QZ9yyUNmZmRLdkVmEvf0dHbe235Rv1gjeTB5NOnG9uH50n3RoRU0sHrZkekFqmWOvPsa3p3sKf4wyvJ8n4AvQhjTkkyTWSzJUcX4N9YSf92cxjPkzBYhKkOpYgN0Ktjt7+zO7QDoeIL7Wr8Z+0KIoRZfLXiquRPtBc2lpYfIR3li5t648ySPs3cZlmF8r6HF8JBFi2TiRqz8fPm70Y+KMOcgOGeRC7nPCbbv5aeIWFnCdRSYs5h20rNhlr7opBCfT+qBvG3Rh3Sf/Pyf38TE+/PqNrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyBod4g8i8Kolm5Nm0H2noOg6v3bPE0kC35QB0b2/yA=;
 b=v7E8O2ozQwHKaJFhEXBtLgOEyaBJRCzuoI+UfI5j7zbacHD3/YnQo8BhyBC9XZaTfsvQJKmNUnrGFHuNW81+IT58jhne2K2SJTt5Sck35k0+XZ3TBDKr8efuTQUvbhjSut3od0j/qS+yBJmAEFMQg/C5VAhKM74fKAq+pPzbDSs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB7042.apcprd03.prod.outlook.com (2603:1096:301:11d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22; Mon, 13 May
 2024 11:57:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7587.021; Mon, 13 May 2024
 11:57:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "Avri.Altman@wdc.com" <Avri.Altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>
Subject: Re: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v2] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHapRdgi7aurfXIZUWjZ6lAEDvMULGU5syAgAASTYCAABY7gA==
Date: Mon, 13 May 2024 11:57:42 +0000
Message-ID: <ea63de370bc984f77d5635f3d76ad43d1c8b2b3b.camel@mediatek.com>
References: <20240503113429.7220-1-avri.altman@wdc.com>
	 <95c026bdb884a27bc6f954e3c01113816723c999.camel@mediatek.com>
	 <DM6PR04MB657566938989AC00F790EA9DFCE22@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB657566938989AC00F790EA9DFCE22@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB7042:EE_
x-ms-office365-filtering-correlation-id: 1f9bc94b-3a82-4800-74d6-08dc7343e4f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eWFqTEdNaVBmbnRZUXE4dHJEZ3hzajhQV2xteGdRSHdNYThQaG9LcnJwR3dn?=
 =?utf-8?B?WW1Md1pYRVJNY1NZdllPaW00bXNUWngrMHR2M3FiNEpkaXByZzhCa0I2NjdZ?=
 =?utf-8?B?Q0ZPQ0ErblNmQjRNZ2NJdVMzVnVIZTlqYlN2WjUrSDJOaW5jbDlmOGp4cnRl?=
 =?utf-8?B?OVVtenhXWmpxbFNQTmFBa0Z0eWNDWVdxWmZlOEZwU251MUI3NjVwOVB3QlM3?=
 =?utf-8?B?WEdXOU9zVEZnRGR2alEzWjFNZzI2aE8rTmNsaTZlVUtORGRBSkRadHNUQ3E0?=
 =?utf-8?B?NnZQdDZRSXV1OEhrOTR6R3VzdlVFMkNJU2JTbXdCaWNUVjJCNHlqQ1RYTkRX?=
 =?utf-8?B?ZFVOazYwK0ZsRWpKRVowbXVXVDFFdU9ZTmNjYnJUbEtpS20ybVdFbzJpTDBI?=
 =?utf-8?B?a2JGek5ZSjRJNzNsOEpWeFl1ck9RZU9YTm1tdjVhMEgyT1lxNThmbWhZUG9C?=
 =?utf-8?B?OHdSYkJtVEFsRjFVMmVmWGJpdzZIUUgzY3dsNlhYNDlFazc5c2ZQYXFWM3FR?=
 =?utf-8?B?b05ybVlPeWJtNFY1OHVvNk92Z2Z5SUtJOVQzcjdrdFI0ZjRrMFp5YU9FMVg0?=
 =?utf-8?B?QlVzQTZ1MjRIRGsxQzVOWitFc2Jkdi9LemZCWUNMRXlCSHdOZjJHMG1GRzBu?=
 =?utf-8?B?b0VnVUM4N3FxaytNelFhakQrQ1ZqMENxZ2MvYmtZNFc4WStkRGZGcHdlM2pt?=
 =?utf-8?B?andaenJRRmlSNWJ3YlBKZDBBNTd3aGo1Rzc5ME40RklBbmlTTEROa1Z0OXRL?=
 =?utf-8?B?UllVYWJHWFlJVStkZmdRUzNCeW9BaDlOcHIzZ0JOQVl1a0ZzUitEWmw5Rzdh?=
 =?utf-8?B?WVNneEYvZ1ZVbW5HR29rZ3B3NWttMDlWLzErM3grOGdaV2UwRXhzMzNhaEhM?=
 =?utf-8?B?L21ncUhwcFlxb1J2M1FYNWpIL25OZUZaK01LZ09MTFhiRGtNNklZQXNkd1RU?=
 =?utf-8?B?akR5eStKUkgzOU16WmxhemVCc2RzOVk1OFlYVHhWdFVicUJwaXhOcFZtZ1VF?=
 =?utf-8?B?TVVnc3FOa2d5SG9KMWlxZS90SUhocTdEZks2UkVUVXo1RnBCamx3YnAySGtw?=
 =?utf-8?B?K2RsZzd1ci96RXFIUkJ1bWluRENYMisrRm0vR1JRV2hEenI4MG9ONDJlS2Fl?=
 =?utf-8?B?NktIdjJsYW9penYwZmo5Y2ZtYlUzL3BpaG1sUFZUNC9CbnhSVmMxVmtrRzNu?=
 =?utf-8?B?d3l1TzZNWCsrcVlRa0JuL2pLMjNYRlBWOU1tWTdHU0lsbEwvSVhVaHI0RDhJ?=
 =?utf-8?B?cTZPVjIxelpDN0F3Kys4cjFhUC9sTnBYalp5MEloZWZScDdDNUZ2ZG9EZysw?=
 =?utf-8?B?Q0dhTnJrd2MvN3pUZ2NmV3hDTGQ4V1dRdVVGQWRCVVEraHphTVRkTVhEODhl?=
 =?utf-8?B?VExIRGxjSHVEd1h1ZzU1cnlGY0lETWl2S2E2R2xWYU5KM0U3ZWpVZ3lkcTdS?=
 =?utf-8?B?V0NKRHlnS1pjejFmUUIvcU9GeGFldUZoazgwSnA4RFBJL3drSS91WDQvUVpU?=
 =?utf-8?B?S0k2bHRjZWJ6Wmw2akEvNWZXcEhoM25uUDluRVZsaC9NNndzYUp1dTJEWGk2?=
 =?utf-8?B?Unc5UjM3alAvaEp4Vml1STJwSWtoZkQ1QzlQS2ZhMnFpL05sMzlaOEgvc3Rk?=
 =?utf-8?B?ajZqQzlHYmpzdFNHdkNKQURTZEtuT1F1ZzRQOGZnQWdma1JtU1hkTHZOUzEv?=
 =?utf-8?B?cVJrQzBDZGRwK050WXZiZVFodUxaOVV3MkhUcnRQNEFvK3Z6NFhKejQ2WWlG?=
 =?utf-8?B?NnFHZVBoZHo5dytldDRCeFhocld6aSs5R1pkamxZUEJ4bFlvM002STNNTXV0?=
 =?utf-8?B?RE0wM3RjT3NYZnJQZkNVQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZG1aVjlXK1ZHUnUyNDFuMXZ1a3dsVXo4U0dSM2JQbzBYNTZPMkxSdXR4dDVh?=
 =?utf-8?B?TE5kaVYyVExwY3BsNkdxeXpJNHRncFJZTHZpMXlHaUJ4L3lMNGovWFpvMTJY?=
 =?utf-8?B?WHZqdVZHYzRVN0FNUTkwNG1CdGFLWWswSW5YWGhwWFM2blN3ZUpuSlQwZm9z?=
 =?utf-8?B?bEJNdGhBQmtORDFtQTB4UkRaTFJSTVI1MmROT293eFFxMm9hajZ5eUsvbWVz?=
 =?utf-8?B?bWpkcHY5TWNjd242aXVWaUgwODZ1ZzVFYTlnRW1Na29NSWZWTFFxMS9Zb1Zq?=
 =?utf-8?B?OURqTHJ3ekY2VUdvZjZSZjFMN1lUeVMxT1FObTRMdlppTUFGcnN0L0lWMUVU?=
 =?utf-8?B?NXdZTVFPaVplYzh5WWExWXJiaTFZTXlkZzc4OU0xNFl6UGoyVyszTXFaNTF0?=
 =?utf-8?B?bFp0TUNFVHR4M3h1S0k1YWNVZVd6N2kxQk8yNDJQWE1uOG15Vm42TS9xNDZJ?=
 =?utf-8?B?NXpDeFVMc1VHbGE4a29HNlpzOFpEUkZTTmlVQ3NzS2RIMFl0Ky9xTVpBSnBp?=
 =?utf-8?B?SkxEYTZxTkhLSG1iR0U0Y01oWUVnVk5BZFdJcDY3dmt0UC95eUpEajFaVFBL?=
 =?utf-8?B?NlVpRGdQWlJlMXNiY1RHRlVRSU56dnRtUjEyL2p0ajB4a3BzSW13WnhER1Nn?=
 =?utf-8?B?NW1qczl3TFVicmFUbVdDNUc0UE4yTWI1Y0VhTTZQZUcwY1B6azRUeHpxQUZh?=
 =?utf-8?B?cXd6YXFzVXRtVWxUWHhJdjZndUdXT29lZjFIOC9hY1ZEUUNuQ2NYTDNGMjZi?=
 =?utf-8?B?MW9jOE9uamQyRDlDWGtlSlhDajNBSGxUaDBzU21ObDJvVEh6UGxpTUlmMEFK?=
 =?utf-8?B?bzVRSERhbU1UcDFlcnN4bGlkeFdHb1NNL1ZRYVc3NFo2cDVITU5kald3eWNI?=
 =?utf-8?B?OE45aW93TjhRbGpGQWNtc1VmSWVtcG4xOXVrcVYxM1dYMWhPdVVocW5NRGRi?=
 =?utf-8?B?aGV0KzBYY0JsYncrUlVHUXBRODZ6NmJrd3pNZjI2bWRoYXpVUjFicHU5NFhq?=
 =?utf-8?B?ZllCM0hoL3JLTHlBbVluc2htbGVuL3EvQTJhRzVrend6aUZNd1JCYWRORk5t?=
 =?utf-8?B?WVNwVFllQm45Uk10VGZIaDY1LzZjRnN5VjlnUTI4eGw2M1JwYzJzcGxZU3Vw?=
 =?utf-8?B?eHBxeVh4QUppbGF4eGtaSUZTL0NhQU9HMTBkRHh0M3d5bm45cHdsR3hlUUw4?=
 =?utf-8?B?VXdieDZMU1phaXFBcm5oUCtIaHQ3cWdmNWZwR2Q4Uk9LaUJsWUJIYmVIVHpp?=
 =?utf-8?B?ZC9kL3lUdXJnRlc3dyt0STVsaVhUMnJvZkJUQzFUcDM3dEszRVljbS9zVEIr?=
 =?utf-8?B?QmNiT3JMMTFiZ1BKeGNERkJXNVMvWnU1SitkYUdEQmp0QzUwdGtJVFNVTGpv?=
 =?utf-8?B?d2I1RjhqOFdWYU9SRWtoUFkyTFJZTE5FeHNZV2VnazhWRDBydVJpVXowcTVL?=
 =?utf-8?B?TWJFRytKMWQ5M2M2czVWa1g2L2trWHlKUG9iZmo1VGJsQ09OeDM1SmkrQldD?=
 =?utf-8?B?aU1ycDZRYTBJTVE5ZVg2UUVKeWtqUTNWWHFhVCtPcFVURk1IMDM3b3dJUi83?=
 =?utf-8?B?MW52YmovZjBoTDdJQUZyNm5xb1lNSENtWEYyVUVwSmJoWUJjSXV5ME9aUHlB?=
 =?utf-8?B?UjZwQSs3WG1BUzBBdHlFblFybEJwYjlxV3pDbDhFbHNyUEpFbko0SHJSdHlE?=
 =?utf-8?B?U1MyNE04cGVkSndRMXdYRUpxeEJpcFEvNDA3VTM0bkhTMzN1YjlXL0dXWTh3?=
 =?utf-8?B?bzQzeXlKd2RGS3JIK2NXZEZpdXdEeW81c0hWaWswL29NQnA1R0h6cW1VenhY?=
 =?utf-8?B?ZGtnVnpFNnJHNXEyN0hqWlhIU3RnMnFETi9lRndHUFFudndrUGtIU3dYZ3ph?=
 =?utf-8?B?WlNwK3NYSmswUkRwcWJzU0JqZkVWWGNFelgzZkZ0OGJzMGR6NTNid2hFazZw?=
 =?utf-8?B?Lzc1bEt3MTh0ZWFRZ0hOZDR1bUlFTFNueUlPZXA4ZTl3VmRCRFlyRU1WRmlV?=
 =?utf-8?B?SW01RVlxalZmbkE1Wk4yd2FJdXFOWE40OEpkdzEzWU00eE9IbysvNTF6VlRu?=
 =?utf-8?B?ZUhyL0wyRktrZm9NMHlwcUI0b2VjbXpsejN6cWh4M2xnTDBielQxZDlZcmMz?=
 =?utf-8?B?dmN3U0NuN0xhdlBHc1AvUU4vWXRwVktHWWF0aHd1VXVQTTZSNGtsV2NZSG1o?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A77E3D8866361429BC852CD67793913@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9bc94b-3a82-4800-74d6-08dc7343e4f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 11:57:42.1032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K53ENgsvMMTzZdloYLXX3K3ulzDMFBsmEadTTyUrVw72kg4vFIXS2Vroo7uAqPa2kjnBcyv1KZV3C4XW+V1yoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7042
X-MTK: N

T24gTW9uLCAyMDI0LTA1LTEzIGF0IDEwOjM4ICswMDAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4g
IAkgDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhl
IGNvbnRlbnQuDQo+ICA+ID4NCj4gPiA+ICsgICAgIGhiYS0+bm9ydHQgPSBGSUVMRF9HRVQoTUFT
S19OVU1CRVJfT1VUU1RBTkRJTkdfUlRULCBoYmEtDQo+ID4gPiA+Y2FwYWJpbGl0aWVzKSArIDE7
DQo+ID4gPg0KPiA+IA0KPiA+IEhpIEFydmkuDQo+ID4gDQo+ID4gR2V0IG5vcnR0IGZyb20gTlVU
UlMgd2lsbCBoYXZlIHByb2JsZW0gaW4gbWVkaWF0ZWsgcGxhdGZvcm0uDQo+IE5vdCBzdXJlIEkg
Zm9sbG93IC0gbm9ydHQgaGFzIGl0cyBvd24gc2xvdCBpbiB0aGUgaG9zdCBjYXBhYmlsaXRpZXMg
LQ0KPiBNQVNLX05VTUJFUl9PVVRTVEFORElOR19SVFQuDQo+IA0KPiBUaGFua3MsDQo+IEF2cmkN
Cj4gDQoNCkhpIEF2cmksDQoNClNvcnJ5LCBOT1JUVFMgdmFsdWUgc3RpbGwgY2Fubm90IGRpcmVj
dCB1c2UgaW4gbWVkaWF0ZWsgcGxhdGZvcm0uDQpIb3BlIHdlIGNhbiBoYXZlIG9wcyB0byBzZXQg
cmVhbCBob3N0IFJUVHMuDQoNClRoYW5rcy4NClBldGVyDQoNCg0KDQoNCj4gPiBUaGUgTlVUUlMg
aW4gbWVkYXRlayBwbGF0ZnJvbSBpcyAzMiBvciA2NCwgYnV0IGFjdHVhbGx5IGhvc3QgcnR0DQo+
IHN1cHBvcnQgaXMNCj4gPiBvbmx5IDIuDQo+ID4gUGxlYXNlIGFkZCBuZXcgdm9wcyBmb3IgaG9z
dCB0aGUgc2V0IHJlYWwgcnR0IHN1cHBvcnQuDQo+ID4gDQo+ID4gVGhhbmtzLg0KPiA+IFBldGVy
DQo+ID4gDQo+IA0KPiANCg==
