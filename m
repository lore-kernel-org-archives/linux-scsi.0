Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD29E3B27FA;
	Mon,  8 Jun 2026 08:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780908719; cv=fail; b=p0Y/MKcbd454g7fyr1AtaLF7JRHc8X7oUyJjPXgln3JYVnEPVdW3BpwvuqfPhb6jQISBXwrnnocKa5pQ8afPPTZKfPETqb08NyQKghtRzUvNlURWDArq9diX95bUOMtTw6gb/a16Fjbil2AFTV7OE/EZLe6Aapaoy+oW6lpE+bM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780908719; c=relaxed/simple;
	bh=BqO+VK0sV+h5GlMsvLT8f8GG4/FHmAWf9okvLy8BkAg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bmvOCSvEXx3fJi71UZi4hqklgYicgGosNCe/0uEoAOF9Wf1uizqVLk8lkvThgo6zqGFoXw7/lsF0iP5ztYy7pNgSw6/M43hBSBYdqDJYqrbTrxhxQhtSV9B6EK4OAfFqbfuZFCm2ki71QjIxiQb1oAcn45HIH9OZRE4AUyU/lfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Hbl+4cfa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=FfYZpTZ/; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Hbl+4cfa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="FfYZpTZ/"
X-UUID: 44da4b3c631711f18dc8c9802ae25ab1-20260608
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=BqO+VK0sV+h5GlMsvLT8f8GG4/FHmAWf9okvLy8BkAg=;
	b=Hbl+4cfaQxIqenNecSCzVUBoULK7tEyF/FzLaD+75NH5QY2UpQ4q03OzurZDfw9/xTyGBlk8UPPIdi0io/0cbFJVz11P+it8X1qX3TAVtw0FmCRw7CZ95itb/Qop+qkGXBf8RWhuIHTAQy8FoJh+dqQEMHErkIOjkHpIvqYoCgg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:c996dcf8-c3c1-4280-a0a7-9eb6d21f34d6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:9b99cfa4-9ef7-4489-861a-e83b251ece46,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 44da4b3c631711f18dc8c9802ae25ab1-20260608
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 262255663; Mon, 08 Jun 2026 16:51:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Jun 2026 16:51:40 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 8 Jun 2026 16:51:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pczsoO3Loh9tEZOyqp/dC6pJ2zC39zwa2rrWSSqPYDKljZEiHaJJ1/Vi/6JUfIxViDJdFN2rZYN5y+SFG0rPxMEwzanWZ55M1T5lviWj/yQb1zbSF0ZYjKUV+hnCunb4aAx505CwTddhBZWup3JErD8kLBwejaWURMYkC2bUXgo8EBhHRAVNwxjZJuEHTrj3h8d0GWNGq6bHjJkf8dw/+iYzXzEkT8HOadV14e6LrDPuKr+2duNYJ6jRG5htyGv5Jl8FasH4aR+Zc8++43tCBVNZyYuYCeFHy+7i/sRDNo5rqK8iESiGM/A7h8lcRLJYsvrB7+KpGyMHyGYE7FOaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqO+VK0sV+h5GlMsvLT8f8GG4/FHmAWf9okvLy8BkAg=;
 b=cdHoseBws8WcG7g5TvWfgOw+dMyt4OU8InjJKs5hmIdSfL2V6b8Vh4LiF4Ysa4Uk/dMMyuGvF7q8X5y0WIvAQK2Sp8RI2brjn5sfI04rE0tOiM4LenrQwjDQNIqEQvD4WIvKShrsgUKqMZZTGMVheW3xJO1W6RUfgpxHNnVPeU8zQJycFZeso6/8z9qBjwDEDFQymP6pHIIfwbkH2nVPRzSjEaf/BdIbFVe8nnT25IP500Z9sR4KZ1YgOrx6Hx1dBxGpE7te1wA648kWhvZiITdGPB5Wc1yzPQQHDU3oaiIoO1BXCbhBX4rYNJF9icQ2eiewtBIisLefJJsJST0NmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqO+VK0sV+h5GlMsvLT8f8GG4/FHmAWf9okvLy8BkAg=;
 b=FfYZpTZ/aFj31yfFw+stkkbpHFTgfWDYHxPZyiw5RgdLbdbbupIHCjz6AsLa/nWA70t/AWDDAe6LBrnOjCNAtw4F82SVcd0y5jRv6+jewoTUaPV7E8cV1QzOtFS0cgvdHHsh6FoCqCuasf02u7WjgePNhYQk5QdxieNXW+G/K4A=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB6987.apcprd03.prod.outlook.com (2603:1096:301:f8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.8; Mon, 8 Jun 2026
 08:51:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0113.006; Mon, 8 Jun 2026
 08:51:37 +0000
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
Subject: Re: [PATCH v5] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Topic: [PATCH v5] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
Thread-Index: AQHc9N12hy03ps+smUqN/FTn6oKx0rY0XksA
Date: Mon, 8 Jun 2026 08:51:37 +0000
Message-ID: <46bca519aa91a71ffd2c322c2e7239b52541e134.camel@mediatek.com>
References: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
In-Reply-To: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB6987:EE_
x-ms-office365-filtering-correlation-id: bac7717a-7a29-4456-068f-08dec53b2696
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: 46uCrRaCYj8Pudihjb4sa03qzPQ753rfilX3BtRw91OqC1aUdQeVKgKJUV3m9zQzXb+1XgHDy5ZV00pZT5ottneXyQzreHM2o7FjrQAezXEHNzuq1CIlFuQOhB9AEbakc/T3yH6aWvf29d86BIL8cffFLB551E3QAie8Lfw5dYX2uVOryMGOKWpNvCIJTMzKVgOR5L647pEUB1eVtlxE/l/A2gTa3crrX2uWgn+w3+072J31P9DrnZu8PJEfS0krgIg7hALaqewLIZdOcjG2T384yJH8fkFANf0RD/cETF1ewslTvCnXtZv9zK1PuSzUcampsRNjZaDhWr/Nl3vwyU/wa51HM7o9KobDU04tJWsckoMlG5mkocTDAJX1PwsLUYWIhRNMGbP1m+8pt7WXN2wv948E2bSkuAM8vbAUKHH0gBGO6sWInJidqthz5UoYVcfSJc/OiV8Ip3JO3P4BR8+3I3aR5Ww69DCSfiMAoGLnK3ZsHRHpGL9phyApuu1OAEsU0HgdYGtNRSwcgPudaBQiLaKFfAFo2vH9G0D3qiCt1+a7gHR2DBe3m/YXu0Op7NGdKF1cml3hUqHibv2iIf0C3wOwIHX0D07WbKiKRo6AXaGoTjlHtbR1IyqLIy10Ab8I/4Ps89c8j78L5hgPFS+Sn2bWFxbiiFXL97MYmoT2ndNubyzlpt18/onPZ5QDw727LkK6QUk6qaN9Iz6IbRYZsQCtqnfkfCHWyzBzeZfuNRxOtwnXBNCNeetNJNSS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFRZbm9DZzFQOHNBbElLbVptOWM5bWRPWHNTK2o0ekQyQjh5UUNEcHlERDcx?=
 =?utf-8?B?MXdZNWNmbEFzYld3dlJYRWoyVk9vK1VxN21WeXNPRW9mMXdHTXk3SDBHajFo?=
 =?utf-8?B?VVRrSDJZWTZ5L2pyeWJCaUdCN0c2bWZadjFtaXozOFF1b1ozRUVBT2hkZkpq?=
 =?utf-8?B?RUlvYmlXanVDUXRyNUQ3THJnbGR6bThCQ2FubU05eDU0MGRvUXREUnkrZjZL?=
 =?utf-8?B?M1hCSTlaanZlbjZhcm1SNENtZWlGSmxiV3B5MmFPR05iK0RubklZeWRQL2Mx?=
 =?utf-8?B?eVpqbDF3K0U4TUpPVjlzVVJHWEtvSlZPTHY3bEJtajQ5Z29PVXdWUUVzQnpM?=
 =?utf-8?B?OTE0U2EyM04vM2ErWnZkOEpsNlYyVnVOUlZOWE5EUng4aHFyWCtLalUrSG9K?=
 =?utf-8?B?MU5yODJKazdmbENyWFVmczd2YkJUWjh4ZXhDZ2ZvRkdrODM3SE9MRk5yUGQ2?=
 =?utf-8?B?M1lCeVNLT2prNTVQR0hHQkVucnZqUGlaKy9VUGV5OUdLOU9IeGpIMXVFclgw?=
 =?utf-8?B?a0hGZnlQSnR1aU4rNldZMnVVZ25CWXZna1FYMGxZQjRqc0JKS0JtN3A0Q3Iw?=
 =?utf-8?B?WDVMNHNrNk9ydHVmMEtUNUlLcUtJL0lVUVQ0MlhrQ1BUeXBpcVVKT0pqekRT?=
 =?utf-8?B?TDIwUjJMYytQMTd0dzE0MWZJZ0Z2RUV1YjdZRmhlYm5sbE41VjN6VkI3cDJa?=
 =?utf-8?B?aWxVYnpnbVRWUjI4K21DQXpNYkt4R0Q5Z2QxeDY4YkJtTS9SOXA4ajB6Q2xS?=
 =?utf-8?B?c29CM1VtWU1zeDQ5dU1HOXU4QldGQkx4TmVmOUtHR2dHUUkyei9nSjJZWWxr?=
 =?utf-8?B?TTlpSlgxaitNTFMvRjRCQ0U5SlZpdnRrZXdHRlkybHFkWHVvd082OTJ4SlZP?=
 =?utf-8?B?Z3p2SFFGYzNEL0VHZVd3SGdNeEMrOEhaWk9JVFFCbnN1QXJ0L1NMUDNNK1NF?=
 =?utf-8?B?V2tZNG5OUTU3Q1RLa29yTHNCOFdtTnVIUTdvUHB3dU5PRDRlMkR1emVlMUJN?=
 =?utf-8?B?M2NyQWE4QWYxUG0wbHk2UUEwTW1Id0phWGV1aHEyNjNiOGtTUEN6YXA1czhU?=
 =?utf-8?B?VUZMYU5DcW96ZkxubVl2eWhHanVrYUZWQTVaMjFheEtJNjdkOHpNWHBQWk1x?=
 =?utf-8?B?VjlVa1NZVjdBbDZqcUc1WE5QWUd5b09sVEhCeENHQ1o4UDlIaGNNMHNHL3Ir?=
 =?utf-8?B?QjhMOWpwektGaXJFc2NPd2Zudk45QzF4bi9xMFpPWjhVTlJJSkpHYzhEWit3?=
 =?utf-8?B?SUwvTGcvaEthZ1ZRNG5jV0hLUk1SbkY1Rm5sR0F2K0YwbGlkaDF1bGRCOGdN?=
 =?utf-8?B?QkxweEtKL2E3TkIxNVc5S2hObkxSc2h6R0VQbDJneEYyMkc2amFoQU1XKytr?=
 =?utf-8?B?ejgvTExwdXpKVmd2c3NHNHFhNlpHdUhnd1E4eXhNZGdxNlJWV051b2J1YnBi?=
 =?utf-8?B?UGhLaDZlbWRqV0YrdkNIekIxRXBndTFwaE45dlNjNmZ0dlBtYWwrRm9iMzh2?=
 =?utf-8?B?MW1ldjhtN1pYR1JTalRtdzlQaDI2K0g5TnUyUmVZYmROSkpseFRoMlgrWFJa?=
 =?utf-8?B?UzRNanZBcHdobzZKNG5qalE3T0ZpUU9XV1JlclA1bUtTQ05JMmtRdFVpQmQr?=
 =?utf-8?B?TDVqZ1FWaUpPMnR5aWo3V2wwaUFqK3MxSGlJVEpWbC9rWmJZWld3ZHA5eThV?=
 =?utf-8?B?SFBsdFRUV29vWHAwak82VjkzUXdScHdWSVc2RGMxSHJ2MTF4Z2FkWkpjWmFY?=
 =?utf-8?B?dG51SXJhdmpsbnhweHZKVGlvMW9yWU5Xa29qVXJMancrSVNlVHJ1bG44Nkth?=
 =?utf-8?B?TUhNeE04dGpsQmp2L0t3bnRqd3pCTGNmd1dDMG8wdzU4OVptUjUzc3I2UEpp?=
 =?utf-8?B?VmIvS1orUUM5UkxTa1pmY25la1JsNmNyZkY3NzF0Q0lWNXNuNXd1cnA2Y1A3?=
 =?utf-8?B?ckw2ZXJTeU5Qak5Yb1BXWUVjNHc0dUFubzVHeXdmT3Q4cTNaNzFKbGxOTEcv?=
 =?utf-8?B?emxTUVpVbnN3bkNwRHZKN3Z4RURxd1lxbnRac0Z5c04rajU5VUpjSy83dzk2?=
 =?utf-8?B?ZS9NRWFIQW9TdTdxOGMzdytlTUNJOTg1b2FmMjRPZmpZSTRWejlreGNhUTdk?=
 =?utf-8?B?VGRKalhYNHRyUmNDUUtYb3BFam1tVUYzN3ZwY0JEZUFNdVhURkdHUjZaaFlT?=
 =?utf-8?B?RnkrRmREbCthSWg4a1ZueXB2eWV6d1YxbFBVUWtMa3daTWF2Unl0b2V6ZEt6?=
 =?utf-8?B?eWIyZFQrZEZkamMvODAyeFVNMktZZ2txQTZyWU1MdXcrY3h0NnZvc0Yxcm95?=
 =?utf-8?B?U1RqYVlSaGdmUStBbXJnelRNK1p4M3RmQXlVRG5CaXVxY2dnWmRYV1VvRGJv?=
 =?utf-8?Q?pG4wKcD+S0bm1588=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07A3C8312AB6E9489403A6CB3F9A788A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: arOVDh92Be4OYAsRmzDxOxTQodTFSRZ4mJpoY59OGe2dBYxfXjnYhSwFk0G2gF7YriqeaCRlM0Os3abmYlqpaRE7yajt9GF3e+iXbRh6vuOqjh19kgGql73Qeph6UpmhaqOAzJnzdxK4RIDOexHc4r5kXcf+LEsEj4G4xKF54zG6slOyNfp/lIvnYUVJe+VeBTGYcwvw0qP1r3nqQ6X1nDk1vckeSN8HNjBF6RbKEeRbtPyvaPEUUAhP7TXAbPJ41bAAQcNK2gtMqQ8dDDhCCVJ7AyThp7Kfb7/fYVNEA+bsb4pt+pD2i+w3ia9BgRURQqch10Nwx1mPX+1oFMF4QQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bac7717a-7a29-4456-068f-08dec53b2696
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2026 08:51:37.3771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uff0Qv11+8fISEAdx7eA7rSg9HCN81xSR+ee4b4xd0fB1aIhlY/GN4bdBaUL6cdgmCtCWnzsT3t0iXqUDn2KJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6987
X-MTK: N

T24gRnJpLCAyMDI2LTA2LTA1IGF0IDE5OjIwICswODAwLCBIb25namllIEZhbmcgd3JvdGU6Cj4g
QSBQTSBTVEFSVCBTVE9QIHNlbnQgZnJvbSB0aGUgVUZTIHdlbGwta25vd24gTFUgcmVzdW1lIHBh
dGggY2FuIHJhY2UKPiB3aXRoCj4gU0NTSSBFSC4KPiAKPiBUaGUgIndsIHJlc3VtZSIgdGFzayBm
bG93IGlzOgo+IMKgIF9fdWZzaGNkX3dsX3Jlc3VtZSgpCj4gwqDCoMKgIHVmc2hjZF9zZXRfZGV2
X3B3cl9tb2RlKFVGU19BQ1RJVkVfUFdSX01PREUpCj4gwqDCoMKgwqDCoCB1ZnNoY2RfZXhlY3V0
ZV9zdGFydF9zdG9wKCkKPiDCoMKgwqDCoMKgwqDCoCBzY3NpX2V4ZWN1dGVfY21kKCkKPiDCoMKg
wqDCoMKgwqDCoMKgwqAgYmxrX2V4ZWN1dGVfcnHCoMKgwqDCoMKgwqDCoMKgwqDCoCA8LS0gd2Fp
dAo+IMKgwqDCoMKgwqDCoMKgwqDCoCBzY3NpX2NoZWNrX3Bhc3N0aHJvdWdoKCkgPC0tIG1heSBy
ZXRyeSBTVEFSVCBTVE9QCj4gCj4gSWYgdGhlIGZpcnN0IFNUQVJUIFNUT1AgdGltZSBvdXQsIFND
U0kgRUggbWF5IGFscmVhZHkgcmVjb3ZlciB0aGUKPiBsaW5rIGFuZAo+IHJlc2V0IHRoZSBkZXZp
Y2UgYmVmb3JlIHNjc2lfZXhlY3V0ZV9jbWQoKSByZXR1cm5zOgo+IMKgIHNjc2lfdGltZW91dCgp
Cj4gwqDCoMKgIHNjc2lfZWhfc2NtZF9hZGQoKQo+IMKgwqDCoMKgwqAgc2NzaV9lcnJvcl9oYW5k
bGVyKCkKPiDCoMKgwqDCoMKgwqDCoCBzY3NpX3VuamFtX2hvc3QoKQo+IMKgwqDCoMKgwqDCoMKg
wqDCoCBzY3NpX2VoX3JlYWR5X2RldnMoKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2NzaV9l
aF9ob3N0X3Jlc2V0KCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1ZnNoY2RfZWhfaG9z
dF9yZXNldF9oYW5kbGVyKCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGhi
YS0+cG1fb3BfaW5fcHJvZ3Jlc3MpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB1ZnNoY2RfbGlua19yZWNvdmVyeSgpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgdWZzaGNkX2RldmljZV9yZXNldCgpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdWZzaGNkX2hvc3RfcmVzZXRfYW5kX3Jlc3RvcmUoKQo+IMKgwqDCoMKg
wqDCoMKgwqDCoCAuLi4KPiDCoMKgwqDCoMKgwqDCoMKgwqAgc2NzaV9laF9mbHVzaF9kb25lX3Eo
KcKgwqAgPC0tIHdha2V1cCAid2wgcmVzdW1lIiB0YXNrCj4gwqDCoMKgwqDCoMKgwqAgLi4uwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA8LS0gaG9zdCBzdGls
bCBpbiBTSE9TVF9SRUNPVkVSWQo+IMKgwqDCoMKgwqDCoMKgIHNjc2lfcmVzdGFydF9vcGVyYXRp
b25zKCkKPiAKPiBBIGxhdGVyIHBhc3N0aHJvdWdoIHJldHJ5IGNhbiB0aGVuIHJ1biB3aGlsZSB0
aGUgaG9zdCBpcyBzdGlsbCBpbgo+IFNIT1NUX1JFQ09WRVJZIGFuZCBoaXQgdGhlIFNDTURfRkFJ
TF9JRl9SRUNPVkVSSU5HIHBhdGg6Cj4gwqAgc2NzaV9xdWV1ZV9ycSgpCj4gwqDCoMKgIGlmIChz
Y3NpX2hvc3RfaW5fcmVjb3Zlcnkoc2hvc3QpICYmCj4gwqDCoMKgwqDCoMKgwqAgY21kLT5mbGFn
cyAmIFNDTURfRkFJTF9JRl9SRUNPVkVSSU5HKQo+IMKgwqDCoMKgwqAgcmV0dXJuIEJMS19TVFNf
T0ZGTElORQo+IAo+IFRoYXQgcmV0cnkgY29tcGxldGVzIHdpdGggRElEX0VSUk9SIG9yIERJRF9O
T19DT05ORUNUIGV2ZW4gdGhvdWdoIEVICj4gbWF5Cj4gYWxyZWFkeSBoYXZlIHJlc3RvcmVkIHRo
ZSBkZXZpY2UgdG8gYW4gb3BlcmF0aW9uYWwgQUNUSVZFIHN0YXRlLgo+IAo+IEhhbmRsZSB0aGVz
ZSBQTSB0aW1lb3V0cyBkaXJlY3RseSBmcm9tIHVmc2hjZF9laF90aW1lZF9vdXQoKSBpbnN0ZWFk
Lgo+IEFmdGVyIHVmc2hjZF9saW5rX3JlY292ZXJ5KCksIGNvbXBsZXRlIHRoZSB0aW1lZC1vdXQg
Y29tbWFuZAo+IGltbWVkaWF0ZWx5Cj4gaWYgaXQgaGFzIG5vdCBiZWVuIGNvbXBsZXRlZCBhbHJl
YWR5Lgo+IAo+IEZvciByZWd1bGFyIFNDU0kgY29tbWFuZHMsIGNvbXBsZXRlIHRoZW0gd2l0aCBE
SURfUkVRVUVVRSB0byBtYXRjaAo+IHRoZQo+IGV4aXN0aW5nIE1DUSBmb3JjZS1jb21wbGV0aW9u
IHNlbWFudGljcyBhbmQgYWxsb3cgc2NzaV9leGVjdXRlX2NtZCgpCj4gdG8KPiByZXRyeSBpZiBu
ZWVkZWQuIEZvciByZXNlcnZlZCBpbnRlcm5hbCBkZXZpY2UtbWFuYWdlbWVudCBjb21tYW5kcywK
PiBmaW5pc2gKPiB0aGUgcmVxdWVzdCB3aXRoIERJRF9USU1FX09VVCB3aXRob3V0IGNhbGxpbmcK
PiB1ZnNoY2RfcmVsZWFzZV9zY3NpX2NtZCgpCj4gc2luY2UgdGhvc2UgY29tbWFuZHMgdXNlIGRp
ZmZlcmVudCByZXNvdXJjZSBsaWZldGltZSBydWxlcy4KPiAKPiBUaGUgc3lzdGVtX3N1c3BlbmRp
bmcgZmxhZyBpcyBubyBsb25nZXIgbmVlZGVkIGJlY2F1c2UgUE0gY29tbWFuZAo+IHRpbWVvdXQK
PiBoYW5kbGluZyBub3cgdXNlcyBwbV9vcF9pbl9wcm9ncmVzcy4KPiAKPiBGaXhlczogYjhjM2E3
YmFjOWI2ICgic2NzaTogdWZzOiBIYXZlIG1pZGxheWVyIHJldHJ5IHN0YXJ0IHN0b3AKPiBlcnJv
cnMiKQo+IFNpZ25lZC1vZmYtYnk6IEhvbmdqaWUgRmFuZyA8aG9uZ2ppZWZhbmdAYXNybWljcm8u
Y29tPgo+IC0tLQoKVGhhbmtzIGZvciBmaXggdGhpcyBidWcuClJldmlld2VkLWJ5OiBQZXRlciBX
YW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4K
