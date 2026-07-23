Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF5A45D5F5;
	Thu, 23 Jul 2026 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805741; cv=fail; b=P0X8mclzY5MWTuj2rIL/4hW/GEvd9JMYtBLLviSSUOgdLgVEfGkIJgwNWUYVLgpC6Il+Dvbo3UvrqveV/A9dsWw5+6c8VgD1Lz5zEh+q6aTwJNzioR+JJUfoLZH8C1JV2kx0FikTKxu7VlagJs6Npjhx8h8fw7QWgU8d6hN6USg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805741; c=relaxed/simple;
	bh=ySS+r9kBNP51gH377h5fvCtoJFwq1pOdRZ06rjvvKOA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IRcsNXSYN7bNOaJQ/gCf6GK29S/CmJzAkBItmnTCztzFTP9/wK8+s3RHi41eIlSdNe9lhkVVLD4vWier5Mi8d85XUF6hbCYUplEdsheIdRWz5pYe5t7mKZzsXBZ4MtVLLgw1qheTmdk6RKyA+8aXcMWHtErMOgMLWbgfDUH+6tI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MKdHjy4k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XK5veHqN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKdHjy4k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XK5veHqN"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtcZO3353523;
	Thu, 23 Jul 2026 11:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LnbjJbn3Hvyy6uwOG5VojAKUUJDa+Op3LXAjNZN/5+w=; b=
	MKdHjy4kadKH7xk7889cZWN0OGCw8q+NSB2EN8dofY3JBSfDhP3DhPkFESg53FsT
	LNYkv96xjQo24j0JVFobbYYM/elmcWe+unyjcHWgRYjfGIPhKpTdmHKDnzFgDLM1
	egxVQ+8TMou4SFFxjEDGoeb0g+si+7rLRakjxq1RDUT+cB8YGrrJuzR5FGXsVs7v
	6tHqESzubDcT2L8uUdnUrqdz+AyXQ7WtYVfQbZGFwMJ0HXtqhRcps3VnFIQAB9It
	g+zSaLUH4Z9L9v+CSogT0FPpJ/knmsbD06GRsYFsVzQSocuF79yzV77xVSYom2fQ
	vU5tP5T9037P+nljQBapVw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6q3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:22:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBIPQm010164;
	Thu, 23 Jul 2026 11:22:18 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxd87cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:22:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vfjkNhrLBQwaGyNnWN6/CGS5G+cH6BGOFtFVLTcuqfe8fa6Fg7Gtodj89xKpJuyMD++AhaGG2qAzXh3UQfVmINa/7b5FHv14INpXrNljDDalD4H3K7idu1x6SylguV0q0lqkpnJjm5Pw9fJRyn3G1JQ39IvBQuVOam53dPGXslHvWNqox2If94GOJqstjQi3+2OnMZnmtSQtx8yzO+QIDypNQydskbZycoA2EeU6w0a+yiamebyV7EpZoJnKpzfZBTk+YosZsZ2CwI6+SVOstKCgyopiu4HJ09HxZWORLVw8/ywV+KRx8psSH9dtlP3EdlKvirBnsuYEbTvU+sRYrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnbjJbn3Hvyy6uwOG5VojAKUUJDa+Op3LXAjNZN/5+w=;
 b=qH9+vJnA85Q3oqFFEk+M7akmnWGWJl/HeUmTKcYUJkYO7I+ZXuadmtje+WmoFqgOHZSR6NlfkEkNI9s9nkRbgdZgdqfO+bEXfHbhJg+B4QeRNcMqfwSpDSJKjQ0r/EpWN1wB+ZWd1AaiwomieWXUDJEMeTBv/iVS3/I1//UHtigXswjV5yxpJbDerHoq5PvHPYBolkgqL4uB0vDcEHaoKu3QZEozw/+NZQWog6Mvv1t0Oc+t9xy4U/0Xlllt8LsJDaBLe1wmWRwpgMHIGVCF83KmV8cJ1/oSomRNG5v3PppFqjhSpOynw3NJ4KlFz3tYvPxdNDVr4LXMnPmpPndvnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnbjJbn3Hvyy6uwOG5VojAKUUJDa+Op3LXAjNZN/5+w=;
 b=XK5veHqNfCfppsu6RppSFrBLbCBXXPjmR0nIJVmh/seVtoOZJSkVXSDwDon4BOKoHAVxCk4eAqWx5BuAH8oBJ4pfW8zX554fOFeu4cLOIvT+sc7+eb3vs7JEKBYzv7+yJPxhVQc8ToqhjafJBgpIWl9sF9xsjlg4+H0XHrzKEmQ=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by CH2PR10MB4279.namprd10.prod.outlook.com (2603:10b6:610:a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 11:22:14 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:22:14 +0000
Message-ID: <26f08dd9-e012-4bdb-b98e-cab60e519fc0@oracle.com>
Date: Thu, 23 Jul 2026 12:22:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 24/28] scsi: sd: add multipath disk attr groups
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-25-john.g.garry@oracle.com>
 <20260723104714.7599B1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723104714.7599B1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0060.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::13) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|CH2PR10MB4279:EE_
X-MS-Office365-Filtering-Correlation-Id: a34200be-7aab-4fde-b92b-08dee8aca55e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|4143699003|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xrlfMWYKa6JpHjrtNy+jjadYEdxJ2154PqLEMO42XnJ4ONv2ukqqcjKPCQzzRY1p6DWdLvHD6KikESdMhjs7SW+ugKe7ABMNR/Be2aPsn4932du6st5Ie/z3Qqwu3yWhgCiOBx2EgR9D5QfiRTCnbY6p6CHR8g8ywe68DKyNf0W4+eTou4CnYRqZcpymsKmohH09IyqkqXTvsMUmXQJD+ujqprb9szEIuHVEh0sVOSwH3hQyO41XLE+aE2Zfh67SITRcJdUJhVXiQH3rMl+ZquOXLHvR8F/EpBd+9G2uJ4YfaRiGu6GBA4r+ga7W7W9gRelXOEdI+SlRjrkcpktH4DPAucmEIH0B50S9S6oEUjRkYqOq7P/AfPFf3PtCQS77OTkI7dCplewk56yKAzzbo46K4J9hkEj22p6TIQ8V7bwyfKR/udL9CuMS0HveRhmLxRWhHNoV1uqUQBOt2H0arfLm6A83P5QeNo+vI/li4JZtFfh+w05Q9tTk/7U/oVt7K1a1J6eLdzXwLldrFiGPfbQyht987nOvTV8DkYanf9Z8TABnTrCRRU2wBfJdbNHtt7t+5yFvMvPL98apzuW27PtpL81E679Zs4ZTpCc3uECdJaFCgg4J/0dnv0QXaejN7dpwHge+ue459SDQNIvRGAbJLQndCAaW6tNF3PbYOjg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(4143699003)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2NMbExEV0V4RzdlWmJBWEQxNktVLzljQUFCV09kcHNWMllrQTRlMXlOVHRB?=
 =?utf-8?B?UjRDOGpieUpKQVZJSHhXWkQvM2ZEOE9rUWVtMTN3WVA0a015d21TQ2FTUStO?=
 =?utf-8?B?aWJkVUdHSWkra0VHYWNIc3ZQN1V2bG1NOXBTdXpoemNSQzcxVFJ1NjJma0NF?=
 =?utf-8?B?Y1Ryell6Z0ttRzU4dnR0djcwdG5GNEtvdTNQclBndkFMZGo2RUg5YnVNd2ox?=
 =?utf-8?B?cEN0cERxNWFDQ0tZQWtwK3doQmRlMEJibjEyeGRPSW85SEpMWFIvY2o2Rktx?=
 =?utf-8?B?QWY3MlBWajYvakxXaExjcGw2Nmt6bC9QVkNkeTIwLzBsSnoxVHdNbndGcFpV?=
 =?utf-8?B?MFQxTmd1VmVxVHFtWko5aUZ2cjZrTi9JaGcrcDNTQ2Y4cjVXa080OW1YNWIy?=
 =?utf-8?B?aHV3elBaTzA5akJXQ3JQMUcyTXJyLzRIdXdHd0ZibTRVUGhOZVFscnNQbldM?=
 =?utf-8?B?ZVFEcnAwOXJrVjQwZmJ0UVJDK2dhb0lqNkRjL21pWVVaWXM3OFRUOWNwMkVv?=
 =?utf-8?B?SExldVErQVlLbElyUXhoeDV5NkdqZnF4R24zUzlMaER2TmNIamIrcU5wTHlv?=
 =?utf-8?B?c0xYSkg1NWFLbG8rdWNQeEh4clFxYTg0RlFEenQ0aGZtdERIbU5jbmNIaEFH?=
 =?utf-8?B?bEdzd3dqMVo5WWFaOGVFTnAyT0ppNUNpbm9QbGVsem93cXdKOHU2VHQyMmpy?=
 =?utf-8?B?MFVFRisvcGw1Q0lXK0s3dm9CMS9VakpqZUcvUzBEcWkrUUhnNmVxR05XOFpq?=
 =?utf-8?B?ZkI2eDI5aTNsZmovblM1d2ZiTlY1YjZmNVdJK2UvVW4wVGdRazl5eW1PWnNq?=
 =?utf-8?B?UnpwVnFoUXRxY2JoM0kvM3pvWVpCSHRkc3ZLdEdMbU14d0tpbDdGaCtrTXZp?=
 =?utf-8?B?bTRTYldZSzFXc3F0Q0ZCWklpWUhycWNabnF6bkcxMVJHRGFwaDRXRmlRTWQ1?=
 =?utf-8?B?QTU1TUpVZTUvaHNDREpEMVpaVkdKdGZwK2VsOXE4c2gzR0ZKNVpJbGxCYnVX?=
 =?utf-8?B?cm0vTjJpSExFMm53V05EZDRaRlNocG5zcTdsRUQ4YWtEUi9wYjhDZjVkanc0?=
 =?utf-8?B?RTNXdk5NMzZLRFlrMjQ0cUZzeUcrZlhPQWRwK2pYUHpmSysxeXRUMlBPN0hW?=
 =?utf-8?B?cUR2ejhSWDB0Ylg4YjVUODV4ZlB2VDd6OUNxSXl6dmNrbENMUG91cC95eGJ6?=
 =?utf-8?B?cmpKYWtxYUhwWUJ2cFl0VmZZdlNoQWcweVBRemVpOWtDbGZqd0FQUTEvNjA0?=
 =?utf-8?B?ZmtaSklHa2J6L2pPbCs4a1NZZ1luSVg0bTZIdWduZjdCMHkvSmpkSjM0dUdH?=
 =?utf-8?B?WElCZnJIVFpDYmtmU3M1TkJZYVhnaWdlNHV6blgyeEJLKzg2Q2NmeWkydWJw?=
 =?utf-8?B?WnNFamd1TzVSdmlsV3FPMWxpVUZXSjJBOEVxUWpEVGJjUnJyaGdyaDBYS1NY?=
 =?utf-8?B?QmxyMG5JQmpXRS9DRml1MjdVR3RwWlVDTExHRFczQXpxbzAwQ3oydjhVOXV3?=
 =?utf-8?B?dzZHUXJybjJ6cXM0anZ0cmtSSEZhZ1VLamJub1Iwc2VxTjg1dEIya0JNcFpJ?=
 =?utf-8?B?ajVmQlJySlFRZ3kyMjYvamllekppWjh3aDd1MjlHZENPd0h2cVJGRTA1bzRw?=
 =?utf-8?B?REtOMFU1K2preVdrNTJUTkNVYnJjbkdUd1ZNclBtMDdTU20rdHVUcUNUZ253?=
 =?utf-8?B?OFlyMU1XQkgrN0NPN25nK25uV1NoNkF5Q0E3SXl4RUZEWUZRYWgxbTB2NVlM?=
 =?utf-8?B?VGdqRUk3K1BPVGh4MUpCTXo5Mm1UZDRObHZ0bDMzQmRtOHBiOEd5Tm4vNG5k?=
 =?utf-8?B?SGRYcXlVZStzWkZPS0lKTVlzME1SbnNqWWVCSVFzNlBIdWVjMkQyUUhlZ0xX?=
 =?utf-8?B?MWs0aU1NOW5UZUdDeU1uT0V5elBGOU83SU5FNUJrby9HT0I3cWpaQUNBcG16?=
 =?utf-8?B?VGFubUVqU1JuUnJvSnA0enRNUk9zbmdhTkpoTUVpZGlhVlc5Z0pwNXJVNkpF?=
 =?utf-8?B?c3Q3Qjd1RWRyU2NsaXJiNitvL2dGNEM1N1g0eWRxZnZjM2ZUUkN5UnlDMTdy?=
 =?utf-8?B?ak9SNkpFTDI0OWZ3aG11cUhnT3RkNUJ2T00wWlhzQVgyYzJCdkROTGhTdG1R?=
 =?utf-8?B?S2Q5Q3NySXRLL3A3cXd2c0R5Rk5yeWUvNGRWTEFjSUh4YzNpSlBPQnA1S2xj?=
 =?utf-8?B?dHlhNFNmTHl1WjEwYkg4M1p4RGV5MG1nVXhzSU5jMGJRTHJnNzFLaFVIMVZZ?=
 =?utf-8?B?WkZRSkhLUXB1cTVHVy8ySEdTdXJjQ0xCQTdzVnNPVG51cDVmaENkOTA0WW5o?=
 =?utf-8?B?eGJuZzRrYzBYTmk3V1lJOXFpZWU0SE1YNzRudkRqdWRtWFp1b0c4Vm9oeTE4?=
 =?utf-8?Q?9V5ZpIetxs4twgfU=3D?=
X-Exchange-RoutingPolicyChecked:
	grkv/ISgqEe8qoi6uRdU40/xWL3UarmrD7OBErxkaKMMbg2mKB3kINQ7u/73qsejQ5oYu4qziQ6xJ8l5UVyRomyklEal9bqqGOlC2uo+MZIPGC/PzFLWFQvz4OWiD6su9woZmMBj36bQeaVezthoi7rmjx21yH/N57Sh6GCwxSr7KhMHEESxnjAPSwLy7CaN9PYYqjVlcx+sp3C/6Lh7i6wivLk+gohaHZjIHVPTTLtE9FWwP18m+2eEQuPYx7xHqQKPmVpij68N42wtZEzRk7lcNNS4MaOALbvN2MujVlVt2cDCWLchvygKJAXxpliyZn/8V9MF/Ir2pm19u2bBVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+S0//Kz+cHDC+n2k9K5FE1f7XgbLj7iRFmTE1YlnQK0Tu3embRiKDVjCLMNG4G2M3fPMAArbxwMqfmlM1uyRTb2o91dKx+O0zn75vm9ty4wWPsy8DRnZtRmOBqYfOgOotFs9Ijcq8uS4OJuukXbg4AzxKpm0uol8SB0SROA7FzLfXpiAvs8LLcHF5bJM3tg4OboQMceXyVAEN4XwLjK1Du49tAoq50i+BfVlLhh0dysgRABDDHkxZGTIX95Oq5ATmp12EPa2gLinpz6oDJEnE7/K+FHl7o6zG1kIQKhElJ6+ZcVXsnf2SKqQ4PktZr+oAZ0CPmjIaZ8oKTEvLX+lbDsHBqNxeFWNCT4lJJqEtLGkqQh13c91Pe0y8WqzuVoiJNha7zdmETlU9XB8k6sWpKJ3Tb6v3W135ICwWD+AwswBZqNReDY/S91C2Cv6xQxnCu2cbmjGIDWDFF4TQPuHMxR+Pc4gMtCMZCvdSyjkqKsgENKIGDNurpjOuP7Yfl/sqx7u+FgKvPktyTWZAIxEVWKH9gOo9PqKmlTPwMN8ctIAqV+e3B0FMWqHJvBRfDVnrG7REGq1L7UdVG5Av8NvXD9TpdQX/aH5AJqUZFJxNbE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a34200be-7aab-4fde-b92b-08dee8aca55e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:22:14.2534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkZvX/W2Yl16LsD7rv6YVRXUKN8E2xIDZ4/Y4e/wJxh/mMuDCygxMgG3ebDqZMBtwkqnugMrMJ1CPf9K2nto9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4279
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230111
X-Proofpoint-GUID: Cq44umY6lS0B0-KUQN7x74oRkzHppjrP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExMiBTYWx0ZWRfXyOfQ3yFwdcWM
 4/5NLG1KyZabfoR5N7619hEwltpo/P6xWX0f8xzHCJ0GkUwB/sks0LS8b8z8aXiVgFca4k3DIiY
 0W12PO1R10a3gsk5A22KSk9w1zmSbJ6Mr2zreFn7d0rV6hVvYgcQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExMiBTYWx0ZWRfX2x8KSfRKflEy
 P+Ko6qg+biuTbrnMrnyNY0G0zwhRSWRBCf9Jwo+QAiFpC0KdIR06dVD7WVSw2L4wt20X2gA/fEG
 wcgbcMd8rQ/i0AJa8s33vFaa2ge7oyN/86kMIcTTwOBMMEEdJBtc8QhkG+Xou+Yv57C/xtu6ezx
 5oqudDh1L8BBfBQ/067p8PdOdhwH5aLJ+ZA+YBtOniP/PkbMDoGghi51h+oNADYO9TkRxgaXJsW
 dSI1wIsZsp2e/wmQ3Gps+EktyUphWEOpjzGtx1dm9CumJBnm5ZRpr7mV48XzOcwFTZzL2PhqnVk
 2FYa881G8HHbHb7ZV5AnmK4naN0Bd2BDPypB0X2FuiAwXGYeZfukWPG8s6gQftdjTYXhHtu4Lnk
 KR4h7Vbb4ZFjoMd8+XSo8cfFyM7UbNRQZ3JUCXr+trFVqykgtK4qu4bLlqD2umCrDVdcF2WwuZQ
 pgLeIz6ezIJWXRE0RwQ==
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61f96b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=lC7M9MIrosp2CGA6B18A:9 a=QEXdDO2ut3YA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: Cq44umY6lS0B0-KUQN7x74oRkzHppjrP

On 23/07/2026 11:47, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The patch defines the `sd_mpath_disk_attr_groups` sysfs attribute group and its associated callback functions but never assigns it to any device or class (e.g., `sd_mpath_disk_class`). This leaves the multipath sysfs attributes entirely unexposed and the new code dead.
> --
> 
> --- Patch [24]: [PATCH v4 24/28] scsi: sd: add multipath disk attr groups ---
> commit d9075e7051637dd60fcce05f493768de652548d9
> Author: John Garry <john.garry@linux.dev>
> 
> scsi: sd: add multipath disk attr groups
> 
> This commit adds sysfs attribute groups for multipath disks, including
> delayed disk removal and the existing mpath attribute group.
> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 242a15bc2c5bb..36c745cbb2619 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
> [ ... ]
>> +static const struct attribute_group sd_mpath_disk_attr_group = {
>> +	.attrs		= sd_mpath_disk_attrs,
>> +};
>> +
>> +__maybe_unused
>> +static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
>> +	&sd_mpath_disk_attr_group,
>> +	&mpath_attr_group,
>> +	NULL
>> +};
> 
> [Severity: Medium]
> Are these attribute groups actually registered anywhere? It looks like
> sd_mpath_disk_attr_groups is defined and marked __maybe_unused, but never
> assigned to a device or class to expose the sysfs attributes to userspace,
> leaving this code essentially unreachable.
> 

yes, there are referenced later
