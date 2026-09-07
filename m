Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A483471CE7;
	Mon,  7 Sep 2026 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778330; cv=fail; b=SjaRV3XYT5yZIQEiYUAjJMyNgcAUb2alFQuab2/ncQZvCh3NCTkYHiABqbdCfIJi+fJLKxHklk6zrhwxt3OcziMzhGmJ5N98YrCwhIgBYzCnPelUwR+UqWUjU/HBBMkjqSwVlh43taj5OWibb15Six/xOcyckKSL1Fvhmv5oT2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778330; c=relaxed/simple;
	bh=SdflWPofnKeVsYqgc9yZN+MVtqKLs20u463C4jGbebo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i6y3mUoNai9CX1LzvcVEJzrRtBKAe4oqah7P+kwt2FMljPyJ7X8gGoGD7IomcjRfVOLm/0edsug0+Qbgp79/hzyprC8qv3SRA6PMVTosGn6U/Y+Yh6njk9ScF+7RMrMfPS0E28ASXi9BG2w9ozl9ahIbuMcsF35xoNddsMemGNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ku8iA1Bz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y8TRcqI8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ku8iA1Bz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y8TRcqI8"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870I0fv166091;
	Mon, 7 Sep 2026 10:51:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XXkB1vnqyi/MJpPMa1hBLK9o2yE3ihQDNMTzXdFuzfg=; b=
	ku8iA1BzGrcn3uRMxRypH7vqaWXgjtOSpy6+SVH3XvL7ttBipokMmn45bA/a1Sur
	O70jpdJxMmvz6SUjreaXewPgPtukhqEqbwQ10p1m36RX+jDXLTVO+crBYOxLHxw3
	8oK/9shot0ufDSGJ4pR2EI1YmA0f06P8uJ4mZGBXiuyINuYF0XcPj/lg2uVD1mf9
	gmxpDXMaT1Z5RXvA4WA//XY+3Xwt/UGVplF+vUTJqbq6dUawTPHhO1vR1ErDo1Gy
	VaG/bHBGzfTiGRYHLpxjiAMGiupjYSOU8vpyPH5iLPf83loXDdrA26+Pb4LHB807
	3OCWD7vJhPJxfpKlCFWe+w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbmq9t40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687AopfC019106;
	Mon, 7 Sep 2026 10:51:16 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UZRXb1y0P7EX+QNUuS4GMeq7N1f9QxfTNZO7hiSVtWMsG60P/+68AbHG5Ap/R0dlPrE9mpYzCcnORxAydnrzugf2TCxsk5udByUNZ5Fm2MK2yzxeYOeyyryQWcc3l0tt6T0m6tLEd9yImNiL45syxPcTCQdFBSJABFjgJBqKNy33oO1MNWsv1Jj/DghIEpPxawQyJUXj8xIlzSya+KFhRanIRfLu+PqvKR834sSDP09pTP8VClUyk7D6WXiIo5Q+cvrKdDiORbfiKBexFZRFceFi73FaCX40fN3+QKm366AbOwoCwLAqI7mbs7cyoOhKdwR/eC8VkgmdZ5vvhVdi9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXkB1vnqyi/MJpPMa1hBLK9o2yE3ihQDNMTzXdFuzfg=;
 b=ndzhbTN5w9VMFK+ef1eUg2s94D1k2flBz/7KMevRs/xg0HtnNu0u+ualmXDdHAVPc6q/7oxOuhXTBI0o5nHGuBQytynbN7T1KFW+E8bJLq6/+gdisedXk7ETj7xatxf1h5byZoYL3r2Uefz+8a+KGp6Q9VSf3jsMfM3rqIGjM5ozLRgR2s+XpSa12eNEkMeAjCDUiJ8YRTV2Di0zdcxiPdMV3YEdFq5trk9FBY0s3Gxw1iSGz9IE92F5OSN1dKaZ+5YQ56a0ddRWBgHzZ2WOM3djrlDjo+D5SU9K3p9EyRv7p11PDREcLf1pccgPV93L0LQl+ic1uYI4etWdZ/VdKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXkB1vnqyi/MJpPMa1hBLK9o2yE3ihQDNMTzXdFuzfg=;
 b=y8TRcqI8+AW1ah2SAf1qBL3U521iNDyFqmZFyOEd4H0S0PeYrZr2vTuOLx5eDYRoe9cbZHla8S4axu4h9DX27D6wEq1YZQL4egbr123YcF9R3sD/r7kwHkRxbtbX7W09YnGmBouarGDfimwKEwnwvhid5uVXntbTvbsQV2hgaUA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:55 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:55 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 10/27] libmultipath: Add mpath_bdev_get_unique_id()
Date: Mon,  7 Sep 2026 10:50:04 +0000
Message-ID: <20260907105021.1763236-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF000040AF.namprd05.prod.outlook.com
 (2603:10b6:518:1::5a) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: ffd898fb-df8a-4044-9a13-08df0ccde47a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	AtwIHMyF3tRmRcgPL/+Y5TmWqgZNHf+diYjGdrWfcsnF3sEIpYpm1kTkPAAoXfoqXeOG6pv2WhUiUf8ElmmnEHXFa/spwr2AkRaRUJYlpQztzwkPT4Y8n4mq5xDjYpPPhr0sXurB/lKFrTT6W9mAz849jSZlgfm8Uj6nUImrwWsbmJQ5rCBhLnNlN97XmFJ6e04g+3h0v2FFIUJUKC+ja1GV5jl5ifE0eWdSd/Y1ooygTi/Q7IOyE0oONjURxJv8oWM0momdIR+zduegyJGpHaJyiRSstLKjxOpB+PIyi9M9yo5qCyHllmj/t6UYvwBEeoBuOBue8JOL6g4vFqRQ5FrDq7uT6B+nQXyskd5LW7/I6kwmRSasiWaKtdBwnYTjBm81oKNam+JSeXJTXTj33XETdWOF7xQHyT2qGk5DaMe4fdSQzN+ZLCIDIX+G27ZUtQPqrrvmQidvEJ2KFvVxkHIcJUrXRuN6xlMl+hsuSyJzvl5MGalhKfg71BP8XkBODaRo+Oy5H58bLWQ/Xz6KF8Ok39HZ1kKk1/sFinze4zbo0GAazvQWyLFJeeqj7ur/NJtY2fDhm8fDAxN3DIflgLgeCkXmCNHIbrm0YT8dP+ubtBXCVlEdOSxVidpa3L+2AgzmuUbmR3vfedgObYTIevDj+PvFvKjlu/G0owRnjAE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zInsMbU2yJdzqrmN37YKYD8XekSHfk04rzZf6K/SIZZpJXYjijl8Gty2egN1?=
 =?us-ascii?Q?xA+F8eibJBnFBi6bLlKjC2GMFwC+2GHcPazkM0KLenR8u0UwkxckE1cVW7IJ?=
 =?us-ascii?Q?xQbqHVRU/1/RZ+Bvvuv711zyNzYJRci9vtwNz2gnWmggORiQrHYoUcbofEmd?=
 =?us-ascii?Q?20ckA6wMYMVLGTmuSpFFyg2QKsZwyUmU6Hd54qA1ha1JfdWp+p5fiBBBMMhx?=
 =?us-ascii?Q?sRaCc4WXiqf/RQdK4VPOUySThpn3Ehbg0pizLpSAXojCin1fyWWpHu4hVXnd?=
 =?us-ascii?Q?7jJwKpy8Mb3gnCHsHJD99QA/80A+iCsB4VXbuYxDyBYMpa/hVXGvzwUs2AOE?=
 =?us-ascii?Q?tnnfJBBbxFYMOJM/RvJEWd1pDZkaviENhYPQ7VjE6zmFVWzNl5Qhxz2jq+VD?=
 =?us-ascii?Q?V2nzyhg3lG6lnUU/slLD9eY+FDj5ix1IXL2IC6CALzokdwETFxmLGrtStaze?=
 =?us-ascii?Q?gUF9tgOmajudvcfYu5QhOrj1n5VHUEeuJCuso5DGVyUn5t4odzrNfQ8LeLsh?=
 =?us-ascii?Q?TQj+DaWj5nvAgskyV5IuQo3rVdnsFnwvi7FpyuD8arK8kRj6tggp7AddZfSX?=
 =?us-ascii?Q?Lk17n6q8rVzt//eeDBRDjekvpVHBM81sq5CGZFnFvyXcMdfvoP3zCmlz0hzx?=
 =?us-ascii?Q?XyyUsqPHjIXnjLIUwDKnimdDU5f173AtMfrJvoLoq6RIZep3/JKk1jy+c4uO?=
 =?us-ascii?Q?4fcSVwkXtv7oBTcTSQ5ZhjeTYoiX7zlGHlquaVPtThgzHwp6pDcGseP/uC/l?=
 =?us-ascii?Q?cnnthoIgkhV+OQKiNV3U6/4DW92F02jr42lTY5uLa4OUWHPewNT1ahgqWCEL?=
 =?us-ascii?Q?ZUWGIP8MUCvkwK8jWoYxlJOOzFrT/lLItPrts4U/sb3fTw8k12kPmjnAia6e?=
 =?us-ascii?Q?q5nnpR4DCbXHF+oaMC48//zDHiHZb/TPwzGNXF9Fr5DUjs6uc2YOT1OVPZCi?=
 =?us-ascii?Q?OCYrPi9jlcya5y8ZcoSYkjzx47/9ecUgI7MpCZKaf4sHz0DbGfbQmYNV/QP5?=
 =?us-ascii?Q?l3zXe3rSz0NmOGTlsOrd3EYJ3QpJZ5Q57wM4XpIn96Ey6iAFWl/Sas/6u57/?=
 =?us-ascii?Q?apGm/gJRwdcrkXgHlJenlGnRneZXXtYcDcqYoMByXZsudIAaQJ9J9/swvKFV?=
 =?us-ascii?Q?ZL/EIFzdikWfpIV6zuHLqbZ0P90oMAJaQ5mSkNORxlTUldfKOkTuAd8B7DUp?=
 =?us-ascii?Q?M/FnxX17Ry+JUMgrSsNtl9hEkzw+v26Ez2ngpg7lwag8eLIwDG4QFUrUlBDK?=
 =?us-ascii?Q?HHspiLFSmBbKUp6fbGLKVl4mfPLBo6KxLbIE4wkXxOOE80JSE9Ec0tLTw/HL?=
 =?us-ascii?Q?tpwfdkqYgmeNE3uyi65qFw5OdiEIt+w7qyK/a/oyBA9wcIjRObT2jzeeu5dF?=
 =?us-ascii?Q?zdjUH/AMmVcRNqa5tvZwpuIcvI9VJ+QRh7HVsVAVAEWgTy3e+iN4/gmOXVa9?=
 =?us-ascii?Q?iq28C6KOmnNEztSMnWkSS1BTEq3XGVY0YWcGU4pynFvJr2lXlFRX2iwzwTfE?=
 =?us-ascii?Q?MmQXUCap7Ka04M/LaSkKzaZlnTrGXnMRQKUxMctyOZFZWPqvDJigVeAKOCxY?=
 =?us-ascii?Q?30M/iiUHYpjO4LNIBmRD+c5O9sWCWbF0wrMuusqEPtohIbZJpEjShjdaSEOk?=
 =?us-ascii?Q?IxMKfAeSktCAIV9yoMxbQX5ULXzrABTxdqihDK+YvAAN3i/YWEfCKpYARX7t?=
 =?us-ascii?Q?/n7aCbX94/5VsUX7/yTRDmImFf2gi8mHEGuBwLtOHfavPFPwjEwMiyzq3lQD?=
 =?us-ascii?Q?wmVLyu2a2A=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	jnFCVOPQ4aWgRecT5EVUSTuqTkS6z60ZLVCE+x8gL7p9N9l4p4jTLyg+iZSYUeZ9hwzy87vG1jQ3roNfLm74AC4/8KxXPvfw662UUgXKqa5yZqqaXjQgPffhUu9gKYpVjJbOob0UMu2bYUgL1u3GAspYS5yw5YWFLkbV2jTe7mmdyb9+fu4ILzvvktmCMsTnOBG+i6gPpBd1o47qGXg5leaFPmSXq1WYzIVBwoPa+Ox9JkLzTbbJm0s8RjlBYDr/lv0YmNIyQUV8Y8qTuSsRSJcmVH0V76n85Wu+mXByIBjO9bvuPjviKpvZ04qJ17jRm4GZ24kpOOtXIto5OQkAAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x/SoevHfJGC6Cl95D3q9lb3LV6JGI8S4R2vobDsFYCQo4Ur1jex937bHQTZRWW/BDXfyZbXfB8eSVOW5M+SlTpEQsVLT0LR7fm/mbC/+WVzhdSeB482JFL0qgAzLvBHa78dvzdSDB6DQu0e6dpRpHJG3hqPTUx3D2hSSfnrOiwJ0z8cQPUNd5uT5nKc2apu9e9S2QDvBDDljmC3B+8m+xexKhYCfMzf+wiRP1FsGMf6gzDiKqXhfkj4DtwvPxyhmpqqP/u18ujsRO54d9SMbuF7JZiDChpGzgTuhG+ElPAaVZqG1ILCf8KZiw6Z62ZJqob2Pl+V1vFxxkNX5MDugidyW+ZQhCloUf9GXzpPaKp5rTf8pDIeJm+6Th4vtbBQYa97SC0YZdYdxdGEJ3adQ18NPqjgfGajggQ/ENv93DCR2kAFhzFQNp5pC2QJ5QIy9KsT7esxPOShmV2ldqPTpYGEhLKHqNd7RAey+dtpLJgjwetmF2vUZxh3SyZ1W3xiE/h68ymHB9jOCU6i1naHy9gxLZ+OPNIPT48ZnqFsaF5sOvdEuos4ITsruHIB/HYA1G1xUbd97PjF83itm3G6ZxWq5XZ0fdSl/YKnXP6pNzgE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd898fb-df8a-4044-9a13-08df0ccde47a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:55.2872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +KRDVk9+HJ/+oyG92ZOvVRhhio2TfGO97/Whr0BXcjnnKW/vvI46mW/Pms5O5aKB4waqKxZLcddPvulw+vgKKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Authority-Analysis: v=2.4 cv=JYiMa0KV c=1 sm=1 tr=0 ts=6a9e9725 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=wdrd9TenfaMKdVnI-z4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX3y6SkKcUSiLk
 q6LoqZRFGe/LHX0o2S58mZbwLGJ8wzDbdMIS1mee6HgTgUBgfizocKtn5ni6WbdHGY6VcBOqDMd
 e8gDAwJ8fMYSTMQjZsgGps858OT8sheTymHeKP4gWzylFOhZi/xbc27Qyk8NGrxK98UVYaysa3p
 VGYQT2LNONBZDLgwlbblD8XP4X40mYukzxi4YBERkrYHrHbfpi1g3i/GdWQ1Wdwpe0UNLlhswCv
 jLlBVI/qMuGe2AzpR74Ly/aNSh9hwAh1uIpwAVoqBAjb0z0XbGwuuTyJecE3TgaKLpbDrgKFqBj
 rZ45+UH3YtZMklkHjfvsZUpMaLI6F0ZIe2A6839xDVz/MOMv88S6+ubEoCbzGeqhHnmWIrFNqAC
 lsn7OxUhUxyS5/SzC1qfps0oXqud5ZZFI2xC4G7fQXRF1bDty4HBICGOl8rNiDPPbU6jsKKiB5C
 Hr8Bvq7LSho8O7+9VIA==
X-Proofpoint-ORIG-GUID: -hdhmrzWGJ18dusZNvBHmr5gDzXm7rtD
X-Proofpoint-GUID: -hdhmrzWGJ18dusZNvBHmr5gDzXm7rtD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX3vGEMcKXdLoJ
 b5p4n0Ohr0DMgKkDcd31VpKRlTPlQuCDSkTyAahF5C1hxcd1vLI1EhcxQY/eOkYad4rUktnvMkB
 KdQCYBiAGOVpnHOIDwwgCRiacvzEKA5Ebz5Y2Exkse9brmzJJ4iz

From: John Garry <john.garry@linux.dev>

Add mpath_bdev_get_unique_id() as a multipath block device .get_unique_id
handler.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 lib/multipath.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/multipath.c b/lib/multipath.c
index ee0afb0f4246b..6bb4346c57656 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -454,6 +454,27 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_bdev_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct mpath_head *mpath_head = mpath_gendisk_to_head(disk);
+	int srcu_idx, ret = -EWOULDBLOCK;
+	struct mpath_device *mpath_device;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		if (mpath_device->disk->fops->get_unique_id)
+			ret = mpath_device->disk->fops->get_unique_id(
+					mpath_device->disk, id, type);
+		else
+			ret = 0; /* referencing __dm_get_unique_id() */
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
 static int mpath_bdev_ioctl(struct block_device *bdev, blk_mode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -521,6 +542,7 @@ const struct block_device_operations mpath_ops = {
 	 * avoid their custom compat_ioctl implementation.
 	 */
 	.compat_ioctl	= blkdev_compat_ptr_ioctl,
+	.get_unique_id	= mpath_bdev_get_unique_id,
 	.getgeo		= mpath_bdev_getgeo,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
-- 
2.43.7

