Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F363E36683B;
	Mon, 27 Jul 2026 14:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163501; cv=fail; b=bp9usZCmJBRk/IN3fZ274X5urMEMWJYbqy8Q2h90SsBcZ7qZdYrosEnoTq8B2AewYeoj9cvF7t8zJ1V/317IcmFWVmn/x1jpcm4G8qoW9sulahdXH0wUHPsiThEayjz3Gr9+oZ41Y8hzwpaAZHT8+iJ5LwRRaj45eZLioe5DXGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163501; c=relaxed/simple;
	bh=4XMYoenVRcfywgZiUXxmJDFt29QOdkYWaCo7hrGcoOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L32hROkRgZHlXZ37mJhvRBaVivFyC5nxcdYxAvm/9Hcd1LU1AFEbRvYMr0VA0pvFggFH+XlQ3iIDPqcDL95yaYxFwcKxk/AMscPTDkZLMWi0x4x7X4wb7z+GU26pk40TLysTI4v37b/9RZ/i1b6J+rmU8kO+97pZZtI5tHqnGmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FoiLAycJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u0gwKN7E; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FoiLAycJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u0gwKN7E"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTHAI2105347;
	Mon, 27 Jul 2026 14:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=; b=
	FoiLAycJv2lWv25lXpI+5e1R7qpkTq/DIsMBXZ+QfnNxzM+kl36ARtw9JeKVPM8h
	H/oyss09GPWS0Y8N78WI5r3bEgEUr5BwBLEv++Sg1MnPudQKTcvgY4ez6+t18+0b
	R6KeyfsLU5Iujnqvl4+aZA2xqy+wj0kFszJdnICd/LcJtjCshPQbiQrE+8Xai7LY
	LzhepKzz9dVaK8NLgE3qLAUrXNd+5Z8wO0/gFkytnkJINcb/+EY5LGwI4VXwxWqE
	FaRaTo6SshVCDz/Gvo7qcsYksV2oHJpWPT8OC5+y6/vNPKe8m+K8euhWqxLLH1OZ
	JI0QYk4GvrDySFqZ+Mwq0g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nhxgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REZi7U023434;
	Mon, 27 Jul 2026 14:43:37 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ngw21-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wlqtsreiKclJWBLW0RByBDskmH5eSW2PafUZ3HP+RWWF8pban6Ob6DX+TV4fEq/z6/9dfqQppyQebmR85397kCtBeMETWs+CAa7snSdbmgUiCQdPV5+uzSUFz/Xnan4siUNGamQsjPA9S3iaLc2MKMA3KZ2skvniwGk2NRObVLll2GdY4DAI1FhotdZmGh6yvrQJJCBph1DZQpQtkZjiWxp2yqb8t5fOHzaSfbx7NnUonT1TwkBRSRLqxRJrNpT1/Jo9FNOEkQhbLbVvHPHkgtyvCafMFyItR8+SJ4VjtCY5L/9xAG1c2TKw0K4LOv2EuYoEBfphQFzVI4LgxrtwZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=;
 b=qRAu7MwCH4SoHlpe+XyCbEagkX8zJfGFHw+ZtK63tcdNiGZ1D018NNQswn8ERjNb25Wa5CRjFUEnY7Ti8eyqZb7F1rBm2zazLH412PkxyFO2C+vO39GCfdST8CTXTm6Wmke78lX+usXWMhwWhf/3gJHPp0tppBwrKjMeGyFa4tgqs7vU2fvlU+ihFj0q0GnPIDsenuoE7Pt6CrxYN2WFCLzzuBgwic/DBuNF4rraOuhLT8f1/nwB2QeWLUStTVZqfS6cjQbBFiVaM1PqvdbcRZzm089vIigwpfWoOLn6gRAgnjon7tFKK88F17r3pNKco9j84hSmXB5tnCEk5QjgAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElGmHuIthoiXbN6Q2TtStK4Zvyvr9ugP8CjmseLjHQA=;
 b=u0gwKN7EY0NJTCvsTh8IN0+Rg6AM06dFpTSROzwj0XaLelYWQjVluoHiojcUbKmPTvYJI+9JWvTAJPzbxW0KBBwimdd6/WFJAvYzeaSeRR9zzjbQH1XdUE3JC19fJKud0ft1QW4iznggEFHaER7iNvRuldZm9Km+GdUDh9dwno8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:33 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:32 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 23/27] scsi: sd: add multipath disk attr groups
Date: Mon, 27 Jul 2026 14:42:30 +0000
Message-ID: <20260727144234.3802948-24-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0237.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::32) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: f1e351a0-6a82-4d2a-98e4-08deebed6e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|10067099003|6133799003|20046099003|18096099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7np+wczxFCzXM3hxbstjabe8Po6cuTL1Xl6BQOLJC6zMc/4TrwHQpIRVrlCswHSdmi0w7BHhSDEpMRZ2WJxtQDZ5Xyr4DSKdNVBO2FdVhBhHLDl+hdkRVebF7dKZ1vRbBkYcizUVkk5zQk3hZ+u8aPRarrwm9mBwmZP6Ew9kwKJLq4lSsVGG0MYLRzavGf24RP9rv2CxqXXDHdgHisLK2Rp05oghnhK1z2UMbT50hpoPeWS5LKu7t8dBe0JGp0/M2hELG2tsR32MgqN0CS9NmUuyv4OPwEijw2V82KhEGwugv7FILnQQIqMofePY669qfa76qNHXEWvUHkBUzjLzOYu7lP6qQeHUU/q/9lFII68MGGN6PUkdqcDNlNK1+cIpzuJ+NXTRT6xUHSVRRcrEB0IQ1QZkYuX5dpT673DMtYkin1QEKyqvQkIhVcxSl9nWqJrrRIb+JLuE1xRSUhBvz377jOPSUtbH8/cPIt9c9edXVLzS/kZEO5pbO+tpSS0unl9vVXjIhMpGti7tCvnLi11DFqSYayEmUIXJxh0sVT6Hw8f/WlIclJO7GMcN77atyDr8l27bpa3ysex33wQYxmHLnSq1pWhwIWFUgw2Xwbqb9pmeLOpmACJsqqSrUhlETLrnz15d5JYxCbaWU2ejm3A0posJvzRjEvU4RAFgSVU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(10067099003)(6133799003)(20046099003)(18096099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gy8jeK4/FMYw4zDF8nTpLUAzpC79lEQT6wrfMVE9kKC1c3prBRc8WjSK7zuH?=
 =?us-ascii?Q?qyu3/x+u54OWa1OyuAPxnROeu3V8A3UD0rnRqUGvCPQj4krYPqeZJcHH3Q0C?=
 =?us-ascii?Q?Ltz9T6V3dAdJE+xs1MsjjbkHwn3wCLKwWKAx/hD7O+gGK1kRI33OPWKWHG10?=
 =?us-ascii?Q?cefolBSY1s57rWwPv8mKUZYB+qQH2TaB7owm6LZDrLCRwcPZl1kgcW6Wt92+?=
 =?us-ascii?Q?QD2H7PW+mA6gQC5Aug9Mk3LvW3+X2JA+mIfPaM3rkn/EHVqQvClcMAOo7IVk?=
 =?us-ascii?Q?F6UJ8wTAI31FEm6CuzmCIdmFWtrQbHy6lKKvc0J/fZFOuceyFiyWc2qReN6o?=
 =?us-ascii?Q?tEOFGpn0PqMYk/OqYpebZ9H66B4Dr+xeIAusOY52Opy5gdjVId/lx9wjhXRW?=
 =?us-ascii?Q?UMts5BMXJMRtZmMT8+/6Xd9MhrTWtN0cG7UVdsBIJnm5UfcZNZpD5+nAj9nN?=
 =?us-ascii?Q?xQY2HI1y+bxkmgxMX4SFYhV9dABi5qVsoFZY4Wjmyd4eAzjIEkDMFcslHzxg?=
 =?us-ascii?Q?JnUwF9g8+XH5hjnIpG11OFNUw86EL30Csd3TgTXr/r57iTdvL0t4fQEU5QNq?=
 =?us-ascii?Q?mtn2Kb1/yGG9IM1tRd5vNq1kvRKg4/XhpLRaY4lBfPVPjTaB1fQHeUagcJvd?=
 =?us-ascii?Q?J3m3O4GHsXn0qQ3vzaqVK4nCNZGFpzjPcihuyPCM/Lr1wiRoz/uZEROfUyR0?=
 =?us-ascii?Q?vg3/GZMVWD3qzkb9tuGxo9nuD+Lcd2rc8mzhJerRUMcwpYR+TFU77cwykz9O?=
 =?us-ascii?Q?0h5qKhgjfhTTrHY508g7hv3Nl1S/DoAZl1hCh5YrrEsT90BsEFK58UCAjXsn?=
 =?us-ascii?Q?WIpEk7Mk5c8NBiikolVHrKOEyTIVgZV7p/1SRSpu73JMXiRPjtkChbenCa9u?=
 =?us-ascii?Q?fQexUhkLipN7NPgfGPJ3TIOTl4LxuwGzWmJX4ajE5j2tj8Yjb3W27oDEDBnd?=
 =?us-ascii?Q?1sjKNMNvEwQZfUwnePubI0RvsbdF7WfxQJFatWi3CeUUDNKvEfp5Uhi9wfTi?=
 =?us-ascii?Q?5WBD5oVA7uTsn655ctJGYPyLVEXmZtU74A+OiJBtD2VhtH6QQXchffJLT7+I?=
 =?us-ascii?Q?br6ZRQe3iBDG9qPXQs/vpNlLPPwU+i4oOafVQaLgJxIXy8PsAcZ05ilT9g9e?=
 =?us-ascii?Q?G/eASPQuNiGdH5uwzrsTSFIon/j7iRxGOHsisJa3uv+HsVOSFwhYpsYnuE29?=
 =?us-ascii?Q?iXCYL6u/rdG3VodscmJcEw58+0jWCgPh4z5gUsjlaMgyr6BeI48GqMNhPjzZ?=
 =?us-ascii?Q?4PpcLlieVj6Jzoazz4p36SkNUi7+LWcvVgRbBrcKOabhRl+yrqmNNMC2BQCa?=
 =?us-ascii?Q?o/Uy6pwbTv43ZzaRo9B2LItjNwVd0gRe7DggV3ETjbz6A5sbu7J7YGqnRV2I?=
 =?us-ascii?Q?8zVsFQgC9ZB3xucy+lqNJNjwG6oqfafOiyEqmkxmtEZ1W5isIc3lh0WFNJhc?=
 =?us-ascii?Q?h7J1wRLc/SA8PB0SGz1VmCZEwpGzhbRVPq8MRbFLlEIvlcCv34SRV58Jye8a?=
 =?us-ascii?Q?pWQoFbwCiudLHpu5h0M8JLG69tyXBO7CxWztXzqIODSujAbCG52mXS1vTxYT?=
 =?us-ascii?Q?9eiBvagg3rZAV+hu82emsMEHpvtOLY6v9VMxLoZuLVAFSBAPv+3FEX+Dd7Tr?=
 =?us-ascii?Q?WX/Nihwsp3U9TFbZ7q54QzQ+AeJ0xrmVZD7+Xs2hoyICO7r4fe+6SeB1n7re?=
 =?us-ascii?Q?XBhj+X6fIFzQCUalufQjr6NsaajcN0mPuUbmiMbUWlnSpUze0AiSRPkGAjiG?=
 =?us-ascii?Q?E0VIRVhE9lIESCgo6cwIaTfn8mAzakY=3D?=
X-Exchange-RoutingPolicyChecked:
	sK1CJjdo3p/DIRTRLou8MN+iP/IsnnLNjhNZRCVbCATQ3iMOVuT6SRjK3FOadjm+y1jU61NRH/ByVG4xSHZRKiXzzeQokK0T935G+hWXYFa7TZFBkm938hQAZCJvhivYI8LfoukH+orJM0fdfTn4iVMwElYTTaH3YHYOdU28YKAgJCxErEMBYgVTljMhud95GlJpaSqbAoyoGb0y+G9TfVTCyDOWMVJEpkN24KmWwXsAozU2fHxd0LuaQqw0gCpP+vzOVdOz1ITb9TQBJXQWPosF7Np+UQv9DHsuEaQjCpiNa8INn7E1HfK5GERthheDGHbQhdn9HJzukFcNIbRphA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8CqXjkiSKzhuhmlYfW2SPLM6x0hVo66bUH96PLfF7ErtIVn6CeVGAdjpBAnrR4QsG8ZSrLtR6sThJPYbkl1ArpdCdSIn6miKI8i66D/dZ38bus2Smpl81/D50iNoVk0PznMm5OZTF5VHE4GzgpAfN5fTo3MoKwgffbhDR4wO0wwSZj4MjQRz4NITBvcLkKaRelvUh6WK9T0PXoC3JiY4VzlWB2QKJ9G/KkwP/k154gdApcZs9Tn0j8OTSQIcubS+G9ommQjzOovmpl33KWJeoAgJfWLKgQWKywuruuwhNoCYmIVLSQ5+F7dLccmB05CjMX+UdTfF1cvXLpp01OOqMst/htqVjbIWXUWyQmwLfFymt91yu/nifHkFVYJNVb1RJf/ROYxsKiQttJ5kUPYXZMNciBtQovvXtyjvaViuRpEz0BMgNt/ku2LvvLvPtle0f9kEm4ow+BBgheiiJl3OYhcFnTTI/KjMU+mxf1W9x2mw9qJaUG5RGR9kEYVXuQRV/ZUyv6jyXQtxAk9mPDTwkZDZB6cxjzfWpSrkRZLbC1RbHEEUKABdA/M0rIl4E7BfAtve3sOC434PnB86URoyfi6d/FGiHjpfFm0yD+ivbEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e351a0-6a82-4d2a-98e4-08deebed6e12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:32.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/gqzed8omxAvdS64UXBr0L5RYnk6IuboTySuS6BXsiatI8YaM7GQVWY2poiKhgUo9LJyC/oVR56wuC1lb3Bqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270138
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a676e99 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=4WwWyauO2_0H2zdGQVkA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: yT2BZyfHE0bEFcIXb3K1c1LCL88tuzD4
X-Proofpoint-GUID: yT2BZyfHE0bEFcIXb3K1c1LCL88tuzD4
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX52/i98/LTC54
 jjdDjzAIB/kwA4VidYUbD25aWPHa0ucFmW/7221h1Cs8onX81Hpi6v1wREulyt88dIH1qL6Tq3o
 GBfuovrO/D4yle79f1C9JCvvJfNYyWI7KS2c6dyOXGxCvvKYyjqs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX7a5a7CKLlcU0
 +OsoXTUoCVscVC9IR08IFJ7L8HGaVx/YXNc9blGsRu5kEKCBwKOT0Y1jdVVxU81VWqZBxJohK9G
 P65coRFMHmqpNuZ3e0gFWgaLlf6g40Yl2T5jc4NTX3Psevr8vAkUg4z7Xj56NyYMCwNifhPaWyg
 RP9vqph7j0z7gb331l3REQauECYLE2iC6JPJsB9cxfzLeIQ5Ld3pQgruZN4dstqCEWXdw2B9Rc8
 B5PO6JHVAZNPNpjOc3dDFCRpuoF46KkT4AHcMhpoll1ITZIEV8l7GePJT6gYZJJlSrGVKWXHdFv
 qpQOFSuZzXpC1wPrtGpqHWDrgJk9z8C1Dza1Cv02IvOm8E2h2V72JHYHwTJYRZAz0WhJj8DWIWt
 TU6E1FnF06fmn+ejdwZNSQ56w7XQNpGTPnmghq1tLKkVbcUCvDTfjOtK3b1TI5XxKm/wr3almQo
 PifQXTB1KC3sOwxfpgHjg/W5I2TEtbkYjiyeHRLE=

From: John Garry <john.garry@linux.dev>

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 242a15bc2c5bb..36c745cbb2619 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4006,6 +4006,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+__maybe_unused
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
-- 
2.43.7

