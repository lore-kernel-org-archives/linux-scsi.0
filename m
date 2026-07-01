Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D639EF32;
	Wed,  1 Jul 2026 06:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782886310; cv=fail; b=t3kvxOHlMD3Ued1Nkdo494BWvygvQ5ev17l7uD8coYBdKF+/QL77rkyHGv6BFEhQVg4HFoAAV19Xq5IS54TasTNNlthueCrKAf2xRD0pzxt07aKVGWYU5NIY7O7pP/VWNizrbvhjV0r6NJEhq7M+HK5b9jXb0gpI/OHB0gB6GYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782886310; c=relaxed/simple;
	bh=mXpkSCXOdqBvGiRLdiJCrbEM/kNyWX2OVMfaL2EDeW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X3aM78FeUY5RpzYyEs+MBgLKj7wpLVCqtRdqUmK7RxDtlZVmZbQ0C7a+AjIeFCIApQNbR1H9IXoDpPDJpkxWwD3TEOjz/A8lMRDd+MtEVtREGVoIYwtxk20DYuq17Uv3uQzn8wK2B6Khm8U2+8QhbB2nNr9/on/jxacmaPYxy44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pu0GHJUO; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=h0y10jiz; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pu0GHJUO";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="h0y10jiz"
X-UUID: ba40cf32751311f1b1788b6acf885367-20260701
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mXpkSCXOdqBvGiRLdiJCrbEM/kNyWX2OVMfaL2EDeW4=;
	b=pu0GHJUOpb0YNWZL5DeD1lpjzaoQn+J5AtJpb2sEjH5gpHBeToVEdDVjeCS4U2ekkRC8Fc8NwyypX9RNgX589LKhA50MREudEsQdBrqesit/c13FSW/AZeFYBLsq3hLbLu+VH5LENKV3SFTOJ+30BmN25BDs9+RU8w+ZnJU9c3I=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:940d7fc3-d836-45f1-8339-f632ea194451,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:c13aad0b-cc5c-4c79-a965-86c83a4d1523,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ba40cf32751311f1b1788b6acf885367-20260701
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 395962245; Wed, 01 Jul 2026 14:11:41 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 1 Jul 2026 14:11:40 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 1 Jul 2026 14:11:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KvOLwrkRt4CI5cIkAPjasEv7uJP4iNLFO5mfwRYYCq80A13mVXbG5GahbD4vUMm5/3z0XYHe6lIZz0KQi5ExjkZhiPZO1OMHM5V1bpt6CurxG6JkOoVIjz2zssauK3xdUe9EFMVgt3Rm3jjt/OQNzwOVX3ji/60Q/WxpZq+spEVaAyVaatJFNXhZ4q8HVpPUeVPpLGGn084vCdzJcAbBUsQ0xKUk+hpNDOZOAnxnQQARSl8Kxmw9ZODpqyEFkElVhfzOnkLooOBWTB+ieHlpK8gSL23HgXWRGZlAKmfiSv4weHhJZb+Vhsfsn0pejyKy6vgr7LxNDtw1W1H/fYSMnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXpkSCXOdqBvGiRLdiJCrbEM/kNyWX2OVMfaL2EDeW4=;
 b=sSJQwB+JWEjCH1ZJDTT4TeApyPMNUP6yPpSSUDg2WIRDwrlReanniciLVrxM21KBLpS855RIl0HHx0r06/niYpr/Wy9l5Ev/I0wHawcd0/mWHahxriNVy8xY5VYlbI+ML7T7gz9FN6fbrlUO6adLwwtzkII3yfSr4vXFgKdM3bfxuWun69D6zeSON1aR+3u5bISAo3ejvO/he3ek9sQ29t+LcmnKsOK3qqlo51H9TDzs5S5JV/OG73eCDapa7Z0k/bbGNCbc0et530sU5zBZvOcJTriUF8nC6rFOWbxB6UwxF/QwxNrqmpuSawCOM/QJRXqnnmHodegBaebZQ3vfEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXpkSCXOdqBvGiRLdiJCrbEM/kNyWX2OVMfaL2EDeW4=;
 b=h0y10jizFTER5xLNNC4LSpnaeKmhZWaXzgaUApsDD6DUcn1utzY2DeBNYE+7UWTJGvkAfIqaP56TAlTLHgdOKqNQacDhEkddaBD0ZMRSYbyWt/uNRI9053qW3tlVmH8isf3BMB0WDwi/ofGYbfRUR9XlS0Ve4zp6G7ZTTyybbTc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8275.apcprd03.prod.outlook.com (2603:1096:101:18e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 06:11:38 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 06:11:38 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?=
	<eddie.huang@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?=
	<jiajie.hao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
Thread-Topic: [PATCH v3] ufs: core: add hba parameter to trace events
Thread-Index: AQHdCNLi94hno+2a0EKBFGOrIXb6GLZXoxmAgACMM4A=
Date: Wed, 1 Jul 2026 06:11:37 +0000
Message-ID: <e4c090a5b8402fe3db137d986f9a6639de73cc67.camel@mediatek.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
	 <20260630165612.3e21b510@gandalf.local.home>
	 <20260630174949.16a9d867@gandalf.local.home>
In-Reply-To: <20260630174949.16a9d867@gandalf.local.home>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8275:EE_
x-ms-office365-filtering-correlation-id: e512a848-e6c3-4a24-b510-08ded7379c59
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|4143699003|56012099006|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: t+cnSvW6QuqcdiWNWp3Peyn80ILIiosoezyy2jANP4v2ccj9mogsMulhmPMh8ORlaDb3oeY35J0K3wGyx4NluNs40FiCoSsd5xwmWi3IxPRb4mh4U5w+Ps1KEQTA4RyhXjSxD9MD5S3q08FtclqCdh/rzsD1CMMvIQbnxbJ8iowbY9NTLwEAMLlZ8KKp7jQT3ZjrjH9m3C40+nsaHVji9x8ttDM2ZzzKW3p+R/RayxymAAGeHi5y0jf8Xx1gxJDBUsHVzyTHtKL8Pz/j3THFEm5BnrRRrc66ZrBVqGQKg5kGVICaMoH9jhWt6EfXu8LtvbwFKbc8dY5d02lboj+vU4DW3qidHqazC2KRNIlPT/qzjY9csQcfII7oXO//phDJmcW8jjs3+ER4qunt3gI56Lr/0CfSJMOs/3BEEbH+E8WP7shFZyU8T+shHq56dVxbM7cmeTDXdag/ZuRldb1xIIK4GZgVbo+R0MHkmgPFiTZfE1O2ILovkjyWwLdOg9oznCuhSQaUN2ReDpIhjFBzIbl/hqdfAEUKtV+hILbUPa2pZYUXLrWdSswEvc9aM5Lq8lJry3jPbhBiWiVKfRhgFFQO9LMxJApT06B1k0S+6pM5DyqQ7o5iHCMbhAmA4Hj8LbgcvquWJcnpQ9gFctH1DnJyI/rmEvK+oa6Asz8hF9XU6kXo661CNBybVVZHyQSWJpGIUXDx8arQ+bTEoj0bLkM86V+RsorS4zF9Q0S9PsA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkNyOGxJdjZGRDB2a2dObDNZTnhhNU9BNzZoNXlaTUhGWStyZ3ZJcHQ2MFpM?=
 =?utf-8?B?VGhka1Q5WnZFb2ZucDZ3blpBalBmZGNJbmtxK25TenkzSkRTbHJvKzdudTFs?=
 =?utf-8?B?TFJsUXkzWEJpcnBNSGJrblVWb0Rua1ZSbWtnMnBWbFkvRC9SQld4bUh3K1B0?=
 =?utf-8?B?WWRTamVQS1FQa21DZEkzaXRSMG9uUDcwUVZNcWRBc3FPamptTzN1MG5UVndB?=
 =?utf-8?B?Q3FBdEFZOERiemlsc1l4SEJjK3VlT040dk1GNjZPU0ZXK09SQjdxV3ZUR3RQ?=
 =?utf-8?B?Q3ZVVU1oeFNUcVV6ZXl3VzBsdDFXRHFVemNibU5NQzFNS1JwOGFZK0FsR1B1?=
 =?utf-8?B?bWZLM3lpNXNVRndrTFN3OWpLTTAyYTM1Z2dPbDRMVDN1L0ZIZ0FTUzR5TEE4?=
 =?utf-8?B?QnNlMlNiRndxeThKdmg5ZGJENVhtZFkyeTBBSjNRSzBRZHJLUUJZMzdvckJK?=
 =?utf-8?B?MXUwdFcwQjR6K1owZlhnb1Z2SmdJaUJjQjFSckM2cTBRakJVNEtibVozNkNZ?=
 =?utf-8?B?SVcxVG1ETHMrQTBtUmkzUmNoQUY1UmY1ZTJnVlRpUFlRYlVoeXltbGlCc0J2?=
 =?utf-8?B?K0NCOHFPbEh5V2FOYVo1U0ZrM1lmK0g2Y2tBdC8zbzZOeHVrM2krUHl2VGh2?=
 =?utf-8?B?b0pHZlJMUzJ1aWxMRjVNZFd3K1BjWFZQM1kzMUJnMGxIenNnazlkYWtkWTgr?=
 =?utf-8?B?SVVkUE5mcGRNMW5GN04yZnVkVUNGdklVQWprZ0x5NlllK0tZbmFzUjA0eUgz?=
 =?utf-8?B?OERGVXZodTJlNFBjTnk1RHJKeE16dXdaOVQ4MElkLzllcXdjTGZISTArMHBY?=
 =?utf-8?B?bTVRdVZaSUVibzVHUm1EM3N5OC85bDY0QWJ4OTZJWVN2cWg3KzdBRWQyYU0w?=
 =?utf-8?B?VWJrcTZjUmdXWkRXK0lkMUhDM3R4SkhYM3RYOUt0dit1N1RIUlZCbzRuK1gy?=
 =?utf-8?B?bkcwT25EVElTakFqakt2VXpDQXRzUit3YWdoT3Rza0dsNHpIbmkwdXJpMXZy?=
 =?utf-8?B?a1ExYVczaWNPWHVKTjE1aEZqUHM1VjVoTkE1dVUxZTMzMTZ3OU9KZ0k4TFpy?=
 =?utf-8?B?Mi8xY0xEdXRVcW0ydVE5VEVscytwVkdyc2Z4TUlRRWd4Mlp1ckl2dktwSjR3?=
 =?utf-8?B?TExMTUoreEpGcSs1bzBqNmJxZjlLbUEzQ1BjdUFVb3BrNFZvNkMvb0VmWVRC?=
 =?utf-8?B?MlVYeHFJUjhxaVlkY2Z1NVo4K3lINVJtTVQ5MmFJaGlwdWQzd3pvSFQyWEVK?=
 =?utf-8?B?eGprK3l2bnFFTk9xeHdDZmVkSXQxcnE5WlpoR2pWTExvVGJhcHRZT002WW5a?=
 =?utf-8?B?M3ZzeWV4akdyUVFkdml0RkIwZUpmU04rcTkwUnZEMjRYME4yRUJtSTJrSTUz?=
 =?utf-8?B?VzJyMFRhcnI4ZG5SZDR5TG1VOXdTSlBPYSthb3FpOEZacnQ3ZnJQRkF1T0ZW?=
 =?utf-8?B?Zm1FWTQrQ2NjVDZxWnRLREVvelIvYVBiSzlpRUxlZ3dBWmlGSDhLTkhRUjg5?=
 =?utf-8?B?SU9ZcFlxMVhuWEYyc2VpdGdBMWhVeEZJTm5DdG5XeTdPMTlHTDY1ZjBzSlFv?=
 =?utf-8?B?b0lVM3oyb1lFazRTQjdMRVMrWGsvY0l2Rzkrd2xmTllYajNqcXpJb1c4VWFr?=
 =?utf-8?B?YWRPa2Nkd0d5c1RSVWpTbml1SHRway9idHFXcFViVitTOHdtN2twY1VnRTVt?=
 =?utf-8?B?TXRYUkQwWWdCSDJDNHVuQ29zdkNHWk4rQ294aVhlTEwwR3BMdzVyQ1JlQy9o?=
 =?utf-8?B?TUVPNXJMTUE5d0RISUZNZURzNDUvSEtCMStDQnpqNHFPYUozejB0SGRCVjFM?=
 =?utf-8?B?bUpKNk1FWG4rSzZlUGk1MDFoS2I1ZHVCZmpMNUFzWHl4L2RTaVBoOUxZdS9z?=
 =?utf-8?B?NGZoaG91Tnc4RS9kVkhhRnBVSzZ1aWRmWjRibVNVeXpiSmxjckZqNHcwbEM0?=
 =?utf-8?B?ZStZbkR4YW1IU1V0Q2FYNGlVZnE2TzdBWjgxc05raXFOWC9RcXB6RGlONWZl?=
 =?utf-8?B?czNGY29FZUJhSm5oQWs5Vm1rR3hXdHlDQ3FhTnNadk0xdGNkclRlSG1TRE8r?=
 =?utf-8?B?aG9uU3VKdDNOZTR5V2h2UEU5YkJDM0NjQkJ5QVI0WGZZbllmOWNDYThaQ2xn?=
 =?utf-8?B?TDExVTMwczB3eW5EWU1qRzNFMnI5UXZWdElhTTVqVnN4bGplMncwNFVZeVBZ?=
 =?utf-8?B?bEFuNjJya2x2YUQyRnR1WmNvakh0aUJILzZ0dmZKN2MxWWRvb0drd1pGNVpW?=
 =?utf-8?B?MjlLOUplVDM2T254QVpwaXNMMFZTVEJvdHlZNzNzbXlvNC85TFJDcjBlWGY4?=
 =?utf-8?B?MjA1UkJ3SlFXVTgxOWl5ZDJuWllCZUpIdkZQb3BteUd5R1ZEdjFDQ3VNRnpP?=
 =?utf-8?Q?XJlJRTjR+MNi3U9k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B097B5C48F0B5E4C802E74DBDCCF3DE2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mhSyU6zevgJbygpIyNfMeEKPavwMzPXzU9MLCx7PQBtePQvR77MLeJaPWw6SBoQ4LwixPJ8KfhHHOqLQ46ShOHN8Bbc6J1/he/rRnl+M7r+Q/UyYsuycC6z0kecPvGmztXwnh6WA18q+LZ7VWguEU8NPJhrgEh2jjw/K4Vz29inI+twl4wSMOCP6GRDmRavcEbCqGrj5v2u54RORS2yHdVbwX71eYXN7dUupE8d7iDRwVpdYwIwCbu6vC5L+4UFrrGe/0dXgWLelIs68zShnyWvk7Pcfb+cqmeZO/zoNfm599iABlmIQAki95zU8Bt25KzmEB4u+1vm68NCIAbKA9g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e512a848-e6c3-4a24-b510-08ded7379c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2026 06:11:37.9252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5emJ9pIOuXNaqkUr1aGGv1ckWd5KXWMiVHbXqkX41GGiNPMbIdJFgdna5wNYwRx4EZefzyOa2Z6YI/oYiolVtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8275
X-MTK: N

T24gVHVlLCAyMDI2LTA2LTMwIGF0IDE3OjQ5IC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToN
Cj4gT24gVHVlLCAzMCBKdW4gMjAyNiAxNjo1NjoxMiAtMDQwMA0KPiBTdGV2ZW4gUm9zdGVkdCA8
cm9zdGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+IA0KPiA+ID4gDQo+ID4gPiDCoMKgwqAgVFBf
cHJpbnRrKCIlczogZ2F0aW5nIHN0YXRlIGNoYW5nZWQgdG8gJXMiLA0KPiA+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgIF9fZ2V0X3N0cihkZXZfbmFtZSksDQo+ID4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqAgZGV2X25hbWUoX19lbnRyeS0+aGJhLT5kZXYpLA0KPiA+IA0KPiA+IE5PIFlPVSBDQU4g
Tk9UIERPIFRISVMhISEhDQo+IA0KPiBUaGlzIGlzIHdoeSB5b3Ugc2hvdWxkIGFsd2F5cyBDYw0K
PiBsaW51eC10cmFjZS1rZXJuZWxAdmdlci5rZXJuZWwub3JnwqBvbiBhbnkNCj4gdHJhY2UgZXZl
bnQgdXBkYXRlcy4gV2UgbG9vayB0byBjYXRjaCBidWdzIGxpa2UgdGhpcy4NCj4gDQo+IFRoZSBi
ZWxvdyBwYXRjaCBzaG91bGQgZml4IGl0LCBhbmQgSSdsbCBzZW5kIGl0IGFzIGEgcHJvcGVyIHBh
dGNoDQo+IHNvb246DQoNCkhpIFN0ZXZlbiwNCg0KVGhhbmsgeW91IGZvciB0aGUgcmVtaW5kZXIg
YW5kIGZvciBmaXhpbmcgdGhpcyBidWcuDQpUaGlzIHdhcyBpbmRlZWQgbm90IHRob3JvdWdobHkg
Y29uc2lkZXJlZC4NCg0KSG93ZXZlciwgSSBhbSBjdXJpb3VzOiBpZiB0aGUgSEJBIGlzIHJlbW92
ZWQsIGltcGx5aW5nIHRoYXQgdGhlIA0Kc3RvcmFnZSB3b3VsZCBiZWNvbWUgdW51c2FibGUsIG1p
Z2h0IHRoZSBzeXN0ZW0gZW5jb3VudGVyIGFuIA0KSS9PIGhhbmcgb3Igc2h1dGRvd24sIHBvdGVu
dGlhbGx5IHByZXZlbnRpbmcgaXRzIGRldGVjdGlvbj8gDQpQZXJoYXBzIGl0J3MgYSB0aGVvcmV0
aWNhbCBpc3N1ZSB0aGF0IHdvdWxkIG5vdCBtYW5pZmVzdCANCmluIGEgcmVhbC13b3JsZCBzaXR1
YXRpb24/DQoNClRoYW5rcw0KUGV0ZXINCg0KDQo=
