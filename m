Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C4560B8A;
	Wed, 16 Oct 2024 06:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729059766; cv=fail; b=YQMgHUD7Joy8RCsThkN5+gZheuJ1fWTvmv59n/lLEO7XkeGZJREIhsBGjPX+BHrpek98vp3fKzQg7OSRkMfQaUwvXBGuoWesfU2bvjpd831J4zsKNn89VJZL9gNjAJEE7p8+cEMafGtAsw1CdVEZDp4xP+SMDC3NSnDYpOBFHh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729059766; c=relaxed/simple;
	bh=WPhK0r/HGStHDc8Iu5tmmeuZws0GORiZ6I1PeAdpdDw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TC4K08MGBzDZlZH3UeNbvYe3DZCXp9Ap0xSuCsOx8Zv3kUNeFjBnmQUssml7xc5ymVYNKSdrLKsQLbQ/ddW1swHwOiH5tVSrVO4ta9AO4o5Y+09lahqYjNV6tT/CwPVgTK+wcTLW16YDvQmsJBuaRAQoAnL615HSu2AawZ5VWKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ME4XVpaY; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Hs+JXCfR; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ME4XVpaY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Hs+JXCfR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729059764; x=1760595764;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WPhK0r/HGStHDc8Iu5tmmeuZws0GORiZ6I1PeAdpdDw=;
  b=ME4XVpaYV40fKIoHfh9/6oF1o/9uDXP6v9GNh7ffQJ6pyp/WAVKvXQ+u
   sLl6EgqlynnYS1wGNdGb4tfxWXN6GsYJ8Mfuw2yWbkBfBmBDjoNmD079Q
   BFXHl3CMmk7wq3+3pI5OSZIYUjRMwTVnJGtd7VP5kEaXRXUG3evkVTxFt
   efHns9wc9q9udCwUgRBIaPVCXrumEXfZ48y8HZXCvZbg70PHKN+wsfxS1
   uLa9bTcQTsR+t0XIxBkHTMZpH5nVyUCfbiADqzugdDzBKwEBU1iSrYswQ
   I7pGB7Pc5KwEX3xvZI1ubfAhO9VuwfXaHvUfe2ZvBMPhSe4LvTdpa0aEG
   A==;
X-CSE-ConnectionGUID: UqV9kb0/S0297sgQKGrM2g==
X-CSE-MsgGUID: 0IJjQb4BTXSlwr6guuyv5A==
X-IronPort-AV: E=Sophos;i="6.11,207,1725292800"; 
   d="scan'208";a="28452144"
Received: from mail-northcentralusazlp17013058.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.93.20.58])
  by ob1.hgst.iphmx.com with ESMTP; 16 Oct 2024 14:22:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psYzTqtKaIewzovtgrqVCwJR9WEhN3iw4SYsn56Q6rVpvXVp0AH22UOgYN79EXkdazFnXzPd3Uv+SMJ2iouK8Sv2ABaUN875ju/N6dlwCocVRl4aQnRSWu4y+3YWUZmWYx9nCpDYvoqNVF72kOZrpiSLC6XOX0JpzkvikidQm7jod1km/P6aYqw6Hzt4n2p59OIzv/uAjoeu4BwgNLXahuiZlZ1ua65f28bcIChfTVLe7cEzB8sk/LfGv3iB5mrJgwVlnWUqLpZyHeyKFeC1gTeB1rwCBOT8cJHe1unCWPWWm1lW2def5GEvsXTcwXbwgVPWy/ous622jYBXQImb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPhK0r/HGStHDc8Iu5tmmeuZws0GORiZ6I1PeAdpdDw=;
 b=bDPq8vtCvx9bocB5gEXmYtIl5m2ttpC3jzoK20KN0INTefIILb+I2kR2KpfpqtGtUQszJ8lmJtus9bOfmsIvJX8ZuINjW1/engxTgmhpxYhTRmEy5t9GzPPnjOF59RNASj9DRgsZKKBDphyGxdSX99A3UlHoHtHX7A73JGsiGXtUbL9bEZsWIIAxtwAI/odFzPnvT46Q6dBmmSex1QrABEej/E/AKsqmn53sJOrvnmb1wz67GoJzLxWf2HubSUpbTeafJWBykQHJxLfTPTq4oQe8EZiV4CeO/qeKRoj9dGp7qKvGbQ+eA4SWjVi3O341hVASQkSjcMcGI3Ak2FDNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPhK0r/HGStHDc8Iu5tmmeuZws0GORiZ6I1PeAdpdDw=;
 b=Hs+JXCfRq7Y9B4XOmVeqzc6rBOxSSdLREXqZiGYpPxqXmvNbKiPnA0ymcgbMQ5EsZ7DmICo9yNmKlHAyoKA5qHbJPpgInQdjwUI5kqfd7WOze4GwkccZuRRfWp+3S61YFti+NJdt3eX1xwTpqmTizyn8CuLrsBRwF32UiUvidSA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7860.namprd04.prod.outlook.com (2603:10b6:5:354::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.18; Wed, 16 Oct 2024 06:21:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 06:21:22 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Use wait-for-reg in HCE init
Thread-Topic: [PATCH] scsi: ufs: Use wait-for-reg in HCE init
Thread-Index: AQHbHr79yYIJ2F9mUkGd2RETR0tc7rKIFRiAgADUZwA=
Date: Wed, 16 Oct 2024 06:21:22 +0000
Message-ID:
 <DM6PR04MB657551BF4339F8EB494E0DBDFC462@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241015045711.394434-1-avri.altman@wdc.com>
 <4a54b449-802b-4d76-9551-038a0b05cc51@acm.org>
In-Reply-To: <4a54b449-802b-4d76-9551-038a0b05cc51@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7860:EE_
x-ms-office365-filtering-correlation-id: fb37d39b-f61b-41ba-dc43-08dcedaac197
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ek8zbnNucXJkVlJyYUF6ZGNxaVB2bDU1SnVDM01TTnhQZlJtM25NVHZLaWVj?=
 =?utf-8?B?KzBXTmwyZ2ZFaWI3Sll3U3kvQnE3clR0eVBNWGJzUTBvZTc1SWlzbUFkem04?=
 =?utf-8?B?a0RKVDVrclZZUlllRzI0STZoTGIwME4rcWwvV1EyaDlEVTFyTWdNZGlleDVp?=
 =?utf-8?B?SjlwQnA1eVFsMVAyNG1paG5vTlR4b0QxQmFTaGp1d3MrTTJiMFAvY0dYQUJU?=
 =?utf-8?B?YWJ5ajFvV3pLTldlOEJ5aEZHczJVN1ppbXhSY2lUbThaeWpKZ0xkT3Rkakl1?=
 =?utf-8?B?bTdZVTZ3TkgwODhYRWdROHEzU3ljaHhlcmcxa3dHblZETWJJdkoxalJCdldE?=
 =?utf-8?B?eFlaL2EzNk9Fd3ZHbkxlckM4NzJzT2FCQzNCeWY0cGJmemErQ3FRU2NKcnF0?=
 =?utf-8?B?d1VEZlBFMkdnTURQRXJYcFpkMUhHZ093QlNqd3c0UlM2ekpwZHQvbUhJQ3Fm?=
 =?utf-8?B?d05WRDN2OW0yK3RJMGdEV2U5SFkxMFluc2NLRUkvenRWSTFUVkNUaGxHQVhv?=
 =?utf-8?B?TEVoYnNaZ2NKQVZMdW5jSkpSeTk0SUZLSDdQOS9XL0c4NU9hMC9hbUlRMGZZ?=
 =?utf-8?B?WGZsRDdUZ0lEVnZBMGRianc2NnJxN3p2dElvWGVKTXlPalpuSXNjV1BQYXVm?=
 =?utf-8?B?VmRFdWZyTTBXaHpKZTBtVE4ybzV6OERJMjQ5T05rWkVtWTJHQksySHU0bG1T?=
 =?utf-8?B?VEtNNGJiUFVadFpCYVpmVzZoYWVOSi9rZFRua3pTSXBQclVrdXFZWlgzaU9k?=
 =?utf-8?B?bWIwdVEzeG1pb2ZzdVJYNjRQaGdHOVdzbE8wbm5aMGJQNkVCZFR3Y3Z4TUtN?=
 =?utf-8?B?NE1SYVFzNlFzaHN2Zy92Y05EeVRFY1MyLzFZVVE2ZGtGLzRHeUdVVnhiWHVt?=
 =?utf-8?B?R0hLbmhGSnFmclBXMGlyejhhandFWmtMdFlqSldZbmxBYldueVVaSjV4cklM?=
 =?utf-8?B?ZFNIbmJQbGllOGNhbDRHZFJMcHh3RStVWk9sUUpZb3hTSXhxbjIzNWdZQ3pX?=
 =?utf-8?B?LzcxdFk2OWx5NXFIeDNKVTRBcnFMMnJiUVJFQ2hNM0ZudlNucVFPT3A1UGd6?=
 =?utf-8?B?bitTYlZ2TWJWQy9ZMkUxY0pNSEl0aGdwZU92UnlVTHB6MWpwM3RxMW5SQy9x?=
 =?utf-8?B?V2IveGRmblNXSVJ5S0dNc1J4WmlMdFN0TzNxUktmRnZIT2xlU3dGMG5jbVho?=
 =?utf-8?B?ZmVnRmFhWXZ0c1VGaHJZM3BhMi9SQThQM3lhRmUyb3RONWtod1NSYTVMSEFY?=
 =?utf-8?B?emJoMTBidXlIVm50ano0TC95U2UvYm05QW00VTk1eFBuaFFCdFNEMFh6NkdX?=
 =?utf-8?B?bXNFYVpUendMbE9lckFXMjlSdmFIK2hNN3V3K29lWjRvQjZzc0ZQbU42d2Yr?=
 =?utf-8?B?SDRYUWUrNU0xbnp6OXQrWkMrelArekgvWWVFb3MyTmk5dlF1dTlVQTVBdXl0?=
 =?utf-8?B?WGR4aU5sZHVQNHhvVHlCcWhEbmc3V2VUWEN5UFNxK2kvUmhrTkhpelBSMGF2?=
 =?utf-8?B?eVRZbVlKOFhodGxPU09GM25RcWJsUWVBbTFRUUZpejhkY081bDYzbDkyalFk?=
 =?utf-8?B?UHRia3A4Wk5HUDJwaDlyOGs5bHBRaVFZSVFnQ0ZqRTJlV1FUWGR6alM1UWph?=
 =?utf-8?B?U0o1d09aRHJvYmpaMVdTVW5SdUU3VGNBRk1pWmlaR0Z0TDdLQzYxMHI2NW5R?=
 =?utf-8?B?SFdUb3REN2MxaXlCSnhvVzhjYUJwMzVTZU95VlRramVYdU5NOG8vMHFPc2lw?=
 =?utf-8?B?VVI3dXNkSVlJNG1KOXIzZnVxOWc5cUNWeGV1QVpmZklWc1ZWU2dqbGpCZnNl?=
 =?utf-8?B?dW96ZVpoK0dzc1Z1M2hhZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VytWcWhQTCtvbDc5NkJ3S0Y2RVl0djhydHpUbnkrMmZjSFg2WXhIZFBDMGV5?=
 =?utf-8?B?T09xait4NnBER0RERDBPK1JHTWR5S2xuWWorY3ZIZE1tenpleGlPNGxoZy9t?=
 =?utf-8?B?L0ViSEkwM3k1VEYwanZNcVJWZHNlT2JaYjh2a1lTTU1UazQzWFRrQ3dobE1r?=
 =?utf-8?B?TzdmQU14WVB1TmJNZjVqYTFXUXNxNXdZcHBKSWZNanA1N25WZytrdDlyM1lk?=
 =?utf-8?B?c1MvTzhQK3Jvc3h2QWFNME1KZUxRQnFZQXRyV1daaFpZVEI4M1R2Ym1VTXJE?=
 =?utf-8?B?MUppeUR0WTNPQU9ubC9ZenYzOVc0aU9GeXV1WEhjU0pKSXd2WHdCYUdTY05K?=
 =?utf-8?B?aHZaSlA3SGZGa21SV1hCa1BEWnlCQ2RuakZwK0JWT0VRQUJqbHFTZ0J4QVVv?=
 =?utf-8?B?a2dqNTRYMml1cStmUTFEYUVrTE16bk9vWHFHR0pxcnUzMGEzd3p6SXBNeVNZ?=
 =?utf-8?B?amttR2JORkdkc01qQ0lZMGx0MU9tQU04SjdLOWNYR01mbHZ3VmRVYXB3OTc0?=
 =?utf-8?B?SjZjME8wRTRPcEF4MDJyU1l0RUZzSVR6MTdNclJ2MTV5Tm52ZzkvT2xSblNY?=
 =?utf-8?B?Y0tHWCtpbnVuQkpnT0hkZW81ekd3a0VsL3IrdEJHblhmMkE2My81QVlDdHdy?=
 =?utf-8?B?dS9ERmJVWnlYYktBM1lnMkdOZVhUbUtxWmZEUVg0V0RKbmZkb0ZnZ2lLQ2Fr?=
 =?utf-8?B?NWhadGVOK0FLNHBrQnh1V3FoMEwvZnhhTjU0WXRIdVQ1TGhXbW0zVHZ2TmQy?=
 =?utf-8?B?MDhiN1h2ZHRBMklLWlJLUnRmSEdEL1VoRGV1ZUE3akxpN0JES1RZdkNHRjlw?=
 =?utf-8?B?SFlqbW9WZEM4dGhsdk90Snd6Vnk3WmJITWxQVGVBcmRubW5naHF2TzNqQmlG?=
 =?utf-8?B?Z3NPRlhhTTR2U1FuZ1RXQ2N2K01vamFKNzNXTEhUQ0ZtbVJMMlRVRkFJYWJX?=
 =?utf-8?B?L0RwbUNvMmNCVTZRdFd1aXpFVVR6dDBvbVdadmlYVG5uS0NIcmUyaWo2QTdE?=
 =?utf-8?B?WTQ4dXpHeHBPNmNxOUsxZE4zMk1lNnplNDZBeUxOM2NUZ3VpbWU1ZkFzRmdH?=
 =?utf-8?B?eVBPY0tKY29iM3lqZmZtdkg1T2JnVHRSNkIvcWRBeHY4b2NEZ2h1dlJpTFlQ?=
 =?utf-8?B?WFNNTy9uWDltTHdyRzRXeSs3c1YvS2RaeE9ZbVJzVTRzOGRqYXJwdlV5TWV1?=
 =?utf-8?B?V2QraGREaEZNUDM5N0RrelBrc1hUNiswMnAzWko1a29HRzJISTJna0FqMnJ2?=
 =?utf-8?B?d1dCbGNwYTQyRW1ncW0yRDk4eFdlZXZ0VGxZMldOQkhIT1hIbyttdHN1VWVO?=
 =?utf-8?B?RktvbG9OMW9Ta1JxYlZlLzFzWHYxbC9BcXhyQ3FRYVZ5WllkL05qMTdKNjF2?=
 =?utf-8?B?N1JidmFZd096VVcwck1ONUFzSnFXemRvdm8zNWRZS2pzNnFITlNNbXkzb2pD?=
 =?utf-8?B?bWEwODlTT0ROVE1mUXVEMU5OMXRTelJvTmVPTDlrNHpqMTVTVndDR3ZDMXU0?=
 =?utf-8?B?VmhBc0tyam5sS0E0TVdneUJxdkJYM3NwV3JpUFBXQmxBYVNIR3FwYnZRdzBQ?=
 =?utf-8?B?L1gxamxQWS80UmpZWnpMNnEwbFVNbENaVHVSdlVUSXQxWHVySWxaSG82eUVN?=
 =?utf-8?B?OWJUc0sxeUVGZ0djbHdaT3BkVkNiVTBPN3lHa09USjZhMm9JODBGdEI5SW5T?=
 =?utf-8?B?c05JYkJQS2RRNTlpbjhuQlZnRmNXYjZlRTVyMVhTcmt6amJCeUFvNFdBOHdQ?=
 =?utf-8?B?aFNuSWZZYldnY0pQdmlWZmtXTlhvcmI5NWhTb3lvc0RIK2h4M0YyMFFpMHpk?=
 =?utf-8?B?RmpMQWhkcVNlM1FiSlVMeU9sOW5DK05MU3pWWjA0cXRJTEp1UUxtZUpvVnhs?=
 =?utf-8?B?L0krenNKdlM3UFUwK2pEakw4Qm1yOGRBeWV6RnJNZVUvNnEyR1BGZWw2cnM2?=
 =?utf-8?B?ZmhLWU03cGZqaFQ4MzlNeU96RU1KQ24xaWpoTnVzemh1S1IzcllMbU5oUmp2?=
 =?utf-8?B?dGh3YlJhNDh6Vi9wcDhBRlV4ekVmOEdGS2hDVmtGZ0tvc0srbE1QY3RBcFhZ?=
 =?utf-8?B?djAvVlUwd0hMSXVldi9BLzFiZFN3ejkyRmRlWUcrU2NQdFF6ZVZCb2kxNDAw?=
 =?utf-8?B?UmFXR0tTQ1RTQWVGNjNyeUNVbnZheUFzNSthZ3FReVJSTnlScGFLbXZ2eVFM?=
 =?utf-8?Q?5aNZO0PiQSuoPhX8cGtfO5NPrtjwUocYH15va/tNDBTl?=
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
	tshhNCwash2z6C4lAsHG0vhQqrSa6mePD9wjvp+BM/Nhx4MgqsiyjaHsSnnT5Nsx5k6G/C/yz5iJbSA/pvdRbfQcnE+tpAiEe992xx2OWbdbPKNZpl1u3Himhp7lb1VtDoIeyLh5eI/t9oyZ3Cv78HqOPOAQt8W9tiNKO7pZvD7RWz3yOvEM8+lZeqZVSxmcMtihMY+pOvD1Pr745toQv702txaonzQlmc64U1ChiQiPWj1gpFpgBfjkgMFCVpJqrsjDniGbysrsfxw9paoJF2gRrD3XiRhCpB/tQgHkR1BbpW1EdFLQ499Wn772W7lR3SVXGJ9Rcuq8qZXZzMW0tcxWI+IRUnm7GpZWr/kGu40rUOk/pcmSQRJY+Jm4Rvj0v+8pi0tsfIdC3in00QvwcRIIlgGytMPxSzS6JMoz9tQ1Xs/cSmtDISSp9Ix3WVrfqEh1t8ZS2wiOVquhcOgNrSjw41BsqYgWdAtyt5HU0xyMsb5JRFORMD65ot2Ey6tdUqmkgxtoeZa7JRmtHEQwfcN9N3cQPpBp4MSTL+7qO6mov6ljYdrnDvTNRJH3WEvg6f+KzZtN/X2lkEkMdHzFCe3eNxwpGe7GP1ozuiXaAhrumV5zwdooh9Fn15bsLF2X
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb37d39b-f61b-41ba-dc43-08dcedaac197
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2024 06:21:22.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cCYmR4AbUQhqpW+jco2e6KnTy+0N6w7pgXTiH58c2kEYX8gZKXCmJ8iYBiyAd/Es+IfGkxSTZRFWyPayXlB9ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7860

PiBPbiAxMC8xNC8yNCA5OjU3IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBJbnN0ZWFkIG9m
IG9wZW4tY29kaW5nIGl0LiAgQ29kZSBzaW1wbGlmaWNhdGlvbiAtIG5vIGZ1bmN0aW9uYWwgY2hh
bmdlLg0KPiANCj4gUGxlYXNlIHVzZSBmdWxsIHNlbnRlbmNlcyBpbiB0aGUgcGF0Y2ggZGVzY3Jp
cHRpb24uDQpEb25lLg0KDQo+IA0KPiA+ICsgICAgIHdoaWxlIChyZXRyeSkgew0KPiANCj4gUGxl
YXNlIGNoYW5nZSB0aGlzIGxvb3AgZnJvbSBhIHdoaWxlLWxvb3AgaW50byBhIGZvci1sb29wLg0K
RG9uZS4NCg0KPiANCj4gPiArICAgICAgICAgICAgIGlmICghdWZzaGNkX3dhaXRfZm9yX3JlZ2lz
dGVyKGhiYSwgUkVHX0NPTlRST0xMRVJfRU5BQkxFLA0KPiBDT05UUk9MTEVSX0VOQUJMRSwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIENPTlRST0xMRVJf
RU5BQkxFLCAxMDAwLCA1MCkpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+
ID4gICAgICAgICAgICAgICB9IGVsc2Ugew0KPiANCj4gImVsc2UiIGlzIG5vdCBuZWVkZWQgYWZ0
ZXIgYSAiYnJlYWsiIHN0YXRlbWVudCwgaXNuJ3QgaXQ/DQpEb25lLg0KDQo+IA0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICBkZXZfZXJyKGhiYS0+ZGV2LCAiQ29udHJvbGxlciBlbmFibGUgZmFp
bGVkXG4iKTsNCj4gDQo+IFBsZWFzZSBmaXggdGhlIGdyYW1tYXIgb2YgdGhpcyBtZXNzYWdlLCBl
LmcuIGJ5IGNoYW5naW5nIHRoaXMgbWVzc2FnZSBpbnRvDQo+ICJFbmFibGluZyBjb250cm9sbGVy
IGZhaWxlZCIgb3IgIkVuYWJsaW5nIHRoZSBjb250cm9sbGVyIGZhaWxlZCIuDQpEb25lLg0KDQpU
aGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCg==
