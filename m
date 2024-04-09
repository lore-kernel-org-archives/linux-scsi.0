Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FED130A60;
	Tue,  9 Apr 2024 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675502; cv=fail; b=RS53AK+bAS5gT6Zj2BJyUleHUEQVidXmb6XZmJEKFnCkRs+LEjC/VX3S2nEZgapmtFZ4eSrmfNxDpbjXwPVIQPClSKlx5jyDwlGmmc8wjxZRXML6EoQI2vRIdOOzjZy+gKnte4eQJ82CTPCCryMxROkr4W/n3n/NvhVD0IsDgNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675502; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UnST9aM3REjBvWgUA5uoKqIeCjm7ssQZq/n29SPAYvqRk/ENOpJDMjwIkHCyU/Z1HdyHlUSCAuXfTuHbHc3q+Gvm4KLURLiiFOp8Sopu7wnbTw3HbGOYnx/b66elMnTTk1cJ/egC5RpagARgDkKjQW3n9aDh/4wubNaMOl2daDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cVO28qjG; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=R5Jz/JXk; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cVO28qjG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="R5Jz/JXk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675500; x=1744211500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=cVO28qjGjidFIbYBYidDBAuTLKmR81yui8Jy0g6mIvloxuhwue7zfQb5
   sBaMoHJijbIFp76JjtKryQTRZvK7cpOflJ01orF2YIwFjdMsL8VTu02my
   DaFpsfRtbRxcgGGvc7E0iPxIL/ahV52326bS/mS/mhLzgyX8yjkjUSUuV
   vnJbGZis5e35jeth8qaempGp337p63LKyDOrn6kO9yLFCd4AjCtN0ZhqU
   uX+z5wjyVPQjZNhaOFmY04/PNCQI8a2sgYolHOd+lrwSplQEYEQN/JZ0s
   zhIQz7oOj/z+HpZj6yjGMzkXr1bVQicNQC/hcEFSmUNV65gyG8rar2YBV
   Q==;
X-CSE-ConnectionGUID: bwj/zQuUQZC3xrvHyQHd3g==
X-CSE-MsgGUID: 3PNjmfFgQ/6fBCiDnSrddA==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13848179"
Received: from mail-bn8nam04lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:11:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHGyXu9hK6Pww8QA8IyIy/u4pHet9Im9lr9ybSdOL88W0npsyMRQEOO6BEtYyIErAa5DQxTkTR6U7K2ymBC+9Pr3TOzLZWWwrq0iuwF6m/8Wdnb8ruHWbZbwZqyu717suSDqo9bxs79iUtgqL5Dd0xnhRCgjVB4P0wLdAQ0+L7/1eyR8DfB5wUMxcPmRv1UWBPcIe0J62+s47T4cfSsBgDY11IlWss2mG/K40u6t1+px+9cicXCwFJRfQPI5+Yq80OvmbuLutcQDPASGulA0UNQiI6Ip3o0UbtTV7XjAvqNukLeZxTsIdOd/GyVwUrBo7EvZSWaMSQO2RHOAmGueLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=AwySnBWITh9pBsfFveHRRL67EGfpMrCdacahGLIdfGafamJe2bASJ8JTz/9qsWNY13UXBrBT/rqBBu2Z4un90U1rb7CnwFsdUaTrv/fui/eWkXoZnfzk1+whJDHPHpdAzCtgcusJHKmptZwnh8g/bAatfBDl+FnB7+0q6yMfW1U/ARlqPUNMoHt7oIyolNQssLDWHoyP1zpRsd3TQ9sjufiNmXSpNURms99Mugm+6KhPapcDJfW9+MvvAh35I70cQQVxXinFFpQ4v7iRjrKzRkidgs8GPMESX6x0L+GmL4rUu6QtQwEswGh7PhwRIWsa/xKWp/wUpGWq99AH7whNjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=R5Jz/JXkBjtX+C9B4gOtcJ+G9dAIXa+OvAEEBLeG82bFL35cKa2oBpYsqK3THOPL69Gef8fPJqV/gyxMQFBcQMICzIXHg9WbkVuKrbUbCiJjkOMtKGJ/Xd1E3gKPpEzDgJO/DJEYz6lQF09ffH2kKi/+dP0cOEv0IY1GjArBiTo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6760.namprd04.prod.outlook.com (2603:10b6:610:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 15:11:32 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:11:32 +0000
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
Subject: Re: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
 the init method
Thread-Topic: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
 the init method
Thread-Index: AQHaiovL1oGx34zpC0ubfwdDr3o0YLFgC1EA
Date: Tue, 9 Apr 2024 15:11:32 +0000
Message-ID: <d801d477-72f3-4342-a391-18e28fdac32a@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-9-hch@lst.de>
In-Reply-To: <20240409143748.980206-9-hch@lst.de>
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
 1Z55vAMuxtlgYKHrYEKVwdGL0bJ9yV6qD2DzlvQJWb0m2UvvkWyiDJPQxe+ElM77EG4bXLLOKiz3wRYMAiFmpmkWiG7bXJ4U94oSGIog5Y1u1pgVUmoizsRsRoge4rv6/XGOdRRr+4P3jZQfiJRbujMMqXelt3Y9m2Zi0ItcovcGBwo4LMW/MUWDLPZKBSTWoSdHla+UuNq+8BGvDmLJTYIdeXmWq/V6qy25Yk3uDhNACmT+IgFIM0Ar727YN/gBouBsFEV2xt8dSjMncbtV8ekxzB1Eh5HRb+6kElKewN3MvmN71gUb6AgR8YcfAc2IDW09z3Yg7uGZ9WNClfjbKqP9gDf3sogDBXlMOfLJ4Y/OgEwQs4TBysl4NxRrqlHlVXfAo5xRxsB++8F773FsvqY9rRuxnmAJt4DTg7vDOhWQ3XQ8Zb+ZIA2/5J9N2WpEWfudQZxo1u+6HPh62RJPYGuM15vAMW5V41LuU80NWp4n08lZwHAJqUztKNnqDsPrPU8vpJvei/vSbxf0kMdFMvMaXfp1YMxMFXKaM0ADgFFCQs8qXMoSufhG7+5q1B/y86vnM10WoOB6Z8z1i+sVMnrItn8NkYNCBIpVlJnuhEYldSM/fYnBqs0ymzDv/4Nz2uz/kh2vVVRyWJ4bD+SKZ/VRGQqw6i/iJ7KeKw4f754=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TCtaTTNpbnlwM0NYVmpmczR6Vk9xQnF4aVBWcDRaY0w1Z3BTcmtmRDJWVmdj?=
 =?utf-8?B?OW1teExuR3ZVZmg4Y09pL3MrTSt6eEhFUGZETU9Za0FMUkF3dms3REUwNjRx?=
 =?utf-8?B?SU5IREdEZkIrWmZqUEhuK3B6cEF1aThNZU5sQ1VBelFCL0hUNTEvNThXeTBQ?=
 =?utf-8?B?TUJxTXJaUFVVZWVLN0ZBc0MzTHJ5a2wwdWRHU096dVdCWDd6TWZkYTZzL1Nk?=
 =?utf-8?B?S1VLbzE4SUkvWWpiRXd4UGQ5cFpiazJGcCtGdVVpV0VEckVtaWFsQS92UW1p?=
 =?utf-8?B?bUJsQ3p5VXlOOTRxN3J0dDJxS1kwL1FqcXordkJadWxBTExPV2pUUUhpTWsz?=
 =?utf-8?B?SEsrMHBxd0g5ak9LdUx5WkpGQVptOFJVNGRnR3lJVlYvV1RHSDNzZE1NY1BN?=
 =?utf-8?B?SU5seVgzWlJzayszbHJoWnJBV0QzcXhnVW1PaWpUYW12QVgyUXJ0cUR5QURL?=
 =?utf-8?B?ZzhnbmgzakVzT1NBU0MzRHdHQnNRSktMUG11YlQ3WWRXZlN4eFVzSzF6K0ZB?=
 =?utf-8?B?UHhkUmdMdGVyN3d1NklzLzl6WEJJUEoxZjBYL2dobmFUbVY2bnNpUVRpMmFy?=
 =?utf-8?B?bWJsTzBsQytGYm5NY3cyRTFKTStkdmFraHR1eGpVU0ZBOHg5SXBzYmxFcHcx?=
 =?utf-8?B?Q3ZZcVl1b1M2ZTMvUXJqSTlUYzNnQkp5QldpSm5Bbmp0NkFKUVdGOWhodGlQ?=
 =?utf-8?B?eEFRMThRK3NiUERjNFV5MUhveDNyaFNsRWJ4U3ljQ3pLQUI1SVhxMzJLRjZw?=
 =?utf-8?B?Q0xndDJHdmx4Nkl3cHV6WHpyVlZPb3JEVmtkZUR3YSs2RSsrMTNsbjV6NGF0?=
 =?utf-8?B?OElhV1VkNFRrckxLeDdVeWhxYkNadWpvN3dOVVhnQWhKR3VTNEx1NFA1eDdB?=
 =?utf-8?B?RE5PODdiSDBtR0ZmNEpIRUhDTGxldVo2d3JiUEI2Wis0ZlcwSlhWelB3NzZi?=
 =?utf-8?B?NFJjc2s4N1pMbjJReVU0WWNTZ1NQV3YvT0JNM200NjRoR3huTWp4TDczVEo2?=
 =?utf-8?B?aUlnZ2RtSWJSTjExdUI2QUlUcWVIRGovemtMTUI1WjZGUW0vdDRPYUZPRk50?=
 =?utf-8?B?SnNLSjV3UUVuN05pVEtFMld3eUpZclRaZzJzTlBsNll5WjF6K3FlY3QvYTFk?=
 =?utf-8?B?ZlZkNlg0VzFZVmN3bjAxRW9TS1dKOXJjUU1US3V0L2JVeWJzRDRYdFNxWU1W?=
 =?utf-8?B?SkNreEVCcmdIKzdNV2RFWUxZa0NPQUdPZm1rTURlU080a0tmMDN3K0FlQ2dl?=
 =?utf-8?B?L0ZtYXkzWXFkbjNxWklHUFZJYkw5ZDIyR3l5K3F0RHVEY0trUm4ybjFKQ2RY?=
 =?utf-8?B?cFErNTljZWhEUVc5QVR6aTNnMlJZWEwzNE80bVpYeUpWbndKWk1EQmcrb2FM?=
 =?utf-8?B?aWNhdjJmeXZoOEljcm8yVUVCRHhGL3VKY0dYRjRraTdlbzlXNlhUaGJScUov?=
 =?utf-8?B?a2ZlbFM1c1dLWmQzcENoQnlOU2ZQTTB4aklYT0xnWmttMllqZFVrUlozNElt?=
 =?utf-8?B?dU5YeHMyd1ovbjQ0MEVTekZuZmZhTGtBSkJYUzdQc1lPSENlbFBkNjkwVEV4?=
 =?utf-8?B?ZzB5QkJ4eHFNODc0R0pSazlHdnZobjZPY0pORTBMN3FxRHdLZVdnclEwL3RX?=
 =?utf-8?B?V0dsVTlldEdzV29GM0IyZi9FWi9jQjFubXZBQkpyYUZUYVQraWpsZTJBNE82?=
 =?utf-8?B?R2FwbXZiR05jSTQ0VGx2a3IvY2pzeFcva2VOYWE4Y29VNHY4YmR0a0lWaE9m?=
 =?utf-8?B?bTQxc3dpS0V6UWVCZUFORWtxZWJKWUJLTENYWXJJOEI5R0E0TElyT3JlV2w2?=
 =?utf-8?B?dU1zNm85RXU4R3Y4cVJSY0Z2cWdtTVNSSGRPYXhMaDluK1FzN1hIMHlWWU0r?=
 =?utf-8?B?UXFYVmFDb0EzMnBqSWI5MWtiTHdnVFZlcTEydDVjZWZ4RmNSZm1GcS9RYTdQ?=
 =?utf-8?B?b1VQbFJyVG5tdzRaUnN6bHE2dmpHd3YxYnUvVDRXUFBtUXJndkhCMW90NU9j?=
 =?utf-8?B?dlRQelJNRFFkajlmcmdyUFZXNUNGbmN5VEw0UVZCYVFkdVNoYXpiVzVsbFd4?=
 =?utf-8?B?L0JIVHZjTzNSdnB0dzRUbjdvdktvS3NHT2JnK0Vqc1lhOHJoT0xBRS82aVd4?=
 =?utf-8?B?RGx3NnlCcVlxWVE2d0JObDAxKzI3R2Z4TVdVdjJsZXJEUmJOQllUall4UGta?=
 =?utf-8?B?SGdlaGh3UkNiNE5DYmpYYVM0UUl2a0pZMjFOdnM0SGxkbUFOVklhdFJWenNC?=
 =?utf-8?B?Q1UwQ1pQL2N6aHRqamVsRUV5L0FRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1236610A34618D49A1288BB05C2E8F7B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tFLouMdM2IHG2vAkE3zbCPdudy5LVhs0G+JPkHHFU+wuGC3/YyUfXymAuYjvmFFs81xI4JdgPuYgKZi1iQdUe3EY+tUZ5+lckMPNe+PmWHE6/CRRlGUPE/z7RDSZ0TpriQDGCjZp2uGyYaPPN5fKewcJRxqSTYaikFWzaWyzPOJC+pSZHINpTJ+Y51VcnOguD4NmsAskpOun45TO3gd/BKTcnEtoECMv9ntRpA/tRRib9HaejqsVLSFVn9KpYYOFlWmaEdUO1mvuo7A0oPLtOqt6loJy46kGXAycn5Nphx0ti43rmWlsUmTqUX72BrRonoslXODrUNVSRo+qy6P4WAODJ8SD9jAPoVd4RSfIx84SxAwv9DkuYgxWI/Fw9vlVz1dRoUiliVACoVq1SP+U+FGYz5KgWQ/co62s4jAh4y5WvBM3JiNP7vyia2tHDR7c1fLxA0dImII+8oNyEe73S2r69SbP/f5RhMRNNNITLa/9HXaCXccQZJjZ8na+87aTDcaE59fwzzRb97Pfco1xCsy1uuuCKvs/NBI8fjm4QSyGd3HZDPNPgEEeQU+OSZz58qHtoGCxo/f5Qtr4AonDffvG/AeNGrmYNTtTsdMFgR7u+HOHPaOu0sRYWXoA3gLi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ededfda9-6eb6-463f-182c-08dc58a75734
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:11:32.5498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nmuh63YGxzdO2VwHAIA0GIZqgTkz6BTqyVqPEUHqsv/SwQfLGWZUPnAcd76Vy8Bob5GIEAfEIohsRpaRoxUIt7h/zsx1zESYmLhZS6xjQgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6760

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
