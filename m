Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA526F2AD;
	Thu, 27 Nov 2025 09:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764235642; cv=fail; b=VoL6K2XGD15voQGWNU3mHP8o9vnm35VyfRzFTFzEzcTv9LKtLjtakgkc545/tmUA3VI90H6jqqRECqHNbt33cnJ58p0yfN4ALi1jG1BZfODtmbvnDxcprG24Q38rKQJ1JIOe5tas1vNaLZCuZQhY2UXphhR4QsH0LWFk7MwSr1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764235642; c=relaxed/simple;
	bh=QI152De9WHdXVnTM/G3XUE0Umx9v8SWJrgStw5EnH3s=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jGwm1BS8VmNLfAR/KN6K0Q/oNQto57aVIx+oEuIGDh3GR3Cv8kIt+Ywer5pHCCIxy112YkeSE3pHSj3+/aEgOtGEj20bsEwrwixD2XFntv6d6Hja1h2+d6UwfmD25v6TyopHue9ZmOVTuvPiFsQAN6lmLrAbHlAPdXR4jdvc9oI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sHicPlRS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lg+8l7cl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sHicPlRS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lg+8l7cl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR7Nf044040476;
	Thu, 27 Nov 2025 09:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G4XtMAznGWI/B3TjitfLkh4feD5MfQHMkJZulRyZuTU=; b=
	sHicPlRSgUApIsPg4Nkn7t+LeY9JAazrpaJME5UdYdgHlXXQuZOQ4+t4b86iVs2e
	PCMdkfmaiPz5tav3eyruEJTFfSNebDxlV8NinfZGfWs03yy7pDimyNX19Z84q/q2
	DJq/GH4sxxMivn+ATQqffCBw9PPB/7BL4xJsa+V3tWNufRyi+1E7uBWEk9LhBNQx
	FvnA08o6BPMZrILU7QoFp3S20PapsdahFb+sxNMvjIpHh+9hkbQciVEfKlUJKq9t
	xwMeQHHknvKR8YTmYBMmLLIRLcwqSOTY9igypqng42n/96EBOnmOb3pldMC8VCJd
	4K/Bwsc21tdFNQVGQZkybg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8d37dta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 09:27:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR6tDG9018848;
	Thu, 27 Nov 2025 09:27:13 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mc2pmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 09:27:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJJon67HtJBo48/hk064MnOmMPLFbo0tCE2fbtkHG3rvDaROrzg/W9NoLvfKPn3XC76euPSBbAdhL1B45LhJzIsvkKutCkCNVdxKBIX8CND0RrnMghCXad0/kYXQNy1S1emsjPIcYiw6dVPoTwZ0wkBv/WIYb9Wg4k/6fLQ2xmnzXZcdGYO24QhXGtZe2Uc8hsTg4isdjOa7bdCaebLEsz9PRwroKG2DE1v87iLWHYA0Rp+BXjiEcs2PQbcu8z/aPou+08rU8UTawmCXqktesYAcFuxhB/xhXL0gOtYz80Tx+IDP1mbNyVPUko59os2AOXDp4usyQM+ZNgTw4rqZ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4XtMAznGWI/B3TjitfLkh4feD5MfQHMkJZulRyZuTU=;
 b=J4nStAkenrwLHtsKR8ad8lVfN6qC/iOqeUmJu2c8ZfFUfKAch+I4CU/cRcpc815iopkbBK6HxEh+LH5rq3Bf4cN5KD6YF8Lk5ykPn3pfwdUbD5ipIgXu/JK5M7CTZ1fdlUpkkYUo+K2nRI9dRICae0teKrBeFTgZfh7yxcrxfLJvj5Yo92JnZlREwFgIeI+zbPQ6kcU/wxHyyq1wq6c6fwOoJVWQQW4j2+RdFdE731TUZZjZ/JBu/DkddWR6gaqA7CBV6EthWTZGYNs2aq0r9hABTTI1yovTUa1viHFDDcExdygHtVeEb+mMIEKW09fpKRY0ZibHM1q/xxnVmyWDmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4XtMAznGWI/B3TjitfLkh4feD5MfQHMkJZulRyZuTU=;
 b=lg+8l7clbyCObuq+/WJ6QXTVO0VsuxxLTiElK+bEpA+szYxYwl1Tv4+GAf7Lr2fEA1ewGmZJdehMxGNe+481zJaSFcrG5E4T4gKkFmpT5KAJrWcR6OHEJlm3BbsrzS/1Mu+HsNr2lzDCm+6DRnwrmWmjzd3Kyb4ZEkGKoP38jw0=
Received: from IA1PR10MB7240.namprd10.prod.outlook.com (2603:10b6:208:3f5::9)
 by BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.15; Thu, 27 Nov
 2025 09:27:10 +0000
Received: from IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364]) by IA1PR10MB7240.namprd10.prod.outlook.com
 ([fe80::6ac8:536a:b517:9364%3]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 09:27:09 +0000
From: Gulam Mohamed <gulam.mohamed@oracle.com>
To: John Garry <john.g.garry@oracle.com>,
        Martin Petersen
	<martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>
Subject: RE: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
Thread-Topic: [PATCH 6.19/scsi-queue] scsi: target: core: Add emulation for
 REPORT_IDENTIFICATION_INFORMATION
Thread-Index: AQHcV93yoglogjgHLU6Wmr1ZRWkltrT4ha1AgAxhKYCAAEJBcA==
Date: Thu, 27 Nov 2025 09:27:09 +0000
Message-ID:
 <IA1PR10MB7240BD4A0938C4AFF0B3870998DFA@IA1PR10MB7240.namprd10.prod.outlook.com>
References: <20251026191309.34968-1-gulam.mohamed@oracle.com>
 <b3c28b7f-503d-4e83-b4c2-b756150bfbd9@oracle.com>
 <IA1PR10MB7240FA764470DDBC324840E898D7A@IA1PR10MB7240.namprd10.prod.outlook.com>
 <f668df37-8291-4cf2-bfda-62324b94da13@oracle.com>
In-Reply-To: <f668df37-8291-4cf2-bfda-62324b94da13@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Enabled=True;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_SiteId=4e2c6054-71cb-48f1-bd6c-3a9705aca71b;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_SetDate=2025-11-26T15:50:39.0000000Z;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Name=ORCL-Internal;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_ContentBits=3;MSIP_Label_f3e58186-1c1b-4537-900b-8707ad116850_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR10MB7240:EE_|BLAPR10MB5140:EE_
x-ms-office365-filtering-correlation-id: 6b1d98a5-4998-4db0-5efc-08de2d9723d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?utf-7?B?dlBPaTRCTkFtc2FrelB5OVFuTWkxTkxjWXlYVWNYMUNzUWdvN1kvWGNrQjRv?=
 =?utf-7?B?ZFk4SistRFNnMXFkTERlV0hZVy9yN2p0NEpoSDhaZ21kbWw0aTVxQlJ2S1Ni?=
 =?utf-7?B?eUU3RW9nQmpCcW9tamUxR0dkZk51NEpyaTl1Y2FHd1huNkhEc2VrYmY3bXlO?=
 =?utf-7?B?cEovMmRQdXB2dWJWQ3JLTzZ1MzM0Rzd4aXhCWkFrT1JCNmNnR0dmZ1pjR0Vr?=
 =?utf-7?B?OFUrLThsUWV2VnFBbVRsd283ODVwdDgyOTBxOThLVThSQUNURW5qUzZSa2Zo?=
 =?utf-7?B?RHJXdEgzSW1qM3hkOTNFczhLKy1QTHk2aFkxMGJjWmFvZFlVMTZldThqeC8=?=
 =?utf-7?B?Ky1hVmZGOUZxaXljTFY2Ky1QeFpYcEd2dVN2UUpiKy03S2FNL1p3ODQyQ2pk?=
 =?utf-7?B?b0liUTVOYnBFeU0xSGVKS0pzVlF4aFRUdmYvTktPaEpJQklEd2QwdG5nTkpU?=
 =?utf-7?B?eGM3TDNGZC8rLUJkajZaUEErLWFFcVp6aWV1R1J0TUNlcFRUdVJ1WUNrYS9v?=
 =?utf-7?B?Z014WEF6N3FnbEUrLXVOejltWkxqWW4wMWpIOU91N1ZjRkR2YS8yUndFRlA1?=
 =?utf-7?B?VjI1SmJlOHIveXN1UmxiZjZJT3lJbzRSQ3VpR28yWnEzcGhJTVJ0aWJpMkhE?=
 =?utf-7?B?U05sYVYzdEhtWkFCNVVwL04xOEJCZHNMVlpGMistaEI1anpNYmNmdnRLQlBk?=
 =?utf-7?B?VkNYTGs5cVpjQ1V1WjRwSE55MXdaeWJUUkVUWHU0ZU1FTEFpaEl3WlVwVWlq?=
 =?utf-7?B?bnVrKy00QVFnR0VkdjVFTGVCaTlaeC8vOS91WUZvOWdYRGZ0bHRnZW5PWXVm?=
 =?utf-7?B?Z0ZiaFIzZE9JKy1xWE1rKy0xbXVES1hYSGxMbjhyVk1CMW5KV0JIVnpaekxx?=
 =?utf-7?B?ZE1ndXE4UnVSZXc1Ky1HVFFhZ0lBenFHVk5waHdSc1M4VnZRd3I4elpSaFo=?=
 =?utf-7?B?Ky1odFIyL1V1Ky0xQzJ3UU1EZ2JDZms2S2RKOXZZeVdIWkZoZ0FzUTVVN25v?=
 =?utf-7?B?bzlZWDYyQ29MVTk4dUJRNGFYTjFUMnJaMm1hKy1JMnU5akhzWnlsVnRUZlhT?=
 =?utf-7?B?QURoamx3WG9URG8yREFVZGJhMUxSNzhTWkdaejl4dWphc3lwYTNvZ01CVG9B?=
 =?utf-7?B?WHBicUpCcnNFUjl4YUdoeVBQNSstdW0za1dqOFdMa2FObUQwVzJVTm04d2pm?=
 =?utf-7?B?NHMvTFhjOUx0QVhyS2tGUWQxWlZJSTkrLUdtTDZRaE1BeXZ5aVpSZGNydG94?=
 =?utf-7?B?Z3VaQVlnbmtmbzZKWUhyb1pvQlhWYVh4bE9vc0Z6aGVPSWJSM1lqV0t0aFRR?=
 =?utf-7?B?RVRIUkVYVThTV3FzWWhvSjlUNWJjcVpOUUpmaE1hbDlTNlcvakFGN2xZU1Nw?=
 =?utf-7?B?cDBVOFlpT0dxYWF4ZDhoajVaWGZFd3JyREFtRERUSWpxeE1RNHFZS3ZlcEl4?=
 =?utf-7?B?aXVIcVJ1ZVhvdkExcXYvZnVjOEVCRDJmV1ZXSmxUSTc5TlVkYmt5aUN2NHMx?=
 =?utf-7?B?MXB6REplS0NWV0JBTmU4ZXd4cjIzKy1yQ0F5TkNvRmd4cUVoczI1akNWSWw2?=
 =?utf-7?B?UW16UEUxWVNCeGtRMGg1ZjJuR1dNSWNzRzY3RFFRYWNhdS9kSlNtaHp2Nm45?=
 =?utf-7?B?dGNpMXN2RGc2UXFSZE12amVUaXhEYjFmTGwvWjEzTXNsSmJXQ2paYjFQOFZF?=
 =?utf-7?B?eXZhZTFQeHpWZmdyMkdOSFpYWFJRbWdIL2dENCstQ2QrLXl1bE1qcHY1WHdQ?=
 =?utf-7?B?THNCd3lyd2tMa3U5YmNkNnlhWjZsMmN0c09PMi9TTmlqZUc5U1hpWE84dk1a?=
 =?utf-7?B?b1E5NDROQm9IcU5EenRCa1hkV3NnVHkxUUVqZlB2SGlOcjRmN3RwTUdNdWJh?=
 =?utf-7?B?VU5BQXZrcnEvSkQxeVJZWUlqRkxCNnBxSkx1bS9oQmtKYlhZMkZhOHpmZEFj?=
 =?utf-7?B?Z3pqS2xzMDNleEN0a1lHS0RVZ3llcTRiZjdjOUlXN0lhRVROYlVnWlMrLXc2?=
 =?utf-7?B?TWJNckZoZjhZbFlMTXRSZS9DeUhBSTAwa2h1M1Bvb0xXdjZ3cXpSTWVncHJ0?=
 =?utf-7?B?VXVNalp0cHluVDdvVjQrLUxQV2l5RUUxc0FiWSstOUxn?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?b3BuNkhzQklyTmN6ekZnQy8vNGtaMUNveG1EcTNWTVBHZzY2QWFNT2E0eWhQ?=
 =?utf-7?B?MldWTnJWRmc5QmdkU2IzVEJQNVE0dDhzREhReEdzWVFTV2lFcEMrLVRucVBB?=
 =?utf-7?B?NWhOTUE4djJ0M2liSm15YmtVMHFVNkY5QXQvTXJhU1pxempFbm9Rc1RodkV0?=
 =?utf-7?B?NW05bXRSU1UweTMrLVhjVnJ3RXlpWWp0NC94c2ZsTGt3OXZvKy1scEFNZDEz?=
 =?utf-7?B?VXpLSTZyMUtIL1NQNXBidTR5QmVveVdqMmx5bEEwTXpDWEJGR2JZall3Uy84?=
 =?utf-7?B?eXJFcVNtWEpnMVBtRURPKy11TzRqZHlPQmVyN1ArLU9maklraFRlOS9HbzRy?=
 =?utf-7?B?M0hPaWhGNzdIWS9VKy0vQUpHVFJzTVFNaVBmWlVwVVZ1bmd2aXMxSW1qb3Vr?=
 =?utf-7?B?WmhHY2lYcHRlTEdNd0JJcXloQWlpV1NZeW9QNDFmbVFWSzI4NC9qRlcwMyst?=
 =?utf-7?B?RGNOemhoSk9rTDZwUWQ4Rk9iNHczbGhPWHN3QmRHT1A3ZU1WNng0MzN2T3hD?=
 =?utf-7?B?RVJjalZTUkt2V1FuSEZGLzNyZTdzcWRwdmcvSlZ5Wml3Ni8wOE9FWUdkMG9L?=
 =?utf-7?B?OCstKy1qbEZmcFI2eGllZlZYQTQxT245M2FDNlNoMENZR3ZaOWxSQ1dML0xZ?=
 =?utf-7?B?NVRrVW9halpMTDdUTXUvTzhRd2ZnVklVL2xjTEN3MVZ4OFpDQUJLNFRxSlZT?=
 =?utf-7?B?empENkk0UVpWbnBHYm9McENBamV1dTJrYTl3elNoVm05YVdXaTZQUWs0UGsz?=
 =?utf-7?B?N25hdUFWWjVwVjZtSzBnM085S2FqQVp1WTFOdmg2SUxpeDhiRTBETk9ocmV0?=
 =?utf-7?B?UVcrLTZud3BDZG1DRFk0NHlFZkpOS3EzTEFKVHplZkdRZ0NXTzFMYUVqclVa?=
 =?utf-7?B?QnFJcTRqa3pBM3JDSmplMlZPT2l6YnMvRlkrLTAwanJiV3hqdm45VEF6THYx?=
 =?utf-7?B?NzhVazdZS1AvVW9OdkJxWVlNVzBON0lRZE1LZFpsUG5WU3dOWFpyQlREQzBW?=
 =?utf-7?B?dnl4OEw1REFpeFpNWE41Ky16eW9qMUNJOVUzR1AyaktjRFhPeFNMKy1FU2V0?=
 =?utf-7?B?WjgxQkR0eEhDWldDQnhnQXluRkNSVWh2QnYzMUZWKy1MMlo4RUx0VXJzKy1P?=
 =?utf-7?B?bVlNSi92Ky1HRXRPVlcybkNKME1hV2FVQTkxKy1vZU85LzRFRXJKMXpZTzQw?=
 =?utf-7?B?ZnFhKy1YNEYrLUZXa28rLTN6anRyQlVqckNIU0RhSWduMWpMczBFZE9McDVj?=
 =?utf-7?B?NGc0U3FVOXZwQy9HaVJvNFUxd0t6Z3lmejFVOXJna1BxKy0xeW5YdW5GOUFv?=
 =?utf-7?B?b0lKRHhnU2plY29iOVJQYmZidEFydzZmUE90V2x2aVloVjhXRFFPOXV2U3hk?=
 =?utf-7?B?RUxDYlJkVSstdGFRWGZaNHFsenYyZTYyY0EzN2ZTcmQxZVp0ekV1Ky1pb2Zx?=
 =?utf-7?B?eW1xWFNiQmNNOW1HdUF4Z0dkYzdkb2hlYnRVWXQyYjJDand6OThEcU96RlBy?=
 =?utf-7?B?YistM1dZaEYzSXNJNGpxU0R2cndSWldvMmpacEowQ2MrLWJCZTJvMXZOSEw=?=
 =?utf-7?B?Ky1HMnpibFA5RXB5My9KTk5uYk8yQXgzd2djdXNMQmxsRCstZkx5TWp0L0Q0?=
 =?utf-7?B?U0djaEZydVpxNDF2OTYrLVNjV2M4Ky1tQVFsaWVnMno3YzNQaW1BTTI5dGRN?=
 =?utf-7?B?NnZzemFPSndHSU9kSFByKy1vSmpxNjNQRG05b0VmTGZSMXNRTDJNNlZxbHNj?=
 =?utf-7?B?MkZoeFpqY01tazIxZWlCd3R6QkJ0MXp1Z0ZoRG92bEM2dnZWOURycXJqMlRZ?=
 =?utf-7?B?bTVPb3hyYW1jd2h0VDdnS0dXallkUmFwbVB0Zk5Rc3V5cXNYc01ORWZPRkZu?=
 =?utf-7?B?bzVzNU5WQlJDb1JxZEx5bncxdlUydE1rdzduZHhObzJCdkt0M2hFNnFKN0Fj?=
 =?utf-7?B?anl5Mlk3SlMzbXE3SFJCNista3Y4eGwzQ1UrLUNBTEx3cExEODI3MHZiMFZu?=
 =?utf-7?B?N0Z5RmpPM1Z3ZWxVQW9TMFpUTy9JVWtZa3N6ekN6Qm5iRWcwdFhrQ2tTM29M?=
 =?utf-7?B?Ky05TjBjUldwNUtPMDI5T2E4YWpqWlB5Z1JkR2gxcWhUREN3bTh5YXgrLUpu?=
 =?utf-7?B?WUNGWFBsRDBmWDhkQmRGZmR1ZnNaajl5Z29FbmJSMzc0b1lrQWZKakhNSmxW?=
 =?utf-7?B?cy9iQmlvWTRiM0lEd3dX?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nsLvV3Mag/0JRr5fm6eaENxqYhYkus2OTEItbr+uMDxBuCnOEoQH2MxlqZ9WnlL1Md8zVYnl5P6eKJHQVWlJpVQNnSZfULT4KFc1g0TTm3cSJ/j/Caz23DjjG2wbIFkFPU3voObPjL++rMpt5F5i9s4BsKaSZANiPwFoaljs3jLwQK6+ALYZbOsVW3GLqU6tXsretLfx0K4BzgPiqEG6azn7Cx3zMjp+aWSWGXnP0Fcoy/WbZyb3DqXDG+2ZZQE5tw6aM5S6HfE4lafc3zxAqBt+tPrboxY6lAvrYpjuxxb/NivzzAQ2IGNlNeQV8ciYS2jJPoq72f7Ybcf4LgnKhi76xT96wvd8CnWofZCKjfBDI4O8X+E98MsbhvGZh0LrDpNx+43eR+osgI7yW50RWBuBUJ0FAqdJQPlLdPYp24jc31KU0mWhhfmESwJ09v8UA9VZNnEen16Iz0IJp2YOf98q7eKrijRBiYNjnXFnWJlA2KKOBOo1bew2lvr6oFYyuWhKUQuI/a5g6xQzRRH4lil+qE5oz6CqKb0s4Ah4eZ5PBDR9fgFfb3JLBwGC5wsDvKGhzxd9I6vex3TBnzWr01blt7jgWttjahvGQjGM4qs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1d98a5-4998-4db0-5efc-08de2d9723d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2025 09:27:09.7750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H+2LtIEh0aUpExX2j8Se7wj2q2CdFFhSf7kLfPA+s3fsepcYmjWeg4BNttFhL7noC9W8qdzE/Sqert2ARDKUvjVzhx/Bk8ClOj/d5p29rJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511270068
X-Authority-Analysis: v=2.4 cv=QPJlhwLL c=1 sm=1 tr=0 ts=69281972 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wzW8d0FwaosA:10 a=YU3QZWNX-B8A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=mQvHCebiAAAA:8 a=SCef4Ec1CelfwKteTXYA:9 a=avxi3fN6y70A:10
 a=wsrb8zZI_WQ3QAEBCXTy:22
X-Proofpoint-GUID: sour03OoQkZrNLzElhmJWKqtH3WeTOvh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA2OCBTYWx0ZWRfX6lus9iCQGUWI
 MlwDNLyasKczkr2qhf8S6N6o7nYQg6/RniJOy92anB4YTe7xJHvscxCj50s6wSnVaKFEptxaDDG
 NoNXVdycYfgLwrRsKqRojOC0KmlB52OCNdwjz8QG1+LiqOMpynf5gpIqVbi0cApKnTx6KKjjtLu
 utro0PXM9Oe/zWtWR/6uYZ0lcNoBueZbjAm7o0l1S1MJ2k9qzdKVegexDFfPScoUAVpU5UDd7ba
 yKlLKF2BsmgQw+6er81LlnxmGAzEdwbukSS0Myy+gvHGuhmtqIGqGa8NkOODhLmDt1F2zMm6Nzl
 MhK9VhbqYe8d6mBMrdWStUHjRDhZ8noFAAbXWd3WeEU3xo7khbHTd5ehSwQ1aIaRR/loZyVr7xC
 jtaitrqmxnlMTYHnx5DxPGzAGwm4Hg==
X-Proofpoint-ORIG-GUID: sour03OoQkZrNLzElhmJWKqtH3WeTOvh

Hi John,


Confidential- Oracle Internal
+AD4- -----Original Message-----
+AD4- From: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4- Sent: Wednesday, November 26, 2025 5:24 PM
+AD4- To: Gulam Mohamed +ADw-gulam.mohamed+AEA-oracle.com+AD4AOw- Martin Pe=
tersen
+AD4- +ADw-martin.petersen+AEA-oracle.com+AD4AOw- linux-scsi+AEA-vger.kerne=
l.org+ADs- target-
+AD4- devel+AEA-vger.kernel.org
+AD4- Subject: Re: +AFs-PATCH 6.19/scsi-queue+AF0- scsi: target: core: Add =
emulation for
+AD4- REPORT+AF8-IDENTIFICATION+AF8-INFORMATION
+AD4-
+AD4-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   len +AD0- strscpy(buf, page, sizeof(buf))+ADs-
+AD4- +AD4APgA+- +-   if (len +AD4- 0) +AHs-
+AD4- +AD4APg-
+AD4- +AD4APg- Can you just return early if len is too short?
+AD4- +AD4- You mean to return before we check +ACI-if (len +AD4- 0)+ACI-?
+AD4-
+AD4- I'm not sure. It's just that the checks seem odd to me. Firstly could=
 you do a
+AD4- E2BIG check after strscpy (by checking len +ADw- 0)?
+AD4-
+AD4- I think that logically the following is the same, but it is slightly =
neater. Please
+AD4- check it.
+AD4-
+AD4-       if (strscpy(buf, page, sizeof(buf) +ADw- 0)
+AD4-               return -EOVERFLOW+ADs-
+AD4-       stripped +AD0- strstrip(buf)+ADs-
+AD4-       if (strlen(stripped) +AD4APQ- PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-L=
EN)
+AD4-               return -EOVERFLOW+ADs-
+AD4-
+AD4- +AD4-
Thanks John. I got it now. Will change it.

+AD4- +AD4APg-
+AD4- +AD4APgA+- +-           /+ACo- Strip any newline added from userspace=
. +ACo-/
+AD4- +AD4APgA+- +-           stripped +AD0- strstrip(buf)+ADs-
+AD4- +AD4APgA+- +-           len +AD0- strlen(stripped)+ADs-
+AD4- +AD4APgA+- +-   +AH0-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   if (len +ADw- 0 +AHwAfA- len +AD4APQ- PD+AF8-TEXT+AF8=
-ID+AF8-INFO+AF8-LEN) +AHs-
+AD4- +AD4APgA+- +-           pr+AF8-err(+ACI-Emulated peripheral device te=
xt id info exceeds+ACI-
+AD4- +AD4APgA+- +-                   +ACI- PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8=
-LEN: +ACI-
+AD4- +AD4APg- +AF8AXw-stringify(PD+AF8-TEXT+AF8-ID+AF8-INFO+AF8-LEN)
+AD4- +AD4APgA+- +-                   +ACIAXA-n+ACI-)+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- I think that this can all be a single line.
+AD4- +AD4APg-
+AD4- +AD4- Actually here I followed the existing code style. Mike also wan=
ted to restrict
+AD4- the columns per line to be 80.
+AD4- +AD4- Let me know if you want me to change this.
+AD4-
+AD4- The 80 char limit does not apply to strings, but you are using +AF8AX=
w-stringify (so a
+AD4- grey area). Please disregard my comment if you like.
Ok. +AF8AXw-stringify() converts to a string. Will include this in a single=
 line
+AD4-
+AD4- +AD4APgA+- +-           return -EOVERFLOW+ADs-
+AD4- +AD4APgA+- +-   +AH0-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   /+ACo-
+AD4- +AD4APgA+- +-    +ACo- Check to see if any active exports exist.  If =
they do exist, fail
+AD4- +AD4APgA+- +-    +ACo- here as changing this information on the fly (=
underneath the
+AD4- +AD4APgA+- +-    +ACo- initiator side OS dependent multipath code) co=
uld cause negative
+AD4- +AD4APgA+- +-    +ACo- effects.
+AD4- +AD4APgA+- +-    +ACo-/
+AD4- +AD4APgA+- +-   if (dev-+AD4-export+AF8-count) +AHs-
+AD4-
+AD4- ...
+AD4-
+AD4- +AD4APgA+- +-static sense+AF8-reason+AF8-t
+AD4- +AD4APgA+- +-spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-info(struct se+A=
F8-cmd +ACo-cmd, u8 +ACo-cdb) +AHs-
+AD4- +AD4APgA+- +-   struct se+AF8-device +ACo-dev +AD0- cmd-+AD4-se+AF8-d=
ev+ADs-
+AD4- +AD4APgA+- +-   unsigned char +ACo-buf+ADs-
+AD4- +AD4APgA+- +-   unsigned char +ACo-rbuf+ADs-
+AD4- +AD4APgA+- +-   u32 header+AF8-len +AD0- 4+ADs-
+AD4- +AD4APgA+- +-   u32 actual+AF8-data+AF8-len+ADs-
+AD4- +AD4APgA+- +-   u32 buf+AF8-len+ADs-
+AD4- +AD4APgA+- +-   u16 id+AF8-len+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   buf+AF8-len +AD0- get+AF8-unaligned+AF8-be32(+ACY-cdb=
+AFs-6+AF0-)+ADs-
+AD4- +AD4APgA+- +-   if (buf+AF8-len +ADw- header+AF8-len)
+AD4- +AD4APgA+- +-           return TCM+AF8-LOGICAL+AF8-UNIT+AF8-COMMUNICA=
TION+AF8-FAILURE+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- isn't there a limit of 512 bytes for code 10b?
+AD4- +AD4- Earlier I kept this as 512 bytes as the userspace is sending th=
e size as 512,
+AD4- but Mike pointed out the range mentioned in the specification.
+AD4- +AD4- So, If we see the Table 61 (Table 61 +IBQ- Identifying informat=
ion types) of
+AD4- +ACI-spc4r37+ACI-, it says 0-256 bytes for +ACI-Peripheral device tex=
t identifying
+AD4- information+ACI-.
+AD4- +AD4- Let me know your comments.
+AD4-
+AD4- ok, I was checking Peripheral device identifying information.
+AD4-
+AD4- +AD4APg-
+AD4- +AD4APg-   +AD4- +-+AD4- +-       id+AF8-len +AD0- strlen(dev-+AD4-t1=
0+AF8-wwn.pd+AF8-text+AF8-id+AF8-info)+ADs-
+AD4- +AD4APgA+- +-   if (id+AF8-len +AD4- 0)
+AD4- +AD4APgA+- +-           /+ACo- trailing null +ACo-/
+AD4- +AD4APgA+- +-           id+AF8-len +-+AD0- 1+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   actual+AF8-data+AF8-len +AD0- id+AF8-len +- header+AF=
8-len+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   if (actual+AF8-data+AF8-len +ADw- buf+AF8-len)
+AD4- +AD4APgA+- +-           buf+AF8-len +AD0- actual+AF8-data+AF8-len+ADs=
-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   buf +AD0- kzalloc(buf+AF8-len, GFP+AF8-KERNEL)+ADs-
+AD4- +AD4APgA+- +-   if (+ACE-buf) +AHs-
+AD4- +AD4APgA+- +-           pr+AF8-err(+ACI-Unable to allocate response b=
uffer for IDENTITY
+AD4- +AD4APg- INFO+AFw-n+ACI-)+ADs-
+AD4- +AD4APgA+- +-           return TCM+AF8-LOGICAL+AF8-UNIT+AF8-COMMUNICA=
TION+AF8-FAILURE+ADs-
+AD4- +AD4APgA+- +-   +AH0-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   scnprintf(+ACY-buf+AFs-header+AF8-len+AF0-, buf+AF8-l=
en - header+AF8-len, +ACIAJQ-s+ACI-,
+AD4- +AD4APgA+- +-            dev-+AD4-t10+AF8-wwn.pd+AF8-text+AF8-id+AF8-=
info)+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   put+AF8-unaligned+AF8-be16(id+AF8-len, +ACY-buf+AFs-2=
+AF0-)+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   rbuf +AD0- transport+AF8-kmap+AF8-data+AF8-sg(cmd)+AD=
s-
+AD4- +AD4APg-
+AD4- +AD4APg- is it really ok if this returns NULL?
+AD4- +AD4- I think its ok to return NULL.  We just don't send any informat=
ion. I kept it
+AD4- like this because I don't see any information defined by protocol whe=
n the
+AD4- memory mapping fails.
+AD4-
+AD4- If this fails, then we don't supply the pd+AF8-text+AF8-id+AF8-info b=
ut we are setting the
+AD4- len in the put+AF8-unaligned+AF8-be16(id+AF8-len, +ACY-buf+AFs-2+AF0-=
) call, which seems improper.
+AD4-
Ok. Returning an error seems to be the correct way.
+AD4- +AD4- Mike, Can you please correct me if I am missing anything?
+AD4- +AD4APg-
+AD4- +AD4APgA+- +-   if (rbuf) +AHs-
+AD4- +AD4APgA+- +-           memcpy(rbuf, buf, buf+AF8-len)+ADs-
+AD4- +AD4APgA+- +-           transport+AF8-kunmap+AF8-data+AF8-sg(cmd)+ADs=
-
+AD4- +AD4APgA+- +-   +AH0-
+AD4- +AD4APgA+- +-   kfree(buf)+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   target+AF8-complete+AF8-cmd+AF8-with+AF8-length(cmd, =
SAM+AF8-STAT+AF8-GOOD, buf+AF8-len)+ADs-
+AD4- +AD4APgA+- +-   return TCM+AF8-NO+AF8-SENSE+ADs-
+AD4- +AD4APgA+- +-+AH0-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-static sense+AF8-reason+AF8-t
+AD4- +AD4APgA+- +-spc+AF8-emulate+AF8-report+AF8-id+AF8-info(struct se+AF8=
-cmd +ACo-cmd) +AHs-
+AD4- +AD4APgA+- +-   u8 +ACo-cdb +AD0- cmd-+AD4-t+AF8-task+AF8-cdb+ADs-
+AD4- +AD4APgA+- +-   sense+AF8-reason+AF8-t rc+ADs-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   switch ((cdb+AFs-10+AF0- +AD4APg- 1)) +AHs-
+AD4- +AD4APgA+- +-   case 2:
+AD4- +AD4APgA+- +-           rc +AD0- spc+AF8-fill+AF8-pd+AF8-text+AF8-id+=
AF8-info(cmd, cdb)+ADs-
+AD4- +AD4APgA+- +-           break+ADs-
+AD4- +AD4APgA+- +-   default:
+AD4- +AD4APgA+- +-           return TCM+AF8-UNSUPPORTED+AF8-SCSI+AF8-OPCOD=
E+ADs-
+AD4- +AD4APgA+- +-   +AH0-
+AD4- +AD4APgA+- +-
+AD4- +AD4APgA+- +-   return rc+ADs-
+AD4- +AD4APg-
+AD4- +AD4APg- I don't know why default clause is required and not return r=
esult
+AD4- +AD4APg- from
+AD4- +AD4APg- spc+AF8-fill+AF8-pd+AF8-text+AF8-id+AF8-info() directly?
+AD4- +AD4-
+AD4- +AD4- Default case is to handle the incorrect information type. As of=
 now we are
+AD4- using the 10b code but in future, we may need to handle others.
+AD4-
+AD4- ok...

Will send the new version V2 after making all these changes and testing it.

Regards,
Gulam Mohamed.
