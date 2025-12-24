Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A334329B204;
	Wed, 24 Dec 2025 06:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766556796; cv=fail; b=B7tMJjWJszIH019XCyponj4W8Ujhj28jX7SwYMr09g7sv4ZC6quYuqMJFM2wqLRagbVLbbvpu4QOG8F6F+UJ80e8TKNWXkLnBxnDwA0+OT7xwB9LHOVXDJhUb90E3dgcqlUq97mvUHgPuDr2sJJ5U6yUrLtkfvX1L81ntILV5oI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766556796; c=relaxed/simple;
	bh=qz3JHwATEF9nK8aW/4KWRJ/Ghh5AasbSn1Wrl2jXdhg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sVoMn/7wjK8sE42z2pfI/BWu6VvKA6MRLo1UB1mK9oDZExG/KzPXuSumuRCSlIetGlGtUH4z/VO3Uqx9UEX2O2ytWphab6ySOL2iC899MK9IBy0Yn5qzWMD8pwJZqhrFCj++V7e6flxBzBAxJFEitjZtd9cLnmZblvx9lkiN7Cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ur4Iribh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=r01lWtx0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ur4Iribh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="r01lWtx0"
X-UUID: 9e9aad2ae08f11f08a742f2735aaa5e5-20251224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=qz3JHwATEF9nK8aW/4KWRJ/Ghh5AasbSn1Wrl2jXdhg=;
	b=ur4Iribh9Nx9/12P2YrjLkLSQl+jiPMKkBzb7S8BQx+geDWzoeRv6N2CriL2J8x1LzL3TOsrotClumRpJk1lsmfohs6GNDMzPeS0S5pejeX059qaxr9N+921F2xvUXS7FDNVaVhDsK35gSMiFR8LhtDTwL07BQFDgNQMN9XNe50=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:184dce68-a03b-42ac-92c4-a0bc3b9ed1f9,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:a4bbdd28-e3a2-4f78-a442-8c73c4eb9e9d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9e9aad2ae08f11f08a742f2735aaa5e5-20251224
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 484649082; Wed, 24 Dec 2025 14:13:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 24 Dec 2025 14:13:08 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 24 Dec 2025 14:13:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OI1FU9cUPdYnCxPeib72vOQl3E+Y/af02wl0gWi3B5CyYELglFMOySYkHT/ILYcoMuKNd4ffgDh93m+lQC/yGgVrTUAo+mDhDQ8hn7tT7gwVrjBi2A1wDJb9hoMO3nzqU6gptiXWQWO9HRQw24ZZ40HFE5W/Ikbg8iYkx+qr86jYcngRhB2qpBnhSQVKQSSb+uSCe4y7HL1fOpJKzADL2xwJllMz8A+rr/7nm0Uy42GzzKwa1ZteYPNISm2/sHqk6oUPbVxUOwP2MM1O54denAMhC735+g/vtyQ/gOs4ikHubYNN2zZxI7lHU8IfTmLuotJ2comUI+kVnmym5xXH+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qz3JHwATEF9nK8aW/4KWRJ/Ghh5AasbSn1Wrl2jXdhg=;
 b=lv7vWzHgCYB9fyvDeGZYco1LWwxLHPdxjqI3OQDfPXy4TG8uhSePbUSsAA2AhzOJmRDN+SSxJH2fa1ZVmxq20qq4RJfFhZsGatuCkd5bsvldLtLymako4/UWvaagUsmxgTNdcORKCQwz5OxTRSfRxBLHKuToh5g+7EuIgt4GNuRqQKOlCEodKaUo2cByQnby3ewe+zCwO1C2ufzarLGXenAWsYt2Y9iieGJupdk3b4f7w46PHCjVMgGSnU+HsrGbEjLEtNUJ5FzlpkGdJIs8WfqfLQZjRR8h/651RTlioTHx9MW0XuYosvsRg654m2rVwQuLHtCkSJQAijVJqbO5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz3JHwATEF9nK8aW/4KWRJ/Ghh5AasbSn1Wrl2jXdhg=;
 b=r01lWtx0U6bZL15VBWebttk8pBWHVb+BFYmYGZ3yrAVxwhwr5Mxq142A22D4hCgkuIDkMzLtkn76mT8T/7mnP7l4N8bg1pyeC4d+Uc6vO9R8ABk3oqRQshABTovqW97K9SFwAPZtuRWwJyaN6KUSrKw3peOJREwsgXc7CDFOg3A=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6695.apcprd03.prod.outlook.com (2603:1096:400:1f1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Wed, 24 Dec
 2025 06:13:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9434.009; Wed, 24 Dec 2025
 06:13:05 +0000
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
Subject: Re: [PATCH v4 07/25] scsi: ufs: mediatek: Rework 0.9V regulator
Thread-Topic: [PATCH v4 07/25] scsi: ufs: mediatek: Rework 0.9V regulator
Thread-Index: AQHccB37rimOvLbVPUGO2UUSvncJrrUu/sOAgABvM4CAAOqJgA==
Date: Wed, 24 Dec 2025 06:13:05 +0000
Message-ID: <2eec4b3c0fff4869c599558a7e851d052eb60e0e.camel@mediatek.com>
References: <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
	 <20251218-mt8196-ufs-v4-7-ddec7a369dd2@collabora.com>
	 <8206d9e715f7ef987b5369d0bda68cce13528112.camel@mediatek.com>
	 <14003986.uLZWGnKmhe@workhorse>
In-Reply-To: <14003986.uLZWGnKmhe@workhorse>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6695:EE_
x-ms-office365-filtering-correlation-id: 0dac1cf0-0074-4e75-2b76-08de42b380a1
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YzBzamRyVjhkVXBEaGI2YjBLZTdkdmNsanJKL29NVTJGV00vVWkwSk1tOVNW?=
 =?utf-8?B?dlAxQUxFK0FpTER0ajhRcVo2Q2h6V2kvRXlEWm8waXZlbHhXenYwTFZKTTQ1?=
 =?utf-8?B?cU0rb1pqZUZENGFvKy9INm5UaENEdTJyNnpHR3FyRWJtdk1mandvUEtTVHNO?=
 =?utf-8?B?N2V2RnNTcHl6WU9wSW16UlJjZkw2VldMNENGZUhYQkhEY25Pd2JQSTZWOWpY?=
 =?utf-8?B?K2lKSy9IeDdNV2NFVEFQcWU4V0R0cHdvTEdMdHp3NFN2VGFOeVNnMXdacERQ?=
 =?utf-8?B?RFk5VDdDaXdnQmNqZTA4MGdpZjk1RVJyVURUSmM3L0xNODQ4WXcvRlNPcGlL?=
 =?utf-8?B?RzNieEFwSmwwWkpHbk91NExVWUJtTXc5WmszdUdaY3BRUGVRa200T3hXbEIx?=
 =?utf-8?B?REhPc2tzSW9LK0VkTmhBVTZ6TFBnZHZqSmZNQkwvaXJQZ3JXcHZUNWl3SE1r?=
 =?utf-8?B?VEJDaXhyQlVidEY3MjlBbDlQWTlsa3YyY0E4RFhFWUJJcVd4YXJBbHpjZDUr?=
 =?utf-8?B?MC8vaHhGRHgyZlVKejVZcEZIVmUxOTEycmRSRHhxK09yakpreXRiY0duOXM2?=
 =?utf-8?B?NzE1bkZ1T3lWTFRaMHh5dkEzRDhQbmpISjJpSXlxb0xMRHRUN1dma0E1QnJ2?=
 =?utf-8?B?RDAxd296SUJwcEIzZDFjbUZ4QVEvaytCN2JTSWoxZzI2dXcramJhWlROQ1M1?=
 =?utf-8?B?VEFVaXF2SVRwa0hjTGlUa1JSTEoyQm5rS203MiswQ2xIcWhRemExbVV3S3Fq?=
 =?utf-8?B?TDJBY2JYWWRwcjJRSkNTQUxqSjdWMVRaWnJJREFEQVZEUXliSno3eXp2dTBT?=
 =?utf-8?B?K21oZUVOZkNBekpOVkFsbElGbGRFL3FaeU56R0g1MDBGWFdnWnNna3FKM1RG?=
 =?utf-8?B?OGNTYkZITGZMYTJ2ZDZhdmZhSVg2RlVMQXprQW5WSHZJSGlOUCsrdmh6MU8w?=
 =?utf-8?B?QUM5aklVVmlUWGpqNHhSWnRlVnZYOGJKT2RBRkZmcDgzODVhTVFNbmpqcmt1?=
 =?utf-8?B?clA0NHFRKzhPZW9Ib0x3TUFUdGo1UEhMZWJpODFpemJmeGxMVjlxaUpScWUr?=
 =?utf-8?B?b3FMaFJhb2s0WGp1RXlITjMvNlhSZkNvdnJoMUY5b0tqQXpjOWNHK1hSYmo0?=
 =?utf-8?B?Mjlnb1l1TUxOMUNhcWZiNFRPOWFHZHdjaks5bHBONGFUMkJ3N3JjM2dTQkpH?=
 =?utf-8?B?Z3d2a3EwQ2NuSW5XVXBCTlJ1TUVSQUthVUt1YS90QnBsZ1lNYmRPUG4wKytY?=
 =?utf-8?B?L2xPL012Qm12eWV2WERvZk8rL0hOOUIrZUp2TlZNN1RpMnUwT05rcUQwOTRX?=
 =?utf-8?B?YThXLzRWMkFxN3R3dFdsUndBR3N0czNxOW9YMTBaKzV6azRqbXQyU3k2WXpz?=
 =?utf-8?B?eTNiNVhkeTlZU3JyZ0pTaUVlb1JPS2RnRC9xOXJraEc1YVIwTlpEdGswUjhy?=
 =?utf-8?B?akV1dlk5TlcvSDlHbEFVdE14bGR3RmJIYmN3UGREZmJsQXplZjdwV0xnVldR?=
 =?utf-8?B?dlI3ejdnVmRrd2NvUjZDVjJKK3IwOCs3eUtUTHNLVXplNkJVQmwwbTdseTJo?=
 =?utf-8?B?R0pKckF1VEN2aWErajEra3NrSERJdzN6dVpBMHpsN3QyK0ZxSFd3ODFkdlRV?=
 =?utf-8?B?MFZxRFVmVEhGVDM1T3pXMnhsUlNCK09KaFNaWDNoMUFQNDB4Q0JUYlhlNEpJ?=
 =?utf-8?B?Z0RGZ01SOEZzSmdYUHU5Rk12Ty9DTkd5TFJBMUNpNFVGdE5pSWl3ckJVVjV3?=
 =?utf-8?B?QzI4aERZbGRJSzhnTG5mZ2x5bFRrMXBuYWZjeWJnYVliLy9ZOTE1RFYxSThx?=
 =?utf-8?B?aDBWVGRFc3YzbFduVldJZGVac1dSN3hlUDZ3ZTd6YXd4c2cwaHVrdmpOQ1Zq?=
 =?utf-8?B?K3VKYTBkeEhhMk1QRTVhekFrQ1BObGV6R21zbW44amlsQ0d5bDdERGRkWURO?=
 =?utf-8?B?bTNjVnlMRHNzTTdXRU5kRG1WTUVvQlBMTXZDcHlHZzZleUkrZ0h4V1k3TzdC?=
 =?utf-8?B?SnVWODdpZUNIeHV6R3d2ZkpLVlgwbGtqQ2pVOHZYbkpIQk4rU0xOSkFBSjdL?=
 =?utf-8?B?b0I4cHhXbEFBeUZwM3lNRkhxOHpLdEZaUHhsUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXdwbloxa1lLY3hvZ0ZmaU92c2VPaE1ObDFCWlJ3emU0TzlQbXZUeVN5MTFa?=
 =?utf-8?B?QUI1bzVOYlRRNG4vNXJvQmc2WW9hR01QS094amlJajJPTWxFR2RIeXhnRHdv?=
 =?utf-8?B?djV0MGpqWXQrUjQyZm84TXI4bDlJUkQ5YWRuYmpuREVNTDRYTjllT25GRXRz?=
 =?utf-8?B?SkNlaEZGSkdlSGVvTW1yeDB6elF1MUJtckpOVmVxUWdDLzhzMUQycjlPWEl2?=
 =?utf-8?B?NStiMGNlTXNRZ2NGa280Uy9HZHhLdGdGdGpkWElKUzlIaC9KKzZPZndkVmtZ?=
 =?utf-8?B?ZHJrSjBJamRVdFRpL1dIbVZTZWFuNFVBandyeWpDR0N2SlR1bWc4Si9wMEpE?=
 =?utf-8?B?NWFUMjJQVDdQV0hwS1cvbVk2dkR4aWZGYmx2ZFpBNEJrd2hhUnRPQi8wdE5h?=
 =?utf-8?B?Z1dBZitqVEdFbk5xdEpNdi9zQUVzZnRsNXhYUmV0c1FjZmV6TUp6OVpjYmwr?=
 =?utf-8?B?QXNDR2puL3dMamNOaEcwd1VnUHkwTXlIcUlVQndwUHFlWS9TSm9tTW1JcEhN?=
 =?utf-8?B?OTRWZ05xRHVNQXdVLzd6eTNZcnlFZ052R1ZNSllhcVFzSjFJdVV2ZE5YUE1M?=
 =?utf-8?B?RXU5Y1htTTNLLzkweWlRZjc1T1lDb1Z0dEhUbnRKaTZGZTFPaDVpSU1OeDNP?=
 =?utf-8?B?OG16Tisxc0cySUhkTmNoNmdZRTd5RVc2WXpxUzNkZXpaUi9HclcvSVgwVTRF?=
 =?utf-8?B?a09kc1JwK3M3MCt6akNZaDdXNXg1VC93QzBDcEdYenhncFV4ZE9LN3NpTHE1?=
 =?utf-8?B?RGM0RS9VYzM0SkJ5b3V6eDdTRnU3U3FiNjhPODRUeTdVdC9IK3F4L0ZvYmJW?=
 =?utf-8?B?bXBJcUdZZnpuRzYvRmxFNmNvUXVQdlBndHRzNlBWMXpXdlpVUGZtOWJFQ25h?=
 =?utf-8?B?UWJmSjQ5a1Z0eStRWlhsd2JrYzF1blRCOC9NZ0lRK2xRWGc0RXcyTU5hZDNW?=
 =?utf-8?B?U2xLSC9sZEU4Ym9UT0tjcXZjRmdLVzNoZ0JDdUpUSkJPcDNUdkxLRTkzd2xn?=
 =?utf-8?B?ODFWSWg5a3lEakd0U2tYZXdZdGMyd2JLMUpNZnMzdXQzVG9LQTNMRXJpWjVV?=
 =?utf-8?B?NUE3UTZ4b0ZTcmJNMVZ1T3VnTVRNUDNlUitPUDAzNGUwSG5pZ0NCUWxyMWVL?=
 =?utf-8?B?OElrUi9mbjRuSWhXK0t5S0paT2FyRWpUeDdyTFJJQ3llNjBiRU84STVlWldm?=
 =?utf-8?B?UjIwQm00L2hZYXdHVVZxNE9WSHNsUTd2Y3FvZXBZcVZCN2E0M2VTU3ltdW11?=
 =?utf-8?B?OVJxZVJzUTRnOEZjVUQzOGMwVUlBWlBtQnpXZ0FnTHhVV0hEOXFqUURITnkr?=
 =?utf-8?B?ZDFORU5VUExueXFJM1ZOckQxOTBiOFR5Uk5IWmZJLzZYMUtPdkoxREpOcTNa?=
 =?utf-8?B?ano3UDZabkhMSWE3V0R3bHZXbDJMbENuMXpCcFBpWDZ0SmE1RE9HbUt3ME5U?=
 =?utf-8?B?cmJ6WTgwZmE4azNEaEUyOWRBNHp6UThudnRLQlR4Q292bmtZaVU4NnBaSWU2?=
 =?utf-8?B?ZjhNZmwyeC9acnVlcmw0TndDRzBhMG4xaVp6SUpOczc1RSs0SGlaL3ZOeEJI?=
 =?utf-8?B?dlZURlExdUE1bHozbHJLS1hwNUVudGpmaUM1MC83Q1VucWJ3L3A3V3BkSUh3?=
 =?utf-8?B?eG9UM3FPN25jdU45aWdLaUNwWHR0ZkxZUVNScXkwUTJMUGxaMGlLa0ZoRXhh?=
 =?utf-8?B?OURHN1d5d3U3ZjdZek55RXh4S0ZTZU5ZdXVnUncrRjMxaHVkdGEzWmlJU3cz?=
 =?utf-8?B?WHBBeDh6WFIycWhjYlRsOU9XWkM4M09BdHhSa3ZySEEvK0RYV0tOTkc4a243?=
 =?utf-8?B?OUR3WThmeE5JNUdaMHVSWjZLTDI4NkQ4MHpRWGpuMXV0cnh2MkV1UkpibVZi?=
 =?utf-8?B?TVR2TnhpRHZVNWtENXJJZ1VDTm1lOG16VlFjUFZnUlBoSHRqbUk4VFZ0akZv?=
 =?utf-8?B?YzNiNlZmWWhRS05xa0Q1Qm1UeG12WG9EY252REMwaFhPaG0vQ2NvRStRU1Rh?=
 =?utf-8?B?amF2UWVmMUhCcnE2MktmYXVrdXdoM0N0ZmNMZlgxcm9BZEQxcFMzNjdmbHJJ?=
 =?utf-8?B?U0diSTlrcWRxS3hPUkhzcXlTZHhmK0xYZnNJeTlKWnYvSE9BWmRJN2Ewek5L?=
 =?utf-8?B?SFNNK2FGczladXY1R0FJSXd3aHp4U2Yzb01wRDJNWXg4VFhTZFpsVmliekZE?=
 =?utf-8?B?QnNTazZSazdlUDZCOHZFMVd0bjNZemxyYmtMSEViUjc0a3pxOHFhRVZGTWFL?=
 =?utf-8?B?OUNvdzV0ellIM3lCR25NTUlWOHJCbk9KM1d1S2FMclJHTUVIZE4vdENrWnR1?=
 =?utf-8?B?ekVuaWNwdlFiWmhPeTdCKzEzSUVmU2gvNGtGYWlDRzRUam8yMkV0MklqLzBa?=
 =?utf-8?Q?+61WmVj5KMYYB83I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FF8C7BA6EFB4D4FB4BF8AE6E394875E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dac1cf0-0074-4e75-2b76-08de42b380a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2025 06:13:05.7681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bEkn1dgkt/k6/XKfDoeJZ2tdZe5CXsTVFRGRi4fjlrOycmsleXegCY+hUYVrmK1BONb+QUfIiVq1+iOZWBEwDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6695

T24gVHVlLCAyMDI1LTEyLTIzIGF0IDE3OjEzICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IA0KPiANCj4gSGksDQo+IA0KPiB0aGF0IHdvdWxkIGFsbG93IGNvbXBhdGlibGVzIHRo
YXQgYXJlIG5vdCBhbGxvd2VkIHRvIGhhdmUgYW4gYXZkZDA5DQo+IHJlZ3VsYXRvciBieSB0aGUg
YmluZGluZyAoYmVjYXVzZSB0aGUgU29DIGRvZXNuJ3QgaGF2ZSB0aGF0IHBpbikgdG8NCj4gaGF2
ZSBvbmUgc3BlY2lmaWVkIGluIHRoZSBkZXZpY2UgdHJlZSBnZXQgcGlja2VkIHVwLiBUaGlzIHdv
dWxkIHRoZW4NCj4gY2F1c2UgdGhvc2UgZGV2aWNlcyB3aXRoIHN1Y2ggYSBkZXZpY2UgdHJlZSB0
byBlbnRlcg0KPiB1ZnNfbXRrX3ZhMDlfcHdyX2N0cmwoKSwgd2hpY2ggaXMgbm90IHdoYXQgd2Ug
d2FudC4gV2hpbGUgd2UgY291bGQNCj4gYmxhbWUgdGhpcyBvbiB0aGUgRFQgYmVpbmcgd3Jvbmcg
aW4gdGhhdCBjYXNlLCBJIHRoaW5rIGl0J3MgYmV0dGVyDQo+IGlmIHdlIGF2b2lkIHN1Y2ggYSBz
aXR1YXRpb24gZW50aXJlbHkuDQo+IA0KPiBLaW5kIHJlZ2FyZHMsDQo+IE5pY29sYXMgRnJhdHRh
cm9saQ0KPiANCj4gDQoNCkhpIE5pY29sYXMsDQoNCk9rYXksIHRoaXMgZG9lcyBoZWxwIGF2b2lk
IGlzc3VlcyBjYXVzZWQgYnkgaW5jb3JyZWN0IERUUyANCnNldHRpbmdzLiBBbHRob3VnaCBpdCBp
bmNyZWFzZXMgdGhlIGNvbXBsZXhpdHkgb2YgdGhlIGNvZGUsIA0KaXQgcHJvdmlkZXMgYSBtaXN0
YWtlIHByb29maW5nLg0KVGhhbmtzLg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIu
d2FuZ0BtZWRpYXRlay5jb20+DQo=
