Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C677515AF
	for <linux-scsi@vger.kernel.org>; Mon, 25 Dec 2023 07:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WJgkYsBO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dbJuyyIY"
X-UUID: 0e888eb0a2f611eea5db2bebc7c28f94-20231225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uht3WW8IZjgUxB5T9A8ANe1X1Ahs/xw4kTWtKr6OesU=;
	b=WJgkYsBO7Z1jQlHpjVYBj7e8BPNUf4cY4Prpjuu3nEbYfZApYZste000EDhPFNdD4L+/zu6qvcHsMTOcsI0M/8hReFpVgYGPJ58A7osSYTbVE8dmdEDpfabkfDFcCNAnz3S7G8G0XNrbBZIg/qD16Rf/wUVWJHQA+QBWzMNBgtM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:894012cb-6c7f-4691-93f5-f669a1dbd06d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:3b02a37e-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 0e888eb0a2f611eea5db2bebc7c28f94-20231225
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1160129516; Mon, 25 Dec 2023 15:20:18 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 25 Dec 2023 15:20:17 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 25 Dec 2023 15:20:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFm3ieVKV/f5/GWpv0+kwALn7N1K5J85jBNR7x9VXJaj1GS/FSnCv72l7zxRXOQnKVwMYbNkDqy7fbvVA3iMyANMsASF2csELbmdHfZ1w+XI50804+FmCnClskIodpoLe+puMfrPfneMy5FsHLyRxrO+FWSabxIsm28yF6nlnXoorPxz6SOLl/JcBDUjlhW/wQHIjXJEKPpWFW0U8c+16Gjr/7FZd72aJ/FkrLBVtOp9keUuv90Uf4OH3jpgDMHVfaxxFP/J/2/4f1NO6eIck954rq/7k4Pp8mjwpfn1+5zyTcppzIAl6LgKx+JFF7bqW9SMOzzHpoVGx4OuR9Zi4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uht3WW8IZjgUxB5T9A8ANe1X1Ahs/xw4kTWtKr6OesU=;
 b=h7sJOne5ghZZmshLshaIjQwcn+ESsOCEy/xNRTNuy+E2Yj1qvhrEjNhmln7bnxgPVzyIY90PDZzsw3kbSe81fYNeMpTpiGbH5d6HG6ws77s22Nodn6498MZ303qUwNq4RY3yYDuoO5C0wOJCOHWX1BDCIvdI1k9ZVWla1u/Iv3Bp557OoBt3iL7+x2sxTMDx2jMboDPJSlKRmU4uq1LSruBAA32GOUWYI7Ud/tEnLYps+YenkZqYPpOJAXwsddPck0PFsVNoGM+j1fvZ9jlQYn/ApI6tj6l5LBoegaODUSOaZl52ylaMxrAj6U/ElEP5Oy0WZ+yOEMLFzbp5CaL+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uht3WW8IZjgUxB5T9A8ANe1X1Ahs/xw4kTWtKr6OesU=;
 b=dbJuyyIY0MYvUURqLutyO9w7lc0ve3uiUNxTBmM+sYkOzmwJaz/FXCPjyr4zX034iAnxoT8DN1Nns7snKxcw3EGZE6joLMOR9Zxmykisbx00q+6BbAaBgKTviEc1T3ZzsWXozNyIqxBPlw9tjKmnGwcRV5JfcI66TPKO2SaCYhE=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by PSAPR03MB5669.apcprd03.prod.outlook.com (2603:1096:301:85::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 07:20:15 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::f561:7963:686d:b2ed]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::f561:7963:686d:b2ed%2]) with mapi id 15.20.7113.022; Mon, 25 Dec 2023
 07:20:15 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?=
	<peter.wang@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 1/3] ufs: host: mediatek: check link status after exit
 hibern8
Thread-Topic: [PATCH v1 1/3] ufs: host: mediatek: check link status after exit
 hibern8
Thread-Index: AQHaM/2V0hH2WPSWsU+jYD2OpEvTubC5naAA
Date: Mon, 25 Dec 2023 07:20:15 +0000
Message-ID: <2899fb4f036ec3087b98d608f2c30134d9f619aa.camel@mediatek.com>
References: <20231221110416.16176-1-peter.wang@mediatek.com>
	 <20231221110416.16176-2-peter.wang@mediatek.com>
In-Reply-To: <20231221110416.16176-2-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|PSAPR03MB5669:EE_
x-ms-office365-filtering-correlation-id: 05d82afc-f630-4d89-5a76-08dc0519f0c9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: alVS9m78cgSfuG3eqz6DuFmMa7UoJSMhYo3E/5F/csfme3RSbTHHQJJRG15jFiEBcOaiyxqgC/fN/9Z0Cxh5SCe0wszJXVpGD7hbeWTUgrKsqVeam2uBEIK4tWLUrcJeACFNUnxUlToBNUKLrpDIezw3ZxyYKCezWiP7D68gAwUi/JccYUg3b3kAFH1tC597Af2OjZLKjdeOdjHiHIBv33/m6PLgf03wLLrmpyvOGruTcHriQOnzRBR6lnlRMztyBBTgMguGDsTqidVpWQqfS13fxeww3HfwoHuLOWOZUwSrVpF0VmhNCpNYErJkeMJTe6NesdIIwxrB9/VehShMa9ut8OVhnR0jWLnxM5AvUc2FfIXqqqLwVSEb1ULKfp8RDEgD6QNE1gXEwxFq8tJ6u+i05Gy80dAOgPFkE/XpcoQTEgOeA5KbmpqX/gDHPPJCbnoN3k2s/pv8wCyx0/RKKwRbNnxDMuhxdOS3UyJ0kungCEr3YcKOyLaPYuVJCyc76e9iuKlHXXKuaa6oBmhFAfEFhlAALlRYuXI5S2mkoNSUsaSbv1X1GQ5aYUlBIPt568EIgPdfZJ/s5qzIB8y4iz8o35PCZk1mczc39XeO7btHA8LhDyksd/XBdOAxB+8iO4bgL2TI08p/s6ZXemXz5XYUflPknyOZgSO7xmlAnvg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(346002)(376002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(5660300002)(2906002)(4001150100001)(6486002)(478600001)(110136005)(2616005)(6512007)(6506007)(71200400001)(26005)(107886003)(38100700002)(85182001)(86362001)(76116006)(66556008)(66446008)(66476007)(66946007)(8936002)(316002)(54906003)(64756008)(4326008)(8676002)(36756003)(41300700001)(122000001)(83380400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnhocFFPSzgwZkQwRVRmb21jaGlUa1FlQkFXUnBLcG9Ca01zQXpua2Z3VVk0?=
 =?utf-8?B?bWxvMWZCa2lJU0tuTTNNbk5NalRnUGpPTHdieER6VEN2VnIydHhBSUtEUUFI?=
 =?utf-8?B?NXFXKzhEY0wyRzJhOEJoaFVpMWp1anJremFHKzE3WjYvdGFDdVhKQzRqV0lQ?=
 =?utf-8?B?ZW5sSVBFYUR3UkJUbmdkK3RJdk94bE9iYnpjSGNOYytUaWtPV2dZSXRWN1Zw?=
 =?utf-8?B?OTdvR2lDS3FLQm1UWSthZXA3TWpUb2pSaG9IU2VyUWZhNldrVTVEb3hTcXlM?=
 =?utf-8?B?VEo5V3ZwVTVqUWF4TGdkRHVVaW1zU1JkTXd5TTNHTXFmSmFiTXM2TE5oRGRu?=
 =?utf-8?B?QmI4YldwRGd1QTUzcTBuNHVEbzRKM0N3Ym9GYUtucStMeW9NZ2d0TnRpS1gw?=
 =?utf-8?B?cmJ1UmFIdWYyS0FxSmNjZlMyQlNPK1pySlBmcDRJNjlibS8ySkFGaEZwSnk4?=
 =?utf-8?B?UUIwSjlyRHdqSHYrMnNLeFl0T05TbU42ZVdvREZZeCtOeVdkWUFEL1phaEFU?=
 =?utf-8?B?S1BQb0Jlbk80WmprOUlPQUlvRkpwQmJmK2YxVkl4TklaSEpXLzJKMmtrN2c2?=
 =?utf-8?B?YU1obHVObmZ5QTlYY2t4NnJDOGN6VElOYXdLOGx0aXFEL05BWkt4UW4yVlIy?=
 =?utf-8?B?QWVJVVIzNUNablVkcHdMWVNRK21mcGFINmN5L3lwU1pnM1hYczNGSEp1ZUQ1?=
 =?utf-8?B?aks0bmMrVjhYb1RJeTB6UU9aeWYxQ2Y2a01rVno5bHA1ZXVKcmk2RmVtSTdv?=
 =?utf-8?B?WnNPbWZTVEI1N296Ujd1V1MwdnovZlhsWTJHb2xxM3hLTm94bE5BYjhhSGYx?=
 =?utf-8?B?V3M3RFYraHcxbGpsalU5aEliV1dVTDdpVnhVNjJPRkN0OGdBYTJLSHpmMWNQ?=
 =?utf-8?B?eDR5Qm9MUHNRUnA5QWk5UDJ4ZFBpcVdFWUM0YW43dXBiSHliTlNNSTBMczFx?=
 =?utf-8?B?WjRuanM3MU5vYitPS1c4NzRwc0JIVG5YUnd3OGRxOFViWkQ1ZWZhVnlpUWkz?=
 =?utf-8?B?R09ZT05saFJsNUcwNkZ5TEl2NUJsSHdiU25YdlF3aGNXZUNqWllqOTlFUVRR?=
 =?utf-8?B?OE1oYlF4TUcxcTlqak1jSFA2L1czMyt0N1JHeVg0bWpiUUJEejMwQnBoZ1ZG?=
 =?utf-8?B?Wm9KNjczYUhDZ3AzbUpVTFN4RHg3ZmJjS3B0NlhINXdUMUZ5U2dQZUYweEdz?=
 =?utf-8?B?Z016L09PQkFuTmJrUXRVazNJQytuWjRhSlJuM3cwa0RnMkZZNUM2UXFFMGpH?=
 =?utf-8?B?OER1T3dVTVBhUjFkaUVxZW9pR25iVkV1clFmbEx6MTlCQXl6WG9xNlFFUGwy?=
 =?utf-8?B?RUp5YWdXSjlGa2hGb2dBb016N1ptcUVYVzBudEhnNnJYMUk2aE05N1FWcnBI?=
 =?utf-8?B?UXBWaExUbHZKSFZYU1c1SjVxNjVsRUo3alN6UTJMQXF5VFhBb25jbmxaVUVl?=
 =?utf-8?B?RzE3OEtlc0RqbzRlL3RPR2Y3Q3VBdTBRTCtGSnVBZ002YkZIUWZyTU4xN3hM?=
 =?utf-8?B?TkFvOENjNnFWQnQzN1pyTXpxcXRWSWRJa1JLNHUyWEd2YzZudEpPM1BSY2ti?=
 =?utf-8?B?ZWhpb0JYQ3ZxQlVQU1UvQjBTVytHb3FobHB6WloxK1dGMjJURGhVaWRXMUlR?=
 =?utf-8?B?WmdZcjgweGwrNTMyU3NuQVFTM21GWWZRYUdUZUJyTDZUM1ZWZmkvY1VlS1V0?=
 =?utf-8?B?Zzlsb2tTYUtHaDJnY2Q2TTU1bmtQOEViQ21HN2doUklpTmJCWlB4SlZ4NWgw?=
 =?utf-8?B?MXEvMCtPSkl1M2hrVVpPK2dTMkFMTC8rSWw5QW5ZTDEwUURPT056UklhUVRT?=
 =?utf-8?B?R0F1WnVFekVDSWhkWURLS1piR2d1aEI5eE93U3B1VEJUL2VJOGd6VUVXUFVo?=
 =?utf-8?B?QXZZVTJOVE92MjdHMFhMekxBTDhlMVpzZVZCZ212dzl6TzdJODNFZmpCeTRQ?=
 =?utf-8?B?MEUvYk9WME1wTVJxSllkMWc4MzhwZlJhYWR5UXdheU13aGZxL3Z4MHlnZ1Nh?=
 =?utf-8?B?UzdiYkhPck5ycHdCNU9zQ2RlanRCTisrUk9qa0JodXF4aWg0R2pOOXhCMWNi?=
 =?utf-8?B?bDBVS3Y5M3FxUnc2V0ozZG9SRGxzNXdNUG83ekhZMVR3L2U4MUxyM1A2c252?=
 =?utf-8?B?QXB2WWhPczR5ZHE4K2hIVmMzVUY4UmhWT3BUYnVKZk9tYjNXNXNYUWxNV2Vz?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB96C57BB47C634AB754C7AB11357228@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d82afc-f630-4d89-5a76-08dc0519f0c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2023 07:20:15.1582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xr8BxMIVaOgkaQD2w7nL4lBqFfsDWcQF4fwnZqxRL9pdpfc1/NSiC3B4Blqa/MjE7UjoRBuJjWJl5U/srvbyPt3v7Ce9kzZxNUlW4FNRokA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB5669
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.077100-8.000000
X-TMASE-MatchedRID: lywBov0pR43UL3YCMmnG4oei/mZCYVwugDRlwc+wR6cNcckEPxfz2JMY
	h35TurcQCeertVoXp2gBtjkcfRMmqXBe8qvb907dngIgpj8eDcDBa6VG2+9jFNQdB5NUNSsi1Gc
	RAJRT6PP3FLeZXNZS4IzHo47z5Aa+6XmpNzc+c4cE99cfDFKLoo62OZ0JEdZCOYuIHMvtG7ezMl
	4rHEuk1ElBLnnvOChD8z0Wm/hwAWu1FfES6M/VcAl1lqYDVpDUVmmxOBaYGYUTjjQYDW1fK9ShZ
	PtchUPCwW+DRCdw1x9WXGvUUmKP2w==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.077100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	3A6DD31536DB029087DE96034AEFAC5C76BD9EAC15C4D9739885CB4C7BD9AE852000:8

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDE5OjA0ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBUbyBwcmV2ZW50IFNTVShBY3RpdmUpIGVycm9yLCBjaGVjayBsaW5rIHN0YXR1cyBhZnRl
ciBleGl0IGhpYmVybjguDQo+IElmIGxpbmsgaXMgbm90IFZTX0xJTktfVVAsIHJldHVybiBlcnJv
ciBhbmQgZG8gdWZzaGNkX2xpbmtfcmVjb3ZlcnkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQZXRl
ciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1tZWRpYXRlay5jIHwgMTMgKysrKysrKysrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLQ0KPiBt
ZWRpYXRlay5jDQo+IGluZGV4IGZjNjE3OTBkMjg5Yi4uMTA0MzU0YTRkODk5IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+ICsrKyBiL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gQEAgLTEyMDgsMTEgKzEyMDgsMTggQEAgc3RhdGljIGlu
dCB1ZnNfbXRrX2xpbmtfc2V0X2hwbShzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhKQ0KPiAgCQlyZXR1
cm4gZXJyOw0KPiAgDQo+ICAJZXJyID0gdWZzaGNkX3VpY19oaWJlcm44X2V4aXQoaGJhKTsNCj4g
LQlpZiAoIWVycikNCj4gLQkJdWZzaGNkX3NldF9saW5rX2FjdGl2ZShoYmEpOw0KPiAtCWVsc2UN
Cj4gKwlpZiAoZXJyKQ0KPiAgCQlyZXR1cm4gZXJyOw0KPiAgDQo+ICsJLyogQ2hlY2sgbGluayBz
dGF0ZSB0byBtYWtlIHN1cmUgZXhpdCBoOCBzdWNjZXNzICovDQo+ICsJdWZzX210a193YWl0X2lk
bGVfc3RhdGUoaGJhLCA1KTsNCj4gKwllcnIgPSB1ZnNfbXRrX3dhaXRfbGlua19zdGF0ZShoYmEs
IFZTX0xJTktfVVAsIDEwMCk7DQo+ICsJaWYgKGVycikgew0KPiArCQlkZXZfd2FybihoYmEtPmRl
diwgImV4aXQgaDggc3RhdGUgZmFpbCwgZXJyPSVkXG4iLA0KPiBlcnIpOw0KPiArCQlyZXR1cm4g
ZXJyOw0KPiArCX0NCj4gKwl1ZnNoY2Rfc2V0X2xpbmtfYWN0aXZlKGhiYSk7DQo+ICsNCj4gIAlp
ZiAoIWhiYS0+bWNxX2VuYWJsZWQpIHsNCj4gIAkJZXJyID0gdWZzaGNkX21ha2VfaGJhX29wZXJh
dGlvbmFsKGhiYSk7DQo+ICAJfSBlbHNlIHsNCg0KUmV2aWV3ZWQtYnk6IENodW4tSHVuZyBXdSA8
Y2h1bi1odW5nLnd1QG1lZGlhdGVrLmNvbT4NCg0KQ2h1bi1IdW5nDQo=
