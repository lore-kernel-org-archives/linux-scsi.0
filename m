Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C4B3644CE;
	Thu, 26 Mar 2026 01:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489972; cv=fail; b=sWhURCZN136yMN/z51fzmQECpvj1mVEjBB2VQbhslFJE0pZNWiRNyUGYKZBLZyGnqvGdbwEgNHoyN+BkhxdDpoPH0udfEyNj1ukGWRiQ7El/ObYcdExMAgCrUJsdkQ69k6uL2S57JjrslGhau/cKW0UCbcIae0fiTp+TpD3xfxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489972; c=relaxed/simple;
	bh=/t6/KAZEXrvdMCLQXK2uxzwdIARPmI2ZyEwbu7yNork=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RYNaV7NgNjD4VACjOPkFTutz+44baLhAtqoATiDLxy7Mb0hOlaID96E4BVy70X/ulgvHx4rLF+PjnUv3r0hfCicMzK1XhN3xWMnHj1HNbFjD5tUsXhxJUTafd2NcVqqFhq4rnMixSrHPSu1xLIMVG/rOoqAO/bbxcOxpJN++xVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VUwSJFOO; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=lMz/bA5Q; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VUwSJFOO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="lMz/bA5Q"
X-UUID: 7b77fab828b611f1a39cd589f645bc18-20260326
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=/t6/KAZEXrvdMCLQXK2uxzwdIARPmI2ZyEwbu7yNork=;
	b=VUwSJFOO4j58iqTbNuiSm536kXmrvq7tAdFTaaUNeYuniXJamY4ndHO/Ay3UmcysyxgpTofiWQCvF1iKBmHqinV12PFH0UoKiJ4Cl9SR4ZjhjARdOktZsaXPlR8tyJnRpevPLDf7S1wiXXgFdzdhiecuboI0+0irWpTiNUDc0N4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:53c387bf-3aca-42d2-9269-4fa4a9b78b28,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:34b8b38e-6df4-4a3d-a7a4-fbdc42d669ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7b77fab828b611f1a39cd589f645bc18-20260326
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1141007199; Thu, 26 Mar 2026 09:52:44 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 26 Mar 2026 09:52:43 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 26 Mar 2026 09:52:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTARxPrC31H0/2H585J2FYCgrGITAXZpKnkoLpnwYWjH5E4MTwnBpZZypwIB6EhnLMb7HdVeYT2hJa8pXl3O/uHenRasb333rpLBHW/ZJKH397Vn0hCqOZehugQxywqcNRXi78fXmWR+7N5TLTEjxVraKRzLb+d3zmwTYvmO3ohr+89bA5M9wb6RG5t+UkH3TbsVzKCh+qm/1LaPJAvcbdiMSi9T0ug+E/tNWs/UxDrwjwkWX2+Zfd8KucFOa7KQjFgC+tKVqF+e6fPNTKsyTjpWd6TqMw0fCf/ppwljUiAel7qSdT9zwEOIu0vHXL0JXkg6oX+9s6t6RCWPFiU4pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/t6/KAZEXrvdMCLQXK2uxzwdIARPmI2ZyEwbu7yNork=;
 b=jNRt4qJROOw+HVR2BSma+rWjQVIOvRoswMedQ2qy+/kLERPDaiQmcnO8i7DpTnq1CDb1kvrSk1OsdS3CzhppmKazuIWGCf5CMkSQQX3ZCUyOBTf2+YgBx+liuTsIpSRusvVyRKDtkzp2kR80cm8T6gNDY+GMf+FdFFkTOZMgoE6CE7oJyOJAOzZBgItYubPrmyY4uEtPVyqS/RuX78fjLot9k6pbYZ/6x0q4rQpvhFpU4kmemXbOrOctc25IfdlwITD7tcfKwsSXakDstTPIvjmRqSnuB3mD4piIgnDUnGaBJGDS/ijEqbL2d0tU+4h3BHa9U4PixMCzhKtSAc2U3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/t6/KAZEXrvdMCLQXK2uxzwdIARPmI2ZyEwbu7yNork=;
 b=lMz/bA5QtORdz9TAWEqH5L70uT5ZsOhjTgzbJUlGAotIiWFfuhJrxGjazovKNZg11GafUxmrRvr34XLRIaaNUPoR6ryO+c+q1/ULlKlqdP/Pzz6YQttVzj8dqXG6oEy1X5CaD88exAVGFqe8vMJuptKtJxD7NTfg1P6dgMoXczU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6590.apcprd03.prod.outlook.com (2603:1096:4:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 01:52:40 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9745.022; Thu, 26 Mar 2026
 01:52:40 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v5 00/12] scsi: ufs: Add TX Equalization support for UFS
 5.0
Thread-Topic: [PATCH v5 00/12] scsi: ufs: Add TX Equalization support for UFS
 5.0
Thread-Index: AQHcvGtBqh7DsE17eEiqcQ495H0kHbXADZ2A
Date: Thu, 26 Mar 2026 01:52:40 +0000
Message-ID: <d3bccdb0715cf4ea85911d79a000fabdbe99f7a6.camel@mediatek.com>
References: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
In-Reply-To: <20260325152154.1604082-1-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6590:EE_
x-ms-office365-filtering-correlation-id: 9db469cd-5da1-4a69-1bd6-08de8ada5d35
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: RPiv3x8dJyOpdCxTi0/3tdfRBvJEINteQRlwIK3hNlMuHz/yoCNFeZhvc1mn1zrsxqFdbVogvmk0gvDTE5SWKj2SSwFAlwy9ugjtaLsCn4v3fSskczezBhCxmVrJuhUmroW1wa1My2ejJMO9SFCqV+T/Uh1I6N852zRKuVUMeqPSSxsT0Sr2AFuHxNUSqCfCuQBkMPwlvHf11g3/ztYoqWsamOyOOrgdVDBlUJeuTon7n4vpe3UHFIdf//ed4DvGgM54dVmhHTltrtroaB0Zd9r/Z0zKf8T4E7tpib6AqXcgbJlXiHyzTKJOW5+B49n4DwyHHHNMEgYc5+fUaokL2i9BwyJ7WrrmQEGnKttwRv35STSoWht9bJT3bnLmImhbYUvyg5owJN9XrOA53zw7qmvWeVIMpG7WDIzh5vBh/fmkh12FRiFQuL5B5o+Qwalcd2mrtp0KUqtao9FeFbzUDh4iC1Z8JOLlJr7FTYJgrdBfc85taGCJ5lP4O2v3rjozwhy9qQiPBlQmshlV6E/5aHANbzrGsy3y+vYeJVBJYUq6GlK8NY4WfRLUchCpDTfTbeXIzrZDkZrQEcJeXEN8pCRnYfwoEJ2PppXsAS6Qmh5U+oBidSpzH0roQKA1v6NGRLNYZ8wqNKV0vjmUsuhxqafBEMOsI29N4kEygU6eVjRoZUGfIfUYI02ob4exgjsTuucwD0C87ErlARa1nnMrI6JZd3fzZ/4XB2ssux3N7e5NEGNHzrOUp1tvhgsenlMy35zXU+R+mar+wPa8HQIAoRGQsLPurcHjdDMegM+FY9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3d2Q203dU1kcUFod3JxUVNYSndFWGI5VnlrSnlpYzJtbHQwQjM1S04vaGg1?=
 =?utf-8?B?NDZmR0RNZlBZbmVvMmNralQrTWxiWDZYc1JXOUpEWjZxcGJ2Y05kN0hmTnRt?=
 =?utf-8?B?NXVpbC9GR1Ezckd4M3R1dEMyMG9qbHJ1SDhpWVVML2JUU3ZubHhkVWxadFZu?=
 =?utf-8?B?UE0rZnMyMjRJSDM5RzRzY2VrdjJ1RmtsbzNuczdsWUltd3dON0IrU25wV0NK?=
 =?utf-8?B?OHIvMEk0RitTSWdnY0RiNDlKNkFqTUtYekpnQnAyOUtlelJ5dHBzR216NmF1?=
 =?utf-8?B?Q0NwUEVXRHdFMGFObmh6MUd1YzBWanVtUkRlSHVDenlOYWZ3TC9NalRBc2xh?=
 =?utf-8?B?WjVvalluazZHSGJXdWRjOEtXTkZUM2RPaHVVem5ZL2VOZjJwTHYyT1FnVU94?=
 =?utf-8?B?cHBhaU9UZVNlVExTT3B0T2M0ODNyMlUvblE4TWpETGl5L1A1c2lJVVFtZUNw?=
 =?utf-8?B?NTV0WGI3aXpveEI2VjBucTZYK2ZCM0lhbnpJSkZXK3lLaVZTN1pzamoyUkZF?=
 =?utf-8?B?TkRZalRMVzA0eWJxN1hrWXBwa3lwUG5scTg2eFc3TG9PVTdhaHcyK1E2YXVT?=
 =?utf-8?B?NllKQkxvdVdCVUdPNlVOdFpxcTl3T1pZcEFlVTgvdW1qRjlWUC90V05zaEN3?=
 =?utf-8?B?bzBmZ25kaXRqdEc3OStoYXljSTJaLzZ4MjNXWGwyckU3VFk1QXIvTTJ0LzNO?=
 =?utf-8?B?TGN6cGQvNDkzYWY3ck52OTRnMVk4NWJ1S2UrRTQyMVN4QUJsRWNNYWJEOHpv?=
 =?utf-8?B?ZHhybTR0NVlyUVRabldDenEyaStPRFY3UnNNNFpGTjZ2a3BqY2VGVkVWM3lr?=
 =?utf-8?B?YnY4QXEzY2hvVW5PVC9IOGpzWDZFN2NmaDVWMXZwazNtL0VjK0VNb2tIMzRG?=
 =?utf-8?B?VTZLazNRemtwL0hDZEdKZFljUGd3emJZT3dzYmh5dzZRT2FMMzF0UlFRMHB0?=
 =?utf-8?B?a3AwbTFuMERNN0xrZ0tqelVTcXNkNXZ6WTYrSmJIWVJ5Tms1Ulp0N3Z1YXZz?=
 =?utf-8?B?TDFmQ0ZEQU90RjJVZ01FTE9Ec2gyTGJFUGlGb3ZaY1RjN05CakI5VGRMT1p6?=
 =?utf-8?B?YWpoMG9oZnM4RnRSLzFIL2kwTVBGREhjdWZIVStySVhtbWE5Z3JvVjFMcnpT?=
 =?utf-8?B?TWNBU0EweXZVSnBzL0V2ZkJzeXNMU1dIQkdLVlhlUjJFK05idDJ1V2REQ0ZN?=
 =?utf-8?B?MzR2UmhzSnpPQ0Fkb3VTbnlmckVSb3JUOFhjckRwQ3pXK1crc2ZHc1Y2YTd2?=
 =?utf-8?B?NWxHSjdjU0lHNnR6OVBZYTc5ZEZOODFrd0lyUFlWMC92UzJaY3ROL1BUN1Zr?=
 =?utf-8?B?aG9DdGliMnNWQ2VFSFRSOUJ1eFBkbE1nZ1VMS0xWVTJmbFliNE8vOWc0Nlho?=
 =?utf-8?B?WFdQcDBsajFmMXNaL0NHMTF6eGFHeUFYN1l4Y3NGQUhhK0VGbUV5Y05ZMWFE?=
 =?utf-8?B?bHdwTmZJd25FWnh0aDlzOTFBTmlGeTlPaVA3R1BiZEZBY09RZDF1RlY4ODBB?=
 =?utf-8?B?WjNzdFI3M2xiQy9zc1R2Sy9UaTdHd2d6OEdzckRkTE9yYy9VbnVWZW5tTWt1?=
 =?utf-8?B?WGxrZEd0SFZLRXdyamNzeE1NTmNGVDQwTXgyK01DOHNQTFV0TzM5V3o3cnE1?=
 =?utf-8?B?aVI1Y3Z4NEZrNzdUOHZKRUFDZlVlNUF2cUtWZkRqU3dRTDRqMFVpckY5NGlG?=
 =?utf-8?B?T3BCY0F5dnFzQUR4OXBqQWlhdmQwYjRqWlQ3bTZMVmp6M3lyUGc4RUErR2JB?=
 =?utf-8?B?NFJqRjNTSG1FL2RSQm03UEV2Wm91azg5a3ZyamU1NFo2YnpTbWNyRVRLZXIy?=
 =?utf-8?B?WkZtajFHaFgwUVVOZmFGdEFLUGpqVXhUeWtZYThFY3lla0ViQ1l6WmxQMTdC?=
 =?utf-8?B?ZzBpcXJpVmxOSE50S0NqeDJ6c01FVTZyaExTdEErVHdVeWhyUTRsbmFRWnVz?=
 =?utf-8?B?eTVIdi9CVlp0Nmh6b2tGMUlEQTFlOEszaTVWNnlGbWgrQ3ZVcEFkMXN3NnAr?=
 =?utf-8?B?d1cvSEx2aG5wRXlOR0JlN09Xblc3MG9GUHdDZ2ZvbVBrSmNhSmxZM29BQnRh?=
 =?utf-8?B?L0VWZTlNQURlTWUrK3VxaFhCS0dOcHFGM24ySEkrVTBMVmEyWjR5OGhGNjk5?=
 =?utf-8?B?enEraVB4czF4TUtKNkdaNlZ1QlJ4ay9PVGlhNnREZkRQcFJqTHF4bnl1QUl4?=
 =?utf-8?B?cU9naUUwT1c5ZHE2UW56cXIzbGxURlVLczR2WUt3ckFKc05aYkw5Z0FzeFho?=
 =?utf-8?B?N3NvQUZBazViNjdXbGxMQ25NSWlUZFh0LzVkMDVMbkdyV003TGo1amxKZXdF?=
 =?utf-8?B?SnFRMGNCMHpCdStVRVJkSWdNRmx5MFFLN3VDbVZ1bWpNSTBjRzd4SUdETklz?=
 =?utf-8?Q?OQdMfgsU6Oeybq7k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA6192EEB71E2C43BC8109FB8CE3DB45@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: l/1xb/bDSbhPTZWU+BK/Tm/bYUpKkKl+S/qnu5IhhihCGtS9bOkTF+IONJJv5o2kG0Eou+T85o4hBhephIRodjZjTd4OiUxM/XavLdkcaYAonnWK2ZLIjKm/zYYzg351dGoEFg8CV/DVE2tfIc81e9ur0SPhSlcPicuDblE+OKa+011M7CdUMrX3jedX94/bODKpHt7ReSEVi80PSL4nv1PUI7Xk828x/iK+zKQYk76kQnCZfGogpOxSX5HoiN5RRPRkcWSRvgIMD/VxZYOAkSmOMW+KtAwB1K2ChM34Aj7pPh8guHYHtJJV3JUFWERpXLjcInFHMz3Wtt9aWU8y6A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db469cd-5da1-4a69-1bd6-08de8ada5d35
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2026 01:52:40.4054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FECDt6+L2GtrHNVicc2HjytTxEaQHOWV6WvLBimPOwNz0sv46sS9HS1n3IafeRc6cuwUhAEQt19UUvYoIyt0vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6590
X-MTK: N

T24gV2VkLCAyMDI2LTAzLTI1IGF0IDA4OjIxIC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiBIaSwN
Cj4gDQo+IFRoZSBVRlMgdjUuMCBhbmQgVUZTSENJIHY1LjAgc3RhbmRhcmRzIGhhdmUgcHVibGlz
aGVkLCBpbnRyb2R1Y2luZw0KPiBzdXBwb3J0DQo+IGZvciBIUy1HNiAoNDYuNiBHYnBzIHBlciBs
YW5lKSB0aHJvdWdoIHRoZSBuZXcgVW5pUHJvIFYzLjANCj4gaW50ZXJjb25uZWN0DQo+IGxheWVy
IGFuZCBNLVBIWSBWNi4wIHBoeXNpY2FsIGxheWVyIHNwZWNpZmljYXRpb25zLiBUbyBhY2hpZXZl
DQo+IHJlbGlhYmxlDQo+IG9wZXJhdGlvbiBhdCB0aGVzZSBoaWdoZXIgc3BlZWRzLCBVbmlQcm8g
VjMuMCBpbnRyb2R1Y2VzIFRYDQo+IEVxdWFsaXphdGlvbg0KPiBhbmQgUHJlLUNvZGluZyBtZWNo
YW5pc21zIHRoYXQgYXJlIGVzc2VudGlhbCBmb3Igc2lnbmFsIGludGVncml0eS4NCj4gDQo+IFRo
aXMgcGF0Y2ggc2VyaWVzIGltcGxlbWVudHMgVFggRXF1YWxpemF0aW9uIHN1cHBvcnQgaW4gdGhl
IFVGUyBjb3JlDQo+IGRyaXZlciBhcyBzcGVjaWZpZWQgaW4gVUZTSENJIHY1LjAsIGFsb25nIHdp
dGggdGhlIG5lY2Vzc2FyeSB2ZW5kb3INCj4gb3BlcmF0aW9ucyBhbmQgYSByZWZlcmVuY2UgaW1w
bGVtZW50YXRpb24gZm9yIFF1YWxjb21tIFVGUyBob3N0DQo+IGNvbnRyb2xsZXJzLg0KPiANCg0K
UmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
