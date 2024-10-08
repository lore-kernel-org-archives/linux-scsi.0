Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B65818C910;
	Tue,  8 Oct 2024 23:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728431260; cv=fail; b=ZFT4I8ehJgOleNaoorK5AscSxwsYYFUixo73ULxkgnxdFmUhTWNcYRjozvXSJ0REKwex1vyXDGZ2WdO2lwUCi4p6yN3IOvrI/Su1bEIKtET9N5D+36nRRGDX3Z7pCCmUpoJKiC+5TyYB9XvjFN9SHOxkP3AQSXoFhrsseYoZMhQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728431260; c=relaxed/simple;
	bh=35ojAJMZkvrbAxQkhnx65m8hgXZ0ZRxM2kMugxt+054=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ex4fyLBDzgk8sBW/0l/zvNnwlXyTKJSZu3Qi6H3ZvaSz8M/Xzbn0TgcRfSoErSSovete2KcmgDxjGB5jE0AC9vtXrscit/z8fbYyqkF7qHFwil5BCXdva06lujM7TbF2H/gYqP2zU4ubGdITR0pWSNRD6tJ4Sxew2B0nBD5PlJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qrKJWaWt; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=faXAmSfI; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qrKJWaWt";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="faXAmSfI"
X-UUID: ae99f4c285cf11ef88ecadb115cee93b-20241009
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=35ojAJMZkvrbAxQkhnx65m8hgXZ0ZRxM2kMugxt+054=;
	b=qrKJWaWthrP45tW+uAyQsUMKew0WgsbLbHKeZhs26ncNL0/2R5XsaMTVgmOey48vURu0+jKAGh4MGihBj6mFFIhttt5TaNsTFW7F2xg9VazNHp1v5kawDyGmZc2zYLWS0R4vTg9TvP0kjj89jvTEa3muVXrnoM2ywJkGZ7HAbPw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:07c7489c-8368-4371-8fd8-025186e14e12,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:e0bbf540-8751-41b2-98dd-475503d45150,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: ae99f4c285cf11ef88ecadb115cee93b-20241009
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1591249562; Wed, 09 Oct 2024 07:47:30 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 9 Oct 2024 07:47:29 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 9 Oct 2024 07:47:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p0xsiVVjfB83oM942KUArHoaw0zZ6Uet3rSFIU/xTQGksvJCUUhf4/84LUALkWt5XtAQQy5HyKyiJJ5MS2kHgxEaCyFMKPk3b4kVRYavXY6tVD0uwLEnCVPrtPyYZzABc2HSHYKVqncWgN8v7uiN2bUQSBxkfIjON0gro+gYEkpbJd51T8Z1dPuR7WvGYEL++I2dvSyMGibbRUbIQHbPK6OgvIips0NYmtxLXLnoEpi/a+7r9W7NAsK6KW6EV4deBzxctJAqIhqt9jYoQvTGO/8u/7XsvcEmn/k1Uqy0WC6USyEL+naxA3I7znbqeIdZWrgchCK/uf+QeGderNsjfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35ojAJMZkvrbAxQkhnx65m8hgXZ0ZRxM2kMugxt+054=;
 b=fnxDjPqC2HkIC1sjlv+HNm/cPT+lcwwr8BSdWGO/PSbbCjQPygt/zI2He3tonoi/8gBFqROCYgbaBCCdCMO6PWHDPh1FkI3Fqlvi5DBcjtrZS8g1m0sRhopYuMg/xigq1UqknoPSxTj5rKZauIMTlTj3x0j53tHBikn/5yWlYoJSSGgS10MTIyFzue7jUJz5PYtvAJxC5hZ6s9NLeXMyM3MMco+ZTbrXaijAD7i3FTveihILFndUNxXUvZeX94qRFE3lUpuTVTE2wNO+RBIntU7XJLfaUTDdGqU4iqvFaX2GGU/cChULMVEboe/Tox5bMAOr0F2F2HCt4FIVPrhfTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35ojAJMZkvrbAxQkhnx65m8hgXZ0ZRxM2kMugxt+054=;
 b=faXAmSfIjG458L9x4CzG9JnQNXSXjYPh/diSZgl8LQic9V21SB8oNkao2Kmo72LRzJgKWfznOjOItNLT7HTTuZ6GRHbk7Csmh6E0twZcllm0W4t8yLflFH/THO+rdzBvlQgJBKRX/3NjKzlaAjsAorXwoc9BxMVil3VxyeTdTDI=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 TYZPR03MB8192.apcprd03.prod.outlook.com (2603:1096:405:26::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8026.22; Tue, 8 Oct 2024 23:47:26 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::8b7a:97d8:96f4:2e6b]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::8b7a:97d8:96f4:2e6b%7]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 23:47:25 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, wsd_upstream
	<wsd_upstream@mediatek.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: configure individual LU queue
 flags
Thread-Topic: [PATCH] scsi: ufs: ufs-mediatek: configure individual LU queue
 flags
Thread-Index: AQHbGU+/GfHtopO+ck+rvoijMpM3M7J9H0CAgABm+oA=
Date: Tue, 8 Oct 2024 23:47:25 +0000
Message-ID: <a86e1dbd34f1db87caf1fb957aeb747b57ded3e9.camel@mediatek.com>
References: <20241008065950.23431-1-ed.tsai@mediatek.com>
	 <7b3b29ee-8e2d-476b-8edd-290c3f00dc85@acm.org>
In-Reply-To: <7b3b29ee-8e2d-476b-8edd-290c3f00dc85@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|TYZPR03MB8192:EE_
x-ms-office365-filtering-correlation-id: 5f92095e-10ad-4d1f-e49e-08dce7f38ff4
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NU5idjl0MWZxZDJnMGNTVGRKbFZvK2tBdkJYUGczSUtSTWNHUEZrbnAzNmY1?=
 =?utf-8?B?OVBrWHZwZi9WNlRxVTV5SU5YdjR5bmZacDN2Sk1ZYW5YdkNzZE4zTHU2eVJt?=
 =?utf-8?B?ODYzRlVoMUxKMFpCbyt6bzl2MVlCM1IwcUhoWGd5Vk1qZ0x2eURrZ0UwMmJQ?=
 =?utf-8?B?RnhnSVhGZ2xYY1ZnRUQrbUZDMGc2ZEJZaU9oUm83eUlzMEI2KzU3dDNZb0lx?=
 =?utf-8?B?Z0tkOVhNMW1YZHJhQ2xxcVpUSjlWeXVSU1Qxb0xveldNSVh0Z0VJWU1YV0NO?=
 =?utf-8?B?S3ZyWFJnRldVV0NhR3Arc2lkVHBla2g2cmFMQW9FK0ZxbkErUWtIUGNhUlRV?=
 =?utf-8?B?RHpHTWNpUVdNK25qdW1MeThjeEJ2MkdkemVLSmhtakx0Nzg2UlRYR2tZK0JH?=
 =?utf-8?B?UGNPVFdWWko3c0oyRWxuaVlKcElxKzZiUkFmVEEvRTZCZ2JPNnZqdzNLa2gz?=
 =?utf-8?B?WHl6b0wxWnprd2p5bThPWUFTbUNDRUFIbW03c0hsaU1RdUZ5cFpndHVQd0cw?=
 =?utf-8?B?WmlPU2RkMUZ3MDEvUjZQbmk3Si8yMkk4eEdLVUxvRUdzS0ViU3RLYU9FTU41?=
 =?utf-8?B?NVMwUXNRMTRPT2QxZWhuUTNzOXBRekdqWnl4L2RjWHlkRjlwL1hOZHFuYWNk?=
 =?utf-8?B?SFV0dk90NXhYZmkzYVp1Nk9nSGZCMmpJdWM4NHArSTF3VVFJK3BmOFpNZURG?=
 =?utf-8?B?OHpEZ0dkSE1VUUw2Z3JiY3Jackdnb0w3UFFKSnFuUUtpdHZDZzFlbm5Sa1A0?=
 =?utf-8?B?WnI2S0laUmVldlJ6MzJyenBuMXh0NnNSUFhqNkFNbkFiMmZaUmtyL2J3WXRl?=
 =?utf-8?B?ZjNhSTFpWTh6aUpScmlrOGoyanN4MDdQTEJTQzQzNjQ3MmR5eWVubWttSmhI?=
 =?utf-8?B?cmhDZnI2SlB6MUlxdzRqcXNna1c3cHdMc3hpZlpoYkJFazBTTjRYUnlWNTho?=
 =?utf-8?B?Yk9UTU55WVlYS3NSSWI0TlpWSWRPZ0RCTVFDSjhvWkZhU2xheVc2cmhZaHpY?=
 =?utf-8?B?eTg5MEgvZzdBY0FnaVFnelIrekYrK0VvbUdWWkVicG1jUFZpVkRqVWp2M3ZG?=
 =?utf-8?B?NCtvckZicDhvUU5jRkFOdWFCYWplczBRaWZCRXh2WWJTdjE3NGwvRytyV2l3?=
 =?utf-8?B?MDdHYm9OV1IwWVZzYURzRHp3ZDdpKzh1WVQ1TURPeERxQS83bUJuUnpjVGdY?=
 =?utf-8?B?SDlENWI3Q2NmUG43bDg5NFNZSEQ0TmtBK1NVUVdYS0RLcnJXQnUxUUUyU0hJ?=
 =?utf-8?B?Q1pIMUw3b0w0THBhaU0zMVB1akpRNlh2VGFjaUVuZVFaZEQ0aVJDelZ6bVda?=
 =?utf-8?B?VkR2eDlOUURwNmtIbFdRbG5CWGtmTCtFYVVXLzFVejVKaGdQZHVIcDFDVmNn?=
 =?utf-8?B?MUMyd21tN3U2QmpvTEQ1WVd1RmZSR3pTbEhJbTYzR0hjWnRlUHJ0dk5nOGpn?=
 =?utf-8?B?b0tlM0VGYVVlczZuOFFiOElWNFUwUHhMSm80NnJBQkwrWktnQ2QvdEp4UVR2?=
 =?utf-8?B?VTB2bldISmhnRkN3NjEwTHpOZjQ3bGRPQ3R0SUlLQU9qVHY0bVZTYSs0UWNz?=
 =?utf-8?B?V0N5bkxrZU9VYXY1aytSSWJ2V3VXSHZIK3hNMTBsMjdHd0RteTFBdHd3NzRw?=
 =?utf-8?B?MFdxK2VoK0xka0dnMFZpazVNRytOQmJyWURxL1VvTE1NUU5mWTNCMUlJeUNM?=
 =?utf-8?B?MUFrMVduaWFrVW5rUG50R1BEV25CbzY0dkRZQkY5TnZibWk3N3kvQWVzUncv?=
 =?utf-8?B?dUhZUTlnMytpc0ZDNnhBNDdXTXExaWpEbi95MktQbTBNR0FFSEtLOG4rVWlx?=
 =?utf-8?B?NFh4SHNzK0NESTdpeHJwUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHFpK1hwNU1DV2J1U0dJbFVIN3c2ZTA1RWpyS2NES1BDcE9LOGdvVEFTUG93?=
 =?utf-8?B?OTNtNExiU1IrRFNaY3N4T1lDZHMvd0FpTWR3TW5qVXBEbENjaXpicEQvUUJi?=
 =?utf-8?B?dERSRkUxeGRsdXdCN2NwbmFGc0VOeFV5alhwVDhZWmZlMEdtZDJXWkJJcUdv?=
 =?utf-8?B?T09OMXl4bUEvUXZkOTI2clRPQmxiK1hKWFlOSDF0a21HUlJUaWcrSTRFYUFF?=
 =?utf-8?B?UENJOGNtbGc0aDByenkwNmJHWmhmN0orU09TZHRrNU42NnZlUVhDVE5pT1l2?=
 =?utf-8?B?aW9KaDBmSTNWcENNNW1PdTd0aUFyMUJOa0tRbTl4Q0xNMGEyVWMxZDllVm5T?=
 =?utf-8?B?U21mQkQxQmdZL2VUV21BYmNncGM1WHZyNjBzaUhURHc5Y2JNSjRvMzBvUnJp?=
 =?utf-8?B?WlIyYzE2SnVpNTFpTkxyRzRlVEtMZjZpclhqNlRMQlJwbEVVR3oyNGFWUktL?=
 =?utf-8?B?a3E1amFaSWdzc1NpRjdGSVh2WHZpOHRjWFJPVkZ4WEd6ZnJrbU1lYUxnaUFl?=
 =?utf-8?B?WEFNZWhDZ3M3Z3hWVW96THVuUm4ybkxzdWcvSnlaYjBSR2dadmNoMUF4QWYw?=
 =?utf-8?B?RmMzSk5YeDJFZlZnMFN5bk5yNmYwVUdwdlJsNmRPU1JBcjNMR1I1R0pJY08x?=
 =?utf-8?B?UWNNQ0ZuM2RhN0Evd2x3YzVOeTBsMEZGREpZQXE3YkdLNTZRSlMvUHNrUUNl?=
 =?utf-8?B?Q29EQmZHNkRObXdndXFwQmpCVVdmdUFvL2xXU0oxc2l2RDBvNnkyTy9sYmZ6?=
 =?utf-8?B?MXRYY2tmcmZmaHdlZTRwdEhjakFjWTVzNkpKcTJZc1dmTW1mMHRUQVFwblh4?=
 =?utf-8?B?aG00d1FFK3djb3Fua2NxcUc4NmF6L2FxRk1YUzR6S0syNDBiZ1ZMNER0RHdT?=
 =?utf-8?B?NnRpNGRlYW90MTJ4NHUrL3RDQVhRTklxMGdXZ1VrT2ppZjcwdnFTdUFRMW5u?=
 =?utf-8?B?eEl3WEI0T3ZKQWtWR25hRHVXM0RBWEJGU3Q1bFM3WVgyb0JZdEM3dEJHbUhy?=
 =?utf-8?B?MTF5ZVRSQm1oTEhHV1hxVUE5cjZiMVp1MGRLMnd3Yy9WU3A4TEZZemRLZTJN?=
 =?utf-8?B?SjJwSnVkUTQzZ25YckxsVVpZVnNPVVNEQ011U0NOTk1lVng3M1l3bHJJZTFz?=
 =?utf-8?B?cnd5RUIveFFWMlVjb3BxaEpZSmRhZG5Ta2ZDa1pneFJXa3ZiR3VCNHdBZ1BR?=
 =?utf-8?B?dStmTFRWV1NVOGNkUTRkZFU5VzNoYjYvRjh2MHN0S0RQK0NwSFpQSXNWQ0Yx?=
 =?utf-8?B?azBRZm82a2gvUE15V3hwbU1ic1UvTzQvYWNXUkdOcGtkR3lxTXhuUkhSbkNi?=
 =?utf-8?B?S0l0WThrQjFZU1pCOE5RTUlhL1JtVlNub1BKb3BpZDUvVWxtSWhLdmxsZ29l?=
 =?utf-8?B?VTQySjgxcmR5Mjh6QUtodmFnUGRyZWFnV0J2U3VMNlJjK1FvdE1mS043cWJu?=
 =?utf-8?B?OTRKeXgydXNNcHIrNFZrdTROcmVFV1luQmhmR2xzTHRkVmlqZWNmdWtXNFcr?=
 =?utf-8?B?TERQRUYvUGgzbnIxekNib1dweUtJYVlLdlhyM3lGbWpWcUlUZEZmWnhFQUFF?=
 =?utf-8?B?NVQybkt4WGtWdm9xZ09sdUtFbE05K1h3bDdRcGg2ZW80QVp3T0JVMHpEb2VG?=
 =?utf-8?B?d2NENjFmWnl6RFRyd0RIczJCK2lwZFVPcXJKMFpSeTN4a0VBTWt6Z2hZMDY2?=
 =?utf-8?B?QytDdFd2TUNWc3VSNDFRYVB0cWttazdUS2Y2ZC93VjlkSHhqZ2syQ1d6ZUdP?=
 =?utf-8?B?dTVVNFBmejMyMmhEcDZXWlh6L2VBMmxoUncyeXYwYjBiNG5xRkl2R2YxNmhJ?=
 =?utf-8?B?QlJ6QkNCS3NyZmRDTFlWbnlZTENhREdFL0I4b215S1FOUUxpZFJzVkNPT1hI?=
 =?utf-8?B?ZnlqWDE3NU1RY1k3bTFZejFWT3ZNYTJnZkRreHBla2oreEtqaXBNaUVXS2VQ?=
 =?utf-8?B?VWtrRk5XYTVvYVZGMVM1bzNsMXYvQXVlTnZQeFh0ZnhlY1VnT0p1Ymk1aDB0?=
 =?utf-8?B?Yy81MUtBWUNxU0ZDbXBFRUgrQWZYMWh5TDl5K2ozMGVvSzJjeVhYODFlK0Rm?=
 =?utf-8?B?ME9WSlBxSWlrazhySUtRQkh0T3k2YzRrZXNZSW8wU3laMDEyZmtMQkxqY045?=
 =?utf-8?B?ci9hVGZxaUh4T09qS0NtdVRyQktoMHY5aTZmYkh0ellnUklDWHZ2T1pGQyty?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61636A3BEE750F499B55DFA5020DBF24@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f92095e-10ad-4d1f-e49e-08dce7f38ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2024 23:47:25.7696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JJau5RCTLyrAnzqBHkgrdBqY8hQSC8v50XLC21g7EvYd7BcJTUwwE31mlXs/vqWaMobTQpwLkzkde3efY+CzMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8192

T24gVHVlLCAyMDI0LTEwLTA4IGF0IDEwOjM4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICBPbiAxMC83LzI0IDExOjU5IFBNLCBlZC50c2FpQG1lZGlhdGVrLmNvbSB3cm90ZToNCj4g
PiArc3RhdGljIHZvaWQgdWZzX210a19jb25maWdfc2NzaV9kZXYoc3RydWN0IHNjc2lfZGV2aWNl
ICpzZGV2KQ0KPiA+ICt7DQo+ID4gK3N0cnVjdCB1ZnNfaGJhICpoYmEgPSBzaG9zdF9wcml2KHNk
ZXYtPmhvc3QpOw0KPiA+ICsNCj4gPiArZGV2X2RiZyhoYmEtPmRldiwgImx1ICVsbHUgc2NzaSBk
ZXZpY2UgY29uZmlndXJlZCIsIHNkZXYtPmx1bik7DQo+ID4gK2lmIChzZGV2LT5sdW4gPT0gMikN
Cj4gPiArYmxrX3F1ZXVlX2ZsYWdfc2V0KFFVRVVFX0ZMQUdfU0FNRV9GT1JDRSwgc2Rldi0+cmVx
ZXVzdF9xdWV1ZSk7DQo+ID4gK30NCj4gDQo+IFRoZXJlIGFyZSBubyBibG9jayBkcml2ZXJzIGlu
IHRoZSB1cHN0cmVhbSBrZXJuZWwgdGhhdCBzZXQNCj4gUVVFVUVfRkxBR19TQU1FX0ZPUkNFLiBB
biBleHBsYW5hdGlvbiBpcyBtaXNzaW5nIGZyb20gdGhlIHBhdGNoDQo+IGRlc2NyaXB0aW9uIHdo
eSB0aGlzIGZsYWcgaXMgc2V0IGZyb20gdGhlIFVGUyBkcml2ZXIgaW5zdGVhZCBvZiBieQ0KPiB3
cml0aW5nIHRoZSB2YWx1ZSAiMiIgaW50byAvc3lzL2NsYXNzL2Jsb2NrLyRiZGV2L3F1ZXVlL3Jx
X2FmZmluaXR5Lg0KDQpUaGUgTFUgcHJvYmluZyBpcyBjb21wbGV0ZWQgYXN5bmNocm9ub3VzbHkg
YnkgYW5vdGhlciB0aHJlYWQsIHdoaWNoDQptZWFucyB0aGF0ICJzZGMiIGNhbm5vdCBiZSBndWFy
YW50ZWVkIHRvIGJlIExVMi4gV2UgZG8gbm90IG5lZWQgdG8NCmNoYW5nZSB0aGUgcXVldWUgc2V0
dGluZ3MgYXQgcnVudGltZS4gVGhlcmVmb3JlLCBhIHNpbXBsZXIgYW5kIG1vcmUNCmludHVpdGl2
ZSBhcHByb2FjaCBpcyB0byBzZXQgaXRzIGZsYWcgb25jZSB0aGUgU0NTSSBkZXZpY2UgaXMgY29u
ZmlybWVkDQp0byBiZSByZWFkeS4NCg0KPiBBZGRpdGlvbmFsbHksIGFuIGV4cGxhbmF0aW9uIGlz
IG1pc3Npbmcgd2h5IFFVRVVFX0ZMQUdfU0FNRV9GT1JDRSBpcw0KPiBzZXQgYnV0IFFVRVVFX0ZM
QUdfU0FNRV9DT01QIG5vdC4NCg0KUVVFVUVfRkxBR19TQU1FX0NPTVAgaXMgdGhlIGRlZmF1bHQg
ZmxhZyBmb3IgYmxrIG1xIHF1ZXVlLiBBcyB0aGlzDQpzdGFnZSwgaXQgc2hvdWxkIGJlIHNldCBi
eSBkZWZhdWx0Lg0KDQo+IA0KPiBCYXJ0Lg0K
