Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A02C282ED;
	Thu, 13 Feb 2025 03:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415637; cv=fail; b=Mv+eZ6+Y+HCNyGEV4xXlZ8gp12uX0pBH29OzUXPgB0tvzgj/XHnC3yjS/eEi7+NXxf74zfuSYI3hPS+vuh6x4cZ48QgjFIy818RPjuT6Q9N6aX65JBgubPoyxz2rRkgjtq0ndR1b0AjSWnnqAl5VV+N/4XzXoCpF4pBDBqiGZOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415637; c=relaxed/simple;
	bh=i/zbUmloG7bHNWcV9LwLTBMx7ihanQ6vOa0PHwHy6tE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bIbg8Qm6H+EdjZ3TWDlIBOm4hT4Ozj6OI140nVQwQ9O6AJav54IPq/HBevYiO1l9wEDJjS72Z+XbODcvZlOIpiKbaJCrVEJX1w5tZbiJBqyv+G6jRfc+e/g43Py89+Sitdf1ZrBNXTN4HZOgEuQf0Qnh6mp/jkumtifzaIsSKAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N/I3hpYt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xaQjKZT8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N/I3hpYt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xaQjKZT8"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1ph1R006624;
	Thu, 13 Feb 2025 03:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=OM9kzpcWF/p2sOPSlw
	emIGUw2ethgI8yUK2xG20Sfnk=; b=N/I3hpYtPej4Fcu8xEhPaK2lknu/L2ayju
	tLZnJu6iHac6Lx3Mgdmpv3mK2BiXfSaqJIXfjY3Z/6dj1wlCSkbbKamXuxLpHsqd
	HOtO4yNbFH+r+bmajjSWqm3fppsbb7t3dO01jr4hiUsi0mMXr8EB206Obf0I/KXF
	ZuC7xTZ8BZ0FExS9DCUEPrAeNVfsVFivS05EQ4vM5RkCsuv778hN5RU0iQ5bh1vo
	fwgAb44ppUIzuDbMRjHUSlNa8zCvRd4i2F5Qv8VD9nb1y4fu7FhxWSfaLBq1fb58
	dPpnLQ1fw3422ocHdY7xUS93r9REQONLA1xCxAizwUCakod7kbfA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq8vvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:00:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D0UQ7o012644;
	Thu, 13 Feb 2025 03:00:29 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb498d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:00:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cetW/j7e0GtdmzPnv8TjJJ2TNls2TCWYs9lI5n6wLfn0wFrfIUIRfzT+gXznW83vWVcXb8uGocR2IoscIT8DLa0D+b8YtXBcsNQqo2h7RTiq567KvLiFcVkT6BmfA1MVJ+31k5wxtNSEO8TJzCdFjNPCppYwQqL8LSOLag/NFiwwdJJRwDUBxDNd80FGoh94JrOoWC+ZRE5bKGJ3/pxJtr6kiTy3QgD4vf6FMN0QUZmOAKkl154UMVRmYk/3qf0hsZREYFKXt74IJuaQwMxqMAGXc3lWN8DZwlgzFgao8gzZi7ARK1gwX2MEWP9kfwQspLiCqKlLtM6gvm6phFFe2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OM9kzpcWF/p2sOPSlwemIGUw2ethgI8yUK2xG20Sfnk=;
 b=RtyL5HaDX78ivIIrK79KsYmBpXUzicq7u6/zsLwCzDAHfvDndeAt+Z0/XBtC5JGDnga4Dn7+7RddwuBgZO4efyTx+WCppxguM+0RC8VgbCG183GIQImHlE3QkeWn0nf7Kue6cjPFi1TC4I29r/oKSpwMcOhDdIk039V/qrS5NX7BFfJx1OK+qkUZ9TLFU8w3tQsWpQBj88lQwYnsgy6yvrB1u19uEZWT/AB5v706WaDaKk12z4kZbE8an+PpHNz/B/F8M61890F/18nzNyLdonDnECwKfggnRkEpc4l2B5MptDC3QO747Ikpq5i0DWwffbR1RHV02PjlFWsiazCmUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OM9kzpcWF/p2sOPSlwemIGUw2ethgI8yUK2xG20Sfnk=;
 b=xaQjKZT8DNiiC8RTAtsq88sVfLCWJroQ3AxqNs2FcPR5izLb16nyk74mX0yIkXctMu4ELEhlxohWadeWzMrqkPK9DXLXoh/BNXj16Czz4l+eq37AcC7HHLU49ZllxFrQtvvTTxK35834s5LGk4hEVNi8sWQMId5tQBOX2wI3+0Y=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH0PR10MB4940.namprd10.prod.outlook.com (2603:10b6:610:c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 03:00:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:00:27 +0000
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpi3mr: Fix spelling mistake "skiping" ->
 "skipping"
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250205091119.715630-1-colin.i.king@gmail.com> (Colin Ian
	King's message of "Wed, 5 Feb 2025 09:11:18 +0000")
Organization: Oracle Corporation
Message-ID: <yq1bjv6wnun.fsf@ca-mkp.ca.oracle.com>
References: <20250205091119.715630-1-colin.i.king@gmail.com>
Date: Wed, 12 Feb 2025 22:00:22 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH0PR10MB4940:EE_
X-MS-Office365-Filtering-Correlation-Id: b01a2d63-d481-44e6-788c-08dd4bda91a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IJq/k8v+23WFxVimSDoRQELhQzOwDKvsLUItnmNzTDK/eRCCzeMaANPzgjaP?=
 =?us-ascii?Q?3ISX4NglXD8Gfxu3Pv5WMiB3XDsY5J36MSJDQO9uf3K3h57OjhZ9e+zMymCV?=
 =?us-ascii?Q?3vf1Nzas2LXRrAiFfC9IzWxUhh65HVKrPAOItRNrTUdp+WIKhOiYRJHq7VqE?=
 =?us-ascii?Q?ab6+uyXk392/te8ztucc2kxvae7ASioa1n/5vpPClqb+lEgd7b6mPVl4B44U?=
 =?us-ascii?Q?tXbDEQpdIyEQjgLx+H7DWpPEyzAnVW7EeVDz/kQsIyf04d5g9tpMWKkGjKaD?=
 =?us-ascii?Q?hkYtWIM+3NXZccMCPQ59R9dZPM57ury4clV3IfYr/8PeSFyQZBRzSSoX9Hjn?=
 =?us-ascii?Q?2F6wqDph1x9XwMVsgqUjliZLXw96+bHtVOwPXUs+dxpqhSfzuVAW63dAAA0d?=
 =?us-ascii?Q?X46B7anMEuVjIce9Geig8ABnYvF0kixaj0Dd0OALPUQpn6+fBy1ViCoFCXDi?=
 =?us-ascii?Q?kBvvv2AdFAIcaq9JDVRVefyUOzhqXgfhN5/pQmNDJJub5q+fsfebyPYNr8Ex?=
 =?us-ascii?Q?BL9IaQHs34VNrdDnV+VlCO0TvOtADCmTWMTtbqBG83dG3TIPGEq8cAUx2am6?=
 =?us-ascii?Q?NO9cL4LH7bxPO/AU49gAzVWlKE5JX0aVFa8Sh3YwvMnKa5jx3w0IBPHOmOGC?=
 =?us-ascii?Q?/zPUZeyTIWaJ4DZK2RMVKQv3Vr199PJgZZKiwVI9uekIVqBVzgJyLQ9wmmeC?=
 =?us-ascii?Q?fO5xnS55QbQkacI4pzPye8olBCtCJvusBE0o1dGzH0jLsLzejvfwqA3BfZRd?=
 =?us-ascii?Q?J4gtqovThrHSkVJoaNMG+QvD/rTYjTxkrM+iGJkWW2qHpRhnNDa3IgWq1WNJ?=
 =?us-ascii?Q?OXrL8OQX0lOQRlx8CQPRYBm4H2tFYnxmJLEkFgfLSZERcQj7MEM53FDnNpTo?=
 =?us-ascii?Q?Mzw7UW79HpTytbFin+5RcNjcAyLPEoeJOTXG+IDuxal7JcbBPbimJCa4a+DG?=
 =?us-ascii?Q?XsaqgtmeqvBL4XigErksA/JIC3VaNkV5NCjCvzYy+LZMUCPBd6kLDBNQQ69h?=
 =?us-ascii?Q?I6n+TCObs/ThSnVxqBR3OwBTnMn4hSwFfuJ8RIU4kAK8GxvJxICwrWQ0GpZL?=
 =?us-ascii?Q?kfxMuu0eabAETWqrSyI6e0dqXeYL3gePmDbWAazeIZoZq/dCum9hXd4AEZLZ?=
 =?us-ascii?Q?YF9tV9p1tVRBElSAUCmBVGxeyP3e/uKdT9G4KV1E8z+9SJ1EC0qloXIPKKJH?=
 =?us-ascii?Q?yoLD+jeHNWFZGnjQr65BzEkZD+wGlNkfUalvNpBiI9+kZOTEhumsH6ua3vhC?=
 =?us-ascii?Q?laDP6/+vDDlvJ1ad6OVJi+guAuo3ztSCRSuXMydVZ4v+eV+lT9yWGSKuvkhM?=
 =?us-ascii?Q?37mzUdtV/eMcScxkhCDTHoTMstqZ1N4l/kbmE+yDgOkV3dyk4puWhtD1TWYN?=
 =?us-ascii?Q?l3T7YWzi33roIaQijfDwoRof2o+4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?60c34odxLGT4ZHbafj6msN7X+RBf2Af38SR9OQw65reOuCJAR1L+pzrH8Y84?=
 =?us-ascii?Q?kVQFXTkOOm31+zgyL6z6NJ95IgsC63unl4+QXMR8SHS8DKv6PdtdTEpBnFqk?=
 =?us-ascii?Q?/lXl018nObZYXwprd5D7WBGgKlhsubKmBGRXzfvnouGN8ZPEQLX+7INoChf8?=
 =?us-ascii?Q?va/Nqj2E0SudMqDnV7G7XQ7+e7DnTXNec7R44g0TE5zFHTkfKr6PzuduLDcU?=
 =?us-ascii?Q?J61sXD2TVs/anSKumdKrmBeS5sk65RCSJpJQSiBUvB7WN/k16jHgBZa67Lqb?=
 =?us-ascii?Q?8ylN6zYlZA/1zmQUQEHiQ7LbcNH/pXSaiMAkW6iY2otkB4xEdBOArKwVcsW9?=
 =?us-ascii?Q?zw8giGQ4U3obozF/bgtosnz+32W6VJ2WUA/4+TzWmFgFXER+xqnPdAOkHMrq?=
 =?us-ascii?Q?rkMmCyWToVQL6UGUjhaCVO9wN45thK0onjSdQpsE8ISiUstI3pQxI8pT/zJE?=
 =?us-ascii?Q?0XFt8hAAFOicaZEmQ+lbhtvKEuW9SE4VjlxQDLtAkxKeyv2Z97fDZ/erySSb?=
 =?us-ascii?Q?mJ+wb2WTgDY46jsevdvSAnwyInSXycu+wCedB6KZGaqfTOg98/BCVSx/Ed0q?=
 =?us-ascii?Q?VyBChMYvN8uwCIB+EAI1MuHfWXi+JLYLK6KFnSMpsF/Y0zTVRbjRLTtKwsmc?=
 =?us-ascii?Q?aIIfqotND2o7E5jketYCEZDgp0aqbQ4NIoEY+ZBZuYAvHPrjo1MuKHQaRBcw?=
 =?us-ascii?Q?i4aZP5cdZq2YLVOsL2jQ3cFXpTZmK90hMtr9c4hI0+34dSVQu65o8zTYjGkb?=
 =?us-ascii?Q?ixldrb6YCf6hRVxxsUMEnJYGdjsmbi04g0hlqyVvysaFl7qIf+SEx5g/Mi6f?=
 =?us-ascii?Q?HYaeLrezv2w3AD3nRFcV0RGjmzFiB0aTB6GbB4L7jcxlTVG2SgNn9YuROz8y?=
 =?us-ascii?Q?rCAM10h6dyMBCD1jzrs+AO/gmKTAX4Q/MG+A+Cg6ExZ9RQR3BaIQ+Y3lhj4p?=
 =?us-ascii?Q?i/oZVbS5HVbYW6/af+ufbIWYQnK2nqOPHEobxo/7Jyk543hasVm7NCKNi+tK?=
 =?us-ascii?Q?BlPohgJwFwQpsQiy4xjbGpy2I4r6Xh4mMbL0XzzwNbGo6IK/x942l9U8wJIW?=
 =?us-ascii?Q?oEGMHGljl6j3UZG/Kbk7XqPt/7xGievO0XgborkAdyPST8R1B+MVB0Tx0laM?=
 =?us-ascii?Q?ViUVfYbjpAxllV8p+Bk2x62n1v8ISMun8iAD0Req7NW+b5wJ3JolkeFaWqnR?=
 =?us-ascii?Q?fF+MPcmhK0PyqdAv91mVxB4fdfnSZsIgeD7WlduwmyFrRZJdgUa6TRG6q8Lv?=
 =?us-ascii?Q?p3+RrmdyxZNUHB5QLUrNQPvE6LBmFPh46EeFzfjOG9LbljHQAIRQqW7F9DT1?=
 =?us-ascii?Q?CTaros/scmqBuLOhW3hb4vvBWGhgkuH/CuoY2s802DkdtCxnMg3FUr/OtcO5?=
 =?us-ascii?Q?xTjS2ex5d03uxaEX049L/sU/hhDvVIw8RsNVhCaCNU9+szoY1UITEqqARBXI?=
 =?us-ascii?Q?Hi21UjPYu8MNV1NreDEkSIthIFvlKhcMGMbGEtEGPwvrVt1TpLw2QwHqoi0e?=
 =?us-ascii?Q?9ivpC2evvT/LoCYhEnTxyGcOZpfOd8NR/S1d7MGEJs9u0W/K8LS/w/jBRMBl?=
 =?us-ascii?Q?LzoemEsjyD2bOfW1b5Daq5lga8qpzAupIhAAW4NhwPde0XME6Kz9706fCHed?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	z9A4miWbXnun2vtEGAN8oRXY9JYMQKRINKTxBPOjwORkX0Hu2eqks9EBsLgGNQJcwhUZmtnkArFyGmIcD5K78skpXcPxXvbsZZBZUdE805qX9PndMlDCwjbo7e1rh6IDD/WNOW48C3wexADiQ4DI0OkOzFSwqXhgYPvS/WVOiEQXBxb0pz89wf7DVUvk3VAJLZ8UMFGXKhIhYQ6ppoPAWC3UaqG9f0aGgTzQ5u+uA3oxrjBOt+NxIffnraGjzIDKznDW5+2LOTG4V/8gmToahwpPyRzLCznXqwubZqWVlsJ/VazY4ilGu6uE9i+jSHSt+80tvcodWP9Wgw05J3bDoHqwZWRZL4sCJ1nDjpFpP4B3qjwyvn0t0PZ0IPxwVmJEQJiv5eDLFqoXadsxxtzBOFudBklq7HKH4osaq6dHuPuI89lDzUylcEL6vN1d5se6KDiRoTLZD0+JknWHz6obCo2CA3l7Oyxykw0A3Gpr14Lcl2+aUqOK+kWicAS/8v73/pUJEVSobXqsZrSwDUsL+oP+v5W3aipqmAZSd4yedE6gj6nIjM6CUeV0J4EnEtneQBv6QzkXrNF6jZ1bebThksDnNvszMl8US+0UIwhNXC0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b01a2d63-d481-44e6-788c-08dd4bda91a6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:00:27.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4eey2lZiNenOGhlP+MLF7shJaz7MDCXeSAEDAHkYgGiFa95nrqhOq0UCvjQqswAgPhbjSwu4FDo+LGBfma4sszP5xLI5A1EkVpzUOCvfDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4940
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_08,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=909 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130022
X-Proofpoint-ORIG-GUID: 1c2HZoBJKlecqYcZVJc1F1fxBqXaNolz
X-Proofpoint-GUID: 1c2HZoBJKlecqYcZVJc1F1fxBqXaNolz


Colin,

> There is a spelling mistake in a dprint_bsg_err message. Fix it.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
