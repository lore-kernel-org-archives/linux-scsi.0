Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D8C3A1E67;
	Wed, 17 Dec 2025 02:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765938751; cv=fail; b=PHNslVCwMunDv8QHB/YBRmckCgQp6qgWnN6ClObkEMX2zU6ctsgILl6soyp6nHm/osx1kEbJUluDyk70wLPN5ouaqLg24pjqRowGVN55lYgOTTRxEU2J5mqJKbHEwU4uIpW13+qMdm0yeMqAbr7V8gYt3sZjY/hgevHRcF/llM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765938751; c=relaxed/simple;
	bh=Hwch0oEmtDR6z1Z9B1WsWsTc/YkqoQohwoYm3Xv+W2Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ROGzsgfDKGLnY1FFXNYSLfvkGvlYZZKDIWLVWGVKQ2ylAIfpLvIhHFRibsiFOnO4QuUgCnLDp/z2pcVY8vyW5JzzkdyCWik6UPdj5N7lKEdzESUZBUA4l20RDXRnEMiMnX0u5yUCYW/dYx6yqK2KJZxv1/s2dfAkIycOz8jUz44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PaxyqyRw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jGiGL5gl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PaxyqyRw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jGiGL5gl"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0uKDG1588742;
	Wed, 17 Dec 2025 02:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tHuMOsVNwavTlFL0yp
	YlDNcPUOJZ9jfv6CehL5Al2z8=; b=PaxyqyRw7dgKLcIbba9YeAFYBmqOIiCDw9
	sem1BpXNh1kpSjLSyZWNffhhd6IFbciUKB7pLa2ThLVztEQ+2T0K5hIB+nRwOcmj
	o+ztx/cMdCQ/RzH3nyxI/bfIJkNjE70wSdPhWB/enyN9zGV2Bo2rJ2Auq4+CQntU
	JMQ66mORy6PTTbxxvaZ2HOo0owoAQyyg3hrHd1SLKduvmgsI85N7dDie1gn7zS4n
	21hM7Y6oVCjysDnBHltbZy2FRkyHr4debtx5FaF3Cgr1ci5ICDIHh4LIQs88vy7q
	MAF5HVXkQzvBxzhm1HtY4RqbbQgraGsSZbZiNHpOCIaLuBHAAgCw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2d2rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:32:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH0HCbN005928;
	Wed, 17 Dec 2025 02:32:24 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xke0gww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:32:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBYmZx83xldaLES6XTXxTPMjcfpcyDlI0QE7Xkunc61e8XdxjnfntJmI1rv1c5PO6Qdhb5TfL8JIvXdJuxGSFeRXIqYNPNGBSPm3CoKZ9DiwHn2Enyflg7DjMUQ/joEtx2+NlsB2fXNthF9BTO3w7WAIU8KAJPnrsHgOmS75Pu/pVGP4DkaV+49WHwFoUb3ld0KKDP+IDFSUuSFGb2Oc+HCLSHLGQlJFSxE3qOLZUDBp3Xa4+5EJsNgLzsxmFDt5Qbbe6v7rKQN2tZ6kHLw44yrYaZjJ6tVgwn4FpERKbX5SWQLShIZ34blnW57LcsP9JzyQ8dj9h1TSviwMXCAtmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHuMOsVNwavTlFL0ypYlDNcPUOJZ9jfv6CehL5Al2z8=;
 b=IOkmAv1Ph2ZPlVkBl7BVAmnQRI3pNVInQdwVlnbruIL4JQerUD8mk1Vf2i4hvlsWCHaCHBcwNUG7DPsfB7r6iAJaurhYG3GIe/ut6Yy9xUotlMOimhuze4SILR5wftS7yISUV52UzvX2PYoCf4AkAyuTeXt/rAPbyjCZDOTGwce1SvWW16icrgxBy5kBjctwiEJUnmKhiqNt/qpUdhkptcvOx4OVFqtrudmKtwnX/miYL7nQhr1Ji8VrGqc7quDFy4NU8CoKYBigU3t/86wATfgGWpjaRj2mShZuwyshFh/RjrKX8UJ+TgCzTlHH3pgBpjn3FTKhQtFuWQZ8+fN9KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHuMOsVNwavTlFL0ypYlDNcPUOJZ9jfv6CehL5Al2z8=;
 b=jGiGL5glqsIc994IRtSrcoa1SJJHX+ts9zOW6bkSeZXhbSA5Cu0aeeKr/SeCjTx5h/QLJMrU2kywKIbS7e3VlhAcvWzBZ7p9RXiXKBMMahIF/zyLTrZBXHM3w6BJXtDsSHJIDEpp31bpZmNWpGdHXU22BKuUb6czVik0Yk6xlto=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB7711.namprd10.prod.outlook.com (2603:10b6:806:3ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 02:32:22 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 02:32:21 +0000
To: Max Nikulin <manikulin@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH v2 1/2] docs: admin: devices: /dev/sr<N> for SCSI CD-ROM
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <f0a3e0aa-e4f9-41d3-8931-57837831d136@gmail.com> (Max Nikulin's
	message of "Tue, 16 Dec 2025 21:17:13 +0700")
Organization: Oracle Corporation
Message-ID: <yq1o6nx6dqq.fsf@ca-mkp.ca.oracle.com>
References: <aSuj66nCF4r_5ksh@archie.me>
	<f0a3e0aa-e4f9-41d3-8931-57837831d136@gmail.com>
Date: Tue, 16 Dec 2025 21:32:19 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0239.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB7711:EE_
X-MS-Office365-Filtering-Correlation-Id: 778ff920-1f8f-4052-5c6a-08de3d148192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hjc0J3DKu0qmfVxiOljQsycPfSKlcHoBWbk35mCFtqM1E610T1WSvSZIZbKo?=
 =?us-ascii?Q?2yZ+uUc+MZtnB1ncXZKAueEkohMfPUj4wOl3twYG0iS8lL5pBfiv4jsyOvZG?=
 =?us-ascii?Q?tPIkSZAJ3oJQOLfjUfmIhfq/k0nFKPDhsTos0rBR9vQwx/y1IdHEzbE67KVZ?=
 =?us-ascii?Q?0HFPVpBKCpvvhJsrBYkniy1BKb8CrNGzBuSaTt8V3yhg0gTiKfzeMHwVdIpI?=
 =?us-ascii?Q?ckAtEKQ4z9O0qKgiq1wmve8n8tBOHYPMEmBInR9dz0Lwavn/XKeSiAQfDXin?=
 =?us-ascii?Q?t4ZFhGLTk3IgCrYSYwUhhJLCCZHw8Jh3jiG7QPafwHP7uewYlKfLLHRBwWDR?=
 =?us-ascii?Q?hX4y/ri0NxLrJrClOnTAgwC4PBh2XBFZlGEiu4mVag7E5OJZbaPoAr7EyyBm?=
 =?us-ascii?Q?rzw8RK98+dlY2zPdvqhDTuCVtAa922ZWkAhYEwqkNKp8mDDQTMCceDlaXvMb?=
 =?us-ascii?Q?aQQlCUpR4eVHSYe/opuTVYvDpQarm8DWn4tLvWVnOCLbENw5pKQPKa2PctXT?=
 =?us-ascii?Q?FChKehM9/47YmLRBj7PWPZ7gjF1gtczNAxHXCMBYWgTRxASBZQt4Unvgs8m7?=
 =?us-ascii?Q?xCIjlMTpA1a9mvAuX9hb8zXQwTR56rj3iDB4SkhEdkUI8/7bwbnm4dl05tBB?=
 =?us-ascii?Q?fvzcFAtZnjEakk4fKPViGnYZsw6FKmYUBOBP4rYxGSRbpwKJac2zCTxvA0Lb?=
 =?us-ascii?Q?HUL2naKxU3sTVbZGzJhS4Y4R/jzZtRK1bFGWggRIxpXITNZfGkqz/9Bb+EWP?=
 =?us-ascii?Q?ZGEILtzIhqY5GDtD8czFk1ZA7KDUygjP1VSnOxfDfcnmwKADiYYv3qYTuGfG?=
 =?us-ascii?Q?6NxbhmOprLnKIrGMb3zO6lDNifFqUIqUyOlH47mXIAXgfUM5c7juvZYGr785?=
 =?us-ascii?Q?D3A7eXCIOMp8JAIVW6fCHhMMZJ+SnnQY+sftK/ev6kIS2Ze99o2N95VDH+qs?=
 =?us-ascii?Q?udCWLVRm/Oh4uCCVOfTeAiLt7+YJeGLbjtndgzuDS7djyo0Nft0stLmWIFyk?=
 =?us-ascii?Q?EQcnbY19CQQnC3NOVeponMaGLyktcrlyuT0WSWA3f0aKFXBpjoIrC4jA1kC8?=
 =?us-ascii?Q?DpAwk0qyudo636u9+WuL+aAEjFBUFqAD0WkcwzagZaU6SacyJWUmoIDfh88/?=
 =?us-ascii?Q?uwoPepf83tLgzY2Yyj6m0/KG/2o8SfwSX5VC6IfOqHBs1TpTmEPeevb4hM9R?=
 =?us-ascii?Q?CqogM4hpCSc6GeDzZSHr/fwUQpXEMtTRRApCxZDg0ZNPCY1wisjzhu6hv8WF?=
 =?us-ascii?Q?T8wMoAcX8ZLgL1q43XgMLHy+57J2R1Pqh8zMe6Pyd5q46kHW+GsckH54A3ey?=
 =?us-ascii?Q?/UcReXAPDup6NF2UmGkdXfgto9yyInSYvgW4px//hi+hXTbXxHk4a0g5O/KD?=
 =?us-ascii?Q?kRA7NJxzZFXKVh3f1f4KCa95D51XhEzQGj/K1ZOd2Av7d6d6zv/TTddSMbyY?=
 =?us-ascii?Q?Hk11pCQzKN31gLUyDUJb+D1n28Ce5tN3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PKprVrTl3ppQ+WDvapyH0t0WDFwEpsKZm19xgCuXS8sxWOv92MYtFyqEGst6?=
 =?us-ascii?Q?xXsvPThDe8d1gstZDV1De4yHuIXWLXfOWrx5hwH9H7R1R8SSjsyfgT7KaoFn?=
 =?us-ascii?Q?7gGwjlPkeX0aRw7dnwCtOOKUM5nVBDlvXPvYEAdAECBvsQ5uH+zgKBhnlob1?=
 =?us-ascii?Q?h+n1HzvcJAGP3idqM7pf/VdJqZG6l/LTy0nCMDSjY5gHPUVleXc3dyjFDV/v?=
 =?us-ascii?Q?4wSLRWCSR5tSGRXrPJhOKWSlQJVo3ez6GQEdZb+AFQpWL3ngShYDBYhEySLY?=
 =?us-ascii?Q?5dW9sxWLCira/CkONPqmTPnQSZAMNuHq5XufisnVnQOViw069iyibfwP8B4K?=
 =?us-ascii?Q?+9K4CEPdP/2tfpEEdyE73j5wNiNxraVEBFaUyKSjcef6Xsu0agqebRpEWNrQ?=
 =?us-ascii?Q?tCixlDqL+eWS1cqp7dijeyYKSHfEcUZe7pnnFx2Uww05+Tx53i7Rm2htLh+u?=
 =?us-ascii?Q?p33oaLCymp+MjTaY23EDM72WGTtQPkKh/91MP6q4s1dFBUPaTNJf5vs4kmSo?=
 =?us-ascii?Q?CJqCgE7sF9mBgaxBK+tN2FL3MwWaY1EnZiW2YKpLUKxA/3CBe/b7pyOrdcmV?=
 =?us-ascii?Q?Zs0K48H4/JO/teVS/wPPIVoOa7/9Pj8ZiZ3jq+XdvUm6Ny7Fqka0uOdY28S+?=
 =?us-ascii?Q?8NRG1Bd+PikMTB6xxoT1FQ/0+r+jr5627YHC7x6eozjD4m6jzxv1ZBBUY0Xp?=
 =?us-ascii?Q?a6V/PNFv/eOVHEf0mgGNQJUVUmHzXA9RG06ajt2JHlwBPm+LxS0Hok6orllJ?=
 =?us-ascii?Q?WgOZQOmM/9ICXCcY2Smq0BI36smeGH5SbDJ0EJOzQ9LhQvvqK1y/Uqr73Ejn?=
 =?us-ascii?Q?U9gnkK38+ghAyZ1YmB0viqmqkV1cafaVdoQgGzU3S+RgrFN89wtZ+xXviyKl?=
 =?us-ascii?Q?XWKNs5XrXOF3n8XvErPd3ywi1Y+/qlvPaLSuF5V6uNZ5+KQ2GoBsFwxyMlb+?=
 =?us-ascii?Q?j1b3o1avI5O+uyogtV8s/YRcLpYX9PVsOk3S+xMFEYKaMk+sf8HZXbVS01XV?=
 =?us-ascii?Q?KiHDJL9yrE2kOmqcvOlDCGUQAVXstoA1kI+WgJQ5UkyvVdZVwVIlt/eD/uwf?=
 =?us-ascii?Q?w4l/hhfNV9nXctr73StjpgMAgoTxzhMopHDNwqlcOs6NdkFJCIkiRhOdjvkH?=
 =?us-ascii?Q?Cj94j0VVTKUeUVhfm/iAOLkr8g+zzzKqXcnIwPJQXgq38J0r18zxIOIF1Qa2?=
 =?us-ascii?Q?L4+goQuAR4PgmBI5vbNqixwJRbSPTUVy8eDv5Z4HDgnZDQjRpuQauiZHQE6M?=
 =?us-ascii?Q?QoXXP/A6p6l5P47E19mdCa5EwijmJzphUXU3doXVNOhrZYUgXuCpiz/stTSP?=
 =?us-ascii?Q?lSPZmSPXQMrV28WgxYrI24sO6/YwhbNNPjbsOEJwpQsy9/WhzywXILVTR92f?=
 =?us-ascii?Q?wranCfi8UHgSwSLigIl9juhdxAVpFKDzY7pQxazWeVG2F/+QbPJnMkcsZl4A?=
 =?us-ascii?Q?ZnRQWxXlI5edN9owqwpCtNj5iAFhtDZ/DXNS3gt2ndV8dk44Kta7ZipizcB6?=
 =?us-ascii?Q?mIKCZRXqqxtRCEB9BwK9gCww0jBG7RAUTSbKCrpU5j5V3t6udnSjxyuJ8uzW?=
 =?us-ascii?Q?p45fH7eLy5VJzsTgOQYOTefDeHM9vIZm2bJCRlJbG6EURDk/sloUkIHe/qif?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I77tTsgP/K3tqwhHLbEv1Tmr0EsT5ietLlXqUElbGqRS+vh6xCn5WQg5nqibbI3RZcXRlF/Ok4qvsEhgFxfjuilqFGhZgNXnxKRMIcW2mBuyqrqg2Rf1jxTQG07ouvhemm+EoX0CQxwSDqFhkKWy/VdvVjt8icQ8PHklWyG/Ayv3HIoB1xmlsrzKb59efVziN79i7sZgha32hX6NuDpZy51kHRD6EjtOoFmEqM6WpnhUW9DLsh9whhUXTr6J4DJ3IUfkhsK3jlV7BUcObWr0tALINonPtlbkXNQaEWSk3EF1A78E/dvmGHijG+72Tj/fbThNHhXxl47m0r42dNIa6h/f4GaBipEqX4cfXyYt2T1x4t/mKNRbGIE5pSQ9vLfuwyvKRZoItHz1z0BJzWqMvifDdrk7u5ca+PlJv+seBXHg6010cyWv7zd9reuoufYrlR5NZyh7XSLOhJUdC+VjKMmerNN0KPr5Nr9zZ8TeiDamrqMUsNECTjljzCubDlxwFhRRdNHGvcHmZaAKd2YLbPkc7RJ1F2L18u5VOCWmssdsX3n37ZQrDKeE31vKqz+vRHviGfN9arssTEgbsf26BU9MVCJdFhVyEtxelxf6FCc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 778ff920-1f8f-4052-5c6a-08de3d148192
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 02:32:21.7028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6Muh0cLE4TRU4E3j5jefGmrqAC3Qp4yS2mJXdJTeGg5LF5ElC8/pkvTns5a7hL5pv+mu+3jHxDy5GmMa3K8cG1HA7FWwEnspNr349lnZG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=985 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170018
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=69421639 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=27XaW9MgylqmDH4Csz8A:9 a=MTAcVbZMd_8A:10 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: cccwA9c_snWLExq_eJ9Kozdfm0D1xj7t
X-Proofpoint-GUID: cccwA9c_snWLExq_eJ9Kozdfm0D1xj7t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAxOSBTYWx0ZWRfXyNdGMhIAKHV5
 c3Z/TtbNugLFzIzQuDNYiwbxodt9O/i+NTE9Ls5vjYupjK8GLwTNHFm3I65gPVxSmTTlHPhn38U
 xDgFrueTdLM+LlzSyjqaIYyPqCxzG2kgnKSYdzdiQzBlZoScOTC8/ron9DAisOF0CSFurTXwJFe
 aWnG7ZB+HtZ430SM9Xm3v7tEuEWkaGS8u0MdDy0qilUInCfejTcVQAsYZiD3RHyVA2VMrc2E3+h
 xXMLd9LJGrSgEKPEdCsQiNXAji/4icJiM0i+zqw4d7sxm8wMXSBAmsWS/ECciBk5qrtjwZGcTFo
 yY5lwiP0Km+nkTxQMP+0JMfAlcAsdHkoT7G6z0Ken1H0MJsJFnIJHmWztxbAi0oIv/NtMXlD230
 BpcljLQtV4/zPzOtf8QTGg25lI0LU7zAKheWcQbtKxpKyehmkO4=


Max,

> Don't claim that /dev/sr<N> device names for SCSI CD-ROM drives are
> deprecated and don't recommend /dev/scd<N> alternate names for them.

OK with me. I haven't seen /dev/scd in use for a very long time.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
