Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E84238F252;
	Wed,  3 Jun 2026 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780469731; cv=fail; b=jyvY7eVYJRtPhhlLwCwpHoD6CN/Z3nwkqv0beZhNGnp69pGdMWIHvHd+3OqOVm1rakSmIprrqUAueP7y2/2p+dq2fnyp96yIGZAO8JwfEEmmy7OEJcXKzuwJWDeLXWg1pKEuuoQuoi2TM6uJ04Kps7tNgkgi4Nkoakm1/foaD0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780469731; c=relaxed/simple;
	bh=rD5TxtoGTYnR3DPnN0BKMVpfQYbznpcuzcXxHa6BNeA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NbsRZp1GGXi7g/UhgytHat7S76rQLOhhNrGLhnZ5TvEU6xnA9PC18lXFIcIz7zQ76lCH6nicFmLTnnoXNyxcjtcwqvk4ufXgJHRDjPR4gV+E3SQKVIqdWHO0mUPmyZFrtMLnw623wg4RRZx5GJW4sZMz8EOtDUpk/kDY1EZl8Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IysLMdbV; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Re3dWQMY; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IysLMdbV";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Re3dWQMY"
X-UUID: 311de7225f1911f1b1788b6acf885367-20260603
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=rD5TxtoGTYnR3DPnN0BKMVpfQYbznpcuzcXxHa6BNeA=;
	b=IysLMdbV9q47PjeQ4qtqwklkyXP+ILjyMD0p9v4r7FtbfBl4tGsntz6WgEjTwnjbPjKuT1bH4T8h135R9N2FGyciJJBnwgEsZ//IKFEa8QOMSFCz6vJeZdaOjVJgeMFEmkwpFo6ua9+3IwE0vup7grKRt3zSH0Dt93BoS7okkAg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:06a76979-176a-4bd6-a0fa-01b002f0e4f0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:fa89b463-e3da-487e-921f-b403259724b4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 311de7225f1911f1b1788b6acf885367-20260603
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 529312026; Wed, 03 Jun 2026 14:55:22 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Jun 2026 14:55:21 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 3 Jun 2026 14:55:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vn/DbPPk9AXN2fu4OdginEAYA8ISc16a0hITnDkCzkwf1WJw9tsl0XE1AAMbgNYzJslFxSQaAfw8Tq4k4lVzkQJ0vBynKKCrUasEdqnNBju23/admbO3nkoSyiiq+V5MvBZbRjjdvqwC4tjSY7+0HSoihwrjrUYLbZ4ssIkYlA+RUFKr86zhzQkCAr5JLNAC+2cMAZLEhEqaW5KcsiF2zod3Iqpceq+s96ClXyTShnBUVgJakEdveVSWpG0fQ1iru9UiKL5WM5xG1vEQHsRHEGfXOKt7pZGgFgkoxGe4HIzmNbFpulHN8XFtg7IObYjJYRV9hN56nVNJ/Ozw0Dya/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD5TxtoGTYnR3DPnN0BKMVpfQYbznpcuzcXxHa6BNeA=;
 b=Kivt1TvwmAYNMeK+UcrFg3eOI/7iDSk1gN3rySgl/9ZDGZjPL4mJ/CC+ojzQqFPg0EQdUXlKEpBcWoCR2bmqsty5+bHt0yflgphF1HHyidMdqhbDlKwCrO/uflnQV+gFIJ2mLBl9wJCv5SRWH7waKRBDYf5qer8Aq7Bw4YsWqYicl2KXy9ckswqUFDK7KoamseeiTIc4K8JqSW6j3cXz73u/2aNOu5J9SlnIBULbccaSm6l1DfIJ+MnOB0Fb7IchngajKbXn9QvumdIETryItm3brIpvq3yIHw6PjXmH8qyNAQUMcNzm85t4sefWsZTw81rYD1HOfcenrv5bjQxxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD5TxtoGTYnR3DPnN0BKMVpfQYbznpcuzcXxHa6BNeA=;
 b=Re3dWQMYlRwTeoZpWohNe8yb59A4GOFuziE9JJIq0L7bxQd756nEVo7DvazZkdOPYVp0/Hq9C9plQtDT69jk1BfDZxtSoa1YzLywCJ5ttwhVcDKoytn9NI4pEih/bJwgusGfAy7+n2LS6Q9DwZCSI14tWSdztWzqQ4fYIbaVUyc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8532.apcprd03.prod.outlook.com (2603:1096:101:1fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 06:55:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 06:55:16 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "hongjiefang@asrmicro.com"
	<hongjiefang@asrmicro.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Topic: [PATCH v4] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Index: AQHc8o1A3BWLkA6ncUmhT2LgQSEKpbYsZsGA
Date: Wed, 3 Jun 2026 06:55:16 +0000
Message-ID: <7404d3067b87d33bb446a1b7f4432b5ae9d98486.camel@mediatek.com>
References: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
In-Reply-To: <20260602124103.1581617-1-hongjiefang@asrmicro.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8532:EE_
x-ms-office365-filtering-correlation-id: 2cf46f2f-76a3-4db0-baf1-08dec13d1172
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|11063799006|56012099006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: gtE8Z8dATSTYKF7/CikttjLTh/8juDWj2ctBHz4emVmARlzNYqwFbU+pwhcivP7e6rhXZYh8jt66haP64JqVk/8rEG1bOJ9TSs3fL1TpDc7ZNsPO9/6Xk7s3cTTroqjV6cs72W+7HTViEHcIzdpKfve0C6M3cRPE88QcahWd1tw1UZ69BsrH2OCadANuPQ500ySEO4pm0SIKn7U37F3D6DUwYsLBSB5zXrgSpPK0vF6InMoVW85ZjpJ62ESAyWKm8wSKLZaPEF3L1tGMpAC89E9+yDdHOHtQALP9VtzzlM4MHcyh3VlGOmvIyX/AXARWn+AMYo1zPQ2M92jsQH/NI1pI3MXvEETAXEPEBWZbz375Ygzy8Ch24iOEV7stUpxs8BUSYXsgazMg9feccMejimWlGrxMhDrmHEIhl7SihNZMA5gWju8t2Sm6WvOIbAonHswUQBMEdSWdty2lAqsi4NFoOhUEzopJgwHABsgMds4ndMc1goBe35oUCZsklDHxYJh4SWztvEH9sWYnQ8jEbqjDpmri5+usDjqN/Kn6vCg+UEjl9XkaBr8a8dv5HBDrGfB57uDF4I2NLxEXehDjzQFFGUGDpLJ0G9ChBWgYYNt85FheUq+fOdTiXdFR2Ytli6T7z9VD47Rx8K/MVP8ap7kceW3/KZEuYh9xoQc3UeIzrRI0bVlZrEvlYXay4MRPOKTBD40oeSF/RJTey+nRukBttZZCCCSNIPJ5tVcU9D4S+iszf3jAqoAu2zdKNTuK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(11063799006)(56012099006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUxUL2xCSld6bURIQmVvREppZHM2N1RSRU91YVlDS2p1QWgwamN2UkJxMm8y?=
 =?utf-8?B?SHFhdWZqaHpvTDNMSVVIKzBNN0Z5dzZjZXN0QTlhaHpDZ3lGSUdrWHZTYlYr?=
 =?utf-8?B?clRmT3lZZmF3K0kxVEJBZ2lMWFRtRjM4R0pIVHV0cU5xZStVcElXN0pKd1dW?=
 =?utf-8?B?QmRWWnk4RFNWQWsyQStHbnpzVC8rbUFLU3UrNFpZdnBEK2xLeDlISEVqb1NN?=
 =?utf-8?B?cHB0V0RLSDZCamdsRWt4WkFDOVBidlBaRVNoK29GZ09YVjI2UTR2T2NNT01K?=
 =?utf-8?B?VGJMTXlmbDRiTG4wWlpNeVpCNGJPYUhYV2Q5eEJrL0FjK3l4SXQraXVUNk9G?=
 =?utf-8?B?WTR2N29Bb2l1U0NhY1JLMzA2VVZRdFZ5em5YWFFhVk5oYmVWbEllOGVJRDlj?=
 =?utf-8?B?NlR3TVdaN3d2dG94NWRFL0tGVDJKS2RqVklsbGVvbnBpbkV6ZDQzaTZFQVp2?=
 =?utf-8?B?c3FVUDhZYm5tVEVsdTVIMnAzdTZWTjFDR1puNFdadVdHV2U2RHZweFNhVjQw?=
 =?utf-8?B?V1V0VFlBNUVsRmZkTkVLbGNGbHFhSEY4OHk5MTIraGJqTnlrU2dvVzdoYkQw?=
 =?utf-8?B?RFhCMGlqRjhmbVRRbE1Oa1JsQ3A1UU9DU09RL1lPV1ZJVmFsMHZyZFdsRlJi?=
 =?utf-8?B?RCs2a3NDZTBUMWpXTVlaQ3ZaTU9HbWZEQVpQRHF6c3VNSVZ4WVNmZnZPY2lN?=
 =?utf-8?B?c0lneWRodG5pWFE2R1BRZU5ReWVBVCtpWUpsUG90TnRyYjlzZjFKYUtrY0F2?=
 =?utf-8?B?WThhWUI3RTZpVnRiUjh6OWtiU1NKM3FWc0ZPZ0lxVWJQNEF6WVQ2RWVzaXRM?=
 =?utf-8?B?SkxURHVFYWZMR1BkQ3kxK0xkeFliSDM4OWR0cmRTR1lvKzZPam9GMk1qajNW?=
 =?utf-8?B?N2JGeWlFQXUrT1FFTFl2dTdnQUpnKzZONW1mL1k5UHZIUE9kUkU1S0srVjZE?=
 =?utf-8?B?bHFiRTlaTUxFWUJib2dkTmRvMzhKeGVCVjlsSjBnRU1XRFlhNWhoWlAyTjQr?=
 =?utf-8?B?emlXYVdRNCtXazAyK3kzMVFlaTkxZFYxeUYvUFBPNjQ5UDlTa0l1ZWhNYWpD?=
 =?utf-8?B?eFU5aGZiaEJ1Q1B4cVJ5ZWFZbzFhYW0zTDNpVDhlbUQ3c25JTGpXTkkxbnRm?=
 =?utf-8?B?VVF6enhnQTdTL2FlSGE1Y2JVZDQ4NG9ZbTBCQlBqQTZJZVZndW9ZY0VTMVA0?=
 =?utf-8?B?RnI3OWRGVTBqMzIyNzNleEFtT1lBbXZoSXBVaWFSMXZ1MVc3YUF0QnI1aktQ?=
 =?utf-8?B?MENPZWJ5anFpWUZOL05Zc1ZmVUI1VEd4d2Q5MlJSUEl5OVVra0o1UWZpYnJm?=
 =?utf-8?B?SS9DZjh6Z2FweVJNak4xcFpWYTJtRGZ4N0l6ZmNIQzROdGE4SlpSS3o3OEd6?=
 =?utf-8?B?eVA2cDl3RW9kZkNGR0hET0w4a1pFNFJ2cWMxVklNZUFVYjdFNktmQ011d2FV?=
 =?utf-8?B?a1lUUkMxaFJHN0RwRHhWUVVING9WazhYY0Y0MUlIUUFSYlU5dkVnS2ZJZk9H?=
 =?utf-8?B?bVM1N0dYckxRMUVISm91dVkvRGN2blIySTRVYzB6eXRDOGFCZHpUTHBrRkw0?=
 =?utf-8?B?RDNzdjBMM0xrU2RESTBIZ1VyTGNYVzFQeDJyUXZRSGNDM3kzWjMvN3U2Snpm?=
 =?utf-8?B?bXZ1ZC85K09SRll2SmYyNGRxMlEwZzNVblZuS2paSVE2a2xUekV1cUVQbWhp?=
 =?utf-8?B?SHF2R0NxdEU0MnF5dnBxcDVPcWJLcGdHWGJ3ejl5NmxqTTBIWGttN0VvaHVh?=
 =?utf-8?B?WForbUwzOUFaTVdhWEY2SERwOVF5NXBFYzBUWUxLeUtycFpuRzJyMGJUUjhk?=
 =?utf-8?B?d2lOU0xrN3gydnBURDRCb3ZLY3hZc1dvbjBLa09Pcnd3SmhIdDlIejlyY2RB?=
 =?utf-8?B?L2lHQTBodHl0aGw2bWMycFVEcUpLbFMwb1ltSHhDVVVCZDZscG1zNkFVSVgx?=
 =?utf-8?B?SFVxUWFLdlAxVzJvN1NrbThSc1FKNnU5cDlUQnI1UHpyL0YzV1ZhbnVyaVht?=
 =?utf-8?B?cmRURUdiQTNYeWZMTmN3Z2ZmWTh3N1Z0VFI5VW5GZDF4TEpmQThLTEp5MFVX?=
 =?utf-8?B?YkZQdURjVk41UjJvY0JiTmhGMXBZeHVvVE5kV2ZiN25DVlhOOUNyZHZlTXEw?=
 =?utf-8?B?djcxRVNobDJzaDlaT25KWDhDTFNrMy9jZDY4OW5ja1pBVEpwTURTZnJLblZw?=
 =?utf-8?B?dThnRGs0NXlIR3d5SGtleVlVbG82Z2VJNXpyVW91VmZjODA2TGtubWlpVlF1?=
 =?utf-8?B?TWdLZHJhTCtabUk1aWJOT3hhbFpWMmx0aThrc3J5dE55b0RaQ0o1Qzl2MkJT?=
 =?utf-8?B?Q1NUbDNxeWhicVVTbUJuRDhTTFljZ3pHVUQ5WGZNelZxM2d3aEJQQlo4aFVj?=
 =?utf-8?Q?H70teodir9Ni5Hl0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D557A2B2C0A3BE4BABFD8175E53A9E76@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: i+n9SCuik0ABfwKlreGwQ18bLDQ8xLOtAKiCMIQruNBHhHXlm1KHD878gt19FPDmVAoz6VwF4we1dmfvUUbtoJTGgr5/Ok9g3LUes7ooHOWn0X6sozbwTmU+uT0DFNzr7jFcHQf35BD0vve7VpUY88FIXdU2w0UQCrT2TwcPIvdsBpeY7QGuGbjDPjb1WVjek7+8JBkSBa2S/yznTz22BOCcees42zkwOFjKV9CAu6L3zprVroNSEBBxmyYhKTnsL7pM/XW9Sb/xy9WW0AHE+OqDZZB+tcfrSJiynJ/TgU4I6zy98yphAWSJqhB/NAeqHo4vkk29Nm3mNytrO6SPZQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf46f2f-76a3-4db0-baf1-08dec13d1172
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2026 06:55:16.2787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hXOY9m1h0A7G/pgI1z/KxYll1S4hBLdPXk1FFjCXYSOr2QSW19rKq7bwU9HiB24NWWkiDzF3+bAzUT/p9dEOPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8532
X-MTK: N

T24gVHVlLCAyMDI2LTA2LTAyIGF0IDIwOjQxICswODAwLCBIb25namllIEZhbmcgd3JvdGU6Cj4g
K8KgwqDCoMKgwqDCoCAvKgo+ICvCoMKgwqDCoMKgwqDCoCAqIHVmc2hjZF9saW5rX3JlY292ZXJ5
KCkgbWF5IGFscmVhZHkgaGF2ZSBjb21wbGV0ZWQgQHNjbWQsCj4gZS5nLiB2aWEKPiArwqDCoMKg
wqDCoMKgwqAgKiB0aGUgZXhpc3RpbmcgTUNRIGZvcmNlLWNvbXBsZXRpb24gcGF0aC4KPiArwqDC
oMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgIGlmICghdGVzdF9iaXQoU0NNRF9TVEFURV9D
T01QTEVURSwgJnNjbWQtPnN0YXRlKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGlmICghaGJhLT5tY3FfZW5hYmxlZCkgewo+IAoKSGkgSG9uZ2ppZSwKCk1DUSB3aWxsIGNvbXBs
ZXRlIGFsbCB1bmNvbXBsZXRlZCBzY21kIGJ5IHNldHRpbmcgZm9yY2VfY29tcGwuCkhlbmNlLCBp
ZiB0aGVyZSBhcmUgc3RpbGwgdW5jb21wbGV0ZWQgc2NtZCwgaXQgc2hvdWxkIGJlwqAKaW4gbGVn
YWN5IG1vZGUsIGFuZCB0aGVyZSBpcyBubyBuZWVkIHRvIGNoZWNrwqAKaWYgKCFoYmEtPm1jcV9l
bmFibGVkKSwgcmlnaHQ/CgoKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgdW5zaWduZWQgbG9uZyBmbGFnczsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHJlcXVlc3QgKnJxID0gc2NzaV9jbWRfdG9fcnEo
c2NtZCk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzcGluX2xvY2tfaXJxc2F2ZSgmaGJhLT5vdXRzdGFuZGluZ19sb2NrLAo+IGZsYWdzKTsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19jbGVhcl9iaXQo
cnEtPnRhZywgJmhiYS0+b3V0c3RhbmRpbmdfcmVxcyk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhiYS0KPiA+
b3V0c3RhbmRpbmdfbG9jaywgZmxhZ3MpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IH0KPiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2hvc3RfYnl0ZShzY21k
LCBESURfVElNRV9PVVQpOwo+IAoKV2h5IGRvZXMgTUNRIG1vZGUgc2V0IERJRF9SRVFVRVVFLCB3
aGlsZSBsZWdhY3kgbW9kZSBzZXRzIERJRF9USU1FX09VVD8KClRoYW5rcwpQZXRlcgoK
