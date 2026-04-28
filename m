Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9FA3D1711;
	Tue, 28 Apr 2026 08:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364146; cv=fail; b=BvNGIUaIkqQ8WsLBsh6kQ5ZzqfhqfvNH+fIZINWyHYuKGt8Ed62ePDPR4jEKp2meNaLINEfNDonllCwME9ZKnz2egE+xHouefqB9mE8+ZJIh+m3CYwhVZRJUfTDBpd5vxNSRTD4yU+zOsfJdmv7S8tc2Kolcme3TduOw0TjzTCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364146; c=relaxed/simple;
	bh=YjwmC76QyHLII7WJcQUKIOJceCNMi4R+mK74Q+352u8=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WN2/Hp2ToLDzw7rv9cdD1t3/3McLkDcQGI0ckV8/bKtDCyM5Jceah7IQQH9sS/TVUMU1Xtipif9sSrJ8S952aA5NfAvSnJI38Ss3qbek0AZmVB4c8PbZz19CU6CBjuZnzbGMu77Vcg9BXIDaVJ7pYHGSBRn8OC28UlsJmiLdljg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q1wPY+H1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ncujyr1U; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q1wPY+H1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ncujyr1U"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S7pv8U3055257;
	Tue, 28 Apr 2026 08:15:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qFSrOUSkY2YfII/I9ODUUI0/19b5C5o30pYFhJwMCLw=; b=
	q1wPY+H1JMZqWXFGDFIbvi+TtKdNdr1ItRAaFK0KoMpIFBd2GzRwGk2U/c5yToyB
	YkBttHLxZaiqPCs4t9bpMgEx+1z+AQQJ9LBtyl+GBTLUkij5Hsq8B6Fxfo0IvKQG
	fi+5vXvhSqOCPkedXPH5Q/DiZpIKt2hfjF6XGfKhP/sbOpdh4HIM1u1cukx2LNkN
	TAb5HCoGfUG75lqY0mSuVSfDwqbZKyvWsqtR2F2Khu1RDwJUkEZ/SeP7k4FDE2uH
	PlpYGXK/PCxDB6E7yXkFd5TpScALTh3DaWrwwSSbv24Qrebe8l3yAa19gT/YUocY
	IX4YpiySeSFdcuKjJZBzfw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5xjr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 08:15:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63S86Qcr019010;
	Tue, 28 Apr 2026 08:15:21 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012009.outbound.protection.outlook.com [52.101.48.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cdsq5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 08:15:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wFA2lYOYoy47wPHfTSYeP6CokTSRjupUn9d5VsIuUYMHY4ahy+zx4TzVJVVYVsZFJynntA2PCP6QEOUoI023l3TL5P6DcGx+4SEL4LZXH/T+/berErSKGsY2vyKXAlKWL2o0TRGDaY9FIubvj7FYvKLPsMw1pBtRVaNWMscjzy3ZpWG6ozrV0C3YeX0pUaZFHy0hK5Gbi/2mNcG2qBISFy4FQOMjWQuFLH4XjcXs5nwbH11azYDE4ny993m0LM8yxuNTR+wdUhPq0e92b4P64osSzslE9oYw64JoYBitAt9u8JlmPN8vr6JIiJ4rYlysGRRpkBGYq++f0RTRPp6T/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFSrOUSkY2YfII/I9ODUUI0/19b5C5o30pYFhJwMCLw=;
 b=DiICcQIJRLKrAjxLbvazmmNiaWZsNsZJTW8WSzuqDzbVQazKsQVl5YQl52IzAbJTQC0Oc+SXdXJ2jJtFxTpoL96dQeKyfZ5P+G1yR8gHIbG5kc9XfgrY5q/FRvo48NkcLVgRbIgNQPwJNsY1W+vQf8s3O/i/R+UIgShRmfrbXUVlHialNsgzskA3cuoGemrwS4r+BrM5P20BgrGkK8o7T8tMV4ncJzoijF/mIg+GgEKaPJhRNLJOseJ6CygNudIBGoMgkih4mie2sZmmgyr1Ij+mbqSRM+SJNirkiuQ7zmz5SYLV1o1H41NIV5rj5aMe7SdLRSOGOMZswlek755PcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFSrOUSkY2YfII/I9ODUUI0/19b5C5o30pYFhJwMCLw=;
 b=ncujyr1UTZcTAeZclxZSPzb9WvVg+BtrTN3KXusODwbipENeV8wq/Yu3zFENhK3v7wLPO6DllRySOVSS6G/ygKsAh2yyz79je80bqTDC0cq2sc2HffCp0YTc1WxAsNsBfFq7GToVjKN0S7GLGIuYBkmAHCg8kZKKKOPyVUgHCLs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BLAPR10MB5092.namprd10.prod.outlook.com
 (2603:10b6:208:326::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 08:15:16 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.20.9846.026; Tue, 28 Apr 2026
 08:15:16 +0000
Message-ID: <2fa2c61f-5b9f-4171-b7e2-1abd23409bcd@oracle.com>
Date: Tue, 28 Apr 2026 09:15:13 +0100
User-Agent: Mozilla Thunderbird
From: John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v7 1/1] scsi: sas: skip opt_sectors when DMA reports no
 real optimization hint
To: Christoph Hellwig <hch@lst.de>,
        "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dlemoal@kernel.org, robin.murphy@arm.com,
        axboe@kernel.dk, m.szyprowski@samsung.com, ahuang12@lenovo.com,
        ionut_n2001@yahoo.com, sunlightlinux@gmail.com
References: <20260415071849.25693-1-ionut.nechita@windriver.com>
 <20260415071849.25693-2-ionut.nechita@windriver.com>
 <20260424132100.GA15553@lst.de>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <20260424132100.GA15553@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BLAPR10MB5092:EE_
X-MS-Office365-Filtering-Correlation-Id: b47e2b3a-ae9d-48dd-512e-08dea4fe47aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KvKrJ1W778zfKxF4b1MGXj4j2oRX2mPFs9qv8bwQcTQP0CfrNAa2RGEV+SAgDqXQGHQ1fPuf+dxqD9Emm4y7QCHMlPQdghYbqHY+hYGfOYwDhsbpeEcQn/XtbhnnRgJh+PcfGNwdcUtxElrIyXek6TxUwC+9r1aVqSRT+NDWbNS4vC9h/wrrAauyw0JEw1uUyhm6LukHOi2Nsw3j+NiqYm76fMIZrBWh7nHknQa30JQ5JIPkz2jyIaZRIRH/EKo8Ykl7PMoUDds0a5nnXRLa1iRd8rD2fXevCPQoLv7wwGRC2kox+16+oN9pUoAGJnLauNQNxjN71sLJnZ2/l/pzPXBKDMevJ+B8nvDAvwZgUpX0bFcfs1CncJRayLHTLnElKxE3obnHWeISGH0nQ4Vv79VQyclLlaDlLbPKzQ2COsssa+jws4SnJIj1AKncMVdDbbRfFUfdVSy756u2iIhNn/LbKh9i1HtStcr+pSNj5f2AWBaFiQSgtr381JHtBo+hD4UxbjRWaMalodBBOxkf+5F2m48+ByxEgDeWAz3ng5PDfBZIqn1wcgwc7HfgWjTJpF5d+l9Q6W/VlZU2396WlQuUD5TlOSjzGw+gN+ZxauwLEGH7T79TaHggnjjsI9mTjLC+Lf3bPoLfIqE2I3TSjAe4sWQ2WaRaCbKevQVYZqbJUSERFTixIioSrCEKPGdhUe6qXoMe9HSMnBDLJMVJJTbm7X5nnRs0KmLWJ28QKtyLpNdLAJPaFsG9pp1Ze3PS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OSswMmJwUzFqUE0wd2Z5ai8reE1SWFR2bDhpTUIyOFNTbEZsNlNwSWE3Skl0?=
 =?utf-8?B?R041TUpZM1pFOVkwVm1acUxmR1gxMmZqaHVQYnRVT1BYWXlONUdBMCsyMEg3?=
 =?utf-8?B?RVQrbUowbENUS04xSUU4Qk1KWFZkTG9LRzZ4RjdlaWdLTUZJMGlFaGdqdU5T?=
 =?utf-8?B?bkZZQ0VwbVhyQnZ5bkt3WHpFZTlqTCtkT2ZiVHJ5T3cySTIrMFh3U1o2UXEw?=
 =?utf-8?B?U0M3YXBnTnQ1SEliUGhhaDN0bFhqbVFwSG1URWVURzBJUlYvbTV2a2c0eWpo?=
 =?utf-8?B?M3hkUmR5OHZEZmQ1ZXh4Q0I1bk5ZMkttK2ZZSHFTZHJPVSt6Y3pJd3ZpOVNR?=
 =?utf-8?B?dHZFcm9jSnlyOENvSDVOVklIU20rOEw5TXExWmlWT2hQM3IzT01pcFF0Yklj?=
 =?utf-8?B?QzJ2bjZ1c0QvZEdIUDk0UWFxSHZXZFFzaGJFV1llZnhuMGgrM0FzVmtpWmRK?=
 =?utf-8?B?TWhvemFaYlZzRXo3clVER2laczhITldWYkNsMnhnN3Y5QTdmM1FCdW8rd1VX?=
 =?utf-8?B?dEg3TWtEZGdMejc5K01RdHZmUjIyb2RZU1p4c2RwTC81dE5IaVBtVXM4cytv?=
 =?utf-8?B?Nm5Vc2c1YmhDTVdIbHFZY1BISGlzUWVSVzFzOGw5aTFmUEtBMnY1MU5sMXhK?=
 =?utf-8?B?elFmSko0dmRVM1E5bWYrUW9SdHNNZE12YnRvTk9pMUVScGw3UmNRcEFQSnhB?=
 =?utf-8?B?RU1VRTJXRFhkZWZwY0R6eTBodWRSNjZ4K29OenZkL0ZwSHZHa0ZRODBUc3E4?=
 =?utf-8?B?Z2E5bk9QTVczM0xtODZwRXd5WDdrQUQzV1RqU21WNFJuSDRBYk9VZ2JOd3ZS?=
 =?utf-8?B?b00zcHZ1V1VITkthaHh6MElxMExxU0dYaWJtUHdOQ3d2Nkh4UGwvU3FZbXpI?=
 =?utf-8?B?dzI5M0M5a1hSaktoaG1rS0VrdUZrSWRGKytDNmU1elpGQndxN0ZTa1RaTkRi?=
 =?utf-8?B?SDJLdkNySG1zUVN1RnJpYmJoUmE5Ly9FaGY5cVZsYTRiL1JreGQ1bFpNVUpR?=
 =?utf-8?B?NDJCcFRKK0FmdmNGYTZRMGlNWnI1eUpvRmtmeE1VZ2JGMmNoMkZSWlZUaGJK?=
 =?utf-8?B?eStUTnJmMWhZWmRnVE1UYm5QdkovTWNmbERHVjRGUjNiYVAwRmtmcUhSbjNE?=
 =?utf-8?B?TS94eXYvRG9OT2pPRzRnVmY0dVcrb1FhVCtCQnpmN0JxNVNBR0ViMlpzcHh0?=
 =?utf-8?B?K2I5UVdhWFFaUlpvMnBNdU9vcnJ1YkJtR2dNaHF1ZHF2b2pON3ZCYUorc1NO?=
 =?utf-8?B?NDBtb0xJNzgydzFCOU5FNnhZbk15MlBtRmRtMHBaOC9DcmdVaWN1WjFoczhT?=
 =?utf-8?B?SXBTSGI5dFRST21rOTNWRkNXYTduQkNydTdVK0Y2U1lvUk9KbmJncitlWXJX?=
 =?utf-8?B?ZnpPdWtzN0h6WDhSS0RpaGwxMDdOUTZUZGE1QW94YkRDdHJLYURZNnIyNi9k?=
 =?utf-8?B?YVFBbzJ4d0ROTVFQYm9EQkt3bGZmS3IwM0NZUGtnWnEzZU1ORWV2Y05rMUZJ?=
 =?utf-8?B?c2tIcE5SQXVIenhiZ0tOTG1sWVZJVC9lSVpVRlRpeVRYMW01UWxMcWdEY2lQ?=
 =?utf-8?B?ZFpGd3ZwclJTUTZ3VkdFeVFia0c0bjd6SlRBTDU5djQ2OTVGODFNNmNBQ3d6?=
 =?utf-8?B?MVdQcEtwUWZwQVJYV29iSjdMSTVLejgxdTdBeUwvcGJhcUJLS1R0eDN6QjdK?=
 =?utf-8?B?OTZrMExnT2lnRnZZRU84dlNaZHdEdG9aV1lUNTNGaWNaMk55Ukp6bXRFUmFK?=
 =?utf-8?B?QzNralc4dDhGWmVWZ21YUUhBdzNNaHVGMStta3U2dHFQZWJKV3ZZcXhPOUFq?=
 =?utf-8?B?L2oxTWNMZWdEdFlrWGtRKzd5MEF3MDQ0R28zcFN2RkVzWmpPdTd5TS9lOThj?=
 =?utf-8?B?Q1pOVzJENklRaUUxSzZ5cnQxWWFhYzMzUE9za2NVa2ordDExbzJxdVVpTGpr?=
 =?utf-8?B?RmFteWhyVnZCR0pGc3hCeldIcXg5YThKSjdlNWJ4QXJMejUrNVJhVW1taFdG?=
 =?utf-8?B?S1BNRlk1TmxyYkZ1WGVJR3J2UXFNcmFvakRlYk90SXVXSm9xa282ckdEZzhI?=
 =?utf-8?B?a3h1dFBsdzRYRW9rRkZWaTlGKzBybnMvUmRYY28wMTc3VUpFQWZNeGx2SldL?=
 =?utf-8?B?K09oNUtxRFEwYW9jRFlUVTd2V3RzT2JtbGNFV25aNTdPenlUbUJRVXNRNURz?=
 =?utf-8?B?aUlBTk1NTnIrK3lwNkRTUk40L1pCcUh6Q2FPMEVaUzhaZUZMcEs2RFh2cVQw?=
 =?utf-8?B?YWc1OFlsOHJra2FjWnhYQWppZWVvZmlBYndVNlArNG91anJadDgwNkhBalhI?=
 =?utf-8?B?eTBGT1dOazFobW90c2dVeHNwRkhMY1hhYWJYVXl2bTJDbGU0aGxmZz09?=
X-Exchange-RoutingPolicyChecked:
	P0HqAcUN5u41791usDpuNEJK34HWAUNaY6VsYsEknEG2YouEjhKVtnd45AnKZHs7b+ncSA09Vu2SDn1QVaxkn9pkwyj+0/qJyyqOHXoy9MA+F3nNEYUgvM5pIhmapkuvgKQrS6hFrb3cvYSxaSm7WTD+k7FtsCD7MO1/PZ1zd8qQFwpcRWpfLOMH6Y/Y02xHmF2pVea2BRhwgo9vFntZ1+fF1QdBix7/8ZJOjuW1l/VUsAIkqpQWVBGtLR+hSci+aYJ1mHg2q2o8T0Qi1uIfhU+w3yavsu7orLhvdBYtgaVGusbw03crN9s94wOY40EM/tKUlPFCOK9Lzi8u+wmZGA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Qe9Dy8Y1UTbUFqWsDwQ2lLFXPA5m9azexSCL42fXxG83HNL36qYugnYhiQmdkjjCMfpDT+OZnMtFK2QKXrc9UTCps84hnzNWrZB6EZVfDLcI/jLMMmPEBL+EilIi7ROnDVsqYFOzl8mfUg6sblvgYM5IMOna7lb8ql2fOCHTHOyEw0HXJx46O9AyLPXAkT7JkBGJJOfucaGS8mWKUJtaUBkpngGcDgrxbg6qMku4hfcEmupp8kfmSVTN6djMqcQd1Cn93JK310UDPlkQ2EmywD3mbLRt0eCkE5yK0yQQmLu9gfFy6ZhhHSbNEL17FJhfjVFJgpRud7d5RxFaJjURAQpOQinnuKrdqUcjsuufxS1FJMAKERo4jMwxclWXow7cikPok6mQUJMgkAGZIE+0lokBY43cB0hzim/ffuZBuV97X7IUtuj262msn1Qa1UG4dMT+30wSKkcvfJtFTObKQOUu+EU7sc6K4foZ+/8JOGpgiCKlcu2NXc/SAMtN/PI+Ukh3z/heE9IpBHQ8SbJ71Jl6xuI/CCkakuCdpXQtwKZaU7x+5mOczMeBqAQ8tB5trfmlF4NwJVUdj7ZvVxsdBGjm8dP7jV2M/UU6zwrRMq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47e2b3a-ae9d-48dd-512e-08dea4fe47aa
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 08:15:16.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EbXT3r3QeYjM4qYdNlIXQOo8ZdZn6yU7CzYZupBc7rGBEhaMZ/D0ZFNy9HBwnPf75kMTeDrktqNDvT0CJEO8Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280074
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f06c9a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=UqCG9HQmAAAA:8 a=fxe6L8JgiExHmVqHutsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: oFo2WpwMNIlDArKZx3drPWaTYTH8-gox
X-Proofpoint-ORIG-GUID: oFo2WpwMNIlDArKZx3drPWaTYTH8-gox
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDA3NSBTYWx0ZWRfX0ughBKzswVOB
 JpfNw79GxR6jiCrg1UjZOuP6tmxfX2kmpLpwMsxBHjmdHuIiofEpu2+mLaotvneGutAA+/4c69F
 7dvryrzd9kFLG8fPWRPtBTMz5zCwitUsMVLrxuJAfp2JYb9/QQD3s/E5IOXXQWid4YwU7DFliaK
 D21Ym1ujIO1OPYEWlFSd6abOT2FECPs7tNaT7zVmsdfPInslv73ljsHC6vSJpGhkheN31gFjkez
 lJJgVjv5+JRLiBOesOdSLBAFpiv1tkKi9dVKqzPUuP570x4kcHupPh4mgmF3z5ehfj+XngRpi24
 6945dNclCLV7mpl/jigt6PHKgpLE+E6ipTEXG//czSSrEgyjQoT1rhxJe5fWRQebRTkVu0HweeE
 vVDzulgt3MKAJ6f1Qygs+3tq1r//y3IkNCNpuz+OwMnFcSTDn41ZQjMweTgMuYCJcb+/L/vLn38
 MH5EaWgAEUv+hHceBfw==

On 24/04/2026 14:21, Christoph Hellwig wrote:

Responding to get things moving..

>> + */
>> +static void sas_dma_setup_opt_sectors(struct Scsi_Host *shost)
>> +{
>> +	struct device *dma_dev = shost->dma_dev;
>> +	size_t opt, max;
>> +	unsigned int opt_sectors;
>> +
>> +	if (!dma_dev->dma_mask)
>> +		return;
> Upper layers have no real busines looking at dma_dev->dma_mask. What
> is this check intended to do?

Back when that check was introduced, dma_max_mapping_size() may crash 
for some SCSI hosts. See 
https://lore.kernel.org/linux-scsi/BYAPR04MB58168CBFF8B691DF33C73DDBE7C40@BYAPR04MB5816.namprd04.prod.outlook.com/

scsi_debug would be an example of such a shost as it is not DMA capable. 
That crash is not an issue any longer from my limited testing. I think 
that it comes down to new checks in dma_addressing_limited() -> 
__dma_addressing_limited() for dma_mask being set. So we may be able to 
get rid of that dma_mask check.
