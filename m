Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C213242A4;
	Wed, 10 Dec 2025 12:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765369782; cv=fail; b=mS+kK8V7KvN14QpCJB47kqu1CkOf8/zzDW/UrW3ndTtxuhb8QbSrdAgl2qXRdqlifltkk1n+z/uFHadoW1U2gdfeMBglcTkPFN/xRs3woAS3BuzpGkO/Hrj8Q+EaT8hPvD48MvlqJTyNi/Nisa0mQ40vdUE3fVqcabriSdP1mKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765369782; c=relaxed/simple;
	bh=3DWVMGKVypYMRhNzjnh6ib59QWEn7aYYftMNAjiBrZU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HhGoxtEyzWbeQPdl/QXgMa25V7nH/Xz/GQUoc5g4XjcvLCkwWqpVCkGhmp4Bz91RRs4t3H4M24TxexygPBXmbIZyVFbgySv6t+8dY1YzJVCArRoWZIAOWvOu5Q2fOP41OOphIiqZPBXVhGQaFNgIzWB7MFkMjghDjqTb30ZY4z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bDpz+K84; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OJqqfJ8/; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bDpz+K84";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OJqqfJ8/"
X-UUID: e2c16628d5c311f0b2bf0b349165d6e0-20251210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3DWVMGKVypYMRhNzjnh6ib59QWEn7aYYftMNAjiBrZU=;
	b=bDpz+K849LzYtz5H5MJwgQPBv3BuoZmZ93l/uamwCDZ+rKwTsJRKUOirTjgRcF+Qb8MK2f62i45p+yI8Ya7MjAiMLsjtJ8RGwGeV18K6uksmuQVRG9gawPpYzR53WWcs5f2TXZRdQiydlZzftNajCa0+9TQcNgfF0j06E154phA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:00f78353-4685-45d1-b4f0-9031bd15436e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:d2739e02-1fa9-44eb-b231-4afc61466396,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e2c16628d5c311f0b2bf0b349165d6e0-20251210
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1676986641; Wed, 10 Dec 2025 20:29:34 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 10 Dec 2025 20:29:33 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 10 Dec 2025 20:29:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=si+bgq5jmkkV6lXZ638wnW+/0o4KD5GQp6vX0yglJ7h6+CkOdo2Dp9YnEhJKEvVCq01pm9czjpSo+oG32n9dui3PlizQte9Jah3k2RS0vdjcP6q5JoqOKgY+tEUea6EsdOZDXdHh4jAdMGhfJYtyZQu9Oi1KCFDk5Cy0f4dOHhibBF09/kLMTgQQllqAovFhSMnVNiFduJFvwQJcTT+NBGdAont+QFImHCLMVlKq/zuxahK/9pa3F6A7UBJMDtlIqWpoHBc2lF86bleOzcHE2gh81FgUNKW8NYlRSsU3d2e7qi29pCAfjfNZqUXP6CpNSzTJPSDVXZJtIVKitUSkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DWVMGKVypYMRhNzjnh6ib59QWEn7aYYftMNAjiBrZU=;
 b=PYJ1wCPXipdYNdWFS+laTY2LLh8L41MmsvLPTOEX0Pxjf9Mqd2YnTbRpogf6HZpRxb4Yr17JN4kh+Xec5cjWrF/m7eeCe9OULeMC2Kp4e/3yNQDmjOuyMWivxSCu82Phwjy2RQKRRwICvjY9VKJwsQ2oqePzpZfKPhdS+7E7GuC/FRWho1UDcm6ImNt3J7scBf3c15lyHQJiUnqPU6CKnPUAkJVX1HwAb5tcvuIkPZZu94BIKtEbqVCCuRPjYhbpBp6aY+MuSuovnzYesuYQfCjLzLcu6DwUB7iZv9q673Ud12+C8ksptM0GADz6lRLwiWscFX1F/cqKtSmZVy1AZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3DWVMGKVypYMRhNzjnh6ib59QWEn7aYYftMNAjiBrZU=;
 b=OJqqfJ8/lJIgxtEVsFToTRGWOAeRewjiuXhAM5MqAcnO4VTnRPAw0RYV4ysnv8xZ4R/zEK1Q2vGaeGY/nN96VaCi8+7wagU2ICfSznBdmqTj5F4jl7gqMyEca70RYH3xkYk51tzJXwj9uU9du+iq0wbbNnB/RCvzLuypoxA1t0s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB8605.apcprd03.prod.outlook.com (2603:1096:101:236::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 12:29:30 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 12:29:30 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "sh8267.baek@samsung.com"
	<sh8267.baek@samsung.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs : core: Add ufshcd_update_evt_hist for
 ufs suspend error.
Thread-Topic: [PATCH v1 1/1] scsi: ufs : core: Add ufshcd_update_evt_hist for
 ufs suspend error.
Thread-Index: AQHcaZ/AMing6tlFIUWUEXpG2aATxLUazgKA
Date: Wed, 10 Dec 2025 12:29:30 +0000
Message-ID: <d7bc09259668d17daa0aca4b8258a2c33a643eb4.camel@mediatek.com>
References: <20251210063854.1483899-1-sh8267.baek@samsung.com>
	 <CGME20251210063902epcas1p3651acbf49d4f8c456d4f3419f4649371@epcas1p3.samsung.com>
	 <20251210063854.1483899-2-sh8267.baek@samsung.com>
In-Reply-To: <20251210063854.1483899-2-sh8267.baek@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB8605:EE_
x-ms-office365-filtering-correlation-id: 1bff019c-ecaa-4541-1c84-08de37e7c460
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ejFSejBsby8vREdITjI5OHF1THpNTVdtT1ByUHBlZzVPbmZmTThZOEMxcUVp?=
 =?utf-8?B?M3ZUcTdLZnNTbkhwNndORDZWMklObm5JbDc4TW1tRjZmb2paUEQ3TjQrZU1T?=
 =?utf-8?B?NDNWSU4waGNZcmJ3OHVlRGdyc1RHelpwOWZoejFBeG5ianpYU0c5NWd2OFZl?=
 =?utf-8?B?VVFJWnZKUCtmakJBZG5GRUVOanduN3V5UWhQR1MwS0ZSdGEvNEVqVTZrcmNR?=
 =?utf-8?B?dTJHVDdndTA4V2FTbUdkQi9wWm41aFMwcTE2dGtxRlRaT3c0aFpPK3c4NndG?=
 =?utf-8?B?aXpyNndLTGJSSzF1Y2hDVzA4NnZwQ21udTZlY3lQZjIwb0NiZzY2Y1lqZHk4?=
 =?utf-8?B?ZjFPOFVENVg5N2hQc1FwalBQTXVQQ2NaK3VBT1k0a201ZURPUUtkOWZBZ1lU?=
 =?utf-8?B?Qm1od3RtV0x0ekJpODBCN21mZVR6VWF1ZzVmeTBDeVNSWWIyK0hSMFd1cFBx?=
 =?utf-8?B?YlJjWTFYcklEQ0tuYmRLS2Y0K2tBWC96TmFCcWdIWUI2K3BqUzltd3NyUDVq?=
 =?utf-8?B?eldvUmxmZlY4UlNwMlVoNXlYMWVya0VWcGNXMGlHRnZLYnIrcjlYTmwrNjR4?=
 =?utf-8?B?dlg4d3d1aEFsZi94emRkY1cwMWFiRXVsVWhpcWlaeEpMSVd2QUFoQU5xejhU?=
 =?utf-8?B?MHgvUUVrbkVxRk5WWXRKdk9YbkFwYW95ZWNTQ3RjbzN4elVEUzVpT2pJcmdl?=
 =?utf-8?B?aGl0cUhrM3FPc3I0c1pRNFNzOFl1b1dzakc0cEVRRUlKbXpKeEl4aW9qVDlx?=
 =?utf-8?B?cjRnWFJ1VjMrSzl2VkRrWk8zMTA3R3pUUVhjWWxiWnZwbWp4bUxGeUxHN2xW?=
 =?utf-8?B?M2tuVjk3c3g4c1JyT3h6bkNSMjZJZUV4NVpycXVUaGVKeVZKSzVxZUlRT0Nk?=
 =?utf-8?B?anJCdGZEVXNkU01ra3VVOFRWT3EvKzFjSnVKR0Q4bjZGMUNvQjNFNE93U3JT?=
 =?utf-8?B?dC9NZENJbWloakd3Q0hoTUIwOHUvVDlWMnhWU0JsZ1ZqNmdlSTZFZ0hmUlhp?=
 =?utf-8?B?THIyMnRXTG9aQk14djU0ZDlaTzRmbWQ3NmFuRlpqQm51ZmZnQmU0YkJibHdC?=
 =?utf-8?B?N0M1eXRLQmJmRVdMQUZiUmhhZmlIS0hFVkREL0ptVmNsQjlOY3E5T3A5bFpE?=
 =?utf-8?B?U1M3dVZ6czBrNWlGdFVsSUR5R0NKR1FQQlltUGVSVGpxNzFNak5Db3liNnpl?=
 =?utf-8?B?Ti9sM1htMWR4V1JnTmVSNk9kR0N0bW4zVVk5U1M4R2N3ZFRTeEZuTU4yVno0?=
 =?utf-8?B?TWNzTE5RU3FRbHRSSTI4YVFmUE9IdzRyYnk5bEJFd0VxNGJ5Z3VNNzI2R2NG?=
 =?utf-8?B?TUE0Q0RHSlRMbU5oYmgxd1VxZE9qZzJvblVRTXl3d2J6OUZacjE5QS9WVHRi?=
 =?utf-8?B?OUxuUjV5bVA0WGRXUFR2RzJEOGxJWGIwckZocGdOVEpjRjRMWWI3MjhSbDdj?=
 =?utf-8?B?bE03UmtCQjY0dW1qYytwcEZoZHZhRVlHZ0JwYklQNmVSWkVkRmQ3SDhNeVA3?=
 =?utf-8?B?Nm92RHIvRW16bjlXSElQQlJNUlF3S1MrOUpyTC84MGZXd1Bkb21zemFCOVFQ?=
 =?utf-8?B?ZSszdDlPN2xrLzdiZWVpNHE0ZW1TczU5aUo3dlNqRHRjTDVwMzQ4dWtwMkpp?=
 =?utf-8?B?YXE0UEY1VzVNdzIyOUpqTTlPNFU1UGZuZWhCeVp6VVErMU1lVlpCcnJVRk9a?=
 =?utf-8?B?TVJ1emtZNUUydkZ4NnhCaXIxUm9DOW1yV1pSWnNTNkJyczBHQzV6dU1OSGky?=
 =?utf-8?B?NG1sdlpEa2RiVkM2aVZobFlJMjFhR21wRi9Dc3pXMTJpT3JqOVd0WTBocVNy?=
 =?utf-8?B?ZS9ES1VnbHZuNlVHczhQeWVEOTFkZmZEbXVFWWgxSnRDL0FiWUthNUNlbkxY?=
 =?utf-8?B?VkNOWnZpUTNHTm5QdDdHMEtXWGk1cWRYKzBkVVZjbmZpN25LWHNyZExrWGxD?=
 =?utf-8?B?b0M2Slo2OTVZN1AwSFFGYngydHFaa1I0WVZoZEVrM3VXS0lXOU1jZnlqanFO?=
 =?utf-8?B?dmNDZU1IdDRLYm9oVjVNTkxiS1JkeGFGTWM0Mnd5VE03dVhtWk9yVUxUTGhz?=
 =?utf-8?Q?IHd/C1?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnNUeUFlQlMxdjNmZU1DeEUxWTVpQ3JLbElHaFdDYjBjY2V4QzkrN0xDcWpT?=
 =?utf-8?B?S3JQYlJJUzkyU3g4L1o1cWxVd0ZuN0toR1hHcmU3MnBseGJKcUluZEQyZFlF?=
 =?utf-8?B?S214blJ1VElkM2NjeEVUbWpRYVgxdXlPRjZzNWFQa0dGczFKNjQwYStkUUtK?=
 =?utf-8?B?bVFhYmpsNE9PZnlwSEIyc21yamVncGM3L2xNQlQ4dy9VVnZDVGdtZlV3MGxX?=
 =?utf-8?B?Y1hoM2gwb1ZUWlc0YW5EUVlyN3lJWmZXbkVQLzNBQkl0YXkwOWx2bS9KbWFo?=
 =?utf-8?B?eXc1dkZjQ1pDckhiaEVzRk1kR2huQTVzd0l4MFFiNnIxS296SjlRVlVNcWlB?=
 =?utf-8?B?WlJvZEhEaGlscFdMYjVMUWdXc2NpYzI5VVRVM01IVllVVzM4bmtwWVc0N1d4?=
 =?utf-8?B?cUhUTTZZSEkvUnc1M0lNaG9jazVYS2J5WFpwNDZpMVRwK2VtRlFnMHhqTUtp?=
 =?utf-8?B?ZmZvR2EyUXhxdW8zcDNodzFaZ0pMMytkMXJyZ0hPcDBPcTVpcEVKNmU5aVFC?=
 =?utf-8?B?NHl4d2pYRjVOOFpucStFV2ZsckxPSy9oRmY3SmJvL2V0M1ZnckVSakZHS3pO?=
 =?utf-8?B?ZXpOZmdIdXBBOGNyTjRxaWVFdHJWcEV1T0FiTUk3Y0FpQ1p5VnI5c1pvYWg5?=
 =?utf-8?B?cHVSalVmcUtydllaTDA2c3dRbGJ3WlNIeitLeXNsNHdCUEhZeElmaEMwZldO?=
 =?utf-8?B?UU5KWHBVa2ZacEoxSUhsYmhCWXc5L0ZGUmdUZysvMUlQcDlMZGZHb2NSZUtJ?=
 =?utf-8?B?S1hhYjFUWURRNVYwcUZBS3VCbzUyNERvYXJoT2EraHN0SkdBdkQ4TzFLRWQ3?=
 =?utf-8?B?V2xpckZzdzBRUHNIamdPVW0xQW5aN3pCK0tYK0dMMS9RM2lHWEtTRUlJcE5N?=
 =?utf-8?B?VFhNTFFBL0NvN011OWh5ZExtL2ZkQ3RicGs2cGhaV0dmWi82TzZ4UDIwa0F5?=
 =?utf-8?B?QmRsSy9DVmxuWDNiUGZ0OXNvVVFZQXA4MkJmK0pYTGlWSGVLNktpSmtRQ05p?=
 =?utf-8?B?S3Y0MEEvUVBaK2Vva0YrcjBBSDByRWg0K0tqNTdjSHBZSDdTVS83c3VSeWdG?=
 =?utf-8?B?ZEZOZEpPOXJkaGk0U0p4dGE5WXJtV0hsM2ZhMVdkWXRIK1MvbHFpWFVYT0Ev?=
 =?utf-8?B?TzhOWjJ3aE8rOEphVlBBUUU0aitpbnFPRTROUXV6bHFzbUVMSVdXOTJ0b0Fp?=
 =?utf-8?B?RU9zQWdBZFB5enltb09jdVFjZlBmVjE5RENaMGgvbkRJTFpydys2R1gyR0w2?=
 =?utf-8?B?YThWOVR6WEYyRlhBbTlwVWlBZHR4YjBIRnczYy9aVFBkYXdBYmI1S1R5MEFX?=
 =?utf-8?B?bFF2bi9ySmdITUoyMDJYbW5NRDg2SFZldThmOCtBaFN6QzVBTGRoNXFHTzhp?=
 =?utf-8?B?bkRtRUtzOGhpN05PRU1lcWIvWjZrUS9KckxUVkc4SFlpOE96aEhCb3RUU0NJ?=
 =?utf-8?B?TUY1MTgvK1pUSnpXV2Z1VFBGenEyR3VaTnpNRi9ZNC9pVkpVWjVWYWhNOG12?=
 =?utf-8?B?dTdrUTQvck9ETW1ueGxtSm9vWjJFZUNrWUVrdVViSGY1dE1XSE14c2VDVU10?=
 =?utf-8?B?ZXpIemlJeDZzZlZLR2x4ZG9OTHdyYllEcFgwLzRicDAvM2ErSlJpd3FIM1RY?=
 =?utf-8?B?eUJWQWpwTUtzZUN4aTRIRjEyb2dJQkxBRlBwdU5ZdTNOa2hWdy9SR2lmVnY5?=
 =?utf-8?B?L1FSQm82dzRYSkRRR3JySlEwMk1hTkVpMExIek5Xb1BsaHF4enNobmhVUnNU?=
 =?utf-8?B?WGI3TzV2MTNZb084ZjYwS0hHN0tkYU5pQmtqSENMZ04vS0U2ZWlpRHpIU2Qz?=
 =?utf-8?B?NmRKMS9SenNQbFI3cXd3VnhjUnQwMWMwZmhRclJLWlQ0ZUJuQUpPYTRaSHZo?=
 =?utf-8?B?bU1GZVlTVVZGQllKTVNEMW50RStkVXFPT05LOEdpbVZIREFYQWMrTHhGVmR0?=
 =?utf-8?B?akdlR0gxVHZsY2VtRDl6MXM1ZllZM080MzlHLzU4NHBsbjN4U0VJekpRSURk?=
 =?utf-8?B?empJVU4zRW9QckxqNGY0YjdWVGV6TytQM28rWXBxMG5wNXd3ZHk1MkNsZi9h?=
 =?utf-8?B?OWIvbWNvQkxrcVlPcmQ2UjFxZlBKRjlpdXpVNjQ4Q3RqVW9EZmFQL0VMWFly?=
 =?utf-8?B?WUM3cS8xSWRwOTlTdHp6WjVkN3FhZ1V3N1h5RzdMLy84eTFuZHRNOFgwUGVT?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <915B7DCC46FC0E4A9B5B464B0FD21B4F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bff019c-ecaa-4541-1c84-08de37e7c460
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 12:29:30.4168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TJBfupFO6C1HxmGrRzy43SS6urqhGfq+7w/I/in4Gh+6qAbTGud7+7ah6tUGE6cGIp++xTTzAbn/EMSAftULkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB8605

T24gV2VkLCAyMDI1LTEyLTEwIGF0IDE1OjM4ICswOTAwLCBTZXVuZ2h3YW4gQmFlayB3cm90ZToN
Cj4gSWYgdGhlIHVmcyByZXN1bWUgZmFpbHMsIHRoZSBldmVudCBoaXN0b3J5IGlzIHVwZGF0ZWQg
aW4NCj4gdWZzaGNkX3Jlc3VtZSwNCj4gYnV0IHRoZXJlIGlzIG5vIGNvZGUgYW55d2hlcmUgdG8g
cmVjb3JkIHVmcyBzdXNwZW5kLiBUaGVyZWZvcmUsIGFkZA0KPiBjb2RlDQo+IHRvIHJlY29yZCB1
ZnMgc3VzcGVuZCBlcnJvciBldmVudCBoaXN0b3J5Lg0KPiANCj4gRml4ZXM6IGRkMTEzNzZiOWYx
YiAoInNjc2k6IHVmczogU3BsaXQgdGhlIGRyaXZlcnMvc2NzaS91ZnMNCj4gZGlyZWN0b3J5IikN
Cj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNldW5n
aHdhbiBCYWVrIDxzaDgyNjcuYmFla0BzYW1zdW5nLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo=
