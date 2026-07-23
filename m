Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3DA42A7BB;
	Thu, 23 Jul 2026 09:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799508; cv=fail; b=SQN70nubfu98AoWV7fg1WYd1F2ds38AhwEj7IoHThIt6DNMi9IiM3bA1cT2zJV9/LpmESBhpK9aFC1lz7khJ3YweT0ntrX3BAsAEL26vKFxsTegu/Y3MkacN/LGbfsmHw6onU/PELn0jNgx23t/LD87PXqsdtWgeGoaWYHU1LO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799508; c=relaxed/simple;
	bh=6PpzII+tLOGLjy0Xa2gKITREMUr66wbpnSdMBH+cyx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=boM8n4FJWYTQjh3QZEyBKmiHcQoxUXvZnnylvW1SKYr2oNoZpJnqpTbkk5f/uFZXLUW2dIVVW0wGDNaKMN5EkukpV/cYYejWNggcQGYbsRmISMYfeTuUjlaMwyu0eViHQxVMVswHNBZRdPreS4Ht9rxStzf/z4kMDJ+3hrD9Q4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=p9/nOtwi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UaanbVZ4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p9/nOtwi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UaanbVZ4"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJthbn3353529;
	Thu, 23 Jul 2026 09:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8WY5zpBveHhpGo39RTEV8d6/FM9E1MSDdqlGBk7PMbQ=; b=
	p9/nOtwiuGBO97yz/AcYGBo44ZWZ2WqsuHAkwI5LGvXoqxQvy5Q7r5Iwv6xAzu0y
	pXLcxpql7WUx67IIfmed3h6Wgir2KhJaGITIX5E1ijvhQj8m9S9Uw4uSCwWBFiuV
	GEQWX9FhoI6J2K6ZeMDF1iKPtb1RmGY0jUYxAookjPYsNbHvrpaIkubNz1/QAbRQ
	S1y5GcwG2YgoEASW/W4VTGS6DDLxK4BWYMzgwiv582XmNl/dJjSThpmQ2WO5sHek
	DOrxRlTLR14dieaWOMm9pCmTVtDNSF69BmpoblSs7Gw7JZ0cwJYW+tblQ3oyXW0g
	5ltvDQQFswYd8s6qY5NZMA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6kp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9XYnq030082;
	Thu, 23 Jul 2026 09:37:10 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs5xfk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8T33upQZRsMrxNWJwBT88d33Kye6cDNWH+SqvpU3gz2jVLov3/rd+M6+dzeUyMpy4Oizav118xdlL9GD59Df5wrUABQMyaFL/z8t32lNrE+qRpv2C+23oB0Yk8RPEwsa8e2i4K7HpuJ3mPYSaNgmsuQUm+rwX5qoGVwYbPT9C5vIq6XUKxqRHelOIeVfrfwIEcb+O2ZFG8/kW1c3GdtT8SxF+jRBmFfTNY4jyaK0Yk9TpVRse+VyEzF6xtAK34cyM9V9G43WZ2lZomdB9AI8HG2Z8GYz+wF/s+MhVEHdVUMjpF+CaCCPm05cC+QlmLKS9zs4GQwowcCfSf9+H4xJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WY5zpBveHhpGo39RTEV8d6/FM9E1MSDdqlGBk7PMbQ=;
 b=M/Rvs1kJ3mIrtMVuYMYOIEBvpOVkKCujt4QsqgaII7SBH6b9WWws4xyhk3ZPHC6prstXnfpDE2GHvRmmRKrFppFqj84IWv6kx33mnWjY/E9BAvkEPchlpIZK1VQgIdgwYUW+Eo5L+9R6cclAD03gCTt56NfttQlMd8iHgJmBKCvTf6TYs3H0vg7HT+9qAf3PM+fR2BZuMX7VsveeoiTioZDj7kr/bFvhFL08W1qvyr3Ec3mrHPMx1Vk/yVRDYtJUcH+WM5r0VftUfoSZVt7TuVDV3fr07sHpLOpwu5eFvBQlsb4rDiHtENT+cywHPwNqDeHRxZTJH3778gKpZRewhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WY5zpBveHhpGo39RTEV8d6/FM9E1MSDdqlGBk7PMbQ=;
 b=UaanbVZ4NCvi0wkvPJQICcdKt/dBe8a1NeBUHTRen+60EbN1fWE2qhSyqamqOk62/cOWOdpb76Fv0NauamG5h6TqH04lOISUJRxK6sZnm57YRQw4PJwxr/tsPPyNRUF7QFsepaQYpqlF8bgT15Hus9abNWaeXZbjmsftQRtFw4Y=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:07 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 12/28] scsi-multipath: introduce basic SCSI device support
Date: Thu, 23 Jul 2026 09:36:10 +0000
Message-ID: <20260723093627.2327456-13-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::23) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: b22a8c71-72ec-4186-233c-08dee89df5eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KW7kq1VFHCgTODlDbV0PbMOG95FcyD0Kg/X+aif1ZbmOm87O0oqPaskkjged2pQF+S2r6oYIq01NfUFZc+SwBEMIk+IugGyppsN7EDJ5UXpyyPfOFrRMYwfVePkUhCJQSPzXiDWLFr0p/A/LggCEiqZcTePIgK1OwOrIBgpWhF3orgFADv7PHQSo/IbjC3WeFOl6P1MbRsay2zj4922MOCozCPteCNWl7YHDpZjG4B8igaeGyaxaWpIDhCOz4GWTdrOQ50Hd9HV88lmYgzg+bzrbtsfpt6DTMa5ukLs+6poe/pKrzY3ew9aGAfbxCZaPv1podBiyWPCrFV018xEijbsil8/M2dT1XsOvSZ77WfNeoT1NE5HbTJIg4y0/1XDdo+qlcTGmXmYExox7lwrPtFKB3AYLoK6AmyM+pXMFY0vUYl6BUrlJR+tbZgQBSaURRsgBfFWE4OyYu1dPaf3kn/ME5ZIb03jznzdbhy1Byzev/yxcFg3IDQLSPIATPjyl+I5wSQVbEhT6I1ktBtAazCdsc+KgTqlp3tVmEsHimPFxQQeoQdEY4d9GuyeopLO9M3s/LAIC8CPwv8qdMHPLrXJYmZ4gMPs3C7JHWdfQXHcCxcHTskwPqG0n3bOPJnaExPHKBL8cMBZ3+MG5YwSpYDEo4LHks6MU0SmWw97F11w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?odsM6570R3n6qwlUfnYqqqWSQVJVje6OHENG4DQjf33IU67HP4tbVf/d4Ikr?=
 =?us-ascii?Q?uDzX+tmXq2pwEhg+o4MiLoI85tkMkPz1FnCFnNW+Wv1fe++SZCOF0Kmwn2Rw?=
 =?us-ascii?Q?j2YuI2QuDiDSIxUonFMjwX1gzyDw8fZ7aAii7Dn+Z54b2moGOvmbPZjFnhpl?=
 =?us-ascii?Q?LMfqCihirC/fuOJgANqC9gc4I3sZ+nLLVsylaytFv0m9V1kwrcOlmUTynwwG?=
 =?us-ascii?Q?clfeIPL0hFYb4PuaCw4uYGZE01wNjRsDyN+yOH8j4UGT9+T2axdayMb0jTPy?=
 =?us-ascii?Q?/wkRP3M0tqb9lQUG7onsvtWNMvCoSUoP1ffAGU7CwtfaTkQpN+oB7/GiAne9?=
 =?us-ascii?Q?7oEc61H4+hJSER1tUD1O2Az+a4KZJapDYEqc1EXmIi3rom06WXVyf8b28M/K?=
 =?us-ascii?Q?MEHmHGpL9tvPIY8usQNAPVdxUuZxGrjRtasFRcIA7IYzoTBlqi/NGVR4w9cG?=
 =?us-ascii?Q?ddlmmgBYVHrYomF8pQngAsaPIsRz/IrYKhAL+WIw0fRKL51ylAs1DDXrTJOk?=
 =?us-ascii?Q?v46hGZqflJPqtvePn7NdcYgvdkO7yfi7Wf6fhN8Mc59uuE+oHpRjndiTk3+i?=
 =?us-ascii?Q?OQmDrz51apCqfPZiODnVkMK2L8LGDTmAdOKqw3y0QWmgiDVNWWAuceBecdEY?=
 =?us-ascii?Q?PFDVi4l4eoIG6ucckDEfu1b0TBPGSgVOHzjEWeUWtMTtYSz4eZSPBUnS+xiA?=
 =?us-ascii?Q?pU+6hYJIGOjxsxiQGmHRf8SYGSlCEX8LW4EAcbClglD1VGeSWRolELF4Zlog?=
 =?us-ascii?Q?XsHAI2NY1tmJgOJTZMicwO2RJsOfajTr/9ieWgPxVJ9DmME7r9eW9KSm5tuG?=
 =?us-ascii?Q?D9Lunia35XM3cqAAw5tubDIO9wpK469u/xCOoBTc9EUrY2L1FlJ40yhAYqtq?=
 =?us-ascii?Q?uGGl1f1WIuVy+e+huRHkDDNPmvTtl8A8E4W1SoV1Cy4OrfjHtGmkG8lcnxDx?=
 =?us-ascii?Q?yK/SgBBAW1Bv951tfofFt81zsbxmzd3peSRCVH3yWTKH3UC1kh+s3y+MDChD?=
 =?us-ascii?Q?fCdTlgFPIOmgqvtEQTwTKdm5Yddl4gIJCAoZUdoR9TGUOhP26qZyuKJBzAn4?=
 =?us-ascii?Q?HKeM4WwW2f3WPDtXC/lwZcyHKUxTr1HUPr9ttI0rw/JLL62pdDzVzMvCsZGC?=
 =?us-ascii?Q?lmR875J8a8uuVf27fmKZ5fWtvcN0GKAdSuM+48OsljFns9y54/PW1HRmCAv5?=
 =?us-ascii?Q?0gLaE5nKxFRSGQ3VbEqPsmIKGVxsy4VtX1gbfnnBGOYOSkKhA7XYc5YibE7S?=
 =?us-ascii?Q?V5s7T2zxHZJLije5BjBpXx5booYabWT7tOKcvD7Ipbl48AcC96C2redsUkHH?=
 =?us-ascii?Q?NY2Y3WzMdDzV7YcUfiMdq6A6wDOKWKqZCkZWJ35QhBqWLlNRZ9WZLq3i1nHr?=
 =?us-ascii?Q?GYdaEsrGKF1481t7MEDWmgqq++ANG1nRGyFVvasa/LJt1jiuQsshEQ0/zGW8?=
 =?us-ascii?Q?uhXUVwsTl5nh9cMb9KPUuKNjXFxsvP7AOIyrdwGOFf8MFzFBom9SxIU7VRnV?=
 =?us-ascii?Q?OI9UDOWxm3+X2V763JRfNcQv7ZvoisOy22Xj7zJaCaIaA4HJv3cKLb+ylUxF?=
 =?us-ascii?Q?mzFDAPQX3YiGF28cHlKn5iKivhSUMHW8d3vZjxfWDRD0uuMlfEHfCfupsxU0?=
 =?us-ascii?Q?+r3ycngeJH+Uixyy31saQIYg+73DqhOXGxLDlCjVcEXSHcJFB/4acSpC98d4?=
 =?us-ascii?Q?tmgeGR73uxgdmpJU6k+ojyM1ILT+DLb0uh3KfLtAQKarGQwIbdcNaCVDjbCg?=
 =?us-ascii?Q?AN+B9w51SQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	rGYLvW9qRtdt/UMZSqxpOxdgAcA36fb6hOt2t+Of/LTUZfff8hoc3MyVeMcYBdNeUFwv32uv4RgflkJyOfCtW3sUbuzr7WsWkB3okfOVITFQuw/iTqzzl5S3Ex1/taI3BoXBe4P3Y5fSa4i1ZzeBlxtuW3lc7mNtMWyq6iuqpFCuXEzp0aH4C/cKUXZgKUxmK6t2c4cdPLr48ejwHeey4EirYMYM+WwXU4zOGvICQHY6ago3eZoGJd/W9dxpzO9i1BfpJAVUHXwt8ITwh+MSF6keMUgPcVpQ9EiJ6UeWIztivi6cgRFg1PEdUhc8nmlMHLPTw4xgrR2T4Y4oo38Wjg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SvpDLsgEKCZaKcBie3zVuXoY8/xP+c8OjsEEIisKml4lSTYecQxF7zS8eqZ3A2D+0NzgOVnbhr6r0vrCtNRNiso6l1f200Bt36d5fSu/RM6WgqbDqdaK3rE6qxOGWLcUyx/XBiRz2m5z2CuDVZHmP+aeP6u8zyUr0O+05Uu/xe6kUjulgo3z2u7brYYUU6K/+9qw7yBcLZA34lcvsKuxdBsYQTw+nefJycT5gFEIJuYkTvzcy/GIapbf69YW5rp2p2K/rqT/luxAdm5FH2AyWRsS1h5HWI2wvWBoN0Kf7aD87tFTt4BEM4m8gX1WfsjPZxJMAldBPmgZSmhLXzlNuGF0NviFhxE6ww87ZEN9qxVBRQW9dvOPx2hG4MjXeO53lsNytFmeMj94vG2WQi5RJKdZ2m5FVXjEf2CHN1DOa3jbUyG9O4/H6YlPlprNlvFbM4Sk/cXjz5LEb8AphUm8BCCFUB5+PrMneZjwDr23tMbmmoacUZVvgpNiyez/hXTh4RfMgePArlCP295JBL0DzdaJIpQJJVeCKfYbYXKQgWG8a9q2712sT+mUz0IAu0xhRb+o61UsTMwlRVZwzfTvKKeBGlVaZcY4s/5wGB185Xc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22a8c71-72ec-4186-233c-08dee89df5eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:06.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HI3Fi4/UL0vnyU3ZvdFuxmMH1xP4g3qkQWIvtn5t7nklRuVMDHUiYcy3y4fIjIAEZQx+Pl4g8LDvWYh3x9/QtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-GUID: FaIsBb0QXqF7LhC5lVw-H-FJeQO3yrLy
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX/tk3EVW0dHdC
 jrYg0d0zedWrsIgfNm5PlHryQAhvLRSdOXNE147zBLnWLCerEhEDu9+ZuiZan43hl5zBg52SMIg
 92YzGFYMajF7qpOCs7Jts+C1bCZih6CvDbrshdI6ai0aMsyGJeEt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX0DOcrwYNvpE2
 26XKfTn9iMFVOMc4rHhgCQMHGlTVYhLvGODruYvjnZndBYj9ExvK2GzG7NhgTLtITmRwklhklOh
 3jCJNKhYao29Eh72kd+r7Fg8FUfDZRNnvjA5CSR15DeGIpgXCPdftg2XF0UFMtsigypB8X8BVPn
 Ssk6kOOJM8LC0cHxczsod2GJz+GQAxaKciq4R2msswdw/WbzwoAEvFQf1w7BmlSbonIKviVetSo
 dZEd463hAzSsNMayYax/ZdSNnSCIJg7Nk/CQbN74eHsb+zhTcRdF3vbyCJN8Njd9nGeOyw9U+F4
 QjF/GMJrXIrnddXbezNi7HflfDEd+RzqBge386kufvQRS0uMGiSyAGiL6jlCeQVZaUQtdjWAFVA
 F7c7bOIKWbDyjowKf457I9Q6NXTJn9M8yLdmIxU1ljgE7nEWHXWKynFUp0qbEDOLlzdIZ17ws1O
 5MebD2Dn77WbOHcPyIj3sMipK4eW640U88TT2CAM=
X-Authority-Analysis: v=2.4 cv=ZpPd7d7G c=1 sm=1 tr=0 ts=6a61e0c6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=pCOl5fTshOrEa-n2-VQA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-ORIG-GUID: FaIsBb0QXqF7LhC5lVw-H-FJeQO3yrLy

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and implicit ALUA supported and unique ID
  available in VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 146 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c3042393af234..d6c31df454825 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb2269..04f9c2e51fcbd 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -168,6 +168,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..70aa1dbeacebf 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1042,12 +1043,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1066,6 +1071,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 0000000000000..b9b58a3641aa2
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,146 @@
+// SPDX-License-Indentifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+#define TPGS_MODE_IMPLICIT		0x1
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int mode;
+
+	if (!val)
+		return -EINVAL;
+	mode = __sysfs_match_string(scsi_multipath_modes,
+		ARRAY_SIZE(scsi_multipath_modes), val);
+
+	if (mode < 0)
+		return mode;
+	scsi_multipath = mode;
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!(scsi_device_tpgs(sdev) & TPGS_MODE_IMPLICIT) &&
+	    (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0)
+		goto out_uninit;
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return 0;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a2..3f1ac302719c2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1130,6 +1131,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dfc3559e7e04f..2f80d703ce640 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -455,6 +456,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea0..40a435e66b34e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 0000000000000..d3d410dafd17a
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

