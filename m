Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC221420D4;
	Mon,  8 Apr 2024 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591425; cv=fail; b=eWoI3Zfu3J+QpQhfXkbduL4XmwCBVBMyJ6IlLyl3GhLTSvuPfLJcW5I+3AMoCGYSol4+GtnkwZ/CtcqVABfuBJ42zxaAxSHSi3Aqf5oT69q+gFHtlHzMNzBOxO1LStAkEzT4iFWHZhDJMW2/oY7NSFTe8Kk2DNzcyBiIwtTkeiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591425; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JOq0UIIi1K0uaoojErDVt8mu0TGiF1i3RiCAruSl1mGW4KOVFQPbT0BRXTjTtgsJw2hMZRMcvq+eN9KK/P7mW08JTuOzc0T+ZG8jzpflvF7b3aCQr1GL7aJ1im2QJyn9Uw/LezXNrv9OmqTqCEcsZrSLIlNLLUP8o2FtQSCScoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iT4+shuh; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=GsJy3UXf; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iT4+shuh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GsJy3UXf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712591423; x=1744127423;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=iT4+shuhijJk7F1X27oqOPQi6UJFVWKkWFWqhvSHzffGCuor0Lysr0JA
   gozklvBz6tGJLwp+B/4aiMmxUG7GhfFJoYYrRXH/PnzwmwpjTiyIa2m8i
   KWd8bDTvlI76Ksewfz5QUdeEsKtDGyaAd70KHpTEMox59m52FT3ORYJGT
   mYAzu2vfhi8z8YOb/FMWlm9GZkuD6KwWQ15/9hbA8vL4WvQKynTH3X//1
   nVn/MI/rxz1whUolOCE3VKcR59lPZlhJgF0YeZZTfULga//iYvhyCKwGi
   E9+pJz+KzrM7RiUTQZM/kXTHUar7ODuBNN3Hf+kgcOjwtN9xW4/zHmWVl
   g==;
X-CSE-ConnectionGUID: uebOHTqySQiXBEijrAZzOg==
X-CSE-MsgGUID: SItTRjV2Rnuav9ytCCixNA==
X-IronPort-AV: E=Sophos;i="6.07,187,1708358400"; 
   d="scan'208";a="13344497"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2024 23:50:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnvJvNsMQqmx1kFAMv5xN5Z4nTUnkRmUb2VvLap0sSysA0OyaPnx69PhVO086YtKec3hHi332FZ2sVWdtWGcAdOfYLadJ2MbBGmcAS8YiplX82ovo2wXRbX01H0BHoGmp54/exy/a/UPB8MztURfnRAKOEbM6SAOxpOCghI/UVe+D+vFF8Xi3/lckdqPlytBifFSRDRV/kG9bP/w1bZrd6bOhRPO/6nSrvCljVJA87HsUBaEKAkn9zbEOtMIsM48VBp/Z4eBPvaM9vArClOOwLviJEZfUBHsCvzYlAfcAGyfTLuXfc7vf7f87vtk95SCLgssczKRYNFeT61LVTk12w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=espvtvUBk4JSVrqnXuE0Ldbx//z/hWsQ6ghnuNnmqzhVZdYuDZlONYuSuOapZuld+4fkiBElK+HGQ7REGvXhOjeLngIxABn+JZrqw3FnqDEUhOL3iuZtXpVZvs4gPvbFGXXaqWh0uRYn5IGoUC3qS/bmi6ypEc/O3yHIpgWqGvOuK43N9MnwGRH4oVoOkjm+aDPXVk4bH45mRpFQRiAR5jUWuIwZw1rUx4GeRUyeUxhfwikatmGqLBPklw58bU+IiTYWeStwU5ulq6D/TyqTEKq0XNvKDSBXkl+ntd3KbcVocyy/xRUGimrKzw0u+z6nEZVUEk7TVN7ly7Twt8x6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=GsJy3UXf9VCCWHE6ax4pjlFr99L0HGDrAUFG8V09PWLrvdhIEO4Eju/JRJ4UkkyHy4wtxwtvKo7o9y3xHUesRqXKqtfUUDAgeRNHm3B0L20LxqbsSlBmYnSOk8a1DA8JcNsQ5cRr22qTsgwobkZYBHzwUUTW7h04UpgxDsCsl68=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SA2PR04MB7578.namprd04.prod.outlook.com (2603:10b6:806:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Mon, 8 Apr
 2024 15:50:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 15:50:18 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 04/28] block: Introduce bio_straddles_zones() and
 bio_offset_from_zone_start()
Thread-Topic: [PATCH v7 04/28] block: Introduce bio_straddles_zones() and
 bio_offset_from_zone_start()
Thread-Index: AQHaiVX6E4pt50PkA0WlSH7tHxKBOrFehjwA
Date: Mon, 8 Apr 2024 15:50:18 +0000
Message-ID: <4e2a3f7e-cc79-439f-b525-96b8f5806110@wdc.com>
References: <20240408014128.205141-1-dlemoal@kernel.org>
 <20240408014128.205141-5-dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-5-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SA2PR04MB7578:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 SajNQuh4OPJqtEwoTXRX+LPDqRmsUu6hu4/YopbnYmaoXlaf4u4EOpZHwXbGmOTaVD0mB+G/NwV9VUHllFZQoyvEROtHn9vcSVG0N76IOot7wCN7AoqXl7X9qBsgd2TjYwN8V2JHXSg/oZRDLYXiRAeLmPRxCath66goAyPar5mBTPAhDSPtgHBLwg/exeI8zeyJaIun/yqm9k5gDctbQAfkdi1VcjD4jyMwHmweTM3re1V7IqjJY7rNAloQWJhcgCmtU3o+qnnUuq1JQCoRUNOy+OU7pnAnqpFM4/qDLicWIg5n5b+l9NLZQ9gSIMQov4Auq0DgLuhdLO3IoiRS8+Jz8SaqzCRQ39K8C1/URutOnob3Xc3Rzidn2C4mFHAjAFGc9SaLQTWnWe1tG2dpwiqr4VmocXU2yfEQ11Cmy85JCTdXPATq+rnIfjz1ZmiXuehg6NPOYRhIXINDyj+3DiVrVqpcbvJwydqEMfFaRENBgmS565iDhtr043dq586HK9vWO5m2DSShyBcdeXTnI7YzbAX29YTmMqjUszIPSWE5F1He1TVo6q3z45t04+XO9zHNeEp5sLJZlcF4IyCF+W+w4bw5WwtTg4NPgzbgL/jT9rLmcQMHn68zIugA+ryPfV08dsrDIdJuihU+hyB+eqZWzyCO/6hO2Rm7hdpoqiaPwsP/oBC/QVcIzPN3JpTLYIgWZm6UufoOILRKzwoNPg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzhpTUZBQ3NQcm5YdmhLTFB1MjIwZFd4YnVickJDYWU3d3VTNURVU3JEbVBa?=
 =?utf-8?B?UkxZVHZlbW9KOE5yQlpCS3hzVllBalRJZnFPVlFvbVlIZmptSFR4Qi9RRTRO?=
 =?utf-8?B?b0NrMHRtV1pWcUhORkY3R2RLdGcrcTRZazV6WVJTUkRPa2djYW9kVm5uQjNz?=
 =?utf-8?B?dDhtUjlLV0ttTlRUVjhudTdmUG5TSmg0YTFBNXQzN2VpZ00xUnZOZCtXdlkz?=
 =?utf-8?B?ZTV1SUFFMnBGTDNmMVhRVmEzVm82TmZYdTdrVXQrRm1FTnJrcmwzRFl6SzFm?=
 =?utf-8?B?NXgrbWs4VjlYVzlSdDY3dThNUVNwUVNGeWVSNE1tMzVhN3FLVjVmVUQrRDNX?=
 =?utf-8?B?TVRQcWJ6Rmwwek9udC9FQjFaUnNxZkViWW50OXI2VTRNMFF6VFpSeU44QmRn?=
 =?utf-8?B?c01GdWxxNmhSRmoyMnExY25DSXgzNkZHcndLWGFJZWQ1OFZsa0FoWHovL2My?=
 =?utf-8?B?cWhmYVJQTnVYMnVjd3BqekF3U0FVVmhIdEpIbVhVWkgxS2preGRKMWtDalBR?=
 =?utf-8?B?UTc3N0Y3VlRuY3JPOTc0Sm9PMmdBemJUZHFISytKaXBqTEZHZW9SaVFlTkJB?=
 =?utf-8?B?eXQvQWhyTXJvenN5T051M005VlNkaU9FSzgvU1dMWHpIR2hjQVBVRS9ZWXQ1?=
 =?utf-8?B?RFBSVDZSWExRdzVvdVVjeHJVVE1ib2NKcUJHOVEyVkV0UnV6cnRjYXBIT0tq?=
 =?utf-8?B?bUlYZDErV3lEL2VLME9DcVBtOS9aQ0tpT0N5VzUvb04zY0ZrMnd1WVVXK3Vs?=
 =?utf-8?B?dTJnb3laWDN4bC9QaHA2RE9EQW11U3NoMzhzNnNTYS8rM2U2RkQ2NVRoK0F2?=
 =?utf-8?B?cDViRnF6TlNSTkdSZ0dyUjVFbnplOXVidzg2SVMrUXJXZGw3clY4bkhuVHNp?=
 =?utf-8?B?QzE5ZlA5YndlZy9mbHAwb0J6bFd6YU0zMHBFQWhwNTQzNkkvWkp3ZUt3dllN?=
 =?utf-8?B?SjN3aVJWYlEyOHFHS2Rkbjc2WWtsVEtmWFB1emlFdHNKNHZDS1loWjdDa3Uy?=
 =?utf-8?B?WkE3Q2s4eVJnV3dEZ0dVMm8xVXl6S1dkb0pvTmRQQUFKdzRoVUtGNmRYM2ZZ?=
 =?utf-8?B?NWV3em9nL2x6ek5iMzdubFNidFJrd0NIMUxrVFFhL0FxZ0E3RHhySXB0bFZX?=
 =?utf-8?B?OUh2U2ZwTy9Gdk50RThRTlpiZ2VIdkpJaGFVTkF4ZndubkpuQzQxeWJmcHFy?=
 =?utf-8?B?NWpnTktEdGJKS04xeDJ2R1N2V2RySVVxb0pkcHJNbHpLZXVFY3ArL1cwL3dP?=
 =?utf-8?B?OFFNKy9nRG5DWk1CYmFTbmtLL1Q0TnpxZXIvdmdWNnkzMSs4NUg2enFxZHM5?=
 =?utf-8?B?Q3dZRHhyMXpzVnJwNGJXMkdxV0piZzJ6bE5VRUJ5bGU1UFFva3o0dWszMFho?=
 =?utf-8?B?M3ZKS21Dd2UyRTg1SzFCem1KZVFGSzBkb0tDYUxkemFiTHBKaWp6VGRJRDVG?=
 =?utf-8?B?T212dzlPZmdQeFhqRHdIQXlEODQyazFVQXBkSy9pc05LaGlFcENWL2g5VEdZ?=
 =?utf-8?B?YjhqUE0veXRKcmtNK0FhbXloNXhwTGlzeDkvRUFJT0pTTlJLUFhWbXBhRDdv?=
 =?utf-8?B?OWVNWEZZN2xQa2JxNTZoRi9aWDZrSUEvdkJwZGV5Q2pHdzhUQVNWNWlscXpw?=
 =?utf-8?B?SHRpNThPcUxoeXpDV0NlUDR0dGZGd2VCb2IvK3c4enQvR1YwSExWRFBKcG55?=
 =?utf-8?B?ODZYdTlxdDRqR0hjUENrRGYySnMremErZzk1NEU4TGVrakkzQytTU3VGdE90?=
 =?utf-8?B?Y2dQWmxmeXpEMytQYkh0b21lRUFvM3RxMDdPYlY3a3VSNGdBWlQ3bFVaYWVu?=
 =?utf-8?B?OFk4VUo0NVF6ZlJ5Uitia1g3MFVnck50K3RSY0lNS3hGUkFPd0VBVlE4TDZP?=
 =?utf-8?B?UGx3dTJqYUMwNDMxWmpJeTNoVEh0cUJRTUU4NVFJOHRMUkZXSllPMU1xWldz?=
 =?utf-8?B?Y3E4UWVnNTVoSFRuamVYVGlwUUhoWUc2RWZncGdpMUNzUm9oZkVvQmtMUWdY?=
 =?utf-8?B?Z2pVRE9ESng0TVNnc2NZOGhjdlNVYml3eVZVaVpBWUQrSWlNZ0QvQXlUSFVY?=
 =?utf-8?B?b2lodDkrdFBzNGRDclBXUVo0ZmxhWHBRWDJlc1hQWkdTVnRIeXgwWkN6QUFq?=
 =?utf-8?B?UVRoVnR2WG4wOTBSdjdzUzFUblBEOHNEclBBN0hOZTdpc1Z0SUgzeUloYjZl?=
 =?utf-8?B?eFZacHRwRzBOekVWOS9xbTB4MXIvMXVKdU0vMTY5aXI5NjZzbmFySHlTb3Bp?=
 =?utf-8?B?NjNaTHBuL04vbHBDVFZ1MEtobTBnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC081FC71FE9D74D8CDC1866C973E813@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yzPsttWl9ZGdM3P6FLxqSDiU0evyperjzn8aQbQLD0Gzu7N8HgbosoHdi+ZSgcxbkjEyjBHu9ZSfKl5tip9/GZc9EWbX2dY6UCY3bisP7DwaKU+L0GnmOoY9Vuyb2Hf1409KJWjmFFyRCdTPG65ZYMlMeXu1WmK6VhjQeRU2siCzby/9shD3pbrjTcOzYRDuhmFmVzPpsumFiapRYjI89yrwn8RqDEj68zv/4UrindGjZ2yNv6YfeXi597bL1OyFg4bAj6mou+VM7wk0C+X/vWYO8QUb+GOuIsYGdJiVXXO6x/qIyKe34mH21RGRhAP+Kj8oWNCSOCfvxSNCRM43lG9sHX1nVTXmHqcKOWR9OFIfkJrp3tyE0MX/VdtYFDT4L+OzX09MNysctvGpj40cpXz0s94T+8T+HFp4pF0K4lfXDuq4DItGplWrw7sQL8jA20ZFfG7W1iF61KD3/b3XNOnhsL+0nBc6z75gdC0idBc2++9LsOHkrsVfVSQvMZEsQ+FAf8UzGJcDiijrdnEaMhinJEiVesd735+7Kgw9SYh/LYJ8hwUM17GRfBalIf22dfVV8rIw/BFNstewZLqNyVLFVEJZoHjSSHHieyGfwCzT5CVlQmYWbis4PtnT+Z6b
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54470c9-cbfc-48c1-0854-08dc57e39764
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:50:18.8261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npbSvAMyIcs8xJ/E/nhxFVZy6sW9on7wx1SHEktR/TFdRRSOvFAD4PefaDXUhj5A3FTozumGrl6mCmGUQ6NeSShH69hjqfpIrW+7n3JtTwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7578

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
