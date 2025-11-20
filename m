Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FFA342C8E;
	Thu, 20 Nov 2025 13:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763644495; cv=fail; b=YhB3g3T4Y7HFmJcHiTWAQYec+1Y+AXNsLj/4FNuJ9xaXKhqZ7sId+fWXhWkjz/fk0MnB4LhDSbgneHbBfjHwlsAC/+PV7xTziEFGw8cV2HwbvZ7mSvF4tQPnsXM7qyXIBbYVE41loTOtNDdo4MQZmLnkpJoJK+DRAAUxwOAcnWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763644495; c=relaxed/simple;
	bh=eKNrL5+PBko8+J4NFmLtzSYquik2gqRqbgHSMHCWYFQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Aj5pMrrLgWO1wgX1B/t5BDwdbryk6cd3I7K4nC11ZueTccDbXfD8OcVB1aTmw4aG4vTB8mMh1xEKphvGGiHhxxqUEmyF1C/m/2c7x2aNLM9guCQyVjVNNBDyeSC5WiuBXD3DNIHm1yWvQVtlf4C1pCUQVVONRLsBueLQ7TODEyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RQRvZkKE; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=URFRT/0W; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RQRvZkKE";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="URFRT/0W"
X-UUID: e4057d0ac61211f08ac0a938fc7cd336-20251120
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=eKNrL5+PBko8+J4NFmLtzSYquik2gqRqbgHSMHCWYFQ=;
	b=RQRvZkKE49061d6JYTWJkfMCCjLqsOuK/kpt0TUq6sTg2S96Hg7KoYPfX9wYmDk8EF/WWLOEjK3iS/hY+oTVyxTCm7HyX59U/wGzUmE+IMC8QVZ49SEKGovDY9T7nhNr6CpUW6GREvmj7Nr3dguITxLVoGg0FknSnF36t4w7pnM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:aae225ac-5515-45ac-b678-b811866137b4,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:dfab1d58-17e4-43d2-bf73-55337eed999a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e4057d0ac61211f08ac0a938fc7cd336-20251120
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 63478127; Thu, 20 Nov 2025 21:14:48 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 20 Nov 2025 21:14:47 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Thu, 20 Nov 2025 21:14:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXoC/uRjZQAW/GWiE89VmJCECD9CppX08KrJbD9+/L3bE+ZzdilwfkVupWTZUkcJeABUkzbELWMvrCrvm9gWpz83HC96fqhRoGAnnLCES2Kf1MDqSRALk2r0GD6fg6OOop+5OxYuc24dR4I3UPbMHX2tdZGzC3p4tg1ebFg4WiVrDRA8J2B6zo01LnMWofSpQK1HV1IpuKfhoFbaAoTJNCqQPxAttxnAwtnhXP82cbfa5wEgnZ893GIc2fe0PgjH2E8pU8VpXb3pvJQO9m1OZTSV8e+XuHyGRWS1UrqdsRLZ/owms4LgeaeP4DznMFH5WLoFWuv2E0ZabAQyL+aLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKNrL5+PBko8+J4NFmLtzSYquik2gqRqbgHSMHCWYFQ=;
 b=u4pm6laSz0O1226tbROlv/Pr4U8yFaKukZDBk87MgEFrS5D6cex57RMEF5x6FmMUydMMK49u5OqFNsxJYmn09WTmXmqudA8SiBsgNzNKL0aq1MofWkFLov9qESFJZjPem9RPCYUOMwHW9ewU2tjgMI4fBpk3gkLWRZRRFpZabLB7bCYmbUHSrYJ3SyaYtHipSsXmEsIK1o2iZmJirazkqp7PCJsGx/eongeSRXpl/R20xCNXbfcEow/Ni7EbVDUjnj6VmjdA6rUsOHbUPbqZa2Ij6wrm4M+d/SPulCe8Oelk2Gh3kKrTBHulPPRIDSdF97BRTmRxfLyPg5sbI5CcGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKNrL5+PBko8+J4NFmLtzSYquik2gqRqbgHSMHCWYFQ=;
 b=URFRT/0WrdtT0YULT6l6PIGJ880sNy9cumuRHIK8gSvbw3VTMGG6dX3ow3sV7lEWq5FHUXxD9bp0ht0wtgLdruiTGiHBNM6yqemPSYetugG/PLaKadDJ8TWGv63ONuFgUlCcApEdKB4hKLdkoVMod1OE9VxDa+WbUF+Uj3Bn+U4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7846.apcprd03.prod.outlook.com (2603:1096:400:45d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 13:14:44 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 13:14:43 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "powenkao@google.com" <powenkao@google.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Topic: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume
 error
Thread-Index: AQHcU55F6G16JbOQOEePCVKNWnq4HrTuslIAgAARGoCAAZ+hAIAHru6AgAGxngCAAPHvgIAA4n8A
Date: Thu, 20 Nov 2025 13:14:43 +0000
Message-ID: <bd736a55b3a915cbc1493e48359c8772737f289b.camel@mediatek.com>
References: <20251112063214.1195761-1-powenkao@google.com>
	 <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
	 <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
	 <c4bd6532b003089fedf518db878a3843c516217c.camel@mediatek.com>
	 <CA+=0d2aYn_q=i6Yy=zSu6eE=Fj0oTk4t00e1uezBxqNc5E7pdg@mail.gmail.com>
	 <301cc0724a9e22bf195cb0bafb0c5d298e93e99d.camel@mediatek.com>
	 <CA+=0d2a6YKD_OGcM89b4ZUn=gEhF6G-YxTfRBouiX-wYcyxS7w@mail.gmail.com>
In-Reply-To: <CA+=0d2a6YKD_OGcM89b4ZUn=gEhF6G-YxTfRBouiX-wYcyxS7w@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7846:EE_
x-ms-office365-filtering-correlation-id: efd42a81-bde8-48ab-09d4-08de2836c511
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dDM1ajlsWW44TTJEOW5aQko4OWRIWmdEb0R5cGxJcVhkcFZsek1oNW9oMEpq?=
 =?utf-8?B?bnBDb3lCYy9YR3lFWlJjRGdsaEFGOFlGWTdveW0wTTRXamRQenk0dW03K0Vl?=
 =?utf-8?B?d1dzV0dsOXNabzB0eWk3S1lIanE5djBaUldSVGRZRU4rYjZiaG8wSndCTHcv?=
 =?utf-8?B?d0hEQXMwNmxHbm1QU0tNb1d6ekg5NWJhNjB3ZlFiYldXT3MrV2o1Wk9RNi9K?=
 =?utf-8?B?cmhrZmlKekoxaGJWSkFVOGpxc0p5bjVMUEdOTFArRHliNWpqUUxLZWg1amJi?=
 =?utf-8?B?V09oUTh2N29NTVlERmZVcC9PMlkyNExITUNobGo5aW1kNDNQMjZwS25JSTlv?=
 =?utf-8?B?VkVYaktSR2Q3UGRWWWpHdm9WVTdpeWZ4MEJpL0NCWHRPTitpa3FqQmQzdU51?=
 =?utf-8?B?TURXUlV0UG5ZdTA5ZmljNUJuZ2I1dVF0WUZGeWV0NFU5NGcrakI2Uk16bWhR?=
 =?utf-8?B?Q09oU2E4Q2szYlR2SEpsdGtteVJwUjJHdGdWQ05xQS9yb0dLUHVPdFM2ZTZh?=
 =?utf-8?B?TCtmYmIxRWRpaVp4TUE5bXFlbDBHSTJIeGJyMUJnS2NOcFpMQXZDdVo4RDRT?=
 =?utf-8?B?RmRxd1V3S05tMkdrNjJFVTgwT3JHWHFSeGx2NHVkTHZlUUU1WkltUzBONWJ2?=
 =?utf-8?B?amJCb1k5bFMveHh4YXQvNjd3RlNFNEhQM2gzamdFQ2pYL2t1TEROZkl3Skta?=
 =?utf-8?B?dHZrTTQ1Q0NaNXQrcHBwcEZUWFNqVGpoWVExYVlUNzZZa1Eya2FDSVhEbUhx?=
 =?utf-8?B?cVBIUHRDOHZoSEZ5ZmVOMXA3ZlRBamlhZG1yOEFzMGhnaDkvKytCeU8rbDJW?=
 =?utf-8?B?TEtsUmt0NmpUQjVONjhxREpWT0JVM2IrbVpjelR4bTVJejJqRG5FU2JPVTdF?=
 =?utf-8?B?aFkyUDhDaTdIWHluRHA0eFJYTXAyQ1ltOWxOak5xMGJXMjNVK3hERG92Z2h6?=
 =?utf-8?B?M1ZGTmZ2bEV0TFpnYnd4T2RDRmdHU3JYMDFQZWxWM2JUMW0vRmlEWlUyU2tj?=
 =?utf-8?B?dUMxYnBtUjdPVmExazdLTFhvVDVlOWUybnBBdUZZWmIxenN1UVZCSnBYQWRm?=
 =?utf-8?B?YlR3cVJDRWs5d0Z1dUhHL0xnb0FGSUZZS1hES3lvMkR4d2MrcmsxRDlGVmFW?=
 =?utf-8?B?TzBUWGVzemo3ZjZqT0Y5V3Jiem1vbXR6Wkdzb2xyc0gxQVRERGRXaHdmei9R?=
 =?utf-8?B?VzZyelBkNW1UaGVKWm8xaEFuaUk0SkZwQWcvNXdtTHBZTFpPUmRKU0JySzZ2?=
 =?utf-8?B?ZHJ3d3JLRGZVWWdmWnZEdk81bm5sZ0pvL3A1U3lOSTBLQ053SDVMa2lRdDly?=
 =?utf-8?B?bTV2WWZMb01zNCtBRmlCTFFvZGxvSG83ZnJVT0M4NHJlN3ppbDNYM3BIVUVN?=
 =?utf-8?B?Y3hxYXlRNVRoRmdtcjkyNDF5dU5keXZSUCs1NGVMN1JBdGlMOU9kSHpwSDVD?=
 =?utf-8?B?RzhQeHFMaG0va2VPWFY0QTMyTTFhR1BpbTM1eElrMlhyai8yRGtGYVk5Nk9H?=
 =?utf-8?B?dHBYVnZ4ZlF1WVdvSkd6TDA5akVXV1ZsWm0xRE1FYWFjWnAzZ0UyQlEwMGRm?=
 =?utf-8?B?cHVBK1RnZmxPaFBOTW5iaVBGT2tvMEJZeU94emdWN2hSU0ZDa09QVTdVTGFV?=
 =?utf-8?B?cFA2d2xFcnRhVXdrUEhCalZtVC9WOGt2M0hIUnMrSTltVUZCRitZb2RocHhn?=
 =?utf-8?B?cnNtTldVVWZZTVpaUTk5Zkk2cUlBQVVJV3ZZSGZQejlrd0w5NUdBZGRXa3d5?=
 =?utf-8?B?NXdwcnpoQU8zeHNMVU1GS2J1SnV3Z1IyaG1hUldsMVBadW03aC9XVTRMYU9S?=
 =?utf-8?B?eWlTMnlhSXI1TUVSNjNDQWRMbFU5RmhNOGpvSmVTMXFtSjczWDNDWHpGR2p1?=
 =?utf-8?B?dTg5MHpYOVgwaU1xZG1IcUt0Z3lnZmhxM29YSlRrcXNvanlmYkVYeVl5YXFz?=
 =?utf-8?B?UllaL1VpcnFXbkN4d3BQYkFMQ3VOak55ek9sdWQ2d05obStpOVdBVEcybXRK?=
 =?utf-8?B?WEpxbExLaTMxUnlaTWV6VndDSitsWCt5OFBxMysxRXRuMWVuSjhQMDR5YjNx?=
 =?utf-8?Q?1q8piG?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUs0TExtaGJzalhwdWw2LzF3Y3h4TCs5ZjJTQlVQc0Z3OUtrbWJOa0dJYktm?=
 =?utf-8?B?bW82T05FWTBJVDNOUWVjOHdXSUVpVThNZkptQ3ZMUlh0cUNOb2oxTU5PeERW?=
 =?utf-8?B?OVQ0TGh5TXVHK0JJQ2IreWFpNlg4K2FDTkhyeHJFdlJWbjE2SWVDMTFqZFoz?=
 =?utf-8?B?OURVbHgyVXE2WnVlRWg5bkMyK0tPZkJubUpiSWN4MkQzQzZtWW9HY3BvcjV0?=
 =?utf-8?B?YnY5dnFFRzd6V2pNTjZEV21NZ2FMeFBNdkNnL280dFA4Snh3L3lpTUpVeTQ4?=
 =?utf-8?B?WDFScFFwaGk1cVVSQkozdFgwNmt3cndNV1pZSXk0N1JWSC95MUFKT0JpOUxL?=
 =?utf-8?B?bWpnQ2s1NG42UDVkdGYxMENxOUVTcWo1bTR5VjBaSlIwZjU1RkN3V2VZV0lz?=
 =?utf-8?B?K1Jrc0xSZHlQdUFRSWNnL1ZYbWdxendLRUZNWkhJaXJWbUxGbVZUNEY2NzAw?=
 =?utf-8?B?ZE05WXhsU3RwWFcxNkZyVHEzOVI3QTd2eFBMQVpMcWRJajg5ejlzYTlNNjQy?=
 =?utf-8?B?UHlZUktucnJtNnNkak1SQlpSYlBIRU41Y2FDKzcxQzJzSFE5UmgrbUUyYkJH?=
 =?utf-8?B?QmRranFlNzlDMFFZNG5KckVERjdKV1JDSGdYeTdBZUY4bStnZnlZNjBYK1Fh?=
 =?utf-8?B?bXQ4a0ZJZmd5NExJT3hWVEkySzVNTTFVMG50WVJRQ3FBTHl4bFplQ1dzTW9l?=
 =?utf-8?B?R2x3cGpzV3BjQTNuM1ZYZ3plVVFRSC83QVdjV1ZnVmxXRUJrRkh3SnR3NEFS?=
 =?utf-8?B?ZC9rK2s2TUZoZU1uVWVCeG5MOUpleEV6NDh5aFR5L3ozNVk2a2N0RWlOVmdS?=
 =?utf-8?B?TUtZaHpyRTNkNG1aeDQyKzFnVk1GcUR3M0ZIc2VBZTFQQjN6ZTY2c1N4LzJt?=
 =?utf-8?B?S1o2a3ZramNiUEdMWGhJSEtPdlFzbEs3SFlQYitMV0piYWh3dUJjOVl6Nmpw?=
 =?utf-8?B?MHlxbXpnRnJ6V0RFZnB3dHR1SUV1Wi84c1pGSXZiZXdVV3RSZDlmcmNyZFhZ?=
 =?utf-8?B?ZjJIOTlPYXFCNzdlcGVHY3oyL2lTWW50QzRmRnBJRXdDaCtOYmFBYUc1UEVI?=
 =?utf-8?B?c2VPeGtwbERNUGplYndVNnRBOE1MNVEzeDhNWE1iSXc3V0ZpeWMwS3QxSEFi?=
 =?utf-8?B?MEEwODByVDlhMm8zVlVFRFovc0tpRnRNNUhqTjJmdWZLOHM0UXhOQnVDamVt?=
 =?utf-8?B?K0tqSjY5Q1I5YUorbU41WTZwVVdMS0IwbzBDR25LQkEvcGx6ZTZ3RFhNVlll?=
 =?utf-8?B?Kys0Ly9EejhGaExGMTRTYVBQSS9vNzhFR29COWpLZ2d0MnYxNXhKaU1EL1dO?=
 =?utf-8?B?WmtTOFd5QzVFY1BEbTl1T0dic005Z3dvYWJYTEJneFlTb2RIL0NMQTVraTR5?=
 =?utf-8?B?Y3RObUJYU08wajlCSm5SR0ljd3NCT1JidC9NWFptMkI3Um9aZzE2VkpjdE9h?=
 =?utf-8?B?dmpPL0drNktIWUJXaUlqOEtJays5U1dNRHdWVkViMHQrZTYvcVRtemZqNWI5?=
 =?utf-8?B?U2FsN1IxMHYyWG55a3NXeXgzSzg5aTJQN1lYNDZZejhyN0dya0ZaYXV6eks1?=
 =?utf-8?B?NTlZVE5wQXgxSllxbmZVRDlmMjJlVFJhVXJVakJONmcxbnhqQUd6aGZqdVZl?=
 =?utf-8?B?SHpUUEE1WjhybisrdnZrZDd2ZjJ2UnJhcFc2K3llb2VzOG1XeDVEZ29Wbkpn?=
 =?utf-8?B?Y2dMWnYvbHdvbXRRSEgveDk3bm9wR2VFVEQwUkw3UWN3Yy9oNld4NktGS09a?=
 =?utf-8?B?VlhUZ2x3azhYMWVEZjVzSEtabUE2MzdlNU5tUFp0dXRMU1J1VGpqaGVUVDdZ?=
 =?utf-8?B?cDIyOE5tNkdEeUVoM09JcHJ0ZGxmclNpNHROVHZpUXphL2w2OWJnSi9LVktz?=
 =?utf-8?B?cFdHaWU2amZrb2tIYnJzaHhBb1hmc0dtd0hkNEMwdlZJOGZpS2x3V1F4QzNY?=
 =?utf-8?B?cld5Yld0Y0FBcjNDSU5EUnZDNHFYb2pOS3hJTEkxdTZRcFd1cHFPZ01pWHJz?=
 =?utf-8?B?c3hoVkVoVGZCSllSTlVMaGhNWlh6Z2tVVnRkbzJNYlo2U1M4S0JNTW80TWls?=
 =?utf-8?B?Y1dVR3duSm5HODAyOEpibzhxVzlHNStyVElwR1IvTDk5NVlySC9UekZsdzZ3?=
 =?utf-8?B?Z1hMNTVTYzZyNEh2TktlRm0zTFE0MTJtQjNQS29LemJTb0lIdGY1OEpFV0Fj?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AC991E975F3314A81FC2E9E07B537CC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efd42a81-bde8-48ab-09d4-08de2836c511
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2025 13:14:43.2493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtFHpeTzh8NqaKQ6FxOKT044iwkZOhXpnDNgaoP2aYWK8nxPoCzorM6s30PM2ejzZKwL/9Tf+CYBm3QoiZzfow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7846

T24gVGh1LCAyMDI1LTExLTIwIGF0IDA3OjQ0ICswODAwLCBCcmlhbiBLYW8gd3JvdGU6DQo+IA0K
PiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRoZSBjb250
ZW50Lg0KPiANCj4gDQo+IEhJIFBldGVyDQo+IA0KPiBZZXMsIHRoYXQgaXMgY29ycmVjdC4gOikN
Cg0KDQpUaGFuayB5b3UgZm9yIHlvdXIgZXhwbGFuYXRpb24uDQoNClJldmlld2VkLWJ5OiBQZXRl
ciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
