Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B2B30216D;
	Mon, 27 Jul 2026 14:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163429; cv=fail; b=kKjvSbsLX11lufMLY+N1oi8/w6P40uyTt8Rt7XUpC/D2+V2oCfnnW+EGCkKsjBp441h734S7BLFgVJpVr7EBR9jcbvG3fuwgqFAoC8Cioi1N9qBKfubPWqoEsRhHQ8sH8gAOzLuzK6js5F1+LZmxab9aY0AAbrrdiaPSMEhFsaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163429; c=relaxed/simple;
	bh=rvz3M9XXSO4VqzVVNs6qqgKGb2oH8332yapAkRB4mjg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GMYbKzrbyIuSU2IU4kUvugjZvwdPyk/xTdWHxpwH5PtuyVnqb3Fb3F+xd7cl2Gb6/HzNM8WExOG/g9TzJfmteUeB9OrjYBnVSRNYwlGlCwzFASpXxuIG9seU0BjRqkO2VC3Lmwj9oEHbSjJLXTiJ4gajE27ZmyFu/hQleVRS3Qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NcZmwbX6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZjUdcldo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NcZmwbX6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZjUdcldo"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTGR42355227;
	Mon, 27 Jul 2026 14:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=LU5YGgpTS7fMjX55
	HAbgAdnKBJSHNKwDH75AatFVt+s=; b=NcZmwbX6xX/9ltNwdb1HBniZV3PLZTmi
	6saCRMNFiuIa6+6/mcBtqF4VntQZJbOGEH3RLSUFKkVSxZ5SXAPgpXOLiq10kP0r
	Jyr8GWsd5Rkkllg5SQOqBrS9SscPr+/86WOJiW++WRW3WQb5Q0kTRmpsy9JESKyq
	/ZaNkOfc3VYisNBh7LJlujimkPoCkGuvTmJagH1BhDG+a45oZKbvT5L50Cyauo5v
	IWk6+DuaVhqqLg2QlmTgLVRs3d4FfzXPH5PvAo7buF8B2DyEz+CzauI/+8rpsqge
	MWFrBzknTzgMhgvIaid22OFAb3o6LHUwORlvEJl63sThoYhVnOASDA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr011ycp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REegOi011163;
	Mon, 27 Jul 2026 14:43:02 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012024.outbound.protection.outlook.com [52.101.53.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6bgxnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gLqOoF0w4B+klK1Uhtm49mPwaSgLPUrNfWI8jZRvE6IEBFynxTnvxI692dEz9UmHoNaq2wqnMN25Fz7SEtVPFeY/DPnq10u8nLyJpll1iUE+VOZx/QXCbAOjchO1vHPb6JVaqtCYdM+Re8vcAiR+m34CmO8ynwVqtmWUeZolaDEDULNtM0orB5EaNvpghYhA08+5y28Psgp+jBJE0zuf3uf+0kETKAhUxC+z2yomQlxk+uyrQjFSTKwHpj31sk+hl+f+YtqgSgPWNzQI9qKsNUNkQGkwWBwd2CDOb++t4u61Rcj8M72FF69MfJyw+mqjOnLHkfbLfwdFV1QDJ88h4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LU5YGgpTS7fMjX55HAbgAdnKBJSHNKwDH75AatFVt+s=;
 b=hvaAahOExHWOf8Tm78t0WVrFnpmG+vrBkYwurLUghA7OQW06t8wuBBeQsNwnRe3NqUc6k44rSHRLAFK7tbDwZ26+w78QgnoSZA216/GevQC1lFXXRgEHrRzIe2jx7DsrycR0F2wG8ti8KJaIbBIj42hzeOkkmXcs1L8cKEE0dtsaDIgj93WrhiLk9XfvcRUfZibAu7jOL6zENWB6eGd/a1R9QFUPzjwPps+3AiM9Wb5Jn6fHeT9EoN8BXuQAYNmz3JuzzcW0SQXxO/HeN1hzwMBiVfkBBu4UomsH7caOGuyi4IoavzI44V59Z5V3r41GBhQv07qhwqlRw8CAnofNsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LU5YGgpTS7fMjX55HAbgAdnKBJSHNKwDH75AatFVt+s=;
 b=ZjUdcldocqzii3ytaNUY2f/v2Bi/0KozfegqU9mBWdBv4uAo8D5OtQk9F7CCyy8ZJfXWaJLrgg3ffzIhUZiLcJwtnKZXRe5z+LMKzWQu6XCW+qjR92wER3KAd4KAegfb19Y+6oP8bqFWAEUEfXjwI6K6O298jodSnP/A8ZJaHzI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH3PR10MB6810.namprd10.prod.outlook.com (2603:10b6:610:140::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 14:42:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:42:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 00/27] Native SCSI Multipath support
Date: Mon, 27 Jul 2026 14:42:07 +0000
Message-ID: <20260727144234.3802948-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH3PR10MB6810:EE_
X-MS-Office365-Filtering-Correlation-Id: 765bc37e-a08d-4055-e822-08deebed587d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|7416014|56012099006|10067099003|5023799004|18002099003;
X-Microsoft-Antispam-Message-Info:
	zriEcBGCpJHlkzGqPaVaEmnT+n01MpVh4lBhdDuiyckgVCM/fHBFf7UBEHUdUtRnO+XDx5iUO6JTfCv16owF5n3mQNtc6dLzDOG/K8NCNlkdDegaHicrMDtKgptzM6qaOVorM4uSQn0gqFrDZI6+K/g4EqsEe8/2lzvztaNzXJ8b+B4wASoKZ9O9NUtD+2eRwwSsH1LdoPHP9OMQHORhsBGhbw1vX4C09FBWFV9q9nvaYIMBSzOaDNGbMjS3QlmECvX/xPYeATnmzUYPnswm40hacbxo0DoajELRjUP4UczDdvkJTGf3sUi4uYXJyeGUimED8meOIECsvcKno/lbj1eVnTnvXrWy5KBsVKq4h09/MdOKc/ipjKPCnxYcCBrTUxtlV4zbnX1K2a/poreXJYhQx2UG5a6dV1Mjelk7YX91FAz8CzPy4Z0HqtxOYGi+e7GJk0QX6IN3uG60SsIQbCY8AM+BCFSEoYdvkHTs8bW0gyAX1WqdZVL5T0F0tw6y5QXmChDJhSvfSubYaYAxmk73bl5mEMgE4TgKLqN8vLY+0uTugOoivVg8oPhsRiMzYIZ/+7Fjq4wr9kLFWe+770N7oRiUb0N8qA/8ATNrdFKQV9JA6xhKarqtDgKXQ8EzPQpr+GQ6fM5xas5nXf9ZEebzawT1kKo/iV+UJXg8SOw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(7416014)(56012099006)(10067099003)(5023799004)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uMlAFyv+zSXoJhoYC+edsYFo1uQf2dJLQEvAe0SCcAeQ4gzr05tD0V8MaJr1?=
 =?us-ascii?Q?9nfG8+Suo/NJ7B3v6IFJkseJRO6fsrysXcJfewRtNN5NQntJIK8OT7btGMNz?=
 =?us-ascii?Q?bhjHPH5WScRIJ1CVABmKz4rZD6tEz2oKpynEbzyXAGsx4hoYvGcV5bGYbpjR?=
 =?us-ascii?Q?oWPQ7yXDZ8rLdr7Y0HRuIaWV47wNejy6gwpvoo9hqZq7gynHD/SxcNzJE2bS?=
 =?us-ascii?Q?hEcpoGYP7jg+JDHall3GvZbD16l98TdamJkYIbZFDY6xsfQFdvQJZjlFlkrU?=
 =?us-ascii?Q?BC69o0qQsJtqUn3sadYQmfEcWeOshd7GJKBPC1eKOnmpS8SREXIWp/m77SaZ?=
 =?us-ascii?Q?+Nx8AwxAENYjxjF98hmK1DgugcAzTmGjzsdpQKBTFOkbMX/a6ri0ZmAIto5G?=
 =?us-ascii?Q?p6kzrE4n7oP/zJ7jY638kC0oPUKnx4S4EFAgSv4aBZol8TTdpe9ue6VI59ts?=
 =?us-ascii?Q?sEONeL9mgBMucTixa1e2i5SS9OXNXxVPwTia/WR8wW4MgSbhpMjdYW7w0wzt?=
 =?us-ascii?Q?ImE3SitdOq92pkYjGa6cuUe1uR468q3hhWSDQ5V7Fj2iTxdNeKw+jxRSgYST?=
 =?us-ascii?Q?gVxOQsDRkwmMnvi+RGDBnhSoJHo0vpAFoNGHebMc/OuBZvdhJtw5/pqUmaEd?=
 =?us-ascii?Q?GpPhdGXS62VCMveIchpSG0hyuEGUopfZjgFeyK8HIoy2krkJEwRqDAF4cRcJ?=
 =?us-ascii?Q?glvpBaY54dMZp60G2ZEZu9VmzUJwhjCCN5RHda8FOBCwQi6p9xsN+9GzA0Bb?=
 =?us-ascii?Q?JGiBvdJxrH5kYS/Yli3ugwXeO3A0EIwgNrX3Yjr9317dYj/bhvMM8tojyzNK?=
 =?us-ascii?Q?XunCTM/fzTd+clFTx/l9maAcSU85JEr+iG3v8uMnMbOW+KCt2nQjVDNOQ0aE?=
 =?us-ascii?Q?L5GFBSIG3yZMT3mLP+Ycc4VZaublAlf7lhkWcPaFbWJeUUF9qWwkBv0fzpAt?=
 =?us-ascii?Q?zY8Wxg2D2CtjJFR412K4ltRqthkcWKoAdCbbt/FENKdHH6jRKxKsXWhdAtWq?=
 =?us-ascii?Q?o8SoNYUTXVrbjbCJTFocEghUYAUAEWHS6LLMpGXP5XKE3wMLzp2mtKsErKR8?=
 =?us-ascii?Q?Bf041auJidtf2104eFGqvsukS41tPOsSNijTxB7ZSl93GknLPumm+3yLh/5K?=
 =?us-ascii?Q?ThcAdCIiAcQDFNSmTzoYHmRLfA4k7JNVQgSwYmONMh7o+BMhmoDlSgPJguGF?=
 =?us-ascii?Q?KBb/63sTdvMhs0S+OSuOlNavEfLn9vmzPXcw/XZ07c34bhhm7C++O/QLdJU1?=
 =?us-ascii?Q?U22gVx2n3PUe6SD2oSfAX5wwdDXtpfEGt2pbDNdyALof2OZ2ji7E9ptMV37+?=
 =?us-ascii?Q?xkMSAKEeUOkeUPkXVzekrZlyKACGA2zJMYYG+irsIE6yfAu6+eWzCwvCY6yi?=
 =?us-ascii?Q?J5JXpZ/aAR64CqsB453sqxu1mtPJNZgN/sdQacJimM3+pzAuDUPb9Ojf+BIc?=
 =?us-ascii?Q?UTKrrKqAZmfyZMbGY6l+TkBgYxqubZK9pPcxFmrjGtzhDsDlzkAlh4GtD+ox?=
 =?us-ascii?Q?8pqzeq2vXMyBDCgxX55oEVWATca5TP+0dm/h0KIXPuEjG8fv9XnuTl4rC5OH?=
 =?us-ascii?Q?naxyfquK8Ykrj/nXdG4U3P9NUbISyc2pfW9ieHX/PJ6UHhQhL5Nd/uO+gRXw?=
 =?us-ascii?Q?9P9fa7SJknssRpYkwmfMwAE0gzGqvboyTdXiSfKjoy6eh38LHQv+3URfg3ZP?=
 =?us-ascii?Q?61BJLDvFC4voj6+XCxnU93gdapnTGTpsrhrdLUCp8qfHqmjCOxn3LQcktxkE?=
 =?us-ascii?Q?kN1rwqS5ozZEWSwaFTl2kOU1Qbxx+oI=3D?=
X-Exchange-RoutingPolicyChecked:
	eYg/BnPuJMlBy/Tvqnsz4Sz7cLyaPD1LnuW6mjRMlxnRXEC6vYFW1h9mdA8IObosOGDxVqXlkYz5ocDNJ6jZNrCQJ+mXsTOi0SnZMaGoNDfkugbqbHYW7bapbuSgzCre4By/Qzz45cqq5c0g326Ywi1dKsFS2YRuSgNjU4YvC0gW8TXzKer2qOj19f0hH7DWxO216PkGUOXMc7VU3RPhBV+FVvCCOeM2pnT7BXMeW/iwqYH4CcyL6Rap3O80cX2Y7LdgjBFtQ7S4N2yyngVDu+Hq2GJi6Q4zb0z+gchYu6Peq+AiOMy0sRWce/OA+z23oJLvl0pewpq1dKSvYygCbA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NS1k2xOFyG9j1yKFhQsmLdMq3m3/KcHFQXQcauQbELbdzb01cUgpOY7F8Ysq1Uyl4KN/vqwwtwzpVUCsRKOFbhLcFsVaotwMAwd/oMBGjHY2SViU/kVhO0fJl4vCDwmtPs2ffziBmJTKqJ21efwBS5LK7MG57151pWfX10QONkJSh9DFNzNcWjwpGapiaI2fQS6VTKo774FbJIYcNbUHWT1r0i3vXltDtJaLj9oPwP1xTKzejkThp4D/GIu0YJBdSKsHB23U44KYyD8OYSCIsTSlWeM5ZiuLJohTaazcMCzOOzfH+fucCvrO8OP3ls4fJRhIi9X4tdb28frq1GJBUKrcOsTQTaH5Dabf0eU0jcvWwbsMfnjGs8fNvZmpQJ6YQe9G223IB7xiFkkBPWHUBuGFN2ZfKhvgc52Et6JM+TvymCTKVExYnOHrUk/cSz2T/B3fS2HUscFm8rUw+FFeMB0VurBCEUtzIXahHoPSu74+F97PKfU9K8kkxaDNih0US1HLx+YtE5Mxd7uf8c8W5Bf6jXe6gwTcDnsD05u7TC4Y1+OXCCEXHoKbNALRcwcPV1bn4lgxuFuG7cNCWEEXl6HCgShp9qz8BAhFrP806Ww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765bc37e-a08d-4055-e822-08deebed587d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:42:56.1185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8r9ZsGCCsAKkiTEQSiiR+bqRMYJ7/L6nALX610Iz+koXRWprYNTmONynRCvPM5S8yzw1Yu19trDj1/quBJXjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX8I7fcPi5iRSk
 Dun59LqFNpz2hcx1sJWKeuxiuk3QbIopiDSi+wvfPdSsHYeVUmd+ehMpvEN2Y0AZOoItOCWujVr
 4UJnQKh3xTpItAGuSPoB92O1TLK+afwjQcOHrwe6GNqskfpHx9Ti
X-Proofpoint-GUID: fUBHFgMdRi3O3fiILrhYcIRIdiPFobwr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX0bZTyejqwCYj
 Cje8E8oXKk0HVrJfEqKqqPNpSo+QwSnaY/4/vJAahZayCiE3W42PtG1CPF00GnsCMFnWeywD3x+
 PE72LiBAyH6KMuL2NVg0JEU4wGGUsSKDgjWl5TjB/bXEplxaWLaR+fPf5kacxUfU4Fbciar26hV
 a2mRZq1oXzS30J8iI4cJ2wN3+bd7zWRPWK35azGJwEpECVON8yvK56GHLMbCes2pLt/8vAJeu8U
 tTB2P7bdCnywdJcwhJda7WJVeZ9Nc01vX2VdWgDXUDwOix+oxg5/vE8fLEbiZaEN0sUZiIsVf5J
 a19LDQUr3rVyjWcxgZYXgqjLAvl/tTcMLFTq1kc/n0eX7555UHFr88UmzK9qyXdjV/EGsi6A7R6
 WZndhEmApDdsySaGgMnrXoCRpgMRstR9u3KRvsgxXHCHdkaR0lVGmTQfGLKQWizAepzmlsFQ5jp
 T4N41Kwe8SgEFSXqqRsOP7UF/2EXuHvG20Zc3xW0=
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a676e77 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=H3UuCQoQRbyJsdEdLMQA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: fUBHFgMdRi3O3fiILrhYcIRIdiPFobwr

NATIVE SCSI MULTIPATH:

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

LIBMULTIPATH:

This series introduces also libmultipath. It is essentially a refactoring
of NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
-may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.2-v5/

Differences to v4:
- deal with issues sashiko/codex found in libmultipath:
 - SPDX spelling mistake
 - make driver set mpath_device->mpath_head
 - change delayed support to use unsigned int for delay
 - check for partition in bdev ioctl
 - drop zoned support for now
- deal with issues sashiko/codex found in scsi mpath support:
 - use ida destory in 2x places
 - set vpd_id earlier
 - iter through all possible mpath heads when searching
 - remove scsi mpath device later in __scsi_remove_device
 - call scsi_mpath_clear_path() outside state mutex
 - add revalidate paths caller to sd revalidate
 - fix sdev put in failover handling
 - use READ_ONCE() fo reading sdev state
 - fix scsi mpath start/end request
 - take scsi mpath head ref in scsi_mpath_remove_head_work()
 - fix sd_mpath_probe error path
 - fix sd_mpath_dev_show() for deleted multipath disk
- Add RB tag from Hannes (thanks!)

Differences to v3:
- drop for now any libmultipath specific NVMe support, like cdev and PR
  support
- deal with issues sashiko/codex found in libmultipath:
  - add checks in mpath_add_device() for setting pointers
  - add mpath_delete_device() -> mpath_synchronize() call
  - add numa iopolicy check for disabled path
  - fix trace in mpath_bdev_submit_bio()
  - fix race in mpath_head_uninit() / mpath_put_head()
  - add ioctl check in mpath_bdev_ioctl()
  - fix sync ordering in mpath_remove_disk()
  - drop unused arg in mpath_iopolicy_store()
  - fix mpath_delayed_removal_secs_show() print format
  - memset mpath_head in mpath_head_init()
- deal with issues sashiko/codex found in scsi-multipath support:
  - change TPG check in scsi_mpath_dev_alloc()
  - use scsi_multipath_param_set() -> __sysfs_match_string()
  - add scsi_mpath_revalidate_paths()
  - add sdev check in scsi_mpath_clone_end_io()
  - fix sdev->access_state masking in scsi_mpath_is_disabled() and
    scsi_mpath_is_optimized()
  - properly set default iopolicy in scsi_mpath_alloc_head()
  - fix error path in scsi_mpath_alloc_head()
  - fix possible race in scsi_mpath_find_head()
  - fix scsi_mpath_{start, end}_request() for partitions
  - fix scsi_end_request() -> scsi_mpath_end_request() order to deal with
    partial completions
  - don't call __scsi_internal_device_block_nowait() ->
    scsi_mpath_dev_clear_path()
  - call scsi_internal_device_unblock() -> scsi_mpath_revalidate_paths()
  - fix sd.c sys attr references to sd_mpath_disk
  - handle delayed removal race in sd_mpath_remove_head()
  - default index = -1 in sd_probe()

John Garry (27):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: revalidate paths upon device unblock
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: add multipath disk attr groups
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  13 +-
 drivers/scsi/scsi_multipath.c | 659 ++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 606 +++++++++++++++++++++-
 drivers/scsi/sd.h             |   3 +
 include/linux/multipath.h     | 156 ++++++
 include/scsi/scsi_cmnd.h      |   9 +-
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 119 +++++
 lib/Kconfig                   |   6 +
 lib/Makefile                  |   2 +
 lib/multipath.c               | 939 ++++++++++++++++++++++++++++++++++
 18 files changed, 2531 insertions(+), 24 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/linux/multipath.h
 create mode 100644 include/scsi/scsi_multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.7

