Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2796B20C47C;
	Wed, 20 Aug 2025 02:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656750; cv=fail; b=DWOHJ7jd8oN2Y7UmQJqXdZnVq2vEQ6SpcZm/cLF74QqiB61C/OjNFe9lSpK2VQM0ao1M+8gAeoQPt/BI/ZzpG3mGw2ylglNz6vXCaIkTimUBOTc2pMo9a9Lp402AmaAhUShpON0rtOfTfmw+0vAmJx8cQonaBmoU4GphQvncABI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656750; c=relaxed/simple;
	bh=TIgr/wXF6gQ+h7INux5MRJWyBpXK2Eog/yFeATTxcOA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eQJv45Eo4BlcGEf60i6TyUOzjZGtNJB0Qdt/w26KgSp0Q5/qx8h68UZyeQPgqYRKRBcQADneHN5z7lu4lZ+e1XvMayAdCBvUsURh3SGf8T+iUW0YdxOx7Lp/cljM/fHcG1YJtAulmB7D2YEftunAF0oNjfu31oIstIRg3ksQCJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U12u93s+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uVOKIi2n; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U12u93s+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uVOKIi2n"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLC7MV006874;
	Wed, 20 Aug 2025 02:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l6e/Syi0SXxAnm6U3k
	l7F7+mOTvNEUf7tLyNkKjQmgU=; b=U12u93s+CQmo/8YHcgGdw2InzpFSV9IWLx
	7lm8853X6SRh7iXfs9ElYirFMawR8raBKVl5EuQxXSAI6HO3ri9jHVAyUwyn1oJQ
	g9JpFYrqI9iM+QHUN396YdhFRcBv+RxZp9xgKrb0Dbkr6GFPdBaFHcaI+YZyZdNG
	NvetJxCC1K6LU3ZnZNJGprjQBMum3Nv/fb3VbGyzmDxxShfQeSmgF2P1SGGD9LBW
	98IePmv5YRtL9K92ArDHiY330vBz5OrPw4ETSBBsLLlGbxmQ7T0a/YqDVzc05zxX
	+3VeDlPZ/YO/hUOJJorgLdJXGR315zTKqR5BKed+WGltYn3f7LFg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsra2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:25:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNU7cl007374;
	Wed, 20 Aug 2025 02:25:46 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2057.outbound.protection.outlook.com [40.107.212.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q3wws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:25:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L39FG0BN0zf5mbEqdtKFCBSLaMixbATCPfGltNqJmRUcs9ZNjb6bV8Vlz9EEEmx/l7Q+XsFhbeiQugJA6vcOcvUOWlz/h7jaHga88eF+9Q2zoPG2M3ix1bPn+Hy+t8xOSSvXUBrcIAya9v4723zPWRidrEdCahOF8Dd3M81N4QP39TgDCZKjtIWMBM029oEybiU6/j3c17+bk2p1UtgT0Faaa1IeQ3qjGaIi0YtvFrCOF9ZpkEm+t0C+ldRW5+V+Nwslm/I/ljmIP4Bj8f5jxmm+fTefyItyKt82VQFuIZN8RZTIe1gp+T9TeW1pbas/HM40uU1PSRM2X+9j7+dJKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6e/Syi0SXxAnm6U3kl7F7+mOTvNEUf7tLyNkKjQmgU=;
 b=R5OzQI7tCy9OA7YIP5EjRDdniqmerqShHx8GEomWjwRGDtHmd3f0GAfJoCQWZnpZYFgOlGrw4RNXh5N5Udjc2MX1TU+t07EzT9VKzma0cac8eTlnnbggcD2NYh6DVOhqS8Z28z+nIPhckmcX1ARpBxsyu8+f3gdzK7QCB/GNziOOMO8nrbJcj2Empqwnf63hWlDkHHRygSuJ3tBktfxs5jL61C7M5UDvYwdsTAtRmZq2NIEbAnc9MtLs+MLrX7n4XUkC9yg7kYAy6Ah2S0Swo2HBbnl0fu2Os1ObXZja6A1rC2Mqi09HA4qKGfjn7KA0U0xge09MyUdji++9muotfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6e/Syi0SXxAnm6U3kl7F7+mOTvNEUf7tLyNkKjQmgU=;
 b=uVOKIi2nWZcutHGK72JgLKF7QXWLRb7zL5MHqQ5JySExJ5+WewTWfsrwrCsx1lWFwvDkjlS+eafRLsyS1k5LZoZYBEoG2eM/7W1YABwldPiDwoARhEnJoTgRkZl/Qa+97jbq4R5M/ik9Nt+ufCSUORYk23RJ1CsMMjin7Ev2Itc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:25:43 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:25:43 +0000
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        storagedev@microchip.com (open
 list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)),
        linux-scsi@vger.kernel.org (open list:HEWLETT-PACKARD SMART ARRAY RAID
 DRIVER (hpsa)),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250815121609.384914-3-rongqianfeng@vivo.com> (Qianfeng Rong's
	message of "Fri, 15 Aug 2025 20:16:04 +0800")
Organization: Oracle Corporation
Message-ID: <yq1y0revief.fsf@ca-mkp.ca.oracle.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
	<20250815121609.384914-3-rongqianfeng@vivo.com>
Date: Tue, 19 Aug 2025 22:25:41 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: e18d8a7f-1edd-4baf-dc48-08dddf90dd08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BGezhSU1wLt8RhYDl/UuiLBjYcMHxQ0P55ByhTYONbDCdVPbVa7XgD6EpLKL?=
 =?us-ascii?Q?A//bCD2S/x/9tGomTO8nwWLGKddyaudjczAYQbx4KckIWlpc6mDzgnkQwM8w?=
 =?us-ascii?Q?vjrjWMcEfqhtQP6m3G3llIvyWFA+sz5LsY6snav+mxUywzTiCzWhBj7jUdyi?=
 =?us-ascii?Q?KSP5wM0II6F96bUqLk0b3klbm9BR10OumVDF6WNwguF4Z2JzIRfNeBX3Z6j9?=
 =?us-ascii?Q?LHYvSigvsSejbfbfch2/dnNKiRaMPvU6Vh9jTxepk6CLAd604D+v1idJHOeo?=
 =?us-ascii?Q?XOzbuQAQxBJRgaP7ns+gRS/hdak/+wLB6OgjAi623PQZlsOZeeSVw0bHP1Th?=
 =?us-ascii?Q?XeIcmBUR9mOteforR+3HwvqBiihMDTgK1D7hgrqUSIbQ6Gu/0OCoZaxTa5wx?=
 =?us-ascii?Q?saL6E4Z0umgfzk9XN12fNySQbUfTwqrSw418eRWqd1mJ8Hjw2duEgPvCxpFe?=
 =?us-ascii?Q?HKqLkBVhuORriSgQWrT3zlvpU3aPCsegiu+58yXXlCEoWbR3rIBIl0lsnv5Y?=
 =?us-ascii?Q?bIWvJ66y3TN+mODqpk2uS+m8VNZ2QA+1082ta/7nzi+pKmEhB8gHWyjlSTCK?=
 =?us-ascii?Q?I5Cst6R0+k4OsLLAOKQqsaAnzMLYd3DlFt36Iuz2med9AH2A/ovhzv9Bk5am?=
 =?us-ascii?Q?7ID4AII/8ujoks+uURDRCU2KBAVDPOg5rvbOCUc3DtthFkDW1E/lFUxyLIlm?=
 =?us-ascii?Q?qwc7jVIlzQQ5xS+lWtR3nK2BSr+ztp7mc8hRJYTtneP5N48JZHqiiwzwHH0n?=
 =?us-ascii?Q?7IKgp2yEgSi0Nx0pbHVLp40MX7DsLwbxEwTbQkKBhDRq0QDci6/31/3qcfU1?=
 =?us-ascii?Q?LhvETBYa37xbuLAbVfI757nZ//KKU62DHj+2bivvpuMMi+6L8fZYqwnBEuD1?=
 =?us-ascii?Q?re3lNP7ahephcZBJzZB0kb+24joUk6c7vi9/3oFc8Kuz/+1mtEN07V4we5UL?=
 =?us-ascii?Q?2sZUIRHruT48Vyp5gI/Qsu6PqP93tuU2UHk8IoZKCd2xpkSaDIDcel7CWPhW?=
 =?us-ascii?Q?gQFQ0sVETLMMGRMxGDc4SeDwu7sUbIfCLOs8pkk+w7fv4zJ8Zp0e7rdcee/t?=
 =?us-ascii?Q?bmAAHUC3j7DMMGNQPsiNN8IsqEIlAVmhi7cUBsqN3zgq+0HX1jZI0Jyh+Agk?=
 =?us-ascii?Q?8UsL9+OhlaAgoPnKJkOoss+obyZvuCAmE+vd9WCbmw+quUR7TK60zAaJYPyE?=
 =?us-ascii?Q?f7tZ5ORei9UMoyDCHEaY8bAO5Hji9PF8/ACGG4nP0VVFfyxBL4zuw5PQTB1S?=
 =?us-ascii?Q?4Oazfug6V0jwTJokwKvoSpmCrG8APa9dCyFKZdK5a0ik0wll046mQwZcGyzI?=
 =?us-ascii?Q?f8afgHwRqeBjYGokxQJEMdKIM2HEfTuTR4+SxZyTxdTvYYxRrWqZ/VX3UQlX?=
 =?us-ascii?Q?Mw1GgN5u+uiNpLjIaKoeOUxIry6rh6dvwYdOZrlwBUSnv3YErwflYw/aBUPY?=
 =?us-ascii?Q?OA9zMsC7b6M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hsG2qB4S/vtsjeUivfP8vartwVvmZaCm+Sp/Kq7z7xGtak0K/9AY/l6B+0mR?=
 =?us-ascii?Q?CI9XTN6BT6ZsuzYyGRks5Wur+/ssxrcWKZE+B9KOGu7zGWmJbzFwegsX5rxk?=
 =?us-ascii?Q?xz0fLlThtgEJ6/WS0m1f7tblrG1ScplmrsTSzYMZz+1iaof3lY4wHmNUaQjy?=
 =?us-ascii?Q?GFM45X+xMEGX1Mrxv61OMy52cziop4jFtBgLctT+gMDYM2KGXiUZ5LzvOiyR?=
 =?us-ascii?Q?O75TJLhx/NOr6ls/rnl/hh1qTRgGnVpUt+JoPMo6IhUCDtgsQDn1rw5RtDhr?=
 =?us-ascii?Q?EnFsJ+JcsZ10qN0UKbgEkzsrqAm89jDgYVaKbA5vcr1B4WjOXjCVW0I2Dhdx?=
 =?us-ascii?Q?L5G07Ud8FqV9lcx1Z1xNUXHnvTf9yit+94x3V886PU7dYEkCX/8AzxSPxw3V?=
 =?us-ascii?Q?1vLJ+JcXEiNTvXhZp2kKS1wqtRWiowxz5z7Ce9duyJKgMscV234sZmUgfeki?=
 =?us-ascii?Q?Np6h2/IaQYgSoW6PqksaOILwcsb4WCW13FVOj2HdPpqndU4v6ixroME47Jft?=
 =?us-ascii?Q?6xnK7AVMbnXY41vknAW0tyn9Is9BhZobFvXZzse8MMlSNx1bi3LKgng+tGkq?=
 =?us-ascii?Q?9GiqslgicjyVYbT26iKWI8abxwrXP8ZWGh/jMXT3lL+7GU7FXAvJ7YRM6PnP?=
 =?us-ascii?Q?V0XuEZkUAxR2miOXErplWuX/evZdUIiXQW09LjLbZ8Mz0HzX0s58hMEnB0Wr?=
 =?us-ascii?Q?8EVu0v7yRh0l2nNGh8ylua4eqNKbreCVGndd/GvpzuQBc0+T3dhamUu73FOc?=
 =?us-ascii?Q?x2Gy7x8KPGsGu3MWdUvFLbVsbvR3BmiFs3l2jC1lnd8xnro2/9DSwxxuP4DA?=
 =?us-ascii?Q?FhaxzlfuM3D/NEqZOfzFyIy+OpkPA3CDljq0qX8Dt+Hu+UmJjosg7IfSa6p5?=
 =?us-ascii?Q?FAZxcN95mla/TXTM2+Mrg25zxZicwv5OMoiTJwhM/izV3IOia/2rczQP4lA6?=
 =?us-ascii?Q?9o7Jwk56frPFJuqwwygtnbjIgKwMrIDf9YOLMgaNW+zifkb4H1FpP4+hYK4A?=
 =?us-ascii?Q?xnrIh7xgV7q4qK3/YYM4Nr4+YMk2Nda7faCnAS8/jRxxsfJ0heKLw+/ZQnnV?=
 =?us-ascii?Q?XRMPlbZ0LDxrjQ4Dce0YeUvWBhEhrQ+iADFsWYzkHPyIafnRZ5RdPR1Filfp?=
 =?us-ascii?Q?t+SWvDHAEBcE0FSm5l2X1QT+emRDUBH0PXy9EDPP8Xgfgi6e0PZHin0Xdrrh?=
 =?us-ascii?Q?BZvSFSsE1RIK5DNcSiNlmfpnOUODZ7L5L7TAbhdW5Flxtd+U1KlAMzCBW9zI?=
 =?us-ascii?Q?dHzyVXJLpdloCYcFtb4Ejb8LuWkadYwaGZ0QpXLpIidd2TinFeTJd4kh1EL0?=
 =?us-ascii?Q?UL79IR2BBIf2IhRK/GTIr69LWUUV0gbPSyS/2eKNrfnOL8E6kKyEEHOy1tTK?=
 =?us-ascii?Q?ObaIj2GWgBk7B/oCEISwGuAinsHPRmLXPJdrY8PtvmuQ0hoanfTHfm//pUFY?=
 =?us-ascii?Q?hCSOVTrWpt8rXixbmmtOa24DZ0CuKazE3KApOMtsEvTYboaaCFOa1pxW9/NN?=
 =?us-ascii?Q?ltjpURmSr4TxqOjchNXvGs1h3uF678qiio3Ck+94kS7E84Ya0xpdnP6n0T5b?=
 =?us-ascii?Q?bp3Wc7nfwc9xFZJFpsn8cDL121Kb2f2Uho6uYaVHCLh/+ohrAIKuPnNcN5RC?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lr4DUfFM3luB8aAReKMa9OEUpN33oT+CGNv9z+J6WW6MksKIHDqJCr3H9dcyntkUA4dKH5Q/MrHspH6RIB1ZhUKvoAB15rgTYX2gaDIV92n8LW22OVJiasX1SBfIlQKGnV9YaSmRq4O5LyiaWnsdwGa747uZlq2nRiLj85ZNf1cAZH2R/U4Z9BDcxjkrT69tCOy5hKSa49p2WbdY88Y1GzfoBDTeI88EkqETKd6n6Ne4qxHFeohM4PYXYY5tzhaKW7n1cflXAwwaSt4sM7gqhspVCz5acF2MjufDesuU7sGbIR3h3mDwZNcfjStNlVBuKrv4rCp0GqNJQccjKQ2986I6Gp92Vf9rV4irnpVeWwjUWV85WoyB0EH/vV1UyofGPy3gpLFLXR0gSZ67Y8zNuvoZoxYmiIdjlcitIRd5OU/EAdTvzRAk4jWsQtGV7bhFF0xIZGj/J4Jy2aDJ8p789sQUvN+LJ9gdas4PbmhtSBeS3zvXB1jtdVOmiY4c0GKcsRxT0VAb1NSNyRfHnc51TdKMwJTXlzMks7mdcnSMTC9GAzaBKtQnT/K9EKV+iscbrU8THHInIWOXUEh7VEidmYaHjpXZ1WX2DM92EgvoU4I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e18d8a7f-1edd-4baf-dc48-08dddf90dd08
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:25:43.4331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evxNI/E2aOTNn/qyX/pisKdoQX8njR9PRK84Xj0sIgpwQcZLjRKiBK+QJbmx2AS8KEU+D2TteLXB44bIDBw+mwe6U/FQRv16kmegNXxToC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=740
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200018
X-Proofpoint-GUID: UNTDEfNfxkeOgebDKp_MXbMPIDBUkD7K
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a5322a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: UNTDEfNfxkeOgebDKp_MXbMPIDBUkD7K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXzzloJTLRhud3
 gIc7qGsk5VTLliC1p2Qd/j6DL0yThxxkvzpR5AGvy+wRIKVHojoRX2e8r+PmO1ZW6nSfuACTAzC
 QOCTtlg3SJrFuhyouqRz9JhMWDb8GCSUrGQTZJjHKkq07GjN2vgzHXYSygPgU14WSSY5bh4QZN+
 I/IC8PjD9bB0ozqgOlommBp1dSI9ykZ2J93xJVu+x5pdPJLciOurnXw0T8Ol3jbJs6fA8ytkU7W
 nECxl3slQu/SEafmLhcBA3kLpVUjjTtAlQ8YjyxYfhX7BkJhMHN6MzScz/ZEkUe5chdsVOsrBAD
 qquAi60vqLreKlhvD8cYUny6yKdGUczphkRm6loxPD0VEI39hdjqHkSUbBo8O7KbViTZ2mAVPbJ
 sonngVRmQ8N3mkag+mq64AtO0kDYSQ==


Qianfeng,

> Use min()/min_t() to reduce the code in complete_scsi_command() and
> hpsa_vpd_page_supported(), and improve readability.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
