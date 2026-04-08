Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B563B19A0;
	Wed,  8 Apr 2026 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775665744; cv=fail; b=M6M2Y6vLnuEmybxq+TmIGdvY1bGumRFxCaw8oQ+O2PcdUHyBTOE673fAR1O72ddnWWHRGRYPzcOuzfw9MrKlzFS0/bukhknEp+B389dBqPi6D+WfReBI5/VWkcre0+CninyQkeCULMehMmPEt/caDj+XRPdi2jvnRNzeKS48BWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775665744; c=relaxed/simple;
	bh=7zmzAJYhg4qzTIwPE69nRHbyiZrnvO2u2+jy1wosWEs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oGx3inxkOVNpAMbggVDwhzKpmo8VKrmoAD0Tkvy/pvM00ibFjfVkrlY7UGeuev4VMFlcxmv+g5R0/KpEpHQSpJfZPprwUN/HF9/XN0Jv8dItvn3MpOH9brap+LEodSuj5C6YmRzKSenGkwfKUfUgj5vP+9nc17Stc5GVxsGAeMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qV9L/iRZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dp1dOtnN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qV9L/iRZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dp1dOtnN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638AcT5s1803931;
	Wed, 8 Apr 2026 16:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/dGCWyCAwyVjsWcrP1SK+IqqizGVxWw3VKh/OsmKHNA=; b=
	qV9L/iRZh5ft9Q7oWOxUTMgnPJpyHwVGLKhQYy1O++Kuw8VqqltGgABp1khBwz94
	gY50DK5UQULkWGCboSBOd3dbwiBHrPoEY3379R0gU+6YwmAQ56ZRHEHFBLgZW7Cq
	5+gHzcUjG11rhlkJOKdyGsj0FwecJGg5VmqbHgQjqFNYjBZ4un+IIgp0cZy4Y33W
	YL6ARonROY1ufIOpbj7eWyvi2TzVSENEtLfFLpzsRKj+Tjz1u35Wh5HUH+GiuxPv
	ZEe/aSMQkzpj12toE+QgWYH5fevoVme/3NrNjUsy2xrfAUVymSBwncqrR14JRE6D
	TjjWpldNwbq0MmUIsIkk4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqakw9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 16:28:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 638GElCU007071;
	Wed, 8 Apr 2026 16:28:33 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmek0qmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 16:28:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0+viu39Zyb6ncFfNGibwXn/ZShD97kTjltDdWOZmJm/80XioOMGiDaB8ZyvtjnOHzD1MpAaefSJbOES13lu7XGHO+3T6eik2Y+AEtHfJ5EsJLPM95FxEu2E+gfRBPef6SBhajMe001160tZ5m1OvrViLRzQqBcAeNVwOwIE4vah3SB7eI8ZQFnmJgT8ZSZ12WZVoMRcUVzbnKQEI01Q2l0FIJf0PEQYVaFANXeNCa1zbVtI3g59QMxUBZWOQFpMalym4ALxfPFqcgxrDxQnBqSq/dL8BQI5SPutLJYsNtFQVx7ez0W3UsJeVJFi/l5/Mz54+iyyjy3f/5Fso3d5xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dGCWyCAwyVjsWcrP1SK+IqqizGVxWw3VKh/OsmKHNA=;
 b=bqBQ03zZgkL8Iz7XHLKd3X7PXTYwpUtdrJrZwmXO3TU5zx8wk44nVsgaT1Bu/rR+2iMrAAGDNk33LsqgFRM1/Yo49dFmDAXmN4LL5BXQuYvxTe+qhud/YboCHiRv4GKyJEy3O9F2Q58tsAvfnXZy17OAYCUaMidvuZw3E2mKI0MijdgPe9g6G3ovHVTuxryYrHkdAHPqSYhtghpATV2u1N4HtbFKkDHE2gXbhpxNkMIivBW4kNcPBtIj6QOX9kmxNvuh9UzWeEglWI0/sBIWN/wURyF0RrDN552s5gdYMIj5KWBz3RUBsVjffEtMU9VEvSHJF+f/1EqrOZXmRVlw0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dGCWyCAwyVjsWcrP1SK+IqqizGVxWw3VKh/OsmKHNA=;
 b=dp1dOtnNiyefPXvRzn2yFymTG8z0K2WhUoWn6qyLNiy2USSouVVkmHXMcOaxTaDZFB5hu3x9YvQH9q88fg405Atb/1iZT9rOzg1wk7COxsPmlY9tYyrJYHu6TqxTo3tjncH2ZwO8QIbVRd+Oefho69XFw1tn+hEXI04VqjqL+gs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY5PR10MB6215.namprd10.prod.outlook.com
 (2603:10b6:930:30::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 8 Apr
 2026 16:28:18 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 16:28:18 +0000
Message-ID: <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
Date: Wed, 8 Apr 2026 17:28:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Hannes Reinecke <hare@suse.de>, Nilay Shroff <nilay@linux.ibm.com>,
        hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
 <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::7) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY5PR10MB6215:EE_
X-MS-Office365-Filtering-Correlation-Id: f800420d-edf7-4e7a-c7c5-08de958bd789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8Sg+VoRmuQXnnJq2SQgroNpqsCv99KnHajbXr2T8Tq7NVU+vaKzMX/PA8L28BuCfZVReJyFkZyeAEtFvIgABzo9kBFbkqVCmzNw556UVQaL32YTuAEwmPaofeDfBq/xXSEncphR6dsmzKciWhJdk3YOpfJ76AaI6fpPLGmZmlAiNxgni2St1uw6jsKshYdY3eSlvyjN3uANW5bjZojqvDDislAGQdRd6RaW8HrW+qIkqsglZbNjyjdh9m00Q3FsTP9YN7wcvtZVMj9OW80bu8J2qlJP709H3THYtNUFCeP6a+9E4qDHX5IROtgSGqpYp2yHe9Y/izKBwy6eEJYMsWfCerT8UV09vswUGggAE1a8dUmCU2H2SvmukN6/k6oq/umoppd+Dt6HRYd1pSN8FJtQwPSwo7dgUNObtUcLMXmU6grtOwZz0U+zDyI3QTS6o2+FuTQ9KI/Mmy9oU28wsJQGzxNB8vy/AvLjDZAbb+QwsWoN+TlpWajQ1LN29gud5kvVTeDmE+Trs3GjS2CDYd5edX9B97pXGBz4yiKb82tbbsZC2HoZbR8/J8ah8uip/ARLdH9RYOp4l5A7CrQOwxnEBQQlbjnSFGyrrqJkIRS619eqMTt4m7w15OUgOdaUyfD1uHWJO0YZux/DzikXhqj3bpWacFenJKE0WyVDFOJso8gkW/L7c1eGbOqhGVow7G+Q6y9AY8qBjFVa5A79i8nWZbA40VszwWkVWkxQQMVg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amdFQ2hyemx2R1pDMEVCbUthdnVTNSt3dkpodjI3c2VGczRPVGwvTU50NlV5?=
 =?utf-8?B?eDNaWWdWUEFsTm1UcWVDWlJ2eHJMa0kvY05WN0c2dHlHcUYyWURtYzV3YjlJ?=
 =?utf-8?B?Y2V1TTRLczZxbTIyTVA3VVJtS0dJYXFBdDIrTEFDT2pGcmt1V1JFZmR5RVZM?=
 =?utf-8?B?SE9yK1VNcjhWTEtSWGJ5NDlEK3owK2E4K2RScXJXUHZHL2phUzVRSVZRZ2xK?=
 =?utf-8?B?TzZMclhyWXh2Mzk3K2JSeTlWSXBoVW1tVTkrZithWGhheXBjbzd4NWRCeWdZ?=
 =?utf-8?B?QzFLbVY5eHQzaUdxSnV4YkNaak9lMEQ1YkQzUDVBblI3UjkzdUN5a0lXKy9m?=
 =?utf-8?B?ckMzYXNuangwbnp4RnZ1TXV5MTZ5UzhzNWRjaGdocEgrcHptcUVDZVpYME1u?=
 =?utf-8?B?am9vWmViaHpyWXBjdzdJVlhNM1lPWTBjcWpIYjAwL2p0WGNoY2h6SGNmRWxq?=
 =?utf-8?B?NDJYM01RbFVQY0VxZjFJWnpITkRkckcyakg5TFFadXpaclZWbmlGZDFrVnpl?=
 =?utf-8?B?RUtadDNtNzlkbW1KZ2d4WHUrYmh3MlhXdzNpZThkVXlpdnFtWldENStqQ1N0?=
 =?utf-8?B?dmRhOXM5aldJYkJKR0QwL05ZSXNkeVRYOTdwVDRnTGdZRXpzTTJTTll2VXRj?=
 =?utf-8?B?cEJhNUsrQ09VdE1WbTdPSmlzR2tzUjZJOWVvV1pOWEZpRWxPOTNFeHErbU00?=
 =?utf-8?B?amxCZ3I2dEZvT0hJVlhtZytCc1daMHJvMVlBMU1BY2cxa3BXRkxRT3QzYThV?=
 =?utf-8?B?MGlINGdoaXEzRG44b2U3SWg5OElBTWhBVUdsb0NEY0lqSzNtZHNDR0EvN1I0?=
 =?utf-8?B?bU5qb3RCRFBreVF6c2dCMWtPWHRSbitsc21YWm5mczIvQWVCSHBiYm1FRURS?=
 =?utf-8?B?OVJyNDJoUHZaZ080MXlyM1VqcWdrZFJKSGtsYm1jRVNBcVdLZnlWa2lVV3ZY?=
 =?utf-8?B?UUp5eGFYV2pkTkFuWW9jL2I5cXl0RHRDM1p4TW9vYi9EVHNrdHp4blpsVnRv?=
 =?utf-8?B?bjJlQUI0VmZuc05XejRtWGFqc0FDTHZ1Ukc2eHArV0hTbWR0OVVBbGh2SUZv?=
 =?utf-8?B?eXlPMEk4eGdFMU9tcVZvdU1SVjRra1Znamowd0VkMFBwcCsvTHdoZVBJZEQr?=
 =?utf-8?B?VE5oLyt6TGRQNTR3OXZ0WDNsWmlSUGlKWW5BamM5Vk5FdEJpMXhnZWhneG00?=
 =?utf-8?B?eWVyM2VyalpGS2tKN1d5Rm8vbGx1TFpCRVFHaWUwUCtlbGhLaVNYeXBLaGNG?=
 =?utf-8?B?dXh5OVRjMTlHaFp0SDkzZGxhNk5mMjNqN3Z2c2tjd2VsWE16bU1VTEM2ck5o?=
 =?utf-8?B?anlhcm83ZGt3VnRwVmxDNUsyQlJwOGFscVhSUzZqSWxTNGVPV2tndWNYcXZO?=
 =?utf-8?B?dWxqTWdVK1NDQ1QxaHNXejB5Z3hEd3lkYlcwdEorMmdacUhxTnJGVlpQS0dO?=
 =?utf-8?B?dW03OEpkbzZKMUlxMEU0d2xWc1FJK2RDbWtYQnc4Wjc5MHgvKzR4ZW9YNVFL?=
 =?utf-8?B?QmM3bVI2MUJXQVR3MDg2S0RvdnIxaE5LNUtyQUtWM0NOdkQ1aWIxR2lyNjdI?=
 =?utf-8?B?MktxR09BdDd5Wi9jdHFnb21VRzF1akxjc05oSXQ0VGE0WWE5ak9ScGVqUStz?=
 =?utf-8?B?VmFnVUFqeW9GUFpIVStLdUhic2pGK1dqSVoyYkc5OVFManN1OTc4azFQSTlt?=
 =?utf-8?B?bWx3N2E0TEJwaktJQytWTmVKaXBicjZEb3RLR1hFUFBZcFhNQjFrMXRCRGhE?=
 =?utf-8?B?bWdqVXlmb3QxUnJ2aTFrQyt0WFdCNTEvcFZWbS9HeGwvTHcySU5POWxrNEVK?=
 =?utf-8?B?cGczMHEvZWtPUmFEQ2R1QUQ4SmxYa1FBd0tNWG1OSHd0ckl1WGdjTWgvdzdK?=
 =?utf-8?B?WlJkQkdLay9FVHZwYzRtaXZYeS9pVGhxTXd4QlA2YnFJS1pzQ1lJT0VCOWhx?=
 =?utf-8?B?d20zbTlQK0l0cEYzdkNyQ0xTaktkRkNqK3ovYWU0VWovZnFHbzJ1Zkh3TlJG?=
 =?utf-8?B?SmZ2Q2V1SUpEbVVYcm9WYm5sTnFWZ1d3OUFyUExlNTMyTlpoNzFpdWkvaHFx?=
 =?utf-8?B?ZHVvUlB5NlJ4UnZGTlpvS3ZybGhPZGtYQTlOUEtJbEdJRkNWN0puclVGTnpU?=
 =?utf-8?B?ekJtOHcrUkd5dHFWcTN6b2lCV09vcitrcy9yZGVWaTAySFJwd0k0T082Vmw4?=
 =?utf-8?B?U01NTkhQRG9WOWlaU2hpUURaVWlBa3F3bTlHY2tTL1EyckVWZTdhZDNzZVlo?=
 =?utf-8?B?RVV0M0l2SVpFUWhTbHN3dXd2a2l3WTJQK3ZFU2hzVm5Pd1h0UkFOcFNFbVpt?=
 =?utf-8?B?S09sdWx5alozeUl3L0tyTUdWcnJZd0VML2xNN214VllyUWU1SVRCdz09?=
X-Exchange-RoutingPolicyChecked:
	PrBslN+uJI+86y0yG0AICydAKhSX/EHR7uA8tutLxz/hQ1oXllmj+Y8UNgsr/3/oxRVSlqB/J9Ga8nHOHd3LI5GJGOqb+apUaruOQKXoh72rLi7vfG1QRu0YWAJwEun+PbkDDS5ZK6aY+j/yt+qzXn+88/JwQpYq2oUwgeyJyz61zPd0cpGPNJVySRz0pkdo6j/tUdYg40Ek1IEdbkbqP4MJjBIGxW2spNhhfkvWQhU6GHhYnLBjIFeB0/ke+dBFoGxeoOp0DBJOxwxhmWF6Q72wDy9DcQFJgYlJaO528G1W4LxdznMjCKgWRWNL94IE9OJzAT8LWIBeLQpELlBJ9w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NMcjuR+liCAqShElsDzyx9b6QC8GYH+p/B5QuaXCsVJxnmBaS1iLNgjLQaeJrizeFgIg59NHzayPUFFp0g6Ohdy8sJVXOZK38NUfoUB+sW7j5HjMHQ5aCsWB5fQbNYEaObmllPjszUJBjXAqXrYItWFn/qC9+4Jpch5agsbXaaOii7GnZ+Q5sFOzKDn5cJSvhi71n3WVssY2V4FC+zX2iriZp635rqmkMqScPK4PgZ0S/7g/uFas4OHK3ANgHLq6hImBYVTSMX7z/U83nbQKOY3OoGe0tmEWcnV6KhGw/sPtrWa1jBTUv7Cf0HUBV4i9Z3s6KzTD0GdTPBvWCVQ1UwMtapep0xUy9LM0soR8GawxcrMISvuhccwm8w7Zbh/pWPw8fX3WKCqbVIg0GQdljhScuJ/reEMT+2oV8zzCmn4lxsHmDQH35kqgKAGis15KTy837CVV8Mr2jMkl+g+hDDS+LsQSbMWbiApmSpaGKurdXpHihncNt4c+gCUe86PJeKmw9iaCehZOBmVmPXHGe4HCWDCc0m2zKoJMjn7d+tRI/I/ehYPpbPfCiTU1+wA5ciuShDYorxg36E0w31VQ4qPrTFifCK7XhA+ijW3Kbew=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f800420d-edf7-4e7a-c7c5-08de958bd789
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 16:28:18.4979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgiqzP/KStwOFOJ/fFWlmazEGWuiBFiEH/MPI0CrkUl5kX89lL8ZIN+KxSdu9i9rjlhypZFXkr9MYFPZjbk9yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604080153
X-Proofpoint-ORIG-GUID: uB5Q-1NoeMyvOuZoiVvShBjxLmnoZybs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE1MSBTYWx0ZWRfX+HU4MDgK9Msu
 7SE0I5iYMtn+MdrOP7zjJOIebmWRQRh4DgP2cdAyeYikoSRVKVbEgEAWq+yoJM+FiYvMfm+RTua
 Kwr2AOES96DP6zpxv4TBStC1jG1Ds5oVy6HvO2cTZ8w9OfC5Z8XzFBM19GZJ16pj43Xnp8kwb9s
 5O5EXphwmjRJ9h9tUtjJ90PhHSqt/dpZLXIp4Z1CUeRAKspHQN70LYCvo7L8DRNOOXHP9X1bZjz
 2cX9PeF1booQzmoMLymgUtAfaI7+Kq32bVufyYxG2rFAKkMrrbLOhXwcf2TO8ET3FQLEA3W1bwq
 qrvqStA3vAzKXyGD7sk5yExfu5pW6pXxZAwGVW/WQwI/+0wRRdoxJaKtQ6jR7PlJvbT8HAU/g+6
 RP1yL6lcAc9sHW5tGRyWn82SaBDDHC0BF8+TQCmXLluvVlDnXsMCwHHNOjcNr2dIziMlLYvt88X
 6q0AhJhHjoN7U2p8QZhStR1X4j7zoUUsjqtWjKQs=
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d68232 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=j1hx4iPSBMYj13gSilYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13825
X-Proofpoint-GUID: uB5Q-1NoeMyvOuZoiVvShBjxLmnoZybs

On 08/04/2026 16:41, Hannes Reinecke wrote:
> On 4/8/26 13:28, John Garry wrote:
>> On 02/03/2026 12:41, Nilay Shroff wrote:
>>>> +
>>>>   void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
>>>>   {
>>>>       struct mpath_head *mpath_head = mpath_disk->mpath_head;
>>>> @@ -793,6 +868,8 @@ struct mpath_head *mpath_alloc_head(void)
>>>>       mutex_init(&mpath_head->lock);
>>>>       kref_init(&mpath_head->ref);
>>>> +    mpath_head->delayed_removal_secs = 0;
>>>> +
>>>>       INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
>>>>       spin_lock_init(&mpath_head->requeue_lock);
>>>>       bio_list_init(&mpath_head->requeue_list);
>>>
>>> I think we also need to initialize ->drv_module here.
>>
>> Hi Nilay,
>>
>> I am just coming back to this now. About NVMe multipath delayed disk 
>> removal, did you consider a blktests testcase to cover it? I might 
>> look at it if I have a chance (and it makes sense to do so).
>>
> 
> That look patently like the 'queue_if_no_path' feature from dm- 
> multipath. Any chance of reconciling these two?

You mean a common blktests testcase, right?

For NVMe, that test would:
a. try to remove NVMe ko when we have the delayed removal active
b. ensure that we can queue for no path

I suppose that a common testcase could be possible (with dm mpath), but 
doesn't dm have its own testsuite?

Thanks,
John
