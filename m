Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012014.outbound.protection.outlook.com [40.107.75.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B517F1922DD;
	Tue,  5 Aug 2025 02:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754360813; cv=fail; b=BQaB6qJuo0eczhuj94GJpGzhFA5c5SArr9j1yt6ATf8/hxbnwq177DuR0cWUX3+lOhDCg7wFGwg0Hb0E9t0UvlJG217oG3d+4JAMzThW8Ca2wv7DzGhr18ia90TMUQxm7qidQLtcoZWq0iHegF1lCOmZyQJJCYZDZDzj+nNnPjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754360813; c=relaxed/simple;
	bh=mx/UxPV69IqC8FqoxESVwtifd3UcSdUGun19eRsbl4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=XU6jad2KD6ORLmIuP/XXD91oF6PBvu0LnSMITF6wkw+em0PpBCzhFKHcBYi4Ydu7smNJxZbRXdyFmKL8tM2fGyf2VPJHpy4In3ExRRvnbMQo3FLMUclMRE8zkEJBM3Wri8Fi5ob4Eg28OUmDE7WoNHPZBb1L4JWm9Zplyi0ClyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=QKdh3Ymd; arc=fail smtp.client-ip=40.107.75.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="QKdh3Ymd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8szGr9wY+/X2FnehndB3Nwjict5itjS4Y7AZP1dXMGFGyknjMj+yKAIIZjw+e0CL9hVn4D5wO967msvdGbj5fWGz4yjpGvhkI4OQnG5z0kJrxfCKQxj/I/8EvxTLNN82F4PfMzKeE7iI4Oe/HhvclPjBQGMijO/hPg2ReUzbqPMq2LKwVOtEY5qQPFSzTWYtBLqCn7E0bgNvo61HG1HM9PihQJOqHwuJY+hJ3v972/7ouFzJBeHuTojNjeXLTyAJp6+mNhpLVU/YegE5tWcqPmK35uMXiUUtFwUzvDChu0+y/3Y6sIu5E0o3yw9zKuenlkm3Oqs6/9SDEJhhjYwTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPd64IFlgc3cdwpyLp4W+sopSSDZOBnxcl5QCLwdpsM=;
 b=HxjuO88rziSTSYxH6FTmIa1Vqq2uXDqpnaMBCEiT6jDsvzQtDyYE2433e4PaQq5BDZtaXR4nkbRjurk7RaiwisRPnmr4xL2fgf6z8DGJ+uPq/VYVoLG0Lz9DVzlvpHJEpE+u/u4YtStZ7zGoUdFnBSmk5mPyEPH19xr7cp5ArL/BUL11F4HY1r4kD+GxCKVU5YMwWP0YTHekktETrx+894hLrJZk36yCLqQB7SGqmvid2GK07dpQd1CQy4oS6hJfHTf5lUaqALPclp299Lzg/mYQuAwY5dFqpLpAaF5PWsinkNmVIk9bnxA/8m/q2w2vugqRZHgj9jyaDGeQvKfLDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPd64IFlgc3cdwpyLp4W+sopSSDZOBnxcl5QCLwdpsM=;
 b=QKdh3YmdJ1pNihZxYYNZwBZN8xfAiW62mcAdSZuN0+izgEukAkBOi3Y2e5jcKO9IEGD2ErzRQoM2nssdhjT/2wh+3+dB8qr05RkJyVzKyQlK+QYcdIyF6NsRp87ACd1vYGc3hm0MmrP5F42HrAb40Keiqe6QJyw5eMa3tzyDy5Lj3M4D/YVlpx2BAXAMnqDs7/2fseFmTCuTRtuQnPBWYwKBLVUnlNcabXMQvrfbFBV4CMmG6hnNJfDX5bfKq0YMBaU/aBc/FRRjOmC9kDb8Py1ZQuDH4v9jsjtjo66uBD6aQgaj3/Reyg0k+bmvCzHhdnNjPebu1UQ30F1DUONCpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 SEYPR06MB6588.apcprd06.prod.outlook.com (2603:1096:101:177::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 02:26:47 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 02:26:47 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: bvanassche@acm.org,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH v2 0/2] Use vmalloc_array and vcalloc to simplify code
Date: Tue,  5 Aug 2025 10:26:34 +0800
Message-Id: <20250805022637.329212-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 9c334304-d74a-431a-2250-08ddd3c7871d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EfeRcOHqN+cmYKNwC/X0M1Lfn2VxVjh192XfZ7lNvzmLXIyVxzGWZp2w+awL?=
 =?us-ascii?Q?jZjRFpyqwTTyEKG+fVWpc7T4cGX7hIS2szgjpejq78AQCATqVUqJlZR9Tfwv?=
 =?us-ascii?Q?rn/SMPESfNHUSoglxqNPQwY7mqBM1wgGXC+Cc9GtaPSIjcdhCAG0HwYr/0QM?=
 =?us-ascii?Q?S3We/GzcOABpawmBn3lDv8YuwpLqXh2SJjPukE0EzGRc/k1hkQaIc1vseEKT?=
 =?us-ascii?Q?2PLH3QcFDQYf75Iul8A69s0L9t5PLugx2zbVIudLc6VNZlb6SFRvi9rhSyvv?=
 =?us-ascii?Q?OoZ7O9+IsktGpogGjiYd+dG3rhJ3AVuGQ9McOoZMsF3osKIot30VFD1+MbBO?=
 =?us-ascii?Q?MZ43Jx3cozRxi2Lc64mrM2qklFbwZ0uThLUI0GTdizyJLoORLGrupsS3jnCz?=
 =?us-ascii?Q?2720+IRTpxzvoUbbovbZ0IL1avQw5obp+BEUE8dXv4uk5E5Um1dBmFd3Hepa?=
 =?us-ascii?Q?H+z3wkIJ9uNE2WN4piDEr+caTb0ZfPsbTwyMAWntb5FkRkGyaH7SBdBspE5O?=
 =?us-ascii?Q?z94SCiS1D+vAU1dA5sOb6OTdKPMfIY+05ugD7MHqWNmvpipnDiV6tYoTEW9G?=
 =?us-ascii?Q?YlUYRyl4XAcuZW34O+uZHY2DkkCjq2kDeqQeEP3nJlaEyJly1c8czDwTA+pX?=
 =?us-ascii?Q?dEvpjfOb0VLVgvwv0LJRHnK8XImlYzTP7B3WEIqzj0crjLlR3J7qHEncFiQc?=
 =?us-ascii?Q?92cp41e7u/DtQUHwSoZ29LOkgWRPHWXvAA/otAVnXVkjYnjbMXiRbRVFQ5xw?=
 =?us-ascii?Q?enI3fKJBDza9K2YfagXOB/+FKktvwfQFolIhS8cYrib2ozfRqGha9gWI2ED9?=
 =?us-ascii?Q?RJYOOB6oD1/5joXUvkiT44sifMk2K79LKkScNfuxnpy0/8ay5/keuBYhl7PI?=
 =?us-ascii?Q?70arvvJ071aNOXmUIxC03F7rfBYvZSq5vf2NxUzd5+nw15WpMhDICTMpyhLA?=
 =?us-ascii?Q?jQx4YEBDkQftHkHdcWfSxOZ3AaMzlpa/2c2CJKUlMirodchj4T/kGEtGI1W7?=
 =?us-ascii?Q?lIegpudO5wD+nVODfXLVR76nzypUBpqXD4wMKvEarw4VIy6cim5ypoAvYDGd?=
 =?us-ascii?Q?QFaU04x9VKAj73/oaliShkzGioQ+ELxApH5FOrqNxCQG/d2xKrv22AWoD90E?=
 =?us-ascii?Q?tlboDhvxiQBvzMMy1ZeYx74JJLiLXiZZLy283WMhWs+6WCMMi1Bd3Eo9mvYy?=
 =?us-ascii?Q?fj6oKLIvaSAmFoUXNiywvi29u4XAEU8rYODGRR+epFf0s29UnMu2sQlGLw13?=
 =?us-ascii?Q?IywyDT3+srYQC1tpsBmqVBL4EM+uEWpifxSLadN3djdi4r+MxoW75oKdmOIN?=
 =?us-ascii?Q?DfHU74TWHrgVbGDwrxDhuvp2JMf4eE8diPCTBvE1JaGVlOxLYEyxHv34BgCH?=
 =?us-ascii?Q?2JpqDKTB+ooGqIpfkRD+d2PHL29uc6PU0nBd0bbYtmG5dlMfH2BuQk8VQvdD?=
 =?us-ascii?Q?14ICJo4DJ+ZJYKNkO0w7n/HVSopf2N01rIXL4sK6zLrA2B2UZx5LVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eLZJ8G5/ChelVyqmHP/Hmk/FY+TBcwueQddNiuH7DEXZDz2pgw023RTMNn2H?=
 =?us-ascii?Q?Qcd/1z/wUw96uGxQ4aET2WgvAW9YbOQDRncvWtw/XpuyeTvEAnjpfgf6ZItf?=
 =?us-ascii?Q?hGFbOghSL5EisFJjwIhh1mpyrwO+o1EPPENcFssAFLHoJCoO4PNSwAKdWq2K?=
 =?us-ascii?Q?M0glUHjj1g8JIheNbLfwAivPIRiC04AmosZ3eDNE/IHRvP1WQGPFmpWViytT?=
 =?us-ascii?Q?g2Mf5CtYXiXW+njWJl43IoLBwEADaSLFLUafYFvW7qXu0kgFPyJhwpi1gik0?=
 =?us-ascii?Q?dVCDdtX1+w1yU1MjHgqQvVr0Gu3XAygPxo5SbT8k4lqiszXQ/tqDEFqK2j+N?=
 =?us-ascii?Q?pUeed6AGuLHMa0IrN2JszH1At6NdTpJsmvNrFF6+3O/EjFYgDdcYX6IPn0k3?=
 =?us-ascii?Q?zs3fiNPGJrQjO7Ri2Net1HaTSTO00oXSs5pt/jdhTe4G0qI0HPZKDgMYDSCT?=
 =?us-ascii?Q?QK7bAtStsQZlCRvrHLMSjK4EofYtDkHmDCpQL3YvtQEJoTwpk/rpGWwCuWps?=
 =?us-ascii?Q?3/RgOF+g6HK4yL8D1ZJIZ4Nc0Z5elNvmw7s+/A/MC/IxQMTxDqVFXQz92TEh?=
 =?us-ascii?Q?S4VbhkffHuoNKsbNjmlBZ7gBcSutCsxf9SvcSM4w0fdRYJHHZllDll/d6op7?=
 =?us-ascii?Q?9Ez2NS8e6wY19tV3ILchn9blMkt0Zs5mmwJVngGIn7Ad0bCTkm3uJUrMrP86?=
 =?us-ascii?Q?tuxKYZ4uQMu1wQMMdO8uXFGet/PptASN5GBVpTAzGHwxeQH7KEgy3pYHjFMn?=
 =?us-ascii?Q?+9LHvrCLuH6SWtb+35eRiOkKQf4PRC3DJ8sBusYfXPA0ZlFZPmJO3MZoFJrH?=
 =?us-ascii?Q?rIcVw43GF7RkHQyYrCb62lN5ODSA0LD9+aIerV6KOnacoLcVOg1wmOhvLXw2?=
 =?us-ascii?Q?Zda24w8pqVq9hEviwmdbTShjZwRIF+oxb18heudg2uSmaIyzpZv6lOVmuaUS?=
 =?us-ascii?Q?UzsQVp9lv3Ngxfmv8GevkCi0Yo/cwvB7j6NIDO1NNbpxDrDc4xfMlG5q4hAu?=
 =?us-ascii?Q?eohvo5VqeuYiRBgdGoK8v3cKbJrx7j7ymEcXrzhPtw3Vi/Ajochms4uoipYo?=
 =?us-ascii?Q?Uu+DNqU8b8VA4RzZcJtyyxjeeL8jBgaibT5ntDnCu0lZCMlliQx63i9QG9a7?=
 =?us-ascii?Q?Dji1SPCuhPOqehV1ooAoiDDCo/XRJZPU38ZrNo5YZyLFuMNrCTXS1xWO/EAD?=
 =?us-ascii?Q?1AIkWvmo75nUk+tY6vMHfmPIn+fAKbYNWb4L58AeD7MwYVbDMIEPAy9JgjxM?=
 =?us-ascii?Q?G5cf1in5mBRyYhua2sT86Q/l030WY7ixUo7WyMX+Y2XaEcyNgBACd8DBri3y?=
 =?us-ascii?Q?uU36gAD6cPR0h9ZhUXBEBSgh7Reg72SHaRL80e6FWj3YNLxHjnVqGlcqsIEc?=
 =?us-ascii?Q?YTtqhB/j1BCMv7Lk8pLck85bcWH5rxOOecyavDkyLc1kcox+xyGZx0sNPTE/?=
 =?us-ascii?Q?X9TlCIiHeCskwWRe4B1CBeHzScntMNE6zmZIg6HOIAcjoO3Rk8Acl7qdlUxj?=
 =?us-ascii?Q?3H7HCQtxys3/gSvc3IH+uMQ4GNYHT/IkhcFHVhoYPgj1T0EeE45xgNMRAIf+?=
 =?us-ascii?Q?fzLsExAQldxEiCsiX2ERLX0SeUzt93wHGktqBfPo?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c334304-d74a-431a-2250-08ddd3c7871d
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 02:26:47.7453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utGojHtoL/TpCScvaNmsNpPW+3UN+ioJE27hnyvLEdI5p6/mHDdoMOi0pNgDBYC2XO0gsEkpa45fgcfJ2oU06w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6588

Use vmalloc_array() instead of vmalloc() to simplify the functions
ipr_alloc_dump().

Use vcalloc() instead of vmalloc() followed by bitmap_zero() to simplify
the functions sdebug_add_store().

Compile-tested only.

Qianfeng Rong (2):
  scsi: ipr: Use vmalloc_array to simplify code
  scsi: scsi_debug: Use vcalloc to simplify code

 drivers/scsi/ipr.c        | 8 ++++----
 drivers/scsi/scsi_debug.c | 6 ++----
 2 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.34.1

