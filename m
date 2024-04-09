Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9917F12FF9C;
	Tue,  9 Apr 2024 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675933; cv=fail; b=ZB/8CMFHshoyDKkEtp6Ijv01nBgWtg2n/luj0RVTZKmfTwUP8h+oyudzrNUOox173KhZ97KcWCz0gQQxFEds6oZ15OGr9fmyanQIHn8wyhTF2ssyuyY658vmK0SYWHjBVrHISEyH0UIwKwKYlTxPjP2eokNQq/swYCHhMv3niIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675933; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pu92MSvrbgfUWsATQxqjI0MjxfRQWkMnAQXk23EwU9wle5adaymOKVrWoNY8YocZJwJVmsIj+whtS6l03A/slW3DT1q+2nIVqxffkymMTCGwvnzqPfnOsD/WT3Y47SybplHApweHjp6unDK40KkMLDzp2NbscwRnweRjLDD4uFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nzXTZFtA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=VVtcoBlk; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nzXTZFtA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VVtcoBlk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675931; x=1744211931;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=nzXTZFtAqdWEIdkqnV/JWSF6PhrsxMALrceumDrkkzXCJd5YrAjrdu3t
   JOYl+FPpBPihyOaNGL6Vzdy4/ZmN4/c9dmtOIkmLa6O5VvBa6avPBLaNb
   4Z6tnOITQ7T095erBISWSroWhQWcDQvjQf88UVBkq7Oh+uqVlH3M184p/
   xPyX5LCDL2tptsvCqGH+PpRk4BqZbH6K0rLRbFbzNLGJvEo3epfJ6rKKV
   nrqc/J8Dq0Dn7Ctu0YjQvp7mglvTIcmTeNWMtFr8hllFl7vD8uK3Jn2hO
   qc2PReljXRy91EjHr5xx3MjHF5R33XUzGozWSD+OjfbKJM6QEvT7FfjOm
   A==;
X-CSE-ConnectionGUID: ey9Xq4K1Q+eW/fVX2RZ45A==
X-CSE-MsgGUID: JW6Gn95WTPyGNeVvWfb55w==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13077828"
Received: from mail-bn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:18:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epZYDHp5eb4ccAn0wJiFlXaxSToA89G1lyjZ9OR+o5BgouIuNfsUZqTEXHSri9aPH+L7iZq2YaNVC1cslxnpog8bgwGrxpttGzAOxGtqC9CzGBT0vO8gVr+ZGgV53JQolEVoZOzjTGHEkTTaIxI0MI2/YwDcW86XQpVkVaiOdXdKwVcpM/bK/Ud6MRkQ5EKFOB3n4OdGHvJQgWN8nlwEryPlUVBTrROOGTElZld2ayhIBe08oKuxDr+NOAOIymb41Ux+pskV63PsaUbmz8xMlI7xyYaCG8VlGTubFMUKbrW/k5DM0y10XnpYhIbjbbiIjLu4brwA+Jb9BHBc2te/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=aZ4ozUfdjCdG+9Pf9kxKQSCDO2iaEPCsJ8O2/mtvkS2t22qvjewTYAer57jCuS8pLxbkVfFuLQPVKu+z6vouhJN/ylCHnAbHMrl+MNuvV9tgJc0TAoH+WYLrZb6aiTEJ7KF67r0c2JSnaWr8opzmGYeyGRPfKqlmmxLIQwH/fAoWvjb0rnD3O6Af8H3pIiGjoqZ/GWMLk7sLg6KnSnQEwU9+4AxEl4yhDWDzibfLjcETJuOvjMRCYBGgEoD5EmMhSEGQBRE9Li1djLY7102FcPXpiXnwJ7a37vWuFEqaIynXj9IyVVDdlWQdpd5ZBPD61FVxgUlQuZwxMRFsA2E1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=VVtcoBlkR6u394TqRCPN/r5ZFIzICf4Esd5fK5om47ZPXan6nvjnjE085Sq89mX23oa9xIN5VqMBv9tkyMiTMcwxwBxrHmI5yOgo16aVsDqIi3ahMahRWFFJzFWqmwSOiOnWly2slaDREVhTDCvxMoXbZ20Jv5pL+EmtrcXYLf4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6687.namprd04.prod.outlook.com (2603:10b6:208:1e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.53; Tue, 9 Apr
 2024 15:18:45 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:18:45 +0000
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
Subject: Re: [PATCH 14/23] hptiop: switch to using ->device_configure
Thread-Topic: [PATCH 14/23] hptiop: switch to using ->device_configure
Thread-Index: AQHaiov2a/W9G4KxfUOwdDWjcCPBCLFgDVWA
Date: Tue, 9 Apr 2024 15:18:45 +0000
Message-ID: <34f5466e-776f-41db-8fd2-aeff941e1311@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-15-hch@lst.de>
In-Reply-To: <20240409143748.980206-15-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|MN2PR04MB6687:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 1CxakhBt1PtrMbV5Z8qGazYt9l2Q0IYfzQIRj+o9K8/vUti2IcGkUeagFCivCOIVS1iF2ccOzTZJW8xzHKjdm3oln5nksAvcS9il0e3ELBaCS+JZQkbFGyrUTP5BDldKLjF5su5JsUzJaJkXx3plGt+CCAGtaGxtNQAOL9Sc5I/VdMUiZ/+ppYzVw7NpZN8EDo0i9ATlUqq5HXTCJqVopY6RLixP12eSRFjg3nL0vsmvIUXz8jHQiAtOA1wc2Y49LFmxFasfLnB9c1Zg4xdQDBpZyDBCvD3QWgnOvEvZWN+CEWhf+FwGdA/VQXscz4D418Ht4yArmDtL8sxe8WS7ztnTN1uwOEg0RJ5WPTNTSoY5GW5eDCEOH7WLR+m7w1nMbMj5PSAA3ZztvOM9/Opa0apkwTdSiFGtHWpKiQ2tAD/pVu4mrlCorknySsTaeqHWn9sw4XRDFT/vQ2O4GWpVDbDXl3srIQllBdCD67eo1axwq4Ph7eTYJk/QAfR67Aa0URAhcv9KGWx/k0Hrr7OeAUMXDKhx7wmJJWKDZk0/qC+wH2tp3yALVg59wA5LmmmKpj9wpT4ZBJPPPpm3zKJ0nlTFpRs1dkYzyiTLRt1sBMYmJsNAjJ55cmlaKajkjd0WtWek7YXoRxDagp7bZl524LwX+D8mH2CPf2EvpUJCK18=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eHc4a1hPUFNlK2dDbnpvRUpzalIzVmVNSFRrS281OWtxb3VObUNkcWtSZ0Ji?=
 =?utf-8?B?TkZvU1oyTEcrOXMzRkZYSmhjVG1jbU5Lek1Hb3YwZVFYZjM3ckZCclZKZkxE?=
 =?utf-8?B?R0o0NXk2QVROQ2xKdjhBTC9SeUdpcm83TnpYNjRJOUV3djBHUFBpTjZjMmxE?=
 =?utf-8?B?Y0wvaUN1MytVSkZUdjlkaHRZbC9aNHhocEdxblNqb3dOYzhnVTM2QzhULzlU?=
 =?utf-8?B?RGZGZHA2OHZ1T3Q1NVZpa3JGTWFpYk4rVlFXcDR3YVVIaEFrUnhhRTcwUjRX?=
 =?utf-8?B?aTNxclB4T3FUWEI1ZzU4UDlpK1dwVjNtYXJqanNyYjZNOFFzTnVkUmIzU3Fi?=
 =?utf-8?B?OG9yS1BRWFE4MiswQlhybFhpS2J3UHhsbTdyd05ZdFBaM3UwNFFPL1g2Nnd1?=
 =?utf-8?B?T2sxYW1aL2FWM3RBWHI4dUxxMnpFbzdycE5UdzcrNENoR0djWmpweHQ5MkJa?=
 =?utf-8?B?TlhPNzJ0ZFhSMkZkTEVHMk85RW5zT3MxbW11UnQ3TW10SUthWnoyNG1JamJH?=
 =?utf-8?B?Rnk0ZnAyb0wvS0h3TFhveE14YlBpZjFPRFRlS3hHWG15QWhYZjZPTE1IWkpU?=
 =?utf-8?B?NDlZZ21UbTYwMDQ4blpad0VyZk8rVHV6VDM1c3hjVHZXRi9uSzhrSENWWmRw?=
 =?utf-8?B?bEJ5cU85clFvbWRFOUR6U3ArYmtVenJGRW1oTzA0RnduTFdEci91a3VnVkdC?=
 =?utf-8?B?alV0SEU5K2JVZUEzTFlwZ2xNTFIzVlJINTRaMDBTZnB2d1M3SDJQenJtbTRv?=
 =?utf-8?B?MGNqWHg4V2tyWmlJeGtWcDJFM0RUODFZT2xJNzl1ckZ4L1ZwMUJzRS80Vk1q?=
 =?utf-8?B?UmVHUXhiU2pHaXVsQnpOVzNzbmd6THNhMTVYRHZLVk8xdm9qZmlYQSs3Slc0?=
 =?utf-8?B?dFpnMFQ5Y0pqUnRwTm1kUjhmQWFNcFZ1aVB4UWU4M1d5VDlPNTlRRHFFaG1m?=
 =?utf-8?B?MlNzWFRibmFlOGp5NWJrQnpNSnovWngwWDRDQWU4dUFLV01YY1Z4VFY1Q3BU?=
 =?utf-8?B?VENSeEdZNGVnWVZGa2pVWTlhazJmVlBSemRGVTAwQ1BvSjJaUWZPY1FHaHEw?=
 =?utf-8?B?Y0g2dGhiNnNhWHFScmpxaTR0bmE5SEprSjdzTm9DcEllYVlwQ2ttQ1o4aHo2?=
 =?utf-8?B?K2t5UE4zR3FvZkVsbTNRRGJmemllNHJKdE1iNkRGdW1JSytXUkJsRjU4UXEv?=
 =?utf-8?B?SURQQXRlcUJqeTZJMWR4UURHZTdnQlVYdG5jZFdYNWJCS2ZTazJES2UySEpr?=
 =?utf-8?B?aVl1dkJKbXRnUlp4YWl5anozK1hxNGxaVXdhSnFuZUc2TjVtR1FVWXZWaTJC?=
 =?utf-8?B?Ym5CN2ZQMjUwRWdORDFaTkRjdWN0TXI3a1JwN0xMelN2a1o1dFJKUWtVbjdL?=
 =?utf-8?B?bVZpREVUbTUreVJHZG9XemJVSCt4SjN4bXB2c24xdEsvSUVRWTFOcXkxZWU2?=
 =?utf-8?B?TlplWm5ya1pTcVZRYVVYNEFjYTRERUE3SUR3aGk0b2owUFFRaE1JaGxEamNW?=
 =?utf-8?B?WlhMRWdXcmZjS2lTSFJWcEo1bmdHZnV6R2hza2FvUXhyTUJVS3UvN2pJNCtN?=
 =?utf-8?B?dHBrYnVhbHd0eks0OUFaUlN2WCthRGtadGpyT25yL1pSNURPdEsvdVpJc0hZ?=
 =?utf-8?B?ekFEUVd0YmoxNFhTU2VrZnVSekZ6WGRoWnJRMkM4NDBsc3pxaCtINk1hU3E4?=
 =?utf-8?B?QVlqOVh4aitEbXg2cTNaMk5YR20xZUtxSVJFQXpyQitpYTZDbzFhOXRCV2Vw?=
 =?utf-8?B?VDhWQjVCWEpJeklGdjlVbW5wMFFCSXplVi92aDlDbG05UGVZeVQ2dVVqRm9T?=
 =?utf-8?B?ZjhNdytWaDJoZi9NazJxMVpmWUViY1dVYVpxKy82Vm1CQlF6N2dEcklOeE5C?=
 =?utf-8?B?UllmWEVSRDIxVFlhY3VIL1lRM2tJY2FuQjVZNUpJaTVoVFRwODlUd2o3eSts?=
 =?utf-8?B?ZHR5TTM3TlJZaWwzTHBuUkpjekRZYXlYdXdJZFNQMUlHZXBXdng1d1ZkOG1F?=
 =?utf-8?B?S0NJQXViTUpVeDhRcWhCcVJmTXNyalR6ZkVOclgzR1IycEp1NnEvcTBFTmYy?=
 =?utf-8?B?M3dTM2FXM00rcWp0WXJYYmRld2Zyenl2cCsrUGZWRzBWdTQrbmd2S2czak5n?=
 =?utf-8?B?NHVSR1owZzJ4djc4V0ovZVkwbG1xN2Q0R1czTXJWMkYzQnAyVlVWcmN4aG5o?=
 =?utf-8?B?Kzh6ZHNTMWMrRmNORHo4Mko2ZTZpWkR5OVhXZG1sY0VSN2J3Tm9WSXJDYlE2?=
 =?utf-8?B?MGFHcHVnMWh3c3phWkVhNlN2VU5nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCD2067CE08C7D4DBDCD31E33A4A3655@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fk9jKyAKKLqEq3r/+iooyF1F21W2yaHNc0kr4930KHjuHAcMdo71Ls/R/tpoZJ7IvyOpeK4fiaM21KFQVSao/V6+pgukwimQ4zyBAX6UKmHeYPxQZf4hcEkPXWsd9cp8cJcdU71uDGIw7Yb7Dfm8TufyYd0XWl0EgbJx+H6OLXFUEaSw6md0d1KjtFuK98DJsOcEkBO58hW+Y1x3dsL8IuSt7V6ztv6QxetjCSZPT4Dc6l4ymdyM3mT8ObQhWtbDkwC4LD0iL8YZpZlOoc0K6cnEF9vrmaqmJBVtbActcO+oh6lbYrKgSKJ/HZBlgMIgAasSorqJ8kszXl6eWsU/kfFWMYVeF0yA59Q6MGmAwGQqp+XM7JNHe8rISU9n2Pl2BJer/YiVfU06ruXGZH6tTpRQUmCKOCHzY1R+pehqd2uKFHrCmzf+vRKlj82gRn4vwvL+dnsqq+qpCXFyyO9DnrgeQUQDnFRk5d/ypuG5Xu1ODrLrOQLn8CrelqbrDHtiq3VFzUp15JlIw2fNtBlvzEp86vD0hd5trGTPOfy6WTGzeaV/u/VdF3jU8SOo3j2isYDiEkACuOHjVeqLclWWsUqD2NQiXRfsPvCdaJUXlOZ7YJ9KeXtD3KqqRu6CpgSw
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dcc5dce-e4b6-4616-9f86-08dc58a85960
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:18:45.6465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihxfzUnX623nn+g5aS6b3v0sIcgPf1LJ7XbNTgIiuafhfN05/vRGqRcyckMf1ILXaLLQ4WRHXva8Dwg2+UcsjXVfxdprf/h9VjbIAu6dQgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6687

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
