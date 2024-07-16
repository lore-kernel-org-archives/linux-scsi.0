Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2A6FBE;
	Tue, 16 Jul 2024 02:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721095401; cv=fail; b=gpO8waLzC2SrmOYYtR/JQ4OtnixLkOgn7rYV6FhfhLTDLD4YuCLbGKoq4V3sSq/Cl6y/Vbe7c7K0n7egYRdfuK1imCu10MyR07fo/jYjwBEWm7i4T3zjkpm88NDQc9xDf81zdJQmjI3sxcNG1nKup2p6fy1otJBzmfmO5cvedTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721095401; c=relaxed/simple;
	bh=WZLxfOV32iI5ME//IbAq2XV9TR4twaM4ugoQs56PuVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ujj5nMy97MJuPGndvbbVWUlhWL/W9iy39eQhX/dOGg+k0rtP2/O7DS1cn/LVJGleHrgPRQ/l/GyOaEfiXicOHJvpQzLdjd/VXaS3gNw4+EN6x3+p7z1yqgKZWjEdikwcjod2yVzpGQOkc9ZQYTyF0G5jJA3MQHWKp3XPFeW/ALI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ApNqLRRv; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nPGBDQsy; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ApNqLRRv";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nPGBDQsy"
X-UUID: 8e2bc4e0431711ef87684b57767b52b1-20240716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WZLxfOV32iI5ME//IbAq2XV9TR4twaM4ugoQs56PuVA=;
	b=ApNqLRRvf3hfpMmpJUTcpaxAAdYiPFNreoSxGJwaQKuIQCCEsvzOFXgjSVtR0ECB3odUKvtKX/SQZjm1EzKUHE5LfFtFw2DIsooxQ1jry5jcyjIAyotyKDlRTnwjC+btnOjjjxyKMhLxBHDI/eALh+HtaYHrTOZtzsomceUkdfo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:09f5764e-f5fb-4ee5-8fbc-e3c9ac5459d0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:b43962d5-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 8e2bc4e0431711ef87684b57767b52b1-20240716
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 532151868; Tue, 16 Jul 2024 10:03:12 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 16 Jul 2024 10:03:12 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 16 Jul 2024 10:03:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rkeu6E3DY+DTDhDO05nW8wgMO1xuHkrsfyk29xZqPLoLbpqAnOpOfMPzoW0B39ZF/QiSMK2Q9kCTNE7sPoNWLZab56wpX3HBBThGVZ8c27Gwing11yalHKvjvyiYCvGHEUjrJc/AvZBsh7iu3J2HNy6piE0sd+7d/Kskzd4ByYyauCoCF8oaG379DaPDr+os9MCRyosIFKUuyIvC2D9lwYSAqYwgs2BiXGItkOF6B/NMLcU/tTY0aJABg/5BoH9Df6brmxzABrCFypDesP5eFYek+lMBxGUbtZICXGjJvX78fsmWvOE2d5PewQFOAskXjO9lAzhWVwk12gDhaHiJAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZLxfOV32iI5ME//IbAq2XV9TR4twaM4ugoQs56PuVA=;
 b=j3BpNa+U80uYlLXuhjbHRmO3LfCMt4MhoLByqL82zyOv4clEpiGMMzzBwG/q/FAaavykaAQn6PfEPa0tQ8XoWWbRiy/uIb0qpjmB7twSJ/a3Dbf2xqNe3/lTj9UUcpUx/mKe0EEHERww3jtdxmkF2qY5oY18v/iS9X0/5NF/mFlu3/4/XGXsM3FAvvbbRObScUsbDHXl8Bcx7kKkyC0dL1lmtovtiIb5dnf+B7k/JfHCpequmpfTyMxmC4F6J7ukosFpFNUE8nT7SftCTLW12mp2JpYoSwDCPgSBtDeMPW/esd0h3RAdWKOSapw8ZGq1wgfGz+jbf54G86+4YMlSOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZLxfOV32iI5ME//IbAq2XV9TR4twaM4ugoQs56PuVA=;
 b=nPGBDQsyJ8ngu3ZvakJqVWRlLoQ/uX/GokuMSdtT9wTpS8xnkv/FfK/wHg1EVlr2xjHUskxK1BxgxK93qbK74H2f0KwjG2NDEPUzjxpdHWhsYw5B4mWuAgrxyld8ujqCnPvm1s7IRUyfTbfhkngRDDGrsmNPcMYBIZqvvqNBLy0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7598.apcprd03.prod.outlook.com (2603:1096:820:e0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 16 Jul
 2024 02:03:08 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7762.027; Tue, 16 Jul 2024
 02:03:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "huobean@gmail.com" <huobean@gmail.com>,
	=?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
Thread-Topic: [PATCH v2] ufs: core: fix deadlock when rtc update
Thread-Index: AQHa1oGfHX9jD5TnakSNwh6noF9JO7H4CNgAgACSvQA=
Date: Tue, 16 Jul 2024 02:03:07 +0000
Message-ID: <0c2ef22bb06369c94b65cb4892bb130f5ec9d78b.camel@mediatek.com>
References: <20240715063831.29792-1-peter.wang@mediatek.com>
	 <814b2e3f-3386-45b6-ba72-7a1143e57e33@acm.org>
In-Reply-To: <814b2e3f-3386-45b6-ba72-7a1143e57e33@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7598:EE_
x-ms-office365-filtering-correlation-id: fd89a817-82e4-402e-0c9c-08dca53b6fa1
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WTZRYjFudXl1Z0ZuYkptQXVEZ3FiZEpzK3Q3aThDVTk3d3N5ZGtXNlFwZU54?=
 =?utf-8?B?R2lVbEZQTWZUMWVMR3I4bmFNejRJRFpRSWxqa25QT1hZMVB2YUNlY0ZRZ3I0?=
 =?utf-8?B?OVJjY0lnMm5oOEZtMVJiYU5UT0RhRksxc0YxS0hzREhEZGFrOFlKYVdycXFq?=
 =?utf-8?B?MEoyRmZ6d1Vaa1VWVElYa09UN01FMnV1cVhrR2tpb2RBUjBUelYzZitqRWVG?=
 =?utf-8?B?UVVKQWdhS3g4clo1ZnhFd3U2ZXBVNjJLM1phdlpiWlQxMHJTcUpSUkZkRzZw?=
 =?utf-8?B?aGFPRXpQa1F2TWQyMDZBNTdYeFpLYXIxUC9nN1hCR0hTVE1JT3I2SnBPUFdC?=
 =?utf-8?B?TklQOWY1c0l6RzdhcCtJT0dFUHU3ekNSbDRpK0pna0ZWMEYvOWxINHJlN2xh?=
 =?utf-8?B?aFk0bVd5TEd5OUszbk80dkVjY0RaNVdKcHExSC92UUs4QVZwc0dnVnQ0OTdv?=
 =?utf-8?B?MlFpTnZreFg3RExPbmNsa3RmcG5QTm56dm5YYU5EMG9MQkFTNXp3WkdsU2Zk?=
 =?utf-8?B?S0xvS1dqYkVTSXBLUEhkaG1oKzN6TDFCRXJEenEzSlpoVVNsV25jTkZOZG10?=
 =?utf-8?B?dnJNNmdjVmF4UkdFcHc0dTkreXQvZ3EwRit0U2JxSFZSRzNyY3oyYWw0V1gw?=
 =?utf-8?B?RUdMblBGdTNucU56NHh2aEI4d2lDSjFnYXNhcjduZEtXMkp1dWZpbzg1bGo0?=
 =?utf-8?B?RVpXTkFxanJRVHVkWU1pdlROZGQ0OXJBVlc5YTcxU282NlFmbGxVVllrai8w?=
 =?utf-8?B?TnVxVG5VOHlxN2k2cmE4WWVOYjNGUklDOGljeU1VNU0rZFNUakxNRGowbUpB?=
 =?utf-8?B?aFBRNnZTMlFPMzNpdVNvam5VZGZZYTdjaTVDU1hFeEtNNDB0MGlXL0JNL3Zr?=
 =?utf-8?B?QUtCVnBjUC9mZW9kUUh0UVp4OGFleUkzWktPbHFGWXZtZExNQjlTL0lidCt5?=
 =?utf-8?B?UUdYcjVJRHhIWnVuamtlbktRemNsdEFSWmRTUk5NWGlrR3Jpd2drZHhCUnhT?=
 =?utf-8?B?a3Zvbk4wMExoZ09GNXg2L09DM3hBOWRJblBIQ1FyZjFiYnI0cGNHZkZIemN3?=
 =?utf-8?B?amlzSXFkeHNEMGw1Sy9OV2dQUnhBQ3pMMWlhckFjVGhES0NaN0dMS0tnS29u?=
 =?utf-8?B?NUF0UEkwQkYyZ1JLZVZ6anN3TVRLWkZjNy8reWsvL0xuK3UrLy8wZExKZ1ZI?=
 =?utf-8?B?YVIzZXJxR1RxbzNqSHJPMWpId0pyek5QZEI2Y0N0MXN4R3FZSmJpdjBNMFZO?=
 =?utf-8?B?VjcxQjIzTUZRNEF2KzBwdnM5N1FzMEFGTGZFcGV2Vm8wRlRwYlVDME5ZOEpu?=
 =?utf-8?B?Lzh2TEtqNGxlaWpxazhPOXVCbVpDaGFibzVpcWFTd3JvK3NWRUx4SDZsUHhz?=
 =?utf-8?B?aHZZanNCcloydGZMM01VWndSbmYvcTdlZnBabEU3d2JEUjNBQ0wweU9NaFBX?=
 =?utf-8?B?VEVxb2xsVkI0Ylk0eHRXVkJwZHFadkFDTGYyNWdJaDR3RnZFUVJjdGQvN3Fq?=
 =?utf-8?B?TDd6U2xEZ2MwMCszU0tOUUVZcTZhSjlUZG96Z0UwQ0hJcVlnNVdwc3NZOWpN?=
 =?utf-8?B?clFkbzM5UXY2TjNGeVZQSlFKZGlCRFZOMnloR25IcVlJczlpbEJWL2lETnZP?=
 =?utf-8?B?T2ZCVlY1QVdTNXhBZFdJUHZCOW5Lb2Q4OEdQVHVvZldLRFY5NEVPbDdLR0l5?=
 =?utf-8?B?KzFWcTl0N3ZsaFhjZXU5VHhkeXR5VEl5ZWxZUDFMdEtMeWc4ZWg1M1FObHl4?=
 =?utf-8?B?d2l3M3VuN0pJNldTcWp0MTlyY1RyeVNVMDRDb24zQWFNUndhKzFUaGNLRHdO?=
 =?utf-8?B?aURzVkFnOHIvNXBydzFTTFhJR3hpYmwyb2NtanpKQU1HSm5JdzhEZXQxM2Qv?=
 =?utf-8?B?bkdwTTdJMlYya1BkZEdYUW16TGFNdUcybWp2a040dVZZakE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmhiVDFlSTYrU3RtaU9OME04WGRtMVMyWUZMUUlkMTlMV1U1ZWlKZnE2TG9w?=
 =?utf-8?B?YnFmQ0JJTHVoWWsvMTh3eVk4MDRmZy9qWFM4OGlOWlNTTEVCQTJHK0x6b3p4?=
 =?utf-8?B?cXRtQ3pLRURiTER5N1RvcVVFa282SWRJU1pyemxFSzdIYUtsOXBCMDZLMU9T?=
 =?utf-8?B?WnYvVkRuQU9TaFNtMkthMndrVERsUFhnc2JNRkxXRW1pTSs3UjlKN3dXSXJy?=
 =?utf-8?B?YzdlWlRVRlV5YWMyMEFyTzBVdGZPUCtXWmFDemtReXlBUGN6MlFFYmcxMzND?=
 =?utf-8?B?dTE3eUpRNUU3RzNjbDZtelZtSFpnU0RZWUhRVnpCV3JBcUREMmNvMXEwUmow?=
 =?utf-8?B?dXFsVjVmRm4rbDBaUVZYemI5U013cFMxbXI1Q3I4d0VtcUdlVjFsZ2Ntemo3?=
 =?utf-8?B?cmVCUHJ6ZW1SNVpDSENSNjFheklCa1V0QU9RMWU5MDQrMWdKLzltb1pOZlR1?=
 =?utf-8?B?OE5XcGlhcFlmVW5IRmVUcTJ3Vjh2QjBmRWhIM0trcFBkeVlWclE3SCs2L3dI?=
 =?utf-8?B?R0hjMmFtSlduR0Yyc21YRzdLSlZKWlVRUmNnWFJwZ3FvTnprVFV1ektXaG5v?=
 =?utf-8?B?TDdRRHZ5QTBtaHcvVWJLbExLdFpHYmpYS005aHpQSEhjNm5Vd1N3b1V2dGVs?=
 =?utf-8?B?dXJxaEUyTVRuOUVUY0FObUVLMjVYV2hxeDZieldFeEE5djV3RXdmSWsrUXZq?=
 =?utf-8?B?Z3dBQmhDVE1PY1hUS0U0S202ZXhMNDBpbjVFalNZVFJ5Z0lhUWJUN2RLOGdN?=
 =?utf-8?B?UGdCQ0lTQW15SjF3amE4Zm1hRWpvM3NBRWFZS3pTUnc5ZXFnR0d0UTNZL2Zo?=
 =?utf-8?B?Q09BOTJXS2UwNkFaTWxKdmV6ZHhvekl2Y2p6RmQ5ZXQ2Unc0K0pXYVg2SHNn?=
 =?utf-8?B?NjJKSGlCeTZUbVA2WkU0dm1LWWg1YUZjUVh4UEduNCtPem9Fc3Rra1JCRWdN?=
 =?utf-8?B?NStnWVhLRkVPUWxxZjBSeTI0eWY3UUVhdHhtNm9NZmw5NFNSdXJlaWozRS9S?=
 =?utf-8?B?MmkvUjVnV0xNQVVBZWtDMitEekU3azVlS25nM3ZGZFgxS2I3aTJhRTNSNFBl?=
 =?utf-8?B?b3J6QWhucjlUQmZVVi9VVk9iUDhhUkZmZWxDdEZ0REN4ZFFhcTRXWWtlcjBH?=
 =?utf-8?B?TkZLTHpUTjRDYlhUMEFVSVhTNW1vZWlNKzFsTUpNditscmlIN1N0d2hscmVB?=
 =?utf-8?B?VCtDRU9FNDNBMU4vdU1yWTI0UndTSFFydnhGR1FzNUpPeGVieHBHOUk1RnAr?=
 =?utf-8?B?WkVmMTN5MDJUbStSY2cvRDV4dDV3eENrWHpLNnlRQ1VoN1BzSzkxbmFuYlU0?=
 =?utf-8?B?SmMvZUNSUHZwV1N4WW5heTc1Y1NCN3dJMkcxSC9GYmdEdFhnWkZhYzRLdTNU?=
 =?utf-8?B?SktnR2crY2ZhdjVmUTA4Q2ZzREhzejBaTXFNUW91c1YxRlVBT1NJc1daZklv?=
 =?utf-8?B?N0plcmpmbUNWMGM0UzNjNXNxRVdlcVZUM2I5cjMyS25JZGdpeTdNcC9lZ0xo?=
 =?utf-8?B?MEZXV0lJS1RyNUQweEpMU1JRNzk3Qm1KVHZCL1ZkNnUzakRETU5pTFMxb1dJ?=
 =?utf-8?B?MHBmWktoZXhuYkVicVNGVDhuQjFNd2trOE5ieDdQZjlRTjZWY3h6ZkxwbXBl?=
 =?utf-8?B?K0NRLzNicTM5Qkd0Z25kWWh0SjBodThITFBYQ2xvZmJFcmNSRjNCZW1STEFj?=
 =?utf-8?B?SStHcU9qcldEdFpCZ1hOSzQzMzZYZzZOMUI1YjBDbzVUTWNUVHJ5WGVUTC9o?=
 =?utf-8?B?U0VZNnZ6eGhsWXJObTZnbWxKb3FadzY4NGNreXVITkU4emlTblZGNWhLdDU4?=
 =?utf-8?B?blFxeklFN3ozWFZXbExYakNXOUFGYUNHWkJiUFJuYkRhSjQ4VzFId1U2ZEMw?=
 =?utf-8?B?ZGNTNllERXYwUndlVkFEUFJsVzBGeFQxZ0U5ckY1MnVmWCtZUFcwUW9XMFND?=
 =?utf-8?B?ZXpHZHZuWjg4L3pmbklqaGJQWU9USU10aGx1ZzJHd3k5OVFOWFovR2xtcWND?=
 =?utf-8?B?VWtpRTlHNjN0U0wvWXVpTFdSNVlZUkJlMFdvMXpKbnVaYjFFVXBMNG1tR01Z?=
 =?utf-8?B?UndwVzd3R1Q3T0tEbVcvc1hhTEN5R1pRR21CemN0ZU1GYkxGbTZDWFVOU3JO?=
 =?utf-8?B?VldSelJwVlZvZWRLSmZHc2kwY3ZPQXFpdUxaU1JlekIxUGlzaFVqL25kVTRv?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCEC3811646F4748964B406A8E79BBEE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd89a817-82e4-402e-0c9c-08dca53b6fa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2024 02:03:07.3621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qBAwIJcist+Xc24LNC8gCkLlgwC/M4IEm2RJ8IMUUbWhF/HwkZiB0FPcrkhFyutfq0O2yRM+sXKluUs5r61UKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7598
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTE1IGF0IDEwOjE3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gNy8xNC8yNCAxMTozOCBQTSwgcGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20gd3JvdGU6DQo+ID4gVGhlcmUgaXMgYSBkZWFkbG9jayB3aGVuIHJ1bnRpbWUgc3VzcGVu
ZCB3YWl0cyBmb3IgdGhlIGZsdXNoIG9mIFJUQw0KPiB3b3JrLA0KPiA+IGFuZCB0aGUgUlRDIHdv
cmsgY2FsbHMgdWZzaGNkX3JwbV9nZXRfc3luYyB0byB3YWl0IGZvciBydW50aW1lDQo+IHJlc3Vt
ZS4NCj4gDQo+IFRoZSBhYm92ZSBkZXNjcmlwdGlvbiBpcyB0b28gYnJpZWYgLSBhIGRlc2NyaXB0
aW9uIG9mIGhvdyB0aGUgZml4DQo+IHdvcmtzDQo+IGlzIG1pc3NpbmcuIFBsZWFzZSBpbmNsdWRl
IGEgbW9yZSBkZXRhaWxlZCBkZXNjcmlwdGlvbiBpbiBmdXR1cmUNCj4gcGF0Y2hlcy4NCj4gDQo+
IEFueXdheToNCj4gDQo+IFJldmlld2VkLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVA
YWNtLm9yZz4NCg0KSGkgQmFydCwNCg0KV2lsbCBpbXByb3ZlIGluIGZ1dHVyZSBwYXRjaGVzLg0K
DQpUaGFua3MgZm9yIHJldmlldy4NClBldGVyDQoNCg==
