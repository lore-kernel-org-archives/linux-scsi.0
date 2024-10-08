Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB4413AA45;
	Tue,  8 Oct 2024 10:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728383120; cv=fail; b=hn0cnqBoaSBD3eptzk39L1mLbDwAx5kEAA3E9XZ0jLu4/M6ra+MpmmrAf76BvsqjC9EklHSykdBxwuwZMvDCP4ZZ6VGVqVfO/SVbfkv2460kKlggRb+h+rSpMsSPo4kfH8huKH6cEdcstX/Rsk/ELjm0SRNprmpF0VHDJtsroUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728383120; c=relaxed/simple;
	bh=9awLBfqncFs+fV1SctfpDH/2KeRYIPD4doD2L6SwwfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gF+B+ZlUDeKTEU34olJ/LRXTk6O3thWIR7dpF2n0rn4mVTIaP9RSqRRPO2YsdKn2qXfg0ll2iiWQoCDqGt7/vF7bWQlow4ybFUxG4c9eC3Ed97asWPoKc8Ic2dEEZjj5fqwOyCBHKKKjSC7brtnxt3v5EE3rih2NIS5ZejdBYEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FHb0JD6O; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=tF9gH8MR; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FHb0JD6O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tF9gH8MR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1728383118; x=1759919118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9awLBfqncFs+fV1SctfpDH/2KeRYIPD4doD2L6SwwfA=;
  b=FHb0JD6OQ1AhbBd3F8iOGgiogzrMwtE9IdBGfiOVBh7SstBivj4yUYUj
   X2kiswnLLnmreDLXGbfgh+ub+asbMU+3khPT/sorGPE0jD4PYsiOieyLT
   Q/+IAZktVRZhEU3l26GP1XaXtiq3IxtT9HXaz/fp+8FanIe9CVOzyEnW/
   Xn7Wz6DIZ+yhX3oTWZSaUtfGens4X0GfirKq/X/xcL54VBFZfMSFEZ2JY
   bIbI815FBvvqXxkerJ7aam9cijRbYxHrFVZHVG95ykH9CGwn15lrJ1WuA
   zaGVmvsBn72TCpcthpmrh5JNJ08e1HRPIQAKbZjdzPQ2tvcREqTkhA2Bw
   A==;
X-CSE-ConnectionGUID: nmqivbk6Q8aGmZ0giSH5ZA==
X-CSE-MsgGUID: XfurGRn+SBaqB6ZBTvnh/g==
X-IronPort-AV: E=Sophos;i="6.11,186,1725292800"; 
   d="scan'208";a="29565596"
Received: from mail-dm6nam04lp2048.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.48])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2024 18:25:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bw++td/LOl6REPzxq+VgUgpsynq11efhIL03R+FuSuCU5fVSp298o1BYHp/DFRy8jkXbjmRUQMkpat9a+KHTL5RjTdUrDygyPV6RGYp6fvAYLhBZ9dIZT8EsuNQRTpUeQYK/HGcq6/rx9mSOCMTfVo8zdPQFZeq/FH0uJTatMm6mOzweoQ8CRpynntlOOFgTfBeVwtWcFi+Ti1ZrWTDWZajhTWaX1SzexS7vV+HIqCm1CmPR/aQW7AvLv/v6t4q2fbTz6tSegWLMOdq9y7lnzB2x4QnAO1V+6bXnlGQ3buotwwpZIxjW+1iQp0IFunAZJQad0+A54NUoepKSuDNZVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9awLBfqncFs+fV1SctfpDH/2KeRYIPD4doD2L6SwwfA=;
 b=xdPMXSnSO/2pH591K+dN5xCD4/44FZhPoaxMfKiHnyw0BkpRYx2nM/iPd8ingroe/aiX8N2YSAtsC6/VxCfz8YmtDPRIhuoMLz1xbgfO07oFLhqrLon/+liHMTBDcKC0tFgXZZXzF2lmPfKfJwn2fzJS7+djRcjdtLu4KKiVMnSVimgZ09j18rRDfvO9ywJkneaRUDpmp75B8w+5SyBNfRzft63dEwDsA1+J60tmuEhMPcFS5c3lpOARgzUVqV8kcNHTBU78zkEE7P2JytDPRBQKEIiaDsxOBjCsMlQyeyy8ggRTAO+7PpmSVxjzfHi33RXVwe0Prhg6Zs9Jd7d3UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9awLBfqncFs+fV1SctfpDH/2KeRYIPD4doD2L6SwwfA=;
 b=tF9gH8MRiLcKnLL+lJJ/M05abbtqNa2XSmF0QyB3fmU4j/HrWhp9C472E0uRFvo5gTlxswapghmBFgTAtT5nUV38osStDMKIXdIZ964s7qdeNCE+nYz6XBEFoAKoYE34PmbvYUXQtH9qOPrn8pGjoB9NKQzgPB5f285u3vn1zS0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6520.namprd04.prod.outlook.com (2603:10b6:a03:1c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Tue, 8 Oct
 2024 10:25:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 10:25:09 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, Satish Kharat
	<satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak
 Kumar <kartilak@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: fnic: Use vzalloc() instead of vmalloc() and
 memset(0)
Thread-Topic: [PATCH v2] scsi: fnic: Use vzalloc() instead of vmalloc() and
 memset(0)
Thread-Index: AQHbGWfcL4/KbKqeoEeOKGGJF7XcnrJ8peOA
Date: Tue, 8 Oct 2024 10:25:09 +0000
Message-ID: <596a6bd4-88b3-4836-94ec-b2930c9b0062@wdc.com>
References: <20241008095152.1831-2-thorsten.blum@linux.dev>
In-Reply-To: <20241008095152.1831-2-thorsten.blum@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6520:EE_
x-ms-office365-filtering-correlation-id: 109e1d80-d417-42ec-9dc3-08dce7837c84
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q0VCSGZwRVprVWg3YXdOSCtNM3J0NjNBeldCanI0R21FMkorNDFjc3dwdkZI?=
 =?utf-8?B?N3NackhBcWRXNEo3NjJpRk5MVzRReGZ0ZmpDdXRHVk91QmJqMUtHK1BTZTh1?=
 =?utf-8?B?eG54TFpoOWRPdUZraDhGRjIvVGlkYVdEakdjQjZ0NEYreWpXbm9lKzN5djlR?=
 =?utf-8?B?YVhhMmtDOG83WU02SzYzNk5ZZmw3dDU0Y0NVZUVjeU5mWFZ0ditNcVNHRTVj?=
 =?utf-8?B?UkFsc3h3UGd5WDBJdVI0Y2dpaG0yNU5OdTZwaXRIRFVaUk9SS1hPRzRMbU5E?=
 =?utf-8?B?M1lhWjhjbFZlZkYwTGhjSHk3Y04wQUQ5elBBdGhvcmIrNXRXK25FK1p1YlJ1?=
 =?utf-8?B?bkZ4ZklmbzA2VEY3Z1I1cE51a25CamUzeXB5THFqcmVEelBKQmQ1T2k1UWd3?=
 =?utf-8?B?TjVkL2h0eXJSTGlWL1duYXlWUzkrT3o1Q21pa1laNVBGUEFPWjdSNDBHbUQv?=
 =?utf-8?B?WjdwdDRxWTIvZ1VGYnFGRUozb3dLaElxZ0pUOUh1ME9mRzlZRmZTZXlxOWMx?=
 =?utf-8?B?eDhGdXRBMG1nc1ljM1FhWTk3MXFXY3NJV2Y2YnlNcVVQRnJGOWhJc1B4U0dW?=
 =?utf-8?B?N2grQW5lcUdWZjN0RDdpT0F3NFR1UmUrdkhEblc1QUMzK3dmZUF3L0hwYVc5?=
 =?utf-8?B?RzdDNk9FSlNEYWx1ckoyN1I1S25qMis3enBSU0VnQkZlL1haaXcxMVhVQlZ0?=
 =?utf-8?B?dDdKNlRUTVk0aU5OeEprVlZEZzVVRk9wQ2k5K2E3RDRiNXFQeHFPcGtVL2F5?=
 =?utf-8?B?Yk1VU2ZncjJncUNRMXRDcFRLekZHTUdueHFSRU9tdHhSUm40alNEcGpFeTU1?=
 =?utf-8?B?K2xXWjhhZDVOcnYzb3BHRUd2b3V3YVFaajZEZXR3dHdHc0pybTVMclhHeTJj?=
 =?utf-8?B?T1g5L2FCNTRDTnQyYUthYS9BOFhGNXRhaStKbFZNbTVRRmlUUEFvTXVlNHE3?=
 =?utf-8?B?R3hiWUFtVHJnWjBVdGVMRzFnZHM3UFdnMHV2MWhVYVk4dUZsdnBTOHl1MTVX?=
 =?utf-8?B?WjgvTTdlRU16a2h4eUtQK0tDaHEyaE94WmZYVFptVkNPYmFiZ09wdWRldXZV?=
 =?utf-8?B?L3RuY3lKYVQyb1JpMm5iMUV1eEY3L0tLcWlvM3ZqM0NEQklSalZVUXV6N2xj?=
 =?utf-8?B?RkVldXVwaUI5YnNDaE1kWXlpb1h6aHp6ajNNMzdxTjFIVllwZE15Z05Bd2tl?=
 =?utf-8?B?dFNuWmFPSlRSQUR6aE5zYnlPcXd4anRnejFSNnd6aDF6aWlLM2x1U3lJZEdm?=
 =?utf-8?B?em9QSXhBRWUrNUNvUjFWZ0xrMjZ6b09MTzA5SUJRdlBwYzd6aVVMbFk0VG0r?=
 =?utf-8?B?aG13VEtSbnFUbmhDOUJyT1ZNUXgzNXFjMmhxRGpGSjdTWFJMZS85SEp6SER3?=
 =?utf-8?B?VllYRWtwMWRwTFdhL0ZnYW54YTdjRUwzU0t1SjlOQTBhM29KK0IxK0dvdERo?=
 =?utf-8?B?dmpCc0c4RFRRMVZnWjJRSUs5S0VjRUsvVHpwL0daNUl0K3pqNUFTZ1JXanRp?=
 =?utf-8?B?RnZWQ1AvalVuVzIvNGxBOWhtSytQQkQzNi92WnI1UGJ0dHhESUtPcDM4TEZr?=
 =?utf-8?B?ZmhlWU0wK3htTGV5Z2dTR1N1QVYvZUY3dUhnTCt2Q3BvREhPRXp4Y1NJV3B0?=
 =?utf-8?B?T1p4aE54dmZVZkN2bmN3K0I0eWtpOGYvQmhxVytMK2l0aVp5aDJOdklRbVBL?=
 =?utf-8?B?VzhUcDhTNnh3ek9BcjkxY1RITWI3RjhTbzVWU2dJMjVJcHV3cm5rczNDY0g0?=
 =?utf-8?B?VkU4ZVhnRHduNUQ3YXRML2VlVEwyTHgyT2pqcmNGWmNHT1JNcjZESTc0R2lu?=
 =?utf-8?B?YWM3M0lmTVY4cm9rQUlWdz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NkJUeFo5TmFJWVJZSWlCUnhtV3pYWENlSVpvWU9SNUtCT3AxZW5hdjFYVUNL?=
 =?utf-8?B?K1dZY3NzS1JYbDBKY2s0UlV4dVcydUVMeThKSFQ5blE5Rjl5SEFKRzU2NDlL?=
 =?utf-8?B?YWtQK2ZPWjBNaDRJMkVWYVVyY2plQ3MxdXVyMUlFZ3FkQ3VVODhPWnE3NkhY?=
 =?utf-8?B?OUhnL1RYZWJsM0ptRUxhYUdVTVVzTE5hYnBCQkg5OG9CM0JEWi9wNTdiMnA1?=
 =?utf-8?B?REhyZExaUGJhdGJHU2Z4M1JUcDRQODdSVEZReDlja2RsSVp6dDlPUGs0RGly?=
 =?utf-8?B?dmtQRUxnRTkwWit1VmtsQTJaUmlsd1J2Z3c1amcvOHdCOXcyVENkcE5DWHIz?=
 =?utf-8?B?T0RYK3pCelJTZVozUUZoelVpdThObG5KYWE5eDFsZVIrTi9JWGNqRUZHS1dq?=
 =?utf-8?B?ZHUrTXlCN2RuRnVBS1E4Q1ZXMnd0cDNBWFAyL1dtSlBCY3JGZXIxMi9NTXZR?=
 =?utf-8?B?OUU5TjRGcEFjc0FWMGxHaFRuMmlHZ0JkK0tKZm42Um8rSFdqaXJScVg1Vm4w?=
 =?utf-8?B?Z25waXNKSHQ2bTM2MmlFb3RROTVaVnVYbVdublZ6T0o4TTh3SGg4UkhYVkQr?=
 =?utf-8?B?d3g3MGR6ZHcwYWo5SW5YUE16elRkcEhONEp0OEg5d2FmdjBnTnJOb1RqMzhv?=
 =?utf-8?B?VTUyK2JESnVQV0hKQWdoZWlHaStFVjErbnF5aVErL0dMVFNDK1oxNHFORXIx?=
 =?utf-8?B?RmpDaGVxcERaeEVhcEJScjlEQnd6L3dEQzVjUzcvZ1hUM2VRVWRtK012MUQ1?=
 =?utf-8?B?c2xKenRJMWRKdTk3dUlscVpDK29WeEhWZGlwR1V3cDZtcXFoMGNCY1lyWHpY?=
 =?utf-8?B?VWFFVkdKaEZpRkhVTjREcjN2aHhGR3U3bzUxRWFGRVp3dHdXd3B0UlB2Ryt5?=
 =?utf-8?B?Qzc3Q3VuT3dUeDRuNi9ONkZMcVpuMUlnOWpSSUdaalZTSUZmdWFMNFZtSXdy?=
 =?utf-8?B?TXpQU2Y4Qkl5SmVKemRmeGZiZmphbVdwYXRHdXBHK0UxdUU3eDdKZkJ2V09T?=
 =?utf-8?B?emltUVoxM25jZVV1K0R5a2xBaUxwdm1LRFZrdmUyL3kvQjRqVEtkQy9LMUgx?=
 =?utf-8?B?czhqamFlemxvWm9OZDRXclZMbVVQSnNtREN5WUZHbjlpTmVScWx6eWQxVml1?=
 =?utf-8?B?REhZdVp1TDhmanBhSjZldjhBWmt1THluUXBkcHZldG1iRnhWM0M0cy9JOHBV?=
 =?utf-8?B?NTgycVBnZG8xR2Q4elNtTjFsUVVocHVKc0FhKzc0YkRXOHhVUmwzTVZEQS9Q?=
 =?utf-8?B?a0x3cHRNUDhtL3U5aGpTK3RKV2E1QVpMZVJFaklqUC9uSWtCVDF0M1Bkbjg3?=
 =?utf-8?B?TEV2SlVBZFIrQkJ5ck94N3hFWlMzRTRsWml0NG5hakJyZ3UvalFTT2FXVU1o?=
 =?utf-8?B?TWtCd05kRWhDSmJqdEp4OVpvK054VzZQSVdvUkRKVUNmckprVlVRR0tFd2VB?=
 =?utf-8?B?S3JxSlV4WHJKSEhuTHY5L2tYdkZXZThVVjkwTmRXcVFKcjMxRGJxUldFdFZS?=
 =?utf-8?B?V2xHQmdIa3FIaTZyRU0xNTYxekJmQWNiUWF6V2x1SGF2dUJvM3lpTWRGVEwv?=
 =?utf-8?B?NUQ0VDVzaU9ST2VuOTdWKytYUVBHaFBUWkw3dXFrenRIQWlpU0tlZ1kzOFpR?=
 =?utf-8?B?cTh0UlRpMkZQM3QxZG5hNnRKc09yTWRQeGpKYko1ZEhzNmNtcFVhNGVrdmcy?=
 =?utf-8?B?WElybVFUekFIbDVsZElLbWxHN1ZwOWZzTThaVURwR3E1dkN5QjJZQWZaRytR?=
 =?utf-8?B?SmRlZU5hZ0VHdUJhZVJEMXlDZzhCbkJ5VDE3Tmc2dWlGdXI0VWJJdzZVR29j?=
 =?utf-8?B?UU0yaUl1UHk5RmhqcGEzWGxiYmpLTWw5cXNWcWw4czZxb0RKN0lXRmM1eEF4?=
 =?utf-8?B?OHYzelN6ckRqOUQwb2c0T3VkSnUvT1MydzgyazhjQmR3alhPWXQ5RzlQaS82?=
 =?utf-8?B?S3lta0NDWkhDcmQvRmt4ZnZYR1B3T3J1VitMYlNJQUJDTnZJc3NhMUdzZ0dI?=
 =?utf-8?B?Zm0rZTVGVHdpdWZ6SEFEQU44QW41YVJZRjhjYUQ3djJWdG9JMWtsQlJxUUxX?=
 =?utf-8?B?Zi91bCt3RzZGU0pUNlJwcVZ5Z0dlblozVjNDaTVvUEdOcFlvOW1iUFppQk5I?=
 =?utf-8?B?bVRFMUQ3MEtlOUg1UEhKWUo0RmhQbkVLYmtEVlJDcUo3SVMrZlJDbWUvVDZz?=
 =?utf-8?B?anlwMEZJRW5jV0p4MnVQWC9YQ2s5ak94UnZTU0srTWhjaW9jS3FyS2VKdjd6?=
 =?utf-8?B?RnIzaVdPRW5pRjVKUGF4akNLMVZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84AA3C54C6B17B4AB89149CCE9857BCF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hfJE/D4gu6F4Z77VKrBagHaU1LoltS7fM/ZFCakJKuWl3r88xLUWX0psJmPg5xhWUWz5SCK3WqOR+5ONgiRMJcJAST789znBCSvPegVE9ZHOr/pLVdA71ai8G+UZdaUfxpSMxIBtCsM0TP8lC2UZlcv28eO62u+J900YHxRsidNXpl/F8NeYyx0pCU3FVdW2h1bdJx5mT+iBJXWjHNgGk2XFzT1RyEDOH882eKmaIDkvlbQA0VdZWv9YFBcwPWXK6ASkK9ZeZcJPtIx0cl8j5ii0SHU8kwVL41rrr4GnXySecNkXchP6w9aRvb0/qCEkXemsJrzSMfIF2hiG65+iv9WmpPagO/TSpGasCbOxw7CDhUdvbQ25dFTIt4WVIadUkfenwVxMuXtnAEAvI7kqR35/QlCQysPNrTXP8nuVLCQXQqy/kBuLCJJr0UuN+6mm25ZRkDtJ+cSMSZqJcbxZuMEKZQNa5bwoYqvdi9HR/sIDVFCqvtlUvZjgiSOGMKnZAflrnw2YjsioksYQLQcrOVCxGHXk7O0rjySokJNQtsDUkucnDp+yVtGmSii4zYDkF7C18WrAce+egHVN3LaPmY5IOqivmXmabnaK11b1q9yTMtNkzHa9XTfW9JtVUuDp
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109e1d80-d417-42ec-9dc3-08dce7837c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2024 10:25:09.5157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XLAMP3LU9uf4ZoX5N/3MdXq586KbPdnLg44fnDw9l/a+8otw1/iyIp+PY7HYlszNe6zRrHx7krH/gqqFiVJhKVnYyEsHMvrhmSNA6ogPdH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6520

T24gMDguMTAuMjQgMTE6NTMsIFRob3JzdGVuIEJsdW0gd3JvdGU6DQo+IFVzZSB2emFsbG9jKCkg
aW5zdGVhZCBvZiB2bWFsbG9jKCkgZm9sbG93ZWQgYnkgbWVtc2V0KDApIHRvIHNpbXBsaWZ5IHRo
ZQ0KPiBmdW5jdGlvbnMgZm5pY190cmFjZV9idWZfaW5pdCgpIGFuZCBmbmljX2ZjX3RyYWNlX2lu
aXQoKS4NCj4gDQo+IFJlbW92ZSB1bm5lY2Vzc2FyeSB1bnNpZ25lZCBsb25nIGNhc3QuDQo+IA0K
PiBDb21waWxlLXRlc3RlZCBvbmx5Lg0KPiANCj4gQ2M6IEpvaGFubmVzIFRodW1zaGlybiA8am9o
YW5uZXMudGh1bXNoaXJuQHdkYy5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFRob3JzdGVuIEJsdW0g
PHRob3JzdGVuLmJsdW1AbGludXguZGV2Pg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLSBS
ZW1vdmUgdW5zaWduZWQgbG9uZyBjYXN0IGFzIHN1Z2dlc3RlZCBieSBKb2hhbm5lcyBUaHVtc2hp
cm4NCj4gLSBMaW5rIHRvIHYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1rZXJuZWwv
MjAyNDEwMDcxMTU4NDAuMjIzOS02LXRob3JzdGVuLmJsdW1AbGludXguZGV2Lw0KPiAtLS0NCj4g
ICBkcml2ZXJzL3Njc2kvZm5pYy9mbmljX3RyYWNlLmMgfCAxNCArKystLS0tLS0tLS0tLQ0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfdHJhY2UuYyBiL2RyaXZlcnMvc2Nz
aS9mbmljL2ZuaWNfdHJhY2UuYw0KPiBpbmRleCBhYWE0ZWEwMmZiN2MuLmMyNDEzZTBlNGVhYSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY190cmFjZS5jDQo+ICsrKyBiL2Ry
aXZlcnMvc2NzaS9mbmljL2ZuaWNfdHJhY2UuYw0KPiBAQCAtNDg1LDcgKzQ4NSw3IEBAIGludCBm
bmljX3RyYWNlX2J1Zl9pbml0KHZvaWQpDQo+ICAgCX0NCj4gICANCj4gICAJZm5pY190cmFjZV9l
bnRyaWVzLnBhZ2Vfb2Zmc2V0ID0NCj4gLQkJdm1hbGxvYyhhcnJheV9zaXplKGZuaWNfbWF4X3Ry
YWNlX2VudHJpZXMsDQo+ICsJCXZ6YWxsb2MoYXJyYXlfc2l6ZShmbmljX21heF90cmFjZV9lbnRy
aWVzLA0KPiAgIAkJCQkgICBzaXplb2YodW5zaWduZWQgbG9uZykpKTsNCg0KU29ycnkgZm9yIG5v
dCBoYXZpbmcgc3BvdHRlZCBpdCBlYXJsaWVyLCBidXQgYWxsIHRob3NlIA0KdnphbGxvYyhhcnJh
eV9zaXplKGZvbywgYmFyKSk7IGNhbGxzIGNhbiBiZSB0dXJuZWQgaW50byB2Y2FsbG9jKGZvbywg
YmFyKTsNCg0K
