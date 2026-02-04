Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6779E3BB48;
	Wed,  4 Feb 2026 03:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770175650; cv=fail; b=aS8bNE6orjDL8m6zw24Cuy+49wIgvJ1vf6/vUDxO/vG1z0KQhxJmoSJrevaRCz/p6ELhJWglKzq+sJKYdVyXeLmdxQgWkHPbMf4ZOp4XuXdt5CGDUtrDUEU3GSQCHzv/ZbEu8nPlEbMzKuwP8rGKnDP+1HueKUH2S8DFoqhEpEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770175650; c=relaxed/simple;
	bh=OHIx6SQZUKreW/1rOXllWumfc/Gb3jRhvX77PrMpxeg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ouLG9Z8brv205y7E9TCHjuYJrcIA3Y7OOYl+J8edqDn0OHZpvQXQh0vCwPoYlT4yr/vSobwlSBQH62qFTpIH+uURmhU3fjOkJ5pewAi1A/zdpfIvWW1WpKQEiamGfjqKZPugmhad0+pHttDt3d8EGtndozU9YiLRyX1k+p0kpuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RAeQjg1w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jyW6hmBb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RAeQjg1w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jyW6hmBb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuK5L4088011;
	Wed, 4 Feb 2026 03:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eo/MucRtuIC9oS0pNS
	qAEp9FeQ/WNtoslDhs685HllI=; b=RAeQjg1wbXLJAtXwYKMEQ2SPYttqKxeLCf
	yxZ441f7zGhKphwgMLMtuk2y1gL0iiZ+2FXrXvSUe8Sh1555JS59btLVDbmxjIk6
	rP/Y8xh1pOgGK9TeAfqxCwYk+YyvGI5KFy31/+uxCvWaS0CP60dA53G5/SYDj0o5
	AEfnit1tD4iJbRo5LNSXbnKt2e0ADEYNLDPubrmsMRR+qT0E/6EH2nJMpTJtmCUM
	8nBpuP1SWp7uV3zwJHoIF7qeVE6rlokS4pgv6X+bYtYThLmfMvw504mNN3X8QQUL
	SRZHxSDw8bWsjEJ6KtqdOdds+M8ZMbLDYY1gog0TSDu7WL1qFBQQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb14n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:27:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61431FW0002180;
	Wed, 4 Feb 2026 03:27:20 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012036.outbound.protection.outlook.com [40.107.209.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nc65j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:27:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRrBuuwQoJksd71DFOmNmWQxB/naem6Oy9FU9OPqCJ0Ky3LhNeFy3Nd/bDKLIdatpounFdPleWRTcWTSiaTTlMwY5fr7nGbi+fk8lj2minwYmLvqUXM75zF6s6i19U3bRd3qH50gzT8uATmpZ9NCAqluOaNz0PgLzcXWbwv8uDHRKCdY4p8Ebo4ZeXg4hU917F3OfRhsfG0imeZeJBGPoqdjgdbecY9v/LEYVJAr5y76E5vWxpo6Z53EnJfWe65t4LnHB3Tc/1pzZJdzwHWNXpdVkwFYEnVx6jqrom74yhAcJVxRXjC3sxM8BRZMoiv68zH3g4ifNPGMsPdFuBGoHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eo/MucRtuIC9oS0pNSqAEp9FeQ/WNtoslDhs685HllI=;
 b=o7wyhY6Gv8jt32Idc2GfshAXUzSLsNDBNmxRtrGDLWgCeBQgeUJdrogb286NOzHvStZ6gstR4SAT4l9pa5plYKLRlBJiql5irbnjBI8WBq/087R9OSUzXSt0ZtYNuluGLBVckuhykxZaaQRIYECj+Ib1oXjWKcpDRaMXZD+VjXCe0uBaKcZNyjX2a5t+t1r5Bt+3NaOja5lh0dgjP43rRIDS9Jc9R2yucUdwQYwKEI/Xtc8RCuPT0HT6nHHOujTHacaCfquvcx5f4eXUOCu9zml0IjGAALI0JC0iJnJAaLTDOWutjiwt6lOTNEgsTEA7zq2bNGKl5zy20XrR4mwEXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eo/MucRtuIC9oS0pNSqAEp9FeQ/WNtoslDhs685HllI=;
 b=jyW6hmBbeKRmYeqLHyCOJChC0tVhiAkAejLE4mFHt4yiI0kXB8zZGn6vsd1Vvs4UTyJMZljaxcFiU+ottQFp/Z/q1zLiKbSBtyuZ9NiZeB5MldQKqryuEzIKiD4Kv6IYpCxnVkC1vu/k5imbdoL4D6YHf66O8Te/pt+GFZLnWAg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPF109C7C399.namprd10.prod.outlook.com (2603:10b6:f:fc00::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 03:27:17 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:27:17 +0000
To: Keita Morisaki <keita.morisaki@tier4.jp>
Cc: Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing
 <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mediatek: Fix page faults in
 ufs_mtk_clk_scale trace event
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260202024526.122515-1-keita.morisaki@tier4.jp> (Keita
	Morisaki's message of "Mon, 2 Feb 2026 11:45:26 +0900")
Organization: Oracle Corporation
Message-ID: <yq1jywtnq7o.fsf@ca-mkp.ca.oracle.com>
References: <20260202024526.122515-1-keita.morisaki@tier4.jp>
Date: Tue, 03 Feb 2026 22:27:14 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0100.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::36) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPF109C7C399:EE_
X-MS-Office365-Filtering-Correlation-Id: bde1a721-fce1-4cf7-8800-08de639d4bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?889DlL7E6l0kEWlhwRMhSQ1a6lk69wKYny2Ar0f0DEZyEpBZewfZ05/EvkXL?=
 =?us-ascii?Q?RUaSjMUok1DqR6B69trsgVHJ1oQtyDrTWm/an1imZCr/RDyiS8VGhzUmBO7j?=
 =?us-ascii?Q?ntsIUUp9gAAO7amHSnA+1MF3fgYSmClB7m1tZApysT7+LPp/Mfsun2ovFehm?=
 =?us-ascii?Q?q5hvjMItss2+IMWnV1rVFEbv+r7nIJsOk5jG3YjHhan2aK0PEx66kY8/8sID?=
 =?us-ascii?Q?RCO8CcjTl5zSNHr/90lSBQOFda8RGsj87uzP8A4ng3vQ02tsgZlwpBXj2+5T?=
 =?us-ascii?Q?0bstsz2OmJIE7MvvqDS50y+axs8Y49V4JrfKprCq2tNcBLXH46SmFO5eDqUX?=
 =?us-ascii?Q?QREi2zc2VszvX2vAthcJNX9V7crys2mSoXYVg9GQTsnzx/ZaFIoZOQdPGurS?=
 =?us-ascii?Q?A1PP992rQcUcUWNEGsP24kjYnNhgXsM6eJE8qrghjgezUMtoiEw+phW7XIkk?=
 =?us-ascii?Q?zmSN4CnpawJx9lCxiXoV4R7/D1f/uZiNloWtf8EjCFYoYy4hHqr6HdRSsbVQ?=
 =?us-ascii?Q?TC40nEyXlLGqWdwkvMh5F7Sb9rFCnf5xypG50acW4ufvsVK/HY2eQtHWjtnX?=
 =?us-ascii?Q?i+RlB11GD6nvoJCLSTkyAJP4pD4JpVzapXePqHm2TasjT3IjAhKsV0KZNe/g?=
 =?us-ascii?Q?gf1WgQ03bOEdmFIxSlYLATP3PbMaypdVUi8aPZGSobkvhfeE2dNVVpnh3A+E?=
 =?us-ascii?Q?+JuxR2tEQJYluQ2Y4pGwlPIaOboNI2wgBvryvD3y+n/tCPFABT0nEyDLL7p7?=
 =?us-ascii?Q?XijqX+ti+S9pEdm4U96I0x9hJevUj97YCkhkAb//xFokSS3CCprf4uhQ/w+p?=
 =?us-ascii?Q?G2Ce4RzNkYgUaqS34d2DQebWtxGrUzQki3aRUBvwsUcNIBluto7HaWnUMI1k?=
 =?us-ascii?Q?uRxIqt109DZL9bO5GSeXPnqkQcOsJG0dOuDmzUnHiDdcpT3Is0Oc0q/i32gr?=
 =?us-ascii?Q?HNRPa1/JV/RYJhCGvYmm8nm99c1LD/GGoCVDQNe4fGzHaOWwDYZuKVHKieX4?=
 =?us-ascii?Q?8XjKBkY+Qiy/Th+ND9aUX5IYAnGIXQJ7/qCnzxO+GE7SDbK1PQxIXqRGEguR?=
 =?us-ascii?Q?hP7L05Eskcv39T20LBaY9nQRgFr19n+XXAg/U4mg3m8rGKlnfNpf0zz2U4r3?=
 =?us-ascii?Q?0xv4xQLBpPdln5ZoVVYcIuxSOT/qaCl9BDMSwK+0DYQAEgzu0Ml1emCQqvrv?=
 =?us-ascii?Q?9xG7slz3WxUaMaCh6enVMZXFRXYnYb6iTTApkDsQvlmitR+Gz8tWI4fuxy1I?=
 =?us-ascii?Q?vlhbP9SnP3IKH4IoT/1SmUURYK6bSdGzXWleiCdd9ky46P00CYsfrYGslGJq?=
 =?us-ascii?Q?3hs3kQ+UmiaM081W63FBWfc0Br9bHv4U0fiN/4UiYMYmUNIY6JOw9dtZGJMh?=
 =?us-ascii?Q?jF8B7GFMjMmL1AKiAJaFLbjnfibh/A67em+q+0mtmdIi9Gn5tU3ySdznTzry?=
 =?us-ascii?Q?OuA04YnUZHEn4gxcU6bRQ2katlK7iD0lGvrGNkamLJD8zj8GKYhI06n3l1WO?=
 =?us-ascii?Q?S36PuC/k780NC6rUa9l81WDB4u0WVIyolC4dip75YWeZpgixiG3bCbCmuMWA?=
 =?us-ascii?Q?H3V8+xqhQNraxLaeGfg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?913JWuHMa+2HpxHL+35Bw1h6hNgMfi0rhOb4MLMJiDuxOvaSNbXT4sf8eD1u?=
 =?us-ascii?Q?92H9KE01zEqM7ZH1XvqcGKoEPdnkMsZl2v+W6D3FAsvxw5LA8jMm9egUacMP?=
 =?us-ascii?Q?6WQwTFysD+FK3wXNxS5ca5EJCgjtcougyQ5UOiGN38WUmliKiaTpjJAjw6Vr?=
 =?us-ascii?Q?ktRCBoFw/5A/pQikPfrfnFsraLaxKsWEyHjXNp7FAzlf43Ey9r/Gn8nEVZKk?=
 =?us-ascii?Q?/Md0VxN59sUQ0tW8arwNfJk+lifGxHmvXbjYLnRqXcPofKNNAbKDwaqjfEsM?=
 =?us-ascii?Q?jW8haDH+sKAw/ouPLmPy/s7pVEDvml9n+3It6jryra2k0J1RbZ4f6ivsXcFz?=
 =?us-ascii?Q?PNRSen0ZAIhh+r3j6hp+XGauCyKCujymWix3cWuLYWTsWPE/vD+dQ3tz5uER?=
 =?us-ascii?Q?OgJBvBmePX0I/dYF5dK/5lF3D3agxASmpO7/tOYV8Umg6BOq14B/AB7RkW5d?=
 =?us-ascii?Q?UdIT/vH9Z4jqtBzxJ9vxuUteG14HLMcMf5gDc4cl9HmZy4+CqLHNLqUDW94q?=
 =?us-ascii?Q?Z9BPn0tv3q4Ny9pBn0hXOMHXsgCrpMt8yZ+Bu0wH9RnNUjbkFiSKTdSScctO?=
 =?us-ascii?Q?kqvAWA/i9xfhWkioD2TJhWttFH6Z3anLqKdf6BIbPf7/Jbyj1EBnJ9Tg2CX6?=
 =?us-ascii?Q?KUkoDtyDVZeZkxTpKaE7N9NWMJBbYw8nvjEl42Fw1BoxX3XJITsbnh/w9Wzm?=
 =?us-ascii?Q?cBEs0lY2IoX/QDAUKLtzQFXDuMcfYDdXQurglSigfKTNuSucXKBNLtsCpEFe?=
 =?us-ascii?Q?p1cpls42a7HozsTbby9oQrpt07P8kP5ARnrhj70OhzExWQ2gamB/gyXRRW8+?=
 =?us-ascii?Q?yp5d77VoIZF+/8q7WybnHb8qAZdSdn3gFxqqeDDpwI/4DDqKZtCRLNRlLg11?=
 =?us-ascii?Q?JkbecU6XRF+dvnNUlXDqZaJRmozny4PTieyN328exJ0vxMD2eY2Matq4hQ5n?=
 =?us-ascii?Q?lLU1js5qf3S4o+A/C7cXgfK9RWLYXkHAZUayQ675Fiom1fXQGATHR4SvLV8U?=
 =?us-ascii?Q?KZ+l1ahpr69/MzbfVAkX/ehkZLkDKocsfa7zML2xytnNb+iOG4arRgp7jb4+?=
 =?us-ascii?Q?WxbZ8l4ZE0x9jzEn8kjnV8jKEBSxWErjE1RsCGYuTzc6HOOXxnyGZoHlLNKL?=
 =?us-ascii?Q?Vj7XID+5RsVDZKolVMxZLnUHrb9DFjASWxnMva1l+Kj079Eej71qq+84h3O6?=
 =?us-ascii?Q?qU2PWQpQtQeRl1jCvrmFeT6xc6Ps94vaam6gU2xqkG/1hm/WvkECVxWZsyc2?=
 =?us-ascii?Q?vLnf10C9tTttfZD2XLjvbMY4BOTL2BfPYwRAFP2jMorBEv60Hle9yDFUPFhi?=
 =?us-ascii?Q?iyZ2csSK5aJLA/bqnF9GkokPmb5LxQtxVuAMAoBpLXoNegWGgn0QgELS4L2o?=
 =?us-ascii?Q?pfqu8hP/p1EMzDHfYr+h0jtIxhfFETK4WH+N2hyRS5Ky2RXUogW2/x51CDPh?=
 =?us-ascii?Q?vDXHH4TiMlsvi9rtws451xaFNfIBzFVaTAi1bvPmjFY6LMkkDXIEehqq9REh?=
 =?us-ascii?Q?4prAQXLTw79Gd3GslxQDywXjyJrwXnY2VamjC4vn6q6khUMs2ZO2CNtsQOKM?=
 =?us-ascii?Q?4daKM7jTICFLmgyRdwN4zNxdygIIH6gQ4KN00Ape32MpqMdOKWv2aLtOeaRM?=
 =?us-ascii?Q?GfUWWnbaE+k7noTqyrJYxcGz5IEKhF/YkSQlU9UmNFPbC/GQJlGi01NuyKTj?=
 =?us-ascii?Q?Vti69TGQOsyBUrRvTB8nDoo+26IU9oU6Mfiqgd+9SGjQrteEPW1bgMCIfM7O?=
 =?us-ascii?Q?/Lu0UcWGo9M7xVZAZc3b6EhVAl1Crjk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+ivvbMx+Eq3UmbtMAqt2ZydF7M3DCU0ia/dxk255QmD7hYNMR0NPTJqu4eRrktjVPweHSFW79gXj6ZUxK75Or9lt/aqpQJoCPKC6MF25I6x1WbGjSqZ3wS/XYOHV96HlDBpNLyr1OJrjt4zaYAKXuQ5zwiJFUij9JN23nmS7j2Jx9lVz6IayU5WTfJJKD8cPiGSKTjXlMQtih9j7rhJRFIdjhIDRyvv5oPMV4k5Hb3kohDn90UMNB1r2wyeuFZckkwaoBxZfs0a80JlkYv/QXLNGaW8PFR2yMpyzqLGaDnCbp0NOvhrtoV0WQ25r96zQDV6gdBVQv99jPn0SUQWaF0tLnJCRXOeR1lHCY409vSnK5d92hnaH5jIxNEBRMDE4732+pKIj2lkTVZeLXyZt9LdRrcHDMAb6ooSa82JEvLX+Yf4QfcOg79OAI/vwAIBBIieP4JYR96MSSnTArFeaeeWrx+vqVz6aubTVhCq1F1xXUjQpBbQM0Bzj+lNo6nHtlH+Mkq1AENEc0ln2gSOtBNeAKxX2sl4y1dkGnQD3gs3m0sR2B5OnTPrHIlVZBjLl0InjqRfgx2gJuvR7DeZDywvAIPlUA6jI1P/0briHYAc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde1a721-fce1-4cf7-8800-08de639d4bd3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:27:16.7681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dIhck6axX0ihvXnTKCh66cVJLn3CNPUQ+r1yWNPeHG54X66HdEeN8zuVSL71UFFvFeT9VXs+H7r2O1yYrbhgVZVwAkz5pPIRfnrJ46Jc2eI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF109C7C399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=927
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602040021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyMiBTYWx0ZWRfX6Ms/evyQRp5J
 Zp/ZyMgtmvCBUyCR/7B8NCYeXAEE6DRkVbQkhJfTkWCEImWtFHzPj3oXDnRsIpcW7zNLOpsQaSA
 CDavvbuottGLVp75eI2U0u4dAXuBHFXBxnCQda7NgY2xKtrvtGZylf3vgQ7uXSvS3s1hLa6TraD
 pD91dRNmCuSyDcLLb8Yex5AlytCZgbPnwpfZRE/bKmoJoAF0olHn1oe0Os9WK6nLDVMH15BGF/7
 DzT+T4CDEYYi/jTpcXaR66WFuGreAZmZSgalERKG3trkHBWAb5ElaLh6isH2IBR62/fcl4Wt9we
 N8jOgHVMKrnmYsrgIEw4dF7cCBshlwT0O9rNDH0/7ec+79LhKcr2JYy+YuZ7XuWKNojzmEJ0wH/
 UxiWmsupasv/QUC7n71SxYy0BHQfq/EZmqjp2/vlnM9DmEMbdYTjpnfEQeXcVQE4F0jNdiVH5Hi
 quaeGzezE6YyUx8cvUQUH69H9SdRKLUlzRy7XSO0=
X-Proofpoint-ORIG-GUID: m_9VS5IwebZoSpXzWsxPZXb6UIJoJgA6
X-Proofpoint-GUID: m_9VS5IwebZoSpXzWsxPZXb6UIJoJgA6
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6982bc99 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9 cc=ntf
 awl=host:12104


Keita,

> The ufs_mtk_clk_scale trace event currently stores the address of the
> name string directly via __field(const char *, name). This pointer may
> become invalid after the module is unloaded, causing page faults when
> the trace buffer is subsequently accessed.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
