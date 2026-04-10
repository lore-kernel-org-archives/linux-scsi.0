Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF3E34EF0E;
	Fri, 10 Apr 2026 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775814597; cv=fail; b=M5v3Qvr3DxhD3b5ryMM2j8tNeXKWqdEMRn2OwXJxBuBg9orOu4RBf9TK605/EyePav8PUGt+MlzqNbkKjb3JQo6Jf4qfCKFCBFaUPfFk9uelAP4W8DCs2xO5PUdZVx1vakXXqjIuHt6B4hZGGnJK2m8lU85B04YQOvitv+NjlaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775814597; c=relaxed/simple;
	bh=TNzv9iQmoMv8f/0t6K8loxg3CFpT3Wrv3WpIaVGQmDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=trsDf8sgH40SEozewrpaPJ3O1AYyxn2bvDGI6gOF1+pj8Rkm6X+PvvPnp6+a1b5yK5r87bFlbVGU5UxFo/1XHgQ2C+WJbjvIH9DZWjzQ0xnK+VYs/+5P75c+Qw1JlE040Uw6yi8/btOf0rrLtrvSg8vI7WFQpU5Fi/WeCgrI/Q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G3k8S06v; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZhWIMoMa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G3k8S06v";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZhWIMoMa"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A911ce3133271;
	Fri, 10 Apr 2026 09:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0hkHzJZtkTQ1GMHcImuHSp1Ls7slziGMZIga0SRxfSI=; b=
	G3k8S06vMZjmQ53B/dhgVo1bv8eNH50Ayl9JG+rJfniByPSeRcC0xr7z0v6jDJ1T
	yrrQyoRbz36GrHNMfvAYMpC+8E/T2MbrKLB+NwiYLfUVoLPsx4jYPeD3bdn/vgOx
	FhK/6nxreX/3fqH11vtR+52VpYlHAIZC7bFjagGltNnwazSBXMbOLHleFLY6rCnA
	1l84swoeYuBFe7HUL1MXYSiTdAcvCbBy4twlSlsIoiw3F32RgLFfiUAJ8ZdFC5ay
	FE5A9m2ZK4rDLTTQTzODLhLBBxZdG93HN1QPavtnW6s0522VruWj8mUNTLQVIxlb
	AblkOCAvp8yIUd6Fqx0W1Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqbs9s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 09:49:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 63A77Ov6005305;
	Fri, 10 Apr 2026 09:49:30 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxsyvdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 09:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wqKf+euCkzPtjWfA36Vueo/YhYRxy4kR+3BDjmy8APC1uH95OQ6td4O4FzlI9RcJBBi4UZ1S7zcoBJgmfr0EKFuMVMFT4EW8nUXTNM0U2o8NpQZwtgu7DvOYSN03B21yIV/YN3O8wdKEVE2BivX0K/qNDH3vtFNLJy2ZtQt2yN5Ou4faPo6zwaVtmWl404MfzI5G21XFpzLqgGbL01EK2SfxCHogp8BfgGD0sQckj1HeD5/IjvKcSS24ySt2OuOChvQ1e4dgEr/sdqGFrNdF4T32+I3Rx0KphLCZXYh1RfbNWVQBqmiQ7RM+uTc8Nug+UNjl1W6M68VpHwKDcptDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hkHzJZtkTQ1GMHcImuHSp1Ls7slziGMZIga0SRxfSI=;
 b=b19SuoXtdBdwR/uHTt3GXLy/zb9kd8+YzvxsuCkT6t9xLVXwkGciBDYE381Jw7+j436Z8rXi+t1SuQFbuLarJUFKCWWTQNFr43EJAhSdOpkEevU5Bq9+5mnqUw+n9XqBD+spf1P7Z3LlL9gkGsdOcHE5MsLXDfWPLPhNQjcejn3h7tUqUs0PfLBBnR2m401Kox/1OC/7fldGINUhFmfFnJjF89xOE/1A7mL3FXg2IKeZlDUjSwcuy1hYAjlEe8BYUlsBQCC6hPUbqRKzYCDp4/Gn7885y63nMf9HVCh1/3F07mqf13kx3IGDpaqFn+aqDdeEeIXUVOKLHa60JtgcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hkHzJZtkTQ1GMHcImuHSp1Ls7slziGMZIga0SRxfSI=;
 b=ZhWIMoMar1PNDteTYeAxKARLgHdI2F+uwPDBWbPVwnTResBMem12BSOqETHg+yeE8PBtgPaLrPV9AQHHkrUYbtKH89zc65fAD+2jdSd5Y+HAkgSox9jefCIYE3HZ4FrYIP+mWZbUZA0DBiO6foQqoCzwUXvOjfvMBvne9527tM4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA3PR10MB8468.namprd10.prod.outlook.com
 (2603:10b6:208:583::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Fri, 10 Apr
 2026 09:49:27 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Fri, 10 Apr 2026
 09:49:26 +0000
Message-ID: <8d9c2ee9-0c2b-4c64-badc-b5b0fc1eaf67@oracle.com>
Date: Fri, 10 Apr 2026 10:49:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: Nilay Shroff <nilay@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
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
 <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
 <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
 <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
 <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
 <b77d5eab-d50f-4102-8bfb-f907cf39ca56@oracle.com>
 <a1d72045-7b0e-4354-8365-f21f03765659@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a1d72045-7b0e-4354-8365-f21f03765659@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0285.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA3PR10MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f9ba72-0911-4504-4d0c-08de96e67402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	FsAgr7HMKrlwaScmcjA5kZNH1NBDUo6kdNuqWtWRN/OygLsa0It4LazxM6uDx9gHkZ7lIVQpKFtpa7EKfQqL1S+V/s52mON1TJhzcz3qDTRPwvqd5a27emqQoqwDuMZRQjoCutq8kqnU18Cae6mPbVp/laFriE+UV7ml9zEiE5LLZeTr183sO/TbjlL++phckyjSedrQLGrqwfpGLHoO3T4qrfUCsg7J7oMtXV2x5zDLrtGUua12ZMLhUFcmtud9AVZsqPYbC2yLsFyyqoTnEx285ETdF2U87FVXGjTnT6dRiaOJbCUat96cW1EomNkehoPshxCQCRkzYhgohyORRoRmkk2vsRxVqWoagWZfBFoXgXDAcWKubKSm0AZORId0jQODl7mOKddviC9YhpZbWNMZPdM/rRcsCQdS6WMitgqSyp5BNvUsrOjiA2ozxsULAgTOiVZW5XDRRyeNAo+OfHcpMdybQNXUdJ831UND8Tg6r+Qryz5gLrdO7y1Dn1J/bz05grcPwwPUAe8WMyxurMciG034IFpryibM9CXFFADns1UkuDXmjNjbG5aCf10Et3GwpqRsC6/LfSE8o2NPTgYAqflWQzHpxvoyaOPB5pA0L/b2xHYUcvNPFEoPZniQbki1ye7/xgTCDLpgmoaac/Z3TnGJEqrLqYdDsdZ3mcVdfgiuRsHzuhcXwA31+0imx2ukQhkqr6cTK8Emb6iEiw5wDRafNnSx5k1oZjE5jCo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHZnN0E1VTZGRFNtNTFaUjJOYmsvaFZvWVRUZ25xeUYvWW9kUTI0RHlFczhG?=
 =?utf-8?B?Rzh5R0VSSW1BMHpxUVFYN3RuMDFzTnhzbWpHazNMalBiOU9iak0wYisrUVFS?=
 =?utf-8?B?VER4UFVFYUo3N3pOVTNTVTdBUjMvQ3FFbEdrbGl0ZzhXa094Umt6dXZXVllX?=
 =?utf-8?B?Zk1tSzJaRnpLVC9FZWpLaC9ZZDdWTEVyTm1vQjZzZUVSMk5OejR3ZnV1VWNx?=
 =?utf-8?B?ZjVJbko5YldjaXprSzV3aWlERGJiWnVFeGZJTklCaWVFU2oyRXJmbjhXeVNN?=
 =?utf-8?B?SnVjTkUxalZvcEtTdVJBMW0zVktsM0RlTm5ta3haeG1pNi9NUFJhVmdDcmJM?=
 =?utf-8?B?UkYzS1FuWWJPS3hHUEsvZ0thZXVQUmx1dEFvdGhIUHZubE9GbENySTZpamZO?=
 =?utf-8?B?d0hPaUNxUWJSbGsyd1pRSmJXSlcrVGJoMWIwVnA4Y09VSTA5S1lZUTdxTnRF?=
 =?utf-8?B?YnQxMVNKQnUvTjA4Vzd3MmpNMFpCaGZDY2tMeURpNjBBTVpWVVRldi83SmdZ?=
 =?utf-8?B?ZWQrajdDN3BkRGd4OFpmRGRwWkdGNzBGN201OXZTSUE2czY3ZDRnUk5yRDNr?=
 =?utf-8?B?TzlTOXJLYXV6VmhEc1NzTXZFb2pJL2c0TFR5NFppWGx2VlkrVHNaN25sOHpI?=
 =?utf-8?B?dUdjOEgweUM0WHFuY3dtcGQvVWx4azJxelpIYVhneUthdjc3VEd0cUVKNjla?=
 =?utf-8?B?a3VKbUZ0T1JxWjBzMkw2cUtEZjdPd29TZE9jS2t3UWNEUEI5TUVxdElWaFI3?=
 =?utf-8?B?ckUvOHNlWlBKS0owbHNGeXJnZzk5MlpYS1NRSERHOStkUDJ4YTlwWFhKUTVM?=
 =?utf-8?B?cmJtKzJZdTk4NkYzTzFTMHlHa1c2ejRrQmlud3ZZUStCUjFldlJhYmoxdUZw?=
 =?utf-8?B?OXFmYUpEeXRvMU9pL1YrWGRaT1MvZDJZRTAyM0JaekdEWWtxQkxDQkMrZGt1?=
 =?utf-8?B?WC9hQVQrNTdlSGhwZTJEN09MbFhZZ2hhSS9zdDJiZzkzZzB1VGJ1blVBSXVt?=
 =?utf-8?B?bW1POTV4SjAwM2JBUjFheGc4N3VIcHpnVUJHVFdiOXFqQmdpeVVuZlR6SjNN?=
 =?utf-8?B?TkxQSWx0ZGFFMW4xbVY1WDQ0ZU1QVlFaMjBTc281QW5pRXlxcFkxV1NkWWV6?=
 =?utf-8?B?bEY4cGFlQnZwREJ4RW1ZV0lSeDdvWmRMUTlwNDdPa1JObU5GSkMzQ05FWElM?=
 =?utf-8?B?clp0eVptNDdWZXpodWxNQUhpK0pOeFMyVjMxdmY1SzVsekkwQnBobXNvWjdD?=
 =?utf-8?B?elNSRWRmMGFBVG1XcEV3cHNobjdiRUdKTUx5dUgzSGZQeElLbXlTdzUwOVhB?=
 =?utf-8?B?eittNDFkRlBCdDBKYVlhM2ZLa21GK1pVbXZPNGgzcUU3L21yUHhWdE94VkVm?=
 =?utf-8?B?dDBFa1ZkcWxmK1ZPQlJKTkJYTlhCZ3lTTThuY1VaZ05nTSs1cnBOTDBRcHVm?=
 =?utf-8?B?RElWR3hMRTFrclNOWVdRZFlaRGZtUVR0dDhTc0JzV09HVmpYQ1BIWmpkU2Y4?=
 =?utf-8?B?N1BPMnZtejFjYUZjSGE0UWNvWWFCQVZhZ0l2KzEzVk1kL2JwQVY2SXpFdFo5?=
 =?utf-8?B?OHRMdnBTVS9Oc1ZXV3UydEdPanM1WlJBc2ZJTkhyaU9tcVBhWHVPdjhPbGg0?=
 =?utf-8?B?cDdYZ05SVEdLMVZMSzlPNWVsaVkvamd1cVpiN0J0QzR2bVJXY2xmZnlIMkFP?=
 =?utf-8?B?UHliRmFLNkVNbFpiLzZONkllaU5ZYXhIU3ZGMmJWRTVzODVwMmlVK0R1UEZO?=
 =?utf-8?B?SW8zR3ExTFlrLzI3bElzRlpsVE1KTWtNZmNYazdVUXRhakRtNGpoeGNBbWNX?=
 =?utf-8?B?dFo0ZEdJdE1mRHA5ejhFZzU1UDhJYjNWOE5WWUFhOFBLOEEzTDdhN3VwVHEx?=
 =?utf-8?B?QU1oS0t6MFFmQm9jOTR5d1pNTEJSS1ZmSFN1eG9xODNyVVFOZldodkVmeEkr?=
 =?utf-8?B?dkJwRU1oeWlDTXF4Y2I0ZTQ3dUtMVWV3dVdLM2M3QmlCQ2EzK3VVeWVYeUMw?=
 =?utf-8?B?dmdLQnYxNkVXNmN1UGhxTFE2MkxiYTQwZHQ5Z0R6NXJkaFprY2dqaUtYcVpZ?=
 =?utf-8?B?WlZEWGZjZDZoOURrWi9CTnovY0RKTmg1T05QOGVPcUg1NjJHWTJGUVczMFAy?=
 =?utf-8?B?eGZKcFhoZ09yOTE5TS82M1Y1ZVJrQldIcENVcG9hTnVzV29YZmx0VUFBcFJ5?=
 =?utf-8?B?OWF1NXpYdnUxeGFBUmtrSlRaUzVpS3hndEJhTmpNT2FHQjA3b2Z6b3FMOVRW?=
 =?utf-8?B?TWdPblJpNDlyOXh5SlZjbFhsZ2l3VjRMOFltN2pBNnhXWVRseldYMURXdE9p?=
 =?utf-8?B?RGZKQzc0K3ZTNDMwUHM0MDBRcUM4SUN2bC9UeS93VXlad3RNSHVxZz09?=
X-Exchange-RoutingPolicyChecked:
	pFEzzWZeigU3uZDWK/wWfEYm3faeU9V3pIcCIEeUmlh6NxiZ+Kc7nR6FVcOxX2yNspWCQXzc4uU/sL2ppxJoFFqi+LRI1jOUKoBrIWiO2QYQZU33/nDKIUXLYbGoZThz+WWjGlJ1x+Hc4VWv8s8PMJb9h6JbUKxUXGELD2Ag6OqElrY742Ma9IRnwRM6ha1ZVKbneuyhpnG6oLfU+AwNxn5noZYvl0XKI1k5+HPA2G4TX6TXLJvQUzduxC4zUAW3x33U44+V+AuCzodZAsJcbXGvX4tYRkVJ6PI9QmrrXoxL6UGcveGqYnt3bS7MDtmPw5GHVdgXDmWbfXrgdvTrNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sO7AiH3fBYbK44e/xR2AtnP8ALUc8m54QqDYxWYMn6SHLNyj/x3tvv6InxHIZT52E0otnRga8GiAke2QyY2sqK27Tomnk8siDOdF7xM3WKWTR9v1dLv8M3h0S5vHUK4oFxdkbgAwJIsJbf7kdWG232TYlC97z9Z5EIzs7YEjVJF2iaygEwEnaHOfgCJRdQxseOVPTahP/a8pmA6GqmRRlPQTXjeQvoFuwxdBCKHCs+5TxW5g1i4cOfxWXAMm2Ld7YxKTy+yC03EFRYUGHDoegTf/DZz7Yw5eV8GYwEI0PJkx3YqMUPz1ZLe70EFTVTdQRaNSrI0haap2uLG/KtoNUCKGQqfSONGaovZhNPPZWKhlIj8HZ5Co7EewW8Aaw/ZQbTpVHHyKKJz3Z0nBdO1nOGTJLs7FVImbzGPYVZT7NSy5PgZqgwBa3byNoihHVpI7pHQvzS7mrLtQCYHfq2lXvIBtb1E3yeJelDvl3AJLYyy81Af7MLesr4ekraCt4a8orU2tcOUajRgjpm+hcAwzX84zNbGytcamY6qveqy1a+sOOUIBU7+ZcwGRK+nfAfCPczFjGsJKDfUBNYXLM+YSg2qCA5bqhuNU48DP8G5JxaY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f9ba72-0911-4504-4d0c-08de96e67402
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 09:49:26.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5k+Kb4cx4/zTRlHcizpq0wSk3HlHdpiLJPBOoPFDpR1PLPLF1H4ij7zWWTORuw7ESLjariCV/3rPgF5q46nC2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604100091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDA5MSBTYWx0ZWRfXzWJEYHUls7mp
 148/qFnZD037kX83AZggtWg8RaJDnX01f2WFKzZZOdFELm3qvHEF+wGbZg6Gsipn0Wp7ES9/lmv
 8V7AlB2DYMRp+KgOhLFlv7fm+AtckJVINofJfGe6kFs2CuKE+xx7rHQlXvO1UW3UuZfp+0K1aIs
 yNtmxgra92rYvXuMwyw+Ee5Eqh/LbWGpPqMp8iqxBhD5T3uHfXClY64hY/CMj3QbPpKoKOkmCn+
 Qa3ODQkKXIOOAQy5VGeQNmZdPfHF6Bnc6ENOuKYgj72YGS9qn8sAO9hivQWwRzOidMC8GzxRGB7
 GQgCFCsin84b3U+fGGQqtBW/Aqeq41sNhqgZ72Ud0qMEzL4VrQ0wj2fSGAT/BhPjbjLw+vnTaLV
 nKj+ye/0f1hbgiy294cew87biNrl7irkWdOCmLhCFXi3eA3rDUc21H9PlsblkQQXhuGBmR54xvs
 xmZTabT2F116rDA2lQQ==
X-Proofpoint-ORIG-GUID: s00LY8kcuYs-g_5y-aaWg7alIZqSAGny
X-Proofpoint-GUID: s00LY8kcuYs-g_5y-aaWg7alIZqSAGny
X-Authority-Analysis: v=2.4 cv=KO1qylFo c=1 sm=1 tr=0 ts=69d8c7ab cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=U3QVUDT_743DxyKmlYUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 10/04/2026 10:09, Nilay Shroff wrote:
>>> It seems there may be a race here if we attempt to write to $ns before
>>> the reconnect has completed in _delayed_nvme_reconnect_ctrl.
>>>
>>> If the intention is simply to verify that the controller reconnect 
>>> occurs
>>> within the delayed removal window and test pwrite,
>>
>> Not exactly. I want to verify that if I write between the disconnect 
>> and the reconnect, then we write succeeds.
> 
> Okay, got it — I think I misunderstood the intention earlier.
> 
> So the goal here is to verify that if a write is issued during the
> delayed removal window is in progress (i.e., when there is temporarily
> no active path), the write should be queued. Once the reconnect succeeds,
> the queued write should then be unblocked and sent to the target.

Yeah, that's it. Otherwise, the write will be queued but then eventually 
fail (for no reconnect).

> 
> If this understanding is correct, then this looks like a good test
> to me.
thanks

About the module refcounting, as I mentioned earlier it's hard to test 
this effectively. We could use lsmod to check refcount on nvme ko during 
the delayed removal window and ensure that it was incremented. I'm not 
sure if it is robust and whether the complexity is worth it.

Cheers,
John
