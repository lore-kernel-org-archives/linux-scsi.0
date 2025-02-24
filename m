Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9880197558;
	Mon, 24 Feb 2025 08:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740385790; cv=fail; b=QW2nb3NuZoSQfpr7AJoId9BaEQqAs84CXmbLBEJZcGjJ7wBH4zWVN7m+GqioXQ8IAIv6TrxvMFDuZS2G3rA9cgzZQPXiS5q5Ff5wlggUl5R9o/RleritEEWV3IGkS2cnYErbLzTPon9u8ZvzBINYTIqahOUWiKz4tjHyJHyQEx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740385790; c=relaxed/simple;
	bh=0FR8PbPMFdHqf5is13o18VCz+r/yxG0CLjSjHq199UI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V+BZbV9Dtx+3TDdMJ6t5Nx0oKvyf9LOd8sbf+WYTdceM4xaxXV0i5N2jNQ1RF/hlE6yO6KG1U7w4Jib7nJ7PadBKYvm9+6zjNLmJIDdIblUd+wz300KMO4ypnpXObnWRB2aHlw9UqWwMx1SeJ/JuS+ly2yiPstxVErCYg7hMpGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=miRY1wJg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DwlQJ3IN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="miRY1wJg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DwlQJ3IN"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51O7fORr012887;
	Mon, 24 Feb 2025 08:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1f5ZXT1HJOTUlB22qIPeoAj9TkqQaJu9s07mnw9vd/g=; b=
	miRY1wJgi4gVl/9iKYwzyZqAwm3t1HZNJqhfTJzUYd+mL4ZVzMZiU0OqfQp++eaO
	eDKZQbt6aomcW7YVqlnVLlCcGIiQsJsixSg+ZxhXMxhOpwioY+wghqJIxnzCMEO3
	Zs2eqB/aSGTaXv0I8qgVmcaB/NUF23yM1wtjfA/poRuW3f+9LJC99MhLhQ/o+t6E
	gfwV+2duq4E3SnsqGQf55tW89r0L2eRTrT+apyq0LD/fPFB+fKoO68pbb+wLgZTt
	yvV/5NUGakv+7uAd9nKRBclpQeBs7yP4jqCof5LBA6ZjXND5rOf8DxW9YBueafrg
	aDZmqumAYq+/FmEMtbzhXg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5gaj2kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 08:29:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51O65Utr024503;
	Mon, 24 Feb 2025 08:29:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y517bp1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 08:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bbedG4QvHx4/Rxi6IfcrbM8S2QsKFsPh7D2kAnlil6KCObzqm57GYM/xww3n4PDGQhLK1a6A3ObNmaFV4l1DpDzymFZOjq/hxBWH2Z75KeRJf2ReE9wXLQmnCHqJH3kk2uTlK8S76ZI0ENtX2w2xQvwEBn7hfJAWMpJ7d/riZtg0GtDjB9j3i5w0G0iHx7lma5RMlM5T+VT/9jyE7U2mz0P86qJuErojdO4Vs2uyqSCZ0KsthEWVw2WD3LLEvA7PSNLXp4vZd3aRBEMQRhkOKE0ko53WMeKJRVD6HdmZoYDLRBsytV3x/fiNq9jUHX4rmSatCoLUpaHbk/X5I+/Few==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1f5ZXT1HJOTUlB22qIPeoAj9TkqQaJu9s07mnw9vd/g=;
 b=ipKXth9/CiLTUh3sWpZyEp0KUR68JGvC3NXnVyLnaQbsW0ivBPKLDumwcYLrb8Nj07ZAyHqL4VIkzPcHA9+XvXAvXd36y9LxKkwF16TsvqFuLqHvz4ck9pGXZkM8B56+ujQh+NxUyJi3zZB6Rc2MNwWS8NdlxzBzhI05AFSzoC3Kn+JHQQ3BB7uZxgLL3I58zufk19tgusNY+9pKD15nXCn4ebpd8zc95GMKB+IzEQ56QdP1QqAtFS3EF4dNRBO+aYEb+kTMJmU68XCUxXsNjEvOjt19rev6fAr5Zzbkb2iEUoNGFr0TNv+4vaYzLCYy3IMEu/5gfwPjs4w4W6Xt2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f5ZXT1HJOTUlB22qIPeoAj9TkqQaJu9s07mnw9vd/g=;
 b=DwlQJ3INE7rhjH/q7azul2aUSMAhDmWPFQ1iHHo6CcGurE/4aHLkpigpaXOVr+mQ2tnO/PpyzljgxaVLkJGjlFE39NKzfSyQ2coL2QaiZxKKsOUyIxjVXMUrPoBl/mWUp7g7cHsRCDCqQMXkn7KNdkDlFS9h4VzGgyGZkbMKAYg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4701.namprd10.prod.outlook.com (2603:10b6:a03:2dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Mon, 24 Feb
 2025 08:29:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 08:29:12 +0000
Message-ID: <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
Date: Mon, 24 Feb 2025 08:29:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
To: yangxingui <yangxingui@huawei.com>, liyihang9@huawei.com,
        yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        liyangyang20@huawei.com, f.fangjian@huawei.com,
        xiabing14@h-partners.com
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0229.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4701:EE_
X-MS-Office365-Filtering-Correlation-Id: 791c8ae0-38b3-492f-e344-08dd54ad50da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGhCNEFtNDZ2T2NsZjF0ZGlCRWdPVDNHNTZOeEJFd3RwWXd0bkhVUjlMc1ZH?=
 =?utf-8?B?SmZUcG5qck41bXd0NUZwZDFna1ZXbjNqODBrN3o3U2h3TzJwNy96TU14V2sz?=
 =?utf-8?B?bGZ1cDBSL2Qwblo3L2h6R3lBZlNpVkttQlNTelJFdHFZVUtMNXphSUwxRFU2?=
 =?utf-8?B?TmtJZ0M0ZnFjNkJtZWRnOVh4UkxCRVFzUjZBSERWb3FNeDAxSUpTWHlWOFRT?=
 =?utf-8?B?VlNqVjFEd01PK1dGK1gxRFJ4MnhwYmQ2Tk96NzJVQVdpT2YwS1U0VzZWbUdn?=
 =?utf-8?B?S2J6WC9aa0M3V21XeGdwSEJqTTRYcjdtdGVBZkdQalhDcGFOTFB1MkJGbkZQ?=
 =?utf-8?B?M3VvMldOeXpjamJZb0lENkRtUVhxMWp1azBYcWdqWFFXTXJYdFYxTHZLdzhI?=
 =?utf-8?B?QjZ6cWhBRnZtRnlTOFpuZ0dSekpLcVI3Q0lGN00zVy84ZXFDS2YxN20wMHlk?=
 =?utf-8?B?S3hGL0Q1Y3lyVVhFVEZnOXFIUS9Wb25OQldXTEpyY1kwajBtTXFVaTRXYnh1?=
 =?utf-8?B?NFdMZTFud0YzK2tlcm9RTWczU2JEUnB1NHdoL3BCUndETVhhcWJmYmY3ejJ1?=
 =?utf-8?B?YmJKaHVBNW02NTgzeU43bk1XZ3ZHeHJPekttUG1ENWlobXh1S2VRcStTWDN1?=
 =?utf-8?B?emhaMVEvMW1ISTR1MVlrRk1XL3NhWmd1bTU2WVljNk5LNkdrZit6S1VkbVVO?=
 =?utf-8?B?OGxtWm1xUDhTaW5BTzVWVTRhdnp1K1QwWDBIY3RwYlpENzJQSVlEMGdnOEtv?=
 =?utf-8?B?b3BVUkhiRDBLQVErR0JIemYzT05WU2lsWUpWTFVnbHhnbFMwbUpBSWl6V09W?=
 =?utf-8?B?Z3ozenNiL2s5cUhaNXpPMTkvcTdRZjdQMlpTc1Q0QjQ2S3hpTkdUNjh2b3po?=
 =?utf-8?B?N252L2dNMWxXNHNPRUxDU2V2MmxlTldwRS9JSDlEZFBJaFRGYjdrQmNVam96?=
 =?utf-8?B?NTlRaFFFMkZMa0h5Z1pyS0NiVEFoVS9USEYrbWpzcWlOLzRFV0svNXpCS0xl?=
 =?utf-8?B?eTZ2eWdYZW82N2ROaUc1RzNzcXd4QmtkWTVEeEFrTmJyRVZRRUhwZkdBd2Jy?=
 =?utf-8?B?UENzemtpeC9lbm9WQ2V0OFVweC9veVNka0Nhbmw2ajRtVUtUeHlxeVl5alRk?=
 =?utf-8?B?MUtOZDVvY2hLYWNTNGhCd0ZTV3ZaQnVFdzJ6OU9SY2V0RFF4ZENkbkZFbTdv?=
 =?utf-8?B?VXo0OTh1THVzQUg4dHBQblJqUWhTS291eFRCaUZqQlZ1Umg1NWZwbUNGQzF0?=
 =?utf-8?B?bFJNN2RaSFBFQVNjTFpuT2lUZThTU2JxZDV4WVJaNDFFL0lnWitRSDRtUXcv?=
 =?utf-8?B?bm1WZ29salVTbHBwNU1nVmlyUlJva2lrVCtzaXV5WjNnMURINlRiZzBxZFo4?=
 =?utf-8?B?OExidk9zbDFSN1VVSXZOT2FKbGlkL3RZc1dYRVpDSHd1L0ZUVENsNmdlM2Rv?=
 =?utf-8?B?eEVHeVJxdmI0Mk1pbzlkZXRRUjJWTlh6ZTV1UHBnZ3NQU2lyeWYralBzUFZM?=
 =?utf-8?B?RmZPdFpCaVNVeW8zUHhjejIySEthVndmZ0h5dEg3RzZmRjV2aVMwSHFhRWF1?=
 =?utf-8?B?R29NY2JQcXY4KzdBb0JjQUtSRE5YbHhxWHM2Q05EcE1aam9WWDV1d3Q2elpY?=
 =?utf-8?B?ZC9JRXVOeS82NEdiT25LOVE5NG1UMmJISTBVVmVEcmgveUZxeG5ZUDIwRGlC?=
 =?utf-8?B?SUREWUZEYlN6MmdjVC9WM3ZVSWF0eGxOdmxUZHhnekNiNUtxRFpORER3bXpG?=
 =?utf-8?B?Y3MrTWNlV3RRSzJNb0s5OWtaQVpQSzAwazJHM2FSeXNjdG5VV0FZa3B6VHZj?=
 =?utf-8?B?elBrVVd5eFN2Y3k1S2p1MFdMcnQvNWlIdGdRbU5rWi9GN3hhR3o1VkZwRGFV?=
 =?utf-8?Q?1NLrUGyWtj4Oy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eURKejJXV0UraEgwaVZnVVlhdzZrakZ0TlNENVJ1dVZyQlp2NzVOZHZlZk41?=
 =?utf-8?B?aWV3VFZ5OXM3aHo4K0xiUy9NMmU4SjY3TUNDMUZZakRkWnpjaHpBZ215Q3Fx?=
 =?utf-8?B?WFFrbjRrU0tvc1ZmUXlWMEJWeW90Q2hEVjFKYkJJS1FiQlhIQmtKbGgxNllB?=
 =?utf-8?B?cFF1UkxLZ1JReW5QREFIQkNlRlZacURRNkdsY3U3SlpiVTIxejQ5bllNdXZ5?=
 =?utf-8?B?cThjTVVZZElwWFRXZURsNXFwRWtwSHBxWXJUUEJJYjM1TmZoeFptTkYxcllT?=
 =?utf-8?B?ci84UjBTclRSbUFKSkk5cTJSd2RiYnIrRmY4NlkwYXhlUHBvMGF6QlVYcVB3?=
 =?utf-8?B?S3BMZkZVdXlqTzE4NHlYRmh4a094K2dWZFpMT0JCNkFPdkk0YW5ONXl1eUhM?=
 =?utf-8?B?VTFBSDZSb0pkWEMzMzUzTHQvdUZBN1R6VzdBc2NnR1lCSUtpZTdpMnJ3TmlZ?=
 =?utf-8?B?cmR3N3RzU1RhanRCYlVTRmU0cnBwZVFKbUFDM1BnWjNZR3VONjMvMjBKYncr?=
 =?utf-8?B?K2RhMlQveWFMOTZxRzhjSzc0Tmw2NExwVW9rRnQ2Q09BbFBkSlNBUjRvTndJ?=
 =?utf-8?B?eDdac1lCQ2V6bmk4d2FhRjRualRDb1hjOXIrVGxHT2VqQndlcjQ5NENIZXNJ?=
 =?utf-8?B?Y0J3YzJsMElWVVNYa1l1N0srS3c4TWp4alRjczNTbE1Wc1AwSUVqWUt0TFJX?=
 =?utf-8?B?OEREbFcyKzFqTmRYMUpEbzlBbTdESE5EeHVwR0s3SHpTdjZGYStJV29NeVNj?=
 =?utf-8?B?K0wwSjF0WVF5Y1hURnpnR1ZTeDM3YVozOU5qUmNpWEZaUHY4Z0NmM3F4UCt4?=
 =?utf-8?B?cW1keXVTUktsYWIzUk92YXJtREZDMlcrMFdWWnJNSEpvcXBjeDRjZmJqWE9J?=
 =?utf-8?B?R1RYNjE1RTNIc3VaZGNqMUFLNk1NVDUxaW90NGJVVzYwVWw5M3p3aTZ0bVBZ?=
 =?utf-8?B?Q081d2JwZ2NJYTZtRXhHK1BBZ093V0lDT0xHUUtVL3JNSmdGVXIvRFE5N3Ba?=
 =?utf-8?B?ZjUxUUdTRzN4a3RmQUpyakVqQWszK2g5MmFZUTJNbzlTbEErQ2FlUmlPSFRB?=
 =?utf-8?B?MEVMVkdkQ0VJNnNwOWZXVVBEd3UrTVZhMmxTaDVKcVduOEUxMDhieHcxV3B2?=
 =?utf-8?B?M1B3VU1ndUt4ZC90d0lkWnh4UUptZWRNYWJqOXFvRGlyNkF6cG0zaElMd2t2?=
 =?utf-8?B?OTBWai9PL3VQS0lXcmxIa1ladVFRS0I4UlpNSkQ2R2FETHV4U1Y5V2RiR3E1?=
 =?utf-8?B?SEZvZzkvODdrbG5TMWl0amx6eC9pcW9ZNm9oeGZsNTFPWkRhbHJ0R2laNExu?=
 =?utf-8?B?Wlo2NTkzMVl5U2h0b1dUZjFINFRzMWEyNXRrdWtRUENtWWt0VHlOVDR5U2hV?=
 =?utf-8?B?b29DTE9pbXQrVmRBS1FPZWN0eFhRdFZlYXFFdUpabEYvU2VPZjlSU2ZuME1H?=
 =?utf-8?B?SndlbjBtYlZWTGE3d2tlT0c1ZmdmbVVlbzVYSThVZFgxcTRmZ0JQWDYzN0Iv?=
 =?utf-8?B?dlZ5akcxYjFreE91bm9YcDFoSEtaYzlhcVhZdVZibFdNU2QrUG92ME12c0tF?=
 =?utf-8?B?bnhSY2x3d2R6T2pRYnA4U0tDUmgxT1hMWCthUlBJcnEvcXhwTE1kUnZLdEFV?=
 =?utf-8?B?MERvVjdyTStQalMrLzZsSURNZmhKa2ZWS2l3amdRWXRVL010ZnRHRXZjeitD?=
 =?utf-8?B?WTVwNzRob1NMdU5EQXVDNG5OcFl2bTB3K2VxYmptU1NNc09oN1ZHS3dUWEM4?=
 =?utf-8?B?c0Mra0dYaGY2ZHJraEIvVzhWazlEeGxWYVlxWjhZb3o1ajY0YUlDQVF1cFFh?=
 =?utf-8?B?d1EwclB6TFcvRytyeXJkSk5Va3N3UmplZkYrRy9QMEtWUjhDUklmK3NtelVz?=
 =?utf-8?B?TkNXZnNseXFvVFVUMytVL3h6azFXaVBza3l3UHhGZTcvZFlnUFJTclI0cnBn?=
 =?utf-8?B?YngrdHZHbUZvamptbVdCOExyL2F3eHBFNW5aU040dDRFUVNibkUzTVhISHpD?=
 =?utf-8?B?eGxWNDdzWWNZZDY4VmpUN3JsRlFINGt0cks3NWNSRU9jZjFhblJ4TmMrK1Fl?=
 =?utf-8?B?SnovYmdGZGs3UjFPYnBDOFVOY3ZMNUhqTjVHdFVGeCtXZ2VXTDRYdlJONi9U?=
 =?utf-8?B?Q29DRDcybFJFUHlDUWRUdlNGMUtYb1hlMElyUTZWYTUxcHFGMFZJNEdPaEhR?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pRqzGsWxll5l9SGayqe/CG6YqaHqVzINCR0q4UFWOoMP0kmBMROwRtARpQfTeFRhycv1RmvW32L88c1F8d9BEYDaW2+Sqdf5jqT+vOlO0WopgNsQ1dFmkmIxpwn4xE1IF7+jcx2BEIUjIBEvhlsKGTdkg3hdyF3Lv2F2cTUgUqrS8evjmGmYJT6rdP54cY7t2ylLdzKnp+qEDrRin+LDshZyiW0t1wL0Um1A6+/W0AMwolWYxcVmwZyQbht4AYjiXRJMPpFzjYq4BDGU1aj5bTiR6qiPvxjiNw+6ndRxI47i2JdzmCmfv80YR/SacpOZehDgU1lbtrPZfUTYsI90MYdzXI/wupGR7oIG6vopDgsz8fUv3TsS8nbEBl/49M0PjA7GBZsM6mgrdbKb9hUbJAoeMqj1FXz8ifJogoXHz189UTHd9MW1DpUZM5QVKeoF+UW5UtP4HcW9GLh/ItpIswuPRJaR98FLIq7N3V44F1ImzrnwvGkCmNE98a7LAxXQ96nDohNGY7rgupLka7/vqwggJH6EZkFhue2CmA2qF5Ho6aROTq0FfOd8Q/gWgA3WgHfiit6XLiSsD/p8kxQjQVjOzSoVshJosRbNazLeS6k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 791c8ae0-38b3-492f-e344-08dd54ad50da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 08:29:12.1969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EaPjtNxl2K/RLbnyA5cn7RkOOHkfb5L9jVI+UfY1ZWYZjJzwbCGXhjttjysLVipHk0nUusKMDPkVbZtQyMOmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_03,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502240061
X-Proofpoint-ORIG-GUID: mTZMj3Tdjx_nlsX24IB0DThmA0MKBTRk
X-Proofpoint-GUID: mTZMj3Tdjx_nlsX24IB0DThmA0MKBTRk

On 21/02/2025 01:59, yangxingui wrote:
> Hi, John
> 
> On 2025/2/21 1:35, John Garry wrote:
>> On 20/02/2025 13:05, Xingui Yang wrote:
>>
>> -john.garry@huawei.com (this has not worked in over 2 years ...)
> Sorry, I used the wrong one.
>>
>>> the SAS controller determines the disk to which I/Os are delivered based
>>> on the port id in the DQ entry when SATA disk directly connected.
>>>
>>> When many phys were disconnected immediately and connected again during
>>> I/O sending and port id of phys were changed and used by other link, I/O
>>> may be sent to incorrect disk and data inconsistency on the SATA disk 
>>> may
>>
>>
>> So is the disk reported gone (from libsas point-of-view) after you 
>> unplug? If not, why not?
> 
> The problem may occur in a scenario where multiple SATA disks are 
> inserted almost at the same time. When phy reset is executed in error 
> processing, other phys are also up, which may cause the hw port id 
> corresponding to the phy to change. The log is as follows:
> 
> [ 4588.608924] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy2 link_rate=10(sata)
> [ 4588.609039] sas: phy-8:2 added to port-8:4, phy_mask:0x4 
> (5000000000000802)
> [ 4588.609267] sas: DOING DISCOVERY on port 4, pid:69294
> [ 4588.609276] hisi_sas_v3_hw 0000:b4:02.0: dev[13:5] found
> [ 4588.671362] sas: ata40: end_device-8:4: dev error handler
> [ 4588.846387] hisi_sas_v3_hw 0000:b4:02.0: phydown: phy2 
> phy_state=0xc3 // phy2's hw port id assign by chip is released
> [ 4588.846393] hisi_sas_v3_hw 0000:b4:02.0: ignore flutter phy2 down
> [ 4588.919837] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy3 
> link_rate=10(sata) // phy3 is assigned the hw port id previously used by 
> phy2
> [ 4589.029656] hisi_sas_v3_hw 0000:b4:02.0: phyup: phy2 
> link_rate=10(sata) // phy2's hw port id is assigned a new one
> [ 4589.220662] ata40.00: ATA-9: HUH721010ALE600, T3C0, max UDMA/133
> [ 4589.220666] ata40.00: 19532873728 sectors, multi 0: LBA48 NCQ (depth 
> 32), AA
> [ 4589.233022] ata40.00: configured for UDMA/133
> 
> In view of the situation corresponding to the above log, the 
> hisi_sas_port.id corresponding to phy2 has not been updated, and the old 
> port id is still used, which will cause the IO delivered to phy2 to be 
> abnormally delivered to the disk of phy3.
> 
> After force phy, the chip will check whether the phy information matches 
> the port id and intercept this abnormal IO.
> 


So do you mean that all IO to this disk will error? If yes, then this is 
good.

But I still don't like the handling in this patch. If we get a phy up, 
then the directly-attached disk ideally should be gone already, so 
should not have to do this handling.

Thanks,
John
