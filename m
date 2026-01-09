Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453FB352931;
	Fri,  9 Jan 2026 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767950208; cv=fail; b=gNbBJr/CM0OuHO13j8sqCHnkkI0kKvWuiWG77nAMIiRvWd5JhLGf3fyD6DrxrOi7Jl9/RkbKdDHBYwuAMq9SbkRrObrePIr+puwGnDtmwPjaCdHP9mXzudl1ci9Wa8WMgntHRKb1sh0GuJELyyt8TsBThAY4d8JPfngxKvMpKWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767950208; c=relaxed/simple;
	bh=eDvBZIfJwICBQNCczPlUI2rGgQxQwk1qpGP+xYMddy8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pwmdnvBRihDCNtXWDs4d7y2DS71TCHXwejVffV4vuXaCbnclvO+gvQ5BriewVZr4LvV1bAMjJpnZUoaSnF24NPT12tX2Z/jXR8t/csNZZn2KXcNz+toPqDfZWpTrMRo6UyeGuRkt35C3EsIBaXJNdaX0VCVDpj0t5mSZIA6wEBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BJEOvn25; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CPHry7XW; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BJEOvn25";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CPHry7XW"
X-UUID: e721d092ed3b11f0bb3cf39eaa2364eb-20260109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=eDvBZIfJwICBQNCczPlUI2rGgQxQwk1qpGP+xYMddy8=;
	b=BJEOvn259T0YHG8s5pWkokXG1he2b+QeJFdN5HYBzm6JIzTDTM84k8GuKqQOPUzQL2Kdac3+PDXbNOxLbpynr+PXvaS1PXa2p2qVJFbKB7Qa95INAcpgzvOmCoXQjEwkFCBpnQ+lvtPW+9+ozv1/13NabmQxTmJ+tuGiqkD0It0=;
X-CID-CACHE: Type:Local,Time:202601091638+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.9,REQID:2f49fc72-8353-4688-ab76-39829dc44b8b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:5047765,CLOUDID:c62052e8-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e721d092ed3b11f0bb3cf39eaa2364eb-20260109
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2002163733; Fri, 09 Jan 2026 17:16:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 17:16:37 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 17:16:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mjUwX2gNvSTnxOMcb0rx1nO1q5z+oF9b80EqDy4XJZp9V6xN/r8xMOmanVxwfNrSm9+SgAUni4SslPv1PNyTCR11mhDSfzvsdDMWOCHzhwz+CyDPGm5bm3XNrsutK57hJn+BXtr3uMOZZxUDzxhVXnT+TY2r0g3fp4YO+QayozuDDwX+yXt6nvI6z4cH8pKN+BFTQ5FpsAcI9YAnRUNwNyPYRBre4a3ZknL0CUdKCeox6Tf+q7bl5pcLOepokF/47AgHwz8YwQXKZznlqrxJL3oZvJcFDKZ+jGDsJWMkDkhEQG002nvWc4FMJcm4Ne7UP+oyxxZsIiWcxZMyddp0fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDvBZIfJwICBQNCczPlUI2rGgQxQwk1qpGP+xYMddy8=;
 b=L41bYod1xXbuNJHehQjXyd8BXBlkR9ECRndJ/rqK//Yj90NBA8CIa1y65xkU2Cv5CUsVeX70LiBxZzJEjT+W1scJrUQjacYVBoT8m5mMfS5I9ZTg75+XmXKAsuAL44xecxfykuA82vvA681/A659OH812TNwQb3natJ5+t8sfqqiRKLsUSRsVsec+37QGMPSGSIZ+/ny0ZJU1qimE47RH0ZuSL9OxwvfMWWas09srGjSeOBQpIlbrKSFEwKZ9l+b31yP7NNkMNXoeXFDyHgZH8w0fSvmwksBCSDpomYUDG/jE/US5uGpk0KyNFrbumDNq62BK3iVO0mMMLw6F/Ufqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDvBZIfJwICBQNCczPlUI2rGgQxQwk1qpGP+xYMddy8=;
 b=CPHry7XWvO4jWZmXPaSIEdJOzBDILggjpnaZ7vdCEFlXcAZq75BnuS2sXtbXxxzDEmpKoLZC1AYCQwYLu23gYDe53GR7ZHC22cIK3CLROu9tiz+V0C+ljoZEEyGw/u6emPjJ/MLIfm4F3JVBAjD8JhszvOvcpSkDC1T5Z/Tif88=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE2PPF7BA6A63F0.apcprd03.prod.outlook.com (2603:1096:108:1::49d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Fri, 9 Jan
 2026 09:16:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 09:16:33 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, "kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "conor+dt@kernel.org" <conor+dt@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "krzk@kernel.org"
	<krzk@kernel.org>, "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
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
Subject: Re: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v5 11/24] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHcgIzex50QwHB34kulYV8QY4/tvrVIMsMAgAEs4YCAABE5gIAAFKGAgAABlYCAAAkegA==
Date: Fri, 9 Jan 2026 09:16:33 +0000
Message-ID: <46cb450f92887ceba07614dc85ed495f6af7f602.camel@mediatek.com>
References: <20260108-mt8196-ufs-v5-0-49215157ec41@collabora.com>
	 <20260108-mt8196-ufs-v5-11-49215157ec41@collabora.com>
	 <81ed17eb-2170-4e97-b56d-488b5335ff5c@kernel.org>
	 <dd2eba99adaddf7517f06acf7805d32e261fafa4.camel@mediatek.com>
	 <87887adf-2c94-48c2-8f83-4e772ab50f60@kernel.org>
	 <e9a6da3998195b9dbda5abd26bc6dd5d3aca07ff.camel@mediatek.com>
	 <66ca211a-c909-4d0c-a22c-9cbd3489d372@kernel.org>
In-Reply-To: <66ca211a-c909-4d0c-a22c-9cbd3489d372@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE2PPF7BA6A63F0:EE_
x-ms-office365-filtering-correlation-id: 90ed9dd3-b92e-4bd0-cbe9-08de4f5fc883
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?SkgweDZHdWFxV1ZRTFRGdithbTdITmVFQndiSVdzRVNGY2JNTStrOC9Eb1JD?=
 =?utf-8?B?VURxN3dvbDNHM1JSaC9UbjMrZ3B0SVVWeEF0YU1nbEwwcnBIVHMxMjJZOVl5?=
 =?utf-8?B?T3lzZjZCTk5pZHEwb2QwRzhQNUZBOTZPcG53TWxSRXo5Umd1NTlDNE9sdVNl?=
 =?utf-8?B?T0FDQTRmU2FsbFhKMnFiRUR4Z1JTNjh1YTM1MzBYTVFubTdZTythVEZEWlJH?=
 =?utf-8?B?TGlTOWxiVi9FYTNib0g2RTZFT3hxZ1NWa1dkRDhPb09PV2ZlbS8rN1pNc29C?=
 =?utf-8?B?NUF2akU2RGE5R2FxK3VpQUlZTjhoQXYrSGJSeXJ5czFodnpMakx4azZHWHdr?=
 =?utf-8?B?Um5lOUJ3bEREZzRwOTcyT3VBbzNtb0VnR2pqQndITmxnZnhoZllGUmtpRkNi?=
 =?utf-8?B?NFhmRWU4T2ZZeGRzTFRuY2FKQ1ArU0Q0cWs5Uk1Ocm5MOHExTGhNdkR5a0Zl?=
 =?utf-8?B?dTBJenlrL2pGVkNZTkw2cXIwSk04WjhmNlppcDBPWE9Sem5hUFJ6MDk2UHR2?=
 =?utf-8?B?V3pDT0ZoUHdlWm05ZEw5SG5KV09Va2c2b2IzWTZiZnhzZXRGRDdPQjc3Y2or?=
 =?utf-8?B?LzZQaXJBNFJESDdiRFJmUU9QRWhaa1U5bjdIR2tDTFBJb2VBMit3dTBja0N4?=
 =?utf-8?B?NHhEOTVwRUF1RjJNTGpRc0tiMENYY1BkcFRPVWZnKzJNOHNiSVNFbktXUG5N?=
 =?utf-8?B?UXBaYWxWQkpvSHp1cHkvTWtzSyt1VmVDeG5lZFBjdDR0NndMTWROY3l5c3Uw?=
 =?utf-8?B?aGZpQ0UrSGdMakF0aDZocC9GTkZ2WElXZ2ZybmRMWTVwZ2Z4V0lGbXZRcTAr?=
 =?utf-8?B?MmNzREFyM21ENkN3RWY2V3JUYmM0Z2JoQXYraCtHbS96NFRybnFLOE9uT2NQ?=
 =?utf-8?B?dWtyTkdneE1VNDVhcmp4MTBxSnd5Mmw0T2pNcit0aElrTVFGUWpnU0c1U3ZD?=
 =?utf-8?B?c0FWbndhaThZSUtFeGE0QjBkM0VmRys4UlR0dlJ6S2pFSjl6OFMrRUpQeFYr?=
 =?utf-8?B?L2w0UFMzV2dmSDdNTjlFaVNRUStCcmVKR2NHNkIxR2hQTkZ1U01DeGhldlRu?=
 =?utf-8?B?MWZ6RlhwNjN6ZHBpYm5YMTFONFNlTVcwT2JUS3lrRXMyN0tyVDc3a1Q1aDVx?=
 =?utf-8?B?bjU1czJOek9NSVhwUFF1em5GR3lZdlRyWjZiYVZUMkRVWk8vZnowckxHR3E1?=
 =?utf-8?B?ek1PY05pQzhCZUVLMk5YUW41N0EySitnQTlhMzIra05BSDJKSnpWUFhZMk02?=
 =?utf-8?B?TjRQK252NG5ERlFuN3JSRStUQnJqNjdacU12L0hmYmlleUN6NkhDa3NZRHg2?=
 =?utf-8?B?THAwWFhvZ0NVblJmQm5SZFpmR1Q4QksrZ1V0SzVHS1pRRkJRZjRiT0NJTVYz?=
 =?utf-8?B?LzFpbXh3YjUvSnNxVHkzcm5GT3RVNnVjTUI5WnRTaUh5aGdvL2U0eWFJRFFU?=
 =?utf-8?B?by9Ua2szRWwyc0VQaTB6U0RWWC9KODVNSTdFL1ZCVHhPOGVDbW9BL3BQMVIr?=
 =?utf-8?B?b0lHTjJja3pNZ1NlSzBrdHNxTmtKV2ltN3FLMEI1bng3dllOWjJkNjlabURn?=
 =?utf-8?B?YXlyYTg3UjRrV0FjY01IQUZTdUhiNmo1aklVK0VlL1AyVjc2b3ZjcWs3MUgv?=
 =?utf-8?B?ZGoxNjEraWNXbHRKaEtQTjMzbVRFcXF3aStvV1d0TVVIWTZ5dEw0aTJoWUJ2?=
 =?utf-8?B?TmNTNjFtQUFBZ0Z3SGF2QWNFcHhCbDF6dUxXbUhJdk9xSkd0SmxsVGxRMjZT?=
 =?utf-8?B?aFF0dHE0bnBNWkZhUWNPd3NNcUxwWllpZWJ0bi9rQ2Y3T2pQUVRiNitPZ1hI?=
 =?utf-8?B?VUhKL1V6aThDdDVHaTVvV0paMEcvTDBFcng1SXdqRWRUNGFPSnpEM0U4MXdr?=
 =?utf-8?B?SmcxQkgxSndDTGRHZEttbXpuZFlNaWdMbklTUTdZSitIYVc5NkpuS3dDMUw0?=
 =?utf-8?B?dEF2NDRRTUIyYjdMZ1J5ZStKVStWUUdEZUc0Sm5ZdGllbXZ3UjRSSGd6dUdN?=
 =?utf-8?B?Vlo3d3lKWk5yK2J6cmowNjNRMjY4ZU9COWx6KzlXbWZmZGJUR0lML0ZRb215?=
 =?utf-8?B?VDZPOVFOU09IcjVkWkNQcEVmQVdOaGpLejFuUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXcyTTNpOHdxVWVvYjFEMDZTWWRscEZTNHFwcnBoMi8xR0p6blcySTVmZEFk?=
 =?utf-8?B?WlhUSzNueTZ0THhzbG1HSHQzb0NTajZVYUtzQ3JUL2dQOU1lbTdmLzhTdkl6?=
 =?utf-8?B?S2RLUGV3Q2piMXVXQmZIbHIwSVZpeDhkbGNweEN3UExkdzYzQVZ5OFhhM3ov?=
 =?utf-8?B?Y3RUOG9nSi9FaUx5KzhnN29wU0tBMDZVaWh1WTZKaitoYlQwQTN0T3V0NmpS?=
 =?utf-8?B?aHdhZzZML1JLQmo1M0UwZVhaR2dyL2IwVlovbDNrUmNOQkV6R1BaRDU3c1pK?=
 =?utf-8?B?bGJNejBheGdOOEZObVIzUEhtcnloWGZXMWtnVUdhSzR6MjBFczZVZFdtZjhF?=
 =?utf-8?B?U1doeXNNVlhDdnZteVpZOTJTbDNHZ1dOZXBhUDJ5cW9sV3ZPS0hBcTYxalhh?=
 =?utf-8?B?YUphY3hUNElZVGVDVHc3OW1tbnY0bmpKTnI4ZXJoTTI3UW1CSlRiSGxpTkdv?=
 =?utf-8?B?eDMyTHZHcjFWakJqMnp3cVRDcWk3WW9MZk93dkMwMHdGbkJDa3ppL2pWd1h0?=
 =?utf-8?B?N1BReTBqVjExTC9xeDZoV3YvSUpvODl3d2lhN2crMGVPRE52ME5VYW1ad1Vs?=
 =?utf-8?B?Q1g4Q3VMcWMzYlYrM000VjRpb0ovaXZvV25EYlhHMFFFRTVWSzZRUStlK3Vq?=
 =?utf-8?B?bGNzZEVOMWhTY3UxRzhHMkZDSkxJUEJZNDVFQnNzS2FWRWdNSG16L2VUWTQy?=
 =?utf-8?B?cFJmWWpsamJBZGpBM2p6UzFxdTM1LzNFQmdvcUdzWERZcGd2dlVRdGlBUE9m?=
 =?utf-8?B?dUEwSEwvSGNaT3VRL3BMdDl2emhNRlR1M3ltZDJQdjg4ZjRMNkhuSzFKWnlu?=
 =?utf-8?B?OCt5MkR6UktKS3RLbjVwNFVxUmVibjZWV2RsU1VGQkJHbjNrT2dTRXJadUR2?=
 =?utf-8?B?MzdDODVucnhyWmovbFJmTklvOHlPYS95R1MvUVFDdHo4Q045ZXBuMHYvOWps?=
 =?utf-8?B?b2F0S25KcDU3Vi85R3J1TFJaRXYxN1p1UjVYeFRJb3M4S2M3cGk4M3RWZE9V?=
 =?utf-8?B?U1VkQzg5SHdMZUhOWFVCS2R2VmphN2NZWFZ1SkZxTWdzQzFvZkIyZ0RIQ0lK?=
 =?utf-8?B?bWZ4RURMTjZCZVBvMmtsTXlYNmYvdGdvYVpUVkhyNVVNK0Fyb1ZwZXlCa3VQ?=
 =?utf-8?B?aG1hSkpBejBWY20zT1J5ZnNJa2ZNOUsyODhxSzJRRXh3ZGF2Wm9jUUQybVB1?=
 =?utf-8?B?dUtmd1laK2kwTDRHUWcrM2U3bTFIWjJpNHl1dTYvUkNidFdrMTdKam1QaXI1?=
 =?utf-8?B?bkFkS0lzN3hnNHkrd3daSnJZOVdDRG9QMkRTSy9pTjhRZTFKYjZZazljclRW?=
 =?utf-8?B?RWRWSFZEK1VneGp4bTZaYTRiVnBJa0w3Z3RGSkFHL1BOVmJaTWFCb0xQQzZD?=
 =?utf-8?B?N2txaGt2eU9Sd3BsNFZGTnBnRmxSUW16U1BxdkZJQXBtUzdOSFV2Mnl2dkoz?=
 =?utf-8?B?QWhWbFlzMUpSWUxHS3JaV2ZyUWxJY1VadEYwRURZek9XOFlJajJhNUdlOGEx?=
 =?utf-8?B?SWg3NFVNd0RzNnNqZ1VHK3ZGdExwR2dDZm8wY1F0c25HQ0lMT1Z6VFlKVktv?=
 =?utf-8?B?QjlqY1BDSTNaNWRXMzNITklpeG51TUFwbDJCY25FNFJrdFFVS2h4ajI3NVB1?=
 =?utf-8?B?OFlkMkxoODZZYTRoUWF2eXRzbEZla1BnZDZKTWpJb3Q4eEhhek1LMndpaHBQ?=
 =?utf-8?B?akZWdlpzTHkwRW1RYmVmS0lTQmE4Y0dQTlYwTGdDOGFJWER0OWFLemYwSEgv?=
 =?utf-8?B?dVpNYXpzNndLMjNKTUFPUXdSekFJWk0vWlBCbExpOC9HVm92U2hkeC9YdFZG?=
 =?utf-8?B?TG1iUGZiOXN4K3lnVUFqNjFkUVZlc1Bsd1FVWGVQNW11NlAwNkFoQndSWWIr?=
 =?utf-8?B?cDZzRjdlMExmK045RnRGaHE3cmF2NmxienhxNEhBOUcwWTdyaGNUb0srWEU5?=
 =?utf-8?B?UytPQ01ocDR5R1g4Q0F2VkIvWVNWMnVmWlJWRWVSUHNJRnM1aHFrMEl3YVY5?=
 =?utf-8?B?eWp2emNhaE9ROFZzTWQxRUxuNytlMkFWRVV2OFZIWVp2NDZjZTR4ekxGRk5T?=
 =?utf-8?B?S1hEdjlkS3Y2UU9iUFd4K0pBc3oxeUJ6YUZjRmdnalNFc3JSRWl6QmRVMEVC?=
 =?utf-8?B?Zm5JMXRzcG83eHdmRmFCZHJ5VmhGOStEWE1uZjhJaG9qbC9SVXJCTExCUEVp?=
 =?utf-8?B?NFJ5a1BEUVFwVXI0ckRrM1lKck9iNjA3NjE4QVZyMjR4cWgrbTFSS1hGazdO?=
 =?utf-8?B?MEdGeVNzS0hSSi9ZRVRjYUwyN3VtNzY4R3hndmswb0JHeUdNOHJnaFRFdU1O?=
 =?utf-8?B?Y25FRVljR3NSampxTytxRlZPZVg1ZjlPeFRSOFduVzVQMkdDTFZFTmIyRlJG?=
 =?utf-8?Q?Y3tK9UnqGa7ZiAxE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3401B74CDA8C34C909F1ADCE240CA17@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ed9dd3-b92e-4bd0-cbe9-08de4f5fc883
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 09:16:33.7146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFnxfCws2b8at9I5cSiPWybLquodjSvatSGOWbgSDDplxUWAGI761R27ryRJ1POl/nci1vo28oXQL64xjHj0jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPF7BA6A63F0
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDA5OjQzICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBPbiAwOS8wMS8yMDI2IDA5OjM4LCBQZXRlciBXYW5nICjnjovkv6Hlj4spIHdyb3Rl
Og0KPiA+IE9uIEZyaSwgMjAyNi0wMS0wOSBhdCAwODoyNCArMDEwMCwgS3J6eXN6dG9mIEtvemxv
d3NraSB3cm90ZToNCj4gPiA+IE9uIDA5LzAxLzIwMjYgMDc6MjIsIFBldGVyIFdhbmcgKOeOi+S/
oeWPiykgd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gSXMgaXQgc3VmZmljaWVu
dCBmb3IgdXMgdG8gc3VwcGxlbWVudCB0aGUgQUJJIGRvY3VtZW50Pw0KPiA+ID4gPiBUaGlzIEFC
SSBtaWdodCBhZmZlY3QgdGhlIGFiaWxpdHkgdG8gcmVzZXQgYW5kIHJlY292ZXIgYWZ0ZXIgDQo+
ID4gPiA+IGFuIFVGUyBlcnJvciBpbiB1cHN0cmVhbSB3b3JsZC4NCj4gPiA+IA0KPiA+ID4gDQo+
ID4gPiBJbiBub3JtYWwgY2FzZSB5ZXMsIGJ1dCBJIGNhbm5vdCBpbWFnaW5lIGFyZ3VtZW50cyBq
dXN0aWZ5aW5nDQo+ID4gPiB5b3VyDQo+ID4gPiB1c2FnZQ0KPiA+ID4gb2YgVEkgcHJvcGVydGll
cy4gQmFzaWNhbGx5IGl0IHdvdWxkIG5vdCBwYXNzIHJldmlldy4NCj4gPiA+IA0KPiA+ID4gQmVz
dCByZWdhcmRzLA0KPiA+ID4gS3J6eXN6dG9mDQo+ID4gDQo+ID4gDQo+ID4gWWVzLCB0aGlzIHBh
cnQgaXMgaW5kZWVkIGJlY2F1c2UgTWVkaWFUZWvigJlzIHJlc2V0IGhhcmR3YXJlIA0KPiA+IGlt
cGxlbWVudGF0aW9uIGlzIHRoZSBzYW1lIGFzIFRJ4oCZcy4gVGhhdOKAmXMgd2h5IHdlIHVzZWQg
4oCcY29tcGF0aWJsZeKAnQ0KPiA+IGluc3RlYWQgb2YgYWN0dWFsbHkgaW1wbGVtZW50aW5nIE1l
ZGlhVGVr4oCZcyBvd24gcmVzZXQgY29udHJvbGxlci4NCj4gDQo+IFNvIHRoYXQncyBhbm90aGVy
IHB1cmVseSBkb3duc3RyZWFtIGNvZGUuIEFkZGl0aW9uYWxseSB2ZXJ5IHBvb3INCj4gcXVhbGl0
eQ0KPiBkb3duc3RyZWFtIGNvZGUuDQo+IA0KPiA+IFNvLCBhcmUgeW91IHN1Z2dlc3RpbmcgdGhh
dCB3ZSB1cHN0cmVhbSBhIE1lZGlhVGVrIHJlc2V0DQo+ID4gY29udHJvbGxlciwNCj4gPiBldmVu
IHRob3VnaCB0aGUgY29kZSBpcyBhbG1vc3QgaWRlbnRpY2FsIHRvIFRJ4oCZcz8NCj4gDQo+IElm
IHlvdSBhc2sgYWJvdXQgRFQsIHRoaXMgaXMgYWxyZWFkeSBhbnN3ZXJlZCBpbiB3cml0aW5nIGJp
bmRpbmdzDQo+IGRvY3VtZW50LiBZb3UgY2Fubm90IHVzZSBzb21lb25lIGVsc2UncyBjb21wYXRp
YmxlLiBXYXMgYWxzbyByZS0NCj4gaXRlcmF0ZWQNCj4gb24gbWFpbGluZyBsaXN0IGJhemlsbGlv
bnMgb2YgdGltZXMuDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IEtyenlzenRvZg0KDQpPa2F5LCB3
ZSB3aWxsIGNvcnJlY3QgdGhlc2UgaW5jb3JyZWN0IHVzYWdlcy4NCg0KVGhhbmtzDQpQZXRlcg0K
DQoNCg0K
