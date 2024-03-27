Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED79146002;
	Wed, 27 Mar 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711551894; cv=fail; b=MWcIDTJpopVRBnnLa3wA2a0ZjzqF1fxOtrT+6OnQRes+eFnHHZ+0udgd06RnUh98eIjRxGzvbpg9j3jZ0IL4vaikKjTkKEgN7lvRGy0006VyW7fFzzkoVKx8RmAdwh8tOLeIc54oh9T11c16hjXGuntkSVnu0fwMEiL5kknHzso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711551894; c=relaxed/simple;
	bh=7hO3BDh6BU45CE3x71sT4h4pEEjma19ZJjdkw08oIgU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EdwyclKfcWZwqE22hHsuudtBck+kqfp4q12Bmb9KXnH7U0cTSbETuc0PEYj5LDdc7JwcLTGIRsfSuXB3S5Wd5YCgAHgEpd5STH55scGI2KlVvRSFbets/vJjVINRqXka5IhfPA4SUcbtJEgUdfFAIUNqK0XJ+HMG0VHCdcZimS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RiMaaMd2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PyKcJOxx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RiMaaMd2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PyKcJOxx"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42REiW4E031995;
	Wed, 27 Mar 2024 15:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=oxWip4jZuLdyjcaRIJujyHV3IBkTh6OQ/mHgMlcCtB8=;
 b=RiMaaMd2g68WwVgQ4P0LqIvrpbl1HiQv84hBBRYkBQv4z5/2htF+Hg15efO5PkLLBtc0
 HG1htJB2ucss/XV7kgrbqeY8KfnMWjRIF6ALxmBUkFfV/KuQgXV5tbOr9AI8lHGe9VgA
 6A7CwviYrnjWp3dAx7p8dnFKLga+QqIJ6xM1mYfIz+Z0NhpBRc3LHYQ36J1mmQ8BD5Hs
 7wvZwrfaGzwoT+ovaH/5egxsOWlT2XwHpKwIMpqXR7DdARnbRm76FvDPfAjDpR9FN3Yy
 GKTJgMKJSHCHNA8PRyxfrC7Kmwtbow+qi95xfteiRmLOkLmg15jm4JMRQ8lUE2+x0veQ 4A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gx4em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 15:03:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42RDwMaY008820;
	Wed, 27 Mar 2024 15:03:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh8xhsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 15:03:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgpgXhSgY6PpxAg1649C8hH5u5rR1bbNvGFjIeKXaa/m9odDmtXcjQOs0ZbpGsBsNGn24BwqYjLqvx0THQHOAfyYmI2wI19Kg9zWS33Nfavxyv5kRZxJS6PjBvEsY/3CjIgvlpskG1a/GBGDhnGZ0mBaoBwKdKdfqR/fo7yIyKhtRkIIIWenZ5s9xSTk7/+aF39SSR8nqoT2q9IyxamAGNWMgQRof3sRSV8zHtvoNp8pX1As22v/+KGZ4L7pmxwNz9rO3nOX7KUZC26fc7oS6MCf/qD4uZ6haT38vXkT1CUxF40LQtzDH+u8qqbucsEhsav8UnUm0wBwAVeDZaor3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxWip4jZuLdyjcaRIJujyHV3IBkTh6OQ/mHgMlcCtB8=;
 b=D0AROCloGSMQCGSaMDbj6d2pV7GZBCbWY4cM6PMlTG81dNx27fGkTZ/FF0cav8XWJD3jJWMJYM2qrIgaXxgktAIpGoDRuUOQe+VUZvMLLiOSL8T4JHjSFT+0m6vHEf17HPChYuWa+vA9CPHFy3hRprKz4qTOAdZWCD+tZ5xkHVWKJ2D+ge4kWb8bJUaW5MjiKYMXLaFDgN+SJvy3XWiEazFKs1aFMXmNRNJL7+t5h4mpYwreBKWFXNhghe/RwTmeEtdDtbtNU5joTEY8ME4aoUtqLAdc2Xz/OHB9OrKTN0fRTExLEatcfgFQayLWyj/TMqJUd7CmQmKpRPIukWD/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxWip4jZuLdyjcaRIJujyHV3IBkTh6OQ/mHgMlcCtB8=;
 b=PyKcJOxx+2PnGuDbEZ2g9trcgzztcXiuiSTe77OOwJ77bfNVDG9pt7TT027exKcR+BIe+xEUbN0d06Rjdpz4/zQaogGKJBcGVWLzdTWoJvmChSoZl2RUB9fH6aQSQ7i+X827B6kXQFtbhhKPMkrTwaUby5ccJaY+Jdi93owW7to=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6342.namprd10.prod.outlook.com (2603:10b6:806:255::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 15:03:35 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 15:03:34 +0000
Message-ID: <07ce3ccc-6079-426b-ad80-a354105f3965@oracle.com>
Date: Wed, 27 Mar 2024 15:03:27 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
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
 <20240324235448.2039074-7-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0432.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b016268-a0ae-4c92-b331-08dc4e6f12da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1c2eGvBBN1lgfaJ4T7Xu7lP6027Qv4M6CsQiGzKVQzR5L+FugLi7VaLP3C7WNO8i0y+22QZt2rb/8B7Ne4orQMMtOyeAxrN9Bx12Zpxuo4FElrqJW8eph+TND7gE9bCaH16rh2FlSy+Kn3735ufkUPXlrPq14KHGTR64wLI7Q8UXcAoIqrvPExYHUhsq27YQn7atFw8C83YZcCn9bL2rTMb9QRt3ggqzOKBL9/MZVZCPIKy6pdZQ6tgqRlUKEe7CDjNB2k9zByYuSfVmBtEsYeFhlDND4kXxL7YF+xLRmvbgGTrTiDpr1HxH9794xEqQQsHiKyXI3hdkgu0dJ+Fotv4Cva/LS42Iv3zA4kIOwzNMY5I1cOi3bLPNbxdsWEwmofvNwrZOsqBOqeWyIf3jvm8PElQQfGipVe7YbEOJ42XSh80KiyE+y3WI7rjYnfNXs/wuow4ScI/u3/6A4ztHDNVGG555CD935h6XkJORAVhQaW9HpIAofSjslJeo6T4kVHCtO7+3vJeVjTmA8SlX4Cs4sjkOaiksGuybBCiVgypJKu3vfPNRo7CSxOmS9lywmExyiThFm0AiVsByiLFJNo7dk3237cZcBqlk/uOBVCveB64YS6dF5b0eP6IAalUHUKWFW4lUAZgIaLXMuwTfTQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R3FoVHNaSjZJZUwzSy8wdGxXNlcwNkR5MzNtVGJlZklHdXRSa0N6L0wwSVVD?=
 =?utf-8?B?UnZ3eC9hTE9INmpQOXM0N0ZubzVObHZ6NDlFYUpDd0J6K3RSYWh0ZkJxQWZ2?=
 =?utf-8?B?WFd1dXNRVW1weWIyUEdEaVlMT05wTlMvdWM1ZlRnZGVQZ0wyYUJVR2h4Y0k5?=
 =?utf-8?B?MG9FcUl1emc0SGZkeEZZVFVUaHRXdFZZWVRFK3NWT1I5OTAyR0FBZ3EvbzFU?=
 =?utf-8?B?ZlVBY2FkaU9TanBTSVE3cXNMQ3FGMEIreU9EZ3RnU0Y1YVJwVExLQWdMcjZR?=
 =?utf-8?B?WHgraHcrUllKSC9RVzRxRVpLc1dlbGtKcXB0MkJLOUNOSDhkZDVRdGZ0ZjhF?=
 =?utf-8?B?aXlTSE9FNzh4MEhTMi9oSXpFd3VMdDc1akczUm5JZDJXSEFmbEZQbElIUnQw?=
 =?utf-8?B?aFIrdWRnbFNkM2UxVWZSUzJ2eGM5dG4zTVBzRmNvNXY2ZzhHUTBucm1MWlBy?=
 =?utf-8?B?RlN2OTNqZDErdnJmNzFHNHcyenYvZ2FxK0RUUUpEVURrYVFHeVd0T1RURzdS?=
 =?utf-8?B?MTVyN245ZUIwYWFkM1k5ZmhVWGphSWhjMkNESUllMzI1UTNJbzlwMFJqRHVX?=
 =?utf-8?B?ZXE3Q0QxRjRRcEFLb1lUby9xU1pCSXVVSWdOaW5SVHVEMnM5M1V4UVVPMVh6?=
 =?utf-8?B?Y3A5YloveFk5cHdmcE9JY0Ivd0pFcENoVXY5VVZ5NGI5SlB6TFh2KzRuQXpY?=
 =?utf-8?B?b0p5S1RzT3lyMUdyMzdhQlhMV3VTenJBRlg5WU45VlBzN0MvRTRkWDJYVXlL?=
 =?utf-8?B?SnRIT0d6anAweDFaVlh0RzQ5QmJmdGlIem9kYVplUlhZMTMzWDRkeTRaM2hs?=
 =?utf-8?B?eWUwWGw0WjFtalErOE1MSTZGRUxmblM3TFZnZFhvTWRnQy93b1IzQVFXNmF4?=
 =?utf-8?B?VTdoSXBmdUJIVVBaNlNVdUphWDYwOWVJVGVLQzN1TzdGZCt1QVE5eHlLQjJ1?=
 =?utf-8?B?dHQvQ3VTQzJDOHd6NWd4bXY1bDB4ck9JRklrRkZuMmx5WnpqSkhNTDhybVhr?=
 =?utf-8?B?RzhjanJ6V0I2S0RvOWx1dzJESXMrYjV6TiszcEw5QWVRWUlrMi90Y2FlUWxl?=
 =?utf-8?B?dTlJK0xFMFFCUTJOdmI5SzU0aHhoSS8vNngvNkdnSzYyclU5OUt4WGxocnVI?=
 =?utf-8?B?VVRmR3I0eW4zdWJxQStFY3Z1VGNjU1lIdU15dlg1Tzh2TUtjb0R2ZjFlZzNw?=
 =?utf-8?B?enp1NmpQbmNOKzFFWGhjVEhKZ1paV0dkNm4xa0dHaFBrSWNHRWdFREhZUCtv?=
 =?utf-8?B?R0VnT1R0NHBKZWtPeDM4MDA0eHRTVHJVRlRsK1lGZC9FeWpMU05WcVNjTWFB?=
 =?utf-8?B?Q25JcEVaOXg1dVBraWZWVVE3L2ZZYkx6VUNTUTZMUTJCZ0E2UVhKQ3UxWS8y?=
 =?utf-8?B?YWMrT1R2NDV5Ykt2ak1TTWtVT2dFWDExSGlTc3pPT3BicUN4N2ExeDdTWWlL?=
 =?utf-8?B?bUE3UlNjTnUzZGdCL25mQXJWZWxpK254ZWIzak4xZDJUeEwxNndhdzVaUHZJ?=
 =?utf-8?B?Vm9kRmJ6czQ5bWdYaXBzVkFCRHJEenI2ZFVBMnNaVm8wSVh5Skh2aUdxMFVT?=
 =?utf-8?B?Rk4rR1kxdlE2UXFjellFVFEwYTZXYmhHUzc0dTNtbEZ2SDV5RnJ2WG1vYTdI?=
 =?utf-8?B?a1BldHk0bmNWb1AzK0pzYmx6bklsbElrUWFqR24yZmpSZ3JOcDN2UWZ4THkr?=
 =?utf-8?B?U1V6WjhEaGRLNTA5Mkl3SGVuYVAyMEZiZkxRbXNuYU5PNVF5NnJCTHI3QVBz?=
 =?utf-8?B?Mnp2bGhQS1pQTHM1NkRUOWNXQm5oTzdqck9VTE5tUERPZGdxeTNQVzhtOU5p?=
 =?utf-8?B?RUdoR2J4TTE1cUlxTFk0OEcrU1JrRkxGcUQ5R2gzcEJWTEhyZnA3eFRyZ0ZH?=
 =?utf-8?B?S2UwdkdVOGhkSzBFRFhMbzVGVVVPVXFBTTI1VjVEVUR6ZWRENWpvL2dlbDhQ?=
 =?utf-8?B?S0tIVlppQmFLZmtUWEliaytHMnE5WElLOE5NVkFhRWtFL0JscTVXZlBJd1d6?=
 =?utf-8?B?ZEFEeE1xR0p1MnBJZW4wdjQrTWtpYVNaamQ1SWtuZFhLeGNZNlIrLzh1OFV5?=
 =?utf-8?B?V1VOd2pBSDNtbzFvMFNFd1MrcDROL1BhL2hYakE3UDhmWmViT1F0MFBQek5n?=
 =?utf-8?B?c3dlTWIrd0FSc1htamRhWkZQM3dGZFZ5cGZZT29hTktEdGMrdW5iREJFdEZo?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XS2QFK4sArc1bO+EtLbvP2nmP6FGcv37OsYQVjT7mLcRp1KJar6xsTcGc2BSaxBV40t/fmnFE4jDrFiy4Qy29wcRAbWZGJhuKyNdtnPCmQyLTG6qoEbH+DUA23DYHGStjZv/I++UDE752houoAI5CSxLAnEdG80j7UhlJoqD0v+5Q75hTRf9fgghJSv5qK9jcjjrj/cGGLYUfyiS83FvaLpHPNAolUpY6jBGTBNBWDGoO2TdN0M9PPnB5KQyTMfb0tznRZzsWpxSXxCSRNCZ4nnDPrZ1xV/VhdhBz8raoHCuKQQUH0BIfr2GjwFGLCNy+ZPiODIgWqH//z7k/bbdAzsvrUGMU/UqeIHMacw+KIWfKGiXVsRoMA8ac+RCP8WHRsmTL7seBLAFvCeuLs7c2ZQUjvUGi3UG7Qxi0nP37nAmHEiWyZZ4EMOx4KzKkstzNOgfEWNBjXSK7RcGW0S78Cs/2aMWb68x0/xiQTSpm7V6TjnRbDE64oPZP+UM9N9kyKfg7Ls3DwcSQzBspGf2+GAHw/tFYGjlgtnpYd6JS/F/yya5Viu4OBT26CreSQxRXazoGUOPVO0m4Jn/A6fXlQGtQ4VTshjioxrazcyf70k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b016268-a0ae-4c92-b331-08dc4e6f12da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 15:03:34.8346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcA38WrT4RT9hbugec4yxDkX1hPulkB2wKFebbP4wTIYQJASC88oJ+2EX6k9XiUwkhEDRT/o7b8uUaLsmhwwoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_12,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270103
X-Proofpoint-GUID: 1aQ6vFaW1xdOhRFItCM-b_uoZ9wIeAfg
X-Proofpoint-ORIG-GUID: 1aQ6vFaW1xdOhRFItCM-b_uoZ9wIeAfg

On 24/03/2024 23:54, Christoph Hellwig wrote:
> While we really should be killing the block layer bounce buffering ASAP,
> I even more urgently need to stop the drivers to fiddle with the limits
> from ->slave_configure.  Add a no_highmem flag to the Scsi_Host to
> centralize this setting and switch the remaining four drivers that use
> block layer bounce buffering to it.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>

