Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486A63AAF4B;
	Wed, 29 Jul 2026 15:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338857; cv=fail; b=ipDO2cxjYd4YJT46mHd9w6mUn+zk+c3yVFnWsDWrrLkvGUDwsGSF8c9wDcKiha8D/POqsfsRZCzyUAuoMiBEEKJ3Y5B+ZF5UzvL+sqDoiY3MYyiOHMuBi/wwUpWVFGn9AGx4qLpixdJPFbfE3VFV3U+5NdVsfTJlzm4iZ15YsG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338857; c=relaxed/simple;
	bh=pqgqew7zuMoLDFc14p0Hg3YUmjz6LpNbPRhaNSLePlk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pPC9nRh73WSOVgvjW3NnOTFLAYDJq90RyLWEG5OtHmLPUplY2HyFV04R4gH5QeE5KKhkjeNSnF25BQNRNq/R208ZsTrSYqoOW4kM/ykSrDEabHRX27DnC2cls4XCzsIiV1Wn+5pc/5UeLZMY0DvsG3377dHbhzOlnu44/drHu6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=goAxD8bN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CK2m3OBE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="goAxD8bN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CK2m3OBE"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTK8E2983271;
	Wed, 29 Jul 2026 15:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tNYNqMpRlt+V3uRG/jsK6l0nheNiJ4k3QA8EHVJK3B8=; b=
	goAxD8bNPqzd0Fk9LRezbAyoEB5E3E3NDl/TDiwA1UHJrjv/amkY2Tgqgc7xWtpk
	zP2qbAk4yzFvKPMwCDkiI6AiAxBUwttoQxsCWhuZR+dryJ9X1m7T8bgc4iLMuqYZ
	I+Z9MesWa6qDNsSDjYIH5k6xAf11Q2ziqTPRaYJzLTM+UT3tagDT5xLW8lVbdTUq
	nkBlY7TvIWnSTQMdvcE9NT6QrNmzYL/yaiE5vUZ0NwszHxQdjaxZPOgByDaDQQuA
	7yuvh3t32Hatkc3IxUpBj2DNy6TfN/QNLPecKAWmNeEMNC5QEXSY+dWoqRDsEkcz
	YlN8QiqSJK7xLYQ1V3rSdg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr1de3x7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 15:27:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TFLJwt038172;
	Wed, 29 Jul 2026 15:27:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhem2dv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 15:27:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7Pbhl2O4cRCzLIyPzTZ8O4MfpigBqHOK1v2hy7TjzSJ1bQnvzd9iuMnHfpdvsnhGTeIxgBQyosbxdGuSKTDZfKpqB1I/mqQSa/7fTtTL4bKQiR4mmLa6EIWPj2k/apNjwWkLAwy5K87UbLWD0Zs93TT6xYi6ZYUn/wjmg1a2VvUbQN+WjCiUgVmpo4FNnB7AGdRv9ewS+8xiZUlPOafDtRZ102srI1E3voRLgJ+dPTU/bU9Pdzh458dsLTxQlKRsJ/lRq33LvEA8ljUgi8E6uh8cbVIsGweG6Wy1HlA8GnHWTkdwCF/mPi+4Gn+Q+fUXvIsi+uedplINFpk4exAXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNYNqMpRlt+V3uRG/jsK6l0nheNiJ4k3QA8EHVJK3B8=;
 b=UN+PQnKhRizFxeIxYmWYryJUrWbVQTFdAK0GIbS0BpfnEPgecktwRzgudtkBzIIG0OQtLVEP8RlVy0mpox61w0MTqlFnD7to8xIuWAAN7x2m0WLSHEopgBI1/ouAgFYVRajcKXVfyDrMZW8WnQrxPdhkQHWxdKpZNEncNIedc1V8klWjd8MQJzHmj6Khx88fWq5zu0rLnauFxEWXw+DqwxXIvJzJ5rEgNypFRIC/ZLj9VRcl4wtNz3PxNavNeyUO7OPXFMpuolzPu37zVgfz9AR1oSIokJhw+BefehBoVrIk11Lyi7ovgvDIJdIq0KJr2HHaoP6n8VQI7jnQaFxR5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNYNqMpRlt+V3uRG/jsK6l0nheNiJ4k3QA8EHVJK3B8=;
 b=CK2m3OBEa4yHnFAdOrIbgcmOjKM0OYD0FwfkiI2HlM1Vvyz1htIsieWdtgs8DZlouE+ShOY1wRiO88FXP2Ol0uJt/NTLdUtHiMmWT6otnJGoLc6ucXjoYPisSLEQNi4S3pPQOwq1fD85Jggtg9IDM1xVD5cRU6CLJ6xq9oE/j3I=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN2PR10MB4335.namprd10.prod.outlook.com (2603:10b6:208:19a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.13; Wed, 29 Jul 2026 15:27:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 15:27:30 +0000
Message-ID: <eda5898f-ff5b-4e4c-b7a7-764d81de23a4@oracle.com>
Date: Wed, 29 Jul 2026 16:27:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/27] scsi-multipath: revalidate paths upon device
 unblock
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-18-john.g.garry@oracle.com>
 <20260729145423.D8E481F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260729145423.D8E481F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0647.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN2PR10MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: fffb0345-d1c8-4324-178d-08deed85e731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|22082099003|18002099003|3023799007|6133799003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	vZ86EaF/MzfyWp280efyjzeGDNLkwh0HSC3UlDmZIEgL7Pv91jXzLPzc2WFM6/q8A3Y+YSZP8i7JEuY9rnv6om8pCRUVFl65m3jT3+m5ELclJK22hUEhorn3H+wzwb4QsZmzPR2X4sjVlhWAf2smJSb+n+KooXz6ZUiWs5GBf2H1aPaeAp9Gd0TYWetdTUgBYAikHDTYcZup08bYxQyv3vIltQ0vV9f1wFG94D3VrlGx3l143mgfo7DVhjO2QES5xoiD6v0F+ykeRxv17jJdx+qxHCEIrGIkvbJ/za4KbqlnFhcA1PTaq/GCJQIyXXzEQr31G/cqGno8VmF6qApUfwg5xglP6rU/FYui8QJRFcypZBOjrmKHyctT7TQBh8iff3cu/mpwcdGY7Cbw8q/WCQaC85CZIgGE84HrGqkQKpltxK1VzcZEsdVPRpUrCdOSkdWcCAJyXSApNA4I+JIju53WoVWULBH3G2esZi9nNCosicNwoAyKwGHe+kxXys5VhyfngnwMYaAkGH0r0m5RjdWE/XlfPYjw6eMTfeqyh7UFScvdfJzJ6xZNcLadiDzWkuPp+sF/RP6CwPnRnd11Jboyb0Po4Y/z0vd472qWGJQ5yWNgsFGmzKO9YLwGCOkwFR8A2D87j9vdLS+17mMqkaiE1eD54ck03mK97rcYhos=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(22082099003)(18002099003)(3023799007)(6133799003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QThISWpOUVhscUdTcGxEVTN0VFFLOFIvNmlSSWhBTld4N2h5cis1OTQ0d09U?=
 =?utf-8?B?WitYRndRWmk4bW16YW1WUmJrUDBRaUZoanpidWVKclc3cnA0Qm5Uc1dpWjg1?=
 =?utf-8?B?cXFNbmNYcHE4ekpzbG4ydkpiTVN1VFhyTWVQL0lWbmY5dm5xWmRWQXd5ay84?=
 =?utf-8?B?T05FbFo1RGZyY2FaOXBtVTRXM0lzMG9xbzd4RFcxQS9DYjlOSHNvRFR3Y052?=
 =?utf-8?B?YXJnbVl6UXp5OTJ1ZW1WeXgxSXhITmJUcWQxcVFyRklBOS9KY0pNZzFsTVhV?=
 =?utf-8?B?a0VsK1F6VHcyK2o0Vi9uOS92QkFhN01hSWxyUyt5K05MaDdrblRva3B5dmtF?=
 =?utf-8?B?dUxyR28yUU5DQU1iUTRncm9Zd2FUUDVGMk0rd3NaVU5wWVVnS25hZG0wQWZu?=
 =?utf-8?B?emZ5Zmp1cm53RmE5eWt0K0lSOGZpZm1FUlhETmJXYkZGQjgxMW8xWlY1S3I0?=
 =?utf-8?B?QlJKZzJNUk5ZeVl1dVBOUUdveGNrdlgrZTl3NnI1Qkd3ZDlmbzVWR3AvTm9V?=
 =?utf-8?B?UkNsMnNQWW16OWo4ZmhFVWdKY1ZEWUdQRjhIR2RPQjY4VVFFaFp0T3VDdU9i?=
 =?utf-8?B?WWZTTnhMYm02WlN3c2VVbmk5cTU2NlhmS1B2SzFmV3E1bitPVHlEZi9UeW5h?=
 =?utf-8?B?TzY3anpoVjJEdFJuTnZYQkYycDBBcHcvZklGN0x1M29obWVHZCtONUtNOVc1?=
 =?utf-8?B?S3JkN0F5LzFjZldhYk05Sk5XTk1oam85dGlHQnJBRWRsdjlpV3E2dlJVZzVm?=
 =?utf-8?B?UDcwRFhmNHpNQVhYbFF6OTd4WjdwYnVPVEI4MFhQNmdqc3BLWEtnTDRNaWQ3?=
 =?utf-8?B?a2xCZ3JLMHhZVWxsWWVhQUxGdllUMjkwL1lYQ1BmYmFlWGxrZ29yTEpPSmlJ?=
 =?utf-8?B?ZnNaRHpUK2g2dDdHckZxckpNeE8wM3MzVnRKQmN4S3lhdnZBOWFucnJWUE1J?=
 =?utf-8?B?WDVpWXkzQjFBa0VEZGUxdjQ1bzZEUHE0T0NjcE9CZmRHbWl6c3NHaHBxTEgw?=
 =?utf-8?B?bHdVa3FqWXFvTHVDbnZlcUcyTCtqaGQzZW5Ja1FNK29xdW5ZSmhmUitac1BL?=
 =?utf-8?B?V1AyTGw3b2p2c3R4WWQ1MXY1Z1N4THhqdEl0WGRmKzh5azFFbDF6SXFCaUxQ?=
 =?utf-8?B?ZTNzM2ExWGZSenVDY0tJN0lVM2dwdlF6WFRFUEJKc21XOVRDaFdJc2U1bmFi?=
 =?utf-8?B?SWs0RUl3VDhLNzlmYWRMRi9LaVNJV3VoRUQwd1FQemVHZDRPNGpBdU52Y3F5?=
 =?utf-8?B?bnArYW80Z1hTdXd0Y1dtV094N3dDU012MytPOG56REU3eHM4ejJTeFIzOEYv?=
 =?utf-8?B?MmNWbmpaQXkxbFozNnluK3RYK3BSSFh3bjVwRVU0RWpuMEl5dENyNzlLemlX?=
 =?utf-8?B?MjJjMmV3SmpybE5BMlVvU3p1eGRsQkJHMUhjNjRxSzdxc2hNZGJ0Mmk3U0g0?=
 =?utf-8?B?Wm9TRkZPdktqM3RpZkdTZ3VkZTY0aVZleHJTZFRjdjRxZzVmWDE1VHVoSVdR?=
 =?utf-8?B?MUN4cnBYK2V5VEd2TFZXdlFxdDNjZWh5YkZURTR5VlVuZ2MrUWQ4aG5wR3BI?=
 =?utf-8?B?M2ZMOGpmSkRwQk1UTlNtbVdEVDg0a1ByaU5peFhSY1VoQ0NRZmVYVVQ1Z05F?=
 =?utf-8?B?ZXZ0TkpzVkJGTDQ4eUxNRWFkaVd5MFpjTVNIanJweTlhbDdTUXNPUEFlVFVO?=
 =?utf-8?B?by9RNFpyUzJYQXp0S2FaWXhGeDlac2pNVUNxYVJqNUp4ZWFrMW5KcHArVWRr?=
 =?utf-8?B?S3pvYi9heWdESDF2Q3lpdHNJWHRqeW42eC92SndxRGdQSGREQVlselJOL29J?=
 =?utf-8?B?aUcrMWRzSWo1L01wK2hNUFBqUDhQT1lJekFKSXh3azBxZWhsS3FrZTRWelNj?=
 =?utf-8?B?WFQzWFpWem9tWHhHeXNEOEs1VWQ0OVVOano4c2lZa3pyK1lvTHFYUTg5Zito?=
 =?utf-8?B?NUhqdk5ScThhWURKR0crQzZ0ZGprYWNjaWFOc1NROG1WTmRnVnRUSzRwbkZJ?=
 =?utf-8?B?UXQ1YmFEYk1Hd0h6Vk96Yitza1kweE9rOHRUM284NVBqZUp1TzNaQU5EUDJ4?=
 =?utf-8?B?K2NQYlZweWVFYTAxVjI3WTRrbmtQSTlLaXVOTGhSVm9ZeDRQZE11aEcwQ2or?=
 =?utf-8?B?RFYxdVRSS2tnY0hBQnQ4VjY2MnA0Z1BtV0NMRnMvM1hYc3FHTTNWYW1WTGwz?=
 =?utf-8?B?Q3hWTjhrZytXL1hsVFlyV21TWUQydE9lZHp1TVJrWFY2VlY2bS8rWjZTTzgr?=
 =?utf-8?B?RUtrZ28rSUQvSFoyT01LUlFFTnAwMVBuSE83UWZkWEhzYnVlaDM1blhtamhJ?=
 =?utf-8?B?THBZemlHMHFSaXY5VzQxclBLQVQxSEtsenBvRmdRdnJNZndQR0I0ZjFvRktX?=
 =?utf-8?Q?vvlODk0KZMpfbFsI=3D?=
X-Exchange-RoutingPolicyChecked:
	L8OrSO1thuVWkGUyuWfncGvXGug1k4f3jHIpJWJZiyad0+COlOGqZ9xQVft+kt4NilxSxJ8k50schJmq3JR53KTCNX1V8+w1FW4pUnId/t3qoAZIYlBA6fc3rAlRODSpXqkDV96jr8Bw+oxY7IoSMsZjtErfnbhW8+Z0wzC69LVesvuonZG/qXR5ghol/r2HA5wWDKdWNV0TjvfiVmUm+K/QbJFzpvDPs0FTvNxiDvB2zFBXyVsgKvZI0mRGV9SPUwE7l1J02EdhJp5afiWE0zmWMTEfkIUa0Cgv1OsZp2+iWPCB+J0h+S9izRmjfJcVeWaJrToWU1n0xBDk9IM8Rw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LqQVsFAqzyZclmrIL1g4tKraw5uHg6O/R5LRjYxVBj5gou3dkw3N52TcNy80fzyD1eFA3mDX8Zr24gKtKpS3fmSgeyriVbr+RgZNluc5+q96FTpsU0TaaE4PE6iWT7qnvvG5Nyw1UIUjSr+PRKGTZJL8Jy9UKqCJchnWGdRuokL70uJvKKAKpKMlf+aDzcxudespgow0U/WDxM66MeF14/pxiWifPBpn7uqYesZrieS0pZa0tjzVr+V+01lahcJekbKN3kP1rnUxqoX4wrhUdwyy5uJ8F6I9X3j1CmXMjBpZDiEGIR3b5o4lQ1w5cCCfE5gV97nckji+DQga9fJAOEVmcGIkDjwnclkf5pwZBWNbHa84541PhUfqzJ27jLyLwx0U8xYISwEYISzL/I+BW3FNKaM2kavrc1UKuz/SXEgrQuBNdmpdnEvJULhQW68ti8ux+/SRh/WVl6jdDzAixcgU6xogZDqln8xbHfMPDZS84z9JZzDwwvVdohji3kVHPHZUY3PH6PXGLNbnBKG4vjMkctSxy1n0/MSVk1uvRZ8GD0zBclGgTRDl/4oD81zJXriUF6nbTN5KYUuFpH6FUtNhEtSi+KBd2OZn5lhngv8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fffb0345-d1c8-4324-178d-08deed85e731
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 15:27:30.1174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xxj9R6xYHbqhA+3lw0l23jPOJu4M1AQjBpAwnJ2U46DgVJmek8p5jn9iReWxb+NwgiSO8eG9yexgfRXhqfMCKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4335
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290124
X-Proofpoint-GUID: t36Np5D6mI27wcopmwN52LBCag9UTNm-
X-Authority-Analysis: v=2.4 cv=Y8fIdBeN c=1 sm=1 tr=0 ts=6a6a1be7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=vqt1AEZUGDWOw1ggD5oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX6KZqoup0eMYP
 7zkqQxk0E8afeN7Glmuw/EndoSkLxlS/3gYqUUle/kcj+8eMb/mgBRr4h2eCVRQVWJZ3F/qWwx4
 ev2ZgUAOUZj0t6fl331+jHyhjpXl+ArG7HvWvgfWEIFbw5qbYGMp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfXzO6tWOdOLbE7
 mUfwfDtFunXauQmWNwIlnQ5d9RSoyyypMqqJjKBNHVeim5AGdEa5Oy40aZ54SqOZC5PJm+gSHzX
 8aV2Axm81tDwC7cQxEoe/lpcp3OsjOEk9P2iWQSSN4EdceOQfJ4qQV/uwbNL/w0z3acEbs85mA7
 9L+IwKA/9DMwaBywfkTdHbTUcucmCSsN03J/xrD9v64gAt0eoAz1tOQm+Gl86vS6yXvpkIVZH6i
 0PpvV4QrVyJ9nzBbVTR4+5GlYs9vEhZHE3gW828PP508ImyU7n93ArWjm2rf9ZS9SCFpZb0uyAW
 1SUGtkVlQNqcFpsmmNNEL8u9p3N4Bvg2e60ruriITLyWNjvPf46ujAw8ka2FIZv7fs6BJq8D0AX
 jW50HVOZaCXclFMRk8AH3DmGipwlrVUfwdaOGXxcviZHrAsSKuyPVxwjmJET1SwjJqkrXx90QVR
 1w05n6ss4MuH/8jNUyA==
X-Proofpoint-ORIG-GUID: t36Np5D6mI27wcopmwN52LBCag9UTNm-

On 29/07/2026 15:54, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [High] Calling `scsi_mpath_revalidate_paths()` outside `sdev->state_mutex` without a NULL check leads to TOCTOU races with device removal or allocation, causing a NULL pointer dereference.

Same as v5 response, this should not happen

> - [High] Direct callers of `scsi_internal_device_unblock_nowait` bypass path revalidation, which can leave queued bios indefinitely stalled.

can you name relevant situations?

> 
> Pre-existing issues:
> - [High] The patch calls `mpath_revalidate_paths()`, which schedules `requeue_work` on a background workqueue, but the teardown path fails to cancel this work, leading to a Use-After-Free.

this is done by (disk) sd driver through calling mpath_put_disk()

> --
> 
> --- Patch [17]: [PATCH v6 17/27] scsi-multipath: revalidate paths upon device unblock ---
> commit 6253cb1fc352f4ec6d0d42ac99c1827b35592ff4
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: revalidate paths upon device unblock
> 
> When a scsi_device is unblocked, we need revalidate paths which means that
> we clear paths and requeue any queued bios.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index a1ec11050090c..6a2d7dbfbe8c3 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -3092,6 +3092,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
>>   	mutex_lock(&sdev->state_mutex);
>>   	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((ret == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Is it safe to access sdev->scsi_mpath_dev and call scsi_mpath_revalidate_paths()
> outside of sdev->state_mutex?
> 
> It seems that concurrently, __scsi_remove_device() could nullify
> scsi_mpath_dev->scsi_mpath_head. A similar race might exist during device
> initialization before the head is populated.
> 
> When scsi_mpath_revalidate_paths() is then called, it blindly computes the
> offset to &scsi_mpath_head->mpath_head, which could lead to a NULL pointer
> dereference.
> 
> [Severity: High]
> Does placing this hook in the wrapper bypass path revalidation for some drivers?
> 
> Low-level drivers like mpt3sas and scsi_transport_srp call the core API
> scsi_internal_device_unblock_nowait() directly. Since the revalidation is
> only added to the scsi_internal_device_unblock() wrapper, won't devices managed
> by those drivers miss path revalidation when unblocked, potentially leaving
> queued bios permanently stalled?
> 
>>   
>>   	return ret;
>>   }
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index b23cd6f12c602..12750621a7fc0 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +       mpath_revalidate_paths(mpath_head);
> 
> [Severity: High]
> This is a pre-existing issue, but by introducing this new asynchronous trigger,
> could we run into a use-after-free during device removal?
> 
> Calling mpath_revalidate_paths() queues mpath_head->requeue_work. If the device
> is subsequently removed, the teardown path in scsi_mpath_head_release() frees
> scsi_mpath_head via kfree():
> 
> drivers/scsi/scsi_multipath.c:scsi_mpath_head_release() {
>      ...
>      mpath_head_uninit(mpath_head);
>      kfree(scsi_mpath_head);
> }
> 
> Because cancel_work_sync(&mpath_head->requeue_work) is missing from the teardown
> logic, could the pending work execute on a freed mpath_head structure?
> 
>> +}
>> +
> 

