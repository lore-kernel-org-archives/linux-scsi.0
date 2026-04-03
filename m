Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BCD17C69;
	Fri,  3 Apr 2026 01:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180783; cv=fail; b=cHvgYQwMTwAmtfWQx7T3bPCaxHj9pYxX5QTNbFZx9u716nQ6u7dJdJ54TXvnTMWRX4ywMaW0MtFY2jsg+5jsj5nnVewadFHIUQ1iF5nvDJMRDaTvzng6AKrvk+K4RV2uAqRIbgwIFc/Gl+DSxO56qNU9KcZo94Whd5baXDaMEoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180783; c=relaxed/simple;
	bh=aw8vLL6RctOuXzllnoh6hF9/LVgp+N5ZvVO80++IJnA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uTn6vVwK9X5FDmZI+BClt3KIfI93kF3UJapsdehgtLSYyLWVEsz8In+Q8KWDE5Kd6X8lqrdaR7jdAd+rfi76/bnGCiCr1TaH3JAeZsvRpeNvX46zfriG2oa7CA1q9a7RjjCYOOOHmoe/aISQvwbhLKfvEEzCrwAyLpjYO/FNNH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nF0lCdu7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A2GcGgOj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nF0lCdu7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A2GcGgOj"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6331A2Wj3279858;
	Fri, 3 Apr 2026 01:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nBmbvMDgoX8Wn90/rq
	COR6d2FTgOaFfCtP0j7lf8Ddo=; b=nF0lCdu7Xrz2Ju0se56LXLwTzYxB1+YfSF
	ik4ox+sQ08I2uGFOZzrcXSzG/4lxdMdTyQCyl2rbQZMp0Yp4bvg9KaS0QFZCadNP
	vX7LNTVmL7uq25toySnfkSqKgFlr/B8AFlWnJH10kxh4DRBk3A64HTJ7XxbYLOqC
	zqYOPK65/CJw3lspsuDH49XsGGoL1Eyk8WTIIWx1WrL+COLfa+IeVGJW2Fxo5589
	cpiL6LqnW0+AQ1+JJpr78E7NW21bKLIAYlb0nFopAP6DxptjdXFkFmepE9AoRPOu
	+yRQtwfwj8fI/n9TILKL+vYhJF85MrlY9eMyt3/bMu1iVgb1h72w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65w7hg5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:45:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632NmiVt008506;
	Fri, 3 Apr 2026 01:45:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ekqgmj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:45:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Br97N9A8uaHswjGaLTVbkLsbCgJJ6KweBb/S5G+jp5JQg63uHiCmBezJTJuHvXuSrUlj2sIumNRMQEuhWYvuYsoaR6UtIdEM82p7+6I0P/4xivV3DPKD4JddP46N0DjGnWCmjpFHkJYbGp54C7slFLxmX0cN6cUVWA1JnrT6m5BjsspVj2330Lvfji7vVJH32tkY3vT5UXjaXxKzTUFhKp7Z4xI/z4vQHHNAJhFyesf4jiFGnCS0LIwNVqh7TVAF3pVTrh88FWa6lF+IOOLmyxeJnSnRP3gP1XqwGUCewM4VAJvGz7GeQz6FMw9CqGcUlrTSd2UsOUp+XivjUGZARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBmbvMDgoX8Wn90/rqCOR6d2FTgOaFfCtP0j7lf8Ddo=;
 b=IRQUcEFKgg2ujIiTLKl3l6FStVJPMst3HT1Ttcj+dIxh6edVyTq0/II0Gxi8ehUe27KCu5NyUEo3U2R8NhpNHRAox7SrTFKDP/gHKyaMhLnEkoBOb/YBmOej4+elcI1czOd66lHZ7CJgX6y5uvYHs4NfWClMDwswa5hI6e9nBWT/AP88FIERbJJWD5hQFuHmrItcfomq70UJKWUaM+3eTRDO8hT/mhwn8tr14gPhhODuzgmLIDXW8mQYJjMK0eOM4QxGKizXt8MK8hHrz8tO8xyb57P/C4kzLMUxQ4UBgyOKzBOtapPUDalvtJYZQpnFKoHn/k9niVzU4l0uaE0U6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBmbvMDgoX8Wn90/rqCOR6d2FTgOaFfCtP0j7lf8Ddo=;
 b=A2GcGgOjuY9XOTG7flLREoIm6oQsOQCXfVRl6h4OHY6D5O+dLFHkdbAYua0cgXFFCAL1Mjf5qf+LMVLvBx5sdMrfl5TRmO4joIaRoYW68+aWqJc32iUreVJ81c59yn4xRrDZENtnNjM7eK2KQrmfdx/ip36M4+8DmPiTf4fgsbY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:45:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:45:12 +0000
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        mst@redhat.com, aacraid@microsemi.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        liyihang9@h-partners.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com,
        ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, tglx@kernel.org,
        mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org,
        ruanjinjie@huawei.com, bigeasy@linutronix.de, yphbchou0911@gmail.com,
        wagi@kernel.org, frederic@kernel.org, longman@redhat.com,
        chenridong@huawei.com, hare@suse.de, kch@nvidia.com,
        ming.lei@redhat.com, steve@abita.co, sean@ashe.io, chjohnst@gmail.com,
        neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 02/13] lib/group_cpus: remove dead !SMP code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401222312.772334-3-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Wed, 1 Apr 2026 18:23:01 -0400")
Organization: Oracle Corporation
Message-ID: <yq1fr5c3jhe.fsf@ca-mkp.ca.oracle.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
	<20260401222312.772334-3-atomlin@atomlin.com>
Date: Thu, 02 Apr 2026 21:45:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f0e3dcf-2dde-434b-aa7d-08de9122a54a
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Z79cblT9wB7K1NDDf3j/Ix7Sqyzq83w2Yql40cguQxt8Jer3gzIllVwwE2pdQFth41y6xz5pjceqh2D3YIaJbmyt+xbYSevzJaXtLO6q9dSMlz4wNww+hXzCeUqCyBrbxOu9td06JAUD+XcXL58tnyHOGiPoENLw1kQphQSyT79AlvzMzcTC/6V1HQDFsbySpQzj+KPiM4MjyfeAnswLETyqhd+Pe6r0MzYmaDEzb0hbigFiZX7+LRogsN+wbjYMiW3UV+vE+XBmXi0RWiBMrmBmXclxm0FguDO45JV8YTC1ot+Ng3UW3RP5OQYl/fctktffZ8erE00iPDV0iwECHXqWdPh8NBtAaaoGT1EnpcKfB/qFlnOPcEzKWnltpXSjlV/7+drc+gE+Lr4NxInvdZftNn9p/Xb9KeTHS1IsEb6MPAILM5sSXb9fcavFOb1GzKb/SD49uSSUBdV0F2yKzeATPsyWVJxvbW0SkFnbRDH9Xmb82GTH1BWJaT2s7rp7MOsuAYq2M4BzcOmvuXnG3ffpikocO+xRO5qYXBGnpeJBr7w/AUZo/IftDWv73Lv6Z95tlzA/zAqnGLdEk9cRPkxe3ar1TE9+pTBaoFTMsORtykkqREbh/1ALWjd6BrOwNX8q4dGBcriDkKWUIWtjqMaSV6rzCZvP36buoJQCggZOuS9slKEPUka8ckijXGYY5HWgQOxCXry1FjQIZYBnUf819V/u1yrFll8an+yWgN4=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?nU4d9eObnQPV/ym0ff380p1x9KDNib/uqeiGyDfE/nsKy9XE3ihk5tSv5Qzv?=
 =?us-ascii?Q?vAboT414Ph0nkjvQ+fKuHQ7KmJ6EnV67PWF6YS2EMAsg4K5Zx7QmNTTdgVWK?=
 =?us-ascii?Q?/exxCx5FsNDgh1nYf4XQJzqgUo0V8aCnaMGtmPcbfVQSWHKolsfc2NG6mesR?=
 =?us-ascii?Q?wx73+5x893KC4mWwYDOqnJDaSnxgEKGxgYRgTOpG/jI/7idqlJ/sUvX2a1lZ?=
 =?us-ascii?Q?eNo0bESqgb06VvFDRYe5T5+pB+XNeTXwU3TJN82b9Xu6AFHGTm04p8lVLAkW?=
 =?us-ascii?Q?iWSpYH3ORV9wg4oqTy+RnhLMSeBDsQUW1F4Get+h9Bj0RoZoWTdqrjt10rYB?=
 =?us-ascii?Q?vtXIAaVm5ZVzQdiuxUgJm4R2CXkNAanVWou+njU1ItsORc1keRaScR0OLnOB?=
 =?us-ascii?Q?QXDRZSOUDNS34j57IRwUB2y4vfosC6tLTOfJG9QulruQNER3J8PpCTeBawRw?=
 =?us-ascii?Q?Z+1NH42H3BaLpD+1XZdKkLvCwEzIR3nI8czYKTWoN7AfQLoSsnsWsbxefk2p?=
 =?us-ascii?Q?ZMV3KXwwfHP90veUR900UwJA7nUSf7H1mY0qL0z1DF6LVghzASJSg1X8mfcj?=
 =?us-ascii?Q?3DulWoQs3WC3MfHVzxjKJfLymES0glQSFZOoLyWqLLjq2GkRNWDm3ym31RDi?=
 =?us-ascii?Q?p/lY0jw5IZiq4OdH+YbyO6dN5xZAiQud9Bo4EI7b8bKNcq8rcstUj4lfe3iP?=
 =?us-ascii?Q?hIFVQZR4a5pRjip7hrVEzGErJFEhnltz3B6Bhip1fh/2TI/3udpD6yhwm7IO?=
 =?us-ascii?Q?43AT8tawZIvWp+82ThbvmXlrybCZH7SQcCGinjWBg3OmPYZRAAa78icZdOKK?=
 =?us-ascii?Q?CLLsp+rHNoEsdHZhO76/rvnhUGMWQ8SYbo+XeEmhnmhB6ZPBiCMG1UTeHyq2?=
 =?us-ascii?Q?64ZeJzLkIdpql8mADotVlycgrf2uAvJoaBjY9YwP0o1l4g4v4R4KuNo07m15?=
 =?us-ascii?Q?zXblLjnpQjBIZUrPpLkT99discA2UI2FNX9i07e6dNigHwqMwAQ21tmnUxRB?=
 =?us-ascii?Q?hDbOPpXwIvzrCHl84AQTB9FMvZiw9ykEM8qrgJvEgUM5abbYg0davedvjpqc?=
 =?us-ascii?Q?K4qt2Jydc7i3c3vpThwv9/J9BIv4v75Emf/evEvkW1pzE5CLPyI8dmIhmCpj?=
 =?us-ascii?Q?zy1VKRGlmTh6NBT76N0bLeZbtTtm0drHM4zON7KEQ4/CJdxAVbflVdQP0qhB?=
 =?us-ascii?Q?X9HZin9VDzwyIXtQ6k2s7dne8thtEG/j/Lx/0qh05pNMHnjEX2SWHjkmCLMt?=
 =?us-ascii?Q?6v02nFQYMm6/KKBf3v0fd45Qg25axhg4p57nv1ozpaUaXVIyh/UJ4cMZxfsM?=
 =?us-ascii?Q?STqkMwMmIKCNV+6XZ8ew1jdQ1D5xeMwGyEO4Tin6nkoO86Hpgi1sox/gc9wa?=
 =?us-ascii?Q?1MBfnx4r0TgxXoDHrLb8Rg8qnxdK+1XITIc0uU7kTCgs9gYbKUrmdwZ8+mSu?=
 =?us-ascii?Q?3liJEsMI93u0YfQEtx1lRHg8qTekfDDgibjHqzB5GolwAWs4HUnwHRR9ne4d?=
 =?us-ascii?Q?UJw+SJxWb/ku2nxcegmL/RTZzAygACRIRdIj1DWfnREJTYugF/AptMzuNIlF?=
 =?us-ascii?Q?6ygPVekkr6G73deu07Qr9Fxze29ssTtxgxTgAAlMdpT6V2EGN6Jd/2Na9EH7?=
 =?us-ascii?Q?UrwkU80uoLfGUm3EDnypL1/5QAV3am8PI7COrfQr32biC4Nhm66EV+8O8O/b?=
 =?us-ascii?Q?xC6PawE177nI1m3pu53X1Imup5QEp5J+IE0AXASDcPtWqyOtl5V7DVSuf+fH?=
 =?us-ascii?Q?8PrxBl/XgKmGri4s1GiWBgJV3npwFB4=3D?=
X-Exchange-RoutingPolicyChecked:
	p6RWEuMF4kZPFGugGY9MudL0Saj68ABUC8ObGc3Y2dYOx0orHzTA0z2OEboYCHERiO4G8MNf4HjLJHNdnkNL8WX2xR1Bh+C/5YpaXNV+OqnxtjLyCFJV7x5rH3HD6x9SnFMY+Py+aqFmaaf7oJpSpVIBSN4sBQeyaD3EykSW6sO7FNBuQniKzeVyZA3QHk9tOC50oMBo75olpy2sX0wdzdfWnk6PMVFnnDMKK3zZnVUfq/NVt0dM8B65MhW2GwVL+iI09UxnbcGJmmFEI3KGOSWX7c11tNd8Bd0uB+wtepa8BA61IrhZ2BRwoqshkKqE+4oc9vElYJD1TQ03S7VWMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E3MsZxcqZkaiBp8vZoRBrAf+qUv817E21BKTABFzNDqNIEvoyxbb4jpM4SUSZ8VnaKQTafRt+qTMZP/Xi/Tz7owMTEJLwJOE1hrdMSBTSvHKe9S2H9O474kAd6SPLdOtrWdvlpRzddh3sAoU0fcYq4BdpdphuwArbRhgOfoXbr1RE1QOKnrJ1XaQRdF7IcJkpyYkhgUP+hCJPhfrSafFAztVy1yehnXCguzHrs7U3epiAZ9MrXZq5HxBZ8Wx570Wsh/n8fz0FfHzaIlrvrvUDlyUIopLrv3/YsI8O/8OBrTt9QlMs2DHzONl6L2z2cIceqQPOKEhPzCnTICXCPmO/KcuUhiPBUmnWwaD8+OkW9xxHOUnr9s/eU9ONH/nEd2s+i5awjC+RqLedmYsHYYIiHrMv6bPtpVAXbZHze5TlU50elKElANC0jaa2iyRhJs7+qI0vpOBi1dZsJi4Dl7V/3qTINBySAT/pp7am5LyDehWyf+qrTT6jEqV7eaOnsQggXs5G4tMPGFz68Vt4lOeeoncM6cNQ5HNv3/yRmJBBW0zwHAPWkp3G6x2fClZ1zzT+5RYT+9aqnRtvy8aFAcMFDDP4LEd2FBkkzuzCJLM5l8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0e3dcf-2dde-434b-aa7d-08de9122a54a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:45:12.3609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ql+AOUp2cJWwcMzQZU6Qz/WUzC0QMNEON9B1z3sYsNQtTJPWR5MBH6ogS0YVr09Q9EoUhTwbZiQzYBj3ZzxrOEM+p2AOB+087NmhkFdvv60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030014
X-Proofpoint-GUID: 2dTawK1g27qxRDBz5UCmhtL5FumuN1sn
X-Proofpoint-ORIG-GUID: 2dTawK1g27qxRDBz5UCmhtL5FumuN1sn
X-Authority-Analysis: v=2.4 cv=DKSCIiNb c=1 sm=1 tr=0 ts=69cf1bae b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=R78La_C8J0khP6YsHn0A:9
 a=MTAcVbZMd_8A:10 cc=ntf awl=host:12291
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNCBTYWx0ZWRfXwJgfK0UDGDIP
 wYcUOYsrqOdG0otl3T7Mwe//bJXeHSGx2Od7bUR8wSXBHwqqBMYqsXf1N4CHFdy0KchlU7WJg28
 uHb362OfDhLrA5F6MzpG8eRsJYP9XKEVGQgrGoDeF38e5xfRgkJAvJSIrN1mj7wfpfDEKbxh3gw
 l3VJMs++ZKc5y/ZrPjTvqWUXhi24OMpQ+5hClFeDBv3yNLmLYhZj+Td4OpxDVIDU0Dej4HBKQmd
 5cM3tKC62Rkt/912UmjqHUQaqHMoHwlQbt1QMonJO7/LgI4wcLvYl8BCBREe7juUZ0SGh+qZNHN
 SjyVPVTgfbwkX/W4EX+kle9WbnWVdLX15RB1rwbyZzR/z9SYOItiJbcRKEDx3bjkGKU/NVVrRV7
 YD/zvZTc3KKfu0F1JaSYBL7U/JLA7RRpNyvPgfXt96iwjPzQRwW7FTSh/GVhJ31ygzVO1mU5t56
 01JuMjmZiTZHjaO8Di14SekHuBymFZtvYy903PII=


Aaron,

> The support for the !SMP configuration has been removed from the core by
> commit cac5cefbade9 ("sched/smp: Make SMP unconditional").

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
