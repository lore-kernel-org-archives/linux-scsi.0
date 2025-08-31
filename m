Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535C5224FA;
	Sun, 31 Aug 2025 01:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756603208; cv=fail; b=lSblTWZ1u/QGP4JJlxdITv7ez5721tj3Iso926I+LZLONjp2aDjKFvbLwWt4arIkW0X36oPttQRRBtGB4u7fXzf6RCinv0+NhrJ6XZNryupTbnqoW8HBwU2u4hIteNg6hJQiKzKb9E145G4V0luesXqq0B4grM5zCx/Xt9WsyvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756603208; c=relaxed/simple;
	bh=ZRX/vjwELn9td9SmLkwlfZ1p/xjzI8Zzp4a6eq4O6cs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZGuU9eiOorC+C5mF1gMSd4UQHNUIgzwEUFuvrPu84aKipFGrykxQiggbuTbAj3eLOVPVuAcfemop9qrU3fqRwaFTtwoR2kx78Ok/5jC8bEkquTZxNST2UpLheDBZpqu8nNt2r/S6q2SHRr92y1MwUnyyD8eUdHVDKtlU/IJ4gFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A7m1mH6E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IG5BTjVc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A7m1mH6E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IG5BTjVc"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V052KG032726;
	Sun, 31 Aug 2025 01:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WRC7VN8aLY9gTnR/9o
	Q6+maROMZyw8pmExr/QykuOII=; b=A7m1mH6Eegl6ShXAk7X1Gtt3JFNCw/0My0
	llpQnKHI11HhcIx/INiglhv4JT7SNPO2DWO9vp9iznuHRCmKMarM7elq6i48Dgr7
	/u/AFsQ/01s8Y9nrZGA4gHbaRIEdoYvK1grigTnSkJ7imkuHzTm8iKjdd7ZnGg1r
	qFuC/flK30/kwTlCGvpNDmJrWxcdniyUcT/JtZoc0TcrOOFUL5EQMSBbabFPxOl2
	jx8RI1Ph/+EbEBoSP302NqQXmD+g+GGA2ouW5eTHyfUcleHMVkIz6AHqFNzQB22m
	s/pDFiEfN3Bbzs4W/xktlgQfs17cTBgN1Xst/euptH6UtdjC09DQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usm9gm39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:19:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UKXQZV032286;
	Sun, 31 Aug 2025 01:19:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd9rsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 01:19:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7TBRLxTPlPh6iR9ZhfUIZbjmAjis/O5hl0j8WzKBOPOgdB5Jy0Z+ZsOCbppkPLDnIBLsBG92RWov609wULn8lvIk8M/NKEQvf6ud1E94Z8y4fj1KgIVxkoe0b5hgiEBx7BgZv97WAzbd2XaGdW39Eotv0Ny7lATYLfPGG0LDbJzAAdMfOC8zr5XI1wfwb+NIor7ev+jBuzGlSrYMAaoCdsOuWBXiaZhKTfKD0aOEPOH0CDYfV7AM3s6rVGlPWKKxw1Jdb17soaVeKIhS2SNvC4asJbSyGN5r4/JgqH/6idWzOg70bLmdyStgltkr5lF1NSx27CxY5NB8yvRSZkw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRC7VN8aLY9gTnR/9oQ6+maROMZyw8pmExr/QykuOII=;
 b=hTr2bO1vJJIc1gs1imPenB//Xzzvb2NM2E6lurov07JCqTgKFoSSWjOIkzkvdZNbJaw6AQaJoFJZbCwiClO8EVlXNjpIzpSLd29gDNUtjZPU6s5qoFPQoU+hBR9HYGzr+/nDveDjs/sbA1cqc0Gi26bKsfmJbhqYp6MlkNaD7pz2cj9HXhpvQlYRel2ClJkxciFDDyg7sx+JVXrcNTPXUjR3sPriKZJ3BNArNYpEvaJ70Ozueb/EXcKy/rCAhWcCynQ5VMW7OW1AmJfTjy7V6mhgzC8+g/pqZ3ly8EJHKsjH4Wl8eOmiFyZIImaZZkCxrQqcbTVyRmbP5BvKIMvmMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRC7VN8aLY9gTnR/9oQ6+maROMZyw8pmExr/QykuOII=;
 b=IG5BTjVcnPIl2cbv98T4YoGvH3nzWWioCiLRSCMhkGgavt8HKUq5jtRnCiVA6p+CQydaMgOQLZSO56KOC/Q3NoJVLXOqm3cgm7FdXxvzrUFbYOikxblIMJM7xvj3w2LUa7s10PsrrP05TLeqR74qZPSQwuhEWtJiOsn+fn1WOcM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB6582.namprd10.prod.outlook.com (2603:10b6:303:229::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sun, 31 Aug
 2025 01:19:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9073.021; Sun, 31 Aug 2025
 01:19:47 +0000
To: Abinash Singh <abinashsinghlalotra@gmail.com>
Cc: bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        dlemoal@kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v10 0/3] scsi: sd: Cleanups and warning fixes in
 sd_revalidate_disk()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250825183940.13211-1-abinashsinghlalotra@gmail.com> (Abinash
	Singh's message of "Tue, 26 Aug 2025 00:09:37 +0530")
Organization: Oracle Corporation
Message-ID: <yq1jz2kffto.fsf@ca-mkp.ca.oracle.com>
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
Date: Sat, 30 Aug 2025 21:19:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0077.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::13) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB6582:EE_
X-MS-Office365-Filtering-Correlation-Id: acaa2104-0187-426b-8835-08dde82c794d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WpPclncqDGkGpRX/hvNZoO+o5G/chj27wedP54B0bA7Iej72ybBLmupopxQw?=
 =?us-ascii?Q?cwUebQdlZeNrF1UU9aEfT/fNYTdIhuLScjNOM+B+3+pIC6vujvijJoSldoi3?=
 =?us-ascii?Q?gHx0fCz2wuskP6x3tYYAFGrm0BHFUvkEIhoIak66dP/6wSWhzVmdqpWhFeF4?=
 =?us-ascii?Q?+CvZTKTxy3H82ii7amngFaxSvdELrT7E2/9xA2zEi02zdR/DJL6E1PyAx3EC?=
 =?us-ascii?Q?pmA6NMnzDU2XeESbB4/vkJUPbbH5iu+K0A5yFSOemauu2q1l0hfKmMI6rSIa?=
 =?us-ascii?Q?S6BOHuBoEiMaf1T3vQqovIeOIVzBXjkvGKfDGSz2SYgghKLUw/KBr5oAWWF/?=
 =?us-ascii?Q?x+unVKUkcQSvS+EKaqTCg+0jv1D38G+bGTcu2o2hKC75H8/mI4Sh6nEUOIfT?=
 =?us-ascii?Q?op0yGhqI4o3A+Qj6vtDPbCKyOMtNEzwt28EVbG1ULTQAogDi+4RB1ommirTK?=
 =?us-ascii?Q?DglFj8/2q/UF+vcbROFE92GAG2KdiK0SV7C2gQoxP3zwXgvFeStooD97Rpoj?=
 =?us-ascii?Q?OY38E1nk0Izp2c3IYb+noSXLQQSmOZRf2BE+00UurDO4ciPMsYzgbk6XeBxs?=
 =?us-ascii?Q?JTNePN/EtNpz4nk890RbuY9OdCnPMYtJKIYWyz3MYA6nHk4jEoIluwU+Y589?=
 =?us-ascii?Q?pz934ivcgLZHnKTaN66M+k4RU1D6ArOvdRYR4vTkzMwAbfotlGMrtb+0LHjP?=
 =?us-ascii?Q?ZZsm0kq9qu2savBdq3Wgh0iuBR2vrx2r3PkzZ5ecaaT1yxw6KEAtRpN9B/kC?=
 =?us-ascii?Q?fmr5sKW4TWKW33WfI0st0ZcYprQgA+bCL8LJox5JEAmjPl9+oiehpUeNSwgf?=
 =?us-ascii?Q?tKghMqXNxNoZVI32h9kvU5iKiO/pJ28cM5rfrG3DmabEXRv0hrgMSq5IzKgH?=
 =?us-ascii?Q?1yIBwiJo6+XMruuVWMkYWCgvPOYS/Curt+uTj1Ee2zalmXDFiiUI+fLIoW/U?=
 =?us-ascii?Q?OW4M+zIuNwnR0h+NYT9Ae8U8uow1KzAuHeVfRCbXcHascBUJ1DVjD8a5avKm?=
 =?us-ascii?Q?WSnBOguqgEG8dMaFVJCA9cxVwvO81Cpn8pEcSRyao/CZac/P24PPcBf1Dd+L?=
 =?us-ascii?Q?Zq+HpzFcdtFhD1Q7HipRuT9uw/O7dO2CkVetvX7UB6BzCc/3h8CDY71sazda?=
 =?us-ascii?Q?KpZWTbBPWohcTf78RFYdyTMClS1jVuHCZaoanRG+VZuGMREMUugVh5y75KYy?=
 =?us-ascii?Q?RSNAqet41Rw3VdamWg2TnSwQ6Zr6nxla5ZBNSHO21lwjlQdQgATEWhr4Xu80?=
 =?us-ascii?Q?kwM5C6SeWrKON5XKze96JuIWxZEyQ+GCZ4O/GyIs+iZvRWOHoHIe1xcqkXl4?=
 =?us-ascii?Q?XKa4R3ujuDRESXER4iSwopA4azYebe7a6GkZ+50wZpY1vBASNayyQvho7BVZ?=
 =?us-ascii?Q?IZfkrFBq8uXg+XnFzuOnS5P2b/3S2yznMcgmdI3TD+fFaMxkdqGAVKKKB9be?=
 =?us-ascii?Q?7p/xv/dHSJg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jf5ydcGOdDLGk3imzs6YAlXPMC8GErF/tgIQ0cyKq3uG+ZKiEvaRW1PCt6hP?=
 =?us-ascii?Q?EY2CRAtMzRrFXjQaGCIJfLbv7wpEncevuueawUBFaR4i8tpAGWvj90KdmPN2?=
 =?us-ascii?Q?nDu7Lku/Jt3JDEj3Y3YqMXCd6Eg99GjzP5lUlybP+F4UXmYNOU5KlzuHpCJn?=
 =?us-ascii?Q?rjfLZ5gR3GvfrccmCJ/Y7qaRF8nZyLUIDtMGWBAAwTuixqM/zqwIGC27v+sx?=
 =?us-ascii?Q?YFcoIxecaQkh/cbMEdnUY4/scXlAGlLPmditmAsXdfTQcvv2HzLQ1ubcpnpi?=
 =?us-ascii?Q?q/GjUfvG8wNVthj5bEnglzkNDBpO2gVf46bsMVPYrs4cay6/u98vBTEWJta4?=
 =?us-ascii?Q?EQMTBfQ4UwN8UFFWZjWkYgMYx0DzdRp1JlvFNYaC4jA6XIEuRtjZXc/Qrux9?=
 =?us-ascii?Q?mpRMznEfd34iKc4Mcze0GxxuXvAS2LOfA27kZxPVP6n3KTQIYtxblvY3hzRh?=
 =?us-ascii?Q?KzZhE+YqxRb89hNqiHqxDl0oe6BQ7GhJ423iBnjsN7L6/IW2id4iq1KQMCVA?=
 =?us-ascii?Q?Ol4BeuToPUVaFgPQzA+0mrr/SyJIcbsHrOl+QyWCtj2QZOfh6Ph+T9JMHnTj?=
 =?us-ascii?Q?+6ZYiv/zUSwFWre+0/QUQ9qTGYjW8HRRSvZwhQdlT66EpvZcQ47xoXEW7hZV?=
 =?us-ascii?Q?ldX2dgr0521aipKble9evbO1CiBYzOmjK2Xs0Q0PJMoYYcfFK++8vcrumL26?=
 =?us-ascii?Q?9ycfmu3eZsptCWsZMm2KJcvHINtOGl/YF2mrLsUHrY6spxteJS7XgoG/EB0h?=
 =?us-ascii?Q?dkf745fIG7IKVjrMtaJr/f+Hi7fFkKQgZUHHngDusoeatH8zIJR4OMpYM/7t?=
 =?us-ascii?Q?lvaGbffOGdiorS7NIY0vQqkVKuERkiiauQH/yuXH6hgAv8CGpuYkXXnj44nZ?=
 =?us-ascii?Q?JjtkpaHdPBQCuyNGWhtru6AehxHUdbywM8pZzEdcV1mpzxfcvLP9vlVOGXz4?=
 =?us-ascii?Q?1R7N+i1ImQfv2YNkGrAj/vtRdgab5WTkVtvDVw5ZxOFFy4WTTp3o6HClGox4?=
 =?us-ascii?Q?eU5pySI/+tsvjgODEL8ionf1kx69o8e9J9VxVH21kEpELgTnXJXCFyLq6v1h?=
 =?us-ascii?Q?Vj7ADqIif3UJk26ihi4z6tnbtsxiwKJe+FQFsmVlfpJJp9Il++fYgeU6IOd2?=
 =?us-ascii?Q?YkKtF5de11fB2nJN9uR6HstuzGou6DCIQ3Co4JDZUbQGosfp4i08Jf1DZJR/?=
 =?us-ascii?Q?Yvq3pTUYRpdrIdFFhtHiwUjd9nIICmOcOxsW/n5OpLwLzNSN3sagqA0qprHD?=
 =?us-ascii?Q?mmSJhCyciPc3PSVvIebh/oBmMSM9qv9/0Fzp6oRxX1ZyxzhgwMRZo1oJ65X/?=
 =?us-ascii?Q?jZ3Q1DZ1PwhFvKpv/I//ojDxL2NPIR7x3kQzCJTYsaHT78yaNSMghcSiLi4a?=
 =?us-ascii?Q?DplUHg8dGHPgbAPqiWaehpzlV47qGPCDyQ5o1Q2fK0EBO5ibVtLQOJ/aigEC?=
 =?us-ascii?Q?QR4wH+452kEb/PZTTLPLB0J5TMC4jddxM6XcvM9UD156WTdV/3+ZVcsZ1j2b?=
 =?us-ascii?Q?BAllpzlCkNpUudTx19kKpnEZSnisMjp/k+iQE/LTmUsGWAJboBHEKZvEoJr9?=
 =?us-ascii?Q?5gZyUoCE9awrXXGkb4iVLE3/oyefRY1TCwzKdrt250Zdu6JQmAM4ia2/eeX+?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DyfTh1P/VUIznJOOWTZ6FSjRCSJx1cKV/qHXpyitoKdPc3Qx6rKgdX3eWGpgAjRA7D2pvbUQn0s+cb4p9pDxnXtTjmjppmIGLhAtcrowDEMkBJcDXvtNE5W0kC6mYmiqM6IMmi5jsbSuo/X4LOJuMo4AGiCO/xpKdoqPJxW3n5vPVQgXIKBJ78VItmabeIpOywpBXHjXE+arUieKkMnUFGO3WOce2B8cGYMGp3sewEBhF164+iC1M16QLw38YepnQPpSpQjdFzOTHWSD3XVcP3ByjA2vnYEWUJ6b0+o204e6ziyVH0tkYVlsu+LJZS8oQ96YLyAs2ZpKqLglrNRI6JmHn8ucGi2vTSb0qIddrz330v+Z10hlbA0f6dohuiP+LyQ/oFKifbQkGSGseyOog5wC+KpK0N7mkUDHDJNit++RxeUSckrPrxMZHjHTfSELfHakVRKff8hSMp49/WSFW9rAau+GfowNNV6QAXT/E/Driw2Cih0PCakBXXQlUW/CGrgpCjO/+cjZF1qjYYcSxBRVY1qARRJa0P7kAE9x5XmCcjmeFhPwjwcx/k0mgsQgVthFAw8hDVcq1LnO93cOcbgsL/LbQmslMGuWIp96yso=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acaa2104-0187-426b-8835-08dde82c794d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:19:46.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQKDikOEhphPXD+1BAFJU7sg85usteGpHUqEjsRVe8+WZuRUsO/N0j2s3tqM/FG1D8sTcb+fFNuBd3xQMMiPHLWVrSS/lXC77iVsx6Jx6Bs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-30_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=619 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310012
X-Proofpoint-GUID: 0LPA9sOAD8hF0kE7tv6d-l0cpR0WnAe3
X-Authority-Analysis: v=2.4 cv=I7xlRMgg c=1 sm=1 tr=0 ts=68b3a33d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMSBTYWx0ZWRfX8HEAcqYFovT0
 KDP/r+S0FMp3kerd+qtVDQ17pY0LWi63ttKXbmHKMpbsFOkW/Az1hrlMg9w2+w9GkUrrQZGpcAd
 y7HTYLhP37vJ0ocJpOsNZPwPfnN4gV8Z4EE4rjSeUqbJsxkzFFqNGa9LoaC6tWRkuvNMP1Vc72h
 SfY4cMZwVJsIcI/zQCxS5OZFzQkF8ApXTTZVaqWze1JqfZoX/MYlmPM2IJncD5JkgVYZh0JVDR2
 FaVko8lPGpcX9VzvJqe9290T6KeodU//OOLYc4BRawV9nG4BBLOwlK5xokSi5vZQeO0CpetlWE0
 F3ucmDyXcTNJf/BTfES7GYNKO4iYJFJ1DB2xiHymxS9VuKmG9aN3TDmua0Va90oJzwII19pZTHU
 oXggs/LNx2vp8kk7BNgzmdlU8Ox1+g==
X-Proofpoint-ORIG-GUID: 0LPA9sOAD8hF0kE7tv6d-l0cpR0WnAe3


Abinash,

> This v10 series addresses a build warning and does minor cleanups in
> sd_revalidate_disk().

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
