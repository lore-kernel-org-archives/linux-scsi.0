Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24193DB65F;
	Tue, 14 Apr 2026 13:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776172256; cv=fail; b=i/lwke7g/dIIy4AmDHLBh7xZY5OOugrsb75udzdONk0lMvb645YojZqGbBsyb3ztU1XlH5416lzLv/Ezo16G4Kjl2qeo4HLFSiD1ixKbGy/CQjJRyeq6lLjVQsOV8L9l/dolYkwzBTf625UMK5SnlG0j4RiSv2dvmnVvawsqdhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776172256; c=relaxed/simple;
	bh=1pjrpzy6p49u0BK7GAdtBU9GrWpNQpa2V79ym2nUtcY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rgKxFnrHQmDNSuoyvlh7UM0Hl9djSlU1eBnUXxjSSpjp9tFJVlb2LacUkH0cBI3IieE4VRqVhDr3zKbkb+zQTXgturbwV6fbvsGdr64HDFtvpDc99XGdqruixcCZjzw2RHJ/tZu1q/eWca4Xr8zBzXm/v5+No2uOw9NG7QDMW+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IuuCc0UA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q9Olw5Yc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IuuCc0UA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q9Olw5Yc"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EBk6Bh779629;
	Tue, 14 Apr 2026 13:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/uvRqI0LNysj+LhwMFzakiU1XtXsKuoJfm9VNySbots=; b=
	IuuCc0UAtfDpXFX23Cjdy5AvA1uyC9jtGdNKcDjFABMpGvsu8MnlekqUegvRiDBh
	JxzcI/lcNwyrKE63Ys3CToK5Os8eU1OqKj1CllVWLUfHGtlbeUpNVRFCPvp7eKh6
	aWRV/Hw6mbV/zDL+C9/dj5qr6v3yXsXs7kv9BQxP7YzdMUOIKMomb0Ybal2cjm8L
	/eUwZ7aO8rHt5EAmMOnGqu/0Ov7lrvmumSumWRrDIxAj3sTMOJuzcMHUjGmLwQFp
	oRDiUtE7w9ZHPGWVwlmVhHgX3I1gbglM0S44s040UalfbReGh7fg6gUk0YE7v2+0
	SR1VXjSQvyiNdb+AsvACxQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qjdkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 13:10:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63ED4bm7012081;
	Tue, 14 Apr 2026 13:10:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012047.outbound.protection.outlook.com [52.101.43.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nmeh0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 13:10:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/ASd4MvRWHcIsTVNVzJLD45k7RADf5b5Gh2nlGcGXDxVU+Bdzq9s4K+k1xJW2SdMnd+L0gG/hjEi0nCMdpetk1E3nsFuItDIrf9lYOMB6xJUMZ5XhLjo2CGd4qWtvaftTBiIlm4TjC9X0GnmTWeGJ7tJGGBn3Xe+w5nFGIES0NyO+HGhUPv+jI+hdutKvOghck2oW+T91ZgTrTkNcBoHS8ZZXngx9wBJ/WG8AtItDErOAXlEHGdEYYxilDyXO6oqnKXaWXoe9voBLeanbklHtg6GJGRa2IP+ShK+wb7YtZhdL1oO8X50FyFI9zjsaLJ9xzDdkDnyfZ8fX7GA8ap2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uvRqI0LNysj+LhwMFzakiU1XtXsKuoJfm9VNySbots=;
 b=xif2UOZVuOYGiTif1zJ6uAJ8RHEDe4INHai/JPcYrCcTsD4seqquSu4fUVh68xfc7mksWhcX88VhkQ7fCkQR8+KY3ybk+sH5dX6ILuoD6vxCoj67HBYGGTbG/C5hoT8QyXLKTshZB2yEVAagmitXUKJdOWdQW0x5reg/0qJrXm7jTRZuyHrTOrIZXd1qn4GgOlAOui8w+h9meu21RQ3FmBhTtXp6raoNHegDIk8dhkgFg22aid7zpceqAV7B8F5mciNhBQRK6cjnUkuTDl8yLNF3lMZzvxRgxr9M/4QCQ5YFPAIaedfghVPk0w0qhftLmhktUHmhymLlL5jMFugliQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uvRqI0LNysj+LhwMFzakiU1XtXsKuoJfm9VNySbots=;
 b=q9Olw5YcoqgjUwUJMAgScIGe+I0Kd4IhgpjEc8iGHlNHHk9Aw++R4oK6S+fp0TWxFEQK4bFFAsk1AYRUoU8XJfqav6g/GtV4BScnYU5ULWKOGSc2tBbq1GEKrIq+1JDjELtK53Bs3XcdN9ywGZaqSFcL/mtfgz+qkxsdlQnThKI=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6827.namprd10.prod.outlook.com
 (2603:10b6:930:9e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 13:10:17 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 13:10:17 +0000
Message-ID: <944509bd-64b4-4f31-b363-a4ddcb3daf2c@oracle.com>
Date: Tue, 14 Apr 2026 14:10:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
 <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
 <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
 <bfd8c2c2-65f7-44f0-a4ec-01158e249505@oracle.com>
 <02288590-486e-4243-8352-c756c6879629@linux.ibm.com>
 <bc18ad6f-10b1-4a28-b88d-aed5754b968d@oracle.com>
 <6dc8e0d7-9b2b-4867-9df7-6853f4b2fa05@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6dc8e0d7-9b2b-4867-9df7-6853f4b2fa05@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0681.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::15) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db51aed-cff4-424b-d222-08de9a272c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sY5TGKW9XUk2HuagpZIdP7L3aGRvPxQMQ16f89vFO3ZHgRrgEPeGZUCupFxPwdZccSQ6EV/WB+kjdQqf/n3F89aq9nUBniNwDFyjFz0EbqWWxQ6pNleWIn6TkQ5vtkls97ap+jI35nuQ8c4JyOzQRCVCvcZDP6sTUpwmyvQPQnqi4arY4q1xqz1t+WvarodF45u54oyKb5IboYklmRokq9qTg0TQkSjrdc4DXy2IREWp49269hmwPj0XieHfvMB4/cv0hUyt1+t9Gon0kfMTKQmRCkWsmUtiizXuPoKkI2yZY2uIRy0kXX+2rpLVxLs9HoT6O3MOB8aWjAkjV2jGbpRU+Yfa5Co3qYhbG7M80N0ir1C6quxRXT7rAFAu1pfrR0TSLAgN7g+LfIGdWWAmuKJ7YJc+jfwxee4VmJStMej9IOCfg8KxyZVDPWgxz7yx6knbyajNTlhUaICCUYjxcXJIOLJhNSdUeFZFBckTN/0LA4QMnhjEXqFTS1JlaVqrC1d4jxEeFjYk29SBegvL2dUkbqulIKN7HtFgtRJkAvxNJonHrgdf+MUeYzXXd/R28lEA83TIO5FHn25ttJBNn+p4gO9mrAdZ/nAh31vLjHjZrreUbZT/l3Omp46fCXAwnYJ+EnwR1AtyriNYg1K+aADKkhmW/dbOQzNuef0RY9QWfD9RGIMP4BFVlkIoU2VD1h8x/7M0GHc7Pa+89Vpl4D2s3U/bsBtBHKM5XUUbhDY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGJmQ3daMnF2ZkFnQWdMY0FySXhGYUtCdnJaaFl1VEt4T01vbkFLeXVablMx?=
 =?utf-8?B?ZklOSjRBajZkc1djUUZKUnpNM2lOMmgwNC9wUTZ0ZHc3THhxRElGVFc2UTVM?=
 =?utf-8?B?MTg2ZWlKUkVJVzB1UVVTK25rdXdza3hFOHpkMU85WDlaYlpsU29IL0xSM050?=
 =?utf-8?B?RXRvL3UyY2VPc0RMQmkwWng4QWlEWnpWVEg0RUUvdGhEQXhGa3d0MzNWSEVu?=
 =?utf-8?B?NVJpQmhuVUxYU29NZk5ZdURMUi8vRkdXNVoxYXczOUdhTFpqQzZydlNQNm9T?=
 =?utf-8?B?U085dWJzRVpmelhNTlVnNjhybXR3UmUrOVJzYjk4c3ZTWWl3T090V2tYQitO?=
 =?utf-8?B?YXh5WWw5OVZVb3RrR3VpYytWa2FKZ3I1cHMxRVBWc1REaVdrTnRONWIxYmJl?=
 =?utf-8?B?eWJ4SVRBOEV3Mi9ncGNaZWJoWlIvVWpMVGpLUFJoR3lCWlFRR3VmR2hpQ0FC?=
 =?utf-8?B?WXRsNzB1emtVaDdSQVlvN0ZzanhwK3I5K3k2NTB5RW11Szh4K2pTNitQL043?=
 =?utf-8?B?ZnA5WW9wZXl5NUZ2WGp0cytqYy9sOVZJTFcyclBoZnJyRVZtOWhtRVRIcmVE?=
 =?utf-8?B?WllWZ2FMTnNLb3A0OFVwdGp5T2ZBSm5paTR0UHBHOXBIK3ViNm8zTFJMVWhT?=
 =?utf-8?B?TzMraHdGY1VWQ0xrYWorV0hBa05CZFp3dlZ3VFhKOURhRU10MmtzL1hEMTd2?=
 =?utf-8?B?amI2eHlpZDRVRU56bDhlRzY4MXVMV3hsRUJNd0RubDF4MG5RWHBSc05VV3Zi?=
 =?utf-8?B?VHVLdktOeEsvTy9aWlJMemRlSnQ0LzNwcXU4Z01oVkY2aHg1OVZBOFRXS25J?=
 =?utf-8?B?RDZDczMwZThwODUwajVnOEJoUmt6N3pqZ2xEV3NubmFnR0RWQkt4c1pjOVlr?=
 =?utf-8?B?QUFzVzREemlkeCtuekFLSXJyUkVJVTlPZVJHa1VYQmdhbHRsc3NsdGFvam1h?=
 =?utf-8?B?UEc1Z0Q0WFZVaWRDMCtrU3c0YTN6NFRZNExFOXVkOFE1MWdCVWFVbi9NZmNO?=
 =?utf-8?B?ZXZ3bHVyWU9Hd2t3Z1NnaTlNYzhYb2ZzajB3NC9hckJvYlE3dXpiUm9UTkpj?=
 =?utf-8?B?MFpIU2FweXRSRlpHUHRmQjQvSkJ0VEdlbDAwdWZVZHVYYUx6aGRGQ29sNVBX?=
 =?utf-8?B?WUpBWHEvOWdxMUUvQTVKbXVtNndGbTJRZXpWNUt3VWVQeUxmcURxNUZ5Wml5?=
 =?utf-8?B?bzJselo4TzRPUUdNaVVnOWFia25sU3pQUEFNcjNHZWVKbzY4OGdDVGtjZXFj?=
 =?utf-8?B?VGVhcmlUb0JBMmdBNEc0SHVKY1lCRkltNnpQSHUzNGkwek1WYXhRUG9aNnNn?=
 =?utf-8?B?NnFxZDFkMk5CSVdoWnk1MlhaT3A3czNnNkQwdkF4NytraFZMUy95aHNqWVpr?=
 =?utf-8?B?aFNiRzlhQmRPMkFTem4rNjVHQ1JPazRuRVFlM25sTXQ0ckNkRFhyUXlCekc5?=
 =?utf-8?B?dUVSRmpsRW5FbmRWYjRlR3EveURybXJyQU1FN1BLWmt2NFVNYnR1dFhIT3RI?=
 =?utf-8?B?Qy9iQ1hINVMvTlJVYXpUZzZDSmVEdDFsa1JTeEJXL2w1U2kxbDB2dXNBaDkr?=
 =?utf-8?B?ZEFQL2dIT0ZORi9NT3czUm96REtodEVuNmlWSlEvY0VUdHBqaW85TERreDEy?=
 =?utf-8?B?MERRWDRSWFkrMUxLVGFNNmRuNmo5bFVRQjV5M0JFaS9YSFA0ZkZPU3RnSndj?=
 =?utf-8?B?eFpCelo1UjRYR2E3bHFkc0JxNWF2S2tNaHFCYkl4bnJEMUx3YU9qZlBGeVNa?=
 =?utf-8?B?Q09aL3RoZUcxM3NaNkpBSE0wc2g0RldCM3dleEQwaUZBdk5BdjRtUTJVcklT?=
 =?utf-8?B?UW9vR213QWNiY1RwRStzV1N5ejhEeFlPcUgwV0JZbXZLdXBTcTZpL1k0Q3VT?=
 =?utf-8?B?OGFMMTRtaXgwSlBkQXViL3J2c05pTHg0eWxTY0pWZDU4L0xRTEdvc1ZpbzNJ?=
 =?utf-8?B?S0NqdmpMWHQ0clZCSCs2UU9FUFY3eDZ1Q1J0dG5PSGJBd2lmaEdTN1U1amRN?=
 =?utf-8?B?RUt2Mi9qYUNvL2lXUHA5QTdsRmdYb3gyL0tEcGo4ZE0yRE5xWGZBWTdxeXlM?=
 =?utf-8?B?YWdSa2xBUDZyaUl1Y1FSdjkyaFkwRU1iVG5DQkYrWVpnWjRvZTFIYzc1b29D?=
 =?utf-8?B?VDRmRTBTbmw0SnVmYVJsblNxL0ZYRE5sNXVTMzZaZENkZGZZZUwvZ3NhdzNG?=
 =?utf-8?B?anFuNjdaemIzZ2FjRk9NVGFwWHNDSDVGNzUvMytBSzNscTA1OElSNkRGSWxv?=
 =?utf-8?B?azN5TXp6V0I2enliZlR0WnJqRU1pTDFLNS9aQzF2VXpvSUE5d1lhbkx2WWh1?=
 =?utf-8?B?OFlBN3RCNDJ1a3ZmV2RUcW9tYnZUc0hIdzNTUk9MOEVsWmFobWNPUT09?=
X-Exchange-RoutingPolicyChecked:
	OpVWOvQqOyW+wrz6ClcXemkYZ8ZDe7w1sYQSLhex3TkgZ8wriLpRKD9MHhOFvQ1hkMOuRQi3ICD41Nc5ZrEldGxDSTetzLtBBr1cFp/MYD4HvfJNJcLvTSiUZeZEIeMofmGL9Fb2oBCsCe/TWOR/g9zFUHcs8Bxlilq5C7chdpAsFXnKTZoiYMSGlIRhuqHa9rdoaj0Xokt0jDAydZPvtaHwmxfnpWBn0Hcp8NUpJwN4Hq0ggZJ4zxeZMIm+GTHiwbQpXGttleVebOb4sAuttk/GcIbDMDAh8M0+MdcK1RsnQ8SUtYgPmq91BgnbV6q0Chp4chLqmN8J90kVzgmrHA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QBadbtFNoinAGiRgkG3n29SeK02gL6xgbG8gMXY32khp9jHeK0QWZVtKlne5D9yjh8TtEe80098QixnyfXFYxH9aXyspyS7WDIqG9VWnWpPAsDORhd6oEug2U1BnXRksU5e3arXrYwe1mi/LOXpAejFq5d6bwzWF68HLzePqWVC6o83Q20IC7gRFI4sbGkTt7FUt4B/c8FRLAVRAhSi5VR0OGeZnUyjpbYGpXZZEKiZGI7JHTimCBn0ShTkzghmQ2F9MAAYx95SalJcVqjRaLbssp9woR/PuEVKPWYViKfak4pqZZqHxEWifF9cE9uNHaoQKguLfDj4QemwY7Y4jpr85BmUqmvNJjcHwnM1eCgd6AMacsntYkzp96QIY6LEHb8unGGWZEdEi38bW/IH17t9lkdBcALiU6JmkULtpdKjIDZWO/oBQHGB15dSTL8gMCr2Xi1D4E3dMpiu3qD1A789x0TRY3lxzODq2qNUiGJitAb2t9RHyEhxyFqomtDSvbbWSWJa7JycntzqdibUWVPsykSITz24Edo+pj4uvXEGvoZ/ADGu3FwW29McVWYRLvQEjvz2gw8HNfYXUw3I7yZmF+SIqXBB9E6vgamXOIEc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db51aed-cff4-424b-d222-08de9a272c16
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 13:10:17.0033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rewAmQOee77vTQV4uUoYMsGqXEifSy1mzHOCBwKU1nRfAgGLOViNoSfsrczmUpAGM9aAFPirc438Gk7TWz/Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6827
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDEyMyBTYWx0ZWRfX10gzr1SSPMn5
 +1bxKI8Yn4Zw4D4ktIkF9jptdK+Ynib79A4Sd1dqE6Oqhcm+fclo6dJ75CMZmuwt2+ymXz+lkZ2
 cfW4P5Ou/Plh5plJFl7VJ99HR/D572+tqoj6z7+gDlFgB3iKBS9zrZ5tnnbnDbN97UVZ9eQGXfr
 Kk18rP/9Qd7Sje1q00Se49CfGF/ekuV0SJ7g+2PstpjcA8ev0J8+PuNouMVu65sGcXn9kdY3UK+
 jc9qMlqfezNta7ObWUxhGfFaXHHTr8yaedBz2sQyNQmjsYrirpkZmbdLiwRL25muT9q6DvIftHL
 g33VPa8n3XoZPFKWY6IHjX/tW6xI3g72NfbhLUDj10mWLd1PlPDrIKc2eMv5RfjYUN5qZyjPMVM
 VNIcYSUMW6606fICIdhEhO+CErfuqd3guDcT9MwCKI3+9fO56OtsAo7VFggZapt9y2iNpBIpyIq
 oqqeO4qlT2YcH5v+79bLB/iGPF8EIR2pGk6bT1Lo=
X-Authority-Analysis: v=2.4 cv=Lo6iDHdc c=1 sm=1 tr=0 ts=69de3cbf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=lmGieSKD2doLzn8IYwsA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12291
X-Proofpoint-GUID: VUlR1FZ9LNjT5URoV9MZDdu4gt5owqfx
X-Proofpoint-ORIG-GUID: VUlR1FZ9LNjT5URoV9MZDdu4gt5owqfx

On 14/04/2026 12:43, Nilay Shroff wrote:
>>
>> about the queue-depth iopolicy, why is depth per controller and not 
>> per NS (path)? The following does not mention:
>>
>> https://lore.kernel.org/linux-nvme/20240625122605.857462-3- 
>> jmeneghi@redhat.com/
>>
>> Is the idea that some controller may have another NS attached and have 
>> traffic there, and we need to account according to this also?
>>
> Yes, the idea is that congestion should be evaluated at the controller 
> level rather than per-namespace.
> In NVMe, multiple namespaces can be attached to the same controller, and 
> all of them share the same
> transport path and I/O queue resources (submission and completion 
> queues). As a result, any contention
> or congestion is fundamentally observed at the controller, and not at an 
> individual namespace.
> 
> If we were to track queue depth per namespace, it could give a 
> misleading view of the actual load on
> the underlying path, since multiple namespaces may be contributing to 
> the same set of queues. In contrast,
> tracking queue depth per controller provides a more accurate 
> representation of the total outstanding I/O
> and the level of congestion on that path.
> 
> In a multipath configuration, this allows us to compare controllers 
> directly. For example, if one controller
> has a lower queue depth than another, it is likely experiencing less 
> contention and may offer lower latency,
> making it a better candidate for forwarding I/O.

ok, thanks for the info. So on this basis I would think that SCSI host 
would be where we track requests for scsi-multipath. I need to consider 
it more... Hannes, thoughts?

John

