Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB1A3F7A8B;
	Tue, 28 Apr 2026 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374779; cv=fail; b=Wi17a+mPEgj31+GOfUyhUkZizPW0hq3gj+ayOBBNGrZKmbObVnRVvrkGNxSu0AJ08LUvDvfXNinrfxAFweciwXs5gJoTapqHlnXQqIO7wjJEOP+3R5h74eOcoJ8oTDl3wUaf44i6XiX7vhreJk9+fbewLn8LrNcv/gXP4hkQcA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374779; c=relaxed/simple;
	bh=VPK6aiR/klbopf63n2tFt/pm9eBFrFl+MBB3C6hgrvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nv5ILNtMbWWr1pQ33TrmQ2NGvWU6bVbAq9smxofY6WsFgDG4EF9pyEzwgeU3iZ4tZKyaIK5bC01VoTFEK1Pn65VGAA5KeG5phrxfOYYJI65FktqLT/97FqWTzkXwPbYxY7g81ycAqkUbNPFjNh+w78EveYIzQaLXYgB3pdC5p6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lXfHxtj8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VMXJMCYv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lXfHxtj8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VMXJMCYv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S9pvlH1905709;
	Tue, 28 Apr 2026 11:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fDVU/yy7jbne+z/SfvCkQxCfhvEB3zC4l0nCXCTR9To=; b=
	lXfHxtj80S0IbyD7xvSjSwv8kkqGyV0DDVqVG/UK9hwCHKtWkQapVrbo5OWJ4IY4
	6lm2q649POfB9brJs7657+/WmA4xFSh+5w0q1N/1yPnuUxpA8Hjipl4OBpZ4v1d2
	DXHw8Yl1CaS8rJURvcCXVenhWaKvMtiFR2Vc3+Xh9+huay2ECsVpj3d3EXmNyw8j
	tU3GukGz/2kjnU3p340PjUMdeXy0E66BhEddGaVQWGXq7Tj7qro1MTuL0pPUAbRT
	r8HlIKsqNH2ZZ0IhzMZFaPZUiy3OcBvGUuwoX5YSwG90lXkHUenxK9+4aFrGEFD6
	z4Cb0BIJAyjjrPCRKADxiA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drng8fcnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SB2jRa002822;
	Tue, 28 Apr 2026 11:11:37 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012034.outbound.protection.outlook.com [52.101.43.34])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cch8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:11:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FU9XbyshGOt/llJaoQvVZvdN7TKiFJ6UWinWy1K7rj0Os82D4UP7QCA/D/RvDW1EST1ANb3Kh8kI6aRipltZnpv4ikYH7thCZecF79/QhZqVzkXzXSeKCX5Kg7r1ulRXyPfKvOcUfh2DMOsdavw+qVn2B2DzJXJyepeQGpBC3t9U2ShsqHRmYO8EpvYiugktWF8HfRuUkEBbP8Mxat3OiB5xB6u++f8WNsOHtgMrv8KGt5QPo5BP0eIaSq+dhpvgobhdLwjiCZJ0gMqkuOgya9ZQg9bCazboka1KKiNPmVJba77Sv9XUr9L7qKgVADeor+qvg06X4F6yzsxCjeuA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDVU/yy7jbne+z/SfvCkQxCfhvEB3zC4l0nCXCTR9To=;
 b=mk0xMXYPL7DQbEEuKPdxxryuHIr2UM66tq0oqZvwwLxXHspSDf5h1xVuuiNy2mS7rdCS8tVG5l1n43QYLUrW5hpjhbNnQaTMcQnXm57m/pFFOI/x5MUT7WS/9x8K7ED0FuRKET8JcMAHbJlBVoXYPgqcqCxhNIxpEbym9WiC+YpLHsU4rQVQwer3vkBDLETVRQ+nNr7g0Q6nKE8y2BguPqOVXvhYasalsxbiprd+jnI+3g3UNumLBZ+z/leFCXpLu+sRpJ9HuBpYKkn7HzliEjBulRYva99caBG7WYkVPCO5+rIOnWIvj1R1ar25DtafDG6b0ldxiSd/kvlO99MDGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDVU/yy7jbne+z/SfvCkQxCfhvEB3zC4l0nCXCTR9To=;
 b=VMXJMCYvPJXZVQXyWE1U1eohpC2khjhHkWGS33EMnsjV3cYErviFd0JbSzBWo1DXOkwuiSUMZ1nKz8NAdzQ8dWnPFMhWUj9F/7qqexQGF6bsQEBLNlgHornOw4cQSwP7vbjn4mHLdx3sr6HeMvltuU39gLMPYWlo9Dcz4kfw0/U=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by BLAPR10MB5073.namprd10.prod.outlook.com
 (2603:10b6:208:307::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:11:31 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:11:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 08/13] libmultipath: Add sysfs helpers
Date: Tue, 28 Apr 2026 11:11:00 +0000
Message-ID: <20260428111105.1778008-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::13) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|BLAPR10MB5073:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb54f7f-f25d-44e4-d2a2-08dea516e684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BEU5iwp4COwogH6+4QKL2kMu9KIqY6qO7Wv6AJpQNefPfF9eeQw4L9MLfe+nMWAhG6gMGGd9IKyjeDxIpR/UqlSi4oBngatQMcXhX3vsdzBKicwZ+s4SpR7u6DvqiYOmupF+No3uuO2+xGWAVerlH007chfOmJ+HZ7hQLUyWP8wtB8JILEQjFuafkK8amuBJAV4O/RYUMHDGpa/s5oWwtC6Ozqxk5P7QY+sIp5GaHMuNv2nPAP6MGakH0gYetgKoSmcr8Raj+51VfhMWPQ84yeErHbe9M5UcLplK1VU8DfrJBmbqsdQIPE1kC46JJJ22/UMzrGzEwDG9bfjDFuV703sVyplfezTyDV0jdvdJGA1VuLN31c0q1J6ZyN2UwcAgC0GGx+gAA934FWV4BIX8s0mR/uLRjtxY4D2iJEUfSc602xpM5k8wKtBmMflmVtu5wUFTmiVz4pPlrgT/DtOcWm+7p7lfhI2oziTiNjlH7vXxEhi0vKkELZVv5zUDq5h7YTwwfbWL3iEHk1MIdBkF8P+g/b0ygmgXUNzA3HyvMqQMGPz/O2PYJgEBKa3Qh5rpFyb1v8iEsD41/imMid6O37bKpk6h7O7PNr2lOU88QdE7KquFKIEnpF4aipYmgU5zEvoB81hir0wuERbFWMKiNNZm2KoNHlREJqjlUpxAQyc7Lwstbn8Z/QfBjV9S8WYG2+Yu0PYSQyW/etOJdwalYO9pF/ZizBYwUUSRk2+Gd7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?INhsSoxgxg8rJ/R+tdk+LX44NsDLYpNy2WvrmSs1qp4raRYgCZcut30e7Q3o?=
 =?us-ascii?Q?ffeqDoIrwkTkJFy5v/ENwTsY1J6gislSzimY4SbiF9pgoIwY8oZP4YqVBr7o?=
 =?us-ascii?Q?HvEVA9d1crbuQh5GdxFq+0dntRQq0c/D6JFHaWLtprftJAhbWnEAOXMDW8qj?=
 =?us-ascii?Q?glsuDgrVUapKYr9SIHeLISDl8ZwF091RD4FHdBNdH+J19Be6JvQr5C50K1dK?=
 =?us-ascii?Q?Yh6nLQVnH47Tz9mRgxsoLk+qE2V0Ht+iTuFeWfmFkJp3RyZJUig3jveAMLlS?=
 =?us-ascii?Q?Y7z332Fwuh4fip+1Ok4MSQD1GWtaTGSTTyGHDIjqh5QhCQHeayg3jghpAH0t?=
 =?us-ascii?Q?98gmGHyruipCHg/9oajmaRlBskyNR5w+Z9BB7CB4F+HmWddoTwLsAAHDMbS0?=
 =?us-ascii?Q?I0G0xnt8cSs4mNa9u3ED3UPl/tQT8wELNLkEpsIe+DBKNGZI//qG13HdhRqH?=
 =?us-ascii?Q?RBgeqA0MCIK74mIk1byLDGdAfR28BQx00s13SGlU5D9WvRvBWZI8Bdw8Go3V?=
 =?us-ascii?Q?W4BYh0zU3+PeaofJxoWR2/HkjK9AM2ocvP1HYfcoOElgesSsD9hcOynjn5KR?=
 =?us-ascii?Q?GpFoobD1ynIOSefRJLypXdftRMUAy3BfxCvR7ocFlqr6nVaIwT9ZZPQ1OOs6?=
 =?us-ascii?Q?ntVXyoys2AezzfEPEUfGZb00BvgEHHeirgMEDpRJoi+raNsKOLNyUXNy4zJt?=
 =?us-ascii?Q?6oi01sYLeY4tYE/s+gi3xlsXQI3yB5PKjoHrKmKglzOm9XC5qP2g7FdL5N6G?=
 =?us-ascii?Q?27CA1zLwdnJ+ODaFD76c2tUlgMmLLuTxAOayOvSkl3c58xsCQEwPURSe1bPI?=
 =?us-ascii?Q?LLjhkdKnB/lPQ4n7fXKCcn5JF+wTjXfJgWGvqG6rsQxo+Rr6zf2GtXQiFVXj?=
 =?us-ascii?Q?a4Fq5chnC2tcm0jqyF8LcR1N9G6GA+p72NoCB4sh4iv59mF+QHntEfijk2wF?=
 =?us-ascii?Q?Zri3IVSX40oYhyg7Y3wKsw0vjgApUPE9VXQmn/ym6KoIqle8NoHFuuMOs3Ay?=
 =?us-ascii?Q?ADmwwXVuvlZQtZQ6OKPs1Pug6pQZPRDy4EBEAJ27uErm7N4Bb3BijdTam+Zs?=
 =?us-ascii?Q?CzQA7r0OqWSNeUXPZRWrGboBCrhA4adBWdeYxLvxwEMzkhk6evDR1xkFNqe/?=
 =?us-ascii?Q?pkv/Gf59O5d4IrtiudaQyHcolcUUEnHfE9J+6BttkhZ+r7YhiaRtGWsJnprA?=
 =?us-ascii?Q?TwnBD9mSg9YpG8Pe8TO4sDQc4itJqLE9Yq+IyBHMB6NNjtcAAu22FVV9SRUl?=
 =?us-ascii?Q?fJNYIuznTgK8jkpbKRck9shcUFY1Cg9KiJtBkt0ZU9REDJQluMBdhp4oyN2s?=
 =?us-ascii?Q?YtE7MzLcsRnZMHV8kBs2kNIpfDFH0s2jmznL2ytCcgktrRX+gu71ERgNuZTk?=
 =?us-ascii?Q?KgaUx1Ng8LfmE9i+wWVmHQvGrRM70y1CkC9WKf7Vc8UMinx/HfFJegJk6QlQ?=
 =?us-ascii?Q?Uo8jsTAL6vgO2p3D7wlUNoSr96pg9hboQdq7Bst2Xm1+6GMsag//YiYRVp1j?=
 =?us-ascii?Q?4wvy8m/PKarrLAmoVXVn6xZz24v+as1n9UQDoua2roUP0l0CitnSyGF0eDQ9?=
 =?us-ascii?Q?qwzWm6TFg1AQRlRY8086WiKs4KJ+qM08zYn8srEtYCrBkEOYvDLS89e1sAqM?=
 =?us-ascii?Q?3AU/C7kFpbrgrKww+Po3TVRyF4TuL1FINbp869S8AwK58eZGZlnHbErMUn7D?=
 =?us-ascii?Q?dPhz0tr7hKPFYWXNTiZyNzxwXcy/cNzhQ58A1jZ4OTcniQ+UHMWyK6fWOB+3?=
 =?us-ascii?Q?TLj9DBiXlWm1vSvHZV9blkNHa1L+kU8=3D?=
X-Exchange-RoutingPolicyChecked:
	MFXyO6JxbjIiY3roTPExf1rmSKZWnCiymLkg4UqU4LOT2ZUJgbgXvLRFEmLSgxXrwpWvHH/62qTIjHc4HCLbwW4VouPf3UnQgg85uY7H9fwF9F1kJEFat3xW53y9g2v7WcNdWvDhrtzYQ7nbbVKWcRaj4QU6MfVkdaSEfgmxdGIAppN+fjrvQUsF3ONngUOz5cKXWqWhQH/c7Q0nP/BZtWPdZvWb3RPlRMFOYFy7U+hwa7y+0Td6mpXm1NeW2DD8Xql16WH4TlN6T3pNmoQT3nB8ZL+2R/WnyowYFrOvvdPcnjXYfLq92LmB2f1pzwn5cCI8IShSVnVSKhBEzSQxqg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PzD5fEf/Sdwx8RUHHOuutwF5ngExrOya2zEnFtZ5UCIcx5zlwiXg0/XqmJ4ES3vS1pWXyv4KjS9Ukd3aGaVUbs8qDRtSjpdWPh3cUC5aY54buZgo3d6qFLAjKuP1yHzfbkns7OB+dvG85JpirH4EGdHXX13EgoVthv7VN1BMMAF6xSEJ8ozUUs+yR73N3wxf2rLc93K8Zq1wdL13srS6TkbaPnUvmI///M8od2rJ+BLV+//ZlvLoyde8pbKpYlJVzTDYrnmboyyxFLhhP3B3KkLQWEDX0zYQ8qtklUAEHd0iasEOxi49JoEdtcwfOipkt1MTjWgUAQ3OINAGBSSnh5AdxayN9FIp9rFJ1n4cP+B2O8oUHdBN35qtVYsaR8Nxkb4MT5p/eNTMwrmWq8O/D5IYZKdx9y2CJpEXrjES8p4wxIjTOwCOqbSmZF4XRS8JezRUx0595BMxPhiT3VWHMNpw9KeSHVJq5l4DQqv9ByzMlkLjTi8lt3mc4H0c2oNqbbEDcNKI4p6VSNPDUobHr+zBQFoT5L3TIO/M6KZIVa4sNZ+dcwMw0t4AU7vtXGw/uikPP7NICGP3JQEPUQqqXGUvFR2Q6oxxx9kcsdCRqY8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb54f7f-f25d-44e4-d2a2-08dea516e684
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:11:31.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saefgbsZ6nalENUzLF5kQa4lQ0pcaMVpGe7tywEefx2C3c8o1XwBJcVkk/efMpVJZGwI5OpZIxZhMMgLL5qB3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604200000 definitions=main-2604280100
X-Authority-Analysis: v=2.4 cv=U7uiy+ru c=1 sm=1 tr=0 ts=69f095ea b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=JWw5DRbbQmmJTouRsXkA:9 cc=ntf
 awl=host:13844
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX+uu5tisPdipE
 8UkLgFebFXTiqCN5q34LadW5MEBHFkm8UEuwYzKS7Gr6d+PmOPB4tUGudmjg910IAAUpDLAz9n/
 CSKi9J4JjZoQgWEga1/bjZbyaX7cM51FZesDRz9s8vT4uQnhB2UqaBdtWNjacsZoNuqtS+wBPhK
 M6NjNSpnw3ZBtOFcsKxVNcUFG3+wO7Xz8MyQeMRJ90ZAsTouVaB4j+6MtbCJvn6MCD0oRSEvosp
 sLIAzFH979iVquo8n7vgc+307GksjGYIkXAUjgMpadwK21Yoivznv9MQTVWqBe9Yi61p0XhINC4
 E2w+goTx/7QwGSMzL4SYU2fEMHncwLP/8qMWgQrDLszGRpLxbVSuL0YGysmYao6KiuSmgVTJ3tk
 hTlf1suqKAxTPHf9l6FcooyNg8IoBuKQry/F50SvBTRDKsJJXfOgYUHoTGs7bSumRI0IqevNhxu
 3QWE6eep1ZZCGjdyq0j+j58sVivLM/CTOZ7LzoB0=
X-Proofpoint-GUID: _bL7H0AcLGW61SuiKCfEZFLnUm3kCIC9
X-Proofpoint-ORIG-GUID: _bL7H0AcLGW61SuiKCfEZFLnUm3kCIC9

Add helpers for driver sysfs code for the following functionality:
- get/set iopolicy with mpath_iopolicy_store() and mpath_iopolicy_show()
- show device path per NUMA node
- "multipath" attribute group, equivalent to nvme_ns_mpath_attr_group
- device groups attribute array, similar to nvme_ns_attr_groups but not
  containing NVMe members.

Note that mpath_iopolicy_store() has a update callback to allow same
functionality as nvme_subsys_iopolicy_update() be run for clearing paths.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/multipath.h |  7 +++
 lib/multipath.c           | 96 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
index 6afbf6ae1d2a9..b18491c1d077f 100644
--- a/include/linux/multipath.h
+++ b/include/linux/multipath.h
@@ -10,6 +10,8 @@
 
 extern const struct file_operations mpath_chr_fops;
 extern const struct block_device_operations mpath_ops;
+extern const struct attribute_group mpath_attr_group;
+extern const struct attribute_group *mpath_device_groups[];
 
 enum mpath_iopolicy_e {
 	MPATH_IOPOLICY_NUMA,
@@ -140,6 +142,11 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
 			struct queue_limits *lim, int numa_node);
 void mpath_device_set_live(struct mpath_device *mpath_device);
 bool mpath_can_remove_head(struct mpath_head *mpath_head);
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device,
+			struct mpath_iopolicy *iopolicy, char *buf);
+ssize_t mpath_iopolicy_show(struct mpath_iopolicy *mpath_iopolicy, char *buf);
+bool mpath_iopolicy_store(struct mpath_iopolicy *mpath_iopolicy,
+			const char *buf, size_t count);
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 			char *buf);
 ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
diff --git a/lib/multipath.c b/lib/multipath.c
index 9a1a8cb4a417f..680bb4f0ae237 100644
--- a/lib/multipath.c
+++ b/lib/multipath.c
@@ -753,6 +753,102 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
 }
 EXPORT_SYMBOL_GPL(mpath_device_set_live);
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static bool multipath_sysfs_group_visible(struct kobject *kobj)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return is_mpath_disk(disk);
+}
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(multipath_sysfs)
+
+const struct attribute_group mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(multipath_sysfs),
+};
+EXPORT_SYMBOL_GPL(mpath_attr_group);
+
+const struct attribute_group *mpath_device_groups[] = {
+	&mpath_attr_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(mpath_device_groups);
+
+ssize_t mpath_iopolicy_show(struct mpath_iopolicy *mpath_iopolicy, char *buf)
+{
+	return sysfs_emit(buf, "%s\n",
+		mpath_iopolicy_names[mpath_read_iopolicy(mpath_iopolicy)]);
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_show);
+
+static void mpath_iopolicy_update(struct mpath_iopolicy *mpath_iopolicy,
+		int iopolicy)
+{
+	int old_iopolicy = READ_ONCE(mpath_iopolicy->iopolicy);
+
+	if (old_iopolicy == iopolicy)
+		return;
+
+	WRITE_ONCE(mpath_iopolicy->iopolicy, iopolicy);
+
+	pr_info("iopolicy changed from %s to %s\n",
+		mpath_iopolicy_names[old_iopolicy],
+		mpath_iopolicy_names[iopolicy]);
+}
+
+bool mpath_iopolicy_store(struct mpath_iopolicy *mpath_iopolicy,
+				const char *buf, size_t count)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
+		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
+			mpath_iopolicy_update(mpath_iopolicy, i);
+			return true;
+		}
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mpath_iopolicy_store);
+
+ssize_t mpath_numa_nodes_show(struct mpath_device *mpath_device,
+			struct mpath_iopolicy *mpath_iopolicy, char *buf)
+{
+	struct mpath_head *mpath_head = mpath_device->mpath_head;
+	int node, srcu_idx;
+	nodemask_t numa_nodes;
+	struct mpath_device *current_mpath_dev;
+
+	if (mpath_read_iopolicy(mpath_iopolicy) != MPATH_IOPOLICY_NUMA)
+		return 0;
+
+	nodes_clear(numa_nodes);
+
+	srcu_idx = srcu_read_lock(&mpath_head->srcu);
+	for_each_node(node) {
+		current_mpath_dev =
+			srcu_dereference(mpath_head->current_path[node],
+				&mpath_head->srcu);
+		if (current_mpath_dev == mpath_device)
+			node_set(node, numa_nodes);
+	}
+	srcu_read_unlock(&mpath_head->srcu, srcu_idx);
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&numa_nodes));
+}
+EXPORT_SYMBOL_GPL(mpath_numa_nodes_show);
+
 ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
 					char *buf)
 {
-- 
2.43.5

