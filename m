Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311A648124F;
	Tue,  1 Sep 2026 10:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259618; cv=fail; b=jgKVNu3Ze9MOk5875sSpQ3bkx4up/CY0SfxV/M3pcRDcmP0bOm752XTuGmdsrGH5dL22R/lt3Bz8AS4orMaizLiCMxacdsKylroMkOzzk9k9w1J1mUMhvzjrJRCFsLT39ju1zGaCkhTZEl0fmbSyURSJC9pUDh74o6EqFQeCgwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259618; c=relaxed/simple;
	bh=eNYLT2Xq7HytdMY8FlA+bswiC4O4B47RlvkZuaCWdl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y8CApKAfSK85Ji8MCj2UgCSJH+jK2m4/4BxZptyh9/xkQ0/tGP4bRoaOq3i2yvw0VO1Ch1AugbTdNN5y41/g37a12ysWy9gUzPleONO+fg9aS0I+CQ44nx/FpCSmzYd51G4zuGZ8uG9CH/nqhAcBYMr0JaKV3m3zcWXujMBIiVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UWsuq8ti; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tjFcKpVM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UWsuq8ti";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tjFcKpVM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6812psDI2878056;
	Tue, 1 Sep 2026 10:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BbHnirOdSaShtpQvZ9aML1V1Ld9TJnnVoW3N7sLn4bM=; b=
	UWsuq8tiqcC8LKLr5B0GeDfM5z9MBlKfUzir0t85tukc7iiTnBVv+SuqWj6bnb5W
	J3l4zY6sWd4/D5BQtxg/8j2SWcLZvdQZHKYPv/aj/2xFMIg0hipH6+K9D7aD5uqf
	geudZVU9dlKmdZ2zIPD2hio5nL7EW1j9KJ+9lmNJzwrWWvvmwCQVSYANQ37pXUJg
	Bv7K8fmgRlYavU7Hojn1A3iq4KYk3WImYF0YJKoIfikd7snsefUgAwsQMsWiYPxp
	bP2dMx5fnJ4clHJnTvZmMIs/xC4mC2uvBEk6H7NYBARHsZszEJFtmIQCc6VXAj8M
	8nDuRcOMfDZBCdH4xRxrWw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbq1smbvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AYtk1040131;
	Tue, 1 Sep 2026 10:46:34 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve8nf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQY4yYA3cA2LAeeLzopbDMYXfaRxib0+xxlqSoAMpLUXBl4t0SFPGTN0WQMqgxCygEnBxXlM/WXxqLsGplavXmYVdT/hyRsrLrxloQQyT7Zbn9Cbbyt9VLMQYCKPJGuLtShacUwydH+PCjPg8dPsrnK54gUvEkl1ldPiBLDm0SrqgoxE4rcuDkYJo3w4c1sL4sSZLCNISBhCgDq/b4/f9ojanaCEi6M00SA+4eOKsx44ztZTKZmYOcz7/PM23jQ3ZxE1NBoCTHWE1aZaTwlSv8JldPSbnB7sj1ocyZYW7JoP3P7enfpSITr5SPncdq+jfAdfh+4qdRcOPVe5BydHsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbHnirOdSaShtpQvZ9aML1V1Ld9TJnnVoW3N7sLn4bM=;
 b=Ai+j0TLI9pDM7E/nCYow3sF+tpEVsfYp6dAtYpMlUb8pJh74jcwbz+YC1D3cTkZ1JcOqttFRdnYa6YSWAlT25m9lCpd8jHxkyv/BS8qgCU1lk7AQhGVDE3r9TY8RIufCtQC3ut8nY16q2/qBDsJxNmV6SPcG9zs6WBOwLaq8F6QCnTxjKVK0RPY4/HmQRWcnxBzVwqY5TF/1AUcQrMTOxGApMTBKfh3c+1B0rQvrDZqmGbxfhF9xqeMl0fym6HryaNtiAKkGNsgTmEM8jdrA2cet3fGW0rdu7bSUQkRxTllDpMbwL99NrnquEULX7hYUxEFnRthn7IuF4rpn3icxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbHnirOdSaShtpQvZ9aML1V1Ld9TJnnVoW3N7sLn4bM=;
 b=tjFcKpVMI5Y4ww1RSv35XUoWs/c82Qy0Z6n5NQ1eUMiwaJ+ay9xC0AjicCsTzP0kH/p2Z1lahUY3i57fnDXdEw7ndhv1PPyNrW4HiJreJfI/7iJTdhONQspF0rFhyKgp5koK7emXoHCKP1kpIPa12FNgM3zxO86aJWep8kF4lzc=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:46:30 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:46:30 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me
Subject: [PATCH v7 26/27] scsi: sd: add mpath_numa_nodes dev attribute
Date: Tue,  1 Sep 2026 10:45:25 +0000
Message-ID: <20260901104526.3850621-27-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:510:339::33) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: e04dc813-fdd5-4931-8be1-08df0816484e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	xvNVNwxf7mYUZT8BoBrhzxvXmr5P8NmYrTmimrwyVX5dywBODjpkLEMKtHPbwDzYJO15YeNwnaFcGUANZfawCop8oAJVSVKRxuyl431JStCB+xXYZT2jk75sEgZpH7hPb0GhzKSFDv3qVBNB5CoRxkm/kIBOG4rMoVZW+WlYPrg/iXbe1BmXFO7T4hNqNpTNUjWF8Tw0P3W6XGCdI5F8vaHl8OyApKLtBBsWM3s6hqDTm5Cj2pys4/rafKoYUQIdMD5u2Euvwa88+cRnZPb8Uq4swo3hOboQ5qyijUlNqNrs/cJbFksLY/RiXYjGfcgidcEbi79d1Sfxm3w0pzugeGJ4eGgvtNuHUIXmWq8PTCDpF0KrzPG4Xi43MRB8HYhXzcO5zVagmhnzJkWy+DzsgNn4Ap/oACb1PXySClZVJSvY518L6uXzq4LNY+4nQaYaibxYwBZre71uzUiOJv8lNd7j6cXG6nUCXdey97wzKNdQ0Ht8U7QWwwQyooc2ICUtLlIZGOrMwA0xYNSpiEC9g9CLu79ycUzXCWKS4/ENCsQLVwVGcqmylQ6Fo65uqa9YmUBWvRWqV8s2dthnLxVyFhWjOt/0IYge4OS8mubKHDd54FlB3v0RXTAqIAcs5DBFptApaudrls07WEfvL0r2dvJOnLGd5I3oojCJ2XTXW78=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oOjrSE3iPfWSu3RGtaYAEfpMFULYhgv1J1udfsfLnjsX72iQHK4KlolX2ISB?=
 =?us-ascii?Q?K9VuFqtAeBomV85g74sSbTP1BRbsyx32ReAnwkHUuVxqh3yfW1UIdcRqWpjN?=
 =?us-ascii?Q?MWEdfRMPdZOhvH/zsYEwi/HuTtdFKi7W21yJcynV5RH6/HrT9mTBNHXJrhj2?=
 =?us-ascii?Q?VvY8Oc2929/0/CooOOORszU34zuwX5MoYeO9vpZ72b+4BhbnCqEfBtq5OydL?=
 =?us-ascii?Q?a9CWUQfLUdt5DHhFggfm96eT95j1lPkAbCgYyqZ73oCz2TgUefreREVUn55V?=
 =?us-ascii?Q?g9rynQBpjzpSsQsGJ8vLboCx5pSc9S32GXxmBmM0GHBzKDEuNHi7GV4DSjoG?=
 =?us-ascii?Q?Oyf/Qn7e4TVk0dUNt9ZSmxy5ICbzxU/a6ensRGUf3DWcp2w64T0979W7ZZfJ?=
 =?us-ascii?Q?cyAxO/aG4YrbLj2Tz064z0m3pnMXTzHUdO/AFTqxRWK8BeeQ4v5I81sLUS6Z?=
 =?us-ascii?Q?Dpd1EJv8yQpk/tbrcCgf+cFBKUJKnp7490HxPLY529TkoNjmyIFNfPZG/tUE?=
 =?us-ascii?Q?4mE56Ehu63Bndu3Zvv+PgLqrGstiKgT3/SUL+D0rlx7OsETFpceTFy+gDFIb?=
 =?us-ascii?Q?tdJGdhgABe9I3ETM1xzFOTmSZqVyANLpQiwdZAfDN/dd9mrLB41wdA55eEIo?=
 =?us-ascii?Q?ohMhQZOfciQtVipMNjt5tnXtQhf/QoFePlPPOsp/1bAWH8WsAA8e1hJZnFAf?=
 =?us-ascii?Q?svwFYHGtivhbQVUvBCySs7gH/UNU4+QtE7x5JpjQHF/Wsh5oLSrioUlAtWhz?=
 =?us-ascii?Q?A3Ew0VKxJCGbQOQ8dtQDhqGN9tBiE8VOAw4veV2gbKdqEumdY9qBEpAuvdMs?=
 =?us-ascii?Q?tfPix7IGyVFAdsh9AX53Wj8j/PjoKFcqb+uEYi/i4sJU4CpofNQHq5FVQz9d?=
 =?us-ascii?Q?b72+ZGJrmZ32Su5F1b0NaR8+6GwCPxB0zaez2L+vrkeKWtI4ll6GMaMFWOTG?=
 =?us-ascii?Q?UhcRKdRVpuLOcG2n1SU8g67wc0ioYj+/MXHtJ0X2A/Ffp2ZvP/Did4HTzXgX?=
 =?us-ascii?Q?esVglg5uIgY7/Drl6jotzEocKkycpIxNt3D1FKBBphO8vtXAYlGix8jObSlE?=
 =?us-ascii?Q?yhdj3FAF1hfhmlD0C3J0laWMR1awasLy279fumy8ke3BRYDL82EKQOA0gcia?=
 =?us-ascii?Q?HDwToe/lrpHJRd81xUPNOwb2lJGyikhmf2RAEVMfOAnnsBO6Aawh5N4WJoZj?=
 =?us-ascii?Q?YdaDtZPvtddGTCKUIzqMkAw0bJ8LrBJ5SZ+DtMtgO/+t25gYrZmKwnwgzZWB?=
 =?us-ascii?Q?pDJb6tJoXUgZameoyeKjHSFr1WVjs2epBrZC7pPvdEq7ASFUVcf9rjnLC7S8?=
 =?us-ascii?Q?rVnYcAsixuzMgT4fige1IMG3CAubenhAiePQiaaDPm1JZVcgciz3XtKKQ6a8?=
 =?us-ascii?Q?IO8JorBC6a3wBfLwDMXYMf8OmaAYUr/AdfBmYI4yHmikC3ik0YxwCVDOZH+b?=
 =?us-ascii?Q?HSLX45nhLfDKNRn6N+kvKDz1XL73zDwpXE5nqGJCQuk/gM0vSF+3qKIEYYl0?=
 =?us-ascii?Q?TzKOsicJ4Fxz/zI+hiB6xRCh/QIcbUF4cdI6eocdoIxTdERe06grQ5tyv4Cn?=
 =?us-ascii?Q?jXIcpX3CB+GsChs1GN3hG3mP+biLcKE/4x1pttltpzAMxLsiVzQPtS4eRa+W?=
 =?us-ascii?Q?WjOPpeDDLpQTD4DYTs7VHpLNzLo/DOS7NgL5ip+U8NoxHc2xJvhfZs5PRDkQ?=
 =?us-ascii?Q?5W3KtgQGgjqPVZ1Up2w1XB3vAUwaLgxcrlReSbodSJAddf04rdeGevh++gzL?=
 =?us-ascii?Q?Q1RWSiOJkozYNAmLitIzIzUnF38TDd0=3D?=
X-Exchange-RoutingPolicyChecked:
	ymM/Onwq4g6RbyfCvH6/KsSIGuHRp1U/Kaway2Y6YP7WBigT0TSMSXjvKbyKVDmZQzxz+oWfmrIVMXRrBIS2/EQkV2AcFHssbUDjDTJhP9PSxEpb7aqni/6t0nqGuzCa1mgiCVaUchZUlFGD1WX3qEl0qvjRGRT9c4atVqVXugLOETLJhkmK8FhF55KdC1HAIwUycEcykTnh5zx3ChmsQGwaKGqnuP7FQTlwLEaKDfV6+Mq5Etx2YUZSiD9h8ujfoWMdcwDMKHmESZMY3Cqux/ZRwB3WaU0J+kBw2etjg2lvN7TVirtQWKmqsDcLm2UBGTMRRgfzdP9wBSkHsvCvBg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GI/wks+CMxjjxoUqh3ricoFcx6QJ/G+rqZ89eZe2R2jPCDCKHLK8tpSjfYBVvVaxjqLUTYF9ovjB0Xv6w+3d6nI3mlp7w7TsST61i8aybHMOHEvSZdAP90M1khONtioW+jgLnujKckJhyBYW4jDtt+5WuDu/8ZVDZYrnApiMlhZEo9/dVWE30cVX8ctG8REmKomtbkkPYwN9OfIciZligIEnAqNHNe/WzxFR9g3VWChpWgqFzLAQN8B0XY62D66FHzh1fIqQwm01gL7y3M5bQx4D7mcw4fpcMzeoAQo0WhRfYkYEsDl8iFDwMQOTNeWcNNmAbTPsoHXLUzuu+lC2rm7I5uH3Whj8cATdAKkiE6cBGIDh+oQp7CD8WcebglIXkrmOv1fZtS/OcSYNYEOVoOD0ZKwQimiGFXanf4epR+cvT2gIav2KR0HSMF8Aja7IyYjmtvMu3MotoHPkJ4pcimvqrbr39QSaH04sNxX3tkrd53U4jbNUlf94vhNG1F5XNvhTZ4sVrbGOCogVndik7SraXIma+9l3Ciel7oHAEHZ0TroJ5ARIg3UAhB8/8nO1v2A+ALwKJJCC5XtWeE1w4aACUg+Fy+KMQq0IewxEobU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04dc813-fdd5-4931-8be1-08df0816484e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:46:30.7491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTuVBigepf0D4FP3H/B4vPrQqrcMh4QZPjhzuCzyel/JEj9jyWf9wV63N84WcNJ/XbibRIOOwAANucFfCMWVOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010094
X-Authority-Analysis: v=2.4 cv=Vp0Txe2n c=1 sm=1 tr=0 ts=6a96ad0b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=P2_R26dytZ8aPJic-48A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX4g4jO0eAlxhE
 IAizFG6PRT7QbnyvxYYf21J0px16kv3OZhR0mWwBcaei8xPiz+aTJv+xf6qM2Y0prQqG1MhgVQ8
 B69118QKd0lrt3HVD5hg5eCMtPdf4QFgdiRth68rGJz98d+2fat6uUIPPXXpseFhNSOtUK2euEq
 CZr09dok1OYaXVH6cX2QYsO/YJ5qVO5DHqOuQtJNgWRxf3+3Ntjk7DhP6zZFxUpTMISI7/lElh+
 zFAMkIBITlxQtkVzc+XBH0+yF7xMi9X6Pg4liVGCpwvOPwbZ62+Rc7hTFFQnvw6arGtuTgQi1Vw
 2EtLiqopfhpmbrExu3I/iNnqN5rENGXSvfscL9+NkkPFmRfV6rR0hxcvEVBQdiX1yySWXUkuYbr
 AGPqidBjQ/r2oxmMn+5i2mRtGUxlMgQx+QfCtr0hL6t8LJnucq+RFEQJPe3H8fqXXylUWzezTRB
 zKLyGcWrLJoaZCPTLiA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX95AGqEGs32qn
 I6zJ2SNo1sya7mVlFuaA9H6/QDihigF8IhoRm3/2NdKTyM53I3hhsSPrY/DBpzfXj9JASysehDQ
 wui7DiEMrNXugeyYBCdK5YYsM/bh42sMy010kzy95LccdlciBK5V
X-Proofpoint-ORIG-GUID: UaOC3zOh6Xg9zLTr7ktUmLCUPpoDc_HL
X-Proofpoint-GUID: UaOC3zOh6Xg9zLTr7ktUmLCUPpoDc_HL

From: John Garry <john.garry@linux.dev>

Add an attribute to show multipath NUMA node per-path (scsi_disk).

The following is an example of reading the file:

$ cat /sys/devices/platform/host8/session1/target8:0:0/8:0:0:0/block/sdc:0/numa_
mpath_numa_nodes
0-3
$ cat /sys/devices/platform/host9/session2/target9:0:0/9:0:0:0/block/sdc:1/numa_
mpath_numa_nodes
$

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8c79a0ab52575..e8227e00defe7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4163,8 +4163,22 @@ static ssize_t sd_mpath_dev_show(struct device *dev,
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
+
+	return mpath_numa_nodes_show(mpath_device, buf);
+}
+static DEVICE_ATTR(mpath_numa_nodes, 0444, sd_mpath_numa_nodes_show, NULL);
+
 static struct attribute *sd_mpath_dev_attrs[] = {
 	&dev_attr_mpath_dev.attr,
+	&dev_attr_mpath_numa_nodes.attr,
 	NULL
 };
 
-- 
2.43.7

