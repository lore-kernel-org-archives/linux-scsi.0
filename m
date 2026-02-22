Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E445A932;
	Sun, 22 Feb 2026 23:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802995; cv=fail; b=Xsi4e/rT8anoWRwx7Vo1nBAV9pG7aZ+nKs3r06/fGBKOWYSTNGMalP0J+ccTndv8doTZbNSq/USsB5D9pdQoK3lSG15LilkGQNFU2ULdvTm5hBnCqnm06j02jLZmp3lmre6zELCSS5JMQC6+ZJifLC8Cn1PoOht0qXVy4twf3bU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802995; c=relaxed/simple;
	bh=I3B0aLYCks7NHo6GhTntYiwlmH9FYa9qlWOss+JXcOs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=F52JKs4oujrEqiMy7+j4Sb+m3ZAF42u6Opk3gsT9zYglHMeDYQRUdYtVMf1LUl21cWt4rMo4UlW+1E6Ir31LI4R1aPnpaz6f3hX8yywW00K6GHBSUofqzdMHSehN6ZoyJWY20TmKohC4pAzGQJpA1N5wMa4Mp0saXt2viPoJ58M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=afRMPurH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0Cw0hRGO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="afRMPurH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0Cw0hRGO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MJYHOu071933;
	Sun, 22 Feb 2026 23:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=I3B0aLYCks7NHo6G
	hTntYiwlmH9FYa9qlWOss+JXcOs=; b=afRMPurHO4MCnL7K69LZvd5NHox0LcqU
	2+Yjt35Rf5lHIH33LwjlfOYOhnpJzy3csU74rT5goZCoD6/mtKuMWJnA0NIMe8ve
	U9HPvw52fMtX66+8I7egLDcDBpOzMpACW5AX/M+/BYrugL5mpRGjI5F58KCKWq+p
	v/dZUFzJ/i1rdD1vs/O4lyXxd9ZKuNPuT6ImrIjwLVYuejH9wmcmfkfIPeV5mxH1
	ws6hEGfWhnIn/rXseKGz5Ezclra9lDKTxX31IoQ7dKDAACWr2FCK2zmUc+ae9Z80
	4mQbfgD0A9K3lC1sTWgT4ljB6Ug1mW/2h6hkc487ce62e1TdLtcyhA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3hc5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61MGUg8C028459;
	Sun, 22 Feb 2026 23:29:51 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf357pyv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aeN2s2FpOn1rnIMXbdvfNANcYlbze4Q/Av3569M/KSz5lqsB4txrmbsT71MZOGBOn4DyeVk4oukXxF3a1EdOBpk2c5T36vd2f8rmWzg1ouqhUc6WFh235Qg11Q7ubZQoWdnxObMNvWsCaNnIk4MkWG2tz2G8+J1k86b8OumQ5zqljQKLrYueRF6KkRFlOEufTAmmCf3YAoIeqHiuLkM8V0os8bH2opHfgHrjxTyLDxwKaRdTte2Jj59sAhH7dtD/h2Z40uLp857sRIkQK5VkLGvzZeA9slR0gu2MwNvjyCsul860TCBB5Bm1jCbf1MKHH7Ofhpe4D6y84o02TalxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3B0aLYCks7NHo6GhTntYiwlmH9FYa9qlWOss+JXcOs=;
 b=I7KiaMgsTUkpNe/60IUyqYDSLjfK26oSG5uNsk5urk0lXQL3MZxvpHFgpr8FR8a1hifaU4HbOVJSTFTBeQYnYNg3QtIJ2JEoWpDy3rGUaKogQmbCXC8ez3zWNJM4S2k4/A+wuWmGDdFtlwzoE6CvyfpjCKh5eVPXJEyEyDBxR+hhgUP4KfJD5BxGQocoWwGTXtSGncni3u40zuYFBwdEjJ1570bMPu3LCbUjV6WuGgGn3rc7IJsERCQ12rzylFq6DxI9S7RrgJTxbWhoWweRfUb/SghNAzPa+SwzYOBDISp6pJ1SgZEUeO4rrRbuoqRhddgxU58t5X30MNPpxy4UQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3B0aLYCks7NHo6GhTntYiwlmH9FYa9qlWOss+JXcOs=;
 b=0Cw0hRGOcxvYIfR2fRuk1PRj2b5XTzHYz2QWsK+J85EziSalIm08tDh1a1WpGXOA1d4qbflw0qfsR4ca1GEY6NctPVT+KIH8t2FMEmhar4PRysNRoe+EyhEcrk5racRwqQ34s/ZW3/V8BoGuYCPl5k67xvVckl6WmMG9mFQX2Ds=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO6PR10MB5587.namprd10.prod.outlook.com
 (2603:10b6:303:146::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Sun, 22 Feb
 2026 23:29:48 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9632.015; Sun, 22 Feb 2026
 23:29:48 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 1/4] scsi: target: direct completion support
Date: Sun, 22 Feb 2026 17:27:00 -0600
Message-ID: <20260222232946.7637-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:5:60::35) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5d638f-5fb2-4e5c-e03f-08de726a450a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rJ1zMaTSVQlomIj4e5CDztYCwfggZsVNhvdcISuttnCyJSthXcuIpk4SE06b?=
 =?us-ascii?Q?iEA9rYppUE0xc3kEYw4GGF9mP02O9uaeSzcbrC1wPBUIQj8ebAY1U7NbKu8g?=
 =?us-ascii?Q?+JvO9p0ytoA9zZj21SOfz6yRoKOTiahAvrCaWG0gOWVRMK2ixKe1lmmtfSIZ?=
 =?us-ascii?Q?8WKbF2HpMzegfTGgmWB6ZpjphXmH8gRvMEjxpbEtktO9SfXCaOxUMplbFAT0?=
 =?us-ascii?Q?IfCjZVJog0JxMsBuyGmtJN041QdGLV2tS8mnfivZ/SQoYnsy4Z9Quviy9VKq?=
 =?us-ascii?Q?+O3K0woRq/3QpBLKSusTL5i0hHAGXpGk3ONT/OadVHpyaT8ZmXhAA0o6ko1h?=
 =?us-ascii?Q?EMM7qq3BP6WARaH9xqmQsKUrf92kwbxlgWxkMKjEPdjjXM2Uxz8EourV6tzI?=
 =?us-ascii?Q?nUPwlLEt7RJJXM2vPzAzSkZdjTFyVI2Ney8wBx1ptEyAOiA7STEGQHdmMc32?=
 =?us-ascii?Q?vSn3PC+biRDxf/VZK3o/6Gst5HtN4mqlrWjOHVr4ba6vMolIgJO9CqbOGy3A?=
 =?us-ascii?Q?zH8Ht2NCcPSH36xpVdEWsohoiCkpbLX4xBmVgDrWjMn5Na2zxI5AOt1D52ZM?=
 =?us-ascii?Q?ozbO+S36EkS9WtDvEHQ2BiKVYLskOigoHe5P6UXLHtePao8PkpQqcAxne3MN?=
 =?us-ascii?Q?kc1bhRkuPJBZdxrn8ndlYc2Ui8z+ervXxyVwh2LxuC4a9k3J8PSRc2MQCkEx?=
 =?us-ascii?Q?9w9BCPrvOFQ5Tfd/klY87AxLwCTfuWW4jNMW+oQrWwq89mRUdO/9m8xZ9qiO?=
 =?us-ascii?Q?RMWn6Drz1rcRFneZOW2r4XyWhId899vCdj6e63fm2tOjEpES+7wNeCl1EqaO?=
 =?us-ascii?Q?3psIqKKBYAky6XU/ScP7OKp0kglvFrllHS5iW0RodPknsUpG3qx9USlS/vUQ?=
 =?us-ascii?Q?sP3Evs4iQzniEXZXio7RKpQgWDeYxN9aNOXvcmiR00G6wub/9qyFvdWMkUmB?=
 =?us-ascii?Q?C5gVgkRVlLnfutgEAWe/1d2Vn6bKevVYf3mrnTMDbmNqZ5WuZ2XWlvJRoTTU?=
 =?us-ascii?Q?7Nb/HdVavV1l6+FGljGD8CjRcyAUPVAVafcfIqBKro+FQnIdZshATmUaIyOy?=
 =?us-ascii?Q?aZN9HyixRBJWGlmhIbH3Csur8GZbFGNYPt0vkvKvKZBimd3VsRfWLmTeReGq?=
 =?us-ascii?Q?ON1pUn+nEoL6/RZ7y6mt3tE4o6O9smOndxl1KG/WRPxeGSYt3Yt91AlxjoHq?=
 =?us-ascii?Q?S3eFa9S7PMnuKLNOvWCRzqDpMGIOcFZIaflkyKpmkDQRWzWfh7hwDO0ce0J5?=
 =?us-ascii?Q?/jURou5CEa2WIkP3opEBSTOnmzOtiU3a8eg6h0c/qtMIyj6mq9eorv2BULpS?=
 =?us-ascii?Q?gsCBsIuQ4e2cfm8uzn2oY0P+PhilxobzAKRFESkzFGxRRKWvayqR6GpS9ydx?=
 =?us-ascii?Q?l413cvU3v7dba+oodkcERZWRMS/HUUWW9FyqIvbfESPIKymFeT2zDXBpzA3F?=
 =?us-ascii?Q?QZd5jBFeEfdIhOduTg3SoqLq2D7KhLuUKibZZrvfWoRCXnYna1UAeEOW+08+?=
 =?us-ascii?Q?dCFS6DipiEEVA4UdBe6QKahM4ctX3DgtCSJRVLdIzBvJJMTxr23t/9V2nXVx?=
 =?us-ascii?Q?nDKS2jYDZ8l0mkm2xrc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XUltDvwqr0+LL7TcyYyGE3zw1NM2UtFod6dwqsX7IJ7fwY0b15ZJl6QLTv0o?=
 =?us-ascii?Q?dOH64mbzHR69zkbZ04PmxRJLH7l8ofLOk1Gve7q+xDTYfZt4DGg4N4UlehhK?=
 =?us-ascii?Q?vDNmlIuDfM6kfpj2FmCXTrbjB3j7/RW54kMTiNYzuCcIbsq63uN03wQJd/yA?=
 =?us-ascii?Q?TmEt3xvIHuUoU3Ih5EzQilag9Bt1Al3BLH185yQd/91KsJQYbttTuWN7Mc5H?=
 =?us-ascii?Q?sX8bvfsc9LVo8amV6ndWQ3dg/NTAPAyP1bdGqoSKgyswYevnTSvjff/vJ4y2?=
 =?us-ascii?Q?a3O7xZYhQ/2ru0Xt+Xgo8sKWqRrfa7sjTahGAynWjbPV2eWYtVFgszqLytYn?=
 =?us-ascii?Q?qtXfS9azJeOSfAP/SuLIO0IEuu+url8W4ggPe7NUDmoeNp/cprtsNyKgfkTk?=
 =?us-ascii?Q?qn6vWEYDl3Mv+7G2sB/SMPUNmxjttqslhInbzBUvtQnHKTQ6fdhPV1JMhiLp?=
 =?us-ascii?Q?7QV3bgHOuNl577IMxN/SHgloO2whQAqz35r2btNQ4Wl1CRcioSbzcIBNhZSM?=
 =?us-ascii?Q?uQ3xFoDDoRtj9PQnW/6dA0/Wj+O9MABap4qF3uNtt2HMyY9d9psB9p+8oRfQ?=
 =?us-ascii?Q?G1l8XXwX6VS3y9aMze0SUCjXCnTJiiqw71cuYtgsar75UZrehW5rbc+0uZ1W?=
 =?us-ascii?Q?lP5cgJSc4oVvl4YmZFkfLPP+CmGVNgVG990Zy7HlVEihbN+CGqR+wzbBIwFm?=
 =?us-ascii?Q?Gae1X702n2NzrNdXV2IQI0/vl0ls+vXcnFhRugasn1PzwSRUC/j66VH22rPw?=
 =?us-ascii?Q?3mUUkKPGeuzGoo8SRTfe6POnM6oXSdOZD/kXLbZhkeah0v19jxEejT9Y4WQi?=
 =?us-ascii?Q?jVX18mzIliVVaX7RHBVX0b6bDUY42aM+vDGcbw5IcXf5NBt5O8QoANNKFfx0?=
 =?us-ascii?Q?VMPPwjmUblQE2shD4ON6ViXJjKLnafXWmolHqaAbGzeQbyPbRlAwlN3m26Ie?=
 =?us-ascii?Q?21uQSsBPo6aCU9ZvffmJENHlcyYS6Z21zdQ+FXxVjw7+IEDBQaZLsdy9qdAc?=
 =?us-ascii?Q?aQZIPUBWu4YexB3n8qmf2VBK9frRpE51QpmmP/xOM+nGd6PYWn910qzYEhIc?=
 =?us-ascii?Q?J2tyt8+vFC9LlQ+5l/oQUHRqB7Mm7cfBpyTPNsq+sIs56WqvTvaAfGsEPJg4?=
 =?us-ascii?Q?YEA87tPEzZHqkaXIVq4xipBSKx/Ks3H4GOcMYDIg1kqflMK65JJzhJwps+KX?=
 =?us-ascii?Q?NVUHULMJ4ztcMcjpHDTr2yelchB21aATsq4UqpkJC5Z3DmTfh3yo9kdOxk5D?=
 =?us-ascii?Q?WwSKnMlmzxACN6yV2LP9yLpoHcual7l2SxGKNg/22UTfg316qknV0xRmhDij?=
 =?us-ascii?Q?7ibDcd+BVc2AUWm75O71g5twmLisgQV3krZI2T25qRerdXZXa+yQuCh559jL?=
 =?us-ascii?Q?7VbjkEMx/EGe+yOm42wTpigiaa4N4ek2FKxT0erbYrJvzSPp1K9t839YOBQg?=
 =?us-ascii?Q?mfszTTmCxGt1nfL8WAYDnA7fZ62gb8qzOOtY9+P0c4+6uwTjh5atrWXUlVgr?=
 =?us-ascii?Q?Uc/jobfug9Z5ueBSsWt9US6qVuMdOT7TLf3u659v/95muA57fHzy8IG8upfC?=
 =?us-ascii?Q?kIrvgmrV7Ksnxabw2kIjpQa+AYXrxgQZ0Ui2Py57Z1Fgbf/GPaULB8/54YET?=
 =?us-ascii?Q?qVAYHYOi4LTufos+D+qWcoebN4Ct3pTm3e0misPrksTIBcsi/MMsWOLbatjD?=
 =?us-ascii?Q?fizhDqdnooiC/ztNWIVJvDIEPA7tPCCyzanuNfi/3vbNiIX5h5C4VffY4oew?=
 =?us-ascii?Q?kwHANHJIa/5dr6DfTBQaH5IwvrqI4VU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dsWbGHTv3WkEOtqRFf5cdpx0reVWQXt6hYkM4RImnnlCsPIIaC/+mjubBoHNHwJ7gX0nJOBXV8AaEfZJKnj/7/sgbAPW2VgCdxF7PDSvHeCKdEZZUE32KXtMCz9M3a53Znya7+PCqvtzrg0v7IRpz22HL6qTw2c1Ycy7vS4+qD+rMASTE8eFIJoq5NYb1VYOXwsPwubKIOxpOTNh+17Vxl7ISZEzMiQciP9ne5rH0+L+FQhcjlVgv4ey1zrjLV5+wE9g3A7D/0Sh7Rpw5zbRx7AUUH6ugt5zKlABzHRFQGnIiOvz2rIbLlu6wM3n2r+ChpK6mT9M2hDD2PFInlduo/ohqqhLQWy0B3rAKVOs/qS+ltBxesnL12qduhmN06mStiTlYDcrtA8eRExRXYezmyBrfkBucbwmjp+iBdxp11zY1M2CL+kG4Pox44L7VfH4l7Jd3N2KQDRbEuHt8trH3oUmZZpW8wH4EvmDtxTSHRGZJTkfd1vSuGqzp6fSYjl5VGqEFFGAFJ+J8mgrnjJ7oBCDcaOXcKknEjatOkINqw+OgX3dQiJv1jiy05B/VDPHWJvVDezrZHo493DqjepZ8c9QRJ9lzpUxbDyxX1cc1nI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5d638f-5fb2-4e5c-e03f-08de726a450a
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2026 23:29:48.6021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQ7Xd+/xxm6j+vnmJ6yzCjYFnmJ21jqPfWKbMOc3XxVwY1CfPlhLfu5FKdr2Z0fFP1buVziZIZKSjC0Jg8yt4bJpUcTy11U4nACbh/78XpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-22_05,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602220224
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699b9170 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=A70L1MIJJoVerDNtJbkA:9
X-Proofpoint-ORIG-GUID: 2dLRIcz9PXWxwJfjpp7Pdfrn2jyQJP06
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIyMDIyNCBTYWx0ZWRfX2uPmHE59bbMl
 i8GqEw5+GC7ljktUBzU8bSW2JxlD/UWUTnssTJX0ygZUA8lrktYy+78bvxMa4uQhWYNBjue1iaL
 eMP8mlEzPwGpvdgxZNVmy/WNjfIbsL4r1h2KHC2eOpF4n5L/I2jlCHE+A9ZRIxHiS4vNGrmTqLE
 2iPPNO0ceTJSwCMXKb3v2ZIZQ458L7NgbNl9hSByMdPVCBqkkslpU9WgxHdeam55WU9Hl671W0C
 hQZEKJ3I7Low0NgKowafHrPyk+BaLJ8A4E4gNhhobwxo9VAsaHA/o0kvrv7Z3QxpBD3o9VOEbiS
 SpRLJi9BPBtvI3gZyMQwBCUo3Oil9Gt1Gaikkm4rXIDzLKAPBniPq5kfKFs1iWaELSl5dXX4nGV
 CF/pWpxv5JI+Xg67hnNF/966rUpr6MPjU/vRW0OOLTmO44v1d4P1UGrlJ0WAhWhaa0favVaTSmL
 KnbVvHukTEJ3VF3P+5g==
X-Proofpoint-GUID: 2dLRIcz9PXWxwJfjpp7Pdfrn2jyQJP06

The following patches made over Linus's current tree allow users
to tell the target layer to perform direct completions instead of
always deferring to LIO's completion workqueue. When the frontend
driver already has multiple worker threads (or you are doing
a LUN per target with a single thread per target) then bypassing
the LIO workqueue can increase performance 20-30%.


