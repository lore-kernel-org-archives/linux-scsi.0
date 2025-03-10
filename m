Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B42230BFA;
	Mon, 10 Mar 2025 17:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628735; cv=fail; b=ItlLzrp6DZShubmnesmi2tK3zLlFwPDwm9qSiYx8Wabzrm+iQX6QjhJoZAujcN9HMP9/ox9SoBqvXKGczyjlGjkdXDK4jIHudI9QiKR+OH3jobiw8VOkGORlQNKXdIYJBjati7JFKIeRJxAYxle3F0sF7FdPu7i2LU4YTPqFwnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628735; c=relaxed/simple;
	bh=iRV3p78ercdoCYZTUWYlDIHmJjv1lCaBpj3tcb8G/Qw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iTP7ofzzyzHQ0mvOQVqIMwdCnKbvGNgbp411CVNlnSZKKx7zGovCh8iDwjuYncE4Kwry+5eLfc94QiiTOZquSmNqVslnWwL1pr3VR/mZyF+mZVh2ifLBbrvbTY8tZnhlFXsfqUsD5ZIQFteWxlJG9ks7WMDdUPBSZ5myEczAbpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N4v6DTqU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Fr983VYX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N4v6DTqU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fr983VYX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52AGfmcR015817;
	Mon, 10 Mar 2025 17:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3e7wuLMKldG9+K+Hvos5JPR1T3NRbk4BQcIzjLfXRgE=; b=
	N4v6DTqUpZVJX+sBeTGPh45AQQDqLb4GXPO3RdswuHrHDBREUGFfDowl7JwBRd90
	tlrABb2rfRdjXCbxAEImnN37uZqvzFJBDgbErzw7rrQdmr7RuLivcjGQbZ2ZQyEn
	e3iLqF3kx4i8QjUq8Bqx/y4kXAYOWjdaGIF3OEO4SDFZAhzrMhDnn4epDLDXjmq+
	YxWyYYdFjOSOdLJyWzXUw7MRy8XTQD+M0dvTTZlqnRR2EvE3zgdzAcQb1FBcQygP
	Zo9KUwN9FV6B8eJOQIXeSm+lAWvjdTD2YRXrUm1l2wHcyN5KPUMBh13+13nXzrYO
	z+X6FpOrxbHp+BJz8T3qXg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cacb5xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 17:45:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52AGMChv030658;
	Mon, 10 Mar 2025 17:45:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458gcm9ykw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 17:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fO1w63gAO7ZXDTlV2+EmVuBZNNyqnHFyLIx9+zPOQ2vJHCpV9Rwn8Wv+qmgPztKvGTw8BSEVdhpfT18tLKtMb1FbrSIb25NzPXAjcRV6B2FpvR9GOpi4AK5LfhSl55Px6QtTXwbLRyKuGU/LANp1XTrWsaGn2Lqek4fBX8nCStfDxRRVzZWl/Xs4J94yz8dSGFYe6p54WOXfzwHA5u6umc/eHgTuIxdzeSsyWPfkogm3OOdLXoCg2YfaiVJBCAVDKQmIgg7rC2bytC5k2s+jX5f8S0tiJ5K6QofJbYQN/p2XKTrx+2GRS6sNyWuyvOIhxHsr/4LFi6rGDBwIFyiX9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3e7wuLMKldG9+K+Hvos5JPR1T3NRbk4BQcIzjLfXRgE=;
 b=xwLxjmvW1ZmL2Cgz722y0pAHFXyptLRUZJQBtciSSUkWcBnbvo4/fO7QAoHb3o1+rJpGL892/wN8+/5BDYYVvx1pz5bdWWObR1IAT153GKbuKOLYBuiUbcuQHBnE8L3abpLK8Sqqkb1H1eM2YhDfeJ78aYucgFzwGXA19OgL0GSlm/ZazaH2cra3Kp1u0r/cJ9IgpPimZ2m5Oe0pTPq4YZnDxd9kKd+Jj1CpOS742k/U52ajqk8VPDUt9ksHuolnnFlOy22hUIIfWQ4+tx075hGfjKbqn044H8DE1K1yQoDXvJuDtbX7sM3wDDLy1bJcbYvorFFa7mdk2t60VKON0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3e7wuLMKldG9+K+Hvos5JPR1T3NRbk4BQcIzjLfXRgE=;
 b=Fr983VYXV52yRJNhfALmgkB+eS5ndGBxEgvzBsCenwsKx2ynA6IuiX2nNBzeJ705gFtg+pX9+ZjnokIbFrM3tlvUqbbvnsLOfWD1sNa9DrTbmZA/J9nn+VWqzMqYbWbDUjCZWr8/63kIMrWECjWR+g2z8I17Kds7uVElkrYCckM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5172.namprd10.prod.outlook.com (2603:10b6:208:30f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 17:45:06 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 17:45:06 +0000
Message-ID: <1fe3bb6b-1f7a-4188-83a3-f4c62e2a963d@oracle.com>
Date: Mon, 10 Mar 2025 17:45:02 +0000
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
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
 <d0a6b502-328b-2f83-3cdf-55c1effd80c1@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d0a6b502-328b-2f83-3cdf-55c1effd80c1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0099.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: c2465c03-7190-4705-3936-08dd5ffb4b0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkJXcjlKaEk1R2FMMnBYRGVyQTRHc0F6S3JEN3cxZENRNnhBcjhGZ2V6MHpN?=
 =?utf-8?B?TVhuaFRmY2ZPVkJZdEM3VndVeTFLY1V1MVM4Q0JUelJWQ2tVeW56TVJ4Tkxh?=
 =?utf-8?B?dDN1c20xc2ZBdm5XalNSSElkMUx2WDVBV1VYVVVqWTdvWEo3MG5VK2JaQTNC?=
 =?utf-8?B?N2VXeDhtNU9OV3V2WUJGS2NLSTdUYjU0emM3bHFEK0xCQW1QS1E3QjV1bENY?=
 =?utf-8?B?NkdJQ0I5a1ZDYkwxYWt3QnNhc2VtYmFBOU9MeFpRRjhtcEdxNHcxcGdNYi9X?=
 =?utf-8?B?cGwvRjcvMk42ampFNllobmUxaFNEMVpqOUp0MktlTzZIZ2JSOEljeGZNaDNS?=
 =?utf-8?B?dTdtb2tDeDhUeVI3OWVJaUFDcTRlMDRQVmI5c09Ia2JLZE5CTTF3bzFqeUUz?=
 =?utf-8?B?RHNHakUrYTRuNHNrWXRJeThmUmNxRytUVDY2cVB4eDlWMk1QejIyUFNtWjdm?=
 =?utf-8?B?M2YrODYyZjRvZVJzeCtHL01pQWY2RkE3cy9nR0VjRU5GbENhTXdGWXduMi9V?=
 =?utf-8?B?dHdKNjFpWUhXYXpvWnhuTS9ueDZIem50SjhYS1ZmNDlWV2p5WS9XVjhCMk1M?=
 =?utf-8?B?QTBab2dlOC92Y2dETmdiWHhRdEtOcStzZ2lNYWVvUkJZSDc3czAvQmd3TG5u?=
 =?utf-8?B?QWd2MXBrMmZzL0hUZ0pUcVVOVjc2am5Xb2YxWkxZRVlxVUtmd1U2SDFuSTNz?=
 =?utf-8?B?OXp6N0dHMTVacDZOTDlpZVJDZUkrbFRIR1ppQmNHZjZDZ0tMYXFMSElEbTc4?=
 =?utf-8?B?VS9nK2J3bUwwVzRRM1l2bTh4QVlUQXlrbkxQMmo4ZmxlVGpNUjZ0bjNVRkZm?=
 =?utf-8?B?c1lUaitvL2ViR2VNNENhblJaQTliUy9NTUFLL0hLWkFOZ0c4R1M4MmJVRC8r?=
 =?utf-8?B?TVJEbXlIVjdBNkEvNDJrd1dSWHpKS21IOEF5QVoyNUxuSHJXV0NaYzk5SDZX?=
 =?utf-8?B?R21CWE9uOVFCQkwzaEpMYmxpUVYxY3EvK3hYdlRBbktxV1J2Y1NWM09qVkJz?=
 =?utf-8?B?QkpEVFhVS3dobDc4UE50QXVIdlJROFp1ZEVHZEZXOXNLR25EVk5YUzFCbmxC?=
 =?utf-8?B?Wk1nM08rNVhHbVdVdDdudlF1SjlPVkJmdGJabDNNb2huZlQ0bGtHaHl0VFMy?=
 =?utf-8?B?K1RQSWUySXNCeVFzRjFlbGw1d3lzQWJVQnpzSERUN0UvUktxd294Yjc5cWF1?=
 =?utf-8?B?Sy95Z2VhVzRiaDFPU05wQlFIcUt1QXZjMXJCRStYUGpmaENXYmU0NlUvVkhR?=
 =?utf-8?B?Szk3ZjYrLy9IS2l5N1NmUE1OS3dITjdNbFpSMlRDUzlpKzBpa1V4dVQ0SmZa?=
 =?utf-8?B?T1kwbis3MWFSSVRHRUdkT0tMNmZPVVZTbWxST1g5cVk5TVFIV3ZtNnppOWlL?=
 =?utf-8?B?MWp6UVdrUGNLK09aM01ZSVFiTGp5Ly9idVVWTktXVFNydzBwVUw5WXF6RUtr?=
 =?utf-8?B?ZTNwWDhTUitHUStZc3dJR0owQ0sweWptSXllSTg3OEJSSEE0L0toY1hLU21C?=
 =?utf-8?B?MS9aYkRTR3F0YTJxUkd3UXB6eTJPV09PalR5RjY5SHNFRGNmVWZlNDdpK2tE?=
 =?utf-8?B?K0xNd0podXVOZCtTb2szUGVsK2dOeHNRY2I5Z3FEV0x0OEN2VXBuQU9TNUE5?=
 =?utf-8?B?OTJrS21wNDk2d3hPWWNVNjNwVmkvTm81bmo2TkZMRmVXNk5ud0YyVmtvK3N5?=
 =?utf-8?B?akFnQVlZTGZYSGZrL1RkaEYvcURxQkxxRXAyS29IazAycEJ2OU1YczVkcCtk?=
 =?utf-8?B?UU40OHVyTVZTQ1UwNEhObEkwTHBXekgza0VYQVFMMUlNbURRMGdoVXdiQ1hv?=
 =?utf-8?B?dkhzcHVtcUpBT0dDS0xEaFozdHRtbGZJTXNzSzA3VjhnbGorM2RnM0tDeDFo?=
 =?utf-8?Q?BKDASxqy6bxUk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDNJcWszRDBBb1ZCVFBOWTNuVjU5NGpnTkNGd1I0VHVDUEZtallyUXVqMGtm?=
 =?utf-8?B?UUNkZTNtL0k1UFhvbndUSHphTVo2aXRxNitiY0VORjluTkNNUU9VMjA0YklJ?=
 =?utf-8?B?Wnk2eDBhOXdCYm5jaTVSak01RWdjemcvMHdDS1ViMnN0RjhHblI2VHNOYzEx?=
 =?utf-8?B?ZzhGc1A0bUFhUkZkT3NPZzczbTJFeDJ1NDhlYUxwVkVyZXN3Vlg2bENZNTc4?=
 =?utf-8?B?YURsZGFNcTNBU3BUNDY4aFQ2b1g5dTg2clVtdmVZaTJyN08rK3dYU0RrQ2k1?=
 =?utf-8?B?VlRoU2puRFdoaWs4VU1VSGNrNi9hTitqcDU3dGxHNVZNenV4UnVQWTBFdWs5?=
 =?utf-8?B?NVRpWk5sV2YvUGtvUEVsUExDY0VpeFBVNmpnbUxoL3pydExXdDRBOTcyS0U3?=
 =?utf-8?B?RlNQTEZpNzJPbmpjZ2VDS2M2NERDTDZjTGgxd2FjZmQ5MjZTa29zZk8zc0J0?=
 =?utf-8?B?UGF5a3htUEQ3UW1Ra1lvVXRJNGE3NnJhY0R4L2tGTUlSM0U0T3RSNTJIck5U?=
 =?utf-8?B?bDBSeHlBWG9DQnVQYmhjYWxLemFTcmRMMTFQblZ1aVJtamtCTEdaa1J1b1lT?=
 =?utf-8?B?Q2x2ZEs5aXZKcXlmL05TUzJoOG4rM1ZCNWtSc20yM1hCWWJmczVqVFQ0QURX?=
 =?utf-8?B?TllwbkdML2crTEx1anorQjlaYkhieWVKYkhBU3pQcjBibFMwRHh4MStVN3pv?=
 =?utf-8?B?ZVVXVlRBNFloRHRjcURIQ0Roa2lXekxRMFFCZjM1WmdPK1JXSEpFanI0aUli?=
 =?utf-8?B?eVlIUnVnaytrRy9FcGUyVnJVLzB5VXZEREw0TmVwUTh1RkRjSis3MTBMbWVR?=
 =?utf-8?B?OU8ySlRCeU9RL01KdHh3SHVTaUo3dkRtdXhEcEJLNVljWHFXT0hvekJHNlZX?=
 =?utf-8?B?Wm1oZFhxN0FZaEVqUzJTN3VpeGFKamd3dUVDRG5CK2FQOFFHZzI5Tlg1dUE5?=
 =?utf-8?B?aHdGTTZCVjNLekNkVE1qUU1McU1rODgzLytrRjFuR2hyWkt1Z2xObHRFZVZj?=
 =?utf-8?B?TEcyWVZKckZxVEdwWUJrek5uWXQ4L05oNzBDYVE0OW5Ha0dBTmwrZ1FLYVk0?=
 =?utf-8?B?ZUVWblZkY0Fpa2tHb084N1lYYjFUMjFQR2Q2SEtLTm9tUmNuY01Bek1oME1N?=
 =?utf-8?B?a1Vqck9MaTZwZ0FWU29KRG9XYTlwR1JNSkJoWmFudnNBcmNIWkJ6Qmd2YkpJ?=
 =?utf-8?B?Z1l3amNsdDN0NWU2WitXNSszZXdjWGlhM2hFS1pHWmF0Mjk1Vk80OE16T0lJ?=
 =?utf-8?B?Yjdjdk1XWGlZNXJtRXZTcjB2K2t4NVU5MG0yZWxLNGZzTGlYVVFGcXpPUUpk?=
 =?utf-8?B?b0ZWTmtHNlczeXJEc3lWYm9NcFFTV2NvQWRqMlVqM1VvWFU2dHFyOVdKU0NK?=
 =?utf-8?B?SDBWMlgwdUJ3d3B0eWtyUW9mVmlFaUFsY3JjRElTQVMwTitGNFliNVJGVTdZ?=
 =?utf-8?B?dTlWZzdzbHdwQmY1dCtGcVRRRU5wMFZCeHNDdUdEQjBnUzBzNHMvanpObjQ4?=
 =?utf-8?B?V0F4WFE1ZFIxc1grdjFydCtpYjRoNlVuRDNBdHdZN210TlpaK1RJSU9rSWxi?=
 =?utf-8?B?REVlaDBRc3dXbDFlRGpia2NvRHk2dmsxRnpQeko1NE1YMCtqMEFwQzdwOTRx?=
 =?utf-8?B?NjJkL1dDVVF0Y0llNmNmYm5ZWjk3VHVkM2ZTMkNua2ptV21oMnB6YjA0NlA1?=
 =?utf-8?B?emxVeUE0dWxVR1ZUV2ZpRE53YzI2S3FsWVp0N3NUTlJ3VEpTYzBnTFVFbC8y?=
 =?utf-8?B?MGxTdEJMRE1ZeU9sRGExTTBSb1NaMXRZUzJ5MWlqODNtQ3FOaUlLMVp6VU85?=
 =?utf-8?B?RWZpWG50QnAvZ1Z5RW54RlVWdXJsaTdKT3liYkw1VjBMNThROGFhdXRFUmhn?=
 =?utf-8?B?NEROREttWTJ0WEdwTDkvMWwwQXdqWHRGR2pRK1NQeW5lTUlUdzdaVWZYSUlP?=
 =?utf-8?B?MG1tZlZGYjkvNTRlNW5paVVmOVZ4czBxdlV5bnRGOWF6UDRrRUtpekdlbWJH?=
 =?utf-8?B?ZkU0UjdSVUNVUXI1MktGMUNlRzBPK2ZCeUIvdVJLbE9pL2ZJUlRlcUJSQ0xn?=
 =?utf-8?B?WDlsUVlXR3VGeXNPUlBycjFLMnZqL2JSVzZRZDk4MHg1Z2JHOU9KdjFJYThK?=
 =?utf-8?Q?xQVldcy7a6AXg2/3/8FxmsWHr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u6NgzBrkWUECZ4V94/sTtnr0eY6dsP4yLblH4sOw2KEH24IAO2SdlKVsXeFQLWznQpY1ETrGtk0C1T8D2D1x5mZTn84s5s/oYJ7p/acleey6VsExPHuDcouWTlnLa4+Tsj4iFlA7vKH4N+1RbbEEShgfmV8MfHc2YcUvuG9/N0/8f2r1WmtTYK2AM6RGRjbK+13ACZISSPtaafIqgct0PReEceyn9tOuM3d1vSCdkhtGEAG4p3R7/bFVHpCB7W1iajB1P/H9qHaKMjyJd1vHa8RpfKVdGpk1Wsu41SwoSyHT1DOowsnUg6c4DY7XIjRJ8AAZguQuaIyrxiaQZCgFl5bc517SCmG8dZ5pI+WLi9PnDhyFdUKCxP3sUu5HU5YteA6cRspJePFVNIEsfZRbvZdgv3gr90mwIJ7JOI3ZFQ8qMOdD3ZgWTBilc/HY8EQ+0oZExm4ErG1n/4cbahJIDZd02DSLa6LND8sk3wMtiwSkgszAMAZkGWqHlY9wPlNyxcUcJfzPwJeQvFRBLhaEuw5ki4KciFuuS18drh4fK/d1D+nXZrm5wp8yP3vqYmiUj4tA+loxWTQL1fRYRnXMLnCaK0dHMyb3z5cMPRqdPj8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2465c03-7190-4705-3936-08dd5ffb4b0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 17:45:05.9831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZnjiW5BAJ/YjHeMDWVjVh1Vz3FgPVc2f/SQeH1jA9kkxfEYotyujtKsLz//0YpWgcfW/9x40GJTDCn9KHjT7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_06,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=619 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503100138
X-Proofpoint-ORIG-GUID: aBnbgAT6sLg6YTrXAaULUtU4CDihbICZ
X-Proofpoint-GUID: aBnbgAT6sLg6YTrXAaULUtU4CDihbICZ

On 10/03/2025 13:09, yangxingui wrote:
> On 2025/2/25 16:19, John Garry wrote:
>> On 25/02/2025 01:48, yangxingui wrote:
>>>>
>>>>
>>>> pm8001 sends sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,) 
>>>> link reset errors - can you consider doing that in 
>>>> hisi_sas_update_port_id() when you find an inconstant port id?
>>> Currently during phyup, the hw port id may change, and the 
>>> corresponding hisi_sas_port.id and the port id in itct are not 
>>> updated synchronously. The problem caused is not a link error, so we 
>>> don't need deform port, just update the port id when phyup.
>>
>> Sure, but I am just trying to keep this simple. If you deform and 
>> reform the port - and so lose and find the disk (which does the itct 
>> config) - will that solve the problem?
>>
> We found that we need to perform lose and find for all devices on the 
> port including the local phy and the remote phy. This process still 
> requires traversing the phy information corresponding to all devices to 
> reset and it is also necessary to consider that there is a race between 
> device removal and the current process.  it looks similar to solution of 
> update port id directly. And there will be the problem mentioned above. 
> e.g, during error handling, the recovery state will last for more than 
> 15 seconds, affecting the performance of other disks on the same host.

How do you even detect the port id inconsistency for the device attached 
at the remote phy? For this series, you could detect it at the phy 
up/down handler for the directly attached device - how would it be 
triggered for the remote phy?

John
