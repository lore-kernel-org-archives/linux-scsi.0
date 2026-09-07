Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A1B479885;
	Mon,  7 Sep 2026 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778315; cv=fail; b=N7hwgRbZ/QMt9fu+D6OXFe/KOMwzRlq/Q6tNgHbVVr8bhBRhA9wuyY4kkMQwV9vCPD0nVoIbIAdhZjC7GTA71EyXeHzhl/aa+wkc3a5E5sk63LiaZpy/BJ4FCIN/Ro674kdOBtTEfjuK5Cs74UOHUk2AGs9U5nBQDhvC1dyIxP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778315; c=relaxed/simple;
	bh=bPE6p7T5G6zNreqRGlEAePMWn7/MqHBi4FtSz4y3uWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h39pKpKFRXxrviEsdTmUq04civTHJQO8TVg4/nt0HB6VO39X/f2rss1MH2tTKA8Iu8+uE1FUYmoL7GPreBJBh6PXR/iEd3F8YU5y/QevUiLvjVL6EHintSFht3neehQ0c6yo1hgdRCmnHPofhLevAjSjOxgb6mSB3KniioT8X4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i7EfMHkZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CuiyQ5gA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i7EfMHkZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CuiyQ5gA"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68701eoV219204;
	Mon, 7 Sep 2026 10:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SyPiERtt95gEupUcKtr3rfwWHNQOyWfJp5Kk4BBvaiw=; b=
	i7EfMHkZVPKafTelN+iIgw45Bg/HZsQUuhH9Xmdvx397vkUy29I8IzcA+BCxH7c7
	zJ3R3ekyW9cxJ1aYhGaOekjoLsMbhJu90Bp0xHzyIS7GbZ4+C/UENQtxskEay520
	kf+79Vqthh9Z68qmM2lG7X9ccoCnIR/WQMYWvgCI8JWdnlb7wrDrgZ5LjZq0bRX7
	jj18PkpaYQs72W6f6vrzf5RooZcRN8cIBMH0YjAeJ43BN/cZohceVlk7AJd5VeXy
	xL8XlMNzjSvr33YBH+YidI5zzCqcBf4Dis2uZwwBAaezu7coFc4XPrPShzLc+wk0
	eaXPP5U4vP4fAxgBNdjFVg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbgvssfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687Aopf8019106;
	Mon, 7 Sep 2026 10:51:14 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74q8rtr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGaDVZwFnA3gJVoDy8ZcKtYPNTSrabZxlKTV+NBnvKA3I+6BJvHLLu2qGmEPpIVcXT/YFlbVfotuv/hQjZO01u4YUTg0GXYPMl9yKGf733fUVzb+ZRFIWdDNw7V+aZYJ+6yzrEQrZx0wfPZaS5vPmL0aDjz3+lW1grrBb2PKd6gfN+Rr0ge+2dbdSOlTGiEEzXQoajIul/eHDr92H9Fl7CYP0eBT2Pg5GQoe5UYjvKqWBo3UlUtKRYrA85wMnmJzCzKgBwDJ5RWn1wECfz7TXEdRonZcHn7FPxey2DpLUWohCR5E5OSKto5BP7fSADW2LJ1tbUaBvfSAnlt3xdpEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyPiERtt95gEupUcKtr3rfwWHNQOyWfJp5Kk4BBvaiw=;
 b=Q2hQI76oGVrYbTJTFU6mJUKWLgQ8s2B32NRm7ZxXlhKpjyU11GtjyV0vF5rN9PF/yBXbZVFCy2m5t4V8Mg+/hEr7mo0S8tnv6FS5G+TxIjNF4J1wiTjYOi1U5WR5nXp/qtvGe5EWHnHH8DaoJXTI3jdCtSo0FI+jHcJvHCIzcrPlDoMXcB92q0wkORZVcHWR5jF3xLEbGJ6QWb3/kYW2s4n1aw2hJeSIZRpQUiUgekZWuz2D74iFiJRKd13OHc2oPLR+HSE+FU/D/eAHZgvTvls/E/o6UQbLLuXie7bsj7uCDd1XFeg4ox5JJcU4vjM84x1XXgOEVv8644TZnoQiyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyPiERtt95gEupUcKtr3rfwWHNQOyWfJp5Kk4BBvaiw=;
 b=CuiyQ5gAxmco+d/mU04lOnqKQtldUzojnieeeHoV1gTrrdQ5ZEPxX41cmhHW5LZyp2ZnPPll3daiix3M30kLgvlgy9whTftT0Lw2SAMff8mFkT9laqaLU5/w804wyXMkfP/hKe9JEofCQJIRALgxZk6n+fPjEL+X2aJ/7aZg+x8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPFA7D84DD83.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:50:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:50:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 06/27] libmultipath: Add delayed removal support
Date: Mon,  7 Sep 2026 10:50:00 +0000
Message-ID: <20260907105021.1763236-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::6) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPFA7D84DD83:EE_
X-MS-Office365-Filtering-Correlation-Id: db6cf73b-5474-4f31-ad21-08df0ccddf4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Dc/RcAw/mnukUCDqKje52hkISvJCL3sakRFO1JBLg29YuK59q7R9BP0TOEOYhxdNRRbdXTLMH42//K2mfKlH308S3Ca7oIe+Iki0gb5uruNHuGt+fJxwgIIK2UN9cjI1aRJyC2HzMOVPfxwDhVShdmjeuyvTerPhRdL1atIhl9wm0RaI2I5IOsYKzX3AZua3XUhdIyoTR7LMbF4zqRf/FFlb6tdWU22L2kM6igesyHU2DBBXwy0EIjw6u6gvccK6O4o00PTXBW1eaLlgLtwT0YnP4xiMuIPVW/s66thdPQExEaSpzLG5zZjYA5WFQKiEchWyDuJKCEHHBJolW3cwG6sS18gVYq5sTQwSXrQsCcwwjtGuQpdIbdEcBzsz1FwI2FeQ/e32oUvjT0xoJ/8m3G+GsYH4lj9LE4JCPRv8O3eBtdiYG/CIXc/41fvfpGWuoHGYWX/Xz7mrxxzk6JKC75/nmdJXIH/eWTqj5wBzlbXVnpo6NO1VLC/R4WU7OGYnjQOaWUzIKHz8CjSLZUoTwNNJC8+vDIHSOHReIfCTtRTj+qjpntmZaEiDi4WFrJUiVW+539tSOSdJ65Xd8QU2D9m5ExYts5gmUJFyt5ruhJiK9hLCIGs0eGwuq0AIrfO6HkS4y6avTX2XcbkGEDrH0+l9pxBmORnocg9zde3AuJE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xB5Wx8mRCuDeEMAsg2BNLN0fAndwJuo/lc+4srStgxaFFB5XtfMQNFxyUBxX?=
 =?us-ascii?Q?m1VtT8Jrom91Ok06MdU9BDsulLDvoJT6f+RNB3pQOC6UTr+oxVWR+CVMXiOc?=
 =?us-ascii?Q?jo7eNvKhhehfPSZTXFas0E4zk93La82AfWnH9/95G68FHmYmdG4fCe+YXf0+?=
 =?us-ascii?Q?AEOT0HXlN0vxS3WsISBOMLV6AxuPJYCy+9CjD8nFYIjMwOQEx+jLl1hDTTCe?=
 =?us-ascii?Q?CfcFX17G6KTN0pyuScpEdcAOjhlvf2nRGR4jk0n/vwgkQQiRVBeCs0C9OgL4?=
 =?us-ascii?Q?aMZpJutGO04qUuVa+pZsguTpsJrPjjTrEKhrrjdMoYEAEMD8xMlNnDvOmgxr?=
 =?us-ascii?Q?+M0j7Ie2J5Y5iGZ1cBV3ZigFhqz5eoblClFaEHwoBwyjVyRDk/35+y+X3Qjg?=
 =?us-ascii?Q?hL+QvyFpF+Vk+0/ipBSiFy1VBkjDG7P+bUrxV33bmMPHt+kYxJG/tfVaI2gC?=
 =?us-ascii?Q?9kxXFc47WZZvchuHtRc6n4L1Zmd9JPlcbr10Ci1SXF9o6sroM6fMMVVd6e2L?=
 =?us-ascii?Q?SUWzmvFIAopZjrqPAxsGjnkjW0fd0SiRmDOK8dEdd9/JxyAGT0cHe2FdMPRY?=
 =?us-ascii?Q?UtdO+Fi2lA5wY0D+ejENutyK8SkYlLggQU7NIcEUOOTwkQ+W5y4OrAltb2f7?=
 =?us-ascii?Q?pUslIkiQ5AP1jn3nea6x2TXX2LkIAY8ODrGW0p3hqKnZp7MFutb8LNXWv/A5?=
 =?us-ascii?Q?L7Gksq3TgdIRKQaI/+P3qXKsRGHuMgIQ38KzyHEPJ7JKoj8z7YEsAxNDcx8H?=
 =?us-ascii?Q?vX2ofJCWVlKJhp/xSN+uNCm42O84mJZwyaIK6WICq+rtyAK3iy+JY3H0ILuo?=
 =?us-ascii?Q?9P2vjX02ezZWnqAUhy/2jWYfgEAFl2Hjhik0tnIbLafZ+NN9acZ3fK708cWY?=
 =?us-ascii?Q?FVdkWlum4jMROGgwzRZm+1rrfnQq9Z51jylFeek4AdZ2+q1ueyXoso6z4W0m?=
 =?us-ascii?Q?S5IzG6KTfzrWHLoOluAPaGxqXMUy+xqTi5Mp9xntjzfuXRZT2h2lFT++3WlT?=
 =?us-ascii?Q?vsPx6RM4kyCDKXVwP7ZbVT4NLIwzyFzDx6WzKcUU0H6cO74fYgMTN+oDPm85?=
 =?us-ascii?Q?OzOq+9Wjf/Yye3ruOJjOkvGOv9jqHAO/aRPUFxPGum0QONQzBCGvyBObQ5Al?=
 =?us-ascii?Q?2i4kbNgY4RA8LWo4K3WFX6T0awpqQy0KyOOZP47+18LFDjl1d/4LDbQaV2MU?=
 =?us-ascii?Q?+e4ePMC1/gRx8hIw/KORqn9TVR9gGPr7at40xeoPqXP4/O+DmSJC/1fIgQvF?=
 =?us-ascii?Q?EI+78k2uU+9IRbGmwXn7SJzYwafD5oWh1OWxN6sgJNCcBdlopgWadbG1LAw2?=
 =?us-ascii?Q?e6ASmPMdrBN6GAv4P6SUh2ev+9QKQLe7LAdXv2JlHUMFQGUK9w37fxXdAD7v?=
 =?us-ascii?Q?hajfO0mtSXW9GLafdCsO6VD6f5YZF0g5DEm4FokaTmpRUTVXMTH9sFJYv1e1?=
 =?us-ascii?Q?BEZzOiGZuQRJPhFYhh/R8pCS2xrbOGTiZdDvG1NzGsypi8yLkrMjdcf73G3m?=
 =?us-ascii?Q?bOYawR7Aw6S37RyL3nNSoa/GQ3pz7Z8uJNeah6eijjfkgOHog2zbiQO7Blws?=
 =?us-ascii?Q?09+YO+2k9JU3T5kAeU4jUWWDSuIgJFLebpNkJs0Bzybqr+Cys4icDs51Zy/L?=
 =?us-ascii?Q?8YAPZTU2KQ0lo9uk/goiuMFhy8YEuSIVsM3HSUEtg8J/DrXtdBeh5AJy6JPh?=
 =?us-ascii?Q?v5wb7AvIjAhswI5vBRIxFQMT7BY6/a8oBNTo4RcvYLQDFGdNO1OX2Lzx2Qw+?=
 =?us-ascii?Q?51nPe4wnfQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Kr9YNqCuur/bFymecI8njlZ/VdWfsjCqkYjGSOlFWqV/CVV+dl1YgIizBOxR4TEBCcLPXnI4iKW7Q8aefBJtyY2Qe2FyI4xGLpy1dR12BA6yjZYqEgPM1QhFKEtH2YSD9tSSFyvmkh6BxHMpdGDIJp8v3HAtX5tP/5/qCJKc7APU4z6aDIMTx1+paGjl0BCbJDlbVrRn0ZeIQ9C72g5IV9pUN2wZqmtyeq8mD+q6yoYBpchYkp6GRr9ey6gsOZkZTjGKlHjDrHBFBenODzzll9Cs5I71vrjy4byHkx6grsqjxtubZq1e7gBhNxD510oHlCIOl3m9eNE8q8M0iWUQow==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SFJxP2CDJgbH3IOqxGqSvQpDoDqVngCHY6CVaq57QBFsMkIMU/Ubcd84fI1moyMCjstFGm9i0PGf1dmJy1UppljjYowgHDx3wayQN8Ptmiv4Kg88fN9qkKFeUGoQhpWBRkddm9x3EiU9Q6ZUCACSZZSZFRcliTuqqPKbXAAaotRzw22oRUOJvVw6GHs/2JrNvjaOldLGeYol/feimRw7+sFfUP+k9xH4sAsZGMItArdpACYISCAgRM3yn2/9pSlc+IVP2+HzGL4RY8ukD6VzzNs9PmTy430F7MFVQDbJ4Pirye38VYJNnLemUrSWGqUC5O7WSNIbGxw5CWNsIcRnTZ9FEujq5XYOti6xowQpZSVoXuhORwKitpZtkLPqADuNe51EW3urw8c4ySjj6IHD3nlU0tm89+zwFzJMh8dN/4fSRz058AIjQEbLZ2JPYCm59lIqP4EPh9LxAzjlW5D7FkIMX4rAD4s1RsUbnOtgR43sJ5qxsd2AUxL/Xy8XSDTa9BAmVfUDxZpwrOPZ+U0QtuaxI04zTFs6WYtubt9I7hO0FJDLyVItbhLNl0LEHtfySIWjDm06IPa0hYMoLgejdxOZRakT+/nl9PFrDl+4i8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db6cf73b-5474-4f31-ad21-08df0ccddf4f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:50:46.6586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ds0opHQzf5KxeKI7oyNpZzEV2komeITqkvPJKFOm5r/cToBL+xwLqC5Bi84PnjXnPw89a3SOKJaasbY8ZEB0ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFA7D84DD83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-ORIG-GUID: HFjyhXmdFdVJy2xU_NtRf7ptLmZr_PlV
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX6R/sW01JTSwU
 J+KuL/+5vtticnJAguqjRW1ofdt1yL+5xObI+4mft2TmOG9mN6r6WGn9L959WY/W/7X8UvR10zB
 VFXBgoEk7VpxTCgYoZFNXdw5JCsc3g4bWThfmCdM/2MpKY6saFiY
X-Proofpoint-GUID: HFjyhXmdFdVJy2xU_NtRf7ptLmZr_PlV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExNyBTYWx0ZWRfX6V7nyl400gg9
 mTG7je4JPhv92lZpz9bwNzAgXmkKzlvGtUtL6Oq3HykJcGci3QKKpWKFDzQlBQBy4dvmX8PQgcK
 RukiOspMTcD5ENnWw+pksRBNjCkk38h1I5wt38jOMOH5LR00G0x8LZWQDjmM40UbhdZsBcBM88M
 VR7yfUh4VwGawTbDKy7WGH/f6XeEPG0+pHHgx/DL1fV4e1zlCdIEpcJS97gGeqimIirES6t1uCE
 9iUnezbmV48YUVkUZYVqQgNVuGU6bZKYKFB05+HRnFQsIiejAI14ZvE3sr6dtEhkJLrfXTSeKKP
 o/PUlwVKEbaxf66zkV6xF2C2uveUowS+2annmpS88BnIJmTtmr5aS2bw+RHyH7iPlPNr9yFN/M0
 Ru9JUmal72jn/VWBb3zg7giDfaJlnjAy4jvl6gqW6N9PYvBsv1p1KS4QdJnqrmZQBz8hGLqRcyf
 OVtt7F9U4P2en00ikjw==
X-Authority-Analysis: v=2.4 cv=Td6mcxQh c=1 sm=1 tr=0 ts=6a9e9723 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=BfxcaXdt0Lgmg1IeN-8A:9

From: John Garry <john.garry@linux.dev>

Add support for delayed removal, same as exists for NVMe.

The purpose of this feature is to keep the multipath disk and cdev present
for intermittent periods of no available path.

Helpers mpath_delayed_removal_secs_show() and
mpath_delayed_removal_secs_store() may be used in the driver sysfs code.

The driver is responsible for supplying the removal work callback for
the delayed work.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h | 18 ++++++++
 lib/multipath.c           | 91 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 033ee8d54bbe9..66b6ad9c2219a 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -34,6 +34,7 @@ struct mpath_device {
 
 struct mpath_head_template {
 	bool (*available_path)(struct mpath_device *);
+	void (*remove_head)(struct mpath_head *);
 	bool (*is_disabled)(struct mpath_device *);
 	bool (*is_optimized)(struct mpath_device *);
 	struct bio *(*clone_bio)(struct bio *);
@@ -41,6 +42,7 @@ struct mpath_head_template {
 };
 
 #define MPATH_HEAD_DISK_LIVE 			0
+#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
 
 struct mpath_head {
 	struct srcu_struct	srcu;
@@ -58,6 +60,10 @@ struct mpath_head {
 	atomic_long_t		requeue_no_usable_path_cnt;
 	atomic_long_t		fail_no_avail_path_cnt;
 
+	struct delayed_work	remove_work;
+	unsigned int		delayed_removal_secs;
+	struct module		*drv_module;
+
 	unsigned long		flags;
 	struct gendisk		*disk;
 	struct work_struct	partition_scan_work;
@@ -111,6 +117,11 @@ void mpath_remove_disk(struct mpath_head *mpath_head);
 int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
+bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+			char *buf);
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count);
 
 static inline bool is_mpath_disk(struct gendisk *disk)
 {
@@ -126,6 +137,13 @@ static inline bool mpath_qd_iopolicy(enum mpath_iopolicy_e *iopolicy)
 	return READ_ONCE(*iopolicy) == MPATH_IOPOLICY_QD;
 }
 
+static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
+{
+	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
+		return true;
+	return false;
+}
+
 static inline void mpath_schedule_requeue_work(struct mpath_head *mpath_head)
 {
 	kblockd_schedule_work(&mpath_head->requeue_work);
diff --git a/lib/multipath.c b/lib/multipath.c
index f24086a6e3012..9fcf0b743f0e1 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -66,6 +66,9 @@ int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
 	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
 	mutex_unlock(&mpath_head->lock);
 
+	if (cancel_delayed_work(&mpath_head->remove_work))
+		module_put(mpath_head->drv_module);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mpath_add_device);
@@ -339,7 +342,16 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
 			return true;
 	}
 
-	return false;
+	/*
+	 * If "mpath_head->delayed_removal_secs" is set (i.e., non-zero), do
+	 * not immediately fail I/O. Instead, requeue the I/O for the configured
+	 * duration, anticipating that if there's a transient link failure then
+	 * it may recover within this time window. This parameter is exported to
+	 * userspace via sysfs, and its default value is zero. It is internally
+	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
+	 * non-zero, this flag is set to true. When zero, the flag is cleared.
+	 */
+	return mpath_head_queue_if_no_path(mpath_head);
 }
 
 static void mpath_bdev_submit_bio(struct bio *bio)
@@ -481,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
 	}
 }
 
+bool mpath_can_remove_head(struct mpath_head *mpath_head)
+{
+	unsigned long delay;
+	bool remove = false;
+
+	mutex_lock(&mpath_head->lock);
+	/*
+	 * Ensure that no one could remove this module while the head
+	 * remove work is pending.
+	 */
+	if (mpath_head_queue_if_no_path(mpath_head) &&
+	    !check_mul_overflow(mpath_head->delayed_removal_secs, HZ, &delay) &&
+	    try_module_get(mpath_head->drv_module)) {
+		mod_delayed_work(mpath_wq, &mpath_head->remove_work, delay);
+	} else {
+		remove = true;
+	}
+
+	mutex_unlock(&mpath_head->lock);
+	return remove;
+}
+EXPORT_SYMBOL_GPL(mpath_can_remove_head);
+
+static void mpath_remove_head_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head = container_of(to_delayed_work(work),
+			struct mpath_head, remove_work);
+	struct module *drv_module = mpath_head->drv_module;
+
+	mpath_head->mpdt->remove_head(mpath_head);
+	module_put(drv_module);
+}
+
 void mpath_remove_disk(struct mpath_head *mpath_head)
 {
 	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
@@ -528,6 +573,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 	mpath_head->disk->private_data = mpath_head;
 	mpath_head->disk->fops = &mpath_ops;
 
+	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
+	mpath_head->delayed_removal_secs = 0;
+
 	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
 
 	return 0;
@@ -571,6 +619,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
+					char *buf)
+{
+	int ret;
+
+	mutex_lock(&mpath_head->lock);
+	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
+	mutex_unlock(&mpath_head->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
+
+ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
+			const char *buf, size_t count)
+{
+	unsigned int sec;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 0, &sec);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&mpath_head->lock);
+	mpath_head->delayed_removal_secs = sec;
+	if (sec)
+		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	else
+		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
+	mutex_unlock(&mpath_head->lock);
+
+	/*
+	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
+	 * by its reader.
+	 */
+	mpath_synchronize(mpath_head);
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
+
 void mpath_add_sysfs_link(struct mpath_head *mpath_head)
 {
 	struct device *target;
-- 
2.43.7

