Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02829B78D;
	Wed,  1 Jul 2026 06:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782886388; cv=fail; b=ac+h8gK+z7MBZzUkgYnrc6v2nWwX5PKBO4kFBnLFAHCD0owy05t1iHKj0PhE12IPVxUaetC24658KbmdO356MpRhydWqrySEkZq3sQY63HvJPkvaBhqO9lH2/1FxHHYkEM9ko4Jm7hPzt6SXlkx1O2lP+Flrt/19+yWB1WfT+CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782886388; c=relaxed/simple;
	bh=UH/X6eV/UE1+n7SlGfbdlYH5cat0ydCibkcnUmWiXSw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IkZ5l3mrh96lpJh+CAszOQhqJZD/Dn6jDhm7/Ygmb+8pGvWrkd25yjLpdzOLlOliyd0w4dhPSoY1iu5oPkenFpZkFtfcYXrTx/OrsXpiVS4QOBpGHvSR1Oz+mYUys7EsKBjZn4llmmC2mxPOwL62KfX82/+5J/p9yWsiwfJ6p3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PBNiXES+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=GDJQkyKo; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PBNiXES+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="GDJQkyKo"
X-UUID: e5428cde751311f18dc8c9802ae25ab1-20260701
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=UH/X6eV/UE1+n7SlGfbdlYH5cat0ydCibkcnUmWiXSw=;
	b=PBNiXES+7xHDlM6el3CsYegxE8Fx9NeMbcZ+XBbEGGUv7JWQ3FwdLugBwQ7nc7ZAw10mc15Ayw8WP9hPS0hHELN9I5aFzZg2VpeAHiv9W13Rh3v8AfUMyygho7lSNtuYQemC+mGe/WN7smhoiZaMR77ne+nmghRY5b+ZmNIqq38=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:0a7c81e6-cf06-4d3a-ac2e-3a9a3f1e3905,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:49852904-3795-4a90-800e-68e9393a343e,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e5428cde751311f18dc8c9802ae25ab1-20260701
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 75022456; Wed, 01 Jul 2026 14:12:53 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 1 Jul 2026 14:12:52 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 1 Jul 2026 14:12:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OcrdYv/HyKY4hwZar1mHBCnQO5aF1FmsZYkJQAOL/CPdlpEVqYNLzMMu63UzD1moAfaO1dBnOQZyrssBz5QXQykpwPxSbzg0kqrPtDAneCRh9l/zJpzy8SwnuY5WGantlPTmZTcvDj5UjkpGeix+YmtUXdyjinRVUFfZkLiTxrwWuCggSZDs+94hkuhHwM7Y0ZH2huAFO6oiDZ/xW+w86WY73sURkr3UYi+8zi4KUD9AoJ7oM+kkptFpvLS8RyVgk5/pFv8SewdBIEp+sQfMUM1YWzeFCKJJ0wQjWM9qy8Gu01WZKLliS2poWq+RFmYgQdFYp3QqXtXsqzcKnKnR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UH/X6eV/UE1+n7SlGfbdlYH5cat0ydCibkcnUmWiXSw=;
 b=ximg9ycw8vG805qFde/63Qs5fxCphxM6B4ZttpjpP9EpyNv0xkprm5KfACK6JozafsANs31O844+le/Xd3xgYg1cTIMFL8B/QufY6O5oLoaeMgVC3K/dL/aWQZOHgwfeu8B6uZrBaY2umXaLqXk5NbGwSTY3m9LxS2V/wZJkF0f4F34P0Ydy3yvIVtvy6DuHXlOU9SgCIyuRx1JxkaxFVEsxdK7Z3d8dgxKhpTclV397AialT1/5OS3FcXwcQswSjKGl1UDcHc1v67GwscumFmvTWNEv6G/Fe/ZDmbN7PhYbuyNN6LZnKu6vlGdmNLOl0JSyrHOQXAnZLIOLWTyufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UH/X6eV/UE1+n7SlGfbdlYH5cat0ydCibkcnUmWiXSw=;
 b=GDJQkyKo5Ry6KVp501+80IVSZ6AZRIdklHnyqOiDlVnZirPeccQVochwy2rEeVVJHE0PaVIOP665yQ+m/aI1tCCXLL0ZoxQb2xQkP1kM3FuWpldH3rnKYxnX1VHb8UST3ADpD7flgto1HXgAeVCB/7o6IZZnHzM74+s4b+4udBc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8275.apcprd03.prod.outlook.com (2603:1096:101:18e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 06:12:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 06:12:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>
CC: "mhiramat@kernel.org" <mhiramat@kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [PATCH] ufs: core: tracing: Do not dereference pointers in
 TP_printk()
Thread-Topic: [PATCH] ufs: core: tracing: Do not dereference pointers in
 TP_printk()
Thread-Index: AQHdCOOB1PlUzwfmO0Sjm170XumZsLZYL30A
Date: Wed, 1 Jul 2026 06:12:47 +0000
Message-ID: <8976eea943032ff1d30d37b9a4c89d151e689e04.camel@mediatek.com>
References: <20260630185412.283c26c5@gandalf.local.home>
In-Reply-To: <20260630185412.283c26c5@gandalf.local.home>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8275:EE_
x-ms-office365-filtering-correlation-id: 3b505c13-a595-4312-5746-08ded737c595
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|6133799003|3023799007|56012099006|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: dGlLm9dagpSir7NTQ2YBW2cTto1K3gazp5FGgL8xsM83tS1gDK9fhhXTZfpFwKJ/KktfFIakdpmMNcJR6EBfc396ifRHWWeJCMyiDo+tCcWowI3Z+k7RDuCClwYEU0uSxhp2vcR4AVtE+iemebU1hvY+jM83sLfF4Vovnb8Mv8nzRUUZgjLZPBZZ2Lidj5OXjaSejinTNJwxjY3h4mBEikrg2s5RjeBuqbKZdHHwAIU2cxRMv+zG2zFw9JRY+wPmr33h+exsVqdXmkoS0udwQnbXyXpF9tPeRgi+ig+RAk6YG52zW2NLbjhXvOCacpj9q4CASRqqFH6vG9uEhgrFEtEo5gCCekTDY9cJTju/qqNWu44/73AdUpVU1Dhuofs+HmB7EdK0VmQzR+K/v+xBF5PeG8PivhHwpjVvIPSFOn0m8CSJFWjRDwkg5oLibeoY1snJWebPVKU/zbcdDyXjJ623Zpusy0ddr6gfDU/vNuSRGA0+EzqvW8766QdrqC+3wUs+B/nm1RwPOMCaIVAedInUSBYf4uG5N2+wcoJN8AP7laB4Q5FVuzTF40Ot4hlbDrS0Jzlcj0mAzXY7e+ORf5m+zREx4JxWJHErObiBw3Pis1SVvjrryocg/9OsZjo1/Q9zUMWuRYRMLOFLl51E1RfRiVDdm3H7Ory8ZgIUrthOcHzzoWGmZi2Is3GvPXlyguHM5QYvB36W0WFe76uitieeZuUJmwkyBu97u2OnWUw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(6133799003)(3023799007)(56012099006)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NXZSWncwQkN5OFVxdExVVEgzQWhRVUtWRU56VzRNam5rK012VUtkSTJqdEhD?=
 =?utf-8?B?c0FuVXBIVENtbDZteU5hcUVJWU9mL2NXMUVwWTYySzYxRUtFaU4yM2NLeUxl?=
 =?utf-8?B?SndLWXRSdTFxenBYNG0vZ1lFMTNyYzMxb2owQU9DWEVCaDBCZEMwaWE2RnRr?=
 =?utf-8?B?bWphdGdZaUpBZGg3K0t2eVIyVzl3a2xHRUFQcG9McVpsRkVEZyt3R2dIQmJP?=
 =?utf-8?B?MkdodG0yK09qamdEbGxjMzd4dHRYb0RWRHE5OVdXZ0NRckNpLzlQa1lNZ1Jl?=
 =?utf-8?B?aXd3d0pnVXNPR2RxNkd5REtNUHJuM1VLZWtYREJTQkRNVndwbTlkSjFhbHhJ?=
 =?utf-8?B?SlRFZEVkdXM1R1NJMFRTeGlHUWwzQmVWS2sxUGNiN25yY051VlRxUWxpUnpk?=
 =?utf-8?B?YWw3RDdaRzBMOHVYQjRobXhobnZtc3NMdE9HN3JNS3VxVVIvRmhQd3o3NUd5?=
 =?utf-8?B?RkF0dzNvMC9yekwzM09lMGxIZ3B6Yk5OQ0JNdkhzUjZDT1RuWWxwRGhJOWZh?=
 =?utf-8?B?TzZHNUxheTdjb2NNd3RiT01hT3FnSHBGZkU2aG1ETWxObkNoYWxwblB2NGRa?=
 =?utf-8?B?bm1GbnZYejFyZ09VSWFPN0p4ZGVSQ2MzN2RCZHA3ZG9Vd0JDd05sbVdweS9p?=
 =?utf-8?B?SWcwMjllMmQ3dG40Q2pQOXhkMVVjdHlxNUdjMnVmV1RwMUhoNkp6SDY4MTF5?=
 =?utf-8?B?a2o4YU1FY3RRZzZGVTN6RncwTi9neUV2WEhxSlpxOUgvbjkvMWNPemNEWXgy?=
 =?utf-8?B?M3JlY2Nob0R5QlRnVDZuRFE0a1NVTUNHRW9paDdrKzRXQ0lUMUoyWGxnTUYv?=
 =?utf-8?B?V1h6MHQ0WXdRMUxzanNSMmhZblJlbjhQb0MwN2d3dnY1SHVYbUsya1hjdE13?=
 =?utf-8?B?R3ZkZElhV0hvQ3ZlemdNTzRZQWxSbHMxTU5hZVNCdy92UTdEcE90VXZHWXZn?=
 =?utf-8?B?ZUowdlA5cEdqUjlJdkxPcExZTkxkVGNvRzk4VW9ESUpBZkgwRlN0ZTNsQVhk?=
 =?utf-8?B?N3dzcFJRTzhtSi9SMDlVY1lHSzU5MWtIN3hNQUQ0K3JMNEtoYnUrMWpTV0tz?=
 =?utf-8?B?d2hNRWkyQXFtbE81ZzMvWVVNaFF2M0dodzBMTVVKZGxqRkE5eEluR1NXcExh?=
 =?utf-8?B?cG8yZzVTanM4L2JVOGJMeVkveTc4OVNSM1JrQUpNYVBseVFXK2JEZUcyS0xj?=
 =?utf-8?B?dWNKZ2psc2E1cmxMdVl3dVVkQkJ1T09HUHJMZXlnczE5Vy81Sm5ZaXorWk0w?=
 =?utf-8?B?K05XeTUyVDFjTy9FdCtGaVBncmkwZFo3SWV3V0IrUTNVL05jZzlBam5CT0cv?=
 =?utf-8?B?aVFPTnlFMzVoYjF0YktsWkVPbStTRldILzhXcWVjUVUwd1lvZ3g3TUd4L3Nz?=
 =?utf-8?B?L0toc3NzelZNQTZrVFNpVDZxNEtXMzB0aTM4NXY4b0dtZ2FCRnFISjQyQlBB?=
 =?utf-8?B?TnFXbEoxYWZGT3RhVCtXUzF3U1BQbGtNVkhHektDYnJzaTRScHVYS3BPUGtq?=
 =?utf-8?B?Mk9FT1EwTEtWNFB2OVdvd3NBYy9wQXJaZHRRY1VPNW02V2lyNUEzd0d2ZmVK?=
 =?utf-8?B?QjRLQ0t4T3c0QTl1dlFlTkI2Ym91STNqWE1sRTZNNE02R0JJOHZyUDJKK1hy?=
 =?utf-8?B?ZTBIa2ZnUW9mdUltZjFNS3hERy8xZVJwejJpeEdoSXJyN2pKRy9ra3Zka1NZ?=
 =?utf-8?B?K2dQSHppZ2dUMGN6YzVyTThzRU0vN0phTS9pbnFtSjN1bnkvM0tnSEV4bXlP?=
 =?utf-8?B?QmR0eUhhaCs1dExOL2RMSWRSTG1EZ1ZUNnlUQzhiOVRMcTUrRmErbElKdnpa?=
 =?utf-8?B?b2RHcFg1bWFwM2QzL0sxbS82ZUlhaUUrV1A2bWNzQ2gzYy8rRUVTaUJOYkVM?=
 =?utf-8?B?eGY2Uys4Z2tDK2dlUGtkWmtweTMrdjJWT2hQL1ozQXdTTEQ5WUpGWWJXbnpM?=
 =?utf-8?B?SSt4dFVQdmdiT3NEWk14VEkzL3p1VkZLQXpmenlMN0NNU2RjYWhCYjYveEd6?=
 =?utf-8?B?VmFTa09GeXlSZHNSajlpQ3RKUWRqYTRnM1g1Z2NyWmtQcUMwT3RQZTRkd21s?=
 =?utf-8?B?ZlZLYlZNdFpmd1pUd1JZbTNjWUZSc2dEanN5ZXFneTI5eHM1QWhiUy9QZElt?=
 =?utf-8?B?aWZQdVg0SUtQL2RpdUxzYTV6VmZzSWNsQlZtQnUvbndWR2FieGZKcFQwcUlK?=
 =?utf-8?B?QzRxdlRHclZCRnBqZU9jNGlwdzdSRmd5cW5sSGltdUhoQSs1M1ovaGZmbGV2?=
 =?utf-8?B?ejdvRWhCWDV3MDU5dkxVVlZ0T1FZT0ZqL0IrejdIVFJmTW1SdHNFK1V2NTlL?=
 =?utf-8?B?VUgzbkhaVVN3OTUrVXkwUFRnZ0tzWFA1ZUthRWF4UVEyb3ZXZERBZVpmVy8v?=
 =?utf-8?Q?PViYZFCo5Wb/HrzY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9125D837972D9946B3A2DEE86DDBB0E8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: X0chh9tCFkfPnvf8ntpblNTYKP4BIvN2k44TU4yq0XNSnCLtsXTDM15rL+3UpPOjkSeJPjkk4sFVkBGNaeBJBAbhAf6nBkvn9WW83vNj+v9JNa7cY7NWjcev0LTSUyPbvd07TsSyjM193TETGdGsGDdXE0YEqQlYRxLwmtvyPfa512t3EzecvZ6jkfuM2LUlF5D9iMR+R9ebpiiKM/HHhKF9CKuR1NDBnvxf2gv4RA1QOGKcG4nMEyz1EWPFMMLxkGzfD5Mi3PbhEdWfkGBKVF+0bvZTMEq2jQ657MqumFDYsPWiKMZzdgLQEgx7fhdvbn5Z823tGLO0Qn8aXiLobw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b505c13-a595-4312-5746-08ded737c595
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2026 06:12:47.0637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RpesLCQSlOgduVz/bw3eVc2D/EjtQeiRHCEAyNRfgw3qnFa9rbN/74PVK3oO7W6OgOmjtqn9u7dNVbugLVAEgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8275
X-MTK: N

T24gVHVlLCAyMDI2LTA2LTMwIGF0IDE4OjU0IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gRnJvbTogU3RldmVuIFJvc3RlZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+IA0KPiBUaGUg
dHJhY2UgZXZlbnRzIGluIGRyaXZlcnMvdWZzL2NvcmUvdWZzX3RyYWNlLmggd2VyZSBjb252ZXJ0
ZWQgdG8NCj4gdGFrZSBhDQo+IHBvaW50ZXIgdG8gdGhlIGhiYSBzdHJ1Y3R1cmUgYXMgYW4gYXJn
dW1lbnQgZm9yIHRoZSB0cmFjZXBvaW50IGFuZA0KPiB0aGVuIGluDQo+IFRQX3ByaW50aygpIHRo
ZSBwcmludGluZyBvZiB0aGUgZGV2X25hbWUgZnJvbSB0aGUgcmluZyBidWZmZXIgd2FzDQo+IGNv
bnZlcnRlZCB0byB1c2luZyB0aGUgZGV2IGRlcmVmZXJlbmNlZCBwb2ludGVyIGZyb20gdGhlIGhi
YSBzYXZlZA0KPiBwb2ludGVyLg0KPiANCj4gVGhpcyBpcyBub3QgYWxsb3dlZCBhcyB0aGUgVFBf
cHJpbnRrKCkgaXMgZXhlY3V0ZWQgYXQgdGhlIHRpbWUgdGhlDQo+IHRyYWNlDQo+IGV2ZW50IGlz
IHJlYWQgZnJvbSAvc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlIGZpbGUuIFRoYXQgY2FuIGhhcHBl
bg0KPiBsaXRlcmFsbHksIHNlY29uZHMsIG1pbnV0ZXMsIGhvdXJzLCB3ZWVrcywgZGF5cywgb3Ig
ZXZlbiBtb250aHMNCj4gbGF0ZXIhDQo+IFRoZXJlIGlzIG5vIGd1YXJhbnRlZSB0aGF0IHRoZSBo
YmEgcG9pbnRlciB3aWxsIHN0aWxsIGV4aXN0IGJ5IHRoZQ0KPiB0aW1lIGl0DQo+IGlzIGRlcmVm
ZXJlbmNlZCB3aGVuIHRoZSAidHJhY2UiIGZpbGUgaXMgcmVhZC4NCj4gDQo+IEluc3RlYWQsIHNh
dmUgdGhlIGRldmljZSBuYW1lIGZyb20gdGhlIGhiYSBwb2ludGVyIGF0IHRoZSB0aW1lIHRoZQ0K
PiB0cmFjZXBvaW50IGlzIGNhbGxlZCBhbmQgcGxhY2UgaXQgaW50byB0aGUgcmluZyBidWZmZXIg
ZXZlbnQuIFRoZW4NCj4gdGhlDQo+IFRQX3ByaW50aygpIGNhbiByZWFkIHRoZSBuYW1lIGRpcmVj
dGx5IGZyb20gdGhlIHJpbmcgYnVmZmVyIGFuZA0KPiByZW1vdmUgdGhlDQo+IHBvc3NpYmlsaXR5
IHRoYXQgaXQgd2lsbCByZWFkIGEgZnJlZWQgcG9pbnRlciBhbmQgY3Jhc2ggdGhlIGtlcm5lbC4N
Cj4gDQo+IFRoaXMgd2FzIGRldGVjdGVkIHdoZW4gdGVzdGluZyB0aGUgdHJhY2UgZXZlbnQgY29k
ZSB0aGF0IGxvb2tzIGZvcg0KPiBUUF9wcmludGsoKSBwYXJhbWV0ZXJzIGRvaW5nIGlsbGVnYWwg
ZGVyZmVyZW5jZXNbMV0NCj4gDQo+IFsxXQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MjAyNjA2MzAxODQ4MzYuNzRkNDc3YjZAZ2FuZGFsZi5sb2NhbC5ob21lLw0KPiANCj4gQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gRml4ZXM6IDU4M2U1MThlNzEwMDMgKCJzY3NpOiB1ZnM6
IGNvcmU6IEFkZCBoYmEgcGFyYW1ldGVyIHRvIHRyYWNlDQo+IGV2ZW50cyIpDQo+IFNpZ25lZC1v
ZmYtYnk6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPg0KDQpSZXZpZXdlZC1i
eTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
