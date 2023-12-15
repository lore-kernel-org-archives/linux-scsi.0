Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5A18C10
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2023 02:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GSf8uRJh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="hedP6m+v"
X-UUID: 113c94289af211eeba30773df0976c77-20231215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hHlxIcfkoikp8WLIUcrevwnWFt6N/EO5v1cnZlHOJ7w=;
	b=GSf8uRJhDYFi6J8N5HD2qu730tqxRa+DfMU69K90bSiqSzMlzPmHnecrA3kXgkKcVONFvGTQyCvTyzegXAWupH21VJf9mCfJbz9PsdyC/C5UYZPePRDol0d8SxUBUTond4htStaAMX5w7TLQimfNraPA8ysgZ+vIjYQhY/oFDIo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:135a5be1-7f1d-49ad-b9fd-b9bfed245170,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:79c2cf73-1bd3-4f48-b671-ada88705968c,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 113c94289af211eeba30773df0976c77-20231215
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1901478784; Fri, 15 Dec 2023 10:31:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Dec 2023 10:31:33 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Dec 2023 10:31:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hx34MeE1k0U1e2ZmKa330SCPML+hnM7o78W8Gq5bsyn0RJSx1kJlMqihOXTU0eEPYP9b/XGCLrKZjCi/CMihPUOhL+MDORxmQMrLWKPVqC+y2OLfDCfCX1DpsNW47OhCS3B0x8gbr78caPuQzDL/2Gr42lDgyKhJ5x3bBPx6ARR55r+ugp2HE1vY83iSuGDRcjXnPiW/DI7p8z3+4bv2RYp97WdzZmzGk9FEw6X9gtudEG1i6hy9XJyHw92CckZzbmyqt7iAdOduKM/TNrJ9PSM/J34D8zTDufohanVuWKBwJSOil41W0AFVqgx9lIR7X1W94WlXYPe5+2u/3wuCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHlxIcfkoikp8WLIUcrevwnWFt6N/EO5v1cnZlHOJ7w=;
 b=L+A6mrP7SNx5kZBj4ytSqey64Qg6EhvUsjIF4xYiJIjr3ISElbV0Sc/0sywdUQtsl7pDhvY4A7w2ijgELN08uNZwIR5/+uqlRjIqzASmSTEloe8VqGQKRzqHqMV2ybiHoLctgoXxPI9yizZMVPL1NrTZDZgDCfiacrZ0JfcgZKhZZPlyhbIpmH01EcgxXKgSkEKV/terbU3pr55IEOuyE+Edds4rlOb2KqHdtzi+uLY6NJRWDAePQYRAbVJ0dOl8bN0gi5Uofzt0je3VojhFYHDTOLKYuliiFNmLdDvktAG72wLuoajNBCpJ86Qj2cwqKKwpvWXdcyP9G04Db3Yo6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHlxIcfkoikp8WLIUcrevwnWFt6N/EO5v1cnZlHOJ7w=;
 b=hedP6m+vyEHlsk0PTYiFzJBBJi+4O0qim9fbPls7bl1BzzNmXKNhA7yMf84hIU0PjMji14m8bVrZLKD1LaMQCn+W3Gw1oxAIkcyIQTAg4LCvKo5/w3w2WVI8fzzTmjRQz6nGLdYZU9UStZZs8T66cTTtgiK6Oxa9T13s6kaTHxI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6724.apcprd03.prod.outlook.com (2603:1096:101:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Fri, 15 Dec
 2023 02:31:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::4cdf:58fb:79dd:4b7f]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::4cdf:58fb:79dd:4b7f%4]) with mapi id 15.20.7091.028; Fri, 15 Dec 2023
 02:31:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "Arthur.Simchaev@wdc.com" <Arthur.Simchaev@wdc.com>,
	"quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"mani@kernel.org" <mani@kernel.org>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>
Subject: Re: [PATCH 1/2] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and
 make it static
Thread-Topic: [PATCH 1/2] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and
 make it static
Thread-Index: AQHaLsM9gKxlZtGDeUeUdvnLHuxE67CpoBgA
Date: Fri, 15 Dec 2023 02:31:31 +0000
Message-ID: <c3477afd06d87364b310d8849f595ea169ac5839.camel@mediatek.com>
References: <20231214192416.3638077-1-bvanassche@acm.org>
	 <20231214192416.3638077-2-bvanassche@acm.org>
In-Reply-To: <20231214192416.3638077-2-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6724:EE_
x-ms-office365-filtering-correlation-id: 975751ce-0758-448c-ba48-08dbfd15f2c2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ps3HlJM4Ur3/bbSf2+ra6trOV+RC6UK7xLrABkf2V6ZWlSEWPpo/vRx+wxFliITPgRAmMLtYvOYKtCZwfSFOt/LxQ2wQ8S5z4+8Gu3o6PuEFgFn+fFfwByH87GsOk/+/FcY/k+bjHyIWeZVpO433mRgAEdEaY5KWverw+3bzivcmcujCxHWPVvtUofyjIXr/sFrAcQtp3JSnrhlSlUGbyzVNtus1Y8d5N188liqYCF94NXc/xLwTYFCUaKh3UogS+YfnyAw34s5FbGxfzx7YQI3LWyf9+nRltL+yjwP8F8iUnaybwpk/Rn07spQIoh2JTQ03qHTkget24i+xOLkv9zaJ3KPXVcJW0UfTGAxyB5DutoUHmJYLMUvTM51h1XPzWvxXZL2ophXv56Afskf9icdzCQ88QD+2RVI7aJhwQ/4bZQ/uyDEk3ceHpWOarKR6HkmZLIy3wj58eqPae9pmg+uI3viJt34z+Jot71prUN7rk1albvGd+upKF7yt9hHahCztlgd1UR7F3m99RVVXWfIvFz9TPfjo19797T5e1RZNjcXN8mO0BTr+0OQLuzOn5cxasJ2TzINUXV8XASyB6mgAdg+6bFAo+jt2c9C7SQ+550lrjXyqvPaV4QegzDQMjvOEyP4Dn+cbxA+hGuTHp6nDkc4Aj+oCbRrO3VSTJWag14xDaACkrZQw+et+F1l94XD+mbkZkxV32freXm8zVNZmSSefoyg93bHtRRITo/I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(346002)(136003)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(6506007)(91956017)(26005)(4744005)(2616005)(478600001)(38070700009)(6486002)(110136005)(76116006)(66476007)(54906003)(64756008)(66446008)(316002)(83380400001)(66556008)(66946007)(6512007)(71200400001)(86362001)(41300700001)(38100700002)(122000001)(4326008)(8676002)(8936002)(4001150100001)(7416002)(2906002)(36756003)(85182001)(5660300002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnM1TTg1SXRxY0lNZEMrL1huQmI3LzhRWTBGUFJlcmNlbFV5dUVhR3JmNHhT?=
 =?utf-8?B?LytMd01MSnBVNGE5MXY2ZitaTy9mOUtQT1JPR2VpRFozK2NFL2JhN01PcjNH?=
 =?utf-8?B?QjM5UHZmZ1ZGa2tObDM1L0ROM3d2bndkTVJXTXJwYXB0VXlYNXplTzZJMmRk?=
 =?utf-8?B?dUY5dFVqLzdCNmpDV2I2MkRKM01XaXBxUzE1aHA5bnNEdkRDU2tiRmo5V2VL?=
 =?utf-8?B?RWFCVlVxNjVlNkloVEcwSE1uQjdGeWREcWd0eWRmTDYrSmowVHh1MGJZNU9Z?=
 =?utf-8?B?SEh0UzI2Y3pkbVNmNTNRZUdxNk9nd2NwQm84clY0UCtlaXVTSzFLOXJUSHpy?=
 =?utf-8?B?d0NkVmlPU3hnZG0zWU8vcldTNVNvcVNPOVRjZHd6WFN3a2pDOGZJbzZFTk1Z?=
 =?utf-8?B?VElTSUEyeXJjQXlHclRrSzNvMFJpSWlXM3FBRURvaEY0c01PVzBPekFQTWtD?=
 =?utf-8?B?NDhsV1NibDg2MUthWGNGMWduVXg4N2FYWkN6Q1o2Q0VkaEt1V3ZYM2hRU2VJ?=
 =?utf-8?B?Tk5ITWpIaVQ5YUdDOU0rdE12d0hYSmlwWkVjTk9vQlM5aWdnd1VKcnJkMVNm?=
 =?utf-8?B?YVVKVXpUMGxlZWxkZ3ZRNlVmZGhicmxnVmlUVXNUY0tLalJHQ3pQMGJ5dUg4?=
 =?utf-8?B?SVJPM2pKU3JmS3RZaFA1S0JOdlRjOUFrYytpOTFqQUcvOE5nM0hyS09EaC9H?=
 =?utf-8?B?SUd5YVNrSlFQOUVMZjlMLzFPYjU2cEs2ZXN1OCsrcTFhRmp1UUFJdVJ3VG1n?=
 =?utf-8?B?dnJ4T3VZaDI1RmpXaEtsWlBBUjZZNlZEMVdNQk9JWXVLdE95WDlpSFdhMitR?=
 =?utf-8?B?NUs1MVZCWVYzMElocWZzcnhJZzlIVG0zdURvcGRtSU5Rcm51c2JFS2ZTTnZm?=
 =?utf-8?B?YjJWZWpPTUYycitHL3MxQ0RiQVhlKzA0emhsL2lyTVlmV0tJbE4wdFJ5TUVG?=
 =?utf-8?B?YnhidllJTFFOQVZEWEdldUFMcEdtWmhXRUpCNGM0dm1Cc2NzN2ljUU5CVlNO?=
 =?utf-8?B?Ni9zUmNocnpOejhDK0pPSWVZdCt3eG9adUNzODNRWjZOMWNBOEZwUTc4WGFO?=
 =?utf-8?B?azFXSGRFRGsyK1hGWTdUdkhvUkgxVVM3Tm5la00xRDBCdXRvOWZ5U2ZYUG9G?=
 =?utf-8?B?dUxsaTJ2RERvc2dJQkhrMVpwRXl3YytyNHJwVTNSa09SclNZa0pwQnF3MzZV?=
 =?utf-8?B?b3E0RElqbnBuRzU3R0R2RDVHeGpTMkJwU1FBcFVFcE1PdW1nOGpGdGlVYlgz?=
 =?utf-8?B?SWNEb1ZYcnJnazlsMjV6WFB2eG9TdzdCZThjRmF3NU51SGZNSkdyUVZhR1N5?=
 =?utf-8?B?WkxuZzAyL1NJSnhFeEJEYkFReDMxSGdFc3VnNWFFNE16dDM4NkhWSlM4SEVC?=
 =?utf-8?B?d044cENIUnIwUExpZTZnLzJIQm1UYVdCc21hc3JPZlJZUUJKaXFtOEdnQ0JN?=
 =?utf-8?B?L1RMeEhHTVhvZ0F3dlhRb3hscjNDNnZvdUs3STRqdnJxNlJVU1hsR2NmT0Na?=
 =?utf-8?B?bjAybytmU2dCTGFlbUpnVmNNOUNyaFhQcWdlbWFiUGVzWTVWcVYvclBWR0Jw?=
 =?utf-8?B?aGV5a1Fib0NmUnlBSWowNUZsc2Y1MzRFUFdqUmlCb2VxMHZJYWZKdC9ZMDNo?=
 =?utf-8?B?ZDVBN09Xd3hpY3FtaHpHRFpiU2RUUEtvLzlENndRWU4wNkJJbDk1akRFWit2?=
 =?utf-8?B?MWtHQThXQ3BmcnNIbXlwL0F2Mm9wWmdvdnZXL0oxTjhaZ3VEMnRqYWVUQ3hz?=
 =?utf-8?B?Q0pKNmlMaUtCWENRakJVbGs2amEyOVRyNHE5bkYrc2NPcE9va0U1M0pZMHdo?=
 =?utf-8?B?UHZxczFLekJQUVNzTVNRQ0wrNXN6RUQ3V3lqV0QwUnBqR1FmanpLTmx4ODEv?=
 =?utf-8?B?RnNjL2ZCeTBNY2RTemxUSTFSTGxEckQ1VVNLRisycWIwY0xKaW9keGlVWDZI?=
 =?utf-8?B?YUV3N3FwVWUydzMxdVYvQVZQZ0l0UWJLeDZOT05Xam9EZ05TVHN5ay9wdFMz?=
 =?utf-8?B?MkUzSzNqcnU2UkxWUnM5RXlTdFBodkZVRU1oU0hPQytFbFZpTmFYdWVLV00v?=
 =?utf-8?B?L1NSKzNVSG1sVlFBL1dMVXE5THBzVDJRWXVTWDhtMEJLYWtXWm1obXdTVzVm?=
 =?utf-8?B?dkx1RnVVeWhjSllZK2Y5SmhpWmQvc090WHdwL3QrN2N0SVFwd1l5LzlMTVhv?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F16107CED666B441BECA201669A7C1D0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975751ce-0758-448c-ba48-08dbfd15f2c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 02:31:31.1690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jnVEqKNBjDV8+FC9B9exrWE81V0tfeYqOn0SiIrHnIKblCabQiGKZ3LwfPNNOD3CvwKEkUmOsDlzIoeN7hfDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6724
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--12.189900-8.000000
X-TMASE-MatchedRID: dwNgap4H9hjUL3YCMmnG4omfV7NNMGm+bkEYJ8otHacNcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzVy4hHC3/gyA6QlBHhBZuwRAw
	IPTXbPAExQoi9/6SsEPwi5mIlCYHkxkSgnHUeW2VjVtAwIy+afs6j/8n8QDVBOmC93eKossajxY
	yRBa/qJRVHsNBZf9aRodR/em3xyDXu2nB9KtyYQNmzcdRxL+xwKrauXd3MZDWQUtVu4jv/Jg4Xk
	Rt/qrn4GvEhazltGhLofKTo0jrw1wtgINDvFUrF
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.189900-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	01744049EE870E6882172CE9730F4EC31393214126F2E3C3D4B1E5BBEAA747A12000:8
X-MTK: N

T24gVGh1LCAyMDIzLTEyLTE0IGF0IDExOjIzIC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgUmVuYW1lIHVmc2hjZF9hdXRvX2hpYmVybjhfZW5hYmxlKCkgaW50
bw0KPiB1ZnNoY2RfY29uZmlndXJlX2F1dG9faGliZXJuOCgpDQo+IHNpbmNlIHRoaXMgZnVuY3Rp
b24gY2FuIGVuYWJsZSBvciBkaXNhYmxlIGF1dG8taGliZXJuYXRpb24uIFNpbmNlDQo+IHVmc2hj
ZF9hdXRvX2hpYmVybjhfZW5hYmxlKCkgaXMgb25seSB1c2VkIGluc2lkZSB0aGUgVUZTSENJIGRy
aXZlcg0KPiBjb3JlLA0KPiBkZWNsYXJlIGl0IHN0YXRpYy4gQWRkaXRpb25hbGx5LCBtb3ZlIHRo
ZSBkZWZpbml0aW9uIG9mIHRoaXMgZnVuY3Rpb24NCj4gdG8NCj4ganVzdCBiZWZvcmUgaXRzIGZp
cnN0IGNhbGxlci4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0K
