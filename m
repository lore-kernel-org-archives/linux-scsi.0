Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A8204F93;
	Mon,  4 May 2026 09:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777886370; cv=fail; b=GAfa1WkFey9CGxRvP1I0oQmbkJnCA9bvfneSOSAOL37TH9TAYjYyiiZjX7omjwW6hTWLXdCUsEQVcH9UMHMuXAYVoIip4XBVza9vZonSe0U+3mHxoFxrAjks5MhGQSkm4x4lGH/wQ+1IPM072MtdnfyCm9p+9CsgpL/LFkqiez8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777886370; c=relaxed/simple;
	bh=alQJw/lKVXAUHN2Kynq4JLjOxF2grmUHBpYwjkrMVoM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sv3e9eohaom8nUeaTe+nuEeZkYPU2iHlQaoz6qW7XH0AbubsFNVrBq7/RF9eEjafYlW+45Lor6gG7scTx5Ix6MRHMbFNCkvnOr25U38QIHDAWbtUxWZzgh6Ndbg5nN7e7w0y2RVlMeKfrtGBYeAlDL98BgROOHFankpKahrloDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=skzdvlKi; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gOIHuDbL; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="skzdvlKi";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gOIHuDbL"
X-UUID: 536fd6c8479a11f1b96f91537e34a508-20260504
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=alQJw/lKVXAUHN2Kynq4JLjOxF2grmUHBpYwjkrMVoM=;
	b=skzdvlKiBTMNhuf21uPSByO3McYNlCPnTICY5MLr7ZskKlAUEcoqJT7+pD6LMUQYqZ80X8Rr9FO7oVB6qaPOaKNF4PoFthdcKXus0ctssN5si1xXIg7fQBDas0FRu50Ku95ZNsfF/tN8kEslnC8ayUIHAOLrkwGxOYpSeDqFveI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:99209e80-3617-41dd-af64-dbf9c9b7ce3f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:9e121145-8360-4d24-8500-9b9380fa4b0d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 536fd6c8479a11f1b96f91537e34a508-20260504
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1241823817; Mon, 04 May 2026 17:19:17 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 4 May 2026 17:19:16 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 4 May 2026 17:19:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hpXbcUnC/KZTkHPKPyLQ0jEomFYbtewGie7qf8sQIYtH3Qa0Ac45TDnFIEhll2ad5WU0IlBCQKyZn8DK4SzoUIN1GHOGoBKAIh7UMVzw5pMscda4Eke1c+ByUSAr1acbiO37Zg0aVh+txW5XxVESxvDjteaYPhziSDH5zoJ8BsCm+kRYD+BGAL6GaFAZQQKVFzwGvlKVHkNawVtge7W1RA72kbVfuxy+tdrMvRMuM3ia/9R0faz7KjLOGnc2NxELcE8iqG6u80q3Syrq/qO9/uSzoLorQVq7YglERsr28hXPheeNa+856tEcxXt6X6f4t2rR804ywJuLKc5s+Qv5ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alQJw/lKVXAUHN2Kynq4JLjOxF2grmUHBpYwjkrMVoM=;
 b=mUN8x5l3jS/ECikcgmi+r/JbpTGnwWjI0kVZlfynjqDVS46+JyTMUF2UhN9FLbI0TjuKUv1DlaYMmMn9a+LStFw4y6vgXVnYIpSou/InJQ3pidgurhmSK4BI6ujXununGjU7dQu1xOe+JVb4P3lVMJGShe8xfP/1Q47zYj6SIWWshkqNSetnV17MuyfS/lxAdPsXUQnxLsbYGvsEy3PN2Km9v/vQLXhJK8OlMzS4ybU2fR07FDYRohfH7qxGKG780uEC3CE53dcktibURsqnJm3guQpM0i2YxPCzYdgdFDj7pbw4Fnwgk7oUqxhKZ/nv0Mo7wDyUC0VeFF3P336HgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alQJw/lKVXAUHN2Kynq4JLjOxF2grmUHBpYwjkrMVoM=;
 b=gOIHuDbLMt0ZShxuH5hhbWaJ0bO7w72NVsBPiNTR8Be6FoSDEAJgUn20DvhW98ie9yjF09vcObCwV6zJFq1ywQih+ziCyrd4WUxP52pOyS+M+Qjrcy+mS0pubQZmJYBvaae+q0766d1aFqBDi1diSnSL5/d3sq0bc6l/kIXbJE8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6622.apcprd03.prod.outlook.com (2603:1096:400:1ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.13; Mon, 4 May
 2026 09:19:08 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9891.008; Mon, 4 May 2026
 09:19:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR
 Adapt L0L1L2L3 length
Thread-Index: AQHc2WzyAK9ykRAzgEuKYwXzeINk5bX9m0IA
Date: Mon, 4 May 2026 09:19:07 +0000
Message-ID: <a173bb1733968d41690f8472d13b95028c8975c5.camel@mediatek.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
	 <20260501131641.826258-2-can.guo@oss.qualcomm.com>
In-Reply-To: <20260501131641.826258-2-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6622:EE_
x-ms-office365-filtering-correlation-id: 175a2a09-eed9-4031-78be-08dea9be31a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: H4xpjFx28hppSK4hv8M2jPnWlh8Z0ViBiDROA/70tv8GqfA1S9vPl+P9rUyOfcLzXhaA9hidgaDtCDI97vg16l+j/svMj+s0CiHlOzeaWuIE8koYxYxi8ZKks43FT5aOLqAZKeAeemzvdRLlWH2lKtWjKymLFzWf2B+rADTTH3Lrz/8jng6sN/CYBSkzMhO1LMmUHu2k7yaM2Ki5a2DhQe0B6dmOL93DPk49KhSkg5PHp/kShjqpfxq+iNthhJkNwF+9mF4gGAsEFoXeC/wizEkIj/Hc1WymGADz/uhgqQa27rjQpAgbXGbnXBFi+iKIs4Jq5UmFDTNwR0gH/GXAnfZDwyAV+S4Df+MI+wg20lPpem2XWTWwXV+9qdRxNLxEOt2kQpAk1vp2JODNphO9DyWiegiephBi8ER4au4T7qQfShERJtAK/gjj7sja/Ba28v2zzSnFHgE5MKllQJMphURRv9bGaJYma5XMGLOSMdKeul+oNqXv8iaVP6HN7zFUCAwzQNU+9GDv2MM2b0An9UaPuCvxb6y/A8TOhtejZwsi+KFFa3XRMHABg0QHDmgCDV9Vw9KwrLQnKJHDFPBXCrEdWXipnTZzTazlMBMFL9bEHRXkaJGXwOh5+Oto5/wGhhYejCb4MBYn/NfepjpECSGvEFvI7h6caYXROTI4DYtjuJNC/V1IKZVRL/PfcjscqLglfWThPOU6AHWeTgvqbiiMrz7HNgffxIBH02R1KvtF/Rf+Og+uzWSpbBQTVOWm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmllZWJXdWFHUlU5RzFYbXc2V3gxQ1M0U3h6Mndsc291LzJFZ1lhdlgyUGFZ?=
 =?utf-8?B?ZkMyZTJNMzlRVUdvR2ljS2M3aUU5OXQvRkZsK3Vjbm1RZWZvempsSzIrTFcv?=
 =?utf-8?B?YW1sL0p4WmFEMDNaalBrMGRjbmQ3cExlQkNXb0lBeUM0cDNKcnkvTHBEemVt?=
 =?utf-8?B?aXdmc1hyQmFYNTMzNWl5Z3c2Y2xyMEc2VmNRQ3pzOHRoNnEwMzdmZ2RwSndY?=
 =?utf-8?B?Qk9QZ2h1M29PV0dxSzM5QVRKcHh4OHBaM251bnRxSzc0MGg4aDdyWHNudHQ3?=
 =?utf-8?B?SGI0UHFQNXJXWVpWSDZMMjFoRFdheTVnTlRsdGszMTRLYW1JUkVISHlBeWh3?=
 =?utf-8?B?algxcWJIaXltTUEwWUxaTllCSU9ISitGZEYrZzZiMWo0c20rTUtUcGtOTjFz?=
 =?utf-8?B?dkpSUnpSUTM2d21YWHQwcWhWNGJBRjJoV3hSdFdNUXlsZXJ5b0lxeThHVllP?=
 =?utf-8?B?L2xYdHBqS29sdWJvNXh6cU1Na2RaMTRSeVdqU3k5L29jQi9mbmw5azViSjZY?=
 =?utf-8?B?VExlV0gyMWZ4c1hPUXRCMUtKZUF0R2FtUUJFemxZSlFVd3l3NmYvTlMyS1FE?=
 =?utf-8?B?UVFIclg0ejYrRzhPTXBtbjZiTHpvR1dpRHVSd0p2N3Y2Zk9xYWJnYml5Rmps?=
 =?utf-8?B?VjRCVldZblpKVnlodHhqaTRxV2M2RWZLaStYMWE5emV1VDB3V1VBdmZBTE56?=
 =?utf-8?B?N0NIbnVLeGtZeDdSZ1p2a0tJakNBeG44Nm9jeDF1dk9NTjFVY2JyTy9ReDIy?=
 =?utf-8?B?bnZ6VE5WYlpvek5qcUM3Y2IwV1lNZ1Y1c3lONHdzQjZhUHdsVFlUL3ZkNmFz?=
 =?utf-8?B?enBsVER2NXlTRllXNGZ5R2MzMGV4amlhK3RMWWUxR0VRaE9YZk90OVlHbFBy?=
 =?utf-8?B?cXRRVTVjQ0p1dmt6NTJlcktPL0ZrV2dlMTN6bGZSYVkrcTQ2eEVodEVTNmxW?=
 =?utf-8?B?VWdBU2lzZWtEcExDTGFzSUtjWWRFVktRS3NJNXQzdzl1TEZ4R2hhNkJtTkxR?=
 =?utf-8?B?ZHFiTDhYaGZSVjBSZS85NC9Hbm0xWS9ZWUcveXBQS3JHMGJRdURnUzd6VTlx?=
 =?utf-8?B?RXRodmJsNkh4YkFIQW9QbXA1NG84U29TcFBZb0NBendVV1p4aUxCcXJST004?=
 =?utf-8?B?YVQzN0VEak9ZV0YzdFNPZXVYZ0dCN1hJNEhNeEFpTU1EYnhhYjdEUVJoV3I1?=
 =?utf-8?B?bjVpcThZMUdDVWRNWFc0N0I2NXJOL2E3RkdGR2hwM0JrWEhiVnpmVHlDMk9a?=
 =?utf-8?B?b0JWZllmQ0lsb1V1RU9BYzQ2b1VOTjBIZHI2RW9FNFBuajFjSWx6ZjcwL0du?=
 =?utf-8?B?a25EN3QzZ3EyK3psWE1CblpDVlUvQjdxK0tGY29BVVBLZU94MThCN1Z1WU5I?=
 =?utf-8?B?LzNnWXk0NzJBSGVpN3pkU3lvOVVZOHppQ0dCWWRjWEVRSE5aekZkMWEzR2JB?=
 =?utf-8?B?dm9pTmwyakxCWURFVlg5b2x1Q3VJQllQVlc1UTdTRDZIcWdMSGVqUm5mY1dE?=
 =?utf-8?B?R0hLQ3NxQk9XbkxPMDBlUzVkUmYzcW9wTWFnZXkrdWZicTE3cmVYNUxrQTBI?=
 =?utf-8?B?eGpnTWp3VURJQVd2V3VldXNmaU8yM1J2OEIzMDVzMzF5VEM0cXk5LzlDZlRi?=
 =?utf-8?B?YllIMzN5L0ZZNzhSVGt2U01QMDlmazhCY3ByenpYclJhUWZtVHFKNVZ5SEhV?=
 =?utf-8?B?MjVFUm5DcUJYY2Q1anVsOXlsUmZWK1RQUUJNVEE0L1NxUkRWRC9hazlrNFpq?=
 =?utf-8?B?eDBHNWdsQm5mL29FS3NwMWNQZmYyQ0oxcWRLUjQycHdJc0RVM0ZhUjM5ZGpu?=
 =?utf-8?B?dHd6YlE0WlU1NVJNUkFNR3V3KzUzaUYxRHhva1lTYTV4MXZPRWRBSnd6aldW?=
 =?utf-8?B?K2pCRGwxVEVOSGlPa0s4Q1JDR2I0WldURFdGU0pZK1lnSktsNUpXZVRaZGJH?=
 =?utf-8?B?bUFFamk2Z2pNdEV2cU5sUHpCR2JScFgyNUU4M04vOWVCR3c0N21aZHFKQkZZ?=
 =?utf-8?B?VnpDM1gzSGZYRkIyNmhKLzhNZjY3Z0dYdFgzUGd6OTc1Yk84WGszWjhjL0pv?=
 =?utf-8?B?UDhjNXJlOG1KWWkyVDNmd3lkMVc3TnJEZEUrQXl2cXBIN1ZsanM0SnFwRGpS?=
 =?utf-8?B?SEF6SHhYK242QkRuY1M1cnl5WURSVGZzN21kajVtNHhBejNWYVhJc3VXaWVR?=
 =?utf-8?B?M2VJa0xGSEg0d1ZVUlQrSWZNdFJiTzhhYWZwOHN6UnZGbFIyNlVPTmcySjVq?=
 =?utf-8?B?MGpBYndZbWUwcHorUDdwUkNVVmhDRTR3MUp5VFB6UFJ5NnppOXdrcklLK2xZ?=
 =?utf-8?B?YjdUZ3R6K2ZOd1F0VkZEZm9vVGI1a3hRU0g2QVhTOWVRZS9QbEtWSDk1THcv?=
 =?utf-8?Q?NMmiOZSK++3xD+y0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51E9C442CEA02D4FB10CF3BEF7C24A0F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: NRvx8edPCVHKPoCkCacakvmAU2HvqpPVYJkjE4lTiN+5y0vPIznJeO2yG1SOTinRw+aO2t0JQ4jehtQlFVKpTvLHis6yKRX8ulMlx8/jKGFkZgcmmEF3VK4OfFciEViqSEVX/T+4UTISQTuBMGOQLND28y2yyd0VLRNx5jVFhK+Uf9QburCckBJP4GsV1SahOU0KrTs3Sm1o6TY/v2mxUcNCLTSGcyZnDBnt/HVa6obkYwj8XSPJQaQ6wtjO6zaqTIDSQDolM0/XkpJdRdlV7KSiij6Rf2EVLAj5eh+YVhuowKt1dgtPBRrstYC3ULVqgu2ryM8LLY2pP/v7ZyBR/w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175a2a09-eed9-4031-78be-08dea9be31a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2026 09:19:07.4434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mlb44kdK2myT4yHyqHTxgeL574/XvvLtBhksnoHoaqp6PjTdCB07Gh6qWSxIDO4VRg94j8RtOQme8ni1TL9GSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6622
X-MTK: N

T24gRnJpLCAyMDI2LTA1LTAxIGF0IDA2OjE2IC0wNzAwLCBDYW4gR3VvIHdyb3RlOgo+IAo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy10eGVxLmMgYi9kcml2ZXJzL3Vmcy9jb3Jl
L3Vmcy0KPiB0eGVxLmMKPiBpbmRleCBiMmRjODkxMjQzNTMuLmZlNjQ3NDUwYTdhMSAxMDA2NDQK
PiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy10eGVxLmMKPiArKysgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmcy10eGVxLmMKPiBAQCAtNzQwLDcgKzc0MCw5IEBAIHN0YXRpYyBpbnQKPiB1ZnNoY2Rf
c2V0dXBfdHhfZXF0cl9hZGFwdF9sZW5ndGgoc3RydWN0IHVmc19oYmEgKmhiYSwKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGFkYXB0X2wwbDFsMmwzX2NhcF9sb2NhbCA+Cj4g
QURBUFRfTDBMMUwyTDNfTEVOR1RIX01BWCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihoYmEtPmRldiwgImxvY2FsCj4gUlhfSFNfRyV1
X0FEQVBUX0lOSVRJQUxfTDBMMUwyTDNfQ0FQICgweCV4KSBleGNlZWRzIE1BWFxuIiwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBnZWFyLCBhZGFwdF9sMGwxbDJsM19jYXBfbG9jYWwpOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiArCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghKGhiYS0+cXVpcmtzICYK
PiBVRlNIQ0RfUVVJUktfRVhURU5ERURfVFhfRVFUUl9BREFQVF9MRU5HVEhfTDBMMUwyTDMpKQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIH0K
PiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gdWZzaGNkX2RtZV9nZXQo
aGJhLAo+IFVJQ19BUkdfTUlCKFBBX1BFRVJSWEhTRzZBREFQVElOSVRJQUxMMEwxTDJMMyksCj4g
QEAgLTc1MSw3ICs3NTMsOSBAQCBzdGF0aWMgaW50Cj4gdWZzaGNkX3NldHVwX3R4X2VxdHJfYWRh
cHRfbGVuZ3RoKHN0cnVjdCB1ZnNfaGJhICpoYmEsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGlmIChhZGFwdF9sMGwxbDJsM19jYXBfcGVlciA+Cj4gQURBUFRfTDBMMUwyTDNfTEVO
R1RIX01BWCkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgZGV2X2VycihoYmEtPmRldiwgInBlZXIKPiBSWF9IU19HJXVfQURBUFRfSU5JVElBTF9MMEwx
TDJMM19DQVAgKDB4JXgpIGV4Y2VlZHMgTUFYXG4iLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdlYXIsIGFkYXB0X2wwbDFs
MmwzX2NhcF9wZWVyKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBpZiAoIShoYmEtPnF1aXJrcyAmCj4gVUZTSENEX1FVSVJLX0VYVEVO
REVEX1RYX0VRVFJfQURBUFRfTEVOR1RIX0wwTDFMMkwzKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFM
Owo+IAoKSGkgQ2FuLAoKVGhlIHF1aXJrIFVGU0hDRF9RVUlSS19FWFRFTkRFRF9UWF9FUVRSX0FE
QVBUX0xFTkdUSF9MMEwxTDJMMwppcyBkZWZpbmVkIGFzIGEgaG9zdCBxdWlyaywgYnV0IGl0IGFw
cGVhcnMgdG8gYmUgdXNlZCBmb3IgdGhlCmRldmljZSAocGVlcikgaW4gdGhpcyBjb250ZXh0LiBJ
cyB0aGlzIHVzYWdlIHdyb25nIG9yIGludGVuZGVkPwoKVGhhbmtzClBldGVyCgo=
