Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAA71411E2;
	Mon,  8 Apr 2024 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590966; cv=fail; b=hWVPvtnIM/EOR04qRSBVnOobW0XZisWqJkcoPpuMemI1DizxvELaIOWRQfXaB9arwM5QxanEjB77bueerFAYND+clUbklq6lRH1wFNdCfESRjnMj+pgm74Mmhr4wvA0wsrc9QpS/SDFhsi1tUd1fb0NKS4YvjFVJeR8lcCFX9B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590966; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ji4ki3Pq8sMdT0PaTrStg39+ADrwm2e409fSpT7c/xQpSLzTtSn7tgp2Tmp7Cm89NC2Z8uOx1enXvu5qNF1S6vuWlXiDTV9p1onFrlPO34KiS5+ceZbo0ZahenC5HNPofelNH8OqtW3MNxukIJugmVdMb8HRxX835+bUreXLUig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZQffY83T; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=BT+uHCwP; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZQffY83T";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BT+uHCwP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712590963; x=1744126963;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=ZQffY83TllRV6sDzU/+vhUmoyAP8hKApaA4k1QaZpVIFrbimyweRIeuh
   G10O7wZUhshfWgpzYszjhVOOaTlkxvxpGATctMpXyDSRoUwq4eMEWdwvl
   AobTLaX5T4YLpH5hE7VieCUoX01ptwyIUhv8wpwz3gjEO115rjMSKRTW9
   i9xvxb+fRKREVIbkmi1jHdYfXxiVz0UncSHDSiIk1dlFnAqmWs2KeOQCF
   zpwKAB4Ahh/LOMqcZLYBUSAo0MP/LwFW3TzKGeXUa5jkw1SEy2SfWHr1+
   Pvn+V6kXjuqnQLfziiIIuRG39qLbt1cREmjrg7tb3MvP/7sSHQwId4tIw
   g==;
X-CSE-ConnectionGUID: w4XmJb8yQRSem0s+r0gXCw==
X-CSE-MsgGUID: RDRb9cIgR7mdWSfYP5NZuA==
X-IronPort-AV: E=Sophos;i="6.07,187,1708358400"; 
   d="scan'208";a="13521274"
Received: from mail-southcentralusazlp17010000.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.0])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2024 23:42:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiO/Y452ZNNzIlNA22q/V2wxxfcMkUG0DgY9BRDmIvuwI+ZUKesY+MR/G4T1XJT6ormc0Jrq6MNmh7CXvv/OneJLAGATt9GyerPvx2cgXbsFMa4qXk36pFVSr89KL4ZtH5hBuAS8adXApJBn4Zo95F0VhI8oPRC1TfxGEMJtFdOUvVsfuJDtBukwoOZjFk8y2krTkU5YcrrAP1R0ZfP0oGTXir/UIB5vg1yaAUcuIzmKsnBLD/SiQd1+pRaYSKbRwTExDOpTyIpBsCd5xWGFAlU4q8ldn7XMWeCdr/SeTqsAVi0yrOgZhcx4lEaY1dkoHVetxtJLJbXTIy7mWLYuAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=bL0bwU0Hxn0m+8CeLXyWcI1zbp8Y5W6gKZGyZ7niNr5OLa0j6rliAz01f7nyyEbumfHnj7ZR9mZeFmgwaAvEV9N0nUwOpYyvJlKq42mbnFRl2lllo202V3O/FCcvwB+ClixZA9X9CNu9PwEuPWTWyByNycxAntzqGFt5iOEr+vePjizVn1RW1f3gyDNbzr26LsxhTEzUrKDAJKe/bTetpgl0mb3MuYMDfuiPL5+pPbmV/R6FOmCTAT9+sawFa2GmzasYpyG00ua/ILWXhxjIoKq41f4njSRhspLqanqR1AISWfBJ6e4/57GnNDdTmPRA+MRuLa+EsqSCup0C/ntABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=BT+uHCwP94qP9hyma09DFlz6WfsMvEEKRw97Jm8X7wOrfb+GmH9nD64NmiCbBEbtTmAPGrZyqyCv/ZQV8QdHshW0G41dS196dchLw/uB956mhfNXp6l/1VgfLyFu24e1EtV3MyVtbFmOAPq+y+oRGeMJnLnNlUE9cz18XXNVoE0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6680.namprd04.prod.outlook.com (2603:10b6:610:93::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Mon, 8 Apr
 2024 15:42:32 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 15:42:32 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 01/28] block: Restore sector of flush requests
Thread-Topic: [PATCH v7 01/28] block: Restore sector of flush requests
Thread-Index: AQHaiVXunQUeE+LqvEq+gdT0eEyuDrFehBCA
Date: Mon, 8 Apr 2024 15:42:32 +0000
Message-ID: <88c24f83-9b6d-4742-94d1-56131e1358e8@wdc.com>
References: <20240408014128.205141-1-dlemoal@kernel.org>
 <20240408014128.205141-2-dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-2-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6680:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 HBLv6K3woDJx8T/NuwqVlsO7EIDzFir0Y00kM4fhr5t1B0lT8JdkZtWQAcfRhnlSW9O0BSC3cIGvBPtOSk6nl2dUvHe1JPfVKzJYgGecrt7+4Itj9MnpSrUVcutsxMrt/K0zkUd5TEHMtVWnsg+cXUN2fGOpwJAPq3z1enfTH+hymvRo7cnL79UTTH8FvRq6wOXE5UujvHq7nW6Qpuo+VudEtqe9Bs/wDU5RqiaJWzGVb2/X9D6w462ItMUOwcjGAlzKPSZFU27s/NwG0M6/u2FqkGSviDrqq0VTXLlG6jndZrZtmqGp0YoNcFJW2dBPjRzmie31rNYM8WCCdBHbryZ+VlAWageOtYcjyOzV+B99zLFVokfazD3jlBrX5IfJ4fHkjC3KCN32uVHaXfpchMiI4yA8k6tX/I+EkF90v/tRhKyFSQK9K7rh/s0B8vwHtq9kjUnkH1IIgJ1nnRgAX4MQbBB8GC1pmDskO2HNFCUiauG2O/bXgHBHtDT21qYbE188qcPR+5ISDCe8e36oidp8xVnWg3CjV823CSmDmCUrmjB3AvC+PAOgkdxTBaV344Rosjni1+YHfk5IfVUAy09dMHKcUIP3pj3c8kXwHn1A80PL+Wc3yGsVW4NWqPQlMMFA/or7zm/odc5QW7FBWZlsrqKtdOl6OPOBXPP5dWi8hYFwAywE8q+3I1Z2Rdibn2ftLCVTAbZieYZ5NIx/6A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T2lLUGY4UE5mTGVnUHlUWUQvZjZid00wNGJBT25vckNOdndLU1hFdUczWVNk?=
 =?utf-8?B?d1NtQmFyWTFoZGc3OFhieUIwSUpIT2Z5ay9IcFZrdFRqYnZCN3YyTUpZTkJv?=
 =?utf-8?B?M1dTa0VtQzJycDVFaXd1cGdTYXlWbG9iVUpDUmdOdTlSaTBtV3lVaUcrYlgv?=
 =?utf-8?B?STA4NThKbnc4WFd5YlFqSjQxZ01xQjNmZVlEb1dNZTJCd3hVL2R3SjdwTTFw?=
 =?utf-8?B?cXE1OHIrdzNzK2dTTnh4TExLcGVGRkFONDg1bGNsZG1CT1I1LzZJZEE1RjZx?=
 =?utf-8?B?ejhpZmV4TUNZZHJsNnRMNTJabFk4Sm9PM0RjTFhCck5SNUZWd2g3WVI4WXZN?=
 =?utf-8?B?cnllclY5dkpFVHFGT1JWVGdweEY0WXI2bjlwTmcxL1pCN1F4Y1FGVzFqdHNw?=
 =?utf-8?B?MlFtTWZwVDdPWHNkNXl6eWkxblh3VVJNa09SVlBITGZpdklneVh5aThZMU1P?=
 =?utf-8?B?UVRGamRYeVV3ZnhNUklaRHlpL1Q1NTZHQW1naTZpcGhra3JrcmJYb2w4Y3pO?=
 =?utf-8?B?cytkdjRoWE1CZFZqK1ZkRno0OGFRR1BGK1kzQzgyTGI4c3Exb29yd2V4SGV2?=
 =?utf-8?B?N3YwOWpvTXNRNmFWT1N4YXM5SVdqQ1QzL1hVWWtEVnZZZlVBSUM1bndnSW1B?=
 =?utf-8?B?R2VPbmVPMEhsM3dVMXhOc0lLM2xHYzc4Z2paY2JobnhLUjRmb1hVcTA1S2Vw?=
 =?utf-8?B?YklQZGxFWG93TTFTRGx3eEp5cVhMOUtuR0djaUUycVo2T1ZmNUZpVHhIaVRU?=
 =?utf-8?B?eTJsTnFiSElHZFRnZy9xY1M3NnowbFpVMUdqV0xnSEE3S3dndkZwOHdQd0VB?=
 =?utf-8?B?aFo4enJleWZNakpFNGJHb1VJRCtvKzhJOFA5NWtlT09XeUVXcnVPWGFDWGRt?=
 =?utf-8?B?YnVRMTJQS21DOStxVGFlVS8yMExtZFNNekEzZkV0VG10bXFoQlFpTHpsMnhX?=
 =?utf-8?B?NmdjSmZ0Wm91MXdZc1JmVUFsWkVqVUM3emZCM2JyZlRvaGJVNVJ6QUtWUkVC?=
 =?utf-8?B?Vno0ZUhEcTlXcHpXOEpudjZqQUtvdHNlQ0JWNTV4bGh5b0tZcXE1emlJS2kz?=
 =?utf-8?B?bWNTR0dvT01POVk0SnBCdTlwNStGMm5VRDNVL0pKRHkvQzZzWExpRmRhUmFW?=
 =?utf-8?B?bzBBRVFWRmRYclNkMVBmdFhnRzlWSFhWNTM4aXJSbDZ2NE5zY0szejVLOFE2?=
 =?utf-8?B?elJZZHRVS3d4SUtQaFUvQzgrNGpVR2NHa1FTMEFMTEJ4QVpXb2lzNllXWnhz?=
 =?utf-8?B?Y2ZpRW9aWUtQSG9Pajh4bE5WWmkwbEpNbUlONEdnMDV5NCtBSzVacWVKY3lx?=
 =?utf-8?B?OXp3LzRtbUYrRDdHTmZmK2R1TkNVWXBPUEtiTGw0UjYza05ZeVQ5Tld1eGND?=
 =?utf-8?B?UGFFSFlSbUhqbEtyd09FVTlXdUt1L3pscVprdWhaTk1BelloS0ZHQ2FUYW9T?=
 =?utf-8?B?ckpHVnJlYmVPS3VhTmZuZWhEZnFIREFFWXhuTUUxcVN3NiswM2R4RWVHNVJr?=
 =?utf-8?B?Vkc5MVJVVmJ4bGNjZjVMNUlWMkZZNFBNYkExeWVxeENFeGNqUDhhY1hxMkFW?=
 =?utf-8?B?SG5IQThHNkdsTlBWKzAycmxQakYvdk43SlB1YzBzT1plUXkwdmNBanRXVkNx?=
 =?utf-8?B?OHhucnRQSGN6c3o4ZHZmNGpJK1UvOTlRUEl4TnJzNjVmSG1ZUmxER2ZkZkc3?=
 =?utf-8?B?VE9ndmpTdkgrdXkzQm5NK3BsN0JHMzRYZXBUQnNOdGRHNHA4NUZ3S0RxVWhq?=
 =?utf-8?B?T0JJRDVBRVNFbXM3MHlPcXlKTW1ZSkVVUzI4NGhJNmVXRmVkSmpNN29hNVlQ?=
 =?utf-8?B?dS9Kd1JFTkt6bzRMbUxMODVQTWpsNDZOc3AxNEFPRmlQRTJaQ3ZZVmRRSXha?=
 =?utf-8?B?U0ZjSWhUVGxlVGR4R3FwSmVDNjFtQzRGQzYzUjR2b1BwR3ZubXRQVkdTbHNF?=
 =?utf-8?B?TXFCK0YySmdPWThXQXdJQjBBSzdtUzhCN3h4eGNna0NnVEVxV1l6NUFYSVRl?=
 =?utf-8?B?VnVBd0dTSTlyUFhnOEsyQXozYjFMV05HWHVQYy9BWEN2ckxqb0hHSDRNK3RU?=
 =?utf-8?B?U0pGV2I5WlBTTkRjbUFZZVZyanFTd1pGK1kzUGhHM3ZDclM0cCtFMEd0NTRC?=
 =?utf-8?B?RjJXbFFpd0tvaWZCcHYveWFMTGZXK2hUc2hEd2NVaSs0NE9RMkZJZnNWRlZ1?=
 =?utf-8?B?SWJXVmlidU8xTjhtU0VFdTNhRXFBMDZtWjVoQituL1pXbVUyVXdad0RWTWNM?=
 =?utf-8?B?a1Q2Wmd1RjJOaTFyR3NYbG5VTWhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACDCA9809495794FAF553B7872E6C4BC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IXUGkC4TppFCybbH/P3h/4j1uYcwUI60c3N+SsnZUbHIWo7gyiCKdhBZ/WunlXLCzIzlIHPxvosytfoyCHWZazhdm08XRt/VLeZrGnYXbwL0dAxCVMmtYp14k7LFCyzQyrf4Ath+4PlUqZ+FTBO8XQciv68skJN0taTJ9x9ZYljGJjyuaEGHSh7IDNIr5VMsKjlLp0o6VQF7FEMgYXUOeICbEJnV73dIpA6W/KjKV9yp2xaGC/XgyZTBpSdMbwHPscLh0bFDBj9fQ1ngPaDVKPIMlZlwYEOeOG9ohaojLYLzMeQdRcrTJQnorBc41FYoOzfCuxTvx/Zpd1jcR4Qg5gCnTQffba2pBrWlAxjVrMkCp1XBL3wjz09vS2OTxqN9+5snTHQRweIhvX1gfr3uN1aZ/ZkUgoZbXpYhSDEWjOygWDys5jqOOrPUpSZ4rVvIIypv/DsGZ+NLqUGS2X2/0AsKvojwzH2PL1cfv5gC/HK8dTJqKagyKsRPt2XQqwqdev2quz972EWMqObmx/aAKF0cpXmKRjqMcgf5en7Npw3yAhZxNLHbGj3kOsBPfBg6Y/jiRoktew8xyKz7aMQJp0xF85Np8yhzcBpau92eI1I1z9lMX2pmEk1jM5ZAUJFO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d6f7af-d446-4914-d8e1-08dc57e28135
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:42:32.1705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CzNvvtcsRcIdadfhqjui1F0goQB6id8D2i5AEFbEzCRsUsB/rcK5J+0636muZTgtVjw4UMaTNqjmSquMCJOoNwyO8aCu2wg4ZnnXxrxKfdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6680

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
