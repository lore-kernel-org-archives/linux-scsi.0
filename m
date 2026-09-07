Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEA349483D;
	Mon,  7 Sep 2026 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778341; cv=fail; b=OM2amNM0DkA18W3ynj97oQuLMckPaFkh+U2fSwrGjBsXkOURhSeT2HfqdcSTzqnt5+TmnF/bLSey2CubcQgmcStHH+TR/OV496U4VRd6E8fEZAx0IKAAG4++FHmAbhCX9DimccLPGo8/eaH1iGArHdl8KMxt4mLBg/QxXCQapU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778341; c=relaxed/simple;
	bh=0tHfHRxVgUg0g/f/dBdQLGON/+3npr1P/655VNCOZG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AYAiuRQvarJI63cNAtwd4nbGQ/A9ZTZPLRh1Lj9iezO4dDVdjrDNnz410czOMIMmCv1Mu3peeiBMSRAfKm/gep4nzjwPev5xPNYVN/PpovluTCVhuLK9iLEdsWGSwJD7HAhX9H0CigKllvIbhBhDDoouNpG13WDfq9En0hcC5nM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aKesivN/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uO9VA3sy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aKesivN/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uO9VA3sy"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6870l44l227842;
	Mon, 7 Sep 2026 10:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JGlwJRpmTmzi3d0wpKC+/WgXEINhpER7dUJPEEUIXeU=; b=
	aKesivN/4Wh+nAdQcTLahnV0m6iRL2wfrqyIqdbMRL/+Il4WVKtULGKY3Y/yCtFw
	/okX8zCLDYdtnjTz+O6maO1oDZmaT3+aS9PjpFNS7ws47UuOcnu/VMo35b7qk/Wt
	S9OsngEBrFyHzMy/QiKE40Zgwu3Eo/kb3i71xY2kcos93Vmfd8ZLOD4dbe8iZB6+
	8dqGP1GTjPzyw5tLDucddZuWBZy+Qm4ZG+ho+iTXr0sSCl/3M4UGtQ5iteb8Gb+k
	RzL5hJwtLow4tjEEA6TSMJLlyQoV0cZx4IDZpQvTEgwV6AI43bcd2zkcd5qe1ssx
	hs7WPIhCtXL6SvfwUJPExw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbdessgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Sep 2026 10:51:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 687ApfQa029304;
	Mon, 7 Sep 2026 10:51:54 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gh7aw8bdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 07 Sep 2026 10:51:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dg8DIxlpgVC9NOREDiDdzGuc9jmGKioU5Yu7cjdrpKFFozKaQjTjwzAWsxLIujJmJpjyiC15JHU4azaFzavDdkbzY3t0L+R+Ntn/gxXdq14V3jtSNuOM2oplgiEznowQH7bMFHVt1XPl1KfZdtXV8eGzHcfTtvuhVKZ5Ks+RW14cvlwpGs6tErhEMekLy643GBSp8yC+ddaKgOjFmfQ8rBzfFIaLzk/ChEPSjViJ2nquVYkWd/Bht94BdheAKFrRrDECPzsDJH6pcWAowYsX9EZ3UkcckevhWEoBNqDbW1RDb3vOGkr7x3OqgHGsVIOfqko77emXRd+Cyloxepa/CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGlwJRpmTmzi3d0wpKC+/WgXEINhpER7dUJPEEUIXeU=;
 b=q9QwU1eZS+rthjLd/FNNF0AKqb7DAiMqnCQZJOlkQMg/Zm8F9wbyGphaY7/CUWXlEFzytC59RgsceYrKurv+DrjIWRXDB0PH9vLPWqZPefkmk/Q9+yjTJA24XrwKILh3DxiZ0Ta6uHo1WJgxICv1oCEZHBqYHBgENYJUOEIflHcZqZR7lALVsrBp/zx/GCY+uSOU4X7TgdX+GG1IrKtMMhWwpuwkE2H5ed+fb0pnnd/ciRoNi8i86uJeB5hL/UHmyU9PjjhrAtXFDTQfsE6BHyBfXefKXNLMc0XmwMkxm3kJV8e2piBBQdUiVvPXLW5OCh9ocddH6pan7Qaw8CC4rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGlwJRpmTmzi3d0wpKC+/WgXEINhpER7dUJPEEUIXeU=;
 b=uO9VA3syoIB5kF3CcDj4sANhm3vS/kS8VutHZev/ZW1CZMrYBwt0M60cPropYS6/8wGrlLFfK9JXxTuIgOGHPAyPCpkkG/YemgSOZZQCHxWn672PfeluC0p37FNMMrJbqPnQ/RvVX4KWNj4H2hz68E7yn7ceLaKEttw1WOgw+Ck=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6276.namprd10.prod.outlook.com (2603:10b6:510:210::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Mon, 7 Sep 2026
 10:51:21 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0406.005; Mon, 7 Sep 2026
 10:51:21 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v8 23/27] scsi: sd: add multipath disk attr groups
Date: Mon,  7 Sep 2026 10:50:17 +0000
Message-ID: <20260907105021.1763236-24-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260907105021.1763236-1-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:610:11a::29) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: d99411eb-72e9-4eaf-b721-08df0ccdf3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|6133799003|18096099006|22082099003|20046099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	JFZepZ/72v6A8alkLS9mTyG+vjPD/ZmyjZNvfHogQ2QqAGbipInH/8vneFjZN3kGgKc9PDuDP+knwcOUkITuj3B2QICvmzsrIhpRUaiDlkxMMFP5cGA6okhdKQhqC6BqraHn2CeA/l6B+wMAydBA+wZWM5zrLk5W0oeX1Z9CEsobwQo/klHpp6OTy0MSuHnq2JJ6egHQC7GUsLJw7l9tc5fMqv+36SQK/IVEOz1glMWYJCJIZMZh7nJoy1H5OeoNAiRPrgbyQH7o13t6sNAtGrZU0KmtO9SzSVeCUJFobeYg1OCATAu1qC02tPIFT3Vu/AnjVv8HV9sn9BhWvnmYmjCCn8N8S5QiT2em83FJIEQ4oPpaLKLd4NPIZMayDI5FlmKOT73UxpEe7ltgI2QjeP7Sm+V9lNqc3UfTyvHdQmMAP8of8BU9GBtNRtpAbxQ8S3tIU8midPQYYfZhK2zm582JK/xRCklqom2iCnalmByftrCHSjM0be+bl7aj6pjs6VTyHzOcVK/k9WHQOEKufVUHtfoFVXuwdjEnyMIIWxxpOW11GBxXBnLiMQpGiVR7jK29vjq0y+P9vS9AYwzCRA3CkUVZmN4W4KGoHaFTkTdRKPa1WcDKf1KuuZpIJidEBUZ5pZnQsf3MauC5KEaPn60AySy1WRiBf2uFEPF0b7o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(6133799003)(18096099006)(22082099003)(20046099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X800RqqqmsqxbcMfAY35uY3GX8p+Ub1lVdbB6qp0fruq0q0k/R7spc10bGfg?=
 =?us-ascii?Q?36JIBgO7PBULgUxgFYirjf4DkjRufmy3ogqz4znmMZuKoreyqdEs3yRGWZKA?=
 =?us-ascii?Q?WjYuVTQ5Vf0xgblW7Pd47zqDWFQ62GCPnxhHy0mjVDS5xkDuMUpr/T82uFc1?=
 =?us-ascii?Q?ffs/lJosphwx575LkxLGPFJ/DDGyNAMmin55imEibMUGUVgGfRg2d01VhvW4?=
 =?us-ascii?Q?pCUOrTVDsdBcpik+dhMOwP7YjCq2L6gjztF6W5mJQtF65cSRM97+G4VdCAan?=
 =?us-ascii?Q?Zo0ZHBFVyxJ8dPO/jC8ZHMhw1lu1CbbANPKmG9egULbLxCPo0nZ6tyYIRaSa?=
 =?us-ascii?Q?S7KXj5LQ8TN32uFSrVXc07PHa9agKuSv5VQsIk6bphz69AgRBT3VcL4IHIHL?=
 =?us-ascii?Q?A9lJmgdekgkhZeYJvhgqKrVIb9H98iZDe2iDi6PmwTEg6JetU41S0Elr6x+6?=
 =?us-ascii?Q?bfdCY/Q+3m4rxegcLFcskrT4UbT+3xPxcyIe4uplDlKj3FnI8bP7thNLUm59?=
 =?us-ascii?Q?yp/NZNIrfWYD1yb6EPRKLTlbLA+Li1yUcEkUl96BJh6tCPi5d+G9S5XpayOx?=
 =?us-ascii?Q?1uzE47jLRvDrH5Tuadygu0u5mA+2AaGogdcApYKMmfpDNaoKct7RuE2is3wM?=
 =?us-ascii?Q?MxdLCKoyj6JKdIMOP0MEBIWN+6Z7YmC3nQbXjZ/2UrFgnfjGmkDJNbj8lt0/?=
 =?us-ascii?Q?jbqjFIbdA4Padv41/HB2yaQSa85vo9lrxVaw3aSP49HZ3HZus4qZi04iWWBs?=
 =?us-ascii?Q?nxnhf8Osy3s9BGGvY1dPSM0XO/aKU+cEwOTkNuwlp0palCAwDSAYsVKpZ+4h?=
 =?us-ascii?Q?c+8J7SmTeZezV+6SezuUocyrmf2Tw5yyBhenPBiJIE6r/pe/AFDDJ9/RboxL?=
 =?us-ascii?Q?4cysaYe4ZnPrx8/URBNmYJcE1YH/7b/ihvi1eoz+TgY3O2FxsJ469oma6GXg?=
 =?us-ascii?Q?keIgmRel0jOzolTI3Zvmd9/l1lQ6jDOrGZDAHgbyw05YJsoSO2ys19AB9Hkg?=
 =?us-ascii?Q?3TcSq9HRr+VYEp0jINtY0c/tACLejDQROJfXqzMqaKR1q4mamNrQ5WV+tIV6?=
 =?us-ascii?Q?mMuf3RozYnlGqdfeq+6xldFK7kxFdydcfdxFdjWr0OvzlLKanfQA/X5tZsZO?=
 =?us-ascii?Q?x0QBsLNWMfafbA7sqNQMqM4X9hhWMB1gq4VEVPEOnCgKEVu8cqaMi7cLJCbA?=
 =?us-ascii?Q?clL1oiO9/mIUkcC8NRwwNoY15VjDMcCw01+OUzTIaiCkoJgWmbiTH4XuFPKT?=
 =?us-ascii?Q?Qx+vgxEF4PWybA3jjCYaarZDPZbPJOqoQ5UTvHa7ZRtOqfkQ8sPmdxatLhTm?=
 =?us-ascii?Q?OLY0AR6NvVHc4UPsO1BTVceFSTyngxkt3ioG7bSGWUiIJ997Rx4YNtqm/LB4?=
 =?us-ascii?Q?i7FL2Lyj75362IvwDziu5Hc9h5hqR25jPO3jBkoIbtFeP3RWy2vV2W8sWsIB?=
 =?us-ascii?Q?+RAKhSzZ7VoQuYtjfkQR4yFh3E19hC9WniIAILoem6OW2sQjrm56TNvSWN/+?=
 =?us-ascii?Q?/vvk91+zzGhTkmQNosGtHeQJSOts1MFx2ZOJUIDPRE0wzgnb+LjQEOYx4Eg6?=
 =?us-ascii?Q?0bOhkuW0o+JZkGAuzy8++Ua6lieWUyQVFIl4wAtOSxDqtDCl6GqYx5kJ38XL?=
 =?us-ascii?Q?JixgSNWAXwBUVQo5edDJRshdN39+ENS0cAoFb/Qq8VRtmCzLuDOFRRR8o/OW?=
 =?us-ascii?Q?NS5W3CsPFezMiMnnd7OZo0zSk2U2DghQHYkSrMVNqrFk2kGq4prFsjImSDhL?=
 =?us-ascii?Q?wjOXVkmenQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	FFb3fhryElZrrVVrVAktzGBMRm8sQZl7mhC31ph4i8JsZnp8A9W3nnNaJyrAPWWrPGqh8xi/5yvvPsG0aKTBRDa/uSNeuJYlfkgrEYUN0nfNtCjfwaMDR+DjQFB9Zm/c8pVb/Pyp139un7JfIzvTKErK96irkip1yFskAcXPvMrZ+UIWTi5zfpmAt05N+tDeAIzFpdI6onVJzSPPUzE0r24M1eUzCks0SbyeOMkSPTeMW3whE7+RU5GGDT/po9WmxijAN3rGD2CqrMMhbl13vY+RW1J+A8W7BEPSNhHjf2tMk6cebqXd9OLjl1FIvwCeQKb7HthkMDQwxW23RLpodA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gCLRuh3YpNV+6rPGrn++5r/Bcs/tCWAEyEHzY9Y3+zPnczcEugmFd/GAuW5Tq3/Duq00oBJpd/B3rZQ0hPmPMIkKUGePR6cyi8ThJ/o7Ir9n+0l0iSTyEzWPu6xgiyIYCUYhQ5RK+g8/zG3buAfmhFEA+ATcxmQ7AMi0LpI/hkLXzHAxuv37WEPV9bHXq1qdoMNBnRCy+BVuMvHNkeAC1icNkbsmqZjjgn7Q8H2LTh+5ujqpLM10NDUX+0A1/7v1Q6mguu3rWuHSVoC8C5ZNEOVFRFC1hE7tNxcYAtckpfOgNnXJ4vKWyzSySx6mIsMQaNYQGQRw0P5mcUN0L5Lfi3/wYxMb3VpkUqykdTDdJXjuWle+SHcVuhRFHeyvPrfyxvJ9OIdiEaRjdcXu3BPDml5OUtdsj53m8teliSCpSgbjkNtSqBUYCQeFx95CNFpa+mucENrZLQS0atkVR1Nj9s4TYzEGALKkuHW915VZq2TNBETxJFLzOKHSXLfO7GKr3L3Ax8XDne2/BDUytN166dj+2WrCGf1p0xFNqOu+AfDgZJ28VzwWy1X0eDbQv48REg+QkLgl0ycR+vO0jfI9R8WNolcLu0O5jxZuUoApOhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d99411eb-72e9-4eaf-b721-08df0ccdf3dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 10:51:21.0291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BSpf8olBxwuLey9HAnM0yg8bpGemUUf1naRc9lQqD00pg5A5dbpm9Ey/MdwrpDTwlZwTx6oPx6hoRXRhkOzUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6276
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609070119
X-Proofpoint-GUID: W7_mmKZu35DuCVt55HFnJpUXtAs5qzkE
X-Proofpoint-ORIG-GUID: W7_mmKZu35DuCVt55HFnJpUXtAs5qzkE
X-Authority-Analysis: v=2.4 cv=R94z39RX c=1 sm=1 tr=0 ts=6a9e974b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=4WwWyauO2_0H2zdGQVkA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX8i45N8g/AN+2
 It2suUvFeLSj+putfakfg4Dp2/1VKPh8PIKSl4ag1AJgznSv4JCeoiHfzCqXN2wnIQAin8ynQ3/
 vxN9BzkhD4sfzB/Kc07xuZtF7CE3HPNjwq+YLbcieb7bwb1OsDWef6+N0DNs+JgMBuaELNZvx6u
 9HSWKwH9VrQrurAYhiEWmbEWPtUt5M4ocYm1Qp78bm8yo4ze+ATkSF1eeMBJgsbhlW8cBh9Y/W5
 zseAEsXQgvV6tQqcDNtlB5gqQJHP+/1nIyS9LxQk4Ulg+aI2iHdWI9TyEQvJmli5kEoXlOhsubL
 XlE4+UPNvvg+jNBhv9sZ8n3pBy9GnrcHDhmLPqAM6mrDxPKMUKXKDf5SuemtFfAhD1snyAYtRSH
 w/3JapOBnw5ZTspEur2Ot0az54B7t9QDsI/pXaLiAqbbffDeQnaa1OiGZ88RlAr8MF8dtcvEDbp
 lpwGFU7p8RcOe3i5wWrhfKNbz0aDDk06edo2A8LE=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDExOCBTYWx0ZWRfX+oVs2dzSiPV7
 +f13B041qXicdJoXQGN3CodqtlVn+LgpX9lJ44k0EIkFRQDxx9BzDQxvgZ/Kq9ez+gjTvF72MIF
 u+JeZYVdTG2BDBY02e3r7Gdu5VScLHc53vDLIbi2YyZxAYbmVS5/

From: John Garry <john.garry@linux.dev>

Set multipath disk attr groups, which includes delayed disk removal and
everything from mpath_attr_group.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6847805215bd7..60e071d23ddd0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4019,6 +4019,42 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_store(mpath_head, buf, count);
+}
+
+static ssize_t sd_mpath_device_delayed_removal_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_bd_device_to_head(dev);
+
+	return mpath_delayed_removal_secs_show(mpath_head, buf);
+}
+
+static DEVICE_ATTR(delayed_removal_secs, S_IRUGO | S_IWUSR,
+		sd_mpath_device_delayed_removal_show,
+		sd_mpath_device_delayed_removal_store);
+
+static struct attribute *sd_mpath_disk_attrs[] = {
+	&dev_attr_delayed_removal_secs.attr,
+	NULL
+};
+
+static const struct attribute_group sd_mpath_disk_attr_group = {
+	.attrs		= sd_mpath_disk_attrs,
+};
+
+__maybe_unused
+static const struct attribute_group *sd_mpath_disk_attr_groups[] = {
+	&sd_mpath_disk_attr_group,
+	&mpath_attr_group,
+	NULL
+};
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
-- 
2.43.7

