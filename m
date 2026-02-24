Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA7E39903B;
	Tue, 24 Feb 2026 12:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937002; cv=fail; b=lFdB9R963kWvNNQ3hNgHnXg9ZsbhuYmQwpVfSldHRvDHnExPKbcIIyUbYMkp8zbAp2Z/xG8xvBw1jGYkq+XKJHEFfPz/3KrElOF+McwG4QcWc6VLiC6yCOkq971QeG3WqonHTLY+WGv4tA9+48PqyAJ4QG+ZLPyIoEEVRedZp2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937002; c=relaxed/simple;
	bh=aPHxJzA1xyLEOtRXTvNzEm98bLSjd4LIqgsCMToR6lI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T8nnX6FB3qfJUNHxOlpOGEBJw9FJI5CRF4rD3LYW0qpyDG9UCzpQdyPuiWFGu9NsB8fxutBf3cWQW+ah2c3vuz515Lgf21T0arDAUEE+JLG6O09VFZwfyuj7ufb6rShDgUR/HnKE7HnSjnuG2LpJ5uVau0gglCyNidfesOuOCZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=omcCLpHf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dRMJuQw+; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="omcCLpHf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dRMJuQw+"
X-UUID: 62d80be6117e11f1bcd7499a721e883d-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=aPHxJzA1xyLEOtRXTvNzEm98bLSjd4LIqgsCMToR6lI=;
	b=omcCLpHfhIstKSro2mYG3020kptQJY4UdNahuTKymcuGXxw6G9jMUAVMJL7f2K1N+corWoF+GC935WgUZ+I8JcMEF+CvDgdL2AkTAYBJYl7mIWQ0ncg8Nk8j9HQlz2yKgQuPEpt5ATWfbCu1jdzchT95glUxXRfs75ioOyu7B98=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:b237a92a-c623-4f35-82cb-8acdb58f9ce5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:47778e5b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 62d80be6117e11f1bcd7499a721e883d-20260224
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2105101139; Tue, 24 Feb 2026 20:43:14 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:43:13 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:43:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pCPPexN7WvcNAr2e1wNzKvoPZ0kA+M6FmKfc/0JyseDcZGcxjS7EGhWTxl6+1/C271ZntJ3051CWAcGVtQ/ZhPldW6MgYp69xeKCAG7RYsPcGufyiqkPR9Zaz8s+uLHau622YXJjzXJ6FUquQ0Sl5wz+JRRv7ZO560eKQZ2OWkjNDJewP7IK9c+xzYERW0WQ8P8v2npOh1mzGjgftmRKcHjjmG/TrcOuW1Whd77IUeUccHydwcWsiuZ9KWrxzzjDNlkIqjigZ25TonDbUQQbMP03W7ZESvt0HubBil4d7cOjtsNU9CTjztiWL7A1EG+crP/enDRFOylHdBXdsHv26A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aPHxJzA1xyLEOtRXTvNzEm98bLSjd4LIqgsCMToR6lI=;
 b=KVawfcChHXNXKQhPxABR7bUp2Hnf+kQII0mhrjj/ob38i+PhjCskpL1QMTia6HI/lhMxQ9BRwlOEFABZHUdbM7kEnYroCV51MtUhNLNtdF2VXj4OxxovD91JG+0pPeOnpDxS9VccyXyp+jPlmC4yV4QUJmj4KjAVttFOcEIrpF+TW5A/+CLh+EBM4HQbmb3pCgdf2oNHhTiUknxakN2bqMB0wgOB2mECR7ctKlYs2aEUzlylXmU+d8NZ9RCL4+wALaEb3qmHxK4B1AwO+ZRzzWOM5k37vAe1LEw8+LskKQw06oNsyqzOxOPc+BGIb+NY34DbbIQymGvv/oa1oUOLXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPHxJzA1xyLEOtRXTvNzEm98bLSjd4LIqgsCMToR6lI=;
 b=dRMJuQw+VvKX/Qf4+zrfe//d7VLU+HK1MG94yzA4/N+eFaHrc/32jfTNdDJFphxQyonRu1RtwQW0Vo0j5PMGiTgdvebEGrtaD8dYF0BF9924XMTdo+2WKQ+uwGKUOK+ApHOcIDuxVBvJIP4aNzAD6xlfuoHEB3V40c7+6Myzi5U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:43:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:43:10 +0000
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
Subject: Re: [PATCH v7 14/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Thread-Topic: [PATCH v7 14/23] scsi: ufs: mediatek: Remove
 mediatek,ufs-broken-rtc property
Thread-Index: AQHcn0nVM9FQAWzpsk6CIUfsBt/s8rWR166A
Date: Tue, 24 Feb 2026 12:43:10 +0000
Message-ID: <ee2e18e1a6177c40c5a4b3ed0ff228b9302429b7.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-14-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-14-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: 7610ef88-ea68-4075-4bf6-08de73a24452
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?T0UxaGpsVFJTWHlLUkVVdU1oWWZGS3ZETWRsNzlaTDJ2VWoyZHdrb2RJNkFn?=
 =?utf-8?B?eFo1Znhpb0hFd2pRais0TndRTWRWWkRVcndTK0FoTjNaZEFMd2Z4djJtZk9T?=
 =?utf-8?B?dTNDMlQxOGtMZ3o1a3dqWmlGa2ZiSDl2K0I2YmIvQVJCdjBPK1NJU1ltL0pJ?=
 =?utf-8?B?aTgzR2xxYmIvbnBMOG9ORnpOU0I4NjNkUnNXUUJ4cGczTWhsRkUwL3NsMjdC?=
 =?utf-8?B?dlYwOENveVhkcVpUZDVKSU5XMWFZVi9GWW96U0EvTjc4dnljRDBOK2dPMG16?=
 =?utf-8?B?cWFvQUF2ck84amp0OGdTMWdHN1lwMWdlRjNqZkJvUkpIN2V6Q3oyUGlnQ3hr?=
 =?utf-8?B?Ynp5QzlIRHg4ZmJidlczRSt3TUJMaHRpMXBqL2hoeFVpdGJ3WUhZVTNTZXln?=
 =?utf-8?B?U045S1ZRbUFKYldOZmswT0VNajhWeENtQjAwZW5GL29NQTh1Ly9zazZScG9P?=
 =?utf-8?B?QlM1Y1ptU2EvdjRTaTM5Y1VzYUJ0Zk5hYzdIOHMvTlpsSkJvM3ZwQlF6MzBT?=
 =?utf-8?B?bEhKVVdtbUF5UlNIY3QxRDk0c096MityQmlaWjVqUkEzdHRJZ3F2K3hLSHFu?=
 =?utf-8?B?UllCbW5WdGI2cW0xajJYN3h1am9rU0thUllveDh4YTZ3b0R3a2c1U1lJQXd4?=
 =?utf-8?B?enVFT013eDlCS3Y4bVJqVnZ6QzBhUmlGdkVhTklnWnNTMzdWdkZaS0RzQVEw?=
 =?utf-8?B?TTZmVXRGY3JXUDBtaERJa29Weks2Y1hIVFhtWkthTFRrTkk0TTNiZWpMTkZk?=
 =?utf-8?B?Wm5pek81YU52ejBKT1F5YVViL3ZLR21mZHBhTHYzc2JsUVVzd2k2NkFLMGM4?=
 =?utf-8?B?TmN4Z1phcEtFeGNCamhlK21kWStVVXhKbEZFbTFSZWtGRXI5cWNyWDFFVDEr?=
 =?utf-8?B?Mk1RVG00ZzVmZTJ1Y1ZPNVErekc0SFN2WEJuVzIzQS9MMmtRSnR4QkNFbEVv?=
 =?utf-8?B?c3diTDB0NW9OT1dVM1hNeDYyaTNCeHcwZTd4dGhqdWoyZXlsdTBqT0ZhZnFN?=
 =?utf-8?B?RS9XaDBDeDgxLzAweFZ6VnRJbmdnM3BUSFhhM0QyakhFL3NVYnpVd1BrTXhH?=
 =?utf-8?B?TTdCd2NObjBkUzhwM3Q1SFhDU0RRK0hKUUM0dldrbzN3NUd0Vm14N3ZRQkZY?=
 =?utf-8?B?dStBSU9vd0xpek1CajFmdzArZGdjVDhwY2h3WXdCOW5KNnV5cmFpYXlCcXhC?=
 =?utf-8?B?NFlCRXZoTi9ZQWpvdjljMmV1Yk9kdVJEWnVlbll1SjlMSklpZHZyVEFxQmNR?=
 =?utf-8?B?UHQwNCt2dzQwYmlJWGRwSVJrdWZJbXl5cFdWSk1saElzQTJCbHBwTDl1eERP?=
 =?utf-8?B?VnRnakI1dkpkTVVVVWE3dGFsNEZscDVMUjEyLzd6KytJcXZGNkJOVXg0Mjl3?=
 =?utf-8?B?WjhJU3UzdXdBSWh2c0duOVJtQVQ3MnFFR3IxRHVyVlV4UytLNmdWTDNpY1kr?=
 =?utf-8?B?RUp3UjFpWW5IUFdySUNscDhzQzBIVjMxT1NNT0o3K3BPUTZFa3FFWVQyVWZL?=
 =?utf-8?B?a0RsR2h1VWd1UkhCT3luc21teFR1TU94UngyR1J5YlVoK1hCamt2eDEwdzRl?=
 =?utf-8?B?L1dDVjAwMmQ3c29TZEgvRWZ6aGxkK3UzYUZTZjJxbUFVNGVTT0VRczh6YXUx?=
 =?utf-8?B?WWQyNjBreG9nNUpEcS9JWDk1TTgzbTNHT0dMUld4b2U5MEVlTG50YTJTMUJL?=
 =?utf-8?B?dzRqcE83eGpqUS9ENGNmRThLUFBFV1JPNlZVZytSckk5a3VqRE5xRiswL1Z1?=
 =?utf-8?B?ZzI1VnBUd0JaekFnRjR0NG45dWcxZWE2cm16NW9PaUpTNzBpUDNidnV4UmZk?=
 =?utf-8?B?UldKUUtZL3ZUTEVUN0xoMUFrekdNZk92VitiQXk4TU5hRTlpTHVvYjljQXhx?=
 =?utf-8?B?OFBTUHlueE9FUnhpUzFwLyt6b3BJbE9wRlQ2MEE1MjlMczNmV2lSYThNYlRX?=
 =?utf-8?B?andwSldpL2Q5Ym1vMkxSYmFIbW1JUGNTL3VjcVBrTG9wbExxamNzL01PUjc2?=
 =?utf-8?B?UGJid2tqZ0UrcVhpenZXTjkvSzFJVVJHNTR3aG9oNnF2V1J5b0ZpdTJyVzlH?=
 =?utf-8?B?S3hZa1k2SHRyRUg5ajFIelplTVhUWEpyeEJPTEVBTXp4emNYbjM3TEJJQ01t?=
 =?utf-8?B?RzI2NHI2M3d0R2ZqMnA0STJ0Y1RIbWdmZEpSK0owT2FpTU5uaDRDNkR4cW9q?=
 =?utf-8?Q?lBkYaPjUdMM2VQPXf2GdtymLQYi85yiHB9U+laEPCuVz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0krckRDMTNSekRxMCszNmlPTnVpSGdkbktpRm9MTUxpWTdPTys1S2JnMkt2?=
 =?utf-8?B?WEIxYWRxQlJBbzk1QWo5aWpYNXdiaVRtREwrTkQzUXhMdFJjWjFyR0FQd1Zw?=
 =?utf-8?B?SVhtODBNREh3Vzd6WmpLRTN1aytCNTZlL1NqZU1uM1N5TVNMUWNXSFlNclBz?=
 =?utf-8?B?VENmV0NGZE1DcXFRU1ZBYzB6TU8vRjdpQ3FCdExPS3kzOEhXM2FJdkh2cTNV?=
 =?utf-8?B?Uk5JYmQ2KzVOWmxXSjJ1TG9yNXlnOFdRN2NrL1NIMnRKZkFSbnJFb2xnSCsw?=
 =?utf-8?B?Lys2UStjMEtuR1JrL29HOG1zZXNoQXJmWlRlbVBhbXI5RFJpOW1udGFaZmJ3?=
 =?utf-8?B?VnpqYkRkdDZ4cmtyMUhHTFpKOVV0QTdNM2NVRUpLU3hRSUZmOHVDVGJ3VHpO?=
 =?utf-8?B?L1AxbEZRY2FubnpKYnp0VStoVmdvVUFmREhxZkJLTllnTXdDZ3NyKytvdG9U?=
 =?utf-8?B?Mnk0TW50YlRYVkFEbW5YSlNiM1BnZkxDYklEVjJDN2FZWkdnSGNDUjlMbGtk?=
 =?utf-8?B?L2s5S3BHVy9GSVpWcFdjdEJnaU5EaFRGRmxvaDRFd0dzVUxyMGxzS3pYdU5G?=
 =?utf-8?B?VWNLZG95NTJJWVlJeTFYV2pjZCs3aWZyVmNkcGUxcXRVc0Q3V3hNem92NkRT?=
 =?utf-8?B?WmNLNFBjN1lsOTg5YlFmbmtlZXl1aG5DYlNGOWRvVHorMERHTVlKS2JzT2tB?=
 =?utf-8?B?N3B5U1p3MkhKVzZCSi9tTHJEblhWRWRSS0VWNzlQd05FNzZXekNzTzdiam9F?=
 =?utf-8?B?K3dGYTFneE42clJxZGxpeXJrSGM2UzY2eUJwUXlQVFk2UkVLelVyS1QxTExC?=
 =?utf-8?B?OTFabDF2QXduK0NmNXhXVHA3a1NmeFhkZ2pVTkpxcFMyQ0lLZThNUXV1VjFj?=
 =?utf-8?B?OExJMGxOcU0yb3NDMXhYZHIvWFcyNTQzRVhBVXg1dDlmaFZJK0NvMnBMd2Qr?=
 =?utf-8?B?OGNlQ3VmQ3VuK3VGeXordWZrRlRBeUFDamtPdFg0VSt2aTVBVXlzRUtTM2N6?=
 =?utf-8?B?QnAwSEEwNm1vWU1zODZzLzZPcXVVV1NUTUsvL3QyRGluNHRzLzlqakNNblpE?=
 =?utf-8?B?YXBRaERGaEswMTgxN3d6UlYwaWZ5bGFMNWhXWERzVU1YM1NQQWNVaW1jZDY4?=
 =?utf-8?B?TFZubVdLMDIxcWcwRXZHdDZucTlZTVlMS0ZkT3U1WjlNaURYNUZKcnpQeGpr?=
 =?utf-8?B?bjBKUXU0Q2h4aFRYc1RmQXR0bmxKMnRwUFZjWmNpNFJMbGhaMHVqT1lYZTJS?=
 =?utf-8?B?Q0tXZTNhV3VBVWpaTHowUUxrajREbUZkNU9ES3F4d08rOC9kWnRCN3gyZkVD?=
 =?utf-8?B?aVRmQk1UTFpkL2ovdlh6NndFZ3ZkL3FDTUQxMHozMENoRkNtMEpDdXhWbVZX?=
 =?utf-8?B?UEd1dElWTk9NYkM1RlFJRUhCcXEvbHpsNFNOQXN3cjg2ZDFRVGxES0JZNWpk?=
 =?utf-8?B?NzR1ejVkcE9xbzNBVGVVNjBORTZEMWt5R0VjRUpZbW54Y1FJS29FMGpzZDdX?=
 =?utf-8?B?RDlTaGxweENBTm14S1BuS2tJaWx5WXcyQ0ZJSm55ZUtEMzhRSWVTdlFWanNi?=
 =?utf-8?B?UUZXRStVeFdsT0NpbENOazdNNUtKcXRXV3pLUkpnbk1uQnZVMXcvdlduWCt6?=
 =?utf-8?B?Tm9rWkM0UktvMm9pRHpqeUwrNzA3R1FpejJDV1BrUWlSTURDbEsyVnJ5cytm?=
 =?utf-8?B?dzNYL2JYM2FlSTJwQUNNWEMxR09UTTJJQytzSkNxUCtJVDYrV1FCdjJ5R2gz?=
 =?utf-8?B?Z0d4K25BQU5aUHFvcGFzSWtFZEY0YmtReXlIMWJ4b2tkeFFOODRZcnBUMERW?=
 =?utf-8?B?czkycENDMlVYY2JOb3NMWFBGTlNYTUtad0RQclFrUEp2c1QzMWFFeDBhaVIx?=
 =?utf-8?B?cHArcXlVaTMvVUR3N3gvM1M3UXZFbFUxMG83bHN5QzYyT0ZuUCtMVDZSRHhr?=
 =?utf-8?B?MVNoU01xYzhmRjVOK3NTdVh4Q0dZWG1xa0V3ZDlYVUV4K3BvNjlhVU4zSyt5?=
 =?utf-8?B?WnBzWktFMTl0SzJMcEN0TFVRaVJ5c3hSejg4dVJ2OEhTbEN0UFNBRkdURng0?=
 =?utf-8?B?YlBTQzBCUnhmbEdZYXYvMHZPNnI5WU8vc2lwSGtJNWdDc0pMSmFXbHBzUkJF?=
 =?utf-8?B?YS9TVTV5Nzhqc1A3RkhiSW1WMzgrVVd4am5xVjdNbVpla2QxdDIyUm15eVVL?=
 =?utf-8?B?NUpRbmx5M0dWTVlwbVBYTGE4RzFyZVlTZm1uUEZodzNxcFVCZ2RCTGUyaU1Y?=
 =?utf-8?B?WDlYeERKOG5oVDgvWlJFaGRib3Bqc2FzRnNVWkRPZllqNnQ3QUZXcTNvSHI1?=
 =?utf-8?B?aXNLc3dXNEpuODhXTW54b0luQ1FmSk45dktMOHUzSlZWa0Q3aGFpdVFnOUJF?=
 =?utf-8?Q?EOM8oQVBYLhvumdM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD53D6F5A3F08F4EAF61CE677A992ED0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: a9Q3v3+GK+Xf83xqwZVQGEBhs4bTHdEZpd+n12QVgG3f2CvwjAqA2eh/uLJhZkowMvVkl2qGtpuUGhWc/EAlm4BGOZ97H3ikC1IdwDNisOjHUAzr9e+G5ApSvJMFQP6NHDwNkzrLItqNNHIcS9vMmboa5j2M+7L2TzrU2tsd7XFa6GFDE7qdWEFoEIs9+Z0ch0RatHkf7uZgYNd2JP18DWeCxt+nuqoUfwPWmmgUQl68AjVrizN0bwHIlUIHEK1IbVr/YxIoTe2kg/TlxoOBVzsi4mm49LPPRAxBHy9Wz1tn9tHEnstIjbuitlbn/NOJ7jjAGS5I0WToYbT1HEG45A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7610ef88-ea68-4075-4bf6-08de73a24452
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:43:10.1161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1xA/EFpmy11KUKkUSqDRgHwvDnPyyRxQM6tUKLwaqZnaz77essb6UXNfngg9Xp7m9hz2Bj+DL/2LN6n9jko8CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIGIvZHJp
dmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmMNCj4gaW5kZXggMjMwZTExNTMzZWFjLi40
MjQ1MzM1MzhiOTAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVr
LmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtNjU1LDkg
KzY1NSw2IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfaW5pdF9ob3N0X2NhcHMoc3RydWN0IHVmc19o
YmENCj4gKmhiYSkNCj4gwqAJaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChucCwgIm1lZGlhdGVr
LHVmcy1ydGZmLW10Y21vcyIpKQ0KPiDCoAkJaG9zdC0+Y2FwcyB8PSBVRlNfTVRLX0NBUF9SVEZG
X01UQ01PUzsNCj4gwqANCj4gLQlpZiAob2ZfcHJvcGVydHlfcmVhZF9ib29sKG5wLCAibWVkaWF0
ZWssdWZzLWJyb2tlbi1ydGMiKSkNCj4gLQkJaG9zdC0+Y2FwcyB8PSBVRlNfTVRLX0NBUF9NQ1Ff
QlJPS0VOX1JUQzsNCj4gLQ0KPiDCoAlkZXZfaW5mbyhoYmEtPmRldiwgImNhcHM6IDB4JXgiLCBo
b3N0LT5jYXBzKTsNCj4gwqB9DQo+IMKgDQo+IEBAIC0xMTg1LDggKzExODIsNiBAQCBzdGF0aWMg
aW50IHVmc19tdGtfaW5pdChzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiDCoAloYmEtPnF1aXJrcyB8
PSBVRlNIQ0lfUVVJUktfU0tJUF9NQU5VQUxfV0JfRkxVU0hfQ1RSTDsNCj4gwqANCj4gwqAJaGJh
LT5xdWlya3MgfD0gVUZTSENEX1FVSVJLX01DUV9CUk9LRU5fSU5UUjsNCj4gLQlpZiAoaG9zdC0+
Y2FwcyAmIFVGU19NVEtfQ0FQX01DUV9CUk9LRU5fUlRDKQ0KPiAtCQloYmEtPnF1aXJrcyB8PSBV
RlNIQ0RfUVVJUktfTUNRX0JST0tFTl9SVEM7DQo+IMKgDQoNCk1heWJlIGNoZWNrIHRoZSBoYXJk
d2FyZSB2ZXJzaW9uIChob3N0LT5pcF92ZXIpIA0KYW5kIHNldCBVRlNIQ0RfUVVJUktfTUNRX0JS
T0tFTl9SVEMgaW5zdGVhZCBvZiByZW1vdmluZyBpdD8NCg0KVGhhbmtzDQpQZXRlcg0K
