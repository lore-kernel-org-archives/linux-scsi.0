Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E581465BE;
	Thu, 28 Nov 2024 07:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732778037; cv=fail; b=U3xnIY1MD0w3yw1QwOI5WGgTH0qZypiHKX4lx6L9r3Y4MMBfzBNXwOHIA0MtwhHdU0zKAgD8YjdGz7EHdh/EbzTgZLgUL3uRjLQJiGEwXEbhEwsLvc8SUE5iwhPC8C2LD7qOD9jC1id9zj5E3zHM7+u1kSn0ojdeW2SX0xED9M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732778037; c=relaxed/simple;
	bh=NTn1nUltvBM1py1m/jG3sn7FKy2jcfme1X20xmHzfyU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oChFCpPzmdDVgM4+C+Ip885r1N3OAFmJJxBfV5elEg0b4WmvUaNUb0lGU+5b9BVWtAsXzJyqGidu3UjlrbmyFa9FSpmLWZHrKn1xjxUEeGAYhk63IbHlng57QpJg+cxOpPEd5kqHH4TSi8DGPM+3VFSlq+a+qHxTxqBWL006omQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NVUB1MgU; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mItNZuy2; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NVUB1MgU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mItNZuy2"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732778035; x=1764314035;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NTn1nUltvBM1py1m/jG3sn7FKy2jcfme1X20xmHzfyU=;
  b=NVUB1MgUeCQ+MOrvBxRsAT+ldxs4hphC8Kkl6vjBIXDDbBzLivBKywpm
   EPAMGxhzJS/yfcQunGk8bAw8XpcUPfYRJzHDYwdERGoAuhOrOxPPQ6M7R
   dTzChuizK09jI8TGsE6DpJ/1bhMrgQ+fdbiW/AHFNf9CUXakopTDtFAVx
   erPYYhhdQWA0YdOQy6vy5C8kjgyfgA8zppXU4BRRGRUdIMDnwPBKboOr2
   NsbKEG3iVM3Pk4d1m6lnennj/99XGxBcv7MutYBF5Xcq7p5fGeJYq2opV
   GYJQHIB4lDo/haRVPIxQlrwkg+LsVie6bpYDUzM1KdchjuT1t3XEHohaQ
   w==;
X-CSE-ConnectionGUID: 1MzHw4gVS8OlIY0jBK1gTA==
X-CSE-MsgGUID: X1iytdqLTRGjvNmqvNARrg==
X-IronPort-AV: E=Sophos;i="6.12,191,1728921600"; 
   d="scan'208";a="33614084"
Received: from mail-centralusazlp17011028.outbound.protection.outlook.com (HELO DM5PR21CU001.outbound.protection.outlook.com) ([40.93.13.28])
  by ob1.hgst.iphmx.com with ESMTP; 28 Nov 2024 15:13:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMt0qtEsxG73J7kr7c3FgPnAMZ50iJiXWhZfJd+4mH1DMErjRlGu8+neAhl9XVtVI+XNX5o4tifK4y6ggwIHBDBeQ8GzTzB2iWCZY894EfWQzbTX16hOBRDXfpLqVxM6z/k1luiXJTs/wWIkCj6J2QztdOJuJ1UvFcrDj+HzLGW0E3Ri5klTwKtDjJ+iyiuLwg3gwe84dlP56/VOPZrKBLwgzsDYdfS1nMGfnNCFd8gye8reSCqAqJajOcwwHzQ6XPIZuqLhNQRCcBvVz+3t25635FdDRQ9TWSwjjFG4NEmHUeQRxMbj52NuBO527X2TGK01gY7lE07eiywrvzwyAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTn1nUltvBM1py1m/jG3sn7FKy2jcfme1X20xmHzfyU=;
 b=EgHmHf+ag1zxTd5tdx+Nxyf06WkujIBL0itdd8ru9+GD5Unher9MMFLz/g1YB+2KB+2QyK0mBzcbOA932I0p49R8QolVyLfTQwb+CLneL+IHf8E7S2dOciS3mZ5N+naXa+J4PTEP4kdyacdC596uLJufHy5Z/1RKZcUZ5c5j9rhnF6pyDouALrXCdLLW+IWvTmgaBaCW23oMgRycU8zFhstRpa7io4wQWSwgTnI7pYXpTQjHYFE2zzC8PSjJYpVWcCi4QviIghUc5UgdzwfOqjnEmNv8kyji8ibNY9NGKQqXeP5dpgWV9lzGrmgc/T5e27S2vYA+wbqlTjls7dqDAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTn1nUltvBM1py1m/jG3sn7FKy2jcfme1X20xmHzfyU=;
 b=mItNZuy2Y3uqos+soEbtC7aG0Z2Rk7hTHxa/+0s3mO4h0FH170GqibDMPppTGb7klkYFmBZTWoiHAUrut+I0Y4UIhtCNAj7ee6oNcJdESa/dEPKwPKhg9HnrIOC4JWKynuiMhKjYVj0uBIHRuxVk08xbRXdtUDy2aH/3lWMG9nQ=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by PH0PR04MB7734.namprd04.prod.outlook.com (2603:10b6:510:5b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Thu, 28 Nov
 2024 07:13:46 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::bd7b:c391:6f87:5a9f%5]) with mapi id 15.20.8207.010; Thu, 28 Nov 2024
 07:13:46 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: core: Do not hold any lock in ufshcd_hba_stop
Thread-Topic: [PATCH] scsi: ufs: core: Do not hold any lock in ufshcd_hba_stop
Thread-Index: AQHbPmFtTtbGrXKUVUq0mAoWQ5FRS7LIoMkAgAOsNOA=
Date: Thu, 28 Nov 2024 07:13:46 +0000
Message-ID:
 <BL0PR04MB65641646D6F5CC2924DC77E6FC292@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20241124110747.206651-1-avri.altman@wdc.com>
 <87f1bb6b-6a8e-4bfd-8c1f-d63c857a176e@acm.org>
In-Reply-To: <87f1bb6b-6a8e-4bfd-8c1f-d63c857a176e@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB6564:EE_|PH0PR04MB7734:EE_
x-ms-office365-filtering-correlation-id: a90b97c5-b4de-458e-eed1-08dd0f7c3311
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZXlnaFN5enVVWTlwTjdEbkxQN0lrb3docFhMZ05MZWw3K0c4bjRtK2h0WTh2?=
 =?utf-8?B?ZHFuSnZ0ZFl1aDdOZ0d4bU9BbkpOZEN2K04xdzhlSmYzTW9mUnJnb0NCY3cy?=
 =?utf-8?B?VjYxRTA0Nks2RW1TRjdjZnMxK2E5cEhxTnV0S2F2aEpqRjhHSzl3TG9KL0Jy?=
 =?utf-8?B?dEFIMFBpWXIxcFZ5NFVBUm5vb2pNMEk4Y2E2YnhSSXVnN2RuSFczQUp4OWZZ?=
 =?utf-8?B?NndHS1RNeGVrWHJjTXdYSHRvOW9jNWtvdUVsWXpwYWxzTk9MREYyUXN0Z3FP?=
 =?utf-8?B?ZHc3dFk5YVYwWFdxYlRIZ3JwUW4vZnlSUWxuN3VPOWsrZTF3RVJGWEN5SWIy?=
 =?utf-8?B?WDMrSWc4OCsvenAwZnhSWEFuQ3FucUkzcG83elZ0VzNMNEN4OW84MmpiYytN?=
 =?utf-8?B?eERhUGdUVUI3bm1YTTQ1cFduOWlFd0lJQjlGZ3ZYdEhKTUFSLzNFendkZmx4?=
 =?utf-8?B?VWREU3Q2MHI5bytJemxuZUlYRW1DQXZuazY3N2dtNGNzUWxrZ3dzY0ZEUG5y?=
 =?utf-8?B?REJkN25yamtVTHp4RGFkSmIyM2dIMUErNmY3RDNhN0QyajRPelM2Vko5QnRV?=
 =?utf-8?B?SFZ3NFl2OVF1eTBaY3FLYzVpQUxxR1B5L2dXQUwxbm9EMjdDVkpPa0tQOFQ1?=
 =?utf-8?B?TURQM2xCeTVTdTdwK3BSMHVidzhKaDBEVDYvTU1NNWRJLzZCek9pVUVRVlZN?=
 =?utf-8?B?WmZuWGxySlN0WVVyckptZWgybk9OaHE3eFdrM1o1YTIwVCtzVkJzOXhvNnJ2?=
 =?utf-8?B?S2NnOUtUY3l2cUJ4NGtER2p6dXlPeStmVWZtSXF1UVNTaUtadWJUbWlHLzYw?=
 =?utf-8?B?UW1FeHhOL0dGMjlJM1lvZmUyMitQQmdCdWdHd0JwUkJreDhRc25yeEdpMitM?=
 =?utf-8?B?MFRIK3l6QTIza2xxQ2hTcDFQQkFTWXJpRmt2TWZiSGJNdVlRdkN5WFF4aGVs?=
 =?utf-8?B?QlVPelNwRk5OTWlhWHprSVJuQjFoa0VTNmpZWDN0ZEtOeDVqdTI3ekxNYk56?=
 =?utf-8?B?OVJZQkZsbHFIWHNSdmNSRVd0TnhPd0xabUovMCtjMjMyZVkvalhHSTRWbkd1?=
 =?utf-8?B?cjVsdGNlL2JoQnE2Yi9ZcStOTm9ZNFFnMm9EZG9MWWRFbXhRREJkbkMzKzJo?=
 =?utf-8?B?aWFCclVINWxuM240WklUeVcwc2NuaUwrYVBsbXR1d0s5L0RyZmpHTDJzNXl0?=
 =?utf-8?B?K0djSElwbGh5MDI2ZGFWK3A1ekRTMzVTdkNib2NvanQwbDZIOWNpRGhXU2NV?=
 =?utf-8?B?MTNqajM3T2gydzQ5ZUlHSkFLTE5sbkdyMFdHS1dENTU1K0ZTdW9VNFY0cy8w?=
 =?utf-8?B?V0ZxL25OWXNPTFN1YUR0Q1FFOGhyMlM3Y056a1BobE5lcGdQWE1mOHAzQ2tC?=
 =?utf-8?B?S044RjBWa2dSTXp6b2dPbXEyTDdlMDdoRkl0aWNrQWhReU1TcWhSSllhdHR0?=
 =?utf-8?B?NzdHRmlCdVMvN3c3YmZpb25xcnNrKzRYbTVjK0xJVTV0Mk0wc3hmY0U1V2dG?=
 =?utf-8?B?K3hKazNaaG5FZ3V4T0FLdDFvYjZrTHZDNk5YZThpMXVvS0d0VHRBZDBna01W?=
 =?utf-8?B?WXR1UEt3cnhDYS8xSld5d1BBQlpIN2x4ZWpuWTY1S3F0cDJhcDdjNTM2dkxC?=
 =?utf-8?B?enpFNEo1VWVoaTEwck9aWEhlVGIwSklFek5yeXBLSWZZMEY0c0xFZWFoNVhn?=
 =?utf-8?B?TDNPL3IvRXdKZlorVm82M2dnSHdtOTJKQ1cySjFrVGZWbXMxVElhOGk3dTZ4?=
 =?utf-8?B?b3N2c1VrWkI3OGkzS1R3aUhhaFRmaTlGb0xWbDVja2F6NTVReEhRejRVek9H?=
 =?utf-8?B?MldmYXR4N2xuTzh5RlZLNHlEU00vMGNNVWpUalYxbDQ2Z1Fqb0k5NzBQQmxR?=
 =?utf-8?B?eGNMZWI5cFlLYzFjd05PWUd4SDJvSllEdWRXRG5ZdW55d1E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dWRGL3d4TjgrcWxKc3hHVkM0SU45V0tlRDl0bjA4Z0J3N0JubnJmeUw5YjQ4?=
 =?utf-8?B?UERITlFQU0VxVmFZQjZlMzRPMVJMblZqcVVJaU9JWDJZN2c5UzlQOCtOR00v?=
 =?utf-8?B?dTJ6d08xVllhVEFYVlVkU00raHpQakx3bDc2TTYyeExjUHBZWk9JZUFZbHpK?=
 =?utf-8?B?OVhRZ0VwZFB3RTlJbEpnYmpBZ2owejByNTI3QnRkUHVVVys0amFGSDAyMjJt?=
 =?utf-8?B?aGVCRlNoWmJMMUJGTE1aTE0rZXQzaHhEMVpjaS9TbnhwcXVjNlhBUnFrV1JC?=
 =?utf-8?B?bXVNNXo0WTBjTllWdGF3bkZJMzJteFZBUU5lZ2N0WGtJcTg4a2NIVzlpMEdD?=
 =?utf-8?B?dHQ0RU5rclY0S1U5N21ES3dHSVVWcHZKd1JJZlZQRTZBWFh2eGNWWnRPUjVK?=
 =?utf-8?B?ZnQzaTY4T21CSS9ycnZTc1V0MWRXTlBSUWtnMkVpWW1vZ1Q4Si82Q0VBTkFW?=
 =?utf-8?B?cFVldjRva1kvWWQ4QUtQdGI4WDdVQ01EcGJQTlZDMkI4VlFiUWFsYnZPNWpM?=
 =?utf-8?B?RUUvUlE2ZWFEMnZTZ3B0cWxTQVNPYjVVZzA4SS9ISkowY3B5cmdKendvcnlI?=
 =?utf-8?B?dWUzUGE4UnE2dXgzeWVuWlNhTlBOaU5UVmRLK2VCYlovNG15SHFiTHdpMzJk?=
 =?utf-8?B?OGllMGxibXJIWkVOSld3TEl6azhDOUVTRmlCcXhIM1JCQXBwRzZ0V1B2cDNy?=
 =?utf-8?B?c0VmbUtYQzV0N1FXdjRWYTZnT1dhdEcxb1hxOWZlUzVFRlRIcmFETk95Mitx?=
 =?utf-8?B?SVlwajdDTm5RUHNRQmYraVdiTkUzTGV2M2VIOEZmK0M4NEUweVRqQTdRYk5Q?=
 =?utf-8?B?RVNkaXVPL1NtYXFaM25PcVo4dTBkZGREUDRwQUg0WklVdjEwQXJsdHovL0Y2?=
 =?utf-8?B?UG1HN0dtN0IvMGxvM2hZTXZhSlNpQzd0ck5KaHpWSkk5SE5zZ3V1bUFKbC9G?=
 =?utf-8?B?Wi95emJvbW1wVHNBeUNTZE9EQXBKQkdOQmJ1TERJWWlBVHJWUzBDQncwcVFP?=
 =?utf-8?B?aW1NUDJMVUpTa0xJNTRoTWlMTDYvaWlZNm0rNWJObXNXd3RoOXl0SkFmWnNC?=
 =?utf-8?B?dzM3L3o4SVRLVnltaFpaMFRMc2Y5T2dTQm44WkcrMDVHQm1IQ0VjbzJINm9v?=
 =?utf-8?B?cFlHSU01SWFzdzhnUFRzZWFuT2VhK3BuWHRXV294VVJYR29CeG1ka1FqRElv?=
 =?utf-8?B?aFV2UGtuVGJSTGtpVzNzQTNVODNNT2laZi9OSWZMVXpFTWUyS1pNRkdlUGU2?=
 =?utf-8?B?bVk2RC91cWI0eGtQSXhDb3YxNUUyOXdVVk9IdmZnQ2RsVVdhQkFrT1RQUHFm?=
 =?utf-8?B?dDFVVk1qUnpHbGwzc01QeEo5NDBiQTVwWlRrZ25WVVZzVmhaOHFQNml2enpT?=
 =?utf-8?B?d2QwZ0pKbjBFMWppRTVabkxMdDVPdGwyT2VyenRTbjJyREJ6L0Fva1VFL2R4?=
 =?utf-8?B?ZjdEcE1iaDVZNkIrbk5CaHdUQ3F0aHBpM0FMeXRNaU94WFZZaFI4SjRwNjM1?=
 =?utf-8?B?Y1RpaGtjVjY5RWlTNE5HZE01OE93Rm83dERHOTlnVTNObzhlQVRXK3hKbFUr?=
 =?utf-8?B?TkZMS3NCUHk2aWlRTDBSZ1M5V3VHZDEvSjQ5R1VFc2JHV2M5SWlnVEtMSkVw?=
 =?utf-8?B?bGkxcjdML1ZjSG1RNzZRVTIwMkJycW1NMVBSR2k5OFgyd3RTYVE2NDQ2dkF2?=
 =?utf-8?B?NlI3aWV2cUhPSTVPMEYzbWN5amo5Um1JVUdlTGg0OG1Xbk85Tzlid1NRTU96?=
 =?utf-8?B?WTZFUGV3TGo3YlAwbWxNa2FTclNWWjAzQUpnMnFRVmZsMGJQeklGck1sMzhB?=
 =?utf-8?B?bmF5a08zaFo4b09XUG1pTndhb0Ezd21RWVBWY0hCMStJVEd6c0cxUnFTRjhh?=
 =?utf-8?B?N1NVdHdqYjBYZW96aUhNTGJjUjVwQW45OG1zNmhWc1pxb2pYb0srVi9TNXBZ?=
 =?utf-8?B?Y0I2QjVBb0hKWkYraUZUc2ZDZHJibWZGR0hsVVZ5Lzd4YWM4SWl6bTJlUGFE?=
 =?utf-8?B?bnJlTEVPQi9ldnhZVjlOWWsxaDlVdTdEREN3MmRiRlg5MVlKejY5OVdHd3dn?=
 =?utf-8?B?dUhOUE9FNnZpdmN6R2NqOVgwNDhCbUcwL2FqbkkzTEptbzVlb25ndG03U3B1?=
 =?utf-8?Q?O3eH00ngv8LKjVfJP28gChgZ7?=
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
	7JcXKnK+JSRSwxDKXICW5CBscNhcPm3ygN4Uhh0Z5kgjCKAqg8YPBo7U5UtIVmY9ddfjWEBkmj/yqoPik8uuvcA0bYFgFuHmdLXZqic+sxnx0PIzwd24tT4dy2vnv1/6JW2xFMeuvUwa6iXUzXVEHsCQGkk72TUt7iak0b0i9yF2esNGig2P7C1e8HIWFJrsvFOqF6QkCfH0XHa0oVP5En3X5jYKP1DoKE4SZ/mjXlW54hP68j/7JsX0quDJgEnQS1oei/km9LPoBgQnORABw8lKJFgG+Fo7XPUVHL/4ODn4YvthOmN4eaUkQqpbh7WM12Grnd6Qm9bG1WD4qjhA3aJcjZWwnFY82ps8C3QhAgu8BT2CWntJv6jkB1rmuJY+Nx1IooRRjkYY8sekgAX+qSS/EAgMfLeYe/qileNrP3KOaMZg7tuW87sLviNd3ZC14/DYRm8SmwkMWvViBnhC5LfrQyJEs9ESncppn34qYCYgUHU6vcLJGt541kyWicjohWHAd38uC2v9pj5Zk7/vgTxSikAD7RnjC4wT6XzX9ORoxpBOsc1OAEEZ5bvi45H8NUJ5f0NKWKS4AEg2yCP0zp2NNOdREW/saGUoxKzJIWcEQH1R+0Hm06oXIMG0/w9S
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90b97c5-b4de-458e-eed1-08dd0f7c3311
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2024 07:13:46.3096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XN3shtWXJDEnp0qIsNwVdVewY8ZeiG6pF6DZ8m0LfFEFRod725W1MPViKM+JP0miN24kbI+51Vb/9lcq+W0cpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7734

PiBTaG91bGRuJ3QgdGhlIHVmc2hjZF9lbmFibGVfaXJxKCkgY2FsbCBiZSBtb3ZlZCBiZWxvdyB0
aGUNCj4gdWZzaGNkX3dhaXRfZm9yX3JlZ2lzdGVyKCkgY2FsbD8gT3RoZXJ3aXNlIGEgcmFjZSBj
b25kaXRpb24gY291bGQgY2F1c2UgdGhlDQo+IGludGVycnVwdCBoYW5kbGVyIHRvIGJlIHRyaWdn
ZXJlZCB3aGlsZSB0aGUgY29udHJvbGxlciBpcyBiZWluZyBkaXNhYmxlZC4NCkNvcnJlY3QuDQpp
ZiB1ZnNoY2RfZW5hYmxlX2lycSgpIGlzIGNhbGxlZCBiZWZvcmUgdGhlIGNvbnRyb2xsZXIgaXMg
ZnVsbHkgZGlzYWJsZWQsIGl0IGNvdWxkIGFsbG93IGludGVycnVwdHMgdG8gb2NjdXIgcHJlbWF0
dXJlbHkuDQpXaWxsIG1vdmUgaXQuDQoNClRoYW5rcywNCkF2cmkNCj4gDQo+IFRoYW5rcywNCj4g
DQo+IEJhcnQuDQo=
