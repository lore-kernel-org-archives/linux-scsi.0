Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2101DFD1;
	Tue, 21 Jan 2025 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737465892; cv=fail; b=dGbhutp4HnjomyXriazpBhxU7OsLpT1Vs7ysAZNKB0I+u0TQEzfiVtsTTPuP2oH6nv2Z8Vhvmyg41VMVNi/TUTNOeo28RXYF9iqES7HhCqNzZZm6wE+FBmnsFI0lJBKwrT6/bG3BhableAXKzks0tdW7/WnYSwuumDXB9QnVjM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737465892; c=relaxed/simple;
	bh=LjNFfzyG9wDB5feEgBK0qkvO+S7SdARMQSbYdmY8EYw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q5NhZBHWVP7iIcw3ijiwEqp87lxNyv/Kc0qxG+S84AcBOf3tRG5l+9POlxdT4moknB3EVdFoBsjTJuqRLrix5QJXi/BqPVHHBxdCZQcgzckNyoNoIeZsnm1LKauKUzKAnnWjCUdGSJCJ4/bfmLunyNBYaTTljQSKau0zXgd6J5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MGkPBBTv; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ByduINNo; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MGkPBBTv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ByduINNo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737465890; x=1769001890;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LjNFfzyG9wDB5feEgBK0qkvO+S7SdARMQSbYdmY8EYw=;
  b=MGkPBBTvqXmUxt1FVRW86TFNDQko2oWXojkTW2pfHTTSTwA9Y8ue/id6
   GnYelHSRlyl6XmOuxa89zttb91w7MLBRnJ+86zvOuQnqnRJM1ZiKxkP76
   I6QyxpehpLebdU/u1zIabEf5ZEeicyId3sRs3chOW6xJv9TXjzJftl/8P
   pdgB0Dba4jeQeP/VaehhNIpXNJKQdI1UdYd9heIKdKVS27FKAZY2EJBa5
   DbUxlSBfnamu3ahCYK0rpkxr62OAJXquSauuKwkC4wFeJxWm64zl1SNXV
   ExPruTO65jekHaQezQ/q42sSRF5E+bv/ymO7kMtzpLkNaC8hsUyFLwS5H
   Q==;
X-CSE-ConnectionGUID: x5ejH9fOT3y2eU96+6CQ2Q==
X-CSE-MsgGUID: J6CbP+KoQpCF2zL/fDiulA==
X-IronPort-AV: E=Sophos;i="6.13,222,1732550400"; 
   d="scan'208";a="35827410"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.10])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jan 2025 21:24:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ft8Q+dU7kbB/J8qkaIOUcz921Xi0YUZCifBaGuVpIAA8FFPGaGXJVOaWZkywBpB3qQk02vbLFMDCFC71Lv8WVUmWl/qgBazFjVXfP6ANOlEIlYaovc7VoNUUf4uUbeHxw7892ccVOy6fL1NZwEv+2cmQkCPBWzO7gz0lQShpNKMNvkUf57NkB0EDCD97guk5FZl2QeaziGnLwkwZLdPN5iy4GZXBoH1y4ah4lOBU1fYRC40KwB5WW1tVsTuKwNA8Q0aG9yVLofyfuWU6Rhwa8K6KB/RKaaC8IKMljp1Ikf8iJFMDI0HEq5W0AsvgdpW7NTmb30MvngWHaSSDrlxQJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjNFfzyG9wDB5feEgBK0qkvO+S7SdARMQSbYdmY8EYw=;
 b=ARnxLop6clBDFfVWedwqiI1pWMNwmsN6/J7ZUQ32uiA8SuZbcyM9S9k3+6CzjDcSzLF40/Q2WMFYtaUM68HsYlmVLEVdsXSeM72doF5+UwaVTFoMhQC+/44EXgn+I/ZfJqYgv2deRCLg/FFyktVo6dvKUjbPDSRP5hmG3CYqKt+7aSO5al4iAx8HjXrdfVSABop7cANCXo1KnVq+OR71y3RTI/HqCJhlbmWamigEAXSViHeckBSpZKWzyxEHIEB0Q1Grtq4eoYetpUeRB9j/EXLQ+Riwc61LfHZK8RRRhkfJoA4WR4PH8bKOfbVNVN/7iqAfkSz/Hsi6juSSPwyJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjNFfzyG9wDB5feEgBK0qkvO+S7SdARMQSbYdmY8EYw=;
 b=ByduINNoxyrkSRq4Em7lpSZ5LviiHxqxlZlGqv7SQyiyOBWkcO4udthQKct5goyD5pymj8KFFmj2Mep/cLjHAxcbMaMj0lSw5iiTxpbNhNVRAr5MfN+SkeKTWEOL1L59uPs8PIkRNFzkceWRUuUk+UpduLSQRseg7rWSSSGVnUY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 IA3PR04MB9301.namprd04.prod.outlook.com (2603:10b6:208:51b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.22; Tue, 21 Jan 2025 13:24:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 13:24:40 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	"dmitry.baryshkov@linaro.org" <dmitry.baryshkov@linaro.org>
Subject: RE: [PATCH v5 3/4] scsi: ufs: core: Introduce a new clock_gating lock
Thread-Topic: [PATCH v5 3/4] scsi: ufs: core: Introduce a new clock_gating
 lock
Thread-Index: AQHbPj/3YH/oF0yNhEO80TTPaVCZLrMhh06AgAABNwCAAAhJwA==
Date: Tue, 21 Jan 2025 13:24:40 +0000
Message-ID:
 <DM6PR04MB6575BCFE6A0715841F4C3F0BFCE62@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241124070808.194860-1-avri.altman@wdc.com>
 <20241124070808.194860-4-avri.altman@wdc.com>
 <20250121124217.ajerfz3p7iorc2oh@thinkpad>
 <20250121124638.ess5iqn6weyw6jzg@thinkpad>
In-Reply-To: <20250121124638.ess5iqn6weyw6jzg@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|IA3PR04MB9301:EE_
x-ms-office365-filtering-correlation-id: a31491ac-732d-4518-d230-08dd3a1ef60a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?V09TYlVKd0RVQ2VvRjk3UmZEdEc0VUtFdUNlNWIvZGtKRHdtSFlrR1RaT25T?=
 =?utf-8?B?NytmcUJza3dwVjBVYzV3SllQOUo0N3M0ZTZvOFFGSWlOTzhOcm1uOXRyNnp6?=
 =?utf-8?B?a3FwMy9hbkhHQkRBcTcyOSt4Y1JISWVJcjdlZk9EOGtJRm9PMXRlNlk3dXRY?=
 =?utf-8?B?N3haQ1AzNnJidE1yV3VwV293ZjBIaUQzUGp3S0lHenZlR0pxeDhGL3JWdkNK?=
 =?utf-8?B?NnE5cFVLN0IrV0M4aXZ4UVRWRForU1YyVzJCYm5Od01nV09nZTBOWXRtZjVI?=
 =?utf-8?B?UTUvbU81alRwZzNQTm5nUzNZWGtpS1BGZnJUS2RvZDMvdzhXeWdjckdaZDJQ?=
 =?utf-8?B?YWljcmtTRFRKODNDRkdMUXVWVHZNMHRUVHN5eDFTenI3eG1ZOEFONXIvOTN0?=
 =?utf-8?B?eldFbkxJU1NMZ0ZDdjdpQ0F5OVBNN0tXK3VOOWdyTHpwdjM0VklNbHExbkFG?=
 =?utf-8?B?S2tGVlYvaXR6UitLZCtKZjlYc1ZQa2xWcVlPL0pudGJTSFg1eko1OW01QWN5?=
 =?utf-8?B?dkE5dkFBNlhReCt3VXJYcWJUNnlJMGx6bDNwTGNXS1RrS0JQNlFDZVdQdGY3?=
 =?utf-8?B?b0dHMmZMbmVoSWRqVnNFdzA1MVcwcFBxcGV1ZnRoSEdpNnNXTnQvbjlYR25k?=
 =?utf-8?B?OVNna0M0bmlTZ3FkTS9HQ1ZUL01BMFVyeXlmUlNkeGFYcXpvaUJLaURvQUJH?=
 =?utf-8?B?SGV3M0UwSmJnTDFjbUNRN0NsN3FXMWp3blF0M2tQVVVoNkpoOEw3ZjFiZFRs?=
 =?utf-8?B?YlJWZmRzSS9GSks2a0kzWWp4TG1xQnJNa0FUVW1PT3Z1dkw1MFpadUdqSWRY?=
 =?utf-8?B?UWdDWW9Fa2YrOUMwUUdLLytkaVFNTXJLeXEzSzh3dW5hbjFqOWlxckVIYzFj?=
 =?utf-8?B?WElSYnFEREJQRFlFWFZXOEVwQ2dWMVp5ajlPdE1YcENUVVc0TllOU1A0bk5s?=
 =?utf-8?B?M1NqM0s3ZzlWUkJRQUxFanBFNlhpL2o4ZThXSEg3NDBPaUpmZ0lLZ0RiSzdG?=
 =?utf-8?B?aHZCRzlDdjBDaDBZQkxlWWVjZjlUOFZtd1FPOTlUWWh3cnFLRVdFWXpqL3dj?=
 =?utf-8?B?OFgvSnNRSnAvV1YrTk9xK1N2cmJIVnErSjhabitWQlp5cjc5SzU0VkZXbjMz?=
 =?utf-8?B?MUdKSUpTYkhwSktCMkd2eE4xUFU3bG1yaEIzQVN1RHVNYnArWmhLUU51VVJB?=
 =?utf-8?B?b1RWTzhleUQ2M3p1Tjc4bHBlUFZMUXcwTFFtN2RLays3Q3U3bHFRdDRCc0Ev?=
 =?utf-8?B?dklUaFhFbDBuYTBrVWhHY01YNU9DbmNpOCtNM29USGdiQzJzUnN4eFZNdFEr?=
 =?utf-8?B?ZFVBR3hxeEZGYjVTazJQeDM1ODZDTmxWb0p1b2w4Y2VsWkE0UmtZa0Jua2d2?=
 =?utf-8?B?OXBvNDZWd1ZXK3BtVm1lWCt1aDl6S2J4V3A3eXdnNy9jSmxjKzc2VEl3ZkQr?=
 =?utf-8?B?V3NyNlg3WWh3bXRIaEdGZzQwOWVGN2tYM1kvRjl1N3dUYkh5U3J0ZE9pOVpU?=
 =?utf-8?B?M1A3dDNvUEJ4aU1TSDhGenpzQXRFZnBUMHpiS052RnkrWTZmdHk0cHhOMURD?=
 =?utf-8?B?aHUwNXdrUTBNa0JiYlJzdW1WK0xjM1g1dDc1R0pPMTdrWDYzUG9uYy95ZkxO?=
 =?utf-8?B?SXUvZ2pYdFJiaW9BeHlSM1p5bE9oNEZ6NnY2amwwRW9ZSG40R3NmWGVRYlRl?=
 =?utf-8?B?aVVmSEhoQmRFOFp2SC9IVEJhUEVUVHJNY0lNRTZOL1BWUlNYbTJlN2lUT0x4?=
 =?utf-8?B?UjB6bGlLbCtEbHU5Y1JjOTNUbWY5UW0vbThiUkJGU3JuYzU1NExyQ1Y2b21p?=
 =?utf-8?B?cGNWbjhpaU10dm1lRWVzY2xvc2N0ajQ3MS9LRVA3UUhEU2FCTHBQNzhITjV6?=
 =?utf-8?B?SlgvWVZpdmwzdVBPNWY0ZGVia3NoTFBVUWQzcTg3THljbm1lV1RZVU5MRVZp?=
 =?utf-8?Q?mivAM2jvskuL0ZxHCqUmMjqt6A/r2jw5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RjkvZnVaUW5DRy9qdk5FSFdGZ2xRdTQ0YkxVbkRQQy9SZ1k1YXNFV3dUMktl?=
 =?utf-8?B?QU9CN3JPY3pBSmJFMnl6WEhXWmRVaEp6YS82cHNVTldFMjZRTGZuaHJlVWRS?=
 =?utf-8?B?bzBpWnE4MDc2Y2VrLzVTTEJzNCtkc05CaWxjRXVWblBGSVVsM3k2aUYxWXh1?=
 =?utf-8?B?ZjNGOGYyS0NncW1ldWZDaHdYeG53SE1LWHJ4V1NLSW1hVFFMbmdpWmhhZXR2?=
 =?utf-8?B?dmxwSGNQenAvdWUzZVJ4TkNxeXRXMEFpeENSbVlXaUZmNm93aFJDUEZHTHZi?=
 =?utf-8?B?M3QyUC9UWmZVajZjRy9wZ29qRFZxcGNrTjRuRWNsN0UvTGhmOVN3WVlDRmNy?=
 =?utf-8?B?WGtCbnVQZ0ZQeDd4MHZSWlAxcnNBbmk1NTJoT1h5Q1dQZFhmZTNueWdsZFFw?=
 =?utf-8?B?dUVUMGd6OUdrZ3JpT0NyVGZyaU5wZnowN1UxMlIvZUtqbmpySTE2dFdQek05?=
 =?utf-8?B?UU1YSmNJbTNxV3FuRFhCSlNoLzY4K2k2WnBpeE5IY2wzc2plNkN0RG9yTm1D?=
 =?utf-8?B?Q1RseVdEYWdlYUpzakdkSnA3SXo2WGJrUGtFSk9iK3hTbnlQVGJZWUMxMXBE?=
 =?utf-8?B?QnE4V1U4TmRLREo0Yy85K1RpcEJrTDNLOUJnQ1hKYXVUWGw4L211YXFPeXAr?=
 =?utf-8?B?b1daV2Nmbmg4eDhNNlVEeUVRYm84eDBxOFBNM0gzVEtSVEhPQytCU2RaakJK?=
 =?utf-8?B?ZDV3QTEvVFJuMGxybHhjUElMNDFmV3V2RHhaTWtmajlIbkJZY3Bmc0hjM21y?=
 =?utf-8?B?UUJzVEcwcE1pVTkwWHBiY0g1ZFVTZEozeDV2S3o4aWVseDRmS0NhTXhuOEhv?=
 =?utf-8?B?Vm1OVFJDZnRwMitXRWRLMmlMejlPS0tXaHFmRVVlL1pOaGxqanh1bkxaaEdl?=
 =?utf-8?B?OXhvYWRRRktmTUd5UTczQndrVTBleDdSWG5vQ1pva2hERFdUZHdRODhLY0kv?=
 =?utf-8?B?a3V4RnN6RFhKZ1daMnVFRUIraGxMNlZaWThzMnFLRzFKZkwvRkptbHlSUVAw?=
 =?utf-8?B?UW85NVNiSHF4emZvQkkrS0tLNjIzQ2dpZURxSWdKTVFwSGphSlBGVTNlaEtB?=
 =?utf-8?B?aWdSLzFXRkJyUDZjQUQ5cTY3V2U0ZHJ6VkpzMkN5QUFIY3dvL2N0MU9QeUVk?=
 =?utf-8?B?MlJiSGZJaHg4TzNURkFrRE9iKzNrQ3FmOHU2Z21XV240US9SZmdHcjk3cEZa?=
 =?utf-8?B?d3ZaUTJRWlg4YTAzSUpJSTdnOFVaN3NhdmM2MnNuN1BLUDZaU1hMenBSdlNp?=
 =?utf-8?B?Yko2WW5BUUNvbUNka2ZBZi95OU1FY0tOK0ZsMzkxa1J2cG9kRWozWVZVeDJS?=
 =?utf-8?B?TTNqZWpSRUhWcXNnZVVabE5BU1FjZ1JncDdXTkV0dFVobmIvWXVQMGFYRmlT?=
 =?utf-8?B?U0hBV3duS1ZPVjN5UFJReTh2UTk0ZEptdDNSRWZ3SkZzazQwMEpxMGhQVHhF?=
 =?utf-8?B?TUFPQ2s2UTNjQXIwOEJnTUNBeWZnc01GYS9JZGV6YkUxYWs3YkF0TjBOdFRQ?=
 =?utf-8?B?bENRcmhNYWNxMktoSUlHc09FMnhaQXRFRmlCanNOM2VidlpZa1NYQjdHWkFt?=
 =?utf-8?B?MW9WdG9idDhnNUxPMVlURThPZERqeTlDcXVOUmUvdjl4TEVuOTBqOEp5UzM5?=
 =?utf-8?B?NysxSVh3NlJoU2lNWUpqdnh5a3hvenUrRzlVMm9FcmcvMlRhSzNweFAvMGFV?=
 =?utf-8?B?UG1DU1BPaUtWeUZ3anl0b1hDL3VDdWlrVjVZaDdqLzFTNk9PSGdZL2w3T1FU?=
 =?utf-8?B?Z2VqTTFTOHlzRTFkQlp0c0dFbU5ML3dBaXd1V1dxcGF2dVZkNVgzSU9kTDYw?=
 =?utf-8?B?V3g4TlVScUVVVFpMaHhlYWF1aVdKUURqTUN6S3RwV2xkVUhEZ252YlpXYnY5?=
 =?utf-8?B?Z0xPdEpSYkNieURkVXFyWmdkMFMyUEZ1dzd1ZDRzbENDNkNYT1MzVlAza1lH?=
 =?utf-8?B?R3U2cGhqVUdGaE15bUIvTnNpMjMvSHBHcHNBelJZZGdlUEVWNWdkQjBpa1dX?=
 =?utf-8?B?TUsrMGhpY0o5Y0c0dG1EWUF3bzBIamM0MkdydjFwblhHZ2tkSVZLdUdRdnlt?=
 =?utf-8?B?SG9DaVkvM2dGWFE1NGt6NlAxQ0Rnc250QlhDbDQrdmFyRGxOTnVTazBHMmhQ?=
 =?utf-8?Q?wRbJf0YVKTWkHi3z5aa/bujxg?=
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
	8+fzsazamgByPqXImFIsO6FBh6Ex/Bs89YC0mC5xCbNJqDHB9FG8Y1pZBC+MdCbpybdHDG81Jbg6vw7VIIH0J/VskhrwUpZeAneqOxxU9h7gzst4WrsyRUvr2hXFT6IW5H0g8VghU+k5xOLEXLZXFKEZV2CdclfD+jWgwSe8HX6Wx6hKQ7gGLL0aDz9f3EteNc0lRe9yEgpoe0M6Zg7cbMp/1zaWRfemPnmEkOfTSjsFisY2Qeu8qrC0kAg7xGNqtYH6tlCygsWUh8h6IbSYzzH6/CzXGyUy0JM0qDVr7TycCN18BPE6Mz2LPvBdm3NVuGHDFQrhAs+FZPzXi8nlbKJaEp/3/QI0jpUu1nRK8J7omL8r6zdZT3kbS+1P7M2Pyz+7r3Vgay9wIB4ldp2Y4Y4321XDAMBPPZpcIUBJmA2hnRdJxUX3e1XFjqfypvcM8y85jCVSGg0FrqEmLSgvbFifZAeVKPLrKPBaKgS8Wy0qr16v7CBlMXmSNHspH+2S2JxsxgxIEwJi6fta7LXa9jll2yp+U2jMqEeiaX/f59idHQuQWjk21kuHtAAxkNUAHa+m/KgqPvMTm9y2c68rO0nj4FLlv2jDG0Pwc695GPJwjC3pwx2IeGLPDtCId68z
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a31491ac-732d-4518-d230-08dd3a1ef60a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2025 13:24:40.7177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gCuRJHhIiQOljnzCZRhkciGoR3Jb4RgrfyqG86amE5oxpXuq5nF/vIpRUYepKFhQ/QHQaVw98RgoouWcO7eiFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9301

PiA+ID4gQEAgLTkxNjIsNyArOTE1OSw2IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldHVwX2Nsb2Nr
cyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIG9uKQ0KPiA+ID4gICAgIGludCByZXQgPSAw
Ow0KPiA+ID4gICAgIHN0cnVjdCB1ZnNfY2xrX2luZm8gKmNsa2k7DQo+ID4gPiAgICAgc3RydWN0
IGxpc3RfaGVhZCAqaGVhZCA9ICZoYmEtPmNsa19saXN0X2hlYWQ7DQo+ID4gPiAtICAgdW5zaWdu
ZWQgbG9uZyBmbGFnczsNCj4gPiA+ICAgICBrdGltZV90IHN0YXJ0ID0ga3RpbWVfZ2V0KCk7DQo+
ID4gPiAgICAgYm9vbCBjbGtfc3RhdGVfY2hhbmdlZCA9IGZhbHNlOw0KPiA+ID4NCj4gPiA+IEBA
IC05MjEzLDExICs5MjA5LDEwIEBAIHN0YXRpYyBpbnQgdWZzaGNkX3NldHVwX2Nsb2NrcyhzdHJ1
Y3QgdWZzX2hiYQ0KPiAqaGJhLCBib29sIG9uKQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGNsa19kaXNhYmxlX3VucHJlcGFyZShjbGtpLT5jbGspOw0KPiA+ID4gICAgICAgICAg
ICAgfQ0KPiA+ID4gICAgIH0gZWxzZSBpZiAoIXJldCAmJiBvbikgew0KPiA+ID4gLSAgICAgICAg
ICAgc3Bpbl9sb2NrX2lycXNhdmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiA+
IC0gICAgICAgICAgIGhiYS0+Y2xrX2dhdGluZy5zdGF0ZSA9IENMS1NfT047DQo+ID4gPiArICAg
ICAgICAgICBzY29wZWRfZ3VhcmQoc3BpbmxvY2tfaXJxc2F2ZSwgJmhiYS0+Y2xrX2dhdGluZy5s
b2NrKQ0KPiA+DQo+ID4gVGhpcyB0cmlnZ2VycyB0aGUgZm9sbG93aW5nIGxvY2tkZXAgd2Fybmlu
ZyBvbiBRdWFsY29tbSBib2FyZHMgYXMNCj4gPiByZXBvcnRlZCBieSBEbWl0cnkgb2ZmbGluZToN
Cj4gPg0KPiA+IFsgICAgNC4zODg4MzhdIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3Rh
dGljIGtleS4NCj4gPiBbICAgIDQuMzk1NjczXSBUaGUgY29kZSBpcyBmaW5lIGJ1dCBuZWVkcyBs
b2NrZGVwIGFubm90YXRpb24sIG9yIG1heWJlDQo+ID4gWyAgICA0LjQwMjExOF0geW91IGRpZG4n
dCBpbml0aWFsaXplIHRoaXMgb2JqZWN0IGJlZm9yZSB1c2U/DQo+ID4gWyAgICA0LjQwNzY3M10g
dHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5lc3MgdmFsaWRhdG9yLg0KPiA+IFsgICAg
NC40MTMzMzRdIENQVTogNSBVSUQ6IDAgUElEOiA1OCBDb21tOiBrd29ya2VyL3UzMjoxIE5vdCB0
YWludGVkIDYuMTItDQo+IHJjMSAjMTg1DQo+ID4gWyAgICA0LjQxMzM0M10gSGFyZHdhcmUgbmFt
ZTogUXVhbGNvbW0gVGVjaG5vbG9naWVzLCBJbmMuIFJvYm90aWNzIFJCNQ0KPiAoRFQpDQo+ID4g
WyAgICA0LjQxMzM2Ml0gQ2FsbCB0cmFjZToNCj4gPiBbICAgIDQuNDEzMzY0XSAgc2hvd19zdGFj
aysweDE4LzB4MjQgKEMpDQo+ID4gWyAgICA0LjQxMzM3NF0gIGR1bXBfc3RhY2tfbHZsKzB4OTAv
MHhkMA0KPiA+IFsgICAgNC40MTMzODRdICBkdW1wX3N0YWNrKzB4MTgvMHgyNA0KPiA+IFsgICAg
NC40MTMzOTJdICByZWdpc3Rlcl9sb2NrX2NsYXNzKzB4NDk4LzB4NGE4DQo+ID4gWyAgICA0LjQx
MzQwMF0gIF9fbG9ja19hY3F1aXJlKzB4YjQvMHgxYjkwDQo+ID4gWyAgICA0LjQxMzQwNl0gIGxv
Y2tfYWNxdWlyZSsweDExNC8weDMxMA0KPiA+IFsgICAgNC40MTM0MTNdICBfcmF3X3NwaW5fbG9j
a19pcnFzYXZlKzB4NjAvMHg4OA0KPiA+IFsgICAgNC40MTM0MjNdICB1ZnNoY2Rfc2V0dXBfY2xv
Y2tzKzB4MmMwLzB4NDkwDQo+ID4gWyAgICA0LjQxMzQzM10gIHVmc2hjZF9pbml0KzB4MTk4LzB4
MTBlYw0KPiA+IFsgICAgNC40MTM0MzddICB1ZnNoY2RfcGx0ZnJtX2luaXQrMHg2MDAvMHg3YzAN
Cj4gPiBbICAgIDQuNDEzNDQ0XSAgdWZzX3Fjb21fcHJvYmUrMHgyMC8weDU4DQo+ID4gWyAgICA0
LjQxMzQ0OV0gIHBsYXRmb3JtX3Byb2JlKzB4NjgvMHhkOA0KPiA+IFsgICAgNC40MTM0NTldICBy
ZWFsbHlfcHJvYmUrMHhiYy8weDI2OA0KPiA+IFsgICAgNC40MTM0NjZdICBfX2RyaXZlcl9wcm9i
ZV9kZXZpY2UrMHg3OC8weDEyYw0KPiA+IFsgICAgNC40MTM0NzNdICBkcml2ZXJfcHJvYmVfZGV2
aWNlKzB4NDAvMHgxMWMNCj4gPiBbICAgIDQuNDEzNDgxXSAgX19kZXZpY2VfYXR0YWNoX2RyaXZl
cisweGI4LzB4ZjgNCj4gPiBbICAgIDQuNDEzNDg5XSAgYnVzX2Zvcl9lYWNoX2RydisweDg0LzB4
ZTQNCj4gPiBbICAgIDQuNDEzNDk1XSAgX19kZXZpY2VfYXR0YWNoKzB4ZmMvMHgxOGMNCj4gPiBb
ICAgIDQuNDEzNTAyXSAgZGV2aWNlX2luaXRpYWxfcHJvYmUrMHgxNC8weDIwDQo+ID4gWyAgICA0
LjQxMzUxMF0gIGJ1c19wcm9iZV9kZXZpY2UrMHhiMC8weGI0DQo+ID4gWyAgICA0LjQxMzUxN10g
IGRlZmVycmVkX3Byb2JlX3dvcmtfZnVuYysweDhjLzB4YzgNCj4gPiBbICAgIDQuNDEzNTI0XSAg
cHJvY2Vzc19zY2hlZHVsZWRfd29ya3MrMHgyNTAvMHg2NTgNCj4gPiBbICAgIDQuNDEzNTM0XSAg
d29ya2VyX3RocmVhZCsweDE1Yy8weDJjOA0KPiA+IFsgICAgNC40MTM1NDJdICBrdGhyZWFkKzB4
MTM0LzB4MjAwDQo+ID4gWyAgICA0LjQxMzU1MF0gIHJldF9mcm9tX2ZvcmsrMHgxMC8weDIwDQo+
ID4NCj4gPiBBcyBsb2NrZGVwIGZvdW5kLCBjbGtfZ2F0aW5nLmxvY2sgaXMgdW5pbml0aWFsaXpl
ZCB3aGVuDQo+ID4gdWZzaGNkX3NldHVwX2Nsb2NrcygpIGlzIGNhbGxlZCBmb3IgdGhlIGZpcnN0
IHRpbWUuIEkgbG9va2VkIGludG8NCj4gPiBmaXhpbmcgaXQgZm9yIGEgbW9tZW50LCBidXQgdGhl
IG92ZXJhbGwgbG9ja2luZyBmb3IgJ2Nsa19nYXRpbmcuc3RhdGUnDQo+ID4gbG9va3MgZnJhZ2ls
ZSBpLmUuLCB0aGVyZSBhcmUgaW5zdGFuY2VzIHdoZXJlIHRoZSBjb2RlIGlzIG5vdCBsb2NrZWQN
Cj4gPiBhdCBhbGwuIFNvIEknbSBqdXN0IHJlcG9ydGluZyB0byB5b3UgaGVyZSBob3BpbmcgdGhh
dCB5b3UnZCBoYXZlIHNvbWUgaWRlYQ0KPiB0byBmaXggaXQuDQpUaGFua3MgZm9yIHJlcG9ydGlu
ZyB0aGlzLg0KSG93IGFib3V0IGp1c3Q6DQorKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
DQpAQCAtOTE2Niw3ICs5MTY2LDcgQEAgc3RhdGljIGludCB1ZnNoY2Rfc2V0dXBfY2xvY2tzKHN0
cnVjdCB1ZnNfaGJhICpoYmEsIGJvb2wgb24pDQogICAgICAgICAgICAgICAgICAgICAgICBpZiAo
IUlTX0VSUl9PUl9OVUxMKGNsa2ktPmNsaykgJiYgY2xraS0+ZW5hYmxlZCkNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGNsa2ktPmNsayk7DQog
ICAgICAgICAgICAgICAgfQ0KLSAgICAgICB9IGVsc2UgaWYgKCFyZXQgJiYgb24pIHsNCisgICAg
ICAgfSBlbHNlIGlmICghcmV0ICYmIG9uICYmIGhiYS0+Y2xrX2dhdGluZy5pc19pbml0aWFsaXpl
ZCkgew0KICAgICAgICAgICAgICAgIHNjb3BlZF9ndWFyZChzcGlubG9ja19pcnFzYXZlLCAmaGJh
LT5jbGtfZ2F0aW5nLmxvY2spDQogICAgICAgICAgICAgICAgICAgICAgICBoYmEtPmNsa19nYXRp
bmcuc3RhdGUgPSBDTEtTX09OOw0KICAgICAgICAgICAgICAgIHRyYWNlX3Vmc2hjZF9jbGtfZ2F0
aW5nKGRldl9uYW1lKGhiYS0+ZGV2KSwNCg0KV2hhdCBkbyB5b3UgdGhpbms/DQoNClRoYW5rcywN
CkF2cmkNCg0KPiA+DQo+ID4gV2hpbGUgc3VibWl0dGluZyB0aGUgZml4LCBwbGVhc2UgYWRkIHRo
ZSBmb2xsb3dpbmcgcmVwb3J0ZWQgYnkgdGFnOg0KPiA+DQo+ID4gUmVwb3J0ZWQtYnk6IERtaXRy
eSBCYXJ5c2hrb3YgPGRtaXRyeS5iYXJ5c2hrb3ZAbGluYXJvLm9yZz4NCj4gPg0KPiA+IC0gTWFu
aQ0KPiA+DQo+ID4gLS0NCj4gPiDgrq7grqPgrr/grrXgrqPgr43grqPgrqngr40g4K6a4K6k4K6+
4K6a4K6/4K614K6u4K+NDQo+IA0KPiAtLQ0KPiDgrq7grqPgrr/grrXgrqPgr43grqPgrqngr40g
4K6a4K6k4K6+4K6a4K6/4K614K6u4K+NDQo=
