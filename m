Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8911E529;
	Tue, 22 Oct 2024 06:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729576989; cv=fail; b=OM4ux0nPgE4IbPyEW/gWBH8APpBgPIqmJy/rBEuM+ptggQso+3de6hXSbA0yj17Vw51qeyhS+qYGlbaE032puJvTQ/cvIs+fxbLJC8/ZJOEbvS6c98Lphr+G+4Qgj0NKOdFdnfDzp/cw9eIVKS9HUw/XQwS1xzpq3EsdQNq+6Pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729576989; c=relaxed/simple;
	bh=r/EYf2DhZm2AFcLR6JPWrl4K7wyfMy0jpEISlSUA6cg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aW8VLPtQ+b970Si3CGVxyRobWyLElAOXRyFABWtFanGpzEfLMq+7afT2b78i4Q3w+JFXeZKqAdhfVCZZ/jfeLxpt0J822FRfEnC89ikfBCUSZsnBJPwNAyN3Itbd7lbgOvsBKeaRCpLyifKbU4WlZzhL4xIKgYfsbHmUvSGAyko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eDUztDwi; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=DhP74r7s; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eDUztDwi";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DhP74r7s"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729576988; x=1761112988;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r/EYf2DhZm2AFcLR6JPWrl4K7wyfMy0jpEISlSUA6cg=;
  b=eDUztDwidZGE0hhyEzS3mO9RG1/UXKStgySI8AsYx7EGRqZ0Vbmdfbk7
   d8gTxks6lqh153nijWElEKQRQRpz8WllbT99oNs9g4tw7D7ISr2qLcYnl
   2uXaaXRzSFrMKtp89LNEQn8L74I2+1CZsBbz5qjuRCBEpRkeSQDP8knSC
   XvQw5gkoXBPOOxImR07+Ak/Dj68d0GCLdIqUDVp9iJjG15neZFkIkSLaU
   mtUPRLAiN0+PI/GFOiKa2GT/SUCgjYPYzSeBLnrc+sHeHyE0JdsRYPS2z
   ej5ZQMXSP+eigL806TZvZzZVVvB01MUmkXeglFEOfz0nEM7PBCwKRHyaW
   Q==;
X-CSE-ConnectionGUID: xGWyHKH+QMe1hu93YscOnw==
X-CSE-MsgGUID: OLeSG3EMQ+W60Dvy+zNH2w==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="28957489"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 14:03:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ckzFUYLhDdmECaNLXN2JUbCla4TX7oy0u/+zvcwWdPrAGO0IRAAOAMehOMvd+RpEk6vqv/iocBmtXJjAc6ZFxznGTkjphBS7Md8/TXC+os4emPTlZIGO63Ydz7UWmFiqmAyN6lXmfZemcmYlM3ll+PDI/wmLMWEVoz7CNlYMu/z2HHtzPyLeH37vGBVqtFm7k3l77FTku/cGQ92BVsjSUIVBGJu2/Q+tOXdzmMmIjbGHSR6rjFOnnefyksVpWZ/+0P+Ikm+wdJ7VAQ1FlEXvhmM22BF4CTrwQlmq0YYsS9NQxt3IO7w0znj4EFc7mk96pB7lnuesSWaYa/0wymuppA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/EYf2DhZm2AFcLR6JPWrl4K7wyfMy0jpEISlSUA6cg=;
 b=c7xMFLhmoeJXIRvrVvezTq5P2JZlRznv8ucm7DsTMd2jTixE00xEFYhbTYcNznYHr5qoPOeAlBM42cpsFCUMqSG5+h26FN9WxaZLrXXg12RFI2UNeKK2ZU+YyAcLJnkYSzsKACLn5OhOg0081hDpg276jkJalM+v0ZDaev8STC+ojEE453u0YlEBqwsF5nBS+BWEpIf0a1lUua1XD1sZaoRRdC3c0AoFpYgzMtxxk5QvQCpr2xh8IX4RcjKsYowThpqWXcRmc1dtUoQK4m3ZYcanNCse4MKA7ykGt0fxJuG9P3Ct6An4rNyfj7lKONOGzncqgF5Q3I0qe2IIf7/eYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/EYf2DhZm2AFcLR6JPWrl4K7wyfMy0jpEISlSUA6cg=;
 b=DhP74r7s3rfIpEF8RzV9A51ZqJf61vNC9doFlWqTjNhsbIR7AMEDUGoBJl/De6Yd0tYotL5EZwISiEhX3uCjKmCb7Lfy66gxPsVSMB8wJFcq6wwDHKSH/gH2v67w5BXI/kP/cwAPcYT1Vkzs/71YWg5HDB+AlyEnsnEIyIExGFI=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by CH2PR04MB7109.namprd04.prod.outlook.com (2603:10b6:610:9e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 06:03:05 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 06:03:05 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/4] scsi: ufs: core: Use reg_lock to protect UTRLCLR
Thread-Topic: [PATCH 3/4] scsi: ufs: core: Use reg_lock to protect UTRLCLR
Thread-Index: AQHbI7GUhmarQlDCUUaP4ZbWJj61K7KRp8QAgACg3wA=
Date: Tue, 22 Oct 2024 06:03:05 +0000
Message-ID:
 <BL0PR04MB6564C8347FFD2C60B5C589F4FC4C2@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
 <20241021120313.493371-4-avri.altman@wdc.com>
 <0a1a0c85-e2f1-4a7c-ad0d-86ad8a84e624@acm.org>
In-Reply-To: <0a1a0c85-e2f1-4a7c-ad0d-86ad8a84e624@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|CH2PR04MB7109:EE_
x-ms-office365-filtering-correlation-id: 539b6589-0b86-4545-5344-08dcf25f3212
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TnRtZVFNejRiYnY4akpIcXEvdEhmd29Hd2lBenV0TGlLYktvVnFEQWpZV1Ey?=
 =?utf-8?B?eU5Na1d6cXo4VnUwOVJ4TWcwZnJzcVVTTVo1aVNCWEoweVRRRGN1Uk5aazBj?=
 =?utf-8?B?ekM2OEJXMloyaDB2Q1B5Q0QwQUlwcTZ4cDJJL0hlRXNLTHdDS3hPV2E0czRN?=
 =?utf-8?B?aUpENDVqVzk1aGgzUEd6MWpLNjlMc2NlTXJlZHdOT3hNbkZFL0wwMEdLU3NV?=
 =?utf-8?B?SG1aWWhzRWpBZmpBNEhoUmlGYTYrZTdsR2lGb3BQeG5zR2o0dk9aQVZpaGdu?=
 =?utf-8?B?c080cWJQUXU1RW9BM3FqaEhLUmJNTFdNYVRha1RhdGFxV1ErNWRHdGJzOUEx?=
 =?utf-8?B?VURDTVp2aUZNZmxWejhtWDU0T1Q5ZDI4eEs4bzZQY3BwTW1vNi9BM3hRUjJt?=
 =?utf-8?B?RFl0RGphRHV4MDJCM3M3cU1wUXgvTjQwQlZDUlFDd0V3QVBUd253cWdXYXJP?=
 =?utf-8?B?NDdZdDhYSTdPMmFnTTRyY2l6TmxoTTIzU3VoVzRld2pKYTdidG9mcy9QT0FU?=
 =?utf-8?B?MjU1ak5tTEhObmFvMklnc1lzY00xOWJtbTdGZGh4Q2U3SWdlNFl6WWRuSklP?=
 =?utf-8?B?TnBJdE8rL3hjdG9RNHJmYWFvSmEyYXl3b3RXeDRvZ2ZVc0pvd1ZlYlB0VCtC?=
 =?utf-8?B?Wkhlams4Y2VQVGdkVVV4S2l3dHU4UnMrdHFYaDJQbDBMWWZITjduNW9FUTd0?=
 =?utf-8?B?akpEVis5TjU4MDRVZkh1MnBkcXNIZEFDWlVrMDF6WFlaR3ZGaHpaMyt6M2hH?=
 =?utf-8?B?WFNBa1ZuTVZvK1JQaEF1dWszRUVJaTJkQVpndVJtTTBxblBFUjhadjRWOEI2?=
 =?utf-8?B?RnFneTVMWGs1ZUQwa2xCWXorenlmTzM2QnJFNkxRS2hld1A4QU0yNlRjVGo1?=
 =?utf-8?B?UDhSMDFIMHdvOVFpdGMwcHdQMTVGc1ZBaHdmVXN5TzYrdEMvZHRZaVZ4SUhz?=
 =?utf-8?B?SDc3bll5STFhUkhOZFVaOFF1Mlh1czFZeWswdTRzVmtoUWVobWZzK3ZhRWxk?=
 =?utf-8?B?ek01cHdCdmJzbUhkV3dUQ1dNWjJRalNLdW5CWDlhSGRNVkpUSy9sUU5YWjR0?=
 =?utf-8?B?U2UvQjVHQlkzZSs3cmpOZ3Z2TlZJdFgxVUFZem9sQ0NnNU51VlZPQmN4cTRz?=
 =?utf-8?B?bGlFWHBTWmkwTk55NmE0TmZ4MHY0Z3c2NnZGR2VEUjBzcjFMVGlEdWxOSVds?=
 =?utf-8?B?ayt6WVhPYnA1RUIzNy9FUDBxaWFLWHZCYSt2YUs1UXlTLzNWd2RncGtETjRO?=
 =?utf-8?B?OGpMZEszbVVpL1Iyck8vM1dCclgyZllvWWZxeE4zbkwxTEZSYVNBSkEwKzlM?=
 =?utf-8?B?L3hScHppb1lIS3lHRk5ETkxYakY1eVpiRDJYcXBnWHM4eHBxNWRlYUpEbGdR?=
 =?utf-8?B?R0pIMHBnU0l2eEx5STI2cElLN3NoaEwzUXpLVTc0Ri9UU1ZNV09ERlU1MVRl?=
 =?utf-8?B?WThRQkpvdjRJR3gwNERvRGxaV0FRWDJpcUNzNHo0dDJGZlkzaXU4bWVwVTB0?=
 =?utf-8?B?eW5CVmFyeGVnS0ViNkVvcjdOY3BkODdpTXI4ZHVXNGRYeTNXMmNDT3JKTmx4?=
 =?utf-8?B?MzNHZGwvY3AwTmp6Skpyem5paDM3RFhvUUR3Ym5qaER3cktVN3ZNb1pDUUR5?=
 =?utf-8?B?bWdqTzBqOWtqaTNWdEtxTEVzQkR6ZEtxVWwxSWdCbDRXd3dJd0dscWQ4aUdn?=
 =?utf-8?B?ZGhmczAxbENFN3Y0eU9pQ0ozVVNYTG05R1VnN1BiUk1SZFZZWDRQSUludkpt?=
 =?utf-8?B?M1pyc1Q2R0tzOGlYdmExU1NkbkZ3eU5EY2JpNzhoYUpGZitQM1pqTkN6S1hI?=
 =?utf-8?Q?qSpnh8uTeOF1f1tc3fHut1Dg+YCYtqS74QhBc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ekQxTEduN05zRVYvbnZqcUxvQldGR3JkV2Zqcktkc1d4SGN6ZHZWcDFjUVNN?=
 =?utf-8?B?a2tCR2w5LzY4NStsSVp6YkRvR3BTMnI3V1pVZHpYSUdWeWFnU2JXbDIrZ1lu?=
 =?utf-8?B?R1Q0ZWJsRE90SUxYNWZjamFOQ21mZk9qb0g5NURKeHkvYlBlU1o2NDdhNFFN?=
 =?utf-8?B?Q3gvU2dyMHZjMEU4ZjVSTEVmMjNGMTZnL21ydnZzR1haWDJwejNGL2Zrczd4?=
 =?utf-8?B?TTFJaFd1akMwU3hZSGFiWk9wdmxJV0IvZXRoeE5FZXVWY3VETXRuSXF6dEhN?=
 =?utf-8?B?UjhzMURwVXIzTnhzY3ZwWG9wL0dORWcxRjNLcGM0T0hiSVVGQ2ZZVnptc0dF?=
 =?utf-8?B?OWFDeld3OEUvcmRabHcxRmFsa1Frd2hWV1hEUTYrUDRpUkFuMElxU0ZrSVZN?=
 =?utf-8?B?OHl2aGdRdi9OU0xGcGdNOTZvSXJtSTQrdWQ3Y2ZINFdmc0JoYllPRHRWckNz?=
 =?utf-8?B?VmlBU3B3VlRKZlpPS0JkajNBbzFCN0l3ZzVIa1hqME9NaVlqS3B0d3djb0Yw?=
 =?utf-8?B?Q29HTXBQR3JRb3N0YmRlRG9oTWVjUGQvckNDMFdoVlhiK09TWjRiblNveWNL?=
 =?utf-8?B?L2JkREpjc3lBdGR1eWFnejhpdWdXMVZIcDhmdXhJcDdtZ2RUTEZKTjZXR1la?=
 =?utf-8?B?aEJZLzUvVDREMTNsSXp5NzJCa2JDUitVdUJpRDhBSWxlZXFXTTJKTXJOMTBt?=
 =?utf-8?B?UGdJU3VEbGt1ZjJuYkpsOXFTLzZGZE9EVnMvb1A3aGhsbEx6NndEV1FnbExx?=
 =?utf-8?B?c1g4ZE9LSm9ndFY4NlcvNTBYUDdlejVKMDNlV1p3YUdoVVJmY3JPaEkzeTQz?=
 =?utf-8?B?N25lY1BQMGpsL0ltaXAxUnQyWWdnWmhscGgvOEpzeXA0Mzk3Z29BMWhNZm1l?=
 =?utf-8?B?WmNGVGR0YVZGelV4VE0vV2cwM0tHQVV2Tlh2YlpnTG5JNXlQYW9SR3ZvQVdw?=
 =?utf-8?B?ZGFWTXoyalhYZFVuVVRiR1BNckMyYUwvRFdZRjRHcU8zK25xMlFmT1F5b3o5?=
 =?utf-8?B?eG1NQ2gxQUEwRDF2RlQ4enhUNHFUanhpVDhrLzVnZFFSelJGY3UzMVVuVEtp?=
 =?utf-8?B?Y1VjUkh3NndsT1VaN09RYTg5VEtYOEoxUTBnc2hRSzgzZFNpTm9sRWpmTmxm?=
 =?utf-8?B?N2UyNDNHaWI5Yi9TQ2dSWUVIUjIxQmluWnorQnRCZzEzRFk5RmJ1WS8vd3VS?=
 =?utf-8?B?Um1lZkNkSWtqelNJOWZOTVI0Z1JES2xUNHhuRFZJMDk0NlpaRVRQM2xkL28w?=
 =?utf-8?B?emNYMHJoNmptQ2VBUDFablJzRDYxL2ZHWS82eE5Bcy9welp0VklUZ29sK0Jq?=
 =?utf-8?B?UGNTc2h2MTVHT3YxZkJNSG9oY3QrZER5ZUt5MTRBaENxUVljVHg4dnFVT2pl?=
 =?utf-8?B?WGFkM0dqWjlYOEM2VzUxbUR4S0VKUjFRNFRBOG4vcWVSMVMzbEcyOVdXbmdw?=
 =?utf-8?B?eks0NkVMem81eS9HSGJ3Nm1ITUYzRk4yK2tpTHJxZndWUEtScU5Db1BITnNM?=
 =?utf-8?B?YnV3Uk91WjJnbVduUTl0MTVUYkZabzU4NzZicHVBL2lkYmlONXJJOHBScGc5?=
 =?utf-8?B?emtUdUZpWTI4UmRmUE53RncxN2FsYk5janFjREtoSFBna1dUWEg1amUxYWcy?=
 =?utf-8?B?elR1RVBNMnFDQVlWbG9SOTFESDJmUG9hUXVya0xyblJDOVZzUFVkVVhseEQx?=
 =?utf-8?B?TS9xTzM5RzdQVzhMTHBrb3ZXaldmcjM0bnVpU0tBS3RGT25HN2ZaTHBGNmhB?=
 =?utf-8?B?eUVlZGZLYUo5aG4rNzJpeE05NE10UTl3cm9jemJnUEh1cldkeFFlNHJGdk1m?=
 =?utf-8?B?RzJZaFlWRlhjMUFXWjBtT25LcE5ZcnlvYlpQMzZCYlp3TXcrTHpPdzF5aG16?=
 =?utf-8?B?WURFSWxjTzlWVFdNSE5xcERVU2pFdHlxWU5YdE5HampFbWx2MXBiWGNsekNp?=
 =?utf-8?B?MG5GQjZ6b1RuTW9pRWJmRGFiNFp4dE1SM1RtNlVBL2IrQTJaeUNUT3p5WHNJ?=
 =?utf-8?B?VlBUR1lrcGJ3Q29iSktkRllEK0cvb1FFcUVDRTFGVjJ6bytaVEw3QUc5dnZp?=
 =?utf-8?B?bzFaL3dDU2w4aG5MMytNTllIRmJjakMxWnBEaHNBckhDcWhTdW0rSVNEYk00?=
 =?utf-8?Q?OnMVeGeBeWqR2oeH6D2P7Mtpd?=
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
	aPUeCWnriLpJeGhaMdQMYsm0kTPg2/TDhDJOHrm+X5p3caelpv/CfidGI6lX8nUemyDSrqMdWcx6B0uK1PQuvfL4YKdmhS7ZUwfdLvFXYQcRuWQqPoqrP7Pween7U6XtstgQnqTnVubDEt25zvxIakWg+AGoO2vyhO4NPzbj+8XGhqwPGM+XKYd8d5afmUVemjvaQv2Ad3Z2DJws9ZymFZ5uGCyc6w5aIhAsHOBQDxK0fMwH8bz3noY/BeVRVq1dD7Zz5M4FYbNdg+Uj0XV6mZFe6fCiWPEPjGEIp57mzd/UWuFLomPl3ek/QzPV05SotQMl2o23m/d+VeB2zGCixDePO0ohWSZhX3DIokapsvlAKoREgO6FbI9LB7SYw6oME9cyjh53ndoYWY68aK+g4gMcHupMJ+bBlBRVNngRmve+RXjCf/hU2uOjLTlaptrSS+ySW7ZiHVhnPpzhjuiMZ1TifbE/XoUdqDUU+mFzRi3I7ejVRWYie86Xyqgkn4T1rNy3ghKxq3cY8zDCBBbYnafu4TTDLp6ANzdZOaMN2ah8WWktCKG5cTOXR0xz6PQ0yTNN81nK1+M3a/o9HwMjqdLhz927L3YogKGdzDUrRtM7gQGgKFbAHeJZgaPlWuVk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539b6589-0b86-4545-5344-08dcf25f3212
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 06:03:05.5369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /pNQFWLqJv2625CB9LXh43kL77peyAi7aDg8IK7RTdrwD1Hemr+MSH7h7loc9K9mpSzb38EMRyIyTaAuwI4jcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7109

PiBPbiAxMC8yMS8yNCA1OjAzIEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBAQCAtMzEwMCw5
ICszMTAwLDkgQEAgc3RhdGljIGludCB1ZnNoY2RfY2xlYXJfY21kKHN0cnVjdCB1ZnNfaGJhICpo
YmEsDQo+IHUzMiB0YXNrX3RhZykNCj4gPiAgICAgICBtYXNrID0gMVUgPDwgdGFza190YWc7DQo+
ID4NCj4gPiAgICAgICAvKiBjbGVhciBvdXRzdGFuZGluZyB0cmFuc2FjdGlvbiBiZWZvcmUgcmV0
cnkgKi8NCj4gPiAtICAgICBzcGluX2xvY2tfaXJxc2F2ZShoYmEtPmhvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOw0KPiA+ICsgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZoYmEtPnJlZ19sb2NrLCBmbGFn
cyk7DQo+ID4gICAgICAgdWZzaGNkX3V0cmxfY2xlYXIoaGJhLCBtYXNrKTsNCj4gPiAtICAgICBz
cGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4g
KyAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGJhLT5yZWdfbG9jaywgZmxhZ3MpOw0KPiA+
DQo+ID4gICAgICAgLyoNCj4gPiAgICAgICAgKiB3YWl0IGZvciBoL3cgdG8gY2xlYXIgY29ycmVz
cG9uZGluZyBiaXQgaW4gZG9vci1iZWxsLg0KPiANCj4gSGkgQXZyaSwNCj4gDQo+IEEgc2ltaWxh
ciBjb21tZW50IGFzIGZvciB0aGUgcHJldmlvdXMgcGF0Y2ggYXBwbGllcyB0byB0aGlzIHBhdGNo
Og0KPiB1ZnNoY2RfdXRybF9jbGVhcigpIHBlcmZvcm1zIGEgc2luZ2xlIE1NSU8gd3JpdGUgc28g
SSBkb24ndCB0aGluayB0aGF0IGNhbGxzIG9mDQo+IHRoaXMgZnVuY3Rpb24gaGF2ZSB0byBiZSBz
ZXJpYWxpemVkLg0KRG9uZS4NCg0KVGhhbmtzLA0KQXZyaQ0KDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBCYXJ0Lg0K
