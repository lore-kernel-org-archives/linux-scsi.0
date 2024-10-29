Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD43C28E7;
	Tue, 29 Oct 2024 05:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730180405; cv=fail; b=nS0Jxwc6YZFS2ZzRQmeGK15YtdvmTumJt0Tv0S9quk0L0iLN6Aho9SGDY9BiTZMbDDa5IRM7SK5IRsoat1oFBHN9g9TK3/pOUAAuKG6P4y57I6GWay+TtrsUu9VmYBSvGkG2abzCyK9NJehLaz/sfJuqQ4xSOeCJ+ufJXOBi/4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730180405; c=relaxed/simple;
	bh=kATqiHaHflj3v04UKDUiEPpuZt1JCcYy3FGHsZZoCrg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TIAuD0Bnlx1LuZb9CE8vf7AXWNvOG5lwdYjpwGt0AHW9xw41XzAop6BoARZkQzAvRm+CLBkRNJ+uC1GK58djT2fGKRaqxBqQKWGITnkcAx/tjruVKTsHing+VDTvD+sGsddsmJdQKpi7Fwhq8rLTOZRMO9G9nqHg2o/ol0voMS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=qb//9ufr; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=p8XR3Viz; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qb//9ufr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="p8XR3Viz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730180402; x=1761716402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kATqiHaHflj3v04UKDUiEPpuZt1JCcYy3FGHsZZoCrg=;
  b=qb//9ufrQaVqbDgMKLiK0ktnCSCd9EWl/NuhOmlX4AdHZFXJV7AwDNSR
   TGwYQ9d5Tuz++6PjDZBLbyEkRVBuh0XkBz+6hXVWBFh/gB8g2W6sDUmZ6
   G5L5Ll8j69qKORU/URWXAKPthisIQUmR2lx58gADOpYf6iwqzlM44v2ZE
   ZcmIvieCAGW5Yy+QVM6YM2DcmsSxAIVsO9xTe9MeYX3CPL9rCUR8qBgCs
   SGy8TbTuYCIjnALHsdWhIVmiQssjWjkYk2CVsxs/OMa7OwEmhSKl1mQuq
   frqXBRKPBIYmNqJFrrOCZvf3GJ5UwTS/fzE1iZKmOy9HGI/Fb2cvbwHWF
   Q==;
X-CSE-ConnectionGUID: cDtDH83lSya2KVT/AR+ZqA==
X-CSE-MsgGUID: wP9+f2tdRTmVEH1NtIgFUA==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="30593528"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 13:39:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ktWSltSULyyT6subfXhVzPHDVYg/9MDfmLAclaMEGWXvlt8DfdDsfF8bkY3rHgwuGies274rfzO0bD/pXcabvV2X1LZuH2peO7r95OfqL3jUvgCsNS9sUmdkdU4FKAvB6NvcTvDG1PFJMBvvWolLPvJdSjRDXJokPuwSI664PAiML65uu6HMV+q6NUfvWcwIqCSKriMyn1M1mWGIkkbdtdvZ2wEgGgypfA5EiWyu+jeeJkbRWBXLzWMKI76r8j6/KO2B2Soc0Mi68110RKWmsopTegJIc56Kx/6RkfO1B6V5BLfOA7b1nPgK70vSbtLqvacu7RafUrJsU3RMsXPU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kATqiHaHflj3v04UKDUiEPpuZt1JCcYy3FGHsZZoCrg=;
 b=Ty/3/bGRN8VCSVDpcijLZTuS38909mvcxNU5KQ+Hap7vN40XgMhnPFlU/K+2GyZwu3wkbI0TIWaGmYgR9d5ltrqxgDsjVRpljasIocVf2vOfDMxwG3drmy+vNonQAeqHkWhH6eDgQr2Wb9Vd4pPN2DukPUzzgIMuZMD0p2F7wbRmBGkntZliWw+bWxJU8UAvEwmSyuM2jOWcES0xwu7YhfECDVF7o42Sog2rqoOLPM1c47SjiPICvbjoTNdCovgOjPieh+B307IuqnAUJw31MVE5dswiq9fN+Gb6+BYsl9rFZ+Q/w85xhHkH63dVKQ/cGWzcRpIddbzO8hUA8U4aOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kATqiHaHflj3v04UKDUiEPpuZt1JCcYy3FGHsZZoCrg=;
 b=p8XR3VizKN0HRKsuo858nnHp/yxEXjsITxPkuJb+vjkgr46iY2YKu2ho+DTU2jez6SqLBslkYa7NI4hapq31yNTaOy6/C6+768roBY2ShAQMlvSqwwTWEMZeifnpacwT8m2kL5DklaJXV+L78PWJ52/fpjW4ydyTO2nMQx2c5H4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB8084.namprd04.prod.outlook.com (2603:10b6:610:f0::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.25; Tue, 29 Oct 2024 05:39:52 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 05:39:51 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH 1/2] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Index: AQHbKEoWQLtWEHgqgkOlDewYT5ral7KcmLKAgACgUyA=
Date: Tue, 29 Oct 2024 05:39:51 +0000
Message-ID:
 <DM6PR04MB6575D6AECFEC5C3ED1016EFBFC4B2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241027082519.576869-1-avri.altman@wdc.com>
 <20241027082519.576869-2-avri.altman@wdc.com>
 <242b1d10-2c11-4bb3-8f77-c939ecb5f1a0@acm.org>
In-Reply-To: <242b1d10-2c11-4bb3-8f77-c939ecb5f1a0@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB8084:EE_
x-ms-office365-filtering-correlation-id: 9d5808c6-1fec-45bf-58eb-08dcf7dc1c3b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MTcyVzJMSy9WWExZQTFWR2FobVpmQXhTcFNrKzRaY1NCdC9wbDZRSnJZbjdC?=
 =?utf-8?B?Q3JQbHZEMVpGWHY1aytxSCsvMFpkU0hXR0c2UU9nOTJncjd3U3BGZ1VNMEZ2?=
 =?utf-8?B?d29FS1Qzb01GUHNFWEVaOW03a0VqZ01UWVdsa1FEZEg4Tk5KUWVucCtmaS9L?=
 =?utf-8?B?QWg1V1lIU1NXLzZiYW15ckRSZFpqVSszdDRLaVM0cjRydVlKNG9RV0YwWG8x?=
 =?utf-8?B?ZjhqWEJtSFcycFJzRThBV1UrRTVHNUFOdGt1UG1qanVKZ0g3eDFJWXYwVFQz?=
 =?utf-8?B?SlM3dG4rb2o2MWxKS2VVLzBKMEZjUXBab01ZY2RTYys0ei90cnZjT1AvRDd6?=
 =?utf-8?B?YWNTLzJTZFphY1RNZWU4QUlmUnFzc013L2UrcGt4cUVzUC9Ta3ZsWmtNRzk2?=
 =?utf-8?B?UGV0Q2lXZ0RsM1hROW4ydG82dXlBTnJwTzlBY2NWVldyc0dOTlpDeGJ6WGpB?=
 =?utf-8?B?THVhdTNNemVQcXNEWm8rblNtTTUvRzlWVlczZVhBZmJtSEZwZnYyR3IwcklE?=
 =?utf-8?B?WVJHSzJad0xNS3pKK1JNWmh6RFpLODQxRFFBc0tZdXd2empWd1BGQnAzOXl1?=
 =?utf-8?B?Ujl4RU5zUmo3OXoxQVd5L1FCRC9kS2FtUVZGWmZlLzF4U0luUWd1dmd1UjhH?=
 =?utf-8?B?YTZoZ3ZXbTFFVU8ydGR5NzZ6RmxVTjJhVTliZDYzREJ6WHFuQlcwYk9PRFBH?=
 =?utf-8?B?QXRPbGFJamxXTDNDditqd1hwcUtaRDJXY1ZNTlhNRUtiRXEyeml4R0pTYzlJ?=
 =?utf-8?B?VjlmUEVJYys0ellWNDVEVnd4TytnQXNLSTNCMU4vamU0b0tvQWI3b3NoQ2RC?=
 =?utf-8?B?RXdzZ3VIS2U5cmZ3Ym9qNW5Ob2VNWEpWa01ZRXBwU3loRTRhbjVObFliYlVl?=
 =?utf-8?B?MjVYclhRcmJDdDVRYTluYmhZRHFxbEtNeVFSN1FEbWN1TlowQW9WME1Yc01R?=
 =?utf-8?B?TFNFcGl1NmJXTnp2UVUvUE4yRU5TcnM5dHUvZ2xCbnNKcVRqLzRsKzI2MC9i?=
 =?utf-8?B?ZDNhSHdCRmltYjU4RUQ4NXdVQUFMTW1XNmhVWjBDVldFN1psV1lKVG1zWS93?=
 =?utf-8?B?NGxTV3JjMDcvYjQxNnZPbXl5eXJuYUI4ZDBGMStZZWdScExZVVZ4R3d2Rzh0?=
 =?utf-8?B?UnpjemcrcDJYZUVpYit3djZHZE8rNEJlK09rMUpWTTRseEpXUmg0YjZvN2cz?=
 =?utf-8?B?K3U0STN3QW81N2YxZ3dsK2FVU0xiQnFsaGkxWGJWd2w0MG5vSVVhTmNnWTlG?=
 =?utf-8?B?OHdxd2o1SVRnbTdOdlRzLzlIQ1VYdmppNUFBQnFoenZ4bUJ2TG56Zm11a3Iv?=
 =?utf-8?B?cVZJb1VkV3dRcmM2bDJoTUVoa1o0Y1c1WnpFRzFRY0xPOCtNMkE4SlJPZVlP?=
 =?utf-8?B?QUlOTWZtR1dJRFB0OUx6NjlSWEdnR1NZMTd0ZGFaZjhSUEdCeTlSS3RLa2Jo?=
 =?utf-8?B?TnRnWHd5cjlQUU5DK09PbjVOQzljdU55bFlJUDB3dGE4OGNaRzZkdXZTSHVx?=
 =?utf-8?B?NjZjVmJxMThrVW5tVFdtSmROVHZaQjhCb3dtNDRNK2hGbzlZdnhhMklrREEv?=
 =?utf-8?B?TkNZeHBIK0w3T2ZRWkkraHJDOVNmNGZPckxmdXVScW5oOEZYVGxEZHdxaG1B?=
 =?utf-8?B?Zm5vdEorS0FKK1RDMUVweHFRN1BDYkFPTGExQkhLaWs3c2N3amV1T3FiNDFr?=
 =?utf-8?B?bGl3NXJaWFZiY2lzNnpWS2lrbTU0RlNZWGx0UGx4T3k2aWtweVViWGFvQ1Jl?=
 =?utf-8?B?SlBDeEd0eGFFQjBlS2tzT1A5VE1iUTZRUlNLOGU5V0pTOS8wRTlEK0VrWTMy?=
 =?utf-8?Q?tFpVXL/MiFEYmKCC2/AvFipcoN22cw5qwvtsQ=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T3IwVnArcjYyNEpjbHdvMjlFQnQ5UkZDQVl3N2ZRbS9iVTB1cm5MM2pBM2ZC?=
 =?utf-8?B?NlhYNnpiUExGeHdzSDZVTHJ1eEl3SXpyanllZ2ZZeWtWWDdoOG9vNlFJc3V5?=
 =?utf-8?B?UndpeEFvUjFHWXkzZmJBeWVoRExhWTVqRlM3S2RwVkhPcDZ4a3daYUszbjFu?=
 =?utf-8?B?b1IwdFBlQTlZSk1tdzMzZW9qMWtUbFhzdkdVQVVoWHdvTWtzcHlOenZsQ2NB?=
 =?utf-8?B?eXZDdHNUS2JDY2FybTNweW9wZThnT3dwZEprS2tjMEJqZUtjVkFPWGwwWFFn?=
 =?utf-8?B?dVVSNE4rSWN1V0g0aXRNYlMrZ2ZRM0lJcDROWDBFTmV4VHhqRittc1N5Y242?=
 =?utf-8?B?TFB2Wk1ZdUdYMStKM1FYWCtiaGk5SDVCcjVVektnaXdjeXllaWpnT1NNUUND?=
 =?utf-8?B?c3lyYVFNZjJQelF6WFgzbm1xbVpIK2t0aWVENEZ3SXNQZUhDOUIrNFJJMUd2?=
 =?utf-8?B?WndweVg4UmtUbHRVTDBQbGxwZStReVNKNG5nSWJjZkZQSTRWK2JNeHNRUzd4?=
 =?utf-8?B?RnZvbElFK1o3bzRsUHE4S2dobHgrSDFqYU4xbWMzYjN1ZkFkTFFJK2ttWEx4?=
 =?utf-8?B?Vm1pb3l4K2N0TEdKVHhsMm1FOHEwRzFJQ1E0NDU5L3htZnI2bVFWUlBTZi8v?=
 =?utf-8?B?Q1hjTm1aMlBtREtLUFFpOUFjMHFCK3VGNkQ3UEhwT2dJYWEwVitobGc3WHU4?=
 =?utf-8?B?RjNaK1Y4d3ZYTS9NalVMMWFkRnJOakJjdHV0cjY2V1hocEN3RmxXbEtJQkRS?=
 =?utf-8?B?OHN3TjcvbitlWXJENzZLNHBsWlFrVVFWL2lIYUFsdXRESWJ5aDBQV0h0MnFW?=
 =?utf-8?B?eGJ3dGpNMFBDRWdJM1ZwWkNPelpmdU1VblNwOXE0R21SQUloT3BMaDEvdWZl?=
 =?utf-8?B?Um92Y1hPYVdPVE1CV2duMktQNU1CRWNpOTc5TU04bGpoWkVsYVlvYm1EcWEv?=
 =?utf-8?B?bEJSbUNPRHE2ZVYzMWhHSXNxU2krTmxNbWxTRlkwMVg3WGlTWmVyTnVjeXQ3?=
 =?utf-8?B?M3k0WkpuU1p1QXJvTHhrSVF0ZVNiVU41T0ttMkw5TkpwTUpZL2Vzd1JXVVFT?=
 =?utf-8?B?SXRoR0dRZGRTYXFYVGROaTllcVI3TE9pNk5CckdEdXIyMm1SQmNzb0hwMDg2?=
 =?utf-8?B?VXNrTFcrSzhpZmlXL1RDSVlxRHJUM1hvVGdCcGdQMmxOMzVqb1lXMTcvNnds?=
 =?utf-8?B?bDQyc0tZL2poNElqcXY0bkp0QUJWbi9OQ2gwb2NxQUwxd2VlWDhTQXJ0cHpY?=
 =?utf-8?B?QTFMcUU1NGNGSndydFExSXcrcFloT0JuN3BBN1FPRkdueXhQTlFkbHVXWUky?=
 =?utf-8?B?QmRCdlZoYWhXamhsTDFyRVpFVVV6Um9UTFZuRVZia2gzbWNZSnZ0OHB0dWJ4?=
 =?utf-8?B?TDN0R0lhVEpXWDJ4STVLSm1ITTRtaVlPNURnYkFvT2pOM1QybU9paUFDZFQz?=
 =?utf-8?B?UzNEa2k3Zk1XUmdlcjBPbk56T1cvWXRjeHFqUkpVZ0JCcHZ1cWtKQVVvUUdF?=
 =?utf-8?B?TktuenhNcU5mR2hUVU5BSUFKNjM3OXduVDhtcjZnV3pMSEsySlM4UzMxcU90?=
 =?utf-8?B?YTBCeTVzaXJVaUZHVUlabnZiWFNEeHlWQUJPU2NzNG0vNEhXQjVoTm95QmNm?=
 =?utf-8?B?VnNLUE41RW0yb3BxekxhZ09sRkJtK0VwM3NKRktlZVlUL1M4YnZYU1BQK2My?=
 =?utf-8?B?K3RSMzNFcVgxZkpDNzdRakZGNGtOeGllWGVHYmp4QTZHWm9DZk1VdzVVMUhw?=
 =?utf-8?B?MTlidElMcERzUlNURzgyWTI0d3Nmd3FKc0VEK3RvZHFXYWlacmtKR20vOTJh?=
 =?utf-8?B?eGRXODk3YUphWGxVRU1ZYjlLRUtYTHpXR0xScUpjRHhqMHZjQmswdDlReTFo?=
 =?utf-8?B?RTNSZkhrL2dZRkROWmhsMTF3Q0FwYVN3cWF5eXF6R3F6bW1NOG9IWEZJMG5I?=
 =?utf-8?B?b3RXTzVqV1FpNG1SNXFkWlZkYkZ4N2tLcXNCZGN1NnFmSDR1L1pIUFdIZ3hp?=
 =?utf-8?B?MzUxeDlPVHI2ZjlYT0k4cmRwMHQ1UDdOSWRJcEEzN2FlSHVmMnJ4U2lUYTV3?=
 =?utf-8?B?QndteGZ6REczOWZnZ044OTNzbzZ0aGtudExkVC9xT2NBNmcwbGZKSElQSDFI?=
 =?utf-8?Q?AWFrI/rgs69VYUmMbAn9KvXSH?=
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
	E1Y2EW0Q1QCewy8nqGrXX81GCaxR9GfdpDDU6zRjjdgOtYLUxeI/uYjQHX55EPgeWLu2h1k8TiHlCTnTAUM5LdqQ6Zde1dpqGfy0IJop9ClL0DJGE0PhP7WKjJjkCAn1WgHfQ/pp0E2cwi6t1aCdEzKsVY6xH+YS1ChCTkae2Dvdn+XTfI1fPk0smNwUVB/gWrk3xvZmz/wSAB84q7PIgerC3MlOOltdJhzYdu8zEd145cJTqvQF6ijSW9aiNJLQI/eEZ0sWjzM/PbjN9bp6WX5MzNq1u7wOIfXc06Cpd4/jzvFSgHOScUz/5xbDd1RE6nXHCysykPjYzK4rJU1xhUCGMacn/JP/F/2BsWrqMmtAIwgTacuKfKxUmnuoTOeP6ETqS9pVoPvB6IpLU6brdPoFH069Qbmz0bVPdajObAkb1SQ/SAyx4fqshlfWNWgEQ8ii0u5XFzyotaUeL2VfdT6pyGDvB+7uBKW2F5G//dXfoonLSTMyMzAjO2r7VJ09e8gT1oseEJxL8ZXdZR6sDFyNWkmI9kICA9Fivdic2TkLvGekOZ30XhRKh0QLWp6Lks0PNkVaMR1sw0Va+qB5ild/VeWL9OdSYx1mF+7o4g0mrKJxWgWaalQlj+DwEnEn
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5808c6-1fec-45bf-58eb-08dcf7dc1c3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 05:39:51.8017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /IlIa5fpAz6lDPuNZ5sp9CdzIX695kSM5fXt8hXDBXl7Ue461guwj/2G5gQAbDuVbO2L0D0ffw5Zk12c3ovxqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8084

PiANCj4gT24gMTAvMjcvMjQgMToyNSBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gSW50cm9k
dWNlIGEgbmV3IGNsb2NrIGdhdGluZyBsb2NrIHRvIHNlcmlsaWF6ZSBhY2Nlc3MgdG8gdGhlIGNs
b2NrDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl5eXl5eXl4N
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNlcmlhbGl6ZQ0KRG9u
ZS4NCg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2Ry
aXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCAwOTkzNzNhMjUwMTcuLmI3YzdhN2Rk
MzI3ZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gKysr
IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC0xODE3LDEzICsxODE3LDEzIEBA
IHN0YXRpYyB2b2lkIHVmc2hjZF91bmdhdGVfd29yayhzdHJ1Y3QNCj4gPiB3b3JrX3N0cnVjdCAq
d29yaykNCj4gPg0KPiA+ICAgICAgIGNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmaGJhLT5jbGtf
Z2F0aW5nLmdhdGVfd29yayk7DQo+ID4NCj4gPiAtICAgICBzcGluX2xvY2tfaXJxc2F2ZShoYmEt
Pmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZo
YmEtPmNsa19nYXRpbmcubG9jaywgZmxhZ3MpOw0KPiA+ICAgICAgIGlmIChoYmEtPmNsa19nYXRp
bmcuc3RhdGUgPT0gQ0xLU19PTikgew0KPiA+IC0gICAgICAgICAgICAgc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ICsgICAgICAgICAgICAg
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGJhLT5jbGtfZ2F0aW5nLmxvY2ssIGZsYWdzKTsNCj4g
PiAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiAgICAgICB9DQo+ID4NCj4gPiAtICAgICBzcGlu
X3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gKyAg
ICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGJhLT5jbGtfZ2F0aW5nLmxvY2ssIGZsYWdzKTsN
Cj4gPiAgICAgICB1ZnNoY2RfaGJhX3ZyZWdfc2V0X2hwbShoYmEpOw0KPiA+ICAgICAgIHVmc2hj
ZF9zZXR1cF9jbG9ja3MoaGJhLCB0cnVlKTsNCj4gDQo+IFRoaXMgd291bGQgYmUgYSBncmVhdCBv
cHBvcnR1bml0eSB0byByZXBsYWNlIHRoZSBzcGlubG9jayBjYWxscyB3aXRoDQo+IHNjb3BlZF9n
dWFyZCgpLCBpc24ndCBpdD8NCkRvbmUuDQoNCj4gDQo+ID4gQEAgLTE5MjgsNyArMTkyOCw3IEBA
IHN0YXRpYyB2b2lkIHVmc2hjZF9nYXRlX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0DQo+ICp3b3Jr
KQ0KPiA+ICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+ID4gICAgICAgaW50IHJldDsNCj4g
Pg0KPiA+IC0gICAgIHNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFn
cyk7DQo+ID4gKyAgICAgc3Bpbl9sb2NrX2lycXNhdmUoJmhiYS0+Y2xrX2dhdGluZy5sb2NrLCBm
bGFncyk7DQo+ID4gICAgICAgLyoNCj4gPiAgICAgICAgKiBJbiBjYXNlIHlvdSBhcmUgaGVyZSB0
byBjYW5jZWwgdGhpcyB3b3JrIHRoZSBnYXRpbmcgc3RhdGUNCj4gPiAgICAgICAgKiB3b3VsZCBi
ZSBtYXJrZWQgYXMgUkVRX0NMS1NfT04uIEluIHRoaXMgY2FzZSBzYXZlIHRpbWUgYnkgQEANCj4g
PiAtMTk0Niw3ICsxOTQ2LDcgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2dhdGVfd29yayhzdHJ1Y3Qg
d29ya19zdHJ1Y3QNCj4gKndvcmspDQo+ID4gICAgICAgaWYgKHVmc2hjZF9pc191ZnNfZGV2X2J1
c3koaGJhKSB8fCBoYmEtPnVmc2hjZF9zdGF0ZSAhPQ0KPiBVRlNIQ0RfU1RBVEVfT1BFUkFUSU9O
QUwpDQo+ID4gICAgICAgICAgICAgICBnb3RvIHJlbF9sb2NrOw0KPiA+DQo+ID4gLSAgICAgc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KPiA+ICsg
ICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmhiYS0+Y2xrX2dhdGluZy5sb2NrLCBmbGFncyk7
DQo+IA0KPiBTYW1lIGNvbW1lbnQgaGVyZTogcGxlYXNlIGNvbnNpZGVyIHVzaW5nIHNjb3BlZF9n
dWFyZCgpLg0KRG9uZS4NCg0KPiANCj4gPiAgICAgICAvKiBwdXQgdGhlIGxpbmsgaW50byBoaWJl
cm44IG1vZGUgYmVmb3JlIHR1cm5pbmcgb2ZmIGNsb2NrcyAqLw0KPiA+ICAgICAgIGlmICh1ZnNo
Y2RfY2FuX2hpYmVybjhfZHVyaW5nX2dhdGluZyhoYmEpKSB7IEBAIC0xOTc3LDE0DQo+ID4gKzE5
NzcsMTQgQEAgc3RhdGljIHZvaWQgdWZzaGNkX2dhdGVfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQo+ID4gICAgICAgICogcHJldmVudCBmcm9tIGRvaW5nIGNhbmNlbCB3b3JrIG11bHRp
cGxlIHRpbWVzIHdoZW4gdGhlcmUgYXJlDQo+ID4gICAgICAgICogbmV3IHJlcXVlc3RzIGFycml2
aW5nIGJlZm9yZSB0aGUgY3VycmVudCBjYW5jZWwgd29yayBpcyBkb25lLg0KPiA+ICAgICAgICAq
Lw0KPiA+IC0gICAgIHNwaW5fbG9ja19pcnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFn
cyk7DQo+ID4gKyAgICAgc3Bpbl9sb2NrX2lycXNhdmUoJmhiYS0+Y2xrX2dhdGluZy5sb2NrLCBm
bGFncyk7DQo+ID4gICAgICAgaWYgKGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9PSBSRVFfQ0xLU19P
RkYpIHsNCj4gPiAgICAgICAgICAgICAgIGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT0ZG
Ow0KPiA+ICAgICAgICAgICAgICAgdHJhY2VfdWZzaGNkX2Nsa19nYXRpbmcoZGV2X25hbWUoaGJh
LT5kZXYpLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaGJhLT5j
bGtfZ2F0aW5nLnN0YXRlKTsNCj4gPiAgICAgICB9DQo+ID4gICByZWxfbG9jazoNCj4gPiAtICAg
ICBzcGluX3VubG9ja19pcnFyZXN0b3JlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+
ID4gKyAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGJhLT5jbGtfZ2F0aW5nLmxvY2ssIGZs
YWdzKTsNCj4gPiAgIG91dDoNCj4gPiAgICAgICByZXR1cm47DQo+ID4gICB9DQo+IA0KPiB1ZnNo
Y2RfZ2F0ZV93b3JrKCkgY2FuIGJlIHNpbXBsaWZpZWQgYnkgdXNpbmcgZ3VhcmQoKSBhbmQgc2Nv
cGVkX2d1YXJkKCkuDQpEb25lLg0KDQo+IA0KPiA+IEBAIC0yMDE1LDkgKzIwMTUsOSBAQCB2b2lk
IHVmc2hjZF9yZWxlYXNlKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ID4gICB7DQo+ID4gICAgICAg
dW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPg0KPiA+IC0gICAgIHNwaW5fbG9ja19pcnFzYXZlKGhi
YS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQo+ID4gKyAgICAgc3Bpbl9sb2NrX2lycXNhdmUo
JmhiYS0+Y2xrX2dhdGluZy5sb2NrLCBmbGFncyk7DQo+ID4gICAgICAgX191ZnNoY2RfcmVsZWFz
ZShoYmEpOw0KPiA+IC0gICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0
X2xvY2ssIGZsYWdzKTsNCj4gPiArICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZoYmEtPmNs
a19nYXRpbmcubG9jaywgZmxhZ3MpOw0KPiANCj4gRm9yIHRoaXMgZnVuY3Rpb24gYW5kIGFsc28g
Zm9yIGxhdGVyIGNoYW5nZXMsIHBsZWFzZSB1c2UgZ3VhcmQoKS4NCkRvbmUuDQoNCj4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgg
aW5kZXgNCj4gPiA5ZWEyYTc0MTFiYjUuLjUyYzgyMmZlMjk0NCAxMDA2NDQNCj4gPiAtLS0gYS9p
bmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+ID4g
QEAgLTQxMyw2ICs0MTMsNyBAQCBlbnVtIGNsa19nYXRpbmdfc3RhdGUgew0KPiA+ICAgICogQGFj
dGl2ZV9yZXFzOiBudW1iZXIgb2YgcmVxdWVzdHMgdGhhdCBhcmUgcGVuZGluZyBhbmQgc2hvdWxk
IGJlDQo+IHdhaXRlZCBmb3INCj4gPiAgICAqIGNvbXBsZXRpb24gYmVmb3JlIGdhdGluZyBjbG9j
a3MuDQo+ID4gICAgKiBAY2xrX2dhdGluZ193b3JrcTogd29ya3F1ZXVlIGZvciBjbG9jayBnYXRp
bmcgd29yay4NCj4gPiArICogQGxvY2s6IHNlcmllbGl6ZSBhY2Nlc3MgdG8gdGhlIGNsa19nYXRp
bmcgbWVtYmVycw0KPiAgICAgICAgICAgICAgIF5eXl5eXl5eXg0KPiAgICAgICAgICAgICAgIHNl
cmlhbGl6ZQ0KPiANCj4gSSBkb24ndCB0aGluayB0aGF0IHRoZSBhZGRlZCBjb21tZW50IGlzIGNv
cnJlY3QgLSAnbG9jaycgaXMgdXNlZCB0byBzZXJpYWxpemUNCj4gYWNjZXNzIHRvIHNvbWUgc3Ry
dWN0IHVmc19jbGtfZ2F0aW5nIG1lbWJlcnMgYnV0IG5vdCBmb3Igc2VyaWFsaXppbmcgYWNjZXNz
DQo+IHRvIGFsbCBtZW1iZXJzLiBBY2Nlc3NlcyB0byBlLmcuIGdhdGVfd29yaywgdW5nYXRlX3dv
cmsgYW5kDQo+IGNsa19nYXRpbmdfd29ya3EgYXJlIG5vdCBzZXJpYWxpemVkLiBQbGVhc2UgcmVv
cmRlciB0aGUgc3RydWN0IHVmc19jbGtfZ2F0aW5nDQo+IG1lbWJlcnMgYXMgZm9sbG93czoNCj4g
LSBNZW1iZXJzIHRoYXQgYXJlIG5vdCBzZXJpYWxpemVkIGZpcnN0Lg0KPiAtIE5leHQsICdsb2Nr
Jy4NCj4gLSBGaW5hbGx5LCB0aGUgbWVtYmVycyBzZXJpYWxpemVkIGJ5ICdsb2NrJy4NCj4gDQo+
IEkgdGhpbmsgaXQgaXMgY29tbW9uIGluIExpbnV4IGtlcm5lbCBjb2RlIHRoYXQgc3RydWN0dXJl
IG1lbWJlcnMgYXJlDQo+IG9yZ2FuaXplZCB0aGlzIHdheS4NCkRvbmUuDQoNClRoYW5rcywNCkF2
cmkNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
