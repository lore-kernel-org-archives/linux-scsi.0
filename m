Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6734C33B6F5;
	Tue, 24 Feb 2026 21:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771969445; cv=fail; b=WhRXP5pghoeUTijalcpT5kzYA56GEs9lGWPxAHe92kDJjfbzEhKeGqb1/e1CtAUpv1L9wpuvSRGyP76QSifp+TzMcepRDXaJmO1S13yf9bKYk4YFrTwdKKqfqyr9D0iQ8lWbTwZdH+2fA4qRwi11XS7d8QHQL6GsS3DaTNq5Rwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771969445; c=relaxed/simple;
	bh=oObKCNyliwSa1HEHBgpmPo9XVQU9jhhBgz8Ue2Vbrj4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uZKcXp+iwCqxgdSGgx52y383o/LUUdwlHDs2xZG2L3uUZJl/Uj5E4wk4ajlgAEyIInqUwOv1PVyRvXnXBVUfhoMs9lQqJnIMRg5dDtjdBEDvhTBGbS55CAPnPTZ1XMl7Zcxd2/1nYPG3wEhaXy6aoULH01ajQi+FMBSnChet6GQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ozAb5gRp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jaJqsJ1Q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ozAb5gRp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jaJqsJ1Q"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIu6E2369450;
	Tue, 24 Feb 2026 21:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EcJy+5RtXyZnFVz0Xj
	0t6tkl6LVHYGB8Fe8tzS7jmaA=; b=ozAb5gRpLH+Szm/TdBcWZsNGZ5d6CefUI8
	8BdePqYvwqdOZBAlaX1yY69sMEKn6vrRIxxy8M3HFVq4vXXYYmSbTgvESF2qyWpl
	uC31MUDIB407pF9AZwn2IErcgbnOMppy4BDKqCC4OcFxT7jLyu90OK8C1vNpJ6p3
	A3oLXVE9iPeZ4zl3dBqGr4/B5P0sYfVbjtoFtM5XfoIF6320YUgAdJQumtawTO/c
	fXWuZGi/zVEr/jSBwM5UZvLhiGjzRz5axZo7Vu8sORaLT3Lg9uW0o9gGQROYZPFr
	IidktKLTA9lr3KeUnaBdFFJxDQk0A9jrT7O4uZ5FnOzEJcZIbPjw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5w2p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 21:43:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OKQuYw027863;
	Tue, 24 Feb 2026 21:43:29 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35f9af1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 21:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BmOskUqX49qFT79A22ccZqY8Pik6oIuONE1KCR21H8lDvGTapPziL4bqTLu/YGeqTC/FfjBf08fM16+e7OsU3DRMpHFeGbrZo8naQb+SEyAstEeHGtkPnraByKckx4Y4phzD4wVkDpbDSl9hxRYtRTVBDXZFqq55A0vSEwG0uHShihF+o3d3CRzf99oDSq12i24Bc6rax0Y/htrhLIc5kIoYgSbgDKGsvcS5af4nUQpK0iVjp8zRpbY+EoFMkDYuAktsFKkCl63QKV6zZYkgR1kBaMmVqpGgwDvL0oKj0SbEolWugByScN61i4ONpVTZohpKHVnxwxbxT8r0gPwEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcJy+5RtXyZnFVz0Xj0t6tkl6LVHYGB8Fe8tzS7jmaA=;
 b=C2/BWf71VJJczBNE3JZhxilPrQxAdmika/TiJzSOgXh9224EhFeK2V3VWr108bFexfePB1H3dWutDtgi7C0Q42bZwO21g+p8ggC/QSC90epWjxGFIzqp74R7BE6l6Qm0fDD4QS5luKZRnfzFYgObhtd/7rqQaxu4acaa2c0cyBQgRdGnKwhIBSNt/4JvH40wgKikCYIAxgx/EdiE4mRMc9kXolHdAuTOtuSO2DkjljyK930ReyOkB+xyHgk3U/3YiqOqmitSYZbj10bwp2lZLFj3CR91hZkdKb5SUPk8zV3RMhkiw35Ez+Q5wRF2/ruXMCQmfkJK6g/MbUd3M8bJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcJy+5RtXyZnFVz0Xj0t6tkl6LVHYGB8Fe8tzS7jmaA=;
 b=jaJqsJ1Qfbff9U0o0UQmYYPvk2X4m+qVNDPJ2fHhXUTNA3b3bLp+Qq20X7WqBAix185FxoUSVEvufnTvtGcZ9qu2GdTGA6Om9/EX0BvClpEjcCfNqvoE6Pv2St305k2bkPOzYcOhbltbs8fl0ji7bP5mgTFxpCx4LJTrHPLSiOg=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SN7PR10MB6451.namprd10.prod.outlook.com (2603:10b6:806:2a2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 21:43:22 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 21:43:22 +0000
To: Bart Van Assche <bart.vanassche@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
        Waiman
 Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
        Marco Elver
 <elver@google.com>, Christoph Hellwig <hch@lst.de>,
        Steven Rostedt
 <rostedt@goodmis.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
        Jann Horn <jannh@google.com>, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela
 <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 29/62] fnic: Make fnic_queuecommand() easier to analyze
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260223220102.2158611-30-bart.vanassche@linux.dev> (Bart Van
	Assche's message of "Mon, 23 Feb 2026 14:00:29 -0800")
Organization: Oracle Corporation
Message-ID: <yq1zf4x6cnz.fsf@ca-mkp.ca.oracle.com>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
	<20260223220102.2158611-30-bart.vanassche@linux.dev>
Date: Tue, 24 Feb 2026 16:43:19 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0108.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::11) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SN7PR10MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 630161cf-4218-40f8-6c2e-08de73edbb31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ky7LMi3QfH5IvcwD43gxz7P+ICq+wD6EhavkQa5DzJ5C2VFIaG08SXkQkV3L?=
 =?us-ascii?Q?VObBhU9xaiYikL9F8HUmUNBVD/7FGtbQMfhUOlxYsp0SA9HCGDjufHwbjowl?=
 =?us-ascii?Q?AYu26BNqAw0LnNkNqJyLUQe9eWLxe1gfLoDyxjSw88G/zIcNdHAzSx6J54yH?=
 =?us-ascii?Q?y45JAO/z4OgtVfzPQgRUT4zDff0A1kLxFjkxcAg9mj4O778iWaoT+mCynM2O?=
 =?us-ascii?Q?LTyUn56iTOG7NSxw6NCtQ973Wt1mZIkEaNuu93jh0pJ35OrHTEu7uiois5wy?=
 =?us-ascii?Q?y3PclcSYBqzmeBJvfCwCpNJEXJ/Yrs17e0ykCxdyM9h9fzujoiXTdzzJTKMK?=
 =?us-ascii?Q?g3RxtyZL/DIZjCQL/x+R22aRZyOlKBpjto7grC314GcYHisvw7OkpN7iYFDd?=
 =?us-ascii?Q?w8oOInN7OPtqQnA4gYPjNWRSLhnARJCAhLa3zmTuiJLwOaUCurnKkiYZphtd?=
 =?us-ascii?Q?zo3mOfaOY9T6Pu7IpQL2VXwD1bDNDwe2W6w4eSXZElY1iIpmV5B49DD2Cpvs?=
 =?us-ascii?Q?m8E384SNMvVCGPdlOhicFQDDWQ365ew4gD07KY8pmQItLUMJFD8sqnOviPko?=
 =?us-ascii?Q?MFtzuwdYYx82KQtvieXS3k06egXI3XT7YArfDcgIAn68bV3+ilpS9NZBCWa3?=
 =?us-ascii?Q?FEv450bx/SKa7kSnl9Dgse4apghBSlOKCFqb2KB7MAncrdLpsgunuBm4gOEK?=
 =?us-ascii?Q?LYLJs35tfT+hhOP/BMzROR8rVoORYuAwXdO89cvsP1ItgQlG0yIS6ndgOUhH?=
 =?us-ascii?Q?rsLYxIBBfaF44zr1hIKiGal/zGYN2RUcGG/MEGp44oMzM0jLkEum4ied/mqz?=
 =?us-ascii?Q?jvW95BwM9E8u9jqFzhKAdj9Emy1JbZargCaEkOrc5IcmcwnP43bRFNJtZRlL?=
 =?us-ascii?Q?h1i8TdKzbd9B5JApusMkYCSs01e1tpPnHuIPtd2cTgUn2zHMAbvj6GvwolCV?=
 =?us-ascii?Q?is9n931c8Kgx1jAA5O/UxHrpRvJSxnNXDzvxnueP3NaRL09cGhn6J4iNcsCj?=
 =?us-ascii?Q?D+nZ8Hgz5BsiKUiUCoVlu+RdUKZGo0QbtdyX+5UktD8s+Hd9shi8ExaL5MBS?=
 =?us-ascii?Q?j97g8SYkWR6uGYweL8UCWL0MhJlh/UAQzmtndTUupjquUiL0VIUvqekWBjtL?=
 =?us-ascii?Q?uRb4S1VKjOqwtL06Mfu0O+LjH7woYJtDlgkdYPRgnS6o0y7fMA6/XLouF4Lq?=
 =?us-ascii?Q?RiFZHuoWClqopgBHNck+ryAQlJeq7dC+aIYAfVQ+jSfbmk/SvNLMqIBcxxJZ?=
 =?us-ascii?Q?ugpdeQJ6ccz9x11hN87/S3kSdxAbCt1RFk0Z51nIRGkwGP6/aR5dtgE2DIaF?=
 =?us-ascii?Q?hAKbWKmTwAVpXxSrpS2I0qMbBX861evxLW8h3NntPf0iUXj2O9Zl9B0jh9g2?=
 =?us-ascii?Q?20Tv0cfIo3Pf4gW+12BOJ3j036LUsejg8DRbeqdRCQQxUwX/gOdO1oChWIeG?=
 =?us-ascii?Q?g2Pjg7FvDSpCPAcgUxW/C00UniyQBxWhxq7fRf4xxZKk91Omu+J2dsyD0zPl?=
 =?us-ascii?Q?XClYOvUSwbNd3+xE0fwgdfkXDRzGT6z2OmVlxDsRerJvmZR8FMjcvqzorsUy?=
 =?us-ascii?Q?0sT5eie1leN4TagwSJ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UjVv2hLTTfpe1UDZqB0Lh/xYE+kq1R2bM95J3EhGEhTaKEoW3ul0eu6l8hF2?=
 =?us-ascii?Q?Tqm2+iA0IVg1OugUdj3aXhMBIyvHQQppZ1i4XGaItznMtbz7FM72GA6Yw7i3?=
 =?us-ascii?Q?QKEqWQitdaVaykaLfPS/GXJoRbQUSeqd1ACk4+Mdfu5aZ3KBOw79pdmsslUw?=
 =?us-ascii?Q?RtlbP9wqupbbkPcFGJohhhBrdOBfZVcS1Eev4oldQ0nDpEeJdf2fHVL2LPQa?=
 =?us-ascii?Q?t5yLlevezTNqG3duFYzpsb24Kc39mrbGtt0CSM5ZQSziz35lGmf5OZTaHsQe?=
 =?us-ascii?Q?2FShGtsIM0HK9KdlvTPxsP2EoPfQAg8IBDo95Y5tpQEf3jN1NYsza83HCt3+?=
 =?us-ascii?Q?B2xFNHAhSVnDC5R/YL+fKQ+LcWH1SG72emvWNVe+x2+mM4mStRcAvBenpRT2?=
 =?us-ascii?Q?GSB3JQFpNk+vsnZQaZS9wM92D1dv+KeTfhDtCzkcTVDOSOAhmlZfCGL15whl?=
 =?us-ascii?Q?dKhXdBskqkR5pRuTl7wNG4ixGe6cFTet2C/KqeoqibHKjPuaipQkZA0ZTqGn?=
 =?us-ascii?Q?MnPO+9YnkD1VcFhCN3GqE4qP/MEtclQcMOOUoumnNKNniZYLhNuUdo4Kofru?=
 =?us-ascii?Q?5kwcxFdyb+JnZ5ORpvcBYXd4JjE2WtIC0P5ApT85STUFoT62+p2nykgwmkKa?=
 =?us-ascii?Q?RdZcjupCdvlRt4WHUfveyaiIzgCj70uE6Q9qI/gAvgubHSwK/P+cAzMgD/TE?=
 =?us-ascii?Q?jNQQmIBAULRSGjRRH1SL68B1RPNzisXTd+IcZSxK+bfpKo2DgZrbLbguuByy?=
 =?us-ascii?Q?SaxxqgD7EAVpttgxe0QSZCxrMjf+0tiMsY9dh0mCf6XPGBEPw86N36Uhyg/+?=
 =?us-ascii?Q?zjhczjb37EFVX1EIcxfBpK7nopvXpC/1DFcwPCDa9JBUA+NWKA1bAJHRgtxc?=
 =?us-ascii?Q?TQ8jAzUyylCiedSN5jqAGILzMoGnsGEU1R00MbHZSHOtrbBcM4EdJ/5rQ12x?=
 =?us-ascii?Q?acqB/Wmk4lghi2a/6qW8JgEYpPszAcBfq7IpB6RG5HBcCh9fD2duB64lKD3Q?=
 =?us-ascii?Q?6PH7OVidla8l+Lw9oXXlQRsYnw676V4kbXB6rSazszZLTRLN6IXxieCtjnKD?=
 =?us-ascii?Q?yKa/of+ZH2O7avVAwaR+nXXKW4fFrkOeQVBmmhpqtALavZ76rgAwLumniVJ7?=
 =?us-ascii?Q?arjmXGFin1b0DaV159N//8TY2fwGHcrrwGwU5k7QlNtiYB0E03zb2mdl7jmf?=
 =?us-ascii?Q?81d3YDoEOt29ZKL/k7kWa2Fjk0CKOoeD5f8tPpLGett2vu04P3+wWH671oop?=
 =?us-ascii?Q?+MRqPewj1RI5ZzLRbreLJVem5NAVExuTdI8mMBLvyIElSobNUGBVenPFuYP+?=
 =?us-ascii?Q?Ff2WX0qbfBUdCdKFme3Wig8qJ35DHqY393te8Ld4wxf6O/DE7GmxEsOnp2X7?=
 =?us-ascii?Q?U86RHRtwo4YHrbrW18sSSNPkyRKl9akR6DzSgdIXf08GKxdhg8U2AQFWiOuP?=
 =?us-ascii?Q?L0UuLcN4WtQfQeXuiPUEEq401xmqocENs5+WAPO7wpjffa1esBI7Ur5HxRf6?=
 =?us-ascii?Q?gMyWJTBuvjTJEte6U4RlwYZJFsGEjx4EnlB5PjJLpCZf6qmXR5yXD+mi5ng6?=
 =?us-ascii?Q?lVgio5Yy64Zzw4qXgKZuYvkdYT3SFZgBqHQO882bFXVD43rvrt7X8ZU4sXOr?=
 =?us-ascii?Q?tl0kf3fL+4LDxsbi19I2RRCjmLika7ScgJCg0fBazN9TDblNiWU62ELUCv3Z?=
 =?us-ascii?Q?TJr/piPGw0NvGCoNDh4/C+NKmm8BmMyLxa1KmDuX6dKG1betVixm1Wq0Tb7i?=
 =?us-ascii?Q?F8KS/BwtTx5L2zF1g6iOqDXtxElCuxg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+NDlOa4mWqUwc9oxY4oHAch3+EJB/GeRNU3a8CEkCcJ2VGS8YmncQ3lryEo2PxhW4LVxX3PPzcHNlKAy+FP02hhOV8/NwJugzoz8kZSrKqoVOhVioT8nRwee7xU/jYDGDVx13LN469skW24wXMPK1XXp8vXosypS5ZH4oMpX9h2ab6mBVtHFQRayV/j0DI0/smLg5dByihrXUj33VTPwGO1vN668eO8G4qZvhQrtTpmBh5lXr87g4lO9Rku/uj4X5VTAbdY9I8bGsKAQzamCmpukMHfZY3d7jjK+Qz7Rppm0eN72Yspj6rmqcuPwamWAL28yg7ePlxAOBFEpwLihcJQiIQ3PfiOy2MTw1FZpdROL5GxZbA+/pwCyfuD3MB2/2WyvI3nC7kpxdXGWgBdRfE0ybj0fm/lFoKoaOzJWNPWpdPboF6KnTaIUuCrI6PqunrumS4FjDHE/J91sQsMZjXKdpGopByqc0yH2LLao9VIka2QmO+aO+aOtYqWw1ftZm4ik72wZIIRq4aGg0SeGTUyAfWiTpIawSbVcHKvMKuYJJbGY6oZvPFiX1wjoGsRgm3AyWQkLYWWmFmJNSjVBlC86RJZTk6QjWdakXn3+ULE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 630161cf-4218-40f8-6c2e-08de73edbb31
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 21:43:21.9579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQNhZim5ytUyD4+Avm/kcqs4AupwdVFrI0WgTmbw5kkR4jlVOq/ctTsu/cStMi127+s9JeF7hESIam5xdxuyZinCvQiucqADyINuvqq7e/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6451
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=920 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240189
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE4OSBTYWx0ZWRfX5mpEecYTi3R0
 71sqDieGHECNvrEfWru1t/eei37F6yHHeP+u8Ik3cehFAeqORyudtE5xmWnJyjp40kOZyjF7egg
 8JvEyh6ygjyHJdqj8lWkrh9BuMhq2Uu/QaA5PKGaAFQdieRJKmsKo5hFAgVKPUTXpO8TyQzjvQW
 pVQqrM0YxcdVR3MpvXiJ4ZlWyQrXh+ec8/JbN9sQRqA4zf9/UkASbniMghNnsWgcmP+M82v4K07
 Y3kpNiYq2CyDLOOL67h3Z1gYiKU6V9YsvTxBgnsk+tn7cuhVkQMoYa0v7AwwghPN6oMk/CIiedb
 woEwf9J8idMkW6js/EW8MqtIIMNtWx5sz7jO+lBmtp2v8GQQMI+dabl0+eyHnwxvEXHzGNMc9Gr
 hdgC5lm3k1azWAci3coh/rIgB0KXn2Z/Xb+YH2//xG8QhTISsQZFCUi0bJZ6/tA8ePl8tlQEkcI
 KNaEZ12RjHk5pPd/ZzWNVTLQtWn4wVaTRdxLPX+k=
X-Proofpoint-GUID: 8Vykzflva2dvieIjt7XgHY3NjpAzEcrB
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699e1b83 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=7bywzJ7hSbhxkNf3n9IA:9 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: 8Vykzflva2dvieIjt7XgHY3NjpAzEcrB


Bart,

> Move a spin_unlock_irqrestore() call such that the io_lock_acquired
> variable can be eliminated. This patch prepares for enabling the Clang
> thread-safety analyzer.

Applied to 7.1/scsi-staging, thanks!

-- 
Martin K. Petersen
