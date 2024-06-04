Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C97914A084;
	Tue,  4 Jun 2024 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717522246; cv=fail; b=DuZvXUkQ+vDYZ2htPE9+MD/Lxps/l37STN+3pfWHsaDmRgUWVckKqfEXqSfPMY+Citm9gRW+Nq8O14Imo96LN0ZNQgRXlgu5XLLDf0HackkZwO+8dEkL5EA11I8NTqD0RPNZxeZt82ISTtVRMAf0HViX7MPzzcJ1vOhsHCRWa7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717522246; c=relaxed/simple;
	bh=LvXbEVXDDleYb/pWiBFjqQj8QxU/4/bHJza+lFfSchs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NFtuu+nvFDFN1h98z+ecMTtmAqJKk/MSHsJ7WqNU+GeCTqMvar6t9H1U/qv+nMm5puY+3+KV7GfG1Ep6QeJkzTzRPBOxCTjTaHVdlQf2dwzYB/UIx2Qi7Y99h3RswCP841jGZiJDhF3tF7ksfhSIJ66/579+LeCDeHcwtIBDPXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454BnaTW024276;
	Tue, 4 Jun 2024 17:30:33 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-type:date:from:in-reply-to:message-id:mime-versio?=
 =?UTF-8?Q?n:references:subject:to;_s=3Dcorp-2023-11-20;_bh=3DLvXbEVXDDleY?=
 =?UTF-8?Q?b/pWiBFjqQj8QxU/4/bHJza+lFfSchs=3D;_b=3De4Vx13V14jXQASWMZQgyzhR?=
 =?UTF-8?Q?cNOH/eK1YGQAw4D18XX5T3mdgxS8jOrWHZ1od0Ht3SNiE_1R0cClYztLgiuSHb7?=
 =?UTF-8?Q?copHJDMy9+Hwbb9q4hC+7m5Mzi/V+yNGX8LFNPfhDSEHgeGG1Ti_jNHviMKAi6l?=
 =?UTF-8?Q?iJpMr0fuhvaJURgo9LZ792/ViOvlzzThUwVp/oxhSWnIYfIF0P4rkf2y4_6zAc3?=
 =?UTF-8?Q?3r23IkMgPh1nXIorWom4Cc5m3OR2kcHQz6puD/1SgaaUS8MjEQmzJfWL9y/0/Uv?=
 =?UTF-8?Q?_csT1t83eITLLUXOH1HPPEJVuc+TB0hNN5mlsFP3S/soVISA22bgPRRzNFLbhv2?=
 =?UTF-8?Q?lcc/AC_KA=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv3nwh53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Jun 2024 17:30:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 454H5rko025250;
	Tue, 4 Jun 2024 17:30:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrt8xg90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Jun 2024 17:30:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGllSHjFAWKfvXbp/hr0+8wf2iWhOwjBXdzfWQX+/Y0f+zVtrhLz5Y5Q8jIGCI/uPAvSyzFzk0nFiFWCJvypBOpBLHwmaivKR6LaaVd9VvXPO7NqnE3l9LzQYjd9i8j6ljn9x11TQcEUxHUZxbumCcUOGPVFn6fs3D5PN2VDn1WrYVEREnK2K+MtMT07wIlbCE7lRuz/rJATvIFRTABuMVW3R5Q1LCKczQ9dYgUo32ph983241FMHebOqabN7tMq40TY6AZ4sMHyZ2d+jdJuUo26z0Tw3D8fb90kCMF0ZB6x5tdo8ffzdxc1+V6Lei7a+VVb01i2uQoDeHIcIqGTvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvXbEVXDDleYb/pWiBFjqQj8QxU/4/bHJza+lFfSchs=;
 b=CIbXtdT8OlQDhRUCtsfOGBAPeAWKewcxCMJaYfZ055emcs4dG8ljnluuu1S3+3wXgLi0a+HED2AcvmjtgkrRfIvSAl1D9wK1B4GNU9qUkJBBvqVR+WwALv6Igh5QwpovHMBC5fKYK1xvZz8ssTOodXwJLjkx0P4GbwcjfZwhKBxh70jxU+Oft2UyuGEwbDtw0XHHF1Otb/NSYC4IjIbn1Ij6W2QJVXm2p5+Yr0/CWMzPnLRH1ATGC1BQYsUe+tdt3AqA8YbEZt0pdVcMDsySYXT21GwiK78NNys0LDlexdUNQxIRFjw5qMvRJBfZKcWEUpBgoY+hqh8AfVbWJbW69A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvXbEVXDDleYb/pWiBFjqQj8QxU/4/bHJza+lFfSchs=;
 b=isJgQU4lWgWk3a2e0eEEDaP6M4k5LmPN4AhGq9itfAyCYDVliR6Ms8ogLyW/1yAxuGPJRZ9nK8jemolDkktF185mEeNg6VGRGZsGAqCPtaAklSIm93K7TtLqRcMkJc2m/TQF3NJqH4WnKQYMXWIgvD+qqq4lasTpIxk+HzhGJD4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4601.namprd10.prod.outlook.com (2603:10b6:806:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Tue, 4 Jun
 2024 17:30:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 17:30:28 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Pierre Tomon
 <pierretom+12@ik.me>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi: sd: Use READ(16) when reading block zero on large
 capacity disks
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <50211dcb-dc40-4bb5-8168-8f102f6bfb5c@acm.org> (Bart Van Assche's
	message of "Tue, 4 Jun 2024 11:00:05 -0600")
Organization: Oracle Corporation
Message-ID: <yq1plswaab1.fsf@ca-mkp.ca.oracle.com>
References: <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
	<20240604144501.3862738-1-martin.petersen@oracle.com>
	<50211dcb-dc40-4bb5-8168-8f102f6bfb5c@acm.org>
Date: Tue, 04 Jun 2024 13:30:23 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0039.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a0caa2d-5b27-4c0e-7145-08dc84bc071a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?0VXWGTNwjmp37opoA8p8rmpVrYe2xeMgfigrCQy3KHh6dwZIzeeewnB2ZlPx?=
 =?us-ascii?Q?Mh2V2rtPy4DsQN0O4YwXP5rTO5su9DWck8w6Yy3efqxJKfxt2Dqj+0MwQJ0K?=
 =?us-ascii?Q?Ro7oKjCaCI5FaFzH8ArxL7lchcERW/fxrQu/7T4ho3yrmNICAk3SRVoePb1z?=
 =?us-ascii?Q?d3t8fx6YKm9EPa3uER4aJNdASTsVdvpqPKGuzXOKnwUTXU1j/fMy7cZmk2oY?=
 =?us-ascii?Q?b0ox023BngzlQfNP8+lY0e/82wH/0jBcDy5SLfhk1ZAr0RBFudaKwTvOofim?=
 =?us-ascii?Q?qDvqhTktpx1fxMTgC+jwW51PkZ5xYKbmdjAG/iPbTxcCHxZk3k5oapeDimew?=
 =?us-ascii?Q?S1yNBIfqZrZMDS7ewDIQLqlroh4d2VD/lMF0+aGRRlMvh/XCLpCS6xnH3E9A?=
 =?us-ascii?Q?56zK7I14OHOljgDCiifNUrSQtk4deKjedNlpkpORf4/rfJFkHFtxJaDfOlRo?=
 =?us-ascii?Q?3g+1GCyF/21aKGTyMXmOBq3ir+9/clFPCZXoxHRpNhcZrJF5aQnV4N60NiVx?=
 =?us-ascii?Q?wrYhU9yltG66fHUDdg7yTj7LZ8CdDFZqCB+toOy/g4lsg2wztbkrP4vQs5Jp?=
 =?us-ascii?Q?XfFC33VRORIg7twWuTrr+6n6l86vNNgT4SUzNMttSs/dog2tRYg+vXHuFiTL?=
 =?us-ascii?Q?0qNQjvgRNbM0uSGEZ1XPUlAon0M0ztWFKFskd0knl3N4rc9PdXYplcIW6zAH?=
 =?us-ascii?Q?xxUnz8on/kGXSa8SHCrOBrhcIe3JjF2r+BYzOuLkr4o3G5NE8cGbPbaU8q7t?=
 =?us-ascii?Q?ObMR9NsZ5ApMj+oJzcvh2G3rayYJB72huQ7lDci77J2PJCtbweIb/PEYrKIV?=
 =?us-ascii?Q?Asvp//w73PZrnrI70ZR+PggYUMH1R7ZKPScUztKr5hzkclWv0WnyOfmMOI90?=
 =?us-ascii?Q?ssmuwZnSsBBS5ZVcPw/ajhy0G6dc3h7+9LSDIzCK58pNDAIOT054TgvbEq2L?=
 =?us-ascii?Q?hj9F5YL8s6H8Mk3fNXOwb6g1R0DCyDcQHUX47Ywp62qI2NWC50pVms0nKeOx?=
 =?us-ascii?Q?P5MTkkwgnh5WwDW+TsAibZzoQDX82LH0dzEMH5lgaPwscFcnk4uGKZQXpoPT?=
 =?us-ascii?Q?RIZV30NPtg7AyIudQi9LuNl3vdnPVMXJ/zv73KsyVQStO5QY61LqWEay7elT?=
 =?us-ascii?Q?QAsqa1aGlIOD1iz7rLnwdlkSIq1om6GVYK1tR8GZ8hLs1aeek0XahF71xrDN?=
 =?us-ascii?Q?gcNgqstEiF+FTHLATsVW4ZKcsKYLosCjZRLh5A4hJBM/WHXZP819HS6tnCyR?=
 =?us-ascii?Q?YdnzvNnKeHn8cpXYw2Egx4dQn2mDxnaatdrQducRGQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?RXryBHnl7yHY1hWjXODhQbmPweurxP5YGpWE8vkEF1wHQRnK7kj9j6cJHDFp?=
 =?us-ascii?Q?KsA67RF8XJC267aq7jGe2W6XVDnKSaDLJgMDWrq49/3Usdji1JptZb9vagdB?=
 =?us-ascii?Q?LISNVXiORThaE6FXrJvzD3RTta2D5tFLCsgfwg1SWtrPPrkzoDliVENITL2u?=
 =?us-ascii?Q?KlP8RqFEZoUCKHpRrgeMWkhFdo/iqXUvy/L/CNJ6qlpYV0vtHKgcj1QzCLi5?=
 =?us-ascii?Q?9cKdztgaRlvTZukiozsLJQJrDfxgZCq0sWtIV15SVSKjLvbtsZaLkGoej34G?=
 =?us-ascii?Q?LHucDTh7KZeYGywj74qwCQ3TrrpL/5EIouDuRpMwvM1PcSbJ2q1zTSNZ9I6K?=
 =?us-ascii?Q?CA8dmuM+f47kNJHWPTQNk2GLn/pyOc5lWT42GyO75pcEIZ2Dmz+KvJFS9UiE?=
 =?us-ascii?Q?Iz70r3616EniLxD1OXcOgKWaLk7UeyTQxT5UveZQlFh5vlZ+c2d4/TnhF8rZ?=
 =?us-ascii?Q?toXcxshBsUvf6FFMI63tttFCDtohhHZFMNhbpH2660OyCou76XIC3cNF2mxc?=
 =?us-ascii?Q?tUWC+HlPxdQdWgX7mKyzxeIyyzG5WsZ/lFOuw5t4NjKVaRhxEzxq2z1pE1C1?=
 =?us-ascii?Q?D9DgAWL9XKIzpiOnW+ZWxbmAig8U8xz0pSbQe+u5nATjSfj0xUMuJ1Ws0ifL?=
 =?us-ascii?Q?oanICIyXH4XelaSPni7Ay5XP7zfkCMQci4hgbIoLeVrhBmTRBjNRwyR+ZV7R?=
 =?us-ascii?Q?0N5Pcl5lm2Zkitzte8W6D/ilGAWbEiA8L7FfBVDmWDNQy33cOusZmsiaKZrR?=
 =?us-ascii?Q?rmJcR7qKfc+rD7tEyJ72fIN8bPMqlfJEmB0EucIcjoGBFldqS721FLdH+0S5?=
 =?us-ascii?Q?5Fckn8z/UU/3FCG/naOoWbP57tAadS1mjW42v0OFTz20Dt0/aIfyvXq271TJ?=
 =?us-ascii?Q?H/LHIoIf2sA4AZFGt5eJogSXdtcW9KPT6HkLI/zRhH4indmUWVtjfda8cBsF?=
 =?us-ascii?Q?C34qskVnGwcrDxOCSK24hG+dvuebHM4vaviPTTKijSRmh9e/fNgj0GCSdjBd?=
 =?us-ascii?Q?3YnzYQXu9e2gR4v80d5kFaNxV62/ufLZT5Q/U/JhZHnc2t78BQnKdII1u+ok?=
 =?us-ascii?Q?Xj5cJky+WMcIZiQYTMcv/18F0yKKSLOUKRm24ktCboSooDZzU6abwzoZKlC+?=
 =?us-ascii?Q?GDzGSl9i33LpFo8nCruyXY1Uj4Eba8ZuwMqw98TmGfkW7g3RElwPk3jbDnR4?=
 =?us-ascii?Q?/1tlR5dj0/1VKWWebujqLM/Qg+4Fogq/QvaiGlBK8g/kocBQlu023vzR9bD7?=
 =?us-ascii?Q?IwOSmqhH7vhsQwHY6xmCNtX6xYkrUD/0nSdjYOL/UYtQivZ8SmJpspXj1jcd?=
 =?us-ascii?Q?szYX5YooCRZV92OMJL6WKb8CJuSQOMK2pzUcEj/CIDsE/adi18/dlrw57ede?=
 =?us-ascii?Q?lWeE052/AWVf/rm/NH7zeMcKIiUJdqVrAPXH68dw+Jer02Ze55KXQdQYYboy?=
 =?us-ascii?Q?r+1dV0KX008vNDoUjcWhPcOlDyKZBnDEHBOHwQiZdi9GahmnzOdgQ6rYYGzo?=
 =?us-ascii?Q?J15H8CDmknisWNdjpjvGZLQgLZqGCyXRl24YhKHTZFIpBrSMdYO+kNXS+GD3?=
 =?us-ascii?Q?fSvGRNzCITci2F+FEqtbwjZNWjamUh99GJWcnxu2jxso16L7pVP8QJrUxdiH?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	el9q4qoNtKRzJA0fdx4CERmnJy6bLVxxcRlrBpoTDUckifeSIsVZWvFJ2F4cwG0wEWlWFH28bd16YijJdUmZWk/nZqhOHH78+y0gIMSsB51FV99amy7OBbeMsfup+G7lOQC2wAeMM0S2ggMf2Rr8bD3Rft47SeIGVpt7AFS/ZTmnBY2pTRqQSIzAxLGPtlsj4QSj9r3gQ783Ycsy1BjHc1F2k0Bno2f36eRjJVKJB5nV9LLX5gesqXQFtIkNv7vJAGGTUVUCMAdYSiOHiDCVA7w0dDgO50kHnKKf53r0VbjJcvJB9eRYFKXPwdycUKOWgyZUlWUV8B67A3zhxwUnJwhtoDBqdBd/FHWqVXmXmplb/J2gWAtVuvj9KnW2vXmlJMNcLiZm5xZaLBL9HDqm1/Jk7LBj2T39elvWfeqAzrauHYtflr8fBs6CgxqGR7bb31mg8zFtkVbFy60Z6hA1qQSq95HkQRTHd+r3Q3Dpu5o9HJTSImTdPe0stsKynFwbTDMLt+Fqli/TT2jt7u1HGIkFSXEbSlpzk1t1QGtso56//MjCY6ial5APi7AkSTIdvr+Cs7+heB2xvseWqfUBlc28taPtZvwi+i+/CMel1f0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0caa2d-5b27-4c0e-7145-08dc84bc071a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 17:30:28.8619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdLpI+XhivH7+TYxSQA0e++lzeMpEwieEwEI2fGHid0eLjYbcMpMp4gx3lys36s/E51jLpi3XR9I7JGX2AS4BBNE7Wgl8ThROPeI/UJQT1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4601
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_09,2024-06-04_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=821 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406040140
X-Proofpoint-ORIG-GUID: fQX3eFTmUkixThvCi1gaRh3hgJLnJuPQ
X-Proofpoint-GUID: fQX3eFTmUkixThvCi1gaRh3hgJLnJuPQ


Hi Bart!

> Maybe this is a good opportunity to change 'char' into 'u8'? It seems
> a bit unusual to me to use signed char for a SCSI CDB and a data
> buffer.

It's not signed (-funsigned-char) but I can change it to u8.

Martin
