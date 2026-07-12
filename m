Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63C624113D;
	Sun, 12 Jul 2026 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879905; cv=fail; b=gdqg+B4ufcaQUsmdMNJUcm4DINxCYimtlTEeRqx789zpu3uXm8i0Jznp1bx/t7FpmWCSZ6g/8AYo6oohOGLi4ZdlCVYU0B1E8eAmAMcMXKVNnUbhdOf3/LCLl7eKzCElniwgoMy2eUla26ByeC7cxjeyLsMCzP9H/r7R9f/WZxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879905; c=relaxed/simple;
	bh=wtFuBIO50UGcRVJ8yyJ+nv5GAOTiVbkE1jit9OoyB9k=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uVWQ8uF8c3VVSkTtD9c03ks8TNXeoTt7NWVtf9qXC5muZLpE2lbIsHQX4dGFtbc1MXfxDhJJJ5lKG/EeyxFsRJhkTSY7/19kdqp37oOg47TRhTh3K3eBsz+PX2oUKNNghHh5hrdrenqdiqRrfx7kDjUDVFZ9+xgQAjDSpD7u46M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gk0m0iIN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BZNHb6I6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gk0m0iIN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BZNHb6I6"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CIAHxP3757139;
	Sun, 12 Jul 2026 18:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oWZw0rn64cz2JOdZMl
	X08jmRTQAjJRHR/OxF/xJLFno=; b=Gk0m0iINWedHiXlTn9swBoFDu10LqFqTZn
	ljQKkToY13D+hxtps1nap+rZs6+mah5CMmXO2ypJQ8yyb/q2o+EQCzedOpFxtaXk
	17q8Gde37C7Pjzw1DoMONMaBAOsGRxQ14OZeKQymvExoUeaKyIRG9+Bo2heNZoun
	5nXKtWW9EahyOVA3W2voSLAzKBDI7+eLYJ8gCCmDQOPmXrom/C+cFHkCZR6906fN
	MNt32a0jxtXGsJSHANwkF989LjlntKlS3xfqXnFxHxquqU7EjLm8p7hHSnHkVH56
	4qSgGYL6fiMcJBjLh+5Cf/vydxyboLZfhPGGSZUa6uQRt0vM4Uhw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed294w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:11:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CI8IYv018472;
	Sun, 12 Jul 2026 18:11:30 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9cc2gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 18:11:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPDG6ex2C1S/o6QVLvNsmLj2aS7URT+eUL1wiQmS7Mu4WVUZpTgSNsNi0a2bqB1nKqLoyfgq5qbs3wNdWy5F4bh5Jw/ww8IwF8ZbrGaR4oG2xufse36o+X/xJYQrrHCqGHo5AaipoKH9bSu7YME6FNP8wkBmxy2RxkPG0koXH3BLmgWuq6lJEojEI5ktw9+sNgyhWmeC1Dg2D1Zb1SWwDNUGieNgC/jISRfo1o/u3Vc7EGhouH/rawQOVKWKoWeevJQ8VhmrOGpVVsKNY5K8CM/71NGJpY0dlOZyFOUVJ2p7CBpig871P0d/Xg7qCxu0X5wLwG8DguNPl+dlhpFFkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWZw0rn64cz2JOdZMlX08jmRTQAjJRHR/OxF/xJLFno=;
 b=Kw7EJDM8c5OOaRcIV+IgHndud+5BEF1/PsI3Tta6KjGYr191w/J3SdA/ZQNQ05/cANENs8R23yzIDgyNXlfdZNUOhQeK+iHwsZ7OzfR3nWK9wKQudZbOzO1lzTYG68tGPiqbi2og6Qi2/s3LdU1nE1B01ah8OwUgbdNP7fChMTbGDGu0gui/0/RzN6nzD+/uwoujWuZzsbTB+Crjt7FSKOhXvSMsa0ls0kXDU94M34vLWlWvIC5Z7twsrK+vNCJbS1csoUYvxq4xPOr/j/W/dvW/Kx9ipyBEMcy9rkcaJ2GRYYZjmfXd+xI7QvhCj6NZlo18EyE5Jx9wX0s8TPFjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWZw0rn64cz2JOdZMlX08jmRTQAjJRHR/OxF/xJLFno=;
 b=BZNHb6I6/xzxlr8FVkypwJDu94ie5lhWnAtxM0hhFSEKc3WK3I1HD8CtNVxMZjQIDIHSkgfUwyXCDbxy6NQXknox9OVNBdhUNwJWg/zD0XP80+B89gPL8jVyfZXNwHIXxVyHcrBRtMqVIY0f5jiJe2Vf5MyTEgGGe8MK5NE+KTs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF1D755039F.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::790) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 18:11:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 18:11:26 +0000
To: <ed.tsai@mediatek.com>
Cc: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        Matthias
 Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
        <naomi.chu@mediatek.com>, <chun-hung.wu@mediatek.com>
Subject: Re: [PATCH v3 0/3] ufs: Add callback for vendor-specific RTT
 capability
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260615055802.105479-1-ed.tsai@mediatek.com> (ed tsai's message
	of "Mon, 15 Jun 2026 13:57:14 +0800")
Message-ID: <yq1o6gcdqob.fsf@ca-mkp.ca.oracle.com>
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
Date: Sun, 12 Jul 2026 14:11:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0340.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF1D755039F:EE_
X-MS-Office365-Filtering-Correlation-Id: 81501a2d-fc24-4de3-1be4-08dee040fce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kb88T0MV+b3DctTIGVS21khZ3gH/Sf5vbTRSWE4QPVsa1y/d0VboHDbvTVjrVALczVyTOqvKmN6lOXKelx380BujH9kE0BDnQn+KHq2AJickXSLj5hm1t0ps8VwBuEX06saFEKS4uTekVKJx7LsPGRqJxUd87bYgJkFJZ2TYw3OL9/SfedJrIBtlGOIZ10xdHTtC6a70kHE9AD4tuGW8J2LBgrmPdmLEh6HXIp3YC7eGemGQU7FAUHgxREdkAMlkpf6mE+U9aOnrdYwE99Qgk2gOB5CQATGYj28puPtyfny1PdBVr7bjxBeS6U4BBWhqZPVGxPwJyINxXQgPLgbXVZfwoeY//F0EnzqjZwBgwcG6xAKZBOZZNPdcih4WwRimCFMbht/uk5xmxGmXma/OAkXuk5Ii8+WaNMlwKIXwEGsWezp9XA26kSj+SVTdH0Duj2zQtEjCN0J0rgqtMds1PhLqUJc1zXrpKJVpTXiG7uCvO326/vRS/L3gP2C2+JH5KtDa5Luq3nuNAHvg60DQVVl+1vqNOm/uGWB2BnuYmhn7yYJ/scFJtspeNqUQ3/pWrdjIr1QX0pHu0ZfUcnLwTe372WyvcdPDiB3CKC2GNXk1TZg/eDW1+9rw6KoRTTVBayStDa33F5SbGhJMmaoHo/b9nBszIEM/BbP60ZjjsjQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ThohJObHcssHzXKIPxeR4IXrRqyU2Uf6RZ3MWf8P4/+5TgFw8n5rsNvlaq9G?=
 =?us-ascii?Q?5r9VX3bO8Z3mrX5VEfH8awOrxMMc0mAt3jYm/ptjtnrpM+q03k17kFFaBFYw?=
 =?us-ascii?Q?NriLk2BvpIAgXNQ76A54ruzF8U3xN4duhPXBcGYbgk+kKapePayr7skP4+DK?=
 =?us-ascii?Q?p63OKPcbQIY5yUrVE/1Rtw8FM3vntd/9f871ltnPMyG8f2nq4FbEWcfEsRNj?=
 =?us-ascii?Q?9FCH9yQWjAfSuPdbSWYr8pyUMdL990DZinOqvoIhmh6/Z7iBYImAqa8HFzQU?=
 =?us-ascii?Q?Sg+NrgZtku2tNYLJGlo6h/PGnTQlv/NiZ6dAdJdcvKPJ2LRilrt0tslTV7eX?=
 =?us-ascii?Q?ipB2TEBJJTHne2HZn3Pdi4v9sSOQjfET1lvVEP5bZJrdg2ObOCLviV0aGCSm?=
 =?us-ascii?Q?jYxegLyst7xaEeCHmYPXPqSTyGr/+kPey9FpC8STo5BLC3jJQwb+s0GQdpZE?=
 =?us-ascii?Q?tae4ptw1TnZO9Xn2gYCN6xBweDm3ErIqZQZ3A3MFsva+edUwLC16GitVKGgq?=
 =?us-ascii?Q?QJ/OCSNdXKga+frWbHWbmgjj06tit4Qe2x1XeiabXLnwrJ0mGIBRLlRbuhbn?=
 =?us-ascii?Q?jQ58UGxsi5TquqXMJ8cJPIgpR3oAjHHeqYS2jD9DArYGmiE6S/l8WXxREc7i?=
 =?us-ascii?Q?MhOUyXfNQvfOF6Bng078HOE7Vpo9ULuWY0+kGfGTlePB5ifnHChsauOQdbg1?=
 =?us-ascii?Q?ytgcbzXoICxuo+HlIMaLCxQSXbtJpbNTVq8mkfL7TiGPv8gxT/br9x+v002v?=
 =?us-ascii?Q?swG1OENnOb5YJz+6axSohv6CNsZLNd/TjwHEBf4k8oihVu2eW95Ie783ELxI?=
 =?us-ascii?Q?4jfYvhdN1w6q172WbmtAD24xvwepgEYqNAuK90XkI/M/uGAImQWwiX2qr4U9?=
 =?us-ascii?Q?asPANuR5+9u9lDUA65lAvwEae2o36lkU/vH9YF8/ihhY8dOwkmPkiaqVF6wU?=
 =?us-ascii?Q?6+RrEiy0jfmeNn4urYOSTNAEN7du7ZGb1AgdkAmUHni2T5i81Ua5lAHF9RWz?=
 =?us-ascii?Q?t4EU4jlqV1CtRYTyIDygdpRI1X6DURrVNEWgKI5pazrmyQY6PSXskSzPidKg?=
 =?us-ascii?Q?aNSdhQLowx3eBRyXoQMk8c+mg7CPzk4NPF9naphUVd7v++5BTVKvJ1XFY+UY?=
 =?us-ascii?Q?vfl5gCso2X0OSZO5xnUra3UtoboIW1hYx2vemgc/w0/lw+nWk3Q6I0CCAgyK?=
 =?us-ascii?Q?8R/v7Sm9Z+e0Z/FfvSo0Jnn0+KViKU7FLjd3qCeL6dhfo+jsp46FdRy5YNcw?=
 =?us-ascii?Q?XJXvlbg69TbG0xKXqoq0N9Wdf7T2TDwDJtn98sYs9q3mbTI0uYmZyBx+Npy6?=
 =?us-ascii?Q?1qVT8K2HT7Hh6QB5MZi/kK8ubGzdh2QCojN2VacdXT8cqqS9eJESe3fzc3bh?=
 =?us-ascii?Q?t+z2BwWejcMqNvHqYFrRjwIw3FpIRoAEwb1LtYE3JeTx/FKZWMg/LCPI4E0t?=
 =?us-ascii?Q?ypWi25eQG87vFVgPbF+KAecKeC8r7n+HP7OIJxW25u4U2lEPdCfvdRkECmOr?=
 =?us-ascii?Q?MYGAipK0iFQWwIIm+UQFONNU146QGpKklMmeETVvCu6eYRRzWhU7GxMb3NUC?=
 =?us-ascii?Q?0gL+zgbRTbORBeDL1FKZHAd8LwtimD4uHh+CMjrTnY6Rr0Bw/MAHu0pf2G45?=
 =?us-ascii?Q?v27N4O3AnRde4OkrIViN7cQo2FS7hrLr6+2fX0cuT1PIFYIqMjFtxYxpRrmY?=
 =?us-ascii?Q?MYkOwUJtKGlzM5QiaOPWuhSVg9mN1GzEbwcPus0mCZ7cmYjQhYgERygqt7aP?=
 =?us-ascii?Q?RfYgjJllLoApmNBL76/2D1/PG9iiaQQ=3D?=
X-Exchange-RoutingPolicyChecked:
	BN3aGWfOc0FSml1pewfn/Ccrro4v9v4LKfubn45lMRsH0tOMiSKbiPqrGj4kz3bzqM2DnonVaXPch8gvN5yQm+ShuJlN/EsoJMlPRthkPjtUcftJ7LvfV0ahm1MTPdsSw85mD5niMV0+PsqWToNCkL+yeE9o+3SvFBf9JiGycRhnOagwzWPutjjDcS2zsdPFGI7OCxI8t+LmJI3VapJQ6iwrYBZ+F9FBWNqnP/hqW9AsU52h+9mt/3FUi0Tw+yvCVvcbH3TT5P623A5jdoKrZIGnf0Nt52HQQJdpiETQ2dAJ02zY8W4Hsmh1MJ1pOe/jND7e8k1N4tioiyxP6JohlA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3TiK9Rkb9eGyxAaw5PKRiVUE8ljzZHSW726iUiRB95T5Ib0hHbf+fhQO7ONrRlDYCGzlB32qqDSZWfFVccOjRl8I6F3n/NGXcBnu4t5/p2hVh5lWegRvWa47BZ8tYlBx0HSZBVMntMd00Jyq14MtF/AMGtMSW+9KhBuEKc6SpcvFOhLvUAkKjEQB1HVqkJ8rcuLxVD1YpgQEnvrLYFVyyapXbnq/qU7SKsr3eGZpLuRFOMA3BNY22J11Sfh9SabU9S1s1fp33jcAl0sTH5UjJneZAigvxDT7ljVhTDZFDqQ2qDrDoGJLt56+70vLSWPuFjF+nHn1oSsa5HbMSdBx5T2Zg6XS05Vy0e/h1h1dfZMaesAwyhkHreoXA2l1c7nEhB6+/NGJOM6G5jWgpHN4YJOK7/i3C4rRf5uDSYUjv2ChjBRc3AhJXhIVAw7zf6MrV571PFkKSW9fECQlY82u4H7CIPJ2YWD4ru/bOIoPvhOKFeHe0mEwVSLos/D798CZRpPkjFOEZojjKOYv1HoOOm0sqU3HgLJzJN8bmCHZkku2ly1rTZsE3yHWforgvhqrM4JGsYGWGXoF8MSxdbqDG5fKByAldFij4z6G4aPWGrg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81501a2d-fc24-4de3-1be4-08dee040fce7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 18:11:25.9733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvMufQOJ5xCw7epRwa5UfDZVPtJgS99caiSQD+teMfxSwL2wi4X+3DSvUmMCwk5RvUng1X4inFRKXJqBggaJT1m5vjGPrOMEVvEU7Gfn/j0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1D755039F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=890
 malwarescore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120195
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX6vBbucW54jg4
 h0hsOPqeJeoX8+VtOUDQuzDgO6tGeyCIOcD9ZShoysKCuzuQTZPl1gWWwEWlU6FKRGbw+aQLUmg
 vZEFo0sjfbnA+sMVjPEhd5BfmsF4uTdCFmtdzLTj13oefs2gKf/kFPF3Yd/RxaCH1XeuZO+UOZP
 yFy8GrOcFIRBPl8O0SIYL/16UIZeBE4MAFDhXaE/u+hTTuCvPHcpIIfK6npIfTsAg8TGpz/EiuP
 b+JMVOkaKSgQKYuSzMw3t2kdP9frORtcv+rsp4yX0GvY71cnRnaPNMUCblMHoCyxAjBlwj/KC2c
 Djlb26ySBoiMZv08WCGIfdTSs3Mv7BLSIy1CMHdWIsdYVK3KFTcXpi6eK6nq7bSasn0HKeTwZQ2
 AJf/6NmCfX2xd8IGj1/tO0BUEQDjlqd54zyqLgmqUjLYxys/ncxs1nV1/4BaBgLcsjHMqYT0KgP
 WIaGnKtm72gEQONKZ6A==
X-Authority-Analysis: v=2.4 cv=GcknWwXL c=1 sm=1 tr=0 ts=6a53d8d2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=2MSF8GT_-iQIVhiD6_QA:9
X-Proofpoint-GUID: mbe88uv5QgHUM-NyP4kNjUMpQ730hnic
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5MyBTYWx0ZWRfX9xvB8MhnkSwr
 U1svSd0nZhoPda3wpy8i4+dO3WONPCz80Stp/k20zqWfsytLb9IaLw4gBG2xcY9tE6PtYAprzJP
 9J1TFDkI2e/k9wmam/qi3ndrTE+AfnY8AJNR7qiZitw/E2X6FP2B
X-Proofpoint-ORIG-GUID: mbe88uv5QgHUM-NyP4kNjUMpQ730hnic


Ed,

> The first patch adds the get_hba_nortt() callback to the UFS core
> layer, allowing vendor drivers to provide dynamic, platform-specific
> RTT capability handling.
>
> The second patch implements this callback in the MediaTek UFS driver,
> distinguishing between legacy platforms (which require the RTT to be
> limited to 2) and newer MT6995 B0+ platforms (which can use the value
> from the capability register directly).
>
> The third patch removes the max_num_rtt field from ufs_hba_variant_ops
> as it is now replaced by the get_hba_nortt() callback.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
