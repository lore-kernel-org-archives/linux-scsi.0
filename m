Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7F9202F7C;
	Wed, 11 Feb 2026 13:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770814846; cv=fail; b=Z+xn3XMjRktzQFDM6ny4hSEoL6l5txqcDapdAvZNsxy6NaBCc5fcKG4MKFqkYPgbLIbIcmaAntbQUT2L3tB271Bz5n8qHL7DSiQOnr1xEq3ra1h0rTkTJa/nxKe2fJ0M5LKsBbMqog6GA0EY8FsqGDf6wosigBOUL9q2m2Psuk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770814846; c=relaxed/simple;
	bh=bdpbekmZVwQ8suYGVfh5nq+S6JUcg1hv4EgB7GdODOk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dpaMutScVa3t1ZT3fouOG02it/+VZG1Vg1J8Hmf9OK2omKq7/aQCURsACgb0MvW4uJ4eUMZ7brgkeH5maz4eKS62Kz/5W2GrqLH6KapO9xIKsiop0pBxSV81f4uHRZ3c2tOEynILSeequ4DyIiKfX/ndYNPHVTCjP8dlHG3Ic9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=swSMw27j; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VTtHfCQ5; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="swSMw27j";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VTtHfCQ5"
X-UUID: a99d0d90074911f1b7fc4fdb8733b2bc-20260211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=bdpbekmZVwQ8suYGVfh5nq+S6JUcg1hv4EgB7GdODOk=;
	b=swSMw27jj1wa99Gh4gg/wqk/zNpqhUfKXZG9/4p3hWEqNWnzGAGm7JdepQh0G6GblDnqPdfAITPAZYGg/slry6+jEptHJI7R4RuTjnV22mnUcA2m09jGNsEEyumO6DgibXaxQr2x6oP8ZeWUZPxjOAtqJnkvV4WQAOZH9tZ7fAg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:cbaa6dcc-8c1c-445a-855b-9eb4d172995c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:6f9f91e9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a99d0d90074911f1b7fc4fdb8733b2bc-20260211
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 710269750; Wed, 11 Feb 2026 21:00:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 11 Feb 2026 21:00:37 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 11 Feb 2026 21:00:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iMGbgQ3SNSAB241Uf7xQKVMRi5IoBwN6c2hI2Uai4EoeMEoAnhdHYlmLt/88QEnTIauh7sYaloifpGcv1tfeFcuDrcyTJ9sc56vNaItR2SIQ/Seo5TLlXeA6gilrTUwo+SvcIsSH04D8z+Dk+VtlukzMhY6tZ3RPGPRxVio7HTV72x7dndfmcpZiiYuRjmw5h+9CKRb+vFW72UwDqQyZutYdpasqHCT6EGTu67A3rG79VgjnYqmcZc9szHttu/GDbB9+bP9UI1tWdrnIXEc4P0mRYY791rKJ28kTLfuI98AVATiIrHWWrbXAkxuertyUUYCvuHG55STDKvJsyc6Img==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdpbekmZVwQ8suYGVfh5nq+S6JUcg1hv4EgB7GdODOk=;
 b=DaIanixEOaCDINtSNhRp9tgPVm0/m46Zlo3rVjUt+rdgxJurgOfgaALf5K82IvkFH3qYOlTexE2LxZsMEPVZ36sMOezY6ZB86MPBci+6MtAIcA++sS6ieyI/x0ooo2SLDyk98x77RpqC12yqcAzPPbeH5rRPNdjoVwdgSomVV2pu52T0499l46Qi0ZNgAcF6kIhGTN8FoPFiYEsE216T0jDTXgl4f39axzmErIzAmAy6TH3JMnlDfad3RbWCK1d4MgQPZY9+xlVlJXMGAcPpC3NA/sgYjU2oWZ/GL6n+RJufFRTzkj8BXDZDIP8hUiO+Xk4h93pb7rla2GZXwpuz2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdpbekmZVwQ8suYGVfh5nq+S6JUcg1hv4EgB7GdODOk=;
 b=VTtHfCQ5Jlzs/Qxqyn88MaMq0CNU1IQOwW1GS8rXph1/lxS/D3I68jVJjyF2BW4zwfOoXhqOJ4HgHm+KR/vK/E1TCSCrlMZiDPtI63JmOiXHPqt9GksskaPXtpMyU9HQOwkze6lDCs/rkxDgm5ziM3li+n7OPWJ70mP2eqNFLGM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8196.apcprd03.prod.outlook.com (2603:1096:820:109::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Wed, 11 Feb
 2026 13:00:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 13:00:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jeuk20.kim@samsung.com" <jeuk20.kim@samsung.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "wone.jung@samsung.com" <wone.jung@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "j-young.choi@samsung.com"
	<j-young.choi@samsung.com>
Subject: Re: [PATCH] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime
 PM power mode
Thread-Topic: [PATCH] scsi: ufs: core: Reset urgent_bkops_lvl to allow runtime
 PM power mode
Thread-Index: AQHcm0M8WxYz6hU7N06FZjnblwndOLV9dkYA
Date: Wed, 11 Feb 2026 13:00:31 +0000
Message-ID: <1d893295d23f59d87ab30e7cd7d2c872fe7c85fb.camel@mediatek.com>
References: <CGME20260211060105epcms2p6631646c964afae761c5d8b93db5a476d@epcms2p6>
	 <1891546521.01770806581968.JavaMail.epsvc@epcpadp2new>
In-Reply-To: <1891546521.01770806581968.JavaMail.epsvc@epcpadp2new>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8196:EE_
x-ms-office365-filtering-correlation-id: 8c5aa042-9a1a-4011-fdf0-08de696d8a4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?dmQ4MUgwYjdLYm1LdExlaWV2UUlLRTBQd2l1UGFYNzUvMnh0S0dlY2UrUlNy?=
 =?utf-8?B?Wmc3SFdhSXl1YWFtN1AxY1hqM2QrMXN5cXdvSkN6K0p5SXVkUEoyVWNHaVdu?=
 =?utf-8?B?SE4rWGJpVkZ5UHREOWphaHdUZzBHZHJIZWYvZ2pSdEt2OWNHRnBFNjdtUXcx?=
 =?utf-8?B?OUtoTFBWQmtBWXZLSlowQ1dBNEJEWXEvRFdDNVMvZHBVRFdyTENYbG54amZE?=
 =?utf-8?B?SzMxVjJHSFlCNGtxSncvYVpXbjZvSnU2SFdMU09NNHNzQzR3SXI0cWxqRTVF?=
 =?utf-8?B?dUxJR25Md3huK2ZJTHBPSkREYSttNFcwaGVJd0dIQ05pZ0k2OUF4aWZBdVhK?=
 =?utf-8?B?MmRMT0UyZjZhVUpCL2R4KzlMcEJLdjFNVXp2SFpkWmJTMk00b0lUR2RxbjBy?=
 =?utf-8?B?akk1amIrUElEM2J6QnlwU1QzRTlWYUFGejNiWDdYbmh0YWU2NU1HdGxhSEhn?=
 =?utf-8?B?UmdHZEpvTTEwRlVleTQrdW9lTThsUDdQNXk4Sld3RVgvVXlUYks3dkV4Szl1?=
 =?utf-8?B?V2dWTys4MmY0d3YrZDIxSWRudTUwZzg2WE9yNWJRbkR0MldpVDd0ZFdNeHRs?=
 =?utf-8?B?NFlYRUNWcEJmZTFTWnRZeWhVVHoxR3VvMHZydjMvbThLbExNTUVxWkw0QVlR?=
 =?utf-8?B?aTU0bThLTWdtZnVyNXFWaml2S1gwMzVoSE1aSEk5NjA3V2dkZlZpL2szUEQ2?=
 =?utf-8?B?RDBOeTlvdTNFZllhMHg2TUowenI5ZmlmR1BMMFA0VHhGTjJWU3FaNEpvYUZE?=
 =?utf-8?B?aUdsWFpFaHplU1RhRGtsQlUrYUhZRnBKSFlOVVRYNTQ3VThFbTBMalBIWlFx?=
 =?utf-8?B?SExMOXlHVm1EWVVGa09XZFRXZDk1UmFGNVlNb2dyVjRFTVhFQ09rejRJaHI0?=
 =?utf-8?B?KzZBQ3ZGdWVhOGVKbkxxaGZKdktpK2RzZDBPeW9ac1gzWlAxa1o5cGtaTEFE?=
 =?utf-8?B?VWI0STlnLzg2ZFU0NW1kT3hpT0QzUTQ1OUc2M0QveDBjMldqa1FiLzRhZVhn?=
 =?utf-8?B?TllWa0QzZ2tWSTNxVWlDRGxPTERROWNnN25QSmJDcDNDT1JUb2FuQUVvQWlX?=
 =?utf-8?B?MmtncFJSNW03WkNmY0dKMHhXeXlkUmg1KzBMZHdsemFVU1VEMDhqNkxpWFd6?=
 =?utf-8?B?NWJYRm11eEZJSXBnMXY4RisvNnhEdlRUVE1lS3V1M2JnWXdQVzU3Y0NGWVRs?=
 =?utf-8?B?K0J5UzhxU0dtclhNb2gxYmlhTnN1YVIzT3cvU0xXWis3QjlGRXhZL2pzN0xo?=
 =?utf-8?B?NzRIbkdkNUFXZGlMTDV2WGk3eUNJSUYvaWQ2U2lhc1Jvc2JNUE5MTDVuTXdQ?=
 =?utf-8?B?VmFWL1FvQ0c1SytoY1B2SWxqUDk1TTJXSnFRa2h0Mzl3L3ZCNWgvSVFraG0v?=
 =?utf-8?B?NmlKWXYyN3pVbE85YkNpVXlkY09GME4yL3FJMEp5Ry9NTXNjUEFlR1IrVVM0?=
 =?utf-8?B?ZEZWVkZ4YU85ejRMVWZheTNZZlJEcGRSZjVOR1U4THVOeUsrNFVFc2poQWZH?=
 =?utf-8?B?ZGtSQkpVelZVWkl0bVJrbFVNVS80NGdUWEwvaFA1d2RKTHY1SW5nb3lnQ3U4?=
 =?utf-8?B?MWRyUUhlbDR5ZUs0aHY5UmY1UDRiWTVHdHNuYW5WVnJlSWpxZlkrMWJVSzNw?=
 =?utf-8?B?TXdxRWJwNDNONkJTUGRIbE14YVUxUWQwbzlkam9ZV2FXZ0tmUUc1eHBWcytj?=
 =?utf-8?B?ak5yNFk1SWVMNWFRVVRsRWtRU3I1MVhCQWZPOU1pZ2JlTzJzQlU1RmsvY1l0?=
 =?utf-8?B?RzFWYXF1bU5tb3NXb3g0Wmhza2dJNk96QUNzWUNxdVlkMnJtMXd4ejViOTI2?=
 =?utf-8?B?MjA3dG1YWjYxUGFLNjdBV0lwa2h3RmYyZ1l1NHo3UW5RSXUwMzhiNXZqaXRB?=
 =?utf-8?B?SGJrS0NPcUh4VVFwYkxYN205R0tON1IwMjgxajN5cVYxT0g5RnJIMS9mZGpK?=
 =?utf-8?B?L3BpQVFYZDVHSU15d0EzZDRvbWhoTVQvc01sZWZXU1dldHc3M2NOUWZ1NWNC?=
 =?utf-8?B?a0dLak1GZXY2YU9nWm5MMGZUbGtBNlZEc3RWcG9QR2VHQ2F0WW16VXBmc1N6?=
 =?utf-8?B?WmFFYm1zVTg3SzIxb0pNMEhFSEdwL0NmdUd3OCs3MXhpNTFTeTRqUEJDWk4r?=
 =?utf-8?B?MHEzQ0xISU1xdzYrN3U3TEdRVWY5NmhlblFMbG5mQ3YzZUZZcTdNWmp2eG4z?=
 =?utf-8?Q?3BrPC7/x1VbbBChxm0kWgpCsgHTpjKWKrHwcw1FdYqUO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2hvMm9sT1B1dTRIcWJrOFpjbExsT2hqY1BlcEx2aC9ZWnR1WXljKzI2RVlh?=
 =?utf-8?B?aE5lRUhOUkUrRGY3UU9hOEQwVE5GNVBnekpjRG1lVVB6dHJIWW5XaFY2dE9L?=
 =?utf-8?B?Mm0zZEtIdERybndpNmk3ZVZrajdVR3ZZb25NWXY3YXFWUW96NzFKeGpHdjZQ?=
 =?utf-8?B?dCsyemVyb3hCbkJVODVGampUQi9IODAvRm9BQlIrdDlvUTJDS3ZqRVZYbzlE?=
 =?utf-8?B?VzUvM3ZMNmlINEtBV2haUDlkUFhDZFRQUHoxV0pXVXBXNEw2M1JjZDBmdDZj?=
 =?utf-8?B?dkJhWHViRW1pVWdqLzJiMjA1YTJmN3FQWlNYNmdMWkdjRlVSWkVwYm5lYW5n?=
 =?utf-8?B?TzBZM0hpTEZRbjBaMVpNaU00UHRTMS9CcFh5eHR6UmdhTWVCR0JhU3hERCs0?=
 =?utf-8?B?MEtwOFVDNE9tRExVOEZFSVdNNWxSZ3N4QSt1aUFpMGM2NXpSUk5rZHBja3l6?=
 =?utf-8?B?TGRkZ3NGeEVvbk9Ib3cxRXRRRDR6RUFTaC9ON204R2tRSHZ2YndUNFdGNmQy?=
 =?utf-8?B?SHJJbzJsU2JWNUdCNWJBSklDM29aMVI5RG9OODZwWmZ0SlRnTU01Zk1ESVlH?=
 =?utf-8?B?bUZzZTdEejMrMS82UjB3eGFoVU9GZ0lsYURzcHgzeTNtRWpwaDkxdHNOK2Zz?=
 =?utf-8?B?T3hPS0pmRTBRcmxTaW1FcExBSTNJamw4aHhNTE1hVWJNdlRiQ3Z6NjU0c3Fy?=
 =?utf-8?B?Q0tmZm9wTmtlQ2F6bXpaMDVUanZGNERtT0F6RG1ERFVid3F3WEFodEdxM0tE?=
 =?utf-8?B?bHJrcEJwMGdjdFpUMjhkbFkyWXFOTGdTd05oandYaTRoc0J4QTVwZVFPcnNx?=
 =?utf-8?B?dllLNTlnWS9mYnpJYVlYTWVRMEVpbk95eTY0Wmo4RVRxYTJOSDFNaXhFdFpp?=
 =?utf-8?B?RUQwUHMzTldyZnVjSGVTV2lQREZ2L2g0Qm83VzhEUU5DVjk3ZGYrQXZTdG1a?=
 =?utf-8?B?dVlkS1pKSmFyaDk5OXhhb2FoNTJlTXVzZHNINGZqT3JKWEdNNlBBM3NIRFZS?=
 =?utf-8?B?ZlhzbGZnOFlQTktweTVEQXNQSmFaYU0rRmVhS2VyM2VBeGU3VUhDbWlYWFBl?=
 =?utf-8?B?RFBWK2VGS09YcHBvYzY2OUwyRUFXVDNpRjVTaE1pQ1VwWUw2T2tOVGFpODR2?=
 =?utf-8?B?dUxzZE5ibWd2bEp1a0hIMTFUWEJLdG5penV3VjhtS0tEcFlWeVJ5NjB4TjBo?=
 =?utf-8?B?YUpVZFhqOFZpa095OTM3U1pMbDd5d1QvWExMMU9KeE9CM0Y0elZ4VUlhaWl4?=
 =?utf-8?B?Vitndyt2QmZhYWtPWUJVTWtEMXhtUmw3U0svNGdPWGo3ckxUNHJ1bEZCTVA4?=
 =?utf-8?B?SmY2RnNGVTA3ZTh4UGtiOUFpVnpGcWkzUERYRGhseVd5YmlkckRtOUQrV2FF?=
 =?utf-8?B?eUZ1SUhUbHdldDBSbGVZWGJsbXoxMFRtNDJHUkgzTHRET3JWR0Iwa3k1dGcr?=
 =?utf-8?B?UHhvcHdOSFJNTytDQ3R0bTlIMi8xZk9LTi9KcEZpMXVyQTFMRGdLempoUVN5?=
 =?utf-8?B?dVhaMEJqWitmOTg0SnB5cVk2UkdIbTdRVDVVRTVmazBGSkZnNmgySTVUL0Y2?=
 =?utf-8?B?UHNaL2FPUi9Kem5HaEJGaGxvTkM1WTI0NDJ5NmxsWnNHTGEzajNZNDRrK0tL?=
 =?utf-8?B?aWpjSEliRkkya0R1UjFLTExiQ0REeUlFT2VQcTdTd1NPQy93WTYyeThsUWh5?=
 =?utf-8?B?Z3hIZ2RNWjg5eFQ3YWkvOENYeU9uWU1RT2J2VG8xT2hrQVhsRGhWNjg4eCtt?=
 =?utf-8?B?SFRSM0ZUMGJSSmE5N21TL21QN0tiZjFqWFdzN3BZek1zaGpDeHQ0OG5qOU9u?=
 =?utf-8?B?c2FXeFNYeG45UC9RN1o5QU9KZWtUU2ZmSzRWREtsNXZnY2VwV0dJWkFlQlBW?=
 =?utf-8?B?WmpvNHhEUW9jYUhLWVpIOEF3MVQ4aWNtZGV0S2pyU29CMEF2SDBCVFFwb1hX?=
 =?utf-8?B?TytDbVh4MW5vNVJMcnRVclAvRnNETDNWb3BGaXpUdHhiZ0RaOTRySzh3aFJk?=
 =?utf-8?B?SVhORDRNaEtOMEFvM1pvbHcwdW96TzRiZXZISEx1NVo0ekFJOUg0NzZIdmVj?=
 =?utf-8?B?VUsrdnFpZ3A5SVhQR0hyYmNpUk9sZ0VyOERwcy9MYmJtd0ZXcXB2L1Y4elNP?=
 =?utf-8?B?SWpKU0hjNW1WQlNrOWNtbXdHUy9QSStnVThOUmlGbVltSVM5Wm1zUS9tdU9C?=
 =?utf-8?B?RWt2WWJ5ZlptbjJPOXJQcm9pQzFRRFU2WElnMjJKM1RMQlFqN2h5YzJKMFg4?=
 =?utf-8?B?dXdaN0pQbHBsU1l6SGwxSDM3c2VXZUhna1hEY3NtMVREcEltVHZQZW5lc3RX?=
 =?utf-8?B?RW5EZGQ3WGZWWExNNFRqTGthM1o1dFQybmlpTWRVZUExVnAwaGRyS1RrMlF6?=
 =?utf-8?Q?0dvPzpgm4upfDlJc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD3D65DB7370B3428FBDC3256F6F0D55@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5aa042-9a1a-4011-fdf0-08de696d8a4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2026 13:00:32.5525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MYUOyOzVWihrvtEjZ2YvcoJUKAW8NdsiNsoBrKTY+diNrzZ0yq4ENTIXDwccftjZBE01IJBWSnTn7FXckyMy6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8196
X-MTK: N

T24gV2VkLCAyMDI2LTAyLTExIGF0IDE1OjAxICswOTAwLCBXb24gSnVuZyB3cm90ZToNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vm
c2hjZC5jDQo+IGluZGV4IDYwNDA0M2E3NTMzZC4uZTJkM2U4MzRjY2JhIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsrKyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZz
aGNkLmMNCj4gQEAgLTU5NTksNiArNTk1OSw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Rpc2FibGVf
YXV0b19ia29wcyhzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhKQ0KPiDCoA0KPiDCoAloYmEtPmF1dG9f
YmtvcHNfZW5hYmxlZCA9IGZhbHNlOw0KPiDCoAl0cmFjZV91ZnNoY2RfYXV0b19ia29wc19zdGF0
ZShoYmEsICJEaXNhYmxlZCIpOw0KPiArCWhiYS0+dXJnZW50X2Jrb3BzX2x2bCA9IEJLT1BTX1NU
QVRVU19QRVJGX0lNUEFDVDsNCj4gwqAJaGJhLT5pc191cmdlbnRfYmtvcHNfbHZsX2NoZWNrZWQg
PSBmYWxzZTsNCj4gwqBvdXQ6DQo+IMKgCXJldHVybiBlcnI7DQo+IEBAIC02MDYyLDcgKzYwNjMs
NyBAQCBzdGF0aWMgdm9pZA0KPiB1ZnNoY2RfYmtvcHNfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIo
c3RydWN0IHVmc19oYmEgKmhiYSkNCj4gwqAJICogaW1wYWN0ZWQgb3IgY3JpdGljYWwuIEhhbmRs
ZSB0aGVzZSBkZXZpY2UgYnkgZGV0ZXJtaW5pbmcNCj4gdGhlaXIgdXJnZW50DQo+IMKgCSAqIGJr
b3BzIHN0YXR1cyBhdCBydW50aW1lLg0KPiDCoAkgKi8NCj4gLQlpZiAoY3Vycl9zdGF0dXMgPCBC
S09QU19TVEFUVVNfUEVSRl9JTVBBQ1QpIHsNCj4gKwlpZiAoKGN1cnJfc3RhdHVzID4gQktPUFNf
U1RBVFVTX05PX09QKSAmJiAoY3Vycl9zdGF0dXMgPA0KPiBCS09QU19TVEFUVVNfUEVSRl9JTVBB
Q1QpKSB7DQo+IMKgCQlkZXZfZXJyKGhiYS0+ZGV2LCAiJXM6IGRldmljZSByYWlzZWQgdXJnZW50
IEJLT1BTDQo+IGV4Y2VwdGlvbiBmb3IgYmtvcHMgc3RhdHVzICVkXG4iLA0KPiDCoAkJCQlfX2Z1
bmNfXywgY3Vycl9zdGF0dXMpOw0KPiDCoAkJLyogdXBkYXRlIHRoZSBjdXJyZW50IHN0YXR1cyBh
cyB0aGUgdXJnZW50IGJrb3BzDQo+IGxldmVsICovDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5n
IDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0K
