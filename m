Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CC713329C;
	Tue,  9 Apr 2024 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675300; cv=fail; b=KLPhSg0Ur0Z4m/MXaP4ODIsNyZhMJGixo7HNHlhenVWBQ9nqlAByfvfu9MmhqeHUJjcUrYbYTa28kgPqSqxuaoNZFZDt4pfVP9WlUFE2t6verFQA14rIcWpJOckTVk5WOPeuIH/44XGI/tY5KcwX5Hi5/aX4qmvNfQusgDokqSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675300; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=A2O07zeF4q2WTRj1C1v4s9LA5UayygvWCZ+dJX8NdD+gB1AUszRZDwVC1u4cKL2E9xz/pkhV6TE7YqO6XXf+PkzfgRT1/S1S7dgiqLzNI4utr9V3dqVY+7c09ju2a6CKJERFpAEVio7wJD96Cy1PtFVHSPbXj3E03BYUxhAqaBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=IJr++rTD; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=M+nGMEh9; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IJr++rTD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="M+nGMEh9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675298; x=1744211298;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=IJr++rTDDKw84VWdPCG7gG/c0jq0qxQFFMDIaTxtZ+t5VCVk3FXA9JJB
   gbN4AVZeIXMnMaphAQ4c/R7xSMZFpCf7O2tCBlN7a0DpEs2CD1mx5bBA9
   UKh8HRyijLfJ60BYr9DkZnMbLOa00odHfzuk9XshSMhg2g84drR94/dFu
   kpK4r/5oRl5hmAyYS9tqkeg094fSANYhqC73/cJy19vPgHIQ9HUxT2l+T
   pFsrDfvu63fVe9pCqmOIP0aE3mg54iMVFOTFcOO7WKtQL8JYloepGYS72
   xsqs9MNnYpVRQihuzLmaPQLALsmZXtGmSRTe3tocIGq9aRMJzAzWNe6D1
   Q==;
X-CSE-ConnectionGUID: UdkqvAIdR/y6qSqCSR81gA==
X-CSE-MsgGUID: Ty74lvF7TZ2JRr/HU1CzFw==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13601520"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:08:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9GH5OV2ZJ9mFrN5+Vzuat022xq6jhphyTDfwas01FB8n9gD12bGxO9I8KjkSGTemwJa0Ip7e6JDFv1jRz6ZMrlPbUAzYStFLvyeGAc2qjFQWLkJzez5+YSXnA1klJi2o8WA7YJPQZAFq6aW+0fgiq3TQTp3N06OhNWjswg4aSUgPPIhRafbJcnr8YKeQrHwgnFU10UK+7B9HcBdTPu58rOvAL7rWIArqeUiyc7SVF/MBqG5X4337hYDKDbhIQZRJIqw/+r2mSU+jhNTBVgFqnTkhJYNOnScSCVagvYhaEcDKI18Cjx4+Zxiymp7dxPoAzNTGQg3s6Y+n4Iw7upiZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=RJSOwM6Oct2ZwpQsJWw1n51rfxiWK1yOW+LA2z2KCfLRE3FpCrl/iwmX10MRh9Rb82gm877SDIEOdcimdby1NalP/+iUn+V2U/Zz53LymPC6UKrn1GE3iGy0wXyu1ekXFCBti7ABnf717CsrZlUlKRjI5p+LJJnnK7vPQMRA0/cRpCD2R+kWcp5K37GCBnLrFe0oLOmI92tos7dVAiHH7+Wgi8utr/4wXFNcSDG/BpRJPpMyqeQ4jO8opoI6V0VEguI5qeHVpnqpPTp7tS4yklE4qJccLeh1sqklka0ZUrUOW/bw7TeCn6oHv6g61ieuB6GhO/mnjFYnP4EqDXuJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=M+nGMEh9S8TLTQTooPLlzqyYWeufc+QGOEowhERw2LZLCRePrN65XzLrnIIw8LtRdFk/sf9+9LvPsNcVeAtKwGPtrsxoDAg0iqJOqgMdd3GIFS0HAT0SzrCmi+zFu6zhU9VH5sik5ePLSooIKwLctNQWK/zzcJCRdySBoWLUZJ8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB7715.namprd04.prod.outlook.com (2603:10b6:303:af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 15:08:11 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:08:11 +0000
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
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
Thread-Topic: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
Thread-Index: AQHaioulb6oCLfKfhESSdkBL43p8crFgCmGA
Date: Tue, 9 Apr 2024 15:08:11 +0000
Message-ID: <5657792f-7724-4ff9-9ff3-a124ebd52006@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-5-hch@lst.de>
In-Reply-To: <20240409143748.980206-5-hch@lst.de>
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
 UYKZ94rrEoKkMqCS/CRZn31/FaZtAp9tS5NX70124OiLdV4XclbGWNHz4EZuKTVHlcztY4G8pgeoJgqqhnB8Ut5lnJfq7euAU+nDwZXjt+6zvbJX953bj1mvo480TNR/ZIFedueSiNJCjmA+1TCgl7OufpteEDnlZatb/0REoFDxgcX8uQw9v8LghGihi2pfkNupzfMjlIlYEUfirh1NitqQuNr8e05amqRixjNpj/1YDnaVEbdGC1o49kFznFdm3Z+kNiAfa6e47oGrfOP4r1zdVtn9IzyM4TP7j1PYPYFoQS/vXQbYtvHTDleeEdPDJXUs0aCtTVyR95erbywpLPpeRaRoaaXU/r6hJlo7Cpz3ZMoff3pAwNoNS/PSJl4p2PvGbLSrn4YcBF9pCQ8TV4gUxyZHDnhHEeUB7RMS67hujDPt7wzlfEnYG3DC0fNxldC0RBZKuCAu1yVxQao9WBoBhuV9oof3pxl+JFa3yB0909GpHMVByK2LVx5m/g/Oow0eNoEIS4g7s9EtIjp4taQRaWl76Cu60cUERVKLdiYTJuJWJ3CUzqL4Wbftet+7P0eIWV6ewX+McfvD3YWQZDZr0l/yjlmq6vhnrNZKElzIUX+VH7fnR/Kt178qVH4TMLWR/gmXl+sf+bkUMd0ZiCLB9DcNZfTqnzzG08sm+PM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UjN1NC9ITGJtdUdUc3d0RWdNTHU3NENaNjBwYURtN1d5bjNObnpDQVUwWEk1?=
 =?utf-8?B?NDQ4bi9jWTRGSkF1c1h0ZUZpUzRYM3IzYWFMRmRsMFZhbVE4TG1PbmN2VU5o?=
 =?utf-8?B?VTVheXpLdERoK0hHRXUvY0NPWXlOV2xMSTNEa1VZdmhlbWloMVVkUzF1VmhO?=
 =?utf-8?B?UU5tUnBXZnRUb2lMWXB6dUtCNHpxOHlrd0c3NENmaFVFRU9BM3UxaXBvcVRE?=
 =?utf-8?B?c2kzSDJpdTdjU3FCMWpsS2RxcVJ6Ui9wYU1XSGphVVp2NVppUUlPYjBUc0pH?=
 =?utf-8?B?TmkwR3A2Q0dlQlpuWEhRaWxhb0E1SnpRcXp3SjAzckZNWlFwcTNTWUx2N0Zp?=
 =?utf-8?B?ZmZtTEVlcUFCZmk0ekF0TEhqY1R3MCtqd3lLYnU0M3l1ZThtOEd5ZXVjZUFa?=
 =?utf-8?B?dWhld2pUNS9kQmRYdmhvN1J5TUxBS1k2TUIweG9wTGR6U1hMZ1FMT0lENm5I?=
 =?utf-8?B?blAxWkxZaWpKUmVSeDhVd0tJdzdwNXlvUFI1MFh6TDhBWWJEOE1BenFlNGZv?=
 =?utf-8?B?ODQ2MlEvRXlwenprelFHc0xFZ0Ezb1JoQy9acmJmTE9XbHNDRm5rcTlkWnRG?=
 =?utf-8?B?ZlZhb1laQlpqVGxQT3UySlVVRERHdmVtWU00NlQza0E1M1NnKzVoTkQzb256?=
 =?utf-8?B?SlE5VzQ3b3dHQ3BWVU43Zzg1cDJlZEhvQmp5bHhzOHVYblBOaGU3YkFoK3lM?=
 =?utf-8?B?UHZKbXdpb1cvVDlzeGM4L2tVcngvSVFFRUNORHdYbXNrUXFrYWdCeEZxY2hv?=
 =?utf-8?B?VCs5UGNTMGZ1dXMwME1DeFRPM2FxeU5nWno0SksySGdYSE52M0lSU2w2dDZJ?=
 =?utf-8?B?WU9lMkZoU3JycU5DSERWYmswekM5WlZnb0FXWkt3RGtNS2s1eFZwS2xTNXdI?=
 =?utf-8?B?MDVqVlliYzVtUlNwYWZ3MmVuNjFUWFdvM2hzRWNKa0Y5OGhhaHduSnNzYStu?=
 =?utf-8?B?dW85ZFdSZEtmRGg2VUZkTEJhaUxkN0Vaekd0UVZGSXF5SFhzWmc3d0xhdGFa?=
 =?utf-8?B?RCsycjdUNitXZWlzOFF0R0pFZ09wc1l0czNoNDB4K3BuM2hEYkx5VERZZXNj?=
 =?utf-8?B?dlIyNjU2a0NqUG9oZk14NHhUOExrZGk5eThPU1JwSHpXSzY5T1B6cmhjTGZn?=
 =?utf-8?B?dFdzU0p1citvRjlFaGtwYlY5bGNPWTc3d2pRY3JDSnRpYVUzcGNjeWx5ZCtP?=
 =?utf-8?B?TCtEMGVKZVRrSmFaYWVyQmFJRjhQUENUODdvdG9zZDFRTXJVME5VazNWYktr?=
 =?utf-8?B?MDMrV3prSUNGd214dEZrMW9tNFJnVVJ1cTArSEo0b3p1Vnh3SU9pYjU5ZGVZ?=
 =?utf-8?B?b1kyOXRnWllCUlZDaXB1YWhUMFVmTjRMUWsyNkwvTnpSTzR2UnpjNlJKV0Nk?=
 =?utf-8?B?UFZoc3U3UHlFdzhlVkZJRkVvakNiMUppRXo3OFN4K0d2blFmaTV2VmZJcldx?=
 =?utf-8?B?cjFVRU52S2lkcTVxb1hIaFQ3M0VkMDdoZlpRZHUvcUJUWFV5Q1JOdldOaklY?=
 =?utf-8?B?MGN0aVc3Q0hqTnN1bHdQOXRGa1pjcFFGOG5TMThjdklaQ1VFQVJRR3JPb3dr?=
 =?utf-8?B?TXgyMmljaUxFTVZBK2pmcWhIaW9OQ2JBY1F5dnFpUEJOM2xmUHZ0eTcwL2hu?=
 =?utf-8?B?TUFkZndPVk5nd0tUMHZKL2V5dkkvVHFvVnQwSTBzdHAvamJVdGZudUdmeFc0?=
 =?utf-8?B?bjVta1BJQmQzNElVYTdZdTRha1Y0SVVvdDljcXlyem1KSHNScFhEeDdzZGpK?=
 =?utf-8?B?Q2svM2p5Y01pYmQwRFV5UUlTcE1tRWtGdEJyNEFnbGJCNzJHSE90LzZzL01I?=
 =?utf-8?B?QlVXKzVpZVJadVE3K3lrMFRzaC9JcEhwRGFia0dFR2lZSDVHajBtb0hyZ3Nl?=
 =?utf-8?B?dWNnV2UvQmdsNmkyZUt2a0FGbUFjZ2djKzRMNlEwTHlWVFBLcklDa0ZUb00w?=
 =?utf-8?B?L0tpcVVzNHMwRkIwZ2NPQmNzbExIaFdWSElXZ3pKcVJybU5PVHp1VlpWRytj?=
 =?utf-8?B?V0xXRDM1U0hwTThrWHhpU3pRU29VNzhCbEoweHhxNnBvMHNRUFhEQkpvaTI4?=
 =?utf-8?B?MWR2QnRmOFc5a3VIOTFZM0ZBZUVRMThGVlBoc1hpcm1XUUt0UzZLMzJ3WkVO?=
 =?utf-8?B?Q1FYYmZkTllyU2NRTW4wNjZYNjJqTkVzQ0xhVnpMUGluUHVGZUpGM1RPTWg5?=
 =?utf-8?B?SEE5TEpFYlRBMEtMZkd4U0ZMUlZ2bTBsSUswQ1RRdkd2SDk5ekh3ZkFHdGxQ?=
 =?utf-8?B?NEN4dXhaR3N2blhUbjNINGNZbVNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04675840BE0BD04BA508A4FBDB13016C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z5rXQ5OzVXFXnZFadmjfqwK5JJCSwzpC0ZHNrA3gtRWpBSyoid9DEpJyhs4sk4JBD54TkLy4Z8Iw9YRAvzK3F+0H2L7fit2vJDhEtbBgMHIEsHKIDYR4rjEezG0noySIB0nsnwm218wbe/T1km6Opfh3877JoXbCetFZTrM1YPJckrUiwODXhD8EdylzR9I5bGUciCT4isq0lOdlK/PEcF5l6csuuh8nnhgV5H6a75ibAqYle7zXM2MMQg4Cd1r5GnInSgq6GYjdWH46cWzAqf73Jjnp8cfKHI0M1uPLNphd8awTSMo7YlQhY1b9g5uApF/F+8iNXYdQxZ/k60eZVaoz7HecWSkah4EAl+knJan3B0KoQ+geN5t33Zhv7IdL2U+0ZRNfuwAW+MzxKDHzHtvz8uiLlcLaJv43MlbLzdqG1oyj7w3pSa95Op/pIxmT67tDwbTfuQLZKoIQYu5AQiR1XLQr+iprT2Vuw30rtTvozx1zI/MRKcETuUjXIcObC7bVUr3JNek2e9ibLlc0WjsKVgd5vXWcLpCsFg8yDjJu9sGqHuO9v5wxI0cfjYoZERSKOHTP4dBSTZBKabEWTxjFan8Of0km7fjjPdZcevD7sOWAiPKrJFX92zDFLGii
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c7f211-a22a-4d49-8be5-08dc58a6df95
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:08:11.8152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbPpH8RjKdJ98nliCI0Ff0HXMLshEUSpU6BEK2gUzbDl6++SJ29LOb8gltTgDyS0Wv5eEVkG8y7Wqs8EPmQiW+4NOaSjl0IayW8BE4b1TPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7715

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
