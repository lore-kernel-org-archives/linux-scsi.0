Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB938F83
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 13:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LBHrXuWO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="QcI/Er24"
X-UUID: a95fc2d2aeef11eea2298b7352fd921d-20240109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YvOcBZqhebicdLovLTy2BP0cs4P6+brHIKz7pjwaaBg=;
	b=LBHrXuWOAydtdzoc7lSVL2gTh04FvyC/r9U/4obDDlYNRjxBwpt27V9EqSVmVuHlUxKCLIfa7mV8Mwd5SGIm4durXtVoHgthDz0LWp6O1XQDDmHgNcq9EIv8NUrv0yeeyma/5/f9VmkGNfd9gD+imZZoBIayx31RETyljA2hADY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:9a98c060-e9c1-4c0c-95c9-b5f876f0a7c2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:0966a882-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:817|102,TC:nil,Content:0,EDM:-3,IP:n
	il,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR
	:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 1,FCT|NGT
X-CID-BAS: 1,FCT|NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a95fc2d2aeef11eea2298b7352fd921d-20240109
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 812746416; Tue, 09 Jan 2024 21:04:45 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 Jan 2024 21:04:44 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 9 Jan 2024 21:04:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu0AEqbaZaM4V3Jm0QN+HxWBriFXqr43LhEgXPAaKEgPhPsS0NP/KtUxJNIbdmMm5Fsm6MEmG1TAIIHKlG2+hTROtB+QQAAlhMbfkqBmoQz8M0HIoqApbO+Lca2URX5fOCmn8uIUNX57rZ66TKjBuVrf+txejKo6q4mCY+X51uH6QfPyNVjkWmytqD4ALnGHNYZ7GK9SJ+TqxFrecPt7Zqd0/ouyODO7DRlHJY++v9raL3AEzYp0FTDAPREYO8WCRQYZG9H78AthnpjAri+OSWAM3labFVIqpLdnIzqJlRSFlbIegxQ3j5wBdRWir8C/UsDPNTx5lL/ax9XTgxmSYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvOcBZqhebicdLovLTy2BP0cs4P6+brHIKz7pjwaaBg=;
 b=dixwvgdzax/Yc//pOIBQRfeU/kMKxIceDAikCPEdO1mkEnHcY7SNPP1p4uJIquPGmZf/2E4Z35PBS0q0PDspXY6ipuoRamluT9vIakEbMACZ1cD0fS0MdkReH7QWrk+EcVrbvyBrMsiSnm7dbTMPFXjQozKeEF/tmYOOwsJRf6l9gjqSDzC3Ym2z3nN/meNrGOJkAijKPwsHXunDqm36mKgdpzWmgpmIWfRkdD9tIuSHlY5OS57c0cIvwvvin2UQqCSBQdmju6NEncd42pzZ/+AYvWb6LVztJAxrkhoQ7srtCwySoSONuLfSxzBcMroOTjTfBuvdEtTQ1xu5uWhfdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YvOcBZqhebicdLovLTy2BP0cs4P6+brHIKz7pjwaaBg=;
 b=QcI/Er249JfqP264HDQWMi6yPSXXbUcEnFksBkRKD6A2N4t9lXQv7aGnQ8LOqzzp+Pw5i9VmmqqKIHKA0fULlH+IUExxst7IHvZ3l1Z9atn1ZviXJV2e+2YeKxt0ggFcSpKWMrFw4uq9zum41o/b92DtbNXyP4Wg3vcsgA9PUXo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8787.apcprd03.prod.outlook.com (2603:1096:405:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Tue, 9 Jan
 2024 13:04:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2191:6368:fa92:8dd7]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::2191:6368:fa92:8dd7%4]) with mapi id 15.20.7159.020; Tue, 9 Jan 2024
 13:04:41 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>
Subject: Re: [PATCH v3 79/80] scsi: ufs: Declare SCSI host template const
Thread-Topic: [PATCH v3 79/80] scsi: ufs: Declare SCSI host template const
Thread-Index: AQHaPvK5Q+ZsexHxP0yL3b0RbOoldLDJaXWAgAbOVoCAAUMeAA==
Date: Tue, 9 Jan 2024 13:04:41 +0000
Message-ID: <3280413014268a33a964bab98102eb2640e6e21f.camel@mediatek.com>
References: <20230322195515.1267197-1-bvanassche@acm.org>
	 <20230322195515.1267197-80-bvanassche@acm.org>
	 <543800c0b840ac1fd2943b1bc1fe909937be3e68.camel@mediatek.com>
	 <f5dc9add-4995-4a55-ace0-b091569f0f76@acm.org>
In-Reply-To: <f5dc9add-4995-4a55-ace0-b091569f0f76@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8787:EE_
x-ms-office365-filtering-correlation-id: a7ecee5b-5363-49a7-096e-08dc11138b35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P2Z0hVv9jnQrDisD19H5Hu2WqwXh6+fcwmY8li2Czws4+OE+cBpp/ucNS8f3z+XcBHguZPiMfqqa9Q7HQ1krluQCe4s8ENLchX4HurqTEEbBsvVl/pachlrMzGAN/QWM5V2gwRug0DSbvW2dCMsmEdK3mTNAHV11KNqHdIEGuj1FO7m42TSn+R8Yyj0U+E4VD7O9d8VYDMcNPfSG4k4isLW79x289hDUAWSWkdCBv4YJY1OhiDC7GCfBtRrIUZmkeW8fLu5vS1Bte4FT+ybekWYTUXvJqAGd4oSpyDos88eqQYOnZv6A01eEUSwt9mRWAnAtAKnw1APVfiaUf9Wce6t7PpbyoOR0jJ5/tYUyU9WacMMvTTEHdi4iUlZTT/2dn3qv/HY3j0/0CH2iuAQbqhSD0IdiFRCVV7AE6dsgSXfF2FONUF/dxogxFLjKU/4K+aMSIiYV8hjpJidP5ve5QE1TPTjNnCvAFOhBa9RimRNhanvY+rmkCW54JDkIgynSm9QyItD3ShzRmz/2SeGHBZsAw1Gwa0Vkqqrx8bwy4AHIwz9vkgGN4KGT/wD8ht7eq3fZxT8alfXSPmkczbdVsYjCRs1gRIwvsfDqEE7S8uqXZV8/tNAoxyw1Kj3yVEllai9rSNVLDAmYqyN60+2kv3iCkS0de+3CFigzJLWQpBIVcdNQ+tmidAz3MqitVHLS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(346002)(39860400002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(83380400001)(66946007)(41300700001)(91956017)(76116006)(86362001)(36756003)(38070700009)(85182001)(122000001)(38100700002)(26005)(2616005)(107886003)(6512007)(6506007)(6486002)(64756008)(2906002)(66446008)(110136005)(66556008)(66476007)(316002)(478600001)(71200400001)(54906003)(8936002)(8676002)(4326008)(5660300002)(4744005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czF1L0hpR3F4OGRjNjZ0c0ltamRwekc4bEJJN25YZ0Y5b0JmWS9DakRFZFg5?=
 =?utf-8?B?WDNlaDR3RSsxc01yWk9xWEZSUU03UXBSM2JWbGp5SXo4aDQweEp1QUhJSlVG?=
 =?utf-8?B?YXc1d0NSZ3VmUWhINExsazM5eFpkU2ZQck5VN2dyVXNxbG82RFo1MFFZYlV4?=
 =?utf-8?B?eDRBa1NEdllKOVpHN0dtYmZkTGtSQ0RyWHkzNERzTHVwY0tXVERwSG1XbjJj?=
 =?utf-8?B?WlJSRXFWdWNsdUN2ODd2YlFubnRlQXpmMjltVnRRVVVYSnBHSDc1K1hkaFlM?=
 =?utf-8?B?blNSelZFNGhjYmpILzdYc2tmL0pEek53VGd5WW9xaXZSL3lwdGFYYXNxbXo3?=
 =?utf-8?B?bytTZWs2ZjY5M2dXM1RFTlZ2b0JKZTFScVJjUUx2RnU0TWFSbmE4cSsxTnQr?=
 =?utf-8?B?eDUxa0dlWE42VUc5V3d6dVNNODZEanErR2dLN2VRdC9WeFBnampRMmtwemNC?=
 =?utf-8?B?VEJRMks3REM4ZHlTemlVTjlrUkxlRVdZNnM2QUQ5MGd2MGNxK1o3Q09FYmwx?=
 =?utf-8?B?SHVhQTRxR1l2eGRWUEtKWGZMdnRHOE1MU1Zzb3E1Z091WmNJL1hZa0wyN21a?=
 =?utf-8?B?bmEwQ0xjbUFVMzNJWVBuSVJIVjBBRFY2dW9rbmxQVUxJdS9XdlpEdEtKUjRH?=
 =?utf-8?B?QmQ2cDFtSjJIbzZta3pmUXhSNnJIYnVRcCtxalcxYThGb1gwZlZHNlRRd3VO?=
 =?utf-8?B?SEd6Z2FXR29qbmV1T0RjeFd2c3VNRWpTVTZjcVVaaXhLSXBJS2FRUTluTEpI?=
 =?utf-8?B?WmIrQy8wL1JMTXBZT1VNcnVrdDBCVEpZN1BEcVJDeWdYQUVaVUtOVW5semNN?=
 =?utf-8?B?WUw5TG5OS3MxVE5qbE1UOHc1U2RJMXlHT0VLY1NvZU9KYlcvbWtLY3d6QjJl?=
 =?utf-8?B?N1NjQjU0THNYT0RjZnBOYmFlUU5QMnBGaE1SNG1HL2VtbGZzZWxrMjVLODkr?=
 =?utf-8?B?V05UT0RXYk4zQ0trYUZvbkloSEI5dXIzVisrd0JadVNDbXRZQXNidGloay91?=
 =?utf-8?B?UldVa2lGOFIzSFZkSUQ0eXNTTGJONUhvLzFVUUJzSXVUcnFnQlpVNklTZVls?=
 =?utf-8?B?ZEtpbDJpVFdWLzF3ZHZURGtzczdsWHdVdHdLWWx5c1ZTZ2xwREFFc0xTb2xK?=
 =?utf-8?B?L21LYWc1ckgrRG5HeXZYRFoyaE5oSUc5NmNJRHNRMS9KSk9UWTQ2RDZGUTEy?=
 =?utf-8?B?eXpwdURkSFN4WmxqdjYxNkhOWVhvZitDODRueE0rZHFEakRPeHUzNWZHcjRP?=
 =?utf-8?B?cVdEcnM0YzlVbnBnTjN5TnpmWlE3NHAzak9zSDFySlczTTVscHRySVh5OUZU?=
 =?utf-8?B?SGhNTThrSFdNclRxeFpocFpsYmk3UUxZSXRHdzQ5MEFvZHVJSXprSk9Tb0dI?=
 =?utf-8?B?OW9oNWFFcDVpRVpmcDQ5L0dEOHJpNmZFLzltN3gxaUZNTFUydkQ4ZmFBWWdS?=
 =?utf-8?B?eW5rVTVkTmVKWkJ1aVZac3FsRE5SeG55cUJ1U3pVa0J1QTFXSjcvMmZnU3Ns?=
 =?utf-8?B?THhMZ0FDUXVsU3ZhWUc4L21UazIyTHF3dXZuMEtuY0pDMzFzdk9hMmE2NlF2?=
 =?utf-8?B?LzFmZW8yR1VRcG13SktaOHNXUzhLQ3pPa0FPQ29MbW9IanhPY2tDQW90cUFE?=
 =?utf-8?B?djM3d0NsQnRPbWQ4S1h4NlVNSU9Sc3UweTdjdk9DQmdBQ1IwaDdUTElkanl6?=
 =?utf-8?B?THJyazc5ZFZGelc1a3E3S080NDFOZHloTjJpWU1RdkpUVGU4N2M0Vno1bExI?=
 =?utf-8?B?V3Y2V2ppVERGZHhNSXQyMjRjdng0SlZZa045TENjdHZGcUp3MWFwLytXbUo3?=
 =?utf-8?B?NWc1V0Z6QTFqOUZrRjZpOSt6aTZkTzdETnh0WXQ3bWd2U3VaTGkxUmdCeXMv?=
 =?utf-8?B?b29yTVN2bmhzSlpXV29pdmVwM2NtY2xNVWRHQ29wWXpyUVRpY05Xb1h6dkhW?=
 =?utf-8?B?UzZCL01CZVpSb01CdzVOei9yTy9JblRKdmdmbDB0UCtEY2pLUDQzb1VxajUv?=
 =?utf-8?B?cWxLY1Vyc0doMUdlZEJaeFRvbUxBSVFYZDc3dWJIWmZxMHBKVzNmZnV1L1JD?=
 =?utf-8?B?cXdWdnR2NENjVzErTEJrblBnNmdxRGVaYnBUaS9JMzdLUzlxWjE5T2V4YTA1?=
 =?utf-8?B?UGRSWjl2MGhkejE0WGFoTWZyZndBaEZmdjBiNisvaGxjTjV2Zm83SDdGa1I4?=
 =?utf-8?B?Z1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F7DF096C19BC640B3E89B3CD0F10EB5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ecee5b-5363-49a7-096e-08dc11138b35
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2024 13:04:41.6817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZP9VcDumyUeo+fV2R7sdp8amanwc/O2tEQM5BmY5JJqOsuc4Ny7okOqwxkfKmfwz61FicdMRHW5T69Lo3Qf9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8787
X-MTK: N

IA0KPiA+IEhpIEJhcnQsDQo+ID4gDQo+ID4gVGhpcyBwYXRjaCBjaGFuZ2Ugc2NzaV9ob3N0X3Rl
bXBsZXRlIHRvIGNvbnN0Lg0KPiA+IElmIG1lZGlhdGVrIGhvc3Qgd2FudCB0byBtb2RpZnkgZGVh
dWx0IHJwbV9hdXRvc3VzcGVuZF9kZWxheSB0aW1lciwNCj4gPiBjb3VsZCB5b3UgaGF2ZSBhbnkg
c3VnZ2VzdGlvbnM/DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IFBsZWFzZSBhZGQgYSBuZXcgcnBt
X2F1dG9zdXNwZW5kX2RlbGF5IG1lbWJlciB0byBzdHJ1Y3QgU2NzaV9Ib3N0IGFuZA0KPiBhZGQg
Y29kZQ0KPiBpbiBzY3NpX2hvc3RfYWxsb2MoKSBmb3IgY29weWluZyB0aGF0IG1lbWJlciBmcm9t
IHRoZSBob3N0IHRlbXBsYXRlDQo+IGludG8gc3RydWN0DQo+IFNjc2lfSG9zdC4gQW4gZXhhbXBs
ZSBpcyBhdmFpbGFibGUgaW4gY29tbWl0IGIxMjViYjk5NTU5ZS4NCj4gDQo+IEJhcnQuDQoNCkhp
IEJhcnQsDQoNCkkgYWRkIHJwbV9hdXRvc3VzcGVuZF9kZWxheSBtZW1iZXIgdG8gc3RydWN0IFNj
c2lfSG9zdCBhbmQgbWFrZSBpdCBtb3JlDQpzaW1wbGUgdG8gbW9kaWZ5IHZhbHVlLCBwbGVhc2Ug
aGF2ZSBhIHJldmlldyBmb3IgaXQuDQoNClRoYW5rcy4NClBldGVyDQoNCg==
