Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA11246788;
	Fri,  6 Mar 2026 00:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772756378; cv=fail; b=fTzgW5iRi2g1cQUzYeBWlohIXK2DRmNLhdypE3+9+ZrVvSePH6/lqO9SncYMn9NZwwE+RM45YoTb8s2b5tKbj4C8+jbs95xK9iJaApcXLXubwh2TpzDrLYOnIVe1T3YqS0mfCz5J/C2rC9cuYZJafYMHE/GwMo6tVMD1s0xMe+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772756378; c=relaxed/simple;
	bh=XbUVIBNjIkdkycu3Dd3lsYI0AlYp1wC6bOnAMVme+X0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FRBWKJsVJqGV1Ow5C82G4LbHugnCL95J8BnFCiwmNk1ltEE7zfWHCv1aDgK3pJHgWWkp9SAPiN0c6upkuVhwKlUQYzpayF33gymyu0+0IcKvEwTxcdUGJ3AbK2xyJSFUvxY/y26RbAE6Jsvh2h7f+ypxlQgz1c44WXr0MNc9tKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZiQFPnZh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=msxYjH9G; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZiQFPnZh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="msxYjH9G"
X-UUID: 24ad86c218f211f1a39cd589f645bc18-20260306
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XbUVIBNjIkdkycu3Dd3lsYI0AlYp1wC6bOnAMVme+X0=;
	b=ZiQFPnZhe8ho1A6ROquDfOsIE6rIXI4VIOYyy1auxdcYJcvSFQuD9EhXwTU8g39prFpa9j1I8GXvzQasy7E+bg6e+xz9AE3vL8cRV5zy+8Im0vM106Xfk7i1SwG0G9ep+ANZNoR3Lyp5L9SqwtYI5aGVP5uAX/6AGrI7HB7/Z3E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:bfff3c7d-03c3-45b2-b188-6446c2d72755,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:710250f1-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 24ad86c218f211f1a39cd589f645bc18-20260306
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2090830201; Fri, 06 Mar 2026 08:19:30 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Mar 2026 08:19:28 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Mar 2026 08:19:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQC5YB4ydonI5Y4Rk2GKWtLkMIDt+NG+930HfY3s14f3UtvqVgY1UUEmvWPgZsWObQHwo//OgKae/MM3WCImUJM/fForTmnciT6RNwYcnJ5/ILuxKuCM+v6IANUnNAdPWkci6pyRITFAr7BaH2nkqVGPVc2FythfQDdL8ZmVhtCs8YxWcElxOaScFA5ES17FtzAwTRFJJRu3dNoLf+tZ/LFhUUfRvAbA7gjTkFI66ydPvD17SXUzT35TocRCffyYeDQyloq+UVp+FtDtOCI4ZZuMpwkSHAfmutq5MWCdNgoTxasuIb5IMK5g0BsswgMyZ2JGFUIRcdY7okwNIwroRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XbUVIBNjIkdkycu3Dd3lsYI0AlYp1wC6bOnAMVme+X0=;
 b=TKR0Auvpe27D88HXdVCNRr2Jos85yFyjK727Z3LhLlQIR2FD0gu+oJwgz9e9tBvhhW0eMxVLKEqEf1oh01CMgsNPJbbKSMAyg1YU9RB+wSpe520abGHBYC5rhCC2gYvi1PFERDRM7+Z+5di2I/YCYX1HfZBYVd9Cx1gZzbMCxibP3WQ1QTjsjnJsPJQcvyifsoxCITSqtiiT4UQDdGU1XO1Kn6Kl1Bcw4btVzJLOio9N6oYoJ+GCT3sCiv/JUwzf5puArKFSdqnPMfnYN9b44C25vaqcOg9gSoGEIp5eu7TkfnDQolHSiDLbB46wCr7/XE2TqIuk6BoQTWEhIQKmJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbUVIBNjIkdkycu3Dd3lsYI0AlYp1wC6bOnAMVme+X0=;
 b=msxYjH9GE7AkAes2XR2ps2EYJ1DqdgqXfpL6/IaJAl5qo0z+EawqurAkjr6Z4fsSN1Na1DDTE/LVGpMrI6lA8un8jCm5VDKa7KX230U3As/HxFvF6xzVABUoKJR/6R92JTOoFZqcklFEM2YHp4/ekuUsmxNOd+anwBzyROhwEH4=
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com (2603:1096:4:131::9) by
 OSQPR03MB8503.apcprd03.prod.outlook.com (2603:1096:604:27c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18; Fri, 6 Mar 2026 00:19:23 +0000
Received: from SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6]) by SI2PR03MB5545.apcprd03.prod.outlook.com
 ([fe80::42a2:bb5:d1fd:3ac6%3]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 00:19:23 +0000
From: =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	=?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Subject: Re: [PATCH 1/2] ufs: core: Add quriks for VCC ramp-up delay
Thread-Topic: [PATCH 1/2] ufs: core: Add quriks for VCC ramp-up delay
Thread-Index: AQHcrHsmVCWU2bwkoEm/l+3Rczmhy7Wf3RsAgADHsQA=
Date: Fri, 6 Mar 2026 00:19:23 +0000
Message-ID: <0e812b2b96603f69467b57ae6e9836ef8b4bd1ff.camel@mediatek.com>
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
	 <20260305083610.2672344-2-ed.tsai@mediatek.com>
	 <fd1fb573-6d02-433e-a74a-1a015c64e3be@acm.org>
In-Reply-To: <fd1fb573-6d02-433e-a74a-1a015c64e3be@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5545:EE_|OSQPR03MB8503:EE_
x-ms-office365-filtering-correlation-id: 4bfb1168-0365-4779-2a92-08de7b1604d3
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: lV6k/WyOTVHQWx1OCahH9moJgtLsLaIDLDEZPA8NMTwzHEc8joDT3Kgv7JJcjhRJxGst2ubUCZ3xx5awIst5PzGg3v4SyUskxv4/TfoH0vEdKGxMDgMqChChE9wsomjhVs1BW1U6Dk0vjgRhr9VINO4KEMkHA9iSvYnP+9OrxRfSetCcN+2OkqjGquhr6hDB7UYq1r1bQ1Sk7qupcknkcYEdzvm09LHyfB1u9ig1f/qM/lzuoF9xGNUBTJe2dUkPrXR7JaVH/zkG2cBajTsD0MTPu82ykTZ4qQuSzgMqBywqFBE01YA3n6OtPoJNHh4AFt8C1IKiRFVTEa4qSMxoJM22VhsbINxpEVg6Nv8ZA5Tfe3t5u9r81vFbkfa1JDBNEXrOfVtHp5p9VJyl8FTgae9QiReLPezYfs/J7j7ysDj97yhPxC15A6A0I7idbk9A27CVJx8HXKyMNd5YYJfPU3DqlLlsTOAl30FvE/lyxyTzMSVwEnNOLBm2F1akep+uCYR1xBXVp3X/uCPy4FjapR4p0pXTzM/+W/ljmYcmw37dOdYyhXHEijL6wl2QENGfkakI41eBMN6v1d9mqxOgW0k8OZIbOaX6DXVEaZRmL3j89rVnJ3WctkhfDNGH1aA/WdC0afcjdnMnOe6H3F+zeHv2f8bF2tT1XzGp9r3Vy/6YRr31VCUy62V4VW596EW9a7RNjGgIL7lTcVJv5zLGdbFCXbpiRVaEY5GRXgsB8xI+yXvFlLOcGfd55lU/8pSfWDJ8FZruqYcsgoLQVmUJA1Cj/bsaqcDwGaqQ1UJ7NB8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5545.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkxXSEx0OS80cmwxTGVPQUN3OEcxU3B2dE5CUnB5aDUwckYzWXhZeU9MZHcy?=
 =?utf-8?B?eUo5YnFPL1pLaFZyWHZpam0vcFJzSTVMV05peEhhNVI1cjhIbUQySnpYc25o?=
 =?utf-8?B?VGk1V2FlWGtkcDhNblBHL3FTR2xhZWdvcEhaZVE2cThzd25VcGl4anQzSElj?=
 =?utf-8?B?c2MzdDVoWXBqK1NpMjhKKzhlQzBTRk92TmNMYWEreDcvUWtUSThMQVMvcGRs?=
 =?utf-8?B?VVZQUXJ4a3RGSExjdnV6Yk9jQzFPK3RJTkg5YytVdGRGbEJCcjhlV0lVWCtG?=
 =?utf-8?B?VlgxVDlJbVZ0NFcwVC9SanYvUHY0d3UrbWF1UVlxZ2RGeUV2WEl6dTdTbTRI?=
 =?utf-8?B?cE9nN1VZZ1F4cGR2YTdmbWVxeXZtVDRXK0ZwVUtsT0h1U2RONHRKKzhiQlg0?=
 =?utf-8?B?eHY1MnhleWpNWExvbE4zUmh4QlhvbTUrTGNDOVlMUHVpcStveGFaV3V5TUta?=
 =?utf-8?B?MnplTFN4aVM2Vk9tWGpQSWdpemxPQjdKWTBZenRzWTJTSy9oanZKU0J5Q01r?=
 =?utf-8?B?emQ1ZGpLeXZLSmhWTnpDNW1iS0RWZzhVcmt2R0VWYy9VckdUUzhUS3l3STVN?=
 =?utf-8?B?S3B3WEJDZHdYeS8xOHczYWRIZFF4dHB6dlR1RVA3a0ExQlh3dXpudUMxOUhz?=
 =?utf-8?B?TmlsbXp5TEkrb1FwRDdmaGJaS1RVMjM3TWRpZUtpSlFRY1BsREsrWW42MlZy?=
 =?utf-8?B?Zis4R0c4bWZMbkRyVHYxWjJkYVZvSExVL0c2cTZFdE1wTWFlYUVEWjlRNmFm?=
 =?utf-8?B?TWdCUERGc2FxWW84SVptT21peGFLQ3MxSm54a1RHM2lmNEF4SXFVaks2dVV3?=
 =?utf-8?B?MWUvalQ5VmZVbXpWMHJzVmlwYkcvK2wraW1pRk1hUTZXMlRMdGtUdnJuOURz?=
 =?utf-8?B?eEtlOEI2WWx5Tm9OeEp4WVpFQ1A4eHNYcXlnTER1NDdoYXFndVhyaHlNbW5i?=
 =?utf-8?B?bE1FUGFodlRSQjJiKzhubU53UllYa0FhVnNaaUIrakJZRGk3M29XNE5Eb25W?=
 =?utf-8?B?akJLdnI5TmdaOVpzSEZqVklsY3VRUC9KZE9yb2piYVRDR0FJQ0ZVZDJNRStW?=
 =?utf-8?B?eWJ5T1lHWVhLQ3VsR3BGS1hYdzc5bFhwUDJpYjY3elBvUkY5QUhMU0djYXpo?=
 =?utf-8?B?VnBqNVBTSUlGNzhub1Y1VzBVVnhHa252M3R3ZlpvZ3NkOW1TTHYwYnoxOXN0?=
 =?utf-8?B?SVFyVis1dDd4T3dnekRqV0pRUm95aENrMGRjeDBiK3NKNGtHdE10WmFRZnNV?=
 =?utf-8?B?QVZEVnhQOEJzMDByd2VpbXRONms2TlkxMjVVSno1UUltTWN1UUEyeWZWNGsz?=
 =?utf-8?B?aUhhSzRGS213Z0xqZ0lXSnBNVEZZVkd4SjRTU3BRdjZBY1JMOWZwdUVVU0lI?=
 =?utf-8?B?eEhvN2xjcmw5em55eTRvblA3U0F4OWNvTEdoTGFLZXM3T05CbEdnWElVcThU?=
 =?utf-8?B?ZUhqTllXWWluRVJvb1BmNnVEOXN3dXNBQXRkZWhCdWtVY1YwK3dOdHBiVm9h?=
 =?utf-8?B?c21MblZLZnJhM3N5UkZKakYrNk1FVnJQTm5HL1VEdzNwbUVLa0NqZ29UWmJv?=
 =?utf-8?B?MUN6Qml2cElQV0JJUnZHd1FWT0NRczgrU2t2Ry8zUmt6OGl0YkJyYUlnZmMy?=
 =?utf-8?B?T3VlWHZmUk5Bd1VuVnkyL3VIeWh0ZEN1MWE1bDhJOVdXTFcvcE52a3V3YnF2?=
 =?utf-8?B?cHhNS1hHZ3AzS0N2S25qMUlzYWlBeDB2KzVvZ21ORHBhRmxzUi9zMy95MWVK?=
 =?utf-8?B?NUxHcHZjZTc3QUx4eGlZbU1BN1BIVmR2RGhoU0tKTHVLQ3V1eVZndVB3dVZt?=
 =?utf-8?B?cThHRVhITmFxUHViYXZHSjByektDSXZtdjZVY0F0SjZkS1JYb28xdWdHWXR1?=
 =?utf-8?B?cDFTakZSQm15NE9QQjg0YWRGdW5wMngrOThXalNVTm9US2dlb2MxK2k2WWNt?=
 =?utf-8?B?NFRjdGZRV3dFdzltK2kxeTIvZ2lPemNxSjZKd0YvcURGWGIxTUtvT3FWK0c3?=
 =?utf-8?B?QnZHVUQ2WklDaFFLdExIanlteTcrM2RvVHE3NDZqVTdMOC9DRVhIOC9qdGNv?=
 =?utf-8?B?R3NkNmU5ZmhKRjlkVGNla0JNbmhoaU5ZYitrekJGRDVWU3dzZStXNldXTDh2?=
 =?utf-8?B?M2w0dUM1dDB4Ukl6eDVQdVVGUW9URzhyclJxSGZqOVFpOXR2WmFOaEN1a1BO?=
 =?utf-8?B?NUw5Vzh6OUlxUEZBd2FyNjJMYUJlekRYVkpIV1p4RHI4NnRjc2RiTlE0enVT?=
 =?utf-8?B?dUZYM0d2YTA2L0w3RnVOY0ZKY25NbmYzd1NYdVdaZW5IRytnNVcxQjY0WDJ0?=
 =?utf-8?B?b21WNXV3Skp5QkpoNGVZOWc1d2M3VEVCMVJFYnBXNE1CRDhuZGs5UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7899B454DA41B479B1BA38D09725AE3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: NxOFxzicWsRKEgTesMVQppjy4W6Wn53ro92AaT2Z93lqnMrdqT00g5sx1jm4rniiQuGxrZcbPSJfus6rEIb8XEdcKkeg+3eHRRgdYuQFO0/sEg8aKssFT9xdQVklEjPXghOTmiozlUCdx+F/8UxynaeWf/9pmFAqZAz9IzSxtLRzPGd+nFxs8n6t6zU2eUR/+YC9uxk9j4V6bODzj3eOTpP9Ce+sV5DBmYlV8UKSf9404vL7xKSAlxeI3pylN1bFwnivyHvlDLr7D/M+2wFXj0I5iQ8M9/bUBDvoWlR5ruNJIEMgS0kom8kouIaxE2HUCFzWv9qPo7kCtmEV849k3w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5545.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfb1168-0365-4779-2a92-08de7b1604d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 00:19:23.3149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yl3i4SvmD7B+lgdBT3wRzKZkC51ZPMWgnTt8YeeyP2LaKRj7A9QcnEreP4coSrECMMt37mqfpiNjqHHrCludHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8503
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTA1IGF0IDA2OjI0IC0wNjAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDMvNS8yNiAyOjI5IEFNLCBlZC50c2FpQG1lZGlhdGVrLmNvbcKgd3JvdGU6DQo+ID4g
K8KgwqDCoMKgIC8qDQo+ID4gK8KgwqDCoMKgwqAgKiBPbiBwbGF0Zm9ybXMgd2l0aCBhIHNsb3cg
VkNDIHJhbXAtdXAsIGEgZGVsYXkgaXMgbmVlZGVkDQo+ID4gYWZ0ZXINCj4gPiArwqDCoMKgwqDC
oCAqIHR1cm5pbmcgb24gVkNDIHRvIGVuc3VyZSB0aGUgdm9sdGFnZSBpcyBzdGFibGUgYmVmb3Jl
IHRoZQ0KPiA+ICvCoMKgwqDCoMKgICogcmVmZXJlbmNlIGNsb2NrIGlzIGVuYWJsZWQuDQo+ID4g
K8KgwqDCoMKgwqAgKi8NCj4gPiArwqDCoMKgwqAgaWYgKGhiYS0+cXVpcmtzICYgVUZTSENEX1FV
SVJLX1ZDQ19PTl9ERUxBWSAmJiAhcmV0ICYmIHZjY19vbg0KPiA+ICYmDQo+ID4gK8KgwqDCoMKg
wqDCoMKgwqAgaGJhLT52cmVnX2luZm8udmNjICYmICFoYmEtPnZyZWdfaW5mby52Y2MtPmFsd2F5
c19vbikNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVzbGVlcF9yYW5nZSgxMDAwLCAx
MTAwKTsNCj4gDQo+IFNpbmNlIHRoZSB2YWx1ZSBvZiB0aGUgZGVsYXkgaXMgcGxhdGZvcm0tZGVw
ZW5kZW50LCBoYXMgaXQgYmVlbg0KPiBjb25zaWRlcmVkIHRvIGludHJvZHVjZSBhIG5ldyB2ZW5k
b3Igb3BlcmF0aW9uICh2b3ApPw0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KQSB2b3Ag
ZG9lcyBmZWVsIGEgYml0IGhlYXZ5d2VpZ2h0IGZvciBhIHNpbXBsZSBzbGVlcC4gSG93IGFib3V0
IHdlIGFkZA0KYSBuZXcgY29uZmlndXJhYmxlIHZhcmlhYmxlLCBzaW1pbGFyIHRvIHRoZSBhcHBy
b2FjaCB1c2VkIGZvciB0aGUgVkNDDQpvZmYgZGVsYXk/DQoNCkJlc3QsDQoNCkVkIFRzYWkNCg==
