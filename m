Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7787C26158B;
	Wed,  7 Oct 2026 00:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791331272; cv=fail; b=EfDEvi4iDKcu8EIk/TSNptaz5biR3RwD30Q40IbXuIwN/ZVKJ8RWhz9n0ctp/j1dhprpYRpbauQNORt3sRIOMYTqRMk2GN/3eJDmBvdbAKj3JVYiGPN9pYmPGekTaJ+IPdHV+erEgTPbe9+JWklu3GIMHSuWHvEATbibMZpneXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791331272; c=relaxed/simple;
	bh=nfOCjVf1ljyJAFepZpem/YeMMK/+mI72Y3+KXfISo+8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UHggbOBt1mgzxjLKjGFKByRQwupUCXEU6ptlu7o6bzuE2DDQE7myzhL2Y7+mDni5DJ/0nHHo5cnfFwn4jUgexs5T1r0YQOUsi4dWrl5hsL145p+hjLEHomq1ZfFD9mvW+vf3ffcxrl72zeU3IpwBCj0mMRt3hwh5E/iWdUkNmdk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ig/JPfnx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zNfkDR0e; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ig/JPfnx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zNfkDR0e"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696Lbe001694822;
	Wed, 7 Oct 2026 00:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2F0lZMEB0Pglk2mHQ+jBKRQmKfy6DKbDwlqhXaLxaIA=; b=
	ig/JPfnxhwyQpplILHw6rXw6zuZqDryJH4vjAS2aQximugkG8luQ8xXGTuyuC9vx
	Lczgs/RSMjrHeV/FrGrRfFJE0k3YfVanYQMXjM5iWFy+nHbrF1hrNw/yn/apooWG
	58BnKRLVNfGPGS6OreMuAe/1kY3XsBU8HDUxVQVIjLsZpXTTjxX3OdUM3pZ337Jg
	VW3MSSrSN97h2V1CCWDE4NxnVmeniYtFnsBckiPcxjGAR0SWFXQP6GMxrPg9BAUV
	0tkIhh0fuCc7H9djyzGfDyqAEitayePs7EXEWXheFzRlIEgQeV3EpwEgJncDKeJK
	yHA0+Aa1jAT7w1p6xMnkNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2rm9csgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Oct 2026 00:00:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 696NpNJ6040441;
	Wed, 7 Oct 2026 00:00:54 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d0y9vp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 07 Oct 2026 00:00:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ja7REPrMJtSYkdZwN+YN6rHQP8biG4G8t6k6TSqFx9Rirxgq3zSaZ+ojjzq2n0G38ICBgFfaFJiNfRtKP09dVMRck41k1kogZV5oiYhDr/sfd8BUyP04I1ql7Qp3dNuGDKn/XnfcMQGwm4OMwQ8BjEP1EjEFtPEIn6z1u4IvkYD00m0WE92XW/fZwPKBkIty1U7jpaSe5+WaqEWrdfdTQ/g8w/rjSjlO8VcPfgrkzNynUY9DD8GJqTPDc6JsEYYHYpDqkYbum0SfjuO+9oQLgUj2vUyDVdIYwrdoJpRXYsE6BSy6TnQI+aRFpT2Ojajg2EYQ8QlAuhiLpLra1hI2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2F0lZMEB0Pglk2mHQ+jBKRQmKfy6DKbDwlqhXaLxaIA=;
 b=hGYPUkBocfZfN4LqmNYPyVOvgVuXzshA3vd9LG8LGp+Yfci5t58pYzfxxgjCIlYrm9J2L0ljtSIdnrl6R58fmQIvSe/3HVFr9lkh1e/rwlvYGtTL3R7YPjp0S/eHgyMwHIdY+Q6QE36xoiAT8mOi4Z4ULpupW7AaGBJe+zIvzFUnB5OvKlxrTmpdIA4SwLju+7uTThZlXHcCt0BNFUySX3H5a3lkU3YZ5AD4YcvrSflvrwMgDtEspwSsM577eZCGshKDqP2+Qqtmm1bcdYwTgd1u1TpcGrA8+RpnNImgXqY3t3cVBwIBJ/aq+X8t1R3Cpd4zbYa9ZiaGeLl6QN7llw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2F0lZMEB0Pglk2mHQ+jBKRQmKfy6DKbDwlqhXaLxaIA=;
 b=zNfkDR0e8zE3DnfizdtGQ31xWqbQ3g12a1lcgMGLZGyrlkYS1mnbU1QKgjPkbQ3iv/sAzoszAtIovSSMr8GU8Ug2d78uxZGw+KVnGwcNGWHUWuG2Ti0dpj/uD4MMYvCGGyMYppBMxgzCDMsmYYjUGsWQ482yv9heofq8/ALlCE4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by DM3PPFBD8703CAB.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 7 Oct
 2026 00:00:50 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::d1ce:85e9:74e4:3120%8]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 00:00:50 +0000
Message-ID: <55388f95-80e5-4b44-a939-5b1ec16f8432@oracle.com>
Date: Tue, 6 Oct 2026 19:00:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libiscsi: validate the ITT reflected in a Reject
 PDU
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, lduncan@suse.com,
        cleech@redhat.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>
References: <20260803104149.2114414-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260803104149.2114414-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:610:e7::14) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|DM3PPFBD8703CAB:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dbb80b1-c64c-48a7-a6df-08df24060be5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|10067099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	16osJTYEZQvSzUNowI1gBBG7IQCWblYO7Vakd/r218y42PIPN74VkJlChT6Kkez6uLL+qlcryhPfhvEcHrliWkNMQWq9o1ru6DdTFwL992vIs4tw+biUbANZ8Fe/wLl2WHQGtZ2+W6gf6vci/d3qj/vlsQPNlaCx9Vxbdn5Du1Y8CBKBGIZ1DDWPnc5uOlWL6EmSvSuo9D2IlxMyo3NLDB64clfcZ2e4LI5IuGNebL5C0R1LygLQC19mEa/GHwd9QpmdJvcyXJVVjILkhLXfNDkE38dbriO4Ont7SVUN5CBcZGS25J4tOHmGuF/+/tybuC8fzGYK9YqDJ3eFzPxFzCzF+i4M//3QRwIlJCADOqF8v1psumzo/cuogR8HNkMCxgnD7pVUQppDTOXT4mixgzo7ARpjXs3h8rqQC1nLHHRGITMs+K3E1bD288nK8V3y7xdyY8yLrbCcg3BEZ9Kde0kqlT6l7IfyLaf/e0n59GHLQOt5MhFWxvZhL7BAjSPLj7vr3Ee4/qoH6vC35fxSJqtu1daG7ulyFaAPuae+PFe11r7bCQaXgH/SPQ6Sc0rqmE2I0vKdNHDxMOcqsa1L6cSqz0oRH/12RGLz0CDt5IDwCqopvn/Z8Iicg/6a2frImPrNCzUDGdZaiFE/HriighdZ+r/ybRSfAu2pg3j24KE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(10067099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWFxUVFtbjNxVVZUQjRmcXpmWTJ1NHJ6M0R0aGcvYVVXOFZSdDFaY3RiTXpy?=
 =?utf-8?B?b0tTcmxHWTJWNWxyT3c1L093dCtZVld5OUdlcHk3YUYxOFllWTZBS1RNcGc4?=
 =?utf-8?B?TG9zZmM2TkFFMEFrOTlVVXlyOXlCSmZ4MHYvbDl3eENOWjByUjVKS0tqeUI0?=
 =?utf-8?B?bnhCM3ZTY1IyelBpRTF4bDJKTGlBc0IvZnNrbmNta1k0YjhmWGsrcnhFUEQ3?=
 =?utf-8?B?WnU5N3BvR3M3U0lWRnB2ei9vUlV6VndvMlF5SmQ4ckZiNVB4TjdLSkZmbUJH?=
 =?utf-8?B?b1pxUm1ZRmRnd2pkTWFLYVhpaFpJUGVxM05pMTZUZzVDTFl3QmY0Qk9DTVpq?=
 =?utf-8?B?MHU5U2d1eGZQYkNsdnJna1BjUm81cWJiVUZnYXhZL3orTWZ6QlBjc0dwc29Q?=
 =?utf-8?B?MW02azdJOVdqb01hR2h4bHhaUnNIRnZIS0FnMklUUmtDQWY5bHhLS3J6WGxr?=
 =?utf-8?B?NDZza0paZnFFZXh2eTR5cFVPOGFmaTl2QXhvdUNGSWplR3RrRHkra3B2MFE4?=
 =?utf-8?B?NnpkSTRiVitSdnJhOHpEZlFjM0Jmd05jaUp5ZFZnc3EzanJ5cWp3L2grYVhw?=
 =?utf-8?B?eGppWTZjWVZPYWdPZ0c1ZWNlMDJCU2poZ3E2RDd1TkQ3RWhoK3NaNzE0aVdM?=
 =?utf-8?B?VmFmTmVyeWlkQnQ0bjBWVHJuZlhGMUI2NFMvb3V0SUR4K2dOSkhlMlJkZGpI?=
 =?utf-8?B?aUFVdG1oa2twc0pJK3ZPSlJNU1kxYjlUVTlvTVYwRFRNZ3AzVDl1cGJFb1o0?=
 =?utf-8?B?NTNBb2lHM3lqTGZhcGhNT0pFa05YSUpPSWYybCtRVjJRVzV3UVdpMlVsQkhl?=
 =?utf-8?B?RXgwOTBoWWs4akRXeHhxZ2lvbnd1NElZRytpRzNKcVJ2M3NkcjVER3Zibk9s?=
 =?utf-8?B?dVp1VU95TktnbVlxOExnc3NuVCtiU3NlcWphWlhaT011eFNYWHJmUnNleEU0?=
 =?utf-8?B?Vm40dWsvV1RTVEZNWkowMHMvbWpoTndmR0N5aDYrZ216YXNtN1hRbExYVnFX?=
 =?utf-8?B?aVhMK3gycnE0dENsTVhIMDRzWDFQc09WakhETlc1dis1Vi9uSlNFd2hXRFNq?=
 =?utf-8?B?QlZwajJIOU5WUWIvYU5jK3VRWG5Sb05qc2JOQ1VVa2xTOXRZYng4VXhzR0tk?=
 =?utf-8?B?Vnp1anJNbWhINUsySHIxQWFLNE5mSE5Eall0cDNPNHUyYUltSXkvcWY2Z0Fl?=
 =?utf-8?B?QUlNa1lPTGIrNTJDT0RUTFA0R1RNdTZuYndMUVlmUFpxNnMycnp0M1EyVjVK?=
 =?utf-8?B?NmFNOXB2TzRZdHZ2OHpSSnhVYnVxVmNpYTRjSExBMEpmT29RdFM5TWladkN2?=
 =?utf-8?B?V1kxTWRsMFNYMXFNWkRHYWZ4cHRYWXoxaldvM2hWbjJtSkc2ZVpSdnRFU0Zq?=
 =?utf-8?B?d1FqcEkyaEF1YzlaZWdHN0p5TVhyeGExcG9MM2ZjUU9lM0x3T3Rjc2lGWDNK?=
 =?utf-8?B?eDZ0blZOVENMaVNpaWZLSXlHd2NqaTEvdHdGNzVLeERGVjgzTjM2eXcrWlNx?=
 =?utf-8?B?UEltWFY2OVB4SmEwdnFJVy9qK1J5Y2ltT3c3aXQrTFRpeUwvWlJpQ2wydXFk?=
 =?utf-8?B?MHlaVWVyTEgwV3RhSzN1OXIxWDFCWDVPMVBmUDlzZ0lJdytZeDN2ZHpQcXVn?=
 =?utf-8?B?Mlc1eDk5ajdJdVNRUWFXY0tTbWJHWnF2ZEZmTERzOHpwd25VZXZ5RGRjSU96?=
 =?utf-8?B?RTNkbE0xbk5zdk9YOGF3am1aVG92SHU4T2djQ3Nsa1hOQzFkbWVHVm53d0Fs?=
 =?utf-8?B?cVZjNUJtMjZIT1N0bXZ0R00xZyttU1FhVjR2UHJOY2ZHSm1ua2ZnV3lLeGVz?=
 =?utf-8?B?c1hNNStwaS9iQUNBaS9YaFpYYWF6U0JVYTNvdzRWZXlWYXV5ZkJRSzIwcUtW?=
 =?utf-8?B?RDZuVUg3bXl3R1FRNXBiTDdYZWNKZFo3RTNxMG02eFYrc0MwUDYxTmhoRFVB?=
 =?utf-8?B?TnVZa2NDdVE5ZmErWU9CdmtLSkFLTEpKYy9kR0dXa2Z0by9rdmN0RC8wK21h?=
 =?utf-8?B?eEdnR0Z0RmlmVHNic0RLcElrL0dhZWloMVBnYmc0b1VnTXZLN2hDdUExSWJ6?=
 =?utf-8?B?c0lTNVh0WHp6eUxodlp0T0xPVUdtMXZHeXNxWFcxbXZITkxpN2RWNkRKUVhH?=
 =?utf-8?B?Umc3WExSWWZzNFV3T0g4N2t6OUU2Y1NKSTExOEV6K2dDL0lua1crSnZ6cWdY?=
 =?utf-8?B?L01EUDk4U0NtTTVlTzh2OWVJcW03N09zZnZqc2JPRUpDcXhJMlpvajZabEFr?=
 =?utf-8?B?b29iMG1ZVkY4aVk1cXh5SVM4Njdzb0U2Q3JxeFBOdWxFTFdrdWp6VTh0YlI5?=
 =?utf-8?B?S3BuL29iZks0Nkh6bkxCaWYzdFVKNkcwYXRRcEpIN1NjdkpoRWlGWE5LcmpT?=
 =?utf-8?Q?3hdH7pVPax4SzDfI=3D?=
X-Exchange-RoutingPolicyChecked:
	xgaaSpqgcqCS/Y4phWSOOiz6Lcir+n2TIUCZfYIsWCA08HMeI/8sPuJ3aAlnAtWFootusY64vRkl+Ckm8tHMY14SZ2fQJUhydVNp793LYd1CtRjfFXhH/pzHbjSS4F9fI27nJp1L0iSdoeM6pE1guyQpw9maomMUEm3FXoMkqM/5TNVVgRxrrhRert3eEUlvQ+wpT45ZL5pIeLUFFL2L0f5ZA9m7PAFsULURl019yVllXogSDuY7fYk1OiJDKgLGthj0s8W8yrk39KC2XxnzCKLtdOjVfeVwq4DDQWSKp1VuKuGnKLWD4MYsv8oeMiys+P7FQkhe6Cz0rE6s9A1p0A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Gr4KKEkI4xs+HOEmCm3b0GHp0irf75lOHBQxiHY+fUa4hQBogpvpDLwgYu8+UCU1KXB5fS/XILMEqPVXyHafHUXSz42PUpA8WSaAR3NDiTzisum4iD7I7QMXh7M59HH3v8ujCYY/tsaQyFnjrW0Xjhdh92v+57MdvuHRIuFJldgZ/A+XFsCyY1ID8T7f9Df2uap9cRscLkTNFuHyTehjUDRUl3NHz0l4hd75TqMwhFe9eILBEPETn/WEzBxJV78/9SVKonGLE2ZigxUfM+U1rJi6QS/YpK34lsoybNv/QBhkGYYNcnF3g9sl31g6BerstmOrwVzc/S2tKYlCaSS1jeC2k20k/cdpC/sc8KCFlHEizZFm7ilYOj3VZ2q/9z7ltzcgoGS5rN4AclN13bxo1NjQ3UPKSjUEy7HA4X1iFoAWPlWzS/A7BC7ZsNA6Xzex/289EhIZD6ixnwWqtQZyAFmOC9kMU/fS0alMp2En+58uPyYifkKFOckUUQKeqb8R5F1nnDoNlLGJhDEW7JpkiniV1kuzCFQrGcjCu8TlTM/gBr/8U0urmvWtea05gw55XWkrnPpR0vGt/CGZ+PPPCRtek1s+RYEYAX/XlGnFYvc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbb80b1-c64c-48a7-a6df-08df24060be5
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 00:00:49.9347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulXC71JnFA8u+yl4JgzLu1WQFsjULdODZXDwowhEfr6N3Smjhcp2pLCK2n1E7IrZgJthf8lI4uaPW01AaR+hTaGRne03eYrd5opuQYPW74c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBD8703CAB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=834 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610060095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA5NSBTYWx0ZWRfX7rj+Xu7UoD+x
 vIjPhUAouAqmXbU3z4QrMIYZPBZu1lor3QhTnkgaE/Sh5Ue7Bz+hCM40sJ0n/PopwiDxakSwqaN
 fUrZ/O/Dsw/ptqrFTabvzwmKrdvXqF2TGb96bS5QqeBl0hIy4Jj1KxLG11TAF4ADDXHbsj7zaOy
 gj/vavFWRpl+0/flXgSFqPjGV2rkI3qV9J4Aoo61VeEetXVnNVQfGmQb8mkpYHE5cQ7PFN621Y7
 at753c/OjuxB6+pgYLdLRn5GYonu5R1V5FNTebc/PnxerYtSsM+BP10W8MembsvJsCAuTxQAt8d
 s9zDZD4PTwa3x8izK5qgW8dV6HH3EPYZK88ZMdw4SamrdFaeF1ZYWRPQv162BMTBRhK0lrYHDbn
 orD2S+4fYEq+lDatsS2vuFwup495bzqbgI139+jJhsA4qxw5iCUuwyYlyL/UIEuBH+CBbCzoHQx
 iTxYIk4Hry5xghsBADQ==
X-Authority-Analysis: v=2.4 cv=QMD91QLL c=1 sm=1 tr=0 ts=6ac58bb6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=CCnDJwmaqiJk0TO-yoMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: JNo0a0djmLUNT92_QXz3TVqOrQ05dEB-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA5NSBTYWx0ZWRfXxTpZd/eH03pK
 EN6miOqHofOfMGAdbdIeaFxbc/P/vva7OVmWVM7Rqq8V8XceEBRJBhudjbwPRaxZleWldUgSGLz
 qe+1nDk0zE6l1sX+S2E/y2ATzr36xaHkL7/qgslsM139RYtIcigw
X-Proofpoint-GUID: JNo0a0djmLUNT92_QXz3TVqOrQ05dEB-

On 8/3/26 5:41 AM, Yehyeong Lee wrote:
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 160f02f2f51d..d881f4dc47b4 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1147,8 +1147,11 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  			 * Our nop as ping got dropped. We know the target
>  			 * and transport are ok so just clean up
>  			 */
> -			task = iscsi_itt_to_task(conn, rejected_pdu.itt);
> -			if (!task) {
> +			task = NULL;


Just do this a couple lines before the comment when we declare the variable.


> +			if (!iscsi_verify_itt(conn, rejected_pdu.itt))
> +				task = iscsi_itt_to_task(conn, rejected_pdu.itt);
> +			if (!task || task->state == ISCSI_TASK_FREE ||
> +			    task->sc) {
>  				iscsi_conn_printk(KERN_ERR, conn,
>  						 "Invalid pdu reject. Could "
>  						 "not lookup rejected task.\n");
> -- 
> 2.43.0
> 

