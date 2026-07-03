Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DA83C9ED0;
	Fri,  3 Jul 2026 10:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074753; cv=fail; b=RVRwAbZNwihyOUUclnUVNkdecPNPWL24e/m0gYuqSS5q+RtO8UPR2IlKZ/T3z4auUgrC4zx7V00df0YLiskxoQGZCeEqrzNgJVKWm/BNdyVeGL0LmXDXSXrQYYtv/roB6s1R4auNThc2I0YbqWjoF+fROC1MdINY9V6K/1lCWfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074753; c=relaxed/simple;
	bh=S4G3Qe0ouOVlmOoXeT27o8+UA23I7UAL2e0dbbtOzlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KaWCtUb03S7RTaXk7/bSsWoqQ8ONhHwyeK/qvPTu4ZNaaprOghWIbRGL94xqE6CXklnIlaGtYRwKDoT0xwWMCBNAsrAo31/gxrT08q9Gb7gLHEgXWUQOkn8x2NyQWQIPR1KM+bNYeTTaQ5F/RRFIQGXtmcPDSNmYhC0BgjjXH0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ufl6uQIN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KZSmBmK3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ufl6uQIN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KZSmBmK3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tprf3329559;
	Fri, 3 Jul 2026 10:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aCfheeqgyRKprv3PKGDxFcaftjCmCq0DnTY8r1OiIq4=; b=
	Ufl6uQINJ/2zM+HWTCSeNAM/+1DMu40lqQpqdqNIQ4AyD5BreYJLWqlq6T8ESjyv
	fxkHD0UQEaWSb1Xnb+3UGrlufCCYgs7j2+73kR08ZePHg9R1lFpk8zLXBrsWkw56
	FQ8dzxvQBlCStGFSOFpcmZ6zlv5ltobwSnKgnYc3EwRNZ1uuGiNjhGB6li8C5U5p
	xH4NYiUKZAFRzykKwiKCmJMni16OrW0+S5T/ISZp/va8afzKUxV4BeGbCstq5YLQ
	rumBuCsz3a1nO/PIBunEl7CfkO9QSvilfPo9orE42hBmgu96btsssYgQ55/FqA3Z
	zxQT1x5lwcUmwTi9pqDRUw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26mkadx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS8xe033859;
	Fri, 3 Jul 2026 10:31:02 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010002.outbound.protection.outlook.com [52.101.201.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yhyqqn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:31:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFafHSosfhR17PonY4wXHVM0G9HZ9dA/BHCoiVqmLD5PyhBItOqfzvrpFpa/TYnIniwUICwdsEEZu2tFvNqFYtvc/YeL/qb++m7SxV6ErSM1jHJKbUOIku3R+ckS0HALNHeSnGEebq0CqL1ODA/Lr2y4o4l8p03rEWHfr6M9v5SVIoAQkCW/IwlsQGKL2HxWcSw94/TzBtxHxYzYZ+MIDgjEQgI2SNUvOL4QRilp3UGMTuseXFq8WLNxMRqDRXD2+t1Qx/Q2gim1ammaVvubdT3BWmZZI4umfNKZs2ghWSkvqiueEhoGzks1D+/DIWbrPHtC7IFD18veLu++XhqjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCfheeqgyRKprv3PKGDxFcaftjCmCq0DnTY8r1OiIq4=;
 b=hE99TAYkq7KbARR5szRw7bYQJWeu9JWY5XUR5i90LoF4D74JKy/vHtOuUcRn0UcwcZJb2qOa2kR3V68Gm19zN6XU/desVqh7tNiSn3vhQ9y+7Aqw8ovzxZ2GQIrMVKOYN5kFT65j3WCEa/tA3p3ZRbjml4kJRs0wrL3/Mb9h75wYycrONl84LQpjUHEYjodpV/L2+fgdFxso7iuyJCfnysRZO2yo1/0F+9Y1XiJWbIYVipMpy7CNKroEMF/vm9gLxLZeX0MDiHEimVTMf7K16xmiYVdv74f4PFUPNayAZqGA83EMuxnEKoah4cy1LNM3jELTjYdkN0B1r2lfpg7JGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCfheeqgyRKprv3PKGDxFcaftjCmCq0DnTY8r1OiIq4=;
 b=KZSmBmK3NkRqhtG8jzJTZocjmSejPr9z9Od+6DHI5sJUF9mmKN8RiuhQD+XKnG2rEbc53J8p6utTkC7wJ79Z00sIsjyJCvHbz8fYIeulndkx5iFuoHKoy2wdaGkyd0dtRBCkX0wP1WDzdJc7dA1JdU70+ZUnauQDNS3vP/EqLKM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:30:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:30:59 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 09/13] libmultipath: Add PR support
Date: Fri,  3 Jul 2026 10:29:14 +0000
Message-ID: <20260703102918.3723667-10-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703102918.3723667-1-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: b303dfae-134c-4a45-d0d2-08ded8ee2c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	uQyLYoJpRM9aYwTvZkp5VrrOhKFt7ClUK5KkUan+nhCgXWA9aDN5kFBNEwK6pNz+qiPJ3LW3EEq52c123xJTQuxhhvFa5XZy2qxgEMYuILVivbzh7bcrko3LyXBrYE3dnDF1e72Hqs9S11jw7n6fxvCVWWBfXn4t6x6e4g7ugapO6k53c+kQHCAnf140LEPz8++xHD+skWzFJ1zfG4mchy3G4+Jgto0BP7UNqHyqKjBfHHwXSJ3UaDj/+KzXRMD8/J5E5HEkwsRPj4ojdHpdcxbtIdRZRiE94YtGbd8XXxU3jjMifZaDEPPw0OYoFIeBy4jpI2st9SNGet5TkC4jDEoc4x+9XKiY2D14M50uRzjAdQWIiiFE1+4mC3OFbtxokQ4rc6CMhaMEeP7wnd8828uspRsN/8s0QBuJHp6pPpKrIX0Nz8+JBaOtSKnF4UtJGsMD0D4vPdYB2xIIaevjhJ/C91rcpjW+lj8I9pZbD3SnXkcHBhlYr1ilK2Q4FjofXbCQeqR7vr5Xg9YxehoaS1BD8kDGvlW2hSjU1A540jQtPTe9t5ps8tCy9KW3Khp+QIPVTGdx1aKeDnL5w1YKLURCGoOp3IruiC3oz57bMDWUPDHcBt7uiVLkmu/tK/lpYdMXa/xegWKVkG9Z3wygr4GgbBJEEGX7wiclPqfok0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4745ttDazfUgcrcFgip0Yu99BtrHJMmmKI6p+pB2BnFV9oMHA8vLuszQwfmj?=
 =?us-ascii?Q?k6V5TWlo2cIizdIC0vf0NKGTVriAKThX/8ZR0lZ/X12jGsb+Mi0sxMA/nv/b?=
 =?us-ascii?Q?O+iaCwlOVYVhAUWfGSCIWRuvIIXR8jBiuivRFW15sgIm647Kt5HdCHB86dah?=
 =?us-ascii?Q?lJVoUQPl5aOqHhL3WHy62NsCO7QULVw+OJgmscIa0opOiMvehMtugyJ9DnpF?=
 =?us-ascii?Q?22lUpNbo2mCB/frrCaYoRkksBxr9aSmFqIAA/PNqbADpwoVDzOc25nzBUvYy?=
 =?us-ascii?Q?TvaocEOr94eC5Bftgk6jysDAouiTZsblBR5gTAaB9tnd/Rtrw13WHj5z3pjm?=
 =?us-ascii?Q?DmSmsho0aXNzMNvgMUR0Q0NXA8MXkn3JvcFLf1oWLeV5ZcYHpvuF/SaWetDa?=
 =?us-ascii?Q?7pCrRK3dihIKmehU57sxIhBPAL3fDf/uiP/phjsmkQLDEP5FtZAMI4QYOYoF?=
 =?us-ascii?Q?fRfXRdRkW2YMvDqvJh/Srq7ZI8k5kw4jOZQI+A6qSBoja6s13ABim5KMFpjp?=
 =?us-ascii?Q?PsEv96ajv+kSRp+J3O8BpJAMLJ67kNvJESfMgNgjuInh7it7xZAAGw9+VfwN?=
 =?us-ascii?Q?NZvJpzNJ6AvXgNp878oQTQTPWm83CK3WQWFjbORTVq2cT7ueSomBSSUyVNbq?=
 =?us-ascii?Q?d2JsOPixZc4umPuy90TXKJw12AD8Juku/45mvITFo/3cu78YyWq9OPr0FNL3?=
 =?us-ascii?Q?XshWRiOcr5z99GPIcOYUqknP2nbWo48ETcBXIuEkyoQRvsnOGhYO9R3bNkah?=
 =?us-ascii?Q?OzLZ1ibCSG+kJM+OBV6P+iFqdR0YdOWjrMQwZAfNpVxd/i22IyFcTHCn5cp9?=
 =?us-ascii?Q?Adq8ch70dyMIBo/io1+hJIwzcIaWKZuNspYvnInISVDILuk+k5xXh2l9iO6B?=
 =?us-ascii?Q?Y6TVRHE5jQDWRddAlGlRMHvbm+mMfGI3jyY4CHdqpmmN/K6H368D+T70PINC?=
 =?us-ascii?Q?nqQq4IernuYE58iv90gcDQJPyoheTojPhhAHRNX7vh2USySNiOV7sgav9NrO?=
 =?us-ascii?Q?kVfRpd5qu7zCaJ7FCSc4sUBO+bEGNSSvy0KfQoYte31lQ7EXBqYGjobo/kTW?=
 =?us-ascii?Q?YYciZdpws8/zoW7ePfqjuIqHQ52dTa9ATZwm6Ez9is0/cN/k7qmOPZCeEMQD?=
 =?us-ascii?Q?6+O36WU0g6QDZiBWlG+IerHz2mYl8HVed7NrOhtfqriLi0KCqIXJciGRvZGl?=
 =?us-ascii?Q?R6WpG0mLbba7iDTrR/gzl0+DulYNiKcWIFa5vuc/vgTOyhbepZYi2hJpUvSg?=
 =?us-ascii?Q?E7ncqYv8EgqTqu9QoPtc+5IEx9y7bKdmZrRMjkqd2KAmjNtfE3glqM0iQeyV?=
 =?us-ascii?Q?BvwkXToSMjQgvETdeaNq307OpTPthwSKxjq1j6qPytD3n2yQpNyvTVR8Z9Ue?=
 =?us-ascii?Q?h1t/FFsKe/D7nIImSi9Z0/RyigKH5O1LTP3Qv24IM8EFtmwqqFCffT/mi00q?=
 =?us-ascii?Q?7sWHGncj577B0EwX6+kpP+fIk/71z5mfe78cMOCtWbmVSCjrBzFp7KXvj0E3?=
 =?us-ascii?Q?CdxZdIOi1XfSmOXgwZziM1m5igBxMV2hrtFFUIiRGNBDHbltgZ2nquwZiK7u?=
 =?us-ascii?Q?HRkkl0lq6RBDT7HH4718VoQEGiCdCKMftI1nX/ymbWmaSqI2ZzvM8U4K95BS?=
 =?us-ascii?Q?Y+TU3VTABfA3ygmtymxrYVJNXjGtNBO4lXuvLF573xzzBxJnHkMRJAUdZJsh?=
 =?us-ascii?Q?8rVtysU7C2MS8//ZjR9MEABdlOsEMnLBUHtnLzTMyMAhkCsFeJWX/9sjqN6u?=
 =?us-ascii?Q?jIo20KDW1129WxM4ppTBlbJMfTvMaKc=3D?=
X-Exchange-RoutingPolicyChecked:
	l0CP/U3GTygIGrWBigvIXDFq0ZQN3zyEbOe1gEmfXhBwNxX4Neix8vhx++eiPReUYn2Vu35ql5HbYwOHoNd1ba6UAsUvVuL0W3TGvoRy+Oxcp7Q+tySdNjnGbkCtzc7NNB4OXOZRpKXHlQuq0J717i3YOokQ9s+hlcDUt+XF0wurSCcqMNu1uyUVl3Uze2IpkbCz8OPtLoWC2dIBc7dO8O/MRW+msqAuo4jE/s9KW3UGrpu664w6JxLQX6VzAzMW0G8AATv8xUlrbcz8aVmLvSXqlCRu2qKAPKWelJpobewGeFir0mXN2EUBfsgjMqV2qiPC5ywDJEPoIeUmY1XH+w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XjVvKvCJQ+gX/+jVtwoxExrfKUspwtfqpWXF/XSMKjfkDdrL5iz7LyjiFS1ZPh/PCxqMKZkM9l18vNvh4REEjRfjmYNz0Mr6WCvVFezlgLxMGQr0ta/0sPWnLqGX0npmkTe243uvk+Tw4goSTTGWWyESqvHXrPjSVi/rLgaf+IZCDhWxRrB/AtJ4dogXyf1YsRAoEP9Ug6vPx3fNrqqnhhJqiGQWHAZdSsTNwlnM/e0/Xgo7uSr3gOgsSDO8SMfbz5D8W1a/1wVQRlqpKmufT8CJy6CZnIWNPwufhbbt+Oo/PS+AUgEcEFonIAmv7yDPf6n1KmBg7YpXF9R4VLb5d4ppnLFxPpS55rPI9LCsAY92A7Y8TCDhRy14Uce1v/nIU0eHchIyHs55o3zKCDnIMPIFcHOEl/40eN+5rRa1bm9miH6QMURZeqi1EmBa2+pTXlIjzWBn91ryraX/BYWcdWuEc/SRTtl+blTDQEloIZjYNIMyPQWnoXT0Kv1aoUxMf4WZhcZ+34cix1SHa88AmyiSB1YMWcVfbGaef3magOgKGzEodXn8fG7opxaN1BVYR+itn42lmjpj17KPq9BjvUDildZqugGRap4A73MwQfk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b303dfae-134c-4a45-d0d2-08ded8ee2c76
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:30:59.6649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwvX2uNmAU9l2wkBSM1jMP6D7hmlKOC7wUBDMI5/3ISGqx9OmvGPdfyoju8CjwXuGPaWG2iDfCxqzMGlB3WALg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4tzo6+wFUZvN
 3HFicdvUems2YndJ4ewOUbCDDyfgh2Tqh9/tqdYZpRQCCxPnbVJ0E8Ko4R/s1TVMunvetExe0Kl
 zSZkKv9YzbNVuUbN8cf63c7mMLpYpSBs/fwk+XvOnmGyusIuHhW+
X-Proofpoint-GUID: h9PuYcprvChxFjh6RBlKgBg6pvsFY-w9
X-Authority-Analysis: v=2.4 cv=OKwXGyaB c=1 sm=1 tr=0 ts=6a478f68 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=zSmYoRqB51LVswEeA60A:9
X-Proofpoint-ORIG-GUID: h9PuYcprvChxFjh6RBlKgBg6pvsFY-w9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX0nMj7nqiSYmH
 3uiDj6g22JuJv5t/SkE+V1epDUgj6ATuKngoCAe+xusFRfYjg55ezbaMbw0X9slu3lS2nEfSVSL
 cSmuwqftBtkVHKoS8ae8mllUhN7N/dAS7m7KEeVBli/R6b2QI6ejGOBodqCGUhcQf3rxU55in7X
 0tF4XvyXuCh5D6zTI58eqMKFBewWCAV0KK6pZSndy60sJxxGA8NljKgrhEsPgV+BqXO36UAnNAJ
 lj2Q6I3pbMzvppw0AJx5830dnKH9piqa6Js3JJ+rTJgOs3AGwD7HEVdrhISi1tTERskilS0tLqG
 +MbpH7tpL5SMRNBybxAQtPdn73Y1mRkNeAuz8Ff+V43mzMrrkl9KlfSxCgUQKypnOTAXTZx4vKv
 fzTkiw9SzSzvRJkORL7Dhtd4mCi0u9kb1a4XJjf6xhEKKCMSuFmag0Ru6wxab09VGBWms2Fy5Lw
 4SHEMaKIS92t/jNU1zg==

Add support for persistent reservations.

Effectively all that is done here is that a multipath version of pr_ops is
created which calls into the bdev fops callback for the mpath_device
selected.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |   1 +
 lib/multipath.c           | 182 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index a335ea9885110..74ff2e4d33e69 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,6 +5,7 @@
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
 #include <linux/cdev.h>
+#include <linux/pr.h>
 #include <linux/srcu.h>
 #include <linux/io_uring/cmd.h>
 
diff --git a/lib/multipath.c b/lib/multipath.c
index 4945f2d847fbf..cec7047ce7b9b 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -491,11 +491,193 @@ static void mpath_bdev_release(struct gendisk *disk)
 	mpath_put_head(mpath_head);
 }
 
+static int mpath_pr_register(struct block_device *bdev, u64 old_key,
+			u64 new_key, unsigned int flags)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_register) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_register(mpath_device->disk->part0,
+				old_key, new_key, flags);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_reserve) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_reserve(mpath_device->disk->part0, key,
+				type, flags);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_release(struct block_device *bdev, u64 key,
+				enum pr_type type)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_release) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_release(mpath_device->disk->part0, key, type);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_preempt) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_preempt(mpath_device->disk->part0, old,
+				new, type, abort);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_clear(struct block_device *bdev, u64 key)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_clear) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_clear(mpath_device->disk->part0, key);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_read_keys(struct block_device *bdev,
+		struct pr_keys *keys_info)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_read_keys) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_read_keys(mpath_device->disk->part0, keys_info);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static int mpath_pr_read_reservation(struct block_device *bdev,
+		struct pr_held_reservation *resv)
+{
+	struct mpath_head *mpath_head = dev_get_drvdata(&bdev->bd_device);
+	struct mpath_device *mpath_device;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	mpath_device = mpath_find_path(mpath_head);
+	if (mpath_device) {
+		const struct pr_ops *ops = mpath_device->disk->fops->pr_ops;
+
+		if (!ops || !ops->pr_read_reservation) {
+			ret = -EOPNOTSUPP;
+			goto unlock;
+		}
+		ret = ops->pr_read_reservation(mpath_device->disk->part0,
+				resv);
+	}
+unlock:
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return ret;
+}
+
+static const struct pr_ops mpath_pr_ops = {
+	.pr_register	= mpath_pr_register,
+	.pr_reserve	= mpath_pr_reserve,
+	.pr_release	= mpath_pr_release,
+	.pr_preempt	= mpath_pr_preempt,
+	.pr_clear	= mpath_pr_clear,
+	.pr_read_keys	= mpath_pr_read_keys,
+	.pr_read_reservation = mpath_pr_read_reservation,
+};
+
 const struct block_device_operations mpath_ops = {
 	.owner          = THIS_MODULE,
 	.open		= mpath_bdev_open,
 	.release	= mpath_bdev_release,
 	.submit_bio	= mpath_bdev_submit_bio,
+	.pr_ops		= &mpath_pr_ops,
 };
 EXPORT_SYMBOL_GPL(mpath_ops);
 
-- 
2.43.7

