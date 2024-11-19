Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BCB1531DB;
	Tue, 19 Nov 2024 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731998459; cv=fail; b=Ary9QsnSaUnPkgSC3kiymik9KyjD6sq7WAy3KpHqlF0Kh4nmMZJup2niUrNjefV3Q6FAjckq+pUHTq9LSkl+jwTVGg81TECuAkTg26lkue8Y/4la3dOqevsVFWBxzdifCP4mWle7YuT6LJyUqMlvhChDDslmBeDbng0xadwjkM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731998459; c=relaxed/simple;
	bh=rsFcKHAaGO1wHpj3GmDKDRkvfJ7DSTKbjqulDkTQxiw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G/rl+qUTDNmoheh0x/vVT8pBMoXaPCyK/W2abfifPlNOwjfj9u1hdg2g2U6xC4Knu4R2sdssHzptiEhw6kr9ISzXyoC2ONP5RH557hb19eQljOc/kG5smf0756kbmFstxyn2/bgcP79Ec13ANFCY23Dr+0qZiiK3v2vXe/MjMsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qSHlj94k; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ka0mdLd9; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qSHlj94k";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ka0mdLd9"
X-UUID: 37453412a64111efbd192953cf12861f-20241119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=rsFcKHAaGO1wHpj3GmDKDRkvfJ7DSTKbjqulDkTQxiw=;
	b=qSHlj94kt1A5YZ7JLuv+f2nuAHKloeRgqZPB7ubyAzrBdLXY789OMWJNgZpsLz2gW1tFfjD7O0tyYE7f4a/rfmW2UksyiHNheoJx+IakE8rSYJKcQ2xGV8VNJH11iRVk3THlnaj2IFhRIs8L1DiPBOBFtuDG1Unpiz/6VZxYwWA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.44,REQID:b067b8fe-9f88-4da0-99a1-2ede31a556c6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:464815b,CLOUDID:423cde5c-f18b-4d56-b49c-93279ee09144,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 37453412a64111efbd192953cf12861f-20241119
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1982974064; Tue, 19 Nov 2024 14:40:50 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 19 Nov 2024 14:40:48 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 19 Nov 2024 14:40:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVVyHUsSriQrrVbH3QwHdkDXR5wuZ/qXg7AK3s3ia1Sim69IijVGz04NEuRtu2QcxOMNon+dWYBdUBwdUKwe1P4uw8rBdtPe7wESK1vJML2fvQ+MssXIB5qzP8VLalMH2D1ELbleritfEENnrA4J7XPfKBe9Td/ckw9jSVU5rQc/0ZZWfxEJx1qBk5q/eF5lFPvgh87qKgTWMlTViXGnNMbsPgLj0JVNvHsILKy0WyP6+Cp/FOIrTbyRjAEmPC00Y6yrdlOi2DbB5I3g710jn9Y1pY36YCB8Tz5AI2K97dzcaV1G1tilI+44WNYP4HyCstqsOdhwvWKHiC5aNpxlWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rsFcKHAaGO1wHpj3GmDKDRkvfJ7DSTKbjqulDkTQxiw=;
 b=us8dVsMDO/O/uqdQFkb2XXdQ/yVnpX7LjpSIzUONjN95gpKRxNfUAOv311NK1tyY1aBEmMKsxxIf/lks33cayVt7uyVAr+nrb+aakBsEwEo73aSrpAUy0L9enBClOUqXqZIAJ2lIDq2xxA/c8t4xHMQfWfU749OsCqZWc93Jqm6B5XAb4lg9CXHiqmBKfLhiM2PaMGuW7MVuiMYI6cApsGAICdSFRLjRemR2znJsuUny65W4i6FKftNtyQo3Ln8cWsEMAYNHoBTNhQ+FrJoFmCI+6TQPl7MgkXnvCVKETA3Ypq83O72NtMj5diveCgJC8+GzcBI1xkhuPTmLB79ltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsFcKHAaGO1wHpj3GmDKDRkvfJ7DSTKbjqulDkTQxiw=;
 b=ka0mdLd9oe/t32/5hq2WhaPIDTWeamB2UORnpuYXK9EFxW75yDFwKT9JAyxSnWijqI1gUi2PKFV1sw6ySyi/Nxd9UAfT/i9GQi51gfVhNyviHt24lyi02ZLyEok5a7LM2cmYnftlkVyjj5rxRMwpPl0o4X4xfRXZV9VvF7A+7eo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7808.apcprd03.prod.outlook.com (2603:1096:990:3f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 06:40:46 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 06:40:46 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "junwoo80.lee@samsung.com"
	<junwoo80.lee@samsung.com>, "mani@kernel.org" <mani@kernel.org>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dlemoal@kernel.org" <dlemoal@kernel.org>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS
 BSG
Thread-Topic: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for
 UFS BSG
Thread-Index: AQHbNb1HPxYjMt8oq0qPQOMSxLmZcrK+MHGA
Date: Tue, 19 Nov 2024 06:40:45 +0000
Message-ID: <d3461ef552047db3e18cf3d222163ee685e13d9f.camel@mediatek.com>
References: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
In-Reply-To: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7808:EE_
x-ms-office365-filtering-correlation-id: fa8089d3-cdb3-410d-b55d-08dd086518f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b21OaGswWjJuY3ViS1lxZm1yTDM0b0xaOUU5OFVwSU5QWkVHRE95czBuQjJw?=
 =?utf-8?B?OW8xZjJ2YXI4bVV4Mk1JT1hLM0ZmcDJOZWZ6SUQvTkNsYkNSWFkvZk8vOFdl?=
 =?utf-8?B?dzY3ait5R2lOdkVVQlZ2THVyOXZWQUFpUTNRVjBXQk1RUUU1dUpLMlJWcXo3?=
 =?utf-8?B?dkNyd0pOd1hYZUtqSEwyTHU2QkhjYmlvMHBTbzcyR3h0NGFid2tmWG9mREN5?=
 =?utf-8?B?cU9CVlg3a1VjdEJKRHo5Z3MzT2hQV0UwL2FKSFFCT0RuOU1MTHV5VXVnTjhB?=
 =?utf-8?B?UTJ1LzVXOVdPYXJGWkNxTVlxbFFYck0zcWU3QnJWaW1rNFgvM2QxQ1g3Ylk5?=
 =?utf-8?B?NGR4MzBBNjlNZFhRZC90c1BJUDljREpKaFJkUlVLclJUSlRiZ29ydnIrSWgx?=
 =?utf-8?B?c0tpc0ViY2I2UUJ6cTlJNnN4QmRTQmVNVG9mMUl4a1p6SVNiMnJnakxTYW5G?=
 =?utf-8?B?Uzl1akdZbFpldTI5ZkM5c3NXTDg1Z25JdjUzbGc2VkNWQzJjOTlZa0lOMkY4?=
 =?utf-8?B?OXlqSzBxMnFKWlFpc01yUU0rRVVka0tFN3F0Q0RMZ1h3bmZHVHBqcUVyck02?=
 =?utf-8?B?Ui9FNWhtMStkY25rYWc4Y2twRGhqY1BkdzdhNExiWWlWYUVCSThQUjVROHNu?=
 =?utf-8?B?WUFhaExOUUR4czBkS01hZmpreHVpekNRYUc0WnAyMHdIb2xXWTlleXBrbk9s?=
 =?utf-8?B?NVNIQXhGWll1b05vdTE2N3Nad2VZTUZrbCtleE0zbDJFdDVyZmpkeUo4TWo2?=
 =?utf-8?B?ZjhUT2h5NGROVW92NTc0WUErWDUwV2hBVjJNZVJwZUdoTkMxSXFRTTdRL2U4?=
 =?utf-8?B?MVpYblpQVWhPQjNSRjNwUFdxNjVJN3RiRk9HMnpKWFU0Uy9JMlpJWTEyakV4?=
 =?utf-8?B?SEhxTU9aUFdvNkFDeE1pMEcrWjBYMlhvZ3k3Z2RDRkFTeUF6SWNGM0RjVita?=
 =?utf-8?B?V2tpNUVaV2JMUUp6OENxZmxWZWZqVlZJQjkrd21lZ05BRkJ6b0hBcFlHajRj?=
 =?utf-8?B?L1ZaajZrcFNIVVk2ekZKaHh1WGt0bjBLOW5oeUYxR3BYTkdrOGhxbmppVUxO?=
 =?utf-8?B?U2habkpraWZiUG94MzgxTFdIWk5KVnFUVE4yTjVMZm9PNXorcXlRTDZSbUcx?=
 =?utf-8?B?V2V1ODI1U25rVkVtRStVdVUzT044V3hTeVdzQ2s4VHNRUDNvWFNldmpwN1Bl?=
 =?utf-8?B?VmhKa040RzBUTHJLU3RpWXJYL05qeU44ZDFlY1ljczNiV1lpR0JJMUxSU0ph?=
 =?utf-8?B?MVJsdFc2YlgzazNKazZuNU1USkNZU25EY3B5aklXTkNzMWt5aG1PUGZ0NERM?=
 =?utf-8?B?dG5sSzM1cFBoYW4rSHRSQTBLZDVvTVk2RGpZbTlURHpNYktHNUo0ekdRY3BF?=
 =?utf-8?B?SVprRHdudEZUUkRrOGRBdlNUcUM3ZktIVE5yNDV6QS9rTXhEbjhLU3pGbnhv?=
 =?utf-8?B?WTZWejZuTmNiK1hBQzdNUlNvR1AwcjY4RGk1b2phb3RJa09BOGFteHFOd0xK?=
 =?utf-8?B?c0RNTjZILzhEVGRPNko2ZkpHdjg5ZFFkS2lTNnFRay9JK3FnMXRSWk52Q05K?=
 =?utf-8?B?NDZ5SURuY2pGM3JLMWxEMWF5OXRFSEhaQXl5RnR3RXVRMExuZlViMDJIV1VV?=
 =?utf-8?B?cHFHREhYY0tTeW5HR3JTbThHUG5FUDlROHprQjIzeXpYK1FEczB6U05Ock5m?=
 =?utf-8?B?aDJzUjhibktaVER2NC9aNkNOTVQ3aHZzVUVOcHh0V25KV2ttRXBqRFpiWm8w?=
 =?utf-8?B?UHV3Ui9OYjNYcHB5OHU5aEZnaDE1U1EwMGJYNFY5OTFOQ21xWHQ5c3NOb0FN?=
 =?utf-8?B?V0YxMHF2TGQyNFFQMnB1dndEN1Q1c1BYdnYybTFXTE5HMkJhOTE1TXhUbzg3?=
 =?utf-8?Q?3ZpFUhsJqPA7Y?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODVVZnQ5blZjTTRzdnJkaHBGeFc4K1Q5d3hOOHB5Mkx6aGQzcUJPall6VWQ1?=
 =?utf-8?B?Mm9pTzRVUkptajFCRTVhNUJnNEhCZXRjRWRvYXRLZUw0L25XTDZmYnJqNUpM?=
 =?utf-8?B?cDBBZzN3NzNWMzRwdEhKQVlXRXNCK2Vrc2R0MzU2Z0hDUEZqR3JiSTk0T1ly?=
 =?utf-8?B?ZUZENHd5YUErZmZCQ1pPMUFXb3RRZGpCNVVabVNuaGMvTjJVek55RG1vYXVl?=
 =?utf-8?B?enJDbStrYXJsREdxNlF2ZFA1MlRlaVhuZVRDanA2djY5M0huTW52T0V1WlJI?=
 =?utf-8?B?N0ZqNTVOSlRHckhpL1pvMnBqVE9BemlUdXBQaG1DK0ZvZFpmUTg3R1VFa1Jp?=
 =?utf-8?B?YisyRmd3eWlIakhoRW9DSFhYT052dkNPeGw3YVRiOGRCM0RzWnQwTzVESi9o?=
 =?utf-8?B?dEVOaWptWG9Sc2JEaUpoRGpoY2ZGcXRkRWVRMXlaKy9NS1crSHJPdDVHQk5T?=
 =?utf-8?B?MkRNWmhRK2lSTkwyOWlxN1V6VFhpek1QUzBScURST201VnlZRmZyUjU2QTFv?=
 =?utf-8?B?dUxFdFdJUDdVakwxNGZpTnZBOEppSHVDVkRsM0cwdDdlcnlXcDA1QTlPN2tr?=
 =?utf-8?B?U3Z0cnMxT21MTEVHR2FMeit3NEQ4TENGZVVuMnZNaEk4Wkt2U0xGS3lvVmpq?=
 =?utf-8?B?bEV5OGVEV0F5aUo4QlRiRUZDWGk1Wmsra09tUmg4TTUwdG1Pc3VaQUh3Q2tw?=
 =?utf-8?B?c1pWZ2wrTDd0aE5RVEIzdWl4bmZWUG5jWTc5YkdDejUwc0hBdjQzcVpPQ0NF?=
 =?utf-8?B?Y2M0c2JhUmgzZm9lYTBEek5WVndqZUhzOGFRNy9IZUxwc3NtUEJmQjh5NDFh?=
 =?utf-8?B?bldBN0tXQk4yRU1BTXFZNDhhMHdBVlBaVC8zbEtjZTZ4TllvM0pKZGM2dVZY?=
 =?utf-8?B?aExrRlRPMHpGdVhJZnJrV1JzaXhST1RNb2hkVEFiMXBGVjlyWFRoWldNUVNh?=
 =?utf-8?B?TUh2NXVCL21jeWxNdmRTSDNIbGRxcnQydnFOV25QSEFXOWhoWlVvQnpGd01J?=
 =?utf-8?B?eW9sM1JUbUE5cjVCZFdYSjVRSGdPTFUzWnVCKzdRK0tTZjltc2VuMzFEUHNu?=
 =?utf-8?B?ZldpdUJwSVkvVk16a0hDcUYrWWgxV1p2MHpEditrNnZXQjBLUzJOM3BtbnpU?=
 =?utf-8?B?S0srdG5BSVA2emdHRm1OenYzSXF3QkdSL2hhZE5uM25OdFZKbVJLNU1yNXJS?=
 =?utf-8?B?RlFPT3JXMDdBeUZhVWRpd2d0emhUN3VxdjNCVVVEVEM2aVljREMxaHVWdDZH?=
 =?utf-8?B?YTFLTFZPVEZQOXV5SDMwd0RCSzBkM1ZRS3ZOOU1VSzFJRTc0UFdMSlBJaEpj?=
 =?utf-8?B?QXhtUXhMdDZ0Skk2Mk90NkNBdDRnWnRqVVMwMmQwdGlGNHo1bDcxaktQMm1Z?=
 =?utf-8?B?S2xtQXZzaHJtaWVmeXE3K1FmaGh2MHkwREhjT1IyV1g1anY3aWVsNy9FaVdL?=
 =?utf-8?B?S0krVEtyVVZFVnRJT2pKcGc0RmhRRTJEMHRlMGZ2MG5YMlZ0TXZlcHphWUhl?=
 =?utf-8?B?dXZ3Y2o5L09aNHhUOEdnelNDSEVlNWkyUVVjNUtLM0hpNVF6YUVIZStJcXVC?=
 =?utf-8?B?cUx0alBOOTFpTlNHNERaVFQvamNuaTN1eWtDMUU1b0VJckJ6cXRsQUdRZkxB?=
 =?utf-8?B?UFR3Z1hIRFVzUHRYaG5mV05FNE9KWDFXSXVqRWRSTStTMVV5cDVmaU0zOWp1?=
 =?utf-8?B?RHhrS2FMTU9BanNHcnRuSnExeWxjQkNyK0x3OTk4dW9teG0xZDFVK0JLVkR2?=
 =?utf-8?B?YUQ2QkpuWE5jS0M5WkV1dnYzTWd4bVg3ZFVoallYWVBvdzNQeGlUVk1mQUhJ?=
 =?utf-8?B?SzRkUmd3aGVmaEZyQitMRGVRL05uYUhBMUhWZmNxVlVEQzRsRElOYTNyMzho?=
 =?utf-8?B?bjlWaXo5UVFxeU5vTkFGNFloeUMvSkVmSFRUTmpFVnZIeGxjWHcwSmxvczJN?=
 =?utf-8?B?MGUwSnpUVTJpem5DZy9lWm1VV0FhVEg5YTZhVXBYVFBGWHJlQ2ZSM2p3Mk9m?=
 =?utf-8?B?VFZ6cFlaSTJjZENLeGQvMTZmSy9QODZueEp1amNuNWV6VjhOU3lWdkhSenR0?=
 =?utf-8?B?Zlg3MDdnY3l2N2RnRU05U2FwTUd3UmxRbGZwVnJ0RXlza2YrSzZNZThKZGpF?=
 =?utf-8?B?b0Z0d3FWUEQ1L25DaFp4WGFYeGUrSW1OMzEvcU1oWUlvYTFrU0s3czRpc3hj?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B050CD9606F26B4B9EA32D3A115B1612@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8089d3-cdb3-410d-b55d-08dd086518f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2024 06:40:45.9921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gy4XBGV70sIRPU6rF6PkPch6D4jrOMLgaozE+5gSy5bBBtNvHGXkAgoIunyBEWUmf1WeO4xGvDzlz/VbmVZ55Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7808
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.679000-8.000000
X-TMASE-MatchedRID: ewN4Wv8Mz/jUL3YCMmnG4omfV7NNMGm+QBnqdxuJ5SANcckEPxfz2F8l
	h/2sQnVwThbvLLI8RvNdFUmWoM8+4feJL8tlAFMo66G2abPj6tgEa8g1x8eqF2Tld3DbJ1CG5mS
	23ZOIXyxWrPEcQNODjBj3dc3NQHAmr78SC5iivxzSBVVc2BozSlkMvWAuahr8+gD2vYtOFhgqtq
	5d3cxkNQBkkm/8xWmbzea0BxWlxTzuFTnK6Za3fuHwzE4GuGF9bJCdnKhhRH0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.679000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	4A9E5A429C881517FB2114DFC95E4C7F0D73EAB7FE64C9F9C47A394DF6D320FD2000:8
X-MTK: N

T24gV2VkLCAyMDI0LTExLTEzIGF0IDE5OjE0ICswODAwLCBaaXFpIENoZW4gd3JvdGU6DQoNCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3Jl
L3Vmc2hjZC5jDQo+IGluZGV4IGUzMzg4NjdiYzk2Yy4uYzAxZjRiMGMxYjRmIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUv
dWZzaGNkLmMNCj4gQEAgLTQzMTksNiArNDMxOSw0MiBAQCBzdGF0aWMgaW50IHVmc2hjZF91aWNf
cHdyX2N0cmwoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgc3RydWN0IHVpY19jb21tYW5kICpjbWQp
DQo+ICAgICAgICAgcmV0dXJuIHJldDsNCj4gIH0NCj4gDQo+ICsvKioNCj4gKyAqIHVmc2hjZF9z
ZW5kX2JzZ191aWNfY21kIC0gU2VuZCBVSUMgY29tbWFuZHMgcmVxdWVzdGVkIHZpYSBCU0cNCj4g
bGF5ZXIgYW5kIHJldHJpZXZlIHRoZSByZXN1bHQNCj4gKyAqIEBoYmE6IHBlciBhZGFwdGVyIGlu
c3RhbmNlDQo+ICsgKiBAdWljX2NtZDogVUlDIGNvbW1hbmQNCj4gKyAqDQo+ICsgKiBSZXR1cm46
IDAgb25seSBpZiBzdWNjZXNzLg0KPiArICovDQo+ICtpbnQgdWZzaGNkX3NlbmRfYnNnX3VpY19j
bWQoc3RydWN0IHVmc19oYmEgKmhiYSwgc3RydWN0IHVpY19jb21tYW5kDQo+ICp1aWNfY21kKQ0K
PiArew0KPiArICAgICAgIGludCByZXQ7DQo+ICsNCj4gKyAgICAgICBpZiAoaGJhLT5xdWlya3Mg
JiBVRlNIQ0RfUVVJUktfQlJPS0VOX1VJQ19DTUQpDQo+ICsgICAgICAgICAgICAgICByZXR1cm4g
MDsNCj4gKw0KPiArICAgICAgIHVmc2hjZF9ob2xkKGhiYSk7DQo+ICsNCj4gKyAgICAgICBpZiAo
dWljX2NtZC0+YXJndW1lbnQxID09IFVJQ19BUkdfTUlCKFBBX1BXUk1PREUpICYmDQo+ICsgICAg
ICAgICAgIHVpY19jbWQtPmNvbW1hbmQgPT0gVUlDX0NNRF9ETUVfU0VUKSB7DQo+IA0KDQpIaSBa
aXFpLA0KDQpTaG91bGQgd2UgYWxzbyBjaGVjayBpZiB1aWNfY21kLT5jb21tYW5kID09IFVJQ19D
TURfRE1FX0hJQkVSX0VOVEVSDQpvciBVSUNfQ01EX0RNRV9ISUJFUl9FWElUPw0KDQpUaGFua3MN
ClBldGVyDQoNCg0KDQo+ICsgICAgICAgICAgICAgICByZXQgPSB1ZnNoY2RfdWljX3B3cl9jdHJs
KGhiYSwgdWljX2NtZCk7DQo+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gKyAgICAgICB9
DQo+ICsNCj4gKyAgICAgICBtdXRleF9sb2NrKCZoYmEtPnVpY19jbWRfbXV0ZXgpOw0KPiArICAg
ICAgIHVmc2hjZF9hZGRfZGVsYXlfYmVmb3JlX2RtZV9jbWQoaGJhKTsNCj4gKw0KPiArICAgICAg
IHJldCA9IF9fdWZzaGNkX3NlbmRfdWljX2NtZChoYmEsIHVpY19jbWQpOw0KPiArICAgICAgIGlm
ICghcmV0KQ0KPiArICAgICAgICAgICAgICAgcmV0ID0gdWZzaGNkX3dhaXRfZm9yX3VpY19jbWQo
aGJhLCB1aWNfY21kKTsNCj4gKw0KPiArICAgICAgIG11dGV4X3VubG9jaygmaGJhLT51aWNfY21k
X211dGV4KTsNCj4gKw0KPiArb3V0Og0KPiArICAgICAgIHVmc2hjZF9yZWxlYXNlKGhiYSk7DQo+
ICsgICAgICAgcmV0dXJuIHJldDsNCj4gK30NCj4gKw0KPiAgLyoqDQo+ICAgKiB1ZnNoY2RfdWlj
X2NoYW5nZV9wd3JfbW9kZSAtIFBlcmZvcm0gdGhlIFVJQyBwb3dlciBtb2RlIGNoYWdlDQo+ICAg
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdXNpbmcgRE1FX1NFVCBwcmltaXRpdmVzLg0K
PiAtLQ0KPiAyLjM0LjENCj4gDQo=
