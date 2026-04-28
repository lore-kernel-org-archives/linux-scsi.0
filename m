Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78053F7885;
	Tue, 28 Apr 2026 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374710; cv=fail; b=MOj6pcHo342fmvAa8oWbE/RuJp19D1UA+XjbFzyDUJrJ3pEhb7G5aXrS2BeSUQjeZoUDOLANQ2pzmDf2RSONziXJXy8fk/y6ejg/ckk4O0kTygC8rl+DpAwl7DzHBms/RpmI3yMQl7DLPS7n7ivAFw9t5EtpEtES69Kw8wNvBmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374710; c=relaxed/simple;
	bh=SVycnrhyMs0jlsPUshaZfW3tJGZLSiubs/P5NLvcEQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rRIP2UMGLVnkp0RP7soAziwu3J709D6vqiyigjpuVbwY2tOADfFwROETKA9HDzDViM21ZwlsdEAbwcoZwxGjntGvevMhRXsTs7CX8leiq7IXo50BRzkLayY4dWhFQ+tXkUmXJpOxQsTqlux+I4RAxD2U3H775Uu47liu4ZqbNLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZN/89onQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pORhorc3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZN/89onQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pORhorc3"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAQvRg1905274;
	Tue, 28 Apr 2026 11:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TLDHcnlGX2iGN/9FnmGvv+PrPiiBYykQiMR0bm81Ge8=; b=
	ZN/89onQeWOBLpQ/Wg+HrvCyQXsKTFW+LMXbR6DyzduK8y2lAPbQSCqOzzkIb4kS
	ftgAOvfGE+3JqBKRS9Qxe89QwnGujluuTc0LVjjuxgJkhuGsHFB9Z0C2USiicAtd
	VsllwNRwdx0CwXN0D6+C7TrsH2/c6Oxwn/0gxx4fP5FUvXyuUrsicDGY6ULnsCUT
	TdGiCzW4z0AmBXp6gTgPU2igm2eNTyxC9yfZt1yKr7ktPp/7yNDGrGShRQ4chUrY
	DTctRkoCGWo7/YW8r2HPLbYrSmNh++ZQ29kmbXIGwEKQA44hj3uhhOG72bT7MHKk
	bqaiHOicUnVEv/uBkAN6Dg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8fcna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2jhV036886;
	Tue, 28 Apr 2026 11:11:24 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvem5-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lv65OcYf1Nxiv+Sn+vi42elAiXqSUXaEvq1xNtgco6NPmDsDl14GbFvv6nbJrItKRotCAXuayYg3ksjIhCRXWT95zMo6aUKxwBzTSYYQtFzvp1lhFVIpZbzITPahsFLQp89/m2BVCa59WB80sIFl5qJ1KpzZLAdo5MRhb9V9bi1OP1cZkjVg9m5dIkfkkvTBqcJyNWFtlkiRnQCWNZ22ecAQJrJ7+Kz8sYtgqxLTaBtyW+Hjoq0n2seOPfk+P5M2gEu//6EqDeGK3qfOeXwcHabUvQ+lFJFJQNTdjuyru0i/X1RHcTVzTJjc2EonGUcr9pkRanOoHUsRQnW3CAKRBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLDHcnlGX2iGN/9FnmGvv+PrPiiBYykQiMR0bm81Ge8=;
 b=HvCIH5Iy3t8ayC7pnUAzTbT2W0P02fvAP9dw4oC/pJX+YlPXHB3UKfJLla0T3xdHw5Z7botT6jPEINjjh4aEe1QMvtE1dMxAPkAFw6IkZdCEdbASAtCzkdpnAQ/A7xyWBPeOvpwzTcCDEz0xXouwBojYdIe1jnnNcbwlAV4ynThfdCEoKUhmJbLtWLKlDalt7ftHFrC1osnarjwkNvf+0gQ3xxj2viqYuTJimkwLUYYduSPB+PBIsrfcIvAlmbkkJJimsbtTn+Pbzyw9uARwAfbw8uJJGaU4QOx7/UU8w7HLQjOfSjSHlmoSTGDAzj4IAHqnNkj7qSCpO1RORE1YEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLDHcnlGX2iGN/9FnmGvv+PrPiiBYykQiMR0bm81Ge8=;
 b=pORhorc3pxbxIJ1q2ytfLVmU2uPfyIR1dts7wPd15EZISIvdkndRjguNLCTqbcLUQaAC3END3rBRve506B9KjZNtu24GxuBHmmYdxgfCYww6M/eCDPzTgtBMlzZn122EILsZTWyV32j7dmd0J4XMNObi1nibqg4+pyuPAw857X4=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:20 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:20 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 02/13] libmultipath: Add basic gendisk support
Date: Tue, 28 Apr 2026 11:10:54 +0000
Message-ID: <20260428111105.1778008-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::7) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 354fbb62-65f0-485c-ecc4-08dea516e02b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4Nd/wLavMK5el6G9B9pgZEV7GubFDuJMBj7/wihYtEJ82225Jxly5jOkc877rWnl1lMjgKGf8KsZKCdUVeXpKoyBGFE0mGs7mvUK8u+TDJk5XsXFwCZF+Og8EccmUU1T3MsK8gP/z3t8EnBDy75UKe3Qr4+7Y3B6IMaulPV7/+InxufpwXaTU3J+qImRho6cGJbESz+r6enl6c5uDHJcQmlJ2g/0m7JykrJIwR2prOW1WlOJpNaJmzKdGnOEYLHJbAYegWyDU7RSTMyKd4L75bkSoYsQA3yQYxDm1wmj6ziyfdF8rFaXNi8npQD1Wu1dLtKWGDRskXdMORhuvIJjb0y4ZF5n+Z7QAzghumxSmdbGQH9Oj3pxw42lQYibp25/g4b63x+5tzxw2ctHunMPS/qWwVbYH6c+GG2s/NgOPeC/qKrpwtpaJLDhXTd/pEZsbze3gXZ5TArELauBkw+Y65pWRtMh38dXIQ9HcWjNRLKQZ+d1tsthgLDEAAdMGKv6uivHjCBy8HCgKsRWzsAvgxAr/8qQrsRTpJfIEqV1WGJSr0WTXzlBM5Jc4Wxq84kQC82wk8/HaWtp81NYoKQFNZM9m0K+GPJbls0apLQoSm38P6N24uNEMRtCvJr2EJi5ye4BJ7TX8V3h9GQQZtjA1gkcalE//N8WtFUWbbLCEK3H5QEEVBxRakznDrJXns8lxquKZijau220vrahVgx/H4tQvIG5hEn/Xgpxx682wPg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7LFGGH3IG1c74TODg2UW5sIvTLKLK09r9eWmnaAyr+0e04ql4gJ4/HH7Ylwg?=
 =?us-ascii?Q?vOi/nv0Ox8V3HtsHJUIsntcdsN8pNNLlWSg9ut6eo7zBlF2ELsPHSkUJr4XF?=
 =?us-ascii?Q?xjbBExuH7PwhkRAm8C0dSryGF+LOAPnBOC5/9TP/rPLfKO+JNumqYZQ3vXkm?=
 =?us-ascii?Q?7wg9YayBb+2P+FwzfUBtVPjkz7vYjpzZZ+CPORnj1e5rWBBM3Bb25N1S5+ew?=
 =?us-ascii?Q?zUcmHUpNNvF01JzXgQsWX/IZq+usN0mEnSjgl/gPT/YrWOKA5SN1i8cXq1be?=
 =?us-ascii?Q?YAwK1+FjnFrdCHiKKtbSKV08Lx5LxDKexTm5rawkWBz32Y+gyC2Y74Q1I5Yh?=
 =?us-ascii?Q?Zmk8cldQXVKe272DWhNaz9HCpCowtdREHazvPB7wpYgLCQHAMHQRVp4z0aoV?=
 =?us-ascii?Q?mSxpLbQHxgBQr4YnUKZ5BzKfkpOjCkXsz9oFfpuRoSgprRPLAnMcZl7q8BiJ?=
 =?us-ascii?Q?ToL29iSOr0eQjLNvugMHjT6B2Gp5D0guGiSwKlot3xZSYc/ElR/1zU+wFmNg?=
 =?us-ascii?Q?L9O6kdCVMGeNCS7XIb8s/GOGHbE0L/HI45eUBuWPke/7682qc/CTj1l+pj+0?=
 =?us-ascii?Q?naygsVNZsBFey9dt6PyGMbXbhWEjCF9yAi6LTDv6MbMb/3D51x3Cv5WHczay?=
 =?us-ascii?Q?Nbfii4AMEZrRI4uS4cJSmnozk51NFkJx3+5eyVr7yoznnLVu2cFbeA1ELOt/?=
 =?us-ascii?Q?s8bCAFQ79onoezjqY8wymFzhcM3Jnfcx3CvFLYg3vE7IKvuukvg3IQvCIRMB?=
 =?us-ascii?Q?b5TW74zC11EZSyo2z3P+vSInAQYOwciNXYove0DfJWUjTZWHpXRacMrIZ7vn?=
 =?us-ascii?Q?mgY7zctn2tWg111zt3gXz+mM92gLZ9urohw69vFs5hBDZVGJ1qVdOly/0KDo?=
 =?us-ascii?Q?yyKixS41ZTdcyOemrRJHnsWCReOOTU/wUd7xXLvdgnKU+u0N2bxSpAf/hXuW?=
 =?us-ascii?Q?ZtycGi83dcfEZx7PJycrtHnp03wiMpdxfkkNABhd3NlhEi79Y3vWM9uD4MEV?=
 =?us-ascii?Q?sL5wm1llD77eaO9Hq+Mo3KOClYlLibdXUoNYbjbld61EcnZ8va/XAxANhVHb?=
 =?us-ascii?Q?dMnD27Q1NSWAMGsI2QoaxHSZZy7iWuT2a44VQpLB99zana2fE5vuEjCHWgk5?=
 =?us-ascii?Q?l8Lkg9FX8uGguV1PCwBdCn3+IcrXVIF5LkMGrS2qqQfLTUuGEP3USNLScSxE?=
 =?us-ascii?Q?n9Vo3eDyGpscLwvJkcVpqRXinF+lyARbTMt7oDE5yDNJFpRb0Im/Sv+QJR5z?=
 =?us-ascii?Q?Xq/GVo3wRh6xw5LgOWzacATDheB7zVq+fOCljbjzeVkQ3udo+CMRmBA1DYER?=
 =?us-ascii?Q?wN4QC4ZySVhTYLNcegWf5s3aEa9hiHot9cHXcA7BsFAHI2jVlG5ZgrJQP3+i?=
 =?us-ascii?Q?4mmjuT3bXBWPvsMHv3260xy6wSQylDURA3W0I2NOhLEICBeukDtPM7Xx2KT+?=
 =?us-ascii?Q?C5uHVMxaIejN/ggse0c/b4mSmsCNpn8oook0N699GbjBOGcCIEXfX9Fuq9nk?=
 =?us-ascii?Q?4juUevLtPZ5N/LGfJmR82uR1KUJ+8E+qeEBXJsXSsZ8x76xFaaQnPLOjj8Xt?=
 =?us-ascii?Q?WKFS750qhDPhUP1dBczjDFoIayTDOM7H5XYRTBzxLRlC9qP0ob+TPiE5JcEk?=
 =?us-ascii?Q?qSQlZdfwJpq8S0C7WDsgmr6A+NHP3/2LiocjyYYB96BXf69n3BqSMVCpVTL7?=
 =?us-ascii?Q?OC2ZS4PIk9emIMM8pXbU5lFEEWsrCbPvP+3jGENT4hGeKJpkna/21Ja5Eeis?=
 =?us-ascii?Q?n/GhtBbLvpDMGlhPHc/py+ZEO+aZiKw=3D?=
X-Exchange-RoutingPolicyChecked:
	L3CTI+pcFCNhoDhifyKaU+vb7krCtnFmsEBgZyFiLHQAnChPzS6k2LaAQuUlkMQ4TLpPBwj55Lb9V8QV71wYAqNLCdAMGn6x7X8Ec+2BfdiSUNlsFak2RwB/2gm/hlReS3mue99ViYJNezmiX38MCuJw76iUs5SfR/neU6ygQIYM4qMzs8LM1LBYUSJ+gZHBCf5sLQAAzH30m7EjDAg3q3/wMx5bZLGJfjlzxfBVbizGx93UALLTYz7Q5FOhov4hv2HeaI6lDVtspgFuvhh86faXsmtLqetLNPApsG85517QpfOwJ2iGbNNuuBVuB6CBNDdq04jUeqzlU4JkArIuGg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8GuM7C+zOykQpV9YVDPtyyM1HcpGNaajmltJ6Xx0NmwAAl9lwMYCqBqc2miH5DM6+2U2QH4VpW4MGuxO19dUVsPArVaw/yyAnBe08uy7Hjr+Xy+uEBdhk3LJfYdQrLiBuPYzbSBtoxrGeNv2uaHW9bgfpbBloMtNOH6HUmktrMUESnt/8cUcO3u+uZb0RagcEXg98tHdwAYL1kimcqKApcdHhiQCeW02mSbth0k+qTKVOcmzuM8/Vu4pHDg3twrtOG/QbcRQJktoVdaxl4opjjQr/fmujD1rA4Rg2mi3a7kRvWfphtx9DMGvVa0oUONCWsFYpYuRtXzTDDKhbr7E5i1r982i0c9IEe0T43JWkDjNSDQ13IeoC5CDjydMrpVhB0Malv7GIAOD4ykwoN09AoHJhyVHUltFaxngFnnS+1bftfUi9jO8JHlAeBTRnectG5drOZUHoEdCmt48bvSZpqmGqDXG3nD6sOu4iNOiARgjFEadzcmeEJM0olkCmJJuBjiy+Bml8ln1KETs2YI86F5VuPvRmM0nOo+OMYTDWrEmkJfFrItgNHkeXsc5z//w+CXIUlWan86xlUTHzkwfNbbswFkUkBmmnpU2RVNXTLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354fbb62-65f0-485c-ecc4-08dea516e02b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:20.5049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enJLU/w+yH1UGGa3siGoaui8LmJCheNiFSK1yKM3LkYMTAbaQ/vC8XPVQK6vHhPQKf2Ur/pb5SzvtkNb/xxQOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69f095dd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=B52eoxIPv8yZRAGToxQA:9 cc=ntf
 awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX3Zd/gKMfgG6c
 ahv/J8jn5bvTnhTKDjVe/mtw1WnS1nuze0eBeGNHNugpG1JJt3vF0CxRVquKHcZyYLc643c9d9i
 Tsa+3AmX7h+Vf2xX/83WO/xNtGjZEZ8F618niQ56pznxh7OvxsAS1FPkZUb6nE8Rj+jsqDIFt5S
 qBKSvYeJ3wLFxKKc/v9yDIA3/oluD7i7vgzV18sRzvHSZWWvvVZIw1ZHnE3M48WctL/e2PO3LPz
 6GUDNhFI+tHb9Md2hpY6NX8VSez0cnzs3t0fBz0JnKvvoLffqqz7v9hqX26rY5cou2PQdHQDwkr
 ae5LJpRDuBX05T23gOPlioIAlqy1UB8EZbnnlcHyP0xbqvbJcPZxi/PfmoPUH2/8HdILzx66aej
 V9JLaTOfEAzrFqhcMmUovi4oTFZq5e3479LVlzBSDzubUul9USbKxbXaWOh9veRU0ttJYbxh8HN
 E8WAONFPG5MmWWXqEaJJzmQaB4zGoqYR9/ltyc4o=
X-Proofpoint-GUID: 56FGO4HzAz7G1_93MumkCaT8OppdiUqF
X-Proofpoint-ORIG-GUID: 56FGO4HzAz7G1_93MumkCaT8OppdiUqF

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 38 ++++++++++++++++
 lib/multipath.c           | 96 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 102dfcf21ffc9..3e2a513059cde 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,19 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
 struct mpath_device {
+	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -18,11 +26,41 @@ struct mpath_head {
 	struct kref		ref;
 
 	void			*drvdata;
+	unsigned long		flags;
+	struct gendisk		*disk;
+	struct work_struct	partition_scan_work;
+	struct device		*parent;
+	const struct attribute_group 		**disk_groups;
+	const struct mpath_head_template	*mpdt;
 	struct mpath_device __rcu		*current_path[];
 };
 
+static inline struct mpath_head *mpath_bd_device_to_head(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_head *mpath_gendisk_to_head(struct gendisk *disk)
+{
+	return mpath_bd_device_to_head(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 struct mpath_head *mpath_alloc_head(void);
 
+void mpath_put_disk(struct mpath_head *mpath_head);
+void mpath_remove_disk(struct mpath_head *mpath_head);
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node);
+void mpath_device_set_live(struct mpath_device *mpath_device);
+
+static inline bool is_mpath_disk(struct gendisk *disk)
+{
+	#if IS_ENABLED(CONFIG_LIBMULTIPATH)
+	return disk->fops == &mpath_ops;
+	#else
+	return false;
+	#endif
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 0d5690b5ba4ca..726d9bec13553 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -31,6 +31,99 @@ void mpath_put_head(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_put_head);
 
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	return mpath_get_head(mpath_head);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_head *mpath_head = disk->private_data;
+
+	mpath_put_head(mpath_head);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_head *mpath_head =
+		container_of(work, struct mpath_head, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_head->disk->state)))
+		return;
+
+	mutex_lock(&mpath_head->disk->open_mutex);
+	bdev_disk_changed(mpath_head->disk, false);
+	mutex_unlock(&mpath_head->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_head *mpath_head)
+{
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_head->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_put_disk(struct mpath_head *mpath_head)
+{
+	if (!mpath_head->disk)
+		return;
+
+	/* make sure all pending bios are cleaned up */
+	flush_work(&mpath_head->partition_scan_work);
+	put_disk(mpath_head->disk);
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+int mpath_alloc_head_disk(struct mpath_head *mpath_head,
+			struct queue_limits *lim, int numa_node)
+{
+	mpath_head->disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(mpath_head->disk))
+		return PTR_ERR(mpath_head->disk);
+
+	mpath_head->disk->private_data = mpath_head;
+	mpath_head->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int ret;
+
+	if (!mpath_head->disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_head->disk), mpath_head);
+		ret = device_add_disk(mpath_head->parent, mpath_head->disk,
+				mpath_head->disk_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_head->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 struct mpath_head *mpath_alloc_head(void)
 {
 	struct mpath_head *mpath_head;
@@ -44,6 +137,9 @@ struct mpath_head *mpath_alloc_head(void)
 	mutex_init(&mpath_head->lock);
 	kref_init(&mpath_head->ref);
 
+	INIT_WORK(&mpath_head->partition_scan_work,
+		multipath_partition_scan_work);
+
 	ret = init_srcu_struct(&mpath_head->srcu);
 	if (ret) {
 		kfree(mpath_head);
-- 
2.43.5

