Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C35D23E352;
	Wed, 12 Mar 2025 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741778401; cv=fail; b=ofpBmD522USiKVio3LSAkVr9H8RdZ2U2u4eHfd0CyHGclmY34R8gnGu7z4Aq3dQBToWIEOBvsmZqP5HOyrRfxSVdyGiByBnyfVQz6TO/cI3qA0FD/aoDE0Gm2FdwWGM0+NkT6vb99kAleSkYYe6yYPmEO8vzSnx3HnfkOJEy7uI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741778401; c=relaxed/simple;
	bh=+CUu1bhMq0zpZDxmwp3JYgUE+rKdFsGnKJnZvXNLjpA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LXQ0rgA7MBWs4xbwD+NPC95QOeaysC4wjx/59WTGPaHtPn6erJudWFLQcLSOu5ny+PMmCdOL9i/eVQWB7EMvNlCjkUiMT2JiS3VsaoKnAxux29Sea1OiL1srNqVectJRqniDlj5v9H/96wn4s3/Rsvhgc+IpaRzbZuOTOoMcGQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kfJPnVzc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wowVmjRe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfJPnVzc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wowVmjRe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52C1g4XS000790;
	Wed, 12 Mar 2025 11:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+CUu1bhMq0zpZDxmwp3JYgUE+rKdFsGnKJnZvXNLjpA=; b=
	kfJPnVzc4QmTIK1F+7BTYhryeZ14qVBiVSm9TuHebv/8gUxPTGq2CwlUdvGYYeo7
	I10MomompWlQCJ58lqOJg+rU/34Q3ewOhhi6VUIGdw8Q5K4fUwNDcReL9ARKWtbP
	vobZRQwHW8bPERX0jZc4541s2L5C8x/jNnNfs3onem0Bp6vTZJMsD9xj8BmsU7Kz
	m62pJfWRTAGWbglUl+V8ang9912E/Dw3+JE6UPQMnLCEnwA0PXqeKz/MmzzY9Siu
	33lTwEyS5cfX5m2i80YPbeMjDPGleJxhduWuagEBKhM+mFN2STv6sLbE8zLytSDu
	QAOgnRcRvAsGXwWfMPpWnQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au6vhfhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 11:19:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52CApBCB008591;
	Wed, 12 Mar 2025 11:19:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn35adm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 11:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P7qd625VzLsREoAGViU8vCYA8API9MahdmI6IIDJZpHmQ408H0R/DpKesTc60JTlU+89A+tQWe5uFey9TXEoY3v+pxqHQkxKCngqLiOIaF1uVrV9dy3DYHPsqQKpTyukxTHH6SfAsuOm9dphmAkAfPFK0CwLUeee27zbwB9fQ+yn+FpjDtRTG4Hy5KXduhaUSNGmV+es4Phiq2ZXPojlNEYgi6DSUD9LCRlIVHOu3ywnGh7HLG8MniP6zcVhHOMER2c4LNy13fXBNCfgnX2r+m+7cftQeq1Ow5FgXANVmngv/4vZMqlju0zxVFUex1q+OxxTX9/19cpTWBiN3AJd+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CUu1bhMq0zpZDxmwp3JYgUE+rKdFsGnKJnZvXNLjpA=;
 b=KgwwafwMLQGtZ7B4v6J/nU1qKktEVNS7ezQ3V2rzSjarT0SOQhX3uv0Z43vLVf8esoWadD77Y7mROQpEIzNejzC7Yj23KE+F/wPf6o2YbnRR3IqUGP/67ePHch+GEA5u0Z4fu0HTN9UUgPhuXpdN2IzE2fScPfH8Il824RvN5aqF0Vulv0qse4aNRaa+saAneo21akgNh3TARRUlLX63fsrdnmZw9W/8fydOLQq3YP+ong5XQ4bkEYbzrUjuAFwfuyglDYdvRErc7679lxmTWbIv2FeOATLFRDuD3vew9UIF1aoT2Jzsy4hMTxqeMSdtg7D0Jb6LdXJHrmUdlMGY2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CUu1bhMq0zpZDxmwp3JYgUE+rKdFsGnKJnZvXNLjpA=;
 b=wowVmjReXCIF8oktB+WUuFl4G5DLPakvOCBW0ZQt/W0OjFj+No85TxglTkevLn0uyMKNBVy9AQaY9UV8UQOZCwqwBNzQcf5GY6Vuz06Y5YrRbzx1HsxglLrqytuA3fYZjxfixdt1gvR7a3aPKxOhNqN8R+JlvP3Mqam5QQqakyI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4747.namprd10.prod.outlook.com (2603:10b6:806:110::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 11:19:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 11:19:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: yangxingui <yangxingui@huawei.com>,
        "liyihang9@huawei.com"
	<liyihang9@huawei.com>,
        "yanaijie@huawei.com" <yanaijie@huawei.com>
CC: "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen
	<martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "prime.zeng@huawei.com" <prime.zeng@huawei.com>,
        "liuyonglong@huawei.com"
	<liuyonglong@huawei.com>,
        "kangfenglong@huawei.com"
	<kangfenglong@huawei.com>,
        "liyangyang20@huawei.com"
	<liyangyang20@huawei.com>,
        "f.fangjian@huawei.com" <f.fangjian@huawei.com>,
        "xiabing14@h-partners.com" <xiabing14@h-partners.com>
Subject: RE: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
Thread-Topic: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
Thread-Index:
 AQHbg5hbfRFtBrJv4Umzg42H4A8aM7NQdIQAgACMxICABSPigIAAErSAgAAuFACAAA5ZgIAASSCAgACKEwCAAG0qgIAUv2cAgABNDQCAAp5ygIAAGmtQ
Date: Wed, 12 Mar 2025 11:19:25 +0000
Message-ID:
 <DM6PR10MB4313DA1A6DC01ED10D9D34D5B8D02@DM6PR10MB4313.namprd10.prod.outlook.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
 <d0a6b502-328b-2f83-3cdf-55c1effd80c1@huawei.com>
 <1fe3bb6b-1f7a-4188-83a3-f4c62e2a963d@oracle.com>
 <134681bd-0afa-a5cd-2e44-4f22db363734@huawei.com>
In-Reply-To: <134681bd-0afa-a5cd-2e44-4f22db363734@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR10MB4313:EE_|SA2PR10MB4747:EE_
x-ms-office365-filtering-correlation-id: d50d614f-1084-42f4-197f-08dd6157bf22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NnhWb0tBNHM4V0UwbU5SY2xBSjVRV2drZ1oxcGcwRVhHUjJad29MTmQ2Mmth?=
 =?utf-8?B?SldhQSt0ZjZzR0IzUzNEMHVyWU0zdkFka25QRWlMZUljTEY3L1M5ZWlrOTFO?=
 =?utf-8?B?MURBZHJWbzhaazNCclF5Zy9NTkNnOUc0RXdmMTZzQXVvTHdGU2hrRkVScG1D?=
 =?utf-8?B?UVRORWNhV0E4bGVjTU1GeTgvcmFrOXFXdGVqTTJaaTlYQlVGZFZBZDZLMmc3?=
 =?utf-8?B?ci85TXc1Q1ZqS3ZYbE43NkFHVHFYMjVQMndKdXdSTmF3cCt6Z3haanB0clli?=
 =?utf-8?B?Qmw2U0FwL21aUEp6ZXZYcHBKZk1IeUQ5WnZPS3R0Nit2ckREbjFxeWFoajFj?=
 =?utf-8?B?Z0p4NXNKaDFLQTlQemtGZGNUbFBPdzk1ak8wWGFZcTFXSkx3Y01WRUF5MVNh?=
 =?utf-8?B?RU5GNWptWndUL25OTEJYVGxCWlhOSWt2NXRyN3pUOE5pb1RMRFRMT1hETEw3?=
 =?utf-8?B?YVpSbHlFYkNCOFlpVGE2U3EyZ2NyWVlGNjNyM080ajhnU1R2TkpBMU5wbmJT?=
 =?utf-8?B?R0hYaUEwbWZWaDNmS1BZdGtvTXpjYlNhQ2IyRysyS1ROQ3RvSWY5bFB4Y3Bw?=
 =?utf-8?B?d2orcjkrZ1ZyWWc0WDVjQWhUSzI0ZW9EQVVSQXMrMGVHTGFBa3AwV0N3SElB?=
 =?utf-8?B?NDlsY3lzczA5UDhhcE96czVRUHdPTDVjSFNiMDh5eHFDY2NoK0EyMEpPcTFt?=
 =?utf-8?B?Skd6QVRYeW5CQVU0WklmTjNtTFdvU0hXSWh1enN4cEZWRm1GbHhmVFRMZjEr?=
 =?utf-8?B?dlFRWS9LOGNjUWxmNER6TTgrSlgzVUFUSm04OGhWUWxBekN6YmFZQXI3bVli?=
 =?utf-8?B?YUxhVVdILzhKVk5BSVRHb0cvbUM3bE5hSEowS1VELy9LY0tuZEVSZTdlcGlx?=
 =?utf-8?B?NWQ2RXZXek5YbTZZaG9RTVFvN3I5MVl6N1RPQW5UZXB4VncrSHdjMmlLWlJH?=
 =?utf-8?B?REFHYVBHSHJxN0Jacm9WUUdSV3dsUU40S0U2RVJwQytFN2gzME9WWFpkbVYr?=
 =?utf-8?B?MkpGb1NHY3Eya3F6endMN1M4RWtuNTlHeG5rdkEzcVYyMEd4MFN6Q1J3Ukpr?=
 =?utf-8?B?dmcyUGxLU2hnVDRxamwrL1o1b1BYcHpwMUtOK20zWFFDQVNVcnNaalYza3Bm?=
 =?utf-8?B?T0hvK29ZQm5vbGdFVnRwSzVkRVFBMzM2OUpsWlhLei83dytEMzJVYTBLdldZ?=
 =?utf-8?B?Vy9vd1F2Z2toeTdsbHpYdTl0QlhvZUFZK1FNV1laVkVUME92Y1Jad1REMUFi?=
 =?utf-8?B?YUdGalZvVDdPMTB4cDhVRlViQkFFeElqQ1dNU3dONklrZnNmR05uRm5CRW00?=
 =?utf-8?B?RTF4emx6d1BCUUFVeGU5L20zVi80QUFRczdjbXZpV1J4NFZDMjZKT2wrOFVq?=
 =?utf-8?B?SU5BK0N5Y2lYdU95Tjh4YkdkeFJha0twUStuMVZqdVBRbHJmUmFLVjg5VGNV?=
 =?utf-8?B?bDFBdDdVcmZBN3ZzcmVEcmxiY21RRnBVU3U4blgvb0FMRTlxOFpCUWJFaUE4?=
 =?utf-8?B?Y1QrOWVqak1vZWl3THcvTTM5WTdMdkM5SE43N3NDYTgzeGN4eHBHMlY5QU9O?=
 =?utf-8?B?YWpDRGxNbHQvbW9QVS84b3dyYjcvY3EvcG9FQW1UZTkydDhINlNXWGdHVEVv?=
 =?utf-8?B?OVBvenFEcEVMQnNuUkFzSEcrUlhJT3FrL1VvRVNMcUJSSWwrTXhJTHhEakJw?=
 =?utf-8?B?bVNEaEVuUGFqNmxVTW1HeHVldjFJS3BnZzlUV2lUNFRvOXliUWxuRm1BZUlr?=
 =?utf-8?B?YjA4WVNCaUk4OGo5azY1Y1FsalV1WGpIdFJCVjhUeEZub2RkdHljOGZrM3Yz?=
 =?utf-8?B?Mk5oN1J5djdtc0tpYzNINm80dmozcWFFaUZvK3BpaGRVRnBMajFlbUZKY0dW?=
 =?utf-8?B?anVpbDhxelNTM2dabmtNRmh2QTNrbE5nT3dNTGtUNUE4UEFJbEZDVG5XQThF?=
 =?utf-8?Q?nEHarlNAxRRhJDRErcT84UezNJiJkASr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Um9kd2JPRXRnbmpuMytNQnJFN1BKT283UFdvU3Q0V0NhTEZtdXg1WHluZG9u?=
 =?utf-8?B?cFFEajFvMm0rcTJTby8xWDVuOFFNVldHalUrRHFRa3g5djV1OER5alNUOHZ6?=
 =?utf-8?B?djc2a1lHdVd2aGdrNWFHTjBRcS9pdmdvbUtWUWlZT1VNR1piMjBwRmdRT2xO?=
 =?utf-8?B?OWxOZUFVYTJPdllGdVJLUTBBOG9ZbG1YU2ZoVmdxMzJIeUlJZG4zWFB2YWpN?=
 =?utf-8?B?ck9UZ1kvbFZmWFpCV2RtZldmQ0FCZkhwY0s0QTZ6alU4TzdYSmFYbllXUmhm?=
 =?utf-8?B?OGpVeXBNcUxjbTMxc0ZVQWd3d21uRGZ6L2pTNjl2ZGl5U0IrNi91NVNsTDF3?=
 =?utf-8?B?YXVyOXFJQ0Z5a1NzUmhLNWV0NXJhbDNsMS9PTzBEZklqMlFJemwwckNvZGsr?=
 =?utf-8?B?dG9BRStSYTZxYzNMeFVITUVLQUZ5cWJobjBGYjh6c3piNXBjUXBKYTNoKyta?=
 =?utf-8?B?cEpuN3FpbHV6c3VsS2NOYmhiK25Ka0tUSjJCbzFqbS9SMWl4dUZBZDdXckM2?=
 =?utf-8?B?WEVibG1CNUdvNXJ4WHZPeDVwbDhYWGIyTEdlcEdjMkxrOWxHR0lod25HN2Vy?=
 =?utf-8?B?V3NDR2ZzZnEyQS9uMzZkQmtpNHpVWjVJTzg5dXhKSUU1bGhBS01QTnRJcWM2?=
 =?utf-8?B?Nm1GZm05Mk0vRFZ3TEcvSHZnT2QrTmFxQTMzZTd2d1o3MHY5eTBYVmFld0hL?=
 =?utf-8?B?cEU5VExqYko0clBabDE2RnpSZWZ2dEFYVytDYWp5TGNodFl5M0UwazNMVXZq?=
 =?utf-8?B?NG9pMEZQTWlqV1o5N3lHZWFlTXdtZW5ndE1La1JPM2psczR0ZUdZR3RqMEJ4?=
 =?utf-8?B?OWprcFlEaFNIdkxPVUl1eExRbytmditUNDFnelBZUUpobUU4clExZXl4ZUcw?=
 =?utf-8?B?Nk1WYUxLVmIyUGZneXBVUktmdFkrYzY0MXBCWEZDWDBxcmNWeUQxbjZXbVRQ?=
 =?utf-8?B?UzBmdUxEQ2trOTkvd3VQdHV4akdEYW9Cc2RQK1ArMzVlSHE4cjN1b2VpTTVP?=
 =?utf-8?B?dVJSS0tjWXhDSHdWY2VRclJSUEplaFE4UUttMXNPWnhlTUNBSDBKbm5wVjhy?=
 =?utf-8?B?NjYyb1RDV1pnNHh0clVzVDV1QThhV1IyUFB6SmRIUFkvTFJPdWdUQ2MyZTV4?=
 =?utf-8?B?aTNYeTBweUp5cThXQ05QNTMweFJDWExNVk52WnIxNTFmeDVNcmZWR1VDcnFl?=
 =?utf-8?B?V2k3U0ZoME0wR2FDVXZ0SFFabHBUd1o1cjkvUlhkbXRYQlBaeDByMkdPaXV2?=
 =?utf-8?B?VGozVVJNSlUwUWtUd09DK01aSXpZZVg5TldMeUU3YmRGb29EbmN0WUxJREdX?=
 =?utf-8?B?aFJnQkdvQVpZOFBnWHpGbUdZemVkOVk2RU1LcWFVb2dHeFVkSm9teFJra2VZ?=
 =?utf-8?B?RCt4cGJldGsyVlY1SkU2MUsreTlhR3pEbnBTSnprYmRDdlFudmZUYTNGaEYw?=
 =?utf-8?B?U0cySWp2NkNkUDUyVmRDbGQvWENUZnk0YVR1Um02ODlaSy93eXZkMi8zckty?=
 =?utf-8?B?emlPUkdnd3U2NVdvb3ZPSUN6dVR5cEZJWFVSREo4UGptWFpDdUNFYkxLRE4x?=
 =?utf-8?B?VzZOQ1VZUFB5a3pXYmlmY04yRnVzZ1R2dlRtc3Vta0pxQlZlZXBOb20rdDdv?=
 =?utf-8?B?VVJoaWtUYWZxdCt1TExkRW1mbUhvdjEvSXJka2VXL2ZObzFtdjJkdTZSaTB6?=
 =?utf-8?B?bXNUZVpoL3NNSm9xMDRxUTBtK3BDRkx5d2RlZEdhOWRGTmVoS080Z2k1THlF?=
 =?utf-8?B?S0xOak8yTTQ0ZGxTZ21OQWtLZCtZL01ESXl4LzNsajVRSnkyM0ZRZ2hpaHZp?=
 =?utf-8?B?eitGYXVJREMydG1pNjFLdWtGUFpsQ21nM0k3cVViNzMwQ0w3NzBIMnhCZkpt?=
 =?utf-8?B?QUF2NlFnUFY2cGd6eEk3UXNtRHY4bXMwUVlzb3lPTkczL2ZPdEI4dkJGZUt5?=
 =?utf-8?B?ZURDMWN3b2NXQk4zK2pKYnY4VjhOYmVmMm9ac1R6bHgzYytYS0NVNkVCLzY0?=
 =?utf-8?B?dm5VcUE2ZGs0S0x4N3pDSzl1SUFmQkFjY3phRG5BTUJrSHlFWVdTWW0weTVt?=
 =?utf-8?B?UEFyVmIwT0U5Z2ppU3pabGp1Slk5eUFDS1BPeE9KaW51Sk00WDlQM2syVVNY?=
 =?utf-8?Q?eJMdl4OnMHgAYm1oB54Cxy0RJ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	le/DjLrNm1dtRCEEx/GYVGXpEd2ib7QZAPcf4qTHaYZ6I2FJ10JTn7UDxdhqc8liOguPqcdN5yiuObQWcerTXnNa3yRDpm+i/1696KMT7P/zprTKMrhIJ4yNhCT/eVNLQphvqTLOqWWRKKQAeycpY0uTQAiDufn0wdnBvaiIcBM4gmt0kPseulu9X4FxSpLxNdsuLK4b7jnjMZprSYQx2Jg5YbauceRAmTvZj83DeARiI9n/VyviKjkrCES+yIka1dbJKwDdsfie52C9rallXclTmvczxoU56bh/p3DB212PfcBf++wC1a91EyRrSLth/ZUvexW+C6zIEjr9OJ/s/kpn3iTkFysKkzmjwkNBkxZwl3QmJJo0s2KbUif1/k/i2voPlaLufBVWaG/gMI/kzI0Ig+fK11wC8V26Rvpo7cBSdA0uoNrOw6Z7HA3rIAypAHi+naK4/nqG86v0W85Wl7o94gE33MZ8tXXtP6xCcZ8mRiMPx66krON48omMh3ONarpyFyf90dA9HbzRR4g/wUe7ninjHEhNxaUMp09VYhn4dibwJ5JNHXYSsy4HpflorLx8JRI4UZdn77negHiW2NZ9FSpO/vzY4L7B5V5iM60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50d614f-1084-42f4-197f-08dd6157bf22
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2025 11:19:25.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GxMBRJbeQNV16KOXmgEwz1+2EjBX5aoTEV0EA5y0JP1PdZu2AlKAy/7mJMXAy8CtMU8f60G5LVIL8Wj85vtSGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-12_04,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=678 mlxscore=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503120079
X-Proofpoint-GUID: avpIE26UwuTYE064tFxS7Vd8e7DNfAF0
X-Proofpoint-ORIG-GUID: avpIE26UwuTYE064tFxS7Vd8e7DNfAF0

SSdsbCBoYXZlIGEgbG9vayB3aGVuIEkgZ2V0IGEgY2hhbmNlDQoNCi0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQpGcm9tOiB5YW5neGluZ3VpIDx5YW5neGluZ3VpQGh1YXdlaS5jb20+IA0KU2Vu
dDogV2VkbmVzZGF5LCBNYXJjaCAxMiwgMjAyNSA5OjQ1IEFNDQpUbzogSm9obiBHYXJyeSA8am9o
bi5nLmdhcnJ5QG9yYWNsZS5jb20+OyBsaXlpaGFuZzlAaHVhd2VpLmNvbTsgeWFuYWlqaWVAaHVh
d2VpLmNvbQ0KQ2M6IGplamJAbGludXguaWJtLmNvbTsgTWFydGluIFBldGVyc2VuIDxtYXJ0aW4u
cGV0ZXJzZW5Ab3JhY2xlLmNvbT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eGFybUBodWF3ZWkuY29tOyBwcmltZS56ZW5nQGh1
YXdlaS5jb207IGxpdXlvbmdsb25nQGh1YXdlaS5jb207IGthbmdmZW5nbG9uZ0BodWF3ZWkuY29t
OyBsaXlhbmd5YW5nMjBAaHVhd2VpLmNvbTsgZi5mYW5namlhbkBodWF3ZWkuY29tOyB4aWFiaW5n
MTRAaC1wYXJ0bmVycy5jb20NClN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgMS8zXSBzY3NpOiBoaXNp
X3NhczogRW5hYmxlIGZvcmNlIHBoeSB3aGVuIFNBVEEgZGlzayBkaXJlY3RseSBjb25uZWN0ZWQN
Cg0KSGksIEpvaG4NCg0KT24gMjAyNS8zLzExIDE6NDUsIEpvaG4gR2Fycnkgd3JvdGU6DQo+IE9u
IDEwLzAzLzIwMjUgMTM6MDksIHlhbmd4aW5ndWkgd3JvdGU6DQo+PiBPbiAyMDI1LzIvMjUgMTY6
MTksIEpvaG4gR2Fycnkgd3JvdGU6DQo+Pj4gT24gMjUvMDIvMjAyNSAwMTo0OCwgeWFuZ3hpbmd1
aSB3cm90ZToNCj4+Pj4+DQo+Pj4+Pg0KPj4+Pj4gcG04MDAxIHNlbmRzIHNhc19ub3RpZnlfcG9y
dF9ldmVudChzYXNfcGh5LCBQT1JURV9MSU5LX1JFU0VUX0VSUiwpIA0KPj4+Pj4gbGluayByZXNl
dCBlcnJvcnMgLSBjYW4geW91IGNvbnNpZGVyIGRvaW5nIHRoYXQgaW4gDQo+Pj4+PiBoaXNpX3Nh
c191cGRhdGVfcG9ydF9pZCgpIHdoZW4geW91IGZpbmQgYW4gaW5jb25zdGFudCBwb3J0IGlkPw0K
Pj4+PiBDdXJyZW50bHkgZHVyaW5nIHBoeXVwLCB0aGUgaHcgcG9ydCBpZCBtYXkgY2hhbmdlLCBh
bmQgdGhlIA0KPj4+PiBjb3JyZXNwb25kaW5nIGhpc2lfc2FzX3BvcnQuaWQgYW5kIHRoZSBwb3J0
IGlkIGluIGl0Y3QgYXJlIG5vdCANCj4+Pj4gdXBkYXRlZCBzeW5jaHJvbm91c2x5LiBUaGUgcHJv
YmxlbSBjYXVzZWQgaXMgbm90IGEgbGluayBlcnJvciwgc28gd2UgDQo+Pj4+IGRvbid0IG5lZWQg
ZGVmb3JtIHBvcnQsIGp1c3QgdXBkYXRlIHRoZSBwb3J0IGlkIHdoZW4gcGh5dXAuDQo+Pj4NCj4+
PiBTdXJlLCBidXQgSSBhbSBqdXN0IHRyeWluZyB0byBrZWVwIHRoaXMgc2ltcGxlLiBJZiB5b3Ug
ZGVmb3JtIGFuZCANCj4+PiByZWZvcm0gdGhlIHBvcnQgLSBhbmQgc28gbG9zZSBhbmQgZmluZCB0
aGUgZGlzayAod2hpY2ggZG9lcyB0aGUgaXRjdCANCj4+PiBjb25maWcpIC0gd2lsbCB0aGF0IHNv
bHZlIHRoZSBwcm9ibGVtPw0KPj4+DQo+PiBXZSBmb3VuZCB0aGF0IHdlIG5lZWQgdG8gcGVyZm9y
bSBsb3NlIGFuZCBmaW5kIGZvciBhbGwgZGV2aWNlcyBvbiB0aGUgDQo+PiBwb3J0IGluY2x1ZGlu
ZyB0aGUgbG9jYWwgcGh5IGFuZCB0aGUgcmVtb3RlIHBoeS4gVGhpcyBwcm9jZXNzIHN0aWxsIA0K
Pj4gcmVxdWlyZXMgdHJhdmVyc2luZyB0aGUgcGh5IGluZm9ybWF0aW9uIGNvcnJlc3BvbmRpbmcg
dG8gYWxsIGRldmljZXMgDQo+PiB0byByZXNldCBhbmQgaXQgaXMgYWxzbyBuZWNlc3NhcnkgdG8g
Y29uc2lkZXIgdGhhdCB0aGVyZSBpcyBhIHJhY2UgDQo+PiBiZXR3ZWVuIGRldmljZSByZW1vdmFs
IGFuZCB0aGUgY3VycmVudCBwcm9jZXNzLsKgIGl0IGxvb2tzIHNpbWlsYXIgdG8gDQo+PiBzb2x1
dGlvbiBvZiB1cGRhdGUgcG9ydCBpZCBkaXJlY3RseS4gQW5kIHRoZXJlIHdpbGwgYmUgdGhlIHBy
b2JsZW0gDQo+PiBtZW50aW9uZWQgYWJvdmUuIGUuZywgZHVyaW5nIGVycm9yIGhhbmRsaW5nLCB0
aGUgcmVjb3Zlcnkgc3RhdGUgd2lsbCANCj4+IGxhc3QgZm9yIG1vcmUgdGhhbiAxNSBzZWNvbmRz
LCBhZmZlY3RpbmcgdGhlIHBlcmZvcm1hbmNlIG9mIG90aGVyIA0KPj4gZGlza3Mgb24gdGhlIHNh
bWUgaG9zdC4NCj4gDQo+IEhvdyBkbyB5b3UgZXZlbiBkZXRlY3QgdGhlIHBvcnQgaWQgaW5jb25z
aXN0ZW5jeSBmb3IgdGhlIGRldmljZSBhdHRhY2hlZCANCj4gYXQgdGhlIHJlbW90ZSBwaHk/IEZv
ciB0aGlzIHNlcmllcywgeW91IGNvdWxkIGRldGVjdCBpdCBhdCB0aGUgcGh5IA0KPiB1cC9kb3du
IGhhbmRsZXIgZm9yIHRoZSBkaXJlY3RseSBhdHRhY2hlZCBkZXZpY2UgLSBob3cgd291bGQgaXQg
YmUgDQo+IHRyaWdnZXJlZCBmb3IgdGhlIHJlbW90ZSBwaHk/DQoNClRoZSBjdXJyZW50IHByb2Js
ZW0gd2UgYXJlIGZhY2luZyBvbmx5IGludm9sdmVzIGRpcmVjdGx5IGF0dGFjaGVkIA0KZGV2aWNl
cy4gYSBuZXcgdmVyc2lvbiBiYXNlZCBvbiB5b3VyIHN1Z2dlc3Rpb24uDQoNClRoYW5rcywNClhp
bmd1aQ0K
