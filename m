Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDCD389E02;
	Tue, 10 Mar 2026 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143402; cv=fail; b=nSGbBNKPMQBsrNhO90iXP6zKh9updfVrmFI3TF2+tX0AsMIecEi1VrkAPxpzKaqT3xB9h4mZM5fpdIHnqFnf1JDUwG3pMC2OmD0W3FRN3Dpu4B/8TLAFbxJbsV22qhZ5J5/veQ2LBpFxzWYwcrll86Ap396nHkDnPH2QO5uYwIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143402; c=relaxed/simple;
	bh=kWUiRPWNcKP1mXIElDFC0iqMpqseOvOtaPRFRlx3lRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iHC1ZCf1DgzFhZCrFO8AIXQksB4UHgbOZXh1vYPR5tjs3JOez3Pvg0VlK8Uj6dHQplnHtmwKQ1f956ztiZhiD6Hg0A9mmKowM7OKg9sfxG7XWeeoCChOIndwQ6BQaGEQbZPxvGafGqLUtf/fWGgyjfWpOWSpp4RH1mZAn7PGyPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F9zUIs7U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CPxVZqOO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F9zUIs7U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CPxVZqOO"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9aPk62773105;
	Tue, 10 Mar 2026 11:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LH3iklJTkZe7LMNn+P8PIF+s9ip61wKmfmpC4UUsm9g=; b=
	F9zUIs7UGB6pdo9y3kkLu+zr8eiyYRi96Yx55DjApqju5fxo58+tLiALNrSmpN7w
	fY++FKTqGd6Wtqnj8T0cmXfZnBCLd/dphRPC61EPC2mfmW4WrfpI04i5QLnDCKzg
	iOwhuc0bdxbYr1Xr2euL130A92SvuhXIBFMFIW2OTH/bzvewIJtyV9zO4mBQCI8Y
	8sHRQokoMsbsdC5+dueUydME9ZMPtPIyEyNd0U4Dpj8xyLu/0+l1OdGj5q0EwLFh
	rGCE0b3xNLFRlHGjFM/EiK9z6DYa0yXglYIyoWiGhyR1qCkExY0M0wuoxn5ExP+5
	MSWydEnolxrIzDkcXR8cVQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csjnujpah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ABBqxJ014869;
	Tue, 10 Mar 2026 11:49:46 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe850d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T4eaEjCYFcKRjWuIP+y9hauUmZ0EzhrkVdWfiUP3BHW0CvtFQa+1SS1ZZjBWUlU0BDuQnMk+iIpPY3Nwh3eOw1OH/BRmrORS7bKlUls9Tk28Rz+g4CQ71FHq1SVOqXGUbSmuAESIP3GTkDDh/ME+M8dDArH0AwmIY3WLinuRFOBeJMIrL+9+5R91xFEKfIdjKdpiicOwd0Z4/Fl2vjz3ZLSdzthz6Mu1xuOFCkys09r9aZmFKX7UAWSGpVBeRyZtzxaDnQGFX/G7nWQtSGGqhImTfwpI91X1INHyFO52nVJwvtrSe5oaMnbE7jC82VSrMgLBMiaRZ7SIV4xHZpaMBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LH3iklJTkZe7LMNn+P8PIF+s9ip61wKmfmpC4UUsm9g=;
 b=vBDmZyWpa1fitmF/kDevH6LJlkk8HaPvMeVJ4wwYEaVHnX0RGtvu2KQwY4DyLLXW+v9shFZxDUSxHmjSio5zd+2ddkZW0KJnWn2prYUJLrQYcLHzkqe7N+x/5vZIOzdr9HPlm00BZ3sZ4U/XdgmceFk8BR960T9weqyfXSEEgwuc+zYGMoTuX7ciKgahV8MYHTxwDB/Zz8DxUAR3L5eC7TYqPxqQkOcPvNg8huIIpB6lEBFlxbOFnjasUvt17qUWZZqmBXmNbo0yTVbsHKlFQ98jc0rXgWTwQJ/6c59EoOAwnANFva1vq3MxOy7jCzlFFM06o96VyiXyYRE3xP3uNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LH3iklJTkZe7LMNn+P8PIF+s9ip61wKmfmpC4UUsm9g=;
 b=CPxVZqOO8NQLVLBlwLEAiIya06ue4+nY9G8DA6QIng8s4cHOfS9LyMwoHrd2KOoCENYm8fFzfYCW1gGUMLP/9nVYFFa9DNcp52PVdMJvfS3LicvIGTVQYQh7dY1FbHJtRrth077u1ujvvjWLlIwAdao7NxGOsScE3C3rG8/RgGs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:44 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:44 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 3/8] scsi: scsi_dh_alua: Pass submit_rtpg() a bool for extended header support
Date: Tue, 10 Mar 2026 11:49:20 +0000
Message-ID: <20260310114925.1222263-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dba6de9-2486-465f-32bd-08de7e9b1f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	/KYCGrHOD5Rg4WTki0u7DGaiJPOdk12nGvgreAFhfMdmEmvVlwvLcrZgnL4sYP0utmKhWyeSxuDzkVCJBBW/1Tk0hfq6BDHwhXvUBasm6+9xnJvcRFCENbt2hrjRv1we6t8nfVWLBnXloDOUnskHmKfCnU7KGcgdNuWv8P7X+aWN9ejEQBbUp08uqgu1se4kIcy5H/0NV0b30kysj0TptnFzxWbxK5k5jiEu69BEdyjwfRkMqWIQFT2o1ZtOW3AiKgDYaTA1HnK8zklfwlPj+8/4YUx+DiL6QqU3Db2U8/N54S4v+10OegMRA9fgUlGS3tlTR12vMedspWpXW+BbAyO5Tj/qaefPPvXZLcaHaokXl2yXEb4uxIDGiKQY/6L4njITn+RvK1N/t8FVyAq+1IQ2ohYYezsA6gRdxsI8/IUWl7R698vQU2oH11mLCIwVQiT3b0CGnGmIw1EnszXbMutIEm3NZDBCbEuj8NEODn+kPQbwMm6sC/yE30FprRgWOK3b782OBRC0HPljXCk7WjH+vW//hTfkgXz8oC70TX/mSlFUnMcRyOlks1a4HsI96BK2e17pMEjO8epJ1IzS0Eabg4pi8lzq3sVfkNe7+Bf/T8exfj0zgHvC287ttPTAGeQz3yMkuj1hPctL9imRoeVtKjRzlpgyIQLLl23oQPuZCPGspMMnmtnt7phlepdpJripfK1RaDLUjCQUQTSiWJar8AGwDV+jMtPjw/c383U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iqlfLCLTavzoFc7GvzGE4kwt0SwtgdgenyxMHdzzheL0GSK13rHO2NKuhmWP?=
 =?us-ascii?Q?6RRPRL5K0LOSWyEd9ObXIsqVqrZrqVW9mPOJxnnuMyAATM3Fmi7+BxomVoL+?=
 =?us-ascii?Q?dXm+Jn18rKBmmyKNvayh6RCMbkRSlUKZTE4y9XN+CQ2kEcveG+JNMQGkN+b1?=
 =?us-ascii?Q?tntc7kEVgVsYqUc7VHzUfdELM40u/cFacRjLOhAJqHlLs3QRrKxUdiY1EBOn?=
 =?us-ascii?Q?0ExfPDSiT+381DwuQXByV15HvSJpRYdwId7clxGZ5Dg4DzxdTYIQdImMMElZ?=
 =?us-ascii?Q?6ILs/Prvah3ElPJYlFFUPywG0D8AvDkb+gwoXz4esTbNbjVQxczyj6UqxjUJ?=
 =?us-ascii?Q?1HEdEcgPoLqzOXg5GWP9tl3Nfev+y4vqIa7pHew4Qg6dYhvXzYFJ6D8l96bl?=
 =?us-ascii?Q?ofuOwJABxUZblBneGklyeSkGvqtwiw8kTS0e7TJx2RgMzxvUSYmmusaWPsqL?=
 =?us-ascii?Q?rAMALT6zzfV0BKbMN1zmd/64gR56EqKSEDsNBQgFvA3drT5rZX+BIl7f70T+?=
 =?us-ascii?Q?XfH3nZwcyHwtGXfDrILzKlYkS6RhQjeZiTXbOWyKZktUxWHHaGjAUZeOLZkw?=
 =?us-ascii?Q?4V8GXKUZnG3uNJsBfCsHUtHQa7h74IgUGW998pGUhijtnKRloBVp/K8KmuZh?=
 =?us-ascii?Q?UaN1aKKTHJKFDYBmVYRuidL47E2WEu3jx7FxJLUU30MwTj72hVfn3eCLlYsh?=
 =?us-ascii?Q?YmTHkVwEjI0uBB48MOJtuFloPW5Cglup79AI46wbvE9YeHkYl0FlCppMNjWm?=
 =?us-ascii?Q?PvZMGx/+letaalnI/bZwMoxiDly2Daqthk2S0CcHrrAvyNd6QpVVmPaxFz38?=
 =?us-ascii?Q?ZMIcRp/P0TuNjYEzvmocyCAR6L4bZ3R4P+gGPs0vwDhz4VcTLDOd6ir2o3CG?=
 =?us-ascii?Q?Dc1mrjz1fPvwK7XcB9H8jG+QQNb/4gbBraMXuJ3VvzG75xUCUqjcddKhGYrb?=
 =?us-ascii?Q?R0u2UgkP/jOguTtQY/cFw/ekYfrLWp9dIv+1Luw1ce71/rDEGvh/AZIojJAv?=
 =?us-ascii?Q?6TRrVz3VXdPjV5EAx56pl2UDDEr+Xro5Irh55KmkSsVf7Nm7e/q9LOLTrCz5?=
 =?us-ascii?Q?tnxdjE9U2xovtO3VOu7N9yf+1eqliv+K7fG5PsC1hZyicoys8N2VIvDMNaTM?=
 =?us-ascii?Q?iW8heDGKAiyTJ8w2FwZlc5SheBX3kTk4W135rZ5nbabMAcrygLrSp+5Zwuxd?=
 =?us-ascii?Q?yaRAaBOch3iI/GPSrfVDcOs/quDxvC1ThBNvPk+DJXDOFuLFMO84rti2r9fl?=
 =?us-ascii?Q?F4zNLSI3iRv0KSzF6Cyqe+H4RbmDE8Y0kwVOuQRPJGBdR1+OZTM+MpisuAju?=
 =?us-ascii?Q?VXOLOuWYPEk32YeS78JsKNsbsH/SPcITj9CmMHcpnd/4tZbFlfYHY6nwbZCw?=
 =?us-ascii?Q?EQhNxWdjDSBQGi0QHVQw+vYhKGDCTy6aF6OeyNRYeV9kgPF+re0Pb1athZ5+?=
 =?us-ascii?Q?D5i6/RJ+vsk47fQrMp3dy+Urp38nXZ7xvhHiUxYwhZ7inBupafqJ1Dxxbg6u?=
 =?us-ascii?Q?BZyAX9mChE2n+LiXQzehF4vqe/cfkwg5Nhotl5P1wCdfGTxfx0k3PMeXnl7E?=
 =?us-ascii?Q?jVdQnQ2frS8N37qAniIVx/wLJDpt8zfHY4WDt0iBf7zHTzdyqaA3QPy19qBZ?=
 =?us-ascii?Q?vKBXrTUofBCxzqnK7QD7qpEVjIrriQc79BUMWYjueXf3l0yc3948B1XsLJ/V?=
 =?us-ascii?Q?S0ERi9Vzu+jzbmI1xFiRVi5uD+ogDzbh6+0voNjG/vV9nvpPwEdntCaTlriM?=
 =?us-ascii?Q?d1PIYXsgzA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	NiZ4Y7M1rRbmlr7xiIGYAQX5XL3Ntvy59biY90ajJmhFRiVwNAkeoA2N2sQvrw20YB2Q5uqnhZ8eqaOJ/SjNeVFa2mZNHYGGcoNhK5lOJYn35M1bBs9Inv84/Mpkw2d7uy+QcRhK3qDX0F2lxBVnf3AfA8zZqr83XSdjNkdqx5xOMJK4uysY7OOBxKdj4jkfd8mx+5jrya45mLN8hY4S1QaAxPRk5gW0czDy2vHRwkPgMrRWda7z0LOSHksC5t/FW1M4z0q7ghVbYfOI+eLj/xiCNDTghXRKW+oWkl0ViMjM0lvu7Nj/aWhJH1+1swIZm+WoWLkP8SeZSyeBngFpVQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2kDjuszlo3YeTQhft5bZeWhRLx6WJCf4/TnvbFFMPdsuJysc9IHgWpibBNDkZ/taqYuLNakjfps02dJwo9Np12LVJzfWMqKPOxoqQxvBuFc0S9RYk9RVkAeUQBkw+73kcVWDOl5GDIN5D+BO4ENyr3aNrpG1MaiRHp4Vs3ElD5/4tmVO6wGbfsW8L+hDIB/d+DWMNV3dLtl4Ilf3o/CVKRWcDRcKdrouUaeVXxzXCE0gQz0T48Y3sIv0Igck5wdErnlTGRNak0GO9VCgQD5wX9f4zgiVKecJ6CszS7KegA1A/Cm/1Af1DWpxzcMYEUl2vvG+rcE5HQFjpbQ1ITtcFHTODWZApZ8gPqh/Mi3y4k7I1bCBFQc1qvJx9h1khJRLNj/aOyPXV+KYYT/A5Pv+H6rC5Z5KG9gFkGRXFwFalVewvGnasi/j3Z8HP8VLsolRsNu+z7f2hm4o9E/bPXaGMw5Osuc2JCl56Z4fBXA5DSHfCSeEkWhNiVhN68c7+mmxow8Y8smxj9T3R77eOVMdyb9XyhCoUbH+htcQ9ym2nWkFymjg7HBTd6ttBB9/dIYi6o9un3Otny3AxHy9PMtan/b7lbsy2moenz6nhxM47ug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dba6de9-2486-465f-32bd-08de7e9b1f43
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:44.4337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1y/7Ri9YvbbfGbYC7owIELyOb0E8SgvjEOZCabDQycepU4BAZ6SVzay6R6Ut7m24i/wOwDVrbrksJA3kNxadrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Proofpoint-GUID: cCwA6XPujdBR3ULe5no7SzrcyFZfuJBd
X-Authority-Analysis: v=2.4 cv=c7WmgB9l c=1 sm=1 tr=0 ts=69b0055b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=fg1W8QEykYd3I03PS9AA:9 cc=ntf
 awl=host:12273
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX8N+D15f20HYU
 +yIIpkfLSUkvPg3fDtCOcn5QEL3NALBYWilquFQvij347pULPHIuKXZeA/F98CUbBxQ/JaAwrIM
 EDI/LKT0Ysqx15K7Y5QOkwMtK8bEIgTDWXzyFKBy/u+88XkwgeqeASrCUU/mBtKarcWUnPBgAJD
 J2JbWV0dYyOUxHY6eTKKGDbFL/33FcRxP9EeXoDhMcq7ffMzRn+ux2GI4zA2Z/anK1LXed2c13d
 IBy+a7nntanyLofupL/zKYhIDmSsbfiqsUmywlrWCjcVcyvbyEd+rRcpOgz4cS+hMQ0zeKdOWjJ
 F+1bUf8Jkvr8A0dfCANrsk9VSXpMYHehoKIXknY4u3eBTXptCiXefkQdY6iVtfwE9Rl+Lhzr6T9
 KaoGLyM1qoSfnl3MXTHXXBXxAaiJHBDQNrvMq//nlYGU6assoy7kLepUkkNPKHHN/Nk58cnyvWL
 XRZkStxWrDRSRkeJwvGjl1X5KtbsQk5MCx6+YF+8=
X-Proofpoint-ORIG-GUID: cCwA6XPujdBR3ULe5no7SzrcyFZfuJBd

Currently the pg flags is passed to submit_rtpg() to allow submit_rtpg()
know whether extended header support is available.

Pass a bool instead, as when separating the driver into a pure ALUA part,
we don't want to use pg flags.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 7b360e7f11a6d..e9edd45ae28a3 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -124,7 +124,8 @@ static void release_port_group(struct kref *kref)
  * @sdev: sdev the command should be sent to
  */
 static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
+		       int bufflen, struct scsi_sense_hdr *sshdr,
+		       bool ext_hdr_unsupp)
 {
 	u8 cdb[MAX_COMMAND_SIZE];
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
@@ -136,10 +137,10 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 	/* Prepare the command. */
 	memset(cdb, 0x0, MAX_COMMAND_SIZE);
 	cdb[0] = MAINTENANCE_IN;
-	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
-		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
-	else
+	if (ext_hdr_unsupp)
 		cdb[1] = MI_REPORT_TARGET_PGS;
+	else
+		cdb[1] = MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
@@ -566,7 +567,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
  retry:
 	err = 0;
-	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
+	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr,
+			pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP);
 
 	if (retval) {
 		/*
-- 
2.43.5

