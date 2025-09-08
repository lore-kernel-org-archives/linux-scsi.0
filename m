Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996C1C4A13;
	Mon,  8 Sep 2025 12:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333201; cv=fail; b=dWqWPQTnDnzTiy3OSvUQaTNlwG4LntBSvqsz1HuOyZatPWRiAuNAmStd6p4aBVMF4nq0W3ebklEp20RIOfg4OLpvmYkuYPvznXBz+JzvEKi/LtugF4rRcpH2yE35krFhp0Gwhb/AOz1ebHI6cYUJvnzGaRbuNJyEkcbRwJBMWCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333201; c=relaxed/simple;
	bh=xzzysfSgccZUh5Ya3bjaSpT1vHoHQBNhXObhXbSXn9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FPhS6NmUmCiADVLtQQ9M0Ok2LixherZuEeD48ZbGyGglP3XHHNu1cQ30d67n4PiLK4afaDuvk3nA8r8dpapQSgm8epm/DcvROGEnpQtv9/eLg6WcCgsQnTFZqG4NXPE2D5/O/NE/72Z2H7fGM2v5SCpDb0jMPkY/8JgT1EIzk4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KPZ2ahmH; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=lf8S8E7n; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KPZ2ahmH";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="lf8S8E7n"
X-UUID: 3e3ad1ee8cac11f0b33aeb1e7f16c2b6-20250908
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=xzzysfSgccZUh5Ya3bjaSpT1vHoHQBNhXObhXbSXn9E=;
	b=KPZ2ahmHNaBUFCqH4iLHzKMEPyIg5QURwAaR9oxozUsbTV3iu5ZxSRAhcKM2DXD+dzxAYBN368V4bt1Hm6C27q14+nfv+EkCuhyJYr3cI/od/rHglw9+lrnBD4fAEgzsfb1wgcHcOjKsMpzbdFLJmoEgiWeM4Vl0S8a8MZSb1QA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:3abd941b-519e-46a2-9a1c-2c27e4185fbd,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:f7c016a9-24df-464e-9c88-e53ab7cf7153,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3e3ad1ee8cac11f0b33aeb1e7f16c2b6-20250908
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 911546180; Mon, 08 Sep 2025 20:06:25 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 8 Sep 2025 20:06:24 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 8 Sep 2025 20:06:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EA1RPLRif16445zMvngSxGLDlwDVMTW+odr5toKiz10cMtDMKrUOELg3MO+Yto0P644QLMyniXvFYLS+8zup0ZbeY2iGlPZ2POGdSCkXTq1m7g0qBhY2pHeW9Ti0gi8QOkX+5PAm2Bc14UNFALmvMNQ6ox9pzUxpZLrk+p1Q3t9Zq1I5vEJgJnT0rRgMFi6J62uTj5Llwlm8JcmKLLA1ZT76+sMzVQra4dMMhubnamJGyMdtMN/1DRo7sDCAWCRnFzG4vJgrpapH2Dx9lRXr0Ahy57G0/oNbIFgCYwo94PklCs+hPiNWsq3S/WQOnQpaDVPSIqcAYhSYmDD4fpUNZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzzysfSgccZUh5Ya3bjaSpT1vHoHQBNhXObhXbSXn9E=;
 b=phbXCIg8DsxBKZ88CtnzzdlsCN8gJXVaOJgviO1WZk9xnleV7Anv9dNNLHTYTCjP1IO78tDJ6A8EZMcRVupeJWAZxZX+b32UHc3IpqHYklvD5dFnaG91A+s45Oro38xfeQPWfUn7Kt24cxn5IhfONP0/TO0y4xqAaR+W94wVgbq2xTmK+L1aNBugjMrLOdryzZL+/yVf/le9A+qT2OtMS7/rFC+aEtGyxLXmEcaRrX+6dmXNEkTmOCrIlQd4XxJHxnG78BKeG0Z1Z48IopbMuPamnLw0ZwePVZIipgs1WEJDvxagAYlJG3DAxc1EqFLv5c0rtsvP4ABDybKd+M37SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzzysfSgccZUh5Ya3bjaSpT1vHoHQBNhXObhXbSXn9E=;
 b=lf8S8E7nqu4zTdA9ZYF3ldw61+YlEvuaAhd+A+QQ01NNJDv2o/5p1zJFoRaOF1xK2XRVceaMf/+MvON2J4AMvMvUjfyLiBTqdrGUt3y6fFkW+U2n1bmLLWPkeuA0st08MSPSudXwYioyavDZ6yjaGxice8Z0bAQ1mj/BtTDZDrg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7865.apcprd03.prod.outlook.com (2603:1096:400:452::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 12:06:21 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 12:06:20 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "quic_asutoshd@quicinc.com"
	<quic_asutoshd@quicinc.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "mani@kernel.org" <mani@kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: mcq: Fix memory allocation checks for SQE
 and CQE
Thread-Topic: [PATCH v2] scsi: ufs: mcq: Fix memory allocation checks for SQE
 and CQE
Thread-Index: AQHcIC9d8ixLmypGskypbinHK0T5a7SJMZmA
Date: Mon, 8 Sep 2025 12:06:20 +0000
Message-ID: <3fc7d28a549bf013d320cf274513090ca0403b20.camel@mediatek.com>
References: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>
In-Reply-To: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7865:EE_
x-ms-office365-filtering-correlation-id: c997be1b-84bd-4ce2-9962-08ddeed01fa1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?clg0aVpwOWdHbHhXZjlsTU8wRHpaVHAvcExpZGFtODkwejlzU3ludG93RjVT?=
 =?utf-8?B?R3J1QTJtTkllQTVSYnVjNmtyT0NTcHhYSUsvMndJUjhtdFozZGI3Njl0dnFn?=
 =?utf-8?B?OHlpM0d3eTN3TE1sYUlTMWpBREpJOTRsL2NHb0h5V2gxOGxNeWNRMElYMnNv?=
 =?utf-8?B?bm1vaDR4VmhFcjZLK2xYd3JNRWQwSFJkV3E5U0FyRmxsWUFSMnFWUFJTa2VP?=
 =?utf-8?B?VVcySE9pRXdta3B4TWljYjBFNlRYQkkxNGZtcVRBNldyaXMzMWw3Y0FPTldD?=
 =?utf-8?B?a0svc3JERWFwWmRUOTZDWndocldramYxbTJaK1d3R0lPNUE5Y0tPejIwS2FN?=
 =?utf-8?B?cGU4VlU5S2JmNGExajVFL204M2lBS29Jc0xsS3AxQVlFMDhiQXFwM1FpazJ5?=
 =?utf-8?B?eGJlWDhGalJJU1UrUWhRVWFrV0xnTGE4MmdrbW1xOHpkZkZOMVhuNXBRZWUy?=
 =?utf-8?B?MjMxLzRXeklRSUIzaENScFFxY3BPT2hXZGJyYjBNZ3lOMDlvcFhuMDlsS1VC?=
 =?utf-8?B?cTBFZEhSL3NVNkozWXZHMVlXMlhhcmQ3UEsvSnpDTit3bEhMcTlNakdBRm0v?=
 =?utf-8?B?dXRpWHhJclBkRzgxQm8yWFlyeTFsemVGaFkrdE1lT1EvT3QwM3cvRktZUXlx?=
 =?utf-8?B?Uk9mdVMwSUNhQWlhOHA2K3BiSGM1NDFyb2dIelVaSFBmM2ZEeTdGS2d1QVhy?=
 =?utf-8?B?NVJ1RnlZUUpxb1o4djBaRTFja0NaTi9sK25tWElpUjhLT3pWUjlxWTRQNk5N?=
 =?utf-8?B?V3BhL25xamhpNXBPcVhtZS9lSGc3Q3dkcU9nQUtLa2RROVRqTEp4MHp6TDNQ?=
 =?utf-8?B?RkZhSWlGb2RKdFF2M2F4SWNOMWhOM2JQdVBUYnNuWVNqeU9URGR5NldoUGNJ?=
 =?utf-8?B?ZVFncWJLUERHbVVobUQrQVNmaWhFaWNGVTBPS1h4UTcxd1dyNytRamNCUGxO?=
 =?utf-8?B?ZW1KL24waFdvUEVKcXJIclBQWnN4ZitnbDVvZkJZU1cyUFViU1UyNXpUaEs5?=
 =?utf-8?B?WVpvMlZERGJvd3d0ODJtRXM3ci9Rcy9mWmNqZkkxR2dYZjR4bksvaTlCUkEr?=
 =?utf-8?B?cFhuNnJYSzVuc0wzODhaOTZxY2xKcTIzdTAzbDZjTW16SDhwbkVoQTlacVFD?=
 =?utf-8?B?NWMyQUNNUnZZd2I2bzZOVWpSa2dFd252eHpzZmhzOUhSaCtyR1ZzTVZpK1ho?=
 =?utf-8?B?K3dFbHNwaDZHZkVxSk1RWnNUR3JHaWdVWHNua0tFSjI0aWpLcjJwTldpUU5K?=
 =?utf-8?B?dkxqZWFJc3BOc3UzcTE0UkNJM0FZUGhoM0VyMTFJSFJNRFpnQWVZa0Vtb0x0?=
 =?utf-8?B?dkVkWUZmMzF1T3JxbUF5OGNXU2wzeWZjWlBOQm56RmFIaWpyMzUvMnpROXVF?=
 =?utf-8?B?OUVtRUlUVkoyS1BDRys1YWxOTUdBUjc2RkRZM2FFRTc4T3FwSGc0UzlMQ21x?=
 =?utf-8?B?VlJwWG1EZHJab0ptYXA0ZFVUMCtleEhpYVJOamxxSWpTVmpoTkFqZ1NEK1VU?=
 =?utf-8?B?bGlRSXJwS3ErdTNJQ2xwcG1aQ0N5b01ISFZtMTBEdHdUTlNXNEZhZ1VYTitX?=
 =?utf-8?B?NHpmVkxoRVRZNjRDRzRWM2NnMjEvbWhTYXNnZWs3UTZ2aEFLUWRmUmRMQWZR?=
 =?utf-8?B?ZnBaVllNZERGd0xnT0NuMHc2Y1ZKTEttaVF1NzBObEV6aDVURzM4aldqNVI3?=
 =?utf-8?B?a2Erd0tJRjNVWE5hOERCSlVtSEVZVU5DMkxKdVVlVHZsR2NaU3lPa2Y1Q1hS?=
 =?utf-8?B?VG9JTHV5OWdXcExvR2dKbEhQUmRuQVdWdXM5YkQxc0tUOHA5Sm9hNWxjTUhu?=
 =?utf-8?B?U05ORDArV2FqSHMwdW4wcm5FVzUrUDFNYkxOU1NDcEV6bG9mclZQNFU1SVdv?=
 =?utf-8?B?V090V29zb2t5WlNHQ0dHL1UxU1Z2NHhlZFMyY0QzVStFSlQ4c2pNUHIraGla?=
 =?utf-8?B?Q2RyY1FQUk9OenpERFlJWXIwRG1EamJQZ3U3ODZRUVE3UFBwbU1CeldaanR2?=
 =?utf-8?Q?nmAi7wJyg3RYKWDaAenakioejdY7Yg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlRIRlVHa3RWM25NMWtyeU9ubTRyNUNFMTJDbnhiYndyU0pPTklvQkt5aTVO?=
 =?utf-8?B?L0FzUGlkYjdteFlVUFU1UkJGTnkrdzR5a01ZbldpQ2lZdWFxb3Rmbi9sMWtJ?=
 =?utf-8?B?ZjBqUlc3TDlWODNlNGtWRXVXc1ZqM0NGV3g3UmhpOUFNaGxJYnNNZktjYVlm?=
 =?utf-8?B?SnBXTWdwTXlTNGlLS1BPQ2Q0NlhxOFo1TXBYcjU0SGlMcnVOMlc3akVaN1k2?=
 =?utf-8?B?UTMxeE9MUE9TRndVQmp4Z2pEYlR6TXB2d3h0eHNTclgvZWNoV1c4eEpoNFRG?=
 =?utf-8?B?YjY3UE5QM1ZGdFVoV3B0bDhEMStDNVY5eUg2d205V3loczdFQm1EMk4wWjJX?=
 =?utf-8?B?ZkE1UlJJRjhEV1dLRFFXcmlVM0pMSlJYbjRvZTJJRStWNGc2S1BpTkFOZ3lD?=
 =?utf-8?B?dEJmT2lQeXNRRi85QzcweWVpRmwwWHoyQkhLWWptWE9mR0VmejZxQTJFY1JR?=
 =?utf-8?B?R0dHL2QxNjJTZm01eWpuRlFWYnM4c0llVkx3YWVzcXhnVU45dGVKYklaNEtR?=
 =?utf-8?B?Ui9JYUpSMzU4aWdPWC91MXlQMjBsbzhxa2luWTN0QjlpbitJYmV2ZjRNTHpo?=
 =?utf-8?B?UmU1VlNIME81SnI0UG12UWN6d2V3Vzc2blJrd09odTQ2L3E0Vm9DdGlqbXo5?=
 =?utf-8?B?ckxPTzJaVTIvYk5oVnhZM2RnK2JYRFBmK2lhdEJJNGxrMVoyNS9UbThSSS9j?=
 =?utf-8?B?RGdtNmc5Z2pXTnpKVGF2eWhidWJ4dmllWEdUSE9WYmZwUzVmY0N1by8rVGVW?=
 =?utf-8?B?aW9sOGl5N0ovM1VmTkl4TjdneG1QQ0VJV1p6SDZNczU0TDNhdmxlT3hLTytC?=
 =?utf-8?B?TFd3Zmo2TFJJaEJjaTRUUXBwV3ZkWkZ1QWRqZ0prWGIwcERPdUJiUW43TVFl?=
 =?utf-8?B?dkIybTh6YS92Y2RPcEI3M3A5NjJYNXJWb2pSa0FFWDRuNUtBOStpL21pREpL?=
 =?utf-8?B?RFBHVk1hRUNFdTQ1R0tMcERkUnVoV0RycXFrQVNPV1psMlVuTTBIUmMxY1gz?=
 =?utf-8?B?em5QYi94QTQ2UGE4ZGJXMWRKQkhIOWhYdTBjNU5IYnJRV1Q2aCtZTDU0NzVx?=
 =?utf-8?B?U3lCTlVReXlBTzZzQUZGWlJoVE51aEdEdlhISVdZSmVrZlk4SjBGZVd0RUFj?=
 =?utf-8?B?eDhaYm91dkNsQzYyNUVXSmFYZDY4MS9EWXBvdDdLQnNrQUNOMXY0ZFN4U0Fz?=
 =?utf-8?B?YnQ3SCsyTE04KytUOElyOWkvQ2dGZ1kxYkg5WjI2VUpTV3ZaN05tS1hKZXRr?=
 =?utf-8?B?TDVZN1RSV0pOSjNBdWo1bHptUlorK2VFTVYzbkR3alNDaHFuakZIRlRrRlQ5?=
 =?utf-8?B?bVFKVjlQc3RJMXNUUURzSXh2MnAvWkZlL0ZCclJTT3RDNjZTWmV6VzJtOU5E?=
 =?utf-8?B?ZkVyNVdkU2NTTEdWSGUxa3pDcktNNGtTY0hPd0IxZ2VCYlVrN2o4dFNxdkx1?=
 =?utf-8?B?QjFDemY1cEkxZHUycjlYK2tLYnZueU1scGx6MCtJZFBJUElVVE1RaXlHTkk4?=
 =?utf-8?B?ek5FMURMY09SR1gwSis1dnhxRFNHUkJ0NXRXelNpeGdLNGhNYkgyd1dSMEs1?=
 =?utf-8?B?VjZzaTRlYlpaK0ZMd0Nsd1F6cTExbThtbkVESGFCVVpGeGwyOE9sVUNVYkpw?=
 =?utf-8?B?RDljMDltZ28xenpFL2g1Z1RxbHQyV2Njd0ZNcll6UUFWRG9hczYxL2VsV2lH?=
 =?utf-8?B?QmFzZEVVMHFidkJoS3NHUVhQVW9Dd2xwSlExaUtseTJmYmF0akZZN0dnVWNr?=
 =?utf-8?B?R2FWN3F4K3YySkFxVGY4c0pwSzdtdERuSlZjaEhvNVBkNlMxa2dDc29CcUIx?=
 =?utf-8?B?TFZYN2x6RmUxNk1QMk9Ta3lJRUs3SW40b3JyUnVXOFJuUGhwVmFNUm1OU1Fm?=
 =?utf-8?B?cXpNL09xeGh3bHozeWxWYjEzTUw1WXRReGdGMkRTWS9MVThBWEFiclRITE40?=
 =?utf-8?B?VEtnbllpZUJnMFp6bGJvMzM3REdySVFYbEJPNmpiNVJobFNFbkFLQ0hkcEFY?=
 =?utf-8?B?SDdqUXpUNUcwL0ZwdnNjMTdNUU5aUjNIbHNpZmRUMGVOWlc0UzhEdzJqMXF5?=
 =?utf-8?B?VkE4bDlwRCtRQnN2Z2pVekxsdk1Bbzl0enFocnAzb0NYc2dzTUVveTJxRXcw?=
 =?utf-8?B?U0NUaWR5WUpZclJZRGdkYnl5S0N0eXh2Tzh6bnFnRTRZWFVTdzZ6dUxleDlZ?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58BAE95D2837F34F877BD35CAD22DF86@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c997be1b-84bd-4ce2-9962-08ddeed01fa1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2025 12:06:20.7036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owJCiG/K4f1Iewev2FOZJMBM98CoPSpBDA0dfkMYDB16QUdd9/l2kTg4lPZHAw1zfoVC0cOLcl0csmNZMZP/hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7865

T24gU3VuLCAyMDI1LTA5LTA3IGF0IDEyOjQwIC0wNzAwLCBBbG9rIFRpd2FyaSB3cm90ZToKPiAK
PiBQcmV2aW91cyBjaGVja3MgaW5jb3JyZWN0bHkgdGVzdGVkIHRoZSBETUEgYWRkcmVzc2VzIChk
bWFfaGFuZGxlKQo+IGZvciBOVUxMLiBTaW5jZSBkbWFfYWxsb2NfY29oZXJlbnQoKSByZXR1cm5z
IHRoZSBDUFUgKHZpcnR1YWwpCj4gYWRkcmVzcywgdGhlIE5VTEwgY2hlY2sgc2hvdWxkIGJlIHBl
cmZvcm1lZCBvbiB0aGUgKl9iYXNlX2FkZHIKPiBwb2ludGVyIHRvIGNvcnJlY3RseSBkZXRlY3Qg
YWxsb2NhdGlvbiBmYWlsdXJlcy4KPiAKPiBVcGRhdGUgdGhlIGNoZWNrcyB0byB2YWxpZGF0ZSBz
cWVfYmFzZV9hZGRyIGFuZCBjcWVfYmFzZV9hZGRyCj4gaW5zdGVhZCBvZiBzcWVfZG1hX2FkZHIg
YW5kIGNxZV9kbWFfYWRkci4KPiAKPiBGaXhlczogNDY4MmFiZmFlMmViICgic2NzaTogdWZzOiBj
b3JlOiBtY3E6IEFsbG9jYXRlIG1lbW9yeSBmb3IgTUNRCj4gbW9kZSIpCj4gU2lnbmVkLW9mZi1i
eTogQWxvayBUaXdhcmkgPGFsb2suYS50aXdhcmlAb3JhY2xlLmNvbT4KPiBSZXZpZXdlZC1ieTog
QWxpbSBBa2h0YXIgPGFsaW0uYWtodGFyQHNhbXN1bmcuY29tPgo+IC0tLQo+IHYxIC0+IHYyCj4g
cmVwaHJhc2UgY29tbWl0IG1lc3NhZ2UgYW5kIGFkZGVkIFJldmlld2VkLWJ5IEFsaW0KPiAtLS0K
PiDCoGRyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jIHwgNCArKy0tCj4gwqAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzLW1jcS5jCj4gaW5k
ZXggMWU1MDY3NTc3MmZlLi5jYzg4YWFhMTA2ZGEgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy91ZnMv
Y29yZS91ZnMtbWNxLmMKPiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmcy1tY3EuYwo+IEBAIC0y
NDMsNyArMjQzLDcgQEAgaW50IHVmc2hjZF9tY3FfbWVtb3J5X2FsbG9jKHN0cnVjdCB1ZnNfaGJh
ICpoYmEpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh3cS0+c3FlX2Jhc2VfYWRk
ciA9IGRtYW1fYWxsb2NfY29oZXJlbnQoaGJhLT5kZXYsCj4gdXRyZGxfc2l6ZSwKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICZod3EtCj4g
PnNxZV9kbWFfYWRkciwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIEdGUF9LRVJORUwpOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGlmICghaHdxLT5zcWVfZG1hX2FkZHIpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoIWh3cS0+c3FlX2Jhc2VfYWRkcikgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihoYmEtPmRldiwgIlNRRSBhbGxvY2F0aW9u
IGZhaWxlZFxuIik7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVOT01FTTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfQo+
IEBAIC0yNTIsNyArMjUyLDcgQEAgaW50IHVmc2hjZF9tY3FfbWVtb3J5X2FsbG9jKHN0cnVjdCB1
ZnNfaGJhICpoYmEpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh3cS0+Y3FlX2Jh
c2VfYWRkciA9IGRtYW1fYWxsb2NfY29oZXJlbnQoaGJhLT5kZXYsCj4gY3FlX3NpemUsCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmaHdx
LQo+ID5jcWVfZG1hX2FkZHIsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBHRlBfS0VSTkVMKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBpZiAoIWh3cS0+Y3FlX2RtYV9hZGRyKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgaWYgKCFod3EtPmNxZV9iYXNlX2FkZHIpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9lcnIoaGJhLT5kZXYsICJDUUUgYWxsb2Nh
dGlvbiBmYWlsZWRcbiIpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIC1FTk9NRU07Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IH0KPiAtLQo+IDIuNTAuMQo+IAoKUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdA
bWVkaWF0ZWsuY29tPgoK
