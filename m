Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9D62563;
	Wed, 21 May 2025 02:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793314; cv=fail; b=aSPkojbk/GONTmYO0GgsTIs9JjrfaPtuvfVTCjrcfqrfFfnfrQjkX2pQt35TppsSrsrenGETSdP3Kf+oHd4MxE9NwiIc55kQfMHEmkW7RWABv2WOsR2xXFGx8u0BOld3CqD769OsUbbXrWh6WlFgREp460rMaqwyKHwmWOnnFTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793314; c=relaxed/simple;
	bh=0gZ+53q+SAtEG4AgDg9Qw5KGnEXVeY3JaKkAcvAImOs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PgDHN5tVhf+iEI6XeujCcMdlnfgeZu+vBGMXm2AixGTitBoX1DODwzeUoNv3X7Zd2bGjbizK8OqGosPFY3ywFw27F9b1lq2z9wOUR0y3VPATLQ/pHBOa7W5hsj+Sf6fFrlT0GcxO+EPm6ejN+G6ufRVxE62vAivml1Il9pvjRuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W/F5PwtD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WpTKZVIJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W/F5PwtD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WpTKZVIJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L27xm8028071;
	Wed, 21 May 2025 02:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OMSliecXeh23t3OMJz
	pZT30dJdLI6/7sjeigLpZnKAo=; b=W/F5PwtDE2eC1aDLpm/vhsCvA1yAYSNLm3
	OxvEpFmQ4McgLH50rY6yF/RtNL3+jLU0YIa1DQL/aQtXQbOF3paQqyzojJ8xvnLW
	YqVNOAil6ylF8Z7O/Fa3WrYVRU42p5l8DlPLt6698gQdZtKutv5qmJ2nUQ08yCAZ
	0Zwo9WkroZ/a9hWUNeQx64m5WWDlNnLc5h0r1EwmTX7CQjxmGzcQt08FwdHBsT61
	SPeI/Au/ho4jmY5FdPmwLXQZDfkH8Yi/sJPA22bpueAsxCBDiJhVp1QIQ8aLU/qZ
	6iSslcdzxf9lHAcHLJFOKhnOtym925pX4qaajbjcwL3aTQHUkO1Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s5ryr024-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:08:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L23msW040673;
	Wed, 21 May 2025 02:08:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46rwet93ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHx+y7HOP/ViDBJl4+O2DOEDIPPU/uzrXm/3199KHvtWN/JhDROBl5n/DUpuJv5393HOZqePUAfCE8ZeIOvba0CP75v47E8xA8L4iiLBuWznMo50QBE+y/mHpegVYujakzGjxkl9S4Cn5sP7H72ZVa3oDverJU9Y2gqZjeZJ9waIk37xA9Q59XaDL5GSEPZGV6aCtgl1T5DAceP14DW5IndQ87zJMp9ihfwHEStHKdwfehD1MYhVel8wLOkE/dnLd7Pyo1/xgPFemymX7iHRs3mQR1/gWo66wwLcLl7NP1++5RBKwZwcIMezG6wBSEqw3hhg0kzlYpzlI6uJFSee6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMSliecXeh23t3OMJzpZT30dJdLI6/7sjeigLpZnKAo=;
 b=LBPS01XsNa7fxtiq/JLcOxDCWHSw0Vxo9DkKYd5dvMYpXFG7Do1B9Sv/laIxhDsG2I51jtTqHe3xX3czmG8y28MlBYPCj6Gi2OKhTpZVwF/hmXWEfHoQpFZccpfDpV6fCtOXPE9Kd6+Djd40gF+Y1pNYeD5Z3FMnwKe07Lk8K18wO3O7B4CCkZ/FaADp4UohRJjg0Me6Nkw+A0V8pAmkDf9PeTfDRhMzg/FNxlWnlDxgVlPYSFLOmmOSGwVK8Cc4LMOLRFOSVUDdPmj2sxLnLad13r1ccECsr2Vn4pACaz33LAw/MREobdzX1DVxc13fym0LCgf8G6VLpSFit+XxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMSliecXeh23t3OMJzpZT30dJdLI6/7sjeigLpZnKAo=;
 b=WpTKZVIJlti3uOXDZsmyGfKHFu6mLDnvgw9G1f4Y+CGlhiLRtW78YWuJizf5mYqp5NxArHw2a/vDmJwdcNlUjMPhLmmfrDmvRTsWqsVEOY4cRvy/mlf2WHpxVkvc9FR8KpxXYQri+kYiNsfjoqqq2/WBzH+5WQwYw8UV7d51700=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA2PR10MB4764.namprd10.prod.outlook.com (2603:10b6:806:115::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 02:08:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 02:08:23 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: Wentao Liang <vulab@iscas.ac.cn>, <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <mrangankar@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] scsi: qla4xxx: Add missing is_qla4022 check in
 device initialization
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250510095257.921-1-vulab@iscas.ac.cn> (Wentao Liang's message
	of "Sat, 10 May 2025 17:52:57 +0800")
Organization: Oracle Corporation
Message-ID: <yq1tt5ek9ab.fsf@ca-mkp.ca.oracle.com>
References: <20250510095257.921-1-vulab@iscas.ac.cn>
Date: Tue, 20 May 2025 22:08:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0380.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA2PR10MB4764:EE_
X-MS-Office365-Filtering-Correlation-Id: e3ab390e-5810-48da-5dc7-08dd980c5d5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GqVBFSEQ6tt9M+jlXWF63jr7rrJKpJiY+YLUu7MNHR1Iq5YKiXlv9P/dR4ch?=
 =?us-ascii?Q?WAVfE9RLE94MNnRfD+G3GS3kBQNEHZND02wuHuuLQ+r7XpV4eJcOVlbbexZc?=
 =?us-ascii?Q?agvZob/pB6ZsgwY/rfEn8M2V1BhFPK5zX1icOtRLet5BuukfF+aKinLamhuk?=
 =?us-ascii?Q?AoBVJCTsCWUPzFOnEeKMf0p+Zl2Nm86nAtKA+rIwbjd0qcMdwaUw3o1Brqeo?=
 =?us-ascii?Q?2QtROVc8n2jF0qOpWtxWA9C3n8W7LCT+YGnazK7bbCSoV88JJdSXB7w50aBy?=
 =?us-ascii?Q?Yzwr4vPWcL6Tl1RiZTZJwG2aaqrfTrQjdd7wVLwJbyGZZ6gKzKwA8UwrxehR?=
 =?us-ascii?Q?gTT14MFyJaiseEA/BXyGTUdBViN3QjqSh9a5Z0e/HLGveNCq2uBjUZFhGW+w?=
 =?us-ascii?Q?OSS+JBqpl1sNLnsHgJ9WqWn6VCWHGmds4zvZuCy2wXgiRTaYqQePWP8u/Iw3?=
 =?us-ascii?Q?KRyhS+4g9TfUr+zX2nQ7MRpXGgku1SZFnL1qIjgwKJBVsV/VYSQ6jBxRktxJ?=
 =?us-ascii?Q?duTFG1PKzq2vRaM6OP//zTWHF6DkS3a8Gw+aPeqRqODgI4UpViX6WUcpoRq3?=
 =?us-ascii?Q?y1MKVrwOkVquWJBTop0Fg/e477mwJy6gn7MrsKgjl9wfh7BcIj7nAiT2/fqg?=
 =?us-ascii?Q?p7guP7F0OXaKvlUducQjGcAVsy43RdKpfUhH99OnTfL7x2lNLL6IC6tdQkdt?=
 =?us-ascii?Q?YLrZWLQt8zEdyr+pzQE+Q5OZYZv4h/YyXk6awGmcImombFKyt3F2IYYoM9kY?=
 =?us-ascii?Q?DYyEzRolX1GBXi3xVTpOEDCWHVmBKX4VxZMTYfbNNGSzo1XpYTWqoyerdEOK?=
 =?us-ascii?Q?it9hTs0nMahCMQ7YlUNuUXzfSaT9ZGGLI1+oT1qCqnmsTYWDVkv4XUwbqrev?=
 =?us-ascii?Q?Tf5fqmuP2uGO+oTHdvoLWNGdhKhBYjMoU4MLnpmiJaZOT/K/J2bY+FTNlf+3?=
 =?us-ascii?Q?c0c2qeUNwoWKgfyPR1b0jr6pMvYrJ1IJdLd+NXj5YncJmo6g8H0Vc4vv+s4c?=
 =?us-ascii?Q?cImxe5uRWmqmMg/8aeK4CgLDoqqaU6eeTY+yc5+HjEcHCVZNeSwAsLA2OtGO?=
 =?us-ascii?Q?Rnwddv+ZeTr6IJrz99/hZsqqPc0EUwh6eNqq1XQHmSIH6FZ6tP9Uur5Ig/GV?=
 =?us-ascii?Q?Dg+wFJqMaWa8O07NsZ4qyZdiTMN2GHHpoBGNOHEGsdCQ6uv//nfQGyMA8H0U?=
 =?us-ascii?Q?tDAjhPYLS28IkY0gb7udc4k/7daNyQ7a8oj4vHnCq1/gtRt4HUeMBPz9RqW/?=
 =?us-ascii?Q?2yjjJfV/spU3md9HDvXln9Y7ct26QvtdwUmm55z8vrzCrzcvKXX78TYb1tyE?=
 =?us-ascii?Q?GdzhV0tEGwtsHboI+tb34WUJL6qmqXrFzdy7k3nDIgQJt0R8eylD+RIxsHdv?=
 =?us-ascii?Q?wYrdCbxmeB5zRbasobt19FGa/r8acXxmZ6yc9J77HXHfc/FFfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9slUPAmBssBjsK/7r2jcBsAanCdq31E/NHF9VeW73GAeIz5ZbrkH0SvFIc6J?=
 =?us-ascii?Q?6kXJTbC7vXVNZVcOEQapC/nz5PDtEpNo/+SixwN7YQbl01kWSP16CruXos1B?=
 =?us-ascii?Q?sc5i3qQsEjsPS4sApW2Ko8va4bsIrkWv/PSvZV5HUUk49zdSV5P6F3AUxLYL?=
 =?us-ascii?Q?/4cy1vu6NP4O+x7g4FVd9tZF4euMXxQXjM3Op7zEROyRvey0wAWu5iuIlDma?=
 =?us-ascii?Q?wZ5p0JxqiSDPTh1xAT7+KNsb8eHz4LLrpdvXLXuVepTLFtruwufWGH8D2+82?=
 =?us-ascii?Q?1mMeJk+Z8JfTG/UpPo0c4xoVDXY+XQhAEcFFnFS9gAKamzvYBmzbQCt22cuz?=
 =?us-ascii?Q?2vCVTl4i1Aj/VNie34fBDx5YEn6Rh63aeDsBIffu7fpYH12kX0Txmsu+iQU4?=
 =?us-ascii?Q?zCqWRAuhalq5HCErt91c/F4O0qevZ47trZmhn7U8Bt5AwfOBCCK524f9BdPE?=
 =?us-ascii?Q?/qvfBSQ7TY1lW73T9l8cl3ZHQobaqbJkcYaMrFm/kMUmQss21DEdAsrhbgUj?=
 =?us-ascii?Q?obsfF8lVL8J1Yd7fx6LiBWPdaM67+z1yUieQ1tAdHRxpo4f9Epj5LUrZFITh?=
 =?us-ascii?Q?nTfclT2qs/46OufPrw5M6zXUZjP9ar3S3kHSq7ikEqK2jYaOHR8dh/wHw8oU?=
 =?us-ascii?Q?j3+aJgm7HhLjNR+QmL2YLWZTPl39qWTDXnEZuMfQE0axdNQOMAYZwkzBY/qy?=
 =?us-ascii?Q?+NGwQkswAq2SQu0N47xqeyFC787vxaJ4lwrrRUmBkYkwvW1A5md0YDjdIJSi?=
 =?us-ascii?Q?SfXDk3hylRSFeBR92FaPY1yPG3K6s1CrOHemtfc9TMvP7Z8tw/yzAOasj5xo?=
 =?us-ascii?Q?OBMP9iKACfHv3XzEhyzHaoJ9qSdHZEiPCj+ykyXOMsieA6WO5npfo+CpnDco?=
 =?us-ascii?Q?kTzVNs+latow04qO8gVACt6GXBZeDC5/VIl2wkcRp+lGVOOPxj46isxQIkYj?=
 =?us-ascii?Q?JLBzrMSGyxuZBePzrMv/dSA3Kp+r2jkMmk/DH07miqRZPBpZWpdCYOz/ajBp?=
 =?us-ascii?Q?pS/kLxhfs8P53s243Weyke/0Yd2xZG4lDMrEkJmzI/22g4nMpGYzi9hvkCjm?=
 =?us-ascii?Q?iQUZQaPXT8vQtZmLt2nbiLnP4C1DmnCZq4eS/CLsODVgR8NVfXTBORAja3qH?=
 =?us-ascii?Q?YthlNaSdHS76+gbar2/DeZXJ3uFoKg0wfdW47X/BpnLCntdOucgKvWsMG84h?=
 =?us-ascii?Q?QQMFWymEsqb3WDgMHr/PsJ27GIm0bUdzu5JXjpd1R1TKOmqvj+L5ve1BzAXK?=
 =?us-ascii?Q?RJeiHrrtFyJ3HW+ug6SJ3KRG5Y83RzgOhF8d/Amo4txJVsDQFr7uvvux40KZ?=
 =?us-ascii?Q?0HZRiYtdYQSit7d6Gq8xSutQDgBev1HPLH183SPfH5qXhrtBwFNbcvd9b/+i?=
 =?us-ascii?Q?ynU6uHcUCl37NbKyG+6Fi3DOHKLppUKTtzdX0M+//gsRcw5ttJSKq/+4ss00?=
 =?us-ascii?Q?+urk10RIv1GGNyQ9GNaAZtMS47XOXzY5Z3SRjHiuYqUzqBCZeGaTGSzwO1cm?=
 =?us-ascii?Q?Z+M/jcr2xQwhcRDVBU0xcjTV37OENsld7DeoLbjv3hYvg9WdEJyRg7zqKnoY?=
 =?us-ascii?Q?xv8z+1Squslr02+s8P9qOxIex8NReStYDWdvPy2Y4uXOT954x2qy7GZALt8U?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A2/TEQNkpwY/Fu9dPR0gWLqbT03KEVXR1gsUrLYn+pZCTfLaM8VUJ1QFfib5wT1iuCzpdhc+NwKnkIYfDqANCh5i4MXhnt7xsO1wSWgvQ1reWZOKoSXcPkcnky3wznXBQY0+F7EE/krNi1cZyOMSUR76jgXTIdkyNTvcHZf3yReSpYRgcptgReQEh/lBL0q+fbwS3PJ08Pu2wthcasuh1JiFXusXPM3D2uOrE6cbIPBnEVgypFU86VDDIxNjZBxWiPZzyckqQiQspPjI56hVuuYeCR7qBjnoGQFt1i4DVDMpiVgEip7n0juQ82bTWEB6lSBiW2GZnefsvpYmA3Ob3/vi/dS9NE+lIeSW4Yt1YTgUIVfJMrlajLYDPFVOqoHJTuVhMC+nXeQrfeNcGA3Gjvk3RwEdzs+xjfG6SrVO+sOklh/kov2Av4Of+2d8J1qN2Fzvo+BlhriBJ4LFf6wV3BWSgdoK7D0xbv0gfoBiU7T/OiAwFSny+1k81ogA057agv3gzqAfHJAZUoS6C5Mkh251dv8/ukanTi+xMu20SlbgZjeE9jbROAy23u5c7O/o/ZuUyOf84p2YRm64kfLCCU4YMRDmiMqoT9GmcKYFt9g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ab390e-5810-48da-5dc7-08dd980c5d5a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 02:08:23.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lx+tdkKIfdrLbpMn7URFRu+fMgm8erOFO3Ay2JSDOXHqvD7CMIXiC+TpguJeLZpndmcQyNfY1Tx0soPnCgicAXZ7RmewvKdq8vfPip+ZGzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4764
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=939 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210019
X-Authority-Analysis: v=2.4 cv=PMgP+eqC c=1 sm=1 tr=0 ts=682d359b b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=JlnndBJoG-qW3p1pJG0A:9 cc=ntf awl=host:13189
X-Proofpoint-ORIG-GUID: dc98CcB8QqimLPFxdmrlxgpQEnFmJ78P
X-Proofpoint-GUID: dc98CcB8QqimLPFxdmrlxgpQEnFmJ78P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxOSBTYWx0ZWRfX7XuRAHOx2ai5 aGd9wNAaRmJJbxL2w4gY+zunow8O0EGTPMrNkv8hJITEazv2aQHFZN5tNB1aj3Z5xqXu0jzRMM9 ndItKLt/3RX9JOGguK9QEileQDvpX6del0dXqGnlAlBFxnISMODJiXKOFG6MpVuUwqofUbu0HDR
 xhABfTJTy0vYSNWZKEGXU8E+9NmSfiKiDl05ieE4Ud0fLEKNgqZ8QTeRfVvV65o6VazzIwc8CFd 8cChng/pBWyr6FxS1wxuhJSVaDC72l7OHsygORdBKKkZkUCAspSVwnswdXwofOqkm4yUe0EyjmX gyDnw/S10Q9uDZpxQeo5xc1HkK2A/pnt9Y5GstPvzDApZrjjo4hGzqsgW4bLEtMKzfCypKZfeUI
 x5Xv2XQDiCS88q1Dth8OqPIbD6ByT9z5NLF0bDPY8S8yUYHsf+ZOnPYuhquVUxZ+l2YwP7yY


> The current code only checks for is_qla4032 in the adapter
> initialization logic, but is_qla4022 is also required for proper
> handling of qla4022 devices. This can lead to incorrect behavior on
> qla4022 adapters.
>
> This patch adds the missing is_qla4022 check to ensure proper handling
> of both qla4022 and qla4032 devices during adapter initialization.

Nilesh: Please review, thanks!

-- 
Martin K. Petersen
