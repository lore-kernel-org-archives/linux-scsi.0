Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B260392801;
	Wed, 25 Feb 2026 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015705; cv=fail; b=aom68atz2b4Rqd0m0qp4qmlN4Ca+lxD6cp1sKRJTnYBOpd+PVxf5bCWB4kqANgq9vOwqiExlxdoYPZbkWJOp06ZrOPGlwRHHSvOyKoTN/gYaZdfFQ4I9tnR82WZhsG6CNGMozOLQycIKoJVsMPmleA4cOY8BcdeGw21vASaTvBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015705; c=relaxed/simple;
	bh=Rp1j31MN7IpJr4GwuUbm95/kADjsbK9fmhMSNNMjd/0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BcX8N7q4IG0ow4Z2PZASJ+9SsxpUGDeddxLL3C9TmCFGu2JWItvWX0I9YeuiTUSGiP4XmwKfVQ0OnULd6hv40z6zpxSq+Ob2MH3VsVREksmTueBzI2zBm2rOrYaJayflUQAk/2Aqd4SSemrqaJ1vrzoVqE1kjUpg7QTKZhZP0+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OnHfb/KU; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=NwZfnria; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OnHfb/KU";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="NwZfnria"
X-UUID: a1694bec123511f1bcd7499a721e883d-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Rp1j31MN7IpJr4GwuUbm95/kADjsbK9fmhMSNNMjd/0=;
	b=OnHfb/KUDMcifW87f35SudHFrOCbmwUb0FzT4Isz7jdC9Q5esKpQl0V+rtK6lK2rGQGDJXwfpdFiTDPPqduOmthJJ/iNBlS06vkRAFkEqpJ5TFYQGE60xvjm2mlDxGnXzPdXm7JOvmZbxlC35eNfoK4zUrGCgZaLQP9MzTbAiFw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:2e970da5-71d6-48fe-96ce-5da080b4704b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:610efff0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a1694bec123511f1bcd7499a721e883d-20260225
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 859816888; Wed, 25 Feb 2026 18:34:57 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:34:56 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:34:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c93pyOyTPmyes3CXJes+bF5jNDZf6vtKM2a569knBX1O00v+ha2Y1R4KKWZgGQm5O63op7NOpBWWrdC79xf1u9tBp8BkmEV67HdD/jmbb/GnKgl40yV53xcaGrxzmmLg3SinR33+OxiDBgs6oNF/77vNFjggmTXO7qZLdN1KzUCTSfKLYTqsbKpgVeLDhQTJkX17C8IExkIrr5UPBgdrYATvyHBTzAULelFcHz355x3WIvCogvhUR5ZIhZoD8fNs59Pau8f5702vuZXVLesckxfKsTCOJ5bOyaesEBfMaEFmJxW/cm3kSLpXOvHXnRn8dcfxycBsoiEgeSwajVCYrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rp1j31MN7IpJr4GwuUbm95/kADjsbK9fmhMSNNMjd/0=;
 b=W22hZKjMF+ShTLzhX2J3KKwgwvuQDOzg0NGdxxEoc3pqWHMV9PB7pwjzxWWFpL3ZgyqXrqBvMHJWoHQbSlCl8nrbTG2rC0iqFnmtdNiqquZGLY/hp0lmoHEaaOhWzq05EyYUEr/ZM2ujzCQBjfxC9v9FJRStE12vlrrqmHnuWWWPd9d24xpQugn9FZ5Frir2vXIdlnjfBtYnRga+MVQotzG0v7FMst1mwZblqSiNXDk26lsNZHB7vLehTCSsAx6EIwoqwAbtUdDUFPh43ytDZA0v2KIFL1gceMI6Rc5MRl1spEqmHMbxxVoLA638o7Y19kBavHlbusFrY7sqCJrw9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp1j31MN7IpJr4GwuUbm95/kADjsbK9fmhMSNNMjd/0=;
 b=NwZfnriaJO798vhhYozYpBdJi/AaFcLqq67FWea06f+QFWWdDgq9GpWJ3qhZJCTWWSdH7WNZj5wT45Vzfk2r1JYR0mTLOmA0D5g2snBz7WFnR+b6Jsw9a0D+szNl5R0I6+KFXWk0yQaSIDKKQm7DM9Jw3pVsomaJeqYOeIl9DrE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI6PR03MB8652.apcprd03.prod.outlook.com (2603:1096:4:250::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 10:34:53 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:34:53 +0000
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
Subject: Re: [PATCH v7 19/23] scsi: ufs: mediatek: Rework hardware version
 reading
Thread-Topic: [PATCH v7 19/23] scsi: ufs: mediatek: Rework hardware version
 reading
Thread-Index: AQHcn0oVKXVThtd4YEePyfvizU9TfrWTRisA
Date: Wed, 25 Feb 2026 10:34:53 +0000
Message-ID: <9ab33a80c1e367083966cc459161f60945a1d894.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-19-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-19-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI6PR03MB8652:EE_
x-ms-office365-filtering-correlation-id: a711bb14-62c8-47ba-8994-08de74598348
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: P//y0lBN9ydhST4kKcVLClove1WY5yMAG/J32/J6VDgdwFSTDD8o7BEm7kJKVZoChyYOCiqOpI0VkKfq+LhIO6NyVEiMoNJkdCZZ4G8geyMrzg98iZJ5XRCtjzKBtagZ5jE8Vjwg5DWw84n/q6pTPaEA15XuN/+221PK9fcHT2cqqznRNcZgoMCbdTav9yZaORdJFHKO/XJ8GlwoMMUNP8y85O1ut0kkyjdk/iNM3QIabZQIhV00ol6lh4mZQzNphRx4AAeksYi3Wa53woWs46fVQYlDi/HMfDZDQMeDd2RfNtHQtaBp16Is+NteCrPRwB+LxV31qzQXmgfAYm2WNDC/Bfb+LD8np1kJyWQRVuRDu7QaelxnCZrqhhN45A8ZTjpV1M5T+gdbbSNzLqCdD61c6dnqfsZLWBxyMZ602c8PCsywbwMQwU3dyXLJ0Fndl3I3Lg+90D9ek7ZhlNbeIu/dbGiYAxSZ3e+L2kjJUb2bEgNG/7VFfdoZ8GNDTNuNo0XwOnGN97Wm7KzQ0SkhSs6pu1aeQoIVXjD04ZSxjo/mTFF/G2ZBoFP5mK4vVdD+ZwMTN4gHON96wxdNYcY+42xLnqu5cCKCnzapRn6m7bL9z50bkZQRZFE75kDCf3zTVlYqadRtVLh/UI2/0JdFx9jKtZHbFbmZJEJpcmSNw7m6XJuaRnLM3ngWXWyG5eE5Q5fTGPXTyHQ9ZPa371jHhaeqYrMk3HscqsPcZ5QELX8p9ctXN/gf9jR4Zg/Jk0WXhXBPKD/MPP+HZs1/ttEF7c6DX5jTMNg9kPfBcHJ6fdyW868JDXtYnfI5FuOjWsLm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0EvRnMrZWIyNEV2c3Q4SVJZYnF3SkZ2OXU2N1IzSEI2NHMrdEdXQnpCemVh?=
 =?utf-8?B?dmJkQTVkNytYanhrSmhOTldJTE9odXFZRmdNL0VOdmFuZ0ppbGx5NS9uTkI2?=
 =?utf-8?B?ZU0vdWYxVWl3Z0V4bTJzK0RGRUIrcEFZeW5hc0lxSWhGMFV2SDIwU3NwS0E5?=
 =?utf-8?B?Z2lMSUs2eWdpM3pmVmpFYkg1ZkVuQ003c3FCdnlGV2hEWWRkZXA3RUh2NFpO?=
 =?utf-8?B?RDdQRVlleDJPeXNycy9LMzVUM2ZTVUlqdytBNk82aWZTSGVLWDBUOEpldEtn?=
 =?utf-8?B?LzhyeWh5TDhGd0Z1eU9ReG9qQmVEZG9sNVNQd0d1ci9RcDRUckwyY1p2ZkFa?=
 =?utf-8?B?UnJxSEpZWk1JcDRBWllkS3d5QjArNWtCMUdLU1J3OG1tZkMvQ3BqV1ZPUTdR?=
 =?utf-8?B?cHJQczFINDZRalRIVmxSZXlJK3FKeE81a1JuZ1oydStMVXpkR2l4VXZPTkQ1?=
 =?utf-8?B?ckR1a282bWJ1ai80OU83K2dSRllPbTJzbUVtSnpPditJVjk4YmY3TDNBdkhs?=
 =?utf-8?B?V2pvTDVsSWZvWGRackJSSE56VkNSQU15ZWEvNXR4NGRwOThJRFRwd3RQOFVr?=
 =?utf-8?B?S0VMK25KZFpFSnFCdTlhZjNHZ2ZBelhvZW5peHUxUkJudmNDWWFxcXNwaE1i?=
 =?utf-8?B?NVcvbUYyTXB0dkNsaGhNRE4ydm9FMS9hM2taTzF4Y0RWVTI4dUNOajZ3WVV1?=
 =?utf-8?B?dmZhM21PcjJlYllPVUxXOWxFUzNXaWxKbWRwbWRLU3FOcVFWRUxWREJtc1JK?=
 =?utf-8?B?bERaRFdlMGlYTHJjQ25ORXBlNHgvY0FaZDBla0NhcU1jeHZSNHU0bUtRdCtv?=
 =?utf-8?B?MDNpWnBRRzc2SmxvUnZibXp4NVdqM2duY1B5MkVGUk1uTjFOa2dZUWF2VjdQ?=
 =?utf-8?B?d2M3Z1lJcHBMK0ZKMXRSY3RLZlAyb01Hd3czNGxXc3F1SHlSUklXeldnZlli?=
 =?utf-8?B?bnI1Y0lacG1GWHFEY2Jsd2Ztcm1yOUpRdVl4VmJJaktMakZtNy90OHVMNjRt?=
 =?utf-8?B?R0dETndwSFlmUGpJdkFtd2hpcEJWci9xanJaSTNqcXdjOTB1UVdONlBJWXpl?=
 =?utf-8?B?a0VUUHR2enhjNFBxVWRHYmZkQnVaWER5M1FhWXJ1MkhYakNnVzgzY09FVWpm?=
 =?utf-8?B?bmJkVk5QSnFMdzdmY2VURy9Eb2x2ckNDN2pLRTZsWmdVbzdPVlNhOWI1WXdP?=
 =?utf-8?B?K2cxUGQ1ZmkyQlpnQk5PMERyYlVRTXhQb1pyZWMwaU1ueks1SEkrL0duYzJs?=
 =?utf-8?B?c3VhNFp3T05nUkRSY2VONlpPV2RrZ3BLb0xMcnU4SUtaa05MaTFMTTJ2elBW?=
 =?utf-8?B?aHZPeWJFdmxNdUo3SmRERFA4eFVpQjJMbXluaTZqUVRUcmdBaUcrUWRLRUZX?=
 =?utf-8?B?UVpzSTVUNmlPSmtPdFpjTnNnWHRCRFpCQitIZmVPVlMvRU9ZL01MTTdDU0tx?=
 =?utf-8?B?QzVrR2Q2cXVMN1pxV3pTS1FKaTRZUmFCdXp1TW1paTNwLzIvczlQMmJ3ZmY3?=
 =?utf-8?B?TUl2Ti9wOWl6THV6QVRTZ2RsemdnZzNRUC9YUk9jcForY1BMTFdSUE9XYkVz?=
 =?utf-8?B?ckF4aGdma09raGovKzJBR25KOHZ6TkVQOXpEa2QydnVra2JnL3ViZ2xWTng5?=
 =?utf-8?B?Qjd6Y0VKRW5tejBqZFlHV2N5M0V1ZHg5Tm8wK2F3cDBMZUxKWnNmbmVkU1Y0?=
 =?utf-8?B?SE1KeVhGMElNck4rVDFCRTZOS2FyNXBycnVFLzBpZHR2enpBcXBNeThaSXpV?=
 =?utf-8?B?Vzl4UmZ4TjNReFU1Mzd5NlphdndJTjVmYnY3RmNHc3JtNDFXUU9yWnNKQi9S?=
 =?utf-8?B?bkpqbzVCRDdxNkN1Z0tIdWsrMHUyZ0VUb2E4dmlBWXozZ0dHVFpuN1hDcjE2?=
 =?utf-8?B?ZHIzVTM3RmZKTTRSSW93OXlSc0RPN1NLaU9yR0RPTHNiQWZKTndTVTdOQ0lk?=
 =?utf-8?B?RFJYTStFUU5MS0pDVXVQNmNoeC82bS8xcDhjTlMySjhJUFYwK2tET203U0U1?=
 =?utf-8?B?Z1VkWUJRMXc0YmRCTTNpcXRIMlhpS0sxL09IT2JNVHo4QWdNcDFPeU02a3pR?=
 =?utf-8?B?TWs2dmlZMzdnSjV4ZlE3M01oWFdvRXRGcnBuenUzTWNzSWNzNGtpWm9QZ2ZH?=
 =?utf-8?B?Z2tETS9INkZnQlRqNlhndWExMVpzb3JjVnVnK2hqK2wrK29VTTA5NzNvckow?=
 =?utf-8?B?UkkzZHdyZjdLQUsvOHYvSVRrYjFkYVBIMzFoRmYzTWJpWnBrMnhzUkgvTEtq?=
 =?utf-8?B?bU83REJQVEFUNEhzTTRmdGJPUHBJZFV2ZVM4T3N3RjJCZFlvbzJqaDVJTGdH?=
 =?utf-8?B?akU5MGVtU2hsUEpNei81T0JDNjV0RFlRajNMbWhSQ0lnZ3JNbHJDS3hKeFdK?=
 =?utf-8?Q?umzVjeOJZaEDECro=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C02F2400B77BD449AD4A2B339DC44A6B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: i01jwBSKSQLkkGnpSFphNQF2bd7dsk0L8jdNugsybw8+qZdMBOE90TXc0Hw2iF28jAlq96Izt5SGfMlktLKXyl1FySLcrckiFRgzK5qWVc7sP6BLzgCDLtsnyhZlcM0zOAwdL3ZRRpoJ0aj6VWX1ZhzOJbhCl9CSr0tj6InoMYjzoyqzt1LoQej18KHDFDiC47QMfSYoC6ygeUGOIRst4NWUwQLKUzAkMu1bks3R5UCoZMF+/vxhOjDHZYtcGwHoIFmr8G7+4y3FvMXDkb6F1GtLsPxqsGWWvY9ViJwNw4D5kOM6U4jka4+XmMnhz+EMOjPPG/RufNDNN4sJgy5egg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a711bb14-62c8-47ba-8994-08de74598348
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:34:53.6554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qviqt6pDX+2g1y5SYsa2ce6UZ+27+xr3S8d7Si0HXJb7HmEsWNN7f1DWhHdSVF778rvpi4j3xqWTiqftdAyzZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR03MB8652
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFNwbGl0IGFzc2lnbm1lbnQgdG8gdGhlIGhvc3Qgc3RydWN0IG91dCBmcm9tIHRoZSBy
ZWFkIGZ1bmN0aW9uLCBhbmQNCj4gdXRpbGlzZSBiaXRmaWVsZCBoZWxwZXJzIHRvIHNpbXBsaWZ5
IHRoZSBjb2RlLiBBbHNvIG1vdmUgdGhlIGRlYnVnDQo+IHByaW50DQo+IG91dCBvZiB0aGUgbGVn
YWN5IHZlcnNpb24gaGVscGVyLCB3aGljaCBtZWFucyBpdCBubyBsb25nZXIgaGFzIHRvDQo+IHRh
a2UgYQ0KPiBzdHJ1Y3QgdWZzX2hiYSBhcyBhbiBpbnB1dCwgYW5kIGNhbiBiZSByZXdyaXR0ZW4g
YXMgYSBwdXJlIGZ1bmN0aW9uLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEFuZ2Vsb0dpb2FjY2hpbm8g
RGVsIFJlZ25vDQo+IDxhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxhYm9yYS5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9saSA8bmljb2xhcy5mcmF0dGFyb2xpQGNv
bGxhYm9yYS5jb20NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KDQo=
