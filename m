Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB89D39FCAF;
	Thu, 21 May 2026 08:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779350725; cv=fail; b=jihz93uaHqPvRn1dTyBqMNcEYHOOG3GslKV6jFOdzlP8SxlT7L8HuD22cMyX+A7oBHMulaXMzWDn8Ionyum8E7q6JlIZ1OsLrjyxAmViB6sZKEYzVc7dcU5y781xv2Su0iccMcjkNpQKLz3SdoJuElQfDMXQIRBVKbzx+emJnBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779350725; c=relaxed/simple;
	bh=itpWHqG0kNdXBNNPtWrXQQOTodO12eUdpW104yh13HE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=stTTOl3b25JNr6rUI94k3CZ5QxfZpTYYglMpKjvG0LgVimrd7N4SAE4elt7D0ZzXhUUkOnNq9rKe2LDQsnq1kNt1hz0tnBnOCwrRxwF0VcknyOhV4hXaRn3cNBZwnPvRTXIiUZ2OIkU89fr2OJiX7xeGsipBZY0dJFzXOsXV8kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L8S4OqcT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EWY4Ei2p; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L8S4OqcT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EWY4Ei2p"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L1O9Vu1419307;
	Thu, 21 May 2026 08:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/8/03Q9ecL8aMmEjF0c4nFTry+N8VdCrphP5HPXGX9A=; b=
	L8S4OqcT2sAIxIr02GCxwYx34/idqlUk+jbLxLMk8Ba2XKzBcGD5GFBSxxVdsWNr
	ZbJOHieaqel3CjyYpappZ5QWnUSnP+iE2y0IZV8jzjyD8vjNMjTSuX8ofI/DvAQD
	HTCAZOi0jCM7/EYYBomemG5/6IXdcM4desKVgzwIKEhgMc1hhZFOpx8GaGZEsp40
	cgY/qcikADdiAUnPWQp456+rFI0Xp0Ew6SoZslUXkQ1l8sN/X9P4ZdGFT8Nutawt
	2ViseUrznOeTV7fnokh7jZmYQFGWXNNehJXOpbfX/L3tsA9hM8f+Ltfrxs83sj3x
	nBeNnlz9v+p0MnxWF2FG6Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h2sgms2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 08:05:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64L84wLu029744;
	Thu, 21 May 2026 08:05:01 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1jbqhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 08:05:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tClzf1LsiZUR9q9ABiq4fIsUK7qOaMaMsM4ljLDbkicpwRb2YeS2IGrNuijraCJAETddMqx/m7hc41yM81o9TIFCjaZQrW1318SHUwrgoOKucHRxa9BZiCkZ9ssOcAKUzGOg2ThKCFii2B85+2rovqtDA9AFuqraTAedi0BErNRfW+2S4XILyeKy9eBVQClb9uVXnU9RGfIMwdzn2KIHye+NQ9/mmGNwLrN6PY5BNJtgs510eP5+zIDTV7rmej6q642eDnU8HOxG53ztVzmmAQ91KKey4QeSXsZLeS+49FwSg6Muz1NE+GHY/lgQ3uNExL3Xjzgfxw7jFRVwWNjKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8/03Q9ecL8aMmEjF0c4nFTry+N8VdCrphP5HPXGX9A=;
 b=h664DkWbxIvX3McXzIRDq4BhqR+aOEuWdFy15b5lLFbLkSp7p1s32uj0Qiul0TC6IOzx+y3MPaBYftnLcEh9YkqUj0ZhLtvueovQ0+pZpe65aYl9nnRwDvbX4zjlqzfvbVNnvD95+NOxR8UThWQlIUkpYylbFiQKJWW4Dtwf/AuBh75cHZwg5fn6Zp8h+PDQYA+uYWtdsusFfjahOOSeB2e7Gsvj0MJG3ZdCIkQQzNREgZpr5AsCBKlPVWjAuI4ZOXYpuHM/dgNfRhXxw7QUl8EAQV0NlFPWp3Q+B2VuOytuE4L1ik9GdPV7rdiwVEYt0zWhdJy3LPYpIxhq+5n+qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8/03Q9ecL8aMmEjF0c4nFTry+N8VdCrphP5HPXGX9A=;
 b=EWY4Ei2p/dCKFoXnYNuEUU5wIaldzd/q4pyBNNUX6pgsUFR8VcUC6Jt80ljTKKPdPqjfATsg6ghDOPpyLtqjbhQTJlUl6l3K0WhzzPagHOYXU0damRU0ITYrRkTZ8QEHAHNzMVSBjZw+A4dNobFmxDWeVx8xM8DECmW+m+D4zew=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DM4PR10MB6256.namprd10.prod.outlook.com
 (2603:10b6:8:b5::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 08:04:41 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Thu, 21 May 2026
 08:04:41 +0000
Message-ID: <7a6fa9ec-9f5f-46a7-b22b-542e493ae8f1@oracle.com>
Date: Thu, 21 May 2026 09:04:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-2-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260515084531.866259-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0510.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DM4PR10MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: e4199d53-7c52-47f6-0b9b-08deb70f9c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|4143699003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	DT9iSQPSkb1bo54Q2F6XiWXKAyfdOTMNsrCpeXUmqwgta8fihBkYACOYVnPM3R8kFFmTAxLwV7fATmFObM7zfHIirQp0Zym31Z/t+GPdFtEVQjjX8Iq6wFvXI/q7Tq8xI8XNhxLY+caKU+XuBVmfeynBvEfoVUBUqgLW6fVre+umIAOH6tklOgsRb4bk+TgcU/kY1tpt+TtG53upuucuSZtkNU/SPxs8nWq2mX0f4hEFCusCadbWgEKFW4+iD7l3wty2ndjTjWwWVKV1eOQKOkjLa5soCskvTeNkOFP5HxvlQJi/Skr6hQ1wvs92+hTtzWf/RblW7zbnpZAb7h5CV1oMuIy7Sxn3v5uae7p4NDOaNog/jqZQYpZ8uj+T7/0fA7ncHvZIgcF2dAOtbkVxPoCgsnYvwa4Z1majcJuTPxG8y1ttQxNtE6pCQfdb2fkZTvGt0bOl3xlyCUZ5+spsB31m2EtWqH5Yq/Tt9O/Ag9PeWfI7T24u0UzGBHfRVsWZgf6PlrQdbcpnHuFR7hvdjIiOVaOGkCihYpFcuh1uwhKrcUHKC+ChlFwllA+j2uklIr0JubHcJUWSMxQll/JGBfZ4V4R7LqOv8ZSw+Br7F5j9VRm6GT9S3SzoZ/Bj9ArNPUy5DBoj4r1Zus+6dm6cHBBgIe+p939Vw9UwWph812n8p+gDvgu95OsIfQzE7T+W
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4143699003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0pCQzB4aHIrbGdndWRDd2ZmTzV6VTczb1NsVWVsazBNQURyRUxId2xvOXNq?=
 =?utf-8?B?TDRPeVloRlBoT3RRdko3ekVPdmkyelhjcDFPbTlDcWN3TEdzTmlmQmNSWHNt?=
 =?utf-8?B?UUxmbDlka3pCcGxLdmJ0aGl2eXdxZitxbzFiMzhDWS8wdXRnNm5xK0xlQ1hG?=
 =?utf-8?B?S0Ewcm9tUFFmVVIrVUt3Q1E4c2NubGExRXRuMTBJTUtDaUtxSjRyejRsVWVy?=
 =?utf-8?B?N2doNEt1THVMY1Fab0RScUhpNVBYT1d6R3ZVZVlhV0IyODJ5SnVHRTJ1dmxi?=
 =?utf-8?B?SlNwSDJRaXVCNnhwTnhKYVhWeS9zNHhTU3RBWlVuRDI3M3RYN295ZnR1OVBE?=
 =?utf-8?B?VjFMMGlKbm1pVWZNOCtxb2xwdTZEVEZzQjQxZEYzcTNacXlLSzdxMEc5TWVG?=
 =?utf-8?B?aUFkbVovMWUySDFZcklVbTNRYzRmMXZUdDBZckR5ME0yNGJ5cHlFckRXc1o1?=
 =?utf-8?B?ZXNJMngrLzRkV0xITDZsa1A2OVg3anhpOW5kTnRWcG1uSkVLZkdhSWh4ell3?=
 =?utf-8?B?blRiRzZKU09YRUk5VUwrY2FjQlhvbW9nQTl5S05ycTZHQ285d0hjdkpQU25Y?=
 =?utf-8?B?VCtrWGRiMVcxL0VYTXV5NkRVZCtkQ0JJc2NPVXl4QWZFSWVsMXRtcU1uTkxG?=
 =?utf-8?B?VXBOV2w1Ymo5bG9IejMvNkhWYnVuNGlMclB1blgrTEZNN1VWOTdiTUFzRmlC?=
 =?utf-8?B?QXM0QVBONEtmWnpKNlF4YW1DODJPcHZzN0J1b2lQYlhZZVZ3Nll5K1BaUVVC?=
 =?utf-8?B?eVNrd2dRS1g5aXhsNzdWaVliL2IzMDdHaE4ycGVicHhqc1N6YTNqUE45T1hP?=
 =?utf-8?B?a09WRkdoTlcrelppZk9VQXllRWJCblo5bFBZSGxNUG40OTF4ZkNJWWJYbXVE?=
 =?utf-8?B?TUl3YkVCYURLQXUvdlRNZUc1V2xXS1pKeWJoaGNjdXpjZnNSQ1ZHS3hQYzl0?=
 =?utf-8?B?VnY1WXdmUmxWUXZvMHhhQWZ4UGpRYlg5YWptL0JCMUNMbGorYmxGVVA4TVpB?=
 =?utf-8?B?T1BjRW14MzZjajR5Qjkya1AxTW94UzBOYWF4VDIrZVVYQ0NGZUUrUU4yYjlw?=
 =?utf-8?B?MkZhUC9vL3J2ek9DUVBWUU0wWXd5Wlg4dDZiaFdxN2l2dXFKZG1zQjhLYmFv?=
 =?utf-8?B?S3NYRmR1SkFlRzA5eUhuY3RRNTJJS1U1VWJ1SkVIZW1xcE1jUE5WZEJyam5T?=
 =?utf-8?B?UDlqRE4rTWpsZ0hJSVZPYVlteDhMeno4dTRCRGxnWTZvK016cHhlN2N4S0JC?=
 =?utf-8?B?TlZueUhZRjVJS2FkVEpqYnB6SWdQckhFOHRxUndwWXQ1UVd0eGRNZmZ1ZGpx?=
 =?utf-8?B?blRGampXeVpQVXZCTkxnejZ4TmZtVE12cHhEVFNhYnd2Y1lySXZocDltK3hL?=
 =?utf-8?B?QmF2WkFJUnZITTlmcEltVE9qNFN6VkNrcHozVisrdnNnd1NKa05maEJZRkRQ?=
 =?utf-8?B?V0J1bnlGQkoxay9QdEZta2UrL3duWFNrMm5WYzhaMXAvY3FRYjdrYzNXbG5V?=
 =?utf-8?B?WUQ1bDh4dDJOOTh5cUo0UHpQS0dNNlY2Uy9CeGI0VGZYMVZZc2NWK2RZR1Ir?=
 =?utf-8?B?WmNRZExrMy9WNWtOR3ZPQUVQMkNDbEJINTlnZnBjZ3JXN0M3YmZCZ0laK2dl?=
 =?utf-8?B?N25rRnUxNEtIVTZZcnBBWmVKNlNqeG1nVkE5WkRnK2M0UG5TeDVjMWxCZjli?=
 =?utf-8?B?MCt4c0pxVUJBTnZNTDNwQW0wY0RKZUp1Z1BEQ1N3RndOSi9QUUcxRnBIeXhK?=
 =?utf-8?B?bUlPVDFnWGkwekZDQkJjMzVSOWdhaGpBRjUwbWdzb1oxVUZ6WEZEejN4cjdK?=
 =?utf-8?B?TktibGl6a0NOUGNXT2grWk1LQUt3dVZ0R2t3Q20xelRDZWx1NlZMSzV5R1Ey?=
 =?utf-8?B?UHA4SHRiNDRYZkR3ODQ0V0cyNm9oWEtnZS9oWUN6ZUpXSGhYMWl2Y0RNWnNV?=
 =?utf-8?B?ejE5WEZrS0xkVmhMcFQwUGUwMW9zRDNzdFNiNmhLeExxSCtMdmV1amsxcG9z?=
 =?utf-8?B?V2NHdGVPcmVONE1DSVI2YTkzMzZkMVZMMllXMk5aMG4xZ0c3OTBnUG90a1Av?=
 =?utf-8?B?RExUOE05MUJBTERuUzVHQ3lIanlOQnlVeG04eTN3UkxUT2V2ZGI1b2U4NDh0?=
 =?utf-8?B?Q3Q2aGowbERuYmRqbUJic1IvL1VKOWtpNzFRZ1lhNkJmZDUrRkIvS1J2LzlH?=
 =?utf-8?B?ZVNMeW9ESytGVmkvY3VodFBTUGVHVWFqZmlUdkpUdW9UMGxGcnR0Rk1nN0Yz?=
 =?utf-8?B?Tjd6ckU3SUxLWUdSc20zS0hNZENIZTlaQ29CbVIveG50SUJTb0J3aVRtbUFQ?=
 =?utf-8?B?WnZ0NnZ0c2xaV01iWTBOSnZKbzNFS3FIeUhkSFprMkNvQW8xZ0Qxdz09?=
X-Exchange-RoutingPolicyChecked:
	Yq8dE6xTAMqfrJki/OPBwekkfrBtdOvKKvGa1B9KK/whUMMO8Atjje9x07YbwC4uihZBE6zH/sCUA6lvPkmu9/BKXhkv9IMOsXQfbAguzdWT/Kyv5cwzl9LadrT3c5i/zrFj7DMcaZJckxaFMnvmPZ75FItbjzhsWD8Cg5SKDQYrVZkwbfEAZ1WkVvEonUkmaLZh1dUDSbBosrIRUNFa5kZftu+5unLq2XiktCUaeJucYSr24XCFyChpQz1VhloU5VKAZ8e8TlTJ3zXCWkhHKK/c2wefsOaWBIoTGvvj5KDAQE6ygp8SdSfDPYPw9at/W3OoRLBQeYsB5ygjMJM7oA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OmCGsumM7K7cCxjYw2O+tfdysl6VddxJBg1CEXL3tXWERy2VkYBpVMCWjeScDDX2iwg3qg10EfSX2XU6hXeAmZ0yrMmXZ93lljLzRLOAs4/1L3C/Hm4HpjLhSzr2H48awV7ou95Na3mpDpWJbUuBU/MjaYyLSBOXIp75/XtJlKruJonfRDl4p+ofICZrqUAemp30uNgZ+6KFkun4lljW/2CAD2pHy79Jg6Z8bpJnQWO1XVjRxzP8ndoagBRaM8TBKtSVsxsPyNcoV2ZR/TrukgeCV4wQ6sJY2VwHDyBGSmHXcDjjkWEBnrwMUmXUykjCIiMMDkP5+bxrDFb/LKhO+JDprd7Mo6C5tWrpzDaV5qglC6CYjBUFS70yIiQMKYgM5Qtjw7A4PHE17M9w3osQej7w7pdy/cRVkjDEOcdeGIlgDKx0hQeHYKo/XfSMEuUUpLfEAc4QjcnSGNONoDkCpyX2nMS7UiYA4TOzKsA64ocJAkiubTXaGkajaENH0ciI7kKbMej+mWIotXPo8t0nORL0vdm4qERblQQP1sTs7A+NZsv3gaqaQQioDJym+h3fDIXd41NxoPIDmkym9dNPNVgPIq/NlnhOMLM8zLHbloE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4199d53-7c52-47f6-0b9b-08deb70f9c79
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 08:04:41.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zcGSYCCXOfq4ISK6DACUTc9pw2wWOH1/NK6BwsNkz3qaxwEHCDp3sa1VKi5oT71lwqH+pMiqrMN2fYBMvfvNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6256
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605210078
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA3OCBTYWx0ZWRfX8Vxq9RIpaU3L
 pefYRZ9EDHWxtH0ibHEQNvzMwuGfAxTtDug4LQOQmM4ZL+mK3yervWfUvRyHREyAZbF8wmXoyNs
 Z75evprPwhpbGYNly+63SZyp4+vG6FRoXeFoeghjY0CgTyn5qx6dXJGnweKy9ApUGU5OlPunFrL
 7Nkpx4ZJVNuvEUGK9ZodFkQLPr01xNoF6GSwtxDBQEr+HjveYD7udJY7ms05XaE7jESab81FzrJ
 IxFLpy8kqRKcIeufu7sN+Eh5l4weaLIVcLjowE2hcJ9nm+ei6o2J78JN/KmL5Vyw0guU+DCAtn0
 YIZkiCh6y/3pVVp+2cGozqOGA0P0rd+OBo99+DJvnVHZWtyIr3j3HcpFrhOrfzfMeEi4sUEpjdv
 XRsWFPXfqx6XjCIvuLIcex1vJ5xR+otzVtnfuSbXXCtz6Lik/VphUisfEU2nAb4D5d86be7QzMZ
 ktM6KTDTfWipR5cO7MuI2GoC+UsDiM+ak6nPM/cc=
X-Proofpoint-ORIG-GUID: wICruQfQ63hJgXqEXwsdss-A4SlsMvos
X-Authority-Analysis: v=2.4 cv=dc6wG3Xe c=1 sm=1 tr=0 ts=6a0ebcae b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=gnhGwwqrzdVPENvbM0MA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12299
X-Proofpoint-GUID: wICruQfQ63hJgXqEXwsdss-A4SlsMvos

On 15/05/2026 09:45, Xingui Yang wrote:
> The sas_ex_to_ata() function checks for an attached ATA device on an
> expander phy. Refactor it to use a new helper function sas_ex_to_dev()
> which returns any device type attached to an expander phy, improving code
> reuse 
I think you mean that later we can improve code reuse. You imply that 
code reuse improves now in this change.

> and allowing other code paths to find attached devices regardless
> of type.
> 
> No functional changes intended.
> 
> Reviewed-by: Jason Yan<yanaijie@huawei.com>
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
