Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7B2623;
	Fri, 13 Sep 2024 00:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187469; cv=fail; b=ip/l7gGJWneW1fRXVeZh1L+kaheuSdWwjA/1fHYT6Ey2cJblVhH+pOiSToKkEEZYkaVI47xduDoycLSMvlqpVpiqLgiH4pL00fda/e45ZTGyq2n3Afz0S7TV9JEqybng+wymCSmr97OLuk1RmdoLkYzQJtv1lYlD12cXDumwxbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187469; c=relaxed/simple;
	bh=II5JbvybiSqyNlLySRfaQEw+q2a/CGRRfntfoo3u8Cw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=oEremBFVmTwg2D6SsTGA9X1ExAvlbqqGnOMXjgGmxF0lZaMtg8RDQs9s3s9dg/BamPBzSr84dYB5hArm/Yu3dJiMIxmO2QtsD8TO/hAwkzTjwyKzUUAhNTe64XhPem8qtyQZ4eqJACbOicqO7XwWLfUVc9SM6fxWlZX3c5ZzQCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kfCY/CjU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h4EV5UWX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfCY/CjU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h4EV5UWX"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBnwc007456;
	Fri, 13 Sep 2024 00:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=/PYFa3cpjD8f8V
	5pogM1jtEFN30uPKo0If8xRvzETnk=; b=kfCY/CjU9ikkCkNKYM+xWriLyesREo
	3Dwuko9l+IFPQiC5r6CKhnxqghq8cjvj1OLjfdNUXkvmv7bw8+jDQzW5Zc61srU3
	WjOBQlJUTVd5koVshxL+u+aKT61T5vITX8z78Se/jjTir9/97hoWawKre2fysG/b
	FXllaHraI9aUy+fV9z/eqglWByNVDWXe9NdPErFBnvkd5DZ8LGijOHMf1ib6mksL
	O8Np8XIoGI8Hhi4nf58+rS0zp7MKGvpBm7U2UkYPdGfkLCIGRwNH3Jb/3L3VTs3i
	MRVz/Btb0E7ZnV1l7xHP0Wug1nVY4vNG6eBOiqEzvpjH8wkM05xMRukQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9v406-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:31:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48D0BwcD032470;
	Fri, 13 Sep 2024 00:30:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9jagfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9lyqD4gk0W330YQcMIlch9dtiAYNbIyccw41/60rD/CKqMBqR+dkctKse0EdR3WvLduv+mGmt57xFzQLiojGkkITm+mqliPjhwrTNCjOPD/SIg/DOzKZjr9+6KTAGlc2XiHRGNulv0i4zKKEpEdR/gUDEzGTa3iNMQwxNTuO1NZ2SK6is9jDIilUYhhjCZUitLBUZeM6YvOUNQECZCXgkDDbJdLKBsjTuslwfBeV9rVMqn84y9AYDHBGLaaDnYZrgGO5N/7VXXnLHaomhym9YnyUpHTuhbLcEOE72qw0dYxQnTmf3Jo3UiJWdp46P5+yWRf23eddMpe3BAJWjuAeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PYFa3cpjD8f8V5pogM1jtEFN30uPKo0If8xRvzETnk=;
 b=KAIzLIs0LSCj3q0bwwNOuDJ3neUV4+G1f75C0yxNi1o4aMp6ouzbe9Lp9WPmr+aG15isQrRMQAQbqYgqK/YK1cIiQtFWRdEGrhi6BB8Wk1Ho4/Rpqqpt3+SHjOZ9FQk+2/hqOM9P+TITfDaHJ+wiGq7Mct0b8jbHnbIxXFsFyIawXuBAREoWPXlOJvVD1JfsrjzlxCns7vvSOUgIBP2Of6hU3sQ2wHRyPNFwzWjJw/neSG1iT/88xaSCk4y7VOd/zvDDU9uI7OaTk7T6nKi/RnMzV/zhkbxcXOO2SV2zXFmIw8sUpiLIE1KvkLP667j2CCIuXGMHTQhkgvKNWky96g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PYFa3cpjD8f8V5pogM1jtEFN30uPKo0If8xRvzETnk=;
 b=h4EV5UWXphAzBwlEdXRhuSaHVCR+2WSkcNLT2KHIkVGztjlUagIGGFz9sZ8ym4qytVUx770qT9LGFTiGvdTdOZMtUIHZCwuYJPAiSyamapcIjwIApFqmZgk1BVSY7mzWJF76F0n+x5RQ0AqWyVWiG5AQsjUh2BEI5E5V6RfW3FM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4485.namprd10.prod.outlook.com (2603:10b6:510:41::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Fri, 13 Sep
 2024 00:30:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:30:57 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe JAILLET
 <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH][next][V2] scsi: mpt3sas: Remove trailing space after \n
 newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902172708.369741-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 18:27:08 +0100")
Organization: Oracle Corporation
Message-ID: <yq1frq4xumg.fsf@ca-mkp.ca.oracle.com>
References: <20240902172708.369741-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:30:54 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0188.namprd03.prod.outlook.com
 (2603:10b6:408:f9::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: 59a6e51e-2a96-45cc-f441-08dcd38b558a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O/wfiQVWhZ0YK7xyX8or1iEbPFjr+PVTqYIu2b2kvFdt0QW0Vbwfh6823R4b?=
 =?us-ascii?Q?tt5YG3+1CYy3L2rM/gz5cK8Tn9cJzhKj4E0/KvCTT7j9zjKc7am9t++CL9n/?=
 =?us-ascii?Q?je4HJ/DHhtxmt78RMU77w/TvShGGKMTakobrn3UPpqKrun5dKwdJgmVgM4L+?=
 =?us-ascii?Q?DdSbwawMOYTCAwo9GwGxqyj460cRbt2keECNh2Km2qNHPud/oV8AszrFiUGF?=
 =?us-ascii?Q?z4xQ3nInPK5hXTUj2JY6RCuQlyyoPgKpAN6Dnq5Q9ETtFV0u8csBHXLp1WNk?=
 =?us-ascii?Q?6h2z0HlVlS2KgdJQKIV+y/mwAl1O8qV35mSqlj9neJI/PMh8LxhUzRUDgQBt?=
 =?us-ascii?Q?3RKjQBXY6WF6/PSlRDvJVfP0vLdiU7O8jDLbqoKVyPEw2/FmddBSnHj+rJVT?=
 =?us-ascii?Q?qFOuAOJJbMGRgw9B9eaebVLEEH72TUdJYeTDY5cbnFLmyqhiKsBuZCOPXPYz?=
 =?us-ascii?Q?Bxr1TcjVkAkVfV3bCplbFFbFz1kp3y7Fjge67JGGYF0PqfPHK+BpVRAq9ybZ?=
 =?us-ascii?Q?h9lkPh7/yPHKFH7pcvl9izPDLl77zN6QtdcQxF5tMIlRqI17QB91mW7tptFb?=
 =?us-ascii?Q?Y2cBAwoQsUi/HvzTx5iBtnV5E0w0wb0qm5Qx9XIFj2M5R2iEQTu1EG3w8V47?=
 =?us-ascii?Q?0cpTHQXOkJ8R0xotSH+WBK0TIE3oNX3K+CRjtxrtQQ4Vkv9VrQfgnjmqFGza?=
 =?us-ascii?Q?XWj9hAyhyGC04hVwGJ1ms1Do80xsm6Hg/N3p72K4BlkJhRfZFrtW3XLoIKrM?=
 =?us-ascii?Q?r9WWSuggBVQjg8ollrjTHmzpDqV3muWp9VkcpDUkQEdiERDLywWClUAc+dbs?=
 =?us-ascii?Q?ruzxXPdRnZfXVCRG4kngW5pjRr6QR3kBB1MWYFkpI4dkwOe9f3dCYRkly/1u?=
 =?us-ascii?Q?ySBQ1RLU50efsTqkNXKcKaIFQDS2fS4pgMv5MGngW9gdc5Y6BlDo9N3YyzE9?=
 =?us-ascii?Q?xQk9RL+JzQntzOtTI0ROlvnZMkb8df6rzuZVj007NsXUSv75y/9AD8vo7Cjj?=
 =?us-ascii?Q?8969XnoadDwqseH5+Bl0u5IjZJVa411LLdGDGWVR2FoSB5/RcD7dL05SnbtJ?=
 =?us-ascii?Q?qaMvQuqpRd6zRUgbtLk52uKa9NNbxuHzRwFDdU1KCG/F7/xkBLVHERJOSSge?=
 =?us-ascii?Q?uRQQV5F/WlvqUym6LXcdmT1W4GndVMr8UJNCzsR6T9+aBzHLxrSGq0GCegTK?=
 =?us-ascii?Q?f57+csbz8hin7yoZpxt3OiUPbuop+KKTgQeI7YAEXjJW40oaOuJM1mOXEWHI?=
 =?us-ascii?Q?jJt++OEWIzMnoKHmNupeRWYmkpAzr23LDcPisd6HLxLKhcQ3i8FI+wH9bHwq?=
 =?us-ascii?Q?VrseNXVTSF5glHJUumq6abA02zIfSTZC/0KKBdCOyA+zTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HEZNbM6+7wVlhR/pM9NBGZX6LOqhwZliQc9HftXAck0Y9QTpKRTOiLkemWL6?=
 =?us-ascii?Q?x8xVhGfmPRutqs6JKtVsA5zAz+ktF6+HDAOR7c4bGDqwAzMkQiEIsDwF69XO?=
 =?us-ascii?Q?xLJpurdWdbJ+RCh8NuRIFfhR1AxfzuVdB9IGKtJe4suhGyOCtAqjnWpcmWmX?=
 =?us-ascii?Q?WU7zDBk2bhiMxvNVY8hpwk9RmMHQjk0Sx0/9ZXSphGFHopA17D0Muj8BweYX?=
 =?us-ascii?Q?arTDI3L1EgJC3juYWBrKLuwngRehy4UEt+TqfItH0KEY33cmSqbbZDND8sXK?=
 =?us-ascii?Q?lm0/KtZxdQqamv9tyBsxXlVzszfy2urSuiYvFS308vYk8RP+Cx3JHbIFq1L4?=
 =?us-ascii?Q?O05OsF9yYFqiLSmezWat6CUGYfHMi71BSkY/sKkEiDGHSlIokfdLSQo10up/?=
 =?us-ascii?Q?W6Z4/jbhQHbcInnkkl/7CCfxTFskYGScU3Dhs+AkCHrXu/cwLlDnRIdEWYdn?=
 =?us-ascii?Q?QdgNzxFSxHpnp3eQoH3rSlfExpmTS9xa3kD2W2tC7uMq1/z0t/qio0eJ5HdE?=
 =?us-ascii?Q?3NUWh6zSXWM5rlV540AxLRNhBsnqUbHTwFfTp3uvgUnrp1dAP3lDP1FBTQR7?=
 =?us-ascii?Q?taxnbJyxRhkOW9p8AXziBnmbbuxy1euei0Sw4WhX3dYTu9Y56/9LGD+RshrG?=
 =?us-ascii?Q?PUbrSo8jC9ptIPMBoISM1fBIUNonm1L4D/EByGqagPT9GXcdGslsqDtwkmWi?=
 =?us-ascii?Q?ZJnzyhFzxEiqvIPzLoV7VdmdJfQR3KrEpO7O97qG1Hjk1z3Pi6D/FkuYlXlk?=
 =?us-ascii?Q?MEWi6KpNSxeDtLymeZgX5KChVN5advglxw3S/wzA/dc0ZKZssYdPoIYi2ZGc?=
 =?us-ascii?Q?2SesRcRB6ATNbjgYAQ9+s8s3UFkjaZSop3xZs7lmSUT2XrjZv+Xvf5IWc7+t?=
 =?us-ascii?Q?k3/PvQEhtX2m8Be1IeTIQ8aZFlYgz2ogDcb274F/G63AnG0HVxjvhhpykswC?=
 =?us-ascii?Q?6GFXpZ9MbjLnqlUYW/BxgTlkNVvKa1Dx5/vFMeP6f6gR78s3SwRV6tgfTw03?=
 =?us-ascii?Q?U0SzIZHveh86kqu7gJS0cN9c2eGLH6EcRiVx2nOc/YoJSJQ76oq8hCiqyCpU?=
 =?us-ascii?Q?qtuT03oY1ocI5qFVPOi6v7v5Fv7bJBt6jdXza1cmE5Z0RERSA5tqovHbYA+6?=
 =?us-ascii?Q?z/tWD3Mxund9IoCRfaNPHps4unPBQI2wj36cZhlRzEJH9Fi1hWoXHp/MKm2o?=
 =?us-ascii?Q?RGTy6tMl8PyHVChsGJ/YcphIWUd7AnD8fqHBKg+QtJ/Phgn9tEsBsSITnHv6?=
 =?us-ascii?Q?koCr3m5ko3tmaKDIZKnfR25kwMhDGlrpSLwx9nXlQfeD3/RqRUZcGiqkEfJi?=
 =?us-ascii?Q?C6F6V4FUKq9NfMR1/6YBJY1FABQeB7/1W+l3MHSO6hYPsSpTwl3+61dyPX1k?=
 =?us-ascii?Q?aA3XhtaUlHZXJXr+XvXGhSea8aI6myoIjxghG9lzX/fl+Wh9dwhI19JLphei?=
 =?us-ascii?Q?js9BUs+PX1mnpB6cqUyMhLyPCFEMpwcKrlXbTaoKf3wnFl8MsgyQ74nWDSQT?=
 =?us-ascii?Q?uzBCXdmKmfURpT9mFWex17ZS0TrXHEOfyfhd3H1IiGZB7fqcKVmSKGdxV+Wa?=
 =?us-ascii?Q?l2wpzfFi+o3wOgzLaPsZahozQ8AzkmE1noovrPS0FYm4LDiaM47/lquf7DMe?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AouiNVt79A74qLtZdtle/b3a6l3rjdBqmp9rvKXB5gCwpOZG2iOBEetr+OSk66rkG30n2lfNxY7FV4iNY16OGDhR1nxPb/R318g595st0jogUyLXbWfBZe3xJ57VjNVDx7XN3Se8ENLpQghTv2cZULfXQXhlY8MD2Oar/yvR3kPatRkAxC1itcH8R/ZGC8JF6/X+NHhlnO5gEeqgYczX4YG3YzNFhWDECe/y52J4MLb7+dbArzy+2MaV3O4LGlkMlgcLdqLmvyVUtz0FI51OGE5lr3S4rL1oaUvyfsq98EN3vk9eOxWEwevW9WDKVe4UZkU3mzl//jsaMIz852EKZZJ1jOb31JbyLIdr06pdAtNX3fLCid9m4fMHdSYNY6Z71RJPfwwLqmjS/DiD1QA7PX3joBpCXJ+LHAfPKdr6ijrsavYX2ZD6UrD0/tv7uEKvY1Ze8oPAoSAF8iAc354t+k3IyUS8kE5gmnNn2Oe0DRtK9A9scREknJFA72G79CRbs/E8ond0W9R0kKzYFOAruCtKU24J0pBa7q57ekSedlOBgYpaj44fCOh47wUFqLiprEBU+X/Fo9mzi2Ab4fwImTVjyyUxd/aQFVoyAKvpK90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a6e51e-2a96-45cc-f441-08dcd38b558a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:30:56.9748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ks08xVdU+QWaNMcen0ZE9i4ub7AOSKwLGEQxTUiOzWMZ6abYE1w3AU1yQIAvbyycQOybCBR/n4skesmy7VZmN0Z9qLf6GR5ubw2mJC/FoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409130002
X-Proofpoint-ORIG-GUID: H0JOft0Asj0q_FqVEv3UJc1xozCad8vF
X-Proofpoint-GUID: H0JOft0Asj0q_FqVEv3UJc1xozCad8vF


Colin,

> There is a extraneous space after a newline in an ioc_info message.
> Remove it and join to split literal strings into one.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
