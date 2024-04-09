Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9152613665C;
	Tue,  9 Apr 2024 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675190; cv=fail; b=ieh+ma+18t88KUVjWXFODNSwWTBsrPrcIB772egUClLJCnC9MqQCQRtb6CgNJpbWWCcFX6TrRsZ3LZCOHawlbhuW9y80sQMLWR8LIyGodYCXrBGKGLvAa+OounrIZTmCYmdiB4hh3IugiJXk5Q/MSaJgEMzqw50Bp8+meL+QVb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675190; c=relaxed/simple;
	bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L07u6hDbl1F68FFLbgms6vSF05b6+jgchm5VLMv+EUNDV7wT9hrsQXS9QshVrp8oK5R/NwlbluwBNOGuiaW/VlUdgn7Ya8A0mtd+8D7E1UwMyECHNi8pKDxBzIWFbevkhDUGEWNZ+PQ/+t6zeTbL52GP1uU52nqc0pQsgXFF3UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=OwTM/igx; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=Kf/yv26g; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OwTM/igx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Kf/yv26g"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712675188; x=1744211188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
  b=OwTM/igxe+TZB7isixBwx1pjhBr6J9HFItxvczHI69PeuZABihLKHsCX
   r+9GKdO1XPdpFGeBKUtgkWxtSeiYdSN+gQAWjibNEPbXRRkm4o/Ac02c8
   nwd7WN9n/LtPxJWQFzGa+fcQ4UX+Pt73p05UGl0EIw2QZVHBjF3XvB1+Q
   EqOYykyVT7UYB4FH2XfvqoO0cPOIB4q+q+WtP+dss2HSqSQbW9gQPB+Xb
   PDg0p5ztNAKiflgPOY4lMkqFSfH8k3l1K0TVD/d0MwIIf7eedTWFBoJYK
   m6mWXYAWZds06yJZfSIoA2+3RQ2q2KWPx114Nsr6mVP65VP0dEmjqpJG4
   Q==;
X-CSE-ConnectionGUID: OElsb9BORkyIvSuoAs6M+g==
X-CSE-MsgGUID: oWoH50g3SS2H+RoOCVTMLQ==
X-IronPort-AV: E=Sophos;i="6.07,189,1708358400"; 
   d="scan'208";a="13424336"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Apr 2024 23:06:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+SDp+/xuajLOfkcv6yWEpyy20dlzbWbtJ6T5AtlizbyyyxD2qczYawPd49+jiHwElTT7aIVvd3+PvNCuFtIsiHkvNhDn9NiKK2I1NS/4qHPNBW0nKE46iDfqWsUpmHYYSNomH1N1zU35Hxrw77EH3z9YaXiiFEi7E1dhx4b7eT9pzdk0I1Tmsoj6uhRfJdGYPVvraTUQq2c4iquBhfGR6/1CQPvRWjVEhN4tPH/O15qHRf2aIboZzjjkm2pYTx+naf2CMJpaGEV8KGpnWtrHuWYu/SSH9geNX94J6alYUhR71eVo/TMCsrFQvtEwppkoe8ef0oIw6O2quGs6cGhkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=cKmrPKEMCYpxvYpC3Gtz+TdbmfpJZ32+DXVSQAXrd1jet7zOLKyK+h/ddCZFgjWUTf+yRY70pQFSrHhGIUouhfOLEs86tPf5tudYB6qH/6/YUI4QYGuY9QQ6WZtiLQRKF3oug0Yaf0FdeuUoiu78bbFR5lhWEE8sD8YUWf6BLleeJtZeBbyMrmZ8GW+eKl817U0LnRt+nhChlIYlmhvqTPkiYwYqGIWjCX/wTFyoAMGP+N0BYpvuxEbtlQnif9Isx/JKFpXmzunxLootyT82eXRyFN1rktrEsQslxv9iTSS3IuOvXrR9Z88SoHIYolgblydF1+bOfT8482fn5SdGKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2hUJbB8x1kfmvsTSguaM0YPcY6xrQ/6geYb6UO5dM=;
 b=Kf/yv26gXKu0Kl4aURlxRVenc0AO/CZ4YIhY+Wm7iJA7jBpmsE5WGtqpL5J9FAT9TEPjhJvRFtlZ7ls3TBC2Y7MY6o2Di0eGde0G8sn45mdlTRieUB4Zx85/iuMZvj8+/wAyQ55n2xUqZxV44i7+ATOzgOWXEFDIQlQXerwDPAs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO6PR04MB7715.namprd04.prod.outlook.com (2603:10b6:303:af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Tue, 9 Apr
 2024 15:06:21 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::48bb:3ec7:409:1907%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 15:06:21 +0000
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
Subject: Re: [PATCH 02/23] bsg: pass queue_limits to bsg_setup_queue
Thread-Topic: [PATCH 02/23] bsg: pass queue_limits to bsg_setup_queue
Thread-Index: AQHaiouiABQo3wFikU6PDFwt1R5sVLFgCd0A
Date: Tue, 9 Apr 2024 15:06:21 +0000
Message-ID: <70e10f2a-54a2-46da-b2bc-24ae2262e1d7@wdc.com>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-3-hch@lst.de>
In-Reply-To: <20240409143748.980206-3-hch@lst.de>
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
 +qRenYWWeyCblm0qRyUzYZsBdTDDsENbpLQn1HZMXztAQKryGEx+dHGSV9fXUpIUKyNeXK3wlF4YTyhmb48vHumg/5nY4I/0dludHoqgw4v/qlAtZoFC2sxuexkedFSfsdHD27DSagafOwgZpuFhxVob+6uBWQ5CI3+7fuOqD+2d3MYpNVj05tNPrYyWVI+vll7M/jxN/12WgkGrV4Nxxr7Y0GHahqrOPxzLZrfNKI2NFDmaO0kLt/9LmtU61HXN+jdn9lE/5LZW5BllvNobyCNgbvSzJpMwBTSTO4pgFxmKBZ7/Cc75Qhe74eYuvPQc3Uro7qocQa3+9suG+nKI/QXg4SUpptAUveZrsFTY+Y0np7JH2+xtQdr80sbrk1TZ7GzayJOjXXMCdid84Ke3GldFrMNDZokrUalpVxq33BimN9bbV3yqtMb4IpCa6KRHpgv278nv7UUF0J/mKxQZnJQ8SteqlxXw8J7uRk+OCs84fK74fqTkL6tEUa7DjAsl3KwlNJVDAkvUjM0JY4cXa0IaKRS6pXJuBa2mJqDm+Ss5/QkgaiD0DfVosQXfNZg+qpZFEWDbP7f4eSKIG7SdULe7LVveA5DAqBtss1RbxkPEPXsyLglA4ivhlq0ii53wA293CgGwLRNLTGtqssTQalg9/UisZjjTZAk6lxqkQec=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TVpBRi8zZDMvdmpzcGdkL2pUOEUvRmdnUGhZR2JXVkcrRE1qWnlieGxlaXZR?=
 =?utf-8?B?d29lTHpsTWtDTjdvWGkxVnlIK0dmY1N4TVJhS2JwdjZYMjZ1MTJjTjVnVnlS?=
 =?utf-8?B?Y0tab3ZFNHN5VHVZK2FGdWdSTXV1UXgxVTdLMVhnOTBpc2pkbEN2c2NLWGcr?=
 =?utf-8?B?eTRnRGJNR0ZUZnRMWE9tUGx5K2lmWU81UGl5OW5VQ1pFc3JJR0hZdGNrbVla?=
 =?utf-8?B?K2lZalN1SXJMSEpwVlIyTzRmMkdDdVNhKzBLQWVsSHI4M3gzQjgvZ2RDR3Rs?=
 =?utf-8?B?TmVBV3h0eEdhbThsVTZBNjVUdTM2cG1JMXJhTzdURUhpS3Ztc0EvTFVHeTBt?=
 =?utf-8?B?S1Q3Qk8weXhQSUZ0M2JOVXI5T1FwTVUwUzVWUmhDU1dDM2dRU3hGVDlBRTVE?=
 =?utf-8?B?Mzh6Rnh0TE9PRGFCZEpiU1V0N0dML0pKKytGSFlxYitlWkRmOUE1RnZ3Uk1W?=
 =?utf-8?B?RkRyRG1uaFUxdlZZTExJclBhMXk1dmY1SjVkMGxOdkJRTHVtMFhlTVlZQ3JC?=
 =?utf-8?B?UEV4VHVwVFlCWEQwMXpMVWhkWW5Qa1V3OHg0T1BjakhVV0NIMEpjTTBRa1Zm?=
 =?utf-8?B?Tk9CcHJPMzd6RmF0MlVWWTh1cFM5RUpRS0laZHM3eVZsUDIzSVk2NnZYbFFR?=
 =?utf-8?B?SlFZQWVYM0lJN0p1TERyV1p4UXRJOFJ0ekZGM2RPNURkMHhZaWM2TTNNR0Fv?=
 =?utf-8?B?MzR6VC9NTXJSanRISWNIWHluVDJtbnIyNFZMMnM2OHEzaGVGOWdhNmo0VVR6?=
 =?utf-8?B?Y01iNkdtNTFIeHdtN05vRml3OFdLSnB6NHlZUE5FcjJraG8waSt0dUxRUFkz?=
 =?utf-8?B?OGhXU0dsbFFsUjVSM1dYVkcyY3ByRDlLS2Q2SmZ4ZmpqZm1JZ29ZQ0YzMWZE?=
 =?utf-8?B?cnZIOFVSOFA1d0R0M1NOaXFXQWtCT3JqSHN2MGJsUkVlWHdnckUrZVRYVStk?=
 =?utf-8?B?SnhiQjN2akRTNGxPL1R3MXZBWjdmbm1QdjloSE95eGFDRHNHNjJiQXd2UDBC?=
 =?utf-8?B?NUp3Nk1jOHNKM2cybzdiNyt6Yjk2L0VzbG1WMmtuelBpaWNTM1NSS0o3TW5p?=
 =?utf-8?B?b053bFBYbVBKYW9pTTFxKzhxU0FweHp1OHdqcmd0dVJxWG41Q29BcXRiQko4?=
 =?utf-8?B?OWRobDdKTWRodkpITnA3UGQ2bU5xZjlURE0wUGJ4NW51Qi9jUFBoVWl0bThJ?=
 =?utf-8?B?UmwzcXZielRhb1MzVHlxNFo2cmF5Tnd1dzByR0hOd3d4N3lWZC9VNWJSTkZ0?=
 =?utf-8?B?RWh3TnM1YWY1d0FYQUxaUFVvKzJJbmN4TnA1R3Y5amhqdC95ZjlZNVZHYjIw?=
 =?utf-8?B?MUt1ZUpCdzlDd3JYR3pMVHZKRm03LzA2Z0txSGNualFFQ00rZUJUdlUzdC9v?=
 =?utf-8?B?dXNsc3ZHL1VXV3VlWHN2V2htelBWSXZHNjFnYUV2cEROcDdDMWIvRFl2VkRZ?=
 =?utf-8?B?Yk1ERVBmM213K1J3SjhTY1o4MlJod1psTVlJblhzL1lhSUk4NURvUVk0elBs?=
 =?utf-8?B?Wld2K0FrSm1RUG1yajZET1hmQ0pmN3dRTCtWZlljaHgwRWpKSktDc2RTZVdC?=
 =?utf-8?B?R2t1OFgyQjJQaEpkaUp6WEEvNWVndlNWWFhPNkkvcXorNUlXTHQ2dUswOWdO?=
 =?utf-8?B?UXV4NTZqNUhJekNJME85MUl3ZXBEeWFYSkJMVklqb2hqamNHQXVHczZ5ZjRD?=
 =?utf-8?B?dGhhV0l0MTV3WXFucktZcGw4eWVYbjZxczNMdm51SW1FRDhVZHlpcXEzTjlD?=
 =?utf-8?B?bTMrZWpndXpoS3lMTHM4TTFsUG5kNUdnZE1uMGNqWEdSZE5ibHVheis0eEIy?=
 =?utf-8?B?UmhkTEpUWVhwbWk5b2R5SjdabUxmdVdBdDVZdGVTR2NnQTVpK3ZPWTA3Smpo?=
 =?utf-8?B?Q0NYZGJWUENGRWtkZUw0ZXAwcXBpVk55bmY5SXlwZldWVjBUeGcxc1NPQms3?=
 =?utf-8?B?cUFIaHJQano0R2xlSmw1S29wUUVmZXhEczcwNmUxN0NnWktjWW1rQWh5MEtL?=
 =?utf-8?B?a2RCSjlLbWxZWnN4bE1pWUNuY0Q0eGN2QjJlei9qdDFEbVZoUm9UMk1QK25D?=
 =?utf-8?B?S2hrS0tjVVBvSytxUGJMS0NvUjFxM0tlRTM0RTdycmZpVHVjRElFc2FaUmc4?=
 =?utf-8?B?VG5uc0pKYjBPekFQeCsvNDR5Ujh3eS9NN0lDMXdnL25ybVZtZzA1Y08yZkRz?=
 =?utf-8?B?aVBLWjljN1lHNUFkYjZKUE9vWWdYVUJNR3k3b0RST3NZUFlJWTd4c3ZpN3pI?=
 =?utf-8?B?VGExZFZHREJWeFpUT0gxOVFvRzhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F8DC5B123A93F4699F64C81BADC7292@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6lkYCIeD2GueRKT+jGXeTP+J0HZgw0RyZALJGmCeHQ5E9yIoks7DpldiQ07ag70N9+ockND0B5l03MKGYq33iRvr3eARLhIJJnVhVx4sOgTiylngX9SUqTxTX58fbD64khcNcHhYO+XA8fAZh3lyZJ8PpHLQ6E0rhEVVZj6V+ZxgzpO/k6FBKuXPt2rxMnXwQHD1zuwe9Xsl/marpOb9klJ5IYtsR6Fvswye6HTjZwfaLxQqD/w+JktNUv5DVgt15AXOKabmiM7rOJtFZqMls6wk2Vuj/f/rl26wBa8EWIWYKJ7RNSyswtf9OqGukLP+egSS7LjYLXHaVK5JVc6Tt7GmGB2dP7Hi54b/mqonjHc9UA/lS7Wam+jOC5f169XZo5roG0OQfMOftHZmKOjS0vZXyBJZMmQQotB5wxh8nvuSPMWEf+82OlP6xZiapfwXobwXi62lzHSu7NMHzB3ouQqX7NAx9gcXw8pStTgGnNm6zyLQcsEpQiaQbXHMWzNZT5IDnqenehWyuuhyFQTAJd1ZK/tJ3BfjVoPpOskL0LB/BBy/WctnZrEFSY44ib4C5C1vLiiA0whBSCpqb1d/zX+pEyq5bCtgNGUfvZvIoIuug8Dj3uCdgkPtMl7A307N
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05144b57-1a01-45e1-d5c7-08dc58a69d95
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 15:06:21.1238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 091iljQRPY4ILK+7mL6/JXETUxGivSj3P9KlIwORdVOYVMxroWaw4lZlWLo8tUukYbGHkUu9Uvw+LSb6kKfOaKgmewTFYzU5GMjaJpdVlyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7715

UmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMudGh1bXNoaXJuQHdkYy5j
b20+DQo=
