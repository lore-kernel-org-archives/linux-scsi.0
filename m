Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F747CC91;
	Tue,  1 Sep 2026 10:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259613; cv=fail; b=QnYhEDv18XjpXMh7oM8mz3b45/rB+PFkjloAGaGLcd479rfowMXhTJsE31gniEJl/1cnm47mtYV2jGQ3q8vUmAORU7F328ssAu5l/lg1ObZKrrS/S8deciu/Oh42ACNRJEVkjWDsk00vZ0q22yPw5GJSNqao3QI2YuSjH8VorUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259613; c=relaxed/simple;
	bh=oYzZA+0OlPfEQYwQtiA48uiSnL2QvacnSVYiFwm/oqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i9UmpaakEOS+QVA4fgUUdgcRR5cQJqaWhNcVrUNHEamzCuAWxX/cfZmJvLA4vUbnfmKnjeJrbsRYwluIl/ltN74MOk5e3xN6W5QFcq9L0MTZ/sT22xDgaVyycVLIvEvR6r3cVW77f0JJXNjBr8d+7lFpJldH7ZYoxm/exxsVtTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R/zDMUlO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OxXTsE6L; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/zDMUlO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OxXTsE6L"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLBs6q2311152;
	Tue, 1 Sep 2026 10:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4qvo0uSsuWqHaSRtyFXpQMQze7z9Nr73qGkfNvFW3Zw=; b=
	R/zDMUlOAIFL3ErSa5WdWXsz5AAqhW+AulSJf7u2UrjJpMmuu9jNiSWJWtLwEXii
	dkZNEzIOD6/0EGVqD6/dbZNX10FPzutXXFJEuVrMF+5/eWr9Bpl3KKvoS++G7Fav
	Mpcr8L69l2z7jYDvjBNxUhvLmkBMx0QwZj7oAKXofOj18sQNrT+oEZ+GkEfsxXYC
	a/g6AUxsR/PGaYOe8Vj/tv4pk7tbf72LUNnKznQP4metyAcnxfibEZKq/D7J1Fq2
	7Y4bvxXbO/2bBQALOC2xhM+CtKHECbenCGMFilozJty7xO/KIFI7Joy5+In5lM9Y
	EQvoPCxyXzWvzhH3SL3oaA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbq1smbvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYuBI040245;
	Tue, 1 Sep 2026 10:46:25 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8n9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ptfSWjn6dKZsZpAeM9JYQwMCDoeBFlNzsjUKK0lLglyNXe9nM7EcDu+Fo2Vs4oVrMuMj2TPqLbW8v8ZsvWBVgbYrLLyk0zWRkk5SN2EZCfAHXC2p1gsT/CzZf3lgMZ23VIXWtPYJdTMiIRs0hMuE99LjT0BXU62PqEnzHiTkplLGWdHJPE+e0GgHSRTXj+mYyRqjMrqz27P0R0YjFh+X05PG5DzL4LmUo96lJo0FIdC0DDhDyHcO5JdrBwoCt5LtJAhE8IO8ZC0C/ocYMWIVbjw/7QY35M1HGuwDMhFb7h0TF2AeDtOUT7zEXnGCRf652kmIbgxHyPJd4WTRhJRA8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qvo0uSsuWqHaSRtyFXpQMQze7z9Nr73qGkfNvFW3Zw=;
 b=F1OBeqmGWybx7jFMnziPDLfWZVsUudq1ilQAKCOeEH74zN+0hy2/T6Xs2El3FMY7ybDTOi+ZDzBgfpPd1uhthz/M0rXu1hwrjpNlnEt0TjE5GOtE1buau4+QZHiUhLQEOyfvLYBiWGPcAtwsQ5FHetyGg2b5+M57p+EL6EODOdeWspHlokU+XGFU0MpiQeP4ORX9UQE+pHhr6B0uaz6TNEJpfC0IjLZbTy2WK2JgTtCW9EnSMH/7uOZEUjX78grJO0xkdakOdzJDNwNvPGbulLOyOMvrL0DenoSkxa+S/+9u9zlo8Z4hdQyDUvltJUfIm4DP20gaAY6yNwdcUHW4sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qvo0uSsuWqHaSRtyFXpQMQze7z9Nr73qGkfNvFW3Zw=;
 b=OxXTsE6L9cgUCqepP6Gh9cR9KyWCLE2tk20QzxVAObpF7UC2cHIx13kOoV4k5tEJWSZk+Klnhgaxe4FraNweqOIOVboJMyfLf92DPpbUiFsmDUdmu3g1fbo+Yp0EX7bHBcf8VS2Dn2iPYglCjDUUKv5NEDjqtvrAgjKWJWXZLuU=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:17 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 19/27] scsi-multipath: provide callbacks for path state
Date: Tue,  1 Sep 2026 10:45:18 +0000
Message-ID: <20260901104526.3850621-20-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::9) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d4c568a-9629-4f52-ab9e-08df08163ffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	VGWyd35fKp99A6N3c06hzwCuxJJvRDS1TSoSh2bacxANjDOLgPPHCscpjP+ib59Cuu4tIhHw5wyZ769MT8OKGjIew8QwsJJuGpjeg/pt/2PMpUt4pkursQH/NgSc+wh/sguWPWJVRtD6X1ujT3j+0/Q1UH7vzdaDi2utl9TIzxZ2VElMRMY9H8Ga+LGEPL585/te7II/wlPfp2mr9zBSTQTpPCErI6b9DTAVHv/BUu6YufF8u0s7vDpkXLRZsQFGG8FBKHyMcsOOmCnQN1SZTzVK6CLegS9b2TFXBTiN/7bFaxuV4Xg/GMJEoce3uEqvKaP/R/iW2mJGUGyrWbJZ6VUS4l5M86N/jCqdpZwY6PVqYuUtuIZION2ulU2kaRMJvT3ZTQoRShl3A6RREFz+1oM6MUjaVeygqtnw7oNnqswvkPAuLzOaWE0oexVbdcn2KQwNvXDjyQzNfT5NIn0/92qTOiAjMMZVTgAnC1hAra9rNrbLSPPzSGLjMAxgo4eRSpbG9mJlQAxyo702S/H7zyafeCcoWs3XlDTQ5ETNOhNk5tcOSynQYmoY6BUwdEPCBcwH2wHJrUkUujoG/t4cjktmleG5h1QexRpgUnbBFlU3cV77pLQwoh/5s3RkatIeATkoTM2bM7myRmwnuHPF0UuaHte8EszC7Xeuy0BC+Uw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AlbQdc3ozEDrumStZqEMrj0srTt2P31afmiPZb5ejPxtV4L1UhMnnTpdWXcM?=
 =?us-ascii?Q?WddKKKZgYL26eGot4SA3NLwxJd0W2PlfRLEbqm0RNpViiLFFBuhFKy2+maBz?=
 =?us-ascii?Q?ApFADFMdlbrgXXiOr5bu+lNtVZb5IsJcaQLTQJhdGHCYJx4wa49im1FyxjMv?=
 =?us-ascii?Q?+xS8dMHMRMdBAFVFkNOOpYKCv5bmntmrT6kBREURdtkk/BB3+CpaDZqSxzZf?=
 =?us-ascii?Q?A6AwsYXpewGz9yiSylio/iGHso/p/y7pYMNFUJcNBVnorCyYTgAKED/8bosd?=
 =?us-ascii?Q?ctDXXd5N2mG6ojfWeFWe7dZD8iZzINL6XrC/yglSKzjxGvSZgo+y53qjflb4?=
 =?us-ascii?Q?3VrVNcDEkGkdo+VweKauTbGCQ/dpND+/hUIC4fNjsPPSg0bFhkoyk/A3wOYw?=
 =?us-ascii?Q?2eSEh6N0iBE81prRZ613zcQDWtkiW8g85kN9u0gIGTWt+yfdMSZsbxR7eVTI?=
 =?us-ascii?Q?atzzNfjcM/DEL0cGOscYkDs1Y04BJ3AeBTVAyuOoCQXci3k+uRDI96ObCk/P?=
 =?us-ascii?Q?nQuWYQ3JGeYBX20iyuFJ9vUIFyzmxs2J2+mhe+0eh+FstG+Czx/b4N7CQwoZ?=
 =?us-ascii?Q?Qyq/H6YjRoyyLeL9NuqVH2XATL9WMd82m/McuykaHv+899bIY6ESvVVxUowc?=
 =?us-ascii?Q?M78v5dABJSEOA5hnbFOYSG2G2iDTRcIneB5i8RjRxpadPjPnytwoTl/+9JY2?=
 =?us-ascii?Q?50qPdLFQWwMSGKg7eLxll+LbqsmG/UJQt9NconEM6xctR9l73yBml4EgzaCA?=
 =?us-ascii?Q?v1a7H//jzYs8U5ZKbwT1B3J69oEsrpW+3GlS7YQ8ZCdduRZ/BavF9z+mGlyx?=
 =?us-ascii?Q?rV/R/ub/TcVkPACisWOVK87a/lwTfpWDVxQRMdIpMSMXlu+A1izLsWhevCzu?=
 =?us-ascii?Q?Re/kxs4Po2OOJjjd4C8jsxttRcwKoSpSlcY+h8iFl0Jr3aW0HrXubLv+tcg7?=
 =?us-ascii?Q?c1UNukcoU+oE2NS+R0rZDrDEcfYVBmPnjZxNFubkGfsJisBnYtwwLKJpoHje?=
 =?us-ascii?Q?D2IO1y1UWJIYghzP5JUPPtFgfIWzkjs6/c9He+EWwoHnzv4S5+IpUeGrhQUk?=
 =?us-ascii?Q?L0qtog8knkFVfZkeDN0eUqYY9jJvAAVfQ+wmV1tW5Q5ydA1hFOiVXWGBKbw+?=
 =?us-ascii?Q?QXSxUtP8pYsCyy4htEDOejKT31GeItmiqHedc0egXztD5SI8vEoYEOe8f4ba?=
 =?us-ascii?Q?jTtXkQteKYkYIdbLHw5i/JDPYUTPdzej/6gI0eK77bo14dVCw3ef+TdCFSDw?=
 =?us-ascii?Q?OtKk3Bo3WaPA6uXGjaFAr/J06v0qNXcGY8x5Jy952RQy3jxU66Owj4egAFsH?=
 =?us-ascii?Q?vC+KAkCbX9uYIZFE9/UBLG6MPVh0i6TsO0fXl2gTm8svVu+s6Sq5B5lCyCm1?=
 =?us-ascii?Q?wf7qkcDFfQ0nfMiu6a96J0aobW7Mh8ouUxZwdecRfH51xLO7q0K9xG08eq7L?=
 =?us-ascii?Q?VtgAK9a4M3cpblFwBV3PAiQI0KeB9es4r3ztdscqoKsdUG1S+jzo1v4Xp2IR?=
 =?us-ascii?Q?c3y9FcZcOGhHLnDxNqtBhjo1u226rJhkdBAyHvgbz9NoChKXRcgEQ9qPxUuv?=
 =?us-ascii?Q?e1a6Yjrbo1uTjSp4xZw2vQbMm4cyzopljDd88pmEDUwWO9/Mu70sTYfbZHh/?=
 =?us-ascii?Q?rAILvfnjdNwmB+Zbafd9T2dnTJAHDHLVGuvlDWuf3kY5fAuqG7NPFTBFRNqm?=
 =?us-ascii?Q?f0dSArMxw2r4u81omBUY4i8JBQ7BHI5oOAeNUp1MqwIvfc5wlnlWDODeuWY2?=
 =?us-ascii?Q?aUrpctml+bJlHdebCFib77jgF5YAbQo=3D?=
X-Exchange-RoutingPolicyChecked:
	LULJqfVO+bJfS/8EWKPLaP4CFozHpI/PYj9qx98XjsEEwLE/Xfpv19kIbf9CXW4OUa3rJo2TlKGPf3r4q3tKQXjUu9JCS4PzA6BLLstdQBgMBSoxQX3ZnlPIBYAIe36JwsMRkSgsbzZovY8g3xZS7O2USlErWlBJAOdYjucTSmg2OmYhDwEPqg75YSBbEu9QDufJZplSrSh300//wFdo/7SCNYFpW/qpHAUjMT4GVFoVoL/3w/zaQj0SBe6kij8WxzaEDPkfWbwtgrRv888TyeHeWMGKHvkURd8Yah2jk3AjEp345L+5IaNr6DXQSfAwVDQMiyxfhvxrZGJfJyib1g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZT8Xp1+UV2rnkRPm98hz8Ged/Zv7VpIScCJi4BXsZR4OvZ47zJw1OjJtQkQGB7BE1lXPmJQZuhGKVH1+CxjF318d47vX+gtW4vGxbj9+stj3Gi/zx1GxUD4LhAuuNWwea6FrFBRf0oaFNjfvnTwAr/GX7lM5gJuyUkotX36wzySlFolLQaSlrSwGvYuaPrIiXHP80qQG31HD+NoMQ/06WqlkruByMNqBH+NwmYcMFb63jrdGiBfqxLDcfnNZr2CrS1LcVGfY46Rq4H10opXhH8VbSIybFMHoWO46n1BBHsQgECyJuG+sekqY57Yghe++Wy5FU0nBWZUD9EWbbd9sxnE/irNdkeflK9nim3Bz2l2ApOqhJBgmrghalhOs0bReIagLP5tkx4J4EOIEsCvh5LAwSmRvXUqBLWH4gVAfs6gS62f6bUUb/iSPYL3hd4ZvYqc3E3dvsbUJy3B510ZI1AhBZ2rNpaesRmK5o7rG2pwPDNFHSQOTC1dOrEtxNl4CUq5wor0nkQdRTaJBehdhrfkh7nV6eSh+07e1povMZG7tvDrECRWjuk5GyBEJdr6JijmOBu41aB7C1lSodfdWzi/gZc1+jHa6SHUYfoUDCnQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4c568a-9629-4f52-ab9e-08df08163ffc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:16.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xV6B01OHfaXGntd1UPiCq9TgimImykJw64BH3K0Rpq6bJAZHWeR7QvBwN7GtN/qgQMV9IEcXiyGoHn9BCbyHmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Authority-Analysis: v=2.4 cv=Vp0Txe2n c=1 sm=1 tr=0 ts=6a96ad02 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=DHJJM_rHgSnfI6yttmIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6ConmEBtOHHW
 n4cGtLNGTV3sE8NcDluPMQoYLAl8JnsJLR1jW75zXwPWCslPsW7CpQUicwtVc81+2AJv3JDwABJ
 Bjf5ETm1cjaikvYt3Bhfeb5XFvqA6W6X5Vduh73J0mIbzHhMknj4/4YWitLAjkH/nqAxie/xeU4
 TewzFBemL8asbkd2+WHGOPpq54du3NH1G1VIFxiXOw3BbluoQItSZ7vsQ6q9UyvVdb1Hc04sNA0
 zrlC4msZ4sbSetlOHKbCCNoyypaPBlcWHsJrsacJ7uI56lg0j15UPSCeq/rmppjOC2Nod2CHnMm
 LQ1rDMODq4r0f9t/DHuvDzxxL01yyzeJ6fwTWEyKHc8wPv127d4yNkMq4bd1/aikfK81Iny1Ytf
 EGOFZyOjwwTj6yF8PbnB/6Eeg6J0/qrQb/YhOLCZC/RwM6xJA5nwC3Tta5oWMrRPyov3Sc0AJv2
 KRFaCAlWc4o+JTCl3xA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX3BVfuD4b1aOc
 Bb9SbbZZCduJAkvuM1EpzUYq58BqO6GRPnasgEnwDu5kyTAW2xupi7AxeeURGKyCy0jjIz3PaiC
 CdVjShHrPhZbzL1JLGkLu8LINrd45Ed7PV2Yx02xPzINKauVF8sq
X-Proofpoint-ORIG-GUID: 2KRXT6ARvAbTj15ku-lZz0lPUQ2X0m2F
X-Proofpoint-GUID: 2KRXT6ARvAbTj15ku-lZz0lPUQ2X0m2F

From: John Garry <john.garry@linux.dev>

Provide callbacks for .is_disabled, .is_optimized, and .available_path.

These all use scsi_device.sdev_state and scsi_device.access_state.

Member scsi_device.access_state will be driven by ALUA. Currently
only device handlers support this, and in future we will have core
SCSI support for implicit ALUA (not relying on device handlers).

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index fd28667792472..b9f6b1eb3c883 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -321,7 +321,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
 	return clone;
 }
 
+static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return true;
+
+	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    access_state == SCSI_ACCESS_STATE_ACTIVE)
+		return false;
+
+	return true;
+}
+
+static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	unsigned char access_state = READ_ONCE(sdev->access_state) &
+					SCSI_ACCESS_STATE_MASK;
+
+	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
+		return false;
+
+	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
+}
+
+static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+	struct scsi_device *sdev = scsi_mpath_dev->sdev;
+	enum scsi_device_state sdev_state = READ_ONCE(sdev->sdev_state);
+
+	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
+	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
+		return true;
+
+	return false;
+}
+
 static struct mpath_head_template smpdt = {
+	.is_disabled = scsi_mpath_is_disabled,
+	.is_optimized = scsi_mpath_is_optimized,
+	.available_path = scsi_mpath_available_path,
 	.clone_bio = scsi_mpath_clone_bio,
 };
 
-- 
2.43.7

