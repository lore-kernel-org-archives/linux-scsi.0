Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A633207;
	Tue, 18 Nov 2025 05:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763444910; cv=fail; b=KMoH+RpxeRoFVOmoOvbQ6Nv6q86GGzDkiTfTshjaJu82cgW8R+AherIxZSotEdMVU/4uatsNOB44s/H8U4l1aWeBFeOpe6Bx78Ej4mol9nbS08uHKmEy5K+uVm9h6WWVt9NnR5t55MVyq5i1h/jDF/zyrjMiV1GUvd1qlacKmi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763444910; c=relaxed/simple;
	bh=mi4dMlNRgQ9FchAM9QdF/EBOhz3GeiyVEY4aqnMx9ac=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KjEvU4JrPkAIWXQwmfCg8BHzGXNjPKHY2RtUk9glnSvCwOm3O7aAdHF6Bq7/2aB1We1bKOGENiEAPFKTX5paNAUwpP1nz4CXpS11Rjl/dMqk2egtss7Aqc6bQhZhyJxNMUxNQBRFtKk00PVgOx+aqmX+YJ4ixO1qs2s+73ERBo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YK9edPQe; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=F7WTpg//; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YK9edPQe";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="F7WTpg//"
X-UUID: 307e5350c44211f0b33aeb1e7f16c2b6-20251118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:To:From; bh=mi4dMlNRgQ9FchAM9QdF/EBOhz3GeiyVEY4aqnMx9ac=;
	b=YK9edPQeTyl03hzBLt+kIDSxIhXndnx7mOR8Teqtkb5tp5xLxVV1aXmiZBLR+rjOeSR/kXMhjWqHFDfBnqdEVy8ogbUqbN0dihnMZQ48UFgiztimSgKbVHeCtPJSky2NbqcdaRLrJCMRg4rdFD5THoQU7VHFwj4zBqtYTIIcJ/U=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:aa2d3f51-58f1-49f9-b65c-7e94b42721e2,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:97a40358-17e4-43d2-bf73-55337eed999a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 307e5350c44211f0b33aeb1e7f16c2b6-20251118
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1981846271; Tue, 18 Nov 2025 13:48:20 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 18 Nov 2025 13:48:19 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Tue, 18 Nov 2025 13:48:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tbnU+FSQDbZKsvcMqWb963oR8ovHC1zKEZaYw0eGhLwvO+n7MlMPeq0pmQqxh405720LglzLRQ1/TiStp6cArfPBTm5y2mZ/UY8cyC68xfL3J16wHQGM9sNkSHrXyNkCze+jgjCSFgrWUj7yiKqf0AvjMTUdzqrRxDTqKA+ab2qpiqF7XFljnEd3kDKeEAFI4V4ybholL9ewzxHCvidqrlFojgDSjtvZ1sitjEBbgcU6UeUarmE5HDRHjpcRsG2O1LQrfz6f8qDhnnQO7EAFnApDJ6bo/Le1ijo3UYz16+A6p8pq70OiZMEGJXcTgZGMdwaJJKAL6r4XsBSDpFZV8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mi4dMlNRgQ9FchAM9QdF/EBOhz3GeiyVEY4aqnMx9ac=;
 b=AXS5nXzuju5ftXBJZcMx/iznoTl81WOI2oFbGHJCFIU5vlk3CodhQtj52+cVTFhOfMfRG77bHgyB2RUdYz20SJkW5RyD+te2AFWqR0+XsG9w6CIN/0Tcb9k3DQyxgWBF5ewP9AjkS1CpxmSPdhi5Gvp5jBx2BuGSbml55bC10ZsczpEfZa07XfycPDrATotWD1CQ6kKJ+tD+ppIYgsUrRpgU9Y3eiayfGP7VrPL+dhXP8eEjyJJCnWNUaCZw9d4TBB002ODTaQI+qh1BK+SCrJwN5TkFjnfyenBSjf6vvHUx7K+yOpn0vToPTQ6GDT4e2pJLN7nDn/Hr2874BUkiiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mi4dMlNRgQ9FchAM9QdF/EBOhz3GeiyVEY4aqnMx9ac=;
 b=F7WTpg//jyaQUawTXJqzzogOm6uHX3NXYmWciEN8pgYIDZAcv027QEnuAbDLbKWepywI4tuAW9e6icz87fNcxAZG7rWISb43iL8HbvLD0fTzt976qnkq5rlUH25Q1fX/thqB/3GBn1S4e4cdCk0gSV37AA3yCDQdRUxC0dD/qxA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8476.apcprd03.prod.outlook.com (2603:1096:820:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 05:48:17 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 05:48:17 +0000
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
Thread-Index: AQHcTryHb8yV6u0+lEKcdlgCbA0ur7TszUCAgABkAACAAAVFAIAAfuaAgACtbwCAAOjIgIABIdaAgAYXzICAABj+AIAAExCAgAFPEwA=
Date: Tue, 18 Nov 2025 05:48:17 +0000
Message-ID: <9c6fc92a0196d76d4130c5cac5fecd26c61f6593.camel@mediatek.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	 <20251106012654.4094-1-sh043.lee@samsung.com>
	 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
	 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
	 <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
	 <500022ecc5216afa01e7f606187f012294a76da3.camel@mediatek.com>
	 <000001dc57a7$661a8040$324f80c0$@samsung.com>
In-Reply-To: <000001dc57a7$661a8040$324f80c0$@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8476:EE_
x-ms-office365-filtering-correlation-id: d47ebec6-4c8e-4bab-e43c-08de26661286
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Z3lyZzM2d0IvR01QY3NYQTdFNTE3c3dpakF5LzArTXNhL2xjL2RyZFhmZEov?=
 =?utf-8?B?NHpRUitxMTVaQmxDbkF2VExXRTg2MllXMEF5NzVvRVFZaC9Cck03djlIVkFZ?=
 =?utf-8?B?UXhFdk9XTnNNZnlKc09xaXhnUmI1Vk1jMHNHU0lvK0lOWldRV1oveit2ZHBv?=
 =?utf-8?B?b3lpMk10eGkxYVRlU1BHQ3AydmozeFNVN05MdC9zbEFQd1ZoRDk0eDJMYktY?=
 =?utf-8?B?dlU0ZzVkWEdOeGJudGM4cHV2ZG4ycUVKbEM0UmdaRGgzeUdhVFc3QnhwUzdm?=
 =?utf-8?B?L21YWitSeEFnRzdxMWhVMTZ3OVdEam9ZUkFaQnJORzZLZG5vUCtnbDBodGpN?=
 =?utf-8?B?bDh0aTlCLzYreUVHVUxEYnVsNWRSa3NwcUF1b0N2UDlqbUxoK0YwWDJETFE3?=
 =?utf-8?B?RFd1THpKVmZjeTZ0eitWUTBYMDdrMHAwekY1Z2RkcCtVWGhRYXg2b3UxRUhm?=
 =?utf-8?B?cy9DNFhyem5pTzE3Q2h1bStDMnEwMDRYNE9XL2VQL21aeVR0WkFraEMzZ05u?=
 =?utf-8?B?dXl0dVFESkxWc2VOREJsZ2tTTnJBUWJvUXFyamdLdlkrMXQrY2IvWVZRUFRy?=
 =?utf-8?B?MTdtdjZhS0dDMG5nemM5SXk1eUZDdDc4T1RrSTRSRzIxVVNUWTdSKzI5T0ZC?=
 =?utf-8?B?QSs5ZGgvY3FpNzZOQ1dBcW8rWGRtdFlER3YydlZsOWYzK09hbXV3RFRzZm9G?=
 =?utf-8?B?aDQwakVXb2xlR0pLWWJPblpucTk4Snl1OHhOZWdaMVJiUUlIOWhLOGRLNW53?=
 =?utf-8?B?cUFYUWNFOVB6OEhrYVphTlhUbzM3QzBQdGNxN05rbk9qMTJkeHpONGZ3ZjVk?=
 =?utf-8?B?V1JUbGRvY0NVbE5MZExOdDBvUVN0cUFRTTlpTDk0ZVBNZ1RBUUVxL2VRVFJk?=
 =?utf-8?B?ZisyRDhpTm54aDZQNVVPYjVrK1ZtLysxYWs0OHpPNnp1b0IrOEdHVmVRc3ZI?=
 =?utf-8?B?UXh3ZVd6bU1vK1h1Z0pFbXRwNXZZdGp3RWRMeHdSS2FjTk1qZEx3SmNneFp4?=
 =?utf-8?B?TWFxMmQxT3ZRZ2hlMjhqcFFWQ0lnUnQ3bnVRV2srd1M5OXNCcDYza1p0bXR4?=
 =?utf-8?B?WXJuZG9zNmo1WS9PT2loUVFXdllJRzN0VXpabG80a2pjMXhKa0drV0pJU0s3?=
 =?utf-8?B?MTdURjl2QnN0Y2piNUVCZDRpK2xBRDlSbklNT0ErUU9sKzdxQThhY0QvU3o4?=
 =?utf-8?B?bm55cm1PVXlLZEUyZkZnMGd2NHAxVVRJdGQvTDRWaWROUEQ5MWdGS1ErWU9Y?=
 =?utf-8?B?NFgxT3NQTzBQeURaNUxjRTZVa2k3b2w2VFhycEgwYzBBb2QrTzZmNGxkcU4v?=
 =?utf-8?B?ZlF0c3dMdVNHOE5udmRONVp1ZFpwSkR6M2l0SXQvcWUzR0FUZzlPclhvN1hG?=
 =?utf-8?B?Mkp4M1FraWFXbVE0b1ZFNi83Rmp5dGRpNHovRER3RnhyL3gxYkdySFRhUHNm?=
 =?utf-8?B?U2VySFd1bDdqSjZId01Wb0xjbzV3d245bWFzTEdCL3VzOWExN2V5SW5qSGhx?=
 =?utf-8?B?b1I1eHgrWmdWOHFjZVJLRlVSZVF3QUkxOUN4Wi90Qi94NmIwMWtqMnhkdlhq?=
 =?utf-8?B?ZDA2QVZJeVFHRjlsWWFLNzVkVXZSendHdk5wRlpzbXFGZVcxbVhaSVQ4Ykt3?=
 =?utf-8?B?UDF5TS9lWGdWRi9waTR0L0MyMWZueXQrU3I3clRFNTN3Tm84S0t0Zk95bUtN?=
 =?utf-8?B?TnUxb0pGbHdoNXVmNnVwRTBDUFpwcDBFZUhLSVVKU3FwcWRlV1FVRU9raE9o?=
 =?utf-8?B?STJjcDBtdEhOMmJCa3l5UlZZUTdJaGhISTcvNU45djd1SFEzNUU5WU5GdmVh?=
 =?utf-8?B?SFR6eTFFV3k2MStGRXc3NVJBaVRzWnZIQ01pMDNzQkl3RFpPbnl6d2FMaHgr?=
 =?utf-8?B?TkJCZzUxd1ZvY1VwQUhhdmlIY093bTRhSy8wVEJzaGx5SW0vemxWWkY4a2Nh?=
 =?utf-8?B?VlRVQ3M0T3RQYTQ5VlE4WWkxTUpMNUxjUTFISjFlTjFjeU1BYmx4RzAxODk2?=
 =?utf-8?B?cDhHQzVZOGRzdXhFeTBDSGxvUHBHdlVEaUtLY0s3QTk3MVF2MDIyVGdqTXpa?=
 =?utf-8?B?bVV5ZGVMSzdmL1Y2bWNxMmVxbXVKUWYyd0lxZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGFKMlRoZU5nbXpjN0E4VE9aNTFaNG5na1ZTalA3UUJSREZEYk5sYTNIb3Za?=
 =?utf-8?B?V3E0Q2RDdzU4alVhaVF3ejN2RW5PWFlER0FScHVCRDYyK1FlbUh6ckZsYjVs?=
 =?utf-8?B?Wk5CeHZCcU9YWjlUR0pMSTBiUGhlQ04wT2lESk96bk9KdE9ySVlQYWtUUEcw?=
 =?utf-8?B?S3paQm5iK0VMRUlXMjlSM2R1d1pFWVM2MllZMGdCcjh6U0ZkbWpSblZ5THFM?=
 =?utf-8?B?aVpYbzg2OHpSMTFhL2JqUSsyVW5odHZkazEwbGhXNFNsLzJ6Qi85NEoxK0ht?=
 =?utf-8?B?REpvdW92YTZQbHpnaTV5M3djUVBRUGI3blRIdlZyVXBLdjJxRVVrR3lQYXRQ?=
 =?utf-8?B?a3lZT3FVQnFXUDI1WUliZU9GQTgrcGJYalhGMHkwd3hsZUV0aWszcnkxSEtu?=
 =?utf-8?B?a2NMai92REdkb09HZVk0ampuMEllb2FvRldxcWhqVGhoQTEzY20yT1J0RHpX?=
 =?utf-8?B?N05pdkd3VUZnbU5tRkk4ckRwc210QXZZdW1LS1l6aVdiSmFlWHhMZXZjeDRi?=
 =?utf-8?B?aHdUZzU1TEdwOE8wUklqMnBSUjVFRUNVTHZNL0VPazMyNFlsc3VNcGlJeW9F?=
 =?utf-8?B?Mk56dTcyMXJ0V0VqWkxjT0hoYkVYRy9hN3dsZW5UdmFaZjBEVnVtTG5IV3Nv?=
 =?utf-8?B?WmJ5VEJjQkRuNTJhN041UVQwMlVVM1pMRWczUVg1K3d6NlhYeHJTU2JVWEFH?=
 =?utf-8?B?MXl3QkFqdTlhZE04dDdJY3R1dTArUUxzQjNEajRvNzN3NVJrMlg5K1hGamZh?=
 =?utf-8?B?bFkwSnlnVTRVVVBhYWR5a2g1a1JGNk8wNU1OSU1wc0tZMUFYL09aRWNzeGRz?=
 =?utf-8?B?SXkrNE1MSEJzR2Q3T0R4UDZHdCtQTVFDUmExSjB1Q04rVWdtNmJsU3M4a3E0?=
 =?utf-8?B?VVlhZlF4VVJUMThIL2xwVzZTZmRVeFMzQ2RCS1ZoRlJZZ09DSmRmZ2RqNEV3?=
 =?utf-8?B?ZllZU1NLYkRQRkJhVVlvUEhiM1h5Y0k4UFhtcjFEaHJnS3cwMU16RkZhRzNk?=
 =?utf-8?B?Q1V2cjhjbUxtQXhlT1RkTG1mc2VVYi9DZzlDcHczUGNILzFlL1AzYmhUL1hQ?=
 =?utf-8?B?b2xPS0hNUjdTSnRMRFVYNGJad1J0WmNQajQvL25WWUJVV3c1TC9xc1FQVDFa?=
 =?utf-8?B?QWlmaElUdmVmQXIyZFdLRjFXYjlnamhxb2FmREpJbDh0UURFQ0pscWZUN2hR?=
 =?utf-8?B?Yy81SzdBSFlnZ0JML3hqRnhUaGFVczR2S3dLb3BaeFNzT0Qyb21HSVdEcmJn?=
 =?utf-8?B?MTQxRDM2RXBYOGdyWG1uNlZ5VlVuQU1MbVhPblFmaXh6Z2JCNmRXNkZQRDdz?=
 =?utf-8?B?ZWl2eXp6VXdKc3VtYk53d09mU2l3bWVBVlZGaHpva3BTQ1BWTG9OMDFYaWZj?=
 =?utf-8?B?L2xCZk5hSlNZdEhyazJBa0lhVWxHSjc4d01xS05QWGplVUlJMlhQOVM0QkVD?=
 =?utf-8?B?L3hTRitnMVZ6bzgyanJqcGVJOGZITVpWZU05a0pUdEdMT1MwKzNSaWZYenVh?=
 =?utf-8?B?WVBrNWFWaklHRnZ1K3FGeStYQktuM2ZhVnM0U1cxU1dCb1pGVkVnZVpHbXJt?=
 =?utf-8?B?cGZvUWdnOTRkRUdDaStqcHpRakJoSTN2QTA3aGZDd0ptNE1JQklrUmp3SENU?=
 =?utf-8?B?N1pteUo5UnRxWnZSZUJCU014eHE4RDZTMXBBM0Z3OVlnUXdGeFkwS1I1ek9T?=
 =?utf-8?B?ZXpMRTI2Rk5IUzJLd3E4VWRyUUJITGd0dEZOdi85ZGp6azVsQzVLdERMdUp3?=
 =?utf-8?B?VjJrZkN4SGlOazk1cUxxNnhRb05DaTZYK0IwSXRxRWlPUlBOZWZ1a1ZPOUkr?=
 =?utf-8?B?YTljZWZnbGR5R2tnbVRLT0V4b2hMM1JqVUVmRGZmMzBMQmFIYS96aXg3NDhI?=
 =?utf-8?B?dnhFWFFNYTlnRWRmNE5kczlKMzVMUFBzaE92SHJCV29UOG1GZXAxTGFSZ2FT?=
 =?utf-8?B?eWFnVE0rbGpFVWJFbzRrQUxXVEFjc1VPSWdCeVg3NTZNYXpvZ1VTVWNMMklL?=
 =?utf-8?B?a2Jtdk1ocXRYS3JqREVtaVN0QVIrWEQxSnVDa2JRdnRWUEl2OG5Kb3dFU0hK?=
 =?utf-8?B?WS9SVXJJT2ZmK1g3MEMwRzB6YUlzNUJ0V1FlUGtLNzNDZFdFOFRMT1BudG84?=
 =?utf-8?B?NXR5a3dYVEY2dkE5NFo2d25iNkV0V2ZvNkd1R1hJNVJoaU9lUWlKaGNwOE9D?=
 =?utf-8?B?c0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0733686048EEE843B594CBD67DAD5AEA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47ebec6-4c8e-4bab-e43c-08de26661286
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 05:48:17.2046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K1kgn/V8+tC5KXXDtxLzFqOn4MZJ0uyoACUXuEAWT9E5ExbOClf1ZCL2Naf3A3LJ/6An9J++V0MwJXdXBCUhDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8476

T24gTW9uLCAyMDI1LTExLTE3IGF0IDE4OjQ4ICswOTAwLCBTZXVuZ2h1aSBMZWUgd3JvdGU6DQo+
IFRoYW5rIHlvdSBmb3IgeW91ciBhZGRpdGlvbmFsIGNvbW1lbnQuDQo+IEJ5IHRoZSB3YXksIGlu
IG15IGh1bWJsZSBvcGluaW9uLCBpdCdzIG5vdCBhYm91dCB0bSBjbWQgdGltZW91dCwNCj4gYnV0
IGFib3V0IGhvc3QgcmVnaXN0ZXIuDQo+IA0KPiBJZiBpdCBtdXN0IGJlIGNoYW5nZWQsIGhvdyBt
dWNoIHRpbWUgZG8geW91IHRoaW5rIGZvciBpdD8NCj4gSSB0aGluayB0aGF0IGl0J3MgaGFuZGxl
ZCBieSBkaWZmZXJlbnQgbW9kaWZpY2F0aW9uLg0KPiANCj4gVGhhbmtzLA0KPiBTZXVuZ2h1aSBM
ZWUuDQo+IA0KDQpIaSBTZXVuZ2h1aSwNCg0KWWVzLCBpdCBpcyBhYm91dCB0aGUgaG9zdCByZWdp
c3Rlci4gSSBkb27igJl0IGhhdmUgYW55IGlkZWFzIGFib3V0DQp0aGlzIGZvciBub3csIGJ1dCBh
IHJlYXNvbmFibGUgdmFsdWUgc2hvdWxkIGJlIGF0IHRoZSBtaWxsaXNlY29uZA0KbGV2ZWwuDQpJ
IGFncmVlIHRoYXQgdGhpcyBpcyBhbm90aGVyIHRvcGljLCBzbyBsZXTigJlzIGxlYXZlIGl0IGFz
IGlzIGZvciBub3cuDQoNClRoYW5rcw0KUGV0ZXINCg==
