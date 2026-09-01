Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA87D47D95D;
	Tue,  1 Sep 2026 10:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259582; cv=fail; b=JGvjqWDspxZvtslu407fCUvzVuyQ9KBQrlL8LB/5kjxAKtCaEUacyt9aBgnzQ4F+tMO4uk+tJxURg4vTOYw7HAIYyuezUHHHUFZ/0zBBRdMrzaFJCTqbpkjYUOecss0z75uZ88lB5bThu4L2wa32YxtuviqBdlDovfkJx2/pnmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259582; c=relaxed/simple;
	bh=0JZ14Q0fGwDCnjRTbG+h01uOwkGWQIXuqag805PXpKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HlJBIA+u/ih25B9EanOXuStdF9NqQx1vuJW1tigVVRbj0WxeXo8Lz2nU7WlIzJVR0/uph7UQhYe1E5C7Db6uVc5Cm3qKtuG88PhlLmKuF/o1OTGP0OLRRgFMjc9iSS3ru92CYZQ/BkqMspSaAiZk5hE03MQ9Z342xRfPVPsZkTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MAQwcGxQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q7Y1w10h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MAQwcGxQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q7Y1w10h"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBpDq2846754;
	Tue, 1 Sep 2026 10:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZMovxh+wf8jZqfOPnrTLdy+1cRRjhk6c4HUjpo8erTo=; b=
	MAQwcGxQ9c57kSDoeIKh/miM5U1XT7GiDcCqGJGOFLWVCx0Q97nZ3RDsI/mAJO7z
	PGDT3a37RLZQTIf1g8P+eX6L3uulLIHOxpIhythZ/sHaTURG+Lg5X3uIbba2KHj9
	6k6XiFLBoWOmVtg178WjykpUYVKmTih1hFBFI1FZ8q4CzGOldg7VUtycV5E/TtIp
	yyO97hPFOQLm7U5tobSa+uzeqO1LmID93zPKb2cjYrzXHUfoKwFGCsbMy5pAniWe
	pODVi0RhSnZYd8/5tKwjKxSaZsaaWIPxjmp25sUGUv6NlmRPixPBQybjN4l4+jFY
	XnnHtly8ljVqlibIoU3saA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbpbavegv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:45:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjY9u036488;
	Tue, 1 Sep 2026 10:45:55 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvqfk4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:45:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8wHbzR4PCQs6xWajKn3QHrZA4wWfyeSeouqStOeGpZrxg/lBsFd2m3ceF9GaFr/lznP1nh6POAz9XV6ou8XjK21pX7jmR8yTG4dhB5Jl2hmybQz/VKBpZ09Rk4RGcfzc/pkWCBJIDFgvHAzU06bTBR6DB6/rnkWAYuFAliVpNBupZXxRVWn7cSJ5SSv4osjRNSs/XmkXj/YJFUjwYWljvIoOXvJL0s4HymHDls4jT0aWJZH76WHXXwWoJG/cqVpe936ZWwRWaW5ymTwz6OcX+kQWm0dXbZu/AQQmMa9QJC4MWz++9z5XrHIQkvgZVxBtbiSzkVoysuGF3AtqIc0rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMovxh+wf8jZqfOPnrTLdy+1cRRjhk6c4HUjpo8erTo=;
 b=TXUeBKPvy+8VWit2i0MAMnQ8rU5kuF19rgW8v4+eVJLdowvassCh3ZYdD8oE4yEOoErGq/8W8tHTIk7YkuK/pl8ZQynR+Xn8Rt5cSUnJ95JYlrZSuEF131S6W/FQYxlDEFN23wH6lBDXWQxdj6ghSIjt0fhvxnN3lfI8fmkWW9aaDUxce2wIHYLi5c5q3ehBPbzeah4Dv7kCv3BtdXXeA/qmcl8bs0fKyhvBGsT849w+lfCKuBxK1nylYWLtHHiw39gb3eFi2nNiXlCV1SXtRNk7l31BVIelyD5nBxVos7UL/dMJPy+Rnf0XNgJEYYoo0Nxi4Ii+eD+X4psCkIXe9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMovxh+wf8jZqfOPnrTLdy+1cRRjhk6c4HUjpo8erTo=;
 b=q7Y1w10hUj8RU5fmswLXRH9GA7hzRPt8pzBfMTarL6JnxGhuxfnp4ypaF3DfXu0FNAodsSHib0DG+q8ART2U1Ch3YFHB1W/RgCRXdL6nILlddP9+JXBtoiWuQaA7TFbX5RAwca9a18fNGU1eGurpzPoSmC2QfuzBjRGptdb8jGU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:46 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:46 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 05/27] libmultipath: Add support for mpath_device management
Date: Tue,  1 Sep 2026 10:45:04 +0000
Message-ID: <20260901104526.3850621-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:610:57::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA0PR10MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: 5965db82-5f50-4abf-d391-08df08162d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	GSIAze4MMpFplQs7s4T0wPeuLP5Ft50/XeC0iWXg1XpwpN5kJL7qPkm+kYMFdcG4zjGbZWhpIoCBsSkTQ7o8FPwjk1kCyi8wz1d2WXTQ+HpznmEI4T/rO9T08rCOEl/XWYwZ33xyllwIpPgMhUJNj7y15wNFjFeqG2Y7BYCZKn/z2FgybyPCy2TTS4kpZlWK62ziRu8PT2V32EcHoHsNDNfdJqCGS3hVqEQL9LeSII6q+9g+1sMFA1+PjtI6vaNHZRkkpF3m38FfbYtaMyFZVX7pqCvuyb0fcu5THzQw/fBZITBem/Ifq2+et5fhVY+mypE0ljAKWHEnnHVXDJCIU2yBeT/PEdH7khpVm81tQca8cvNRkjlnx43/nje10Rlifcj0NDDq8IdrHh8PLR9jXvRDGoFnrIshrD1HU5coc+jggPgtt6uqdyvj1nSlqhH1V1V8FLb7A7EEwmzDLfh44vkavUI8eL27K2bV2vEILkMPyTGMZqPYzq9/jORzSh3URaPHweClMOD10qwLSomEZQMoN9XnSESDtb7/2VnEQTL5lT5IaNl5F/6Lt6J+yW3YbQg07YzeMmj2yULvxM8ZkHJ97U7J8hk1mJ1+Vin0wfgL5WxpubIa9qrmkDe5ssY5NFo2krIVAp8DVeSYb54Hn3Ul/4lE/C8Wq+SD7SXoUe4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zoFYP8hGQZ9pH+ZTfb0Q3hFcHeoS6hiqpBPBiESxRcz1m6Bg9PS8fKgmkcxk?=
 =?us-ascii?Q?OfwWB0AC6SZjHcpByx2obulflsM12PKXrSuGY7fQDStmTMX1tzC5urjPI6l1?=
 =?us-ascii?Q?ncpLTneWusVeIVn/1nqiiCLFYJCnumdR/R8BPkL9dmnzRDNPIPf/5p5Lu0Cz?=
 =?us-ascii?Q?Zd9mSDpMsDjxYoz/95VuF23KuXhW/CXZA8mnQQecSIC7bAEpSG2ad2TVHLD5?=
 =?us-ascii?Q?BNzS38Z20fK299eNuPlPg8ONTftYb+IEpq+1Hwkkhgne6tX1QJ6QDB2kjOzv?=
 =?us-ascii?Q?m4wtIfxWdeFy8lxFYY8z4raKo5yBj8es5Rg31wdZHYF22oQuaGVKD9zqoHuL?=
 =?us-ascii?Q?QW4UJ+AxGxruw2XBFKGzbJ3slvMk4YkJSQPWCC/Th5QmwVRIAsYW0nzDehKk?=
 =?us-ascii?Q?9y+EDG3IjTdzTa5rShtdB3XPrwJaQnXakMFvNxStqP7zLUxn9yp6vhqXHW7R?=
 =?us-ascii?Q?Q7tJ0wKW5HuhMoGNKGdyUWDytVYzaCQ3Ncu8QNBaK5YOUpOz7l2mZhHvhoSq?=
 =?us-ascii?Q?LZ05AWfTJk02GUj4cd4U1WGpSMIaCPVSivlYaAYZlU8edDMJPZB1bDdfwI63?=
 =?us-ascii?Q?r0YJZ6eXmHvG0GfhJzFLy5X0QywHys9O2FDJ3qEjhm1cIDWjJd4AeOG/R7KP?=
 =?us-ascii?Q?Ad+mL/qD9RaCITgKys0Ws3sU1WW9879iZbezKtOVi6kVr8uUwqWXLeD0uZuG?=
 =?us-ascii?Q?KypI5LTLbPHHeTvtVPTPjKaUznQYKGqFMGNZNgj2CapfmKI+6s62/YjCZMwi?=
 =?us-ascii?Q?s1K3Z1aeBTb7BzUcBq3Zc1rlEnugiys9Dmt3tpB/YwctTUcxGFNDW8LZsn6L?=
 =?us-ascii?Q?4s2zE9np33Bopj72Hf19wFC/VBAZzOoUCp1MecGu2+EEck2uhcEMNZRMk9zZ?=
 =?us-ascii?Q?yMGBIax1q+pqvsSHgN8NAfXLbIaUNFxvzkiQ7V51SNvohpu2gKVp4cOvpQ55?=
 =?us-ascii?Q?+OHNGrgvCkFvctZZejXx16ya8DPVbz0oa1V6ENRGbJWvNYKklMxULDEIyoc+?=
 =?us-ascii?Q?/qEHbymmSgl/l7KhZ2I5K1ZSJsaUOBeQMkdVOPpjtwDUCizvBh78/gSYRZlP?=
 =?us-ascii?Q?cV4vd3J95MANDn7fDuVIZIYN6BWpIe/+a/VXhXK4+5/MzcRBdRB6u0c7cmP0?=
 =?us-ascii?Q?gQa9tBR38aJ4xmIzMo9RzKWVD2ZE3d0Ct7dtxH3y4DNQPVbjYkcVLZ/4ir5c?=
 =?us-ascii?Q?6vwERxYL4OiSlzGCAKIGXmgXCfV9BNMwwCSiOfqIGbGXCg2XPedgyQh83UKY?=
 =?us-ascii?Q?ygsrmbxmyqQKsXYxRZS/K3q0bLWtl7C2XiwQXNtCpiP/aAONtSZaGm3PkuMj?=
 =?us-ascii?Q?T1okfkHfUA/8gNCGGQMEsMf81Cb3GtPPZyYatq03xMjN/ClhG8PwPRCwa4St?=
 =?us-ascii?Q?rB5ate3IeMQGbS2ZbK6ivZsvdQVUs2jdQ+AbCEXw7beMimt438Skbmh0r136?=
 =?us-ascii?Q?kHKpTd3BS668z64cPYMvpROpngFDSHFwojT1zOhHnJNqX0fnqjWYkrDk24f4?=
 =?us-ascii?Q?aLLqAv7XTd71XmWzbMLUNClFGrFNQMqBWFmUnAToLcfCloR+OG5UgGZKvoQ5?=
 =?us-ascii?Q?P6Q2Ogt4n/oas6aRWaEu5QN/BrnYBGwTljW17gehyo/vqEfqFsOEzUlarxlh?=
 =?us-ascii?Q?LcWxyQogTJZBwbliJ6omdUAppQf3n5Ffg0lZFaGugZk1LpnHQtaNEaNKtsLp?=
 =?us-ascii?Q?cNsPM0FL2chzsN7wr4d6OGwWE/RF5DADUJNu474pVpEn82u6vbajFukueEGO?=
 =?us-ascii?Q?auA5IFJiOQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	AV3U9najLBirtyiYFwKWfnvAlN6QGmv8Fpb0/rJ+Zog7kwPydYlsNZX96WV5+dZ1/pGEFBecS0yLVbnQSyQgH+b8Sf9b1LyrADeKuNUXzpSDWyyNrU+Np6s6vhX+hwn6hYM745wI+OF4iL2NnEn63PG9LaNhLt9Y6Cy3vCSuRc/kk2RbU1jS43rYK5+XrcwNNsypaOmrTbj9B9On5EmatyjYJ+T00MN3nbH5Zm++dlDJlDGAUQ1DEPKI2+3PffaoDvsYFWIzuuJXcg4SvKOOpau7jexLE32IqqzgMX7GsT7g5a3Fz0OXx847mIcJZKGnYOLMFC+b4c0E7hD0iteJuQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qwAjtuDT3seFSCJs82hcGfud/8GZjn7njyW1yZ7hJ5/Ziy0ir2Yk4gx7/ljNALn5hn0pSKbBjceK3fnzjrZglvfe2VPFPhBcSNCRAUgxhsxGC0pzUKdNEP310brjv4dLxPLuaKeeckGZ/WIKSMYyDYZMb5aUoq+2lHAPpbnYYpQr3UfGlHmbZZsMcTbxy0QvnP6HLS1NvoocyaAMlqScui7sShRuaYqJOmBPedC9cDxc3RWwCuQ21ccXfTpocTs9U5I61+BAfvNttbsrXc+9Ckoq//2Uee0rIplqHcY2dFEG5/Br3nitm+70qTwjntlsyZgDhGaPG4Slj26FP1D2l6uUn9pQmfQ8qYXQFs2AW7Ld/0ySjA0UvRXsoFZHiy9NnPoEWN1osKhsF8AfgdHXJfHtagCeTj2PGs3jRqPrxQ8t6sRoVVmfh6wjA3bzPq4xtKTjjZdpsY7+z1gZMgWMA1++AxmM0trGadRTXDef4AdWPhxuzRGevXMAzi8ZOg9c92kQJwrIJyUL8rQ6bETQJnYAIz7e6FqzCY1bVzy/Kqyt/7P5ICdOniFdx6UdJdUbuESQpZUx8498i9ctaG0whZ4ucTBed0tb+5SX+NEeivw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5965db82-5f50-4abf-d391-08df08162d89
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:46.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4ZlGsE0V4bwM0CP7xP2LWp+kJ+R3X/1clDJ6eZnVXkpVexpBeIVnBJEBvSd1v7/h64owJHyTKqvLF9SbeEPkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX+7+6gJIteCXQ
 /eeOcpCCLNkjADbspm0YHYM+KWN0cSeGj2aUPxyRXJS5v2OADsBkSDUyWBlXilial8ybGTjejJf
 whfm4nq4y02FqBex2Ac5i5K9ntYfKamNqlE+2Rw97n6075NyFU7x
X-Proofpoint-ORIG-GUID: dFYtnu5_RRiXuqljeKRmXGATBu7fz9Yn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX0GoWdkB4VolK
 6ukOSpb6cvBv5HxewNItEIr9vknyG+v6vRWyBAnZMsjFLp4FjJBR1wJeC942GsCLTIYbhufRYTr
 joEPRYJiPyzGstdWhiBV44RF8SNOQZCQXuup84A/nm50uWdKLnZTydmfoPo6upTIb37xbdtID/l
 Lmpz1hAlBbhVlSMGnapKPBDWf3JAD6To/wAHKfoQxaarowXP6CCtr22tSqq+z5qWFQ8xfJk+0pK
 rx8n300hDW8RGfTpwoEmQgQs3Ib9UJL+wSjcDGEebG5dTAL1EtRF6P6otR9A1YkbhqNZWn5TsZv
 ktOKSKq+J+AlWy/tZ/1ZzIZNihCS1V4itDI6mRBewSiq9eRsOfck0MfvC6YXzhm9knMUdMVkqJ0
 zEin9sWEfxzYIQ5cVOHOrfREtx0xwzCkNjLBepx32ewGpr63qSeytAy2w3MC78qBRNkEOiuQWr5
 GtgpsVl9zhZZ/0LvJFWb4/sZZ7Dy1KcZD1WCY7po=
X-Authority-Analysis: v=2.4 cv=DMi/JSNb c=1 sm=1 tr=0 ts=6a96ace5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=WlZ9DiTZ2y1qVm1cHVYA:9 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13521
X-Proofpoint-GUID: dFYtnu5_RRiXuqljeKRmXGATBu7fz9Yn

From: John Garry <john.garry@linux.dev>

Add support to add or remove a mpath_device as a path.

NVMe has almost like-for-like equivalents here:
- nvme_mpath_clear_current_path() -> mpath_clear_current_path()
- nvme_mpath_add_sysfs_link() -> mpath_add_sysfs_link()
- nvme_mpath_remove_sysfs_link() -> mpath_remove_sysfs_link()
- nvme_mpath_revalidate_paths() -> mpath_revalidate_paths()

The functionality in mpath_clear_paths() and mpath_synchronize() have the
same pattern which is frequently used in the NVMe code.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h |  12 +++
 lib/multipath.c           | 154 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 374f0531f7e07..033ee8d54bbe9 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -20,10 +20,13 @@ enum mpath_access_state {
 	MPATH_STATE_OTHER
 };
 
+#define MPATH_DEVICE_SYSFS_ATTR_LINK      0
+
 struct mpath_device {
 	struct mpath_head	*mpath_head;
 	struct list_head	siblings;
 	struct gendisk		*disk;
+	unsigned long		flags;
 	int			numa_node;
 	atomic_t		*nr_active;
 	enum mpath_access_state access_state;
@@ -89,6 +92,15 @@ static inline enum mpath_iopolicy_e mpath_read_iopolicy(
 void mpath_synchronize(struct mpath_head *mpath_head);
 int mpath_set_iopolicy(const char *str, enum mpath_iopolicy_e *iopolicy);
 int mpath_get_iopolicy(char *buf, int iopolicy);
+bool mpath_clear_current_path(struct mpath_device *mpath_device);
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active);
+bool mpath_delete_device(struct mpath_device *mpath_device);
+bool mpath_head_devices_empty(struct mpath_head *mpath_head);
+void mpath_clear_paths(struct mpath_head *mpath_head);
+void mpath_revalidate_paths(struct mpath_head *mpath_head);
+void mpath_add_sysfs_link(struct mpath_head *mpath_head);
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device);
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 int mpath_head_init(struct mpath_head *mpath_head);
diff --git a/lib/multipath.c b/lib/multipath.c
index 93b82eea7d38b..6b8f6e846987a 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -51,6 +51,87 @@ void mpath_synchronize(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_synchronize);
 
+int mpath_add_device(struct mpath_device *mpath_device, struct gendisk *disk,
+		int numa_node, atomic_t *nr_active)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!disk || !nr_active)
+		return -EINVAL;
+
+	mpath_device->disk = disk;
+	mpath_device->numa_node = numa_node;
+	mpath_device->nr_active = nr_active;
+	mutex_lock(&mpath_head->lock);
+	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_add_device);
+
+bool mpath_delete_device(struct mpath_device *mpath_device)
+{
+	bool empty;
+
+	mutex_lock(&mpath_device->mpath_head->lock);
+	list_del_rcu(&mpath_device->siblings);
+	empty = list_empty(&mpath_device->mpath_head->dev_list);
+	mutex_unlock(&mpath_device->mpath_head->lock);
+
+	mpath_synchronize(mpath_device->mpath_head);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_delete_device);
+
+bool mpath_head_devices_empty(struct mpath_head *mpath_head)
+{
+	bool empty;
+
+	mutex_lock(&mpath_head->lock);
+	empty = list_empty(&mpath_head->dev_list);
+	mutex_unlock(&mpath_head->lock);
+
+	return empty;
+}
+EXPORT_SYMBOL_GPL(mpath_head_devices_empty);
+
+bool mpath_clear_current_path(struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	bool changed = false;
+	int node;
+
+	for_each_node(node) {
+		if (mpath_device ==
+			rcu_access_pointer(mpath_head->current_path[node])) {
+			rcu_assign_pointer(mpath_head->current_path[node],
+				NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(mpath_clear_current_path);
+
+void mpath_clear_paths(struct mpath_head *mpath_head)
+{
+	int node;
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_head->current_path[node], NULL);
+}
+EXPORT_SYMBOL_GPL(mpath_clear_paths);
+
+void mpath_revalidate_paths(struct mpath_head *mpath_head)
+{
+	mpath_clear_paths(mpath_head);
+	mpath_schedule_requeue_work(mpath_head);
+}
+EXPORT_SYMBOL_GPL(mpath_revalidate_paths);
+
 static bool mpath_path_is_disabled(struct mpath_head *mpath_head,
 				struct mpath_device *mpath_device)
 {
@@ -473,6 +554,8 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 		queue_work(mpath_wq, &mpath_head->partition_scan_work);
 	}
 
+	mpath_add_sysfs_link(mpath_head);
+
 	mutex_lock(&mpath_head->lock);
 	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
 		int node, srcu_idx;
@@ -489,6 +572,77 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+void mpath_add_sysfs_link(struct mpath_head *mpath_head)
+{
+	struct device *target;
+	struct device *source;
+	int rc, srcu_idx;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_device *mpath_device;
+
+	/*
+	 * Ensure head disk node is already added otherwise we may get invalid
+	 * kobj for head disk node
+	 */
+	if (!test_bit(GD_ADDED, &mpath_head->disk->state))
+		return;
+
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+
+	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
+				 srcu_read_lock_held(&mpath_head->srcu)) {
+		if (!test_bit(GD_ADDED, &mpath_device->disk->state))
+			continue;
+
+		if (test_and_set_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags))
+			continue;
+
+		target = disk_to_dev(mpath_device->disk);
+		source = disk_to_dev(mpath_head->disk);
+		/*
+		 * Create sysfs link from head gendisk kobject @kobj to the
+		 * ns path gendisk kobject @target->kobj.
+		 */
+		rc = sysfs_add_link_to_group(mpath_gd_kobj, "multipath",
+				&target->kobj, dev_name(target));
+
+		if (unlikely(rc)) {
+			dev_err(disk_to_dev(mpath_head->disk),
+					"failed to create link to %s rc=%d\n",
+					dev_name(target), rc);
+			clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK,
+					&mpath_device->flags);
+		} else {
+			dev_info(source, "Created multipath sysfs link to %s\n",
+					mpath_device->disk->disk_name);
+		}
+	}
+
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+}
+EXPORT_SYMBOL_GPL(mpath_add_sysfs_link);
+
+void mpath_remove_sysfs_link(struct mpath_device *mpath_device)
+{
+	struct device *target;
+	struct kobject *mpath_gd_kobj;
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+
+	if (!test_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags))
+		return;
+
+	target = disk_to_dev(mpath_device->disk);
+	mpath_gd_kobj = &disk_to_dev(mpath_head->disk)->kobj;
+
+	sysfs_remove_link_from_group(mpath_gd_kobj, "multipath",
+			dev_name(target));
+
+	clear_bit(MPATH_DEVICE_SYSFS_ATTR_LINK, &mpath_device->flags);
+}
+EXPORT_SYMBOL_GPL(mpath_remove_sysfs_link);
+
 int mpath_head_init(struct mpath_head *mpath_head)
 {
 	memset(mpath_head, 0, sizeof(*mpath_head));
-- 
2.43.7

