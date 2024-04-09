Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BB4130A4A;
	Tue,  9 Apr 2024 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675413; cv=fail; b=aaYuAEbKftAwuy8g9BMCNE4enuXbLrPEYEosLTnhe+hAaoWZ11zZPZFoQkFVdkeT+lO4ZcXt9csYO26rIz9eii1OuupQYmlUY0u00T/OOKPH0cgOKeUTxleSWLz/l69eIrFzsevDSrP2tLuQRm3jW/azvgh62d/Lo6moTpi8af0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675413; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WGrRJlZtGwbDMSstHS2f2ZS2RVsa8Rl21if6l/okmdUrUtGbl3/IUMslJguQdD2mP57/8ivSedASu0Z3xzNxR93Mu54FzyAITc8b2X+pBunBMoytO4vI+jd7Bb3D907NelmKbWGWo1sdg+7afVjokKCa52f5lPQ90RgrVORvTO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=nZM8rpZZ; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=LwoILs11; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nZM8rpZZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LwoILs11"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675412; x=1744211412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=nZM8rpZZ0sEbSRCqGzjG9fb3SKIvZPZomInf8vt+6x2F3d4tOkNgG2sj
   mXEiqZdlikTbgAys7NgnfKrigixhTqXI/T/lq3bRqEKGv5dvVxOFyQLGJ
   kQFt7dbGwP+PqrrWh2JsDnODEXktOwK/Yov4MQZNo0QM5QtsWPm44lUEo
   6+nQAr7nuH/GTzFDJO0FKw7mILydQXZPNqxO5nWjcP7wVWkDpCwO6Izmf
   c4Idyj8155+UZPdPH64s7L2WjmHMxfdY2gXAd7eRGm12jt0KEeynn8bG7
   l2tGF2Po+iWdmZYZ6TvzxreZA+9c1gooQUyDXTBgtKWKDR27q4CuD7ScS
   Q==;
X-CSE-ConnectionGUID: 87gtMWmPRwii6dBvmhFLeg==
X-CSE-MsgGUID: Q2b7m57YSvab4lb/zsLyCg==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13847894"
Received: from mail-bn8nam04lp2041.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:10:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anzAVAul+tH8lipuJalt5tyXLugU0FOp6wkz3EDxRJlo77Qh3wAeseNWVg7XUXcdoTX5Di4SYyLzlm84mb4kgcz0sE0ieFje9AdzXPznEPsaPbvjA2zYuFAniiDEvMbn903gh7A6Lq+pXRHV5Co9APN0FGRSTz9eA4lbK4LdV7eGqll+F8kruEQqxNvKGwI/PIwe/aQQeZ2U8pdoEECbDVPOlbpx4JDI6aFZF9ZIz1ajkH3FppHYZJB29Mrk9miOBam94c+CMKCfoCs6kkmPirOULwtASPAZoiZBMW3LO1503IiXG1SWSS9esdAzNVkIoiDFWG0t6m1k6IS0TbYP0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=Hy3EWnGwRaKzD6sHZDyaei/FkifHIg1zwwQ2xeMM469hDutbYJ8VDWXvkZ7IdbPyCnMT9oTqv0YSBQUrb4ix8PnGufVGX959Y1oYe5E6dnUbGK4Dmv6AeOB7TsYcGaEJAWZI/I6bXPzoeubQuyYSX418CpUuD0m4LiQndLvvf4molIGampsrQC4SP10MA2iv86vwb0kXOrC61JYQwZA/Gmo3JzKWhKcMPOGCYUkValxQDK+FQoljZaTlJi4Z4g2oqnHTUq49/vxrYn5G0s864UCMaOr8neiqT08xvlhMWdZQSvL/WF6Gr1SJut+jtWTcUn5Vq3LG20FKpLqQJlSdVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=LwoILs11FPHRfEfIL/n3XITUqxlX3AnODL6mYk3QGlQSaZxzLbAtFvBF8mh2dUmq7ZuymBINOMMiEUmd40RpWPiycWszaqnXebHbtB34gimB2OJ5sTFWymwy7I+u0lt1tdEqU5fbAgXNH+hHIPLn9qksKEqegKf6UlwPEAtBxLw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6760.namprd04.prod.outlook.com (2603:10b6:610:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Tue, 9 Apr
 2024 15:10:02 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:10:02 +0000
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
Subject: Re: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
Thread-Topic: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
Thread-Index: AQHaiou9hixgiqnxDUWiKCglhteZTLFgCuYA
Date: Tue, 9 Apr 2024 15:10:02 +0000
Message-ID: <cef8b379-bbd6-4e9b-b83e-625b20bb0b83@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-7-hch@lst.de>
In-Reply-To: <20240409143748.980206-7-hch@lst.de>
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
 fsWNNjNZYna+9QvUJaKqpV3yMgzSATZSwfhwG4q+5AqvS3Ol/OlzfaGd/+M8oUsYJEYpb6PKU9OKQUg/F2kN5Qc74HZacfcuBCtoc7aUtyfTV0ZQtxuUYkOwTmQB08HFl6e26GAHrZl9qftWXhzCQQ8zu6JtGw1q1LB5ve63AtM+6Vy9DXzBTtLYkonrfTwet5hj1DAlRnCZGMWh6bywUvtQggP6J52DRwZ1EbzYUo1pxeqqKoAJ4bglHE1D5gqKNpf/AH1rg9DnUMzWTchGLXjCGoZoY9NqWvMCcxTKe565mKtHpqVQ/2Zm624+roSUm01YaU6e2WSw5+gMZv/hxJvpL7cYe85wYGTVLFDk2Hu8BNepAkZVyq32DLVZgPgr6scyrBAD5KHjZx3mhhj9HP72FE3EfdDg0DOoWREM3LzCxBI/yBTqZYUcsWXPBc6HO7vYElbtllyNvNuK5NPMAwTeVLgAjHdS9vwdtBlnfsKhE8aFSFRRUpGvtoIMjBZcwMi/RMzhjG3shTrlU7H1+hUrAANVElCHpcR524FLoQU9CK09uwnmNzUSt9bw+6YzHqNSw/uyY8Wu3Y1y28+QCcVf+8hnbkLGwq7rjmzkh/nqEISZvsLyopaTo8sCLlWJilMgtdX244+2TIaE1rm0cPPCm+z7CZLgEwk2PtM9YF0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UGRFN3RnY3cvT3VlTHpKMnFDUjB3NVJacmI3ZHZFcG9ld1NrWWpkOFREY2VG?=
 =?utf-8?B?NXMrcitSanFqQ1hLTGVKcFhsd3hIOVhreUVaMURJQmF4eUtPcjc4Qjl4L0gv?=
 =?utf-8?B?cHpVZnlFZlk4ZU05WUFVK0ZpSytrTzBBWFBxbmo4QmRQVDd4VGhyRDk0NG9z?=
 =?utf-8?B?eHVYMy8wUG1zTnVRVmlGRzc5Z1E4SStIdEJaa1FYbERWRUtxcndjSXRWQ3lm?=
 =?utf-8?B?NlJzeS9Sd00zSFBYbkd5UTJXMXN3ZEIreHJwdVM3Q2RqeWtnWWxmSkhkWmlx?=
 =?utf-8?B?ZVJaVFRWUGlwRjVvTEp2OGV5RHNtSHBDakVJTHdaT0ZBam1OZDhPWTV4UkI3?=
 =?utf-8?B?ZFF4TXFnckRTUnNEcDdvdFdnR0lzZnJmNlNobVo5bEFxdGdpR21TY1BvcHRa?=
 =?utf-8?B?SEVINnhieEVBZTVSQWE2U05yZis1YU96MUtHb0piNzVscXBPeWtYd2VpT01Z?=
 =?utf-8?B?QU5yVC9HbkU0VmhobWluUHUzWDRWSVBBSzNaZ0ZXZms3eHhSOTYzQWJzY1dx?=
 =?utf-8?B?VVVBSEdUUUlvOStyL1ZnRENXZnZ4MEVJQm1VNThnS01ZNTNZRE9GM3FMNDA4?=
 =?utf-8?B?d2YvOWxTTXJTZnlHaHoyelRCRm5HNTZNRE16cHVEOGRFYnQ2dlplUFd2ZzFF?=
 =?utf-8?B?K0VBdDBVQVRYWVU4UE5Ta2FaR1d0Tkx6S0pNVWlCYVA1bGZoQWlzWHN0c1ZG?=
 =?utf-8?B?a3dXY2tLTWtsU3pOaG9wMnVaVk9FZkJTeDJ5OWZ4VG5ZN3cvbVNrS3BvOWxh?=
 =?utf-8?B?aGtLSDJJcWt4STFIVDZpN2xyWktjTFRNRmVONi9KaUF4YnRIeHd6bXd4b2R3?=
 =?utf-8?B?dFpaZ3BnS3l5QXEyYmdUT1JlZXo5TVhwOTdISFlOSE52UkFWeEJWNkFjUkF1?=
 =?utf-8?B?emRnUE1udWtmVTVPOEZSNHBjZ0VYTWlvRzRqcnhZckVSWi9abGkvK2tTSjBN?=
 =?utf-8?B?bkpQK01ieTdjV2pHMFVQb002aTY1WU14eVE4a2k1VXF4RFBuYWtscHNMSWZY?=
 =?utf-8?B?aUlRWUVnamR3a1RodkFKa0k5Z1NKa0FZdGVhSE5OQlFBTTgwMHRCcGpRbTNC?=
 =?utf-8?B?Q1ZvdFA5RWNGWTMrdTAvOEgwTjYreXJYVzg1MjlhODFRYUJyL3k0RWg2QlFL?=
 =?utf-8?B?dC9qZnRad1JSZlQ0YXQyODY2aithMll2RXl2WDMxZDNRL3NCd0lnL0R6c3JG?=
 =?utf-8?B?cjNMUWNxaTRITmVkT3BHYWVhb1NrK2hXVDduRi9BVk5Dc1JVTmI5WW51U2JO?=
 =?utf-8?B?UGlvU0l3QXd5T3QvZXNYRFZKTXEvazNGYmFuY1d2YVlvNGNHb1VRMi9scnZM?=
 =?utf-8?B?UGp3N29LVzMrQy9HN3BEclNsaERRblhWd2dTZDFlaTM0MlhRV1Y1UHFhZkVK?=
 =?utf-8?B?VUxXV0U4aEc2UDU1NVE2c0FFUExxZFpHZWNhd292eXBvM0ZLWFQ1Y20wdmt6?=
 =?utf-8?B?V0NLRzY0VnRNaGdVYmlSQkNkRGFkUlVpcEt6cGtONXp0Z3BtbGVQRFBsMFdB?=
 =?utf-8?B?THlLbWlYc2V4Ym9SNXg3Q0dJQzJ5SXdEQVd0TzRKUWN2L0xRck93UFQwNFB5?=
 =?utf-8?B?MGgxdGJBaFJHaVN5L2FmbE02djkwY3ZrYjdhYjd1NWNiY0JWRmNxSzBiNUpR?=
 =?utf-8?B?czNINm9XWTE4UWIvRWVDYTRHUHpOUmZDTUUwdFRRZGNSc0NwdjhiTTMwWEtk?=
 =?utf-8?B?T3FvZEJMd3loK3NZaEFmb0hKcmpndTNKaHJ4KzhDRXhUN0pUOGlVQmpCR0tL?=
 =?utf-8?B?d0w2d095RGZaeDVOVzdCOWh1K0t0dzFVdThmUXRnaVArSmxCMTFacGdXSG56?=
 =?utf-8?B?Q2oxSVNseEY5eTM0OHJvUVVlZmN5eW9rTVZuR3cvMUU3NmtnK1NuRUtLWnJr?=
 =?utf-8?B?NnVWWm1xSGhmZWVMbm9RV0o2MU9RYU9wK3hoc2ttNXBJSEp5M3hrajlPUUo1?=
 =?utf-8?B?WTdqa0Irc0pMdW9SYnpRbHNMUk5Bc3FCSUhrNEdEcjBsSENYQUszSEFJK3B5?=
 =?utf-8?B?NXphTkdLQ3RKV0hza256cnhUZi9DalgzTEFlQjFjbDdTOFp2RDdlYzY0NU14?=
 =?utf-8?B?QkwwWlpSWkp2MVppT1U2NThXY0VsT0t3QXhxQmdwckdpdy9YUnZjOVhJWmNF?=
 =?utf-8?B?cHJVbnFvVE9RWmVQMlk2NDR2OXlmOG9zWU53TjJkTXlrczBOMFBnWE90czdL?=
 =?utf-8?B?RTJpcEtTaUduSm02QVJwRTg4RVZRTjk4WFFhS1YyYlVtVkphSVl0bEc5RHpq?=
 =?utf-8?B?UnlHNHF0MHdTVzlSUHF3THBzV2NRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <571DD9E5884E214283D8C1E88EBAF7EF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wb8F/k6AbZ6hWZj6baoi3/R7YmJbPUXBm/QyTh/Bvhqj+n1IqOqmli+WdKvdo0H70HMsd0+b3itby67AEngwNX+B9o3UfxiNHFJhJz3b40GIKF1+qDJMTgHIdHvC5qfM258qGo1/egp4WMfcQ1cb98fOAs62mmUKCyVGGo/kRDlXrXVZIibTSCeG9xrl9SnT2s3ZgPVfvTRwq/BJSBihXvQ4Em0wDZrmMaE1SR7IF0WNfteb68BbcjvxFh2fBfWhC3IaaWki4jxp1ZRC7FwPCbUe6jJw/EZv2L+BsY2CrBXrLw9IUreQEaRLGSQlteH0B9EYP7hUmQwMMw6obti3LwLd0iQaTNFLXDnwxuWH14KPlmY+W2SibWb87ZjC/IpoJf/BumufpNPESa1yWfdUOyhUcSjLGSXDWVAGenPUNLFMzZecU4AUIdD0FnibuNqBwRaQi7LUoNvReDzpbUsryLWPi/qRgdVOUMrbtfOIhvdsu3LNBPYZenJ6EbbgAqkRE2qKhFKL9LYO0DbxAoEs+2wPXPfu3MpMZkVq9TK2V6YMz6vT1ZnAnwq7vYFQRPxs2KEFMo4iiMzdi1pC1kg5kSVaC52+umoVG4G4S8AdhkpJpUaZ8TVs/1iX75CPaorO
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fa555f-9d3a-4be2-51c7-08dc58a72189
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:10:02.5116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQZuLpWORdD+ZVDHF2F9XBcCk21PySu+MhSjAw+5WwuvzRXJDOFxxI5ig2LkINATMcTkLdFur1z6l30kCYPuPaUK5j188x3ZUKh7U2s6qXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6760

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
