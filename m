Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147EFDF6C;
	Thu, 27 Jun 2024 02:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719456243; cv=fail; b=Z0giz4yuewAUjA+a9m+kfZ580JhZ7U9GU+BR49gLN+LDeXj9oM13G7Q6kqmwEFAtzpjLEciFuWtUYYbYFg7txtY1c8GB3qanDmMtPFckwBBZwSOiqIgHV6OMu5akhWYvzBMJZsTyc2Ssap9EnCZL0ayuk7ZzpSLOEE0KvNUvKY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719456243; c=relaxed/simple;
	bh=RlfbmAA+6rQZRnzCVAjc7vgU9xXb89Y8hwLZUUkBgtU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jSJQcxAw86qu5fwhEw+am1fNZMs52eSrZtonWoQyM7psguqBeWlCI2Wjp50tkM8tOwiDk2hqjDfNG67IUkmLmbjfzBo57EBOZVbxLcX3GpmIHLVTuS3rr4HYouW18grbnRNSkug4envxCUIwRRgH8RY3fTOFcbAWZpNd4W1Qi6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kZLLSUav; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HQwYN7Hi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kZLLSUav";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HQwYN7Hi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QLMkVN011135;
	Thu, 27 Jun 2024 02:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=3C4pY78xNz4pAx
	II+1aSjWZHZjmM+aZWV/lWq8pAJL8=; b=kZLLSUavEdkAtNa8vZ7+yu4wwsH6OX
	NCU4IIahBTw5KROPtBrMNKIpEpbM+3rgZJxkq/LWrEPjO1EMXcQqewXPAmJmlYIE
	1n0dGqT/yMv2Fgz9G2lyv8nUVdjkyb7BpDZfDm9EALIvzpCABD/KlS2iyK3c2Ue7
	ezFoXZmktKyfCjwxBDA91hM7+vx45tdm19hkkgZCGj0fKuVnK47h/lzrPHVxszNW
	H+ei8Y7sAacLOIIv6saZ7XKDGZwcudNuS6QikDkM010dfLYu14QrLM1NzVYoKXSw
	78YA/GhIMdiENwFb+RE+/XgydLQ4Ji7+GKg2m3x0G1+f7wM3q4TAGgeg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywq5t4vy5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 02:43:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45R1oBCk010789;
	Thu, 27 Jun 2024 02:43:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2g9w2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 02:43:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kykul4la/bJnmnd7d//L7h7+ORDD3CtuP4xkY7mPpzjTqosjy5yALxNmAHgBFmVSYAqQMUhLjMulceW/t08h3I7aVHAsDVt80Qost79zk5mr4wazYmPuPVLTnICgWBaG7emuviIjxqg6OYb46n/WlCOqcXu+vgqadb/+lInVSeRlv2/btWz1RD/SBBjy6ii5sbT1iewNAgBQaoVxJxX45ufSZeygzkKtmYtclGETko5Nt1SZ+6UZYlZPvcMTnMDhnU7XmfZbCCTKGRgmpxTOPANMzP7jWJS2Kj5AqbafcdliOACNR7MkDHA47P/3s4+NSJ4t8+l1nfA3wT0Keckz0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3C4pY78xNz4pAxII+1aSjWZHZjmM+aZWV/lWq8pAJL8=;
 b=Quk67v/FtA3bE9KUJPvYtd6p39QXkL03/eAybq1bsMyXn4Ytt1IKCCKebBrsu9fCQrztpnxE6dSUz4e///mgbSwkh5bLmiEI8ZaLn+EEoVIeYhVcziC8hKtnZ4pGDUmkLmivvJIy6XqU5IMsRsGBobmHZChyaVFSLC8RDRISpR0lxmN8/Q1t6ulPt0jE+RDn8V0MDFF0i+wdGL2AIHf/s+UpBjtFBU/66uHQFqtIvX9U8T2j5oLfrm19IqYRkfRyPkZcWrcw7HvwgS7ampBI8EUbYFdpoMQtwlAwm08S4yoaNgeUDBGq0/SFtPf4mRH7EgaXFB+XEdCdz+A5Zo0O2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C4pY78xNz4pAxII+1aSjWZHZjmM+aZWV/lWq8pAJL8=;
 b=HQwYN7Hiw5VeuKICT9uMFYGSAOqgVrqtunbLQM94Jy3SJRTZYruKH06iR/vvi1iPowqPBlbK4nrMIY0SC3xh/jOrwxR8Ry8i7+S6ylnXyZOOCIRRh0JKln56nBjsPSS7T1RpNXmP3FoXEX8DQFsP1bPzkisSHdoT+98LyBAd+KE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB8033.namprd10.prod.outlook.com (2603:10b6:408:280::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Thu, 27 Jun
 2024 02:43:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.033; Thu, 27 Jun 2024
 02:43:49 +0000
To: Li Feng <fengli@smartx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe
 <axboe@kernel.dk>
Subject: Re: [PATCH v2] scsi: sd: Keep the discard mode stable
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240619071412.140100-1-fengli@smartx.com> (Li Feng's message of
	"Wed, 19 Jun 2024 15:14:03 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ed8jglom.fsf@ca-mkp.ca.oracle.com>
References: <20240619071412.140100-1-fengli@smartx.com>
Date: Wed, 26 Jun 2024 22:43:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: 542e2c45-4c96-4537-4297-08dc9652f905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?ttUVQpSVurl2ovjruP3ojsfs6FePpqpbLZXEN2fqUmdjfDj6pHn9VnwuHHlu?=
 =?us-ascii?Q?jaJBAYXAq3tBb1rptyZuNcDFVxv+1rReRzJXfpMRtq0TWldx9p6980JDF/83?=
 =?us-ascii?Q?d3JjNXXiYz13Ap0lO0spEMZQk8dgeZjjEfrd48HdelcApxOOVbTLx7WaGOIn?=
 =?us-ascii?Q?G9kTkKYAS9K4KyPylR/gYIAIlf15pstxsu4evr8s0Vmxc8WxStEyF97+OoCL?=
 =?us-ascii?Q?AKEsOD0FNqdKqLICFmjYT8NGvtCFKXl8GBJh3tldX2f9c72itNVSYM1fSw/o?=
 =?us-ascii?Q?Z5RN8F/szpz588L5MPf1nh4hfesImFdQ4WQCLvDPDez0CnkOnzQAotkvsVO5?=
 =?us-ascii?Q?2kIUWdHaVVxxGQfZvSsIIXRzp7fWwJTaGmHzZI4/FnEg4pAidpjkswjiOUIs?=
 =?us-ascii?Q?MsyiIqQ1dZyeNT9H1xXv/o9251N7OVdxwb7Yz1Ft92/i6QSSWBm8BTPdvre/?=
 =?us-ascii?Q?p8SPwFCS5f/qxFZeHDHVZhTdytvSDBM8aY+bhFsp2PRIW45rtzSgxuqujOBL?=
 =?us-ascii?Q?2Z3C/p/RGtyeWxVbla93bS+fEHlaMB02u6TzYm4kgPPgcWIO+snNIysq16Io?=
 =?us-ascii?Q?RTm8F9A9WhVJaAM5kQu2DsOUiAnspw7rsWUPfr/3d/bPyDXVOzZb2TcLwLzE?=
 =?us-ascii?Q?/VKXMnfDMlBu3P1sriC8uC3NjV4akiZd++3Bi/gW6IBgqXsTY0Ct3B/q72ca?=
 =?us-ascii?Q?ktnLEAEeOc2uy4iEXx2qFOoZM3KsCyLL/Uw+BpP5w98mJyuwScvnENaVtzL2?=
 =?us-ascii?Q?fDJZ8rxAl6eXzTJY3RSnPRipMlO1YronH8ArHWKeWHWx3j4vMEbpGxe/v1gL?=
 =?us-ascii?Q?wFmE2X+qjPRTM1WC4A3GTNSxcf2iwR+OvucUiz+eEqeVK4vng1PA2GxGZi+k?=
 =?us-ascii?Q?RPF7xZ4a7p5s1Ydx1QkLIcf8jt7dpuI01qeDzTRQh1JgT5UGjfbMo/VVuHYv?=
 =?us-ascii?Q?IzKlJb+F/CvEKZ32AYvutVw58EL6IGIXeRYq5bdd6E4z9XgIIMqixo31ls1V?=
 =?us-ascii?Q?oNWKfHA82nTWjRCpCxy4daPV7KNc44fXMqHezBPjPGxMSJylpKRGt1TVjWhR?=
 =?us-ascii?Q?/WlnEaWYX2WO9lXiIVipWy/cykkTV383CvDzeZUB3tCA/G9q37t2APzicBJt?=
 =?us-ascii?Q?E88O8B0hDymNjivjb9SB6frHaN163mDjOZHuh4YQEw6kKcXHoo07d6emo4Jn?=
 =?us-ascii?Q?RijpRFP6GxY4SOR/LPTlnLwwZMJTRpuWlOaxTNe9JUOuN6xN5E7r3d7VKOB0?=
 =?us-ascii?Q?4xwXwBBXWpgepcn8uxYRtmQADnRCljD1EUgk3DfwgeLvotn7J+i14XfwKhw3?=
 =?us-ascii?Q?fA3wzYcbacZxHPuCdofkCvkAy9+D2BQevfEnl6B06vzN+g=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6umVeWr5zc313KGogu1IeVqEGHLxZ+A+b/OA7MOIPXbrfweBjDtvbwviG9b1?=
 =?us-ascii?Q?1PaXTScQcioGWL319V4ZUBz8xbkPouOz0HE/ZKhWHBRIFa7OzLUt7RtFEgvs?=
 =?us-ascii?Q?0MnjPXoHSpTqHWOn97KmzMM/jd1b3qCS7OBXBgF8pAb0lOCA5oMJylZT20Ng?=
 =?us-ascii?Q?TXz+x2j7HWA6thlHLkasBH8d2WvFnUFCsYorpQo54FfVo5U0hVCQ+Eelb6Ha?=
 =?us-ascii?Q?5/bam4Kly3x2FYQuVIp1Biu3iX9Qy+HC44HTUu4sTTjjxj8uX2UiDJzGh1iY?=
 =?us-ascii?Q?HgPyhTT4NGSFhTBDINJzAxlqqKgccBVBEfsahe87LM9O19SCy8mAsaEpqjfp?=
 =?us-ascii?Q?Uy24OSba7pBxnKoBtOY4KIX9tIssZYDKXJhrk5bGGgPbWPQTDHhr/0dGrtdE?=
 =?us-ascii?Q?YzT5+uGPAYX+XXhZtzjQ9N0ORzl+3dzHDYy81FS2jA2QT25zxzvrYmEEXtjx?=
 =?us-ascii?Q?lMZEMrDhSA7XVo17ImZ675aMOg6LG7GQ9b6SaLcYkp+K7+A4oqph+o/gaURs?=
 =?us-ascii?Q?1MMgpgTYzaUfxN7pl4FZPOC4XLBIcxAfdBzrIaMReNOQ0Akc7j+3R69mEMiZ?=
 =?us-ascii?Q?byz0SPpWE+QorBl+lIc6uzvllnNnwuniAA/G9om3n0DGKNRsI+8GBLhVbXJs?=
 =?us-ascii?Q?2V321wtzQi+6EMqZiBoZVuVRbYx+A9zjKcoGl5DMjxXWuAJ4oqz/d4FuECL+?=
 =?us-ascii?Q?AKgY95Al0sJZBG7Q6omRr+Y64Aue+fojELsIY1F3J6eub1NkVE4wQp9+oyx/?=
 =?us-ascii?Q?a5ziNHJFgWl76o5wCNq1NOU8MAOZeCi8wpler78Qu7iOSzvCU0cqH4zORhsN?=
 =?us-ascii?Q?HU4gVGZh4XiHkayzjEWWtolqd/eAom1y0GhcuxpTWg381Vw+f87435tXXWte?=
 =?us-ascii?Q?uRiude7eXItCQwxdThkMdlpxVkX24uiffcWh0cXiWsu9ySvFPY9M8bT7ayM2?=
 =?us-ascii?Q?2iFseJYgVoIe7rNM8nDd60cK0RsJ4np8fjdUFa7B5UGY5ykxXzH2dHRPHqmw?=
 =?us-ascii?Q?RBmZLg3CMqJIHpJZ6YMku7xmTit/vkqYD7Y4cm/2MKXah6fXFiXt/X7M5cY5?=
 =?us-ascii?Q?OKLbDRS45Fai77j48TFL8TldojbWbMNDhI+UNJu7WPcysZVhMwEpiaXAPhOI?=
 =?us-ascii?Q?Nd+8J26LsH29nZKYIO/Tn7CPvm2tutZUvCswXUG4WZqcTI8ZpEZOzrnsi3uw?=
 =?us-ascii?Q?kQN2QA+iJPdkIp5Wm6Z6sKla+37FcZyayhomPpHDJgVw61S4TLBXEGkbYHSf?=
 =?us-ascii?Q?cOPmPKNa1n33exSCcRZlEbWvJ1J75lLQnJeOh077BBiLUNWFfcxvXW0SAmo8?=
 =?us-ascii?Q?eLvbyywnOXOSm1ikCN7NyYJ/6ziIDU2Jxz6GjRdcLlktoo5CWU4zrTBFXyNb?=
 =?us-ascii?Q?TVA1zTXyd4AzqoDPpepnQxPvsiVJU954N9vCg5/8WGwuHa0yGhgWgI9oC5Cz?=
 =?us-ascii?Q?X4JfzRfX0RKPHqqzunuGc0broZ7UBHy/GiOAHEvUBS86fperdIoAM4gH5Uez?=
 =?us-ascii?Q?/0pUIWqu8VAYuO4NZmH8SmlgkwNprf3HdHNZGgvKGNsVfjEtisZuKBd0mtFt?=
 =?us-ascii?Q?vjO4RKsiHKveYbfjHYetrr4MI0oEaP/ogyYwjCDHx5cZsxqlXh3Kccn0ERA1?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lEHVDLi6fH9eL+MIXctRmnSbrln239LppEx5Ze7q2U/0ZuM7SF3ig51ALUvn/lzxK/e0rIjR5KybBCKDkzRCaILx//lPk1Pp9RAh3OeN7QDYK2HQla3WJESZD/GszIPuhY3I+PleoLgEYVcScJMjtafXBE8i58jIcoSdaD2LBwL1OYePvGSt8axYD+XfWgbYbIakSNKBkuMCTTmiJqg6/5QftYhwJ7cRdLBmQ5QdbcH8EU9ogLdrr2mcut0rQwUVjztxVbSEZek90FgFFGqFzj8kTIuE/FoFiCOKbYjCNeXr7CYTcSYNqQRuu4AyKXs3cDlWEKuTB/jqTH51W2u8AyLzz9nLYQjwShLoFS18L4tUTEKyqhDAk8XDF8C/BhidVMWEdDq8tbfaf33csMhkcEZijKk1fidpq2vox0l1vSAx9BALpVfX4ZTRvBGXhW6TdEFingQuydFDogM7Eu5F4xZVvIjuIUqZCzWA+sE0rq5ZeMUcBK0Sshc9L5Qk64fbu8hni1NQlfPRM20sCodwcy76M0r+Fe+H0z8xl1gwWQ8BVH56Jmva5V0WFvHogyJvGBQHJV7Z85nGwoaCEdBPbWdoqh6Vgtvue3/G7RwLURs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 542e2c45-4c96-4537-4297-08dc9652f905
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2024 02:43:49.0789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /A1qnzm2+GMvjN5uwU66tEsHgzDx+GGraiwrUbHpedyruaYTyo0NY30TNX51ogfoOGDUdboQZKnFVDbfrz4i7ygVMhHESa6kVlDM2HzBeso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_17,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=904 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406270019
X-Proofpoint-GUID: MXoWdu5DKZIuvXKfkEj8G5ir80cbAujR
X-Proofpoint-ORIG-GUID: MXoWdu5DKZIuvXKfkEj8G5ir80cbAujR


Li,

> The discard mode has been negotiated during the SCSI probe. If the
> mode is temporarily changed from UNMAP to WRITE SAME with UNMAP, IO
> ERROR may occur because the target may not implement WRITE SAME with
> UNMAP. Keep the discard mode stable to fix this issue.

This is fine with me. It's a subset of what I have pending in my
discovery series but it doesn't look like that will ready in time for
6.11. So let's just grab this for now.

Jens: Probably easiest if you take this through the block-limits branch.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
