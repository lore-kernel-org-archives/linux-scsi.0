Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532495F87E;
	Mon,  8 Apr 2024 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591267; cv=fail; b=dnVAA/jxDUk4RMJndceLsv8Q/7i1iNd7IzE7d2AvSjPeG+EoP9pVbH5BnctGNBokgGug+vglFzfLQAp9Y5yUoYhjfkcJlEVkWTCZ7csM2UNQQmaec4wCzzK8CJ8n7jzDh4enPQ2Z0V0O5ARs2zVIMTxOxFGnJ614ezZq8eosCnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591267; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NanKNZpoA8rnkwIoI4DD4l+xEth0UrCzXV9zPhPIamkj92X4zcWJSFx60lmigKCZIhK945S/KJ4q8+WQUvwmc//GefGIxwGw2xtdaSDVD+0fXy/Ktt6RXVjh0BchdrdHTy/MbQ0eFc0Ikd0GlPu9AZYXi7aP2hWHhV3jnRffqzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oM8HYWg2; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nSQra0/W; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oM8HYWg2";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nSQra0/W"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712591266; x=1744127266;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=oM8HYWg28S6uHbmTWnGJN32dnuS19TjkIc+gys/lIUgnt3RSAXkk9m1M
   uyoGxq73ubDfoeHeD04wXlU7Agox7xJLoTBSGvAHkoL/BYOsCM6k5qg7M
   XzW27HcHzaUcE47zeM9J7msihC+t1kGletOF5M7FAf6Enboz9Qw9imdkd
   rIXcpgrTJvg3hI7mLUqv7xJoRBt0LDnuk/mC5UXtwCThYpQOnUCKRis+v
   pvs4p0LU0qonrm8bwd6H2l+mqFSERUF325JS9sMOH2A5MzEXIffcO5p5z
   VZHtUWdqvReYcnqfGyrzLJAT4b/aYh2XXHLX8QxQ+xHGlr9fRRcBjMTeh
   Q==;
X-CSE-ConnectionGUID: nJZq/CHxSk26LzXdfJJd5g==
X-CSE-MsgGUID: wcWp6XSsQvmIGie4npEJ1w==
X-IronPort-AV: E=Sophos;i="6.07,187,1708358400"; 
   d="scan'208";a="13344381"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2024 23:47:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTNao5Rh7yUvUfqnqEv7L5c27J2tLHwM1henBYkeu7qz0lxMA4LMgPRG7cwgFRbGZzJQusojeT6hh70G2vKBqpwX0JX9S6Fqz13RSHNE6KJSKFfKh30bxfe0H/3lLIknJVfxDfX7+aKegAAUv92dxK2lx6PS75PYM/yWdunSQrZ3JL0MIMQb/Hj5VbIlcCoXk+S/narwCz+flb0z6mvFxJVpNw+6jpDg6sp5Yx5ymyWwJ5TOwLa8vsAmLpmZZwSuVj2ZbUps+oBP7/8pGE5rFpCQ8MXt12FCUQVZomtNVKsPTxmXQoFX10WTY3Pbje9vjaQUgpzkKP4xUlGmhdafrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=hNRH1ILJIGQ8u1U0BuH0NhU8fh2U05hMUhjsodEaCTZgW2B0rnNvTRT2mtcwNvbtDlCwmfga7EIdVF4MsdbAiiOTPSrEgvC9Edr78TIEJPDaDGfBIwO9TP7zfFm2oWs5lgjggrUg/Dys9shbEn8PZOHF6kWQnp0zXXZSwvLRvbWtQ8X7IBr7vDuXGHTH9WxqMjE2zuIBQ1LEj4IW9J4QBgKo09LOKCLijX+ZeFsj83IEcWZn4vdVEhO7Y2d4p8TySNMxOwuIXwjxE4RlSnupQfmwuMfXzkvwChj1I1v8Q6PvWS5jgn9yF4RcnMK5WA/5btjVdUouWP+88gNCy1dpXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=nSQra0/WiA5wQ53mIalIUFzjyJp91ZaMmUFKwkssjtAoCpLe5qvXWjcw8+W6V4YXgMEOYGxz8nVzbp58pLeQVG4poF4fe6PN64J7r9OWPQzgcELNHuT95uNZfnevYVaQmqLQrGV4Jkj8QtLRPXKeIM0E7uHYxF6AZthAnnO4vEc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 15:47:41 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 15:47:41 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 03/28] block: Introduce blk_zone_update_request_bio()
Thread-Topic: [PATCH v7 03/28] block: Introduce blk_zone_update_request_bio()
Thread-Index: AQHaiVX2gknGZ+9ufEK6JrbmCCJZN7FehYGA
Date: Mon, 8 Apr 2024 15:47:41 +0000
Message-ID: <70006933-a00d-4a27-81e3-647776a1f3be@wdc.com>
References: <20240408014128.205141-1-dlemoal@kernel.org>
 <20240408014128.205141-4-dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-4-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|LV8PR04MB8984:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 3BfnSl44m9X7m/7lUjfPd//5rKr5NVinKadGVGXwFZwAOJ4O4M6oqb3ADz85/TNxmg8rSrYktWzuCtCd9f0zdxclPEEnhKILxstTECuOdYWfKoc+4ZvkCfJN3cOV0P0IFoE5ebvxLKswkiEDKuKcwDkpZVAy1DPLtqaaAr9ke1CVg6xS5ZdMXNT2F11uoWgeCefJ2FpiSPm7+y+Isu3xWaiObPUCJULJyj8TYsUxi52NTr/gk1nCzhLyWUZ36JvNoyW34fQpBWwww87coLtYr1yTMS1cLXcW1k0vXuibmvaGbmKIXWsviYolCd5vH/HcX4jB5WBcDzhJaizDyPQn09cfaMTaawz0OsQ8gVeaGlCMFT5RdUfCkyEuas1nW2sxCrQHt3yf/9rFJFoCNYC261TWpHX94BlxZDlQk37OCV5nBYP9Nq/XLra16oiqdXec42DVdBa/NNXxWieYIEVKNcFvzHZ4w87eX3eH+eb6OtiOUEl5b78sPNBzU1NA5GhyzwQ81ibKEhAgP5WT17Dp9GNWJU0qok65YFB0WHV3o6EyZl6QkC+FEe5EeSsAGBUOESjhlMwr56W3gpdZdGP2jqmU3VwypRgNOdA+jE9sfMRQ4YTJLjUVb1Ms4dc+CTASceeCsIKSJMsitdR3r3wXBNT4TLU9sW7KuzM7gom/FuW/XaYkmQtKhozSbLUsw7i32hLvE8C5wG5orlreq3maiQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGFTYjJrUnBDcW9nZFhweVdqay90VUNZZ1Y2RHRvblpKSk8vc2RyNXN3b2c3?=
 =?utf-8?B?VVl5U1ZiNVV2RXRYUmNrUiszemlzNzIvcERYazNpc1YvYzUwZWtmZG8ydFZw?=
 =?utf-8?B?c2hJcGpWQmx1L3FDbTVqZ1lBU2R4dk9LeVZFSSt1TGlNNjdab1c3ZGY3REdH?=
 =?utf-8?B?L0RmNlRWd05KNDZCSUZvN25FTTErNHE4clEwS21GTlh0bWE3QWJieklrL0lz?=
 =?utf-8?B?TjJ5RWc2QXQvSEVvM2V3NGVtak5HSjhldFRKaVlLQzlZL3FTWUMreGUyRWFX?=
 =?utf-8?B?emgrVkNTNkJvRkU2RHZmTDFZTjhXQ2c5bU5IMUQzbjNVbUhPZFUwMDl5eHZO?=
 =?utf-8?B?elJHMlJTQ3h4VmhkZ0V5NDg3eE5WTWtQQUZPUXRjZlZ0eXJYb0w5cmo5STBw?=
 =?utf-8?B?MGxVYWV1OGIyWllsQkNxS0NOYjJPQng5WWpJbzl6YUlHNlM3a2V6b3Rmemp0?=
 =?utf-8?B?TEpYeUJDdmtlcVBqVElRSmRWVEJiU3J1bUhGTVprUGpkVkxralduOTlxV3Rl?=
 =?utf-8?B?NmNpTDQ4UTI4NlNSVkIvUWREUS9qalFGMk92ZFFTSlZ2V2owTVFBZVdqQi9w?=
 =?utf-8?B?dE9jRnJhQmwwS2c4cDYyOWY5MWFzMlllZTRDRTRVUi9zR1RnU1BxeFpRTk1Q?=
 =?utf-8?B?clg1TWI4eDkrNzZuK05zY09ySE1YbWlWRTFwL0taSC9PVkdqNzZ3OUp6L0pF?=
 =?utf-8?B?VmlwaGVZOFNzQk9xenVXaGlWT0tzdXBmVzA4K0VlSkp0MFNoelNvalVmeFNR?=
 =?utf-8?B?M3YwZ28zdytadDBETUJSMEcvMURYTisvMjFSOWJIRjRrejkxZ3NSZE54djlL?=
 =?utf-8?B?T0V1QWJ4OEFRcTNJczVHUnVQL08wTngxdHlTYlBsUkhsNk5JOHp6YkVQc2RH?=
 =?utf-8?B?eC9BOUxQQ2RCNlNuV0I5czhLM2MwZElwdmczOUJEV1VsRWxMYmxGM3Zhck9j?=
 =?utf-8?B?Skh5eXNoNnZiSGtEQUtaUkRxZmYxMHk3ZTJRWGRabENGcWVLZ1JkT21wUkk0?=
 =?utf-8?B?Z2NoU0VibWFLQ29NeU0vNlMzeDZ0VkpuSGZ4NmdPOHB4R05xL2NaVmFLL0FT?=
 =?utf-8?B?Nk1CL3dCMWxtclpCUktSU2NlWnVoVzVubWltQjVwclpGc0s0VEpGL0VjdlBw?=
 =?utf-8?B?aGM4bVVaTXAySzNud1djYytHMVZITDZYb1FKWmdTd1I3byt4YjlBM0drVmRl?=
 =?utf-8?B?cSt5TjRwZWlhWUdpbzBoaE1YcGlybUJUbTdWS0kvd1FLWEo4K3JiOE1oMjhY?=
 =?utf-8?B?R0tSeUlZeUcxYXlXem5FVDRzZXA1cTZiTGVJUjVMN3NjaTlZeEZvQzQ3R2Fj?=
 =?utf-8?B?dGJPdG02UGdGVEhWUjZyU3N0dDlleDRGbG1TaDNvMlFTWkxpeGpScTgwZ2Uv?=
 =?utf-8?B?Z0VaS0JaUGtpQ0hQdHhTS1U2RXpRMHgrMFdwWkhHcGQ0UWFDSWw2NGJVUTc2?=
 =?utf-8?B?WGZaSm9DYzUxeUV4ZmpyVUtvVFNHb2dkVHovU0UycWZjR3RoQkZzUWVSbG1O?=
 =?utf-8?B?S3V3eTVmWm5TeldWMDIrK0FIN2FzQjZGTVREd2VXTzRONHRiaWJzelRBaUhR?=
 =?utf-8?B?YnlSdFlaaVMrY0kwS0UwSFFSSWNPTTFIbE1GRWRjVnNLSUhFQUYzNDREdDBJ?=
 =?utf-8?B?RFByMW95ZGpjRzlYUThkb3hGOENGSzNBbk1FRWlxMEc5c1lZdFpMRDFBZ3d5?=
 =?utf-8?B?bW5LQ2JaOEtvb2NRalI1TnJsMGVkbUQyTDF5RkhNQmg5SVY3eTFCV2RwM3pH?=
 =?utf-8?B?SnlvRjR2YUVncEQ0czdVM01ESXQ1VnZmdVNiMW5JQnpEcmtCMWhINVJ1ZEti?=
 =?utf-8?B?MHRxVEZEaU5jZTIrNm1yeXRUdnlTbEc2QjBkM2FxUnVZOGhvRGpkeENERTJi?=
 =?utf-8?B?Z0ppY1h6VDN3N0ZjcVFqNEw0dHI3VndoblBnWFFyYXlkOGtRTU93MStEbEhV?=
 =?utf-8?B?cXVPdE5VVC8zb2VGR3dWdDJ4RjZNbnFsUXI5NEVCeTltNDhqVE9tZkQ3ZE82?=
 =?utf-8?B?bkVZSHhRQXFpTUhUMTE3dkR0N0p0UUFkc0NKaEMxY3FpdVRBRjhBOXJpUm1Z?=
 =?utf-8?B?dDN1RkVxVGNScEMrOWd0dG5veHhhcEhmZG5zbUFiZ3NtVDF0N1c4ZDNVVzdi?=
 =?utf-8?B?VzlsdmprQllkM21tMUh1eExDYWJlVVNZTTZ4OWRZVVNYNjJZSFVNT2VSaTFz?=
 =?utf-8?B?UGJDbUdWM2FXMW1QN0lKVldNRDF5bFlBc1poOE93SStmeDhib1N4VFEvR2JW?=
 =?utf-8?B?S215dDQ1ejNHVksyeGZoOEJWNHp3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <749EE9B4BAAFF448A4CADDF822881A05@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M1QN1LuiipgNkCirLePdGYmk/eO/TUOtzG96gzB+O14xfXylvc6D0MFeLeX5YfETOsIpdfqWHDxqaN1TKDRvmxbcpu0sovhNlFUJnBQ2tSeqiKGzn2EWBD27a2/IyAYtynLJezssQnf+Z0iPdJBgFSSAhgGCtT6MSNGbenPHoNrmVIeaiXmO+xQ+8Kb6KGmQr+Dg8oktT9FBQ7oT579+0C68KEKUlaf52CCPFhf7sGFLWBa3bP1fftgUG0GspcUaJ/d9y3u6pz5a41h4R5SitiFaouDbMYFhlJuHn/cpN5qCOL4d5YtgYdy/YuwIOVrWSCcYi6frIzPgJbkcOxxrtu0M9bA6ARspgXVGtDybea6oH7fqGweF/ZB9LPwU1doAu3pI15kef1x/od89DcsswN5mAsYQXgvRDp5sp2Tjs6k8KgTKVBKv5CF++ZnwcqV7jIdNl7Sv5XXRoLaaLF5apxwkJKvnixJn79tWOZB+JbkuSJljEIuzsGsnGcZEpa9Bm4ZO59eDho1MlaGxUWL8/D1kuFFcJH9p6Xh7ZH8bgZkefXiwzBvPKGKKvkve/2tM5Xw9F71S1EV1jKHBuDf+tnwkaBijO1/NMe50/4Eb15cYtTwp5TEGugi2c+j1mJJX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0f87c2-dad6-4817-c7af-08dc57e339ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:47:41.6538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C/HCklDU89O7OS5Dii+nyFeoTeptZ5pe/RJtjlUklKyJGusAFrz09p+Hx744562MxdiLBtsE+jxrvRusSjTs+vY/823/lVTZazyMqkouoUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR04MB8984

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
