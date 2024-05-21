Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB3A1F951;
	Tue, 21 May 2024 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716291371; cv=fail; b=POWiu6owa6HoW6LN20uxe+slGXvjnsibdW04I0tEkkYKqYR55KgK7EXYmGPI9dfjGgpY/Y0Lij+mVIpoBT5gcqkeFVXvrGWYJhenxJL3stOkqwW2Tcai1JQkvzcPYElOtrdb6mxoRF14heii0Cp0fqG9BL5MUAH7xWOmAl8ZxQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716291371; c=relaxed/simple;
	bh=1Jz/of7RQQLIeeGwQqn4HUK9ZafAr9DuHjTpPfj55Tg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=elTzs7HXr3TAtHHRsemvIVo0lBhz+VoA2Wno9kMf+YWgYU5E2ZYb2I46O6IUi2cO5camMTt6fHr5KPx0NzqPbZGb44fFamfz72mj27LNZzMCuMjd8I8xQu2HnC+RUo4ZgkW2O/MsmjLO3JkeUl7RVu9muitOxtoadddq7JuKjYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HvG6H+6O; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=yX2+Bjx5; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HvG6H+6O";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yX2+Bjx5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716291368; x=1747827368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1Jz/of7RQQLIeeGwQqn4HUK9ZafAr9DuHjTpPfj55Tg=;
  b=HvG6H+6OOzZf6f5NjayI3GTC623t6Lpn1sn3XTOhcQHuaHItZpjwLhQf
   VmcDm+6bff8EkYc1q7j5q2QglaoNs9L2RWrP/aaYpvSB0+FbKu34FiGm0
   f73wuRY3f9zqmVWQSKWfS92ZtWuB2GR2wSCP0OaIdMjAAW8kTbXME1VIR
   i3noMiLWRj43MncqtUaWNdTpNuNlb6Ua7me4HMUs1T9C5pwkLLB7PwR35
   5of/7j7w9RGxU0Z/VvNUOeWOBHf11AXdB001UEBdUexQVbvvFNf3cbByb
   SoZOPeRqW+f8jQ0HsgJUcm0OMoNAGOPqPY061nUnxgap8x3d5i1TmWmCT
   g==;
X-CSE-ConnectionGUID: wiFxOeZYSGqLt1bHeegjCg==
X-CSE-MsgGUID: WT5qaediTvSX5CwU8USDew==
X-IronPort-AV: E=Sophos;i="6.08,177,1712592000"; 
   d="scan'208";a="16834402"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 21 May 2024 19:36:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exkbLXdoGzXsxfuJmfhHXhxTOxbGbe41RIcWWyDjf7W9ukwpUcGfS3CSuRbuV7Oh1z9iJKoUk85Xj4za2pZfpVYx8RA0HgXszmJngvrQiklfRs3/yz2NEMR8M/MhIkm4L73Fiu3D1XzGdmWNE6Z816jhBMscDyMBOFjGgb1XILY29VIzxBPgPG6wBimfolmYZBik05QofER4pvsnsmKfyxqRfdMV1f1Hn3/jjBPOjDwiT5XW1JbpMNeYM4qRulkYrpI2dK/l4OKtwJd246HgMlyD4XxRr4bn8g4NV2NiPMzhayNI5whzWKXNYQF3oyu3ZNCs2e8LmdhL5zDZPTz3wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Jz/of7RQQLIeeGwQqn4HUK9ZafAr9DuHjTpPfj55Tg=;
 b=aDAHcs4UkbqbZDwhP1rcy4QKCYSESYbge6AHvA9Rdp1Lhlre5wh3BBuiIY4WmTKdzRWQ0UFt5MzZuBa3O5wEWFADHia7ib+VX8Sq1aRTPLJWI7ks1FRjCW0pU/Pc/MekTDEQ6toTXbSrolSJ4LmC4KKn2ifmOc8OOV+TB8W4KWofWNH+H8fcG5ek6Xfq+CvfE76StextCshtGVoM9HPYuUduSN1TgWaQZv9S2ymeCpEFKqx0tcwe2qoAN7Jos4M11M+i1l/orhOw/tDc2MTdYBCf7rvkX5I7faMr5S6VeXY5bojKCVteGawGFVc3M5Q85duESMo/uH58Mk2JwpxKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Jz/of7RQQLIeeGwQqn4HUK9ZafAr9DuHjTpPfj55Tg=;
 b=yX2+Bjx5u+Wz9avMO7zVp3UI3o+KJUKTnBJveLpLuhh0chm48IIkN9q+vwugxXHS7EW30lZy10MxJYS+RKC2yz1mVb2uU4MZNpYY6x7bi2iKxscqIKjFrXX3ROTPIiND8KMTrbr8ZvmXXBCrBsPLCM83puK5nE8XEwEmg6bMmzA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA0PR04MB7180.namprd04.prod.outlook.com (2603:10b6:806:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 11:35:59 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%7]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 11:35:59 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Deming Wang <wangdeming@inspur.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "martin.petersen@orcal.com" <martin.petersen@orcal.com>
CC: "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: mpt3sas: Use a unified annotation style
Thread-Topic: [PATCH] scsi: mpt3sas: Use a unified annotation style
Thread-Index: AQHaqqW+BHpM0VQ0N0CHlMazT5QGwrGhkM0A
Date: Tue, 21 May 2024 11:35:59 +0000
Message-ID: <0a61b25e-02e7-4b8d-ab75-17e6f6a6d81a@wdc.com>
References: <20240520110546.1652-1-wangdeming@inspur.com>
In-Reply-To: <20240520110546.1652-1-wangdeming@inspur.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA0PR04MB7180:EE_
x-ms-office365-filtering-correlation-id: 617a62d1-0aff-4e2e-3d90-08dc798a2fa6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?NmtQMWJrZWp5WkI4QWpYeUVYY013OWFnbnBzTnhaUlVFZEFwODBjYXV4akNq?=
 =?utf-8?B?RDk0MHh4U3BxQXpPT3lKUXBnS2p3L3dTbUNiMXdCQkF4MjVQcXkwNkc5Y1Fx?=
 =?utf-8?B?cnEwQ1VoeFdjSWRRUlBMemxFSXczL0RZampnOGs1M3FXeFJFbkVnektwTEhZ?=
 =?utf-8?B?a0xheTVsSCtrZFYzdzZrSmZuL3cxT2VGeEs1T3JLV2krSk02cUM2dklZWU5H?=
 =?utf-8?B?MHNVK0RQZzdjQ3RiV3lIY1lsZytPRlo1TDlKODlxYXNYSk4zZTgzV2hsRmVM?=
 =?utf-8?B?TUdWVk1rMnJGblhlTlZ6ZGxRMGtubWVDNEtoUDVnYTYzN29JcWFFR1dsY1or?=
 =?utf-8?B?d2ZheTh2N3JKV2ZtUkJDbUxlWE12WEowakM4SWcwMTcrZm9IQ2U3RW1GYUxD?=
 =?utf-8?B?dUQvT05tdlFEWXJQWGc4a0IwaUduM3psMEtIK2NoeVpLUXB2S0JXS3BrNnhS?=
 =?utf-8?B?MG1ibTljR2J6UDljYW1QR3VYaTN1L0pEQ1JqeW1oV0dUWWRVcjVIL3NiYkNv?=
 =?utf-8?B?VlBQcWpXL2RieGNlTC9rczI1YVFaQ1dpWFlJeUJFamFOZ1pTblA4VFlXajU1?=
 =?utf-8?B?QkhvYkQ3T3loQ05FZVd0eHNVekp0YktLb1dhamY5b0dwMkcyVmJyNVMzUmJE?=
 =?utf-8?B?TGh1bTd6YW5XZkNrdG81cDlJZGNJSlBzWWs3S3ZIajh3R3Q5ZnVoRm9HTXlk?=
 =?utf-8?B?SjBpVGtiZkJEZ0kwa1FTNjVHOVBSY2dvSXI2Vy9WanN0SldiSFIyZi9TbXR6?=
 =?utf-8?B?NkplZThZbG5lajB2cDBZUUpUN3kvQTU2bkk0b3lUSkpPOFRuaG5tVEpYTXZI?=
 =?utf-8?B?UU9hZE52dXl4TnhVREgvRUlhQVdjK2RucS9ZMWxYVE5zc1JJbWVyVzNISzlI?=
 =?utf-8?B?TUFONXAySWh4cDFMTWp4a240VU9Sdk1EN2Z4VUhCM1BCcENjZG1Gdy9IV0xk?=
 =?utf-8?B?SzduTm80Sk9IQkcrQjMyWWpwazllbTUzMzhBYzVuR3h5TnRNK3FiUzJkMTQw?=
 =?utf-8?B?R1VBRWtFcko2anJKR2dyelpGSUk2VngyNlkrQmVWaGNORGg2eEIxeWJNR0F5?=
 =?utf-8?B?QThaTXdrTDNXMjB0Z2w0NjU4WjZ1clZFQkRiNmZxaUJqaVA1VVlrODcxU1J6?=
 =?utf-8?B?SlVqWHdISXNoUm01T3ZiUi9sZUJ5WmI3Y1FWWmVCWENxOE5SSGNDT09SS0xK?=
 =?utf-8?B?YWp6ZEN6endYOUVucHd5aFZsS01QUWx6VFRnZE0rVGtKVWE5dGd4b3VDWjg0?=
 =?utf-8?B?WEU0MEtIZTVlRXFLaFNmMlZEdG10eGc0b0xhT0xrTFpkZkl0bUZPNzl6MGhk?=
 =?utf-8?B?bXZYanRWQUhJL3pHNkFDTlpSYWRVOGZXQ3cyVkdaZXlBNzIvZjdXOWpZL0J0?=
 =?utf-8?B?SW5pRmRSNEdiRjI5bXhQcTcvQkd3R3ppWDVocHNuTC9BQmJ4Qm1aM3E3Qk5F?=
 =?utf-8?B?ZjNraC9jQ0NiU1ZvdCs1eWNLL3BxbmcvMEo4eUJxanNuT0QvOUdsRjZadmls?=
 =?utf-8?B?c1pRTDJmaWM1UTRWdTBzT01tbDdsZ2VacTFtNXQ1c2lJd2RwMXBVbVRzeXpB?=
 =?utf-8?B?WGVkRHFHNC9lREtzUW9CQ0k0elFJd0JVdkFMQnJVaVRxb2dQeTcvTjJ5TWJN?=
 =?utf-8?B?SjAvVWdmbTdXM2J3ajNtS2lydWRXdEhBWnFNNkhQUWRjQnRJL1ZEVFpBZFVn?=
 =?utf-8?B?aDVabHdROU9iUHhSdWZQL0l3Vmo0dllTMjBUWlhxWHV3T0hqV1JWeDl5Qjcy?=
 =?utf-8?B?YWpKUld6Tmd6em5yWUZWbS94aVNiRXYyQnptYWhHYkNVYVFsQ1AzcWM5Qm9q?=
 =?utf-8?B?NFk3eEFLczlkWGo2aFVHZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TW1wc3B6cjBxR3hEZEI4ekRTRE5maUxTcXpLNlJkTFhVNElZUU8wcEVTWTdD?=
 =?utf-8?B?MUkvRGJPZFVnanAreHVHc2ozaUFGQUY4RSs4Z0RpMG5rZ1hDUXNKQldsUUk5?=
 =?utf-8?B?Q2dYay9PYnJTMU91Y1dCSDNwdDQ4ck4vYU1pcGhIYitmOVdCNkZHQW9VaUxx?=
 =?utf-8?B?NnJHakYxWWViUVJ3NllpejVaMDdpOTRsQWFBdmNXOTlFZDJyLzNlVFg4U1lm?=
 =?utf-8?B?TTY4MDFDRnF5RGMxbmF2OGNROFdRTGs1Qi83TlJVZEdxM01QVzM5ckRBUlpp?=
 =?utf-8?B?a3p6dFdMTVZ6NzhDY3ZWZUNlQTdxS2dSR282bjhKaEZaZEhaZmY5TUNWSHdW?=
 =?utf-8?B?c1dMVWE1MHNCYlg3MThWeExqU0c2WCt6ODJQNjBVS2FrditmUnFTSnZEV1RD?=
 =?utf-8?B?c2ltcEEvd2lSZzV4VTB2L2FpWjlLanY3OEllMnVoenBMdVhDOEFNazdQdE5J?=
 =?utf-8?B?bTlPUFlSdHhsWHdHdzdBNnhsNEFTRkJ5MjRQakl6RVY2bWcrUXRvam9DSzZl?=
 =?utf-8?B?d203SUU0VDZNZFEwSzRkd09DMEZwamlReitXYTlubVhrcEhSS2tkOUN4dXZy?=
 =?utf-8?B?ZXpteEpPazVWQzVWcjh0UUpndW50TCs0NXVJazVpZlJUVWFTMSs1UWtBSnJo?=
 =?utf-8?B?bFlUdWF1cyt3b0dGM0FPWnNHMkcxVHJiTWhLbFNpbnkxUVdNNWJndG16VzFR?=
 =?utf-8?B?Wk5uYllYb3VhenNOVTN5aXFsdmFtQkREMC9Ic2xVbjQ0eVppSTZpYVhiWGNv?=
 =?utf-8?B?UW82TFBEOFZiWTk5dXdSYnBaTXcxbEVYZXJSNVQ0Rm9tQTFOaVVqM2pieFVS?=
 =?utf-8?B?UXZ0aUVBWStucHkzbGc4MjhaWSsxYmMvR05CZldqZGJUaTZNZnNlY2hIZFVV?=
 =?utf-8?B?aThkTGc0UW44a3RKSVVucEJWeVQ5Nk5rcGJyeG5HNUxWZEJmVExDZDRsZ3FO?=
 =?utf-8?B?SnJIVDdxaCtESFZvQ2lsKyt5M0dpTVVEM1U5TUo4Z3FPemwwT1REbmt3cUVO?=
 =?utf-8?B?Y3RJNWY5Nmx5UDRVd1h5KzhFc2NhclBHMllBclJDUFRKMGIwRFhHR3RSbG1E?=
 =?utf-8?B?RWJCVHY0MmxzeGdNY1lWeDdVbDE1MWVBQ3NWRStRSWhJOWVUL1Mwb3pBRHAw?=
 =?utf-8?B?Qk5QL3ExbnBpYmhaY1NXMHFFL2ZOdkhhM3lHK3EwVXJLTSt0UDZka0dOUDdy?=
 =?utf-8?B?UXlPRWNyNU5JVDZWTHpFZEJVRGZXMTRWL0NESyttVnBTYndXQ0lKbWdFNVU5?=
 =?utf-8?B?ZWtpVDBUcXBnbndIVDU3eFRETDlFV0Q5b1RCN0NCYjFma2ZCQ2tzUC90cWJQ?=
 =?utf-8?B?NUxQVi80NkdEcU9tZlpDdW9ZeEc2eWVNRkpIQ3ZzZlZXOEtKeDdKa2JrMDdz?=
 =?utf-8?B?WldMVEpaUjkyZ3orbk9KRHhlVjFIWmdFZWpwekQwRks5UUErYis0VThwY1hH?=
 =?utf-8?B?U25OeWxab1pGNGdTK05UVklIdVdaV0xEc3NYZXRyaWpwOTNqT0pMZHdOR2No?=
 =?utf-8?B?amYyQkl3L3FhMmJxblNaMjkyZVBzMTB6YkxNUVBGN3ZsVzIzb256NDVNTmlh?=
 =?utf-8?B?S0ZPNExDM3dBM1E4K244YThsY2UzeVl3MmVRUm9RcnJXNW5oQ09mVmRKUERO?=
 =?utf-8?B?UlZ6UDh4QUZnak50bW1sdlNqMkRXN0x4MkNMdkJOR3FsUmNMZFJxeHpSaktl?=
 =?utf-8?B?bTNQMFhQYU1ZaHM3ZGFUdHFaS1NGVHNlaFdtd014Q3NzYkEvOTR4cW9yRWZz?=
 =?utf-8?B?TlZFWE1IRForQy9yd3FYb09PbFFJM3pxckFLNXZObzJFbHVadVlESEF6OS9S?=
 =?utf-8?B?OURLKzJlUzY0MkZwOE1iLzh1bTNzVktsa3FuQ3lGZUx5czVURFJKRmQ5bktF?=
 =?utf-8?B?eFBqWU9lTjBEZ1hRc1pYSEsvNXdYd1FiTW5iRU1MclQzdDlSNEEvTUlFVWV5?=
 =?utf-8?B?M2tuK0dMZHZWSHBVbEhhaDJMQTl0NHVabHlEbWlML2lzcGlqV1ptTTRUbEJR?=
 =?utf-8?B?TFZYMnFYcUh0c0JKYmhWYW1Fd0huU2toR2crdWZCQUFtc1M4T3pxaklFSmN2?=
 =?utf-8?B?S0JwTnJpUUt2bFhZb0FkU0hCSmU3Mm4xOENBZlFLTUlIUWhuamZFN1BQMkVJ?=
 =?utf-8?B?SENyekdWQ2VSMUsrQ24yQ1IyeXlFRXlITkRIT1hpZHlCZGpQOXhmKzBPOW5n?=
 =?utf-8?B?Qmw2Z2paOEVmOEVWcnFXYnN3MFQ3UlVMZkhmWnFsbm5DWjV3N0FxTEl1TVps?=
 =?utf-8?B?b0NFdXFYWStNWjhjekR0UUJ2VmlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E16ADF0AFF35384190DC1F8D10D7EE48@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GhdD00h1HhhKKzwfBjnQ5kLp9kQhVVwahcTBPRjyTIiBglJOOh4R0TV7W3f49NTdLLF0eKiCIp2uVG3e7Wu2qeWJoNUyZag3l5nEfcNAQySIiStuogx39kB8nvGU08+HUQhMq+C+liUF6/8ZyTGGEZefchQgJoe7CLHsAk6X6SU2lY3fi9zjbcFgcd6uly1rbWSCz3+PXv4QL6g/sTh7PRZbvX3VYCxhr1O6yRwWeBCZ1+yEOXduZx7SGYxq1zCXpi6l6ghGZqN6rzrJcOnKP6+8x0J1w6RYx+cl6lJk9mJoL78ObewNlASZtMf6jHb0dXAgbn0CFBZ65rZQfSNz8zBzO2zujrl/CaruflhZF7qhW7VZktpfgCAaeOyNSs8F1Xg+6vLHLqF76suJBhg50MjCZXLXO1rIv866w5WsA6SgDchiYFXK8LrtmfLB2wAnMAJckiywkGOwlJHqRjHr++XsEr9Qr9791A37B0trvjw00aZdV5VoUOVlEN9YmGyvuvhf2LnyP4hItlUdWlZcNq9TMIj/fui9fU23EHHc3LA9A00j9dUwCRpPwJggJR/dCIU3yBVm4BjJVid9gsgL8NCwn+VRe/SN97yVMGj1Dh2kXJPgnM3XObNYCfATI4od
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 617a62d1-0aff-4e2e-3d90-08dc798a2fa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2024 11:35:59.1397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QW2ME3ljGql0/bQ2Y7eVrb61GUXjxZeOCZO2zfmYP/1yeCUihVVj/mDh8h516gfii96T1H86QG2wYWCQKN2GiItBaDNL7Ob0A2OGmjit2uw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7180

T24gMjAuMDUuMjQgMTM6MDYsIERlbWluZyBXYW5nIHdyb3RlOg0KPiBVc2UgYSB1bmlmaWVkIGFu
bm90YXRpb24gc3R5bGUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEZW1pbmcgV2FuZyA8d2FuZ2Rl
bWluZ0BpbnNwdXIuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL3Njc2kvbXB0M3Nhcy9tcHQzc2Fz
X3Njc2loLmMgfCA0ICsrLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21w
dDNzYXNfc2NzaWguYyBiL2RyaXZlcnMvc2NzaS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYw0KPiBp
bmRleCAxMmQwOGQ4YmE1MzguLjk3MDYyYjQ0MGU5ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9z
Y3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9tcHQzc2Fz
L21wdDNzYXNfc2NzaWguYw0KPiBAQCAtMjY4MSw4ICsyNjgxLDggQEAgc2NzaWhfZGV2aWNlX2Nv
bmZpZ3VyZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsIHN0cnVjdCBxdWV1ZV9saW1pdHMgKmxp
bSkNCj4gICAJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmlvYy0+cGNpZV9kZXZpY2VfbG9jaywg
ZmxhZ3MpOw0KPiAgIAkJbXB0M3Nhc19zY3NpaF9jaGFuZ2VfcXVldWVfZGVwdGgoc2RldiwgcWRl
cHRoKTsNCj4gICAJCS8qIEVuYWJsZSBRVUVVRV9GTEFHX05PTUVSR0VTIGZsYWcsIHNvIHRoYXQg
SU9zIHdvbid0IGJlDQo+IC0JCSAqKiBtZXJnZWQgYW5kIGNhbiBlbGltaW5hdGUgaG9sZXMgY3Jl
YXRlZCBkdXJpbmcgbWVyZ2luZw0KPiAtCQkgKiogb3BlcmF0aW9uLg0KPiArCQkgKiBtZXJnZWQg
YW5kIGNhbiBlbGltaW5hdGUgaG9sZXMgY3JlYXRlZCBkdXJpbmcgbWVyZ2luZw0KPiArCQkgKiBv
cGVyYXRpb24uDQo+ICAgCQkgKiovDQo+ICAgCQlibGtfcXVldWVfZmxhZ19zZXQoUVVFVUVfRkxB
R19OT01FUkdFUywNCj4gICAJCQkJc2Rldi0+cmVxdWVzdF9xdWV1ZSk7DQoNClRoaXMgc3RpbGwg
aXNuJ3QgdGhlIHJlY29tbWVuZGVkIGtlcm5lbCBjb21tZW50IHN0eWxlLg0KDQovKg0KICAqIEVu
YWJsZSBRVUVVRV9GTEFHX05PTUVSR0VTIGZsYWcsIHNvIHRoYXQgSU9zIHdvbid0IGJlDQogICog
bWVyZ2VkIGFuZCBjYW4gZWxpbWluYXRlIGhvbGVzIGNyZWF0ZWQgZHVyaW5nIG1lcmdpbmcNCiAg
KiBvcGVyYXRpb24uDQogICovDQo=
