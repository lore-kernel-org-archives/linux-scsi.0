Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CD414B09F;
	Tue, 20 Aug 2024 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724133518; cv=fail; b=FaRWoqGtY7u7ltldRzACSGGB7mu0OST2+WsR0p8yUGijnEYX+Y5BaYRukEK5xCq2/sxWFHUdkjDY821b3OZvmNtM0TNhUmVJvoIa4Kjdi7/Sl2e3NJ2vFyICKu3yYaenOmwrHZy40CYOg8ZAJS0h1ClNJD+LsexdhwS1zczCmog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724133518; c=relaxed/simple;
	bh=WrLfxUZ2nDqqXev/NcElthBYP8+WSWdg1lGZcG/3PjU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a1c8K+6c0mIeDv/U67QPtIXRhG4b7yTf9d9YDTq26vHppJJmbBzAZ6ze5ZPPqL0s9aUnLeGLL7hhlQl0DKnhlPDGv3dgD27IyzWtMKekwWIQ9f3WactVD3xr8pP18w3zb0h9K8V6olPweL/QUx0/2Aq5Ni3l1AE8AKU3GW8MfZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bIwM+m30; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ab+wjnwy; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bIwM+m30";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ab+wjnwy"
X-UUID: 368a38a85eb911ef8593d301e5c8a9c0-20240820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WrLfxUZ2nDqqXev/NcElthBYP8+WSWdg1lGZcG/3PjU=;
	b=bIwM+m30hHn1FM5hM3d/vNBYoqcT6u/SRnAsJ1Gk7MRXR0psR+nJsg3ky9qJdFuSZh1n4n+/jOFY4WHdzvWT5TGctrysFpK6nUdh47tH83nQtfNa0Fskxnv345AP0uReWjrWIsFWmfhvu3g/YjqGLVwetC9WzmDPwcra0XAICWY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:d3b7c77b-af41-46d7-91e2-69e679054b2d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:fbd2b85b-248b-45cb-bde8-d789f49f4e1e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 368a38a85eb911ef8593d301e5c8a9c0-20240820
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 218582160; Tue, 20 Aug 2024 13:58:24 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Aug 2024 13:58:26 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 20 Aug 2024 13:58:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3m3cGXKGh9QH+byiLuIpZgCxea0bKnX9xh63PLMdw5vN8Ob51qz/DMJ35PxpZbVE7wNj8jZFi6TVy96rzq+j9fU55qfrPFmPWExJ62bB4UuROcCctN+mSdAY81X/POLXpi34YlKufGgKD7sgMVFe6hiTQUPYTZGZLIxE9NfTcipEBOTZ0Y9suv/whrTw0XZpKNGiAMcT679vbyrD6kwwjg4zVdYWWXacFOmmRODxLZa4fhGwVF6APzFB9ERs9W1n0Yu8uceb4Eg2qmdGRojlbLQkXUMnqySBxPebstJmit/1nDbwWYhq5o9Dw2QJH+hFkR5jbyp1o/e3DHxUTK+4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WrLfxUZ2nDqqXev/NcElthBYP8+WSWdg1lGZcG/3PjU=;
 b=nrGoCaeiAAKhZG0OzWV58MAp09rs3FlXZ3Cb7M8L9gfH3m5kuezmwdBiOrKjSh44/IzWdb2IQfUXfNpi6W7xvuoeIeScQmzLERdFsHFc2MqqPwjczTa/8YwTKFaXsKrZKLU5u+1TzraWDpnjZIWk5qo+4l8k7CKzZuz8V7HJxZP5xtOZRebkm6BbUX1d66Rz/VFV4tP4JRNnUQQIlt3RJ0UWJdMe3CXZWUxfGO1DaRC8JQtAiYmt9Uoc8fShf4Cq2CKrrIeX2t35ZSeJLJocOap/F/gs0Xhqg2ZmYh3+RESI9elqc8McOD0tij0e5PeVAZJ2NzcFvnsxp+9lJZ/7zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrLfxUZ2nDqqXev/NcElthBYP8+WSWdg1lGZcG/3PjU=;
 b=ab+wjnwy24Sq5vIbuFO/8kWdXz+/v4+umDIZrSpGCLsqxf9y9uSI0q6R1WerL73rgX1PawT5BLswvoDaSZ0fj3y/osG5PZIJDy03RmhnSSbLRab6ZqZAIDI1RWv2Bsi+fieM2AEPe64cnpgJckykqh5OQvWbUw+n85IDcd3LYLs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OS8PR03MB8825.apcprd03.prod.outlook.com (2603:1096:604:289::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 20 Aug
 2024 05:58:24 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7875.019; Tue, 20 Aug 2024
 05:58:24 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "mary@mary.zone" <mary@mary.zone>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Thread-Topic: [PATCH 1/1] scsi: ufs-mediatek: Add
 UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Thread-Index: AQHa8b2XhFsZSWSo6UWUT/pmOicOc7IvqHOA
Date: Tue, 20 Aug 2024 05:58:24 +0000
Message-ID: <9eaebd6bf66231ce3f1a450d120fb1a3188ad2a8.camel@mediatek.com>
References: <20240818222442.44990-2-mary@mary.zone>
	 <20240818222442.44990-3-mary@mary.zone>
In-Reply-To: <20240818222442.44990-3-mary@mary.zone>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OS8PR03MB8825:EE_
x-ms-office365-filtering-correlation-id: 38e891c8-c1b7-4755-c429-08dcc0dd1a51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z1R0Zy9GVStOR1IvYS9nS3ZJOVNsQkJkc0RUekFZQzRVSzhwZXFHUUFFWlhx?=
 =?utf-8?B?MjdUMCs0KzZTSlYwc2VlVEZVWUc3ZTFXaVNNSHEvNkp3UEVWSU5mSlRXY2gv?=
 =?utf-8?B?Y0hFb0EwOVI3c0dmYWhDZHpFVmNRTHNVemxVM3NmSnV0QS96aTFEb0VwTGdY?=
 =?utf-8?B?NGNZQWFDaVlsM01ZdEQxbnNMSGNYMlRRbjc4Qjk2QU1RWW0vMUkyaU5nYVEw?=
 =?utf-8?B?NENlUWRsTVhvMmorOU5vUFhGZFFPWTFub2tYVGN0eVRySnFDRE9zSXJGZ2kr?=
 =?utf-8?B?UEVWOVpXbGNIRWR6UWFTUkZMZ3M1eGh5ZHUzRklHRmpSOUVBRFl1eGlRcHAr?=
 =?utf-8?B?RGZKaXlpVnVnUmhrQktDemtmL25yM0hpdk9PNnIrWGlqQUYwTHdlUHQ4bEFy?=
 =?utf-8?B?R2xwR0VIZGJoM3VEQ1JvTm9OOVBtM3VQdmZleGRyVndlNUpXbUZRaGZpTUFG?=
 =?utf-8?B?alBObjllUEF1YUF6OFl3WU1HR1N6LzdwMloxWFJsMHN4SzliR2REMmZWNlUx?=
 =?utf-8?B?T20yeDZObkFCSE5vUjlRdjB4YU5VdnVZNVdmZGFubU9UQlI5anp4NE5sSEJl?=
 =?utf-8?B?K1QxOFRGWlVDUHZadWYwRHJvQmxXQVVNQVJqQUloQVVEZWhlS1FuNjRVaHhD?=
 =?utf-8?B?UVhNcWpuRE1sczNUZVh0YmQvTmZoSkhEYmN2cTNuYmV4elBZRTNqMDcySGl5?=
 =?utf-8?B?Y0xMbWhxN3daTndSUDhJdjRITG1IeVNTM0ZIV295MDdsK3JGemFBcE42OUYv?=
 =?utf-8?B?ejZPZ0ZuMVpjOTQ3M0RwNXE1TjBKUHlUcnF3RkVnNFBSZnYrTlhWMk1ScXV0?=
 =?utf-8?B?QTNMVCtKOExnNUt1aHJNajQ0WjVKNW4reDk1MVE4NjR6cHI1b0FuUU5sVGdv?=
 =?utf-8?B?TjRrSFQ2cGxoOXJGbUFvcHlnNTJsc2lxQ09oeks1SnpsOE9hMlJnNEs5UTVw?=
 =?utf-8?B?SnZ4cXFhKzI1T0tLYSsvOEo3emtVa3VQSk56dWJWYmdCR1JsSGhmUDFvdWpj?=
 =?utf-8?B?a2l3UHFSTXVoYnQwQ1oxczRFL09lSnEyN0p6WHpUcEsySHZxbEVQK0ZKUFkv?=
 =?utf-8?B?WG1iazBSb2ZIRGs5Mm52RW1vMFBYQk1zSzF0VE1wUXVISlpMV1RqNmNxWXBq?=
 =?utf-8?B?ekE2S2wva0dmZFJLN2RoU1AyZ2FhODRRSG9vUHNOZUpKQ1RLcWI3M1pUOXJG?=
 =?utf-8?B?QjUreVRublk2d2JSd3JzQVlqaFF6R21hN016aTQ4dGJCZzdkcGJoNm9HR1Zm?=
 =?utf-8?B?OWZuODhnQi9oS2lyL1IwSTl2ZTRWeHJ6N0FoK1BoNUw4RjFrRHlXUjkxTWQw?=
 =?utf-8?B?eVc4UGhxNUJ2aUdyZUlWOXdzVW8rc1dEeXU3VVJGMXBpTjdhdlZnZXBtdlJH?=
 =?utf-8?B?U1c0cTE2Vis4emhRMGtlbERlNVhDRUVsYnY1ckN5NTIzMHpLblZxYXZEc2Rq?=
 =?utf-8?B?ZFhHcWdmQm9ZWGtjMnVyNGdhVTBXWmtPUHoycTdRU2dmVEZRWjBxYnpCK25v?=
 =?utf-8?B?cHBtN2sxQ3IvS3pibnltVTdTUW5ScmlicllaTUJGQXFhMnk3Y20wZkRNOE1j?=
 =?utf-8?B?Kzk4aDA4WEtBUEd0eWd5SitjWTRaZUlQRnd6alNvMmZYb09ENTF5L0owVSt2?=
 =?utf-8?B?V24rMGwrS2U4WHM0aGl6dFMvRnprSzZQaDljanBUelpXbzBsRzg1cTY1bGh0?=
 =?utf-8?B?N1JlVmlremkzL1k5Sm91bVFLL3ZkNVBTd2NsL0VuSElFYXIwWE1VUVM0eDRs?=
 =?utf-8?B?Vmswa2toWkRKWEsxNFQzYXcxblh6VDk0K0o4NkVEMklEMUhlaE4rbFZQdTIx?=
 =?utf-8?B?ZDVadG8wZko4VmJubXpmRHY5UGNRQk1TMG5VbEtMMGxWQTNiekl4c2NNYXlD?=
 =?utf-8?B?cE0vNUthczVkaG1WY1VQaHNQend6aDZBZ1pDOUYzazBvWkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ckJPRlRTNUhwRjg3MW5tM01sN2hGRm9NeXpGZ1pjMmVLWmNWTGg5TVdWOWxQ?=
 =?utf-8?B?anplS2tic3AyTVpZT1l3dU9lVm9JZHNEdXR6UVF2SEI1N2dkMnVGL0ZaZzBX?=
 =?utf-8?B?T2ExZ0JMMmQvaTg2RDZFQjU5cW1LQmxGTHVtYk9zcSt4ZXorSGNFQ2o5cEt2?=
 =?utf-8?B?L1ZkVnV5SHNDTUVqZkh3K3BJOWx6N0crWFlpaXVSMExlNDlFa2Q2MkJRaEY3?=
 =?utf-8?B?M1ArY0dQZS9weFU4YUNlTG1YZzRPUm5xWGxabGhVTTMrUmd3UGZEUy9Bc2hT?=
 =?utf-8?B?dG5WZFd2MjIxQ20zQ3pya29WK3RZaEFHMUw0S3l0L3c5bnJkVE02aEp5QkdB?=
 =?utf-8?B?UU11ZVJDeU4yak1jOWNwZktNN1Jad1cwcVdrcHZxYktCOHovcG5LZnFFblA1?=
 =?utf-8?B?aE4yVWR2VXVrdDJGRXlLVXA4S1hXdUV1d3h6aTdISkVuTmttVzB3dEdpazk5?=
 =?utf-8?B?czlNdW5ubTZZTVhkSnFObmdmQkkyNGlHMWFqK0VXVEhJMXNNMzM1WlJyN2dQ?=
 =?utf-8?B?d2k3V0g3TlFQZnMwZUlQOVRSV3BhMzZWSG5yMG9Ubk9ZZkN2VGhFWW5YTW5S?=
 =?utf-8?B?Vm9heDI4ekhDZUozaCtIR096MTVRUXA1aGNSQUxkaFpOUDFDcmJlRWZOZFNU?=
 =?utf-8?B?dUlrVTdDalFLOW5US1BqZkZjcWNRVi9MSVdoMDEwZlFUYkdUTVlyeWY5bVVR?=
 =?utf-8?B?NW9mMXFSN21qL2ZSM1VCa2RMSWNCalU4ZkFleS9aYXhCVlVuckIyMlZHc0p5?=
 =?utf-8?B?WmdIaVpvcFdjQTY4b2d1U1FXRFlTRmZPRUs1MW0zbGpGbTJwMUlFQmFxR3NV?=
 =?utf-8?B?TlUwa0RlRTJUR2trWFJMbzYzVlJkS2p2OU4zQUs0L0dYb2tXOFRNTmlnUk5q?=
 =?utf-8?B?TU5Lam1QMnl1RWh4NjJvalltdXlNUm1rWTZZN0NZTkpJT2NuUjRPWDlud0FS?=
 =?utf-8?B?OWw1MThOUHdCdFdaQ3BVZXJZb0JxQ29xSkFiTEViaVYrTmJucmNtaGQ4VDVj?=
 =?utf-8?B?VWRvdzJXcysxaUNsOG13a2ZmZUI1K1hucThFTllQQXIwYWdHYldJWkwrc0dr?=
 =?utf-8?B?bkl5TmsyK1d4V0x4dENBMVJDZERyYVRyV1QxS3d1bUFTOENXY3o5RS8xS3VG?=
 =?utf-8?B?azZZQ3ZCWVB6WHgrOHdRMEhQYjNZOEZ1RWVCWi9HREVlSjByNjlMYlpocTFp?=
 =?utf-8?B?dEpJbkVxWktXc0tYa04zSVIyc3dUbkpWanVMTExscnJGS3JQRWl3c2tjOEJW?=
 =?utf-8?B?TFJxaWZpOHJoS3FzWkcyMTNPVHRkNFBzMlhIajkvTDB3bXRvVWtSenNSaVMr?=
 =?utf-8?B?TnRlc2VNSGlMQ3dHWXBYd0o2L081blpqcmlHMXNSOHA1TEc5VHd3OTZhU2dm?=
 =?utf-8?B?Tm1sM2RUcFZ3c0F3UUFvUGFUZGJPc00rYmMrNEtQajF0UHlqeU9NeU1qcnlp?=
 =?utf-8?B?RTBIUDdrbmlTQ2JSZWN4V1FzMlU5Ym41MWhENkJpNmFPYmh0eXhwQzFEL2Na?=
 =?utf-8?B?S3FPT29MZTdJM3lpV295NmZYN3dsd00rclFVcVIxSjFaQ1Z5cXJBYlB6cUND?=
 =?utf-8?B?TU02UFRWeXRjWTlvVTlsc3g1VjZ1bmYwak9JZGlLOFRKWU56bThmdjFFeTBG?=
 =?utf-8?B?d0krYnJuNExxVldva0p2RFZDZEZNc0twRVptSGJTUXBOVUhaNDlrS3ZvaTBJ?=
 =?utf-8?B?djRqNWRUTXQ5c1J2RGMxcFZqRjlGZHdJbVNEcG51R01GQkgrWjIxRk5MTEhP?=
 =?utf-8?B?NWJOK0pHdDlNWTAxcDArUXFBRVFkNmRIZFJERW9TaSs2QTAzcmhuMkM5OUpa?=
 =?utf-8?B?V29MV3FYcGxMRnVrZDJ4WlQ5eGtKRUJ5TW1MOEkwUURiZzFmR2hEMUdIbDZK?=
 =?utf-8?B?emZmbXY1L1hUakJFMHlEVWYzek5pK2dEeWNMWXpMN05WdHo3V0hDdjRmYkcz?=
 =?utf-8?B?T0t1Yng5bXFGUElvbVdENDF4d3JCUnJvUmdPbU4rZFBQa0tPeUQ5SXczTENv?=
 =?utf-8?B?WWQzUDdjNkZBWjJWZXd4WTJ3ZVI0ZmFXZEpHeXJBeUNyeVpySm5RZytrY2dS?=
 =?utf-8?B?eDBwZm9pamJWZnRjcExQTmxHWVVMbXlLMVBWWGNWYi9tdlVJVjJhL3FGL2hI?=
 =?utf-8?B?UVhlZ1BScXdrUURSVlBLTmZKbTJlVWRncGJzdXJXby9NVko1dGxNRlBxOHZ2?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BF062B77C93884A94655A11267BC1E5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e891c8-c1b7-4755-c429-08dcc0dd1a51
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2024 05:58:24.1417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kIlDrlZttRDWInmod1jlRDYDAfZ1PL06qvQ7bU42Wl7i+eM5+869xu6CdqnRtBMtVXr11lVRUs5MVReBXIZ8EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS8PR03MB8825
X-MTK: N

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDAwOjI0ICswMjAwLCBNYXJ5IEd1aWxsZW1hcmQgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTVQ4MTgzIHN1cHBvcnRzIFVGU0hDSSAyLjEgc3BlYywgYnV0IHJl
cG9ydCBhIGJvZ3VzIHZhbHVlIG9mIDEgaW4NCj4gdGhlDQo+IHJlc2VydmVkIHBhcnQgZm9yIHRo
ZSBMZWdhY3kgU2luZ2xlIERvb3JiZWxsIFN1cHBvcnQgKExTREJTKQ0KPiBjYXBhYmlsaXR5Lg0K
PiANCj4gVGhpcyBzZXQgVUZTSENEX1FVSVJLX0JST0tFTl9MU0RCU19DQVAgd2hlbiBNQ1Egc3Vw
cG9ydCBpcyBleHBsaWNpdGx5DQo+IGRpc2FibGVkLCBhbGxvd2luZyB0aGUgZGV2aWNlIHRvIGJl
IHByb3Blcmx5IHJlZ2lzdGVyZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJ5IEd1aWxsZW1h
cmQgPG1hcnlAbWFyeS56b25lPg0KPiAtLS0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlh
dGVrLmMgfCAzICsrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJzL3Vm
cy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCAwMmM5MDY0Mjg0ZTEuLjlhNTkxOTQz
NGM0ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiAr
KysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC0xMDI2LDYgKzEwMjYs
OSBAQCBzdGF0aWMgaW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgCWlm
IChob3N0LT5jYXBzICYgVUZTX01US19DQVBfRElTQUJMRV9BSDgpDQo+ICAJCWhiYS0+Y2FwcyB8
PSBVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FUSU5HOw0KPiAgDQo+ICsJaWYgKGhvc3Qt
PmNhcHMgJiBVRlNfTVRLX0NBUF9ESVNBQkxFX01DUSkNCj4gKwkJaGJhLT5xdWlya3MgfD0gVUZT
SENEX1FVSVJLX0JST0tFTl9MU0RCU19DQVA7DQo+ICsNCj4gIAl1ZnNfbXRrX2luaXRfY2xvY2tz
KGhiYSk7DQo+ICANCj4gIAkvKg0KPiAtLSANCj4gMi40Ni4wDQoNCg0KUmV2aWV3ZWQtYnk6IFBl
dGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
