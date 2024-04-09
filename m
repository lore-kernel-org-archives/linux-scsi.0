Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCB2135A4D;
	Tue,  9 Apr 2024 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675829; cv=fail; b=HH7Hea32hxsXRWRbljPbPWLe94CD1/NhZkXAIgK97toqjRWDvdlTDo1cnJ7shklP//nYLQ14L0DrjjscBuAocnHP9LVsnPX/OxkR/+STbYaD4vXkJYOZlW+pQloB/JNy16h4hcYHfCYopIjmoFe2rJpIksAV7RECjUciSmUamME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675829; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WOnuGm43akJEMvcqbUnnJxfn3/Oy1NVWTzYyLpNbPPacbOWFGtY2YUvY761Ft8XirLrol7oTXcoTJhBh3j/4/F1bra+sKkORynyuhQ2Lz6vRVGvsizTIOqFH6hj9DRw4ZOFEGp6FYBiqIu6u9Vvn2Ph8OPW4ROX4U7gcfQx07ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AGh4cXH1; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=poq9OsU7; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AGh4cXH1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="poq9OsU7"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675827; x=1744211827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=AGh4cXH1rO7KazxI5LIIkwPXX2/eLsURxaZGyk7fRjYW8VVl7D+nwiZG
   huMhnDAtztGpqJ3F0s9+a5/0r1XDDCb73a/7Nc1z2WgsJjNy6CScevd6q
   eyve+ebIkpihJ082z1pGrxCvufaFKUXVSPu01JXfRGYgDJL7GjPTSXRjR
   3KjX+1EUnzoODUV1h3BDWWezNwban4Abc87emzEj58/JFBBW0HRXSFv+o
   0lxykI5g+7azrqQbmZs4M0/QwkgQmLlQfwFSdV0Zn6gq9IaA4UBlwCDby
   ogMjcq3sex0fotWZ/Q/fQ5v9WwXuQGJ1mwwL2tRIgOXtpDYwhaiyrEFCl
   g==;
X-CSE-ConnectionGUID: 1UdBTteIQYeGOL21jiwwIw==
X-CSE-MsgGUID: Q9NHJitBRQGlckDWGpvR9A==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13602633"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:17:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Feo2qdaUShYgkCncLGQv9seeOiPomTFLsLVSse2ZyiJg+1MrfHhayHID5wfhem/jjlixFLfq70GsbmxUl+b/ngiHdL90P6bdsqAj+XZPeK4dDcIkpv9ZhzxUqVhNb0WUEZoURLlSKlzQAODnDxgz8UPOJ0ssImgMt34aOxdxU6PG+vaL5obwMUJjRnMAn7RDG4MWDI7FkoeDpXjkomHWlsOr4FuHBWnLZzmo6gKyG6GgNfBZN6dSWV3TzvSBqWq6f3Lq+EivXI5lCZS6++59UAeofWEKxWxxoB2xyOa0ltJzBFg1X4WReUQrCs0fsOUgi7wW6p0Yz8/pfyHb/Jo/gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=G1QZJKKFRuxIrp6D9z89GfCrHwyS2XQkHpacVyVMGxLoq2w0wdGRrskX6JAkdrDgTGXt6TXtTdSrEHaKE/9qRoNAVF98k0fBPoNG+XIIK+/9qbBx2A5jhjHWfujvt3u4HLE1nzzqoiweqVlflUBi+T2DZ8+vvmSogzLf7u5u4t3W66QottOKAsh2BprlAm1mhXDIS/8v7wcVlj4qW4vl1T3bIovO6IiYzXnLzPj1FtqiySzXHubB2LWsO3+LuZ5gAaCjCHDUKpW8GgOsydb4flgQR46wDbADNR0ALBHGfFmxEUzdBEJkKHcZOTf+Q9o5XvYs39t7cj2EZwxqt3cuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=poq9OsU75JACziDHhCOGK/PKWbxO1G8yoayfQz90rDA+BblKhxeSa/oDBsWgKKqJGs7quY9v+jsncfBDaAlBlvmLb5ssxWWkFlflrwob2AhUHPO4GKzarQE6uzYJAmztR1uf7sIBh2iKE8V3sWSv1RiBwwLdD5e7RTD34Lgh+7c=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6687.namprd04.prod.outlook.com (2603:10b6:208:1e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.53; Tue, 9 Apr
 2024 15:16:59 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:16:59 +0000
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
	<usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH 12/23] mpt3sas: switch to using ->device_configure
Thread-Topic: [PATCH 12/23] mpt3sas: switch to using ->device_configure
Thread-Index: AQHaiovsrLjo0KkLnkyUHqlHwWPr+7FgDNaA
Date: Tue, 9 Apr 2024 15:16:59 +0000
Message-ID: <efa5f8cd-80a8-4534-abe4-0ad193e285df@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-13-hch@lst.de>
In-Reply-To: <20240409143748.980206-13-hch@lst.de>
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
 V9sy6wb/iM5rIGnKr2IkiliPEpSJqqVHCfItILxMTMqdbsdOWOqVfdwApFbzxoU/Mn73kLQCBtPoo68uOQXXFIKw+mOifVdrHFmmbhV5BARhzcMqTc7a6zmNL9LURLgwuA0AcDpsSX+AVoFSAvq6CwEx+ARB+W1Z7TwnFPNfV2V0ZFP/SvxTkXl2iKvHpwM3ubGI+x63H9HQDlBQ98xhVZXc1KmQx8Ofxf1aaAcmfYrgZFQLjdgj8AC25XKCfbe9O11hpyVJKc8y8taiQKeoAsJVtOulVQRz31aDSzgCkepB7XPJ+CaECeR8IR4efHPGZ382fjAqWJXGPIO/OvDB+fGVqXvPeRqfNNK3Sd6bm1K0PiXiDknuP85mcO9ms96mlZa3jBfVY/rvi0sqZOWPsSyVlbg12b8OMUfjOQi/619doRlezSoo4DuT33qggjkoygkHRqUYy1ldt1MdHLTjw1IuEGoMIeYWv/quJvr+bJdjeSTd9PXSDP29kv3DIhuI/soBSvgc72gWPhljghSPsAkyb+txNe83eVjjpXwlro2jJ3cp6Id2lJZwZ93I7gso/1Oflbjmmq4x7aCq8IDOynihuutqMlE+PZ+X2xsmcoQlmxaLBauKk3sWDg1B92dKqA5AGt4XRvYF75T8E8epZgpykHr683krwb+rPHR8hgc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SkRwTkxxb0t6M3dPQmt6ckdNR0s1VWkxVGFUOVdUK1N4V1lhL2FsUUxtT3Jq?=
 =?utf-8?B?eml3d2UxWDZrTko2UEtyZGVITUlRdk5yOEZaYnNRQ1FldE1RZUVBQzZCNHFU?=
 =?utf-8?B?WWo1bitibW90TjNiamNrUldCTng1WE1VMXNyc3RSc0NVRzlsZHliQXdCMG1y?=
 =?utf-8?B?eHpSR3hCYzRQTlFaWjBISFZiVm9YRHE2OHFXZlYyWmxJTU5VOE1DRWhnOEc4?=
 =?utf-8?B?TDBtQzdlaFgzVzNGckRPU1djemNGZzBYaW55ZDNFRk90S1JXaTF4WmpNVnd4?=
 =?utf-8?B?eE0yRHhxTFNFakFtNG00VXhwSXYwWWd5M2FGdlZ1c2VQUmJGa3MyWHc2YnNQ?=
 =?utf-8?B?M2xXOWtPaUJaVVJDU0Iyb1J3UGFSeFdRZDBkajdObEwxYzhVOEFTSlBOeC9t?=
 =?utf-8?B?N1NyMVh6ME0vUDdYMzNuNmdCajV0TC85Ni9TbXI1NEduckhYSTh0VHpCa29I?=
 =?utf-8?B?UUl1bDRBb3hpSEwySWdPQ0UrNlVXZ285cXBLYmNDUTBCalVMeVoyTG41SjRr?=
 =?utf-8?B?UVJoZDdoR2J3R1l5VkhXRlNpUkIvWHBhZ3RhcExRQlVjQVo4WW1BQkZFQ091?=
 =?utf-8?B?eG41TGJVdUZxeVFVckRUSmNjMHJ2UHI5VFdzbUhQUkpkUWxGNVpsbUx3TE41?=
 =?utf-8?B?WkhWOWtiMyt4cE9jTURQLy96RXdNckVuNWF2KytTNmQxSExPSmNCNG1rTFc1?=
 =?utf-8?B?dXM4THQraTlueUdyeU1MZWpDWmllVldiZ1JYYjdHQVdpU0hiRkdXYnNIR2lY?=
 =?utf-8?B?TWJKdW5WTlJxUmcvYW1GbVNUdHd6cGtHS1hLYTZvUVE2RStPTVFyMkgyUnRr?=
 =?utf-8?B?NGU3S2tLY1M4MUpOSE1FVDVxaWxrTFhnc3piVE9HRy9YYVFRSkxFeHBEVWF4?=
 =?utf-8?B?cUJLODRKUW1XZHR3OFRwdlpsWklyZEJ2NlZ0TUtmSlNjeGVkbklMd2dFTmdi?=
 =?utf-8?B?RTBkSWxJRlJFenBFenVGNDFHU1A3QWRPcUtJNndLTzlrQ24rM2w4cTVjVmQ3?=
 =?utf-8?B?OTZTNWN4WGtLVlZOSHVsZFRNRWhuemV6blBuZDB0QmJXZFRFeWhZeFVJREpL?=
 =?utf-8?B?UGpUUDI3dzBLZ1BHY1NFekZMNmRoSnVZWHQ2SUFoYnBvcW15NlUvRUlGUVIx?=
 =?utf-8?B?YXhyVklLYUk1YmNiTmFQa1FFYWpJMHU2UFE0eFpBQTBQYTE2czJkR2pVR0Fj?=
 =?utf-8?B?SDdnVnFiQUE0NzAwRG9wRW9qZFkyaTBjRzJ3MURrT0E1MUF4T0kvdHNwR3Va?=
 =?utf-8?B?Vk9hSDh6T1g4SkFWZlU1SjJGMFp3dHBWbmtmamhPSE42VHJXM0JQa0F4WVUv?=
 =?utf-8?B?TTZ1UEhuZFJib1lzKzR4bjloMHAraU5WYkJEcU5QYXBYRWNibjhUay81VGZY?=
 =?utf-8?B?L2cwblNtdEtEb1F6V1h4LzZUM051WUh2dElrR1ZOU3FKcXQzZ1JxbzVURndu?=
 =?utf-8?B?M0RSbmt2N3kva1ZIRS9mZ0RVVDRDUHo4cVJhN1kyd1R1bDVpYVBLNUlpMEF3?=
 =?utf-8?B?Q1F1NjFQUkJqeTkxTkdHOGdXSkNJRitDSm5HRkNFSURMeUlBUUl5NUxBKysx?=
 =?utf-8?B?WnB1N05BeVFHYU9tbHJyWndzZ0FMVTNyNjNVSGphZzBTVmludks2WVhRYXRu?=
 =?utf-8?B?eVFrK1hyVWxMZGJhMDdrVk9BM2p3RHAwZ083RlQ5VW9CMm5EQTlqaWtnemR3?=
 =?utf-8?B?U2h2Y2NFRjROMnZvZnZMY2tpenU1alRuZ1pjellTSlJXNDZsc1RKUm5oK0ww?=
 =?utf-8?B?NjBuRFlJUmt3TktHZlZDaGtaZjRYckFNNTdtL3NvdHQrZHkyZjh5TXNDemx1?=
 =?utf-8?B?T1VrZUp2NVhnQVdJNTllajA5YVp2T29mZHFLSmpXMVdVTEMwWlFpYi9kNDU0?=
 =?utf-8?B?R3A2MVpkaWFhQkpsMTlWQ00rc3NKZTFUNGF6d214d2w4VmV0OWRTbG4zRlYw?=
 =?utf-8?B?cGZGSGd2bGRteWd0UkZTSCszQVZGK21NbVBFMVZzOXVlQW9VVURDc2YzZEsy?=
 =?utf-8?B?ZnJENUwxSjdxZnowNEhpZUxObU9ZOGg2cnh0VUo3eUVST3o2RDJ5clZTZUE3?=
 =?utf-8?B?d3BmYTBYQkQ3RTJSL2cyeE0wNVNudkkyUlQzRC9sM1ozR3c3UXU1M0xhdTBu?=
 =?utf-8?B?RWp2czBKbmZoZXdWanRLL2VPSnM4ekFLcVBSMlB5TXFpSXBUaG5JR2s3cVpV?=
 =?utf-8?B?NUozbmhxZmtqRVBhQ0pQdlNVUXpTNWJCSTB4bE9CSUc0SnBIdTRKTm9jMnFw?=
 =?utf-8?B?TkZPQjdEZmNYVWhzdWQwaE1RWTd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEF33BDDD4587448AD04148DCDC39C64@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZiEqjoryyNy8cpXqgFSnmciNqY3v0ow0dhgOJbidh5tuUnNyxuQEdkW9KDDUTP4PajOFx0K+Jlnkex00mytq6Zig9ka+igRNDxTrv+KrJhaRplty7qPNBeZpKJw0CWQN6EFYQCjS4tkt2yj2e0ALlBgzHgkq9rVpt9xrm2Ly5k+hE/CJz1hpGNrJdutHGepX7DQbHqB09kBnglCsT1mI8ScOJj372AywBaCfLi9O6Ay/6tg0lpi+JtB0QCqBHYlSFpiQzcawhq2sAp9UlQGsiOvn2yOy+j6N7IGk7xgMTxFX/Q5kntD3wGRL4tCTrYm+CKy/+oQT118wZWLuaXTImKGO04qAE71bvaKH4qIYFy39H9xnlycmGYCs12ttM9lhg/fI8KvTuj1MJx+ByMdjorAn3+dK4vwodPiSbKVMpJgwnb42XfSmparYRq5icK1a4GO4ZNrp0u1PQUGZHC55fL7c3OKrBQ/Mnyt0fHecyVkMXAKTZW9wiq7t+w0ccMWaEiPGth3mdsTFnVJx6K+TTSeETwJCx53DQNwzxYBJTdiMG/83d2MIyRgUFw0DInSAYej62tztUaXwy+EEOmXeIgYTrHA/EVFMJ6ARzs8ld7RRCgnfzmhC9jEg0RcNmJxL
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9be547-456d-493e-855b-08dc58a81a27
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:16:59.6152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JhS9De56tX2za1yhFsDRrkzlDrtoubB5+r45DJnEkfI5cezLj/q5G4nqp8e6Z86LQjEQ0vDZ0ONXrh1xFuH/bDQ+rmXI6Q1mUF1XTfHBaSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6687

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
