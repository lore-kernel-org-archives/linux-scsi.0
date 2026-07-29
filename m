Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF94645D5ED;
	Wed, 29 Jul 2026 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322337; cv=fail; b=DNXbJ5elUK2+M7kFurw/5itk/9FJAVdjsJZd5Zq6aDc7UILfJRoF7bBTs6qCI3C2oYyWdeqA845gU53te17EvSsmG1mNGppaXFJclCIbJCIcc2FP5RFcP6jTF3WhX3qsnWNvBAtUbQuEDQajj2kWdcACMfqaR492z4K99mL1cGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322337; c=relaxed/simple;
	bh=iBq4h9nZbINloG8JD6+dLvWQFID062X+pM0WbviBlt0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bVvnnz7CE2RJoHXswuG5Ec7LKpuAtUidg4/4xHy2B2YybVLvP1ZDhULnZ0O0bsZpKg4OkoZ1pofzwOyVxXW9kiVTGtxZf/79MfT0wpMEXXvAgSkxD3k9OhTA3s2atIaFV1w09sbUsE6HWeaaYvkn7/kXQPLsmpIIaPqv+vWZ68w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EeigzSup; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zYk8xDIY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EeigzSup";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zYk8xDIY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T9OM5H1094334;
	Wed, 29 Jul 2026 10:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=ceR3ypTWvoBW5Vdh
	wuI0fxuMllG+HKMwS9F1vekoCIc=; b=EeigzSupOu7bdRD5RQpKNEiD4EKZRbrL
	9Yiy0Ec2yPRban37nSpK1VO936A5taHmV5OkGl87P6F+ajxkspJ3K1uv0HNEAxjf
	qHpO+ItM5V7Ry8UvsFV+NmHU5YhKj7ztwu7BQivJSZD0PFvCYuZY3yrMm6VCHO40
	p3404hAaRZaP77cj/KmCtemgg6w2P5/y+fovz/pcJjl2VEzAAAkSRCG4fhAJjRBH
	8lgqIbOI5fdW0YmL/c+1T5v8b/3AfbkHI1pFEWLlxNE+ilJHAGTZy5j2ewcJ15l7
	JY7xxz6CrDJq8JT1BAIjG8i7W6q3MCrxpUcH+cRWNMsxBxONNRQozw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqym5k5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 10:51:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TAo5e9040026;
	Wed, 29 Jul 2026 10:51:40 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekrk0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 10:51:40 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uY0mzMKYgyVRvS1MFXVtg85oVBISxgOFLCR4BJHQrXUKw509A29Sg+ym9LM01+/TgC88fYmGCPwrpqkcAWY9M/oKN0p9X7xcKdpF0CuIkznClocfWGUhsMNYPLuzAHyXYEy877KVVs7IegCr8HP6C4cP1Fb6xMKtV8ho+Zfp+11YrXy2e2skjXsb6flMZxHxEIphklj4sLqEPW+eGmedTiAXgJvNKKQ035aPHrL0RbdgdFYI8+2WK+FzpjYOalxU9dN4f6S4gh7MCniiLJgabBBt8g5XbIlK5O+KkGX1mvRi7p5SArMSo9dnJgRU26TobjwLSAZdIjHer1TjTAEj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceR3ypTWvoBW5VdhwuI0fxuMllG+HKMwS9F1vekoCIc=;
 b=EbmtYp5I4bTzxkr6dJdXbA8NKwUZwUaiOKjR2fLVzvtOt61U+0VpkUBjb7KckIPB3wn7YjJemEKGWaiRQAjuhYZbvDxappOkK0VdSFtyP5X4Xcp+U54tm6hMedSem64r9Tp2wCJLqkd0pSXZf8msmba05flLmUFdNOs7d1T3IO9kK2z/36JdlbVTOEbGW0nndcxadb7/nwE7fdMB3nkdpd4fe4CdH78jRWawkSZME4kjChWE7PUOsB/fzJhPvo9bL3uUfQ3mvvEmKm6yI5tBYUsep5gwVM3h3RfLLze8g3qLqPmWNR27tEvLqDvWg8/FntdajYIkGOIBHLdBbaJByA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceR3ypTWvoBW5VdhwuI0fxuMllG+HKMwS9F1vekoCIc=;
 b=zYk8xDIY8LUum0vtiFfhtWWtnP5HoRqrupjHslkB/PtL1JVh75GPOLxXvenfz2PKqohkvVIOF8AxZcdNSo83PZN//W3FVjClrdhYwS5lWeb1q8STsmht0zWcjR6xeYMTzB9NhaGvOwchK1ZQ3wkYfY+wLp58K2eM0wMy8CcUPBI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MN0PR10MB5912.namprd10.prod.outlook.com (2603:10b6:208:3cc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 10:51:35 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 10:51:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 00/27] Native SCSI Multipath support
Date: Wed, 29 Jul 2026 10:50:40 +0000
Message-ID: <20260729105107.255712-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::14) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MN0PR10MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: b8b65609-f70f-47da-a1b9-08deed5f5bd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|5023799004|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LGzDWMsmkXKrLuVt4IRvh0dGoMsOANKWUVVqI67Or3lsyNgWuJKy56rhy+o4Vnk0SdH9vo5KoA0xgFJvyJx0/h7FuOCV5AWKc6B1wd4ExnEsN6I2gbIar0DnFLyQJzOGoXKpsWt15OImTcbpLzR6l91fQCHpL1D6JnZIGiqqNI9gc8pbnnH21XgqQVsuMEGZfP7hU2vZHVGVX8Lv0QL1IXXn35idpme1XYLF7NmqOUktJZibZoFGZ2jzoCSRlQgPl8X8mjHzLg9lBTiJ7/pA8ugGy541QfPVOjXzTz4O/aVMpxZQHMFrdiqapj+FRVuZhl3BO/z7XID8/Km35kpGmTmL7nu+jdsjHrDcBAq9Sx4b9XxW+pKe0YXtf74q/FgMazg3FD93J60XQSJM1/kO3lqBH/9MC2NfTiGU+CFvdGsOlLGzG1bjwB6rhZkDvyOINdtN6FFkIzFnNRO+lL78uNUWLvUtO3cPyE0LvJn1lNPDz0337Z+PNen5VQlcPT4L90T7TpZd8hUF0bSjwxI70zdgF84ZpW4DpoAGh2+/1mbei3a5g9BgPQto/ilbcsmdTMN+halN+1sfrHsHwd15GoUc8HumIYwfHsGuCQGLqC3Byu/xCt2vp09jZqeOlUiWb8JWwx+cQd2vbpnMbuKgKm+cDuAIckusESe+je4xUhE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(5023799004)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?weF44HfkLPBIXC8OH/9MM8VtcmxH7AEukaUH/luK8xG5Uj51+5sJhgHq1FBO?=
 =?us-ascii?Q?c+u8bg57L5Y1mDt6FOHLPjhTwMilVand67ywdR2dchTzl/PVdMQ4etCwK0p8?=
 =?us-ascii?Q?rLzkDWcDTA00ZgD1COeKOnjsEIOridhL5rNXcLMWNN2M5CFB5/nFI6cTdDeX?=
 =?us-ascii?Q?oyDf28s7JhfBU8A4EKao3Je0sAfIfoLCw6lNAbDuvmQ00tt8Ta2p5qW1shyU?=
 =?us-ascii?Q?2wP6vHc5gcHYuT7exDhlTjKsDopuW+mLC53vJn5YE3W2wrVrBPasvhBcsWUx?=
 =?us-ascii?Q?p/2+nHfHDSCvSvV9nGnMW/QkjmRkAWZeCqFagDagnJG3PAhT/gwoKBsdmlNz?=
 =?us-ascii?Q?ztKfBPuBXtuIT2Q/i4DhlC4G0DOqgWWGHSNE+JMUJpuu4kmPiwHbSRufq8Au?=
 =?us-ascii?Q?RmDTACrrxXpRoXjaVGzlLqyn8Y/3DXjFzWsFTttkLCXnbPW2szYT4FStxKMZ?=
 =?us-ascii?Q?R203jehqv1IAFVhfh9o9bmwcHlcVfrRFdbBy93Et/rAReDAega66OVDqxwwa?=
 =?us-ascii?Q?xiK9wQ0neN+y5dQu9Xy979Y1stFIKfHKZZH7TvtinJL65ETLPzluGI8+toEz?=
 =?us-ascii?Q?4NH8DGQkcS0es7/kFIoweX39F9JbRmBOZIsGTp82ClOHBboLlX9AqmswJzCr?=
 =?us-ascii?Q?1QFyzm9V0TN3xm3yHrv9yy+YgI9fZFBXe/2zW923T8tn6xeCksiwz5nGdzZY?=
 =?us-ascii?Q?/M+XcgnsuhTdHAziDV430cybBkDe8cWwP03uN8hXwnztAQg1QYT8ItdicJ/8?=
 =?us-ascii?Q?sXMmXHhmvN0rLhvjKFNySTMBHSpmYuqtojwyq7mzwNfXPKy4Wp6452MDQ4PC?=
 =?us-ascii?Q?XqfprIWd5m9OFzJrgedhq8+VOoSPwbdWt2q41LYgCzjiikN1blVnyu4ykPq4?=
 =?us-ascii?Q?FRvMgGqWQMoFPK77BVyXul9aZ8sG2uwoP6ofuyjtUzW3dqj4NkI/97JuK7on?=
 =?us-ascii?Q?Yxu+il+b+WJH2senCZkACFkuQ8ZcCCwpap4BKLnk1Ivp4vL1UvyNqNg85FiW?=
 =?us-ascii?Q?XAwa3aE01eYiucXZ7mShM0FNoEeu220YOvqyvcmrqKqTy03cnC4JKZs/UK+a?=
 =?us-ascii?Q?7Ir0KwQJ/ECZ/N3skOilCY1qCQ5iUPcQeoZF6heefK3RmWvFMKeE/fUN+cJt?=
 =?us-ascii?Q?sbX7FChe+W5V4VHPG/g+pcNn6XRceQx/N+stY0ZsAcLgyibsZ9LsNHJXKRBK?=
 =?us-ascii?Q?v5exWJ1nBbi84r8/551ZhIP2OQCvh0e6xQ3E9zZqtolnl+af0mNrvR42Ew0d?=
 =?us-ascii?Q?1rpdqt6PqLqq7tpnEriFofOwzEliBPlqPgHTYOsyOybFtSFV3erqEYsPF3JV?=
 =?us-ascii?Q?HYv7Q2SSv64PKAiZ15e/YkUrd9+Du4AC8hS+QhkofdlwCXx+kqbkx75fhWB7?=
 =?us-ascii?Q?Q1B3uIkogXm8UgJ4XUA2+pHNGTyF9hpZ/tNKt3OH/uiriG9y2+pMdCcrjejO?=
 =?us-ascii?Q?6HZldSmwoevKFywNKQTkpDo4tj/lFyq5ALpX4v7wCSL4GQaOS3/waQcLShCV?=
 =?us-ascii?Q?ru5IGzYxLI3Y64DXRPlhc3oInzXneSQfYPvzdeWqFtiAWzYAUNXL3ULk5HEH?=
 =?us-ascii?Q?y9B0KTHtJ3c77G4UufzD/z1/aIDyy6DjX614f6WDGqvcgrTKWOU6Me5iCsUP?=
 =?us-ascii?Q?8vuXeFEdeolptmY5ylb7jBJpRveL3toWsAeU01mrJRAU/keov2jM36rskdG7?=
 =?us-ascii?Q?LoECrK73kZJ5Ga58nI6fMjPnVSSbdxyyzYmd1Py4GI8zPmIS8EhVLBOxp8be?=
 =?us-ascii?Q?00Jqn9w0Cx79z5Gsi6TZyRJmweYllCo=3D?=
X-Exchange-RoutingPolicyChecked:
	MlQZ9RZgeFDj+Mcc9dFrGed3VIeqUEWcQXIbOlh520k6zPb4Mt7qEuosKW7sGuwwvKZf6FTwyXA/XZ/1rscw+netFdF/yB6Sw5m6z916s/x6Qlt8oc1Fd0c3XxcATawp3w9S6COg8VYHtkAvQEEUxm/6tkgbY47MWCB0qi9S2yIfj3zVMA9LyeLTZA6jEVMUsgTXj3SFRd0tXceuO7XRd5T3JA0mhaVFbwhXg5KImdQAli+9IyqU39VlXQa3ksk1E7dwdqmxoeYQqWw3YP7wofwaXNBbz+GNZ0G8LR3Q3IsJX7Fj+bsXsST+2vCHUHnepAAKtyHEjbg33J6DURGQQA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7LurMG1EqW6TLRqmaRHj+uv08YuUyVitX2dRHVUCUuoRjWGLJVVW2+2AI9iZtc4aSSw4B93zI5JCoy0zU4WFTGz2lWvOclO7Kxdb/WgifjP5+4VSjSKJH5CZeOdt3t7osYI/nqjdq9zFdzBl30OVaW4nuH6e/jRDkzWftQ0OOz1J7JbX0vXdqdhuIJgE8QLH8fmiBsW2cm6KYb9FHJcg70EtIvPmljIPTK+iLJEI0H81G1DvTsVKB8OczKudOX8Gu30bBSOnH7SUdceijgGSjmN+FgWHmWnCQ80t+uXlIGz4EHO+UyabxtU9nFVdKPrpaIJ29VFotM8BC2KnCx+xCb7jfBcXLSO0W2gvVt5ES0eilDEHAU8RY+9Y8qO5brQIRcQrGA54ktEJFGxqXJi117HhlyG4DqtDGLKyf0aP5uG9cUAh1bgsfPeno6oIYFtx5DhQlSlASiCNbWQq6gA+2UhGavGvnDDmbz+4j8OnfoEL5MkvTobYr8gqMNz1NSB3biqnXAxWm6gp0XMNEndq9K/i7husY5lUe0s3UMkai9pMCzTqJT2vuTEMPF2SEY6a2s5WXxEUxekXu9d8e6/AyogVNPxjSYrhG3gwZ4QCoF8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b65609-f70f-47da-a1b9-08deed5f5bd7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 10:51:35.4888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9W6DMiPGRmAzYn+a554ZCkS1Z7keqix+ADybtfwe7hB2pGn/8v5S+ZweK8OjjMGq3dQZWTcDBeeByZBXDGBlCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_03,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290089
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX3/OkszsWJbAc
 brxhDDqKQ/ayP8vYsrhbfv7Hx0TfCyhtA599Ws25U656R/ijVTJXY5URP3gycNUMglDbg6ZnZCT
 ppau32eEwPpTuVcMdb77SaozrmpOBrOOzUJI/htQsTGakQEeVSEl
X-Proofpoint-ORIG-GUID: _7Dgm-je9xr8ARh3qjzk5xzKf40_rxwP
X-Proofpoint-GUID: _7Dgm-je9xr8ARh3qjzk5xzKf40_rxwP
X-Authority-Analysis: v=2.4 cv=UOrt2ify c=1 sm=1 tr=0 ts=6a69db3d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8
 a=tPCbtmrUit6F0t18becA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA4OSBTYWx0ZWRfX/gpXkjpCWdxY
 Qa6FH/9sEBHP2eRCRh9zJwagThLmBHef4TybL2rFMKHYgH8owFsvXDndnI1cccJGUCh46mSm18D
 /MUQyi177KLgIYruDGmcqY1De1oJ1CnpcdMXoBNdsofToCyrTmDI69PxSEuEKRBL+65TdgW37wW
 fcPO2CjCQ+w5/9udt/2JDfNkbQ1NJ3/SMc/AIgHML+qD6t9FOLIoIlZCqs0zk9M0VuwBXQtTOmw
 MvNfciCN28/QLhouKV1SZ6Ljc2OhszSj3LBeJPtyX/Rv3oIC3FE8F+z+zoWaMo/Zn6JseRblT6G
 Cs/+5aeZ3HvNAb+2GbsBT4wnqFdVaoB5ggCNu/Hvz3zXu09+GM1hsjs/XVlsz8ttK5SXaTlRgdf
 FY3d/AmCpICzXNzL199N9FOzefr9D4HIvK3toL90ekqECcDpn0/mtgAv6V4xz3PbBkymJucJKkV
 gO1nO/EB345hZO4Fr3Q==

NATIVE SCSI MULTIPATH:

This series introduces native SCSI multipath support. It is intended as
an alternative to dm-mpath.

This support aims to provide a multipath-enabled SCSI block device/
gendisk.

For a SCSI device to support native multipath, either of the following
conditions must be satisfied:
a. unique ID in VPD page 83 and ALUA support and scsi_multipath modparam
   enabled
b. unique ID in VPD page 83 and scsi_multipath_always modparam enabled

This series relies on reading sdev->access_state to get path information.
This path information would be provided by ALUA. ALUA support which does
not rely on device handlers has already been discussed at
https://lore.kernel.org/linux-scsi/7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com/
and support will be added in the next phase.

New classes of devices are added:
- scsi_mpath_device
- scsi_mpath_disk

These are required since a multipath scsi_device has no common scsi host.
An example of the sysfs files and directories for these new classes is as
follows:

$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/
total 0
-rw-r--r--    1 root     root          4096 Feb 25 11:59 iopolicy
drwxr-xr-x    2 root     root             0 Feb 25 11:59 multipath
drwxr-xr-x    2 root     root             0 Feb 25 11:59 power
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 subsystem ->
../../../../class/scsi_mpath_device
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
-r--r--r--    1 root     root          4096 Feb 25 11:59 vpd_id
$ ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 8:0:0:0 ->
../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 25 11:59 9:0:0:0 ->
../../../../platform/host9/session2/target9:0:0/9:0:0:0
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/vpd_id
naa.600140505200a986f0043c9afa1fd077
$ cat /sys/class/scsi_mpath_device/scsi_mpath_device0/iopolicy
numa
$

$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/
total 0
drwxr-xr-x    2 root     root             0 Feb 25 12:00 power
drwxr-xr-x   11 root     root             0 Feb 25 11:58 sdc
lrwxrwxrwx    1 root     root             0 Feb 25 11:58 subsystem ->
../../../../class/scsi_mpath_disk
-rw-r--r--    1 root     root          4096 Feb 25 11:58 uevent
$ ls -l /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:0 ->
../../../../../platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0
lrwxrwxrwx    1 root     root             0 Feb 25 12:00 sdc:1 ->
../../../../../platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 25 11:58 /dev/sdc

The scsi_device and scsi_disk classes otherwise remain unmodified.
However, the per-path block device is hidden in /dev/. Furthermore,
multipathed block devices have a new naming scheme, sdX:Y, where
X is the scsi multipath device index and Y is the path index.

No multipath sg support is added. We still have a per-path sg device.
Since the SCSI block device is multipath enabled, we can access
multipathed scsi_ioctl() through that block device.

For failover, we take the approach of cloning bio's and re-submitting them
in full (for failover errors).

LIBMULTIPATH:

This series introduces also libmultipath. It is essentially a refactoring
of NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
-may provide callbacks for driver specifics, like ANA support for NVMe.

Important new structures introduced include:

- mpath_head
These contain much of the multipath-specific functionality from
nvme_ns_head, including a pointer to the gendisk structure and
a path SRCU-based array.

- mpath_device
This is the per-path structure, and contains much the same
multipath-specific functionality in nvme_ns

libmultipath provides functionality for path management, path selection,
data path, and failover handling.

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.2-v6/

Differences to v5:
- deal with issues sashiko found in libmultipath:
 - include wait_bit.h
 - don't store error in mpath_head->disk
 - use check_mul_overflow() in mpath_can_remove_head()
 - use -ENOTTY in mpath_bdev_ioctl()
- deal with issues sashiko found in scsi mpath support:
 - check 0 returned from scsi_vpd_lun_id()
 - call flush_work() in scsi_mpath_device_iopolicy_store()
 - clear SCMD_MPATH_IO_STATS for !bio in scsi_mpath_start_request()
 - add checks for calling scsi_mpath_{start,end}_request()
 - tweak sd_mpath_dev_show()

Differences to v4:
- deal with issues sashiko/codex found in libmultipath:
 - SPDX spelling mistake
 - make driver set mpath_device->mpath_head
 - change delayed support to use unsigned int for delay
 - check for partition in bdev ioctl
 - drop zoned support for now
- deal with issues sashiko/codex found in scsi mpath support:
 - use ida destory in 2x places
 - set vpd_id earlier
 - iter through all possible mpath heads when searching
 - remove scsi mpath device later in __scsi_remove_device
 - call scsi_mpath_clear_path() outside state mutex
 - add revalidate paths caller to sd revalidate
 - fix sdev put in failover handling
 - use READ_ONCE() fo reading sdev state
 - fix scsi mpath start/end request
 - take scsi mpath head ref in scsi_mpath_remove_head_work()
 - fix sd_mpath_probe error path
 - fix sd_mpath_dev_show() for deleted multipath disk
- Add RB tag from Hannes (thanks!)

John Garry (27):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()
  scsi-multipath: introduce basic SCSI device support
  scsi-multipath: introduce scsi_device head structure
  scsi-multipath: provide sysfs link from to scsi_device
  scsi-multipath: support iopolicy
  scsi-multipath: clone each bio
  scsi-multipath: clear path when device is blocked
  scsi-multipath: revalidate paths upon device unblock
  scsi-multipath: failover handling
  scsi-multipath: provide callbacks for path state
  scsi-multipath: add scsi_mpath_{start,end}_request()
  scsi-multipath: add delayed disk removal support
  scsi: sd: add multipath disk class
  scsi: sd: add multipath disk attr groups
  scsi: sd: support multipath disk
  scsi: sd: add mpath_dev file
  scsi: sd: add mpath_numa_nodes dev attribute
  scsi: sd: add mpath_queue_depth dev attribute

 drivers/scsi/Kconfig          |  10 +
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_lib.c       |  13 +-
 drivers/scsi/scsi_multipath.c | 673 ++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |  10 +
 drivers/scsi/sd.c             | 610 +++++++++++++++++++++-
 drivers/scsi/sd.h             |   3 +
 include/linux/multipath.h     | 156 ++++++
 include/scsi/scsi_cmnd.h      |   9 +-
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_driver.h    |   4 +
 include/scsi/scsi_host.h      |   4 +
 include/scsi/scsi_multipath.h | 119 +++++
 lib/Kconfig                   |   6 +
 lib/Makefile                  |   2 +
 lib/multipath.c               | 948 ++++++++++++++++++++++++++++++++++
 18 files changed, 2558 insertions(+), 24 deletions(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/linux/multipath.h
 create mode 100644 include/scsi/scsi_multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.7

