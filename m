Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BA039AF3;
	Wed, 15 May 2024 04:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715749011; cv=fail; b=THUW2EIV7nOI9+nSjL/2BT5ekzq/2eBZ+DFtYPoV5EoIxdP2nvjGbTlVUFbpPFsQd9jxns3krxbtIbhy1CEK2W8apJWqThgdyY9zpvDG4da//oFpOGuJZTqb4fQ4ZOaAkbFDadVkFUOuWjcxcTfLJZfgLAxtP1xLmBy40XiafQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715749011; c=relaxed/simple;
	bh=sH+fQEWuSyQA/NK2g271jaB6LDzYR6d2O4OKiztORbU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zif9LZyIPxZXjMgLuFuXWvWDQeEJ0mLvJc00q6LCRE+Dnie9jJBPhHitRv5jQkGmLDHrshgkyTnhmNZdLgfBhxQRBEcDF4Bca9U2PKhQom+OOp2+R2y4a1tUepEdj5xQU858Gjo3YcKdgIZh+jMJKglZRan09/edtd2TTC6nURw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=KxNo4DFw; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=F2qeuXqD; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KxNo4DFw";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="F2qeuXqD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715749009; x=1747285009;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sH+fQEWuSyQA/NK2g271jaB6LDzYR6d2O4OKiztORbU=;
  b=KxNo4DFwkiysvE9oe5Brbd3I1LSykG75iOJlBpEkRMzA7i54xk1hSg9l
   ziFb2ejiE0XP9FWvp0QsXRcD51q34cVy38jEIYEqjfA0vmsxbbzHyeQUQ
   2ui9uBmM222EQKBQKXyM6gEbfjF9Z2lgbyyRTH2CddhlBAi1FL5MPUTwi
   xAUVLVDUMmkUkgFbvSUjKvF96o2LmLOLjb7kRmQXNgdLyTmVns3LDJeJV
   6oeWXYFnZ+aU41Hq6iJToeJOJCz8HQG6hCHNMHdLFQ4PPU80clLWsPtTG
   RqVm7ftbdOuc7iiG7GHsXCBD79lAuhIVn4lIaIfHy0bAbZdvPP66On4rF
   A==;
X-CSE-ConnectionGUID: 7OdbAIV6SZq795gaLk7FNw==
X-CSE-MsgGUID: +yR0NDGbScyRWbzfBZ5xxw==
X-IronPort-AV: E=Sophos;i="6.08,160,1712592000"; 
   d="scan'208";a="15696700"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2024 12:56:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLRYetWz4yuaivgSDAoUIuFDXV0tVGxEKfxnwUHYh3T2HMNSzUJQvSiqvZhOMALcAeR/JT9OU8z80yUcI7tSXjsUrgB8OYwiGpgd0DcRJrCAVnZGJ/FhEdclEd6tioWzTIBgsuwa08w/FUYusAnVe2m2cYKmII5bu1sNrD+p7jwEg+jWEYMVuRBSPn59PjrsRWmorwwXKBA6csdKlz5ZBB6itghUusquareVVTNXUj3gwlSQFOdiYC6ik+co6xX0Y7nd1HNl3M6MX+sSs6OkJhdsb0cV5SRLjI5xAjnb2BeDCP3cs/sb/7QgkwCDdTiku19P4vjVXG9A0R2uHznRFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sH+fQEWuSyQA/NK2g271jaB6LDzYR6d2O4OKiztORbU=;
 b=edlrUt3p956RrrSWvG+I5Z35TyfkJxd6OY5ASVhLaueW/ReSjL2nFa1de/VhPOP69+Vj8dh73Nw9xAOzBp5wcGD2VPW6+jN0gsqp4BzGstnUxESJRohTVCFu9bhiQxFb+aGYvRxS0kaYLRItJzMBvv5ZhTrmeDhh8bSHun4uexxMMnxRRLdxupPTQ1yn5fR5if0EXAUt+3FUPEQ20oBe584mgBNa+FbSZxh69L8woryANs6T0DKYOVqkfZeuLJLzKjN83IiUdttvJND0GBkEB4guftHRCjjq0VaXDgDCDHjeeMDHcvPUYDTF8kfoBPvVcACnzo2AjbrKLh33S7zYhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sH+fQEWuSyQA/NK2g271jaB6LDzYR6d2O4OKiztORbU=;
 b=F2qeuXqDwnOgdmxZlRk/Zqxeo8rm89nRFyQEUOIJvYuoPRUzv3ltx0kXMj2bd5LC7c3SBzR2fuPbdcvdFVKNGEaiqfDkrEmLKoMpPhJgp1JMO30+dE/XM7T699PMQalAHUAsVg5+ccaQivT3tiYC4Zb2jxjv2qOFM2g6Uckze6o=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ2PR04MB8510.namprd04.prod.outlook.com (2603:10b6:a03:4fb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.55; Wed, 15 May 2024 04:56:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.025; Wed, 15 May 2024
 04:56:39 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Index:
 AQHapbzIAmCD9ZFsDE2/LZDUaio3E7GWsCQAgACAZcCAAAW+AIAAAyWQgAB88QCAAAOoUA==
Date: Wed, 15 May 2024 04:56:39 +0000
Message-ID:
 <DM6PR04MB657562B04C1394FF8FC1D9A3FCEC2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240514050823.735-1-avri.altman@wdc.com>
 <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
 <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
 <DM6PR04MB65759D4064B9FBF13BBFCF72FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <de19c4be-ef6d-4b1a-be26-fb697ac29026@acm.org>
In-Reply-To: <de19c4be-ef6d-4b1a-be26-fb697ac29026@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ2PR04MB8510:EE_
x-ms-office365-filtering-correlation-id: f8fa9a50-ba9b-4d5a-9a93-08dc749b6855
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?OUtyZHR3UXgyVXR5TTAwejFqTmFQNzB6RnNDK205TWovYmtwejFBbXI5UUxm?=
 =?utf-8?B?bFBzVTZyUTJnVklWUExQR2x3bHNhRis1NC9IZDljcktQWG1tSFgrZWtKQXlu?=
 =?utf-8?B?aFdHYmRTZVVpOEhLejVGZ3VMRkRGK25Qdjhqd0RkRjlaNHlsREtiQWRISEdn?=
 =?utf-8?B?V2JndGpWRGY4K1Y2aHlDUVp4amZUaHJta1B1Y1FSTUNEdGRlcE9aUTVlTUk3?=
 =?utf-8?B?clN2ZGFOVnRjN3hSM2NXZ0IzNnQ3bVdQbHM0YW11ZVMvZXkyM05TUlVxOHEr?=
 =?utf-8?B?SGpZREk5anY4TnNmR282UU9FMk1Fd1hqbU9PMkduTjNzOHlCZTg3S0czTFdE?=
 =?utf-8?B?QytzYTZOZ3hFQkxJSHBOcVRON0ZKQWJPazduNytNZHFvaVNOOTdvYk03UjJ3?=
 =?utf-8?B?bjcrTHYxVlVCUzd2UFI0Vis1UGJyZGRKUUdBZ1RBUmhZZ28zdlk1dG0zL05R?=
 =?utf-8?B?T1ArSTVlbE1uNzRNT1dqa1l3T2t6RVArVS9MeVM5R2djSUNiZ3N5K0hiVCs4?=
 =?utf-8?B?d0FRa21xNG5BcnpGbzM2MTlyS2lKTWlxaHB3Q1pmTzJPdHZ6K2RKOFVXMTZp?=
 =?utf-8?B?eVBmalJqeE50dHZmYU82OFBDZ04yL2NmbXprVjhIZktoT2NzZ0YwcEJLRkl4?=
 =?utf-8?B?ZEtOSmRlTm9HemMrSFQ1anRrMjNzSmRyK3FQeVJ6Yi9GSXJOS2RRUHZJVWgv?=
 =?utf-8?B?K09WZjNEWmZJZnk1dUcrcTE1K25LVlk0M1N3OVY3cVMwcVBmeStUaUFYS29i?=
 =?utf-8?B?SmswMCt5Yk56VU1sYkJGZXlxZnZ2WFhQWUNZenRKWWV5blNra3dwUjhYM2tT?=
 =?utf-8?B?MHMwUkJ4Vng4MEsycDE2Q2MwYWt6ejRNNWIwQmo0UitzNWczT3NFVFlmck9y?=
 =?utf-8?B?VzlVVHRaOHhQU2g5RXBOZ2Q4SmlFRVpvU1owTFdQY1FmWUJqaU1Uc0tCNWRi?=
 =?utf-8?B?L1dTVEo0K1BzOWtTYjBlaXVrc2d5RTJBcyt4U1VLYmlVbW5QeTM0dVllWWs1?=
 =?utf-8?B?MXVZaWRTbnpVazJZbXFCZlc4VGd3VzkrVmNLN2dncU1xYjdGYnFDK1I5Sm9o?=
 =?utf-8?B?djduM3ZwVTk1Z0hSUUpENHI4blZSTXNmQm9wMDlGWE9taitKUERqVGVKUy9r?=
 =?utf-8?B?c05XOGRUdjdMc3lYY200eTlROGRGbmwzU09taUM2cnczMjNOcVYvY2hIeldW?=
 =?utf-8?B?OSsySjhWSk8vRUQycTRlcXB5ZFlncXRYOGVsWSt5NFN3VnVnMXRnMzI0WWRl?=
 =?utf-8?B?NDBZbi9lTlBUNDhFcWJ4bElBOXdYdzE5MXlHQ0ZwMHJNb3c3QUNvakVobWRq?=
 =?utf-8?B?QzdydXl0WXhCRDkvbmdsdEdIbWs4ZGxzOXlpNTdJdVNLcmhTbU1TeklPdnFI?=
 =?utf-8?B?YkZYUTZqcXlORDRKS2pZTjhsOTFhbDRIdGdwaU9QdTVRczkxUFR3T3VrcFFL?=
 =?utf-8?B?NW5hS3dUZzJoaGhEc05pK3ppZ0MrbzlvdDlxTnVJdzE3SzhML3hSZ1ZMcFVV?=
 =?utf-8?B?ajBKeEVFQ2dHQ2V3RXg1dmM5OFdSTFZmaCtuSmFCTHQzZ0ZvbWZKU2lUVlBI?=
 =?utf-8?B?NWpTczMvWWY3Z3VlcDk2eDhobHJ1MDdGVThVTE1jZU9OUFB4cjlhbEtKTk42?=
 =?utf-8?B?cElWbnpTelhjSHRYdnF4eWlaay9idHFPbDU5Ty9sMzhyQzdXdDZGeHY1MDNo?=
 =?utf-8?B?bWs1MjVIWlVGNlc1WTVBZ3lsYmMvWHhMVCtUV0NDbmRjb2Urak1LeVBnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MlNrQ3laMXR0NHdFelMyVnpLbmJZY1RlL1dkZkNCT09LSGViZmE1S1NVbG5Y?=
 =?utf-8?B?d3BkQVA5MzdqR3lHZzRDQmdJaUJSb0ZxQkRlbWZaN2tBVkRXb2xMTVpNaktS?=
 =?utf-8?B?eGh2b2krZEpLWHZ5SEx5aGtDOXcrcVkxUFhZTll4OU02RkhvVUM5bXpWT2l4?=
 =?utf-8?B?U294YlE0Y29SMTFudjhiTllLQXpTYm5TUmZYUEFNZzlrMTBjai9tcjZFWEFz?=
 =?utf-8?B?dDE1R3lQaUxsY3I3UlJ6UGtwZ05ZQXdsaGt4Qy9sQ24wc0ExclRtWXpQUXd3?=
 =?utf-8?B?ekxRVGFtQU1yN1VFcWtxK05aT3hkSjdEakF6MWZXZURaT0xOVnpmZlZzNlBx?=
 =?utf-8?B?UkQ3RnpVV3RQcXZkSzVPSmRnQUQxY2Y1WjRhV2F1UHcrOWtoQkJ5Mmw4cEY3?=
 =?utf-8?B?RDRwdGk2QUtlQWEyM2VMeFJxczV3dmJnVkFFVkVnYmJ1bW5weUYvM3ZGb0lV?=
 =?utf-8?B?cFlaSnIwcFM3VzEvZ1pIU1RvbC9jNHFqT2wvZXdhNmt6ODBTSC9hYm5KZENU?=
 =?utf-8?B?aUE2Yk1xd3FkN1RYcDBBekpOaXl3ck9OOFFQQ2xVUWt0QWpNT0J2YmYraVhs?=
 =?utf-8?B?WUJKUlJUbm9yRDJILy8yQmpHWXpKcGZySEduWjJPeXdaU0JqRitIVFFGL3E1?=
 =?utf-8?B?VE5jWm1YYkw1eVkzQk1DdE1KQUxJb1pDbjE5MVFPbTBwbU9ueE80clJNeGox?=
 =?utf-8?B?MS9FNXZaSi93dWhZUDd4a1JIbnhFbzJTWUd3Y2FlSWl0KzI1NXVMRHI5ektw?=
 =?utf-8?B?WVRCL3NORnpob3hiNFBOaEJUM1Q1U0VQVVV5OVJack05dVF0U2Q0K3BFREJV?=
 =?utf-8?B?aEljcEkrY3RCdGJxY1d4c1d6N1A3Rmw4bGtVaVhZa3RtTGtJMzdGbisrQlRC?=
 =?utf-8?B?NlJ1ejNVY1VuSVFlUmVDczJaRjRNeDd6M3JRVGdtR3lLTjBNR2VocjFjRWxS?=
 =?utf-8?B?a0ZhUW9TOVZtTWxyVDFaWER1Vm1GdHhzTWNYcnowMlZVSkQwYWV4S3U1VURx?=
 =?utf-8?B?cklZZ05CZ1FNQnBGSXlHWWJkVnNiMGNmb1p4L0tQMTB6NFF4V01UVjFFSmgy?=
 =?utf-8?B?Q1hpb0JqcnhxYWV4T1pXbFJ3TnFYazYwQ0NnYm5wMXRDWnkvakR2NDgwUzlZ?=
 =?utf-8?B?TnRNK3BCK1o3L0dTVFB6dkVkcXM3S2xBZlRKM3VWTDdGRm5ZeW16RUNUTGFw?=
 =?utf-8?B?SVRicTcwbGlmWmpqN2ZrUjIwc2xKeC9CZllnWDV6emRMMXFBK1hyMjdWNnB0?=
 =?utf-8?B?Z2VsVEFyaFBWekh3WW1VdEI5aFlJaUxmU3R1blM5RFA2cE9OTkpESGx6SFow?=
 =?utf-8?B?THpYc1BvVDNSMUd0dms5Y0JYOWR2a05HWkZuZkF2Ti9VOCt2STF0NS9YZ3Az?=
 =?utf-8?B?L05UeWtMRVNlZUtyY0pqWDNuRnU3MXFoYm5DanhUYWRBQjlwbGE5K2ZGMDRC?=
 =?utf-8?B?bksrb3Z0N3hseDlKMGVNb3NUMU1pOEpSdm1rUGhyTzh5VmlHcXFrNlVvNFQr?=
 =?utf-8?B?T0huUlJOQWQ3bWFXbGV4ZUNmbnNqMXJTZDc3SUVZQVBEeFh2cWYyOWxXQy9r?=
 =?utf-8?B?QVNHWFcwRDk2MG1adzkxd3R6NE1WZEV5QitHUDdzbkdNSHRSeVBLdy9FaWN4?=
 =?utf-8?B?YXFrZnhqNjdRZ1cxTzBZTEVkWkVaNkp1LzJ0dFRHYlpBMkM4VEhkT3lGdWNX?=
 =?utf-8?B?SGdFd2JKNDRvV1U5T2hDWUVxYUdFQnF0clJkL29IMmVJRUg1emV6SDV4U3Nq?=
 =?utf-8?B?bGtVQ3pDcEpNRXVGQS9CYTJEdGNuMGRCVk42YjVIL0tMdWdFNVdneVVvVVBh?=
 =?utf-8?B?a3JWZTRrdkxab3FKeVBDSXJEVzJ4NEpqSjR1MkY1TGJ1VUhrM1VXSzZwSkxN?=
 =?utf-8?B?U1hIVGdSUUZWeTVmN2MvZVNET2dGM3U3cmh2Wk1HU2pDb2R4bTFoaDMrRG53?=
 =?utf-8?B?YkZlU2NOK1dKN2M1THFvaW14MDZtcGxTM1NKbHN0N1RDSk5TZEoyMnB5b3hQ?=
 =?utf-8?B?OXo3ZUsvZFRPSVdnWjlFZmdndEJxRklpT2pENmhzQ2JuYU1hM0RydzMrblNC?=
 =?utf-8?B?UkxqRU16R0VRVzNPMVgwZUk4aEltUE55cXV0eU92RTU5V25sSU5NcytqKyty?=
 =?utf-8?Q?PwX8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zXsMODasWN/ZafEBwzGx7PPsdD7XLHRuIB98jTlH6Y7NZC1kffb4x5ZA8WhQh3thg97M9I8X2gDKbnmrMG0vDEftluzuff6SoNzGsihf/OQ1XfbbWfOfKXWpvXfpKxcaSbsly4eBPBXwI6TNtNOfO5le2tqUs0XoiInaM/MZRzmU/SdN/DtF0wmjkLKFLLZWkyfxjVeA4hSxMUBZTdkBGKi6HMgdOpbH0PLc8hxuNrfq1XKqOPnAkMIcxEVbXxHDCHQ466fQm4iTgDfclL57M6fzSM4MFv/3ZilxcXa1TcOxLaNto4HOePTsG9XDQ2w+uLK1w/0idqpbq7i8Id93EV7U7HX25r+nT80EDDtxoqaQdeZwa+AMHEFtq9GP4GltQQfFviOTc7ycaWetcQJJhRR3GNa3YCRsynD7jD8ZH9as+n7aSp0+36AkUibqH+SEgNH3YBzrXgRJ0hz38+Esak/urxUEwkimhiLFWjD7XngkVXTOJXirNndQdgBCUQNr84WlXNoeWOEtNQUoXQiUHgws+DrgLaK8AgZbgLVTblVQMkcMr1bT/LASOns78/2DfV5Gx1YEROQ7JdOW5qWexzpRmCa1SNhgI2vy+pXh55t/2s7WwyRKGBHqI/w6y7/S
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8fa9a50-ba9b-4d5a-9a93-08dc749b6855
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 04:56:39.8832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bw5v9wo61UB46BAz/vYdYiboME1RlzGLR+LS6gUfFreixJFE+Vp97HuipvV0Wmy7ewEv6VYFSnqBlwaq7aPbrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR04MB8510

PiBPbiA1LzE0LzI0IDE1OjA3LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBCYXJ0IFZhbiBBc3Nj
aGUgd3JvdGU6DQo+ID4+IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB0aGUgYWJvdmUgY2hlY2sg
d29uJ3Qgd29yayBhcyBpbnRlbmRlZCBpZg0KPiA+PiB1ZnNoY2RfcnR0X3NldCgpIGRvZXMgbm90
IG1vZGlmeSB0aGUgUlRUIHZhbHVlLiBXb3VsZG4ndCBpdCBiZSBiZXR0ZXINCj4gPj4gdG8gYWRk
IGEgYm9vbGVhbiBpbiBzdHJ1Y3QgdWZzX2hiYSB0aGF0IGluZGljYXRlcyB3aGV0aGVyIG9yIG5v
dA0KPiA+PiB1ZnNoY2RfcnR0X3NldCgpIGhhcyBiZWVuIGNhbGxlZCBiZWZvcmU/DQo+ICA+DQo+
ID4gTXkgaW50ZW5zaW9uIHdhcyB0byBub3Qgb3ZlcnJpZGUgUlRUIHNob3VsZCBpdCB3YXMgd3Jp
dHRlbiwgZS5nLiBmcm9tIHVzZXINCj4gc3BhY2UuDQo+ID4gQXMgdGhpcyBhdHRyaWJ1dGUgaXMg
cGVyc2lzdGVudC4NCj4gDQo+IEhvdyBjYW4gUlRUIGJlIHdyaXR0ZW4gZnJvbSB1c2VyIHNwYWNl
PyBUaGVyZSBpcyBubyBzeXNmcyBhdHRyaWJ1dGUgZm9yDQo+IGNvbmZpZ3VyaW5nIHRoZSBSVFQg
dmFsdWUuIElmIHRoZSBhYm92ZSByZWZlcnMgdG8gYSBtZWNoYW5pc20gdGhhdCBieXBhc3NlcyB0
aGUNCj4gVUZTSENJIGtlcm5lbCBkcml2ZXI6IEkgZG9uJ3QgdGhpbmsgdGhhdCB3ZSBzaG91bGQg
cHJlc2VydmUgYW55IGNvbmZpZ3VyYXRpb24NCj4gY2hhbmdlcyBhcHBsaWVkIHRoaXMgd2F5LiBB
cyBhbiBleGFtcGxlLCB0aGUgU0NTSSBjb3JlIGRvZXMgbm90IGNhcmUgYWJvdXQNCj4gY29uZmln
dXJhdGlvbiBjaGFuZ2VzIGFwcGxpZWQgdmlhIHRoZSBTRyBpbnRlcmZhY2UuDQpWaWEgdWZzLXV0
aWxzIC0gaHR0cHM6Ly9naXRodWIuY29tL3dlc3Rlcm5kaWdpdGFsY29ycG9yYXRpb24vdWZzLXV0
aWxzDQpZb3UgbWF5IHJlbWVtYmVyIC0gdGhpcyBpcyB3aHkgd2UgbmVlZGVkIHRoZSB1ZnMtYnNn
IGludGVyZmFjZSB3ZSBhZGRlZCBmZXcgeWVhcnMgYWdvLg0KVWZzLXV0aWxzIGlzIHRoZSBpbmR1
c3RyeSBzdGFuZGFyZCB3aXRoIHJlc3BlY3Qgb2YgY29uZmlndXJpbmcgYW5kIHByb3Zpc2lvbmlu
ZyB1ZnMgZGV2aWNlcywNCkFuZCBjdXJyZW50bHkgaXMgYmVpbmcgdXNlZCBieSB0aGUgdmFzdCBt
YWpvcml0eSBvZiB1ZnMgc3Rha2UtaG9sZGVyczoNCmRldmljZSBtYW51ZmFjdHVyZXJzLCBwbGF0
Zm9ybSBtYW51ZmFjdHVyZXJzLCBtb2JpbGUgdmVuZG9ycywgZXRjLg0KDQo+IA0KPiBBZGRpdGlv
bmFsbHksIHdoYXQgZG9lcyAicGVyc2lzdGVudCIgbWVhbiBpbiB0aGlzIGNvbnRleHQ/DQpTZWUg
VGFibGUgMTQuMjcgSkVERUMgU3RhbmRhcmQgTm8uIDIyMEYgcGFnZSA0NDMg4oCUIEF0dHJpYnV0
ZXMgYWNjZXNzIHByb3BlcnRpZXM6DQpQZXJzaXN0ZW50IChXcml0ZSkgLSBUaGUgYXR0cmlidXRl
IGNhbiBiZSB3cml0dGVuIG11bHRpcGxlIHRpbWVzLCB0aGUgdmFsdWUgaXMga2VwdCBhZnRlciBw
b3dlciBjeWNsZSANCm9yIGFueSB0eXBlIG9mIHJlc2V0IGV2ZW50Lg0KDQpUaGFua3MsDQpBdnJp
DQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
