Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A319C42B746;
	Thu, 23 Jul 2026 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799537; cv=fail; b=DiKZ+I1O/yvnqIgPrfCPvDoxO2kVsEZP2gkfBfr9Vbts1lCnL1axKkbz7a2ZPdPk7Rd7EE9J8TS7KoR8ls/cvGT7FYdJoIVi0AyiP7Ku/EGacI4M5bauITv83i7L6G/DYkms/hISBTraM5Zlfa4GHZYpgneH1CN1YY0Yhedbkys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799537; c=relaxed/simple;
	bh=VnsgGjpp1J3Kk1betwDfZ9LLCf1Cuzy01Y/bJIMp37o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BTpEQa7YnIR3PDtRVQv11KP+nU+DTZGu1eBZ+D0ZrGiWsm1++Rtr/m0CM0XFx+2gC9BbhISYuSGtPeG2OAvdRLS5W5IsL1IqOgdayUZU2dl0fhJbB0QaucV7aD5wEQKXDqlwXfP+7qsvyNQofAmqJk9O+jR0Vxjz+PmvcnGbAjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z26MmIXy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VHpLDdso; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z26MmIXy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VHpLDdso"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MNtJck3766698;
	Thu, 23 Jul 2026 09:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1xtuB0wlvQLQNrnAq3jHfUb/L/hP3ZhiUqLkGQxjcMY=; b=
	Z26MmIXyTkLqrkx8gqRgdfNZYl2RCfI5HMRJQMVxuWB7i6NQ82oRyVhjvcjH65wP
	/2G32CkWFa7OnWCJ0MdAfgi0M09f5IOe1p3j/k2yRguMqvbL+L0i6qJGjCQqqw73
	m0K4TQHZoHrA2qgCvERV2dwmBJtoSWwzdnCYFZcLTzsbiEn86KUEZO6gizuVG61A
	Rir6FRAgldIO2DajiqCEfd7QuRTDlAeom9k4OQTVCCpE9LE1aAWS0Ry0tMuo00ip
	XD4gT5XJTup7YV2l1RQijRymwZUQ+19Bi5L3ID4IVepMr47ZafFTf3UQhNpgYbWT
	s1nVmfwzok6zFK13+KQubQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg21q6mvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X8Pn003486;
	Thu, 23 Jul 2026 09:37:20 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010019.outbound.protection.outlook.com [52.101.193.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxen58q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:20 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XMcADAtNGBL9WiAjMSM+B5IoZGvvWnWxRUd8ewyMfQuZ7D4Lg747xHbMrRoXslEa/JOvEXajempfzksPGn3pPxWdx6k26JYLN6+DPR5UyO89bsJzb0cih19+ARP+pKLat0CQ9hZ58QSXFelpmkLGcWrtUY0jtnwZcf25MMiyXPxOgaziDGt3VsTAep8mJ1El1KTQlRqcrz8LxWBvX/LHGuPtqHzHXnNLxBiE76+KA6CmDbQ2UghFKDenp5w5MCNQ29E5ZQe70U5RNVg87mbsd0rHgIWgrwZ2rWJhbSazlAeeDi/uj+O7Pe6Byi+CQGx/9MHrpjVMdT8eajLM+umolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xtuB0wlvQLQNrnAq3jHfUb/L/hP3ZhiUqLkGQxjcMY=;
 b=YpaUIahY4UkYq8V4cLKM3+imAJGMR6boLxmKaxeRHpVXpCQa2XMG9Kb2HmwKWtt1YiUthR7jM58ylSVUbGVqQYIQVNXafAaqc/cvSEgrOpLN2Lpy99xps5DYP1nablwcMRlY45tMZ+PVUEbhA/xM0yiLficwytZECDK582Wsd8Bms95G/6286nsFmeCerbfB9sYkM+lFnBl5+2YDILy8TG0J1IbJeWSJEuZot1hIaJPdz4Jt9fAfEXN81WLKuMpjV6MB9A6+w6mE54mczf/tA3R2156BTmmi4eZauu+vxJoDLCOSIg20GRcVGflGfTO21nPgRJDLa/hqGPy54Sk73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xtuB0wlvQLQNrnAq3jHfUb/L/hP3ZhiUqLkGQxjcMY=;
 b=VHpLDdso8Yc2x8aJFBfSynDkCXI70t/FdpbqZJdwH3p3w14d4aCU+/3ryWHV1x/p34N/slk76iLj5hiQLoneFvh8e3/0QqfZzMyDpDW51tGZM15UBj8xzy6O56yVDK6y2/EoLRRCgFL3xjkKhpdaWIsdDzVVpD4+hNW3iB163uA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:16 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 18/28] scsi-multipath: revalidate paths upon device unblock
Date: Thu, 23 Jul 2026 09:36:16 +0000
Message-ID: <20260723093627.2327456-19-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:610:54::29) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: c37f7c4a-730f-4d38-1ec6-08dee89dfb69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ixpUSeAWZseR7jIIl8sXqLjmj/ca1pD+3fK1LvEYJmH8bH0UfNtGfRn/L0AsiTmwxVeoFEV8CFZYWbYyeLX5epOxenggyzosPNTMw93WIYu2yTbsWD/69kKx2e+pdNJjanHs47l3eGFa4N7doN24BThTsfL8chDI6lvlI8RyJT58b4LHCvX3avUwdGL25xOUWVJrba5Tc7lDIANxyrHEKQ0n+sFDwyn79mT3n3IjNoFOywJq2ttUJ2iW8DjbVYZo8i1pQ0Ja19akQ27q2KguAsP/WKydp3qg3ROR/CvInEAvpvT/zFF+qrzDrTf0UzgiYVEONcU64rL8/AzDL8/5RpckYJcu865g+tOOhjo2olaxXXu1pAkeqhwV9KfEuwtUdz8Z/ecQ2QDgkirRwNv+xQxTAgsefZzFjuBD10yd2VKeYRJ7sJS/0e79GMAh8pYbVZzdxhCSVOTNQiavuykNGeZLlrOUjk9gITnoGlQvFlLKLTQy6KUXods0XX7M5M+hd3oXkMo2y0oFs5rVYCKwKNGz89fCrKuix7JDoamhT4bE748MxHby0s7bDawkOEv3F0U4EXae6BU5wPP364cavcirwj3PQU1CdqQrL89+51YDWshJokELh8qyxVoxJCOkd4TDp4KFXFw5qfBkV9tmmWAj4P2WTSornGHYbE8MFBs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e6m2+E24shrxd4GyYZjcI5lANqgUKH/gg30Fjrn+Ygywln2fkIJacBNpH+yZ?=
 =?us-ascii?Q?7iW1diIxyfrr5QPqhZM5jVilo1fc70mNAgizRFv0GnWwH1mWWElGjCTFrR85?=
 =?us-ascii?Q?7AbPuMAK/q8rG+BTRkArFaNvyqsjGl1qVleUrPsHorcL8Q6J87QZb7LTXEjT?=
 =?us-ascii?Q?N8Zcfv5SmsyPqSQFFth1RAqnILeOdYkHHvUlFZLMQiIlpwfMCsVpp695VH3o?=
 =?us-ascii?Q?0HgQkuUD3ZHn+2YetNuFYlvRlitDaAd8Lt68MW4lVD+qP8TEoAhgaBddw+hh?=
 =?us-ascii?Q?MjHUujp3ZMGzEulI5eLBKwRepoMyKjMCvUqau0KKlCFv4uuYIqeL8K0wqoX9?=
 =?us-ascii?Q?4638qcp77RdjQRbnUJ67AMV3AEeRz4Cwc49Dj4v6MC5mPLn8bwYrfruFIRG2?=
 =?us-ascii?Q?RojBdXoS9UGC/iqbsDjf272ild1kpnA7h4LfAx8nQ9MIX5FxxYqfKHtU/nPX?=
 =?us-ascii?Q?u8IOgks8APCob0uN0jaQ+Pi24CKUxsjIs4/MLEBtuejSADIAQ5V2UA/YxS5I?=
 =?us-ascii?Q?RJVCQHq0gIKv4FJlDI+l4udt5A1YYfsXNyadSq6KgrpTUoyokQ+2JabUKLeU?=
 =?us-ascii?Q?sO7k3X/2hNHJLfpXvYoRLvMBCJlYIkKNYFUyCc3sa96VG7fHeNBr8Pa2hX6a?=
 =?us-ascii?Q?9Vv3UyQrJhekUuLxvPhTs18JXIClnFikABZmVA4wJBA0Y+nC3eygHuXDfmMu?=
 =?us-ascii?Q?9zuOMBtr8iU/Cn2ggg6nkeuIoLbeVyxh4qyoI628bh0dEVhHr9+AGGcN6hTb?=
 =?us-ascii?Q?bCzcSXIuuzciB7IEYvwE0LmMjUXIERffZTgvquaejqGcnPf+aOGf9XiuaIKu?=
 =?us-ascii?Q?De7FBXMpr5D4Ea5FirPQwW4uIPCnpkFgVKvo3YzZ/qLbqCRiy9C3pAu5Pa8/?=
 =?us-ascii?Q?cQmN+UTUMMPlXJ8p/T6dr13xsemyIYZWmNTYb63fkd5CMyXmBF4DRpwphIuH?=
 =?us-ascii?Q?Maa7TLvuJjMi1gOFh5eEzDocuMY9RqMy1tteo/rWDTfNq4bnoFe9WSjaK4DE?=
 =?us-ascii?Q?TsK581UDCplrCnx61dQyE5Imgm0ET/TexASrcC8XRrD9gegyBlq8NOvElzP3?=
 =?us-ascii?Q?BK20qCl2r/hRKM/4dSS1661VRj0UMcC35QeJup1puGAotOVLjs5BBHZB2nQJ?=
 =?us-ascii?Q?mnSwqhZxIvLGYeLF1/z4QatzldMGHe08CbVOcbSlADLl6Xcr0FTlZ2E2I6fx?=
 =?us-ascii?Q?UFyTzT4BzdFTzih7sVQpj7Z9CWmtms9uSpRHM9BtPFPYd+At3kTmAgu9m0Eq?=
 =?us-ascii?Q?u6j9eKuSDD9t3wD8Oasfur6lU14kRjT9ulwYTqT1FW8HXl/Wfi5XUjUfSlln?=
 =?us-ascii?Q?MjCHtJfmOuOt8hSy0B6EkHXxA5AxBUiczz68LDv/d11tP7c9HLyOcW4wg9PB?=
 =?us-ascii?Q?xVLLZjWq+7L1UNdfToDDH+pNjY2NWN9Qwy+9yDfMlbLcf2r1lAoxM/x4IwSA?=
 =?us-ascii?Q?8Ru4f4xN3nfukMKuZwrwNaAMSyhmSdNr7Swl5lnB4p4Z9cGSi4jaMeZjmt9w?=
 =?us-ascii?Q?MQWUutjX7uh6ipeUewAe+2BCCX+B1fk8JC3Dwwss9BSxgMl0ziqwFP3axGM2?=
 =?us-ascii?Q?XsqCUW/1LgAuqPKFiUjGn42Hx0SquUH0PRlzwh8oHN9qSdjUx/YpOmxg1v3A?=
 =?us-ascii?Q?CZ2cxgCtch5ZZ4cI0d3/42p7512ltt0fEdTvgRU+WkTvTFd5B5K0GGOxQiQT?=
 =?us-ascii?Q?ShYaaEBtvSpHhYRTyNSsNrBSjf82dUys97Vl0uFxnU30Sgy7SdurriJUEJcg?=
 =?us-ascii?Q?gtLdxbkBdYXDY2kbeL0ENNMmO7xdn3o=3D?=
X-Exchange-RoutingPolicyChecked:
	k3PARCootWOaHn2L13R04m1XgBDt3Vvgt7bD+PoslyiVupriPn/3fo+3gRxj4FwO3G8pw29u9FE91U1MDn+5rstXHbvGfqDuo3QTBf7RJpShZKH9rDjFBvGuqeoy7btczYHusdIXyi3RqNlw4yx/sB5riaBOzkKfjZ1+B9w/3lg0h6fB/cLRuPFqMpCR5JaHnhoN5UsRvBU1zdp+2QJR0b47Xr6XFQERlDBRy5HdJRsA1QhcZyUrNoWyTBjuspNxEYofzFAZ1ddqrQLo/+7GPQM6s1tJtPqk+0imBpadHGlrvLA1bz3gEB/Zoi4+fi5NCMf5pYJaXksHe1z3VNCiig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NrqFLniKJIAO0mwNDd+fszXDL2WyAvvzffavQvbBJtkbyFVcH3/E+UTd20omygvMJYTPtEOjC2PwPoEBf1dk6GDrRv9achpNUZN+wjVLrOJ2eSYF33NsGZvwb2wWc15kLswddJA8jXTP+RL6W5yxnl2sCAwHzdkoxe8rqOFUyx7C8Bvi4qqjo5qR7BuZnyzaYN+AotN5tDaSBwtCfgkx/FqvMtiLRlkCdod/fvGOLRg7EXPL4Jr13etwfQS5HI/e6E2kug1bIXCzXYRKZwvlvnLRSWQxJ4DjWWOmFmAYBh8v+P+thq1eqeeXZQYn02XWRSyIsVrgzOnJY4oFda6YHmVp3lIUewGVQgz46K6sF6psRojeM9qN6RbAGJlYBpT13ZMrLX6NsGp91XICxRFZRZZN/XLl0v7KQ2sJZ/2w0L21klhtQ5DuwncxIbCjZ8z4UMXxVnK5BuBLQ/G5YY69Q+9bQ9dfiaSliLFcbxO/n1N5gpmzQGWfCHbiXY/ZR5SFtOQ3W/+1ExZK/qL/tAGsjnoaE/9fSyOx90nuJTULLVIXserS9j3usb6gUbH+rvEUs47am5YUajO3hHIjatpQUFJBIL+RyQ0n9gvTY0kWH80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37f7c4a-730f-4d38-1ec6-08dee89dfb69
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:16.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ig66CONP/wGL+CQL7C9PZEw95/giv9Zc6K41hQrmDwOKvVSNqAmTaOzJChsxxVQ0J2Apx+RnFGLQWTnAdcACfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXwJnc7ecRZyne
 NtOEt1uz1742GgDqtHTP75R7hhJZ2ON4AySNbQeR3nGo59xGM3MBX42KTn3n8UwE5NamDZImT6V
 ot8tx48/g37KCwoHfIMyHk5pBJcBjzT8R4/ezrrze6l3dKneAGiSg7oAs1YgZeI6eyxZOufiISZ
 ZTrHwh/HmG6OlY8hVIwTC8QApYyWUW8QuNR8C5Gl+uHRgdvhHD+K/JEhj8IGRcetAxLVgiATGqQ
 6xU4pE73JWyTPwoTDDU1rxRi8Ybb9erZ3e5g4lqVT+jT5BJ45lpKVEhTUYEnc7zMgy9HGG+rwXG
 n/PnKlRCRE11nAw8S6GbARSxH1Fw7a9FT15sv9XAw6vsBBbgx6EiaIj7R5/BySWm6snChPuB16Q
 ntgB4u50g8KQMxwDimgOOVwE9d5hu/2V/k0c8STBriaROezFR/jrnMVZgW2NiUMs1RmPs9a1gDt
 MDAtc0MdsEsilFTNmGA==
X-Proofpoint-GUID: l8VhxvYsy2dPVxy2UchyTm8CJnM8WwxP
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX37TbFVKY9ni7
 rxK1KmS3Jc82u5Dyt0qYKjhFmpD+2uwJq/fDDCThZlRSV6ouu6o8hiePJBbgrZJZD1FEaD2Lbh0
 J7Df9k8gtN6FLX1sm9oG3zWHY1xxlYJdRL9htupEZNaxWSWCV2gJ
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a61e0d1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=PGUL5CXhDM9-3yhmlAsA:9
X-Proofpoint-ORIG-GUID: l8VhxvYsy2dPVxy2UchyTm8CJnM8WwxP

From: John Garry <john.garry@linux.dev>

When a scsi_device is unblocked, we need revalidate paths which means that
we clear paths and requeue any queued bios.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       | 2 ++
 drivers/scsi/scsi_multipath.c | 8 ++++++++
 include/scsi/scsi_multipath.h | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dafa781288046..1e13aefdb6d64 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3100,6 +3100,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
 
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
+	if ((ret == 0) && sdev->scsi_mpath_dev)
+		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
 	mutex_unlock(&sdev->state_mutex);
 
 	return ret;
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 6a2b06c148c1a..b896d28a7dd9a 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -230,6 +230,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
+       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+
+       mpath_revalidate_paths(mpath_head);
+}
+
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
        struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 8f58c44d96a77..cc77e63c43da3 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -55,6 +55,7 @@ void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -93,6 +94,10 @@ static inline
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline
+void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
+{
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

