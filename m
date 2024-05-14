Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C8F1DFD1;
	Tue, 14 May 2024 21:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715720881; cv=fail; b=T5iShohlfNSeukwfszNmnVVyG0zEmvNxpw+tf6cR5a3jbmYm5AVZAABr5jUTl5bZjO9CHvAJ00KFVXCT3Mo2BipOd7dqd2wk7s3YA7koX6s5pc0YPX+f48JFzmEYZEP14i09jPVzFXCK1W9+AjQYTZCCLww93xRmfbbZzX1211M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715720881; c=relaxed/simple;
	bh=jzN7CaI0y/sza/ijQS6NS8+rWLmqhOIDNvyaFmQY6II=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tqp//whHM0lkfbZQaJ1PtIlhkLGbXG/8jKTt4NOWCVB5S7rU5ZSIGVmWUGWkulzfblsnP9gCbbqWjoUf4ZViCt9l3QMpUv0NWp7KtMjeRFEW9RKuYTNjgp7Fpa4K6XPhRA751z+2MkgPKq4PrClm4s6eOQh0M13dkH8ZNQxibkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XQuTAsaq; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Re29IlMp; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XQuTAsaq";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Re29IlMp"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715720879; x=1747256879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jzN7CaI0y/sza/ijQS6NS8+rWLmqhOIDNvyaFmQY6II=;
  b=XQuTAsaqPYVYMDsiLXmXpVWBXmfKXDq86RaB/a++ZgmClxZsDQ594hom
   HaUSMEqAhWYCtvzhz5yWIHRas08QmnRKo+Q9T3llHrv9l3hr5H7eeWDop
   taY4ObVTlz/0FIJb5zSnO/tDa0q+nlHyDpzRaPus8r4mISdeXfxJYiHl4
   tRTkqxV/RRWQoU+zD094GSBLxwHIBDH/bGNAvCpOaCFVfl65Abi8ms5YU
   I8Fb4Yy8UcU+sdgJY2rQhnhKQaDbUZivSd12Fwmw/sNfqX2LFzruGg96j
   AVs0Ens9tMpFrSWIYLZzv4oZ2OEtiAP7PDMAfichzBdWtnErX7z72uYYF
   g==;
X-CSE-ConnectionGUID: ZNrgzdm0SSygXJkijgqxIw==
X-CSE-MsgGUID: R/H/qDwDTFyqbj0J4xVR5A==
X-IronPort-AV: E=Sophos;i="6.08,159,1712592000"; 
   d="scan'208";a="16574684"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2024 05:07:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlhTqWX5k1mVJCAFr0Mla5yrVviE5HHEyrfwQ2RfvV86zUTaYrqrseLoH/SmUVlMvL2pVcy53JL2KfOJYjJ7jQ9T7enwE+i7YMat9SNRAdVtUpyJOcecZeIDztKUp+zOZhfCXeggJr2QG7ibqhHQAo2NSVdQUPlIqs5/3fQTaBsGm9pFrfuCtYV/0fiSVtvcSpwXBl8H0xcHUlgY7BX9VKw6qgOFr7dZmflFsMGMVDY/z9NM+9BcL6buZN9mHnM61Ph2Ug1PrBuuYC8HDBMYcAYaIv3ij0hgIjcUDSoWC8cUvMZZclXxxJ+aM3Zo56Iu/HCuFRXXTnnIfqh0j0+VcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzN7CaI0y/sza/ijQS6NS8+rWLmqhOIDNvyaFmQY6II=;
 b=JvoBpoutJh2H0elmAJBhM4zGvwOJqdLXlRJiE3YqeC1bcMbZor5Xdxs8IcYIoDTf8a5rs+7o6ol+moqWAgVBS6NZGs+9nyu9X6YpQa3nA7FbBW3NSxDy79dCey3jG0HkLCCg1mNc1ic+Vn8vUEqsDu5IHAVcI5f2W+wT5QO5Qy76GZWusliRewnkG2/8jjWxQETcTB/zigSoQrX9jHT9C9ipUn7dkLrD0ckzMXSczMu1MKHLhOMh5h/PQ2dcn3zpqB79bECL251ix9wklpsMNptDdlP0x/zLdF0uOtmN6rEIP0Q9KPEGnH62W5hlEHo+DTQV++Z2bkOK6kRop38CQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzN7CaI0y/sza/ijQS6NS8+rWLmqhOIDNvyaFmQY6II=;
 b=Re29IlMpW1ois9hj8hWERK/73fnfpv1Nf0h+0OY1qWC2PUNbkX7kTsWCoxwtgf6KvAMkBGVyv4uM029r8eSAWLI7pBafN/rsP1PdZ7Y/+pxs+HK6R3NWx07LVzMHvB1U3itHp/04LN5Tt4YVnWsTPzhXGvke9d07+fEnmSNWhTg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB7971.namprd04.prod.outlook.com (2603:10b6:610:f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.26; Tue, 14 May 2024 21:07:56 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::73a8:8d4e:8c05:62a5%5]) with mapi id 15.20.7587.025; Tue, 14 May 2024
 21:07:56 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Topic: [PATCH v3] scsi: ufs: Allow RTT negotiation
Thread-Index: AQHapbzIAmCD9ZFsDE2/LZDUaio3E7GWsCQAgACAZcCAAAW+AIAAAyWQ
Date: Tue, 14 May 2024 21:07:56 +0000
Message-ID:
 <DM6PR04MB65759D4064B9FBF13BBFCF72FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20240514050823.735-1-avri.altman@wdc.com>
 <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
 <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
 <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
In-Reply-To: <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB7971:EE_
x-ms-office365-filtering-correlation-id: 5c9cc791-2c5c-4cce-56fc-08dc7459ed76
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?TG1rT3YxNm51N1FhTGo0SUJpU2MzTGNndmN6N1V2T3RtQkZnQitoa0pYUTNv?=
 =?utf-8?B?NVdnNUtyaU1vSkJOUERmV2dBRUsyckZnQU9BWW41clUzaG92T1VLWWg1d1R4?=
 =?utf-8?B?MnJPN2d6Sy85aU9IZ0I4QVRZaG1wZEdNVThxcFVqUlZFYWVKVGdhQW1EZmc1?=
 =?utf-8?B?M2Q3cTQ4OVVRWXJXT2RqSUJvYkMvWVNpOEZ5cVhFVFpLa3FnSUVWbXR0RlNh?=
 =?utf-8?B?bWwwYWJZNElLa0kya05sU2FISUJmeThLdWRGSUNuMkRPWEg5V0hxdGlBZmdi?=
 =?utf-8?B?VlZMTUE4bW1zRHpVNU5WdnFXSTZIdzhYN2Zwa09zL05FcWZGenNHUTFJV0dO?=
 =?utf-8?B?Y0s5QzNMREhXREtvQTJkSFJpelg0bWcvUHFURDZZQUdLT2FhbmFEVEZrZy9r?=
 =?utf-8?B?NWR5THpvMHpMSWNZRzQrb1Y1MjNwcTVkdTBwKzA4TGxycThBS3dkcVJndW0w?=
 =?utf-8?B?eXJtZWdwQURmU0l1WU1ZckFUVTNXY2NiMGo2em5qTmVPSnJFTHF5NEpyNWFm?=
 =?utf-8?B?V1dWdkoxek1SeE43bEV0K0lNelN6RTBUbmRtS1hIWEJuRFAxYnAzMEQrbUxq?=
 =?utf-8?B?ZU9QSGlidDRSMmx3dGErZ0R2NTJWZTRPcXpzOEw2Wm8xVkNOWDFqOHB3eGMr?=
 =?utf-8?B?aTFoR0NHWTlQNDRIRFV3Z1dBYzRvMWFkVUg1TTZiK2UvK0xpdlREVnZ1VGgr?=
 =?utf-8?B?SENKNU50Z3JqbFFOTmNVR291RStQVEFGOURtcGk2NUswM3RhRkdWU1VPYk9y?=
 =?utf-8?B?NVk0NXZKeUhmcnJhMVZCQjBVWFVvT2QwZFFQbUtFUytCbHpJRE1sWXpta0dC?=
 =?utf-8?B?cWVRdXdIUU95Tlg3MTRTV0x3eHR5ZVQyL2FwREE2bExROTRjY2dnVGoxR1h2?=
 =?utf-8?B?MloyNjc0ZXNWRytzeUxsRXY1ditGaFVUYmNsTmgrOWlxemFEakJPM1l0cFJM?=
 =?utf-8?B?YXpPTkgrOFI4LzNTSEJtUnZaV00rNDFYT2FVOXIzeHl0UmhFak9lV3ZHcC9w?=
 =?utf-8?B?enJOQVFFN1ZzdHZqRGdVQkJqZ0V2MEF4ZGZVcnRlNk5aL080WFJnWGtYWS80?=
 =?utf-8?B?ZEQxa09EaElmbjFWcmhIU0ZMODhHdlVoTHpnNTY2T2xZaXhoRVJwd2lTM3Ex?=
 =?utf-8?B?WmtuNnAyOFNiWGJNdWdLeU9DcC95RE40Q21SNDhoUjVnNHNPNXFoVGtGQVBi?=
 =?utf-8?B?MSsyNDF2ZTBWWjlnYnJ4dnVxdzB1V1NtSzZ4c3JPNjd1aDBkUS9YTlYzdERl?=
 =?utf-8?B?MEJjRGVCdGJ5SGFnb0ljVFhqaVV6dlg3ZUFueDhrUDdBczFvNnkwTFBMMVd2?=
 =?utf-8?B?V3RCYmpkanhDbThmY1NrSnFzZ0lLQmNybG9WYnFaK3VHNi93a2ZGTkpLQ2JI?=
 =?utf-8?B?SW9mVjliRVRwZmJwd0M2Mm10OU5ESjhkYndMVWVwY09ZaDRSeWw4NURlSDRt?=
 =?utf-8?B?Y1B6dlFjVlQ2dGdSZitLdHlNcTk3RjFFZ2JPYVdMRFIwVG9YQjBKWFdlbk5E?=
 =?utf-8?B?Y2NDK3FWa3p3NTJrWmJwL1NjcHY5ekZhSGNzQ21xK1hqNmtJTDBCbGg0bWxm?=
 =?utf-8?B?NlIyZVVRc1ZlYkhWV3NJcGYxWSt6dU1qR25lUTRWR2UxWG1ucU1VVlBQWlM1?=
 =?utf-8?B?QWNOR2ZTMnMyL2M0RmhYL1RzWnh0alFpOTBEeU03aXNRNjJ2eDZETHVjUzdO?=
 =?utf-8?B?YURWd1ovNjVtMU41YlBUaG1ObTZVSXVNSXJJczVVUlcxWDJNZDVETXFTR0Fk?=
 =?utf-8?B?SHNScWxVSmtDamNrWlZMc25OUHZ5WnZIcWd2N0NlWTR5aEFRdHp1RWE2YTVV?=
 =?utf-8?B?WVJPWTZNY21zMnN5NVpYQT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QlFmZDdURXVab3hMMUJDMzZjTVRSUlNkYzVVcndQSUEzMFNYMHNVNnhSK3ZY?=
 =?utf-8?B?SzgrTkpHbVpVZjkrSGkrWHMrcVFVKzVlWGVwL1RKRWg2WWhNeXJlWlltNGtM?=
 =?utf-8?B?Tzc5M2YyU3QzQ1RxczdBMVd0L2xOanF1Ymg5TjNJaFYzNVZKbWVReVovVUpP?=
 =?utf-8?B?TDBaNmFiWXZUQlpyOHNtSUxTN2hhbEZhTWNnOHRpdHZ0cEsxc290OEVxeFJl?=
 =?utf-8?B?TkhXWEtZTkVpR1lvempEVm1sbjhCc3ZZZmdkek9wUDVQaXk2RFlDWGZocW1W?=
 =?utf-8?B?Zm9DRDNROEx0T2Z4dG5GWlEwWWFIby9FU2hVWmVSQVJkZ0MzZ0Ywc0tKcHVE?=
 =?utf-8?B?ZTlXSkl1eWIwd3JjNVdZSUVMMG9jRHpQNXNXbEo2QUlRaU9DRWkzdlk0UTdI?=
 =?utf-8?B?TW8xZ2ZveUZWR2o2OCtuT0o4M0pEU1liS3BMZEpHZDQrZ0paYWhzeHBDT0ZU?=
 =?utf-8?B?UTNFWkRHRWgyTlV6a0dHNE05RU5oR3VaSW1zYndTYlhZR25tSWRjQVY5YzJI?=
 =?utf-8?B?Wm1leE45TmllOGR4azgrWVF3cVlUNS9SL1YzMUZUSElCa3VDV0dsSjlHbTRK?=
 =?utf-8?B?WWVYdzdiUmNlNy9wZVo3WmM5dlBQTmVDbFpqUEZ4aVJla2w0TlZ2RUpqWkp4?=
 =?utf-8?B?TVFiSlc3dXZJYmwxRGZtVWcwN1ZOaGhLcWkxMjRFdHdnakgrRmRXcEkvcm1F?=
 =?utf-8?B?Q0xBWkNWQ3Z1SC9yaWhOQVdxU0JIYW1la3hQL1p4OFRBSkRxeUlLaTI4Ylhx?=
 =?utf-8?B?cUNqVDlEdnJBU3dDdm05d1NSQytxVWVZTElUa09RVXNxKzVBaUZyemgrUVlv?=
 =?utf-8?B?VU9NL1FUejBGb0t3ZktKeEx6bjFxREVRTStkNHpQRUV1Y3ZXQVMyYndMRDBh?=
 =?utf-8?B?SGpKQzFzUi93Nk1HNHdMZHdSdlBzZHRBdWpHNEcvY3RCWmtlRXJ1NXJxYjFC?=
 =?utf-8?B?SlFRaVNtNVFyZEFjdWYrcVROOWFIVndWbWgzUXhQam9WcjJsLytCRi9GMTE2?=
 =?utf-8?B?UndCWU52cnRMaXFzdVVRZnhkRU5GSXZIak0wVWFsaXN2R3RuV3E2bDVCMk1n?=
 =?utf-8?B?MFRnWU9SV3d0bzVMbWREN3VEOXM5WmdBaXlHU3ZNWkFQWDM0eVRFUklqTTlk?=
 =?utf-8?B?NmdscGpuTWNJSHBBZE40cVJ5dXhsL1dxWXJWbDVHdkFZanpRSXo5R0NMOXBX?=
 =?utf-8?B?SHlPZ0VWcUNRYnlkU2lmd1JNdlkvM2R3RnlZejFXd2ZZM25NeVR6MFVtV0JT?=
 =?utf-8?B?cjhJV1REaHpkWUFPNWQ1UDkxTkFMTXl1eG00QmpKUVZvRFZySVVJUklEMmU2?=
 =?utf-8?B?YlAyTG11WFczd0J6dmo5NWVDN2tRWkl6WnM0TVhBb0J2dmpveU1kelpDSXJG?=
 =?utf-8?B?K1RncHg5SCs0bDVHYTd2WUVGV0JFeFJkS3BUaFZKVGNQeU5XeUNYZGtHQzRu?=
 =?utf-8?B?c05vZXMwSjU3aWlRd1FiN2JPcmhWZUM3a1VTOEthTFp2dlBjazZPV3V1ZUZ2?=
 =?utf-8?B?cEZENHI5YnNYN0pKc2Ixc1pvSjNwWUtKU1BVVUpYQ2t0OXdCS1N3cys3bjY2?=
 =?utf-8?B?cTd3L2p0TlZpUGp2anY4aWZNVTR1eXZ5VWlXZEVMNnJBWENjSDRLdnhNSkN4?=
 =?utf-8?B?TWRpa3AyNEt3K1Z2Vk1RUkEvZDhNZGRUR3gva0l3UW1YVkIzeUZkUTRsL1Mx?=
 =?utf-8?B?TXpUMkNkc3NzVzZkQ0ZMcEFFMExIbmdTdVJNT0dGUmZpT1lCbEw2dWU3QWhB?=
 =?utf-8?B?Z1VYdmFmSGw2RVlRL1U1V202OTd1NzJMRHpaQkpYWEF5QVkwUFpVY0YwMHlk?=
 =?utf-8?B?aUlTaE1pLzNqYUFoNGpMVGg2cFppdVBBMzFlUXRuV2ptbDcvcEVIVlZVQ1hX?=
 =?utf-8?B?TmY1Nkl2RUFUUGVreUZ6bCt4amxJd2lYeWlEdENMWGIrSEtUMURXZnRhMVZC?=
 =?utf-8?B?VnJRUk5ncU5EV1ErRG1Eek4rZlZnS1ZVWjd6REdXV1pCaHlGQ0dxdVE4VC95?=
 =?utf-8?B?T3NiamlLb1J1TmYxNzd4NzVoNnlZMTQzUXVHaEhLbzdyQ3FkRGpnVUtKNklq?=
 =?utf-8?B?Z2ZYSlBOU3dYOEd5cmxUK1FLSEhLN1FST0h0UkJLTm4zU1FuV2t5eDlZdEN1?=
 =?utf-8?Q?VHdpwWx5bc4CuZaHQq1sqgm/7?=
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
	lpj/PRkkZGs1DDWsWHZDH5vx6HyjHWMUruUEEjoURreSyOKzRao9GnhOJ8H6oXf2C4KqTMwjhEqlpxJo05jPSlMbgu7br2Ezw1gb8unTuQLJsgMBRA5WtQF84Yt64Gn2YTSZtb51yqJ+0mutcdvdMEUhI8n01mgaT4GDmZjc7ga6rqNVBdlzfMCLmsUsagsVpedyD5bHBr/QdGgfTQFESu+erXXOu6nYEYcO65VB9RDQLVw3xXZGB3kzPhQlGpoQbCCfRqOlOydd+tbpqeI9IIyHP3oIIFqnrkikqrhguU/8mE/W8Bq+ZEXLh7kMaVvRZw7xP4SZqYBPJNNgJCZ6Q+68wVHUTuabhm53gdMinXiO7bZ33+Du9ljtopMRmsbs7szgOczMBp33tLJ87kYZhP4rL+NF+4SDPKu11mbWY5738VIbm4q0YkGuIJ4CPxpGn7dnkqf0buSFFZw5gmqPtagsPw+k0bD0EGggD5/cJGEDnx6bqK7f0Y65wvcZVSFZ3GL/WRcIQBXqV0TzTtRYl1+EeN3MY2DJiMG6Xd6KKasqNox0V9gpVUvubZq/RULQHGTK0R8EQnwG1lHe+m0miQmsNZ8anAzlh8XTiBWmGQfI4F808ban4JgpHjGfPLZQ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9cc791-2c5c-4cce-56fc-08dc7459ed76
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2024 21:07:56.4323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpSKdiDLk0RO9JnPNYh1CJqPrvrCj9VV8tPmdkJafHpm5+HcGO6EPUOK+YfYv06J9T+gfVGg6ITZTi7wKbR/SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB7971

PiBPbiA1LzE0LzI0IDE0OjM0LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPj4gT24gNS8xMy8yNCAy
MzowOCwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4+PiArLyogYk1heE51bU9mUlRUIGlzIGVxdWFs
IHRvIHR3byBhZnRlciBkZXZpY2UgbWFudWZhY3R1cmluZyAqLw0KPiA+Pj4gKyNkZWZpbmUgREVG
QVVMVF9NQVhfTlVNX1JUVCAyDQo+ID4+PiBbIC4uLiBdDQo+ID4+PiArICAgICAvKiBkbyBub3Qg
b3ZlcnJpZGUgaWYgaXQgd2FzIGFscmVhZHkgd3JpdHRlbiAqLw0KPiA+Pj4gKyAgICAgaWYgKGRl
dl9ydHQgIT0gREVGQVVMVF9NQVhfTlVNX1JUVCkNCj4gPj4+ICsgICAgICAgICAgICAgcmV0dXJu
Ow0KPiA+Pg0KPiA+PiBJIGhhdmVuJ3QgZm91bmQgYW55IHRleHQgaW4gdGhlIFVGU0hDSSA0LjAg
c3BlY2lmaWNhdGlvbiB0aGF0IHNheXMNCj4gPj4gdGhhdCB0aGUgZGVmYXVsdCB2YWx1ZSBmb3Ig
dGhlIG51bWJlciBvZiBvdXRzdGFuZGluZyBSVFQgcmVxdWVzdHMNCj4gPj4gc2hvdWxkIGJlIDIu
IERpZCBJIHBlcmhhcHMgb3Zlcmxvb2sgc29tZXRoaW5nPyBJZiBJIGRpZG4ndCBvdmVybG9vaw0K
PiA+PiBhbnl0aGluZywgdGhlIGRyaXZlciBzaG91bGQgbm90IHRyeSB0byBjaGVjayB3aGV0aGVy
IGRldl9ydHQgaXMgYXQgaXRzDQo+ID4+IGRlZmF1bHQgdmFsdWUuDQo+ID4gSkVERUMgU3RhbmRh
cmQgTm8uIDIyMEYgUGFnZSAxNTAgTGluZSAyODM3IHNheXM6ICJiTWF4TnVtT2ZSVFQgaXMgZXF1
YWwgdG8NCj4gdHdvIGFmdGVyIGRldmljZSBtYW51ZmFjdHVyaW5nLCINCj4gDQo+IFRoYW5rcyBB
dnJpIGZvciBoYXZpbmcgbG9va2VkIHRoaXMgdXAuDQo+IA0KPiBNeSB1bmRlcnN0YW5kaW5nIGlz
IHRoYXQgdGhlIGFib3ZlIGNoZWNrIHdvbid0IHdvcmsgYXMgaW50ZW5kZWQgaWYNCj4gdWZzaGNk
X3J0dF9zZXQoKSBkb2VzIG5vdCBtb2RpZnkgdGhlIFJUVCB2YWx1ZS4gV291bGRuJ3QgaXQgYmUg
YmV0dGVyDQo+IHRvIGFkZCBhIGJvb2xlYW4gaW4gc3RydWN0IHVmc19oYmEgdGhhdCBpbmRpY2F0
ZXMgd2hldGhlciBvciBub3QNCj4gdWZzaGNkX3J0dF9zZXQoKSBoYXMgYmVlbiBjYWxsZWQgYmVm
b3JlPw0KTXkgaW50ZW5zaW9uIHdhcyB0byBub3Qgb3ZlcnJpZGUgUlRUIHNob3VsZCBpdCB3YXMg
d3JpdHRlbiwgZS5nLiBmcm9tIHVzZXIgc3BhY2UuDQpBcyB0aGlzIGF0dHJpYnV0ZSBpcyBwZXJz
aXN0ZW50Lg0KU2VlIEJlYW4ncyBjb21tZW50IHRvIHYxLg0KDQpUaGFua3MsDQpBdnJpDQoNCj4g
DQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
