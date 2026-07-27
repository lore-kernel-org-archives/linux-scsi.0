Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266953ABD83;
	Mon, 27 Jul 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785163660; cv=fail; b=fjTC++rMTg1HXzcIjGnBRjecd5Eulj2HaDI2mtR3XWqrltLXbACRSVA8i9OQNqdczGmo/KfQzXd4gFxgsFu4Wo9Jsj+SrXDSIH7C1+uBko+LVsJ5YjOEbB8Vz7chH1gmiGK2u5mx8eC3RVO0ysq49GuWa6dnN9DpIn9Ze5CumCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785163660; c=relaxed/simple;
	bh=TRsalg3KDYMm0uQJDYBAjt3kChyNAfyFP4WwiB7UqEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aaKtoNk+NpkJ3yrGYe14mowS/BWWTG0idMsvmFT+nbxqTrx/QfY3ffH5wbCThxsfa9rirZWjXV+e4s52Wevh13EpMokj7yHdC705CdJo9RVDnLmbOTZ/9hnZA8EY/Sby3X7BJ7o1kcW8D1yv37xtB50Ed96E5V+oOVIGUAJdpOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AnJwTrZ/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UVb5WwSS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AnJwTrZ/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UVb5WwSS"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RCTG3c2355226;
	Mon, 27 Jul 2026 14:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FfRKNAbpmla3sVCFOc+tacFkIcXb5kzxJ/oZIclceOI=; b=
	AnJwTrZ/pCnlrSrqeNVohxwNigYy0lx/nj2oA101Hg0vGM9t/WMpzIvGwn2Z6m1L
	TiSJd3B6a+RxvTEAhUBiIz1Iw34pIRXPcJLTIWrnGu+Bu1nCXTxjWKpoRKtk7QEw
	+WSt4tiN3qcpbNi+iUzkdHUPChhSHJ4qPbHkWwz9A+j/9aBcLJXsQ8jDZQTkkgJo
	QNlut6UShpSRLIZpXswkuRgM64kDcGag+tX5Lv9tuMRJ4K7EKNaBm1AWYMqQdccF
	vDGX6veuYwt/1+qvnj4iUZ8cOhqrLrbv/hG0jlnuJ48EzXRNUt24DkK8TbIVrOPZ
	XnaCCGA2xKu04/DLgihUSw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr011ye6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 14:43:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66REeD9r034438;
	Mon, 27 Jul 2026 14:43:30 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011002.outbound.protection.outlook.com [40.107.208.2])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh85s255-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 14:43:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYq6S5tRQwC08khe7O9NdNXW48FrJoFVuckT5K/AH7+9TxSTKdhHLqfq/bdE6UmsMoRhLgwdYVAzt36kVInhWRvhSO9dsWbAWbPq6GZLLS8jIP6Rg0nwSOePiD7IrL+2M2kkvbZjzSe/HZ1NIQSHOBtafQr/mb4STaYaJ6mLu2ccw4hX+ET/46QxQuzEkf1jEWtIBtLodYRvL2VbTLvG+GlOmhgCZ6MCJuove2Hoi5s5gbIMpgk3i5TX9Aj0OpbW7qYdnchnIINR1eJpgHpNEyrRw6gjxPJfw6IFFMMU/pDgTBlpwZZuBgL7uhgPyXUcbHhjoRpu6LPtA8gn5tZR7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfRKNAbpmla3sVCFOc+tacFkIcXb5kzxJ/oZIclceOI=;
 b=TAoLc+kkmbRql80MVF0LbIPzKMAgB7JUn4OvLbJIKplaYKCaKwxgfQWaqhNSYzddlP7Zj3U0df8PNvxuYMS7fqoHVZS/iwBsOiDXXD69AmaVPS1uRxs02Qu6BwG+Ju5xqpxQmyGsCbtxY6Cf8uI7BG5XSeDXIsIi8OhTXgONBFqfQyLnlMGEuEedymzBpGbt4o0i9DeLxXc5bTvs2EPFAAoaOvqA5rTJwjlaO91M/j83Pjgv02BAxJNfi15H3Y/n4jUuplPxO17JZXgrCFy0L5J7t6wh8os/x1fxFX6XS4wGDwfta6+QvSVOBYEbPEF7EfZBFG083ppUUOnktuStWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfRKNAbpmla3sVCFOc+tacFkIcXb5kzxJ/oZIclceOI=;
 b=UVb5WwSSDF0kE4i2acnO/gitNOURTzaJks0AYdoiWf3CpH2Hx3v1q2Jzb0rp2Exrd/mIgY9f3Pk/o2KgmAHFcHJ4SaL73EAE0R2SiAPSTNjF9cufk0XzFv9o+QCQG4f4DrW3eYlngoEWbJ85tOcWjHz+VbpCrOoa3Cs9ic1Wg4Y=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DM4PR10MB6087.namprd10.prod.outlook.com (2603:10b6:8:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 14:43:25 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:43:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 20/27] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Mon, 27 Jul 2026 14:42:27 +0000
Message-ID: <20260727144234.3802948-21-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727144234.3802948-1-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DM4PR10MB6087:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d830501-0385-487b-028b-08deebed6a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|10067099003|10063799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cYs8CdRMZjbjMvPacRyCdpBolBuYnBUrhsDcOh2y4BmkNCC9GQhEXnmZy+RtOQGF+Go/XpYT/xbs/ESXXCquoSjtwEbfnPp1IhZuKi5pNnfovE+WuBzS3caKz7ANSNTX8+y3g7uVxGFyQTeuk8vuAnBp+9VL4uULF2Xq5ZdJQmzMBsCwVPjdKA3Y9fpF4iWdcw18rl4RDMD8p2ANm1tIPjx74uFgStEq9rRP+zN4h/XTYuew87W+zn02MWKiYW4cwPI0MkdvwmnGZMWtE3dKO0y/46Fvu2EqDaChCHODuhhvfg6vg8Z4FkuGFow8cWoqCnlizLFWBxMEJXWJ+rSL9OKIKd0m8V+QCbJsqUOcx7LrT1yCBHPvgw8Ges3vvt8lkXgbqWY4YtEk4WuBZXmqs0oPxp+Lblnl/KIHUwNA1TMBzr9AtgWtiDEVcsBrD8AwH9J8l5KdcPmy0YoV+S+Flk0ej3rkMWJEn/D8pK5cO66MN6WcRAOtuN+Tx+HWysFfg1UwHOOyl9He4lMzKHH4oMSY8s8Xbt+4STYLcv/y1Mnoel7ok7FHysThe100Ddqbhkjcq+EvCDSPFo1fFH5jTOSHlB9oDl4HCUSYrSH0w5W2d+NYgA83CdFVR9Rlb5K+VwQMZty/9c8cYYTfpa1Hugk+cGGOjXTZqkMU8tK4faU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(10067099003)(10063799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UyZzBd9DFG02ek2cOMe9oTip/pieey1jnwgXNBCr9Ze4JItZ2FYl9sh1LgAL?=
 =?us-ascii?Q?kSVDZnQNHNxVXUDA/TaRbZjoj+unIt3mOxY/dBdjBkHxanj1Zux9wrsUbDcS?=
 =?us-ascii?Q?GNXydLW/HIA4puii1Yp2LhRgABsGJpTbvaBzMWcNsgqKQ7ySd3+JONv32Ntb?=
 =?us-ascii?Q?9cSL+cnx0KwIxYnPyPr1XwfKcgHibwqvoye/2O7AHWICNRkohkZgHwF8yjG/?=
 =?us-ascii?Q?QvkTDKV1WazrDgsz0miX+t+D00CGwRFW0Km3JDesteu1yVZco+BJsnfwikaN?=
 =?us-ascii?Q?0fa0eoCqWlabcxBcWamkx1qIN2YiKsYgpZ6smULODAS1gYuUMTp3VsgF9QMC?=
 =?us-ascii?Q?P3HRnKAOmVaS86p+Y1LCJ3PU+fgClRA6rXZf51nzm6s5p4Jw/42UQRTXU9ZE?=
 =?us-ascii?Q?URL6AHC3aE/u9/myvTjzloa3eiu4M8/oKBYwv01R4s1ZdOUeVkImzu9CqzFo?=
 =?us-ascii?Q?o8JmlbQnnswry/+0WBlpkSzYeFGn2Yjv2Jr8USxN04dbEAbzYZ2OIEITOcl2?=
 =?us-ascii?Q?IkCoV8FGb1JdOWWEcahwg4LxqNc/c1thWQUkmFGcLzYVWJuEyi+SZ7Ikirpk?=
 =?us-ascii?Q?5HVsZ3ieEDivXBjQRAL2c6GhOnKffwOOGR8XgC0JnQ6suHv5rUWG1HP4R5ds?=
 =?us-ascii?Q?fZwiUnG0lTah9saSIPA8E0ci41zuRnZ8rcFQNBKikbwgM7EeFrx1BpRSF2AD?=
 =?us-ascii?Q?BQyiUZ/ph6uNQ6ZHrfjd472GViUe/Tbm4tSUuzm4b6lRUMe79F8rTc114bXX?=
 =?us-ascii?Q?SuIm0K1Sw+A+JxzcgjVKB+y5hDnZMvSy96ThEkLFewNV6IT8nwboMLLvroMN?=
 =?us-ascii?Q?DZ3iKa1suFe8z75yGzbrPB3eg+M3ZjSGFH54aBTNkAWLcd8qlH3//IAW1nOY?=
 =?us-ascii?Q?pV8UwSatgOar6sWUkKMRJO3sOKsyC5FAVRTYYQ6aqp75IyLWNA0lTTRHxOf2?=
 =?us-ascii?Q?WUyjibDU9ahla0PE96CeKoJ/oy5X4Wyl7vG3Rc5Wf+8JIQqaRn8j8C5+zOT9?=
 =?us-ascii?Q?XY/LW9ASsk+N65VDzPFeaiojToFdapb8+WmtGIt38ZsUtDDbbyqFVcdsZMZM?=
 =?us-ascii?Q?m3/PUK0EBSkRBQs68Zz5TEW2BwU5yD71bsVZjrPG99G1rERUocvV3sZv0dBI?=
 =?us-ascii?Q?XyphJgfPZDu6MXH54LSpc8HIJYA2PDiSHf8Kpgk1C5zkZNhF5T+9PvZ8ebbE?=
 =?us-ascii?Q?gI1RJhK7opSAAVN10okBO+iHNrxMf+lPNTJ0XOTEy/I9TplSn9p5fJ/MB/iA?=
 =?us-ascii?Q?R0ulo2yCXNuPCFSFFlxITao8nq4UNbTogLMUKwE4ATPpTUY67kXI/N0ju6JT?=
 =?us-ascii?Q?TJ0B3HZaCYkKgOTnuWHWlQG6jXHaQ058FWlR2mpnRjbqXZIBoiT+q11vFwPO?=
 =?us-ascii?Q?NpovILKyRh9fZQDFkPin4UrHVIsT4UW5I2M4k8ShQ91zgHh7bTSsDo4Py9D+?=
 =?us-ascii?Q?WvOH6eJ+Nm/SPVPDQdnK7NnBxDT6n7Slt5/Uwm9dq/KB2MirXWJF4CsoiNW2?=
 =?us-ascii?Q?L9hvgXr5gt3S0Lf7whby15YLD6pCPkt7JvOjF9r8e1ZJCGRzXmx+F6zK3Alm?=
 =?us-ascii?Q?OB9lc6ZpcFuVBz33WRnbdleLPr2pOh8028y4Uo9ND+Q0AEyVLjPBWYOmHM04?=
 =?us-ascii?Q?S4PQcUNcTdbBNrDHRvPzKA7Sx9pqN/6oJGs4HUMVa1eqiq4P8uvB0EI2wWbW?=
 =?us-ascii?Q?BTvGmdDJZaovBnKj5XLAUoj8Gk2mNnXI1lCUPinK4gGWc37Dy14Wx6mIVLhi?=
 =?us-ascii?Q?tDR0gfADCiLeQRvkC4C03l6s1a6QY78=3D?=
X-Exchange-RoutingPolicyChecked:
	Zler+0HysdSsoIJofdnGwUlFezdxS6aqj+s7sGyLL1XXuw1nPidNto+fzG00GWdebhjNuwMbGAxFrwtHTd8Yth8UEPqctiLEPeLCT/Nl1yYIOjZWwYkfCEybyLUzfmizBUE/zJ8qWjshV5u1cQRC5GS0fQu+DQKsYXNOg4fMIztaPQnyd4hSiyjMQy12r8ABo17mT4HoCRa7TzEbnbqiUqaBwo4XngyjNNiqvoOYGv0oOVLXW3zJGQLk6O/6vwf1FFFPq6c/YGxI3640c7eQqkB6NmSgD52VeIyFsfX3FKOryUMKEn2xYdX4/gX51pS6EVrX2CmOvQTWX82wYDy7kA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9UsaRg3LM5pVroEEW4z4t5bybSYsYAoS2MWBsKb5GeI+yWoHSKKkuN1c+ZNWAz26ZFYT5TwnsHDxIleGiEFRj6kjhT2x3i4WJ0lLCgC1kPntU/PUubqWqFs0H567mE/yJsF1yEHuD26tyz6JQ/b8xSCd1ZEFqbYFje4tfhw+TY1eXhrS9YrEFwNBgYWll4dhrY12TZVMmuV4kYVnW3VJlht3F5xtw67ISmDe2WLgSI0q5tplqhhDaGBEUpKqBAA97KxgJImRiEg54SNtqO2DeXtNTKXtuiXQO3y9mwtPgmWYDcz56scIBTS+9rR90w1C071VlUUTY6s+7i/5+/5rCRS2ACUtfPjBTwT9BPh5yHL4K3d5Cw3M4m+JoDlawb9jsm8/aYdImu421fxtBIQL6NerI0jl2KOyVF0SmZlegu8wQx8AbJmZrXRVNgS4nz0A9hMO6ehXVLSansMlWD9FosTQyLPf3f8/c4hYn2vfdyFtlFZxKlQ2Kxm3LNNkZ4TyAQWghQdEVdW6uhI+3Ec+HCjX9dR+IWiThquxTPNhzjaopKTA779fu1XIAJ46AQl85wV3zr+LNTbiPu6VuoKxB6U6olUKolguCveHgcWieAs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d830501-0385-487b-028b-08deebed6a07
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:43:25.4820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9cI49jw9tOYDdxkBbZVTgKT8qma9qum+yqVbibzaEMr886dzFwP4Yq8Z5q7Q8g938nQqqBcc+MdwEAkPcuBaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607270139
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfXwy1cNtiD9BAF
 xgX7KQT1nVi9Om+584UJ+UQN5fDoTGLSFOnnkoEwRLWRZCe02wwgUFYr9MBdV5jWbzlrbLC5v9M
 GewfQWYMsxiRWb1//1JzR1bpHK3+vCn6tBGIiWWM2jMz/BotKuEf
X-Proofpoint-GUID: jQnF6qvxgEdXuL_9njEAaERxjs064E4L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzOCBTYWx0ZWRfX1VgpDiJLMlR1
 9NBgvMZNRyNiHtEDqB/22/mN/e1+OBLEE1UJg4uBSKe2n0Ez6nkmb6ceJ3ckJdlrSw6zLATFlAh
 3ScpEvHGeiXm5hdaEJlFldpXj5F+OA/QyzRm6AT870lHU4Qtr/PhVPujMQCNxjo1BFhfkDMbCWh
 zXkP0HUNvlOAriUESEnV2QFuXP9obhs8KyOhAX3l0TU9wq31L84OZ9XQnHD2MqPmleoLSy2Vs+I
 49TeX2ntZVd3/0XxSGEkmWweeRUsEB/CStzh3op8XY3HC9AeAQSW+MsBL8Z3fCSQ2C9ubYrLWZr
 AdynGdYakoi3/j6Kg1HF87A3CXY1vvm0SdANqis94EEl+6dKS1SZDsjuKjGYl0jLihG9fkktZC5
 6P57ydzgIbYjY6h6xOebz3UAL1rwc8Ngy0XfxZQLoSF2Al/K29dHexNk3RRgZ4dM06+6w642aKz
 8lgHQBe83FTe1PLFk5g==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a676e92 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=-3jN5J4PbOmX-KBf5wsA:9
X-Proofpoint-ORIG-GUID: jQnF6qvxgEdXuL_9njEAaERxjs064E4L

From: John Garry <john.garry@linux.dev>

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c       |  8 ++++-
 drivers/scsi/scsi_multipath.c | 62 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  9 ++++-
 include/scsi/scsi_host.h      |  4 +++
 include/scsi/scsi_multipath.h | 11 +++++++
 5 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41d201b7e7def..cdcef98e56eac 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	if (blk_update_request(req, error, bytes))
+	if (is_mpath_request(req)) {
+		if (scsi_mpath_end_request(req, error, bytes))
+			return true;
+	} else if (blk_update_request(req, error, bytes))
 		return true;
 
 	if (q->limits.features & BLK_FEAT_ADD_RANDOM)
@@ -1917,6 +1920,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index d79e1b7b90051..eae5864ce5826 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -555,6 +555,68 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct bio *clone = req->bio, *master;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (blk_rq_is_passthrough(req) || !blk_queue_io_stat(disk->queue) ||
+	    (scmd->flags & SCMD_MPATH_IO_STATS) || !clone)
+		return;
+
+	master = clone->bi_private;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
+				jiffies);
+	scmd->start_bytes = blk_rq_bytes(req);
+}
+
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+				unsigned int nr_bytes)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct block_device *bi_bdev = NULL;
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS) {
+		struct bio *clone = req->bio, *master = clone->bi_private;
+
+		bi_bdev = master->bi_bdev;
+	}
+
+	if (blk_update_request(req, error, nr_bytes))
+		return true;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return false;
+	bdev_end_io_acct(bi_bdev, req_op(req),
+			 scmd->start_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+
+	return false;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db5..52227e2cd9749 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | \
+				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -139,6 +142,10 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	unsigned int		start_bytes;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4b..cf4fff3ea1a8e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -753,6 +753,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index cc77e63c43da3..c3398e9f03f16 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -56,6 +56,9 @@ int scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_start_request(struct request *req);
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -98,6 +101,14 @@ static inline
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes)
+{
+	return false;
+}
 static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
 {
 }
-- 
2.43.7

