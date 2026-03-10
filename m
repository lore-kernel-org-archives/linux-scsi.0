Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EFF38E113;
	Tue, 10 Mar 2026 11:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143472; cv=fail; b=f6CLhhe8OMNgbiBrQB/DMZckTnEUtSPp45ctD3b6IWC93pVxBvu9ajcfK37/ehRO/QYZ4puIoX5g8xIXFbBo28npMt6zknbDXoaSuLrlfpwraHdZGxERrzroJ+TPyeJvqlkte0n/Df5yRCTgsBYv229LcgDOOrXIXNwxqPsyCeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143472; c=relaxed/simple;
	bh=xMXobP9GPVbaDpIHzcIo8fritLIyfvnDVTZbjpnl9DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r2rwO/oWeGaF2vsIF7IyX5tbxkkWGFTUzBev4UrAVnBo0mY3gdBHUIRKq6ydzIne1sWZr/mwJplDpS9wFuUhH/Hy1CMOQFv1MmllpZa09f5Io1udjjrcIx5jHLJgVVzDrs/PAu149yYwUC6RxRHnclvWVz3NIcegjLSRTm0CtTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gLTfAo3d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y5aLR1gd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gLTfAo3d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y5aLR1gd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9eCLb1628413;
	Tue, 10 Mar 2026 11:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XBPEgrh3P8I/wnirTcteSmT4GS9exVPhQYf7Aaz/CYk=; b=
	gLTfAo3d+r9gxzzoUUfLavazLqyFDpcOamvKFUApJNWLvdDR1U/SA8uTS+LAdRRM
	XR54WeXcDRQQAsMiEzt8MoASQm0wZumT/2CW3MIO0HifHsT61j9jXJTM/GDNOKdA
	iL8f+e6mRHTopfxiKodjy/QuClXBz95rbYyjzbRYHqUgMdU0Chte4T91FYqUFGGR
	mf4lrswf+yFZTirhKDwJ/36WfTbNt+X6tToKCSAqbt/a0rRvHvHT4p70jvd0hEHZ
	oR/FF94MfBpJ3jSUWtJK9C2VWENuHh2VvbOoTUlSzedzbJ6aswtQHoWN65dXqIqS
	luv5kfdhIJFAaT3qS7d4DQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmps2nt6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AAbA1Z020243;
	Tue, 10 Mar 2026 11:49:53 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafe075d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/h4dgl7zzPFWWaL/3lg8trN+Id3ZVMdv9HsF89Y4OGaodEcXpZube68E3YLnRh3LruRPEOe3se4wvSlOLuVQHqBXyHO88k2jS1tO0W36zD+DZdyklgtX6zyaa0fIsy6U8dUILflGmUHFxTj8IOXDCE+wsnAE6Q5/YKxxo9GU+53Xo4oy5bEZDttyCRqTwrc+aC3ikndgp9+kwHrYFMlPkiiMvGa3fsUik08tWdO/zIONz2Z8S7++UgyVPrRJHWR9H7WJago5Q/IrZs+Pr1TkowAxqUbgF4fnhWwL4cC2SAxvdcHtkYuS9GP9CzfhWdlFWgB/iOO2BqxVCKz2XKW5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBPEgrh3P8I/wnirTcteSmT4GS9exVPhQYf7Aaz/CYk=;
 b=nSyJ1yygkzT6YswMbokAWSJEt1SWnCHFEDMBBVy5DIr/u5t+z47bjicrDn2OX2+fjrqPMReQ60ZdrlfsqVmPMJahBYvZmeChYdO3Ss2McXr2GJwngzRwtb++CfWr6DOlArvrLkAyuF+FfYAyxoF4oFQz0UI+ACdjdDsahi0M+2Zm8QfptjXbmJPFczA9/z34KJjVHKecAs8nuPVALWzeHq2WrGgKfSK1pbRv/M9JqZ74p9ECVaUL8WsZxCqtdzj9wuhwgQX49aaVODbXgf7hZs7uDqi3kVFfSe9uFNu0pogPsEBuxVQxwl2N7/LhSmCgBjFgcs/3ia7ROc30W6TyGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBPEgrh3P8I/wnirTcteSmT4GS9exVPhQYf7Aaz/CYk=;
 b=y5aLR1gdEgYDDQR9+fO/YQS3RABMd3mTjLn3YQB16CrvuyEvx5RTeGNDloRfOz/qtkaNVY3L6MhqnK8Cax6k2r16+PfeXN5CWO54X2/xKi7kIcZXLvLZ2OPwuuQazo+m1wBl4ZZNeLG1CoCccWg9A4G4CeRdTPXIHTQ+w2ydQh4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5166.namprd10.prod.outlook.com
 (2603:10b6:5:3a4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 11:49:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:50 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 8/8] scsi: scsi-multipath: Add stubbed scsi_multipath_dev_rescan()
Date: Tue, 10 Mar 2026 11:49:25 +0000
Message-ID: <20260310114925.1222263-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5166:EE_
X-MS-Office365-Filtering-Correlation-Id: 7784f53b-e273-4fbd-eb7c-08de7e9b2317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	D9/TQpBrKZ/QlZXvum0fgilxnV9YwdbY+AgQUR+xPAuQuoJ9SxxeBjw217GMWzPq2LBw6ZU7l4ldJeF+c+4p5LoHgM3wGY3YJNQ9owG3TSztdFo/s/wkPQO7XpmHjnUOuO3Zov0M66f13Q34UBAiOhgHfpCBWksW4H9brta5bmWh/SXh8PQsNkHNwKVdSQuuTtezmeLUXGfVjV+Zqmzvgu3K2tbHZ+p8IGbjDpmfHX/XGuT7Q1onf/1DCPMiv4INZC7n1kHeKAPRnySpCpUXh3xQkKRVc7Wwj6sw4ZczKNRKP8JrmApb+xd1nyrKsGq5S7qPnkmhdDZ91zk8y7HE0JaMqpXSuxYZ6lw9FeExUNPzMd2kG5pa3WcesoSFS7c0ij3f/ocrqC8nTkwaozgic40ADHhq0kCI/W/mDZJ1RytjepPdUB2csGnXIX2ipKbd9tImc8HEQ1ROwu9crySn6S/AzEwC/a7MnasXrykI5Hu9PfAqKPehvHVDSoP0M3fNvzLudZOWk+A2KWJPxc5pwzQ3AsTYhGPE6gUPHimcM8rn0QJYYi39RczEQZiLLe2FWXbfiZ94ESLtjLhZp655u9cD4dLw68rbY1HhNqAcbzxxIBhmG0Y2tYkdPc+WzjF1KUqkDy6z3JOfcnfm8jEYGXDupN/NTU5guKvgbq+HtdPvSW5GWXuLBGbyiiCetGeV3DpRlwXETVSdpOrJF8Ryy3DXFLTG0T/G+JH9Q8q44Ys=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8beSk49EAsw9VpghDGGRZuau1jrcvD9rUAUTSL0SnZYtpPbHQyav8aSSCurO?=
 =?us-ascii?Q?ZQsi1W/rGCvHjdbjsdXhkn1MKfRB+D0Y1e0MZzDzUsLfFwMlxulVH7MI9RYz?=
 =?us-ascii?Q?+DVCz+W3HGOCq9uKuGCK/QnRccR7qunsujqHSMtJyjWptRTOHiK/HqzmXI8a?=
 =?us-ascii?Q?ggOvpa2cRYhBf0PdauyLheQ8vS+4nwZ/Nov3GX0ygsgnso5zARcsLoeyn28F?=
 =?us-ascii?Q?FY8tcDFyd9uw6p6ltJLZRGRpW0Y2BL9lOjzH2IeVXTByaoDCRZUMKhid7GrQ?=
 =?us-ascii?Q?gNLsGIqm648O7HhbAHs0KTmO8LlidcrsEjPMUvc8gvZSRzLM+fPKBSqkG/by?=
 =?us-ascii?Q?+NV8KOEKiicPC3Zx9/bmOTLCzSOdMH4KLlw7lVrZsTMMA+zQJt4htEMrr9Ui?=
 =?us-ascii?Q?Bf6qZlcemiC/o44yztUgCcprffn7OE4KenkIn1f+f8Tid4EZ9l8WBE57cYbO?=
 =?us-ascii?Q?qELTK5HGxpMSn6aFvg+b0+F2FFzec+QEUof6CLGgvRmPERySdOnEj9+4C9g+?=
 =?us-ascii?Q?/n3lkfOae3oPwL7DsNYgbq7cxaj0qAQZIurthdBrBJGe62Lv9sxazGVg8bRP?=
 =?us-ascii?Q?t9Dy3L9Ufy89QDeJi5XfKKfI45T/nCki9si9XHCYegP3bfSrXCUvDZshg6vg?=
 =?us-ascii?Q?uM7E+1E6+79cUqUiW3IrOWip8uoD100of8Cf61e51ABIImWlJsinSN8yaZRO?=
 =?us-ascii?Q?WPj5UD91nn14bg+yFfyp0OPZANN2ZXQJPCA96kOhqMGFtWqgJrq/4Ye1PMbp?=
 =?us-ascii?Q?ikgndsKsvTdvwOeHnRg4KjzFXAzkz1O5HIfISzQzuEzeDEekAezq2NWAU3EE?=
 =?us-ascii?Q?M5YIwsQ9+wYj7Ee9QSpHm0J9cQHZjqPUqjIPRmgKWBeNdFqzMVUT28YY1zMa?=
 =?us-ascii?Q?qsmNYC25voqx+3GO9aJtqs76jYVF0YCumFoY4HBYYB+Nhz1u2i2ZN/TnUzQq?=
 =?us-ascii?Q?2iOzOv/tI0bZrMsx0+LiL56O+JsV4s+MszqeapCe3MX78LXIEgXeyciiH7Sj?=
 =?us-ascii?Q?LkzI1O5lx445nJf/Odf8LzWCHo7Vly4mbIpX1/e+z9VdHdHAmL9XsLNUM9+C?=
 =?us-ascii?Q?6Se/NIVFgN4z4i+SbUsQ6tid6cOH8m6jt98ajfAGdcJx3/oiI8/JEItN3hrl?=
 =?us-ascii?Q?Y2wPLhQ/BTYeFZZ5Qf3W8EduwHEVwLa3s0uhpZYOClix3yiqVsaw0tXfx+e/?=
 =?us-ascii?Q?eqvA+LBWMPAEPRAjtGJZYx9RThDfBxkNYM4VIz2Mi66Dmde30qPXXgyHpit0?=
 =?us-ascii?Q?vdN5FzIvPTziyX7FttgrWDlVkk4lHv0FAWVF9fUSTNIC85jkSVUntyPpAeXY?=
 =?us-ascii?Q?fUmFQjdFdv6jO1pvhKB2MUFf3rk7hPnJkDWqIUc3qwSO99TpMMTOF1MhKYcL?=
 =?us-ascii?Q?b3tduBVufwtohcZJHdD8QfrElRKVpvrplC5RW9thI1BJez6ZAMdWApj9vqRa?=
 =?us-ascii?Q?3hc0SSDvdISFMaDivgpHwjqcUKSlKeMfGpdxj7NjCuXLCApwH5RKLpfQfin2?=
 =?us-ascii?Q?FALM1ZiCb4NrB4TsO42VQJsut3RrQMTnq+zlWa5PpJC25Xh1W+ZKYSIM5rPW?=
 =?us-ascii?Q?Rup4b4ix4zchkG9nMyurxnnQ7kdJ4Sni9gK/Ie5yTVcyAc9tNqgFInSP70+d?=
 =?us-ascii?Q?ijFFcWOmd58/0i3CASS85P2v2lthTxxJXPKcAsJDnvPVsYAUM9jaeVazLYq/?=
 =?us-ascii?Q?tqr6CqDALdTnFjRqwAxHpR+Q7ow27EpJl8lN0Px0IJMojItGxfUeAg7pA68Y?=
 =?us-ascii?Q?UTwntTzQXg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Jgap6+K9xdkXeCut4pQR89oS3kktkek6Arh+6iQp3VawKgCdVVyHMcf/GzveVF4ifewst1400eHuGlkXTvWA3v5qwO1Ch7trkGYcbuIgdeVXUBu0OT675915Q/t/kABMlCpgxzik7DBaSsnVTLswohSJHoB3n6EEedGCSlzHqgta3SOmBTKcW/nfiRIWIZABPB42Q5mzydH18uufiXqkP9aALVF9+uxKvp9C7n1rprbZV2xcHTuSxkgYhjglgSenaKNiFpmK+eJHXHXgxrTvbkyDyWLx3gflUPleGDU6Tkey414oDW1+yH04mOKCKI7oMDd/aiHREAiuJBy3LbrHAg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aleiRuDtxDhritaFgCi5sELA4G5kMgqGg+rnad5UpFdl7hfWra32VrPBaPama1nvtmJofpigFK72GCOGg/W8TlUsTc26fl8x4mBXn+5BqiymbQN2rKS9ElSb/hhc5QrpgdBPooBuJJKlsiV4x4HqruOlyY6iUHvbh7FeRQnFJAgd5p4IkskW9cAFEx9/z2+KJgVoeWYxK23ywke8YXA0JZGEMcN9ZXTjuFhPzFoLb1XXKUXeUjvwxh1nXLgrzvMMDC4mKhJQnUYM8egKLksAOmN8q10fqbztul8njc93KaXMhoB0GD1S2lJw0Uy4NmZ+AQ8s3zcZa10mCKuX/AhEFXiphrHZfyOvE4sZcHhfWn+I8V3Ogldiim74mTBGgjPeKmiMK5hwKcwNf1L5CARShD3DvV8uo6mT8oDvu6+fFBu5uBhFqt4Grb3azKjwPWyUVSQJk/sSvMxhqQnYKSMGcWZpd7Dn7ilYis3DrXHzOsxUY8M3H+KFamYep0villaw8DIaEuZNJM3Nqh7f0AbP2khyup55hMa+s9wXkc9GC+8n/VYkhjaQ21Wd+B4YZ31nJ/ew9BPDXG+W2D7dcS+4EGPzzYD5THeMgapUK6Ol3uE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7784f53b-e273-4fbd-eb7c-08de7e9b2317
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:50.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFVQVFSV1ku9ZkbJRumM5CEu0OkbNeEYlfjVmkpTdMXsxSLAt1jNrK3hOOH15X35l/KpwrJr7fy4Dl/OLhOvTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Authority-Analysis: v=2.4 cv=IJQPywvG c=1 sm=1 tr=0 ts=69b00563 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=0MBnn374Ymj33g5u8Y0A:9 cc=ntf
 awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX5ZGTdpUnuL+p
 VPfqBaNBMEiK8iFDHc5aoEcTSf9A/zbeXwIX/EeRnXkmNevNdnRWZOkvoIlYHod5h8mtR5AnXTS
 u71tWuQYnZvGfUEbdzSSI8hqD1BOsmFFlLNFrNfeUoqv0jrP7u4nVGfU9lgVRX3/w++J1mQu4Zs
 ebOFWik8rxUnAMoNPdmnIHVuRCRi6LnrCsz030rhFDSvl0vJ6/7WclRy8/LeV6/w6bh2R6KHDxH
 MEN9tg9g/uxHiBK3bhkz94lUgAvatL4cnLZ7cPOBUoGv8uXLvNmBIcRpvOskm9UuzRexwmbpumF
 K5Vd8WFM6sV6ohmbbOnrShiOeztPKMRmbv+SLXjcAKBaGlH5EM/nL6W6cKeWXiqjCP4vbh521/B
 jx16xWhsEy0WPkvK5JVwjcbUlJ1l9lXSUFTNUdEO4uRV62XQtdXx9T14sBA7JlclI4GwCFGDqlG
 OrsnXwsgEvBonpgpE49XHhl7Uq2zHo9HWwzTVVTM=
X-Proofpoint-GUID: hil4FPYBFlfcYTW8AES7d6airb5TT97N
X-Proofpoint-ORIG-GUID: hil4FPYBFlfcYTW8AES7d6airb5TT97N

Add an empty function scsi_multipath_dev_rescan() to handle sdev rescans.

It should handle ALUA reconfiguration, and that will be possible when the
core ALUA driver can handle that.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 6 ++++++
 drivers/scsi/scsi_scan.c      | 2 ++
 include/scsi/scsi_multipath.h | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 2b916c7af4bd7..97d835f1b6aaf 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -539,6 +539,12 @@ static int scsi_mpath_ua_thread(void *data)
 	return 0;
 }
 
+void scsi_multipath_dev_rescan(struct scsi_device *sdev)
+{
+	/* Handle ALUA reconfig */
+	dev_warn_once(&sdev->sdev_gendev, "mulitpath rescan not handled\n");
+}
+
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 {
 	struct scsi_mpath_head *scsi_mpath_head;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e22d3245d4b65..bf602daeac1db 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1743,6 +1743,8 @@ int scsi_rescan_device(struct scsi_device *sdev)
 
 	if (sdev->handler && sdev->handler->rescan)
 		sdev->handler->rescan(sdev);
+	else if (sdev->scsi_mpath_dev)
+		scsi_multipath_dev_rescan(sdev);
 
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d30f2c41e17de..9dc02a56e6342 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -78,6 +78,7 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *);
 void scsi_mpath_put_head(struct scsi_mpath_head *);
+void scsi_multipath_dev_rescan(struct scsi_device *sdev);
 
 static inline void scsi_mpath_start_request(struct request *req)
 {
@@ -156,5 +157,8 @@ static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
 {
 }
+static inline void scsi_multipath_dev_rescan(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

