Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D36520C313;
	Fri, 25 Oct 2024 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729881514; cv=fail; b=YQTNqWcjOS5d+uWP491POg0dPzIY8lZqS0wX5Ko3RC/viBYbei4ANOpoIQRAXPOXEcMXLirJEpr1E8gpsvpOPEN/8NbACg/5L8ZWFNquiHMzRlsN5SYm3fSQSV6V3/Okq2/aUS4kVSdhbnGShJY41Gax1G/5JJFjaZcK3LhC43U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729881514; c=relaxed/simple;
	bh=U6MorkPeU7/8K5R3wyOH1rQcC6/SlRbkSn2ii9R4tnk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lcZbLdQaFtjEMfSEA4LtW3TQCwLjVPABiB3WFDQ6TaELGbI/rb0fCIAkhDIOMiqEC68zZGU52/pWcBH5j9bbBsgOv/DRuxWG1W3kOVA2/8ff4KcrsFcmrsA7hm+0ji4QtTqwhg0VmOmsNpubVrGmCVfVEdz6BypcXWAVoG0RC9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=imJDqAtD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kx1bCc7k; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="imJDqAtD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kx1bCc7k"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PG0YOG017102;
	Fri, 25 Oct 2024 18:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=4pnIiXGa572V68B95q
	B+CZw5Rjcs925smlBRK6zrWTQ=; b=imJDqAtD6Oh/B6te/mUcxxOIutujzBUe8z
	LgfKC3XJKMqMgL5NwcKnJZW8DduhSmfzHxiYVVvuf9QDnnXeUzi4oMeHJTmag6Kc
	2KzElWYDdMBqa/5uCZK3S/lzWO6fPIPP29w+q2MfoIrPbK5kb+/EBYUIKJVpdIDI
	K3aNsubvTzaSlB4rNSaW1Vw4DM49T0BkEAzDxpGT0/5d96KcP1b0K6WgB7Z5qtw6
	/iY4zoEc6mYvlmFP/ygCS5yrlfGGUi4m2jVir6lgW7YYcFoT+Kp5esjkQ2iYSuIy
	TXcd+WPPpqp8Hh4tVgPBl74PLs1wMWHBsC0FiO9ylD7Zn/vDnOgw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55engaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:38:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PHUkEn039313;
	Fri, 25 Oct 2024 18:38:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emh63kfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 18:38:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rPPwN6FIFiVPjx1VhH/m6dk4mDqI4ZEFlbaUbGMKt9d5C/VsIiEEjYbCfVyopA9JCxnKZU/0Fjsp3kwDQcwNdfP/8ohhiLRjcmcgMZpK4A/zus6bpEv5GMo0qP4iubUyWnGj1X3Vln691qUEENKKz3s1x4R4P0HEFbPCj66g/qB9KWCTxwY9PozL4XARa5Bpj9cm7Jd192hQRWYcxPjdMe/AfAQQjwD+U3qkS3uxCy0gs7o1ASSI9f0vHbxAtzn7ezcJedLl+V6EDWzF37Jorbo7Q8jyIvAs6d7PqYx0cIRlPoLmWilh+Cy8H/CtQnfCBWiST072qeJW31DIDSDOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pnIiXGa572V68B95qB+CZw5Rjcs925smlBRK6zrWTQ=;
 b=hGt1LDfFnd0+JF4AmIEBWMN1bPTn+f7HXKghOuw/tMzWnm3DoJ0KjC/Phxfs0LLRH50pjrvFFfdcR9dWN+GGZAzlvDnqxtYIuuQ+m2VfArpUAdPuEeA/nPJHxuQca1a0ZOYn0IJ1oL0WFHeYPXPpw19LHvcPL6UjUB1RSu56X+YJCb5jsMYUwNGwIBMb42RJ5DEeW2m/y2Rq6QPUg+kKT/Q81X7y5ZgsxB9k5tCPYqIoa1t6md8KuwNRdAvuG6OO6S+fpU0f6pTLA7CTnYAzdwDGOOEQnlgHIRHrv+DWLdGQKK9gH2M+UzkuyjUAirM5LHmvy4MAJyfR5p1gQxWJgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pnIiXGa572V68B95qB+CZw5Rjcs925smlBRK6zrWTQ=;
 b=kx1bCc7kdYfREK/azRSfG/SHGf5yu5U5mJrjAPufErqkxtO1YwtkHF2My8XRpDjzjTTYf8EbX6R+p6FDtXhBQW609HfWY+6YeB3W9zg3iwNE+PGY4Y25j5i3rGtL48hJjKXH2N8MEhrMMzBgbtp74S6gNLccnD+fnQkwMK5TrTU=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by DM4PR10MB6184.namprd10.prod.outlook.com (2603:10b6:8:8c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20; Fri, 25 Oct
 2024 18:37:56 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8069.018; Fri, 25 Oct 2024
 18:37:54 +0000
To: SEO HOYOUNG <hy50.seo@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
        quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
        grant.jung@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: check asymmetric connected lanes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <e82b4b65b5f6501a687c624dd06e5c362e160f32.1728544727.git.hy50.seo@samsung.com>
	(SEO HOYOUNG's message of "Thu, 10 Oct 2024 16:52:28 +0900")
Organization: Oracle Corporation
Message-ID: <yq1r084f2q1.fsf@ca-mkp.ca.oracle.com>
References: <cover.1728544727.git.hy50.seo@samsung.com>
	<CGME20241010074229epcas2p31ecc33731a96be7958cdd93908a1ce86@epcas2p3.samsung.com>
	<e82b4b65b5f6501a687c624dd06e5c362e160f32.1728544727.git.hy50.seo@samsung.com>
Date: Fri, 25 Oct 2024 14:37:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::11) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|DM4PR10MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb70127-0fa4-4c3f-5085-08dcf52423bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NzsmeW7m9lTv+T5cD1NX2aGtMsFb5HG9i0lcz2itMRTyICV1/leSgCmHQPXz?=
 =?us-ascii?Q?mSr4oYUrwmcUslcDqR0U6NoObwkAHmD80jA3HpmwP7Iz8aeCUKx3XZpImQy/?=
 =?us-ascii?Q?ZXSbsiJ1xTIMC9eVQJeaouppFc6A8FhfetRvyWmfsVCFwOXSZJK3qmcu1c6t?=
 =?us-ascii?Q?uqq64Wc8CVeFEQN3k0clfL5BGj7qzoSZaAcx8XJnaZseBmtiCyGeZ3yuzbx3?=
 =?us-ascii?Q?DNYTl/ckMJyzveGkk0wIgGhkFKzqQjXuR5A4NhrQRA2pcvOWzwh9jG08xKj/?=
 =?us-ascii?Q?/XtD7e2JttzOMo2zHXWNR+fYds0DFu/5XkzeUXdx0H7utaNIsALslTtK4JK6?=
 =?us-ascii?Q?cVC38u35XnVeExVh0Bel5JOqijQF+z/LJDOgA187ZB8rR6UuO2pXryDLyG8i?=
 =?us-ascii?Q?2Ke1WmtkhJRQZoug5NILWUIPX/DSGYetJefNfknxbchNpyMdyIF3ABfVTU0b?=
 =?us-ascii?Q?BjX4vlzbzIse+HmS3PBcL5hATidC2ctTfoWqQGg4ljL3gAV7Mhs+jRjr7wpv?=
 =?us-ascii?Q?UfdLHOQc2kyFjFiIvAH5zJmzvsWaxNOQmnfq0+8DjSR6X+6EpWlFNrjkMuUK?=
 =?us-ascii?Q?eokqI9LqXDmSxHXTRjWuFUQHs+cDh9m+fdt82SE43XP1de1CuTtQSeao2vl7?=
 =?us-ascii?Q?45a3G77usiJGI2MAaEHFixiLL+xjzJ/2oUwo9RLwGdgVprgNYD056GvZN8Ww?=
 =?us-ascii?Q?VKCF1KYdtdFO4jjWfsmMUP4I0ksX3KUMM3L0vBHX6x5vgpp0Dkm1stDR5Fap?=
 =?us-ascii?Q?jgDpiyBpzDeSWLumgLSMkYsAZxhbkdje34WD7rgORprd+WAE9mCy8IT3aV0f?=
 =?us-ascii?Q?awP0vDXioFfb7Hephs79sQWpL8sWB94z9O0dyxqQSea2crQFutg3MJ0UAdEp?=
 =?us-ascii?Q?BTif3hkRk7i/MlMBHNs02vcUNYS1fqUpkUkKYDvr4vTyMNtKYlrtlioTVRMY?=
 =?us-ascii?Q?2WiBbPEeCFAeQGs8BnyaB2QiCL+Rs4EIyWUP0W36jZgwAb7+uhNN6gUnoVw7?=
 =?us-ascii?Q?9EnJ97P/ogvgo3QVAkYVF7PsBxYATvqCfzFjHrpPiLlC1OaHVX5u7CVy4OqZ?=
 =?us-ascii?Q?m9AgFy4iGqZe1wV04wJ52gjMNnVcRYE7Q2ocPVZAuMcYXzRB+OdOuN1XREIr?=
 =?us-ascii?Q?sbZHR8ZjB39W5QdcVh+EbzakjDmprblg7+V/gnaAoPuuHwJ0th5j3lKB7viB?=
 =?us-ascii?Q?LIlcfNgAxcBlWdSgq8BoGqJbBuMtkuafhAHrWf9X/vSnoB14Cx21Dt0oAcMZ?=
 =?us-ascii?Q?TzjRoeNDBK2EJxZjbwe676BH/iEISxbXrAxAq0BMtt8Vzci4AUsIMyytcaYr?=
 =?us-ascii?Q?VwM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2NBEZyv2wAUqQSpIQhHi3EG7uFhWde1FjnRxUzAB+6//3SIzh/4d1nugUIQH?=
 =?us-ascii?Q?thKaT3id8r2twNDNnnbM8inJgbfqnoRYsy9DNHh4Jc40UkDmX9unXnpzrTJF?=
 =?us-ascii?Q?A6O4+UNH8PC+alCReB2AQgWo55KJxMt6ubyfnujGZ/EZmx2lv7CKlxuybLPg?=
 =?us-ascii?Q?+QVpygmqn1WH264jEyBynDnZ4EOUf6g5pY1bRpWQUQMgWuB/Ns/KP3gXMreo?=
 =?us-ascii?Q?J1Tb1iaNA20hZ2pkVgfW+XhXVaZq8jrqeHMEy1fiA+C51oy6QkeqojhdokVB?=
 =?us-ascii?Q?HqFbd/01xlBE2h95BZreq04tBwpLqNcPSX4DV6qaCjtF+RQZtIblLVbAFPzo?=
 =?us-ascii?Q?bPNfV9+GeTgp6Ldupu0IavPsvgG59L9lXqxhDvhYB4tf9fMf+FBvv+0t39Vg?=
 =?us-ascii?Q?Q8fcpO6mWGiSMmhkXnm5TPkMITrvtEid9J9j2EQpHki6arotq/hGgbP8t/Gs?=
 =?us-ascii?Q?AfDsDUCcEBgywBc5LlX7yhmNRFTIo4cQJWwY2bElcXP2H9dsJoRhKzVfUQKe?=
 =?us-ascii?Q?gdO9KdqztDZ0ouA4pMZxRucXjsEjNLQFyKYX3DValv8X3kpdVkKnqTXtffAp?=
 =?us-ascii?Q?JAtQAb4ab0pFR7p2siW7VJTEe256ekOUi7U5w5+PMustyC3VLE1BbQNuKVmX?=
 =?us-ascii?Q?OwgnLds0aCbB1ZlDP1mUs7iQ+joukC0qSefXjooIi8ut/n/QTdfC7SCXggwo?=
 =?us-ascii?Q?1yKvBJenN3F7V0ehwKxZXH6QgggfXPc66mbCAtpU9kt3XuLSdnGotd6iw3KU?=
 =?us-ascii?Q?5Kfx741A3BhFjqSafMY8YBX48xC1aBeyFTp/A14DiPhE9T1V7dIbJ46k82ce?=
 =?us-ascii?Q?zizv57kSXmB8mmBh+naS1E9riX0SrZsP+pFAIuOmOnGBDetx4nagwqLOUNw2?=
 =?us-ascii?Q?wqzC/ES8nTF+zHWU2MkWd0aLnYoMggof/gkws5ekDQ1iuqyQ0ZnmYd6i/cIw?=
 =?us-ascii?Q?adJtk1MjziuTVe42pbKO4+1RA6WhZm7heBGIXFmE0b6pbEaR6NNXfiyjial/?=
 =?us-ascii?Q?pR277ytSwphbcWQhbBfTNwgSISWw7k2wYrzKciH2kV5G4lDZydwX50z/BA1+?=
 =?us-ascii?Q?zlkVJfKBC2+5CKVMHOuoeXyizt6rslST37vl849gDjABocIqzWcoEb9QhZSa?=
 =?us-ascii?Q?zgkUBJbYqWxfQOAiJz5DW0uCvpYkp6v+cZAG1W001TrxF3WaNNsinhEGOYHX?=
 =?us-ascii?Q?hxMIaruIZUeg7tHm2g1ERYsVIpyeSyauz0gDUObAbfPPl73Z0dcFsWqPgGbx?=
 =?us-ascii?Q?Y9vg+n1Ah37CkQjmiLxfFcswglEQ0m+YNOujxuwIHSeoMIm6pZxGzkfpwcQT?=
 =?us-ascii?Q?GXp/WMb4dyFDROhnRpN4V+4URwm+osJgojvSJjK9uq03rKAGBuyK6pVtgD3g?=
 =?us-ascii?Q?BGMDiGnLAH3q3KqvqVWb8R2K4clZGREyHFeyYdPpDk6gUSCSPSUtLPn4SzID?=
 =?us-ascii?Q?g5z45H0O/qeDLVLTID0+pXvOcMk0Kdl2OPjp/HiSUiVGLkSob1g3RGct8old?=
 =?us-ascii?Q?K75GDFv5FkeMOnul65/h1LdjxPsoE9KcNETsUDPxzajfSjQJWnNuTL19XVmx?=
 =?us-ascii?Q?O6O0ruOFAkruaxPFg3qzt2sIvAHd4eSHdXiBZ0WiZ+Plt2Q0amjrJXO4bD29?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sCRBauSIpCnWSG01a7AJiuqf85p41t7SgXfHcsVH4ZybZhVjAvCDhVkb/ffoINuNv1LrXYVt+vs4MMYG9fbhWhZM75vrsmGDQVBHx/X+DgsD/CtMyI1huQfSizD8NJDTNuI4/0VMf+fkcqAtXKqxAtbQD7x2Aq0qXMPOYIkisDJ3Wl3G+jMSY844AIgvC/nzU00uTovRP3H6I6usKXSJLM0fU9ZUmJhXxRRDB+fp8UdlSvVr5MxTH9fSJ4HUkdVFo/iMqITuWNbHkPJ3SBjElogord2ZRYtHFDMcd5sW1JRAWsamUGn5n8ZhmFGiEmT+XwAei4t/9TJ06k0333HKQvESv1k6kOoC6NmGMebIcgYnZs+CO4mjlc0olvFanv2BasCmsU6dfePZg7BChent21vs3W0XRIC7s/KDIVtnz2niV9A3WnCBwg7hDkMV9I7+PEIj4LR6eB4MFY43EkQjxgnbIkpmJN21byTV01BSwnRokx4WKsofeddYd51gaIxncEe1cjEs8tT7ob9f4sSG/Rsgf3X1HQhJtVdmOQ60rci3sxPW2o/DWnE+r93h3aGhfxoF83R7o3yDNY35PX40irZNhjTsQ6ryXCIav1v6m7w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb70127-0fa4-4c3f-5085-08dcf52423bb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 18:37:54.8176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RuIvV5EHteLBWbYjiQfDLaA674qzmBclqaV5BEKlvFhUIiEjaD0BTAQtppP4GxcPrYp4wSctPW26KDNLxb9m6NybIpf2QsV9yoWe0uSfGgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410250142
X-Proofpoint-ORIG-GUID: 8EbPtNZVmiLiJsVlYcV3f9301A7dmJti
X-Proofpoint-GUID: 8EbPtNZVmiLiJsVlYcV3f9301A7dmJti


> Performance problems may occur if there is a problem with the
> asymmetric connected lane such as h/w failure. Currently, only check
> connected lane for rx/tx is checked if it is not 0. But it should also
> be checked if it is asymmetrically connected.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
