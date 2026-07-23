Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7242BC57;
	Thu, 23 Jul 2026 09:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799457; cv=fail; b=sDLsffviR59iq5bAOn5tovrGSCTchGRyzPCIw9yNNh5EkvTVkKEblEav2yFl5JZLIsH6KzdGuM2x7XrhW12slYMAwPjXQsx6TzMkQAX08u9rXKR2h3QDXnTbw7IMzz2JWtRq+9IUYYP46qC1AzfIc4z/fNOCI5FJK1pkExYiyvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799457; c=relaxed/simple;
	bh=kUFO+oDV5zQsT9o5YCWDJk6W7MGU6zfFoqQmU6X8sQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EURZZ3IHHPU4rcgW5Y6ny6aJAjGXJRDjEJDOD0eFjL8Qnr122c50qb97Xe9e5b5lLxc+VZEPQcNFF8t7YId6m+sicNDU/pMdx3elRxqkO7apaNPK/4U7O7lVyyn7ADItLbZE4EB2Bcy2jHIk4iI/0MdLSyg5dcwEf6tIrRudR1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AEU7JCvS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JctfvQPS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AEU7JCvS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JctfvQPS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJtfvW3573953;
	Thu, 23 Jul 2026 09:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xgaRse8ZbTfEZPQsWNd3PHir1B1w/jmQMD8p6NiVf4o=; b=
	AEU7JCvSJGqEcLhcS3aSVWXGTwVYksSst0TsHLGfa97sXljKQjtBPH9MH/QcQHO1
	D++vJ/iisnbNSh7efuLOeCFHXLUL0r8A8jv+A4559Xx24kwcw7uZ9Aip7UGKI0Yb
	kfR9qhSVRPA4zRmvKp6V4XCqA6hm3omGTts4UKML/uQpMr+11m731BcH3GaaUKjW
	wjPMzcw+dexh+D369bJ/71haxzA3RPpzzbU4pmoo5vd1hG7ydXa/AWpqEUpBPe4z
	Oj+4/+kzfFyl2QuDe1BWxwMWgM5qYgh08dRnPHjcWRVBaUK37F5Nf/GAlRBOVoHW
	YIR2CXMwnJs7WjR//nAFwA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqpqay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X95v003534;
	Thu, 23 Jul 2026 09:37:10 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010003.outbound.protection.outlook.com [52.101.85.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxen51n-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogKBCioExHS0VyFnNkJAtp/4dx6jznnKQApqCJ2dsYAbedk6kWb9L+GId4dYhjrVEKa/1kmScqhsgefcfBD4o3zTkTIfp+LFYoouzk0fAZZFKVPUWtXvlfuegt7rr3I4ZDIgabqWAqsS9p4qaWhR3H0DYu52H823IIlQf0LOZjfQMVeXe6HHr2lthZxJeXI/fAO0serfMbIYqfKf6zvLt29WtqnqF9kcmCEvPLeN0Koidzdj3Umr7dOR0FXnHIV+NSO4xF6+rB6DRhpsJHDkv5maRkmYZXrbRIf43k7zLHfJN9Lpa9JE6iTg/jMpaNT7FIzvrxGRSbeSKtieKL2Hfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgaRse8ZbTfEZPQsWNd3PHir1B1w/jmQMD8p6NiVf4o=;
 b=EGan8NClgJV87r89U3Z0Q5JYs9oZYxHBhEHXzNNDtpPRpRiJApZJBQAyMTGau6/WyBY4Be5V+/Zc9bLbzFD+C2vYvkqKg8ZSs/0eD4fooHBv+bbZjrvUTu7wuMzuRR7xx9MtDR40Q7BjSeACzk0BQepDunk4FZTfzlv1b+e9JCQT4BDEogRL2/CjFDCFSmBwyiu0oIOFo+1U3WVXO8DGYUGZqRmsZ89QaIsH/YddUrFpxfL1/S+hfX8pUtKDuD/FTmBNOru8lU5dcAYuK0WLTCG7ut0xNk55i6BqVI0neSEemclXQxJxTYuIWaAoFHa+VALT3zy78YURF49lM7EhLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgaRse8ZbTfEZPQsWNd3PHir1B1w/jmQMD8p6NiVf4o=;
 b=JctfvQPS2c5/VYK7BlTt0DvWjqDKgjF7YMNIyM+sz7fvNm2Z/oPn5g1BsDNcJM8jup3f9bSD4UWG6pvm0UYLQam1wt137NbElFHF1yRD4djm1akH6jMNMpfswL6ajP10Pe7Rv9lUzzjsF/7R6oa9+MIPfbA6hAoZyADS2v3oJ+k=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB4678.namprd10.prod.outlook.com (2603:10b6:510:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.10; Thu, 23 Jul 2026 09:37:03 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:02 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 09/28] libmultipath: Add support for block device IOCTL
Date: Thu, 23 Jul 2026 09:36:07 +0000
Message-ID: <20260723093627.2327456-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0030.namprd18.prod.outlook.com
 (2603:10b6:610:4f::40) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: fcfdc179-2159-4f79-e631-08dee89df34b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	sCUQhNSzjAjbg5CajC/2anpBjLWR4uzVjVl4NYLdNpthlJKkJKtc0MeQLj9XH/edNwAda6eHZ+SnjB66cWxvl3w00jNgbHkBT4ARD7F5FRsMg1yhTcGPB5nXW1YBFNXyfAHxR3WMC22TJUWgUWQQkVc9Zyb1WbGmN1AG0Em4VvZjBdHndvi4UPDWwLr5gKiH+GalzRs6OIxsTNCsT6nJG9Cul3Xp3JPxScR8d1L2bGo2S97lHTX8JluiJ5Dl/SRdl0Td9C/GBJfdUB4yGuSVtr9F0Tm7WchJ6u7FRbA0zvvhptSySMNlc7BvHJflv+QHgML3VRSA+/V6ChGWI+zAqRe8Q3wW3dGj0eqJHN0dHTaogXanBwgEwjMQqNjH00ZcflccKPZxm8I9QxrdZfv2F12tZwLi6yQ0zCA7qhvyuzasOiQtr/o2/md/PD+m2JSaCsXwJBKD35WoBDOUPTAzi4xmKsGfJyWo8QmbcHjGl9S+9CZikJHC4UfoBuLZaTY4HntTL4aUhN6qFpqdkwPAfoaIHU1KojCNn4yWvqP35fE5irTBzw8KDlzRhsvo5O1oWhyzvViduALmq0dN/LKSlAwfFKUYVoAq9OW6bOJnPjY99OG9SPk1Re3pwVl3L2HcKv0CAzl80GoMfyYSSTZuu2ONzZA5DAWfh4DXC6FOLrI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cGyMd3M/N06C2chPxg/T0Ep0nC6zGJyuiRN2X/xq6aBc5urz6EHu7ygQLevF?=
 =?us-ascii?Q?2G4Lg2RdKgZLnTw7+mjNB8D0nFWmVtmOTk+HfNehUf/X8HPWoOxM/+HeSRbN?=
 =?us-ascii?Q?LVgmAEgpLbXFT2PxenHRQRzwYrxkIpsc9j/crhDvBog4l92l7vPaofJnpRT6?=
 =?us-ascii?Q?b6t9Il1uSYLLC8gcGhtyPMgp7CTI8kggy4GUdtnFwqJOix/iXKNl4PJfh9kl?=
 =?us-ascii?Q?+KvbA+CGQchSNcwP6FxVFEQJ+oWhRk3iEErZANlgT/BMP/4m7r1+7u4ryEAI?=
 =?us-ascii?Q?s7Zow5+hhoq012l7hBd/NiKoktBwEkNJoAnanIQ3ntEQwJxLAPgSSdUwm7DX?=
 =?us-ascii?Q?M5wmrzhX2CqYJ91VZuC0VSnqAro3umOs7troXLRlAECUf/3IumtL/bgzWEtf?=
 =?us-ascii?Q?28Ob6lKoacG7x1ERMsemPxfs88iHIMBf1KTEps7LLToGontt9eIF6UA8R/Ro?=
 =?us-ascii?Q?/NhfIZtVtfEubPsTZBuXWRZDcfOkzzagTtihZr0icm530KOo6bVb5SG25FpR?=
 =?us-ascii?Q?3uwaz0AGh5hpAFuNXMfGIIsWjtAYanIhzTbLrgqBRuG/f+mNIQfkcqK729fo?=
 =?us-ascii?Q?1GoxWOW2MsiZ2SI2PakPXE8uEbiS4RBi8Njcrjcpfj+Kqw1nDSl6xcdeJZWu?=
 =?us-ascii?Q?N3zY65e++wLjYK6PPgbKtW/ZUpy8HsZuUP+6yMjcenapWcpFsCbdrqeF0dtY?=
 =?us-ascii?Q?5p7Bh7n3qx6PXdPP//M+5o9nVk8cf2LvVifbotUUjTIvV2E8McEwc7rcKzyJ?=
 =?us-ascii?Q?afKpibhCUwoDSwuwTytll02HCLHFhMBRfGBrNQXBqW6s9IBhv5WMVrwVRnxL?=
 =?us-ascii?Q?IYGG8jYx3tqKxe1pIOchDF/Kd+USR1y8cwwUQ0CQqEQyzguyToGCIJmJoAAl?=
 =?us-ascii?Q?zTb7umGQzZlg/+Ci26F2WBVEuiREuZ7kbFdAchxEAzt62BuA8KPORPvZpmLC?=
 =?us-ascii?Q?wTA7daJfKTkpPvIXhNganhzTJ3YiY8MweSp1WZsvlUvX2hxbxXsnBx66WCzV?=
 =?us-ascii?Q?ERvUBnmaFj0nUWS0hlcPRSgwDmHAZ4tExRkxcq6q2L5Gw1igqw4MpdYcFtV2?=
 =?us-ascii?Q?jzyshVH2nhaVwfYltD6qy2hKTTl+9hKWvvqwWIdaYdsisljDRGFCTDk7U8Gl?=
 =?us-ascii?Q?QAxD9rm2jslkVpIPqUvG0/NWN92lkboE5BjLBQYH74/inFq4YPDCWtLzf5FY?=
 =?us-ascii?Q?nFuJdGGhWZf8kn2IWUNXpFqkGT5emS+wPelFu91JbqHrAfO2R9VktllAMzAp?=
 =?us-ascii?Q?3PQxGP2umwwco3ugyjT63NON+TeLgYgw5DQBO1S7ZGsg3k/LsXCkU9T2kkPL?=
 =?us-ascii?Q?JLRAcCKgrDqDezS/aq5KvZsrJUjdjVp4ffYQd+jLqRUtCxc21is3AKeVjo/K?=
 =?us-ascii?Q?iZlMjSo+rNs2KVVCnfBpkfOf72VNEZvwBCQ5vtOhQQZS2NMg8ny0xqbtQeyI?=
 =?us-ascii?Q?FpXxtNQCoiHXF/Bj5DrWP4SxGMxOLiUFqBY75GYcNqENsI7b9z0RQ8EkjUKM?=
 =?us-ascii?Q?YPJ0MP5xLJoligEwx8d6rsAiMmVbbx7maPVS85Abk6L91kLd7OcdN1FLEzWc?=
 =?us-ascii?Q?siBnio2jUbmCcvPeglBqTZQ/0hp07eDUbo2rJc/jvinradrwk3l5jjkKKgid?=
 =?us-ascii?Q?ZqAJ19QjGtTMOJEDTvQvLlhdi1RO3gou9mrBbrQCfLFQoCGPjuRcy1w7Thq6?=
 =?us-ascii?Q?ywpC/uZrlHbDQH76XV6Vi7cW1eh4SGvfAv7/DEbCo+WXeeMJmNeVPy4EJMfK?=
 =?us-ascii?Q?sWMF1SuP1w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	aImsmQbxQJRA+oAVvbK/P+hI3qhlELkl3McTrv8yuHJ4neW7Of9pAVRqqdx0yQAwcX0j3PfHijHmMO2vdXKKK/OT4yjLNi2rrdXtojN+27MTge1tn/6pApOJMJDuqSqsHwgk2nkdrbXSgImmz3BOeSbGzgoXLDFl9kCkeKuKMIXx0ZEe1LzIONPQzqdRtATYTG0r1fdTbsTmD+qdzIYtbQ2pJq1ctOEDKNEmxGfE9SdzzUUwqZ1+uV2WMHuAo4Y+E7sgoxsPD578V530XhjDz1uwZmIL2WszktPUFAPgmpTdHJtlMfptzXlZLFUvJV/db4kIxVLJrPjE4wOiO0l/Kg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ei7hQ8vK+vUybJw6wczt0XRaWmMLonPnJPGIX2ElnierXJ0dvoNilSuCZe9lLnJOQC/fPqFSCKUE6npqnRR1/8U8qMl5OtfBAEKF+WQ+C/i+cXPEVaOvekLZ8Fo9zQ5SQOEiKbybWaWfWzh5p45rSRtV1r7L5dB5DU/qSGEtPXXIGKiAG8RF99+QF/s5coAgK7eEiYPbHJyeTL19LhhKef6OeiU2kPIEXyx+Ig4XC1iPdGSzf/XhhIx001ay3x7ke7O0/ihgP61zaDpV5U5A2HSGf+rOBWGnknjrL3xCCgnZ05KqihcZVP8yX6O+j3gW+6UFefsq1MImtbzrZlYf1P6tJy9GMpgC37R/gZDmrDs2gq5wmuB74nkaPdO/FWk+OjTCLwooHecNHPHNMAyDRSvKhXwPQ1cJE8WWcOTWNSWjlIrAYVflkYh9BuDzuu+wE20iDdiSbka8Yb5+of0R9qeirf1mPB+qPVzq4UwJ3ut5OIRu0jaTkD0VGc/ybc9gJfQT4IFFIqvaiAkKq6M2W6as2xof796FmvHHn8HsOH8mAUpy/u1A16F5FzFzo05OiQ3lPMoscQC8op5jviOZ0c0EvQaFNy9B+5PZFqLHIQ0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfdc179-2159-4f79-e631-08dee89df34b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:02.4780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VCcXffZIaDE4zDsQ9TMXGoXrwXjrvkD+Ocvh3c5A7ijfconD2HQDSPGvrS0HmnIyOu0UB9iUX8UNG19CIKu7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-ORIG-GUID: ZS2NtGRBxRGFIXZAHfOokrTfIofReEHi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX2Z/IR5/SNRMv
 YgwZxym5kp3gH3mVnzjRMrMmCe7ZEAKVd+VMQlSRT6+XwVJi7nWWgx504QD6Gwl8ERL+2yk/N3Z
 RABdHf7YwlRk8yiA9DOkUUxId6Ziw6Uur+qUDkM1ptSZcHvwOP5Gb58lKY79NBbmV2dZ64epypY
 L+WKFG5U59rfihrn+yEVrNBUTVNPM01Wl20qrtPL9oEZTToCX6IMCSh2apTipvixTPFsrk/l9tA
 Rh1LILnYznvMdgKIn6GBdoRoY9kpi5Llh8ruYBH3PNq71COdz2oHFovmmFXl0sg9LFelQwxK6X/
 z7I/Qt7VgJuvrJ5Ez1j7RUXLwyNoynBKTv94HK2zcqFDc84CrI5qZjYhoqka75aTqf4yeXJ1jd6
 Z2CI/bESTx8/sM1FqL6PRb8zauEw+Nb0xsr/rBOZLP2+txbmqe34xn5it/xCy/3lwgPRZYQBZPq
 f+QJ8cXjlGiNEoU2llA==
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61e0c7 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=DqrFQuEEK8k12kQt16YA:9
X-Proofpoint-GUID: ZS2NtGRBxRGFIXZAHfOokrTfIofReEHi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX5pu2zVVMCcl8
 OKnPd8M+WEVZ1x064ciS3V5rylhy8k04BxVcyY4ShULuTtIeAKPs8YsxvJd0RHvEupyU9D+Kot5
 7a4kCNpLVQrHnaSG3lo2xXe6nJRRARcP7zC0LqT/rdkRlb94QgI0

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_ioctl() as a multipath block device IOCTL handler. This
handler calls into the mpath_device bdev fops handler.

The .compat_ioctl handler is given the standard handler.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 lib/multipath.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index 0232f51f64742..fc8ba8fc501f1 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -478,11 +478,44 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	struct mpath_device *mpath_device;
+	int srcu_idx, err;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (!mpath_device) {
+		err = -EWOULDBLOCK;
+		goto out_unlock;
+	}
+
+	if (!mpath_device->disk->fops->ioctl) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	err = mpath_device->disk->fops->ioctl(
+			mpath_device->disk->part0, mode, cmd, arg);
+out_unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+	return err;
+}
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.ioctl		= mpath_bdev_ioctl,
+	/*
+	 * Both NVMe and SCSI use generic blkdev_compat_ptr_ioctl, so would
+	 * avoid their custom compat_ioctl implementation.
+	 */
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.report_zones	= mpath_bdev_report_zones,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

