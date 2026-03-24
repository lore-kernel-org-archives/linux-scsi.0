Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9619338E5F6;
	Tue, 24 Mar 2026 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369531; cv=fail; b=aPetpEEoGcwc/WAWCvkLae7hl7miLO14sNbJSk0wGbv82zSfTNUsxD9qIqiR1sJUFkQBKWRim+tLB9pqshSz9UJNbUF7LLU1ZmabQbJH5mbdDWu/L3hUg1h0VIkTnzsg4oIljpBDz3sQoniDgqQlwg2p8fzREjNL7tocbjGpq6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369531; c=relaxed/simple;
	bh=uTfEbqAYGGzUnQ5GsMWk4w1Ry09E5mAY5ppQbyYmwNg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pDRCEFcS63OZzqfZYEswfTRZlyHGsYX3Ygm1nw40drJbA4mYi0bfxCT8iRIX0Ce2+9eBePeh7AWQ3WS6M1vBmT5AXgtwrww7FMk79Ouxk95MSmT6wLuhI+YZO5RFH8JZRo/O4EEwgmtPCL94S99E4YJacViw8dMPmC6gJaORCJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JIScxTLG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dB+4i4S4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JIScxTLG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dB+4i4S4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62OCFfhV613140;
	Tue, 24 Mar 2026 16:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=thBAVuuHPuohcr0QGfKtBxuNU3ONzrcNzpcuKc7zgWE=; b=
	JIScxTLGLSg6IK0MQ8RRW4PPthA9y+ILG5hat5WFqhcy1S/RGDSVv56yJ2XacQrT
	taahd0lQBPbiLyLqTmttrB5R3xAlDgSh1UDXAuPdpbrRW4lXRi9JRY+IFyfs6woP
	1YL41QQeXvpUHJrMSqff3YnOCUoYGp64Bu+UxFbV+UWDs6utNGnilry9QdyLs61d
	56ct3Oa7lFbgxDio5y3ManAZdUaN5oaVjYJ4lasLgj9NaYPEZsysylJ/JYb5r1Pt
	5Wlhb5DvmSVhrihSZ2YHVk0eXhnKc3DQoPmAQwKjpyMJG+RZFWvh6yo0MIrnd93R
	smd+HNFAWcgM2gXCgIgTOQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1khf4jvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 16:25:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62OF3bGP012377;
	Tue, 24 Mar 2026 16:25:17 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsg6xjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 16:25:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DJdRFdOaoCxtAn6qgMcUUHN3tUcKNGWnTJXbGI1+AzFSU6WHMsd6Y6nJRYVZnb0kzShQOiNyHWqTxevGvIy+NLMlwdBQrvDYzHqSvP1uZs+NX4hDtmMKI+oz8mNJYuhnJcaMzFhkaYuEPrUvQWO32f1/f3ex0ubFRTLsQx6A71uo0PeDMCkouxddjsTtvaaNlr/B2crfnnuwaIQ9H3BV3j3PRo/MfDbgFZDojbTkuWdt9RlqSYittVPer1sLYY+Uk+BBO8CvbaSTquc1DR4FRCllLCR8rmsjGjgdngdwUqjCxWm++fyjUp7Led0Q3iJKuzk7tp935SR6u6EW3Jb7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thBAVuuHPuohcr0QGfKtBxuNU3ONzrcNzpcuKc7zgWE=;
 b=pjpwduTvGlQFFDXIR4nA4a5Ts5FoukdFe0ZlRDbC/ENfoS89n2fyND1o4GxVQAyll56NEz6RLVe18TLOjDoH9pNDoaYYvZGgtcH8Ykwa9OGzy4Mo5sxr4xDmX5UQvK69P3z03WJyPgsgUHfO4F7TL+jj5i3l8mmHx/LdRSyAf3WgKmB2/sDP3ZoM1reyyBMDZBtnKNSkLryVlyEf2yeC8jPwQssPVw1VR4oIhsoIIqxB4gGajpmPgA5x3w3cMU43BdAw48LK7bXH2BThgaRs0PDKsZfedkbuyEuN0oD8zUIuY8Gt/L7Te1qE3IGS0wwzszfoSjzqdCroV/FLvD3f9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thBAVuuHPuohcr0QGfKtBxuNU3ONzrcNzpcuKc7zgWE=;
 b=dB+4i4S4zxC56IwDMN4z7Bt/tcXGcLhJkUgeo0HohCvCH4iYgJ8yEFHfIXSCyIx6idoHJtWBNJ9rThQO3Z4EJMatftEZ7nf58j2hKmfez8H77jJ1cLQaSYbPh+1XwVpRfrZSXsO6xQ9nI6No7WNJuJN+ihqrWNeWKidI6VKQrPc=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5196.namprd10.prod.outlook.com
 (2603:10b6:610:c0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 16:25:11 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 16:25:11 +0000
Message-ID: <2673bc45-6933-4a7a-be73-f0554c3350b6@oracle.com>
Date: Tue, 24 Mar 2026 16:25:01 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
 <acKyW6IPMhhZ_eF8@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <acKyW6IPMhhZ_eF8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0042.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:58::13) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5196:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aad04cb-56de-49b4-6423-08de89c1eb09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yodzmL8wJ7dbxE3/Pt5SC8t4exH4DHto4H4NjR17gTPtwFVFNLozBedakjt/ASM1V+FGbm5S3pB+uEaQ/a6awMtfrZDogoHRA+NS/3sUvn0Pf4ZErgOZyVXyscf1Xcgsym7IYr9wKhT69cLF/nVUfwpCzQXG0LVPn7WrmBpmOOhWnVfTAQL2kLI3UK1gKNA5SQ5zRHpd29N3QJmX3OgYbtWPgkG/EzkDCfxt0JaCw4BUBjSxaaoqrs8jk04cTvoLOPVIsGesUKAjdDaP6EuJ4V2kZb3HOR7Mduu69lNY10p7+HCtc56x5NKGzEQokjBpC+O3AkYxLz99J7W1FwWqGfXXQPLIknlUkFLTohxBiw9ZatXmSTFFoj94C2JyxVgjuba1t3QzXum35Zn9BV8PZBxDQUf1v+6PUoTb/MxBfNMM/0G0zf+HzIr4ibCFIw2iYxkMZVRrddR6arz7vtkY8CW55OfovYyUnHto8mj4qNCOQuMzbnMMjATOs1jmQt0uyUteGxvgT1tuYAnLY2aiMXHOyPg8/PrKn/IYLBe66r1Os5d3b/pw+IEifKNF6WuhRUVFpw9HeG+9BWQBrJlzquk9Od2FzbFDjp2zmE/qgkQkqz7eGsifsJwdaWr8lbskEdnxWXKHsO1L+Zor8td6EAq+WSozcZr9VpruGFkke+JbiPn2B4m4IwEWfMgv/sbQdokg4o5c4nQZbZpaCLgyFQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHhhSjNtbEpJZHlRZjJMczdSaVd0R2VxQXBaWnZZUFJmUUF1bS9TSFI4Q0pp?=
 =?utf-8?B?TVdSSGgrRVdqbjk3cHVZQW9SNjVqQXQwRU4xc0kyOVFyT0xPOWw5ek8yTzkr?=
 =?utf-8?B?NGU0MGROOTBxcUVTdWpWTzQ5dUNVVkVzcVR1MDUwRThYMGNvREQzNTdUOC92?=
 =?utf-8?B?c3JhNjd1V1ZOTGZSU29QMS9hTkdWYjBZbm9Pek9rYVA5L2hEdlE0dDVvdVhr?=
 =?utf-8?B?dUhvc3ZmU0hVWCtzRFAwYTdidVRvYlBYUDRkK0orS09ET0xXUGNLQW4xSHJ2?=
 =?utf-8?B?SDRZOEQyVGNtOUt0U2V2aXo4MDEwZDFLSTBtOEFvK1NneDFZMFdYYW1WZ2V6?=
 =?utf-8?B?YnY5VWtXVzU2ZWhJZTZ5WXZXNlVNOENHdkp6YzJYKzduKzlCaWwyUkduSXRF?=
 =?utf-8?B?MVhZYzFBRG8wcFBCK3RqL0VQdnJvMnZpT1NaMTJtVVlkOXpwNEFIcFdudkVX?=
 =?utf-8?B?L01QVTBOUjVUNWdzeGE0S2NFWDdkSVBxaU5Za0d4QTY0T0QwN2dqNHF3ZDNU?=
 =?utf-8?B?OFhkTm5WWFVXSTdNZ2RvRWlIQkRFTEZ1R3lmKzhEYWJHNGtWL3V0OHZUMDZw?=
 =?utf-8?B?cVZjTmNRZndjZGFSTkg1T0QyTjV3RURCVVZpeFdsZTVOdVpxU2hkbDdoUWcz?=
 =?utf-8?B?UE9GbTU2bVE5WERvNnBoWnhJb1RkVWtvOGRON1prRmtMTTFlUUZPK25nSEQw?=
 =?utf-8?B?NHJSNG9pTFdCT0tQNlhqbERNTHZiQ1ByWklzS1ZFSEs0N3pQT2xjd1BjaGY5?=
 =?utf-8?B?SmJ2OWx4cC91T2tvMXlmTjljdHh3dDN3RHFsUGxpbVl0TklzUDBEWkJrTUtW?=
 =?utf-8?B?UTR3WlZVaUp5U2hITWxUSGgyRVovTWREUEhPbllMd3RuaytBTVFwcGErVC9k?=
 =?utf-8?B?QTQ5Mi9yeFFja0ZGY3huRjV4eW4wamZOM2JqYUQxSUpPMWM4THoxS1V5Mmxl?=
 =?utf-8?B?aFpHQlVoQzk0TmtiY3lwd0Q5NVhRa2s3TmxnNk9wakZ0SSswYk5QbDNVRldJ?=
 =?utf-8?B?elN4K005WUp6aURLTWwwdkdNVTJoc3pIMWtRbnRBRWl4bkF1d2dDN3RQTnRR?=
 =?utf-8?B?N3o5b09hQVFHS2pyTTJhMkZyOTdNNzJPY3haNnMxN3RpQ3I1SmxjaTdYL25M?=
 =?utf-8?B?ZEUrOUJPa2p5ZkoyUlJoVjMzMDFtcm52ck9aM2hidVprS0I4RnIzV01jbEo1?=
 =?utf-8?B?Yy9QUzJCczVJOWlPTVQwc2p5ZVhEekdlVTNTNXJaakQzcEJ2RC9TcWt4WTFB?=
 =?utf-8?B?RFJCYXRxclhDby81dk1RcUgweGNMTTBYOWQ4RFRXYTVhKzBpMGVmaEtVZldX?=
 =?utf-8?B?bVNqNk91R2tSSzA5azBtR1BONy9jSS9VeG55SVpFNHBCeVhLRXZWcDBzajhl?=
 =?utf-8?B?VGxlREt3ckJqTW1pV0xlUWN2N3RvR0dRK3c5TVp4RWRxWFlSRjl5Zm1pbmRH?=
 =?utf-8?B?QnEzRjdWbWt1Lys2a09QMmNtWFlMeVM2dVVncHBvSU5mM1ErTmYwZ0U4aHgx?=
 =?utf-8?B?RnJTVlpUSmh3SDcwMFpwVjU1R0txZHNJS3JGYlZ5MDJjQThLZHVPUXpQNHB0?=
 =?utf-8?B?bDdjYnJsQkpHTExFNHRtVEpCZkVtQkZTZVpwZFZvMDF1VFkxN2lXdnNiWWZu?=
 =?utf-8?B?M0NJYzRLeHk0aXE0YTM3VnphTGhqNzI3cXUrWlU3Wk1IREZmMU9IZ0ZiNzdk?=
 =?utf-8?B?aEZrNEZseW9MMkloanI0NXZnQTdKNnUyNDdTNm5SKzhzZWZzajJxeWpIZElv?=
 =?utf-8?B?NWNmR3FnajhOR1dlVld3OXFwWUh6cEVUbHVUM1NIL0lCSFFBR2pLSVpOMDVq?=
 =?utf-8?B?bU9xemx6b3RXSlZkRkJwVFl5c2ttbmd6TVlCdi9RbDk5cjRUNTFtdEcwaTlp?=
 =?utf-8?B?VXRYYnczZjVEYWJGYzNVOVRoVUNCWHp0RGxBanV3M0tDU3NJYWVWVVh2UnUz?=
 =?utf-8?B?M3hKT1pTa3FtRWNkaEdKeTNnSUxLdEdSY0ExTnBjc05BRWZEUGNxLzZtdG9L?=
 =?utf-8?B?SkNKVFIzY2pmZnBOOEt3ZEJyUGc4R3hIWHl5T1BEWVZtK1Byd2N5YnJYTzdF?=
 =?utf-8?B?a1ZlWnJQeWVpb3VERFF4WktVcTU4aGZNYUVYRWpIQmpaQkdUaExWQlRMaVlq?=
 =?utf-8?B?YytIcjNvY2NubXpiQmVFSGlQSTZyellMWnVkTlNCNUJsR0ZXV1Z1TndIMmVX?=
 =?utf-8?B?K3ZPaVBOdTFGR25UTzIvWkNjZXUvNmh3M0t5b1orSHp3L3ZWMDZ4R3VON092?=
 =?utf-8?B?YUNHSXBOK3ZkNWZJSW1zRTJVNXBGeUtHREtENXo4di9oSytkRU40RFhuT1hx?=
 =?utf-8?B?NDIra0FhTFRSNDg4YXRtSzJSM25qTE9OaXZiR1VON3hmM21aSEdlMUk4Q0NL?=
 =?utf-8?Q?ArgI309AjQVGjmps=3D?=
X-Exchange-RoutingPolicyChecked:
	k2/X5BvLbERBN+HbTY3boGCRRbefpaGaRxRVrPOEY8c07J5PsT/wdMOwHowAU72IKVh8u3qw/A4duI+HysM7Ka0+slyXHwDAvG/9ylIDReouaADhygrX61J5rw9MS+znQXVNpIjeforeIonBl2XzMpLMFQdiizGWOBVW5V26vs2D3Zm0V2xkqh8VWupLUgD+v9uILbk+L5JFPWoyGE7Cq4HuQxTr1XTtk3mhKmmE4om7UTktw0wUbzRTiZFCyAAVmg61/Sbxg/KpbdmXXbzpNqOuFVxYv4r2zhxIy0jjHorm4wwtX6KzV68zgxJvZSBixp0VDgHCCvucm9C3aXyx6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G0DUmZEcI3X5BNeoNrsDex+5i5T/v11CVblQ5cx9zWs9cOyIqnm83qgFSz+pyBXxpYyoy9I+LoCife7OOIy5d8Aqjooly69Ub26bqFcmAHLsodYrmbYLhuspIhlzUlem8ZNNKibxgzhqXADWYltJTckH1t7n2UwiuSdqy/0D27Tk32P/2Hdo6EhX1M3FmWdh5cEp5v3GyPW1917t5S+lR7Gw8b+UhAsikmiEAJ2ORoRO8VXjSgvUWaqEc/HBltIYkMuWQxZInjZ8VgZeJKj7p5CjVJIFIn4WjBrfYFAXNj5UgyEhYKdhBBdLIxT/ijCY0AsKmQHg4Zb1kkywXbDtUkmXx5PtuYaO74wAqoIixY63+XemmSMPEy7YY+e9qq1OqWsDtT8Gcb6EtoK5UQIEeYfcvxmBgw7zFQQoreY/gxO8IS2L1+9QgihyfxYIsEeFPM7mSUz16Yiig+3Zfsf5A/dNKWFl8qqaUL3mY8g8biMcPMuHLTokR4FBrj1q/IH1+ulqYlRROjg7Isxu0PDXUhgwHgTsWAuSxHsa/3dgdo3qUND+Ye/j718UBvU685T7aniQ5nOcLioLBjro94WyNiJJcrCg8POcGqjjrhlSgo8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aad04cb-56de-49b4-6423-08de89c1eb09
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 16:25:11.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dl38X6NfnNYTPbQTycbVX4dJEdItM6/eSjFGsas4DBx8Yao0Dpjuh2cv7GWJcAg7bwxvVOJXXpSd3qRxcJLO9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5196
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_03,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603240127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDEyNyBTYWx0ZWRfX39qmoEL3R+vd
 Fmw0/2Z1qNWPPLNJ8bMQP2B2Qj0PdYTrFF5TnCHtVovwPmi2lplwQFr5O2A0ykjSfNIWSrhmt+P
 MO5NPd7wIzbIAhadoOV+sR71Ahb97rWvCl9XMkvRGWBvDg6TO681jcURN5A8IV59SCFROYhvm/K
 F20mWPfB90oASWUC+b+jXcAzpbEMkXyomawMmpH7R8MATTl4DWVs03m6UdbPmk3yANy7m39iZI+
 AE1mge4rCh0mITHBBLZcOAj00dNskMyi9ysa2SrtB/zvLJD0Ubn2Wxt7LhHovzAS4kW4h54TvQg
 x0NqQfuW21hhq6iOIpMHUz3O1veA2avx5BVWFQVlJTHMaBWZDxtOw3Sxc3PyaEsHSeEgck5AULU
 aXSbKU384z8wRsG5cTpIeAab/nyBfcyjSMOAseNXsGHzr+XWwSdVYqvAGTNLSzc1IRaFvyy7Sx0
 6ANlgbFKC1b+i0Ecdpy7NnvH95VIMsZaxE9Flg/E=
X-Authority-Analysis: v=2.4 cv=AIvfpCdw c=1 sm=1 tr=0 ts=69c2baee b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=ED3_JYZbo02qrxEpxg4A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: q62b4MDXTbj4DdfcSrY2TyKqPkg5LoDo
X-Proofpoint-GUID: q62b4MDXTbj4DdfcSrY2TyKqPkg5LoDo

On 24/03/2026 15:48, Benjamin Marzinski wrote:
>> We would need something like the following to ensure that DH ALUA is present
>> to update sdev access_state:
>>
>> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>>          bool "SCSI multipath support"
>>          depends on SCSI_MOD
>>          select LIBMULTIPATH
>> +       select SCSI_DH_ALUA
>>          help
>>            This option enables support for native SCSI multipath support for
>>            SCSI host.
> DM_MULTIPATH doesn't force the device handlers to be built. You just
> don't have their support if they aren't there. Granted, it does make
> sure that if they are built, you can't build dm-multipath directly into
> the kernel, if the device handlers are built as modules.

Note that dm-mpath does not even work without DH ALUA module:

device-mapper: table: 252:1: multipath: error attaching hardware
handler (-EINVAL)

> 
>> And that is even enough, as Kconfigs should only specify build requirements.
>>
>> We really should be also calling something like scsi_dh_attach() for scsi
>> multipath to ensure that DH is attached (and running to update
>> sdev->access_state).
> That isn't necessary. If there is an alua device handler, kernel will
> auto-attach it to any device that supports alua (see scsi_dh_add_device
> and scsi_dh_find_driver). DM-multipath's calling of scsi_dh_attach() is
> mostly a historical relic.
> 

We still need to know that DH is attached to know that whatever is in 
sdev->access_state is valid for scsi multipath.

>> And I am not sure how the dh alua module is even autoloaded. I think that on
>> my ubuntu machine the multipath-tools.service does it - something like this
>> would not be nice for native SCSI multipath support.
> Fair point. Depending on how the kernel is built, there could be system
> configuration work that needs to happen if implicit alua support
> wasn't in the generic scsi code. But as far as the kernel code goes, I
> still see them as parallel efforts.

I see what you are saying, I'll defer to Martin/Hannes on this.

Thanks,
John

