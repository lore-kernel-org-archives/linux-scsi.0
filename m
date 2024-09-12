Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF544192B87;
	Thu, 12 Sep 2024 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152541; cv=fail; b=OHkyHTv8gpiAIol4tK/P0Pv0MeYKm6yWqEYw7hslxNR51P95Cvu8WR1kBswcXgBWO++jmLDBo+GBE9t0mZZ8VZJaQ4pF+awrx4jmGI47fIDcbtP/i5CkjoHZEqqMzr52Ko9ZZqzZi9F1ivflJFw8DZHuUxYAQ+bN3ojdUxl+G4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152541; c=relaxed/simple;
	bh=q263laJbRQaNJHLHJbnSn9RZKsELRej4zELDK2oUaOk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EsHn9r6KmpYChrRJnJ5On1yDxFvheWSV87PMaV6uS3kozOgWBhcgKuvmAla32L6AjRunbJ8v7PsDzzQUu74cD3XzBTajOT7XUc2dKS3gz5Jux7/6hGK4+TmGhhz+UYXwtZaCPPwJv/aB4itzdwcdQIogRHYzzbpmpJfxhfQOXVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LdCfZl3Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=abxQbjlW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LdCfZl3Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="abxQbjlW"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtWYC014144;
	Thu, 12 Sep 2024 14:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=OESS2rOk6HFjOpffM4Bsw3lUEhY1ihYazGH912Kmzkw=; b=
	LdCfZl3Q8zL+zLKNzdG0LgMCjfR9Dk5VtkAm3i0Cas9Yy5HYHWHwFVsc9t4YFKLd
	D8EbX4ke9ADzwqiw8dr1d+TP6l8O147Ai8+KEH1Nhmvp4vHdeB7kjERLokXj3THJ
	zC9cRZfiX81U2QAypz+nEhTU7JShyDLuop4F0q8A8MqiQmKJvjLEi2wLnaO0M5oI
	nKamrrJ4HNVOvAhBKJq+/lyAV9mV1OfM0+Pi1CaG2Qb32QJlJKKXW0OdPyynDmaV
	y7TsSiDtWHtjeIJrDiJeOs7p0jo16k+ztnvbkwbpRZiHNCzFxHnfTrjzue8R5V3N
	pQjvPrNxRHjevCSJtdTyZA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gevcu45v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:48:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDdUJB000300;
	Thu, 12 Sep 2024 14:48:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9d0pk6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 14:48:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJ4MqO5nA8ro9PkefRHi0M8Ydv4mvNFRjOMsULI20lJPoPbebPBzvPlxlK15sBkRJBjQ2DObPjF5YCxj186kkr9SYbSZgtaJcvukVFO0EFlqYcsCYNMVw75Lch1lX57oAuMkhMsVZwJsgFRqzcsvvWJbMiqr5jbgR78G+rqUfLhUkUjx1UtEg9dUmte+7Ky5KAQ8JhrfMUiYwsIiico4JTVAmD4iVX5Pio+6KSW2szE+eBnM/4rRuVLG5wIXec/UpiNOTWVB5h1+7hFx9uZF7kOCkrwh6tH6TvBZAUvC0E/qRnD8WCSUx0iKS91RyVfp3nQkm7rpMs+YF4ARpEHASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OESS2rOk6HFjOpffM4Bsw3lUEhY1ihYazGH912Kmzkw=;
 b=g+JgYfRvcY+hG+pMHT+zEr5ORlEyECtxrO0KukDdT3TCkq51V8qVQC2RQBdY7oBB8R7FKeVPynLXtT0sa8GH//sNSBeOsFWyaIkOQf+1snRFnMExQb60lDTsQzP3QMbg2G+HhOh3pmWFex/58m0B06WVw3OVm5jQ5gSSIImUCsC/DXzdSzkFkkBqy4pumqDvQw460jeFoFhNjzghzFKQoL1Y0M57XVNq1cDqXNsB6SKVBPPw4crFFLHKq3a2OhdlfWQdg+7DO+41yColWlA8rFfRerUXHXb8N/Hd35BVIafOKwdmhPwkP0xRC+iEh17NcxkQAa2rScSfRZn89aSyAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OESS2rOk6HFjOpffM4Bsw3lUEhY1ihYazGH912Kmzkw=;
 b=abxQbjlWNC7zq47GIIe1Fq8+M8E99bf9aZhVZwu4TsKTrJgnYR/Vd8WAft+s90lJRDT8g6cV6jxKN6ooV130pRMrnCn+3+TAlhX7cYLpW9WdvstNSXsNR35sQnkPlDosjm2QP8Z7ju82TY8Kgv1y5Rplmj7eBWh88e9fCYIbWrg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7385.namprd10.prod.outlook.com (2603:10b6:208:42f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Thu, 12 Sep
 2024 14:48:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.008; Thu, 12 Sep 2024
 14:48:14 +0000
Message-ID: <340e4306-4442-4276-b420-6fee8ed97a7e@oracle.com>
Date: Thu, 12 Sep 2024 15:48:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] md/raid0: Atomic write support
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-5-john.g.garry@oracle.com>
 <20240912131803.GD29641@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240912131803.GD29641@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0369.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7385:EE_
X-MS-Office365-Filtering-Correlation-Id: 3af499e8-2d38-477d-33e1-08dcd339ee26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZG1jTjJqWnFuSXhLVGJiMmFNYy8vMVZrc00rU0JEU1pBY0VzSElWa2N4bkxL?=
 =?utf-8?B?Y2hQYzJOcW1ubVdHSFhHY0VQMm5lMXBIY1N2RGJVYU01K0djOFp6WHZVUWFy?=
 =?utf-8?B?NFRqcTFUVWJXYm9FKzI1dWsyQnRJUTFnMTYrVmhIcUFJUmlSRjhMWU96MHNE?=
 =?utf-8?B?a2x6ZFJ2MDM2allwcnJmVTlvRTdXVXF6VU1zVzF1bCtCclNCZ1BQTG10QWtt?=
 =?utf-8?B?dlpickRPMTJyQzd1K09ZVllHeUpIalI1MEIrdFRzTXM5SVQyWkhBQ2Y4dGR4?=
 =?utf-8?B?OFgwYzFzdGwveG1ranY3U3VVSVJoOExMMmhFRDMxdWkxMkxYY2Q3M1dMdlBk?=
 =?utf-8?B?eFJaYXJKemV4T0MxVmY3OEpFZDF3bzVHV3Q4QWlrRjN4dmp4MzI3ekNKU1V4?=
 =?utf-8?B?NlJQc2tnWUZKZ3FuSlRqV2ZNV1VmLzhVVzZweHF4aW40QkQ4dFMzQ29uelYr?=
 =?utf-8?B?b2hLRXg0MkIvQXR5MUxaSFhXdDNWS3R6S2pIM0JzemlGZnVTZ3RHRS9tS3dZ?=
 =?utf-8?B?eXBBS1NBTmRIOVFmOEJaalFDcTgxZUIzQTZJRlpPSzBQTzc3OHJ3cFMxK0t5?=
 =?utf-8?B?RzNtczIvNS9yVVZ2cDNERHdrRUhVSXJhZldFWm9VNXVEL0J2a2U4UDhDSXI0?=
 =?utf-8?B?S3V3WmxrMzhkUjJrWXkxN2JNRnd4R3Bxd0dudEtkakozZGZaUHQxQVBPNEhh?=
 =?utf-8?B?N2l5dGtzTSt1RUFCUjhTcmRDVUxrT2RiUUlyNDJNVm01TUpWWmxJNFcxV0Q4?=
 =?utf-8?B?OVBOcW1ZVjdwazlpVzhleDhPd3JKendhNlNkc1VBd05vTkZpZUhRYktobHpp?=
 =?utf-8?B?dGNZWDh1T0JmRHJ1UE01dnhPazJlVGdpMUNlMkRFQmlHTjVLd1lQNG1pTFVn?=
 =?utf-8?B?QWJLTFo4NWRoKzhWZmpMVzVNaXE1QWJkQzY1cFRWVFR1VkNGc0RhZllMb1py?=
 =?utf-8?B?cEVWcnNabzh4L2pDSFM1endpUVYzZ2MwcDhKRDZBb1BHeEZTb2UzcTZzTTln?=
 =?utf-8?B?alJNKyttQTBjNUtLZWRtc3BzV1RiMWNvalgrUkNsVEJMT0MxSUlySmR1ZFdu?=
 =?utf-8?B?QTI1ZE9ENkgyUGczSHVBWXZXZUZ2QWZDUGNmRzlXNXExQ1FvTHJlOFdXRy84?=
 =?utf-8?B?dWtkQ1h3KzNPclQvN0tKQWJIK1gwbi93MXFJUllmVS9pL0szcEpPdEgwOW94?=
 =?utf-8?B?Q2w3cGlsY012WCs0MDJNRWdjVDVaaS9wS1FHZmRCV2dZSVowMlJjQlp1VGVT?=
 =?utf-8?B?T2lDajJZVVZNdUtKeEVMVXpQQzd4aS85aTIreTc3SXBwQ1UxTmNiUjNhekNU?=
 =?utf-8?B?S2d1MUM5dDNSeElvSURQQUFhT2RBc0hBUGJpR041K2NZR1ZSbng1ZWswTXpm?=
 =?utf-8?B?bTlab2Z3RDdDK05FMDdzSXVoeXJkUktIRWU2MHVDTE83bXJNTjkxMFArN1Vt?=
 =?utf-8?B?Zm5Nc0h3dXFHK3ZCQ0ZEbUJocnE3WGNKZjVoSGZmSjRZcVg3eS85VmtTbE81?=
 =?utf-8?B?WFFxa1BVTytwRVRLOXliM2MrY0hqS0czaWY4dlQ4SUtsWXdzU2I0SzB0eWNN?=
 =?utf-8?B?RXNRdG1LZVNJdzE2dVZQSzU5SGg4eVlVd2lNd1hENzVNSmgrVWRPY1VmL2ZC?=
 =?utf-8?B?NTZ1d2Q0NFA4R0VOdEtJNVhYUWY0dXJla0c5WnpCQ1p0eENDNy9qdGsxTE9Q?=
 =?utf-8?B?UkFOczFsalZyd1BGQjJVeXhQaXl4MXdnMGZvTFRQZER5VHM3cFJYV09MUkRS?=
 =?utf-8?B?TTZyQzJtdGxWeFhKMFFNbFJJWjhuWlpjY05kd0VaMWwxN0haTU5LdE85cERt?=
 =?utf-8?B?U3U2OXFXNSs1MXVjSndEZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFVraEYvaTNRVjV0WmdVb1BvYkVRNVdCRjBFZ3QzUGdvUkZvYWZJaS94R3R3?=
 =?utf-8?B?MlN4R1ZZOWg0U0Q4MEFoUCtmZVpGSkNoM2JOb2NDNGxGMHZPeEZYWituYVBZ?=
 =?utf-8?B?WThyZUhEMEdnMmhzYzJ6VXRrUWd0WG9aOXdXMHdQYkNSTTdrZHc3Zk5hWHox?=
 =?utf-8?B?dHZPR1dTZm9kSjRaK2xIbGxLUXBlNGkrbFJsR1NmZmFiSFpyOHdkY21pdjI3?=
 =?utf-8?B?Y2hDT0kwVlQ3S29jQWQvbE1PUkpMajY3UGwrTWMvWm5uS3J4Rm1CMHZwdWQx?=
 =?utf-8?B?QTBiYTh4eGJvYTlmclNVc2Jpak1iZEVhWUh6bDB5Q05lS25SMUtiZWlXZTRY?=
 =?utf-8?B?bFRGZGd2Zk5LTTNqTmxnS1ljanpKVTZXMkxOS21penR3MFZIdk45SEt3TGwy?=
 =?utf-8?B?bnJBVk5JeVdNUHkra2hmbEZoU1lxUzVLS016QnRubGhUZHpoMzFhQ3lIdXdG?=
 =?utf-8?B?amRkRWNIeDhHZ3ZGdlR2U01zK2FUa2lCMit5NS8zcVFHek1GSTNsT1Y1U1o3?=
 =?utf-8?B?QzZkTllwRnR6OTV6L0NRbzZXRFFkM3NmRWRXTXhIa3RWb0Q0N1VEb21iMGQ5?=
 =?utf-8?B?dEdWQ0sxSEhyZkl0UzFxMzgxc1FlMkJUMEFGTXlQaS9iZkNqV25UWjNHcFJk?=
 =?utf-8?B?TERjUVJ1enFMKzN4L3crT2lnWFphVU9yQU41cnRjdjhzZXNHTjRZeUhRVk1i?=
 =?utf-8?B?eFVnZTRDSlBKaHN0K2M1bmhIYlBudzZCS3FsS0Yxc25sVjk0T1c1bENDVmJr?=
 =?utf-8?B?VkRwVEMrdmxjN0R5TWkrYTd1MDNzWDlMb25aQnJxUklkRTVOaC9zMndrc2c2?=
 =?utf-8?B?S2ROSndyM1hXaUxKa1Nxam5SelZ4aVU2U2pBMFQrMmM4U1NFRkJUSlJvdlpK?=
 =?utf-8?B?dlVUdDlxaWVDRkpQMUlTTUFmUFhnbCt4SzFRa3BKZDdVM3kwZy9jMWtXandX?=
 =?utf-8?B?VHZ1cnQ3YlVwWE9kdUo3VHJSU0JDdUovVklKbTFtQ2pBcFJWenFOK2w2SXd2?=
 =?utf-8?B?SjhId1lPY2E4MFhrQTZNK0NqcVM5djNxcEx4bmRIVDdzKzIzdEZCUU5yUlRz?=
 =?utf-8?B?TytlVVNINEQzWWR3VEtyOUdBVk92aHU4bjNIZUFkejkxZEhOWmZVbjR6aW1h?=
 =?utf-8?B?MHBmWU1OQ0g4NjNvNXFGR0sxT3lGa3FxTUgwczBCWjBwa0FZWUVUY0NHOGEx?=
 =?utf-8?B?R3MrMURKczdEcDBkaWFPOFRQT1hLa0lMZkVSRk5rS2hXYlNvN1hCQnNxODFw?=
 =?utf-8?B?MjlGZW1zYkpUckxIdHN6TVZGNEVDL3d3bTZuNnprSHJEcmNvVFhFSVFLRHFk?=
 =?utf-8?B?em05Mnlvd1U3VUpQUHlsejV1VlQxT2RLenN6U0RIOVJ1RFdVU1JRWGp6T0Fi?=
 =?utf-8?B?Wjdib2d2NWY1cmthZWVJNm9hRFNlWUFQMmN3d2lBSVNLY1ljeHNSdWhSblBQ?=
 =?utf-8?B?MUNZUXNNZFphRkM0SHY0WHRKV285dlUzbGlicjV6ci9EaW5xVTJLZDlTVzd4?=
 =?utf-8?B?blhZYnBQUmN4VG8ySDRQMDA0ODVnZFpkVzdCUEhPK1kxYTQycjQwSW9WWlRz?=
 =?utf-8?B?Q1JDQ2owcXZQeGNUNE5jSkJBUFh4cXd1cVpYUFBkUDQwZ0RDaDh6TUtQTDNh?=
 =?utf-8?B?Z1UxZHQ2ekZ4bGxRVWpjN1V1Rm9CRmVLY3VFT1VtbGlMTEZKcFBKbUdKV3Nr?=
 =?utf-8?B?Q2REeVF3Wk45bmpsejBIbUlsZGhOdjF1cm9hUFZZZnhKbURLbDNZMmZ0NmNB?=
 =?utf-8?B?Y2RQZzRUYWhNZHNuZ05qNGZFcVVscml0UW5mdmd4MjNVQ1Vvd21OanBWUnhs?=
 =?utf-8?B?WU93bkZlbG5vbjI3b3BqTHIzd1NtRW1DemdJa3JCdzBDYzkwZjJ5NmhzSWJx?=
 =?utf-8?B?NnVnK1dqSFgyWEg2M3ErMFBEQ0diNE0wOVFna0NWN3lsSm9CaXJyODJic0ty?=
 =?utf-8?B?K2MxbVpMdW8rZFhTQVRvL1I3dnduU3dkRk9JbkxxUUhUYi9OcUc5MUEwM29z?=
 =?utf-8?B?R2dhZUlMZlRoR2xwTDJKQnlIeHdxTjNZSjFmU3grQXJBeHlaVUo1dU81QzhM?=
 =?utf-8?B?MUd3ODhNQ25zaS9Lc0JoKzVpM3J4TjRjNHdqYll4RGZSYjQ5bm1RRVNhRTh2?=
 =?utf-8?Q?8moPxDKOeRNERKXzkOk9oMRkz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1vWgvL9o+BNqU8ySI8Ym5MlcEkg5ko2+DgdUKLy5FsB0OysvhpJ2i2ApnxhlaXdWJRYo1BsMCJf7YDBFbplg/x1VTWeZnIX8aJKgfYe6J8yY74/T8QeboUsupwEPTGVdsk6tC3qRzbGlJ6iRdhcm+QpH0fKCvVZnXpsnWgIUuJ4adhAOb71pVCD7lADLALDaPy93RbFhadshkPKSIUEVp00F8Ad4sbsXPDVYT9lmW0HWJI35m9zOS2ibIV5yf9Q0uTG51zJoHn38CWu9/aidaM7sZXXr3mwls2YSJSEZbxWfbRWRCN2u11JQ0X4ytM46nii8q3wcBWV1R1h8OwB5xPLx58WzovRR8D+5CuOql2BcU87HxvqQTtMq1F+vcEfjardww7xUxFgNRLc2/Hx54nL8vwS2gtUuNq/IFLftO3DPUyQXTKvFmZbTCPVi5aXoJLn74UqzO/jTEYqbiZzS9KvRDtmVbQJ8SdZ6OJ+9NrfPp2aJhvy4kHDXe/TgUFMb3ntt2rSHIRcEA0JGD6VIkwoV3/OMQRM6aH3FV10sK61ncS5oD/rwxLJKefFqoo2eeocFZ/MpyWW+Zpb/NBQDdblnahRFx4GZeF8AmVLIG2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3af499e8-2d38-477d-33e1-08dcd339ee26
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 14:48:14.4105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZ1kwLlVE6kvdr1rHVjSPNDAwFlATwwksLIjtzPKtyjKM/aLrsa5FXHe3iKpilohYvHys/xO4MzFO0DoI+Kcxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7385
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_04,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120108
X-Proofpoint-ORIG-GUID: x4ljTBegdFcc8hW501h5HswIs-7mtsZj
X-Proofpoint-GUID: x4ljTBegdFcc8hW501h5HswIs-7mtsZj

On 12/09/2024 14:18, Christoph Hellwig wrote:
> On Tue, Sep 03, 2024 at 03:07:48PM +0000, John Garry wrote:
>>   	if (sectors < bio_sectors(bio)) {
>> -		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
>> +		struct bio *split;
>> +
>> +		if (bio->bi_opf & REQ_ATOMIC)
>> +			return false;
> I guess this is the erroring out when attempting to split the request.

I actually now think that I should change bio_split() to return NULL for 
splitting a REQ_ATOMIC, like what do for ZONE_APPEND - calling 
bio_split() like this is a common pattern in md RAID personalities. 
However, none of the md RAID code check for a NULL split, which they 
really should, so I can make that change also.

> Can you add a comment to explain that and why it can't happen for the
> normal I/O patterns?

ok, will do.

Cheers,
John

