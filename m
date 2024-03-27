Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB31012A14A;
	Wed, 27 Mar 2024 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711551414; cv=fail; b=ADsfAnG+2sKvIrZxZutJlP7iDqDqPMAc2AJ8I86Zj/11IkDeJ+Bv3z/ZaWtiwGcL5/HA2WTiudfVpGxVRaOcRy7Xh8oNkeoduXC7tU1eBryIj5fkRdM7Z36NNhpq59P4cGdUrbv9tvmcaR1hcCrPyPXh6cNPtsgcxf01qOepTAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711551414; c=relaxed/simple;
	bh=fiCjXCaZcVOxNICfS+BN4mHlZMNuCrIkYpMEuTZokvI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NfQSKQ7t2spqmQ1XHFvBt41G+5IHPEMSQH+uNe4sw90gsmMIPzVPWpiGBhLlvSMuLZd0kuSP5pOi5CfoKZBkWBvrlCgvm23XEeym25OSDh8psSZp9DiTiFBpf37CskxPnkY8idMsbKV/Bxu9nvex+vIwpRhwoKBMAtduWKlryqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Df8GHPKH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JX6sOT5H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Df8GHPKH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JX6sOT5H"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42REiWfE031987;
	Wed, 27 Mar 2024 14:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=zEhiVGntDzPU/YA/6n+Ndfvaqm2avVYTLWEHER3ErGk=;
 b=Df8GHPKHNa8Y71Q4qXT0feOQIqu1pkQ/jrkkdx6dQT2D9tmNe9Oob9HCiyXbB0HHy5PH
 wmpEZMZBlYkMf3NkZQ3NnzlvLM3e8nzQMhrS4s24diwwOIBMXRuXspxTOwyhXT+m3Kps
 SMk5DRa2Phi8CoBq70CKwDX/2DF/zmxYa0UInsWzq6lK9pqxVZvq5MzxIaryeUzBPP6+
 JRoifFz12g04C50mDyOtYZK8CUI255b0/ttRLruRXtsJZFDvtgE9gWY69vWPyrkGdwsc
 Y4nuAUWNLGfLgM7u3c0bm9ik4eFOpiMqFzYl9WmndYUCIZHhSSY+QDIcPPUnB7ga4zXC 8A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gx3me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 14:56:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42RE7Dkr014379;
	Wed, 27 Mar 2024 14:56:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh8n2yb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 14:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OobS1OH+gUHBACk9WYavDMZaaCHt+zNYNfSYxd5SKSKclvr5EjfM0UslCPqzmAqBFGGDbH/cxqR3cTU0pHAo/lHmlsstTmLxIl8Mdg2ZwiF9PJUfuSVQoChWK3gbBMVdOyiivbKhyM1D6Olw8woOOBw/LWjwRAw4d1CKL12hoWOC7juAkOBuXp8sUTMmbDKi4QczWInPxb/9xYsx1fiK0AlAN35JPKebZmotFg8/JXlQYBRAchZY+prZ0FN9l7V97lk14H5xiC3FQFiGEBOVFK88gVKx8Dnmf6rq+Q2i+JEJEs6kAwNiS43d5tdKlibPVUKgeTJO6sqzZYZdnOeDvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEhiVGntDzPU/YA/6n+Ndfvaqm2avVYTLWEHER3ErGk=;
 b=Hr42/90kQaTtjPi8qFecjTLVhbQFOvlTo6s7uJpXS2GxQvWv6PlDOccMcjhFKQMKdD3C/DT2B2zriMtv09ay4d+hCh/YmDddZV7UGzk8bK+EEB2jpXP0DCcZ9UUiM6PPoUcrdyWSnSz6bjQsRx7UC/UcwrV5yp7w0Dk7qt/ky+8Y/fNv6X3Y5/fafl6Sg6laYc9er/jUOEyzmJrFvomLwZbNkTLfvDmjgZxRD+pGikJivdwp6DB6fRtz86triGmyZGY5TxbBPRhpnup/QzCPrwT6tnlV6ngmhVLOl9OfWJ6FjqP+EIYCCSa0HNQ10zCqD6rbruEaobKmclucfLDf3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEhiVGntDzPU/YA/6n+Ndfvaqm2avVYTLWEHER3ErGk=;
 b=JX6sOT5HOWMynJo2Gs/VyrnfChBElR2Mel1UZ0IP8xae+hxXjogcr42yvLUxrGSuEFItzw1SnaPlAWbups1aPQf1b4zqC52NBMRpDBQchaaITu402GV7nWvFcm6Iot4wMWISOEP8ekxtCRkzuqFcoFIxRKM34qlzUFRA8a+4OEU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7170.namprd10.prod.outlook.com (2603:10b6:930:74::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 14:54:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 14:54:58 +0000
Message-ID: <af7cdf5e-f5b7-4de3-88ce-8147cae6cb77@oracle.com>
Date: Wed, 27 Mar 2024 14:54:51 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
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
 <20240324235448.2039074-5-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0134.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c503a9b-a7e1-4a34-b96c-08dc4e6ddf2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0D0zI42NIuz7d4VqebBSBtmv6UCUWsRnBNnA2G5Uk0CbYcR6SwGjWAwBBY69J9lWkjO1yfvmNgurLqkIU0nw54fhg02pYiKjfzCVnxZjVOsSiIxrx9iXDgbFWBiRX/O9f4GioWbQxTrdJYxuzF/UmH1iwNX7LcGAYhPDc+TKPBdweraEJtR7q18WGyM4/TpHttr7hEZbSm4D6Onc/0SXpECbPMpwHG184WWrR/5lVVvruKnRy5qHJuuEEjdMMcOR84Rey6NC+bMHdffQmbea/95lIc02RAVSL9ELj/Vvl93QhMi6/wq2z0iZISZm3hw/XPYeMr3Rc5jFv+D6rMlqZt2Ic3UXkBmJOj6L4MVvcO2AzFDIhxf/xx7TGDZ7gCgbV07G8/mupJgKUbugClu07BCfxZApq47fcn2291NTpDOOK2rG7JC/qNhoHxT5zwkqKFwyuhYrqMEehrYsDMDcfVyxTKLITVmvDV8rRgCEXun9sCN32dMkZXZcohS6okNfR+a9Iave/6J1NVLAsR7JL2vRqNKkWlfMN7bkqHE6qQaXjUJfC/oNWoHMnMwk9yrM9+Q9f2gWwJa/8rKVuXvCqJml/RR6ZPAIKC/wFfus/F/+Rin56oMC77sGNpZp3rEieiip4KcPNZxpQM0j6kkWYBuFXB2FklN0hL00dQ7m+JE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bUs3VHlrZ2pwaHdJYWpSbmx1MDhqNHoyLzZ1YVpaVHdTZXVzeHR3Qlg5MmFp?=
 =?utf-8?B?Z1pNVVZvbW1yeDlVYlZxYVZ4R2tXalV2VUxRSWZHZE9ZZjN4MzZJdGFJYlgx?=
 =?utf-8?B?MktYT1c4Vm1uVE84cHFrdFBlamtxQnB0UXdjMGUyMVpDTWxKc0dVRlUyK0Rh?=
 =?utf-8?B?WXI0RkRvQm9ZbzQ1bytzb2J0U2V4dFBONkkxSEhmSUZySHp1MkpKbVpoQ1dy?=
 =?utf-8?B?cTZLRUFuWm5FakIxRFhGTytiNXRVb3pVbXQzQjZqTTRTamZuckxIOGc2VW5E?=
 =?utf-8?B?Sm5ZS01iTUx0MDVjdGVsakVpTVZpYm5MUCtWSUI5NlB4QUtCQkdCRXFGYzJn?=
 =?utf-8?B?UnZZYlk2Y0JMd1pRb1NHcUl2UjVhV0IvN0grbTRNeW40TkQwM1AwOXU0d3Zw?=
 =?utf-8?B?UGdzTWVRNmNOSEVqZ2xxTEVIVUtvK24yVjZjWG1yb2d5WE5sUHRJVFZTZEtP?=
 =?utf-8?B?VUFlcnA5VUhlbGw0Q2hkWW9QVVNLYlJqS1d0dFE4MmxmcmdwM3NPSDltU1l6?=
 =?utf-8?B?RUYvcVFmamVHYTdTRTRJKzQ1VGVLeFhBaTM2ck1OKytXMU9ZNkh0L3E5Z0Yr?=
 =?utf-8?B?Ky9sNjVYR0FHZldZQXBWVndqUGpHcGtkU2Vjd3FLS3Zva0J5WHVXTm5sRVVU?=
 =?utf-8?B?QXRCYlZyNXVTK2VjckVIUUtjcTBzbGdNaUtTRDhaVDhNem9Wa3ZrMWRwVHNH?=
 =?utf-8?B?dUFlYlRER0RkenlRWVFuSEsybElTRjI3cEJmMks5VzE3NVg5L1U3WW53QUdY?=
 =?utf-8?B?djM1TDdvTG9qQXhlQUUzamFXVWhHQThaOG9Fb2p4Q3NPZ0NDSWpPdjlxUW1k?=
 =?utf-8?B?ZzZick5IV0xrcGFwWUEzNXZnZ2M3T25OZThIMDlLWWxIZEowNE80NExsMWJr?=
 =?utf-8?B?V1UzdVJ4QmpkZWNSODNUcFMvV0pLNGd1a1dpK2VvUkNHVEprTXdzQjlKVGty?=
 =?utf-8?B?QksybUszNmtCbVhxK2V2dmtJZmlrdko2N0ZycUVtbEYxUHhZdmVrV1J5RzNT?=
 =?utf-8?B?RHZaWjQxY1BURjNPMU41RVVVdXJNUmoydWFzTnNWN1M3WXFleVZVK0pGajVW?=
 =?utf-8?B?WlZPNlBpT2Vid3I3d2lmVlkxWDRWQTJQeGZzdmxTZlVERE1wbFl6RGc1V0t3?=
 =?utf-8?B?RDlRZWZ4ejJwenRwTGlOZTlwbjViSmc0YnJHZkh2WExxeG1qOFNKR2JwVHZz?=
 =?utf-8?B?N3M0UTJkVGFJVTZGR2g1Tm90Nm15V09BSTQ3WlBoS3k3cFgwTVAxbERMcDlS?=
 =?utf-8?B?VFlYWjRTa0hFZy82OHdBSXNPN01VaE45aXl0YTBlZGtRSmhtbXZCYlhNMmF0?=
 =?utf-8?B?QmdOMHljTlB4VEZSelhhdHd6Skg1NDJkdDJKbENOWXVsQzlvc212NG1qRzUw?=
 =?utf-8?B?RG9Ta3VkbmhWRVpxNDAra2Y4Z21tTlhqcGlyUm53anVFTGFBbzh4djFFQWIz?=
 =?utf-8?B?elUwY1dRYWkrbkNkbndOdVRwd3FrUk5EMVZ4eitXUFgxSjN4SFZmYkVuM3lz?=
 =?utf-8?B?T0dYbXlWNE9EQVdRak5WZUJkTWpPRlVBc3NwanR5Y2d3REQ1ZEtCcjJwVWxL?=
 =?utf-8?B?MmF0cm1wRi91UmFaMzV6SnNZVjdoZk1ibXdENzk5RnJsSUNGZklGVzhqQzZj?=
 =?utf-8?B?WTF2OFFpZkM1ZVlhclkvbzY2cUxHQ1BRRFMvK0poSXpUNzRENXQ3dDhsRzEr?=
 =?utf-8?B?c0dvcjZkTVRGeENBak5QWlBWeHVnME4zbW1EU1NkajBHUEJEcXJwRWtYaUk4?=
 =?utf-8?B?aTViMUZqTXVNakhQdTVweDJxbkU1cHVlZkNlRkEzbmJOS1pqZDBsQlVtRGR4?=
 =?utf-8?B?Y3pjZCt4OUxpWS9oa2hmZTFsU3lCekhXdkRramtTZmY1cFJjM0JaVWNCUkds?=
 =?utf-8?B?Yk4xWXN0Mkp0WUttVG44SXJFTWtHVk9HdEdyNCs2SkpRMi80eU9qRyt4aThQ?=
 =?utf-8?B?Z051dm8zS3JEU3BoRFl3SldyMnNaSGJJcHEyNkNnOWFzL2lNRXFJdUpscnBY?=
 =?utf-8?B?bTl0eTgrYlBQTkZMci84aEEwdkZ2SXJscWZhelFoUGNUbXNTUUJXa1ljVHhJ?=
 =?utf-8?B?MU5La0xLTlJ4c0UyNGJ5ZDV1N25nME00Vm1hdDZuWGcxbEVNRHBVU3F3T1dp?=
 =?utf-8?B?TGhrQWdjVGJEZVNFc01FUmhCdUtUQWcxeWlGK2hxdE5jazJSQkUzbU45V3Fq?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	0+prwVTx3uGXLMXFebq8MMOdNjXxAdApS3BVcZNOCCPsR9YctSrsr9jrQjxFIZMoXhhOY5d//TUYThJnRiN2Txa1yfD3a16J70zPjZeK3H/MvDLJUNhuNh8fDC9oek7cgCpBGteuu9VHwe4nzQ7TMHISaLHXU58jEMmy6eakwkt3wwv9nTj3ACLMlQzd6MiDqnPmnDtWlsTHebLSpNq2a2wMmYdxem4sUE+U14cmbuBE15fgeEw4ORdDsL3geog+bROXgQ8K5JZPBOGmnQ7jnVjezha83NZkpqs7DwiwZlFJayXq/zY4PPpwjdFBDiYYF4DLeHkVcD38vULHRV6Xq/EX1dcBqeqZgdekV7/qPKIPtS0SeiJbvrcX88hyPXfhpPaI6UuFw4O2CJ9VxJDJhJSHu+6lkF8OEXj9jQmUwbZo547SmzcNZztmsbOaZqcbACU4eqR3F09OQRgYgNct5uOJ1vUNcanLKDSdYUJj/0sxJT9uLiCK3+y59o8oeiBoxMYnk28+BCRajbkIHifjKwws5Lm9QjF8aqH0of09yJ29Bmy3/i7E2bYkMIw4li7PEWmpXJTLNndimJfWV33XqQiTBtnOgoxB2DhTjEfS5m0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c503a9b-a7e1-4a34-b96c-08dc4e6ddf2a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:54:58.4646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nedkg7fHE5D8+ydNc+CcjJt3A4a3ZRx2ckgFF2VSVDWnwBYjX7n18xq2TwRL6R31q1z6pL8zWKdIqLw2OdXIwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_12,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=972 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270102
X-Proofpoint-GUID: r75A13K8Z3gBNYGCyAfZDd4KdOyKFsuo
X-Proofpoint-ORIG-GUID: r75A13K8Z3gBNYGCyAfZDd4KdOyKFsuo

On 24/03/2024 23:54, Christoph Hellwig wrote:

- bouncing open-iscsi@googlegroups.com

> Turn __scsi_init_queue into scsi_init_limits which initializes
> queue_limits structure that can be passed to blk_mq_alloc_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

FWIW:
Reviewed-by: John Garry <john.g.garry@oracle.com>


