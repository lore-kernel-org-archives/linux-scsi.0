Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E05D737;
	Wed,  3 Apr 2024 07:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712129991; cv=fail; b=fjjhfDPLBWtyxG9Lg7yutWDmbRHTmIeIlEYZWyJKpXie8FQWfvyVH8FrRmEifB11k3+iu5166uBY8YZN8S7pKQlGNCT75IeZhLThkmJI1W06/ek6R1bXbqR81daP+xoW95tbARf9RbLWqRtU6DBRJkN081nxvd/w9lD64NQvcNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712129991; c=relaxed/simple;
	bh=dWyaaDZ+agVi+YKcS+jW7w/LB4QsEmKjxW67bi/5lfU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XwHM08FD8tzw6BrRRDbUZFbZKRWumtdCHpeHFxAxK0EH8zgUN3YGMaq6I2KnA9zh5hfPJwFfAqIs1PuuYgSrBvwTpPQuEDwInB+N0y5PTW6TU2thMFOl1Ao+G0mzyzcF1P46y7FdK77erZBHk2r4KwCZUJgq4lsRzUbRFbWoBTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lTE+GRGv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a13Nt/0+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lTE+GRGv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a13Nt/0+"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4334pSrQ024855;
	Wed, 3 Apr 2024 07:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ZPqzJZOnuq2QNb4pBTUI0yQNszq+Lho9zYhbA12KAYQ=;
 b=lTE+GRGvNoC58aXTVu/z7Jm+2HfaHo74SyLvlyXl84e8MN4tYwvoQc+p9fk6PhvK4dE6
 S5lu0flHBShIk7ualNQp4nuzZiEOzAp8BYJ88+/MG0MePky0jOMQGGOS9DKPWHAJ+nqP
 hMV9KzJYB85qEVcd5XnQcFVtO20/x/6Kza0gk+HV4xiowVCn5Rw0/wz72vxhQCzrX6by
 ZMJrxZGiMarYkQdyy/Ays87sdAtPohf5YE2agEHgEn31VAR1s0O1qxDWeYXj7mKEufj9
 KVGCEwBhLk+ZXxGaPyls7rXWOCalT1+SDOAloXnFn+AGfUKWMwyCRc+7Ev4CqhiuP3vk tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x69ncpgqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 07:38:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43371O68007138;
	Wed, 3 Apr 2024 07:38:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x6968671t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 07:38:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaBjBkv4S8HA97pAVdUW62KrxByDREwbZuA/9Svxh41wQln7kIihajbxM/AiCal/e0kQOOblF2ZnjQelMWWHhca+bKwPu2lWFoqTY8u4Oo8JJLJ79phuil/uxxfqc5/pqN9f8tBnP9Qbx6Lqix5PLB/se0y1qK8TIjvFly3FIHz9ZTmj1+vzkCY6SCfgwzEmEMkcvt9gVRsMRbFwWWpbPfk+YNBNg2FQ6tzlgE7+UHPSXENSN5sqe1Dry/FuKDWC1V++u9Tim3PBapdW9ZjyptpX6igcdV3ubr+ZIIfTscxbxSkniFukDxZeB7ld7ml2pybSM9QT3FfsSFZGeZQS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPqzJZOnuq2QNb4pBTUI0yQNszq+Lho9zYhbA12KAYQ=;
 b=FYNY1r/6StWVgAAOjyu+pE7LVMxafOlMU5SbZ7IywquLVurlT8E80FByake0vKrejoP7499L12ffUqCZ7bMqenqKiMXkP5O5AFIvbtLQLYCaVPAGtdCZjeV+mgzBrBaOb6iMiZtFW8zPBlr6RW3wD41irKHEZArekmYvD0QuKq0AyrmAw8S3BPgoU63HX9++WS4eup+nPVCNwG2WfdFXLluf3E7nVwbnWO4FLW5SMenvHD7wUGRcXtPAqYpaZjKYi+de48EtDspG21qCvXrspaVI4YnD5wmiqJNXEb8uo4d3nelsYSTRy+KKmqlgXfy3RHnal5czrMtPEYFqUmjK2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPqzJZOnuq2QNb4pBTUI0yQNszq+Lho9zYhbA12KAYQ=;
 b=a13Nt/0+MsfqPhHcOsOAdMlqZk4HGTLqcRjZ9mATAFGcbdVsNBmrthpIlf0CPVUQ8m6qivUBR1cnVk7avDYQ0nGIVw9xRSy1BJJuqiVdMqo4i4DVmj/CxqjI7GGErOCTKy0HU/idjOSgtfqHZyN5mQUOGQe6oTcJCtqs+HPPT+0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6706.namprd10.prod.outlook.com (2603:10b6:930:92::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 07:38:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 07:38:49 +0000
Message-ID: <fd99a58b-37c4-45dd-a738-cd2b49341c70@oracle.com>
Date: Wed, 3 Apr 2024 08:38:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
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
References: <20240402130645.653507-1-hch@lst.de>
 <20240402130645.653507-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240402130645.653507-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0120.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6706:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gIe1DoJ71pd7XtD20RFqGP0sleR/dUDupLlqqay59RjsXJLJJRE0yty6UjN5Y5YfBXUzy5E3baWSjtmjW80T7CB4JCZFrYR749bdsPsdQN2lyvHguEsVVQz/oGlxrifCAzCxJ9XXtqqBJCE3ASF91obAJ126uwldHAYmTX6cng5SnkYEuHktxONuTihNDtYBIc+6+lTbocDNWNlP/P7g9Vnq07cQNDxDY27lNNGpRnFu1hpJfUtlY0Dv0F9pCcx6JaBmHXKLRZUOGeGm8M/YEvnUba/mzYfVaSSe0YU9p6NtkdIi2h0l3hkb1vucO+HBx+lCzMa240O/rYvc1Jn92D2YeT9UXro4zHU1ncTig8eeUVjGCGGfB2ywLhsbeouMuqG1UHhxDeybqGZPZI2CNAZq21/NOrA+HF8DQY38H5B6Slcpm2AmZB7ptJARMqxNPD/SzqmfPx4X/El9EDXxzg/lcGi2IjO1K/7E09fQvlXZenIAt/FU0hO7/JmcMKpqJ65WEgdejrrtd7xnTzxyOHNJrKLCMkzNWHYpVVWFb+2nlWPRXZlt5DsyWUWfWrKk1Rc3G9Jh/6J0POb7RqPJoEteuNdf74W7HPvMGVjhi6oP5/lNTgWS82EA4wqa7qe8RjlvD/lYiJlrmQxuiVfPQLRowAQk4c9LN16wUo5Jv2I=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Tzh1UEwwZHhQT2pEdUoxMGMvYnNYTDUwNjhMbDg3dzRKbTV2eUtUQW43Mkto?=
 =?utf-8?B?QmFIM3VWY1BNSGt6UzFnZFF4blI2dzAwYVRvcU9ONXNZVm13M2thb3BEWERz?=
 =?utf-8?B?VVMvWDh0OWdKaVQ1OG5JNVV0cHc1a1NvQS9XOVRlaE1RMVc5c1lra1VORHdB?=
 =?utf-8?B?VjNEeUZXNHdvOTREcGI1SzVrcXNEbmE1QTZnaEpvRTFIY2szUFI0cDQ0NFRh?=
 =?utf-8?B?Q0ZWTnFoa1lOeG1CWU1PRXAvaTFMMjNMeFR6UmlIc2hHOE80d2xjTDRKY2FY?=
 =?utf-8?B?MUh0SUx0bkJOQjZZWFVtdHo1Y1BOSUxqTFNOQjkwWkFCMnk5eDM4VWl6N0FM?=
 =?utf-8?B?a3A4d2lBYWRHazdYU05WZjFNMThWS3ZsZFlwUU94S2gzQ21MTTdrVERwbXBC?=
 =?utf-8?B?ZjBWRWxqUWtOYkZPdkk3bEVXUkNEMG0ybFY5OUVmNWkrMkE5cGszaWdzM2RP?=
 =?utf-8?B?bnRwcWkvODk1WFZkQ2NVVE8veHZ4K3Vvejd3K09qZTgzd0Q4ZGdRSWFvNkxl?=
 =?utf-8?B?Tkw1Mm5RZmtCVUVUUmMxU0dpb2xxNzBPRnIrOXB3SlJObWQvZ1ZTY0hhaEY5?=
 =?utf-8?B?cmFYQ2VwYWV4cGowV1FhNkVZNXdMWk9Ba3JEVlp6Q3lkald4ZC9BQy9xdGdY?=
 =?utf-8?B?OHhITXVDaVpDcGhndENlKzRKRzY3YzRwUW1kMnJmMjJ5b0hVV0ZENmloTDF0?=
 =?utf-8?B?TG9tSGQyeExSeXBha0dibkYvTWw5dnc1eVJOZnVnMEd1ZEhHTDdQQllVYVZW?=
 =?utf-8?B?MWFwS3o1SDFWbE9ySXVobnVjTEdXN1JsNHBxVEwwZVJLREFxR0dWTS95cU5B?=
 =?utf-8?B?VmQ0bCs5U1lzZXVsTERrTjc5dzcvSVZIcFFYaTZUTmhudlBjU2FnWnB1NXJz?=
 =?utf-8?B?U1dNRU9obmEveEdxOGNqOWNhQk5VaXFhNFUzZHVwaUdOMXlmbGsyb3pzaUd3?=
 =?utf-8?B?UXRtYjNqQmFEa3hqRkgrZlh1ZWk5cXkyKytFYk5uQXNFR2lwRjJnSDhqcFBU?=
 =?utf-8?B?M3IvN256YVAwRGl4bTladDYwd3pzdytXUldneU9nV1Avb1dGUzRDMytudVVT?=
 =?utf-8?B?WHV5cnRmaFNRMHNXb0pVYWpoTXRVRzJvN3IrY0Y3Y0w5LzQxR1BIODFYRWxU?=
 =?utf-8?B?SHh0VWJES1N2ZkhUSytEc3pMSXQ4Sjl1MzMyK0RxOUozMDRQQy9SVFpQSFRi?=
 =?utf-8?B?a3M0akxoZjlwU2szL2g4NnJTUjUxcHNPWjNndERmZi9DakhPMDRUNTFVRktZ?=
 =?utf-8?B?SDVMaTR1Vk82Q2s1dFM5ZjF0bXN5NkxTUmxzaXRFNko0dkg1bzRSY21MZGVl?=
 =?utf-8?B?Rk9TQWg2UzFRTDJ2amZ1ZEk3aTB1NC9oaEZiTTJoUFcwUUlkdVM4RCsxb2dx?=
 =?utf-8?B?UVlvVWY0ZWFqUVBjUTV6WnRpazc0Q0EyTW9pUnUrc2JETjNWTS9wU0FFdTFZ?=
 =?utf-8?B?bHQzTXdRMHBPQzhaRUJZeHRsUThRbi9MU3RBV1Q0eHpSS1lTeXdqU1hsbzNk?=
 =?utf-8?B?dnRKeUIyRFpOZHBSd0l3TWdDd0JQVk1WelJINTVLOW55TjlHV1ZLNG1Ha2t4?=
 =?utf-8?B?SzRoSnBGWmpvUm5QdXpzeDRqdExMcklOeFQySXN0OG41TWowT2tZdzE0bjNE?=
 =?utf-8?B?YlV4NGlvWDQ4RVJ6NHBtR3lGbWRtZDhxZDcybWVkZ3F6T3NVdk5BSmp0QjJy?=
 =?utf-8?B?MXNUczNmVlR3MUhPUEJ4VENKNUlDQSs0TTNqd2JQMEFia1JGb0E4VThsS0dy?=
 =?utf-8?B?TUZxYm9ra3c5d1hLM0hDQzNuY2d2NklueWE4TjNDRW9GQjUrbWRMWVc5SzQ0?=
 =?utf-8?B?MmRjdUxjZXkxTW9OUjBpT3NlcDcwblY3ZlJUNWNrdWg2cGVhVG12MnZtVmtK?=
 =?utf-8?B?MXljN3FVYjdyWlhsREZJS2VNdGpYRUxFWTJMazRYY0RFUXlwdHhHWW1qejlq?=
 =?utf-8?B?YXhOUHNwc3hibTdoOWtDNkVzckJibzRaQTJxSTA3R24yclRMM3hDM2tRUlRi?=
 =?utf-8?B?azRnaHpTL0ZDMXVMY1NSYXdXZG1ZZTh5TjRFVkorNnpSU2t4bWVrSHU2cUN2?=
 =?utf-8?B?eER1ZDJIQVdnamNWOEsxZEtsSmhjV3dMUTgwWFRCRjkzVHkveEM4akVLWElX?=
 =?utf-8?Q?q8lW+GsDtl+/yrfxAKAym2hoB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZhqnB0XSLscIMRlkuG07aivicyLDuHW8nDgrHB19PNAq/h0z8i1gHjoXad1ZqrOjJNdVUZ46P3PgseuKOviV3QCTE21CA2No5fqAGoLvTf282BlN+4nlvpjYgfEJjMwGalqy+FGG+5Ji3sj7Zf1jLLr7kdXjmzzOSQjAqyRHRGkSyMRSVFD+942rKZ2+RUOr3kT7/1nyyCgm38VD/6+7w03PuSlGgIRQvYPIKKeYMX8+dfjvhcgQ2jbayDz3K6QcFkgBfXxDfYENR5UfaLJyGAGUDdcr0Dfj4iEIdNFyopFfkHxmAtQuiVwvNDt1pcBPhusR2dsR+RWKeFcN4NdSqZjJLnCzbX5CuJrvhF6JHnnwkYR67tllb+1QZVhFfOUB1hAlD9AWMDa0Bpw1Dvr4PZDGQAZTIGR0jOne6r8nVlvjGs3gh7B31UyVUdn4N9iffsXLB4WcNWg2CInP9XLmiC5QGyOG7Y8xPhDoqbr2RpRbzuAtKTWbeTyhgpSHH5rqL1b5Fl4Lv7DBkBobr6rTyXJSw68g+fjazILX9oLIXDDC05E2Uab20zazPHFMh498oQbuhWow7xJIUA2FZkzn8zIBLFi1KrdMVhWS1VeXvaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af70410b-6bf7-417a-1e87-08dc53b11a2e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 07:38:49.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWVZx1FtANzoX/yQcBuPLJcqKkahXi6EKwqOIabhUFlHgs4FiF0aTmePengz/ikezjdAs8OrFZSzWni/6L9GSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-03_06,2024-04-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404030051
X-Proofpoint-GUID: ebuKG2HGVHhqQqfRgRcMV8p5lrdt-qD0
X-Proofpoint-ORIG-GUID: ebuKG2HGVHhqQqfRgRcMV8p5lrdt-qD0

On 02/04/2024 14:06, Christoph Hellwig wrote:
> Drivers might have to perform complex actions to determine queue limits,
> and those might fail.  Add a helper to cancel a queue limit update
> that can be called in those cases.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/linux/blkdev.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c3e8f7cf96be9e..ded7f66dc4b964 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -892,6 +892,19 @@ int queue_limits_commit_update(struct request_queue *q,
>   		struct queue_limits *lim);
>   int queue_limits_set(struct request_queue *q, struct queue_limits *lim);
>   
> +/**
> + * queue_limits_cancel_update - cancel an atomic update of queue limits
> + * @q:		queue to update
> + *
> + * This functions cancels an atomic update of the queue limits started by
> + * queue_limits_start_update() and should be used when an error occurs after
> + * starting update.
> + */
> +static inline void queue_limits_cancel_update(struct request_queue *q)

Just curious, why no __releases() annotation, like what we have in 
queue_limits_commit_update()?

> +{
> +	mutex_unlock(&q->limits_lock);
> +}
> +
>   /*
>    * Access functions for manipulating queue properties
>    */

