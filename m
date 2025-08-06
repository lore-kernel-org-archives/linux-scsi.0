Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013031.outbound.protection.outlook.com [40.107.44.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3BF72602;
	Wed,  6 Aug 2025 12:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754484410; cv=fail; b=PQ44HgtaO1xqojrWhlbPlyIXSEE04n4d/quH6GzbFhXcJ7BYmXKd6xamAD/OoZln85yjbEo0z1TKM+JOXSt/8baZ+88NEeLYL6HFFMEfxPCzORnDDmnKQFP6p9MnTcoysuSdwhFvdMLxGDIPWWOOtoN6t8KulcH7easADtEOS4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754484410; c=relaxed/simple;
	bh=EeEnwZ/8pJbXOYQo8Tf9j25Qfex8HLsNEHfSk7Eu4z0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Og2ffeddqMSetYBb1qtX+uaB7HGatHCgtCLXwPCUKAUHgl4DdgJ5b56Z8tHCW8joGdvOsKnezOqiFX47M7WsuL7eJCMzDHUdKgIz8TQOp9i72nLNd78JLoSEF3y8ng0UFlwQO8XAjtZdvXCn/3ogbT8O6SJbnLxyGoytBucd3SQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=qBJ9qwEf; arc=fail smtp.client-ip=40.107.44.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="qBJ9qwEf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TRpszOGSVssoj1Ot+MgzCsWAh3MiSN8nPQ7MVEx6w6P5aliZ7CTL+mWKjmEIv+2QZY3TVTXZxpk0MZxzm97rEdsAYtqM5nbQowvb0T/fKTn8xSP3sn3Y9OtD7MyTDEJWQZ9xMudpPAH8aZGGn6E7etveEYsSvgqv/Jy2QborI5XILKhynXp5p1C4OQPeweMsyuxp15Zjyzr+/lIvY7AZ0UZ5VPqK7CchGvqgRBNkiQFRRY0HgMmkmll5gKZnw/pPINiYTAWiPbtk4tCQ2ZfFqrd8Dq41p2wQQFC0Z9mJ7msWXAy6tLh4F80tvBEk85b6wi2rxr84btCPOkJiZdSbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvAYTBc4bobBMzRxOBys5jrhrL6Nikf1uDmnhNXbdYk=;
 b=i0kfnfporhzLRHlQt17G1hXqqykoIZwzNVS2fuVXiLCHCFzfdCxcZ2ypPY5crdv9/K0fI+jwnJxR8r5qvX3AqeF7yjjw0R9Nxcj5951CuugDgqVqGQD8Z6LYMkIoDMhwO90+DAt6XtlIxPgqzMDIZWf52g/8l9h710xLRnFVwBl4x38e/r42osSulGlpmzFCXj5T0Xn5u9En3UXKrJcqrSWRLZnl+D/ihIU0+XiKLg9lISJvIhbjduXcf7RsZIK0JxE6Y/1I1VBFCUrSvvruqsPvcvN/d9EeXGwHBCZcIRXOQSo61f7EhFGP8sUnA+taseY+Nmozo5tEDs6Tby8NbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvAYTBc4bobBMzRxOBys5jrhrL6Nikf1uDmnhNXbdYk=;
 b=qBJ9qwEfxjDTEOPpPw4TV9j8Kj1OhK2UzKS4eOfnG9TeZyqj3PutaGBh0feyWArT9GCGAjNIU7O7WIACaJJLRRkhM1xW/ZMIxgoZicRm4Gzy6pTwTES+0B7r5jVXNEI7EbFBlFB2a4dV4rKzmO6TfDPhjtWATyu3kLXw8m0a8aDkOXNW50pTF76fBtE4QAbUZ7ouJLF0XkTM4d6Y7Ia5vKG4mqdyD6JHMMasW1iTFa7f+q/1jU+IgPTm4QOQjTZTCgeelVr+g1sj3sJum/q6aSm0i4FPXgow4n31nIkpK2IJm6Ggad6n9GCR+ujMuBTWF+VbR1AlR01qj3V86jvQUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7283.apcprd06.prod.outlook.com (2603:1096:405:a5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Wed, 6 Aug 2025 12:46:47 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 12:46:47 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: bvanassche@acm.org,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v3 1/2] scsi: ipr: use vmalloc_array to simplify code
Date: Wed,  6 Aug 2025 20:46:32 +0800
Message-Id: <20250806124633.383426-2-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806124633.383426-1-rongqianfeng@vivo.com>
References: <20250806124633.383426-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0045.jpnprd01.prod.outlook.com
 (2603:1096:403:a::15) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7283:EE_
X-MS-Office365-Filtering-Correlation-Id: 5834ac48-1b86-4d59-091b-08ddd4e74e2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SWfelYQYPoXKWKAzE1GJN/pzvLeS9aV3BdE6ux6afIyeCcO3OQBBnEGMJHa9?=
 =?us-ascii?Q?7CplAjo5tUd91+NaGdpyy9cxSevgUPVefEkG7/j93kRneVMuL7pijxEDk0Cj?=
 =?us-ascii?Q?/aqNOxpdK4VBxGJysOuylSGKP4trrw2E/QfyzFrdWU+4QFEcejK/UjOZ+u9U?=
 =?us-ascii?Q?8eSK29hdWV8ruLY0fOVpQHuQmRkGzxhGnaTkw/M+CFjXxVzOYdiDaO/FKR6m?=
 =?us-ascii?Q?U4Gr8HUNHgRydkNvalEWMwPhaxEhkZECZ3bWrOmyQ13bZ34CmZqfe28fAdU1?=
 =?us-ascii?Q?3BNdNg5TqwPsD3e8h1BtaLuICIX6U/pjZbRa1CD82h6EbI5HdMvPLApmhIdo?=
 =?us-ascii?Q?tajGTt1sveao6ZY6Y8JF/YCWRCypNxeV6F5gNn79vGSEV3tiyL/rHbf//ZGL?=
 =?us-ascii?Q?PktnC25FotcdXavmzC0rAduy1WrE8QiaJEleny7gkFiM315kj+sgLrYxwks8?=
 =?us-ascii?Q?D1PQ4k0KSDWShqAyzYSnOriswAOoTdannNqqeWnSsChdIssh/0cO+dBqxFCl?=
 =?us-ascii?Q?JRVZSdKdbDJoqcmep0y3iyHbOxEKdJjfgWc/AwbPdOHXPyvnfSikLlOluSQr?=
 =?us-ascii?Q?PijlfK7lexAt7DgFnw79o7/drLe1mHsLWeZu7Q0pkuPWOTLard13yyD07/mC?=
 =?us-ascii?Q?xvSvNR23LY6sGBkHDTBFUaMndglOvUWkuos3FF0j2oUDalfGa1cxVZw5P146?=
 =?us-ascii?Q?/Ys+DHL+E3xIUkvyIG1Enkmu2FyCew0hapiPR9LLbDqDs/wBasTp5UH3K25z?=
 =?us-ascii?Q?ZG+tB5TGvFyQeiY40TVIsXQx/GrtiMqx6+d43QC7aN1xr/jjFjEqtdMt8sJm?=
 =?us-ascii?Q?w5hctkxnvASPXv3EJbHfsdlk+tIeIu/9CI2/fANuNwR2Azp/gPTq0oiWEl9c?=
 =?us-ascii?Q?ct5NQB0DP0cmatqfQ/315Xi/1fzoTtez9srsK5YhMx5TA/SYt32+zdK9Bcr1?=
 =?us-ascii?Q?Ua/REkBG8+Jdl3HTX8uvEz2ACQj6Z/pTTIxt7A1k2PeRxmhdQpM1brr6mHh2?=
 =?us-ascii?Q?CgAMZkkku1+493aRVpcF8+bt2CCb+O9il35omfPUY38JkfIm3I2hYvk4WI7X?=
 =?us-ascii?Q?NV471qjJmcPKsThERzuwDEoUsGCKlDVDkI16RqOb+Esrc+neyMQQDp8seyOZ?=
 =?us-ascii?Q?faYyNodD4BRJ0SQW2yMpy4cUajVUzApl3PokjAOU0ZJ3VT3TIRN7cWDFuyJg?=
 =?us-ascii?Q?IlOxHOXmE1tsyNQ5Qy1oUB353JaHPHr++UD/kyiGuaph+ilTo8CjzXP8BxUY?=
 =?us-ascii?Q?qfTDfVC5udctJHA+3Vyo9QBzKl53XFW8V1hMOiJWVASnmCfCoqpQeq1dfNSC?=
 =?us-ascii?Q?XoC7JBJeRN2rlYt0AfejGum4ZAVhbW9WjghdkrGx/fbemvgTNgO2jf3qi+ow?=
 =?us-ascii?Q?hzLEGuzZS14LFXWutli6Fb38o4CbJPl4+mDvrJTtj/XHOWpNX0ThTGV5kj8x?=
 =?us-ascii?Q?v4GIuCyNxt5yj1Z2c0dGwAUM0KjzCv48OxYqOf3Vf9Mesqfbt0P9ng=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xt4fSxh3ZbcmZ5jQJytLv/Y3pVr5O76fbqDbjS2aIzPhJNSZxZlHdboSXSN0?=
 =?us-ascii?Q?GtHfNUAARFJpC7Zn5XkS4I0MHEsc1m7I7gcRjWYflFsbt0poqtxvkyWKG1bF?=
 =?us-ascii?Q?9AfQAS/mXuBVKl+GuDhMCjCQfgtCoGKzqcN7+V9syj3gw0QSTlGI1JCWuIdQ?=
 =?us-ascii?Q?giIRXCnbH+UrenyZD0yUnKRbYaYui+OAs0ZQBGpLvvaAwLOBdxOuPc2NUP+t?=
 =?us-ascii?Q?bpeClzTHkxA67bqLsLMqjwldFjnzRAKzgDttNLhaZ0WMjnS1GoyWQbJ0fHNf?=
 =?us-ascii?Q?1e1kO+iie/24+cs1afR/lCpq+Usv0Gf1v3dAJu5BJXU1Bfe77R7wPObyRpdB?=
 =?us-ascii?Q?rjmnYXR/4Z+dZ/VssM9rcB2J2237SMwTbfUm2AkkvlTuvozi7HZJIWrD0kJM?=
 =?us-ascii?Q?ynz5lIZEce/CqDhfdNSgm9zl/Nf7ccMqhT+MIcMjS8pgwe5n48B6ltrXg+Ks?=
 =?us-ascii?Q?5RXxV2sFqZw9lYityuJ2v6IT7H3MXqMy4wnBKHEzrPs+gHZ9WEAXgU2FDQJD?=
 =?us-ascii?Q?aI58rsnLV9A3vR6eXqa7Q9HL8v/8dxhtaMu6fk8iVNBGE1BpdgETaitagw4F?=
 =?us-ascii?Q?DUCsl4AkdrKL/3OixbBVojkYE3mj99x5umonHTsLXpT4rNxRb6zWHhpeRvnI?=
 =?us-ascii?Q?piyK4GFLGeuL3zMoZjJhmG++966XccZujklsv5bfu0ubw27Sd+woLG7bR6Yf?=
 =?us-ascii?Q?rYNrduSt7dNs6mLhhGKbwEY1qISmHjib+tv6fnwrqPjWycUr/jBSb2yKA9oS?=
 =?us-ascii?Q?SwsUrRb3+52l9IFYyFlwKYv4H0z7LkQSXbK1XE/pC5cZtKfMsuLt2OLsG2PL?=
 =?us-ascii?Q?k44SQI14qhGxh+/ghtXPFKWOnjra8x1s3Y4RuAO/AeSIhkDGD/JzObIl3VY/?=
 =?us-ascii?Q?JDisvD6twAug6KvvBQ7YAdxP8hw32J7PzJ2W/gw+HOlnEBPWoKX2CDe5E2HU?=
 =?us-ascii?Q?cOc2jA0Ty72ZSGCpFkPBn6y7F8WcqvWBG+iYeMLryn7UWwJTlOUwBN//y4jM?=
 =?us-ascii?Q?jCL6ZyA8SRRx64DBZxMWI4mvZfRa46gpcxkkTsDI83av58iHaQxekSoQFvMR?=
 =?us-ascii?Q?cr1IWcdnM9Q9vp9lTXUbTuClie6Im3vCQcRTPis5uQx3mUG4vtrTYRtRG8xg?=
 =?us-ascii?Q?qodkhtVHqDokLHDEcLtSyHvAnp6tgYhXFvTWPaZ0+d50Tya07Z34vyJOwX7o?=
 =?us-ascii?Q?1jvaV7/sff2rLYvjXki+9lGBw28Dg3l7nZcUC5CfxCPVxW13bGMfYGgUd+pN?=
 =?us-ascii?Q?NV3SWUFbVbXHqVAdBw9arRJCqvPBW2zdV1+ILm3Ti6NjpcapHWA+7MdtF38C?=
 =?us-ascii?Q?EjlJ7a3eAISrg27kEy77sxATy22Ept5aLZKkh4qAop6RedfaccuhdRUqUmOx?=
 =?us-ascii?Q?HYQ+YA01Oe9t5cTfJCCZm46Sm6GExOcsSSvrQRcP7E4lyYBArLIWhHy1TrZU?=
 =?us-ascii?Q?wffC+cz8TAgago8C3YOLsmLwI1skqDOXld1LLTXnyZUznObCj9681/g8mOdZ?=
 =?us-ascii?Q?m5ns/8Q2tLASH3+lHi71aqeJVPT0QeJGuomz0bCw/yYkugfA9A8lb2LSbGSc?=
 =?us-ascii?Q?DJukcC+Hw0tug88scfBMG2axGDO3Dgf5p0/1qqYy?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5834ac48-1b86-4d59-091b-08ddd4e74e2e
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 12:46:47.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2vya71sDE2TlCTZgWp++HlRIxGr2rH5W/kspfohijtvoHFwi4g851DtoH3TYh5M/GetjqYDNqx19NKpfx1FtLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7283

Use vmalloc_array() instead of vmalloc() to simplify the function
ipr_alloc_dump().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/ipr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d06b79f03538..4fb5654472d8 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4281,11 +4281,11 @@ static int ipr_alloc_dump(struct ipr_ioa_cfg *ioa_cfg)
 	}
 
 	if (ioa_cfg->sis64)
-		ioa_data = vmalloc(array_size(IPR_FMT3_MAX_NUM_DUMP_PAGES,
-					      sizeof(__be32 *)));
+		ioa_data = vmalloc_array(IPR_FMT3_MAX_NUM_DUMP_PAGES,
+					 sizeof(__be32 *));
 	else
-		ioa_data = vmalloc(array_size(IPR_FMT2_MAX_NUM_DUMP_PAGES,
-					      sizeof(__be32 *)));
+		ioa_data = vmalloc_array(IPR_FMT2_MAX_NUM_DUMP_PAGES,
+					 sizeof(__be32 *));
 
 	if (!ioa_data) {
 		ipr_err("Dump memory allocation failed\n");
-- 
2.34.1

