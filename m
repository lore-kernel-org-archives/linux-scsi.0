Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E922E2DFB;
	Wed, 25 Feb 2026 10:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015656; cv=fail; b=u/3/GS3L9pzgu0FbLViuyhM2b9geoe0xNUOMyQ7/nf2WjHDLZs+T/30F9nxqmBqAdjuTKezdPpnO3w4cmV4PCwze39EN3MQbkBG0TWQK08kD0rhDqg+8SzoKg6s8ZcQYAwVzambBm3GRH0lQEjxQqk/Eij2TmfFQoB9s3i6QHyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015656; c=relaxed/simple;
	bh=77Vt5EeovBxVe3qXAshmrzHec4/+hS5bQrhsyfLm2rU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rnZduSCaD/qx3n7XWwfKPTclRbqMpc7jKrSrvAZcAEgSQH3PBeB0wXThm38O79bqqxaUkR5uCnE8WHEeBsy5QAOOyASSBzG1lifiW94srezKN8iN8gzFbZ6QTGyGq0L7PzgqqDz/sED76eMJfTwT5AtGiFfZd/3t9kpnwP0KyWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mYYxW9JT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=SHJkcu2v; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mYYxW9JT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="SHJkcu2v"
X-UUID: 854c83b6123511f1b7fc4fdb8733b2bc-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=77Vt5EeovBxVe3qXAshmrzHec4/+hS5bQrhsyfLm2rU=;
	b=mYYxW9JTaDO87hPrJ51RTO0CKodEdx4VKkrqE5RlAz6OdWNxjpXQFYtcRALSJpxfG3Mtzra6Z8xsQlORmqhzcUEP3GvJrGgfkWuftt98BoC+qQ9YqwxNwIIk1MDA58OzwH2RudGSUDn3ukcvW+cwXcI/YCCCN7EsWR7so5QDOlw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:7c6fe4ea-f922-4e1b-895e-2d2bbb650dc5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:dcb0fae9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 854c83b6123511f1b7fc4fdb8733b2bc-20260225
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 683363917; Wed, 25 Feb 2026 18:34:10 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 18:34:09 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 18:34:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9mRqJKVPKVMMq+1a2hNgVw+7hkBlmaZ1EcdR3y3i+TAuXvgewcAjJ3x6orEihp+R+ueq1JClXDac/6i3g7E8OyCPTxrkdRdX/ny0OvUsKSUesCL4rF0NvQEqFkOTeTcWsoikCaqi9/etP0fnHEb6hCuSsWI96EWMQbWuaN1opJtja+Aix/02nHkSmziPMfDWLJFja57eoGcWZiZEVzAWS4PhT0LaQ4lu6AeK1+NWu/TOXIiHhIRjD1QvSBBZzLW5lEQTdZk1Uv5FM6wnIYlHdhyHkU//geUV1KUoPiAZuvIEE7uf8XseXAGBD8XNE6DkvLd5qFUEyeVVTZ6GMcVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77Vt5EeovBxVe3qXAshmrzHec4/+hS5bQrhsyfLm2rU=;
 b=Z3SePy+TL0BI8kg074AMAuvWXP3HA5vAVwL11QxnxxfYmI623JFjAoV6y+2QNf7P2o2wMSwcraIQgKTvWcRgUR18ZahCvIIkMbRrEkPyNG1lpsQa73AV5xtZitummg3GwpfnRhaS9lx3iWGXlIwIxHO9pWd7jIbKmici02cDY6MiqYe7733LiwZzeA7TOaH5P4l1rZ4JWwMkQte+mYLa7iUDC6QQxIvxJFvS+rNRlmEqecgqcqKU9066IYbub4FN3547RX2hLZDLJHKMSqWGVuCfZXEeXRF3y410JFQ0rXE4qSahYp6Bg9rhwf4GzxeZppTYMmlQob4R23kUhhcuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77Vt5EeovBxVe3qXAshmrzHec4/+hS5bQrhsyfLm2rU=;
 b=SHJkcu2vfUeTVPGdbcZUoVi/tIXRdZ8PCiISjCtPkDCxtOzdtrjwYf+4v317AMgqpjemVR0P2z2ZPpb6CP34EB3Ou/FAY59rMaZah8nB7kSGdMg8dwr+TPAQsU481JR9r4JwSE8mIfVxMK/3qQARvRl5NHSpcqoiTLddGjkKgy0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI6PR03MB8652.apcprd03.prod.outlook.com (2603:1096:4:250::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 10:34:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:34:04 +0000
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
Subject: Re: [PATCH v7 18/23] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Thread-Topic: [PATCH v7 18/23] scsi: ufs: mediatek: Don't acquire dvfsrc-vcore
 twice
Thread-Index: AQHcn0n0HrdpPO0pSUqq1c5Zt2tyIrWTRfIA
Date: Wed, 25 Feb 2026 10:34:04 +0000
Message-ID: <010d77378b9cca477439b92d92c8f5bfb2d4df65.camel@mediatek.com>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
	 <20260216-mt8196-ufs-v7-18-b5f2907c6da7@collabora.com>
In-Reply-To: <20260216-mt8196-ufs-v7-18-b5f2907c6da7@collabora.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI6PR03MB8652:EE_
x-ms-office365-filtering-correlation-id: 2042f713-2541-4b7d-87fc-08de74596622
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: OhVYLMuBPGMmD2RCHFNVijhDrjX3na3zmi32Wy6qcwm0G+AkLaR+v4JHNeyi3Wglk7Uf60DL/fcE6DOK5DfVSEt0TUlPBswyexuEXY5Bs2UAE2AUPHQzrXmwKgCSDcILQSZNPTr0im3L0lTeaz+0Oa6R3okP5GwFvlU7hBr+T8FFZbB/fLhMGdqlQtjBQ1aM3sFs8hOvQpiYco/CAJld1nTX2b3MGg83NI9CwUJhgnLdEPUSdBSjDBuwAwsuOfYALk9SXLrG+eex0U8BymIopeiO+isWw/my35bmqAIXvVjCys916jWKMauNFxCki7CVv++Q3OWATeRz7XVndwGsmbttEgnL7J/AltTBFpNslrHkuTnZ4ZM/Wze65QfXNVmPlUUD6YnnBz8KogYYOZjj1+6qtHs63TeiVJQ7lp3nbfZ7nsHLPSjYl1yQzu2BKZSZ3xjsZdjlQKiE4Ggsl//JCe6VPVBt1OaBA7Mjn4C+AR0O5VvjeplJMSIhT2wuvxmOGOyeQIkj2nieafuHv64yaScGQ5nV4l2FLOB7BR+rvKeSf68WwjwD0v0/faobGGH4ZjuYcccRr8ntvZpaq6NydZfcKcK69nB8a3AhuT3lMyyRPpzo1sQobAq0cgj3GtBNhvX3wz77nHCaaZOWLMDde8LjP42LKPKbR02MB14o2CamqYMHVzKLYac/zxhfJHquDL9iVejLf1LsZU2hWKCAwW6MbbhqFwZ5gRcqUnD1vNAz1OED4N62g8jShSQz1TseFPZ42TXwAMR9VLoW6hrFq2Gao3MGzpVXwxT3Op7UP7un0kEx6GdJl+fVe2kJHqR3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjN4aXU1SzI1VzNOS0NQaHNzMzJHQWg0WjdoamxwT2NCM3dZNWU0SkI1em1G?=
 =?utf-8?B?T1lUbU1FMjlYSkRET0ZGdFNNZGtHNTJ4b203bXg4TmpBdjE4QVB0ZzJTM052?=
 =?utf-8?B?aXI4NGNKT3NkbGNYQnFaeGRXRTRmWEJReG8rRmgvR25qcGptRnNqTnQyN2xh?=
 =?utf-8?B?QUZMZ1luRGRrU0RqNnRnSEZsL3o2NmRFMVh0U0xML2J4bGNBQ0NmY0I4blY1?=
 =?utf-8?B?ZEhmV2tvRlpsUUNNbmgrQ0hOZk1nc2VSdVZRQVlsd3h6cGU5b1VDWThsMUI1?=
 =?utf-8?B?bkdxUDczZU5lUEVCM3l6MDN5NkloNWFvejlrMzhjQUJsZXZhekFNRm1lM2t6?=
 =?utf-8?B?LzhHUHZ1WVlEeldPM3lKMWQ1a2hBUllPc1QwVkpldG1ZZjJzODJlMzhPeGF6?=
 =?utf-8?B?c1hCS3dBTWJPTml1R0Q4ZWdxbHhZcU1HekFucm4rY1ZiNC9sakJiaXlSTEVq?=
 =?utf-8?B?amlST3FWMjE4NndBeUptN2JKR08xVDlQVG1qVmIzV0FWbldMdjdFV09venZF?=
 =?utf-8?B?dVNGTGVWWWVIQ3lEZjlSKzlxNERsbVFuSjJPUFVMcjZ1ZVRDS0U5RGJsMTNY?=
 =?utf-8?B?Y0tPQ1cwQWx2MUlZR09vOG5xVFc3Wkx1WGgxVExMVzVPYWNFS1hER1JtV3FP?=
 =?utf-8?B?UENyMnYxZEV6clBEdE42eDhWU2gvbjBqZXc0TlNzTWRidXhqZFVTNzg4aTRz?=
 =?utf-8?B?NUFwQUtQS2VuY2JZL0M0a3pweWZESHVGU3ZBY2JJbGdGM3VjRFpMVk52SEl1?=
 =?utf-8?B?Umt5N3dCVS9abXJ4UGNQbUNvNkFvOXllVDF2U2lUSkdaWjF2VFJndUJ5bnBD?=
 =?utf-8?B?RUFua3VkR2o1S2FTbUIyODFCbHlHUUZ3elZURVpkS3RGU3NLQjFTY2F2bE5Y?=
 =?utf-8?B?ZnJRL1UwbWsrRDl5UFlLZ0dhM1VMcDhiL01YWGpiUEk2S09NczNvckgwazB2?=
 =?utf-8?B?eUtLM3JXQjFWYThaaER3TUtYQmJkOFlOZ2d2Z1VlSTFINGl0VDRoK3Vka2Jo?=
 =?utf-8?B?RkhpWUpkVGxmcEJxVlllNjFsMThvR1doSWpyZGtjNEVTQkVnSExYaDlJa0kx?=
 =?utf-8?B?TVVOWEpYbndLVnpqREpRZ1NDLzhLaE1KRWNYQTNGdHRkV2lkQlpVRGNLczBG?=
 =?utf-8?B?bzdqYk9pekI4ZW5NMHBpQlhWUFUrU2NMd3owbmxXK2R4MkVHQmhHWXlyQitx?=
 =?utf-8?B?L2FNWXUzcjdwdDVRTmtLU3gxTEVxKzhsWTJVMHRDNG8rSTVYMVMwcTN0SGV5?=
 =?utf-8?B?S1lwZTFHOUllV2pQNVdTT1pwaUdBV2swbEhGVWdPQnFuNGV6Vk5NVmgvQXZi?=
 =?utf-8?B?clBDTllCbXd0MS9hUE5SL2JYUzhHeWtGVVNTN2xKUjlKSDMxSjc3MFJURmZZ?=
 =?utf-8?B?R2J1a1JIRnBNc3lSZ3BRMyszakhLQ3h1NExlVTFxelVvWFlCMzY2QnBIUEtm?=
 =?utf-8?B?VnlxZzRaekRNa2I1bjUzYTNaMktmU0tqdjgyME91SzFYZzhpNm5rKzA5OERB?=
 =?utf-8?B?R2xmZXJvOWIzWkpuNTdVQlUxSHArYkZ0SC8ydVJSczBSK1pjd0xBVzY0cWk5?=
 =?utf-8?B?RVpwMFpDdExiQnR1emxuYnE2Q2llRHUweHp1NTZvaWkwN3dnWlVaenEvVm1n?=
 =?utf-8?B?bFFFWkVTWFdWSzNvNWpPRi9qVVZ6REVsYndOUkhFWjZiYUNsMmV6QjZPNEln?=
 =?utf-8?B?cGxGVlc2MlZxc21GQjBIL240QzA2Yy9TRm5OZHF3NHRVQ21uNlR5bFk5YThj?=
 =?utf-8?B?cU9vMXptR3RhTUhHZEpWakQzZ0hPNVhxWTkyQ0FRcjVMQ1FTSEpzdHpNZkpN?=
 =?utf-8?B?MzFNUDN5TVRmb0tUbkxkNlZEdWlNeGVPaU5XUHJBa0tIV25Sai82UStYdStR?=
 =?utf-8?B?ZHRJWExZditCZCt3cGUyb2ZncTJORGwybWlxeS9RcGlrMzhGOVAxNXdvQ21R?=
 =?utf-8?B?QnFoNDIzQVRPUE14RUQvWTFZVEhNWTEwQjNYRm56S2w1QzdoOGlTNDhmWDBM?=
 =?utf-8?B?WjBkMzQ4Rm9iSHd3N3l6bW1Pc0ZPbFVSMEw2SEU1QUNrYVJXWUJqSWM0NUNO?=
 =?utf-8?B?ZmY3bDZ0bjBkWXBtdG13N1JCUjFsOTExeDNnSEpBSTZya0JEbU51aWdEUkxL?=
 =?utf-8?B?a1lZTVZaNURiTjhQZTZPNDlFVnBmY3Bja29icGZ3MW4wdEpValhORXhhMkYv?=
 =?utf-8?B?M3YyVTVybEFEa080c0R3Z3drMjE0RzczNDVrcy8yYnJJTjdWVkx4cHJMRFhL?=
 =?utf-8?B?Zy9XZWJDZXdEUW1meVpNV05LTlhNMktyYloyN2EwS1Y5Z2hQWUp4TkliQlFH?=
 =?utf-8?B?WEJES3lsN2V2UzdYdzhFdVZQZXpIS2VNVnp2T2FjbGlRY2RKbld2WlR5UTIx?=
 =?utf-8?Q?WFIYJI0ktLu/cbpc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E50B158B0043CE42BE99F79A0B01537E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: drv4jSP4yjjL1f/ibVYx8tpPRvO5S3xjCd0LjB7U3WDgK4OSV6aAJfxcNtxQnfw7dakSpwKWDMG952ciQgK5cdQAaMA1IEhrYFH7U4s1T0C0ve5zocfPiyYNHMJ4jqB1RYYneV1HdkUTPs5v65E1ThZtOmi0xRme+2QLlDFbnA/PeT4uzkhzj3B3/BM+GItZG5kw58yYdSx8THLi5MBgIXcFsSTppegcMY/ihOXbLL8lS125Y2ke3WRol7o6iqGSCEUkon+sYfQYI9+u2gNcjcAuikJyJ0XsSgiM5uBsdMtHQ2cpKgaCAfFJC5AEAPGwvu67zz2rFVfHy+1kS3mWvA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2042f713-2541-4b7d-87fc-08de74596622
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 10:34:04.7365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XwfMldS5RpUDJtU4Gz1bJu3Hvp3dXqbgqeZumuPKa3+QaTv0quyLeacK5/KevYx03CmgKK/AB9H1eP9AbxpkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR03MB8652
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTE2IGF0IDE0OjM3ICswMTAwLCBOaWNvbGFzIEZyYXR0YXJvbGkgd3Jv
dGU6DQo+IEBAIC01MTksMTUgKzUxOSwxMyBAQCBzdGF0aWMgdm9pZCB1ZnNfbXRrX2Jvb3N0X2Ny
eXB0KHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGJvb2wgYm9vc3QpDQo+IMKgew0KPiDCoAlzdHJ1
Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZzaGNkX2dldF92YXJpYW50KGhiYSk7DQo+IMKgCXN0
cnVjdCB1ZnNfbXRrX2NyeXB0X2NmZyAqY2ZnOw0KPiAtCXN0cnVjdCByZWd1bGF0b3IgKnJlZzsN
Cj4gwqAJaW50IHZvbHQsIHJldDsNCj4gwqANCj4gLQlpZiAoIXVmc19tdGtfaXNfYm9vc3RfY3J5
cHRfZW5hYmxlZChoYmEpKQ0KPiArCWlmICghdWZzX210a19pc19ib29zdF9jcnlwdF9lbmFibGVk
KGhiYSkgfHwgIWhvc3QtDQo+ID5yZWdfdmNvcmUpDQo+IMKgCQlyZXR1cm47DQoNCklmIGhvc3Qt
PnJlZ192Y29yZSBpcyBOVUxMLA0Kc2hvdWxkIHVmc19tdGtfaXNfYm9vc3RfY3J5cHRfZW5hYmxl
ZCBiZSBmYWxzZT8NClNvIHdlIGRvbuKAmXQgbmVlZCB0byBjaGVjayBib3RoLCByaWdodD8NCg==
