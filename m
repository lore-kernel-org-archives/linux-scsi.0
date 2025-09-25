Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C601C8631;
	Thu, 25 Sep 2025 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758763938; cv=fail; b=mGdntVjg6Yp7QL2FjYl11Sd45JyJ6m4oo8gDDgp/vFcQdbOWTfOOeG6sdTCvJJtoiUIU9NhpHWER/MJJz+BoCCzR7MxHKesbNIifRQLEvufI2Mu6DyHM+1fnmvU1qFFEbCKaDUv3rB+VutpB4uhByVSo/H9tsUdQpNfxihusG2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758763938; c=relaxed/simple;
	bh=QgLmlarDflQlPn/1bzaUoRF2pQ8+XRE0qhdveZ6bUbc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=qWl6rnfPYJKJ9xJlmtX5/VzxYyoSMIuL/vBtvWve0YEWRfIloxdGe0CLpXt3s18LcFHBqHT/i2tw/VIfaPj94blD0kOTh3zqe2po0UfkUQGN0sgpBRbqUjecLl8Wiw0xB5eRSVvgLNGv1nKfoLE9iCHxJWVhgmpDSeP3ePbj/UE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G63wn9Po; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GLmBfMuD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G63wn9Po";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GLmBfMuD"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OItwno007210;
	Thu, 25 Sep 2025 01:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=P4ByQQFwHKpVIjm4Gk
	Ma/4/5JiPOQ1dQCRs4Jpq7HAI=; b=G63wn9PomBuH2E5NfYfaij5xvZQUlmYvl1
	n7qPKSzlnmTszW1Ygk40EHsG5eF88TbcUEzd1KUZ4kPDyLPFnjeGYfN/bcIvdDo/
	5F+OywbTJ6lyZRMyUmYCs44HVbQmo/8fPGAgMNDAda9CWGedr2eUHeZVabEQAZaz
	IQ91+aqiD2P2NzaX6z2+l1DporK0nvemmpmc3qNzsJmmFuThKJeHfjfVloU5/Ax9
	iI7feqqbPITieYpbI3e6GS6FQMPRbRNaYen/awiS9jKC7iip8SwCLnEwq4yRyMfb
	8rN0agYBfnuVNH0O66dBJL1/bfOepe8Nv/HMCq1DkiMEE/Pmcmfw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mtt90e3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:32:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P0JvW7040889;
	Thu, 25 Sep 2025 01:32:04 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013060.outbound.protection.outlook.com [40.93.196.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqabh8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 01:32:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8coB865HBXWb4yopER/cgytjg30CL63OosDrV1EkMVhDx4z53TcskGqfaSwwfjOw9aheCZO9VR/QuP6qoSiwzAvDL2JDgvgohcgUmY/E+fqFW6upF0Rf5sbIrHFY6RUQGg5KbPh6dcH9hSzNHYSjIW01qkLu43BJBmBSn1FgIT8vx1nppoKNjlFUyti1vfzwdRhwPSkVrx7JQIjz3NCoU5bbBKPYtRj1l9XNoITs1DeWxzg8trqHhYl2RaqPP2A4I8yJ/7iwD/4StARhf0beR/sngVDP5KO+DaY4BFxZeAQ/faIcH013IKvcKhkBrKJxIfJ1krGVMpTOCmq/6EyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4ByQQFwHKpVIjm4GkMa/4/5JiPOQ1dQCRs4Jpq7HAI=;
 b=gf7buWFXRwhsHbcjGxyuVD4DmrAcYSfvjQjBKkaIFy0O9ZMOwVPErz+pCaq5RkFmOCGpKuKtXjbZVjKXeS7Km1ioOILqQoHWbIiAoMznVMSsjmfY7IDDFR2DSzFtKhBSnwCW6mEHOtn4qUrz6detBPqx2fo+1c2HFsZ2aBWHZIMrR/sXApu+/k7Iu7otl351B7CMZK+kp0UFmHpv6nKD8Tg2y709vdMIDYTOaqCyiVNi21B/fVkEMFIYtyYrKeBAVSC2k+cObJ0uKztPoP+ed9lcgANhVW+DONaEsXRbAt0TcLWR0jvOXFShgcPShAwuZ7aZ4Trejidagz79koS9TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4ByQQFwHKpVIjm4GkMa/4/5JiPOQ1dQCRs4Jpq7HAI=;
 b=GLmBfMuD0ka8uYbNHwL/n1HQCZ0ps5DtoAN4n2eSEWSMAsvkDEUr+5TyQDPN8uGBU+Ve7r882lMQMcf9yZ9Qh5zBK6gtLMkBSGoUzfqYF+qKT3OQq/LrmONigqjQi5dG/CSaFs+WJzfvOu0beB05ylLeziM7vkGn8ImODZUnNgE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BL3PR10MB6185.namprd10.prod.outlook.com (2603:10b6:208:3bc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Thu, 25 Sep
 2025 01:31:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 01:31:58 +0000
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Replace kmalloc + copy_from_user with
 memdup_user
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250922201832.1697874-2-thorsten.blum@linux.dev> (Thorsten
	Blum's message of "Mon, 22 Sep 2025 22:18:33 +0200")
Organization: Oracle Corporation
Message-ID: <yq1h5wrs4fz.fsf@ca-mkp.ca.oracle.com>
References: <20250922201832.1697874-2-thorsten.blum@linux.dev>
Date: Wed, 24 Sep 2025 21:31:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0072.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::49) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BL3PR10MB6185:EE_
X-MS-Office365-Filtering-Correlation-Id: e5712384-b5b9-4b51-10e2-08ddfbd35198
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pGmOmxWIaeVJcH+VAVexEfwkMopUx2U4lr8m1VmtKzsVBut93XX02JlXW3Mv?=
 =?us-ascii?Q?5ttj24fa11JaS7STriH1VSt/+szW3KmXTqUbn5L14TyehKbJ45DgmPRizE/u?=
 =?us-ascii?Q?75OyrdcY/ZsTNegng3abxQ67x4WSrwfhXzLerGDaJLAIRkCDh4w6Kus0kScD?=
 =?us-ascii?Q?CBoJpQ82R2zQBA2eS2OqtOZG2OIu5jPFWDRYe3LE6RhnxkvIN4vhA5H6e2Mn?=
 =?us-ascii?Q?ElzEfYIV3bce52pRlpzZjI/qokcakc9AR1WCUaFDA4URp/7iNCf1y9wDLPod?=
 =?us-ascii?Q?eCGy4jP7hJF8PsJLRxZoDJWzjgTCm7q2ZTgSM+ai9iY+z2l5BJX8d/jpVbcy?=
 =?us-ascii?Q?7rbWTG+B3NwoA5oHKS6PmWVmc2AYgroBboyhBRAR7eR+aZeW5W96pdTbRECp?=
 =?us-ascii?Q?cXieHzRujSXXROcZGUVW0Yq3onzDLWYTBbZMjWjVveSZMPTr3/+K/yyL0dJ7?=
 =?us-ascii?Q?jpO6PCzFzS4ko5HxYc4+K73l3tFM50I6nJJ/WII5DZUFO9EyQ8Qqis+KO0rm?=
 =?us-ascii?Q?gH6BumGQNV6MI0q74rnWqtYPawUgBju3H1itNV0TAnmtrRjCLqy+c7MqaVfh?=
 =?us-ascii?Q?B5p4StzB4Mk8e5MemBLodkjw7fTnkONqOwf/t2goVG5yeZHADzWhMD5U/P49?=
 =?us-ascii?Q?xSZ2mP/kHNa8Qoips4GO37GSMnZrBMaFw64d6gRlAwBTXnDpike/uEJavwu2?=
 =?us-ascii?Q?1jKJ8DNAF+qpAVV/F/VMPcKNNtOqK4tPaOpDoFE0yLN3L7SVQZEi9jHF3l1h?=
 =?us-ascii?Q?kBzu6GddxCSI2OiwdrlPnKqWlelPpUAI4o+GxLsB0w7JGtTAcLe1BvEaNnhS?=
 =?us-ascii?Q?iNM6qF1lwfBQ6TV2EovI8xsLruRg2CLprOc6+whyDRVnFSK3ccG4W3KRvZR4?=
 =?us-ascii?Q?7HxlSDHenTx4qkqSd0WYChnVfGlem0FRLXF+ejakTAkxVOvBg4iDzUcDXxbx?=
 =?us-ascii?Q?zSV/MAHsSQ5l8tn0s0g3e/R3mAKQx/t3zVtN+DukTfjZwqHCZmNNsTJaRRW8?=
 =?us-ascii?Q?9puMVm2iYvF2QbaE33GjtzdE0h6nAg760Fx9DuraymqB6rfHkgEUAQ21HTv4?=
 =?us-ascii?Q?Kw66uLag1mufVn7eSFpMG14VMyv0ha9R8y5b33mYGQXFkyoLZzxTDv9ul4hW?=
 =?us-ascii?Q?fCwMM+0Ui1xlhN8hk/fpkNrFxKmThpzTpvvEOluJBqJuZ5NyzEAjM0CvR9Rt?=
 =?us-ascii?Q?1U0+ED9I40Qnn/LRemWEsXI2FFTxR27EvD5QGlXgn5q8+QmXNh4UAQ6x47ll?=
 =?us-ascii?Q?F7/J3fRBidaePm2qVY07zIRQMbQJE50bzwAAVLBppnNmXqMdHN4a17QLwLU3?=
 =?us-ascii?Q?/tiAXpZYvzzaUVU31eSlDQkfn5JALupD2PgvyGauPBUub+YfzsatBkfw68Kt?=
 =?us-ascii?Q?akzZAPLentJe2I8NSnKSL6dGnyX5lINVS/q7Se5UWNCcaI+sYXP6UVEutBzX?=
 =?us-ascii?Q?HnhVzliyHTM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hk065wM9AyV3KlFqoop4c8yyageDVrl6bdBP6GGaks1a/DvC4/wZt5hiZ1Lb?=
 =?us-ascii?Q?NQB6FORNYuDPYb5E0O2cIi4Jg81BDPeLFRv0O0lBBVrt1/udPCPhuTP85OYJ?=
 =?us-ascii?Q?NIfbFfjo37owygPW4WBZ972G8TQ/sTMG9h2U/ePnJPlPkrZgWfx0od3UHPFs?=
 =?us-ascii?Q?K+8TLtULt3W20eZLWp8YT1PgyWVwZpue0zBz2mDK0JHWTo67NeA+HZAK2VA+?=
 =?us-ascii?Q?N1rtkmLh7jsClNMnuBSK4Q4nRH47VacrOVW1qj8TTvw1av0qSW64I/yPC9tD?=
 =?us-ascii?Q?knovATj2ZY9CTyg53xKgbEXPKynMCf6Vj6lTzJMMQHtSj0lAXIZCCdxBwADL?=
 =?us-ascii?Q?QFLKMHz4cFiSAq71eHoERP/rcX3LldlsFo5yKhNNvqqDO0reBPDKzY9T+BQZ?=
 =?us-ascii?Q?KRL+fHFfVL31np9ufjPY33TV0ay42EUXLlQU2izNXr6A4guL2dCpLsqexYLk?=
 =?us-ascii?Q?4Pu8cDrvhB99MkD70k4wUN9mBqcRZoSwIxGhR6xLj0gEstQ0wfxjcRpQpgx3?=
 =?us-ascii?Q?5wm/2kF05UXMb3l0LFat0JCQ4Y++dBCQMk3CfZ2M5hMLh6k97Ma1mvL0WyMk?=
 =?us-ascii?Q?H8h4AXNTaWpvS8SmqlwDN/lVBvwCzWNZoouEQPTO+UI0gDJOKw/oRkuGhBmb?=
 =?us-ascii?Q?fP3SaWbuZEXRt7NY5ER21pT0dmF26wt27fwvIgHKWaW+gvlOcx+IdCAxOEdY?=
 =?us-ascii?Q?T2C7Bo/CLabU+VqhEyGeSRuUJykyL1c1JuFoB+CaYuyMboh78sqTgPattRU4?=
 =?us-ascii?Q?5BUpC1jXMg+833fzKWRuANdcu2Th0pVt/4WlOoEJ4nvMK6JrqvgNGQXBTiqI?=
 =?us-ascii?Q?YQQ3HWSrxmfCO1H6Fq5MS+MHvUXFGTvAENgMadKnbHGqHU9+EX1OZiU9m/4X?=
 =?us-ascii?Q?13SwnkwwoFe7xPj8PbMAJ4mL299fTJNpX69GcA2u35R3KmO6YUlLr2SK2Rs+?=
 =?us-ascii?Q?PCnhNQ5M395qBM6nRAnNogHDplhA3ur2Su7WAn6qMFzXjfTEbg8rvHlrlohN?=
 =?us-ascii?Q?pk8uj8gWKO1X2bxt9KhM9sn4Hxl6R2qRCWMahubIrhgE25sUCLHlM54vwVmb?=
 =?us-ascii?Q?Mc2BWCIBl5UKItDxGytmwY6IpQCJTLxMamhPh3iJfLkGjw/WYS5by7rciMeW?=
 =?us-ascii?Q?4obVViq0DVEmSracPxDe8Yp4cO5h/2zXTyy4oJpBkIcJrk/9T5DxNMGCKTto?=
 =?us-ascii?Q?Sh+mmF7pXqi3jIZLg/I3qPgKnl7rfD63gVHX9p/SBAjUKDI7i4btHyIRQNPM?=
 =?us-ascii?Q?knrfSgi1arNA5d8iXlDe1hCOGiN3roOrfctIUofv54ZvfrW6gUcbypfqmKxi?=
 =?us-ascii?Q?+qsP73EKNgBHsIvC07mQMi3SDjhpqMrjSQx4FmK4gADRNrWij3v9gjaEPSM1?=
 =?us-ascii?Q?8qSfV4sdwQmRA9+WNbbGwWxKApSDgU4hLr1El+DPIJUw/3opMF5sW0CYCegz?=
 =?us-ascii?Q?I4EsIBPXx9g979ZGzvcO3XS7sl9Y8lnRS9eREVuLvJTOsqjbtaYDI6brUWWC?=
 =?us-ascii?Q?hzfOUDnwl+1X34tYvWKRFPW5gxjE0cpqgRK62QAt+RUnoWAi9MXx+BJD925N?=
 =?us-ascii?Q?Vd1fdFwWYI0fihwyddk3/Kw8PPgC8lupJgl76FAwSdh3uv4VafrC/x14onCP?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aqUT0RnIppHddW2scZ4ajqWiSZicM/uWXQMhXZxLSZj/u/FCMZVhyJR5OWJB5/cdvF2MItwcUXmSWZlY3nX8ACJbqaI4mCHsBWe+0jAuOR8bEuUzZiu1XF5NDGAv+kH7UMnTgiQLoeM2SndzsTiO/1dz2/ZSqietSM2jW0x2aGYYKe6sNqns825ijMOypbx/O8VeEZ6opusGmdapdQpP3D8i80iGQNn72ZXV5krSJioBX/LY/YrpdevLebIEEfuLtJw6zxEhSdbqnqiC98T/S0iNyW527vFqKmB0zVnHCxJSfVkci47SR+4pNA+Qjo72qDDczpzQSv8OBCdFyFfznYCgOFJHv2IrNmwB6waevam/Zlg6HxRcJAwbvEp/4m2vs7dgj4WojjtcBwMgK+uRp5lGSy5KsmdWfcX7PYsp8rh0JtqUKze634hcEiaoEEFlNbwObDbSdoEd8xblyILe31tYrwNIo4WG4D2Uuu+emeexEdcIE5h4tRbjbFEBnAPmjAc056QCDmPUUIUDaxVEKHbqLdTilGj3bdR2PYeN36Mbx8vs6pFtkjSZc6yutm/VuxIMPJW2Vzt0Ghly1j7Q3vaRKRJO6SPdT0Fjh/2hKPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5712384-b5b9-4b51-10e2-08ddfbd35198
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 01:31:58.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RuEBNVsaCdDeKceQ7GLb8aSW0hK7EKtDrDnHYn3jgXtXmKGABAn5ncsoY0OPiEOm2j89iBhO6DMwV52F0IFb4vD/yovamHUGPcuRMmBK7So=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=873 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250012
X-Authority-Analysis: v=2.4 cv=fd2ty1QF c=1 sm=1 tr=0 ts=68d49b95 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-ORIG-GUID: Z0KniDWBSw-Vynp1boFeV1CnqWM6jSBi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNCBTYWx0ZWRfX7/TcHG8vggGh
 LN9MkKKrvuS6sv5vppARC32ulXDUotGPfC+luX3wgcU0ejeqTj/TUxYQfHfsQlM0lhrMLR1kv2o
 YqirQAwAchzgO3Xb8p9o3X3r6mZ9/h7Zabazo6xLGOzy0CEgtCmGCqz4SSepFwYh0egsPGS3l8Q
 PyhbeCRQZbCLv19S815Qg0qv+ff1qGbt6giLDPOhH+ec+j9B2jJPHmo2bvfGZO671U62dtzNNcy
 7Yzjddip5juXrg659f/WkqXgUbZiCysrXx9qvGRsd7F7HuA94kRH+PuM/kW/HtjSFaZOtFZwLXk
 MTRhG/a9qI5ulUsid1A5zOf9ged5t2ctCFSNoFOwz0q266fhoCjaA/JsnKBrJgAHNKqJsIcSi4K
 sCp1U4aB
X-Proofpoint-GUID: Z0KniDWBSw-Vynp1boFeV1CnqWM6jSBi


Thorsten,

> Replace kmalloc() followed by copy_from_user() with memdup_user() to
> simplify and improve pqi_passthru_ioctl().
>
> Since memdup_user() already allocates memory, use kzalloc() in the
> else branch instead of manually zeroing 'kernel_buffer' using
> memset(0).
>
> Return early if an error occurs. No functional changes intended.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
