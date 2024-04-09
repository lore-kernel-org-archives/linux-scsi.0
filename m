Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB38D12F367;
	Tue,  9 Apr 2024 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675465; cv=fail; b=bGb7nu9z5bF9JZ7u76FJiAvnhLH3OD8HdZX83m9Itt7TRk+eQmiDJBnnUxSTZsBvLU6p4FnuX6+FVBs3KaUo0OHhBcAaeV4nzbz1/7lkRaHwqs6U6Gok3JOS9AwtwE9LxstNnlC8dZHTDNoITDzOg0+vK9Qy6iWAPpCF7ItshHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675465; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rk8vcNIlUlkB5hTVU8CRe+RpcCNUEXnpS7diuM9WNNLF6gFmyN/5Kg3u8Uqe+khi5grm2+2pOcfzml6duurALCV+JowNqmxtZta7LQHLtF2DcKFw7CEuu4yBxWRZibPbKoQhF6wcyzrDXuyOo9sbfaarLjDxxz4bT4C7IXot0kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=g63jg++L; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=NqtbJQ6a; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g63jg++L";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NqtbJQ6a"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675463; x=1744211463;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=g63jg++L2ybrBWxrjeC21235v+Ty5sIs7zRgatE+2oiYvOfM2ElPiOGm
   hYd0AH3qWD3s1W6V/jE8DJe5hWH8r+wpClMUy1T6mLS1/FNjpzbkhaDCX
   oPXnySAp8U1xrGZgoo7dMJcnKJKQYB2FRqi4/ezswJmCOieKvyGK/XD34
   T1+7Vjex2DQLbE1Bim4gsPlKuPp10cJsbgfGM/8RBGDygrLAR0LIZ3idf
   MuCXeMjwdRLuetLXzFJhDVumDCUPiUIuavXlb9UYw053wXbhql0lN82Ny
   5yK4hgKSUB5K42ddmNN1gjl0NFYE3/Zf2/VtVneMjp8F+aCmeMPRO9qL4
   Q==;
X-CSE-ConnectionGUID: RMVK7MDTQnuMz97ViuNVeQ==
X-CSE-MsgGUID: 6G+kv5nMRguir7/3/tgkdA==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="14283803"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:10:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwVKKvytgc9XmuThSwalDqCSoZFehA5F57LV5PXvgZXSvnhrKnDfFCtx6/insI0l5gK8lT9JzrhhxtQWu1XBanATALrYhJKG4BGEXbwpILkw9BiE9xfhULEWOsV7mFOILC4kOc9IpAWjvf5Dv1buyVRsIG6HpWtqry96L3s7PGl6qnKSm88A6SIjxo7Ao+7WT3IaIeOTg9LFjgczBYUnxD6CgqTR4VMcauNLxjQ7I3tJUlnBLHv6SQIys1q3wSfXrc/brlb01TzosuIz1jXu5mc8XOv3TpMOOOoJ8ZWWj9j+op71X5yI5K4FI1vf5vjVEn3TH9diUr/estoZ/bgQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=m6TF2ZZ49eoo9gCW1TXxgUonshdYD53TVcDg7y0XY3TJhNOKTVjnjgic0Z/wxleLsyhlH7s+gQkjATKKcCjAWag1DK5Fi+FEndZamNk1uSHwYES18qrJYgmgMW6foIfue0mDSU6qUF6uLJnKMOXbgbs2Qf4ZLr1T2jsE6rDDFHuEvN1cc2kWXbGFvSQBirtWlqnC4wLYAiOegEIKlzdjaPWZoE+GDCLdRfOoqikope32Ao9jL8LlwYynSSdHvBUZPk54GvH4CWkR8Fr85Ms/Qa9Q3rvHW08u0P7iV49CPc2phDIGmoMRrgAnGyzjQ1dQlsRSNOWFxQDUPKjmPSoqHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=NqtbJQ6aWQFZQyCWNyOl878zm37XOxlfmuTF3tQ6uoBQq5QfcFlwFW5ZNcKyy6EgNQEwnfEPtN8eLn088+81sK0kaKS2btmEwqXqbxR9JMa/ieBg50twiMt3Kz3yF8i88TsF/op96h52y8U1jkOPdtQZeOhvRZ+QImOziM7lwxc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6760.namprd04.prod.outlook.com (2603:10b6:610:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 15:10:52 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:10:52 +0000
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
Subject: Re: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
Thread-Topic: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
Thread-Index: AQHaiovAPJdGlWFvDkCKjeMUQhIPyrFgCyEA
Date: Tue, 9 Apr 2024 15:10:52 +0000
Message-ID: <ef2c4e22-5650-4ac6-94fe-dbf213bfa4ab@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-8-hch@lst.de>
In-Reply-To: <20240409143748.980206-8-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6760:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 6Lkh6HSfUKa1cOLMZpbZ+rL5jX+FzehOuix6mDtj8qHiJq15gDUrgJJfX4sHS1cCao3/SAeJTxpKmTHmROvLURjm0/AZVzmJcOJ0hJPHzaZww9WPXsM61fnI84J23nprGBxSkBXsuP626uw0kJqLCA6b/abUkuhM/lODhkCs9gUPv6blhpmRJpZOaB1/oOqDBaHiBCkXAljc2t5IqR7ofTSOU/iIN85m7l1R41537s/ZpvCo/PMxQ8aYxsI+sXs/1RXZ++txBaDBUmuA0XjKFLUjPsNqiynQrDDDFh8/zTwjOJG2Swky2pn9GhlDJGf4/j09xFypuLvYPtyHdlNRQJZMF88lrK6hu8hszPmHIbE3gjrj2YTn2j0EdNOcO7RGZFZeNwxiXcmVAa2Xsm3ORI37+gy2OCCl0UFN+MmSXUYL2K/hQDNAcOHKG+IIh+tD4WqJberfsv+yqsD/GKm7ig25jT7ZdHNEgBF5kORxUuPKHaC+wfFGM/Lei7WXuyZwfocdXxFHOz2yHohv+wkCRimtDUuhIh8iRaTRDkWTHOiYNE5LrfU7kUcLKeYC19zEWf2O9nh+eoDyR1A6cvy6KosCAX1c4/5eQGdrS+5ulRqHkqVwJ+L3uaxh8VTemlK28JmB93rpMQhkcrZ0kp54QS2xtn6uyS/EVYgqK+ZLf68=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZFNaUjNYTXBxSWxMN3E3MTh3c2pvaitGbU5uS0VjMkcvN2R3NW5mUUhZeTlZ?=
 =?utf-8?B?NXlQYVU2Z2lFdjBsTytPdHVYQWFDYTA2b0svRUo1VUgyNW9qY0VNVW5SeCs1?=
 =?utf-8?B?UnlrSVlxOVMyOFZlK2hjV1d5RmVadXJkdytTRmxwcDNYTENndS82VmYyeCtL?=
 =?utf-8?B?d3d3K2oyRHhMV3IwcjN6WStQa3ByT1pFdTM0aDJLSEd0bUtTZCt3WVdRRE1X?=
 =?utf-8?B?d2d6OHVGakxYNXUvMm1xNU5UeWovbUMzK0dyQmF6VGx1aUIrcFJVditjV0d1?=
 =?utf-8?B?YjQ3MFZSSVRoUlJZOHE2TkNiUWN1NnJIWEJFMjBML0FRTzRnR2Z1cm1PUTNu?=
 =?utf-8?B?dTlTaUwzRnJ1cUVxNm8xZndZV2t1YjI4L25tQmY4aHVNdFEvWU9hbDJRbHF5?=
 =?utf-8?B?a0dBNGRSR2ZLbjVydSs1S2c2czNLbzFmQmY3blZMSUhzTC9ra0lKV3hVajRv?=
 =?utf-8?B?QnR2Y3BkcUhMSjk2UC8raGxvTktQTWtXNkFSR2d2ZHZqekF5M0VjQUo3TGdQ?=
 =?utf-8?B?blF4eGJxQVcraEVORUxYc09oTDVUd1VTTTBzRCtJVXpZS1JzQjd4cWZPNS9O?=
 =?utf-8?B?MkdNMWxiaSt2OEVwNjJPNzJIeDgwcTcrb3N4Mkp2RTNON1lVdmIzWXlCZlhR?=
 =?utf-8?B?M2l6Qzlib1owNUJmWVl3VVRWc05YM1dKWU9VMlMwZEVYdkJXaExOVUZJTCtT?=
 =?utf-8?B?cXpIR2lyODUwT3E5NDVhQ3BBaUt4VE1La0N3THkzNnpmNmE4NXlXT2o1cWhr?=
 =?utf-8?B?TmVQRjZGc2svZk5YWCtXbnZpM3dmV2NQa2lya3FsYzZXMVkxQnluTjlPOXhl?=
 =?utf-8?B?VHk2YnQ4S3NyTGlxZ2ZGa1RYV1JVMUt1cTdKSGtWMUJWUG5VTmdaU2pDOEpl?=
 =?utf-8?B?OFBGNlhjbGJtR2J0N3orY3d5STJmNCt4akpLZDdmYlBRTnhQUEFxbEJCQS9u?=
 =?utf-8?B?ZU5kMWIvUUNUZFB3NGJYNFRkNHcyVjdrN2FTVzlsSE9wUFkyK1JRclpXUzdB?=
 =?utf-8?B?aXhnNmsvcnhpZGJ2UWdrRjF0YTZoR1psUmVxQk01ZmJLVFdhYndWUVBRRk5H?=
 =?utf-8?B?dFR6SXpyOHRqaFl1ejNkMUtIK25PSVJ0TEFFNEhNcGkrK0ZDamsxbmlhTE1q?=
 =?utf-8?B?RExQc3BxVVV1b0tZUkhoRUJIVDZ4UDZ0QVlXdWhoQXZ4a0cyYTZNTng3T25a?=
 =?utf-8?B?TUlBRUhldkxmWnV1d2JVNS9QZS8vN1hJTkM2MU9MbTBDR2tLVmV0YUxQblR6?=
 =?utf-8?B?TEdtNXFodnZWTTJRUFJSUkNBVW13SzZWSmZUQTVzQnVkOUU1QTJsdVNDNXI1?=
 =?utf-8?B?ZEJoclJtSHFWMmlHZW5SdHFDb1dQaFBMampzUDBxWEovUzJhL3hZeUJ6VjVi?=
 =?utf-8?B?ZjEyVngvcVdlNlZyaHB2MFBsOGI2cWdQTUpPcE90cEIyd2ZORTh4M0VUWXVl?=
 =?utf-8?B?WTlHTTNsVmloZzNlUmVpVHF2MmhGQUZ5VXNVM2xBWEUvenEzSVVmUzAvN2p6?=
 =?utf-8?B?RTVNeUdRcHFPU29tdExFTTIxNlpiRWpCaXhpN1VFNWFQUXp5K2hYNjhVaTlO?=
 =?utf-8?B?U25Tek4xN1ZLQWlwTjVPcDRSQUU1OUtsT1NTdUY2U2EwalRaeTBSYUtrTVMx?=
 =?utf-8?B?OUR1T21wZSt2VXVLY2l5eUw1K09rVU1YVHl1REdzSlBkMExCL05UUFBJQkhB?=
 =?utf-8?B?eXVyOEFFaHkvZkVGc01wdTNhTTkrOVVIQ2xrNzBaSnZscHdBeUJVVGJQWWcy?=
 =?utf-8?B?TjRpMGNLRm1HOGtKRnUwVkQ2MndEZE9SVmlLc0w1KzB6WStWV0JoVU0xektz?=
 =?utf-8?B?UmowckxGUU1YcVN2RHYzNWtQWWhWcjBkZ1hJdFVjcSszMzU0a08yeU5nNDQ1?=
 =?utf-8?B?bFpDVXVVb0pObDZGamUyOFh3a2lldWhMblBCTE1UUVVrOGZnN3k3K3d2eUlj?=
 =?utf-8?B?amg4Ty94UjVHc0VIcTVDbjZhcTRYb0toVTdBQWhOeml3Q2hHaTI2UDl3NlJa?=
 =?utf-8?B?aTNkcUxsMFZmeVhnajlUZzJjak5CVlRSWjdYejVROVNTWUFTQ09NS1dINVk5?=
 =?utf-8?B?aktjKytvVEVobXNmbWgwVG5uL2E3ZmExNlVSd1A3QVQvWWVIQzB2MWU3cXd1?=
 =?utf-8?B?aGhDVS9DUy9GTis2dHdJaWFXR2trN2w0OWxBeWFLc3pUc1RCcVQrbXFmY3VG?=
 =?utf-8?B?SmF0Q0dTTDdCVEZRWC9raWlSeWhIY0tnUU5vdWdRU0I0anY3aE9EOUpUcDY3?=
 =?utf-8?B?QlRpMVo5L3BTRHBqL0JzZitOQmtBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B034ECF22EAEE044B631B62C8FF4DBB2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Znr9NZooQ9MwFsDLr7xF/2TWsBWdKX2Rmu/UIjd5fcH2UamgUct2+mnAJPaq5VcbjoNOwPxXz10OMXycj14myooz9SAzRhbd6L0NLCjbF0Crtdz34SMpr2DU87SQuyboyebX5Fa150f+K0+ipRfxlHd/ivUyDkHbGSUHgxeGnui9UhZkIuSNhfPI7xyrdClNcH+gjEXRgMHmzIliDFuqQ+mz8WRnlOdIpKEcmqocs7UUvEgY8X/B3+0tWQ0s0VkVulvLZL4h99lg+m6HN7vKaxtVyX8xr0S8Vqf7dNXhmd28PgIBADdYc4LqPpJSUHonNt5FCCECBK/vCQ6I2NtOp2wdi17pJK8jjibPnV2UZpLS1sDPFhVAh8tuVkze/9UvOJHOGzK250E/We+9JbTun4OMl2R4UNBUN1ej7rTlXFDFk8+dD7R4p1KuzTlhcl3gBq0aMtH/WWWvuIH44DLJCp0K9OoTA0t8lDDvemz/SReQeWvZxojgTwFCptWl+VfRyKMimCS1SaxI6DzoDFRcL4KMn/O8t+FAkf6Teq/+wmQn2GWhh+3LQXEDa4raJCj3KSyo5LQ5azeduUnUVsV6YtTxrFj+avRJiSxRcLwzTdlSYg9+hdPPTK/mr6/XLWC
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318b2e00-b3b5-4d6d-210b-08dc58a73f5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:10:52.5026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9r9NFFcppLQ8elTDLmLTm+VeJ5Yc5HdX5q3uI12liv81BQwswtvlW5absxJgCQo2c7VUR6OlRTJQKdyizAoqBFkTKbJo2PZ7ku9dxoQJjVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6760

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
