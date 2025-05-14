Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC046447;
	Wed, 14 May 2025 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747220183; cv=fail; b=MycxShLgNLVJMBhS5p9u06wzC7mBl6dwlCKbTNd9M++tmyoZpa6B90xgnPYqWo9XXj4EyS6XJnLZD1tkvxQ+Sk3MN7LQ2aSEsczt5BjVjC+FoaHgvBvm4vOOZVmM5pP069ajUqnboNrQm1/hnHqj8IKh5uB+JwDT7q38R1Uhszo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747220183; c=relaxed/simple;
	bh=wpTOFSqlDeITBE93mQHD0tA9wy/S+Gk0l5LUmO3mCq4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tzKgiLjZWBAfAYFT5Vlbr8CSh7vB8SJqWbDDtbgI7RHyFwwTFo2eaqUvXsPwFndDNHQDfRZhhLSKfE+0oDt42lVz7lfi6e2HToegOjPx0Nmh5i1BgbX+tmt+BTx7gNVlRwxsHcDsgMEgtUFgkcL78RBt6jSSdC2AlI5l6s/jjB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UxtW4e/a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0O5Nr4am; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UxtW4e/a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0O5Nr4am"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E0fvO0008008;
	Wed, 14 May 2025 10:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kxGrY6hTS8X4SL1OB90DrYean6PNtnHow5qO2DdJcBM=; b=
	UxtW4e/aQSGFI5uG4MjKf2xIAKiD2gYNiW/0OP2P6g5ZFJk/wpMv53lzRridqe90
	iDuma7FDS98++WHh1XhWN0GNpETpgJGFZWnIHTt+P6ghdyZQBFKJJtxOhiGLTER7
	sd31FlY8trXwMRaF8DVqHrVJtD1RHZZJAJMliafHYcnQb89bF4J5Tn0Cwrgi4mFv
	4xK6VDM9smp5D8p2lxqbKCO8gAuEVyjVEek3XvYzWiojtf38zrS8K112bxfnA4cO
	dWX98ONFUgjnQgwtqiqOI1yK+/7WTTOQn4xKkMQypj+GVC/5W39CHdRdosD4dJGJ
	n77+N5WB3l8/lnH9c3uyPA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcrh8uv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:56:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54E9VbRW004270;
	Wed, 14 May 2025 10:56:18 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013063.outbound.protection.outlook.com [40.93.20.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmcjgwn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 10:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPbK44iJh5LvIrJrv77HX+bSqGFkdFk3t+X5C8IdYrN5Q9gZjQJfRAKq5fITgZyWxZnzzpEsJWxUj9iWrUEQri4r1VQuqi/+dmptX2X394NHC1cZsbsC5wgq97wEv0uBNOKMf5kQPMzMXgwFmW8ibmIkVtj3kbJDVk2M0RWHWkdjDnwgUs+d+PfhkaEve/jIPcynaQfPclHXo6IAy4FV4hufedDggQFXE0aoD41lx8Ca7hrhE8XGvmUxNkcxWnke8bZOOyzsGx5YdV8oiigeBeYD4lp8BhwahimsgM+NJb1wqK/7lKFXC+EBat959OtwLbHJ4Mc8UyQ2b8z4heJamw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxGrY6hTS8X4SL1OB90DrYean6PNtnHow5qO2DdJcBM=;
 b=ILSGYQPoTiAIo6TA+w3HD0tTuKiy3PGiroRtw70LCwaLh2QOFSK6eoJcigZXbWQYUsPr2a+RArBYCc85PWdLPwE1/0rfF/IAU2jQfaCbM+NCuOJnKDzGlGaucd3Ia2nKq5fx53TLnYn3CY7Dq0W459uC2BCRY+XHQQROcW3t+EQDSKFhwz/ZRD8R/065e4wWk3DiNoncSYJ+lMayTncH5LPi46Xtppio8q69gobIANS+uQ8bLRQmEZ5aWCdgc5VWHxsHyCuiFRz+53IrmAmE26kwTc3gJmkRwU3qPF4AdRBJ/6HejgzusMTUqRnzxE4N6clLjJ7KMXf+GNYFq25Cgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxGrY6hTS8X4SL1OB90DrYean6PNtnHow5qO2DdJcBM=;
 b=0O5Nr4amF8cfaymM1ILQUnAozxudk3MIUjVHGISeBF88gDAtarFLdmuvHPzYyoezKirWqAzaf3+c4OxxmSC3ncnY1kzlU+T4ObRnldLmD3D1jX4/3v15d+zfyv6Nn8iuFJIitcGDA+swR98ZIy0pFnZeFcFdnPBc3iCRorBsmjE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB6319.namprd10.prod.outlook.com (2603:10b6:806:252::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Wed, 14 May
 2025 10:56:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 10:56:16 +0000
Message-ID: <3d68de99-bdb3-4a06-93f1-298b2e170cd5@oracle.com>
Date: Wed, 14 May 2025 11:56:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: target: Report atomic values in INQUIRY
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20241008020437.78788-1-michael.christie@oracle.com>
 <20241008020437.78788-6-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241008020437.78788-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0586.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 04854f96-e4af-43d8-3d5f-08dd92d5f30c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1duNUE3K3pvZGV6bVova240aThEaTZmekw2R1dIZXErUzlkZnBIOWp5b1M2?=
 =?utf-8?B?aHhNK2hqWDRVenphbkM1eVM5cU1OYXBhWGVmME5vd1dkZjRTeEhIOUtJS1JU?=
 =?utf-8?B?NHdhaktsNm5jVGpzSnh6VVhyWmlhbGRpMUdVU0pCM0hPbW1NTHkwa1lCem9N?=
 =?utf-8?B?SzFXU2ZhM0VwRFdZQkJqbk9GUHdqS2IzdjZzbXdBV1NSK0pJR1h0MmpYZ0pH?=
 =?utf-8?B?MTcvS3F2YTJxNXJwYVJ4L1BPZldBOFRTanFyM3RsRUFDcE1JMjlFN3R4MDFQ?=
 =?utf-8?B?OHN2REN0M3RkYytuNVVhWE8vM1FsNTZLY3E4d001dGlRRTV4aGgvU0xBOXU2?=
 =?utf-8?B?aG9Fem1uT1FmV1JYQ25YMkF2bEFIVklRWExrQ1JhZTlWbWowMitQV1ZoWjZM?=
 =?utf-8?B?b2Y5b0tZS3RTVWFNcmtWRUluUkgwRnlOaENjdGtEOHFDVXhNVGR2bmplYXB5?=
 =?utf-8?B?RU5jNmhkZlFtZ3pLbXVla1VBY3ZnYi81MFZKUXNEa2pGdXFCODlZU3dtaWNT?=
 =?utf-8?B?VjJGVm1HNnZabThoM2YvZWEwMHlNbE1YT1hSbE0vdS9pYmNXT3lTcmRrTzlH?=
 =?utf-8?B?SG5XQUJZeDNhOUI3NHdiZ3h2VUdQZmU1RUE2c1VzNmJZOEI3c2x2S0FmVG1l?=
 =?utf-8?B?ZVNNVStZOEpEMjVXd1E5SFhsYW5JeG02TnloTkJaMHlndGVKUTN4NC9xZlNW?=
 =?utf-8?B?RExMSkhFMUV5K0R6cFhyWjJXRkU5bmsyRW5EQnV2aFFzRTR0Ui93WVcvam04?=
 =?utf-8?B?aTJDeHJrUmsrVk00QlBiY1BSS00rY3B3WkVWQWpNMWdsQVZFaEw2Y2hiRkcz?=
 =?utf-8?B?YUkwazl6OS9HZmk2Rk5IQjZ0MTh2c0lLYkJtSU9VTWZ0WGxJN2hpQ2lOTTdT?=
 =?utf-8?B?QkxuTEJKcXdGaWJlNVVMQTVPVVBtYVlSWXJNdkpreTdUbGRCY3dSL2dTZjIz?=
 =?utf-8?B?Y2VDWG1mQXl0SWcvTGNvVnlGN3R3OFcwUC9Ka1NQVnhNNlBmYlBCMktBTzZs?=
 =?utf-8?B?OFRiWjZwTTdxUGVabjdUcDdhck1ieEtQNjZmcldGTWxqL0w3WlhoRGNsNTRl?=
 =?utf-8?B?aGY2eEsxakNGelZzSmFVa05UaXFGU2NZVkx2S05zdndOeEM0aWhQN01zYSt3?=
 =?utf-8?B?aDU2V2VhekxPWHVEZS9iQUN5djQzR0tqcHNQUnp0REM2eEdxU01QVm56eWt1?=
 =?utf-8?B?bE1KbE9WRTFnenlYRGNWM1VKeWM0ZFhxZmNiNlpSdWdEYU91Y2NMLyt3Q05B?=
 =?utf-8?B?SkNxUUp1QnFxZG9WOVhvMTJldFpkVldnSTY2aGZJUHFSeWEvVnlzNnVSa1h0?=
 =?utf-8?B?WmFQTHBXRk1ETVJPYU1GQktIL1d2aDhVV0syWEVndFhMM0I4OHg4TlRGcEdV?=
 =?utf-8?B?WTA3eldaR0dxZTQ1RFROaTZmQ1BFMkZyVzhqcm5WSVZrREI3amh5ZVNXM2Vt?=
 =?utf-8?B?THhDdUU5cmp0RmIyQnMyTFBpVEU5eWQvalpPcC9ZdVlvWUFMUEx0ZkY5WlVk?=
 =?utf-8?B?Q0ErT002NGpIMG16UVhOVVFYQWJtNkZRQy85NUFicDd4MFJSbGFPYVord2s3?=
 =?utf-8?B?cUc5SFhqUlQ5NVVCQUV3dVhEeGV4V2x1QTVSd0NyR0NNa3lHOEwxSTd4aXZl?=
 =?utf-8?B?Z1Flc1NHZVlnZ1h3SUdnKys2ZEpUcjBJZjZMNjdmY3pML3dvU2hsa29YSXVN?=
 =?utf-8?B?UjkreWs0M1dORnNkUzI2cVFiSEtHYXVhY2dEbjl0S05zd081ODBVbVdSdkVO?=
 =?utf-8?B?eUJGaHc3UzdubE5adHFhTDlsVUxzbFl2Sko1aUF2c1pNeUFhd1FUejVwRjVZ?=
 =?utf-8?B?djdNdkMrRmNMUkZFbkxPUXhrczBPcktHb0paSEs1MzVZU21pblpHbmtrYnBv?=
 =?utf-8?B?MU5YbGkrZkZhUWIvTlY4TngwbmY0a21qWWVLTTV4blR2NjhGQ2ZUVTR3Wi93?=
 =?utf-8?B?Ymo2MHlUbnI1YmdZdGUzVFdIUTQ1YzZYcDU3Ni9icVhnaGRlTE9nc0NsWmx3?=
 =?utf-8?B?Ym1UWHBmUjRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmVvdk5SZDh3K2dCei82WVpueUZuTkFqL0VITDZmTENma2kzNlF1ZlZ6eVNQ?=
 =?utf-8?B?VFNsWFlIMGdremZ4dVhsQkx4QXVWVU5aVG1PK3AzdTduQzlBOGFmOUNTNUhZ?=
 =?utf-8?B?b1FsWGpxY0syZnRJWlZ5ZDFpejJLa3hyNFQ2SXBidUVaaWJaS0JiWi83dGlZ?=
 =?utf-8?B?ZDUyY1k2cEtJS3kyRURWZnpDeGl0TE42ZWRFbzcvVXU4TmttK24wdlhBaTBP?=
 =?utf-8?B?cFBEcEFUcXFqd0pnZ2FHbCtCRzVnOWxuekVIeWN0bUUzZkx3UVE1YVdlNkp2?=
 =?utf-8?B?UUdRUE1TdCtYazZ1TkU5K29BbEgxU3lhRlRzaGtoMzg4TXhnc0o2aXBaVnhH?=
 =?utf-8?B?UnlxaENjRGZOY3FZeEhQNjQ1SnJPWGNJUGZpOGk3VmR2VC9jYzJYaitDZ2JS?=
 =?utf-8?B?TUZoajIwSk1JclBiUE5nVkVxSHNjNkNQenRHVTBCZU9iMFFYM3lLM0ZBeWo0?=
 =?utf-8?B?YWJSUUxpbzluR2pVVkFONlJNZXlPTjI0NmxreURsSVR3WXg0Q2phRnVzUlEz?=
 =?utf-8?B?d1hDV0pHYmR6cUc4WndQZVp6dnNZOHJGclMzWEpGUW1yalZxeGRCTWRSeXhZ?=
 =?utf-8?B?RDZrejI5V3ZrSmtlYVI5ZDUvZ2xSc2UvMEgvN21WVnRRMzJodU5xUC9wdU1y?=
 =?utf-8?B?MXFHOGZwckJWUEVSYlpQRkw5Y3J6Y2JGMGVTbmg4eWdzcEdqdFYzOEo3UFNM?=
 =?utf-8?B?eXQ0Y3NJVzN0U1o1cW1RcENCdWR2TFNFLyt2VlpDVncxVStQZkxmRnhKdnJi?=
 =?utf-8?B?ZEM2RmxndGF6QXQ2TkVCbUVYOERsS2RjWk5QQkV3SHI2SUJ1eU44YTZIaWRU?=
 =?utf-8?B?YUQ4V0NJOHdrKzVYSDc2cW5naGJrcUxzWXEvTnlnRDN0UkFGL3VDNzR1SGhZ?=
 =?utf-8?B?YmpEeHZQSmdrOEVVUmsxUTFPcGo2VlBWWDJFZE1IVm1CaFc4R2JZS2lOVk8x?=
 =?utf-8?B?eVVoamtoSmJFYmFPTGIzSXQrazlVOGlaTDBMbWtFRmdSazZPYU5vcDdsV1F5?=
 =?utf-8?B?K0RSemhQZGdGTkZsc2xHZHVQQkU1SWNZVEJZeCtEV2hOenpyWk9EamJ2YnNH?=
 =?utf-8?B?WVNzYUlVVzJBdDhWSGxoWFlPYy9qQnhlaFhRQStKREREZElzKzl0SEM2NjZV?=
 =?utf-8?B?ckFsZDVSNm9VT0NnSTZIVnNtdzhWR2FETFNGVHJZcjN0dnhFZHA4TGREVHk5?=
 =?utf-8?B?REVlZUIwMy9FVmVPVW1KNDRwME1peXFybHFrRk9xbzZxL0lyZkJabzh3Zm56?=
 =?utf-8?B?ejVVRlpvTkNNKzNUYnJQMHlNQVZsN3FBVktaeWphMWlkK1dnUDZITHpaRXBx?=
 =?utf-8?B?N1N1SHVYbkRZeG5paWRTaWV6TFVLUy96MnZET1JXREx2UVd3OUhrSXo5MjRB?=
 =?utf-8?B?cUd6QVY1bHZ4TGJLam5jZUl4L3BCUFZXT1FNaWc1Vm0raGIvRi95aGI0bUdx?=
 =?utf-8?B?d1hmYjZjb2daTkhXVWxCMjZOSWJjZ3lVaTQ5QnhSV1dlN1N1Y2x0TFFCWWRa?=
 =?utf-8?B?eXR0Ry95VUtMNU5sN0U0VG1ONnVMVnpTMWFXSGJCd1UrNEx3ZlYyZWUzZ3lq?=
 =?utf-8?B?U281R0RHajFzUVFuc0NyN05tZG5aTVBxWFlSd3BHQjNiUFFidHNsZVNya0Jr?=
 =?utf-8?B?cUhUK200NHhIYjNLV0VWbXM3VjVQU2VCdWhVR2pXUGFwckhJRGtsU0JlOGl3?=
 =?utf-8?B?Vmd3TFJuY2liR2pZQ29XcWpJTEd4eEVVR25DZ2R1ckZzb2hJMG1iMmxSTU03?=
 =?utf-8?B?K0lGUGJJazFvbFUwd0p5Sms3cVQyeGRqRE53b3VUQ3JKbEsxcUlQODJPeEUv?=
 =?utf-8?B?NzNZcW4yVXl6OStOQXBZc1dwUlZaZktzamRDbmxhcTFINGRqRlQrL0pnYUt6?=
 =?utf-8?B?RkVWTFV6cU1GckFZRWY3aXFMY2tZZFR3L0l0ZjU3cC9mbk9hbC9EVUYrdVJI?=
 =?utf-8?B?NDYrS2FsdEE2ZkR3ZkpROUF2RHh5SVNjODArV2pPUTF1R0JhanpVeEEySUw1?=
 =?utf-8?B?VThoUmJQZm9UaW04Q3g2aUplSDlKS2dUbStxNmlSYU9qY3Rnd3FscjdvQW15?=
 =?utf-8?B?UlNEU3JXL0VXeXBDN0hUOGxEcVI1bkRhcGIvaFkya1djSW1iWWVTUWNCR0Yy?=
 =?utf-8?B?YW4zUS9UamZ4cXBMWGpyWXBXTFMvdmg1VXVlODFtRWNlZ0JXYUFXM2JFQWU2?=
 =?utf-8?B?bWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xlZVf9mqy559AxMef0WpNS/G6BjrtSJr6e8flEwl+Q32fyIsSk4GZStLmgoX5Ani/CPMhAjUftCwEMciohPRMLpBophSUt6OMP1icf9y2NVDoW+HjnyHrI6NmPOadM5lez51a1SgzxnJRIkrDn84tnxs6Jmqg2W7ekfxjQ4UUOEFt9f8BQS30+AFrsBQNAAyy9CvWpMkY0mH6ToGyfvSkbHHjrPk4VJmz6g1F1rcExqaCUlNvm4hq9oD2fIxVTlpPyvzRlc/TUydNuLdvqxuV3j52Ri5d7bdRpoPweT4XKxuLurlM3+iGuihrsggkm4snEuAinWkT/hYIXF68Vf/Wu7SPb+9C69k8XUEgijL3nthVPgCe+FaaYFpg6wJgsLZiRQVWfhR2KQPVqa14Bjl0gvY77NtDcN2sCr00rkBohpt6sGHbk6nVLcqDT9mDazlmXqerEQPyNaIbSiSQ6TUdvf/nh/NdIYtCDJfxBSEW/5Be0hEpRCgGFqHnqySzzyaZiDJ3RZiC5NqciBkqaCMFpJXERpChG7/oMfQXXY8JPSKT1gRcmfllka4+2wAdQA/AcUX5U6W1Lz1IbHvc9O7gdkrxSdESVm0Sux1g/kz/I0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04854f96-e4af-43d8-3d5f-08dd92d5f30c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 10:56:16.2848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2fPtOa3qWFRlNMXy6FRlFMyNn6fM+XIv4HQmj9ZqHVMv4FwZVCzHDD7DH4CFDESkolyx2HZD1hw/Vh/XY950g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_03,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505140095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA5NSBTYWx0ZWRfXzB3rkMwWu05L Fb1TU9codUF9k6z5Zafpcfsk6XSZOWonOJLDARiJwNWQCnk1mJv8DtWnAktFqyCPFqpCpW+AUuE v2xe1Sgy6i8Zlj3nPwpcS+AIizM+o5B2mlUBSUROZ9qaDju7Z0/izPvSaXDSWgHczzLRyL2U8uH
 DqbMhbUR6FR4+8uIuRvPDP8RjcW4kbh2/WIBRIu6H0KwFsAmJwO3qHG6PeoehJYvhajoTEWj90u ll1IDXe2gFxb3D+S0NjMhHoozPBHYdIsfDmRGV7FOkyj/3rgbjcir1YCwOiZLtb8/GBaBaXoxn6 Kcth4e9JMBWPhXB+v4E+M9oeMjCXGEyp2p+BEz+AoeTHVchzVUlis4ggKbgy2XcPaorOyXhva+T
 8RlSJaG7pHc4+aG0kPwR2WjhIKQ65dPxCrZTzBBLsWOpIQLIh0Utsp9YZliMH5RI1dyzYTkc
X-Proofpoint-GUID: WdsaPPAp7OXOFjRy9xPG0gH7KLL-lcz-
X-Proofpoint-ORIG-GUID: WdsaPPAp7OXOFjRy9xPG0gH7KLL-lcz-
X-Authority-Analysis: v=2.4 cv=cuWbk04i c=1 sm=1 tr=0 ts=682476d3 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=gU33CeF6v-pkG9WdXZIA:9 a=QEXdDO2ut3YA:10

> -	 */
> +	put_unaligned_be16(12, &buf[2]);
> +
>   	if (!have_tp)
> -		goto max_write_same;
> +		goto try_atomic;
>   
>   	/*
>   	 * Set MAXIMUM UNMAP LBA COUNT
> @@ -595,9 +593,29 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
>   	/*
>   	 * MAXIMUM WRITE SAME LENGTH
>   	 */
> -max_write_same:
>   	put_unaligned_be64(dev->dev_attrib.max_write_same_len, &buf[36]);
>   
> +	put_unaligned_be16(40, &buf[2]);
> +
> +try_atomic:
> +	/*
> +	 * ATOMIC
> +	 */
> +	if (!dev->dev_attrib.atomic_supported)
> +		goto done;
 > +> +	if (dev->dev_attrib.atomic_max_len < io_max_blocks)
> +		put_unaligned_be32(dev->dev_attrib.atomic_max_len, &buf[44]);
> +	else
> +		put_unaligned_be32(io_max_blocks, &buf[44]);
> +
> +	put_unaligned_be32(dev->dev_attrib.atomic_alignment, &buf[48]);
> +	put_unaligned_be32(dev->dev_attrib.atomic_granularity, &buf[52]);
> +	put_unaligned_be32(dev->dev_attrib.atomic_max_with_boundary, &buf[56]);
> +	put_unaligned_be32(dev->dev_attrib.atomic_max_boundary, &buf[60]);
> +
> +	put_unaligned_be16(60, &buf[2]);

this is the page length, right? if so, can we always report 60 and 
ensure that the atomics and other fields are 0 when they should be? Or 
does that violate the spec?

> +done:
>   	return 0;
>   }
>   

