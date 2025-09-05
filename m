Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286172F747F;
	Fri,  5 Sep 2025 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058909; cv=fail; b=e/x9Xe3yxsJBl3k2/NWmAlWFiEgwODJaNKeLMMixY8KKavv4dhySJCVgb6h8B77qhOknFp2GUL6x7+J9K/fw+kXyWdqbkGJ++qQsfmRJvXmMN7LLNOO4SZgxv+Lut5bMjybWemGr8mfPfBIWo9UU88Z+RXUUfIQWZ9nBVLtAb/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058909; c=relaxed/simple;
	bh=+3vM5rtS8Z/HD+7wtGgghP50yhJPE0qHihRnY601wzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DyZWxbmIfFE+yJfhHBmZsA84tiShGRVuUV1U9gYQy1294ZhDbfT5C7hWeasgG+1OWJHzHx+iWUwt7EnNus7V3weGlhScbboDu1lcPd6ZQVvH8gdcGve7DPidsDeCeZSTMJ3syrsU0SnH7IhlTqCOZyTQrfghKJooAc3Kwgher80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=PeqQxIVB; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="PeqQxIVB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aTdYkbOdEqcw2y+ZKO3iKeZj3hgEtacSe+xktDIfvhNGEm3Bcx0DzV8HWT/CcssVrBk+2Q5B6Pv6M7vskyE9BrXQgM3hJDW2gzB3+iNAG0nHJ4EGfUuYKHy4h3O6kkf5KbEOCPGJwSN2PkygW5Wj55T0SXnMP72GQS2CuhrjIB9/h+uaqsxDdu4D9i/y7fSKLQi4gNSaaDFGdaAs9y4q6Rq41BzSNycN3eri0ID66vbEpWrWiUjlj3J7w+wxXCRlwQx/cGmAeU6isM42afMP5pxfPvAlyP20WeVKg31gvNbr8YimsD0arFUQv2uj/ADwgLEpXSbOCuUtQSJ4lBXNdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x+3pEK6LVlneBZMslM0iQKiIEQJQxObFuQDl91H1SI=;
 b=eZQ00WQQZAzJTIDv7ZqE4HEjtj38vQTl7MDXsO4m4xBoAU9WPPInQyJcvao7EEFd8tQk56ogXUImHyOS9aBWi2nXeRLFFz8pwCO3ee4fovz2CNn0a7+81AP+O5NOZyIjyy9Y69RM9vWocGDxX7HVjpGMxwwZj850o4Ob3WGxrRsgzJPrGoMQMMcRUb6N9nZ+rVCWjCSGTuLBR4JJ4JVAi/YOCf2yxo3DXbetj7NHFbJW93FhTwWezYRH+pPneCyspFDlbxOOWWjyZmXJZFk72l4pRbNHK3X+cmdvGo3yeqILtiaOgHMeeeTTovcfAKUAGM3+yWNAlDESwdKvs3rdvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1x+3pEK6LVlneBZMslM0iQKiIEQJQxObFuQDl91H1SI=;
 b=PeqQxIVBbVpBrJf0C9pSZ4u+f7+zanuZUKtKra5hgjX9UQIAJyyF+QI+iST1SypsroYHykNReH/dS9XdIGZgfZhB6eVF25S5qcljfKb8e5HcjpseTWu56mF7aiZkyQkKmnKkSTfbI57pQgOLXbz6nj8udQtFmvpdQc7jUBXmEyhjyu8s6cPZHVCnjdTATenbvYV9rOjvHH9fr/d5j6tQSK0y4ci28Rj1m9xwd+ZkrHi4XJeocAYonlE6UbcNfiM5ojOfe2vNEmuuD2U3Z3YhRtGPsXsurRhW0L8guFE4ep/CyGH5I/bCNyK+0h5Uelso97kc+KF6RvNOgCm8WN+aWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB7282.apcprd06.prod.outlook.com (2603:1096:405:a1::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 07:55:04 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 07:55:04 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER,blamed_fixes:1/1=100%),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	himanshu.madhani@oracle.com,
	Quinn Tran <qutran@marvell.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 2/3] scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()
Date: Fri,  5 Sep 2025 15:54:44 +0800
Message-Id: <20250905075446.381139-3-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250905075446.381139-1-rongqianfeng@vivo.com>
References: <20250905075446.381139-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0244.apcprd06.prod.outlook.com
 (2603:1096:4:ac::28) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB7282:EE_
X-MS-Office365-Filtering-Correlation-Id: ccd9335b-1ad8-4829-d575-08ddec518616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nuHYr5Bsy06gNmbDy9tDM4lvUEY8o70B7g7s9US7LjJXN/F48YhlIj+3tEu+?=
 =?us-ascii?Q?4rUYWVer0S+TxX00y2ZucqcrLEiPm8ZpsTMBTCEFzw7CUw9vAhqDKn6udurM?=
 =?us-ascii?Q?1gd4nXhY4HDMEMhIQCiW/Vb7GRWdhkYa08ju6JEcHT7Ny+Zcq6V4kYfwKNRX?=
 =?us-ascii?Q?qz3iZxWbv0o7oKmNU1Vl8P1z4XVBoA0RFtj+IJyWbnNySjAnQP/tuPIehRwS?=
 =?us-ascii?Q?eqhWsCUdSOxkdu+jK2j1gpu2sLgPBn0ZUZhyLDXTNgc1WdN0A+I8+RmIuvDJ?=
 =?us-ascii?Q?e238RfTlfIAbC1eceiILitcTgEWzUbSZArcM2H8wQoIhn+u1TruzCbFOASnX?=
 =?us-ascii?Q?olpZq/I7j5D+aitu3WJ37L/j/sIeuvCYhsMTWFWbFXKdR+Qa0YalL/3yuhkV?=
 =?us-ascii?Q?yQPwTu9GUufTUoWAnucfUt9EPQmnDLr4MTse1YCH/yq1DPFm7zcUP3AZLOzX?=
 =?us-ascii?Q?30LfFKrVG3ImStcJd78fJVtl4mIK1I9jjfAGrRt7HQmIB8vv1AqJc/3jEe8Z?=
 =?us-ascii?Q?hYPz/6UWuKPAUXf3C+6OFn/8qjDJfxBziZvrJt+EHDiuwsMkqu/OjSnbQ3cC?=
 =?us-ascii?Q?Afargguz8FGOPV8q7JAFfUbhHKqik3EmTaSxzhbDlXA77EQKGiZ+6J5KNt/J?=
 =?us-ascii?Q?3ANfsc3mQSBobgnPH8DWGTYbMY8v+ESLWzhgg36QkDNfBhHc06XTVPYQCr0I?=
 =?us-ascii?Q?YwNw4vttZlnERwWy03hZwzcAyK/vuc1dNiLetdXX55vXIAdN1qaMWOmnKD0B?=
 =?us-ascii?Q?l+ZOhYFRr6uk6x8+wMTqaxb6mltA1dPipVwzfL7f4xApeHBKFtyhEqGuXbpX?=
 =?us-ascii?Q?d3T2VcyvPl+N5/fBCyENJLvBVJ6AgxwwPvqKJ2DKxc8xs9ra172+j861hsvG?=
 =?us-ascii?Q?4y6Kj2gG7SwxMlXsKhP0T1qdMJwwGcJDFICnjxK1XDcaLIB/UuSqh78BWkFb?=
 =?us-ascii?Q?F2PKOQXAb95lpZI4Wvxrl/fqCAtYdLlC7wJDFuxUWxnZcOwV4Arm6Q3l/8pO?=
 =?us-ascii?Q?QuMDALCwfiUzB2H/19Pk7TpZ4m1FEin2bwptJShtuIZIH+Vq4A185DPiK+sL?=
 =?us-ascii?Q?yp99LBe5fmr0XToP4pEsCQJN9IF7lz0wAAzScwrct/q8YQcGay/b2+is0x/s?=
 =?us-ascii?Q?8/wv7WToNQCwSBCnczaSWI0MBu91cPQH52khetOYMhcyHZ5+9D6TD90d+ijB?=
 =?us-ascii?Q?lNOqGv6xk7aX18h3UIrjCiQ2dNntGagAgVmNXxPFOb4T1Ze4sCJcWg7C9xK9?=
 =?us-ascii?Q?I2NT6yJDqrbYs6r0yfVsJhsIPs0emo0qPKhBbniBAcBCR2LouePZQ5UGLLdZ?=
 =?us-ascii?Q?8n00CTCkoHBBYe68+0DFq8D2PJhhF0IXcat2CaqChTNp/lF7C3jsdsDKLBTA?=
 =?us-ascii?Q?qX41bHLMyTK9ck6oJonX+Tp9tZze9PxH262OYo+pCS9sxzTdD+nMO7DgiRS2?=
 =?us-ascii?Q?G6VRQp8MbtYQ5roO2NducTFnBY7l5B0CyHF8lwoPUUmaavkk3qr/ZQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SkEkvjfDsw2XdDDLOMiWKUTT3g/veKKj2m6frk5VsdIvYv2vNn1pioVIUfn3?=
 =?us-ascii?Q?brOvPO3L3gZEuzXrQEmZB5d/r65znsSafVxTeYfxaP6T2usOeg4OpA5FBlMI?=
 =?us-ascii?Q?ZP2MiuTQ46es3y/xwn2ev2LLK2gQw2MOGmoy4Z3e2M1Mk6TTSnSa8uLWVw6J?=
 =?us-ascii?Q?UPsemzGES8apayL5Un6qVjYbXn/h4cJZZ0YwaSNG9z8hdSPoOn7wfz3r5YXz?=
 =?us-ascii?Q?Uj1uaHvzLdamvVOinOB0BmcZfoLgHtvddOGgMwbWmhWmr+H5qO76wWYY8zL6?=
 =?us-ascii?Q?WKV7eMvuoBq6OW6Px01nsIh/qLNcwaxS4QfvJOmvHfqcxWPapcA960cSJTD3?=
 =?us-ascii?Q?5/UWX9psS/iFEyPsQONeKXcNbqW2aGGBz98uy+BkJSs6XeoTxEmcMkdsnVg5?=
 =?us-ascii?Q?wWfWhy7k5+veJJwxS3trGVxUt7mk4gLQLKnsJbxXkdrz6X/cZhB/u6ttmqux?=
 =?us-ascii?Q?sWDyHjhOQK2852NYlE32KAQ58D5+WIr71aoi2PQvXBjfi5gKDDeLPoKZjD1F?=
 =?us-ascii?Q?l0wOcOvR6aYocC8Fuc/ugHO6H7F51WRreJAR2m0UfU5YhBvfj+6lVcCpNUQC?=
 =?us-ascii?Q?YsEzW8lgIshgIHFV0h9DRRxZHrF/UA62qGvt8xvDRSh/N+15Ij13K7eF3+eE?=
 =?us-ascii?Q?l+s6BhVzo3ksqRIGY+wGZ073UT32Ry50fulGoyGkf2srbQdxfCbZ/81DInSF?=
 =?us-ascii?Q?07jluzwG1kGUq25+6eS5YagsGJeuiU/jnE4cj95cohhHgP1mpWkjMgcBkcwn?=
 =?us-ascii?Q?uZ2gLKf8xIrtijsE9LcaI7NTCQiczaIidF3TSpfnbTDtXn4YnI3QZwibgPU4?=
 =?us-ascii?Q?KdINJVIKz8SOjcAoJOTXBwzOXFkC9E1Mabw0aomh6ovQUOHNdtk+xrOEJdtH?=
 =?us-ascii?Q?owfCkcdI+4pEoAGJxj4lPNid8NGAd/vX59EQs07z6sNDhMwzRAivBVbx00Pw?=
 =?us-ascii?Q?drmCTS0sdZ1PJR9JNjm8sh5N2E6JU1/J1lWMHN+jwEiAjMVSg0sZo4CtPw76?=
 =?us-ascii?Q?mb8vRVFpBerkQmdfaTYMnGnv22ZOELa38p2uDinBUnL9Bn7iQi0H4vmnIKPE?=
 =?us-ascii?Q?AhMSNpbTXwsaGNfxA/NX0AgdT0bTANdWcYm6kePSU9ldSuPkF88kN5DrpX5C?=
 =?us-ascii?Q?XrKZj58mII8d+ZNVBJMQlIPDIXsGASNwBNH9sLiWugoTjUHBhUZcm8Jrt1Tm?=
 =?us-ascii?Q?x8zvvrumo5JObLg43yP+e9YIUz2QSsJVCaCu5NNK9yUD5cjZ4KofJdM89DFy?=
 =?us-ascii?Q?g8ZLOVKgXtB2pxITk1oXe3EtHpCVffHgh+7JA5C6YckzNo92CKmmi24A3IOu?=
 =?us-ascii?Q?wqT6iIl/f4Dm/UIOkp3MODxJzZckQLiwZCUu3AsQXl2HCBrUJnPj4wBgvkjy?=
 =?us-ascii?Q?LshhvInT2c94UqjF+cq7qms9HcI7hrxcvVBwwhgMYs9kAScQPvABcHb4+v5a?=
 =?us-ascii?Q?YlZdrHu+S+9Jc1ALnLBWxEWKNFcUl79Xd8sgbshYZTqlqLXKjOeTZHmVH5GT?=
 =?us-ascii?Q?5KjtOyouqz1wLV+z4qbzcDchPF+edHfaRBhB3gse/dLpFDUmqxMQcU7PMZXX?=
 =?us-ascii?Q?7Qkv9IzH2J+XFgASOUKv5efHJQy22L7iz3lwVjxz?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd9335b-1ad8-4829-d575-08ddec518616
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 07:55:04.4203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uKkkwG5Is1fMmEsjSTz0BDH9T3cchc6VdD1fTrxLuaNZcROdXdq06XPlescLpV4PyONXeYnpCZ/pJO7/DI6iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB7282

Change the error code EAGAIN to -EAGAIN in START_SP_W_RETRIES() to align
with qla2x00_start_sp() returning negative error codes or QLA_SUCCESS,
preventing logical errors.  Additionally, the '_rval' variable should
store negative error codes to conform to Linux kernel error code
conventions.

Fixes: 9803fb5d2759 ("scsi: qla2xxx: Fix task management cmd failure")
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index be211ff22acb..6a2e1c7fd125 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2059,11 +2059,11 @@ static void qla_marker_sp_done(srb_t *sp, int res)
 	int cnt = 5; \
 	do { \
 		if (_chip_gen != sp->vha->hw->chip_reset || _login_gen != sp->fcport->login_gen) {\
-			_rval = EINVAL; \
+			_rval = -EINVAL; \
 			break; \
 		} \
 		_rval = qla2x00_start_sp(_sp); \
-		if (_rval == EAGAIN) \
+		if (_rval == -EAGAIN) \
 			msleep(1); \
 		else \
 			break; \
-- 
2.34.1

