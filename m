Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012033.outbound.protection.outlook.com [52.101.126.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112243019DB;
	Fri, 15 Aug 2025 12:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755260197; cv=fail; b=LuiyOsdUBbGLO39in7K+kqIpFRduHxcQFzpnIM3+EIt37aoPzkVGiWg7mFmYqLq2Qsw8OYut8VaqBYgQUlWU2p1T4gKVyjMbOwxj603zqCMND8HK686KrwWE20W95jgHK38ZLO6+lqi34jctF2fsC5XyaE/ni5xU6rDba4ouPpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755260197; c=relaxed/simple;
	bh=JYRx+xr9AwFTr0aKo/FRepI/OOrBVJbn7ODeswm9840=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KITqnzqoPYUvtF050i20qvDgLgIw5spAK9xkyLW3glwqe8s4nqVv6+DrmAveb2XYr7KzXMd7AcWY3cb447vBsNK0SI3bSeMYTQGDFnw3NVGkRL59Fk77fpUapHufcf7kr/piOIkXUK/8tA3xJxA3F9GP2TWBW04THcBJthhKXeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=oRAv+HRt; arc=fail smtp.client-ip=52.101.126.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="oRAv+HRt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8038gX3+LV4QJa2xWyknlRiLcbRS6+0dVHlp+kZM4eurGpORAS32VbUfd5dCvemuncw79Rew4gxRJlI8VPpW1XBzVH3yhf7b+zP3l+5zZvyETQbcCV1U08jOk/I0e/5+JHM39tVkYrVwKuq1w3kMne4kzSgaIoP/ZpZg7mY8yXDaa/z38LafLNL7aENMjXLWhQSlPhC+hNqghDYF2HDHUVxyNjRgdqePBRW5SZEprxhWwb0s9U61Z1OmT2tP7yoS1fGpA5br1Z0o1b1YjacMi2NzEkv2i9bpNBHnkgxOjOGwC3LhqYEnxeEJcic5WceiIsl3JWJqyETUgnlAelF6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdCQ7Vllhfrnu8V/eCSo+DnU5wWqPBzaP7FgjkHd5CY=;
 b=aaGaPelDbeNpW0/hFI1W+gBcKGeIHCoZ6mZbb0dCsnQit8so/LVIoIb+bEDHX0TjMrmZLYPbtm7AJkp3VdC01qlqSPeqbZ6w8Vkv9he1WIzWDU3NRtiMmBVuWDhUWfG6Jcg2fare+lL943jfdUIvkWZiNEfyga32HPBAFiuzLFQ7Whtz3JF/M/g89YiQPMyScyqlLPTLdhqz+MS10Ex1tm9dz+9aXzDC/QhMlgu523RTBc+TzwgdbakBgStTprFqBG8rq3brCynI/U5Xh4reIF4vPQvOhxkjWFGkQJ+9slgb3icOkG/tMak1AhQZv9mjmj2pLeGPynTyXc6RIFgySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdCQ7Vllhfrnu8V/eCSo+DnU5wWqPBzaP7FgjkHd5CY=;
 b=oRAv+HRt8nGka5QllTa7xaolzYVgq+sIl5HCZDOOM/TQcE31j5scQ3Tq+q6WakGVVvvr8FR9fDkrV9fWY+UHneJZDIDJo4l1k1yRtV+R5M7ogOT0K73CUiTMr0QVZYM0SZCJteVN3n2peIbrMtL3aX/bo44B23UAwRTDWEOFki7z2tucFTqBFUhjCTwWpyh0bQbrhBUeAjdWcD9pZR5MV8XohFivcwzFopztdgMcLwY2jm+GoKiyQPCIt/fJfjJcCeQR0fzB7AV8NiI9Ss2LkpEeTVKnogiR1PVykjc/ArrqefZ+dBPn8Y8E7w50nQ8USO4uh1OcA51QLYAjDSHT8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6896.apcprd06.prod.outlook.com (2603:1096:405:22::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.18; Fri, 15 Aug 2025 12:16:33 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 12:16:33 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com (open list:MEGARAID SCSI/SAS DRIVERS),
	linux-scsi@vger.kernel.org (open list:MEGARAID SCSI/SAS DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 4/6] scsi: megaraid_sas: use max() to improve code
Date: Fri, 15 Aug 2025 20:16:06 +0800
Message-Id: <20250815121609.384914-5-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250815121609.384914-1-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0196.jpnprd01.prod.outlook.com
 (2603:1096:404:29::16) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: be8171bb-fda9-4f44-b2c1-08dddbf592a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|366016|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9sPDPE0W8cxfDX0+K2PxrOuiKk1RfCCZdQ274LI0+xAM2wNzFq6xebrKyrBj?=
 =?us-ascii?Q?/Ag3e8oAWyLYk6DTfxNRZRSGBjqk5OU4+ZZD3EJwJR63sCEjWtvZDbcXrMoc?=
 =?us-ascii?Q?rxYfZ4HZZ40O4O4xrLO8a1HsY1ETjpRDFIkYce8TlvxY2v5XMB8ua5Y0hRlw?=
 =?us-ascii?Q?KyQeACyE7IdwxksEztyI8uXGWbQef8DAfFUoopitMAkUFYBq2aXqERrmRaif?=
 =?us-ascii?Q?qOjBMnTb0D2337yuayHoGci5xaJnfTzirasR6VxlSL6MddwAszKtdaAyQI3y?=
 =?us-ascii?Q?PBQbzExc4aNYQcJinHfjpiBQfYlv5/FsK0r75BVagyQZ5f9ojjqcIbFRWiwV?=
 =?us-ascii?Q?Xol/CgAO2q8hbYsJozLeZcpSsWwT/EkZHFI7XzJY/OXphzxJep+4DsBNFGVV?=
 =?us-ascii?Q?dtXsCL/1bw1Xt0ueGY08FNebi/JaOiciFzGgQcvbJjohFTApdXeFI8+qujoe?=
 =?us-ascii?Q?ieJcv5rPeOz9SNzHoqs+xHRsCvL36inSyEtuH/kl3DTk9qQjyjKr5W6+h+C0?=
 =?us-ascii?Q?f5xbKt2vpY0lbh/kANlC62m45FUYCl9jjHEEDbVyqMfIKU8csvLZctwrbrCL?=
 =?us-ascii?Q?5ZA4YqHawFxM98D0WN9tfVJmu6BrB9M679zVY8NkL/R3RcMDuJOcpKSYfhuT?=
 =?us-ascii?Q?8qITQOa1sspoSE5rZUt0TsF+T3y8wB8Iy8DTqh8WQFYqScHkFnGZn06aSDE6?=
 =?us-ascii?Q?emLGvzbZeCbX2rla1bJj1Gd7AEkeGM5r0GT+YZgOslgj6Pf1XiPDXKYD/olj?=
 =?us-ascii?Q?ZF9uDPb0A9uwR6tNVjlksbzVvWR5yXJ9pIotMSsCs5RegzuC/xrEKxVSxW5O?=
 =?us-ascii?Q?Q7S61VqhA7EIXdIo2oY1y1wGnmupVPh5wW3QU8Yoc5iJ+p3YR882zi0cpFbt?=
 =?us-ascii?Q?G89+UtZ+kM7DScrNaVMoM0DYJsphBQFIK46KurDt1hspc808tvUDdo5i/ll6?=
 =?us-ascii?Q?YVZx1AyIuu3ODJDbYmP+yoaUT+joZ/n6xR0igSWHXROSGGvE9hMUTelEY88U?=
 =?us-ascii?Q?8znFhOksOAIWnc8rMOYMelFre/NQSCoawV9sIdffkfm5bi77ToCfwuCv0DP5?=
 =?us-ascii?Q?/cHxv3wLcax30WuVQEmuAe0EN9Rxqbsb3ZhIz0TNrJHiJE2j5hMfxL6CsJ7T?=
 =?us-ascii?Q?fI3HjKMb5/dDxom7soiz5tCeXnqSAq2z3fIYfGebNO0RpMgk9mc25mCmB3ft?=
 =?us-ascii?Q?38aUyitnHSE909J9bwOZ/cAouhepgUUpKUQiITzSxYutDhIJP3huF7VPKyM8?=
 =?us-ascii?Q?XKKWcOrjMa4VoBOVldXsKeFbb856IXKd/7Atm3ms2lf/MaFY/E0w02lJThCo?=
 =?us-ascii?Q?fny192HgfwDFCVfxVfr5p7X0kKIk5otn5r/uFt+AHKXcWqCvgxrtEmUwaB2u?=
 =?us-ascii?Q?S7UNGYagBHXWv1gpkKmA0DQk5PKDhUMBpt0wKuw9GICm1O0S5ktknS9Ol0Um?=
 =?us-ascii?Q?95GTelsysXiTuJjJl0vvgirLtpHoqP7MVUfguI0VUJ53oWD61UM1pQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?peVuAv20PW5+wG+gdj/LZR0RTk04IJL+8irtAgRJQIvWB46v8+RtmsdX3+px?=
 =?us-ascii?Q?2TIche7iPTziwOe85iQOsQBcdojyV0NIcMpWH3gtkysTaK2H0QsXZJQAf/E/?=
 =?us-ascii?Q?Pu0XyOJWWZghlDcWuTauFBHATBqoCJxHuzjD8ICcw1yUQA+C/0c19G5udYwN?=
 =?us-ascii?Q?FjHLVmmQEi4P7C/1FRCFfwqgb8eq+uZ9zNY5drH1OIlPvflatF8QoxjunKBX?=
 =?us-ascii?Q?dRqYBU8IJfVic7sQw0cTbgYC+a2IIEnOEqkFP28Y6t6Nq2/nojsj2hWceEOI?=
 =?us-ascii?Q?We5rzKOqQJcbiQC0U+gf/9AYm751NfylUZJtPMbmmfXlYmyr1umGysPPu9FQ?=
 =?us-ascii?Q?ittZ/hA3iOwzay7CU7q9ZavkEbGoIb+7PhnG6+NZfQmvJzWi2+zI5myOAaqF?=
 =?us-ascii?Q?4yul9uM0kTY4Xwwm/nTwfJUtUZNXIUjmDK0q4Lz/MDKZRGIzGMro1JZSPsiL?=
 =?us-ascii?Q?/jaQoyEq5KUBxbhIhQveTsrOfHsk/U8M5WtH6hBQHcsTpT0iZ1B5SJCs1dDA?=
 =?us-ascii?Q?aEEv+9ChnCWuDIohhKcKNznaxE1f0cKvQ/J/vAZlJOuvOe2hkFufDv928UkY?=
 =?us-ascii?Q?57SjRFlyu8ycKAWFSIR+2j/LVU3jXhZWHv3Axd0U2S9JWiKhmgFkhwLHl9J4?=
 =?us-ascii?Q?vnTLYlUt5XvwoY1bBFdFMnyqMemObQ7mqv8E8Yejg2HrTlIhfkBrJJH50N/O?=
 =?us-ascii?Q?T/nx7iko6Iy78R6b6a0hHsD5aw8D92YtHSVh5fmmRlTDXTJ2aWq6bDNiD8CQ?=
 =?us-ascii?Q?uodNTGOBw60wq5KqJIiqp1npkjgCEgMfDUayx5tcaysoudp/oDGSrgu2UNgb?=
 =?us-ascii?Q?JiwV/36EfTMDcCtIpV1Kvxd2pg4EXpe8i/VlAfc6jwGNSvxM10bY4zdC+Bl7?=
 =?us-ascii?Q?RD/Xmf7EY6/X4zpzhIZ66p8LdAFvTno+/4xTQgluA3CGLB79JuUY/ISxHLeq?=
 =?us-ascii?Q?PH1Wva62G3mYd74a8I7QPpLWMw+MSVHrrpNmrCXAJX5QYhOV73LDmGKNcQ7S?=
 =?us-ascii?Q?1YV3Siu9Kj0ODwPQhmB+BKiFNEDgioI1qa3ZkaXMUwTbOtKgfEw8gYaaWyMW?=
 =?us-ascii?Q?1/xWpROWgcH7Eg/BK5UeWmaR3xsSuQ0TmW0Ow003jp2UJ8b6SoOmieV9XaPy?=
 =?us-ascii?Q?hJTfiySRX9oMqKnSHidDQYKBYrvlqYEK/VES/6YDddt+4e2rtB4SRk1D52iE?=
 =?us-ascii?Q?z9M8mjGrfuWJDzKejN19bd4IOYLx8lvVwFWPrbhUVGJqLdGlbT+cFGtWCE4q?=
 =?us-ascii?Q?B89pWAk7D+nd/fOMdqyKl6APus6dSbfsvJ0PIDAev49eMcrcHd3D0G/mB1Qf?=
 =?us-ascii?Q?coDBr9kMTudppgZ2Asy0Js3BsvBQPmhUjlQDq9BdsfUL5t3splvP6bkKUC5c?=
 =?us-ascii?Q?b3lRJQEhKn0rpv1+bM4AL/4rcsfAPtt5SHQY+q9PxAHfBgSAcwFbF1SOA/wq?=
 =?us-ascii?Q?7XMCXdWlQOGn30AxaoM56A5KAKkVTo2UvE1e194o5A6jCNwms1MtaVFShb8m?=
 =?us-ascii?Q?YiRlc+cEWdl6rm/uBkdaL5J0sl9Iunf6ySxxo7q5iO48PWifrn8Q4VtL/k6Q?=
 =?us-ascii?Q?GWqQsUIQU1D8aEBo39BbwWJ0sWASc1eVcvISEt0y?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8171bb-fda9-4f44-b2c1-08dddbf592a7
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 12:16:33.8224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NGPpZo+fCk5mBCTcy9EjZDsiuDy/+0paIgkWH2qDhEHrkm3ZnziaM4SamztYT3amG5xber6c6TDtEp8Nf3nWIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6896

Use max() to reduce the code in megasas_alloc_irq_vectors() and improve
its readability.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 615e06fd4ee8..18ace4fff9a8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6004,10 +6004,7 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 			instance->msix_vectors - instance->iopoll_q_count,
 			i, instance->iopoll_q_count);
 
-	if (i > 0)
-		instance->msix_vectors = i;
-	else
-		instance->msix_vectors = 0;
+	instance->msix_vectors = max(i, 0);
 
 	if (instance->smp_affinity_enable)
 		megasas_set_high_iops_queue_affinity_and_hint(instance);
-- 
2.34.1

