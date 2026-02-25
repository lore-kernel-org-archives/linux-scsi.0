Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7873D7D6C;
	Wed, 25 Feb 2026 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033606; cv=fail; b=Cx8K5YYGG3qXY5tj4ziA4/hdpjEx55pXQTEDL+ufSqTXh8jKYRzSEcgX2DGO2M6CG8Fc0uZ04T1awVt+hZXI0+pxF5smiMJzdHVXKdQU/sELukbSajRwUi6wK12hjQUhCh87km/c6SpEQACVJtLMfRSyfMMNUqJozle9g/+tFIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033606; c=relaxed/simple;
	bh=dKi3HhBiY+0bZDmrUi+W6Wj784TiUXYwkt/Bh/IJ9cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H6EEwQnUS3uSwh3hmAoaWGEnRZ02r89xbkau+paj6ZctPT7Tkr3vTl273TVYGM7iHT7EDD43SxpNdQM7gK3PrJu1NCbQ3QREp5NkUZ+CJmn5QUCvXkNADtgRqlrpYxm1EV5oJAfuKnX/9a3CzuxIfqgL5KlpkNht/Z/H97FlF3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nBJsQYzQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jk9JOEgh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nBJsQYzQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jk9JOEgh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9wZuT369440;
	Wed, 25 Feb 2026 15:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F25BWcAudDvqXAh4GCC6p+5U7Pd3+YgjRtSaTBQoXhA=; b=
	nBJsQYzQNTtwUtsA/4PSayITycvR6zyO4CpWMHdHmkC/YdDkGOJWt2Bo9E1SPz72
	2S1r7TCIdWXKuhLXuPMem0iCRnsZI1qc6m049fSJqQKYU60r8Zv4u2QmBdkuddRy
	lzXEVoDtBE1gaKpUJ9tZ+eMaEZ2oFiJ0u6ZdPzZddd+Q5duvqn2QDwO4HNyVIZGb
	pGFrA9RFbMF0fdqFmMW8kQEqY+3avBfbWA5hR3HhPAkUPgASJ7v5XZNijmYzhSA7
	PwJP6FSVIpBBLtkhtu2YkUZ3xonnTI0I2vyhaZuJ9/dbpuP1t8HXjgvEYgj9Vweq
	HI7u06CEqQjldNKR9iX8+Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5xdab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61PEXUdl013310;
	Wed, 25 Feb 2026 15:33:01 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ffugs-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 15:33:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LIKPPRdGU5SEIRAnblEV7+AH5MPrh+C8sR7PadeAyQcdFbEEeQuRgvypJMN+5+OkNU0WoFml9ly5dWw0yws936Mi/UkkfjCvR5z5yR6nQG1i26WsYbPqiYrzxzxWW9t4+jF8zKUoBSoxuWvGCy9ZngTrQ/+1IHByCn7uf2B3ZywfGhhLpDyD4kBb059l7uzteJxHLdDNLI3Vdhv9cyzdDEHsNOhyuhNITm9t7TGsyyxaw9te6B8tNt2PM++91UymsXXZa0ogOXVACE8DPp2Fr3UCRRZt232AB+xRO0rpjhKDS70jE/qSLoE87rSfIeabSJaOiXVwMVdu8AexAM9fyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F25BWcAudDvqXAh4GCC6p+5U7Pd3+YgjRtSaTBQoXhA=;
 b=bqE2Vk2Q+SDxSORZeRImlj59P20hnsh8V8diJQLipnjQqgSAgnd5FuLhknCsUD2ZcKoo5EZga5oJuwP9E+cvGCCYIGqA80//sAEX6Y4y5aixj6ZP7/eaqsQdjBqGsTLqo+H8FjGJP/FVlF+MtkyythoiUJtPjVG0ET5mBgnSl3kq1rf8zc01VI0bByVwqvHsM0GmoIH7HMDCm/NUqb84ZkiRfqpir77819SLIEd01c54B6hIxgPulcttKZwGSlQWlr24CRnFirFFZxgU5/9s0CFnL6VHT0UAJwN7rlZBBHAjuZOeqzu0aUUnA8u9IDV1R+TY1qNByqDOjag8b26nKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F25BWcAudDvqXAh4GCC6p+5U7Pd3+YgjRtSaTBQoXhA=;
 b=jk9JOEghEvqZGKjx4OiAOo0R+RuroYmA4MIenNrsbMQd9ktD8j+JCx5KfK9BARUxGZs4XBH98ce9F+AYOeLmW1lA1O2XGx1PjTrnTbe7iVrnPGEH/BTH39BED6OVT1Ryy0sih/RkrjjcXbTHEtUoTnloeYefmX9/EoErzICMyOY=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA6PR10MB8208.namprd10.prod.outlook.com
 (2603:10b6:806:435::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 15:32:56 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 15:32:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 02/13] libmultipath: Add basic gendisk support
Date: Wed, 25 Feb 2026 15:32:14 +0000
Message-ID: <20260225153225.1031169-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260225153225.1031169-1-john.g.garry@oracle.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0014.namprd14.prod.outlook.com
 (2603:10b6:610:60::24) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 06f09d48-a23e-4fd3-9781-08de748325a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	6ADF0J92pjTes74MtZUOAlpIiKDT8E1Nt4CetuL4ZVjUFeeeYyevjsPhmEL6S89YOkNtGZHSERkNh6xiA22xMTo6/4DbaHk2sbSELZbgN2UlxevCZlqQqA3FyK4FQc3iIXthi5EMPbb2Z2YpkdWKL/mf6jnIOAskcpu6sTxajM7dL+unMDxmDzKN5DuDBQuytT9EbJSAa3ZEMJlgHsPIiwkriWVFbNV9Haj5hMgpdn/FPX9pED9DEzGaBgn1vw7chxKdr7sF5QzppZl94fcsrMf7BTY5A18BAx97F0ALvJzOMekXygTGAdd8b5vdI8qH3F+jKPP1uPMwO1HzOanySbNFz1VFbTzU83aa8xsfGepvUO0ogjWAj14/qpN7hNfJyG4fBPtuOJaOizWNUnvV1B8ONB47lIxccaWkZJxqwHSZpqNQuFG92/AOdPdX8UZflSejFM351glnng6aKfgcRPGXH4I4gmYFdLwNtBW117Bwvos5iZQpUW9cuSAiureVDJpOmg/4a4Pb2qoS376XSh0oIfGnBkalCt0qpUTclmxeLsZ3fgGDQGkz2unfaJPQ+TA9D/v9Ajs6MudB/C1ETEbsEVnD7mDH1ljV6UglBKBhhhFbOTDM1oEpqJwPzxhH2Pi8d2MSiW7tmbyD7fP130En4FdF04NhRRvXyjY9m2LbW8eCS2Ud44nyYFgkJrwoLaHc2AD2M/BO3c8O7tSXXeJKTURNx8Qsg7CdxLE1hpI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3exuwk+HAIDnB/CpsxB56bb9dQKwlBo6kJMkkmfJIVp6WLV0LZoAcDKPRBqQ?=
 =?us-ascii?Q?r92vw0Qo8ucTsp2chir6drZNOKKS04JrZo0WALhRbjkThOsbRvf+PQXuV0rm?=
 =?us-ascii?Q?YYMySzJNu9y7eER814Mq4DPp63+AqdH3zi71BycdnEEjt70w26cRKkVl2e5F?=
 =?us-ascii?Q?SaXaclI6C5l4XKXRSfpsF8Wyin5vYepBA3k4TOm03wl+EJ0SfxzYZ/w0eAoB?=
 =?us-ascii?Q?ajpHPo5MWTRxELVxQYLDoyAWiupHeGmjBexyPuDF5ca4Vf8bDNDE9TvwqcKg?=
 =?us-ascii?Q?2dBwxXMtPpKWvf2rYRG86tT7EvMiK3s3pb2eSZoCM8OE0ViXWfcWK4bl0Lcf?=
 =?us-ascii?Q?bpVumbUEGrVwcca7U0ppZpSH07t6wfRras4OJjxGkoVLe7Df9Ql9TZLHHF2b?=
 =?us-ascii?Q?OXULBZqXtgtzLC9so24PSk8fbvFbN3YEcTTuvDsBq21h+FRr9Z+cXvOhHm0C?=
 =?us-ascii?Q?iRkD2A9D2HH4Ymg+wX9UxoV0W3nEZNzpi/2pMnzRzJcf3FREEfp2a3oGGYwQ?=
 =?us-ascii?Q?gaqEGWQso8T7fQaYAYBJ+S3uiFPsTdXEEoGHU/RzULlbjUkaS3Amdhj3guCb?=
 =?us-ascii?Q?wQA88CPlh8LuNcxMZYRwjX+N5Z1/5pd02RPsX8BhM9P5c+IX7V8Zn3ewcWow?=
 =?us-ascii?Q?/DcS4b01306gIhzwABL5rTYW1mMarnHSdL0Vjc5NQY11Wu4noTUIqQE7vK8o?=
 =?us-ascii?Q?wACub1GbBAVDdsDb6TSitUtacUHetY2ZzhduWvR5D2kt4/UJWzrscLhQkcMa?=
 =?us-ascii?Q?E/ieBEa2LGoQP9LOeuK6veYbyb+Lp8RVkjIkSuc6V2GxEUMFhah9yDIwm5QU?=
 =?us-ascii?Q?LDMy9ZMHnBlpbX2tqca0rCPlXGAy0U+gVBswtcfH6g/YbZIc1L6iPOhmKudt?=
 =?us-ascii?Q?THAz6ibLjSYxAwDR7Y6iM4195pL1wVvMm6cHrKTSVs+Bxl3zv9rq1zmpQTBG?=
 =?us-ascii?Q?3bu0aHaZOb0nOiklAbcQUQmOjk1EQy4sqPZMZfVwivUWxD5G32Jyq82LFzoy?=
 =?us-ascii?Q?TxCyiEQ4brr3P7GlHSI2EeGefz+GeUXwxHo36X0LIYTOhzJh4HIB3DqDGySB?=
 =?us-ascii?Q?hhlQHpboUk5x+K07CbGqdq591FtEkSzvy3mclUYfQjUroxfPrqFrcAoIH+pQ?=
 =?us-ascii?Q?6DePR8DHMZUCAEDau0+FktYOQc8XTADZ4nHabLEmUcThEvUFeVSKIDPnYhig?=
 =?us-ascii?Q?OhBhL/dJNrHi5jrOgtfDnaJk5elkSzYXdnBVB/Txs3lXR4jLkv1geV8U7fpy?=
 =?us-ascii?Q?5h8xgXif3bHIx61Fs26kgkNSQqFbmeiouVCZicp3EaZsP+6U5n9+gFEzZ36c?=
 =?us-ascii?Q?CoWFmE6owhVcr3m95Szg7C+t403dmZ3uXaka2igzE6petzeRzM9Meu6WsiEL?=
 =?us-ascii?Q?ITpSzSc8ELqom5n+noLxp7RkEwINfeNvcFvKQMajzCsRoiXlseqEPyuj7+AT?=
 =?us-ascii?Q?T+O/D1U8kJqDal1bESgUeeWD2fneGHB6gYjUHelSYcOK81gE+UDtEtppLjec?=
 =?us-ascii?Q?L87BNRZ/+dqJHytbd3bRiPeYZtGXV+1KAM+jSy+tvMaO75pVvE+0NuFn2NcV?=
 =?us-ascii?Q?fzidexHVeJRKVIqBWyJP4dd186P6MJq9BArMHA+/lU6O6huHEEqvguPxRvkg?=
 =?us-ascii?Q?cCXZsBPmGGTQIITwyy8WTBUKELDLfDOLHkBp6rgN8JcnnAIiLHx8PXVeTCWM?=
 =?us-ascii?Q?QkYmmH6J5Sie2cUVJuHRJ+BNVACqkosAo7rJKj0s18HIKeZnVUnNYarFdN7S?=
 =?us-ascii?Q?3ofbzF+9/gfPeeRTJVUgu8NUdmJZjJM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	53qeF1cuD4HQpRYSsG87/94XZbn+KyOGlIwduyjsGlpDgNLYKZcLW8cA/uTUyKVj5rZP8KwyEPJp5yUnqfGCob4xumNEXcvRjuBt44noczEUYbBDnG/9IVazN4siFi7bqZpEZEXT4VsvwHO8nx/ABcEHEfowdACBfVfsfU0LGHf1yXijVvH+r7oDD8P1Dqtoy+G/qhCXw2+rG2AjyxjeOBxCW6sJvQoxHpR7yeHHeU8dNZsJOe/Op/VTgZjw7xC2LBib3bUGnpRMTBkt5ZLfNXy6puS9awAhjDINtmbcJlakhz1bGDZPLbx6UuDUTEgUKkDBYiNXh+oTF5nl9n9dHM9JC5tvMj8OI+A2CWhukFuc21u5LvM//qAcwmkMa8PWwAxvExEQkzokBvsmyQASgYbHZsnN2S4EEAYJMMycY0GSJqrDNdktUmtmqozHsr/rL1Gt02HfXo1JhB0nKnsCRetumgy40vHqB94ia9nCg4mOoPdFZySRwmvv3mJ7E/qD24b9C9Sz4ZbIxkZ5MpykedeliglvT6IOWWUt2/EM8gxrPprVySZUnHDZhhHuTYRL6tXHb6/0vO587f1aHGK/GDFnI22SGeVHr0dKA2Fzssg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06f09d48-a23e-4fd3-9781-08de748325a1
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 15:32:55.5373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLYEma9sBDhQG2SYkXuCGRUpJneSsr88znRXsmHWxu9H3cl9vLybSDLIdQHq+UA90uNtrK75+/C3uKMsFti5Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602250148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE0OCBTYWx0ZWRfX/Lm9+Eg90LfI
 Esna3onkyPQpzCUnN/IgHqzpVM8B5P4qJni7qyj257IBjv7nrhg/2/1OGgcW3p1QNMT7aTE7Mit
 RNvBOha9wGmIGCRxfx38B0u2k4CDx5Zz2r258ds6rJ9xxL4pdEDVwermJES1Sl5e/PCG7UJvsem
 ksD87bgc6r0bFSXtao8CAprPDPHA0Q+k+QZvZoakuip7UDlAKUlQhpHEGWc3cRKNaX1+yL1RQg8
 fSLIUKb5lHVuX8SwixN4p7p4HxuhRJv6M4782F8lvcw8/vrqqPst6hAEVQdJEu6s1Gbl9P8WUCx
 jCENmoJWlFuR05ODBqaG3rtwfVhlUh17BT5TH9uBk08oAKmh9dBg+IgYZBxIJS7sjOxhrNe26S5
 1htpV3Q6cZjyB2CFGQmpax4DYlPSBe7SP5R3+2FYKi0K2iwTnM+FMjALUp1lggDd6+gInP1ka0d
 DuMWDXxR+T/z8QCGhfDna0EDSj5YGHnIe31WrHDM=
X-Proofpoint-GUID: NHVC_G8F9OyHeHJ7MjLsGQxbxHte_go9
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699f162e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=B64n-4R_P9uPcH8_Qg4A:9 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: NHVC_G8F9OyHeHJ7MjLsGQxbxHte_go9

Add support to allocate and free a multipath gendisk.

NVMe has almost like-for-like equivalents here:
- mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
- multipath_partition_scan_work() -> nvme_partition_scan_work()
- mpath_remove_disk() -> nvme_remove_head()
- mpath_device_set_live() -> nvme_mpath_set_live()

struct mpath_head_template is introduced as a method for drivers to
provide custom multipath functionality.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  41 ++++++++++++
 lib/multipath.c           | 129 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 18cd133b7ca21..be9dd9fb83345 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -5,11 +5,28 @@
 #include <linux/blkdev.h>
 #include <linux/srcu.h>
 
+extern const struct block_device_operations mpath_ops;
+
+struct mpath_disk {
+	struct gendisk		*disk;
+	struct kref		ref;
+	struct work_struct	partition_scan_work;
+	struct mutex		lock;
+	struct mpath_head	*mpath_head;
+	struct device		*parent;
+};
+
 struct mpath_device {
 	struct list_head	siblings;
 	struct gendisk		*disk;
 };
 
+struct mpath_head_template {
+	const struct attribute_group **device_groups;
+};
+
+#define MPATH_HEAD_DISK_LIVE 			0
+
 struct mpath_head {
 	struct srcu_struct	srcu;
 	struct list_head	dev_list;	/* list of all mpath_devs */
@@ -17,12 +34,36 @@ struct mpath_head {
 
 	struct kref		ref;
 
+	unsigned long		flags;
 	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
+	const struct mpath_head_template	*mpdt;
 	void			*drvdata;
 };
 
+static inline struct mpath_disk *mpath_bd_device_to_disk(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+static inline struct mpath_disk *mpath_gendisk_to_disk(struct gendisk *disk)
+{
+	return mpath_bd_device_to_disk(disk_to_dev(disk));
+}
+
 int mpath_get_head(struct mpath_head *mpath_head);
 void mpath_put_head(struct mpath_head *mpath_head);
 struct mpath_head *mpath_alloc_head(void);
+void mpath_put_disk(struct mpath_disk *mpath_disk);
+void mpath_remove_disk(struct mpath_disk *mpath_disk);
+void mpath_unregister_disk(struct mpath_disk *mpath_disk);
+struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
+			int numa_node);
+void mpath_device_set_live(struct mpath_disk *mpath_disk,
+			struct mpath_device *mpath_device);
+void mpath_unregister_disk(struct mpath_disk *mpath_disk);
 
+static inline bool is_mpath_head(struct gendisk *disk)
+{
+	return disk->fops == &mpath_ops;
+}
 #endif // _LIBMULTIPATH_H
diff --git a/lib/multipath.c b/lib/multipath.c
index 15c495675d729..88efb0ae16acb 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -32,6 +32,135 @@ void mpath_put_head(struct mpath_head *mpath_head)
 }
 EXPORT_SYMBOL_GPL(mpath_put_head);
 
+static void mpath_free_disk(struct kref *ref)
+{
+	struct mpath_disk *mpath_disk =
+		container_of(ref, struct mpath_disk, ref);
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+
+	put_disk(mpath_disk->disk);
+	mpath_put_head(mpath_head);
+	kfree(mpath_disk);
+}
+
+void mpath_put_disk(struct mpath_disk *mpath_disk)
+{
+	kref_put(&mpath_disk->ref, mpath_free_disk);
+}
+EXPORT_SYMBOL_GPL(mpath_put_disk);
+
+static int mpath_get_disk(struct mpath_disk *mpath_disk)
+{
+	if (!kref_get_unless_zero(&mpath_disk->ref)) {
+		return -ENXIO;
+	}
+	return 0;
+}
+
+static int mpath_bdev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct mpath_disk *mpath_disk = disk->private_data;
+
+	return mpath_get_disk(mpath_disk);
+}
+
+static void mpath_bdev_release(struct gendisk *disk)
+{
+	struct mpath_disk *mpath_disk = disk->private_data;
+
+	mpath_put_disk(mpath_disk);
+}
+
+const struct block_device_operations mpath_ops = {
+	.owner          = THIS_MODULE,
+	.open		= mpath_bdev_open,
+	.release	= mpath_bdev_release,
+};
+EXPORT_SYMBOL_GPL(mpath_ops);
+
+static void multipath_partition_scan_work(struct work_struct *work)
+{
+	struct mpath_disk *mpath_disk =
+		container_of(work, struct mpath_disk, partition_scan_work);
+
+	if (WARN_ON_ONCE(!test_and_clear_bit(GD_SUPPRESS_PART_SCAN,
+					     &mpath_disk->disk->state)))
+		return;
+
+	mutex_lock(&mpath_disk->disk->open_mutex);
+	bdev_disk_changed(mpath_disk->disk, false);
+	mutex_unlock(&mpath_disk->disk->open_mutex);
+}
+
+void mpath_remove_disk(struct mpath_disk *mpath_disk)
+{
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+
+	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		struct gendisk *disk = mpath_disk->disk;
+
+		del_gendisk(disk);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_remove_disk);
+
+void mpath_unregister_disk(struct mpath_disk *mpath_disk)
+{
+	mpath_remove_disk(mpath_disk);
+	mpath_put_disk(mpath_disk);
+}
+EXPORT_SYMBOL_GPL(mpath_unregister_disk);
+
+struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim, int numa_node)
+{
+	struct mpath_disk *mpath_disk;
+
+	mpath_disk = kzalloc(sizeof(*mpath_disk), GFP_KERNEL);
+	if (!mpath_disk)
+		return NULL;
+
+	INIT_WORK(&mpath_disk->partition_scan_work,
+			multipath_partition_scan_work);
+	mutex_init(&mpath_disk->lock);
+	kref_init(&mpath_disk->ref);
+
+	mpath_disk->disk = blk_alloc_disk(lim, numa_node);
+	if (IS_ERR(mpath_disk->disk)) {
+		kfree(mpath_disk);
+		return NULL;
+	}
+
+	mpath_disk->disk->private_data = mpath_disk;
+	mpath_disk->disk->fops = &mpath_ops;
+
+	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_disk->disk->state);
+
+	return mpath_disk;
+}
+EXPORT_SYMBOL_GPL(mpath_alloc_head_disk);
+
+void mpath_device_set_live(struct mpath_disk *mpath_disk,
+			struct mpath_device *mpath_device)
+{
+	struct mpath_head *mpath_head = mpath_disk->mpath_head;
+	int ret;
+
+	if (!mpath_disk)
+		return;
+
+	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
+		dev_set_drvdata(disk_to_dev(mpath_disk->disk), mpath_disk);
+		ret = device_add_disk(mpath_disk->parent, mpath_disk->disk,
+				mpath_head->mpdt->device_groups);
+		if (ret) {
+			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
+			return;
+		}
+		queue_work(mpath_wq, &mpath_disk->partition_scan_work);
+	}
+}
+EXPORT_SYMBOL_GPL(mpath_device_set_live);
+
 struct mpath_head *mpath_alloc_head(void)
 {
 	struct mpath_head *mpath_head;
-- 
2.43.5

