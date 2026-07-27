Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183841DE09;
	Mon, 27 Jul 2026 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163458; cv=fail; b=GVTCWNimPkMgVWfU02GChLIVRE9AVr4J2iC73qYrWI3JVCkaqODBKqcEK7hYyl22PAaxAdtFxXzpu1DpIhvWfKKu020dZQIUWUTTxRZ7BJtyuQwYCRjA94b6K4bLrG+FiNNmz9ZHFt0MpaTGyEJovw+LIl4EcLH0IhuKNKvqcZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163458; c=relaxed/simple;
	bh=Vvh+RNBC7oKSknCPNqNskwTdFZTP5QbJjXKFGoi8zWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SPVw4R7exWz/x2xAqxyD66uwLflzxJ9jcVkFEoquKyT+asft+DEf9OLKs3efBHYVlNpvyibE5yQT7wIdq1bUI8N9yx45JRGyjxwIOObfxgeVqclECmNOLnlrfJhvzUhdQpXaal4njITBkV5GKrTv6yvNQfSTabvEPqOMiKZa2gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lhmUCHnI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VLXL/Le6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lhmUCHnI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VLXL/Le6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTUNq2105609;
	Mon, 27 Jul 2026 14:43:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZbvPYL+2eHE3KLdVREN3VqB9Q+rodHP9HpUHoA/zxFo=; b=
	lhmUCHnIfD83PRjyM4yGidJJw3bYkDuFd/YZTts5j8+uHKaxrUJlsSa7tNjGU17p
	Gp6tgWlfzclYrccUsepBevI+nhEa+QnhKKO8yp6hOrloq3MLKNErBixy9Bbv0gto
	TbB3qjfv1Wx74Estr3R27i2GLxE8SZ/22PEz0jP2GImySX5wejLTMaq7FR0/qBI/
	nuEA3VXS18kzesnkAWXjakQTPA9VBZW0fBisOC+CqaL1uP8rogq7PpH6wNgFaVcE
	I3Fnh5gB0zW+jc/whUDhQfaMB5itbFU73kIpuDGHEGvC+SQpAhJaUsCgSNbREg6x
	0K8NVcj2GbFGaQrQpj9OQw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5nhxgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REZi7X023434;
	Mon, 27 Jul 2026 14:43:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011044.outbound.protection.outlook.com [40.107.208.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ngw21-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MNV85w47yiT2yCwAyT2T6WXa+I5mzLsdEtAnG4IMvwrTjTLm0vvasNcFqQzDW/b1XpgYgSZlsM1WXZppJmNlPASJjrEjBc4OxrOZStY6I7XP8bnaNmUkzYCp6uGVJdELrlvp3r3S1grSq2OXAvMXxMTAnuCD524OVqq4jJVJ58FeOCOtI+9lohL6m4+9amEKhCtIZEJR++nBQ4XSf/+Zb+WBUftkWG2Q6VWTI2jZtXZT2IrFwBph4aFPD2WXpacUmzJ7wEtF2L6+Lhjz+dFg99Vd0Q/IsY9oY3G93PUP0HuQ37r4R82UERsZFpZkmxX9V8jF3HiBscF0VB2LDgDc/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbvPYL+2eHE3KLdVREN3VqB9Q+rodHP9HpUHoA/zxFo=;
 b=Hic4HO69ll6HvNdhVQ7wMBbQl8jPnfI52HtEXEk+HNM1UB653w9xjmvR7OFdIAEI3FnGbBuYh31fdIhWpus74Wd4p3YbP9sgWOVzw7phipHyJkaSOCAaQk78DSdkiLh/Tam46Eg1PcrDUb1MnjGRwJ24f5lDAfuLmzhCMZlTj4WSR6EaR8tYTubR/zh/IYjk4ErsDLm8OSShLnDEVvQ5wE7qfvXogXAx4eCmx8X5nC2eQNI4Ih2bjA3HH5ju70sw+MfxwrsgIXNjdck9qLDIWtdP2rMB8XvAQsZXelS/bq+1CZI5NvbselWejOTWFYmDokKjjGuG/mfueVq/rW5KgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbvPYL+2eHE3KLdVREN3VqB9Q+rodHP9HpUHoA/zxFo=;
 b=VLXL/Le6bDRUJh5kkBK5RetJPa1VZ7RBI+91ql31EYq6Oo/EIrbMKNqZZLh4OlUXNOhQFUkcxttty/r5dk/gcy5qwH0e2mO7/FDYUljVyrjNhNeIa5o0oqMglM5vHO/JpxSYqvkEGCp8zW8srFOvaoDyvaEjVmNS/GmjhJxvgCA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:35 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:35 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 25/27] scsi: sd: add mpath_dev file
Date: Mon, 27 Jul 2026 14:42:32 +0000
Message-ID: <20260727144234.3802948-26-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS1P221CA0001.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:451::6)
 To DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a36a4cc-185e-4c1c-d66a-08deebed6fbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/BZep9NSOdVfK6pA7zwICItyVJSh4BBlxjtOGo0jOvxzysVY88V3PdEa6LbrlFphhvwXqkt3rDSqQb7hDv/IF4yqqDx+eR+r8+mx1SoD89YBmfW2CA9D8avZa81NGqOvomkzhArFrc12KDs2pHJaYWhCv2wffNadMzv4uuQVfOguFi499c+7UcbDKQzm5rp09H/yayLglxjET5iE+l7UVRTpP2UDl46gzrgp2sttp0lK9yAmI0Lv6Clx8XsRML97/sawPfJTcBbi/b6HJRFlHPS3EhpWcf/BKoNC84bE83K3RoXf4LAyZaoi49yNxj0Kn8DKTPI3QO/+M0+7MDcCtnDQzoLsauZf7jGRVoG4Z1lzNMOnYBBVRXJ8y2L/NIGpEz1vpncuGfHCcp/yezfwdeznmwpT0sJURPuzloHCnxnn/hJmr3dBUP2RtXXxOILIw770YyCrkAy35vQbK51StfnJJe0AgbNZXkTKICW8yHONgHsvWB2kGZpcHcb6zm/2CV/hkmOIIq+WPwr9ceW81B7E+oaVGcBGZ0j2cAK7l7i26IvTYS32WLg9p8kN5YbN2FFTqtnhd0CgvR/xKbv+EMa/3Yp8EOH/8+xp7/YN367TYKSj5L6QlX/z1bTyPPKJbGOcYYlymeW2dou6txnujDUGoIt3q1kk58wg69AZCoM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FdapHZqN2jvprADP+F+KWYnafJL8gZhhxUA0Js8V1/Kkzxn4/5TpEC4y/CI2?=
 =?us-ascii?Q?IEggtWOe04jR+vsSX8biav7wuLACkVCcrmTESwthjAfumyePQOv43MvRjUdt?=
 =?us-ascii?Q?6ds/TIw44D1fBAC8fOscfZhD75rEvHIYAnk96n1DIBTUWCQMXvslg+bp/GYn?=
 =?us-ascii?Q?0xo6lAEOkzipdNeZ0cD+3B7IAg4smzWzeG4CKSTKdwZCabWFbaK6D37+It/f?=
 =?us-ascii?Q?Om2p6RlqPfOKQTHILLkzzyNmEOJe7BoJ/62wiElCp7/CMrIPCLQJLpmTOQ5X?=
 =?us-ascii?Q?sFr0lz+HbaozN/WEWLuvr3sXvmzANRziHImyLbnnv8nut4dHxjvEBA5oGoPf?=
 =?us-ascii?Q?bZG+jdFPo8i3mO5n5o20jNlq/eMWTStWPbEPtNFk1yP+uuGXyoBvDk3s3Zy8?=
 =?us-ascii?Q?GGRqdFKPyqVpaJREqMOpRIr+S5X6IXplY6IwUwLd/dNG0tIFw07gb2abWQdh?=
 =?us-ascii?Q?+DSsLoNgs2HjUqN1vus+0XNLpjIIRkuUW+pQCkqOHBoUou48KpxE5O1Jmvdq?=
 =?us-ascii?Q?1Q48JRM6UXTrkXrcuOXEc636LjAryqimmPvL2HJ9ulgSlDTZEbWKMHXi0dGN?=
 =?us-ascii?Q?H7WunLHej3niBRyO648TW9q2jEd7LbUbodyNGaaaY9UYfCBO3v/Qa/QjXhvT?=
 =?us-ascii?Q?bfnAiOaqoWRg2Mc9oDbvq6GF92RnUPZix/SxNLAnR0hsr3u5VjVjsHbdtPbg?=
 =?us-ascii?Q?N1S1hwuIuD9ocqLQ3660Vi6v+EP/zIxRf+bu7uHMRXObf0JJHubOEs5C+e2O?=
 =?us-ascii?Q?3SiSP/Row8gfafzea/SY0Hq6oNZYeEg9CGVJvDhUuX1B2RmSpKvLf+1LrtJW?=
 =?us-ascii?Q?NqP0HffkLPIO7hikSHFCEzzkbxb84nAS0fyxR2j8LVp5nq25hp0UNKxRf3Sz?=
 =?us-ascii?Q?XYB8MbNSUejasGn6WoBdiiBMA1Si01oRi8RtYQEuTBoBNMPoitO0gMiUYrUH?=
 =?us-ascii?Q?ZaYHq5Jj4f3tyxrobIOcTFxodDXCB3ghDjyw56NvwYGJH35j2QA9K/7Pgk3d?=
 =?us-ascii?Q?jq+ah1IIRqKZy5qj3PwlLeYmu+jDaOoLieE9drSsrnUypnfgfI0pHOgtXzJG?=
 =?us-ascii?Q?c/gWFl9EUqUXURJ9nuHKhHVOzCl9v2/N8d0FL9lAcy4eGFLSO4VeYsP4+tFY?=
 =?us-ascii?Q?EZxVI70SpgfPgC7yGCTOcRSooITeYCkUZZjRZcwHO88+20KGQpOywi1g0Gah?=
 =?us-ascii?Q?eTm9BYh+ipA5jabQBlQEMappPa/z1bt3EMglHCk00LSGISCmt5Q9mbImdaaD?=
 =?us-ascii?Q?wynvRbuZkZ67MEdsgCHqZlnCuiqqOvwKEZq0YYcVCNyW6ePobIX3KH0ganqR?=
 =?us-ascii?Q?TUi58celRRPl2KjtJVcxukzPyW6PZRYCbHryywLrxcSOekSn99BV0MHuWwlD?=
 =?us-ascii?Q?Nj8dQJf/C4GYYU2czMNap/NgKZ3DrIw/P/6S5j13nD2yeWcCdkvizNz7+5dX?=
 =?us-ascii?Q?L1ZCf63aRGtf8GWIl17axcmvQp0KUALDT5Z1rrCq8Mw5mUunZs7NkoJ4Opk0?=
 =?us-ascii?Q?32TDlmZLwPqEl7Igm88TYoIKExvkI4k6TDL/DCYdHO1b002WgE9lsGBJgNBg?=
 =?us-ascii?Q?fsNtn10fL4gKW8jvObrI6jV8XHiE66dl+i1+at1DuR08DcE2OvdL5kh8cwLI?=
 =?us-ascii?Q?Ei1I1CuHl3DRO4JQzNWyxKU0TSmJ4tFMJJwkBG1BBfiODSwWwxS6LA9h0mF7?=
 =?us-ascii?Q?vXgMdQQe3EAL0cONE2eVKYa837M89R8SJtxfjs4F5zo6Iv5SxhJybZNrMmcy?=
 =?us-ascii?Q?hLfdqUKz4Q4hrXESp1IfPUIsw0E6J6M=3D?=
X-Exchange-RoutingPolicyChecked:
	DaRpx1ZIFjqRWAg9awgT8i8yuJ2yJas8n2e+Jr/9BEKpdbVDvqBkK097XNQLAyy+y9Cg/6gnN1HWeL1xRCnai5LYhK/s55/oABV+kG8rSTCci35HjcNucs6aQNdsOn50YZV1z6t9arXOPq/xaAGYEWDdQJmL2k5Sb7xcboV8xE2fLTQIMBBDgnjiRkCFtZoxoz8enA0aiWW7+DKNU0jWjNRq9ebJHUfgzEGLl2hgk29HSov23PSz6vOB8HNJH9ATJTzi7b1KFPXZVVV3Fo+GNhrJID/kNFWeZ6CdZAlZaYO9Osbu7ZSg96GlM9ufZmAU5mQXmcDSyKAeoLQJ+37cHQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dk0bnwpaaulugFqzHV59s89HOJ2xtdeHJ+ukJGFwRNwMSMqr3awnGcfnO+rz+bRG5cOvgkvfX+9xl0dsZtBa7zucUZf+Uq11vokWZLVGeB9Kva3cDdZpYnHeMVmUib8lLGs0e/lW475i2dz0GosXAMZCCBLlNbIxVgMC8F1bercTCL/G5xmJYv+90TbZ/9tzS1d7MMmhVvnqyBjexZgAoGCGdPAbLbTtXJPndsoGVvdE0+oB5/obHlwgPzPylS9+AkFz5OWV+l+g19+2l5X2vhxIYbI3WsEmvVJn9JQ4JTCoUF+FoZacelA0GfdENTUgLU7BG/DYjoh6duPqWfhcR0Wgbp/Z4JgT5/mcKNg+Yq7b2fCiNiz1JtRnTZEBO8zHjlxiisbtWrqCyJNNpKU2hNiYRVWNxNdFzO0ksTKFxaI9YxiS8oC58b8yPvKSvmek3sMz66LQOUbMPq6K0Kc988iEykcBfuBr6aNLRce2Itj5YyJNe+antGF6tFnbpbST4vnmo3L8A9+sxINyKpUVbLSS9P80LDVwNqYcHJu2NPSD/vBGR/sFlU3D+DkouVHHqyjB/bYFNB7Rwq2/EQZl3aeh9o+1CBwFa/j2yUXJ0X8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a36a4cc-185e-4c1c-d66a-08deebed6fbf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:34.9419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5E1YyMQBayR71rlCMsZQEPILRn7ZjiPzf2ZPeuZP6TbHS9yh6MZNpt5xtLym03+6SpkL1zjtXm1ZxlTCcNf7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607270138
X-Authority-Analysis: v=2.4 cv=OPsXGyaB c=1 sm=1 tr=0 ts=6a676e9b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=7RnQmdzTPIgLJ45uHnoA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114
X-Proofpoint-ORIG-GUID: 9huvm--1Uv7_jKl-NS-yulqS7B52w-hz
X-Proofpoint-GUID: 9huvm--1Uv7_jKl-NS-yulqS7B52w-hz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX9C84Gkps+OxG
 1hPud5xuj/pqssUyFiB5UP1Yqtb4oZV5B8TYywsfyh5sm0TnAe5kYOl9uWG+C1P7VItd/CQFv1z
 4mVOg5SOY5hwFJTubNo+gpLCCEA4k0JPXebCujBgWv8xKmjLimeM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOSBTYWx0ZWRfX8AF0ld7XQkD/
 whCxjyrxF1lqYXMa33nzPuQ8UfGQIp8mzNCClMV7A1VwLnCC3iPyOgolq1+qb2HTkacYGVhGo1O
 1GPB/ez5dDvtK7wFSZic+D/r+7rM1+vWWRMfyMBLuyWGRwIZVmXUTiEYglNXRhEu+EmAiRUvx1s
 vkswqFjKtw0NtiRiQ75YX/HyigcW1nm0/FZMbFn9h6rW/W06kMfkGAZFY4SfMG7NnRr11D/exmR
 UFQlf6CpS4ILzy8oVwUzSIUjVc9DYJH5mDWyyzsG7nKQLsViTqvkzgqu8lAGPwKX+pTb4Y6SIb6
 zVM+wRUZwoV5bvo3V+PUe/dAeF6iW1+WSq1Rvnu8RIoKUVKboCTg1NKTR7HK6u4mMe7DFdHapXd
 VsmxA8BNIaowYFF7iIQLXdKPf3La9KKk5qOZqSA2uc+I5QxqLRB7wTvHbnxMvZqfQ7fE6TUCJ5L
 GJRAEXysfdiVQYTxgnvivkDDi3CAhW+CrZUR99Yg=

Add a mpath_dev file so that the multipath disk can be looked up from
per-path scsi_disk directory.

The following is an example of this usage:

$ ls -l /dev/sdc
brw-rw----    1 root     disk        8,  32 Feb 24 16:08 /dev/sdc
$ cat /sys/class/scsi_mpath_disk/scsi_mpath_disk0/sdc/multipath/sdc:0/mpath_dev
8:32

This can be used by a util like lsscsi, which would find that the gendisk
for the per-path scsi_disk is missing.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f044b2dfaa9fd..0d73b03a3daee 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4109,6 +4109,73 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 	return 0;
 }
 
+static ssize_t sd_mpath_dev_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct sd_mpath_disk *sd_mpath_disk;
+	struct device *disk_dev;
+	struct gendisk *disk;
+	char devt_str[13] = "";
+
+	/*
+	 * This attr is for the per-path scsi_disk block device. We need to
+	 * handle the scenario that the multipath disk has been deleted and
+	 * the per-path scsi_disk (and its attr files) is still present.
+	 */
+	mutex_lock(&sd_mpath_disks_lock);
+	sd_mpath_disk = sd_mpath_find_disk(scsi_mpath_head);
+	if (!sd_mpath_disk)
+		goto out;
+	if (!sd_mpath_disk->disk_count)
+		goto out_put_disk;
+	disk = mpath_head->disk;
+	disk_dev = disk_to_dev(disk);
+	format_dev_t(devt_str, disk_dev->devt);
+out_put_disk:
+	sd_mpath_put_disk(sd_mpath_disk);
+out:
+	mutex_unlock(&sd_mpath_disks_lock);
+	return sysfs_emit(page, "%s\n", devt_str);
+}
+static DEVICE_ATTR(mpath_dev, 0444, sd_mpath_dev_show, NULL);
+
+static struct attribute *sd_mpath_dev_attrs[] = {
+	&dev_attr_mpath_dev.attr,
+	NULL
+};
+
+static umode_t sd_mpath_dev_attr_is_visible(struct kobject *kobj,
+				struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct gendisk *gd = dev_to_disk(dev);
+	struct scsi_disk *sdkp = gd->private_data;
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_mpath_device *scsi_mpath_device = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_device)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group sd_mpath_dev_attr_group = {
+	.is_visible = sd_mpath_dev_attr_is_visible,
+	.attrs = sd_mpath_dev_attrs,
+};
+
+static const struct attribute_group *sd_mpath_dev_groups[] = {
+	&sd_mpath_dev_attr_group,
+	NULL
+};
+
 static ssize_t sd_mpath_device_delayed_removal_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -4389,6 +4456,8 @@ static int sd_mpath_add_disk(struct scsi_disk *sdkp)
 {
 	return 0;
 }
+
+#define sd_mpath_dev_groups NULL
 #endif
 
 /**
@@ -4539,7 +4608,7 @@ static int sd_probe(struct scsi_device *sdp)
 			sdp->host->rpm_autosuspend_delay);
 	}
 
-	error = device_add_disk(dev, gd, NULL);
+	error = device_add_disk(dev, gd, sd_mpath_dev_groups);
 	if (error) {
 		sd_mpath_fail_probe(sdkp);
 		device_unregister(&sdkp->disk_dev);
-- 
2.43.7

