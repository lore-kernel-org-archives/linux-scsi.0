Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A012C695;
	Tue,  9 Apr 2024 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.143.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675784; cv=fail; b=Gh3l8yIILSdE55g4/q726l+AyePKuVsoxfgh2Sj2Q1XVh4VtSoG6DsZDlUwpbnJIfbmlxIm/bGZqPleE4e0bo+vwfeUDGyp+dgcVwkJ6buTn+fdeGhYaQATurf/h3OuGfMJDMiztiU7W5oCw76+ggjNdh8LjgWykF5Wb45TjXug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675784; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SOb5fyht1//9iTJsi4bTkgVvYOHx17yuLLgmoQN+AhVEiAPi9qYffUMvvtZXTZ5n1ldcMMtMiAnRi+kEsjURVoQRb6eCg4u5Y4iekZsnqW7xx9xOhjQeNo1lfWYY7DUTNMlz/LTfnQ1GuGs5CiA9/V3WXQqubb1+8HWD5sWwBao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VAPMKRdR; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=U+XYhIds; arc=fail smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VAPMKRdR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="U+XYhIds"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675782; x=1744211782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=VAPMKRdRrA1l4MXKvYFysXGL+lETTaKepWEkaGZNZxUa3P1i7p3DUb7d
   gGRKhho8UZWCi2oZEZAuFSPfnCf4fvAzTwV/DL4I+vJbVWHT4CD1xjHno
   gyrXUNTHS8hslssFbVAamE8EIoDgzW9VNjxe60HfvSsgtNGhFpdQ+hq/G
   zl8ThD/hjCauI+CMWl6l1avmxmHY6hbdqFZkfpHSfyCGq5cKyC0kdPJLD
   htSnxcwY1N8QaZ5Pnx1RDZ+Dz0bsnitIbo/KhOCYMYTyEPIDWyqqscL2H
   DJXJfSx2V3MKGd47RR/or8uKB3TfIfOwX2OA5kFj+hkK5ZlAewtx9izib
   g==;
X-CSE-ConnectionGUID: wu/AmVbqRdC6BYVLTZqpZw==
X-CSE-MsgGUID: FnspKhO2REaiVqkC3bsBSA==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13601659"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:16:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGWc28lcYtyErDg+OUtCzggeV7r6LmEmD4bdchwA+Pf+AraYN1mc31zLs+HqG6N4vgZNu2+vTXSQmgwnHBDi9+BnjmcA5dc4/1UKEzdTQZxNQWv77lWfK6p6ooIQ7U1e2LUokJzTdSxvTjPxWhxoAsMWPBMKk4xLYdUEVs1z6xIdI25sG11YLMI4NpjUBqvkuj6GFT9MqLg3KPvuJqaqBmYQbZkbzusfTQ2Rfr+Ix+6C8+PNYgAZTo4FmrhZNLMbMf+UEWE5tlanekVOKIovnD00s5Hh7DrN3kjoYbc+WKQ+JVGeJiRl4SbtSwDkVwnfOCjWOZGnnFwdbjhHnrfjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=BsvlzrYjwkW3bccHKupvZvUpkp4e0tKkOLL7sv7hOZQUf/7gy1ZD8TQ2jcjdIySij5lz9nGEoNcvnOSlIaQP9gwdAHQTLtU5HQFhJ/wL8qUWhxzV4g1nsArRJcZxf6lW2SPS8baoBBUh4TQAh3HeGiKZ9vENlGyg6utJ6XnZoGyVfYA8mkforuIJzHLKJctEcXIhAQivqsz5/6OvygmIiLpQd+alOIbYX5YfJlX7nERIRkQbN3Y09JfwX8zeGnmn8CbLx4jO11T19voqQC26T0RyHgMld0C0/B356Pen3JrpjxNp/t1eNV+4dRfDFU2Xyp1P0oSSeVjXUtwIOiI0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=U+XYhIdsQ3z/3CmYvZO0vMLeciQOrFcwUNpl4j/r88P5F0efNnQB086FrfN+rkvcsRmU2iPQJCcPzoTU7afcBi2+Bvyp21uaKZeiypP0CnvFHWH68hvg+mq+dgluqgWxPu3N5n/jeCJ7fPh/NRq2Rc2G5mSUrWMaDXa5NgI6pgg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BY5PR04MB6375.namprd04.prod.outlook.com (2603:10b6:a03:1e6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 15:16:10 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:16:10 +0000
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
Subject: Re: [PATCH 11/23] megaraid_sas: switch to using ->device_configure
Thread-Topic: [PATCH 11/23] megaraid_sas: switch to using ->device_configure
Thread-Index: AQHaiovZL/iD4SNeW06jEmzpoAlOg7FgDJuA
Date: Tue, 9 Apr 2024 15:16:10 +0000
Message-ID: <c8cc86f5-062a-4a5b-9983-66f01d1dbd09@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-12-hch@lst.de>
In-Reply-To: <20240409143748.980206-12-hch@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BY5PR04MB6375:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 tJAXLUeJ8cMau3YPkF4VCS8DDnQL9bQgyBGdy95Jkx/0vKz4Aizxl1XoCEKsnpu6XpU37HN+Etxpy2LnR5GHrcQ1uSLDtxUKYYFbgnFvpPp4twSdKCMBa6NwUrwN54Ha/AFQEM3lWEuPkCWD2ckaB39qkXO+hQSRckrxghgUi2TFqBuvJjLb4sCjFbXQsPh2pFqIklDWV7lTJCCLfsqs+y1r/2KCWFS4I3sP3Ljw6M+XvAxwAOiJW24z9to3kcHf1IOkeubUq6mBatTb54zKgzlgGsbOOq+T3sqaoTv0luey8i3Wr2vXhBzuhD4T8adGpgHs5xe5SPxS9RK5OLNvZKLPJcsK7IYehcCfG8DNDZ2rXZkMnPiOmA3CYTq6rifHbaRZWJCYbxZMscUykJemtEmUd3aBcKY0l8/D4vV9YgBLKV+rAhvlRwfVRlUlVwhZwg28tAqp8XewVGnsGYdfBm3UFLb1QdoM+asWy3MSyFAEG3TBeR3ttoCNDbPM1Lo71nbHzo86fR3eVwW2I6F3K5pyACxONRY4i5h9Vn0zS4/fy+QFBxTa9/gT9x4MUVaycDIMl/FzyWEHIhPREYJIGu/E3nOMKVlBlPJI+o0I5RGOjXoORKzUNUOddoUQIZRQuQ8uZYqbB5Up7ARVcrdSylANQd0y5CKVkFOztmJ/wls=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0ljWmhLZ1dEN3dubGRkMW1MNGFvT2xycnZ2aWFheUJ2dU1qMGRHbHNQb0dn?=
 =?utf-8?B?WWQ5akxBNTJHdHBac0Qza2c1ajk3dkxHTEp3ZkpnbThuTGF0dUlpWjVOZFRN?=
 =?utf-8?B?bU1CcmhuMDhDM25KcS8xNHFSTkNNYU1OdkF2L04yNVFoL0VKRStSeDE0OUla?=
 =?utf-8?B?alV4YWh1Y3BnR0NMdDU1ZkJMak9waHBLa2lydHBRY1IwRDltOVIvbk5GaDgw?=
 =?utf-8?B?M0N4V3RGRktodUV6RUY1ajRSWGlOVUtVREpYc3FQZ3UxNjg1ank3RVkwMW9C?=
 =?utf-8?B?d3VNckZLT2s4MkgvUGVXL0V5Sng5MmE1dFhCVlRoRkNPZW5pTnpmTzJ6YjhJ?=
 =?utf-8?B?NEtQakh1eDdaL0pzYzhhdllFcDV0QW0rdU9NaGFrMndrN1YyUWRXZGtPMGg4?=
 =?utf-8?B?REg1OGtLWTF1N0dhNUlaMGp0emVva1RpRzllRVE5ZEFIVkovMElHNVB1R1E1?=
 =?utf-8?B?UndNTDJZWE50anM0NmI4em1xdEhLcjRLVUpZc0RLYVlGbTRUR1IzanhmSk5J?=
 =?utf-8?B?TjNHbWtFZ2wvMjljR2ZZdUplUVYyUUFiU01yQlFlWUZoVWtDL0lybTlqUGhn?=
 =?utf-8?B?QUFYWlFjT3RLak1LaUhiaTZKNzBhTE1lZks2S0kwT256VmhOQm1FaGxnNTBq?=
 =?utf-8?B?OE5VZUt2Z2pPNTJxcnFPdkJ1aTFhdFNGVitFMmpoWVFzQnNGdjIwMWc5UWRB?=
 =?utf-8?B?cXZiMFBuTURhMWNIN1pmcnJja0owemdqM005aHRVL0NUYUVLWU9aUlpjVVlV?=
 =?utf-8?B?emk4YVFzL24rbWVsVFRuYWE5MGVZdFNjSUM1K3pqcGF2ZDZqWjI5MjdEK2cy?=
 =?utf-8?B?TWFEYmowVTFCZGlvc1N4UjY3SnNSaVVZZC9HRXRmc254S2pzaXZkLzRTVnEy?=
 =?utf-8?B?NWxaeloySFVwN3lINFRFbmhFd3lhdnZ1L2dqOEhlM1lramtGRVg5TiswV1Nu?=
 =?utf-8?B?bUlEUndBaklpUGw0Q2p6SFZFbzdSNUhLaExocitxVHNQNS9nYjZ3c0xyVDBV?=
 =?utf-8?B?VU1uUkYrak5CTUpTdEdVUmZOdVBaV0dObEkwMVFwRmwxdWo5OU9tOHpvbzJZ?=
 =?utf-8?B?bnpUL3hobWhmTjJWUUdqeVZkZWdFZmpZRDA3YVd1WU5rRCs2dkFoS3dMMWl4?=
 =?utf-8?B?RDYrYVJvc0JaQ2pXLzZIUFdqVk56ZXh5NGtkbFY2VUdSWDZVSTQrbXNjak5N?=
 =?utf-8?B?Yi90b24vNDlKRWFNQkk3TXBUTmhjSWQyMkxWazNpczcxK3pmVTBoZGZSclNk?=
 =?utf-8?B?SmNUVWdsZmNCeExpQWpZeDBnM0M3Rkg2TFJsU3diZzBITjZyMThwT1dZdGtO?=
 =?utf-8?B?V0pZRmhMdEJpbFk4czVDVVpOcDVaVlJwSnhyMkdWblQ1c3kxMUo1VnBQNXZI?=
 =?utf-8?B?ek1ueVdWbUtuY0JEUWV6TVF3S0lxLzh4QjZnYUpNV1REYytCK1MvNDNjdVNq?=
 =?utf-8?B?TDN4SVpMTDd3ak4vWmpRMzdEbDBMR1VsZ1RzVCtSMENOSkRNYzRIbUlHaHps?=
 =?utf-8?B?NDRDcmtwR2tMbFFtWnJMdXBBWDk0R3pOK1B2WVBTaksvUVJEa1ZQck9CbHNv?=
 =?utf-8?B?WCtnTlRaVG9JL2FFL3BRVTBmdElxaU0zc3hsUE9CZkZNVVJib3AyaUdYbWZR?=
 =?utf-8?B?UEJ0d1RXeTEzei9uNFpqL1FqN3RacDZEd011Qzd3YzI4SUxuZUFxblRoN3Zx?=
 =?utf-8?B?WkVTK3ZYZm9oM3M5ZVZKU3M1aG1FV3ZNc0VIQmtTaGxzMEZDWTlBQm9MS2tE?=
 =?utf-8?B?SURqRDc3WEh3TWlETWgweTdaYkpzYnFJakprYitZTmpXT2tYbEFhbk5JRmpi?=
 =?utf-8?B?cDZSdWpBWWNpbmhHYk5FZ3QxRi9ra3hUc1NhZE4yaFI2WkpVRkxob3JWZ2x2?=
 =?utf-8?B?bXlQTXhRZG4rTW44d0RVRlh2a3dqWTErUkpDemlWcXlNdjM0cHUralVqeHZw?=
 =?utf-8?B?MWFYaHRadmpIVzN5Y3ViMHdqd3A3TmhyR090MzhzVW9CTEN6MVFmRlRGS3J1?=
 =?utf-8?B?ZGtpMk14dEo2YTl4bUc5WUxIeTArUG5nZ3N5T3JDZE8yd2ZKZ0NZREtlZW9K?=
 =?utf-8?B?anFadFo1YXEvS0hIV2trWEtHdGVCejJPcGxVYkIrbjlPMHNXWm9lWG9saTM1?=
 =?utf-8?B?Tm5SRCtDOEpnb2xNWXd4djhKY2NDT1pXU3hQNmZxajMzSWJqRWwrZGsxZS9U?=
 =?utf-8?B?dGQrMXEyaGpoc0FvR0xRdFROT3NSS2ZXNUNuQVBDN1dIalJranI2S0UyRVZr?=
 =?utf-8?B?Mk02aW02Wmdvam5BRG1IOXl6d3hBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5066833A619EDC49B275267E54070427@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dvnTDGcegYfIOuN4V0ZxLSoGk3hioZ3Z3nCueyZVBM25x/NnwRV+W51HVYg9hpdDxQJ87ukkViIKWDgHdTuHHlhzBSRTJHplnnEJ6sk2EdqEAupXDW/Xk6WSUkF5qkg3YMYwyp/9+XOCc6mZZHCfK2RTvcL5zvEVCdmcMjXu0b1DwysAu7S9Nbasrk26+pyv6IFC7ptGcz8fQDqCyRJmCh8Uwq1mFJusNZBFi1SzvyRxsUQQV/ybZLklWy9p6NC2GxzslZc9+du9w8vCXORNUOUNWf6SOCewHeNUV40jfNTjoNnqH3nXcV8tCgrmhv1TYwF8SXhR8I1C/8HbTAV/GfL5qEZ2E/91uRcYQmXBsN0e0gFGlXoGx6n975cTPRjosxLiYMhtFdrKNOV83gLNog6Mwr1b6rvyqfyuKAOAO3SraO+MSdEsrMsFbq7Db+MsrKbnKmwr8ktgRGjCVVnVeEPtoT66s+49U7xZ0zBmhVtQL4QBLeqEDk+96s5LGW6KFQiVVKaXYB9W/z9YCs8L9DQvaMox1zBVOdAtcemsJFCjhBZ3N0s6kKtVaa4aSaoVrl53+i3fLtFOH2cyGYLHUIfxX9zk3PHqnPsZTgd/0yDaJ5ydkgm/y9nigxM8EAWz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e36f40-4e48-46ad-eb85-08dc58a7fcac
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:16:10.1573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQIF7QcIDrOD1c0BMXwF6+1aZDK0/BEi1ZD2w8q/jbMDLcFO/rGkNN5BABqRyCpRHIfk+r4Y+8peOBzxD4uEmNEahHj1FGuZ/q+IFPyBCLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6375

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
