Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF56FCC;
	Tue, 13 Aug 2024 02:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514860; cv=fail; b=owxe+jFr3n9a/ArojuIN0e+5ALw3d/qzuRC60xEqetMprJF657Y7D5oSvM/gFIUhFf/lpAPUdxFgpYXyLK0VFl85JReMrMS8pxEv6vM8psSDQkS8uuxwtu2sTpnbXdg3admUWLfi16kqN3Kkzy/M6k9zGXsNG5Td/8rNjwsvCbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514860; c=relaxed/simple;
	bh=PyZ+ksezXaj673cSdKSM0yGbPYVfuJ9c2JyLKMs0KFA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=C5zqaDXWT8DM7qIFlReToBbFfWL7sfUeqmIply/Y4R4GycRiDh/YN/UkWNAil5Sh4nlfZ1cUUYU2jLod5ceJh58dWzDBRxs0VcS9x3Dvqb/awLZ6Bht8H6Q9sznoG7ckGbb06RopkFqIIeAsPZsDorzfRQRzwhlSkABIzs0dsoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i8zGKdVH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=id0zpRa5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i8zGKdVH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="id0zpRa5"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JBK030882;
	Tue, 13 Aug 2024 02:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=eFDQShAq05/MKB
	DLh4aijVtCXKzMK/VPW2CazQugMYk=; b=i8zGKdVHxKNJWU4Kj3xyJ0LGhUN19a
	TREUGBzBSPg4ZFIDb7A754ZuYlGBw/jObSrt96M9VaVcLDVJOfgIxta+b40w5hYZ
	REnu/+m4iGueoERAojOThDzLGubGqNFdLs9b7OWQSCC4K1saUWO2E9X6zveU6lAb
	0e0bAqYkAzgMVmfUAex/V5/NOR4YeuupctBf2v4OZ6xfn5nhnNOmNn7A9GDpj5tP
	vQMG/LDV9ad5r7YiHXt0qZikFSnMVMcieBVIAWEVCWgJvUwDTsublH9eGW9MnnUU
	64MeD3dKx2B7RyJGkXmPjg6zapdakT0v+jfYAg7HHau64CKGfLfP72NA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmcvty6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:07:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CMs3G0000610;
	Tue, 13 Aug 2024 02:07:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7w2uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:07:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rgXV3CbQ3PVDsmlnCqjuSrAcgzVdVA22yQGzSR4FZN2sJa56gXYUUVrRt/FLtRDH6RRPJhqfnzrsNKnf2zPcnRkbvflXfEJyj1/ssnStAWK06x8BDx242r9yWnyXxz/5qn4L99U8pUPFHFVyW5HMms8f+vs47cHdRbvIAA4X9oRMpgvd/nvfAEgOhD7/WqsCKWfcPRAueKq7AhryJu0OkoYNlgiHPJimbv/qUrnAO8cjFGhv9cHXmKn2hViXpeesH8WVfbr5Oi3bbrSivUFMN7WhPJvrZ3oUUeE0Z8WdC/r3cu+lrHj9Qa4tYzl+pfvzyZDD6rgtrL07X+kdW5zqiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFDQShAq05/MKBDLh4aijVtCXKzMK/VPW2CazQugMYk=;
 b=pab5jcjhQh7UWEmJ5sVtDKCl7mOHg3w2i2mMSYnbSqRpPFgY5r6ZbnCtWrj/vQrK9TcOOHHffKTNBGoU/oa9LHZwU7CXbzNG1nVp5uWOuN46C99h3Hp6+dTXZOjM+j7VU4KDc1XWXM/46hU+ln7tNHpnsiBgM+aLgaqQK+JpjgWozCQcBcPQ3FAHUYTZE1NxehkyPUGXJk4NgrU0Z5ci5r6ynlktHTmrDYp1yIcsW2T1pUNXRZyoWRl/fw8RqGCZTJ30uIgg8NYTCnY91vMbxj+t/+IwdAVOpbNLRb9XSOwvjPGh9xHEhhy9UGPL/ViesskCp4enggIby7auDnoq1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFDQShAq05/MKBDLh4aijVtCXKzMK/VPW2CazQugMYk=;
 b=id0zpRa5Gpwi++0tlx8X0Na7ZIl/EOmVtOqfA6ZyWkcs+3+MXK1lRcYxNbag0BmC0Okak0diO9ShsGQJ5WyYI6RgTwSDs8l50imk/ZRytKlBVeA3ucs4NEpmAUkdWD4fZbY8vMYcAfRSD1iQDhU4lz6/VbkVyRuuN7gryAQs8HY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7289.namprd10.prod.outlook.com (2603:10b6:930:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 02:07:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 02:07:28 +0000
To: Finn Thain <fthain@linux-m68k.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke
 <hare@suse.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ondrej Zary <linux@zary.sk>,
        Michael
 Schmitz <schmitzmic@gmail.com>, stable@vger.kernel.org,
        Stan Johnson
 <userm57@yahoo.com>
Subject: Re: [PATCH 00/11] NCR5380: Bug fixes and other improvements
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org> (Finn Thain's
	message of "Wed, 07 Aug 2024 13:36:28 +1000")
Organization: Oracle Corporation
Message-ID: <yq1cymdw4yz.fsf@ca-mkp.ca.oracle.com>
References: <cover.1723001788.git.fthain@linux-m68k.org>
Date: Mon, 12 Aug 2024 22:07:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0041.namprd15.prod.outlook.com
 (2603:10b6:208:237::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f74c70c-32ae-4996-0a50-08dcbb3caee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yYRy4vf8fJ9lxvsFlc0U9RSH2GerBLxqPAZyL4Kp2FV0iAbLHORopsUIPLAP?=
 =?us-ascii?Q?1YlL5bdrbuvXfbXv3Bx2YhuEpSvQf6YULJ+1NPDm7FIooeg7B8y/o1fU6LEy?=
 =?us-ascii?Q?/+eK+XT+7/uRQUc8KbGCLjEeDx8fqFJ0Q6imo7aEbAg+XljG+gcUFSKaUlJh?=
 =?us-ascii?Q?v+Z9EY2pD/i640dvY7Uu8Qu8ob6FhHk970x4oijN+jvw/x3Xx+KnjvJXgnzs?=
 =?us-ascii?Q?vIyE7EfVzoBUy6a5Da4+8dxvHOol5YflB+cSe7tzCm1g1ZEQ8zdM5nwHpWxM?=
 =?us-ascii?Q?Ubmp0ypsiByRBAMchRhiXoqaQR9r6TDZCrLHBoebKN2ywljj7PxETBeW+/sc?=
 =?us-ascii?Q?QH2eFGwpTNY6LkrwUnQqCN0rGpbpyUKO1Mq9Dv7NmQzjQFkDIXuVZY+GXB9O?=
 =?us-ascii?Q?VeaOS6BKywIU7P8wiCzl90P5ewrZeiLMRsXR392h/0NIXbhgxsOs+faMtNlq?=
 =?us-ascii?Q?70HjwF3023ubCwDV0VGFnyUqakjrHAz0i78nqHDwiPubTf2S4nn2/cw8KEUk?=
 =?us-ascii?Q?hG/82xsDV3H/ywMTxTqp3rUoRkN+vPwdWRrohXFdZOLbNUTGtKsidt+uiVu8?=
 =?us-ascii?Q?KYVuTf7Cvu+aiXrTvazzuV63yujXO+7AxZTdut5Wz/DOf9BgXtIf1auQsZOF?=
 =?us-ascii?Q?NsekTWThMfMwG7JZ8gEXaI+t5Ytpo14o/FvpBwBQPCIZ4prN6fpKlQgWKXnl?=
 =?us-ascii?Q?PlpsZvWJmJ0RcFA+u1Dd5NKxSJOU/XfeDJZmWnGIb1B8+P22yIR9PNCYdY6Y?=
 =?us-ascii?Q?khcpd8xVFpMQr3pcwX6KLV1taTCGsG48uyXw7lNwqJYtKlUhcOF1a1ApbxCC?=
 =?us-ascii?Q?ovtXtDkWwOAhnaIc4RHH8+TpCc1j6/xaBEL4FYcX+MlTDYU91r4xMzAGmaQy?=
 =?us-ascii?Q?NmbhAgjzQ6gdLZdT6dCjSSTg/VU6pUvfFIsBJXil6ezQFOEIW6eu6NK2etcT?=
 =?us-ascii?Q?/h70HGQcfXxRwobd3I/tkHfXP64xsxbIH+qbubnxLUlUJKYKuQe8WLxuBddk?=
 =?us-ascii?Q?rnFUaDq/Cbm1Saxw7H+Y8J0Z5QynU5PAcH3+V4bTPE/pHSDRx456R0p+nxGH?=
 =?us-ascii?Q?mDCqSICFPfyXI+tb1LEfinO+N1lFRy3mUDYhZ7QQgh+jXBmcjEabvZYbxML2?=
 =?us-ascii?Q?m2R9QVtNd8wapvd3VDA13wOS9glBHZ0PXYeYkrh4XWsJfMdhHm3kMqVz7NqP?=
 =?us-ascii?Q?dZWp9tnXHSqc205hA/bl/WCXwEgbtAuE0qB1XT9Q4OZY11s2yuuERSxGwe84?=
 =?us-ascii?Q?mODTQ/6SMH2uLPWiThrg05Jo7JQII21g9MRLPPYvczo0TGRqDxYsi7BdZSch?=
 =?us-ascii?Q?r8H+YyEhRQvOIMGbnTvvYKb2rru5s2CxiA8hUEO6NVChMA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6jpmbR9DVQZv8pztTGHEFNzC5exYseiRssF9kojp+T+96kp88/0gCGKe8iDd?=
 =?us-ascii?Q?jNWSwAOqUUOpD8S1aC3Btx5VUBIVJJ0J9wHEh8Ttm6P3+JQJXH321aWjZ4B8?=
 =?us-ascii?Q?McWnTeuInKYcSLwCGlqh6lv54X48RctYkcCddMp428/YuPI3v/FEHLO3Mi+f?=
 =?us-ascii?Q?rEroBTL/WEDoqq2yKMrkr4/MHrLmTj9O+4Uz5Zb4irzm7kNobSCr8abkaYpl?=
 =?us-ascii?Q?vrjihIiM00Zkd7LvDaXsu4v6IFXfPtI4vXLM4cufUt3cZ8usQ9XNNuTbyxjT?=
 =?us-ascii?Q?c/qNwaOkXRRQA+j+QbocWpawpXTYQ/tYWFJwcPUOhT94vc6vjMbDB6w26HxP?=
 =?us-ascii?Q?j0raR1kTJr5KxKHgofUF+S1cftYeD7NuLYH9hRU56fPYL5SgypV1YZxznJEy?=
 =?us-ascii?Q?Y8Gu1ddAzZUTyfIegunh/7wfj2iKIw8E4INz811hurMtKkkexnBOiKPGz6/E?=
 =?us-ascii?Q?CD1R6azEImP5SPxtOji1OlSpMaCHEY3iLyVl+9pbFxjBLVJFpkEEkx9Sy2F1?=
 =?us-ascii?Q?4e4qegJ6bNlFpkbJDtnd9W8VM6iS7HLNZEZkk3nckidYcfqVkAp++dgZhn+O?=
 =?us-ascii?Q?Vds2rCWBVNBr0Mbxu7fqAcjD55CZadMtbkGPviuwYKLUZzFj9/JdPL8q5vET?=
 =?us-ascii?Q?Vlu+zBJ5Z1XAK6aIWw4VT9cbDSCAHiiGUeYMQsHIz0TZGpcWis1HhdhzNags?=
 =?us-ascii?Q?eRl0zHSIxhARqgW7NgDbOZX9IE0tbcGjoKMpeYUNRRmZpGx+SiVNoksz77PA?=
 =?us-ascii?Q?NdcGCLp1bAkMzOpr+5wT35TIxbP/OVzFNd1GPBXFSoOCLDxu0iFunak2upYY?=
 =?us-ascii?Q?sEMHDw5mH+D/js4v7uKetvoVf5+5eb4mTBgxkFgQhQ7BNPK8pc/6TRoqcl15?=
 =?us-ascii?Q?NkasTADv+E5qleoa/4c7oRWLyt1iomAZjrlDtUZ/7T4nzMA3Wwy9T6p1sh6U?=
 =?us-ascii?Q?Hix5huvjs7jJZarsr9RMu6zaif4adw/Y8Dnw07FBAs0MiaqNzJTEuepWX56j?=
 =?us-ascii?Q?Z8vpbsQ7ndX641YEJTp1kLjAIylNMJqoM9n2ywhuAnYXdhTaSPU0l9iW0EGr?=
 =?us-ascii?Q?PaN13pBkMVwaaxw913hGkvMHmprkBdUZQ+tzekOyFjUWHnvS2maSqTYD8TD9?=
 =?us-ascii?Q?sGWAM9n/CTZ6k3qXMKqjxSp1iM7y2CwWxYygjvuj7Jjc3ajc/dwgMEGjFjuQ?=
 =?us-ascii?Q?Q+hec4fVaf6AW5oAANy+ASTkFQ3NEJRXm5CptjrJlh2XgKKQmSvcwpbMT6be?=
 =?us-ascii?Q?Hg4pZeZc3mHLn+dCEKEhRKa0v3zXh1+KhVEV0lFH/FwN4jjaLofufU2wQlbJ?=
 =?us-ascii?Q?nq3F+YDg5OkGipexHlSBNZT93xmlLw82SKfkCetig+G0HYsw5nIR6g6UK0EI?=
 =?us-ascii?Q?8d3iS+VQbuMnCujmVP+i3DzutzL1qjTvWb2AVg1Sg0oFnDTAVNE0hPuQEvxn?=
 =?us-ascii?Q?1+1wuu6u78S05z2zUMSefBpKXPYEtQun6QfQY+6t4xGXRBiB2ZO413qtMZsM?=
 =?us-ascii?Q?VPYOm3Vu1+ad8ct1rS+PuDAy9cqgU7H08JZhTH6kznHMCOxG3vwuEA4nRygc?=
 =?us-ascii?Q?4BjABuFWroqYBUZa3rTQ8jDE0msU9J38m1jWmbJW77R5GHkrhNJmbttgJ6AX?=
 =?us-ascii?Q?Xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	putaHUbZqrmmIfmQRKltEImz0y1albdUrT122u07m9N3FKHql13SDx6J+FFrmVkoBAl7/aIoSi+iZgMkdo8SKjzSmx2ArjD5wVn7i41qoNjUMy63CSm14GQsMfctHHMMaJcz/2kKXvDj26XiaQK/r4OjAnid1v7+8X+/+wodQWDKo8PWeck9JrDcwg5a4esizh35bfmsjG4vRUCx+cTXNhX/X+/1zcRlYHVWlHSEIzefiStYY+K11M9wtKht3IyjlJZKwHgI0piLMZB2FWre4t8hlc52faDYntV0WdBk9A/mYYR+1A/jxtpavOo4NKtHbEeWOrHFb1AxjV0ZPS2sU4eyGQuPY+L3JzaV6Nss/+MVkWylZs4oHC0EMgUrYTpS1sS+s2srd+D0HS5Z2cZT7tELrtNvDU0prN5WrDjedgDH3Cl2e9siqxaGD3t0/b+uEhR+sHeiMJKB+6sW/IIlD6zqixsY3hgE2urpiP4V2SPnn5t+CdN7+O/oM+Q4Fza76o74jvjgC24J0VJkjSOH97nqwyiPMRe2cy7FAhKaXf+5bi5r8yGLUI3FL3mnaq/iHpBm0IkPdBC2TnMFw+zjtl+FtHSLYarRH+kLehxKU64=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f74c70c-32ae-4996-0a50-08dcbb3caee1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 02:07:28.7127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxUkQzkORE1Cni42JjVPag2cLCufOJXJrK3R66xsNvrPWw8cCbp6y9rZlKKGVXxheLxq5lz8fT+L5jIdbfTJSWYhiPOnxkyIG3dLBZqOi5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=535 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130012
X-Proofpoint-ORIG-GUID: wpqapJ5UZYOlQtBM6260D5Lpf8sji7cG
X-Proofpoint-GUID: wpqapJ5UZYOlQtBM6260D5Lpf8sji7cG


Finn,

> This series begins with some work on the mac_scsi driver to improve
> compatibility with SCSI2SD v5 devices. Better error handling is needed
> there because the PDMA hardware does not tolerate the write latency
> spikes which SD cards can produce.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
