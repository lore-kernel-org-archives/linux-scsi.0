Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128CC2D77FF;
	Thu, 26 Feb 2026 06:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772089177; cv=fail; b=j+IRHSHH8cKxk4W9nbI68lgIGlVa0vuB1CcyC1e43havAzHT1JaS6yDCcByUS7CaCVt/ea9pYgSZxEIvkBWAJmSetP+YRLmyFRwKMf1sYg8aWaYLdv22TanKXN1JZHMBanYFEoT9bDNMIv/YQY5h0SvqlxlNyQdeWWByDnow9DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772089177; c=relaxed/simple;
	bh=4OBmNVYcj5hrpOHwZq6xFv+ni1VxvCGCIFwYZQ/esC8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hbE2M2s6d5hbzbwkO/pPEwT+SQUFnUX9zOs/BFmIh3oNqrU0u724k29NAuRXLxJuwOEeNiY+JhBajpNGiilZoUtc2ssQq+Def5uaDPde80NZ4gUlJHacy4/WuCtiOojp0XrMtx7CTPB+yH6OWopbxl9A4uVgZ/takGOrmIVKktU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dos56v5g; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tJFKaEWT; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dos56v5g";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tJFKaEWT"
X-UUID: b42a6dd212e011f1bcd7499a721e883d-20260226
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4OBmNVYcj5hrpOHwZq6xFv+ni1VxvCGCIFwYZQ/esC8=;
	b=dos56v5gQpoJVs60e71s+Kxpbs5FODlP0XhmKTksTQd1KA/fWR+jNdwOKPb5soohjgIZGNFAffvhaBF8gMHZeG6EsO5Dv1kPw82i2xuyvkssnWXArZ4r4ykl93JaLr/VNIE+FfgKqts61Ht+76D4KBpYnzNww1M6x+CpZejxIts=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:29ca3cea-ffc4-4953-9dcc-b9ce9d2bc182,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:f46a03ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b42a6dd212e011f1bcd7499a721e883d-20260226
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1786557056; Thu, 26 Feb 2026 14:59:32 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 26 Feb 2026 14:59:31 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 26 Feb 2026 14:59:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zdf9A9ymwQeUiZ8OUKvwDB+xem/wrZEd9Ey7RX1a/x1prtNYLw6TTiGadpXXWwcyuo8qLXbP4yZ/ry58y4VzOyqVJbgwuydUKYOtXWGLrhFH5FUrWeGzced/TvS3DCiZtBGpi1K6xRO/YSW9Me73FKzj1wcS/e9WGSOAhvSzepUKRiAOhINZFVJPjj3viEOsbdrUg3C4tkiviuM1rfLPlV7R5wPhYDIBtzkzS5NQuygsJpwoHK5v0xNYQAFAlX3tGIYVPAv/6+w5vfzw0wzAwiwZ9dxwBBjaLep2+UhgNzca2V2c9tfFPMS6KAGACacyjOa/8SrJfrS6olhSKCdGyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OBmNVYcj5hrpOHwZq6xFv+ni1VxvCGCIFwYZQ/esC8=;
 b=UQA1U09SNCOeRdBbbDAvAF0qxfVxuLymnBmP9Ko/VySgWpCwFE2EbelBsUqKqXBizqT76ZCvWuGejKOy/juE1w4LP9FPeBVQ4fSjyQY3Qok52b59SJ961raBihePYpf8Pvy4bCU97LYvUDTzu91z0FbdaRiEjqGqI3+6xUJJZ5FfKCywH/HT9NUxExXOC+hI5FYNpn8YhJe64nUFqXeLvwOHCPijb9+/pJt0uQU3Fp6iDxxDlnH0gT0qFTUAOVk+OCDEsvaDhavbcJMoO/THCjooVv4UfDAcFoR1Hze5QpdxPLzhxxqLvLGLz0kQ2O3khNSV/AHjmXLx895HJTzlUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OBmNVYcj5hrpOHwZq6xFv+ni1VxvCGCIFwYZQ/esC8=;
 b=tJFKaEWTRQ6co5wKDrGLw5nUzfSnbtcxujS8XDt238z7lzi2uM+16QrXO7CGlbe5iMHwdAXBN44B3Dx7yKoBNtui+KyQQ57Qj7TX3E/E/uBNoTbSX8eWQAT/KaxC+mdodoA0vQUxgFRLZrJGkYF87s5rUn5twInSTdvtl+SMjNA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7394.apcprd03.prod.outlook.com (2603:1096:400:422::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 06:59:25 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 06:59:25 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "broonie@kernel.org" <broonie@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-phy@lists.infradead.org"
	<linux-phy@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>, Louis-Alexis Eyraud
	<louisalexis.eyraud@collabora.com>, "kernel@collabora.com"
	<kernel@collabora.com>
Subject: Re: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Topic: [PATCH v7 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
Thread-Index: AQHcn0oAy9P0aKXVVkSCKhBIuR1jYLWTRuMAgAAm7gCAAS58AA==
Date: Thu, 26 Feb 2026 06:59:25 +0000
Message-ID: <a010d4a6c4fde8f2da8f855ac155f54848179b18.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-22-b5f2907c6da7@collabora.com>
	 <e452951498ae82433337ca428bd49c7358194dd8.camel@mediatek.com>
	 <6563087.lOV4Wx5bFT@workhorse>
In-Reply-To: <6563087.lOV4Wx5bFT@workhorse>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7394:EE_
x-ms-office365-filtering-correlation-id: 60afe5be-f209-472a-21bb-08de75049419
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: ftA8Y0iuIkU5hi8dWoT28JAo8IyACBLfkwFjUVCmg0hEiNxbTNJhH550JMJYaHN73gGK1bjT7SVVWJZ8hCZ/X8G76MdvMSxHPJyRPIY+m9bExj4Qf7aS2yCr9AnXXgaGRsmYI9XN0fVUwwjOWKkSrBpY7yDypcviTiWN/I/8x96V4dI7wD59ybRsUC4JBzqWP+d9eF3f8L9h18Rsghan+8KQKd3/69ZpHMlaE6IqTllE7sELudV5Yx+b6W88LoXBoP2L3FmKg2xxhfpaTt7rZFTqONjHef7ERx9yKkJPlGg2iBjc07oYtjSZ8rYAV1L5xzCQ0uChMAQj8CJnCknVkFlIR/Cese5783fBul0uQ4HF7fmpACniNdf56bzFVpX4Rk3hGIBxU4wTpA4ZNfist5UQrYuzjbuDiHJaKFiQphGP4do1lm71aakodDq1qNSuV2+xCulfZMbgI0OVnWJzdAJ4rDQL1IkumVfnmZp5cFkKohhv4OCVcLt3Cyurwd4nEVFOTUXncH/yRpLsSRezVdozwooIoANBLXtnsYZvPgNS8ReGO3FIV86DtFSe0ZqAD4OEldDFvU0RC/sB40YmwDyUxJTk3KnZCOV6MrnbDJEMX3EpvN/Q/JZtZC8+qtXzV26b8ULF79waS8GAH4DHz83fmXIU2Ick57sPcgnFvMLvWoVvNo2BF10xpddDpF89qXqlYuDLyurB3UK90RP6zyaSedYgO4O3InNfH+AamlZpoA7iw2zOuyd/JDJmxE8nE3U5s2+vLnnTwV6KqeyTtsJNDWtlmTPQ2OCL3mnp9Jm62K6Y7FSHSgwRd015Y+F2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NExTL2dlcmxDVnU1UC9MNFhKQllDYUhYTUZrd09uUjg1QkRCMURlNC9Wa2Y3?=
 =?utf-8?B?cnQ3RFNUVTFlUnV3R05ER0hLS2wrM3psVi9HWlBaVis0WU9WK0p6REhFRmsr?=
 =?utf-8?B?Sk5BUXdMNmgyc1RKZ0dFakFUdkNuT282Tlg0bkFzQ3B6Qld5L1dWb3FSUGxh?=
 =?utf-8?B?OWtKZ1UzcUNPWlA5MDlzNU43QlhEOGRpeWZuYms4NGIzbmd6dW1jbkNZYldx?=
 =?utf-8?B?U1JGaU84MmNxSVFoR0lvYTRhbnUzK3Z1OE5GNTg0dktXR2VuVHFxcmQvRUNN?=
 =?utf-8?B?YU5za25iVjR0K01QMEZmcGZYTUI4Y05kWU5zZGMwdFpQODU3Z2RQTDB4c3R5?=
 =?utf-8?B?UGVwMm55RkxRU01RY2JaREVQWktnYzJVVkIrMytDNG9kTk1CM054YmRqTVlP?=
 =?utf-8?B?UWpieTd2Y09UaVNXWW1EK1hQSCtZdzRMcnJybDJ6aTNiYlFodnRMbzl2bnFM?=
 =?utf-8?B?LzJycStxTzJ0NWpMY3A3Nk5jSW1mLzRXaElrd0FJSlRITTBscGpvMU5rZjVk?=
 =?utf-8?B?Zk5lYnNXQk9Sa0p2eUViNHFWYitEZnlzYXdGbkN3emI4bGhjcksxZm1YMndl?=
 =?utf-8?B?MDd4L21NdEdLampCN2YzZmVtaWVQSVNrdVBnMDFrUGF2UkovSlNmdE5KN0li?=
 =?utf-8?B?T21VZmVtM1BJMjV4M3FBS3VTSTV1L0ZmOVBQbGRhRXlZNjZaUmgzdzlKUk13?=
 =?utf-8?B?QTVvek15aHlSbzJycjQxOGovSFdBcURPbEFkQzd5ZnRqMHdEK0ZEVS9SdGdi?=
 =?utf-8?B?VzVOQmtQMWcvTUdXbm1PNzN1SjY5NEd0dkoyNFI0ZDBiMndsRHN4ZTZLUG52?=
 =?utf-8?B?dHFvYWxkU1p0b2xBeTF4RGI1Qlh5c21OTklMV3c3MHhFOG5vb3BXb251dWNp?=
 =?utf-8?B?TWt0ZmRXSkxZSkU2Q2ZrWmcvNnFKeFR4TEFRd0tKSXRYVFlMak8yU0RDb1VQ?=
 =?utf-8?B?R1BGUk90WmsyNWFpSW5KemRramt4SEw4S05mQjBKUks5ek1qSmFBYnRNckdj?=
 =?utf-8?B?cVdaejZ4eENyOXEwNlhIalR5QmZPa1g5dUQveStQS3c1SnhUOEx5emw0bjNE?=
 =?utf-8?B?bC94dUlkbUFTU0tyNE5UUXk0MmhQd1FjUEJML0taUkNQVEQ4WjYzeSs4N2Jk?=
 =?utf-8?B?MWVDNHdLekw1Mm1JNUZJc3MyN0p1Y2ppbmQzaVZhOEk3MWU4YW5lckJWR3Iz?=
 =?utf-8?B?ZzBhTWtvdElQYVBIQ0szRGJMTHZHcjN5UHhPQnJ2YWVjVW9RS3o1M3lDcXhi?=
 =?utf-8?B?S2c5eEtxLy9TWGVJdFN2OVlrVzl0Q0x4VkdHVUZudHNQQ3I3UEUzQWxmcDM5?=
 =?utf-8?B?YTlsQkdWMEM3SkFpK1RVeFpzZkpnWlJ5UEMvZDQrdFVGOWhiOGtoWmtMdDM2?=
 =?utf-8?B?a1gvRnFUVGl5VVJrT2YrQ1NSb2ZuWGw2S1pBZ3gvUzQwRjlPbFhUQ1E3V01V?=
 =?utf-8?B?Z04xcW16dTJnc2pocXZSZTlNMkRXMVdUYUFDVisvL254c2hrZWU3cURzbzRq?=
 =?utf-8?B?T0UycjJoUW1hdUtRWjJFUUhWdE5rZ2RKQzRETmZmQmVXYzNrZVgyanI3K3J1?=
 =?utf-8?B?ZzlPVXM3UjFZQzR6V3Bzb1FpMEFTeEVETkJNMFloa3RWNUwrY1phbGtBbWli?=
 =?utf-8?B?Rjc2bGFwcGxlendvdjluR3RCQytVRC9veERSaVN1NEpSODU3VWVvbjY4Vytr?=
 =?utf-8?B?aEpYYThPcDRIYjBVcDRVRnptTmxMbHFsRG84bUtsNFhlRnpyQU1SaVQ1KzI0?=
 =?utf-8?B?bk0veFpDczFLVE9LUkdhMG1GQkw5eU82ZjBNSEQzTEF1KzRqSXVER29lVS9B?=
 =?utf-8?B?d3poejFSNHJ5eFlIUTVBR0RqVWZGLzVYODBuS1dNR0FSTDQ2a0xjSkRxVEhQ?=
 =?utf-8?B?VlIrZVJ4S01jUmZHUGxBK0pOa0ZBQUhtWnNMVGIwTmM0MUlwT1l3S2NTRTQx?=
 =?utf-8?B?ZWFZRFhhaGt2WjNWWkdWNWJFMzNmb3J2Ni9qMVh3aEwyRWl2Uk9Rb3dFRXA3?=
 =?utf-8?B?QmxyWVpmNU9oNVRwUkQ0ZWVnWkxQbElZTVZWc05aTzlkMVdYTXZ5UmYzUU94?=
 =?utf-8?B?RkFWNDB5aVRDV3hjMktTMFJTckxMeDdNU2FWQzlkZmNTeXBHcHlKL3huZDlM?=
 =?utf-8?B?RWQ5Wi9MK0pPQUFvRjNNOXBYOUlrNm5VQUplTWRQcDJHKzlQaEEzb2xFNHFl?=
 =?utf-8?B?cGxjRU1IQklodnFmVzREUWxzNkJLTjZNZXJjQjBhY3NYUEJwZ1R0d0NNdE93?=
 =?utf-8?B?WTErYjNiV0JaRHYwVGNEUEFEcTJHMjNUWXVJTXhiVkpiQWZUTTAvQlVuYS9t?=
 =?utf-8?B?dnZkOGh1Q0NlV1NFM3VSWFh0SHlMOTEzRjdTOTYvSm5YcE1ZdFQ0ME1rYU5H?=
 =?utf-8?Q?XUfVLvz7R7/JuDYo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBB4F5B27BDDD84C86F50AACCDECE74C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: SJCjPVjMx9Bh3H8lSkP0g/89fy44gXFV83IDaVuxCfbc87W6NEO2Q7l/C9NXHEANTTqGKOUPlpenBw95z5A1nfRm8BD8ePiTjG70CGZb0wbh2/VVzUo6xYvWpTXqOGAhIS/UwBm+hK+NF1wwIT42if/DfEMPnN5FVtQvWu6ZePQ6kxFMig5TWtOSfHh/dwmNx1khkgIQ8Un9f3Pv0xNCRvBfq3btGoAU9+de6TwMAAFdmoMH56eb270xg1vWwDsgGPtBMK39Jb6bYodr2cpfuQl4Nv3+g65rY6X9f7a1/uFnFCetcrSN1PHfjHFIIwnXF0uuH/TCq3CH6At/mC9KtQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60afe5be-f209-472a-21bb-08de75049419
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 06:59:25.7765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LDf+52kSlPX0sn/GK3uInVI/dU54AUjXuc//DLzESfOSuRDQxoUAxAKlj2pP5ELvrRHGa8BgviuVMJ2vQDuIQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7394
X-MTK: N

T24gV2VkLCAyMDI2LTAyLTI1IGF0IDEzOjU2ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBjb3JyZWN0IGJpbmRpbmcgaXMgdG8gZG8gdGhpcyB3aXRoIE9QUHMgaW5zdGVh
ZCwgd2hpY2ggaXMgYQ0KPiBmdXR1cmUgdGFzayB0aGF0IGNhbiBiZSB0YWNrbGVkIChieSBzb21l
b25lIGVsc2UpIG9uY2UgdGhlIGJyb2FkDQo+IGNsZWFudXBzIGluIHRoaXMgc2VyaWVzIGhhdmUg
bGFuZGVkLg0KPiANCj4gQWRkaW5nIGEgImNsay1zY2FsZS11cC12Y29yZS1taW4iIHByb3BlcnR5
IHRvIHRoZSBNZWRpYVRlayBVRlMNCj4gYmluZGluZyB3b3VsZCBub3QgcGFzcyBEVCBiaW5kaW5n
cyByZXZpZXcuDQo+IA0KPiANCg0KSGkgQW5nZWxvR2lvYWNjaGlubywgTmljb2xhcywNCg0KU3Vy
ZSwgaXQgaXMgYWxzbyBhIGZlYXR1cmUgdGFzayB0byBhZGQgdGhlIE9QUCB0YWJsZS4NCg0KVGhh
bmtzDQpQZXRlcg0KDQo=
