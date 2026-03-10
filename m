Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61B3ECBEB;
	Tue, 10 Mar 2026 11:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143470; cv=fail; b=t/8JhWdc0z5R6J/YE5HPV+g9Pl84gZz3PtCoOiW9HT87CiDzo6E/GapwKmlEaaWD24jNfZ9qmWjq6VUcmx73W2cOQmHUgtjMEtAVkqQt7KAEjH02dCZGeoqhsm+upyXLlNPF69v9phdeXJSf1dvDl1c5Hk34+3MbDC8lj3sgTjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143470; c=relaxed/simple;
	bh=QRTvCjdPbNZHSo4Z/JEMNXymWsC7j7oM1YMACzAnOOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PzranNlvr8jrH+wyt+VAGT5hpOQ6eLoGrUNZOjOu/h540zYA4o2JslDP+nXcInWhJzbbgzeqXLLvcWkfNKkSqNCImTzuF5GXkslyf6E4ukGbz2sL92k5vrtxrlzIc37JhuHXCHhJQ1HLj9ni++G4Q3SM+UYs3g0G5k/TV50XOLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=onxLk2dT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TwVIwVjz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="onxLk2dT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TwVIwVjz"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9padI1719464;
	Tue, 10 Mar 2026 11:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FO/cAK6o81XPPeYCn7Kpf8qBPzAzBBFi8m18fVhx+9Q=; b=
	onxLk2dTvHdYbJ4/iybPuDdJr5gMyZRUv3ZH7UpxyXxyhoGg4xaBDGF2AY7IEGbw
	kkO34uCSzpNF/wyZjF+cJgd40gvM8C+GAN3EEFCkoMVDUTuu+wiRLWsSmUu7c3RZ
	0P+LCW8uYilBkAGW9NE5ZryI21OyUsrBEuebABNLAunu9lEWfhb3tKkwbGz+fHqd
	+CqGnqSymSd3QuZaCz5ggI/zhg0Ew7zWFp+X2nGdqlYF2HCOp1qkFPVojmPMPnWh
	+cr8LVbZHZVvwY2Y1IOSVFV92kMdFQ7/RZUAvJAaNcC3ohhjNQCg8DOcobP0jgxW
	OU3ugG3PH8a/vBk3piIn+A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskyp2nuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62A9o4vL007796;
	Tue, 10 Mar 2026 11:49:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012067.outbound.protection.outlook.com [40.93.195.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf9yfuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbFv3X6R4GnYypv6/i31KKVF0sHjxFwhyB+nexxipTKgDYHtnkdDbcfIiZT0EtOyaJ3Uqu+853yRMQam8Nx62/RpwxUgyEisOSjTnWCk2h16qA/0Itlttsj0JpFaueszpzzYoAKVDYtMxudu3J7M3F5GonLYe2r6LT1KUZnC/sSBSMUM4JHLCJHOtgr/HJZwGG6On6TNCTgLwgky6n51gSLw/wIh3cdaGxUoXwC1KKk0D1jCWhoUNWyVvH7SjNtbCRggxE9piTZubQ5WP58bb9U6fUvZdbe5yz+RxL5RZy9MdJ07birUbeqnoUrQwfx+RdVjB10UNX0gcsBS3Yo/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FO/cAK6o81XPPeYCn7Kpf8qBPzAzBBFi8m18fVhx+9Q=;
 b=PT+NdZEXCuTSOw/V8dCWZ15YOhFy/96PxS4KaC2WLCuxC9D5YrhKmJvhKbej9/hUSmlZ+rznuXDWxbWYjonkQOTSOp1swCi3gQ32c8xhqGzy8CNWo+3LTSEGRO5bxGNk1B88ywOcEWZ7iMh5Y+cAY7xEuUssGy16c3H6Swi7Lr23zXe/LbhSiv5id7sTmv1xAJqH0QlG+NbWsb+KGvXaz+CBG67SkpruIo5xp+Fn05Zxp+lQ/L3qWHzfe1adKSo2dF1Dkh3pM2c3tL7+Sn4JqqmIUpNj5Fdkt1waU5EqfsiZ1TC/j2xXNNwlILbvHmueXyPPUgKWa5KVhOl2dxH58Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FO/cAK6o81XPPeYCn7Kpf8qBPzAzBBFi8m18fVhx+9Q=;
 b=TwVIwVjzPw20x/4Vc8JZ3+KI1XCV9y52j4x0YON9NWi/s4a4Qsjq7f6ofBiPuDKMVWg8eFbSEDluXR9I/fU1l1WQ/aRwrTGDegJQ3E7hByz4po+2RqMImk+YEGN0lwMJtNtGXmJZi567nR8TqHeHgfQkqgg7NvECa2L5PbhVFrg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4519.namprd10.prod.outlook.com
 (2603:10b6:510:37::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 11:49:47 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 5/8] scsi: scsi-multipath: Add basic ALUA support
Date: Tue, 10 Mar 2026 11:49:22 +0000
Message-ID: <20260310114925.1222263-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fd30a1d-03b7-4660-11a5-08de7e9b20d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	NvG1+HaC/tyW9T8SuvMepjb6vGwfjacYYAeQ5b9h1WUzY1ZgEpCDyuuAWLSYkZ5hC64DLvDM95HhtLj9K/u58tSr3hKDzQlD9VS/okpFuYS0JjHZnvzjBskS51Rhzn+50ra212MLNwYvLyRRXiUaGSASDuxU8+t4hpwC4kVsm5HoJVpkZFmV4fMjE/GiuMqQNQWhg1DyaF61iQoLwJAP20mEBeMa1EdMVgA8Ri/to94hYea9Kj5R6RBVgzqr1H6bfWBbYqSamMud8wKv6JnEYjIrqMGPSbnm6lsERV9Ixr3Ia0QHdtFFhAyVO+zXeg2hFbR0S4dmW5K76DB3eWshkKmFpEOJ7zkMIZWH2KoR+MO53xRsOl3cAskfaf88lqNrCeNvESq12Hg1A6vOcB/tb2J3x4pb6FxL4/iwZLkB8chZg+tuAyp4bWrri04zRp3LYlmtpF2r0SK6Uw6MWtlaMDktFtUxoQOV1qaB5Y3Hg9hu5MLs97S2Gka24DKSRcPmLOyDeUNaxGFNewIBpAuQqsPK3uQMbGXb9gpHvZ9e5qzlFTDzvsCwEi2FLVzoLOE20VXrUM/lPD61HGQLOW6/3x7B63o2hJvQPj8RIMah8S6bga9l/2Yswn0BRpwo5SjWF61o39zy2qCJ4kKgCqXwtTNNTE+tBsydFr5STLbFc8LB7Kr2VDBoBK7B/S4jRYy51X/r+WfhjpddyyyDXxNpPQKtLJpM3kyQdgQCCGu+3cE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RQsIULEk5fy+vDXDIHD3hE5LUCfCCl6BkprhYptl3PZ+Q0ShAQMTMvsWx1qS?=
 =?us-ascii?Q?PKji1mnJa1XxxDD5CUl5lwSXK8MiDL6iu6/W/VVfnjgoEDifK09fKaDmVamP?=
 =?us-ascii?Q?b/OcAUOUbTjWw/447jaZqfTGQmJP9hGaIijmWtgk7Vy3v5fMRpg7JTjVgmr3?=
 =?us-ascii?Q?PeXG2fD3FHjwcKzFbVBsXF3TTaePRcYZ4W9NPdVFqNL7k5piy+d3k8SnwU1G?=
 =?us-ascii?Q?gy8Bb+ha1Icg1whXo+GSJvASJqX9f3SZ3Vt/AYu8OmU2q1HWPRNxn+LeqSeU?=
 =?us-ascii?Q?/uf6bAMO1EvHx5IALIO1qmeb7EPwJ+1XJ74FJZQzZ9rKuMJCdg5wynNCF81X?=
 =?us-ascii?Q?2SKkfs/mm4ZFIqq4bd8PkpdDdmGnYYH7hyixSvO3hJQp1vg2TaMjpiGEFuWu?=
 =?us-ascii?Q?kDq8l4gitMtfCZp1cwxgq/qmCHOoSMDSPlNfpZEA+P+2neO2utsgyBcFmOoL?=
 =?us-ascii?Q?y3cUExCwGbundg0a0fY5tnES8EA/lzFN7TB1xJ80aVsIArZLH9uEQ08Ulf6+?=
 =?us-ascii?Q?MBZG4UFv8ZQdJ3OEatPhQzQUCQPz3FvGzCetzvsn4pDoMnHIeYfT2R7z8C5P?=
 =?us-ascii?Q?PzJPHYCJM3BdD1FGcScq5K4ziMUTLQNOfS1hhg3Ae9+njHtpj6NMpwhSDGTx?=
 =?us-ascii?Q?h7couAPWAK0QOdgweFIyd84owOuRzXhXwZXGujMw2DqlRTqjtSM2LoV23BE9?=
 =?us-ascii?Q?6C0WRT88Z/yWjD2wx5XIW5wPXK6IGXLrnjLuzzh8o5xrYx0YR9OOK5cZ9auQ?=
 =?us-ascii?Q?HXWggNLhTff7pd3o8mRSu+FAFpGkofgKB2tdCcFawfwbY+QbBjM/QTDXjktZ?=
 =?us-ascii?Q?j6M978Z5Ed4TmUph5XDnRo2Jm7r5crCLINwc7oeqlnCTsQq+d96zrmCepSYS?=
 =?us-ascii?Q?/A0UDhvM9k9zGNs1tZuXF5G46wlbpkF0ogAFqwTnqzvOndqaJGtwFL7iI4wx?=
 =?us-ascii?Q?oW01f2l5K2GCdYwHrXlrS7Mzt2GCaq8gbmbQVb2Q8ieq9wrzyqty6ucGnTsV?=
 =?us-ascii?Q?l0aJb7UBMGOeP/PIGBkBGBFKA5QWubJnmL/poA9iNk43kt2wGpW19Co+fOPu?=
 =?us-ascii?Q?ilmm/nJDqh+tKmxif9gYubT+Cqx6/LYiNU34iHqZ+gXSmUrS0bN3TWI9dQh2?=
 =?us-ascii?Q?DIUjzlG+1yjENC3ylnPvm8fQyar0YX0HLHSbs2GvlAOFS+wC52wWZ35DpkF+?=
 =?us-ascii?Q?4NLPv4nw+gi7NDY80+qipDcZ6RKUwD4E2Q6f1BY9vapxzFFnC0i21EBxtsXT?=
 =?us-ascii?Q?+0vPqkM54YZh6fwvgcRxSwMcAjUSOUpQUzGK6OLQ1+yiR28N4GiQ/PP2yhrc?=
 =?us-ascii?Q?XjqzgcHd/uxP2BzLY/X9BUB3JGPZD/W4vdhRhsq8Z3q1XQIu6+jk2z5ZwSmV?=
 =?us-ascii?Q?A3nfq2VK5uMgvMzduAod1s9JEi8RyruKq6UNIpQBUpkyBkgxvg13yiWXQ2BE?=
 =?us-ascii?Q?HH/7SSNk5EFfsLx1AWQ/2YqIVW8JZKsCZEpV1d8lgHxbfRSrG/EYrtgQHyX+?=
 =?us-ascii?Q?HYUJLV8HBMUQ4iLy5p9NDuVZJdXL+x+uEOw6kJUxN+wbbRLDXvcABFRZF55t?=
 =?us-ascii?Q?Qy7ondYvsJG+iZN9fEzHE4rTZP95Gh0Rbq7x+JJvHVZrqeaMRtmdD1bZafru?=
 =?us-ascii?Q?uK/qJ7Sdh1WH0ppgT6ANfnSvzs+EYWrXQCmaWgnxBGZNrN2O3EjAkzPGuV1u?=
 =?us-ascii?Q?STBY3ZN04kll9xGrbK25zds/vHEGp8N3JhAwqqakHqPz9lKbtDo/kelXQGTx?=
 =?us-ascii?Q?x60Q6zmZng=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	Yp0FWmfWgiDRCOEAzKHB4/sNqPVrphqOm/cL5lNDA0bqjbf7i4Ak/JMvueyBRUH4dP//6TZt9vcQ3jUuYEiYNfiUDkrjjwsn5SP+xIrh0TOm7daCs2XTLk8GQK/OxJorpHzgKdpzk8fXa4k+V4R/agRh+EZS1/jGzifBvjih5RnaeOUy6N7HUfUBEr1Z17KPMNAfQc1++Hl173OgrtpZK5pep7MVXHdij409+ggxJ6QDvf4z8vmXG2Da5EVZImenjQpSLrhSAw4T3apUgC5uivREuxjgNAY3FU1+DHf4ykl39QThxV38lgOhhGXdKd9zAerVsY4DHcYUPNbc9lFQOA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4JLe+37cVxsvCefx8k+DbL9mzQbZ+XlYh+/i52w7HO0gj2kB30O/g8fTbNPBt6bRk3t+1WyTjUM5SL6EjCp9RBkN1g5LrlxuZGEyLpHD+s0ROAKGm32rNi8X2n5HDnRefkmCnS2zs1Lhv9V8h3YvTFi6Wfn3Kpw6SzuGUQ9rm+WvKjwVRDVcvxYk35dAxzLVRKVQURVX+i/2Lu+gDRrvmEKeYYhiq+IulL3IkP2aG+RfqNcBR0sljKSMifCPTWDPbUBZFf3/bqZfbm1SK76Fj6zq5JUbVCOYKjOsPtfPo9iHATEzhohvNsJXhJY6lNKgzW7puElJ7+QXlH61JQTO8DyqHFjlwmD3WYlwiMUhqZ0mEk0qQBtznuFv+SbvRr3nyOOK2VdWrKXA25e6oBmL330ujmi7LjhHtdRfydpGbtB0SYBgnkqfO2BLN0OAFOkC8u18Cix8gFrdRxgdjXvjPXwqmRMcc0ME8npFU8c2pMeFxuPw6c1inod0R7C+1oF6MRMn3RoGuiY6v1A+3fqcSr4rfteZRy/8NUhZztrgRBGcUx6DuZDFA0wj2aAAxoUck2jX+n3FhLXm2JPCpuCXifz2bBA1tReYyf1MrFBM2hA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd30a1d-03b7-4660-11a5-08de7e9b20d8
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:47.0376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNoahDBHVq2HjCEjppaNsdO5aXTkf8Tsr750L4wWGN8/q/p2ntxssI6jJJOtpmzsTbEd2aLF2dCrGm7VbMm2aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Proofpoint-GUID: 9Nk7jOjmQ_kjt5_p53hZmJa50Pq8Hy_3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfXwqskKXhbuECH
 vxq/z19dRJ8q6K4uj13/82A/vwFECLlq+XY3hhkDQUSX/lnrktP8ggukgSF/h7YZxlZb5xqR0rB
 MnkmLYbfi0e72EVwS++NIsoHc5D2MmKDJJB6x3qUSrMyqTw7lG6+sMv5HHFNSfkbtiY1ZsUXnLi
 6ctgtyU92EFkhQWIP+MwFoN9wBgNr8yJdENoWmQfzZGqG59x1Falzw2aIP6rtF87pt0EGTK+Z8L
 xHr2VX+RAOtUn6Yu903arYt3CnqXwu3iQFZdG7kFi3HdhsL0HA/ovuq8HGxhFW9TrKlMFVU/Oc7
 tdb+L5coPVU4eVPrUMPAIxBaQqRNj6D/4RxhfcwL89LVvDcK6sMI7vuQEpest7ZxVuR95PDTGZw
 d82Wtn1anw8zn5sEZKPkgBKkonukt49sjALEWYHl7JBsMlX2K6HqZCcqXW0dMXTeq7Bo3/gxQrK
 IlmCXKLxdMWSdd2BSvg==
X-Proofpoint-ORIG-GUID: 9Nk7jOjmQ_kjt5_p53hZmJa50Pq8Hy_3
X-Authority-Analysis: v=2.4 cv=XP89iAhE c=1 sm=1 tr=0 ts=69b0055e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=AZlAolgNaF6XCcgzKhEA:9

Add basic support just to get the per-port group state.

This support does not account of state transitioning, sdev port group
reconfiguration, etc, required for full support.

libmultipath callbacks scsi_mpath_is_optimized() and
scsi_mpath_is_disabled() are updated to take account of the ALUA-provided
path information.

As before, for no ALUA support (and scsi_multipath_always on) we assume
that the paths are all optimized.

Much of this code in scsi_mpath_alua_init() is copied from scsi_dh_alua.c,
originally authored by Hannes Reinecke.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 163 ++++++++++++++++++++++++++++++++--
 include/scsi/scsi_multipath.h |   3 +
 2 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 1489c7e979167..0a314080bf0a5 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -4,6 +4,7 @@
  *
  */
 
+#include <scsi/scsi_alua.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_proto.h>
@@ -346,18 +347,29 @@ static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
 				to_scsi_mpath_device(mpath_device);
 	struct scsi_device *sdev = scsi_mpath_dev->sdev;
 	enum scsi_device_state sdev_state = sdev->sdev_state;
+	int alua_state = scsi_mpath_dev->alua_state;
 
 	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_CANCEL)
 		return false;
 
-	return true;
+	if (alua_state == SCSI_ACCESS_STATE_OPTIMAL ||
+	    alua_state == SCSI_ACCESS_STATE_ACTIVE)
+		return true;
+
+	return false;
 }
 
 static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
 {
+	struct scsi_mpath_device *scsi_mpath_dev =
+				to_scsi_mpath_device(mpath_device);
+
 	if (scsi_mpath_is_disabled(mpath_device))
 		return false;
-	return true;
+	if (scsi_mpath_dev->alua_state == SCSI_ACCESS_STATE_OPTIMAL)
+		return true;
+	return false;
+
 }
 
 /* Until we have ALUA support, we're always optimised */
@@ -366,7 +378,7 @@ static enum mpath_access_state scsi_mpath_get_access_state(
 {
 	if (scsi_mpath_is_disabled(mpath_device))
 		return MPATH_STATE_INVALID;
-	return MPATH_STATE_OPTIMIZED;
+	return scsi_mpath_is_optimized(mpath_device);
 }
 
 static bool scsi_mpath_available_path(struct mpath_device *mpath_device, bool *available)
@@ -579,16 +591,147 @@ static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
 	sdev->scsi_mpath_dev = NULL;
 }
 
+static int scsi_mpath_alua_init(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_sense_hdr sense_hdr;
+	int len, k, off, bufflen = ALUA_RTPG_SIZE;
+	unsigned char *desc, *buff;
+	unsigned int tpg_desc_tbl_off;
+	int group_id, rel_port = -1;
+	bool ext_hdr_unsupp = false;
+	int ret;
+
+	group_id = scsi_vpd_tpg_id(sdev, &rel_port);
+	if (group_id < 0) {
+		/*
+		 * Internal error; TPGS supported but required
+		 * VPD identification descriptors not present.
+		 * Disable ALUA support.
+		 */
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: No target port descriptors found\n",
+			    __func__);
+		return -EIO;
+	}
+
+	buff = kzalloc(bufflen, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+ retry:
+	ret = submit_rtpg(sdev, buff, bufflen, &sense_hdr,
+				ext_hdr_unsupp);
+
+	if (ret) {
+		if (ret < 0 || !scsi_sense_valid(&sense_hdr)) {
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: rtpg failed, result %d\n",
+				    __func__, ret);
+			kfree(buff);
+			if (ret < 0)
+				return -EBUSY;
+			if (host_byte(ret) == DID_NO_CONNECT)
+				return -ENODEV;
+			return -EIO;
+		}
+
+		/*
+		 * submit_rtpg() has failed on existing arrays
+		 * when requesting extended header info, and
+		 * the array doesn't support extended headers,
+		 * even though it shouldn't according to T10.
+		 * The retry without rtpg_ext_hdr_req set
+		 * handles this.
+		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
+		 * with ASC 00h if they don't support the extended header.
+		 */
+		if (ext_hdr_unsupp &&
+		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
+			ext_hdr_unsupp = true;
+			goto retry;
+		}
+		/*
+		 * If the array returns with 'ALUA state transition'
+		 * sense code here it cannot return RTPG data during
+		 * transition. So set the state to 'transitioning' directly.
+		 */
+		if (sense_hdr.sense_key == NOT_READY &&
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+			goto out;
+
+		/*
+		 * Retry on any other UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == UNIT_ATTENTION) {
+			scsi_print_sense_hdr(sdev, __func__, &sense_hdr);
+			kfree(buff);
+			return -EAGAIN;
+		}
+		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
+			    __func__);
+		scsi_print_sense_hdr(sdev, __func__, &sense_hdr);
+		kfree(buff);
+		return -EIO;
+	}
+
+	len = get_unaligned_be32(&buff[0]) + 4;
+
+	if (len > bufflen) {
+		/* Resubmit with the correct length */
+		kfree(buff);
+		bufflen = len;
+		buff = kmalloc(bufflen, GFP_KERNEL);
+		if (!buff) {
+			/* Temporary failure, bypass */
+			return -EBUSY;
+		}
+		goto retry;
+	}
+
+	if ((buff[4] & RTPG_FMT_MASK) == RTPG_FMT_EXT_HDR)
+		tpg_desc_tbl_off = 8;
+	else
+		tpg_desc_tbl_off = 4;
+
+	for (k = tpg_desc_tbl_off, desc = buff + tpg_desc_tbl_off;
+	     k < len;
+	     k += off, desc += off) {
+		u16 group_id_found = get_unaligned_be16(&desc[2]);
+
+		if (group_id_found == group_id) {
+			int valid_states, state, pref;
+
+			state = desc[0] & 0x0f;
+			pref = desc[0] >> 7;
+			valid_states = desc[1];
+
+			alua_print_info(sdev, group_id, state, pref, valid_states);
+
+			scsi_mpath_dev->alua_state = state;
+			scsi_mpath_dev->alua_pref = pref;
+			scsi_mpath_dev->alua_valid_states = valid_states;
+			goto out;
+		}
+
+		off = 8 + (desc[7] * 4);
+	}
+
+out:
+	kfree(buff);
+	return 0;
+}
+
 int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 {
 	struct scsi_mpath_head *scsi_mpath_head;
-	int ret;
+	int ret, tpgs;
 
 	if (!scsi_multipath)
 		return 0;
 
-	if (!scsi_device_tpgs(sdev) && !scsi_multipath_always) {
-		sdev_printk(KERN_NOTICE, sdev, "tpgs are required for multipath support\n");
+	tpgs = alua_check_tpgs(sdev);
+	if (!(tpgs & TPGS_MODE_IMPLICIT) && !scsi_multipath_always) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
 		return 0;
 	}
 
@@ -622,6 +765,14 @@ int scsi_mpath_dev_alloc(struct scsi_device *sdev)
 	sdev->scsi_mpath_dev->scsi_mpath_head = scsi_mpath_head;
 
 found:
+	if (tpgs & TPGS_MODE_IMPLICIT) {
+		ret = scsi_mpath_alua_init(sdev);
+		if (ret)
+			goto out_put_head;
+	} else {
+		sdev->scsi_mpath_dev->alua_state = SCSI_ACCESS_STATE_OPTIMAL;
+	}
+
 	sdev->scsi_mpath_dev->index = ida_alloc(&scsi_mpath_head->ida, GFP_KERNEL);
 	if (sdev->scsi_mpath_dev->index < 0) {
 		ret = sdev->scsi_mpath_dev->index;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 2011447f482d6..7c7ee2fb7def7 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -38,6 +38,9 @@ struct scsi_mpath_device {
 	int			index;
 	atomic_t		nr_active;
 	struct scsi_mpath_head	*scsi_mpath_head;
+	int			alua_state;
+	int			alua_pref;
+	int			alua_valid_states;
 
 	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
 };
-- 
2.43.5

