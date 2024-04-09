Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A79A137743;
	Tue,  9 Apr 2024 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676041; cv=fail; b=pYKubYH04vdV/GpJMZ4QJlT9mp/rSuabL47LIJiEbo7vYEoyKFekkTlE0PrYOHMom+D2sSAtQlR0s1jmIyHSoo+cG8OcKccrie4V0QOQXTtZLt6Lc0e369H4p40f5MeiL3c8vQr5LgOkuE1vQ9a9dLBvnMSZTjdEArSFquIO+WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676041; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oF6Hw2XMoYQf7dK+qIIHXeedo/OPHuK3DducIb95f3OBGZQQaRE8rzcrsDYVmw4AfpVUotcUH3Fv/RlAKVn+r37AuE6mB93/e0v2GXcONBq2n+oqu6qttFYd13nZ+OCWsPw94SIAE7gEY/o77u0Yt2Ch3o9X2CuoPYwdf15jqi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=pSGjKqK7; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=MwC0hqf6; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pSGjKqK7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="MwC0hqf6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712676040; x=1744212040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=pSGjKqK7ljepV2V2DwmsXzazPJNbzFKNYjREqDhC7AiJlkorurge9m0t
   ib1s48nSUJ8QcNEUvodYJY5DdDS9INyW1RjZ82ws34Gf26SD8/VKgUoQV
   8EndT8/TCl/HlC8KPZ5U/cxEId8jFm2sDBB+1JpK6vHcg5C3dZp2ISwaH
   3FSil7lTkusAHJU1ivpf8DNXa4aEgQEApB+n4GyutI8lpkT1iJ1AbR1Co
   sdmmVQlFaqYDaBxZdfgTMhWr4XB1/kT1QsZVJCZIQaU/zmylIXkqeIkwO
   FRbYMC+meFRhutlMOfcs83QJB0eerG6MUgh7pusEiHYndUntDElER3Vq5
   A==;
X-CSE-ConnectionGUID: qhGl+E97QZqvln77lJyspw==
X-CSE-MsgGUID: 1p0YmFD5SZ60GXvzVQ8CYA==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13602980"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:20:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeKQnDVBFskwBntcrm67CKFoguVtzlOBwW1Dw3mlwVl6CK78+B5O9uj1eXojmyzJ+TKt9/BVR9J2KMAztr0Eg+87UKqijULq/u2XO/l3cTicdZfHyvVdbMhsW0kdZoHGvtWhs0Xa0QBd/tmjH2gC04KNPR2ge/JZ4wc67Mgp0xJOgI38MVbzbKS06deETc3Yv3NErR80F30AE30TmsA/coo4xznE5VGUBEFBs96OAbSktIsDdQtPWYu5HvqxKczZR+5M39TKjR/mmvHXk7c0BUPE5CdjicGsKB8z++DEuHHChJf0JqVdTiiRWbcyDaI2KYeFwG0MarHclPqqV5rKsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=dPx7jSaj6KSl2l/dfZXoeAfI83DoGGpCmjGusFAni19LPoe4PmlKPDpr9fhmYFsvZJgA9CZwGmCASgfpMrxEBf5jt/jjmdwkbcQmJBjr5Z0Q8EKl2eXDotBfnhRHNbEY8YJOgtPp6ELyvtu1w39F/P0n37g3VTrPR8rORrdcvU9PCOWfu1LD2GIrOW0ss7ZKhq7mk+LfMopgt0qABwjKAwXFCdAIuYNqgw3ec4IAtMQKIGupjRDY9PCxo0cTRwwAFLOiBEvUoxnP9L+Ll8YQneOucIVg32xTjHHAXeiycrqgB6KXe042yOk5WZ/Y8S0hsBZTN25TyPL/helH//Y/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=MwC0hqf6by4rDZcGmHsoQrUzghfgb/hpXCJqxOkl366THVqIq6OKar660e2ezMngDH82LpWsPj8vx0k0jWHy5Iffh+ry8ORW7ymdOS3bItMJxAVKzcMUd/kS8EQH0ztCnEAS4JIH822kJRKc1Iq5Tg2QdrADV/ikGdkDOnpxQEQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM8PR04MB8103.namprd04.prod.outlook.com (2603:10b6:8:2::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.46; Tue, 9 Apr 2024 15:20:33 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:20:33 +0000
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
Subject: Re: [PATCH 17/23] usb-storage: switch to using ->device_configure
Thread-Topic: [PATCH 17/23] usb-storage: switch to using ->device_configure
Thread-Index: AQHaiowAhJKdm+ihHECoHvcbzmn+zLFgDdQA
Date: Tue, 9 Apr 2024 15:20:33 +0000
Message-ID: <7d597579-a4cc-410b-a410-552e2bdd91d2@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-18-hch@lst.de>
In-Reply-To: <20240409143748.980206-18-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM8PR04MB8103:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 NcC8vMefa6npiIWAMjJS+EojB2KtqxMvycOprzNaE6P2a4g1l+2/AZ/on5ALeinRcHCcov0Ytkc7G6C6PAlnqBn3h20PSQ6jvYn27NjefrCPBGgDlywxF1Q5DCSaNtOoLl6APM1DZBmS2/QQgIS7tfdskyzO+Fl/0cm2QTIK83iK3YL+JeA8fHCR2H7Yg7KQNYiPx3dxqfF1cLo7j/n6taJ91jr4+CVgXOY61l//g7Vjsh2eWkE1emexvayNjNgYkXPZ3bObhxbzG5GKA8XW4KjKvL14fuJrQnwhjeh8B0NlDZmsJers9zKmAKahHZs5L4QjVjKxJq5ShoMtfwry9QamKBa7UVZIHb3do1kK9hJ/62wW+ZDsHWk/R1mkWqRbbGhiUFkWom5b45YOC6tqgDcxDRrfzXAHQIKa7IxeSHJJPTtsSzYpTMYGS0syEGLMMbXgSUeqcPTnHbp4CnAFlEehSDIVzidjMeZjBOPfBTk3A7krtcHFLeunspTe/Aip5kpCmeqduGHQ2wFFAHxlheD/FN/AxN5GcmBLtVmSueBAUm/Cuy93KhNiHtLhlM46iDsmzQP+5pcDR6wzCYkF9CtUBFIYgrkdsFpIvTwVBPaP1TCMt9tG0xT5XcGboyAAByHTIpOOw1mtRytDI2H4ow+16fsl9//l4eUfL9S5Ais=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eG1hVFBLSmRjWXVpcElLclFuaUtrMmdzUmgrQ05HekJRRkJ3QlVkYWdRaG03?=
 =?utf-8?B?ZnlxTWpaV1F3clQ2dTJZY3N5MXc1ZGVRTEFTcXkraSs3Q0JLdnRqVlBpRGox?=
 =?utf-8?B?UFluWk5Ob1RyaDJoRUpPK09Rays4VTN3VkdtUStBTlpYOTIvejhnV3hZa0ht?=
 =?utf-8?B?QWpBd1dyK2w0N2FiOEVPeWY5aEtDbHczK1hQUHZBL2wyV3VZZTlTMlcrMExr?=
 =?utf-8?B?ZVp3RzV3M1Bnay9zenR1UEFsSUx6S1hvdjVhS3dVTkhhRTZoTStuNmQrTWJX?=
 =?utf-8?B?cjFTWE4wWEhQMG41YVJldVZFQktBVUlkazY4cHhWVExUMTNIQjMyajBsaHNv?=
 =?utf-8?B?c0xiOEphUnZpZHZ5Q0RJQTdNWXZRZWtRVTZrOXRweFhJdkJqN0xmRXFYY3Z4?=
 =?utf-8?B?MTlidGdBelJYbHBhU1h6NWk4VTVsL2t3WlU1eit1UUhlSituMlZ3KzZHbkVM?=
 =?utf-8?B?K2lRSG83TVozTFNwVlpjc1M4RDN6YVNDNE1obTcwWVRBRjl0a0pxZzUwQmJN?=
 =?utf-8?B?SVlNd2NIK3krRGszanY4dERudWZJaENFV1JYZDEwQlpCY0h5VFBXNVdEM3dL?=
 =?utf-8?B?YzE4eXE0Q29JSkJPR2pZK0J6bm1wUkx1UUdLSUxGNW9KSGE2dzRMb0cybThn?=
 =?utf-8?B?cFE4TU1nalg4c29XZjV0RzBYRjJ5SHNadHVmNXBCTGZkQVFXY2gyTjVackVE?=
 =?utf-8?B?R2N5WGpTNTVxTSt3MWxBcHMvQjM2TTR0b0U1anlhOC9xUTdjQUVyWG5kbW50?=
 =?utf-8?B?WjA3dllBcjdEdDdZOWExNnZTU1ZibW9BMDNBdUlCV2VBMFZqblVqc1BPdTc3?=
 =?utf-8?B?blJNaHh3aHdwbGh0SDBnMG5qc2JDdk9NaVdOMXZnSW82M0lJdXFUVzYrNjNH?=
 =?utf-8?B?aE9XeEUwcFNjTUh1SWRybFlrRVltUFV0YzFRRVJPVVlBaUxMeVRwVmhYRmlL?=
 =?utf-8?B?SW5TdjF1c2xuTlhBYjA2ZnovM2NqVmxPNS91MXFHNVdxM2pSNStqK200SkpL?=
 =?utf-8?B?T2NIM0VOaXFsZCtjaXlTT0s4UUY3cFU3Q3FZd2x2VkMreEZUdXVzWVVQTENK?=
 =?utf-8?B?VitJZ0xQMlJ4cDlhTW15dWEvWFZITW5jb252NGpNQVdQdm8weUxVK0x5elZN?=
 =?utf-8?B?aGErK0xoR2JrY2VERnZrNHNiaEhoR1dHV0dmNDJ4RjJEa1h5SkcrbFF4UG8y?=
 =?utf-8?B?czlVTjZqQlp2RzJTV0J3NFpGRTdDY2NmVnR2TTdaZGRUYVVpRENTWVBRbk04?=
 =?utf-8?B?Z3dGSEFxdmhkd2c3bWVrNmVvTjBaL2htNGZOWExPTWdVMmlnWmNMT2NYUHdR?=
 =?utf-8?B?Ty96Z3F6dDhQUGtBOEVLTDhLeFpoTE5kTExWODJzUHNQM05RdmF4a3Zpc0Jw?=
 =?utf-8?B?QnRiMGFUUUJsVVpzSXUwL3lYRnlLNFJpNnhMT3BvcXZsRlZ3b0ZzakdyM1FN?=
 =?utf-8?B?c3J0NVQvN01meENla2o3LzhYbmF4VUNETWhSVXZaVnlqTjNKYW5qeTQ2REQ3?=
 =?utf-8?B?cFhjNWNyVmtEWUs3TTdvSXd2cXlzRGxkRDRjQVhJeTdESkttNFJFTWdtYUdu?=
 =?utf-8?B?dXN2STM2NE0yQXB2SzUycEhiZVl6TTcwNlBoZ2tFNXFrRkpCb2NNWDh2WWtS?=
 =?utf-8?B?b0JuRnRuNlpvNmcxc2M4SXU4Tnk2ZEowRWd0ckxVTzhUcVdGUmF6NnUwS29q?=
 =?utf-8?B?ZUxDQVFkcEE0K3YyK2tzbllrUVQrS2NvVzJuUzZjZ0hnV0R1cFdYWlYzWlBu?=
 =?utf-8?B?NjVYOGdyQ0Z0UjNFUUdnNEJRaWQrY3Y3dkh1dk45bWJqSU9peGFIVCtIekJm?=
 =?utf-8?B?Y0dTTnlVQS90RkF0QWc0Y0o1L3kyMEc3Vktzc0ZXQ2tYSTQ2QVVHRUdSZENp?=
 =?utf-8?B?Q08rdDNGY0JFZXBFWXhmMjlqT21ua25VQnFBRGdTS0VxKzQzaTZIeGJKQlpi?=
 =?utf-8?B?WDZFT0cxanhpQ3pqS0dPenlyQ045RWRGYWx1b295UlI0ZGU2QTZZOEtjR1lN?=
 =?utf-8?B?VzVuTEdSZU1nUXJaeDBLZTBnUEdONUNINWhmMy9tQlJPYUhCbzBuVWNYKzJO?=
 =?utf-8?B?RklCK0ZHbFFZNWNHbEpaZDlValVjR2U4OVUweUtJcUU0VHVyZFQ0dEJjdXJY?=
 =?utf-8?B?dVZ0dkoxRlp3YjlRenVKeDJiUVhXYlBQV3lUaFNHQVJ4NGhocEtocW9IOUFN?=
 =?utf-8?B?aVFDeVB5VDZ6RnFHcXgxRFk0UjhyZHgzZ3hsQkVRVE50T2hFMFBWRGlyMVIx?=
 =?utf-8?B?SUxGSkdwMnh5eU8xWVFoWHRvREJRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A222019B584F954A9E98E9AB31181B28@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iWnxDtVM0tf12llU/R+iSEn4V3WqLefe/W696Kmr8n5PvsS07agQEMbQeu+yU5rI7lm8f6pLB0i38UfIORnUa1g/grXzKVKNcrI6ABh9WNxcV2E154gj3c3tl91E6CVd1vB6ykHAdzQL6S0I23D2wRX3zjvCLJOWva6FHmYgFUsvxMCzNdKixTiUaXeswMZ8s5t8GY3Vt8SMGxdkY/RquoHx3Ldk6VeG5wVsSIlhvPXBo/OakeWTqNgEKk5IQWBj2vUKa+jKPl3+P49Jpz+bvISuU/aF63i7a+Ap7LDKhe69YRojHg+9W3LHxAzJECAr8up2LKBEFb3JQHdcbgePs0/BqpffYIE04DZ92Gcc4Znvhgrnd/Vj+tcB6KLFF8abv0GCzQ84gpg4pSZoxcYTk08Bc5LD7Ha/mEWerBHLG2ZBQk6qu0SnFujQKuLGHCS8m6e27zQrpaWIm2iJAID6V0gE5csmUwac/pYqeaCWiU/Xq/0PtggqkCIb8fsZBVmqLBxYvY0v8Ifpxj4oLh2IUe+/4eQHIRlUTlAqkYBaWl7v1wPbaIfJqXTF/iPbi6o+Vgfs8oP16tDFnZ5Xx0Wqv8auX/MO7qMSfCmRZ99X7qgiNsNSoTWMa3sEwIUg4OlX
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e272805f-8b38-4ec3-e7f6-08dc58a89998
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:20:33.4390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4WKeteo4Ia0glHPrmbpbYmyot5u8ynT74+g4cqguY5n647kww6PsMcvKPqER/yhCUTb2fOqjay2KZybfAvvYAbw5MYsRbFq852Uto3VB5us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB8103

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
