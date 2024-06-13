Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE42F134407;
	Thu, 13 Jun 2024 19:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718307653; cv=fail; b=IBAYXgdrU4+jVkrKXXlwIN/NDrb5l26305uR37ZoBjtwQYDF2ymRXiQ9BLb9b5mBj6d9n/vRiAEClV9f3gcDcisM3Nv8EyC0sRhdcvZ+gZwUn/wOSH3+gRn/cpVSWffqPr7EKErbs+vMtGHTu9MWHt6XWvcPGl+5bPOJg742y/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718307653; c=relaxed/simple;
	bh=VgWADvyLcp3v4ssE1jZeoIY5njJFptUzdaRCFFXrkPY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ByG+uWrHAeHNqN9WUI03Cpr1NIKzKYJmBUPUDWnBs001rW6Rt7PAGCTaFu/GkY6VapSfg+H31gni8TNUso4RyoIf5xNkOCmxC04evAH0WKmNmbW+7RZQ67de15V04DKx7x8yt6D32qPnNPIXGjsj3I1zh0L8A0brRGmaAvE3uM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S3Qd+CaZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vxec9NbN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S3Qd+CaZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vxec9NbN"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DEtPTZ000856;
	Thu, 13 Jun 2024 19:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=KsY8H8oAd++9DU
	9W2l7EjE3CvjFiYMqzyRdANQCU/4s=; b=S3Qd+CaZAF/U1wad6ZsL2nvBdBP0VI
	f/sqMYIZW+7moxTKoOX9JPjuLvoPm2Ni2rGZsNUFY2m5gOSI8CRsU41D5/r1nc5c
	qeS1b9sThMHwsk8Ruiwt/y7vmNjnEbD11SOkQXaf+kYMipHY6znEUyMSRhnyK0A2
	e+O7yz5a4KzCibTt+9oBylenlCtM30X24wTr2DmPjRmk1i65HAwhFpOA47HQbp0a
	cBGfsqDbxbDCZd0mCNeiGogNrcc1a8wIwvB5RlbC0t0rgYv//HubvcMAxbWkccRs
	WEKnzLwRGiKJmMLSVEDy6U6tzJrAfbeLt34Zpf1cHh1zR5HSqHTWDbkA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhajac5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 19:40:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45DJZGrl036490;
	Thu, 13 Jun 2024 19:40:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ynce0rebg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Jun 2024 19:40:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqH1jzO59W1bJL5UXCbKTzxZHh6TtxX3pT+ZW+WJ16Wbubp0rsLSZCF+KNfQTxE6pVP/xuQZbxT7taQDB4IoEk8dJJIMF5/uxW86KUJ1+8H+8GCDNBF7KBgJ8vVbAj9I4k45h1vEDvjOQAQWG6uaRopqZyqeAOvl1s9LRJFKozpIRg8FQSpzuLhMjJcSPiCwyjCyT3oDYyO4HxL2KJfU8/u2HE5e9pOeHECivKX6h9juw0NWZ3gXgW2kKSdZFRov5YgD5QnIkc9h3oizec1FsCUC6K7MPB0hw11H/QoyldKRqElet38rwqb+rYDfACTLhg2lKViEollm0OP2ppIxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsY8H8oAd++9DU9W2l7EjE3CvjFiYMqzyRdANQCU/4s=;
 b=keI1sLKoXF+rsylHtuT9ghP0TLlxNE2IkWblna9MdAUC123/5pGa4mtSY1eI5mJtBcAQPPcQfDbPyB4unek1DtmTfz2E8vrUoyozics3DeDyT91p7i7SkAMyEmLU7vEjDZ+Tk8JjRPxlKlZ+6etm8ss/JsC74tFh2VBkvd8GXD4SvyVLxZ5KLZVFAt8tfSo//Cf1JY1kFHGExr47j5rUx+HrYGWHtss8t10+dTUqHYMJDCpAl4vk9qGJMgtM9ROhHio872cNCGo1ELXOh3gFaOuzDHujPEOW07x/rgoN/dGIEwf6TSiUyx6cV+7WhasG9RmDhM5vU9kvFdNo7rtsgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsY8H8oAd++9DU9W2l7EjE3CvjFiYMqzyRdANQCU/4s=;
 b=vxec9NbNJ9pqH+Lkt5aaAxGGdfpEHEX/dtrdGICBELv/O/5GVsuOcbDi3s+KMvpNP659woBa03COHcg3pIezwNYONfuDxudRCGQiCJObN64zOZilKWh/RQIkCiAg5AefQsg93E+N/+SaWtL4ef3WkaArO1XpUluAaOR/aUy0s9M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA6PR10MB8136.namprd10.prod.outlook.com (2603:10b6:806:438::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Thu, 13 Jun
 2024 19:40:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7677.024; Thu, 13 Jun 2024
 19:40:36 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alan Stern
 <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, Joao Machado <jocrismachado@gmail.com>,
        Andy
 Shevchenko <andy.shevchenko@gmail.com>,
        Christian Heusel
 <christian@heusel.eu>, stable@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240612203735.4108690-3-bvanassche@acm.org> (Bart Van Assche's
	message of "Wed, 12 Jun 2024 13:37:33 -0700")
Organization: Oracle Corporation
Message-ID: <yq1frtgve5n.fsf@ca-mkp.ca.oracle.com>
References: <20240612203735.4108690-1-bvanassche@acm.org>
	<20240612203735.4108690-3-bvanassche@acm.org>
Date: Thu, 13 Jun 2024 15:40:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA6PR10MB8136:EE_
X-MS-Office365-Filtering-Correlation-Id: 0229fb75-d441-42c8-4c85-08dc8be0b237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|376009|1800799019|366011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?/RQeOosHgzXNpsWABZnxVcb/3xvg7+6djzwoE4SAa4wcNBXKlN+JAt3BaSPY?=
 =?us-ascii?Q?NNAFAO7I/O94Zodyk5cczW3hGofoG+RN61ewhQnPzmbSV65CY7gFf4vOJrCS?=
 =?us-ascii?Q?1IVxlD6rRGIj2KG2O7STWxz2v32AxMeVUYjUA6D+A1KIRgN+/NHN/6Ewvp7U?=
 =?us-ascii?Q?BEKH1ve7jOMB5XwqGZH8ZhZ4zuw9tss8FciwAXwnvHnB/RZgyUtv4yRyYmxk?=
 =?us-ascii?Q?eWvqvt4RLgaY6AJLvkMkxxytzl1qCS9L283FotjSTOCvunYt7AGP4EmEmYW4?=
 =?us-ascii?Q?Oa6pdqhKup0mZSjEUSobvEEJS2tUjemFq3RTm4oPrDfly6PKlNK4zWCnMWGB?=
 =?us-ascii?Q?MKGLeaYto8R3l9wB5eYMZNuSPrRAYnzLXkoUs9pU9PgB8JfBi2sR+RcEkYxn?=
 =?us-ascii?Q?pxNwNUgculC44C/CEm/r+FCYXLOe/tRhO3FrmhiwR0xMQelfq6ExGsBJSDKy?=
 =?us-ascii?Q?COvLdaBsV1HtYQTAri+vT7CvR1aw0I23RjwiENwVuJ8vguy/41bBnJVmDgVm?=
 =?us-ascii?Q?aSBkub1NTCrYTA5t9hUdequrdbCmaEAuQjsBMyJXhU4TK0kJEQv8Fd5Btml4?=
 =?us-ascii?Q?qlXBJMsPW8rtlhOsPCBiYAk1JRjqmU5BDIedr7JNWbDGf7X6VbLzderTis64?=
 =?us-ascii?Q?+5M9PhZf63jmyx6IiDLSjSxF2UuapG0IfkqXFltlbQ4pRU8lCiTWaopCHTSZ?=
 =?us-ascii?Q?FoBtcjGlNWK8nSkRLyUg/I2jAWP1hiiqq1Zq+UGRH6+niLssos0lDIRL6fQJ?=
 =?us-ascii?Q?jEj7Ric2gRVts+pR4eV8RIa3rw6Z7g0FgEjio33pvDgSN+f4dagAUHfs8p7R?=
 =?us-ascii?Q?uEPhbSEoiHosVFWgher3+lmeV9nvD9f8Rfyc6g1pHj2g6zY4XCxw0U/7b0ZM?=
 =?us-ascii?Q?2Xqe3hPYY8r4KDaBPIrxVBb1ZOG38jKgkEPH8XM9vu3AG740vj8cvyONhR9x?=
 =?us-ascii?Q?gErL3bQjgwRLd4WW1WRdwpoMA88jOhsY2Ja3utkxm/vPXqDDiX8GJU0iE3oT?=
 =?us-ascii?Q?i2lmvf00hS1xVDMPkU+vV+RZxt+A7QWHlUXCA9VgMOOgaPjJw3KInnihL8/E?=
 =?us-ascii?Q?56b0VfH9cxuPPO/mbLlgHcqGy8e5rFWM8s4zyDJbeZcVQi2Iatxb+hc+cq8P?=
 =?us-ascii?Q?rN5oAqWPeH3iVFUXRZFTmb7TqESYFrsLvUZF2JK+XMauFCB5EFYenm+Akbbs?=
 =?us-ascii?Q?ny5AOZU0AQAwEsPRzbhIhWsNt5OKRpCfoY+3j/5KKx1DJmC/uO42+zL61s3i?=
 =?us-ascii?Q?YC2UlurDLd24wzuyw+bneSvGnM22ny4K1QfQe5IH3PP/fZzAKq4dt1PztY5r?=
 =?us-ascii?Q?8zGwe8LNgsSqfG3Pb6OIJYsz?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(376009)(1800799019)(366011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Crw/pq4AaNvXT2nHtzrITaD8QUNTkinkSL+GwxGoD8UvKmhnZ6VdbXbrudgd?=
 =?us-ascii?Q?+U3DXwZg3m9NKcC1PTiLaOxd2kEU/BjtAXZioD8X1J1kdJgT7nZfFvpAMKaq?=
 =?us-ascii?Q?X7xUaABhScCFB6AeIqhzhqOs/4BMIyCqpY03c2I3J9PwGIDOWJl7f1MWFehs?=
 =?us-ascii?Q?M6qxXor3Lb5oYMx/7Oc3WavA0yTEDCWhqQWGrMjkDlLmMBC3s5DNnHHvLgNn?=
 =?us-ascii?Q?AZ8H5/J/t9Gt5nx/QuO6J36NcYClZskRupuxjds/Vg+P/0wex6tboSZD12r7?=
 =?us-ascii?Q?ZRH2vQRBb5ASM1vi9FJQ9lA1jkziiAeuVIGqXDjPuSdalioPk95acKVehaV1?=
 =?us-ascii?Q?ii7TlsmIqpc0Sl/GhIDsfNZY1SB+59lKhUYQrfMjWrP/pA7fO7LWFMdoYYKg?=
 =?us-ascii?Q?JWp8p88Ce04jN0firGRHlGJjkw+Ext9NVUZNCAow4ARaVT2ypSb56QDUqfAo?=
 =?us-ascii?Q?AI6C+JaKfLaMzU7l+8PLCIHApQN3/YUA5JM+mr4ujKHpObXesekMkOVDZTuX?=
 =?us-ascii?Q?fItzVeWEo0gv7VJkKS8XqOvgdFfsBgBKk83H96UalEFcUGLeTLbWojfLJz7b?=
 =?us-ascii?Q?OdKNt0rFbA93zEjaV1iZRJwVLGoNiMs4+NzomDQJrSNChBGvpRVPZsUX7xCJ?=
 =?us-ascii?Q?Q7IcVnt+WuDhfP2huKy2bzKTbENR3tRezAxD87TMouSBMkcXrKNVoa9ZhKes?=
 =?us-ascii?Q?k8fuazQnfcr0w/ZUzObMflz+MqKqa0J8AGAs5rcpBnqm9uNVuF15zaUCtnPL?=
 =?us-ascii?Q?r/CAS4AtriHW2chpG38ygYGrXASAIC9R+BUWWfrTUGvTxOSN47Hz9qd8HFTT?=
 =?us-ascii?Q?hci8vkXnju4r/Qy6+ObQoT5bw3xoiFwVkjlxe067724A/IxeaNiIqHvT2+XN?=
 =?us-ascii?Q?4yM/hmkwgp+P9bKNU6ioS67BbWHNpczgA5aZNjmDf1MImqScUuN3fMYBmqNX?=
 =?us-ascii?Q?3Zx/6vMzX+OXbtDS/cksSaleOreKwussC3+5MS6nMSBvVugNMe+njFkMrvE+?=
 =?us-ascii?Q?naPwXxdyUsqk+fQHzMePjLlzjiDsCjR5DnWqlCFtWjTrB3k5bG9VErqdI53w?=
 =?us-ascii?Q?SExL4hJRvg5efyj/4ypboIoGxpDvyHs7NAbYAYgUAB5cr0mu7Sm9R37oZkPH?=
 =?us-ascii?Q?lsK3L8FRyVhUu1vbVHG4cy/KG/+tsa/jfyEGEFycaQ/DFAI1cOFktQYVag3H?=
 =?us-ascii?Q?DdqA/Ee6AlXbS0/hJHiuoS39S1AKPm/A+mxi3apIoOxRBj0avMJ5mbJ8lU1v?=
 =?us-ascii?Q?mjojDF/eUqykR+2AZK0+dFfUGgqq5VJzILig86A/y8ZbcjHzcGXNSaIiB8QN?=
 =?us-ascii?Q?5wVotdX/+KWP5BktdgJpY2H0OsLy0Vps9DC7fnMcJOTNkJpKHLyzp832ceRq?=
 =?us-ascii?Q?zaNyYXMhY1U8TsZ9C/pll80x+mfVr8T6eyQcTCAZipf5Pr1019SpGiMKfZhq?=
 =?us-ascii?Q?W5xyIQ3vj6AsyfFFuI8T5oYivnZCF8FIzBmcV7LuqOTuHpwBQRWtuj26EmqS?=
 =?us-ascii?Q?RhIc1YG4fqqVCi9ptfCweVduddKijcpGPWF/RJQO33dErE1C3QEkdrry3kbm?=
 =?us-ascii?Q?S3Nqrf1ciWOzdVkZWyPQ6/xbHyKDPUMhv4jd2mNKrb7YIJcFJ40Jm4a3IZgL?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ztaU0BZSKYn/LM8bn+n/85ydAybiMnPLKzKS3UGpiQdYOhXzWZcqd2i0/WW31vnCCecAq4m0QqN9SXY3rl2N2ZnOrTBMW9hNwbrwBjVvupSnzdlbNqHlG5uJk/hvgYfEfJp0puFb4YicKU0SW5x/JumxvYU+wyxtn7xuuVpbVvKM82OTWIfsCJJ3vz7RKw70ZS2vgPWglg4bk8gR/cx0XBuBKT+GRViq1HW+XMXrVy2GYi8/5HLIS/gO8wFx8aZaX2AwLBflqTtct8Sl9C5q+fsg//gdFdlscF4mNXlsZBxRM61E9DGIk/fa8yftaaQBtEdjXpLIc2i0gGs7VGGyvrHCv40827fc+wnOwOEMZtRPC17/+stx8oZpu+AtV6zCvwn6TTXhV8fGA5jS2LVd+oe5ndl++zdDst1e0nOdg4VOxA0xnAdRtTHHSlNtb7G9QrPNTrsY29b0HF1cSS/vmP0uw3EiS8Tv5e2xEevrCMD03J4uz9BeeiwZXfIOJ4BZ5piVeuIGjwoa3oRNaDTXxVDX1W06OsxLKi7c2N/tU4uqz1vTlr1+XWII3+arASUsvdKgEYmNgK6e1q1/K5dnkKTfJBq+GuhDBlfF+mTuQqM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0229fb75-d441-42c8-4c85-08dc8be0b237
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 19:40:36.0942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9+g4eD2zlNVo+XCC1r2Y5OLUogk3qCogl3hAJZdYjuVwtuE0Qc3gRt4MKFNhQpmH8PsH6PIaacYEQPS/NmeXQT651ZYqJZhwcfvVLa7VH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_12,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406130140
X-Proofpoint-GUID: OYqE9KErw0CgA6JMlJb-51sJ6ftPvgL1
X-Proofpoint-ORIG-GUID: OYqE9KErw0CgA6JMlJb-51sJ6ftPvgL1


Hi Bart!

> Prepare for skipping reading the IO hints VPD page for USB storage
                                   ^^^^^^^^^^^^^^^^^
[...]
> @@ -3117,6 +3118,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
>  	struct scsi_mode_data data;
>  	int res;
>  
> +	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
> +		return;
> +
>  	res = scsi_mode_sense(sdp, /*dbd=*/0x8, /*modepage=*/0x0a,
>  			      /*subpage=*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
>  			      sdkp->max_retries, &data, &sshdr);
              ^^^^^^^^^^^^^^^

s/IO hints VPD page/IO Advice Hints Grouping mode page/g

?

PS. I'm not fussy about Cc. But I generally avoid listing anybody who
will be automatically copied by virtue of any *-by: tags.

I tend to use Cc as an indicator that this entity needs to act upon the
patch in question. Ack, review, test, respond to comments, or merge in
case of stable@.

If a person listed in Cc subsequently responds with a tag, their name
may be listed more than once in the commit description. But I view that
as documentation that the person whose feedback was requested actually
responded. That's useful information as far as I'm concerned...

-- 
Martin K. Petersen	Oracle Linux Engineering
