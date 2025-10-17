Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CB0222578;
	Fri, 17 Oct 2025 06:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760683926; cv=fail; b=QJrGAIb1nWW143q4haJJCqjlT6VUU0hJoBiqNBzarIt7NzYqGeR3NeYLpVYtGBsdC9MluvTcOuf3fnbCHfWtoz5T4k7ce4QQ5QyMkAmCcWXGNwGtgGfPTzf4FM2cgoF/cw/UTywKCkxe9v+hmU+2cz0CMyJeUQ2TMXPHYt12MPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760683926; c=relaxed/simple;
	bh=Wbdst2q+UmJ4EX5E5/BhaMzCG9NSOH6HdqCpb5oKH7Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h53SzmKOV84Ho+c5Mc9Mp4c6TwwP2nWjoohuZhUYKjD/Ds6tf4IezDJ1UMQ7qs03xULBg0QyN61sdDEeNtO70wHp+299MdjtPikJXTZ13LaAAxUfnLtOMYaep1oLT3n4cxWJxbtOWGp3ynU1xefgSgg+3gJudD9clkNyXpVOkOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=D5uZgIi7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=M05k2Mue; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="D5uZgIi7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="M05k2Mue"
X-UUID: c62f5e8eab2511f0b33aeb1e7f16c2b6-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Wbdst2q+UmJ4EX5E5/BhaMzCG9NSOH6HdqCpb5oKH7Y=;
	b=D5uZgIi72StcErkncP0lWILr1kmFRafhY58C4vDB4m/J+JTSYr10Jpdxlb8Fgfr9fZC2R7Yy3J4q24+mHUB5L+fnmD5AwiztrvnOHmhKPAYZjpN2fjAhiUPKfPvBek1VuCfI8Plbi3dy+k3KTsoF0AEgTWV3qUkd9iq/Sf29Q6k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:73e3b83a-347d-49e9-9db3-6244fd49f612,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:9e7145b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c62f5e8eab2511f0b33aeb1e7f16c2b6-20251017
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2083839073; Fri, 17 Oct 2025 14:51:57 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 17 Oct 2025 14:51:55 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 14:51:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUIbdGojcEltc+K/fyooQpp2A/Gd5+hGZU0xCzt1xj59H1oBPvSHVghTozA0JzwniOvcfnQnexlbC3Z8zG74/CQjb/K8Mex/P44UoW13Xvw7t7yrFw3BW6BX6zzZJVR1UyKzw6A1B0Vtl3nPnEcftLpSCeCA+2f9udC9eR+9hRm8qlJV+uDeqNSup7XB5TQX4JK8x11iUU8/ggO2FSInGin31Uq47AbVjpfVG1mBbt2Q2N2ZcAQm84IwyPmxvkRCs1+y9EKlI9S0flv3nRe5+AbVHlv3BVhDD/5rPEyX3JdBeVY4AWyG7e61gh+wIiKdEko08416/30quWWZCty/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wbdst2q+UmJ4EX5E5/BhaMzCG9NSOH6HdqCpb5oKH7Y=;
 b=ejJOQmlKWIgU4RqrLfYOy9TJhZYACQM+SYEtAkYWaChM5NkvIHrDnFd81dQdW3wse2G35WyPZkZxF/9Pj9l+t1ZMPgKhKU1zN/O7edKC6kNHGRucPzTMB72G7xOTcasJjxR9b/WdlSbTqVjhVaY92pmyklZIil0XxYmkG4sTS+a3m2hM3tydiCL3tmOplM9sMBI7gx1Zx80Am9/JdD6P9uApqxTBhZMr3y9po8ZU+HNpJJB7dUReGLGQx8nUl8ohOLadLH1BNfXqBX38QdiohhO+8/E/VN8MmxFN9rkOkZy3Rt0XHGUoPEfe2vLzGybL50M/98I+O3K6ddik601RgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wbdst2q+UmJ4EX5E5/BhaMzCG9NSOH6HdqCpb5oKH7Y=;
 b=M05k2MuebJ8y4zRbnDXReP8w8G9CveHhUcqBdkQ2zct8eIKQsswgaicBid684WFzU8RzUnOau2kYnGB+PPv7wtio0hApfe4qD5aKjp0s1QthrdZdXuHacQIKQYj4V2Lj1B+wekNWSW5YlNTnOrJ1QhjRxfgUWpBVo1YrGm9A+pM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYPPR03MB9367.apcprd03.prod.outlook.com (2603:1096:405:2b7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 06:51:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 06:51:52 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>, "robh@kernel.org"
	<robh@kernel.org>, =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?=
	<Chunfeng.Yun@mediatek.com>, =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?=
	<stanley.chu@mediatek.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "kishon@kernel.org"
	<kishon@kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>, "krzk+dt@kernel.org"
	<krzk+dt@kernel.org>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
Subject: Re: [PATCH 2/5] dt-bindings: phy: Add mediatek,mt8196-ufsphy variant
Thread-Topic: [PATCH 2/5] dt-bindings: phy: Add mediatek,mt8196-ufsphy variant
Thread-Index: AQHcPR0UnnBuLpB7lUma1wSUsLg8qbTF6s2A
Date: Fri, 17 Oct 2025 06:51:51 +0000
Message-ID: <5cdd75ee9f048bdf50ca78978c508dffc27e2db2.camel@mediatek.com>
References: <20251014-mt8196-ufs-v1-0-195dceb83bc8@collabora.com>
	 <20251014-mt8196-ufs-v1-2-195dceb83bc8@collabora.com>
In-Reply-To: <20251014-mt8196-ufs-v1-2-195dceb83bc8@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYPPR03MB9367:EE_
x-ms-office365-filtering-correlation-id: 0fe5aff2-c885-4a9d-e967-08de0d49a705
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?anZOMmRyYkFrcE1RZXlLVXRCbmZPRkNFejB3Tjh2NE5sTnBZcFdwa29jeHBI?=
 =?utf-8?B?a1FSaURjWDVPMW5CYXE2MmJINWVBVEk3MFc5Y3ZldDlDY3dQSzJoVlM0ZHpv?=
 =?utf-8?B?Wk5EdzdGR1FNdU9NbHZaKzljTnYzMXVLaE9iWXErZmNnUitGL2RtUXVFRTQz?=
 =?utf-8?B?aWFmR24vNVlYd3BqaTFCSTdRcTJFUFRRZ1ZBblE2U0djUW1PdzB3QjBaMlA5?=
 =?utf-8?B?cTMwd2ZPTUdwaDU3UmlibFlhVldYS1ltSEVWYzFpSXh5bkFyaEE5REJuME43?=
 =?utf-8?B?K0tPZDU0Wi9BNkJ1NHBySzFsT0dBMTZxMkpCUFBKcTduVW1mbGgzbmdHUWVX?=
 =?utf-8?B?NEh6UjIzTTVod0FxZXlTcG12cExQUFJUQzZEQjBOTFIwakJid2c1MnZMYmxo?=
 =?utf-8?B?S2tUTFJLTkV1WUtQS2cxdWZ2QnlFZzhxbWk4Y3RyZDk0dTZwckw0WFM2QUFj?=
 =?utf-8?B?SFptY014Nnd4TU0xSkxadUtDMVZMa0ZNanYzTk9vaytLVUdZdTEwU3kwL0Ft?=
 =?utf-8?B?UFRXZ1ppVVNMMXRxcHdiT2JBeUQvc0xLU2RDaStYT0hRQldCSzdTV0svQTY2?=
 =?utf-8?B?TUo1alV5dFJwRnJhRDlBWTNZdmJkdkJ4VHp5bHhldTljdmtKSTVqQmhwcFhs?=
 =?utf-8?B?S3NKV2o0MFNXSmVyUTZOdXRXUjNWOUl6Nk5wakhVMmxKL3JBOVNPcmdxZ1Ix?=
 =?utf-8?B?aEZ5dzBaRTlzOU5qUWlCWEo5S09XMlZFL0RLSFl5TnNEWkJkL2xjQkRMem84?=
 =?utf-8?B?OVIzUGU1eU1yTkJxRjZUc3ZJd0JiSTNBTm9GZGNzTTdDRzFBYlBjTGU0WWln?=
 =?utf-8?B?WXU1KzJiK25ZcnJWaGNuemlqN3k2bTN5QXhBaTJRWFIyZ1JRQVJmTmlGYU9F?=
 =?utf-8?B?U3QyWEdYRkltSXpWMWowR0FjcDlRZkIwY2R0S3AvL0dQVnExalMvK21TUjRN?=
 =?utf-8?B?cVM2bFZySVpydHFWTHVmNmYwb0JYUWliS3JUcDBLQjllaVN4T3NSNk04N1J3?=
 =?utf-8?B?dHo1TW1SWHU1R0NKelNnMENBQXdrdnVLSFBmVS92a2FwNUE5dGRsVUhUOTlS?=
 =?utf-8?B?TllxLzZDaXhqY0loWDRjV280aHRvYzhLR2hRUk9BOGxBTmhhMmpoY3JLWVZO?=
 =?utf-8?B?Yi9RUUM1dkNoamgxTE1GaFN6QXFtVjIrUURZLzBYOUhycFRPUHRxVjMzZzc5?=
 =?utf-8?B?dHh6YlZNS3ZnaEthNFA1MXA5OVFrdXltazc5OFhEYW1JNmhEbGhYWjhGNXRF?=
 =?utf-8?B?QzdNYnFkb2hGb1lGZ1Y3Z2dtQWJ6MEdPc0dkeldMcHBqUW9vb2pnOTZIVGRt?=
 =?utf-8?B?a2Ntbyt2djgxeXpSYW1PeGRXY0RUeHZYZ1hJaTNuNGhFTFlpbHNweTBaM3RR?=
 =?utf-8?B?QmhsR2VNSk43ejE4cUpoV3dRMlg4WGR6eUtYNERXdG0xcm1QeXdCc0JLdDFi?=
 =?utf-8?B?dnVkNTJiQ25QdVhZZWVZQ2RXTjh0czhCVkhVNC9DRVc0ekduWkh3WDdDcENv?=
 =?utf-8?B?MXlpejdmNk4vQWEyOS9PbmV5bXE0S3MxdmRua1hHT2drbWI5RCt2MnlnY3pz?=
 =?utf-8?B?WnQ5QmVjVVlvenZIZk1qNm5zVnNMSnBidVIwTGcrU1BYekI4YU9Oem1HSk5K?=
 =?utf-8?B?U1FXU1FWVGJXK095bmszRCt5UmFDUDZvb2NiUkZnSUNkTXVrK1dNNzNuRmp6?=
 =?utf-8?B?Mk84cGxvR1F1cC9JZTlMUWU0Z3dyR2wvWnZFWTJJYklONmM3cGpnOFZVV1Vq?=
 =?utf-8?B?d2N5UFBvT3E3K0FydVhRdUZDYkpLcjk3MHF5L0lXV0F6aHJRR0VKaWg1Y3Zw?=
 =?utf-8?B?dTJPQU5LdEVOMzlKZFd2QjVrRTUzOW9JejFlanZhVDRBOEw4eW1CYkJkU2o0?=
 =?utf-8?B?aXF2VHFUamFZeXZvaVl5b1cvT1hrVWVMSnp2dzJQcDJzZGlrUHBNd0tUTFJo?=
 =?utf-8?B?aU8wN3JKSnBveXVLcHVHNDNnYUxCcFRwOURGZFd4bk5GeEwyNHFZMnlJa3Vm?=
 =?utf-8?B?enVmdURvWjFQSlZuMUtxUm5uRHV0SXJpQ0pGSFRwbWVuKzZOK0h1b0pDMXEv?=
 =?utf-8?B?QkFGS1BISit6Z0wvK2hGWFBOajdpSC9MaXR5UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2NkdjFaR3hqWGZldmpoWkpOclBzUFVLQVBpUllBZjVZQVJGMVN1Qm42Y0RV?=
 =?utf-8?B?WXcyR2RMYll5TC83YnpMdzdlWEt0YVpyaGdoWlZKV2NxT1Bub05UZ3JsZnp5?=
 =?utf-8?B?N2ExTEFMQTVzcFpUM2hNY3MrZ0pWNURTSHVqUXJIY085ZlkvL0xFS1hSbEhn?=
 =?utf-8?B?T3NlNDNieXNnNkRsUDJlYTZYUHEvSmVIUVBCZ1AzUHB5K0hLdk43cVNYa1ZY?=
 =?utf-8?B?K2NTTWt3Q1NvVVdaajlHa1cvZ3BRTTJ0RjdjNVRIRkwwL3ZHN3E2MG9Pc2t5?=
 =?utf-8?B?ZHI4VC9OcDk2bjlGYUluYWlFT2V3QlJJVFJXc0YrbVBlUzY3Y05Pc0ZRM3hi?=
 =?utf-8?B?c0hQR29GNTJjZ3Y5V3BGSEJsMjBiYy9Wall6TUJyVTU4d3BXNFAyTGFJRy9h?=
 =?utf-8?B?MGFSNUlOUDJOMnZzM3RnMDVyY2d1dFJFNk41c21OZ0N1MFh3UzBwNE92N0k1?=
 =?utf-8?B?WVhpci9VaDBDRHRmNEJuWGtRT05mSU80R0luanBQNVVvSUc0L1dNak1aaGhu?=
 =?utf-8?B?RlQxZGN1ZGIyVU9JL1lUczJOODM0RHZXaFh3RkNtUEhZWEVORHR6MGIxcWFF?=
 =?utf-8?B?Y1VlM2tudXpMSFdDUVd5RkV2anVGdTVhZzhTN2ZjUVg5KzJHRWRUM2dCSHhr?=
 =?utf-8?B?UUVGUzFTZkFrOVF2YjZUNzdYc0NMRlVTVG1Zeklla3BoeFNoUkRkKzdQaCtI?=
 =?utf-8?B?ajlWSlFKL1gvS2pYNEJpdEpCcFdrTGdYdzJxZFQrMDNORmJHUnR1RzJhQUNV?=
 =?utf-8?B?ZmVySjFSZ0dBbHZPUlJjczhTZUo3VVp3TnpRaU9iZUdsb2hoTWlrRzhMZ1du?=
 =?utf-8?B?VmpVNXpOSnRuLzhMMmt0R1RYTWNMY0dncTcyYWNLMFkzVm9hbUs2MFMvV0Zo?=
 =?utf-8?B?VEwvQlI3Q3YxYVg1SW1peEVrbE01cTVEV3JzMVpMeExRbnpSOW5EYUF0Uk5U?=
 =?utf-8?B?bC9OYWZyajRYZTArQnFoU3FoMnZ0ZjFmUkM0VE5XS0EwYWpTcUU5bFRzc0V5?=
 =?utf-8?B?WHo3RStZZ0k3TmxUSmJYTUxSd3RHWUZpRzk4QTZ1dUVBOHQxeWFFRUxyWXI4?=
 =?utf-8?B?SVh4bUozcFpocWd2ak94RHpFQUNxTjdqVE9Sa0lTbWs3cmxEZkZNYWxSOGNz?=
 =?utf-8?B?NUlKZUNyZ2k3enJwYTRIclRMMVIvc0lxRzFEWWxZUFhLOFpjM3BZMHlKR2Nh?=
 =?utf-8?B?Y3BMTHdqZysvZVpSbVJrK3ljTmJEY3ZCRkpIUkRZTVU0ekxuUXgwb3grSTVR?=
 =?utf-8?B?cG1ka2l2WHZJWVE4Lzc1ZCsxTEI0YjRTUitVbUFZa2h4dzVxc1R6VEVJcGpy?=
 =?utf-8?B?UnBzS29acVNqNi93UzFxOE9WeTE2emszMDBVU1lWWmtFZVVTTngycGlCa2VZ?=
 =?utf-8?B?a21mR0ptRHdaUU5nOVB6VTRXd3RBSGt4Tlh5YU1Ub045cURsQmFYNTlCVHFk?=
 =?utf-8?B?Tjh3cXFzSHNkdDVWTFpabUNaOVJDaGdGZk1wVHVKN2VFc0N0V0pXclBjMnFm?=
 =?utf-8?B?M1RscEh5M29BVDI2MDAvdDZrNE5KS0lwNXJ6ZHdTM2NnNERPaS9DYTFteGY5?=
 =?utf-8?B?bGxSQWo1ekpTbGxBMlBtZlFiZ2FLd3BBSldBdGtwVDVxQXBMb0gyYjdmekh4?=
 =?utf-8?B?Z3R3Uyt6bGphdnlRN3VscWNYc3dDNVBReWlGNXE1ZXdNRHVNM2ZBOERGNkJP?=
 =?utf-8?B?MGRjajNFU1FZZnhnczY2N3VwU05QL0ZXWTlzaHBicWwwZklxSE9QRHJ4ZVh0?=
 =?utf-8?B?UWd6V3pxV2JFRXljK1A1RG52YWdtemJzUHdNTTFMUEh5RWVQUFA2SmlJN3V1?=
 =?utf-8?B?Zk9wMDBtTW1uY2J2WkViSndkdUdWMll2VHMrYzYxU1ZGWHo1OWZQZUlLL01x?=
 =?utf-8?B?em00VklteEpNVXA2MWExRkZ3dm1mWnVEL0tPYzVENmF2ZDhLNTM3T2tzQlZn?=
 =?utf-8?B?TkhXcXowRjc5REZKNVZ5WGFkaWE5ZS9IZFhlZVhJUUd4d1hiNHpvVmo4bVpp?=
 =?utf-8?B?YnFmeDF1RlRCWlBsenBDK0k1RTYzTUl2RUF2OEVxWUpjSlZjVWo3NDdROTYz?=
 =?utf-8?B?R3FlOUFUM1pmM3ZPbzl1WjRDOTcreU5TNWNBZ1NlYS8xOUhZVTZZOFlybS84?=
 =?utf-8?B?bFZuZFM4b09XWnNPdDhNVHE4dHNlTUp1dVRpM3NURXlZYlE2bjZGSFZNbmkv?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95B275CB89B43C4FB9F2D90668D385B8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe5aff2-c885-4a9d-e967-08de0d49a705
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 06:51:51.9116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D2Nr6NOto491W2Sp+lK9ckQm05qKsPo7eOusuFJYMEmAj0JN/DPZ9WxE+hjBiAlohoee9eXlJrqaNRY79+4YkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYPPR03MB9367

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDE3OjEwICswMjAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IFRoZSBNZWRpYVRlayBNVDgxOTYgU29DIGluY2x1ZGVzIGFuIE0tUEhZIGNvbXBhdGli
bGUgd2l0aCB0aGUgYWxyZWFkeQ0KPiBleGlzdGluZyBtdDgxODMgYmluZGluZy4NCj4gDQo+IEhv
d2V2ZXIsIG9uZSBvbWlzc2lvbiBmcm9tIHRoZSBvcmlnaW5hbCBiaW5kaW5nIHdhcyB0aGF0IGFs
bCBvZiB0aGVzZQ0KPiB2YXJpYW50cyBtYXkgaGF2ZSBhbiBvcHRpb25hbCByZXNldC4NCj4gDQo+
IEFkZCB0aGUgbmV3IGNvbXBhdGlibGUsIGFuZCBhbHNvIHRoZSByZXNldHMgcHJvcGVydHksIHdp
dGggYW4NCj4gZXhhbXBsZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pY29sYXMgRnJhdHRhcm9s
aSA8bmljb2xhcy5mcmF0dGFyb2xpQGNvbGxhYm9yYS5jb20+DQoNClJldmlld2VkLWJ5OiBQZXRl
ciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
