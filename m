Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C363D952C;
	Fri,  3 Jul 2026 10:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074903; cv=fail; b=GJ7IiQm9VdFTgbqra6S5f8d3UETvkX4GbgPI6zZ+Qia2E2Nf2DJ8NFxGC+igSDCYiuabu90ibMsxqptMqa36ml0hl+PLhvzsqxj8CJBkNsJDC9ljyMbxVYeyLX96RJ4MQyD2u1+RW1ojY39dQfzs2tsZQuAOuGs85wDKkv3WR1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074903; c=relaxed/simple;
	bh=dneGfSLR8/4sd8f2ZKUZ8X3YQvIF7/VQsV8B8KwShXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V4rhMiF7avuuCnjwYc3aIgWvts7atFVLv8j+8HxfyTSAtvmiey1qx8mBKiCxLxzkkSU2+AcbufX/OYCnXMEbAFTvH3lrOhVFHhoefxXf1gthPeZiJHIerUUsb+hiG62vMDmUqrKhj4cy8SU4Zv8goSTwHhHpRIJW1x8KyjjX+6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OyrCqVPI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m8CGAmKp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OyrCqVPI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m8CGAmKp"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tfTM3187161;
	Fri, 3 Jul 2026 10:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8M/yiPN1d6R4h5040oUH1fL6LbjdyOz698fvulWv0b8=; b=
	OyrCqVPI9BUbZ+tKGGHLW6Jd3kY0qUh146E+TndgTElLczsHBFj1fYUs1U6xQNoi
	z99YZtO2rahV/10qHqrMH+UlGKFS5OSvnx84UjD/m85LWG9CiUFWuHkyVRXU7D5U
	9kD0i1nBQ7Jw1XlGo5zNZikduZV2AY/tefhdSJPLar0JRLokxCrYj3YvXwSAVkTV
	94jT89itGFd88l6ntS6LYODBRqSNSf4bkKUMUyZKQ+36ASOfF3CF2m5MlbzuZz5G
	crtyQNOfJwJZJX/zsCdNIp5HmFKhCYr3bxrtKDFo1SBVgxKGwZJ1/o9QbbFSg7jX
	X2mN7N2AyUtZ+F/l1H8S3Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kyjdb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXTcp019323;
	Fri, 3 Jul 2026 10:34:38 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f24yu87h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:34:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1Pi/3tyCnTMCYj75nJsijAhcvvyyopAKcIHHTPE57AV2LgR6Pf36sPG+DCakaVzpEfEMzKm7e7B/EQLop05QmCSnEntrI8ax2bxBxPW5eAA/S4yV0OoLZPqCyAtgl9xh8Z6Q93jFZVXblpuKFdOByZQuy5fI5xxj52nob1G+aDx6eCIsMFiHUM3YhcHdcReftTgrUhXEiXOYqW1+9QDfQh3wTX887pRxR9rmu8PhQvi7ie7V5all1QmzAT8a+7bU5FzFW4zVPclBfFQBTNpgzYaYnNqD/9KMKQUGkvJ+vfIFt1kd2IyGZHQH7Z+/j9SWjU249hit5QXmr8hVqG2Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8M/yiPN1d6R4h5040oUH1fL6LbjdyOz698fvulWv0b8=;
 b=QuULoif0DrRDOfdf+OeYPC76CxEdsR1qjjfdp8jGxLFplD5m7HAsscXjqYrM/w4OtzZZx0keiZ4r6X31iAd7UKSeVhlqj3VtjmOJSZV0e41g+1p0CcPIILQYfqPuyiFqyOj3fthyefeHv1O1PpxobX4MBnsG5+/PmjxOSxqnpEjHI1tl/toSF8hr5G4OTmioDlnJz1V5bfUTBIUTIvDgqf6iIXNlB0EJHyF6xj/2UfIK7CmmKAxZuDf9bWFopIMQmqotrZARvNncx+B88Yk1EA6GedEWnt/zNOO3Gk4Koixc3Bz4cm+hbdtj0P8AKGdOhicsskP8HoutkZN/Y9UXCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8M/yiPN1d6R4h5040oUH1fL6LbjdyOz698fvulWv0b8=;
 b=m8CGAmKpbqEYb7691GT82hivnk+uKLINoqOtSX5h+qz7dJizZUHIhSleaW5e8JgiJU2ANq0HcRSmlBJNtWKyll3Vn9bFZ9xOOkC9vv/ILsAV6/zAYbqm+dpx/jUV+9dVZyY6AzoQgYJHlcFA5r4IhezEnPpL/kvafc6jdW0wMCc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5549.namprd10.prod.outlook.com (2603:10b6:a03:3d8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 10:34:33 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:34:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 03/17] scsi-multipath: provide sysfs link from to scsi_device
Date: Fri,  3 Jul 2026 10:33:48 +0000
Message-ID: <20260703103402.3725011-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0053.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::22) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: c1be9f00-13bd-4649-9815-08ded8eeab0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	tXHPD6g4ZSfWH+370THcJE87sDde+lJjD4R6rU4XUVwHZ6pSxuHZUK9jQTJqVjKj46n7w1kW6IlyQWuk2vtO57Nl30MwTghqFKlYScFilEtBKx345FDGMNVhpv/HwStw/EAm6oGeQbtQRDpfDYw4jXaQS1bYnjFjlTv9lH1U8D81GD5bPMG70znht3gn53tSGdZcEsgSh124oQjtn7siC/wuNRwr11p3m2Vcxe2OXZJ4on3SKPZ3SGl3kqNWWEyQkjMuvwTidayUJ0GIy+Uzj2+qOEwZXOtBwFLZqeH3oJt2p66LvDdnJI87uANiJO0isN85Tld79gvJUp9sf0tut4aWjHiGToQ6/udrOE7EceGuY9ekGWgnI1L9z0STRHEkvJRQ/AYwIlzfKfxdTRQKsK+bA6g9oHx7JWF2GK7zglplqF9TB/jliEONK1eRAwtiVz1xIg1H1HruwD2M2dwuR3T4Zw6QzNeLB/zizdkX5f8v5Gq5e4jE5SSZ/pEZTqrjI7y4e9gFajpilBVuMAA/nHLQClrtXdtUEWPzqSiOpJG0JN/9+BWclQ/u0dCzgWL2VFNbzvR3TDWxcNZiL1PYJfurY8ZL3E8Q2Oz162qJBvUHm1WhPnKYCvB2yirhVebRf0+L4QPBMLscdqIuw43MrFQNWXbt9JZnodvZaCgkBkc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WFzkynsjPHRhE9WyKv+n9H1x0PUa6I4HeBoCo434XgCVQ39sJyYS+vPQJUtT?=
 =?us-ascii?Q?IrBN7dsMW5WKk6wiDBL+eypt32HkBVKdyxUsDGQPNDYowoTFoBJLNB5kadQG?=
 =?us-ascii?Q?bcfB4iZboCTJTxzUnUJxr2BGQy1WttxPeXXHnw91mSsPkrLFaUNn/i8GE+cl?=
 =?us-ascii?Q?eKDxzi1Jrd1h1KPIk76u1BAkn9swKPUsCsJ/HL/L0oYTlUk6ifAgfT/ALQ8k?=
 =?us-ascii?Q?Nvurcm5DVpEK2zT/ndNjBACqCGwy3LXfN+bNpq3hxebfiwIo/Til2jPs34DJ?=
 =?us-ascii?Q?pMMoMltCE+yDAZGfs8lh9ssWKjdGpiEHMvJiA/0P+nDdmmmggahLHPR+N0GV?=
 =?us-ascii?Q?3J8mUfBF8WgOO26i/r6zkiqGeIP3n0agXnOIqCaye7/MXX2eL2O6K5TSe16m?=
 =?us-ascii?Q?uencG4BZiYw2ZaSqbNoTA8kamZvn+W08P4RGZnOgo61B4yivqmunkU5DRITx?=
 =?us-ascii?Q?O41Ca/wdivaf1D/pNMylLjsLgAgtVNH6/E9uJ4HROtDuGwr8KxkUNHW+NSjZ?=
 =?us-ascii?Q?4FipI7+xOYv/SgWxu+KQZPP37T8Xsx65ECOL3Bm+Gi76OI6x6hUr3RzrgNoe?=
 =?us-ascii?Q?id8XpZGE43sadDUvl4+fiUSxzc+0d5olHnVaEUMcfN0VItJKhEFhyUNZFJhA?=
 =?us-ascii?Q?KVsWkvVUlPXH4CSHpRYCdaBdfCmHtbNNKO9aK6Dw36jzJcjw/c9esl0TymRo?=
 =?us-ascii?Q?+VMKipdwmI7nHTzGPOb8xXU9VbGgH2FQjlQgvVHaMUSNjpLawZKUMu+ADQ9c?=
 =?us-ascii?Q?bhN8X/nzYybkCvIbIYdTqwNQXTXGxwOv7V4mPYi8J8HkpPrw0GJkFhakkRnl?=
 =?us-ascii?Q?XFvKYfTdJXKapdaT6eDen82aDmjlmyj9yRlJ9DHQQLOrXaAdCB+nZOKXKTpJ?=
 =?us-ascii?Q?vbhcgO1wXyphhfYwhQeTcPOMf+ZTsGKoUrMG498LQbAq0OK8iHKNCb4c3Wr/?=
 =?us-ascii?Q?1BFCwcisgseAxI0n+78ysM5MoLC678MnvMHqyixvg8CpXxZuc6VSSZKJVa3Y?=
 =?us-ascii?Q?3RgvYxIKgzorftOEbnyyGxVknyDNfBWX79zA0dxXsnwK7FoUl8wu7uMvXOQS?=
 =?us-ascii?Q?QLt3EuTXM+bdVGTMG7bCL+iYSmwFfvo/vFhmI48h6dbfuNhhdEPIQEV5gDHz?=
 =?us-ascii?Q?skP9v2SdVXwd7FZ0ripnWgxfQHFNlHzJP6fk5q1o7ksbUaf2P2xa+Ipjefga?=
 =?us-ascii?Q?Z/E+ekzuEzv0oPFtQWtedJFZ6r2KV170fv9YzraOhMOdPCdrZO39yvplr9wF?=
 =?us-ascii?Q?3+PWEVloXoORbZJ1EgMKXBmocc5BC0OCdUj+m91X7+6mM4C7AbHAaBBQiida?=
 =?us-ascii?Q?L3gDJI04GiflbxLO+TTyHQF5qNl6vUH6HSaCn+8coTJ1Wf1UlsxV9ZzAmYPV?=
 =?us-ascii?Q?eaZaUTMPv5fFVcwDpQ3uETG8gDtTUQK0NBkXDDRf4HiTVyVAAZBdOZ2p6zKg?=
 =?us-ascii?Q?I/ludUTVYDMkX0Iz6cD1R/6a2iCOb9qk18VbjyDm6zmONiwKoRppoTABCeGp?=
 =?us-ascii?Q?lNwfOPKaqjJHKlU544niEqGCzYmNcEpgq61l2Itika0UtK584vSaLARqi6EG?=
 =?us-ascii?Q?0+DymuW+ad002p3cZEuRqh+TG/PYtvkH+8OchDlMEIwlqav/T1L7L2Ih6rWZ?=
 =?us-ascii?Q?VdeehUp+qPPE+cBTyUs1goBDNz+YTD9v4CHukasn4nbDBGCFh/E/hRRz0hlF?=
 =?us-ascii?Q?Ef/cBrG/2q9bHDhpRYoLaxyVNK6a0kMplZRgj40kuZpsS9liwuT2sJY4UslT?=
 =?us-ascii?Q?li3XMOgn0tlWM4zZeS2AG5AzdVVc108=3D?=
X-Exchange-RoutingPolicyChecked:
	Taw81HthmWZ6K2Kq80vJAoSg+P1EfN1F+yPCMAnqwjpkXlnkynr3BoGvLbFcA8UOV9AOy/PZl/D9cAd53ZTch9IWpOvn2zN/oVXr4z5LSZ018PNj5t/7wbmFOFmc4WXEQ/t2KR3lDqzQsTJpY+21/FFpfA5w0ZdbYCsO1nYZ1jPFA4g6Vnguq0sNZL554DlewJ0+vgQ0VWHA/ARAQkMgAKwQNNpiTiIWECzOuAulEGY0Q7W+TP5jm9F7vMp/Z426K5unoZXXqn8Z7S2x6+FHkiAv0emmKmF/x8xSRytHqGehvFTv0kjEDLzDJVu+IMuF7VVIvOnW0ncZ6ZsLj5+Vwg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f/A47YtgKKCXG4Zi+zWUMG9YF0ihQ1oaB0S/6lEytRc0ywttNYUYM7xZK4GlEbatZa6gWvXLw1doCZLR5qJPpUI58iSkOZv9IB4ZBxtDnlxqKOEPXQOvqu3C5ib4PdL1wy5P8Euj8VFBoyqnPzs+cB7DKM8gJvOvd7bqjb1+cn3FZ7p3O9xgHuOcMnYAj+vKfMYbBobScRc1B/KO59GqCZxwfIfKvqcIUgMQ9srTtmVqE9iGfVsLz4ySftt/0gmpnL4KTV3s2HO+xICZYbofOQxgVrmE+pkjGMijSdD8plqfd4Z+utOyyNbIyWvIhVWHs+AtasI4fFyiDeJd5sbcfmIec0UY0Kc/sOIwBQqtXFo/oYYDqNzGd07Axc/dZ0OQN1MNMQvUNWTvVvLZqmmfW3fV7MpvrTSGQtlmwtaXdI071mulEyDxDU8GgYCBn1UyX+xbF0GNm9zQ1vI1xKtlpKPvJ3bzswb0GYZmvNDXilw4VVlb3QxP/ANm7Y7MqDjGEkq6dBg4ehpGWouzztGS6I/BmNavb3zkArhEpwmZXG6Ha4U2QEhur8s+ye7qFu2DpCABrHf7+Q6hFhXxBsSK1ACBLUmLvHtlVH1KVmIsKrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1be9f00-13bd-4649-9815-08ded8eeab0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:34:31.9850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TubJXZN2IrANWyIEkcu2tNE+uMjkKawwEOJBm0edpgWCnMO4XBYaOngNOKXTKN6kOr8Rc62eu5WK4cAWzkwew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX998MnKN3ZdDl
 WWxUZ1bwBuzlOKhIbvVGXU6KiKOv+Y3HUmoYDubyzXE0FYDnehqurrA9ePIOWq/lgIFcShUwmgw
 h+h9b+2UEfx1vXLinMmiTIlmcN4P8bjVH5i4sNroyuBjbwNan0Y9
X-Proofpoint-ORIG-GUID: kQm3DszL6KZ8csr4JsKSx1kVpTtYyjP2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXyeXAp1rohU7c
 TzN3LsOO9hZA8SoQCKz1A1fCzjW99cQULNS3NxBKu6USsDE/8nWb5dKZ5Um6//ZRNP9SQsI7jUs
 InCssP0YIHwO8B89hh030MV5ZvZAvoBIZRfKH15PQelGgwGfE9sKBhTWhquyXqvDoW/h8oTJJAA
 O50sLa7jHMfH9o5XEfbEmuaI8NefiO74nKUHe2+ch9uyORONDu38tlBR5gQh52Z/i3IwBQH8WI5
 psDPKcNwY1ybv3CeozP+7ZVUqvwcrovd1UQcZtLNuBQ4R5ujYNPEie5eo+mf1ClHHe8zE5nuRPz
 9Ejpcmi3vATyH0ieqShCITcS/7yyClKThLktyZC5SRLKfbAWA4OxN4fgIODFYgHPk1dw2OwOk0R
 NhmhQRK+2WVUhkYywVwRoOT65VWw1fmkN8uajx1zqsdCf1cnIXDvuUxtO46mxWmIQPfUFnGa6Hd
 O3n8+LP7VXhwkj7xzrrVqTWjalJ4DIeOCkAVdA2M=
X-Proofpoint-GUID: kQm3DszL6KZ8csr4JsKSx1kVpTtYyjP2
X-Authority-Analysis: v=2.4 cv=ROaD2Yi+ c=1 sm=1 tr=0 ts=6a47903f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=ZbQ-JUxe3OK3M8wTWUQA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 51 ++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 ++++++
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 65ee3da5cc7fc..cb433a028dbff 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -104,23 +104,62 @@ static const struct attribute_group scsi_mpath_device_attrs_group = {
 	.attrs = scsi_mpath_device_attrs,
 };
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
 static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 {
 	return true;
 }
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
-static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
-		struct attribute *attr, int n)
-{
-	return false;
-}
-DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
 
 static const struct attribute_group *scsi_mpath_device_groups[] = {
 	&scsi_mpath_device_attrs_group,
+	&scsi_mpath_attr_group,
 	NULL
 };
 
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+	int error;
+
+	error = sysfs_add_link_to_group(&source->kobj, "multipath",
+			&target->kobj, dev_name(target));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, error=%d\n",
+				    error);
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_add_sysfs_link);
+
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+
+	sysfs_remove_link_from_group(&source->kobj, "multipath",
+		dev_name(target));
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_remove_sysfs_link);
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6bbaf424bd4a..9c4f8d4a6f42c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1443,6 +1443,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1495,6 +1498,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 50298056181f9..a9fd02bc42371 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -46,6 +46,8 @@ void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 #else /* CONFIG_SCSI_MULTIPATH */
@@ -82,5 +84,11 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 {
 }
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.7

