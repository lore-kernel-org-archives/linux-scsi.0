Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7903624B3;
	Wed, 29 Jul 2026 02:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785291393; cv=fail; b=ufDLf2Avz1qatq4KsKleylF5xLzmkMydfeBx3guHPYnw/TIZ0u/WqtuuOuFF9XO0wx3MJ3+JEe3mdY2OnwA25VFNAPFqO/dLD+sfQQyjQjPp/ukc/Zk8C5DJSeVZchFh+SPj8ntTtgzRYonqqO/0QzoC6aNrh8PyFBClBP9NG9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785291393; c=relaxed/simple;
	bh=2o1ifnyf7wkT70OtC2BKAf1BjMuBBEPlWqs6ztLn0jM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=p7bsHOqL2RPDPAfJ2yrAL2qVD8EE2FUnIYO4GbfPOdXDwk0n6Cw78DtVjGtZm4vPTQExrY+HUZ12bUgdhTzJKel2lSwZ7E42vjKMq/J6XUBrC1TvJCqH+D5ePuYSC91UNH0co3IltrS5wPvAhFjtPAuAE6zjyO4BbipRsA6+NDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k23ktrte; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z6aLEaag; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k23ktrte";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z6aLEaag"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SIta3d1401890;
	Wed, 29 Jul 2026 02:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b+o55SPrXUm2oBwspm
	SccAgmQVW7TAMmMs+qwR7OGbw=; b=k23ktrteASmI8YZuj1DPxVkZL+kX0hP8mt
	O1MQOzwIqn3Lisgo4SHFZE0tIqVg5eTscNQdye9Z7VOXy8ZpYbg3TPTxQ2h3Pv5t
	4xUanNjlBGSw9fJDurFCoN8C7lTkYQywXndheheRx+UKhJrashvwV36p9ulRrGDW
	9amQXD6MqcsExWuGu27K3G+iR2nAC/v+qYSxL1ffxUugXCtQP4LQNeu9JPR6RCBo
	TSqhjTXpeZD9DafKl7mlz9sbaaPehmbPZ9VZtog0DwGOvial/GWoB5o2ASP53h2o
	3Q/DpTqJqIXPAyxPj4F24D3d7YmWgUWCbZA6oABemiq2mZRPesKQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0157sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:16:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2F9P3005506;
	Wed, 29 Jul 2026 02:16:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013009.outbound.protection.outlook.com [40.93.201.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnhekae8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 02:16:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKk2xoeemI/pPhhrFqIkqA223mk68foAzlwIDLC1aMH/utKEB7WFdyGnMb8ddwvEjeyRMrJQqK4+IbG3gCh99HVmWqmm7l46PPqreANZYISGoF9Kj6aAhPDIFAhz6XlcrrlS1Wj7R/3hKLULPH//EBKDl7T5+2c25g5x8jC4IRMJQHBiaGV2LUeu/e+/jmuW4OQHA5dcgHHsWXIWudn7gHM/N5GQHm98MGwuHv2ZEKWizGkfsggbPuUbh+XkuHfAfm8EsfKkmhuZjGZKDP/djdwglQNpBmbauynnWYhZvaw+/+N8yo8j+qsRk/MFRBnpqEytwGew87eqiRj7loacAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+o55SPrXUm2oBwspmSccAgmQVW7TAMmMs+qwR7OGbw=;
 b=gzBnNj88CnN3xLDx3Sh/T5+aVDpJvSZIvInjFkq9tIq2rcfTE96RiYNHh79C4Q55EW2bgBNyXz6bhHEgIr39x4SmRsbYJWwaDVg4bW/KU1Vd6XNJnflJ0xHjHwnmTKWJDpVhBDf6H1bvPz5lntzWgQXwiJxKaBCO7ji4WaLil3Ny8lh0QvYdXR3KJeltThreEDytJCtf2INYDZrTgL62ihmsmVPORbVtaA1tsvAbcvTjIlK9aE3okSG3ypc08Ihu04EQbsi52IdgiCShP+GCZpshRtX4VyIrASB36Wo6LB4X0AmbWLZPHAxVWNOTAjQroS/drGr3kRsf1N9qTjcs4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+o55SPrXUm2oBwspmSccAgmQVW7TAMmMs+qwR7OGbw=;
 b=Z6aLEaag6bXMHwKmXMbRRFRVjrWd0l3XFzw1kf5Zr2XJ+QZtmYn5qNgp38PG22h+5TTMb9GR4OcGMThfbngLNu5xtWqyPeBBMxlUHt6KEJiMPpKbtxY2rQaPfLcLjbUCoRWc6WC+cXMzqIoz4wLhSD4F4gQhObcenl5jZBmG3/k=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 PH0PR10MB4550.namprd10.prod.outlook.com (2603:10b6:510:34::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.12; Wed, 29 Jul 2026 02:16:22 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%4]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 02:16:22 +0000
To: Nihar Panda <niharp@linux.ibm.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
 <hca@linux.ibm.com>,
        Vasily =?utf-8?Q?Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Christian =?utf-8?Q?Borntraeger=C2=A0?=
 <borntraeger@de.ibm.com>,
        Nihar =?utf-8?Q?Panda=C2=A0?=
 <nihar.panda@ibm.com>
Subject: Re: [PATCH v2 0/3] Request to queue zfcp enhancements for upstream
 merge window.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260728044857.2532646-1-niharp@linux.ibm.com> (Nihar Panda's
	message of "Tue, 28 Jul 2026 06:48:54 +0200")
Message-ID: <yq1jyqewnfd.fsf@ca-mkp.ca.oracle.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
Date: Tue, 28 Jul 2026 22:16:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0112.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::15) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|PH0PR10MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: 504c5ee7-ab73-4f32-fca7-08deed176244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JRx1X9yG+TOw4UsKO5ldO1Mx3DjKzK+WMpvv+8A3Zn0aGKhySL9gz7Dsl/3lBY8SwoYyMjhPracSCcCbP1/myC2uYHksdEUKtnhSiwuVS+4UAgiXnZWEdN9RPyN2u39rBiS+bEmkjx1qHMXwKuYJdlXB1/PMhlJbHJFQk1TBjzcoGXPkIwMj/RmONWX4uU0AaZSFD27dHBVX7m+OFfIPhza4KTMxdPJqIu7bKBBw7N57Gg9MaJ/ZT/hVktIdqO9EAthQNQS0O/LDwKomrc5fRsy0QUnjoCQT79lyaGliegC9+w1MyeabZh8CEHbvsK8R1tGhFnp6fXErMODeGpXlyxA6F7wTgg9mzP1aYGOi6uD9ZHzWiW8WB1hWgUPyJidQql7021jCYucsGs+G8FTd2MAD+kRuasLhDqvK4cIhK1MLvJjOJ8vZUd77eGc0hKz+aRWL7SH5v1SgYgp4bIk767QBtoxxbQSNCeHECgXIjr1xcLAxY4N5C68qQH+4SdFm381P47KVep0ZhRsGF+thHXfLmxbcmc7P+RTE7/5T4akYXPhF8V1yhliNSS9L6zPg6w7cXdWO4NNfVYMhfEtqfqMT7tjbZyjLRH9jJRz+2/iN0U2OgDaY7HvHKRMYk4DVIq5q4s4GSsac0cjpm7PUvysuJ4iNVawOCq/W5rJc6cg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e1+HRJzBIvqcX5bsmx6G+9VcONWeK/irp0fl9IUbnBkSk+rCJRjNzLz0wXgs?=
 =?us-ascii?Q?D4l24t3fZkiTq1iQ+6RhTf+7tgvpFMWqm07CE7Yw1+7cPz1auKCdIl7DCR5x?=
 =?us-ascii?Q?XcEDjE34A7uLtoBzcG9UzhsxRSTKUY/xjr5p58q/S4KkzG3gvpDFUMrSieAX?=
 =?us-ascii?Q?uQdhHXYGdjfRgp8hJD06lkdm6f1Z5Z9v1tWstQpmWKU1f4AUg8iu/3okpCst?=
 =?us-ascii?Q?ZvNRRnPV1xx2LoUxsu0nlWMXcfLuNZOec070lXVKRWQGYMh9bIBWVSpS8dSq?=
 =?us-ascii?Q?1x286SH0uAk65XmE5j/HP75LOrmFehnK1Qj4eSzkk7I3CFG404yZdBup+e66?=
 =?us-ascii?Q?KY78fr+F4bdMH3X6fls0rbGJv7s7FWAec4sNmkFOARm2qcBKDc8USeo9PIms?=
 =?us-ascii?Q?bN9ISqQhsBTzTQhI8d1v/5jMYTwI09Osogi4sXT5Tz6Tp//M8QcrbpiGI71P?=
 =?us-ascii?Q?hyj9+epP7qaQjeqQ0naHAyjUXNBn2K7Xqa3wHeAs3Dn75IcxLdedJFr0Ob+N?=
 =?us-ascii?Q?h5TKd5N51kJ7euGt60erV8PiKFu4vs6vkI4qoVuKRLe7cN0QhnIU5QqLGnsJ?=
 =?us-ascii?Q?CQqtY3hp15Ib4XjSESSqSsRpFs02jr10ua5rHj36CZPrBRKjjIWlShS8robY?=
 =?us-ascii?Q?bZMB94MWYeilpz3Y428EX2rS8C6/vW3gWg6jH/y62ekJi9pwMZwXQPmiL/uQ?=
 =?us-ascii?Q?hf1aVS0Zxsbg5r4Feln0RMOB841Dg7T5N+Myzj36eQysGXZEVLqu1GwYaiBg?=
 =?us-ascii?Q?YrI9DgGBK3PS0xj0PnvCFxYmQKrgreya6ujHNZe4YejORwjQz8r3igLze3zs?=
 =?us-ascii?Q?GgmnJwNV5snGD9wES7heCd4YCzN+2gX5iIglO1r5qPWHyb6+ZHAWEgfClsPf?=
 =?us-ascii?Q?uQfyHHdog8wUd/fuyx0gPG+X4kG/sXx1RoD6qQ6AFiluUXNRhC1YBEpFfiwu?=
 =?us-ascii?Q?uh6wdZ8MSYgXBvQY0Kf3lx77YX4Lc5DlHSeFmAPA322ZWVKwJqItnMFSJ7qY?=
 =?us-ascii?Q?oEwMr4riWy7sT9Ez2tyhpPelh1h06dyKhnpd6oX8x5hpLf+hQA5j9kuzvyIb?=
 =?us-ascii?Q?vnd+T1PJ4YznUonCCmqCmkR7IQafe6ttXnC/Azo6+r1qtwW2oPs6mAu/fQYN?=
 =?us-ascii?Q?FIrWKrA+J7HHmiDU02L84jW2sfoaSFAsgPcpIH3W5u5U93qYgdbHwloWqCS8?=
 =?us-ascii?Q?lhoLFd4ZGum1BTCm31dTprwceASSgPH9m5/80zftLLzYDjsiR6juN1Adpx3K?=
 =?us-ascii?Q?13xBsXOtQ/WjJ/pQn1cnPL0uqYSEIW48LhCEG9jWqtHxP/DMMbh7Z517pxO+?=
 =?us-ascii?Q?gya7xGK5+w52tp2mv5MKsCw+e64dAo5FPju2jPUzyCxoxHkID3YhYchY0Ldk?=
 =?us-ascii?Q?qQCtWs4rfeCzixZw281I2Lo78vMRjhyQw54YpW6zuT+a4iyaidloWm+X4BJ2?=
 =?us-ascii?Q?SNVM/EtwE3XNxVbeNZ4PmU14DKyMf+vVVEsnTLVIsoMZ3YNSx5qaTEMqi1s5?=
 =?us-ascii?Q?tC4lsA3LfH9/GxQyJqqtzDyFZHKUOyqo8Mcd+0OvvJU6qzXNkVucoNM6vKzg?=
 =?us-ascii?Q?3SuG5/7r8upXnnLmWOudLAkhqlpuaiNodFDXyq4KI5ANRkDqAFfIniE+MEy9?=
 =?us-ascii?Q?DJBoYU6DCwBk00T8PNM+By0oyFzhfFRmlPTE/l3e8SaaWIaftdUy8Bs/auRX?=
 =?us-ascii?Q?0S/5B7kTF1cRrg8lB3BAw+zbg4/olFUCUNKEgG0MWWAV1GdLumawbjwm7oWY?=
 =?us-ascii?Q?HJ1bUeTIk0YLzFh3PRKdP240nku1CGo=3D?=
X-Exchange-RoutingPolicyChecked:
	Ql2iqoIOf1ur0GilOLLfkqUhLwh5XbY2g3TmxOYPF9grwPiB58G15vIZ2AXUpfTIgGd8f74GUZKwpa7pR5bDl4+vLeGOcFO8cY6qv8x08Yb3PtDKzTIWtbx1BUL8PVt8vicVD/KjOFRBVEnhk898JNLo2rFULfcA2U86b83goMbIApCJc8OHBTlZhP6AGo1SrcsnK8KmeMk3TX4Fmk73/814wOfvDdASxiTR2IjVIh7Vu2pj+q0O3un12LopBHddP99q9L7ypjgcAeP+4OBxqSS094fNHmMmSus0pbi2iR1z09tizZa7j4eXbBtshZBXyBE0PYmI+3nOEcjZer9i5A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MQF3Rxp195S8N9x8wa/vVA13rS+YhBHKGI+/qBuE7HS6kx9ZtvIU1RzElF+rp6hV/NKlu87r66NISmfHjB56/6rJ3hnQDdowqIPhPlLsaVgslE9m9YEtTcaWsZxxdlpW6y8y+ld1Ga22zrPJOFVZCWfd+uK27RP2h3JseESq5AmGDIoL3lezTiHsftb72GBTcT9FpRHTZsvwJCYAE25CsNzaHo+afjFEewz3g+WQiPHZ/bFlVEAbuCESj1jPQEze5PZEZYf9TEqLf82ijH3dfv+d4cZjQ92vAUrGH8Z1bORysi8SLTv6Ezr4Q3mMGDFHLPnxpZb8V57CNJPJFMKBDL2mf8Wrap1uVpRlcXD5i0eO6eNy1vODjTGOIrsk3bKTVWFruoRwHzDKac/B5lfwzoOsPD+MsBMc4FpzNFlqaH5dzfVKnbbQFetWHdqLF9IuTUfKeAV+1fAy5nPmy11xSgxyKqiO0vEcU36X9MrQIK8KDnLU/OLeF+UC884fpFVXGX7vJWGv+hPdMRp9Rk+WRefRa4ligsu8m3LkiGapDg+/uqHPZuU7TtJtgyV9JATzW+paw30pRRdbEzotSbpG5O5RS7d5JD7fBgdm3Jy2coA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 504c5ee7-ab73-4f32-fca7-08deed176244
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 02:16:22.2926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCj5CGiB0J/jxFdK83834oMG6ICFwiTxlVTdkOfRwzJ62pyzoj1Z9UKX3a7jTGpP76EKYO9G1Uv5Gp+pq6o5K6mZcrmKz/yTol1c3ENFA84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4550
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290016
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAxNSBTYWx0ZWRfX11lna6yZ33ov
 wu7jIBxZ/8XHYEiTcmwMsfh8chx0D92M7t0Fhszpi3T7vtuURkpXdksE0AMwuuBdYTtRgRaM7id
 d92u57G2VkSjNMfg37Oo9zTO5UiOybuqbvNa6gjLPSXKMIxcklqT
X-Proofpoint-GUID: 6AzgN_6MF8CJMzxAqfN0lz43OAKyQ2c_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAxNSBTYWx0ZWRfX9gfgllXAXwfA
 pLUNT3c0WyPm3DJmv3NdcPT9cVTuOIzpFKs4prebvy9t9Ey8jmUngSY1GWjo80DJnKDjs4dQ/ij
 KIPjUvBZe/NZY2LAXez/rTjf1DmHx/27hf9HNY0dIBHwAUsngmFsK0NL1fk4qbzg592bw9iiDHS
 fwbv+DLh4Q3qnFh4UB8zzRZ86uFJy/B6PcXjTIIj2My9J2yRfE8orqAvylmieGVVAGxxy3YVOqx
 UVCu6bmKLjSWGyGUJWI+csuPMUNHLfp4y8FBALkQXwpiG7x0iD7v/U49qr5PYJQtMPnE0l892Va
 TIXOAt7qM9LqN1c8qsrA/VWNNVTfYgyDsPysvnLyNWw3stxGzwWus1fbJWNEUbZW6PAJxZXb9nk
 zZiunH5INGgYgYD0f7143TtOJsRdeBWKBcbO1KmkWnub1HkWg9/5FVnJPmproG4ASA4pfNt7FU4
 9M7wvbOG7YjNq6rJ/Zg==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a69627b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=uALulf2T401AiPjdZQkA:9
X-Proofpoint-ORIG-GUID: 6AzgN_6MF8CJMzxAqfN0lz43OAKyQ2c_


Nihar,

> We are submitting zfcp enhancement designed to improve trace logging
> for the upcoming v7.3 release.
>
> Regarding the sashiko bot feedback: the majority of the reported
> findings are legacy issues rather than regressions caused by this
> series. We plan to resolve those separately.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
