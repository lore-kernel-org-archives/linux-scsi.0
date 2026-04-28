Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893153F54D9;
	Tue, 28 Apr 2026 11:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374706; cv=fail; b=Q6jeJqmkSm2TqPccpzUnSqtgdh8osWNHtIse/lS5sa8Z/SJx0Ep79ksgWpmpYRzXm5eV2zeNbz+B/1vBYMRdKMg/cxfzWJO+PJieJLqnPIYUlHs5BM/018AyNyhK+lOXuIb9RD572AsvX+7itFCqGGbVDNouxmoWyiRiDREjYlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374706; c=relaxed/simple;
	bh=wo5H2QCrC5AhaNGZkNtZbhKZlwPulgeYL5x/hq2ZYj4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pb0ipMl4I5k+/V4ow0vrUD9MB09Dv8hBHQhM8M4uAwsLml7Y4OndcNstRygwkE1BkPUgvPKUtft+FBQhMqT5OMx4dx2NmARLAiIYqj2DfbjbttJmuML5OsmyDSOo9RIEFUqf/U2VzVIzYLCsuYvnm+xYdv14qKkoUoosCM/A4zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NoKNoyxw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o674gBQf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NoKNoyxw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o674gBQf"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9QQYK2128206;
	Tue, 28 Apr 2026 11:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=QROEJKQFPn04vM+d
	QvAV7cwng6Hos/45noAvSQEDcxA=; b=NoKNoyxwS1YKPh80le4OL7AQDYqqj6S/
	9TtRnVTjYNobq1NmF81PA7vPnSlSwkbZMK8NWIK/cdmLKm18BdGGV4M+buRKw/am
	T4MK/kbyDKy6/cXykdQXOvI6ahfHVdMuvpF2D0dVOhfYJIHBirnqvcmpM0SasVuD
	OywOw9sjTD1ca6uz7eNkmvCrHQQ6wGxJ6lzEAxp/m4CudN2ZHwM8Z04m1gOEDH0E
	DxIRDPYBmnhOIxPO47OA9jRV7/3eDRwwWKegJUyFudZYNg0HyujUosnPTJ5qr9PY
	Qge00sMbJNuxW1H+WoYY//jbubAKp2log8bq6vGs9sxviVBn/ImGiA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmha7jd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2jhT036886;
	Tue, 28 Apr 2026 11:11:22 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2bvem5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUI7Lwrl/plMbOH5uTjTWHlNTQjvjVSPItu3QoWHtr19vPbzr3bCjLWeXqDwSdgo52devVHsypO6Kvq8TtnZuITnd/9EmlbNxH11zijzDj3vIWD/cRG5gdEvW5BpLl9/w6oX18MSozZmzzNklAAaysZq0U6wXD/VEDPcR6NEz2gGJ336qY+YfH614Zo+11oEaI4Y7IuyUo2NSEQ0usWxhnR/MIMYX0F+IGLOxjGVarVlOpbCweR5tDUJ7mcmLb+c8+3NZ+aaGlzjBr40J10cJCq6PrIvaMcAx4X3ODnQ9KxC6udCDPuMMvpz/z0KoNMC7cOJPpulQad4p/8YMReg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QROEJKQFPn04vM+dQvAV7cwng6Hos/45noAvSQEDcxA=;
 b=xohNNvIwBvSsbFEe4JjFoW4errf0450m6TcZAwlSGMRdRFZT9Ku0Xrr5JgHgtUNhJts+oi9SaK2piYAZNG/1CmzZ6fkRn5EPZYgBpk4mF5s/F+mGiuvYzeeYMoIzRMFrcpgIsME6nKUO1mGJvRUj0DxHubh951mwFICHNyBsk7XETaH27t2PdAuyjVWXTxdKV4Jo2r72mJ8deZ5cAArQ/I5+ZycxDWVXAUepQFIaOkO8G2RMasoMozfHDKoyH//2Mhah2pWhH2xCFwIoyFR63BLnWrSheMSPQTR7E9OgxfbsVDvVEZwQtQjoHmg6Kl/SmUdBuXRwVbU135CYfn0pEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QROEJKQFPn04vM+dQvAV7cwng6Hos/45noAvSQEDcxA=;
 b=o674gBQf5+DfrgED72VACVk8/t2zmOWNvEkoWCDc7wg5gCQ/I6s0KuSOvRBg4xXMpGysTcl2IJxIy/B6WOjJqg+hzIj5BJQ3xVgSzZdo9vt8o0JY1Le/iIK73Ac1tJeHeCCCwQYTdEJHEGD//wiPBgnwhrYeHEuOlzCWG/JEGgk=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:17 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:16 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 00/13] libmultipath: a generic multipath lib for block drivers
Date: Tue, 28 Apr 2026 11:10:52 +0000
Message-ID: <20260428111105.1778008-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0054.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32b::11) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: 1067834f-81e8-4b17-0450-08dea516de17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mhbWQcPE8QbAuK1nGgHpSBFt/woYPSSlV0zpUQ5NcwBy+TvnKQSJz+kQ4k/Br1/CJR8S9fVHOpAQoZaWl6NYQFEDBmdyvZzTTdcXO1gxsboWp3p8vv5YiiQo1a6XpQ863JcvDzNl92GsKwCdwjRAq0hrlYhwemNOJgknrc4vFpvho86i93is4vZQZ61LLASIQhbPXK8pSg+8Jloto6m0kcZEPDhEnGyEGpCpIfUYHOWyzkxCmrszJOcP8NGyvclQJXuSFm3lSR2g//ak1T17KUOJRIQXHP8mkywV75n+6jUGi1oFKZhLOqfYWqJwk1FASQIGulUFvZ57Mfi59JzwmTXHNSSyAN7xoIbeVpZ4pyQYeVMlhUehx0Q9cpPXIr1IqVLF8aiA+oe+578ksF/oA7Rr+eLJ6eGtbPs62VAZZM4eLaIX7Jqd2ze8eUQM/DwSMzvj6NUyZOSbUP/r2yfpLr5H4piTrONJzkjJN+otVGHbAlA2i2nLQyR8P7PCJFDFnF5FYoPhSdydqo7j/RGPeXqbFndkNalcexnS4aStHTXVZaJPu3v1WsDTLV4XN0qEA4Uu3h1O+O9m+iY87PCXjr0xDSOui2fieZF8p3rE5IecjstqqsoHAEq1cE8DRZ332+WJV92syCp524D6xti9fK6nS6W+hhqfO0MYKNlR/Hbye76Oi+SQOb6Xx7b9oZrPi+NI8xlNEin1SVeUnIUsBphVL/4T7gAjrd6VqNMLw/aIhImpiKZgm3a7mkvP1Xr6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OZiH+EjVQ8oDQwCb49tCAWs7M6lPC0f6hMny/1hnGBNK0vo296kC+IMvr15W?=
 =?us-ascii?Q?64Y7WHN9GyVlwxXXJIPosSnHNMJw6zdcaUmnTCdwWYmoQ7aUnQ/kfz8opWGq?=
 =?us-ascii?Q?uts8S6SuBHXfF96Wy2uXncxJG2Q2p8KxtZW5YQ8TX5XGbVIpqOil46xVjpsC?=
 =?us-ascii?Q?oJCTWd4WjD2bhUxMsv5DeDv2bOvC2J+/fqGok+EP2XUUIl8OYXurbo6czVqB?=
 =?us-ascii?Q?7EY3PR+YYEv5w/MSknboJv6vEnRqvy6bw37YqTQNH6mgzmQ5aDr44xBHwxTB?=
 =?us-ascii?Q?WNHS5I7mLHkgXZltbDuYlMm+pJ7QFWjZld3ft/9pRkCapElJukJ658G5pkBr?=
 =?us-ascii?Q?f+/joemLL3sprXZgxEcaQ34UyWMqGw0GD3P69szjIpDSA9Eus7upmW3h2rk5?=
 =?us-ascii?Q?8hxzoM4PW9z9qRL/+0W3JRQqHzgIbSUUQIB94bMkbPXiBdBrO5J83HqPH2fB?=
 =?us-ascii?Q?mFfz4xfltaf4vYYM1PM/XeYVgonsnU6Lt6HzLTk0libK0nKB0bRvsfNZ8L/E?=
 =?us-ascii?Q?XJatdiq/6peUYTHNu5Bq7K/PPgtK/WQbGNM8lN9ShAzTrMLG3lqKjbTFiroe?=
 =?us-ascii?Q?09QDS4DhMkzJ2mO5xKTcS4UOor+jssuCr6r96zJTirP8aVEr3KnG5WwlHF9P?=
 =?us-ascii?Q?0Eyh0OvQvxUxgKr4aSsnUIRDdAHDtHZf5T1KVGKICmrteMQ9cntWUcLQlapU?=
 =?us-ascii?Q?Mk351R32W6otyzFXKR8Y+ViQVaPdy1ZKxMB4nRNRCbB5ut/HYxomw+BNfBsZ?=
 =?us-ascii?Q?CY+gTUm1e6sOnhm9lT1DCcPoSBKHve1qRgsJ0F0S2tRvtW3XEptDCnj7WE0s?=
 =?us-ascii?Q?KQg5QOAeknKeZypMaH/i9mMgVWBq+wnak7c/p3F0vTZw3vjOYtlGEP9a1Ybs?=
 =?us-ascii?Q?kZDsyH9S7MKLga1Mbfm5rDqc28oIKeHpHMAEviXlLy3UGUOph/cVIb83mk/A?=
 =?us-ascii?Q?e9EXkqM4VLRTeJBhVCWjUK5P8MIajGxIoRiv9G8F6baBHZ6jK0LcsQwpQ+JP?=
 =?us-ascii?Q?mdBDUtNM6M/eQaKFpU2HB44Vv4j/j0cQnt7PpOGbStbUZyfs8smmZkt0nhQx?=
 =?us-ascii?Q?YdN1IVRMEK/Eu6qg2EFFqirZTEw3unyAX74fmqkGiSbqByxyYteza+pkyU4z?=
 =?us-ascii?Q?V2aR/Uz3XiwouRAAHEVt5mKOQZUMA4g/01KG5MPBmYztc8SntDRN4IEByus4?=
 =?us-ascii?Q?9Ry/xORyA6IhM+RaPiPQ6rzjFOp2+G+jnOMXd00H64x6YDlMPg3mpeGfP88u?=
 =?us-ascii?Q?fdmJUcNV5daZ8buQG+CseMQ+GGsSsMgrr66crAH5+HmtoG7G/Vv1nFb3BbWn?=
 =?us-ascii?Q?fkulfKoZBpGrbY+adx9bl2KTCsA/mUCuznIXgEI4b+ODgAMjFVoFbGSl4cE1?=
 =?us-ascii?Q?Z40Oq7tSLEfLnX8Noz/iyYZW4BQFvqvZi3aE5o4GvYbMAtfKF9bRX/J4nLPc?=
 =?us-ascii?Q?2Wlg+YHvWry3Ji1NtVsW02yxDxdh2KGne0a2tRWwtgLSXnPpcbE0d5GGXgD8?=
 =?us-ascii?Q?K0EuyswWDjZmbwlpDaT14J23u/57s68MDyvU+GV1lhMgjZ7KQN/mfcCT2otq?=
 =?us-ascii?Q?s88v+YCTgq0J7DkrHR5byjJbST6w5aGEk8tU4+Xcj4dbJ97oeOuqRs6f7jaD?=
 =?us-ascii?Q?DQdfdndl34fQZnNrWRZkp5bbYE4JWYFcVLCywiJ1rbW+CRfN3udt7SofR4mw?=
 =?us-ascii?Q?Td0lcYeZb3z0WSstRHv7Xbe6ViZzQwoQg4NeWSQKxj3aZ8Ae854xF8Jmih4A?=
 =?us-ascii?Q?kvOQp16bRGBcvvofCvn/rMimtFzdvmA=3D?=
X-Exchange-RoutingPolicyChecked:
	guxFs5gsnRZJqSZ/WbxKYIzmObCpofvCX28TlhuU76kACzs1yDOu7rUxtm74nFfigkP+X8/Uuv0t3cUE6VgXYlt355TSW98OkgVdOwE6l2Nfu1MvaWE1WI8lBsdJ30mmnGrl2tl9Ln+q4nZL1JUFEcOMwfTDqbrrmh618HDbxFAOYW+J/OcoIuxJYjdQ5wxjcW+WxeAqOSrvyJHoEU4G/tS5OJTMuXta4pyYq2EZIQnumw8FAGz516D4SQbrmr5fZRWfOSaYw13m7J6R/ET9mzaXJKgXoRJBIYss5m9zp9b9oO0cwMRrGtljWdW2Z9k4Aw8t4E0SAgndGcND77X0lw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5T5i+3Z/2yHS9ElDm03vQQ576WpnD3apGsqdvH6pwl1b1U3c7oEKFrQ6kz//cJa5nzffMFTjJACOYYG8p27DyTNLiNKytBRCuDVf3agl5V8moKB61SjlVMfKD5vQGJEwEBHVdWu2NdqJS4u7zp/0RUtiRqQfNV2HEX/rp3kc67843KQFvpdnoWzVrMAS1EurYZcZKB2Q9ictGdiz7MPWz8Dsp6YyahmlAjgunBh3muzCYBOJUDsZ9HmSx1nhCn3xv72luBWnSoAVoQaFTqLs8DQMP5ciF1DAl94rJQghm89ytQ7APfIa1HI4TRJIZcs7UEfi7p/Oa6Dy6vXcYwwSyB/0RQDv3bKytij5ws918YdmLs9WONHyDzm3W4U4H2qLwfazMXafDJ4sIr2fz1v2nggY5mEH+GQZgYAZ1h7fpeBDWxdNymCAkYrt0+orzgo65MxeKMs5KOmUUekKH8mlO09ONzXJ+hVRoa2XAdOJ6kOnkUoolF4hB7G9EEN6f5myxhxSRRcGAG8dTtO9QCMp+WcO40dT6X04ryckz3kiuD28nnLbccrq+/SGP+1LYZZfHxfxLPGTbcC2MgOZ6POc3cX3l1/SuSN67SL1plW92uM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1067834f-81e8-4b17-0450-08dea516de17
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:16.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJgN6j07OtBoVbLbStH1l6oN0VCtYuyeAV+DTumkxELK7L/82PdXxnR/cMh/U4Hj7oTngv4HnKn/KiwoSECp0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=992 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Proofpoint-GUID: ldQcGiKKj0KQ4J4zWYI0-lxxu478TQQ3
X-Proofpoint-ORIG-GUID: ldQcGiKKj0KQ4J4zWYI0-lxxu478TQQ3
X-Authority-Analysis: v=2.4 cv=CrOPtH4D c=1 sm=1 tr=0 ts=69f095db b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=NEAV23lmAAAA:8 a=c4o3e9GF2tz6pKNFHFEA:9 cc=ntf
 awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX5S0m/0a4mKmu
 zVUtIm4qbDXZhEDDvdOpjxGUDSkAWqd2CT6+RecBH25gmdghN4atatlQ02ixF9+iADqPwupCBq9
 e+ILKun31kUwpULwky+lcvlrKZjN7vC3GNshoyayxD8Zwa1SP2Q4D60+d5M8R/jtYdtIs2fUUCn
 KXRjVZ35agiOWwgnkPePQDCCiDAWwjPSgP0A8Mym423I98NgoaX3qyqSnNR9s1FW5MfRkVQYV0N
 qVAgQcSRf3I2OhdxEO9pEcQ2/pMg1Wah0iSXZwkkR3uEyiE8b7UHfg4NgKi/re1Z/POdti/vUwM
 sukU13ZoWt+KFTmloRCC484DMnRXmQ6SCR7HeXHRnNyF7UCXzZUXkRHYA2gU8ZqGvBlatZzeEDM
 GvqN8+tIivFE8mJPnglFzehLJOLnSHSuBX4owN7lwNdbKGyR76tIr/k80Tygd3H3VEgygAnICN1
 hNbQHYXp0COHu28vd2JsQlIM4rB4I7q0K0J0FOD4=

libmultipath: a generic multipath lib for block drivers

This series introduces libmultipath. It is essentially a refactoring of
NVME multipath support, so we can have a common library to also support
native SCSI multipath.

Much of the code is taken directly from the NVMe multipath code. However,
NVMe specifics are removed. A template structure is provided so the driver
may provide callbacks for driver specifics, like ANA support for NVMe.

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

Since the NVMe driver has some code in the sysfs and ioctl handling
which iterate all multipath NSes, functions like mpath_call_for_device()
are added to do the same per-path iteration.

Full series also available at
https://github.com/johnpgarry/linux/commits/scsi-multipath-pre-7.1-upstream-v2/

Differences to v1:
- put current_path[] at end of struct mpath_head (Nilay)
- drop struct mpath_disk and keep nvme_remove_head() (Nilay)
- don't pass iopolicy from mpath_find_path() (Benjamin)
- change mpath_access_state names (Nilay)
- fix for setting mpath_device.nr_active and .numa_node (Nilay)
- fix uninit'ed pointers in __mpath_find_path() (Nilay)
- simplify mpath_head_template.available_path (Nilay, Benjamin)
- use DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE (Benjamin)
- check mpath_bdev_submit_bio() -> .clone_bio() for errors (Benjamin)
- drop struct mpath_pr_ops (Keith)
- drop mpath_head_template.bdev_ioctl
- drop mpath_head_template.get_unique_id
- drop mpath_head_template.report_zones
- drop mpath_head_template.get_access_state
- add mpath_head_template.ioctl_{begin, finish} and drop
mpath_head_read_unlock()
- add mpath_device.access_state
- add mpath_head_devices_empty()
- make mpath_delete_device() return a bool

John Garry (13):
  libmultipath: Add initial framework
  libmultipath: Add basic gendisk support
  libmultipath: Add path selection support
  libmultipath: Add bio handling
  libmultipath: Add support for mpath_device management
  libmultipath: Add cdev support
  libmultipath: Add delayed removal support
  libmultipath: Add sysfs helpers
  libmultipath: Add PR support
  libmultipath: Add mpath_bdev_report_zones()
  libmultipath: Add support for block device IOCTL
  libmultipath: Add mpath_bdev_getgeo()
  libmultipath: Add mpath_bdev_get_unique_id()

 include/linux/multipath.h |  181 ++++++
 lib/Kconfig               |    6 +
 lib/Makefile              |    2 +
 lib/multipath.c           | 1293 +++++++++++++++++++++++++++++++++++++
 4 files changed, 1482 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

-- 
2.43.5

