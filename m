Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD27A17741;
	Thu, 21 Nov 2024 02:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732157765; cv=fail; b=G4SWH5ufT4AzAT9aaTXrjagBcxw52jqwc3gClVp0OTh0Yw1L3AWgf7Vau6AN9bqL1dznFHHWgaXAAo3i6TcqiGPpAj/faMddiyAacNRIg5/JAcUy/jVsAKfL6VGYXSe2MSQiT6mzZPkeDmNNNGhaogyTeDhe/avJFuhUVeSahQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732157765; c=relaxed/simple;
	bh=ubpVxb9O9Sexy/w2pyyozvnIdI9FwGPWA8q8GtnRNdM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=p5lCz0WKa6lglfvB2EOqLccDTvTe/P5oq9xY0TvqoSPDY75UMF188DJHy4C/UIINkRm9LkjGqnaKJsE32Lwnt17PTbr44GF/w9KsvTi2ObYMt+lMWuCv8I4kIiPcncETHID3YrypPVkRNBTn2v7Yn8CCnCs0P4l50ZKpBKwQEFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lj62LnSC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LFH5Z2ip; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lj62LnSC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LFH5Z2ip"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL1fi4M006268;
	Thu, 21 Nov 2024 02:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Ay0TBm+RZnDGDNcrYe
	lApmkFASsP4jsB3NhdRNuRVOo=; b=lj62LnSCH0K0FPJ+NbHAKWZqnqdBSsdUau
	cqDMwpL3/UAMumSL/TCSzWP/2W3uXXFopOjyGvNCzFKOnpIdn17iXAJIi4ZDSIeo
	ITzUyVBiEKBBUgq9akqEN4WQqgprT4lh3fFV50ao0hzcrzJ3PqWOI4+i5RWieFdQ
	Bhe29ywNOrLxmaiF5CUQ9eiKJSBG4yY6C/gTQnoJX5zArYJ9ML+fNLeaH8IvHT+Z
	QWmtRsYlF+dvy7hWWD4v30wiUdrg137kk7IDjl5JnpLtw/sG2d9cCZZdpgYOoJXT
	llHlM/Myxm+SZdf3btJYs1RT2N537OzsNX+Iqg2yUyQMzpX8UKhg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhyygqe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:56:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL2CoXX039202;
	Thu, 21 Nov 2024 02:56:01 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhuawknp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:56:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oQSun5hygidYml9LmyoszEAaFAbjWFDCtBGes/dX7M7O9x2mzcTC/hzzWysEVhNWrqN+toc4FHzgZZ5qx6ldidNb1BaKqw5E8er9MXvHHGkfCmZvBqHL0kCa7+vo1StDp1eT4hicsAJ4HPXLYtJwuOlo5Xeead6GkJUzYAE4RBpgqqYlNTMXdVE8s3TlgFrWtuCVfQvFMl7qV/Y4iZiYpPVhv79lIcK8Bv1qobxR57HAbRh4wkbAbvdNHXxiSVzpnE5DCFHw+I6huHZaEwU1T30vERGOvwBNCAII7Smy1fr3yPI61K45gjSiI3Y2k6cOdgyRPOPWdJzLtZhOxu+B1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ay0TBm+RZnDGDNcrYelApmkFASsP4jsB3NhdRNuRVOo=;
 b=g0WWhCrEkzF/YBMRIwzJQsMSWZfhugoSZsz7BDiqxKWKvG4OUbHD1nqdRmDWfORvn65p5iX6eAMZx/j9qKfSbESwqpgDRF0Y4q04177PIpVJHoag9Oi38C8rBB1rY1KMVWLVu6eYjDoTk5RP8pRmvdHIZ4r3O+DU8laEk5CqO0NzcUHQwvSPozjDNSBZwkJl+Fnp02F4lRF5DcEuvR4jGLaHul3Uf83k88MG0V0RPCjjUVT82F+xXKv+zr53FipTa0ngDh5G4RVjAyrg23TbefLUSihfw2gCpTBa8KqEY+U5LgajFDfto58nCeSylkokAa4k4EIi98cnNC3w2rUCHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ay0TBm+RZnDGDNcrYelApmkFASsP4jsB3NhdRNuRVOo=;
 b=LFH5Z2ipL/eu2qrZGhF9T6qUpiZNZgEegElzXsyoOlRuY1ayXnNhzjc7CKBydrVkB1UIEAU0ha6Q1a2DAE2nGRv6p4hbH/ywCDwo2l0Pwcf3KQ3xZYUa6smMV++Iy8Jms6T3R0Xs3JAOCKJSybdo+/P4D/2BREE2FdVvU55Zkns=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by DS0PR10MB7405.namprd10.prod.outlook.com (2603:10b6:8:15e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Thu, 21 Nov
 2024 02:55:58 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 02:55:57 +0000
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Bodo Stroesser <bostroesser@gmail.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: Constify some structures
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <f83cd8469cc17391178e1181e8c26c4c1fb6028f.1731330634.git.christophe.jaillet@wanadoo.fr>
	(Christophe JAILLET's message of "Mon, 11 Nov 2024 14:10:56 +0100")
Organization: Oracle Corporation
Message-ID: <yq1serlpa73.fsf@ca-mkp.ca.oracle.com>
References: <f83cd8469cc17391178e1181e8c26c4c1fb6028f.1731330634.git.christophe.jaillet@wanadoo.fr>
Date: Wed, 20 Nov 2024 21:55:56 -0500
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0495.namprd03.prod.outlook.com
 (2603:10b6:408:130::20) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|DS0PR10MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c55ad0-44b8-4617-216d-08dd09d80635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UDZEVMIuMjMWR28uEKUT8kyy5TiS6vYBQPJ80XTZyiVguw0heb00ChNDYkc8?=
 =?us-ascii?Q?RdVWXw0dTtDVIXo1tch+/fNQP3JrRvd9oB846Yza6McC7KggDbMF8CSbQ3Nk?=
 =?us-ascii?Q?Wj/GY8YeGMwiK5X5YrjqPTlB2oeS7XrfB+nDzQ+DUPYN9hLv+f8sUKebJPO5?=
 =?us-ascii?Q?ZoDgc/MjfYEf2i0yjlxTHVKimALJaydDVOmLEhLPKCzmYd+iCu0w3XXfxkCg?=
 =?us-ascii?Q?3LOwVMAiMFizOY5bFe6HuuKAt89Xf5xYmgXKW422oCmOy9QNLzuCciAWbQWo?=
 =?us-ascii?Q?WSUeCzr4XWpOv9YL8njxNeqfFw2co4gHQgmYRsXbStjvq6mXBq75kT9zbVeF?=
 =?us-ascii?Q?IE/5uy0Y8HYJ3eg2pVQcLlK4F/835KqZbsfrWkbTIXnxSmCH0J7gh/+4/lCY?=
 =?us-ascii?Q?gGmTWPsiogSEARLo6neUcF6tt2ExXfgtUr9aGSg0lVDMAxh3D2W92QNyUHnY?=
 =?us-ascii?Q?1F8zE3dUIYLEylS+jKrgEz/MdEKQ/e5Nc4qQD5+MSUonIa+4ZsCqRKkw6HmY?=
 =?us-ascii?Q?C8gZuAaWWWwSv7PGAnGp7C14+GuD8kk9w9ewtV0aRr9oIrKxTwURSJ5ZnvCf?=
 =?us-ascii?Q?ZNc8BTNxCDvzP+RtPuQw8FUqcFAOW2GpeL3U8L8hxC/9ZtpS/9AeRaxrq21n?=
 =?us-ascii?Q?nmW7+ycY39T4u6GQQyqrGh5AB26vqg0lxsrA7B7UWEyjhfrhxcgMuKElaJQd?=
 =?us-ascii?Q?4arSGsnPcc9Vu1jPURO/PU6XxjR/AWB0j150b89Lo4krNJvB+40m9iC5NvtM?=
 =?us-ascii?Q?rbnmAfkTM7zTH8kdIKCa/yUCExUYg2c2k+EyAvkH3CohQce2iHB3DhhAo6pU?=
 =?us-ascii?Q?aj6zLAt9uTxwW3inL+YbZu4nzWBRSMlgwKwiKWvQOMfU99Ek0j/bKmQWG1O6?=
 =?us-ascii?Q?/RetsHmrxvxWdufs0Eq0ZQJjBNh7q+yjcDFJrPejuKHmiIGcjHqbXU6VH4DB?=
 =?us-ascii?Q?aoAxWYRZ7y2TTF7zkh3BSCgFYS6lal+G/Y1mHFy6mqf8i4mvXW8YGsUZto1u?=
 =?us-ascii?Q?+aYmUVZA45McWKNnnvnP+l6J+ted6OXkniiN/+LogC278nKJnRRbVv44cR17?=
 =?us-ascii?Q?pk9Cty/JwPfELiWK51nMtOpT56SoTivnV1QJgfBg4rOGas6jTp4UZwg0iXej?=
 =?us-ascii?Q?xV5gAwhdwZwIiRgVt0TwSn5YwIo+9p6KVBMNqfKjFeOsuikHzMGflh05YDJa?=
 =?us-ascii?Q?mdO/WhrHJ8SjuRqWltCjzXPB3Bt30H61BGc3ScbNKi4COihfvwP6fqGKxovW?=
 =?us-ascii?Q?YPNq76xdcTlixllIdgkg9U2Qg+llByNukYv1zoYHrtD2m5nycju62VtR2h3w?=
 =?us-ascii?Q?m+rrhH0SkVYw0fVQm2Cw6eGR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dZOTZBCFE4mrlQtyNG/4FK9imWefQTTZc+jlelCmlIdVUMyDp9CRqzbCW2E0?=
 =?us-ascii?Q?3ohZn5xYbcdoQTVxDaw13v3dQMxN3ZUC59C80d5FlYgFFV8UQRlXt0BOivCt?=
 =?us-ascii?Q?SO7KQz193cCo3wpxorgdbqll4zODnU0nHiycDrrRFf0Fy78QeFnU0urw1qpx?=
 =?us-ascii?Q?IfpelqRaTwrYyvX37R5hifxjl9xKK8rDMXWH2ij9oh5850ql5BBuuGzckj9N?=
 =?us-ascii?Q?UjhQJPZhH/OmliuTMznjwnWd0HsDbhTpQqSTUdQHW7ipkZkMHDY9GUjTsMiJ?=
 =?us-ascii?Q?CFQDuaZ+nfmskJdE1hTG05JtJZaZXzVj2SdPYCbvehYBR75EzeEf1mai3EUT?=
 =?us-ascii?Q?umcc+ThQ6tmhCIcHPZN3IuYjN3jweHxonvhAB04CQAhyrLhBau0B5XSp90o9?=
 =?us-ascii?Q?yYGa8LJG4Glvvi+87nejpGl49GsgL3laJ0vkXGMvqdXSE110gTVDm4r2wD62?=
 =?us-ascii?Q?Dsk92c9jTepmFEmlEnC8v83WmmZDRxrrxrOiN+vB2wrZYRNsVOxdP3p7FuSV?=
 =?us-ascii?Q?OuvAXNTyfOhafW3xKZXmONxw7G4ual8VzkuwbgP8AzzP3o/284/qTGslNZjl?=
 =?us-ascii?Q?MDI6n8aW5L4XUGuEO6KqugdSktxTcYQqqZDsskXsUgvDKI/v3lo//dqj0WfK?=
 =?us-ascii?Q?4AfwqztgCvyDcG3g4JHlPDqLICVy5fBGq+LMjFTMglkJPK+nJIQ1ggBhX9Wi?=
 =?us-ascii?Q?DUj5kGj81JT6nJFKlXRuqnGuFv2pRb0+UjQIkE8PGS795V3anetn8QQ+JEsR?=
 =?us-ascii?Q?RDBP6c3be0X6jKEWcdYRdBrURa0GETXy9o8vSASdhZ/BDrwk8qFDKwlMVE10?=
 =?us-ascii?Q?JctltAR35+kdJRR2Es9NmLKgxYgWkxNeWyO02v5sFjnfEwPEAHjit92GIJ7D?=
 =?us-ascii?Q?xa4tLgdpZHZ4G2ZvRo+q3u8sD2EXizXRPjis6buUe3OFQ/Y5rYf8wFr5m6D0?=
 =?us-ascii?Q?Aw4pswJgsNdvk+FCMep4Cc6K3UlMXeRSxV784aYRNWmUlLmnYbbSne8VLx/4?=
 =?us-ascii?Q?wpWhi331bgbGOgD3S7fkwqtVp8YaoHvkQHg8q36zBVB/1bAmatwE1hsft19i?=
 =?us-ascii?Q?RNim4gbiRmG5t+NWhlDmXVdpGTUHSBD/4EopoTUbIw6/LIJqMDHLmy9CLBv4?=
 =?us-ascii?Q?wQ3WMW+vvoi4Fbhxl6HE2p2eSeQvN+UIhFz7SDIHRPpxIv+bnG6I6BbqJF59?=
 =?us-ascii?Q?n4wvcw8f6Y2sqS3+ml5d04brD98KHVe4w7uvsHFmYtx90aVrz6KcC0UdDcGc?=
 =?us-ascii?Q?TMQ3bJ/fJRUtz52bBtJQu+kNJaZUlPRfRNFKhYkgQ4BpD/2E5xqHME/9y9tX?=
 =?us-ascii?Q?nahYmikMxG3gLW61NErwhdCU+ji4d63VCMOioGCR+cew6KZUyAU5F+vOxSUB?=
 =?us-ascii?Q?WmJ74/9a+wHbVeDERewzdSpQeZmqr0rRxWDkriN/eTuR0MNidhfB8yvT1KvA?=
 =?us-ascii?Q?LkLi7sTJUD7Wio6iBxPxD8Qg+U1H7ljB0znHP+WgfxCldOc52CZDl41G8Nr6?=
 =?us-ascii?Q?rV5dOcMGPVUK+ZPDGlRW4D37RY5v0CJWT1flrOd7aS6reDHd/vVB/R10PhtA?=
 =?us-ascii?Q?JFKnkDcrl1bGpBHj9AbIKyI7xS66oe2JbWe5zL2h5bC2fX73JnJjP2Hn7QQ7?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aq4rLaF34Ng+rkYI1/V4sxj8H++Ong1vfPlG9zZtUYn2np4l60GouebkS5yQBrMh9b374c929lIHncNaegOzJSYKNDyq260cUA8R3jlcUVaWkVjTBwlstysHufIJtZ9jRoU9lIC+INbyIWyesL94xQK/M3+TaGngsDO7gUeGPcIyHvNfsJ4b29JZmoR2+C1MnbIOEl4iN9FegIPdyqoo/pzEyXBsl6UIiUEQNh2A7XTmX9eNq/57St8372chTsROb/R2NRoXf7iZz79G7+bmJesRXUngwfiWdbU8+0UJL8PmqVlqE1zhh5lYiMxXS4Ko3KapymbKOnXVn+J8CgzaoLKIsBI7jmNm+IJvdQKyursiiycRCVhQB8gZMhWpAHmqF8XMqnMtEaHq+mM8WC7+c0UgypqvWKMQSreqLHRPDB0DPEpgXNdC6uEiZFArch2Dk4LzwH1QbeGVrJvL89ONuAeOEM/cGStohapxpT0pY6vs8wJmKtoxm3exigHe353okCDOewS3AsqOASENBa+Se4Vfj9TosPFK0xcT5A50wyhWQ5RzrTtZbEJ7Q2kGFhEAlgrNnwUsdtZjJq39dsPi9xCA1TixqPDo6eEnT8SLZlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c55ad0-44b8-4617-216d-08dd09d80635
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 02:55:57.9314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmFQI7bz8JJISfy/buys8g7xs9EPfiCE0cMKSYNnkM6n1KO0020YhOjiBDD/kBg+Cmo1sSnRsFoR8ozp7BSPDTBOCJeSL55AE/499BHSF7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7405
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-21_01,2024-11-20_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=926 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411210022
X-Proofpoint-ORIG-GUID: rKzVwGHPH7B65vsi5yBZkn6QRQ1wkcbu
X-Proofpoint-GUID: rKzVwGHPH7B65vsi5yBZkn6QRQ1wkcbu


Christophe,

> 'struct nla_policy' and 'struct match_table_t' are not modified in this
> driver.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
