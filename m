Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A5F210E4;
	Fri, 26 Jul 2024 02:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721959790; cv=fail; b=qIzFvI4aZcjyqIdm6oRa40mziFd0MCDblwU0etwEnLAZcTILdOk2wRAULOSiCXw9lErbOH8EFPtAP3bt7QXhnxgQb3D5dGSZYFDjmULUHgMOpvpBav2oByTAksQdzSYLcwmvjBQhAL5yhSmM2I58gxVYjn8GxY2dhf/elAWYbVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721959790; c=relaxed/simple;
	bh=uwDzUGbdp6hSDXSvCJXEAo4aqflujCbYPUraHZTS+ks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CbzeAXvouJaCqjxNK8mm2yCz+pgxcyVntculxInNEt8ylgKHILFGRuAYyLVDgyQlWZV7fKai+X9GS/KeP09jt/T7BCS+29tBccEIrmg3WmWZs2YsaXaRsP1BBjYLddD5JoC8rqO4e4HCu2zMc4ohgkzCrfm2OAVRUa99jXd3mK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BWG0ZNfC; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=i2D6VlYM; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BWG0ZNfC";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="i2D6VlYM"
X-UUID: 1a2338324af411efb5b96b43b535fdb4-20240726
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uwDzUGbdp6hSDXSvCJXEAo4aqflujCbYPUraHZTS+ks=;
	b=BWG0ZNfCWDqw5I8YVvLIKy17VSq/Q7x8eRDo+FAXV4XmfA41a6yLLlAz/seSkbnn7frv+BsafOH0HYY6Ouzm/Wn/cEq0em5sbdSHUf3ye2MoqhbQbz/37NrGji43qDUkc3iOvh/Uj82oIoXOpGCFUP11tVYFWUNOqYJK/N7pLg0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:1bb04288-82ca-4677-b550-468515fa657d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:2da3e8d1-436f-4604-ad9d-558fa44a3bbe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 1a2338324af411efb5b96b43b535fdb4-20240726
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2111318441; Fri, 26 Jul 2024 10:09:34 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 Jul 2024 10:09:33 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 26 Jul 2024 10:09:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCkNIqO4hGxGJfCXZX+8DLIdIBUvkI0oy6grrVOHZNbiVknEECAWHEfpIYSbapXQGQRnRY99OEtIQgVlCUqGinEJytssGX+4y5YxYZcrGHDuoboBMQu5xJZdCKYkzzSOLAeVWceI4XezWdYRSN+zw89cVrMF1ybwchldkffFkZcbbiXtIiRAij647WisNB3x9BAFERlrjxFOiDbDc4FKwm6zzPoUssyziKwUdhRmRcB5hIKIDZTDDrgbdt2hTfiT12MA491Xs22ZAwpOk+etKteTz2pwk9bJzb4bFOlPqpdBPn6pCuR9RXWjN/W3T2cMnINX0MuE5feNXgOQCD2ydg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwDzUGbdp6hSDXSvCJXEAo4aqflujCbYPUraHZTS+ks=;
 b=AmQpFomyo+9jCdFjBaxsyGPGO0TfjqWpKS8U8hQCPxQyPGFCRSEfSCJ1bLwNTvMR03kRQt6V1eYrrUMp1s3Du9Gpr/HnhilRGjXbPKTa1ekKMHRNJw26C9rWg92WtfxwWDnP0xa5jqm7jY0ZKoSSezgSeRsyrWSdAhF38qWOKVq8eB17GGCGdrXS4jkXX/Wi9uXMwWDBrxFa//5tcIZ8NjK//LkBQTwf2S3JuKuYIXRC1q2tKs3qH7GgimgkYx7aDYIBPJrtxel96UNlXvkDJuHtaY18RaF19g5PAFiWk8JkkqVRffh35ggEbxpSulJTRfHlH2A/z6va+IR+HnzLAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwDzUGbdp6hSDXSvCJXEAo4aqflujCbYPUraHZTS+ks=;
 b=i2D6VlYMBtwr5igsR8aWkeX48FxO7MVtaQx1ndlojyh1PSj+hD48wmGmAtZuAVnhvY9rRQYhJdt+Oy9duXUyU3rz7hTNXPOrqxO4TFrApLUcCq0gkby1yS5OpqemCLFlYeW5EOF2SOS1+T2qz2IqS217vdJx1pLqAodbugILa2U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7635.apcprd03.prod.outlook.com (2603:1096:990:e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 02:09:31 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 02:09:31 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>
Subject: Re: [PATCH v5 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
Thread-Topic: [PATCH v5 1/1] scsi: ufs: core: Support Updating UIC Command
 Timeout
Thread-Index: AQHa3XygwZL9zdBZVk+IjGAe4bgxg7IIRrkA
Date: Fri, 26 Jul 2024 02:09:31 +0000
Message-ID: <ed78d10b8083b32387116d19ef1d3dc3066a881c.camel@mediatek.com>
References: <cover.1721792309.git.quic_nguyenb@quicinc.com>
	 <e4e1c87f3f867f270a3d4b5d57a00139ff0e9741.1721792309.git.quic_nguyenb@quicinc.com>
In-Reply-To: <e4e1c87f3f867f270a3d4b5d57a00139ff0e9741.1721792309.git.quic_nguyenb@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7635:EE_
x-ms-office365-filtering-correlation-id: 7b574bdb-1f72-4ddd-e35f-08dcad17fc8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L2x4TWxUYTZ4SVJEOVlCNHV1V1V3eWFiSm1qaEtsQS9NNkhhQUQ1ZXlIY1hC?=
 =?utf-8?B?VFF3Tlh4d2JEZytLTS9JcW1JUDM2SDNyRXp1NDB6ZHAwNXc3V2ZGdXhqRThH?=
 =?utf-8?B?N1dKbEdabFVXemNVbW81VHFRV29VL1dVUDlDTlB3QkpDOWtCK2hmaG51U1c5?=
 =?utf-8?B?VGxPZ0FGMzV4YWpYSVdNVzMrWCt5Mm5GU3hsOXVPUFBkeGV2K29lZCtSa1dB?=
 =?utf-8?B?UUFaK21veVpuV3lpS3NPYmxlbkV5S1RveDdwSTJYdjJaTElkTklySUZyQ1dj?=
 =?utf-8?B?ZkRmZnNjM1ZhWlZpbHNCQjlkemVsYXkvNmJHVFVzWUdpWFRGKzNXK2lLWWVs?=
 =?utf-8?B?bEV5RzhGbC84cjdzaHF4V1lNdjVOUmErd25pT0ZFMXhBUmVpbXpSUHU2dE5x?=
 =?utf-8?B?bjV2Zk53SUJjZzRvN3l3ODlmNzRTbCs5djdSWVRwbXpZMGF6dXlrLzJDelpy?=
 =?utf-8?B?cCt5YzBmMmFKN3MxM0I0Y0lsQmx2bm5wMjg0eWthVGV1WmJXRnVhL0o4Y1Va?=
 =?utf-8?B?MUM5VE5IMFRRZWlBWmZsMlZhK3d4ZWhkNks2c1VNOTF4VFpZVWhjYkpoVHRj?=
 =?utf-8?B?WlhRYi9JelE1ZFV4SG1mVWFkMU5pUnUxL0JiU0x3QURSdmhpOEpVTTdEUGs0?=
 =?utf-8?B?VGUyWHpoZlhrY3ZJTUFEcndUQjZrTDFBdEhuMjdQR05SdlNKUlI1RWVDMzQy?=
 =?utf-8?B?NUVkUk9KQnQ5aE0ycXpuL203NGRXbWxhRUNmclpPdnp3ODhKRVBzb0N4bGhW?=
 =?utf-8?B?bVJ4Y1FFUFdsNytVWEExaGkwMkRFeks2V054dS9wakpCQUxtK3BGNUF2d2dR?=
 =?utf-8?B?TDRWVFZHdU9YV2NkWXlLYm5MaHh1TE5nM3hkNktUdTdYVVkvdXhicEZISkdX?=
 =?utf-8?B?dExLUVBkYm56TjRXNGFTUXpXYU5ldWZYaWZZemh0cmdsYUg1cGhPcFNWNlJS?=
 =?utf-8?B?QlJrQ3JPVGczbzJDRVhkNHBsOFhYSEEzdjlwOUpxSXRvOGdEbStSalViSVQv?=
 =?utf-8?B?ZTVwTXF1aFJtOWZpcTlXdTY5U3BCK3VoOWREemMveVNidGgyOVY5UFdPUW4x?=
 =?utf-8?B?THgyWmdvTklVNW5nQk9tMllGdGpEdHhPQjhrNE9vMDZiQ1V0U2RQZFV0ZXhT?=
 =?utf-8?B?YlJYQTk4NlJFTWtNekIyekR4NnZ4azlCUTl1bEFDMzZmalJvVytLQkIrakR3?=
 =?utf-8?B?OVVKczhtRmtiZWtWQXFNeGRrTTZzaVpjNG5naDRrd3A2OFNZSml4SUpmWlhl?=
 =?utf-8?B?SzE0M2JRanVwYysxKzhwQUU1OVFHOTZQaHUrWjZhcG9rS1JrY1ZWREdyc0xC?=
 =?utf-8?B?ZmszNGdwQ3VnWlVPaEtjbWtKQzRyN2lLV0hjc3d3TkxMU1RSSjBUQkpNV29j?=
 =?utf-8?B?cXUrZU9zaUdjS3ZJeW13RldVOUxKUmxFeVpiWWJ6SldzMnRObGkwZzlaTGM2?=
 =?utf-8?B?OElVNkJLdk9NZ2krd3JQbG1EVmlKVXJoQnlXbVVnSmV1MXFqRGV2T1dJU1BH?=
 =?utf-8?B?UGxiNFNteW1aaGk0VUsrT1FvWHJaY3F5SzNxY3FRU1l2c3IrOVFVRlhnT3hM?=
 =?utf-8?B?N29PakxkdzJpRWQ1TXVGOVRhak1RODJRT1lEUG45bWZNc01LZ0J4R1hlQURJ?=
 =?utf-8?B?SnBRS0x1Mk90SEpvcksxdWxJdllIVzFLSnUrMDZoZURSSTI4NTFRQXhmNENr?=
 =?utf-8?B?YVlBNSt0RTB3MkJvVEZzcHFPRzg0bTZTcHhpekZpT1JnWVB0RS9QbUVRZ0cv?=
 =?utf-8?B?V1BzbDJCbExEOE5mOXg4ZDh4bW1CemtLMWUyb0RlYWs0NW1FYTNMUnMwVTYy?=
 =?utf-8?B?V3k5aUhacHVtL0tvSFFqdDBVZmFnSi81emd1c2hiYXIyNitCQ3F1MnI0Z0R2?=
 =?utf-8?B?eXIrMFlPYUpyRFdBakV5WFFHaXgyeURuUjBYV3lESkEzcnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0ZrSmJDTHhYUElnN1hwRFRSYmd2OHRKS1lqMVZEWTEyTWVnUVR0Rm9JT3BU?=
 =?utf-8?B?anIrZGxwR05JWEZXODE4a0ZkU3BQTFBpeXEzMkg4MjlJK0prQXE2TmpNR3NH?=
 =?utf-8?B?SFV3cUJFTnZZWVcrd0VvM2RQSStlWWVIMHdsL3dGZ1ZCSnpYK1BkZjJXckpq?=
 =?utf-8?B?dDdaajdEWitWUGFUL3pUaTZnWlAwd0R5Q1hRWmNrZVZObTVJeDNkUi9malc4?=
 =?utf-8?B?RHhzVUNUV1YrM2NYVjE0akNudk9XRHcvMVdKdUgwZmg1VW8xTmZaZmIrQ1cw?=
 =?utf-8?B?UEtBSDVMUWhYTXZEL0F2ZjdpcjZLU054WExYemVYMGllVUI1NUtNVXFxekJ4?=
 =?utf-8?B?RkVPeGd3N21XdW9zcnQzMG9yM0o2Z1dvNW1vem1VY2JzSEY2ZzhLMTdMc3kw?=
 =?utf-8?B?YVhZa21NMWJsaHRyZ3RkckJVTVRIb0FLK1o4MnMwN2NvWUxCeE5TbjFMR0Fi?=
 =?utf-8?B?aC96WGdzdXNqYUUwODNKNXM2RXFrb0FNTHg1dDFpUzFKNmthbk9IaUlESDJo?=
 =?utf-8?B?L3hFbDZsTVk0bmpDSk1sOGhSemlQWVlNU2FRTnVmTzM1WW0wRHZCUUlONzBI?=
 =?utf-8?B?R3FTL0pPL1ZSbzBzWVNaa1dIckliZG8wbU0vUXlYYVozRjNOS2xlTTdVdlh0?=
 =?utf-8?B?bGVTNmdheXk2Z0xuNXhGU2ZQVjJFWlp4Q0Y3eGJlNzZpV3lTSDVKc0lrM0hY?=
 =?utf-8?B?ZktOOTM3T3dJMFhCdEhYVW96RnpzVG9TckdBKzNsUkR3ZUVGTDBWR2FReDZX?=
 =?utf-8?B?ankzVUhYNnhwMmlLU0d5TUYyc3JzUWI1cFBIOUw2SjlOSnloVTJ3TnpwRXJF?=
 =?utf-8?B?RHNqTm9HMGRFbjJ2c0VTUXcvWkFlSlJCK0d3bk1RVlZrL20xd1o0cGtkLzZj?=
 =?utf-8?B?cWFHN3hoRlhoclJxeEJmNEF4V3JYWVdHWkZkakt1dEFBQzRXSWhiR0MyNUJi?=
 =?utf-8?B?ZEFJeXMrS0IzVXNPQVpHSTZQNGE0dVpnVWJKUndLRHVXejV6K0pwVVp1ckZM?=
 =?utf-8?B?SWlzaDNxTGhYSXB4c3RXSEtzODNqQlBlQUY5VFFyRWdaai8zQ1l6UDNpeWlW?=
 =?utf-8?B?Y0RKaG1IUGJuWFc4WHBqc0xKQUN1eUZFTVFyNnp3TFphakxhTzJTRkJqN0lW?=
 =?utf-8?B?cU5EM0NEUlNxNDQyb043US8vemdnVitOU3ZKcjR5VktJZGI1M2xWbXJlT3FM?=
 =?utf-8?B?QVlFMHRVbkFoZTBHdEpBeW1MWWxmZnkrL0ZkOGIvbTY4S2VScWdZejgyRGpT?=
 =?utf-8?B?WG02U3U1WStIdWZ1RGpWWlE1dit5NnA0VVVMVlZkb2E5SzA4YVhzRURNUGZ2?=
 =?utf-8?B?bzFWemdsb1RKelRZWExpUEZJU1NnQTZ1aGszZGREaUNMWFhZMDRBTnpBdWQ2?=
 =?utf-8?B?eTVHM1BldGFHb3R1aTdwaHRBUUt2bU00RklwUHFRYlFsTDNWUWcvV24wYWc5?=
 =?utf-8?B?aWJucENRdVh3a1YyUVZnN1RtYm1DRUErWStyaklXZEZCeEZoRVkxQkZ6a2Q0?=
 =?utf-8?B?M2pOS2lYOGdESGF0WjZlaEo4NXRNbUhTcElJWU8vaGpoR1hSdXAySXhpUHlw?=
 =?utf-8?B?SmIybXc1eDFWZHRRUFF5cEpYL1k1Ymhsb3dKam9TY2Z4eHlSYUt0Vzgyb0xM?=
 =?utf-8?B?a0RWUE04aUtucTM0bWJHdndEa2VscmE2NUt4ZlZSS2VEdkpQNHZ0T1VtWndt?=
 =?utf-8?B?aG1kNk5la1Jha2tLZkdGQ3JDVUl6Zlo5R1V4ZXY2Rkk3Y25GbmxVQ0ZSb3Jn?=
 =?utf-8?B?QVhSV3BkOTJPLzl3SGdZT2ovc2dMeUtMK3hlUEoraVREdWVnSE1JallvK3Vn?=
 =?utf-8?B?eURsbHBza0Ixb0VzenFORWFhSEJGWkxGUFpxRGxXQXNlL29pTXk0QWVpeTBN?=
 =?utf-8?B?eDdlclpxRXVER205Z1ZyQ21wcFJnMW44SnhHZ2JKL3hQdExQeVpLRVd1eVZE?=
 =?utf-8?B?VmRpQk0zckhyNUc3WmxYS0J3ckdqNVh3eUJNY2pjY0xHY0l3Y2p1bEVVSC9L?=
 =?utf-8?B?MHpxdHBoTTZXRkxOUTlBYVVXOFRDZ09pZnBuTWcrSmlnNnlRR201UGZTOFpt?=
 =?utf-8?B?Y2tVTUg0cHFUV0g2ZGxZMkUyTE9hOHJSZTZrL1kzdTc3RE1vK25MZEVOOExs?=
 =?utf-8?B?SnVyQU96cHRVQm9KRTRwQnNYRExxT2Q4OHZGcUZvMFNXdDVseEtDU2h2elBM?=
 =?utf-8?B?dFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39EAE1092BFDAF46AF9B83158DDCD58D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b574bdb-1f72-4ddd-e35f-08dcad17fc8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2024 02:09:31.2863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wc8sAako4hWZiZCkNbDFLO45QpAjpVJpe5Tb5CNSVEP3L5HlbmUIJE5oE7wd5USHGQpi7WyOTfO9Si5TeoP0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7635
X-MTK: N

T24gVHVlLCAyMDI0LTA3LTIzIGF0IDIwOjQ5IC0wNzAwLCBCYW8gRC4gTmd1eWVuIHdyb3RlOg0K
PiAgCSANCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0
aGUgY29udGVudC4NCj4gIFRoZSBkZWZhdWx0IFVJQyBjb21tYW5kIHRpbWVvdXQgc3RpbGwgcmVt
YWlucyA1MDBtcy4NCj4gQWxsb3cgcGxhdGZvcm0gZHJpdmVycyB0byBvdmVycmlkZSB0aGUgVUlD
IGNvbW1hbmQNCj4gdGltZW91dCBpZiBkZXNpcmVkLg0KPiANCj4gSW4gYSByZWFsIHByb2R1Y3Qs
IHRoZSA1MDBtcyB0aW1lb3V0IHZhbHVlIGlzIHByb2JhYmx5IGdvb2QgZW5vdWdoLg0KPiBIb3dl
dmVyLCBkdXJpbmcgdGhlIHByb2R1Y3QgZGV2ZWxvcG1lbnQgd2hlcmUgdGhlcmUgYXJlIGEgbG90
IG9mDQo+IGxvZ2dpbmcgYW5kIGRlYnVnIG1lc3NhZ2VzIGJlaW5nIHByaW50ZWQgdG8gdGhlIHVh
cnQgY29uc29sZSwNCj4gaW50ZXJydXB0IHN0YXJ2YXRpb25zIGhhcHBlbiBvY2Nhc2lvbmFsbHkg
YmVjYXVzZSB0aGUgdWFydCBtYXkNCj4gcHJpbnQgbG9uZyBkZWJ1ZyBtZXNzYWdlcyBmcm9tIGRp
ZmZlcmVudCBtb2R1bGVzIGluIHRoZSBzeXN0ZW0uDQo+IFdoaWxlIHByaW50aW5nLCB0aGUgdWFy
dCBtYXkgaGF2ZSBpbnRlcnJ1cHRzIGRpc2FibGVkIGZvciBtb3JlDQo+IHRoYW4gNTAwbXMsIGNh
dXNpbmcgVUlDIGNvbW1hbmQgdGltZW91dC4NCj4gVGhlIFVJQyBjb21tYW5kIHRpbWVvdXQgd291
bGQgdHJpZ2dlciBtb3JlIHByaW50aW5nIGZyb20NCj4gdGhlIFVGUyBkcml2ZXIsIGFuZCBldmVu
dHVhbGx5IGEgd2F0Y2hkb2cgdGltZW91dCBtYXkNCj4gb2NjdXIgdW5uZWNlc3NhcmlseS4NCj4g
DQo+IEFkZCBzdXBwb3J0IGZvciBvdmVycmlkaW5nIHRoZSBVSUMgY29tbWFuZCB0aW1lb3V0IHZh
bHVlDQo+IHdpdGggdGhlIG5ld2x5IGNyZWF0ZWQgdWljX2NtZF90aW1lb3V0IGtlcm5lbCBtb2R1
bGUgcGFyYW1ldGVyLg0KPiBEZWZhdWx0IHZhbHVlIGlzIDUwMG1zLiBTdXBwb3J0ZWQgdmFsdWVz
IHJhbmdlIGZyb20gNTAwbXMNCj4gdG8gMiBzZWNvbmRzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
QmFvIEQuIE5ndXllbiA8cXVpY19uZ3V5ZW5iQHF1aWNpbmMuY29tPg0KPiBTdWdnZXN0ZWQtYnk6
IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBSZXZpZXdlZC1ieTogQmFy
dCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IFJldmlld2VkLWJ5OiBNYW5pdmFu
bmFuIFNhZGhhc2l2YW0gPG1hbml2YW5uYW4uc2FkaGFzaXZhbUBsaW5hcm8ub3JnPg0KPiAtLS0N
Cj4gIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgfCAyOSArKysrKysrKysrKysrKysrKysrKysr
KystLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25z
KC0pDQo+IA0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5j
b20+DQoNCg==
