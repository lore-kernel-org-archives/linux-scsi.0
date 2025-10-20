Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C382F6173;
	Mon, 20 Oct 2025 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956717; cv=fail; b=af7UlFh+2dNfo5VxpdWxQ8Yms8dAtkA0755UgnXQ8pNjSgSO33cuKKbUcbKyc3MihbxMsS1dnX/CRSpiYS6n/gvtkpwgaOyY+g+JSKD7L7DkIimDRRoWaOSVKcoyx0IKJ1wJBoP1RUpbodxLRY14XipnObXpjIYb26vKWJyK4NY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956717; c=relaxed/simple;
	bh=kZLJWXlPobFPOkkPGLp9OksXFkAVsxSQjuviY65FRNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KxnVCTs++vqTOYIIs664SyrDrq7F6Ie4SlW9oQtE3XZVgeANDyQfZfpJKhGGhFCBoB+2W2Agt73QXhQ7us9kpQcCRlLCSSfdW4UkMzqeP0SXh/ytCYVEh4Iiz8kboe3aoLTapfpLsNjgBPjo1kOwb3chv8OcsIQR6PLOUk7jeyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aouU1KDs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gCgG/zqd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aouU1KDs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gCgG/zqd"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SAlQ006199;
	Mon, 20 Oct 2025 10:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RV2xenPGdUewoQxdW//8FEe4aqjuVmY2eLpJc4yV8VY=; b=
	aouU1KDsCGn98cNrRbjfLQxyG5+gqKsaiV9Yfyqa05oqbqYFLI4r4F7LRDZpoMrp
	f3MJ/7pbCiSq3/zeviznPyrq7N4bVVFpX94S1SoxsQYa2GooNgs5lVI+bnize82g
	zTMVg9i5nNdhgaDMRw7Xc6AZk7S/qrcb6v6qILF7QdCt9sxy8gXECpdRojfaxUdm
	e8vCcBN2VD1lsG9QFsItcDtgOINBEgR7RBS3H3e4AU7MzPqWCbssDvtdGSrqzJ45
	bhIQrntNrgEx3bmC7xEbNRYye5ptn0ARor5ZeqbVNNYoccd0HDNikPdtIfeGQAoE
	SaRtEtV9B+dWs6yxgGFOwg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vvt0sc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KASJFL035186;
	Mon, 20 Oct 2025 10:38:33 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbjdth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 10:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvbiKMfO3Gg8WC+kpbJddPbcudQRTzKrISXIHvfrLPYbo5D4cVPPuUEfn17LGS9+9zdxlBZk0e5ZAdEaRRQLSKOETK9HaAg0MDgV22eGboIYr6zzy1NvsHthoXNBpMYeSY3k2YzHpWWEfHhG3N9dUVoVlMlJUB6E6paSUdwav3Nn4AEWq6C6NP2GnIbDqR/eyrIy+kTyA9xUYXYv4zEe7K0decajHYyMVlSKQ7h+dlgow9IeKJFlfmTA7HWieQR1G4Tw6DPoJ7WHf/ETjdhBokgX5b/pVayg8a4AzGzmVw6jT7moeEz2NAuBGFsbyliApHzOqs9VK2h7441dmkKe8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RV2xenPGdUewoQxdW//8FEe4aqjuVmY2eLpJc4yV8VY=;
 b=sBv4Ki6vXqmb/j681O80y/7e8LUEvRwHef9IU83fCnyOpb2785hSrhg4uoZdJvUXKVhxyPmqTnpAqNg3JfdzgmS/o9XSw4YT0VlbZOQTqo9aRR+fv1l7ssa/i9ishtFS7UPeWNV8jqmKq4fQlX6/UNh4WLi+nCGLFbt/T2IGXVsDWq8tOdXd6Jttv82lYXcphuPdjW1SqV4eyHbcP77lJY+t68bhGG4QwESuSAfRyGqN6sDjaZT4sbffg8F+gkc1nQVVbK1nm9DKFo52I1hVw7fgB+L3EOzGJOxH2J7KydTiTqmhnjQFcM1V2vu5dJJvYYt5DIRHIq44ZuWBBIebCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RV2xenPGdUewoQxdW//8FEe4aqjuVmY2eLpJc4yV8VY=;
 b=gCgG/zqdNrcNqtKpYb8ZnRbMd9Z6d8fvW3NwvbfVSEQ7E1QalKgE3UyIVRM0P/jUPC4zMCjnEY5sf2dVlROg+HxV1CuF8R2Q/yLlv/89gQLRkvtsd5y9iS20xRlqBpj3D5+HANM00PXIvg5vOXP4xxfTcqs6jEZ2jnp83Cu0Qb4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CO6PR10MB5618.namprd10.prod.outlook.com (2603:10b6:303:149::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Mon, 20 Oct
 2025 10:38:31 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 10:38:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 3/7] scsi: target: Add helper to setup atomic values from block_device
Date: Mon, 20 Oct 2025 10:38:16 +0000
Message-ID: <20251020103820.2917593-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251020103820.2917593-1-john.g.garry@oracle.com>
References: <20251020103820.2917593-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:348::15) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CO6PR10MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e79c865-a351-4cfc-ad95-08de0fc4cfe9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cZ+ljtOXqxDFwo5TTIcr91R2wSpncSvTAFN1pWVLVQ42lRGSZQUkvSFfa8Fb?=
 =?us-ascii?Q?mgQkeb/ugUiobCp4Srq29RmoTWltUZDKFQu1EtbK35lDoHSgw0RxNNaR2LkW?=
 =?us-ascii?Q?396DAVAWN3h9HMgLOOwjigAbJR3twRulp8xNzJD2PG0uC8EbDl73VKdCj5Kz?=
 =?us-ascii?Q?VuxqilV13P/B0oc6KFZiB/eF6cxhZE0IAh5QgqXdbSSEfbiIgqdXP5PBiPZF?=
 =?us-ascii?Q?++0XXTWdJHKUd//a5ULPImN3zDvNZCJswvGT3mCJCOOez1BsfXVOkKE/tpGK?=
 =?us-ascii?Q?kGTzgyr+iO2gjogs/jKxymDRfA74qz9GHKqSjnkT/O9+qm2ggv2Kx8Afn+0q?=
 =?us-ascii?Q?zUn0ixOYIlYrYkykI9T1Jp5qeT5XQX+DvS2mAeeTIalKBDD4dDrxpuGro0MZ?=
 =?us-ascii?Q?eNZ+AWUwu7TGGlnGdHNGS7DyhS9CaTEB3FjlBwG70LX9vWgOGSSAhYyeliFF?=
 =?us-ascii?Q?ztg0TMrmXsX6VS7u+Iy5d7DRz54uFYCEt6wgQlqkVbQVcfTIjuAuT9Qg//dg?=
 =?us-ascii?Q?7qhNG9TgYqeHGZ/+zi78NPQDYmx0wJ6OJvUmxlZaDlwFE6mQIJB7d+VB1SRc?=
 =?us-ascii?Q?8nc1+y9lOCZVnIlZ3nBwq1HoMxeWWNTmTU0NaCVCGKKF02wK3/EWbmg7JeNd?=
 =?us-ascii?Q?na4x9Lns1EH2FYhrluYmuG5zMyMpZD8ADyGgUqML+VgsEOelyPOfXdiF/o7a?=
 =?us-ascii?Q?RNvbXBjs4kULFwYDL1o4jCeUHLBX2z3wqUmYK5dsYULHG9E15/NiN6YHJkG4?=
 =?us-ascii?Q?6JBcTn8gXm/3HQFhysIUdALIyHHARsexsTLDh8thc3WoJ+I2Sz7RxT+1yO6M?=
 =?us-ascii?Q?7vpNkt7OcoT5h7xICABWeMe12dUvC0qufPcqLZcxMMVXJPgZDq1YK8mGVpuK?=
 =?us-ascii?Q?cbAhxXR6c0E9vq4HmnOzvpfw3JPCsYMshpCiWNBpnBMmc5/TVP/x+42itEEr?=
 =?us-ascii?Q?jTcO6931LwjaBnOD3mNHkRPN5Qc35YF3Oqw5T89GPuGqu5MTQ8YM/pS4Ufbp?=
 =?us-ascii?Q?8+uAoA7zmgLpyxmQZeEV5TuObLaFZqfgnYm0WfXZRuQyI2WJLLzVDLGofffm?=
 =?us-ascii?Q?vaNZKpkonMpywMS57LMv+TlLAr9kFcjAqONgM3sN6enCM7rlM7vr+b9wDkhF?=
 =?us-ascii?Q?0Cdmy8JUDFe2touUVdyxvFOOpPUv4RgCqXPr+OE4Szw5CcmIwguLrFdKu0T1?=
 =?us-ascii?Q?mTiKCepX91WGk39Hs96W7gPARAwXkrYoOs5PxfWBZy1gZ4rFF91opXnjGksE?=
 =?us-ascii?Q?jF7X7dnqdC0PF7WqwuuPfXI2Zz+b2CDCdwT8Oj9pE7utzvAJq3qcGBhSWz3M?=
 =?us-ascii?Q?zPiFTBifp6w7od2iewjqxKMnt3hC3xi/Wv9xBEpK+uSP7E+wSZD+am211uax?=
 =?us-ascii?Q?qEHuozDKA6Z4G4MXx1VmczjlUHZ1MGv2unFs6YwhSCVS+E1TD9AVz1TOxpQU?=
 =?us-ascii?Q?q9TYLdPlnKzxmWyFTUOsvvZ96ElI6++u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KPz3QowU0+Bb2QHlfkLJpwnpRWtFfs32mrdVfb4ejM+XfVRFq6qccD37RB1+?=
 =?us-ascii?Q?tUzyP74p4tEs8XhV9vVNRjHqZdR2+hjxwC0kWTMnSB4QTvq0/j0oA/xg3WQh?=
 =?us-ascii?Q?Ew9ToeI8fnviwJKwRysx2KP9GswcJFwCFju8mOkCiHnzGeeVy+33HeZc5bw9?=
 =?us-ascii?Q?yRGPPnG694egbiBCOnmiPtAbKYtkIBgb/AN0qY79rIA8eGYMqbuw5q6zjmgx?=
 =?us-ascii?Q?up4XN72bGHVFv2D1g6KK9obbEUJBuZh7FLppu68aoS2btdyQ016ytII0m7i0?=
 =?us-ascii?Q?hfFI7cmUc0ynTXYUV72Ajt72ZD8HaALQY7nhaLrvm+0Q96zJETfp0T81snGu?=
 =?us-ascii?Q?Aq6EhrWWK9XxwbD1bnZLRXjoZa+q5+Y5ndRW2DdWIcpfM/+awpWmluKTIjBO?=
 =?us-ascii?Q?lkf2OApF+eANajdiN7BXBYz/pI68ZLX17xn1Dc5ouHY6Rhdt/iz+LT0AKFmp?=
 =?us-ascii?Q?LCy8p4JW73x3inkfD2y8+9EPTDzZFNvYhNVLIMhsbyQPuGyY1LRzT2+qwnwG?=
 =?us-ascii?Q?s+zUmD4+jZxxf+pG851MD6gpJmixcm2XH2YW/Tt+8dEvw1cbOcmSr9Eq1At8?=
 =?us-ascii?Q?CuQxqAKugx7E4SCmhnjS/ZcUCEnytFsSwcBSvEw8gdocPF4WLb0cBuVs2NL7?=
 =?us-ascii?Q?Be+ClqytUZ1aMEdYCxOSI2MqxpqVO5pBpjlGVPF/LAZKfCM/fuw0JT66vwPP?=
 =?us-ascii?Q?6FDsop7CV/Tc2LyLd78kUEHeS7Uec4O3iYYUJcIeZdr+crfixrzuuc9Oi56P?=
 =?us-ascii?Q?61CzA54tcpb6LAbEIWD6pH305odoBTp1WEezzjF9GPEuiRfC2viYNL/iWp2e?=
 =?us-ascii?Q?M1ymKE4dujSmhfMRrj0enQOWBIwoQ6Jnt72+JIdiy0RtxBvdpAIppG2tu5Fx?=
 =?us-ascii?Q?nLaQE5NlxQQaTPNUlFYsT61IHVCdkRDWbtDkcwZeusJ8SfirzcAA9QpuAR0Y?=
 =?us-ascii?Q?XPE8Khdb79YnkIsadHG1CwNWAfw6BFAyAlrRGchOSjuIXCJEPq/f2xxXDqtz?=
 =?us-ascii?Q?ffF/BYFxu87KJ/MaoCwG8tH2i37VPCGlRaAUOrBSkILGJMud2bKgutkbxR08?=
 =?us-ascii?Q?L+BTFdSMl5ALxDx7+xs0mSZk0hQ67UYtR9ezFs8jD6P2A1kpzDOe6oCP4KLh?=
 =?us-ascii?Q?7qIpg44XkYfSVCP6M0eszkDvgY/HPq0NFbGAF8Td/F6rWzHQpzA3lbICjD1+?=
 =?us-ascii?Q?1JE2zDRWA3sn7+kxOFZrqaTxITYLevYnTKNQXpL3fI9Qc0TMzDEZPON9vnJN?=
 =?us-ascii?Q?IpLqsYSAljMlj1IHdO00DRo0NxiF+9XHHbEwXwAJEmZrO2gphHwIRgwh+BNa?=
 =?us-ascii?Q?lxFsXNkf40ruGFD4YIbj+Mkd17iKzJb/UZ9rq6MzQq/0kLBjOZz36wS7EsCc?=
 =?us-ascii?Q?gbCNv/LzEcSV2SohrjXoUQEDtqjQjUlwfLEyvuFWqnBTUpopfEWMK/OP2VvU?=
 =?us-ascii?Q?3QtN0Mvlxj4tnp6e+//WS07j4ZXqhHq+6zy3ttv+JWsGMMqtr1K5cvKhgB9/?=
 =?us-ascii?Q?SKn3FKq2FI1f6qRiXUhwz+vuSGHCgw+8FT99SCrdJmEAmQYcC6GcpLx0MiNT?=
 =?us-ascii?Q?oLAtdy6ozI8e2znEecunR1lQ9OwE/AOEK/bLa1Yr+f7rnCki0oCSpexd1Pdo?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SsFPmZ2cnA+hpH9VyhBflJ7VQEc3OeNpmDbR4ospmBsyvGka01XXVAUh4DBbMCPAbuUAFtb2tU8GvPHY/1TZhNKCvoFb5iNrm/iI8i3EomnXOYA2npPvzwWiHv5I5ODz1V0tDXUtk5SkyJ5IpZtpqggqENpXgtGPXQMf+EvXYi4JhzBjBKk+tXJfq0jKRACRCBQbGfnTMUkWvJnn0VxDZO+U5gEy25lgndYPbBRb4ytqI88UAYkK1Lv75uo2rglkhefqz2vvvjfOL7300pHD6DOTiWqee1/bOiwjFK7rlVH86BWFtOK+lCnKTVb8EwM5lBU9Sm1ew7mRRiThxt7L2HkEtbMYbyAk06UVL3Cd71HCZ48NVPghBJe6PT0w9bUU5txLDgBGlRyYlNzIDkXwGL15/XTY62Eu9tCkkLt8hYGUhyFlonTyv9PytxabkYHcx4rGgzqpQ0/zDTnA0i24iCj8YfdpVERLdyw3kQh6gJ6C1/8nm+pIJuJ1qrUbEIpwLqOl13r2ZlILoHUmbhoVgbevpORJ46cqdIH5mlCG4MtaoVJoYoJ8+Zf4ph6hvB9ANK0Y1cgY0iUVbnoCVpKXzDCYnrOllqKkUmiPRC2ePjM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e79c865-a351-4cfc-ad95-08de0fc4cfe9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 10:38:31.2077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptteQG37c04m8le+1HJ//O+TbYrQEO50iZAkYLJX8nOuiSSrLiCFTllxaygBtsB2mzt/F60lnb+yA3rGi+BgIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX5GNfPfmQZOkZ
 XwJxAXZJE1c/Y3aJ7tPTwMyAKQpjYSDmFOyX2v5gSXglwj9g2YbgARn0t4Xtr37ypNRnRb08rU/
 Ys7h0aDkb8sxzvJL7i6TYi+oKOYbug7AhjTuKRCosho3oObe225ZfDynlfWpY7djjVKGhoH+s8T
 P2RTZ4mVoExFhOde/3qq6hT/eutzi352vBnL5X6RQnCNILDnpUo3t9TojMfu4uTetkxhSmRi/Qb
 bZ9r8JyLHMl9jH5kgsOihTH5NeOwld+t/A6WCTwwW9dMU6GMr3zd7EvLz5qzD/AiWTJWTxJo6av
 FTTPrO52/U1cRGbG/Bi3tNAVvd8hbg9Me2FrNwmcFgEQBzfONqpnctVCWxVu2LK3nynNxagPZSJ
 KiSh8QWxP4MwRCg9aplfzxq7daKsatlYQdSD/U5X3RvWzQOw7rg=
X-Proofpoint-ORIG-GUID: sj3gAkD7561bgm9dEpJo8F4ET2qX3SFK
X-Proofpoint-GUID: sj3gAkD7561bgm9dEpJo8F4ET2qX3SFK
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f6112a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=CwEbvQVFxUf5aZh4TjcA:9 cc=ntf awl=host:12091

From: Mike Christie <michael.christie@oracle.com>

This adds a helper function that sets up the atomic value based on a
block_device similar to what we do for unmap.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
jpg: Set atomic alignment, drop atomic_supported reference
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/target/target_core_device.c  | 17 +++++++++++++++++
 include/target/target_core_backend.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 83fe3d9a9681c..39a2d9c3eb9e1 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -840,6 +840,23 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	return NULL;
 }
 
+void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
+					     struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	int block_size = bdev_logical_block_size(bdev);
+
+	if (!bdev_can_atomic_write(bdev))
+		return;
+
+	attrib->atomic_max_len = queue_atomic_write_max_bytes(q) / block_size;
+	attrib->atomic_granularity = attrib->atomic_alignment =
+		queue_atomic_write_unit_min_bytes(q) / block_size;
+	attrib->atomic_max_with_boundary = 0;
+	attrib->atomic_max_boundary = 0;
+}
+EXPORT_SYMBOL_GPL(target_configure_write_atomic_from_bdev);
+
 /*
  * Check if the underlying struct block_device supports discard and if yes
  * configure the UNMAP parameters.
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index d394306f8f490..e32de80854b6a 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -123,6 +123,8 @@ bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
 				      struct block_device *bdev);
+void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
+					     struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.43.5

