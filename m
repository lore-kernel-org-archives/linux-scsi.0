Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7429335572;
	Mon,  2 Feb 2026 08:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770020115; cv=fail; b=i2NwC6tlsjGDIsv56U9jGIFJukXJO/pNNLwVBKSqtY14I3B+e3cG7LXx1Oa3A7H1elp8pVN6bJiO+0ZcT6RJiDFd9ATBrjZqAT85+8jMxGRQnStmBTMIYRg7pFIU5Ib64RBbUsoVYf6eeHFCbFemMeA2T/28KcLGAOqZHdttdNo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770020115; c=relaxed/simple;
	bh=q0kN7IiTdxjLbrVgl8o8zq0M1X1EpmSIjj5mJYkhtFE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SBOozOVYKA6qdnRJSKwrcbepQB7wiNIADY2524wiIcgyAX4fAxGSQ0eCxHtFt3RSycYhSvEc3N5VRpBN8TXYoIWngA5I99bS7VkWJI5Jcgu9vWrbfaggp2hppsmr+TlzjrvGjEdmBpDYPvEgTP0tgI5Wmfg2MtL4M6Ple35amOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XUnwsh9r; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=AAatv7/7; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XUnwsh9r";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="AAatv7/7"
X-UUID: 4650ffb2000f11f185319dbc3099e8fb-20260202
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=q0kN7IiTdxjLbrVgl8o8zq0M1X1EpmSIjj5mJYkhtFE=;
	b=XUnwsh9rWanz8MnmUo84InmeR3SE3i+k697RspVw3ZXMPuQdO1KPo8+9L2fnjEl5dsEYRHlyPDxk54Vpkg34Gsu4wtsN9gjsCkiX81sPMROaplsDXA76cW4XZtFk2/+F5LUrDJ15+MUQN8edchDFej6OapRKvnLQwzpVy6FBgN0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:7f5f9175-633f-4bfc-bd58-55d6f65cc2a7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:e69dd35a-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4650ffb2000f11f185319dbc3099e8fb-20260202
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1122264326; Mon, 02 Feb 2026 16:15:02 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 2 Feb 2026 16:15:01 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 2 Feb 2026 16:15:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uiItan4Zyj+mTp0mDPV1fjlb65zrD5a4q38T8fgtNVsCBtQ6QNM44Zip2VHQZZVHhP8sTXTOhuyaLrd9c2g0kJWVcCZCijTDv9QHKejL0Z4tGOwVTlDvk1lki1rN3P3oQY9JU+Dg4SaWh2tvBeH+cnEmgsio6B4cI8S2Q9C1/t8lMqvFRhRHto5B9cgPsgWsaH/UG0I9UMWDw5ubaseXv3SRqz2F9jx9tvI48dfNsSLI1wMICmdp/Siuf3MJ4KDE2L4HaW6DhNcij67bq/BjZmJl8KCHEPZvRf6kRkfJXEAZBdp1LuEiTYc83WF/hyqGLK6JhvKOoFxu5ilF77DhkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0kN7IiTdxjLbrVgl8o8zq0M1X1EpmSIjj5mJYkhtFE=;
 b=QzCdIgxriAPId8ynvA8pBonfk3MwkTwL/tEad7sUSIIYg9y8RJwukxpPqiLuMjWf8qkvcFj/TpmRpZMstxBVrJjNq2KKYpmtpmwq99PSarYDXfFoGwV0PzrMH3b5ZSzb6yPGRvdayW0EYp/q44//s/8xyySbm+mypHjnJ2ZPLJ29CsPemJFDXKm5WKE260s3ZqNBDJ2n/iTKnpXx77kzrnlXdC7AvFkIbiYNcL+XpR9s75n+Y3+7ZHaGbLktFulNtBzzpk0gUqY/P0CfO9RdNM1kaA26lBxIq2cFKNPy1azVAjztJQuADgGUi46VrTCyyWmOxln8xBUAtWnqSV3StA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0kN7IiTdxjLbrVgl8o8zq0M1X1EpmSIjj5mJYkhtFE=;
 b=AAatv7/7uEuot8pUeKUibmJSVdAns0UeqcM6wPr7InTCs+7h+ebuejmMhR/yz+AiHLsjKCaQKqrSDQuqMe6PmTfy60Swz/PHw7KujfgU7FlZbxsU9ABZpCFPvOsEo6wk0eNYkESnUsctiMN0aKV3I07gnY6H5iWDYeBDTboX8cI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7720.apcprd03.prod.outlook.com (2603:1096:820:e8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 08:14:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 08:14:58 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "keita.morisaki@tier4.jp" <keita.morisaki@tier4.jp>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= <Chaotian.Jing@mediatek.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale
 trace event
Thread-Topic: [PATCH] scsi: ufs: mediatek: Fix page faults in
 ufs_mtk_clk_scale trace event
Thread-Index: AQHck+4axqH/0GHWDU695UqtUW08n7VvECyA
Date: Mon, 2 Feb 2026 08:14:57 +0000
Message-ID: <e02c66306c10dad50cee0cdf886948d8d448f0ca.camel@mediatek.com>
References: <20260202024526.122515-1-keita.morisaki@tier4.jp>
In-Reply-To: <20260202024526.122515-1-keita.morisaki@tier4.jp>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7720:EE_
x-ms-office365-filtering-correlation-id: b6d6f09d-c1a9-40eb-98d3-08de62332791
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SG1SOUpOazJSVTJRZ1dINDA5aHNWOVRFYkpTNHVjYXhCMGxLNG54dFU4QWJr?=
 =?utf-8?B?dUNKaTE3NGNnd3d4aFlIQ1F6RGgrMFpXbGl3OUoxU2ZNZXVTSEdna3M4bFJo?=
 =?utf-8?B?RE5SbFp5S1RHR1FlL3pDdjNSWHgwRDRXNXllTVdWVU5iN1ZHcHJycHdSY3VH?=
 =?utf-8?B?ajZUU1JFVFNJc25RSm4yL3pmVnp5ZVRyejExdmhSRGhBQkszWm1mbWhKdXRF?=
 =?utf-8?B?U3JHQ3k3TjBmbERBSjlEOHFmc1cwdlVkeE9Xb2cxNmJIZ2FjNitrSnVFYita?=
 =?utf-8?B?RXhiUk12dTROTVRWcUZqN1NwSkFMb0FIMFhaT3RUOFlaZWdEc2RLN01FYmQy?=
 =?utf-8?B?OExxTUozYllCTGtxSTNIN1V1aE5xZlh3NS9nb2NweWNBYXpxenJDaXNuM3pB?=
 =?utf-8?B?am1HVXVXZnVnVm1BaDdRRkd1eGRRZGlueFpIZ1VhdkFyUjYyQ2pJN3NhTVJW?=
 =?utf-8?B?Q2JLTENKN1VkKzdzTXkydnFZNU5Ndks2ZGswdkkwSnRTYWNIVmNzYnFsVTV2?=
 =?utf-8?B?LzVHbkFJM1cvYXp4b2d6TS9meGpMVzRYNkQyUWpVUGpDSzVCUmp5MFZ0b29Y?=
 =?utf-8?B?RFRPSWluRXpndy9XV3BPSzFTK0I5alM0N09STUlkODFaTkFnQnk1cmtkTTFR?=
 =?utf-8?B?OEdCZ0RibXZMS1hMQUViTVUwbW14VXF6cVFMVVZKMWtZa25tb0RxTVZjNyt6?=
 =?utf-8?B?dWlnZWhDdC9UV1F2cGVYOXptZ0YxVVdvajkvQVo4UXduUm8xSk5mbStraU9E?=
 =?utf-8?B?UGlqU0dteG0yd0p6SzVmU0RnQllKTVE5UTFLV1c4TTFUWnArbnFUMG8rL1Q2?=
 =?utf-8?B?d0VIQm5TNWExS21ESkhPTjdrcTY3R1Y3K2hxOU42YWZhU0x6NmVySk5EbHhU?=
 =?utf-8?B?ejAzOHBFVnI1WmhGNzZnNU1WYnh2K2ZNTFVHenZ1SDJxMTIwL2J4a0dFaThr?=
 =?utf-8?B?V2xUK1pBZTdPTmpETTZJV0NtZnN1cGtWbzJKa3hTNldBYUtqZGIzeERaY3J0?=
 =?utf-8?B?aE1zRGdFaWVmYWJyMy9kbjJ0VmZMcldJN0h0TDJaa0xjamo2ZnRYL2l5R0h3?=
 =?utf-8?B?WERjVTVORVA5Vm03UHJybnMxZjN5THlrSEZCcW9mWTcwM0dlbGJLMEJLUlJD?=
 =?utf-8?B?REo2dUpGL2t4TW01ZFhkVytzQnZJZUtPcytWb1BKZWtGZXdqdUhOaHAzeFdQ?=
 =?utf-8?B?dkV6QVZOcVpSOUNHZGplNjM5WUlUTGc0SHR0UHFNVHVkUzQ0UGEyQmNVckow?=
 =?utf-8?B?TDFuRTFITWk5MjRYRm95dThWdXVwRGVzSC85NHdBS2lOOFJOa09wV0pMVk44?=
 =?utf-8?B?QVJsejlqTzc4UWlQZ1NEU3FrM20wekdWWmdVSWlLemxhdWtTYmFLRUxDUHlk?=
 =?utf-8?B?YjFuOFFLbHhCNURIRGRLcVc3enVLQk1jbFN1ZUZabGFQa3BIcGJJQWRzVHNh?=
 =?utf-8?B?WnlKSytPOE9GUldJTXYrUWFxQzZDZFlSZVIxRU1Ta0MyMG9mWTVReEVqNXRy?=
 =?utf-8?B?eFVHRVhYWUxTcCtKWVVick50amhCNTEwWFR3ZVptYWkxVDdQYkNPTnlEVmVp?=
 =?utf-8?B?MGxEQlowWnY4K0ZnU2hQV1B4Ky8vWkFNWUJPU0FtNkNDalB2WkxWVWowK3pY?=
 =?utf-8?B?dnZGS1hxbGgxNURuaVZBdm9nUW9KMjU0aVdQbFNEdEhGZk1WUTQ1RDl1VVUz?=
 =?utf-8?B?RGZUN3p2UTE2cWE5RUVZWXlxUDFTUjB5VEg1Lzl0RFNRS0lwQkE5bkt3bk16?=
 =?utf-8?B?bUh5cXNKTTVyRDM3djExN0lVSmlxS2NDeUxsUmUxSnVCVGpnbERHY2ZCZDl4?=
 =?utf-8?B?cWVVcHhKalkxUXBONkhXREN0aE1PSHN0TS9FekFwbVhkZG1uWkp0RnZTc3Av?=
 =?utf-8?B?ZndieUF5WkVFbWQ0Yk5xaVd1R3BQbHBJVjBGOXIzSjBYTmtHblZKMkhFZmo1?=
 =?utf-8?B?MW1VWDIraXZBZndIditHZHlqMFVXNmpxUDN3V09BY3QyLzJVeUhXdWh5c1h4?=
 =?utf-8?B?eDVHZW1qdlUyNFkvdkoveTJ2TnBrVWZIUEV0bmRMWWlWVlk5am9Ha05Bcytu?=
 =?utf-8?B?SzRKc1JyM1pWdUZIc2FjcFI4U3M0ZU9NRFpIMFdTeStNclB5aFlmN2Z6TDNL?=
 =?utf-8?B?Rk52UDhUYk5KZkFvNUN5ZGwyVzZPUXZobHlhWEVoL2hQWnhIK0d6endadnZw?=
 =?utf-8?Q?LvAU7E5Y9ZdzZ7Ka9x0mOYE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWc3cnk0SFAzeHVDcUZSYitUejIxTTdWQ1hjY0E5SjhmZzJUbDhURmxFeGt1?=
 =?utf-8?B?dHRoMjBZRS92YXRnUU9TUkE5dmVGM2JzdE1jZDRBdXBQc0IyNkJVMFlha3A4?=
 =?utf-8?B?dG5yZ21OVU9naWZlbGd2VTRMYnM0T1VaQlpSK2lGZHF6Q21sWHFGU3ZJdVV6?=
 =?utf-8?B?cmNBOEZ4cmYwSCtFZzRDMi9IS3h6VkFvdlR4VzRsOCtySmFaRmRsai9OdTdI?=
 =?utf-8?B?Vko0b2Y1YU1aemFCa1l6NDAxQTc0RXYxS1cvTy9FOXFSbTdkS1VNcWU4dVRa?=
 =?utf-8?B?ZVRVWm1DdUc5R0ZIUTdSaG5CU0NjNEdSL3NuY0Vsazh5cjRFVTlVcW82UWt6?=
 =?utf-8?B?Mjh1WmdodGs2K0tuNDQvdVhRdTY2bHk2UndJdFg5bDcyRXZ2c3lNUHZjdDFI?=
 =?utf-8?B?cy9oSVlLMUpsTElHOGpMMEM4S3YyenI0WUVhc1Q1bjEyM1dtQlBRVEVSMXZu?=
 =?utf-8?B?MUVUSmoxT1dWdzl3c1ZOS3c3Z0RUeGNWVjQydHQ1eUZYb1dpL3VvMnBoUndP?=
 =?utf-8?B?emE5UVZ5Uks2V2xsS1hIZkt6RlpiS1AxSDZIbEJhRnhnc0g2d3hHK3U0M24v?=
 =?utf-8?B?cE56d1V5SlZ4Rno5V0hZam9WYkVxb1lZeUN0d2JCYWk3NlI0aG4zVDI4VjBw?=
 =?utf-8?B?aVJCbEs4L0QrYy9HMDlxclFJZ1BSQ2NMQ0R1RHpVazU3NEgxUWcwVTI4SXc5?=
 =?utf-8?B?SjRPejhnYTl6Y0ljckpmQkg4L2V5TUtSSHE2RU5rRUV5aTk3RENIVkFQaWVn?=
 =?utf-8?B?a2pPbzVUTDlRNFJjSG5lZm5FL2pZWWw2K3R1aXhWcThYSy9YZ24vTEwxUGY4?=
 =?utf-8?B?L0htUTUyMmRwWkVzeXhUd0I4UDVTZ0gydncrUm9oTlhDS1dmcUJxMXh3bXR1?=
 =?utf-8?B?L0pDZEdXVkhqRCtDUS9hUjdrNkF4YWMvYndaSmpuZGtTZEhZSDZ4QlI3eFRC?=
 =?utf-8?B?MjR3K3FUWWtWTnVpRU1QdVY5NmtqS05rbGU4cUlKSFdjd2V0UzB6S2dyTHlR?=
 =?utf-8?B?a0ZlSzMwMTc2RlBSWlRqdmxBaytEY2MxTnRwc1B5dGl6VjRDK256ZzZ4TitG?=
 =?utf-8?B?cWNwRmpocjREQnEwTjhqVGRqTW9VRkZMeHA2dllVcEJDS1QvSkhmQlA2NDZM?=
 =?utf-8?B?K3FKOUVtUC9KVVN3b0F0ZDBvWG5NaXkrdnpvNVFEUnZGTVBKL01MZFh5WmtJ?=
 =?utf-8?B?OXR0WVo2dTFsK2JRSGxRMW5WTlZjdEF0MGg4QVN1ZGN0OFd4dTNFNmdDbjlm?=
 =?utf-8?B?TThKY0VnQ0pWUGMyYUlHZVd5ZFdxQXZhZVVGZTlSN3ZjM1VuOVJQQ2FoUDlN?=
 =?utf-8?B?Y3ZIdkNCUm5xQVRlbUNMNVR4T2JrZUYyazBnNnJBNDdUOTlMMDIzY3lWeTVX?=
 =?utf-8?B?TmQrREtobGVMWXFqUTc1VjFJaVZhNGpjRlBzK2RFUGF2VXA3YlZnSXlpWU02?=
 =?utf-8?B?bnlJeUlsOGRic3ZYKzFuMjRmR0J1blR0UGdoemlEM2QzcmtmazFtczlPR3RW?=
 =?utf-8?B?MllaV2NDbXJTZTlBQzNyOFNJcm81bGt6UXVCRTRkR3pFWHhzeHNCSDlNbXlT?=
 =?utf-8?B?dDRLakdENm9sdHpnWjhGS1p1NlY5ZVEzaVJGZFNBN1hhWkdyOHduNE82UVNI?=
 =?utf-8?B?NmtjTXdyczZYcWw0R1FHcjlEa1BES29qQWZFcGtEWWoyVXpKYUhrTmpRMEpG?=
 =?utf-8?B?MEt2azNUQS9vWVorU0pqckxYSUtCem9oSnlxc0xZVXZqalRQRGdxaXF6c0pR?=
 =?utf-8?B?Y3FZd1VDNlpWRGd5U05Pa0FXaTBDUm01WGIxRFZGUUpLUHNZcU5VVVh5RHdt?=
 =?utf-8?B?VEVCd2lqakt6dUg3SkIxWjNhZnVTbWhyWWVlenVhczltdURDS3YvY2hTdTNH?=
 =?utf-8?B?K3l5VjJycUZLVTQwTk9uNDZ1S2tReEZnODBzd3VvN1I5Njh5cDBvajllRXdI?=
 =?utf-8?B?ZEYxL09RMk1BK05OY1pDU25pazJFVmw2U1ptR2dxVXphb2laQ0xIRG9RSVZw?=
 =?utf-8?B?SXRuOW5TNWExYWxUOXRpL1lKZ2VsWVdJeFRxSWVRS2h4UkdVK2IrSkVQUnhS?=
 =?utf-8?B?OU8rVnNPRVduSUpKbGF3VDErdEJWOXg2cnM0aFNKbTlLUFY0WVkzU0dBNG0z?=
 =?utf-8?B?QkRGUDl1by9qSVRPR2NabXVZMVpaZlQ1cnpZL2E4U1NnSFNyY09JdjNCL3Rq?=
 =?utf-8?B?ek1zQWVYOFhHdHpqZGpla0xFUisxZVk3R3hDSVBzQVA1My96V0xpdlJQaTZz?=
 =?utf-8?B?c2kxb3BCemxBTk9RTEJnc3ZJTlowOERvc2FQeGk0YW5PUzFETGxHb3JEY01a?=
 =?utf-8?B?WXl3aXZVbXVPRU5lWGF4aFNQc0gzclpDRk94RzFmTDZxTjBSZGtkUVFZMjhV?=
 =?utf-8?Q?pDiphM61ezw0jab8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4524568C9B10BC47BC19F48967B2B964@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d6f09d-c1a9-40eb-98d3-08de62332791
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2026 08:14:57.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F4IGnNATZv+OZNJtyqs+ifjmYq939W0y63QqqQwHNUBmjwaw3YarmzlSiSGdHCD1GtH6sYLhmQ8aZ9hkd9JFdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7720
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTAyIGF0IDExOjQ1ICswOTAwLCBLZWl0YSBNb3Jpc2FraSB3cm90ZToN
Cj4gVGhlIHVmc19tdGtfY2xrX3NjYWxlIHRyYWNlIGV2ZW50IGN1cnJlbnRseSBzdG9yZXMgdGhl
IGFkZHJlc3Mgb2YgdGhlDQo+IG5hbWUgc3RyaW5nIGRpcmVjdGx5IHZpYSBfX2ZpZWxkKGNvbnN0
IGNoYXIgKiwgbmFtZSkuIFRoaXMgcG9pbnRlcg0KPiBtYXkNCj4gYmVjb21lIGludmFsaWQgYWZ0
ZXIgdGhlIG1vZHVsZSBpcyB1bmxvYWRlZCwgY2F1c2luZyBwYWdlIGZhdWx0cyB3aGVuDQo+IHRo
ZSB0cmFjZSBidWZmZXIgaXMgc3Vic2VxdWVudGx5IGFjY2Vzc2VkLg0KPiANCj4gVGhpcyBjYW4g
b2NjdXIgYmVjYXVzZSB0aGUgTWVkaWFUZWsgVUZTIGRyaXZlciBjYW4gYmUgY29uZmlndXJlZCBh
cyBhDQo+IGxvYWRhYmxlIG1vZHVsZSAodHJpc3RhdGUgaW4gS2NvbmZpZyksIG1lYW5pbmcgdGhl
IG5hbWUgc3RyaW5nIHBhc3NlZA0KPiB0byB0aGUgdHJhY2UgZXZlbnQgbWF5IHJlc2lkZSBpbiBt
b2R1bGUgbWVtb3J5IHRoYXQgYmVjb21lcyBpbnZhbGlkDQo+IGFmdGVyIG1vZHVsZSB1bmxvYWQu
DQo+IA0KPiBGaXggdGhpcyBieSB1c2luZyBfX3N0cmluZygpIGFuZCBfX2Fzc2lnbl9zdHIoKSB0
byBjb3B5IHRoZSBzdHJpbmcNCj4gY29udGVudHMgaW50byB0aGUgcmluZyBidWZmZXIgaW5zdGVh
ZCBvZiBzdG9yaW5nIHRoZSBwb2ludGVyLiBUaGlzDQo+IGVuc3VyZXMgdGhlIHRyYWNlIGRhdGEg
cmVtYWlucyB2YWxpZCByZWdhcmRsZXNzIG9mIG1vZHVsZSBzdGF0ZS4NCj4gDQo+IFRoaXMgY2hh
bmdlIGluY3JlYXNlcyB0aGUgbWVtb3J5IHVzYWdlIGZvciBlYWNoIGZ0cmFjZSBlbnRyeSBieSBh
IGZldw0KPiBieXRlcyAoY2xvY2sgbmFtZXMgYXJlIHR5cGljYWxseSA3LTE1IGNoYXJhY3RlcnMg
bGlrZSAidWZzX3NlbCIgb3INCj4gInVmc19zZWxfbWF4X3NyYyIpIGNvbXBhcmVkIHRvIHN0b3Jp
bmcgYW4gOC1ieXRlIHBvaW50ZXIuDQo+IA0KPiBOb3RlIHRoYXQgdGhpcyBjaGFuZ2UgZG9lcyBu
b3QgYWZmZWN0IGFueXRoaW5nIHVubGVzcyBhbGwgb2YgdGhlDQo+IGZvbGxvd2luZyBjb25kaXRp
b25zIGFyZSBtZXQ6DQo+IC0gQ09ORklHX1NDU0lfVUZTX01FRElBVEVLIGlzIGVuYWJsZWQNCj4g
LSBmdHJhY2UgdHJhY2luZyBpcyBlbmFibGVkDQo+IC0gVGhlIHVmc19tdGtfY2xrX3NjYWxlIGV2
ZW50IGlzIGVuYWJsZWQgaW4gZnRyYWNlDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLZWl0YSBNb3Jp
c2FraSA8a2VpdGEubW9yaXNha2lAdGllcjQuanA+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLXRyYWNlLmggfCA2ICsrKy0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWstdHJhY2UuaA0KPiBiL2RyaXZlcnMvdWZzL2hvc3QvdWZz
LW1lZGlhdGVrLXRyYWNlLmgNCj4gaW5kZXggYjVmMmVjMzE0Li4wZGY4YWM4NDMgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLXRyYWNlLmgNCj4gKysrIGIvZHJp
dmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWstdHJhY2UuaA0KPiBAQCAtMzMsMTkgKzMzLDE5IEBA
IFRSQUNFX0VWRU5UKHVmc19tdGtfY2xrX3NjYWxlLA0KPiDCoMKgwqDCoMKgwqDCoCBUUF9BUkdT
KG5hbWUsIHNjYWxlX3VwLCBjbGtfcmF0ZSksDQo+IA0KPiDCoMKgwqDCoMKgwqDCoCBUUF9TVFJV
Q1RfX2VudHJ5KA0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2ZpZWxkKGNvbnN0
IGNoYXIqLCBuYW1lKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX3N0cmluZyhu
YW1lLCBuYW1lKQ0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19maWVsZChib29s
LCBzY2FsZV91cCkNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fZmllbGQodW5z
aWduZWQgbG9uZywgY2xrX3JhdGUpDQo+IMKgwqDCoMKgwqDCoMKgICksDQo+IA0KPiDCoMKgwqDC
oMKgwqDCoCBUUF9mYXN0X2Fzc2lnbigNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
X19lbnRyeS0+bmFtZSA9IG5hbWU7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9f
YXNzaWduX3N0cihuYW1lKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fZW50
cnktPnNjYWxlX3VwID0gc2NhbGVfdXA7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBfX2VudHJ5LT5jbGtfcmF0ZSA9IGNsa19yYXRlOw0KPiDCoMKgwqDCoMKgwqDCoCApLA0KPiAN
Cj4gwqDCoMKgwqDCoMKgwqAgVFBfcHJpbnRrKCJ1ZnM6IGNsayAoJXMpIHNjYWxlZCAlcyBAICVs
dSIsDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2VudHJ5LT5uYW1lLA0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgX19nZXRfc3RyKG5hbWUpLA0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF9fZW50cnktPnNjYWxlX3VwID8gInVw
IiA6ICJkb3duIiwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2VudHJ5
LT5jbGtfcmF0ZSkNCj4gwqApOw0KPiANCg0KSGkgS2VpdGEgTW9yaXNha2ksDQoNClRoYW5rIHlv
dSBmb3IgZml4aW5nIHRoaXMgYnVnLg0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIu
d2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
