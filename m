Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C0F1373;
	Fri, 13 Sep 2024 00:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726187375; cv=fail; b=dBmtGZ9x5A55ynuoJuITFYWOezr/j7UvHrovGrCQADIfyTaQK/HCltHSDxcFWqaBmyE7rdOUdBtWhR+ipyWjmnaZ942u31yWaGdqU/6VuoQu5N5tc2MDZo3p1aX9isbZOzll3nwdXf1N6vMJhDeD9+3p7pPhmaarsk2V0TGdENE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726187375; c=relaxed/simple;
	bh=dPnPTwcjF6BrkRSNtWFkcbeuEpIzdqOKYtWb9/9QCNU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=To0vhYyP2j6a/bQFPC5peAd8NJz8Lf4e4WFYyTcvhQJdZnoz4ESeSWYiGSBqbQRwZALixJODoBJoLLGIvcj2G0kLNbNODQyMk1wIK28FVArSgaIFB4Ya1SFZC9a+HplKLiddf66fu/S+2U9x1JV3yD/it0rxy4dpRqbbddq6Tf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hoJ76b94; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S2HXkXS7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hoJ76b94";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S2HXkXS7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CMBYgn023293;
	Fri, 13 Sep 2024 00:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=a2bf9TV3BlF9q/
	0RyUSYxPI4QbNO8z6vPn0bDiKkTNM=; b=hoJ76b94pM0qeidcVnjH1Me9NrCpN5
	B8Xf/6M84bLukDusCeiea3L0FvVNAJfc6WB5jiQGSzzaN+4Aa1vem7DNmRrbz2hr
	U85eNdl01sIGjBxH0c/DIALbFVAfedisjy4M5DajSmzQqP15sRs8yjiJz8YH+w0K
	8dhKL+ys8b1hJ3a9qZPVMRf4MYMMuVxs5EK1Eo22YWr+vQpJhfXal2enIqubfqEw
	3Co8NST3BKrXZQoVbanRYLLCoCnIJaRAxOvWPFxN8ogEb3yEI5F24MD8TqXGNdWT
	qSkPprADWpeZauFxsA8UOdpN5HyCgxqBRP/sNhTAUgYvm6Mekx+gHz+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gd8d423t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:29:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CN2ASH033581;
	Fri, 13 Sep 2024 00:29:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9c0aku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 00:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TptmTYSI39LWyWjNvMzRLu37ThbeQ4isrIS2dVObk2veJrhfqtNdHjgxZH/uyPSBsGQaSI/05u4FkRVNz8QGuBSAHuYtOts6N4UdQAWuzIvuXr8KE+GwlWAw54xQjn5Dza6dBiSW5GSmpbndoYYYp1F2zM4xaeQ/2FHyEVK2v0woreg9CG88B8QUYQ/0qkeO5oOFKasjrJmvOPNTC/dp9e2FsytrbU1DkBtZ47bc2Fakwe2Pvkdqu96SIzlAdqJJkGInHuhCfsQJUVJceepy7BjhZCP+sUKBVfZXKihXLPxfYUzORk/C2+r0GstGRjazbDPZSOprS2HzUlZt5Ei2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2bf9TV3BlF9q/0RyUSYxPI4QbNO8z6vPn0bDiKkTNM=;
 b=WNh+2uEDR2pBch5FAMK6J6HMrnnScEImRIvVh7hWfi9sWzNyOEOJWKVMnRQqvLi3rYhPUVmME+R8zQqEhnWuwDT8UiXbLrrdohvOMkYUZop+QJDUmUiPEqi5XHUGzBF/IJPibEvS1o0G0pb5nKJ0oJMXji6ouJqr6pXpLFXHrCxeXnjb+iWcvT6QMvppsuViuHsAErVz1f3IjchVX7/c7D0ivtv7IuOb289/rgMmIRmeG8fUk1QRH5u35ZCY5RasGDq9FpxmYglCuiPD4YqOtpUr1lPUjGVbMRHlAN1EVm8ZYvYOWbfbY3d90p0xQ0MleFZdaPJ+OdHHVqdaMqrfMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2bf9TV3BlF9q/0RyUSYxPI4QbNO8z6vPn0bDiKkTNM=;
 b=S2HXkXS7hVcEB01ObZNk58uJaU7rMqyCV8BJlKBieItJX3TAlzi0X9OMsewYquJbk7/WeAf0y0R/UUBBFehzJuv8fBMh3uRhCg+tNHpjOMzW4lgtA1jzyMnL9uzWAsxnYUuQmWr82RH67ytiHcvSKhvF1MTfNs11JYaewejZP+Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.16; Fri, 13 Sep
 2024 00:29:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%3]) with mapi id 15.20.7962.016; Fri, 13 Sep 2024
 00:29:26 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan
 <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E .
 J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K .
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: qedf: Remove trailing space after \n newline
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240902145138.310883-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Mon, 2 Sep 2024 15:51:38 +0100")
Organization: Oracle Corporation
Message-ID: <yq1r09oxuoy.fsf@ca-mkp.ca.oracle.com>
References: <20240902145138.310883-1-colin.i.king@gmail.com>
Date: Thu, 12 Sep 2024 20:29:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be8b5fa-9113-4417-3aa6-08dcd38b1f87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zQNkXscoDIGBZpv+uFCpp/iP8BEm/UyHGsHTtDPR29j8Ps8HA2BGvzFdjhAl?=
 =?us-ascii?Q?F8V0U6DJnoE/TjcdDv1k7hC/rqkc5zaoVhVbsWZqyxmg2bFecr68zkmmYUxy?=
 =?us-ascii?Q?XMbnHDAY/NZYC8W5ybCxm5sA83njH9Am5S5B+WNviKbBu86EZKnlETeMGLnS?=
 =?us-ascii?Q?AMgPec9f8Zivt/khguEQMewKinCnAPn2yFpuOdhZ5K3oKIpDkiypKuB/RoPp?=
 =?us-ascii?Q?7YPuPmE3WF4Ci6PYaDm6mPYF2aczqpAI+P1SGhLEs/GvzJnoaSwU0U5+bwkj?=
 =?us-ascii?Q?BtbDCL+LU5pfD7ji1gaRFTm//yLNuw6RSYtKw6LmVptFtUr+9RjUqHfMNqUb?=
 =?us-ascii?Q?/IQLe0z392ZcAg/UjQOLF+TjKhRC9ucp1hGltGdp9QJfHxTwoPsPinteDPh3?=
 =?us-ascii?Q?JogAmxOiyL6BA3MlGpgF2i0Vcsh1q6Yrt2ptEhmcHFETnpIS6klza277n9gB?=
 =?us-ascii?Q?GXnw8iiVz+5vlESo0IshYZZfZXyhZ9l9AjW3j23jfP1ec0RnBFcoyKTs55U1?=
 =?us-ascii?Q?20A0NSl0wm1q4hgDTJ6a/OZ3wkEomz7/hmsVS2gPvtWdXMu4TddJ20BpcdIP?=
 =?us-ascii?Q?EiXgm65YoUJkACD+Ivs2sBa/zKqAWqOirx07BLwvyurQk/kco+8JT9unKVKg?=
 =?us-ascii?Q?3hz7hTeeU/t03VBND17jWGkyBt5k7j7mhjuTTvxMWtI0OY3h93/G2DoZIZVZ?=
 =?us-ascii?Q?JOQ5HnzuNsqLaXCbzMAZvS6IDgr+47yoA5MDgEzISm4KelpmJ7q1sArl3Lcg?=
 =?us-ascii?Q?Ivc5dn52YTGNmvgQaoJZJLdahWaFCQxaVDFpKdeKb4EAyWFrVpi5vKNjqj0N?=
 =?us-ascii?Q?l6+/yjTyfjmMKKqSD2zZKzxvowhzJ/oNpPIhKgBg6cUanhOieWs4V1E4VZla?=
 =?us-ascii?Q?zg2+CyL157ROK2ngMuYu32Ns0Nn0tBXelG/GHPhVOzeWH2yU8Oxx2GyaJNSc?=
 =?us-ascii?Q?2GL/Vx0w8F5ty/q5urMEw3KZ6krb7TwX6I6wg5gcGxoaD4b6nBUv3OvUcWIP?=
 =?us-ascii?Q?HZUFed08R2AgLHblm3zWL2Oxc46SzRUUl3mAIRBEvaZeddoRffFWkEHdQZ2E?=
 =?us-ascii?Q?f83c0ExOpnoctkSosmpoT5Dd8O4LDzv+5pZa+k4VB3Fmfolr6RupZMFgJgaL?=
 =?us-ascii?Q?nwjBitAMIoOfMSP9zope2nYBx5PD9LLI/54NwfOk+L+4qCHV5iH6OyeFR918?=
 =?us-ascii?Q?yoMQRNFJsjHnvMAlAzhlqO2YGM46cyGe5Glwru+YWYUNITiCecP3RP/XKMBd?=
 =?us-ascii?Q?GaN3Td0rdOTOhztr06n6VqesI1u4wRGUCLJiF/rVZrGsFc95frOxtaiTmNQ3?=
 =?us-ascii?Q?lK0FLB3oaaxMqCM/m2tyFjcfCrlZLJWt60wQY9sPI1pziw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sS/Jl3OwHIMD0mX6bLjWzLyArq8CyZaDN5uJyb3f1whcYXNH3ajBr3aaRpYX?=
 =?us-ascii?Q?+DJXmCMnFd6tHGnNot84qQpvCjHLbV38amzfiW2b6hW1yqoGTD88v7zDLZWe?=
 =?us-ascii?Q?moJ4rNob/e5el6m/5SzEKEaP89f0cME7s0EVQ2foCx4jLGiaR+UDop6xNzup?=
 =?us-ascii?Q?X3UonUUd4InTvETS6LZNA2fMq056MJiRM0ltA6yEpowBRv2qhm6n5J7mpNzW?=
 =?us-ascii?Q?AJsiNLFTNwSVC7migECf0IH5htmeAhsnuyIJhNsTOFuQRHtO8c5WTP21StzF?=
 =?us-ascii?Q?2Gl8bltPujScNUfNaojj4VdSSfns6eXTlC78tvII5nrxPnUry+pj4ebYZJNJ?=
 =?us-ascii?Q?ptaLUr9dek5ccGd0MBQ3uSy5RdAKa/1xSnWBK9K+/Du5P2YbsnMWlf9c9lVz?=
 =?us-ascii?Q?HuWVee3rOBipnhA7Kts6EAe6EZaUjG2AY7pi5Mowp3u4l2qwUjWayDsGt+UG?=
 =?us-ascii?Q?8Z1H6UUQJK/WaAmktaaGvirkLKs/9PzT8eFmZUhrOdx3B3VB80Fe3CToa3TJ?=
 =?us-ascii?Q?ADXUMkSus5JrVWNOmfdAFO/Jp6pZ86uTJ+fQXpIuIbCecXZMCLkUMnJSfTHW?=
 =?us-ascii?Q?PaCx6243RZYwo+yPrq7xQnvI7bVDD3Eosj0icVpybbgFhunBf6IhsS9BactF?=
 =?us-ascii?Q?iaH9qkV38jGykMSG5nL7brzBkcVtZ4CQZBoNlCixQvZ/oJpR0F80mM1FLcC+?=
 =?us-ascii?Q?feE308TRvB0r9bnVbTiwuIGD1bCJO6BmsJUhsGo9jpayHSZstvbcXrwz+e3a?=
 =?us-ascii?Q?WuMs0gcpx7vYljiFGhmhn7mcX0vEZOmw9QyX59Q1ZzbXhpOSpg9JAtCbomRM?=
 =?us-ascii?Q?7nF7BoD/EtX3kGfXz3X55EqA14GSZqKPYJrZzmL664hukzmUPHBa+9fWcw6I?=
 =?us-ascii?Q?ldOwgciLpzn3ONOxaSyvDOtTLeoeW8KznSy6xtIQ/3ndXuKfvdgrvmXvYwSF?=
 =?us-ascii?Q?WcxY8VR6hHuYSQcEKFLcLW4L4gE5ST3m49od0F4KXgXE4AFbpg5DKeMusXGm?=
 =?us-ascii?Q?tdJCJjpMWsIpq07h56seOchE8MH9O6zuYtMLaqniTkAC4RmOyMAvdPHKIKoZ?=
 =?us-ascii?Q?LbMXKVPaeRptDvOYP856DMxD4T64ukuXlIz3G1jOzs3HoLDo4glXunaN4e1/?=
 =?us-ascii?Q?XDvAGH20vy/cnHUUIBnKcamjQLzf6drAmzY/i1+jdO4vby/M8DeNgITDathV?=
 =?us-ascii?Q?0s0igPnRbxeG1VbYvpnNBOgP9hATu0XTMchitXsyv6/IOdd94U2w4bX0z7ad?=
 =?us-ascii?Q?KnLNjgfD6fjKf+HD0FdbNpNJ8n8jcMivzKE2EdVp5QS0FovAHWq3GfkePxZ6?=
 =?us-ascii?Q?7N7ZmIHKGqb2po5ZFS530mjPJESG5crKdogpAwyWkK2kzGovYkmqkyY6Rqty?=
 =?us-ascii?Q?eZNOEwBxql1F8f6YS+fMrDBtJ5hcdl7vQMqt0CrMJAajJrHC+K3GL7MHTEEi?=
 =?us-ascii?Q?yr7F10YNGWsgxl21bpShXNEu9YytP4csiPGH2SmTA9P6W2/gf41th1Ng4JTK?=
 =?us-ascii?Q?PllNe0XVj2QxesZj2GcOer2yZqFVOx1Fju9dUELGajZlgMs1OA8M/IGrlRiV?=
 =?us-ascii?Q?muTBDY8BoFfaI28t8P9MPorWlJ8JpI3O2HOykCv8brXcVy3LTYoy++ld4TAq?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IBSAN1MN2BHECHtgjrluJC8d9wwUkWTGaqOBGE4/k7KiC7yyQ3yTY8zbNRgCJoUz5ll4jJpIifTTY6fk9WtHlLZcxDzbBDFRAQQikb2NNunWX5gx1zXLhGaO8qdp2ejiTZKZv/c5kKxNIW76sgcEZvTG6ZHRk+SBoG57R9Aoas/ond5DWW9gl0SmBHk63TihreX1RYYHfBTeJ8l9IR5FR+qbI9mFYGYri2Rl57GHh2FPZCJggKgsKw+7FWwTYQAuhLH02PHeME09QYPxKtKfkdFCUuDUiZyA/e5JM3dJu97JPAQImn1QnFGLm62Rx4YCnqyx80lg+mSGHzCc+/t2ytLhR4GB8fvRUJMB0DbSSARSQdRNG0ErRDgcd0L+CErKNCgEmowAxYp+ERrogWA16+tasn5JfJUbRtLIZjHUObGBwKSBug51dWNGFzjScRfMfP1goBex1rXVb6sHZrwByiqddMqaXFCd0dnDxsWlUf0CgVtg8tB6PhtNmT87IZqth6q2ZmGEewu7ZsssDnx4FPAmYRaNJIbWBbt4QHno4vs5TSTUsKUhKoUeCydLYH2TqkDket7ezoNu1kc4enPW+L936ngAH/H8DlhUQPztniE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be8b5fa-9113-4417-3aa6-08dcd38b1f87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 00:29:26.3554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/r0gefu+/b65K5o2zQdp8pGgcCxKURjb/W+GxsW47iibK7wVJwTvHNMXtZdbpuBFGi8uRHIig3Wm73KTwxFYmFU7EgcdunM6WBzCrj+m2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_10,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=886
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409130002
X-Proofpoint-ORIG-GUID: MADXY2UyPGpbljfStpW6JoMUJsPvqDk3
X-Proofpoint-GUID: MADXY2UyPGpbljfStpW6JoMUJsPvqDk3


Colin,

> There is a extraneous space after a newline in a QEDF_INFO message.
> Remove it.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
