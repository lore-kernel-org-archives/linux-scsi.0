Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B5A1DFCB;
	Thu, 28 Mar 2024 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711620179; cv=fail; b=VhOzxosEn5YEo+4EdVaWEUsb9kssAM3kvx1F/i1UTcfJhRxPvub9AjeCsasZsOyzQh688nytxZy29zgc7Xj1qGqQqLtbFh7ZjaRXfwNjFTUmRRB/9jaI6XtFVFw14gYtUBj11G2fYFxTZMTbWoy+UkiDeGNiChRmBLoxdVdvNKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711620179; c=relaxed/simple;
	bh=IXLwB2c5LeFdUNL27Bdqb9Afo0PYQXFCWO4SPHc99EA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iu3d4N3jGsNQ50H1N8gEykoNNXwFnMxWQZTnD3HY9LD7jHViA189ak6ONX4Bj9Qrdypc777sK7EU2MeqoxTKmvNB1IsCy99jlLQWV1cuLM6BVK5hHKOxAneRRYzLVH5ks2KrHYc9WCBBo5YK461dWGEmCtiFTMvZwlwLD5d+tb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=odCyzP0d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l9cKtHxw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="odCyzP0d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l9cKtHxw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42S8xENh008039;
	Thu, 28 Mar 2024 10:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Db5uT61Fljz3i3wYZ16ienrG2TnFQy1RbaZ2Zls2TLg=;
 b=odCyzP0dQ6MCkXyppcxUaC28rP51aJkcaHwlZcREwGU+GLCOaXHPo7Fg04FHUW3z0e1E
 Q5jpZK86SDGYIK3Ed+Asfzl2N1Qo/04+pUHglKzZ9+tbnhQ7saupMfINAJ6pDtTB/njz
 KjSvEzxFW4FAcW0JDi9+EoNpprehQ2QCGTRyF3+npItn30JJA66aVkFaEVpuwtPQTJQ3
 eyRq/3WMhQP+YDJCiPjCXzd8OmBjEYw+q9xYNKKAwhK4m75apB2jFR52594dJZMSLOL8
 qDT1e/mhZ3sbcUDZsJi6y2uIj9ILRtOSdAtBYdb5IMszx0+GQqyA510FQkNI3/TFYy3w wA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h84sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 10:01:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42S95J4E014352;
	Thu, 28 Mar 2024 10:01:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh9smx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 10:01:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnQubbB5mFnP5tKggXwFg9fk1FKIlHy6WHoOTbM4rChysJe4I356NFS8SwoqWNDoBDcd8PDJ/2ECFuipE59ZtX0QQ41N6qgtr3F7BKKHXWtpi4RP1QZmxa1q07RxiDnTQWsLWlPhtC9rLBKwBGGOLIwUQvScyz/3M17lsiF9UntrM1G8a0UMQybRORB4RPGTAVZxgNN0RctA+te1xNoFIcBICT1rrsu/xr37oYIMn2nRRCJU9+1qSoU7dTrBy9Dl6TY/RRkd6qAoM+ZvtF9GZW6EnWrAO4mxiY0rQ7KOIYixpH5N4gdDT5svwL/OVfBgt9H8FlDmxfbkmatvE4Ncpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Db5uT61Fljz3i3wYZ16ienrG2TnFQy1RbaZ2Zls2TLg=;
 b=iRrEOdkPADqiNTgHc8HFURBPTG+P5kSam2N8jdgP3jGs7+S+N6B7dklW6WKhNGjUIFhdsKkp7kTACVE4qFChvO4W0JfQaB2iJHRt6EaJwnrGcj2O+C8AIMaSC8bvIR3DYlcoq6542IwpQXVJFCcT5NiLNOtHqm19MyFcab8AxAFUsHRsVKCi/F6Z1Wm76AWqsJTHu8udLWuoAHW7+26K8/rbl7NW9C2N7ledY/QgmULYMFAJe6u2CY2sZsENpuL6n5RYYMz6gS9wxQywfKKUytqH9/hUu4ntFXVCWF2RPYD5seFeIbH3mQqw6xAfDAQn4XtNRb8NN7gHe2tlRtFa2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Db5uT61Fljz3i3wYZ16ienrG2TnFQy1RbaZ2Zls2TLg=;
 b=l9cKtHxw+RGnRevEHCbU/HOgguVG7R+rsMCff01XavgP2LefUR2sR4GsUFnBLiXx8j5WJ7L4zgDuY80wX+Z7SewHBQIxatgmbyL+Mlx9reogNRKCvxPbp1LnDeF6TQYHo6X+SxHy9HJaIALhy2lmGqXy7Bdxpbcg6tEL69HPqeI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6244.namprd10.prod.outlook.com (2603:10b6:208:3a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 10:01:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 10:01:37 +0000
Message-ID: <ff54300a-b906-4884-a669-3dcb2912ae0b@oracle.com>
Date: Thu, 28 Mar 2024 10:01:30 +0000
User-Agent: Mozilla Thunderbird
Subject: Re : [PATCH 20/23] libata: switch to using ->device_configure
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
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
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-21-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-21-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0136.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::28) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6244:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e78e90-76ff-4fba-e9da-08dc4f0e0eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rsAaMKfRgvdlCM7EIoTSjkCpNLP2/MMljpW2rHbLXVqbWUj9ibF/Yc6d7AyyWBA6xuL2qBlgTOC7xqx51a+xWjo5m+GYi0Hq8KpIoH5ZhHj+oPGvqUDTW6feNh1CNmROaLjD3cpL/AjHz954USuMw4++U4AKzKHxw5YwgnW+grB9hfQsRcmdPKvJP0FJHvfLjpI7XKWh+CVv09f/h6N7M65EJAfjBzEjchecWyih+LWPNt6bFflldCi/ZfjQPGE2223Rme/JvOjI5UDaIQB81k16kzKxXU8UXGaDfqoUzl5h9fYLfUzdWzGADRzML8qVk9VA5mGJcrm705L4+DfYgMcF4i2PkRMLQ6x7L1MnrCx6GdffnMYukC0aG2EB2XgcIQ6vWVVbbk+0KaJHtImc8WHeusEOf18o1Ihb6y604X4azHM2pk/jIVOzMQ1/vZJhqA/a4rgl1UmD4xTI9IppX9Zn1FgagSgNugYFRKvmrBrE07eDpRWoL90VRAg4+d2vuDmfAMBAGrvts++qNQ9CX2TB7qKArSta8FK50hh0bJUO6AjCv6JXYaXGi0vQEvF3O2IEI/m+Yff8VlAvGrwUjwq3hPVevdq1GZTRTEY8WjWmArejQhUq7LvVxj38pW78nu8zx+oWc/VX9sd0GjbpFnMefVlb0Erq0MbCjTm12S0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MmI2QjdkNFIxZkdYdnhjWWZ0bkxCQmJjMGEvRHhTSFA2R1RJWnA0cDRiV3pV?=
 =?utf-8?B?MDROdzhCL2prOGczUE5sQ2J6bnhmcUs1cVErb2V2NzhXNWdpOTU2REFsNnBu?=
 =?utf-8?B?NUNaODhZY21iMzVMMENlYmVic0c1a3JTWEpLYnlHd0h4SUpSdGJEV01TNlpH?=
 =?utf-8?B?ZGdaR0N4UHJRVGVXenRyMHN6UUxyWWVLdXVyL25idkdkUHdYNW5CMjRWTEY2?=
 =?utf-8?B?eEtnWXRNdzdrWlowU01mNC8zRFY0dDFkWmZkYXNyM2tpWEQxWStGTGpPd1Ny?=
 =?utf-8?B?TDd1Ly8yY0pLaTdBWmFrVExXNVN3UklYN1FpYVNxWnU5UGg5T0FQVmVldGli?=
 =?utf-8?B?Y1M1MWd2clZOYVZJNDluUU1wc0Z1dncwVlVqM0RUaTYwQkxxbnJRbzFuK2pC?=
 =?utf-8?B?QlNvWEIzdW93bnZWNnFaQWRuTWRyVTQ1OEFkMkRrWU1wZG1kNS9MT291VjZh?=
 =?utf-8?B?ekxwWUYrazMrT2tDdWZRdlY5MjBxenN6QjRsMHFFUDNqR2wvN3hxYUlVQXFW?=
 =?utf-8?B?ZU8wSHBVb2VmQXdlVGxwT1ZRQmM2c1pTa3hKNlBYR25hZlZMMkQ2dWNpaXJs?=
 =?utf-8?B?V1BFMmZtS2htK3M3ME5na3A1NCtDTmhRUnEvOENiVEk1alpibWRDQUZHKy83?=
 =?utf-8?B?aGZXL09rNFdKSkVRSGQ1RG84bnppeWc4L0tRZERWSzdYRktLeE8vbWNpakVu?=
 =?utf-8?B?Q1ZQd1BmNUlzYW80TmhwMTBoN3NZWlNjb3FDQ2RUeHU2YzNnRDNJV0lCV0pp?=
 =?utf-8?B?OVNPTFp1aXFybFhEK0p6ZHhMUkpBT21BWjRGKzV2N0xDS2RReW4yMm43Vmg0?=
 =?utf-8?B?dGY5NkxJZGUycnV6clVRTXpudHNQY0t3K1VrU3dmTEJPRk5BRmJXOEhMWUZy?=
 =?utf-8?B?OTZSTlcyWHZCeDhIU0tnNklIbG5CVWlxdnJsRkp4NXJuV0pDeGpTbUhmWVQ5?=
 =?utf-8?B?Z0ZuMDl4UitDM3BmeG5zcnEyRDIxZFlaU0hJVXhVZ1loZTdoV3ZvYTZPbW1N?=
 =?utf-8?B?VGw4cGRxZkFwQjl1NnlTY2xTV0xKTEhJNnVYOG9RaFRqcEFHaVU5VUM4b2xC?=
 =?utf-8?B?MTdzbTBJb3lEREIvNmxOWW5aVGI4WDF5MitKb0plQUErTy9iZmZIb3Q3K2lC?=
 =?utf-8?B?dkxobFpyWGRseXJhajlLbDlJTTZXZ1R2NjkyN3RpcmQweVFPQXR6WmwxcklB?=
 =?utf-8?B?WWp0cDBBY0pUZWg0UkU0WGZndDVIdi84bTBHRHlTVXdDKys2UUlBS012enVv?=
 =?utf-8?B?enAyYnZuMHZNRGREVUlCMlkyUnVjeTJydFFFNTJ4QmVaWEg0Y1dKRHBEK0lw?=
 =?utf-8?B?Y2pxeisyWWJxb0VQdDkySlVaZGxYQVVJMXpCL1pQOVI3NmxXUkk5WEdPWk54?=
 =?utf-8?B?ajl1NjdBWmpBMXVWdUIwSVArYXEvbEtLeXN4WUFoOW55a1VJTXlLeURCQlJG?=
 =?utf-8?B?R2JENlpTeURoRVJIdElYbEhPRUlaUXVYQ1pZL0hXWE9HanAwdjBIODU3YUhO?=
 =?utf-8?B?Y3NBZ2JSeUpWYzZIZFRhUVhhL25hVDh2ajdqVXUvZTBhUE92R2pYSm9XNzlu?=
 =?utf-8?B?cW52QlVhamg2VXJPVWQrekx3c0o1MjZtdk9ja2xnbG5CUUZsaDNaTDBJd0o0?=
 =?utf-8?B?TU5ZMlEzWGw2S1hDQ2Nub1U2RWx1RXp3bVZkM2x3TnBEMzlJcGQ4VzJGVG85?=
 =?utf-8?B?WjFOUGtDMVlyUE9vcUNLTUQvdHpBYUVLUzVIdmJFVUFqRFh0Y0JZUWFwMWhh?=
 =?utf-8?B?ZGF2U2JWb2JtYit4MkFKVFdZUXRaMHI1M00zMkVTdXNLY2JjbkhaaklSMkxn?=
 =?utf-8?B?dEQ3MnFobjU0N2FCWmNxMHEwNmxQbU5aN1FZTWVXL1dqRklreWhGcW9OL3BK?=
 =?utf-8?B?Nk5VQVNPRlQ3bVdEdGNIQWo4UW1VM2tWTmI2TVFpL1FFZ2xJZmdNRnEraFhi?=
 =?utf-8?B?WDlaN292bHN2OXowVTQzSkovYXVLRGFaK0d1b2xrRTFvN3BqSlBST2NYMnRN?=
 =?utf-8?B?MHpUMDhsc0d6RVd6dHpLMEsvQ1EyOUJESHNESHZ2a0w4WjdCVXdGYTdTdFlD?=
 =?utf-8?B?NnZaUkk2TEswck9yYko3dHRyRWk2OFQ2dWprNTJhL0ZiY25OOTYyZzlFOG9O?=
 =?utf-8?B?SWJPV2hBd3RTdlAyTERqaTkzM2UvQ3g1alVlOGtoUnVDTEU4MlFiamlSYkVz?=
 =?utf-8?B?VUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	t8rV7k5Arhf8E6doqvDu0fE/zXU18rzeWyWhB902cG/wyb7wN5pm8Bz55+yzUko470iZjW0d8Sl4dZe0So2THCugrZL7hIZ+P1WDy2FA/yJC+ZC0qMBAwSMjecOHJMJGDEeJbQc+JH0cB1GH08q31to7xopSmHloE3jpHBlYdMXe6d2HzC0ZcHZ/gMLnr0ZQQcWYJ89E+q6o/ph0rtVWTBg+yiqvRz9aoxvMdRsfha1+yxZA4ZouRcgPEJTTuwsLhNA/zupjpNYdkz6NFd5iYvg+yGNKeNl47AjxKM6kIGgr5C88NHHKeThgqTi5X2pTUSzpAOnnFT+QbIuD9QXRc3TyCdKhEUdJkgjT/2srvIv2pnunW7CGV1SpWAe2AGdbUfvZKfCvZiPKwkH4BqdHpHDIcaMJyJ9jkvLqHJc7/u2fkqE1ORhgq9bW7XIkG7Z9y+UsZYdS5lNYTOKCIwwOQMKo8Txb9vpjJJ1V5i8Mab2M7vFFPAY8S2HmOoL3UmaSKQOn8diXHm4fN2Lnv6SFFs+IR6I3+tLPqp0V0xDvl1PfRfc7UJ/QJaa/sXtt7kHgHWvuV1Fw+Qz86xa/yY54EJjXTiucPkYHiSxbEC+Qt80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e78e90-76ff-4fba-e9da-08dc4f0e0eae
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 10:01:37.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/0+BZUy9bNGV108TI4/Q4R7WqM8wYYheWSKvNdrxlAK3hPDAnfT8aLIPejbS9kbjLvvVfNkIrNIhXrfWvwOrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6244
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_09,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403280067
X-Proofpoint-GUID: BsLa6u9D2NvTBSGd0wLx3-4THGyg87Wt
X-Proofpoint-ORIG-GUID: BsLa6u9D2NvTBSGd0wLx3-4THGyg87Wt

On 24/03/2024 23:54, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
>   
>   extern struct ata_port_operations ahci_ops;
>   extern struct ata_port_operations ahci_platform_ops;
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 0fb1934875f208..98780d3b2f1c1a 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1170,21 +1170,23 @@ void ata_sas_tport_delete(struct ata_port *ap)
>   EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
>   
>   /**
> - *	ata_sas_slave_configure - Default slave_config routine for libata devices
> + *	ata_sas_device_configure - Default slave_config routine for libata devices

That comment about being default slave_config routine needs to be 
changed, right?

