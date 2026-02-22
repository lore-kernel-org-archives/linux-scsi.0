Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683E735CBA9;
	Sun, 22 Feb 2026 23:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802997; cv=fail; b=u40xgL4kdDA4p204VepW1Hfcqj4uVoi/BhJak2W/yjgPQmNEFgrGGTBgvBQ5snNpOUIFC+UH17c/tvbjI2bj1jKnramm+NMRMUUiBcinmGpY7FaL7isiyx+JTRNu5qfloiGXjmVDKFCCuNm2wqUXPWKqCr1/4yncrWyZYOIV504=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802997; c=relaxed/simple;
	bh=fo5B7HUjSTmQfbChae3yEEbeUvHEiBa8yL3TWj+Q8yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VorEPS1okQv2QlksjpbW4q6J4x/k9asaWkg/8po00GBmZLLQfd52+7sNAMLjKxHN+plpmJKP6bkuLnqpI4yq3JKW4zFMcnaG4uvT1W19G9qivI9MIs+FfWUY1Egx9/gHYI1ADArE/HQOOirQ+DvJmW5MK0aw2p2LXBejqGaHsXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qXGRuLnW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZV5kPera; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qXGRuLnW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZV5kPera"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MLVFFk056081;
	Sun, 22 Feb 2026 23:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6HYH9PvcrM6VnQ14/ARjOUUZUoSNf/ypl56tAOouOQA=; b=
	qXGRuLnWfiAW26ta81s19ifvJpPxXRk0QA0b1pZsWT2JPI008xbm74J9DzhJmM4r
	kIFbX92yGhDaDrcEaQhwLcsNrSL+AKenYn1ou1Yx+85tpJabtET5mnvl4R4oFNna
	fP08KG9pATo86bwRHHMQ0JQFoh4bv1bj7uU0LOYp3hB8iPAoDwJTHFiFh9WZdFfs
	hpOGuwZxBBIWYo5JIzeIi9LHX6pnS4JSyEJT9LklDy/w7YCg8dsxak5CW0k0sIPE
	GVui9tGrcev3BP9kJOYuZXBs8296EPf0hoZ+fZqh/4gm0DdOk3h/n87Ut5pBT8d4
	Vcy/540gg7jGYvc9mRNPeA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7sah9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61MNDIqa028450;
	Sun, 22 Feb 2026 23:29:55 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf357pyvg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mGGFUAMYeKW6Xn6b6SOpRp4fu5JaPiKNdJzFgrPCQvDsOM6kxfHDznUVs/c55Ki+W7huKWbET4ZHYNIaLp4+VFNWdSahz4CokLW11sDkqcCQ2af6igkxrePeSLGdx2SoFB+6yC1Xs9TTK81ZDJX9mKykwYWzBqBawM5+hCoEYYgjFJOi8xdF8OT0ikKDmIMI9sD+vKIE84iHwfBp+zLeX/RST6o58hlkMX+3pyU9JPwuhTOWYjIdSMyUm7Cs1pSWePb1Stper9fzhckRdXhhdNlaue4SyMWq38uqIp7txXRWQ1yfIKFKnpWgkzCC64azxp0ut20qKLSaIqDaDXqtxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HYH9PvcrM6VnQ14/ARjOUUZUoSNf/ypl56tAOouOQA=;
 b=n/YszDBLA0QZYpVanJCWpF7+5TbR+/gVuwwo4xyFnK3Lp2eQCYcg2MYFaop5CZyvYU/zfCoXkWA885unS8sXNGP50BsIUD7QEzDKAi5ByH9qIKWpz5IFr9YiOrVY1onu0BpSDnd6aFSFYcYAXNc0WhAtnbqvvDa5QSFWSqOfnukZAIhecsbYTn4gsOBo13mq7ycDMZoe23V0qMMKG7/LXuxH5XvOpqL49Cy3gVoUaAjm8JTUW87hja8AEnKlabGR6jen3aZBlz0wMPCGdhBEG4gNfD1wuGgMwneoRyYouL5vnW8g/QweuGG0YnhwurYyH7tSIGR2jdJlLEpvbKBcKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HYH9PvcrM6VnQ14/ARjOUUZUoSNf/ypl56tAOouOQA=;
 b=ZV5kPeradyV7E/YLqgNuK8y1qA4zWEVoxLb8glCxKSw4Utgp2Nmo2vilyeOISPzR7VL/ZBUJTmQeDHIG+W+fYaq9IHua5Ll5kzq0QVn48aVRft9g21/ZEI2HieWF3m+TUPP0EG2qNi2FygF74ELsjoVAoSwGjvDTTO0CnrqTyhE=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO6PR10MB5587.namprd10.prod.outlook.com
 (2603:10b6:303:146::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Sun, 22 Feb
 2026 23:29:53 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9632.015; Sun, 22 Feb 2026
 23:29:53 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/4] scsi: target: Allow userspace to set the completion type
Date: Sun, 22 Feb 2026 17:27:03 -0600
Message-ID: <20260222232946.7637-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260222232946.7637-1-michael.christie@oracle.com>
References: <20260222232946.7637-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:4:60::26) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: e441263b-2cb8-4ce2-e9a2-08de726a47c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9E+CE3QaXUpeITin8Q/Lfhn/6ZJhY1piMBU7kOMVge5GV/m/MSwRH4DKBPc4?=
 =?us-ascii?Q?T2miK6wN4+6Gy7VzSn/meLU2NZw5GI2r7pnPuNbWfkFYn6PxMQhTKggNlWQa?=
 =?us-ascii?Q?bIhBWWIP8MRH553of7OKn0S4/9TKGubqHpNpz9NE/MkxLR4+3bmNQXPoSqXW?=
 =?us-ascii?Q?xIWdBhtYlUdKFwVmjzdS5ZXsIBaXe2u0lPND7UVpvp8a1kalxq0f6r82BhZo?=
 =?us-ascii?Q?SZXjRsClNFRZKoIN6xB1kaxRjeKsooyU7Pn3KQ9MnXFxHx3dpPMLNAK7WAgd?=
 =?us-ascii?Q?K51iNADm8O8VQvrssrjt3QwNCFs6djnLyY1t+wSGDKUOuoSkcbTfGu0gvlJp?=
 =?us-ascii?Q?x1IOPQKBkfumRaiQZKya4AK4PY5QnUliwf8UZx4/zv+HDwZZQrdl7RHzHKX8?=
 =?us-ascii?Q?IBgMqamDZRjzyiiC41LH/zmlOOoBysLnAK6Uro8H/YUon1cKIc8IxYcddSAe?=
 =?us-ascii?Q?LKZC4odxyzEPEAKSHr7CHCXc4NXUwavE5IRPwifnvrfMyfqMz+WF9nxkxQXL?=
 =?us-ascii?Q?jPE+Sy/oOWPrmxsD82uE4ur20j+ZbNHtIKNi+MlN4+qd9EJKJcz4nEAeMX1b?=
 =?us-ascii?Q?gKAc8W1gan91tmRVzDWMX/vydaGG+6vajiqGj1ihBk6UxtZsW37R2xbJK1qP?=
 =?us-ascii?Q?WZSfheF1HozTIcCJuvdaYYYprN9p/FVeog2UVsB+ngA1xR2LJqDk5YATwTO4?=
 =?us-ascii?Q?VmbRknru5zCqLRBFFH/FXj5WKwoVbL7Gbi2nSDBRs1DWAB3DL97TAwL4qozF?=
 =?us-ascii?Q?dfBtLKn7mDISkpixvEWshQg1MxR22MuxVKhc3YMqKrnIuHR4NDU2L4HEJCmK?=
 =?us-ascii?Q?b8mHoWTa9wwtUqeyT4J0KlKyrQzQY2nW/SIxmxZKXptC2GGYGkPVdPi5D9mQ?=
 =?us-ascii?Q?LQxhwJkATbrqSyXRIxe/Xspsz0uxaGehr7PQrTTQinMyHeyMYKxYFsrdrDat?=
 =?us-ascii?Q?B3RiB69+8YI3C2y7sCd4uv/nwRXbjU27G1cBvSLsEdUVdKDL7vaCRVxwn2S4?=
 =?us-ascii?Q?Dv7jxicZDybrMde32R7QzeLjREbyDMHKsYAD6fXzAcUTEBFIuahRSuUJ49Ji?=
 =?us-ascii?Q?06XhK0J/axNt0a1dbkkkTmw6ibuNtQygYLEMkTrLSDK2vN/t8MKGltLrKNOd?=
 =?us-ascii?Q?cFBopyxGLuEneKE0Sj9EgS/vRtpYyPimBRjYq5Y3Peo+4hg0Rz9P7zBTT8YS?=
 =?us-ascii?Q?9UDP53ZkG9BU+/uLOa/tUfredIBGYt9ULOxZIDaBuQNyOsXnzv9vEmeu15m+?=
 =?us-ascii?Q?/UG2NcAKy1fl60OBkM4QS7z7KA7T2i+OBEck/j8QBt0sdNDSi+aIQALJ8KxJ?=
 =?us-ascii?Q?CoMeQaaiarlMJ+cTaHuT1mAMqSDEkA2M98WUeCZe7DW/aoMcQAaKpdJo5EY/?=
 =?us-ascii?Q?eC+c9zLXyc57nd7BO7qK0iHnN1PAxYP6JGmeWRkse5o8dmf13pBxSgylNjcu?=
 =?us-ascii?Q?71qdwRr0jF5T2S/oiHJOUaTnGyoEbhiOiNAgA6o4IBww5/JhkABmFgO12RYc?=
 =?us-ascii?Q?DLVw6r1a1i7OAXejgHEjv8aNPTbT56bTVlAp7+D7kiDDWaUqoFcTWahJu5cD?=
 =?us-ascii?Q?KHBkumB+sdXuT8aL5pg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?13RIVfj57UgW7dGNI7sxqCHFj66znmYA6pBXbJ8uDSPXeMbsztwX7PmpburM?=
 =?us-ascii?Q?L+Wxq9K2B+aHUv+9aOMFjlObdPKMIxuB1gltKRPGRH7kmSfV+nSndQrhtDVS?=
 =?us-ascii?Q?J9httcTiIblJWOzmBr4wUAACcs0uM5gpiKqdo8JeUmAIKjobxK3/jmii+yGY?=
 =?us-ascii?Q?hceJcGDbLhcyfoiFdfTc+CwZTMoqlNtwLzH3LKgEHXASsUZ7wjbgMgYgzIC/?=
 =?us-ascii?Q?PZLGBGTjsSOsiqzAjKsCCEiOxznx8waNMFQelxHHCjB6KRFpjHzJc0ZUM/fY?=
 =?us-ascii?Q?AniJsyuk+ixPeHSeSSLPLv5R8MM3m3lZx2R/AVhnMIoayX6L+CnvH7oCMa2k?=
 =?us-ascii?Q?+efahoKl63cZfPce5+F81V+mmjo1afjg6toD+O7neJED4bMafdMWnmxGWR39?=
 =?us-ascii?Q?VydsVYGeOPMrN1OSiOZxYJngAhhfKZlRfaqmbOtraxLOUJgDKv3wtCoRweKN?=
 =?us-ascii?Q?AXzwbt/Gn9NLXbmTTH9bCIJ0d2LUICVHFQre5bExlFrtc/MAWEe4MhhDihfR?=
 =?us-ascii?Q?y3Mo0VdoQxq/mTa8KX8ScXR4h3YmaG7nAiGj+DrC2/FI0BFcyp55oEP8UWYG?=
 =?us-ascii?Q?XCHo4p2EO8cVT0W50LhcayhsYCDNbJJRlzvUCiz2NV0nFp1uBdpIJxqHq5B8?=
 =?us-ascii?Q?n6mH27N9i7TxhoQ56GEepwVCQAGd9Sr4LrTosaZYvBztpWeAhAmOlmobN7vR?=
 =?us-ascii?Q?cenrJufSS2KUjqMf1tmzqo/jgsWaqkS4z3eLlgAxy5eRBoTXw0JdM9/PxP6Y?=
 =?us-ascii?Q?4sOgJGrPB3AMckogXfPSQM033cdeXss40Z8IBFWRHFe7+dZrE9Jki+BngLZ5?=
 =?us-ascii?Q?1qyYbJl2o+8mb0Ep66ITEUvxSfalA16uRd1IKAi8K9DC/CS1q+sVvVqC6eQw?=
 =?us-ascii?Q?oWifi4m6MFmcKLAyh1BAuasGSaQdyr88hosNrLQxEWYurR4bf/UeabJ3rOyB?=
 =?us-ascii?Q?kUWDSctMhJZ9JxqXE6vYncCQgMogOClMv22EeXa/PbyxtHUjAl5SiDWRnVZn?=
 =?us-ascii?Q?cUWa0TS33oTj2BK5Hx9f2ea+vTctSMmoicBg92sWoSUQLzs1tc/rGw9ZOyif?=
 =?us-ascii?Q?+qJ/2q3mtSEccV6W+lveeodvU0SnMvGL9/NRe1geo1lPoDPYlEocwvbHo0cx?=
 =?us-ascii?Q?Qt0phu1w4+aWrl+8sOUPE82+iWjDO2nWrjAm8hdQUQhk7pOOJ6/wNpV6CTvv?=
 =?us-ascii?Q?FYB2oSvPcW6jLuFmlpq77GGqXj1MuC1YzY/6EE4t/rP5dD6mr+DycXwZ+FER?=
 =?us-ascii?Q?Zdw3tsIEHC3C2F3dRltMjLHohq1UU4UW2RR/6B1ZpJsTCDsvSMCf73eKH8aV?=
 =?us-ascii?Q?SRZprCh4IxNIJx6kWk6chuQHYYU7Gu+LBR2VoSl1B6mDkeSpnvRZI90mCu3h?=
 =?us-ascii?Q?B2rubN5drMZBh9IVTkTJNsmXsiWv0AKTkg3HEQKuiZiJJGeHQ4uHVzej650R?=
 =?us-ascii?Q?GlkwA6mf207N2Sz0tVbfbUQdpDAZJvjBKnLsHMQISxYFwTZsvf7lIe1wC0k3?=
 =?us-ascii?Q?sJ+BG/LPHSLa5g5QE0l2mydYUQWAGklvouyYUizLyFcooDdnU/3/qN8vJ+uH?=
 =?us-ascii?Q?cWPd3KCWrZEhKyrtOGtruJiwlus5MDDvhTrX71PrzTIYpqNZFhUt21qqYCep?=
 =?us-ascii?Q?6ztk8ceT6PN94gpMM1z+ytNxDy7NLVEHWUkmHG9e0bFCTHf9FMC8KAmesXB2?=
 =?us-ascii?Q?P7s6xblnDTWFhUq/MEAjwDAiXWGx+A0NGym2C16y44Ildb4ap4DGcikWxk8y?=
 =?us-ascii?Q?Gu4SwYgF1yW8qZTi0kVXUyOuQeq9vTk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pk0TV4HD74wzWn5FFqqsqCpbrH6fuiEofNr9Bb4jWxmO3ZcgyyWOStDqM1AjILnsN4yP0Z0PQOaydZAdipGIplo5gPubdKxU9NcP0f7VJd7iM0J/PJ/vUXxWUmAHwC2uiBg9I2Z60RqJ8GqXrZMp9vasOKxuUIpgAXJ+ZftuFnmziieW7c8PWLR+5ccDX5E1EO06oVinBNK51dTDRhNcpSyr5e62cqYorHPY3l2n7BytMmr/g2y3NJdg/LnyP8gt193WD3h/3x3M1O/2AW1vMXadRj8ERncDxQxKohrj+AtdS+a6U38MOpjrhs2OslsyR0Sdo3UrQNjIDiADzsfxgKtEpZwZ7sPRkhLEQZ0VOk3zlH7JkwtEUuhfuqGZyJSsYgNlo21v72DFSB0Q/Zv6mNaFGked/1agG9QmGV3K4yFfaqyUn5BDVKtU23bPmt3SeqXs3KX0MUvEuEM2vl6to4LQphBM9i6yp5ZITmwRSIEYIhtudmB6eYeXDRS1OIvgOMZ+rc4Yn8WRvHQ94cmab7q5lNdkx+8jLh6ReCNaPLvhQZu9rT/QfVZgHGbHkXI2iHS3kvB1WRMAzNkqdUnXStOxwsynucnhOQ7WmM/UqNU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e441263b-2cb8-4ce2-e9a2-08de726a47c9
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2026 23:29:53.1093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOnwWHoQ3IwbaQVA59+0uL5jZF/fI56DrgZ4FclICYffjdSWQD1734JguLsJ/ZhegxbTxYh9/AK9XG9OKBR1WN6eP6T5ghwHwe8K43OUo1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-22_05,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602220224
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699b9173 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=m5ZvfLA5-aAl7a1B3BsA:9
X-Proofpoint-GUID: kNHccxxGYOlFPDK8gMDexYoJXQ77ZYM0
X-Proofpoint-ORIG-GUID: kNHccxxGYOlFPDK8gMDexYoJXQ77ZYM0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIyMDIyNCBTYWx0ZWRfX1YFHTH1y93Pe
 O1L5tILAJ1cLhZpngDYlhO7NdJD0qhRyTdIokioRxcOMnqaD9AWeWKWrvWtuZ7WvUVyn69dN1AQ
 R/X94QyAKY4DHatza6io6c5ABhsWE/KGfdAcWnVVvS8QByE9mhEu2g6h/GnIyHs/jXkSOxzP/Lx
 2lovu73JTlg0Dg/+tzDbVjfj8lbtIVFn25rGVz8eSCApHnFeyUnkHkRxPP5cthy4GEi9WsfRfdu
 3qeS1tvuiA+Novmxk+4nln05vbK8exrNVBiuij4hBLw/ivti9hck710LP1ad8GRqZ09F8NjZtvl
 Yr7GO6uU2o89NUq+Q14MZx+VO0DIkiRRni08YagJvthwM1L1qRORIAzXfa8InNQ8lRWSQPwzRHu
 SSYY4fmvM+Uzkj6C3v4/LE4Kk0Ylu4/ebv/ImC3c8IbKlrxwApU1l/mZmRc5YrpzD3OgIVoJjEh
 lzZVdR/eHOEmqpufO2Q==

This allows userspace to request if we complete in the backend
context or the frontend driver. It works the same as submission
where you can write 0 to 2 to complete_type:

0 - Use the fabric driver's preference.
1 - Complete from the backend calling context if the fabric
supports it.
2 - Queue the completion to LIO's completion workqueue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_configfs.c        | 22 ++++++++++++++++++
 drivers/target/target_core_fabric_configfs.c | 24 ++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f7868b41c5e6..1c1c83c6752c 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -578,6 +578,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
 DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
+DEF_CONFIGFS_ATTRIB_SHOW(complete_type);
 DEF_CONFIGFS_ATTRIB_SHOW(atomic_max_len);
 DEF_CONFIGFS_ATTRIB_SHOW(atomic_alignment);
 DEF_CONFIGFS_ATTRIB_SHOW(atomic_granularity);
@@ -1269,6 +1270,24 @@ static ssize_t submit_type_store(struct config_item *item, const char *page,
 	return count;
 }
 
+static ssize_t complete_type_store(struct config_item *item, const char *page,
+				   size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	int ret;
+	u8 val;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val > TARGET_QUEUE_COMPL)
+		return -EINVAL;
+
+	da->complete_type = val;
+	return count;
+}
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1305,6 +1324,7 @@ CONFIGFS_ATTR(, max_write_same_len);
 CONFIGFS_ATTR(, alua_support);
 CONFIGFS_ATTR(, pgr_support);
 CONFIGFS_ATTR(, submit_type);
+CONFIGFS_ATTR(, complete_type);
 CONFIGFS_ATTR_RO(, atomic_max_len);
 CONFIGFS_ATTR_RO(, atomic_alignment);
 CONFIGFS_ATTR_RO(, atomic_granularity);
@@ -1353,6 +1373,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_pgr_support,
 	&attr_emulate_rsoc,
 	&attr_submit_type,
+	&attr_complete_type,
 	&attr_atomic_alignment,
 	&attr_atomic_max_len,
 	&attr_atomic_granularity,
@@ -1376,6 +1397,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 	&attr_alua_support,
 	&attr_pgr_support,
 	&attr_submit_type,
+	&attr_complete_type,
 	NULL,
 };
 EXPORT_SYMBOL(passthrough_attrib_attrs);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 13159928e365..cab48c372e8f 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -1065,6 +1065,28 @@ target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
 }
 CONFIGFS_ATTR(target_fabric_wwn_, cmd_completion_affinity);
 
+static ssize_t
+target_fabric_wwn_default_complete_type_show(struct config_item *item,
+					     char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sysfs_emit(page, "%u\n",
+			  wwn->wwn_tf->tf_ops->default_compl_type);
+}
+CONFIGFS_ATTR_RO(target_fabric_wwn_, default_complete_type);
+
+static ssize_t
+target_fabric_wwn_direct_complete_supported_show(struct config_item *item,
+						 char *page)
+{
+	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
+					  param_group);
+	return sysfs_emit(page, "%u\n",
+			  wwn->wwn_tf->tf_ops->direct_compl_supp);
+}
+CONFIGFS_ATTR_RO(target_fabric_wwn_, direct_complete_supported);
+
 static ssize_t
 target_fabric_wwn_default_submit_type_show(struct config_item *item,
 					   char *page)
@@ -1089,6 +1111,8 @@ CONFIGFS_ATTR_RO(target_fabric_wwn_, direct_submit_supported);
 
 static struct configfs_attribute *target_fabric_wwn_param_attrs[] = {
 	&target_fabric_wwn_attr_cmd_completion_affinity,
+	&target_fabric_wwn_attr_default_complete_type,
+	&target_fabric_wwn_attr_direct_complete_supported,
 	&target_fabric_wwn_attr_default_submit_type,
 	&target_fabric_wwn_attr_direct_submit_supported,
 	NULL,
-- 
2.43.0

