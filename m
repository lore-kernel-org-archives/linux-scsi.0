Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BFC30595B;
	Fri,  3 Apr 2026 01:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180704; cv=fail; b=r85qQ8QjH3OZR5c17CIN3omn6vgMwxcE7eCeLUvq5GRNwB34E+9grtcfnQZM/mIh0iUUeIoFfy5K/Oa/yrO/XxPFhLpHbqd7PCRmTDEOsFVeUDEHBpEVrJNlutkD11R7OMaktjV9Ls0TiD0wQCTmTouSZ1b21MPSJza+QrqUYcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180704; c=relaxed/simple;
	bh=62rh6wdH99A3WtacEKK/HciYzHgjlholrMUJTFeBLJo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=BhvXIOOVY3dORgCAVKL2Il3IJKkW0Wj5lqgRRe812BTgy8inwc9kf76l9xGeHBHW12ZfTDzzp7/6vThZPa9Xrs+D4R03uDf/NLYKnPQZQx45lV1c7Lf/YhJZYNKN4poSJnb83tAFEKhI44JJgcxLdz8VdcHo/iOS0NCgfbM1qog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ixF5y9Mz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bDwy7VJM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ixF5y9Mz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bDwy7VJM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBw8F1498964;
	Fri, 3 Apr 2026 01:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vUlkO0eY81tKfNbWqn
	/OVJ2bM9X76LPafSVoiJybTO4=; b=ixF5y9MzG5jHSNrPz0LFbdb1EnZo28EYAt
	ncSl9Jf2Vyuwc/d2dp/Sve+XAJUenspP61xWTexeNsvIw/uFHh1vVis1AZBFg847
	OwP3I2QVdDPbH0loD6D6ziYcTerSUgWwKk2e8Xqx6RJJPK2buHBAvWtXfBCfPzt2
	JH/L2c05oa3GYEaW6BFM6QnNcrHDcR75p0jyLhbKQ0ka9CqW/WSIts3ci9RnXWgU
	SzSB978wM4WBSlPjqckYNnibh06RkhchP0Yz2/dq1RmXDXEalx4ZCi+w0b35pKoh
	tltIMm+qjvgYvk4IOFTI/CgkAq81hfCKWISd8wdMIkYq/z22WJNg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65jwhfb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:43:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6330fLqH024554;
	Fri, 3 Apr 2026 01:43:30 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ede973-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:43:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YMnosOTTYiM37DlX664Jx5Ylna8GDs51MoDbb+5fyYSSKeg5H5RmiPJi201mhdv5bcjqMwe6ys6hass5klC8abKKeUBTCOND4QRYAdkD/YB2WjEUvY/vKvZmGUT/o7ppKKdxmXgko6fI6n4MvFlRRpQhlQEODRHbTEDvREMpvPohnJpuLWbbRBK6KNJ++eaF6eFIgeqlcORS85vLUqFdxjvlwCz03bPHgwL8yUV97C3VU6iRkqhIDc3WpnwHk8Ugf8mPqoC9Zfi5lVvjcPDeZxbI8Mnm7vFvMUmgAfDvPBQKj2CINqX9E6VTbmVq5S50KmRT7KzrHMOS9oIVel7itg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUlkO0eY81tKfNbWqn/OVJ2bM9X76LPafSVoiJybTO4=;
 b=daEx4wqErh/fm47N+KQb5AhvJWDyhFTp58NFuZ3Cm5mRaKsx3fBhIaaVuBt3zwR+MnOQ3TdSdQlWvnCtfwOA/wsBOxvxz3uRqVGIV6YBeftbrr3+cfoyF5WgMi19c/DwE+lNrHzz+06R6M+eGLIcoDs+9+jf8AlzBYUUaZCbzMJSbFAHWGsrxyP71j25baBNkdHx4QjSUBdUe/HVapSDNQgV+dVMBSqvxt8RdPrFBJe1yCAhGPjLQF8wQehF78JLs9HDcuvOwy4AlWDW0nwQ2LYgRJ0DYiQ6J2jY2Hj9NDN9dEhGe5IMhxjAVrZ/Xzji3wNDXwT0jGUmT5dYnFR57A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUlkO0eY81tKfNbWqn/OVJ2bM9X76LPafSVoiJybTO4=;
 b=bDwy7VJMZpFwR0DOjCkGwTHak7+of7xJkMk3gMnHGHiFCiR7eCoeGAfkZRpuPs4RnvW43Ti7jw2n57NrcsoFhJpJS8WtSRdIYt0v0+CnJuWE7hKH14fH/eaYwA7PGHo6lInToRKfk6jbJCWW3fu3JUvaxur2wUJHfV+hVmlVa8g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:43:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:43:07 +0000
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
Subject: Re: [PATCH v10 01/13] scsi: aacraid: use block layer helpers to
 calculate num of queues
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401222312.772334-2-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Wed, 1 Apr 2026 18:23:00 -0400")
Organization: Oracle Corporation
Message-ID: <yq1ldf43jl1.fsf@ca-mkp.ca.oracle.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
	<20260401222312.772334-2-atomlin@atomlin.com>
Date: Thu, 02 Apr 2026 21:43:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0020.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 5baf72e8-d685-4930-fc47-08de91225acc
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 VEJW/FcY1Bmc9eeBw8HoEh4UI0eGkZPq/ji3YU+z8NVPfEXAl2qKDi/1Ku4AKvb3DV3gi7ENy0N6AVGe4cQEoSPneElW+RbruREoCL6FaTtV2R7k4vNu/q0qz8so/Ds6iQHxXRTnSMhCqd3dlR1FUlzfp3sLdYu8NuXGgcizFk8eM6mrO72IR8Feh8eg3pfOXcG/+7sQYTqLhFnff2BVI0XFlK6+WTp8YR2OeTzNZ4jA4KgJHMI7D4lFuhTDDo7BBTXF3thom4E0ZOcDFjVKcWkbLzKEAvr0/yLV/yj1Lhyk0a2XphTrzM9I5jmYGwzx12nP6tUlyheI+sIvIlE/ToVdFTU+VqiPYzvvAh5VGfamo0A551gH7VFPz/y05wFzkC/Ur9/FymWjJSPfFL4TieT0KKBPyQGMP8dXABvqUz7bW4zpD+NtrHKvZoArZqu1PXzNglIJDM61YRGjWwQIXvrF5I0VTDHtdEOd1v6wIxqgmbSbW0RMP2KuWOgfJ1xtoSTVKPtGxb9KTJG19Ln4bJbeWP4Xf90z8enxIAbJ4+EyrPtQs1B4oSMWJmNActVveepjUcR13tK2uUqBEdskqJu8Ap31AhFmETWp5IH8e0OhSUhb0B9ie2B++mk8CXsYQLmpKfujFWognQnQBpJyRS5XTMCHgteDNKe2ypDDOz/zA8Qht5Am4vcE+FT7/ON6ibyVqhufJtVdqOWy50iIe+vLdJto11QWrcaH+ImL2lA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?UVxF1fPKNW2OpPVVj9d25XoUqw3faoyqRab9l6pUv3Fk5avpynLwbRCwOt66?=
 =?us-ascii?Q?+oU767MXJE5MPbfFtdK9ok4QjT4b5IfYhi7UBdK+EMnzDVUK9BcZWr0EXlVt?=
 =?us-ascii?Q?ogpMBy5z1f1cEyPf/GQLQv2HgUjrAg4IHY0VipKd/8ywngAINZ4T/qDoWiwP?=
 =?us-ascii?Q?cXtZJJhNkDdh4PSMNZrKHa0AV6hDmHqrgu2W2m6gmJnxlNfZhkhrqoP0xOjR?=
 =?us-ascii?Q?uhDzJ5zVGPAqBilKqh780Ui8FdZB75rw1R/kXr73AqZ9FNSYw4hVw2GWx639?=
 =?us-ascii?Q?9BiZD3esMZwdhMQVUenXy4JuP7f4yi0DRx6qwiKQcrgxP1CoFAw9JIZkt7Vo?=
 =?us-ascii?Q?gFYEDR4Xtt0i7TpPNAcFZpmq20xXJyNQT9EwRqaSiWUN6/LsG2LNKv6Uz4eR?=
 =?us-ascii?Q?qeyzO83s6FXQolWy0Blh1TLyGCg9XxG35VOQZifBjngjC+jaADzaP0V0rEQA?=
 =?us-ascii?Q?gkbOgQU5ldcPYqAP6whzCigDT1WqC4Y74sg+5nWJugfVSAlTaVJ9uPlI+Q+I?=
 =?us-ascii?Q?VfqVJZWqMMLNCZbg5+ngRSkGzXsOi6DUzt7NgtbPN84cmRgw36WUrT8wwZL+?=
 =?us-ascii?Q?HBaYbszSYZED1kLtBlgkRFI0K6qODhCoV56bEJE/vBg+uKzwTJxB5JoxZShF?=
 =?us-ascii?Q?foVOXGeA+zpOgOsPIujL6VYKHAribYIFgkZ5AYUAuNb4MgMJUzjwdokMrC2Z?=
 =?us-ascii?Q?14d09/qsQP18fgHOnyZap27r5UUa/Nm6D5rWLpmf3zPbEFpzWxHxFgAXlKg1?=
 =?us-ascii?Q?A2pfZaJW/yNnnOUUqHk/5QwK4EM0PXTiIoRYFcs5pynL90TZg1GCNXrbTKtz?=
 =?us-ascii?Q?FlMY1ZxPgEuqNQ5N/Kfxnm4Mikf+/l1CtYrLvZQIWztNe7vDzLae0e8Q3YiE?=
 =?us-ascii?Q?mdRMwfqyKXpzd5PAIr8XsAmya2vvDJFVssSWL6T/uSCG7NmGqE7+gbteLBBM?=
 =?us-ascii?Q?TBVoSaixwQMpKoG2hQxq50DaSUSgZNAfGbuhCpATTKofAr4VyXQ0Vrr8yKSx?=
 =?us-ascii?Q?eUFhvYc1v7iYFd3o+dic8Q+VP8n6HrlE7FOi30kWGUCoyrCDKfp+yGCvk4e2?=
 =?us-ascii?Q?2wjfEy5cCAMXpDGOxV+M8s/0qv9l5ze3EFJKtqf/s5PmTXWVqbE8BMRgB0OE?=
 =?us-ascii?Q?JWRFcTWwSDcDL2o70aOUXQK4JunaSVEIwnE3b3oTUnf6kOpNakRPQrORlGS8?=
 =?us-ascii?Q?LNHZDLu1B8OZSs12oOTwV2iIG3KEwn6pXO/3r3nG/lAh46uBJL4yGejNMqyT?=
 =?us-ascii?Q?JydUy/0426sV76NgnNjEAyoa09W6Xu3ANcgVDqEXVwq0VeG5+P018cJb3tfF?=
 =?us-ascii?Q?BRC93zuzK6bjqlqrLL8gTT3x8ft71NtwN/rNFHFjqLRJSDTXyYAh7orIqhyB?=
 =?us-ascii?Q?qxcg8q6TNz+IixAYhgmA7jkcS4z8vBv+1iMe5Trs8aB8IJi5DnPfUH3XmvvC?=
 =?us-ascii?Q?emXY+rpGsJzGo1mh2x+V6Ez3/HCFioTTyCHQbR3ENw4KZAgQtIBhPkaaR3Wq?=
 =?us-ascii?Q?I4Akxj822Bvo8iZmAP7U0yXyBbKdB3gaQsslS1vVJMkjQst/443H+W9+ZVWk?=
 =?us-ascii?Q?ISkZ8ld0NatjH9MJbGcL78+S3A3c0IjKLr7mw45JP2ktLS3GwKT2dehwCqXF?=
 =?us-ascii?Q?Ksmu79lF9AMtY35yiPN4pJjfKWgTWlDO8jwVjmyvKgI1P+aQGxrU4H8iI+Ub?=
 =?us-ascii?Q?9j8tijL+thGOJXhFaK5nf89rpbpmk9R4J3KVvwntepKTgYTGn3L8+2qAgi+D?=
 =?us-ascii?Q?cXm84rdsv1I9fmaETPaFPvXU4R8uztY=3D?=
X-Exchange-RoutingPolicyChecked:
	i1GJIQOhrAB8+oirJF10jqSCOBrXKfJKFBelVQsPgFTPvfjykNiDFlxsbsb6JBDA1VpJ1BF6hQUpQxj26rnwOBEhHn0JhFdt2etV62CPKfvojM5p/1FVYJxWMZEGbyj1Y3hFywQlflpdv1tgSg82/pxAlnJHMCVUzADRJZHrRH1q8GrndYMjQa7Gb1TcY7vakOz2wUs612PQvAoLn4OTmyaBbV80aUDOBC6T+rRlepCFylFYkbTX4GLCJQnJrkIlIDW8evGf52mMcifCf2UiwpxeyhM9DS21vB5apaxbP0dAqXTQRWPNyoPWv9cGtLeZakeGPYAhHei8dVe2A6+MPw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u0kS+FEOHM/7Yqu+PgusnPXHUY9n+XQhT2cudTihbyWgHHXj2VYH13NWwZ6S7e4ErhF2ys84E66Pv1mDuyaYxezVg8tXapqPdIMswOO98Qh4S9JdUFukMOXwjOW6k2EQpfCt4idG/SM+D9hcyZyPKIQHtX82QcQl5f12D3kUizBjIJhA8vWpUnShOcC49jGVBx5WjGE26xyqEuF/4IIas17zYKFno/E5A2B/xCchQTdxu4f6GdL0ffEUmbBJvEwf7EzHxeLjB0tqIu600EIEjCu9a/GTzvghcnnayBPEEFOiYprZWVoLjYk8i6BbRPSwwcQMkqNFxEBSR/9J74DdVpmtudvwHLZ9jugGKYXbQS8qGLiiYyVNVZUgQEBMYpQgHZP5VXoLxeFCqDhLedZcr6ckNNio16r51DEkE4e1VhTS8GKIrARYbBtRSTSZ9lYSELuEJIfaAKEbtNj9FPXwuqUCKQH9LDgz922boWpS0cb9RKqt4e8IXDPan/EPJdXwoqfGkfbxAD293hr3pkz2Je+b2FMhjPsWcujjXnFEn5bXEfKkvKieYLpxTWH3rV3w11zHJ8Vg/EM/HKMzphb3DxOCdoHxgNsiHd4nfCn9dTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5baf72e8-d685-4930-fc47-08de91225acc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:43:07.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xYIXNyfgHgXAoLwl0vnmSlszP6Cf9ZYSYVxRuqzhi8TFmGoN5fAvR1DGl397gEH3iepCRWTxe5UtBqOFwG4vKY/yvkaimFAlsMfn9lzwSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604030014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxMyBTYWx0ZWRfXzp+iDLBlXvth
 04Mh5TLYFH49Gwr7OmTC53qwK5NKCiQykEnwSpOatMKBhmE1D1Rj4QJfW6/XNpRTy0BhTVB9dWM
 phvx5VWC3a1bELfHJsje8GdNrngLssOy4Pc178TeNT0baQw7HHEHCN+0VJmsq8SQ6gExNd5i8fL
 Sdj+xb8ZdRXCktGzs/GfJkIjYuK9Xidq1aZqRk1+hbhqcD1+BYkZhgP5PX5U2jOgEZbP0e8KjJR
 tSNEsZBVV2seZxmmA/QbyndypZ09F+rN3srl2yxnQ1FQGQCAhizuY7Dg1g1AJVNt4ib0GW2q/g3
 22vJyY/4qrVWPv+UHf3ncWRlWYejxdlSxmomW0oRN/KRRVp2qTUNf0sEuKngbEif3exyW8sJy/G
 AhFFMWYCNtV0q/N5ZtXmaXsV+ckc32WF9M6RUIJCHDOKn4+J/J/jKYsnZIEcgpmXnNGc0lX5Mxq
 eCs9qV/Ud8Y6ebEB8pg==
X-Authority-Analysis: v=2.4 cv=CJEnnBrD c=1 sm=1 tr=0 ts=69cf1b42 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=-2TQyo_SiGlBptuIPGIA:9
 a=zgiPjhLxNE0A:10
X-Proofpoint-ORIG-GUID: El-RjfNSniK2AlpLIiVB0ptL9IuMnMre
X-Proofpoint-GUID: El-RjfNSniK2AlpLIiVB0ptL9IuMnMre


Aaron,

> The calculation of the upper limit for queues does not depend solely on
> the number of online CPUs; for example, the isolcpus kernel
> command-line option must also be considered.
>
> To account for this, the block layer provides a helper function to
> retrieve the maximum number of queues. Use it to set an appropriate
> upper queue number limit.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
