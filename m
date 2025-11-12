Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BAE53363;
	Wed, 12 Nov 2025 02:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762916305; cv=fail; b=kSXhyPhAaTZG0a/atdwDbKWiWIzFJoEUlRHImdkWr7saWfvrDdT4GetajDehEXL8NXGK9AOvPaIxhwIsnNDFR+P9MK81mv9ptD+SYc7WhqTafTPo4t7xW0rQ3bqev8xq5JYt4t6VWrtHyl25mxp0GJCnB+9DzaYC5UHOMkQ3/IA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762916305; c=relaxed/simple;
	bh=GoIQuGZo32vENt5Z3Z68Mbip5tYDKSHZUAnYT6u5zAc=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tvBRAforS2R4RcX2q8NhmTZodX5mgspahvzE0T8KS1ao1/vlpJXwKaMN9Fq6YtAZXtNnCS4Det3Ed3SoXm2lU3JrQwSM5pOe985sMlwhrQdYr44grz1nibi1JmKqoL7TOUrUCeYbNWDaDK47B9vOF4oxWBxMODrC9IKXzbX5Pqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PQNWnd07; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=scvAlGi2; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PQNWnd07";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="scvAlGi2"
X-UUID: 6beb27d4bf7311f08ac0a938fc7cd336-20251112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=GoIQuGZo32vENt5Z3Z68Mbip5tYDKSHZUAnYT6u5zAc=;
	b=PQNWnd07Y2FuoKSRILxYADCB3tiRjI3/w4xl0GnSSXIqZ7whcxtUpAizDNCfpixbyYImaImuroZ/kswVcZh5kHdFPK+J5pv5XL4OHSaXxDsJ/JNtdFcZLfk5vOfkNKuyxQHe/BDLjeHLKFJLdbhFhHlShNwL9/UWlKf3EpaWVSk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:05c6a669-fca9-4fb0-8512-3bc215472e6b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:bdf38b82-b6af-4b29-9981-6bf838f9504d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6beb27d4bf7311f08ac0a938fc7cd336-20251112
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1982725746; Wed, 12 Nov 2025 10:58:10 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 12 Nov 2025 10:58:08 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 12 Nov 2025 10:58:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YIAmxwo2InAMUveNTxty8omvobct2tOs4k74V77pSNLDhOCmUxgMEspvmpaj6DvgTWXZ0HlO4MH7Tr5XbVdMnMMWGdSoMHC0Yf3zMHhqS3d553ydH5UiBdgWZjNawnvqTA2y77SEr+7DMHAlxkz9DSbC3WPTPtCpwruBro8KtV0hWmTKkL8QTWPc8DlOObTektVQ4vk8FSEgt769Qa5SF4j8snOK4j/WQuLF4zAj4++G66mayiheZUjC8s1k42axopjLENHiPTZ23oXsAz3oaPRkva5XthYp+Z8BZv+JRhgtXvCcp/jZW/aspC8Nt6MjgTERXW0wBxiz3FaMZF2klg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoIQuGZo32vENt5Z3Z68Mbip5tYDKSHZUAnYT6u5zAc=;
 b=fGFTz5o6qAV6/diXqSCQa5t/2ZtyQO06g+P9dIIV0gQVnqePlhRDv6zuQTesuCcVUZO1ZvrDYk49zS3v/or0FT/A41yxQGnRp4TAeAZmHEtxupiuk5Q8kik1uD9KpLe7kaQxMXBDKwTgCeHCWwHwTcz9lZTQTjbRfhqtPoXv/KENZPdRUXF8tXfz6EjCX1LomU6gyQvRuHovBfXZqSmrpVtp/J6xm3jCxOjkyuWK5H1rUeyXkbPgYJL5Z+Rao+AL4h70piF/h1lPwDlrcul+xbPIZzdr2TnVV+UdLi89EZXQTKd0sTnq7IYue6AZDm8wfLNMModUtDgq+gNSmOU2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoIQuGZo32vENt5Z3Z68Mbip5tYDKSHZUAnYT6u5zAc=;
 b=scvAlGi2GHs9PVxT7mLFKW3Ho6pxD7HgTrCMq7Ty1kAgRd1sbkGSLRO0zPqLpgoPAv6pPOwMyUKtCl9WIYTSqb8/kCHx2QOrN83RJm0t7XN/6cS+u+iyc8up7FvzQcEZCNibubsToc4dl3mi9ytHLZex1ZQeFfqqbxfCzmnPC9s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6825.apcprd03.prod.outlook.com (2603:1096:4:1d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 02:58:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 02:58:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "sh043.lee@samsung.com"
	<sh043.lee@samsung.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"storage.sec@samsung.com" <storage.sec@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Topic: [PATCH] UFS: Make TM command timeout configurable from host side
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwA=
Date: Wed, 12 Nov 2025 02:58:05 +0000
Message-ID: <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
In-Reply-To: <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6825:EE_
x-ms-office365-filtering-correlation-id: 51fb49a5-1181-4216-3310-08de21974d76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SEhoa1RSWVFteHhlMEhvYVpjcTNQUVJnVGRtMFB2RXc5anlaMmdiZ016VnhK?=
 =?utf-8?B?MEVmMG9GMDk5c210TmNBRUIxTjJJRFpEOTIwTTNHU3Z4S0o4QXJkR3hiczZ0?=
 =?utf-8?B?L1VvQVNOVEJzRnJLL3B5M3NFbXdUSlFGNXpWWGg5Z0RGTnJxTndYWGV0UG05?=
 =?utf-8?B?QXJYVnJla2xPY1c3MWJtcklsREZ2d3dLWVoxRWFyTTNuazNCaFBFWk03NWll?=
 =?utf-8?B?NzM5cm41bzg0NWRHNjNYOUVaVFdHTm54V0pXT3lLV0VPUWRZazdCMGlyNElv?=
 =?utf-8?B?TjRJTGovT1Vpbm5MMTU2dG5KYmFuNjdtWWphdC92NTZRcGtaQ3lxNDhLb2ZO?=
 =?utf-8?B?WWFINkQ0ZllqMDVhMDE1eTJRY0FDU0xrc2dLMXB0dmZtVHBNZ2lwTmdta0hq?=
 =?utf-8?B?eW1wN0V2ditoQ3pFeXJoRGphU2lIV2EwQUxLbW5pSUpPREk0T01rT3MyUnVo?=
 =?utf-8?B?YndoR09YUDVUWWxKczlpMHM4ZUtSZGZ1RGh6Nm52OHErOURBRUordTQzVjFH?=
 =?utf-8?B?a2V4WVRheGVOTFZETEc2TWl5SkZjaU9aMCszNUI1V29qc2cxZ0VZdXBqK3Fz?=
 =?utf-8?B?WkYvb1ZoNVBYN0E3Z05za3QvdlZPQkhmcWtaNlJZQXBHQ091bldOb0s3ek9u?=
 =?utf-8?B?K1Y4T0J2UUsxb2lzekNQNm9nRG10N1MyNTNUcktuRzFpa1JmS1lsWklnRkxT?=
 =?utf-8?B?ZlpvRk1xam04cnlmZUc3RXZRS21nSGZENmJpOXhvMlVqK2p5RzJCM2h6dHM4?=
 =?utf-8?B?S08vRjBGa01tUTVmbmc2Umk1RUdzWVIrTEtFRVNkQ0hTMnpTYUFKR0JBMDF2?=
 =?utf-8?B?VSs4WmNZTWJrUkh2VHNMY3YrcHVNK2phQnNYM0JvZEpRa2hjZWwzMmt6Nmgv?=
 =?utf-8?B?dE9uRk5PTVN4S1pMVkNhVEEwQXhMSThyckttUlNuUXI2SS9aaDliekJGRWow?=
 =?utf-8?B?Sms4bVNzc1paTjhWWEgwVlByQUpzN1kwRm1PNFpNODF2NVJ5cEhoTlpOT3g4?=
 =?utf-8?B?OGM0U2ZpZC9kSUFINlFMMUJ6T1psM01TLzNsQW9iTW4yTHFiUW1VSU9hVUU0?=
 =?utf-8?B?ZytTM2RnRmtCbkkyMXkyZmZUcjBvNm12NUVaazlHVmc1WSthcTVWSkZyeStY?=
 =?utf-8?B?dllFTCtKekkwTWk3VU1HN0VPeUJsTkM5TmZRQ1NHdGJmVXpqM1hyUFFZTVNq?=
 =?utf-8?B?cWxNamEwMy8zZHlQVDFrUFIxbnFQbnVpNDJzSHZ2REF1T3RJNXBxdW1XTno4?=
 =?utf-8?B?eEdoNENCQUsvdFhOcno5SUMyZnlEY1BiZktQbWFWOUxZUGczNTZSNzZNc1ZU?=
 =?utf-8?B?cG51YVdlNktUSk42bGkxVmN6YmovR0VVeHBzbktlUThpcjVBTHk5L0VOWENw?=
 =?utf-8?B?NUJrRStXOCtZNUtNMXQ5R1RSM3UxcUtEZXZPaTZOTyswQUZrcXBXRG1aWVZY?=
 =?utf-8?B?VmRUR1h0SlpHQ0NES1pJc0pLVmZkRUpQc3ZIa0I1MStGNVozNndWL2IrOTVS?=
 =?utf-8?B?ZVgyVzg2aUJJWDZSTlUzOGhUdUxFczdDcmpOSUFPMUM5SUkrVkpkMjgrQ1h6?=
 =?utf-8?B?b0VNZ1V0ZEx4dEp1YUJuR29ITVFVams3VkZwa21KMmtqait6aDV5TDJzVmho?=
 =?utf-8?B?Rzh4VGtPNUtsS2gyME1DclBwMFBjdXNMaE1yV0JFeEpkWmxEYzRhZHh4NEVQ?=
 =?utf-8?B?Yi85bGt2T2x2RUZNMnNtVGVzNXZOeCthbk9HdW5jUDVrNHJycXF5NG83bDJY?=
 =?utf-8?B?T0RwazZhSUNHbTJTREZJRVpiM3pML1VYTUFMazBuMDRNSW5OUFRVWlVjUUN5?=
 =?utf-8?B?ZUpwZS91T01kazJHbUZNdGFNbWQ0SXlsZnBXTG1CQ2pSOFJNeDk3RzRJVzdP?=
 =?utf-8?B?VDNtaUZhdXY0YzdEYUk4ZUE5SWM2cnEvVzdoRzVLZ3VJeFRBSDFGc21QK1pR?=
 =?utf-8?B?WWJmaFJKMTM2bUtrclNLeDc3dlN1VlVXUndZMllqQ01ONklIUS8xYjJveGUv?=
 =?utf-8?B?WXFnb3o5emd6MlcvSkRubWZ5ZFZOSjExR3p4dWNRcFR0SEdGZEsyMGlDTmhG?=
 =?utf-8?B?dDVPdkFIZzNzTmdqVVpHMTluTGFpMDJ0bGdPQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y2d0bWdKanFwd1pNeFB6dDBxVjJab1ovNk5qTnFZc3NiZkxuMlRsSUxBSjc0?=
 =?utf-8?B?ZHFJYVM1SEtxVEJGOXRUVE9xN0s5L3IwK0gyK0JXNitwaG42SzQ2NHV2Mmg0?=
 =?utf-8?B?UG1aNUtUL1NzbWRuL1ZVTGNYaVN3Z1YvKzRSTnVKVW9iK0dvdVFHUllWUTA1?=
 =?utf-8?B?Nk1iaWM2cHhVTGVUMkx1S2tleEZ3WSs1T21IdnRNYVk3em03M3VuSURPMnk5?=
 =?utf-8?B?NzJ0NnNUTHlQS2gvYW9VbThwMERuanlBQk1LZjh4d1orcnpuaFErb3M2SDNt?=
 =?utf-8?B?ZHNGRHpPK0ZpMlkwUVE4ZUZTcWhDSE1sblVaNWkrK2hJVDFNOFFNUm02NmR4?=
 =?utf-8?B?WG9ZWXVxZmt4aXQxZU5PajBaN3E2VmpSbm4ySzAvTWxzTWRxbTFYYjlPN0Rw?=
 =?utf-8?B?MHVXanRheDZLY2pobktGd3lXcjIvMXJFZ0l6NDJDNVYyUERxTmxBZkhDcGdG?=
 =?utf-8?B?OTBkVzBYcytoM01OdmhHeE1zbXl1T0N3MDFuekZodGJqbkNvcFE4aDlaSTho?=
 =?utf-8?B?NTZ6TndUWDlWa05XNC9UU3hUWXVQVVMxSHJmOHlmOG0waFZkNXJweFliOGt5?=
 =?utf-8?B?SnNrZnc1Q291QVh4S1RXRlRnc0J1RTZsSFJZdmlGcGZiK1BIVVZsbXZjc2FQ?=
 =?utf-8?B?OVZmUkxQMmdMbk1md1ExMlQyVzRpMWtyang2YTdjbFNFRkZtMjUvcXh0andW?=
 =?utf-8?B?ZjJkcWpNbDNhWkhac3FoWTNJZkEyTitmb0hwNjBncXVEUkRJMmpnQ1dRcG9B?=
 =?utf-8?B?L0x6U2ExbUZtMGNUMFRDcW14ZjBvSHZwTTZtNHIvMXpMWnVtZWZrbDFwWFl2?=
 =?utf-8?B?ZGE3OStYZjk1U29Fc0E2bm1kZmxya2orV2RjUVhyRkk2YWNxZGcyZXdvam94?=
 =?utf-8?B?VjVPVThDVFl3YWthYmhyQ1ZvdkY4MW1pOERRQ0UybzExOWtqT0ROQW1VOG55?=
 =?utf-8?B?djVIbWhnRGhOa3RZMlBNZ2wyaDVob1RtaWpvbWVVWFZYZWpOdk5nVjRYY0tG?=
 =?utf-8?B?TmdWNndWTjlhM2VWYTBJUTIvMURBamMxTzhBT2U3SXc0dUhrMVpreElvVDRj?=
 =?utf-8?B?TEc5eCtpY2tZOWtDUzN2RnIxQTBUODFnWjFkdUFhNTcrcEo1WGl0MGttSHhZ?=
 =?utf-8?B?aTQ4ZzQrb0lqKzdCUXpZSnhzUndmUi9iaXVOaTZHUlF6THZMclc3U1ZIdERy?=
 =?utf-8?B?YjllM2NMOVl3YTREckV2dDFZemxFQ21XWmZ5QUFrbEFBVXhEVWpuY2VFVFJX?=
 =?utf-8?B?R3RqMzlhNGF1TzVRTkVBRjBnR3YzNmNFSEcyY0JDVS9MeUY3SjM1ektEdkg3?=
 =?utf-8?B?M1NRa083dllkVWJPU29RWDhBQW5kNFlIaU9UNWxIUUtHcVUydUVrcVROQzJ3?=
 =?utf-8?B?elJORjQ3OFVEaUtsRGJTUG9QeGd4QUNmUzljclpmQnp4VHh4MnNSU1IxVEJ3?=
 =?utf-8?B?RUZCcU5iQWg1Z3R5YXdnckF1ZkN0REdpelZ2UVFDb0FQbDhSaG1WQ2VoaTBx?=
 =?utf-8?B?dVltNFhkV1RnWUd0dDNxMmlrUkdDa29xOUdIRVlEQ1VKYkc0N29US1dRTkIz?=
 =?utf-8?B?c3ZBSmVXekFZekEzaTZqSFhKdFVwdmtyTGFNRnNYL0dUYzhLa1lwTEJyeStz?=
 =?utf-8?B?OWFuUjFBSTFPdml5QlN5SnBwMHp3OFdEY1BqbEtFS0FOb2Y0N1VIVEJiWndB?=
 =?utf-8?B?dUZBK1ZmUHNjV1FIYVM4d3JyS0pFNzhpVG9Ka3JXdU13SXcwOHNVWVhKZHo5?=
 =?utf-8?B?aFk3cExLRWc1NzlLaXFEdnE0ZW1vdlZQb2d4aWtuZGY2dE4rbE1EdU5hRlhG?=
 =?utf-8?B?M21uSStQaVB4NzFMS081R1VoRzhOKytjU2cyb21vd1ovcVJHeVhXUXRZT20v?=
 =?utf-8?B?WVdsZ1p6SWxucE92djZzQVRhaVFndUtxajhXSWtNMXhUNDZUSW5mbGVNZ3Av?=
 =?utf-8?B?TDR4T2pVNjMzaFdSWnMxVWgzZERoMlRLSWsrZXROaFVlTGdKL3dQNkFYbDI4?=
 =?utf-8?B?QVNBdWVyeDk2NGRPekFYRm9EbGcyYkphV0llZFV3S1o3ZStqdm1nRmN1c0ZL?=
 =?utf-8?B?MVpCU3JKYlJLSHRGTTdmdkFhdWN3STdKcHRKRUZpQW1BZ0gyeFpxUVBZT3NP?=
 =?utf-8?B?Ri83clhjZ3hBRHphcElZalNranVRQytJVGh0b05lY2dJaEkvKzV0UFlrR0dD?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41BA62A1BA8E9948ACE02B2825EFE7B0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fb49a5-1181-4216-3310-08de21974d76
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 02:58:05.6091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmn5+ktLdS93YuRXaRET9wBBJCMS12mzSsUbgJpt1h2+HxN1DaDJTf/brBTmqtehnj4GS9cNnoCsbeFeLHFlzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6825

T24gVHVlLCAyMDI1LTExLTExIGF0IDA4OjM3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBXaHkgYSBxdWlyaz8gQSBxdWlyayB3aWxsIHNlbGVjdCBhIHNpbmdsZSBzcGVjaWZp
YyB0aW1lb3V0LiBUaGUNCj4gYXBwcm9hY2gNCj4gb2YgdGhpcyBwYXRjaCBsZXRzIHRoZSBob3N0
IGRyaXZlciBzZXQgdGhlIHRpbWVvdXQuIFRoaXMgc2VlbXMgbW9yZQ0KPiBmbGV4aWJsZSB0byBt
ZSB0aGFuIGludHJvZHVjaW5nIGEgbmV3IHF1aXJrLiBBZGRpdGlvbmFsbHksIEkgdGhpbmsNCj4g
dGhpcw0KPiBpcyBhIGJldHRlciBzb2x1dGlvbiB0aGFuIGEgbmV3IGtlcm5lbCBtb2R1bGUgcGFy
YW1ldGVyLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KSXQgaXMg
bm90IHJlYXNvbmFibGUgYmVjYXVzZSB0aGUgdGltZW91dCB2YWx1ZSBkb2VzIG5vdCBkZXBlbmQN
Cm9uIHRoZSBob3N0LCBpdCBkZXBlbmRzIG9uIHRoZSBkZXZpY2UuIEl0IGNvdWxkIHNldCBhIGxh
cmdlIA0KdGltb2V1dCB2YWx1ZSBmb3IgdGhvc2UgZGV2aWNlcy4NCg0KQnkgdGhlIHdheSwgdGhp
cyBwYXRjaCBhbHNvIGRvZXNuJ3QgY2hhbmdlIGFueSBob3N0IHRpbWVvdXQgDQp2YWx1ZSBpZiB5
b3UgaW5zaXN0IHRoYXQgdGhlIHRpbWVvdXQgdmFsdWUgZGVwZW5kcyBvbiB0aGUgaG9zdC4NCg0K
VXNpbmcgYSBtb2R1bGUgcGFyYW1ldGVyIGlzIGEgZmxleGlibGUgbWV0aG9kIGlmIHRoZSBjdXN0
b21lciANCmlzIHVzaW5nIGEgZGV2aWNlIHRoYXQgbWF5IHJlcXVpcmUgYW4gZXh0ZW5kZWQgdGlt
ZW91dCB2YWx1ZS4NCk1vcmVvdmVyLCB0aGlzIGFwcHJvYWNoIHdvdWxkIGhlbHAgbWFpbnRhaW4g
Y29uc2lzdGVuY3kuIA0KT3RoZXJ3aXNlLCB3aXRoIHNvIG1hbnkgZGlmZmVyZW50IHRpbWVvdXRz
ICh1aWMvZGV2L3RtKSwNCml0IHdvdWxkIGJlIHF1aXRlIGNoYW90aWMgaWYgZWFjaCBpcyBoYW5k
bGVkIGluIGEgZGlmZmVyZW50IHdheS4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
