Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E633312D776;
	Wed, 27 Mar 2024 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711552601; cv=fail; b=ISpZBLlz+z5ELZ0fBpCqTiCZbgAVIrWad6T9X5gz0PautLJ7YZ6xZR9vPVKLlu1Rq+ITUfilUZZesTv4cpM7ucZYurhVIDiVtAB+nwC1yEGrqlgN2Q84VIKAWnGVTsn1bBFcYSREvKdEUC7NMirmT0Uhaqg/K8D/GezDNc0jZZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711552601; c=relaxed/simple;
	bh=fH+PwuDwgMAo4bnqGbc4SoTz1BiXAwQO2caE97NH7Og=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xh8w/ODFvIZ68Ar8a55OPz66PlE7XyDkmwN/fGLEl3Tt3qNgzrhjeya5tt+/ERMk2e5daSQCSQrWnKAUEPjxCX37m2b0pxM5mgFGlyvBf1eEitRiHs/yYHUKjspkbvFGJ3Bfs174b0XQJp+l8ao0V06E5VyW+jF3V+7oUoZztUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=khDosMR8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jUPQ69hl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="khDosMR8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jUPQ69hl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42REitAN026477;
	Wed, 27 Mar 2024 15:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=TaZBXp00XYdfnoeopkkdGQVTG4NwwW8dMI1d7Zc/SYk=;
 b=khDosMR8ggfwlbRah+HO45Zt5l4H2dAgvk6dZKEf1yUOXYM8oHHgtW9HE522KYFuNNH1
 20IRqIipO3PTofMPzbVK0QjbELB1OgzJA0ZD4Ed/jUXYvjSJebMR+0dNCCwqyi1bZwQh
 pYkQgNrOWipuftDbXF8pXiTlM0zD9EzziTXntTOF/i/Bn7j/jNW8mi6XNFCZghFk51ir
 DWwFuuP9hcxjV6R9LnPZwUjWiG4XTWPIDVY0rjvk+ymxWXmjG+uQESye1jVfGwkjE46r
 DLBMTGYC7umHJ66CEt9YChjCc6Rd3b9WqiJCQ94h4oBwAS3WyBDsBgGGdj82ZWHv1BWh Gg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2fqrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 15:15:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42REC9Ef015028;
	Wed, 27 Mar 2024 15:15:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhewhsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 15:15:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6J0e0/4ciXBQe+WMEGGrsT0tZbYLymcRhUK8ZjjE0xHZd/JbEXcVEMiEdqfPSh+ddi/MahnaG+RItcKETwIdyq04X29KARKl9VWcAcjZ4eBy1Rk1M/PVg3lifxT83PYprPLRghc+u6h4vINx/H+M38l86gLGigJUD4zDuWYXjtjL+WL4VHNzh6YJmlXfAQ3f1czm31J7hdAKuc8NNirp71TzuF9fUv1vsnj1Fton/F5E7F14ee92uL1bF90O7ZOdNqwEWQmJKnGglYqdivqvOYaNHMPvzxhv5dMsNrwE0bhQU15yOOZaE0D6n+vzdZTSyDV5CB2Re+8TlbAtQMoWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TaZBXp00XYdfnoeopkkdGQVTG4NwwW8dMI1d7Zc/SYk=;
 b=VL48sfvrDdaGdqRWoyr7IGpIhhefJNc7Ui1vruTpptT9n3OmbKwHT6L3sm3/diFzDroAY2jDZqG0FDANB2uxAWo34CP2WmYv7S0W2eaPSn+5P+njJ+JcXSVhs5WzZWzFNVRUJLBN/vrs5rPLyGftr2T3n5Lxo/kKVEw6yIOf13aVOEouwKbQ3asDQPQGcPjNWT3nCmcd2EIxmeXj16aJLA0XNDvFEtUdUOKGolUn2YpuYhij/K3HOSzc29S3AcxFMjjSWPrH99xeJYdyK+jp59yRaceIqSTLB3DIVQmp6AZYFFzReTRpC4S3cXvFGQ0Ct1isSXB6JzLxi2GXp/2qTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaZBXp00XYdfnoeopkkdGQVTG4NwwW8dMI1d7Zc/SYk=;
 b=jUPQ69hl0F/Z0YGSJNz8pl0MRmrkerQmIvy/57RFb9mOSDfCVq+xlx4zJqMV+wYq/vwAVKJq0FulRYRn7H4prtI6hE9wzAwpl3Rwn6PHntb+rx1WxCgG7t0xhjyPaGI9SmV3xdJJKqJgHxXrs82823GmwT9rwCH7h9UwAPnx9AQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ1PR10MB5953.namprd10.prod.outlook.com (2603:10b6:a03:48c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.26; Wed, 27 Mar
 2024 15:15:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 15:15:35 +0000
Message-ID: <1137e698-4376-4dc3-9bdf-886945787486@oracle.com>
Date: Wed, 27 Mar 2024 15:15:28 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/23] scsi: add a dma_alignment field to the host and
 host template
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
 <20240324235448.2039074-8-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0212.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ1PR10MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: 29f448c9-b611-4c52-8675-08dc4e70c0bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	G7hjmgAINY/qDMXtzXqxzrQwiLAeuTqdfkfy36FpHjEDR9sPhGv2bV8Gb6LPep5KB3JEJrBN7ayGPvUqAS0UIhwlBZqtme75mhi98PyHxCGkMlz430qkgy7aseRIwsbdWnDUNhQxjhFtkS8de5//Bmb0j7k2Y/w2ffepROH7ZYuAE2amqSxW7vERCa/vXQElLnmvjC2Bn5zTJvz5aTgNPL7qKgW0C6J5MRqFwhjnMw9AAZ+uWxazqm3Pq+UYi90ygZt+0o8nHQcLNnbI+9X+ealU195A4BWo5+q7pvMjQ8C5fT/pgs+TqDAK8nwsMRpS0keP2M6yXnjWcz3Ct1kQmpVr+n1MHMcfUVOjcsXoXjS3lHZsCz+Z4ZglzYR4I0GgjBHZF1VVa/qyQ90ZguMxB+rEUMjpSNv/0AWIZ7kJE/qJTzWKNVy3LTKyCbT9u5dxkhjQmXn4sU1mQSrKDysjkAd4ah1WzLSI84zavAkG2SkLiHjVAA9JOOm9tNgTAff9/i/b3oF8gvhK5i4rMWxzxzywHNyayYaa+uQTUVWtmbrF+qlDXy4UQF+SU0YxQ6FeTk2uteUdGd6ZY+BSF+SbWHXdDne/wTvy3zg4c1RBknRPQTnospwhsoLHVWCFAY8UZAUh5CykNUY83NqcIdM2aKaaUcTccPJFBaGTh6bKRZQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NlAyVXovZ1dMK3AyaktjaGFhR0Rhdy8wazczNm5SQ0RCQ2g3aExRcEN2aCtV?=
 =?utf-8?B?OENDODFZWGkrQ2Y5d1hOUm5XUmhSNXcyd3lYenA5QS9LbTlqMit1VmN1OUxZ?=
 =?utf-8?B?RzBwcS8wQUFwZm1SOHNYRDFWNnJlakVxbG4xb211dnArYXNwam9uQmpyNjY4?=
 =?utf-8?B?Vi9zNDB1NU9naHFpcHNNNWVlUXhhRmNldXpvZlJha0l4RENnR014T01NVjlr?=
 =?utf-8?B?VFFjSmlRc1d4YkNkRGI3SDJrbDZXai9mRm5leFh3SEhwTXJmcllhQXNzM1dp?=
 =?utf-8?B?cmNyTHh5K0loOW55dFN3dStJdUg0cTlpUEttMHNxSnZ0TlY1TTREek9xalJQ?=
 =?utf-8?B?YVRoVWNHYkkwSGhzU1VoVkE0L1luRk9pb1FLRVpNU3ZzRnY0VHd4RFhUYVZr?=
 =?utf-8?B?dE01VHdPSmY2c2pENlQxSmN0QUVFK1lJWVdYZEpsMndjNFp5V3NXUjN4TDBZ?=
 =?utf-8?B?aEtiTGphbEM5SXVudkNXTXE0bEs2YXZEa3VTN1JIWEQ1YmQxNC8wUUVJVmph?=
 =?utf-8?B?NEgwWE14NkRPU1ZsSU1FQTlHN2xzSmMzMVozNmphK21IZHdpM3o3MHJBejZ2?=
 =?utf-8?B?Nlk2V0lDZFE4QzlaVktyL1JWcG4yM0pyaExkdGZwUTdEU2Z6eGN0dytHL3Jm?=
 =?utf-8?B?OGJYWEdrMXB1cTZQYmp6TGF5OHhMQ3pzU1Y0TWprRVY0ZUd4WFoweWZiV3J1?=
 =?utf-8?B?UHY4MEY3b1hJcEhKNW1XL1U0eFAzT2x2VkdHNHJTNDRTckpXZzZPU0RtTEQx?=
 =?utf-8?B?YjMzWXprWEJpbm1tZjNHVHJWWXdlOGg3dzdGVFUyV1hpdDFOMk1TbDh3b0xG?=
 =?utf-8?B?aUhseGFzdUp2c1dIY1VHcjRkajVDVlZsaHdFcG8zU2J3bGdlVHFaeUNIQjVS?=
 =?utf-8?B?TmpEMnJVYldPZlVwVlcyS28rK0J0SzhOdkxIQWp4ckJvdlZyc2NyNWVpVXZ2?=
 =?utf-8?B?UHZkNEtYMzRBT2s1L2FCTVZjdGc2TVZJRmRITUc1WlJ5aCt3T3NVMzh3N2hY?=
 =?utf-8?B?elZPMG4vUHZsNjJla1pDM2hWR2tLdjF5Q3NIK1pWODQ2K3VURStPVlltd0hz?=
 =?utf-8?B?em9OWFB2MnMrVWs0SUFVVXhSTGFxRlJJVGYzc3VCeUw1akdCSnVEaVB6Mm9R?=
 =?utf-8?B?SGhkY0haMXQ0ZFkxc2dRUURYdGN5VG9LK0Z5V0xwcTk5dXJETTRoWnkrUDcv?=
 =?utf-8?B?RXk5NTFZK2VRc2VVVEZmWFRZUUlHSS8vQXVTUlF1b2FpbDlYeDVFU2ZsSDl5?=
 =?utf-8?B?b3NJU2IxeWNVNkQxbWJLa3RoWEI0NXhCR0kwS0poWit3NkVHMkI3RHlHMjBa?=
 =?utf-8?B?czhnNGVYbi8zRXhCb2RCM21mMjJyc1kySkJKVmVaM3NHSHhDWVA3RFJ6cjVm?=
 =?utf-8?B?Z09qcDlSM1FNcyt2SnhaZWF3SnRVRUsxb1oxVHF6bzhzY0dybDlFNWVGZlZ4?=
 =?utf-8?B?d3lVb2dRNmFJTVBReXMrRU9SbXFRL3FYUFlYOEVXQW95OVZFV1FpaWpmNzhn?=
 =?utf-8?B?UEtKQTJaTTF4eUpEeG03SEpsYThoUERtOXcveWRQL2hab050Y1BZVklJeUlJ?=
 =?utf-8?B?TDVVa2lId3JkQ01ERU9hZTRyTnF1YUE5bVJkQ1R2Qk5qTkRGZGlFbmFhdXRW?=
 =?utf-8?B?eFpVS0dWYTh4d1NnVzUrOUh0MWcvNHdvTXFuRU5nMmUvQ1BscVhVTHE2ZVhn?=
 =?utf-8?B?NXhoaUI4R296NUtoSnNKdEN3aVRuaS9pQkVEU2NGMThBWWFyTlpIS3NXS0RU?=
 =?utf-8?B?TnZnMG5jTGg0V1dhN1pyYU5lMDc5Z2RqQzNMUGpRY2c1dGVtOG41ejdtbnBu?=
 =?utf-8?B?d1BGVkNJSFNBSGppb2w3aXIvN3RNdjZIbVRRYjZUNmJGWDE5TnBFY2NMU0g4?=
 =?utf-8?B?Vk9XNkk2ckprS3U5TXcvOGtJbnpLL3c4RGhIZkpPN096UkZvQ2tiMTRIY21x?=
 =?utf-8?B?czgyUWtITjMzOW1vakNtYW1DN2pJV2t4dllzaHQyQWY2T2w5dXdXeEtZMGFw?=
 =?utf-8?B?aWlwL25NN1p6cDJ1dVcrL1VJMUVrUE8zbEw1bHZSYlpFenRnYlJBVnowWnNS?=
 =?utf-8?B?NXhDbG5wSHkzWnNaTXZBc0RDWVNsNGZmeFpQR2gzWFlVVDEzSjR1MFZCWXVV?=
 =?utf-8?Q?wZRjqeCN0FOv7OUHvQQD1Avl9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	B1wRIvntXntF0JG9H8cqwKGRCIyqmjLSq5lywcF5Rswbz+xGKb871ZjllC3kL+ra01+57kvRCEJk44/z4b8shUy96IRgF0uYwsJVT/Fa8/BIRxFT+dBHrZMr8kXXJWSO8EfEGYGhY7taAoM1ISuwyRQVhP8vciqJ24Ehiq6Ml5waT3Q7Hb7JwXoiuYONqMq3qRBxMxh7Y9jZnMQBvbPn0VecFkcfgmu5ZcZ/xMvnVfd9yViNxwCyV0c59xri1UvxjQJPNlKR/M/aezMT4NHUb8SsPYUgSmSBmT9hDJAeuHDGikGnNHppQyc3ZJ9DVeDbmlTjS7PLBobCmTmerV5RirlxgayXJK5EuGSyl0PC7ENwV79K8Hrr4yajgXz52dU9Ss8KI+Rt+tZRf4fiZx7fUXGc41K2u6kzen0tu34YP6SD4+3SOEbz4EGnRT9pAIBV9R8OcY4hvFVyIn/1fKXVBooaWglrhOVpezW7u6iRCPv95+OrJ5l49xNmgYZhR6LKunxsiXD3XFD0zSxcYscCWvu1+fu8/Q7qgRnkh6/8/6vxFCr8EyzR7yciF3aTc9Lxgdg8nlvUoJiTy07VKG2mmY/ryD3hhyAgXjaaJSXeHzI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f448c9-b611-4c52-8675-08dc4e70c0bb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 15:15:35.8981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOsG3M7+eKrngpnQ/2vxcgY99maCe+FPe5+AX+2uIQXPXpuL2UkZKU39dxnxrXf7waRxUvMcF1N2HUnDrOuJ8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5953
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_12,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403270104
X-Proofpoint-GUID: pmA3ui3Szx5JpOvxqJF0Skka--To2z--
X-Proofpoint-ORIG-GUID: pmA3ui3Szx5JpOvxqJF0Skka--To2z--

On 24/03/2024 23:54, Christoph Hellwig wrote:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -943,6 +943,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>   	shost->max_id = 0;
>   	shost->max_channel = 0;
>   	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
> +	shost->dma_alignment = 0;
>   

nit: I am not sure that we really need to zero this, but it also seems 
needless for max_channel also ...
