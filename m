Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8059342FCCC;
	Thu, 23 Jul 2026 09:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784799514; cv=fail; b=RUQtp99Vw3YJEKYbPSQ2WaVi9qM+ukCE6YOkZsu3P7oij4q9WFxVr9oHgPcV+oIA8NJdkxUgrORogKTNA4KNdiL9N3s3VolM9GuqTsA+9fHwgDE5Y/Ir6JacgKWvBbQEi1Dw1oQl/JiGQ+YmI3qgnfYPV3wjCUk9j4sj+A+PUmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784799514; c=relaxed/simple;
	bh=YreAfZWBIhXNtYVgMfzYt4DlIbRLzToK5ILZ/svU/kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P2ae+pz7yBWe2E68EWQD5SAoEbCjo/CGMAP3DrAdgSFN3Tarp9cD47VWqjdeaKluaKX0Ts2ICcd9z7x1Qy722wUOoCvJS3xxp61BXtK4topDFkdwuIrxEfuAwfvhGUqEOSkzVzAhrQK30QB1kzAwu1/qwHd6uf94UQMoC8MjfP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ahI4Q4IV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qSZA9YW+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ahI4Q4IV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qSZA9YW+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N3rdkO106353;
	Thu, 23 Jul 2026 09:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KmCdhpM2klN2F/bt2AxoxrfCmccQc1YM+09GDxueI3A=; b=
	ahI4Q4IV6eNtlN8YqEKgiNjv60AXR7s2wkjkf5XxqgFgJEt9/eelsBxj/wiM1Vnx
	Atp1+EMqqgJj4mcrQnkGFd4afCVh6ThrY1UtexXf5m9gsdIR3BdSGHmCGJsDe2oI
	H4N50ngaJP8mPVe5X/xSP/wxFoDFAOHtsbEpg0RAkEbI6OY+a9KE/GM6ao2JHA3t
	bAFclEEOKr1ZcdFOjHrBLNSR+cqVEAyT9D0/wpz7AEQx/adARlndrN4aNCRY4OhE
	Y9CrvPtIlctC2aizk3+e9siGSgakta9VzjBPuROKXGh6w2bvyKNNPTkJXnn78Fjt
	yUOJTJANDke0CMlC758cfg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1kpxn2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 09:37:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66N9X9QE021137;
	Thu, 23 Jul 2026 09:37:26 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fgts0y4cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 09:37:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYO8dyObi8UDDX1HE7lkbe3eyaK02Tj1lZMeB/mTgkfamCzW7hyJ2RKwj7FLIb7vFRVRz8XD8NWtohe40qQ9J8eisqNC+9/M3uDjEr2gsMrcQmrpsS7y1CCyqI+ZtRXIIP92CO9I2BXbhtrIrm8q5TV7FMBM/qXxDVSzV+mpQq6EyE5MmXac04wvlZKhFR4HNIQg8M7ofgdwT2ib2WwMs6h4TjsVpkRaEjp2bzCqHMp7t+TYV/q1xeF+kSdgGncTtg72YgTJkb2NM423Q8RFFirbU3oC7LgWJtwPpNOYhDNZ27JQKoc2Bq4pZt63edWm87iZONC3BEXKekaBkuWAdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmCdhpM2klN2F/bt2AxoxrfCmccQc1YM+09GDxueI3A=;
 b=ZwLsnEhFVCJErljLWvHL1rlQJKCYYfRAd4OFkU/TyBBLpieUO/Xf4kC+4LMeC3PQEsK4C3bBwVIKLC1+ij/gRKtv4xKPc7y6q0p8s4qqmsuykzezf9qvU4zrbgSbsg+dA/JWO2qAHJQjjfDzBkmzCuxvcgylJz6kxbmcMO8qvl0yOlhdd5bLpqI4x0lCtl7+EBekZComzopvNFqoiQIaAueUZsf3gzyTzm4jggcMC7fgyD2Wes9OVam1xTuWJzYPLhsUYmxyJHItT8L6wboDs+36jpw+ib/oMLZCJaJMNhr7b3OyUVzt8mBIRrhlzfdOyMMhJHZxxlzKF3o1NkLM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmCdhpM2klN2F/bt2AxoxrfCmccQc1YM+09GDxueI3A=;
 b=qSZA9YW+T1UwIpEpGi5ArnTZsH3ul4VBWjq2/GXpFfoXtMQghnRg6QnpjExeJqF9IweZz4EWjEtKAHo10lfmTyJTdLzM251fJDAQa8BK6CIcnJL6Fl8ebYWG2ZDgeyitEbTiyKk6B9Q1UsdHbO5AOrgSyNZtH2GYaQlwBq9FCMA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM3PPF2FC05F2F4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:37:21 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 09:37:21 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 21/28] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Thu, 23 Jul 2026 09:36:19 +0000
Message-ID: <20260723093627.2327456-22-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260723093627.2327456-1-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:610:b0::8) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM3PPF2FC05F2F4:EE_
X-MS-Office365-Filtering-Correlation-Id: a361a9da-c274-44af-325d-08dee89dfe52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10063799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/OwixzpzjW1xILf3EJm1cfhg/yPgvG0NA/5RYrP/bufiOmUn49seXeqaLK14tglsUiH8C3JGCraW35MpoNTTrqhzhhYLDzcsPFFtSbTXhicq+bJb897CZoJlEnn0XV5Duv6h7LG3LkRqhplaCi3jP54pIrH9wr5ADXO5q5uRblGBAtOrewSrgrExt2A8WzHyaTqMYoDi37aNMVLBhL6ohDvcuOo0bLzI3A+4tJLPqQ3J5M5CSSMexq7PfeKEE0yX+4u4fZxA3Lb/M3uUHOobqVzZwTX7uFN868cL3CyDtXLcy30gHbhnKnO04Ny4mBRgYgkX0SbaDhK9XKJeXHfaY6XWYPgrS9lffTwlcxJAFxrlcL9BkFKlb7XOMINio4Fvc4L4e/5zJLpwYYxBtElq8/nKwqZaCvlimtOeUYFnnEK6K6u0AjjE14oKs6oXOz/IuejxVU4UbIukIFWfDldZAUWaHUKrhPR7L4grnKX4CIDUnyhrT1SN3nh/YuqusBC1oFb78AGBc1cugpLp8eVdqjQsecHCEVmo/5sD7dIyzr5Tsxo1Mvm+8ONhtgy7BVlp0WDNn72mQS//yUFNKU0UdZe0ClF8KZVuIfD0WGwNqDgUOxGBUjNAccmTBYPYY+cjINY95+reTN4HQj4JjsgIfg+jlRCKX9GUaGtw6P8kAGY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10063799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TD79O9suYCX1UN1I0bMfAoulK+FOrz3P8374cKxO7jcRla60fc5xIlM4SoS5?=
 =?us-ascii?Q?4kpxtUO+VuSI5xrJRp+Wl97bzPipB++XdFxAg16fCkjOE499obKln9Ij2MxG?=
 =?us-ascii?Q?+zW84GSZLE16cX6odyyVNb7jXwzu9IxDK43MwtyQheQh92hHDo22Ysr9xvCp?=
 =?us-ascii?Q?m8966XGyJzB4Jyrkg5Svpwy0EEzMIFNyemfv8YkiLg5XAUmAv7/vBxCb0mzQ?=
 =?us-ascii?Q?bbIlSUI/yUmU94twVKKVBObbjamflzBo6Qa2SjJXe2GYC2/YDa3Gfls53Al+?=
 =?us-ascii?Q?eJtz8g9pi1cPfc+IlVBg2U6++HYNZUdm4kGOuHwuAhGMI9y9IROZV80AuEmW?=
 =?us-ascii?Q?nuB6LIWsNoH7PxiG/NDt/kNpwAdBDUIiJO3unJdX889+STP5vUZ0f5r7krkT?=
 =?us-ascii?Q?/DCgE7KLdV833MwnB0W5Efg97/kjhB4Ae+ONRqudyPoLb96IjqDmTdWttCez?=
 =?us-ascii?Q?dCtR73wrir0M+pFnWQHwezmyPDWlmH/ulBp6HEDpCHJDlnra33sVkX/zGH0c?=
 =?us-ascii?Q?UmaZ2RfhqM9X2ltoYUl50fw2NI3h0iS/mlLY47LKXeePpgIFCPGLJOeYxzVD?=
 =?us-ascii?Q?W+vdmGFiQfiBHoz2ZOaoMP3KPKQ0nhCeEpLYjMo8NvQY+FymuYk46PQct4b7?=
 =?us-ascii?Q?6p3PK4u5SbSBJlRxF9AWXTmWLARp01O9p3soJNWpqeFgNO1rBRanx1SSBl0L?=
 =?us-ascii?Q?d9SWi88CUwDg5pbhOrvbEGFBuQ+zRecO6A6ZXlgtM+cocuN5k4D75JK8wJwm?=
 =?us-ascii?Q?0VC61ra7ZqaRXPplvG3BxZ/I6qgjGsAZPrRCTTQgNz+z9bIAmdO0CT0RPUXd?=
 =?us-ascii?Q?ggln8McThMcTiY2wFK/zDZpOpApoEg52ryt9A72ynek0NIjVYhALs1VSD4an?=
 =?us-ascii?Q?qz9RR4g8r64ceX1QUMQt9v8yehv/j7kdUt+ZNbTfjZ+ISag1D1VKq6f4Y+T3?=
 =?us-ascii?Q?o52WPo+rGMZgwBsgt64bzUb8W5GIP1bEOWdUFQz9g2ue9sV2BsNxPrxWWe3J?=
 =?us-ascii?Q?qUyKz/ktG4SEV6kOLc5BxKg+u8BWDk4u1bwhkvU6gSorYIYr5U90avAWOcv6?=
 =?us-ascii?Q?81BnjrxcX627YQ3LcWFNk2DEsD/IEsHcQv3g9p5ZWJ60RIcY4yeg1awFHp2K?=
 =?us-ascii?Q?ymKaW8BQNHFnCcRbaOu8cxs+owT5cx4o0YbXec1o3cKLOhnMC06RGo3oHE3W?=
 =?us-ascii?Q?9gVBxxfQqso2tXlnz1+5eCXqkWkh05vZ1A5rUnwVUdmjyGbMeJv3NFZHqmUg?=
 =?us-ascii?Q?HhBN4TPS0nrhHcXpzCtUSOgD1ERIeGBFRhjf5y8cDV515jjWTw2ys7EINgY7?=
 =?us-ascii?Q?SHqj9hwfHvd78leH20tD+LlQbMOXH1W2BmUb8cU/k+AXmMctiY2FOm4/Djht?=
 =?us-ascii?Q?P0Hxz1vMtZCJzn1C41AWtDY7j/31YiA4rX/6XvoViG/0+QFvoEjm6kI9Tyql?=
 =?us-ascii?Q?W7wjMUZAY5Cf6t7p46Hwujdko2tciRCfxRQryoivudWyplfSp/oupHyx9hmh?=
 =?us-ascii?Q?dH4r4ISk8yo3KIWwB0AYVZZ2ePdt80LuT9sLej+BG8ezQX3fW02nAg7i4xzR?=
 =?us-ascii?Q?X9G9TElpXyAU36IJtR461iAtMFH3jL7+a9A2GyhTbS1nP08wGhrefwvorRaU?=
 =?us-ascii?Q?GiXyAOEwwyjeT8nWGROoq1J4DLHzJRZLVe/MRU/GPR+ryClGCYKmsEPL2+bp?=
 =?us-ascii?Q?JOkKuDhji8f5uHgqGpw6fV8yzgPObr12lTxWH0K85pOydZPBDgPPJX2gQWle?=
 =?us-ascii?Q?cR5lhEhYuAN2uOQFetJDnkL+ZIUJ79k=3D?=
X-Exchange-RoutingPolicyChecked:
	bZYCsIEkv06LulmB4gbIgTTWQP8y+EsDhRGhfMljKc/wpAcAaMAakCUKxen/3hHPImRCUZ5nV6xDRt80qgPV3nYHvlpu2P5DjaXIgiNcWD9C3GwAUzGaJNTH81YlvwBeweYJ/pQ35zMi1NrRl8uIswpPHFT1xRXNKbGYeai5slpnas8jDz/jcLpjzR6SAr4olv58eKNGVlzjiKqLspxertjgI7Xk4ZQWRnDb8jKlowu/Ua+vHIUSGzWSvM5o0LOLuwL9voXua5RULkL5uRUSeayORmE//PznU19TDSoL+i9q4cGKH5K9b3PjiWwbCSbRTqet5HcmBLA3VxITp3xsPw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SmN5loLveHofMaB70tSPTzBw/X0pa6i1bh9fT37zbrTv08FPr94qySER8jxVlAu9juQWEOxHW/V2yJpA6BDD/DSYbs0oYbqHgsCBy4suQdNrk0tMr046WI/jMCgx1lQthoXvXRE4M4m6Sk2rC8Nd1wSis9Rsa1AyNrBcMMdcpos3Zeo5gIqFQG0QJ7bC0eK273JYwua8z3cmvWu/VYaI+CQbxv4apOYufCBVg9DI5ZaFpwVMtbWzRDCmoLPs6ehhemmalYEq3nI4rrCAWP4KJYv7e9DCcj/G3j1WyACDBKfBfzVRxSx+Ltliuq0ps5+Yxc+imrcSYanG5Mgon/SARee8mV3PWXM7lPsJsqXyahfsKHpoNx4BPSCLgSv6waojzs4lNQ54k37hp9jK/Skn7CBhWRZLK1ktXy/ex2idsvK+SMvmq8PgrYG7tofq7GAoZa4tnmtQvfooUd8CAKPlZB4bsrDRu4S1QC2K7/oQUC+wfjEU4kMiaIVvO62zTGNVJD4UrIi+Y4ZQOVZhMSXdFi7hLtIv6bwu7kWml0GInRTACAvX+OXjzJ3hMpHylCarAXng+SvKrwAvQnEW1iFY5CYjVw+oievkyk9WsS49NXg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a361a9da-c274-44af-325d-08dee89dfe52
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:37:20.8935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5gcQ1YX+4diG8nCBTmsV9wY+cgQAW+MJ67kzE00Kmfm4vfAgidqkU5B8sjdAzej9/CiyTIFJB4zw12yhQUuGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2FC05F2F4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230094
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfX66Lr22sItkpp
 6idfmPvTgMOgj/F5HnAOHw5hTsorKw9XQZlTozaKXRAEoCHRCi7IzZo+pNTNcMHN6BHAxjhgc4D
 u5pJX+OWezQ3IoombrqHbS+38sdzG1ZLLJ11NkQNyuysVZpdT3RA
X-Authority-Analysis: v=2.4 cv=IKYyzAvG c=1 sm=1 tr=0 ts=6a61e0d7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=-3jN5J4PbOmX-KBf5wsA:9
X-Proofpoint-ORIG-GUID: F06COIuoBWr-ZDDL16zkvGOVtR1JAX3P
X-Proofpoint-GUID: F06COIuoBWr-ZDDL16zkvGOVtR1JAX3P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA5NSBTYWx0ZWRfXwH9/9DxAtUDy
 RCFrljhFyEOqbuRYc7ksoFErwRphv5rUhexS4dpbVzUVcodUnYfXNmpYtM1+/xtbs1QFrH86NXA
 ZBZ1ygssbiShBX1KNJjVPG4mpvl+DvRtJc4whjIH4BWfPoZPE8EHQO/K8Duwq+4Ia4Q/Wd3ndgj
 ETup2djjkXSqCUH7A9cK7Q3zQvAy8amLBfLTiXtVuGVw8MIxEAnjoVIbIRXc6J8IF67XXUjLdMV
 M8XKxDc9fP/uTjoIXWwAALm1nvVWDtu3iAmQy+L8i+F8uyv8XTT2pnEYtkaXvKjGCg00DsAbWKh
 uTvCfKjn9nFRctZWrfU+pJNCL+Q1cV9Fbe6M8v7fN0MRtDQjs+5FJS+ESLU1w20JfY5Gh4y+P2F
 U+fTdDgUy21LeNQha0uvuiDHv32hbfhuqLCxS2peh507BKiU7HIqvwXilsxJ/kPl0Bwp40UhOc3
 yydteh+zrL4+vFYy/uw==

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  8 +++++-
 drivers/scsi/scsi_multipath.c | 53 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  6 ++++
 include/scsi/scsi_host.h      |  4 +++
 include/scsi/scsi_multipath.h | 11 ++++++++
 5 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1e13aefdb6d64..3dda25a05f78c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	if (blk_update_request(req, error, bytes))
+	if (is_mpath_request(req)) {
+		if (scsi_mpath_end_request(req, error, bytes))
+			return true;
+	} else if (blk_update_request(req, error, bytes))
 		return true;
 
 	if (q->limits.features & BLK_FEAT_ADD_RANDOM)
@@ -1917,6 +1920,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index e566d47199fcc..6c50fdde70d65 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -555,6 +555,59 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct bio *clone = req->bio;
+	struct bio *master = clone->bi_private;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (!blk_queue_io_stat(master->bi_bdev->bd_queue) || blk_rq_is_passthrough(req) ||
+	    (scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
+				jiffies);
+	scmd->start_bytes = blk_rq_bytes(req);
+}
+
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+				unsigned int nr_bytes)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct bio *clone = req->bio, *master = clone->bi_private;
+
+	if (blk_update_request(req, error, nr_bytes))
+		return true;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return false;
+	bdev_end_io_acct(master->bi_bdev, req_op(req),
+			 scmd->start_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+
+	return false;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..3ff425c5f1e56 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -60,6 +60,8 @@ struct scsi_pointer {
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
 /* flags preserved across unprep / reprep */
 #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +141,10 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	unsigned int		start_bytes;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4b..cf4fff3ea1a8e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -753,6 +753,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index cc77e63c43da3..c3398e9f03f16 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -56,6 +56,9 @@ int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_start_request(struct request *req);
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -98,6 +101,14 @@ static inline
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes)
+{
+	return false;
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

