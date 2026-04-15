Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3B0392811;
	Wed, 15 Apr 2026 08:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776240136; cv=fail; b=k2tKnp4ARhOd5yfia9Ba0KOdeoLy6+/VM06RAZurS2h5dnNewP2mz5YuVi5N6diqxW3uwnjsjV5yW/k2PNMahedNWBJqYU+RzAnNZT/CfTAsBhD8SFiRIeDzh9GrelqAK7lOZq4cWZmioyZ7+p3yO9yoSLY7LDhZVaAlYII3RuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776240136; c=relaxed/simple;
	bh=YIevjR6BggoxJzv7kXAwIBZE7N7Q2FUiNMxOD31eXgQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YTAaALPNtcNk4a1gfHldo23vxA/e4f7LuX2sr8kq+7FhRUeNr5LnYfobhDxGNBHoHeN6XcFOAvclxnj7ftunxSQb5pnxtXU82gWo9MVeRmvf/TuZS9AFk7Q1HPv9sFNSB/eQ13FW9qY0n6TC1TiTdhs4jorqkeC/E2Vz9Skc7PY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PTzLsHcu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NAfZONbS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PTzLsHcu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NAfZONbS"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63ENS9Ae625888;
	Wed, 15 Apr 2026 08:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kgopEb4JOQx9wfKpy8sfxL8VV9szYYqI2aQDqJAexvQ=; b=
	PTzLsHcuQEBIibAwZwNx0l3++MUQljRudtnVoxFF6C0mx3/Ch46+M0M3DFqSBklT
	EmYpq/TqTYt48VYCsTBfwYiA/2xo0L4IGpsEfoNOdncAndLGvkf6vAjcBQv52job
	iZTa3ic2behBiIJg6I2jv7dD6DXr06BUEWIlJok32AH9DjdGpmVhzOUHjwpP1C60
	mqcC2U+xCisvExX6Ep0tNzn/pPx2VXc4t6U2YV/CqS5NJ1DXHcwerghgaA7oGKtJ
	pWEk0aOwiViFmEMfpnc+/B3deHQItZMoQdlZatS/Jt8p0QYL83GhfhzFoLQ0NAvr
	QXzxvm8FN3EdInNHPEUmlg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh87h4dtg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 08:02:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63F7xUSM033096;
	Wed, 15 Apr 2026 08:02:07 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012001.outbound.protection.outlook.com [40.107.200.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nnkg7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 08:02:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTmup5FnIVFbXL02vpplZ6+XGNy9CBfpM3RfgPijJeIN7Pla5DufbEj2l4OEQKytPZec2b/Qko6rfLRFhvrKI/lxfOwsjSiu/SH1iDnkG4lqjPTFN+25L/hAl/HP3ccXnKPSLxSh8VXzdiLHCyhKKUbL/vHOA7u/k9w5wAhJKM0VI/clN1a2aHfTmCFlbTUjLOL7A2OLTo4VZsmgHbZ2tEH2WEcJdmT2qw+M/3lknbW9fuIuh/GgnyjWaczG5/QJya5efMJmqGBg5Dt+mlWmWL4f5xsXtRiyyAv2HcgTs6zo2NDKdyJrspDoIqJgPXUCg8uO5GRne90dOyJG1O13pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgopEb4JOQx9wfKpy8sfxL8VV9szYYqI2aQDqJAexvQ=;
 b=TUF6RiwxUPk1y/RBqM0so5sxP0FbQe78s78jCtYDRgczPPKBZ3sD01wutKNHWjjX9//AMX6CW/IaLTk40HHRZIiuDBLyXVp8TKrdAM8j4iTD1xesVqI5sEH0wQGEQ6Y2Iuj33d6+I2+1djvtMET6OwMo/dejJmwMhwc5+b9YMrEHSQzQXDjWACu2Gmku0NPOCgnqTH38RDnimNEY6Ap3rDZJ3S4cVTvJYr6DwRkthZSJgDKTN/NzafrAbJ4n02LM0H2VbqMTRLWvNbfUDuRBhkDqLYeqxx7t41yeXXQJit1ZB69g8kuMtJD4Avwt4GHd7vizZCiHwsgMWtrFbtWBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgopEb4JOQx9wfKpy8sfxL8VV9szYYqI2aQDqJAexvQ=;
 b=NAfZONbSoXsrnGdYP9A7HUn311aJEqCK82G0UpkdWEVCg1+GKlw7tiagQBw89nBA/miiMyn+lUCxwLnUUNwd15YgP9gplV6qYoS0735sEq3TnfiE7fjmGmdlKXBITHVcjNVyWkIWNAfNmBkjfQe5wMYrbbbT5wrLpR51lVddDBM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB5029.namprd10.prod.outlook.com
 (2603:10b6:408:115::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 08:02:03 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 08:02:03 +0000
Message-ID: <3d9794f8-971a-424e-be10-11d85374b81e@oracle.com>
Date: Wed, 15 Apr 2026 09:02:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] sg: don't use GFP_ATOMIC in sg_start_req
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Doug Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260415060813.807659-1-hch@lst.de>
 <20260415060813.807659-2-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260415060813.807659-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0505.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::12) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c3704b1-d02d-45df-8bd8-08de9ac5477d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	v0Z785/SFDOCa80IAVZO0le2vuMpdsyh2bpHZQDNO/3UbTzTvvuGdEgbT7bu5vjo54DrARyFHiNqzx4wF4hSK/+TVN5zXJlsi2TzvmjjBzlhlZ15hbdkUcCodgdAR5FRYWByx0oyNQxl64AOdVKgG6Opv8dNzq9+DoaueEt5GCAKv/h9xt+QnwsDUjwuBfRKR1T3h9b9CA3q7k5ozN72YgDRkSBTdqzuJVO6Vl51EJuWIE1e3pOM18/z4UgZDwL6dbKWgdeqCxnwuj9lpDHnkq7rx3h4mFzFhIeXT2maAl0qg2ujSv7nzPmu0SC6VOfyhYSfLid+ary57twtrxEIPNcJMQfR0Avcpq7DFfdD1RYFrGhg7RIvQY6OcrhD3DlIdkp7/CMd3SpGrIix3kxrpob5ne8idEw6fB824V3wgE8DDy+q38wZxhtJkRezSPcBlRVGY78RgtxabYJufybxTlk/jUvMmdHCB99hglTlqaf/BIH5xBSxItke9kw30CuJt+YeSH0QXXdpdnAwNTLm5JieOJOMhykq6YpDRM7w230dIpuLCq/MBtY6MsUaKYj9DItD+3jfnWw/OlUucq8+nzVaX7tQWdMiwMRtAwr7fxaOLcjhzthoPo8sMmKFfyj5gxda79d4NhJKb74iXuZLx51EJGcrra/kp6jyFtHLv28fh4RIjdt2qr68BUe4X8rRCo4o+xS8sZtEHIu5nYgXv2srQtzlwXMDiMl277fLOGs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmtoR1ZlZkViZDdJT2tUZzg0WG84a2FmRmhMUmJBWVN2Y0tsalFxNUY1Wk53?=
 =?utf-8?B?TWJ6Q21VOXFFV25KUVROb1ZYa2tNa0Z1KzN2THhwU05RdjBNRC9DOWhpTC83?=
 =?utf-8?B?QXlyNitiYU9INUZKd2NNbVlKdDdjWWJLeXNaMXRLZy9GMkhjenlwdWVkODIz?=
 =?utf-8?B?VUs0NnZSZU0wOGhRTDVQd3RyWFVweXNHU0dkYzRGZ0dkNkV4R2gvV0VBMmYw?=
 =?utf-8?B?M0tjVFg2dWwzbklhcERVOTJwVjBFeDhjNnpsNitZMk8wTUUxVnNMa21jNEFn?=
 =?utf-8?B?YTNNNEp0YklCaS85amRvWEVRaW1OR1pQdVdaRWR4SFNmQmUvUUh0dGNLd2pT?=
 =?utf-8?B?TU90eURoYzdRYmlCOW9RN1NySGpMLzZ3U3RRV255RGoxK1hNM1owMDZKck52?=
 =?utf-8?B?NjkwemN4UDBXWCtkQXFaZnN4OUFpVi8ybVdtb0ZQeVpWUzk2NkQrWTh1M3J3?=
 =?utf-8?B?VVRUQUNtbFVuL0ZickpUeGpQTUJWYU9NYTZDZUZkTis5RFdYanRGNTV1U1Nh?=
 =?utf-8?B?RTgvSDdRbzVBN05GcTZrRFltVngvMG5Md1Bwelc3dVZqL0U1Y0lRbUVSVnNj?=
 =?utf-8?B?emZUTHB4OVJyT3UxaDdqcE5tKzZTWURqaStQMXJjYnhyWTdiOUtrRjVtT1dy?=
 =?utf-8?B?L1ZzbG5kMTd3dk01TmFSc2pMOHBGNklTUm95OXNXZnFBaXZQZHpIdkZ1NTRr?=
 =?utf-8?B?TFFmR0ZNdk5sVlZSNGJRNERZTmdNc1lDMi93QW1iV0cxNFd0dld0dnhMVnRM?=
 =?utf-8?B?WEk2eWswa0UzZXl1V2hSWXY3MjRlZWp1MHRSWkIyY1ppSnRpR1hWeDNoWGJt?=
 =?utf-8?B?MWNqci9aMDI2ankxbGNPRUFERHdaZVFQMHR3elhpQTBvbkpJbVArZDZBODBX?=
 =?utf-8?B?Rm1jeHJCZUtLTUlmUjQ3Szcyc3BqeEpBejJJaDZ4eHVLNTlhRCtYaGpDZUZs?=
 =?utf-8?B?NEZNbys2U0FkbGhKZXdGWFhQTVBPYnBWOUFFb3Z2czVlRnJWKzhTbFc1eG01?=
 =?utf-8?B?WkJZd2VYbmJIWVJSVzV0US91UjFlZG1PVTIwUjduYy81UXNsS2RwVG5kUmZY?=
 =?utf-8?B?OWN3TU54RGdVTkFzcU5ZejFOYW1VclFLTmg1cHBIaE1NcWhITVhRUjVoREg2?=
 =?utf-8?B?S3FqTDI3UUJqQ0NCbnVkL09QRjcxNFpDU3hjbEI4a01xNFNrR0NNdTRRdFpZ?=
 =?utf-8?B?OGpFSVVyQTdha3QrdEF2UkZOWTM4blZta0xUeVd2alBkRy9jQXY1empMQmZo?=
 =?utf-8?B?eXlRanBTTzlIYWV4aXdDZzBWcXMyRVlKeWtzdFBJbjNVYVVCM2dQc2x3bjg2?=
 =?utf-8?B?YjdVUnNPWE9FeVVvNWlnUHhwUVkyK2Mza0wySFc3YXBXK1ZNOVpTOG4rTFNW?=
 =?utf-8?B?eUw4NWl4QmZ5eTRyZUg4M1BLZmQxVHpkUVdVckNYT3F0Z25oeGtOL05ER1Yw?=
 =?utf-8?B?bjRtY3RYZmlGbXBWV1RUVVJhTmplQXVadkZEbGtsUDhPbDRJUFFmL2JMS0xh?=
 =?utf-8?B?VS9GL2srRHFQc3Z0b1MxRElQM3BOZzEwdWVGRmw0cUVZczhBblVtSThqeUpT?=
 =?utf-8?B?anFlS0RKazg3eCtVdStXOWhEU2RuQkhmTnIrWHM3MVZPemVNY1U4ejBMRTUx?=
 =?utf-8?B?ZWdieVJmYVRIdytMTmZxU0NrS2lVcWJxa0VaYTlDZXh0NCtJZzZJVWllZ1BF?=
 =?utf-8?B?WVF5SUtkUUd5TTQ5UjlWQUZHY2MvbW5nMDNaZ1NuVWo3TlplalNPSTB0M0VH?=
 =?utf-8?B?UmkwYllRR1U4NkFiLzVKNnN4UWZacUlYaURTMEovZ1JNc2w3eVU4ZCtjR1RE?=
 =?utf-8?B?MEljRlh2YmZTUUtRakZPTmlxM0dwN2l2SWxzSVBvSjRJWkRJYWt3b2QvSmg0?=
 =?utf-8?B?VzM5VFR5aS9PSmoyTmJTOC83d1VBaE5VM2RyUnFxZ0JYd0tEbWhxTk83bERU?=
 =?utf-8?B?bVRnbjVGeVVwdStrZVNHeG5vZVJFaS9kWWtDOEticmJwNEh2YkQ2WjRQZVor?=
 =?utf-8?B?OUQ4SmZaT2hmWVNjRVdwMWVyZ2hlZVl1bVNGSm9aZmVISTBZZzd0dW5nanNh?=
 =?utf-8?B?OFVzMFpjcmNvbFozVXh4Mi85YVd5ZW90cXJrVDRBZTNjZVUvdDk2ZzdtSVR2?=
 =?utf-8?B?S0ZMa0ZlZzVGLzFtZS9QNVVNL09qMEx2VmVsOXhObytlOGRsV1Q2SUdqY3dJ?=
 =?utf-8?B?ZkpEQ1BZS00rRVg2NGhobzF6SGRzanVSZzNsSkJXVmI5NXZxeVArTUFFaTNR?=
 =?utf-8?B?bVhsM2pYWnY5NDdtZklrUnBMT1FGdjJES3lFZXRPVnl3L29RTHhweGJpZVUv?=
 =?utf-8?B?MjdWRlFxWTVmc2N4dGJFeXFmaGJCV0prcHg1WkJqUy9RVnV3VmVYdz09?=
X-Exchange-RoutingPolicyChecked:
	TQZ5uwp0abUI0A7S+A5V0DvYD+emsQtMYwyXUY1ZWz798eyYwhq2cupl/9XzfDxUU/s4wIowdesv2Vec7/hpEpEVglOxbFqRDjMiE9XRqiv0njkNybIWgJ1R9D4njdLQ32vr8+tQSjDBmTDX4Pa40l/mAbtq4dYKH9E57xadXU9dA8qRbjAwUGyirAE1JP4Oc8RLYz3k22RmzM29ut9pSfnHTnKDxt4dRDJB4l2SEt9Kz000ODZQDMrzrcjD31tR/gODnsnTJfQoVhSUUPjIHX5yAJ2/HtETVAKfmBkcjlXqUKLXCBEYMYaZkpWQ1NqprjUsGxDfbh1ZPcCYdjxIYQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HF3fueuLrvGCgyAYMReFFaz+tO9jTxqjpQGv6WDIatwvicLnpYBG+MxGinZ/BKviSBw4SW0NylcM7opiMVLAQu2x1vn4JYGls49QgLu+YE705pyMb3OoUWxXwStuBeUyDDdmVT71T/sBTkF64WsSQNhtmF/VaShraOX6IUTiHkhE/gQb0CAwBzlBU2MMLKS/P8jA1lEp8il0yLurtXQWEDfibdWYwtjgK0EszIS63wq31r//WsTCTEf0NL8IP3vPZdGWf7CBbCQgH4UQNMgdIZTBWuKwVO7tfyArNn1mF5TGfbmrfB3wFn0TiX04hVgx6oApWcWc5i0HwyanSBXmNKDHt+7CCE2VvzT0FP0TVgZtTCq77+2LK6IkWhbIwc+zo543Ij4QHJRvMO6j8avSeX72pNHDZ+nXAdlmmvsdmk85zPJunEfOxQYBwNmaYA6Aae8GH0ghNYjb4J6spG06HtipEQwvhcjN0QgxR6tR6dvo2pIKib/U1da9fke4EJJzbUJ4LE+jgXhLpBgO+njsIoi6lovR7SYWkteRM3vmD1KH/2J66trRiWBeQfqxilFWWbazklWhXJtZBw788X4Tuf5Ul62VECdyQncQTps5GF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3704b1-d02d-45df-8bd8-08de9ac5477d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 08:02:03.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CeIELVN2CIJl0sIvYmyCj5bC+ysweK7RoCiLBgqZ4jyrWDmE7PdkD3Ab1szXEVtL8pQTMuUNxX1rHdLjMqKMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_04,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604150072
X-Authority-Analysis: v=2.4 cv=eJUjSnp1 c=1 sm=1 tr=0 ts=69df4601 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=JF9118EUAAAA:8
 a=yPCof4ZbAAAA:8 a=Jqleip0sMEAhYxYqKlkA:9 a=QEXdDO2ut3YA:10
 a=xVlTc564ipvMDusKsbsT:22 cc=ntf awl=host:12291
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDA3MiBTYWx0ZWRfX0E0LGWpckXUD
 igLg1XONZJZz6wnj3nsixltpJqV42g3XJfDqljECSlyEjy9xWuRLFrbCC+MeMuqSeZBHqO2nEMu
 +UjTGWs13n2I0jbDqsf3nHDJyWHj3mOwqRP05FJHLw2K7GPJ0HiZ54EP7WhzlY0wJpUCZeUD0uK
 3gdRxKP0uCvLTrUzCmpFghVHwlOhtwyCDyXERXZrKKzMB7i+M5x16gqdzsaz1gCVDnCCJyRNIe4
 yMZfplG1CuHJGeXwKZo785dHQLa4B+5mIrbxpe7zSiFZpt/UMgD/z1hes6a04VPSp9UrdAkBxNp
 yxr5E3PIcifq18eVs1VMvK1AxQmKSbhUZBCHnfLIeOt/arioeH98npfxXuJb6uNlT/ETn/+2LVf
 ahPWSG8QanMJ8xqWKnNEAS0zT+DSkTjsTIgeN3ohQ98YPTD406CEIhqbjGx/wYVKyBlGjZ+Xoup
 +d1CsDFAZqFycMJN1KoZm/pQhmnfUliysLDneA+g=
X-Proofpoint-ORIG-GUID: wvoSxFhF2I3K4B4RlWs7dUjKmOf-Wkpb
X-Proofpoint-GUID: wvoSxFhF2I3K4B4RlWs7dUjKmOf-Wkpb

On 15/04/2026 07:08, Christoph Hellwig wrote:
> sg_start_req is called from normal user context and can sleep when
> waiting for memory.  Switch it to use GFP_KERNEL, which fixes allocation
> failures seend with the bio_alloc rework.
> 
> Fixes: b520c4eef83d ("block: split bio_alloc_bioset more clearly into a fast and slowpath")
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>


