Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9202C21E6;
	Tue, 23 Jun 2026 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205631; cv=fail; b=J+KbfBm41hllvRKfsB8oG4ByNnDOy4373eaNc6KpGyECqklAf3GtxCQ5i+x4LGMlG72wtlmfjQ7JPBemNmEcxN/ejyOxDya9rUuEBVt/hy6znV4DZL/gLuwITAhAUXQCejyrD+pcdMxv4y6WslZFahFiEVTi2RD1v2l4ylAxBls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205631; c=relaxed/simple;
	bh=kozEtsDk2j8ozzUkg8s9V1UaIjwfYi4REUrpog/4kdk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iQEdWna9E4XuT2wTNRUlxXnen0B3yrdea3+zmcDNNeb/01+zlp7ieCTD3TpcIP5kWV4wEm/ZhdTjIdtz++Re/JrnwM2fiOuJzO+DQ8xX2bV0a1H/YnSWLH/wtG2QDhp02CER0nWwphVmigcPAWO4pN5SzkkgK6Fbdwrti9Ohov4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=r4YK6zJ0; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=szsJeYTq; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r4YK6zJ0";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="szsJeYTq"
X-UUID: e69490f06ee211f1b1788b6acf885367-20260623
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=kozEtsDk2j8ozzUkg8s9V1UaIjwfYi4REUrpog/4kdk=;
	b=r4YK6zJ0cs8cLswynVAn4zjjMi3gFjBQTIM14Xnkho/ZdiIy3truaLDDKAt1Bjwp2Fy69eqmdXAKhTvpG6Aow8iqVC+v5nW68dpCXsXTA3ypYcc0NW6FzBPxx3dStP8HAfQB+qSBRJTJQ5qCtjguIgQL0dqi5ULAepv2Y/5Ea94=;
X-CID-CACHE: Type:Local,Time:202606231707+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:70aab4a8-f1d5-48c4-8674-b9dfcefd8766,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:e935b659-9619-491a-863b-e5563c012806,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|136|836|865|888|898,TC
	:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e69490f06ee211f1b1788b6acf885367-20260623
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1698515817; Tue, 23 Jun 2026 17:07:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 23 Jun 2026 17:07:02 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 23 Jun 2026 17:07:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vDzOuLl4ttyWIeU4gVBoK0lbW59mF+B/c8QsDTznC5NQdm48RVNha6lmEs8QPLyGxl5oHf2Wg8ufAuKAaxd5q4Q8HhOO3nUEdlF7qknFxXADKxT9zrjl2sxPYTS70SMRlXmVmjLVlKcJoHEuiU3fOXp7c7aK2Ej21S3mnhdWNrnmRkfmS0ccGhFlQGup9Mo6Jxw/umkkO57P0d2O0G3W93mqrBAm4W1Z2ArCccyXgcxlPUbPmDuKcQ7pUERjXhOIo8YhLgEh4jymvfNIHgeKXAJ7FugRa7USXsDjkOVqJioN1J/N3wlcqk4M65ycp50sayhg/EeZE5xDg9xrlRpiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kozEtsDk2j8ozzUkg8s9V1UaIjwfYi4REUrpog/4kdk=;
 b=POnReuwCuE79n8w2K0gjqkauX+Qo1oWT3flWw7B/VzhUHhYZ8HJxjE5BgK1Z19IDb5LOwz0SuiR5U1G9REfPAwrCYDWJSltPdcgFRNWpy6oVNUxMPGXF0FDY/DpvBxoglbXbZL6znoW4MvqZ8EhUe2UwYjefFW/B+3ZNFmxc2cG2Th5XNWtUqdDRAQ/qH+jrLNDHG7iDpzv07apG9mJnHfhaXgJuIr7JzVKzjVNtKFsEpO1pC8zCVK/+XMcHvFwjBZ1wKo3gyapVtwfyeD0KEnG+dMblW/egArDEyolnav8C2Bz7q/t2Hn40I/qnBk/GXe+N6gJh+B7J0z1jyn86Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kozEtsDk2j8ozzUkg8s9V1UaIjwfYi4REUrpog/4kdk=;
 b=szsJeYTqG/LyBZdvnqreFzvQ6Ciw+Z+NrzA7h7vUlEJWT7h41159onuS2XnHALFJUKLZSRknewqJaZoLVsOaWzy1If+WSTURBX7PTNUL9QDDqjpi6DGMzgMAU/S6W1/lssZt+i02ReVJZ3dYUYJVc+1wZ/IcNJFBWHKdY0OmBRw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6730.apcprd03.prod.outlook.com (2603:1096:4:1d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Tue, 23 Jun
 2026 09:06:59 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0159.007; Tue, 23 Jun 2026
 09:06:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
	<mani@kernel.org>, "can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] scsi: ufs: core: Always run tx_eqtr POST_CHANGE
 notify
Thread-Topic: [PATCH 3/3] scsi: ufs: core: Always run tx_eqtr POST_CHANGE
 notify
Thread-Index: AQHdAItnYTx0clUAO0Sha/sPho5sFbZL3jSA
Date: Tue, 23 Jun 2026 09:06:59 +0000
Message-ID: <6756c061948dbabcee037a7f37381a5d9110d972.camel@mediatek.com>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
	 <20260620080322.3765210-4-can.guo@oss.qualcomm.com>
In-Reply-To: <20260620080322.3765210-4-can.guo@oss.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6730:EE_
x-ms-office365-filtering-correlation-id: e535b1e4-7edd-42b2-21d7-08ded106c895
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|56012099006|4143699003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: twuUeNLR9HkCerpRFYLVhqf87d1wy8o09I4XrP4BIAFL12WdyzCxAHIBtpKkMEKyEmQys/uWGynceQOeMb/5m+0GCIFAv9BK5eQyCfYedl+9zdwkKW06Oj7o/TCkpFcavjWvmi61C1aDpsr2dGtSfWMuSkfRJj5KHwsTqwFmJC1zmY2Lc8Ov2uaYnGpzLjzf/YPLpmCPrrfo7isQHO5ffJHSsiug3VAb/KT0C+AJmPAMstyyC/d/dL/Xduz097vLzJ6ESMQ4Rtg4o9ZqssjIOhndDtsLTA14sJ+khTrxHM/BL9oS7nOXNRIiuDoYoswtdLMTVx7/OEbEyLm5f8dwavcALaeA+HD7bAK4h8pOVXfa4Hs4jvOkOTYaLvoCfsLFT3iwHVYdYImyMFxZtOBerJVtIzAjHzNNeHO/W7APIOrTbww/hHjzPyP+X2umVQ5Cd+NuzDfOHzLC7+XHMvA6+2hRJGG7tuOSdEcRD/xGOFMBC20so4S+nxS2ER0WT5Ci7gdYO7TL/23X7UGApi7w+zyfnjH3qdo1GBjNuZFM1nnAZ/mYh0p/gQbVA0qXikXbnDtCPSjfs0SNEZxqlqbpoiLNfw4wna5r/sTMIeHgGjP1wkRTsoFrSxao1ayT4ZgByZ+ajDhY+5vKR97C8JPrO+pHnzniC2JFNbpcI1NwaSLagYQ3ZB9Pp+SPmp/T3nGKRiNobdgJm83Mxksi5g+juBwQYj2r/EavaZdM541+UuI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlNWYk5HNmlxZWxZZXB5a2czWi82dDFoV0RrUnpacUFmdDZpTWVVVmRUZmpu?=
 =?utf-8?B?Q0w1anNKNlc4ZEoyNUtjWkhRY0ZuVTFlbWl4WVdPWlJlK01HUGRmUmZnK1Ny?=
 =?utf-8?B?VmRmNktvNEJUM01ubTArYW84NlU4cUp1YkZZL2NYMzFaWEo0dk8xRmZnTGV2?=
 =?utf-8?B?RjJrd1daVEpKZGxKN0hRU2orYUtMWTMzdGNNOEVMcWd4cTM0bEc3VlU4MXJP?=
 =?utf-8?B?RytSVjhaamEvYndvYXlrNDV6K1lxSGNxNGNZM0hYdWZGbDJDZEJRV0xYT1R4?=
 =?utf-8?B?Rm5XaGNlc1dlRUZSVlRBUks2Qkx6cUd4RFVzVTRjZC9KQW9rb0hFTmRBeDFP?=
 =?utf-8?B?VCtvbXBGSU5CYzVHRFBQNzFReDBYVU1pV0E3d3ZvSDdEYjRQUERXN293TjFj?=
 =?utf-8?B?ZzVtelVtR01JOG5HQzcrRXdoV0RZellGTUN0S01nVURoaUo1a28zei9FSXlF?=
 =?utf-8?B?Rm4yMnVrQXJjajhpQXZFaFErQ0NxUU9KL29CZU5FS2tiOVIxUXZjUDNzR0VF?=
 =?utf-8?B?cXRka2FnaS9RZ2FmeUhhU2k5TGkrM1oyR1Jhb2puVGUzUnJrWUh2UWgzMitj?=
 =?utf-8?B?a3BhdWduNldDZnJJb1htekR5SEF5VXgzWjYzVllOWTFSbFVVSUtiVGdvSXRO?=
 =?utf-8?B?S2I2NWtaZ0MzOGJsaGpkc25Uc2t1QWRRbktlVEl3YzNSVHN2WkpsQ2VJYVNy?=
 =?utf-8?B?R0RWVmk2KzhQOWNTT2xEZ2s0YzJ3TGlpN1d1aXViZE1KVS9UMjh1N3diUkRJ?=
 =?utf-8?B?T1IxTzM3RFRSbTRwbE9aZXI0QnJZcStaeC9OaEZpM0I1b3NzTGpHMGN6MWk4?=
 =?utf-8?B?c0xIbFZOTXl2OWJTZGV5UjJZTFovN2c2eXZoWm1MdzFMRUd4NVlLTjZhR3M0?=
 =?utf-8?B?RzZ4eE5JNmZTR0RDd0RrbXFlZXZ6QlpMR0NSUFFTWC9oUXVwcTdJeHdQbHRv?=
 =?utf-8?B?dUVYYS8rWmtKY00vT2hVQzF6eFZNaHhkbU9aQnlNQnc5UTJmU0IrQ25NMjlV?=
 =?utf-8?B?aHdBTDN6bnVxQkhiWVpWRHA3SFZNQnNEeXpCNjV6ajBmK3k3aEZNY3JSMXdv?=
 =?utf-8?B?NnFNSUZiYnVJcUpudWhEdVA3SWJKa284VEI5QzkxSEQ1TzR3aEZDQ2pwYW1a?=
 =?utf-8?B?RUpLUzRLUU9WbnlDc0IyN1lxUEpCVnhVL3FBbCs5N0dleXVzT3pncC85RmlT?=
 =?utf-8?B?RHBFSnRJNWxubm9IbXBvL2pJcDBVelQwRjNOSTBRSVRwL3Z5cUlsN1Zvc0FK?=
 =?utf-8?B?SHlCZnYyYVkwZWttc2tOYW5XcE56S2kwQnBOckpEWjhzRW1zVUFUTUF4a3FV?=
 =?utf-8?B?OHFnUjJDeHhLZkNyYUlwMm1QMlJNTDZ2VldPZUpsR0F5dUYxQXJVUEV0T2Ru?=
 =?utf-8?B?MXl5Ry9janVlalhKMzV1YUNLeGtiSUFIQ3lDNkNYd2p0eGlYYXlQMHRHT2FY?=
 =?utf-8?B?enZzcWRhWHRFcGxSNDNyT2J5T2xDTTRDZDdoK3RrWko1aDdIeXZkb1d5R2Y4?=
 =?utf-8?B?RDgxT3U0Nkd0NTZyK21OVU51ejlqM2NGQjVZbWxGcmZmYnVqYytyWHdsK3Vq?=
 =?utf-8?B?alhUWU1iVDl6WjlZTHhIUjRxZitQcHFySWJyMmFQZGdmYWp5cXdwdVY2ZDl4?=
 =?utf-8?B?L1o5NmxjTS9LL05yWEx4Q29yTmFXUDBQcWtjVlc0dlNPRWZxMGhkUkNMUi9B?=
 =?utf-8?B?bGt2Z2cxMHd6TFdOWFprbHRQRWc2OXp2NEJ0T1c2aHJHb2lzbUZNVXBCQ2FF?=
 =?utf-8?B?My9JbGkvSmlBUGUxeWltVEJQWEtHVFovazNKSzdWUHovK1dzUHhTbnd5MGFP?=
 =?utf-8?B?QnNhQnZHdlYxZ0pKWGZxbU9wWU02RFNRVUpyV28ycWt0bkVTUTE0S0RjRFNE?=
 =?utf-8?B?YXpBYmcwWVo4UVV5dkkvSlplNUxjVGZZSzhxdFBnQnF4TjNhTC8vOGxMT2o4?=
 =?utf-8?B?L0d6dFFibTlNbHMrQy8wV28wSmppMTJWRFVobnNCTTJyZnJidVhsZkZqN3l5?=
 =?utf-8?B?RkFUY1o1b2Y0VTdiS3BqWE1oNzlabVRQVitiQ2tUREhDZ2hiaVhjbUtQTU5a?=
 =?utf-8?B?OUVnc0hpNS9hNjFTVnBuZlB3VlFTK3h6dlRpRmQ2cXJZYmJnU2k5U0xpaEZp?=
 =?utf-8?B?UTlhSTNlK09CVjB5TWEwZkJnYU4rak9aUUZCZUR0Vy81YmxRVVdheUpIaWla?=
 =?utf-8?B?Yk55cWhrZ2lwREsvZ1RESWxaQzJoNjhjWVdQZnNVR3U0bC9Pdm9aWUpYN1dO?=
 =?utf-8?B?ZjMwaGVETUNBNGhEYXJLcVVDL1RoR2gwbmwvODR4SndNcFY0S2svQXQ5Z05R?=
 =?utf-8?B?eElpNEtCRnZDSk1zaGJqSW9xcVR1a0N0WFVPSTJ0cTZjYUVIYy9lS2c5YUly?=
 =?utf-8?Q?lk4m1Pccs8dkMYhk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9130E9ED9AB9043885C6030611B1D45@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: dbj/x7ILrOJR/83tHFsEBCvyZ9ixbELTWfF/QdHg1IcYtzEgoEiWiTtyPDEKaV9xpNe/sOw9htRSVRA1+ym92SM5ZKezj2005QD1GDjNZytFszB+ewosYF98uDT5CrdBe+63atY6ZlE6AURY+rfHzioAhdPhnpQJrK84L1JajdnszxEoE8huFyCUEom6t+ZgMDXOZe7k8vWrm51EhGgJEgskYipal6jTVHk6mrdZpJflOexQI4ykWSY5Ym3QjPYNIzg79qvKxpYLP6JLKeG3+1duFARivrVGk9W1ML+a6V0x5pkulCNXUG9W42s1pM7wMHjcUmkB3FclxQJC+N2/zg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e535b1e4-7edd-42b2-21d7-08ded106c895
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2026 09:06:59.7686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WaQp40OXpvR6tvLdeuZrY2Sxufo75xEnHfAXnF8YGbD2OX0qoMvGJRMxrSoacDCtn5sHjC7kLH9OieafVPV1sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6730
X-MTK: N

T24gU2F0LCAyMDI2LTA2LTIwIGF0IDAxOjAzIC0wNzAwLCBDYW4gR3VvIHdyb3RlOg0KPiB1ZnNo
Y2RfdHhfZXF0cigpIHNraXBzIFBPU1RfQ0hBTkdFIG5vdGlmeSB3aGVuIF9fdWZzaGNkX3R4X2Vx
dHIoKQ0KPiBmYWlscy4gVGhhdCBjYW4gbGVhdmUgdmFyaWFudCBjbGVhbnVwIGluY29tcGxldGUg
d2hlbiBQUkVfQ0hBTkdFDQo+IHNhdmVkDQo+IHRlbXBvcmFyeSBzdGF0ZSB0aGF0IFBPU1RfQ0hB
TkdFIGlzIGV4cGVjdGVkIHRvIHJlc3RvcmUuDQo+IA0KPiBBbHdheXMgY2FsbCBQT1NUX0NIQU5H
RSBvbmNlIFBSRV9DSEFOR0UgaGFzIHN1Y2NlZWRlZC4gS2VlcCB0aGUgVFgNCj4gRVFUUg0KPiBy
ZXN1bHQgYXMgdGhlIHByaW1hcnkgcmV0dXJuIHZhbHVlLCBhbmQgb25seSBwcm9wYWdhdGUgUE9T
VF9DSEFOR0UNCj4gZmFpbHVyZSB3aGVuIFRYIEVRVFIgaXRzZWxmIHN1Y2NlZWRlZC4NCj4gDQo+
IExvZyBQUkVfQ0hBTkdFIGFuZCBQT1NUX0NIQU5HRSBub3RpZnkgZmFpbHVyZXMgdG8gbWFrZSB2
YXJpYW50DQo+IGNhbGxiYWNrDQo+IGZhaWx1cmVzIHZpc2libGUgaW4gVFggRVFUUiBlcnJvciBw
YXRocy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbi5ndW9Ab3NzLnF1YWxjb21t
LmNvbT4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlh
dGVrLmNvbT4NCg0K
