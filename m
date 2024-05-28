Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93310F9DA;
	Tue, 28 May 2024 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716890557; cv=fail; b=bpFAlR1wR7nhxaG8VjfpcJcOizbsZO/ljruvFx/7byt32sSn7oaq39cS/OvwJpQv+YCRiPcih2UBN/jOChkdY4ioKICKN29uVsPN1khhwPXLNUnF8X3u3jyglJFlgLbQu9PwGxqosHOnt/bOr2fxTdvnRu44XnUp8Jww93at6kQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716890557; c=relaxed/simple;
	bh=75Z5OnJ2Ea2Sv3ZuzJZgOGoGxFi49tVjfiTEk24O/m8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hv/tnEMN8+Bb4SEpZMMGK/0RHZy5zLktuJZBJ1d4sFafyntt4eSCLiUHd5pe+u1k26KD8/Ng/mDiGalj3rA6UK8eaVs3ISPuYzMviOKY53Z7CNb+WGAuPe7cw/h1rQ048DLy0QioJLVyVtRcARnRLTPuompekdRnc8USZNvNGnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Mgx7kksq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Mb6QVtTK; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Mgx7kksq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Mb6QVtTK"
X-UUID: 6431de9a1cd911ef8c37dd7afa272265-20240528
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=75Z5OnJ2Ea2Sv3ZuzJZgOGoGxFi49tVjfiTEk24O/m8=;
	b=Mgx7kksqIjY9+hEI4glSyughtQa/E0Sfz5E7HCJRJpE+RTMBdtYtGWMCuuYqbnWrEnPINyON/3gkW5Tlu4UJD4OIArQssMWJp8Rjr/xNF7P2fsxWSl6/pbpscuU0HhGU6M5PwMmxG/+KxB/S8cxvfWwEa6LMqaFYZ58YZqTmKCM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:713fbc38-0b03-4bfe-a58c-211a279e9069,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:65cbe987-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6431de9a1cd911ef8c37dd7afa272265-20240528
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 715044879; Tue, 28 May 2024 18:02:28 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 28 May 2024 18:02:27 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 28 May 2024 18:02:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pjww1CPuWkjaX2RtBLPbHMz3D08sRyf3igIyiqybuZpWgQuMqaQr0Jt1wcwibH8B2pnkmhkpHuj4hj7VpgUKuM9Hd+vCY1YNgJy8N+pj4zFf9g2b+t+F95rHsHoLOiVLqAgn0tqjWpnSJvGbdh+6PQTNCgbHKgXCkBSTvOVTowbc8CyvCpc3wtqMyG0UYblEKcrq0atS+SQacyN90axcNaJZC1wWLv1kRaRAppPvlnT888XN7c8blZK49RjOI78hN2WxxmNce/JU367ef0CiCA4D54JYefcngs9RVRBun7s1mdF3GvbOLRosebZAOflVDQ0xzVmKmfs7r3lwME+bvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75Z5OnJ2Ea2Sv3ZuzJZgOGoGxFi49tVjfiTEk24O/m8=;
 b=dyYvE2yGAZb75HSVLwK1b0bpK/GLl4rWyGZ43AWkvhPlhkn0HjbCNlBkLP271tt4qFZ6afV9fYChmkFGth5xXo2IaAEwoDTG2l2eXR3z5Nf0VtVVjN3UWX5SV/SXyUev9loJdQy7yVUsGnrDdOYzkAo7zof77td6awcFlDug41pR1uRTV49qs9Z2QC7aaB6OeoNj5/P4cZR4YZ0doWMx7TFclS2MaNmZoXlVrd1RjOD6kaZNOxIhW/hHvgOxsGrAOmi3RMwh2nZDYXItxKdbZGWOXJ+lakBKbRERHI1PvBWoLQS9HTxkBCHDOBd0HhVblffIJaZLlbyRdUvkhWrm/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75Z5OnJ2Ea2Sv3ZuzJZgOGoGxFi49tVjfiTEk24O/m8=;
 b=Mb6QVtTKHG8/SVISnXy/0iG/kKtcIzITQDROM6OIaXeaVBKHJbho4iR38ApjuJNNoo/s8lVQaPLMnXCUuTPPEHV4q+ullJZMZVd7E73CxnSAl2Dl3nROqWoQ2uVhOFgO7i4rzXxlPuaK9xpdLBSNBrLI8OHnEZ1qsWgz4cyQ/AA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6473.apcprd03.prod.outlook.com (2603:1096:400:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.16; Tue, 28 May
 2024 10:02:25 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7633.001; Tue, 28 May 2024
 10:02:24 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] scsi: ufs: Maximum RTT supported by the host
 driver
Thread-Topic: [PATCH v6 2/3] scsi: ufs: Maximum RTT supported by the host
 driver
Thread-Index: AQHar0Ute9Mym84LA0GeiU2Vw5D2qLGsbbqA
Date: Tue, 28 May 2024 10:02:24 +0000
Message-ID: <81e11b3d3e55aed0b3b9e83fcd05852858bfcbf1.camel@mediatek.com>
References: <20240526081636.2064-1-avri.altman@wdc.com>
	 <20240526081636.2064-3-avri.altman@wdc.com>
In-Reply-To: <20240526081636.2064-3-avri.altman@wdc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6473:EE_
x-ms-office365-filtering-correlation-id: 805b2844-82b3-4cec-1c36-08dc7efd45d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MjI1QTFEdCszM1JhUDdNcTRVblZFMWhaWXpBRlBSS0dTVml3UDNpdXRvYmVn?=
 =?utf-8?B?bXh2ODE4VXFkdU5rajdYaUxpTHZQaXF6ZnJ1cFhjTFdPTEpCakhkQlJVeHNw?=
 =?utf-8?B?Q1lsVlJKZnpSNmVXaVIzTHROYVdnNmU5Ulg0a2k1eTlpUmRYcUhscmFwVWYz?=
 =?utf-8?B?a05YUUo5eSs5cWRiS2NqamkwL1BVaWE2aGlSdTRoS0ZBL2dlK2svc0dNVzZL?=
 =?utf-8?B?WGNNRkVIWVR0SDUwR3h2ZHRncTliU0RZVWtZVlU1Y2szeGpTNGhmcVFoUW9B?=
 =?utf-8?B?dUlaZXdMc2YyZ0syRnNOYXhEY1Y2VGQzbHM5OWZMMXJyNVY1WVNnWERocXNJ?=
 =?utf-8?B?dldMRk9VQldQZWFuc1JIQnN2a0dtL28zd1NtaUJjeHp5NE5kQmQ0dTZvdkNi?=
 =?utf-8?B?N2Z4c2JzaW0yeXEvMkZzdDFWbnkxd1c0ZHNlY2FhRHZ6cFgvS2FYMW5nN0pK?=
 =?utf-8?B?bG1nTU5jRGpVVW1YUktjOEtSTmF6c1RJQWI4QmpPeDV4Tm1KV2huUktEZm9B?=
 =?utf-8?B?WTU2aTFyTHV1dCtHMEk3MzRyazNZODNYaTJLRk9pUDl4WHRRTEc5WXkwS3lS?=
 =?utf-8?B?a21lZ1QySWFrOWNZcW80a2hyWVdJN2wwTXIxQ2ZqdFQ3KzhMWFU2SXFuOExn?=
 =?utf-8?B?RFBPL1NlTVFOVVloZmQ2cGtwZUhTVFhtN1lUUlZkb0xubXBMN1VNN0ZhcUpO?=
 =?utf-8?B?dlQwNURMM0U3TUNkeUZNQkZ4a1RsN0ZPZjlQa3F4UExoN2F5UXhUeDBIT1hn?=
 =?utf-8?B?T1IwRDRHdFpXQ0I2MmxxbVVFdi8xREpMcC84d0E3KzA2Yi9TVEg4OFhqc05S?=
 =?utf-8?B?WjlGeW8zdG9KZlFQTnJxZUptSHNoUjhOZkdrYitUUTVFbTFVQU1qeC9NOVdK?=
 =?utf-8?B?RHFaM3FGakVyc0c3dW1wOUtOTnF0MjVoamRhRllyVDBIZUNWVXBRMnVWUFhs?=
 =?utf-8?B?SlFzNUNjcm5lVnhvazhsMlR4UDFvKzBieHI1T2Q2dE1GQjNIMVYyTmZKT2dU?=
 =?utf-8?B?bmYwRDJJTTN6VGtHOGZYSDJNdEY2UGxsY05mbGtGNGR2UlcrTkVEdEp2M0Ju?=
 =?utf-8?B?U3ZNcVdBTmhJREQ4eWNVZVRyZUJ2RDRjTElBZmN4cjVzNEV2VzB2ZDVLVmVh?=
 =?utf-8?B?UG94dEl0NXVqRUt2QTNSWUpGMEJZNVRJY1h3RFBPSzdzaEhkc1hOS3NIUElL?=
 =?utf-8?B?bDBHM2xPdWJuWUpOSktkYVBBWEpoSmdkaXBxOEs5aUp2VFBVY2FmajMzRzlC?=
 =?utf-8?B?OG4zaVY1NS94VUwvSnl4SjlBMllramZ0OGRjQWhhVCtVYk96MXFQRTQ1VE1V?=
 =?utf-8?B?Y1pqaTdDNDZiK0VNcHExL1daWDkwdlVhRThMdlo4TEYyejY5UjdxbktZYVZJ?=
 =?utf-8?B?R0ZwbWJTTkdnbThINmprMjlDc2hqN2JmSXh2ZkVueUJyZk96ZWJPUFE2aXRE?=
 =?utf-8?B?YzFnc0FGbnQ2b2Q4U2VZUmE4dEFFa09JQk53cTAxY0JVTjVvRUc3TW1LYU5G?=
 =?utf-8?B?amE3UEFOSHpIL2pLaXhRM3RYdmRsL283bXc2SVVLWDlzVm12VUxRU1RjbHRs?=
 =?utf-8?B?RjdtNDczUEJFWkJ0bENHVWRlbTE5djQzZzkvcjZNbVBFOWE4UE5XNG42aFFK?=
 =?utf-8?B?YkI0Tm5FZ2RFbG8yS25xUjd2YWc5Y04wVDMzL3IwbkJSR2NBdFhBMkF0cGRH?=
 =?utf-8?B?MDVkOE5YdERhSmg3Q1JIZE9SQS9EK0pqV2wyak9UTC93Qm1MWVk3VXZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWkyalp6UGtVUi9oSEpjaWIxWmE5Ny9lSmdnVFZkcThaOTVCSGZSa01tVk5r?=
 =?utf-8?B?L0krTXh2V3Y1aWUrMm5QeFhFUVNTYmUyempOVG1odnVCZ20xSC92N2JZeldQ?=
 =?utf-8?B?NWNKbi9Dai9vbXJOVTBvcVpmL1Z3bmNtSy9BSzJBM2IzN0hoVGhGRGZ3MG5E?=
 =?utf-8?B?TjB3L01YVGZPUzdySTlBTDJjeFh4dnBDb0N0NThNQ2lTNk5obG9XZ0ZCQTZG?=
 =?utf-8?B?ZkR4NXBoUDczdGs2VFdLZElCdDBjWlpWZkFlaUhCcWVUc3Q5bUw5c3llQnBR?=
 =?utf-8?B?MFJOb2lnbUNaTk16M2JJL3Ewd0cvZWtCV1lxWDVlZWl5ZVVkcm81cW5tR2to?=
 =?utf-8?B?VFByWFQzbjd3ZGtNZzh1WUVCWFUzSHdzQXdSU3pyRjAzMTVqZkZ5NGEwZDR3?=
 =?utf-8?B?TXZqL2tVVmhLN0NkdGF0MWpvc1I4aE5YVlVReVFoRHhHLy9FL2pUMWw0cEha?=
 =?utf-8?B?VCttaUtNTzNQY0VsVDFjVzFMMWdJNzFMN2R1K21YZlRYdmpCaUZBRU9BYU53?=
 =?utf-8?B?VUxvNzFuL2JWdUhZaTFsUTFUOVRnOGtJaFk1bVBIbGFXZ3gvQ09WZjdKZDd0?=
 =?utf-8?B?cGNDbGZQcnd0M0pvNzZwVVdacUZLL2RVVU14eW1xMmRqbkJYb2pRRXlRMndH?=
 =?utf-8?B?alJZQjF1amliOWNNdEtLYSswdjBuRE1BWG1iZ0g2MmdZSTJjaDF4cFZXL3o5?=
 =?utf-8?B?SXBqVU4rRCtTdGF3cWErVWh5ZlA5UWFlVHgxMWVpdHJoWjFwYkljcFl1MXRX?=
 =?utf-8?B?eHVhdXIveW9Nb080dDZ3WTBFdTVGUnduOTEyM2ZIQ3BUR0t3YTVzSUZBcTls?=
 =?utf-8?B?MFl3YUpxTUNybUgwSi9SSWs4NXZyUFpVR3ZqS0VGK3F0SkplK0ZySkVIVmxO?=
 =?utf-8?B?cmRFOXNOdkdQWEVEMU1IenlyR3AyNnkxd1Nmc3YyT2IyZTFmZ2NqdFZDeTRx?=
 =?utf-8?B?UkpCdzFUaDgyUlF2VnE5TVc3QlVjT0lId2hJWk5YeCtvWURNYUpHUml2dlVi?=
 =?utf-8?B?RG84ZTdGeERvUThkai9RcW9qMTFSRSsxd0ZYVVhWNkpGTUtwSWt5aWcyZzYv?=
 =?utf-8?B?ZExlWlhHTlZRd2NRYmc5WU05UVZTdU5JdUdNSFU4Y0hIMVN2V1VLS3M5d1Fn?=
 =?utf-8?B?SVNpdDViWXMxQUxrWnhJdHYwaVRxME4rdGlqRFkxZllwbkVRWTIxb2RmRWxP?=
 =?utf-8?B?S1hlYVdGVnRTNnpOaGtIeWpIWlZGbWw1YWZmNVZMdkdhQUVKT0xRSXBkaHRF?=
 =?utf-8?B?M2Y5ZTNCOFllSDRvTnBOcVRMekZnVlIyS1NuRERobTljQ0pIdDZSYlo2L1NN?=
 =?utf-8?B?ZUtISUdJVHJ5S0l3ZEg4bjJiMnc1b1NlQ1pUKzVsbG5MaHdVSnR3OWROdkU0?=
 =?utf-8?B?NFh5TWdUU0ZVaFBUTzN2MjQ4VHRjNnQrRlQ5Z0NycktBZlhPY0cyamcxdnBh?=
 =?utf-8?B?WHdReFdiVVpIRnpzK1FTMjZzbGk2dmswN2Juc0ZwN0psZWs5Ynk4WWNvZnU5?=
 =?utf-8?B?TnhoZjhZQ2JZL25nVDZvT0IyYUpIaUhBaUphRXVXWlBaeW13TXNUUXM3UGJX?=
 =?utf-8?B?WlNja0dxdi9xZ0RrdlR5RXU5R3JuaVYzd0c3UWJsNlVFbWEwSU1lMTBiV3h2?=
 =?utf-8?B?UzlPZGo4OVpCT25rU3N5RXAzNjI4VTl1MXlWRXZqUG0vL2wwa3dhdExieVg4?=
 =?utf-8?B?cGR4SEZmMzBwSDZ2cWh3ZExwSytNRVlxQ203RU1Pa2xWeW9Ucm8wS1dLT2pk?=
 =?utf-8?B?RW9wSkY1M1MzNng5UEhxRnM0c3pzZk1WeklXbjBYWkhQWU1Iek5lRWovc004?=
 =?utf-8?B?ZDJJRWkzOTk1aWRzNTdhcFlCYXVJaEc3N1hXYlZJUm1peXhwL1FyVjhXaGVi?=
 =?utf-8?B?VGtrTzFkRlNjMVNnb2hob1hZSUk5WUFpM3FxNjRBMDJLNFN4TU1hSHVmbnVX?=
 =?utf-8?B?QkNWY3ppYWNvUk55ckg4ZCthc2FnYW9jTlg4c04rSjBaNCtSY1ZEWWZoUmFN?=
 =?utf-8?B?YXhJN2RWTEc2SE8vbG9iRTZWckRESDFveWt1WGtwOGp2VEhseW9Ickg3dHBS?=
 =?utf-8?B?ZGhGWlRWV1RxYUJaOTRTSldiN08yclUxeXJnNUNHU1E1ajVYbmx0N2pHZkxj?=
 =?utf-8?B?MVhacVl5R3R4aFJscGU3Yy9vcngvbHdLTkVFdGRTU2pjNTltTktFMEJtbWRy?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4324110C8B4C241B3068262F67AFBB4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 805b2844-82b3-4cec-1c36-08dc7efd45d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 10:02:24.2400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZCE9hCoRtAJmMBie6gL1Gaf7oEmt/sSseyndNVLyRGdtbP86ojlqR5rdG9eK/yNAHqwpN3opN8yRsZZMq+oyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6473
X-MTK: N

T24gU3VuLCAyMDI0LTA1LTI2IGF0IDExOjE2ICswMzAwLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4g
IAkgDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhl
IGNvbnRlbnQuDQo+ICBBbGxvdyBwbGF0Zm9ybSB2ZW5kb3JzIHRvIHRha2UgcHJlY2VkZW5jZSBo
YXZpbmcgdGhlaXIgb3duIG1heCBydHQNCj4gc3VwcG9ydC4gIFRoaXMgbWFrZXMgc2Vuc2UgYmVj
YXVzZSB0aGUgaG9zdCBjb250cm9sbGVyJ3Mgbm9ydHQNCj4gY2hhcmFjdGVyaXN0aWMgbWF5IHZh
cnkgYW1vbmcgdmVuZG9ycy4NCj4gDQo+IHdoaWxlIGF0IGl0LCBzZXQgdGhpcyB2YWx1ZSBmb3Ig
TWVkaWF0ZWssIGFzIHJlcXVlc3RlZCBieSBQZXRlciAtDQo+IA0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzBhNTdkNmJhYjczOWQ2YTEwNTg0ZjJiYWJhMTE1ZDAwZGZjOWM5NGMuY2FtZWxA
bWVkaWF0ZWsuY29tLw0KPiANCj4gU2lnbmVkLW9mZi1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0
bWFuQHdkYy5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyAgICAgICB8
IDYgKysrKystDQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jIHwgMSArDQo+ICBk
cml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5oIHwgMyArKysNCj4gIGluY2x1ZGUvdWZzL3Vm
c2hjZC5oICAgICAgICAgICAgfCAyICsrDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3Jl
L3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCA3ZGY4YmNhY2Jl
N2UuLmI2MjAyM2E2YzMwNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2Qu
Yw0KPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC04MTQ0LDcgKzgxNDQs
MTEgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3NldF9ydHQoc3RydWN0IHVmc19oYmENCj4gKmhiYSkN
Cj4gIAlpZiAoZGV2X3J0dCAhPSBERUZBVUxUX01BWF9OVU1fUlRUKQ0KPiAgCQlyZXR1cm47DQo+
ICANCj4gLQlydHQgPSBtaW5fdChpbnQsIGRldl9pbmZvLT5ydHRfY2FwLCBoYmEtPm5vcnR0KTsN
Cj4gKwlpZiAoaGJhLT52b3BzICYmIGhiYS0+dm9wcy0+bWF4X251bV9ydHQpDQo+ICsJCXJ0dCA9
IGhiYS0+dm9wcy0+bWF4X251bV9ydHQ7DQo+ICsJZWxzZQ0KPiArCQlydHQgPSBtaW5fdChpbnQs
IGRldl9pbmZvLT5ydHRfY2FwLCBoYmEtPm5vcnR0KTsNCj4gKw0KPiAgCWlmIChydHQgPT0gZGV2
X3J0dCkNCj4gIAkJcmV0dXJuOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0
L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmMNCj4g
aW5kZXggYzRmOTk3MTk2YzU3Li5jN2EwYWI5YjFmNTkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
dWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVk
aWF0ZWsuYw0KPiBAQCAtMTc4NSw2ICsxNzg1LDcgQEAgc3RhdGljIGludCB1ZnNfbXRrX2NvbmZp
Z19lc2koc3RydWN0IHVmc19oYmENCj4gKmhiYSkNCj4gICAqLw0KPiAgc3RhdGljIGNvbnN0IHN0
cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHVmc19oYmFfbXRrX3ZvcHMgPSB7DQo+ICAJLm5hbWUg
ICAgICAgICAgICAgICAgPSAibWVkaWF0ZWsudWZzaGNpIiwNCj4gKwkubWF4X251bV9ydHQgICAg
ICAgICA9IE1US19NQVhfTlVNX1JUVCwNCj4gIAkuaW5pdCAgICAgICAgICAgICAgICA9IHVmc19t
dGtfaW5pdCwNCj4gIAkuZ2V0X3Vmc19oY2lfdmVyc2lvbiA9IHVmc19tdGtfZ2V0X3Vmc19oY2lf
dmVyc2lvbiwNCj4gIAkuc2V0dXBfY2xvY2tzICAgICAgICA9IHVmc19tdGtfc2V0dXBfY2xvY2tz
LA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuaCBiL2RyaXZl
cnMvdWZzL2hvc3QvdWZzLQ0KPiBtZWRpYXRlay5oDQo+IGluZGV4IDNmZjE3ZTk1YWZhYi4uMDVk
NzZhNmJkNzcyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5o
DQo+ICsrKyBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4gQEAgLTE4OSw0ICsx
ODksNyBAQCBzdHJ1Y3QgdWZzX210a19ob3N0IHsNCj4gIC8qIE1USyBkZWxheSBvZiBhdXRvc3Vz
cGVuZDogNTAwIG1zICovDQo+ICAjZGVmaW5lIE1US19SUE1fQVVUT1NVU1BFTkRfREVMQVlfTVMg
NTAwDQo+ICANCj4gKy8qIE1USyBSVFQgc3VwcG9ydCBudW1iZXIgKi8NCj4gKyNkZWZpbmUgTVRL
X01BWF9OVU1fUlRUIDINCj4gKw0KPiAgI2VuZGlmIC8qICFfVUZTX01FRElBVEVLX0ggKi8NCj4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgN
Cj4gaW5kZXggZDc0YmQyZDY3YjA2Li5lZjA0ZWM4YWFkNjkgMTAwNjQ0DQo+IC0tLSBhL2luY2x1
ZGUvdWZzL3Vmc2hjZC5oDQo+ICsrKyBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+IEBAIC0yOTUs
NiArMjk1LDcgQEAgc3RydWN0IHVmc19wd3JfbW9kZV9pbmZvIHsNCj4gIC8qKg0KPiAgICogc3Ry
dWN0IHVmc19oYmFfdmFyaWFudF9vcHMgLSB2YXJpYW50IHNwZWNpZmljIGNhbGxiYWNrcw0KPiAg
ICogQG5hbWU6IHZhcmlhbnQgbmFtZQ0KPiArICogQG1heF9udW1fcnR0OiBtYXhpbXVtIFJUVCBz
dXBwb3J0ZWQgYnkgdGhlIGhvc3QNCj4gICAqIEBpbml0OiBjYWxsZWQgd2hlbiB0aGUgZHJpdmVy
IGlzIGluaXRpYWxpemVkDQo+ICAgKiBAZXhpdDogY2FsbGVkIHRvIGNsZWFudXAgZXZlcnl0aGlu
ZyBkb25lIGluIGluaXQNCj4gICAqIEBnZXRfdWZzX2hjaV92ZXJzaW9uOiBjYWxsZWQgdG8gZ2V0
IFVGUyBIQ0kgdmVyc2lvbg0KPiBAQCAtMzMyLDYgKzMzMyw3IEBAIHN0cnVjdCB1ZnNfcHdyX21v
ZGVfaW5mbyB7DQo+ICAgKi8NCj4gIHN0cnVjdCB1ZnNfaGJhX3ZhcmlhbnRfb3BzIHsNCj4gIAlj
b25zdCBjaGFyICpuYW1lOw0KPiArCWludAltYXhfbnVtX3J0dDsNCj4gIAlpbnQJKCppbml0KShz
dHJ1Y3QgdWZzX2hiYSAqKTsNCj4gIAl2b2lkICAgICgqZXhpdCkoc3RydWN0IHVmc19oYmEgKik7
DQo+ICAJdTMyCSgqZ2V0X3Vmc19oY2lfdmVyc2lvbikoc3RydWN0IHVmc19oYmEgKik7DQo+IC0t
IA0KPiAyLjM0LjENCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KDQo=
