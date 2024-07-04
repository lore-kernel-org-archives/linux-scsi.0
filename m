Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB3C1A270;
	Thu,  4 Jul 2024 06:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720073244; cv=fail; b=uV6KiEJNFMfC+TftfSZJYe67DTiIoasbUK1NBkJkZPUlHrESABm8YO1oJeUj70b0RbF06tVRxy7rqUD1rI8tJrGrH2Ul+EIxvEk+yOauehOUwAOuynZNnSIKh8kOx7/mQ8hRRJMWC/Mfvrxktt+PIMSGfNgLN/B7LCuPUwM3b6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720073244; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bqCeogJfZVXQ6PFzsQ+Z1CaLxFfJgrHivcjf7XxxWkgPs7zZmjsckQkk64jYzzWSqHED9LzUNLfguHQYCmi46nIOTyDhvAIlm5+DngXZ8xw6H/FbAA4C44HYE9MNAZv1JWO3DLwhPTpvYk6OWKMfpxHMGmdX8l2U3CP214tU4do=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iJefpJ3l; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nxLdLxu8; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iJefpJ3l";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nxLdLxu8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1720073241; x=1751609241;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=iJefpJ3lUitBhHQ07/dXtzSZx7kTDJosu037+CxNIjLkgAmbM4m7016U
   S7Gqf7vMR/HfiixbafpcGYGfFOa0Uhee77S0vKUR/fWnGSv0zMuz8ORjh
   Q/mJSEI8tzFLSbA3GWo1aBPCLWkdmQ4YFBieE4NLkxe5J9zt6GV4zOF8y
   gSC8OLz6a/LNwI2gQnNYsFhc89GGJ6hW38zti3Is4jzhOxaW08kINJ/tV
   ENdzgjzMo6gkBRCNnVNlR6lmdj3vskFEgPFFTSDQp3gU8ySf8uc1eJumd
   XHpe0vnz40PJW+EQHcDFMRCI9lZ8KOniKnFdTLe4eMMTM4bpr0tcnucid
   A==;
X-CSE-ConnectionGUID: 6y0MHE0eQyG+Cz5gO2BGVw==
X-CSE-MsgGUID: sEyN8sRqR6uIrJatIO5cXA==
X-IronPort-AV: E=Sophos;i="6.09,183,1716220800"; 
   d="scan'208";a="20532504"
Received: from mail-dm3nam02lp2040.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.40])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2024 14:07:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWp8KbQPpJTmSfU6E4l+0XaEJs3weehCd+9wBuwzlldbLqOcz0kEsd1UcaQFLfS40tgv9aCnCUFn4n1JxC992d+eDROlH12qol5XjIu1zSGY+NiYc+3oyALbo261r5m7XE4if0j8MHduWaE3jBg2K4v1LbY5XxMMXsnkhETi8oVhxBwf8PTZeVH9nuRUU4f2gTEJhSB2YIuuACbipDge2QClD6RHO1YoUu5g8HiOeQAkJo2QC+4sUhQW1Gzvs8pIprkjI/bz92k3AN4NXS8ff0vE6uvqYhHyMrJefxJPtMCW4B0eyj7rBJFoWYjiiSUPwnuKRy8efAO/gjgJuBm2kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=OGdqQxmbn3bhhgwHoiv6PfbvrmwBsDC2w/rXWi/EE8VPwyfaLdrsW+UEhlVxNTKE1Xnvd38Bp2zLHQqf7M7KFc10snACzvHIjOM8D0pzw0Ec/1KXPB/LiYmJJ7NZlP3WEjmmMCqL6Mwc3ab2aWlGOBLCC+Na6snT+FSBIEJzgSFRH9zE1rDNubDZiZ6phiLW7+ghbcMSn32r4GNmgshHk42sjZ5eyGE8V2yTAtvmf6CkSLHqvN0Uv+iYmbtWZGkudXqd2md6DaAI6NtV0XwSkwiONdETDHU2A+4EraCMiY6J//VzkFeVKBbH6xJAg92oyH2vGSSJw/I293vC0mxAAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=nxLdLxu8hRz73E0vBQhr9CcGNiukvxsawE9X1zT4FAtgl4ridaycygKDbOtkzEiQfCUSUlK1zkt5beNZ7qk+wx+LWoNCvBuOq+mrW/yWlIQGhljljS2nwKY6fnp0u2YutlLRPTbuC+fSa2xiV0Xf4rVbY/sGeQED7gL/0TrcdSg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6329.namprd04.prod.outlook.com (2603:10b6:5:1e6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Thu, 4 Jul
 2024 06:07:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.7719.029; Thu, 4 Jul 2024
 06:07:16 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, hch
	<hch@lst.de>
Subject: Re: [PATCH v2 0/5] Remove zone reset all emulation
Thread-Topic: [PATCH v2 0/5] Remove zone reset all emulation
Thread-Index: AQHazdMCckqZNsbKDkqPDkR5jKRB27HmFTAA
Date: Thu, 4 Jul 2024 06:07:16 +0000
Message-ID: <92e51405-f8c5-495f-8263-127142d08e35@wdc.com>
References: <20240704052816.623865-1-dlemoal@kernel.org>
In-Reply-To: <20240704052816.623865-1-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6329:EE_
x-ms-office365-filtering-correlation-id: 91177124-dc18-4d09-f2f4-08dc9bef8e49
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?utf-8?B?amttd1dsQmRnbkp4OHZiUkQzdzZzSExvajNnbERDOTk0NVdadmdwcXA4ZDJt?=
 =?utf-8?B?VXlaZUNpTzUzQ0NPQlBCckk3eVBiTkVBQndDZFlOWXlvTGJPVzc5Y3Fpb0Fs?=
 =?utf-8?B?TFZIL0NzSm9DeTY2anV5QUN2V0s5ZUJZNjZMMW83R0JIME9ZeitEOGFCWkly?=
 =?utf-8?B?ZjlnN2hUTzJDR1VUcmYvbXFmQlIzMitWZFp3UHBMRkNWS2MyWXRyZ3Q3WkxU?=
 =?utf-8?B?S09NQWNoVlJqcXQwQlNzR3U0UzUrQ0VzakYxMGUySFEwK010Yy9ubWFXTE5N?=
 =?utf-8?B?bjVTdGtSUlljUlZ1MkpFR1QvTzNENGpxQjNjSXRvblFWUW1HQmttV2lOc2J2?=
 =?utf-8?B?dDIvZy9mTzF5Zytaamd2VnFuL21sRmlhUERndENJMEVjTGNCaHRUeXlFT3hO?=
 =?utf-8?B?dHFpdDZNdTRzUU5QVmMzMlNKRGdMOWJlWW1wMHg4VE1ncWl5NmFkOU9yRG45?=
 =?utf-8?B?RlhiTlJOQm8vMG41d2IwQTIxZmYySFN6MndoWHNUZmNuZTFvZTdubEc0Q0k5?=
 =?utf-8?B?anJsQmlVNjVFRG51dlV1RVdCV2dUSUVpWnlNWlAzaHVmcDk5eXZ4K0Y2VGt1?=
 =?utf-8?B?MThFTWMxMHpXajB4NXZ1dGpzNnFnMjJ4blZFaTh0RlREMHVaY29ZSGc1NlBm?=
 =?utf-8?B?SGJvb3VPVTBycE5VU0ZnRVMyM0RGNUo0R1BtSE9pSFlnR0VhWXFubVpvQWh1?=
 =?utf-8?B?bEVtV0V4QmhMOW5LT3VCVXdnUFBCVVM2bmlINytWL3R5K3QxMjM3UFVTcUhD?=
 =?utf-8?B?K3hzaEhBYWpnMW1zeGtsZjVybWo1YUoyWDU4ZEZsek5iNFl3T3pDMkcxNk5M?=
 =?utf-8?B?M01FdnRNL2FuV3B4NFprT1I5bmVLcTRVQ0xwK3ZWd0RodU90cm9rVlZva0Zw?=
 =?utf-8?B?cnpwaENKOTY4U2Zwcy9zbDE4V05YbFlZMitDOFY0emZsQ2RlU25rK28vVmhP?=
 =?utf-8?B?elMvVkw0a0dadjI4OXBBdGE5VlZtZG5VT3dBalJPZFBucWRBWFNtUDFTYkx4?=
 =?utf-8?B?bEQrc0N5OURCS3pIaVpmWTdldTJFbXRIdHRycmhzMCtKakV4OW9ZNFE2RFdZ?=
 =?utf-8?B?N0wzNkZRaWlQQWgyOXd1KzVyQjlBV1J4RnRtdU45c2Y4Tlg3UEs3bnpULzZh?=
 =?utf-8?B?eFNObEZ0U011U0c4YXJCQkFHa1hud3d0RVRFUlBNd3NxRG51ZUpHT3dHZFNp?=
 =?utf-8?B?eW0wQ1Vvczk3Umpsa2d3ejZzUUJzN0dtNUZXZkFyOFhKREMvbmhGMXVYMlFH?=
 =?utf-8?B?c3hNN29WZkdGcHpDa3RNNlN5Q29NYWVhREgvV2xkQ1loa0dlT1c3RkNjNnN5?=
 =?utf-8?B?bkVadHcwVjRMbmEreVZSZVZURkNLb28vT3hPN2YxT2NFMUZCRUd6WFhqeHVW?=
 =?utf-8?B?eVJ3enI2SGFwZlJneU4yYi9BQlg3a0hMSkhsQytqM0RtcjllQjVIcWdVMlFo?=
 =?utf-8?B?cFkxQXR1NHlzWllCODV6cVh0ZUdEd0lEbFBwS3pZL1I2cXVOZGZDK0xzdEwx?=
 =?utf-8?B?bjlxRGsxdFdYVW1NZktRMFdCRVV3V2JSQjg1M1Q4djMrL3hqczVJVlBNWnRa?=
 =?utf-8?B?VDBtS01oRjRmQlAxRitRTzR1alF3M3VzWlhaSDhNUkNXbUh4SXJscDBhdVJY?=
 =?utf-8?B?QWw4WWdseHY5WlZqajk1VHBGRVB3eHQxVkpZbXIvQjV1Q0ZCRklTMUQ0NTRu?=
 =?utf-8?B?b1pRTXpBTU1lM1o4VUxkNTVvQmt2QnE2L1laeUNIOFZqU3B0RGVpaTkrOFZN?=
 =?utf-8?B?Qmp0VHNUdGNQM01RVU0zN0wvS21SWGN5Ym5qeEN3WFdBekhBYWllVmg2WEd4?=
 =?utf-8?B?NFdtZDd1UnIyTEtaZTVJdDhXZ0tld0Y4dXhOalhYeWVVaEhXYzJNQ1BQdjQy?=
 =?utf-8?B?ZGxuREtGaFIzd1FQNDBDMENRZjRzdTVIY1RXa0U2WTlnK3ljUFU2TmRlbmh1?=
 =?utf-8?Q?Wd4xQJJH2uI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RGdqb25xdEVYd0ZWb0wrRHA1NnJHWXJNTjltNDROamlzUlBVSmhNNjZRM0RO?=
 =?utf-8?B?dUE3U0gyT0ZuRUs5SkR0OWkxL2RpSmNmdC9jRXJTSm5CU05KUGxBQlNlcTk0?=
 =?utf-8?B?ZStEZ0Z0UTl1RkNTVlZ3R1Y2WkJ3N3ZjV3hpVk1pN0NhZUdMcUZod3BjV0dU?=
 =?utf-8?B?Q0RDTWd2dzVRaEtIc09XMDBFQktqSHBUbzh6bXBHWFc3NkFSV2NTMTA1cHVs?=
 =?utf-8?B?KzA3VHpvcUhDSktDWmhHOERkMU1qbzNvSmlDZGFVbWVVMlhkWkRINkQvbno5?=
 =?utf-8?B?dDlzMUZhUk5zVUJRdVBEYy90UFh4RTJVa2xUdUZEL2dRRzdVdmlYSTlONERx?=
 =?utf-8?B?SWwxZCs2N2N1eXpRd3l4RFBlVmhqY2VZT1ZWL3JpTndSL2IxaDVWazNoMHcw?=
 =?utf-8?B?WFVBY013Tm45K0FHY0FEUDh2YVZUZGNka1IwN3lFMU5jYStJWERtbW5jUmZN?=
 =?utf-8?B?Q1NsWS94dzBZeUZ3NU5ZcUwxVDJPRDNuRlZYdDR3VUJsNk1oVDNMNzJDYW5F?=
 =?utf-8?B?YURmTUZDYzF3RXppZ2p3NDRzTTFDQ1hhRkxNMld6VGpZM0h4UDZvc1NsNGhO?=
 =?utf-8?B?MHpMaGRmKzRMajJZVTI0Nmp0TE5UcGxDZkczQVRaOGFhalgwQTRFZ1gxQnM2?=
 =?utf-8?B?aXczRnMxYXNpWmdzZjZrMExsK2FMeTNNYjNUTFdKVjJHM0pxeGFMM3Z5R0RK?=
 =?utf-8?B?WXZNdVZVdFcweFc4T1hFMnlFRzR1WFNrY0FWcWlJSkVkZkxxNHVzN2dvanBz?=
 =?utf-8?B?VUZ3MG5VdjdsTjJBRkhyN3NvcnppYU9xUFlvS0U3Z2VyUVp6MTdKODdGejU3?=
 =?utf-8?B?OFRsS091YnVFanpIYjBhSWlPbmsydVRYOFNVcjh1Z2QrenRoUkpuTFFMcFZ5?=
 =?utf-8?B?RU5RSXVwLzBYdGN0anYxYTVZZXZJdkM1ZVhPMEVnTVIwTm5CdG5DREVHRkpP?=
 =?utf-8?B?UEIrdVo2bzBCWk9mNVFzcUpjWWVXTUlTcFQxQUxyUy8veE5PMnZhT2svNDUr?=
 =?utf-8?B?Z1dFaEZkdzhqdWhKQXNLd2pGdE50OGozbG51VVBZMXFXN2xtZnhjL3d3djY1?=
 =?utf-8?B?OHdqVVNndXBPT25TMW90WjBvMEFWejlxRkZlWUdwRnh5UnNLOHdHVVF6Qngx?=
 =?utf-8?B?cGF0ZmxBVFBuVzJmUkNrZzJQV1lyTlJoNllaeWxIZEdVUjlyS01XeENaeWhN?=
 =?utf-8?B?TWdyanBVZzVsZnZGNmFaQ0llYWJaSG1qbWlvbW5WMGJlajZjS3hNeFNjZHN1?=
 =?utf-8?B?WndxMXVSNWN6eWUxN3lZNVZVaVdjN3Nnd3lBMUczYWVvMkZ4UmZBV0pCNUJ2?=
 =?utf-8?B?SFRXNmRUQkdlRXVvNWxGWCtVV1g5cHlvcTB3dG92Y254a09RUTV3a2ZaQWVu?=
 =?utf-8?B?Um1pVGFxemRXVVgyYW1vOURFMk83ZzNNZHBkcTRCaEdqUFcvU3h3b0JGTFpr?=
 =?utf-8?B?OXNTZkYwL21TS1NMZ016KzNsYkV3MVUxRDkrdUpvMEIzdEU3TEY4d0NBM0s5?=
 =?utf-8?B?NWhJMHg4OUYyUldLRE1pSVVNSUNPMEtvS0hXa1hhZUUxS2hrblRBYktqOTRw?=
 =?utf-8?B?bVc1Z0ZGSm1JVFJiRC9FNm9UN3NBY29kT2FXcU1UNXhRMFJXdWRXTjlEYXR1?=
 =?utf-8?B?OVk5NEVWL2N2bzB0NlR6T0VkQWZoOGR4d0ExSGczZERzMjFMT2VyT011aTNL?=
 =?utf-8?B?RUs2d1JROVpTRUdUOUVrNi9rdHRiY0JPVkpNbjQxbUprMVdEbzlRKzZsbm03?=
 =?utf-8?B?MmdpSmxmZHZHNC84MDdXS3lyUWM1clBLYm1lWVhLRkQ0WUtLZnJGQmNtZlpq?=
 =?utf-8?B?L2hJQlh2YnpKQ3dMQUlyUEppVXQ4S3p2NzdyRThMRTJoMjFrV1o2akExSkFK?=
 =?utf-8?B?WnJkK0tFQ1Y4bStSRytGYjVCc1R3SisvSjBRdFFoK1BmV0N6ZVBKTmQvN2Qv?=
 =?utf-8?B?ejZqU3l3WXpLN1RIRjU2Wm5ienBsd0NjenhXQmYwYW40cmxSV0NYT3Y3RXRI?=
 =?utf-8?B?QTNReVRQS2xwVi9Bb3BWL2dTR3dtenZJa1RUM3ZVT3RKSCs1Zk54a2tncFAz?=
 =?utf-8?B?MXRqQm00OTZnSHVKSWdXaHNYaDg2ZWhrRXZHR1dCd1dMNjB4NjhlS200VjZE?=
 =?utf-8?B?N1VWWllLYXFqdS8yQ1JXY1c5SjJQUkdYTTkwckFiUWVld2NXMldodENlai8v?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10A7F86D26C8EE46A2B41F34F9DD2971@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3OVNpxiJyWSLCYdGZ4m8zkoBjWFwEQrvget0YIf9JgSEsqASjJrJPSmPiYmo1SOnofTb36HBO+d2M2es0H5g3D3B2DV1q4ngzYWldEr/fkk4bsileOOHI3O6PzTdqD4XWMrfVr9Rs5qzMQUuiGkDq8jVfYztemObxHQ3ZpRlipuLGs0YwnvOz8GiY+8NHAfjUnSVAd8j9VAXcjjiPy48Ff2FZmj3mjrzdtg31akZN/FgVGKbl/CAJF0+Mj8iWVtzYlJS75ABthI0WbmnQsc0GXef9js3NKaIsOjQtYmfSOssmHYYMihT6RSjwqnKXL9N2GRFp30HQNe95pXeMXZoUJHt0jdVO0GxrJv9iNnr03HR1xWo6K5cB1OhOUTryMKZyrqxr5B2l2BvnZkwWT1uG7Jsim/zeph2iiX32fzS0TZl87KE7JPmyQJ0FD6v7jbCSORDeMPhwMGhRPLe4pwA5soeY8kMWw0qJWo/qpmsfsO8culYEAx90wPamlBETF6pdVfZL75rc918gvw8mTD0OmVn9wg9+aktMMpmsz49aJjNcjvxvAJgUsTN1b8bFsW+LsvKQ3AZxbfwA2XXfb102bg93uJddrM8Fwn3/FMeL3+N5cXzLOdCXlBrd2KinpPS
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91177124-dc18-4d09-f2f4-08dc9bef8e49
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2024 06:07:16.6241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y4C5x3Q8Ks2M2kKyT5ynPirYMEAsaxtrqa7k2A4RzNnAUp+Qi6F1fZzIgP8EyIFpkfHjNmsZgTEW7IsLGFhftpo2dpQQ32Nrt8ROcaYyNaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6329

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
