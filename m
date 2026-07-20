Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139E83D170C;
	Mon, 20 Jul 2026 09:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538838; cv=fail; b=AfSHuibI0Dv21fNAbpHLP0yOdOe3e/iZgeiu9L+iOZan8t/Qd9PiAjBjmrbjzCAsF66udFHirfHE8Li3AziQBjlFXlgTa+eD4uKJ9ZpEyTr709dugrJWdqqJRiMAibV353VPSp69zbYNrDgkBHKJkHVymZvlCA+WUyASIXdd24A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538838; c=relaxed/simple;
	bh=ep1hd8PCSWXMeHK3SlKc7uLnq/EfAGcGCfE/AI5cNVs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AG2kjuBv044njs4QfPSyw5cjCVj94fliAYQQOEDXyIc/O5DhF5GwlMJrcf2rxq7QwWXyTNX8GgVAphvQN48F0XF0UpOVa3josxpr1MKS0IkVrenscjpvWaObXZOT+Vb4eEV/z3iOc4KCL6czLGNFRgLZZF+yQ+hQI3kTNR9pAN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YoZ2W/TF; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=srRVNTRk; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YoZ2W/TF";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="srRVNTRk"
X-UUID: 5344dd34841b11f1b1788b6acf885367-20260720
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ep1hd8PCSWXMeHK3SlKc7uLnq/EfAGcGCfE/AI5cNVs=;
	b=YoZ2W/TFuhvK2PLFoa5UYtga4k/acGHGiaJ+De2OmCMAl6GzeMsKo+0TPn7mQpG1VXDRDxs9Q8S0M+TGY+45MH8VE2as+8phdgu+PBc1O9SfjwBJZyDaAH0z6JNnhORbapB7txFVxCypnGGoPUoRkc0gvvzVpnFVnaHLRpxavf8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:398ff9d6-10d6-414a-bb42-77bb8e2f457f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:ffc27a3f-46cf-453a-bd84-ad9fc7cb0e8c,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5344dd34841b11f1b1788b6acf885367-20260720
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1303709401; Mon, 20 Jul 2026 17:13:52 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 20 Jul 2026 17:13:50 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 20 Jul 2026 17:13:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJSY9wn2Y4B3IlIXTBmy9ROaZYK54UM1IZYANkpgd+WEcShQNdpwKMDzz2fON6VQidbB9WwzzEwa9kbQ33RSILhPxgj+pPW0QyNSQ3343OLBOOPMriqRCYft5GZjB59KC4d7pB3mEPhYJNDqz3mOakaJblpyXm+qVMURCFtWjd8qhUGJCZjySbsg97njKAR+Vp3idnL0B/ZsHiiK1hhAPPYCgBg16zw0fXXGSggxG8Vp+ublaUiFsBxcfUobfI5IP6EaKLLdGgpEVtI+KTulyrfQEIgoAUsAPGP8DsBf0UIZpPwJkET1eb84M9qZXLWK/edK1F/09f5nDbNdqcnTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep1hd8PCSWXMeHK3SlKc7uLnq/EfAGcGCfE/AI5cNVs=;
 b=avKVs1xcK3fFPnhcVBomsDy55NG1AXaQcnXpp98Sl+i6kWXglTv6FNly5V9NzIla4wY2lS30m+ceIPaQIDq5WO12r505wz7o4lVpwdEUbbM19hRMYtE0CRPCVJNw5N3UvcArDR3Ovt+brscf6v0w4phtjZmvEIRbF7b8ta/4J6/6qtWsp78jS2DFzyBQMnMZNIVZekCVwxQCadLWQIZcYk7Y/ddb/tvnhBdDE57LHnrzFjpjSRRVZXnnUguKs6L7iEFpeqZHAHCCj/1zBLQ/3pQ9fBQrmL3ldXGNl3Fvk1kzA19VXG5Xfn4XSXm/ak/LMjzPBvq5n2TXRuesci6rzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ep1hd8PCSWXMeHK3SlKc7uLnq/EfAGcGCfE/AI5cNVs=;
 b=srRVNTRka8DkyxBsolXSK54Rtruu93djWXQcxndE9FtqwncKHRIezj5JKsneGh0aEbGcVx2HAEh9yWYbp+RvrqednRM2D+xb7dnUFEJLHgVH/kVrc49FDT3y6GM/u+8P4H7Q9+RkRm0YOXWCGFGPfYSRxja1PYLADbx/zLQ8+84=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SE3PR03MB10511.apcprd03.prod.outlook.com (2603:1096:101:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Mon, 20 Jul
 2026 09:13:48 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::38e4:3e0b:bb37:322e%6]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 09:13:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"liqiang01@kylinos.cn" <liqiang01@kylinos.cn>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
	<can.guo@oss.qualcomm.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/6] scsi: ufs: core: Validate string descriptors
Thread-Topic: [PATCH v2 1/6] scsi: ufs: core: Validate string descriptors
Thread-Index: AQHdFgKp63S6yK2J20Cycw+MZ6fJZ7Z2JB6A
Date: Mon, 20 Jul 2026 09:13:47 +0000
Message-ID: <111d73097067bf9f23c9bf18ac1b7db123c9c63b.camel@mediatek.com>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
	 <20260717153914.26321-1-liqiang01@kylinos.cn>
	 <20260717153914.26321-2-liqiang01@kylinos.cn>
In-Reply-To: <20260717153914.26321-2-liqiang01@kylinos.cn>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SE3PR03MB10511:EE_
x-ms-office365-filtering-correlation-id: d60bdf35-96bf-4f21-1dd5-08dee63f34f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003|3023799007;
x-microsoft-antispam-message-info: HKKfu+QOZk+zhxtjmFx8rLo3HBHUDzdvtSTXHMNKaaXp1qBugd15swO25Gt4uWtqWlxK24dmLlEg/MQepspcDr2yXlsPIAfDpyvD34fbxxUEIgR2JZp83bQptBRX3YXVTQ265/ifGTPQddMZL0mrF40ZyYu5QLHmhA5IFP/jmBUzIlhDw/7CHSCfX4OzaqFG6ljYp6RG+o/Lr7v2m35QhcD/ZhczkddCMWa49zLN/vcgX+kwy3eY6SXC8BqSjuliWxT7sHbEOVnSN7AFPl4apEvi8U5OkJR26KKsex97QxOlGtaSfYM5R8i9tyYzW09mkgEJe97013bCwjhK7gX/L/3yS+VLvVrogivbeY471cu02tv6LjQtPCWTuK7LvGW8HntuJtIHWgiMXbPhfyFGgJB8+LhZD7oFJzEv9IhYW5jqHgMMYWcZ+2PMG+BU8n4l+/j8+2QnmNZh1+49rvYXMcus3ct7CCHz0gds3bO2Q/4EjFAWODiiBlVO0U4mh3vfawN+JYetKLtNHq+oHVx0Vw+zxgZ22fVaBEvvV4fUIMnBlyg71CymU020g52KlihZAV0dsCGUG05PGcmPtdwXgAvJuhWlco3T9JvS4KvF+yegF/lPk4iKBP3phCVVwZqbX5GD9SOM8YI5jtpQP+qAuk32onU/r3jlQ57+k6mb4a+hoRZsFxSBw029dmy+ng5F+U9/Yfqqo8InIRjdnOG/oRLl62TvLlyYZvfoZtujNDY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzFwUWFJS05nOTlBbDN4U2ViYktJd2tkVU9YenlIaXRIY0tNbERvOExQU1Zn?=
 =?utf-8?B?WTBzOGxsNUpVaFhmd2xiOXNhTlZhZElTamsrT1ZLTTAyZzd0NUdSSjNjc1lO?=
 =?utf-8?B?VE1YbFpkTitreFd6ZEE2d29uVmc4M05kaVlmSW94QXVqMWgwMHlhWmkwcHBh?=
 =?utf-8?B?RGhLYVk1by9KSTM4MlZpaVA2MUIxRDI4VTNXS3VkcUZyUE5ac2ZUQUtxcEdT?=
 =?utf-8?B?TDlkcUFuNGVQVTQxY0hLcjltVDVrQnhzMGJ0MTA0d0VDdEtnY1ZvN3pwVUV2?=
 =?utf-8?B?TXBMZFprYnNIVEIvQWlVWHVYbFpQMEhFYm4rMEVHMHU2YXZWYWM0R3VYSisz?=
 =?utf-8?B?aTJEbU9DSkRtUzNXN3dpRjJEL0haRDI1aG1IYVh3SStocEVwNWM5Z0xrMGli?=
 =?utf-8?B?b2tkZzQwQ0xRczFVYkZuRVRrOFdGSVA1STNvakI4Y04xTDZuQmllb2ZFSUIw?=
 =?utf-8?B?TTZnMFZEWVEweXlIVWR5WTlDWjJoNGN0UmtDTGhZaFRUUG9ZeVhnN0gzYm04?=
 =?utf-8?B?b1k0MGdQVG1lTTRWOTlCOEd4Q0tVZmQ5WjdZWnZMK1J2QTgzUGMrR2R1QUV2?=
 =?utf-8?B?Q0k4N3hQWWRnbk1zWm5jWUQ2aGoxM05MZVRMYnl5MEx0a1AyOUp0aGg2Mm9x?=
 =?utf-8?B?QTBLYk4xODVKM0YzNjY1aVljUXJHaFlubkVMNkVhcUhLaGZkZzZ5cjErbHhI?=
 =?utf-8?B?QkFRRDQ5NU9Eb3VTbFdxV2xlckp2UFhCZ29aaEVaTlRFblZwZVpiVSt4NURJ?=
 =?utf-8?B?RDd6UkRrSWtQZ010TzBlYkdqVlFLM3U3NXZOcHBjUXZrbWd1R0I1WTVycXUv?=
 =?utf-8?B?SUFDZEsrM1kwcmNaZ1JISTF2L2FBaFpXLzl5Mk93MXhreXFKdWhzTjcwQjMr?=
 =?utf-8?B?NDdOcVIwK21laUVYays1ankwVVNwZlRMclJuWkZibjIvckZYbjZVVi9OUk9N?=
 =?utf-8?B?N2VqOWdxTjhIdW1wa2tLcTl0eEpublgwNGtBSFVyRHBjVGdkSGlGd1RZQm9O?=
 =?utf-8?B?SHlJeFozR0lNWnFCckY0dngxVDJPLzRHV3FmVUNrT3hqUTFhN0tEblVCL29X?=
 =?utf-8?B?MWZJMTNFdGFBT2pDTnRucFRiZ3hCRDI1YllYWmt6UFpqMjJaZm5aeW1NTjBW?=
 =?utf-8?B?NkJKYW9mWE9rUjVlQytCOHptdTE1TkFZMTlSR0tabXZyb21sSkJxVGFqV1Nz?=
 =?utf-8?B?VVh6eVM3VG1GRGhubEZ6TWQxMHk5dGYyaVhmUzF5T2MybFhoOEZWRUlFYnkx?=
 =?utf-8?B?K0ZLSFpvSS9sUmUyMHJTTTY4ZjREdW1PTzBqcm5zY3A3a1V1TVpMeC84R1dK?=
 =?utf-8?B?WWRidUZxTGpDb2VON2dYNmhldS9FdmdwUWZOOWRWVXh5UGhVaFJwa2NXdGwz?=
 =?utf-8?B?cUowNXozbEh5eHRqVkNLZ0FzRElJbkNiQVhsVFhPaC9UMkF6aWRYRmU1UUpL?=
 =?utf-8?B?bXB2d0szVGE2cGFYNW85bUpIVDI5aWp1NCtPK01LTzg4aGJxOWdSRytMeEhU?=
 =?utf-8?B?dWtzWGNvNWtGL3R1MzJORXU0V3pTbEY0MEVsSGNPWFR1bUZEVGpCWmozUUdq?=
 =?utf-8?B?bm1idWhOOGc4ZmNmM2p6L210WWt1bDhYN0M0aUJxb2UrYzRZZVRoSFVnanVh?=
 =?utf-8?B?YVRRWWtoMEVEaDRsbUwzSXY4QkxyVmp1NlFpU3JEQk9vNUZmKzVra00vQk9m?=
 =?utf-8?B?Z1dGYUdDTWs3RXcxdjBWeGpya0c5NUU4VXpwZHRWdTRHWmFvVmovejI1c2dm?=
 =?utf-8?B?NTJYd0hsakV2WWFza1NTVTloOUl6VEhBTzJxbCtLcjZzUUtCeWl6YWVhSlM1?=
 =?utf-8?B?a0Q5R08rYUU4WjZGeUpvWHA0Q0ZCTDlPaldNekdRbXd1TTZ1WTR6bnpWamtC?=
 =?utf-8?B?VEFZcHBWVmdyeWdJUUhkVDZDZWczenN5MkE2ODVFbVRITEV5Y0VLbzB0dXdt?=
 =?utf-8?B?Z2xudFpyTFhlL1pEemhIL251OG4xTjEwVzU1UFA2Ynk4MEJybkNvK3NiNnh5?=
 =?utf-8?B?RVpSOHl6SjFHSjZiT1Fzditma09DQ3ZmdmIrV2NwQXl1dlB5bWJIK2xSWTY0?=
 =?utf-8?B?Q0R6ZFQ3bDRpenpQbEl1eEVnYnI1SnArOEFpNU8zWll5ZDdkZHZ1N1A4OWRN?=
 =?utf-8?B?cmdiWlpKazRFdXBqTEMwd2NtWUwwZ1FqanVqTVZVRU9ST3lsNGZXOERwcG1J?=
 =?utf-8?B?aHBHd3VKSS8xWGkyK3ljWWJtbXVGZlViVHBRWWtQaytyY3J3a0tOZ2VsOFdx?=
 =?utf-8?B?SVYzb1RrcHYvM2JWSUFOQXBxblVQYjYvWGQ3VmZhZHpkTTJhNWNUYWh0ZXM0?=
 =?utf-8?B?R1IySTBZekY5ajdwOWVqOG5sSjFidWdiNWVueEJUYWtiYVVPVkFqMzQ1OEVC?=
 =?utf-8?Q?iaJpfAzug8lP79J4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1DF59ECD6A96E4DB89168ED272ED62B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: H5pJT5l15dBrz3yyUEkoSlKnH462FPCWuygzi4l0xAqlikahaIXb9447F5qKIH1bZjC6/pi7Ze1w9/DeiAHjZk0E4V5pkHvW6YEobRXbH+zaM7fEliA9jxR4MUAGgS9DsL+Pn40PoPtXGSU08n/aAgSLmKYAdkcsNBOH9CMBtElBY67etmdoIXj9T4J+IvXm+0UE1hmmMHK2E5YIRhwkIf2O+SBZJ3BDyi5sqHlvbj5onGnNG0lHK6/4pClyl2nUlqHun3mAbQmyQinLvdJENA1XCB09niU3z57m9cHNluwaw+zLOvl9V1uEYzBdz1LaQf6/qBt66Nqz9ruE4dIf5g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60bdf35-96bf-4f21-1dd5-08dee63f34f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2026 09:13:47.8463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 29k8MzSOTlvOHDjuqMmhclccVvoMUA8tzfnKU72xzXGJfBtTZcJ66CEKuOvIzPW0ch1B9e2h5qlVTUNB8War3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB10511
X-MTK: N

T24gRnJpLCAyMDI2LTA3LTE3IGF0IDIzOjM5ICswODAwLCBMaSBRaWFuZyB3cm90ZToNCj4gVGhl
IHN0cmluZyBkZXNjcmlwdG9yIGxlbmd0aCBpbmNsdWRlcyBhIHR3by1ieXRlIGhlYWRlciB3aGls
ZSB0aGUNCj4gVVRGLTE2IHBheWxvYWQgc3RhcnRzIGFmdGVyIGl0LiB1dGYxNnNfdG9fdXRmOHMo
KSBleHBlY3RzIGEgY291bnQNCj4gb2YgVVRGLTE2IGNvZGUgdW5pdHMsIG5vdCBieXRlcy4gUGFz
c2luZyB0aGUgcGF5bG9hZCBieXRlIGNvdW50IGNhbg0KPiBtYWtlIGl0IHJlYWQgYmV5b25kIHRo
ZSBkZXNjcmlwdG9yIGJ1ZmZlci4NCj4gDQo+IFZhbGlkYXRlIHRoYXQgdGhlIHBheWxvYWQgaGFz
IGFuIGV2ZW4gYnl0ZSBjb3VudCwgcGFzcyBhIGNvZGUtdW5pdA0KPiBjb3VudCB0byB0aGUgY29u
dmVydGVyLCBhbmQgYWxsb2NhdGUgc3VmZmljaWVudCBVVEYtOCBvdXRwdXQgc3BhY2UuDQo+IA0K
PiBUaGUgcmF3IHN0cmluZyBidWZmZXIgc3RhcnRzIGFmdGVyIHRoZSBkZXNjcmlwdG9yIGhlYWRl
ciBidXQgaXRzIHNpemUNCj4gaXMgYkxlbmd0aC4gQ29weWluZyBiTGVuZ3RoIGJ5dGVzIGZyb20g
dGhhdCBwb2ludGVyIGNhbiByZWFkIGJleW9uZA0KPiB0aGUgcmVzcG9uc2UgYnVmZmVyLg0KPiAN
Cj4gQWxsb2NhdGUgYSB6ZXJvZWQgYkxlbmd0aC1zaXplZCBidWZmZXIgYW5kIGNvcHkgb25seSB0
aGUgVVRGLTE2DQo+IHBheWxvYWQuIFRoaXMgcHJlc2VydmVzIHRoZSByYXcgYnVmZmVyIHNpemUg
Y29uc3VtZWQgYnkgdGhlIFJQTUINCj4gZGV2aWNlLUlEIEFCSSB3aGlsZSBhdm9pZGluZyB0aGUg
b3ZlcnJlYWQuDQo+IA0KPiBGaXhlczogNGI4MjhmZTE1NmE2ICgic2NzaTogdWZzOiByZXZhbXAg
c3RyaW5nIGRlc2NyaXB0b3IgcmVhZGluZyIpDQo+IEZpeGVzOiBkNzk0YjQ5OWY5NDggKCJzY3Np
OiB1ZnM6IGNvcmU6IGZpeCBpbmNvcnJlY3QgYnVmZmVyDQo+IGR1cGxpY2F0aW9uIGluIHVmc2hj
ZF9yZWFkX3N0cmluZ19kZXNjKCkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBMaSBRaWFuZyA8bGlxaWFu
ZzAxQGt5bGlub3MuY24+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIu
d2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
