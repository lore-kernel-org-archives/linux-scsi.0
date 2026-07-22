Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51249472F6B;
	Wed, 22 Jul 2026 08:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710050; cv=fail; b=jskvw68Yh9fcPO5+FACv6D60ol3Try4NjUWP8IgGYXHSzvFB3uKMG/ouD7s/IWionEbnlpUnzSRxK8K6cJfa9qTKbyBWkUNDABvejp1m4fFFlhENAJWA2ad23M4PXzLugsgwzCAsLQHjQo4CR2OVckfmN2+unbb1RvrIChcdi30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710050; c=relaxed/simple;
	bh=+vES7thtRMQQj8H3E+KqnI/2cR+6vG0Jb8Nynt2qt5A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h2sHh4/kN1aecz85i1xsFIngwrrVAxfXJEa/Yq1GNZpr9QglJW3wOkfYHVRg4buLrDL3tQ1An/UrpPmT6M6FzuWKB6QPBFmDRi8umcWxIz0B0EWImC0u2+YZhrYY2ZlviT7JOCs/rFPwwnbhuu7IAjnTGpJDEg8xivcoxQPig6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L1SIhbsu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N2Mp3DWp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L1SIhbsu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N2Mp3DWp"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M4E0aa314268;
	Wed, 22 Jul 2026 08:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vdGbGssN24XTnRhUUcucXCCZiYRKcrdKahCIPPxmR8A=; b=
	L1SIhbsu09ymZ++bxBeSKkRzDfcjo8FG9EDQpw/vtipIA+K2H6W5AOxMEmFS63jW
	MDvi6tjjGwkjiCld2OFk6iBZOptHC1+0iUuSFfwJeK0HzCPc+Jh4Lv1NHow+7Z0v
	QX703Y2fEuHQEqklGaNs+VLzq5DH3LqzacYekRTS9WMUutWGBWuPfRrIVzpXTuEf
	/YhOqIbe19jJ/yisxXlzllCt4kimD8pWRDxcTUjXGKvGHlIK0UchkjBkX9IFrmsq
	B516H6kmK9Me9Tx5UnsoyWdzBO48m/l1cQ+BqOeTBMqzK5OB82SP4r71OKf6H/R/
	zO3JpUmICjgDnPrGwps/Nw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv4u5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 08:47:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66M8hWp3034613;
	Wed, 22 Jul 2026 08:47:13 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxqqdav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 22 Jul 2026 08:47:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgTaIZ2A4g59/8xteCA2ZQ3fjJXmKTKkwiRTO22xUPqMwAoAGyKdGT0932zzQdh+lkQNEixRA3i9BXpwzWmfjNEelv3IOJ48l2fRzLmhE0Em2rocKJbE4fQq06tUU+I7XJWQJlfD/ElBga9ySp1Fo8uxxnGFu7EI7HTfSyf0KdZSdwLPJ5L+N0d4ET6WXwYWKleYM5yYxVdrMo61d/sfyeP2HXUUN4BvTSor7Iyn9zM+ilTTAa3PDTrKhORZ4EUA+eSaRXmo10zNw1WYzCASjG+XDqnyBJIduVc/345WotYQOpIupoaMZHtuY5wM2et+CEpIGN2C/r0fl4VwaBLKTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdGbGssN24XTnRhUUcucXCCZiYRKcrdKahCIPPxmR8A=;
 b=YxSeqM1/GaP3amECBxCZ3snZfdwCH/5KqDqkn4SzrKayQh5IROOlrEpFDg8gm95EIvHN7tFKx3omuaJweM5sytQKUesvzV77O7teptJ3JjBZF+en50ArpmUkmOcAVPPZiHzJQdxWlbymKXaOK1Tj9kt6c5p3qMMF/awzfELgKBzX3H+hsBYwCSrSBQtNA+izpnKvr1XnxrCT1zsvOFFgxN50vfG0MtO6Zgjqxo63xMJQS2cODD7rZUIujRERfk0i/yEFDn/UHCUurcAGtoYPajHGAu99aYqINdczPfoAkqNVXMthhHBUkDBddu7dR2ehyONgxETw+gSGV36y0iq9EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdGbGssN24XTnRhUUcucXCCZiYRKcrdKahCIPPxmR8A=;
 b=N2Mp3DWptkqb3KLWJRoZy4KCynMOWG6pehHnZcSrY/QHW3SW6T0Cy+uGrF+e2CgAfkd96tPldN2/03KbqcaOVkMrGUbepM19appByoXz5umhMuf8/GIAvjp1I3FVR+i+tHV0hkaB5mROdEP3Au8fuE5Sj/yeq9v/Wv3Kc/fXMRU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFACCDEE1A8.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 08:47:09 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 08:47:09 +0000
Message-ID: <c5390973-6db4-4191-8330-dea5830da4f0@oracle.com>
Date: Wed, 22 Jul 2026 09:47:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
To: yangxingui <yangxingui@huawei.com>, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, dlemoal@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com,
        hare@suse.com
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-3-yangxingui@huawei.com>
 <c9a91dd7-b158-4416-93bb-9ae1e1acb8a3@oracle.com>
 <55307987-d86b-f28c-7c39-0a6bafe182bb@huawei.com>
 <a2ecff55-aabd-48b4-a702-7e052646f22c@oracle.com>
 <7baf77e4-345b-3419-6562-f0e435227e5a@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <7baf77e4-345b-3419-6562-f0e435227e5a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFACCDEE1A8:EE_
X-MS-Office365-Filtering-Correlation-Id: b5fdd4cb-eb7a-4e90-b8ca-08dee7cdd0e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|3023799007|10067099003|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bC9rSXylaZKHTodQaIL2cD5SuolDLWd+4Ya4F3nlJLvLz/Vd6yL5jEinR6tv31GQ7q66cPnaDRMf3RWZF9DsedK5dLrRR6J3zVVDbW95Fvwsobfx60ZRvB2rG1EqblRScXwxDMkXN0ysiCZfzu8Gm8hempaySajuGQ3k5WwjvP+gobZN16BHda5LXo9oAevLLRJjiTgJY4rZXiozQ5o/cwUh/wDuUSHBOHO5JD3G2eIjPDN2hhqCnA9JfA2NX65BNuryncjDaCWqavJgbmLQdf+5HXnC1Kf+NGNBKarrPyOGeHd+tgDhON18kful8OghpuBF1/UGJu2wdC068NkybvV9kkk3cjdiH2qRlJY1ruh5blV9osUj7o+DuBAs+BZ8ooL8iFvkdxIh/H6qjXVB0oKHtzabVt3feZGbPDv/35vfY5DMZ0zTD8JDtOAqVhos8ck0aVKPd5Qa6QReGBsp3+LBDvYifNzHnw0PkW5RPywJlmfDATVz+WCwaD9bCLaC5MFrolhe2mF4OrgrNzEnJ9z3BjRfQn5qNgF7gXBLRA1OyD8zrlqPnBC8+WPy9rnoekQLS1fnlP6RpE9ADi49LvmLiCkvMqVIR9i0evjo7dtR26qrTkx7qa4vtUh0sFGCERIFS/Q5ENnR7ICy2Wumniw1N1vH7ZBNinbCWHVyFoY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(3023799007)(10067099003)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHFHWlZRcW8rRndNL3JtSDJGZDdQYUhpb3ZrWjVWY1J6YnkrcFVSK2cvVGsy?=
 =?utf-8?B?V3hGTkNVeWs0SWxLOW1SblFhdGxoYTEyVVJ4blRncWpuaW96ZTNFZS83U0hl?=
 =?utf-8?B?dElxRThvZEZyelF1elhjakR1Z0xKNE5ZbFU1TE1CbkV6NjhaWmVBNHorYVhX?=
 =?utf-8?B?ang2a0ZxUUZvem51RDBPNUNmWTN5Rkw3eU5wT29qNTVHWGM2eEZVNFZuSDM5?=
 =?utf-8?B?Sk5jU2tMdGN2YVBGZkVVU3o5QUUyU3Y5TGNnTGx5ZkdHMmdxT3RDR3NpQkhH?=
 =?utf-8?B?bDU2TEJ2dFE5cFRUbGNaYktMNUc5R2haa2JmMFZwSTF5R0ZMaGF5RXNPcS8r?=
 =?utf-8?B?SVFaaWp3aG5ORC9pQ2F4SU0vYVNPUkdHdFF2Nk96MzQ3UWY3VVZTT3l1NVVr?=
 =?utf-8?B?WTBXSTdwNjZuZ2p1VXFkUVZYbWFmM1k1V0Ivb2VCb05relBzN09QZStLMC9l?=
 =?utf-8?B?Q010UHM1VUUxamQ3Qk9GT0NnOTlDeFdDN1ZaN2o0YW0zR0djWEUyUVozYXl0?=
 =?utf-8?B?Y3ZwOHRzVkhiMTdaRlRMT2dZMmkybHV0S3VFNFdSSndMcVZoUndENm9UbzRU?=
 =?utf-8?B?eVRmQ0NuamVrVUxxT25YeTVYckpjZFR1cjJhcUc3aEpGYW1Wam1DcE5zQVlU?=
 =?utf-8?B?eGZMTUlaZXB4SUt2TG9HdGdlUjhvdnNuQ3dJT3VaU0o0OGRmeWpBOTFKUURO?=
 =?utf-8?B?MUloQ2E4RVgxUlZPUDU4Q0tsb2FuZXBuSEw1Zlc1cDBocWc4NlI5aUU0TWFp?=
 =?utf-8?B?K3ZFVVNHK2hJN0JZMEZNQUNwK1p5bDlhaDdXbjVKN1AxZ3RMUHNCcFBaUjlt?=
 =?utf-8?B?aUU1RXlJRWdtdG03clk0bitkVG4rWGI4ZjRzMmp5VExzYWx1RnQybUdSSHkr?=
 =?utf-8?B?L2NPdVlDdnRoTkNVTk4rNDdpbkFJNkV5K1ZvVVpPNDg1azczUEFTd1BOU1ZK?=
 =?utf-8?B?YUVCc2tScmZUcEV1cjdhNHhzK1JodVBKSmVFdXdqRFNtMzFTNTY5am9QVUlE?=
 =?utf-8?B?azR3VFBpN1pTYmk1QTJJelJUMUI0cktudHNiZDRmSlcrRTBMQnZDNm1xb25L?=
 =?utf-8?B?NWxBWlRwTFQ5aS94SWdMR2ZKcHdERFcwbWErY05yZ3Zkd1BkUzFYSEptN1o0?=
 =?utf-8?B?WGg3VU1jb3ExK3RtSUpWYXVFM0NKYTFVLzlURC8wWlhtbkFPcE1PZ25laGFU?=
 =?utf-8?B?Q1NScGUvL3cwOE1ialI0TEdvK09LNmMrQStOR0ZGRXhTdlNCQTFRT0kranNn?=
 =?utf-8?B?Q0NTdlhib0RwZDZjZlNySEZXRHFzSmFOWXJlTG94ZXZjbmpCeFp0WXoySm4x?=
 =?utf-8?B?Ty9oZFRsaWVrRlVTdUtxcUNBUEZib2M1aFVBZVlGWHVIN3lFc3pZQTliR2F2?=
 =?utf-8?B?WVlNejZMSTRMaDk4KzByRmtkV2lVVSt6TXRsWHhzK2pxdWV3L2d4SFg5bjVS?=
 =?utf-8?B?Q2dhMmNrcWZDZzdFSXphS1BHaStZSlNwM2JGZnhoTEpKOEhnN2R0UE1KMlc3?=
 =?utf-8?B?RlZzaU44OGEvR05adk1LOFFKT3hRTUY5U3FVQUtzRVU5dTlYT2Q1NmtBQlBC?=
 =?utf-8?B?ZEg2QStCR2tqcGxIanoxd21DTlJGbVA4ZTJNem1nWmI2QkQ4VllJMW9qWHlN?=
 =?utf-8?B?dkx5UTdwYnF1Uk0wK096NkZyNm9rbWQvTzY5bjhzdFpxdU9YWDdwSHF2OFZH?=
 =?utf-8?B?QzFTM2JIcVU1ZFNXcXBBbmU2blJGTEJiWEdMcmtyWWE1cmJqaGdhOVNYcVZ1?=
 =?utf-8?B?Tm5JVmdpREtIL3NIb3I0eFgxV05SdG4wWVJFY3E2KzdIcnVVb0J4WkROeGpR?=
 =?utf-8?B?L2tBNEtEY1pUb2lWenNBNXNJdmd3NEVjZDF5OWExU0RPWXVkY2JqZDV0djdI?=
 =?utf-8?B?bjRjUFNXY2xsM011RjJUTUhpaGozQ250YXZQWTdyQjE3ajhvVkxmS3dmOVRZ?=
 =?utf-8?B?Mm0zTDEvdVNSYUNFMmRxdm53d01zdXB6Q2JCd2d6TWVzdnRNWGRoL21OU0VY?=
 =?utf-8?B?Vnl6RFc3VFViWFhJdnlLZTVhMVdIdzNFeWZGZlhSTHlsM0I0eDdKbldNYUp5?=
 =?utf-8?B?TWJSeEJ2Y0JHcDFLb0Myc1hjQnBTRHQzWU9IV0oydWpnM1h3RGJmdkpuVUUz?=
 =?utf-8?B?enBKQzU3SEdWa3BVakZTQWNaNFRGbUJqaVkzdGFQSDJ1LzRjekp1QmpiTjZz?=
 =?utf-8?B?ZnU0cDRxWjF5NWhWSmR5ZjlzUVJ0Tmh6eGNKWDdIZnhIa2VVOENnZnFKeENy?=
 =?utf-8?B?cGlIOEthc2hOaWtncEh4dGk3aXRaS0RxallyeTZJQU9LczFDbjBmeUJVdHhU?=
 =?utf-8?B?VGpuano2K05HRlNlYm5rdG9wcnZ3dUFoVDhQOE85TnluV29XaEtRQT09?=
X-Exchange-RoutingPolicyChecked:
	fLILp2/ajqG7J/0UcW0wwpnSBHzFM6irXsgmY+t91CI2AhDew1RsgHS8sqNjR5xPaqVlfmVTjGiMYSVhgX4DcEtV2Opp82gyKyINYfE5pKApFEqt9BFymmLtVhiXycC8G8G3aYeYa96Vk2nalXe+HaJVFcya2dVNImy31p7KXIcPPjp3uVXPyLpZwiEjvyiD6rT3tmXF4R3MqSdnLyStAE2AJFo3KiC34WvLw2n4w6gomy7If9Sn276mvqtx/vYpwLZQdXx6e4oPZwSdx7rWAQ0hDZspUvmoHNrcWA49P8c7HvYgU5WK+drql5yU+Z4YDqLpE8Lg+0I+pQ2r4QyFYw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CTcEsa3qKTr1uwGu+h2X3my2cZUQfqy0tQ38naXKpnXl5A3g5fdsIxkjZt6vyRXuLn6pk7aul/VWkd1FR1uRm3gZyqm91D3w3oPOrULQWvWPAjRjefctCAxLmdmS6TMX6giqUG+S4z0NhWEyffgSZE2MJ2df5texKD5i8t9M7kcPMAifStV5xa89Op6K3BwDXiXbEFAtRU3MvSNjbJshfy8srQb2nHsPHCKjZ+p0RsGhZS9qek3uNan66YqOdxkmvuuoZ44PR7kVycrbcZc136rhEizIZoGPgkdrO0VAarzI2xWS4liLYSKspg/9jFzJlM2TO0Iv3JRKkgg9B9Sokahp+m4GH/flNBUjDpFK4f/q4p419OWZB9pRg/gp6xKU6SRJwl9+OZVNLEo+FIMIAZIA1wvu6UHF1jWSrHI8e8cwjIAC0wj5kMHq95g/OhbajV83Z5KVYxcieGkIhJ7hZntitrNn7YdaY4B6vthrWKH4ZdJ9SUtAHZB9nKyyxGv0QEzarXJI+c3deyo69rq0blY+spI3iEbc1T/eLiaQbqDx3BPPOlqG7XrbMy1yxkpPmpjlN9hbZwZ0FEYeY9fayWmHxvt3spAS2M6jHPA4cYs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5fdd4cb-eb7a-4e90-b8ca-08dee7cdd0e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 08:47:09.5306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibpVH1e9hXaxrhzGOJm1g7XCD65/E7VmrDPR/7UykZi4TmuytSGhnYJ+Rkkk2MPEmvxGM6bMGnwX5D5NV013Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFACCDEE1A8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607220081
X-Proofpoint-GUID: GLG_KVuVfqaPgvVkM2hPwKuIvQA842Ke
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4MiBTYWx0ZWRfX3AV6aHleD5YZ
 p6RA6V6L1R7HdR7+z/M4uqdjE+adE9DrP+HpGDdAPX1P8ddA74q2emVgd0bFCAcC6f4hzuV6HxX
 2VOQUbV9U56p4/mDCqeCY3YXp8WweDMMIWFAB76YxxsZwRo90eHq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4MiBTYWx0ZWRfX+Ae15WRdctmG
 S64WAl6G5Ca42lq8LzJpygm+qXLMH7ArKx1ZNkEwwtNxVLfd7ZKBLI77uKh/CLJk3FM12y7p4Ys
 v102c6UL/asvy3yvm7T5J/OrxYYbZN6Cpa5uLkpwlZVrvpArW5xTKtaBYSFVNJX3PL8uj7FVaSV
 ONp4Ym1TXpYlPICCaxK+yTGhTa+zOzBKhbIp2nukZAW+QI68BVp4knGO4EEKMHjxzLazqXCGQBH
 w9jcwbSK5lxYWczht3fXmdK9fdAa0hDuuUJYaJrkUVcSb/FnXKFbAX6X+I44ZKPFE5TM5Yx6BOj
 K6GfxJoMONcIHb/0dIC/zxkBW2Mc98ctpi8pZgM9b411q1NruqR1p6ogZgQl0UHhDe6NDTIcFdI
 lSfAaF0zzZ9/exL+E2XBuCCpwdtce2tRJhhGeKWgfGg+34Dd6s2NooAMvr+dnmCXDwFQ+Rkl24Q
 BuqWJUmtlHagFna2geG+clf1yyxWDxw8uz1h/BsE=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a608392 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=ul5ZcQ9YmKhfgT_5qlkA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12114
X-Proofpoint-ORIG-GUID: GLG_KVuVfqaPgvVkM2hPwKuIvQA842Ke

On 21/07/2026 14:33, yangxingui wrote:
>>
>> Yeah, it would be something like that.
>>
>> But the method to solve this issue is unclear.
>>
>> Back to the original issue: hisi_sas_spinup_notify_work() calls 
>> sl_notify_ssp, but sl_notify_ssp is called already in 
>> hisi_sas_phyup_work_common() - so why is it needed to be called again? 
> In fact, the trigger for this point sometimes fails to take effect.
> 
>> If it is because hisi_sas_phyup_work_common() is only for direct- 
>> attached disks, and we need to call sl_notify_ssp for expander 
>> attached disks?
> 
> NOTIFY(SPIN UP) is primarily intended for direct-attached HDD wake-up 
> post-IDENTIFY exchange. Routing it to an Expander may conflict with SAS 
> topology constraints and could disrupt link-layer arbitration, 
> indicating that a conditional disable mechanism for cfg_notify_en in 
> non-direct topologies is advisable.

This problem which you are trying to solve is only for direct-attached 
disks, right?
