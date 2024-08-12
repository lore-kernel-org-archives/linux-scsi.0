Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E7B18953F;
	Mon, 12 Aug 2024 22:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723501052; cv=fail; b=YltwV1fhcQbGqjCzvJjtV4859jZArQ/pXlnFuRx997xXlzdUjFOCXMUHGm0eHEAOoxY4Vw3F58eYQ0nenLhYkXO4szT9FHLeCVFcgXZ6tiBIc1JzDz2h50yynXUuMNAuhS83BnH0rvzm+UV1L+PluuxrFAwU9F81GkhYAwkCE5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723501052; c=relaxed/simple;
	bh=UAxZ/Ms4hGQdZGqlOMic3yfBmDVgsxAWrGdFPJvrOB8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=XxqfyZxYI3ni5JVnk3zcxVyiC3Qnr2tRgHdVNHdkupIVOwQljetEYjIdaTLLt4pwGJ2X9ocZ+4DtSgNNCoX6IstvBo7zkYWOOGzq3aQlBJGhuAG3cIRuH9vQnorinrpNs7l3E12CCtRfMnehtsal+UXghX9C3Qq95WVMKKuXroE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QzHCiVh2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GlclS++X; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QzHCiVh2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GlclS++X"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7Kul030958;
	Mon, 12 Aug 2024 22:17:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=roVYq7FISukD9I
	xJIVyL1nvmRlgGT5qX6EC+wyr2rKU=; b=QzHCiVh2v3O1mkaFpefW1IJNccWkV4
	DECy19uymdVBGUCSeeqtLEGkAr0vHNbjgi6lNuLmaxPpw/aaKSqrRxoqBWdbrEn8
	xyzoRiF1Ckt/SsAK+zPnXfPn4gqU1W3AibhXj9+5SJspB+zgWALzraxheYKOMFv4
	/dxfseYX02v0UuYKMH7GMuebrJO3qYb/KWVqA+bGNHTis2Ppc84Hv8D1aNJ7l8SG
	IQ/D9rhwZQvy4KJ3tKOJj8sSqYeBw3EMnfQ203aKdulGC4t9nuuDCgPuviK7x3of
	uT8A0nFYbo86zJhLxERMeBclqEF/Zj5pXnh+3j12blUMzCPdoEZfiA5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmcvmc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:17:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CKTqcC003335;
	Mon, 12 Aug 2024 22:17:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7qjkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:17:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ximMuKViJx3MwhtNhmrCuiFPa+GDJzCJI8cOmXsHS5yNW7ygQVEye9a5tvXMfrdFdkXvlGiyg24cCTfBgzoayJe+UyEm4YHRuUh9IF1d1KaGjyRpW427MC1BapX+I/lpNy0HmQ2aX8nrCJ+lN1oCSc/3cuC/ntH+/ohT8XZ9lDtHEV/uSL6fJtqqqex5PDlP51Hi/rwH61YsCt6DUDx3DBMO9bIyyTGzApxUYNI2cmKVFgRS8vxL+NZ+A9HTpWAAov08QqfHq1yl+EneWRKy9uMwU+863JPx5UONfHomx8zLGNUq+J0aAot41EHFLtjz4LuPmLcpbXAwFuDRrO8Gcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roVYq7FISukD9IxJIVyL1nvmRlgGT5qX6EC+wyr2rKU=;
 b=u7SJUbluGTopHSWCCcVv1rUB4NGR9lc5ArdPVyAjFgQd0JC3dwV6g29unIgAp54PkJhPDRciI7qMV7EkWHi6hz6KcfteRNKdJgNsttbAYHRSoJddnfx2hvX4E52PHEsL2g7MNUT+hwdzH039pqW9EFKU3rmavXZ0FkvEBdP4EjMMxd6PXpYQe7Ew5pGEVK9KOOprIOLGwWW4b1SLTri2bu2JJve6zxG7dgyZ/cg2ziEh2hvVoc887OtIRS+8N4Apy/0IVlv9Y2vX0WoiN2I1BKOs9d3R0OL4A/00qna821qk4zummJQq9/CldDusdaMoTy4nuihUTU2k+OCbiURsHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roVYq7FISukD9IxJIVyL1nvmRlgGT5qX6EC+wyr2rKU=;
 b=GlclS++X7jSsC2wHrLYU57hdZIv2GGWOQJ5e5qKutnG1NmIgMRvtKj28zyRFSxe60I8BmETB+O62/zj9JrpEIFuWDaUh9MsjKjSzZRh+5W7GhASVLXHfevGOdYibzYriOzzthfqP7yO2iStejxAoUnmrfd57WpS7DjvG31tL2JQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7807.namprd10.prod.outlook.com (2603:10b6:610:1bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Mon, 12 Aug
 2024 22:17:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Mon, 12 Aug 2024
 22:17:16 +0000
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use of_property_present()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240808170644.1436991-1-robh@kernel.org> (Rob Herring's message
	of "Thu, 8 Aug 2024 11:06:44 -0600")
Organization: Oracle Corporation
Message-ID: <yq134n9z8s4.fsf@ca-mkp.ca.oracle.com>
References: <20240808170644.1436991-1-robh@kernel.org>
Date: Mon, 12 Aug 2024 18:17:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:408:e9::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7807:EE_
X-MS-Office365-Filtering-Correlation-Id: 435f21ba-2c72-4abe-3f13-08dcbb1c8652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0QQWUWqjky6Y6aJpEuzqb2hRt6eyfJnqDxvVOCI61ZPHAHTqhWH1eKz8bucF?=
 =?us-ascii?Q?yDUFEOGRzvLCLKTHjQURN+UFBamHzbbx+dmJ2Cj6gdOgge+P0SARxbR4ecvf?=
 =?us-ascii?Q?NhRKmm4lDrMu9P5HmsUk2/EicgSWG2IMtU483wli30YHeElZ/otgc70dQ3nV?=
 =?us-ascii?Q?/pjyb2FD2pZyytTbzpMe2S7Ev4QgwIQPYKQnGrvEx145373t1DeKXfB2rRvV?=
 =?us-ascii?Q?eOiHd7yPn5+hHP6L3np8W0MdX3zAroXzj7I5JMKV/cFU46cOYNb2gcNUk7Ux?=
 =?us-ascii?Q?1NInm4IpZzjwa27oe8n9snm4W+zS205tk4cZGGvuDElg5ev1QGqgu84Lc96+?=
 =?us-ascii?Q?i0wsRqmMlJuvHe5o2NGqM7bHpdW+OKJ1fqouh0nIOIdMYmLmUuFnGt2rwfaD?=
 =?us-ascii?Q?z50Yd+tZfZ0LmdmVk4Zkkn8Z6Z1CIB6WsKaGM6Vhvwu+pN1gJHzack8eMMGY?=
 =?us-ascii?Q?uUAtHrh5UHjeukTKXdodLDriFa673NbXgpAfk+vNUtqDF0hcYopazGu0BLNu?=
 =?us-ascii?Q?wkBDf0O2gPymbFIJn5pacfNMr0kvlS3tZH6g6UzRmvBSeBZbeZWJufrVFe/A?=
 =?us-ascii?Q?+D2q/hgN2hvASpSimZn6PgqA6fI9UDnXhDUbsA5AcEAfK0hB6+HR9gd+6iuP?=
 =?us-ascii?Q?1YeQ4wqU9/EAuAWY6LDLpEzr2NQ6jqkNrsxreiGYbgtt2yVosHnAgI3dL2FH?=
 =?us-ascii?Q?XZO+XDv14VDl3EE4Au04cPKy17wC4cKJcCzrTXB//iYEMHWmxf7NTltw22tT?=
 =?us-ascii?Q?M4Wbqhk9SN2yK5b5MMCIAUqNG3Mx6iDWgnEEwdGthsrrmpngUVHBm2M3YyIz?=
 =?us-ascii?Q?hmnI/SMGmfBczHEDvOXLaKxUj62YtxZA0XI5XXEDMcJ1AFm9eAWylZp7mubR?=
 =?us-ascii?Q?GrteczyqtXJVRPOu9fvtUyY8Hx5eLtJvpDtCwSpZZJWGOT9p7CwYqLNjMC08?=
 =?us-ascii?Q?VFKaoPJ/ehlwUOv4hSSZ6Uor2SYm3XavXndj8ElCawL/CzRIurTbcCj5jvqK?=
 =?us-ascii?Q?0wMCS6UgYxYe7HcabtO6Iql0jNoNdG5NX218HKmttYiyEOXpVXbEFdBkVFOe?=
 =?us-ascii?Q?KVHKHtHIPBmWrGt8pwOKz3nW7CBKph0di0LUbm8+66oRk4u+TOydjV/p0F03?=
 =?us-ascii?Q?sNtqZ5W/yZJyBRWkWFW73TGvF/Bmgppp0tm7wpgmH352AHe7kgDQCSxpGHNN?=
 =?us-ascii?Q?vm0rE2qiDfcR5ZlDCQyNRZ3EVXHluMN6J9RoM2TFJl4ppSuEGjVDpDUi6O1j?=
 =?us-ascii?Q?uN+OPMjv/ogjhqbqLfX4NQIVD/QFRIqtVEj4xyJmLfLpybGTS4AWOiypU8KH?=
 =?us-ascii?Q?30yogwTWkZl8G6gXg1D7D+vkGptPsqxwWcXWxfs1l1+tVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TEdf39YYPr9HcEhpagPd87NH5ivdlI3s/0Rbju/2vkKAqsP+kZ5zEGq0ITND?=
 =?us-ascii?Q?D5/66UA4F2i3QywVIog77ixY7FyKHSpYnORPKaCmYcK7YB8kSYHM6G+bbVvG?=
 =?us-ascii?Q?odAc8LUD1E+sqR/mnOQSQ+OxpmzpOHslG9MTdfIIUyW6VR97OIpTQsg2jaqP?=
 =?us-ascii?Q?wYVyYBqpW4+LH7SxT4UbkpVhcoXmlIzmKOHeNTtslHxpI7PO1oNWzihXvT85?=
 =?us-ascii?Q?AFgdnQOv0pu3LrxWehEY91saB52lS8fD1oYN/5+2nWCAXJU2SfdRT2RhX2+/?=
 =?us-ascii?Q?9lX5LCYaCp8OMBj9Eq/KAftqkS4cuAsqy/Ov3TP+17yIAlONJN+jbIdZskiK?=
 =?us-ascii?Q?C3DaHqRDCZzuZwu1lhvRL4I0jhpMMbdIS7xb/xpCAl9M3GHR6sa46ygnFWbR?=
 =?us-ascii?Q?YZBfPGrViKD9gB5M6zOcj9o/0kM7qLwhHplZmiyPwMa7PlRieuFAmOqeznv7?=
 =?us-ascii?Q?pH6xhgR+S7DxklLMW9hthxO9iuEwxusmvAt3cQ9459lnJqe2DkmnJWNp+gK+?=
 =?us-ascii?Q?4smZ86iyBUfEK3/COsq2U4TbEv90sa0RXgAseYNwdMd4DulVLo+ZmEWXQIfI?=
 =?us-ascii?Q?dppkAgPnGaOpnYlGJ4nuz0oQ+j+L7AKetoGeyr/smubqp9cFaOrlSIm70sHw?=
 =?us-ascii?Q?JUw0+GcH1jKEwniLv7khIhtkTU1p66eLx23BNPhGx0eTq9XuQ1L+sLF6RzgJ?=
 =?us-ascii?Q?5EIgh90qz3fXFAsG7AVMEOu7Zd4mYIIl/olMxWGDCG8T2C7vv5JymhDTEgFC?=
 =?us-ascii?Q?HgJEm+6cgY7GS9voP27uWgiGrLvY0bJ8J/RQcSi8GXgLpKx0ocI+CdOI6za+?=
 =?us-ascii?Q?XjO4dFp39CjaP/1Ao8mYR+1ft+iuwDJrtvmfdSFwbqx4EqWhIiXvXaJW3ONN?=
 =?us-ascii?Q?Q8xd1FKhZYL8jgVjCBekAsDjAnYOfcFvxGE7V+KXThtHGELY4kFYO/kLjEbw?=
 =?us-ascii?Q?WEQ5P7XORifcNm/twblyPizsuS0OLNiJX7T0Cia87/YVkaY4Ydr79/QWjckr?=
 =?us-ascii?Q?223eMeCiRV5pyWmiU0KBZ8OIoGdCdYzfxRW/8gj7qkGw5j4mP/rg+Z0zlZvW?=
 =?us-ascii?Q?h4cz4bObWgnxBtzVwM4d2L9+ufoQsQc4JNBovq4FZnHFFLDEo0ZWKa1/+TO1?=
 =?us-ascii?Q?vVj4qiHkfhY2s3kT/iO0+wpzEAZ4JtFTdHRgFue+0DDM0HKsUGRa3SVU0bv8?=
 =?us-ascii?Q?gfdiT+1K0mhwMlI5lZ/JVW4TCW9OgTX40pjDOL8g7/7Ldxe+VT5TqGzDCwUl?=
 =?us-ascii?Q?2q01Z98mixa9T3m/jV02lhY0pNbictsouOzp1dXtEOJyW+ZNDnor+nWnjI4y?=
 =?us-ascii?Q?vNc1ViaR4FGp5cXjUV0nFScjRoeHtXG6OlO81HDRzTGbWRp/+WkdA2sUWCfF?=
 =?us-ascii?Q?WjGDasyGo0p6vvXNoecX/uHPI4v+FpnBsAo4KXGty2MkKlXpz89QH6alLlfP?=
 =?us-ascii?Q?kivzY5/aifpn0ds9SzoVXCjfTWF9L3vib07jrcqrKF6PyJimWztSpqyDnbvT?=
 =?us-ascii?Q?ds+HwUjLJJLRYOojX/m5XOzOvbBdAfFyKcpGN9o0y0b+/pxe/aiw90atAkg0?=
 =?us-ascii?Q?52YZWXxCzNl37qe2NjT9NF9XBNqoBL8q34Uwo3ngKLuHFwIszg9IlmwDB5aE?=
 =?us-ascii?Q?NA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OUiyaHsCHP7zXFFQUSUwFnZRWgtb2WeQMJeeIqCuDHyvOuCyeLZj++JqJrW25v0qu4Iba5FLmFLnPLDAkG7APXd6KK3fr9NDekSdZlfgUsc6kLnY/sTAOPzTpUPi4v/bBPDNXG3/gRNvzDQGfPlEWKGG1UKBVuoVonslBAKVn/L8+NGPaxUpTlA0uOysfNStn53bPzp+GthRKWV39BSPGwQJNj7D4op14dxtEcgdV6ezYRiHWmejy1QHYgQhzItkLo9sCzXoAKZwKkibpk3PainNB59WNCcaDfxhWpRzN+UG8Qm3QMmA2JMWurN/pfu4vO/ieXZVL00S9yKfOC4UV01z/v9mB7rq0A2t2+XPtxkz+mDkNaX1aToN/ZnSBvIKh6zC0O+vJ+p7tDhTlwoST9HJC0EAf30gT4Vr1seomFAJTR1OobVUKj2D9SNyB/sUpTthFSJUOiFcsJzmIaRVWBukRFkYxiBD/RKAUcat66qxyj36kPvlhrf2ZI2TfysVsi0atQ2JVbL1EndCByCBlUK7GyOni7iDMy2xjK/GUpMOM6dc5VG48QEsvDSlMadp/ywPjp24s9aNenzaZMm7To0WoSmm6yzgss7L9gskqlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435f21ba-2c72-4abe-3f13-08dcbb1c8652
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:17:16.7562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJRhru5JBnY6QmHY+03pJW/BuL7Q7vyOfZs+FfHa1pCJ988RnnnynBCDegcdUUQAmV639YIV+rs2Avo1IOq/YHMrD4MdIjbV6H1QpxNVrRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=887 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408120164
X-Proofpoint-ORIG-GUID: qmMmnloW8F2OIKQj890z9wAyi9Bvx7Yr
X-Proofpoint-GUID: qmMmnloW8F2OIKQj890z9wAyi9Bvx7Yr


Rob,

> Use of_property_present() to test for property presence rather than
> of_find_property(). This is part of a larger effort to remove callers
> of of_find_property() and similar functions. of_find_property() leaks
> the DT struct property and data pointers which is a problem for
> dynamically allocated nodes which may be freed.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
