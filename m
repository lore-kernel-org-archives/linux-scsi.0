Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59EA239099;
	Mon,  8 Sep 2025 23:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373013; cv=fail; b=TVx/ZEE+KpIpqGFy3FMK6mJSD+cUIszL/6TjEk4XjBEx+Pz9av5mEt7mu0mVZR7LXk4hl67wP+VbljjEYaDX2WkAo4uVdwlGG8R1x/jUoywJi+K2QNCZtnNuaOmTxQymcYUEYDCIAqo9Sz3T53YdMtx60rX9mUWNcnl5tNKqZ/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373013; c=relaxed/simple;
	bh=EM/MfbxYaEQBlTInvoearrjEXuohAeBPb4QchRi09SE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IPkv2wxpsEwQyvbSGqiKfwxL/gDtU70xUjMUhL9wMM11q27XwsNCy3CJUKvoxYd2ti62tQ/xkWH7xA5LE2oNzY29kMXNRVdiZLp+mbzlR5W5sZc0bs6QoMPXf8izOwL4VbJrr2qyY8qrbrJprw/NQCaXkQpqwKE0ZO2pZNfEgw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WrWs2HT2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BeCPCgah; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WrWs2HT2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BeCPCgah"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBh5I012895;
	Mon, 8 Sep 2025 23:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=EM/MfbxYaEQBlTIn
	voearrjEXuohAeBPb4QchRi09SE=; b=WrWs2HT2diygr30hrZDVMCZwYMEu1d2P
	E+d2g+4/GIg0XXVcnUFn0mayqmKYuNZyErOXLYPs3pLkWZOBP/z3J5prkrVwCd2s
	9J5hNKl+m9frpFp+yWNx1/zG2/PtiRHKcYdohlDHUrCmIMyNsk64s8a8Xh4ATCYC
	y7vC/Q3zxJ3K24h7Ib+nI3hHF214rf+gEs8GxgIHZyUohbmonmBtkH5K2QGNB1cC
	c3qWMyW1LYDR0a6xpgVWzllf19IZGoLx1lExHmafc5mfXBCRiETiPAAqNaiaxaBW
	2ZJww2yPMgt7n3mzD14g2PXuRLFn7sCANvyhtoGmjPZxfJijCEZ5EA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pe8smm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588Kt4FJ013598;
	Mon, 8 Sep 2025 23:10:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd924gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh4B60mMcz881ho8Ab7cmfd+/PEW843tMnVe6H3YxLTi1skQagBSf8QvxxKzFhA8DPnCL+BLFWcs2lTF1XpAK+7QV50DTOJSg3IpEf1YCb9F7UHBVy2/+locUxaiE3fBqFNOZqnpi0aFnsbqMxtNPNscT3CxOwPPJik9wwFOV9lhAqrc2i9Z7OsVn3aHkYymmIku5yZBf/vVDigky+y6umCyVjEVLCjblbmnbj4Wmg4meIzPV/a23pgGHCHIjN7X3ZPurc2zfgzTd2itaJ2YayEakDyZ6HH3HZumnGD4i41hgnMrVmi3/GiPD68ELhnPWdGkhwrUo7B4SSFrf8zwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EM/MfbxYaEQBlTInvoearrjEXuohAeBPb4QchRi09SE=;
 b=fez3bjW3wTTHJVcoQFvfNNpU7HPhQ3bmGH33MrxD5y1KnA+Zh/ZsWdmP4IqzFLY5LNXij68PdHV1bCAoJH6Bpt0ciAVjKKYV5/xC84M0NNJm10Qgfhk3XP8uiwJ8kuqSieDs8M1nNLy1LHqtFAfGfkapjkwp9QxXlH/WYxDimJZm3NVZ7mEeuj4d5/yxTAMg93zy7nCl8K9hP5gTr8eAvr8pp4tI2yitsGZ2+IXRU7UaxrpUlH1zzDeHApLjemqR/tRxtOYQkposVooirVtplepNoqzh5attFZShT2AOPVVDLT3VWRx7pa+LB/xNq7JC/1/Vzj3I3IUKVsNjv8EOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EM/MfbxYaEQBlTInvoearrjEXuohAeBPb4QchRi09SE=;
 b=BeCPCgaho6TaJ9w6L/yez1HVB6V7kmH5Zwxjd/x6YW2Sq4YEjjCKMq7v1cYMOEA41wd/r/jBWIqa/5eNEnsdYfz1o3sVWHyE8jP1UHuQE64F0tySO8LYtF6K3WHOx5vcdtXrKPZ4H7XkJoV1ZcoONK1XoRipXiy/SHFpNYw+Diw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB7437.namprd10.prod.outlook.com (2603:10b6:610:193::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:10:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 23:10:02 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH v2 0/3] target: RW/num_cmds stats improvements
Date: Mon,  8 Sep 2025 18:05:53 -0500
Message-ID: <20250908231000.10777-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0063.namprd11.prod.outlook.com
 (2603:10b6:5:14c::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB7437:EE_
X-MS-Office365-Filtering-Correlation-Id: ab756c01-ccf9-485e-7e61-08ddef2cd71b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DQATXLLhrwigGM9ev2p9wNzyJMcMxD6FegQf/OAysxQU3jzFUyRs4FtILxW7?=
 =?us-ascii?Q?0wFujlPCXx4R43rb1m3p7ctlP0x7XhSpUGa75BRaiDUBxGOVln4Iq7yMUddq?=
 =?us-ascii?Q?sx/UDW9/+1L0wHGZvOz9AmWzaoypzicJMh42a5gwE8Rq7qMOF8VhXCBBZoh6?=
 =?us-ascii?Q?gkJoJRakg5HmQkh50WUQhRTAAmo+AkwdwT/CMBwADrq9Od3XjnvNUDMpVVsO?=
 =?us-ascii?Q?uZHCWNPAqGP5JRGeWJhqoi3G5Qx963XWrc2CSSOn45v32Z30uQhyA2jclaXX?=
 =?us-ascii?Q?vSthDi0+k1iuoFTF+lSfnIHTJcVmOCS65ZZF4JjpYKUbbZU13ZV/kFf5nWhx?=
 =?us-ascii?Q?QpcnYH0ibCl8daZxZLdGJVhgUNC3mr9B9yOpUSXP9P3eqH47hpGPuP3q1iWq?=
 =?us-ascii?Q?Npas/p5Uq/3oQ7mmjD+9eSgskF+Id6eB/hRYlR6RnXsE7OOR2iGdwWUvG4i6?=
 =?us-ascii?Q?j5Yll7sEIJKGFduY4ltmhbZFpIda1h3nNUn2GsLEPCOgfyNRzm6JgtWYZ90M?=
 =?us-ascii?Q?SUnnuNVgiSx1XqipYH8r3y3WPBeFj/Aah33LC9d7vgXyw6fqc403ZT+Eo9HE?=
 =?us-ascii?Q?8+VdGraWJwPijfuuHnolkgL1UeiATcgy/10xtQ6qi54T62onFc6x6ISRZjek?=
 =?us-ascii?Q?hfusF2KlRgJEvYj0CtS4fZ4L30JC00aWpaHVM7Ft4b8vMKIcZN7YCxzcRgBk?=
 =?us-ascii?Q?Lq1l6D39ldDhLB+NuZlXVJMFClQD2Jb2UoiKspR+PhPCoyQJ0oN/gvW/1MNy?=
 =?us-ascii?Q?W1EgqOc+LZnQUuW1B0+2i459OYPHIZL0BHZH8yzuokHadnlyHehhHzwkA87W?=
 =?us-ascii?Q?Ug7uWzmgPJ+03vR9qSp8HB4ayrJWDrdooeNEhf/L9edNtRtG14JSEaSsFrE4?=
 =?us-ascii?Q?5epj9yw3ZBqZC6f7qAzfka6V+67j3kEPfYY62udRlkw0YCBI23CYWpRHUl2p?=
 =?us-ascii?Q?DsmjGBTDc6ZLJHRTfpMJqByWgvQvIiByhkYeQykg7D60derzPgTzbQx0Y7/F?=
 =?us-ascii?Q?zYB1xZzmXzNgzt6ajJMWizcdrFm/6J1xfSzdT4tiLmUZMO7f2cW/1bMxNnuz?=
 =?us-ascii?Q?oNTRtzhSwdwuP75omuO4g08wLCnjeWvOw3nlTMek83M5lMOLlC7IghUkzBiE?=
 =?us-ascii?Q?aPTRLqvFTxz3SxZu+rv8hjFqnleI4nlzjFv6LNqVWALWXqxmSsgnFqCrdaEN?=
 =?us-ascii?Q?l4m16RrDIbJyt2nsl+hbTVt0hfUFj+yYa1fdo1IHWYx0PlVJbe4Rb/tAS2WD?=
 =?us-ascii?Q?xmUX3owz7+ovdOMz+ospyclRcLGkrBqCb3fcboQsgOhPAjHeyCvvfxEFXUw1?=
 =?us-ascii?Q?9Snbnr3b4wwhIW0ZKDiOK/fNWNz4Dt4wvZd347XXr9eHjqY+49rW2mm/mGqu?=
 =?us-ascii?Q?0vhzQAkE2/KmkoXtAsNIK5dtAeueg9ayo/iZ/7l/s+vDRncmFbEu5U15A0qy?=
 =?us-ascii?Q?V/ZuGToDhYU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QhoAguUA8Xp1MZ2LDLhdZzWHoARtsz9xRXfXj94U4y/lqh20oE2G4te56eFO?=
 =?us-ascii?Q?LJrdMjV50+ZnnprIAYWSO9LUHKfeuIebiwhVIlSf8c1b8rUVTujMZHMfc35Q?=
 =?us-ascii?Q?OLfyZ2dWZPx1ekyM7J0r0pHS29lVToMFcoaBSI2pYgKUqDwmx/WWoZfACaP4?=
 =?us-ascii?Q?rgRls/E2t6gNydtDJUG+r5i9gi+N8HcDNRYIR7YvkbCJIEzUwAOKvohEvxsX?=
 =?us-ascii?Q?pAygpzJjzHBPDcPCbR/tgZwMDx1UsrdV7rilRUI5JBdJQ8zlRXI5qSQ4QrEC?=
 =?us-ascii?Q?s1vL9esPiDnHUcNhsNxabBdefZxRCZ3eWtWr9BmK9cUDPyqq4WjHsX9OeaPf?=
 =?us-ascii?Q?vjcLJBFkWS4UuOrmnKPOUzrnNAj9UZe7y29tuxuWbCTpy83hcdd2ynhg6P0J?=
 =?us-ascii?Q?a6kdjpfhs6np856ZLwWwvOYHYnNABvt+tV26fCTP7i+PcYYTlVSYoNntDEOS?=
 =?us-ascii?Q?HejjER3m8tsdx5/rpTUK0C/ms6aL28c66Q8Yhbs/81gXMNT7gWfufvUQQQUy?=
 =?us-ascii?Q?LQW0/paJqtdSMW54G6aP/XGUriltZC3LuNWXX8Akf4dkFhU/Cr1u8dgFzXGc?=
 =?us-ascii?Q?wcJ0dDWHAtJAyi17sFAymmPeHdoeEKWs5Iqk+ZIl9W+oX7hl8ReBRevGVaf2?=
 =?us-ascii?Q?meI7zoawU2e4M3U9EkYmdzMzLGSQEOpZIXjB+usTiKw+lCh/5X/wKNi6BzwF?=
 =?us-ascii?Q?+6so22ftoS4EuOVUaphTHIsc9c9FrEK7kCzdgPawiI1LB/EUCb1JsE83qIME?=
 =?us-ascii?Q?+dQd6YZMlDOesrBjzFSkiS3t4l3Iltmas/IFHK+CA/nDr9CwhlxZvYayuAiw?=
 =?us-ascii?Q?CjUtT98hVsmvPLk8guGNHyFBBEYu8rhSvoqXXaGP5kCwzLZLrfb8nPrAAcNy?=
 =?us-ascii?Q?kxABNCGY03cBS5uKRG16FQlNfgRCUZqWRrSlHkARRhmxwvbckOr3X/1j7pPD?=
 =?us-ascii?Q?nmyiYUsbsVOgKPSXYggorzsn64PKvpCCm1fy8hTks+Lv+xm+WKeiCs2tADEA?=
 =?us-ascii?Q?rG5owQkFY4AVuTkaJWJ3TCcx3YUhHyw0/v2MBcuaglhVdMDbCdoKZieQ8Rzu?=
 =?us-ascii?Q?JvufWJvwgc3/Jf5WbOmtqL1Fupc81tqTrbyf0KK+ltg/SNOwnmGPVE75t71s?=
 =?us-ascii?Q?4lN92fsbvUTERZ33BXnNIZxobTtare0qAK1WiMJkajtHvxJRCM1oKzV+hOrO?=
 =?us-ascii?Q?/UtU7sa8VOw/tyzOAfzYZLlfYAYqo2vlEqGeqU8vfh8/IquZiPOZptY6suk5?=
 =?us-ascii?Q?qNEONc2WVT2XcpTmZraMf/Yml/7nn8ngWXsfzA3qBAmF0UCqqZjmCjZFWAZP?=
 =?us-ascii?Q?63RLYyVTdqsYHFN/WxQlmIHObxTqF7owBi1A90DeMCAr4Y8jZ4HMXRljY7kY?=
 =?us-ascii?Q?+WuwK+kVEUGRBD+334LF3gU15pFEfS76UnO0uaWqhJ0uW9YQZZuGVS2GllkN?=
 =?us-ascii?Q?RdAJzz+Z5luBw9icz/DQA307jRDEY53YaNIVlmQke7UidP75JUEHKKTwRtYb?=
 =?us-ascii?Q?08a2BGf8zCEGtJ1iXyELkRtpdX8WpqDS4Hd57lQGmvZT2qHg8yL5VtRdncwt?=
 =?us-ascii?Q?0zASRi5ni1Zgh3iDwtb1mSCFwwamQS4bOyQfnG8qnBAzuwS8SB2sM21doOr4?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6U7kwE2fxA9q71532y8v0RaPFa9tr70i7waxPqUm5VWckg5LsYiPAT+KknHT6vh3EadU1w+j0F+OfbVPDhYnL2SqcRw/oS+pdS1PM0F0RfSqIKTmJH+LFGNbG/xdqhZJ9wPcby3QZ3DNt8WGTbcoSzz8TCEdKPlEx1r4xHJph09gQKwUejWHG4IuSCVlG0dHTAOQ98rNNvycHc1np1XZTQhTlk1BDeo0uoJ5zNIwNadSzQEU0UJOk8dw9UheM/6LWiIkKUghOBWzAJDGlRoAwda0c3EGumrdAuxgV4dMtKtFNmzsZWAyniA3FQKbQFJUiIiioRhnbZy/SbiCeqM42L9rcLRFDvE0qrXTxQcq3zFxrAQP7QYxeqWyZ2kj7qgoAGZL4+E3lCTEMBVopxr4zsspu2vHWIktcdaq+G3obKxw4wqTsWufonzC+YDH7GRbVsAED6KiiKdgWWYFWj5YG88wxf1g4T/5FY1B+nm1zoq/jo2PV48b1tFEiZjUtrxpsxg6iGU+WIBPRN1DjR5XPbK8TZEAf07scqeOC/X8VkUcIeEfC7+rQgeIkAPgcRLIfKC4srQ3uET6HTBKE5LGGKTdLnAhb8zC6gf+dm7JaWI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab756c01-ccf9-485e-7e61-08ddef2cd71b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:10:02.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPPxsDklOevVfV6MzQadfQ9Qn/q5lblMcFdZ0hp5MLV4OxZZL9Dz5Qgat/cZbLH4WhRvaQ6vqRld5IOxGT+eKCKyqMNKXv9upA1f4MH+8T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7437
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080228
X-Proofpoint-GUID: h1LchJW8kdNvA6jJEW2CGK6VHJAcWYN7
X-Proofpoint-ORIG-GUID: h1LchJW8kdNvA6jJEW2CGK6VHJAcWYN7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX7OzzigHa+67s
 guvTgkBjt0e+ozJpXLoi9kyIU5Z1l2O1t04ViksZuk+yRdHYcgTfws4nxuiXzxOIyHdovMFUYD4
 kG0m11yn5eEkxpa40rGH5JuI/EIX6xD/UHj+EtGRjIDyK9Y14p05jQb6FsQ0cI2+XHSJEDhZSwj
 Ap+Mayf58Vc9+HJZ1JKPP8Qora2ada36Y7xWK39wX3oY0cczqJiyfz5q7zr5AcX8NhHpDA5Kg5r
 i+A8XIuyyPOYCaLgwRcEA4iUiLSevgPyKV9zbG6602QaBTSqvJovea+XsNpRd2TrpJKfiuwAMNo
 6Y0wfESkgWbzNwpsH4S891p/eORyVFUlhBzdlmw8qhZmv3mNWF1SlCAGqbWUboETfFwqL03q1rM
 tKhBYsnG
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68bf624d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=Skh9uH65IMUAabULJg8A:9

The following patches were made over Linus tree. They fix/improve the
stats used in the main IO path. The first patch fixes an issue where
I made some stats u32 when they should have stayed u64. The rest of
the patches improve the handling of RW/num_cmds stats to reduce code
duplication and improve performance.

V2:
- Research if percpu_counters would work.
- Add patch to fix u32 use.
- Fix several issues in last patch: do unsigned 64 bit counters, fix
remote xcopy handling, fix default lun0 error cleanup path, fix
byte to mbyte conversion.

