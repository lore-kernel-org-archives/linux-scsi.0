Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1415B3C09FE;
	Thu, 16 Jul 2026 10:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784199450; cv=fail; b=QXJBuDPaDCOt3SZFXN5nzh6zZkwfOoQ4h3T/44C01rucyG1WqQxvCKLp7QlBXLjOOGUNKWCFQPnDp5+ujMpau5LadGqhECFjP8dFd33PjTa+pNxuCpGlsTvUchyuMhk8psx2xgqTRcvSBrqvCYCiMBFC44btnpDIJP/tCvQAMLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784199450; c=relaxed/simple;
	bh=y9AB5XFPI5ybYzmWpO7u2b8N+wVz+EAf9GKoB9ywHTM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DViLGMq3BmEemoBVu98ukapzgpIBPNokLlVAHSoev9WF5oSnxUvJ5GLkyBzeKzDvTCqqeyiwzhw9dfBeTsmeFzsdXtBIzwS6JOeTjtFMyLFJiWVnknfaYu88OqlXh4ymOOxUZ0ATztOyBtXM49IYlpZZVguiJzprAn6D8WH1AkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f60eFO1n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Sxhfuy5a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f60eFO1n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Sxhfuy5a"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GAu8U43848684;
	Thu, 16 Jul 2026 10:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FcCzXMjULHyAwLe6GeZxaNaEUxr43iVS8rZokNamp2A=; b=
	f60eFO1n2Q7I03mc/xC4FW6zVxMMs9pxEYus1nsupRNgiCSDxSn7iZzwIjAIkEac
	1oQpgqNbRkl9sjM/xSMGWxn1qqXcm5e2sFRnYHhVbqZZbh8JvK9cY/zPzwrfy59a
	w7rYXJvrGt9DzPi4sYJ2EySI7PvDlyEW/GJ/gX+h6rPhvxBDegkT0OHgqlHvwooT
	SspvRjpGWlATb/DmwIUys+bIFzM2FKj/HHadQ3PcY3WtDYUqxad/B7RhjDmSZbOL
	BJg1dx1yhTrI65yxZ/LUFA8fzvjN9ooClMdZTFsxdhisvvDL03O6YXnmRjV8D8iz
	YCZ6xcfnWuqIX8iNmGAVUA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fdhn0csk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2026 10:57:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66GAr7c6015124;
	Thu, 16 Jul 2026 10:57:18 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010061.outbound.protection.outlook.com [52.101.61.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4feqycar9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2026 10:57:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sPu+D6CxgSdY0UcOj9EBJ1/YDZhJNK9M6XYLV2kk7AdaXhOrNm1LStsJdYs2bSeUep2D7tTRJWE1Vx81OD3NatiDrC+uoY+lwIgI11Y/sFTqI+DiPoOY9PB273+iptSeeNWmGx3HwhLY5CF35XZbSd8lcNYh1p0BNInX4seCG017CqdfINnqG7k3wiXyzU5ckNhw+v5szj6EmrSlbfaeBiom3TSXpJRaaJDZ3Lah0UZVKK3+tgIPJlalWB3dsn2dV/Vkh2vIEwiSqZntVeQZbfSvON078gg+4iz/1mWWG4JnZZxG7uf0/7nljZGYuL6pfB9vV5AVa5cOgIPoILjdbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcCzXMjULHyAwLe6GeZxaNaEUxr43iVS8rZokNamp2A=;
 b=u8va5Q/3WocfN37Fp61pTJqzBF/gjKPVtpy3ShWMMiIao670VWlwkv+PXhrpfv1OvBbKpCJsnSroXDdkh70Ih/GP/hTMq7eOC+OTbXFrDh6xW0ftwkQA6BCKlUF3YOBzGmhGD0WvdMhWD+i2SAYrmW36Q0z1+3k+sACybWa8pdQ9T90qegMD6yT8q5hnA6VaH2BCKXyGDcUeOnsRWWE2MTaextWmYfYEM1j3J79YHdvqWohJVOHubmXkaQhaDAB1FIP7QnJ70ithKBDkzLXmL+FZ2Vw54KoxoPszV+jMu+WR6yR+qB3lkhQCOV93dS+cL/2NQiKPWutv1VDrFlcv5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcCzXMjULHyAwLe6GeZxaNaEUxr43iVS8rZokNamp2A=;
 b=Sxhfuy5aGveuQJLloBYynlupSVyFBGD94YIrYEoSTpTGGhNdqA1ZuU+PXPtMQH6stON3qdArnm8unZ7GwjJ8hR/xr+SrLfD/ieKz7eUe4R09DzmUwizgWJx2rkeT/AXNvVExKVX0sYRTo16EY3hoCiG2mr8Eo8lGZq+Y7Umdisc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN2PR10MB4239.namprd10.prod.outlook.com (2603:10b6:208:1d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Thu, 16 Jul
 2026 10:57:13 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0202.018; Thu, 16 Jul 2026
 10:57:12 +0000
Message-ID: <6717aabe-a2a3-427c-bbfd-2078d8bb60ef@oracle.com>
Date: Thu, 16 Jul 2026 11:57:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] scsi: libsas: terminate deferred commands on time
 out
To: Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Jason Yan <yanaijie@huawei.com>
References: <20260716083847.926102-1-dlemoal@kernel.org>
 <20260716083847.926102-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260716083847.926102-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0178.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN2PR10MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: be4dfaaa-6f92-458d-659e-08dee328fd6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|4143699003|22082099003|10067099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3vcIwWq3LKp7YLWX+mpvZrm54/jVtscaHIQnqpLDXVCTaIZZampfOHZBD10ZKrehrx6OuxeJL22u5mZQDoXv/7ZrgbiYy4aRETL72TsVr231jNArG8zS76kxJRjIZzA+mgmDOSoheF4/3rI5HpiLXTfADMiHLm74Or6Qe3ejgOISnYdsb3TM36BM45qVjyHhPgmWGOPSRa2057ldLh5tsZ1T84yknvobfBUSutw6ZPZdsy9UhFcz8WFf07m/I4BvS3Q/ihse7aHFSz7/1fc32j8vUZF36HMXa4U8GJ07yNvKAMD5tDEi0SDuxfM3mYFhRwNz4ey8SWhR2nYW2rXD0pvDMiT7j9B5rbHoT/6N3T5WBZq2EyGOC96AMj8NLCocp33rwj93CWSCStzFao4ErXKQ41IHy5axdOxey8G9wk9NEuAYogdBkOPprZmj0L2Z832M+KNRNNVlycBerWmADwepEpI0xrToeafrcR3Rmu8HuBNf5mi54rby5wCnORNnBUmh/fcXFOgw/So5Yf+ofUfHGqAfwrTo8JRSL7qAVq0UG5CkLY3zUyaznOQRRAZvl0KaUsN3UMXnU+hXhr99x65T3OsRnVqQ4TO6oRaxTooI4Sj8R9/xvkKc/N3Klw5olW9fbb9XKG9UAV4307A1CCTSJ5x8lCfQQ9dpZoXuc90=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(22082099003)(10067099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3JJOEt2VVRpWE4wQlBYYVI5dHBJVEtBWEhZV1pCcmxkaXpYK2p2MzJicTNX?=
 =?utf-8?B?Q2U0WFB4dDl6ZFoxVlJXVGRqckloMThMbVdvQUN6Y2xoTm42dHo0UU9pSXVS?=
 =?utf-8?B?SXR4MWhhNTdNY3BXRGx3dEFXd1B0d0RxZ28rUmF3SGg4dzh4MThhcm82bmhl?=
 =?utf-8?B?M0ptanBrdkthT0tPMk1pdHMzT0NPTVFCYWY2amdYZVIyajV3YjN0TUk5L1dP?=
 =?utf-8?B?UmUrdzBuUEYzN1ZsZlIxNXExQUJqalZrVTB2OHRaNEUzU1cxMlBFc0FjaEkx?=
 =?utf-8?B?RUM2Sitkb3RHOEUvSnNubW94cWJKM3F5dlZ4S0NQSERCSTRkRXBaekEwcitk?=
 =?utf-8?B?WmZGVUNFV1VsSWZXNzJnNEdRb1pzTW1jbzkwT1I4a0twL3RxcWpWbUJydTEw?=
 =?utf-8?B?QzZXNm5QWHAyWm5TK1hRMFJPekl2dHVxV3RlYURTNVBqZHR4N1k2MFBwdElV?=
 =?utf-8?B?MTFodkI3R0VxNmVzK0NhdnJHUy9hc0hyRlQxVUh0WEEyc1o1V2p1aDR3UGE2?=
 =?utf-8?B?bUoycGt1YlZrcE5TdHNRUFYzY1NwRzk5N1BkWmdzWFZOYkIwOXdBaWdIbjRu?=
 =?utf-8?B?ODN0dUxDaStDY2NnWk16VEh4TDJkWURSV2lLS1lkM05OazJHcUtaM2VJYTZU?=
 =?utf-8?B?KzVkOXlwMURkYldYQ1M3dnd3eThBNmpyV29pU05kYjRLNEQ4SmM4ZXFOTXJM?=
 =?utf-8?B?S2lvVXhzdWtxbXZHa09QZUsxWmdXekhWNC9Ub0VWcFVqMW9pb1R3K3hNL3ZB?=
 =?utf-8?B?OUg4T3lBRXpxdW1aNEpYblZVM3N4VnY0Z0l5Z20rR1J4MHd1eEtiUU9LZ2ZM?=
 =?utf-8?B?OHpoL3FmUmVpa1pmRGQ3TmNVekV5YkpjaUNDOXhpTmFBVFJmaTIvTFhLdDFF?=
 =?utf-8?B?Tjk1cHJVdFRVUGFjTC9wUk0ycFQ0UU15Z29SQWFSTXh1MFRxQUMrZjhIci9D?=
 =?utf-8?B?Q1FUbCtXalAxQ0NYQlRCd2FyY0owM3FXR0I5SnVFRGZnTXBlL0JSYzBTdWFH?=
 =?utf-8?B?U2RTRGYwMkRZeDNyUjdJM3Y5U2RoM0lPUTh1Y1hCWnJ4eWZia3pJUDh2OCtG?=
 =?utf-8?B?RW9MR3lDemlYbWpIb3VMam4wajFJcVZKUU9Rd3U0R2YzZ0M5aEtVMHZNRzdO?=
 =?utf-8?B?VjlYWnhBLzNQWVNNU0NwRVBqMzEyQlNFNERxbVJOK2J0WmZuK2JmZ2xvaHlO?=
 =?utf-8?B?Z3h5ZDRxMjhZT2s2ajNZOElzZkhCRlhNZW4xQmdYQThoVTR2OHA4clhmbDZm?=
 =?utf-8?B?M0Y0dGRKbVpzaXg2SkhjVnB1eFhJRUxpMWdCUDBiUUF5Vm1YUXB3MFdoc1Rw?=
 =?utf-8?B?elFqODBETGJmMm1vMWxEL1ZPUVFUZEpsT2xOU0w3ZllBNmJObTV1bWpEYVJW?=
 =?utf-8?B?QlN3OGo1WStneFI3ZVpMcXlQZ3dlQm03RVR3NGpkejhjV05teWRLY0NmK1Rk?=
 =?utf-8?B?M0F4Y2F6VWZBb0JBUGFlc3ZFN3Nsb3diVHRMTlZnc0FpdnVQcTVtYmpVQ1BF?=
 =?utf-8?B?dGE5ZWlISDU2Z2VWTkcwelRNNE1sMEk2TG8zZXpnZjAxVTZjRlZhSkhCREVF?=
 =?utf-8?B?b1JRd1dlRmpNZzlweGNQczdmV285NmJueWJjQjFiS1JTQ2VoN2YvQzZrU3No?=
 =?utf-8?B?ZFpFdXFMRXZOcjJ1aTA4QmM5L0NmTGNDeTRXV0hyd0dnblIyd01ZdmE0eTQz?=
 =?utf-8?B?NjFodUdZVXIzSXF2UTd6Q0FjWU5FZFdEL3dMUnpRQmxlRWVycllTN2N2OGxj?=
 =?utf-8?B?K2lvbzhmSG1YY0lQcjhJV0hnSEtLUFlOTGR3aktTWkJwMVRadlI1T2J1bmZG?=
 =?utf-8?B?cXFCcWJBeXBaVlhBV1Jobk93VlFsT1ZMQ1JMWWFhVUJFU1MrUjNwZHFnTmtW?=
 =?utf-8?B?bi9IU09mNW1CY05McGRpcXg2OHQxOWR0NXFXdklYOUV2UmtlOWY2REZHZjZ6?=
 =?utf-8?B?eEdlK1htaW1jaTVyb0tFNWVNaHk5bkh6Y2RXMjVlRXFiaWdEN3F2ZVpzUCth?=
 =?utf-8?B?N0QrYllad3MwM0NSUnFDTmFIQWJ0a0pBZXRqdzQyK1VQUFl0WDFid3NpSTYw?=
 =?utf-8?B?YjdRamNkT3dPM0tNVEtSS0pzRTdFR1NRa2p4NWQ3elFBNkRpS3hyK3ZYN0ZH?=
 =?utf-8?B?dW80dkZSMVFpZEdwNCs2WGkxVkl3OUtOTUsreUpYRVJzU2tCR0NsWlJDeDdp?=
 =?utf-8?B?bDAzeERoeTlZN0IwS1duQlg0N3crL043dHg0UStScHF4MExRUnhJSmgvRTFM?=
 =?utf-8?B?RjZLWlBGRitqeENWVThUaCt4ZEdFTkIxYTZxV1VhVFpZZWhZRU1CMi85MmtW?=
 =?utf-8?B?NTlRaFRWeWJKRVlGT29abGZCMEt2YjdyZkZma05zK3gweHd3UlBoVkVpVFlE?=
 =?utf-8?Q?AW37BT33bsxs4RIY=3D?=
X-Exchange-RoutingPolicyChecked:
	jYNLoIwGLHz8oMEZHPd3WilyILgHqvZduNy3oc5Js19WgNLl0U1DKsB2zASnxDro6+cDUrVR0k62XriT5xKfVZMHbRhCLcrr5cGxsTM77WR9gMmR5SC3ZL/HDDdPXO0zicQhXh0Tv570R3i9amt4tRl8wpR2x+gQ8E0rlvVVJLrgA/0H/WEM1gMAc0WXhrdazODV7HfBIXvASGA7IrlDXk2nnk7sBr7Clyyzh66vhCbZQsyIKgcotdhOhAumteBgsQfe1IMYvaRFCKdADreLiltm9UkQZFRYHSfWikm9XgaB0ZqbDf4J/Je2FAtUXKHKzaR3y6Hg3Y0zM84X7ITLqw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bl3zICG8L7DeZGJuI0RxE3bTfMVvn2TkSgcmQDAhnYxi6xA8CSew3JiyoXo/F1gvB6DrWKATxmJTb/JHek1sXi4zJF0JUIhrOSkk9vPQQBkuayouoyERfH+w3X9u8Fw2Ix3qzB9PTXx6aZG11Yfk7x7JPxh4rldk1rSfXeL2HfNbaGewrtUab6rUVA8N0hQvxRFTJWao3ZFtlGpsGPMSplFWFpzObW/34c/7vKEXFUNCe2DIq8rKHCip208XQaki1Hx52esVopmISAeTVN65I2X/KQX/uFC2mXnF9ENlIMcpZOrWOHXxXVqYmUGE075YBE4KAi64XqHs3aUizWJ8INvvBBy02RarDpCcR6EQOHqLhKOS6AFwjSgJxheO+19m4SnyEqOS0+k/ukjZnyHUIWqIppneci/3y3KaBTKUR7oo7E8sLrlNYSNZc/bk716SaHL/g9EZkvf+6/SIcg6+y4GNGFfDZt8gXNu78Y+CiIykBYvCiV/emeKsN3mHL4aPxD74BPaYpcYcNYxYpUSKpKxFnPH1e/Eg/ZKqpVNqh1ORPNrbKGsivRtoxk/5oxZ49mYsjH7gSrkO4HtWu6FFMPfViHV0P+yIiQSYrUdleBc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be4dfaaa-6f92-458d-659e-08dee328fd6c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 10:57:12.7621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnlG0LF3uwju5Ba3enmkjE+8KuwP0NRXEJH8Y5ontktCeI/TkGIHIyEV9l7bDxuGGHD1FCBKQOtUVTkMvKcSjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4239
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_04,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607160112
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDExMyBTYWx0ZWRfX6xIa67pBAsI3
 KezYY/c8awYlQHwETJ4nyryZnyooV+z0oybauS+5zDWwT3L31nw4rGZDaHqeD4iXM2nqtYMXaLY
 AqJHFkofbW0xiVFYUxa4zR4GhZBwiICdJtzq3GvqVBVtljZeECRB
X-Proofpoint-GUID: Rt_xqqgRZHlw-eJvaQ0DwwD5qbMbwwP7
X-Authority-Analysis: v=2.4 cv=ddewG3Xe c=1 sm=1 tr=0 ts=6a58b90f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=1XWaLZrsAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=c9VprbjzHHBmneTCtU0A:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDExMyBTYWx0ZWRfX34paq7PXHmy7
 m6MPAxK77fs50tJDaWK1bEMKOrFcMl5qqNqFtyyak8pnrdswq4prdmRpBsrFIzKIBXSKo7fhlSN
 s56gAl29o3+jw8MHXBwwe/OgAoOQg6AuTgyvBpj/0NbUWhasJf919qfb/22sdc0FjbHluBoJyrB
 2OzPZeft1IXjv7IvghBhI4lp7TIav7SaE4noevmoRDOdUQhx6KK5WWwusR85eduaCxtrESS9Szi
 r4TLY2QtJVbBgyIKyk2bfnsMYmK7Qgp4/I1Z/+Ed4cHd2X/b31HlD3mMNffhIZ4JK+Pt4JA3OrP
 1n3Du6NGiPoxBYXrzhMd22XY0fQXqPhDKHov2zPIULaT2dkJwn2P+wpzaXHMFaaCTMpz10mu68H
 PwmOcpmSVd6jvarmm7PACm3+X/BOZk1YcsyPUsYWWmcNqn00gGn0eVC9hrFyWYwxBqy2jFw7Fsz
 0X0wMhSUTkcRn8BlOQA==
X-Proofpoint-ORIG-GUID: Rt_xqqgRZHlw-eJvaQ0DwwD5qbMbwwP7

On 16/07/2026 09:38, Damien Le Moal wrote:
> If a command timeout occurs while we have a deferred non-NCQ command
> waiting to be issued, the SCSI EH task is not immediately woken up as the
> waiting deferred command is never issued nor completed, thus leaving this
> command to always be counted as "busy" for the SCSI host. This results in
> the test "shost->host_failed != scsi_host_busy(shost))" in the function
> scsi_error_handler() to always be true, keeping the EH task sleeping.
> Eventually, when the deferred command also times out, the SCSI EH task
> is woken up and the timeout processing occurs.
> 
> Avoid this unnecessary additional SCSI EH trigger wait time with the same
> method as implemented in libata-scsi, using the eh_timed_out SCSI host
> template operation. The function sas_eh_timed_out() implements this
> operation and executes the function ata_scsi_retry_deferred_qc()
> for SATA devices.
> 
> Co-developed-by: Igor Pylypiv<ipylypiv@google.com>
> Signed-off-by: Igor Pylypiv<ipylypiv@google.com>
> Fixes: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
> Cc:stable@vger.kernel.org
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
