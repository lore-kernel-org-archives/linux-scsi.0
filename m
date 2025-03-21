Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F503EA83;
	Fri, 21 Mar 2025 01:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742519361; cv=fail; b=U4Don8wVXLoFDZR0JLo10Ykpj6mTsLIGwyow7mW6uR4FBHgXGrQ3gjiCfOkxX0+/AVbTKtRnhBQZGWiSWQNmIXrmCqZ85A8eDUWnkTNR4pa+BbfqLIMHTxnRfz/LJC5ibHzBus9lnGmhK4XpbmASJ0llZbNmdNftw2OM2yIYU0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742519361; c=relaxed/simple;
	bh=iJkeE5Q8IqgHbYlpuPaUJIkRZRi3qtpSmrCYwEGGY9U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=c1nPyaGQXbbY1A7Tu05RCIiLSEnbn6pLiro/LYeazkVG1vJ1BGGmyWVwgDdJpGZ7Bgs07UIBPDLOdI8XOZBmqDL/124RXdbSM2uNOzgf3d0bArMJegVLld7au34tvxZwO77N75xnkNiGl1Lq1j41NaXU0/6YjhCgJ+2CfJrp8cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h0uJGiDV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fxW/NMc0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h0uJGiDV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fxW/NMc0"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLB9JF007017;
	Fri, 21 Mar 2025 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=zkpFWVr7h/UnY+QmeF
	hbuFiqvsxnkd6dy/hPWtJB5FI=; b=h0uJGiDVQo1yW2bQxt6Rg2wRqIMIotgj8L
	Ll8S6tjn2Bmhojq+MpMFzyn6JDME6aVoftQ9N+0ooZezSGQjxYachap6BYZeeuQD
	WqcLOxe/2qJiZjsenQtxbdwK573n4Nk6Ju//idZYgXJHTDlZAUSZ13mIOLMtQP8+
	hP7HZGmDoqLZqp0wWhIeXeOa4/AYnrLvWi4/7V0BLieiuLdmAXBzIO4QQ07O+MS7
	9PWs6PhcWro1DfbgmW0W0qoXY4On25FhEgsXrrJDAOALtVlCokF0ZIuM0iiAT4c6
	WNfiwzpl5s+ui+KO85RPHubqPHuLb0oIVwP3yeYZogghmPmkl4mg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23s7s7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 01:08:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KMaoNl009444;
	Fri, 21 Mar 2025 01:08:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxm3fkf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 01:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ELERy1ORmwzOI4LxBF/LozxpAJjgIxGx3fiFX9Sq4fLthQz+6fPfbvNFp2T8TaUrdMqY9fy5/8gjjBwDA4rlGFw4Tyo3dF2JPwhmCN7IY1fxmS0jKyRsVEFTXVWtEH1U3wt/FwJCN9S3psLk0Z84cqMmkNFHVy6ZCVgCUJEiEI6ojj4fOXEJhZOiN1pXdFE16GCKk43qFZr85K6AX3bZ+87W0dVNY2gIfOT8Xf/+pgxiCIwnXfvh+JjZnfYTTXem9ITDDkoBGZ0TEzzYZiPGb90F/2+QW3cpcLjFMMGIoZnzL/Jkl+2nUY2BsHARRCG3UntX76d+w17ld3dMx6BwdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkpFWVr7h/UnY+QmeFhbuFiqvsxnkd6dy/hPWtJB5FI=;
 b=gUTA9MS3zeAetAO/RSU/qb+aPr7pIt579zOxMvG+ub7y6lUF99cJNsG/5iT6p5hVu6MufopJQ/JlcszdrUJsRIDq9TPUmjpgaBtADypxwQ/cTdkPGtouhAqOehzVJOsLzzue0g7O5i6QcGph40l9ILhspMIqWpxqv73mmvG8eH+G7OckrIhOkd/mxg+w8CF+FIAB+61Rz86ghNDvL48Joaq9zKofrz44tCY4RxQAofRCDswydRXhPXeQlvV+do0rRefq+fuowo+qgkz2jCOmsIqqfJGPCvGJ/sE/gt7uZIay0LGA2Z3MpTjbnR/6giWI7FxSUycMeNFt9lKeMkUdMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkpFWVr7h/UnY+QmeFhbuFiqvsxnkd6dy/hPWtJB5FI=;
 b=fxW/NMc04gNePSRtGllBmmDHiS6jV6bE89b1E9QaYTbuLSlU6xzEOQ7s9hawzwgbh2yq0vUMRzxbZed6B0huU1iVupBg7PxDnbqeUXXkuWSH1//0JEN9Zfs1sOj9xlNCCGPdBznEE+/kF1RlDC/Jv9Si713zkPGg0s61y+UaJRw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6550.namprd10.prod.outlook.com (2603:10b6:510:226::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 01:08:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 01:08:54 +0000
To: WangYuli <wangyuli@uniontech.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, bvanassche@acm.org, zhanjun@uniontech.com,
        niecheng1@uniontech.com, guanwentao@uniontech.com,
        Xinwei Zhou
 <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
        Yujing Ming
 <mingyujing@uniontech.com>
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <798FB027101C5650+20250318061125.477498-1-wangyuli@uniontech.com>
	(wangyuli@uniontech.com's message of "Tue, 18 Mar 2025 14:11:25
	+0800")
Organization: Oracle Corporation
Message-ID: <yq17c4j9pcr.fsf@ca-mkp.ca.oracle.com>
References: <798FB027101C5650+20250318061125.477498-1-wangyuli@uniontech.com>
Date: Thu, 20 Mar 2025 21:08:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6550:EE_
X-MS-Office365-Filtering-Correlation-Id: e9c22680-6ac4-4f97-344e-08dd6814f333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pohg+QVwCX07QTNN4Vf0CuaEAwKPegMTenQcLSbCN0yk6NmJs7gBlS0mM6gX?=
 =?us-ascii?Q?Mf7EcjaLwkb9sh/nlHqyC6Pbd7ztE/Sj/pvKxM9TukZnWxoHrgIg67uickvn?=
 =?us-ascii?Q?cGyBvK8ha/EhqjZBbEXsQBvWecU8iW9JD093LVbMFCPvWC/0m/hDfP4RXRQq?=
 =?us-ascii?Q?ZaBOT1j/I22Z/QLHX8dN8YkrTJJNNzsP2fjKVkA1aey3i53wBDbqoim2MlRs?=
 =?us-ascii?Q?N17pgqZb2hNo2aYO94KBhAaRAqb1foID4Zs/4kS4s9bRqUvI8pxwcJS7ztfM?=
 =?us-ascii?Q?BwXjxXoXnAKLBh0rc9s6SW3D85h2OtTEPzbT8hgBU5cjWPor0yRyQ3wvKDsX?=
 =?us-ascii?Q?Z6G27/eZ4HLfb0lq8s+kIabNhUEKoHj+wyoTzVQJIeOvET97ag69dBLEA1Fd?=
 =?us-ascii?Q?ACKtQ1mS29TsiZe3bfWHTv3HJlo6T5hP/qUl8FSpTpIwHwWvr7HDqnLjKCDf?=
 =?us-ascii?Q?bz1AYC6Xktqo+XBM6K4UAteW2EVX/QTcavbypIw7mrIt26DXTfMa4Y1fYBWU?=
 =?us-ascii?Q?20ziBaFlSVNpvycRDpOYfMleP4jAVRvRz8mJ0IvftQBNz7lahnIjhNYpqY2O?=
 =?us-ascii?Q?9JDENdKc7tyPaRMh/lx2J1O+a+FJRVEatrqsHDBsLhba/EH4qoGHP/3fkzYk?=
 =?us-ascii?Q?S8jjzV75isB2xL9ZekniY33/T45HPL7g8WoRLXJbcr08HiLZG/GMd3ZbC+lz?=
 =?us-ascii?Q?+M1yoO20oeMjKFnYyu/M+Dngtf3M5LVodjkaQ0fiyKTLopcODF1gjqjRRKB9?=
 =?us-ascii?Q?gqqPSuF3ZNjVKEZ8FensQJlQAOKu3HNtOdgRR3aNrp5Sf/oB4fm8fiJ527bR?=
 =?us-ascii?Q?pfAV8ayX7KdJFCBohz9SHzzX87z/yl3pC/KmbhWSD7hgQXc09XfXt/pd6jJx?=
 =?us-ascii?Q?5EOmg3HEvBcNrtde0hc5RZzYJ0ftOvUS5s8t97A1oocWgDt5iw2Eykd+FE2r?=
 =?us-ascii?Q?VjoPKpuN0kyFHBS2Bn3gcxEPNTrJZbAFTBkFRPq/GtJ21gdkisNolXbNisdP?=
 =?us-ascii?Q?rFlVUXA4N+elksXVlz5dBz+snzp6atibzUaA1E1mU5UhuwWp5VodltkXWlsh?=
 =?us-ascii?Q?84TYDWKEN6vdB9WrZlOdH36Gi5zeMjY38r/AKcyRPmddIcnB7VttedUGOvuE?=
 =?us-ascii?Q?j5D3XFR6Q2nvvkUxnZmRVk1UgRHaQBZnl8ry4lVhvJQPHyv8YUDhtWG1rHhp?=
 =?us-ascii?Q?0s46McJegt6tTxgocYihLwPSVUJgg86KgpkctCuQYBYMTC09XxrdFGSRHOmv?=
 =?us-ascii?Q?vZpK0OiqMxnZNgRpWQKByM7OHqPuMDvuQBs4zOttqddxErnag5aFiII/Dw++?=
 =?us-ascii?Q?yUnI7YlsZWewJDzsUNKdEYMc/bHJ/wbI/UKEhDkbD8ATikp9vKPJQ1XQc/JJ?=
 =?us-ascii?Q?iWX058MO38n7OlZnSloJxxjW3KBX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CTIoHaxkwj8kkjUgizS5nkLzNA7hG3E95sxgmnzpszEXcuY32rNbud431H9Q?=
 =?us-ascii?Q?Td6WnkXKDNIQJmHHr1bjp2wGJrbLm1qqG0tBnzMbhA3xiwa0yQLO0N19JHCm?=
 =?us-ascii?Q?B1rZ0Kyy/G8gFnl9KVRkBRsnUCcOprJBGOo1iNEE5xmSu6qRtWPt1RqVL0g8?=
 =?us-ascii?Q?FPkRk/YLFhvL0m9wuBLOysX0qFeC17U0P1PUgx7z/jPQsAi6YwruVLbDvTp4?=
 =?us-ascii?Q?GsD9gaPWmI8DrLVadHVK1N2FYrH3zDdfEZ9cr2aFQW9/txp5+E889sZRqL9r?=
 =?us-ascii?Q?xzeK0huNCz27ch6l13jVBqrSCe38pXGmE1boJHERghGF7LfZFc54Kt+rj6G9?=
 =?us-ascii?Q?K1C2yXfNGi+bblz1T1y5AaKKjSYowr+H9V8B2p1zzfeYfHFvQ9bDwuBHX1rs?=
 =?us-ascii?Q?iCSpTtoAjFPlqIjGk7bGtS1vw4zalmUU7HJrA1hbr94+ruYJYJYfnLjWMdiB?=
 =?us-ascii?Q?TBz7ucCcoaAQqAzyVvup42NnfDSJVaTN6YSzlXU8G8GE5i4M2V1LLt+wv4xB?=
 =?us-ascii?Q?C9IKql7hCJCHL3Fu1sB2OYp8BhZi+c5Ryqkb6YoX5vgdqGYo1DLGn4CXAuCf?=
 =?us-ascii?Q?fSPwamJ/9y3kmEtPkGkvDHoVJu0BBR/d43Opt810YT+0/ZdKIAKicUG91p8u?=
 =?us-ascii?Q?xeh+U11/7oQ6kdisNag6NhNgWIkavoIuxUGss3sNR08MSEpKp6Gzw88aDY+H?=
 =?us-ascii?Q?vjAmPX4O43P/ZqF5wgxjOr8VFIBRVZj2U72kCGhxjRZVYoIA8xRKPdcA+dQk?=
 =?us-ascii?Q?y/Y76j3msO3IhTbQ2a8HC/mbRXFHPSaYgGZxtUBmxzNnt/Dy9OkthvDbrDpc?=
 =?us-ascii?Q?6lrDJStbF3A5Wn13fQ19WE2Rs88g1ED34tn+tAQyymZe37yHFhTlQjg4SXgR?=
 =?us-ascii?Q?fSaatXiw19s/6I1fR9nVxiAWLpgqgAP7V50dy7OOeQHbM1cJhumY5jHOjr0f?=
 =?us-ascii?Q?PaBc6ySavIS1hmyfDQi6bWWWZEmMvhytFZM8PQufivPj/hMrfUW6RYoaoL+g?=
 =?us-ascii?Q?LHewEjR4ts/X3UTLv+ahjLgVvV81r/lxRknUk8ThIc0JXQkfoNAZti4gRgXh?=
 =?us-ascii?Q?+Mnh1dnEMU7dqL2T0VvtOvtPbJ5CsuAJ/8yPy9e1loNS1S3GALU1wKWCxEsp?=
 =?us-ascii?Q?hr8yU6b3v6jQDi4KUpb5Sr2tP2IUVmJqh8Rzxa2cqm6lXK/xJsJJGHixjmWJ?=
 =?us-ascii?Q?d77ywb+AAQcjt1z0ilnTTXqY+603vHxFPSVdvABS5m2+A8pN4SPCsvJdQmms?=
 =?us-ascii?Q?3kM+1kSly4PjafDSx5ebZyH4XPztpdXVcADYk7RVByXxljkUq0d4Ro9weLTR?=
 =?us-ascii?Q?wZOdTudX85YaJ2HonKNChNwkpgLs5LUOTM7YE3J1siB3bTOY5t0yaBmKmOpR?=
 =?us-ascii?Q?6NX3D3D9xJM9gsYvDnm9k5gS3qV5w5RzlCIi+hBq4wdzVgcZA2ov5RgetK25?=
 =?us-ascii?Q?dZlnY+OzobypgIFJrytRWoVZuSKM95Xctf2iJ090a3Dgvwpj2HEHsaVnsVt/?=
 =?us-ascii?Q?BN/YVTUf4mHj5FkRoK4SYyBzLp8Osjidm713sZC6j7Odq8gD246NeZcdgZjV?=
 =?us-ascii?Q?SV+DRoL8l4DXUBrti39tLjkAVpBNm7i0aJnIUqTxoy2YntbMSXnbs9fVokuV?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VDf7XsQzGPC/i6VNdCLfpvo2C63YxMoNtylUk7/kIDXvL4Z78gzRdmFvhUmQEOH1/bQP5TVgknmM0fkRlfA59gTtHRgacqZzBOvYRUPJArxz+SRH5/hdjb5VBg2QCjPqq1LojD3ZTy9GdUkNy2teNPIJb3z2jDsIS973BDGM+hR26iy3EMjF3ECSB82XR0SpAg33aENGCQdr7up/IZpuSrsMs6oj+dGYHZV7v+84XhVOEjEZHfm5xGqQoIIx4VtWLZjay60YrswUXoAzrS2Uuv/st18Pr+on21g9QHdWHA0YMPadmliden2uVPc4rU8d93mh6+hsFrPcdqj4czsg5XxbOq/G5GMp9GBSV86kyYxfu/PCyCR4vtsN8CIj7ePcRzxY91YZ3aTqedW0WEENEMJRr1d0232/XKLA2D+0n+Y+hwUissw8Qv9MCeLT0N0sFGFjQGc/G60hIT9LmA73c8C7lYHv8J4B9/Td/7zf++XInZVk1WOd+ZEUkUj09Js0rT2laPidklRaXT+o3czxZusoB3wb2x5oZ1EmJLwSMM+GzD/WIiRvFg/ciw4T7t8O7+ZDhv5HlwYh/si7REC919WQ8rZLxhLb0T1kDn87icM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c22680-6ac4-4f97-344e-08dd6814f333
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 01:08:54.6463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XX7cl24ylzWfBpXMJXhuuJy2locM/JPXz3QN0Y4bJaU2ZuOjxCREPdn1ds2fllTMZteZ+Vjwkr44cAP8t0RihVGj/KgJNf4cLKfqZLdeFVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6550
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_09,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=828
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210006
X-Proofpoint-GUID: uo9NoL913N6_N4BBnPFzu0qarzKehJ9B
X-Proofpoint-ORIG-GUID: uo9NoL913N6_N4BBnPFzu0qarzKehJ9B


> However, "lshw" disregards the "use_192_bytes_for_3f" attribute and
> transmits data with a length of 0xff bytes via ioctl, which can cause
> some hard drives to hang and become unusable.

I am really not a fan of using in-kernel workarounds to intercept
passthrough commands.

Why does does lshw perform a MODE SENSE in the first place? What
information is it looking for that isn't available in sysfs?

-- 
Martin K. Petersen	Oracle Linux Engineering
