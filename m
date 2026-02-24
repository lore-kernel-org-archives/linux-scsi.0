Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31D136EAA6;
	Tue, 24 Feb 2026 12:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936817; cv=fail; b=doTHrmO7eOE3xqKr+C5zyNEqPYgdVX1bYXpoDhnziwwkVjbhl7muOo29wBqWuF5bZRxPiRFeNYkMPjDeKa4eG2QdlFl5KH+OiqugUhGDVob08dDQHnfc4uTQovygfn05iEUa6/3RDiCVhjhDPwJDOF76IL3tHtg1dAS7EbFrz/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936817; c=relaxed/simple;
	bh=G5ABMQP3shS2yKKD4poxWIGJ+qOiX8cDv62GFaYRCqs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GpEYnLnUXuEomFbmsPPURCl9tp4FFXDum3eQTk9wEYnQilT0L3DXQ9QTXQUVVj9kqZYNk4XjYi12gvPf/s1n5/Np9peioJaDDWLyw1s6nTHQf4j93/xZfkZ83q09QIFUn25rBb1uKbLHgi6fRmGPIV+rGNqQkRBGrviJkoy9qEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PwjtBZF6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=J7HHbrOG; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PwjtBZF6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="J7HHbrOG"
X-UUID: f2620c54117d11f1bcd7499a721e883d-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=G5ABMQP3shS2yKKD4poxWIGJ+qOiX8cDv62GFaYRCqs=;
	b=PwjtBZF6qWfRM76JLeWZbsCM47BGEEuxLsHewnsORJ59l3vhAVB7sLwOZGMaV86JWNj4ZfkbYjuSycqMn5EKwPoH9J9qxVlFQHs6pEGSIRG9en/ocKyoBQtjsekhyTuB99IjYkYj4lYiBp0oPK0LIn9HzNicXCkImyzERukqRhI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:055b716c-df47-40fd-a9fe-e0afbb0a64f8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:7ac4f4f0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f2620c54117d11f1bcd7499a721e883d-20260224
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 995936180; Tue, 24 Feb 2026 20:40:06 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:40:04 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:40:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fp+Tnfgr+QRZUjHg0YcplVH/cxx5Gb81eJxn+yFuQKl+4saA9xjNkVG/a0wpmRpkDI2u0PKP8eLO58JXHBLvuzNC+rYPW/4UQDC3Yh0bs94XXutuop3mhAGC8BosXPrW1JPhEft7lmxpDBMQZzinFSUHBocl5H9yZEpUOR20HSn/LLIiC5jSxoXz8t7aoUafi1Bi+QdESB8/KKs4kltCMJtn+6VB36SK+7Z07tjmqBhnmM2f/qAnsUJoAiw+qS+S5iFjtf6alOcCftxVXQeOvPxMbS6fVMWgVQC/5KlnMaanYcskZFD7TUe4MZ4T8q6+q+wFaaR6Ixy2SEYXX8tY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5ABMQP3shS2yKKD4poxWIGJ+qOiX8cDv62GFaYRCqs=;
 b=y3kzC5ehsfobXkbx4u8Vw5aD0Vpf0CLsTvygxYl0LJU79Ne9jOQfd6b1kK9N8ZWf/1VjYRVqqu+aUqXZdC+1SMQRURF42rm83Qr/pC6vkND5bhbn719rg9uiqfgKfF41/gn6TXT/5ZNfKt2baEmP+V7C9NrEWnZSBHIrLcsVIHmcJsogcFB/qDCt8Lpr4zwOohdRq7Fbe5gev9lNgwMp/Fb/elp9nkwrRh2RaSfLe7VqxXQB0SbZAvl8XJ3WhHiCUXhQNFTj9MiPl3UIoSenxaxIbVIpxgIaWtQ1D3YWYa1P6Cm3VWc6V0Ov2+JfN1SAD2JvqTkG8QEIS5scrNrYtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5ABMQP3shS2yKKD4poxWIGJ+qOiX8cDv62GFaYRCqs=;
 b=J7HHbrOG4SniTingia0Tc432U2oTL7JO2PmESRWTwSKF13BmLWkWsTAW3maBhP7QcpFryhsy1eohSy7ssJAXw6CZiFy4XgXYh30FbLzTa8r2T4xjuoWjykpAK2H61Qii/tk+CeglWvjIiNQ81v5JUjl+CCSY0V38zAPRt5KOcX4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:40:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:40:01 +0000
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
Subject: Re: [PATCH v7 11/23] scsi: ufs: mediatek: Rework probe function
Thread-Topic: [PATCH v7 11/23] scsi: ufs: mediatek: Rework probe function
Thread-Index: AQHcn0nUcDjnf+bAfEmRQvLdKFMHqLWR1s0A
Date: Tue, 24 Feb 2026 12:40:01 +0000
Message-ID: <c6a57fa2f0841fb11e6377d7df763a2117a4c01b.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-11-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-11-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: 5b0312ee-7db9-4867-c6b3-08de73a1d3d6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ZEVqZkRId2NJTXVZekNSVkZjVi84WjRwUnBjdC91Mko3R1QxWE54R3Q5Rmky?=
 =?utf-8?B?djZXN3oycll4anJENEhYR3p1YzRNWGMxTGRUN2hoaDhtNG9OVXZaa2YvSENr?=
 =?utf-8?B?T2VBRkh4VDljVy9Pc2hvaHp4STFVTHB5aFFZcm94K2VmQlRDQURKNjJsN2k0?=
 =?utf-8?B?dDk5eVJsSnliYnZOV2h0SUR2QTdVZ2hHalRsdlpiZnl4em5JcXZRdVN1SjBp?=
 =?utf-8?B?aFFFZ3dYN0FwWkgvUjl5UzBRQlhXZFp1cHR2eWhEUys1RU9SU0lNbWROS0dH?=
 =?utf-8?B?dVhTYTJVNmg3eDBtb2VHYzBjSHFJZXJYWVBQYTdFejViLy94QjFIVThHakp3?=
 =?utf-8?B?bktGNmlLb2svVWlKa1pMYmJ0dmQrQ3YwcUtIQUVkNkgzREJoQWF6dW9xOGxC?=
 =?utf-8?B?WDFLYWtPOUdtQzNsM0FiQjdRWGJ3VG1UWTVCV2JPZzRtNG44WHpSd0xjckJE?=
 =?utf-8?B?bmphWWhxbDQvQmhFbk1Ib3Buc1hTOFpiNEZIWmo0U1IvT1pvY01XcWdFR1Ns?=
 =?utf-8?B?Zk1lWE5IaEFQRGlIYWdVbzMxREF2QjB4VDVzZCtmUnJYNUoxUnprL0UvT1pR?=
 =?utf-8?B?SHU1a3ZtQWpOVnB6cnVaSXhHWEl3SGJpaTR6UEwxb3dZWHNVYVNLaVEwRDFu?=
 =?utf-8?B?dnRYL21EUVA2ZzlRcE5MYUx6aHhyTmZHQjl5aU4vbVFZTXRrSXhaUE52cXUz?=
 =?utf-8?B?aVZLMDBCVkRKakpUME5ldWszN2JqaHkzOUdDRlJjVVpFeGpQanUvRkdmTVJ1?=
 =?utf-8?B?RWRMRlNRcDU5MGZFVnlPS3h4T0p4V2tOelZEa3dUUGNMaXJUM1ZsNGwwUFpC?=
 =?utf-8?B?ZzQvU25IQUV6WEMzRUlYTnJYNW1DVHBZNW1zU05TZmlDdjRQb3NqUER1T2VC?=
 =?utf-8?B?S2RST0VYNGQwa3l4UmRiOXdXZFBsb0pIOU5mSnlkVjNHekpsOTNkOVlHT0pU?=
 =?utf-8?B?TGpwMW5IZGRyVzRwWHkrL3NuTG42TFMrY0ZaelZFckcrdEJaMTVEYmprMUll?=
 =?utf-8?B?VGZIY1U2UlVNdlJLTEtXWHowVEV6c3d3WkZCc1BMaUJFdTU1b2R5b1BSWTFN?=
 =?utf-8?B?KzBYaTFvZkFMY1F0R2ZLMnJIVVZHUmFuN3BiNUZsR0Y2K1V3L242S1lTeGZY?=
 =?utf-8?B?MTV4aUpwblpJK3Q4eDZCSDJUbVdoVGNSdGRsSmdqamNrVEVDRjFGaUN2S3Qv?=
 =?utf-8?B?TEVFUkRxRnl4ODd6VnV5NFZIYTRTWnE5ampLSUxrTG16WXFGYXBxdk5JcE95?=
 =?utf-8?B?L0FaVWJxZ3VPM2RUdXp4ak5ESHpCb3Fhdno4Q3Q0dTRrUXFqSzVyY2M1U3d1?=
 =?utf-8?B?WjVXTDNNQXdOcmpNVnRKbitydTFGQmwyTjFKTFNQWXMzTWYxdzRnNDRwaVVV?=
 =?utf-8?B?Y0RIWHlRZjZsTnROb28vQjJKcVR2dUorU0ZwQ1haUnMybUI0OWFncC9ocWNO?=
 =?utf-8?B?SXBnVllRRXdsTDcrMzZWd21NelMvc1NsQlp1RXljb0w1STBBRXhXUElrRTY3?=
 =?utf-8?B?VlU3cmxyMTA1U3FXWUpxb01TNHN3ZUNpekVPQk9JVThXWEFhdVpSR2tUdVAr?=
 =?utf-8?B?V1FhU0RzcDk4dDQzMW9UcGtQRzBoRk1DMlJiOUw4c2JaUHc5dHoxLzJSZkN0?=
 =?utf-8?B?ckJXYWJWNFpPU0FVMG5KSUhZRkRXSDlCeWliYzRsd2FpV1Z6bWFXeXI1Q0N3?=
 =?utf-8?B?MGxDL2RjNU1vS3NoSmtIUkVmWWhBdDBhMmlqbEZpTEF1YnI0aFZ4OFNkOVR0?=
 =?utf-8?B?Z0hkZUdCUzVNaFl2R0tOSUlsZTFqalY4dmRUTGdMREo3UVFvRVFnQUpjY3ll?=
 =?utf-8?B?Mjg3Z2hkTTQyNTdaUTFvY0RqUXJ2TEFoUStxeHVhS3pML2FLUkJFZ3pPY1dP?=
 =?utf-8?B?V2lRcjJNM2ZTM2hpbTREd0pMOWZjYU1mbUlBVE5ucEpBd3l4dUNDWjFMK0hq?=
 =?utf-8?B?YWQzTG9CNXRESWlrdDlmaWV5UXlFT2creGVLbURYQ3ZGYjhjM1BGRURXSjQz?=
 =?utf-8?B?d2dhOWJYS3RRUjQzamNudHFDajdySFJucWl1aWlMWk5HZnZaSlhJeWFuNk8r?=
 =?utf-8?B?TWNKUGowYjNkUmtSQm1iWUlGdmkrSkNzKytOVFlKKzR1TUYrZ29PeTJuNEE5?=
 =?utf-8?B?UTRWWW1Yb1ZrbURORDIwNGt5VXJvcXRENlV6U2FYWk9kc3Z1OExZbzhVRVp6?=
 =?utf-8?Q?823dBspf2Sot2VkMyTXTWP5yEX4tNlXrHP6GuGxpmjlw?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkJ2T3NMbXhNdDN2bXIxcmc1OGZIVkNMOUM4ckVhUGU1UWZpbFh2KzltdnNY?=
 =?utf-8?B?RnBVQ3ZOOWo4eWdyZnpoTnJibXVoeU0zL2xTUVlYT1lzOERWMGVOTU9CSkpU?=
 =?utf-8?B?TjBBeTFpbXYrdUdoWVJ5bEtLcjJyMGgzWDFWbnFaeHNxVUpXVUZlMXdOMTBi?=
 =?utf-8?B?N00vWGJvUStJR0FGNWdQZldjNkFHam5EUmJDamtyMDRETUxJT05JRHpGb043?=
 =?utf-8?B?aHprWGRoY3NKcjFyQ1M5akZUTERxMllaKzJ1ZWlFVDljak11eDVCbjM4bDdq?=
 =?utf-8?B?TzhrQTYvbTA4L3Z5c2dGUUduM3RIOEtaL3U1THZ0cHBOamNMMVpyZzM3TTRO?=
 =?utf-8?B?bnZUVENZcDJLNkt0b3I4cE5OMlJGR0FaWlMxVUFtbm9sSW82cnZHRlNtVWJm?=
 =?utf-8?B?eFdldUVWQjdKM3JnQnNUQWJhV0R2cVN4RVkyVmJOQlZ4eHpxR2JRMXhsZHZE?=
 =?utf-8?B?ejZlODNnWVRoSytMblRlRWgxSGwzNUFteXFxWkZxTjVjMVIyUk5mdWxBZHZK?=
 =?utf-8?B?WHpzSVc3ZWFDeHBaVHJzVzIzY1kwdVNvaGNtZlJjV2c5QXoxbVNOVGxHb0ly?=
 =?utf-8?B?elpld3lsS3NmNTNwMjV4c2pSRVF3cHJEVlNzQWZBZjkzZk9wUmpKM2h6Y3Js?=
 =?utf-8?B?RU0ySm9HR1JqcVl2d214RTB2dU0xZVg5TW5aQ0ZTODJ3enl5K21wRmNhUFpr?=
 =?utf-8?B?azF5VE9ocUdsKzFhdVRobHYrSERud2V2T0RYbHd0VVIwOHVJcDZMS1lCK3dP?=
 =?utf-8?B?WFROZDl2OG9SWWM0V3NtUVhaTC9xaFVOMEhDR3pTUCtlNlR2T1A0SWNmNDZB?=
 =?utf-8?B?U3o2aWpkaEZNOHdmRHNWNklFdFpCZm5kelJKYVdRNnZvdDJoZFlsLzZFRE9V?=
 =?utf-8?B?cWUwa3pIaVNZc1cvSW9kaE84elI1czBnRC90bDFwUllrZVN2eFBxS3A4WHFn?=
 =?utf-8?B?TGVDYzVnR3hGZ1VwZlA1cEpTcnNPYVdmeTRhaWg4VHJMRzByMmNWYUpjbjBJ?=
 =?utf-8?B?T2x0VmhJWGEyOHM5bHozV1pJcTVlRkNKQzdlaTBFS2F0eEVEU3RTV2tETnVC?=
 =?utf-8?B?QWdhWFE2cFU3Mi9FOVRrWUE2TGV5UDBwOVU2MllVeVlndXJpTFFzdGF6aG5C?=
 =?utf-8?B?bkdDbFhJRjlxVlZYZkZuZ3lSRXRTWU5weEVBbi8zSVRYWnZLY29Wek1uRWx5?=
 =?utf-8?B?b3RLeUxhNkJ5b0tIVXp6ZWU2VndMR2ZvT2p4OUV6SVU1UEdqdFdNeTVIbEN6?=
 =?utf-8?B?enhCd21tRUpRNG1iYzJSbldPZ3FYRjRRcXcxL3F5V1pSYjhpQThsOG5WVlNT?=
 =?utf-8?B?dURMaDl1SjJUUWRHbjFKQS9ldUFXTHJRYnBicGNHMVV3dTEwNUFLQjhJS0t0?=
 =?utf-8?B?dUlIL0gvTlZDWk9wK3RlZzZwVmsySEJ1WldObmVUN1pMSDkrdTExamp6TWtU?=
 =?utf-8?B?RUx1ZTBoNWwvVThvK2ZLVjVTZ3M5MmduRnJIdFhuYlMvcUN6bzJVb2gySklt?=
 =?utf-8?B?OC9CMGlLUFFsbXFvSGZXM0pGMmlOSmRmZXJLZ09sSUFpNitjRWQ3emhpTjFZ?=
 =?utf-8?B?NzFDc2xsYlZhWEo5dXdLbldid2ZCeXpaVzcyekorcldqcG5EVGpVVVhLSXFi?=
 =?utf-8?B?dGNqVWdvVDF6RGJlMnA1MHJ4RWJSS0RURDdCbSs1ZXNNdlg1Zm5OVXdObEE3?=
 =?utf-8?B?VUx1MVpNNnpKZGlhaUtJeE5EWG1KbFl4WGdWd1RDY2srN1gxTW1Uc0duZ09o?=
 =?utf-8?B?OStZV1lYdDJOVi9QcEFwSUlIM1Qwa0FjZXlnbVlURG9PZ2oxRkZscFlqTnBh?=
 =?utf-8?B?ZlIxalJZRjBtTG1YczBjRS9GWlVZMXRLNXRLdjFUQitBcEJPTlIzY1dLdXNP?=
 =?utf-8?B?cE5kSUF5Um1vSDBIcGNrWlBzZ0JvL3NMUUJnNG5zVTVmTE84dlkybjdBVkVR?=
 =?utf-8?B?b0RUdXBzWmZrZzl3S3JUVjdnRVFYNUIzcFY0VWdROXFhb1BOSzJ3RFJMdnlN?=
 =?utf-8?B?c1p6SU5Dck9NcFI1ako1c2lUWDRZZms5UCtKK0hJZTlyME5TWFdXZmhmUU9G?=
 =?utf-8?B?QlM1RHEreTc0RCt2YW1yVUJZbkhjeExJSWw4eElsSjZxTVkwbEJnVFpqNDNx?=
 =?utf-8?B?c0Vndnl6encxS05mV09wNys2bXBzOWI4clJaclRGT3VZTVBzNjVhOStrVnhn?=
 =?utf-8?B?cFVKdHd2SGhGUVFTWEpObXVRUkhZaXJSd0ZLL2lhK0owU2pCd0dKRDlGby9i?=
 =?utf-8?B?bEJIOXVvTW1PZjFHeDIwVFVaYW1CY2plbjJ6UTYyZE5iNzhYS3k1V2l5b1dI?=
 =?utf-8?B?Mjl5cEhSQmZpdFZKdmlhVzZzakdaaVRKQTdkODdiSXlXK0dGTGRRVm9yOG5R?=
 =?utf-8?Q?rV7PWak5b4Fsvf7E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3C3BCF218C80249810C9738DFAC983A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: DnRu+RAHh15nhDXPIr2X3AGjsZNGlFh/Sf+EOmK5pwSRlquu/k5sD0/HUeNuPib2ryfpCRK/cvzugqB0GzBPAChDp4IQgnEGWfwgVAOI9TK2L9X19ExwS6ON837OrRQUft6cFcHXscYX0AU0tkxvXjBCuF4ppO+CvqijiucK1RX5fgwn6vSFddePA0T9RUc0gKKHAQ/WTExOhtfR8431A4dlWj8C1z2b58tlPoscq+cDcgCWU72FZaWkb9/zsd5q0dP4gh+raYX4p3kDRM3CQV5wWR5NI2H6fqwArr63sAMjAm2wnaaYpdFBfG2CwvI2kV9Lu1eEGDsVG4wUUjZdaQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0312ee-7db9-4867-c6b3-08de73a1d3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:40:01.3611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpIGWieA0nU4P/DHBYkqWaLO+WJY69AsyZK9cmWZQQg7D8BMrJxAanw0vexIFw6Ku8JreBEcZQjAV5QGhjKLdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFJlbW92ZSB0aGUgdGksc3lzY29uLXJlc2V0IGNydWZ0LCBhcyBpdCB3YXMgbmV2ZXIg
ZG9jdW1lbnRlZCBpbiB0aGUNCj4gYmluZGluZywgYW5kIGlzIG5vdCBtb2RlbGxpbmcgdGhlIGhh
cmR3YXJlIGNvcnJlY3RseS4NCj4gDQo+IE1ha2UgUEhZIG1hbmRhdG9yeS4gQWxsIHRoZSBjb21w
YXRpYmxlcyBzdXBwb3J0ZWQgYnkgdGhlIGJpbmRpbmcgbWFrZQ0KPiBpdA0KPiBtYW5kYXRvcnku
DQo+IA0KPiBFbnRlcnRhaW4gdGhpcyBkcml2ZXIncyBpbnNpc3RlbmNlIG9uIHBsYXlpbmcgd2l0
aCB0aGUgUEhZJ3MgUlBNLCBidXQNCj4gYXQNCj4gbGVhc3QgZml4IHRoZSBwYXJ0IHdoZXJlIGl0
IGRvZXNuJ3QgaW5jcmVhc2UgdGhlIHJlZmVyZW5jZSBjb3VudCwNCj4gd2hpY2gNCj4gd291bGQg
bGVhZCB0byB1c2UtYWZ0ZXItZnJlZS4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbmdlbG9HaW9hY2No
aW5vIERlbCBSZWdubw0KPiA8YW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWNvbGFzIEZyYXR0YXJvbGkgPG5pY29sYXMuZnJhdHRhcm9s
aUBjb2xsYWJvcmEuY29tPg0KDQpDb3VsZCB5b3Ugc2VwYXJhdGUgdGhpcyBwYXRjaCB0byAicmVt
b3ZlIHJlc2V0IiBhbmQgInJlb3JnYW5pemUgUEhZIj8NClRoZSBQSFkgcmVvcmdhbml6YXRpb24g
Y2FuIGJlIG1lcmdlZCB3aXRoIHBhdGNoICgxMy8yMykuDQoNClRoYW5rcw0KUGV0ZXINCg==
