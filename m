Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E22139CF6;
	Tue,  9 Apr 2024 15:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675344; cv=fail; b=LFk0rnYiyqjoLb7cNlQ4DWtshSwaUCcUAUw5IIhROyPG+Neen+b9GoJmyubrhC7b3ZaCp7O1ItZ5yGRkjFrUnkMWJuv8omu0oJGkFWpYUkDgIJ4gu7qZBuAFpfh2QM8yJHjoPrtaUefOJr7VQDHd0+S7TtXQrzpsyy/ewW165T0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675344; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FGiwg+38abkHiG5z23ZFT6KDtBfVboDJBMk4A8VANpMJLzeD/s9QhtFbZgzKZ8w7EM0ZZdfT5oju+8kgJOoMrPmXW3CIVIgJNbhT+ttLnDuw9Rt8dbmpaC99/qLuCOWYLQrERnalSGNnp+PL3iapgJABbWZm+bvIPSDa20u1nf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZkNW51t5; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Uy72Rr67; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZkNW51t5";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Uy72Rr67"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675342; x=1744211342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=ZkNW51t5hN5YpD8rVlAbAgxB+TEodU8VQbb5sNjK8fBvf2FjxE8DhpQc
   OSI3hLm0mgjqi9Bukp9qbBNzIXpgjRoMkhvG399lFB4K4KPKA3tLzuDkf
   mZfBXQ+pBeMQmkdDUWvk4hpafqK2WR8a4IzCfysP9K+sYph7YSG/qG5jd
   wUG3+8TURz1JqCIlLSSY3Tw7N7UmDUATYATdH51b75T1n2lmRjwWflogj
   9Me71JeEq4kwtUMtMhhZ/VwZYytpOKAH7tYGbCyhG0ix3ct6B5Ar63rfG
   6nmG2pmnWEqE7Z2vzb8Btlv7siBJJkZ1jAUvB7n6KsPQ7XWnuGfMrjYpp
   g==;
X-CSE-ConnectionGUID: PpHAif9/S8Gef4923YLxzQ==
X-CSE-MsgGUID: SJC6Aht+TPq0dhehVwfVNQ==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13424885"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:08:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVX+atRiaqRUPw+jml+lQmeeq9o8ix0k+xU0dGNLx63WsvmtOOUYl/TYsUouOPqE4yQn8KB3OdvAAQkThtuDPMWT2rQ6Lv+Mon3T1wgcoZ67pKpWnmnNBKH9CZEi5bICOwR2WutbHUtPGQ6Y14UL/GjqrXsPY6Hy5PrvdzxAAR2CWEDx9CMqKQV1Blix2sux3mlAkA2SuIi7xnzAPSibG7qZvSJgL/hBHIiwTkFxnbNek3tS+pikj7Is34Lx5wzqi23T9UNhXN61UONu+UTxESSnmcrOIywrLpB2mwG0bvZ4uAUI26ZNqYMtZyxkzLk4VlK8EdVeGlIQOKSf8X1lOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=lBQjKiWt70/HFZ5gAuyVj6nPCE+Ax4pEfT36hkztwIq1JTCzzUDQetceIuu7VqFjr5uu+EBAjl8tmYACCLXTSWgNmXAcvh0zRrMNCIPs7ynwgDwoWVCTgSUep5lU9gb2cpmZfJcZZxYOXVIeAcOqPHyPSb3/qmzk+Kf0n9rE593j4VgUQ0EJTc01F9d3V94+ZD5jlukTbyrtoNaOgJR4BZLH3VyYcVAk3Yahsey8PS9VwxLQo8KKWghIvLxJgBNcpPXyPmk/BkRCafiOmebuJZMaaI9TNlpTahge6rcYhUuaSIotvwj5n/6XNVa5AJfuf8g8Vg6lDyqjaRFLmoDDeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=Uy72Rr67AFB9GfXkq8akiCeUF/pnv68SASLpppD+ZFkvweKkUsqzq3j4nwkFTFvHD2NWMUtf7WTtjztsV6o9olGDEAiN0Xf8/Kbk+ZCH46tO37hnhKLWgsgmsrW8wf1XPjOsYIMvcVRbJ0vFflVuKFDmgwny/emboZE/l6OWPQU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB7715.namprd04.prod.outlook.com (2603:10b6:303:af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 15:08:56 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:08:56 +0000
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
Subject: Re: [PATCH 05/23] scsi_transport_fc: add a max_bsg_segments field to
 struct fc_function_template
Thread-Topic: [PATCH 05/23] scsi_transport_fc: add a max_bsg_segments field to
 struct fc_function_template
Thread-Index: AQHaiouwYtEGhQUVmEuzsS21aXSkibFgCpaA
Date: Tue, 9 Apr 2024 15:08:56 +0000
Message-ID: <f9146b43-77af-4c58-a49b-07e9a8e3e11b@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-6-hch@lst.de>
In-Reply-To: <20240409143748.980206-6-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CO6PR04MB7715:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 MM6/471eUvUg5uyh0Qv1lheZHW+dF5kZXm49u1/MC2VL796QgipdEIJbelmvMZq5f6xsT3RW9S7A2ORmV0HOrcbaEHrZIOuPOLSZa9fE8bTMQ0aa+YZY0n+9wuk5LSZO6e//E5vqJbtbulfopunQyf5utsOztXbrYWiSE0FMQb+Ia6uNYt8Nnus8b4GLCtMRwbdB8Mf48Vac6qso8vCGIqp/vQv/CjjCbtEm+NJL/Votd27INcKLQ4IK9GVHNQxBg9kypZ1QL6IhhwDFG9Pz0F4Ys/S8rnJCYlugxumPvlxht5jUMp2Y3ijxmxJPB75ItSpW0YmtcAmCorvdJTe+2GN9sh5+yhyHPiuqm8CphkNMNQ5yus7lbnT+F7oPBN1iwNzq13JNXZGtX/LPfhd/zUl1627tGd45nAQUyaf5+9fauYW0hCZ7gLQ4q7Rkct5ft0Z4teyrAOYeRps8nI/HS+coOlb5Cw4DRIqXMe5wQDKdstexb3ZiuYVm85Jiz48qUmTSIhEoSz7/hUI+g0lPk955CEfxzEhT3OB7HERldem8SxhjYLznqoa7j/HMcVe566H/DtzDY+FcwyaHBCiMxW9GrDUX/WghHsEdHIBQhmu53v2pJStmzh4ubSjJLpK5yXf5ejGb6y1Kxdezgwrsc22w4pbnoJEuPU3JqGXrbQQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y0Z1cEFhNWl4NkpmQk5yWWpUSXAvRzNoeEZFcEsrVHVGc1ozYXluM3NYTkkz?=
 =?utf-8?B?eTZyRVBzSUViWjE1QnZkSFhmVVhGTGJiS2pkb0o3S2hhU2wxKzFlMExpd2hC?=
 =?utf-8?B?eFNydUFqcFFLWVk0NlFRbk9Sb3BJM0dNMTJYWlBvSDNWUi9zVTk4b0Y4WDBB?=
 =?utf-8?B?TDlZSzBENVgrVGE4bHJTMEw3QzNMRXU0UEZ5dDlJaWxUVElzZkZSUjV6RGxF?=
 =?utf-8?B?UFRaTno1Z2FUU1RueG5NN2tIQ0MxaGhhb0VxVE9PK3duVnpTQ2xySW9wM2ts?=
 =?utf-8?B?ZXp1bTl4dC91eG0rYzM0dG04NnRUMmdiU1gvNGw3cSs0amZwM05hM2dzRXYv?=
 =?utf-8?B?YzI1VzN6WFBYb2hsdDBuRTlKcjVieG1PQkpGa0lQZGFxQVdSQ1RtU1pNNHJY?=
 =?utf-8?B?M1NJWGlKVmVJYm1CTUR4L2Y4bVYvNytRSE96MzVXYjJjZFNqa2dUTE9mQVBO?=
 =?utf-8?B?NG8vMW5TTERrK2FvdW12Tm1YTGREbzBZWWcvQkJ0SElhbUZWZGFmbGNhc0h2?=
 =?utf-8?B?STRVWktzZExnc0dpUUY4SC9xeDdLeVVwRThUU3lKSEZuR21zOTFEczR6UEhS?=
 =?utf-8?B?OFlLekRFVzNROXN1Qmc3S3EweGZ2QVlZNG9hL0dQc3pNTWEwMTM2WU9ySHlu?=
 =?utf-8?B?UGl0eHVWbDBLeFQvS1ZlL08xVm53N2pyU2p5YWFTMk80eEx5M0hpM0JtcktE?=
 =?utf-8?B?Tk9nSlRWSk5DNVBBS3hYbUlRRUF4NmsyVXFJY0ZGUlNNWCthWTkwazJ0UUxs?=
 =?utf-8?B?aHlzeTdITzNDNmNhMDRBc1pkajczNVRNQXZKNldITDZoL0dsWmR3Njd5djZY?=
 =?utf-8?B?aCtQMXQ1SVF0LzVQeDVycGlJR2p2V1h5MG5mZmV4WC9uUnhqQzA0VTFaaFgx?=
 =?utf-8?B?OHFhOVBuWnhjZXJYbnJCdlA1elJndTFldnZ6c3RxQTRjM1JjWGV6U0JaSjND?=
 =?utf-8?B?Q1VrMlJSZFRSdzVzOVFWcGI1aWJqTVE4Z29FQ2EvLzZxMVhLNTFkV3hlR21D?=
 =?utf-8?B?RTZHL0w5T0RhUnovUEFjOEJVcjVtMFB3WVUvT0wwekJSQUJWeUl4emFKUDdW?=
 =?utf-8?B?R0VlRHRFNmtmUGJQb0tWVDE0SG9HVXlFcHRVeFREWXhTZ1h2ZlVwU1RCbzRT?=
 =?utf-8?B?bjIzWFRlUmRLVlBZR3g3QUNaa2FTblRWZmk0WnJvcksrb0RFMzY3RytnVkFo?=
 =?utf-8?B?Rk1vR0hVcHVMbHBrcHV5MEloa3FtN1k4NW12cmVDRm9GZHVmUkFQSnpVYVlO?=
 =?utf-8?B?VENTMDBFajVOR1NTSnBwRE1yS1JtRkdKYzRYdUpzRmN3YXpjRmZDeXpQUUl1?=
 =?utf-8?B?ejVhR1JYK2ZTeXczSVc4bS9jakNZZVpzb056UnFzeEszaFdKK2ppNTNXOXQ4?=
 =?utf-8?B?NWpUaThyeGlBNXBEOGJuRXMwTXB0NmxpVWpJWjVxQnRCNEVKWkxucWRIVFBi?=
 =?utf-8?B?RVFobi9rWnE0Q2tuU01PT09yRTE3Nk5iVms0bkE5ZGRnbFQ0TmljY3JmUis5?=
 =?utf-8?B?N3QwOXM2bTN1TG5weGhzS3NhdkZ0Vy9CTkJ5WC82WTcxYzJNSjRpZ080TlUz?=
 =?utf-8?B?WWszczIrbWQ1Y21uMnZkVU1VUy9WTk16RlZEV0s1Z3EwNldKdTNPWW5TSUkr?=
 =?utf-8?B?aXJWSmhLbU1JcHloRGpkT0hONm1CQTlHQmdjYWs1ODM2TC9uNjJYSjR6ZVpu?=
 =?utf-8?B?bERxQ2oyRnRwemZaUXNRcWpZeUtVZ0hnUmF1SXpGdEtRc3JLdFZ4dEFHd0l2?=
 =?utf-8?B?ZkR4UjU4NEVWbHVzYmplenZudHBkM2RmQTd2QSsrNGxaL0VIb2lqdHNIeVNP?=
 =?utf-8?B?c1k2V1pMbFFKSjFuMkRESWJqUzJ4S2tra1BkOG14dTE2MGJEWTFzOVZCU3NN?=
 =?utf-8?B?Qm5Pb0UrSk1VZERzZmo0ODZkNmlCcWtGSGp2RmJscE9yWUlrUHp2RWJNVXJj?=
 =?utf-8?B?NHJBTlZ0WjlHc2VBeTA4RDV3aTh1TzJIVUdwbkdjcnZhZzNVTVlVbkE0Wlcw?=
 =?utf-8?B?VjZDY2g3TGlaTE1hN1RuNzhZNGo3VlpDYVhBSmhHTVFicnY4c0tlM083VlI4?=
 =?utf-8?B?eFlhTlIzVitxUk9hdE0yM08wZ2lyMDhkVGNRK2k1K1BESkZBS2lPTm5kRkZB?=
 =?utf-8?B?OFIvOGV6THl2a2RlbkQrNHhVNmZzbERDa1ZlYmxJUGc3UXVBVHo2cWlIK3Rv?=
 =?utf-8?B?ZWQ2Y1VsMFJtbjFhR1U1bm9qMFFsSUo5bUNUbVR6OVF3bUxHOHh2MlhQUlNu?=
 =?utf-8?B?eDBKejV2NldSdTlCYzI1dENDcml3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78A3AD573A72C343AA7CD9588AD19739@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MN3B1b5f62vHyNbmmqkBQwSfMzHKh7mqjyTctBUgsnTPyY9XareleWGF73czh898Lle+gCkONT/DR4yyuVwqXjiVm25lhwmme5R4PxLCh9ZTGYxd86hVu2rIUD+HcbcIwHsCQ9gWZvlJZ8iVxmLuY1hwQGJwNNRgqs9NcDpYR84zVb5LSwDNgkuI82o1Xaf0OSOA1vhKdKmwdUGrd2oWY13p3LClExqptb9FdGbSehJDdbbggLm5ilGYoshdGVQjTDdnvRPwMVdKxMz+Vh5uM64/p2w5CaQZLGd/QD2s4CQIij/6mNiOJwNVZWNfwJf0T/eyKhIOHnHb8L6Xf5x11HziydeoI/Y6V1gFs05aQ16krZ1Y6/cLoM9fz9ZErp6tLJcUzppIRbW/pzVuBpNQxBaqKPkNkbOcfw/65hZQOlUbPL4nRFFzvx8+43E7lwULf6F29xDQNQtgTDBOLqaWKWwwQdpJV063nrwIZIew3aqjyQXJ15QTWX/SPSmW2XuFWASUdbNDKhgTILPpSN+8OE350UyQgIyv1aan2n0/JYNiICUZ/BhH9GlkN1xoTBQUFeeJouVe9TYODS64bd0NURjSsBCdxaGRRYm09x80SAlQSs7zfvg9P6zVYEvx8ZPx
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10a1ecd-7a59-421b-ffd7-08dc58a6f9ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:08:56.0377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1QUbUmG4tkZDU590fecuTnsrmG58YUHaw5aF9PEdCWjmP16Ryvl7T5LzT4NCIYmKqhd1AiEiyH3d71bSblsmVAwqTbTOrAWcEYJLGewcW3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7715

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
