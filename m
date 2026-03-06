Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD4428FFE7;
	Fri,  6 Mar 2026 07:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772781089; cv=fail; b=l/xNeiRDuX+Xha5KNoP3ytfP27qs2CG1Sh2QnkEH79IZ/Gt/RnxtlMBVWkpWTbkWaPn/pkEYt+Flc901SK0BapS1uz6QCGIw2H7J2DeDh1wU8y8CDlqygB0onYq3LGrXbfFInis5XtK1UzP6D6ff0wQJgj2kyy9IYi/d66kO8R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772781089; c=relaxed/simple;
	bh=fwsZ3dl0Ni/OCIyAIjtA0N9fK5ofZ2/Sy2Txu363QCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uY5/cO+qktQ9sodEdBPhra22Hfc1Hd40kVb5yNjTNmstXTA/5vMPAKO/ukNEMi4XfztcZgAvGUuyx6N7ng/c4azOU+7/NnMARdDiiaXa6bSSaEKghZxHmfIcLOGhey2APe3Iui4Lv9JeDKiQ25J6xpjsLdc2EGu/DAm3GLyi7/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=D3dKOgdD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=cQExZBUg; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="D3dKOgdD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="cQExZBUg"
X-UUID: ad307782192b11f1a02d4725871ece0b-20260306
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fwsZ3dl0Ni/OCIyAIjtA0N9fK5ofZ2/Sy2Txu363QCM=;
	b=D3dKOgdDa4AtjDdCA6DbMVWTf6aXn9Xig9njXXD8oODrKvAbh2E3Gdvc+tCaYL7cUcO1zhSVLI3pi/5k8Q/+z5iaFtsKVMY9IrTwWbxWRERt7LQfI/XQV9DIEn4wcGtXsNqmaTok9wsZgZ6CY4a5/lBMGksLTxXeCuouLaQ9ZdU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:3c3807d6-c7fa-4b3e-89cd-267c88a4d96b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:0a54ee5b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ad307782192b11f1a02d4725871ece0b-20260306
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1094545164; Fri, 06 Mar 2026 15:11:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Mar 2026 15:11:19 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Mar 2026 15:11:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYcIlrOMyhe+a/DfZtKBvMl8nev8JM1HdZxvlNwyg6ulCPYELYg2KRo326BoT4i4RiIan9dDIw33xGlNUh8d8pnC4f3VA6qqPW+rC7wXD/tfyufpnU1QoGMmI53w/dDj7d6V7UGGxXgok95F1iUsitiVxq//A87gEgdECq4qjAuzY6aBrtiocH2hA+LJz0Llat9sTvtCILZ2oPwmxrpjUNbTrPgPw0ewtElBJSpr5v/0JBRxMnRRtLH3y/NFHwGHc37ala4+voRunuDgCWZfvj8j8Xj9Y0VWbDhbCjBcTdMxUjDfH6OMeMbdzLu5nFf1UFb9ME4M8R9RyzJRNhj6pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwsZ3dl0Ni/OCIyAIjtA0N9fK5ofZ2/Sy2Txu363QCM=;
 b=ne8WD/ilASYQA/BsT6wSQ6YpNAIss0Tpa1tlr8RKa9roGt0qTJBE2Gb18J+fJPmBY+wUT7IDRjlcF6PbQ9nWhzgCmxNjoyiHVnByIOk7pfrkajrf69X1xSWToKh9GsUwllsGVqhJvHNOK7ypdGA6IIPt29MtDliivE3YFbDXwao/ilHLjt7LEbY/7Xg50anRTgwsiiOwgu/Ikwfihv+Dtkqznf4uX4JlhPDrmw88vsOH7UlW4fmMdFKbGIuqPs0LbcbMr8Kwy1oK/N35e9LOqv4BIqtmG17KCqLQzZ/mRkg3x7r5fPmMycRMhS+RreJzEX9/mK4alOxJMZDS5lfe7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwsZ3dl0Ni/OCIyAIjtA0N9fK5ofZ2/Sy2Txu363QCM=;
 b=cQExZBUgtG7NrUvy1zRTVk6Uw3zGv0g+V2QWv5rjFYIw5gWFfA4EQcSohqNCXdlrB1Z86OchZWF+HrwmK/lAL2dIJH7VGzEGovIdgMhlae6drb+3RySwY0lZyPfukQqj2ERYc+fYB+JEH/vGua56Sb6Um37uGosB4zQTPv/42Uw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8797.apcprd03.prod.outlook.com (2603:1096:820:145::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 07:11:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9678.017; Fri, 6 Mar 2026
 07:11:14 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>, "huobean@gmail.com"
	<huobean@gmail.com>, "frank.li@vivo.com" <frank.li@vivo.com>,
	"luhongfei@vivo.com" <luhongfei@vivo.com>, "tanghuan@vivo.com"
	<tanghuan@vivo.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "zhongqiu.han@oss.qualcomm.com"
	<zhongqiu.han@oss.qualcomm.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "keosung.park@samsung.com"
	<keosung.park@samsung.com>, "chullee@google.com" <chullee@google.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "ram.dwivedi@oss.qualcomm.com"
	<ram.dwivedi@oss.qualcomm.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
Thread-Topic: [PATCH v4 1/1] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
Thread-Index: AQHcrJCWna4Oci0omUGUV6Ndi+6tqbWhF7OA
Date: Fri, 6 Mar 2026 07:11:14 +0000
Message-ID: <b0a7b6ecc14981295390b57e5ef18eaa5b07dbc2.camel@mediatek.com>
References: <20260305110856.959211-1-can.guo@oss.qualcomm.com>
	 <20260305110856.959211-2-can.guo@oss.qualcomm.com>
In-Reply-To: <20260305110856.959211-2-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8797:EE_
x-ms-office365-filtering-correlation-id: ba43b765-af0d-482c-2d69-08de7b4f8da1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: pwtkqD6NvtiUQu41kC5FhfvV76lw61UO8SxmUjH0g2OALOEsjfdEcKACLSHzRq33H1apHGDwk5r+x926b8rrNvypDRHawB52ccurIbeqiICt9LBJz/qj4morkmOcEDcBtMhdzPcJdS1uttu9sX6jB0nXt1NDB0L/pLfxoDcWO5h+UAx9VIPNbmoFvcGLCIauKj6qKZDUOt086+yXZ+r0fqkmCSd2RlJbsrfuznj7nYdLYUj+Iea5PY8fBl2zSYuSFOX3eK/X6PmRgu4O0c+eH+oCuIgUgRf6BEg4Ocy0X22I/RM5HFnkszwesBOgPERgNEAX15pJneSBcGhLAtcDeeCfpBXTvXQ4Jwv6HTw8/GLyhlV+HK9a9l+vVbYWslUFaB05DFyC5okZEkFNiKJAbLowWyloKcpKe+cQfrXaUhI5yJTaPSKuI6+ff3E1f6SqKp/0+M+HCqngfHshRecmybEYH5TWjuKX1NHF+IAj0eRxuoQJ/e3tNCx47g9Q4uPFHNOI314KU39NORCHImrZemvr8ePu1tGmhT4ZkIj9Fpvio9lgoc2h9VqEqIM9eJN0szBZ2WHMxXUarUh99zqVTDZvX/TEkrJQT+qrTkOjQ84eh2VZ/4uwB7vB3jLfjacRF6kMoBHrcDelO1fYpPj/PpJeX81zkdx7OPv4Z5K2X35lbL8f3FLkpAJnHl6Jw3EQkYv8xlFuuFAik42ukcLj/u7+2MMeOraKezTStUNPzuQyTo/VDPP7jD1G5Fdwh56aPUu40MDDAOVh6YxAEruOad71GKLGxF0EtpLgVp3VQ6E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K09CODlqZzgzbXNHTVRKUzE0Qk91QkNXS0RIUmJBNXppekVPQ0ZkSVZmQjdU?=
 =?utf-8?B?Q0lDTEZFZlVwaFlvMEJjcHZsSUVoT0c1amZMdHNUQlpzRktMcForeFRoMDF5?=
 =?utf-8?B?dFg1K1NKczFGRC95WjlVN0RQeUFpZHgzcGhWQm1XY0ZSZkdWZGg3TnhxUU5Z?=
 =?utf-8?B?NEhkR0J0TCtVVDFsQUVXSnkxY05sSER1MGppd1Y1N2pHQmNJbHZENXUrN3py?=
 =?utf-8?B?RXUvSjZjeEd1WmxCbCt2ZW9pVldGYXNOUjdrVEMzMEN0cmc5bTU5MFUrbTc4?=
 =?utf-8?B?NkQyaU5PYlBaT2JVU0RndExKb29USjJ0YUduUkQ5ck5FM2hGU1ZpQlRKaEJH?=
 =?utf-8?B?YXFGeU9HdjFVdFpteGdkTU5EYnVuZHUrVDA2amt2Q2JxOCtwZDJRdjYrSDU5?=
 =?utf-8?B?K1ArLzVqbVZJSEdqcnlRYWdSaW5FajVrSWxoKysrMEtJMytLY2pxSDcrL0FX?=
 =?utf-8?B?SVN1ay9acjk5SXByQzRyRitnM05Gc214Y21QejdKcEZPQS9QSitqWkQ0QTli?=
 =?utf-8?B?ZFk1dmVzbDVhMmFleVRuZWNhcnkvSGpobUdwQXFyUWQ3RkdXcmF2ZE9hUmZU?=
 =?utf-8?B?K2tudFM5emNqVm5QRWNDTHNjYmFTRFYxSERLTHNzSENIREM3NzZmT05kczJI?=
 =?utf-8?B?TnhSWnFGUXBaYUFVeWRIUm9VME9uSTlNcWpVbmZoV3VveXBPemlZaVUzSFBJ?=
 =?utf-8?B?dkhpTVVkYXZIbjNUa0I4eEpObEdldllIb09wb2x4UTBWRHhsQU1xWVBUUml1?=
 =?utf-8?B?QURKSERXQWx5ajM5T0J3dmdzZWtQaXBKZkdTWHovWUtmMXdrLzcwQmUvc29p?=
 =?utf-8?B?ZllLUnFqcmF5UzJWK3hlWlA5WHVjaGtmN3J4clVhMXRhd2llMHpiT2IrS2ZE?=
 =?utf-8?B?YVhUUHNOakVkZnpuM2crNGVpelhwWmlacXB1M2tWNnRnaHNlRXJCMGVCeVBO?=
 =?utf-8?B?NEQzcFpNUDVDOFkwWTNadlVGZjZlWVppQXFOSHNoN256bDJ0TnMveEtlNExn?=
 =?utf-8?B?WDI5c1RacTQrdjJzYmo4eGZKVkJ5S1pBUTN6RVUvQmU5ZXk5L1J4Nzg0RXhC?=
 =?utf-8?B?SXhOa01kcUlBN0FKWlZYc0NpUlpuUjF4THVFNmsvckhXdnpkTFlXMTFPRmRC?=
 =?utf-8?B?cTkyc0NQREg1QnllN3lVY0svYklVNTh2Wk9ZWmR6SU5USk03RlR4aGpxZ200?=
 =?utf-8?B?eUV1eTc5M29BdVBPclRjUGM1bGJsRHhUUjZ2SVpEbVZpMzhMWE1RUVo4TjVq?=
 =?utf-8?B?WVBkbUJxTnUrekExRktCbFVQRFZlSTFwMDZGNWZ0SzJnVk9zbjg3NW9yY29h?=
 =?utf-8?B?bmRjQVQwdnpTdkFxU210bmxnRGx0a1VINWlhZDl3blNKWEZrdjc1VWtYL3px?=
 =?utf-8?B?Y3BGSFNKWG4xSHpvSllBV2xxN2dSOUlscmQ4cEYveEVkdjZTdG5VSUpydHBl?=
 =?utf-8?B?clRDSCtKOGtqcUZDU2NlMTdHZWllMlB3WXBnK0hMRmJSL3A3ZURxbU1Ua1VW?=
 =?utf-8?B?VkdvYlRBV2lrMG5ybTZzUisxcURleWxaZGUwV0g4RG9EamdWNnNFWFZwTDE1?=
 =?utf-8?B?VHhsZEkvcDVZUEdVRmNoVnZkVGFqYVlhMEZRQkszWFZaWXpIK3ZHSEZMamw5?=
 =?utf-8?B?UEVFYkZvVWNGZHBIQVczNmwzSlcvNitrN1BJaUVvMkM2TVo1YnVPbDBtQ2Jj?=
 =?utf-8?B?THo2dWplWng5MnVIWEhOOHZYdGV3bEZKUUF5RlJCa3dyVjV4MnZtQ1M0L2FT?=
 =?utf-8?B?bi84aWZhN21JMFZNSTNoZHE2MkhHS2ttU3VNaWpzc21uQ2dFemJrS0V0cVFN?=
 =?utf-8?B?c1RUdXhUaU9yM3Y2dTlONHU2T3Fta2tId3ltZ25RaEl6UWN1OW12TDhCTDNp?=
 =?utf-8?B?TW84b3psMytOaCtxa0licWQzejVZZFBnWENnUDhQcUhHWklPaDFDbldnZHp3?=
 =?utf-8?B?NTR3dTFOOFB3REFaMzk4cXlERlRNeWVQVjlFWjhlTEVKenFSM1NGdkh3dVJ5?=
 =?utf-8?B?YWpiZGkvUVR3SzBQeXB6cmpwU3RNSGZRdUd0aVB2OWhtbllrMXc4WHVzMUwy?=
 =?utf-8?B?VUxhMlZ5M2dsYjU2WlUyamlVY1l5K2hTRUlURXkxcGp6cVIzY3owZHF1OXlB?=
 =?utf-8?B?M0hKRW14UGN1R2lrQUYwVGdFZkFCcTlmYzhLRjF1VDN4YkpSZmlVZzYzS1ZZ?=
 =?utf-8?B?RFRFUHZLWWN6WHd0NlBHb2xpVTkwZE5lR2U2dnNtWHZ2QVkwTlJNNFAyL3Y1?=
 =?utf-8?B?K1gxS2Vadm0wZVpIWnhGZ3duTEpESVVHUUxuSlJEQjVjODc1SktpZmVRWFIw?=
 =?utf-8?B?Z3JqTmtQaXZWNlZaTkRmQkFRaHNHNDlWQW1pWjlZYVBFbkMzQy9rbU9MZTNH?=
 =?utf-8?Q?EVk0WnW7XVa2R1CY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <431C572E060C1E4C99A2D5B639D7F414@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: NzjiBs7ipd5A6jfDnyP2IdC3EgCKc3TtG4rCG6Fi5gqRyMISK2TIMuchMZt8vs2Xaotx/VulcsTWpbMciAnSwGiOINs10R7B0QJF8ixfUWKGkhtzRpLrS14kD221U5K1P2Zvx+bPIBkodirRJG7oD9AvrLS0sfq4QlM9VAFFywVqgEC0zvOaoZKutjszaolbY/a/NuuFwlGa4eaGkzuUUwv0tUisQkbGCaBi/WgpZi5RxGgDJ0YcYAlHXFtbwa19S6/dM01L5711JW5VxrhNIpz+HJgT5dsYaND5roBLFMNnO0uMjENDNhxYs7QSfhhnkZhdkFdFM/zbRgl6UKrq+Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba43b765-af0d-482c-2d69-08de7b4f8da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 07:11:14.1811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aoJUnEjcfQv0M06KxRMMwVCFSpLh9InuLjyEvxXLJaxgWRRPB4TnToTT44qOWa1xjsAeJzMCcWPSYzi1m5XqzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8797
X-MTK: N

T24gVGh1LCAyMDI2LTAzLTA1IGF0IDAzOjA4IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBUaGUg
VW5pUHJvIHN0YWNrIG1hbmFnZXMgdG8gcmVwYWlyIG1hbnkgcG90ZW50aWFsIExpbmsgcHJvYmxl
bXMNCj4gd2l0aG91dCB0aGUNCj4gbmVlZCB0byBub3RpZnkgdGhlIEFwcGxpY2F0aW9uIExheWVy
LiBSZXBhaXIgbWVjaGFuaXNtcyBvZiB0aGUgc3RhY2sNCj4gaW5jbHVkZSBMMiByZS10cmFuc21p
c3Npb24gYW5kIHN1Y2Nlc3NmdWwgaGFuZGxpbmcgb2YgUEFfSU5JVC5yZXEuDQo+IE5ldmVydGhl
bGVzcywgYW55IHN1Y2Nlc3NmdWwgcmVwYWlyIHNlcXVlbmNlIHJlcXVpcmVzIExpbmsgYmFuZHdp
ZHRoDQo+IHRoYXQNCj4gaXMgbm8gbG9uZ2VyIHZhaWxhYmxlIGZvciB0aGUgQXBwbGljYXRpb24u
IFRoZXJlZm9yZSwgaXQgbWF5IGJlDQo+IHVzZWZ1bCBmb3INCj4gYW4gQXBwbGljYXRpb24gdG8g
dW5kZXJzdGFuZCBob3cgb2Z0ZW4gc3VjaCByZXBhaXIgYXR0ZW1wdHMgYXJlIG1hZGUuDQo+IA0K
PiBUaGUgRE1FIGltcGxlbWVudHMgUXVhbGl0eSBvZiBTZXJ2aWNlIG1vbml0b3JpbmcgdXNpbmcg
YSBzaW1wbGUNCj4gY291bnRpbmcNCj4gc2NoZW1lLCBjb3VudGluZyBlcnJvciBldmVudHMgYW5k
IGNvbXBhcmluZyB0aGVtIGFnYWluc3QgdGhlIG51bWJlcg0KPiBvZg0KPiBjb3JyZWN0bHkgcmVj
ZWl2ZWQgb3IgdHJhbnNtaXR0ZWQgYnl0ZXMuIFdoZW4gdGhlIGVycm9yIGNvdW50ZXINCj4gZXhj
ZWVkcyBhDQo+IHByb2dyYW1tZWQgdGhyZXNob2xkIGJlZm9yZSB0aGUgYnl0ZSBjb3VudGVyIG92
ZXJmbG93cywgYSBETUVfUW9TLmluZA0KPiBpcw0KPiBpc3N1ZWQgdG8gdGhlIEFwcGxpY2F0aW9u
IGFuZCBib3RoIGNvdW50ZXJzIGFyZSByZXNldC4gV2hlbiB0aGUgYnl0ZQ0KPiBjb3VudGVyIG92
ZXJmbG93cyBiZWZvcmUgdGhlIGVycm9yIGNvdW50ZXIgaGFzIHJlYWNoZWQgdGhlIHByb2dyYW1t
ZWQNCj4gdGhyZXNob2xkLCBib3RoIGNvdW50ZXJzIGFyZSByZXNldCB3aXRob3V0IHRyaWdnZXJp
bmcgYSBETUVfUW9TLmluZC4NCj4gDQo+IFRoZSBETUUgcHJvdmlkZXMgTGluayBxdWFsaXR5IG1v
bml0b3JpbmcgZm9yIHRoZSBmb2xsb3dpbmcgcHVycG9zZXM6DQo+IDEuIERldGVjdGlvbiBvZiBy
ZS1vY2N1cnJpbmcgcmVwYWlyZWQgZmF0YWwgZXJyb3IgY29uZGl0aW9ucyBvbiB0aGUNCj4gTGlu
aw0KPiDCoMKgIChQQV9JTklUIGxvb3ApLiBUaGlzIGtpbmQgb2YgZGV0ZWN0aW9uIGlzIHVzZWZ1
bCBpZiBjYXBhYmlsaXRpZXMNCj4gwqDCoCBleGNoYW5nZWQgYmV0d2VlbiBsb2NhbCBhbmQgcGVl
ciBwZXJtaXQgYSBwb3RlbnRpYWwgb3BlcmF0aW9uIGF0IGENCj4gwqDCoCBoaWdoZXIgTS1QSFkg
R2VhciwgYnV0IHRoZSBwaHlzaWNhbCBpbnRlcmNvbm5lY3QgYmV0d2VlbiBsb2NhbCBhbmQNCj4g
cGVlcg0KPiDCoMKgIERldmljZSBkb2VzIG5vdCwgb3IsIGFmdGVyIExpbmUgcXVhbGl0eSBkZWdy
YWRhdGlvbiwgbm8gbG9uZ2VyDQo+IHNhdGlzZmllcw0KPiDCoMKgIGNoYW5uZWwgY2hhcmFjdGVy
aXN0aWNzLg0KPiAyLiBEZXRlY3Rpb24gb2YgZGVncmFkZWQgaW5ib3VuZCBvciBvdXRib3VuZCBM
aW5rIHF1YWxpdHksIHRvIGFsbG93DQo+IGFuDQo+IMKgwqAgQXBwbGljYXRpb24gdG8gaXNzdWUg
YW4gQURBUFQgc2VxdWVuY2UgZm9yIGEgTGluayBydW5uaW5nIGluIEhTLUc0DQo+IG9yDQo+IMKg
wqAgaGlnaGVyIEhTIEdlYXJzLiBUaGlzIGtpbmQgb2YgZGV0ZWN0aW9uIGlzIHVzZWQgdG8gbW9u
aXRvciBhDQo+IHNsb3dseQ0KPiDCoMKgIGRlZ3JhZGluZyBMaW5rIHF1YWxpdHksIGUuZy4sIG9u
ZSBiZWluZyBhZmZlY3RlZCBieSB0ZW1wZXJhdHVyZQ0KPiBhbmQNCj4gwqDCoCB2b2x0YWdlIHZh
cmlhdGlvbnMsIGFnYWluc3QgdGhlIGV4cGVjdGVkIE0tUEhZIGJpdCBlcnJvciByYXRlLg0KPiAN
Cj4gVXNlcnNwYWNlIGNhbiBjb25maWd1cmUgYW5kIGVuYWJsZSBVbmlQcm8gUW9TIHZpYSBVbmlQ
cm8gUW9TDQo+IEF0dHJpYnV0ZXMNCj4gKHZpYSBVRlMgQlNHKSBhbmQgZ2V0IG5vdGlmaWVkIGJ5
IGRtZV9xb3Nfbm90aWZpY2F0aW9uIHdpdGhvdXQNCj4gcG9sbGluZw0KPiBVbmlQcm8gUW9TIFN0
YXR1cyBhdHRyaWJ1dGUuIFRoZSBkbWVfcW9zX25vdGlmaWNhdGlvbiBhdHRyaWJ1dGUgaXMgYQ0K
PiBiaXRmaWVsZCB3aXRoIHRoZSBmb2xsb3dpbmcgYml0IGFzc2lnbm1lbnRzOg0KPiANCj4gQml0
wqDCoMKgwqAgRGVzY3JpcHRpb24NCj4gPT09wqDCoMKgwqAgPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0NCj4gMMKgwqDCoMKgwqDCoCBETUUgUW9TIE1vbml0b3IgaGFzIGJl
ZW4gcmVzZXQgYnkgaG9zdA0KPiAxwqDCoMKgwqDCoMKgIFFvUyBmcm9tIFRYIGlzIGRldGVjdGVk
DQo+IDLCoMKgwqDCoMKgwqAgUW9TIGZyb20gUlggaXMgZGV0ZWN0ZWQNCj4gM8KgwqDCoMKgwqDC
oCBRb1MgZnJvbSBQQV9JTklUIGlzIGRldGVjdGVkDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4g
R3VvIDxjYW4uZ3VvQG9zcy5xdWFsY29tbS5jb20+DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5n
IDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg0KDQo=
