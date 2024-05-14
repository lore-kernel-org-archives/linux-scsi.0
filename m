Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C2E1DA2F;
	Tue, 14 May 2024 20:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715718884; cv=fail; b=eC8PrSCpd+w+6HvvpDIRbFtOlk5rbGIdSlavOq0DOkbSl2LZLRtp3DkLyKdOPdJWJb7DmWh+zvTvcu/gMqzqil7ece2AQ3at87/XlLdXQ1q4kjDW14N06BSyTC0+KoHMl4FpfsTr0zJd6ix6eQgYeVjwlrrPcqJcl4GTHVLlDTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715718884; c=relaxed/simple;
	bh=YE60MrueqGgKDtz4gPe8vifbqWPkgrCrHOK6Slrs1LA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FTZqJGQ/hnvfoWpSi59OR60z2nGJhqTyw0HixcXIsqk8a583AaXtiiw8TzxYzxcT5ZxJkMBYPoUDIyqyIm0m9bvV2jiDV6rx5zqYRKNgUuKTfC5d76Y/u58kxSllZU/6207xNUKzRvzANyC/rddU/HFTNJZMqy+65LEhRU4pgV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=E66mGjeH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=HJcIhKd1; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E66mGjeH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HJcIhKd1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715718882; x=1747254882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YE60MrueqGgKDtz4gPe8vifbqWPkgrCrHOK6Slrs1LA=;
  b=E66mGjeHyTqXmSbBok5PydnKWR9Nnsgb20qSiMKHuyOsdcHccvzgBV0c
   Z8bMvoX2fmYgR8axCUsnFncfjwLXukx2GvClY2ykOsDQ5tKVA+3suZbF0
   v6oN6U1rHv97e9cU8ypigUukUDgehSa6GZMBwJOWe/hSyTnledWo+GA/Y
   bDMJmcpcMBnD7X1JuOIF5qTm+a82dfTEofpTX1ZXpF5RMO+yM7y0utshR
   kXV0nrCrUbqCbEqAuY01TsXSentPiAcvLXufKZJWeKW8dPa2GTMJ6Y5Rc
   M2x3col68NzX5F6jMmmITP5kJkrNWClfzs4dO0VB7YVfNAhhfWbtpWLnQ
   w==;
X-CSE-ConnectionGUID: coWcdxERTSCBmZudq20cmA==
X-CSE-MsgGUID: awuZq9HdRgOHfyQaQXP9tw==
X-IronPort-AV: E=Sophos;i="6.08,159,1712592000"; 
   d="scan'208";a="16384035"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2024 04:34:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFl6brRZmBGJYSgSgHI6WjrN763Z6Fjaz7+k48Xpm06YGyzk8OTL5bapugaki/U5BGT5uOAC2RBglNOqEakd1o+SN8N/L+dS7DZQvrlDcJITOI1K0qqNUdvtgoOqL71Lk74je9v+HD8CdNGsipKvlQgl24HyXJUKsRlwm+k41ZzBU7s71HWaLQ9iheN2GTI72YV4ufEQ3p/c9xv5/p6tiGAlNl2OEDUdPhsTYG8ClQxoiAeR6mBVZr3nkiFGA+/MDMnbLtG1eaLO/IQ8GJwszor1MlK8MACCgvDnR+kgacxgZJC1kqiws+SV2/yWG2OBfskQydPDZXvmURzQ9cYXMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YE60MrueqGgKDtz4gPe8vifbqWPkgrCrHOK6Slrs1LA=;
 b=Zgki+LPkTJN4jY1cY1AoMKPMQF4/LFScJUH+9Tywk3GdSAhj/BwayGSaJyQ2JBY7j3GqSXJ+I8Huo2iZYk89RsJ8IB5mPIeF3PEOohPnf8q8QChvezgiaDOnBiMCcU2JYmmsQnzNKBjqbPrkanHEwaIaEyl0cQ2mH4tor/eJ/31yLQi6aqrxdgioaiOY2pskxorkOUsqZ3bDO3M9aF0GnAHPumWNJzkoqniSgfJQHp6r0xeUbTy9ruLHdaz5tC5uXcVItmHHYYUNriNrQ3eMk0a2qvE9my8enyAeMLUUoOZpuh1iC3YZOIVPeb32dDKtH/6cb7sk8Jd4CZ8DSfhirw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YE60MrueqGgKDtz4gPe8vifbqWPkgrCrHOK6Slrs1LA=;
 b=HJcIhKd14ELFJrxN24nRZtM4HlpNQnGSSI1XRdAkGk12OdKOXeAV7oA7QiacTErrMbqZnakkWnh2pz2+BRer5qW7HqLT93w6B/GM4R7SHnCfcJaSZKuXiPj1elSa58zEF/RUHks0qRy5Xd/z1p9OrjTGsTnoZ0tX69nsFqdkrIk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 LV8PR04MB9224.namprd04.prod.outlook.com (2603:10b6:408:257::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 20:34:33 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.025; Tue, 14 May 2024
 20:34:33 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHapbzIAmCD9ZFsDE2/LZDUaio3E7GWsCQAgACAZcA=
Date: Tue, 14 May 2024 20:34:33 +0000
Message-ID:
 <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240514050823.735-1-avri.altman@wdc.com>
 <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
In-Reply-To: <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|LV8PR04MB9224:EE_
x-ms-office365-filtering-correlation-id: 8b0fda33-dafe-4f6c-0d1e-08dc7455436b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?OFRWRDRXY1dUdk5VaGs3QkhhcW5ZTjIvRmsrUjFMa0dHQ0tFK2ErOG4vNDBk?=
 =?utf-8?B?OVB0Smd3cFFuZmUvTFpoVzFyZU5BZXRMQ3JyL1Z4bGlpVTVvUW15dGVqbWow?=
 =?utf-8?B?QVhLTTladHB1ZndFQk5KUy91cmJuWk1ZeHZyeXpIeXRZL01kRGpGSGpNM0h1?=
 =?utf-8?B?MFdJa1NwU3hsbWRic0FkZXNTM1o0TExOcUVadndtUjlTdXg4b2JHZ1QySFZE?=
 =?utf-8?B?RHloNFFIWVQ5MDc2QXpSekhlcmd4VHlrTndZU3JCOW80eGg3NkVhY0VYZUU5?=
 =?utf-8?B?RGxkVHZqUTFzcjhZa0Y4bkYrTWR1YlNQS2lIZmk2Zm1vYm83bG51TWo3czRW?=
 =?utf-8?B?eC9sL21PZEhDU2F2UWI0RmtnWmxNVkF3RENQalYrQURQMktsRGc3OWRRSVVx?=
 =?utf-8?B?UWt1TG1OU01FaUZYMTRuK0RaOGhlRUpEMG1iSWpLeVU3WUZWeVEwUE1YSjJa?=
 =?utf-8?B?NzFIWE95NVNBWEk5RldXcnlaVndoR2ZLbTNHQUNoeUIyOWxxRXdtWGNWazdv?=
 =?utf-8?B?bXc4S3MrRmtlRVJJdmlrRGFyR1RVd0FkZjYweEFFM0Job0o2Unc1MFd1MlpJ?=
 =?utf-8?B?ekdtS1dYVmNmaWdHWVhFUmQ1WFB2VW1xb3JNa09xUkVFTm8rU0o1bVZiekdl?=
 =?utf-8?B?azdFMmwvSXdtcklUSDQzZ0hwZXdITUVzT09vd3g4SUZ3Ri81d294MXdtS21C?=
 =?utf-8?B?SU1IUDZtK21OUGFFMmx2M3NaeXozQ3hmL2Rsa0djdVhPZGgzL01udnBsVFgr?=
 =?utf-8?B?VzdTeERRNUIrbW9OYnpQZ1lmT1FGVlg3Z0V5cWYyckZ6YVVneEduNlJDRmJW?=
 =?utf-8?B?MGRHYlgxNmdWaGpyMGcvcVkvTkdIbXdrYWxzNXE0SkdyeWFtbE5QamFiU0px?=
 =?utf-8?B?aFQwcXRJQTV4Mi8zUjYyV0FjcmVZb0NFWjZMczVHQjd3b2ZmTGQ0Uks2VHBZ?=
 =?utf-8?B?OFJyQStOb0Y3NWFNYVJlNTk1UjJTTVpidFY4ajVkL3d6T0JJMi9FdDZJVG1p?=
 =?utf-8?B?ZEpUYmhTVHdUM3hRayt4VHZuY0hoSENaYnduRHVKRldLSEEvcFgyR1c1OWtH?=
 =?utf-8?B?M3JWUGFmamN3dnBFOWpDeWd0aXdwMGtNK1lUczB4ZFRFL0s0R3RoNnpXT1Zl?=
 =?utf-8?B?bFlPOE5Yd1hJNDlZSHFpeEJwZzU1TnNpUEFSNU0wOExtS2crd3oxbjBYVXFa?=
 =?utf-8?B?a0dWU01wRXB2U2MzZjN3MithOHVoNS9NUGE3R3hIclNRYXkvK1VDUXNoZlpG?=
 =?utf-8?B?bEpoeHc4VjRqWjc2eDBHT3hFUDJpNVZtcU1GVXFMSSsweUc4RW5XbU90Kys5?=
 =?utf-8?B?UFhHV3ovZk5sb0ltUWFMYWFsSmRVWmNJTjh1RmJLQjFsSHQzSmV3anRUcWx0?=
 =?utf-8?B?WUdXN01Rd25BK2dOVTBmWTJjTlZmN2gzK3JMN0hpWE5sRTNIRWlydklwZWls?=
 =?utf-8?B?amxaMzY0L2VwaGpHZ0E2UWlNdjBtSkkzcGlDei9BRWNTL0RDTjMrREdOeGpq?=
 =?utf-8?B?cnphdXBkR1BwZGVPSUVUUXpaZllNaGcvWERpVkhQK3hoVFNGN3FVREVIQW9C?=
 =?utf-8?B?TDJVempzMHE4MkJ3MnNsZmFzbTRraENHRHVaNE1wb3kxQWJzRldwR1ZqWGJk?=
 =?utf-8?B?RnB5WU9ZcEFjbGlQWEVIdWRpYmpmUTYzYnc2dlduM3hucGRNUXU0d0xCTFFp?=
 =?utf-8?B?WFpMK1RwK2F5STdRTzh4V3d2NVpzZ0hIMThDb255N3ZrVGYveEl4V0JoclZv?=
 =?utf-8?B?eXpFenBkd09sMit4Nm5WS1dESmg0eDdmcWdYd1FFZjkxdVNLOTNUZmNwbHBh?=
 =?utf-8?B?Nnp6RmpibDRhRGVuVnRlZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RlpHMjZSemJ0SHJIMk9sUVpOV2cyUVpZcjkyZ3B3RmVRQXJhaW84d2lzZFp4?=
 =?utf-8?B?dk1wWjVvbk16NkJmL0JCb3V4eUdhRGVpczh6bDRlZ1N3T1dGUE40TXdGR29G?=
 =?utf-8?B?ZWdYQjdQUTJNdWo0WlpJZU5ZYUUrdzlzenJQcmtnZm4xMjVnYXhmdTczY3hy?=
 =?utf-8?B?RnpsSmFUb001cVJQMVo3UjZYRllBUFpURldJZjlIdWhJWDJHaHRzSVZBeWRL?=
 =?utf-8?B?anAyVjhrcG5oNFYxTGNCODAvbGpqUGRsbS85M1p5WUJNSloxay9ScmpROFZI?=
 =?utf-8?B?MWhGeDJURkxIVFJsUWltWC9OaUpQamRHdGs5S0V4bGlLZG02ZUNjeGVQT0di?=
 =?utf-8?B?R25ZL1FSbmphUnNDY1VWNzh2MlR1RnJXTGdIMVVhYWwyamlLeUtXUkIxczR0?=
 =?utf-8?B?bUZJZjdRZmpncS8yU1VRRnJXdHIwNDNONldUaXpmRlV4SUlPOHNRYWN1TEdX?=
 =?utf-8?B?ekdmOGV4M09aOUFUN1lUT0ErL0UvTDlvSmxQL010aUJEeUNMWnQvZHNiY2Q1?=
 =?utf-8?B?ZUVZL2lYYnAzTWVSVEU3NzlXeHNQbEY2V2hKd2x2WFBUOStiby9wbzRnam1M?=
 =?utf-8?B?d3RuSDJ3RFRHRW0vQU9vQ2dKOUV6d0pkOWkxSFVtblJDaFd4MDU5RFpWM3Fp?=
 =?utf-8?B?Y3BMOHdYdlFhZGpHNjFvUTJJQzB6Q0dtdUY4OG5CVEtlODI4cm52MXZkY3Y1?=
 =?utf-8?B?eDg5TnNGTXZrVCtDNldsMitReW4veFhCb1A0OTFjT3JHVHNFVnd3TzZNbXFS?=
 =?utf-8?B?Mmw2ZldvbU45cFA0a05UUWdjMmIwVTNKSmp4S1BxMzVkb0hKSEIrVkdpUGlW?=
 =?utf-8?B?Z2hsZENEV1dOa2FiSXdJL0JpVWdzbWxLV1ZzMHUzcVVQeGpKUVhVRjkxaE5L?=
 =?utf-8?B?cXB5N1UrY1JwT2NwYmRya0ZEbGk5SjRWelJ5aGU4NlhWck5kZVlUUDhwbWRI?=
 =?utf-8?B?aVFnbU12UHltZksxT0hnZko3a3EzU0Mxa01iREJ0eVZVTS9mc2FlaHdPSGph?=
 =?utf-8?B?UHpXUWhkUmlwZU1BbytJL1gyaU03R0x1WWY4d2xmeXcvSmhKNVcxZENYYnY1?=
 =?utf-8?B?dHhaakdQM25pR04yMTR3Y0RGazVteC9PU1YzYlhaSk40Z2lkT1VxTjB2eHlN?=
 =?utf-8?B?RWFlL3BoalJtVTJXYWUvMkRZRjNBZzhLUUxLVUNWOURZbFdyYVhId1VCT1BM?=
 =?utf-8?B?WGtEUXYrd1diVytMTWZJOXZxdmh4cThPdHpnWkp0U3VrcXRjMVpjN1RyS0tM?=
 =?utf-8?B?SXc0VVBvR3YyTGZoVGVWemtnbjRldCtwbDA1NlhtTTYvY1MvY1hyVnJSOHVl?=
 =?utf-8?B?Q2NjMmpVcGNudi9MUTJQMzU4RjMvc090aTNmLytiKzJCRVdvNFg5NHh2RHdu?=
 =?utf-8?B?OHE2L1dNOVExL0pTT0E0NGNITFFQOFltWmgyYnhZWU5IMkhBME91V1R3aGFl?=
 =?utf-8?B?bU1pZXM2NTRNNFl3dEo0bjV0ZHFpVC9uSldoa2VzOHZ2WjZQeXJUcWt5Z0hR?=
 =?utf-8?B?bzMrOEVyUmtXbkh1QUdRbVhTY3p2d0dEY1lYQ1p4ZW1rT3plcnFhYitDMmk0?=
 =?utf-8?B?QlNoTHVqNFAzemRnWEh1MkE3S2dyaksrYWMxQlY5MU4rWEpVRW1USzhQUi9w?=
 =?utf-8?B?QWtaNHBXajU4bk5vdVR2VjZ0Q1ZrTXM0VEh6ck5ydEV5bExlRStjSUJYaTVk?=
 =?utf-8?B?dDFrT3loM05wbGZNQ1BBV1pxZHRLOEVnVDFJMzZjeXp0RmtJTU5lcE9GcHlZ?=
 =?utf-8?B?Skd6ZUZMYVJRR1pzUXpjMmVDNWZPcWJyTWFvYXRwT2s4am1RU3lBNitVNVFK?=
 =?utf-8?B?WndUcmhSNlhzTFBNQVMzT2JVeUg5b0JGUWJCb0dROW5TZmdveUM5RXZuaE4x?=
 =?utf-8?B?N0MzZlhRcVpRd3F3ZTBjSDVRMXdoMy9heXRTdFFaQU9CQkN3eExpRkNGODBl?=
 =?utf-8?B?U2NubnBqUW5XSkhVSW5IL2U4dC9uaTB1d09Sa0tkbVZtS0tvQi9wVVNRV0FP?=
 =?utf-8?B?S0pvc2txZTFBYk1XKzVWTVdFbWg3UVJvS0pOeTFYdmdxdGdvNXNCU2ZoTDRs?=
 =?utf-8?B?cTI2clpGNUFrcy9QQnFuS3hGbkxSQ0licW5sYjQ4Z003Vy9PRlNNS0grcis0?=
 =?utf-8?Q?prPA5NYkVvWBapSJdAtW2Ua1t?=
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
	56r+7BxBr3xVxyPn2Mrfpd4W3aaGVSU5D7LVEiY4J0CwQk4ewcfC1SSbPS70RYwaQ9Gw26Zama6AJTuaq9kZeNQw/um6T56BkViQ2mBUPShoQ6Cb2oiYMfIroP1xE9kptkNaDOpWflItsQ+iQKfyKP0L24CM6yCjFeZ2WYXNcDcsg9Xgmt0w7vU8NUw0FR69iw98TE7Xf1xGsGdtzzE54uRADcQLDH1I90r9q4aaUltnXCG3379U168bc6Ci8DgyBOVOjbwFYU8UapH/dAAiBgxlPTh92zXB7zGad9G7nNWKfi2owbflUj9YkCV5HMD7K9BpDOpoUkJD+R3g89GjZAzjRA2NVQOrZHR+VlFpl9tQV6/TDU/BIeAOGJjo/uJxb8cqcSxSmxMkLp431n6uNNC4NXTWxzdz1VbkQKLb6Xze+K94nE4GiVlhqohFrSdgh5gPWNQyQJIdOfgohnqcTmyCjVsqlQqg9VmHFW/rwvKVqi6gApF07oH5C2cMsWwwZLRGWlnLffZccFDBBqwNTczOHLUI2jlVn50IwylwDSC2/tYO8LtH4wZV1LE41T0ArUgceOoKJjzevz8uRbc6zPFvo9ZXY4yxUTBfa+cUxy4SMVXD5NRUJQSHmkOguNQD
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0fda33-dafe-4f6c-0d1e-08dc7455436b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2024 20:34:33.1885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OAXWuq1EA9Xx32dGbJ6/v45Pg3Ildq60n29xQhqFWXLHKo5btqQluY8U+fuVyszOo83RLrm+fjn1G+8DPuycng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB9224

PiBPbiA1LzEzLzI0IDIzOjA4LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArLyogYk1heE51bU9m
UlRUIGlzIGVxdWFsIHRvIHR3byBhZnRlciBkZXZpY2UgbWFudWZhY3R1cmluZyAqLw0KPiA+ICsj
ZGVmaW5lIERFRkFVTFRfTUFYX05VTV9SVFQgMg0KPiA+IFsgLi4uIF0NCj4gPiArICAgICAvKiBk
byBub3Qgb3ZlcnJpZGUgaWYgaXQgd2FzIGFscmVhZHkgd3JpdHRlbiAqLw0KPiA+ICsgICAgIGlm
IChkZXZfcnR0ICE9IERFRkFVTFRfTUFYX05VTV9SVFQpDQo+ID4gKyAgICAgICAgICAgICByZXR1
cm47DQo+IA0KPiBJIGhhdmVuJ3QgZm91bmQgYW55IHRleHQgaW4gdGhlIFVGU0hDSSA0LjAgc3Bl
Y2lmaWNhdGlvbiB0aGF0IHNheXMNCj4gdGhhdCB0aGUgZGVmYXVsdCB2YWx1ZSBmb3IgdGhlIG51
bWJlciBvZiBvdXRzdGFuZGluZyBSVFQgcmVxdWVzdHMNCj4gc2hvdWxkIGJlIDIuIERpZCBJIHBl
cmhhcHMgb3Zlcmxvb2sgc29tZXRoaW5nPyBJZiBJIGRpZG4ndCBvdmVybG9vaw0KPiBhbnl0aGlu
ZywgdGhlIGRyaXZlciBzaG91bGQgbm90IHRyeSB0byBjaGVjayB3aGV0aGVyIGRldl9ydHQgaXMg
YXQgaXRzDQo+IGRlZmF1bHQgdmFsdWUuDQpKRURFQyBTdGFuZGFyZCBOby4gMjIwRiBQYWdlIDE1
MCBMaW5lIDI4Mzcgc2F5czogImJNYXhOdW1PZlJUVCBpcyBlcXVhbCB0byB0d28gYWZ0ZXIgZGV2
aWNlIG1hbnVmYWN0dXJpbmcsIg0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4g
DQo+IEJhcnQuDQoNCg==
