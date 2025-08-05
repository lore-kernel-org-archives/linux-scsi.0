Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012014.outbound.protection.outlook.com [40.107.75.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80BF1C1F22;
	Tue,  5 Aug 2025 02:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754360816; cv=fail; b=qYn1cA1uLchGk7tijbYLvkh3uAl77i/uxdiF76l6XRfVtBxLYKn0VX3/zZKmhCQJ3YVKC5vuxBqLzSLyhUoextN0NGzBMsKfoc/EPGhLByR08cOR3tgG39w7DV03h/mW9kpd5wdWL22dbt/u4M7GfnLgBq/HK7jQVhuSAguuAao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754360816; c=relaxed/simple;
	bh=s5aPGHc+ePGZCSql3WsVVFpC3gJCAjtr7X5rnQGTQjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sdh9+2xpVIkuuDY996wySu4vsACB+IJPAqo6D9+egBUjxTMvMt9+5O+Q6dTfYgrHFEuSwKTVMUhpHscZqgLBfXbaHjnl2ZSnjJpCVqz8vOif4AAMVrxHdtGigUSNUS6N5uBJWdHlLRjU9qMaO5o2oTpN8iJCNeq6D61G5d0Wd4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=KthcRWfk; arc=fail smtp.client-ip=40.107.75.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="KthcRWfk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EwsH5/cPKWR2BJ+lM6BsQZSWdSisbHa3sv1oxssVE4g6I4Qtdh3kgUlgSB0VuO9NYXp+dGc2yEeKFDihGW0TCKzzxQ5M3TcbyEqnV3OGScoeu2oFYGFPcQoe8e/u+qJbk1akZtiPAFI9DNCR+oRGB+Goyjq5qfXuSu3U+kN00oiwVsqJM1EbTqD+gtmNgfWmPDYFrXLdXxfaNpndBG9hAMI6hV/zBvdgUOI1r872XNIjVWECP5Cgb+HjGRcOPNSHymkxQBK9UYNnhYdEGsLlAFmyDsBJ6W3iNm6UuxsAHLF9tHWw1hZYcuCxTBfKVi48tKc4VmP410DUkrEtgyfBNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j18R4zG2Hw0f+3uK6nXDslJsoVegrXqtcioxNbmjweE=;
 b=tzA/uiL0ZDgynN2KL6MGOQsm2TiwJ4pEcDHnnGAMoAsaRt0sGceKkk6GegSjHFbZK5fNfFYUO3Rc1Q14ONQTKhBhVLKPqkydRawgnTnoDsLvQEAYSxN9jjQBwx90dUTIdUZbL4ZADAT5jlS44pBje60/A7a0yo+8ORoBdQ/CBLeqtoxqF/O/ftUyaje/TpZTQFpIv0+fw9oqq8myZyQcjR3ku7IUZAJilAjZiQSGpFc5bjrfTHlisPBfljKrmA/1cctwlZ3z8lWuexhSGruChhOAreqLaOr0a7tVtHtGrMWSWHhpyxVub1ctRRSK0f3/OjgupG5IzGHnv+F/dlTSFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j18R4zG2Hw0f+3uK6nXDslJsoVegrXqtcioxNbmjweE=;
 b=KthcRWfkFKtPJgOgKJkAvsTmxmRx1geYUTZ3dkpAq7E92MjCKz7LTFvscyoBqnULCitFg8yEfJMSLTIML5t1IjmHAhX9WnqFsozb3nrPClKIvVWBbDbgchK7FlOfXsH0DQQZYn1BG09kXg8+nTGQGy3juYBStVGzHFBGbdd3gSS/Igo4PU933xa7fODhCrUffZ5Q3kCt6+0AJWJTMI2qVCW3FL+sUd6FjreOR7CpKg75KjS+kgKeIxKbU8eNTAduCDfacq+9fJjK9WRVq7DVfhFw8qO34JiRrS8Iwjcz4C/5AvFOB1Cf5yg7iDJtyE8jNNGcCZEwt1ZhxSbBBXIdyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6588.apcprd06.prod.outlook.com (2603:1096:101:177::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 02:26:50 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 02:26:50 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: bvanassche@acm.org,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v2 1/2] scsi: ipr: Use vmalloc_array to simplify code
Date: Tue,  5 Aug 2025 10:26:35 +0800
Message-Id: <20250805022637.329212-2-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805022637.329212-1-rongqianfeng@vivo.com>
References: <20250805022637.329212-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0024.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::11)
 To SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|SEYPR06MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 15a7bfc4-1ec6-458f-a7d5-08ddd3c788ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JiaiuCTk9wk4kehKZDMw0+xHKOtz301y8FhaiItvYlGM0f8ghld11zvs5zme?=
 =?us-ascii?Q?DX85u0ikC2+hr4I+ymvawPV2wtKbjQ+0nwL7Jo5RYQuItveLRnJowEke1zTf?=
 =?us-ascii?Q?f7Kal37pg6YqfPefYSg9hJ5j8AaZzxMSElZ+4mLcXZiKGHrKmuu0wll8u7nO?=
 =?us-ascii?Q?qe8+Ir3gZwiNBknV/E/hGdyIQhk9LypccBgpZ19xXX6b2mM7g9uiClF6/FNd?=
 =?us-ascii?Q?rZk89uvKYLLZesKiWN9PpZvtmHfs3ycdFrLrt7e8bMhNIFKZ0RIMBy0uxaD3?=
 =?us-ascii?Q?c1mYYxiCBJMIpPXQxvauwGbiPQkKQ+/kFLRw1W1townBye5A/MX7wGrG46T8?=
 =?us-ascii?Q?L+LHaq3S3BxeVblV5WUVjaQM9Fv4HAUl6YP+c4m9Hg4wP6KENmyjVuwKsVz0?=
 =?us-ascii?Q?L9RjGvQfFke5vYQOoAZ4R5hErMMx6rTka7ezoewsDXjD/ZaUPYCry16geXGy?=
 =?us-ascii?Q?MW6i5AJyP/2WdgF5EFVDQm5I6MhHkVqqE7pAnsNQYLuKrwTNz8G1eGjrX8D7?=
 =?us-ascii?Q?CFlp+trpWM9CqrGyBd9dq+RpAUqy7L1hBpsOZPIp0BBJs0Jj76f0OfJbUSP8?=
 =?us-ascii?Q?wUztgUlP3VhWO/JJomo9Qjv2r++PoBznYkwH7yMxw5UPM5NfH+/Gsi/O2jNX?=
 =?us-ascii?Q?tVTI/78xqpxVTsg7jwDlANNy8qrsY4Vx30vhtA2QIdair8YplM+wrlIX2Ujq?=
 =?us-ascii?Q?lvy980VoUb1eNVvplW8NAnG64tan6eZJsYCBV7VpCIVIATmwZUmqcte1M/dM?=
 =?us-ascii?Q?zUZ5k1vl+WUZwF/zGyhOtkYNnMXIkpRBDbt6OEM3JRuDLueMChsgiLeXJ+mu?=
 =?us-ascii?Q?zbithTiDyBfWKj785EHBsCvnUrzM9gQH/Yfcmoof/WPKlQihQNBgEdR3zVjY?=
 =?us-ascii?Q?ucEHHyl23iLlMg7qsL5LJGFgVsfFWeSxGcKZKUJnsc2uQ4KAQG1UDF02zRZU?=
 =?us-ascii?Q?2+W9cCxnTvmZiS6sDZAz/GcOIgEOl0zMFhL2At8L384O6pUuX/3CzzR5WBZN?=
 =?us-ascii?Q?oJTCBQAFacWOtBTPmIBLDUBlJs/D2FwuxhqEfBi9AvOV9NrSHiBQbN/HIksg?=
 =?us-ascii?Q?UEC62M7XVFU8+kWhc/F6FIDVDJPDsvknBfTT4YSYK+7CxUjjEXxTitBU4Gc0?=
 =?us-ascii?Q?Cdmkbv1jwhsCYwUqFU0S4gN03EBoijwnDUAkyD2o7wKA4LxpQ8RTCVDOw/4n?=
 =?us-ascii?Q?NI7yiOkUirbJgbr2EFEvicnZM+WfK5WnYMhwTMsBHbln8vNV106TAGLcxTHv?=
 =?us-ascii?Q?XSKdaJe6YTC6vqqJ84dsQ+FoasUi6vjpLsxvHcvhZVB6gFDnglhxdwUabd1r?=
 =?us-ascii?Q?i5/SNaGy8nDDZ76eCi1Eh8Ay7FlzweGLnxKe15frZKYei2pEmCFA8BkDfIvi?=
 =?us-ascii?Q?W6Vaa4QTwmYaRE3iAtgMPcVyKk7qxh/RaO6VmpW48WsSoeiFPBqlN0lY7W8w?=
 =?us-ascii?Q?tONz+X2+Qc/wmNRhQlt2L2pNwuivJSL+kPHIkWEZfC/xDijjDx/S2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZqtJKXzfyUec8tpAxycKsvii/yQ7atPOMRRaKsEtTUV2omXnQwpgyr+trlCf?=
 =?us-ascii?Q?D2thvQy7QsPBvycE+FN9kZ5MKMUG2QrnPATZbUGngcBFdt7O6wqVlnUERy9U?=
 =?us-ascii?Q?HroOA7eLXm6VQ6Hpv/0lgCt0yt6zLKEY04ureYTGrW2F5MK4jWodEs4t3LUP?=
 =?us-ascii?Q?eDK4yuPEQ6nZns82z0V5ePZBEMyTCyJ8msMYBQIawkelbpiiztIAeI+BLpmQ?=
 =?us-ascii?Q?DzDWy6E0CR0Erj7owtAvhPuzseMNM1cMZ+UaHIxo8CBticR8iQx8A+NqTEbl?=
 =?us-ascii?Q?yk+zZh/Brc9/CUql1vJVddS692FpIIqX6U/SyjuVckcOtvI+vXhTETZ04Ipk?=
 =?us-ascii?Q?gfRr45t2ahYxisvaOxBxtNQgotakbwC/zqC33dP+LjXuiURLcyTEPxuiySGB?=
 =?us-ascii?Q?VEdhpwTRb5HPcsb0Nldk7HyWb9QPFc82z1l6gkwOQFHVGxQpYSeTwRmzRQz5?=
 =?us-ascii?Q?1mUIZqaM9BeVQGo/zK/IIVTU7dDTXywq3lKI9oFiZuSxkH2Fqtmr2LdMfSQ8?=
 =?us-ascii?Q?iP00ZyZNPTk9ypLHAYf2TUJ8UL5hlKazJX8yH6Axc1vymtzgO7HECe4VyDBd?=
 =?us-ascii?Q?rYcJL+gYk9JsmVIadlCR6jFYYS674YuXhk6iQbpgNv11fUqxDhcB91W+l7jt?=
 =?us-ascii?Q?agjqC8nXNDKEt1canXQ24kUoR+Ga3cJJc2NeDBxRbYaKfMd9py23WNvAb36i?=
 =?us-ascii?Q?LdjrUbBATPB0m7RHmAHM9XmM4mymRxHz7OlylTlPNnbNfBWjryQ+V7IEjSVD?=
 =?us-ascii?Q?6jfnOqz1rQ/ObujcZEGlPrA8wta0H9afvSLvD3ixl09iDls2okAFo3Y8yrij?=
 =?us-ascii?Q?eN/kKGLMaekEhOJyqgTE6CxDT6Zq8dpIfGN/Flyt98vZjbinqRBU2Px+/NFa?=
 =?us-ascii?Q?e2jUUCXUTiEUUeU0wA6ija1WhJn4ZOB5I4IdICf0HPNkTv/PRGCYkxO/GA9y?=
 =?us-ascii?Q?lmgoEtJQGE7KcLiMy5bSunp9UPddGjKq8h/vdhY1qznthplgbBxfBko/ZrpI?=
 =?us-ascii?Q?HfkC6OmKAJKiXe+przJstS/AFg+83QpJe4wx2aod6L9TthzFYBdyOgxmVv+m?=
 =?us-ascii?Q?0RvEdE0s9OZt2kXZEWdxW5bkHjrb0jPS4SaznaUFj8ZMbZBCDxb2IdPhnCHU?=
 =?us-ascii?Q?nll5d/WnXEv4Gq2+EmYy8Smv9LWiavMzeoj38V1pR4tux4xyjJFc1nJSk8Bc?=
 =?us-ascii?Q?jpIHFO2ffkiwvVoX8ffWkc7JBWiEBNSFOSXhu0wO5ECG1M/Bt77G3Ef38JNQ?=
 =?us-ascii?Q?G3ODd43qz+J8FapQTKewk2O7y9khSBgcJeUoN8dSDJ3EUd3lNch04QICdy0m?=
 =?us-ascii?Q?yLA6pNqVCeZcH8DDx2AfJXgcEQ9nGfzZs7/S2LYacq1VqlcAVjHL+QFg4e/1?=
 =?us-ascii?Q?5t5Sh3SgS81KbHA4mj6fJTn4JgVYI2X41ZQzKKls2Yx7CtihSWhHFUniLLU3?=
 =?us-ascii?Q?AWNFX/PxSS2ST3kFJUMMMTQVwne9nlS8mwgCeab9KXkaqC/wnrimR8Sn5B/N?=
 =?us-ascii?Q?GNZOY/HQkhvrZyvZBMR8jCAOWEiQiai7VhqKMoq0u/qoK7Ef/DE/bR7wASQK?=
 =?us-ascii?Q?c+YQI0Zg0BA65shEpD8qXeb9aqAD8mmFel0d8ooe?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a7bfc4-1ec6-458f-a7d5-08ddd3c788ae
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 02:26:50.3841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Msde8ZvgnTWEv3splppp2LZqPVjJlac0oN6qC48Lz0Tldllwlsfz7lsAWxOjEaWanFe99Evgx+ILn+Xndr46Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6588

Use vmalloc_array() instead of vmalloc() to simplify the functions
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

