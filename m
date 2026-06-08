Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC449223DFF;
	Mon,  8 Jun 2026 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955245; cv=fail; b=cs7+bpg9otmjU+qy6xFs4OSEDRvvMMHXVKPPk8VFcH7hSC3BLR9QudseOgdtFNwAXHSNVChGTrPP1kUPy8Dvn9FXHCfzNccNhpNA4NMT17cTfacvtapBSACWtU9TVDa+MOj4CD+1kK5Nve9V4a0vAP3Ud9QX8d/a3sJyxiaJkRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955245; c=relaxed/simple;
	bh=Kxu6nFRPAjAvDgWzIGtdM9/IY1yp6WVl4m9/ITW99Ww=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Oal9P5J6p/1GaTLWr1LUvX8cyJKFacGUPJiFFC7sN14SnG3fnpCX2aiMfl3A6SP7BEp5eAlUFBRh8gsEE/QjiVeDYGHQfO2ih7uVNyRKs9Sq0nA4ZaAXMdduCAw1FubaA+aravHrp478ub1baGRAO81ye3HX/3afrRG9SvePK1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Arqaitin; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BNX+GxLT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Arqaitin";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BNX+GxLT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSg4f3246908;
	Mon, 8 Jun 2026 21:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hjw0MjTZKPOSayzPfk
	YGh7LMAw3XQ9yjRM3ff0TrGH4=; b=ArqaitinJIPX3GOJItiNx5o1F6EvtC7vD+
	pNLH2uqXFSl3eDN0vJ5+KeYYP2+QMUogvpl8LwY/7z55yqHSP/ysQ30j3aiDo2zG
	uVLTFnmf7kZsfCxygs6pKio3b/nln3DEDBdqF1kDzAU+ovynpxNWgZSdSXCk5mb1
	ARGHlxJpTDVN9spnzm78WH34bDcAFXwwoIYGV81CRJpux+tG9bdV5LDjFawPuzYw
	AyCD6J+VlP0l5ybg6qUcvgTtTWF4RC3BGvkjHSoTqPTWft31UBJHr2N0uXI1NI9J
	OukprOgGeU7s6swC5N0pU/RGhspP47chOdEGyiUv6TWpBJNV7MmQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emc3rk71h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:47:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658LhxmS028088;
	Mon, 8 Jun 2026 21:47:10 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pavak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:47:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMLZ6TfI1985wHrLy7X8VFqQge5pjNRd7cdYte3n/4RCWQZ75lbFLFVkonwLujyWx5f8/wmbNvQwtzheQjiTGnnM72n4jronN89yDN65AovBlHmMe1xmzaS2c9YwBxNbd5k4FbiC0v3c6vmCk+4H6lKqaxs13XXIpli2iY+iLrLLe3mqnVeYdL+Fiyaj0OABAPi+fPX9o8TwSKiGB+d+OUfsEXFp4qSOO9amqFJ63YR1qKBS8D3DEqg/G2KqXFnB5v0v01sauVl3XxL5wNPagUayVAiyqLC4Jb7FSNbUWJWo4VQs2sSoXP2gkFutRhYN4nyuh2U9f/e2MYUz5WnSRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjw0MjTZKPOSayzPfkYGh7LMAw3XQ9yjRM3ff0TrGH4=;
 b=jnM9YMkRHp2+qHGm4eNFsuz5ip4lKmzQVVikTNnb5sueLb95vyUjswtebNo2gHjcTZrQjlDisa+m9Eg03U20fzlmJNPHmTOHR9Z1Ett5XsJKCWH4q64v0Kmi/XSERwAhRehJVjcktuZ9vWOctTVSYRsDLGsuAabfrZCVTzrrvArdllOj2Vf2GaahgGYxQTOcEEXjU7y/SUsk/9ohnxxKDrlnxtHiXcMH9/Mge3ra8GD983bB7A4UY0WZFZ5OnFNddFSziWF78+TFmo3ajv4o8Jj4YnGKpbx0TPYdpy/AxutrbGxKxV1huFtbWSfdzYXxuzqSxTKP8/uF6L7F6l9fsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjw0MjTZKPOSayzPfkYGh7LMAw3XQ9yjRM3ff0TrGH4=;
 b=BNX+GxLTV1ApCwfgbBXeSZ4mICi//j1bMn66ZCiY03W3jjMiNzompNbtnQMp7hkVscoiNyehGs0nyBxMGOhIkqc6A8VAAvHnUAlG2rnvEFcqCGhkdPlfj1V5wVvH3m8oFhBK4S0rZnv/bSN/MZiugLlzYAlwr1TXq7DQ2tYJM94=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS4PPFEE36F3C1F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d56) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 21:47:05 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 21:47:04 +0000
To: William Theesfeld <william@theesfeld.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: lpfc: fix spelling mistakes in comments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260602111912.23864-1-william@theesfeld.net> (William
	Theesfeld's message of "Tue, 2 Jun 2026 07:19:12 -0400")
Organization: Oracle
Message-ID: <yq1zf143dt9.fsf@ca-mkp.ca.oracle.com>
References: <20260601202001.651088-1-william@theesfeld.net>
	<20260602111912.23864-1-william@theesfeld.net>
Date: Mon, 08 Jun 2026 17:47:03 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0126.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS4PPFEE36F3C1F:EE_
X-MS-Office365-Filtering-Correlation-Id: dbd20fc3-713f-4e8a-57c5-08dec5a77b0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vCOgmI6Cn3mCRglltsyYYCjLevG8/+REPA3EIBEhNQ67uMMatSJEdEMTzOpRgM/GlMTLaVGGnFPS+4hFRvn0Sn5sWN59K0LhDqSSeVGYSlcJoj+8LWgXvTmzkxbLDMXHuGC3Pw22mOQ3oR9ACDbIuaB7xr+IkPS3mZJZXxr2f12gNDWEBPEWUFYHU/U6/1Sv/9L3yqmhoWtcWKnA8ccVF/unrJPNcckMjhrrsswR963ugZbl79Lqlq3ilbzJZgEouXxdjCmL7/z3pf6fyodk9jo8p8UMZsFjvHmAPVLCb7Rgb8XXALVBGm9bWXk/SCvZ68fvhGZlMvDX4xVSrlKvAroBVFUc/d9F+JgSsBOqsJkPwcKb49woEW2OEUSl1gZRf/2U7PBfi6QgOSCUQ7KZNERq51kn7269hKh32tJ/krjw+LlkWXk6WiY52+UWIXdFqq9MtOXELrO6VrzjHC9r9/Lx2bQdzgeGNCyimOYVVxgpOlQq8q/AccWqdqMIx1y7gyHBRMFcDiUcMRKZt/vDP5Bei53jX0iCR6J2IFBB9gjP85ysi3QvsSkOlDZ+iJwca4tWm4sh4d8BWfALPFfleqAQcmWLqRVe70ViLrkpSZFBv97Q7JhdiwOZwt2oJt6+fdLA9P1H8bzyzBJPKi74DyYBYIMHD8+qrPS+8DTTEN7mLdsJVMbFpQj8iwXbDAku
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hv9PdoRJ9WDTaylft/JauzrxvLN01nkrle8bt4qUtm+MG6y1dJlrZL7q0tCK?=
 =?us-ascii?Q?qV1Oz05DLijcQONcOUec2gC+PneF+SmiUif+Ga2KIcmcmFV9o4cE4TtPBuSk?=
 =?us-ascii?Q?dH6LfJ65lx1V+waZ++s2Nu6zNdkNalEnOBJ9jFWaqW7e7FO5KfJ1oldETOl3?=
 =?us-ascii?Q?gIFNG/oFrJDIuW/van59SaAJnKkhkS7NC9YrTMAjYj0eVwdSFCTek7vlndmJ?=
 =?us-ascii?Q?3QK6irLKfYcpG8JE451y8417b4cxWgskWYcWz4YYPTEqRWB6VpkkJIAY80Fi?=
 =?us-ascii?Q?0+JrxLhLqVL3lukDxy8+guotfmP9B5KH7nGWgIN0M5XDKr2YJUWUKVTxfCUe?=
 =?us-ascii?Q?rFAyyiknoMNYQH6d9NR+VoY803OnwtE/Chnf+X8XqBvQsILfSth5fv9V5zgC?=
 =?us-ascii?Q?tESq/X1Zbf2qYv7boCA6lpO3BeLPQUmMTwDb+zZzz3y1v8nJul51jFKllIXH?=
 =?us-ascii?Q?8fBWPDUjFH5URM62GUjutTlix+h73B882XXj/1UV/c8rWRnvahfrqVsRNvUv?=
 =?us-ascii?Q?RhYoQ8XNnaBiAHYwUEqqodU4SUEg2JFliERDa3AsR7rBTZcpOoqk5srb11ms?=
 =?us-ascii?Q?mZPtRYnlSBzeIEK+U6aR7cYZ4tAXpFnudaMIYVKPWjj4HGLgo2SSbxq/DPsL?=
 =?us-ascii?Q?fXUdmss+rhqkYysY3fXrbFLo+Ez3fwLDDmWqNV9D6fVaa4SdrwqOeo70V96K?=
 =?us-ascii?Q?I8TzPrgsbS/hEg0mdue3bYitX1rbauGwF7n5xXEH5G5UlOM7R6QNXzNFrySG?=
 =?us-ascii?Q?ZndWdeLcY9OawZnuGeG0oB0QBZH7UqGvjt3BNjEjiFEgwCQBUNBrEu84tr0R?=
 =?us-ascii?Q?zaqpBLCziPdMY+GWi8/wjZHj4pdsLUnfMVgNXsdRGRbOe1eTg2QNONdBAt3P?=
 =?us-ascii?Q?vfPGQQ8DjSksxCmA1OFNgt6O7C2yIUr+ajRF86UzINBssVe1wBxyHu1VE8pj?=
 =?us-ascii?Q?4eJYApx1N2c/J4zo2hPYtL0deiR7e7fmEBJt6WsHHS9Nhg4CiHcezD7ivjcD?=
 =?us-ascii?Q?VMzbiGNjEBhe0uznYKti1zCSk3Ij/fDb7dtWeUBRyOXfJdOV9hxERJier5YM?=
 =?us-ascii?Q?j5pey5sL0MtZbWAGQrUyerbKytQcqUa8Sr2BM4w2eAwZXIq9afDAGDjXjYLV?=
 =?us-ascii?Q?WtqTrlbP8SWIIAYtEtnM3HXJNG1A7tphj4MYH4v+nX7NDK4aAK8iRsToHYMx?=
 =?us-ascii?Q?uTlE8kKZXReWQ+j6dwJgbr58cugtIYr7G+yUO6p3mkTNU9PU5/LyZGfp5vtT?=
 =?us-ascii?Q?4i9Ud1SFe2536cGU5MGZWuuyZYA4yhAChMheU+rtuqgLpNSj5I4V30jReE3P?=
 =?us-ascii?Q?5ODnqEFvZWGYG1yYzkKH4q7y3oLo37JjefZuCA5SOpcJZgmh+I0UgorFzjj4?=
 =?us-ascii?Q?hSSRVF9kiAfGURJ44AvFxr6gXKnKjwso3MOF27s1lX0cRf8lxDXaWT9XKXQ4?=
 =?us-ascii?Q?5bNs7f6nc5zgnMmRtlnk5TgU6YYKbYlGKz2llhobJi+ldWJPhhcJ70U7Yb0D?=
 =?us-ascii?Q?/3Ww95uuKQUlRNLX8AGu/1oXEe4nemH8YE9Jr6RvUIOVS65Fm5L5rXs2qfIM?=
 =?us-ascii?Q?pZG20kCxUGkyxNnc2o0kzL+rMFvkIFRGKLGcDOUC3aW4Gjv2N+/JhtHklBBo?=
 =?us-ascii?Q?ttCJDEzupZn6MArta5GqM808cXu0+m/5FU+JC128s+/HMtJBtXACvUROCC4l?=
 =?us-ascii?Q?LFsiilXrFSW7Cd+h5X6apdnB6CKHC0A374Dbxls989kBen/+bkhhcsctsdpA?=
 =?us-ascii?Q?sYPEw2T+XDU9v2BahPU7whCzcxbFy70=3D?=
X-Exchange-RoutingPolicyChecked:
	Kt0kiJ3qLKKl6JW/GVPI2z0+k7wsSH7AmCc7GqJWBzFLIM0NR/CsXuAkg7U2NLqTHTHbQzn2F53PK5y3SHn9jVWzOb/R1ub7FuYwm+l/gMhpKYR+Hjrj58B04QaVhFIwDApNE0ViQddJGVAynueCKe4ErAEmPfcIUYNaL312Hmw7M++r7VvVY7/SNmAO4MMRFP2RU6XjfpHkIWE/0oWdfOr9Ep2zZs/zP4MbSWvSK0cFQ9w4tjOl1dFYvvmcvrzHdEQmLo/atJtF0CTRS90Rj69zjaT8lVKpVeNGXOyjuIqkr5s577LeWAmlPqr7do0auGX4sNlK7Ei7Wr9m79G9zQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RA+XV9NVFcG/ZwaFBWQa01TDo0sA/TogshN7DJS10bya5yxi5lUqdq2AXGgNnAK2w2RC3Ev8r1feM/NTfTVwTrhAB/ELqG5odSC2y6wZ5XX1SHr5F2pWbw50qxxLYfBXcomrZkYb6vae+vYaf8A+WelOzcQRe3bJjEPu7GDnJYzQsIM++UB3QkiCx8M2Pkgou20MoHi15w+L5Rj+iZBCVe9XJP9s8L1ekCiGT6jLXm5ldcdZ0DY+whqe6jwNNyAhKfng1aHKDJdoYhDx5KM9NE4H+2w0HlZn/jUXtNfS2nTHThJBRPVtT57pRgZr6hcHc71kJxxdRAYa7+VKXsQ+VFc2fSa6fHkzPGhqrpOGwoygCaM0xieBTP9YFMEIBKEYFm/3RkYgAJ0Q0nfohmG8dxQAMJdXoLovv2WzXAS77cgtR3EqWf92OJ8NsbdfNuZipV1Chc6R7ZBZGldan9TCt3ImqR7MxDqAhatutT4Wk7cgMWijvsFvsa89pxh+WSNXhPG4NGE78F18PSi4Y8KOU9wroAaw33lZz51eBtfQhd31V4WXYS5RMMFLTlGo19zeLcV+8VE7WnPgrfzbEfPMwgsmCjBlvGkRZaDwcCNVjzQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd20fc3-713f-4e8a-57c5-08dec5a77b0e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 21:47:04.9225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUmjNPG/+1MMHCknSYiyN/jf6Inok4JZhn0t6+/Q9waw2suU/N6QhT1AP3nxHMP1OxmW+CThVPpYhKyKaq+kKJRDJbdunDujIJ/zQI8KAys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFEE36F3C1F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=705 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080198
X-Proofpoint-ORIG-GUID: NpDM8hgyNmOW8eBwq8pfA0dg8G3rwzSq
X-Authority-Analysis: v=2.4 cv=crirVV4i c=1 sm=1 tr=0 ts=6a273860 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=UbfZsb7zY6hhTfayIt8A:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: NpDM8hgyNmOW8eBwq8pfA0dg8G3rwzSq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5NyBTYWx0ZWRfX7wdBtSg97MRL
 5iGodjHbYFOGTrlvukWp4oPScMBk2kS/ESAaFehdT5IAvaMjU6a39cztu1rIICMYMjeUTsnpZSk
 KLVFPUqLbCAwgxmxgTTbBRoBUHcR0CNCIZ+7d62tGeb3Pkx6ooZd3m4746lGSt95nXqEYZrnIg/
 5f6bQq5w5ubvi4Igxx8aMNoe8SKeT/ogKtvt8xZRJAIPuh4R+PA4chxwsNKacV4PttSL6L/N464
 ZrPmVApqxe2r5lgYUwqJBFsww2x8jqoTGYX6qz2kWlgM2SHPBbGzE1BHWMwMsNLXCRrHRN/UAoK
 llU+31rNgkHpHwXQ6qu+28KZXYh2LG7JoUGfXDp2PYdsFhh5en3wJSFzHzKv/lBqj57j9v3rnbd
 QT8vWLtTLXx20qexqF/5B+7nI3zjOQWNr9zoB8WxCRTq+s+T4KdgTqWwpqAJ1Jiomkx25jcfa9H
 3tfOPscc+i0svvnIPxvVtutFluvcHe+zJrP7Ulbg=


William,

> Comment-only changes across the lpfc driver, found by running
> scripts/checkpatch.pl with the kernel's scripts/spelling.txt list
> against drivers/scsi/lpfc/.  No functional impact.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
