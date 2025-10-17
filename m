Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D6C340D94;
	Fri, 17 Oct 2025 09:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692358; cv=fail; b=O98VXC0KSX6Budns3wfDdBvTNS67uCjQmzs3acDXLsmvSAkLUsvqJLQKbTJhhmBjDZktgJozV/U7EBCki/5TAX/bP7VONQk5XBuK6MSu+F5ieZM/R5T14B0Xz1gRiDsKb2lJxO78zk04rNGYdI/2ycB+Tkwq3xsAnkwsI4uUFrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692358; c=relaxed/simple;
	bh=leA+84L81ecEY6u1l+0lsBrQI30mLLLA7At3MTYzFRA=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qOzt1kVINiiK2q90ErNcPFE2eKpKxuHpFS6uw5NctClT7K1L5E7x/OtcF1PYh8K0IQT7FXu+YT3pXHXoQHQvc2y9T0TQr3kap58Osa1aqnGfYmnB1bSYPGCk97S48zX3SeWrkzS3/2JvrR5/XiXqXsmFZhVdgl5/7uERRElLDlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Q5sqojef; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=QQRnK8te; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Q5sqojef";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="QQRnK8te"
X-UUID: 68b858d2ab3911f0ae1e63ff8927bad3-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=leA+84L81ecEY6u1l+0lsBrQI30mLLLA7At3MTYzFRA=;
	b=Q5sqojefDm+fAw3R6PNvfkNwJgHh2kK1hVZFMZHDgMr7c5J/jgVr8dF8wNv7Zrgu6Xkys4nHmq5L2K+OKdBjEo4hwHwGu9QpYw/p7dymZOLBIQCQutHXTRWCX7zHbaVTl89Lj/rtVROx7fyy1fk7zFV44veE+VUsZGcLLZigyrM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:526616ef-6f6c-4d51-92ce-e27118ae35e0,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:631b47b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 68b858d2ab3911f0ae1e63ff8927bad3-20251017
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 556773488; Fri, 17 Oct 2025 17:12:30 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 17:12:28 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 17:12:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSzO4vXj/kbCTiLkMP4Nm6lcRQOn0/gd1JmuOxRrgYOoM28u6vGjPaC/OEuUVQOSdq+0oTOoSFRPcgl2akD6Iol+AfH6O5/kpNGR9J9plMIWPPtSHjCpggpN+VLYTC2JHEcL/hfHQAUEV8wSx5kxwHtgbQlHSXQzNZVr0CIV08qombBp0I2BcyyjxpLBp+Ns8uLbPs2Hzb8WWEIFEqR/tcB5B8C7PMZqp6vAcvz5XPvzWkc/bSmk8aL0+nOI9NmV3NCSByKdjBgdvoPRa4pqYsBc2s1qa1eY/d5kqWJJ94Y1APo+LYqPPw3dtQVmXKtecK2ZHBXABb0FSQOQUzRM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leA+84L81ecEY6u1l+0lsBrQI30mLLLA7At3MTYzFRA=;
 b=xdhoAyHbiz4hre+WMtK/v3X2Ox4EHZMXCBc219TWA4AIlTRRwG3LLLH+UYFrD9KW+WEcEi7myb2XkxOh2oisc0eHwnQM+demtTN1W2/EcAfGUpb7PsaL6UYOVSZAak5v9d2FGR5j65TESJA05fiDiBimMlsw/FcDIfRsMNCXBA8IxbxAqgRpFHhRcm5czqhqZZyH2+tZ+kf7cJUMuwp2nr/jHZoD+D8bT6qHjX6+ip4MCIMX127x8d/nKJ5WOQf2h4pljUO1geuInjLHkae3g7VfU10f0F3xjaDj6vS0sDHc4xGBQgo8ZOkhiAyhZHMyW/X+anR72eYo7uOi30/3Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leA+84L81ecEY6u1l+0lsBrQI30mLLLA7At3MTYzFRA=;
 b=QQRnK8teHx3vtoO/X0RwEy3k++rmKxzKBWbFS3z3l3bhWvVbC0L8l/mMwcGap1pzc742KmF8UNeLYz9xI6IQ3c4PbRuOxZPnymHtDE4BLsgLLOvn453VIPdmIIpABgiUlCEK92RWUWyIWE/ZHTMJsw+lQZnXWah1CHHIepHUWC4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8588.apcprd03.prod.outlook.com (2603:1096:405:b5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 09:12:24 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:12:24 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"wkon.kim@samsung.com" <wkon.kim@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ufs: core: Initialize a value of an attribute as
 returned by uic cmd
Thread-Topic: [PATCH v2] ufs: core: Initialize a value of an attribute as
 returned by uic cmd
Thread-Index: AQHcPMTIO+8CK43TzEaJJLNmh4ZFhbTGEsKA
Date: Fri, 17 Oct 2025 09:12:24 +0000
Message-ID: <38ddeceac8c97739a976afd5dc66561b56023992.camel@mediatek.com>
References: <CGME20251014044050epcas1p3589b404dec77da9fb9f0f79035c149ca@epcas1p3.samsung.com>
	 <20251014044046.84046-1-wkon.kim@samsung.com>
In-Reply-To: <20251014044046.84046-1-wkon.kim@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8588:EE_
x-ms-office365-filtering-correlation-id: 971715ef-5fd6-48f0-3f1e-08de0d5d491d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dXRSd0sxMEdLRS9zTnVTd2traHNGUnB1ek1kTVV2VU9OR0xYOGdYaTltV0J0?=
 =?utf-8?B?OVllbitmd2hDQ1prYWxFWVdXVHNHa3Y5SjZleE1rajRHa25JdDI0U1h5cml0?=
 =?utf-8?B?NXBXU2lmNFZ4cFNTMysvM1ZUN1VyeTNNVGx2aUFpd2l2WWxFV1RLSW9TcGds?=
 =?utf-8?B?dVVJbktVU28vRitIeE9vT0gza0hwTjBwbkZTejdVV2puMlQrNElTUEE2bzZX?=
 =?utf-8?B?OXd1V1I0WTByY2tNQjhsbHlBcUFmTmhuWHJsQTRpOC9HQUVsdVN1cjJDUXhQ?=
 =?utf-8?B?Wnp1Z0FYelkveGdiM2FxZWhGVE5wM01zTXBSbnMyOGNLN0ZXM3k2R1gxVndr?=
 =?utf-8?B?c1RmckVXN0VZQ3RNeFNiaXZ3blpLSVVPSTZQNEl3TDdMNmJ4eXFrVnp4c0t4?=
 =?utf-8?B?Z3ZFZFdXbXhPMWtJN1dYMndKS0NtVUcwbXc5MXBXZ2lZVm5kbUxmeHRSN05B?=
 =?utf-8?B?SHFqSElOTVBDM1lqczQ1TTU3VHdQSHVYbDBmK2Z3NHMzQmFpOWwxY01VNGNO?=
 =?utf-8?B?UklidnQ2YVpJQ1VZeXpWL3BCeW5VU09DRWpzNFJkT2Noc25mL0pMSDBQNnd3?=
 =?utf-8?B?QVdKZXBEUGZadTI2bEtEOVVJVWdSbitMbFVOajA2eUN2eU5PbXRKa2NpRkhW?=
 =?utf-8?B?bm5PSmo5TXNKRGNZbzUvSzlKeWhXeFAxYjZGNjZBSlBNcU9ySkJpUEZOY0wz?=
 =?utf-8?B?emRNQ2s2bTdhZ2tqTEpXVnZKc3o2R3A2RGh5MHdiZFN0cUxFZm00NVlrcmQw?=
 =?utf-8?B?ME1UNUFydkJDUXh1dTY5TU9iSnVCSDRoMFAzV0tFVlVxVkllUTc1MWdNNmhG?=
 =?utf-8?B?N0JxM1VqaEtoTUxIdHg0YXJIejVDVjBsRVpZZm9JcmZzc2xBZCtrcjdlSUtq?=
 =?utf-8?B?LzdlT0tXemZoZ0RBWlQrMDVqbkRzU1dheEREcHlFV2FNQVJBbkUwc3Y5R0Jk?=
 =?utf-8?B?VlN1RmM2Q21pSjZuVmdxK2JMOVBtelFDQ092QlNEVzlkUllXSzZHUWx5Y0lo?=
 =?utf-8?B?WFdrQmNQWGh3aTJ2V0hINkh3bEVCZkcxZ2lBcG9leGNHbzhZeExZSGl2WWNi?=
 =?utf-8?B?dzdBb2JVa09MdjVpR0k1N0F2c3Q5YUJ4eWVKS25EdUdOajZBcmFjdlUxZENh?=
 =?utf-8?B?VzJGcTByeFp1K1BMK2E2Q0haSnV6dU5LblU3bTdkYjEzSzh4K1VHL3JOSEc3?=
 =?utf-8?B?MFVHR3hSVFlONFJnc1Z5UE9ieFRTbE5GNXpneHZMMCt4SWE3YkVyS0lUdkdJ?=
 =?utf-8?B?TmpCeCt2ejhodHNHNlVWRVRRa1hqNDkzNEZ4ZHhKbFNXM1kwcGc0UXNDNGpQ?=
 =?utf-8?B?TzJYalkzOXZOTHhBczZWdlIrRjM4UFJpcGdJeTlCeVpJVmZhbHVFZVR4T2xJ?=
 =?utf-8?B?QTZJRFlydkxRc0Y3WDVmUFRPRjRlRnh6TUdsakJaaTFkNG1WM1B0UHZ4Nk1N?=
 =?utf-8?B?NXFLOHl4d1gxQUlBOCtHRDN3QXVSUUhCbjdQV0pEM1Z6OUVobTRHWm9Fcmp6?=
 =?utf-8?B?cUNscjhwZ01xZ3NZYVo0ZDhyL3gxemJROHo4bDJqTStTQmh5SmY1bHlBcTFI?=
 =?utf-8?B?YTRSY1ZkL2RuUU91cW9XN05IOVBOZ0V6cHFsRUg3N1N0cFpoaE9xcXpoc2lC?=
 =?utf-8?B?VFJLcWVUTHIyR054enROV1FTdXNHSERKSkU4dFd6c1BrOUIvZ1dSVkFWdXFo?=
 =?utf-8?B?T25QOFlkVW1sSDlCTjVXNnoxMXdFbE5GSnM5VEYrUVJKQ3duYWFvMTlqUmlW?=
 =?utf-8?B?cS9iakExbE1SaVdsMjcrRFljaGFlNVBDd3VsamJocnpkczhQMDdGK1NYaFVY?=
 =?utf-8?B?cWQ5Sm9FRTQ4bWZ5OWptaEkxd0NKejJoaWkybWcySTFwdDc2NnltUXFURlVr?=
 =?utf-8?B?S3o1T2pVYWs0YTVBd2VEV2Q3ZHRUc3pldUdXUWlESVJXSUxPNUgvMGQrcDlt?=
 =?utf-8?B?dFRUWk40WXIxQnVabklPaUM1K2FsdjBwaC9kRVVsNzlKUVdIRXZHMXR6dEE0?=
 =?utf-8?B?M2lIM3NhR2VNb245UlpqR1VJdEl3akVzSVlVUkgxNUdHcHVHQmlOVDhQdTV4?=
 =?utf-8?Q?X+fdNA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWsvOUdTTmxPZHVHVXNXRXFHejZRV1FIV3lnZ1IxcXdYTFkvd2FGdXFsR2kz?=
 =?utf-8?B?UjB1UU9hOVVRRGNsUGhySG9QZW9jdVNXYmFBY2FUTGk3S3FzQ2YraXFKN2RW?=
 =?utf-8?B?emR3aERMbjQ1QVZrZFpQZkFKU2tMSWxzQ3NJQVUyNUJmVlJLa05VR0Y0d05E?=
 =?utf-8?B?c1g4S2VKTmRrMGJUa2dpL1B0QlY0MG5YWkZMdnhZd2NaTXVnMCtlclhpMDVP?=
 =?utf-8?B?bHFYTVNON3lHUGh6cVVORVdaRXU5ekRjbFc3cEFpajFWcllOdm1kdGZTeDVI?=
 =?utf-8?B?NjQxLzIzZnBvd0NWZUZUUjlHM2VISjd1OXdOU1p2a3IzWmtiVk83bW9iVlN6?=
 =?utf-8?B?RFRhdUNqRkdYWmZWcHBIdlR2Y2NzK0lHU3BoZ29MSW1UandXQ3NHck1HZGNN?=
 =?utf-8?B?ZDk3R1BkNzZJWmd2L2VPYTNzQkdaNXY1dW9jdUorajNsV1FRc1ZrU2JZanZG?=
 =?utf-8?B?bHF4Mk1FYWZhNy93dHJLTk44K2hQajRzSUxWSm8vTjBMWmgzRUJPOUFuSkZ4?=
 =?utf-8?B?UVVwVm9Ic0lFQ051UlhLVWNBTGpZU1dmVVduZEpzNVlPVmtLU2pYYlppWWpy?=
 =?utf-8?B?OVNBckN2Sks1aW83ZEl3TGtJMTBnZUNaenhzVGZrMXpmSlBGWVp0Tmp6VUNF?=
 =?utf-8?B?NXhBRzVqL000dllQZ1VTbTd1ZlpHUkoxdElHUGw5NFFFRVZtZ2pMSTlHNmF5?=
 =?utf-8?B?ZEMzUzlSQlJCQ2IybjFYcHBFZjhXRzhSdXI3dStsOHY3bWZpdmFjZDlINDJD?=
 =?utf-8?B?QzhFRUQyaThlK0lxdUYzb1BzU3BhR2ltWi81QlhubHNHaWFXMEVxOS9BanVu?=
 =?utf-8?B?aVhZVzZOZC9LYi9Sb1BUVXlxYkdMcDJSa1c3VUZXNXBNbi9YTTlkZVJqdXp3?=
 =?utf-8?B?bmNxRmlCVGl2QXhGNDZ1N25zamdlbkVTeEkrcC9Jb2UzSVNCVG15V2V5ZlY3?=
 =?utf-8?B?b0gwcXlsbk9RRFF3WFR4MTBUY2RGaW0vN2JBeU1UYjNJbUR3dDJVYWh1N0lF?=
 =?utf-8?B?Q3A5b3BxRE1LOHhtbnBCYTFvRmFvQ1dKai9oZG1NdExFc0dRSWozZXJaL0VE?=
 =?utf-8?B?MmpRY2VQNHB4QjBtZTZkMHFMQUtmN1BHanBZaFdlcUh1ZmFUN3BFMzFMaVFT?=
 =?utf-8?B?eG5oQlVLU1dzQzRIVks4aThxd2ZoUXA2aVh4RjlkZWxWVjErZ1VXdE15QVJo?=
 =?utf-8?B?dkdadEQxWk5hYzZHZnV3dE5tYTk5UUN1bldJaXJUM0dpbmpmVjM3MWVXNVlN?=
 =?utf-8?B?aDBqSk4rTkcwclNUZmZTNjgrbzQ4TmdCaC9nOW43TFQxY2J1d3FnNHVYbExs?=
 =?utf-8?B?UEppMkFJcU91WHhLZnFWUWRaaVNRdWJFYU5KeHVnQWZZNW5NTC9hUmJkOXBT?=
 =?utf-8?B?aE9sVE9nVXpET1lDbU1UMVZ2M2NiYkYreU9PQmozcFdmeFVWT096QWsvN3NH?=
 =?utf-8?B?OVNtb3dWQWl0RngrZlJzNGFNSHI2bEZZTk1tTGV3Y0FIdzcwR0ZFL0EwMXVu?=
 =?utf-8?B?Vkl1OUkxLzR2M0tPZjVoamIzdVJ0S3lENThvQWdlTUdOVXVKZU1reEE0WXl5?=
 =?utf-8?B?bDNxOHVHc2duOGs3NGpzK2dHVS9reHV5eFdwMzdlYU8rRXc3bnlYVFNlMkc0?=
 =?utf-8?B?aWg2SEduZ0NOekhFMDA5bXZwWGVFc283TUVZS2Z1RUgwbmFZSHdiQU5wVWN3?=
 =?utf-8?B?MGsvR3VFYWdsS0I2SnNCTURiYzh2NXZ6bm1XS3JkRWVqeHB5SS9Fc0s3eWZt?=
 =?utf-8?B?Vlg2cmxVVFUwSEJZSmpMVlU2clR2bE91Smo4ZURJZU5vTVVYL3NBNjRZc0lq?=
 =?utf-8?B?WEVOZjJEZUFJVmg2OFBKdUk2RktKWUpxRy9Sb0Y3Z2Jmd29XR2VyWjVOd2Rh?=
 =?utf-8?B?UURRQ0VwbEZoYjMvYzRVM2E4UzhrKzlVbks1T2Exd0xIVGpySFVKajBNQmp6?=
 =?utf-8?B?Y2JKQ3dKTitzZVVpRGVDN21DUSsyK0RKT2RVL29WRXdrT2pIYkRVOUNQQmJG?=
 =?utf-8?B?SVA2L0V5WENpSnM4TlByTjV5NHBqWktqSnAzRVJLcVNuWFo1Znp0WkFFSTVB?=
 =?utf-8?B?c2NHRXNJOEZtNW9jR2tKQmZ6eFk1NjdWbUxnbGJnT0pUZUk5QnJFMG5CV1Bu?=
 =?utf-8?B?ajAzblhVQS8vKzNLc05MdUExeDVFK3BpZERabmkxL2p5TysvTncyQ3dYZEJi?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6788CD0B5645BB4D974DCEBB8D927240@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 971715ef-5fd6-48f0-3f1e-08de0d5d491d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 09:12:24.2570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IX+AZJa5/VC08Ye1DVOk/c6BEL5FuqK9YPEIGaZVWXL6V12Gjy3D8WJfHHFzetNrTLz1cqD6jg3eZxeaWMxxXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8588

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEzOjQwICswOTAwLCBXb25rb24gS2ltIHdyb3RlOg0KPiAN
Cj4gRnJvbTogd2tvbi1raW0gPHdrb24ua2ltQHNhbXN1bmcuY29tPg0KPiANCj4gSWYgdWZzaGNk
X3NlbmRfY21kKCkgZmFpbHMsICptaWJfdmFsIGhhcyBhIGdhcmJhZ2UgdmFsdWUuDQo+IEEgdmFs
dWUgb2YgYW4gYXR0cmlidXRlIGNhbiBoYXZlIGFuIHVuaW50ZW5kZWQgcmVzdWx0Lg0KPiB1ZnNo
Y2RfZG1lX2dldF9hdHRyKCkgYWx3YXlzIGluaXRpYWxpemVzICptaWJfdmFsLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogV29ua29uIEtpbSA8d2tvbi5raW1Ac2Ftc3VuZy5jb20+DQoNClJldmlld2Vk
LWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCg==
