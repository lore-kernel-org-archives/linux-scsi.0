Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1A4C97;
	Wed,  4 Jun 2025 02:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749003384; cv=fail; b=Sxbh2eiZ1MYpyY8kZfVXWWk7A3H8hcRkRThM8UuYSpMyeqlAt4gce/+qiAuE7S/olIxeG1HNQQaQ9ZBAkrcgs/iRTft88s3BVuL/7FDWs66nQ0vym3ByNtCD58WlNHe78AeGTt6rdewT1pHvVZEOeS6zvWKOfU0mEeoF69pVCNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749003384; c=relaxed/simple;
	bh=X1Sqx8150+TaW2OfQTuRjehK+gftie6RsiMH5zrJqCQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZFaRBdJYs0EwV3KY3ldnymi5SpYFEEIBlzd82MYAwiamSKYKCXi8iKdtsrAmfSsFpj8RiMMXwB9krfNo9UXpa81NgTFhr2nXKZLeOC0+nTEvGK3GMORF4MD2ND9GmQn6KmxGmRDiLWrjBtOlzGpedU3iQxhh0NY+2E4dqaHZrY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ai7f3CZh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ks4gX/9g; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ai7f3CZh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ks4gX/9g"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 553MNSnw028411;
	Wed, 4 Jun 2025 02:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CH59pXmvHE00GqENqZ
	jFx+exSPlfVF7vMk+hi7F/uO0=; b=Ai7f3CZhQ7z+mIbYwCksmYGdnj5iJdLxOQ
	fv70Fiqgh5J5m+aDrHdlq5H9iZRalmGlC2f58shJTbYSJMDVZFx7t6t15BuisBH/
	wwh5hJn6K3HWdNet6tnoFdKjuSSVezONpapMITytv82VEnr6veDDCZEepaaZ6/sW
	71envG6kspYxZdU/DIu87TpyGqVo8zsSyy4ylAa1VMm9CNy+lQGdLbYaVX/9RYjh
	WukF0DN+O0ywVoIcEk3e7Q3sNvgnd3ymbeEPr3o5biz9VrBxGIUuQwo83VfJdjWx
	d8aFoC8wSrghPoBxUiyg4S+o6rwWhzqfXu5oDhIRaYWHIkTWdN2w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471gahb4ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 02:16:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5540vN3w030930;
	Wed, 4 Jun 2025 02:16:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7a6a6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 02:16:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ofj+rx+RlB2kdD0o+685AC65xLieditYkMF28vEKdv5rZL51qEzy1ncs4jWIZNBCM/Tmf12Wup3I07R5W6oyeMVPJtmKsd+Uq7kCWrTDuoRsCz2snPizqYafJKvX2MJKXzM3bwu+XwsJ2CpjX2M+AsdWaizQJJZAYql75i9gpZBVsRPjg7ux+s/b5GJIgQzQEwHblJUQzcrguHSe0nqTZLQl5b2eXCy2lkFL0O5VOn2HxHmE073LAQoFL6lu/v1fjOin/o7eWJ8YeBH2ZmXumbTMeN5O4tuRLnQL6ahT7eCuv1WaVQNfCA05BY85V0MIeK1YiMiyW/2ZSxFDQacU0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CH59pXmvHE00GqENqZjFx+exSPlfVF7vMk+hi7F/uO0=;
 b=QRFgH476hyI/VHAqTG2YOe49seq58+gLzNIZiIFKPypiOY9WXhvCidPYrNadAqpoYpc5nLzFkNqsXkjWvdqL2JQ859YvUrNko1qanYUhBNxScuC6CEMYz0DI3l5/LIEwVp5CXPkeZJiVF/Lw928+AJZqRA8tpieSOebckrjOtpV9xTBbC6aJKKjLjPR7cvGX1NFR/FWOwTdVm1mvPzGwQntki3tPvq1sqfThOj283GJWng+HB/txXe6PSLNSYvFK0I+REcyUrN0PPLIlPVT16YHpg2L0B/WTkjP2wbeiU/sLA1XZ6xRKdETYCuW9+1CmyGauy3gUW1JC/rC+baOuRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH59pXmvHE00GqENqZjFx+exSPlfVF7vMk+hi7F/uO0=;
 b=Ks4gX/9gak4GIjPBjOcbaGT1N7msnCMbWp1wmq+DMX4ffxfOBlFNOSyCdJ9sC3XtEQKIBNrCZgARhj6hvDxFF1rKzRj4+x4gKejOd9nLE1Wt5dUq18dHIUc71JoA1Tyin0AYKryw86mzEN/aj4XSjO5vlWNJwXmCT6LFUISE7ZQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6082.namprd10.prod.outlook.com (2603:10b6:510:1fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.41; Wed, 4 Jun
 2025 02:16:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 02:16:16 +0000
To: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: <lduncan@suse.com>, <cleech@redhat.com>, <michael.christie@oracle.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <darren.kenny@oracle.com>
Subject: Re: [PATCH] scsi: iscsi: fix incorrect error path labels for
 flashnode operations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250530193012.3312911-1-alok.a.tiwari@oracle.com> (Alok
	Tiwari's message of "Fri, 30 May 2025 12:29:35 -0700")
Organization: Oracle Corporation
Message-ID: <yq134cgdzfg.fsf@ca-mkp.ca.oracle.com>
References: <20250530193012.3312911-1-alok.a.tiwari@oracle.com>
Date: Tue, 03 Jun 2025 22:16:13 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0063.namprd07.prod.outlook.com
 (2603:10b6:a03:60::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6082:EE_
X-MS-Office365-Filtering-Correlation-Id: dd55ea79-afad-42d4-7a8e-08dda30dc923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4mLuSuzC+ETG0ige3VnJ/SY/U8X55ltRXadoEAVjJ26DjZP0UxqvUKcJHsVp?=
 =?us-ascii?Q?wl7mt1VCyQaSysL1C7IezK9+NmsgkXlxchC732tWzoBT96kw6SKUButKokJR?=
 =?us-ascii?Q?uYe9/ay9KKiRQVUY5F1ha2ZBccf1N7u3iaMNasdI9EgAwGfqWc8dG+mMDUYK?=
 =?us-ascii?Q?bIIqrzYK3PeQL1A8d4jBtbcR9cYw9/8I85jZK9uadyP44t0E1vUi/YZu5WNR?=
 =?us-ascii?Q?MWamiaPdEuDo3b/KogIeIQNay1n3R5NnkQxVm0hh9IVhZKyNj6yLBdY5Kprg?=
 =?us-ascii?Q?UO6kYqFR9JgpRmDAjklrk7l7QHIPB5kFTxT28mn1W4Zg2/roV+v5emrFyh1E?=
 =?us-ascii?Q?oN199w+TiUMC/ILuhV+Jj+NwAk65mTdpvAQCp3tTwgZS00GrVG+PE9kVhiqQ?=
 =?us-ascii?Q?rHNgrdhdUEI7toABaCt708vlnxmjzQdwNGQoxzYPRmfrgydVeYD9nfzQBJxE?=
 =?us-ascii?Q?7cZZ18D5NQYixXY82j5Cl0obqIzDEA2WOPhL38tARgkq3oUPlJIuUZjbn6he?=
 =?us-ascii?Q?GFsW49C9IwB8YixFmX8mULk+7iTds+jaD5Ym7HlDhJtTj88WOL2rREGwpQ+6?=
 =?us-ascii?Q?54urpgYOKg3Job3DusMHW8obBhsdy1LgUNMka2CRQ9Mg0o10VyjLOvr0W7Y1?=
 =?us-ascii?Q?CELCMKrjJoJ5ygpwkTr32402eJGh2k/Asy0jueKb4EE8jmhw3VdidhIp0iSv?=
 =?us-ascii?Q?uxEcBNoVnvURjMoLzas5Crtdfo2aAWGxZDbwO1H+5QKmYUHr2+HeZ8/V0tAU?=
 =?us-ascii?Q?tzam8gfZ0Fe1aVQ1yxW/3Eac0t9UPGd7sAvM/TbXowF4WeuwwTvddn44fqmR?=
 =?us-ascii?Q?a0jQRqQzQnGe7kC56h/CySQIMpkqyPgGltFT1d5e4tmiGvK0IfCZMaLsjgK+?=
 =?us-ascii?Q?hErqUAKhB+xufP3bBb01fR69tNtG5ifnrsSRcMf7YCCNyqoVoVhgDebn597A?=
 =?us-ascii?Q?f0lQWngLT1+K45jPR58Y89VdkJ++aJhHiRQI091DD6yv4PLj7pE8+rnH3XVr?=
 =?us-ascii?Q?JGfoGd40gVWztWQcUQiVuP5b1m95bQRh2bRoQ1pEmxt6mibH9ixorbrBrTSY?=
 =?us-ascii?Q?7nhRKzk3E/Bceoc8yeeYCSobugNn0S3fwgE3Aaj+lLHGpuazuCMJH5fcMBXj?=
 =?us-ascii?Q?xEXMkD/jK6KG/mfCN73D6yJJv6tP7jV2CSQbj5op5xcAFhGnP7Za022PYiBx?=
 =?us-ascii?Q?VnR+S59U10Y7mST1j3can1GkBBmGPX1HUCqHx+hxqXC4BaK3F3PgEZZVvRP3?=
 =?us-ascii?Q?ld5tBs1j2RCZPRZdqmnJCm7BEX3KaK/uxhfcPQrSej+HB+Xk4dQa2UKIwH/M?=
 =?us-ascii?Q?ELDtNuQT31RkHQmtB9MOEpwNV1gCqAmc6oENp6Kphy1iGAF78QjlSjYaob2F?=
 =?us-ascii?Q?y2D2Ki4CqQ4k2OXo54IrzUie6pv0tK5OI0efNiriv559Xyexd8gI24V2LBiw?=
 =?us-ascii?Q?6HxN5Nm7LTk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SNw2FhfZecX2c9DrTQMtLs6DPPEr0h5Fo9IFRYNDBk/qUmoUWiBqaflToXyK?=
 =?us-ascii?Q?OG7JeQlNvyruFLS9Mo6HED5dqtlFICuQn9DTaMgJZwY/XEoB1vqdGk9ag87p?=
 =?us-ascii?Q?/yXYjOG4lTWAj2ZW7i9f+nBdkA5Qu8a7h2bOYcXL0zXxAuvZTWSOgIQENsjB?=
 =?us-ascii?Q?eufZsyGcDBCptFOow31kVil0xkplg27GI6++8Me/6wysuJwQz9BIU9NrZ10K?=
 =?us-ascii?Q?31n1yVouMgfEAI036wZLUKv2uedSL8TGbRbt9WY0ZPguirGtNW1/4Tetvs+M?=
 =?us-ascii?Q?f6zUDWF2k0+N+VgxbIi6zfhJrVVHFbzDERwWeyRXAKXxuaqKnRSrzKbm7P+J?=
 =?us-ascii?Q?6APR9FvHcLUaeurA8BgSSIvKyNweO3Ci/pTsGj2Fix0HOs87tncNw34e/Feq?=
 =?us-ascii?Q?jy5+caxGSe5bJfFD0bKxvU0JQ9QyUgzk9jj8zSE07FwRymcnVZarSgSjBHBo?=
 =?us-ascii?Q?dZxjsMXy+MyppAWWnGFegd92FjYqEspNntARPJSqBscJWX3iA/z9OSZ1c//8?=
 =?us-ascii?Q?AZZTPcI7TS9LSznckyJcQRqy4U6lC92TZzUJTlxUo0c7uDv5S9AU8rkQFiMn?=
 =?us-ascii?Q?8x41heaLrfrf4qJXJ2xDcRfc4ZpWiJsFBB7YWb2LOeR8YPnx/xkFIFnTxFzi?=
 =?us-ascii?Q?Q3O6XCLJt2K4h+7S2VaR04qhTaWJA3mmNgDRO3mV/WVy/6hdzgMdf6bMC0l9?=
 =?us-ascii?Q?O3qWqG2NygKrqBnI8oSsmCaKcBLFs8J9krFn1XVQUdDL6dll3rjbRGD5w/oC?=
 =?us-ascii?Q?AiEFoxHJDHyZ+E6E6LQJ/iLJj2cA4GzuxzKGpxVJGNYs8risio5jHj7C8/pl?=
 =?us-ascii?Q?Ml0ImGGGr6jH1W7xWiVd/m8hP+HSep5qhRe5hCG3QdPmfKhrjB79H2wNzppF?=
 =?us-ascii?Q?xAOvrlN7thMhrHBeEU9BOt0H7OKsFXvu3xuyfmHSh9HRZs06XQFh+szOQgjp?=
 =?us-ascii?Q?NFmoBc1zU9Dc2pN7ZFJrv0HcD+KEtnJpQ+XGzGhwljTIilJyoKx9PuZZN22r?=
 =?us-ascii?Q?qw2f9PvSlCTyrhjznOKiYuQqZc+A+bT5J7bDZ5+G2p21UputZ7x83tR0xXst?=
 =?us-ascii?Q?++xwJ2qkfelz31wDi9V4RhgblbJex6d0XpUoOniNmC9bHyUNWVm0htfFJM9B?=
 =?us-ascii?Q?CVX30+rxodAbbMKfZoEB0Pz9Qilv2tPsNHb49mb/MvmkKQ472LJyACF9yH/d?=
 =?us-ascii?Q?dbysyzsTOgqbRM5iTHKe2xnvdjqquJq9brgB6jZ1t6ymGvnGmP5gKDMswasM?=
 =?us-ascii?Q?mtHQJVU0sI88+T9rdfRW7NWHWvFld3u0gFRnaWerLPyrn+SEV0EfMWUL5/E0?=
 =?us-ascii?Q?N3rewKfRKfuGvdm1+4tLo51zue9rDaWfbqMhPGJs/wNNxRp0aGGvv5ney27T?=
 =?us-ascii?Q?SWVPtmURa7Ia+HoDIhG8UI4ID+uzpJUhqVTAtEN/pStjwceb2SCFpbz+ZCbP?=
 =?us-ascii?Q?zgI1Dum2bUWbDfUqDqujXZ6MM5xLzkaXV0EyEbnJTSun+PXqHYUw9C+FHF5j?=
 =?us-ascii?Q?kFfiypmgPzlnKaB1i7vThEgxlJGUSXxZagSw2TPfV4Bg6soxZRI/vqXr8cYL?=
 =?us-ascii?Q?g64owJstUeB6EV7MkiFOG9mghEONEpZE3Cb2MRJkTVPVTywikYvhBp0MfobD?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YyqID2TgrBL5A5VWpRUS/HheMLz4iMoMYDyPDB7mJSCneQqC8ReMQIXOpKPvvKRrjalyG8kOZSdijWutoHSAPQUkocT3FFLNg7G49B3A8iKQ9ih4L9MGJofUWAJQFI4+LqXDKz6Ru4spx0XJTv//Az3JfDjh2tu/lsjIRsZLvXj7RB4Y4wfspLKmlKBDqQdeLtrT4a/gZt+foxqpUjI5lSacpGunVZkG1cuEIB/jdmHL8Pz9BliqwUsAsobM0ot7w4yungywlqGBOnifBhoCnl16BAkoitsU8wCqXRWqeIoEQrfB+67WhLevudySVaWAIeNpZnJAgH0IR4E0oizU/ketq8Z6CjyAFvjz53iFsqjgCL9YNglKrUDkmEBS06uNi+DS4ppYizc6hT8R2sc6EJcLt2ckYzVpohf79CY1/APtGt6809Eq3GFaElBg7bwewWgHdiaCUzKL8zEGd/AkhZ9TmhP52ujp47E0Qf1yF2KlOWBtulV4tLYbWdaxrB7jLuhT17q6PrHu/ey4ZXdGvTfneGykpJL/VC86sc+yHp7k4hUG5Q3Yj899p0TwnfPTjxzsb1DQJXmz/iSRZoElZFXcpsj9k623cYxNhv2KTUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd55ea79-afad-42d4-7a8e-08dda30dc923
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 02:16:16.2494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+g1LJ5sKcSQ78sxFfkarkO19w/o6tVOb6L18UY3YxZCJ5PuRXeWmcGwBtXandqbObBS6j5pHUHOH89/bAtcuzz5Bph24gfJZcQYo5XtN5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6082
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_01,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=955
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506040016
X-Authority-Analysis: v=2.4 cv=aqqyCTZV c=1 sm=1 tr=0 ts=683fac73 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=cNMCkp2XhuoQE_LABBQA:9 cc=ntf awl=host:14714
X-Proofpoint-GUID: as5IbEbsWElpYzMKvZ8H3QPGD2A0I3xl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDAxNiBTYWx0ZWRfXzcc+paeEU4XM aTNWcT2CfLCf3dp+6KjrLAUuIpFuOfQRiCXbNXNHKT4YDoO/zPx2waSoWMJxdS4w7b5WHX1MyUW sqUw2fRuVFXgiAxZtCJpWu4wlp4T87GHyzzECDExLKgVFIdBP6jHV0MsgBPbriXIwCg1UqT3Jot
 7v1OlgZzL3ssk1aWw1F3gLFZhT4B6UJgbaqajruSVhpQN6Hy2Zcn0sstE7GTUQdu1U8LegI9zD4 NgMmTEDyV3qdPZO7rCD9Hpo72nwwh4H0rr0LE2bkct8T6i+TM79f86XG8pt8KkV8hjm+PhPXcOp IuhLEQk44T3Yg4LgMPG3I0aRnT32aWW52Q6IZSqpWLXnGbxQry6Mr8JNfaxJ3N/NpC5LPySaKhb
 +2MJPrfYjoBl/msLmJh3hRXpl2ZrHa6xNd/MlKp6g8jPtV52XxQNHxQRFe1hqjR/VLy5LQr/
X-Proofpoint-ORIG-GUID: as5IbEbsWElpYzMKvZ8H3QPGD2A0I3xl


Alok,

> Correct the error handling goto labels used when host lookup fails in
> various flashnode-related event handlers:
> - iscsi_new_flashnode()
> - iscsi_del_flashnode()
> - iscsi_login_flashnode()
> - iscsi_logout_flashnode()
> - iscsi_logout_flashnode_sid()

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
