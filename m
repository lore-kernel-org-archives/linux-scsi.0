Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EA3182C5;
	Fri, 24 Jan 2025 12:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737722938; cv=fail; b=NMkU51nasLV/TDt2SOWCmjx8+muPng37/LYVu+/N703Aps/ASXNAjD3ZTEwOxMmcTyelRwjFJeG47RRLZdMAbKDwczgoDZ7qUI2W7SOnVqc30+MK+2XPZK7+ntupuI9lj78hhM4Fi7bcKTLzGjBi3S6htUm24aokIkJwn1cRsZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737722938; c=relaxed/simple;
	bh=4nZbZEI6qOkVuLSJvPCjkV65l3IozfYDMsXlgA7QOm8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YuyeMqnbM3tIkYfa84UBeAFpRGsMdC7DynA/ifL8+cu4VNROEL/LDkVrN0g7K6J1rTemn3WwEMD+JKwhSF19+4J9zSFvG57BSuhcjWcFPuLJHbm2yATLUyup6dUMEAwRbimkTceeFbi6EO9SSBpMg+iNC/L+3rg16fQZ8Dwq1Iw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=UXMeSj1g; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=S0cSt7cv; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UXMeSj1g";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="S0cSt7cv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737722937; x=1769258937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4nZbZEI6qOkVuLSJvPCjkV65l3IozfYDMsXlgA7QOm8=;
  b=UXMeSj1gMRDcPl6AEnfa90hXQmuWbzSteHm941YJzpXkrLTh034qZQVd
   RKBcYsgTJNNqL784C1BY9UcZSeFiMit3D8SMEBmaIa+1/UEwQuVyaehw3
   YF4tu/nFeJieO0ZIE6QGNUvbnJNiRD3AFOcgrJvVBCJZhEZFYCDI3W9N+
   TsrUqAQyWmc2FbNtb3gvM4WSz2eO3E+QLvyERMx787ZpSCGzz4txiK/zn
   vOB2P9xdBcWgrPoxxG+XG44kXrpbuG5hUiMFOXRkEInNpCYyBmgS0Qbw1
   8eOj+tVUMYD1xbTZ6gGmWqbh7kzMKkcJCD0+j6ccd/flS7pmYxHZJ4A4/
   A==;
X-CSE-ConnectionGUID: wMP8sg5aTbCoZ62lVs5xfw==
X-CSE-MsgGUID: lPz3EeFgTxizkWk2mcv3kw==
X-IronPort-AV: E=Sophos;i="6.13,231,1732550400"; 
   d="scan'208";a="36715338"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jan 2025 20:48:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMT84MmH981NFF3SNaY6pn3q6bjZDBxlh4gd0VsewfziZ4jO83nWuIx+AO4DhNePUyICAvDudBro7gKKTWzmjfke3+qrapMsTUtGSc1xSoqUP6arKeVVPFcJ1byY8QJahKD/yTlw+L/4jZC3g1a520kplcV0o5uf2Sc/nCbPcQjZFszq5TD89ckI+r8Aeai2rGdpkkKSpKSyYYijslphmSipH03edBQUqJnr10g0CqubocmN3WoVhVCyixFb5uNXPTthKZW/gw6aPGOe7d+6kMpRs/v3DNNoJ6Ovk6HRwSadE6iw5D2XDF09JxuGFtb7xpmT957r2h8sdEjBFNFtjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nZbZEI6qOkVuLSJvPCjkV65l3IozfYDMsXlgA7QOm8=;
 b=JMeYwewZ+s9SkXocNrk/P//sU13mAPmrBsxbIz97AjrokXyKXXqXcu2e0yzuRH5bop7fjCeq5Z87vs8iU3JGIYN54gDvJ1YTffyCu8kz3D1kTA+n+HLpl6cnjS66x65Fak+EM2YYABQpNfvz4fdV+6NLLK3QmsXchIyk4fYAaS3KVAKvlLuYGcdDRMeKNlnT4qsOZzINv2JuVyQPeRA4uQRFUwihz4/QseAositJmbtPEEyjsN8F5qpTzuh/FF94NqRLx02AcCbW+fFCEYGYobBgG54mLuyHcigdvcbRq6msCmpaEZ+MTwhR6pCTktvlX62RtO3/IYUXghpldXTnyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nZbZEI6qOkVuLSJvPCjkV65l3IozfYDMsXlgA7QOm8=;
 b=S0cSt7cv12/Yqsgjy7cwyhNJn18Uupd/WpX6uzo1doq5eAA+PLnHDKkHxPz3vyC3RqY2hTgr33GhSoeXfvQM6Ek2eKCgG7FlsBJBLXd5Nlxi0tF+fIy/+J45fLlSqIe4KDvXD6nnOrgv/r21hK/CzlSdICL7V3oZ3mrmWljT7s8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB7076.namprd04.prod.outlook.com (2603:10b6:a03:222::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Fri, 24 Jan
 2025 12:48:48 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.009; Fri, 24 Jan 2025
 12:48:47 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manivannan
 Sadhasivam <manisadhasivam.linux@gmail.com>, Bart Van Assche
	<bvanassche@acm.org>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: RE: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Topic: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
Thread-Index: AQHbbjK7MtFbQrGgbEacrXj0TabXHbMl03IAgAAH3UA=
Date: Fri, 24 Jan 2025 12:48:47 +0000
Message-ID:
 <DM6PR04MB657531813CCA81C40A7D65E5FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250124073354.3814674-1-avri.altman@wdc.com>
 <CAMuHMdVHMH8=i3v=qYGhR5t+mbz07TyS7b=6OnnxmHox58c7Eg@mail.gmail.com>
In-Reply-To:
 <CAMuHMdVHMH8=i3v=qYGhR5t+mbz07TyS7b=6OnnxmHox58c7Eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY5PR04MB7076:EE_
x-ms-office365-filtering-correlation-id: 199cd37a-1831-44f8-4f65-08dd3c757215
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZXFBMjBEVDErMk9EcFNLMkpTcXpuQ0RRQVVFRmRSWnROUGJkSFJMbkFZa3l2?=
 =?utf-8?B?NnRxY3VyM09leHNIVkIrZkFRUGZmWGpVaGpucXdzMHZTb2EvSC9NcURJQ1hq?=
 =?utf-8?B?REI2MVE3VE5rZ0JLb0lhUUczN0ZCQm83UldHWUpIQTNnOCtla21XZy9KSDF2?=
 =?utf-8?B?dVRTQi9IdDVEbXErZFpJU3RzblNVNnBScmFhL0dOOVVkaFZDN2VXVkZYNENw?=
 =?utf-8?B?ZmF1bEdFS1pOMzFYM3BWNG9ZRkJtSHkvb0NkTmhiNFRsT21kOFBsZ1dUNXhB?=
 =?utf-8?B?T3J5WVJkZmRJMGZJaGptVURmYmh1bDRIVVFNb09QVyt0MlNBd1diRkZDL2xN?=
 =?utf-8?B?enRib3dHaDk4VW9XWm5xV3FyMm01TnBOa2RFSmxsanQvRXMrbHU1dTh4WTBN?=
 =?utf-8?B?YUJzOEhIb09KZlRVWUdrZGdLSGRHZzFkc29oUjRjREZUS3FGK0NGeU9XVy9G?=
 =?utf-8?B?Qll3eEh4RkxCUDl3NkIycjl5bThmencvN0VEempUYUxIeFZPWVpRc01YYzFt?=
 =?utf-8?B?REMzMjVHSlJGYk4zMjNkQWIrM3BVaXE1SU9IUFBBTC81dkV3OUJJdGZjOXBW?=
 =?utf-8?B?akNteHF1VE9scjl0U2FnbGZLOXFRTjY4RkkzdUM2alBFZUFPbHRmdzM1UFQ1?=
 =?utf-8?B?SVJrK1B1VGZ0NDlNRXRZd2l2cXNXSWREeVpmL055VUtIdXpVMi94K3AxcUFF?=
 =?utf-8?B?by82RmVteFJRcHp6TllYeXdoMG1TbmFDVXVoMXhiZmgxL0ZsRXRtemNUZVdr?=
 =?utf-8?B?eW9ZbjdPMDJtZVh2NzkySVJ0alNTaHpwWlF6UHFmM3VsM0ExcmRNUjV3clYy?=
 =?utf-8?B?S2svVWVXVEFIMDNTV0wvS1hPbmZWaW1vd2hLMGl1NTczQjFZaGsrWGdpYXpR?=
 =?utf-8?B?eVl0MFlQQlAwYU9TNm5hWUMwMXBROXRNU1lVcWY2N2N5UE02VjYwY1BVNzNR?=
 =?utf-8?B?akl0TDZOM1J5aUE1OGNxQUNSck9qaFRUZE9BY2NGY0wwWFI0MU11L1MxSS8v?=
 =?utf-8?B?L1lBc1oxVGFXTEplSVdMWGpVczh5VHB5a3duL0U1enBiWHZ5elVGQ0d5M0h1?=
 =?utf-8?B?Q1NJV291b2JHQlJhbFZwNDg1K2Z2YVJYREl4Z3VsYnF5ZEpXY1ZOVjFOWjZm?=
 =?utf-8?B?MEpxWjgzR082dFd3T1lYUHNXK3d2WE9RVFYxNk8yT3N4TEQyOHlUcVVNRWJ2?=
 =?utf-8?B?N3VrWXFrMTY2MlNYMkhpMjRxTWV0ZTRDL2JIRnFLSCt6L0R4UngyeU4yQm9J?=
 =?utf-8?B?ZHN0a0lWQnRFaTVqZnA3eHdjN1RLa3FLYkhQOFZIQkhKRVpjSWlkMDZSZENG?=
 =?utf-8?B?bkhUTWVkN216bEdXWmJsQTdNQm1TMERkcnZqOWtjcG9rNm0yTy9qY01yeXZp?=
 =?utf-8?B?RElDN0U3YXg0Nkp2OGNmVWd6R0tHS2NjZkdVQ3lMeFl3aWZrU0J1Y3VvaExQ?=
 =?utf-8?B?UFBocmFac3FjK1lnQ3lQYjZ3d0JBSHQ2QWlTMVRNQnlpL215czRRUm1jN3Zj?=
 =?utf-8?B?ZXM1S3pWNnR4ZDNkZ1lVYXRpZUVVeWc5QlpUR0ZSNXF4QzJ3VDNLc1pjdGhi?=
 =?utf-8?B?QStvSi8yakJQR3hoZTJHYUN2YXE1MzJ2R2ZSWkt4TDhid2I2RTlRUVhOWHMx?=
 =?utf-8?B?RE8xSmJOZVVaVnBPV0VIWjBvNmxDdUNZSGN4ZENDZDJsZmttNnlzeStsajNh?=
 =?utf-8?B?NExyNzhhOExQekhudXZhTHhNRU95UEllOVlmLzJ6bGQ4bXJ1bnVTdTRzaFI1?=
 =?utf-8?B?MlRwQ0tEeFZGY3VVVVF6VmJ0OHZER3FvNmxMR3hDTHZaZXNrYWFkQjFuc2p6?=
 =?utf-8?B?TmdWZlpkbjVGZXR1MVpJOVpVaURrNXFseXRMNzZTMzBoUC82cVRobG9kVjlY?=
 =?utf-8?B?TVkrOEN3QVd3bUw5bGlockRvUE5MQW5haVlJall3VUh3V0FFRndpOUNMUXA1?=
 =?utf-8?Q?pbRFFfaRq68p267dIFBhvZ+y2NyOnAzd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WVk0MzQxZk1XOHE3Qk1YMzUxMkxZK2VYWFJtRzZ1a0hkdTdaVGRIdFJPWU9K?=
 =?utf-8?B?SkRMSW1US1lBeXVrLzMzZC9KQ1VHR3N0VzB3ZUEyUjM4THcwbmtOSnZzazZW?=
 =?utf-8?B?ZmxKVENpYVdnRUZnU3RGVitadmRaWTFlbkZCNVZiZGhtaVJRaTd3cHhFMDhm?=
 =?utf-8?B?NE5vSThYS3I5NnhiQWN0RkZkMm1LdkxzbFBaTHhmdmVwcVY0bk90VU9lM2hm?=
 =?utf-8?B?V3EySEpKVllyNUhRM2czbDdkWlZLQmdzVEE1ejFkaE8zT3hYenFkNkFsYTJq?=
 =?utf-8?B?RFNoU0szMnVsc0orMzBEYVZIQ2txejlDMURJUDR1Y00xVnVqUTBKT05ZdWI0?=
 =?utf-8?B?ai9PL3piRFc5cTBZcGtGYkV3UHdkelpEVzI0c1EvaFRuRU8xU2lPZTFwK25o?=
 =?utf-8?B?eWhRbWVvZFRackhKNlhyK2d0ZjBkZmxpMHZhUGdhZk5IOXphcGwzU3UzbzlE?=
 =?utf-8?B?SG1SanRJQjI1S3dmV1YzcnEzZnJPMm9RVG9OMUZEalI1TkhXMVZ4dEoreU1E?=
 =?utf-8?B?SmVFc1B2cFpKQ1djaXNHelZ2c0xKRlNadVZ5SEFTRk9lVEE5R2NuL1BQSVhG?=
 =?utf-8?B?bDFRN2ppU2Z4OVBUZVA2a2dURm1XWGNkNEtRYzBtWGppUWxUMXEzTHgwaXgz?=
 =?utf-8?B?VnJhaDdiRy9UdEpaVFcrc1pUbU8wZXhxQTRyLzJ0V0Jjdkk1NTZXNUhZazJZ?=
 =?utf-8?B?U2xGS2pVdkcwK2w2TEpIc2dJcUdDSDNVU2VSQ2diU1M3a05NTVp5WkVQbU1y?=
 =?utf-8?B?M0RWQndEWHJmMnBvc2NhVk1aWjg3Z0M2RFJXTEF2aG1PUXA2eTFaNGEwNnN2?=
 =?utf-8?B?cjR4MThtMDE1VjhXUTBKNThDajhLbHdZTnlhQXQ3VXZ6K1RVbXBaQmNnVm9M?=
 =?utf-8?B?dHRVaWtQSGE2b1M2MkQ5YzJ0SzBpdFlPeUoxV25jRXgrcGc3bnFyRUY5Qnox?=
 =?utf-8?B?S0RCbkErV1JxcVRBd3dCU05sZFJHeGNrN0hoUHlCYTVHS3NrakFhdVYvYk45?=
 =?utf-8?B?aVBuY3Nla2g4THZjUmpzRGpsQ1lnKzJ5eDMvY1phcHIzVHNPZmh3dGI5bWFz?=
 =?utf-8?B?OUd3WFQ1YlJvaENRNElvSFlyVE10dkNDVFBUMzJtNXZqQktRUVFKRnozeXF2?=
 =?utf-8?B?WHQ3cFo3dDh1S2N5WmMwY0lZYTQ3cDB2WnZZcWlMNG83dmNRclJseUZBS21Y?=
 =?utf-8?B?NWJlbDUwekF6ZmdvbEdoWnlWVWUvTHRuNE53ZWIxU0M4azVESGgzdnFlM0Nv?=
 =?utf-8?B?UTRycFRNcjdBVFArblFhUm5UQU1PcTVYWWdjU1EwdlVsZDR6bjdYWi9sbGVr?=
 =?utf-8?B?SXpyeDB6a3ZoUWlXazcyY1hobXJncFNha2YwODVERWRmRUZUWUlqbUg0K2t6?=
 =?utf-8?B?T0hNTWw3L24yZ2hkcEFDMlk4NjZBb1BHWjRRUndEOGFPR3NFVXZzR0hyZ2Vz?=
 =?utf-8?B?dXpzMllTS3JvckNRQXkrL2tPQVh3dGRPUXlrOFB0cEdjVDN6bktJV3IwYVlG?=
 =?utf-8?B?dm92SHh5KzFHOE4xUlhnWmttaHV0VkRVWkhwWEVIWkcvQjR6V2FQQlVoZXhh?=
 =?utf-8?B?SWhJUVVCYS9iWUxwWldlZVdHaE15SERHSjRsQnovVTRpSC9HTC9VZTU5TlJR?=
 =?utf-8?B?V1pRcXRlNHMwbkVxN3Bobm5nZjh1elk1eHhpaGpYamo1MkVZYUZVa1Qwb2Np?=
 =?utf-8?B?cFhvdDFPaWcxejdISFJZWkUra1M1K1VwMjdUd3ZKWmRxZDBMcVI1OERudUI1?=
 =?utf-8?B?MDdKeXFQNGQwYytQM0U4anhoZDgrWlQvbitiV3dLVUVNUkFDYk5JT24yaS82?=
 =?utf-8?B?U0F4VXcwdFozRUUyQ1JmZWV2SGlZeTF3QW03MGIrYkdSK3htcy9US09Fa3NI?=
 =?utf-8?B?Z3Z0RUZ0NWFTMkZpd2QzcFk0NTQ3bm80SmJHYlM5YWFrd1pMR0l5NE54UDZP?=
 =?utf-8?B?RlZqVk9JRkJrdU5HZWhNaXUwaEpDSnlNV2N4aTd0U054V1lHNzlIK0NxTTIx?=
 =?utf-8?B?cURMRlU5Q3d5aUo4b3dFQnVBVFJzYTF1NVdzb3FISU1acnNQdk90ZXlhTzhB?=
 =?utf-8?B?dnYrZ0dJMUxkT2U0K28yOVhvVjMyWUlKVXFuNm56NE0xU2p2Ykd5Zy9HMzJh?=
 =?utf-8?Q?FB/RTSlg1ugAJ3iIFvtBo1AUF?=
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
	c9szNYHzRGSl/08Y26pYu53pdNyfOgHZYjC4sQVvL8yI4oo2VxnqDNPZWatJG2oJQdWpEMeROlJwM7KRmy8d9t1vW0LtpPeujtDtPCzCVBQkErVpD+Gp5WyqNQCh0Yy9PEakO/6rXzGXrTwCcVj4sBIBH9XNVradICVvHi1bk/SfElxmGQMCYTxwDmaGkFOmOAahj26enymc9mD3756dgGrc9CDgTfCSnibIAMcs1Zo0RLcZNqotJ5u/NXQ1tnDAL5O8uaVBrp3U45qvypU8tV4M+pBnTnFqjD/ySkAm1M0hnElPgkkLWMA4ActpejboXEPfEu+15bVYtVmpeiakvYaC7TCkZSFz3P/rt/3/jjQqJEctpgzp4FUKRY1qxfDoyqNGMTmBlCnsJVR8DCOXZli+zkJPYXMAyO8F+LgOTqh05FGEKV+zFP9ZLZ6MQEGNG+EP0Xq0FnbDaEUMXf125RKafZsa6y/GFCBnAlJOJOMaqeuasaSqUsBAz4KMPxbo6d4kTBhgExB6erJX08DSXEsSEl1xruIJB2N+FwbVyzc5+Or9EF+7T7/XpaTZtuDpLr2LyKhSy4JTJnvs9W+jpZKtGUlcExZZkCGVYzDJazBGB2LNz9G6ibTV3vL07mmT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199cd37a-1831-44f8-4f65-08dd3c757215
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2025 12:48:47.9093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qy0um2UW7jxEwYVUlIWkEYtW0LKQwUNHwSwTOUIsR+0lTX2Lj83hI2/fnDFolsF7qbAkQQZdCgDVDxbv0rmIRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7076

PiA+ICsgICAgICAgLyoNCj4gPiArICAgICAgICAqIEluaXRpYWxpemUgY2xrX2dhdGluZy5sb2Nr
IGVhcmx5IHNpbmNlIGl0IGlzIGJlaW5nIHVzZWQgaW4NCj4gPiArICAgICAgICAqIHVmc2hjZF9z
ZXR1cF9jbG9ja3MoKQ0KPiA+ICsgICAgICAgICovDQo+ID4gKyAgICAgICBpZiAodWZzaGNkX2lz
X2Nsa2dhdGluZ19hbGxvd2VkKGhiYSkpDQo+IA0KPiBUaGlzIGNoZWNrcyBpZiB0aGUgVUZTSENE
X0NBUF9DTEtfR0FUSU5HIGZsYWcgaXMgc2V0LCB3aGljaCBpcyBvbmx5IGRvbmUgaW4gYQ0KPiBz
dWJzZXQgb2YgdGhlIGhvc3QgZHJpdmVyczoNCj4gDQo+IGRyaXZlcnMvdWZzL2hvc3QvdWZzLWV4
eW5vcy5jOiAgaGJhLT5jYXBzIHw9IFVGU0hDRF9DQVBfQ0xLX0dBVElORyB8DQo+IFVGU0hDRF9D
QVBfSElCRVJOOF9XSVRIX0NMS19HQVRJTkc7DQo+IGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlh
dGVrLmM6ICAgICAgICBoYmEtPmNhcHMgfD0gVUZTSENEX0NBUF9DTEtfR0FUSU5HOw0KPiBkcml2
ZXJzL3Vmcy9ob3N0L3Vmcy1xY29tLmM6ICAgIGhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX0NMS19H
QVRJTkcgfA0KPiBVRlNIQ0RfQ0FQX0hJQkVSTjhfV0lUSF9DTEtfR0FUSU5HOw0KPiBkcml2ZXJz
L3Vmcy9ob3N0L3Vmcy1zcHJkLmM6ICAgIGhiYS0+Y2FwcyB8PSBVRlNIQ0RfQ0FQX0NMS19HQVRJ
TkcgfA0KPiANCj4gPiArICAgICAgICAgICAgICAgc3Bpbl9sb2NrX2luaXQoJmhiYS0+Y2xrX2dh
dGluZy5sb2NrKTsNCj4gDQo+IEhlbmNlIHRoZSBzcGlubG9jayBpcyBub3QgdW5pbml0aWFsaXpl
ZCBvbiBhbGwgb3RoZXIgaG9zdCBkcml2ZXJzLg0KT2ggLSBUaGFua3MgZm9yIHBvaW50aW5nIHRo
aXMgb3V0LiAgSSB0b3RhbGx5IG1pc3NlZCBpdC4NCkF0IGlzIGFwcGVhcnMgd2hlbiBjbG9ja19n
YXRpbmcgd2FzIGludmVudGVkIC0gMWFiMjdjOWNmOGI2ICgidWZzOiBBZGQgc3VwcG9ydCBmb3Ig
Y2xvY2sgZ2F0aW5nIikNClRoZSBiZWxvdyB3YXMgYWRkZWQgd2l0aG91dCBjaGVja2luZyBpZiB1
ZnNoY2RfaXNfY2xrZ2F0aW5nX2FsbG93ZWQsIG9yIGJldHRlciB5ZXQgLSBjbGtfZ2F0aW5nLmlz
X2luaXRpYWxpemVkOg0KDQpAQCAtNDE1MSwxMiArNDQyMCwxOSBAQCBzdGF0aWMgaW50IF9fdWZz
aGNkX3NldHVwX2Nsb2NrcyhzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIG9uLA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsa2ktPm5hbWUsIG9uID8gImVuIiA6ICJk
aXMiKTsNCiAgICAgICAgICAgICAgICB9DQogICAgICAgIH0NCisgICAgICAgfSBlbHNlIGlmICgh
cmV0ICYmIG9uKSB7DQorICAgICAgICAgICAgICAgc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0
LT5ob3N0X2xvY2ssIGZsYWdzKTsNCisgICAgICAgICAgICAgICBoYmEtPmNsa19nYXRpbmcuc3Rh
dGUgPSBDTEtTX09OOw0KKyAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoaGJh
LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiAgICAgICAgfQ0KDQpMb29rcyBsaWtlIHRoaXMg
aXMgdGhlIG1pc3NpbmcgcGllY2UuDQpXaWxsIGZpeCB0aGlzIGluIGEgMm5kIHBhdGNoLg0KDQpU
aGFua3MsDQpBdnJpDQoNCj4gDQo+ID4gKw0KPiA+ICAgICAgICAgZXJyID0gdWZzaGNkX2hiYV9p
bml0KGhiYSk7DQo+ID4gICAgICAgICBpZiAoZXJyKQ0KPiA+ICAgICAgICAgICAgICAgICBnb3Rv
IG91dF9lcnJvcjsNCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgR2VlcnQNCj4gDQo+IC0tDQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiAtLSBUaGVy
ZSdzIGxvdHMgb2YgTGludXggYmV5b25kIGlhMzIgLS0gZ2VlcnRAbGludXgtDQo+IG02OGsub3Jn
DQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwg
SSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0IHdoZW4NCj4gSSdtIHRhbGtpbmcgdG8gam91cm5h
bGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4NCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2YWxkcw0K
