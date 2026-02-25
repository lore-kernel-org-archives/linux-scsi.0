Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57502E2DFB;
	Wed, 25 Feb 2026 10:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015589; cv=fail; b=AnafhCjO2XiH2+g/275ZNJ2Ent84SJZHGeGTCGbHwI8/mUyPny0YNxd+c4KZwyIZaauadQuxPjXyNg+zGNAnRE4L5SyIlIcrVWnIKeZ0/4um2qomK0Ma7lg5WW3kPZn6OUGnzu5+rDAl2OL0pIGJfNRLsI4Hdh93/mZxz2KFJi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015589; c=relaxed/simple;
	bh=5Tgq8F9dDYE6ZXAqTmpL7vJkWMCZPqaae6PX0CA880k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cup0b0ExhMpphPzlduxMxZtAnAYVlR+JfA0JuKAxwDN5Cu49m1/S49hDYDTTrULuwHhlImwC/ib0MYZkKy4BbBCJobBoBuxi73Qi2fLE5wDYj5nu+kvY1azRTO95B+QNBYB91DIPpxFuovEbx1a4wqhUNuf07OrmMc/MsEXg6Ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=POGM6+tV; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rWXj2/Oz; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="POGM6+tV";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rWXj2/Oz"
X-UUID: 5c27ba82123511f1b7fc4fdb8733b2bc-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=5Tgq8F9dDYE6ZXAqTmpL7vJkWMCZPqaae6PX0CA880k=;
	b=POGM6+tVfZgCmZUX1/khBK3/CgB6wKbqKLL+Y5OZfjuOZ3PDGZleXA/kElsnn/23CZncI08SWZhl+V0rAPA3v+qeDvLtA613teZk0eNsYQuueOOCp/aDHt4XFiDFVQmlUJn+qDHP56snKBLRTtA0NgS+DvVAUURH57JdL2f9oKo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:8b0ce2d2-be7c-4148-af70-886752207d99,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:880afff0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5c27ba82123511f1b7fc4fdb8733b2bc-20260225
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2084723341; Wed, 25 Feb 2026 18:33:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:33:00 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:33:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqznMyVHpqARiEaATKfyZRi5F/D4eYP3U7w/+UZtzFvmF3HOVFD7ccSKrS43Y5fwVii6GDTr1VrsSLZiHU2h/8A9bFdyEr3/buw0EyIDyP7X1zx6rS0G+eBhFlypNVIfcdlzbjvhu/GxqnRIHdHIcg7Xd7L6FTUp6aouk/TjcIml19p4Q2rGUY1DKLaJv74GMC2GOOzO+VK07KnxWhv8KsxSiX7skKNhtljlzbmxTkceY3zIDVjk89Xx6nBBQsYJ3R70GMCclUq95xiudR331nFKqWfcOnTzI6qKwEyEAZo2z96+0IGMK6GSOV2muGj7IB41LnuXOjxPEeqyKDXb+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Tgq8F9dDYE6ZXAqTmpL7vJkWMCZPqaae6PX0CA880k=;
 b=fkQi3ku6p4wkntqI1iTM0LinpHJ7/jVvrc6TeLk8gYF9tO7/QUunAtqvFBIsENUAx9seUbH2Cks3JcdKeCEDpObfhfCAa/fBDKOriyjv0bGhZyxrPJPfWQ9/twEzHotkDTo7Tqqn7aQqlbmbhAC/B1qm3qYzj6fz6r4VD5sasntgCnIrCPCJ2FhkEzN9cWgXQbq1VMgvN0ZSUK5nAkxaY9pKw5Xa+M+Es3mphYziMeIJYBiN8U3IYUtxH1NdDokdWAactXxm0Y/tWOfVwvPHjdG+hmwo3DwzCBiEPAvP503VFxcs+yLVgc6+a90ogzbsTa/86K138dzDRMfVLDKAPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Tgq8F9dDYE6ZXAqTmpL7vJkWMCZPqaae6PX0CA880k=;
 b=rWXj2/OzdLwfGWAio1zR9VbpxNP9PuPiWQxbOw7+A10WrFZqiRh2ffqY84jPM3ZNK68iyEa0vY/nix4GsUKfdz3vv+cPOZ4fVw0Lxpbg3pKXSbHJMM9ONii4dedXBN6j7cC+NmFmjaMBGbPqwQ4Z95XF8dNcS0Dxsdr8j0uoVgo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI6PR03MB8652.apcprd03.prod.outlook.com (2603:1096:4:250::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 10:32:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:32:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"broonie@kernel.org" <broonie@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 17/23] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Thread-Topic: [PATCH v7 17/23] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Thread-Index: AQHcn0nYpvPFSDho/kOoNfzP7/KCjbWTRaEA
Date: Wed, 25 Feb 2026 10:32:56 +0000
Message-ID: <dd895595dbd4cf855ef4ea53aa1b5a0d30169f6c.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-17-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-17-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI6PR03MB8652:EE_
x-ms-office365-filtering-correlation-id: f947613a-52ea-4713-821d-08de74593daa
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: 6Y8GriSTokrlkTH7t0nrEFguz8YQ5L607+lDCgneEraF9yBv/fvjj0ISvIU2uPWMy8aOhEp5v/qK6Lo96Qfm4SdnbXp+AWEv0iYZ2NfHQYJBxgqAaLU1Rrn+aUmzBValx0p/BYf9jxihn4R5LQSD35DV4lfoHpMgT0M/Enai2KIRYabWTudy8/tKUarU/UOHO7Dwwjn2TNrxCCR8koE+nTp8LSMy+zaNUU5kFskqLzFEgXBrX1TGM4UqDAjrKC7LAX/Y2aGU5NdMK8wsdyuqWO39eg22bhUi8jJXcjwExHcibqY15iHiWLAcvTSqGXnnsBK45QfhypveEwV7p1p9gEhFxYakx3tpSsznnHbu+unbEfPwlcaQ0WoYujwevVgvmR0ELwbYKqiaeVT/wxxKFqvJ6xztw0ezKo1ftu0XEjM5xXyjgsbodqe7McqI5pp6QFGlyVWkBlE9dX5F9We9Wl8rIRWcOlMoaGcUYJrKqJnLpSWzCuCy8dnEmOHdWS4eDB8aXAoJHVYnqK0B2FQ7/BUXBpoWNX5Vak7v+q+3D7/e9IN12viwviNphMhzJm1ZooCTEPuPjTHBbs/V7NY2eaYKc+/+BVKqF7TirkwvYMgSTiNK+ZsT4RXe97Cafi6sowroGTGeGPvv8NL09tPhVIZ1rH3O7qJJUz2t6SmTsqUGskhLvfq5UR5PR3nwMK5DSSOx92/9XpWrWCtxmCMh9C7neDkEGJo1enSIGhSRlrP80qQGA0IWAUeJbjyDv7+3sXAcHO0J64qaNW86I/eA5puYD/vCkVRFSHaJ0wkHpRjiZo61Dp+QqFVstEnuRBxI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUVwSW43MzNrZk9CMW85VjJiZC9IMnNNdWxvUG42TW9sdU9lVUQvRWthOHhF?=
 =?utf-8?B?WldTb3R4eWh3QzgydjVrNUxRY1NnZEtzNmVUTEpjMUN1R2F2azhKZC9jNVo3?=
 =?utf-8?B?V2ZiRnFwY0pXVkpadG44dG4xelRRd29uMnlMWnB2NzV4M2syaExpUkhSazJX?=
 =?utf-8?B?Y3Z3NlJvNm9Jb2w2SUIrdm9kZFpTeUlxQ0RSdWR0VjZWMVlTcnZNN3VQZWFv?=
 =?utf-8?B?c1dhN2pQZUdpQmFEQ2I3ZnBER0pIODFzZWxlWU5DeXNORW0rVWx5RE41cUtU?=
 =?utf-8?B?ZnJMT2RYR1U2SVM1bTlXVkdHUVN1TUdRNmRsTjdkcmhpK283L3NDcHcvNWtM?=
 =?utf-8?B?NmJiQ3RaUHFVL09JeE9MSGRuQVlVQUV2U1RRYnZEa2syRExtbGhsZHhZZmxU?=
 =?utf-8?B?MHY4M0pXeEN6ZjdBa0dMZ0lCUFk2ZTd3SEk5emlEWkU2TkN3eDIrSnNIOHFl?=
 =?utf-8?B?d1ZlRksxVDFnZjdOc2JWNVhKOWVOcEJ5UlZZUEJKTVJ1Wmc4bC9wSkQxYWor?=
 =?utf-8?B?OXhMOEgzVlVVMzZCV1NrdjVZZ0pXM1ROVTk1U0MwOUVIM1dCK1h6c3FZNWpN?=
 =?utf-8?B?bVAvM2hCemlLdkIzaFNRQXcySnFVbVhIaTY0Q1VFYnpTNzlXTkk5L0UzZ2Z1?=
 =?utf-8?B?cVY3cnA0OWpreWVuUjlQeHZXNmNYdkZFWnhNb1JKbWdKYSsxQ3dXN1RQRlgr?=
 =?utf-8?B?Ky9xelAxL2d2RGNiTG5KOGFNZk9TQkJBc1RxS0hFWWJ6UWREZjRUZysvVUEz?=
 =?utf-8?B?M01wTjRGZ2pTOVo1emZnTmcwWWlqcmVONTNIZktOQnRRY1B6RjVPVTNZTWFR?=
 =?utf-8?B?YzB3b2lQVUJqZ2NtTGpESzhvZmYxZ0NnYmludmxXWXFMd0M2aXYyNWZJQUdZ?=
 =?utf-8?B?d3pmdzg1anE4QTVRalRJOHJxZkMyTlJjQ25GVmk3Q3B0RTlVNCswMGJkS0dY?=
 =?utf-8?B?NElSMmcvY09TVXY3b1VqU2VkaHJjeC80dVZyeEhyQ0k3WUFkVVdBQnc3ajl4?=
 =?utf-8?B?MU1DRE9ET1c0eXFpL3hVRHJsVmNnQ0FxaklncHlEYjFGbmJXQTdsS1NnSDcw?=
 =?utf-8?B?YWwxcHlwcjlHM2lBUWhsanFNeGNUbWxmeG10K292aUVPUFEzbHAzQmk1N0VO?=
 =?utf-8?B?aFpoZEhXNUt5YlZsQ3I4TXZMZytuMFpldnV6OGVtcFJDeFNrVXR4T3l4cDU3?=
 =?utf-8?B?ZE45dUNlYlBkNjRCWXpMcnRveTAxOGEwSlVBVXV4bVVWN2xha2dEWFRFU3R1?=
 =?utf-8?B?RHRxMGs5NDJ4bWdrVWhyLzdldUFDcGRGS0JLb2N3MlFsVkxNcCtDYTM2NmFp?=
 =?utf-8?B?Tm5xVWtLQWRSR0JUVmRNUDA2d0hxKzZVNlRSMnJFd3RDclRCNjlHM3BEMnN5?=
 =?utf-8?B?RFZmY25aRXQraEFiQk5sMlV3ZSt1S29zVDVhb2ltbW1FMXNyakxobmFCeXF4?=
 =?utf-8?B?ZE1vSUhQS05JRytIWUpmYXQ2Y0k4WGJDMjZCT2RFbDVieXlnQ0MrWVZyZUkv?=
 =?utf-8?B?Szk2WFhxQkFHTzlyNC9HNytLUjR6YXZPT2MzUUdsUml0d2FRL3g4N3VQcm54?=
 =?utf-8?B?c3MraVZ3WTVIb3k3WDR1V2U0dWhwVVpTWXZvdysrbkVlQ3VPZGk5eTlBRTVk?=
 =?utf-8?B?bGdrNytjSnZkR251NEdpaDlacng2THVXWThkc1JnMFM1NHhPd0U4dlJLYzVx?=
 =?utf-8?B?Ynpyd1l4ZWJKOWN0aU5GTTEvOXNPTTNvTkkrNzZqSXdCZnZEV0VzdEpzdlVu?=
 =?utf-8?B?Tlhob2wvRW5yUEx6YXc5WC91d2RONUsrWjdkRlRUekVOSlV5QVY4RzRPS1FO?=
 =?utf-8?B?RzgyZXlGOWtWSUErRzREUFgwMVpXVUZYRGJKV0xCcWZCN1hHWkxxWVZkMmxP?=
 =?utf-8?B?eTdma1I0MFFKSFczWlB2S293OTZWcXFkbnAyUVJqN1dCNVlFeWVyMWRMUnpB?=
 =?utf-8?B?aG5neWJxem9zcEFJRThTaTI0MmVOSWI2QUlNSEhTNnZKY0JMWm4wTWk1MHR6?=
 =?utf-8?B?YjhLMVJERnl1ZmswT3VUVzljUnk0SktncVM1WitmVlNSNFRON2haNkxhYXJF?=
 =?utf-8?B?V3dSbGVxV0E1VGp5Zmw1dFN5S2xHeURSdFNkWUNyaWpYS3F6elVvZUNlWlFK?=
 =?utf-8?B?NkhZUks3UjlpS3lHTnNPSFduY2FYN0NKdFBBNEJsRi9QUXZzK2FydmNsNUJ6?=
 =?utf-8?B?Tys5RXliOS9uZmwyVkxxSTQrMUR3bmRpYXc2NC9wSzYySDRJK2ZiZWR4WWlF?=
 =?utf-8?B?U2RWNm1aNzJNY3FyckpnWE1GSlIxL05PaDRZWFRFNURaamNKbXFaZ1hhY3pq?=
 =?utf-8?B?UXVNTTg1U1l2Y2xVTy80a3VwWlpjY3NaZ1dYU3M4TkphTXJLTXRkYS9RMFBU?=
 =?utf-8?Q?mjYEKW8LwhverF2w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF7E63EF1DB391408A09A04E0BA605F6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QUp4SGaUzAXH0u/O1b0NnB90hUmJdDStOGZEG4RkxQ1hVUt3RH/+5qBpX7aksh7CCVWoo4bR24vsVfK5sMn5oktTwdiMxdrWsl4YzZwQ0su0ho1B0x5gjOwxhdGD1JtqlNqWpnnf1ADK7MHo56BPojnyztwgpRmWL0SkDMJpUZwcdc1B4GNVZd6oET+T+M5HwmNQCDjmTKbInAuVYfOAGa9qWxKAcE//AzO7hnrR8Ak6flbta92TWG8iZkbOGOddc8Gu/uQ76AcUO09+asC1/fTdeYsKXg6eVoZRlxSo1EOY/ej0tmEmUovN90iYyPiEXUf2AqJo8SeTuVKGeuc7/Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f947613a-52ea-4713-821d-08de74593daa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:32:56.8629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8nB0EEnTuzu07oH5kh7yjdy5wYa+IjKC71eEEHjgBFbo+zr6DG3/1dMGj+Tzl3xGrXTLz8yYWmKfkkEIqrmgOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR03MB8652
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFdoaWxlIHVmc19tdGtfd2FpdF9pZGxlIHN0YXRlIGhhcyBzb21lIGNvZGUgc21lbGxz
IGZvciBtZSAodGhlDQo+IFZTX0hDRV9CQVNFIGVhcmx5IGV4aXQgc2VlbXMgcmFjZXkgYXQgYmVz
dCksIGl0IGNhbiBzdGlsbCBiZW5lZml0DQo+IGZyb20NCj4gc29tZSBnZW5lcmFsIGNsZWFudXAg
dG8gbWFrZSB0aGUgY29kZSBmbG93IGxlc3MgY29udm9sdXRlZC4NCj4gDQo+IFVzZSB0aGUgaW9w
b2xsIGhlbHBlcnMsIGZvciBvbmUsIGFuZCBzcGVjaWZpY2FsbHkgdGhlIG9uZSB0aGF0IHNsZWVw
cw0KPiBhbmQgZG9lcyBub3QgYnVzeSBkZWxheSwgYXMgaXQncyBiZWluZyBkb25lIGZvciB1cCB0
byA1bXMuDQo+IA0KPiBUaGUgcmVnaXN0ZXIgcmVhZCBpcyBzcGxpdCBvdXQgdG8gYSBoZWxwZXIg
ZnVuY3Rpb24gdGhhdCBicmFuY2hlcw0KPiBiZXR3ZWVuIG5ldyBhbmQgb2xkIHN0eWxlIGZsb3cu
DQo+IA0KPiBFdmVyeSBjYWxsZWQgdXNlcyB0aGUgc2FtZSA1bXMgdGltZW91dCB2YWx1ZSwgc28g
dGhlcmUgaXMgbm8gcG9pbnQgaW4NCj4gbWFraW5nIHRoaXMgYSBwYXJhbWV0ZXIuIEp1c3QgYXNz
dW1lIGEgNW1zIHRpbWVvdXQgaW4gdGhlIGZ1bmN0aW9uLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFu
Z2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vDQo+IDxhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNv
bGxhYm9yYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xh
cy5mcmF0dGFyb2xpQGNvbGxhYm9yYS5jb20+DQoNCkhpIE5pY29sYXMsDQoNClRoZSBsb2dpYyBp
cyBxdWl0ZSBkaWZmZXJlbnQuDQoNClByZXZpb3VzbHksIHRoZSBjaGVjayB3YXM6DQpJZiAoc20g
Pj0gVlNfSElCX0VOVEVSKSBhbmQgKHNtIDw9IFZTX0hJQl9FWElUKSwgdGhlbiB3YWl0IGZvciBz
bSB0bw0KcmVhY2ggVlNfSENFX0JBU0UuDQpJZiBub3QgKCh2YWwgPCBWU19ISUJfRU5URVIpIGFu
ZCAodmFsID4gVlNfSElCX0VYSVQpKSwgdGhlbiBleGl0IHRoZQ0KbG9vcCBkaXJlY3RseS4NCg0K
Tm93LCB0aGUgbG9naWMgaXM6DQpJZiBzbSA9PSBWU19IQ0VfQkFTRSwgcmV0dXJuIDAuDQpJZiAo
c20gPj0gVlNfSElCX0VOVEVSKSBhbmQgKHNtIDw9IFZTX0hJQl9FWElUKSwgdGhlbiB3YWl0IGZv
ciBzbSB0byANCnRyYW5zaXRpb24gdG8gYW55IG90aGVyIHN0YXRlIGFuZCBleGl0IHRoZSBwb2xs
Lg0KDQpUaGFua3MNClBldGVyDQo=
