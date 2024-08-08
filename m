Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345D918D651;
	Thu,  8 Aug 2024 11:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723116737; cv=fail; b=bCnRqT7mB2nYvH0Xm60vKekE4n9wjYAOjyzZ6jNCThGeGdG4soppMfLrQlceo546q/MaHDbVoIE/jP9XJgP4rVuzD6kQ5T/4iFkkuMR5XQveCqK0xUA4Mfa4nrnPSrA0+wPFgKJAB8FiM32cN9KuFw8aoZS2pyegxZCAypLaL3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723116737; c=relaxed/simple;
	bh=177P1HPFIFtZ5UdyX5CUXmM/URI9+hPj5t9PKBRh+h4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FxrhX+1rDGWpz/tnyiUCkMHnRn2TtgqqNSf21SSILbsRCaqyyiD15w7BqYQdQmEirGjrDAdbb7joO0k4H7+Eo6bwHGT4Uy1cK+3DA/XLVfaZnYgqsqIq35iBhTZKGI54SlRZ6/d8CRh/VqU39qIycAyiFntfvVE2y3CZbLtxYac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FvtTJM/m; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=TSnmng84; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FvtTJM/m";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TSnmng84"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723116735; x=1754652735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=177P1HPFIFtZ5UdyX5CUXmM/URI9+hPj5t9PKBRh+h4=;
  b=FvtTJM/my9kYF6D7r+vzv9jnCegRo6zMaLLiLjbdoI/ZcD1VHOj0jJeg
   HSLNY9dcbQBNMw7u+6tcel1VW3sqbpjkT5BLCXAWtBlAfrXXMy9lvsSJ2
   EDxi6G+/pC6aDhDXBu8oYB1ayxFjSw77dKFss7qHpCW9lcH/9l+1iFxOr
   /fJ/bYu79heIhto6xs41XouSLl9zTC6IiQAswsQEG7x8VHbyXjEOpqPZu
   DqIDKF0xV9WRzpIaf3apakV534u9y9tWwT8+HBku3BscFzLQqBypbOf13
   wm21UQ8e75FCYfun2RyhRUZ47v1gC7VPx+mUp9nIuaGbPlzyzNvgFiGQC
   A==;
X-CSE-ConnectionGUID: NyATLJbFTruBjSckUp+UOw==
X-CSE-MsgGUID: AWwAlzt1Qjq7TH6FjFanZw==
X-IronPort-AV: E=Sophos;i="6.09,272,1716220800"; 
   d="scan'208";a="24080817"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2024 19:32:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpTMWEDL9R9Hsl6sfOAlKamisbUzQL/6V1NZTW188Le3s2KHyuzxHitH9+U3352n/MngLO/z+eKJqTvyRk1gRMgZZ2jsDcKwIna1ERgUNWEobrUggW/o4Yv5hDnNZj2caRkbbLZOPSWFL8eF5OZqZcpugIgPi1KvlcmgHAu9WvLomDU+gaJ7er+Repp4KKnRt/fvhgvw5d+WTz8JL7fIcsO8RG+j4tr5DMkT2X7MCpXqvtZsHsKP/4Mlnp6wmOPRKNtecgqN48qcip6XWeYAzFlamMo2rAGGs4cc6NpzRS47xE7740Xa2rE4RUAaUm+cQhEF61IfDyEPXqI+8OE1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=177P1HPFIFtZ5UdyX5CUXmM/URI9+hPj5t9PKBRh+h4=;
 b=eS8Vh/nXZbF7NLtS3EdjaJcUdzzkhDMu1cqio8VXaf3RJI3Mxj1PzGilOKWdyIV3Gvwo9psMKrNS7B/ljD7YGzviiXXZ6pfPBwBHJY8EVnwfTjubHWKsEkmVd+kI8MrkGIGTuDj6pQofRkWRTZWX6ZqeofgBn733z4C6iBvDpjHuNpuNOllwxIGdPG0pWEFZ0x1wvHIlZubLFIRs3m/WJoZ54BaediXnHZ77vl2KnTq3G9Qql7DS0arKmj+ZkAWcRbj4XQb/uKklBdtWZKPaePBgYLmA/55k9oBG5F3nmW6/XSjUequi8PZu8jrMUNIZTAwYww+3icuQO3oTUF9Uug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=177P1HPFIFtZ5UdyX5CUXmM/URI9+hPj5t9PKBRh+h4=;
 b=TSnmng84dI0wqgnOBRgex4rO07KIsNVxnagtrmvkQ0nopnmeSixktiM3hhePLyAvLDbP45B9TeuBc/IM0MepWsCJn+8nziDh6q8QMUQdLtBES45YKeIVUUVRqB0JaHpJM+S3IxfnC2JxT5TBxN2Af5ZjgTKSOad5NkEjfP2ekdA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA2PR04MB7721.namprd04.prod.outlook.com (2603:10b6:806:14e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.19; Thu, 8 Aug
 2024 11:32:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.7849.008; Thu, 8 Aug 2024
 11:32:05 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] scsi: ufs: Add HCI capabilities sysfs group
Thread-Topic: [PATCH v2 2/2] scsi: ufs: Add HCI capabilities sysfs group
Thread-Index: AQHa5j8a0OCEceXIRE68E3lc5ZhnrrIcS+kAgADzTQA=
Date: Thu, 8 Aug 2024 11:32:05 +0000
Message-ID:
 <DM6PR04MB657591C5FD3C16AB0864FA6EFCB92@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240804072109.2330880-1-avri.altman@wdc.com>
 <20240804072109.2330880-3-avri.altman@wdc.com>
 <28624a6d-fdc7-4458-8e8f-f8d764cd4b5b@acm.org>
In-Reply-To: <28624a6d-fdc7-4458-8e8f-f8d764cd4b5b@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SA2PR04MB7721:EE_
x-ms-office365-filtering-correlation-id: 5c8df2c8-951f-42f0-899c-08dcb79dbb19
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aHZkdHlCeXRDcjJhNkhGaExPdGtXRTk3MkU4WEp3a1pHeUVjVlRrM0UxRGdS?=
 =?utf-8?B?c2Q0QXIxQVE3VlN0R2lreTdUQnFocFBFUVRtYUVWV1NTcHg2Mk9oSERnVTVZ?=
 =?utf-8?B?emJVMC9ON0J1dlg5UlNCQjBkM0gzcmgrMk1obnRvVWZTcGdqcEk0SDdlL2dh?=
 =?utf-8?B?Q0pWelNvelgzQ3FhaGVSdWZYMTBzQklYSDRvN1Z0ait5aWJRWXNtdzJLbkVY?=
 =?utf-8?B?Yk5hczQ1bDQvZ1JpcVYzTzN6eWs1cnNtNEZQdFNjWWhzQnI5cjVMY1NRaWRs?=
 =?utf-8?B?SFk0cHNJS2NLeGxFRE5hNnFCSCs4L0VjQjlaYVE3QzlDOVdUSFZmUC9hWVhF?=
 =?utf-8?B?Z1cvc1Y1ZDZheFpjVE9lTlZIb2NvWGkrTGp3cDNqYnljV24yb0xlRHFuUFRq?=
 =?utf-8?B?Z2NoZkowVS9vc2pMV01kOUMwc3RjbjdWUmtjQWdTdyt5SVBONUJJZGJuSXFU?=
 =?utf-8?B?bFd4VEE4VVdpL0ViK1hwVzhPYXhjWWRBNSszQ05iMWdCM2dpRTA0NnBQZXIv?=
 =?utf-8?B?L1NUaVEzWk51NEV6cUF3b3o2TXdUZ2ZOZXlQTUZGdm5wUkFJUWF2cnZuc2ZP?=
 =?utf-8?B?OWNYd1Y3bHRaeEdHaTUvTUllVHVqUFdJMUdKUUdDQ1hzWmsyNDZzOVBzS3Bq?=
 =?utf-8?B?eXFzM2dnN0U5bHl6ZTk2WVYydlhqZGxtYjA1TlFISUYvWDVCdmxFVUZuSkly?=
 =?utf-8?B?LzBYRXJCSnIyT0U5eDN4ekVWcDg0dGxLYnE3a3lEU0NFMGsyRUJDM3JnSnJD?=
 =?utf-8?B?NnRnQ3E5Wkg2eTgzR2kveEQ4ejZNeW9RN3ZNQnBMY1pDVEEyUUJLcVpVaWRM?=
 =?utf-8?B?a051MGRxZUFabEtaWGorTlZGZjVsOVcwV3dkbXlmTXpjUHlBbXNMbzFqTlE2?=
 =?utf-8?B?MTVkNWZzNnB1TkN1VUxkSzl3QXgrOXVNamNTdmJFZzNFUlVyQ0pKcVdYWlRG?=
 =?utf-8?B?RHo5VGFYeUpYYjZwRzF6QUI0dXh5Rm1zcWJrckdNNUdIV3V1ZGhTR2MwUFJG?=
 =?utf-8?B?cXIrUnBFNnRLTVM3NmEwUHY5ZWcrSS9tTGNGTGgxeW0wMTUvMTUxN0pldllm?=
 =?utf-8?B?MmRCdk8va1NnbE5VNjNySyt1ejVxK2lpSG1PMTBOL2ZpOXhFNEJNdUhuc2RS?=
 =?utf-8?B?eEM4dFdYd3BHVHoydjQ3VEx3ZytWcmxuMkxnM3JOejFoMDZmb0E0dXVmdis2?=
 =?utf-8?B?NWp1Y2tOVTNJVWhQV0taYlJjOVVtdjVNSXlROGlnbWJ1d3JnMDhZSU9VUkMw?=
 =?utf-8?B?aW50U0VKd2ozMDZmNnNXamlpTjFNZlNYQVJCRlUva2QrSUFOc2dSaVA5Skp6?=
 =?utf-8?B?dy9icmdyZURpanZsS2Y5cFFPdlBrV3NhandMd2ROalVXVm45RVdnL3BGQzVH?=
 =?utf-8?B?L05QaHE5L282blpiOVNKSm5IMXFKamJUMmIxaThFaFMwU3pCSnhLQTlleVRP?=
 =?utf-8?B?QTMrWlE1YllVLzNPR1pqaFRzMlArM2hTRytjeEZncXJWd204M21UVzVKUkZC?=
 =?utf-8?B?UTFyTDU5Z21PYVNyNXZaUEJUUFM0SFlURWxSbXArK091SDZzMTgrdm9kbVJO?=
 =?utf-8?B?d0FJL3pnQ0prS3poUWNZOURIbDBuRGU0bkY1SGI1K3J0bW9ScVRLNW9HK1lR?=
 =?utf-8?B?RTVaWW5za0JYdTlWTGlYZTdLOWFsRnpqNXdkdTBXSWp5U3hUMjNlbThOUGYx?=
 =?utf-8?B?SWtJditWclFSQWlyR2I1THUxR2ZGQUREQ1ZPclZtbkFPTWlGSWptWTB3ZDJC?=
 =?utf-8?B?Rys2djkzcm5XcnJaZTV3RzcyZUxUWmUydUo3dlVhQjZ0WGtJOGJaTkRiMWZy?=
 =?utf-8?B?YmtBTEp5bGpEQ3NldWFWaTZVTTRLaEFPQ09GbzdxYUZvYUFZOGJ1bEdQTmtJ?=
 =?utf-8?B?SlVXTnBJQkpmUW9JL0FpQ25BaVdyYnZKa1Rid2taZXFTMGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VHhqWkZtQm83dmMzYUlENzlKV3htNThwVjlPWnR5WjgyMTRWMDczTWVtREFa?=
 =?utf-8?B?cnI4ZGpmNXdmcGVoZ0Z0bGlVdldNdUtBdFdDK2doUVFHSk1ONXROYmpGUDB0?=
 =?utf-8?B?K09uREl6MXFHTS80TVIyeEFnVC9VMGNnSlkzZ3c2N1NOcFM3bDRWZkJSOURN?=
 =?utf-8?B?dXJPdWxLNks4SE9YQitVTnN2OW5YcGh1eUthdmc1d09jTG55d05hcGFJR0I3?=
 =?utf-8?B?c2xaRkRYK2s2ZmtDaFVCdjV3S1VzNFkxNnQwalpFclNrNjJ6VEVZWEMvYklU?=
 =?utf-8?B?a25CYzJNbGkrRnNOdlRhU3YwM3hVa1JsUSt6UUlWZ2d5Y2lQRi9WZ3lRQytw?=
 =?utf-8?B?ay9EdmlRN1Yvb055L2x2VTBKc2F4UGpqOExCSjBLTnZrbGNSR0wydXczelRL?=
 =?utf-8?B?allvWjByQnlHVlFGVENaUWczM1AzS215VDg3N2M2a2VjRmc0QzZsbjkrTTFz?=
 =?utf-8?B?a1NXOHJHS2lpQVBLdk10TExNMUdQeW9OakUvZ2JTK3dOODN4S2dZSGIvY2hS?=
 =?utf-8?B?MmN4c3NFQ3BUZkVsWCtldlJNbHUrb1ZUb2J6dFlGMmcxbjcwQzNrSHMyeXkw?=
 =?utf-8?B?eGNwYXFTWnVuby9yMDZHRmVWdFlxK0VCcjNlQ3d1Zmx1QmpjQk5HMVg1bXhz?=
 =?utf-8?B?dXZmbHNIY283SHE1aXZCQXdqd0NIL09NclpreFFMTWkrYmdiUjdQc0w4NWt4?=
 =?utf-8?B?K0RSRGdSRThNSVNJUlJJb0lNaXJwaCs4QW5OVFhCaHRyZkdBZGpON0UyNmd0?=
 =?utf-8?B?WVYydEdsZ242Q1J0SkRXcmpWakY4Sm5UREthR082eWFNc1R3TzJnWWR6bGwy?=
 =?utf-8?B?MXA1ZDhKeXUraEpzcVZEOFVzZXBjdGFjZk5lMFNJZUxhT1VUd2JLdXQvTUdD?=
 =?utf-8?B?eTRHSmQ3YW9lVHZnVUhFMWgzZlFVQWVOVDgzcTdkUy9iSHpxcGVDS3YxZGxa?=
 =?utf-8?B?aUU2cjY0NHI0VWVkRS9oUnBPWXhvRnZKOThQV2NOWjFPQUgxN3JlVkVCNHIr?=
 =?utf-8?B?NTR5N2lWVjFoWXltWFBra2xNckF4QThmS2Eva3ZndHBZbTduSkVoZEFkMi9V?=
 =?utf-8?B?eVAvS3lvaStkb0UzUXAvbFpyelpIdFFlc0JIVllVa1E4UUtwazBCVHRVS0Fq?=
 =?utf-8?B?Ni96RG9ZelFSZFlZMzNCOGgrSG5OU0h1Y0tIbGYwZWNjTGo2bzlkQ1JXZDhQ?=
 =?utf-8?B?OHJiYStOQWlCZWNxVjJuYSs2MjRFblhramNRYzdqT0t4c2Q2ckFBYVluUnh1?=
 =?utf-8?B?MVA2VDk4OHpDNWtSTWFCTjJ0NERKSndWbWdTa0VISjhHU0N2K1dTamc5dE9r?=
 =?utf-8?B?dzJQTXJ2T2FLQ1FxSXZaNjcxb21RNnR5MWhJT29DYldtRTVPdW82TURIWUw3?=
 =?utf-8?B?VFVkZVlLNVRyZzdmaVhrRm1RdWJLaUNEaHEvRU0rbXRsVUNUT3p1cnY1R3pG?=
 =?utf-8?B?aWkvbkcwaDJQdEFQei9zelZxMkNsK1NpL29LMTR4RVk4TDNpZjkxM0xNcHhx?=
 =?utf-8?B?QVoxZWNXWDhzaXB5elhseG9zdkpjajNxKy96SXM4WjNjT0p2RENGZ3k3R29O?=
 =?utf-8?B?U0FtRUpMUDlBTEpGUGQzKzBkYmtmMkJiYldmejZJck9LWmZhS0VUSmtTclFS?=
 =?utf-8?B?TzF4aWZIUVRuMVBIYzB3RnNTMFVRclFmcW1qckFZbDc0T1kreVFCNjJjUDFh?=
 =?utf-8?B?TGlzcFNyeW52UnNhL2ZmWEo4VkVhdmZDdjd6VHRJMUJUbDhEendRZnNaWm92?=
 =?utf-8?B?Ty9wdllvVGJPcVI3Y0dodXcxd3JrZExGNGtORkZ3MGVmcVpYY3VzK3VpMFhm?=
 =?utf-8?B?bUpXNnQ0bjRoNjNOa0lncVQ5c2luZ2k5RDV5WVliM2RzS1V5WGNlcXorUlBo?=
 =?utf-8?B?NXh2MHQwemtIWmx5enZlWFpoa0trUlh2bXFudUNIQm9VSjczcW43ZDVHaXFa?=
 =?utf-8?B?WjY5elRpeTBJRmUyQ05nT1owWW9Yb3BlNlpmc09HUnUxQzJ0SlNXUEpoaUNG?=
 =?utf-8?B?TzdtVGpZNjUvK2pwdDQrb0FRMkh5bjBPRHpjaVhpd1pERTA0WkFCNHordFNJ?=
 =?utf-8?B?SHl1NEdpbGJBVHE0MVJDRUlJd2R4SmdMMUFjZFYxWUpTcFljVmJLQlBWYUR1?=
 =?utf-8?Q?ZeErwlKA1EZ/jMhNEPU2pMMR/?=
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
	wT6KJQxn2egfHnycbRN952+zv/9/+Xswfwp5hfddV1Icr+hpU0/ajqNBOadTLKobR0WiTI1tZ+utL6QfXxGfp40AdHxhK3ddQHOTbvpMkV5uGugl+MyPO8NVGkfi93zgMSwhgz4esPqENrT/KsM2WGlFSyxkLkoBn1RbQy9G6prxQYnST+P7rSlTvU8gQr63J9fb/2+Sr5jtJ22m9ZxequcoVq75GJBRWHThWd9H4aVaRSPogd4W3fDKXEZJZPXytcVU09Iu24Lhg8D8QzcvEfTiowxDWLasF5fXOz8Cxx1PVhfUa4VYl26BOpkJE2dBS8mFbqagy9g0O0ZpEy0sJNJGAafkjqqDY2ttd5u0wtZyA7XCPhvc+XT4tkhS6A3ffcbKjAWALhHJhOlZW8e5alVsRXeVL3vJI3+o+m5HTqQZ02bpJe0MrEh+K+lu8sQcRIyHIoJx9vVAyVm5m5tQraHZJNODSJ8Cg9tBaNayQHo8bWmNKNQuPG9Vhiki8kvwsHlE717rfRJgGqMZGXmc+ruaFrJ4yIu+nENIqyP5gAmniUi+U01NnCoSSUMvX8uF63v/YzgmGYYr+VFEw7379ebKm8XkwaV7oko/Pxoj3YmCOd+mJGaMVjfNirkBSmz4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8df2c8-951f-42f0-899c-08dcb79dbb19
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 11:32:05.6435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVMFsbACXJcNt0IfTp9d4oZWDCvJ0avFe26JVKsE60PEIrJavHbHLW5Jg4jKwsRjEQnMFgLynvMEI/qLUNkHkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7721

PiANCj4gT24gOC80LzI0IDEyOjIxIEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArV2hhdDoN
Cj4gL3N5cy9idXMvcGxhdGZvcm0vZHJpdmVycy91ZnNoY2QvdWZzaGNpX2NhcGFiaWxpdGllcy9j
YXBhYmlsaXRpZXMNCj4gDQo+IFRoYXQgcGF0aCBzZWVtcyB3cm9uZyB0byBtZS4gSSB0aGluayB0
aGF0ICJ1ZnNoY2QiIHNob3VsZCBiZSBjaGFuZ2VkIGludG8NCj4gc29tZXRoaW5nIGxpa2UgJHto
b3N0X2RyaXZlcl9uYW1lfS8ke3Vmc2hjaV9pbnN0YW5jZV9uYW1lfS4gQW4gZXhhbXBsZSBmcm9t
DQo+IGEgUGl4ZWwgOCBkZXZpY2U6DQo+IA0KPiAkIGFkYiBzaGVsbCBscyAvc3lzL2J1cy9wbGF0
Zm9ybS9kcml2ZXJzLyp1ZnMqDQo+IC9zeXMvYnVzL3BsYXRmb3JtL2RyaXZlcnMvZXh5bm9zLXVm
czoNCj4gMTMyMDAwMDAudWZzDQo+IG1vZHVsZQ0KPiB1ZXZlbnQNCj4gDQo+IC9zeXMvYnVzL3Bs
YXRmb3JtL2RyaXZlcnMvdWZzaGNkLWhpc2k6DQo+IGJpbmQNCj4gdWV2ZW50DQo+IHVuYmluZA0K
WWVhaCAtIG5vciBvbiBteSByYjUuICBIZXJlIGl0IGlzIGluOiAvc3lzL2RldmljZXMvcGxhdGZv
cm0vc29jQDAvMWQ4NDAwMC51ZnNoYy91ZnNoY2lfY2FwYWJpbGl0aWVzDQpTbyBJIGFtIHdvbmRl
cmluZyBpZiBoYXZpbmcgc29tZXRoaW5nIGxpa2UgdGhlIGJlbG93IGlzIGFjY2VwdGFibGU/DQov
c3lzL2RldmljZXMvcGxhdGZvcm0vPHBsYXRmb3JtLXNwZWNpZmljLXBhdGg+L3Vmc2hjaV9jYXBh
YmlsaXRpZXMNCg0KVGhhbmtzLA0KQXZyaSANCg0KPiANCj4gPiArV2hhdDoNCj4gL3N5cy9idXMv
cGxhdGZvcm0vZGV2aWNlcy8qLnVmcy91ZnNoY2lfY2FwYWJpbGl0aWVzL2NhcGFiaWxpdGllcw0K
PiA+ICtEYXRlOiAgICAgICAgICAgICAgICBBdWd1c3QgMjAyNA0KPiA+ICtDb250YWN0OiAgICAg
QXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+ID4gK0Rlc2NyaXB0aW9uOg0KPiA+
ICsgICAgICAgICAgICAgSG9zdCBDYXBhYmlsaXRpZXMgcmVnaXN0ZXIgZ3JvdXA6IGhvc3QgY29u
dHJvbGxlciBjYXBhYmlpdGllcyByZWdpc3Rlci4NCj4gPiArICAgICAgICAgICAgIFN5bWJvbCAt
IENBUC4gIE9mZnNldDogMHgwMCAtIDB4MDMuDQo+IA0KPiBQbGVhc2UgZml4IHRoZSBzcGVsbGlu
ZyBlcnJvciB0aGF0IHdhcyBhbHJlYWR5IHJlcG9ydGVkIGJ5IEtlb3Nlb25nIFBhcmsuDQo+IE90
aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUuDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBCYXJ0Lg0K
