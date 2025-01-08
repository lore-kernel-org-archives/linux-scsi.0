Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E865C1A0BF8;
	Wed,  8 Jan 2025 10:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333491; cv=fail; b=Vi12aWN7UkthJ0y1JdjO3p73UEaCVvQ0QPEJMSO4n50rCpoKgZAVX0C64Y3EAAlf+1ayXCPCuZKlgLSqFYGRaHemWzx+deexA4yELeQmgZY2P+MGoZM1byZkdGYvimYuh41jr24pmMpjNMjWR9lRJ73c7P9srirS/EpwUrJsnFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333491; c=relaxed/simple;
	bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=inyQpe8YeVKAGo9Naw0Qug5AmLG5XTN+yGy85HFzNakNZ5oamJFVrlBgshZm+QU3R/RC6GlgGRAhNJhhmh7hrq/UFM5aSBIUjvjcz/jGdIXeOVdpKWhCpJcGlpEIvXJVI7mLhRQICEMOwZ0bOw5K0ucMwxk053wuG40ODdDh7VI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QXUODNo9; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UltJx+L+; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QXUODNo9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UltJx+L+"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1736333490; x=1767869490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
  b=QXUODNo9F/14SRJoQZiuCT9lrzM3oKS8Z/qnyCfqvUvzaQRfedH1kUPW
   UCLWvGykPZTVUEWiPsQEbbfpajEtFtG6ZjfS9mmkKXTiJT8WFfMG1ohyf
   r9phHqgTCLqUxrh/llldbFSuI10XNCUnDz4PZlBBetlRgs/YDiQBuDIHD
   DgwA4Hk4n2kcuBnSsNGujO7ye1JAtMCHOzuXv3f0jvXvjD5ACCstEuypi
   jNrAe4Uzf/Y2+w8EDCFTBwPSJQsO2AA4l5T2ytFcTToUmbvO9Bm3lPpBi
   uCZA8NvJcS91qieqZgRVtkAYgvKnqbIwzysNHYKWWKolSQs7/FedWXZAY
   w==;
X-CSE-ConnectionGUID: cv5xjJXVRXC8sYuQ2THCUA==
X-CSE-MsgGUID: qYhOm2PSTpilrQmU8VxjkQ==
X-IronPort-AV: E=Sophos;i="6.12,298,1728921600"; 
   d="scan'208";a="35473967"
Received: from mail-southcentralusazlp17012010.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.14.10])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jan 2025 18:51:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3sJdTLM27+fdDTXUTQx0YkLoCUycBn8Ce54kYHdMGqAf7xwUkEXFT2oZulktnkhCaqZ7+CNIc7wuxKQ3LQbpRAxIry2qV+oSicDkOzAvP6iIE433im4AP9gXWVC3Q2vgazxwvCkdQ0Sp+rvUTCtDjeQV3vX5m7Xl8HSONvlfQx3HjPWJssgjpYl2bm8r+6/OB8cW6hKddHJcFm+L7o2h7PNynl6dhi1omrZnGBKhI9Ybt3eTtxjHqjO1ZvIPxGw/RuA3NYiR4CmZD7nEAp78gi2xX8H8avxinECft/uV4NECqI3ZEgLnn+YJwn4hxH0cnSzam7K7PgEGhxcqXNT+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
 b=LSQdv72BvZB+ImhoqK6yGxO3UiMtQymevd81trwmfUahNQ5U5DQqERUVhxAcrEeXAV2vJXELVaFgpwkucGTFEQM3EY/MjO5UyRpKc25rGzcu+IxF1yy2pS4Od8yvj/qlEVCe0gPxes6LMeAfloo9YyShIUkiIPNDO6h+cIwulCTHUdWuw4uDLkRnQ3GWMkgYZe3ldjVo6FOBrRuGPCMAOz3caJxzjzWQmqQhoUfhfug/2xakGyszPgoJ0kgZw86tXcNYJw12CBAanmfhAEEC//5Y2vSCvnn5ja/OLDKN6YMs7mYXammyrsbZObqnkX+F2K+XcteaegSBnAl2p4DgCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMGotsqNeTx/ubHImRGkrUNQ7VIPAp05xnXyHmBTtPI=;
 b=UltJx+L+MP2YRMWlKGVfcwr/AcLyIVvG3ufGxvmHkVRQBl/pT/MkNzGbKxiV9PQrm75UL+2YxyBldzenVMVZm7oHMpbDmrDaI/OaXSzk/C3bFPnmdHRvm/t15R/VuHvMb/7uDbewmnpw52Uk1SRgDQZu0s4IMk6j3OZzw8l7Qio=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6950.namprd04.prod.outlook.com (2603:10b6:610:9b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 10:51:20 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%6]) with mapi id 15.20.8293.020; Wed, 8 Jan 2025
 10:51:20 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>, Nilay
 Shroff <nilay@linux.ibm.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "nbd@other.debian.org"
	<nbd@other.debian.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net"
	<usb-storage@lists.one-eyed-alien.net>
Subject: Re: fix queue freeze and limit locking order v2
Thread-Topic: fix queue freeze and limit locking order v2
Thread-Index: AQHbYa9FF4K2DACPvke4j+L54RiPxLMMsyCA
Date: Wed, 8 Jan 2025 10:51:20 +0000
Message-ID: <4f6308a7-7a3e-4fa7-8c90-742f1b7a64ee@wdc.com>
References: <20250108092520.1325324-1-hch@lst.de>
In-Reply-To: <20250108092520.1325324-1-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6950:EE_
x-ms-office365-filtering-correlation-id: f443048c-5b85-4136-ad02-08dd2fd262b2
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Zm5LS01XbU9ZWFVnR0lyejg3KzZ1bmxROVFtZnd3OEpDQWx4VjVicHJXdXhY?=
 =?utf-8?B?bzhvY2tXUkszK2YxcTZzb0tpamEzcWtHeDdsMkJWMXdVT1E3VmxMZ1ZzYUFq?=
 =?utf-8?B?aks0TFlZbFAwWEExSWw2VHFvaHlkVlhoZHRtcUtvMFh4aTFqdmJMbGMzTVAr?=
 =?utf-8?B?VElsRXZoelBjVndweFVIOTdReGtYd3V2MUJ4Zk1idDkyaFE4b3h5T3pCWWlG?=
 =?utf-8?B?K0duYzVPb1JnME4wOVZ1VmtjbEVndkJlZDlXVUxudUZRbEdlVXkvejE1ZVFO?=
 =?utf-8?B?Nk9IZENyaGx5cDJ4MDlQc2E4R0NicGNlcU93cElZT1U1alJ5aHBVa0tXOUh3?=
 =?utf-8?B?QjZXYVFiTzFUTUlySHVBVCs5K2h0eXBGaXBwbjhHbWYwMG1sYmlnMTQ5cVNO?=
 =?utf-8?B?ZG9WaVlXZDlPSzhPWEsxWFp1d0pNOXRha2t1cGZoYmV2SXF0RXVTa3pyd2Jz?=
 =?utf-8?B?bjJNcHpvY0RVK2o4NkRxN09sa3l0OG1TQXp1MEtoV1ZZNnhRRm9oMWJxcHBX?=
 =?utf-8?B?WUQxZGN5WkFQTm5JZVZDS2djaU9SQUlzUkNyL2tOLzJ6ODRRalUwQ2ZGT3k4?=
 =?utf-8?B?SUp5eTVzcXRUYnl0K1l0cnZpWURVcDRTVHUySndnTjUrcERlKy9ETEl0eURs?=
 =?utf-8?B?ZEhkMHQvZFdOWlB5TFlzdEJzY0drcjJXTzFZZTVRQnVGUWswMVI1ei96NVM4?=
 =?utf-8?B?RmlTRXZSWUpFZzVSWjBubWFJTC9RZGRUUmJ5dXI1bFl2L2I1RjVDYXBYRURX?=
 =?utf-8?B?aG9zLzhyUTk0YjhUMi9XVXlVU1d6WDhVM1h2VnZGa1VXR1hCUE5PYVJxN0NB?=
 =?utf-8?B?RzJuVFhvMjFFZkg5ZkRVV2xEem54cFZtb1VLQmxHNmtJVlRLU1c5Sm0wRVk0?=
 =?utf-8?B?azBjdDNaT0xGYnBHWVIxQVBjRmR5R1N1T1BRQ2tvUmNySzU1eFZTYXYxd0dr?=
 =?utf-8?B?WEhBL3NNN2tRSS9ZS0ZZa1VpMWdYaG15TmxLUGh3d2ZEZHQ4cmpWU1VndTJJ?=
 =?utf-8?B?aGZ6Ynl6NVFvTkFhL3V6d2wyeThKSXJDanZsUmNrR1NsNkppTWs3bE0vK2pi?=
 =?utf-8?B?Tlp2bFU4UG1LVkg1TkxKWEp2U2FGQlVBMzlTeUc1VzAvc2JnaXpaM2lBOHlK?=
 =?utf-8?B?bTRVQnhLWTlpckdhWFNMK0VYb2lVcGkyRzFTWnc1cWQxR200UnN2b0h4TDNE?=
 =?utf-8?B?SktiQ0szaGtrb0ZjcDVhdzRMV0pnWnd0ZUkzTnZ6cXVDRFJicXh1MU4rNGJz?=
 =?utf-8?B?NW5iak9OOFVLbkRvUVBzSXNMZ0VsbnBxcE4zSjNBY1M2a2VROHhZRG9BcVRn?=
 =?utf-8?B?SXMzNFYvMWM1dnFhWXQzcVMvdm9MUkxaREVCdnRGdU91Q3h6OTBXTVJzazd3?=
 =?utf-8?B?U1JyOG9hYjlqWVd2UmVOczlSeUJHcVk2ZFNweTcvMFk1N3pBbVhvMzA5a0E0?=
 =?utf-8?B?MGswRHowOFlmT0FTU3hKWXZCSTNhbm41Rm4zOXBHa1Avb2RRWE12dnNELy9N?=
 =?utf-8?B?OEZKL3VDQi92cGNOWlkxc0t2dDFMYXV1emdWWUl6eW9DZXRKVzFxUkVZTVNM?=
 =?utf-8?B?bUtlTXJlQnVzVjFSMUYzODZ5b1FBWkRiWkluOHVoUjhFdy83WW1jdFk3T2dp?=
 =?utf-8?B?T0Iyem5pcFRkSWloVjdQNGM2bkJ1Z2pDS2U5U1QxdXBDODh4eW5zaGlya0dN?=
 =?utf-8?B?WXJLK2VaamJMVkVWTS9XcmZVSGJJQnJHMllleDZ2OUFJYjFyYm1KV0ZBcUtT?=
 =?utf-8?B?cVNWRGl0ejluQW84YzliSjVkc0lnUlRGZTBMdzJsNC8vemRiUVJhQ2xlbllR?=
 =?utf-8?B?bHV5aGVjZ3Q2QW8xNWJSWkt4aEpHTjdzd25ZcXY0WWY5a0JPam5KeTFsQjBI?=
 =?utf-8?B?NS9yMWhFZlMxQ0xvRkQvajJ3b05UbUZCYTlicjN3TmVwZGo0NFdORVI1ZThJ?=
 =?utf-8?Q?4HgRUJosRion//2npbf5a3BXhhxz/rwF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M250YUhXbmdKNlBrNlBVUkd4Tkw1dUlsNkJVWC9TelF6bEEzYUZFSXAvN1Fx?=
 =?utf-8?B?eklYbzJ2U0sxQXRlbERxQkh0by9HLzhINlI1MWZxK2oxZFJUQ1NnMFpWaUho?=
 =?utf-8?B?Ukw5N3BCZEMwTERxcFhMeDJxdG1xRStnL0V5NjRaelllR3R6QllrMXFhbWxF?=
 =?utf-8?B?QXVZa0VLamhjenY5ZU9sdVNhSmc0OURFbkNITzR3ZUdnSW12NGJhcGNlaHRX?=
 =?utf-8?B?SFBKdHAzZU1SWWpla3lWNHJHKzdWTU8vNjZUOVVkdnBhMURXM2lGeWxWdW10?=
 =?utf-8?B?NkJMTDVNRTBDN3FIQkRnQ2c1ZVpqWGtIMlRzQUt0bmx3cnJXdDQ5VE5oQk4z?=
 =?utf-8?B?YlNNOTR6Qkh4Y0dGVnF0OEdqM1RhSjVHV2cweEdmUWxkUjNVUFYvYmNGNEdW?=
 =?utf-8?B?cXRydi9NcERwcTM2MDN2Yzd3aXR1bm00eXdzV3c0VTF0RG9BSzA5K3hYYVBr?=
 =?utf-8?B?bENJZWE5bzAyeDdlaVEzWHFnVGRCcXlNUCtEOWZFZ2ZjNHQxZXYyaHVSdVpF?=
 =?utf-8?B?Vk5lb1krdlovOXpYYXd1OWxNMERvbTBqcENDTHFzUDU4d2daQW5FMk9sdndT?=
 =?utf-8?B?TE1sSDQ1clRta3dVcUhXWGNTemtEQTR4OFk1UC9yVHZQY1JVZGhJNUZ0QVpo?=
 =?utf-8?B?bHJ0SjQySTVaRFRFcVphdWJoblovUEcyQWRFeVJoU1JWRXo5cUp2V2JFVk5y?=
 =?utf-8?B?dk9hMSt1Q3E1amdtWld5bWY0UHdGU0RhRVU3TVhSSzJobjZuSzFJWG80dG5X?=
 =?utf-8?B?NVZoU0x0YzVDNkhMc0lPbEIwYzFwMmdYVW5tcXJkUnZ5TmJJT1pFLzVsV2pF?=
 =?utf-8?B?OUdyVUxlN2F5UUxLaWxFYU1ReEdPRGcwZzN4TExXa1FkWEVUZzNHTkhDakcx?=
 =?utf-8?B?Qy84MjE4UVNjVzBFTkJldnN0OGpDSHUvRWZNWko1MjFzclpqM1hSVkVIbnds?=
 =?utf-8?B?MW92bDdaVlZNWmJPWEJjS2EvQlNqRXQxTGpqa09XWnZZVDlzS0VJUzhkY3ZK?=
 =?utf-8?B?dmV1eVd0SW40RFRROWRYdXdpYTNZYTc2KzlyTDJkamZ1Vm1CS2x5d1RTd3dP?=
 =?utf-8?B?dHZuRC8xdE9OaWUraWhRelpIM0ViRWlHZVg1RFp0WXh4WSs3NExRazZIRHhv?=
 =?utf-8?B?WTNDUzVmTjZJaXc2M0JTTkhHcXlzdE51U1BmY29JR29aSnI2cVVVMFJ3a040?=
 =?utf-8?B?NVZOenRkTk5oSlFFc0VJbFJKM2Y3TVdVazFHRS9CbHZUOG9uME9TUEpnclB4?=
 =?utf-8?B?VlgrR2ZsVSsyZkV2VlNQL0pLV09rcWVML2R6RWpyVnlRbDZPakpnYmlnVFJ6?=
 =?utf-8?B?a1hPY3ZDWllSWk5ISFpNWDJ2OTdhT0dKL3lFRTlTRFJaaFhWZkwvV0tMRFl0?=
 =?utf-8?B?bVAybEpkSXZVb2xVeUl1R2JDZUdYNmp0T1B6c0huVEt2SlI5NjUvczhyVDh6?=
 =?utf-8?B?cnlTS0w5WXlhV0JPOStFNEQ4L2dKY0dWdkU3cG1PQnd2MHkvUHptcGYvYy9G?=
 =?utf-8?B?ME5FenNWQWFOUFNFTUovd0pIa0FjN2VIb3pFVnVabE9PYmsxazZPbFBmcTdX?=
 =?utf-8?B?NVc5UmkzbjErNWlXNW56ZVlMLyt5SDArRmJGZ1BON3UvRGtFUWtYZ1hXdzJV?=
 =?utf-8?B?UkJNYll5ZEtvTmNxUEUzQmFmajUrdXRnZzdVQ2JpQ2pIUWlKMy9wd2U4WS9R?=
 =?utf-8?B?MzZod1pnL3o2RTlTZDRPSFd4a04xNXVPTzh5UkdOc1ZHTS83ZmtMK0ZBU1Zl?=
 =?utf-8?B?dHNaZElEbnNqR1NmUFJYcitRTXpoUmNHcWtDZDRmQjVISFZUcDVRZDZLZmp3?=
 =?utf-8?B?OGUwMGtFN0w1dkxzZ2NuRXNHZlZKOEpBckQvUExPS2V4VUtUamJYTDZLQUZa?=
 =?utf-8?B?Wkt0NlhXZzN2UGtrRUtOUnRoK2ErS1VqNzBXdGJPZVZPUGdNSUZnbDJzcjhM?=
 =?utf-8?B?aVRnN0FxZ0Z5aWxDRkNjUkdPOGkxb3hMbWZjMnZ2ZDNJV0w0YUtsSVVXY2FQ?=
 =?utf-8?B?M2ZaNmpodXJLbHducjJRbG9vck5ZeHVaZ3V3TVd3dmpDZ0RPVFdHZEpsNmZH?=
 =?utf-8?B?ajIrWGtqUDNUM1VqS3hVUERlWDRsWDVZL3RxUFJ1ZlJ2dGpDUnlNUTJMNFQz?=
 =?utf-8?B?V1dSc3lMSXQrUTJodXdiY0ExbGp5S3FpRnBJd2s5S2dZN1UzamNGa2VxUXBI?=
 =?utf-8?B?V0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1E7363DC48AF3479B02784928C7B817@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7fG5vUwEe+l5G1/yxdE7stxBmrT/93AINpn3VeD7X9Pv7xOXdtc0+ittrN9eAfWhvwDuUNnr/LllxHwh5UExbqZiyofIKiEvQitf5033GuA9rSEXQS2Sx1C70ZtJXlbwi6W1fsbO0BRut/WZgRYRG0e7m5sKlWhmRocGFbnSOPtB2GeEaGWw0c3GDpw7CeYTUgGn/ajU4GrdA43Dr9JyN8HdzCW7RLMGzBPAF2+CxyfE39neDLaQSazIBWVGJe1ZSYzbgcnBUNOK0OXlHKERTgGt3w/ZWBR9/2y5TrqIhqwYUnmJAuG5liqBy91BZTw/eyHByjHCqZxo8+HBm02C+C1tfJFDM8g2LQTvp18DVTQ1oNxdO4oHLg0NR+i/q7VKvLRJr1JqzyKwHHDHp3N5DDj9mlYxV9eJfU87UnmB9ohPeI16DcwwZHI0BHtiGkp+ldlRfKQ/7K8YTNaO6a0EI/j5bjI/SMJDYtK8k/XkhehK+cvl47xUF+fUInP22bY1U+nw67paihzPOoGH5NnONzklKYoQNyufPhtiimfpC1IlR4laQdFhOV6ogrECs3ngvPFlI6hrHBSN356gKuNa++VaoRvmAKlZc9HbzBvUJ2Nfv341PNYzlLnChvCIS4O+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f443048c-5b85-4136-ad02-08dd2fd262b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 10:51:20.1386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uaNLvMjsZob5YflOQbyEfvlRh9FjuLo/1knaeLVWHppRrt2nULgxndpFdeKiN9plfmw1+IWltbFE+1TZkd8ZB/kRB4B/O7K2NpGY6f1Omuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6950

Rm9yIHRoZSBzZXJpZXMsDQpSZXZpZXdlZC1ieTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqb2hhbm5l
cy50aHVtc2hpcm5Ad2RjLmNvbT4NCg==
