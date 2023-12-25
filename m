Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E3F139F
	for <linux-scsi@vger.kernel.org>; Mon, 25 Dec 2023 07:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="iEj4TbNj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="odE3ppY0"
X-UUID: 685f6b20a2f611eeba30773df0976c77-20231225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=nT5sT3kdwvdIe9LlNhaMgdHbkIe1T7w54BSdtzmXywc=;
	b=iEj4TbNjHw9qecCdScgL1v+LSh4zHZdfKllHGmdBAEDOnXl6JkKhHEU43liceg2kS2/Iq2PIVKtQCnfuprTfS+1NS+BzXbEBKhY4Lxj9uPsJJ6EkY5bHac+7Qujy8zmMhYQ1LdKJI8KuaTBwLZImzD8qtQ3Gh2+5nFTt7PbhzGI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:5bc8909c-53f9-4fdc-b40d-a7f699117751,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:3a09a37e-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 685f6b20a2f611eeba30773df0976c77-20231225
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1721414265; Mon, 25 Dec 2023 15:22:49 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 25 Dec 2023 15:22:48 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 25 Dec 2023 15:22:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TociS+ik1e2NYfpdUdER6oamQot1Bmrgwh5Rlyt+iKj785wYwtho0ZNnVMNqyXpRIk74NRiAUYJ1aKGVUIxs94ec2CFCm65/DGTM5jVvVj/RgLWefXF/3xxLyLcbqA2B1kob6Kv2CQxOuL4u+hpdiM9n3Tl/f3kUTc+PBZFG9E7jKRFIjjcJ24JpjUc/0cGLsMWIqIZTHQ/kkYL1pAp5aUArkrX4fvRgHYAiT9Q6qF3a43uT6XRzB93QMapHgKJ64C7CGFAILVAHeFlzL861iLmrx+9CfrstwCgdhAl8QZ2iZNSb17Kj+R85gq25GRBE0K2RhQs8egus1h7tbwodNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nT5sT3kdwvdIe9LlNhaMgdHbkIe1T7w54BSdtzmXywc=;
 b=fVlvnw8KKJAvCsaf4/IE8YXAhYvOVeLoL5gZrQd9LyPQgevUU/t9t4VMlzFm+DEuxyqUza+tslR+DCveXfFH6T9AQWnva5s+nda2cpnYQ0dN+z7bj3cKAij9Ijdl6xiVVUkj0YhI8Ae7Mysyh0TLZKSCRvIbMm9h1F+1bWSrMRBEydkOlAyDXrMIEe18d35IY7vdHHgdOCWO+fFoDuUI094+48RAjvTMehcK2qzQd2cqm9llQzO9/KVKAWRjAWYAaBp9CAPOCRPdc9p5Opj3cbdtR9S3Fzlet8BfPswGvpdMc+P8vmTmbV8WJTHxm6qQpIA550Qxn7Osybo1LtSdDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nT5sT3kdwvdIe9LlNhaMgdHbkIe1T7w54BSdtzmXywc=;
 b=odE3ppY0gtgTIoM+lgv3tY8amD3/Ymapdcm9hXsFZepxWF2EXfp7lr8vSimW0CpjUBLc+Zu/OQeykafyIU7l9UKcMuR3/e2ixVvXsN0TjMSCxhw/YXfcKF6+NtxkZrG3yt2rGcoC1dWbNjpT8W9DJtSUnx9BNmiLDLd1xUNjRvU=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by PSAPR03MB5669.apcprd03.prod.outlook.com (2603:1096:301:85::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.26; Mon, 25 Dec
 2023 07:22:46 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::f561:7963:686d:b2ed]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::f561:7963:686d:b2ed%2]) with mapi id 15.20.7113.022; Mon, 25 Dec 2023
 07:22:46 +0000
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
Subject: Re: [PATCH v1 3/3] ufs: host: mediatek: disable mcq irq when clock
 off
Thread-Topic: [PATCH v1 3/3] ufs: host: mediatek: disable mcq irq when clock
 off
Thread-Index: AQHaM/2UZVR/9DCblE2V6EZXJ6Teh7C5nlSA
Date: Mon, 25 Dec 2023 07:22:45 +0000
Message-ID: <a47d054db56e9aef48a24c6467901cb4743506d9.camel@mediatek.com>
References: <20231221110416.16176-1-peter.wang@mediatek.com>
	 <20231221110416.16176-4-peter.wang@mediatek.com>
In-Reply-To: <20231221110416.16176-4-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|PSAPR03MB5669:EE_
x-ms-office365-filtering-correlation-id: 589783bf-ed9a-40c5-984f-08dc051a4aa8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ddozh3wWNKY+MLnfk6UCS+Z4LoyzrZ/w6XTdxo+XNfo7J6wAA+5mocr4OTzahRpLm8SxUz90DGpMzz8kS9a68yfEWu0i9FJ29MYKPiPhq8kCx3E376tXuCJXHwXQa3h1PKMGwpyxjZ6wb46ltZ1sjR2+VLpIyVsNLTUgt4FiUac1ZdsbmKdNwQPeT9vTLn6aWG+EpsfEAXhwwSbyNByFZEUpCicQ3J1KEeyaF8aXR6AJB3cPuXlLn1OAbLq6SDdYWIB3AwTrdFfEWGE8g7dsbDzFZ4KRMRdVVh+4+VP/i/l8FDqftRR4b+AuLLenJP7PljZpDOV1lFuArtM0Gak2ekygT8Te5GmizN093buhG2KzQnm/qqs8HdydSwcKSjMRmwoS/yJ9uc/MoDTiqx1KyR74hLWIvlYkw/pDCoc4ccWAj3Utb6vbFK3PsQQMMCCsOdATDnWfHMR692o2DBZiJUaIbNfv8/g/j4Gk9NrYv3vHmwO7gj5wdBXg5zdlQcCqNaXdxvR0ONtokoE9svJkHZkD3RaLkh468apzI7ues+pTLl/nXiNKV8N1J3q6JmJgipc27BO9rtNu+zthAuo9mNSdp5IoX9K6ANIJusAnxUHgCRnUTVULKdLp9z3NqCllFOYnspJCakcv52ACjo8F7Y68xhGC93gW/vT+B/q5g8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(346002)(376002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(5660300002)(2906002)(4001150100001)(6486002)(478600001)(110136005)(2616005)(6512007)(6506007)(71200400001)(26005)(107886003)(38100700002)(85182001)(86362001)(76116006)(66556008)(66446008)(66476007)(66946007)(8936002)(316002)(54906003)(64756008)(4326008)(8676002)(36756003)(41300700001)(122000001)(83380400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWRkRTJUY0RjUU0zNVVNL1JFQlBreU1BajZPd2pKVWVRN0JhYTNRSVZyS3pl?=
 =?utf-8?B?MWF0OGdFNWNZVmFIam1xSll2WDF3aWQwU0d1SHNNYUxQa1o1bkNxQTRmTHZQ?=
 =?utf-8?B?MnFyenlPQXpZQW9zUDljNXBMZEZYbU0xa25UZ05HMWUwT0lkTEpUN2F1djlz?=
 =?utf-8?B?MFFqTzhDU2FXWFRwQTBmbVVZc2xnL29WZTdhR2t2TStFV0pzclJVZVh0R3FD?=
 =?utf-8?B?NkhXaFpGWm5uRmJ5MjlQM0lsYnZ6Ym5xcG5pZHFiemR5MFRHYm83RUtKUHFt?=
 =?utf-8?B?ZzZFcFVoUXRxSE96RlhadlV3NnlmQkNZZjVXbEkxblJKRzE4bUVBRnJhZ1Ji?=
 =?utf-8?B?Z3dsMnprbnpCeWVQc2FjV2h5Nk02SXBIRWVNWUwvcTAwWkh4aFZ2K1A5YXE1?=
 =?utf-8?B?bzFHMVNyeXBpTHgwcnVQSE4rd3pXMTV6VjBIenJSdHV1R2g2bktlN0cvRWlO?=
 =?utf-8?B?TDVWSFg1aVk3NHlnZjdRWjAxdVU0S1JKMXB0bU5tTHVXdE5jbHB2bUd5Y1hS?=
 =?utf-8?B?VzI1NWhuenpJdXFoQ0pMbklEaGxZWk56TGRiN3JSdWJISGwxemI1TFh0bVox?=
 =?utf-8?B?WHlRUmcyQzBzd2F6Ti9McGNBVkV5NTNFS21pUHBHTEVTQ0JINTFZRTJJM0Rk?=
 =?utf-8?B?dmpMQlFVR011ZnhGcXFQR1hqUHJKSDlLSytmNm1qNVVIWXJyLzcyWUFUa2F0?=
 =?utf-8?B?RGZEZnNTTFUwd0hhV2hZbGthdlBwdkd5TjRESWcwblk1RkdRNnJWd0ZHTmRv?=
 =?utf-8?B?YmsrVzBTdUhmaUNaMjJIR1ZvRk5ZM0hFTVJpeGtuMTlBeXYveVR4Zi8vWi9W?=
 =?utf-8?B?UnRHWFp0NGNqZlV2UXROZUtSd045Q1gvalVCRlVGVkEwdHpxTEx0b3RiQlRL?=
 =?utf-8?B?ZmhBaEpYeWdtV1lMbTkya1NiS3dFenFXRThrV2k2U3RlWXl0MGc5ais4eTlX?=
 =?utf-8?B?bTV6Z0JQcTB2TDRNamdnVWpMa0hma2ZDOFhrNGVtenI4aFlVajlqOE4yMUp2?=
 =?utf-8?B?N0c4S2p3WWNwUDlOTCt5WHBKbjQ2MlRnMkJ2UWRiUnF6ZTdkdzZjT3hXZWF4?=
 =?utf-8?B?emdRa2ZkSGJjUDd3Y1MwY3MwRkRMb0xwQkd3enVuVFRrM0JTVzZlazRZQkVV?=
 =?utf-8?B?TjlzVk5IUmxPK2lLNzVBOGEzSCs5Lzh4YVc5bFIrVDdEZWVHcEJyazZkVHlm?=
 =?utf-8?B?cGdTVllhYWxtSXVnYjFKY2ZjZHd4aytVNDE4cFdnOFVJTXdBY2VTejU3U1B0?=
 =?utf-8?B?cG9nMTdvY1VmK2lteWg3VjNuUmQybDAzTUtZMjREbjBzb3pFb0JIS1FJWHpZ?=
 =?utf-8?B?L2hwZVA4TGF5UWdReGhNODlwdFE3OTFZZXYrRXNlM0hWeWV6YUZ2dlJadWpr?=
 =?utf-8?B?TFh4d1JjeEJUbTY2bGNHdVRDYnF2SThGVEtMbmlYUUI3LzFGeXVheFZxSmo2?=
 =?utf-8?B?azVoM25XYmZCQzhzL1c0dEl2d0VVNlZrRUJwQ3VRWURJOUN0ZlhaWmFTanBX?=
 =?utf-8?B?S08vRTQyWWovVjhNaHQ0WERQZmQwR0hEUFdsYUFvZ2ZOazZ3QWx4MUJhdlB5?=
 =?utf-8?B?REozc0h6cndhTm5LUmtnQ1g4RjU4VDZPWWRxS0VqNXI3alhDdDJrV2R3RzZl?=
 =?utf-8?B?TG95SVFNOHNrY1JZb0dWRDlFRDJuZHJhNVlxNFdLVHd6TFpNdUhubFdPS2NR?=
 =?utf-8?B?TVNQMWZBRTNkcXgwVlhhSzQ5b1NPZVJDbW1sY2RUUys2aVFNNVFOTjgxbUZE?=
 =?utf-8?B?dCtCNE5QcnBUUVMyV21vVERJZkdHTjcwKzlCazkrZmp2MzFoVXRtd3ViMVQw?=
 =?utf-8?B?aktGT0VTMlM3TEZTTUhPdk9LTlBaOTlKVnJ1MU5uVWtiM3FDaE1nRXpKWFhT?=
 =?utf-8?B?NldxY3hMYkk4VmlvR2E0Q1dUemc1SHluclJsQWxBMVBJRzlwR0daOW9EMTNi?=
 =?utf-8?B?N1hBWGUzenM4M0pNUTFFVGpmOXZFZGFVYnN1RXRNZlcwZzBiTnV4bmZwYjZx?=
 =?utf-8?B?cmhGWEVOTDN3OS84bnpMMVZDRmh3cGcvUll1TWMwYkJnSkVWWGlDakhRanRy?=
 =?utf-8?B?N09WY0ptbVZnTjBITDJ1dENzVTQ4WFhyaTJHbTJHbThsWHdtK1FMbWxWVFEw?=
 =?utf-8?B?eTNFYzVDY3FTTU1jd3h2RlIwMmtDdU5ZeHhUNXowSjVwdS9rMlc0ejlGekkx?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0535F264D40A3547955E9275F0B1FA63@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 589783bf-ed9a-40c5-984f-08dc051a4aa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2023 07:22:45.9312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMBOL/DzYC5Z0HydIJnjnBt6x7cI3gZgEeFsun6tJ7L2QDYs0lCtPZQqH5KfunCBGH7NLMDo3OoaBiYLhjLmCkbkOx+jHE2r1Er4skZn/i8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB5669

T24gVGh1LCAyMDIzLTEyLTIxIGF0IDE5OjA0ICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBEaXNhYmxlIG1jcSBpcnEgd2hlbiBjbG9jayBvZmYsIHRoaXMgaXMgc2FtZSBhcyBsZWdh
Y3kgbW9kZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVk
aWF0ZWsuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCA0
MQ0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGRyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLmggfCAgMSArDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQyIGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5j
IGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmMNCj4gaW5kZXggZWIxOTM0MTI2
Yzg3Li41MWYwNTAzODQwOGEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1l
ZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiBAQCAt
NjYwLDYgKzY2MCw0NSBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX3B3cl9jdHJsKHN0cnVjdCB1ZnNf
aGJhDQo+ICpoYmEsIGJvb2wgb24pDQo+ICAJfQ0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgdm9pZCB1
ZnNfbXRrX21jcV9kaXNhYmxlX2lycShzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiArew0KPiArCXN0
cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCj4gKwl1
MzIgaXJxLCBpOw0KPiArDQo+ICsJaWYgKCFpc19tY3FfZW5hYmxlZChoYmEpKQ0KPiArCQlyZXR1
cm47DQo+ICsNCj4gKwlpZiAoaG9zdC0+bWNxX25yX2ludHIgPT0gMCkNCj4gKwkJcmV0dXJuOw0K
PiArDQo+ICsJZm9yIChpID0gMDsgaSA8IGhvc3QtPm1jcV9ucl9pbnRyOyBpKyspIHsNCj4gKwkJ
aXJxID0gaG9zdC0+bWNxX2ludHJfaW5mb1tpXS5pcnE7DQo+ICsJCWRpc2FibGVfaXJxKGlycSk7
DQo+ICsJfQ0KPiArCWhvc3QtPmlzX21jcV9pbnRyX2VuYWJsZWQgPSBmYWxzZTsNCj4gK30NCj4g
Kw0KPiArc3RhdGljIHZvaWQgdWZzX210a19tY3FfZW5hYmxlX2lycShzdHJ1Y3QgdWZzX2hiYSAq
aGJhKQ0KPiArew0KPiArCXN0cnVjdCB1ZnNfbXRrX2hvc3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3Zh
cmlhbnQoaGJhKTsNCj4gKwl1MzIgaXJxLCBpOw0KPiArDQo+ICsJaWYgKCFpc19tY3FfZW5hYmxl
ZChoYmEpKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlpZiAoaG9zdC0+bWNxX25yX2ludHIgPT0g
MCkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJaWYgKGhvc3QtPmlzX21jcV9pbnRyX2VuYWJsZWQg
PT0gdHJ1ZSkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IGhvc3QtPm1j
cV9ucl9pbnRyOyBpKyspIHsNCj4gKwkJaXJxID0gaG9zdC0+bWNxX2ludHJfaW5mb1tpXS5pcnE7
DQo+ICsJCWVuYWJsZV9pcnEoaXJxKTsNCj4gKwl9DQo+ICsJaG9zdC0+aXNfbWNxX2ludHJfZW5h
YmxlZCA9IHRydWU7DQo+ICt9DQo+ICsNCj4gIC8qKg0KPiAgICogdWZzX210a19zZXR1cF9jbG9j
a3MgLSBlbmFibGVzL2Rpc2FibGUgY2xvY2tzDQo+ICAgKiBAaGJhOiBob3N0IGNvbnRyb2xsZXIg
aW5zdGFuY2UNCj4gQEAgLTcwMyw4ICs3NDIsMTAgQEAgc3RhdGljIGludCB1ZnNfbXRrX3NldHVw
X2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIG9uLA0KPiAgDQo+ICAJCWlmIChj
bGtfcHdyX29mZikNCj4gIAkJCXVmc19tdGtfcHdyX2N0cmwoaGJhLCBmYWxzZSk7DQo+ICsJCXVm
c19tdGtfbWNxX2Rpc2FibGVfaXJxKGhiYSk7DQo+ICAJfSBlbHNlIGlmIChvbiAmJiBzdGF0dXMg
PT0gUE9TVF9DSEFOR0UpIHsNCj4gIAkJdWZzX210a19wd3JfY3RybChoYmEsIHRydWUpOw0KPiAr
CQl1ZnNfbXRrX21jcV9lbmFibGVfaXJxKGhiYSk7DQo+ICAJfQ0KPiAgDQo+ICAJcmV0dXJuIHJl
dDsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmggYi9kcml2
ZXJzL3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuaA0KPiBpbmRleCBmNzZlODBkOTE3MjkuLjky
MmYxZTUxYTYwYyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
aA0KPiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oDQo+IEBAIC0xODYsNiAr
MTg2LDcgQEAgc3RydWN0IHVmc19tdGtfaG9zdCB7DQo+ICAJdTMyIGlwX3ZlcjsNCj4gIA0KPiAg
CWJvb2wgbWNxX3NldF9pbnRyOw0KPiArCWJvb2wgaXNfbWNxX2ludHJfZW5hYmxlZDsNCj4gIAlp
bnQgbWNxX25yX2ludHI7DQo+ICAJc3RydWN0IHVmc19tdGtfbWNxX2ludHJfaW5mbyBtY3FfaW50
cl9pbmZvW1VGU0hDRF9NQVhfUV9OUl07DQo+ICB9Ow0KDQpSZXZpZXdlZC1ieTogQ2h1bi1IdW5n
IFd1IDxjaHVuLWh1bmcud3VAbWVkaWF0ZWsuY29tPg0KDQpDaHVuLUh1bmcNCg==
