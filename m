Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585508BE8;
	Wed, 19 Feb 2025 02:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739932484; cv=fail; b=fz02Ddvrssgy/xNMUBEqtHMqT/R2CHyf0vE/tyrCEeUSS8w7Cau23ixlUOMM1vJ69BdJMRPkdjiF4tPi/H+xQ/BtmVWeuP0djG4Ivb957rT0v87iKVXgdqprwU0D1Zh6K81+Z7eYchwNds1s2s5OEx1rkikXhmAoH61TwApBEFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739932484; c=relaxed/simple;
	bh=TB6ztd5hLCxkVVNK/GCKsXtY92HsmjkF/2Ubx3rMZVo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZGyxLjnrm5a7767CvzJxx5cH7fNPjg6+ZNfUWuDdik/6QbEddtVdlTN13nIeUaUlNsjxjMxBCiKTALsNWURUpjGTo0nqcg58Nj5JwjKcjcECjBeH92qAiDXVJOLnXbwkNhm4tWDNfx4YcUaU9qhJ4Ixl4JsHVhiXr0NOUKqS+F0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mYZVcf6X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LLynOhzA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mYZVcf6X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LLynOhzA"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51J1uP4H001191;
	Wed, 19 Feb 2025 02:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=X/e7+Qiq8ph3YDHe6y
	GUVGfs6tkuruE3yCI6tFxbzxU=; b=mYZVcf6XERyzqCzrTdoal0MwFa+jaiv3D1
	jKOJF824WY2TCVl0sFANCW+pwj3NlE8CN41gUSYAuS2fb3XFie/4kBOeHg+mRSzE
	RVbOSAkQ+5fnU27cv4Wu2l5WiT0mVHLwhpcYcZZEOw6/zbOKS9AxtD9BzhXkuA0S
	L/zLCu6yyzwhNZk2EaOQ1ON/KM2QLl0tZ4gDjiNN4p79zl0dEcdLIrJnFHpE/X7C
	VCdA3XfSsNEuu/xqoTDYI4nycV7B0sW2ZCIEa9+mdlcesy3morpGKmY0c7+PN6CP
	zeutYm7XUtpd17CcAYPtUt7NXKYmAUkMH8Yykkg7ARodr+OheDWA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n0njx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 02:34:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J09Vmo026364;
	Wed, 19 Feb 2025 02:34:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0snbnr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 02:34:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJYpIgsBl9dnuSWKIdCx8Iah1PX8Mx9JssbO05lk4OjwzOAq9/gxEmXy+xCGFApu5y+z6xvJZPyLVYQrnK+I0N78G2U/Q7I+2DItPMPxRH1FewhtyTXtYYHRzmpnhJmiz2CDk9xOF15az74wcQZUGNOvqqgqLcUdOvQwoOwMTHhs7JIozK9VjgwCJa6tfkrTH7PcBnT/t0SLxsyef7SdySlcPyxWe148y+O9PftrQwl5QmMCVi2Ia2qkrIQUIS0gBuOHuDd6jDSeiyH/plEK+QKn20D9r2QKT0URUVVpNG8xbQnRo6GSyGBB7ypqb1K5AOchr3QwyFQ9l4BqdCVQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/e7+Qiq8ph3YDHe6yGUVGfs6tkuruE3yCI6tFxbzxU=;
 b=w4KXVh8nAVkl+4+nwHrKHVNqspcmt2AmziTdopqdgnmJi/U5PdV1+JTMKvagoPVfOMNG9Qc5z+Gl9knX6J3WL+uu1X5jMRCsLJPFOKKderrb3LZhknyFoikxiQaaMgFuHBlkabazXdFwwt38CswYsTEfx6aXyOG6tiL/Q00u3cP4+MrKoNoEO//ekauNh3Uy4H8MpdhTCE3efWXEeaaz7Q+vBlsz45a4Cf5c1+3GpNAfNvY06uXCb41OSw2wQ/PkNyLsuiU1NCdjbQlBk1rlxYriZ7NdZOqtmanCcljlQ+i6/ecGg05V+17sueCuatGaJrV+iuNHESrGadZT/K/tWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/e7+Qiq8ph3YDHe6yGUVGfs6tkuruE3yCI6tFxbzxU=;
 b=LLynOhzAjhb+PPCX8LHACJzCZMsHPPLMxePYLqxahCgm7ri3KbZEnRNT5BO9N/0aMwl1NCWyJuq0jV6yWqBDtsii1nRdjyAGcXhrguSqKwdH+3SHBkXPCcN5GyiPc25l/XaDryUxU9tpGGHoJrheYEq5JZ0L/WHV2md2ACW6j00=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6598.namprd10.prod.outlook.com (2603:10b6:510:225::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 02:34:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 02:34:28 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy_pad()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250213114047.2366-2-thorsten.blum@linux.dev> (Thorsten Blum's
	message of "Thu, 13 Feb 2025 12:40:48 +0100")
Organization: Oracle Corporation
Message-ID: <yq1y0y2mzmd.fsf@ca-mkp.ca.oracle.com>
References: <20250213114047.2366-2-thorsten.blum@linux.dev>
Date: Tue, 18 Feb 2025 21:34:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:408:fe::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e8a84b-0c82-4f0a-71f0-08dd508deec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c7OkpwjJ6rZdcR2BPCu/Z5yc57JIuc1FQ32Wwn4nSdOQtKQsYc8W7P5l7p0j?=
 =?us-ascii?Q?4LgE1inXZMcFWj1DfYJAsiaW0v3hydzFbc3sJKMoN16zbH8RK5f+4aaE0K/v?=
 =?us-ascii?Q?rinX5tuYtuCYpPHOC1fqLpu9k+GR4UfOtEWnjTllFVK6ntNjsTJuRFHWaLvZ?=
 =?us-ascii?Q?hTpIqQwMXZxeh5/2HvQ8pt6OULsJfdT2/QFwr+SaMO7KSkSWZFYXDyNwqXU4?=
 =?us-ascii?Q?FtI/Ul7EXF7JbZzgsJlKZFgalNNBVNMM+WLXlxSUyuMopL4JBhDaEanVX2i2?=
 =?us-ascii?Q?HGnciTRfe9aMxmr8i1eHEI/bbHPj6FH+rjEZ8LUbhs3ecdjqRHSlDYd+vQbA?=
 =?us-ascii?Q?EyvUa9/wmRIfkNuZ4/Yvo7fJvXqDITQV6iD/xNKjO65WqeocdJICgmqS1fug?=
 =?us-ascii?Q?0LA8wSjceHPeLCxMrUKqEbbQMDFTKgz1EpViuUq3KFS03CqRMAvxjV8gXYA1?=
 =?us-ascii?Q?soxmysw6NAb2XImWk3qhOeXuUe6znqjvqf0x+Y1w9Y4//l9lIFxtriSld4Bh?=
 =?us-ascii?Q?6axtXB1N0DJTatmJ+SvPCizIP2gWtfhpyUjIYsd9cbfPs2qvL/zPTC1jq3c9?=
 =?us-ascii?Q?FTDuLCtc37LZrLmPygkmu57gxcpNliXD1SYMJdhr3cgBD/ZDljMSxp+ZPn4a?=
 =?us-ascii?Q?dC4uvXbI7+sJAPhTN7v2R08M7X60SDENLRvpCM/5hphFNFz+v5WvwZVlzDey?=
 =?us-ascii?Q?KslFxXlsUbS6R5p3Vdr1EzsKsBnDfPtawrsmo7vHMwDvD8ep3pT/ewWD/FVt?=
 =?us-ascii?Q?RHIafrCWM8xKXnjr5Y6CG0QL4+nM5csP4tZ7B4MPqk0GDvwnax5MkGSgHJ7k?=
 =?us-ascii?Q?+WfLDTzMLcjFZ1BFtPO5OUNpANU8Qu+/b+AGmTx7vbjgoSoPl5/W0HrzDEvY?=
 =?us-ascii?Q?BSTvfMn1efK5Ta7u8jEEMYl2ISS8JhbsF1NZas8HjJvUm6xsmHTf/oJqVK5Q?=
 =?us-ascii?Q?1N+cbMUEMuk7hQJqyJCGqCH5KhqV6y/hOvdDboCGO9AzSJ/LvjGnthuMi9J9?=
 =?us-ascii?Q?eQ4dMHr/SvoBTU6Oxah/KR8UncjF0TntisCOGDHQq8t2vPTJUEBpHmXUpXwj?=
 =?us-ascii?Q?3EhvcxtTgogeRHnWw8o9/5vGWDK62Hw2jZaTydu3vpqFqqGImCTBxoIN8szD?=
 =?us-ascii?Q?tzZSFqqouRuznYplQP9QXJTsx/tR6uSi1lzZ/q/UPq7ePP1jIjJeruXmySRP?=
 =?us-ascii?Q?AFu3faRAd/gyd59BDVMtCigWIJVLDASLKSckk6cxoyM1QqGbUW2J/jFC64kV?=
 =?us-ascii?Q?QWFZ1Ebgvc4C/7HVru+4Fh0SOVD1DTf+fr7AVK52ySMsOPQgILXUOyIPt8dL?=
 =?us-ascii?Q?e90YULnPNQMhbNZC5SZ9C5QC3ZGZGDGIFV1mh4WBJusR/pOXx9YRi30tKK+H?=
 =?us-ascii?Q?dEFWMjZvO+XnZskfssiV7JeijzKM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kil+tC1+YMYIBmw/tZwoQmXfVSF/VDeekojarT2h3FGG8zmrM2XV8cQ9LuNg?=
 =?us-ascii?Q?EpDKqe7PkTIcSKhGMHjmrTWrKmy160vY6uCKTkrIkj/poWofw2EQHAMmFQZN?=
 =?us-ascii?Q?htxUm74piLWoaN3IWnG9mznXpalvQuGsnw89V48ocMFUPA7eKwIZ8xqfLlgp?=
 =?us-ascii?Q?VfR2Q3AcgHq7qYWFNhTF2jQd9QkwDzE6hrywvWUnIWxwrY5mDS4+03IbURBL?=
 =?us-ascii?Q?93DO4ta+9PS9ilvtSc/b1B4G/Erv8KczXPvEyGR6Lc6m1IVzu+HeLIT+323V?=
 =?us-ascii?Q?Z/gnKbm84QT1wSN2OPhBaC24qJsps+YtKBE91kbVGxNkQFVAXmXoLCdlonIo?=
 =?us-ascii?Q?9DNqEFvW3xfInOqI2ilBo8QjtP+VyyWiPdqZCHHZAh2FXEE/9oISpyw/eiWd?=
 =?us-ascii?Q?De7Qyf1Ohmzy+1gxx2ZnUuPqeTBNyPLBpHXX6gIgRx2yQl5naHy+vRsvZV+D?=
 =?us-ascii?Q?MwC+VBBXCNXHVpPoJRQD381KFrRQSDX7PHPmZcqqjvyR2urHlRpo0BVpL07N?=
 =?us-ascii?Q?7v1P22QxQykMAzRfFPuEssYUzRe7rFYMcOw5eWm2M0kVUCc+a9Pcytfl9q0F?=
 =?us-ascii?Q?9zYSJUNb6LKsC5wGGUbKE6uTJEcGsKjpVYwZ0LFFCC2GPYBW5S17xoPuty/r?=
 =?us-ascii?Q?C596Ja2QOfu+UZbVy5+OUf1+xtu6GocYjLGL9Ni1f0c+16HVZGWv05Q4PDN7?=
 =?us-ascii?Q?s11ZZZH1NBfvBextJgPg22tU2NwLCM7oLeN9/NXSXIsIdy8kAVQcRe0EZdpu?=
 =?us-ascii?Q?hPmGQcK7iKYmVX3Lm0LoA2DBFjkXgGSe2hmwsp28IUrKLARdkLg0EWctDTs4?=
 =?us-ascii?Q?qhtcLo8+D1YJ/56huWNCuzfmLGC3dl09xIXVDeoc18CNWGzmXOEl5wZwYL30?=
 =?us-ascii?Q?zaM1A8zQk6D3R1XHfUfgMGGsaHPmq8wNJUR9XYU9dnksA6eAsLI/VSrBXI55?=
 =?us-ascii?Q?3rxQpNxOWKTtbZbf0LdJykc3JxmPofigm44X92naE1MFIRkvMXlVzClZRiEW?=
 =?us-ascii?Q?yqOe3OhHL6MfJFmIZufmYA0h3SnV3Pos9gf0grL82lWmvo3ig92T3OE/S4dP?=
 =?us-ascii?Q?t5HCRKSi62z7PK0/AEn+285Gy/Jq1gl6IuO0NLd0Xo0Zv6UZB/JiBgLDo9WL?=
 =?us-ascii?Q?2H6sWiRIMFhLaT+TxbCH3RBtTsYqHZ6o4FAejKo/vmUVh/+IthY048T/K022?=
 =?us-ascii?Q?zWAGC4ynPibRy+Tfg4PwrOyYkXPJ3C229ZzvT3gA6FM1rQgKVulwLN6A3sgj?=
 =?us-ascii?Q?noBUJNnFU5xhIAecseZweULXq8PVqXPZTk/8UvT8Q28LaqwZPEzJd3DlTDo1?=
 =?us-ascii?Q?X8orL7WyDWgbVUcb8PxKj1UtVrs0lYfQIWs8rmVj56raDjxs6If5KVon3eDI?=
 =?us-ascii?Q?766wXukDrglSjFljD3SNB3xaIuhNNIw4RWfPaJD/BJMCWK5zuP/Fu5a7FaAL?=
 =?us-ascii?Q?L5FwekpdHX+e/s19UG78MhCzco7DbY2tchh+E2IOCNLvDKe4AlUBBrBkFT+5?=
 =?us-ascii?Q?/mGhuVVocEqc++x/pVW5nSec9H+OaFCTcfnOiRgFUlmGx5Tuk4ij8uCZv/8a?=
 =?us-ascii?Q?JtunjGtACdCDLVM0XRo08W3CctAeWprvV5bW4X8x35I4QNhXu7DvsgIBDnyx?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mt4bpesueWhqtfCfHZKXC6c7ijh65ZXVr569RguUhISVKQm9nNLlrd9H7n3PnA5UpQg2ncrC4KXI4f3hUoqQVHzUO4pxPQbyVseznz7Q/GVVUaQHkbJu3c+o1JlDIJiiSZCHW9YA7Bk7wzQbe4x3QCenEyV+npka948MJOJH2GRKqaQmAT1jInhPE9L9T5+/r3gQ+iEMfEFoTYIlNarUSGYdWLw3pMPOaebZrNjqVUqihD0Nz94p0wtEPo/m7wfO7nK0YjTJGNSaW+sUyT9t88BSmWGJL18niRPoMMl4co+wj+OYj7dVZZ1QlPzFsIEJfTq6XBUOoG3+gnEbFTif6GMicKo0d5G0vHvnxLHm1WW+H8SBuy5ImGg4roJjfZUD2jcPTbw49rbX4kT+LYSXwGAQPGMSEAY2TvGbuxbthXHiPggJF1xjasWNCGDH0cYanr7fULrkMsBUl4eKFinUuP7hz7iC7J5gx2+0pyG8iEVB/gWTwLXctaK19JThvrfu2iicTUt/umllKwmCz5I0nn0F1KbD31QCUymTjkzDOy4ZcU+UhVDRsLN1n4mdGk1MRMIEJirJc7u24+KYDPAHPSUcs7gdObjc3up7vurVito=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e8a84b-0c82-4f0a-71f0-08dd508deec1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 02:34:28.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXyX/poUwWHZwKNx3z0uJNJEH54m6bHAt5ONK/HHaLw6GlaHI9RsCSb343LxsXd7Be6Z/MCcD4U6NYIpVMROLxCQ5nwS2sY2X2iv0wtOAcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_01,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=720 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502190018
X-Proofpoint-ORIG-GUID: zykCRsxb-WSeALBYBq4rYZbKMqF0ulRZ
X-Proofpoint-GUID: zykCRsxb-WSeALBYBq4rYZbKMqF0ulRZ


Thorsten,

> strncpy() is deprecated for NUL-terminated destination buffers.
> Replace memset() and strncpy() with strscpy_pad() to copy the version
> string and fill the remaining bytes in the destination buffer with NUL
> bytes. This avoids zeroing the memory before copying the string.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
