Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29116296BD6;
	Wed,  8 Oct 2025 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759903779; cv=fail; b=MjSp09Ijl4E4hcy3OvlzInZp5jg2ln7EdXMfIC1LlLLfe5oUxDhN1XFKd6g3cJEtWtIJJUc1LZW7Af3WLMMTTJawvb4+GKU6Ivh0pVfYr5fyobQhnUTBRQqgriWxDoRbpZ69SrVrXitxYApoMaHD1bT2XUXwEsYd2Y5vhUcQxsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759903779; c=relaxed/simple;
	bh=uqAWv1+BNlAhVygDdjq1vTwl6wNwu8i3aUZfy+1RVAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BVEOwTHyOlQ00Id91a3RwjVta/hL+gzYqN+LWoYxxDB6gcPKWEXP0DAzDnRosm8jhwSJxT5ueMNBezBI/dVAHHPN05CQ2co2JWcpZIdw9IxgDUZ+eNE3d1C+MA8oWDICXGjbDT0F3csChEVm3/4LRQDtMTRrR+Vs4VW5m2oi4MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BLZRzNkZ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Vnc1Oil3; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BLZRzNkZ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Vnc1Oil3"
X-UUID: 59d317fea40d11f0b33aeb1e7f16c2b6-20251008
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uqAWv1+BNlAhVygDdjq1vTwl6wNwu8i3aUZfy+1RVAw=;
	b=BLZRzNkZSuJ6J/Rv5VA/EqONi+5UhOnc4241hFmxct13+3U/iyuNhLvL2qNjyRnSnq75FUZZSM41x6TqoXS2wsC/qCrogI5+NuKy7t2sEp0X/Vc0RBN1jo/7cb+TqpFHfrskBbtxG2B5yKne67e3/PxBB22xHZ6xxpwbVBVI3nY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:414c97a4-9257-4bc0-8f40-6ca1f1686bc8,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:e9164022-c299-443d-bb51-d77d2f000e20,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 59d317fea40d11f0b33aeb1e7f16c2b6-20251008
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2071898508; Wed, 08 Oct 2025 14:09:29 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 8 Oct 2025 14:09:27 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 8 Oct 2025 14:09:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrQov8JyXDQfkCXSQ+vH4Mhqi27WplNwGwusT8f4kUvx5djoFhI9c50we7iV81CZ5S4Nz7efNEgglvlcOp+iA0jBtg3UlNVKR4FwF4sUvzlLffBMKJfRs0N1II6CBm4l2efb5JP+FnIBHC8vdtPOUnotJVmcg04FdkmMNiMz2j/ZgGn6ExUXpY2pQTJx8R97h56daCoveZ6UyNuDtkhSmjLPwtCspHxuwwcZ9h7vnFx7S5y7yCSkMFXkPaL/l1WS8OvW24BHZ/e/2JLoMTdW0UmMrXrql9Bb4jbh4qUPmwBTchE6NfevFPqYSAqXdCfWa0EOsymFD2xU+TxJ7L8Cdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uqAWv1+BNlAhVygDdjq1vTwl6wNwu8i3aUZfy+1RVAw=;
 b=qgRwSpPkcE82sdmCYuEmDW06IVeuJKHQnTaAxkTHBCvPijabMzr2IkZHT0YcNVMAfjFjfI9fsHb/oYRAFLJ1f7ohbpcSROCOyivdl+ALs4Wb3RgMGzR7M5E06XU7kJnb+aS3yHFz34xlgXNbS1GJhSkTjDsLb0gJzLMx7rdnvWLO/W2l+wEStX4aQ8h3ltinPwsXDZVOlfgAL9Qxk3MYX1U4DNZiRbIMMwuOlsvkSe5/mrECDcVq3pSALgwj+dY7iAhVYPNWwfoRKksxgc2SnwbVYbpNAU+O8sDLdQyJ+eCo/fz8r19wcBy7iC/bB4pl0p59kULMbMKTllhFuwjVIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqAWv1+BNlAhVygDdjq1vTwl6wNwu8i3aUZfy+1RVAw=;
 b=Vnc1Oil3SFBxtBxXaEVIRSxvc95kCiRWVjMMMGww+fUklZ49gziw+4YOFJHrYgdkOQexLL6bt1R3e+by/gDMNT4DyZYI8BF+nnK/s9FEpZVbl/FOj6AILS5YBCkj/CkiY/f2ZP39znJLevADe7ZWU88Mdw/qaXEE8aj3ita11nw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB6898.apcprd03.prod.outlook.com (2603:1096:820:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 06:09:26 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Wed, 8 Oct 2025
 06:09:26 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "quic_nitirawa@quicinc.com"
	<quic_nitirawa@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Topic: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
Thread-Index: AQHcMxYfazcJy3COe0ibj/0v49XMcbSufr+AgAC4nACAAIkrAIABMksAgAVYKoCAAJs6AIAAg6AAgABkMIA=
Date: Wed, 8 Oct 2025 06:09:26 +0000
Message-ID: <beb96ec5d41ae42edf5573b34505904e05f677e6.camel@mediatek.com>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
	 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
	 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
	 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
	 <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
	 <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
	 <85bce5dc28293f48e32b64eed5591d66c54c9e69.camel@mediatek.com>
	 <2ce08f9f-af8c-4cac-8d66-97517eb18037@acm.org>
	 <8f52b5a3-6104-9659-b60b-4d57007c1efe@quicinc.com>
In-Reply-To: <8f52b5a3-6104-9659-b60b-4d57007c1efe@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB6898:EE_
x-ms-office365-filtering-correlation-id: 4a5efcfd-09ce-4eca-40b0-08de06313c1d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QmdaVWpKZnNCQTVhWFpXVndFVDlWUHd6S0tXd2VUMFJzd2pjODgweGVndnFF?=
 =?utf-8?B?eXRrL0diWVZTUXBNWSsyTUxoUGc5QzdJMU9ob0VvRXlWRnJHTWtqb1VWSnpz?=
 =?utf-8?B?VmNsd2tGSUNreHA5N1FrWDBYbUw2TWNaRmIvcTVHY2l1UVkvNkNkNFRLSVFm?=
 =?utf-8?B?MmwzMTJXNDRaeWQyZzBsUEorUjNqTHpQMkxNYWVlOFNXQkRNby93SXZZcU10?=
 =?utf-8?B?L0VxL2NBRWVJU09Ta3kwQjgzUGIzNE1SMGhqNkNPVThTbEt2K09OTmNXM0E5?=
 =?utf-8?B?ekl3Z3YyMThUVCtjcjBDdXpaN3hmSDBycmtFNWFEY2tLMTdxUmwvRDFNbi92?=
 =?utf-8?B?WWlZSkp3SStYeDlJSmRJZ3p5ZkxMeHlWVlhPekJXeTYzdFVQNjRNTjdkNTdw?=
 =?utf-8?B?ZytQRXZZZTIreW5DY1RBM1BTWldqUSt1aHV0TWxES0VhOW9vSVlIUDJZM1Zk?=
 =?utf-8?B?bjJBazMrNEM1Z25iOFlXVWFYTGVwK1JFWWZXTTBaRmozYm1zbnRvVFE2UTkw?=
 =?utf-8?B?MlNHV0xqazRPeVd3eWxLWGpaRTJTWE1vUmxlZ1dKbTBQbVBnMVo2Mi9LYUpE?=
 =?utf-8?B?cjNMbEJSQ1lLMVVvYlB6dnJnSEl0UjhOUzczK2RBcmhMS3dnWUZRK3RmaVg4?=
 =?utf-8?B?bjFFNEFTekNnamRLVlRDMmxtbHVSUnFnVmlpaUM4Ykp2am0yeVpObnpsT3B5?=
 =?utf-8?B?S05manFoMFA1Y0IzQzA2SU1xd3BSekhjNG9SaE1YUTZ2bmZscWNMeDZiZzFQ?=
 =?utf-8?B?Wnk1NnVpWGRMWTQxc2tFaXVJWUVIWWM2OHBqRGxSb2FMazI3RXlvM2lYOVgx?=
 =?utf-8?B?QmNRYnJGRnd5UlBYR0tkdWNYQXJJQVN2eW5pdmdaVFdLb015REF3SmxFNGJV?=
 =?utf-8?B?a0VLSWNuYzBXMGFJTVUrSEE0c2NRbVI3L1lMMnEzdnp3U3pZN3MwZGVZbmdM?=
 =?utf-8?B?d0pod1ViKyt3MnptZml5dDBzQ0xUTktOUUx3azRMaVl1U1RnM0tHdnVxSElF?=
 =?utf-8?B?VWRsTndNZ3hwSFErK2U0c3h6UkkzMzJ1aXozdWRFZ0V1N3lzbmxGNjNBOVlz?=
 =?utf-8?B?TlI1Q2JHZTlHMGh2cUtzemVtWnI3Q3dmOTdzVmFpRXliV2grTlI2ZW5lVGJ6?=
 =?utf-8?B?VEpDU1pBSFhhck1tVEVoamg5eWZOVWNteWQ1WG9EVlRMRitiTmZ6WDZIUTBl?=
 =?utf-8?B?WitIdElhSXFPWjBMTHRBc2lWeVJtWlhjWVRZMGMvaDRlcXdXelF1YWtGQzhN?=
 =?utf-8?B?KzJqcE1FRUIyTVpIaDlqSW5xazV3QVBpY1U5c1JacFVWbVBtVFE5bmpoekd6?=
 =?utf-8?B?VGxMRUlCVWNkUmNFbkdvY2RXcnpXZDRKSXEzWUNVUC9vRzZkaXFnc3psbHk1?=
 =?utf-8?B?RHU0QU1yQWRoNUQ2OXp0L1BlUEZvR2NMdDRZK2ZZVE9jZTh5eEFPNFBtR1Ro?=
 =?utf-8?B?NXAvNWI2cHFlNUpvcDZhZUVPVWxxVVJzYS9TcjhUMkRac1ljUmJWL3NNSHdh?=
 =?utf-8?B?ODN5cGxUM2NvbVdJdE9aTmdkVEZBN3ZseEN2ZWRYeklLdmU5Rm8wUVg2WmJl?=
 =?utf-8?B?RzlXRXBLYlR6clY2RTl4S2ZHTVd6MVNNZzNRSCthY01lbFpVbXMwUi9pYWoz?=
 =?utf-8?B?bktxOFdDOGliS21sWWtsZHNHZ0tHNGVtNG1FS0JNOVIremZuMlQ3dU9nNkdU?=
 =?utf-8?B?MUVoendSbS9wU2RNd29rY0o0eWswMmVxdUwwL1FMb2J0cXloZDZwbzYrNHUx?=
 =?utf-8?B?Qmo2a1F6anMvMGZSeVU5czh4bTl2RloxSmZHY0lCN1JhdEJveWo3dk0rYnJy?=
 =?utf-8?B?L3RyQUMvQUxvNG1Dd0o0Z1NKeEZzbGVrT1N1ZHJaWW9pWlJsSlp3eW1CRDZl?=
 =?utf-8?B?aXhQRzhXVmN1TFlzM1dUSEdNUDA2OERMNmdrK1FWcjZ4RXQ0d0J2bWdHMVdo?=
 =?utf-8?B?dGl6ZFJVQXkzbTZrZWxFS1V5SmhtYkQ4azI4QXJLOU4rWHJTRHYzVFphVE9s?=
 =?utf-8?B?NEJ3R1lIeVE1NWM1VnN2UFNTSnNuektZcmttWDdRSTlDNWFPNFdGSkVxTDVN?=
 =?utf-8?Q?4GPPEv?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkdZZ0dEY2ZwUVlmSW5IWXNQczJIeEw0Sm51ejZZZmZSaGk4U1NHd203SmVa?=
 =?utf-8?B?eE40YUp1Uk5UaEF6UVZOMGNnTkJrV2VZenA0SU1ucFMzUlVWbEhaL2kyV2xN?=
 =?utf-8?B?eVoxbmhYQzlqTVgrWmhqb1d4TlVEdE9ZYXVibjEzL1ZleWhqUEVPS3FOREIy?=
 =?utf-8?B?Q1Q2bGpwMjVVVGNNai8vS1VwcGk0N3A4NGtUcTNCVGJndGVRcXBlODZUWmtF?=
 =?utf-8?B?NDZyK1pOMzdVMXl1MTFXMEJzVEVjZ2IvdURkaHE0Z1I1Q01nOTMwMEJzbTQy?=
 =?utf-8?B?TjgxdVpzMU81UVYwc05WQlUwZXVweE9TeXk1ZHgxNStkRzhDY3VkS1pqeWdp?=
 =?utf-8?B?VWk5VWRHTHR0MXNvdUVQOUJCcGplbFFQY29Da2dkdzBjV3JFSjFYSmNYY0NX?=
 =?utf-8?B?NWlHNDQrYWZVRmR0UUhYMFcybHF6VkdMMWl6K1V6dkxLWTVDbS9tVG9JZTBL?=
 =?utf-8?B?U0Uvckk3WklveFMrNGUvTVlpOUdza0xRTDhKNTBGWUxpd0FnMkpzK0F5Ym5r?=
 =?utf-8?B?WHlOYUVDajVsOSs1dUZnUjg5SjYyak5JUkh0MURxU2RMbFBkVjhqQzlLaEdz?=
 =?utf-8?B?cmRpMlpNWEJ5NVgwVXRiRlVSY0ZQODc4bElKTmtRZVE4NE0rZ0NrQUVlOTMw?=
 =?utf-8?B?dEQxdks0b0xwc1lnNGExSnA4NUFwR2o3Sm5WZEVuem9iblVzY2M4NkcyWHZ1?=
 =?utf-8?B?YjZlL3ErcFN0RWY0SE4vMEk1eXMwZlc3RmdJbXZKOFlaWk9xSW1mWTVod2FL?=
 =?utf-8?B?Qko4TVJRWjlYT0RRcVpDMlBqbkRPVHlQT0NwclNsV0hsVWwybkRHVWtVZDJ3?=
 =?utf-8?B?Vkt6M25iU3NIbWNYS01KeTZ2bDJ3Uzc3dllQTmR5aFRTcmdORllQUUI0RVBL?=
 =?utf-8?B?QkxoNHk3WHlvZkRSUzhvalZWNjJpdUZ6WjVSTU4yNFlETHdmUitLdDJpS0pt?=
 =?utf-8?B?ZDFjUVA5TVVCK29PWTB0NnphYk4wNDNDaVk2RXlyTVZoSEZVZWl1ZS9VZlM4?=
 =?utf-8?B?d01vbkY2bWlMU05jYUNadldINWF3S05GbUk2Q1U3eEtlZEJ6QVpvQlcvZGl2?=
 =?utf-8?B?RHoweVJSVVQ2aUdOS0phamhpTk9SNWxTYmU1ZlpkRG8yTFB2R3F1S2ExSmlo?=
 =?utf-8?B?RXRwblR2SndtZVpzZ1FaMHBPQnlsWHpjRjV6NnVOUTZUNTZwY09FOGxNOHlx?=
 =?utf-8?B?QktTSmplVlNyOTJ5emV1a3QwWmNYMExlQXdkVkpMYitjaExIZm02aGd3KzQz?=
 =?utf-8?B?TnpaQTNYZDBVVjMxNmlGYXhKei9WdTNHRktIVW51TlEyd3A3NFhKZ2l4b0JR?=
 =?utf-8?B?TFpSbzRIdTRETVRxMjdIVXpZRDBkcHJvOVRNTTBHTjZSS042VFhkY3h3RnF1?=
 =?utf-8?B?V0F2cEUwRHZoVS96K3dKdXZMWVpmZW41ZXllcStJbnpYTzJuRVREd1V2RkpR?=
 =?utf-8?B?c2dHc1ZHOTZCK2dxYXFaRUFSaTR0cW9WN1NuQUllRDcvb1prVTg0Nk1VUTB4?=
 =?utf-8?B?d0hKS09sdmxScWdMUUw2dHZDMmkxQ3J1K2IvZnJxVWNjSmhhdkpxNjJkWnRN?=
 =?utf-8?B?V3NyS2k5ODhEbWFSbVJpTGg3bWtrYnVmYjhFQjFFYVFQUDhqZlJoQWRXV1h1?=
 =?utf-8?B?ajhUUGxFbDEyMnZ1SFR6SDhXQzNUN1NaY2xjWjNCcnpBamowQ2pENmxMSUJr?=
 =?utf-8?B?OXBYbzF2ZVpDN0NoY1dMNm41NStDT2VHdVVmbURLZDZ6QktrYzlHZytSbWVq?=
 =?utf-8?B?b0xKR2E4VmpQN0JzaFNtWk51ZWoyZkEyU2w2NUVQKzJLOWZjOEZzc0lrZ2pQ?=
 =?utf-8?B?aW13KzNQQVVkVlVEblhyQXJ0cHNuQXRqRVJoeHE5OG1sUTRsS0xSbnQxOHRY?=
 =?utf-8?B?U3VmS0I1b0F5SVVMd0xsTE02U0QwUkZlT0xwYUxqUkR0R09JZDBvQ3d1ZmZU?=
 =?utf-8?B?UGN3TGhTNjZyVmVsL1RXS2tYUWRUUjhEQkl1eDhJMVRoeENHdElBaGo3Vk1v?=
 =?utf-8?B?cUZIVnhPYzVRWkFMK3gyb2xHdmk4SnlYTHQ2YVJzeDJ6SkRJS0FYR1orSWRP?=
 =?utf-8?B?OWJYOXZySHk3bi9CREFFSnQzZUF3MnNZVEpLMGxQQWMwakIrWWFkNlQ4cjFp?=
 =?utf-8?B?V3VYbXNRVlpNWDFSUVd6dERYWFNBZWV2YkVCVk8reG4vYWFhaXdpaEFEWng2?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86F4850D5D6D1444A3BD0514B317C4E4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5efcfd-09ce-4eca-40b0-08de06313c1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 06:09:26.4692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p7LI2feiK7j5YnlkO76LaUP5ePTEt5SmOHQRs46qH8KR+YH/yyfC4vZz5SPn0Of4KfsXAxop+Fh9bgbpbFju/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB6898

T24gVHVlLCAyMDI1LTEwLTA3IGF0IDE3OjEwIC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiBJIGFtIGFsc28gbm90IHN1cmUgaWYgaXQgaXMgd29ydGggYWRkaW5nIGNvbXBsZXhpdHkgdG8g
dGhlIGRyaXZlcg0KPiB1c2luZw0KPiBhIGtlcm5lbCBwYXJhbWV0ZXIgZm9yIHRoaXMgcGFydGlj
dWxhciBjYXNlLg0KPiBJIGNhbiB0cnkgQmFydCdzIHN1Z2dlc3Rpb24gdG8gb3ZlcnJpZGUgdGhl
IGRlZmF1bHQgdmFsdWUgd2l0aCB0aGUNCj4gcGxhdGZvcm0gZHJpdmVyIGluaXQsIG9yIGRyb3Ag
dGhlIGNoYW5nZSB0cnlpbmcgdG8gcmVkdWNlIHRoZSBzbGVlcA0KPiB0aW1lDQo+IGZyb20gNW1z
IHRvIDJtcy4NCj4gDQo+IFRoYW5rcywgQmFvDQoNCkJhcnTigJlzIHN1Z2dlc3Rpb24gaXMgcHJl
ZmVyYWJsZSBmcm9tIG15IHBlcnNwZWN0aXZlLg0KDQpUaGFua3MNClBldGVyDQo=
