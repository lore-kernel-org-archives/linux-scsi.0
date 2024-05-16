Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66341145B3D;
	Thu, 16 May 2024 13:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715865023; cv=fail; b=PKGTdT7zLCzwOusoh/HIcVAfuyJq/TXp41UVeDH5+NMP7nG4Ep/Qa+PoDTBNNS+5ZUPPW4gbJCp8ddOAaZdE0ii8QS14oMnlKeDXGimDRI0QE/UdjmBNYFgNnXD0/KlgSt7R/TTqy95M0RQ5QMA7BpDnaEBKm25RO8RrHUdjhQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715865023; c=relaxed/simple;
	bh=hvf3LFC465DYWJd4arFS4ybLFVBtZbnH4oZwcLwarcw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UgjThlrTL7ak+RT0JUbXr72sFkdK3GebXlwvcXpMfOlcv6QxBO5vXCQ0N/OtzYGWGMLukPjmC2COc/CJ4fXoepQ5Igi07oQ/4FIJo2EOKhshRWwfiNz+q5z3GamkoQiXIDaqqltHiQNJZXMq/rWo3lg0YixcrI/36PhcXV+9eZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KlNcJEwP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u9lG4jhA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KlNcJEwP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u9lG4jhA"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44GD7XcZ005604;
	Thu, 16 May 2024 13:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=oozUgZvzAdYAwgZO74j+Uj7e5uPEdowoyEfJpDHZ6qs=;
 b=KlNcJEwP9ZsqlxpAIcd4w6+4dUmxUO6yXo7EQACUFrKSZlhIJHI80dK2MezeKaVAGvM2
 NaORl+N+yotX61ho/RxfBM5WkaIFz2lnxRRag+fkyoQPDul1iZ6kUduF2ShFmv5yFn2w
 QhIl+hTf0gIvOjBGlP0nwL+wyzzPqO6cYfnHkjODgYhq8YeGei7/03NniWxTAhUsiaNX
 NA/aiJX+92hyB+TVS1jfbqVQLOWavEYpKYbakvaMtdurTM6sER0NdmDUFM/1qJ6rDgDc
 ZIYNqcSGadXxZc0CPCaNkm0fdyqDmU6eKVWl3FqriRsiBtebZQFtic90XgabZviZbNoF EA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y4c8r544c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 May 2024 13:09:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44GBdXGi005729;
	Thu, 16 May 2024 13:08:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y4a6emt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 May 2024 13:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbPffQUUbBRBEwM83zms+xaCUGdW4Y22f55vojJmQnkz+D47K6PntD/cMv6uhT8xDtYXwwDVcQtWc4edju+AI5e6XXkctCDHd/K4dMBY7ooCu4VAaP8uTQlRFydJYK4xrWc8mUhhc0LMVQtgLqw5l/CpDZqGl1Jgiut6fjxEZkv1BQtEEQd1J4BPDH3faHG9WriDxyBprsW0jykTEYKCIoY5NJSa8y97b9P4SFwb2ivv5HSQoG4EBc05ATt4LYfxFf7PJkk3shW5DcAIgydgXUNrxqHL3iipYs3iRk8RkHStwlDHe4RD2VqM8VCI6Y3lJhKzQviyNYuwG6CQVLnpcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oozUgZvzAdYAwgZO74j+Uj7e5uPEdowoyEfJpDHZ6qs=;
 b=eP2cdnv/f43u46c+xnAWqEFE+O5B6ovnwIB9vplZreUQ2+L2XVvj9Bh1Z0/G3AmFMT4ykie3gNWj9B9c+F+dG6alfhlyAT3Qs7IxzddO7VrVMh5Jf8+8usf9YXqm8RiFt3JgNR1igmDANvJJbmJm9W40dgO2/NO87jMuJceqwFJdoMyPSrEi95bs+EKZ73h12KL8Wt92KCaYVWOAz/VO0CZpa+KUmkQCIZxPRAy5kfYfeUPmRebVQB4VVeINiMju8xhV1Lh21rMZVU7EEAqV1ieJHpFjeisX0rdSQ3PuUd5+acclArc0OqUcPD7ZizCUFc/CuGmb/7B+IOgc0If5Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oozUgZvzAdYAwgZO74j+Uj7e5uPEdowoyEfJpDHZ6qs=;
 b=u9lG4jhA2d68xBTqXs4otFWP6rpqscw72jkgMGqOR66xYfJvswIdkHThgekeEim/xwYO0WvJ1mb7WTMkcVNUmBIQO+bsGg9/V4sVtfY7UMiHbg7wuiao3V/4Fpv2pTkqH0GjHvpTC59LHiGFMXN7xVFd77NAS1LB30bXQ2b4nZ0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7272.namprd10.prod.outlook.com (2603:10b6:8:f7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.30; Thu, 16 May 2024 13:08:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 13:08:31 +0000
Message-ID: <ff3277c1-f3ea-4e12-aeb6-548b97d42589@oracle.com>
Date: Thu, 16 May 2024 07:08:26 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
To: Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Yan
 <yanaijie@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, Hannes Reinecke <hare@suse.de>
References: <20240409143748.980206-1-hch@lst.de>
 <20240409143748.980206-5-hch@lst.de>
 <ce2bf6af-4382-4fe1-b392-cc6829f5ceb2@roeck-us.net>
 <a8c39499-1410-4251-bf26-36763f5f56b0@oracle.com>
 <08beb913-f525-49e2-8ef2-f62e9d466e53@roeck-us.net>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <08beb913-f525-49e2-8ef2-f62e9d466e53@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:74::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ca19a72-b75c-4659-f09c-08dc75a948c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?TFRMcXAySDRTMW93M05vbkpUbUlLRGlqMndqV05sUHFCWjlxckpBcjNMMUds?=
 =?utf-8?B?WkdWZ0ptb09LMmt1VjFtdi9YOTlFTDR5WDlSVmtNZG95Y3lrRkpWNzVNRTVl?=
 =?utf-8?B?QjBDVisxTllXMTJZYzF4NGNVY1VGSEdTdlVMOEQrbTlUNzRuVEhKdnVPTVZq?=
 =?utf-8?B?dnRxalp5VmZabXczYjc0NWNpRzZoL1lyUmpUT0lPS1lvcEs3bW81bWdNcVk0?=
 =?utf-8?B?akRtc2RWZm9TRzkzbUZETDBCamFicDB0M2M5NUxFbjU0Z09vRHFEbWR5VVFo?=
 =?utf-8?B?bTlqODdWS2NsbnZUcVR3TTU5cXJzeDBrNnYwM1RyMkY5dzEvYkVXOWFXMEd5?=
 =?utf-8?B?UFpXamtQWTdxUkZ0eDNTRkhuVjhiSi9YR1lmY3V5WjFTUXIvcG82bUx6R2Vl?=
 =?utf-8?B?TURSNmJBRC9PQlFiN0psMjR3WkZWYy95NGcweHZXb3dWd29qcUZVTW9iNFFN?=
 =?utf-8?B?UGJpanBnMHFuaTA2S0VnWmFXVmJJYlFuczF6MmVjQUdEZUlEQkNtckdaRmtE?=
 =?utf-8?B?aG1OazZZSEZXMHNUbk5KU1prVWxzMzNSdUxJRjhGL09rQUMreDYySlM0cG5V?=
 =?utf-8?B?Wmk5K1R5aE00SCtrTHhENk1CaWlrQ25FRTVNUm9tQWNDcjlOYUkyYzhhN2Qz?=
 =?utf-8?B?WENsRXBuRmJORjZVVFBRM0NUZVJmOXJZSjFrNUg4a2pBZUhBcnpBekFKLzVk?=
 =?utf-8?B?amo5dGhDdCtXZGk3UEhCYTk3bkFwTEdUR1B2b0Vvc1dEY0tzNllwZVo4cEdM?=
 =?utf-8?B?Y2FrKzd6b0dsSnhxczFxdHFSTmVLOExxMGFIWHBCWSt1YzFGbnc0QVdWdC91?=
 =?utf-8?B?YlNPOXM0dG82VVdGeHdSTStnc2M1SFFEMEdJUjVaZHMxVkdBbTNRd0s2SHA0?=
 =?utf-8?B?YWovenB3M2l3ek1tdGhGeDNsS21NcW1CQ0h1V1U5d0pUaEltTnR2T2swR1E1?=
 =?utf-8?B?OU56YkFLQWlJbDFHVkQxTDhwcnFkWG1kMXBkTDcwRFNxbExpamJGSWFaZWxJ?=
 =?utf-8?B?aWFDcEtnQTd2WmlDS0JxNEM1MmNVNGR6N2NJU1lnZlFnSi9RSHpneW03MEI5?=
 =?utf-8?B?dG54cUJXa005N0JmZ1dvZ1FLRXB2R2NZOUVnV0RnQUczck5wNE1mdERPcWhX?=
 =?utf-8?B?Z2JubDl5Nkp3NnhQUnlJT0RJSUpyd1owUkloUDRDNGFNNWFZZmtMWDk5dFJD?=
 =?utf-8?B?WG54V3lUUUZOQVNvcENScWNMN2dwSm1KS2NHd0gwYkM2RE1lbjd4d1RTeXlD?=
 =?utf-8?B?bDhqT1cvNlF4MEdrK0sxRERaVTZiNXJqVWd0T2N0TU9qOTdaU3JuT21TR0FR?=
 =?utf-8?B?dVhyWnl2bkdCa2hUUmZFQ1lwVUlIUnpuNWtVdHVQMWgrd1pCdloxdzZ1VHI1?=
 =?utf-8?B?ZU9ZbUN1ZUtGNEZhL2xSMHo2bzNpb2U5T2crZWpFZ0hQSTdISGFucnRsYjZa?=
 =?utf-8?B?dEhSZGdMSlIyVE1iOGc4bVZUWTZLUnAwK3JBcThoNnJLWkhkbEkvU2xoMUFa?=
 =?utf-8?B?K1hjZlNjVzFDakdJblpRek1nSHRnaW8yWERLUnZyRERpcmFOZEt3Qm9aQzFz?=
 =?utf-8?B?QUJveVdpSzcyb2FNb3RtRCtLeUpSUWc5ekpSNC9PSWhOYm9TTmlOaXNDUnI3?=
 =?utf-8?Q?npKIROfikAyNzeng5qTtWPI2GCgF7yJwa9qO9vROMb0Q=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YzNpUm55UGFiV29sUVltaXpRU2FFK3RwT0xJT1BYY2ZYNWdhbWx3dW1lcGdW?=
 =?utf-8?B?N2ZweW1DdEVheDZBQy9ESzFFb2pvNGRKWVMwMHVxNmFqek1qYlBYdlUyWUF3?=
 =?utf-8?B?ODRkV2hWNkNBVmpQWGE3ZHJrM0ljT2ltMUpreGkyaTBhRmliOXpCWUJRNUxO?=
 =?utf-8?B?eVZ3dUFwYWFnK0l4UEdmUDJBaWNpZUs0aWNSQk9LV2g1NXhhREFTcm11em1q?=
 =?utf-8?B?Z1NEYk14TllHSWNGR1BSSXJDTkJCcGdBZDFmaE1reGdHYWN2dW5EQTZHTW1w?=
 =?utf-8?B?MmEzN04xeGZ5QngxN0hSazUvb2Raa29iNkFrVHE1dUxKWVNRbVlDTnpySmJC?=
 =?utf-8?B?QmNzQ0ZQUElOZFNmenY1dGczSmxydWFpVHU0LzR0d3BmNHpJdFkxWDVOUnY5?=
 =?utf-8?B?bnUvNmk3R0hlOGY5ZFFTdXBwSjRJaDhvY2FTQjJja0RvbXNueXZPVXNBakpX?=
 =?utf-8?B?NXBkOHJiVTk4Wjloc082NmZpQ3VQNXE1MFl6SFhUZHBoVGkzcktwM05SOUpT?=
 =?utf-8?B?ODFpL0l3d21INFpRSXY3cEkwZ1dId09LTDM2K3FKRVpZMjkzK3YrNy8rZ053?=
 =?utf-8?B?TGJGV20yTkdsZWt4aDdQd21DOVpnbXZGdlY5QmFwUlJOQVpCYlRRZjRPUUgv?=
 =?utf-8?B?STFiTkNxWUg5bE50cG93WDA0Y0M1L3ZPL3k2WnltN3lVMFVLY0tlRWNxZVNC?=
 =?utf-8?B?aXZXWG1QekRLK2NjZ01mVFdQM0toV0NGNThvdWtwZzZDY1NpK3B6RmNPaHhH?=
 =?utf-8?B?QnQ5N3EvL3ROL2oxWDBubm41UVNvbzQ0NkIwYWU3U21wTWxlT2JIMzhjK095?=
 =?utf-8?B?dThoenVueFZZOVpKT2tkejB4aVRCS0R6Uk4xS1lIMWJyUWU1VitXZjJTNVpi?=
 =?utf-8?B?K0dIeFRsVTh1QzZGSU9FaEhGdUtMRkpHV25laXNHS081dmtNSWVTZ2ZsaFJG?=
 =?utf-8?B?eEZRUzg0TnZqa3UwS3dhVDBUZ2xkeGowR2xCMHdJL053d3JVWE5UbitiMTVY?=
 =?utf-8?B?cXdhdjlPazVIVmVIR0VjR0dnRUpuM3N4NTFJZ214YnJYZXZ0RnYvU2xhU3Az?=
 =?utf-8?B?TFU4RTlTQkx5TWtERENGelFrSFBKYjNZYXJ1N25pa1RWRGVBZU5laXdTZEtp?=
 =?utf-8?B?Qk5vR1RmZ0Q1ZTQvMFRXZ00wZ2RMak9OcE1wSVhRNXFkU3JGNkxJOTdLNnBS?=
 =?utf-8?B?VGN1a3BDUGYybkVrR0xLSjdvbjFUWWtlTHVabGVjOVFVV200R2tLVXRkLzBM?=
 =?utf-8?B?anZ2R0dFQ2d4OHVvNGNIVHlmR0lVczR1WDRJVFU0T3JvQVM5QmFTNXdVQ2dl?=
 =?utf-8?B?L2pmNFNCNDRkMjZDSUJZTG9COWU5Ky84YUZERGVTb1dZSWlxMHpEOEtzSzRR?=
 =?utf-8?B?eDdiN0xqR3FrSTA4M2hpY0ZKYkE3aUhndEs3blF4YnNjRnBoOExGNHc1VHFY?=
 =?utf-8?B?ME9pS0kzSmRtRDFVVUxJOUYzVElJUFRBNW8xNWlSTTIrNHlFNGJhcVN2S1lq?=
 =?utf-8?B?dWNUSmlzaGlZN0tvRTl4KzMwWFVWTEpiYUdwMlZkN1BWMFlsTW1YZGZHK0o2?=
 =?utf-8?B?a0hTVVYxVkorTzBZa0RDMlo1ZHkwK0c3cDU3ckVCMFliblVIRDM2eW5ZMmhi?=
 =?utf-8?B?ZXkxRWExZmo3MGFlajJ4NURyaUluR2l4TmFhOVlRajYwWlRNdXlNYW5oNXZs?=
 =?utf-8?B?MVBiOEhwV3BOUGxneFpxTTdKMjVYL3JrSjMyTEF0S0xvVmg4cmZyWkFmbjY0?=
 =?utf-8?B?elVaeGdHZlptb3B5QWxhdE5pQzMycnNpVXd1UmpUOCs1Z2JTNUpMaFV1cEpt?=
 =?utf-8?B?VWt0MVZWcFA4eURjcWtVRmxKZnVVVythTlR3cm96S28zcnJQRmFMUTNlczFk?=
 =?utf-8?B?U3hUdnB2bkxBU3BzU213NHU2eTRXcmREWVpFV2hJSWRtQVZrQ1psOWNpSDBO?=
 =?utf-8?B?TmpqWGtBbytuL2F0OXhnaldBa0FaNlJyV3A3d0tFYlFWZGVVQ1l2R1NvbzhJ?=
 =?utf-8?B?TVJ6S1BGaVpJRktFUTRwOTdkYm9OSno4cUpEUGNGVE5BS21JZzRqUTY1ZStR?=
 =?utf-8?B?YWpMd0ErQzFKTnlObVU4ZWtiTW84QkRpMVlKZzFQa1oxY2hDMFE2cFFkMkk2?=
 =?utf-8?B?WVFTVnUyOFJjMzBOcytNZEJDUjVQcFU5bXA3QnVieWUrQUZqQVJJV2JIenk1?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XkyOpveqnlc7KfShMdALnfaVM0zR4wjg21ruCtGNf1z5xzPG5nfz1QKZciKUJZeP7IhzKDYZIX+Z3qjTi4iUhFI+JVj5anRpgebV8drCm15no1eAGJjxLSDZvNcKHHEyodU4MWfw1QLGAy8aVviW+F9ixPmYcTbyR5vx764QX2r3bS76Wd8PepgF86Aa9F1+P9SK+auV/jqPzd2Qo53hbFp3nqyrb1Hz15j8JY2WBDYBX3ULoVX/T8HYEqGiaisjUVW77yqRttW37wijztbFA32oKBCZj5gahi43eWfCTkC35JSYWngt3A5M5eeB5DEGN/uk4T0CGCfCFU+z5/XqI6MAMAqAPU7Xq/Uj+3Ks9xkJYSm24+TBqmI9NLx40u+sHb+esKcidGQNdEs61d3/F1p00MzIz10LX2JoI/peEUqGfosBAQW3uHa1AwV8tgzUCqCOudv3TOz3YeUVXLdhX9/sd4dq/pMzWosXR2MEMA8uZF9pTmujXOs4lvKvD+GLq1Qw8XGHL0bSWiO1H+d+HTKJNUbzT5Mn2B88o/Km0IFA926MaY4sdKrC325sw+Ta9Kcyy1JG11ikCWcqnFa+S+RzEVYZunBB2OOSrjYwz4w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca19a72-b75c-4659-f09c-08dc75a948c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 13:08:31.2737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yI2ylbT6oLWGqMMyxy9SxdE+U0TqEmEB2wXjoFB3xMJ4N+Pon6iFkTNm1X3xocYf0Lpi05dzfrI1Q+uqHTzmeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7272
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405160093
X-Proofpoint-ORIG-GUID: XY1nNlvRAJ9yvSPasaySCOMXO1CjtueH
X-Proofpoint-GUID: XY1nNlvRAJ9yvSPasaySCOMXO1CjtueH

On 15/05/2024 17:52, Guenter Roeck wrote:
> max_segment_size is 65280; PAGE_SIZE is 65536; BLK_MAX_SEGMENT_SIZE is 
> 65536
> WARNING: CPU: 0 PID: 12 at block/blk-settings.c:202 
> blk_validate_limits+0x2d4/0x364
> ...
> 
> This is with PPC_BOOK3S_64 which selects a default page size of 64k.
> Looking at the old code, I think it did what you suggested above,
> 
> void blk_queue_max_segment_size(struct request_queue *q, unsigned int 
> max_size)
> {
>          if (max_size < PAGE_SIZE) {
>                  max_size = PAGE_SIZE;
>                  printk(KERN_INFO "%s: set to minimum %d\n",
>                         __func__, max_size);
>          }
> ...
> 
> but assuming that the driver requested a lower limit on purpose that
> may not be the best solution.

Right, it is relied on that PAGE_SIZE can fit into a segment.

> 
> Never mind, though - I updated my test configuration to explicitly
> configure the page size to 4k to work around the problem. With that,
> please consider this report a note in case someone hits the problem
> on a real system (and sorry for the noise).

Other controllers do have a 4K segment limit and are broken on systems 
with 16/64K PAGE_SIZE, like:

https://lore.kernel.org/linux-block/20230612203314.17820-1-bvanassche@acm.org/

Thanks,
John
