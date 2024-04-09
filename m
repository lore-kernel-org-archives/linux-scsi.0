Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD92312D1E7;
	Tue,  9 Apr 2024 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675917; cv=fail; b=Ggcscg+5jNWp8OSQegG9Ce7Y8tqFCM28HG7hapJlT64mrZeqwrklqLpB1JZIgrpC/Ao2VwCD2GXurfdwFWe1apioaq+pDa0EZmJHz3IZax0Mk/KrtpjiCZSkG1/y3cqB79gg+XEtPJfFZwn5V+XTIZlr1KJ+6vaw3SBfyp1Qffc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675917; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fpm12bPrUN3FQZs5t/dF5Ywv5Xb7YNl37rTmirq4FGJlucQ3xxS2npn5auvO/nSVVBlveDM8lSigHSDwc3mQRcOahkczGZWLEVrBDJZdxbP9rdQHqFnCmkUO40LCNXE3Rl/v1MveADpu3R4Q11ggqwnC3J9OC0/RPobSxvPiL8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZwBj5w7t; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=CJK5HwlA; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZwBj5w7t";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CJK5HwlA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675915; x=1744211915;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=ZwBj5w7tbJbUhLWkhhJxwhPeP1A+NMx3Bbefb9VAEJQKHucPlDAw3ENz
   JiAb4XjgIneSKzlZgvYGLC1LIvD2UFNRX0WsfFXXQPmFupOiVpU5zzN4Z
   B1vRP0XV39+in/bA0Gahht7Oae1kvloqfoURLmUfT/yA0ht93LBcUFkYp
   CFdeBvVXMx080HFg2AjJJQfoTkV7DrODxojUaAxFa82bQ6VuqaIbtIfJU
   to9fddYvUnJr73be+Tht3llcC1cTmht38SDuk1zNBltNINgw3wd8pYTTo
   8slBYphRnynCMHlRN3v/Yq6/7IhqvFHXl3uSvLhjIHUxAIDlEg+7haaoK
   Q==;
X-CSE-ConnectionGUID: NmRSAX0VQc6wIQvYBBl13g==
X-CSE-MsgGUID: w4ZZHQcyT6+bgARFNxKdnw==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13601904"
Received: from mail-bn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:18:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcZj+lDx0bjMhqk4iJHXenKEea4H/4JAa7jo88SGPGB1ce2DYjYnELy/TcMnQ9tMgJVMMeQohJkO9LOd6MJDavek4b30woeN2IPOOkieWNP7IsCWlWJbcud8YxSpnmuwEM7pnRW8rlnScg86CfSahXoLeEUbqarOeK8UwOSyXsmhF72HcMSVEunnspkWNKxNJkCqq6iPS5k0YgA97d5O+CgT4RZdqHiTN3Z2ez9wsLeDrdKF6+tuLha9YxOULAh87kwcf5s9jp19uMtTn+6MXA1Wlbv0+bwpgHl3BzvgWMEcS7JuLUAiSLURgGbzi6jYitPc+T0+B/Z7CHRDRJoq9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=KPrzYcY+rlJdM7h8R6Ktr6omqFa8m7AgxLZL2GMooGjJYOLN+5sXHVKS+JzrWu5xxa8uYGrayHdVItUpH4DdoqALcyGOl9PFQgoYxhIm8yHLu0ujxtI7YrwwlGO9fiQDTy3XvPkfizbmEYA3z6jo1dthG6YKcUexHJUm4/3mx9VKiZOZqgiFDb37IwIrvvj2KzZodEwG0gSfcziDd/csscCNJl2XUxee0cwaaApVZd94RXrFoBf57pjHO5PDZOnkpHPRH/sGGPsG9BJnCTAdJ8DsZe6U0ASydeeOLOTyUtQBlGbzVAOpo3RFYgOv2gZOE2k2OqVIa+aslGv8ZcOHnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=CJK5HwlA3NS0FOgixn1BXUQHASka694y9W0d/ym9yzc/91rX9pzwkrZDea3QLuU0xFIjSC6UL9gAOKzXUbHHCq0SB/r5tBH6wUz8n5fg3S69v9+PLVH2bHCEUdQ6rNVnV3M5LSVP4N4x043r0dTVnO5suDcP4qlkKtx721vxp1M=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6687.namprd04.prod.outlook.com (2603:10b6:208:1e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.53; Tue, 9 Apr
 2024 15:18:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:18:29 +0000
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
Subject: Re: [PATCH 13/23] sbp2: switch to using ->device_configure
Thread-Topic: [PATCH 13/23] sbp2: switch to using ->device_configure
Thread-Index: AQHaiovw+6K+Ju3FR0+WcJEiyWI6wrFgDUKA
Date: Tue, 9 Apr 2024 15:18:29 +0000
Message-ID: <c0bd2801-74c5-4a74-b314-f119de6a927e@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-14-hch@lst.de>
In-Reply-To: <20240409143748.980206-14-hch@lst.de>
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
 nKHXYQr23KUrW/6bIe2gbfL+7l+HeSz8J+p4tv+jhMYR5Os7VU1M/Odq75qsjKCpMIvmtBoc/xbXars8XTejAl+84ByIN/ZK8Z5xDLeNlwZoSgrvwgohzYBpeVOXCOfhDASHkK0bvrCVFcayGFL/2vL8AYkkmuKTnzgCvSPaKNPj0iq4dWYEoF2Tm30jCYMyOuTIK+r+MH3KypKh051QFbhDpvfLQXJPs4N/LLzM+BKpaYAr1tRqNtIAMZGaF1YxCMNOhoUacA4Regar+Ho9SRTZybFESWfb6VL9KmakmqliCRNGohrScbAJYSAvaZmvUjbU8ft9IH54a5Q3nZEZTtf/OUgK/730SFB2VcH1HxLoO36lJIXZ70ruio4JEt+q2nvynwSr98e943zRIXka9iVyk7bKyXj+EOFxxMsvijjQ/ceWZZz76o4DnMmdGKVeY2jJdyjQhOYOZY47QS6E0e7odd16y8nfZXjoV6sDN6godubn++v56GtG+hSVKK71gZjV+u9VEeNfTzoEOyjb3MBRp17cX6VD0cSODT576sZeLvZyNoyyG+7E21d/WJp/X5Bj41tIjEjjsNQS4AGnoD2yYQXoLLxA1jqB9g+bdfnjOaZ2Wlhk8fUxIeSSl3is5lLMPe35zf0wj00DdRLOq6bu9LCtVnh6z5U5wPFOyEQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TXVDVGkzaS9DZU9KbTFBVHhUN1JBMXRydnZwMEhDOGpNcHZtdGZMYzRXdzY3?=
 =?utf-8?B?MlhtYjltVHJGaU15SWZwaFBtcjY4RlhBYTVUczBrZnNFaGtYOUR4UlUyNEM2?=
 =?utf-8?B?enJzZ3BmSjBHUXl5d2VFWUZTNW1od1F6TTNsNWV5c05aYnlLS3RxcWFzbTBX?=
 =?utf-8?B?Zkt3UDg5eTU5WnZkTDdUaElmODJkcm5sVVZmVmRkaEhYbFkxRDV4NnBjZUZG?=
 =?utf-8?B?cXRQTis5YldOWkM5VDFnZWVtSUJaellUTjlWK3c5T25jSXlybmcvNGNHZDJ1?=
 =?utf-8?B?b1NDVGJ6VTIwekZIVldPNzdaa1FZQ0Z1ZjVUQSswa3pVdm5sMm1vbzNiQ3FW?=
 =?utf-8?B?MTJHNTRacFNONW04c0ZKWlY1d2NEY1p3Y3hmMnVsaEN2SzBpaW1DQlZINmpT?=
 =?utf-8?B?VmpjVFpRUytVajNid0VnaVR4TUhUTHVnVHBBbTN4ajFzQUNlWFcyZDdyY1ZZ?=
 =?utf-8?B?MUt1KzM3ZnhBSVExZnI1dUYxRVRKRjBSbGV4SFFYdWZWUFVxUkZsb3o4ZFk2?=
 =?utf-8?B?WjFzbktGSW4yejV4NVdueTlzZGg3cWxSb0V5b0locFRROUU1NUE5N2E1R2dB?=
 =?utf-8?B?MUdEakUvRmdHT3E5R2prU1BBNUNYbnNlQm5mdHR3ZENoZ3pBOWNtWGpsVnRz?=
 =?utf-8?B?Si9JaXpVZ2FCVmk1S2pFejNwcnFLMC9yakVQRE5jY3JkU3ptWGZPZ2RLY1ZV?=
 =?utf-8?B?YkFDMXhtSVRDZks5VkJQeFBvUjhPZTA3ZGFMWkZQWjAwNUVyZ2JwUytkOHd3?=
 =?utf-8?B?ZXB4cmtIQzFtMW0yZGtROVpCMUgwN1plUHRTYnhLUXBBK1llWWFkTTBpQ1VS?=
 =?utf-8?B?SzVjMFVwNTFsblZkQlUvc25ZOXVtVmdZL0M5L2FJOEFmdFN0SFUvREpWRnc4?=
 =?utf-8?B?SEYvMzFQeXdMWWRHOUw5NVhkQ3BUNDdiUC9VSWMwODhDRGo0aXU0RWFidmdl?=
 =?utf-8?B?TEtlNGk1QTRsUm45T2F2WlovTXd4NHJ2Z0tSSkh1cEIyZzNzYkVoak50NGlp?=
 =?utf-8?B?YWxydUtEdGU2WFc1Vk82enJ6MitrelY0bTVHbmFkY2FCemVoZmQzYUVZYnkz?=
 =?utf-8?B?NmQ1dlA0RmhGWTZ0MVNWeWNnZjVzN3JFeElhYXFOUDByR2NSTXFJK1d2T0U3?=
 =?utf-8?B?N2VPYkR6RlJGNXRxYlhGMTh5SXBTQ0VPT2hDY3pkSmhNT05KOW1Lcm8xaUJv?=
 =?utf-8?B?T0xHejBkRmowZFlUR3VXN1Z1cDVYa0Yrb0RWNGNhK3ltT3NCSWRWUlkrVXBC?=
 =?utf-8?B?RGVvV0FTUW5PejN1dTVRSVVwZEhBNkwxUlFOZFFoVU45alVFdlZhRDRhaXA4?=
 =?utf-8?B?YjZDM01RbGhEckF1dm1LaUZlMXRCNzllZlZlRXIvZklGcGVZUmIwNXBnaVBr?=
 =?utf-8?B?eFVia0RBSGZiU2Z5czNpRnBhVnVEc0VjWlIwSHQ3ZWdKQ3cyQlNLS3hSQXZm?=
 =?utf-8?B?WE85a24rUVNVUXBiOHRWa3RpOEczUktPdjJ0K2l6UlBnUGhLUmovZlhHL3Ja?=
 =?utf-8?B?bFpsRHFZdEZncEhNbFhwVE1OQ3ZwT2EvWVZMM1FLL2lLc2FDY3h2aml6bmt0?=
 =?utf-8?B?THYxL2VKaUw1Nm9NelZVcmI5SFg0WlNEUjNIb3RQS2tMd0QyN2pHZmg4bXVx?=
 =?utf-8?B?WjNoN3JKQ0swQmpJSmVHdmVHY0VhUjRIL1hDN25aR2ZPUGcrZnRqcWFPMnpl?=
 =?utf-8?B?bXk0R1ZsODlyMWxlYzg2UWJhdjBreEUxVXdQWjd5d09ZNU1PWGJtRWxiZW5z?=
 =?utf-8?B?OXFpejBldlo5aSsyUXd4WE1YS1k5aWZ5THVuNENwVk9TeU1WSjFVRldUb00r?=
 =?utf-8?B?eXh2Y3pYM2w5K1lzM2dJbDJNcE16R3NrNGMyQ0RPZ3BPZXk2TTgrTlFISlFv?=
 =?utf-8?B?d3kyQ0pUTVpJNXByaUhIUW9DZDJFSU5tWUZHeTBwdFBKbXViNXRnakViZExT?=
 =?utf-8?B?bno5aXM4N21LeTRVNFVDRno2Y0pBdUdmVmNhVm90Sld6cUYzMkVnbFJjWTA4?=
 =?utf-8?B?WmEzcVUycGtoOWQ5TjNsWHJDOUZ3cmdEWDNWQytjZngxRXdHY0czbXRyVjlU?=
 =?utf-8?B?UHNCZXJZWldEcmpzLzArdGxKM2x4emRmdFpFSFgvWTl1MFYzY2JIMkhVZ1VZ?=
 =?utf-8?B?dlljSUNzdG1DamthMVR2QVRlOENkTHN0QTRqUGNKcXBKZWNBelBBNlRQZFNS?=
 =?utf-8?B?eUw2RzEvRXA5U1BLTTZDcUlKQXRkSyszaExpNWdyOW05bnU4R3ZCZlBvZGNw?=
 =?utf-8?B?UDFJTEpUbXcwNXpKQy9vTXdxenhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D1A7B5A18BACF41B845707A1CF79D8B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LuLpzQ8IJdud8kT396pWSuWQXEBMiJpBA+V/FB8dAXt8gPJrC0Fq9hsc6g/bem9OZljZmqJpVN/BWNP0VfxI3Exfim6cgXHyLf2K4XG1meyn6zj1JrqkuMkKuT93lBw7Tnde4mp0gbZRL575IvVglecWwnD9hajsUQ0TEt9o5ckXOJbMpojFAVeQeL4KpreJIMwKgFznPMHLxvhwWQG8yw4qpJgx09v4+YlMRLKmviTElaQPil2Ea1kbqDoJloFSPbHLJrzVMmupSupcEJVvimycNDFxAahc+uC4WXtebgrLCLz0Ricenkx5Ct0m8Je24DR4/23O4gnpdMEn1q21tXn0agydxD2SBDIUxAtAr2ftjIIuiXLsuodcJPJqHmzo4BT4YUfwvKgT/8f1DgIpNNoB3vb9ysxJKneYmOhZl458oQVkqUGECxsHGiK1tNSFpMYEcpSGG8y6fbninVfWGhK2eFUD5eD3ojkIjR9Jdpogv0wN7oiryVJ0N0EcYqNRgCojfeYUpF7nHj2/PoERIGQkvLn+K8ZC7+EHwaCS3awNxU82iss+M4LbJUsUc5UNzid081+T2Wv5XTJC3NF1XOCWr0BWK3ETqfAthFjzS0CfXYEwOD9i1LPTbKj6pN+g
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a46b853-c111-401d-37d7-08dc58a84fa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:18:29.3204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E3xk4lcsfQd+06/5j5K5eoYYNwnTZITzCKMVOb/B5X4KP4Iogz30Swi36zN38eP6RofJiYz01PFRIZ1m8ECVyfDd5tDf9s6Rmq/NHOikJGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6687

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
