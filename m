Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60A539E17A;
	Thu,  5 Mar 2026 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772729623; cv=fail; b=PhBAAPM4kVjLAEW6UeIZxhdBK+65+0fPR/vvkKrAcBj41w/Af740SXAjYWHsTzGrsuUIeRl9vyK5609EGU0XhvtBGw5xH23huBQoCmb1XNQvhgpj08SGIxSouDvfFSmKI0gs7JclR/9WyuhhHrM6k/J7+dAo17PYYFhE7DD1POY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772729623; c=relaxed/simple;
	bh=X1c0pKx4APUqzYmC/G9N25+I/sRgB4L0x9T0m7iDH5c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MrmQTWc3BCkmk5kfRBrEJAHN4YoUuvoYArYFxvMxZ32YWWFSA/PiXp93pjkDiOFDlRvfY98sT5kcm06UvO1Kmh6cn/I9pzmL43nwD299XjxdkVmYkGqtwcArCeMbH19xmK0VgcGI/omYSfQ5IApeC6CPUknPRIwZ6nJVASMbwcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dOJp2U3Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RGYdsDKr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dOJp2U3Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RGYdsDKr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625FnvlS511560;
	Thu, 5 Mar 2026 16:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xKmV+fSzjGbREGgSTjRME4C+aD4Wm0nLgE6OVzRGFhM=; b=
	dOJp2U3QVDITwMIoIR/tBtuZWiZhbfhy0HGJNyJaroF9Cs1iPELpRMwXurUm7P2N
	Fvmp/0mwfQ6sasnCPujpALLiIK26za54yWZFa+rlAoddG0rR2cXW0OwtN/AGSPq8
	eBLXUsle1i4EY/ZzsIufsI+nlr2tL3nhE8fFrwHUT+tch0bYR1bgnQqrhzYgdtO5
	CBc3iL7B5es9+xFNpuSirWvqVFd5AkswUfFyBQUMYwG0coRV+bnAqBDpYFjDk6hj
	7BEwwL3hH73iPf/mbvkPftb2MYahpaj7MVTHODLWo+8XsXAyJrwgORCK4fW5NZ+Z
	QKdNMz/Xe1tohJcs8VyifA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cqcts03qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 16:53:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 625Gj311029757;
	Thu, 5 Mar 2026 16:53:40 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011011.outbound.protection.outlook.com [40.107.208.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptdfjrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Mar 2026 16:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3rK6icBozzuTqyGIyqJDkdXLY89LzEoTtLe4kNf1vziGoKTvwSCTwGVpcuH3112OuRV9AjdtdyXzyPUfcs50ln7SVVWddrP4tk8BpguNnLXDgv4zLt7KtWwGCs8r8g72NCCckNXaL3qQwt50XHpQ1LArOH2t6d9KkI2Dff/iY1qP1i3J6/n6uV1rX54dJyVo8UNuspt3LykPbKZ0HhCJEkWJBXOHvq0asFBAANOgA2GmDihB/3P9Xhh4R+4gGGro6TLQmSQ6Z4gPUiMPm05M/7ojHcMp6bM42T6S7poJjGOMakdbdiNn87A+7CU0Yt1r1HGEPRQdJQQCTO8EqMRHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKmV+fSzjGbREGgSTjRME4C+aD4Wm0nLgE6OVzRGFhM=;
 b=LxzlgDivOyl0QCzhckbs/En4f5uvF62+vVE5xhGQlR4NhPLFwlyQhXpV7biBxEYuGcDVMOIQX/4wz5MA5NsXiUr0zFDu8v9aB+rplm1WK6sdbCkIR+P64wjZR2/Cwe761j6CV+8hrcZaqaSsTin97fyxT9bCVEv/Qt9HuWejgmyzMuUWEQxR5SDKbnSKpdbYzJgvhMB1SOdAvrR9EdEGGth37+kSqxGFERs63QyMC2zKbeOZySUjT2eLrlxH/VDHcfLjI3HqHWH4zTShNqp6PgbrctO+fEF/nBQ8Tv8WYFpDFYPO7cQ/lfaWon85Ec0J0PBhj4wCN4GLMGaliODAZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKmV+fSzjGbREGgSTjRME4C+aD4Wm0nLgE6OVzRGFhM=;
 b=RGYdsDKr17J5snuKa7kIaBZFj13JiytabMagz72pnCOKEGxSWP0u/UD0MW/jcMb2StsGvkYCX5JtGI5gRSlNaHcDUh957Dgc4yvNpH4kw+1E3nrxPbM99O8FhvpXZ/TDGmhJ1ITcfZHuHeW7OPSxuBZv43YRmZggbHZhXbeKNpQ=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by IA1PR10MB6100.namprd10.prod.outlook.com
 (2603:10b6:208:3ab::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 16:53:35 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9678.016; Thu, 5 Mar 2026
 16:53:35 +0000
Message-ID: <6d2112e5-a075-4891-9f32-9036e9528bed@oracle.com>
Date: Thu, 5 Mar 2026 10:53:34 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: fix default complete_type
To: Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com
References: <20260305094539.5721-1-d.bogdanov@yadro.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260305094539.5721-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0358.namprd03.prod.outlook.com (2603:10b6:8:55::7)
 To DM3PPF905D77450.namprd10.prod.outlook.com (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|IA1PR10MB6100:EE_
X-MS-Office365-Filtering-Correlation-Id: 277d4641-4d95-4bd9-7af3-08de7ad7bd8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	mejh6iWvI53I1DKaGKl6AiuTrwfHkJDRx4l+FPdED0YAICxNHvWniQESis2jRmI0y7Y7PwAUICTTyxUaR2bdnJrGLUDFEt9N8J62vP7u+y9LnNYm75YYMMnTAJNij1ziuyjqXfFemA01Tryhk90EmhKC4ZwqB3+dair2YyXshNyU6Fqej2XpWpUxoICFCJIS0HNVFv6hEGn8g6azXt1Oks6sR1v9IVZtAgt68PofbyoCQqCoacXuWxRwddOoZOEeSHGiOu50KwjJu8H4lmxnjlkDBvcfySGDM9FSQLJAJjOYFRHaye4fl24sFtPSkXL09x720i5TSQYLenrVTj+DD6eEM5usQjc67VxxV2zVN5yFW78Qnxzf+UYtGaHnI5sLcccNg6o8hueQCHZcagvyJDE8PMgsD+12VoUWK8TReNK2DfEVsvr4CSpYPn+wBz+JSUZHNYYeS+E8Frntai842Ne0laFrl01i2Jvk/7LhVh3hUyvrzEzVa1mPD2nDwXz2nnBwXjh2RjmnUsvsjBog2QERPSZORMiaaNvh7+7UxQiHyuDiMlERKF9sNktWh/ygZRexEuzlCPe4u38+1h4PRcQgRdHrm/E0S+HyZ173mkGgRFpZq4Ls/0JrzLk5Vu9YwU2nabVoXsXae4IT0ChxtNznllNMf/M1TOZjYhN9ejvHmzoozZ+dWhx/oqwdRE8aUAzI1j1O3p4C5E8xJZ7SQIZQwO6ckm3LFsKdTPV/gWs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b08rZTJpYVZYcnA3TUcvblB6dzZMMTVNVUJCQkhYT3EyYVd2UEhnWmRnQWVE?=
 =?utf-8?B?MGNCZWx4QVdEcVBFaVc4b0huSmdPNTdUMWZqNGxiYjFOQ1NiQStvZFZsMXps?=
 =?utf-8?B?SnJ2aUhGVC9LcDN4V2pXeXROQnErblpyNVF6OTVVU3ZPSzZtckxDNkFqMVV6?=
 =?utf-8?B?b3U4OGhSVEwrRkIrakhJTDFWN28yQmpDUThTbVduQ05BMTlMbEFrS1dmWW1Q?=
 =?utf-8?B?K29TTSs1RG16aU1NZkw1YTlTaWgyVGlqRWRTWEpFa25KWEFhdUlyb255TGVh?=
 =?utf-8?B?UXRTRnpDNWF1bVhaTktsVm1MLzIySTdyb0dEOGx6ODNDOVJQeUFCaHk3eW1R?=
 =?utf-8?B?L1BSWHd1eWFYV3JQNlFjUjkxTkkrNFZ6NnAwZzhWODR1UG93dTFMay92aVhp?=
 =?utf-8?B?T2lZN3poR09HVkdteHpubGx6NTdiR29zaFF0TjgybXlGem5jQkx0bzM5cDJt?=
 =?utf-8?B?eVpkTy9VWTRCK09FeUczRFd1SEg5N3dlbVIxSU1ONXE2UENycnRaWG5DVmdG?=
 =?utf-8?B?ejNnMVhCbVc5K2ZXalNSMVE1NFp2S3A0TUNhY2dUZWxaeDFRZC8ydU1Hc28y?=
 =?utf-8?B?aDlYWkNvTG81NUxWU2NwOVZsNDFtRzdBVzk2eW9ESU81K00xcjhNZHdqbTBE?=
 =?utf-8?B?ZVVvZWNObTRNU2NzOXV6SE9YTVRHTWIwQ2xhY2dTMjhqMllQZ1JFY0dobFZM?=
 =?utf-8?B?MkN5b3lwaWVEYkFqV3AwMTFta1NFOEpwNXBPZk1MNmd3Rkh6eXEwMkVZUGZu?=
 =?utf-8?B?bjBJdEdaMC85em9QQ2VhcW5DcmVlbEpqejNnaUVOMmU3eTY2UXB2RHZqSDYx?=
 =?utf-8?B?Y3lFVGx2eTF0aEFZN3JYejdERUFRdzI2ZWNJWnNhZm5MTTZ0ekVnOTVmOHYy?=
 =?utf-8?B?UHViU1UxNGlxa1JFZ2JGRUgwVGN1UmF6dHRiMTZMY3JKK21Rc3NBcVhqYklF?=
 =?utf-8?B?dlpmdjRrS2FaOWxFbTNMNXhUL0dmTlkrUVB4RUY0OHNHM0JVWkJzRGRtRjEr?=
 =?utf-8?B?QjYzTHJjM0dQWUlkOTF2M3NQekpNWFNsZVY5c1hDUG13ajNYYzRmSUhISWNq?=
 =?utf-8?B?eTR0dFpCaWwrdUx2cnZCZXJMWU5xbW9ZYTdiWVAxZnd2M2FLWFdWL2JPalIr?=
 =?utf-8?B?ellvdFdQemZVaFprNWRBaXBQOVRnOHlLZmtDMFI3MVhPQ2VWeCttTXdSdFIv?=
 =?utf-8?B?S2VaZ1NMRnhCenJTVENLdjFxNnZSejFTdlE4dWNLU1Z5Zy9nSlYyV3dBWG1y?=
 =?utf-8?B?ejlUbUFGTnJ6VXRhdWVoaVBKNWV2MVpEdDBXMFZnUlphTmJlZjYxaHhvR256?=
 =?utf-8?B?RnRuQ0NBQ3VSVjBaLzVxSGR6aTByNWJoSFo1Z3hkQ0k5aWEyWVdXUU1IaThF?=
 =?utf-8?B?ZzcxZldjanQrUWhUa2R5TTJJSXhnUXpSQVJHcTNrUlY4N1ozQlYyand2Z0R6?=
 =?utf-8?B?cjNjRWIzQVQ1R0lkazBsNURLSWlLT2tKVGNwaEdaNkNKNHczTndvcytzTE1N?=
 =?utf-8?B?RUxRSkNOOW9zOGV4OFhxMmNqWFhoaElTeG5wS0NQRkwyZFA5b2NEVEw2L2hI?=
 =?utf-8?B?Y1B2aGc0dEx3QVhWbC9sUmRENVhOWHIxVmlTOUhGRE51dUh3QkhLaTNEeHVu?=
 =?utf-8?B?K093ZzRuL2dlM2NWa2RRWndhT3ZQOGpydjlvL2ZsTEdFS0xXbllleUtEdEkz?=
 =?utf-8?B?eUZGbVF1dVhlZG9ML0xab1Bwb2wvSEJNNWs0VXVpdFJ3Ry9hQU85bnM4YU1J?=
 =?utf-8?B?M25MNzlkdHVsV201YnovaHc0amE0SlA2QWtRK1BIakUzeWZQSHU2cHNZWGZa?=
 =?utf-8?B?M3E5aFBhckNrd1pQSkxsMTRBMmVmSWo1ZWpNOHRORm14UkFmclFMYWhpc1Az?=
 =?utf-8?B?UEVOaFZXQWpZSUI5TzlGSkV0Lzk4M2NzSlVsVi91ajBlR0RydkNNRHVYTEQv?=
 =?utf-8?B?WlBKa2RFTEJ4dXNxL0F6WHlaWEEvTWRmcXdEL2tMc0dIUUFGVzZOMW9TR1g3?=
 =?utf-8?B?eVR1UWIyMmRaUTJNWVl3d2h4VVJKRjRCaHUzK0p1cU1ITW50aFVoUTJTZmFw?=
 =?utf-8?B?MDdJbVJGZGc3ZmRMK1oxNXNrNmdNb0UwdUFBaEtKdXhlb250WW0vdFMzUmFC?=
 =?utf-8?B?eU4rZk1kOXA3MWxPWG1lSjl1bmJ6OS8rcTl0SlZxYWRmeXhWR3Z4aWI0cmMz?=
 =?utf-8?B?Q29zSDlhWXluczcwTk9mTkcvbjY3dWg2RU81OWVwbkdnSi9uUklnVTJ2Vlly?=
 =?utf-8?B?ZUZBcnNCVDAxL01NczRaS29MSjlIbmQ4b0tuSG44cGJSK0NoWjJTTkZWcXpM?=
 =?utf-8?B?WWMvODJiK3VMbTV6VDBsVk9jN2VmT3BXcFptWWJjc1NaUWJwYk5hWW5tTzVo?=
 =?utf-8?Q?CROU4zu2ALVdjCAo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4VDW3KAlm5ivxi0ESE4LUy1L3vKd3cBIxmeclStid69p1ngtXE/QKLNKryv4ZXdnDvtTfmJYQWeuS0z0KUqkujkMkG1E8S+i0k9nCZSkg/qK1mrxiyNwm9wkSv5tMXn1K2OiBayLBj+QVZhv2OQan0tJavGCVKdqy/3P1Rgq0BNq9e9nLfNmhHLNLva5Zdr0B7RFuNHkRZOIFOgWVYJmQR4UVKNbArHTyWZfHd02ZMKU0W1c8F9n8cQwZ0AdYWevX7hQnj5+WoiVxIriMVHZhN9pZA/lzavO7dhWfgFYyMpyLwsaMWvpvYQUDeq6Styz/gkP/tPXbL+X32BO3q0lkpJ5nrf492LlIcA4m5lmvg+ySqtTKOtjiHttiuK+2SkvP+PIxWe/P2YojWyBkg+nDUDbwaRDe+nFsZ7mu1dku6+O7eCASk8VLa1sTr0euyeRAEVESGy0pHOCL+7ByjQbwBlS9E3BFNA42XZcOOm8j7926LzcbnvGvSQ5vN0zMqX4glAkBZkA81Z/+J1gJRQgQSwk2XjIx8GrrBEEqij/UH5l8OIejqVGkf/E8p2aOghvwB109umUztFYYr27wTBLeYgamDA3YcOAYahDsRXKA34=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277d4641-4d95-4bd9-7af3-08de7ad7bd8e
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 16:53:35.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NalwpA3POLELYloDcf1TzmfYbhM4R2Y1d/gHty9lAYHSnmHa7xmMbNt3mSZaah3QQV/A2FWVgCBE0r38+aJjVAdu+B2gEAmEghp9/kfzEss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_04,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603050137
X-Proofpoint-GUID: nUwAK_doHvm9eazqUEr6Xf6CItdTT2TT
X-Proofpoint-ORIG-GUID: nUwAK_doHvm9eazqUEr6Xf6CItdTT2TT
X-Authority-Analysis: v=2.4 cv=HYgZjyE8 c=1 sm=1 tr=0 ts=69a9b514 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=-c9VzbpeAAAA:8
 a=K89HNbEPa0JqF0rnbIMA:9 a=QEXdDO2ut3YA:10 a=WAq88MDkwfy8HpmZFCM0:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDEzNyBTYWx0ZWRfX83cHgPrEZP3S
 rxwm34+OVejyy7vp1Tuqs1ZWPnBOSKmIGm1ouWLA0U6OviqZyjDbF32/DXPEyAAfraPcYSEhol/
 a0dUsV7XmqXOsaLWcepeNjtZY0JVE1NPtZ92vszLyI4BsQ7GdiaMmXdrX8ZFigBXo5C3dXwigI5
 g2+GdK81kGB4yzaWV/Ed49FuEnCLz87BNn/xAdmILZJNsUy/hbMLwnaR7oDseL2vwfZtn9yQsEz
 K3M96WLmTsTUE8juL+qzsGMnsJ4WKuXDtpltqler2UlQFvNaOSikV/06UAu0X2EhBIu6pVvAPOV
 1Afh48B98mnjj5ct+90FDPbjHw/tfpmCQS40wxzLW91YpLu14Tbkpr/nv8QKWSasa4Y3G0mkjCm
 V9N92vyyEIyHcjD4rFUeFKxU66oTmGumGaGNY5QpFXwH6BsAr7KrFIIeSrLdYanu2jgV706/BDp
 QxO2uTBZXaXWlQF0CyA==

On 3/5/26 3:45 AM, Dmitry Bogdanov wrote:
> There is copy&paste error, fix it by setting the actual variable.
> 
> Fixes: 06933066d88a3 ("scsi: target: Add support for completing commands from backend context")
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index fbc8ab65372e..9db2201aa553 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -813,7 +813,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>  				DA_UNMAP_ZEROES_DATA_DEFAULT;
>  	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
>  	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
> -	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_COMPL;
> +	dev->dev_attrib.complete_type = TARGET_FABRIC_DEFAULT_COMPL;
>  
>  	/* Skip allocating lun_stats since we can't export them. */
>  	xcopy_lun = &dev->xcopy_lun;

Thanks. There's another similar case. Let me ping Martin to see if he
wants me to resend the patchset or a patch on top of staging.
