Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35882BF01B;
	Mon, 16 Jun 2025 20:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750107114; cv=fail; b=nZeSyomfrcwJgBpDJxZ/T7ECYiJDdL9DBsQVCVNX6DJGc384uV3VQTygIw9Xlx8QJId91E9eSfL/wH4U83V6PfbgOKMpUoloCd/3a/genXjxeumg0Sc42i2r6ebUJUWNCtiuhXJ2n/GGNxVqY3wj0VwuMB0+lu42EB/kNOMrA9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750107114; c=relaxed/simple;
	bh=KvD/VmwDney+z+wgzKIH+TfU8DmvHm5B5rCMW3pACiw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uSyx3lX8LW3i5uCiDtzlI6LGlWa+bZNQsfN/CKPSmVp+ity2IJZKrbgKPqf83b7+zOE02eWHdcWHXtb9z+tv1iZdmLmGkC8p7GOTRRueHMIRVD/hQlhs57wlLILtrw1oiISKWQRTlc7PmDE2CPuidfnlBoYsgMzcDohLKCFIC9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ec3tLzgc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RSa0izD+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ec3tLzgc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RSa0izD+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuWA0025026;
	Mon, 16 Jun 2025 20:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OnFeO4AI6KIdXncYob
	vOrf5t8FgM6YMeftGcS3IIZjw=; b=ec3tLzgc+5/LWU3FlrUdwrdJyIKOotGnzb
	B7+qW3Gdj8GmRz5deBxcx94zQBaQRg/COM2t4betLTeRbGx6ESZsaq6kB2+0vS/x
	9VjfKD9yaM3z+Pw8x/pNP2Qpk7reiYTTPC/sAJXD6X20p0x3OfSlMgOWyNwXWoRH
	0sE7JmxVe6fO0PrHDX1h91nMD+U1mRH3IKDq7BlbOU1vPzF9XroW//ZxTcWeMYoS
	YqrdHtk4e/4wEEWvsLA2D1POvhzGejhACC/2LSoAgkLFF7pgrquCmGJ7iP9f6v4m
	H0luIeCOsu77ny/OLtWckipRK3KjNE/WR3t7oEVH4GO57k0zECoQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4790yd3vvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 20:51:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GJ3Jcf036254;
	Mon, 16 Jun 2025 20:51:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhewtge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 20:51:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lafkhs6ACw1WbG15p468OBwMuTN991uJlhngG05GljWZezh+W0AsTX/gDUY8/2dD4eDfMb03hFKa31bVIpxiFy+whbCGref5cqfm7NYGr7iY8V9w0c9xlIMHKINm4lhreOPWzx/Ybfh5i9syQPDmKFtYqyr1fGGU5GpbDjZ5Ixyk7CUtI+Mwk4zuLJ8Mg8BuD+Nj0vp8gICAKPLFBEmgF7jtXoyunZurQS7dgYaGL839Yq/BPvYqgYC7TVI1Zq808h6PUSeurY9UTyybK7QuPLh07Bo74fB1uYKAdEe9VeSHSDbwfA7DtR7ki1FpPhGz2VB1IVAnbQaVXp1UcHaNaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnFeO4AI6KIdXncYobvOrf5t8FgM6YMeftGcS3IIZjw=;
 b=RNScWY37lyUpVS5pfKj/nBz9KP3C4ygfDFbsJla0wN/Rp2t2XWP26rar9OBQEMWzuYFuCpYND+a5A8IiiDrxi6+XHXwM2wzduJxtgs8IWg9br//F2aJFMclptxr66uNYTOzru0yloIl76y0ZzUI9KRDYXnV/35a9BuRiD+zyXKIlr+ZpAH9gAdZa6CmE4lISfbqCq0ASLAEDuxGCqebEuaPETwO7btB5YzGZLNX88TBwIhanWzYiOizkcmAwgQ+hSaldGUr27qSnK1LeJFhifFROXKlJEYOBYu7P6HUUNt2TsoRWkXzwIu/TaBILAB0xrhr5xaPXTJsHsrJXJouX4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnFeO4AI6KIdXncYobvOrf5t8FgM6YMeftGcS3IIZjw=;
 b=RSa0izD+gzaj5m/KildR0ojCDh2o6Otjm10xEZV7fiDE4is03UBG8M+Su5jCrNt+EyJDntqR5ZUaZDSNa61ePzF9bNRtA4aycVpqdMh/2hVm31VOyPHsSeqgtkmbuNhuHUR/WoywePQ3VyXt67J2PKjgYRP+5xxiB1qX1Ar0MTM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF842B33876.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 20:51:40 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 20:51:40 +0000
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250601014056.128716-2-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Sat, 31 May 2025 21:40:56 -0400")
Organization: Oracle Corporation
Message-ID: <yq15xgvz9z5.fsf@ca-mkp.ca.oracle.com>
References: <20250601014056.128716-1-atomlin@atomlin.com>
	<20250601014056.128716-2-atomlin@atomlin.com>
Date: Mon, 16 Jun 2025 16:51:37 -0400
Content-Type: text/plain
X-ClientProxiedBy: CY5PR18CA0059.namprd18.prod.outlook.com
 (2603:10b6:930:13::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF842B33876:EE_
X-MS-Office365-Filtering-Correlation-Id: 50366fb7-3730-48aa-ec9c-08ddad1797a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sfc1Q4mM5d88zK4BYsSuc6pcoXn3PItmyfY8IGEdx+HGmuXNRrDsoKvYfHk6?=
 =?us-ascii?Q?TzMihgfxLxQd9GaxoOuaoPhQQo9lu+daBehuoTZLB0ec30BwNLo7B4rQMncH?=
 =?us-ascii?Q?P+57zA/5da7ezLxf2bEukdC19F+LSRkixGBMb3gKoSuSaVtYufw0ddylPMXR?=
 =?us-ascii?Q?cWa3w++bYeSRjQwK8Nm4VgzFJmFQMkB6TmWwinQxyPPPtMJlr1Xb8m6hqQUS?=
 =?us-ascii?Q?OoZljDJxWRLOfpTfXhJagXCPt9Uit5aXM3sgHsJMPUCkpoIv460YIa+Ibxx3?=
 =?us-ascii?Q?2q5r5jh353Up/vYbjTJ4+x6CapnZHI2so2EOzb/sZXZovmmbgoKhNnDQSV1r?=
 =?us-ascii?Q?B6ysOUmdQEfB4B9QbnVd77uQ8yfV6kXi7XhJPfLN/JE9j77KJpr6VvYkWe5y?=
 =?us-ascii?Q?xHN+f05ITRO/wgrkG21JV+n8bW5sO0uIwSPOwaUwZqnPpuMRkvA8JiERTtY+?=
 =?us-ascii?Q?bJBZipgzfSb+1dxqIy2LHnKoy5ZI1JNmlOK4js/cnkuQgf9agz8F/+Q/rs29?=
 =?us-ascii?Q?X1BXGowAwPRnYX3WlaKpT7gFL8FTEXKpTAtD1J5cVGlUeUTiguN+MTJZlHYc?=
 =?us-ascii?Q?h23cK1KIpYbueULWMCu+rXasyPYlHat/nxk6S5tmPaRR+8HXThtjrRn3y0db?=
 =?us-ascii?Q?bBjWzZe0Gbeljb2s2v+97BlJ3N1M5JETgKRr67Rr3Lp/h8bCLQXufcYZf4Hg?=
 =?us-ascii?Q?3B6edfHfQ9AtS4+JGaKt5gXwywmgf1O9Uy8Zp7u4Y9PKNUBMabFajuiNeoL1?=
 =?us-ascii?Q?ALpDvDmXSUcNZpqEh2w0mw2DYX1vociWvMhcK9HTrySUftLUlUu6+NmogfyF?=
 =?us-ascii?Q?OFvku7D4I+rGMUJEMeeKmXeBrZI3uII3s0gM4B5Qphbpce+J5QdQsCeaam5Q?=
 =?us-ascii?Q?yNN2ZytQTMGsxmDjuMGl9uhx1Yxsah4oY4x/tMKCrt9l87/FLL733z/Wmaiz?=
 =?us-ascii?Q?wQE9LkQ791lxjfcyy27YTE8N3Y77p3B0kN3A8O1XtnamG21O5b9S4fCiOCNX?=
 =?us-ascii?Q?/LVZ9JcVDOYUiwCEGmdaadiJI0ptkOqYOtl5CbZklQALcq8j+tDX9eJ4wkYP?=
 =?us-ascii?Q?Qq/jOFkZjbAXTjPBakP2PwuCLmRmF6iXicWFhQ6/CsRCkig3WOoFvwsDArPv?=
 =?us-ascii?Q?fczY0csoFjC7tTQCMwCB2RcdwWul9biQW1ELfm29sqqBLsYbzUsrE6woGu9Q?=
 =?us-ascii?Q?hD+y6B4BTbeFELoKw7smtGxrjbk8xNOONlXEqPllFFFRUIDxcN6nY3Ph7Inw?=
 =?us-ascii?Q?V09ay1/fUiXKVVurkvn9DO0DMptwIWgZHCClBQGLSHSeAxJMZUvk4QogP3p4?=
 =?us-ascii?Q?qf97rNhbhqlkiYqJdUoA/pqnjpgnIJf0Hr+PkYhh6BTrtlrOloYfhlTHQgpl?=
 =?us-ascii?Q?LovqqhcLyh33qYgxHz7k8xi6B8nkYFAI1/UlWyTN0gJvkMbONQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?32wQb7xBF3i5xP1IK63bhMfnCpv6JLO5dzpkxllxXFOfpnrIJsGFo0ZPavzJ?=
 =?us-ascii?Q?tm2PMzT7BJtde0BhC/4keFUdFkRBqe3JCi5WX0FR0vX0zDVdP/9SCA5F8Hv9?=
 =?us-ascii?Q?Jf6Se/L7QeCjwVa3qTHYLIz0uB4SGP8Mobw4X6UqnL71Wd21utpGtJ3Vjt6C?=
 =?us-ascii?Q?vULygsKDA5cgVbijT/eK9DthVKIWFXzLyoAvVH14pUo9jQCxm232p4WafkRW?=
 =?us-ascii?Q?srN/yA81j61yBS+K3OHj5XmjCh9LgRiuv5lI/8tcbVNhdtH8JA4TKnCIIaaA?=
 =?us-ascii?Q?m1apwS5Z4CEfFinn/w0GerpeyQAzHyiQb5jEXjA9ZAmLGEMRDtYeRD2Leygx?=
 =?us-ascii?Q?if4idCyxLgE+pxKmN00HXTTjR0Nyu+eek8HheofOjnw5frIhbHNa6M2RptBx?=
 =?us-ascii?Q?yHblrYWB9aT20LjcPAOCzm+mqxofXnctHVYKYIFZbILm03oUyFcGfdlvGa86?=
 =?us-ascii?Q?MxNBNlGzToJUTqfmJFSTwD7hvr1jza+4RPgTsYya7s+/rA6lW1e6wlO2pkf6?=
 =?us-ascii?Q?KSgeyHLIadoqHp7DKBxsjr6e3VITj1ijyxH8NVd9QtNxMGcuOS8M5iprVYve?=
 =?us-ascii?Q?r5pL4wYlWgrsWm58uePm5+BfuaB0g6lERN7Uzh9saOmOkJihM8fWqq8Ar4fy?=
 =?us-ascii?Q?DWRRR+bA6Fuj+GhxLrdmsDRwDMEvwHPViEYV6Mtww4dXgBf21OtlwrE4CY3e?=
 =?us-ascii?Q?EcLpdXj+/6o4vo4RltQD/b/trxfIlg4mYft6a0vTA2WgqMPKqDyjOTNmtAtr?=
 =?us-ascii?Q?pFgz4MJoRwcFC7yK9eZv4VuyW3z3Pd2cDZxBvR8Mp8dv3zm9GK/LgefizcTo?=
 =?us-ascii?Q?0lM1KOUtIDYXLSso7QnE9ozog3u16U7lkJhMFuKBRLdU/zZ0+GVIp4snE/7O?=
 =?us-ascii?Q?FG28WApWr9rsCV8SaBEEk8jlx1PcRg6uaIp58EXPwLRnBPPcp4+L3RXPEChN?=
 =?us-ascii?Q?MDgteJq9druHMq4OgRgUSi11XMTvhpf5KIVNXZd0hjmx+YBfbK2zxXny9CAH?=
 =?us-ascii?Q?Tms9HnmzR3T90UJUPToiUkPqFbMRGyNtYyCaAcGN/Ixpz2HvRo+1Z6jw8IFU?=
 =?us-ascii?Q?tDQn7m13rGLAc1GKMWRnbqMtoGpm9aI59L9So0VE6CiOaIKTwO+1oygpxAJg?=
 =?us-ascii?Q?G/Ofzumz1nWUOqWMzyF1TBxMW1wy6w9WaIkAs9drsWTkXbqXp5f115ojo/Y/?=
 =?us-ascii?Q?QWZ+3SSzjKXHbRS2/XbdoycmZNi6a9hAb4tVRfHiX94cnQaW17WWjxKhrXmn?=
 =?us-ascii?Q?sAlFx86jnBtrUUHwfhEWbmfE4lOJKJak5tCAeaY/MKPjZzWAcf0AEtjUdRpI?=
 =?us-ascii?Q?H+VaSw9TNnOSK2pHS8QB2zCrOCsMEC2uEpoUCgAvRo4NgKc3OMiaaMXWgHK7?=
 =?us-ascii?Q?7fHcAnXRkoE0UQS7TVXYaxrXrAY7nsO0nXzY6il8XoHkIPjFhNgJaoGnDoKH?=
 =?us-ascii?Q?sst5vb9ubmACLc0QJ1RaFqdiXtOKJTXJe0XqNj/pc5vT3BliTvCIb1mzlvI7?=
 =?us-ascii?Q?NOggl1Tddg5FsqhsJ81/eCfG1/N+3nFbZvC/ft3Xu1s9pojOOmExnHpAfVs9?=
 =?us-ascii?Q?9bjmGlYY8MP3uZbzLDXCuF8pKwIGPvYsO8MgAnlpu3xPgW7w2V7/MGQKLkow?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cvYHRQu7aTCXkuob1++aLXMUHV/zAxww3XR28z5L3qRsuZApLKDJKJ0GMX343SBVBBTTXgAxW6zXQjB3mZahJQkTGLfR2CUj9e1OwPpw3cJGV3NUBb46phy4jEEQj5lKuy+Qw6ugYuXL0CMJmlzvusZGTrZKfNYgrRuYSky3t4zgjmek/HXVphyul6S7PgQoz1wnk06rbVGByD0sNGqbLXJIhxCUsZemMBGHOBa9A0FsZ1uxAXR1rdiIo+AAXG6NY+JtGjVWeV1h5fJh1cwRWRadX2XleLmP+cVtXOPrVcExO7JpKHPPORyyK5gCx2Zwa0rzxhQjPqi6/3EcGVUVGJa91DUqQQo/mEa0zV34GHB8d/XlDpwFhH5QLkFaK2nb7OqjcJjBAxokwSM9sLIRyBiNQkCaJqgP3C4JgHV0RAbZfYya452ROuZYaAUtOreLm5w9y+V4KRATZalG8eaEzZKjWt4macHXesGfHjDjSwckDu/0tpSUCuPGzJ5K2+2Lc1yX6G3oWPQ3bN1CD7AYw2nAjCH+SwB7AhxXPEwWOYr/FESE6Soqb4J6sShZxNzxtmmnykEshRCbC7hgZ031tLtsxNEU9ll98dnL99M/UU8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50366fb7-3730-48aa-ec9c-08ddad1797a6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 20:51:39.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DB0zQaP4cUO7KKUGPeyjqJC0USGM9iIH0+xfnV7VejRvKl7lOSEhHCq0H2U62DaHbXGrPVg7e09RN2ZkAouxIsOnOPZrHNnYE7DfMb5Pps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF842B33876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=767 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160145
X-Proofpoint-GUID: gV78NXF6eW9i203QIwZukBP0oBtQt0yp
X-Proofpoint-ORIG-GUID: gV78NXF6eW9i203QIwZukBP0oBtQt0yp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE0NSBTYWx0ZWRfXzegfSR73kuwV /T+1fEavFjfjAnAnteKQWyKZJTSxzW/zLxgaMPAYMfybRYrqpPZXkBA2vFCHi3w9RrfI/s1lcOl h6Nk6bDPYqXAMZcMjgis40bhy6h4uzVMimEuKSYFozWu5898KDqnfkUBuMQKLaOhjdtT448mG1H
 lqnphVyIicdHjCCvvsxXvzvAX9XIC3cwtxUe32Z3mIry0u+tSMoPD6ibS7pzD4qbteihgcbnTBP HzoqfNytkou36ZPS1KKrNb51tqyXOEI/q32zC5vkYVoVR84XbKKW9fJ+nSIA9V6HC1ovlyPH/SQ iZTYbaTJxdBxZy0QKMySZ9SZnqNZ30Ra7CbKVudYBMas76VlnI48g5wbPMzyGMakJCON8F761zc
 gPmyS+D9ga1m9yRg7p+JRA5dPrz9TbsGjiK1wDRaMxjTSvP/9i6rqwr0gMV5beY3d3Tjeqka
X-Authority-Analysis: v=2.4 cv=XZGJzJ55 c=1 sm=1 tr=0 ts=685083e2 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=LYj2wnbMdLeu6cyAY7AA:9 cc=ntf awl=host:14714


> This patch introduces a new module parameter namely
> "smp_affinity_enable", to govern the application of system-wide IRQ
> affinity (with kernel boot-time parameter "irqaffinity") for MSI-X
> interrupts. By default, the default IRQ affinity mask will not be
> respected. Set smp_affinity_enable to 0 disables this behaviour.
> Consequently, preventing the auto-assignment of MSI-X IRQs.

Broadcom: Please review!

-- 
Martin K. Petersen
