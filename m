Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C75BE5E;
	Thu,  5 Mar 2026 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703247; cv=fail; b=ItxLQbYa19ICHRu+onaJoqGdP+ovo7dppRHBxxtkgE8CZuVolXFwd9DmzkiVsFq66O+viBVcC2OAfcxLpG6JH/GH1G5xd14GXTlClulvgKYvwChHFOwvtg8pVEpwLApj5ofSjMgO+sjHjub7uvLXqmiH4YGBONcJ+O/gUIhUsy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703247; c=relaxed/simple;
	bh=GWG6/ivhlp2A3RnxzwhliQv3nZmZbuKhQCC0rGSqbJc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Et40wcdy4cbA46R8nUyQxOxK4KBXR0EFnucPjvuYdmcvZsCqGQT+IZ/2Mcm+dM6yPYb0jCDfz30fb8q46uM9I6E3U+9VRijvFwlXq8n0ZN0JbdbydQOwXDlZRdCST9+W6xdG79yEjiInqa29SGI7MAaA+u8TdSldL7ZeX6PGiRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BLcCnEZU; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=l3/K2vc6; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BLcCnEZU";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="l3/K2vc6"
X-UUID: 702e2ba0187611f1bcd7499a721e883d-20260305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=GWG6/ivhlp2A3RnxzwhliQv3nZmZbuKhQCC0rGSqbJc=;
	b=BLcCnEZUSRSSFKhSt+SY+rC0mzu00qfTFTJ3tcKDmBSZJ5wkCE1HxhjQXTuVYCHAzZvJ/rdbtcAWS9RAVUjCznP+fk2HKzS54QTsWv/kIC6hYZmPsUw113AsnaTxbommzQIXGQQGbWZrODxKvT6u7cw6HbSir74Br67o6wwfUH0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:c4c08494-a2cb-4d49-b678-30d0f3481474,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:b5b846ea-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 702e2ba0187611f1bcd7499a721e883d-20260305
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 927874175; Thu, 05 Mar 2026 17:33:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 5 Mar 2026 17:33:57 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 5 Mar 2026 17:33:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KkGxLax0xb0n0/SDK03HVfhd044yCoIAGa05uQtHF2gl8ZnEf9dKnSzQk4h024nchmnfPBsE2RdNw1Tzpbg/7+1NmMdtI9RzrYNZMsnSQit1ZXjtgNqRhBUELYROBly2EV1Z6nS/oNY3qTO+IR2ztiDv0nfvdmQMRYJHVNII7GDS4XSPR/8BOtRZQ1qTvSqgWZhesLTLbU72SdpBn+4sV1ue9s7cc+NzZ25NezMiNIlFS3HwjRD9hA/+Lx+SrhWe/3qr4kKE+b4eNds33r3REFxoJByRo9XGVR/eu06aAacP3DoM8WCmuv9sJKgvamPEzML7E4FEv23ZQg/SB1D6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWG6/ivhlp2A3RnxzwhliQv3nZmZbuKhQCC0rGSqbJc=;
 b=dmW6gfPfirz3Z02UPvrc4G7FgSQ0o6sgBNVzH+L3RACwVcXFmulCBJ56JDqHVHYcJddXbutr642ADgku53E4bDXP1gZOCPJQukHKC7JTLdxnKeg3Ha57RrN6hdNHeVFKXt49IxvLMVfYixQ7KhqgkAnQ7U3hLP4HUiv+F83Ssz1SW0z8QgNY4/iZOJ/7Y/3QcLL2WoDZZ53sBZ9Mrj1wK284hlZdDFIvwmXyTWXjiZb4LHeJ0Nvu7td1DZu8u0/a5L7F1TIMKwY3Y5KBE+WmwqJrJhLCTsWFikbPFumpeHvc0ITZPqqbdjepiRVu9Td/bueNVp8kvnEYRvRLvvB12g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWG6/ivhlp2A3RnxzwhliQv3nZmZbuKhQCC0rGSqbJc=;
 b=l3/K2vc6KTiXyrQ/7HXCh//1VuDS/yJ6CGKjjPDTTRRQl+vmcUKb8UY7EjLdad4h2kH8OUxM5rqwfa87efcZGKO6uvDnW6GABI2NOpLg0fnHan3Gk42B8BRHaikYXQxE8gjuUrOBfa/8DJe4PbRQPrN95ic7LLdhUfjVyZMjlRo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8036.apcprd03.prod.outlook.com (2603:1096:400:44c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 09:33:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 09:33:48 +0000
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
Subject: Re: [PATCH v8 14/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Thread-Topic: [PATCH v8 14/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Thread-Index: AQHcq+cDtmYSdLV46EKlRkVOkZsChbWfroeA
Date: Thu, 5 Mar 2026 09:33:48 +0000
Message-ID: <55cd78f03e8e363ccabfc04b099571e03a45403c.camel@mediatek.com>
References: <20260304-mt8196-ufs-v8-0-5b0eac23314f@collabora.com>
	 <20260304-mt8196-ufs-v8-14-5b0eac23314f@collabora.com>
In-Reply-To: <20260304-mt8196-ufs-v8-14-5b0eac23314f@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8036:EE_
x-ms-office365-filtering-correlation-id: 6431526a-deed-4cd6-beb1-08de7a9a4dd2
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: wwM3IowN+LyFLbv5NAw+11yt4YvPhnMw4i94NHX9X+ApdZ0S4P3yWZgaXO5AJ2EIoU6RJyrv4371DHSQRY0Akax9zIe6S9HJGsUCvPYA6O1X1zQ18TTw1+Br38uquOvMgetVNBBg7YhW9f7w3aHv7p4h/TmKa1aHLEfMYpBmNvteIZRtATqRCiQqD0FIz78vQhZZcYCzd1VkuI3iJrHvy2mgTbTUKxKRoJqJmcMWyvXqds0BHbgy1CPzc9DaOhQ3GTzPK3cd2mo4DQfQWUel7TukMFmF917zUSeTiabtaK3yoqoogtEXKhvSoXFutX8RMyjd4Uq+6QHZm7LdOc/zq8ZKtHUFXww1IGZfTq14U6hAY29LiVg9o9kjH2RJK+MZ5DerLUr44UhnZ3Ws4pLmTd4NtzPGufszDQnTqcu44DYpgfICoIDFck4BXaIM/ApCYSMMoOgN/yL8ukU/crWfqF6VRlkcPmVL2TAdgiZFFsq64v0zSmCCLzPIBc/RmImNioOAnr66sJFOvV+HiUIHbt8Fs21XQU7Fj8RSq8lxQx4Xw9h0y/t/1XH6rVqKgrjGGfqsNEyhcVSNkCA+IJ9NMAl9VcyE6xNilbpMH5zM4YyHax1NheieQ2a98R0AumJbbjXp+99u3ORdnF0v4fk8R98dt5JVPXrepp/k9qRJkYzLcuT1Rby7qG4JqWKKsrMjbDvvc1aXCjzpATnJBUhOILl99o9ubE66YkJPVLcV8Wp3EioBQA5/yF8KlKc/A4BdjNf8/oPnd55dqUMBhm2U8dgoWC7ukNqLTtwsAUERT/+HWVO8HXTTqTZsFpTO92hA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTUrejNDdlRXT3FvekxaMDFwUnhydG1rcFNEd2lWS2hIdTVWTzU5R095UjVl?=
 =?utf-8?B?cGM0TU1LQXEwQ3ZFanJWRXhIOEMvM2grWEpiQkc4WUZTbjJhbHp5RG5KeHZM?=
 =?utf-8?B?M0ZKSkJqQ2lobmhRaFpPeEdlL2V4aHd4bkR0MFhyeG9OV3VkUXlNMmNXY3pO?=
 =?utf-8?B?VHNqemFzWm1hRjVzSk5wckRkb3N1QjEyUnVLQkp0YjdEbW1QN25SM1E1YUph?=
 =?utf-8?B?SUdrUmtXV3I2SHRHRkJhRW12WEw3OW9OYTUrSUFnQjc2amhYaE8vQkV5UnBB?=
 =?utf-8?B?NlVQVXB2U2I2M2h5Vm53ZE1hdGJ3Ync3akpSTjhwVE9nVXVXVURiL0dxdjNE?=
 =?utf-8?B?d2ZHbUZXYXkwaTNEc2RNQmVicXl6ZjBCbUpxTWxYRVVxQTV3Yk1NVWYxUm8w?=
 =?utf-8?B?Y0NGWkpva25JcDE3dGYrb05tN2g1Y2ZERFJreDAvMjF3MVpOcjc1Qm1TR1NI?=
 =?utf-8?B?OUJadWwvWFY5K1plU3o1U0FWRUkvLzNlSDJZN1loZHNhWFJ2eUhPVjFaRlFS?=
 =?utf-8?B?VXpNWUNrQ1Uram5kK214Vkc0V3ZPU21DbVdQYkJ6bVdVYlRGYU1CS3VaWXFL?=
 =?utf-8?B?Wm9rL2x3MlE2cTd0QVJOZitzaXh0NzNNdTJJOHdOMzhuUzNDekRpYTAzVC9F?=
 =?utf-8?B?aFlIaDlsaHlyQ2hVOWJvNWtjSmxDTysveDUwRENUZUxBRkdtWE92MFJ5Y1NP?=
 =?utf-8?B?TVV5c0tuWEc1QzhScG5VeUEzdVBaV0NxTnRjY2g0WXBZNDlsM2dNL3M4VGRz?=
 =?utf-8?B?L0wzNFB3ams0dFJsdkQ2R0xNUUtyNGp0U3N2Mzg5OGJlZHRGMXhwVmVBQVd5?=
 =?utf-8?B?S0xqRkg0Y2luc2lpeUYrZExLU3EyZHBDeDFXZGRrK0Y3ZG9ETlplb2VqV3RK?=
 =?utf-8?B?YkppWkNZVnZPUVQ3MEtYaWp3SWxwTGFPYWhlNG1pb2tBTUE5MjZzTkhHenBn?=
 =?utf-8?B?elZCOWNYNXAvdWFUZmhaTXdpV3VUemxTTG0rK3BuQkU5d2E5NEZOZlgxcW5a?=
 =?utf-8?B?RjErbVh5ZW01dmROM05tcU9iMkp3OG55U1ZMOE5VU055LzUxQThicFhnYjha?=
 =?utf-8?B?b2lkcjlSMEFPZTN2Vko5NDRMQXJVZ1lNd0t2aGlNRVpvNXFzUVB5QVlOYnh0?=
 =?utf-8?B?ek04NExEZzNTT3lYWURpNXE0WjJqRHZEL25ONmlZbGd6WnRpWUE0cXNKWGhu?=
 =?utf-8?B?bFZrT3R0NndlczI4QzU1TXE3VUxleFVHYlVtdkczeW5yZnk0M1Q2L3JGa3po?=
 =?utf-8?B?TVFhQ2ZlOTA4ZjNzcXJCdEpWS2JIaHExZmVZTHY0SkMwMWg2MjExcEJUT25C?=
 =?utf-8?B?REJZNnNONXZqb2t1bUlTL2dZMlViaXgwMkx3eFZyVHpvaDh0TU1NYkdERC9t?=
 =?utf-8?B?UVp6NDVud0xIKzVsc2FoOEk0Z2FBS3BEL2hsMnhaM2pnREw0aTIrY0FGeXor?=
 =?utf-8?B?MzBQYXFJbHR1elUrZzZRMTVNZnFnU0MySDhPam56NzdXNXVlZUx4bVVSVWI0?=
 =?utf-8?B?TjliL2ZrTmNmMjAzN3dUcXFYajBGYzlDZDRLblZ5ZUQyb3p0WVBVWG8rZ0NU?=
 =?utf-8?B?MmdZTEpsYVhVQkwxUEZndVV2NkZGWFVwV3FzYlZJMlNzOVRWMkdwVThJRlZY?=
 =?utf-8?B?bmRpVjlTZUx4b3FFTVZyRDhEWFQrdjloMnBPV2wwQXJ4Mi9rYnJRaXUxeUVM?=
 =?utf-8?B?UnpxZmxhTHF0YUdPclRXZW9STHZqbjRDSTVkMnpmQ3RNdEhwTVFyaXFjR0Vt?=
 =?utf-8?B?OTVWMkRvelNiZ1FSMDB5OENaZGgvS3pZb0YxeUI2bFhCczcxTjVmMXRJNkh4?=
 =?utf-8?B?ZGpVZnNUQlBFT0dVUGd1NzF0ZExDMTNLRHVuUkRpWVBrck9KNkRaTnVmUEpl?=
 =?utf-8?B?Y0xwcDNwRXl0cjJndlRWaS96bFFRR3JwQzNRa2RDLzVKZWdoVWVCblZxMVVz?=
 =?utf-8?B?eE4xVDNqRm1rNC81a0xwWDJJWVRUREJiQzJ4eEd3NkM3eGIwa2pib1FGdGo1?=
 =?utf-8?B?WU13US9vaHJ6aVBEbGVUZWswVWwvTVU3MzVyak9MRXdhbFdaWFA1aEd1aGpH?=
 =?utf-8?B?YzBiK0k2enRUOW1WdEowV3F2Zy9FMVI0L1pnZkZPMUpLMlVkVHVNOE0yM3U0?=
 =?utf-8?B?aHM3Z1dVMTFWV2UxU3NyNHMyK0ZTWHUxSG4yK0Y4WEVJQjJNVGFnTW5XTEJ0?=
 =?utf-8?B?U2lvRkV0MkxtZzZpRmtUWWdFY0NnSDBCZHlZYURGbmpCdy93UW5wd1RSTkh3?=
 =?utf-8?B?dXNLUmtCdlFNelowV0loWjdVUFV2TE5mQlNHZFIzSHZTM2ZsT1ZuQTRXamho?=
 =?utf-8?B?cXV1TTE3bFY2WHlLRHh6UnEwT2ZadHJGVVh1M3hpYmtHYjRJcUUvQ3JmQ2dl?=
 =?utf-8?Q?AbBiij9GboZh5O/M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6225EC3818BCED48A00E0DE4A7EE38E2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: JeJUrb7S3SNd48q3SvalJSgOAxP52IiYcECn/NixFUcjy+gzaJ3g2v8XgdeJhfqIfWFuSgdvc3KCTtEDrTmn/gnE71YysgbqkFgUI1kfktys/lpgAUoqCvPkpF2Eh8Sd/CTsjN9jx/C9ab/fq87EK4tj2iFU2WlPRS2/cyUKafJUcp32xrcYuMHtg63aYysCxAJgyEUXT10Zouzk0uRwYRd/iM0oMVdPTWC8KnbL6U71Io+7D1ly/TGf/gcUXBGp9FLPJa3ZI5mtgrewum/u3TeaJWxh8b4QMdLzxzxM6qwMUcZHUyyBV2tfai84fFwibTN7+mT00Yp8gMIvUYVujw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6431526a-deed-4cd6-beb1-08de7a9a4dd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 09:33:48.1769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c9I9xve+JMS0K4W1XschxBJAqp7iQ+GeSsm3/pDCY7o7Ypp4HOdGkdXS0mZsd9AairMMEnjIbuObbLxgcWMeBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8036
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDE1OjUzICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoaXMgZmxhZyBwcm9wZXJ0eSB3YXMgbmV2ZXIgZGVzY3JpYmVkIGluIHRoZSBiaW5k
aW5nLCBhbmQgaXRzDQo+IGNhcGFiaWxpdHkgd3JhcHBlciBzZWVtcyBwb2ludGxlc3MuDQo+IA0K
PiBJZiBvbmUgb2YgdGhlIE1lZGlhVGVrIFNvQ3MgbmVlZHMgdGhlIHVmc2hjZCBxdWlyayBhcHBs
aWVkLCB0aGVuIHRoaXMNCj4gY2FuIGJlIGRvbmUgcGVyLWNvbXBhdGlibGUsIHdpdGhvdXQgbmVl
ZGluZyB0byBnaXZlIHRoZSBkZXZpY2UgdHJlZQ0KPiBhdXRob3IgdGhlIG9wdGlvbiB0byBmb3Jn
ZXQgdG8gc2V0IGl0Lg0KPiANCj4gUmVtb3ZlIGl0IGFuZCB0aGUgYXNzb2NpYXRlZCBjYXBhYmls
aXR5IGZsYWcgd3JhcHBpbmcgY29kZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbmdlbG9HaW9hY2No
aW5vIERlbCBSZWdubw0KPiA8YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9s
aUBjb2xsYWJvcmEuY29tPg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0Bt
ZWRpYXRlay5jb20+DQo=
