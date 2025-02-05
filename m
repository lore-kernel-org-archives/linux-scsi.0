Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08DD1FF1DB;
	Wed,  5 Feb 2025 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738782465; cv=fail; b=dQHitkjkC46jm9FenMyhfArMBF3/DLld+UUHmpWwXaYCCjhi33rXAxDixkyQb10Qpj/q57x3rhpUrAe0F718YQbw0o2P1YneOiiPQ9VxL4TS7rNe0OHqQS0s/7c/HDwc4gKkaWyfv9sbw/DeX8ojfYUf45p2Mjy3rtRRKOz9z7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738782465; c=relaxed/simple;
	bh=XQnsKXRipvXXY0ThusROKFF2nSfznZZ6j5+tE4NxSLY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bgejxwMVVA+PA6ue/iUQzrbn/JplC/Ho9kaqevoRrmEeH38RXzwZfZIILACrGAaH9Wakw++Hms3mZtjgByjKKNhB+8zPsFbs2ZW36MgNYl8LKK9WQBW0UBh4Q2/8MEbYWlNbDch2daQa7eO2YMRQ31ar9S4wlrN+N/aysBS8DLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ks+w0NlO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ZLF89AxJ; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ks+w0NlO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZLF89AxJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738782464; x=1770318464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XQnsKXRipvXXY0ThusROKFF2nSfznZZ6j5+tE4NxSLY=;
  b=ks+w0NlOP5J0lgaAZ0LTE15x75AMWuKxu+63VIggZj+kVpRGL2oLScrP
   FVAhiQMyzAc6wfwhjiYhT/uJXaF86HJg252VzLjdYuF90X36AiF90fArv
   oBy++BS7EvZ5kl2oVy7y85CAFC5F+W8vFq7aSXjjcHFlPhqRaiGQZqD+L
   oMUdbc93kN3DajtQzSsU/uYLjRcu+zKHv1f6lVf2MPldfXRnkXtlyP/Dn
   J7+4t+uAiNUjA4MH7MvE7zoCIZyin7h8U0OJ1WcfeXL9o7ofOMvIYAjtn
   397CK2jhaOC6E4OwK7Ei+f7RAg0NbPia9padsQizirM0i+B9kM997tKU1
   Q==;
X-CSE-ConnectionGUID: GSEiv6KHR92cCVeNwak68Q==
X-CSE-MsgGUID: jicPo7/oQluWXPTPodDGCA==
X-IronPort-AV: E=Sophos;i="6.13,262,1732550400"; 
   d="scan'208";a="37680022"
Received: from mail-northcentralusazlp17010004.outbound.protection.outlook.com (HELO CH1PR05CU001.outbound.protection.outlook.com) ([40.93.20.4])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2025 03:07:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnXYa3H/aJ3zQDS0KKyh/C20yiFaSSaQvS6aleXPFZXWipq0SLuDdUWnWvbieVvlDEbFHa+9t9WPX0fJYdl9BcNAJnBXSXlzAM679MC8sho8fveK/GcLmp83bgfi2dJAiILFQLWZsaSRF4mzai5ahb8gNu/8wCAu/JIwsiEMrNzciXQnis38Tu7nKdCkGPBcMlPCp9rykakq/Zt0UD06ToFaKooY1VCTgn2L8cG226kBNlqibPaND8h0uQvSzzMvS9O8dQo9KAX1UAnaHEFmHANynw9Ra+BXxBk+WRGEYah45/CVi/LZ1byKFMV/UGRqx47ReVTD0/WQQgLzfYvmIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQnsKXRipvXXY0ThusROKFF2nSfznZZ6j5+tE4NxSLY=;
 b=JfzQpEj4MB4aXpM9sLvyFU6+LEgiDxBhCNwoluQl7G5oLdAE0AYM3eiZra3hJDSy3hK1vtUT4dWv1loSG+8EqO2GC9Nihx7UvqTBlXds856XJkvIBdK9/fxsMWEiXQbF1VORYlKHEjFfGbgPKPZZrbM0uTHTpmjuU4Hrg+4NnQaGbhBxAeEsipnJxD8CdZicydRLltm87HW3pwCVWcH5B5pb+bVBIcklceCYIQaWIh5JXJ3l023O+xvRH3BSWQMbTbVk5FejrRnJB3uMG4gIp8nm9O0oQ/+LH8AqTY+dJ1i+yLP0hE6w6k806erI8yPA4BYgGROGt2yvm6ohERNebQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQnsKXRipvXXY0ThusROKFF2nSfznZZ6j5+tE4NxSLY=;
 b=ZLF89AxJWvOZnWnqm6TUDA1R+kx3yopxILiiJQ8iEmd9+7T2Ol2AsCP06wfEpfnRgiN3ADo5HHofiKimyCJnIwhcDyyjnDzirkCuZcwbeAVAvKErGRmJV2ffP8wxdj0WjQOQkl5ODXMul2/6Zw+e9ffldBr6lk4FjkLnzbi2adI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB7136.namprd04.prod.outlook.com (2603:10b6:208:1eb::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.25; Wed, 5 Feb 2025 19:07:33 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%3]) with mapi id 15.20.8398.027; Wed, 5 Feb 2025
 19:07:33 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: critical health condition
Thread-Topic: [PATCH v2] scsi: ufs: critical health condition
Thread-Index: AQHbdxHmvf69B4w9AEaXxutfZEUuCLM5AagAgAASWaA=
Date: Wed, 5 Feb 2025 19:07:32 +0000
Message-ID:
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
In-Reply-To: <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|MN2PR04MB7136:EE_
x-ms-office365-filtering-correlation-id: f79577e8-f8a3-4372-7616-08dd46185839
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QWRjd2VqZU1ZVnI5SXFXcmFuVWp6VHRtNXdoOHBXZGY0RUFHYmtHdUhHQmlp?=
 =?utf-8?B?K1lvalhzUzZMRG9NM3NrRElBYndPSUxWeU5HRk1qN2QxWXJhYlV5QVhjM1NJ?=
 =?utf-8?B?aGlnV0M2ejAvL1NYVlNKWFgwRzhtUk1WVWhCYWFiRnZNOUdtNVhrTFF6aERm?=
 =?utf-8?B?V0wyRmR2dGFGazl3NktBbVMwR1RNSFdpK0F5S29xQ3Y2MmdxRS9zZVBnTnpq?=
 =?utf-8?B?Y3pjWEJpWmM2K2FSZ3U3REMxREtmcjJ1Slc4K1AwNTdPK3lRMjkydFFMZEE1?=
 =?utf-8?B?SDRFTVVQT0JBckRMdEsxZFJyc0t2SjZtUVVnL2FEclRmWUFLaHdkVTZnS2FE?=
 =?utf-8?B?OG16WlRlNU1adG1vYzZyY2JzZFE5b2o2WHNacjJOb3Y4Zi9qOHZObmRpQWlL?=
 =?utf-8?B?Nkk4d3ZVczNqaFFaR3I1T0VNQnA0VmdEL0Q4ekllR3pjWm5SMlVNWExUV014?=
 =?utf-8?B?QmYyaENMYXMyWkNscFZmQWlrenZ5ZURCVUpSN3ZJTkF4VFExYVRpa3g4enpY?=
 =?utf-8?B?dzZLYlZQMlVVUDN6bFRlejZvVnZMRzVJQ1ZJQy8xVWozNkV6UUk2YjJlaHlP?=
 =?utf-8?B?Y1BIS0xNaWhFZTJaRi9BZzVMVGtnN3NIckh5eGNra0lUcndqQnk5V1VVcXVZ?=
 =?utf-8?B?aGVrU05DR0FRRDBFc0Z5OW1zaU5HNzNmKzduTzJGK2RQenpqdmlRTzQ4aE9I?=
 =?utf-8?B?Wno4YU1oUVJXeElmLzJCNVpnZzhpMFpEemMxeDdpcFVEUnpoaEo0NEZCWG1B?=
 =?utf-8?B?L1ZidUUydFdleXhUVm1zQ29mZi93V3FpSThSL1Y5bXViQUF2Mis3cDlVODBy?=
 =?utf-8?B?VVp4NzFhdW5FTmw1K1RLUHY3WkxVVERXU1pXYkJiTlpvanhUQ0FSa0Z3cU5R?=
 =?utf-8?B?MCtNU1AwOVgyRUFCN21sbGhIbGJtM1I1WkN5R1M0NGNUQTY5MU0zeVRDL2Zw?=
 =?utf-8?B?UjkvZUM3aGRlenZEdU00ZlhoQldHa2lkTXpHdmhsUmYxckp5aG1YUi9MRGc0?=
 =?utf-8?B?NTdiS29UV25vU05CRExLY2RMMnZ6enFMa3hrd2dCV3VhM2M3ODQxS2ZWeCts?=
 =?utf-8?B?Y3R4M0RQdzhNQXBXd0FoRkpIelFWSDQ4OE85RFJJeXdkVE4rSnFaZXU3OVpy?=
 =?utf-8?B?cnRPWEVIZU9RRDRZejZGbUNKckZGZGZiVVhiaExUOTV3dndGOWxLbk4yVVNh?=
 =?utf-8?B?M1RTRzN6ek5DYkxHK0tnQkJHUGRwV05qMDIyT2FWdUVCSUNoRm9Ncm5VZzZT?=
 =?utf-8?B?WkxnSU1JdjZOTDMxY2NKcGt2MWlhWm4wLzBLMTRkMXZCaktiZDQ2SWlYQ1ZS?=
 =?utf-8?B?ak1Kai9RbFFNNjBoZWVyZU9EOWtGZEZNcE00UHVHZHpIL0xJc283NndYTTNU?=
 =?utf-8?B?bFN4MWZVMnNqMUQyVzJDWm1kcWVJdlM3YjErVHdDZVlDK25VNDliZUlGVi9y?=
 =?utf-8?B?NnMyKzRkZGdQbEtGSGg1dFpHZVpFdytEbitvQ2tZOUZHdXYvczdQMUZwSEZ5?=
 =?utf-8?B?Wmx6dGg1MWxuZHpiSmFvK2tWUWVwNnpqOVZxL3JscTZFRENTSSsxc1ZUTFF0?=
 =?utf-8?B?RExyY0tIWnlQczhySk0xejlZWmMxbTg4dDIzVXVSTi92ZTFiUFBKcXdURTA5?=
 =?utf-8?B?Y250NkVZQzM2d3U2bGZiaGRDa3pWM2c5eFE3NWR1bDhaK3V4cUlDVStCbGNi?=
 =?utf-8?B?cHpacHkrcjdPUGVacUR0Q2tZMEpTQTZuWWNpZldTNDdPWlRRcDRJUFY4ak10?=
 =?utf-8?B?eW1PK3BjTkpYU2ZndGpKVGg4WFYxdHlhS0VUMTdiVzBDUm55QmN5VDBjV3Bo?=
 =?utf-8?B?aWNQRjZUckJmcGtiUVpRTHBvdUNlQlBUWnBNdlpvWm9HbHhKd3AxbE1hWG9L?=
 =?utf-8?B?ckNBbmVuMzhMTkw4dFp6YmdDaTFIWnhpUTVpUDI2RHUrN3hyQk5oanFGK0w0?=
 =?utf-8?Q?5mQGB7RFWpQH3PX7WE6SI8t+Wy4/eOa0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eDdYejN6azdxaGpGSTFkSHJnNC9oZEljSEFmelJURWo0cGQ3WFpueFI1c2JJ?=
 =?utf-8?B?MmwvbFJ3RTkvTEUvVGJKR2g0TE1vYVVHaStwYm9raEZDZjVVNGIwZzZ1ZDRM?=
 =?utf-8?B?KzhPMFAvaFNKam4xNVQvZ1lDOEhNK1VsUHEvT3pPSE5ZYlMwemdmZkdlZFBx?=
 =?utf-8?B?YTYvNkJJMkFVc2VQSFpYYU1KVTdLVC9uNWtYcVIrM1I2cms3cG4wc09Hdzlv?=
 =?utf-8?B?VUN4ZEtucUREa2s5L1BrMVFlV0JGL3piTitHWC9qNlBBWFRhMEFEaUZTalpE?=
 =?utf-8?B?M0xybEdKRWY1ZXVMS1Q0aDY1dVV6QzlEQ1BLOVBFMXZpQ05aSUNQNDFDZ08z?=
 =?utf-8?B?Y1BCMkVqYlNVaEZ0dzJoL1h6ZWJkZ3FiVUJCRFc2RVNMcDdUWG9mVUtYWUVq?=
 =?utf-8?B?ZTNkakNtRkg2UHBEaWpneU9KUFlQemdFS1ltbXVWYVlBbUVUTDJCclY4aU5z?=
 =?utf-8?B?ZzBRU0ZKUi9lbEsvSFMreWU4VFRQekNXTzJob2lBNmVlOWFlMHBLNzZ3YWR1?=
 =?utf-8?B?eVltUkJqV0pPNzY0enVKRGNWY0MrQkpDcHdUYy9zem5Sbm9xZVljZXo3YmdL?=
 =?utf-8?B?R1c3MW9wcGpmTUFyOFF2eWNjTTBBdkhHWW5pcFd0V2hHNDY4Ry9scUtacTBQ?=
 =?utf-8?B?WjBNNVhNNzN5MVluOFpGNUVDRnRFUUxJSGF4cHBQK25iYm9YWlpSNUxwRzFV?=
 =?utf-8?B?WmM4ZFNrVzlCWlNWdjVIR3g0bHhqSGRFbi9OaVZuZnEwOHJKcTFwMmJuSXVP?=
 =?utf-8?B?eXEzSlplYlV0eTVKNXlzWFF5aHkxMzFiUmsxMDMzWnhNakJIVFlHRkttWVly?=
 =?utf-8?B?TE9uWkl5Y2Q2QUI4eW1lTXlnenVxR0N2Q1RLSDBPWmpsdzUyUXlERzI1MmNk?=
 =?utf-8?B?c2tEUXZFWHRFMWErZEJNcmZOSmR2MzlTODlEd0NSYU5xNzRTVVdIcEs4UlZS?=
 =?utf-8?B?OXUxb3hCdUdwWmg4NENXVDlTaDNDUXNiOXdrOUMyMk5KMmtTZ0YrNVVudTJu?=
 =?utf-8?B?aVh2dEF2UFlyQkVQd0F3RXJGYzFXSm4xcHhQRy9OWWlTZHBQcGhjR0t6Ulky?=
 =?utf-8?B?VDM4aEhMVDQ2Ym12SDJqWE5wUHh4Q0w1QUhzMmR6WXg4NlY2N0JWM3YzUkZ3?=
 =?utf-8?B?VFkwUmxGWUJWK3Bnd29QZU9VSGtiV3JmV1Q0VHhuM2tHeG9yWFVwMituWVpR?=
 =?utf-8?B?SkJvS2k4Z3dkRTFLM01TUy92amF2dS9rL2JYOEd2WWNYS3hoREYzNG51T2JR?=
 =?utf-8?B?UWpjVUJqaUR3WDRycnh0VzM0ZENtTU9ISkl4Y3NFbDVsWGduSVU4cTVpZElj?=
 =?utf-8?B?ZjB3ZlQxZWlINmw1Skx2UG45ZEEvMldTZW14WEFGT0JDQkY0WHdGcE9COVhY?=
 =?utf-8?B?d1A4alU4ZGFVRzFPQ2hRVWFESEN5clB2NVhPT1VXbUpPbUZ1bjFuN2JqZWpu?=
 =?utf-8?B?WGI3TVVwSXZadmZuWHFabEkwVnZoQVRsZFB6bVpoOHNGUCtyN3V6ZzVmVlBC?=
 =?utf-8?B?RFZXY1Q4OENWZ1BHQXkyc2FTNGhaVDIwV3dkdFYyL1NqVnpYYXhycTNGL0Rz?=
 =?utf-8?B?aEIvSVFkNzc1SDA0eUNQSHAxSU1xUTFWNlovelZTdEx5c1RWYW9nbi9aM1hI?=
 =?utf-8?B?aHJINlU2WWJEdXZHbGpISFhjd0lvOERXTlNpaFpSdVBkT0IzYXg2ejhBenkv?=
 =?utf-8?B?YS9FRXFmVUJBc1haWlhnd3pBZlBwSmJRbExpTk1CaFJId3lWYzNhenlqOEdz?=
 =?utf-8?B?WU9EUVZlWENSamlGTnBZRGVmUFhvRFAxWXFXVkR4amRGOWJ0emR3YWlJalVm?=
 =?utf-8?B?UjRXeGFOa2xhZEpBN21DSi94bDdKVkRLQkEra3pjeHVkUjR3SytrSXdFS2Y5?=
 =?utf-8?B?eEJWTGxyOWpKTmQ5L3ZnK2VkRnVZQzJGUXllV3AvZ1hlL20wTG0raDh1RXJ3?=
 =?utf-8?B?N25UV3o3S05sS1NGS1BHcWxmRUxnYXJUM0ZBODFyVmF1Q2RQdWRFRUoybVNU?=
 =?utf-8?B?SVdXWUlTR21OTHN1MFdiVFRvcUQweUFYZ0xhak5HNGpEZ1QrSmd6K2RqbWdU?=
 =?utf-8?B?MzVnbnZvQ2M0ZXNKcm0zQTZLYiswUnNqQW5lS1hyQ0lCemxjdm9XT2FyMkta?=
 =?utf-8?B?TUZzeGRmZGtab09OSGFSbXJTWS9kQlZlanJWenhoaW1KVFdPMnRLdjl4bmlG?=
 =?utf-8?Q?8zWcHIyH2yrPRGiuaf9WSr84PbyReZmNM+jAdHsskKvw?=
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
	zUTIiBmJqusIMdXxQtvyfyIa9x9Yx1NB2V4v3xAgy88xF3/hdLCdhqFCyCa18ZRtug+S2cc8z39jgewKsBX3aCExF8nwsJKVx34KF3QK9judP+3mP/7IETU4rdUbCIxN+su9TGc+spYVbTUcRCibEBc52DiGc/NYD7rgrrSf/YXwVJBsjlDWRjlJVxsQ7vOFfFiRijKnnuW2eHp0d/VFbyaFTWsLxjh3SuHVVJ4UzCjJTueSU8nov75EpJpWI4yc7sHFfU1j209s7ftpGWRZ4KUVkTHEnqPcLD1luvuA1MMY6eFros7aebS8kyQK14WpQJlLdbIyjKGi5sJluXlJ2/2Ag2pOs5aCGhy4wZ1CpzlU707pdwuTHBFlzDvo2PS4eO8S4LLIWHkpr5cQ/QD3QK1FNWRIOVNs2FMJzfRxz4UXO10dGnM/ejJtmqwntMQken0KT/GwiXizGk1bRcht2+yL+W5gbZK73ZMKT9snnQUjvqCQ3IfcCZGH6cAGk9sBtuOOOk6HOnaQRp1Zc4SeuzgXFB5+ECtXpLFvFyCmQ9uxe3UHPPCO/nSgWMqO++ZCkfsnucK5BoF0JZax2KvqLyFIQKA8kloRKPXm/3MnR++Dnfd+OEU7Slvl2bpCFeGE
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79577e8-f8a3-4372-7616-08dd46185839
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2025 19:07:32.9434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3aniU8nifEQenKCIMxuMMJJtwcju5AjAhQ0SGp0szZG8Tizg63dYfbdNpJTPPUFa4T/CpDz/7lAgAdCpLUXtyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7136

PiBPbiAyLzQvMjUgNjozMSBBTSwgQXZyaSBBbHRtYW4gd3JvdGU6DQo+ID4gK3N0YXRpYyBzc2l6
ZV90IGNyaXRpY2FsX2hlYWx0aF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIs
IGNoYXINCj4gPiArKmJ1Zikgew0KPiA+ICsgICAgIHN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZf
Z2V0X2RydmRhdGEoZGV2KTsNCj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIHN5c2ZzX2VtaXQoYnVm
LCAiJWRcbiIsIGhiYS0+ZGV2X2luZm8uY3JpdGljYWxfaGVhbHRoKTsgfQ0KPiANCj4gSGkgQXZy
aSwNCj4gDQo+IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCB0aGUgVUZTIDQuMSBzdGFuZGFyZCBz
dXBwb3J0cyByZXBvcnRpbmcgYSBjcml0aWNhbA0KPiBoZWFsdGggZXZlbnQgcmVwZWF0ZWRseSB3
aGlsZSB0aGlzIHBhdGNoIGRvZXMgbm90IGFsbG93IHVzZXJzIHRvIGZpZ3VyZSBvdXQNCj4gd2hl
dGhlciBhIGNyaXRpY2FsIGV2ZW50IGhhcyBiZWVuIHJlcG9ydGVkIG9uY2Ugb3IgcmVwZWF0ZWRs
eS4gSGFzIGl0IGJlZW4NCj4gY29uc2lkZXJlZCB0byByZXBvcnQgdGhlIG51bWJlciBvZiB0aW1l
cyBhIGNyaXRpY2FsIGhlYWx0aCBldmVudCBoYXMgYmVlbg0KPiByZXBvcnRlZCBieSBhIFVGUyBk
ZXZpY2UgaW5zdGVhZCBvZiBvbmx5IG9uZSBiaXQgb2YgaW5mb3JtYXRpb24/DQpEb25lLg0KDQpU
aGFua3MsDQpBdnJpDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
