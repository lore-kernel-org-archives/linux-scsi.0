Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3EC449985;
	Sun, 12 Jul 2026 19:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783885812; cv=fail; b=KCHHJdMBeedCf+p1C70E/PA+boC5FHnKtvZ/s4MJVpZjrTx1ybLQ+e0sG23jNlA+0HWssom5JP2RjdYhGZzQUxfEkyu8BSikXN7g4+4dXjp8LS77SVYEmpCAF0p5krYrb24/YGfBQI5ymtezQ69kV+HpHQjzh35SBlgRDVDlIgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783885812; c=relaxed/simple;
	bh=GLufgdPoDL8zG7IBYJ1VkI/1craf6kG42u7UEeXgsBo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=jn1t4XHrOxwHxHPGXw0Y6LfgLfupq2vq3UfYxH0XbmrqWgG+s9HMgcva81q/1fUtoKcf0X+z1IZuuuDcGyhuHpQfuujt2Cq3QG66X27ewPW/c2gzzbcv0FsaiqwJT8Pic+lcBvWxjhXNd7kJRHqVhNZWsYwTQ8i6VMz6c9cCqBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BfQne1Dw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=J50/6DHU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BfQne1Dw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="J50/6DHU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CJnmHf3918911;
	Sun, 12 Jul 2026 19:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HzcuGH4eR5kuIRwJSS
	EtdWYjtuvMtVx6fiFZoCx0aEc=; b=BfQne1DwgbUWZayJpYnEb9Q13JKN07abhw
	zm2Mkx6nUQ+r6EIqODN5erqNaSGsUUcsiUkdnYBbAH0+PvuHQP3cRg3FXfH2eMhU
	CINzYRt4tzhmNyWI0VGQ/1tjjp8z+6RqX9uzhvzaqFvJ9pTS4g/CL6uXYqA3sRGu
	GGspImU5dkCGSlpE3yGisAud3ljtXR3UONrESvOEcEHo0qPMRZSildknPd3ma/SR
	y9BZ1EkQQ0BdV/zt9qhwTLEfelPwmnbVk2uFyjD3obnum8az8XPnSaHs4GyzYPJc
	o/wkmDAbVi7F+fs3aBKAgQKQYa+jBtwbUOQTa9+XrZPtngI4AV0w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedh6ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 19:49:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CJmFEV005293;
	Sun, 12 Jul 2026 19:49:53 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010066.outbound.protection.outlook.com [52.101.201.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9bxx24-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 19:49:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKLkRBd4eBW/X4xjgrBEI/LmdY4iPwW1MHv9YcCT7YMTgh2NC7UhpMcB8PyLlLLPmIlWkfw7iOs6XxsnPx5E95vCXfR5WZhRbC/8nf++CO4hHdCK/pi6F7CHoc5fYxCKT4zwgg4GA6Qee5kG/VpD9yFihUfOigeunll7crN+zpVgGbhe3Dc7t1vE63YZWzonfTt3Rg/yfovdqLvCNgtWQ+vRbRfer1rdmCJUwlvkbROf7+0vtvDKlATltqEqVV8QbqREfH1n+1JNaeo2P33byNUNDbE5m1cd1DcSNuZw4G3WFOqLeQvOIQjLHhR6dVU+7qYtooAN8SWLoUgRIXR1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzcuGH4eR5kuIRwJSSEtdWYjtuvMtVx6fiFZoCx0aEc=;
 b=FMZERg/n/ZNZr8cPDMERfe3ons15LrGBh4jHnt9rpsObLxWtXEmUthmBf0qvFgqomoLI7Ms8z8RdNAiGDsaSrinlVPosFXih2oYtQeLAelp3a4bMY4DQ4Wb1R/VdIYeJQ49oD3Pnd1RHg+B4J3Mld7WnNwncoUnlCPS9wxMq+dhzZ+X+vSdOnS/NyHQ+7VlbuPV7OQYSMZapF6qWik6UghZTl1PDiDToKDOS6cMIEGsG3H6aJsjIrEsCL2kiBAdtC84atOFBrufBWjNdwILVpFjs7cyidPlSLYxEAjzUdguvcqlHFCpQMjFh+8sLQdC4dT/KywA8tn2ym6GA36YpWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzcuGH4eR5kuIRwJSSEtdWYjtuvMtVx6fiFZoCx0aEc=;
 b=J50/6DHUhiLJV2psTrqEYoD7u3UwSurP4jg+CeCtBlxAePbT7dRYsowYwECSGT2XirSWy0mHPOw9k8yYOEOdEOBEVAOgP5+F79hRx2Pnk1TzKY91isOvVPDnp4HzHiqtb6iIr3Vyu6SVfCwB6Uqq2RrYfCJcM6by8fjTbOYpKk4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY8PR10MB6730.namprd10.prod.outlook.com (2603:10b6:930:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Sun, 12 Jul
 2026 19:49:50 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 19:49:50 +0000
To: Louis Sautier <sautier.louis@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar
 <ranjan.kumar@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Damien Le
 Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v5 0/2] scsi: mpt3sas: add hwmon support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260630224922.2543096-1-sautier.louis@gmail.com> (Louis
	Sautier's message of "Wed, 1 Jul 2026 00:49:20 +0200")
Message-ID: <yq17bn0dm59.fsf@ca-mkp.ca.oracle.com>
References: <20260630224922.2543096-1-sautier.louis@gmail.com>
Date: Sun, 12 Jul 2026 15:49:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0158.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY8PR10MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: c47950f7-c6a6-469e-7360-08dee04ebc15
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
 /3JV6RAhf+jssJ/f2f4Kxle3Ph8Hi7FBbNixE9sDB3DpzqlzJ5SZQzIIoBSHpezX/o6PV0Nt0wJ0aMbd1AjqIRo2ppiZRBFn2unoVW44vyK/FmAo318K4meqfW0/3c1H+wIpnZzN1aeZUy2NrGNID/hXwA1sVRCjAVaQyGll+V34S7Lt8/Y6VdDmdE33kKycLhL67Xk9bzT8l8o3TIenkmRSKl66dNeMcstBMDWjj6uehZRgKC7QlfRDCWAJ5UmsFTVwrA4r9HxOfl+BlcF0X6rvhwAStVmLVS8LpN3y5iM2oKUydzl2eKnk224I6PFhcu5FykCWuQjRLFKLbPr5DB+W1j+BxELlnj8tg/hMWvEM4sqtOECVHUNadGr+ScqZkSVyPZQrkQCEHPnIwD8vthJsQk1fVvyawPRZd2fb3XCOmiAzOL/xa3aaz/cBuaa/XBXQ49/Wim/vxu9ZSUJKNOe2K21ezjwbTvJwegUi77yt3hKqmUhu7ay2BDZGQYB5uQTwjqc61N/mOik8UjHj3l/Fk2ckvHYdEq7+bdU/BlNYS6EhW3Qv2KyA2ImPLnoqKB4WsC3G2jfFnLCwldqVwbNKFsyYWFiL/kUuv4VSwcm/XsQUfLNaIwh9ub+37AIAjkBVtuenUsV9a0veRomX8O8+WpkvfkV3jrh0lLdVDko=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?n/e2CPK5ZHaTJ4fb9p01I4eAwek2JdZrHlba4IgicoA1VRqQqmDQeA4Ie+VB?=
 =?us-ascii?Q?dbMJhVTkXuMsCeDRBspCjBo7uKmKTyIlc3txEioqfTh+qunTA+Vaw/tJmql1?=
 =?us-ascii?Q?/14/QdzHC65k4HnPfMsKpi1EADojYlJwtGSIPtsFV666TOHzRSI3dolEKF87?=
 =?us-ascii?Q?EKQCyXxhcJdi/AkiV8GKPsNpDxJP9aMRbAPFrGk8YuamaEm7y989K51/nKmG?=
 =?us-ascii?Q?5GWbDKYtMUUYfSAuNku4sO1cy43XwR6LSC0ZUfdxTDsHajTtRrdkyD0pfdf5?=
 =?us-ascii?Q?0h0EjyHCl/5dnJdEWdRkh5OVBMH1Fmgmwp6btO7qYw/dW/n3PpKrop3ptHC2?=
 =?us-ascii?Q?2Vt1KOvozNVR4sOhdcGnVLsmiocSuuU0BUU0QSc/nw6juOo5OqV1cXBDWGJH?=
 =?us-ascii?Q?nYPUYGd55YJYCcxlYN8L7NVvbbKSiYN31ry2cx2MZU0zY39ewKAAx8kL8OaF?=
 =?us-ascii?Q?qHb/5HWBRG5iFCOKtBaaVv+SEzdDgyh3QyWcC7xhHMYohr3Rp/XqYUvBfSUl?=
 =?us-ascii?Q?YIeczSC6+blJUmU6JtTBsrmMGl0wuFoH0WToAlz5vSxiRiDnCsi4ZsIfRxxK?=
 =?us-ascii?Q?stmh/ot1/19NzjTFAdHCOqcA7qKaRO/Rieq8ZskZEfPcDgiGjoEdgLUJ2+sX?=
 =?us-ascii?Q?aJNFl0dbVu6wqvVC9zfy39gTu2OEjJWfRmyuwY3HQZV348dX+biKukxzL+WE?=
 =?us-ascii?Q?/ENEfJmhgh/o93Ju5VQ8rzAqxzbMQ1ZBTohTxHyAMqO1YrX3S9m0zvt2/T9i?=
 =?us-ascii?Q?KIdB1jvmFqqpOw6/Wmj7ZuLuN4M8HOxTxfhjGALPyfvWUDDy0WlZh4eMmYtt?=
 =?us-ascii?Q?5FXkpjSBXdAHDXGhA9uw51DbNmj48lmTViabHXgfA+XWKoxjWvvAD8dy8VE3?=
 =?us-ascii?Q?24KAGCecxNyamcTomrR2FWrSA5/6yrGVdw2WgNqEmqPoP1vLZE+uXcXtuKec?=
 =?us-ascii?Q?yDRIF9ORDO2BoRB5An7+eHLA3YyqeS0U/oENtXX5/VuwXpO5Ref8K9DsHpIk?=
 =?us-ascii?Q?qAqgzgAVNC3vR52Qt/BG6hG4Wi1lUcqDo7Yu2iaH1vyYLkzR6iLJiIZpFjeT?=
 =?us-ascii?Q?8KoQqgE4A9AfDUHTRkI5ryjJ9+hEK6iChAritxj5G3g6+ReHqEcgPsGHp3AD?=
 =?us-ascii?Q?3cbYWji+uRYP6wdk/RPb9wXD3jhCB3F+XwYupLNhrlVi/cI1y+EYX4WwrdCe?=
 =?us-ascii?Q?Uszd6CRaTJN1xzxg+LxNg6nOn5i+MmkBZCk+229h95A81y7Lu6nOkHdP3kEN?=
 =?us-ascii?Q?0ynzkbRFD/R1QMciOv4HyKRoc1L/V1Dj7VJ3WQFkeL9Od+U+oVriM0UAL19A?=
 =?us-ascii?Q?NdKIsOCIIkLufxSyng1/ErnW/RVTzURLSjO0iTMDdLqix/dAUG7WkQj0d0HP?=
 =?us-ascii?Q?Cq6+HpQ2Kfw2JwG7YJ9DFYYWdVGLej4U0j/jRiVt2yxNPESrPBR1Qtc6gbhY?=
 =?us-ascii?Q?Xzhe/0AbG9QjtPjyXgs7GHhQNh/BUlmuD9YsYn8URm02funmEjv7NPIY/v9X?=
 =?us-ascii?Q?WJgSA9gu6TYole0IbQZDwVVOedwXYSiFAAU3BjMzaANBnwDME0gfXlFptp2s?=
 =?us-ascii?Q?vt9+vT2x+WpI0a96j2po9OoG/om7PMW0NVAd+aMGA+UAfiaYgkgA9rztDufq?=
 =?us-ascii?Q?CO/Bz/Qb8EdqRBKF1aK3gh01PQety5h0eJa7/dX1lnPDEhggQL1RHEYeJhsm?=
 =?us-ascii?Q?74ZcJ1j8SVqUYtQBafSEKBPWfhXnUwLHZuvxrYKDsEFQgnGk6I6xPWazOPfV?=
 =?us-ascii?Q?93NFkDjfe3+luj3CK1fwIA6escvE2O8=3D?=
X-Exchange-RoutingPolicyChecked:
	PM9YCq4a3CoqlIwsBLPHC35u2GQVKTOWVYlLeZB3vOtXwKyg75Ag0p+g/V1X9e4OWurC5WWc6OR+YgGtkX58HrbEeC/yoxFJ/1qEJIR32yWldMMmbchtMND1ThDsx7Y44jqHJAoHXGGjexecOFo/0c5RaV4XIyrcByBrNBAeOk+vXzx6YKLOnorD26/hBeeWM5N9iMZRQhVzO7CeZBiaSCsBR7rygQ18y/YEsENjSLunIXKTYf2V9zgBfIBwnHjdk9t47oHx4sagL0UfEuEIWym8PEDWAJl0h4txSmYlCwvthGhSwfUhHVMfVHoiB7U7Vdj/9UDEp3Q4t/1pLczrdg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PIeklrI6Q9u4qy1/U/SWAHQOEgnlXX3cwgXihCuNCXktNd2uGYTJ1vswRjMowt1nqu7UzHcpiDbSbU6web/oizs7TN0isw1EXXgtY1SxeEWcoX+z5aDxmmoJ2pMkqyk5FVGzov+m43f/+RpMF1aS51FdZZ3vWj3TVmRCde5QwD7zx6Vmw6vuGrbMjR7yTNUCYF+rwRVcTcEvnqcO8BxiGAnngNffI83p5lVT46pNPfZY/ygSpP+IfQ0IUINvzcE7UMXifrYb2QOPb/FaSjapI5cQTfR3mTfdTohYmiZjmwPggSFoMg8btrFh9zYny+gc2+S/rwVpPvj4FIGIJRmaPwCwqi9fTo8lDqZS2kwtp7hiy2Bq1uMlSFJ00X4lNRyiST++EhaHZjJjEAsrZo4bO4rYYXl21ttEZzlW87+3j0KjK01Igfp8RxZNkV7sGT4wBNOpVr52VeTnV+rN0SmUt9+/0o+1uMRbJAhXs58gVF2zt7kg3PinIb8hUQGAqCA3lg/d79bnQVuurfhylgbUtwgXpG+Lf5P0JKg+ieKK1/FUXIkJ3aVCLFAg5gwF6SZkKqunU4kyZJR1bt16P9LR9ukVaqgo51seP8IszxJr+bo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c47950f7-c6a6-469e-7360-08dee04ebc15
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 19:49:50.1867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7AgSfS8vW5xiCLIvqrMIzLM33OeMRYEhmkPBNXF2KhbwGg+A3PGJwaQ/vNBleCHHVkny7YiZvSMZV8VqF5XlW5V8EfXTt8OQBaRzuc34/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=797 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120213
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a53efe2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=vb240fWl8jhAZny2-AwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDIxMyBTYWx0ZWRfX7nYz3JHgNC2c
 fdodAfEE8VP+lYDAhbMlyKp5CLTRxfpdgpOPH6xow/YBJ6awS+tRVJZMcsTat7jr6xHzCPAoldX
 jdeg4qRXWNL/trMASC5ExR/9zNZiDuyoJOm96NsSRRaXDeopAF2LtGPBFmoXoaGK6ANyDJEbJj8
 FsvlvA6arrEKPzPbWlCMMrL0eEVEWEwhyk69Ir3CjzCN8pxMKqHiZV1BXcsxE6Osb6r+7XVNm7W
 3KFFmQq8nHDbin8pZS1uQuuvNSngDM4UIGfFI61yahlQq+fsEzFxuDigFOX9rbIe+NHT0a9mo4w
 wKIdsXd5MMunOT865zCYBAgRtwnIEYfD18Pxh6ycHvn9MswGwAP09Ggx/WxXKmEfnTfO1LEab6d
 3O/JWmpqL0pRf54MZ6tb1MRAttt+rcc+HEz97Tegqgs72ozg5DVWRXrBWXszokbV3F4DlhU2cYW
 AFHIRCuaOVuNP6bQf0A==
X-Proofpoint-GUID: IfP55LZZVEs0gWZD1etlV2bQdDO6VGTk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDIxMyBTYWx0ZWRfX5tLr2X2QNQWC
 i0UtVvPpWtYi2l3e9M8HcQwqGaFYwODk2PWA/8FOIUFj0Pl+RIQX+gzSIygBRVgSb0kazondE0d
 kguILSt3oez4VxI+OWd/o9DqXzFYco5YN1WHnMUAArJ5rXSPiF30
X-Proofpoint-ORIG-GUID: IfP55LZZVEs0gWZD1etlV2bQdDO6VGTk


Louis,

> Expose the IOC and board temperature sensors of LSI / Broadcom / Avago
> SAS HBAs that bind to mpt3sas through the hwmon interface. The data
> lives in MPI IO Unit Page 7.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
