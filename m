Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD223A0E85;
	Mon,  8 Jun 2026 21:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955504; cv=fail; b=KyIDO9n5aIpmmCnkqFbVWUkbzNGuKWHebLiHijffjt6BM2FVUCGOiCVU4H5aSOmFUiWo65pHmzOulCu4YGostFm6C2D65jL0fy4mocUnwelo0LHS490VQhWbWkLFMyDoyLyqv4RDfWA11TpgRFKPtRZlhnv1bf/58JUvUG7LGuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955504; c=relaxed/simple;
	bh=eNq9caxF1ewqftPtzPXtLBH/jyjOxVoLCl9pthF+joU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=fPw4rl5QB9/7EzOWYiXD0VKzTXNgyQtUH/zIR8of87RiBJYiPv6GZWlTZQXQcA3mDU1YtDWBsRUeD3f3MfL+/c6SnWOALUVLjR2FZOqbLH1artOX4hLrXADcL3RmoNwsCb9N0mcnrQCGZGui0GESQvWVmQzqLaUUfdaZeYXbW/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bt2jqcHX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nRY8XXbn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bt2jqcHX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nRY8XXbn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSc4x1242881;
	Mon, 8 Jun 2026 21:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eiLtyajrW4CW+9Tq2b
	m51PQjZ894zyiGkGRr0lASTzA=; b=Bt2jqcHXb5lW2qGZIfdAJzKsRGYodkkDge
	mh6iYoBbIdCIanOdsOkSwlbmyzjdj+Y57rqxLlTwF9JOqvFZp9REIAOTLsZk80Jz
	fLe4SwB2Ge/LdGkAKj+ZQTWH5TEfG/zShxUWMxz8IC8vDTAkB/e6t6EIHHGdC/0y
	loy7AcQiMokn+t+8d5I2mZgpM2HWwULnUd2/orsXTi8C050258enTOs/bGQwmlYA
	/uc207d+XctztDsHTvsq3Kug8hJk1avUXYuhc4t743IasgeLPwTZRqGt4i7b7eKD
	IYHVaJd5G4bEioDwJBzEMamLltQL/eFpFmlykSs9vuOgVZlrthmg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4em9ybbamj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:51:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 658LmHKP001304;
	Mon, 8 Jun 2026 21:51:40 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0e2ugv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Jun 2026 21:51:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VddD46GCok+J5gnyBeXINhbuUJJPAdGfjhTrp6dYis6oy6fgdEGqqzN0lH7Z5G8lUzjpLGtRiosvCkzhjT2XfOH3UqptNluayZiuSqrsB+kCuo6qRFH8lJYXvlKRlzDSFMg7rcxYvbY3B6EnI2pSHVBVtRVMAQmSoFWMkMiSkAbiZAg2KNFZP2H1tiweoU80sYC5DM1JU1TSgD/i+xM90a4VnqBu2QH7N/iOdxMv38fa8Fd/HIImxyMsdno1Y+XTX+wtWLtufUz2SgvMDFrkqbauzPGICzsgj9U5TZMw5k1cRVXXsr30vlS7mS2EImYB888SUUxw5b7mKE/X/ZkKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiLtyajrW4CW+9Tq2bm51PQjZ894zyiGkGRr0lASTzA=;
 b=p9EuRZnp7ETjlPCBpgpstfmfv9w+YASHDsPKR+Rf5HbIZIaTisK3oNU6Zhw5Cl+Six4M0PUVVgjmn4jl0xvMgQToo6x0prxJT/TWHMrnuorbyjA5yDrmkkK4Q4ondSlzNUl/st0UNUSPYpoElMeoAjbTmnTv3yKkM+V4HQrKsq8TZi6MAvDuRL5EuWFBU/NA2duzpaVfsMPlgJxEiRIuvj3Bm5SPcA6xZMDb4DxCCH4ZfGvdvBPnhoS6Ll8HlaoxDE0EUU9f0M6tloezwkjEz3jgKsXi9Tpuy4CaEGT3j70iI8E1T7XX58ylbsUcgZlSdiEEA4entlijANYy9TEvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiLtyajrW4CW+9Tq2bm51PQjZ894zyiGkGRr0lASTzA=;
 b=nRY8XXbnUGtXcf6VRSfVZTH+tN9PMX5aTfzB4pV5ZCjJpfHmE9BOmI+0ttZnCtCcFAV0oMp9bIG/Pi8uI6RB0T4gePPcwq9M3f+3PsuzAePzIGZKPBWywIMaL9Ev3ZUVXpyESyB16186xKAsAYrSMFsQ0ze27EHlM0Gtq1Od7EA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BL3PR10MB6067.namprd10.prod.outlook.com (2603:10b6:208:3b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Mon, 8 Jun 2026
 21:51:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 21:51:36 +0000
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] scsi: target: Remove tcm_loop target reset handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260530052349.5134-1-michael.christie@oracle.com> (Mike
	Christie's message of "Sat, 30 May 2026 00:23:47 -0500")
Organization: Oracle
Message-ID: <yq1se6w3dm5.fsf@ca-mkp.ca.oracle.com>
References: <20260530052349.5134-1-michael.christie@oracle.com>
Date: Mon, 08 Jun 2026 17:51:35 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBP288CA0032.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BL3PR10MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: 9550369f-f014-4e48-28ba-08dec5a81d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TqQx+JYdVBG5YyL1xypGFYvBnHkyo4RF9QvJxPUCyMX/oghlUGj7gbyoiMObsjM/iUYZcU9KZZthjZAPPHO5VtoHT8m0iz3nxlGRt1cupqG6vJiXzprtL2IuBnPQbmEyZY4mf+tCmeWfBoun6onf3akAlLIfXEHlhAolzI7cJfqR0HjaIQnYSif5ZqJfRA046e5mnIpym1W/qUChHD5oX6weJEyHVIzMmCFHcHuG85hTJeI9sLlpYjCoqA7+ZZpMtVU/Wa1owgZZS9fbCP0vqSaMB8orkn+HCxcVqc8MRotTub3jIDv8k7DRzrXkSC27SX036ktMdB9sIVqdGbK4dSs3uVIB2wGjwggXtvCHwIA7CQN2Qo8vqsDNJOzhI6WmpH+hOa1hgMlQSdJJm/HMBHRDJJfD9VhdYjWGw7yFGaC0w4A0wNIq+L0C5PPSV6VO3XFIlV1tfp46fW06W9LW3Pxo5t65qvz56VIqXLJwAzMHD8Y1Bdbl9rQgng1PvCLDk2y4vUB9S8EZQK4Fo7niIJPNvFELmaFnDelMUkctmVWzAI6V7/XDVcrZKjuT392nWvWTHAr91b8QG1qlABqOQ5aLOe25M02Up+sK5SpGh9/S6yvqOrEj+LEzcnoCLdGBmMRuvGMZ3tuS0cASfR6F+a+2VCDXPunypdswCENHUz3BXDcTDO3bYDoy4MhHuXND
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yZvrRFa3SKHz1ERTUYRusGxhRdXI05v9mmaPMFmiIviuDws3oZvoaQdmno/Z?=
 =?us-ascii?Q?efLS1oonevmIvtMYbgeDzBGkkN6beMua35DDDQ6ZBkfrHeMx/DAgLWEwme2Y?=
 =?us-ascii?Q?XrT9LNnQtWYjikjMeWaEotHFTmIOd+MQDQ+O3GXmZ8A1XvWpJn2hOEI9zrDI?=
 =?us-ascii?Q?rhwb2LxshjJ9NXy2ldGhslZe1aAmvgX/aXj8+FkQFXVRBXJy8xPINqqXFX/b?=
 =?us-ascii?Q?dPamHiGkqU5/WzcFMehT7Z88ijCQhJLhonOrory5JBXoP/2LGoVjKmMJoQAu?=
 =?us-ascii?Q?cu7TkQbrOALnLuAr9Ff8BZ6YMcMl5au/1Qy1+OjgXzGSgwc9OzTzfabnjpBQ?=
 =?us-ascii?Q?k/0U/mePJNExbaHpYQz+aLXv7O5Ja6En8zTtLb4Yh+iTd1ukykAj8PoZNJOL?=
 =?us-ascii?Q?/3Ax6igq3wbfGxHjTUsOEnwmLGxv2pS4Fr96XPWjkTpBVGE/mCndCDiAelWI?=
 =?us-ascii?Q?cyIXxVBJFrEPoeqG+a9brG1tCNJfsNO3E8uS86nVC+u9++DJXBeZhd451qpr?=
 =?us-ascii?Q?VTEuYCBq00ssumRDleh9BiQoFDscac4IfOtsPVcCgexZkH5thDuR83suGPH/?=
 =?us-ascii?Q?ngh8jejrnACZAOaXGDW3lz32WkWnoUQ5kzAZPNH1HlPTELPr8yp05929yIpe?=
 =?us-ascii?Q?PsI/1g3vsrU/CVIli97aXul3xsCPlcQg/rXnOL12M0LRX9/xIaNIP5oOFP6w?=
 =?us-ascii?Q?kB82y7DXr8TSWVOmx0uz4nPSa9pRW/18lw9Qb8LL72YKH5MM9vAPk79ZW9YR?=
 =?us-ascii?Q?cqELqb/GE5l/6a/a6MPP8OiByCTE/go9gt6FLE8W1ESNkDLXQaGykNmF6mhX?=
 =?us-ascii?Q?/CkOSeoVEBGTIeqZ+28Ta4bpem4rllydRjY50uBNxl2/no9VfMgl5agvO0sF?=
 =?us-ascii?Q?qFw6jO5IHuKRC13qE4eWHNuznqbOhx6F5sBLMl0Ztav9u7wd+nYTRcYmmmyM?=
 =?us-ascii?Q?YVSmIne5IdM0lrE831nEQX5Go0hhCrD5F7wTorlxBSfyi1PKagT3GosuqNHh?=
 =?us-ascii?Q?Mn/yO+lryEVdtPhqP9tQgcwM9XE+fL6d4Ffkdtt0OdHR8D4ySUnC2DFNZByB?=
 =?us-ascii?Q?HLiGEXnyEjn1Xi2/spoQrSfXKm4nypA9nm1kVQOrpgDggV7uW5TLnzjTTwkU?=
 =?us-ascii?Q?E4fGMgJH1TvLNHzmpC+EgHIZoeDsQPGXFSKOKQI63RbXMF9cg5ozE+4kHZJO?=
 =?us-ascii?Q?fI0zvKkxdg63SB4Dwxm7XOxeKDi3x3QarnlT5FxPmbKLmXdBGYY8A/hllmi/?=
 =?us-ascii?Q?bXAatTPPH2ym4RnEChU3tlI1ZejtyxQcy3hOn5igiVwFOQ2lL4B+xFOkHSFx?=
 =?us-ascii?Q?K/y5IJyd9aNOhU053lMp32UlbGYF1mz0bVZLOQFF+bWq92/6tVrMKno7Q1tl?=
 =?us-ascii?Q?WPOzKNc2jiWNU12PtVXf7phK4m/dgMdNZZqW/KwK8FkkeeTAFrWBvg8SxpWJ?=
 =?us-ascii?Q?4WNBt/HEYx5qgCEaTVj0rElhO810G/dH0bFmIAqT5vpED5YYyycAw8MjkdX9?=
 =?us-ascii?Q?fVDV1idTdkRYDa78eZTvzLRoSFzfjtjw5gPygh3LyyoYniVv/xI0MnsKp2sw?=
 =?us-ascii?Q?ElLuKmw2M0Ses1r3E41Mw+wXTRYKiEDeac8ni8F2dB2ZMD/bOn9W+UC68P/3?=
 =?us-ascii?Q?y4fxJmeqnYmJ07qGnLfLeVvijCRwhpGurOQb3qSmfURG4uOF2ML0tYARMF5p?=
 =?us-ascii?Q?Fr9EQZ9d1NDG0olBnSgnQqq/b8IVbKKMxdO9Ykx9n9cnhBlAB5NsPaw3MpLJ?=
 =?us-ascii?Q?BTka0G73ZcsgAAm6uQvqUN1rCU3P9Ys=3D?=
X-Exchange-RoutingPolicyChecked:
	hW+835I7iMzHVoBepbDNrx/u1HU2Am1kHEFftol1GhTwqw31IGcM41hD5aNpMkPjbv5wdLKys3dpoyRhPPb+uSP3CUeBngJzT1SNzmLY3fOMhOwkWJsny0hsdJ2n/yv8uJHGol72pyj1Ryezqnj6oT5/vZkKSyIysFyq2wYR8E+pU3p3v2BLuwf5y33DiQKe3YI+cSMhnDKmv8ZRgWy5IRxrNf2GO/eJy4eXPz8zVqKDnUufcLLAnsTeXDoAgk4jmuIlcfKbfwk67j/pQo3m3YbEUYAo4gzFqtVhqaJ1eelQQPv5+N2TjqhyntTiQIHvMr23iZq5AkinhVFXpFSGpQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+hMC2ZGb8OLCHJR0z1kC/2ZMfKOrYrDJhY9bq1SPFiI5Hmk2XZWnfOoZaQ6Vcb7B8BRJ/t4MJY0R9l6fNdEcQv72gyr8ez+51uUWbSAcSfS/1mldR/cVb0OaNYqENKciG59BbrD6PF63+istms32UiKbhLyv5SskZvmp/c38ysdmtXOZdb3wVyY3B4rhH8NxT+FKX8BPbFOifByaj1EHEkAM3j6FoHaFtqW/W3aoOPwjSPfhcWxASX91c7B9Z/U0fS2l/JY3j5nMJI4ybrV7lqRQ4eOM/sD8vB2Jj10r4354kqGGC+KCfV2TJhnjS8w/scC0X73AbWetBeACXd4LsaWvhLqSnLBUJH/6dCaOigFBhDyxaWmbBY6NZOrgCQyyFcX2HRwKDnbjnTakUHWfjWHjwMe+LY7LiUc7sQqQ6KnFKVy4wNDZI89mV2PvN5pVn5YRTfP5kQWvsJU4QzNVZjEbCTP2z5QWLRmt/PC20ZKNy8ahX8UpdgpFVpXCuqlIfGA8NsvnIj3lngzDhZucCOLm6MTdUoMKg/WMJbNwWC2yGmDq0ypbmPyRO73yvF90sNubQazq6Qm59bAxPIQ93IsUA/fYv9Zm7QeasjIhzo0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9550369f-f014-4e48-28ba-08dec5a81d29
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 21:51:36.8808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chvTvdzFddwZSDhGHHsWe5e4yUwahBkmbvPPX9AkmEv1DjhTt74Qt/aWJE1p13r7YDwyDAyxVQbXzJm3f3IAmpiRxNkPizKP7hnzbWo0IJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 mlxlogscore=778 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606080199
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5OSBTYWx0ZWRfXz9kKjki9C06w
 jJ1aXqED/tfu61QROVyI5vc0H1KdWK3i6sTFr2sG7l5+aESMyqygoE/38og18jxJsU67zT01mkN
 ypgdhqLnYOCkqTN3oLXGsrcVc5Z5Nasv8VlGBKJ7ReQjXBL0H0u6apKQw8usg4P2tsGthDBMaCB
 n2S8BsyhcCP2GTrN+hlNRUiNsWK0bm//oIB/GeQaUaPVPBzdHLUNlFyMugmGh0Nt2Z7x8fqJYV9
 q0LhHOZuDYSdDWsfMFzu+3mu6z1j0l1BLCXWhzBfi2HYLWQ8W8zd50WwvjgLZpmU6KMZCo4VFgG
 kJ3gAOsWjO863oKhTdgLP++P69fO1SdDUligByGOpEQR3eAUo+4LMD+BXeL+/jTWyTb6pk8/2Ok
 /bKXraXHPD/EtNc3h69zn7GewrT4hmXEXVSqtM/vznINZWMzzDy+nYS2GkPp4GsF6kboZ+UhSQa
 Rt75cgerkQwQsVAvlrw==
X-Authority-Analysis: v=2.4 cv=IYK3n2qa c=1 sm=1 tr=0 ts=6a27396d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=FelO9ux0wxsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=cXXqVfydNUKYWxbBfhMA:9
X-Proofpoint-GUID: ToPJofC5kEO_UofLwZGSFOw4fuN7Zvei
X-Proofpoint-ORIG-GUID: ToPJofC5kEO_UofLwZGSFOw4fuN7Zvei


Mike,

> tcm_loop_target_reset is supposed to handle all the LUNs on a target
> but it's only doing a TMR_LUN_RESET so only that one LUN is handled.
> This will cause us to return early while IOs to other LUNs are still
> hung in lower layers. This just removes the target reset handler for
> the driver because LIO doesn't support target resets and for the
> common case where this is run from the scsi-ml error hamdler we have
> already tried an abort and lun reset so waiting again is most likely
> useless.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
