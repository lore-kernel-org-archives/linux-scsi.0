Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A5D634E2;
	Thu,  4 Apr 2024 07:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712214924; cv=fail; b=jppU9tbUTGUocXt4Tz16tqrylpXbswIRyn/SwS+5aUgSI94ARsDZbA8JAuyY8MNKU74G1FK+r4899BQ/TM0utC0xlK3v76UBDzAScuNHc4TTapdRjrz4rnqhLYOnctqG8aYebA6Llx6crCIplxwtj7VwrZLx2Xjsb0Q5ehoDMEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712214924; c=relaxed/simple;
	bh=qLBaRCtztCjNo9mFKrw9N26/uLQdug+IlmhHwJJCbpY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K2dYEbWnsWd0AiHr9q5+KiCo9+DwKgoemuWDwgz0PCPL1YPApdAronImSzjJzgklbXgnuRGub+AThykdLfaL/cCde43VDz38JA3tHd8nyrvAXgW9RURgJWpz2tH+znZ/nqgPdZxV8rsoh5WeMXlvdP7NxTWfWTbRdSxHa2HPECE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B8ibdewV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zsSrVFe4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B8ibdewV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zsSrVFe4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 433NOvxa009650;
	Thu, 4 Apr 2024 07:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=40E64TJ2LIYTPyRLcD5M4pDR3wJakTocM9rdM4Pmx+I=;
 b=B8ibdewVR2QdNW/4TYeQZNPsfNg/R8Vk2vcAo85mVFAGlCEmG95BeyFdVxDPo74Z43GX
 L8oXj1DvtoKY691KtcWJvqyVRVnvFG+UfMK/huIRQITFtEKDMTSk2UxSS9lj9Jipe+H5
 SHmeTtVZSvtqctBlvDLBIRM7cmouN98ecdt7qyZ+fTXW/mXp/arNLQRLFfEgi5Hq4qXw
 RahF2bX2XeU+qq8dY0LiENXjyGci5xGkh0+zneZCww0IUYvPUmBo7Y2VtWuZM73hzuar
 mZhMBkQwC9E6htYlO+pOXesdvccwKLLwSNfNCWwAc/eREubIdyseBzbcxt3+w1T8cZPe 5Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9emvrkgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 07:14:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4346dxho009430;
	Thu, 4 Apr 2024 07:14:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emka6fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 07:14:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+rCX3FKAvUiHQB3XU6WOpSR6wZkCIHdMfrqvI/vc/e+S6nx6dHmsiqWTtP+7WuEquDx6vwad8AulD3329GqVgkIChK4JEWQe6YSwEvyt7cPoWxrFad5qdGyQov8KvKn3loijTucBjKEYIQENpjG8ZL3Ezt9lv/WjMlFLUX3IxsQqH/+7MNRhOWg9+Iu58vuqNb4p9gPZgj6uEpzvgEecnrQdlEbcDdmmJfA/2TWYIxmcvg49k4jXGnMBg1ApMlwc82/lOUPM85mwLK9k8mVKcySqnmmq81mcjhEEvpCRcWdWZ0uDeFkO+oo5CHDDoqOn3HdQDkRTAZy0P23okPD2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40E64TJ2LIYTPyRLcD5M4pDR3wJakTocM9rdM4Pmx+I=;
 b=ZZPZQUkdzysTyqouNdTfBcNzEcy/muyW3FJ2x3ZlIQM0qy1mm6x3+N7FSq5EgKPPNtnhfP7XjbMF7WT1nxejzE96Prv0sSz5IpOLIyAjakLH1Kpim5lH1SxmP9xgwOPLs+NS+UdhowCIpFo263Ps/cRd/LxW/9dPSE22HJADtkNkNQx/OMqh1iJVqko+eG8ZTuuLgx/SMFERf4fsQ5/E1uqOvhyZZ3ArfG0x83rGLfTc17ve/D/n4fOOtLiAjYi470DNUMmZgietKHM4OR/VCSf5skuerp2maMjkffXgjuROGsmfT2WzXk5hI7HytrhKgEwYcikl7mXsf85kJ1uJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40E64TJ2LIYTPyRLcD5M4pDR3wJakTocM9rdM4Pmx+I=;
 b=zsSrVFe48zmTgtlWkXRvO5xhCcT/NdbO6AYZ0rq1m7+6HAl+uqiZL48IQl2rP0W+D3w+hNIVv8Lbtz7+KBK/alaKZnlUf5gW0mcG9T8YB1Nwx2AB9wzUw85N1pFR7xeFrBeM2ZK67v2RpTdUkUHNyL2/0EBpJnpxgTGz4NBbcGU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7839.namprd10.prod.outlook.com (2603:10b6:510:2ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 07:14:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 07:14:27 +0000
Message-ID: <34c1f31b-2a67-4c3d-8efa-b08a50f20e31@oracle.com>
Date: Thu, 4 Apr 2024 08:14:20 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
To: Christoph Hellwig <hch@lst.de>
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
        usb-storage@lists.one-eyed-alien.net
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-2-hch@lst.de>
 <fd99a58b-37c4-45dd-a738-cd2b49341c70@oracle.com>
 <20240403125116.GA19332@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240403125116.GA19332@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0014.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7839:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Ax5FqAk5rlhFtX6G+ecDo3RaeLK2JsH3HAdadd2HAaAPYnM0zVnEPOtPB5wIejJRoSFS2qp1wWGxwErCk75aPdhvxWiV+oZwuQ72OzPxv+6MgQDWPu3HqYiOPRp/QPED6URtbCYRROezoolb98PDbYeBMfAORSGClX8BhHP7K2A9m9OzGG8EIZp2yA20YH31ZMyMvvPDnm83DelN/NV/nKW1wtkoiwyVX25j2eNRcyTl7nIWqDGjtprN+NDK8jh7VNr4RIdP0YVI0/GAywyCFjjLLtUL7JLr81nF5rKdHTAxbNYdr5lWsdKGx8JYy6TUKiL4wS+H+R+UyIUznXZ1jeo8js67JdvGegnD0+S8prBUWBxtYdrWe0loWqAAxWadrky1byiu3XFVzZGoXBh5M7iVMvmwuV6lPjhOGU/JHyW5BIZkkDB+Rn5pZ2P1WllRZdGzotqkYb/IrlHiTmIg46vM2VkczWehM3fbg6M9phcnkuVvEuhYG8zMH3dUnKLPzLzGq9muNqMQa/Gaj/8VnV67eX+ce8HwGtTH4bFbTgsDuB1a+rqV9GuFzdjlCHaaJh6msiyMsSgGSuOQ3s/59UT0YzMLfdcOxzA1Y/Ct7EFSI1va96e+TF2ft0igI9LUADGGDScN5kB76H7pGg+TpYDn0Eb248krRDPFFkszAWM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bnIvMGdmOFdDdWRXSE5BWUplM3h2MTJvSzdTY0NocENmVEg3dzVpRnhNZzh5?=
 =?utf-8?B?V2ZDck5uL0trdGxkbExIUHJEVWlpemo1UWRidGdTcXlDL1VYWlZlZVF0dnlZ?=
 =?utf-8?B?Y1dBSEx1bFVSNnlLNDR2N3NiNnhzNWpQb01JeGN4aGYvVjJTbE02ODhnZnp2?=
 =?utf-8?B?QVFLWThCZ3Z6dGl4MWhkc2V5Umd5NmE5a09YWkRpWHpUT2RCNGx4Y2tuMnBY?=
 =?utf-8?B?Znc4UTY2MVVUTStMQ3psOEZoeTBKSFlyT0VTRnh4c1Jzaml1aDFGSDcwWGNK?=
 =?utf-8?B?SWFCQUYxbFdvcW5mZWZCMVRBeHpZVlkxNnVsSWp1UFZ5VnlLSG9laFBMR0w2?=
 =?utf-8?B?aXJibUw5QlcrWGJUSWJmellRL0hsVmcrQ2FMcmt3b1lEVjFRbXZSTWcwa2JH?=
 =?utf-8?B?a293d01VL2ZScDVqN2lWek9EcEp5OHQyaWpIbnBQMEVHaENJMmFrdUg1emE4?=
 =?utf-8?B?Mi9QelhJc3ZiNU5ubTNRL29yR3BkS3hMdWRuVFg4aHkvU1hTblFpVU1lWFEw?=
 =?utf-8?B?UkZGeE52Rk8wM1RtdjJIQ3U1Zm8xTlRwVndVbVZxdnlSLzdPSHVTR3IwM3ZG?=
 =?utf-8?B?S292WHd5eUh6MnRHOGpFRzVLSjI3VWl5UTRQdHQxaGlGUnN0RzhWOGJpKzZU?=
 =?utf-8?B?T3Z2VVhsVzg1WHVnUG51RmRYNnFzYjRtU0pMdGlNNDVKWVNzL2Q5QmFOeDR0?=
 =?utf-8?B?WU51c3BubE1DdzdsVjBtTkRrblpKWis2YUZwQzlMc29JOFljUkJUeUdlaC9W?=
 =?utf-8?B?clRpM25qSzMycVUySExBV2hEdHMwWElhMXdISzg0T0JJUUJaclV4SHVuN1p4?=
 =?utf-8?B?VGpBdEJmcWxTanFhY2p0WEh6cTNEOVdFNkR0bG5IOU1JY3VrVVl4dDk4UHNy?=
 =?utf-8?B?WUx1WU5vaFA0UkM4Tm1KUDUvV3I5UnBwQkhndU5MWDQrMk1nRWZTK3hDQlQw?=
 =?utf-8?B?blhsUm91U1A1WHNnSFdDckhneVBFOGVBa0h3dXhWbzNka1QrVEtlTDA3eis0?=
 =?utf-8?B?ZGM4d1Z3L2ZLZSt4UWdtOERIS2FSYWxrcVBuVXIxZUt0TDVyUTRWbEpYcHdJ?=
 =?utf-8?B?MzBwTEszZU1jUHpFMm5GZExxY09aTitXYlQyeFlRcXRpZWdXZzVob09zVU0v?=
 =?utf-8?B?Nkd1aUg1cnNiUWtzVXEvR0Z6WnBnL0VLSXZhTUQwUk1LaXhZdk9XKzBNWXFS?=
 =?utf-8?B?aFNDajVEN3NvQjVySjRVdXo3WUhHOFNRRmJ6K3NDUUxNb0x1Y3BXbmsvbENP?=
 =?utf-8?B?d1J3VjNKdVdiNjFHamRxNmZTUzVGZlFpeU9jWlFkcjFDdFF0Q1BiUXc0dU5k?=
 =?utf-8?B?ZlExeFRFLzd4UTJNcU44cVJzYXZQSzZtWEp6c3ZZQ1JzQ3IwMGtPaFlCOCtS?=
 =?utf-8?B?UXlUNnhTbXBlcExqRUZCTkhpcEVSWlB6eGZmOGhUSU9LWlczUmNWeVdYdDh4?=
 =?utf-8?B?UFBCY2xhb1l6S0ZWbUpWOExoR1VOOG93eUJjSCtyQnR2Z2R5TXhld0NJZE1Y?=
 =?utf-8?B?cFQrN0lXNUJpbmtMaU5IR1NxMWxtMWZ5OVZ6QUd2d2lNYTFHaEpuTC96ZXFw?=
 =?utf-8?B?QmF1VG8xdG9sb1lMa0V0SHhBeXY2L2svdjBTam9BdDdRdzdNKzdjMjdEdzd0?=
 =?utf-8?B?MTZPY3pKN3FKMmxKZDJHaE83MURZTCtYVWV4WmhuUmhvUkhrNWR3T2VWd1V2?=
 =?utf-8?B?YXN4bmY0dHNUbTFKVHdGakN4ckZCL2Q2TzJSUUpMVDlNSEZwTkNOYkUxRU5n?=
 =?utf-8?B?N082REFKNlZlbmN2cUtWMjRQc1hwRHdXSC9HOWhTZEhIVm1IQ0F4RURCdEpD?=
 =?utf-8?B?L21lZnMyQ3pTZWUyd3JDNU1udWNYMnJXcEpxZEVERHhxdE1lRXpGSmtlSzRz?=
 =?utf-8?B?NVV1NVFjRGtvbEI2ajdYMWR3SFZZdVZCRUljWWo4YTIrcWJHNm9yNkZQMENE?=
 =?utf-8?B?TXRzQUZCNXAyRjJJMHFwNUZiRHJhWGJkRHFmTFNPSVdiV2JJWUxFa3RQU2FU?=
 =?utf-8?B?K2xOaHduMEtySzJPeFljQkZlWU5CczJJZ3p0WVNCSFM4WUc3c0pTK2N2M3cv?=
 =?utf-8?B?MVJOUjEyd3NmR0FjckVvaVEyMXRnMWo1QTBZdHVlTzNvNitoekxsVCtQaXdF?=
 =?utf-8?Q?bI8thDsgP5xMFETHDNdjx0yuG?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	uTvCylJPAkzIYpOMb5lPHdSjLUiWzoBjNz+fxFEuSYa3If3Eax0d6W/U5VkTSYDAeuNOyxwaA7zscIpN1WYNMH30hxhgXCpd+sX9r9dnmhOXwjd2rZA4pEjc5rR5gHHG9ZtjxDNxR1ZtctNwCENcRsWk+kXU7ezXLIARn9beEJwNGj9mXS9/kCEu5tAkQcA1Xey7Bq2eKJYeRCC8boP8/DpjMBcqpGpmNqLFxVJe8DW1kuPdCxnRTzdLhtQjOctTC8JfeiNZK6jAq6yVQag7RKeL2CJIxDbG6GmWIvl/EqedcJGQ9fj6BrXp/9lnULJ8p+BiXWyz2MyWbESGx0yKPdpsz84eTPf0fTNqIDIVERfzt5CQNgDu04RShnVV9IN71TZJawUYGON3kNKh+2a6tPeOQ7vEnEl0J6yZXqBEjPFi/MPi3AD1CxclwNXueg1c0BLGDAcDRl5cagXVhgoLDju8fvvs266TEekcJAMgTKyUll2g4+JfawtqK1vRyqasQNtLPWxm2I7UmkwZ/QqrncYxdPWuZgHO0n2pA5h89GT+ilKIkVXMlEZBoy46nVk/CHx5cVS70UjwVhOHePqdRJ4hranksxKTmV/NEEC2PQM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c3fe52-b983-49d6-aabf-08dc5476dd42
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 07:14:27.7085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aub3qfelobV4xgz5E/9FJ9cubjtoimtXuppx8P9R/ays8t8VbCzEC4VkvgoCt17VFKlUrLdGNOEjDFkMyPKcOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-04_02,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404040047
X-Proofpoint-GUID: aGDqyWNbwQ2RPJn1-7rUvZQYOb58ZuLR
X-Proofpoint-ORIG-GUID: aGDqyWNbwQ2RPJn1-7rUvZQYOb58ZuLR

On 03/04/2024 13:51, Christoph Hellwig wrote:
> On Wed, Apr 03, 2024 at 08:38:42AM +0100, John Garry wrote:
>>> + */
>>> +static inline void queue_limits_cancel_update(struct request_queue *q)
>>
>> Just curious, why no __releases() annotation, like what we have in
>> queue_limits_commit_update()?
> 
> Mostly because sparse doesn't seem to actually need it on inline
> functins.  At least I don't seem to get a sparse warning without it.

JFYI, I am noticing this on v6.9-rc2 with vanilla defconfig:

john@localhost:~/mnt_sda4/john/linux> make C=1 block/blk-settings.o
  UPD     include/config/kernel.release
  UPD     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
  INSTALL libsubcmd_headers
  CC      block/blk-settings.o
  CHECK   block/blk-settings.c
block/blk-settings.c:263:9: warning: context imbalance in
'queue_limits_commit_update' - wrong count at exit
john@localhost:~/mnt_sda4/john/linux>

Is that a known issue?
> 

