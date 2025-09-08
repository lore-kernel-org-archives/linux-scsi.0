Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515ED2EF669;
	Mon,  8 Sep 2025 23:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757373018; cv=fail; b=oU1XuHHhNp/J5wb6FePF/ut2DX1xjPUPWGpZ2d0WqrLk+4d4MwtCTm1QrS4kAZj8CElGkMthzbThjjpJQ3lCgY9v/QjOq3gTuX7Oc6zbJx48aylDUc6+mdF4Rb6GXTvgvdCYg0mSZh5Z4rDjpqOBIVufY1KjUxITxMeRjg5fSrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757373018; c=relaxed/simple;
	bh=1wtdiEbuGXoeWPQBOg86yFqLNTrwQqxUvGZ7CM98q6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OvJWyMA3qJpthSZfeHt7t8sYCYF3b1xllkyNL6AG99UH3uMWY+nbpshXKOL+dVDgCh8fg+Hg7uxF+lT2teqSEfNEs11AwjLVj6i0wTeS4wsMVh3rC36JxN1Tx19sWW9KrhxStVBZd86hgmJqet6fa11Z/I0oP1DMOpl8qNfo8lk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hmcgw7yB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bIe14nFU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hmcgw7yB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bIe14nFU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBlRi010589;
	Mon, 8 Sep 2025 23:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9L56Jqi1rx1xCC7Sjj3uH2GtEmxPBgZ6orQ/qkexScw=; b=
	hmcgw7yB5EIwM7yLVApwHAHjoe8DHe66sM6ttHFN8uNMHF0+Vkf3XQwka9aw8TQs
	YWbFshY8G5A8oZWc6FGOVznAhRDHh3lNeM9Z+OjjFa++BKkCkMGHKShs59aiMx7t
	TLK0axzQaiZZKvM+mveObXgAVIgMzgtgRU8TCPHzQKzhH/lvC/H+7LdY2ImLV4Ff
	F3i1l2VETqs8PuXlUERoOKcgDnESxkHMA5PuNco6A8IL4ZWQfpscsplFjvCSQxYl
	S58isrYs3y917zyfY1HL+6tN1BcNAWbbzvPckQ0D0+wYW7B7G+yYUpLlY+26mJcj
	Ho29uo5ftc8XCrIR8SRXPQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922960puj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588KY5uH012878;
	Mon, 8 Sep 2025 23:10:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd924kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 23:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQn4Y/pRqA6rVUR8M+mkAUJ/K5pLeG6GBOB1PceXtzI5gsIIzVOnh4mdR5C6VWSiZjjyGTczTKP8Xx+6KDNG4ibSRfmouph1Kh7H/NbvGrXArj1qj3TzOwTi+wvu4PdsCufinTfROeyHZunGsK6YLwXr17Ygn5KHZARf2/1MOH/GukZ4FceczOzeakRPPeSji39fsLkSkpr/95Il7X54MeLCUGsN6/lbBlLq2rJX0/piK/egTzTMMMArA3LyKoNGJHmHjMQhNRQixwLbvgQ3v9wtCOMCNcCrFmjWArvnBzeNYiolKm67jfwazrLxw5OdGfuX13F8TMV2D8m31YEe9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9L56Jqi1rx1xCC7Sjj3uH2GtEmxPBgZ6orQ/qkexScw=;
 b=Vp9LX6tAD5CiclXV8ctsx88Om9Nq10EIBbBBJqBNdAjDgF6J2x3//RFlZv8J2YTNw9VbELlb+Q2mAFgR+FoeXfHWaEG7ngH6qStX9/QrEj8mmMklKyh1xQmVvcSbTOFLAGXZH/e6dcjuklXgJhlu6oJWY4Ls23UElZZZc3jrRTRmVPh3i3KzS5h2IMCCB2oGY44CL+C38aml3HXf8ZnskJGzfllQXZ9p9B/xsnl8H1sUuTy/qIEu/S3X5W/L8defClzRx0NRlIIe5vOQr1fIy9P63IP44Qk4dHgKrnOcpDXujVMMb1gUXmEYIyHULepBTwNGJtasvZPSfylGyZekbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L56Jqi1rx1xCC7Sjj3uH2GtEmxPBgZ6orQ/qkexScw=;
 b=bIe14nFUSp4yOx5cN5skkUwEQ7y8tq/1pAr1yJcAGMxL3mALksoWoe0MQrt2+ju4sl5UUu+qhEfihDjdO3XLtHcPO1fbAic1eaKOBscIYLaOm0/KmYdTysEcomwVdAnoNt7ofUFAwHrw6slt6YsQxbOOcZU9uYJ++nNtsS5jy9o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB5971.namprd10.prod.outlook.com (2603:10b6:208:3ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 23:10:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 23:10:06 +0000
From: Mike Christie <michael.christie@oracle.com>
To: bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 2/3] scsi: target: Create and use macro helpers for per CPU stats
Date: Mon,  8 Sep 2025 18:05:55 -0500
Message-ID: <20250908231000.10777-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250908231000.10777-1-michael.christie@oracle.com>
References: <20250908231000.10777-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0013.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 51364806-febc-4303-56d4-08ddef2cd999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i2fkBMGNnVRZ2t0V9oi5uzY8kP9aJymlN1OCRX/dg9zEyM7VsWG4NVFl6WI3?=
 =?us-ascii?Q?J02hzcPpk3IMJjYPkuO+NiYy0VnjQtWYqST800vagr91lVllq5ViVG/VF4dk?=
 =?us-ascii?Q?nTwNQVC0ebjSTYTWSSZIam/Qzh/dWDJfMnstpMXNekvZcDyaKRwRpmyQF5BN?=
 =?us-ascii?Q?yQMLWQbTiYEtgad+LhsPYb7To3L1i3XReDbUsI08QQDxCpFIDCMh+PwfZcZH?=
 =?us-ascii?Q?iBnYqY2whAWrmxaDWOWF8H9XH8hZCOTAPchzE/PIncNgYGWBRNF9SAZ1dylG?=
 =?us-ascii?Q?IynIdZgHptyQ2zTAnXfyY/n07Qd1HP1NAqzcfPu/pAHO2sYKZ3182Ey+zdFU?=
 =?us-ascii?Q?D0IMohAN/NmXHz0t+ow+fCz2RLG54za/mJKxVinxCKCYr2rK/z0Z/drIno1M?=
 =?us-ascii?Q?gHuUjp8YTETIsd4gK+XpPR9pht0b86gJ8j8jt+85jE4FRTvsaM6QpE7O6Bri?=
 =?us-ascii?Q?8ZYonTF3cw0daRDBxw85sXxO4icIo/QOVjDdJPm8FzZmv70yfz9gEd6EFb2O?=
 =?us-ascii?Q?9mU+AgFaTLf0AKIHTJ+EVYtf05S4eX7zjZxVzyfJPsN7zlI/C4G71z0LS46j?=
 =?us-ascii?Q?oRdXPOhFK1QqZiJyS/DI0AGpE6yhQvQAFwwCvQ6eFsdxH/JfYcI0F0fKRWI9?=
 =?us-ascii?Q?36d4N6ZfHfEwBk9ACoEvEbXN7o9L82IfrW+2TW/TkkhnaA0gbu8ZghwmeoZX?=
 =?us-ascii?Q?aLEEFO05ayAe61omUHGIaaT8EXn46gUfURnyKwEV141zsu6E+P5IQyIVS/Bc?=
 =?us-ascii?Q?BCzwdFEEzj62hNPSlh7iNVRBKZj0cPYEiB04xvEH9Itd7Kpdy80IU+Xitnt+?=
 =?us-ascii?Q?1PpXpQmizcRCDMb9el8oO9kU2ihwWKEqX8/87cG/sYjfLyHbG9Hmq4wDGOrR?=
 =?us-ascii?Q?1qGufjZNXafRKnqCj7FjcNpca6NUB73B5dvSiPQzsPMMMqU+o77AE7/mtmRu?=
 =?us-ascii?Q?cGGjRqEpwZjPtCQcZNxRJyZWrUf49fHSp0SXb2eMOWF8MwClMpkySCSvoN+x?=
 =?us-ascii?Q?HxmMUEIkOZKM72cFmYstZnoxzhPUS7YKxqkGrhRUCRfvF2cVfQmGZ/b7aCjQ?=
 =?us-ascii?Q?BSb4MlUMd698L1awT5Y+mgDYUX9SVTXdWNAXrzO63OVN/w2VqDxlLeiM0eIj?=
 =?us-ascii?Q?vQ4HK+Rwktkt0AzXQMu1WwgPdvEpJKDI2EBs/kJxkLUzvqgpO72kMCTx7bp0?=
 =?us-ascii?Q?VEAXeyioo0poA7HLGKjAbFvc9SmW0gNWBd9omCWPOH9qP5vXMNlJhF/yAS32?=
 =?us-ascii?Q?NhDe6y5QZmVarv/xEzR4JLzT/Ts8yvkuz9j2OHE7EOD8B8gIcbfk99I+cd/h?=
 =?us-ascii?Q?FJ+UHGy3ucx64SHmgLLp75KqhmE5OZ7PcAioo/71GhfhZxAOkgWGUYWCKDJL?=
 =?us-ascii?Q?+OqTUVlcd/YXFppG/UrY9lCuKfiH1hmAZM15RUx/x0a7AFTHZj739iXDzwS4?=
 =?us-ascii?Q?wdqV8BPorlY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hjXlF0M707wj1AQjwkS8rUjM41lCRG+Thej0ElGHSMqpVKgoUz5UqPddgCDN?=
 =?us-ascii?Q?PKSksoR8vjRmp8s/Bx/dROxBgRLSE29Hh498mpq4oBMVoogdEvT7WGHb2Exi?=
 =?us-ascii?Q?lLcLNx6PFYHpAIWoX+OKZMQWt7D83CL5ZkPUu/6lfKVzKbO9OK9ooimunEoK?=
 =?us-ascii?Q?YGD+BvG2zwLRle9EFwXjE7R7pWS05qOtPAzAfWuTLcUbcSKOPb6zEmW8qSdd?=
 =?us-ascii?Q?Xrtsvdoa2xa/XHlKlLMPxzvme7tYIb90vuIc/fLyZOzobnPbKlqN0R6tMpH4?=
 =?us-ascii?Q?2Uxf6VTDYidEb2olm/Y1r735MoVXxKZlco3J/0JVWROQRS/9MgIRELdLlE2J?=
 =?us-ascii?Q?IUGIpusWEe7RBhQHDh5ruG7Y3Nel9PeFUilMd0C9NkH/eHTaHAdtJUbb/u49?=
 =?us-ascii?Q?ybb3nlsyhnPkFviSqR03RBVUZTxQfJhabTlMFs4qA+IgOn7l50mlpKKxDSkN?=
 =?us-ascii?Q?5RVfvFyAP77xLWIWDc88ENYFHuAbT5++TKiQEdu2Av5YpTzwyWME1iP4KzfS?=
 =?us-ascii?Q?0Cfjzq/SVhGxgmJhm+9oHK0Z9FhNSaye24/NSWI4AbjL+rTrRcYTGsUxAW8k?=
 =?us-ascii?Q?AIC3F4nuOrRkn/nL7LKEFFKMP7KQjObVGSTg+cWrj5QFUKok4G06ubkQgXLo?=
 =?us-ascii?Q?5ft5wBp4mQsgnoEODh1Ty1aVaQSKcJd1Gxp5eKTrohIiYB/BeHKdZyEOTOh1?=
 =?us-ascii?Q?5iFMe5fY+C4SlDVN8ZvCEbdAt4rWAiPpDU3Onc9JW9ezA2w0V4gzwdCpYzIh?=
 =?us-ascii?Q?ZsPyPoY8ffm6vVU3w4PU0gasv6BuE3VZfgjXk9EHFwnMU0gbXJRhAci8hcXg?=
 =?us-ascii?Q?OoiEqNdsIHvRdSfE7Ln0U6ys4CNOvYO3hlYuIbM6g+gCaRBDvI39At2QC/dk?=
 =?us-ascii?Q?6fjyAj+nuXHCxY9V9DCbhTUb02C2naUx6FEh/5iGT9OpdT2ZJSuqm8s/Iy80?=
 =?us-ascii?Q?bd4P2Xf4adl7FLPSCQEb7Y6tT4V/dZkzr0mGY1TNHM3K41Dz4VFmBOCkVhtf?=
 =?us-ascii?Q?tQO179KTCP/hFb+QTPBM4s4/Q0I4AA0kNslhnp500c01XG6zfHNXadvw6zET?=
 =?us-ascii?Q?6wi/cb68E1WIZxIc+K4SvZdIKKkjCE70T8B6E0D7s1UIsMhdI6eDvBl5ZQDW?=
 =?us-ascii?Q?cP8bNXR5u5KQRetxFhbpDPDGswdQ3NrLYXR9XJakkUvSKYSlF3PuokhFRXW3?=
 =?us-ascii?Q?TvVxNvTuO5VEfKJzzw+R50X5wOdHrewD2nXR7q7mNvFk1HRqBXzwmc9gLhdz?=
 =?us-ascii?Q?GLbj7tJFpcyJRmhROgh5e/PjtrTawDSHlwMvOUv4cWV2qW67WjaO7p+Fc9Sl?=
 =?us-ascii?Q?eEr0N16TAOriS1z11DbTnEmzzTiPyju5T6DTxByDuMayukOTsfi67XolpI0a?=
 =?us-ascii?Q?3lrTqDWNM3VpPnIywPyldQnZ5TsUnV1BEAxNlijF842HOLjSqxFILFhe9reG?=
 =?us-ascii?Q?MzbpzMNBERYcNfHf99E7Pb1jzQhRMsXyraEaAqYeKMlvQcBEnKOmnw1Zo7Kt?=
 =?us-ascii?Q?L+WFZh0jNglOiqFgVs4rKyWbZnRGy3bdXGQqiFiYkKifsgjNqR8kIaXPpec9?=
 =?us-ascii?Q?EM7y/brQbhA7nrXT2eA8bpP013Gm7HZetXUBsrPQ6QnwST3pBqrVfMzO0Thw?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M5/UfNBOxdXU/nzwudjIxacCUYjEKMm86HzcphLmCDblTqD//TM+g4o/41+LxsmBDOLsD0tt3viQT21YrJsvjdY48u52wE4Vsd5WXjOAu8oYeuaD4rw/679BlqDmrdOAq0HR/+Agu+2fOM+ww3HDC+2R/Bmd0U/VDsh444HH2Z+UUleWAPfJ8Iy2Rxi413HsW42yfrrXPgB+YOcKD9fF9c9jk+qNY5mZOvU0SlC4AjWcPk4vGfpc6YcidImhRE2qNm+cEjfFstv5BHdqMCbdos0Ov2ZnxO8LtPxDrCyx9tYYEZCMRSzrBK8rsgNMx2L+9rbR8azlPUxJ5cPoqI2Vpp/UbWtOCrBcIe8hg0Ezxr0KAkuIgXhXz3THk4TsPC1bkiQCXfF6O2B4PCqa4mRYMAs055M+5FY5Izi1QmB1uP0BqYYSRm32GeBDq+q2bklSoIA0DvpLfUEU0W66ahitq6po0t5ROQlni0M/GT2raKpP9SSWFl1CkRjz/A20kL9tENV6zcasJHaOSZlB2SMsWrKUrZtIMoAQ1zgY+V9A107FaHfmDXNFag11IwaLcnB4hKNUL0tk6+2PMd9lhbyYU3d0R5vMDy8xuvkHnxOmx58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51364806-febc-4303-56d4-08ddef2cd999
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 23:10:06.6816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeaRAnAOqEkIUIGp/fsFV87c0anpCOXQZQw7hNPse/WCOc0nJ+VvLnJ7zIG/zpAjpn5W3ieUdSXKWH2LEoLjNDlfmdae92b8hnVots0Z5TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080228
X-Proofpoint-GUID: _v6wp--SBLxU6Ks3WtsFTFQQ4sst3OIX
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68bf6252 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=2nhI7uIJQZ1U3olpLWUA:9
 a=EBa_rOYxF3VBboPlVeQ_:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX8K81E92oomp1
 s+rZZhNR+97Wv13vvQfb0hiF5VMjvjf9hJS28LpybisgR/SDzY7XNgXBhBANgHMFrkJgmOFKtLf
 JDiI6FtLoaAhMFnk6c1LFiclSxOSHx0f0JS0YKCc6y/UihgXfwUyHNPfq1Ywn1X4s9YPUsDRTps
 YsLNVkJ8+7xkyrQCeTNN5AvegV8hveL1oi9q6P5phW0B2zRfQXPnGYnF+pri4G+geFoKpG7RtDq
 tRMjPZxLkvn4QMduD1LiuUjXfEWL78hulVlE/1E8aBlUFM5W+f2L9Ki+e5Zesx91ghShiPkpkXn
 8mjT9bpeacyqtXRQmrPcqROJ0BuCbAQnD4dzABkrilJJ4LAaPFdpsaLtkCyp/MpCtfAOWtRTE3M
 nNFA8Be/
X-Proofpoint-ORIG-GUID: _v6wp--SBLxU6Ks3WtsFTFQQ4sst3OIX

This creates some macros to reduce code duplication for when we handle
per CPU stats. It them converts the existing LUN and auth cases.

Note: This is similar to percpu_counters but they only support s64 since
they are also used for non-stat counters where you need to handle/prevent
rollover more gracefully. Our use is just for stats where the spec
defines u64 use plus we already have some files exporting u64 values so
it's not possible to directly use percpu_counters.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_stat.c | 197 +++++++++---------------------
 1 file changed, 61 insertions(+), 136 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 4fdc307ea38b..e29d43dacaf7 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -276,56 +276,39 @@ static ssize_t target_stat_lu_state_bit_show(struct config_item *item,
 	return snprintf(page, PAGE_SIZE, "exposed\n");
 }
 
-static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
-		char *page)
-{
-	struct se_device *dev = to_stat_lu_dev(item);
-	struct se_dev_io_stats *stats;
-	unsigned int cpu;
-	u64 cmds = 0;
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(dev->stats, cpu);
-		cmds += stats->total_cmds;
-	}
-
-	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%llu\n", cmds);
-}
-
-static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_device *dev = to_stat_lu_dev(item);
-	struct se_dev_io_stats *stats;
-	unsigned int cpu;
-	u64 bytes = 0;
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(dev->stats, cpu);
-		bytes += stats->read_bytes;
-	}
-
-	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-}
-
-static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_device *dev = to_stat_lu_dev(item);
-	struct se_dev_io_stats *stats;
-	unsigned int cpu;
-	u64 bytes = 0;
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(dev->stats, cpu);
-		bytes += stats->write_bytes;
-	}
-
-	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-}
+#define per_cpu_stat_snprintf(stats_struct, prefix, field, shift)	\
+static ssize_t								\
+per_cpu_stat_##prefix##_snprintf(struct stats_struct __percpu *per_cpu_stats, \
+				 char *page)				\
+{									\
+	struct stats_struct *stats;					\
+	unsigned int cpu;						\
+	u64 sum = 0;							\
+									\
+	for_each_possible_cpu(cpu) {					\
+		stats = per_cpu_ptr(per_cpu_stats, cpu);		\
+		sum += stats->field;					\
+	}								\
+									\
+	return snprintf(page, PAGE_SIZE, "%llu\n", sum >> shift);	\
+}
+
+#define lu_show_per_cpu_stat(prefix, field, shift)			\
+per_cpu_stat_snprintf(se_dev_io_stats, prefix, field, shift);		\
+static ssize_t								\
+target_stat_##prefix##_show(struct config_item *item, char *page)	\
+{									\
+	struct se_device *dev = to_stat_lu_dev(item);			\
+									\
+	return per_cpu_stat_##prefix##_snprintf(dev->stats, page);	\
+}									\
+
+/* scsiLuNumCommands */
+lu_show_per_cpu_stat(lu_num_cmds, total_cmds, 0);
+/* scsiLuReadMegaBytes */
+lu_show_per_cpu_stat(lu_read_mbytes, read_bytes, 20);
+/* scsiLuWrittenMegaBytes */
+lu_show_per_cpu_stat(lu_write_mbytes, write_bytes, 20);
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
 {
@@ -1035,92 +1018,34 @@ static ssize_t target_stat_auth_att_count_show(struct config_item *item,
 	return ret;
 }
 
-static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun_acl *lacl = auth_to_lacl(item);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry_io_stats *stats;
-	struct se_dev_entry *deve;
-	unsigned int cpu;
-	ssize_t ret;
-	u64 cmds = 0;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -ENODEV;
-	}
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(deve->stats, cpu);
-		cmds += stats->total_cmds;
-	}
-
-	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", cmds);
-	rcu_read_unlock();
-	return ret;
-}
-
-static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun_acl *lacl = auth_to_lacl(item);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry_io_stats *stats;
-	struct se_dev_entry *deve;
-	unsigned int cpu;
-	ssize_t ret;
-	u64 bytes = 0;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -ENODEV;
-	}
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(deve->stats, cpu);
-		bytes += stats->read_bytes;
-	}
-
-	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-	rcu_read_unlock();
-	return ret;
-}
-
-static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
-		char *page)
-{
-	struct se_lun_acl *lacl = auth_to_lacl(item);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry_io_stats *stats;
-	struct se_dev_entry *deve;
-	unsigned int cpu;
-	ssize_t ret;
-	u64 bytes = 0;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return -ENODEV;
-	}
-
-	for_each_possible_cpu(cpu) {
-		stats = per_cpu_ptr(deve->stats, cpu);
-		bytes += stats->write_bytes;
-	}
-
-	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
-	rcu_read_unlock();
-	return ret;
-}
+#define auth_show_per_cpu_stat(prefix, field, shift)			\
+per_cpu_stat_snprintf(se_dev_entry_io_stats, prefix, field, shift);	\
+static ssize_t								\
+target_stat_##prefix##_show(struct config_item *item, char *page)	\
+{									\
+	struct se_lun_acl *lacl = auth_to_lacl(item);			\
+	struct se_node_acl *nacl = lacl->se_lun_nacl;			\
+	struct se_dev_entry *deve;					\
+	int ret;							\
+									\
+	rcu_read_lock();						\
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);		\
+	if (!deve) {							\
+		rcu_read_unlock();					\
+		return -ENODEV;						\
+	}								\
+									\
+	ret = per_cpu_stat_##prefix##_snprintf(deve->stats, page);	\
+	rcu_read_unlock();						\
+	return ret;							\
+}
+
+/* scsiAuthIntrOutCommands */
+auth_show_per_cpu_stat(auth_num_cmds, total_cmds, 0);
+/* scsiAuthIntrReadMegaBytes */
+auth_show_per_cpu_stat(auth_read_mbytes, read_bytes, 20);
+/* scsiAuthIntrWrittenMegaBytes */
+auth_show_per_cpu_stat(auth_write_mbytes, write_bytes, 20);
 
 static ssize_t target_stat_auth_hs_num_cmds_show(struct config_item *item,
 		char *page)
-- 
2.43.0

