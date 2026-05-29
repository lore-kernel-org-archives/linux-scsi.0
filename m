Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB33BBA1E;
	Fri, 29 May 2026 09:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045728; cv=fail; b=iEvzMO+dwHe6BGwPSrBtAa/OkHk+9dwFC/g44fZQht1VoJ3gm8ir0BavXfdZOeUPDnhsYO/czGFckgbd8mwSQDsa4PxVZdUnHz7UGyAUcF9aYAkyYyMBFTV2ngaqPV2Hm1J/EN4c1BNS1kQaK2B8I/zB0Ubyz67L86MRmwcrOpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045728; c=relaxed/simple;
	bh=kNcRL2Wo3zj2VqjSnQw14y23Y18mXaspvVu6xJLvnAA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ffsbDDS5A+QV12RL77+6K8CbJC6v0x9KmfQWRhl8eCyfLnzVeL0zFZWF2oaF384UDetpJ9rxqfGemmLIDsLdQQNez09CBfpOnmQ85A+SiGqodvO6Q3DboVNeQAcqsrMLQNIQ/HQii5CXj4uISvOMFn2k+Jc04E1qHsb6LmykU5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=e3K6eFj8; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=kfSnjxpG; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="e3K6eFj8";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="kfSnjxpG"
X-UUID: fc01f1485b3d11f1b1788b6acf885367-20260529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=kNcRL2Wo3zj2VqjSnQw14y23Y18mXaspvVu6xJLvnAA=;
	b=e3K6eFj8VE6mdCDzsoGFiWnIeg6nxujf8+GkUK2y8yEmb4wNbFBXFS1R3euTn6Elhp8+NxXxYkKm2vTmipvDjqB4tNyXZ/K1fKvdvxHuyIHu+z0gMVAb7ykk7mER1iB6j8zoTvAPr7IrlMr6Gp9JPsqxdlpQq8dRLNOiGMilyHM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:51a8f041-d54b-4603-b303-4d26882828ab,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:6fd56dc4-5add-407f-ad5a-263b1cb638e4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fc01f1485b3d11f1b1788b6acf885367-20260529
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 646288465; Fri, 29 May 2026 17:08:40 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 29 May 2026 17:08:39 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 29 May 2026 17:08:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTzJdAYH3jFa84GGTh8P/uj5JdSJLP3CGA1MahAdwKiU1euSYydD+wRuCtCcbdrJRTm4oMYpePDOyG6DJD6TrcNrB+w5gmB1hk0eW4V1NO7sbFh/1JpT+pAEIjgv9/E71pE0VYDgOo80UccXuy0+s3aYOOyE4c7IS0IJLUE6h55oMa0KqJ/TlsaLIeNdyr+eTRZK4IfVVQhuZpS52H0xbcjZ+JgrXUFlxIsi6Orn0Pe+Srhi4yqvcyRZ50AMfEE4yx3RSQLurHhQD9/qmvXIlOseTq0TUYMyYCWqVCGl1Ss/WgGpvfbnlZi00MVNZR6acacXNDU1HWtxWRykfhAG7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNcRL2Wo3zj2VqjSnQw14y23Y18mXaspvVu6xJLvnAA=;
 b=C+3eNNqZ9oFiyDSI3/FD9rTTBMxPXwC3/xs18OpH4rQruKT68JABYcH19xH27aruz78B5hiqlHywFnuvpocJu3MlPYSYkS7pfo74E7eHjD1DL+VVpFnPpX5tywtKTniPVwdSOFbjwvxuR4u5LdgUf4QZQGgsyOw2wUA2S9tNGFkJVG3FpS+IUWJg8illrDJEBQahkK7sx2FjFSRCa7SB9fk0OA23njQx3KPFwojodnCLVYtJ+hG192VdWm4FVsBV2LpoU+8u+JJHY39dxEawJ89HCsOojgPHZ8Y51wbP2rqvqNin7Ga5mRDrwOsTutkTV3GbJBDbwWv9n2lsA21N3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNcRL2Wo3zj2VqjSnQw14y23Y18mXaspvVu6xJLvnAA=;
 b=kfSnjxpGqotcR8GAttSZmd0T42PH1U2CGR+Zbutp6OGtroayYuQG9yFl3/xgBGjp7w7tpGS/jc6HRh6d8BlAK5ZaYaWRE/DeJ9QQ2e6EGYHGoW+K1X4X71K9FFh7Fs7GmqslhcrxzE9tBcIYO2YCi0EeQ8D4ERtygkE3VWtomO0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8740.apcprd03.prod.outlook.com (2603:1096:101:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.5; Fri, 29 May 2026
 09:08:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0092.004; Fri, 29 May 2026
 09:08:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>
Subject: Re: [PATCH] scsi: ufs: Remove redundant vops NULL check and trivial
 wrapper
Thread-Topic: [PATCH] scsi: ufs: Remove redundant vops NULL check and trivial
 wrapper
Thread-Index: AQHc7zLd0AB9t0dt5kyAMTJhBq3dWLYktwsA
Date: Fri, 29 May 2026 09:08:32 +0000
Message-ID: <1fb30c7002a684420b7612a1cb490d82a5c84fe6.camel@mediatek.com>
References: <CGME20260529061727epcas1p495c499c91420790a225e66263f3fff52@epcas1p4.samsung.com>
	 <20260529061623.301291-1-cw9316.lee@samsung.com>
In-Reply-To: <20260529061623.301291-1-cw9316.lee@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8740:EE_
x-ms-office365-filtering-correlation-id: 72f95746-8b59-4d79-6de3-08debd61db87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|18002099003|38070700021|921020|56012099006|11063799006|4143699003|22082099003;
x-microsoft-antispam-message-info: WMsO0/CJAR+Ggn23F1TPlCU0Bu026KnsHga+xT/VNAWXZTlnnqdzFZMgdo8hziU02K/h4w7vkGZiSPM+WqDXBIKmYej+v2lfArTz8Y/fw943vVKn7p5zKYL2GBN7ozSJ/loVQoXO0LdF3GmOgIKxCjKyRhaRYkWi5ZEdtnyw/Mapzyi7BO82e16XHLvHnDnP2o1ywG+128cLGq114kTpaBk1RsrjMBvF1FaGGruM0eqSmsDGhixlM8xRREP6SGINysShEdJSM86xQRcgotR73J21Aqomd0mGg9y9WOBKC7hyN+WJCm6sjVByXChAMfj1NOPK19orjjdOBcEgo708C4eUWTolJRDUlabnkUhZ2K/iVrg2CeTGWgt1i+o5MNiMwdXNbhJU/0LsZ7LgN2PDf+tfHhkKMcCv+x3IBkR8HU0aLEaX+C+kGUWvzJG1c86QQ1IU/bdjObrxrGYGB5+n9Qnnnw8Cp+Kxz9L62fYzRlTy2C2fcjyBzgqrC6C2URrPwlGOH0jgCastOK+vRG/9riJb9HB2wkWHSKGO5R6FRl8uPploYK14Dtzw5hwMYI3rdsfpkCZqchN6ggfkgJfdWiiTCWCsoLMgdTdO9kMeXyC8D8HZHUTxkgUDlCLNFaheHgRE1EzAykq5M4n191qvesRw+KjGwuEdCHpBj5yy0rYRrqYDhJ+jWXtXfS61hzlaEw32Nki4Q5g6+BBEYuHBR1ZPEp87w0rs4d/bClrrnVawMd4GP+XUQdJIHDWqJokErNn63W0bRqOGfUHK+aTaQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(18002099003)(38070700021)(921020)(56012099006)(11063799006)(4143699003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1FkNVd6V29rT3Q0bFpBVU1ObGtaMzdiNkdHTFBnK3ZNd25CcGtsRXVjekVO?=
 =?utf-8?B?Z2NDMTBvUU5JNjBWS0pSbDFNRjhING0xUDZDc1lkdllPOUVacU1LNjQxN1hv?=
 =?utf-8?B?TFNKdVFkODFKTFFsN0t3OHZiMXhlbjE4YmNiYmorSTlubXh1UmlWQzk4NHl1?=
 =?utf-8?B?UFpNcnpQbDFqVW90aWNzNlhqSGFUV0l2ZFZ2TkluQ011blZRZ1dkVThkeHFT?=
 =?utf-8?B?MmxNemljTU5yZjU5dDJsenUvWHJlNkc3Q29uYy8vUmwvbDRtVkVrTWdZcmhO?=
 =?utf-8?B?OExxS0Q3eUxmR0p4OFkxMllucm11cGpvTHh3T3JuMTk5Q2JLS2RnZmVBQmRI?=
 =?utf-8?B?akZMd2JZY3VhSkRQS2VOVm9URjhVWDFOL3UwUklVMldOa0o2SWlSb01UQXBq?=
 =?utf-8?B?Vm5XRUtYbUZDaENaY1FPMlozQzRYQU14REV4V2c4MjJyd0VVS0JmYUhzdEt2?=
 =?utf-8?B?MkZZMUorb2o5QWUwbW1WYkI3Um9CdXZSK1FhSDE0Q2krOFpXMU8wZXQzS1cw?=
 =?utf-8?B?S3FCN1ZpRVBNWkRaeWd4bzkwYnNmYWhyeUpob1lVRWZpdDZ4bDJVM2JuZ2hv?=
 =?utf-8?B?OVE0alJCRFh4dnl2M1JaeDk5UTFzM2tRVDVpbXFiMFlsZ3p1MW9Ldzk4N1NB?=
 =?utf-8?B?cW9saTZQQlpDUFJEK3JtR2lDWnptNFhTL1RTdThNRkJkeU9JcG1jcmw2cmNM?=
 =?utf-8?B?dkpDRVFVeXZma1U4YkcrM0RFM0RBZnVsYzRQb3huSllUNkZ2OWZ4eUt3UnBB?=
 =?utf-8?B?TGlvNU90MDRXMkhPd0tmeVVESi9sd05CL3RkeEZRM0M3UG1GNDJ5bTNTaDdW?=
 =?utf-8?B?dTNxTEdqVytNZ1Z0TDB4MW5IZjRDMm1ZVEVHb3J4UmFHTjJuOU1wRnMvaGwr?=
 =?utf-8?B?eGgwQjVNMmZyR3dZa3RRd081Qjc4NXlxVGNlL0NpcmFmU0d6K1FmUGg0cW1G?=
 =?utf-8?B?Q3hkRVF5V2VyR0I4SkhjZ0FXaUdIZ1hTQXBoTFBZUWdKa3M2OFN5eWgxaUFV?=
 =?utf-8?B?Z0pJNFBhYlhtWEpuVVNrTEZhQzh6S3AwYklYSmMvWVQxcUpYdUZ6MXUzYXRX?=
 =?utf-8?B?cHgwMlZvYlVvNGs1VzJES05CSlpFMUttUW5KVDRTWmhYNGtCUE9mdFJ4cWo3?=
 =?utf-8?B?Wlo1WHZoQitWVWhpWWFjc1JWcjBKS3FLdGhHdDVmVDZWK3BWRGVJSyt5MlJx?=
 =?utf-8?B?dk1yandzR0FQWkFySm5yRE4yUkdYV21QZWxHd1FHQjlBUjBuUDZkUGUxYWhr?=
 =?utf-8?B?a0tqNncrYmdXQk9pNks2eXFHN2hMakpFVWxyTWptWTNlNEl3aDc4RzdMZFNx?=
 =?utf-8?B?WmxUUnNLTDJBYllVa1M2ek9BWEoxcTFOcWpXTXJ5MDhrWGZ5dnk3M2pTSnh4?=
 =?utf-8?B?cC9BQ2pPcCt2U0FKdDJkUUVLcW54dElNL0YzeDBndVZ3N2VZQkJtb0lEUFQz?=
 =?utf-8?B?aWRVTHZ4a2tMZStMS21Heko3VTlVZ1RtWCtleDlFRGxjNzNGR2lvYXhSRVFi?=
 =?utf-8?B?ZTNSdWNweXV1bFh0NS8wbXJuQUhOQWd2UGxpVS9namdkZDBTK2pTUmNWK2l3?=
 =?utf-8?B?aU1ZcDJKejc2NStySVdjazcvdStKQmNYVHhLSmpMZjR2V2xMbjJJZ1ZtLzdY?=
 =?utf-8?B?SG9MQ0xZVkluNVp0K0NNM3lhbXU1MmZEMU1YSTNqVGRSMStzbURmL2twZmpT?=
 =?utf-8?B?V0t4Y1RUYW9vOThkTVRyVkNzcnZDUzV4SkJodDFhbFBSaGFHMWpHNnBHNmI3?=
 =?utf-8?B?NHVYK0VrUWVpVU1ISlYwTzVaNm1DZjQ5UXZLQUNpYXRWaElsSnZIVnpxT1M3?=
 =?utf-8?B?ck5lVnVmRkgvOVgzRWZUZjFPck1XTjlQSHExTURiOTFpQ1R1c1pORjVYTFY4?=
 =?utf-8?B?d0x0T21lTDIwcGdGdksxcUl4SUoyRHdwd2tnNjNPL0xBVVBHc0dzOUhrK3I1?=
 =?utf-8?B?VmFUNDJlekNlb2E4OVB4STVjQWJ6cVZDZTA2YlVBcDRxelREcXpsNlRYWWRy?=
 =?utf-8?B?aUxzQ0E2d2ZLdUxQY1d0Z05haHc4bE9sOGlmRjB4cTNQaEJiTDVaOFBNK2dh?=
 =?utf-8?B?Mldxa1JOeDFtRDlQTW96VE55MzNTQkhqSDgrOG9JZXpTeUN2bi83L2wrZXp6?=
 =?utf-8?B?SFBibUNnaVJEOHRUU0tuS2hPYk53OE5vTWxpTzBhWWErY0RSSUwwTWV6TDQw?=
 =?utf-8?B?YTJyUE1ZR1RiRVlpdFFVM3F2OHUrdTVsNE44K0VEYnhvNllORWp6M1M4dzla?=
 =?utf-8?B?TmFyZ3ViWkoxQTB3T25qQ0RTTUJjNWxudEl6S3dzZHNCWWtvc3NqS0o2bFZB?=
 =?utf-8?B?SGlJb2FjeG1TaWZDZTdkUGZGdmk0dzRYeU1HUzhjYW1tRk5nNFY2TW41MHpH?=
 =?utf-8?Q?J1HF7B4Ru86ZfWG0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59A16568EFBC064183B91DC6C4329CBE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: RB/t6toPEbcb2BT+fP4niN9lobqgKjjaZLIxPtFWS8Q3DzCyrki2ArfM4o0x7LrDUskdzenuuTpU5KTPJjzGKKsJz1Vsm710PhE7SjCllulDpDH2Af2qN95TDw8TI/TGqtFIpCCtRRTskwuPFX2IggTjpwTM28hiQMP4RTQvy49R9ofQ7kut+VZwRWjCuNWa85e/nYnuV58XYJeZa6G4msMssp3HbKl+k6VUUW0ZO/tHHZljQ56nV2UFFEQ/wlRNKhJUsJlIdDmRJ7jFCvWmB0HjFaWaJEcgkw0/xxHPSC9AdDM9h8e921xnwt7V3QgdzeKhauIH1vgMg5J/i6nfTg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f95746-8b59-4d79-6de3-08debd61db87
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 09:08:32.4972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 13zd7OTymqd8ll/ZFFtLytN4tmVhcD3KiFJEAN4qX5hK2YA2lTWO3d46V5jBr0SUWoPL+GcEXBOWHbPVG5uUIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8740
X-MTK: N

T24gRnJpLCAyMDI2LTA1LTI5IGF0IDE1OjE2ICswOTAwLCBDaGFud29vIExlZSB3cm90ZToNCj4g
dWZzaGNkX3ZhcmlhbnRfaGJhX2luaXQvZXhpdCgpIGNoZWNrICdpZiAoIWhiYS0+dm9wcyknIGJl
Zm9yZQ0KPiBjYWxsaW5nIHZvcHMgd3JhcHBlcnMsIGJ1dCB0aGUgd3JhcHBlcnMgYWxyZWFkeSBk
byBOVUxMIGNoZWNrDQo+IGludGVybmFsbHkuIFJlbW92ZSB0aGUgcmVkdW5kYW50IGNoZWNrcy4g
QWxzbyByZW1vdmUNCj4gdWZzaGNkX3ZhcmlhbnRfaGJhX2V4aXQoKSBlbnRpcmVseSBzaW5jZSBp
dCBvbmx5IHdyYXBzDQo+IHVmc2hjZF92b3BzX2V4aXQoKSB3aXRoIG5vIGFkZGVkIHZhbHVlLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ2hhbndvbyBMZWUgPGN3OTMxNi5sZWVAc2Ftc3VuZy5jb20+
DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20+DQo=
