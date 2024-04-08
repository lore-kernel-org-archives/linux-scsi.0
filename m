Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAF51420D0;
	Mon,  8 Apr 2024 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591469; cv=fail; b=U/9zz2vkyb3BYBrjBhSuYt7U5Cwg/qMnal6L+qWFufgnDfMPXg7Vtpo8RksZaPekLzu31cAjAcYLR3GZuTN3yzt6ipVyQqgR/4tBO4oAziAaLYzb+Umb/p7CFIJK6PtjNtFzawOVvLC/ser4cq1xy/lGTMiI1K0g+uJXGyopv2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591469; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fg/Xw6vTbscfLx4ORATojHAIGpm6/hxuKx2z0KByOuuzeO6vvURWn9XCj3rRlGCMeOguxOlMfxDyCMH9vXBlwQP/GdJL4hvPbI2xh2eF3BAA4CjyqRRnBgYR5TtY2qZ04h/ssIsj9tQRCRPI6fhIVo5hWGXEmF64RZh4fDHAcRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ofa5BTIm; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=u9KA7uW7; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ofa5BTIm";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="u9KA7uW7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712591466; x=1744127466;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=ofa5BTImF6nQWHrMMtvQg87Z/+f64BokV7PKTI4ZlDQcrSmj1zNpoyeR
   xEhDMw6bLuNWpPXUgd3UEzKw7s96BecQhRMtN5RvvTtnSg/z7esuwitL6
   0z1hBal35PcDbfJ5JJMFmBoaaWj7q7D64A6yLPhqjpZQgosOvPkbcEdWj
   QtL/U9tiPG4ZZYp3XZGJriQ8evhvGsmo7+4ReN//mkH5gs4j7dz5EDRlm
   fDYb36/JGK+kMU1OHCBbpK0ESLpjNr2rnyQ4GjGtrJcbBgwBGsodZr9Rb
   enGYV2C2IaxlGlQbnbFew+CiROiYRMc/n2bJwCiNtVvbj8uR4u+9i9rfm
   Q==;
X-CSE-ConnectionGUID: 73uNytjfRk6OwnG9wL5rFw==
X-CSE-MsgGUID: S1XcKBn3Tt6Q90pQR5ZbYg==
X-IronPort-AV: E=Sophos;i="6.07,187,1708358400"; 
   d="scan'208";a="13765128"
Received: from mail-sn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 08 Apr 2024 23:51:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gow83NwCNjGledJyEgLD2+nUvAb36vn7kREfvAyH7vR0JMgZi14Uwrr4uKnWEvXqYwai3cdkJEIm0w6er2d+C5Die9m+ul2418ocV2jzbJvCMNtRfn8NGDq4C/QfvnONM5GBOUyYW6X6i5HqJLrB3sjGCo5TVHyFjGegubxGfMPPd0eIiLHtwr/toEkILRXYxfTsyyJiGkuDs8OuQN9GHjhd+5cjEc7AHO8fU54rUWoM94wzN4dyJUEPHvoqNNPvlJaJashGup0A/CgKT28FFCQKZHY+Sew3BjnqGuBxenlCyB4iJJTfyDg1hPYXbPDnKgDkL6Z0xHc23b2NqaHf8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=kTABZ5CCTFIUmZlqohtpfQxvG/tlWP40RMBBPBUOjbCPPaAcZ+ZHx1DNWdIRJ68YsKMIZITCJDqJnyulw7E3VfMzA6n6l708sF+KzQoVAePZzAkHw3BAigjZ4dyqPMbwE15hK2xdsP3v6lqu2h6YiIv8rfbNYptdtZjE95T/W7qcufdcoMCx9BRzFwWqmCfTOLIfABqOq6d1fEx/cKYDlCyxnwVYxOHFhWhImXDurc9yiDKZwGehmMSzcJEbnb+N6slfQHW1XpBO+4eYmDGh3RwSpMDasPgjq38syStWJEkEWR3y4AfchDMuu7bd0amB5y1yLNHiuxEB9NgO2Y0kag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=u9KA7uW7evuNwmwz/IdzhDYZitmiNOcCMQpoAS/ccz9Ux7THtKBY/yJiCHnbu+Thn8dPSFQzQVcwOhYnliX1//5zGoGPRf324LYv/7oYbYjdqRhAvqDYLy2FfegU7gsXbtkFm0Ryzq8Fd3SAgWh/PpswZTbZV9Lx1alkTss1j1M=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB6515.namprd04.prod.outlook.com (2603:10b6:208:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 8 Apr
 2024 15:51:03 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 15:51:02 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@lists.linux.dev"
	<dm-devel@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 05/28] block: Allow using bio_attempt_back_merge()
 internally
Thread-Topic: [PATCH v7 05/28] block: Allow using bio_attempt_back_merge()
 internally
Thread-Index: AQHaiVX/+fatva6FpUCTgmdggccyxLFehnEA
Date: Mon, 8 Apr 2024 15:51:02 +0000
Message-ID: <031c1661-c7bb-44eb-9bd5-1e2e23134f75@wdc.com>
References: <20240408014128.205141-1-dlemoal@kernel.org>
 <20240408014128.205141-6-dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-6-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL0PR04MB6515:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Xul8sf04mZGgjZoCoMI+gHmadSRMuuiWM6i1stMidSWODQ/6hVJ6rPSmt3X3a4xMeR780Y2Skap4VaG6fAyYGtx0cBwJ6pumHp75sESN1us6BUoKI/RxE1JN1V09kQX2d83lhAREphJGVDYv3nRjR3os/3QpjGgcPsWednLevxSCcXFH+FRBnTjdseQA24CZLHnebZPPoDW+IKtn5m5cYRfE1+YIg27i0PDlnhomvMJA5lX7ExCeIgym4IAQFz1A8Jd1UzSfwPL60oTnDWjr2ygY2yG7bufiw89ma648m6tUnZOxPkroeMFN6qa0C1qEWDsHfTZTbbmlwfB0CrS/Gow7T8rU4aAJ8oe6/X6Uxi5z8xfuX69+2PT87G+GV5CgzcqoYV+YHf0ZquuU+sBnV4zDcfdJ2DtMuJ3kHjdPwTdPxmuAOAPQt05wxxLgwP7/OfscVjgij7VtPBtFqLxofXzqVdHMwYukxLtCIYWx/GAWDPmvqAPLdmt/WgaoJnJr4Zc48ez9CmiCevuqVyEdG5Lt1DRVxChP3zRnFkYGMQE61ub1YB0pkw+9P4gUYO2DMDaEB0QAVgJkpoUjgs7oBebpbnj90gfJLDQ0tzuq/98S+ORKdgK8VVCWZRNlFdru3DG/XaUpqSGOF8/qWOsDG+Wg2R8dXgkdVeNw/HAkZIzvgNbdY0wBgUeZyWQTZ+tKBIvAKbhIztLw02kKHMJG0A==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MzN4SVR3UThWb2dWVURrZTRJWmNLMlhBeHJ2NVlmTnErSHplUUtiQnRpRGFK?=
 =?utf-8?B?YWJkM2lETFNweU1LSEFXL3FFWVYxWC91S0l2VnVXdmREUndSMnVnMHZJU1Vs?=
 =?utf-8?B?eTNZU1kwN1NZbUFlZGhwVW9PWi96S1pjbDlISzZ3MWpnWnphaHo0Zmt5TU1P?=
 =?utf-8?B?MlBZcEJFdm5Sd2lmeXBhOHBnYnZBUndrMlB1UmhZQlVTQldMUS9QZEc5RDg2?=
 =?utf-8?B?N2xqUEdxQXNpYjhxU1RERmNwMHlnbmplL0JQZWpMRU5DTFNwUTdRc1FIbXZC?=
 =?utf-8?B?WWlNZFg3ZVQ0NXk2WDZiVXM2ME1GbU5rM2N1eXRoeGRqdktBQjBYemJOcVRU?=
 =?utf-8?B?TDhtS21LV2lyV3ZRUlhaK0paVVhkSStabURxZXlTcTdtZDhTYkZNYmdUL2d1?=
 =?utf-8?B?dGpZTFhmeS96QjYyTThFeWc1RzFIdmdJU0s3cG82V1dUMGt0Qk9zTk1vblZM?=
 =?utf-8?B?N1hCUk14RTQyNS9JZ2FsS0FCY28wczdTM0JMWHRvY2wxS0tzU2N1Q0pKY2hT?=
 =?utf-8?B?bTFEcXRkckVmZ0pLZFhIUTBSRHM2REc4aE4rU1JXbFR6VVN5aGwxdEh1Rndw?=
 =?utf-8?B?TzlsRzUvYVozSW5aZitXQ3NXdXNKNnQ2dDI2RkF1MTEzU3RPVitoR09xQWMr?=
 =?utf-8?B?bWkzb0M5OHZDeWFMTTV6N01OeS9Gdk5tL0luSSs5VzRoL2hrdmt3U29ERWt2?=
 =?utf-8?B?WFlmcHMyQXZJb1dLOWNlcjEyQkNMb2JUV2Noa1BOaDg4REZjaWVFeFBjWkgx?=
 =?utf-8?B?SU81VEIyaDR1ZHVyVGVQWXhVdnF6Y3UxSG9OR2pScytEVnczNlJaOXM0N3Q0?=
 =?utf-8?B?cmxrMkpMd1c0eHFkcTVWSlpERWE2TnEzNzNsZDJvQzFtSDI2d0FmK1dCcEZK?=
 =?utf-8?B?cWM0a0VGbE5lVURPN2FJMmV6ZERSYzlsQ2I3QUNpU3B2Y2pRVmQyY2NWV09W?=
 =?utf-8?B?OHB4VVVab0tHWEd1a2V0THZvZHpYTlJrd29RR0FsTzdzVVpJbXlBVkN1TDFD?=
 =?utf-8?B?TTRCemU1bWQ5Y3pJYXl3Y090cmVadWVyTzl5WGZMRlNEenRaQjdXcmdSdkdX?=
 =?utf-8?B?aFErMlFhZnpObFRuWVZYTUo0R09oeUZERERyM1ZyRGlpcS9OT1Y5T3ZzQVAv?=
 =?utf-8?B?STdyNGJxMmRMZ2h5Q29LaWhNMVE0RFNuMklScU84QWt4YzVXR041VFMrS3RD?=
 =?utf-8?B?dnFKT09WSlMwdGh0UzJpSktrbll5NldWS2ZhSDE1VUdrdzcwK08xQzRHREQx?=
 =?utf-8?B?b21XUWJvZVF6L2R6bW1MUklVeFJmUnFxQUMrY2grTVhKVVpsSmdZako1N2pO?=
 =?utf-8?B?bE1nSDIxeThMYVJrZ0JpU29EcTRPMlg0Q1FKdTZHYjNjVzJFNjRwSXdLNXRJ?=
 =?utf-8?B?NmJEd0dCLzkrdkRKMHNtT1lyWmtnbkVpOCtjTjBMb0N1SnZZNS9WVjNraEZH?=
 =?utf-8?B?bGxBYjFVNENiUHlYYmpOb0NiL0hzRm50S1h2dS84RXVTa1hMb2wxL0dXWmgx?=
 =?utf-8?B?NnhvbDA1UDNuTGFJL3pvM2RBVzE0bzZpZk5mcG9ySDJaeWFEbVZnb0hhUlF4?=
 =?utf-8?B?Um5ZNW9JWVJiNVR6czFXQUJZWE91UnJmS2tZRFMwRFpUMmJLdFc0VjFGZjJq?=
 =?utf-8?B?UHNvWVVZeFEvTWxuZzRuMXJhTzIra2taU0dQRFVmWjVxQUNiUGZNT0VORGhv?=
 =?utf-8?B?eWV2K1NzMlJBZ2N3OWViVFFFVXBUVmMvMkhNYjZpTk95aXZVMXltWDI2ampH?=
 =?utf-8?B?SDhJN1M0bzhNYllHT0NvVjhpQ0tESjVTVlBmdjRMeWtkRnREdWs5cUlUZHh2?=
 =?utf-8?B?NDRxcytYdDh3L3Y3SFNSMERxN09UMGZqYUhzNVkwMVdYeEtBRm45QU9NRi8z?=
 =?utf-8?B?VXBVT0dUNHY5Qm45dUJWMEhGRmFvQUNmb2tNd3pBSzBEaGdXRmQxR2ZZYUdE?=
 =?utf-8?B?S0NZTUxsOFBRdy9pYjJ6cU12MTU1Qk1CZU5NYWYvVy95UzZpZlNiWlA4RWtZ?=
 =?utf-8?B?eWQ3dDdRTjZlUkVpMGRWT0ErTVpSV1g4NDRRalpLRUtXUTVnYnNYYUF5U2Mv?=
 =?utf-8?B?SW9GR2pMTXZ6bFJERi9JanFCLzRpSEhUNUdYbS9MVEdBSFBjTDQ2c3VqcUNW?=
 =?utf-8?B?TXpMemxqQmlVOUg3bng1eE1zalpocXA3aEVFR2o4aXlnWGdzZVBjUUZITHVO?=
 =?utf-8?B?SGVPd0NreHk1ZGVvMEtlQWw2aGJQN1Z2VzBqdHlqZmpJNDNObStabjJuZHkr?=
 =?utf-8?B?ZDNOVEFFbmRISS9WblpLWWhyamdnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C839411EED05C4E9DD9FA036D91262E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xD8hT5asrSsrsRn02vJKhXQEan4lgbY0K8ir1yapu2OrEdXxxwcN3YUoiT6k4IkF9ViZQu50q4JKg8m6OI5kahW6RDv8NyujvJpnBnHs+1EWNpKpVJHL2I8VVE9CPWpixgFNanpxWgQ9w5SYdEYlisu6rsqGP3Hcx8XaELnzyGI4aTkBnH7lWhwVG2Lj4M/FF5yyBTijEMMIXoUwCdJWfABws8V+ne2/u/W8cL6+8g7hREDU4l6rYgMbqBlYuSidWOcx62BXRbavdAoAZXVK83bf+ooR0ksgIT7HoFEGnUW5MmFKZNA1SY8Kn+i2wY0jo0flUZHoqivELqcMQzR5UuDi2UwLH7oDsP6SoOGC+FSfFMxFf6Ezee+YUIin2YNbHVinio9AUoF1P6es99Uajrw5e241sJTAsOaI7sfcTSBpBKrIISj/g2XewDoX/dyiTw15L8s4k/hchDr1EIM8VlYRe1zRQySus1jqVocUn8HTtlqL+exVDCHMhFNFwP2OgqMjqzx3beVxZrf5+GMRA0ljjzGKwNDW51zM2gCUszB5256pDRAYtV/u02673b6mBfDvChWpRc0U12YWmsQUZStkXAKVEqzGNnyNiPm9u7FTVonPgRRCkOsKMw8m2QJq
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b243c074-f862-4c30-2369-08dc57e3b171
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:51:02.5825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2snlB0Ui8buQu5XBJUt4gHrn1VYkEJ1H/SaUjzfdxNsgdplFSk6ntcojOCdY+YfXNZH8A0UMlQ/9e6DqL4aqm4jjQ9Pz1sA9kZEKTDK2pE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB6515

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
