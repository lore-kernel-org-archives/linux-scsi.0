Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF084480962;
	Tue,  1 Sep 2026 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259612; cv=fail; b=LguchDF2ZDCPz2itbli4oNca9sXoqvuBKBdeiL881YanOTLPGAXg/YYLNw6KK7aV/itaSvXv5P5BQHhZUwff+aZObu47heflfWes8k/V7+xIXxsXySt0Bd7cvq4VRGHp1sQUvM5Rl/Pfe8mBSTON3kvMyuU+FlmX9YtJetZ3pYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259612; c=relaxed/simple;
	bh=oH3j0HFYrkKLmTnusf8KVHEb8hWHPIfSLZRm9rltz8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nq7h8eWhqQZPkcjKyzEO1q5lt/X/IqD08N9giuQL95ZV1sCJIzel0VU/b8xTQ8OH8eHN5e4WVI0O1cCkAuWVxEB7h1sBHlsL3CGI1CpQSBDJp29o8XhC3iA7riGtCpg6GTJBvG1TS+4cCZAdy/xTJfcRiB04oJyzyRhbvWJJkNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YuTNzhwf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tpe2rTCx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YuTNzhwf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tpe2rTCx"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCkAK2297378;
	Tue, 1 Sep 2026 10:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BpTbmunR74CPu09YxsEfFSDfkJsdmcDiiUmNzzu1yAg=; b=
	YuTNzhwfEi53qtLYl/d8VtVwoYLh3HDlnMbLO8qfokJ/wWsViRZv+dESRq7pL8cf
	c63KZ70Qir4VsEHt+u86XgRmPazyeRFPzjD3GpqZKJfkPp9ZkgdOkjUHhRlZFA6m
	YSSkSbdgNy6BGXn3vDRMyXu2kTo6/vD/BXaR8tjnc5xfz4b/WtZEI2yrRMT23ZoX
	AhRMk+Dtu7l1obCRF8k5EgHFL4SJfmg67b3jjO12WUsZXy5ye7FPhfjSyO4jLyOs
	NFiFR+QvfEzbxeXlsqZwAU+tEc73aNPOhEkIANGLds4ck/WuLE+XkCZfAiT8sud5
	0shXbLVA8GtlyBxpAnLQFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp0xvdbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYuBM040245;
	Tue, 1 Sep 2026 10:46:28 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8n9d-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uytbhMri7yMt81HQKybg1SoPB//rYdHFIyFN9ZZnwSO1ol3RTdWjCI3G0h34sFjWrFFt3OdZxW+1QWdXBaGhQwGKDhKx2PCKISy3Q3zpda1y9Wqzxhl1AzXszVGgz5XeOjexwLU2rvIHkmWBN1sbGtwyKF6yQSvm3FUUNxWahrIRMJXQmJ2/8lca1jR5+JVVPtMzwkzZX0Vmcn4hw/sgjU5Euh4wthELQuOHZGaL5pNbNjvCUzxBOOz7aPspjdTXOPDL/elm4KQr5hn50VDggePbEMRp9f2CSO+zvCFMAMd2kjlkpPOAbu+DSPmIpwLHdjPdNnydrF1ewxeHVOxcAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpTbmunR74CPu09YxsEfFSDfkJsdmcDiiUmNzzu1yAg=;
 b=QeCbt5jLtTdtbd8Fq0GYmUI6x8QbjNgqmGE4vgTc3fMKSTQI8rxJySrNxAcWYCpggq8XgphGKbJosiL/yfRONU0B1rSgEOZpA7JeGLNA55VY8OutWNh0jFS82KjETHruk8lrOwvEhXGrQ/rDByzQ19kCkAC5VkI7qoCmKyXJjTnca02fkw+VsvlQYKU/tQnWBEqGS4Cf45sXgGMLejCZWlnSL1BeXyr1EHrV58G1JFGIwrCwMkaA+dxP1JKxDym1cRROSes2TKolx+EmezPSIbDZOaHAnf+2apasdmodccu2HNMvs8UvyP4ATV8qcXgZcSu04sTAPOPMCE9zie7kHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpTbmunR74CPu09YxsEfFSDfkJsdmcDiiUmNzzu1yAg=;
 b=tpe2rTCxy7/kzUAljJfZ1mwchIM2IffMoklrSD46HmTZ/9fZahmE08a+qJuYdZRqqFkI9GFfJRxnJg0/9poqlUhYNO1NEjrH4CBxHUNBqyWG1hUEKGSebpSGooZYk+OlRklhC4ve169mpzM10uGXpQbdQkwam79EWg/Zk1lsDG4=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:22 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 22/27] scsi: sd: add multipath disk class
Date: Tue,  1 Sep 2026 10:45:21 +0000
Message-ID: <20260901104526.3850621-23-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:510:339::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: e201e576-535a-453b-1446-08df08164384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	A4RB410EO50zgTQQPNVmcEfQdNWESgHP6fEhF7xxAaaLv/wf7Y0QJwoyJ4jlk2gaq+FK0OaoCgLs/eW+W2tMF64oAe2nYpc+wiSN1wXfENvWJJoEDgHaG4tF/UrTgSO3Sp9TgcAEuJrFAdEzhZqNDdWZSDCBmuWpX0iPopCM8pcFXdWABrCnlZG9IF6xvjnqfPeQ0JuUgUAPqkhXyQMTpmIUsgcMW26ntg1OBIDoi68yOeEy9zmOz405ODI4tviotBY12QUFrgtSzYoJwYTd3JHhlhNCgB9EPnw7gZGzlPtlDthVrHMOYEc9FkRObINKxi/hrRzCh6rEVwOZWNHd84cOwLGf8gT2AcCr4NVASpLoyC7ap6+NEye1cPkNJsmphDG0nn4AewGqZ1QYRe+m8YPUE0CdCmb8qU2DzRFqSDPQpsg5ZTUZkcmrJsAbnuufywWj7p920ZEcgbR0PrzcI5qMq7q2lVq8lij1XuBXZnHORGM/xJvNTCcJy4sq1c/BfXM7r2utYcn0UvgKQVJ1tC0Df21aHBHBuydffRlDK8nbEhbKupJpqZ2uvX7GK5Fmlcgn8LnXg5diy+9KugsKL0axKEsGxbS1WTZg+S1CMadrXQWdMKYpvwWGXRQ4aosO8Qb+0zWCBjabFtU05WCa+xq3gkb4eBUtWI9pSP3z29M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TlaJqD1KGpN+W+ye44KiNCwFyiMvz6Tdci93GAA/o8wFyTtO2VICNkJKVMLh?=
 =?us-ascii?Q?iG95yxPvJ+J/ld1FkckPYhwDrHlcoDS+QtzJMFeA2LPK1I7cSrfWLREjpxSl?=
 =?us-ascii?Q?6amvjK0Hguyp+kKRfvYcGIbYnKWE8lNrC+d2voKOIZFFEE/IL2gMhOqxYAG3?=
 =?us-ascii?Q?Lj7tlBq02IRDoQaMsemNnu5p62obHPhZ1bAkNcO/ajl/4HcN8iuSyY+y6oHX?=
 =?us-ascii?Q?FllZULdq4+RZmIWvI0Pv5QM50TXqxrIYFMnIsVGLYtatP9osw9Iq9qAEDajr?=
 =?us-ascii?Q?YRt2Tk9hIfqYAJt0kz8nRXmP+2/22z5lU6PcipLVIX4frDTB/J4P/lCC1EOb?=
 =?us-ascii?Q?bhHc/oV8bWOhiv4jf6Qfx5ZwcYdvGOVwliu1uJ7jpffyqQKSKaGF6vjGP/d2?=
 =?us-ascii?Q?hrUHgkDssXX7LxPxSenjBP5c4UNPi4owuUUdi1R+ahbYIRvve8BoStLfzbZ8?=
 =?us-ascii?Q?XLK6eKyZf5DDd8YrXzkFme8tRq+7i1o2ZM5KKAjjsb9a8KEDqWFbL4m0a9vk?=
 =?us-ascii?Q?P2vbjmTZBa9Ml6Xg2bEiCads7tzJDVAOX142cqQHVU7lxw7C72kSdaGpLb4U?=
 =?us-ascii?Q?f7ihSwui7r4NxG8+/42CVH4KnQSRV4gdYl1E1t1b9FuMU+d7dq7BtXCdQt/J?=
 =?us-ascii?Q?u+TksDjGeQtLuCEoijQORZIbdisR+wBZIy9vOZBWh6i+DLcIh3kAgmE06/OI?=
 =?us-ascii?Q?F39NmKR/dLdyId4O6H0lQsUzb5jqOptWb3NOM3D2gxnMBPKGpLLt+klyE+VY?=
 =?us-ascii?Q?NorBWh5emQgzn67CKhUMkYe0ymO+pmM5I5Wt8klHh31mNh4KsoKF0eYtSaMm?=
 =?us-ascii?Q?uLxrqHCJLF+lhdGEQFe/viWewjX2SmM+cKYhrIlXqASxgMwVqtyEKAU/XcO3?=
 =?us-ascii?Q?t9AFSLVES+nGQ4QHL48wNWgbjWcHbn+SDnHAADb1hiuq/8hcjbjcBR3bDfKt?=
 =?us-ascii?Q?PXkH+Q3z4OYwgO+j7ShVo3yJ0Y4FnmbTpnL9StgKgMovrxhnxyjidf3KfJwr?=
 =?us-ascii?Q?0+D2M1Nwf4tMPWUj5GHi1ge4tLq2edf1v/kDr3s4aAl4DYjzgO/pJyxIgWEe?=
 =?us-ascii?Q?S8KVvUaHsVy+z8NUKon7zNabMeL3QSCIHto3w/PINsA2km8UlCSOfTvd1jUK?=
 =?us-ascii?Q?qS7/Nxmmza9ogmk9xZUGaPXG1hoLcz8grIYJ+1q7L4hwqR6sELLfvhg7BkN/?=
 =?us-ascii?Q?88VjFuwkNPIvZdDQ9i5rKFtgfDEb0M31yzK6KWMgqWGeUklrFEFFHGM+JYeO?=
 =?us-ascii?Q?Q1asLvZ1tV7At6W+1qoqKeSu1/3CJripIpb5fWCsr4DY6QnmZIQU5VckAi9/?=
 =?us-ascii?Q?RvmwrzccAkNHDGZz6hlpxYuKMebfH/wPtAO2Lz7hO53+41aZY8dN+rvJBEcb?=
 =?us-ascii?Q?H0GJOnqOsxIusyYlZocKi/oOL28Zc3yLwxMOBy+P/5TjVLSlEn6L1eSgQWYZ?=
 =?us-ascii?Q?6wl1EKkgZqtnUa6u09fedgWuSBIbk3ojlK9QGZQxAiYB3AL12KRBMuJ/GkNt?=
 =?us-ascii?Q?KLHyZxBwEQKK8hZHXLXZ2NtBJrNme8+Sy51yx0iqiO8PFGFVI3Fmvw3t9Jai?=
 =?us-ascii?Q?/8JnUFXcgWSpqvXBMT3TcVqZyYmCkKz+AUMWBuP7FGGkTOCvOiFcLNUOiCbb?=
 =?us-ascii?Q?y7qVkAfRdo30Sk+N4G/hjsQyvWNDtex96AwBztRYxAwzKOS/UI+1II+zemWh?=
 =?us-ascii?Q?7CXoizvjLR+eawo5FI1heghN3wEAUePLa3ALj6YMP7c0+USMJuZysDUqgD7O?=
 =?us-ascii?Q?kwTC25bQhwR/VmCS45dz8wk7HZbLkGQ=3D?=
X-Exchange-RoutingPolicyChecked:
	SmckhipxMzH4vTxcixWnynzwa5+ZPnCvJjlkaGdv/R7xPHeHLg+toaDCfMPWyBrPg48Hx3adcTpZd9BEmU+1MtkXS47oeCaEy9YoVd8kn6hfH4NgN4xdXWKFnLurKQi+Uk7TEvF/bIsER9A/4tOYLQGeXssed03L3rVWevRnfMCYwFoYvTsWUGSjE6LUOCZxtkW9VeadxajMRgA7O79HnY4S4vhyR/JiDPSyT2bXyO236hd74Qwb5pK8rAztZH5fkOhRgBiHT1YeQEmrqAiyw10lPnJbefbon454OPlOy3UKBff1QeWv2T98zBiV2V7yBwlfzE1N1irhW1TigcQGzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4lXBS7fuAUA/SVkETlE7AkikrtZbFBEziC49Fpti387S1Zh89rvsB/bbjb0cBvMqeb9XDoFFblYnMy5Z+7suFO0rKykCvBMj0PCkV3/Q3dLgsrPCoN6Uq/cjQ42GzQgxGZSxJHleMACMTsTWxWqTrXbnaKu/WcMmBdzgPKEReLFMyuh3drAsnwDv+96EkF0WxQckyjlHWEq/y8xf9j2n0vCLbq12z4WoKTAAi0HZr1s0ZyCkPVyYDok1acElufPc1E/gw78l/8IgNYnDc5lk6yt9rh6IQUnnrcpWl3y+Fwccc3uF4bVSza0LpecN+uaZUtldKpFdBiFrAX/QfW7cSyxYPvo1sdZ7aebHw1YVOvVdZK2XqC+d5oyoK+cEU6GffYq6QVl5JCh9IiCvHOOzbRgnb0ZzYTl9Xn9WqaldzOgTiXqTWc27D78kLXunqpaPhtQFFOBRt0iiIFTg6cKqrST6z7YIVCqXbFn6yQU/HSzuqJOmyKbHvXd2nZEWD9TMDTqI+zAOO6Gm2lCk7sUNSIShmvWOixhl5okrt81M3TbUa8pLMXsYdz1OAhZEzPTbGi5yShe296gD8YLY4JavNH42UCS5YoMImKF61wdXkg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e201e576-535a-453b-1446-08df08164384
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:22.6689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtuicyHZpRhiPa/TqvJQf/aS3VaK4sFsWE7bKQ1lS1HTepacoxl/Q3B983X7zYwI1B4MKno+YfuQ2E84g6NWyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Proofpoint-ORIG-GUID: w8iM8dzQTtwGeXjsYUMfT3TvYYSpnoGJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX2W3PIR0lojxp
 U5brGzhPZsaGgwQXLsA/cZZWSv9PI2TYR13aszzYMSrx0JNdex+CPLVVma97SsiQ05PrsriBnGg
 /iAXtGpy7aqNocUFlFIplj+jAA8dsbdeBfK9hG3bLHpPe4V/45GqJTweVCiP/M9uzLd7qiSQOef
 7MYYxa7uFax9BNEYxXj6k7gPU0psAVazlYLtID0cfq0OU/9HZcVESXr3z5onV0EJKZc1mZ5GufJ
 mtOrH0krfRpS0dIBK23r4rFTWVuBZigr4i1ny2lHj1x7XyYe2sdWCJ6pwNRtGSvkEwgGf7Pp9sQ
 VmQnJ7y3C1JjI82PnuPMjsXxEZZv22l3aoL4EUjQ9clrZ7mMPRZKPsn+Flpgv2EOFizcJaAeCGc
 4Ud+7typ1Q7+qWId6JY4+bDv4Vou6ewrkTmm0PyQwfDUnTmzJ1S1CGjK4u95ptliytkxViaSmnM
 g5PQHq7rbn3V3SRtiIg==
X-Authority-Analysis: v=2.4 cv=Ebb4hvmC c=1 sm=1 tr=0 ts=6a96ad04 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=ecQ7zCoEdOpy3JLqRw8A:9
X-Proofpoint-GUID: w8iM8dzQTtwGeXjsYUMfT3TvYYSpnoGJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX+nrWHp4OUXov
 T4Qxo5ycKE9lKVA6UweqbtJJvNZQdMWpPIlVStLFHkOW5/7PGe+16aXT+2+K/HgcGtrJtyhAsFi
 StnYDQfJhFfb209uOyCZL8UTDGjUZsVQY78eFN06nPyRndu1iLx/

From: John Garry <john.garry@linux.dev>

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e549..6847805215bd7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4468,11 +4502,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4483,6 +4521,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4508,6 +4548,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af82430169..22438173ea2f8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.7

