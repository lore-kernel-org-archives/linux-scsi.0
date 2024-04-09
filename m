Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E76113B5A5;
	Tue,  9 Apr 2024 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675976; cv=fail; b=pGl/VffNq46RPVcSsDo5qdvwaFOrOlad1jvh8j1+HXtjSC9MVAi7X4KlRBQprvzLHg87huopSK2ysv9x3TRzQz7N7MPmXemCoMxQvpjiIkCknYFeSo8SVDZGhbFmvSOPrLklncH5oVu3Bbr8DIk435ydhFbQexPO7ai1OdN0Hs4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675976; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gjS7fKZTHQfs3eOzDL6nx1aBTg14BqToSlbjpfGnpy9/IZaj1+wD6+BcUMEEAapPoUE5mFWHN3pzP9QRE/ZOolyrqMyk/LWp0W2yTeRF+xl+favnyyz0pRoIrDrQElTl7L4NfhX7gx1Zz2T6II7VUS063qKUW4PlfT5B9WmmGA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PDChSope; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=m8HOV139; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PDChSope";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="m8HOV139"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675975; x=1744211975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=PDChSope/JFtewA+Ft/szXsgk+3ACgshzqDMGeG8zbDd/aD+q1NEoZxx
   Mby260BB6Rbc/awYgEa+/n8dT7YhL4xaFqbJjtCDAiaFWPGbZoZJfF+M7
   8+6YElw9WZa/SVhcwXkZS3O1qMixGlTIuWFdfDCkYEi9BxwD2Y1uiYxOT
   dv2vZ7wO+icomJdkareyaFzF7T1SEvWl5fbuvOpHCM4m39bJGPdLuEuOv
   183HJuYIytZ4Pu8Ig9B7UwCNO+GpI3SOfcaY1mzMnuprvodDxaEqJsW5l
   A5s6rAESR/1r6Awgw/ZabLgNHj/N2qG8XbynoIz/+nBZYS681h9LKXdxX
   w==;
X-CSE-ConnectionGUID: FDlSiurbSf2EC7k2G/arPg==
X-CSE-MsgGUID: lRomwTenSCO64v/deQR3Lg==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13602847"
Received: from mail-bn1nam02lp2040.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.40])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:19:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGHYNYoAoFoh42pMvmtrzhgxy5iWmw9IlrkwxtfEXBH71ZaxLpDRftR/xCChFzvcAsEDrbFThZ108HYgTv1pGKJORJAwxwiE9ukKn7y29YGx6kuHebZ7A/+BN+Q2oYks1MVIOtmgiCyO1yOSYfhvpaLjpYYuARYRTx6Tu4PGtRwv2K7pXfJ5eXiB5a1NPkjJyx6BD8gTnWnVdlgNw33wxW1TQNuVSgZa+UjSW/5ltAyDjIjXEosdQhPlM9lV/AZbo3ydzVod6pBnEB9X7neronsMFdr8ZVaPUglhksOq+VtgeuZAdbR6hCX70QGs+qCrVzp0vVTC2gBcSbUYKUeLjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=EiJI2DehRn2eRl9JfEuvrJTXiLOvIoU5M8zF8/0Yiq8gLhayDo6vrwCrH49fKRzJUbbUeqamOnM0O9vZWRe3der9VxwwC+V5zMNWsoXytY4BPGehYZeDmmd6WaLLkIJrbC/oTVHCB791qokCVTzZOPMLvjTVb8i0so3NfY36mgkycowVxgbOX41ZZP3B+IROYZv6uMdq9CvDrR4Mf7nbmWWJb4VsTgaVbyS57lIBuM2sIKOrHCprYseltqpxKodvV1xaqHUrkaZiD1ivI9/J1a9vO2xaLfYv2lI/m4ckKZ+ahv/YBhlKjEDr1FpglnXjUh+G/dye5yNZbKYTjXrGWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=m8HOV139z3zntmsvpfhVjEGNQZ5ncLfGPwibQt+upMS9pWwa6rNChVIY2q1I4vmIDV7Xotu09S+MI6lHC65RGkdlrTAOGmjdZtir5cQmwrHhSTLr9iBPfRiKT3E5+J86+R12Q6FDKW4G6KZ5W+xu1quHPMC3uqiArJgbeuDoYM4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6687.namprd04.prod.outlook.com (2603:10b6:208:1e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.53; Tue, 9 Apr
 2024 15:19:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:19:29 +0000
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
Subject: Re: [PATCH 15/23] ipr: switch to using ->device_configure
Thread-Topic: [PATCH 15/23] ipr: switch to using ->device_configure
Thread-Index: AQHaiov746iIsI2UCE+NzAHj9hgv37FgDYgA
Date: Tue, 9 Apr 2024 15:19:28 +0000
Message-ID: <d2ac5a84-edb6-4de1-94ad-b1da102458ec@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-16-hch@lst.de>
In-Reply-To: <20240409143748.980206-16-hch@lst.de>
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
 oCGdPgIFcmZCZYk0xTYoJDF+y93eD6807lms3ELH9H9O/HzWs0f487TR7G5msHTq+SUQDrnwFDBGVeBXpX6kg9Mh6P3B3V4PeSoJTCm0d2C+qnwIQlRMpGoc4kQAnMC5vciG4XrYBYQNUAS+YN3q1g66S5feuTSpa/rfZZ2Vh7QiLi+P/QMQWceZlTnXadVvzs3Ugm2+UR0vi2fwPyJdoCahb7+KYDnLD8zNiHHOFWTtY8LIZjF+2jWp4209Igs6Twk+BcOGjM0USDz+uXCIMkj/iCPa6yB5iuMMSwyNtol9r+f/amj0ztYXxb88rg2G1GQg0xOh8EICmUOzG8a9Ng94no5aa7y/P/ovMEEAKjTgszoZbiCkmPcTFAzLd3QORLjBLZTxDJuvhjT1dzncdDIZrtgSi66uV9Bhlo3PD6Ii3mX698llhCt+4ih4c+n+CDJC8bbSx1PUT8qKvfMjdArVo+bwzXcTvVgcUVLXMWaLLLORo1LN3UpmQs7YH6CpvwC/rozGjVNzGR1RAIq3jZ5XeX/9wMslIOFRSJCXf0t+rFQxV7R7eRDtyZh7FgzylbRjtRCZXnZhKBQNHoTuDzYSGdnAMd73ezlzadyGefyQP+RtCGY5MdGJR+nbY4nZArpmirTJQCqBA93x0GcteTfBJL0wJpuSK17wpW13UXk=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dHA3SVNCNkY3SFJ4Z0Ryb0s2U2tvNHArMHZheVc2VU51a3Frb09JeFFNNERO?=
 =?utf-8?B?aTZIS2FYT0JRRFVvME9ybDJiaHZnc0tWZGdGOVEwSERzMzZoNk1NNVN3UXZW?=
 =?utf-8?B?K0tTcHd2dzJuM3diL3hyRDBCVGgvbHNqYTVmSHg5QlJXM09IdEY5Vm5SK2dt?=
 =?utf-8?B?aGlRWTdFNDVCcUtkQjdSaGlKbElaSEhqY2Vpcnl6WUNqM0tUOWZWNG9Lcjhu?=
 =?utf-8?B?NU5pY3YxS1hKbGZPb0dsemdwNERIcHcrc3FDUFFhRE9helFPYnM3NzhmYlBN?=
 =?utf-8?B?VTFBMHllZ3ExWStHZzNCTHVGaU5aS3BoWVd4cXZQTnE5eC9FWXl4UDU0bTBY?=
 =?utf-8?B?aHMzbU8vamcxem15ekwwblJwckl5STBWbmVGS1RmcjlidjB5alI4Y2s1YWdp?=
 =?utf-8?B?WXdGZU1JMktCT3I3MXY2QmVyZXprK3pZWHlsZVkzc0l2KzNhZGN0K0lGU0Jp?=
 =?utf-8?B?OE9kN0lWQ1FZYUlCYnlVNDhhKzFiSmRoMWpwN1hrOGZVbWJFSkdQdE9OWlhS?=
 =?utf-8?B?SzJ0ZnZwOHBHUUNoUGRielN1NlFoUEhEaWNEMWNUeDFRVEkvazU4VGU4azlB?=
 =?utf-8?B?MXB5TXE0cXZhVG90VmhqNllPcEFYN3h4NTFuNlNjVXlYdWU5WFNERm80OGtJ?=
 =?utf-8?B?NEdOLzMrTEhYbTNXK3FYUGJrbXlGbFRXaTdRd1ZQOHJkc3ZHQXI1YlN6MnIy?=
 =?utf-8?B?ZmlNMHlhQ2cxRmxYcE9aWE1zZ3hvdmpFWklnem5JeC95bmdJdENHTGpZaU8v?=
 =?utf-8?B?TnBYc0VZT0FoRUFrbWRWYUpJTzM3M1B4SFliaXd3U0twdXJnVkNuc0RjcFQ3?=
 =?utf-8?B?cGRRNysyNTdHZEQ0WGkrelEzQlR3VVlaazg2dW9ZdE5kNzJLRy9hVDlZN3Iy?=
 =?utf-8?B?ZXhVQzNPajA3dlV4L1JCV2VaYVp2WDJxOVRFcjlHalJjcXpMVjhQcUxpcjk0?=
 =?utf-8?B?d2pSclo1dFNMbElzbFVPR1pKQnZ0UmhPU1BtSGh4R2wwRkVrc3VFQ1VndzJY?=
 =?utf-8?B?UWZtSWZFeTN4YnN6WlVOVnU4d2hzK1JvYW1jSUlnaWtnZ21BMktCQTRQNDRG?=
 =?utf-8?B?cXJNQTRJdE5BZ1FSZlU4Skh1ZWJDUjdLdVFPSTdBcVpaNmxjcy94VU0zTHh6?=
 =?utf-8?B?VUx1Y1ZDemx3bzRyVVBzcFdVR0VwQXBUMzdPZ09KbHpnckh4M0NObDFDbkpv?=
 =?utf-8?B?NzRZbGhzcWFsNVVCS1lnNkZVTXJBZEN3VXpvbmF3eU9kZnF2UnNMdkZzKzA4?=
 =?utf-8?B?d3JPSDQzekhTSEdJa2x3b2tiRHQ1NUs4MGZ6K2J1Q3MzdnhjSUNvcHJucWZ3?=
 =?utf-8?B?eVVmUndYdFNlL0Z6Yis3aCtsSDRwd2JQUGtlbGQ4L2R4bWoxeGJ4TlkzRTF0?=
 =?utf-8?B?NXpZUDZlRDlVMzRDUk8rbzNMWXh5ZnVjY0xzdC94bGZUT1V2a2w5YXNwaFYr?=
 =?utf-8?B?ZjFFZEdPNHhSWjYxMGxGU0g3Q1dDWUJoTEIwMkpLTzBHczNtdCtMblp5OWdB?=
 =?utf-8?B?aFNXdHNjcElmMjFBMnRiZWZzRXRYdXhYcC96N2M4d00yLzZLY0VxMFFLNitq?=
 =?utf-8?B?QzNrckczR1RveGF5ZTI0dzNoUzhDVFRHa3lnNjhXNmFhRlQ5djYySkdhTk41?=
 =?utf-8?B?OTQySUI0ZDlaMHdsSFZDaVF6T1NzdEh1Zk43R2Q3cHNyMVoxMVA0WVNLdFlK?=
 =?utf-8?B?N2FoSnV3bFpmbFFUZWhhQWdodTAzTG5zRzNzcTF2ZkRBVy9SclpDaXFPRTZT?=
 =?utf-8?B?TElRNDArSVdFbElLQWh6ZE1jUGovSUFtWCtWTENIQTVnd2J5MGpVOUtaQ3Rt?=
 =?utf-8?B?dDNGUFVRUUQ5STFXTVdEczFNenBSNllJdjhKeUxJM2lRbUtUZzBTaVBOYmxj?=
 =?utf-8?B?YnVycjMwc3lzN0dTcGI2MG5TVGZsVnV3eit2dWgwdkhGeXhOZzRUcU1zVGZq?=
 =?utf-8?B?QTdMTy8rNlNXQ1dQU3JxYVNIQ25FLytwY2hyV3lKWGVGTkZHbWJFQ0N0OUx2?=
 =?utf-8?B?YmxxU0dsdWtwbDViOE5QVlhsZkZLUEp4emsySnlEV2RTUzYxS2VkcWJCOWFP?=
 =?utf-8?B?OFdhWm1oTnlwT0FtVTBuNXlQUGdwK0t4M21lckN1NWZlMDNiYTJYSTFUMmVB?=
 =?utf-8?B?SUdhcXUzNElueGI3YWxMeU5VYnZGT2pJSEZCMmFHKzZZTjZNQy8vWFlyOXJu?=
 =?utf-8?B?NmJXWFNzdi9NU1NuVjY1WHE2dmY5NzUvWU5WMW5uVkJyRzZObDN2akFnUlRG?=
 =?utf-8?B?RVlPTU5sRVdPemVHenl4Z0hjeUR3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D954B81E920B04D8FBF92346B1692EB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z+Omy6hZLcHuj3QvbiG3dl3CEJ8AHTg4+qYSur6q6M0lieMIDcaX5J7HRA4I+qGTk4qWYWud07eQ0u0uPxmvZaauLazToL2ZzexsPG5Mp6pT/srs1UlX35hoIWchgpOZlN3lCea5mvPOW9noNSD3etxUlLOYzQ57POjTpu251DTqD74uE9MtmvOgdHw5djAVmS6Cb/4jlsRFrApjgcYOomJBsSeXNzvLv8U99921nRjQc9AOUnp5EC5bB7Qce37qX6o3ApYBesjehB9s2daNDAJyg4Bc9DK3J5ArObHx9wvJRtlzVibHRa4EGdmV8LybxPBhHarCHxNiCXO4+TLdYPf7kyvsHk9o4fcFie16Uh6BPpEKcWXacwTqvIZ1geBTYDcQ8aGB6EgzkZj/1DUD8JtGSOqbA3BG3hB+NnYTBq+nyJAFNsZmoOy6PwZEi4g16aZSCYhGuG8O9OSBfl5aMyxHZF36q6Xaz97E3BRoC8jx8A/Qz5ksgAHZwE29Nmu0o0YBGC5fNR556Hy7gIC+Dn8qJ62vfr48jfW8kefM70u29E3MCQFN6QvNX38js8zD9r3WzmvVH3yUYfbiKPk2tHuF/wpUW1LIkONJVED06hRHZyBwDDSdahCjj+dRHqPa
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5e80a4-e9b5-4598-a574-08dc58a87328
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:19:28.9199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDS0bbvLxsoVxYeBl07b0VpBkG8HBo+1ZV6fYheEveMBfisQaVVS6ikLpcH1dVRZ1uiqcoK6qZnU/bkwX5xrni57FWGBh5MZY+qONz5XOMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6687

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
