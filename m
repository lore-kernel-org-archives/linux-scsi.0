Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF9312DDA1;
	Wed, 27 Mar 2024 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711554050; cv=fail; b=mezDfIrQBmoBlRtG/s3WrCWoI2HJMNCLr+QtwxpsTlSX+19yJXKJLetC2jIvwrqqxU9mLoEslsfDckXY+t3msAjFckeChYq1dyBCGXgvozCsUgmAXMs45AUGyrbwmhFyBOCs5fiQhbHYw/T4u+B3gph2cvL4PckeMDGz01y8tis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711554050; c=relaxed/simple;
	bh=jtSWD3kCNffVlQ7p0xrsgL5dlq+sOX2Fn/wvSZU7rBo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d/rjmd4iFfjaF3etJnQDkwYHyl0N7klNYA5JjyMjQ3ibqijk7RxDifLaBwaAT6f3velPWM+5JHmLyO+jU06Lb1Q82w36qzZ7d2gWJ1SgmdNjQdq3t/jm2yhEGwcqPE06f1PX2cee7Qo1z4PFBCw5iv2d9R/ec40MSRZQQIKfTGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PU8WbTA0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kjpscVXu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PU8WbTA0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kjpscVXu"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42REi6eH015718;
	Wed, 27 Mar 2024 15:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=phjxbvN/LZKZr8RuX2cANfOO1BBOfEsodY9w8oKowZc=;
 b=PU8WbTA0eGWvE5JsZ4XtytEic3gEU/WK21aFs92wsE9LMq5u4mE0KxO1gHgcb7/vr6ws
 npqgzeERIZf/fxzOuxZQIug1ld5CCNIlHA11E66iJxIaxIAaxL83PCmeVA8AFgRBq6jz
 GF6iKyjQvOSqMz6f9QH9jWAVNLyXzFqzU16RtfaP4L8caY/+vaB2qQHQB1xZN/Ytd0Ow
 +MX+JRTW/76uwC/1aFSuWhkMqTC3ZYwsokH6flCZkjP6bz1Z4LCVAwynOSLxBZC09s1e
 plJ6g/h0wXPghpX0gteOwInuV9+Tqo04ehVV8uprAbdM3sG6phhgH7oYJbP1XPVyRltu 0Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1nv47qd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 15:39:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42REA5YN019081;
	Wed, 27 Mar 2024 15:39:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhey5gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 15:39:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhXz/F73ASvNJ080yV0KTY0Ja5M9Tl/zI8XbFFR85qZGnzNmHK7TaL2eIKjJei2ihDVpWXCLhfRn7DutsWGlDPQoi0BKMKB7SRyayaiB6ZYlHf4a9cIPFv17bTNkFE7WADZ0sroG2GQk84Q4Zb1OtSKsY8vxNHIKM0YOL3pc3RvfzsPV86UO8evnaonyklXF0SQe9/nILGXfGzcjCr549HmQQbQaFAIzdnytjv6klTutj6o35oJiXQCEKFgpmKdDNB0ggOtuKrzeWSqr//ooShygmkgj2gPXSVp88MWEc2BQAX/55kosun1OBQAExg92qGxGZZvXcg6Mufl119BLVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phjxbvN/LZKZr8RuX2cANfOO1BBOfEsodY9w8oKowZc=;
 b=kjqUnF0oGqNVAPYxftIXebig8TMfBojI+Eyd4X0sC9dRlnkykvafJz/ZTwn+JEDLP1wF9JN76VWS2R4OxBudbB3aw88yy0ueKXpsrDFhmo5nOg7G2Xj8N3IoRjiW+My210IWmTxfA1SI6UK9/COz1WMgyEDYIM/BfODv5LqWeFr6CxY3LIlOeIx9kUggpPX8hBzvSGZreSe96FDpMOjG9tCj69STK3iFB+ho87OruyZbZTXjoG8rIOq9d1iXVg4zExmXsU4OwAE5EaYHc+lL5M6XTLGg4zFTBixfeQRifTWrs+WKAJYwNme0AgHDSV2L+1nGjxWEpKIczpQNXyrLSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phjxbvN/LZKZr8RuX2cANfOO1BBOfEsodY9w8oKowZc=;
 b=kjpscVXuSImVBwTD7yJspxVPmgfPdJpOGK77623oZ6sclF1oKJ8Pc2eaqUqsVLOSdioTwnI4uuFwVkVmTuAxqDqtMNGjIQ2rh2dF3fjpNUKNZ/R9IXdM25lKBg//f/AJBQ744ToPpHsUNVb7fJUg/ZsBJIq0yxWxuIxZb1CnMQU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6115.namprd10.prod.outlook.com (2603:10b6:208:3ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 15:39:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 15:39:33 +0000
Message-ID: <eaaf6c1d-2a7d-4a67-94e3-bd5dc4a83045@oracle.com>
Date: Wed, 27 Mar 2024 15:39:25 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/23] scsi: use the atomic queue limits API in
 scsi_add_lun
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
 <20240324235448.2039074-10-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240324235448.2039074-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: c7fa8f9e-2d17-41a6-f34b-08dc4e741935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+w6+QvLF0jFD1TmHNYmakDG5i4Jj1IStp30pmshMGdVhrvL0vP82/lpfIv9xMpMmKPi4t1U1xL8qpI88TDS1/KvTr2FY/2OBAvAnNbtRQmBcH6s4RXC3/+9yxiBE0tERlX/Fx2o0ei+eIRJaWZmP/egkrenOHYZgzrNo11ZSmUbY1sLDDauTLQJXkz0P0ZwOy5NBF+qY+JvQER9fWYQrZEATmsAKjZzdZ1YELZvsS57FardyJS1t+FjxuD+Hn1XOYZjbwytHhov96q1jUWr+1a02tTkDYUCjKucDRPPbDXyHSxLoL+jv3GtZQjaRZB3bHavEfMaCVNitATtrNeOPgCPFAaSwylIazimWtAZQxbLSsn4hV0cK6wdMmS2uy3EJ9hJeVnxqATgIBA5nJ/oAQNgdihd6FF1jdqHGggqbxsVO8bMKaMu8EXnugGsH7oLa3WIIynDEeLm2XoSxwFQmNP4CWawIHXVXToN71X50dDJh1pIGug5mtEwChRdhNoKhGR+bWGy3gWcrxp82qFjOZ1KaBu9yxZfhWr3jmV91psmoYHJc+llUs7cgwRoO9tNIo59+A2bgL6s3SeviQqu1RYarcdqYHBjkwT/lSmYJrVI++ND5ylxKX46rPCADSunmgsMf1Bl+uCljatzfbQPPZe5kyJKR0lqOoZFIxmdXvTw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R09ScXJxQXh0TWJjT3Z4TEsxQmF0b1RBV2c4TWZXYXVBQjQ5d1JTWDZoMEE5?=
 =?utf-8?B?c2dQYzFkVTEyOVliVEcxVEY5cHc1eHFhTW5vNk1yVVRsdy8xV0FkVkNJMnJt?=
 =?utf-8?B?TXU4MU1DWGJYUUh2ZmxrNDQ3SDRGUEViejd6Z2hiTEZQMVVwZm5yN002MFph?=
 =?utf-8?B?dVoxUmdyaEhpZ1I4aHZybER3d3ZEMms3NTd1QXpodXlXOUwyUXdNQXgrNS9h?=
 =?utf-8?B?QnhnR1hWVWlhRmJmNkJBckFMenpyanhpb0Z5MEY2aDNKNWhDZElyMmlTdzV3?=
 =?utf-8?B?WVhadWZqZnMzRlFwK1ZNRGNlVTdiSWpFdFd5SDMxZC9EMnFxeUIvZjFHbTAw?=
 =?utf-8?B?QlZIZURJTGxoTzVTdG9naWl4cHYvK0ZKcE1kVjFraStwcXdTNDJBYnQ5NEN0?=
 =?utf-8?B?R1JqNmVKRi91REhNZHhCTmlKVzlrZTFZTFk1eXNYRHh2cVNNMTJzeHZwNkxK?=
 =?utf-8?B?K0VQTk9pUlA5OWR6OGhjV0lKU2l0bkhSWFlJRXdYL3YvVUt0UEJucWswcVh0?=
 =?utf-8?B?Wmw2dnpiMXRGYU9XL3VWOFhWdXBLZGNxTVB2a3YyYXNGZ0tqaytWSUh2TTVS?=
 =?utf-8?B?UmEvWlk1eXpTQ1kzRkJieGNka0hWeXJCQjZnSm1nY2lXbkZ2U0VZNU5HV3Zr?=
 =?utf-8?B?N29QL2ZNSlhibHRUb3EzamdCbldBSzJWaXRPbTdOOWs5V3kybGl3QVVneFFy?=
 =?utf-8?B?OXd6aCtlblQvb2tKZ3FPeTlTc2E4ZVRIN3dUTDVTZWhtNUtaU2t0bXVkL3JX?=
 =?utf-8?B?UWVhbXgvcG1qWUVjSGhmR1crRjk0K1hXTWQ5Qll6WnlYRGFpWThMaFhMSEQ1?=
 =?utf-8?B?ZlAxZDAwTkFiaE1mZWgzcXZ2aG9yVkdrYnFCbkJoaU5NTk1rS1VhaFBVNjIv?=
 =?utf-8?B?UjNaVVhpM3lkOHNMcklHOE5aSlk3N2hoOVkxTWxhZEZJQlFnbHEwVC9SYllD?=
 =?utf-8?B?dHJwTllVVUUvUml0bXQ5SmVuWlVSMlhPRTN6cFIxMTh4L0c3NkNER2JwNVgr?=
 =?utf-8?B?ZGJYR2NwejRJMVFOajRXMnAwQm9zRjQvVW1lMWdFcGVRdTN0clVlSjFKTVZr?=
 =?utf-8?B?L0l5ZzVtd3FVMXdNb2IwVUR5MHcvR2tYTnhTM3o1SFZjdlR5ekFtc09NbGli?=
 =?utf-8?B?U0VUVWNqeXJxNThJZGdEV2Jxelg2bFQwN1QxMjNMWGdEZmJtNGdnK002VTZq?=
 =?utf-8?B?bkw4WFNpZldRVXRHRGVwRFphRkN4SXNuUUdSMVh4Q01xblBlZnUyaFRTZkhn?=
 =?utf-8?B?YUszN3dUa1BCUWFvbHhDRnBEU0xBR2R6YlZuTnNrem8wYjI2aHF1dHRKK1Jh?=
 =?utf-8?B?TmxLNkhhQ3B1YXZlRUNhS2V6Z2RnQUdvVGZZN1IyYk14L0F6b04xZkVHakNq?=
 =?utf-8?B?RjluYXBkaG53a20rRlFUK3FDMjRjNEswQkVDVUJya09JbE1YMk4wSm1Lbzdr?=
 =?utf-8?B?T3dKUnQvalZJQ3pLSnIvaVhGK2dJRXRGQ3M0UkgwTk8wMlJXNnNpMjlxMnR2?=
 =?utf-8?B?Z3NRMVNuU0IvNmJrUFNjbjM0cm5WeXV1RS9HNFgrcU91a2N1YlMvVmVVYS9R?=
 =?utf-8?B?a2NIZk1vT204Y1p3a1VOWTJ5YmNBb20yYzBlY3JEb2Rzc2dGcFY4L0JuOStm?=
 =?utf-8?B?a3JCZFB5TFptVDBOcE8xeU9XaVU4RzhPMFhuc05NY2FsSGJ0UGNWMzkzdzlk?=
 =?utf-8?B?NUUyOTY5NE5mY2paSjdyZzNBcjd0eFpvOHZHZGgyRzVMWUxGRHduMjBtdUdl?=
 =?utf-8?B?OWFYRk5RamRCYmdvSDNjc3NTZWhmc2Q5eEZlSTFmS3BPT1ZzcDNSYzRibzJS?=
 =?utf-8?B?aWVuUkZNR0N5YVZYY0JlVHdxVzl5NEo2V2ErMGlxbDl1cU1DWVFXOFVUdmlZ?=
 =?utf-8?B?a2dQZDZvb1JhbGhSWnhWVjJjY0xWdlhzNkNDQXllVVgyU1VvTVBmdjV3Q2sx?=
 =?utf-8?B?eUUyUTQzSCtsNTNsYWFLSGg0dTdQYk5XaS9EVjFLN1RzNXgyY3Q1S0I1ODlp?=
 =?utf-8?B?MUxISVRFR29sT09ka2NIOUpNZDNnNjZ4N1gwSllSQUwxOTRpWnBlYkFUMDZz?=
 =?utf-8?B?bTZIR3ErWTFmWFBvRGdsK3RrdlhFRytmbUEvZWVuandQTVcwdHc1MkJRYkJO?=
 =?utf-8?B?dnVYNkd2ekpsSnhla0J2cklYbFB0VXRTb0FLVnp6MFU3RzA0MTgyamFrZENY?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BjqfthyUNg4wCjpB0dCBYN1FMtsPMMJ9Dx4Mb5y3vEthxuH+kn8hVHSBH26wfk4vw7VFP8NTQ0Gy/OnVPHAEcAeACtSkTy0ew+4AvKFAjdptF8d7L1NGg75m9KU1/rIhVeMDpy8d2tPW4gnx3HBCVLfz27y9aGbfZFWbcZUANgFQbuSlCjp26sXYzLxSA/YPnsmWBwYTrLFWVCrKNKq7SMxlThVu03MyHm/5QL9lq0Zded/XW8Wn6j2IlDHk4+lRQAKtNVF1rwVkRv6kffXt3ncZYNexwHus2m7axxLdXXrBnOBs/i1Rb7lHKFJV60AppwPtBUxuuWLeNoh9U1tzNsYULJlP3IzrB0YSXd4ot/WByLM6Rd6hVCpxb0SG5Sy2LhSyxZmVou+NksoDdiw/pIbgimHLCrbGsCESvD56UZTsu2RkH8KS60vwXEj35mVNwL3txnew/BZVNGH8KnoiuhVGLl+T+jQQKSn38bWv9NjMVcEIk11Dw9r3OECylYUmSNI7fe0c9KWHRY1uV2oB2ZeSd6uGZFR7RRIypcq+L7rdLZTUqGEezaWZdKG+F/ehtjqwSXHUvwtJ7EMcpCEkfjJbOoMN/vmSpceo/dfwpRs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7fa8f9e-2d17-41a6-f34b-08dc4e741935
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 15:39:32.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kLBgV2rZO6O6jwK2giW/64g51qpvxJYGqVoad2oFjrdfeLoh4xR1NA0LwnOPtzCi63B/QopXfk5NO/rRpXD5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_12,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270108
X-Proofpoint-ORIG-GUID: 3vTOesRXsATzSHahSO42zf_VuFNA3R4l
X-Proofpoint-GUID: 3vTOesRXsATzSHahSO42zf_VuFNA3R4l

On 24/03/2024 23:54, Christoph Hellwig wrote:
> Switch scsi_add_lun to use the atomic queue limits API to update the
> max_hw_sectors for devices with quirks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Just a comment below. Apart from that:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/scsi_scan.c | 49 ++++++++++++++++++++--------------------
>   1 file changed, 24 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 205ab3b3ea89be..699356d7d17545 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -874,6 +874,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   		blist_flags_t *bflags, int async)
>   {
> +	struct queue_limits lim;
>   	int ret;
>   
>   	/*
> @@ -1004,19 +1005,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	if (*bflags & BLIST_SELECT_NO_ATN)
>   		sdev->select_no_atn = 1;
>   
> -	/*
> -	 * Maximum 512 sector transfer length
> -	 * broken RA4x00 Compaq Disk Array
> -	 */
> -	if (*bflags & BLIST_MAX_512)
> -		blk_queue_max_hw_sectors(sdev->request_queue, 512);
> -	/*
> -	 * Max 1024 sector transfer length for targets that report incorrect
> -	 * max/optimal lengths and relied on the old block layer safe default
> -	 */
> -	else if (*bflags & BLIST_MAX_1024)
> -		blk_queue_max_hw_sectors(sdev->request_queue, 1024);
> -
>   	/*
>   	 * Some devices may not want to have a start command automatically
>   	 * issued when a device is added.
> @@ -1077,19 +1065,22 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   
>   	transport_configure_device(&sdev->sdev_gendev);
>   
> +	/*
> +	 * No need to freeze the queue as it isn't reachable to anyone else yet.
> +	 */
> +	lim = queue_limits_start_update(sdev->request_queue);
> +	if (*bflags & BLIST_MAX_512)
> +		lim.max_hw_sectors = 512;
> +	else if (*bflags & BLIST_MAX_1024)
> +		lim.max_hw_sectors = 1024;
> +	ret = queue_limits_commit_update(sdev->request_queue, &lim);
> +	if (ret)
> +		goto fail;
> +
>   	if (sdev->host->hostt->slave_configure) {
>   		ret = sdev->host->hostt->slave_configure(sdev);
> -		if (ret) {
> -			/*
> -			 * if LLDD reports slave not present, don't clutter
> -			 * console with alloc failure messages
> -			 */
> -			if (ret != -ENXIO) {
> -				sdev_printk(KERN_ERR, sdev,
> -					"failed to configure device\n");
Is there some reason to relocate this and have it included for other 
error paths, i.e. queue_limits_commit_update() call? It doesn't really 
tell us much to know the cause of the failure. At least previously it 
was in one location, so we knew the point of failure.

> -			}
> -			return SCSI_SCAN_NO_RESPONSE;
> -		}
> +		if (ret)
> +			goto fail;
>   
>   		/*
>   		 * The queue_depth is often changed in ->slave_configure.
> @@ -1115,8 +1106,16 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	 */
>   	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
>   		return SCSI_SCAN_NO_RESPONSE;
> -
>   	return SCSI_SCAN_LUN_PRESENT;
> +
> +fail:
> +	/*
> +	 * If the LLDD reports LU not present, don't clutter the console with
> +	 * alloc failure messages.
> +	 */
> +	if (ret != -ENXIO)
> +		sdev_printk(KERN_ERR, sdev, "failed to configure device\n");
> +	return SCSI_SCAN_NO_RESPONSE;
>   }
>   
>   #ifdef CONFIG_SCSI_LOGGING

