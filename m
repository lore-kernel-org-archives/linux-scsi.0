Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560EF288C8A;
	Tue,  6 May 2025 02:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746497943; cv=fail; b=ST5X5d2pkeVgyhEuq/I289PAxabNPXITdHXNGbivu0vSL0fWPZFTE6AXsOjER36z2o66ZMVorcGLBX0oV7xWvuW0EnLsDIjdkLbGIsd003bTMD52512WoICgXFr8ByPcQgnhh5GEDiJMG2CqbcSJbGrXR04RT+MYjIT07fZqaUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746497943; c=relaxed/simple;
	bh=wLaAhqKYPclAZ1NfVVFuwNp/Rs03T9wLKyrr4BzsleQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=KJlhnFxCNyTZ+Tauq0L7rBpVqXIqcq0a61/h+Kc3z7+lQ58Z1JSdMo0NZ4ZKwVNxOPkzCXt6eK2dckOyIH2rnwYdeJ2FQXpAZBL0CTpJ4qiTonOkPk8NjuJvf/cudmEgqCOiWe6yY1cP6405X7vNJ3tLESNi/mWozePKst9Gi9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cxoQnhyX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZCPX2Bl8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cxoQnhyX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZCPX2Bl8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5462HDJk011193;
	Tue, 6 May 2025 02:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0a+5r2w9TwdjD3kniy
	vZVcw+yBtXpg83O4a9iHBkQnE=; b=cxoQnhyXMRLkwZU6lnxrvtae87xLQTg/IL
	3kmKLpAp5G8JMVFx7HTTVDdP3rHwPFeFE3HgA+A0+tBrMW4kmGN5nyolC1CrwkAs
	JYJT6q5vVzRd2WHQD+/fY0qmCzCAKUfMTmYZOAhnduobhfRA7qBjdCzosY7oRgWh
	dl0NYoOf7XzNLZJmoZqBcs2loWvRsizg87fy4AkHtOhQemXYd+7mDGjzGTOMEF1g
	4kSlkBDC+vpZogQSdDBXBcFzXL2R9IBQNWfkp5CH7vD+vdnSwDLGhVV0Mqf0ufxK
	27ehYBIOXZoYRHk3ky4qOp5ydO6ZO2BZVT8nB5QP5w/n3MHMVqNA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f9gmg01s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:18:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545Nw3e0025052;
	Tue, 6 May 2025 02:18:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kenpue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:18:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PLDhHUaupSTVkDGUntcrnj0b3WB/uY6HTFoSBoLqGrYLb0/+L1PskyM16NQFgNJeY7Rdtjb6ZedCNFktLRqN4JOi5ZMB426cwoos/JtAicPYOU0AFjioVR22UurvzGZPtXtCt+an8sJCvJJPDyiSBbQ/XVxLC2XPR6paSNuYOA2iikYalak1yZMfVWjEWOqOjPC0MdxNIZKP0Y42msGaKQrF6LqNgEfpodZopfyO5Dc1LLQW7iZd50qHnmbR6Q3ALFACd4J7qdzIX9VpgzXtCX8+wqQrT56p/vUIfrMpBJ8FRQku9kOq56iPasaIMUXnRF2xHSN44WLPTqGoJU+v+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0a+5r2w9TwdjD3kniyvZVcw+yBtXpg83O4a9iHBkQnE=;
 b=Mcq7MX6+Tzdgs4WBcGgfjeBdps5TxZHajOfzSvnkMLERTQwRG7BFcWD61ayenOgcalmHGjOJRm29/87EFcLvMJJi8MT6gR7JpISPlmx7rhBF8Mi7pagerKrmkvxBeu35gRNQQkU4aopia6bJO+3aYvuLycmrL8RN3vXjAhvvekAw08+XJnH38ASLbzZsixtx52dPVsmK8ylihIsaE3IYO+Jhoh0lS/LWS81xxNAb4OUZjq4XN7yqSkbZcDB3UlT7blvSu+lQqF9ALqmgozusRskpRQRbsv+H7yHPTlpOaICzX36XP2Wx7IAKGs/8CeFxqKEqr+xyjvBOcwHpUL8mvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0a+5r2w9TwdjD3kniyvZVcw+yBtXpg83O4a9iHBkQnE=;
 b=ZCPX2Bl8PRA0syEW98Bm4L5ohES24RjACX35ltLsZMR+EUlLsjsjQVHvsnDey2C+jqmUMVzOTjmTnzc2L7W0/UvvL/n47DAH55YZR1Be8iht857j8Kb3Y/+QZGWQ4rmacMidR6blAjVn9ajfIQ26osZ+xiJWFJpBCrW6SgohniE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7189.namprd10.prod.outlook.com (2603:10b6:8:ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.22; Tue, 6 May
 2025 02:18:44 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:18:44 +0000
To: Kees Cook <kees@kernel.org>
Cc: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan
 <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, WangYuli <wangyuli@uniontech.com>,
        Mark Brown <broonie@kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: Use designated initializer for struct
 qed_fcoe_cb_ops
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250502224156.work.617-kees@kernel.org> (Kees Cook's message of
	"Fri, 2 May 2025 15:41:57 -0700")
Organization: Oracle Corporation
Message-ID: <yq1v7qev5w0.fsf@ca-mkp.ca.oracle.com>
References: <20250502224156.work.617-kees@kernel.org>
Date: Mon, 05 May 2025 22:18:41 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0032.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::45) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 0061e965-a54f-41ad-6fc9-08dd8c445360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zqCiHXRwztJ1c3YKR/q8BQhrNMfZ4TCL4qsrgvP5O8K+lrqAWqBA3RP11ifB?=
 =?us-ascii?Q?XfrYWyLQUgZx8vrPuxJmXxtU5ForvhmT6/sV24v0ZPwaAc7SfYAPQIcyiqZZ?=
 =?us-ascii?Q?t0extYLf/mOjSSsnta82sQQDkCXu/cPk+iNKAnzp6znA01ZMLJA0UJ8N7K3Z?=
 =?us-ascii?Q?9wKTyf3D6ebhmV/wcQ9bPz6OrqRf/tqulObxJjzGCLNik0wm+koG6s2BaS2F?=
 =?us-ascii?Q?fFSd2VUOp+oZAz6pEMieyLXJn+78DmkyTsXeqrXdFaTW5LwLKUvFE9otb1Vy?=
 =?us-ascii?Q?6oiSldZz7Xlen2SmhWTLziRE52x8RXW76BziVC1WOgHlclSYGKp4cK8uUMIo?=
 =?us-ascii?Q?cHjHCmw7cEX0unTokYIzqVLHgGDocuEj6EDWgvrLGXU76DSlsrh1IUHf/Cf1?=
 =?us-ascii?Q?dAEmbJbfTD3ilRn+mLwD3VpLUxS0lb3qv6IoVuMlYNHOE4mooXua9J31W9pr?=
 =?us-ascii?Q?4CjD10jR/trLQggVnNOdnH1wmB7170pmj3nOwX35pRb90By9G81y0ab2KKEE?=
 =?us-ascii?Q?ZmcrMv2T9aJcBdTv7JgocuHwWkKuS4NhMtSdc5VjbuvXwBCccDdZnpxQ/X8l?=
 =?us-ascii?Q?ejneLP9GUFqryn+GnzsH/bI+tGCeFXuxWNSWfhBEmrr0hxM+xGwfU3Lt9IkS?=
 =?us-ascii?Q?BQ48GMiSOzk6MeLD/v4n006dfRIShKXEvEVsDn5YolPL2PQSxswwabnFWjJe?=
 =?us-ascii?Q?ImYAeWDa/XNWYVQ/HyUavub++OTcTmgjE0YyIpzHJPR7Wi/DLqzzFHxuB83M?=
 =?us-ascii?Q?s1dSYCUk75iMbqz+ROW7DkIR1sF3HkAhP8SIbNJME0FMk+ZJoZAP5vQHlr6E?=
 =?us-ascii?Q?JS5w2zVguiEIfE1AnRfwnu3Nfqe1x3TA2Wr+0fGyjNF22ob5zlGw/6bW7jdI?=
 =?us-ascii?Q?B8b784AEcNkPua6hLUYjSC6kzbrkEe4lEie1kL0MHQzEWouEFTPCJWxELkIQ?=
 =?us-ascii?Q?fNxKvJmk99Z6RpD3VSNpSUGkl0LGTyidbxFuTR7d/W0VtVq9+ZNjLRIQburR?=
 =?us-ascii?Q?EPF8m7s4bk/LeoBU3Em6gMzCNA0zJGIsx3ukyN435KhEnY/9DKcX1HZJDRKJ?=
 =?us-ascii?Q?OPoBuv83LOL2KE2WwAihbTcCxzX87kZNhe9n6FlDaiFNmWEho7dacPMcagQJ?=
 =?us-ascii?Q?MVWwENd050q4IjnUzMHQld4cNwneolseV6So08EDu+ryPjVP6yGZR3EKPuGv?=
 =?us-ascii?Q?EHvffOe1JATm/wjfCOniQLiJOb05Y5ELdUohvViTmWtgwdJteZWCQ6Cy36vF?=
 =?us-ascii?Q?dcPoSzTOZTR7VeKIZ0FdnOZfzpN3VyzB3RNxWkMEZTKU7IIQJ7pysxd1WZWU?=
 =?us-ascii?Q?8oKd9hBqCa6+GzyRd5BrGgIe03a9m+JgDUUIGd21Txi5QoNBHKeEiNibX6T9?=
 =?us-ascii?Q?qjlYRd4FHVTj9/K0XS302yz2zMSZuc7bBxiruNtToHDHdJOi3XImvb+ZMHhq?=
 =?us-ascii?Q?zZyreXyNeZI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zoaVoYCUYZe6bK/njsQMDKwVnIho5xCUbl15nr1SvhtqUFZwHU3xcwtC7uEO?=
 =?us-ascii?Q?w1HOMIrO+eeDq3IhUvQ597vAVY8Vo+KsH/pL6dyjJZracLMLnWkxBpzDVODP?=
 =?us-ascii?Q?FInxlDlqYtBacUcKoX03BCnNfJx4uOHNGYx5dNTiLXyisOIBMEOmURxC2dh5?=
 =?us-ascii?Q?bDJATmQ5sBEiRF/XDXLLdKBJfNWkOUiBAHoqrMrVKeGQpcp1wTWKm9OmZREv?=
 =?us-ascii?Q?0P5KkVWJsafe0TsJSEGqF9pAOoEOi9XqvepEEyqUN743px41y1kS4S72gyzi?=
 =?us-ascii?Q?QI7nGGND/vLF2NxYkDCLgSAa/yXHJd6inDrLJBqjpv4jX7d9mczLtMxH9p7u?=
 =?us-ascii?Q?b88jbomuqB2cITpjm1YSaF+I6tr/M53zwFMe+Cr5BUx+sjIa09L/00YUV2/e?=
 =?us-ascii?Q?O+TfNWu/fqACDKFyQ2K4mDyfXVjdkcl6VOoHnMVs8xONTSzoPMNVq+P26ouI?=
 =?us-ascii?Q?HE/vA5J397i78jKfo3vzLhjISywampe2rYbTM8yJ9LYBltidZDks9HPfEJsr?=
 =?us-ascii?Q?9592efavCDSvKBwwgYxTBIUcSw8rL7PwGWM/JVri+AzvryjXP95sjY4Tyoni?=
 =?us-ascii?Q?Tt8MpMdTKVg9dw0gBeOPrzz6GkjZrdjc287p7YHml8ZsqR3BD8Qf7AtAqKjO?=
 =?us-ascii?Q?JPi05HEdVdWmswO9UKtZL7leHbfJrTBrfImx6aKns/bVd5qf41rH4B0eOmU9?=
 =?us-ascii?Q?e2E76OS3y5Bj8G1Zd1kNYwCMaljwOPas1QbKfpTPO++xV9pdumSU+G3v4nWH?=
 =?us-ascii?Q?+hvTT78APO047DGD1lOIsWq4G6ElBtSmmCCH0hW6IUCz6sAy5JYsNW+RQ8SX?=
 =?us-ascii?Q?fnlP1zrZehFG62Q+A7tneFsFlE7n3KkKwBNuDAHjfgIrZjARVLtCmV2PQKLc?=
 =?us-ascii?Q?0EN64A7mZBNZsFTzi0fo8B+J5TT1OW3SNCCR6RIZ7WM/6bf6g3G9v0GPclRH?=
 =?us-ascii?Q?v8xuFBzwZnj8MhMV4Ug/yNQ7CRXZurFw6gUKlR7PsWBX4LF7yY/hXUh2q6/y?=
 =?us-ascii?Q?daoIHe65B+c99yPMgt/Ps9ugecIDdojkT0Y1qxwTF23apFK0pk8Pm4gDcpX1?=
 =?us-ascii?Q?vzSf4UFgPDyC3+Orf3orSYK4Ctil1wDF4yMI4/SxQDKz9lVwH8LZLvgSJaqT?=
 =?us-ascii?Q?SqhGeEXZPsR2tbb/KpdfUYCF1kesV2F2TRariOeW9QxzlwaVMnXKUQnf+0B7?=
 =?us-ascii?Q?nAOCMg7Kzc5ChcfjzxtEQIoP1cP86w7HzaQYyIo8ia84IOopVwZuDq8dVSB5?=
 =?us-ascii?Q?fpkyjsuBJFNAqiern9yReJGmismbsEL2i7RvCfC9nBSek5uq08boPWgP9sVL?=
 =?us-ascii?Q?eAUxE4XiKdhhwNlW/odlIFNHlBXHEpiZWmV1G384zeP/rXcnjMIst4aMFPbH?=
 =?us-ascii?Q?y7RJCvrJo3ECcLBQQzS7LiinzoTfTO6hNd9xuEH9kss2q3iBm4jsoLyJD72l?=
 =?us-ascii?Q?++Q7BXXNk5z76otNvM8ooBFpJ7r8+pHld5+BaqR6+m4zVZgjlKyq3ODvtNeR?=
 =?us-ascii?Q?/ctZZhDV5pKWgCovWd6cqpfqo85ZTgGX7gL+rfydJ52fD6L7H1jwbgYKzudf?=
 =?us-ascii?Q?/qPpWs9mlOfDyNzrJKgCmdupXMlZLdOribReOz6fHnVgNmEIEnvLMUIN5JCb?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	POGF6G7eag2Q9wSyn6iv13of6G305RPzejT2AMUZmWFTe+3ITj0VgFuBgJBh+T7wLfr6qhJHy2oL05m2LcuA4mY9uSpGXv2NA5zOn2Ak2+6QtrypJ9lBE1tf6b/v5/Ts/3kpjq3H0KRijtjeWIXxO8NGuz8ztuiUx6PxGAgsG19EMn9u6FMp5vjt3XLNS/XNb1oJcssM+knEYpcBI8gXObjxmISTdPYum84GmA8RaQhoejLupWmVMIkG2fLdKnnmSQ7XlYunwI0Rov0l3GL9RRqBpOLnLxvSSWaIcTmRIdDnu3Cpe7PBmLSHYWMblnaLugqhLr76P9OI1oAb2vMzB+AwC7ovuSLeJu94T98k3VxHl1xipjONkef114CrPU8w4LnJ5V5o6MVxNWazk47+89fKSaUmVIDowwP/CFBJVg8j5bqzjzEkfS0qsJM5FeCrn/Zc0cbhe8eO2Lb53QkNZaLJBBWf+EEO5e+R4QaCJMmlqKRIiOaGHaaMWMth7ORImeuSK0e50DR+7ZyNqCi8lCvEY+6vDAAe6oAfQhk3AashcSeuah9xZgDUkEJc0XtiRdYIiWOiB7ZktKpzBRF7nZwkefnp8qzBDOJoaPg9Vo4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0061e965-a54f-41ad-6fc9-08dd8c445360
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:18:44.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cz0Y8mqwgAl2WmKyOJHAzagCUDkriftZ89ztEnYdoJB06jEhZSecxaeVvx0vBFew/HSqcW8c3EfgxwKmktQhtHzLx32pKlYPkThWdScWNGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=688 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505060020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAyMCBTYWx0ZWRfX2ssg5K8+xt7e O6HKLynxHJRkRSd5kEVtiCGoICm4TJ2gkCBnWYXwe2ae0kvDp+LKOwaLO04juSE9sJaIwWvYQHd Jskkw8pxY0HTS/9QYofBwROMBHa53JVOjVfaXtxQfjj076HV17XgcdQRZD+ZuA6eP+RCeeOkOyT
 w0mO9Afv8UX4RNTdZCyOf4r8n00XFgB0gy1CNiM0IlWkE6IKuOKYV7WV2h4KxIqrevhI2PR17jK uJRgbKOgsdJAg5I88NiIlDSvcJAPcwCDoEl5tCV4jLKHffSWzy9ow5cMBW80bdFQy/XmVTka/Fg y/3PDjnBDl+5lQsb8/djy56s6XoupvlZ7cdkLNPOkbWrQs8mu8FkTKKFgupKlWgLpZEykpu/hD+
 A1t1mxq3cTBnTyNwxXn50TgaX0l693cyaGUOrVjqbavFyAbFf1IuGAmVSrHXK2W+G74iJaea
X-Authority-Analysis: v=2.4 cv=VOTdn8PX c=1 sm=1 tr=0 ts=6819718b b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9 cc=ntf awl=host:13129
X-Proofpoint-ORIG-GUID: qMLA8HnTjugaFgotBEBIhhkcc8TS1Utz
X-Proofpoint-GUID: qMLA8HnTjugaFgotBEBIhhkcc8TS1Utz


Kees,

> Recent fixes to the randstruct GCC plugin allowed it to notice that
> this structure is entirely function pointers and is therefore subject
> to randomization, but doing so requires that it always use designated
> initializers. Explicitly specify the "common" member as being
> initialized.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
