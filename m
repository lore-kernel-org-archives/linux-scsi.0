Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D981DC1AB;
	Sun,  1 Mar 2026 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772327211; cv=fail; b=ncpyAFKQZubolzBnL8YkHQpk6cjFw/4pZYx0HHNxs+K4IKs7ObTgTiLhGKraJ7dmmWQaBUfFmB8q9Tf6K5SyVs92/cgjwc7HrH6Tn/X3u0vFukatZWdZWqXjTyqgzkXpMoQv5KUlpeaE70FDy6/k+FQ7+cPjJnKeENM3zmzmF5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772327211; c=relaxed/simple;
	bh=yz0WYc9a39wJqFAbDcwQk+IPNCxGCTik4rw+XPUP2Xs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ne2O/1zenEl89PgJDPb2iZQH/o+nQ5MY0qdWy46TRlxJSc5jpxfNmBcwS3ewUmruqZKlrsnY2xKzD/8Ylr3aK6nMGDzrwIH9rweONGJQ1m2esbi8c9aHGxb1eNQ9Gi4cMfSXa5sBiqWicGkgmeqMhbXag1N2SQ4GlhdjZHM3r44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T42UpJ3p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TpXF/mjM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T42UpJ3p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TpXF/mjM"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6210wTVV2491518;
	Sun, 1 Mar 2026 01:06:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Jasxm7pu2CuP6ZTPhC
	N/vFBIe+DeDKRdmfbOdI80/jo=; b=T42UpJ3pLp8hRzGqtKHynOiIoyz4P22kl5
	G89/D2YRpjnNkPVRzW1YDUEuwgQMA7zfgRD7VjQK9YTGROup22D/EHk/3ziBlaQy
	kpyjyppuzwX+weum8h00+IHM5aFSQZivdcY33MOL/PHnNx0Xi9tmnXTmMpckNqkN
	RWAzRL8Mp2QNwOdBVaebnMjSpBTpheRR/R5hChrpMiEmwBP5i2PAcpFULSHN9fd9
	QlFDB+3n59bbckG+5Ko50hDWUxcU1D/u4whBoPq8IyjQOrzksGerrlbz2BhdQOso
	xCW0Qnv4+IQIpuWTee2TaKhrQ0F0xz2hr1lacozPRQX/dWEU2/JQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksmdgnym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:06:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0g0F036938;
	Sun, 1 Mar 2026 01:06:42 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7dnpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 01:06:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqpE3UM1rfV3lN3x8GJFLURsOAxzt8WRbZdg4LW+T0BVE+BiiBpDjOgRFGDp7mVmNypCnct48D+DBFS00skAnmvP9lZhQQSsa12VQa/+td9nmQvI6CwtxOFiQAKVFgeC88w9QEbr6lAzCldAL+gGCM269uu9LbZ3GOP2nMBkSvhyVZR2l7GVZ45j5IW9WpSFSres1ZFjoCiGcJcnFz8Nw+SAtggIMAM83PYv1+LSV+Ku7c3wmaqFFNOcDwSJPj6K9iBEl8+fQlOTKZL8JSkuJhy+vEKiHvZ0QNcqXvoq9mtLWnZfou+FSF+1eSwczeO03u3DAmX1n7ZAQYX3ngpUoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jasxm7pu2CuP6ZTPhCN/vFBIe+DeDKRdmfbOdI80/jo=;
 b=Z1hoEECYW7yvHsNEVxWNfH0/yXRXPa+A+ieQWoWNm//Z1Gcf8AStQctXsAQ8FElgUmfaUF5TdLGDYuOt3c5ZU9JD3EvZFOrgvPy2aFgXblu5aLpoiiMNkQhloxtY3A2AeBMCVcKUe6VhMAX1U9laNowfH4UleJ3edT/WnpBDAj/0blxU0kgnrKfOaEaHcgsNYDFvmFIBvMW4UdEzOsAgSKPKefgcMxcF8wKn78O9ANykcVRp7erkrdB8BevYjIFt7ZA4X2XPwjLMe/NyD/vYXVaBRVgvf6ZbDVAfjgeixSf1qrVl9rVWS2mk6uZKa7OYbdWdaELU+owVrMMWYztt6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jasxm7pu2CuP6ZTPhCN/vFBIe+DeDKRdmfbOdI80/jo=;
 b=TpXF/mjMBJqnOcGhcA49oLklkOI7A3An5fknajoPfAQGJIBmnXP2YQH8bWhjuhvk6dLZF1/Br/bzIACdkrOWBAjbDkr27fdu+G88VDlarX/RCNYFmMKjqfAslaYJ6o/VEkMh3R23t/wRXj2mqcd6+hypIXUmlLBs0TgWME9i56s=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH3PPFE06E70EA4.namprd10.prod.outlook.com (2603:10b6:518:1::7d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Sun, 1 Mar
 2026 01:06:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 01:06:37 +0000
To: Igor Pylypiv <ipylypiv@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: core: Add 'serial' sysfs attribute for SCSI/SATA
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260209212151.342151-1-ipylypiv@google.com> (Igor Pylypiv's
	message of "Mon, 9 Feb 2026 13:21:51 -0800")
Organization: Oracle Corporation
Message-ID: <yq11pi42wad.fsf@ca-mkp.ca.oracle.com>
References: <20260209212151.342151-1-ipylypiv@google.com>
Date: Sat, 28 Feb 2026 20:06:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0078.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH3PPFE06E70EA4:EE_
X-MS-Office365-Filtering-Correlation-Id: 21790c38-4d18-41a1-ad32-08de772ec9d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	jfLEa0TcQXSIAo1g4T9UrHoLHLdXIad/ozrUJ+ay+zGCa828lk+8CBtY9mFHOlRXBhqgUhpCnQLxTetn74XhuPYcjKunNY9jFK1oGAc96rQSzwZVHYmJjo/19PimxRCbONCfMlbLKP0mVLlA3IQDICgFMmdZOUcV0v51uND4zfNyxacq9ENMvzRJUF1Xoar5OTFRNIi0D9jhUIasudWyXkmvsm3ZjyIo3qjZIhVlANtvtJAguUqjRgNDx35k9GYec+AosljsTo06y9Zwl3XUg4LUNWdlhdNNgndxohJtLM/MOOHgdnEJnCnnIWJ5h/uPzVCvjzfGG9ZypetoxoaEYpeEck/unYP91Nj8nvuKUMuU+BWdXn+ZgLq+5lt95Pv1z04RBn3/sils90A+J5G2CtoWIlPgfl8ASQJEQGyUFbPmDTn5moYAVOghQi4BMLtjUQa+D/EwcjWGrlCLcM5OXR1oMo/9xpvWg+Z4FK0bU4VynBzcml+ZufX+tO2a3RLR74z3VUrVHy3x0O4StTnho+lezGI+50vMnpeCcfhWiNnxigQW9gC8RkPlsbOWe2KR2wX2EYNE5fSTiYQyx5dLw50N9rdt0GMaok4N9qz5qA76ngCXEz3yq+kdnA+ZRqVR+SFw3J0oiNgikzvaP+92jvEoDG9ii/hd93v0MoPc0IFgPH+gfVuT9dpD9If0/tn4kIkBndrYhEHtM7qErqfydH7RIJ9WxzyooKmJJwk7QNs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5M+7lyfw9VTuRPGBrvByj6Cy4PkDqp9mnFd/+4GYxrb1T7p7n61258mr2FA0?=
 =?us-ascii?Q?6Exi5+9CBk5bWNxV8boUN5TJGItKRgxK66dagV2yLgLP7oXIdcvbRW+wQbEy?=
 =?us-ascii?Q?dPB4w7Zfa+JrlVrNlR3Rs25h1jZ1tfG1xkA41E4ncV6O+oeuYrmTh3lY1fSU?=
 =?us-ascii?Q?0P0XXCMLk+cJ9PMbmM1FVU8IIXA/5BdSl1g8VPZ2DqwKNYyY47ZUWKpm740U?=
 =?us-ascii?Q?pmZb1Wn7dSvXlEFktRv9dj2V/RugQHKDO3D96G1RM1q4AAj1EpEDsJJZ+shl?=
 =?us-ascii?Q?hr8pQ7r4KWOJDpoVk7YJeSAMiyAZcVPQKsIT4fsoTE777x2nRQaIOVOydRgP?=
 =?us-ascii?Q?CeOqlE/VDSu4ca0n4kabKELtSGyre+8DwLr11D5C+Anu8KwGwsikUEk58yvc?=
 =?us-ascii?Q?SwLho5aD6kmT9ufCu7YaewI9P41bDalh17gCBwuiCighe9Bj5fXLcypb48DW?=
 =?us-ascii?Q?LjRT2H8to8eA/4h80lt643HGJIIZYBqcWEUN5nRRyKsW2E87d/yOcXxUeg6s?=
 =?us-ascii?Q?j1UAkkFUiQNlqa1gqaZ5+vD8IVmHzDVJzZEdJ/IUms7k5FX4pZXk86LuBSuD?=
 =?us-ascii?Q?+ItuUcBBWXU3KVCXlliTt10d9NnMKoFh3HiUR2nqDtebhtPlrNOYA0DjRj4n?=
 =?us-ascii?Q?+pws6yGPKcgLm5UXiightRE8CkkbpM8PWJSKgWajtI9S/U3S394CUYBxnQ5J?=
 =?us-ascii?Q?2DUYDA1c2X2FeQ3Lwg33cxfjCp6Br0qDVFoY7CLbINMMqqtox++aKYeZ9gCB?=
 =?us-ascii?Q?8GyDTUUYFJa6iQnbyxMo62ny6i6YWp7tlGtY15eHVQDIr0VNio11DMlyMhSn?=
 =?us-ascii?Q?8cPLdpTkeOQUs5hkvbv4VHaXwJYhGTpVjJAdh46CF2wA154ZFd5fAyYryWjz?=
 =?us-ascii?Q?6Rxx1DR2N8xPcYwKeqn5o+v/VsxsNXo0F6ZtL5xMdwcV4Z0IfmLcUU+Lfn0P?=
 =?us-ascii?Q?2emfhe6YjdG6bHEAQ+wIljph/rRLjBCMOpCU7yE6WsHJDxZUtN6g9SnipLr4?=
 =?us-ascii?Q?EyE9yn7JpNttnBkGNSMXyODKqO2PQRXpeo/D4WYCFDUNuWeHb27M3IkC52Mr?=
 =?us-ascii?Q?Q1gXq3YLGiSUkiwJ36hcviiLXzEA+BJluSRVtcTv1mG69d+lJE1SH7ELN22+?=
 =?us-ascii?Q?UbFWvk6i4ubeB7cfzLi4R4F55IhnoXeXHPzMJIbxl7AxFSi+iArTv7K4aCVM?=
 =?us-ascii?Q?sC4r/G3Y7HXhSYFc1VrNvIcWLIzu4tkCn2lq1RR86GfeQvmM0yODDKySnLnt?=
 =?us-ascii?Q?QP2LaWayA7FFAh5i5wxWRIFAve2pdoQi0Q5KJ2CAkkxVJFUH/AUFVL7CsyaJ?=
 =?us-ascii?Q?dCf8Rukssp58BDxU3eJpaYgzN2dMj8S7Mr6aAU5LsDf5LhqJWTlCNgddsbV4?=
 =?us-ascii?Q?h551BakpqHO8yFO1rqBJg5/yUuOJq1sja1VZh869OIzzwNJLEzkVztF9LLa1?=
 =?us-ascii?Q?Y3UhR8KQi70moqbDEPAKPL17PycKePjxL0RdTByBPwrxsU7ZKpdYQ9LfbtfO?=
 =?us-ascii?Q?Xh6aazeGp+xx+r9jneYBpxZ2Nm2GIy80ITm8uKRzB+Vq/G+PixphSggNP6bk?=
 =?us-ascii?Q?LxHt4x7MuaguIjSGky/LKv0cXcVFX33AaUtIqNwaZ+2JJ4U4CwT1Eaw3dDhl?=
 =?us-ascii?Q?Df7wPS3qXT5dq06J9aOx15ZspBZnxofa47GTqk3sKNQESWVginh5foWXwbx6?=
 =?us-ascii?Q?KhCCVS9EZyihk786xrQEuUi7OA1vZ0VMvHKGXzuzPrBhvggXnPAOa/fiUfpG?=
 =?us-ascii?Q?rAWzWx2HHeKSp3GKbvLcAhS2eyewYZI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KFBcXHB7Xb/oA4oLheeVa42Nv4m8aiJaP8ChZ5b9k+3zqHljLkrAAWk88mrIUZaINkEo9Pv72Luj7sHaar5wVFaMWW+pRxtBvNTrW/Ow2Gk52TV/07TIcXJ88PhQVzn/3Q8USWQR1JjHI9dnrzuhqR6ZYOSc85YWrxfBnO5SxCVMa+PT84Ol5Q1ftrjKtU/gOcRQsYzPLIGiCAbiLdSubQXYjVLRnbDzvUtBHO7nP9AUedztRdRxG7glui7CrTBMoKyQFTgQKMnIl7gURYCgL8JKT+OwxwDWaukkbfsbuzWk6es5wJ7uyMHlsilngoNincl4PMN5uNku28gcxdJ5XwxV8ohRg3FqwuJbE3wplBYDlMRDmnkbKkv98Ki+Zpcl7Oih7+SJxz0yPTNNm6MozIV4lgyBqrGzrLR/XhrIhC0UTjYjtW/xobh+UxOgzrZ2CWz+8u6rB7wAJmxgn4NAJ3V8aF14Vpr+FNWLRHRO4egxYktzT7bOsWmuCkuea1dPVBj4tc0+VESTfa1b3UkxLnH/Wi1JnHanVs6u3rdAiQv0NJA/i9fdDE/SKENPy2amhq/6Gz0grCTxYZjexCHRsgKTv2eIxuPYTN2hn6SZht4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21790c38-4d18-41a1-ad32-08de772ec9d3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 01:06:37.3178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UlhdnnHHDRk6sy4xQRCP6AQ10lB0yJXMHp41IYM3Tbl2NdRtf1XvYP5r9B9NRfxwbTp1jIJSwuK8J9WiPXNN/0YtnsQxIk8auCIZ02xJObM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE06E70EA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=969 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603010007
X-Authority-Analysis: v=2.4 cv=a7k9NESF c=1 sm=1 tr=0 ts=69a39123 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=G6TwHgSKl7pZ8vMjC3AA:9
X-Proofpoint-GUID: oeJE8tRV4xW01VTBN3oZps68SsIyYwgi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAwNyBTYWx0ZWRfX/r0JNnPXx9um
 ElETMtqyaaVfR/j71NGTcTnt31iHWyCylTn18EWnJpH8OdvfKYvazyEq4qjy9nX0QOMo09eaDYV
 XqotTyui6x9lWBQ2wd0oAgw2OJVNDAEbqGBam1f7g0TjqQMntX7HYnFqNR0BG3mCxrNyGZTajec
 753fAR9CygsRM+t64WLQLSIB97RKH0D1FEK1hBI+p5s8E9Dfs120pcTLLU0Bzu8UfS69ZT7K5an
 4zI6fwAkATsm8mwNxWOapn5xYfA1BHtmGg0y+aGKK46LwwTw5QnR1vzEQA6H5VOBR38+oFkzzvm
 sRRcsC0ZUeCy+IFhuBgoGQpmB9CJdX1kunVUMQfOWHD+VDv9TkbOpyawMXe00KBHzryOmLP8aXm
 dnhbYvbHs85jCEzdI7DICMyJfzPc77DuopwOIPOmv2WwgdkKTPsdw6N8B6AaNTC8PgF4hfK02Oe
 49rY14RkVV7tILtk+Ug==
X-Proofpoint-ORIG-GUID: oeJE8tRV4xW01VTBN3oZps68SsIyYwgi


Igor,

> Add a 'serial' sysfs attribute for SCSI and SATA devices. This
> attribute exposes the Unit Serial Number, which is derived from the
> Device Identification Vital Product Data (VPD) page 0x80.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
