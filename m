Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4AD3F1674;
	Tue, 28 Apr 2026 11:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777375048; cv=fail; b=bvioqdrytZUbJ8sAGyUJFthU1OBRUR87loD+Gzq+UDzKDXQ6GZbFXCqgBoSlYs7aQB6x8OlZRiY55BAEY641XNzF35uIDZb6oCSXXywIB455d9m2DaqQ5pws5A3Bngol17wYCCtT+zrISWojopcnIpCF5nAb2SikEU1IqIVa5vo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777375048; c=relaxed/simple;
	bh=vVcMtm6HJHZF1GQVOX5Cz+I7OnZPGeLLjMvptW05njg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O2U+Wy1hRcS2xejCwuM99hclxP0ognjIUD+/cvocktWv0K+pLAfWdPWJtr3Rc9uDKBw3soNM5+F8N4WMO1n56tvJTMU5GhFS3UPa4KX34t4+q2JWg7xmImQRF9xJJzQnHjD1Ij4kzj1cB0+T0P/PJXAghyZlsm5QGe7tEXw25sg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N8FAV+1n; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jyPMwQ99; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N8FAV+1n";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jyPMwQ99"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SAOwfO721101;
	Tue, 28 Apr 2026 11:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9MxCm7fGYcLQYUFmb9S/v+wr9WovBFRfIy8S0mHtH98=; b=
	N8FAV+1nyEzre1vJbjsISTu+myyHsSHBSdl5QzHrSe0Gd2/8/YnnmfxC0cc+ax+i
	IDG2G+B5gr/5PoKGgLm4TcBfWFNiZjnp259qWi8AueO0II4R4HyWxH+Ns1yjhNa8
	fflo6bnF47TCdJnslVIARYq4mtsL3H0s7DcswOlbbRzcfkraXwekKuGFTL0KCcQH
	6X7qUpOgTp5imbwuRSrIXwhuWxo5bjwJQBJEHiFbJ6bCmUwLjpY77Pd8kI1AfpAf
	piL6cRbj4+Z9glT45Fq/hSXeJd7+p6Xgxy7iQ6s/q+1iatKt85XoQ4vnCvM8fXg6
	35/6MJlNhHkuLEZkE2xGNw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drp5syfqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCmVg038802;
	Tue, 28 Apr 2026 11:15:43 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ccner-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRcs6npnrAwpUq+Fp28GbieTFymBpE3L8vKTj2F2cmttNRkjXCd5Kh3bLIjEsEWkiMdqW36DxIK7PkEzuqvLdZhMvjrYUK7FBqdaA3eNv2O/vD0AkEjvoTKXANM5jXeolTByA2fErnQCRGVYhmNY32IdzdeizgFGaOTbHogR+Ik03XlD42WzNG7qxlYAhrnfV1XmrdIvUG2GiToEawZJzaQyy+hU24FS+9SnhEkajlukWWeANBgE9T4iojHmpoZCXEq/47gkX4zbsreIxl/sTrPL5H/0Mo6c6qVkEKBR6mZYzJJVMckvmqSVVS6K6Ilvh+QzYGq+Fry5GXU5BZ9Pyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MxCm7fGYcLQYUFmb9S/v+wr9WovBFRfIy8S0mHtH98=;
 b=KZ8nLqmpkmfgBkTJ/RZsOv5fpnf5MMgwtGQ4Rq3mq/m7yKg5k9otL3mqIULboAJM1RmLaZPMc9hUaYi0Hk+j3IbtLJrQ2Xos8PNX53WXcYoVGvUJa8YH58DwOwS3WX6FYAWkHLuWepmZGM8vGzHIkTsTeZDVMamugp4VKVCfk4iBFgfvmwrTjcXJvBKs1SqTJmroObyvjP1wXRPi6jFSgt0PmwnJ74rKeuhW9Zul+biUkSD6ETOkKHd66D+1WNrYr8foQUDk8aE53XrvuPnXoAYpiuwgkH4xqCj7RHrAyM9NSYa1T3G3ZXO2zEKCXEXz7lw5QVW1UNpda1WoUXzR0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MxCm7fGYcLQYUFmb9S/v+wr9WovBFRfIy8S0mHtH98=;
 b=jyPMwQ99LRgbv1vrUbC7UQDU2ES7Mr1eosRgpn9qwhb+7HI/SP2RpVMG4J8dMKz9RftMOvIrh8fEvqRDmC5WqV7e23srVTvOUZI0m8CsAAVwxdYQfIKkj6PqnVRjQLM7oaQNaYHr+Bs6XxiYtSLQ29GrSf0r/MBXVuiimeICRHU=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by SN4PR10MB5639.namprd10.prod.outlook.com
 (2603:10b6:806:20a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:35 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 17/18] scsi: sd: add mpath_numa_nodes dev attribute
Date: Tue, 28 Apr 2026 11:14:46 +0000
Message-ID: <20260428111447.1779062-18-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH5P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::22) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|SN4PR10MB5639:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cc4c49-47a1-4938-24ad-08dea517786e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Xp8jjQ/I/KlQ5LRpMszT41jQIZq/wqkvsmOc+mz4traRhhV2SkeqdKoG9PuG1q3AaQk6rPZxzN58xParSJdGwQomVPl8vhHCh+y7RffQ3LdvrmEfZ8VcvgVZCy9e3yaeNQvXOnvWEova0GeLkLbvqLpJgBNs1nrBk8eGsOPQW52Z8mxuvUX1rB4dX3VYBma5yr4TYhWjxLf+TNsvexl4FUntf3pCZ8HlvIXpYTo3DjpJDkbrP/hXVRSgseiXLN5tdw0Rk0UWSVv5/otUo6IMK2iMGZfbv9GJW0Aa0IAoNGFhu47MVFetOe62TTLB2BlftYM3gQsKtE/I7f1eWRLKNlCykLiC50X5Pi64dVAIhkLjiQs8FFfq2TbFQQwnHQG+Bg8MdklIyrvMRk5muYJQ18EcuXvL8G6OY7p9Eexhv5RaOLnvB1iJlNe2eU7lY5m0iHiG5IhFrFakJV2ojnVm86PNA2T2OLXiEaw9DMOxs7+plXjAf4K1BHAa+Q34+JJclU8XffLS6i0m6zTteI2z+8UtE/tWJKACMLYMF3GsoY0jQKk4FmTUpXBcjzJx/VnrLjSUnFopAQs2JVocSsclQcbQF2VVweS+uxPdY7h10kcl62nQdbNtyvFDKggKI3lwKE/Yr/czq8KRC7arChDBMAgG3NM7Z3ceVBgPdW8pB3ecHSKoYmDC4X/z5edY/FR+CkvGZLLHLT9Nx44wOKvIG6eKyoYPjubDobTVC5j/8xQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4EJSuK8YZZb+o6k8NXgiH0hn4s1p1Or5PslUNSq2M3i8iud06y+Vp/Rs5aiW?=
 =?us-ascii?Q?+3Jr2VS1wftvXykaADsDqr4zwZT+4Iz7Y+vqtRY5c8d7H2fogP0+ZwV00ukB?=
 =?us-ascii?Q?FXmqHRePPv1HTxU2g7/oScMZK0yHPTB3n0NBPLOdx5IoF2Wzb97AzyFQzICe?=
 =?us-ascii?Q?herPB2aNL1DEM3+tHBjDEXS4sTV+7XAxUhPqh5L3q5jKmkGwC5eDOQm6P3Sf?=
 =?us-ascii?Q?/CRfy+Ssw1BVxJEclIhfsV3b9vgFe2g9IjbgRK01yNA5v7GkqnglQJET133y?=
 =?us-ascii?Q?WQHx/mf0mA2Hysx5U965W7o5ArAwjFaHvUsJWZor7FkXclaSKDhkmMtphQoA?=
 =?us-ascii?Q?uMSvCeep0FAd1PLwA1qGsJD77eT8ft4xnyYs80KULQUdyRXi6nF+TKZZdiEa?=
 =?us-ascii?Q?8js/kCeBzsqDB+hGZdoX9BF+u3gSG5miuAOOG9ENvmIckrbPweU4eV4AMPMY?=
 =?us-ascii?Q?maWY48Ord16QIjrAqoXAe+J7VT5LfCCPIYOJurMqFZaVAv98Rx+vjGhmooNr?=
 =?us-ascii?Q?YSOFDB/9F46+FRa1QPbWw1amjRN+vOw4gkWtP0pNgSTFv9s2ZRwbpRsHoXV/?=
 =?us-ascii?Q?KjYQA1fpfSm33SpKnw7mVc+fzJmDOIxiUQTwGBwcA/FWlzbDR753JhSnz91E?=
 =?us-ascii?Q?gbUKmZnrqdjnKl937Ui6mi3fA1RguUmafos1A1WgOo6nCz3y++Jm+9/76zxP?=
 =?us-ascii?Q?Jz3Se8mKVvNAwEMfrv6p5di9vpZ85KM9g4o1yGNWS3PqmLgi+hquw3G9O6s6?=
 =?us-ascii?Q?4f/tdoiXOsdpGp0sbe/xWn2nqXSY84o1wxBwWUs6tBKPvepmQSTpFbnSdv0u?=
 =?us-ascii?Q?wFaIGCKxpz4Nvqv0G1RyH1+0kaTrE2zIWSVJ1LRKKI+6gTtIAsrCFyobI3U+?=
 =?us-ascii?Q?MjtA5xydldezma55abHupSMQ3nZ4UA9R4vWuH1fO77NAZjNrvGYTHTnzhNqz?=
 =?us-ascii?Q?EOOIn8olBTm+fcrOdk84bGWJNcDc378lPYJOEUBRD9khA4iDQ/QgL4qqguqn?=
 =?us-ascii?Q?Nu4F1glg2qNnJOvMuDRjMOg9ahovG2lzOOlok3f5N9ucsACfiHXITIsLIJvg?=
 =?us-ascii?Q?D48Z6aalhgQ+w/DFwJCjQywc3ymeQV7RxEkAFQHBjrMbHcF4jLrE0xxqckG/?=
 =?us-ascii?Q?Q1CL4Tyxo66FKYlV2FwkeYdokoOL1PG7xUhtbDKcZy/wyyl3t0VVU6WAuI1n?=
 =?us-ascii?Q?kljYOiFNbeuaCuSdzMOo1uaZ5H04JnZNa36/RyxFXm6NaydrXLRXi0zxnlnd?=
 =?us-ascii?Q?6KF53+nQYcDAtPj+u/zuonk6+xoA79dMHSRDFlEmGUcVI6MM6W7lywBNHlLi?=
 =?us-ascii?Q?gxtwdJhV6Kud05pphJODRjsDTG27I+2+hM2qHL5nDIv7CEn5Y4ituEv1RfJN?=
 =?us-ascii?Q?7YO0m9IRqaMxrg6Z2KfufsdJYWyZwsfOfOSQV+b86U7gqZvt9e8wt0n+7S6a?=
 =?us-ascii?Q?TukVbBUpaB65SBSciX0rNLdWHOBhMy7NH0iL+5Hlfj4NykWS2XfMs0DEOi5a?=
 =?us-ascii?Q?8meUK62lXKEzo4aLmT+ayLXCqnfwReLAoFNrJTpVRoix/zAx7vgRRQwBMsqz?=
 =?us-ascii?Q?iGY1nAcgcLpRXimiEK+7Cwyi5qQnmYxf1O/13D7vIvfV6IaeSqjhM4SIrN7I?=
 =?us-ascii?Q?oF/JSYOwc7tLAWk1j0wVjmwY/VanSe8bgw0ZcbsBDKsenSUq8y/NIwUOcscN?=
 =?us-ascii?Q?G7v4pTzvnsd6zMyCzVGKbXP+Nl1eUKZXvtC6XNJzsqesFWOgmq5DsnZXzVpr?=
 =?us-ascii?Q?dTzODzMKasICEsVU9zVdSdMAGAC2jME=3D?=
X-Exchange-RoutingPolicyChecked:
	AnbKq3cy/GZHk/20B0xDN6WR38+H8In8idiKVYqTRktSQBZepATJvdDwywKupZkTmrhs5iAIPBwW7VbX2onPx0HXhCahXoT8d6OLa72N8bpltb9+9IDXi+eAo1AKQ4kkv853ntKFlUty06x1utmxgxUjja828sKrHl04JLHgJLL1VUc9J7u+O7ZXnK3KFSi/BkDFMKvk0KknNRB25OjKi3ViSDj9dkZR6qXPeN5Plk+AXJzeaDBhOx8JipIFlnWlDSwqgtwm6c+oogaWjSnERwLDfx9dca5grV0gUchpvn5Rw5TvZvWCmwi6dRdQP4rzbsTh7VIyx46i/FKIo5pMWA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	56Es0pDEt139wKJ8IV4Tl0OxEGx85mE7GdygcnBBIR0JT5UeC9b3vBvdMOxkh66L8067xGf/l4YvFrfD8TrZClT1qoVsrBNO/SR80y3RO/koWPK7uqA5D9mnNm+VIS9pE593KpCfxANj/SnwiekVX0vrYknYXXgx+PXMaRtW5LO75mIpPToNsGTubS9YIvtDEBgthVskIhuh1pKqf8ZKAtQOexNlPDVpdFy9b0BbkUDbD9ydQKKodqzEtwHO7+KUut8tpDUABlqNn722+XrcLyRXtgUJ9dh3vNQ+fR0Qc+gJdI4b6Txd5T7gNus0sPZV0ox74NN0XVgZQPx/K0QnK0n7ptG9eY/c8wD8AhNZiRMiOuQqi+RIylcUWZQeswsxas39NoPy0W87rHaqhaQJENbr02su30XruUak6+lMLD6BxDlNHSUhGMiOYujncQCfs/q+0OJzXmGskflqkhoC7RcESk6exKwXnkkQoYHNyqdixgM1/bCEiGJgR2pV8+mXe/0OQdqp9cKuiz9xqFstbuFGMaX/k5mlFwHQp0iaAkbbu239cgxZqY4M+RKIGo4+mK5C5o0oijklWj2BUIv9zAD9E6l+EPtPd792Qcxjxjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cc4c49-47a1-4938-24ad-08dea517786e
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:35.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgvqacElYk7LL4Ozm8pkKHdtN/S8V42GzvLI64xdn6fZPX6udotPR7su0gTEOK/joNG5VXWBR9/RMvKQ/KnUIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMyBTYWx0ZWRfXy7XKTsdG4sRc
 eObb1KoxC7DBFCJTKATFRT2AxpHedoIBMg5H7tB+9KFtFOJFDU7GzhCuE/J7qY2qpjxOh2DVMem
 ox/cnaSyekXLK5LoEPG/t1oNqmtfQGpOu4FT5x5UgkFW7FVjLTsJ4WQN/Rs9sjAaHuKDnElp2Qm
 Ph0I3vC9wfIzYiS77GZTfm+JINauplbWVSNmWFTPF3BI6cvG4ayo4WNeu+RkXJacoC8U1RzHgg6
 xoYlsSYdOSSctzCjwacUr3ohaiFJg1e2gsXlzhGGm7jINQVIZezCoVbOcok+ZeaUBdj4JiQWxYJ
 E/QJsfj3pzAvO2BpkK+NI5B7MaQ2pI8q5N6K9FCSE1sCl2zOvAKp6HKIcCjqwcHw9x0VvApRAkW
 oyS5xrZY1tDdojp4V/M65Y/NszOmh7aN5vhRLKFVWQB7voET1D9d3H2S/IxgSEL0CvW2mK1FBfE
 hFbHz/Fyo3hO5P5+be1XC9cMYfFdEh35UsB8HEpI=
X-Proofpoint-ORIG-GUID: pL0JG87r8U8xt3vsbDouhUHOUv-WeV_O
X-Proofpoint-GUID: pL0JG87r8U8xt3vsbDouhUHOUv-WeV_O
X-Authority-Analysis: v=2.4 cv=E7v9Y6dl c=1 sm=1 tr=0 ts=69f096e0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=P2_R26dytZ8aPJic-48A:9 cc=ntf
 awl=host:13844

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 380da0b0298bb..ee604f9f8cd20 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4033,8 +4033,25 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
 }
 static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
 
+static ssize_t sd_mpath_numa_nodes_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
+	struct sd_mpath_disk *sd_mpath_disk = sdkp->sd_mpath_disk;
+	struct scsi_mpath_head *scsi_mpath_head = sd_mpath_disk->scsi_mpath_head;
+	struct mpath_iopolicy *mpath_iopolicy = &scsi_mpath_head->iopolicy;
+
+	return mpath_numa_nodes_show(mpath_device, mpath_iopolicy, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.5

