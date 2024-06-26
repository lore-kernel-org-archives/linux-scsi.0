Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FE815EFC6;
	Wed, 26 Jun 2024 07:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719388787; cv=fail; b=CPaFqn//y9FOHL9cbrFQECgCCOzvUmQ+rUnfmXM/uYuEkeB8712v1k8s1R01F1ts7i1i10d+pBVqczX7KtHIu4KU3lrV5Y+5Z2lmI9qR4WbEXx83HGI5RIri1YBva9zW/UpcUV/HKRxVbssOp262OJXblU/DMibZ3+d0TjlZXWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719388787; c=relaxed/simple;
	bh=4e1PNB2XY0Hki+YXIRsXJxQALZrccsi2XobETWVJ984=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BvU54rkfjqndL7MrMfgdrGj7ORMnfEE9r4I9MWKWr5ggNranK3qa0Vt3IXnUXQDoKonvjIqxIjOg4hbDwE00zHx4Z8jupBfSLhiLeNfcvCkxUs5jZk1Mj2BSuuVFWYluU9/4aIiMBogt0fTZcGwhz+BzkvC5k6/AMz3Df9Awyso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ERvfvnrU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e4xRQQ4D; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ERvfvnrU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e4xRQQ4D"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45Q7ti56028176;
	Wed, 26 Jun 2024 07:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=a+D4OzNePUsTtD2uWPgcalnm70BT4a+msH/grE2Pq+I=; b=
	ERvfvnrU6HexfGoiW65Qkx37L+d+AQGfvKzsfMu/pmGE1QFSXDljSYAwNihpLl1K
	i+SoCf8N/B9irBuslEpJmxpk4HXdpxbYkB9KMi9VfYRFkTH5yF4DXDchvXbgd2bT
	WITDCzjXZBdgwJ07JPhdM7ZjPKIjIfYlJBJb5X5eik69IGQICjZzGLeC/pSuZ3fs
	jf4DvgH37FLodi3mBjsYBgkqWRF2JYAz+side3I2amx2T7r7wGKO21ZlCYyo+NNf
	7BPzOA0cybkYUOE6OU4VAJof97qNgtFWcm3HsnYGDS/XVr2wrhU3AqcyV/Egakrv
	lE7MwVmC6xlURFBYNopHdA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn70an1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 07:59:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45Q6UObs037094;
	Wed, 26 Jun 2024 07:59:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2969ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 07:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvwqQY1NisSu82PXixAN+UritNUDeIGj+RPUEnvDBGEzHePb6RI0Q1wKKTPul8MFmSW1FSTeVvmVnQ6rjUS3/7ZY2BftLnyJFGw8BPygVQ8wkfgjpzmgMVF2T+3NDNTbWFHZr5fy5eQ4cxyg7f8RAnEsWkPmsytdH3sa0iTszM0LRB4ZCSXcm7wFgE/vqIZ4zuOILGmX45NRR7SFO1x+EXbyigpy2QOlaKBnJatGNNKvHc1FjIlqOhLmMwiFTkCM64ziDzI3j1/8oTkOWuzSIWbLg1KPWABrPdFLU7dwrrYsDdKR58eBLvyWsAsXGlEWlWzjoS9W1oZlwSS7j8uN8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+D4OzNePUsTtD2uWPgcalnm70BT4a+msH/grE2Pq+I=;
 b=LZIpo9MSlW6zfeunYGYfrY91T55DTKq79FiH6/pEfz3QO1VGwr+ZLZL3htIknKf+ZW+z83VCphfx9wklOhQldl2cvlC5JNyhvwWl8mhTP4cN8KqH7Wkjl6nDnCfrKvH5iOuHveKN54bQQK57g+QU6l97HwaAPLBQz5ksX5eEyE4lbUpYXpJWNo57J4PJ52REMS+fc+vtcYbH9LG//Xy1zon7aM48zZUXxW7Vx+9As1mIug2y8SR1yWYJpx/f5v0ZSwiym4ZuTTl78BO6h60t0VpQXF+RRPrGcjHXfjYS/PxOnnkeJ//LbrAdvJIglNN1P8TXEBcVpZ7s3+pR/E+kWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+D4OzNePUsTtD2uWPgcalnm70BT4a+msH/grE2Pq+I=;
 b=e4xRQQ4DfA+QWr7YFhya7JwEA+6LDXkwvVU3PqHt/zYK8QSGMXeaDSbV/xJCQ4DPMNWiLOruNwhDFNVqgDnacyxSQ+LzPNF2R+M9CBLllj4ImA+SgjaZcrGYN6Y+hC1zSZHmOyK+3OoyFMfUhSZFaaheVT4iC8oVusWW2f0ucdk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6830.namprd10.prod.outlook.com (2603:10b6:208:426::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.34; Wed, 26 Jun
 2024 07:59:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 07:59:21 +0000
Message-ID: <92039bc2-6256-4c9c-bb98-9cf8f17521fb@oracle.com>
Date: Wed, 26 Jun 2024 08:59:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] block: correctly report cache type
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240625145955.115252-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0581.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: e6f74658-3db8-4ff4-2a22-08dc95b5e2d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|1800799022|7416012|376012;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ME5wRnJaeGhtVVZ3c1Q4NS9ubS9lOHFMR0t1b0x5UDlSNERQWmludGdVSFhH?=
 =?utf-8?B?R2svWjZrZlcwQVlsdkVZQmtjMWMvQWRwNmwxaWFuY2xZNXdGbzVNMGFIRmw4?=
 =?utf-8?B?UWkxYkY4UzJLeVFBRGpYRGppaUlJV0dTb2w5K3hZZVRSOTgwMHM5TlVRVmhu?=
 =?utf-8?B?NTBicWNvSkhsUWx3d2s3Q1EreDNsQUp0M2lpU0MvaFF0THBRbXVMcE8zRW9P?=
 =?utf-8?B?UURIcHhXVkREY3kvb3Yvb1kzanVGYlhhLzhqUnhJVVc3cVBtRVZqUzJRNUVk?=
 =?utf-8?B?SGN0M3dSUzNPaFNlRGt6WDVDeUxzSks1amJwRTRUdVcwM1BDcjExdFJSU1Vz?=
 =?utf-8?B?dG15aUVZVzVVcUVYQndQcC8xWElOWFhrWGtMOTBNUk1BQmtpTlV6YlJjZGdD?=
 =?utf-8?B?MnQrZVZZQzN3Y2RpdEErdm4rMDlNUUQxMkdiMDNCSHV0THFjQjdxTGJ4S0hY?=
 =?utf-8?B?aU5KdFZsOVlUZ0EzQ0psd2tPbzd0WGFIS256aDd6Lzd5M1AyUnRaVnM4WFcv?=
 =?utf-8?B?TlA1OEl6cDFRTXZ5OFNLSEZnakxGMzBJRHAzSkpXMHhJaTNSdjBwb3g3R2Y1?=
 =?utf-8?B?RGlCYzVWT2JjRmgzMDFHbkQxMXZLbzYyQUF2Yit3MHkyQWY5ZGxwWkxpaVoz?=
 =?utf-8?B?ck5iM2p4STlla1puNEtCUnZmU1M0UlVUdmw3TDRKTUtTcmdUVlhQeFBxZXpD?=
 =?utf-8?B?UDhMd1FNbm9IKzNHTTJ2TERvR0NtMFNPNW9yQmRiZUdWc0tLK2JFZ1d1cFRj?=
 =?utf-8?B?SnJjWnViSTdpNlQrcnc1Yk4rS3pYSk5ncktjdThuUDZlN3g4eG9Pd2NpT3ln?=
 =?utf-8?B?SUFQN0hZQnoyZUVvNjIyRmEyemljWlNPWlZsRm9xb2xiY3lGVjc5ajVXQjl4?=
 =?utf-8?B?dEVQYVpjQ0NKbW1hRit0alZndmxtcjZabkFWNFFWWjU4UlNVQ1VIY3grclU2?=
 =?utf-8?B?OGJGYVllb1Y1WEpqTjBSSWJLNlg1VFFic2RIT21NQzR0YTd6WDMxUFY2MTg4?=
 =?utf-8?B?VWg1VWxZdWFFRGhnTExjdllvYTM1aHc2UkNjQmhwNEYyK1hKdlRtQktrbjNR?=
 =?utf-8?B?bmRLUUxvZG5WYmdweVlqeDJkMFA4dS9JSmtTVC9oR21YSjh1dStFMkU2WWR3?=
 =?utf-8?B?azNuaC9SWGZOTlBuZTFmczdtVmtJeHZrQWl6Y2oweFJYZlVISUlzWEhwSDdv?=
 =?utf-8?B?djVxSXZ0N0VTcEJCd2hXTG9qS285MDdINUJaTENqYXpuek11OXFkR1ArUFVI?=
 =?utf-8?B?Vmp4U2dnZWxGLys4dmM2V25TT3l0OVBKTXppenpWU3BzSzFGTUdGUHBaWURP?=
 =?utf-8?B?TU5obmpNMzN4ZDZYblJldDhtTzhWaWU5R1QzY0szWGFvUS9PMTJqNXdpMzlE?=
 =?utf-8?B?ZnJkeDV3bjNPcWJ4dzh0aVh4Smg4NmxueGdrb2U5U0s5Qk1jeURkOHY3NjVC?=
 =?utf-8?B?TU1Mbk9lSTFLVnRmNGVTdW5Ic3JPcHFjVTVrUS9nS0pqa0hERFRGMUEwV1JN?=
 =?utf-8?B?MXY1NEJuT1U1bmVEUWdWVzlDSjRtaWdnTU5IbFNpQ21FLzRlbzdqdElCdEZF?=
 =?utf-8?B?cVJHRXJqbEptZDk5VnQ1dTFBK0V0ZWVIN2QxWmYyTXFxUWZoSXllTWszRnc1?=
 =?utf-8?B?aFF5TVVrZmdMOGVNZjlwWmxLb2x6UmpsYkh4cGx2aGxjeXVwZ3VoQnJKczFh?=
 =?utf-8?B?QzJMT0x5NnRVeFRxVmttWVJkdzlvVVFuMGlCVi94b3JRNyt3M2I0c2pmNnVk?=
 =?utf-8?Q?E9bVJhIgRlurawd8JVL58nQ93osHeRZ8Zu2+asj?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(1800799022)(7416012)(376012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eVRGRDVHR2FuSjVXU01WdjRUZmh5QWgyLzNPUk5DU0FzSklVNXl1WmVlaDVi?=
 =?utf-8?B?UnZQK29PeEppNWltSEVNTXZnYWNwOGluNUJnYTdTdmtZcHN0YmJmSlBJL2dG?=
 =?utf-8?B?bWRyZEROUm5ta2M2TnhDNS9yTm0yNnRWblpReUdNSUo4WndESDAxQk90R3ZX?=
 =?utf-8?B?cmNNTkJIZ01SMnhtbGsrbU9hamRZODJ6ZHhMdy9ZU0ttdEs5ZENRUkVmNzk4?=
 =?utf-8?B?VHMxd3JkUVJtL25wWEU2SERscHZ3djJsOUt2Q01BSUd2NXViTWlUQXlhYity?=
 =?utf-8?B?cjVzU2lIYk4zRXZpMG15cTNIYzdEQ3pZenZ0d0FqTndabEkrOUhjVkNMM0FK?=
 =?utf-8?B?T1ZrakZsbGJhSnp2VEx0aHM4U2s3cUpQcWxEanF5dHNVYWJMQTlJOTJDNHZL?=
 =?utf-8?B?bEcvUlRqNzdzVm01VEt1dElqK2FHQ3JnWEFSZ0NHUUpDT1JobmpxRGJxbitE?=
 =?utf-8?B?VmlXcEIxZzJxcmxZVk85UXhYM0RGSy91RzhkRWhYKzFsM0JwNjI5VkpCcWVP?=
 =?utf-8?B?cTNieGtVVjB4YmxPK1FXV0ZYNlJERzZzN2syaDFEcTNvT1VpanZySDRMQWc4?=
 =?utf-8?B?RzZTQkM5cjVqcXBXOWMwc1VmMEpHMG96NnFpM2x2NnBJZjhDVXVHcERocEJO?=
 =?utf-8?B?cHRDcVJ4L1g5dUEvWWllOVZvVjNNSkQ5eStHMjR1U24zNkJXc1hwekpsWmdF?=
 =?utf-8?B?dytVaGFLL0VpOWRaeFk5SCtQejVDNVRpcElTclhhcjd5djVFVENhT3FrcUhP?=
 =?utf-8?B?R3dDeDl0S3NsRWVPZmUyOURCUzBFbTdJUzkxYVBSU2thc041c1YwZ3lDM0pS?=
 =?utf-8?B?ZHlNVC9wZHpPamtwRVIwNGc0V25wdkJIbVJhVExRVmVadFo3Zkd5QXVFblox?=
 =?utf-8?B?WlQydW5jTVQ0akphdHZndktBSCtkVjZFUmFYRGxpaWUxMzFxRTZYWGJYTDQr?=
 =?utf-8?B?K2xsbDZoNXZoSUNKOTF2bXB2Y3NSYkFGUTFRTjJZM3B2MmR4NlVUMXNYZDhR?=
 =?utf-8?B?UnlsT3JRenlIKzk5YTZNQWZzQXFENkQzRlh1YUVsUFgzTVlIVTVCbHF1aS9X?=
 =?utf-8?B?L1hkZU5KRlUwR2VPY1UvWFZQbCtYblVqMVhDTXY0VExjQnNFMXdlTGJtb2RH?=
 =?utf-8?B?bEdoVjJsMnA2cVZjb3kxc0ZXVGdLQTRDM0FzMytaeXFFNS9mWFNjcURUcUwz?=
 =?utf-8?B?M2o3enlhMDdNeHZhelNPVllmNFA5a3luZ295Q1A0SWtVcTdXdHp5dnBMcXNv?=
 =?utf-8?B?UjBYNGprTWJkc0xKRy94SU1hNzFPN3RHbkhKUkRZeTVFZzJpblFKTlRTVmFY?=
 =?utf-8?B?bjIwa2lMRVBmSU9PUmV2Skh4MGdaRUJwRzRydUc0bjB4RUNXNFc0WnlVUVEx?=
 =?utf-8?B?bjA1SGNsRWxVa2ZPS1RIb01HbTRKcVhnSjdFUExkaHI5NUNoZnduVWw3L2JE?=
 =?utf-8?B?dVNlNmRHc2w4OVI0UWlDV002aDAvOUlJOE5LVlQ0Y1QvK0dzdTM3MnNFZTd3?=
 =?utf-8?B?WHFRZTQ4RGFRbGkxUE40YUI4S1Q5enpZTkYrNkRmZUJ0ci9jenh5aEpaS21s?=
 =?utf-8?B?VDBJZjl4K0svNnBRb0R6MmVOZ3l1NFpZeC9LQkJjT2Exb3JzWXNkM3lxR0FU?=
 =?utf-8?B?VzUvZVl0R1lVN0FrS2JhRWZ6REdlaEJwNE50dWNNQWgxamNGNTI5K1JINm1j?=
 =?utf-8?B?TzBGZkh0b28wUTM0N1o3ZHh0ZytNcFUvWlk2ZnJQakx1U01PWEppZjYxOTA5?=
 =?utf-8?B?aWpaY2pqNU11MTZTdUQ4SloxMU5sK0ZFSWIxcHF2bDJDUm1IaXNBUjVIZUUw?=
 =?utf-8?B?NW02OWZ6elQzOTdOYnJYcnp6eU1QVVB6eDdYK2dFczk0OHliRXRmaHRwNXZr?=
 =?utf-8?B?NEFzR1IzaGJIdmRZTmdEWWFYMU1JUTFMMU05aFpySW9ZV2s0R1JOTStBUkRq?=
 =?utf-8?B?b2dWZkQyMFpYU2E3SVYxcmVLZHdmcjZJMUhoalNHSmYrdlJxVjYyRzNkNDhu?=
 =?utf-8?B?RGRLL3JkUUVvTy90Y21XTFlsdDlJYW9ycHhEUEQ3UDNOVENJejVWdklFYkZa?=
 =?utf-8?B?L2c5ZWNDTnM0bkpSdkx1YVlqUTV2b0xyOE5jRXhiUDErUThhRVVJVDVRY0Nv?=
 =?utf-8?B?ZjJobUlacU9DVW05UHEvd3hmTFRaeitkazYrY1FQZjhXYm5pN3RuZzRGYVN0?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GlMA+r9SbTtTMrwzaE7+ECtz+vRtbJ3ZGmwBTbaKqpKPmEE2Os93Qdrn0qPo8ww9H+KpUJt9JplHpxk1Nzf2sie0D7E6HJd9OwVyTFbglVQk0+JuE9dqrTZbEcKOy8Ta/+FStRUhHifpr198MCZkK891gDapVavkV8GlqKYie5IEfsbCrwYX4dVkG1s9k45z/L+QwovdZ6Pwrcr5P/z5wKg7jUteHvOMODp2jZGI2p6GDWV23Xu5Z9XAZ6pM30VsaXG4DU+XHQUqC+HR/PqhGSuXhMatMQcFvZvhuEtctkTLOcdnedWcBGq1df2ziV3uVChFe8vCFpbyPimZoUD4g6iSN7yck32j5xOxO7pFlpuZ1RA5tf7S0WgoauEuXMumNhWAR5AIFWVd7zQKS0uxbPT1aL65HbYsuj839Z/kIDnGClGVIEXCgJn88sqhcqaaR+QjFqhUrayRFnXoBLskpW6HLv/MOSYu9pwuy9tyc1H8MJEulphA8sJdjP5y97+cSO7qs3onVfOZCcW/HHf05z92VeZrhRIWrpRKtBsC6AbuxA5li5VSrabkS63fmJQ9Ht6CSSFnN3U2MBkhet7f3r9GGYRuJsYSr+QdrjXhV7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f74658-3db8-4ff4-2a22-08dc95b5e2d2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 07:59:20.9677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdFmQgjt4XA8t1suxeUZgXAzXEUJfXTS5+drPt5yGU0UuviiaCAYa6rZHMO16hzyHAAkuQKmu2CLIz3eIhh2qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_03,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406260059
X-Proofpoint-ORIG-GUID: 6zwdwhsPZ0sdRSVyz_9yNjfHROCgekgh
X-Proofpoint-GUID: 6zwdwhsPZ0sdRSVyz_9yNjfHROCgekgh

On 25/06/2024 15:59, Christoph Hellwig wrote:
> Check the features flag and the override flag, otherwise we're going to
> always report "write through".
> 
> Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-sysfs.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 1a984179f3acc5..6db65886e7ed5a 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -453,7 +453,8 @@ static ssize_t queue_io_timeout_store(struct request_queue *q, const char *page,
>   
>   static ssize_t queue_wc_show(struct request_queue *q, char *page)
>   {
> -	if (q->limits.features & BLK_FLAG_WRITE_CACHE_DISABLED)
> +	if (!(q->limits.features & BLK_FEAT_WRITE_CACHE) ||
> +	    (q->limits.flags & BLK_FLAG_WRITE_CACHE_DISABLED))

Could you use blk_queue_write_cache() helper here to reduce duplication?

>   		return sprintf(page, "write through\n");
>   	return sprintf(page, "write back\n");
>   }


