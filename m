Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2054.outbound.protection.outlook.com [40.107.215.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A892F5A;
	Wed,  2 Apr 2025 07:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743580651; cv=fail; b=QLJvAjsEslK/8gxM1oM6Uhhici2OtWMqzPunNoAWUNiBJHMCvfa25F2XZ2tCYCK6bZ7rGZu/kmc8Jklk3oUyP5C8r3LV6/zAR+LjJp1Ouh59oxX0F4/pnltOn0fzmXSXwtF6vB7xXgsvIbXz9x28l0T2pWxm3bXjyhqkq40OuZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743580651; c=relaxed/simple;
	bh=Prxtc9VHRM5f8uAtf4rwNDiM2Z2kp194iM7NQhdH/yk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NUX/3IPe78G/r34W5qmMnwNGznLP8Ft0NKPsxgyue184EYMWJ5MZhVPJnSfDKH577eUokPTyGvFrCD+nRT7Ku3QzFMy8QAu9XG/Q/aFBGy4UmZaYUEDCJ6TNESIj0P8wI1336mNVEQ3wMki8aqEgBun6gOPKnyhwjtuCu3X8nDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=MsqVPWOR; arc=fail smtp.client-ip=40.107.215.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="MsqVPWOR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+3EfyXq/ctkZhkn9Q+Lemf16XU109kosZT46uwFgzdJLyZA7JIo9PBLjhhaq6P60iJRMz8SrW7f0jWYVSv5WNGGkvMpKS7WDeD7gIFaPwMZF6wNCM+EqBtm8gbWWqK/Ocz/GEBPx5WnmZKTeC5Cmo/pgTJBVhzWDMPIzmVE8ZlauvkrRWJ77SZUOCjMSq3tgF0l4hbQq3ArLh/fDHydkwpihZuPrsJsdaSOJYsRxQlToo9Lq1x1xwV4l3wYkVGSYxmn0aBfayi2/j5YJCMJy4NWKuc4h9wOhRpMFaf1BD7M1FdIzdRVQ8Fpi8SRFG+ZYj5pWFB0JpuBqIZsG6JiNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBWRQe++qFcL+QaM6LOy6DDK1YnzHYoqmUZWcwqan90=;
 b=SAbMeKwRuQVnBByM2bJjKkI3j/9aaBy5efKS1Cm2CuD47Ev0obshBsKd10ywf8A5DWBGCvNtwumtQDWhpVTi8JTFGd2Qe0oGF4LZNEXFPbqrZlxRFn3jngcrthyge5qSRt8sBHdO1B0rK3Ihf5ZL7P65kqPFPFn1Wm67ZkhI9VGgAUG0BFoADDGi8HJ2wGVZw0qIdG+uhz+AbIhCFMDhefsJri4pL5rWXzA/LM7tgeDQyMjmWs7Q3w0Q2B/t1ye5mE000nOrnvJ8FumdqsHLYRwdbHVuzQm5xYjBdU4eIPPf05fSmUksn2HWEIAIcGwVIX4R4CrkhXGtCB5FglwgHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBWRQe++qFcL+QaM6LOy6DDK1YnzHYoqmUZWcwqan90=;
 b=MsqVPWORbTRYTiqZd/AgtlxTUl5YjBtrgqPJ1fzEcueKL/51RiX+A6FknlZyjMVkHSpNA+Hjz5myR5oHvotLWFFg1TB06+2fQ7IU2uv0m5xd1bc8+DLZd4yfqI9Rq1yd95+V6jvWBO7sEpF5BZvwrqBMQK6BtBBDDoGk372RCAwRrdiWKr786Qt3Eyt6Ff0CvE+85lBVcJbKEzHZEENfaVEz2AwUbk8utmaxwUsyMsaBCyyPfYk1Xpwtoj9WVEC0FR0lU5HsNpmUR2LtjG/Ql3WtJd/F5Q1oMQwq6NsXiyw4NK4qxT2OgovJ3x5xRQNwuP3xMSC+Q3wGdDhWjVcllg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com (2603:1096:101:139::12)
 by PUZPR06MB6029.apcprd06.prod.outlook.com (2603:1096:301:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 07:57:23 +0000
Received: from SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a]) by SEYPR06MB6279.apcprd06.prod.outlook.com
 ([fe80::9739:7ad:7a3a:b06a%6]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 07:57:23 +0000
From: Huan Tang <tanghuan@vivo.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	beanhuo@micron.com,
	luhongfei@vivo.com,
	quic_cang@quicinc.com,
	keosung.park@samsung.com,
	viro@zeniv.linux.org.uk,
	quic_mnaresh@quicinc.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	quic_nguyenb@quicinc.com,
	linux@weissschuh.net,
	ebiggers@google.com,
	minwoo.im@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH v8] ufs: core: Add WB buffer resize support
Date: Wed,  2 Apr 2025 15:57:10 +0800
Message-Id: <20250402075710.224-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0138.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::18) To SEYPR06MB6279.apcprd06.prod.outlook.com
 (2603:1096:101:139::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR06MB6279:EE_|PUZPR06MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: a16e61d9-37c1-480f-a41a-08dd71bc004f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|366016|7416014|376014|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Oq0uKaVunQBqQeJSCf/j2Vov2o2kpXt+nWG0mhPo/mTdGH+ij1SeAHTPpWdM?=
 =?us-ascii?Q?h7gjJxarS7ET/3WBQHnrpq9VY+oYpJDh5gD4PpJ5NUlAkvDnWHtOqSj286vb?=
 =?us-ascii?Q?BrLgbEsRLduyUJykp42v9Hl81XHqB1MEqd2L0KLHC/G81q0ZZTBNlFftsnWx?=
 =?us-ascii?Q?yZFtzoCCUxyf8tMAIy8a519RXo3ey4MgfqMtpM3xDMR8a/0vzQaHK12Beehj?=
 =?us-ascii?Q?J6gebf0yAGAqf03UkusX6X3esSBLZ4hExCrbIAc1XGTmEspd9DnCr+uqExrM?=
 =?us-ascii?Q?2spvWtxyIuGJj97A9irUkZd/ONhdmb9YtOBnxWqfpWwVcrC6GXyFzLYx3E0i?=
 =?us-ascii?Q?4d0Qnsc1HU195atRUyymf4KmFvoQ88EiuitF7i8yjQT5w87bJ2dTO0habvJX?=
 =?us-ascii?Q?82AE2dQnUTvuHM3puMfnJIlGxzUi+QSUsMKX//wX4y+4sgNJlO0+YfKNJYOz?=
 =?us-ascii?Q?mPMJRwJSdL4HDokpHyGupZH7X4apch0kp05maz/PcVSDJqRIFULaWiHHakS2?=
 =?us-ascii?Q?T0rDvjvxNgS3fiKALUfq+Dx5/jrn9Lf7zk6cPsZADTuq0HHrZnGVzzVIDEx6?=
 =?us-ascii?Q?C3pl5DwT3rzR5r/7A26veYwUdo7EmmELoCT5ZcnMBj5E/uIDmpvPbScqqzFC?=
 =?us-ascii?Q?OyIHnODSecBHyPyahGKyjFQ580LMZCaOmpjgTdD2fJ4zfUgVMCtvJopB+Id9?=
 =?us-ascii?Q?5kEQ+0weTB4qXdX3fLi7L5+MQCmelcPfIJCopcT2wbqwGGTccAT4WTfH3R+4?=
 =?us-ascii?Q?Wq0d42I3HlsVDEVZTLZUp1AIHq9alHSw4J+lz9IXytVw9jBKlq6L83swWOkT?=
 =?us-ascii?Q?HBsrE9VP34MYGaZXa94SdMT5MdkTYgdYMyJQPKf2o5ZXza234VV5oh62ua1R?=
 =?us-ascii?Q?X12UZOgZyizRNk+HtZJSpjbdAOuR4zwVmRCMGZWiEID75gAQb8GWxT92vvxX?=
 =?us-ascii?Q?0ASEZE2iPmWvfDRxh3curbxaVV7NhZjFc6ieo2+QJ845DiFSXVVJRvjBTTvW?=
 =?us-ascii?Q?ZQI8mUtY16neIoiPu3nkcrQyxHJsxbXPM1bwMNSRZnbfoySRU3sahFUkItZ8?=
 =?us-ascii?Q?2+x4O249dSHuHzho8oeDgFXmQ5C86iByG/Yd9YmH98q70YTKMCq90PL3qUhx?=
 =?us-ascii?Q?T6GaWvF7wF339UawhRczSFtCQFX5KonzBeMJ7Utf9TnuHoorUQpDh4V90acN?=
 =?us-ascii?Q?Idtcf8UznoO3Vah+ouYAUpqEMT8QVWnr4TbRjNOxwoSfgtst+3PqvVJwEQ0m?=
 =?us-ascii?Q?LxuZWmxcVgKa/qU66fL4KVJS8Wr8xkaJuSoVIQE3IneZGAaYFC3OkrfYl6my?=
 =?us-ascii?Q?3DEM7ELYoZmRxYAX661V/ENJEpOH7QdiixhCR7kLgp3LTxr+hGwwp+MpNB8b?=
 =?us-ascii?Q?87tLnXks2Ge/bDf7N2aGgN/pXUVnbNNGX3NqXABZppBq7f576X0I1gtVVI+q?=
 =?us-ascii?Q?1HXv2NqDv0lovBqQ6enlYVsvSOCrjwCqRzPrEN6ELPMiFKal2Cx+yg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEYPR06MB6279.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(366016)(7416014)(376014)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9x8HZsriClLkqrori2YPD4LH+fWD/O+nrSGPhLTAuCKLRYZ9N8mGK6hDzpc9?=
 =?us-ascii?Q?q/dONsD397ROjzsCZKv6BkyITVvKJEZkzVnC3D4ydzs0FaS+VGOh5lWvNovJ?=
 =?us-ascii?Q?m0k2HADxyFF6QVTx94eTjxK2xqPov45Yv+003lLBMdJG9c8T8zPWGlPULVNh?=
 =?us-ascii?Q?49swOL6WSEj5Z46ipDM3PLufo8lF0U8BOxZ1aDG+iaRCudG1OSDIYCnLr8PU?=
 =?us-ascii?Q?+ri7yrwzFPq8A6r+nG6sa6K8f41H7kC9nleZyvb/NARZC6Pph4up3JZCqlg/?=
 =?us-ascii?Q?O2SZxa2tYG0vQ0eR5dlLVpdKjmD5k0pSS/aQh4TtAJKCedU/y342/zV/PHvj?=
 =?us-ascii?Q?ghmuspcGHuakASSMFjaTWhISOOrAAhzz5G6qyGG+pmbl9H/IGdy70MXEfZVa?=
 =?us-ascii?Q?qQ9rqsB1kojetY3L20/dGNGEv6M7pyhzX5wXYtNGkute0lLCjeUIo/dH90Br?=
 =?us-ascii?Q?K5ORJJWYrCJ+f+6Nyi7utdfXig77wBsI57B3BA+srWSrE/JQYkFehBLz4P40?=
 =?us-ascii?Q?dbwSxKnhQBeMG0TyT2T91y7JHWtjqSA8I8X4sT8SbxRmGToCkpsaf7W/Nh4U?=
 =?us-ascii?Q?XhdmARN20ii49lloqhC/V1memn4oxyHnHRuOYGt1oo9Q4zddSyxlOAFhJZDn?=
 =?us-ascii?Q?8/A4igiwRXpwZ0nG6HlA3VX2n/if5XEWPC0pPbqtBpLBcLEp7PKXTH84lWD3?=
 =?us-ascii?Q?+QAwOYsaUV4jbHb36sHsVmvmRhVDClIWWgJcxiv9DXY5Aog4xHr57x/Qy8IS?=
 =?us-ascii?Q?9WN3LqmfhVWjngeZa/VMKMvLIsGAaso57e+eV2sw3IaJ8UhNUQ4T66f8anTW?=
 =?us-ascii?Q?j9Jnwf/NnY/wpsqVM40TvB4EGzOkU/p2u2oc0cHa4VgSH69GU8l5zbJD4oyq?=
 =?us-ascii?Q?wOFg3FZvrUCy/f7Hv8k32S7mYZRj/jakssVoe3DA3ZMRGfeX63dv0SvfPf1y?=
 =?us-ascii?Q?jjTqKjP6JV0n5U7gqDE5H/GW4hzjVk1tK1QBnfbCRoY1hycpJ1l4cN/cvdpy?=
 =?us-ascii?Q?ecQvEJ/SdFA09ifTu4HzNuHGD/cmljM7QDZlVokkcrG5ZNX6r3h0tEiBW5RQ?=
 =?us-ascii?Q?pHw/JdNlodfxows5DqcNXGiqp9OOxCVnV/nj9AJ95fOMYFoQGrv7AdMbgvzd?=
 =?us-ascii?Q?EakeWdurlfJo8LN+gxhby2egRfI3i2emT+Mf99bvr4AhShBHgtjiNjttYomN?=
 =?us-ascii?Q?JC5UzvLsYuFPhs/rQusohPGCDygBTmEJXW4ooS2nGKQqQABk7Xk7cOACJPbP?=
 =?us-ascii?Q?knPOFWDZOatoOZCZhp4jFENhjT3Sj387HuO9VeWX82A00RM7juF2H5WSwnig?=
 =?us-ascii?Q?e7ganJihfn5lt5vHx8BM9J7HqEsRumhor9yfjduIRnLFS9sjAqgpLgeyyMUf?=
 =?us-ascii?Q?cqQLSD44Huaj6tL8zNPLclW+ZyZ59tyTi+PeoErHQs3oLKud3ppAklr2kTbf?=
 =?us-ascii?Q?iXTRjC6Tp9lbia0HMRkwUvzBKa9vT3czDJ4D/FqwktrukNrtZZXWnFyMQXLI?=
 =?us-ascii?Q?OmLNlHQkblrekfJWYQi6j9ql9Qz7f/XIea0g0bWPNoWSHMWksHJJo02TkrDO?=
 =?us-ascii?Q?DYBWjJZKJJ9KczecTygUdAoRrX1HS2UErXrwM25J?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16e61d9-37c1-480f-a41a-08dd71bc004f
X-MS-Exchange-CrossTenant-AuthSource: SEYPR06MB6279.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 07:57:23.1788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mye0uudnaQUTRmTXXQ8/cmy9E2sNrZCBm4Wy1EiPQErp/hjlucJmGqfXaVR8iTUOHSUHvH62U4AjUd5cWNHIng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6029

Follow JESD220G, Support WB buffer resize function through sysfs,=0D
the host can obtain resize hint and resize status, and enable the=0D
resize operation. To achieve this goals, three sysfs nodes have=0D
been added:=0D
	1. wb_resize_enable=0D
	2. wb_resize_hint=0D
	3. wb_resize_status=0D
The detailed definition of the three nodes can be found in the sysfs=0D
documentation.=0D
=0D
Changelog=0D
=3D=3D=3D=0D
v7 - > v8:=0D
	1.Optimized the description in the sysfs-driver-ufs file=0D
	2.Replace uppercase with lowercase, for example: "KEEP" -> "keep"=0D
	3.Fix coding style issues with switch/case statements=0D
 =0D
v6 - > v7:=0D
	1.Use "xxxx_to_string" for string convert=0D
	2.Use uppercase characters, for example: "keep" -> "KEEP"=0D
	3.Resize enable mode support "IDLE"=0D
=0D
v5 - > v6:=0D
	1.Fix mistake: obtain the return value of "sysfs_emit"=0D
=0D
v4 - > v5:=0D
	1.For the three new attributes: use words in sysfs instead of numbers=0D
=0D
v3 - > v4:=0D
	1.modify three attributes name and description in document=0D
	2.add enum wb_resize_en in ufs.h=0D
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c=0D
=0D
v2 - > v3:=0D
	Remove needless code:=0D
	drivers/ufs/core/ufs-sysfs.c:441:2:=0D
	index =3D	ufshcd_wb_get_query_index(hba)=0D
=0D
v1 - > v2:=0D
	Remove unused variable "u8 index",=0D
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'=0D
	set but not used.=0D
=0D
v1=0D
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/=0D
v2=0D
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/=0D
v3=0D
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/=0D
v4=0D
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/=0D
v5=0D
	https://lore.kernel.org/all/20241104134612.178-1-tanghuan@vivo.com/=0D
v6=0D
	https://lore.kernel.org/all/20241104142437.234-1-tanghuan@vivo.com/=0D
v7=0D
	https://lore.kernel.org/all/20250402014536.162-1-tanghuan@vivo.com/=0D
=0D
Signed-off-by: Huan Tang <tanghuan@vivo.com>=0D
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  49 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 140 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  15 +++
 include/ufs/ufs.h                          |  27 +++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 231 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI=
/testing/sysfs-driver-ufs
index ae0191295d29..bddcf48910ed 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,52 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
=20
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
+What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable the WriteBooster buffer resize by setting this
+		attribute.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		idle      There is no resize operation
+		decrease  Decrease WriteBooster buffer size
+		increase  Increase WriteBooster buffer size
+		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_hint
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_resize_hint indicates hint information about which type of resize
+		for	WriteBooster buffer is recommended by the device.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+		keep       Recommend keep the buffer size
+		decrease   Recommend to decrease the buffer size
+		increase   Recommend to increase the buffer size
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the resize operation status of the WriteBooster
+		buffer by reading this attribute.
+
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+		idle              Resize operation is not issued
+		in_progress       Resize operation in progress
+		complete_success  Resize operation completed successfully
+		gerneral_fail     Resize operation general failure
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+
+		The attribute is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..9767fd719243 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -57,6 +57,36 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_gea=
r_tag gear)
 	}
 }
=20
+static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hint)
+{
+	switch (hint) {
+	case WB_RESIZE_HINT_KEEP:
+		return "keep";
+	case WB_RESIZE_HINT_DECREASE:
+		return "decrease";
+	case WB_RESIZE_HINT_INCREASE:
+		return "increase";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *ufs_wb_resize_status_to_string(enum wb_resize_status st=
atus)
+{
+	switch (status) {
+	case WB_RESIZE_STATUS_IDLE:
+		return "idle";
+	case WB_RESIZE_STATUS_IN_PROGRESS:
+		return "in_progress";
+	case WB_RESIZE_STATUS_COMPLETE_SUCCESS:
+		return "complete_success";
+	case WB_RESIZE_STATUS_GENERAL_FAIL:
+		return "gerneral_fail";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -411,6 +441,43 @@ static ssize_t wb_flush_threshold_store(struct device =
*dev,
 	return count;
 }
=20
+static const char * const wb_resize_en_mode[] =3D {
+	[WB_RESIZE_EN_IDLE]		=3D "idle",
+	[WB_RESIZE_EN_DECREASE]		=3D "decrease",
+	[WB_RESIZE_EN_INCREASE]		=3D "increase",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	mode =3D sysfs_match_string(wb_resize_en_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res =3D -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res =3D ufshcd_wb_set_resize_en(hba, (u32)mode);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 /**
  * pm_qos_enable_show - sysfs handler to show pm qos enable value
  * @dev: device associated with the UFS controller
@@ -476,6 +543,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_resize_enable);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
@@ -491,6 +559,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
@@ -1495,6 +1564,75 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn =
idn)
 		idn <=3D QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
=20
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index =3D 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled ||
+		!hba->dev_info.b_presrv_uspc_en)
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+	if (ret)
+		ret =3D -EINVAL;
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		goto out;
+
+	ret =3D sysfs_emit(buf, "%s\n", ufs_wb_resize_hint_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret =3D wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		goto out;
+
+	ret =3D sysfs_emit(buf, "%s\n", ufs_wb_resize_status_to_string(value));
+
+out:
+	return ret;
+}
+
+static DEVICE_ATTR_RO(wb_resize_status);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1568,6 +1706,8 @@ static struct attribute *ufs_sysfs_attributes[] =3D {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83b092cbb864..2c52a654a1f7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6068,6 +6068,21 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, =
bool enable)
 	return ret;
 }
=20
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode)
+{
+	int ret;
+	u8 index;
+
+	index =3D ufshcd_wb_get_query_index(hba);
+	ret =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en_mode);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 						u32 avail_buf)
 {
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..ed971480c329 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       =3D 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    =3D 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        =3D 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	=3D 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		=3D 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	=3D 0x3E,
 };
=20
 /* Descriptor idn for Query requests */
@@ -454,6 +457,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	=3D -1,
 };
=20
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	=3D 0,
+	WB_RESIZE_EN_DECREASE	=3D 1,
+	WB_RESIZE_EN_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	=3D 0,
+	WB_RESIZE_HINT_DECREASE	=3D 1,
+	WB_RESIZE_HINT_INCREASE	=3D 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	           =3D 0,
+	WB_RESIZE_STATUS_IN_PROGRESS       =3D 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS  =3D 2,
+	WB_RESIZE_STATUS_GENERAL_FAIL      =3D 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    =3D 0x00,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f56050ce9445..74086a6cb53f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1471,6 +1471,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *=
hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, u32 en_mode);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
--=20
2.39.0

