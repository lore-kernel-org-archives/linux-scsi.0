Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B04377EDA;
	Tue, 17 Mar 2026 13:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773753044; cv=fail; b=DTN1Adn5G1N0Cj22p397HoijiS11oSqnW4r4xjY8bDYikdYLq3603cn5RwLKBhgqlSg25gCjQVHlQpajGoLPxb3C+N6kFb6y8mBiCPuuPGRX4ev4iTzHz6J6B500IsSDX6AVRUTdZSJEqzImA2/N8ye2otQEC0RWTDhbnKtNxXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773753044; c=relaxed/simple;
	bh=4aOpRE4/+ZmFKe3M0vm2i5E8yVw0HDrL19otBKzj2UE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WDxDlRLJHnlUPCL1uDY/g77Zyqw+wrGN/tBslMeHkJkw8vDpOAcgYpwI6wpe+Hqy+MQlmNDipZBMkpIh6CgfZtOr056Hw1BejvA1DtCPZMng99zRlYJCNdYnDNeiaznGM6XLZuIXPIv4uv6LWhLvv+L8irOUamL51LFRrZahCWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=eMxkeH5Q; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZjMocQ74; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eMxkeH5Q";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZjMocQ74"
X-UUID: aed0fdd4220211f1a39cd589f645bc18-20260317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4aOpRE4/+ZmFKe3M0vm2i5E8yVw0HDrL19otBKzj2UE=;
	b=eMxkeH5QiYdTPQw2QGJIlZRvYegbXKGKOYEO2OFDS1MEnqJxyEUMLBGEaBBG6Qa0DMSbefcQ8iuCn6GFo7oIX0Y91UAMASZ+8g0DmWbhIYt0mYDOLVPqzZGSpdGUK29F7UDQCWohjDhlxVelUCHV0QYokJxPSYjbeUa/JmpZnHQ=;
X-CID-CACHE: Type:Local,Time:202603172109+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0bd244ec-9a9f-4d00-ae32-38a96af24f21,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:1b607a16-77dc-40b0-853c-db53c3132fbc,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aed0fdd4220211f1a39cd589f645bc18-20260317
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 46247851; Tue, 17 Mar 2026 21:10:34 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 17 Mar 2026 21:10:33 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 17 Mar 2026 21:10:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bda97Nctxj2wli+BxV3B6cg1IMbAogyarLs1E1tc0Gic2u6PadIirhkvUpARkccb8alBUHC9Gj0uZObrCDJWebmOySwE3rhydo+Ivg0+Zngr7UxfY5tdPj9CcJ7BTKE1WZMf4zPnXv/4amLGyVRjskPQfsNYPFfEaBFjLTXr8Mg3CiCZIXL97GsdxU2GFRZQ2q/gBbILOy9yWTMK4wVxAC2iSEsFq2jFlTI9Tfs9vw0zPgCBqTfvA4HqE89f7iO7/GvMszJiv9TFq75xRyfdtEDkar9YDjeiw4/VAEJmB2gegmfZ9oGeeYk4U1nguSm8toZDvJqybZl6mogZbQadtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4aOpRE4/+ZmFKe3M0vm2i5E8yVw0HDrL19otBKzj2UE=;
 b=aqYypm/JQzNJfaPjVIxdvMul4Ut229O2tm578DstNbtXj8kgM+abbOtkC7wB2pje1sPdQbUg+VieJZTEdBYrn0j26NbIBbX+F8lKJ42lSS9Uii4Gp6aF792BP8Ac164pFiQylp13K0FUC9oxaQAmTUSuVDyQXZYAL8rN+8R4ZtMJYImCXZCpok/JqlWlYXUvdALk1DCe74ZuYJuPTbtWwlT1jbtzOWCmc9Wgak+/2o3erCVUFLiNN7MyToZC5VIimY72I96hO5l86m6grEW7gFeyexaeOrO55cwnZD+QXcr9TcwPjAQD5qM6Do23s4i7+wfinu2f/Eb6TQaE7K97HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aOpRE4/+ZmFKe3M0vm2i5E8yVw0HDrL19otBKzj2UE=;
 b=ZjMocQ74EEhcOkbLjN3Ypdw1Uz8q1jMdCZorEekxfrIn+R0noaH0u+xEXy/byQQdyBpRA2jT8iT4PVmHk+q9i7h/nFGmcLNW/sMv/3CUURIMgL49M0PvkobhCQKA8V02W3SgZRq+KFQA9WYgDxueJ6J0SOYrdtrnP+AoHTRlDFA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8413.apcprd03.prod.outlook.com (2603:1096:820:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.25; Tue, 17 Mar
 2026 13:10:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9700.025; Tue, 17 Mar 2026
 13:10:29 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
Thread-Topic: [PATCH v3 04/12] scsi: ufs: core: Add support for TX
 Equalization
Thread-Index: AQHcrw5m3AJ+eCzqYEGMTPJE+YMrfLWyVjsAgAAJRgCAAAOuAIAAXY6A
Date: Tue, 17 Mar 2026 13:10:29 +0000
Message-ID: <ead714be9dbe88ac66b3ce586498f7ffd734e328.camel@mediatek.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
	 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
	 <42587e16218f1c51dbcbe6bb1639a843e10bcd80.camel@mediatek.com>
	 <fa2a97fd-e17d-4314-b5a7-011b6b16a622@oss.qualcomm.com>
	 <fb56d5f1-2b53-4627-ab7a-03db13cd76fd@oss.qualcomm.com>
In-Reply-To: <fb56d5f1-2b53-4627-ab7a-03db13cd76fd@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8413:EE_
x-ms-office365-filtering-correlation-id: 5231d83b-df0d-4ba4-5e38-08de84269064
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info: 17HGrijq0wB1kL/N+zK4lJ3QMBH7Zp+GtTolKwoHe0z7pd0xebj3AhlMQJ6Hwdde/L2w+akWf+2IpCEbzPyERYn36nS1VyFJnjiVIRxmChZi5Sa+W8kMwxmqwMibscUQAbf7yqq+Qc0Xy7ladfENMjkPSthTuPf5EI2brKFTH0Be8fsXPfuIfwHVr7zrxxmyCby99gLWvTge+e5fDp1Gdq2IPAeslmpzNYuLtU+Mq6QmhJE+otEbVx61ECu0sa4HSNyE4s++U36Bi68r3w2hENgiKlYWXTs1C843+N+P5UjY5nxWMwfk019veWmgZDtDOmZZbty2Dyxv1i9eUTxBkdTGboLNpccVeDHlCQVN0tx97HM+r+n5WnFxV3XWLAaN+2WDxVXHNqpzUDXeOQ2qhYUYVIHHd7vCgDE/ajTKfQAjgUF1iOUnsvfB4Qi1USDHjecpl5QoLNzwHbV4JwbC+LFLbmkO7/UvUAQajrsg3dQgVrFaXONDPvQ3yZ87227phtAt7LeoEOoDRI3pwXUJMbyfSIUNzUnEQb+VK8/6EoAtIz3VYItD3RO5CxpFUJdtYSgA9RPysJ3uG9ywjksg2rfUxzbLMI9RvTXpW39vaijPVsYa8pN5iFWLJMfHfewGA6ojuJ64adWyNBrQY53JjwNScIjxlWTbM1i08/xOR7ypdshbqab/49l2jo88x9x6cCZGPhNjgsq8/k6+Cmh2giIs3mfjx438tf7IUIF/yDzSRN9ofRggFGx5zirNFJIS7Nzvos3/r0JUrKIpEMpQODHkW2SHj1fJskBuxANyu8A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUR4d0tidlROTUpGbU5NTkFVVEFweTFkMTRMUzVjaHZPTGFOdGVkVitLVlB1?=
 =?utf-8?B?UG9wSTN5SGRTVVdQL2pGOWRPV1NRbTBzdkRYU21OZVoxYko4ZkhHTlFtTFdR?=
 =?utf-8?B?WlBiZlpIRUxXdkJsZG4rMlV3cVpSODcraDZBelR1WE9VQ092eGNCaEhreHl6?=
 =?utf-8?B?eWcySUk2M1gzUVZPMmxSWEVjaCtGVVZoTkJJOTZTdHFRWXRZUy83UVZkTDBI?=
 =?utf-8?B?ejByZk1POE5TKzRRNlBOZ0hNWWtzdklvVWRNOElxZFc0K2RTMHM1WHo3eWYr?=
 =?utf-8?B?VWY2OHVFV0F2WDRVMDYrZnQvSitTN0dreUQ4VVVXSFBCZ3NiQ1dPTkhTOU9C?=
 =?utf-8?B?MUgvdC9TRnBoVDVQTXdFQTdRQ2RnS3ZIS3haVmRJZVZVVzNQbTRJY21ybml5?=
 =?utf-8?B?NVRnRHlldzRQdTVEYmxtRGduc2JXUGRLOXhocE9vZXRZVTFWSTg4WXFrREx0?=
 =?utf-8?B?c0dnNTdBS3ZTKzBNU3VvbXVBWUY3VjZRNWxmRDEzSXN6L0Q1SS9ET01qOE1t?=
 =?utf-8?B?SHRiRDB3amM5Rm0zWnMwbitxS2hCREJ5VjJURk5RL1Z6NGlsaldCRVMvSmQy?=
 =?utf-8?B?WGtYYTRpQ2pPMFJyYjZKUDVadThMMVE1UmZWYS81bWRQcVJKUTN0eERzd3ZK?=
 =?utf-8?B?d2tuRFRiMUZGdWlYSlpUUjJHOVY4MDFoUThsVkFtK1V1NXk2aXRwekpvWlpr?=
 =?utf-8?B?K2dhRmNoOWNqVjc0RkpTWEMxOXh1bjlScXJJRXV4eUlwcVBnb0xEUmR5ZXRG?=
 =?utf-8?B?c3lMNUtDS1MzaVdZbHlOdGhJSDJta25YN2ZtcEw1NEdOVjhnOFlLMElrMnJD?=
 =?utf-8?B?M1AwZkJBR2NpQUlnaHdySTF4M1liS0pKTzlzOVlYWUxOZkRBVVQweUxUaEpJ?=
 =?utf-8?B?bldkQmpydnFsUno2WjZOc0VyTm5mVnAwZ3Q4UWJqTnRXeWFCaTJTWlFMRUps?=
 =?utf-8?B?M0cydnhGQmoxYXlvYUY3MkRpcmhHdm5pdFhST0Q3dk12OWpVdzg3OVZ3ck96?=
 =?utf-8?B?STQ5L0hEOG9odzJHVHo1bTQ4NGRVaDhvVFVoS0NTaVFqVmdJOVMveFhiL3Ew?=
 =?utf-8?B?WjQ5Q203RzRGM3Y5aXdjSjFaSkprTEFRdGxzOEhsUE84Q2pmTjJvbGFKVnFO?=
 =?utf-8?B?UmZad0pvNlFneFVIdGZQNE5QN0ZraVAxSG9pUno0aERUOXZZR0hBY3Y2c0My?=
 =?utf-8?B?OWVZd1VRYmJTbStTUUFWT2h1eTl5S3NtdnZFR1dNbjN5WDdrSzBKVnhCUjVi?=
 =?utf-8?B?anZuak1Xc1dLWDlzYW1WZTZiVE04OUFRN0ZFS3ZiNExwL0NobDdHcnhEaFhL?=
 =?utf-8?B?amRsZmxKTlhYaFgwTEowTlhQM2pBZWdiRXVCVkJnOXB4NEl1L1piU09IK1hm?=
 =?utf-8?B?WFQzUVhrek8yenpDU2Zxc2d3dmZiZWpackVsY1Q3blFUcVdNVmY5eUNtQ3Vw?=
 =?utf-8?B?eFVoSm5jVVZnTUdBWjlSaTU2bUR3bWt4NVpyNXNWWmxOMGMvVUdBTFFHZkY4?=
 =?utf-8?B?SHJ6ZjdxdGhhaUVpaGgrN1EyYXlaclF3amZZRkRDTy9RY01DcmsvdmNSa01l?=
 =?utf-8?B?MUI4Nm9aQUxWZmNOL0lsRFJoaHBrbVRISit3alFjZ0tLb1VVMmVQcGwvVFFk?=
 =?utf-8?B?VDV5VXVXWTlDd1ZhRHFYNjZDZGxHdmg0NmUzazhVaG5xZUdmWGUrYnliUVFC?=
 =?utf-8?B?L3BKKzhhdnVmM2trOHA1NkM4TmdpYWxYRTlLcXJnblh0ZE9xUk5FRGJLTGFZ?=
 =?utf-8?B?ZHBxV2V6enFoalMwR1VjUElQNXJ3TUNoWjU2amNLUktqRnJkVjNodzMzazcv?=
 =?utf-8?B?SGN6NVlOTHllRXBMRzV4VG9TTGpCL2JKUTd2TngrZXVCMDJxYzY1SHdGVjIy?=
 =?utf-8?B?cmtVQURPdExXbUJTSFNPTll6dlRGQ05SSFpJdHRtazRjWm1IYXhVNlh3bVpL?=
 =?utf-8?B?bS8zVU9sZ0o4NURReDhzdGtqT3hDWmU1blF5OUNoL3NtZGF4cHliNHA1TXQx?=
 =?utf-8?B?M1hQUHdVUkhUbU9WQ1NNaW1abURZVmNLZ1JzbENXTERCMUlOOWZma0FlaHly?=
 =?utf-8?B?SWxDbDdhVzFwdkM4c1NvMEpJN011Nm9reU9VaUs2cXZhUmt6MGhyVDc5aW15?=
 =?utf-8?B?bVIwZTZ0dzRNSE5tRlhFdHd0SnZwUFFUNktrZVd4N0xQZkhFKzdPQ1htRkkv?=
 =?utf-8?B?UFB3VWlINEQyVTE2THduaXR6QW51M2ZrOERQNC9zRHhoYnpVSERwUFlpMWU5?=
 =?utf-8?B?ZExRUEhpQTBabWp5Mzg1YlkrWUI0RzY1ekNvS2ZDbzZXdnRqTFNNR29KRmdr?=
 =?utf-8?B?bnNOckVicEw3djEwajVpUWxpaDdGZFp4U290QW5rQ0IxRXYvVFVoR0JoY25Q?=
 =?utf-8?Q?rgFRmR92qOAPyoWk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <792AEEA6112DED4EBC87458AE9D139E0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QvDXREeWKzPRfOsxT9yAnUHLQ0BXoOTEg5omK7hRzbvCAHDEFRZvT8xkspQPAJuZ+DhD8iLDa7l+4dkoHwF8rVNuPgzr2SJkqUb3vzkLAnRJ8tqNbSJohrgEntBrhnrhwYwpYOhPGwkex9crBAT12MIRAG6kdrSjw2JLbGRKvd8ilL2U6T3TEtgmrCDL3oTU/7AreOsy8hgfyqPX8w4/C5fIOmiP2jSlXXWrNcb3NccQ53aSClssjF8GO2e7lWeGLMXz+kR5aBvCENweQtnVTh5Xz87UGRoPjarrpTJ2sro4KKMYgHt2fR6xjEWL+5O3gL3wUIvrjO9aHdWeDeZh7g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5231d83b-df0d-4ba4-5e38-08de84269064
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 13:10:29.9272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7vf6xb2bzlqpN8ZohXB+i8cOkxvY+WYzr3Kh6E6d2TFH8ZR5pZpkdC4Ys/TThb2D0ppghqP9Gnj5OROnD4UZ8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8413
X-MTK: N

T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE1OjM1ICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBUaGUg
bWFpbiBkYXRhIHN0cnVjdCB3aGljaCBpcyBjb3N0aW5nIG1lbW9yeSBpcyB0aGUgVFggRVFUUiBy
ZWNvcmQNCj4gYXJyYXlzLCBJIGNhbiBvcHRpbWl6ZQ0KPiBpbiBuZXh0IHZlcnkgYnkgZHluYW1p
Y2FsbHkgYWxsb2NhdGluZyBtZW1vcnkgT05MWSBmb3IgdGhlIEdlYXJzDQo+IHdoaWNoDQo+IGFj
dHVhbGx5DQo+IG5lZWQgVFggRVFUUi4NCj4gDQo+IFRoYW5rcywNCj4gQ2FuIEd1by4NCj4gPiAN
Cg0KSGkgQ2FuLA0KDQpJdCdzIG5vdCBqdXN0IEdlYXIgdGhhdCBuZWVkcyB0byBiZSBjb25zaWRl
cmVkLCBsYW5lIGNvdW50IGRvZXMNCmFzIHdlbGwuIE9ubHkgYWxsb2NhdGUgdGhlIEdlYXIgYW5k
IGxhbmUgbnVtYmVycyB0aGF0IGFjdHVhbGx5DQpyZXF1aXJlIEVRVFIuIEFsc28sIHBsZWFzZSBv
cHRpbWl6ZSB0aGUgc3RydWN0dXJlLCBmb3IgdmFyaWFibGVzDQp0aGF0IG9ubHkgbmVlZCBVSU5U
OCwgZG9uJ3QgdXNlIFVJTlQzMiwgc2luY2UgbWVtb3J5IHVzYWdlIGlzIGZvdXINCnRpbWVzIGdy
ZWF0ZXIuDQoNClRoYW5rcw0KUGV0ZXINCg==
