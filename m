Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D4826982C;
	Sun, 12 Jul 2026 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783877879; cv=fail; b=lnFCwPihO/cj8o/UrkYwABWhEgq3tErPABcu4XLKeCXB7gOylanpJw5/CxTV+oulX2unhIoTC12aWZLJ/eR92+34Ighwg/fHan5Exuqmv30W5Iec+Q+Y/mbQuksW+H3OzcomBMxmbtgV1I6/aHl5XD44/zv2suGuPCOqu05DFPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783877879; c=relaxed/simple;
	bh=eVkLlcGL5mamX6wUQ8d2GsY0asVpumLxIJDRaeJhGyQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kq2IQPPgEWjChEwOl5V0iJoMKrf08XE955Gg2M9OOfcvyjowX5G9v3Ehil/Ecd5b1Ccj4k1jTtsF/Puzn83uvURyEZw8TGeIyM5r6e2nZMUZ5bTbQ8a3w/s2LJ7gmtNVH8ZGFCayf0Xu4BEg8MZHMvrdQgFo16I6LbH1OR9Qdjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=isP5+nWJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ydWAm1HB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="isP5+nWJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ydWAm1HB"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CGepJG3588203;
	Sun, 12 Jul 2026 17:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PGB+MJagQV9XbXrAWX
	YsgRmiANfilSD7zCCKUjOaYQw=; b=isP5+nWJp9RCdMQg6FyuAsDpuBQsr854KF
	AvPZOVrODi8XIImsyJwkHVvn5+/d8WRFdw9QwEDi4aRKRHId0PCNDwzp1e5pByr2
	yoghwKksLEVZHgFm1YSYkIRBfoE2Kb7+M/e6WEUHevMmK8lkjj5DjdSoGKdr3SLj
	m04294TNBXv9UOl9UyJ5qs+IyfYO4AIFC6sSPyYLzxOWMltEz7eWnXJTenIwgSBQ
	OBhWGld4pv950bPBDVOP34TZws5o/5PFlRZ3KYacvF+X2oO8iWVni1A5KdjY5J+S
	XzC4G0MM7j2OfnW/Kga+y9PqICgWb45DQpT/VF0YmRm7FVLSydfg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fben1h3xt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 17:37:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CHXUGP031737;
	Sun, 12 Jul 2026 17:37:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9pbfyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 17:37:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XVrGsxGbkKPazU3j8SgFTnRQ/6/wMVQCL1Bl2CfZ9KPJfS4GwY+Moqd+qSxOt+M76fk1BzHVozmkhIWH1uaml1oMeBndQQahRFv8YhwoFatSXLD6+U8iKlnsE2ZeB78wPuAQNBlPmV0uOI1GuXbC4a11fZ0FRYrXy1fyMIprmew20TVXGPzeN3cD+nGlrkPNwjWzu4K+Vm74FbtRqLlQL4L0kGXWz+hYXQwZzzQhN+4EroFFeM7BTrxeLZDyuDkilHJiLd/WNBcws2izn5ut8jw4G4OqCoR9k7Cx6QNp27+qu0STBcE0MX6uyqe2ZvGrLdAujd6oE+YNbFRkDKVzMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGB+MJagQV9XbXrAWXYsgRmiANfilSD7zCCKUjOaYQw=;
 b=lEf0iAdzCVFFt/sfIZVx72rjObK+iXkxqLvPhbBKXbqfDH6EbGxi6vzCioL/kPgWz7CcRmarrUo4gRucRF2aYG1g2U+FsytDsrfbxZkuFq7nD2gUDQzTjH4D2BT3LAj8ww12nZCop48tPTVr5UJWQPgtiCXE3UH/I3xnpFRvZGZ8TM65uDBtyYi0xaXkYyX/w8CHCmnTk26mqTKGSD1APOQt15j+1POo/2MIV0sz4MQnt9OuEpWX/Bw1Caxdxa/yxaj4MTcPbAe/vfk0ADv5c0/+g6CVC2OHn9GKhRqPJ+GIRTzlejT9ElSik3l4bcjL36QS968bzQtIw4n0dMOvIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGB+MJagQV9XbXrAWXYsgRmiANfilSD7zCCKUjOaYQw=;
 b=ydWAm1HByVdsxdez3nmMCFtfbzwR7QZ4OppRSesUuSndMc/M50sBswOXw144zelf82RbUA4tVJwAU//2AAZ5KEjF5hZGGlijQmSn8dYz6nhNBxSYIXlJDIsHu8akB0Am3Oxd9F/QIkjwDYvfWYrXw1w4GK28eaZ+AEt7tmsFxko=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 17:37:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 17:37:26 +0000
To: Himanshu Batra <himanshubatra@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, vamshigajjela@google.com,
        manugautam@google.com
Subject: Re: [PATCH v3] scsi: ufs: sysfs: Add HS_GEAR6 string in
 power_info/gear sysfs output
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260616100121.548759-1-himanshubatra@google.com> (Himanshu
	Batra's message of "Tue, 16 Jun 2026 15:31:21 +0530")
Message-ID: <yq1se5of6sz.fsf@ca-mkp.ca.oracle.com>
References: <2026061659-enjoyer-boogeyman-25c0@gregkh>
	<20260616100121.548759-1-himanshubatra@google.com>
Date: Sun, 12 Jul 2026 13:37:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0186.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: d1b2b481-ac9c-43ec-611b-08dee03c3d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|56012099006|5023799004|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Lr4FeSHBzVuHP/eN94SGn5m3FANvxPDP3ywN5mU2LKZxJ5oT5Qj0TYqt47HRDcD3dsQRojWF39MUmH0KNosFarZdN0D3CXrscMCe/teQAUeql7d0z1At8BiNV4Ur78j+yFzhy9N8bvwWUqxj1AruwVF34QIvz/hTavNYQOFladC+LoFw82U5hXraT1PInrnojTZcUUqUX0mYA3BFOfkPm/ug/G0V/429M8XnxLQCWglGDjWHqzyT40rqS/qCBWuMPrHvJBUuQqNp3pIby6n6ykCJUUj8LOImv3ZCqG+wYgtvGxs49djjtrjDImMuxubt8Z2Jk33fODdswTDlj7YjC652DD6xc69H1MxG9W2lIQ6U2t39to4SNjfJUjrOEmj+DG5wGJPi1risR0JRoK3KOdHH15x9YGYYrDFaL2enisnD2VNc5d295IlIUeUJvgzhEQtiVsY1sa1voN1ov9JMQd4D3M8n2NCkjHia7w9+0pIxEUVTCDT7m+LHViguhWOQb5qijGN69sss02mGHrQi9+VHiCfg4880+rxWdhDiFO+G63E9Y5BBvL0CJ3lhQB98h+aV2sXGG6bCLk12o0Ae04lTL0Eii3SZ75dtV3lWdJ3efn9oFsufMq+Ho/UdbZG/k+4gLw0vaD/VVlJo+nkvJYn+oVgZj+vOoKmFTaIrK4g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jm2n/JXnvDQLjf/b5KZZD4qWvMjVDopAAaEL1+CSJ1oLvpJtlJTCcqmYcs26?=
 =?us-ascii?Q?25Hw2+3m8HM/eE58NK78lL0QjzL4Bc6PwgHCgEe9HO3BVi2ISRpzXMc/HAgg?=
 =?us-ascii?Q?De18fGOT9R9pq+GIzm0cCSM9a6JJrrDIqMS32dyX5Xh7L3Oz89tW6zC9qGFA?=
 =?us-ascii?Q?hyyFvXNEvkbUZL9SH/72vyR4lnQVz6bU7COwE4dxIFfiOtOfQM9ZaxtjMo3s?=
 =?us-ascii?Q?gSAkireTefOjoV69uimNNXiwSkNt8so5W1snCZUqsbbdHnRl+403RnXccLd5?=
 =?us-ascii?Q?myOSywcUZ11kKXTLvijjXcGIUvZsp6bmAdcDtoPYQyGsWtGqCOZ7IScxrO70?=
 =?us-ascii?Q?l3AAH2NfiVOSI5lH4BUoknPDcbmwjzXEAGlFXzHRWGrsM6N69KFEfsL78IDh?=
 =?us-ascii?Q?1s7IkK5W4NVjFPGeb02A81B47bUZKzi5jfOfppKBVcV/vhGRkVz/ExjaZTGg?=
 =?us-ascii?Q?KI47ye8R7EYAOE6HygNUVD1y9RoBEIeR4KkatuGruavI+/X7ztP9VwwrkXmx?=
 =?us-ascii?Q?n4CYAd6hmZ6GAFEBIK6Ys5vQ/+8trG/uO/mI/sslU2uhrDCXxscxCyJvdxRt?=
 =?us-ascii?Q?w415VdmXTgFEwX40NfOMuKllRpvk9seqLefc8n2bKUExObZgkdfOADNyg3Ad?=
 =?us-ascii?Q?eUXu0NoE6jwXkDrHkKW2HR61fN5WLZj8nlhjgorlpnvFtcTaaLCWsbq9OL9N?=
 =?us-ascii?Q?X4U46Y8tFa4TEpwOrno2RFkxZo07pZzg85ekKEiRflSMkq5GM/Pat+UnVpsn?=
 =?us-ascii?Q?UGApNS4C/eVGkdwvL2566rCnNaZj25eypzJFBrWXkd53z133XXvYDrZIkcyr?=
 =?us-ascii?Q?lLN2WecQpii2Xss+/55+2oHexabMMBfh9Wjf9Km5L9wCwTXGgiNtwz3sJwHs?=
 =?us-ascii?Q?TfIVCkcI7qLZtSLJqx3iQZ4v/af6Yv3/n1JHrHLFiYJzCOoGXkOVvwI3b+vN?=
 =?us-ascii?Q?18JSo8Z//iKyO7JOqmNQX8rYr+q4ix18/ibSGD53Hz1AIpVxAL/0WploFgVR?=
 =?us-ascii?Q?j8dPYyRuURrGyJOYfgkaiWmkhoL+i50vmRxPnQgyXqdT/89hjRMQt+RkLCcI?=
 =?us-ascii?Q?I0tuCQ57kseDk6DbKX6Ds9dIBah566vwzF+Dv8F4Dx+ymwm35IKZ9ml0/ZuM?=
 =?us-ascii?Q?RFBQ0ON2tXLjLHjo0u0KhymRMJ5RPBUjrNxnLcxpA/KTeSg0hLcLIYEJeW+j?=
 =?us-ascii?Q?JYbfVmQkygnAF/75rHsQ0W0UXddJmC8oOkPrsJUA7GhG1F6+Z5aSN9/2c3Cs?=
 =?us-ascii?Q?cvhmblPoH5GbRNRW2Z/Jbe+aDVAZNicN8Baa+FdKlmdZ5aIivjDLxGYbR3jx?=
 =?us-ascii?Q?sW2kyVKMZabQbH65B6FsQhIqonYZCgvqDsIsmhPd0P8RqyNCoRyxi7znqwBX?=
 =?us-ascii?Q?OodnNCwV7aLGvXwRDZjoLY4lIz3yJwFGcFXC3zB2HLRYQNj4RnfTd92pKmZa?=
 =?us-ascii?Q?RyW2+RPHv4fkNHfnueua8n8t/wBd/ce5LmFBiyhlcSQCAg6jKtIynWoHhlEZ?=
 =?us-ascii?Q?n2ubPD0cwfaIIwT2AHzyQX38xFeIr7Us15v7l65ZrdXwNTfgdSH2zqUTKV0R?=
 =?us-ascii?Q?sC8d1Y4VQ6MQv8rjrDyrZwqce8W+IiltsURDLxrCz+S1L1MXGDvEGihLhc2F?=
 =?us-ascii?Q?YHhUKFBz5TObscbBqsKczpgXFg7uycuCl3YYQAPdZMKDb3SUVTaxQrPUeItD?=
 =?us-ascii?Q?qo//0M4RITPBsFjSLuIAv67Od5+lLGs0UrD0MThUyGq9O9kQuI9y+bNpgK/d?=
 =?us-ascii?Q?QZHdjQxTI2tF5t/LY8Ic3ComAQ1gn+A=3D?=
X-Exchange-RoutingPolicyChecked:
	MiIcBeJwQEdla8YyviqBWotmI+wf8RilIWNlyrLHhd3wcii4HOeEmSRDTOtfUO1VZ/7YfTs12G39HCDEfABq5fs0cR0eosa4oiAJgx1IjRjTZ0+MBttakFY3koa4Mr/9kPn+mFbJHfjvp9/w0ZWJXwcPgVuSa1kIEgsjOr0gpHMGoLIaXvaiiS/No2fN3xN/yo70Qb5iZzHCA2B0qAcT1TpFajAYDpyxl8pHH+UPTW//TSigxLpjZBbaMMzS8pDKbEf3ohUI07DwnBdFyGVr1IO/0NIMpeZuYhrcevBMTWVUMXEN6DKiE1166ko7P3YYbRsdOGUQ7QX5BNlhv1XVjA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	67dMyGInqM2ZP+vWEnPMEKQv1hcnuJKTiZrsdneutxbd1k802M7IWJmoCKjZaH2PQrgJRgXzZdCgsTCHflBONfcd0PdAFe0AC9xk42Ndgg08FUn9zMYs6cnpOVl2CQzNr+V+OTcuj1s9BX3WASFlQrLE8xesXcHVqNC/Q0KBvcf35Y9MLwjJwv49ASwLqVekFm4dGzmVandNpu7RnmTEc4LL4lWpE2FGC5qLN4KkmaSiFdUwvXXnFXCmSDDGFUfUsM+t10jrBYoyic/ckmm//QxyqXH/INNyWlH1CVEMYsqzleDL1IGdSsuH3KwKa7wWK0nr9n/cDtZUSunIGr1H3s36Rmbx7OMflgwHtaAo1dbctK3D0FN3IGogsEz5r7A6W2+NVxPmvIb/8qYGlo+HxQ9gUvLfVXYoJ1lRGnF8Vdym4eyNn/Jcgny9aqj2pxewJpq+ZBo4TyWHC/zj51/7wQ2dXHN3eSDddSioGZiMJVdtOGMVeD7TNY0IatV1u9QU7WBinpvyxfVhBVPVEtu2o9ZKGpA6MIF1XJMbuL7vyxNrQ+clmluBLgENeGyC9DGNidiEELMVSTifR/ecpD85tdNwZvUa05rYhV2NmSoT02E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1b2b481-ac9c-43ec-611b-08dee03c3d80
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 17:37:26.8911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3v5kwObU1hETS3gtzDuRQ/3RBITJLB+O/s8Y0BHr+vAxBU5/9B4kYl5wppFXOlAeMRgwHlmNBZrPOA3HOLzJtw293lKgGTU7AdhSK+g32To=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120188
X-Authority-Analysis: v=2.4 cv=d5nFDxjE c=1 sm=1 tr=0 ts=6a53d0da b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=_I-xcDXqbgtuexIhCmAA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13633
X-Proofpoint-GUID: jBCF3wU_KXYplyjDPxYe3auYN9v9UBOa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE4OSBTYWx0ZWRfXwMfd5fyxiMaW
 uT7/dqvSfu+R7IaXeC+dSQvCBE7iHHTAQ/ENI3JOtDoI75eH0FGSBCoa8lXmG9aQ2LN3ajDbbdw
 G1OC6SXjmeZI0XF664jMM/pnvxOvUuIrJnUA5+LMDwpAEpsLRaoicIO2ErNrHs2msKb2hD9/mkf
 +ab5wOsR955/22jrzpeNZQ0S9x0Hu1nRHhOXRkE/S7Od5cqKFOm2LHlCmviW0RMqiRNMqG8lqkl
 h5wYmh0FZeE4Q3izCyoCCrFQNGzBvR4pPVIfCga7kiyOhjZp3IAqbv2Nx8voSn+gK3ZYYzoABHM
 0IQogmewBC/jl7iRub+9AcZCaayPpz1l/UeDSHyjnGAyTGORRXujT8hkANgYpzMPiPmA3N0q8ww
 47QMppjE12+c9PNZ02+7JbwdZjLjmTd2PgLaXgsdz+7T9JPB/drZVbG8pg0/Mp+4twummzTDTlC
 UaMWmMoZTS4XLUEJdxvTIs1ZElzdnggdjIYBfdA0=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE4OSBTYWx0ZWRfX7DIbTp8rDsfP
 vMR0GNYJJ/+Z/auOTbIYs5xGZf/S6dObK5m7SoFQ6f1DImMOmXJaethzy/afwepGVm0XPLSedxw
 qTKCOFK1E9R7ISIQueT5aqwXJy/IPBduZE9VkNqP9sz36Bxg+RO+
X-Proofpoint-ORIG-GUID: jBCF3wU_KXYplyjDPxYe3auYN9v9UBOa


Himanshu,

> In power_info/gear sysfs, currently it supports output only till gear
> 5. If operating mode is gear 6, it outputs "UNKNOWN". Add support for
> HS_GEAR6 string in sysfs output when operating mode is gear 6.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
