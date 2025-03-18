Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37D4A1C;
	Tue, 18 Mar 2025 02:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742265644; cv=fail; b=cjdykRQFv7KPAZM+I6pV6cVoC0QGNY7IYS1Z2o/KrdhIqKVbensgGsOjkY8XkLx9+BPpE58USld8BPxA8SJW24FHFdK0+TiEJwdUkU6iuEP0p6x3UtPZjTDJcWdgNJ+UnVj9nCS6QJYGN0dDjvarUU7GnnobURuivNzo5fm1UOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742265644; c=relaxed/simple;
	bh=sPuA/C4fdbcP+bHQKkmk5EFaV52DC4Dr13zdq/B1xR4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KliFm4Tn+IOTtVfnJ5NJe5nJqueFxpaF5HDS8YQJZTwYuQ7YEGsXIoV/rGnunEwxWYz9ZdgBtC4YN5gqxT3Yk+sjYBgNwk1WXeZbsnXXmnLbAsTxP2kFgKPz6PM2esyA7k2bCg+rxKVCauLKuHYnJNktN/fTPmQmT9D1Nq7Btd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=he6TlBpY; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RWmGxyiP; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="he6TlBpY";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RWmGxyiP"
X-UUID: 60a89c1803a211f0aae1fd9735fae912-20250318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=sPuA/C4fdbcP+bHQKkmk5EFaV52DC4Dr13zdq/B1xR4=;
	b=he6TlBpYDAFUCczPAi4dTEVIs3MJYDd0K/pu1G4WEt0OKuYy8/cd/D0JG0jB/SN170lHnp98itciYLtlQbw9XmBCz6QVanqymCfWBXo9bDf+N34lpN0S07geMtavcytF71ZtcptSSuB0pCwk8Iuu6u+Oi8o+91atPWP1LctSU0o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:d42cfb2b-b537-4e3c-8a48-20533da1d991,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:00c23b4a-a527-43d8-8af6-bc8b32d9f5e9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 60a89c1803a211f0aae1fd9735fae912-20250318
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1555092617; Tue, 18 Mar 2025 10:40:38 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 18 Mar 2025 10:40:37 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 18 Mar 2025 10:40:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cTgKbfiIzzTMyv25LrwXR6Xz7wtE4JGuocWy/8eZ08wfZfSTBCGG2GHh9f5LE+G/c26Jl3h7z8+/+FxoVlri7jhtbxzN+MsDy9kClob+wsA8VdwTF1FdcJrrS4zbPO4Ia9pLoZQpj8VkWUIajByMB81Ph3fwWu+sIKo8gN09L+s2XGSr52GyNir4CcrH4zST6Vo6SfTeipkHnA50mrUaP5DzrV6rCs1E9k2sOlsniKrDnKPInc0bEZu7rgMAHnWJDXwtubwPserwL94dtJPfi+f0XsRA6lAn6VVyHInlf+krwnaqJVlMjgR8bfMGDno0zYcljU5IkrzdtWpX5hsfzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPuA/C4fdbcP+bHQKkmk5EFaV52DC4Dr13zdq/B1xR4=;
 b=yUh0XyERncKz9ChYs4H+dHZJLuzzVbiKZCC3T7fJeJ/JClLE2gwgk7R0JxrTmQdJW++jKbARfX5UGXqvir0meAu18VLB1R3HA2q1ZJLQzpy6eA+EqLAU2TTcx78c9//pJtiilE20RNKXg1I78U69pxjJpy1stOhjMeFMyPDb9DyeZVF0b7dC8pdJ70hFth57WtBoF0RNBVNW5RFqLP7jBNmGqWvsC971EJhmX2UbZVucU2n3HdFk6L612+jP25/hgbkB6lJwKzHLBwSihUqJH8pIKMgbTzbe+yYEU3MeHQ6CLoTuuU/w60/VBsA96GxuVPB8uWN2oM9j64x+MeVF9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPuA/C4fdbcP+bHQKkmk5EFaV52DC4Dr13zdq/B1xR4=;
 b=RWmGxyiPTRYsU0vCwGQR/KpyGoh71qXcqeJU79b3txPfdCo0TtWgTk31QK5o4Hzvx/BhzQJ9sY1nKFzEAatD1WYwHfT/DTZ9dM6/KdKVHE3Qbrj/xQ4J5ToE9hg7+fd3ugzZgU3/9oVnB7sBmkfeJ+fVBI3wPqBM8t0wFjPJ4bA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8532.apcprd03.prod.outlook.com (2603:1096:101:1fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 02:40:35 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 02:40:35 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"minwoo.im@samsung.com" <minwoo.im@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "gwendal@chromium.org" <gwendal@chromium.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: add device level exception
 support
Thread-Topic: [PATCH v2 1/1] scsi: ufs: core: add device level exception
 support
Thread-Index: AQHblTRci+9yc/7UJ0GQbnsY0K4MJrN4M9YA
Date: Tue, 18 Mar 2025 02:40:35 +0000
Message-ID: <7abfa282180f730312b721dab67f95a0b7fe00e5.camel@mediatek.com>
References: <df2a1843d1dbfd0d3fef87b9730089969b6f00bd.1741992586.git.quic_nguyenb@quicinc.com>
In-Reply-To: <df2a1843d1dbfd0d3fef87b9730089969b6f00bd.1741992586.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8532:EE_
x-ms-office365-filtering-correlation-id: 5b111c44-51c9-4817-3bbf-08dd65c642f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SkpkQjdCWW5UK3hlQ3gwajF5UHpkd1ZyWTVFazF3cStzL083ZFYvd1JScmV1?=
 =?utf-8?B?bHBoQ29Ed3RDd1A1UEtlTmpkUHlHaGVNMG5FY2djTDhZZFdYV2ZwejdSU2xu?=
 =?utf-8?B?Vk5EeVpmWW85ZUsyNHQzNDF4K1lZdmR0WUdTcWhKakJzK3ZDQUFVOXNIdzFz?=
 =?utf-8?B?Z3VHNzlQSXJNL3NoWE9xb1gzVXBNT1pxakt1SndHd052WlJVRTlCTUxoQ285?=
 =?utf-8?B?TTRaSCt4YmVXVE9NSmJ6Z0RDNTF4aDRMbkQ4WWw2K2h2OXRZeHJ5WlhRcXVN?=
 =?utf-8?B?WGxoT1RHY2JJM3dJOWhIdGxXa1pqMm5scFpwQVUyWHFFb1BWU3BMaEkzZ1p5?=
 =?utf-8?B?ME1INjZyQmNwa0hzbW12TmViYjBaRmwrbGhaYWlncEFmbzc0TGVZOTA2S3dj?=
 =?utf-8?B?dVd5cG44SFJGYlpxZExBQzZhdjQ1TXhmVGs3WGg5ZlhtbXFyZHA3QXFtK3BZ?=
 =?utf-8?B?VHdiVTl6bXA2N0d4c2NHQTFVblU3dEZsK2FsdnR1MkhDVHp6dnRpOTV3Wmgv?=
 =?utf-8?B?SngwSVlJVFdRNnN4L28rNXZJSWU5QzI2UXphYlBvdmY4Wi9WbFl3cE9qYU9O?=
 =?utf-8?B?eWlZM3UyaUhZUXZLL0VycXNHNmEzcURzYU1QcXltT1dIVk5veUcraHE3UjMr?=
 =?utf-8?B?b3pkNnZqQkE4WFFQckY1WjU3VDZkTys4Vjg5MlVUeFV5RnZ2QW8reVlrTGM5?=
 =?utf-8?B?WCs2cGRIck9GV2w5Z0lqRE92R1lVSkFxVzJPbzdVTFF0T1JPMXQzOERmMjVo?=
 =?utf-8?B?azdiaWNENE5rYzVYSXNYOUJSZWZlOGRkSFVSa1Y1RnNZL05mc0Y0dm5RTXd0?=
 =?utf-8?B?aWpEcHdCZmdJbE9NMy9EbGFtelJLSVFlZEdtcGRMUnlhM1ZTSTNyZzJYUm16?=
 =?utf-8?B?MkZ0QmsreTlNQlh4WEpHU1pZMEFXbEY2QjFwSlpWY0dtYVM5OWlwK2ZUYXJ4?=
 =?utf-8?B?UktBWUZXUmRLUnR1MGZDeW90YkpZMlVPWDRxaURaTStFT1JlVFNFV2s1WTdG?=
 =?utf-8?B?azlLQ3NGYS9yMmZVMmdMZVdLa1dVK0lPZmI0TE0yQzRENnQ3SzRwRDJSVkNi?=
 =?utf-8?B?WGdGcmN4L3NtUXV3RytsYlNsaU1lRVZRenlsLzNjMVl0VXQ5SktqV2l1dW81?=
 =?utf-8?B?T2p3VDBzQ2FucGpXVUJTbVp4bGwxTms4U282M2dQZG80OVJwRlIyYUNnZkdq?=
 =?utf-8?B?bmphM0dpc0E1ODJlRzVGTitKTmpWT1prS2xMOE1tUU5scXgzb09qSVlxZ1A3?=
 =?utf-8?B?cHhYaDZScXczZzZZSWdtUVpFaUdJSmhSMWhReGVCaWlTaEF5aDducXg3RVdV?=
 =?utf-8?B?UFlNMjhzYWVhcm1GSnJ6RnBCV0tFbEdsbUdDOTdnSDNoTkdXMlp6aUpyOXJZ?=
 =?utf-8?B?V0t2cmlySXNIVkFrMmpZZ1hkanYyOStkTEo0ZHliZUsxR2hqVnV1TTV2SUVm?=
 =?utf-8?B?aTI3TUZaa3Z1K21UaVpkQ3hUOW5WOFpJU0lIZkFhY0ZUYjk1b0FsWWtjSm5C?=
 =?utf-8?B?ai84dSs4LzcwaERTdmJkU01SdDVNN2s5b2xTcHJTNjlkV3Z5ZTdkK1dSTUdW?=
 =?utf-8?B?eXZlc05USXlrQ0RFdnB4SUE4THpORUtSSlNmS0lDVWMxSWZ5Q3VrTTBsbUFM?=
 =?utf-8?B?WERMaGRRTFVJU0ROUDAvR290cFMzWUQxdFlyUUQzd1IzaHZQMnQ1ZjEzbUM0?=
 =?utf-8?B?R0swaWZ5TDlWNHNtYVVwT1RQOENLRFRNL29OZlY3dUZHVkxScGk4ZzY4QW9Z?=
 =?utf-8?B?a28xSTFVT09VV0RzR0JsWStDSlVsS2xTSXUrV2tNcUFocnN3ZGZMWUpGaFlR?=
 =?utf-8?B?d05QL05PeWJoQ2ovRjBCUHpPdDFvOEZWN1pTNUVjd2p6SWJXVWhRSWdIV3Bx?=
 =?utf-8?B?alphaWtLVXJVWm1PaW1BOWtobjhJZmV3QXZzNGQ0RFVNZnVBVGUwbXpIalNq?=
 =?utf-8?Q?0EqTOYaIE/JWH52EqlhDLhNenXqbsXId?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFp2YXRLT1B1RWtZTUNBeGdyNnpVMy9pRWNKeXlxS29GZFNvRDhoalQ1Ynk2?=
 =?utf-8?B?SlZIT0JJOXk0RUNTU0ZPaDlsRlNWcTdJRXI5dWxYU1NDYVVrV0crS3lma2xY?=
 =?utf-8?B?L0JpR1dtUkZvamQ0UlhxSUNBVnBJT2lGc3AydHl1c1l6bHVTd3JvbFVBZDZ3?=
 =?utf-8?B?QzRXUWFXNGtsMVNpTUJqekZzMlI2aDFiYi9JbnBMVFc0c0sxWjVyS0NjckF0?=
 =?utf-8?B?Vll0dFREZWxBdlJZMDAwbU9zVW03ejN3b3ZmZndmNHRYUlVTd2dvRWI2OSt5?=
 =?utf-8?B?ZUl4TFNxN09PZGt6MHNwek5VOGEyOGFmZzROL21SaHZIOHAvRmd4aVZUNHpx?=
 =?utf-8?B?WlV5M2NzejFZTi9OallteWkwRVV4YTNBeTBIYUJSVlRTajVFR3pLT1Eyekl2?=
 =?utf-8?B?Zy84d3ovRnE5eEdXNC9tUU9NbWdBNUtyWjhCSHZ2REtkbTUrb1JETHFNcWZj?=
 =?utf-8?B?T1RUMEtGOXZENjNGY2w4eFpheU00QUo5OVRTMWJPdkcxNzZoRTZxMW9hTEJn?=
 =?utf-8?B?cjRPbWVqMVk5VFBWSUJ6dytOelVITmNCVFpud0xqVzJuUXJQOXNJankrUDNv?=
 =?utf-8?B?QVBLK25mSVBBVTdMSTVtRGxzNzRjcFVUUklxZ3BYd25VeHQraUIrTXhRVmg2?=
 =?utf-8?B?V3VLUnpVbnBCWTZnR3FQTnBpU2M2bURmeXY2RkFWYkdoMkVrc3RXY3Y5elF4?=
 =?utf-8?B?OXJ2Z05CNjhid2JRVVVaTit5RXJabHRQa1FTWlFKbmp4OXZBZFVBdUhtL3FZ?=
 =?utf-8?B?dzBuVlZNbytmcXNxeDNsY0xrakRFSUVrVHZQQmszQmR0bGsxSXhhcHZFdXE3?=
 =?utf-8?B?QTFkWTRQd0tHejRoUURXY0J5ekM1c0VYRGtIZEJLbkZsRHczVnI4WWRUOHJ3?=
 =?utf-8?B?Ukt0UG96OUNGM3lpWGxmY2tycDJ4T2pHTk5yTHRFdzVQMlJpUmVVR01qSHFD?=
 =?utf-8?B?elpINGxUVG0xNVdVYWZ3R2VmTS9iellyU2praFdWNVE1WFoyQ1Z0RlY3cmpV?=
 =?utf-8?B?WUt3UFRtc2tiQk1SS2hUaTdUZUl2akJRaFFvMjJsWjR5VktsTTdXekF6dGlE?=
 =?utf-8?B?aU1uU2xNYkZXMDZwdzRIVkdzdll4clN4K0NCcVNwUnAvbS9HakhTUzlkVnRL?=
 =?utf-8?B?eXJNZWRrbzVjWnZ6Tkd5Z04yOGlxOVdoWVlsYUtDbnlZSGhkeW1DMFFXQWpF?=
 =?utf-8?B?RE9PajU3UWpacXpZRkVjUUpDREwra2p5WGNUc2JXaDJqYjdqNlY0MjM1Vm0r?=
 =?utf-8?B?MXZ6bTFoNllQZjZacElIRFY5MHJNUGlmczNXbzZ0V05jNFNIR2pqeTJIcTNE?=
 =?utf-8?B?eWliSDVRZ3pSRzFPNmt3OEUzZ3FHRnM2Vi9SU0F6aW1FT0d0emF0K0dKNHdo?=
 =?utf-8?B?S1JoYTRpR1FlcVVNUTcvNXBRaUVJbVRscXQwVmVtai9LT3hKZzRLazY0VHo1?=
 =?utf-8?B?eGo3M0R2MXdKdXR4blBEd1VZeE9rVGNnOUlBek5KT2VTSXlvd2k0bERSdm14?=
 =?utf-8?B?V1I0UDJlTzlVRVlObFRZS2JTV2w3aDlBcWVQcGxZQmRNbEZPMHFrWWVaWFJF?=
 =?utf-8?B?U1lBbEowNVd1UnhUY1grbzVscTJFMkY2bEYyWTBuaDFOWFNxYjAveURWdncx?=
 =?utf-8?B?aXBnbmNUVnU4UWtMRWorcThVS0tlak91WmFLRVJ5VUlJZ0JLL0JjcW1LWjQv?=
 =?utf-8?B?MkhaV09NeTdiMnNsT2dqbmxnZmg1Q2hOYlpDL0E3VHRSZmtMa2dLWmlNb1A2?=
 =?utf-8?B?aFdxZ21LMk9uZzNrdXdDWCtmMlZ1SUhhNi9kZkt1ZTlsUDgyclFweTNGUEpV?=
 =?utf-8?B?dnF4L0cvQlNTNU0rWnpLRlg3VzAzWVU3MkhQZjJoeDN1SEs2YVdmZ2FGL1Ru?=
 =?utf-8?B?MDBpUXRlR2k3ejlMcllrZGVTTzlKWDVId1JIVWRLTlZCdlVTY0NpZ2ZmYVkx?=
 =?utf-8?B?WVRVZnB6VmVZdFNlcmgwcmJ4SUFpcmdtZmFXeG54c1JsSGtCODYvRWl4UDBm?=
 =?utf-8?B?c3lkK2YxKzdOYUltRGdnZ1ZqVlovc05EelV1cHBEcDhQUUJXMzBxL1FjUGQv?=
 =?utf-8?B?T3dHdVhENGQ5NFFYdlNEVUtQL01sT1F0ZnV4cWFTandRM0JYSzZzY3dDS29v?=
 =?utf-8?B?WmZVWlZzVUJHNTFuSFdGbXo5YUtESzNYLzk0VENEYktpMHBxaVZnWlUzaXNM?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3D03E3A8C755E4A8B735F430900D30B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b111c44-51c9-4817-3bbf-08dd65c642f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2025 02:40:35.7212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uochowqBm2S6/owtDyd5djY/pAr2kdMKGHVwgyJrNE74VpIlIBjXsPVvCtDc2om+1bpqVCmWfggybUXYzlJxdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8532

T24gRnJpLCAyMDI1LTAzLTE0IGF0IDE1OjU1IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUg
Y29udGVudC4NCj4gDQo+IA0KPiBUaGUgdWZzIGRldmljZSBKRURFQyBzcGVjaWZpY2F0aW9uIHZl
cnNpb24gNC4xIGFkZHMgc3VwcG9ydCBmb3IgdGhlDQo+IGRldmljZSBsZXZlbCBleGNlcHRpb24g
ZXZlbnRzLiBUbyBzdXBwb3J0IHRoaXMgbmV3IGRldmljZSBsZXZlbA0KPiBleGNlcHRpb24gZmVh
dHVyZSwgZXhwb3NlIHR3byBuZXcgc3lzZnMgbm9kZXMgYmVsb3cgdG8gcHJvdmlkZQ0KPiB0aGUg
dXNlciBzcGFjZSBhY2Nlc3MgdG8gdGhlIGRldmljZSBsZXZlbCBleGNlcHRpb24gaW5mb3JtYXRp
b24uDQo+IC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvdWZzaGNkLyovZGV2aWNlX2x2bF9leGNl
cHRpb25fY291bnQNCj4gL3N5cy9idXMvcGxhdGZvcm0vZHJpdmVycy91ZnNoY2QvKi9kZXZpY2Vf
bHZsX2V4Y2VwdGlvbl9pZA0KPiANCj4gVGhlIGRldmljZV9sdmxfZXhjZXB0aW9uX2NvdW50IHN5
c2ZzIG5vZGUgcmVwb3J0cyB0aGUgbnVtYmVyIG9mDQo+IGRldmljZSBsZXZlbCBleGNlcHRpb25z
IHRoYXQgaGF2ZSBvY2N1cnJlZCBzaW5jZSB0aGUgbGFzdCB0aW1lDQo+IHRoaXMgdmFyaWFibGUg
aXMgcmVzZXQuIFdyaXRpbmcgYSB2YWx1ZSBvZiAwIHdpbGwgcmVzZXQgaXQuDQo+IFRoZSBkZXZp
Y2VfbHZsX2V4Y2VwdGlvbl9pZCByZXBvcnRzIHRoZSBleGNlcHRpb24gSUQgd2hpY2ggaXMgdGhl
DQo+IHFEZXZpY2VMZXZlbEV4Y2VwdGlvbklEIGF0dHJpYnV0ZSBvZiB0aGUgZGV2aWNlIEpFREVD
IHNwZWNpZmljYXRpb25zDQo+IHZlcnNpb24gNC4xIGFuZCBsYXRlci4gVGhlIHVzZXIgc3BhY2Ug
YXBwbGljYXRpb24gY2FuIHF1ZXJ5IHRoZXNlDQo+IHN5c2ZzIG5vZGVzIHRvIGdldCBtb3JlIGlu
Zm9ybWF0aW9uIGFib3V0IHRoZSBkZXZpY2UgbGV2ZWwgZXhjZXB0aW9uLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogQmFvIEQuIE5ndXllbiA8cXVpY19uZ3V5ZW5iQHF1aWNpbmMuY29tPg0KPiAtLS0N
Cj4gQ2hhbmdlcyBpbiB2MjoNCj4gMS4gQWRkcmVzc2VkIE1hbmkncyBjb21tZW50czoNCj4gwqDC
oCAtIFVwZGF0ZSB0aGUgZG9jdW1lbnRhdGlvbiBvZiBkZXZfbHZsX2V4Y2VwdGlvbl9jb3VudCB0
bw0KPiByZWFkL3dyaXRlLg0KPiDCoMKgIC0gUmVwaHJhc2UgdGhlIGRlc2NyaXB0aW9uIG9mIHRo
ZSBEb2N1bWVudGF0aW9uIGFuZCBjb21taXQgdGV4dC4NCj4gwqDCoCAtIFJlbW92ZSB0aGUgZXhw
b3J0IG9mIHVmc2hjZF9yZWFkX2RldmljZV9sdmxfZXhjZXB0aW9uX2lkKCkuDQo+IDIuIEFkZHJl
c3NlZCBCYXJ0J3MgY29tbWVudHM6DQo+IMKgwqAgLSBSZW5hbWUgZGV2X2x2bF9leGNlcHRpb24g
c3lzZnMgbm9kZSB0byBkZXZfbHZsX2V4Y2VwdGlvbl9jb3VudC4NCj4gwqDCoCAtIFVwZGF0ZSB0
aGUgZG9jdW1lbnRhdGlvbiBvZiB0aGUgc3lzZnMgbm9kZXMuDQo+IMKgwqAgLSBTa2lwIGNvbW1l
bnQgYWJvdXQgc3lzZnNfbm90aWZ5KCkgYmVpbmcgdXNlZCBpbiBpbnRlcnJ1cHQNCj4gwqDCoMKg
wqAgY29udGV4dCBiZWNhdXNlIEF2cmkgYWxyZWFkeSBhZGRyZXNzZWQgaXQuDQo+IC0tLQ0KPiAN
Cj4gDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4N
Cg0KDQo=
