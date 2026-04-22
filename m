Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DEF1D5160;
	Wed, 22 Apr 2026 00:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776818561; cv=fail; b=qZPDr3KI8fZX/JRmp0TpxQvw1YBdjs6sWPa0xY5OZwciGRSqAN11XQ6zpP2MVxbEpGc96ZGXlTVo5c7xtELo/OUAGSk5fnKzd6+GgIxO+pSr/9AFayjF0IHF8Jz9va520LjScKl5+qkVeT5qD6IoTgQ7FugyXyGQ5Zd/yttlLgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776818561; c=relaxed/simple;
	bh=3IxnoxzI25syjSLT9woxoNjWmanCS+AJAEYZliFP1lA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZdE7Jg4UjszRQCsvcep4720IvCO349W7juQul5TDMa+X7tWh2DuGDbhjyTLBQ9UCasoSyX/22RpoTWtHZEbx3D3OmMnTPD9Bt3K3PxGGmyGUvAG+go2iX6xqs25uoMYZsVA69U+0oNg/AePH0Q7Aspoaf9xBoLDhWFT4fPsuR8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FhpwmBle; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D+A1Aco1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FhpwmBle";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D+A1Aco1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIajne2337297;
	Wed, 22 Apr 2026 00:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bVGIkKMl5LbKL0MaPX
	/Z2ruxIkVNpJHDFhcRXjfwT5w=; b=FhpwmBlels0kOCRBJlzQh+0fmr1DPJoAvJ
	dAvH8sCsHc+eN4qlH+temOOJ+0oJbdH19EKJbZtJMJxpp06ETF3CHBNXgN9/to1p
	JrvEygXVFkARpwPXrZfZSRwrJMqAGM6RNkPar3qZyW0n4rHmICQyCMmYuW4hxhTT
	gAj485d6/JtDkk2F1vAvV9rY+bd8XC8AopQ7GRzMO/cUvn30CoSwcFTtq3y54utk
	zBY79Kgm87aOwseBQ+P7ieEfa1aeOBZM+fZl03vxSKbhfU9x+1L7PBNkCjuin0hd
	06LmcC73zNyWFGOxXIb8fJZ78mc+JJmUgAnCvFXwlAN7cI/d15GQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenmrdvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:42:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63M0fEwG009633;
	Wed, 22 Apr 2026 00:42:24 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010015.outbound.protection.outlook.com [52.101.201.15])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjdtfuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 00:42:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IwO1CZke5WLYdWcv8wyS4VC0/p5Vubq45RaJAnO16x7zROFdVO1xDpjIZQDFJ8FwrATqB2KOj9+I4r8fTgakozVDrp7N90wFI2G2pPzTezfxOOg/dKJ1ZwYon1g3dvG9TzNC8q/BqUM5gsCi474ywYJaHDdZriLkkTIWGvb1gVZE5AEdIV8rfmUjRbt6WfDJBSzZB5ArMaG68Dl6R1lQF0BuCm04aykB3fKhgiMzoP1YAf76XNf8OmP7s/JwizRik/EUZPO3sv7x0TYbpnpTl3hnTxyl3o4C9jYKDM9dYHHHJOlOU8SrMeSjdc9/PRpFoGlzr1cT8kt/wU0XxzH7gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bVGIkKMl5LbKL0MaPX/Z2ruxIkVNpJHDFhcRXjfwT5w=;
 b=euxTbmuoNr9OY9Ocys53ryvcCu1/JCVI0qaJBvfpGfdU+7G991ujw24TH6u7JvyY5G/nrWWxO73rrHKrtWHZmxNlyVnBmj8Acp2y+g7V47IE3iaMAjGXOVnwZcG41yxk1L/JbJf7LtmGRjCHo+6FMD9oRDb2SYQretD7midVm0HWAUl2soT17mP8xAAjsPropsnu9RdFFdQvkVDtaAzOYNdnZIjRdUX7wuzIKT9rmKjSvj7i7kzKMR143m4YGyCv2ysc+QJx8I9g1hVrfPrn1IHhtqkiTPSK+ZGC+nVmLC2dbvKQ+5esJxLX3r7ioG0RBO6RJhnAOLmo4bvIGFYnaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVGIkKMl5LbKL0MaPX/Z2ruxIkVNpJHDFhcRXjfwT5w=;
 b=D+A1Aco1SiBhffpfgrJCqOHAYIWyN/BLv0wZmAOQOSdLiSmG836ZYBRfTyjFVcLCsSPvec+TkBC7zQ2iqf6U9N4qHhNX4wu0VGj71/nERYE/Cg1ug1pZU0njb7Yi/TWzLmb+C/HfRkvz1TsFXMcZdaOi0sXTtstCD7P8mJKMhG4=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 DS0PR10MB7067.namprd10.prod.outlook.com (2603:10b6:8:145::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.33; Wed, 22 Apr 2026 00:42:19 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::21c0:ebf5:641:3dee%6]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 00:42:18 +0000
To: David Jeffery <djeffery@redhat.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki"
 <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>, Tarun Sahu
 <tarunsahu@google.com>,
        Pasha Tatashin <tatashin@google.com>,
        =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
        Jordan
 Richards
 <jordanrichards@google.com>,
        Ewan Milne <emilne@redhat.com>, John
 Meneghini <jmeneghi@redhat.com>,
        "Lombardi, Maurizio"
 <mlombard@redhat.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>,
        Laurence
 Oberman <loberman@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v14 0/5] shut down devices asynchronously
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260420152608.6244-1-djeffery@redhat.com> (David Jeffery's
	message of "Mon, 20 Apr 2026 11:26:03 -0400")
Organization: Oracle Corporation
Message-ID: <yq1bjfbn7xl.fsf@ca-mkp.ca.oracle.com>
References: <20260420152608.6244-1-djeffery@redhat.com>
Date: Tue, 21 Apr 2026 20:42:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0016.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|DS0PR10MB7067:EE_
X-MS-Office365-Filtering-Correlation-Id: fedf9816-8720-44cd-c42a-08dea007fb74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ogx2q3YOmzYZiTbEHS20MVk5tvytzipMk4QcJzbZRdcsALr4RNgoxocHG5CCbuIE0VYyM9ESpF90tYHCwCNag2OqGNuNGO/AqKjxWR+cyeTq4KCPCgfjBIIcA9KnKl3WIhTNi3nzVBbeRQ1zo3/rupZteQf/WAk5ztMwL5S4UviDh1lq6MeOaV2cNIIeB7Ld666Rq+g3euWQ3NHv3j0ghTazqfQhbux3ewKAU9Kg7gtqW4qfi0ftxYspJW2hzyoVaaRnt3ko1r6JOd5y9Vnk1w8MMHKHYQls8iLB1I2X4Hbovwjc+jJIS0/lbRRt7X2bpYlvmRl+A97piS3/v4VjLZpbV3rm/vB+7KGgEeZuo65ViRSpzPd7IX4Em/AGVA9J/m0Qr85E/f92Y4l3sXZGY56Ttser92BBcBvUimFjdaRUNK7MjweYG/dVbw9cMXe6ccqdchCIC/QotDp5sCvUYppdvXS2DPT16ADhlxrDOuqoUfDRADbXJdN2eZeDucsTPKuNvqHFkwIYTNKZsfEAlqEDnN0QjVMnsSxHLcKyg4lpPOrzh9GJhZBKg85SsxkwFPn4CGXa+HJkALJEC11J/s4psdF+gLzHbnKgOKX59+TTNsU7dwNnuNKsia/ZXF2EbcxERNFEngHMOqtuUfmadl4t0AxC5RKKY3kYdrc06Fjmr4J3IRcFsYaEGHbWXAG/HvoS72Vj0NnpRsCssq/CpqGOU+Co2ajpCbSDb7Z5h+s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iwKEI5hAzxjzgRvVFEVoGA6s3g874t0Y66WM5FyLxvUOHEkR9K5OyU3aVvPx?=
 =?us-ascii?Q?bRYTLrN2bIiHMqPu+sDpZETwr7z+YfX3u3DJMdGQWF8zvSvBSBmgtFJDeA/h?=
 =?us-ascii?Q?rpPTWN7+64RNSH7fQZzKTBmTOrkO5LwGy4y32IlkeNQ+pW3PVanYbea7rAnf?=
 =?us-ascii?Q?2BhRQov9WhxV/ehfqquoexoqzDCW20viG4YhIpqF1UuDcveg8KuD6rYSJX8A?=
 =?us-ascii?Q?Kli1KZnkOWKwGdb8Bx/endTAHPOTeEKrJeyAudxAlosU0VwvI6Y3ta+yYKDD?=
 =?us-ascii?Q?fw0LjzeWlJX+3ivUSLDun3e+uKnW+xDW3nssgCmrR3svD6wqb9GyjeovId7z?=
 =?us-ascii?Q?7zN/3vCKq33XDSLXYgxWxcaR4mcUlggYAabmgvlAbWaLa495l0CDDW7+MTgP?=
 =?us-ascii?Q?zO0eVbNfjBuXHIqR1VmrAnjn1wtrwajjLSUZI33HU0LDebcKBY5qDvTCfnoq?=
 =?us-ascii?Q?ZxtBNFJCOwtl4aGrWhMfX825JSKz5URvR2iJUDpWNUbZ/FBnK97b00ikEfe/?=
 =?us-ascii?Q?zTplRNGTJMkYnyAdLhkvbbh4s2PlTy0ArboSwhlnH0Lj7+xSNpFAS2p+WWpR?=
 =?us-ascii?Q?lSIQ3l7k9IorAx32hmNha8s/fL6Np40L5jttHxEOWK70R/T/A5i8E/J+P66m?=
 =?us-ascii?Q?Qnqi0yd/NMgetu9qhCAXrhZSuqOeOteQSEFvPrwsNohDi/tYDdyUpQ7vivIX?=
 =?us-ascii?Q?l/TPCt7R/Ux6ooNcCk2UFnWssi0DvQeF3ljt4PcwjzxQJE33d3i8W47pXklZ?=
 =?us-ascii?Q?htEjSrFqFxxKfpOmEl/IP9xb8beQV2uLFCTMQWdGKDUcpdeJ+DknqLH69oEB?=
 =?us-ascii?Q?MY3U708B05EAtLo5KWR6P5aIOzZ33xNjMMzGKh8ewgow/c4WfD+2onLKjNJx?=
 =?us-ascii?Q?xv5NqLKObSPLveemO5iLIcboTOM7F/03YLojo6wetj6iswLBR4tOyFWDJChT?=
 =?us-ascii?Q?cdfob9LxaX1WMyHbxTwwx1nf3tiAvn/O3gHSVtAApl46vmH8Nj1MjGaj2qrp?=
 =?us-ascii?Q?V5s3dwMnV42HTTT4ItOS9JTo8G9DlXHygQpjRlf+ZzPqYqX/ybHcLGkyABNi?=
 =?us-ascii?Q?0fzBgG6LnX/+UOjlfBkJ8DyeOuBY/w8ld0PGV332QwP/6gOGGY5GLlPW5+xF?=
 =?us-ascii?Q?yXQluOL+L3QgcmS9/Jo2qMzWRzMTr5Vg4anWgTBY4PpcwWs+8iWl8PBth30j?=
 =?us-ascii?Q?jdqtW0rJivX/Zqsxe8CKHaa1GXu0imIDFW+JHobcQAMdBUql6Uz3pnYAzhEv?=
 =?us-ascii?Q?CyNHEeWFmG4mq2Md+Hinz991uODKM3Ix0fMVlvl2BzyGbKcybSRH6Fzf4+Es?=
 =?us-ascii?Q?DJOmTtIaNxWigKxF0SnMzQeX5VzvkCGjeK4LZk2wVw1zz8cGF27f0AIogpkF?=
 =?us-ascii?Q?xFNrjfBt93ra1jENYB8x0RuIwjMbUxCNk6d1dpe6Y1/aFOK4V3+uFFx4+oa9?=
 =?us-ascii?Q?buSreAe0KzbiA2LS76GEla05BzFGZSp9DNB3ncitp/XsABp4KzLWHeSADtS6?=
 =?us-ascii?Q?9gdX4A+hspfRap0CM19o6e01/10M+dB+CfVGN7dFRWBDXXuxjAD8ZJSO+r+b?=
 =?us-ascii?Q?58TDsZ1SQ3GSnN5F+dYhD5LkiWg5cEn0nuMeMJhJt7OLe37dccVfPamgBiqh?=
 =?us-ascii?Q?Qt++ak+9HPNOAEwRMLpmCykUYhdNJYiLWf593NIHlxLzsuzmiyIPHjlCyc1F?=
 =?us-ascii?Q?FKN+ID9Z/XsM6sHhCkZqXKQM6vguJu8UqxpLAi9tZiBT19xT+9uxTkVfoylI?=
 =?us-ascii?Q?iKbH4sCexkWU0UM4qK0NaLatPr2ypt8=3D?=
X-Exchange-RoutingPolicyChecked:
	bs8OViHraEVHXM2Gjs/IL7LIhzdp8LP6mHvLHlZ/9F3zF9DJ7RH9WyIku1nucThsvbiToYHPjQhintpej9v/mM+iO5/abRUCKJ4Qr5HgQTn/n/p/nDl2Lbt988JmgytoEqIwsoBEVopZuFQcMNkZsRvizBp5RO4pSNL4YS+vD6V0/tCYUQ7lm6O5wZYGMtO9Im061f1jaP8pUTUh5MLAYi6Z68C0DdgGQcUiuJbM/zCLRY6UQcHHwym3NNUldCRFEDMDCW+BssaPtN95JOr5pqp6/LAnid39tW7clxHUOBi3u9LInxC6imI+LtSQUM4GhfmAglyGmmklkkP8aiSyrg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rrDQv9oBo1vkXqne7IwGlMhdoauiQ67bS3nLQgk/VTBaHQIL+d0+XdpkhB6aBrrNvzJ3ICeQgipZzRdwYNc1I1oNIFIIV8LqXiJ3aK/mpnPpyyFAJi32Bmpoju5rdFqNDZ9RF4qaUVlPFvS3l+xO9UqyIJSvaI6GTEmVDtcUa+YDKcxfK7u+qNJLQ6Ja5d0GEizub/Nl3ydt5oVmdK8xiNsJEg8fgFPu1K57L/oXmsxcyLEqpYDW/wr+eP0JaYmTudXCpjN9Z+2qD2zuhua71b2BUwfcA5Zpx3jlF0TivPbsqHZzTZ6m9XJJjzlR2Zyoa9pFs2LEjgImIFb99jWi8BjYf6fXf7+VEKwFKf3VQ9I0JNTLErDx8qYnwvKxjzKyxpV5/1PgUk2yEHlVtBCso37zR9SZNZ+IiyJ60i9Zhq8iClgsymbArxoZ2w90dor75lRSk+PujDOLIAv+KqIAR1vHXzAVyOaXgizSdvWPQWC8xUzd2/0kg2bf6cbvufQ6zPtfMl6odR9K4o7PvAMTRKnxJHPDrPsdiWbZfYtsyXwxW/mtqEEwM1OiOeKhq2zhbTQjx3Y4Lu6DdejzaVqzF8R/JwmyziBPElGGuQ2gN7I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fedf9816-8720-44cd-c42a-08dea007fb74
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 00:42:18.5482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7Wd4GjlJxgkVLYw5A/yeJdkM6jhppYOdCEZCagTY+sGDvk40n/SItkorzRtlNb/H+eCSmgZo5C3cXdwallyXnw3nlK6I9XO1pSUfRZqjVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604220005
X-Proofpoint-GUID: 59UlIPyoIuQsNDXY0X_vnSDiaVBY6DWr
X-Authority-Analysis: v=2.4 cv=Z6/c2nRA c=1 sm=1 tr=0 ts=69e81971 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=y48qp_fEp6yFt0aH7BsA:9
X-Proofpoint-ORIG-GUID: 59UlIPyoIuQsNDXY0X_vnSDiaVBY6DWr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDAwNSBTYWx0ZWRfX0STkWj5DByvb
 D+AHvtQGxjBKiKkyhJ5GVqEScie7t5p5CZEXr9Lep76Dh2V+tkU4sbYQh/CbUxq90XZvgZHSDpZ
 fl54dK0L3c+/TxDQtxZu4UNG/zqutECSkIeAZFielxgoJykppUD3iTGd3LvxR3hl1qt1hhMEZ8u
 fxdX+q3BKBnG0nN63JQRWu4pQZaMDxqABpZJnMb20Jn+V9d2a0fb556YQ99y8hhi3UyfqaPN3lB
 e98WVK6M8EaMTneZEeEpIew1oF9s1mlb/lcay0q7OoDhJuCaioBK1OhKHNw1T/kzVQiRsuFv/T2
 eNfToTBri8eUF0iX6QvgVVJTCfZlvZMeXtGfCcEwbEohqsSztH1L1Uaur5m3lfgQkkLoKd9ZnkA
 KeWd8GI3K2yxi2RTh6epRiMgIUnK3kJcm+oWLSnwkOHhxodvMd+l58mM05JNgRDwey7kUaJrVEH
 i6vW+TtIj8gU1m6VtIg==


David,

> This patchset allows the kernel to shutdown devices asynchronously and
> unrelated async devices to be shut down in parallel to each other.
>
> Only devices which explicitly enable it are shut down asynchronously.
> The default is for a device to be shut down from the synchronous
> shutdown loop.
>
> This can dramatically reduce system shutdown/reboot time on systems
> that have multiple devices that take many seconds to shut down (like
> certain NVMe drives). On one system tested, the shutdown time went
> from 11 minutes without this patch to 55 seconds with the patch. And
> on another system from 80 seconds to 11.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
