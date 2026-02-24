Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2964E25A2C9;
	Tue, 24 Feb 2026 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936748; cv=fail; b=n60BJswx6A3JXT+GLYckObOegYt39ec0gjTpRIVPigsfk2eHOtPjyWKG/L777YSV7Is8DyrGwQoghea6klNBn5ZnWGf+jlod7Vvzw+4DkGQtnyut0YUwZzwpriA7/vv6Lw6Om0BpGAXTwB3nN8xpUN/F+CgK0TTPHkXogdMEH+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936748; c=relaxed/simple;
	bh=SzME2IHv7iPP81WBmzBmUxDtdqYBftPtHm0jE/rpNRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YjmGjXKk4qGXfHkQRVG5k2S1i2JxZ/DxG7zwjiI3zsD07R1TCLBz1bxqbq992ToOt27AudWRkjlAF837OP28Q2Sjw75CH5C9+yyTcZ21Y/yytRKsG3Np+MMKMxyQ5zxAaQUbLbrjtPjyUpEqmgbPCgCNNW+bGHmot/Xz1YHvmcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PeEkPkTH; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IcHMwQVd; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PeEkPkTH";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IcHMwQVd"
X-UUID: c8c04690117d11f1b7fc4fdb8733b2bc-20260224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=SzME2IHv7iPP81WBmzBmUxDtdqYBftPtHm0jE/rpNRM=;
	b=PeEkPkTH4PGtS4kLn/J+J78o9EAGVCYjTBoCTVO15gJ5Olo0nZplHZijb5qOz4NmZfafsPdkwd0uzDcGw+a+ZgFYyBuR7rmeYEflBSQLhNG+4Bnj/nXaU6Pqmei+uYLcVv5Mi7fwF0V4xsBpxY1nNsjU6ISO6udYHETJS35GcXA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:abce3527-faf2-4c78-afb3-eb5ac57cd006,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:2f718e5b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c8c04690117d11f1b7fc4fdb8733b2bc-20260224
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1525761191; Tue, 24 Feb 2026 20:38:56 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 24 Feb 2026 20:38:54 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 24 Feb 2026 20:38:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mWOQEcwSDsLN3FiraC8rjUqFCoqpIwvL6e+i2gFe/Pzv3Q0yuYTThfC2ewWnAbgch3rkVG4bTWZW1D0rJigqSNyKfAJ2UjI8Rlha/qqj5AlHiflZ0DmHtolVAvByrw8TV//giE9wamUc7VnmK3IZm4lFzPr2Y7d6XuFQAs2VgnRQK+i1Z6eSlC87cSmrfiANSXz3lfMqZ72AITWq0zOd4CevpD9mpOnDw0dc9OVI3XcwJdabe+/EMteV9UpASgKs3rdnknIIii/b411XVX+ex0qkCVGoe0ZhxWyXWo4UzwzqH7qC3OmNEs82bf0DUhBm3vcw5fD2Z1PTH26qvtxS+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzME2IHv7iPP81WBmzBmUxDtdqYBftPtHm0jE/rpNRM=;
 b=s983RK7kemGhUNwFpFqa6JFoyFMvbdCHpYQrFiCtHbMdxmpwiHfV/1AHy4XhXxGIsrnILJxTuvRFefsPtM+rjhkUJ5kQcYGK2heexAOn7ljFX0uIJOmQIICR12KSIRBvajEBl6PmtFSmWaPeHFF0iHO4vSXgmjjzlU4fLbgnFTzGb1UtlUKYPWqdGRoYMWWQFiWLh9t7jKoCQG5M7QGW21AbRVJ94S010DAA1KuRH7X1uPbBKncJC2Zfruwr7KPi2kL3GStoeUNX9NQxWPk4y6ckH7n0rhGQeYbkXpbVV01d+gT1fzobHlWBL9RmBjMbavHtbHXTctpjjRqXYGiBAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzME2IHv7iPP81WBmzBmUxDtdqYBftPtHm0jE/rpNRM=;
 b=IcHMwQVdyvJxfViqBXnLQeLFbZO166MFMtoPG6f8mb6/hyBjvm1fM3hm077d889RIJ/ug2p1i7nsrLGP/F10bOoQcLc/OCB/TZqInmUV6JygoPXNacOqT/fkOWLFy9YsalJwvdyVMf5+dJSYTEjPCoC3Vp1XZHgCdWliSAduJy4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8625.apcprd03.prod.outlook.com (2603:1096:405:83::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 12:38:50 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 12:38:50 +0000
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
Subject: Re: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Topic: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Thread-Index: AQHcn0nPvDFB0gw0KE2BmOLle5gC1LWR1niA
Date: Tue, 24 Feb 2026 12:38:50 +0000
Message-ID: <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8625:EE_
x-ms-office365-filtering-correlation-id: 6d228289-52e9-4a26-d16c-08de73a1a9a3
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NDVjTFhKZHFGZ3RRQUtBT0tGbC9vbzhlajd6SjlFR0JON1pvcWlOQU9UWDRv?=
 =?utf-8?B?UithRUVFejh2ckpqdUh2Mi84aHhSY0FtOUZCZjRHV0VzSmJxQUJpWW9KUE5a?=
 =?utf-8?B?NzhkdGl3ZG9rZ1gzRzdaYXo0RHpoYjlrZURISUxCZStKejJTZFlqeUVPZEI3?=
 =?utf-8?B?Mm9mWkxQSlc5STJ0azczKzZoZFNXZy95dHVuM2hGNk5WejJLM3U0WnN3Yzdj?=
 =?utf-8?B?amZrb1ptTnNmY2JyenRZUlpFaDM5eFJ1T3c3ZHpFRUtvcDF3cTd5M215ZjFW?=
 =?utf-8?B?bnBFKytBSG5qNGhaenJQc3NrclY4TlpyUDR3alh3N0tQanA1RC9rMytUODVZ?=
 =?utf-8?B?YTJaQU9jUi95dkhjL1pnWk45YWxmMWoxbGR0WXFxZmd4VWJhaENUMHRlNitJ?=
 =?utf-8?B?d3hTMTFvVWZZbUtUYlRuUitYQXk5VEF2c2Yrc0NiWlduRVhEMHBYckJGdy9X?=
 =?utf-8?B?UE84WVhRUWwySWJuZmhiMzBWa2hNU2tITE9MSmxFWCttNmFMVTNwYXVWalli?=
 =?utf-8?B?RllUaTd5RXJIR25RMlJ4eEoyUEt0VzBlY2I4VU0ra0NQVUlQVmJWU0MwV0p1?=
 =?utf-8?B?MUxDalhzQWVlVzBRb1NZQTVYZmN0RVBCaEk2RkhaMjBlYzhvSTZZellsQ202?=
 =?utf-8?B?Y1Z4RlBGVWJqUWpFRUYxUXNlNUg4UkxETzI0QnBtWGttOW9HMDNKWjhXd0VP?=
 =?utf-8?B?VDB1aEZiQjQxVHUrRWYrdGc0SWpZQUNQM1k2bmdkQkRTdnpCOE9TRlJ0N29w?=
 =?utf-8?B?UEp5R0ZHb1VIMVpTRSthT0VlZmllM0Jmb0RmRUFsdDZlbVN5SXErK0FTVE4x?=
 =?utf-8?B?dWNKMkNiZnc0aGlKRURqMERRdkRXbFJYaXoyZ0ZmcUZ1aWhJZThzRnYvZURN?=
 =?utf-8?B?N1U4VDJTWmVKdnFPWnR5L0NpOUpuYUQ5QWRyZnhxakFpdjZQS2hIYVFCbzF0?=
 =?utf-8?B?a0szNWtwRXJsei91cTQ1Wm1mK3Zwb0NOTitEOE1vMnZaN1pYbUpmM2VpY3lu?=
 =?utf-8?B?QzVRZ2FlZ2Q0dE83dDBMenpBbHhaSTZ6QzFFTTJzOWJlNGQybHBJblZNNmxK?=
 =?utf-8?B?cWVRbUZiVFBWcUJVM2E2akdMa01HanNUNXAzc2VGTHR2WklUT21ZUzZPWklp?=
 =?utf-8?B?RlhlVEl5ZFRHR1lsZVFQVlNycUJIcHVQVmpZTlc4a2JuOVNaV3RscGpaMGk1?=
 =?utf-8?B?K0JkS0FueENuU3NkbjFRdkhPbE53a1RqMnN5cUd5bG5XY0pWTldaekl5NWNU?=
 =?utf-8?B?WkhvZE53c1J2Wm81TThzYm9BSHlpQ3dDMVNYaWxWKzJJVEo4c2JialU0clpo?=
 =?utf-8?B?d0x2ZGF2OWpqRjN3a2ZQbVpOKzV4bG12WUh5Qm9qL1NaM2tlSm9kSVNtMndl?=
 =?utf-8?B?eUVXN1VsUWFlNDdwVUtWMjRvYXJZelNLUG0wdEdQUHE4bHlwTTF3RlordEht?=
 =?utf-8?B?MURnRjlUVEJhSFNJN1pJaFhTUUhqelN6RE5rd05rWWRYZ2o3Sk50cGwzUjJC?=
 =?utf-8?B?MEF0cEFhMXlBMGlDVWdzMjhPVllMTVhWSUNBQ3hLOWxncWZWYlNYT3g0VVB0?=
 =?utf-8?B?Y09BZ3djcDZ5Lzd6a1dISGc2bzBKeUNJeFZxeURzVkFUbjU2YklSUnYvM29S?=
 =?utf-8?B?NTBJaHY0MXRTUkRjVlVYSjdWNE5VMGpxQ0UvL2dsYzVlbmNuNWFSL2IvQU5w?=
 =?utf-8?B?ellWYXU4c0V3bnFWTUc2U09YMkFCRmFpRTAyRjZjdWwxLzM1czJ6dkJZS1o4?=
 =?utf-8?B?RUMzTFpwWUtMTFBmb0pOU0N6MisvM2pzUm9tQTQ5RUF6WlFHbjRoMWRrcS90?=
 =?utf-8?B?emhxUVpQK3NZN05ieFRScG45bUpJSG82VHB3ejlZWmMvOVdXWERjb0ovaXlU?=
 =?utf-8?B?WUhmVFh4NWhvd0lGclZaU0NhSnYvN3N6KzU2SlhhYko3ZG5Td1pyTHBGUDBL?=
 =?utf-8?B?U1YyZTNXRjFvZEpoRERST01EcXlHYk83MjRwbXJYWkxBZWNKTmttb3Z6eU1W?=
 =?utf-8?B?MVVCM0RKc3E2M01tSnRxY1htNUFKYTRjZHhNR2plZklleDRJMDA1b3BwYTlr?=
 =?utf-8?B?TjZyTWpmWkN6M2ROUWg5M0dTdEZOLzJPd2dRRkh6ZktZLzNwd0VkMEo0aGZ1?=
 =?utf-8?B?KzYzNE1IRUMxRExiUVZucHQ3VU5XT0NGb0F1ZlJlek5waFhjYUtpRmNFTGVo?=
 =?utf-8?Q?VL6Lxs9b9kxunomeUjBuqGOgAYqWrd0eUwmhCEfDUbok?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTJEM3NxMi9mVS9ZeEVnMU1FdC9GakhtZmRrTnVDRjArLy9pc2tRZ1NyN2cy?=
 =?utf-8?B?WWxhallOZmFLU3R0bnBZVFZQMDkwSzlFcWFCa3hVaVIybGlveElnR1kyTVVV?=
 =?utf-8?B?cWJxWUhiYzdzRXBteGJleSs3RVltdkxmNWlReE5iY25hYTJ1T09RSGZkZC9p?=
 =?utf-8?B?Sy9YTm1BelByeTliMFNya0tZaTFjc2VUUjB4bWV4cThYaCtYMGRyQldhcTVK?=
 =?utf-8?B?QjRHYmxpYURWV0lGMTFXYlFyWXF6cEtaaFJmWXdYcmlFaDhDa1k3eUVOcit6?=
 =?utf-8?B?N2c5U3E2Uk9sMzdPUTl0aWNITndnRDFHU0RRUmtWWlhremU4akg3TnAwaDRQ?=
 =?utf-8?B?SlV4UlRFell6S2JESGk2cUZJb0hDZ0o1M3BOWjJEZW5pYTZBdXdjRG5RTEFN?=
 =?utf-8?B?T0JVVTdVTzFVQkd4WEVzNWNHemJFZFdQMk1jRHVWRERraFJrUDBsQ2NpVlEx?=
 =?utf-8?B?MEwzUXBHRU5XMk1Yek8zcW1HOUxVYlpjLzFzR1k2QTUvSmJacUVoVlp3alRY?=
 =?utf-8?B?LzBmSG9rdDdiNU1FTnlNaDRDTE9PTUlSeW9ScHJEV00xdW9Gd0FpRktLUkVT?=
 =?utf-8?B?T09WeVF1dWl3ZWR2czFidE1EYStmZEJIYjhCcGY2V0R4UDBYV2N0RGdCeDgz?=
 =?utf-8?B?WU81T0IyQVZCY1FyUzljdDE1bTE5aFdFTTZwSHY2UHhGc0NPRFN4SXJ2SzNx?=
 =?utf-8?B?UTNPWmdLTCtYWlZaZTBhdWtZOWE1dFZocnNTMnJ3cEhST3krc2ZhblIrbDVw?=
 =?utf-8?B?K3doMVIwNEtiYVo4OHhNb1d4VGlTM1NjMVhqMFJ6S1F1MzBNQ2s5UkRWejQ5?=
 =?utf-8?B?YTB3bU41bVhORUw0TnlEWDF5VkR0Mkl2LzllcjloSVlBeHZXeTBDS2tzMmxR?=
 =?utf-8?B?QVB5b1VlN3FTUlRSaGNON2ZrY1RaaG0vamxlN0NRWG80YnJTaTNIdlBZak56?=
 =?utf-8?B?ZEl4YUp0YXE0SDZpdlRwMmFaOUNubENXclpKNmhXWmF0ZzRwdHhOVkNUZHBR?=
 =?utf-8?B?R25xR3VmcnpBUisyaGJMekdyTnBqOEFOVmp3elFoOU9yTDd5cXIyN1huR1Rh?=
 =?utf-8?B?bk04TXhuN2REa3dvZWxNN3dxR2Q2R3AvZENIVVBKdlphaVdWOVR0S2lGSXdL?=
 =?utf-8?B?TFpIQkp0WEJqQUkyK0hObStXSGdYdm1hcHJhbzN3VHExcnp6bkExUGZScG95?=
 =?utf-8?B?TVlyTE9XS2swdVVrMjJSMXl5U3lreGVyTzI0c0gzQStpMTNCaFNkL3ZwWnox?=
 =?utf-8?B?VzlpUXd0QktBa01EYjFSWDZ2OGZ1QkU0SFdsWU9nS2owN3dIQWJ6T1pmaEdF?=
 =?utf-8?B?THNwN2dEdVNwMjg2WE9IVU13RElsbFBVUzJyRW4yK0d1a3FUclBxQ0J1a3l0?=
 =?utf-8?B?UXhJRWtJdlFNUVppV1B1aVptU3ZCUmZBWVNvTTFNcVQxZFJZVWNjRk1OTm1H?=
 =?utf-8?B?SEJ0R0ZnUTVxUVc2VnBoY3ZzZXJCNmlqdUlpYWh5RTY5eGl4bTNaQ3lKbnZM?=
 =?utf-8?B?SXRzMmhKeXVYMHRzZkNaaWczTzdOaUtqYXp1SzRsUUN0UkNST3d5SkVyZDNl?=
 =?utf-8?B?SkdRRTJmdU5WOHJ0WXd1dGZla3hKckZPUHhrSExpVTRDZ240QzNscDA5eHZY?=
 =?utf-8?B?YURsT1lETk5OeXBsUDlYMFlaejlaZ1BmOHZmTVo1ckVzK1d5WndDVDdob1Fh?=
 =?utf-8?B?YzVWdDY1NjlPRWxEbmxwckZKZVltQjlGcldKd0xIMnYvUzAvMjVFMHR4Ym1i?=
 =?utf-8?B?T1lWSDVXZ2pUUm1BV1BNZmJodis2ajlPVEYwajUvUEdZbE4rUUZxUHhVVUtP?=
 =?utf-8?B?ekVscEFSRmFpdlJWOHpWS1hFT28ybURKVEtkQ3JhdkkzZGluenBaZ2ZLNTd5?=
 =?utf-8?B?MHJvWjlHQXQ1YVNHZTNrUDNnZVVHbG01Nmt6alQrWlZNdHhWaCtoTG03SmJo?=
 =?utf-8?B?TEZrMnVEY2kwWi9CbFRqNDg5a0FWeUgxNG1CZW5CTEpZZGNBc2s0VktlTTBC?=
 =?utf-8?B?Q2lramY5Q044Qm1pMTVwMHVhWDdPMmViYnU3NkN0K3ZxL3NxT1I1WHFvT2Rx?=
 =?utf-8?B?WFUvK1l4cy96R2JoSTFsWlRwcHFScHBiVUdRcjNvcTJhVUp5RjRTQWZrbkJn?=
 =?utf-8?B?d3NUU1hGQy9qVzlFYzhOWTA1Y3pIeTZ1TGRGaEdsU3lneE84TDN1ZjZUWkRk?=
 =?utf-8?B?Q1pTQWI1U1BrQ2YxWlM4a3d4YjhjRDdiamtyZE5aY2s4ZG8wVGcvNENPeElx?=
 =?utf-8?B?cmFBUU9YeGZQb0hEYkhsNW1DZFVCcExQMUN4ZnNXS3c0SDlkMC93RUZ0TThz?=
 =?utf-8?B?aUFsZGVZQUV3MmlJMkRIby9aUVBFS1ZiT2VBdXB6TWJjU0FmdEFLN3l5aVps?=
 =?utf-8?Q?7SSB0aLmsmgdOm8c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97F3C5DCCFE44B41BB27444841DF319C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: BUK7shQnb3usqczq7bXReBiW3A/ITnSVfeRCxO4KDp1fR2t436db675BE5C8hMfDjYUku9hEyUkjsckS+34qv4Oy+Wb9okjMfRkPer4QI84H59LJT0YgYij9UPzFoV6Q7zCf40chYGwKXnQXeMhkBeVkEcEjtAVxqa/LZJiV/OabDMJTJDRyM2u7aWTcpvz5vhWXyGuOKIkzzVyKL7gFFlcTMw4bTY4UwBjqEDmrrS5/l30nkr83enC6tbhR/Ef33fUQ2ozf4ucc1MU6udDsCVVM4WxhBOw4jNQ+i0VQQLBbX3tc+bCr0xP7PcwcrdZNocKH2S+DUHdA8MyctKFG5A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d228289-52e9-4a26-d16c-08de73a1a9a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 12:38:50.5657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMXPj15+VO7Fd5kDkb8O5R4y7K/70z0cw4XUZDWsv55sLJXJGBqezOH3vH6TVfCnLsuugmxCNS2qNXuhfSL5gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8625
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEBAIC0xMTg4LDggKzExOTAsMjEgQEAgc3RhdGljIGludCB1ZnNfbXRrX2dldF9zdXBw
bGllcyhzdHJ1Y3QNCj4gdWZzX210a19ob3N0ICpob3N0KQ0KPiDCoHsNCj4gwqAJc3RydWN0IGRl
dmljZSAqZGV2ID0gaG9zdC0+aGJhLT5kZXY7DQo+IMKgCWNvbnN0IHN0cnVjdCB1ZnNfbXRrX3Nv
Y19kYXRhICpkYXRhID0NCj4gb2ZfZGV2aWNlX2dldF9tYXRjaF9kYXRhKGRldik7DQo+ICsJaW50
IHJldDsNCj4gKw0KPiArCWlmICghZGF0YSkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlpZiAo
ZGF0YS0+bnVtX3JlZ19uYW1lcykgew0KPiArCQlyZXQgPSBkZXZtX3JlZ3VsYXRvcl9idWxrX2dl
dF9lbmFibGUoZGV2LCBkYXRhLQ0KPiA+bnVtX3JlZ19uYW1lcywNCj4gKwkJCQkJCcKgwqDCoMKg
IGRhdGEtDQo+ID5yZWdfbmFtZXMpOw0KDQpIaSBOaWNvbGFzLA0KDQpJZiB0aGVzZSByZWd1bGF0
b3JzIGFyZSBvbmx5IGFjcXVpcmVkIGFuZCBlbmFibGVkIG9uY2UsDQp3aHkgbm90IGp1c3Qgc2V0
IHJlZ3VsYXRvci1hbHdheXMtb24gaW4gdGhlIGRldmljZSB0cmVlPw0KDQpUaGFua3MNClBldGVy
DQoNCg==
