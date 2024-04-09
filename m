Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28C413BAF2;
	Tue,  9 Apr 2024 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675647; cv=fail; b=DCQvjDJ30SaXNngP/fXVxIhvsajIHK9SAPfBEmubyRo3AIxxNwsxWfalA1ZOuuTJ+hJIXl8LrM6v63i//w+2VomfFHZ78hH730VwANKdeWnWvKb5Qxs6QITpioneCTW4myEFDfz/GomyfBWgURyA+LYYHQRQNtHRZ9scmTqOXYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675647; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ClOi1dVDhj4iQhMbh/ZX5udRRA/Stb695Bfve90D0yD1UTh3UV2POZDZG/onbVt8jUp+GKU+Q8fGuN/hM8DSl0LCnsUFMGlR1BxNiN5mfPvN3Zto4eEfRXZ2BHAB7qNX/T4Cx+kQ3vckJtrEnhiOY211FY1iGmRmx0UJYJl06yY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=p1ddnQwL; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ersTzWAh; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="p1ddnQwL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ersTzWAh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675645; x=1744211645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=p1ddnQwLablQrlAEicBkUGdlzEFExO3dkywZmCRfQA0fZ1zQ4FGpxb0s
   O6/sbfGxTy+fY6VVxuM0VP/u1RaIculKRmHG3wQc6fPKWgTfthA1edAgh
   j7NI23A4Ku5QG9Oq93idoYnaV7oHjNFYtyx/Yd3zNQ5knYoa2nFo4ZigC
   0aNxWIdEXsciR/Y1nMgBhUVEwBdUZvdYIyzfMLIvNb4i/0duhM9mkxdQe
   iKkOvg/NpBhyleofWE7WbHZ53CxCCad8ilqV0n6AAHkBc8hRBLxAzQsJN
   yxac1G1tNv6zeGRxJEd9/CHwZ0n+EQj3V7ANCaN8uxaq29VpHXumYNY6c
   A==;
X-CSE-ConnectionGUID: DzjSC/CDRJ+8bXAe3YTVfA==
X-CSE-MsgGUID: FI9j+KBcT4OK8i/gzk5YgA==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13602317"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:14:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGoC9pKJfbF05tSjEv2mQJharhuNhKtB8fx6fNcYvQfKqkFW2PLKkJpF2+o9IYGx7C30ced1at4U4NZtsfJBn9VkFd6cGJywu9pO8CS1ARfpo0QK96bBXC/8zHhXqA6ET79gw1bPHhXVy/5kjmFdP6Zkgq4UX1tzlJ9oppuT8i5AhYew5j5DdFAJEwT55vEVrMpabre44peDdohawun+pgPZovc5rBq5+BgV45jWne8mUaBgf69/FktAYDBIm26Pa0s6llgQuD3n2JwC20W5noZly0ddnbqrHmnZfP4hWT6lzy6te5NPzB3Ma/O61WijFTdHr4WTwsNaiZeaDC35gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=OUlZZB3LT/dTxp0fn/FLBAIuJLklTRgCHv9d+1JGMuyiOXr5zQupr8q8d2CJTyhIjMt/VhAbah0N7V2VlGlN5YsW8/ZcBfMdt5LFVtPoU9tp8IIdX+zWJQ7irOOmMc9I2RWaepN2hjuLd6dyDlHNypSScmCIbAcdVYl+qiFHikQm23+CnuAleUIFuUa1TJRToWvQaV0ggsFFNEP/G3aWHUL+atrTRWMvmqjm/XCyLtXbUn04s3IzSp9gd5UBc3CUCmUsNhONnZZF6wFZJh/r+9sD0QrN2OkqK+xcDId8gCTWngvFw1abv5diHMs0BPLxMsVCtJDUjlaoCzxKmCAhxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=ersTzWAhOP/QoiXXjZbT8EoS1EZN5Ro24ldnCblLyXx4ZmdNSeW+qWB9L9vIxjNoKDwaRDzvFLKe7NTNHM32opusR2RtBWSc+/EE9lkHcmkxD0q7Yebhc75LOaNebki5SmDJxWsIqeodla/W9vLkoWoaDCdYQwn1sxmvx6eLJ70=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6375.namprd04.prod.outlook.com (2603:10b6:a03:1e6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 15:13:59 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:13:59 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
CC: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Xiang Chen <chenxiang66@hisilicon.com>, HighPoint Linux
 Team <linux@highpoint-tech.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, Brian
 King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>, Chris Leech
	<cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>, John Garry
	<john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>, "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri
 Altman <Avri.Altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Krzysztof
 Kozlowski <krzysztof.kozlowski@linaro.org>, Alan Stern
	<stern@rowland.harvard.edu>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org"
	<linux-ide@vger.kernel.org>, "linux1394-devel@lists.sourceforge.net"
	<linux1394-devel@lists.sourceforge.net>, "MPT-FusionLinux.pdl@broadcom.com"
	<MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "megaraidlinux.pdl@broadcom.com"
	<megaraidlinux.pdl@broadcom.com>, "mpi3mr-linuxdrv.pdl@broadcom.com"
	<mpi3mr-linuxdrv.pdl@broadcom.com>, "linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, "linux-usb@vger.kernel.org"
	<linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/23] scsi: add a device_configure method to the host
 template
Thread-Topic: [PATCH 10/23] scsi: add a device_configure method to the host
 template
Thread-Index: AQHaiovRpCMVjc/UhUyzV6+PT6PeRbFgDACA
Date: Tue, 9 Apr 2024 15:13:59 +0000
Message-ID: <938a4eb2-7d4e-450d-9aa2-5f327ea65fe6@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-11-hch@lst.de>
In-Reply-To: <20240409143748.980206-11-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6375:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 XgC4A8bbhhABAiC8cUIxzLGSzX6SOiuWRFDgho1rbqOGti9gMpsGdWlxvSYnHxESNJLLL+TrLf+yOrebtIh3twSM6ngsWwQlaq5Hd0RBBMkjAeBdG3KyuUpeFnMbKH3o8fVvGjIhXhCvjIMnqEn+9Zvewvu26rQPGNFORm2emEWReGIdXGJxVWGDhLnBNlgdj+Wwd8QNU94UXxSJj5QFdjg3i0fC+1gUS/n8cRTVYWc1KGsLew/91f9A9I08lWAn7U4k9D0aKqcLY1znX8UTZXPw/IoE7mhx4ocHKObBPFx6FjCoCIPwPJPLfkWOT1ln2TjpfpDq5CQ0kDnh4zsGdQBMZwUXTqB17XiYddmxfjFZL7ffXI9gFlgcJw119eHpAknHQDXnC/uPOgQ+D4bmbgqMW8Enx5hcWDefRiLAN5G50SsMg1zeyGkMbn9MfYnDzHLo2ZuWTWZ3TKbywBAuCdJzQdamRGOAArrZdCsL4ooaib9spwqSlYAZ1lLwpUwBDLQqnj7ZtWLg6QL/y4/L3MNSMV5iZ5YHMCxNNL30vy4VUbiSVMHyQ8RwBGxCpXI4Qrr5yuUnD3omQI+MwU3aBxyHI7r35xyDGH8SP4nt2g5ylWfNYYpMgr3QNc7NwKrULWGRNJIxuX6Dh7SmOarMV/z9Y8LfnO9GwW2B/nmepBQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ak1PZWd1M1dWL3hDQTFGOThkamJncDNheUdQVWg1ak1UOEJEczdpSXV0d0tV?=
 =?utf-8?B?ME1GWHA5Mk9Pdk5YSU5IUEt2ZzZqbkMyNjIrL1hvRzJjeGFXNzFBNVdXR0pF?=
 =?utf-8?B?MzFYZnkyWFR5THJVVnpzdFF3djRrck5FRTlXOTNNbmNCeW1xMng4R1dRR2h4?=
 =?utf-8?B?cElTYVFvMTdKUHVwUG5IM2JML2RiejYwckp0dXh5ejhNR2FlVjVwNWRwVm9s?=
 =?utf-8?B?L20rMVd1aldaUXVwaElxRk9xTys0eDU0T1AzSmhzbHp3bXc4S3p2NnFtQnhj?=
 =?utf-8?B?dVpTU2lpRkljOU5kYWpYa1gwZEhoVlA1N1pMT2t6MFB0Nk5YQUpYM29aVlh5?=
 =?utf-8?B?a1F6SW1Sa3I1Ym5lajU1NjBEMG13cnVJYTlUd0pjdGRieFBiRC96Z0xPUTR3?=
 =?utf-8?B?Zjh2Z2p3bHBFZnBLd2FoVmgxcmh3V2Q2QkxhaFB0OHQ2T25zRXhSZ2c4Tkww?=
 =?utf-8?B?dG13M2E3OFFtNzVjZFBNTk85ZGFaTmx3enpIYUlYdEg2eUhrdlkxUFNmQjll?=
 =?utf-8?B?WkhuYW9uQVFPVC9PdnczdHRWdTZKV1VicDdxQXFBRUlKbmNiTmNQUE00Q0dK?=
 =?utf-8?B?TUpIdEFOWG0yZm5uWXd0WmoxUnV2eHNyNUlEbEhkM1pqTHlGdjdJOXplYW9k?=
 =?utf-8?B?Skg4dWxCTWJ3Q0U0MldjbGhzMXk2QXhycmsrRndSS1hkVm9iOWM5Mzd3bHFR?=
 =?utf-8?B?RVhzYWt2aWhoNER3R3RRMUNuRjVmZ0VLWDVhQVlvSkZEbkxGUkhOVnp4Q0o1?=
 =?utf-8?B?SDFscVVCMHhxWEw3bUIwTDBXM2dYY1ZrcTM5dTBKRnNIK3hJOTAzUWxtQW95?=
 =?utf-8?B?WW5LZmFGOHpzdGVldHBNMWRTcWt2eDV6cTk5UnRxY2w1ZUNabHhiVjdHMjA3?=
 =?utf-8?B?N2ljZGtaT0xoZlkycGx1QkdUWmtlKzFlVWhsU3RuNnIvV0dCMjVYcTBOV2NN?=
 =?utf-8?B?eHNNNHpZZXNVNGI4N3BvSGJzdVY5R0I1U1BnMERMZVh4R3pkb1VRc2RKMm5Y?=
 =?utf-8?B?cE8xMmZZNkJlTmIyNVQ1b2xQTW9lYS9Ec3R2VGJUa0RkdkdDUEhjZWpoZ1VT?=
 =?utf-8?B?UnpCbTQ2WDY5bHk3bDdlM2Nyejk0ZnlMc2g2NG02NW54d3FkeEVsYUxvc3M1?=
 =?utf-8?B?bksrbFNaUHJLS3R4bnBRS2tjVitPeEZ6dTN4YWJHZHFKTm9mbU0zYVNpdEM2?=
 =?utf-8?B?S3BRK3pMUjRJQTA4SGZUdjF4YSs3bUwwSXV5M0tnZnRWNUhkOTFQZ0FGS3hI?=
 =?utf-8?B?L0d5OFJsOVlDRmJSeis5YVcvQ3dBYTFVVjNjMnhXM1RZaUR1UENkOE9icDFz?=
 =?utf-8?B?REJvYmlVbGFBcnNobXVXTGVoYWp6UnU1UEQrNWpSeWlJTHF0ZVZlWnF2SWx3?=
 =?utf-8?B?eUIzczR1c1Mxb2o1aE8ybHoxcERnbXEvcDlwSDVEbmowSjd4V3RqdVlZTFBH?=
 =?utf-8?B?cHB5UGZTNFdtMzROYjc3SEQrS2p1S0l4NzNCWjQxL2hGOXoxZCtrOVUvWG5X?=
 =?utf-8?B?UGMxY2tYcTVrbnRFdGVqT2UvQ015VE54NjM4T21KNC9tbUNGdUpjTGsydXBa?=
 =?utf-8?B?bkJrL21ESzFMZGowRmZwWWNMOW0zbEpmNlhpcHh3c2JSU2l1cjdjdk8xSUtF?=
 =?utf-8?B?cXd6WnVpL3EwQjhqd0NXQ2E0MVRlbVhCR25vSkFXTTdQdWFhR29kT2Z1d1V0?=
 =?utf-8?B?UER1L1JrTTJlTVlYUUlsekJzTENWU2Y4RlNWQ3UvOWJJZ0FaWE9kTFp0bnZF?=
 =?utf-8?B?UnZ3b3UxVFZHNFVkWjE2TkZGdnM4Qk9zZUVlTXdDd0FZVWlDOFFGWW5pT1pO?=
 =?utf-8?B?NmRYYUdWZ3FOZ3c2WmQ2WklURG41NDh1TDRWWkhYZnBxRlQyZTRFOHpBOXNZ?=
 =?utf-8?B?YlpIV0liT1VvWnFnOUl3Nk42Skp4djN5NE95UHVMS3JVNFFyN3FZZE51RUUy?=
 =?utf-8?B?cE92RVdDeG1USU11dU8yN0ZtV3p2WWtzMENuV1ZUczd5TWtQeWZST1N0dy9o?=
 =?utf-8?B?dFh4ZXZ6L01EOTZoQytnNUJjcGlDV2FCMjdYd2Y0b0ptakY5eEJoTUkwbm50?=
 =?utf-8?B?bnBoTHNXV2lvcitKVU1OS3VBQit0aXVnWk80cVZzNWt5REFTbW9weWpyMCtz?=
 =?utf-8?B?aTZERXk5eEt1WXNESnRUNVhvNExjZ2NJSURDNXArS1F2WEY3b1AvdFlNK3NR?=
 =?utf-8?B?aDVIcVJoRG4yZHhQbUZQODZFRTJucW02Q2VMV2VNS1VkZHdJMTVHSVhlc1BQ?=
 =?utf-8?B?ODVCNlZHVm5CRzJUR0ljcFdKY1ZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B2E4CA14F8C8242AC181307FDD61E62@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZIsObaQys49XzIdn+XBmOKmhZ53iS5LiW4ls1P9SO7ooicL0i/9jCGJBkwwAYNjo4rM1LI/tg7hS7kBF8VwwIO7lv9f9e3jby5IGd1L171QEoarIoQpKcHqzF63CU2nIp4rzDQx27wM6W661akKmfBkJRqZoQheQPPnXBrWm5toYq3UGQ1vEc/8mhslRjP05XVUwosf5cmxGp51mDVYHxg2zGyPDtNKxRqM1/3/x8C/+EKxYsY3ThYD7FbuWPDN+5mS94xKnbGdBIHpp2UPjT5REEA/oOx+RDfaXeExmy43h2qrao/DYX9zg8xP3ZJfdj/syoFx5mckGt9yWm/Oq8Bi4Pc228QxJsXE5f1z2FKlDxfTdK6uU7qJ1Cu/DPH7wDpdGJdDCsMX2YP5VH2EA6YeuqlXFtJ7Sia7mlo6Lt0mopQO5IVqiU0fFS5OW9+AaXw2qo20jTtRyvXwc0v7ynh7NWzk5jjB1+yrGAoFWJYlH9ThCLxakenqLXz+Aj5aonOJrZmuIYNKP9gFFwOEpX9nj2RWnWTG0VclZdGRrryItZoWzbDrfte3RD16lErYYw/ieWw6b2fPxDvZWyTHGJJqIoA6sBFB7d/wGD2KsCqDEFBc/Qa67fP0tavGlDOEw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa3eea7-8aa3-4f31-3d15-08dc58a7aec1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:13:59.4213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TFKcYRBMD86qYhwjXfUD56VfeOkxtiFG3CNwevs0ysDKrITIW3l1263/eAMPVTx34zv5wdeQ0xjRAX4c0fPnHi3LvsUZOI/mJj127vQkFB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6375

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
