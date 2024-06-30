Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E73E374CC;
	Sun, 30 Jun 2024 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719740596; cv=fail; b=uZ/DkbyBYqRxYP6yYjYfeAESHPAvpk4dFFTh74dJ26J+xgPQDCX2O97S569YX6A6K7Nsym5DxqPhSKQlB3Iw54ck+l8UUBN7YD/Qdmdqi7cNmwjR7vJVC85JjcTWZqIV1vqn+LXGcfcpOBEYlInvF1gTErLWAD/+TaRNkxhBV9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719740596; c=relaxed/simple;
	bh=PxHSrXtl/VGIcaZVCCttLEgaAtanRM6TMPYrbQ6+PYQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ipIMkMidah1FhzCqTrO/a11fxURQciFRC0aiob1aTF0AECJP1ecXYT4Fi4m5Yhlv6wFOaNLBfci0KQD0EZ2DUo/2MW0rwaavlPenjZ2eFvi9s6TS9Mgqi7qWCVTAAbI4T4uAaKkawe+uEvcXW1srWY5c+9l+DQMwns8iOWzvhVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TJ/DGx8G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lF/xh7t2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TJ/DGx8G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lF/xh7t2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45U6qvYZ030359;
	Sun, 30 Jun 2024 09:42:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=0XK6oC8/maAN4t5s+UY8bQSzKVXS+wf8pEUCXu+VxIk=; b=
	TJ/DGx8GrQCgpS4YvM77D5BrjuZCh7CJoBJD2xgMlp+uMo6lBiKezTPXOHoPu14u
	tOlFj4aJVCDQ6wDZwJaFllfbzOkGjmHdf+plUFN3F8t9bbobYrgHCCc4HHk1TadR
	OOvNCmpiZQwybZ4AiVQEms2u3nwsxQ1Yc5V0GEbGlo8DS9+MdwE0KAVDd5Mh9l6x
	b9F8dY1dTRSDgnygc5hxNjmzA3S0+IQrrSqktEH7W6m5Z6Im4iCUSdS1xcTWm9sr
	eS7vZ/0e8OsZmPybOdtFRO0YFc4kDJc6D3QujejRnlsOIdsVKEa0qL4QuW28LGfq
	GdLztZBQmIW5AKbULJ7yAA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402aac94y3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 30 Jun 2024 09:42:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45U7eK9P026234;
	Sun, 30 Jun 2024 09:42:54 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qbgrrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 30 Jun 2024 09:42:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuDPEv3095RMAb4cBBKJe43+5KMK5D+/yaN1rVJh3/ObkoHxSMxauPzjTNz4Cpw7vhKSicTOxPmGWDXk0Ba0qjKDm8Yq1Fv4MMRIcfOxocKpeyPHxaMeugCt/bW1EFkbplgsuibiu6eBcd1PWjRSD2YtghACfnpM5M0oR8OVVyTiVC60k32zCeyIi2nkgtLDPZOkNejdkQ2IE0JCaAPA/T1q9E958u/nFLOFYKnKcQEI4lPiD9DKZ6+NNev6Dkr0ho9KhzvchrIrfuFzQ1/XYozi3EkJFlBNy7s1viU7A3YNgP/uSukwc5O80DhBQMbmIzXETXrdHxE6w5AB8iBM+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XK6oC8/maAN4t5s+UY8bQSzKVXS+wf8pEUCXu+VxIk=;
 b=P6VplxRHNLeG6hR0vzdQ2/c4Q8kIWPI4wx/MtG3/o06V7iDsjG47ki0m27L7+FO4mWmDk6JKAJRX9ZYIN48uOgwRVfxaSNOuK1q9O2J37/Yzo2XsFiObuyqUlPI8FD230tQ1GwdNPHgT96zCoeZIpwJuK9eoXCcAoIPJK694JejLqHV2riIU/F8YhdY7by69lnDVW5yakQUUT5lrD72vMvyTVVqqdJDRN9yCudcPkCgSEeVEKkQM8pugKBqAv6QJAXXJxjXJmtDSTqTTakrHR9YXmXYmJDWiqWKpYOopynoB+2Tlm7pd3q/tTw5cO/T4aq4foNPU3ZvLlzUklap47w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XK6oC8/maAN4t5s+UY8bQSzKVXS+wf8pEUCXu+VxIk=;
 b=lF/xh7t2Iuubs2VxewlO+cX3d5B4WXjRa9/E604tgxquhQwGu73tFdV4FZHOTcA8PG8g8FtbUP/VBvQcX5BcMBLu6YFymYmy29XYWZzTANpUBoB5JDB3KGcCvOgulj6D9DIgdi//MyGQd0b2xg0305yc2XJx/exFdK1jxq+JOfE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Sun, 30 Jun
 2024 09:42:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7719.028; Sun, 30 Jun 2024
 09:42:51 +0000
Message-ID: <18252752-d3ed-4924-ae5c-4d3e0120d973@oracle.com>
Date: Sun, 30 Jun 2024 10:42:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] ata,scsi: libata-core: Do not leak memory for
 ata_port struct members
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
References: <20240629124210.181537-6-cassel@kernel.org>
 <20240629124210.181537-8-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240629124210.181537-8-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: fa54a2d6-23b1-4544-8d01-08dc98e9021f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?QXZST09yUjBXeWtaYmg3S1NWN2hvVkp1L0Fzb3JqOGxia2llWGl5eWRqRHFV?=
 =?utf-8?B?ajJFMUtQbkhvdE0rcUNMMXJ6V0lwcVZCZ25sdmx4UkgwOWtSVE5rYmVwVHJZ?=
 =?utf-8?B?bElWaUlWK2QxRFBZYWYxQnF5bEZVT3ZKK0lzZWk4NkFNUWhHa2JVTFBWVy9q?=
 =?utf-8?B?UGNpS2QxcmMwQTlnZkp6WUFYZ3hMUXJvRDR3NFhFeFc3SzgxcDE0bENFRXpJ?=
 =?utf-8?B?ejBGckRiM25PemU2dmZPWm5lNzFsdlBkbTRpL29RRXFTU2NqOHFkMVJBcWlp?=
 =?utf-8?B?RzFtRjVpb0J1VUltZ2hpekFySmd3Znp1RWFVVms4N0JjWDNwUkVCbnJFVWlo?=
 =?utf-8?B?S1ZaYWRBVGRjeEM5aGxjNWdXbjRXWG1ISmQ0TVgwekVHalQ0dFl6Qjhxdmxv?=
 =?utf-8?B?Vm0zR0x5UzRVdGpQVVZSS3FPekVGdnQ0eGRLZ2t6MS9aQXRDSkljZ0YrMHFU?=
 =?utf-8?B?dkhJRkl5bnRBeXRzL3VUU1JYcjRDb2pBRVRaSG1CQXAzWGc1S1FKRG80RS9w?=
 =?utf-8?B?OGFyYTVMYTFVTXJZVFhQa0ptd1Y4STdOSjdPV3dOOG5UY1ZxMm5rRjMxMld1?=
 =?utf-8?B?V3hKZlA5bUJ2MmprdkdqQTRwSzNsaXNPRk5zc2FCQnkwNXRXRTJROHJmNUZV?=
 =?utf-8?B?dHRQbnkvK3JOZHE4RG5DZTNsaVJCM09kMnFKbmtTdHI1T24xR3I2RjB4aVlL?=
 =?utf-8?B?Q3N4M3F0RThOOHNncTNVVDFtUmRVaUcrZ21iWlRacU5wUlZ4R3lnK1ZJMkFi?=
 =?utf-8?B?UUlTSmtCTVBadWttK2xKSVZFTTQzWm5vekFJVDh4cWRMWGhDcEN0ekpON2kw?=
 =?utf-8?B?Qm1WZFBwc0pnOHM5dkZuTjZRZEF1ZjhRQkx5RG9GMFBUQU42dlhyWGVHUW1V?=
 =?utf-8?B?U1BETHdScFN2OHNHcDIwSklRZ3FhNUVpYUhJQVR5bVN3VjJKdUVUaGlEdzlD?=
 =?utf-8?B?NUp1QmxXc3ZsYUc1UWJPRVg0NkdaM3l3V3F1Mk81UVV0VldobWNjSmhBMTVQ?=
 =?utf-8?B?MytWZGVyU1FxN21sdW05SjdLMDNZS3UzV1VXWWRaUUZnc3NUUnRZdVhkclhV?=
 =?utf-8?B?ZzljNXhQajJmUzdIVnBvSDRnVCtJanFGWGlnY2pMVStuS1RGVmxvN1FyOGhj?=
 =?utf-8?B?RGdXUUJobjlRL0NlekVnYWM0MlE3eVBWT3RJd0pBTytuSFlnUHhIeEdkUVUw?=
 =?utf-8?B?aElwU1RBam9kTVh1OXNuVk44dk1nTkVhMmIyMk9SMzF6S2hMVmVaWEtYdVl5?=
 =?utf-8?B?VnZwMGNJdWFiY2h1M2JKcFBhaGlrVDlKQ2hneFhQbHVBNW5jS21tVWYrd0tZ?=
 =?utf-8?B?cURtbWQ3eENJVXNwUzB6UDViMy82NFp1ZlZqQTR6alpjZE82Zk1DWG9LSlU0?=
 =?utf-8?B?OFBqK1ZxUm5jbXhhSVBaekV6K05RcCs4YlBtVFptOFpsWkNLODZ4SFUvc3RN?=
 =?utf-8?B?c0hXdFlhbEc1Y3Z4TXZEL2RwaThVT3Y1NHo1RWI1dW83QkhjV3QwQmdBRWpz?=
 =?utf-8?B?dURWYXVpQzVyVTJ4RDhXMStkRm5WQ0RicjU4bDJzNWJyWE5PbllzN2dNeHFM?=
 =?utf-8?B?UEVRNjkwZ05Uajl4cHNINDFPL3Z0Yi9HUFpQTnpoT0ZBMWY2eEtYazUyRUNS?=
 =?utf-8?B?Ulk3d3dvak4rekpvL0UwTmRZMUhQS3RFc056eVNTdXdVeUJjQ2NlV0tkUE9n?=
 =?utf-8?B?RFA0cTlQRHhNdGZLcXlTby9qamNlbEU5aGpXL2Z0VXEydkNlSVA0dnNjT3dO?=
 =?utf-8?B?aitzSHd3WVEyTmRzdDA0TWVWRW1aSGVPUU5mcmhiYWJsT3NnWWJGdHhvakJi?=
 =?utf-8?B?U3dlMnkrUmNOOGtTMG9aQT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RDNxU0VrWno1MERIMmxvWnUwQ1Z6R1l4T2lxazkyWS93TmtlejNxMlhzRHZD?=
 =?utf-8?B?U2JhTDhQdU1MZlhVT24wUmNYTHF5N2Noa2ZtZmRzNTlONDhFQkRXQWhVSE9D?=
 =?utf-8?B?M0VSclpVMUlaWFFpQVVBbXNJa3VQTG5wM2p0Ym5hckp5ait2aUIycHBOV1hh?=
 =?utf-8?B?YWpmUll5bFBRR1VYTzc1UW5RS0Vpc1Jzam8vNFMrdWEyV2ZTS3hwZ1JmQ2ky?=
 =?utf-8?B?T1c4Z0VHbDM3dnVncTBJWnFRSXdKWTE1NVIrMHpKZTVVUjVENFhKRW95TVNi?=
 =?utf-8?B?clYzaCtuZlBuU2ZmNlVSMW5lMTkwaUZaK1ZQa0JqWmYrV2NzNEV5WmN3L01C?=
 =?utf-8?B?K1JLeDJaVVRTVmRQbHcxMTdsdllZWGcvYVliY0NhWlFoZ2VZS2x5L3BHdXFI?=
 =?utf-8?B?RUQzR0dIU25LcGN0MjBpeWZqRHhEUHJRemkyK282TUpVaVZ2TGl4QklDTlhT?=
 =?utf-8?B?eFZJSWUrdEthcWJjWXZWWUprbjBkTzdIRXZVS3JuK3djNmRwdlI1NFNJc3lt?=
 =?utf-8?B?TUJldmprWlQzd2V1VzI5ZXIyM2t0bzhGdCtPRWdJOWxNY3hpTUdDVWl2UWxi?=
 =?utf-8?B?ZmhNT0U2VGhzalV2VFZxcGY1OEcvSHVUSTVla2p1dVdlKzZMVjJxb2hGZUkz?=
 =?utf-8?B?bWVwK1FxRHlCVXBEVFE0YlBuYXJPNUN0dVBvT1pqeHQ3dTQzVkxnR1BQOEx0?=
 =?utf-8?B?anMyamZFeGJtUE5rbE1EY3B3K0tTOVJvVmpuSWxyRDUzTUxLbkY5NEdoYTZ6?=
 =?utf-8?B?TWtDZVVidTRteUNmSkRmdTRjNXRvTVFLR05iZXltTzdTRk1TTjNEc3lPcGpa?=
 =?utf-8?B?OTQ5NTB2ZzNTSHNVSDBIN05YSjlwSkdxOWlIemZkQzQ3Ymtxbm1BMndQdTMz?=
 =?utf-8?B?T1hPb1RYVm8vUWVhcEtuTUhCeFFOM2VhcXgwMjBsVTlOT2ZEUHU3SVRSRW4z?=
 =?utf-8?B?QmlWcHJMNU5UUW9ydGlPdlREWjBVNk9aSVhFbWtvK2tTbVd3R0lEcVRnTVZD?=
 =?utf-8?B?T2NVWFhueSsrNTk3TFVUY256dHdrdGV0RDdKZjJGeXEzczFFVkc5Z0cyclhy?=
 =?utf-8?B?cXF3aHJQTmJDVFU4ekdUc2U5clNxa1FmVzdiVFFvVDJxa2tSRWtEUDVyNWVk?=
 =?utf-8?B?TDk4cGVXUk5vdS9EQ2dPdVlEL1d2RjZDTHVSREVRdnNlNVBSNGhtK3hEZzh3?=
 =?utf-8?B?RTRXT2JOdXJoc011ZE1vWVlrSTZxZ0w5cVNnWWxDbi8zMGtmV3ZDL2NYeGU2?=
 =?utf-8?B?NVFoYWxNVXlQUkovVklyUzhMcDVkcE9rUHZTcW5udlZielk5VmVtSEJBS2ho?=
 =?utf-8?B?SExVZnJsdUxlVHUxZXJPYXQxU2QrTHZNQ29iS2pQZERmTE9rSmU2dmtUQ0Fx?=
 =?utf-8?B?L2NMRXVkVU00ZzJ1S0oxZ2t1K2loWFRNSmFqdXFDYmczbnZ0dHRmMi9QQ0h1?=
 =?utf-8?B?bUFGYURKRTlxbzhMYWZ0aUZQVWVtNmpzS0dXYXdHMVY3Z0NESSs0R2JabzNE?=
 =?utf-8?B?WEpmSzBGazFtMjRjc09zT3R0ejVTMzZzc3dmcVhFNDVYQ1ZoY1BQcXp3Nnpu?=
 =?utf-8?B?ZWN6bXltUkQzdkVDVVBFalZMaEpacE91V0JqTFFicDdGWC9iOUFPV3Fobloz?=
 =?utf-8?B?YWgzOEpFeHRSdSt6elhhcENzOVhmYXgxdzhnbEZkNnEybkEzS2VQWVQ1OEVS?=
 =?utf-8?B?L1FoSnNLcDNTZnc1VnlLTmJGSlUxQ3FJck9RSVFtMzRCYVNlai9vWHVpYTdq?=
 =?utf-8?B?NDM3ZUt2bnZSUklmTXFDZ0RXejZNcjhHdHgyVDRKWjQrTmhSZGFsaUxnTEhZ?=
 =?utf-8?B?RjlEaytOTkJyU1dIdTNLc1laSS9EZEZCaGs1SnY1bjFQQ2NrWGQ0NWhiRWNI?=
 =?utf-8?B?OU1BTmtiSDdkRXV4SkJDM0FFd21ZekdRZmZaQVFKbTU5T3FkQ3FjMDVpbUh3?=
 =?utf-8?B?dDBSTmdsbGM4aHZLcENUMkM1MEdWdXo1Rk5tUUdneGJ3Y1RnS0hDM3ErQlRR?=
 =?utf-8?B?VTlKNUZRdjZPVDhpWUJ2QmlJL1orRUFoWjhIMUdWN2tKdkxVNURjNVkrSU1B?=
 =?utf-8?B?Z3JVWFBjZVdGVUw1S1haN3p2YS9aRkZzTVQrMDNRMExuYnNxdWFyQlE4T08y?=
 =?utf-8?B?aEZOUHRueHB4VFlMbzRIdk9wSUpzMWVJcWVaaUpoWEMxanl2Z2hFYVRtdHd1?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RUyql4uqxvsdopPokdFHA4rGalzrE70TObx5DQi9WustTHacybgTseOl//QeaSCASlq7GS3tDNe+QzmTShlJhDjQCUlK6g7QmQwqtvaSCKJn6yo7m4iB0rEVLBl4tqPLl+2XpfdRl48J5DwRkU0WRy7hQP7DitzkdmBmgw5K85bZvNHCF9mGHkwMulUHkjHHglMczA5VMGPC5PgbFe49q+Ivsd7KHKJs+tMK82NAI3WLcuWFEnh0+Z/CIq3nngkuZDnY3iOC+ytw2+QyNWDRxNbP23H3zmAzuDtQiUVhosg2+BqSJZ3qr1qRv9EkroQxH5qsNCbNkN3H1GC2GrFLp9CxydiP8YBBSXSezvs4pwoHGF2CXM3o5oabkjxSJZLLjJuv708rQZLxGkIxW8BUPbYrodNTtl3zKlAJ/ZHkMS4BoU8j0dk/oG46VV6DzpnzoDyFsyiOHQssQI7c0/TvTGZP0pYAcdFapPguQZTEsJ8OhwuZh5lDQ4kJG+E0dbAj3iUwmRSNJrVtwrjIuJ2FbN08jHzTZid+wkt/ayugk9N3YmWeynniAGlAp9Rz1fmLX2aUxZESLVKP4uiOrEmvg9InKi47JeFBZXaEB7w8FsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa54a2d6-23b1-4544-8d01-08dc98e9021f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2024 09:42:51.2492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gk4/EupVSm/QYpRX/BrcBl4W2Vek+9M+9N7xBkj8KMdANPbmNDnU0pgQD1sOeuF8JNLRO0Qnu9+DeTADfegO0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-30_08,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406300075
X-Proofpoint-GUID: 9JPCBo9DH0ySdeoL4Jsb_plzlpjQ66Kk
X-Proofpoint-ORIG-GUID: 9JPCBo9DH0ySdeoL4Jsb_plzlpjQ66Kk

On 29/06/2024 13:42, Niklas Cassel wrote:
> libsas is currently not freeing all the struct ata_port struct members,
> e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).
> 
> Add a function, ata_port_free(), that is used to free a ata_port,
> including its struct members. It makes sense to keep the code related to
> freeing a ata_port in its own function, which will also free all the
> struct members of struct ata_port.
> 
> Fixes: 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL commands using policy 0xD")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Apart from a couple of nitpicks:

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/ata/libata-core.c          | 24 ++++++++++++++----------
>   drivers/scsi/libsas/sas_ata.c      |  2 +-
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   include/linux/libata.h             |  1 +
>   4 files changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index f47838da75d7..481baa55ebfc 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5490,6 +5490,18 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>   	return ap;
>   }
>   
> +void ata_port_free(struct ata_port *ap)
> +{
> +	if (!ap)
> +		return;

nit: personally I'd have the caller check this. The main reason for that 
is that often it seems an unnecessary check.

> +
> +	kfree(ap->pmp_link);
> +	kfree(ap->slave_link);
> +	kfree(ap->ncq_sense_buf);
> +	kfree(ap);
> +}
> +EXPORT_SYMBOL_GPL(ata_port_free);
> +
>   static void ata_devres_release(struct device *gendev, void *res)
>   {
>   	struct ata_host *host = dev_get_drvdata(gendev);
> @@ -5516,15 +5528,7 @@ static void ata_host_release(struct kref *kref)
>   	int i;
>   
>   	for (i = 0; i < host->n_ports; i++) {
> -		struct ata_port *ap = host->ports[i];
> -
> -		if (!ap)
> -			continue;
> -
> -		kfree(ap->pmp_link);
> -		kfree(ap->slave_link);
> -		kfree(ap->ncq_sense_buf);
> -		kfree(ap);
> +		ata_port_free(host->ports[i]);
>   		host->ports[i] = NULL;
>   	}
>   	kfree(host);
> @@ -5907,7 +5911,7 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
>   	 * allocation time.
>   	 */
>   	for (i = host->n_ports; host->ports[i]; i++)
> -		kfree(host->ports[i]);
> +		ata_port_free(host->ports[i]);
>   
>   	/* give ports names and add SCSI hosts */
>   	for (i = 0; i < host->n_ports; i++) {
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 4c69fc63c119..1f247a8cd185 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -618,7 +618,7 @@ int sas_ata_init(struct domain_device *found_dev)
>   	return 0;
>   
>   destroy_port:
> -	kfree(ap);
> +	ata_port_free(ap);

nit: If not a nuisance, could we change the label name to free_port, 
like free_host, below. No big deal.

>   free_host:
>   	ata_host_put(ata_host);
>   	return rc;
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index 8fb7c41c0962..48d975c6dbf2 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
>   
>   	if (dev_is_sata(dev) && dev->sata_dev.ap) {
>   		ata_sas_tport_delete(dev->sata_dev.ap);
> -		kfree(dev->sata_dev.ap);
> +		ata_port_free(dev->sata_dev.ap);
>   		ata_host_put(dev->sata_dev.ata_host);
>   		dev->sata_dev.ata_host = NULL;
>   		dev->sata_dev.ap = NULL;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 13fb41d25da6..7d3bd7c9664a 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1249,6 +1249,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
>   extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
>   					   struct ata_port_info *, struct Scsi_Host *);
>   extern void ata_port_probe(struct ata_port *ap);
> +extern void ata_port_free(struct ata_port *ap);
>   extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
>   extern void ata_sas_tport_delete(struct ata_port *ap);
>   int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,

