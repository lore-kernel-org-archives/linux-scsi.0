Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4F715E97;
	Tue, 14 Oct 2025 02:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760407644; cv=fail; b=tuTeeK9hp8epLQpJoIjgOE/AGcnJzoJf6mnxj981qbwJr2E0wvHpSu1g3EHY0+7ek1LTpKtZsK6n0xkkmsw4MnlaOH8a5ZsK8Cey//FQ6wbNYBRZucczTK1NCicPH4oZiHbQRJpfuT+noxI7YI0d2pi0uYuXEwXVxFwBic4/NEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760407644; c=relaxed/simple;
	bh=u/i7cs+XSwx/IuRh8BRRdMnhhH6lkF5ZoR+232ORbzU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WU/ieNo6yr8RaR3fPHAbHlfuQbhS0L78VqOTHPUIV5+wHKh7jZudjw9WqOZiIfqPY/jVnvkoT/MXF+uTlvKv4oqrywQfWuCKVOjQVG/ZcBW6nVVa3eObr1gExzX0xgA8g2+HP5BL/PNSEO0xbSj17jxeZcuweHtrv3cvasFj4uU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rvMgLln1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=DSCwrWF+; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rvMgLln1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="DSCwrWF+"
X-UUID: 82c3fe00a8a211f0ae1e63ff8927bad3-20251014
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=u/i7cs+XSwx/IuRh8BRRdMnhhH6lkF5ZoR+232ORbzU=;
	b=rvMgLln1ikhJkXXO7FkvHTLIO0iffqfniDhoOoUUDTWYWef+btHWpC1xdM+nPr2r9GNsvgkT1oMBgTspc2uxOjV5KAgPg21/J6cFd3ULX0iRC6ZZvLDwZ+BjE3gJAt6nj/k46Pmql+vPqykN7D/uopj0w2nt0kXlYOdcQqlMITY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:c36d7993-c39e-4412-9974-b66dc7bdad7d,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:3a355a02-eaf8-4c8c-94de-0bc39887e077,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 82c3fe00a8a211f0ae1e63ff8927bad3-20251014
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1491833214; Tue, 14 Oct 2025 10:07:18 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Oct 2025 10:07:16 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 14 Oct 2025 10:07:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYSqiGBT4/a6LfOIPABmAutFrXDXEyCjiVsW7Hs2QV+sUrR0S6AJG+DcJlEHFVy4ehX2Tnzh+tmxL9K06i6zTm3GjDaZs24XLIUhWOZ52OQHbmXs8FySttlhHZpiKVq+Odn7F1NSwiwdbd2DHDsWn7jSEJSAzPl1ooa23P1iBVMfV2RW7ZDv1My94900lGd3fPj3XTaRSszgxbz1HOnF1/15tsPmjP1ScvIePiJwSiF+WaonT6IlWjR9CPDGgp6WzH2m+OaTNpm+xanbzRGhXZedV9AcJnmFELYmMcWbgsJSG+fqC8TD/4TJe8IFapBlIRauFq/7dxEASm+ndsZWIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/i7cs+XSwx/IuRh8BRRdMnhhH6lkF5ZoR+232ORbzU=;
 b=UhL44hTvPgJVVjGMpM8O76aZcgpKsK+Ex5utMFuqzfGGcoqj7m8r8Ni+41mTJ84kN42Bh7MyxkYE4y/9mA94aAVT3fWjiHHxCXn/EAv0D7NffDdkJKGJX3WSQMRTr+NupeAOiqnFiU9GBN8l9FCI9+TivsORtICdzdm0/sF6Gk+bihZk8DCAi2Lj1GSCR4FicCxYoKxz8ZgGUrG78yphaDEMNKZF/vDAr07CeYJnsLxiJf81ArnjMzfw2xVyJwEj6DZCYITZfghSpUfCqVACO93slvXb2Qhx/F6pgDkiBjyjP7D6qx/CImD4laJrGGkBLShgIkE3PhKGe0visYfw5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/i7cs+XSwx/IuRh8BRRdMnhhH6lkF5ZoR+232ORbzU=;
 b=DSCwrWF+01cY9aw1I4JvpkUwMtHUPOIQ/60woY0+MNovN3nawuiuMKus8huBX8gfinICqRHpZw36dE0yAjyU/lY6BOprjbQbxyNp5QKxRoNTjF9PyWeRNP4dvDueX0AfNhZVsPuLnFuIWjYOhyB7f2eYDaZccuyPtpny3W/Ckws=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8212.apcprd03.prod.outlook.com (2603:1096:990:44::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 02:07:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Tue, 14 Oct 2025
 02:07:14 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "ebiggers@kernel.org"
	<ebiggers@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] scsi: ufs: core: Replace hard coded vcc-off delay
 with a variable
Thread-Topic: [PATCH v3 2/2] scsi: ufs: core: Replace hard coded vcc-off delay
 with a variable
Thread-Index: AQHcPHkfJQP+7X5NpECHbYJ3FXlCQbTA5ZCA
Date: Tue, 14 Oct 2025 02:07:14 +0000
Message-ID: <029cdc3ae16fd669a862cf49a9e082561582aacb.camel@mediatek.com>
References: <cover.1760383740.git.quic_nguyenb@quicinc.com>
	 <72fa649406a0bf02271575b7d58f22c968aa5d7e.1760383740.git.quic_nguyenb@quicinc.com>
In-Reply-To: <72fa649406a0bf02271575b7d58f22c968aa5d7e.1760383740.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8212:EE_
x-ms-office365-filtering-correlation-id: 59cf5f4f-2b71-4828-f1a9-08de0ac664ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?T1I2T3ZIcFEzMjRNeENzQWNGaHIrRzNBRm9CS3hrcnRuU0dyejNHR3QySnZy?=
 =?utf-8?B?Mmh5WEdrOU9KNnZ6Um9kdjlRdzVNOWNvSWpmeW1FK2ZZYUxyMjhyZ24rK0lh?=
 =?utf-8?B?aElRK3hlaVJjcW5uYnJJZWNxeGNBZVpKOHcyUzFZZFZvc0c2Y1F4b0FDc3ZM?=
 =?utf-8?B?MjZmaGR4bjZzYXJCVWdtNjhYa2JxNTNJUVRqcE4ydUlXRDdLNWd5THBxWWRl?=
 =?utf-8?B?RmRVVWpWWFEyMVkxeEd1YjVURVJuZ1dTN1lYcEF6WjYydGllNU1TRXNTWlFM?=
 =?utf-8?B?UWd1UUNZNkFHaHRBNk9HZ00xMzNGWG5FZVpwL0JhWW1PS0Q1VFZna1V5UFdY?=
 =?utf-8?B?dE5tdno0RTNsckxpb0tGN0pZOGJIckpZWGJqaG5SdFEwalBvWnZscmt3eU1z?=
 =?utf-8?B?ZFNzQUZ5VFQzUnpnaFZlRHUxOXo2bDRxVk1kQmtCajQxR04ySVF6NGVyM1ZK?=
 =?utf-8?B?M3ZLdFg1RFlUT2FmK1MrSUROd05MVzNtZTEyWlFoRVdrUmNuMy9oMDgzRGZa?=
 =?utf-8?B?cHdMcU44SkoxNXFWSkZPR2tOcW9LWDlBRWdHZkVQaWVkUUN3V29laU5lODBI?=
 =?utf-8?B?TlRsN1ozakUvdCt1T2kzM2JWN0ROdU1qd0N4RUlFZU5vU0EyQlh4dUEyWXNj?=
 =?utf-8?B?WkJycGI5Rks4cTl3YXVLck5kL25nSlJyRG9DTnczV0lXcWJUWTB3TGhxdVRN?=
 =?utf-8?B?TEVYQkVYSkIzb0h3eDNiTVc5RXRDSFQzc1V3R0wzcUdqVWpzR3pGNlVvM0Qy?=
 =?utf-8?B?OUJPRkJNaURiUTZJb0g5azB1TG9hSzRIUU16cXZMWXp1Yy92b1c4K3ZrL21r?=
 =?utf-8?B?L3NUbUtWL3pMakN2dEJ5Q1U2VXRhTGRscWJpRjZPWFBvN0xpbnFKOHpndlZC?=
 =?utf-8?B?RjVjLzZUZFluQ29hbmdJcjNwdlFOMTY1VGRSY3ZGUGNPWUtqTTVJSHJYdXBx?=
 =?utf-8?B?TzFsYjdlV2JLU285Y1FOUUppZXlmd0Z5MCtsOFEvNFhaZFR6eFpUZDFYQ2I2?=
 =?utf-8?B?K3E3SzhvbUJQVkI3ZW9pTWRuVGpUQWlxQkJZTm9LOUZUdzMrVmxEWVpaOUNt?=
 =?utf-8?B?OW9qdzhHY3I3cFdZU3ZSbnBHRXB6WU45UXc1UGVmbFRxWmgyZUlWcmszNTNm?=
 =?utf-8?B?Wjk5ZTVManFwV3hNQUd0ZVNHWEZKOFEzRFY5ZUJHTU4wTFJCNGNRc3ZaZmVz?=
 =?utf-8?B?WVRwaEdsQVhXYzBJcG50alhJNnJnSVo5bk9SbGlnTDJabzFZbnJxcjgxa1Ro?=
 =?utf-8?B?bGJCTDg1QVk2WEtBcU9ESEhhbGNmTG1jaHdBd1NJMFlpbld5STFxYWExTlFz?=
 =?utf-8?B?TllFRVB3OTRkaEFONjhWTFVpTEdGY2g5eTd3ZlB0ekpKV0VXMEtOUGxZN2FM?=
 =?utf-8?B?SEJSTDdCc3h6TkM0Zm9OY1E4S2c1aFdySFJkaXorL01pQm11cCttVzVqZ2pM?=
 =?utf-8?B?RmkrSEVTLzhkNEZqUkl0aFM5eCt4anlZUTZNN2xaYm9uZDB0SzQ4bTdZblE1?=
 =?utf-8?B?a1N2SXdBR1pjeUFXMjY5all2VXlIVlNZYWVwRjFMUm5RbkF5YVJVVzB6VFlP?=
 =?utf-8?B?N0NCOHZ0a2M1ZGdsVWhwTmtqUngyVTlmaHYwck5UVHVYWjd1SDV0dWp1bC9q?=
 =?utf-8?B?SzJKRk4zYSt3UFI0azV0eStFczE2TTdqREdqK2FoOTlMMDdhcFlJeUx0cmlP?=
 =?utf-8?B?V0lKeHZicVlDUXFMQXBTTnA3V2lPUHFtQWR6S3pueWhIS0tuUjdMQjJPVmJU?=
 =?utf-8?B?QkVIdHVtWkgwd21pN2hsR1VKaEp1MGZ3cnVWWGRURjVpa0NWa1NFTTdrNUND?=
 =?utf-8?B?MW1rNUwxSEdIMkczaHc3QXVCa0VBUU82Z1pET09XVTdZcFlwL2ZZeUR1SlFO?=
 =?utf-8?B?aVhuRGRBLzZXSnJNQ1NTakdyUnl3b1pnRjdCUmVJRldZK2ZHWlc3THB0cHI1?=
 =?utf-8?B?Qy9GOFFQZmlCWHMyaU9sL1AyeUZrK0c5NDdNRkZIL3VXL3pXVjVSUHZDTHFv?=
 =?utf-8?B?c3V1c0ZtWWtQVVU4WTk2YVJrV2FBaytIUDArZFJXMXBSU3NYNnlsZ3lQd1Mx?=
 =?utf-8?Q?9bZKDD?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzVleXpRQWw4RCtzQ3gzaTJkMXN5NlJDNDRNOWh5Tk1tVklNbDRKcTlycnhU?=
 =?utf-8?B?M1N6YThrOVFkMzV0Z3hmai9mOU1CaG5ZQmlDdnNPTDZKMzgyMExFcVZYNzgz?=
 =?utf-8?B?dlV0NTVJbGxhRWMzaFBjU0NIYVp0T25CTmE0bXpIZ0ZPUm5EVlNNd21XcXFU?=
 =?utf-8?B?aUtQakU0YW9ZTU5yRWsvS3ZySWptSm05M2lKWFRMdnFJc3V4cWtUdXpjZTE5?=
 =?utf-8?B?NGs0Q09UbENMR1d6b2pYQnV1eWpIWlVnZEw4MDBHYjVnTjZndkdNbUhvTnUw?=
 =?utf-8?B?NTJRRktBUHB5RDl4QkRyZHM4Yzl4SmRYTmJqdTJoN3ZBZU5RZU1nWUNydzU2?=
 =?utf-8?B?UGcwUmNqbWVTWmF1amtxV1kyQnd0aHFvZDBmQk15bGZEbzFCQmcvdUVtcUgv?=
 =?utf-8?B?WXQ5eDVJTXpSdVk2UTRkRjVNbXNNWkRBYWY5THZFODZ0QUROTUZrcjZ3aXpk?=
 =?utf-8?B?Ryt4ekpPcy9wVEd5bE5IeUlJaGR6QWZUaFhmbjlEVm9IWGNmOUFwRVpHR3FY?=
 =?utf-8?B?U1pwSC8wWDU2VFlZWlFFbHJjRERnVVFuV3JkcHdmZllWSXF4WlNvTVJlQjlp?=
 =?utf-8?B?S1A2MEl6QVpRa001dTA4eHg5N1VwZUF1dUo2RU94NkR6SmFYNnVvcWgvUjZR?=
 =?utf-8?B?VFExdmZSb1hhL3M5c2MxQkxzOTJtV0V0cCt3RG9DT3d3dEx6Sk5TM1lwZzFs?=
 =?utf-8?B?bTBIZUdKSmlTcWVzTDZpWnd4OGNJRUxvWW1Fb1REZEJBclpjQ3JTMEc5Zy92?=
 =?utf-8?B?OFRJcnFEdGxFSk1RMy9YSEJmV1BURG9iZHBML3FQay9ucUJsOTY4dEpCcHJ0?=
 =?utf-8?B?MHgzTnE3aXU1bC9rdFVmSUxhSGZLSitDRmxhdFNtQ1J5dGNQMUtmUGlwTzVk?=
 =?utf-8?B?dko2UWhJRWxKVSt4SnV1eHdlaXhoa0lZSEd4aGxMaVFNNFB6ejFoS0F2dTBm?=
 =?utf-8?B?UEZ3eDJsMUlseXJGZlB4aHNmZDRwRVQwSDd3U2Z1TW01Q2lCK3V1Q1YzY0I4?=
 =?utf-8?B?VzJiT0Z0a1F3bWd5SWtMUkpSRHlJM2JwNU9mdng0bjdOMU1uMy9OQWtvMFdD?=
 =?utf-8?B?TUw1MDJBRDNtU05XTTQ2NERpdTFOWWdsNk9LSmpLQTd4UEpWbGpkdFRlSm93?=
 =?utf-8?B?Ulozb0xZdDQrMVBOdHBqT0FYK2hPYUlCMkZ1Q1pmS0tHZDYzaWtPcUNhT1dx?=
 =?utf-8?B?NnQ3VW94VXAyWlhOY1ZVd21UYlU4bmgrKzY0Ly9peHZFN1VUdmE1ZFNLZ09H?=
 =?utf-8?B?andTYmdLM2xVTnAxd0NieDhZcUdDdm9KR1NrWUJHSnh4WjM2TkhoeFJFWURk?=
 =?utf-8?B?dUZZNzdCdy96d0JqRUNoTHA4ZHFRUUN1dlF2TCt5TzVpczZoc0lUSG5HTGxJ?=
 =?utf-8?B?d2M2TXVPdElZa2xPV1cwZE9sTG5zaFBYRVBVY3hIbFdFbXdRUUdtdjl6NWxs?=
 =?utf-8?B?UjBhSWVyM1V2azlkOTNvdmdOSTVsSlZielNoYXNWbE9CcHJRMnQ0RDREcXJi?=
 =?utf-8?B?NGpVSU9GQ09ESGF6QkkvNXBoM1hLS2wzZEp2Tzd4RzVXNFpNdWMxZTVFTU5Q?=
 =?utf-8?B?b3dHWEN0TWpra2lyL0M4dzJTR3A4eGxzL3dLVFoxSEZTT0JVeDgzRDIvWmRv?=
 =?utf-8?B?NTdqbWpqRFRaaWlUZk9QOUh3VVZZaGg2cGNXSzlYVkVic1VxV041dS9WOWxK?=
 =?utf-8?B?bk4wMnRkWWdiUStkc3RDVUZlZElZTTdGQmk2YStsTi92U0pYRVJsZi9YWWZh?=
 =?utf-8?B?K3F6K2pjYmFOVmx0Y2VZYWh4TFMrdUt2OE5JUXQrYXdVUWM1a3RtSXovL3I4?=
 =?utf-8?B?aENnaEFkdENDdUpCZXlienRYZmZPdW1Kdm0rcm5WNFAweTROZjFwY1M4bm1H?=
 =?utf-8?B?aDBVVnQyVDBDSm9ocFVXa1VCRzVNYndOQkVyU1lKazVZSU82NEJTa1R4MmQr?=
 =?utf-8?B?Y2ZRRURHU0NlSjh3OFV6RUZadkgvR2RqeTlKQ2krdzNLSVF3SGR1bCs5dlow?=
 =?utf-8?B?WjZ4VHp3dEkvN3pvODNzQVJ0UkxIUlZ1T1RBWkVoeWMwTTBlaFdBdFFmL3lz?=
 =?utf-8?B?Qm9tMk5YdzNSZnQ2TFE5ZEVzUFRwZlAvdnlGZ1N0R1J2dVh5ZSs4RHo0N0ZG?=
 =?utf-8?B?V0pVRVdNYmIwb3lKZlNOWWRGWTAyYlhzSEVPanpkWVYrbzhTK2lWczVIbzBt?=
 =?utf-8?B?amc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB254CD3B5BF8F4FA3CE13E840F75126@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cf5f4f-2b71-4828-f1a9-08de0ac664ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 02:07:14.3704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AbsSilnQRjzKh7ObggidQGccaKRWEYgBiwvMqoN9aeVMFQRkfsRb9xUyungQMrnxRonCLUF5RuZXQB+j6Vghcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8212

T24gTW9uLCAyMDI1LTEwLTEzIGF0IDEyOjM4IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiBBZnRlciB0aGUgdWZzIGRldmljZSB2Y2MgaXMgcG93ZXJlZCBvZmYsIGFsbCB0aGUgdWZzIGRl
dmljZQ0KPiBtYW51ZmFjdHVyZXJzIHJlcXVpcmUgYSBtaW5pbXVtIG9mIDFtcyBvZiBwb3dlci1v
ZmYgdGltZSBiZWZvcmUNCj4gdmNjIGNhbiBiZSBwb3dlcmVkIG9uIGFnYWluLiBUaGlzIHJlcXVp
cmVtZW50IGhhcyBiZWVuIHZlcmlmaWVkDQo+IHdpdGggYWxsIHRoZSB1ZnMgZGV2aWNlIG1hbnVm
YWN0dXJlcidzIGRhdGFzaGVldHMuDQo+IA0KPiBSZXBsYWNlIHRoZSBoYXJkIGNvZGVkIDVtcyBk
ZWxheSB3aXRoIGEgdmFyaWFibGUgd2l0aCBhIGRlZmF1bHQNCj4gc2V0dGluZyBvZiAybXMgdG8g
aW1wcm92ZSB0aGUgc3lzdGVtIHJlc3VtZSBsYXRlbmN5LiBUaGUgcGxhdGZvcm0NCj4gZHJpdmVy
cyBjYW4gb3ZlcnJpZGUgdGhpcyBzZXR0aW5nIGFzIG5lZWRlZC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEJhbyBELiBOZ3V5ZW4gPHF1aWNfbmd1eWVuYkBxdWljaW5jLmNvbT4NCj4gUmV2aWV3ZWQt
Ynk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KDQpSZXZpZXdlZC1ieTog
UGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
