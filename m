Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7C013790B;
	Tue, 10 Jun 2025 01:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749520195; cv=fail; b=OKyow/8ol77optbVIfTpd5RoQgIyNJceFhf/RtAs0H3kqHU4uqCFcl7FGkrgUU5IWTfSNXB0MKj+Fg6/AF1ddHZ48aJaSRRsInuSTGQxKYlThqyTu9EE2VsndL416yCLXj0qZP0toY3+tqvaaWj+lJYjnNhO38Ab5TpbQ9ftUuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749520195; c=relaxed/simple;
	bh=Ktpbr/Jy0SbDgkhN5lY4ZpyPLwbWhf3kwBnuhCuqNNc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Sk4b+CMHQP8IaFIAlOjs36l0kPPhCBOTLUCxAl48k05qvld/tuoLoi9236N1Vf2mg85vDypJWBXlsCiNvjuOxRcYlkIMmwGiL45yRxzLcwN3N0tu6K8V4Em+ejAq96LIAlOyzTWeoflP6CWdu44huwmwiGisraSWkmht+uZTpMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=osTO3Vm5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lF7tR713; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="osTO3Vm5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lF7tR713"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559G23gm009412;
	Tue, 10 Jun 2025 01:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=71/YkfFoedyzrm85zr
	OGiwSlf45dsXt+I+h/trbUOYc=; b=osTO3Vm5FwUOSAib+SGsFgCMQaPSwBqTqJ
	+mq5RQkazh3v/e8ZBVms+/o/N3KRyBWfKNY/TCRwilnnknAM8t7g6amZODhh8KdO
	RbbCaLbEsy7rmOfEye3DnPJfTCXENmiufheTplaBDjoWsPrX57trirTqtANPk6F2
	9alkvnMCbmwxaDdZ+MIO4MIBWMUqAgAPoOR/cwEUypAhz0stTVjB2OE/DQK34WRs
	3A98r8vOqdkylKNxIO7MHuDwTP6lflmh3gwghY5ZWK7laAgGENLCUT5u9UjN0AKt
	jSRRNQJGaZXMXVXJJtVvhjszu7oRQe0WB6xsy/5K6PE79LPc6M7g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c74u973-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:49:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A0qlus031290;
	Tue, 10 Jun 2025 01:49:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv846x5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 01:49:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qv/hZ3/za3IJVGIvXSdPmjnVyD367FQI/6ZQDZLwhN7QHdpZHCrM/3oSie98Kj+mzCdpARz7FScM0Ewt6HpL2TV90iMRpU4nVOyQeDIT2X00Qdim6OUhs6MOdcYcq2QMQFb3j83GyFqgc2h/sPcRs30dT/7F52IuRK4DuA/UiLqZYcxiXyc7u9+IgWG9aKETfK9kFbKMaU6V9V0Hmhr+tq2Bzt9aRBQq1bU/LCimbHwfjkqzTfpSSic49WPcrmi2jRENAipQrwvf6rFKkS6s8Uk3JdHYHak7Flhek9/oKlcoVvfrGaGy9lZCqqPjKgNzQbasbWK1n0L6dx3kPGMd9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71/YkfFoedyzrm85zrOGiwSlf45dsXt+I+h/trbUOYc=;
 b=Xvt16mPn0OAo28ZZxC/2xqodCKUu5Z2cceeN1SA0lERJJH6wv3+sPP2m20vlm2cJae4utq9fJU2vRjPeSp3PijcVW0FxqmNThKB+3lIEaCW7jQlPGZmLe0NJFWE09B61CpPl16QE72uGwph3khsspPMFywiKCVRpfibxmzkrIq+ZNmN0UGhpv2x/5bgt2D/AKrGK3GWQ9L5u1cLcby4O86ngfbEEaqWpsnVZUki9ElWISJlxQZ58ATC9guBJdkKNt4aFC2IWAEx33MMNZW62i1IfhJRtwPzwtseBG8OogxidvU0Q46r1v6LCgDJDIYLm2Hju2WFMIy4CjdPV2F9ElA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71/YkfFoedyzrm85zrOGiwSlf45dsXt+I+h/trbUOYc=;
 b=lF7tR713AVMn1U9+jdW7GucMo2PTu2zDlkT4sm+jQZVJ0TqmmXQIYzpiRigB1FExdL8pWijf8XQqeXp2r9m3MO6zN/Lmh0xlgO0HbBUkWjH6txW7PLKEs8/VX3Z/p0GXJZIwAl7FLBRelT3ReM2nulIdM/ZSj93/V6BFNhUTNLw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4793.namprd10.prod.outlook.com (2603:10b6:806:110::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Tue, 10 Jun
 2025 01:49:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 01:49:41 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, himanshu.madhani@oracle.com,
        darren.kenny@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: docs: scsi_fc_transport: Add documentation for FC
 Remote Ports
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250607162304.1765430-1-alok.a.tiwari@oracle.com> (Alok
	Tiwari's message of "Sat, 7 Jun 2025 09:22:56 -0700")
Organization: Oracle Corporation
Message-ID: <yq11prs74d1.fsf@ca-mkp.ca.oracle.com>
References: <20250607162304.1765430-1-alok.a.tiwari@oracle.com>
Date: Mon, 09 Jun 2025 21:49:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E07.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4793:EE_
X-MS-Office365-Filtering-Correlation-Id: bfefc234-949a-4330-95c7-08dda7c110c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CXwqQJ68g0rGGps3bzRXqaNguco5H+sIsz4LyDxYGhHJloacRbJ3NAsb9psI?=
 =?us-ascii?Q?1a14zv780Q7nQ7UyWBxtqUK+fPZsAwGiLTeiIVltOFsdGKNXDXd+0YeuX/Yq?=
 =?us-ascii?Q?gnornp2Dv77kE29Ol8+P4KfKBWzSR2t7n9iZW9A2Yg/YAlqP1INTTI5GS/hA?=
 =?us-ascii?Q?HwgnisjHBDZnibbIG8xJk/VXFwdHlmNAa0WcTxQ4NySn9HYJo/P3u+jdRm0u?=
 =?us-ascii?Q?Wyn+/ZeoZomDLoiqkGaoIZYOQq5D8l7hvFkMNgXSMoqaKDYbhu3B0D9sT+tc?=
 =?us-ascii?Q?krxi/cGKKLLf3E/kpP+KKVx+Wg4wXcM6Z6bsT701PEteCQW/D1JG2v6d1Hz+?=
 =?us-ascii?Q?2iA7LSJ0IjeGLfMdrJJkvf2NCOY43NtoeuLYOHP6Hq5WVi54XLWLuRHRrbau?=
 =?us-ascii?Q?OiPvTViacwnwuogDQqXIr9YB5qsLWtJhzPVeX1JpIONhSZ25eZP4T9rrZ5nw?=
 =?us-ascii?Q?2vHsldhbN2mZHZW5nGXTLprUkz7siA+m3o7n8JAPgYO71VLVDaKSAmVZYn/S?=
 =?us-ascii?Q?4h5gyJfL4TqXqtSSd+CeF0VYUDx5vVidQ3Ga2MdbefKINKU1GF81C+6ze5/Q?=
 =?us-ascii?Q?9Vv9lekuwvL7Nea3jQZNS+Wzs/TUDEysy0V/pLzkvnC65KsKNG0GPNqpSMtE?=
 =?us-ascii?Q?MWvEGY/tZRcc3ZBvRhFnOdJs4Wjg70grns1XVlBAcliF9YOIJdiZBakZMGt7?=
 =?us-ascii?Q?duyN7Q6oZN3da+5/fUYFjvw1FxbWLgHaw29Qz3jF+W/++6JPmZN2wMjZ7i6j?=
 =?us-ascii?Q?HRDy3mwTkzQh06z2jFkq+XXRiSwVpzCHlDLIsBMgrbPZDk/T+mLvDGjCNF9k?=
 =?us-ascii?Q?W1bn+YiVPf70CmTFd55f7VjB5r9q7KrTbkabZL13oCYi++L3Y1r9Irdq1zK5?=
 =?us-ascii?Q?Mx01NCZmFn2xNfFb1Xs5bDmK7vVH1btdDNHnnPK0Y8h+Y+ssWzsSulXaG93D?=
 =?us-ascii?Q?GGNNflkHYSx4OxvueMeLl1hGwIGv3awSLBLb0i+030Z7QrgUl6c4KkDCHYaX?=
 =?us-ascii?Q?9QpmJW1cQGl2CMZVA3n4sgSh2oqROepgDQbgSQNu36ZXFavXCAS6WXhJZGI7?=
 =?us-ascii?Q?fQ+y2QSmQtyVOaJG3Yd1Zb4MA9TQRCgwiuoTq+0QXDenxSZPu13wJDnBf8h0?=
 =?us-ascii?Q?Ne/D3D83QBKfE0puXTpAa+LOYdU27XClMqxpkbmMazKnEzfR6VtMYSEG976W?=
 =?us-ascii?Q?y3KxlIHoHGblB2XrTfRFzwh6px6oXyBalfNMM+ZoxuVFLvvFqPx9Z52fIAW1?=
 =?us-ascii?Q?41MhGrHWYRu4Qbl+Nyk8dwagTHnuGSBWH+EFg7rjkZcc6ctb7bXFX/TeNrqb?=
 =?us-ascii?Q?ghUABXMxZM9UKQjlMg9dHLBn5TP32PC07ni8FNORU1vYHdj2E456U+q6FEeE?=
 =?us-ascii?Q?Gx9UsbMMKNAl71MZ/u599n1qnxZ5/iVv2has4OAtffRNaEeHSLHw4bOEEn79?=
 =?us-ascii?Q?Hebnns/yPho=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dZtDrLAu93IZgN7LjCfqBRCK+An06gtzXgFXiBhjETbuJPfgu706chyfPjTq?=
 =?us-ascii?Q?cp12ZbqJnKbOlv6T7y2dl0OJbXXBX9Jb+YaRLR/+fxBiRofcCgQmhGRu0WD/?=
 =?us-ascii?Q?v7PN9iF99CHXPuHGu70prt5rsH52HjHorK9pn88mQoi1wmjoLtGU6SI/yCUp?=
 =?us-ascii?Q?ARztECY/8adYisedfqX0CriYyYjUuOlGwlBxd2r7QVRNebZz/nh0VdChuGw5?=
 =?us-ascii?Q?Scm8dmyV4bq7si6Eiurm1FaFq2t4+T4wYLfIN+VPd7CpNQN0AeeZtBevZHoC?=
 =?us-ascii?Q?k7fmn9zy378V7A4RpKiILn56UqHdPjQlUWAsArguGmdR5nEDvdcFT11w+JfR?=
 =?us-ascii?Q?AqYdl89yn+amkzHaCYpiJz541zfqSPoe6anBlAfo5vEQzFaE315LCeLMXnTR?=
 =?us-ascii?Q?swi2VgyIByLDkDesez+m7IJajmGaVLBpsKydSUjg7+A7h5ykKZ0W2/ntCyL+?=
 =?us-ascii?Q?QOaSC4utPH9rSwbpv7h5oghNKcuF3EDvaZePr7dMz8vVWdgi0rV9H+tmKm1y?=
 =?us-ascii?Q?drz078ZUsLkQZqxqeOXWeaDKbu6a97IYjJD4IgCYTf8NpyZoqTE2h3By1Ax8?=
 =?us-ascii?Q?cuu/Pp8AJVJeB7y+MlNSCKBNAdzXJOs70N/65PZ8XM6VLtKxhWcBg+sGb20l?=
 =?us-ascii?Q?bnVaeBtPQY6rk5SM63uOXJYwCXicMRzIPVnXnEN8YmpflRvC1U2ghz59a00r?=
 =?us-ascii?Q?xW6eUf5ZjHefXSOp3Cw7YzzwFUXuyxlQb/axGVBOvFcgeJGMSRiEJur4hwFc?=
 =?us-ascii?Q?4T4hfVPUCRapCi95iQ52JFCUSgFCzxW6Fc52Pc0YWg/fZP5jf4njSZk1L3ZV?=
 =?us-ascii?Q?msrYg27ncogvi9Q9lE+P3Ok8qvDwBJaHmwp8K+0P+jo7EivQFVvvN62FsotS?=
 =?us-ascii?Q?wNkqybseZFfGIQsUcJ5EoFnkFm4J6ejDZMeRtOxE4/sgIwf5B4OgP9nSerIx?=
 =?us-ascii?Q?kO+E8ZxElcGIX4aNaGHxD+c9oplKHwBPj2lR0tVdu7XZ7HupyaEJa0qQjInG?=
 =?us-ascii?Q?SnDyJyNBQU/j+nJfuVx8bd71LjU1WJC5wHE393rHCVi4wNGDFzeOt3HStwfN?=
 =?us-ascii?Q?aIGmJXWkK1ZxY+7f0YdQ24LXNy6+awovsw2D0qmxBFy4ppg1vA/mY2fBw4Ib?=
 =?us-ascii?Q?xnqKHnRdpU4LrrqjZyH8BsSZVAr71IvKUV72QqbZQWtD1CLSbSY2GYz9Hfer?=
 =?us-ascii?Q?DeVauoqSNbKa4tyZbW+6ET5PxuO5YtvvjTIjyA917IC8ipc9yUK0zPsfzdLt?=
 =?us-ascii?Q?CNFwsXKVjuhR24H/V//Yh2SwYBtbOnHiWDVC6/eoNboShQ4MG/G0eOnkdNMl?=
 =?us-ascii?Q?FW26GsSgHbLDa+VZS+0VUGau7X4wmlFOmzBzdC+HGZPtDpTgZyXlBzq0srjx?=
 =?us-ascii?Q?v6bOdL2Dk3Mw5UlBJ1C3cPNtY+HZfEYsaYiSp6NMiqxoRyrO4T5BqMOtpV5x?=
 =?us-ascii?Q?LIPuaDrPmSw+8xQNIc9iClVJXTpLPgmr+VmcBlSqaJRKo4e8O0o36WOgL0xQ?=
 =?us-ascii?Q?jN/8fFdOI+1Ta1aJVv5rFb9UORNkMTwE1ff+QBEmaQD3mE6BKplBIE10K2CY?=
 =?us-ascii?Q?5SCYT1Ftz+6ZQ0uXty3NElbZblnOKFCJ6fngdbnAK4FbC3CpIaoYpgF5IPUr?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tVXAT1OrJd1GA6jsvkEPxXj3J8UzNyFMVjEfCv1Z0MYXBWXvvq+/7vDOu0eZt7+PX2FmYcA2IDq9St222V2ubWgFS7JWbocss2TT8wszmvqDs0qsHPmgMbur8COCc9V6GKru400UcwgLcujkn+99T0CkotVniCUFcojFjI5gP6+CNyHTMCudU72YY8TP5mlqx5XXw3BGxobbHM73p8k/lzaqEb1TgVQs/4R5fBkzbH53dBFqv9eNaajr7vj1kwBCU7mCDBGuFTgwp7yK+KGqHzJPV9v3PIMifLi0MEDgHqYgbkcU2Qgcifhxd1dxrniWmieqkXkMhNJmDXf0a+LwKh5ClHYos9k5F6a/PP3oHLh9tl2ruF5Dw5fbitI/IBTrilSHyBkvBYRY+NCdSrl9uGU1Y+aFyl4qtmyeiad7ATHbQz1LgT/1Rm9yB+B/YBM607jBetJZE3+hcFz4UNJVJNP7IiO1UUUdaUCLLpH7AFoK6eIIICP+bI7Jo5DTYFiQK5Tx2DJSCawSqU9z4vBUKVM024nUg8tYKlSlpBZcbfLJ3EtOnosaPsfKIzMPuVFL1XpIIggE7Fng3htP4ezVQwXN1XheKRSM4zdUy3u1juA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfefc234-949a-4330-95c7-08dda7c110c8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 01:49:41.0139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: je5OV9Ty6+3/bv82KfQeLljcMtpbmSdA/zqOzA817I8ojpV+PR63eFWK2DOdIZt8Bdvt9vDdd9G0kCftD3u3VbAIiM1Hb9irhHFhK0nWvno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100012
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=68478f3e cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=rup8aNqa6yRE5M0vNl0A:9
X-Proofpoint-ORIG-GUID: q_dUHFufb1t4B7EgIySqg2xb3CKHRgmv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxMiBTYWx0ZWRfX2DHe5OLAx4e5 3AJifRSO5h14Llpy0Ad3zy1BlpzRBDKhqhRK/RTf+t9bZoNED6iRQ+w6iGGclkixbOYMs5l6mG3 3gIThgTM9SAR4fKKISPM9rEP2DFfjoatqU1F7zBBtGhjE786zp7WOUNPUSdkpGkKykjlulagl3E
 olZcARVbn/qsJAF4bHEn8JDXzGmJlegfISVsAGJKnXFm5/uZr3KwUOf/oVILgCRf/JI70OlqvHE zB79TJCKLmLoS7G3RGpoQpbQoFk/iMYIsjykI/G8THrza8YnS3SNiUPyAwG0DTpJgss/g1Ni47i ZFW5T2yo2SFe9xxJLauDcDua8SId05wdl+yffxwe17gI9o+FqgK2vEs7bft1sIeq1Ff9bg0mp+A
 cQ00WY1HrheqQ8C+dM7XwfcP+2QUxQ9w6VH2Dk/1gyTovnkOjf5b5qUH9EcDYIpJnaZD442g
X-Proofpoint-GUID: q_dUHFufb1t4B7EgIySqg2xb3CKHRgmv


Alok,

> This patch updates the scsi_fc_transport.rst documentation by
> replacing the outdated << To Be Supplied >> placeholder under the "FC
> Remote Ports (rports)" section with a detailed explanation of remote
> port functionality in the Fibre Channel (FC) transport class.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
