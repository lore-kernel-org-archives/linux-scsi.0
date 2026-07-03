Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF7F403135;
	Fri,  3 Jul 2026 10:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074933; cv=fail; b=mO2pvj89waW6oxm5Uml1lSKKerB8yJmaTg/tYP1MfxQ7MNRblxIp75sItRFyZVavmrluBV7xfmftFNvs6H9LRC/EP8MbOGIxOkz5+g+KNx0S4YHUQZc3M4MmeR9wwRpJntRQsjS22wGJoCwpEdxzFyiCXvJI7NjYx6iGu3ngBDE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074933; c=relaxed/simple;
	bh=R7cSDt11gPcRWmFzdZuYPaWKAMjp9QOuLsjKa6XjisA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aKIW+1ReTuftyqkxlhmt56HgSDhBX0vCNqivgHkRU2Jb09CXUfcsQVFhWx/FysgBMqHZ1drRdAF082RWEfHqVt3EzQFKwi4Q5Kdp5T0pKlTqn/CdZsqvQCIR8eu1lQpORW1qWsSW/fMK4o/kBMPA2EWe+vtwedgwbLpYAF16DXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sYMuRoys; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=atI1Fhf7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sYMuRoys";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="atI1Fhf7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638uZj93063930;
	Fri, 3 Jul 2026 10:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vEPMEUEoHaME+41PuFUXtbi5O9onyitYJmNKsZPQedw=; b=
	sYMuRoysO4Af66MTu1R/qVYpZTbtRXveEtLQDPnCfaypUefuX7rFRv45LePs6+CL
	OCfIIfFxj8g6+sb6OpvRNOa0lz3jf9KpaDXnMH5AiPvGz7YtZS2AhqbiW4m8KUN8
	pgvJOdjS5C7AzCq/QMLtbt2AR0pICdYOlDSFql3sWmsN93LyPa0xAcGER0bn8LG8
	VVZBgOOHXHlqcmO6OCwuXE+dG74PGfzmk6EGY02GpEEXjZtj3qc9lIOQDS6iXySJ
	nTEto0ab97TzPr98FYykKx+cvGiWZhHNF+x2X7nlp3O4LcTuNd6uQjJQrD4jinIT
	WazOFIAb3+9nZFOfCYjGpw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26n1aedt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AXWQB036945;
	Fri, 3 Jul 2026 10:35:09 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011047.outbound.protection.outlook.com [52.101.62.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4f3u20fuad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:35:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+pyizJqsxPtuStj30iIWvi5XNlp2Jpsk+1xCyzScuFqd5G1v2veNbfMWLGwq2pAj8Lx5FQtgJziJ4vriIXKdUvGN00ABuJnzTjs+Rdo6EfqxB+FHE5DRBGdXYEwyjRRVEQBrWSWi/3Uk5/zdBF+mVnEU10+slQ61fs/ZXvUskyQLh+vULU45kLDFLSAevFgbO7WyhJ/tKTUnSL26KNiXO67rG1UhcxyPw/8LDiTlKscMCn+V50Dn2qCDV0+VCu1oRTwVhXxwnQv/o5mKbS3hV+zSlPZav0jLXhQ3I5Ujk4L3rBdf0VrQILCwozvtnOcVCR/4dmlbpYW6m8/eML4ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEPMEUEoHaME+41PuFUXtbi5O9onyitYJmNKsZPQedw=;
 b=QDjaB39KdALx0ZKeBWtgxykGedIHJoc9QzAEXgzJtqaL2JXvfEEvnruLH1XjSiiNz5hNTBUJi0hGREeos6ZS+DQF2m07y5ZTA+HcpXjMICDcgfe4BOSb5MUnCWsVBmEjRpmXKzVZcQqv1m4m7vj/5QfEL9JSnA2qWqphKHrH3v6geo493fTUbnrM16nsT+9L+xknvL2phqiG02gb9K5TFMDiSJGDk0v+47ox6nsPR0+lCY1mlc3Y2+tUKlW4z62XGjLQS+DX4iVibldnE7O/uv1KlBnCntOOHF/0AbFciQgApXaoZFgHWjR+f2arSKBUPbMRtVVpMLLKRNfS7JNNKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEPMEUEoHaME+41PuFUXtbi5O9onyitYJmNKsZPQedw=;
 b=atI1Fhf7wEi9flIt3DyGdYIu67XkilysMHJGT7XFPXXfzTJ+Zw69rjQ8kH9I87iR42vXhrQsUJ5/Lqa6Cqy+bGncmtkHYmQ6MhpPgMqnhr+AnYXQiqlwDRejJ+ThsG0mVqe8iGQPyT+qzxjwq3Y8woPwqZqBerWAVycZl9shO2g=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH2PR10MB4263.namprd10.prod.outlook.com (2603:10b6:610:a6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.11; Fri, 3 Jul 2026 10:35:07 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:35:06 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 17/17] scsi: sd: add mpath_queue_depth dev attribute
Date: Fri,  3 Jul 2026 10:34:02 +0000
Message-ID: <20260703103402.3725011-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260703103402.3725011-1-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P220CA0080.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:259::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH2PR10MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 047bb1fd-9f55-41a0-8666-08ded8eebf9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	MqDGMaMRT7BIsskoe20RD60g4xhrcj+g93oDOAJTUtAAwugO/4aPtwE/Tk6g2S21SKbKR2WDWYL/Xrfo1mCgajzPEWMOfI1EWeB2MdVDyJgcUlsI+v13IYiAOfoH4lWxzaOTXmgB0L1t7q/la8FNk/XN5fV3imGEeDR95Zn6L9YP1KnqNWSgIzqe4Dwq7X+a0tn9x/aDkWE3hSVnYSPyOmMOPzlzaA+jB3cs9qHnqb016Tzl5fQ7W7l3f4Z014vPt7d6VKdRTrN8BLVVrycUagbEFxcgTymGZjBXh95FWcIPyz2CKrGspWgsZZY2IYS03gSCtrPtSJeD8RlyHObiZhKTavAcpHGMz5f7YXPsjYGfLcL9McZ0DSTqzyuEp7i6MTl8EBSR1qp0pkzA/TvriK1TcLBNM/oSJERqxjRK6h9dZDsiDmjUioFw+5CNZOzvDHqGYBRgcmP4DOpwT2ZDps26MMCDCJB5L5Hd6RLpMZnGf44tfJbcnzsyutH1J0CxXu6zO/l3Jey7JtFuQUY4obulyzY+8BgtavlqamEW425bD88pL9x7yVj6uZ/0yrBNujgfGWtzvoE9VC+a8dtjcdpu6PqC6FC4ikKf1KmnR98b7yYnbxMGeW3CCG0i6hd/G2Gk6/2po4QshBgm/wAG8+g9eJ6GGy+nHd/OKyIFpdA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?93dwCTX1UHEaHAlezDdaflI2Dd/fj2FzLY838iw6H1GIBZMrrBk3EXNwc784?=
 =?us-ascii?Q?nIjsx4mnDaYZRWUoqYzt+KD0T+KzNyj6wWOCDISG4oTBE22zn7Kv8Trgilz+?=
 =?us-ascii?Q?CS7S7ALiCRzWpTGgfKtJAhKBQzpGaQEBWBl096PDS9cEN1NSDIbCZVQ9ztdy?=
 =?us-ascii?Q?qhWH+XXjXVH81oo2cf+qXOQcvdQyM23LVfk4JQfaAJnEZeWny2u8sl48M0OB?=
 =?us-ascii?Q?6vJQfpRIM+0+wx+IKFVud+QQxBu743dMuvYnvg7L0buHVtD1Nz/1yfCvU9zG?=
 =?us-ascii?Q?AK5tycOQYY1bXqvfzkiiBQf5vx2tAmQ3tiAvcnA/67I9iMdur24wp6GzNP71?=
 =?us-ascii?Q?wNzZbWQdvP49afYbtmlkIAjgzh+0sjBJjxrQs4/AbWEfCarLVpJVVAOSs+Wh?=
 =?us-ascii?Q?VnCZiG9WFNWe2DvkCLNpj3wU43pFop4HcD8O1pgd11X+AqCnXKXL/LRupwdd?=
 =?us-ascii?Q?+kyRe7jJ46kl98OStcQktow35Dn2CKb21RADGW5BqZf/sZmqD/yR/A1vObWN?=
 =?us-ascii?Q?BBqeJe4tFVoI2bszdCth1fVPGDae78pRsMEceyE4YuZ6dE+GPC1xj967ONsC?=
 =?us-ascii?Q?/CqInU3Lg9JO/DeKneGFdCVtd54tcAwfaq45ZDX2F1U3lx1Lp+U5V8VdzAo9?=
 =?us-ascii?Q?RW3Bx3qJUmn3oRsoEF/l4Oc6+e8lttl+Abmsfj79Dig80fb4372GaKtqvXSe?=
 =?us-ascii?Q?jnVa0xYsDisFyd6HqeSndw4XG9xS1HMk7oZSHm7ib6YzgAseiEqR8K1r+BBe?=
 =?us-ascii?Q?j0lSEzCtiyiNaDrezFZXsObieYgHlsfJ13ZMRi/GzjfjFEYGw81KDXf8+s40?=
 =?us-ascii?Q?hgt1Lz7vxyVjOM9l+p8ZRc7IJ/BCwg5vFo50ZkTwPeZrw7STktwlxg5H1IkW?=
 =?us-ascii?Q?1B/tw+YFaD3YDiQ/e+tVEpPwh5a8TxLNJW81jRfG+xmHDv8zghCpcq37WITW?=
 =?us-ascii?Q?fa4WaAk56HNVS7gskoFJ6YggmwtcpqCJMderr2v2Pa9t8q4nTQd14d8xj0vi?=
 =?us-ascii?Q?CRZCHilbgLUV6RbsrAzhAcJchxz7CaU6WyaymvAo0vylbPLMEm0NZ4/NH/Vp?=
 =?us-ascii?Q?Cgd6udisQWc1dKk8nwt51cNWLAXhirCg2/fEdG9XQQiX4E0yLFJr9afn0uZV?=
 =?us-ascii?Q?z+PhDRGaTlSmFa2wb77t9tsRp+Cr0UMaUHFICS5Dc1w8uey/keHQsIpxMGh3?=
 =?us-ascii?Q?Uec9LLTwWXml/mDRH7wUPC6H6uy1COirnTNV+BRv/bvqWGeoFs76+G09nS08?=
 =?us-ascii?Q?4H7s/opp6qHHTKw2rzxWNV+4frZTumGIpzbnIYbCaD1Gt6kbdTCijJHsCQ+N?=
 =?us-ascii?Q?JrSb7U0sQu6X7Qu5ra3dT8HHoVwZ61h4gDUUxZBcBuo1WXq242Mbt4bad9u4?=
 =?us-ascii?Q?1ZgcxL5xObloc9eTxWgVaZxxn8IxdOtuwbu56t9UTe5lyGpXeCGq/jADZqD0?=
 =?us-ascii?Q?oHVAI2yq415ppRQ7wwu6Lseg5SJHSYA4bVWEVlE0zNAx5N4EEnQH2WvFvS28?=
 =?us-ascii?Q?2J5BTKGXfF2QhtOw+PfuGZct6rEc7Y+jSbk7KlznPKORfJhFnHBiu/vehckz?=
 =?us-ascii?Q?7X8JZvOfmilXG0n+UuuNt2zZ0M6phCsjWDHBomYF2jDtZ2Pf0OJBa+YONkUz?=
 =?us-ascii?Q?BsFCsooOXpwJTqNmv2kEDJqaLufPfNVHwt+nCLL21eWMlLzIGOIq3EdpmOTS?=
 =?us-ascii?Q?TWVwrK6kx0XHsrc2mLCmBNX0Qr++FTdt4GSMrHH85g2+HfBQmU0AWxLbWRgX?=
 =?us-ascii?Q?kNhQAFD+DDcMMXmbfhm+iL64R/3nnUo=3D?=
X-Exchange-RoutingPolicyChecked:
	QoawgI5dB9Y0fMzRHQB1AXrWn9GQL5BL55ARHsX3UtvLUKrPWSSohsvtGPKAtR7eNekrd5x+KBALRhhLzfydJ0SpKIUR+V4ebMjdgjE/9asHqnLnd1Fa+pAPwtJR4kY2kY6W9lSynQLd+2j1LdUQEM6YWs+X1NcSaMfXzYSzB1B2lpjc1s8ops9bUmfLy5mC3FOJ7F9zgg5Rn2cMDllFwgPjK4rVt5POoRCNrUxTTAiiMVLnIj4bQfbTO48jo0zVICve3pP+uGDqdtQysk8CWSAackV281JeS2t8kRCVda+8mA6PrUYbZGzuYvL0g1IZl58J96BVOT7ozOoHDXNaiQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FLTlQLxJzBoaj1E8Z5/KUbH/sXKLwcWI2AZ4fpd60V9Kl8ZkwI5PYPtVK5vf9zHE8n3Ndz0hrWt0E9IwYQu/k28iI4h+XEKkjArjRmPmWCahWNAKxa2tZ1m0kaMsVTVFcAop9cNsQfvZovqD9XaT/u/sJaJU4m31moAESEv0KyggO2pQl5dv9XsrExPoglf339aIayL6qIRmQcOJS2wk5mlCXZYO+4jytSsl4aY0KMJpy6O0v1CxXeWr0eXmV4cXI1xm6DzRBU9bYEKfSAAydfUYfrU+iRSbM1yczL+90Q4CwBMLSbDSKNeHnMUTtHCUDKHO+E7rtr/v0khLt5yxq5rV4lrXxUj1RKvud+hhP4d6y39u2NQBgJrkZmCPvC3S/PgggCj8MCTZyohlFx+HV/5bBfHCN5lnQaKQDiTAitCVIiIcxuk/oBZrB4bX2hTbfn27KsEpgC+HsTlHn5Gr3bZTdnbmcSpT6e5ZfPMlzzmOFDYc9kuEjWlIVvwcFDmyqe0w5quYHkJ5oYLM/afCsDQZPcDUDWH1fxef+KTgi8UH1qWvJOKTJl2DEexk6vKdTLG/mCoQyX7h3UpBOlo4KBi0wKZ/Oq9cWqV/wweQ6vk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 047bb1fd-9f55-41a0-8666-08ded8eebf9b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:35:06.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXYIS1rGoEZiv2As46o7skPDp78pZYZo+DuyiHEDO/aJqs0uQOboQtwz3EaDAbbvYkZeCO5MDl8z6xqqKlr/Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607030102
X-Proofpoint-GUID: 57QEZGi2V6A3b3kd87W6FnfQ4WuLZuvZ
X-Authority-Analysis: v=2.4 cv=FvI1OWrq c=1 sm=1 tr=0 ts=6a47905e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=bA5FzAUjrTEoIiOIIUIA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313
X-Proofpoint-ORIG-GUID: 57QEZGi2V6A3b3kd87W6FnfQ4WuLZuvZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfXy789CFAankdF
 X3V/v/UDLo5THbDp4cD4ZyqtnlToItxS9iAlPuONALQK6Tj7hNN3g8A7uAqIPr2ZzL1OKqMb6tS
 P93jD4/14RpvdmSyyxoiAh+ZWnDcsbof66E2ym0B5uegGAJ6YJYp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX+XPA4CD2y/ut
 ODnBAP9MkNoMoh2iracu/+n4iaP2QfrgQ40ToZ8Gu8ywDGG8TAdH0roA9QTcxWbQK/xVWqTxvrh
 a1+5v9Rswy56nfKu885Rf/ALxY7L4b40LkOryARezygVa6UPAE0OjSxWmnTPFi016L4MQa3N/65
 Z1Ruoc8Dz/nBEQYoeuCS6AFsen2aoKOG6INmsqhqDzWVI3n+BFlxhpyJOYt+eCcvvFwbBoaVuKl
 Kh4kJwkcu2HwCBNwG2cj9NaiMeAKnA2DEDxQZg77TDS+Es/Qq/B+EoEmGJJmzLwYFnvSkxRbaln
 bBsdr8GKbr9Q/ZLRyvR0VxypgN77zKaMBPHPtP/1m4N+E1YmXtKYWua03KisuaL9Rfljm8UKSbb
 0KQsrMSknt70edfAUTUVI1heBMNOndc/Ao3vR1F/qmtpqwXDJyDFI1WVOhbbdMiPkSE9zTdp2r5
 8w/2pRE21+OPGbRMZ3rFcetyHMIL0rCxYvtukrNI=

Add a queue_depth file so that the multipath dynamic queue depth can be
looked up from per-path gendisk (scsi_disk) directory.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5e0514304d81f..f6feccd557e76 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4088,9 +4088,27 @@ static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
 
+static ssize_t sd_mpath_queue_depth_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!mpath_qd_iopolicy(&scsi_mpath_head->iopolicy))
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", atomic_read(&shost->mpath_nr_active));
+}
+static DEVICE_ATTR(mpath_queue_depth, 0444, sd_mpath_queue_depth_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
 	&dev_attr_mpath_numa_nodes.attr,
+	&dev_attr_mpath_queue_depth.attr,
 	NULL
 };
 
-- 
2.43.7

