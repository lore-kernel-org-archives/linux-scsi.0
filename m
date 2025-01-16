Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE781DE890;
	Thu, 16 Jan 2025 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047051; cv=fail; b=XvZ78BYsyQ+wqG/i93t8J7tsNKEdvz1z7qDlXXOeYDNEhUGcj7KgdJzWxvkeftSLyz5Qtt0xlCPgXOTi+EHVFXfkCUzSVwvIV77mygP3Xtocxzy9plt+kZjH6wsVEWZo5KfisvTZyln9LTYiSKQAKOfNXmyDBfrNu9sCtBPSHA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047051; c=relaxed/simple;
	bh=p6q6F+lV4MQfwt7LZ980TvG90UUwHs2H90IZr9JuQUs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ai+pXTYsoHffx7CtExH2yo9XDn5E4ppvGwiaWQyZxYos1ZCIjQJH/9M2I3bxlcqZwzGc55V6RY0rX7qBtNuIpiM094umaoGGSVn2pX6uCrPJWeBc7EOol7i9p2Bt34DUEF/K31mpugl6qfKKCjv2RJ7oNyTYNDclfpPNsgmARKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YGTndVRm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q0S3543O; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YGTndVRm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q0S3543O"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0gox024167;
	Thu, 16 Jan 2025 17:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ebWUp9yE0MpNy6PVjgfNu559dHhK5qyyHea/CjurGiA=; b=
	YGTndVRmDtjuiDUGUgnCtHxGUaHUTcvOYvO5eVy6kh0xXgjf5TaQuger3qMTlhh8
	/zMY0suUF1WAYh67WzfLaVLJY1AdKAKEip+gsyewAqw8PTt5eaxQtHaEiDs6zVd2
	RXB3PHFTqfHDwIUwg1O+HL230iIN6UnwR4k1ywPUYJmkNUsw0VQkQjactKXTJzgv
	OoB98Os3ONWMv+Zm8H/5uXST9oSkpKaGmu60isdPhl9z2GZxMeBZV4ePt2SdtHhW
	9rscuUHYRZrNwqRY0gS2yWjb6Bvulx/U00ASkV2lJuzTlZv4O6DgxppvbVBZgZoW
	dm3qzwLrOBPuYFmfD+eT1Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4475mfg2vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH25IA034806;
	Thu, 16 Jan 2025 17:03:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3b24sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eDuDejZ+SZiPRgD7TWU0a1CRXpkOjHANxPfz5XA/XVA4u+LBTWmTuNJ96NxH2brbB5p+rgebPdXeU24IF77suTWubQZ3fR4tTVelc4Y5OpgcQBCT3v/vGHprAnnq++atlbMsWb+26n7E4sE8OWHwk9QHW8S1+8ndnIFobdqGxIiH2p6CE0VUo06x1YDlBz5NyG/7z3MJtD6BZLYoBsTNjq2NCM+HoMX76s6aNZ7L8mXlRxoTn1cRg4KIAHeBIkq0k8EU+F0iRB2Y1iwCtY0uec4s0jOAp1M6Ml1n/g9RWZnlI2W9NNCOHd0OL6HRo7BGaYnL5VbPP5cl75S3W0NGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebWUp9yE0MpNy6PVjgfNu559dHhK5qyyHea/CjurGiA=;
 b=fBnbeqF6iDN8l1McbGHCdcISENHaFe366T4oqF0IHuiB5kh/l1vbOmaV1o78KTSESwrxvKJhY6w/UE17LjOJp5zTivpgSf2+iUdgMC+RALSx5oMlHS6yCBGC9mKv2hHONbGCoAUsYyg2dpe7xG+OVGMD7nvqW+ikPqQx6I+tInAGn4ErOiYsXcLmw/mNLL8rp0yVZdKGyCuSEdUMMYrQq6o0lJd5INAyG8Qx03cMWIRf9IladXfZvPyxrrLgQB4LaCUEdJGX/6c5AFF/0ozTJhnkr6sccLKkORDupmugO8bF5DjQHwm5K/GhCgSr5K0hneSWWMHAZDLBrAe95eI8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebWUp9yE0MpNy6PVjgfNu559dHhK5qyyHea/CjurGiA=;
 b=Q0S3543O6r1lsYKUAF7CHoOdNqvMroTZiu6YNnfS0YYA0Wcajp8M8aw1lf8EuxDPgQcDDncZnExCD52itC7hdgytVpDGUvIOpOpCByseJ/dydt/of1BISdLQTpmnf2dmdQQ3E3XhBsD6jzGZ8ASSiEppeEDBZE9Gq+2s1wVVSRs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:43 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 8/8] dm-mirror: Support atomic writes
Date: Thu, 16 Jan 2025 17:03:01 +0000
Message-Id: <20250116170301.474130-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:408:d4::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: a88f71ff-4fb2-4648-8ea0-08dd364fbb57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2vhPz14QN3JM0NpgoTSzx4W/YmbdVu/CLWizsXhLVFysnQv3L1fd23jRTpIy?=
 =?us-ascii?Q?+HzUbFicgYzJmblMsdz0CgzdHgu56umD+e2G3BekU3ogHfhcuQdpmbLEOEty?=
 =?us-ascii?Q?KuMLgwsw2SN1HcFDG+TmdwwPPEJfVYpqTmUN/RxyEAQJIYpReoOAzMfqEf6t?=
 =?us-ascii?Q?qEz89G6lywtcHc2hoWWddafUghQfux6Me06gnfEWU1SiXT39mQ4qndkpctOF?=
 =?us-ascii?Q?/JKDYj2Kgz27ibP+en74EepfRgoXvbNow3sYTHpZHSwHe4HXg1lRhH5pFCZn?=
 =?us-ascii?Q?Ft8fre688rV72XZzIMf29sQH3O3pCU39VAg+/jdW1beE0EB63Ph52wFsjJT9?=
 =?us-ascii?Q?jbbaA3HwGMDstYU9o8k2Jc8Yu2NEpGeIQ2JEI+x1HNbvgPGoMH+4rdwEMCz3?=
 =?us-ascii?Q?1i7x1h6EQ7iCkQ54FCOPSbKw8dU7jkyYYqGSxTwvoVs5iwK4U+4qFd9BfSR3?=
 =?us-ascii?Q?/UBvoaI2DNby1FSKQ+QIAvwR4plJA0b560PLaAX+eh+I0u5HzXbw36hguyNw?=
 =?us-ascii?Q?wrVnkvTUnfLYt2MTc14duBRNQSmiNT3zfTkJahBG6RN4lPtFxgr3y9CCrpaL?=
 =?us-ascii?Q?1iorJHU1dWwbN4VFcPQP08YBF64jyKfZ+xQN+O09HwaVUodXR2vCIfFI1efg?=
 =?us-ascii?Q?QMaL1KMdgVdpIl5h+S5bCHysX4k2WPc0UT8izF6nkQPEP3GVRaHVJknax+S1?=
 =?us-ascii?Q?XHoRAkNdyCXRs68UGpgNjRwfEaa8subSDHazYCb8PDe/0v03x6gwV292Lwxy?=
 =?us-ascii?Q?N2NRwDUlkPenxvlEo0ibm5MWtx7mnU2tBvqwXK+ZHPhUZcUbaS2Rfot1cG53?=
 =?us-ascii?Q?crT60yzo/Yii6vDyCR/VfQ06r4Uk64MklHA1xYoIuYGwvxTycdzGBXD0awkr?=
 =?us-ascii?Q?5tlQJIgQPaVM2MbbdFbERJdBj3+egTzB9fO7cyEcK859L1XRSQZm3TLqsnmx?=
 =?us-ascii?Q?I6j76V+IZ7ov5hRI0F43IC7taUKTjauLyKYGMwPc7+bBiaZb74Bb6TCaH/0y?=
 =?us-ascii?Q?rPiof0U8T2Z/S0IVYvKn+2g/eoxvjL4UVcEsPNhEeyOGTwYBrFz25wq69phb?=
 =?us-ascii?Q?zn8rEQ19O4tYq1UJTbAsig4kvkhSx7zOvn5SKHnjVDT4LaFOiVfPloKea7Zy?=
 =?us-ascii?Q?irHwu44W6J4ap8DHtvgYznfYMPjxIBVxuQApC2g2Tp56rSbEoHyvirigf6S1?=
 =?us-ascii?Q?n/1Sz58EB/FDjtlJZnXYgHJLWVP22kCuEZs9rSZHQ7ScDoxHQkKkdoKqkYTG?=
 =?us-ascii?Q?FnQ5O+qPeoHGS8YHHsslH70co8qT/VDsA+RgC3lMpe4WvKp4Aj91oWzcNL4Y?=
 =?us-ascii?Q?qwPHCGds0vqtkPM5W4lQDcrvFqQxcLzR5Vp/4RzJX1ddkUIR30GuB5dZN0n/?=
 =?us-ascii?Q?axtw2fxIF1Ul+peS7ZT9EIaTOjm1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wyvM58vEIVA8AP0ppxVAXEw9f/oiNgWiDlT3PxcUQP64Ay+HtKJVUtnVHvrT?=
 =?us-ascii?Q?poV+pvaEyYmFQgVNqj8IiqoZDQnopPHlbDsF3AgqcPHhWY/c3Dhir7nfU42r?=
 =?us-ascii?Q?a/jpPxT9BqomdztHwvGqmBjZ2hcM+gI3I9mr3/hUC9Y6sTT0q2BQoxgavv43?=
 =?us-ascii?Q?xVDRHA05ADOufROFB5xg/hvr3VFkeW0hOamDz7vN4EYDNb7FLE9+wPQVsBzE?=
 =?us-ascii?Q?d/bMc52QM704vzyqGZFUoL5pD8SUBv7+jZfif1YgdrQAPktBiuDvnPwz3iF7?=
 =?us-ascii?Q?BBaaFdRHTiBSnLDNPeoBxSfZ8gNrPmQYYgFqnAqFD9eZbM+xmmaO41g+NqKq?=
 =?us-ascii?Q?yqPP+l9hvSRBGhtdY4MbTrImcTOihBLVAX2ygAt63tOOenkTxYMELwYv5MZr?=
 =?us-ascii?Q?8V4hdkjDspUuxoMOzX3qqvv/CVz3CPuDeeLeiGoCJumJ6lGrQ6DeMydYpF9P?=
 =?us-ascii?Q?Xz02nLfgDuO33NnHQPEOqAvyS5vGoCD0te/kziMf+9pSfGdVUkXfUizPhajE?=
 =?us-ascii?Q?9RvG8vfoIOs0poDo+y6FV/KVz+0BnkfJpnQP8fOi+qn5uynoi+No9eTcsPD5?=
 =?us-ascii?Q?i72xGdEnnEEDb9QbF1wKrtOCxNKzSHACNKpZIakm/2wIwjea4rHRmoAQsb3+?=
 =?us-ascii?Q?L2auImgpFP2up4Opdk1pVNKO2frOb7HGX+t0vticqhGOdGR1NCl4Dc7BEH2V?=
 =?us-ascii?Q?ukKnZEqLukDMw2ba36azJ5mx9EVFdmUR0Sanxgx16OMSOaYQe26wxIQHWlLz?=
 =?us-ascii?Q?V1qFI4bhwqP0pufi1w7v7fKVX8/1/kc21H8WKKxV01Gkr5gS5XrHCS/fjnQU?=
 =?us-ascii?Q?tHoOvrOCJ5z7SnQu0EbJMo5th1Slzt5MXp7d33inB0vrZdqHJkju6jPP5g8L?=
 =?us-ascii?Q?sMJbsnF0HT128DmdDzB2D/wyot0P6IKhEr8LrUrk56Bub3WzKwF0FBPQwh9Q?=
 =?us-ascii?Q?/pnyjXIEh8AerOKOOqLabrIMhHRNv/16BXWjElPf1ADn5LUGgO43MiAlO3jT?=
 =?us-ascii?Q?M6fp7nFPtfagh7euYZZ84W6QADXnMNByhT1H0D2tNpPe5jYcZz7f8+rNc5N0?=
 =?us-ascii?Q?9iLJXpPHq4hvkpzHDOhvXDai5c4LOlrnOBrvgKoqRGJz0D4avm/iWjSnWYJI?=
 =?us-ascii?Q?DxY50Laf/4kxipKS+IP7B5pdNw/MBoxTLRwKuAT8JPKqmCa6LilCcUectA6H?=
 =?us-ascii?Q?owt3+t/nFi4J84lJEdkgMHgsHsP8mBnFWN1uoBaUkBNJeFvi1n7APdoziLAe?=
 =?us-ascii?Q?zrd8HM04euylybPGwUg4YFA9exlr76cX6THVO7OIwJiRk15ZXguHmjZtu3pR?=
 =?us-ascii?Q?1cnL/R6eif3ZBZrW38TVXL3ITdbg69IVfabte8YpE/EckpiCClOS9grR8S0Q?=
 =?us-ascii?Q?87W4a4a4PuCt6OM1YI4UIufXrenoWyva7i3UX+9kCxhxls1mcWZB6nxIko3e?=
 =?us-ascii?Q?vQSG6gDGqj/I1A2/Gq6ov6qRU4B706WK5FBH2iUWtZO4JZUagSftkRHLiN1J?=
 =?us-ascii?Q?Nb5SNWZ7rqCMB7Rp0STtnGDsQCOBYJyChsxz8/ofpYPflqD6Fr01BzunELWz?=
 =?us-ascii?Q?oQhCtM/3lttBhWtRER9KjUZY4OxEB8V+6AOPsU5paWnVCmdvxNGr7/00M80B?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6fYHhDENmAnU8FouBGJuKHEdiEYRaIKlPkpIhPuFDGSxlM93rqybq0Nrny9b4stqNWBPWYffWziZo+BQCNGn01bmYePT7NT/iGYh72my4x3gdosx7D3PRUbFC4dZKjwrJkdcbXOUzA966pvoO6BfHFXxPOAXQHHYqlPKGxmWNvZm1ol9IqwHJFH9VUZyB6zYumt4HXWBnVUF8gflWn6/8qfu4CA5K2d4x94WuuXgTOtfyxiVvbi8I8XgHCSbzcszKa6oyKaJtOh1dDsQdChuqmFLE0QIgu7pnybgSHGztgEF4w9XhZohvmwxipMa5nt/mndr61baYqumLT9TVd4aK+amPvNDpmyMkc9Jl4H5PpIeOgAWJOuT/Pogz0PyyhjNO1yr+dTYS0u/1+isERVPJWlg36Fy1qptWxvfoXgdSaGxthXOPjwA9SDiutJwCchAiNA7t7kUmnCwOFYnrf0ykjSIiZwOMT3P8O+9Tgx8/EhNlw9KaF+urxtyCAn4CCo58VubBDSm74emzRR7Diq2BLLQLpjibKo93CVfHa3PmmAH0QFrtld1K6RcbpaYkLP9wMXFY6nm4+X7b+YIBjJPjUgduHq02ww2kA9u3BGni6o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88f71ff-4fb2-4648-8ea0-08dd364fbb57
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:43.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GFWGTwl7xiZuwpuuKtno1YHYiqajwUU3GEGrth7NoyQhZmcsBwJrMXtpgoWT8G6g+JGMleoGpumonSJySUFww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-GUID: sWdNZkKlewaFEnGS2NgUgrKm9lciTJ3k
X-Proofpoint-ORIG-GUID: sWdNZkKlewaFEnGS2NgUgrKm9lciTJ3k

Support atomic writes by setting DM_TARGET_ATOMIC_WRITES for the target
type, and also unmasking REQ_ATOMIC from the submitted bio op flags.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-raid1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 9511dae5b556..7a42bf648c52 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -656,7 +656,7 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	unsigned int i;
 	struct dm_io_region io[MAX_NR_MIRRORS], *dest = io;
 	struct mirror *m;
-	blk_opf_t op_flags = bio->bi_opf & (REQ_FUA | REQ_PREFLUSH);
+	blk_opf_t op_flags = bio->bi_opf & (REQ_FUA | REQ_PREFLUSH | REQ_ATOMIC);
 	struct dm_io_request io_req = {
 		.bi_opf = REQ_OP_WRITE | op_flags,
 		.mem.type = DM_IO_BIO,
@@ -1485,6 +1485,7 @@ static struct target_type mirror_target = {
 	.name	 = "mirror",
 	.version = {1, 14, 0},
 	.module	 = THIS_MODULE,
+	.features = DM_TARGET_ATOMIC_WRITES,
 	.ctr	 = mirror_ctr,
 	.dtr	 = mirror_dtr,
 	.map	 = mirror_map,
-- 
2.31.1

