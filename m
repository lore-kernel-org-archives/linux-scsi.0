Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20542B9B4;
	Tue, 29 Oct 2024 05:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730180449; cv=fail; b=uevr0nQysVE8q+tJyZ1pG5ONoBkBum0Ka33AURWvbQHvh5Y9ISMPxhuJLNEkZwmMkMJpODG2tBjqrcJEFO0FyRw8EkOoJtmgkRnhuDgGl9JglZ26nKz4ophJs6AglXjyu/PSSknPxJ7mGdHJlXOi2FP3rKfPRfMNffjt3w5oe7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730180449; c=relaxed/simple;
	bh=sl1UJwRqexWm/5z466fhEI/mWHHi6OxeA5iO6jSbW9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k/Q+azgUZwBrJ6ryjocxgNJSIQSUaCniBu0+6sOu5SbZom/PwALgKpI81If38sZzx/kKFIrknF1r25PXYs3DE2H6al6JgIfICSsywyyk0d7wQtozatEmUYjdqH7Z0Gy2FEBoIph5T9TDOhrg5XOMa24wolpgEPqe2G8K6shC2k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=EFGMyYpx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=xZjqKy3b; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EFGMyYpx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xZjqKy3b"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730180447; x=1761716447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sl1UJwRqexWm/5z466fhEI/mWHHi6OxeA5iO6jSbW9E=;
  b=EFGMyYpxMKll8cN5RQ8dKTwdfb2MSYann5CrIJGBpmo2fL9WHOYSbZ1O
   ToslKOu6v29sTA03P8lEFRFJzoR1b4i5BeWOaXjfB+8ruc17mwJAo8uoN
   hSgUQS2f5TpiH9I/Sh1pj5rgDig6GC23YYpla/tQkjULn6rbovDkY0y4P
   wyYetVcKxLViqoFkRSCJudkIV2+BDddjl7m3qoJfIQf9DGIgCf/Sg2fvT
   AnKH/xlfCSZwVlVcwn3BCtumXkYASKsscmUPudASrK5Us8ZX4hyOpw7Gh
   4d2IDB6jJM3h74pJfVEBuZ8tNR73q/4sBcpttSjz9D8GnbWZYE3Sjt9sx
   A==;
X-CSE-ConnectionGUID: 8vVeLuPAT7GYcDx0TaZHww==
X-CSE-MsgGUID: OP7dvwu9QBiYwhqwuk9YPg==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="30593575"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 13:40:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e1ely6AOXeTGc0m0WdbGJr807r4oYOfTZR1BEmWiYHlUcfQmPD0nji5WxDoAVh0JF3CuvoASuua44x891IaH+3uDB+b6W62doG9fsiQ8MFZhbNRrjlNqhfeu/UC/KGVpLYaIk16Si576XGMYYsk1RjFn3icwYzA/3y6sWFEfRdhSkMIk8VEwD3UmsTZjGM6yTPBsCko0uWxUZ5Fnqv0J41ha8NyxMg5h6O5aVZUNNOMCisbeY79ilb5k6WIB89S+AT5yV/IvrRidMVfYHnhF9uHJFRpDhhu64TuOHcsCgjywh8SZV6rfz+L0dXgIS97h/MjBU6s+SvlMgYMJuXqNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sl1UJwRqexWm/5z466fhEI/mWHHi6OxeA5iO6jSbW9E=;
 b=yt3HmC9TU31RWdW4mqiwX4NTf2m6bmKCnsFWfQfWj2fdaeoCRithpLW7aWloG/e+B71FJRlZybutQzEoRZnEj5a6fsMKa8tZ6cxUZIhA9ofrK93aqSSf1A+IQF/oMuQqbpdVqxZXcnowvWLyTYx+g16jYRMUqIWYYBlcMgtta2KNDVsuA4vghSvbQ5yxfN8Vi2jwcoqix8uby31ay3Y28tMEv2rp6SlvdNu2xr13ze6vxumokH0E2dfQvVpuSvvvK7Lx9cNrSBiY/Ymh0v8kOFAu3EupKm4dF/bYN8owymFSf3nRMClTYEYeS6w/Zimsa+VndfgSa3L8RVtYIBomDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sl1UJwRqexWm/5z466fhEI/mWHHi6OxeA5iO6jSbW9E=;
 b=xZjqKy3bZNGNgA4G39RVUYfVXD93PpisERBQaDWqZ6Qc/+y0IldT3ef6maf93wRxuoN0KzHY11KEQpnI4ofq3Nerac7rseWtijBR8rMPZiJS+mtAN5Pu7y3Q6cPVXsiL/0DzqEBvdl4NXpMxXZV16qzzvslkqHC+vpr0owJYoy0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH0PR04MB8084.namprd04.prod.outlook.com (2603:10b6:610:f0::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.25; Tue, 29 Oct 2024 05:40:45 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%7]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 05:40:45 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: ufs: core: Introduce a new clock_scaling lock
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Introduce a new clock_scaling lock
Thread-Index: AQHbKEobF/Az3YRcnkGML2HdBqFSbbKcmUaAgACgOdA=
Date: Tue, 29 Oct 2024 05:40:44 +0000
Message-ID:
 <DM6PR04MB65758032F229BCDBD7CF1216FC4B2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20241027082519.576869-1-avri.altman@wdc.com>
 <20241027082519.576869-3-avri.altman@wdc.com>
 <e3defca3-dd73-4260-b18b-522b8ca38201@acm.org>
In-Reply-To: <e3defca3-dd73-4260-b18b-522b8ca38201@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CH0PR04MB8084:EE_
x-ms-office365-filtering-correlation-id: 543065c6-dcda-49c8-b450-08dcf7dc3bd0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QlZMNlFoNnY2U3JkK0JLQ2luc2QvYUpwdGV5RW1zYUs5Vk0weUNKZFVFaXFB?=
 =?utf-8?B?bEZjSUdWY1VHZytvWVA1SFFta29yNXVjSllmRWFVQnorS0FqS0d0cldoOVRQ?=
 =?utf-8?B?VnFlZElwOGh5RnV0YnNPdWFLeEVXaktEbTJMSzZ1U0g0dzFYN29sTFVMWTM4?=
 =?utf-8?B?UlFWOXY1cG1jSUFRZ2p4RUtTS2pPMzZmeWkvQ0haR0FCM2R6M2JzZWc2eDhn?=
 =?utf-8?B?eG9kazA3UXVhSmYrcUJkTjFqWkR3dWdNVDVjeTVxcFZIWjlsUGovcmovTWY5?=
 =?utf-8?B?YklSVit4UDJrT2dvVzBLb2tMQThSQ0RtWW5oZmJ0YkdUQ0sxQTJNWXNtZ3Nk?=
 =?utf-8?B?RVp6Z3ZoNXZqRjgwVU1RdG9wK0V3RHJiVlBDWkVXMFZBeXp2V0tlTjdQZXFC?=
 =?utf-8?B?UURQeDZlb2JxR1hPZVFQc3RlSmtZUXUwS09RU3VlODJjOWZpNGFZNkZpZGkr?=
 =?utf-8?B?WC83eTUzYWRmWGhnSlFrVWhvM3FudzVGK0oxMVRNZ2FEVGh6TUlVOFV2ZlVv?=
 =?utf-8?B?eGlUaWZmb3hPcFZqTTlDTjZERUdURlRINFdQUDJSWjJlR2dqNExXaUR6L2o1?=
 =?utf-8?B?NDBBclVvY1BVak8wSG5yK0JseUxZQXZzaE1remJPQ1NPcFJyNVNLOGtvT1dW?=
 =?utf-8?B?SEFvZWg0a3BWWUVuKzVLWFpiWEU0RkxCQjF5TVJPMmVjSFZCWjAzNmMwUUVj?=
 =?utf-8?B?MGRUclVHT1FHeHRNQlpQU3NZbjZuK0NRekpoVU12eEJQMEIveU5LU3M4MlhJ?=
 =?utf-8?B?Mng2SDZVeEw5RkFDRjRSeUcrY0FNemw3U0pDZUxLK0V6Ym8yMWx0bnYvcndU?=
 =?utf-8?B?VkJOMzVUVTIwbTJWbW9FcUxkcUlISkxjc0c0SFZkOFVPZ24yVHlTS0VrNnlK?=
 =?utf-8?B?eGtIUGNveENGOXJTS3Z6cFRIVEFqaXVBaXErMmlkN2NHS1dOZWw0MFNWWkdp?=
 =?utf-8?B?RzIzMzBuTDBTY0ZYOG1HY0JVVFl1N3FmN0ttUVhEOVRsdXZRbkJaMzRXV0gx?=
 =?utf-8?B?VThxZzI0Y0ZjSFFhb2V5cEFZd0N3aFhyYzdKaC9tUlkzTm5wSGsxRkY0WDg5?=
 =?utf-8?B?NlVBekdDdWNFQmJwM3dTSGZGeW01TU5hTzd5WTRqaFJEMkpmYVhhSXl2L0Vr?=
 =?utf-8?B?dFRCeGVScnJrSVlPWDBnQUY1MHBHSWdwUGM0KzZiajJtM0lWNGhDeEpBUm84?=
 =?utf-8?B?eG1DSE1XaW5mSmJScGVTdHRyS0NpSEowb0xTaldERUZSSURra1NBMEZLMEtn?=
 =?utf-8?B?RTkyL3F3dzl5OHJ5OEN1UlhjTTB3MFRwN1JXenlRcWJBRWd6YWM0SkZKSzdr?=
 =?utf-8?B?ckNpdGRybGVKdEpWdDI3UzZnczQ2cWdUU1h0Y3IxUXI0UnJKemZIYm9YUXpL?=
 =?utf-8?B?VnhmbFFmdElmTC9ZYVZGMTdEV054UVc2V1hISmNMNzhGcFU2Z3ZobyttNWph?=
 =?utf-8?B?eUJIUlZnNU5kbEtreFlUVXN3STc5ZFIvdVNZRGNNQmFwdndldGdQdUdRZEIy?=
 =?utf-8?B?Y0RoTjMzczdDQkRlVEVoYm80SG9nZ2toMGMzR3NqZXVKQXZLcXNHSGovMUhp?=
 =?utf-8?B?R3VRakV3R2x2OXc0NExTQXVnT0MvMEh3YzkwTnNCMTRwZXNSeG5ROGdHdFhO?=
 =?utf-8?B?R3M0QkxyWnZTYlV4Wkpha0VGYnQ3K05BZnJoekFCdml5Z2lHamV2aCtvRUhS?=
 =?utf-8?B?dE9BdVcwd1ZleGtSZU9nVVBnbGZiZ21zRUdLeXBHMzdGUFRUMkQzbGJldk1v?=
 =?utf-8?B?RW9uaC9NdjhOYVBDMEdJdkNEZ3pvSkl5ZE5ud3hyZUdUeTNUUUlpeCtPRmE0?=
 =?utf-8?Q?Av0sjP/RmHwPzxXhuvVwwFpoPCYF09n0R+LFs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UjJGRXBvaktLcDBoZHM5UmVBZjV0RW93RVd1VVM5eVU4ZDl2RWtXVGVWSW94?=
 =?utf-8?B?WDlPNjVHakQxT1dxVm41bjRPeVMvWFd1TjdzWGNpWmFieU1SeDdibEgweVhN?=
 =?utf-8?B?YURhc1pSdkhMdUo1MW9Yck53ejA4akVLczd1Rjh6eExsNlV0UnhXdzFkSmhV?=
 =?utf-8?B?MnVKT25jM1RGQmxTYS9DT2RWWlk3Q2FacUEzVXVTRUtpZmNaeVdSclhmQ2pj?=
 =?utf-8?B?V3p5OFg1d3V0VnJpSkRJT2cyWjJWcjNQU2xzeWZmcU5uUzlqT0JwVlRwWndB?=
 =?utf-8?B?d21HNm9WWm1wakg2c0VyY01QWGJYWUd6R1g2OG5URmZFYlhseU11dFdCMVdh?=
 =?utf-8?B?WVVGNzdDMytWZExUUng1OGRxTzdxc2xDSGVqMUk1WlJtVjE1VjA5c1pFdlVs?=
 =?utf-8?B?OUVtcEFWQmRHSVJzbVM0S1l6K3V4ZlhtcWYwU1JRMG51Wk40eVg5WnRKelZl?=
 =?utf-8?B?d3EwVjgvbzJueGpVeFBEMUhCUXR0Z0YyUC9SL3pabGlKTEhFVmZ6Ry9IMENy?=
 =?utf-8?B?OWFDMk1kSG1tYUdxRHRZbncxNWtMNlU5cHBoOXY5MldlNFc5a0YvSlJVRHdm?=
 =?utf-8?B?SWtkVHdQUllBOGpwOGsrOTV0ZXZJek9mRVM3eHZWeUpnNTZhcWlXcE5aY3Z6?=
 =?utf-8?B?cTRtSGdDVWlJRCtPM1pxNGFVMFBkODZqWDYzZ0JFbldLR2JobVZLVUVxK3Jp?=
 =?utf-8?B?RThRMkNVMHpiZ1JyUEUzT0JoVjlRREpoVXl6RWRvY1lYYmswQ0d3WEM3NWFp?=
 =?utf-8?B?YjBGME5VWlVGOXlIR0JocENhczQ5MTU3ZXdoZjNjcnBiVGJCTXl3STNoK1FY?=
 =?utf-8?B?aHh4TWJXMzNNL3oxM0ZRaVQ4UDZuTFhqVXNDQVdiTy9IUDhhLzdjMklObk9m?=
 =?utf-8?B?WUtzUms0VjFwNWpmUHY4YjZDY3dJalc2L3lEK2o4M3lORzlPSEVwdGF2Um85?=
 =?utf-8?B?ZG8rc1QwWFdRU1RqL3diSTBIdTZZTUFYRVRncXFrSjkwSzRNWTlaZVhZeFBY?=
 =?utf-8?B?RlpYN3R1Z2pTZEV0NnVoT3JmcC90T0wzNGJ0SW8zcHV3L0JraVRMMVRFM0VE?=
 =?utf-8?B?aVR0enpZMklqQUlJVTA1L0cxcnVpQklpcjYzeWliclNDbHM3N29HZy9aS2VU?=
 =?utf-8?B?czBxdGFMVU8rVnpZL254NGNVL3NpM3p3dUhFQlBFdkp5RWJHbEJZbjZFdFJk?=
 =?utf-8?B?UTgwZk5YRnpraHBIaEt1SFMvV3RYeVBjTlFIeUZIL093eVM4S2E3aWhSQnFS?=
 =?utf-8?B?RG81aUw2YXZtYWVIRGtHb3Q1VC9JaWkxWDBCK2VpLzNMTXpTWkdQQWVPZXp4?=
 =?utf-8?B?dm1oZFhMZEpyUEY5ajRudmJCZnVxa2FSVlQycm9LaldCbGpRb3lzL2NkM2hW?=
 =?utf-8?B?czF3RzFDbFdybDVnbVJrRGozMjlFY1BUMDNRMVFIYkx2OGFRVmRvL0JrdmtB?=
 =?utf-8?B?cTVBMHJMUG5QSkw0cVV6elRxUjVhSlhvd01hZURWQnVSWWVsamVNOEJjOS9D?=
 =?utf-8?B?OEpIVXFBTm1IWEc4K2lBVnRZKzNBWjYyd1lsYTNRNGROZDNscWxPSVk2Rncx?=
 =?utf-8?B?SnMzNTZsUTRjTXhBU2gyRjh0QVVvVWxrMHZMeDg0cjNLRGNyUUxPVnR2a1dv?=
 =?utf-8?B?TWF1UlpvdWpaUjFqakF6OVYyUFhFUFZlMCtrTGROc2c3M1EwY1RwQlVhR3F0?=
 =?utf-8?B?SWwzWk5wd1lneFQ3dXg5L2l3R1FML0d4K1NUTVFyWU9ZVHFoUWpOWVVLcTRl?=
 =?utf-8?B?RU5zaDE1UmNrMG9EbG9TdW92RWNSU04xbVpNNExweWs1TTJaQkpPb1kwRWp2?=
 =?utf-8?B?Ukt5bGo4QjJRRFpUdnhJUDVFdnhxaUsyb3RZRzlQbmthOXdKcjhFY0YraE5u?=
 =?utf-8?B?OWtySk9NcXY3UHlYWEovYlFiWmxFSU9UZ05aTnU0TVRaQmRzaFp6TGw4Q1pj?=
 =?utf-8?B?ODMwQkxCbCtQRWNIVG5rTDNmQUsvc3U1L1cvdGVBeVFxcjVUYjlRa1RzT3F2?=
 =?utf-8?B?cllwaHNFTXJ2VkUrM2dKMk0xNEtuSEVuc0NpUUFyRUFpaWZzZ1JBcy94OWhO?=
 =?utf-8?B?KzF4V1h3cnMxK1dOZHU4NjQrSnhGaGg2SlQrMWZMZ1JIMFdKNzFHeTlnNFFs?=
 =?utf-8?Q?VQNr7kSSBkMr3Pdz3cJUh0w7G?=
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
	avplYYr8PURHk97UxWhnIhl/ckQ3OBec9QHIM3881l6+RiWaSbT606eSZD9sDhald0q1THl/UQFMG+YgbpAcTxw0At5OdbF64cvaRc+2QpYrfSvb+qKBKrEgEWYgiIub+ZoPBgF9Ed0LxHW01rULhEJh/mZdkqvco/Ib401X4E84c8OnKLgRNmXr3VkxTIs2GDzbzo+OSoSSGNVOJ3K9Zd/rT9QV1v2dyl0nzna13eNCpe6hjoGIba+M6+coY36lfHfj4IaS8hcKNfYk4wbazhf1Q4zZ/zF2vJdvosLLpyTaVYVx6xgJzxR9kw7c+mO9cLW+e2XLvAj6ZSAIjzoHyYte1PI/KduDNMmPqIMpRhP/FTVWjdvQ8Vt4JaFWsBI3KoDGxUxphAvzook0qTHl3A6X8HIBRq4I0UBbrwJXs+ULgIoLAB50bsfjMJW7wz8XnPfeGeRPWnPpOTyZzj3M2EzTq86j/rhstw4DuwYuK5j3zf1omzfI1C2mJFcEHHYrKmjtOvxLEYT2HIE1drhO7vNxi/6NLEXO4xM+Kwqpez/VDe1tmCifNJ/TNWurSYD8NBlDjHASNY/P2gPkEUwvbr4CzeU9QSezLH4Eb3YgVoawcgyCR4B2fzqf6V+ni8wC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 543065c6-dcda-49c8-b450-08dcf7dc3bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 05:40:44.7845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9J3kvwYIxGEjObqpirRUpsCXneMcKSBjgytdjpqjJfOV7QZzh7b04HtR4GWtx5xVAWd4XNHVQYWl5OFakPdQUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8084

PiBPbiAxMC8yNy8yNCAxOjI1IEFNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBJbnRyb2R1Y2Ug
YSBuZXcgY2xvY2sgZ2F0aW5nIGxvY2sgdG8gc2VyaWxpYXplIGFjY2VzcyB0byB0aGUgY2xvY2sN
Cj4gPiBzY2FsaW5nIG1lbWJlcnMgaW5zdGVhZCBvZiB0aGUgaG9zdF9sb2NrLg0KPiANCj4gU2Ft
ZSBmZWVkYmFjayBhcyBmb3IgdGhlIHByZXZpb3VzIHBhdGNoOiBwbGVhc2UgZml4IHRoZSBzcGVs
bGluZyBvZiAic2VyaWxpYXplIiwNCj4gcGxlYXNlIHVzZSBndWFyZCgpIGFuZCBzY29wZWRfZ3Vh
cmQoKSB3aGVyZSBhcHByb3ByaWF0ZSBhbmQgcGxlYXNlDQo+IHJlb3JkZXIgdGhlIG1lbWJlcnMg
b2Ygc3RydWN0IHVmc19jbGtfc2NhbGluZy4NCkRvbmUuDQoNClRoYW5rcywNCkF2cmkNCg0KPiAN
Cj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
