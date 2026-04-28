Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418723F23C4;
	Tue, 28 Apr 2026 11:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374705; cv=fail; b=QRVZdIEB/tkRHspiAjlqzMAr9Df3EHn2SRM9MZ9cKVbOrU5kKN72iG/s8krVzes96p9knZNHDqW0a9LdKHJlafVwktykJZcl9hTfZMjAAkoGprK91uYbky9vf8kvqvT+A68y1CV1LrVtvR1nd/goYH4ddE1XquBBMP1p3k10ghk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374705; c=relaxed/simple;
	bh=xYjlI7GGuZjwwrV9dxuK9fHXb2Fem4+yZXJuvGWOWrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q7EyiAkZt2R8FjxKaNKRgn2DCWMVSSaduHtojqHAmDOEpFmT71G05NkthtqBqysoThSILdyBR9THuBK86DIQ8Nl18J6JW8wov6EsP/LsgCEoRbPGUZMbcxMBuZl+RkLV65tRjw3TizdUIcH79/FMwXqfGyfZz3cOn5NuXfQy8TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JIH3/9LZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jc3yK/Bz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JIH3/9LZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jc3yK/Bz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAKCW71015453;
	Tue, 28 Apr 2026 11:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qu5ejjtQDJobWV+8ud6I/z21eINPbr/9+GVvdtHO884=; b=
	JIH3/9LZMG1WKHUNrryRSlrAo+2YjFvYEVANWmKpvAxUVYTgTQF2WdKsnRng3F1M
	I3klsrJSb6Wixe0uDV5vbV+mvAOgmX9+BgKvAatC2HuaXJgpy7XFFY0AKCJAOiK1
	3QZy3KhBhLYiO1ySjG6m0TxxMzLSOrQfyIV+TMJLc6ySKryVukgt69Wm0M00sDNJ
	aLaQSYQOydAwvPlQ2MOD0MV5zMqTHQoXhEnRJdVUgBaehP69Qh0Yu410yHRpvIcx
	PzgGLLjKBtHxLdveLTr8JwmJEC670GNoXove7cT7zWSC8y1PunPw07o/cInuIQC7
	eaX6fUR0+L1U3GXEcUhJdA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yyjtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2jhU036886;
	Tue, 28 Apr 2026 11:11:23 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvem5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WXpKoIeA5LFqIjTdIdfLCVoeIbSYGmHj4iFaneKSFZhhqATjJA4BHCAVlL/gIyAcc9IWaVQQLxaG9cmAMx0hsyuMy3d8+yZT6Du1dxC/NS/kdPq3azNOWzCEkCpj+ZhAuIDPp4ewE80mgm7ff075pPe7+tgvY2/lHsIVfwtmZMvpM4KcjJkhz1stayIPaWBRguZJxDTty0o3V9Ye+y5VBkdiw5nZYqJ0qnBRVFk35cSYA7kMvTBZxkBmgboVyNFOdyaYUeiVR/3/4aNcSwJv4cFGj/YwqOIkYaV5vaVwVP8QEunvYC9AGFQ+WVK6bgKaeBks/qNciK5C+xmZB2qKjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qu5ejjtQDJobWV+8ud6I/z21eINPbr/9+GVvdtHO884=;
 b=ZBxbWV+U+zeJEmyv76P77Z6pBsDBm1262uOGzFNURFspORxycA/Rjwzv/qxRz1j7d7aNdlS9jngjRyaDUzNkSl0Q2VXyjNkKH2wzENjGQ6Hoe1r3nz9fILMdYT1bDpEREI+nh8kQcPI940yDU31GhAnMwVrai7ZbLeM17Rz6Y3bX9xE6mmddAlKX43XhujwFYBey8K/0q/kdtoTmDtOdy7Stz/hotWB79TII2iF1W+e5y2yMWFcFpj3xt6HNiVqVKiLYPalo/aeGyP9CMiZ7a8cX14ncwvg8p5VHNwTY6UXRZG79spfz/J60yvDqx5t4dLTp/nDKDUAHdUzedT+RbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qu5ejjtQDJobWV+8ud6I/z21eINPbr/9+GVvdtHO884=;
 b=jc3yK/BzlIOkPqMWE3KPbR78zyn0O8kesqmdPNQryFgd87Gx0T/M+BH4uNbk24/j1eG9vVIFxRUnxGSJM8mi+KGWO30bMkCG6IBY+McDCNiKMbca/p+D3x6vSa6inWl2kmwl6rx1Hs/5s20Ju/sFy0eZhxT4cf6XMQRtOdOAi9o=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:19 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:18 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 01/13] libmultipath: Add initial framework
Date: Tue, 28 Apr 2026 11:10:53 +0000
Message-ID: <20260428111105.1778008-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:510:33d::29) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ae5bcaf-188f-4d2b-2b46-08dea516df05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ux03vHIOlipE60jf7WFQsdqJ3cKk/sTkwcqXST/61XGgKDcAAYfKRkf8NX68P2n+0YCuEYIReHZNdEM2YXSd1hZavkm/6AYah+zUnL7CINy0HNyKR69ljMu1wMtx5dZ0ybZQLA765s2B4WjJAYg6M4veS3Qgz4vRNHdXMGy6qECTS5RY9RCXHIFLprB6tS8g3FKeAjETKG+rxkJuNTbJjuxPCrQ/dbMOolURUtxUeqBpYy8nD7tZdNH3alwpymqkFe6IcDz2aY134kr+vgnNsLfsIGOllktAi30bsQ5JEOAMZoEDAqpq8fgNIwxTZFkJjEub1Mt9j+pjB5NTPr+QlW/PnCwm2TsYLWnv8SS7CRh+rNgR6l5dsy9b8BztH+MKM+dCsmYxdURyeQyTWgEdWBznwZlaIGbWlWPFQ70m71fNpDcXUlLgxQhYRHApPoOwHC1xc+oPotCpFML982PgEDAyKvS7QVURIVmEHlII3bCpqyvCZRwtKUqmU/2yN9v9lnfczgyob4H7faWJVn+FR14L8LBsOUktiOwyFX174cka8yYI/vMAKgLJgNt/bOrZMXMgJH0wKlNmIeUkCgcbP4mVGWdaXDWDUCPjWnHO7UENJP3RtdZBjmg7CXLkr/qnYDBu4oiNoqJCdWTZKpvkYNJv397euJmjVFAF+9jTE0oEZ8YbLXWp9yHzYFYSVn4a3VnfYEp8J6JCqjyq6L8MjYd9ct8wrGmiaXWXL9NnbHo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hJU/o0T0pfKHqMvD1JQTWIU5RZBtR20fAfuCU74+M6kCJrY0R76aw+tUEqPv?=
 =?us-ascii?Q?inB/pmzTtvOEQtnaI9hD/fNXO6Wg7s47munR+LE++Qj1ZAgmtBWpNTS4sxR6?=
 =?us-ascii?Q?huiRj9WRwkDEfujcQeXcto+AHVJZCbxSnBWSBy68zzaeQMwlJHfCbNF4HIR/?=
 =?us-ascii?Q?EtM1Vdt6YEiOD+WGlf9HPz057Evhpj9+A7GfeGxU72y3h9xWJIewmMAj+p4W?=
 =?us-ascii?Q?RDR3O5ZluYCQZ7zES+cDKObsYPY2Lt1OA9gSP0Jn2LHTKiUAdTlqRSL1mTU0?=
 =?us-ascii?Q?dMisGCY/tBsAKxR3N8lVZIdhjQ7Ly39nBP3a4of+Ql5oPpbz3pInBrbYy+Zp?=
 =?us-ascii?Q?HcmNEeN91loPTfEVXdizglp+P3NHMTOfcYAUsvLU5iLDlSORX7Gr6SmHHWDW?=
 =?us-ascii?Q?JHZ/M0DGF0oHhJSo8T6+nz1K2OxKWbh628rBNZw7/gKueeSnDwbJdfttRwTi?=
 =?us-ascii?Q?cAzd4JCkcqCT3dX8TXZLsimIhj2jdM4dtjvSgJdPFwaY4zEPPQUFZ07eLqjk?=
 =?us-ascii?Q?0sJccYzjszyVwST/mxQRoXL5KRrB3d6eNiJ0s9Xd+42hHwfY302c+qg9EFeF?=
 =?us-ascii?Q?hfblhd48pnaBIQ0GbSgn5GvsPaRv+R/gVXnTEC8IZr4IXB+uhzdKQe2/GzCq?=
 =?us-ascii?Q?7ja/XdoeeLoZZs3ut/I02/vH5jg+SWnM/JEnv1p9w163047uZPIAdR2gQEQD?=
 =?us-ascii?Q?ymF7lA7iVWEI8oTTRBPNhcHYThA5QnEf7CYSpMVfKm5sPbTNPP19a+5b8+Ro?=
 =?us-ascii?Q?ZugLyc52+TyxgB19l5P4/x3buwhAOi6wDKDfj2XTthQuiklGw3yeoCaoWSZ0?=
 =?us-ascii?Q?IPoUafs4FkheNJFDV22Bjs9hKYZFj+/tjJV4PqJiaIf4UrdTGVbReJo7q5/e?=
 =?us-ascii?Q?rdU7Sm84t/clbRvWxe8FfaATivl5AO+jY0s6aZVmL1mzslMCf0R6kS0d2+MR?=
 =?us-ascii?Q?CWPmxFJX6KXbuxz2aT5AfKtEWyy6++Z4NoHY9mD8eYaEqfl+XTn6e4xYZD3E?=
 =?us-ascii?Q?S5AYWC+Oa/kzvfnVNkLO93F7m5PWorN90cKbdT9xBiDvCTwR3dfBOUof5FHB?=
 =?us-ascii?Q?PrPlcMPEC1nkHz3dBDmepR9WF/9AZMj59UGKU6YzZ+9JwuFQkNofKw+fAyfq?=
 =?us-ascii?Q?u6h2oOQyLOE4d0519g6DOlYGZ3GTOlUQ/o1tCMjgiTqXEMeNJPdwM4nx+U72?=
 =?us-ascii?Q?qExgVBzbrtVlylUQZlWNX0uY1uHbumX2fKjvtzNqPigpFBOVXbdoDd9li69s?=
 =?us-ascii?Q?5HTm3FS15fXWXnsf+wVE4B7FLiIB3FOueyIaGIHN6PXQvkLQANGdd0JKlGpx?=
 =?us-ascii?Q?mzB7F5++WNNN+hdjgQIPs9VaeP2u2s4o9wV1X/h0DnYoeTQCXw4B0Uu/r6GH?=
 =?us-ascii?Q?l0o+2Gt/mBc7oP+i0YvfdBX2BVherdaYMAbERwJqzbtsmCGGYfpJGocOKII9?=
 =?us-ascii?Q?9K23AOVw/vZkGzXoO4T1FxoagyPND97nrBZRcEoTiJI7l0RQuTMPACHi3XR8?=
 =?us-ascii?Q?4NsYB6kAGSqMnz5N8T7TPr9oGai3Us3AaVf0H4Vur0pX70/29tslmTdN7sBH?=
 =?us-ascii?Q?X+GNOtMVYojhJRTAs2ZFs9fmTYD4jaYeol8AOjXBF/ktRZUVeuJyPOMXCUzF?=
 =?us-ascii?Q?HTx5UAKuX2r+YSoYxLMD+rDvqKTvYW42NytdVcQKO7pYS41pB9Kx70J+2Od9?=
 =?us-ascii?Q?dfAeMlQG5AbPHEZxx5J5zT5iVbJFZMQ4pJUYHG+uSfIokClf2oCH8X71XYgz?=
 =?us-ascii?Q?7MJ8M3Sm3dZwPkv3YpW0vvUJ3T9ff/o=3D?=
X-Exchange-RoutingPolicyChecked:
	iFVlkLHt2bh8UDocI7uh4ZTSZqp91ynbjFuMi+M+OtYJ4KL3VRli8KSh+t3POXW3sQSrlWUw6YKZ5HfOJC62EvZYwAp/TLJzdKXtn3DRJjVlMdqee2RrABqedfFvVT6rkq7sAiwuVarfaj9mGw+hSL9F0UmIAYaYwFSWD634Xdx4ralx1c+qGzDOEunZWH08C5iMlCsg5v3CWfkEQd5n0V+hVq4c1bYpp45uEmTKRg4r8y7wMiAHZfGCphQS37Es/iOuXMWKfrNSMrD2/MGowOAOd1Jl9uCV00+gwelIxZkYQlJbFbOsmyX3usB3+z4Zj4SLcy3BpZec2Bund/EoGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eKKP8T+G6C4urZ1d6F1LlWlZbDzpw8mkVj4cBaD9AkPaNdUD4dQciUM2ATEFhcDenp28JPxCUhxGMwmZGwTg6xiTBs7wq9nfoowdcStsg9clSJPDbUwKK+dKDyWAicS0TUCz/OAn/ToplaLbNVkOP+ImCeLEar2ec75sok9xDNlvLEkj4VVfnBLdOix0f/9ZpRUqwEK7ESfBFHujBmM6sImAfwjkfoa7NvlMSU/aa3vpjuOF/M2dUTlUk6f4dUiYxZ/sCjszFjWq5Wz2f/VGK4WxodcP8/ecCQwtu/eMgKIbrIj1ilfO5RDZQhxM0Z+xSZTupLGFIDtwPGj1DOWrUZMO392zwKMyS+rIFnKXDajB67bhwVKZE8ooaqizSsXhPnk7FhvG3KB+CvQYLvDQsP4j2HYSFs8x1XgoCXSKpJg9eLWuSW6VpfShvh4cdMmfE7WJcaqKyOiMys3sPDBnindmC8ZXZNMGnxbBfmdkWqqBxYO4VsRW2zLIOnCH85lo1fWFQoxUm8i6CcNws4WYsGgZKWNQPm2v/LVxCXTVPuvY7atbbFyFMCAPxAoOCQFpaqM0b//ifkDVp37kdutPRpG7o3BCpFAO+txt4/ZnMk4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae5bcaf-188f-4d2b-2b46-08dea516df05
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:18.4432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFJ1OEFMbqqfuJXy+kJ/4MpgWXNknWF9XGXD4KNkIaEzJFVvZMYUzFCkvXUpaY2BaQg2FPcWED6yLUNvuKuLeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: 0LwnBUeDsUX-pyhdyVsVGkYkB48oI7sH
X-Proofpoint-ORIG-GUID: 0LwnBUeDsUX-pyhdyVsVGkYkB48oI7sH
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69f095dc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=XP0GnSSCGFUgwQirCqwA:9 cc=ntf
 awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX4gxlityiGVeR
 89n/6jWK51uXqcvcjKSjjAmOm5kSKD7eCdgtAlMNwYQTH0QloN7zCrnudTQtVbvAhrSn1K6ezlw
 +ODs9fPwT9WFtH5zBwWyj3Sqn3R9qkE8d+PVdz1c3vT/aL7BILzaDQHTV1QYQjfTp9uFfPBXkUX
 z9A/Ikp5b0ZUMHQim6gtcdn8Rr9mOcNfF+pUZjtIjpY/KqRT411DDoIuLj4E/RuzayiGqYRh+J5
 mKCixJm8QO1Eb1843hNz65wynX0xAndfisd5VRh+9IKB4dxrk8gXVYyuqGtKywbeRa6Ee3f5rAF
 HNHPCBQtWl5fpccMYmT7kgn18TQ1gyXXmtXalZzwX/8oZY/ES792p3CblgHlWXl6geWN1RiMdqb
 VacC2NyHIuoR/PPpvPHgZIM0LDgA3jEomow5qNMIG0CB+mH+XjwhiauondTRm1OrjyUuKdB0cDn
 9Jf5JbPsB/DUTsg6ronYt4Uhp1vic7iLzi0gKCTY=

Add initial framework for libmultipath. libmultipath is a library for
multipath-capable block drivers, such as NVMe. The main function is to
support path management, path selection, and failover handling.

Basic support to add and remove the head structure - mpath_head - is
included.

This main purpose of this structure is to manage available paths and path
selection. It is quite similar to the multipath functionality in
nvme_ns_head. It also manages the multipath gendisk.

Each path is represented by the mpath_device structure. It should hold a
pointer to the per-path gendisk and also a list element for all siblings
of paths. For NVMe, there would be a mpath_device per nvme_ns.

All the libmultipath code is more or less taken from
drivers/nvme/host/multipath.c, which was originally authored by Christoph
Hellwig <hch@lst.de>.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h | 28 +++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 74 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 110 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
new file mode 100644
index 0000000000000..102dfcf21ffc9
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+
+#ifndef _LIBMULTIPATH_H
+#define _LIBMULTIPATH_H
+
+#include <linux/blkdev.h>
+#include <linux/srcu.h>
+
+struct mpath_device {
+	struct list_head	siblings;
+	struct gendisk		*disk;
+};
+
+struct mpath_head {
+	struct srcu_struct	srcu;
+	struct list_head	dev_list;	/* list of all mpath_devs */
+	struct mutex		lock;
+
+	struct kref		ref;
+
+	void			*drvdata;
+	struct mpath_device __rcu		*current_path[];
+};
+
+int mpath_get_head(struct mpath_head *mpath_head);
+void mpath_put_head(struct mpath_head *mpath_head);
+struct mpath_head *mpath_alloc_head(void);
+
+#endif // _LIBMULTIPATH_H
diff --git a/lib/Kconfig b/lib/Kconfig
index 0f2fb96106476..5c70e6df89740 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -636,3 +636,9 @@ config UNION_FIND
 
 config MIN_HEAP
 	bool
+
+config LIBMULTIPATH
+	bool "MULTIPATH BLOCK DRIVER LIBRARY"
+	depends on BLOCK
+	help
+	  If you say yes here then you get a multipath lib for block drivers
diff --git a/lib/Makefile b/lib/Makefile
index 1b9ee167517f3..98948b18af7f7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -335,3 +335,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
diff --git a/lib/multipath.c b/lib/multipath.c
new file mode 100644
index 0000000000000..0d5690b5ba4ca
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ * Copyright (c) 2026 Oracle and/or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+
+static struct workqueue_struct *mpath_wq;
+
+static void mpath_free_head(struct kref *ref)
+{
+	struct mpath_head *mpath_head =
+		container_of(ref, struct mpath_head, ref);
+
+	cleanup_srcu_struct(&mpath_head->srcu);
+	kfree(mpath_head);
+}
+
+int mpath_get_head(struct mpath_head *mpath_head)
+{
+	if (!kref_get_unless_zero(&mpath_head->ref))
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_get_head);
+
+void mpath_put_head(struct mpath_head *mpath_head)
+{
+	kref_put(&mpath_head->ref, mpath_free_head);
+}
+EXPORT_SYMBOL_GPL(mpath_put_head);
+
+struct mpath_head *mpath_alloc_head(void)
+{
+	struct mpath_head *mpath_head;
+	int ret;
+
+	mpath_head = kzalloc(struct_size(mpath_head, current_path,
+				num_possible_nodes()), GFP_KERNEL);
+	if (!mpath_head)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&mpath_head->dev_list);
+	mutex_init(&mpath_head->lock);
+	kref_init(&mpath_head->ref);
+
+	ret = init_srcu_struct(&mpath_head->srcu);
+	if (ret) {
+		kfree(mpath_head);
+		return ERR_PTR(ret);
+	}
+
+	return mpath_head;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head);
+
+static int __init mpath_init(void)
+{
+	mpath_wq = alloc_workqueue("mpath-wq",
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!mpath_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit mpath_exit(void)
+{
+	destroy_workqueue(mpath_wq);
+}
+
+module_init(mpath_init);
+module_exit(mpath_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("libmultipath");
-- 
2.43.5

