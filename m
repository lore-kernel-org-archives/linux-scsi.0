Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC62346E71;
	Fri,  3 Apr 2026 01:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775180907; cv=fail; b=AeuN3Vdz3l+/gwWOdbOlGR/N2IvoKXeREFCIiUZQ5QT13RcmQKPgLUxI4oihA/VjFBwoNfG50QWB8VfMKVRcMFdFyxTt9WVMfu7DXzienkeh8WBPlupkQh5P0nwjeBtEwDfbiYWJjc5K2Z9hATD8gYfwrdjRHANcVj30v49z9Rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775180907; c=relaxed/simple;
	bh=jxOsLW0pbTBPF13vz3Bz/6aD5WEJNuSgyN/10o8nXSQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=inUUg60Dfc/OdxIZ8Ejuda0XqwaGDUoU3LYNzc0rz6zv55iomJMF1mzEpfgttEbNRNq6fJ9oihSSH/dYhvowgq8/8K9ttf8HRgfz6S+Ns2XPR0VbK9GTjufOU+4ybTp7grisWbQzDvtOtUK+a5Yv1IJ+CGqt7hf8rM4r+FL7bSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vvwabl2e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Yf2xfMDq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vvwabl2e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Yf2xfMDq"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6331BPCV2270014;
	Fri, 3 Apr 2026 01:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ExpiihG+sDQqRRZj0r
	BNGbRtFNZinJ0QNR+8w3rfMso=; b=Vvwabl2e/GAQT5R0zQLTwJwBJleJ/AWDcz
	pcNCDkYW86vlHw01NgCKiBjX6ZK99LE+OgjobIOjsRXxFM4K4+KWvCuqj3LRKLuX
	32voxyzEMG1YCiAOCBX4KES1iEp+QS5y8d+8HTZmTvYx7qEACsMWVv8JYFwzLkyv
	VddQxS/zredV5hGbzQy11yDtALnjN/g2rHzy+Y16bRpFMZmIe13yc68T9hvb6jam
	DjcBE5tp850XtgJ+sSPOO5ZR4eejKdRpo5z0gLwc3amN2BIMVkOM7N2HkN63bCqT
	CvlyXevDk/b/roullNTwH0nTCOrtTJwTEo94e9KU7WLjN372oXaw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d67hqhfas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:47:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6330ABiw008531;
	Fri, 3 Apr 2026 01:47:16 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010004.outbound.protection.outlook.com [52.101.61.4])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ekqhpy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 01:47:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgI/jAjpEU480kMpgGaqG+ruIPJxaq6E0O0+cU1px+QNJznEENEKB5aWPTmMf63GwJu3qaQ0gYbnNuD8GRv1QWmEfnL2L9dev1utvusfl20j208m29vKKQlCg3K4HYQlLuDya1F6QK6SQBt5acm3q7QHV0xW6PZXqUNasB5ztfO5mJxtMvHSzEaNSWFgUEsOY/M5Y4mQmltF/3If/lhjaq7InZTmTzOMdgPA5hONduHWG9k1vPUfHa5Lys9XrjVkP5wYeWMocizG1VfFx+ZvHXUN0PozreAU9uRSdABOOeqIsXd6xq7G9OKHTUj1xVqUqRSa+VKoZB1SQYb018lpnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ExpiihG+sDQqRRZj0rBNGbRtFNZinJ0QNR+8w3rfMso=;
 b=eMDjhEaeDxbSFyYdv7W62uSjbHp5QGsDkLagCH7XPRb8IqCe1yFUYxLHK7UmFZQpdWEHjD9/dGpEuVBpOePWHE2ZIY1AlTkUNuqW2MYhY2APm8mQrZHji+Yu2wP2scAH0FSl8hI55lU6XRdyET7MoZFRuCjVceYwk2KiRPpaR++dSAjdSuBEW67prag/bi66km+b0sve36uoz+EXcM4t4MWmSVMYCWvxmJpSu1JfdffjxAQIkUdWWYbsPIBr4Yt9RqAST+cEtpUsaVnuKuLpzvP0nsXsG5NcnXHvjnn5f9A8w3Bk+kp76Jo0K/EgTCQfKtAtv3QisFq4KSfdgtA8nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExpiihG+sDQqRRZj0rBNGbRtFNZinJ0QNR+8w3rfMso=;
 b=Yf2xfMDqRq4y4QKgNCOhClarNN1x7tVfKGTd+2INYxFscdH/6an+qffWaXoXP6z7FXp5pWEkEDGU2ZE6QkWvRlJA61EuWCwP63MnWT4P7AUXNZlx1bt6Zm/D2oFVkFOCSOzryEwBAk/i5xrSX0QEPHhyCJB+mLfy7vJsi52+Xow=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5169.namprd10.prod.outlook.com (2603:10b6:208:331::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 01:47:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9769.018; Fri, 3 Apr 2026
 01:47:12 +0000
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: <axboe@kernel.dk>, <kbusch@kernel.org>, <hch@lst.de>, <sagi@grimberg.me>,
        <mst@redhat.com>, <aacraid@microsemi.com>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <liyihang9@h-partners.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <shivasharan.srikanteshwara@broadcom.com>,
        <chandrakanth.patil@broadcom.com>, <sathya.prakash@broadcom.com>,
        <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>, <ranjan.kumar@broadcom.com>,
        <jinpu.wang@cloud.ionos.com>, <tglx@kernel.org>, <mingo@redhat.com>,
        <peterz@infradead.org>, <juri.lelli@redhat.com>,
        <vincent.guittot@linaro.org>, <akpm@linux-foundation.org>,
        <maz@kernel.org>, <ruanjinjie@huawei.com>, <bigeasy@linutronix.de>,
        <yphbchou0911@gmail.com>, <wagi@kernel.org>, <frederic@kernel.org>,
        <longman@redhat.com>, <chenridong@huawei.com>, <hare@suse.de>,
        <kch@nvidia.com>, <ming.lei@redhat.com>, <steve@abita.co>,
        <sean@ashe.io>, <chjohnst@gmail.com>, <neelx@suse.com>,
        <mproche@gmail.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
        <linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <megaraidlinux.pdl@broadcom.com>, <mpi3mr-linuxdrv.pdl@broadcom.com>,
        <MPT-FusionLinux.pdl@broadcom.com>
Subject: Re: [PATCH v10 08/13] virtio: blk/scsi: use block layer helpers to
 constrain queue affinity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260401222312.772334-9-atomlin@atomlin.com> (Aaron Tomlin's
	message of "Wed, 1 Apr 2026 18:23:07 -0400")
Organization: Oracle Corporation
Message-ID: <yq1y0j424tm.fsf@ca-mkp.ca.oracle.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
	<20260401222312.772334-9-atomlin@atomlin.com>
Date: Thu, 02 Apr 2026 21:47:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:23a::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: b47d409e-0ab5-44cb-7907-08de9122ed1c
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 5oj5UHDrgIk5ATwAPbPCgP8HEuPLRjQlE0QZyQmHzjXlIAMyQLs8QMz/dR2/PpoMLPaNQjHt/th2OPNrb9sbSiq2JhTx/zn+YnJ7mHqHZVMP6WvwwP3FtJjOzrSO/0kGi9kC/VuHdNN4jjUbA6BEpuBE11QpIIMsso3aVWT638PDa98oURMRuknt1BP5idBuX4gkh9hUDTWdRSfLuBgEDvWt+ETQLVNgxy16YlkJBBf8UNi3xPfFEzUx6nQsNYvLzT+REFPvD4Fvybm+sSAEnb2YDinQicOx+hYwgXuRxeFDjy1Ko4EnsFWAVWVKbYc0TOZFLbOH+E9Irl9y2G2qCJFgGXH0coZuJOvt5+tg4WBUATQgF6ewrlRO0diEJQdlv2A0KuxT4YeLHf8ulO9Ho8Bq7sqObo1ILfnUFDpCVqVegI++GkO1IEcF+N2St2Yy6S2C6I2BjdbPJQCieAdkxX3vaxpMIzGFR7qrASsNr1mGBEvVYasNEMCNUYoVLGuhYDbQRNyR/CnHzG7Y1UTgmmeutsaWASN+UpX8uacZgQcpl4d3BRQWqqOWR90PMR5Ezrqtub/bYE8EDQ4+g2JmQrzxFzFnDanhcyOT28dsnrSQyqQOm0GZYgcf4PpZZOmRD5aw7H7LBz67r+qZ76vc0liV3BsfSjRFvkS9GN3jUrshYkJjLD/4EcVG10mX6BTjeD+b/46Eup3iFqOoh5Ykrfiygd0sV/7reDyFWpyBKq8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?vcR9K+z1sLyAIO5pcGMWWmRFT47rAzCsm1npUkiC2y4ZnYPCi8qFcDOFb6qY?=
 =?us-ascii?Q?b/tea0f2UjXidEWZ6rGgHj2Gdql1YmpHC3Q+6w0iD08t5KNFzQ8TnPYl05O9?=
 =?us-ascii?Q?qJ5aLlAI3R8/695tmsVDESYoGThjofHz1TITUOjhbrMDkvLRvew+CTMICYzc?=
 =?us-ascii?Q?KT/qoF9AxfLcchqHc+NwQ3G9u33i5t4LzEMluRLBp3SGW8sZ+VgE9fXSZDgU?=
 =?us-ascii?Q?LeOMXItybZ5LFLO3Ob4n2TpSV//pQwdyQWGhnBkbeKWDc+bfE8C7pqDWFryq?=
 =?us-ascii?Q?WBv9V63F+eDiJgjRvghN9D9HTIlXDvHSa00x82s6NtcvcoMABVhPFiUmStt6?=
 =?us-ascii?Q?YIdT669zmuxxHnMExuTIN51HjGfg0aD2PiXRnfDkAk1u12IvC9gXEukkC94g?=
 =?us-ascii?Q?UMmtOLv9XIa/mRHUTGNByzO9dWN2SUQ3GC54E2Gl9yFIInAFFKDEfkn13xo6?=
 =?us-ascii?Q?3XuYDSNH5k5be1ZuVSR9q53vYD0i1i3XkAtzWAzIgBpcsIL0FOvEUr7GY3h6?=
 =?us-ascii?Q?Lk+eToS286aVnV4fFKe1NuCiD3pgRg2OBoYo6uHfP2AnoWrEbJfpWqcRvsW4?=
 =?us-ascii?Q?yPEW4qaLSDtMxc/GQ9qgn/i2Fgrg4ffpzMojC4JCSyiCvL/25EHxh750QoRm?=
 =?us-ascii?Q?Qa7oHl+nGK+kqHeAKRp/iz3Nh8BmTrPuks2OcrKe8HeyVjir396XUjtxYOla?=
 =?us-ascii?Q?njfxRRZHuMXmHw2wbjsw+h1828sWAu0W/h5GVYfAMPc/U2ZmzF96zdKw/onI?=
 =?us-ascii?Q?DUOM9iQqj2nME5MN6TIG0m/oBMHnN5HdPXvr1SIv9Ng8t3OHMUdF8mHIlknS?=
 =?us-ascii?Q?5qS9VMYHHoIsnmPOjRr11c1aqgNw6K1gDyouF+vZh3b1itKOdKetlwDJ4s3Q?=
 =?us-ascii?Q?IqcIsCURdYMAEqgWToP5QRrhBYlsNVS66FAuUsDt1EMoMLjLaurdK9ElBX0v?=
 =?us-ascii?Q?0VO8ucOa7w/xHkTrFGVu790IfGvZ7wsOltTt9/jt/WH0+TBfgi5ruz3Ijk8I?=
 =?us-ascii?Q?oSgm1rn1Puu7TxRUc+PeXUuQUZs41TDsRahGfNbNKYI7KC1/ahgfNhLXqa5P?=
 =?us-ascii?Q?FIH88EL6KRYghAHrFPsrWyp+9ssN/s08wG+DvH8BCjGmDi5alr+FB4FouhwR?=
 =?us-ascii?Q?IYA30heR17J2b+wzCOqqGwEw2DYrutQbuvKzB6DKKUaQCIPB6HVFKedDEKQT?=
 =?us-ascii?Q?hZM8udx4AqOrn3rGvM5tSstJEFD5CqxktJplExqmrugzBBl87Te+ruL2t52h?=
 =?us-ascii?Q?bHG+F0m2Dj+59wzEzV2BC8tKSZChPikGt1uARXJQL2aEdHyxaCWPPOIvjZxn?=
 =?us-ascii?Q?sXHR/w5v86j29lLhooxv7eh+aTaJVLLKh5Yy1jj8PO37DO50FnHjr73yOMPn?=
 =?us-ascii?Q?3l0pt8o8Wn5vla6mWZF/xej3G9BOrFBS2TtCSJKk8ZyWYoaJ/Gr6cFpdmrn5?=
 =?us-ascii?Q?WhFS7KGNEEdO2P5a9GoZmuKZLn7+2+gcEnNx1nXKB4A8SQCpAYc1NqpXFPp7?=
 =?us-ascii?Q?sIthxNBIA++xcrIyAYtkH6wmXKjOLGJmj7xTDI3sEqVio9ae9xOSLR/5SPuS?=
 =?us-ascii?Q?qDKuj/PIFF+cSwl5/realf8cBvDV5+lK/BBUhmDpLEhgcyCycHmEUkUQHjzB?=
 =?us-ascii?Q?kHqa+fL+G/pVGK32uyoXwvZuHBVco6nceLZ31SBMiuZ1ftJHEOvVVpTYBdZF?=
 =?us-ascii?Q?RJnPqdtuj5663KjQjzQgo+yNi77Gx1Lx9C0IktGQqm7XtaVESUsKAQEGV58h?=
 =?us-ascii?Q?071pO59R7UyHBv6dCa61QvXvlH1Qm24=3D?=
X-Exchange-RoutingPolicyChecked:
	T4Crwr0suNKptNrUcTpc7SsfgOtbDPgOPKvuymkru96tRiBhNGesg5pxjp6WcThP8aGc3u5U/bpx/ydnEOr5ObFdDXycajFj+Gxc7Bh2o2GxAHY231OWjtOYOoowPF7DCQsidFIAFqCmrPu6hnPwmZLd6DNHhkD2svEjnllRsvQMdrJnkenRXHpA5pTm0/ILHpo/9ESAbqg0ESAo/5sXn9Gqct5zAj/IAG8YRvawrHq4zLh5I2tQYx5+MAXpp0ZgLs0F2g7YeDzjjTGgQtvlheep5hELiSLUus3UDAsSKc766bwSix3RB1LySnEjn1zfk90o79z5uRuUeb2CJ90ayw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2paQZcuCyUPrBFjS4gz7kDR87Pq92TMZyNgfX63TPxGE5hJiEOH7By6AjM1oSlll90ot0LQwnzWd37w9LEZsV7GKnbRrEdY9lDExaWhPY0JEaa1GfqjfadsnYgAq+Q2bmBwguHNnyM9Wq3S80WNKZ4VUFgtnBJwdK/woRhNOkWgY3/DKLs5inbHLNlNv3RJCq8hboPIVzr4R0mJbWnFDNMs7w0WBYkQPU1EO7fI1/s8BX1gQ8fN/xVvu0idxbCsUQU/AUGlRimSGpt7amXws05R2stFCrmgUuli+zcDQc4CbbQRcy3duefxAnNnM/Du415xTS0lY5lxTPrI4+44VvPJLRD2rRJOU5H6c5n47BUwm5BL9d3TmHEWiM5oI0NZ7Tb23/VSWbkpJUN24zIVggMgBfNGFVHQNarmSAHVWvw2lQkCRrQFwGAxWHgrMxKifPzGNDoERUx+kK2t61+t53Ud2nB+rsUSGRTvhWDQHRBQABYhOtppfqcucoQTGD396jHARqu1W9r6hZkGkeny0+6oP6xiILTvrtEMfcXJ0FmD2/8Na9rOnBnceXmAdAcXel/B5Utqzg2R/eQIyb9BWGSvjoy5lXs318xW+uy3Iqkw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47d409e-0ab5-44cb-7907-08de9122ed1c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 01:47:12.7423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnEZa8M1lxHbtDI04bxj3QV4qncGVQRS0SZ81xNZQy0NXiKUPS6hexLK0MLHBQw0uQtbpoVV7owJ5fiMQQLwTbse8kz4JuMWqH2VzbFX918=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030014
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=69cf1c25 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=Ym7BrytTJpxj68NhldQA:9
 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12291
X-Proofpoint-ORIG-GUID: 8N_U5K2U9nCvhQXFoGpYugSt2MSNy544
X-Proofpoint-GUID: 8N_U5K2U9nCvhQXFoGpYugSt2MSNy544
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNCBTYWx0ZWRfX/0BPEdXbF6fO
 PuVhA51vxdrBGTDxUnP44ETUBCwagHCxvxumEwYglgFjOxgBUBnmBZqUOWjXYlzV9oHt172xboO
 Uvn8ByOUPq+jSeCmP1noVoLwRoYDbV+OuV/Xdt16nd4UskRknbXUck5lDZlKZdtzjqfQYnLmLI4
 rK6yzaUXQhi678+FKwSAoGhrI4K5uRjz374BF/DwhqJE3gNiNqs8h9DwpkfI2Pl9Iir3/elI7lv
 MuS6zA2ht23qP0y1VfVnt7pXjuOQH24gqHcmfAfYVM/w2U7pmAv7HIaZq7TS6PEHzVU6kJ7wt9T
 NHnVW05TOHGsGiaHK9QCSnI907mjZ5EvJ2Qy0of7138wBFqWUH6J7QoGAvl11ddGUInvfSBdZRL
 ySpnmsbt07K8XEVIjtKTtsv5wKkjjyt5MIfLzM3DpTcHyy1cV5fGLG7Z4drE2cz89rwzps64VYj
 B46iguMiQ0Cm60vfcVr6TPlFWTALEIQCFdQY6Xhc=


Aaron,

> Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
> constraints provided by the block layer. This allows the virtio
> drivers to avoid assigning interrupts to CPUs that the block layer has
> excluded (e.g., isolated CPUs).

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
