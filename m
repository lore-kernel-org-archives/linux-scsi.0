Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F16322A;
	Sun, 13 Apr 2025 04:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744517112; cv=fail; b=CzRYBbZHuWyBdoWGA1+1gDEOUrJpUMCR/s7NjxUUgAOu7JblPGNgXb1dOEXTeghR+ELqAwdCji3/T1P1zVWdPpt7tRniB1QhZplN2iFUuHJcSTkiAelQW6Vlcc3mrjLYBV6aj3dxoFztogbyDa/ZUnHMFSj7UcL+5iihnuRobDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744517112; c=relaxed/simple;
	bh=lZ4FQXAjWbnUw7c6DS2g4IvGCyFIq/pHYK5FWl475zk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=fcTSOs0JJHRdrebAlR9dujKZXUopEvKxGDLJSDQDCdv5RsQ6OBCk9Cdz5zlwIQNZSvrTadRI3c7qcm92jk9jWyJdHsEek4kzlgN8nCShk+XkP4r2odGKU4nB+oBs/IQThtXqWRY5fxfqOttA7PgsdHFZWlHzeC18nO0Cu7cjdIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BIuY3HhP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JXS6b50B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BIuY3HhP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JXS6b50B"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53D30hJF019261;
	Sun, 13 Apr 2025 04:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=lZ4FQXAjWbnUw7c6
	DS2g4IvGCyFIq/pHYK5FWl475zk=; b=BIuY3HhPTt9nRfiMHbyXCIp4MNnUbxlQ
	H1NcNPz3NggY8nhLalysNe+o0rAdNjNb5T1cELBjuLk3nFISTeulXqfRiGaU/ATi
	Uz4CCN162Xf3sYWRv/eCTzZNSP7ERJ7MqK0KrUNDpVuJxtC4586ZXbGRCFJdlazv
	QNFRX0f6/BZZdJZ/wPQvceiXJ9jdeW/pJ6HhrbOvIN5meRcebUw5tMHx/qngoCdw
	OG6C7R3lGrdo42eAIsXfOdH+5cV0Ainf2CthTGHyODTK0i27TH2fLPdHAn0ZgrNU
	Oi9iuqk3mq1I/3CCiCWlG6hcVIVorH/GTFdFN06/1uor/WX6Rrs2MQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4604xag1mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Apr 2025 04:05:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53D3NOej004934;
	Sun, 13 Apr 2025 04:05:07 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazlp17012051.outbound.protection.outlook.com [40.93.20.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45yem6h9g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 13 Apr 2025 04:05:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qRv0bW3bvKtCAkBN2GgvItMTd0rURH7ctHFZwzvmTcO50EOHwiQ4kYsJy030R2ntXqEtYw01TaSLkex7Nme2d+9RSqddCA5SJeQn8QLskzblBSOzzJeulX6nyrz3FJsxH1X2v7vKyxExwutrxlHaKRAdpeVt+rolfUPQ0WnvHtX+HSDEzYurpkPiP3E5T8L6a7EgKeGq7iSZ9+ZAnSL3kV/UsJbbeTKYl2E79EmRPi4hOoIb8A+T+omREEzB6wWjdOkRBi9RYr3MIj02FzdOXTgaYvIBMoSHL7I0k4AOf3SQ2rgx5wZ0+N++We0A3+FCucwqbKA61WTMyU2rEOUJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZ4FQXAjWbnUw7c6DS2g4IvGCyFIq/pHYK5FWl475zk=;
 b=XWoT2YhLoDIeHuofdWuo4RDo86QGnc0djpVrcaOywzl616ph9Qkx8cgc4EdqyockadQlgCRP58G0g4mcYYARplLbLKPigLvXzP+WdPR51TX5Z8SbO/998OkEApUcudgFsraJ6dipxRdHAe7qsDyKnwgOUwGU+qTiikYKSaadRk4Msfd7ESL/H1paSZafxUyvBj1S/tnJfrYsUbc89ABrZ90g+OzN1SaOBsHGuZYO339AZPn56bv2qn6Vlg048RYZU5U43sEdzEkEK8AuXpQALXCe+4tJmJHfqVOjaTqV3viTSoOsjiN7jDOXTlY211aPZhRvpk2VOxJIv1waIXZNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZ4FQXAjWbnUw7c6DS2g4IvGCyFIq/pHYK5FWl475zk=;
 b=JXS6b50BwDf30Jf6KLDo9alUEEDlR9GMX1wAIJN05a+KWe/CwZxx+mualcE/rChDD00wOTjyuQ41X+pTRVajIlZM1RsGP9wpxIfLyT5fIG16BgjLvxHieRuT2zaj/TBiXKFqlefZxGiuB6zdvq8ttOZzQejmix948oYsXnuBCJs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4120.namprd10.prod.outlook.com (2603:10b6:610:7d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Sun, 13 Apr
 2025 04:05:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8632.030; Sun, 13 Apr 2025
 04:05:03 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 0/2] target: Remove atomics from main IO path
Date: Sat, 12 Apr 2025 22:59:49 -0500
Message-ID: <20250413040500.20954-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0346.namprd03.prod.outlook.com (2603:10b6:8:55::9)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4120:EE_
X-MS-Office365-Filtering-Correlation-Id: 821cc681-15fb-4d8a-aa09-08dd7a405e16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cHU1j1j7FxV3E/9RJ0Ziwsa+F7BVZyB78rLb3Z8MiO2+2iWK/9GhLs3Tzto2?=
 =?us-ascii?Q?LMz9Mp/NcImPX1rnNzRNgd3eSFAML9yroYjD7sSIOdGJZCew7lf4Vq+JM//U?=
 =?us-ascii?Q?+V9I+aEr5PkYvgOL1+bS2y64uALy5IE5ut+u5woJZJA/3jDWB9IXKfqpQ5Rl?=
 =?us-ascii?Q?m1cU3FAt8IKJnIOoFYvHvWeo6tZZoVY7RK0+Ix5Fur14HQIGq0X2Nwh/S3YS?=
 =?us-ascii?Q?GljDiwSxhbGEMFZJMdeXBE/CE+yBsRT9FeTohFN3fXFO05XoJ0YkSd23uKUH?=
 =?us-ascii?Q?Lwd+rhBL2Qw3gJNnDyj6R97CKhffcRkN4G5Q9uODIvIOMbYy7Eh+jndVP5Fu?=
 =?us-ascii?Q?8fyaLHe5cWE9ym56CcSipanUoKGRtX6OwvEC0Ym4bHXjU52nCx7w0XCRtuzF?=
 =?us-ascii?Q?HxetAzOfRG2MZrJtWpxVEPBpsDncpKTaAf4sHLC0koW2DY2HiHhbYNm0BVdJ?=
 =?us-ascii?Q?r+9hT2AZycSl4HQyFxpiWhXJyeiyBYpHojIhqRw+9S9QUO5nsOv6nidxHvSh?=
 =?us-ascii?Q?+S2hDx8cyqbsyDqifFCnTAOUK5cBhdHX2yM3nxy3GKL53UDk1vuV3CbEGkLR?=
 =?us-ascii?Q?oou7qhhCuFRUpMy3U4D6rWj2whuudeL+BsSzPa8RhfFbLBswVhlI/uc63jH2?=
 =?us-ascii?Q?OcmWiDvdS3QFqexAQNoEDfHYIHKh+Ds/NpUaDOV/N/aQdL1drvbM8PLQkcpY?=
 =?us-ascii?Q?pezep5zTAYGjDpgAszmOGLpR/cbiWKoKt1A25vS8bTPmmxR1ahIBu7GXV2qX?=
 =?us-ascii?Q?ychjN9B7H9StqVl8kJPpuBv7gqoCa5Dlskl1qx9a6WSO3JhmSdIoixtDZfEu?=
 =?us-ascii?Q?H+vZZf5aMbC6J4n7b9GS0icMIE53wpS8To7OIL4LKXHen33eXUcRF9xvYMFV?=
 =?us-ascii?Q?tibFaADVe7jfQ0HOQ50QFBLuAnKGSzEZPnwt4hlYZ3sY5hs7fP6Dzgb0GwDA?=
 =?us-ascii?Q?6wujYXBluyXzzR8KXuttI3WXgV162PiqDTchOnMh4dH/CBRw7xw3aHSnLyi7?=
 =?us-ascii?Q?M1cQw8GYaKc1c7GW6795Dee9yO9rPun1fBe2O6KdqEiumj0YlA0LFJHTfb2f?=
 =?us-ascii?Q?iZMnL+M2ARp1ED/x80tvilzJokTRHIuSz2Rt9zdxAwDxZzMqgGGngUtW8+ev?=
 =?us-ascii?Q?SSEU0ER/9eOCGFuxq/ybgY05uwCdoP3R0HS3xQh9a0N5Ih2H8W61cFeXVyS3?=
 =?us-ascii?Q?BngIi2Sz+rV8TzVRzyKMYl6Ukg7b+8Kbg2CGobls+HsFwS+8oQccQ9EbtUHw?=
 =?us-ascii?Q?tpW3i8wu2lGiwt5dug4HZ6NDkIDj20Ro5Adi8q6wFmXm0mMsc33FvvNcFv+o?=
 =?us-ascii?Q?Ysf6V1V/l2k6TpiNr09vhQo78cO6/y4qM8zoW6aGXWNjHz+CuiFfU4Pe0LU+?=
 =?us-ascii?Q?sVi3ZHPK1VO58QoEkp7h+6F4n4AmUphfdnlAR6ik6E+Tns+7DLTx0jAGGh3c?=
 =?us-ascii?Q?dlhJx7gSOU0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D8HO3kyIZaN2SR2YOwRbqxuJAXe85WJKPQhWfuZAOI9Davh5hP1XH7PKTmqr?=
 =?us-ascii?Q?ME1MFtcvxQyvED9DoX/ljAUMgCmYTT8m8b/QWiDGa2MyCKpp2rEuPkX3v8rz?=
 =?us-ascii?Q?5d8I0d/zJiIkRnkjElANTIt2mk2yan1TFIrccGj8yeIzaalFPx3kiE81tazN?=
 =?us-ascii?Q?7PxHEM26HSqiDYLbT3M1lDL9uXMayyKRB9EZGJaphYNlPcgKqjcZhoNTs9dS?=
 =?us-ascii?Q?N/ZSu5cAnzM+wqijVyWXB7cMQedBlXa0v6d/Z3Bnk+UFhE6eHvc7qcnBEc69?=
 =?us-ascii?Q?LxhVe0ce7mtksqAOMeR2HOFa8FGpv7IAOmAS72mS62gzdLWeo/6RRkfSda8g?=
 =?us-ascii?Q?Iqdd3XfVsoCslXR34zJmHcgX6wtduJJPugAMXMVN+Qs4DLrzbBoFHtnuWiHR?=
 =?us-ascii?Q?oMpRB/Uohr34dEq/9meunSKh9LIKBJu/8Q4IliQnzjSWHHXjBxNQlJauuwgZ?=
 =?us-ascii?Q?CelfBqyehmPlJ4/IVYrau5baLX0qhZ7mSCWOgc+JUkeqGaiTC7z+Z7Jq/LgN?=
 =?us-ascii?Q?j+NGUjJPGrYZhMWhdV5SOH1CkAlwTQ1Sgb0EXh8M7vXawCDLgTkUpkAeHTFi?=
 =?us-ascii?Q?GfjnOecDQkueusQrnLh33cQWjDRsvsHmjynS9ZAutXWjwOtifxthdqSvozXZ?=
 =?us-ascii?Q?tqneRS3yEJ/Kh/9HrRnD/4v0hjSTIXNCAn9Zk3DU/K5Tzr0Dli4SnyR7+h+m?=
 =?us-ascii?Q?C0CikfNBgM3EncxFfAKBvqmm0iftZUbZvxdTVo2qg2bEq/WsvLDvefJjGZs5?=
 =?us-ascii?Q?TYY4C/Zeqegguo1vSArXap/FfyYpmRCEHIVBxmlswg1RClDPP89XG/tU8np6?=
 =?us-ascii?Q?MjRaUO38q2qe+Ir7K6GtvyrofRRXPe19pKXt5ccN87KJMadqch/XDEs6CiuS?=
 =?us-ascii?Q?3OhsSjhhHzfb4i2YV7/9gCdyIrC95s1ex7PVWCCZfpxI53m4jofnUDFKLd6F?=
 =?us-ascii?Q?9QGXxepZVw1WecooRye/3k6FuLsjW5PXTT+cxzUGbB1pUMoyuvqqw2QNusa/?=
 =?us-ascii?Q?Ksg+sR+YwJcZ3XLCFr3oGHXOAK83lOzf2ocf7P1oqQLIEMMr/VkA1iceL/RB?=
 =?us-ascii?Q?GhxcHq8PY0BPk8OVGBc9BqKeyZptJNHkBBAfzqwyFNFTAWYr0rbmVv00y77M?=
 =?us-ascii?Q?lY3rBp2UbI2pEXTNFKoomMO7q0LYs4/tRAdaUz0KAq1XPc55M1eeMimshnPY?=
 =?us-ascii?Q?W2etIluA1sqAZtQvU4AOcR/jATojr5hqztyHnvPVjsjOpwUff8mhvxG2Hw2H?=
 =?us-ascii?Q?Ywdn7TS8rD9nEA21Vvq6QUlrQWG1WwZ/4PrKcOKcwiOrfdqLNy5SNuXdAJEV?=
 =?us-ascii?Q?iM/fOqEAp3i3iyT7XEm4BTKgfONOeIzz5B16UlzoWgjneAL3tRpguT3C4fmu?=
 =?us-ascii?Q?fFqCgk7Eb6ghpLexcH01lai81+dq+4E86jceWr+SGouNlHfijar+yqd+CggI?=
 =?us-ascii?Q?yDBCc/F7/GJcbIT9LpsD3cZrqHWEsXc0/PxrU72hLRtgsCeuZlSoYf3K9c6i?=
 =?us-ascii?Q?4fRfM0kHKjptrHL/Spa3+Gp7s7prYx6LC6tPbDdZgeRFZqH2Xtp5vuZaFFRM?=
 =?us-ascii?Q?6/mZSdEyrTPMhSlgMwGQGaceCJxVzurUj5qUkH6VTBtoZAZ1GfLgVQh5BRgO?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EWsSxZggzrWPwnMLkvnt0qdxBppZnNKh1ofp8+rYEWs//bovC28rHjnr29OjoRscnz/4TCVhPSCek/vN6cNILr3Ku5LjphzZ4X4ScL/hFLrEGs0wb6uKNVts/mq6aoXJkzRfeBHDeGtYu0Rc1NSYJ83gQ7dW8idmoDoDSngkcXLo5M5MDe7TyLyP7v66slHlTnFFGqnWeKW4oZRilYkTzjARp9Hdkj7TexnzsM3MA2CnvVLHhHnsLT+5aqc0k24tKj5u7i7gM0OZ7eqLwgDaZOWdbYRIGd9jASDy+42HjX+t5Uyrpkc4YXp8GCo8OnZ+h3L+FMT1sPNW8OdgAMnopbylSbR9IrLBT8w0UAh2PBu3tiPqs3UgnGDtVRx0v82wZHP08HchABXG/KOzIewpaHwhcdKV6ZgdQEezrL1rYaE3HwB/TAXD9OXRw8AzU094exy1/cNpJYrHQWCmdtE4jXGtgerKmGrKBXMIZ2ppaCmc0WNaCOlNYIoGpnkH4P3I3VRn1kqZBqpgKqCwXpZ6uCZ1wJXsJrp7cI3RGk2Bov+VQ2ZHUuE4C/aD57q/IdtAeySkql5T6tnEUWIXXkvQB+4gXBzfPtZxRSR2kbE4PcE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821cc681-15fb-4d8a-aa09-08dd7a405e16
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2025 04:05:03.3100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDkqPwmZjt+I1bvW9ezVYivS1RFgoceX6w4bUHAgf59VR/7UtqLvwm/9zHR3TvgyAsUCxVR8XWntyRJTAqCrFQfArb0vnhmnjej3bqsXN8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-13_02,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504130028
X-Proofpoint-GUID: 0wSI_XTd5PU8uiyvRyrF11z7jfpw1H3D
X-Proofpoint-ORIG-GUID: 0wSI_XTd5PU8uiyvRyrF11z7jfpw1H3D

The following patches made over Linus's tree remove the atomic use from
the main IO path. There was a handful of atomic_longs used just used
for stats and a couple atomics used for handling ordered commands. These
patches move the stats to per cpu, and moves the ordered tracking to a
per cpu counter.

With the patches 8K IOPS increases by up to 33% when running fio
with numjobs >= 4 and using the vhost-scsi target with virtio-scsi
and virtio num_queues >= 4 (jobs and queues match, and virtqueue_size
and cmd_per_lun are increased to match the total iodepth of all
jobs).


