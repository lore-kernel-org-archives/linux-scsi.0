Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CE74322F5;
	Thu, 23 Jul 2026 09:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799493; cv=fail; b=VGmF7lQeT4k+6A28aSAjpXtXhMCXywhJ4EAK4uLA4rQBXopfrsGrIFd3Bw0HlpVCAESSgcqeVy4/duTDCup5ln2dxv7NZQGSsBx3V5peQVfUCVEUSrO49CSkYJ11oj6DDOus8+cHYcMBcGIuvvB5IwKH1SzH3tOjndtVeEMnhT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799493; c=relaxed/simple;
	bh=VhKboXGuMwIOVGOfv42aqalImvUo8hmH6ZtDVhsRm5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xem8CubGDBtNYPA1J6ZnVQNIsQ8IM61qH3POc1QY/sY1BCLwFJeoUC55j9s4mWVThJaExNHFaciSwzjPOafZ30AVxAOUaN0t4bOvyNsvM/y3I2Nr6ssXdxBZqFDfGlK+Ybz0bBjidmxSMlsKH2OFSkGAPxa+gnk43ZcENqW2O6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ngc3jqco; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EYAMKi9S; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ngc3jqco";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EYAMKi9S"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N2n7R0080922;
	Thu, 23 Jul 2026 09:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NGHwTZz18H6I/MB7c36ghyxfhyp1tjhdoXl6BmjK1uQ=; b=
	ngc3jqcoUkp8OSiuySP9kXaRxvqlikobbZPanE4//DSGidKexEmy3HnubuyXrvBi
	hoOo/Es3v+8qFctmP3FdTtyJuv7+l+sVicpRWl9oATStvWUGYsODtgO9kNdRiGe0
	j7H2kNlxA1q8DOEt9DMBPW7vX8vqEdknFcsXs4XrrSynPO9PHBg12i5aKD1rCAyH
	Ons9wSCIxafGuUSCJbS2e+pNiqN25+PvaYvZMjTBPamI8J4e5uJlbhZoenr0Iic8
	KQJ+VUCQByQFcBEjdf45MIFNgXB1b+2r/OAjzqAX6syGvzWYUfGOBzg4W8HgbryO
	pY1GrI+rPqf/HiCpoq2SrQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqpqct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9QI021137;
	Thu, 23 Jul 2026 09:37:28 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y4cn-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJDvcwYdlkBHp9VqnT1T2ttUVZBrQQGghDJ1/9C1PnaAgczWcio/ljaGcu4Ol6sGh2QSeMkNn/oavJ4uonfpS70BUAarCBK1taManhlFjy3xWPOFzbhKpxubmnEuXvTq4gaE0K2G8qAsD4Jms/MUG46aIpouNNxw6MqfqCnq4vbKGXD8dEHgIbM0NX7IdL0+BZ0/JGkceLLrjKAKpC8ZQRq/667ssX2oQ3SQPEPGQj6bm+wfDbk8g3wE1X8TgTPm5MoL1dTxxUuGm540WDMZGo854X8l4iBQIU2PJDcOaw+A2wJMz93fU/ux8PNHnIk15MSxK0a2vjo/zfafzrlCQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGHwTZz18H6I/MB7c36ghyxfhyp1tjhdoXl6BmjK1uQ=;
 b=J+Wj9ajNQYidDrYPgRdQaBx3Yi1c/FPhMTPiyfWHXwMyqqXAJ1pLqJgKim48erDH0mxS2zqmK1UsW7f/EjQiQZNECpkwoob9APqPBUXkaG1MutnkQNiGENnHnGWdLD02M2VE/Zha8yjvG7c4B3JuNi8EfhEQIrIYHUoVhhVcIufcROyxmWrOm6Cmp3kGAKXGZkw9tERIwedLEJ+XL2/qhbX/qVFDOj86urcnZm7/dmk/hVviiTWWj/ht2412GjcGkJVFpX6I1CySiRcptcKr9YIzv1S9blZ7kGwE2UQ3Wmy36pUCW8VcZgV1oROPouwkOpg6FZOkihXZSOvmK1T7TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGHwTZz18H6I/MB7c36ghyxfhyp1tjhdoXl6BmjK1uQ=;
 b=EYAMKi9SvnK+YyHKXi6VTqi5EWJmsuQHxDPXdpBEGM04UoptUxreQctLsiqhvwGFkGAnW3GJQc65uaoPgaH22vICOLAd/XVdOip6+TUlWA535w/dS0wjm6KE1DGvn3mQ3ZWEyBCs7SI5nhaySB2M8+9FhHLn1cwm842xvm19xOY=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:23 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:23 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 23/28] scsi: sd: add multipath disk class
Date: Thu, 23 Jul 2026 09:36:21 +0000
Message-ID: <20260723093627.2327456-24-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0037.namprd04.prod.outlook.com
 (2603:10b6:610:77::12) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3a0b78-109c-4ead-7d0e-08dee89e0006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	20dcDpc+kU1+dH3sgoVuAkvamqW66L8ZkuAgbrkUOWIXWfq+DYpJ0p1p+2pqG9dWvs/HmaP4uEXPdrFrjbrO0ZqvsHwMND46vJ8GLZ+isk8RQwOLGvPoQHrzryM2DKRH7W1yQ5FkiOKxs2kJYC7+DjbS1CD5Gv9b6FlkJnM9ivT/n43z+qNkV25m11jIgGQ33Xk8LwP/VEFkSZOKYAn6KYKKJnig8MtQUNJT7mVl55jmEfRuLPP/JBE3o/SMjkrk6siCjnx9QsMKfwTMRKZJQZfwyXpBzIdfDVrfNzqPxppooMtCks8d0SubeRD7X0WNP0Zr7Mg2j9EnsPwVcKMJ5wWUAOK3AnD2xWDimqudLhmf9dfoGkiodghWYNocHJTAx4054DeAdmywKB/zboCo+bPscxMB5kEXdqDa8Wq7H9bwz5iDcRnb4xUqCM1PLppCh22Aaq/9UKm5/SUhjhD5CnAMcf4nhN4atIg1l12LPhpzqyUblrergfju85h8jUQkgoD/vgGaiyVtB4MwutMQODdYa3B17a/vt73ISR0mlFNclTFT69JduaZnriQizKYAOGTDRneZsiHVLJvX2y5IaSZ1ZO/WmCMTCPMBIeJ5YL/+Ak7QxuyA0tzixsbUfr10Bf8knvpOi0nckUf7FhGr+VIJD4zFA4x9Gs/rYx6bCZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6EQHi2Tezin5BQMmy+hPVxYRMrWsrsLFxICUsxEBQTWB2egfm/YPyteJ5neF?=
 =?us-ascii?Q?WuI8KmayiL60ihO7j9hfJcvyoynoXY/w1DKvk9sC+LKj6eiVU0UM8rGb7Yf9?=
 =?us-ascii?Q?sX9t0VOvZe+d6ZvguAxjlo6m6/cY/LhHNzeG4AhV1SsVDh7P6rkoaP6lWPZV?=
 =?us-ascii?Q?65lAgjEogkhmEdvjqSPY+GQ163gbgSN5egUmVtvAH5lEyY+6JIJRfzJfpvZ0?=
 =?us-ascii?Q?r2Hv+s/stK5RP3OtcQn1tlUnk/5gT4G1ZTVaibMT2knqe5GRDGFVssz7FiVv?=
 =?us-ascii?Q?e9rPPAkzH4Ctpwy3sZHOQ4WK+Gim+5vz319ATpFEZwTyidlVSqbNNdj1JcXI?=
 =?us-ascii?Q?PWAl1ICZMw2X4kK50na+rysLA5LARUeZF4xUVjypxONb0cK7bLM7vrYe+DDP?=
 =?us-ascii?Q?H6YS1O4rA0h0nAfIm9vrmkp984j2nZh5msG9c8QFH4RpuNsK3NN22/cL78uM?=
 =?us-ascii?Q?53NwyPDh+1ZqooOeFXLBSAOPQfnr4Bz9IpJkVHwpTKe1xjlenxqLRpF6eoY/?=
 =?us-ascii?Q?emGBJ5ulxWVPlqEU6Vl6xYYttW4m/9IEIzxYnHihkPSiHzkXjEUxQxXVYGqv?=
 =?us-ascii?Q?CdWmNIgHMKheP/2kcmI3uCSO+IjLOJ4kffC1Vxga+tRnVo7/0qNHNr59i+2W?=
 =?us-ascii?Q?Cl4DxcZJuZLAnh2DC5HyHJfefpv7CIP5ewffnw1xYUi2bUai00eI8/WhgaMF?=
 =?us-ascii?Q?rkmzm4h6mp8pZtfDNOEvImMHA9AaoA0qjjmLB3dmX+eH2Wk61Rh1HFykkZEk?=
 =?us-ascii?Q?aeLAhqIOZx9aXMZjW5TzyZc02W9HkMONrhiiv3udKfZyjwH9wxw5jp5C1Zno?=
 =?us-ascii?Q?XwJYNkqmdn90gZGWEbvRu2i5SXq9Lba44MKNZkdIOolgtqPG1dWqLQdAJrj1?=
 =?us-ascii?Q?/EsxvObogQJ4gXLGmDE+atHq1Zo37Zp2SqOiVoURWrloLbtYkP5FpiKrS6wo?=
 =?us-ascii?Q?MBBHeQR1tZWm9s+p+4T192kYj52OAXUVJR9U4jNBrA5cSDTsea7U3hR0BN5n?=
 =?us-ascii?Q?H/ctgWCrXya260r5joDIBaOs8ul2S/mVfZDiYsg1x/Yn1l+x16n6LvmZv31K?=
 =?us-ascii?Q?8s1Kld8n6fMO9m+veIpv2dZgo+e+JzcYsIcNtAoJmWt6QzWX1RqbNALIMiDQ?=
 =?us-ascii?Q?lVGgcgLqhNexYHhVIncNfGPVfTtSAzEdDYEqhYXwEww/JTCTMOB44yZIBtVc?=
 =?us-ascii?Q?oR/fmaF4ep4JOMlJLI5Lgu8ilvPYp+E6NFYXmNT48+1NsGssPso9Ve9jgHZ0?=
 =?us-ascii?Q?iJtsBYzb9IoFI4fyPHhTIO0oQFMQpip5xPYxl4CWDtBNCD8v/sJcgMeG/xzx?=
 =?us-ascii?Q?zBQiI3hTYem8eSsYtulgjJjsEfrlGtk7QQ6xjoZrTI8bOv66kcIFB+nPB9Cb?=
 =?us-ascii?Q?s6yrQ+qXGVNXljWmApTiXLSUidhFHo9HmXjdSSdH0EOTRppIMSV7GcPnJ8Q6?=
 =?us-ascii?Q?MxlnSNZuRj5fow0G67bc9QeRdDU8vdgL1MB7mZqjaddrGqQukvDRclcmnuEE?=
 =?us-ascii?Q?ztnVIPdXYVv4bMrU1HtIgiFh0xEFhgFztK8vw8ENB3XLk00NTmKRcDNd/ogq?=
 =?us-ascii?Q?RQIAmJmFWRtbpED5ixRHh+2kijbxCDaODN+UaMKZR/CtokgtYEcBWCyf1e7U?=
 =?us-ascii?Q?tHFdc+YTVBumacJbMCOcdDZrjEO9iOUHOiqPTW+eOJf3+Tm/OkgmmcCKC0rb?=
 =?us-ascii?Q?VVLJAZD+01aUfLNz7B+FF8DfSRqCO+jnNumU644UufYswi92Y4FwfrbDUMA7?=
 =?us-ascii?Q?m9R4uWVwmovVhNCfmmyAjxr9qllLnCQ=3D?=
X-Exchange-RoutingPolicyChecked:
	a4fLYH/OiPygfNMylXN5Xxy7NvkV0efR4x1iWS/HzW8qOAm+31fc8KlgFZLl+EjuqPBHGCfjQ9JiLLrWpZ7C4IzTpbT92eAay/KwmzauRSu/spPXi3KTiZzkQ0F+b+WEG7Z2YsA/5y+y1VpLZHg+NhyekCpPFTj7LlSJePkk7Mg3Pod4Gsu+KmvPw632BPRZeNuHdI4kcFykcgigRF2WkuC5+pLcDbr0CHpUxaFapy59fHaFF/E6KEjKGwXTQcJHE/naSnDLcbAQI1aXWpMQ1u3lHxiy7T6HdEZnDG5GvwWuS/F8xHv3yTdUUOuuyABgY0NjCrROaSqtGpH23zAQRw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sFc8rZBuYdn7A1K+9M80Pk/rQRPwKa5PTvmZXDWu9Dmd3EX/C3GH+CJkcBYwKP1FI4trNlAw8onvxIPUGvA6Yu/Yq2JNUkUAsflPPvNEpWgtODudt4ENenTeZA5+IqotKWUhi1SqIQKRgNj2FJZNO70CIV0XI2jQeKmlNFFofiOs8tz/awr/pY6CA77k+45CRXMKmr5r99gFupyCgRSgGlyEY9kiyvqIXcojyDBKE/jXbtypS+8B4JQLdKCBtkIcvmGZ5PoSSNyiD85AFWregn1QyTscByKProEdkyEYz2QBub8jcUI8vNbHwomepbZ6M3kUftnhieedTm0VCM0+UrS+UCkvUq88NVoBHdSiX0TOw1zqiZnEYLZtLXnhVNWe63iUJQFWyLy4YZqQDilubAyUX0GRDZEsWtrCs63WUIBadrXOj3CBzoUGGWhiJXHs1sasQ6QP4xciVFeHIZIkbAannN3UPXrBcBVEyV60OrZ2ykfOxuaGYStmkiVnrJdzK0lDJblwNJePw/hIfHI/jGQV2YnAHcrPHglR1D66+XpMB8tPZvdbs6wxJU7Sims9bJSPBFVEPWRoP5nV36DaCkHtxL5p88PKcIT8FjvVWAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3a0b78-109c-4ead-7d0e-08dee89e0006
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:23.7618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjpL5b5bCK68Btx5VKJWwnxy0zfan6FLV0K7gTmH0xI+OJoldYdhJUXqshcsP1LQDPs2WV2YMlv2jZbp4Sedew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-ORIG-GUID: sjjKGlHHhD5taZYwt8weFNpkxrQaN4U6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX+Il267G0/vml
 m0ocYLma5ET//Shyj+Z0ud1m9lC4fchvcZzPp4RhrYEWpx3u1ke949bGsqbOVH1wpmzMIn64P3I
 UFz6hiIfCYCeMCAjFUVzYIp/JI//5LqvieuBHK2NdDD0o0Kh/UHrnD+rgisZjORqQRmopMmUqaP
 h/1jh563R5da3WpHGm8L0rPCw6ebPk3OxdpO9V7r5g6lfoWHw1zyM5ySXPxmVurm49P8W6qfZUR
 QuyO2xiw45g4hTprfCaimVrEM3KsbCPqWJE/AatlH8UG/xWLd+3UmWB5T6tQGov4gTUGKbZXc2q
 W4Q/1drlvNTCyRntU9AmN30DPF4MxA5eWYXGY4Am5JyxjtAL6FImPcFLCUcILFK0xMJPHjzGRhn
 t9e72wzSV4sRurch7nLThS3QQ+5+StiqZgXnB9JA5fuka8gmxL/+xQpvMXBVClzI64jON3wpeXq
 xWIdHxz7mjaySP9nnhw==
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61e0d8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=ecQ7zCoEdOpy3JLqRw8A:9
X-Proofpoint-GUID: sjjKGlHHhD5taZYwt8weFNpkxrQaN4U6
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX2SxN9HfR7p83
 u9cYPzmB7Wjs/fmu8KB9EPK/8HZRGptB7jDJirm2QNlKz7EPhn7AKlkKiXRcWIawr9SHBGurH/6
 QYMx99oxe6hskNULDEWoA6Mbw0jcyiwVc+m1ODzspdiWrVcT57qt

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..242a15bc2c5bb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4453,11 +4487,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4468,6 +4506,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4493,6 +4533,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..304b24644d942 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+	#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+	#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.7

