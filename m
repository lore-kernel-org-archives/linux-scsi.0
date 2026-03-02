Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBBC34FF58;
	Mon,  2 Mar 2026 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448342; cv=fail; b=IazCCERzpV3LCga6Bibc4AqVq6ywlIPKZKpjfuKQY4d765sL0xZ7V0fd5d2XCWGR1erhoXbv4JwC/+sNhxn8AmGcGHNrPdZD5Pn80sUwsWSMIADrzTwa2IZkHme3jVI/1vfLi0LG5EDvKW+7Hetc/6FaX8haQbNFMi7BdPVg7dQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448342; c=relaxed/simple;
	bh=WQGsbCTvu+rQxAUVjlvkkhj1DNQ7Ep9sngDWjOX7zF0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AItgcXTtey71B6mKiakl3VYY31lPHnui9Q+b1YYq5tskTtozY1/UBBwLhl/FTW2HPho5ZxkgV7ODCi+i7IabbPT3SFX2bClzNJReve4bRi8PjUPygld74gJ13UCSm77/XE1e8sMzB4fBdaCk7wg8aB5oOKf7xlZxvI3PNjUurPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rtEePaOg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BiqYWXwj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rtEePaOg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BiqYWXwj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ABIRU1959338;
	Mon, 2 Mar 2026 10:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T2uaKcQCKdqf9IeicYWlKM61c2fFGyR01CiyNm9fTIw=; b=
	rtEePaOgnvC622GsYCXmpxPF+tb6CJDq3fengXdRrayjmV5WLY60dYuJvxO5HNfH
	s0KO9X++SJl/vuEt0uOD8L5/g/0qq+Kblx1wjC7vKvwcUHQ/0KhCI9PyPZZ+Ic0M
	ZnBqowg2AfSa/Mr6vqSNspkynbP9DjRKDQcOSIhHJOiVMKRmVkrldAybN+uSnZG/
	RwBVi5sUNoWCsg/yC2xA2LBP8isrvo7ti5V+GAOEOPIvZugApyTctPbO7Volpwr1
	2Cg2DnBXcuwulVzMresX+ZfCCNSbWhEjbWP8yWR3ejGtdPoUG+FAnWA2IlfFdVQg
	uH2593cJ7uvleB/9pu6/xw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn8jkg1tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:45:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6228dVCN023181;
	Mon, 2 Mar 2026 10:45:16 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd2ah3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:45:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ro4/PuHv8YrDVf6vVwdWJFL1EXfmHr6tNHavLt78yud0nVHyeXNoPCLsBfwvc+EIsu+Ze44bkNbDHNxdOnmJDMjUxk5MoPYexf4fPbx/+97SMAFLHXoydMuTJzhObkxdkWkW4Y4qt+I9+ESDKIQl/30I4lCPbqI6WZyse5yNF7MatT9HXHkK1dItgN8la12SsqR0VEHnULJ0Z9XHFT0G0MmMtQjcruMSqWpGWimvcfeCgxVxzc1c0qy+9woYubGb9YQawUL2FLLkrD+tikuTWL0eyVdfXs9fxuWqo5yM83EYWzbDwe6EpI93rwB/xbeQ52PsH7Kw/yyPTuRG50Zdxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2uaKcQCKdqf9IeicYWlKM61c2fFGyR01CiyNm9fTIw=;
 b=gUyl4qfCOCZceck7jKJIsomYuc4jn1umrnAG3O6G4yYrTtwJh76dIpW/Zty81uxl8nJ2srRJrEaot+nkm5L8P+wvUN+6IdtDO4o0MkkcoJZ0JRUAFd9U2Kj332+l4kGFeCClhA6ErPRDhEo+Jk//L52KoDFUrcFWol9R4vkezgQnQiug+2/FHIDAGycAVFY16+2ni5f1TTsf7ItypfjTtPo7nLpKv8yQg1vNiOsXatJF/nAaeMPF0n0wyArFoLs7iT+RfRkk129SHVZlam6yRB83VIBqkrHTMQ7vYyta9z1hg5Ebik9nalu9NC4IKXxIxdOpk51WWI+VtNE78u6lPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2uaKcQCKdqf9IeicYWlKM61c2fFGyR01CiyNm9fTIw=;
 b=BiqYWXwjJs1y1thIxHtrx1xmtavVYG2CTf5qoWhIwPlcCK83k0G/P8TbnPRefKvLfOh6sbHhkENvNUd1KTzyai0a5FbapCmlCQN6nJLHoeJEPQv+iIkJd6v2hb05F7KEB0FiZAqLf5W6PQXhLXFuJtrur08cuqBusU3gA6s3i7g=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH7PR10MB6276.namprd10.prod.outlook.com
 (2603:10b6:510:210::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 10:45:12 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 10:45:12 +0000
Message-ID: <add7aabf-fa2c-472b-bedb-e8713176c692@oracle.com>
Date: Mon, 2 Mar 2026 10:45:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] libmultipath: Add PR support
To: Benjamin Marzinski <bmarzins@redhat.com>, Keith Busch <kbusch@kernel.org>
Cc: hch@lst.de, sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-10-john.g.garry@oracle.com>
 <aZ8Z7A4uOFfOTDeY@kbusch-mbp> <aaHecneNg9Q8EtiS@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <aaHecneNg9Q8EtiS@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0063.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:59::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH7PR10MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e14fa01-f7bc-4166-508a-08de7848c7c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	TXLN1zv4pcJe7J/h2TjHFaWh2dpzeTXmiUokCLQ0ETU6LnYQM1yNzFeZtazm7/fUeJPeVDxLxcabTezCOimMknPSbU+tbklG6cgVhIhJt+rBX0O9XEZi2nRj/KdcaeaHnz9DzkVN+5F9Azy/XjxjbGC8EHgzAi1zHFrjWJRCVmdIJwh7owH/So9y/reLFLxQmjyWYDObiL3hBXk1lOFr1fIABhIOZcGrTf4faOYzuvdVNABQTEpejn1v9t9f16EVKCtLTVar+CdhPl2CDK4VrtfU6ELtcheEs/28x9NNzyk0EiR1jqBqrLMqHWpPpVOWWlE6O4No0mXigAU0clS2u5Tkcn8D1C2k+BouYqFUZ600Dh69Y5c1tugf4xUG3iszw3gSrKsb6PlZMuqphTWCwj9DRDAnAsT7wB6DARpCmGRohUT9h8NLMlawaBASCQwm0BnfgNzP3SNOsgQOBEDmrIpGzqBOITpr1BnBKpIQRjS2TrlIKPHPIrlOm9B4bX8rU56pbcwFRFhYALjby1ydYtWziBTeL65eGZ1BZrlyzWvrGYtTH+Q3adgyQEBVWLEla5WCsPMtbWAReRvDBQ5HjW6wh6iMP/egsajGycUYneR8yUfAX00JC1UdcOGsKGtfxF/HZ9adq12qsXMkD/6XbZDi4mF+7s1VEwJhppeuPuZPKm++dmvJMCLJgnj0mQIVkN6BEa+Sv0jRPK0KdELG2zNR3GHg0/mD0+iCWjDKAhM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHh3NFFtbVJCSXBGbEhyVWNaeVArTlRLZUxGVFYwbEo3UlZkL25hY3QxTW85?=
 =?utf-8?B?NytrZDR1VHBVeVFMeDJJRGtXalRjeUtRa203VmpETGR6YUtsWDdQaUZtcFhB?=
 =?utf-8?B?MjZRdXozL0UvTmFWZTZTZzRCckhHM2VRTVFCSWhabFEyRXNRTWpIWWFtY0NP?=
 =?utf-8?B?aGhzbGpya3FQNUpRVVNIN3M5djM2dXRLL3R1enBaVnRoRGFNUUZyR3FiR3ND?=
 =?utf-8?B?MzU4R1BQbWZuK0ZwYU9jK3hWNDZ2MlB4WFVvZ0x3R21oWU9TNG5pSmdqZTIz?=
 =?utf-8?B?NVltQ3ZsV0ZQNDBxeEZ1SkZSVmEyaTdqVmM2QmFnTVlVeVVsdWx0cmJCcnNL?=
 =?utf-8?B?dHppRnFHQ0tFeU5UdnRkSmFGcFBnVDNCenQreEpnZFZLcG9xcExYZjFGWllD?=
 =?utf-8?B?TVFTcWpINnRtYWh6UnM4TDRQOEVEdEtaSkc1U3Z4VmZ0YWlSMFdVeVhkQ1FH?=
 =?utf-8?B?dFZHRzlDMjdTQWd3VEFoWDdES2VtODl4c1VIdXlQdnhSVmJLc0JWRHc4cWRR?=
 =?utf-8?B?eDhmOHJtSkZpRjRtL0RyOG45MTVHdkhFQWRoK1hkVFlUVHA5YjFYdC8xOVpY?=
 =?utf-8?B?bXpWbTRvNFV4ZUI1NDNSU0s5Y3dvcEhEdWZtemo3S1gvamc4SGQ1L0E0MU5S?=
 =?utf-8?B?Zm50VmtrY2ZPdVFyTmRWcUpJOGwrOE8zc0xDVkJhdG9DNjJsd1llNTdFcGdT?=
 =?utf-8?B?ZGtKTnpuWi8rZTJzUkRwUVdaaEtiK0pySEZ3U0EvaTJpNXU4d0lmWTNiZWF4?=
 =?utf-8?B?bFQ3ZTdMWnV5VHZJZU1udlRXSmxWci9teW11VHliaWlmYVRoYVFsREtwN2NB?=
 =?utf-8?B?MGZTNzQ0aDFINW5COWRkMlZCMnJ5bHBXSUt6TUYwWnpCWm1ROWNjMklnR2tO?=
 =?utf-8?B?VHE2UFVQS3UrRXYzY2hvUTVKWWoxOU1xNC9LK211aktnZVdWV2JLS1pPdEN4?=
 =?utf-8?B?VHpBYkNRSS9PUVU0dlVxQWVLNjg2Z00yMitja1UyeGdoMi92ZG5OemNnNzZY?=
 =?utf-8?B?dEE5VjJUdzUrVXFHdzZMdVlsS21TWkZKUjNDUTZPc0ZqQ01qdkpORjVyS29i?=
 =?utf-8?B?aVhhaDBjaU5WYlVNSndYMVFqM3JPL3Y0cnZxQldUdllBaFZVSWtTZkhxOWR1?=
 =?utf-8?B?K1NlM210ZnpkVUxDb3ErMDZJckhMak1TNHduZUV3TDNqZEJObkFaOWd0MDZR?=
 =?utf-8?B?c1o5MG5YcFJTN0l1bEhvaU13N2lnaUxKNjZLMWxRbUNSajZZVmJaTUgxM1Mx?=
 =?utf-8?B?VUxKVUx4RmVzcW5VTXB3aGtWOGRLRFo2ZW9PTW5ocGJmRzZENWhYTHJjeVVX?=
 =?utf-8?B?V21ldjk5Q0ZOSFVaaWlmM25HVnZycGRacTNBNkRvME5pV28vaVJ5NmJEajY4?=
 =?utf-8?B?T09zTm1vbndieDlPdDExcVFnYWFjcUprNU8rVmVvdFBtWHVhNTF2YkV2cDBi?=
 =?utf-8?B?Um9LeVJ5UzRPaEgyQzVBWU1uNUJqTFZ6VjlPbjRiRm13YmIzeXJTeGFLejQ0?=
 =?utf-8?B?Z3hlR1k0bnVzQUhvNU5LVTNLUk45dDhVeVVLYnBtOWk4MG5rUVJsRmpxaVJx?=
 =?utf-8?B?WWN2dDQ5VFBXdmtGcy9NZHhWL1d6YktMdWFDdHRGLzgrVnJuNVc0c0Rac1NZ?=
 =?utf-8?B?SHdJdW5wMFhFSnVWclgvU1JSeHRGQTE2SnJ5eGxxeUR1MnBLMVZycDJjWVZO?=
 =?utf-8?B?VFY3QnJYb3c2OVNBVXQ0NnIvYjJkMExGNkNzZTRGUjU1Q0x5N215d29Gdkpi?=
 =?utf-8?B?QlhuRzJIblF5TEJ0VGpyb0p3UmxUS3VrOU1Uajl1L0dUY0hoME44NkVpSW54?=
 =?utf-8?B?bkxId3g1bXlNQTQ2cXpDRTMyTU9zOXBaeStQc2psWXBUcEg3TGpDdGJrMUJ3?=
 =?utf-8?B?SVUyZ0Vvd0llQ0dGL200TVZkaS9CYzZMdFpNQ0pyMG42NlRmNGxjaU1wWUpB?=
 =?utf-8?B?RklwR0JNQzJweFdtUDRjVHRkYnVUMlJaWHNQNTFHRkV2WnRmUWFDZDZ5a1VB?=
 =?utf-8?B?SzV4b1hnd0pRRTZaTmZJZ0tzbWJrK0Q1Y2NMZEs3bkxnNnNrMlRuVGxzNk9D?=
 =?utf-8?B?aHdSUEZJaFpnMXFqaEhZV1gzNzg2QlRMaHVZUkxHdjBudEo5T3NKNEdQV3BF?=
 =?utf-8?B?d0RWQmhML29JRG1INGQ0YklFN3dXY09ZZGh1eWdldDdwUDYzd3dwUUdNRVM3?=
 =?utf-8?B?eVFoYW5CRGpUQUpSQUFmM0NidTFhR29hTXpQbnRVU1VBL1k1VXVQQ1RxMTV1?=
 =?utf-8?B?ZHQ5dEhXZW1ERmNXY1R6aGRYZUxmV2VZMnJ0NUw3aDNHMWdnNURVOFRwaWd6?=
 =?utf-8?B?bzJDbVhHbDI5MWZaYzZ3RXBUYjRWUjBjMmxYbTdiZnhiVDdqNmVXb2h5MXQv?=
 =?utf-8?Q?uW9DhmE8uq8VuyPw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NfQz0+QsHKrVXbrDnmmfcQdepWdRCyxSppeJb9X+ryixt2eyQa/+F70wbxT8Ggag47dGl0vxM6S4+VETfTD9yj2xKESNyFYo745vaTLFs11Pa2hhL+LGeoNWS5bCfENZDlFWja83GhcWqGFa43tJbosxLqvEUlUUCB+0b7B4xlNKc/RJuIhW770ErLeUzuNMWV/7fqr/ogI5W+nH+5sKeNHQMO98ntqezCJDS4AbkFcwY/P5zS1vA05EfAO4P5iLZr7GVaKPu52zZ0GhXd1aY/ZRsP8/1qmBAF7RRR71V804Lc+4mcBL6EZ+TQwQYazBpaCJD/2Si09K+Kbckj8cwL4sE10JClyktIM7KqyO1294PNkqykbJvSY5991PhwVUP9FVwA6rYW6i6+asl7kemBa4voulQRFBqRkoDe4WdcjqpEScJtu+CGZ1yfBMuW59A1yMvTRIlqLRP9PweSPfTeMa9RCKtq4+igTBG5tiL+6Vn5uJvbqix33Eswmi4iw8rfuZVDvQsF678XopJMlO0CbSaRVAQJqEJq4e5SFLTcszwu6DzXb+6715Cnv3G9F7/3jYtdZsBIWGEv3RYobJdA/tRLKsqAX+2G0EooZX0f4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e14fa01-f7bc-4166-508a-08de7848c7c6
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 10:45:12.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o70/IlFnqv0kUQ7PlHClojoZ7lFZ++Fvj3wBY9Kvncn3t4BbI/dkG4+NmWd7HcyR2mvz6RYXxVkVG4+M3PWsog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020088
X-Proofpoint-ORIG-GUID: xTdl51ED4C81BtQWGIcjLHt0FuamjzjS
X-Authority-Analysis: v=2.4 cv=Rdudyltv c=1 sm=1 tr=0 ts=69a56a3d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=IhCKgfWZ24nsi4r4i2IA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12262
X-Proofpoint-GUID: xTdl51ED4C81BtQWGIcjLHt0FuamjzjS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4OSBTYWx0ZWRfX9t3IHraj9j+O
 tvosgDATWXx0ah/loi0bSm5tdjZltkJTqihmSJqihRkHcv36zB7WCF2CdizPoBUwwQcWbUw6uH9
 GwCE7msZfe029tLpylDkyayiRnEIVsuyUlYv2kjEEkyQMyHUb7ry7ReKFOoWAOvzPIAErSrciE6
 jxLh/7fUBlC8svzBU7KEQxF7WIL3lIh+saZ2nmgEqINnHfjE8kgQ3Ja6zBKlEuu4fM1S7xAke2o
 vERWx2RoJvEgjmGssKD8tuuwAqAAN4sFQA3wxi7JtkhmAD2l1YOhmP6kkpcL27HyQ9ZWRipn1rJ
 1wrfsFxOTVHxNsQw54VxdRFjHEqTvSlxtTnWSMH+VR4t13SKcLisKC1ZsvRxS6qQM4iDRecksSx
 E8AS7rdpS4Bj2qHiu2T8AHm2w6Cpm4WBRMe26sIwP7QbBFh7uF/5XbACNy8beMhVL0+jlLvKjqe
 il2YVdL1ShlR3nb2uEN9hOPtgyLvsSC4e0UyVL5c=

On 27/02/2026 18:12, Benjamin Marzinski wrote:
>> Instead of having the lower layer define new mp template functions, why
>> not use the existing pr_ops from mpath_device->disk->fops->pr_ops?
> I don't think that's the right answer. The regular scsi persistent
> reservation functions simply won't work on a multipath device. Even just
> a simple reservation fails.
> 
> For example (with /dev/sda being multipath device 0):
> # echo round-robin > /sys/class/scsi_mpath_device/0/iopolicy
> # blkpr -c register -k 0x1 /dev/sda
> # blkpr -c reserve -k 0x1 -t exclusive-access-reg-only /dev/sda
> # dd if=/dev/sda of=/dev/null iflag=direct count=100
> dd: error reading '/dev/sda': Invalid exchange
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 0.00871312 s, 58.8 kB/s
> 
> Here are the kernel messages:
> [ 3494.660401] sd 7:0:1:0: reservation conflict
> [ 3494.661802] sd 7:0:1:0: [sda:1] tag#768 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> [ 3494.664848] sd 7:0:1:0: [sda:1] tag#768 CDB: Read(10) 28 00 00 00 00 01 00 00 01 00
> [ 3494.667092] reservation conflict error, dev sda:1, sector 1 op 0x0:(READ) flags 0x2800800 phys_seg 1 prio class 2
> 
> If you don't have a multipathed scsi device to try this on, you can run:
> 
> targetcli <<EOF
> /backstores/ramdisk create mptest 1G
> /loopback create naa.5001401111111111
> /loopback create naa.5001402222222222
> /loopback create naa.5001403333333333
> /loopback create naa.5001404444444444
> /loopback/naa.5001401111111111/luns create /backstores/ramdisk/mptest
> /loopback/naa.5001402222222222/luns create /backstores/ramdisk/mptest
> /loopback/naa.5001403333333333/luns create /backstores/ramdisk/mptest
> /loopback/naa.5001404444444444/luns create /backstores/ramdisk/mptest
> EOF
> 
> to create one.
> 
> Handling scsi Persistent Reservations on a multipath device is painful.
> Here is a non-exhaustive list of the problems with trying to make a
> multipath device act like a single scsi device for persistent
> reservation purposes:
> 
> You need to register the key on all the I_T Nexuses. You can't just pick
> a single path. Otherwise, when you set up the reservation, you will only
> be able to do IO on one of the paths. That's what happened above.

ok, thanks for the pointer. This does not sound too difficult to 
implement, but obviously it will require special handling (vs NVMe)

> 
> If an path is down when you do the resevation, you might not be able to
> register the key on that path. You certainly can't do it directly.
> Using the All Target Ports bit (assuming the device supports it) could
> let you extend a reservation from one target port to others, assuming
> your path isn't down because of connection issue on the host side. But
> in general, you have to be able to handle the case where you can't
> register (or unregister) a key on your failed paths. If you don't do
> that (un)registration when the path comes up, before it can get seleted
> for handling IO, you will fail when accessing a path you should be
> allowed allowed to access, or succeed in accessing a path that you are
> should not be allowed to access.

Understood

> 
> The same is true when new paths are discovered. You need to register
> them.
> 
> Except that a preempt can come and remove your registration at any time.
> You can't register the new (or newly active) path if the key has been
> preempted, and this preemption can happen at any moment, even after you
> check if the other paths are still registered. If this isn't handled
> correctly, paths can access storage that they should not be allowed to
> access.

right

> 
> Changing the reservation type (for instance from
> exclusive-access-reg-only to write-exclusive-reg-only) in scsi devices
> is done by preempting the existing reservation. This will remove the
> registered keys from every path except the one issuing the command. The
> key needs to be reregistered on all the other paths again. If any IO
> goes to these paths before they are reregistered, it will fail with a
> reservation conflict, so IO needs to be suspended during this time.
> 
> The path that is holding the reservation might be down. In this case,
> you aren't able to release the reservation from that path. The only way
> I figured out to handle this in dm-mpath was for the device to preempt
> it's own key, to move the reservation to a working path. This causes the
> same issues as preempting key to change the reservation type, where you
> need to reregister all the paths with IO suspended.
> 
> An actual preemption can come in from another machine while you are
> doing this. In that case, you must not reregister the paths, and if you
> already started, you must unregister them.
> 
> I can probably come up with more issues.

This all is becoming complicated... :)

> 
> I think the best course of action for now is to just fail persistent
> reservations as non-supported for scsi devices. IMHO Making them work
> correctly (where mulitpath device IO won't fail when it should succeed,
> and succeed when it should fail with a reservation conflict) dwarfs the
> amount of work necessary to support ALUA.

Yeah, that sounds reasonable, but I want to ensure libmultipath API does 
not later change here such that it disrupts NVMe support (if indeed NVMe 
goes on to use libmultipath).

> 
> dm-mpath previously did a pretty good job handling Persistent
> Reservations. But recently it became much better, because it become very
> clear that pretty good is not good enough for what people what to do
> with Persistent Reservations and multipath devices.

Thanks for the feedback. I'll check these details further now.

