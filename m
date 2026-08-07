Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162DE343D85;
	Fri,  7 Aug 2026 08:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786090730; cv=fail; b=lQWFOACRtqQ44UAfSzOpIIeixS0/L/xt3UJW91gnSGvzYij6ScvQB3DgFPJzQrbjteAA16XSK6VRtXZyPVbIGpBr6CupiPqOnVySP+L87dL+ywY7LCVqd/8GaEosTNlPf139q6HhzI6yX8W3nzNEJOgQqyWTgXraOAJf9noODCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786090730; c=relaxed/simple;
	bh=RS8txZESacYnxVWKX4Fy/m73LOUgRfIEmiv/f8863KM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=selFrWyWnh5qUQPG0cOlHDfukbClP+B53sIDFkYAwU7TWZ8ipdXSYJqFO2M8+sb+0uo8O4bPBEpnvD8X09537CV2IAi5f2Q2f4fwXrpqqRm2NlXW5f6RK92ipAcu310FJ+26r4ESgHhVkUcs5ujz18s5yMK/thsltqeXP+wsRAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IeoEfaB1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zRQ88ibF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IeoEfaB1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zRQ88ibF"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6777L15b3081893;
	Fri, 7 Aug 2026 08:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ufWawAJxpk9jejyFjCyOLTYdCBlWYFxWjrc++63l+UM=; b=
	IeoEfaB1qp96pq+yUTFRMGYVLxwPFurSlJxT7hKLd5AAueA367IZ0yppYf9miBCy
	E6ttQh9EtGcId8m4eqJc4A9AT38pgEt64mdzeGuVwUDIz080k21vULdFTLUvUr64
	v6D53wpo/i3Z/4dsP65u+Wyzoo1lyRGNWFcRyNGNSZpE45MGzkvQ6zUCydym0Bhw
	WNnkMir4okdiKIeroxfuM4LnZnte44hGMJKR05b6z7e7K5P8KfQuodpcbcZuNExm
	vCG95fIuBJo/LY2GLJmF0NzRURNIEEeBmHD2XkktWBq3+tCf2cFuFbPxmboBGA0L
	Y6fHqZnQvBwbEB5eNSA2Lg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cyfjub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Aug 2026 08:18:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6778AEg2020248;
	Fri, 7 Aug 2026 08:18:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq45as35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 07 Aug 2026 08:18:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i/mqzDthCnMZSWtAnzGVFYv1TNwar5aZnPDr3OafQ9usXAJroziRZAGssE5ypzOFSHXyyOFkUjLsYkm/aOYlIT8hXPpo8x7xqz6tj+ynB4OfaaFTCcnBSuarlFxu0jlPp0WP6mKwORwWO0c4O2BtuzEjhOW6FepHjJATDtORL6rybabcyrJgKg/hieBwf8x9HH9Pk4N09PMDPHjAPv0IT0aE4In0uu0BJf2iRcqJ6B838I32BRjuKK/UvCCxk2Zq4ftH5VAG2aEUfGabROe43R7/871DuSUp8egQSR+9Haj+vU/r6RMjS23SS0SwCWT3epZSToNkyZAg77Qt23N/uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ufWawAJxpk9jejyFjCyOLTYdCBlWYFxWjrc++63l+UM=;
 b=M8+aqH34XA6WQEP9WCwmvExb0zHM9s52g4vxQDow7Rdu8PC6ryjWDRjK0AYar2Fi1YSEaTA/+slMhGWpELd6r5SWoXTbA0+kjCh0dwSJL+nzkrXDDxNU5miORaAoFxkt39kfULVe51c8emyIoLn3RzKTWPh5iQAnTusw5yqKSl6x/e2PferbQM3M71PlDnv41L6kmxdbG/BLG75wUvFn1giMi6uXXEhNtH1G6o9+V8xqd6lpQ3ufaVUI2ccbU4WXAIOB/lwHDAHvwFWlHw/Vr+L9W5ofAAiuL2iPwO2db6t6BtkJALi4fIVxr3gkM/fvVIHCaHxcJhSJXFTedm3f0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ufWawAJxpk9jejyFjCyOLTYdCBlWYFxWjrc++63l+UM=;
 b=zRQ88ibF8YKUg9axhdjb1LEZRNf6lOpO3A9aLxVWfs4/sAFblLvXFSH5O69B4xn5GMe+9IIpnbQHhPuSZeflPhYaBVvcPnKrQx/nA+VffiCYHxaP7xs4B2tIpgLtzdcP9qwtK0NSL274APPWX/Lbnb17fkkBmw1I6+bUFdz2yVQ=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CHAPR10MB997723.namprd10.prod.outlook.com (2603:10b6:610:2f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 08:18:29 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 08:18:29 +0000
Message-ID: <a5ea45d9-2a94-4b3c-8f31-d6bb22dc6eee@oracle.com>
Date: Fri, 7 Aug 2026 09:18:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Drop Scsi_Host.default_lock
To: Bart Van Assche <bvanassche@acm.org>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
        John Garry <john.garry@linux.dev>
References: <20260806113958.3127942-1-john.g.garry@oracle.com>
 <9d9092bc-6bf0-4afb-9d1a-5ee16c9c501e@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9d9092bc-6bf0-4afb-9d1a-5ee16c9c501e@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0284.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::9) To PH7PR10MB6228.namprd10.prod.outlook.com
 (2603:10b6:510:213::11)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CHAPR10MB997723:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9caf4a-0c32-4c40-a986-08def45c75a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	24zl+vKkRPt+hLk+8cAoaTouVn75lS68ugXKZtnulWC2PWmMNwAJMXeD+v5pX12CoWD+EqjTKZuewVZ9ZLdldYm/XLbC5AgYamptOXe8nD0CKeSMGJQIyYFzWh34GBw4XRpkRlb9Y//Z5wmfAPOUWF3Q3/4o+e9X3v1lzxn6tbVIhfqbvHbBacL6QrCbtY+w/hwN7LK4PCnXFcnbj5brCDdl51tbbJf0jC1oIxGcGQuj95IJWdhBLuENCD2M8Tov5smXmkcrjTMCw4lS2qCtC4orhM7BJnzzUEWsZwXi7QbMKYqV7SQuoycsZwOfr0KhHSfrQT0BmhAX8W84qNJq2Pmz8NkIVVEkuhhI8Zn+bQj1S+EaIVeq7y40B9rWdNXbFg5D0JnaTvcgs9Jbjcp0zbo/lHcbGt2JXSFNCIrZs3guDEBlyD5ak3qR/CksvIyDtQT68HKCXu7dzjWhb5Id0FgN3vKPL4MkwU++2Vd6pQPka7mh+cT0umbh5xJbBfApaTtxggbEhLvAwwNJ2oKxLJd8fIwNv851wW9vOFo6vyeZ2IB23k5V6tsPtqDmPCp3ThfpRlIsIDcmSim3B4nAnL/CwOCtBYDRDAf3QC5o8ZS5wNX4hvEvI7kWDRizYJ+gGv8nKDST1cxGT3yQzFDRe37O67eCgeVlPgusZ7F+edk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZStkWXMzY2tGZ2ROalZodkRnbDRPMDRrbEdTakFUcUlvZVNrVGg5NFF2TmF3?=
 =?utf-8?B?UjQ0bk1jdVNpVjBhV1ZCV0FRV1grWU12ZUZYQWMwcll5cy9ERzByZjVjRjZj?=
 =?utf-8?B?NXFuS09Ga3F6aW1SRWkzdlhzYks1Y0hBMVVYUHJqNzhmNVZzVmpzWEwyUHg3?=
 =?utf-8?B?NzJ3OE9SaW9PSnVrVFVsVEpGVGpuZHpCWXN3dTFaVGc0VHZJRTlGUE5UUEtt?=
 =?utf-8?B?S3NCc28vR2owby9ieWZRckJXU3lNa2o3Ui8ySEZlRERWUXZYb0dIUjNOV09F?=
 =?utf-8?B?U1IxN0FaWTl6bjVmZkszVGZveUREQ25yVnJsQ3pVQ0I2SGlxWkMyYWdZaFBr?=
 =?utf-8?B?YTFxNGdidUdKaUVFYlBTdU5VWjZPVWREUGxiUmNhTDN6dkN4NEc4Qm5RbFU5?=
 =?utf-8?B?c3JIUjlFSnJnMCsxTVNoNmhORC9na0dTeGN0Mzl0N1RpNWY2OXFMTTU5NnJv?=
 =?utf-8?B?aFhGakszd21Lckh0QUlPSnhzRG03cU5mSzVvUGQ0b2diVlV6OUwvY2tGeTVr?=
 =?utf-8?B?KzB0cnNTbHprREVVUFp1VWdocndaVUhJMUVSZVBCOUo2OTRGeWozR3ZXTHFM?=
 =?utf-8?B?ZmQ4RXZCRSswbGFPVG9GZlpsdDM3NklUOFNJQ2FZRjNrQ1ZkbGc2UVZVWWRV?=
 =?utf-8?B?M1ZJMUJic3ZTeFVXZFh1VjVnNnBJNElPelVmakFFRnpjVFJsdStXZ09PQ0RU?=
 =?utf-8?B?NWh3Z3oyTkFMODJmL1gwMFBiOHVYTFJ5bnNuamlxd29TZk84c2pCYklBbEJ4?=
 =?utf-8?B?VWRwc1FSYVRvWGw5cERrOTZxU2I1WUthU2Z6eXhyNGRTVTEzWHVDOUJkUGRp?=
 =?utf-8?B?YThsRmtKRjFqN1VQK1dFbkdFUXEzNEg0M2pRNlJvTmhlYi9GTVI2R2lTdHk0?=
 =?utf-8?B?ODJhVXFNYmpaNWFpT0dpT0dkYUVzN1VFR0doRzlRWG44SXlOSnpMVGVTYWtz?=
 =?utf-8?B?UGlzTUF5dG1mMTJZREplSUpUYkE5ZnR0ckNHZHlIOGRtcGdsUVlkTnUrM2Zk?=
 =?utf-8?B?YVF6dk9IcWszYWl3UVdpelU3QTFsQllOTXVLaEdLMjBwZDhFWDNIRGRDb2di?=
 =?utf-8?B?bE9WVlFONW9WRkRKcGhZUExVSWtiN3pOQ2lxZXpid20zVmZFWDY5SEswWmNG?=
 =?utf-8?B?VTA4ZU9rRUdITmJyRGdTd3dJblFMRkNET3hPeG83QzNtS1ZqUGFSaElyZ2o4?=
 =?utf-8?B?QUVXMmh5MW96MC9GNzQvaW04WjRjaGJaR2FabU1sSHlpeSs3cm8rc0l2RW5m?=
 =?utf-8?B?V3RvMVBuRXNBRTA5Y3dYSkF0Nk5sUFVtTms3MzV6VmorMzBXWDdtNnp6T015?=
 =?utf-8?B?bkVaOWdVYS9FQmdNNjNxRXdpSkZyTlBRTmtvblc4R0ZXbEdjWFFQc3FsdXhO?=
 =?utf-8?B?WG4weXZ3dW9jMlgzZG1sNFA1UkQwaTQyZThWK096aThiYlRvc21zMEF1SWpO?=
 =?utf-8?B?cWpmZXBWQmpleFRVelpSQTZFR1B3SCtQcVFIb091ZXVPMnNQOUxqT3dBZG9o?=
 =?utf-8?B?RmNLaTJwNEUrVTczNVdFL0xzVFByLzVHZTA4WEhQU0xxVXlBK1JiaFdlYThC?=
 =?utf-8?B?dGFOR3VzMUNWTS9lRzhQeWZyZXZhOHlQSHBLM0lMZjRtMVZvSCt3TkpHZnh3?=
 =?utf-8?B?SGpBNEJTbkozczRJOXdPVnVJRGpnZnNJeTFlY1ZnVGI3d0ZXRFlIN0dSOWxP?=
 =?utf-8?B?QVc1eHNXaFBWL25QSWo5NDJ2WEc4SjFZbFlLZ3FMQTRSdDBIVEh4TlpzOGUx?=
 =?utf-8?B?SWduVHUwVUhDWGxkeGFJU1lyZmJOTFNTd1VmdFVYZlhQV1JqNmZhVlk1dXlu?=
 =?utf-8?B?OGxiQWR5dXZVOXB3NUJ6YXcwbU1mamJUUlUxdmhsV3dLSGtwUkNRVld3MHhv?=
 =?utf-8?B?c1hPYzkxVkRhYU0wRHNpNEN2QTBlRWp1U1BhRGxEdy9SZDFhSW1oSGdEQmNk?=
 =?utf-8?B?Mk00K3V4REZsenptOWJ3S0VTT0k5S1JMenByb0JwWFNDeGlVNGp4cUVWb2RS?=
 =?utf-8?B?MWsrWDVEZmUvRkFEbWgwQ2VGQ3MvV0xyQmswS1RRQytXaHpxdWQvUHNIeDB4?=
 =?utf-8?B?QXZmOC9XMWNMTm9wYldUQjY4aWFza1ZYTEM2VEV1TjdjNDR4dUo0bXVDRThD?=
 =?utf-8?B?Y1pwdThER1k0T3BQYnAxRW50YlM2QURKUVF3Mi8zbWk0Ui9UVXp2TmE2bVNa?=
 =?utf-8?B?dlBHdUZ5SmVTMkd1NWVlelBiRURlL3UxajNqOFEvQVorS09JYW1FQzNLbGds?=
 =?utf-8?B?b1JPQTBMWXVaMHhWYzRBUUJkdXRjZThNMkx4eTNpMm5DNTVQWWR4c2hsSVAw?=
 =?utf-8?B?ZHg0YU1CbkI0cEVFZHB4Uy9lT0hQdlNhRUFxcW13WE5pTWllSGVtQT09?=
X-Exchange-RoutingPolicyChecked:
	oKhSUP3t8VOHXd4TeHMynOakJ91VERAZrEuu1tFLI8u1zpqSgjvaGuIAT6hIdv1oUu18uTuFXXv2Dzm4UprYWRKxTD3J0+bdgxO9Tn+MjrbnYuuFETd+A64diean5Pz4lvWCyAoSz+7saneCUPNHAsd8bQKA/GGEmdp1MyN/lYWy5HtsrxajRTKK4tQYuETXcvSWoWm7HQsSC5z5mCaZ4kRF0MxLlvyYSGzwXPQbmaRdx4jw/QvXYQblQKJZkKm3MZ1v/icu65yDkmnwE5u5OdePbCPUXXgS+QHf0lhJAX3YxhDHhXMxW4p+VFQ16pzYvlmResobhUoIOWumziGq4g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+x+2YsE0m/n7cz0pMvo0RBfr4LVR0j0mluaIsyyJWngw66SH/XoAIlWnnGHH23WVMQEeeLkhgVX01mH6zlXu+xwxzgZBLLy4f9Dc4ch8J/mDpSEzsD7Hq7Yix2gLMo2pkIf8jf2SuTl2KjX135v4LkCgHzzomJhTlNysmsQ7A8MjMsESRLrmgTK1gX5T5B8BokRfrBEBTpfH3J/MUjBCzaiI3HfHwWXJK02YObYiLddTRsC40f+e8MJ1M5DzByiHI79nS9iKpCJlKF0rd2woLj0JG1eja3vZxLKtGB2zvBTUQffGGQEaA5uUzvKjqQdCWB60Cka6Qrk7QmnizebrNQnYaIY73aaqNuhQyVZ1MpMJF9iehofpjtRiSoOl5kvdc0+OkYkirKiwKs9TqwpJ9kzeT31+MwuKCjQvfhIVX8S5wmk1SNh+YESztdFeUuSHmKDbybOrrNLfE5Hm8zzk0oseOHU8qSAHS8wClRmj4eiWbLLb5hY1gn6F6ZuY8/yZ2t9dSS4SCDchGyX05KWMjTFqFcLP3EEcHY1hTj35LNObXECjrJOtHXBylHzTziBHsRSCGncLCgJMMUJfO33yVHcvE32K+NT6lJ+ADNT6td4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9caf4a-0c32-4c40-a986-08def45c75a6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR10MB6228.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 08:18:29.5858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3mi4U5DCaU4Wuj4dj4fOpm8uozYUqEELw7Odj1u4PIZ/3/zyI0LvZdF+1YD6UsPzJJGLhtYqg9sb+p76BWOOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608070060
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA2MSBTYWx0ZWRfX23lHXg9P2Ub8
 C84P2XjA8as8+c9E94J8kKSPbP7rSe260Y4ZviNUcHtT0xd0R/zXzZxsBHRwgYAuseQHO2MAl0q
 Lp4y9oKzR/eJHvczFoJpk5mwg2SSbp1bOxLbgjeWKpytFvfiu7OM
X-Proofpoint-ORIG-GUID: Ht8UUj9AvQxDEcNJiW7EuE8LsUAHI2-I
X-Proofpoint-GUID: Ht8UUj9AvQxDEcNJiW7EuE8LsUAHI2-I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA2MSBTYWx0ZWRfX7U9zAbfcyv/A
 7BLeogJO+fHSPa2NPCwxyXY/iUBYfbGXM1wnRZ+SDb5owXdKISu7sRMchyDVLiaDDRRhgKsAKN8
 qbdtohDvvzKnJTTQ8KG8+iar2B/x+AfZaoCIz5ZxDw9mudzAOVEpppKXsyoh/u8Q823ckMd7mOd
 979+IsomOcNmIG2c+N4r62nz+dz2Px5anbJ8eCQlnCEsHBhPp+7RuRP1FYB2skXgfhnPk38wgdc
 ZUYeYgvDhYNXrgR7JsYVhLacVJYV2XT5jtszN/M/UFlWdsO+0haEO/ymXnbk7Z9qKnDYgK5PWIM
 Gt/Am3bSaPkhAe8w06AMlCkknp4GHafbntSnbBRgLxpeR+EISyy2293heycsz4nKhJNAcLmoItl
 V9cGKjjQ1lrP49TUdWKLKp9kuLy1gjEOlpvIK1yLAbg4qhgNA9Pez9WNBVbt7KR0C7XhOTNpX1y
 cNExk0frsOELuo8jFBQ==
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a7594db cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=N54-gffFAAAA:8
 a=UpLBKnZkSEUIMPGQdmkA:9 a=QEXdDO2ut3YA:10


> 
> On 8/6/26 4:39 AM, John Garry wrote:
>    > Getting the address of embedded host_lock structure just requires adding
>    > a fixed offset value to the shost pointer. However, getting the value of
>    > the host_lock pointer requires loading from a fixed offset to the shost
>    > pointer. The latter should be very slightly slower, which is relevant as
>    > this lock is used a lot throughout the core code and drivers.
> 
> Hmm ... SCSI drivers for which performance matters shouldn't use the
> SCSI host lock in their hot path.

Any driver which uses DEF_SCSI_QCMD uses this lock in the fastpath. 
However I don't think that many are high performance HBAs. Maybe 
usb/storage/ or pmcraid could be consider higher performing.

Then there is stuff like xen-scsifront.c which uses this lock in the cmd 
done handler. It's used a lot in lpfc and also in code which looks to be 
fastpath...but that drivers is very complex.

> 
>    > @Bart, Can you kindly build test this? s390 and sh were causing some
> build
>    > issues for me. Thanks
> 
> This patch passes my build tests, but an update for the references to
> default_lock in the Documentation/ directory is missing.

I'll fix it

> 
> Otherwise this patch looks good to me. So with or without the
> Documentation/ update, feel free to add:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

thanks

