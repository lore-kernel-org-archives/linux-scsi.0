Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8409921519B;
	Wed, 22 Jan 2025 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737567982; cv=fail; b=MO2RjgdEtxZaxO2dSdckm8wNK5Mh8GjoFdbweylD/fKipUimYxuh98c1YXiFwo1R8oDsD4GfuyHfLkmyU3dsjnxWU/afSHDcIjhF9d+CP6slOSgmPY7ZwobM/PYIv+sDyiB96EEGEGgfseTYsFjbuJz+bxR84FAY8SC1rAZh6Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737567982; c=relaxed/simple;
	bh=UgFsWv1xOfvpz6vpUr8ZPhmZVxnjUTqxGDQ0Dp68rTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K2YYAKyUGThQVuJMzxRoM1WGzaHMzDB1rEwXyDcRs85WtJ7rFXyOGptJ6uyByWySQD/v5JTWMW9bYTpFcQx6ff0FQ5+EIMkKtS+CCHFGY1kcWGAwTKzoTphFPhaVfclWLNMsV6u2Z6Ak0u4rargv3n4qIjV10a4zWrApjVeWlZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gM2ZpbuA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=daiZV98y; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gM2ZpbuA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="daiZV98y"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737567978; x=1769103978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UgFsWv1xOfvpz6vpUr8ZPhmZVxnjUTqxGDQ0Dp68rTA=;
  b=gM2ZpbuA0lFD8+IKHvdpRR+4qk9DAabZ9j1bR72MMUIpo4/dgDXfwpbl
   kqY9730SLVXGd+GqejXf1WJyMRwTyjQajsUAMBEgWKuFuY4B6I5TuV8lZ
   021NtqnCo7PkwtYXXAc14gWawAZRwvpyv5b9F85QJ08aszd8JUx0OYyRt
   O4aI58xNmPJ2agKfV1bdxKh+PqWsIcy2dZfJPb9UJ/ajilCh6790ol0yS
   xqCV9rGgx8URBOJuur4LiaACm8o6w9IejHXIsnwzTKIB2q9xBvmqXNlJA
   fAOCO2fyce5qxmyL+KXgjxf6+2R4GO/J5eAOvvywkhNGKwgGUP8edvS8j
   Q==;
X-CSE-ConnectionGUID: +NQpOcsAQ5CYUxYmAE0PMA==
X-CSE-MsgGUID: hlh/YTc9QdilL1LlsvfoSg==
X-IronPort-AV: E=Sophos;i="6.13,225,1732550400"; 
   d="scan'208";a="37566043"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2025 01:46:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5jkOyBuaASVrY59nSIpTx4dnSkLHPg/BojmHMDeRaXBgYeLinkerCt19wxb4TUAE43mXGAW1bo4ZeNBiJ52ddLUO4tMHXYBbze7V6aou8gDD3jgm7PB3YzH2RaHbkrkMQM6EBDElfphLJE8ttUaWw2V7klNlH7aEBywQZO9v4YsU1uSwbD4WPHRMCcvN/n9FpZP3Z1uCpwDBYlgrFjXRf59wfF86ro3FdpONd5W9GYDESyDM24Q+ntB95aq1vJ53DVA9Q1FEVVfMoF606rPftt8W55MPrRq8UHJ31gjMQu2wf77Q7jjTzl4SOV5T0BpiaicZhOdm1jWfGRvghF8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgFsWv1xOfvpz6vpUr8ZPhmZVxnjUTqxGDQ0Dp68rTA=;
 b=kOf6Iw0WJWR7toMficwPO3RqK82E5amJO/6HoNLDuo8KV2gu+ou1QUg6O+lEOYZynf7oksOPvURhMsw5eq7A4o23EzO1bsdw9fIAX3WCSsdg5w+zpDuJWssldd4xQUZFMb0WuquYA4DlPKfgJrTvgSghJZ41jP3L6Mm6XYv7wjfL+YiNb/c6B7JCGkkfsZho5+s9EE3OsO0tHOGrv1DXUgOmLs1rAAyM93N1fdjG6T4+Fs+cJv7xa+7Oj0Kt/F1NCxf4oX5JRJgcRmiKja+I//BvEsoe9tXse8o3hA9WQOlP158Qw0Dp7/J1fqhZaoy0/emK6ee9dL/YDoVpZw6VMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgFsWv1xOfvpz6vpUr8ZPhmZVxnjUTqxGDQ0Dp68rTA=;
 b=daiZV98yA3dhfwCx9prBDl9+JL9irkCuUHbPT031qjxi5bj1rA8Swgwnu2Xak0M/wVClqzXhnIFrwlJjbJGtew5rpUZAaN+7DB3sSs5zMGGTsz8ECXC75Roldb3UfB87uPRd0EnXeaku3JKMACu7FjU/4FiP5pijNCnJuD+FKps=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MW4PR04MB7316.namprd04.prod.outlook.com (2603:10b6:303:7e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.22; Wed, 22 Jan 2025 17:46:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 17:46:15 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
CC: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van
 Assche <bvanassche@acm.org>, Can Guo <cang@qti.qualcomm.com>,
	"quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>
Subject: RE: [PATCH] scsi: ufs: Move clock gating sysfs entries to ufs-sysfs.c
Thread-Topic: [PATCH] scsi: ufs: Move clock gating sysfs entries to
 ufs-sysfs.c
Thread-Index: AQHbbNtf3b+v2i0m4UuvxCr2kqq9sbMjB/SAgAAIw4A=
Date: Wed, 22 Jan 2025 17:46:14 +0000
Message-ID:
 <DM6PR04MB657573FA8C1CA294A5324F21FCE12@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250122143605.3804506-1-avri.altman@wdc.com>
 <20250122171237.33gvwxgmpsoqekwt@thinkpad>
In-Reply-To: <20250122171237.33gvwxgmpsoqekwt@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MW4PR04MB7316:EE_
x-ms-office365-filtering-correlation-id: d89cb8be-99ac-4bb9-6360-08dd3b0caae8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cTVTUkIvMjg5U0FXS1pLdXQxNko5YTVVVXczOFEzajRua1NERE5yUjEyd0xm?=
 =?utf-8?B?SjRxTkF2MTRPN2J2K2lpQklhdnZQcmRWVkRQNXFtbjBibVNORlgyZjVhalBy?=
 =?utf-8?B?UnQ3RkIrMkIraVVVb1JCNHl1bk5yeVhTYkRKdVVFdU95TG1WYzMzd1ZrQmtI?=
 =?utf-8?B?N3FZTXVLc3M0NEN4SnYrL1RJYXNWZXVaSy9tK0xkY2RhU2tyOVVxelNGTm12?=
 =?utf-8?B?czJVeStnWEZ6Zk1WOWM4U2p3bVp4bkZOdkRLRTBhRVlvT2hqMjR3Ukt3MUtR?=
 =?utf-8?B?clptWCt4NWN2MjdHQ3dQUnVUTjhHa29Ob2hlR1k5VHVQRTFjeEl2dURPY0Rw?=
 =?utf-8?B?MHdmRkxsVm54TUVFaFBKUytMOUwwQjdvdE56Nk5ZUldTbzBrVkIzdmNIa1JF?=
 =?utf-8?B?MUNZc283QlZQSXd0OXhQOHVoMmFuOUJuOXNqbGxwdUV0dE05elcrRGFiRzcv?=
 =?utf-8?B?U01PME01VHd6RHg5cjk4WHBLaGdnUmcrYWpadHVkOXQvcVpseXdwcnFkM0FK?=
 =?utf-8?B?aHFEOEE3UmhpekFNTjZ4NWo5WlhYdXJXbWRyZDA2dEs2T3EzMUg5SE51Ritp?=
 =?utf-8?B?YzdMM1h4RGdOU0Y0VDAwMUtIOUlURW1OUGFYNDdGMmMyQWVvTHB4T2VkT21y?=
 =?utf-8?B?WHRsY1FJa3ZGeXJZQTE0V3MxY2RUTlNKak0xUUZhM0xUbWZoMGxtMEpWRjRK?=
 =?utf-8?B?RzVaYmdKcnROKzFJL2lLZms3KzBhRzcyWVFKVUtMWUtaMHg5ck1Zays5VW5j?=
 =?utf-8?B?ajJuUlVMS2hmRWZqQ01XNXc5djV3Q2xHYmJFc2RLTXEvSkNYbDNTbXltZFFF?=
 =?utf-8?B?RXpSek5pcmYreUViYTAwTUhCRGhOSGhXRU5aYXFjcEhVQTR5WHZIMzZMUDZs?=
 =?utf-8?B?Q1F3UkcxUlh6b2pYMXdEOGx3OElzajkrdExlSGo4ODNaY1NLUE5UNXFjcXAy?=
 =?utf-8?B?bDlFZDlWaXArelo5N3FlbU1LdzlaZWFibC9GVEsyS3M1TVdPVHJFNFBUUUhj?=
 =?utf-8?B?dXBDMTRYelZyMjZNQStwSXVaMS8wNUFaOUJhQVZNRTJHd0lYZFJySWhEcWo3?=
 =?utf-8?B?YXlRU3J3SDFSd2dIcTNIdlVLcTFMd3lrQ1dBUlUwc0hFeHJaVVh3QlRmS2cz?=
 =?utf-8?B?V1FXRUo2aGI2cEVQNTRnMk5QM29pQzVzVXpYRURlV1haa085RTdCUURrT1lq?=
 =?utf-8?B?ZDdJeEZzSGRuMGhoTTRKZlNLOWJxMHFkMXpZdUZPWW9tNG14TkxLdFpZcUpm?=
 =?utf-8?B?L1JpQjNxNlNuY2F1L2tEL2RaVWFsQTZoekt4UWoyWjhEc2tGS0R4N014WWZO?=
 =?utf-8?B?T1dMVWFYWWJnWTVNdmRWSkhGUm9lejdtYVprS2dCRm9uYm94WDd0T2FJVXhv?=
 =?utf-8?B?SzRrSWFjZHMzNGkycll0QVZOM0c1eHZtY3NoNTFTM0VISHF2S3p6N2lTZUNR?=
 =?utf-8?B?bFFzRENGUTdiREpBcldERFpmNUZHWUxSdFJvUDkzMkxMSFBTVlA5QWRhQkZ1?=
 =?utf-8?B?d3lnTGwrYVJYbGRwK1J3QmJ3cEtMZkhZMXp1cXIzYm1RRWI4L1hxeTZ3N0dv?=
 =?utf-8?B?Q0pvcWVKejlwSGVTaG96d1lIZ2ZYR0F5K1hYV0d4bkZ6UWlHZGExbUoybkQr?=
 =?utf-8?B?U3pvQVMyU2o0VTE1WEg2ekVLc1RJcVRoMG42bkM0NWxiVkRqMEpXK1pzZXJQ?=
 =?utf-8?B?elg5NWM0dlNmdFcvYUtyK3ByTGxTaFhrcXM1R3VWT2MvbG4xM3R0T1NjZGxS?=
 =?utf-8?B?akhCYlNCK1FMQzNpOE1kZStWcGNLMXRzbUJZTjkzSUcwdURIZjRzY3JkVTcy?=
 =?utf-8?B?TTRpUFZveGZhQ0FVMEl3aUVnZ0dxWHB4V0RGRUpaeW1kK2htV3ZLbk5Hd0t3?=
 =?utf-8?Q?1qfKMYsZHVQ22?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bC9NZGp1ZHNRempneDRFM0R2dERCa2I1ZHArOVY3UzkxZkNqNUxKNTN0U2ht?=
 =?utf-8?B?UWlHRVVZSWhVMnFnNHZLRGJkcks4d2FYemZ4R3BjSkdiYUp1QmhEVDdYMVUw?=
 =?utf-8?B?NmszZEFGK2V1ZGtCMEZ6YW1JL0JnblEyYU5paGZiSmowMm5Ic3BueUdobEM5?=
 =?utf-8?B?eGJJalgxTDh3N2dkNWdBYldiLzNTbmRCUHd2NXczcHhjTjlQdmU4RlB4U0lH?=
 =?utf-8?B?MlJMd3dBM1ZqaENyMGVJMGcxTDQzOEUxb0pXRk9ZclNoSEc5SUlCKzhKRXZQ?=
 =?utf-8?B?eWJCTFI1MXFhWEQ0TXVKK0ZnR0p6MFhPUVZZNlYyM1grUmc2ZmNzUWRxQ25X?=
 =?utf-8?B?TlBVcXZiMERnQk82WWV6Z2gxRStmdU1WbWdGdDRwMEZxZHZna2tjZW9XWTBM?=
 =?utf-8?B?NDhiaHgrNFp0L3lrTGsvMkpjTWlLZFFGc1cvYlZqUnkwOWtMRVNWaUhnUmln?=
 =?utf-8?B?b3ZsZms5dEhGcUwwOE4wdTZSZU5aNVJ6ZGgrRlRrKzVzQSt5R0Rla0ZyUmg1?=
 =?utf-8?B?MnlMQXBoY3Y0Vzh2YWxjem1IS2FoWkozaGxrMGl4eUEzbjFLaUtYS3RrS2pv?=
 =?utf-8?B?cSsxUjM5SmR4Yi9KYWdncVl0NUlkdWV1WEdMckNrUmI3eUZhQjVaVlZVQ3Ey?=
 =?utf-8?B?YjJ5NlNMY0JYamJhRm9LTmJBb1B2WXdxeSs1ZkVnOW8wOG5jdUhLUFBoZ0xv?=
 =?utf-8?B?ZzF5NWtibmo0dUxUMW1PUnhRa3IzSTdhMG5DR0VWT0d6bGFjRjRuWmk3eDJr?=
 =?utf-8?B?QkU0d0F3ei9BRitkaHNjd2JOdXB3TE1OUU5Xc2kyMkhTYnhzNjVhVGRXSS9p?=
 =?utf-8?B?eHhjVkcxUVFyYTJzUlJSbUpmcmF6RjRSSkQvWW1tTFd5K29ETUZYSmMzNHlF?=
 =?utf-8?B?Z2Z4ZXRsMFJVU1hPdUQwcGVXNnFvYWRiMVdNWkJSS1loUE9yRzNyWVNFWXpN?=
 =?utf-8?B?Y3UyOHBlUGZVTHVDaWxKYjFONTQydXFiVVFleDVOVHRWdG1zby9PV3BmYnp6?=
 =?utf-8?B?VmxKOEVHSDlpRGtYc3hMREh0L0Z2ZjhITDN5U0dFcWdtMWdabStlT1gyb3My?=
 =?utf-8?B?ZGhvVG96NFdQL0FqZUVLSVBTS1htcFl6d0pWSWRLSHJGcjZuaG9HL29zaExy?=
 =?utf-8?B?S0c4NmZVcExtRElSRzN3WGVkaGllNHZ6UEwwaHM3VEl1aVp6SlA4d0tjbXZ5?=
 =?utf-8?B?S3h4Z2RGWDcyQkFSR0pxVmVJaVBTaFRNVE5xQVNyTTlUR2syZkJqQlhDclJH?=
 =?utf-8?B?M0c5cEZzbEd2M3BCUFQ3b0JWemNKTk5pcjBWNUNRZFU4T3ZKQkk0OUNmTlJC?=
 =?utf-8?B?ZENSd2FqN2Y4c2s4V2UxMWYrYjRuK3kzVG9oYmFlQ2NDcXQ4WjJRN1UycUQ1?=
 =?utf-8?B?SEtFVlFxZUVGNkxsYmNlMXhEMUo2K2IzZXZ5em05UmVSSndkOU5idnhwRWgw?=
 =?utf-8?B?Qjd3Z0R5QUo0bGJhQThzeGxnNXNsVENGZ2pnZ0VydEV4aXZ6cE81QmJ3Qml2?=
 =?utf-8?B?N09MUTBTWWtjSUNtd2ZCQ2hIM0pkQ1k2WEZsTmJ5cVJuQWZ3cS9QZ29SWGd6?=
 =?utf-8?B?VG1LaGtuTzM5QmM3V2VuM3NHTTlDeG5tV1pQNTFPYTB6N1JJaUdKVEYzTDVj?=
 =?utf-8?B?MEhuT0pUaGtGc0dBbjFiaWszQjh4WVI2elVnNEZtRFNjeldCMi9vU0NhQ1Ew?=
 =?utf-8?B?YWVwclVOVEJwa0xWVWY5RG96ZmhyTjlmK3VVaGJpZktmZDVic3dUeG9iUzFn?=
 =?utf-8?B?b3pQOGZQQ1lHZ3VnQ3AwazBad1QxNXBVdDQ5aGVFTUFJUEY1QTA2R0JKd1lD?=
 =?utf-8?B?Q1d5Z25RTFFob1llekZvZHYwZDg2bGxEMXIybHNaUFVKbGhFaURTVWhQcldm?=
 =?utf-8?B?MmlSM2FGRldNc0kwc0pYQVpBcmU3MW1yaWtPdVpmTlNZS0oyZ0Q5b3lRSEZG?=
 =?utf-8?B?ZmNqM1oxWC81MDhCaGhSZGk4dzhYd0ZxRzRJejZPWFhBWXV2WlR5aDZyL2c4?=
 =?utf-8?B?K3JaOWZHVThpUXZkbHY1MmtuOFY2ZXNpTGQ1RmNSSTlia3BRTjFTb3pSTEFw?=
 =?utf-8?B?Q2VaWTJ4VnNBMVVOYlRDNUt1bXZJQzdXdWdqQnI1R2N6YUJLcmhTV1RvOXBI?=
 =?utf-8?B?YmJuZmpjRnRSSHFHeFE0RzlMSTR5aHZITTNTeXhRaElOc0ZObHFFaEVNeWVZ?=
 =?utf-8?Q?SfLCRbKBuXKm0f0hTRLyBe1eqndgFKpcG7BeJXQ+v4xb?=
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
	7rIBpzMhKlJeKQQTAd2Dl9QCSnxQsjAoFzymUDTAnmNBdz7+MLQDQ9G5de2FDXx2ielTtjpv4QZ+/0TxCcD5aYvBpeVD3Qc3VlwnQlCFcrn4A2w2J5mCCtj0Lk2B6RSCZ7Bl6hqh7tI+vAYSeY6rvHUsyjm5URd6aOtxFJqtJYz0f5DoLgWo0J4thTU3eYF4IOLZDHM+ZE7a3X2kTTBrGAaJHMKZDGj3QuCQbt64BZx3vGYBajGh+4maqKXX8hd59vsBdDcd8L5exafA1WeFupr9wtWDJZ17SHpQHhhbxI0AOrTme5M9I0N9eMDShFQnLYozjSDT5E/ow61upNaBnBr/TbL4xkOBQ5qWfEcqW/oiHBWmyShO4pcM+69LGcul3iAsGEgHWbN9YodkCBA8sGDdDU/W+NKcZ2OqFivB8nzUGADyXg2zNCWGYR7Z1MyQMIfPZNOLhFXi5a2tW/wQY02h6n2xBphZ/SJoAgUNoVvN4r0BdVLreG9IZhfXnz6MNUNTScvI0VmH1LqZzsSFwMfIdewX62li5P7u9SsdM5j942G56+IU2HLZ56TekHNF9u9i8TEt+rcVVsTfmfYZ6UeGVPKttDme40ZTSqHWKuE5Jk3w+6xMgCb1vapznWpR
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89cb8be-99ac-4bb9-6360-08dd3b0caae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2025 17:46:14.9157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lho04o3jEfoZHBEkYTtQJSQsW/GUNxO0WPLQaA+IyuJujOSb92ICYaK/f0cLeJ3kC9ccFHpkLyvpk5fG5xm9Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7316

IA0KPiArIFppcWkNCj4gDQo+IE9uIFdlZCwgSmFuIDIyLCAyMDI1IGF0IDA0OjM2OjA1UE0gKzAy
MDAsIEF2cmkgQWx0bWFuIHdyb3RlOg0KPiA+IFRoaXMgY29tbWl0IG1vdmVzIHRoZSBjbG9jayBn
YXRpbmcgc3lzZnMgZW50cmllcyBmcm9tIGB1ZnNoY2QuY2AgdG8NCj4gPiBgdWZzLXN5c2ZzLmNg
IHdoZXJlIGl0IGJlbG9uZ3MuIFRoaXMgY2hhbmdlIGltcHJvdmVzIHRoZSBvcmdhbml6YXRpb24N
Cj4gPiBvZiB0aGUgY29kZSBieSBjb25zb2xpZGF0aW5nIGFsbCBzeXNmcy1yZWxhdGVkIGNvZGUg
aW50byBhIHNpbmdsZSBmaWxlLg0KPiA+DQo+ID4gVGhlIGBjbGtnYXRlX2VuYWJsZWAgYW5kIGBj
bGtnYXRlX2RlbGF5X21zYCBhdHRyaWJ1dGVzIGFyZSBub3cgZGVmaW5lZA0KPiA+IGFuZCBtYW5h
Z2VkIGluIGB1ZnMtc3lzZnMuY2AsIGFuZCB0aGUgY29ycmVzcG9uZGluZyBpbml0aWFsaXphdGlv
biBhbmQNCj4gPiByZW1vdmFsIGZ1bmN0aW9ucyBpbiBgdWZzaGNkLmNgIGFyZSByZW1vdmVkLg0K
PiA+DQo+ID4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBB
dnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gDQo+IFdoaWxlIHRoaXMgcGF0Y2gg
aXMgdXNlZnVsLCB5b3Ugc2hvdWxkIGFsc28gY29uc2lkZXIgYWRkaW5nIHRoZSBBQkkNCj4gZG9j
dW1lbnRhdGlvbiBmb3IgdGhlc2UuIEkgZGlkIHNoYXJlIHRoZSBjb21tZW50IHRvIGFub3RoZXIg
cGF0Y2ggdGhhdA0KPiB0b3VjaGVzIHRoaXMgcGFydCBvZiB0aGUgY29kZToNCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtc2NzaS8yMDI1MDExOTA3NDgyMy5sbmxwcGRwc2Zua3o3b254
QHRoaW5rcGFkLw0KPiANCj4gTWF5YmUgaXQgaXMgcmVsZXZhbnQgdG8gYWRkIHRoZSBkb2N1bWVu
dGF0aW9uIHRvZ2V0aGVyIHdpdGggdGhpcyBwYXRjaC4NClRoYW5rcy4NClppcWkgYWxyZWFkeSBi
ZWF0IG1lIC0gaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtc2NzaS9tc2cyMDI1
MTYuaHRtbA0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IC0gTWFuaQ0KPiANCj4gLS0NCj4g4K6u
4K6j4K6/4K614K6j4K+N4K6j4K6p4K+NIOCumuCupOCuvuCumuCuv+CuteCuruCvjQ0K
