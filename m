Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F50413D8B4;
	Tue, 19 Nov 2024 09:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732008164; cv=fail; b=lckHt84+dpderEcCeGzj0pw5VXLshcD08L7xXAPPrLIwAMOfIEZ/Dvxk1eCt2m4c6dKWUipve+Znc/HJniIJLdae5VRHY1dwvsBcghHjWZVwdvdCskAWhS+n4Opg+taQpoIQB+GtGupQ0c+Nc6iA4/juDBfuD8rD9VKm2iueo/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732008164; c=relaxed/simple;
	bh=XplIWuX7aEFrM5sszUfAF22KkNxJcwUELAfKSkb5pTI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N3K6u2vE7ZtCHEqBY1UKGI5OB2fcDFigNKgagNtGdXPn1ywIl/Lsaoqp9O66Asi8NMzzyagi6VilL8G+6P4mKWpN3wQtkNIs8FOR3tnxEx0P5qNtmNLU+gGEOKU4ayX/FOlYDGXZ8jHPy07ax0mnp+Wk0Vqx0HRhYzU5EoCBcWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=O7iC3wM1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YEsyr9zf; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="O7iC3wM1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YEsyr9zf"
X-UUID: d0008402a65711efbd192953cf12861f-20241119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XplIWuX7aEFrM5sszUfAF22KkNxJcwUELAfKSkb5pTI=;
	b=O7iC3wM1r0Kla7fDoayboqN7MdUVhx6XHjXPH4TbqrH4ZvdNv5HzG9+YqD77IT920NxDeZ7/V/Qp41F5AZnWcIRU68hE4Jbw0INvxX5eeQuT5GUjjx2BzQMjwoAr2ii6zw6dAiMuzNcuIT4TWBmyoJ84NaQ3kMn7yNE1sBYWSvo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.44,REQID:ad32bf6a-9a6b-4010-98e8-e665061d244a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:464815b,CLOUDID:c108e15c-f18b-4d56-b49c-93279ee09144,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0,EDM
	:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: d0008402a65711efbd192953cf12861f-20241119
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 675203653; Tue, 19 Nov 2024 17:22:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 19 Nov 2024 17:22:33 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 19 Nov 2024 17:22:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SU7V0r1387y6DlO8WMNIc8HJ68u1u4Etp3BIpbGpfuGheZmw3zvQeNwor0EhXD/qV/GO49SPZUd0l9vXqgJIWp/J9Slvbo6KqdKO0MlSazYYwsFfdc2lCFRmq52MKBZAfSbueWfdFZoP8vYbmbsbiPu4wJfwnMnbgDDsqCNaytifnNRIWBGr7NDOlphF+2MLBTb2E3ZeohpCwiaiJZLowr/S+FJDpGHvMvB67m/eFVTCzLZitmrdKlCb5sS2lsJ7a4fltt/VV/bQbRHPVOaappLVjvVsieOLcZMEgUGdFyiRJ1/uZ+DdeiTkY+myofmf0DA9nnOGc7SkTTM7qw8qhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XplIWuX7aEFrM5sszUfAF22KkNxJcwUELAfKSkb5pTI=;
 b=nZ9TLvAA+L0PSNZZ6EJNEzxeemNSNAn/qxB50Osz/h4d4ziO6OhMWaew2dPxcMGDgJ7d/ExEjC9KDOw5WhcIgwIyszBUB2OZcrG8YeIWAo45jBA4kvKqqEHTfZii1t3+0MjLXLofsrh2J3mPjrWlLsuzCklH7Wk4B+MA1wC51mVKkdQ71TRb20u6dpY2H4ghPbUKOAW5d3lhoELHCRzNx0Q2JHD5cfv7HBNi7Wh+3Hp8PeDQlq07JeAjRGAjNFcvV1zDRLb5n7dNcq+lSwOnC2oSvUMhHKmeXKcXeBTaNAHi27MLtPVsuZaHNwgiC/PSR9rMG0BnlXFMAOyW2VO86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XplIWuX7aEFrM5sszUfAF22KkNxJcwUELAfKSkb5pTI=;
 b=YEsyr9zfpXd6LKbCllG8fP3PoO2v/b3ASoGwNF1c42lGfOxuk4T5zUFAc7xGmHiGAXp0ddNl7zgzgdJ/k+KlhxMerxM0bvsLKT4tSYloiEoyZf6/ontS0tFxgCY0QvgjRlFDY4BEPb5G/PoDTfeba2jGWX+1x1R+XhI4slZaRzc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8083.apcprd03.prod.outlook.com (2603:1096:400:476::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Tue, 19 Nov
 2024 09:22:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 09:22:30 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>, "beanhuo@micron.com"
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
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS
 BSG
Thread-Topic: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for
 UFS BSG
Thread-Index: AQHbNb1HPxYjMt8oq0qPQOMSxLmZcrK+MHGAgAAkxYCAAAhrgA==
Date: Tue, 19 Nov 2024 09:22:30 +0000
Message-ID: <afe477c2276a932588af53e37945ea57b61effcf.camel@mediatek.com>
References: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
	 <d3461ef552047db3e18cf3d222163ee685e13d9f.camel@mediatek.com>
	 <eb9fd0fd-6701-478c-a697-9453d97d604e@quicinc.com>
In-Reply-To: <eb9fd0fd-6701-478c-a697-9453d97d604e@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8083:EE_
x-ms-office365-filtering-correlation-id: fb040061-4f35-48a2-e977-08dd087bb127
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V3ZYUWxiWitQM3ZkSnd1Y3ArV1JFcU9jZ0xzaUtYUDRncyt3RFYxQ21nNjhT?=
 =?utf-8?B?UG5PRFJad1FVNmVwbThTaVZmQmVCTWJ0Slh4Sm41YlNrRUM2VnNZWTU5OXpR?=
 =?utf-8?B?bjAzUURHSUd0Q3BrbXN2WWVYVE1sUStlVUlDYXc3MGZoejB4aWwweDgrS0li?=
 =?utf-8?B?WW9sbWZWdU9IYlRvTi9qS2U3UFVIUmpuZHFwRWhUd3dlUlJCY2NpbHp4cWFI?=
 =?utf-8?B?U1NiVWE1aVN3Sk1qL0EyRVlIQWJrTEJuSnRvTUZTL1FXakRFVjJqNUx1UE51?=
 =?utf-8?B?cnJnelo3bzQxb3FSQ3pLWTRUelJRbmt2WERIdnI3VHk0cjRQM0tlWEQyWktD?=
 =?utf-8?B?NURlc2RwWVE0c1ZyVTRTSUdYYXUwSGh3Y09hUnBMZDR5akQyNUczYzZsOTFZ?=
 =?utf-8?B?VzdKajlwUG03YUxUL0dFUkNVN3BCV0h3NlJxMERGY3FlQkVpOXI2WWM3bUZN?=
 =?utf-8?B?cGlPMDFrRFIrc3JhVXFpeU9udmVaZTVIRDE0UW5WMFc1Njl4bjZDT0RMbGkw?=
 =?utf-8?B?Mmd2emw2N2ZIWmJIaE1VMU5HcHBVZlEyaUV2ajllUU1oNW9xdlkvc3c3YkNj?=
 =?utf-8?B?Q2RjaklpelBUQTB6YlMya1lvd3VaMEtUSUV0OFV2QVlQSElQVkxySGQ4clo3?=
 =?utf-8?B?Q3ZiQW1LQ3NJQ2hOQklzKzFZazYrTTNMZWs4N1c5N3oxWnl3S3pmUVRwa28z?=
 =?utf-8?B?akNWYmF6QjZad1NRbUlUbkl5VWdsdnBtRVZZSmxyTUpoSWVsYTVxNERsQ25p?=
 =?utf-8?B?RFVXN0RTV2ZkWmx3U3NQY096ZGM2UDZVTlI1YytzS01JbC9CZzhjWS9CUWRQ?=
 =?utf-8?B?QVAvU2lnUGp3VGtCNFFKbEoybUh2OCtZZTRPbFBTZnE2MldUOFJTN0xRVFg1?=
 =?utf-8?B?clBLWEpKVERnL2sxSmMyR2kwQ01NdFNXRm1UekNZUnM0a3ZDK0JkQVpGcmJh?=
 =?utf-8?B?VVF1UWhPYWcyUWIyK1pnU3JoKysrUnd6REpNSzlwK082UExETFVwYVZSaGdW?=
 =?utf-8?B?YzdOUWxmS3JqTGVMN2IyMlVxaVNhQlNrMmtTVEV5b1hPR01FcVhnVE1RejJ2?=
 =?utf-8?B?SkRKL21naFpBV1pFTjA2Qm0rSjk4ajhHamJ1OEE0Q1d6Q2VvbXdPc3NScmo0?=
 =?utf-8?B?R0JENmw5MWEySDRxWHZqWjVjd2hXTXdHRjZtbVI3aExhMUptdk9nYkxPeGdU?=
 =?utf-8?B?Y3pnTDV2ZG9iZit3T2N4SlZHZ1VnTTlERVcva0xmSU9FWEVHek02N3lQVU96?=
 =?utf-8?B?alBEZXZvT1FJNStNL0RmMjF5cFYvSm15Q0dlc3ZLTGFtNmlLRUNvNTFqbk12?=
 =?utf-8?B?WVRQMW9YNzU2alg1VFUyNkc4bnorT3FiYzBNaU40N0ltUldqRVVCbkY0bFZJ?=
 =?utf-8?B?RW05WHlETm1reDdEaHRTYzI1N2hVR2NmQUZJZ2xPcUNFWGRGdTJmMXg1enR0?=
 =?utf-8?B?dEdhdURmQ2xZbSt0RzRlVm1DaWpzOTIvMVdsWkJrMlFURTg4Z2F0cUpsNVk0?=
 =?utf-8?B?ZG9saHMycFRDdGdFRStJQnR5V3dCR0JrTGxGSWpHZHBJNDdtMm5ZRW5RTDRs?=
 =?utf-8?B?WmdtbVZ1aEo3aXllNU1wa21uWXFGN1NXY2RocW1TOGRjdGV2elBVU2RQZFN3?=
 =?utf-8?B?YmxJc3dURGNDc0cxdW5qcG1YQTJ3eGE3MmEzaXd4ZzE0WjRUVEF6dFAweUgy?=
 =?utf-8?B?eTB4RTJBWEIzdytqQWpGWWpadTVBbm1ob2pwc3lHT2FqRjRCMWs2ZVcwNmNw?=
 =?utf-8?B?b2pnT013TFpFR3FSbUlMWUpSUEM2bkVjaitIM1poZVFkeGFjRk9ITXpZZzQ0?=
 =?utf-8?B?Y2RQdktZTXc0Ri9iN1dqL0w3OFlST3B1SE95OVpNenVta0ZJWStnVW9raE0v?=
 =?utf-8?Q?zuV3wyWEfBJSI?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0pXRDJHNXRja0xrdUpUK2x6RlM1aWNaRENTQkhMR3drb0pmdEFNaDJhcnl6?=
 =?utf-8?B?NUV2TnhTL0tZbVhYN2o1RFNiUm83RlM2SG9HRytOYXBRVHhUUkprZ3VENUt2?=
 =?utf-8?B?bVlkUlhqUG0rUXcrNE5BWERWcW83RDFoYkEyZUlRV0RvSEo2MjQ3MHNZT2x0?=
 =?utf-8?B?cnhGMFhROFEzdW5vS2hrNU9OQVhOeWdGN2JNUFh4alhoMEFjakNLZHpMYjRa?=
 =?utf-8?B?YlRVcXBsMlEzakxVVWVHbTFQZHUzaEE2eHcwczV5aVBLVnhzWHFUZXk2OFc5?=
 =?utf-8?B?ZVRvNUxtVXAzTUpZMis5eDN5TlZaN1NYczRsYWNLVjNKTmhtWndONTVqOFpC?=
 =?utf-8?B?N0orcGhKcVBBajd0M3hpRHVndkw0RWk4UjIxeEV0R3VVcThIQlNJWGF1c2J1?=
 =?utf-8?B?Z1JvZFcwSWF6MkNZb0cvays5bEYxbVlsbENQWmUwQXJzRHNvRVlPWXl6eVJV?=
 =?utf-8?B?QlB6SW8vOE9POXNlWDVDODhMRXNyODFrcmoxZ0JKdkxkU1pqeXZwSVZOUDUy?=
 =?utf-8?B?SUdtbUZRb2VaNzZHS1NBbHE4YmYxUktOUGNIdk9Na0YyRmtLaGZMejdPMHdC?=
 =?utf-8?B?UUw5bkZBWHdLZGdpOTlXZElIRWhMOUdXNnVJcHM2TEk3ZXV2bGZ2c2hNNTBk?=
 =?utf-8?B?M0YrSThPL1RTeVBwNzlrb2c1V29jQjdNTGc3b0JWNEhmRE5lTkRXc200MjZB?=
 =?utf-8?B?SDg1MW8xdm1jeGZOckxWTWZiTkFoNHdyc1ZVS3c5STF6NGhxWk9TLzBPZFR3?=
 =?utf-8?B?dFVTakVQQWlHNEdDVVlEOGVqSFRkcnYxWVhyK0FLeG5meHZSaTZQRnFMa01O?=
 =?utf-8?B?SnNNNFRoK0hiVGNlS1B5aVhMNjRPVm1qeGtTempyS1k4a0lrMXpuZWl0QWNv?=
 =?utf-8?B?N0VzTWRNc0Y4aTFTbFNqQi9rVUFwVWl4NWhBSlphOHdraXJ2UjY2dGZMT2Zz?=
 =?utf-8?B?Rjd5OEhuS04zQmJvYVp5STBMd3ZOckVXVnJDWjVqMXFFQnFwMHNVUTRKMHZo?=
 =?utf-8?B?eW8yZ2drSkVKZnRmWTNGWjJqVWNieDROM290Q1RLaGZRdHM1L2p2NkI0QTNH?=
 =?utf-8?B?VWhTTjI1Y25GanU5Rk11OVV2dTdJbkcyeVZBNFpQKzF3NTUwZ3RsOTB5MUhH?=
 =?utf-8?B?bkFwOUVLaFpjTXB3ckUzUkdPR0tvb3E3MDExVk5pNkg2SllOM2FKMEF6cDlW?=
 =?utf-8?B?RUV4ZDgwSmZldjFnOU9zVzZCK29qeUViVXZuQTdFdmlxZnNhY2VXNzY3NXQ5?=
 =?utf-8?B?eUd5SXdpcEg4K3Qwamw4cSsvOGNyZmYvemJnUUhVU2t5cHdqbmZlUzl3Rm1j?=
 =?utf-8?B?K3RvN2dieTlhUTVud0FKU1FoNTRsaHNwZ2RpQ2FleXU1NlQ0em8yTW1MR1Fy?=
 =?utf-8?B?VllSMVRmOGlkdW1HSHpyTFZsZUVwbFNwMGJ2aXBpOE1INHpPVnR0bEJsOVFQ?=
 =?utf-8?B?QWVtaFAzV3VEUXVsMFdEbzJya1p4cXVTQjNSSVZWUEpuQ0gzNXVjc1VldU9S?=
 =?utf-8?B?clBFQUY3dzVramxvNTZaZzIwYndzQ1FETlh4cWVVdUZIaVJjMHRvQmZoTEFs?=
 =?utf-8?B?RGkxOTFkNmgxSU1hUTFiQ3VBdWFtWE9tSUxyM3FzcUJMYWlJZXF5NWJQRUI2?=
 =?utf-8?B?ZVZMdzR2U0dzMGViYnlNK1BLY1lMYlRreGgxN29HY2U1R2Zia1lzSm9vZVp0?=
 =?utf-8?B?dFVnTzBIMVFleWoyRDVpbDNCcmtPZmV4RG93T3dXSlhjNmRSSEhVWnpzd2hF?=
 =?utf-8?B?MmY0MkxEdW9VdFFoM3Vsb2R5ZnRLZFpnUjA3TUdqU09NNmJwRW9hZVRlSHFK?=
 =?utf-8?B?SW9wZGJiR0J2NFZ1SDBxcGxDbEdwbmpURThya2J5WHVOeVNjekkwNDdqc2dS?=
 =?utf-8?B?MUtWS2xIM3FCT0F6NjFGb3dkUDhBckFJR2JPN1BQalBHeUpmNnllejIxK0Y4?=
 =?utf-8?B?Z242VE1GMUFkSVhMcnUzem4zTFdFVjcwSERGd294d3NWSVBPc0xrZGQrYmQz?=
 =?utf-8?B?d0d4K2lqcnpIRzQxaVpwMVo2UDl5VHNYYlJTSzFtTVd3RGVjMklRTW4vZnc3?=
 =?utf-8?B?M2s0d2VXaFNUQTBrMmp6aU8yZDduQ1ozKzhiSHlFNWpCdis2UUNQOFBMbkkw?=
 =?utf-8?B?YVQ5RU1XUCtRLzA3amdZazVmQWozSHBUZDhSbGtpcnN1UmhzZzRRR1BsK3Bl?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43356A7743F4994282E6C7B66AD36A0A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb040061-4f35-48a2-e977-08dd087bb127
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2024 09:22:30.2349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6DRyEz4sbHyiPhrHM6fjYHmJo576BhqXSMrd4GhPAMfZ/uN09UJOrkH+AjHuFAdXGgKVYZOlLq0D3x9eqy3H7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8083
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--21.627500-8.000000
X-TMASE-MatchedRID: yxAmdCLMIs3UL3YCMmnG4omfV7NNMGm+QBnqdxuJ5SANcckEPxfz2DEU
	xl1gE1bkfdd9BtGlLLzx1uczIHKx54/qvvWxLCnegOqr/r0d+CzOo//J/EA1QTMVY5itbDoDLuy
	t5Ak2dzs8noX7PDvCLIiuLU5n9mEDOxkO1TPw5VGqEvbUNq/XjYED+PNzPecBWltirZ/iPP52eV
	r7iwQ+6vPVl3o1BS3DRUb9zPzxpcWAaBshbPhdTPSG/+sPtZVkmyqQJWNsuknJYIv7y0tu9hnXQ
	1lmRV8S51hq/CJiqpHdQuDmogZ1+VQhXn0EVdzO+L2GsArAgtpNedaYR0zWETGnMWgJkpRoDYq7
	6A/eTGKw/FVk+Fw7zN1d7aF3CVBvX2XQkFZkGg/mAId+2bAQwrWTdtEh1dU0OmC93eKossajxYy
	RBa/qJRVHsNBZf9aRAYt5KiTiutmJhnKtQtAvVsRB0bsfrpPI6T/LTDsmJmg=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--21.627500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	C5A9C49AE02731227805EDE4DE5D990F0671A25DE2DE5E9C0834C5CABD2299F82000:8
X-MTK: N

T24gVHVlLCAyMDI0LTExLTE5IGF0IDE2OjUyICswODAwLCBaaXFpIENoZW4gd3JvdGU6DQo+IEV4
dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNvbnRlbnQu
DQo+IA0KPiANCj4gSGkgUGV0ZXIsDQo+IA0KPiBUaGFuayB5b3UgZm9yIHlvdXIgY29tbWVudC4g
V2UgYWxzbyByZWNvZ25pemUgdGhhdCB0aGUgSDggRW50ZXIvRXhpdA0KPiBoYXMNCj4gdGhlIHNh
bWUgaXNzdWUuIEluIGZhY3QsIHdlIGhhdmUgdHJpZWQgdG8gYWRkIHRoZSBIOCBjb21tYW5kIGJl
Zm9yZS4NCj4gVW5mb3J0dW5hdGVseSwgdGhlIHNpdHVhdGlvbiB3aXRoIEhpYmVybjggaXMgY29t
cGxleCwgdGhlcmUgYXJlIGEgbG90DQo+IG9mDQo+IHN0YXR1cyBjaGVja3MsIGFuZCBzb21lIHZl
bmRvcnMgaGF2ZSB0aGVpciBvd24gc2VxdWVuY2UgdGhhdCBpcw0KPiBpbXBsZW1lbnRlZCBpbiB0
aGVpciB2ZW5kb3IgZHJpdmVyIGJ5IFZvcHMuIFNpbXBseSBpbmNsdWRpbmcgdGhlIEg4DQo+IGNv
bW1hbmQgaGVyZSB3b3VsZCBjYXVzZSBvdGhlciBpc3N1ZXMgc2luY2UgdGhlIHZlbmRvciBzZXF1
ZW5jZSBmb3INCj4gSDgNCj4gZW50ZXIvZXhpdCBpcyByZXF1aXJlZC4gSWYgd2UgYWRkIHRoZSBm
dWxsIHNlcXVlbmNlIGhlcmUsIHRoZSBjb2RlDQo+IHdpbGwNCj4gYmUgYmxvYXRlZC4gV2UgaGF2
ZW7igJl0IGNvbWUgdXAgd2l0aCBhIGdvb2Qgc29sdXRpb24gZm9yIHRoZSBIaWJlcm44DQo+IHNp
dHVhdGlvbiB5ZXQuIEhvd2V2ZXIsIHdoZXRoZXIgd2UgaW5jbHVkZSB0aGUgSDggY29tbWFuZCBv
ciBub3QsIHRoZQ0KPiBhYm92ZSBpc3N1ZSBpcyBwcmVzZW50IGFzIHdlbGwgKGRpcmVjdGx5IGNh
bGwgdWZzaGNkX3NlbmRfdWljX2NtZCgpDQo+IHZpYQ0KPiBCU0cgZnJhbWV3b3JrKS4NCj4gUmln
aHQgbm93LCB3ZSBoYXZlIHRlc3RlZCB0aGUgUEFfUFdSTU9ERSBjYXNlIGFuZCBjb25maXJtZWQg
dGhhdCBpdA0KPiB3b3Jrcywgc28gd2Ugd2FudCB0byBxdWlja2x5IHJlc29sdmUgdGhlIFBBX1BX
Uk1PREUgaXNzdWUgdG8gdW5ibG9jaw0KPiBvdXINCj4gY3VzdG9tZXJz4oCZIHVyZ2VudCBjYXNl
cyBmaXJzdC4gQXMgZm9yIHRoZSBIaWJlcm44IHNpdHVhdGlvbiwgd2UgaGF2ZQ0KPiBwbGFuIHRv
IGZpeCBpdCBidXQgd2Ugd2FudCB0byBmaXggaXQgYWZ0ZXJ3YXJkLCBpbiBhIHNlcGFyYXRlZA0K
PiBjaGFuZ2UuDQo+IElmIHlvdSBoYXZlIGFueSBnb29kIHN1Z2dlc3Rpb25zLCB3ZSBjYW4gZGlz
Y3VzcyBzZXBhcmF0ZWx5Lg0KPiANCj4gQlJzLA0KPiBaaXFpDQo+IA0KDQpIaSBaaXFpLA0KDQpJ
IGNhbiB1bmRlcnN0YW5kLg0KDQpUaGFua3MuDQpQZXRlcg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIg
V2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
