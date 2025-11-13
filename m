Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909B2FD69C;
	Thu, 13 Nov 2025 02:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763001526; cv=fail; b=qBes5gA21o2Lk7VNUbO4Vea5NryYILocf79DopkX0ET5EnSQwOisJ+dHGr7O/QprobkK/PSnArI40HwJWFlD/BLoEv+gkguEMsLNrdZ4iVlSppJCepM7ixEs+KwdX3uR8lbw5tKdDKVg0MUhxxdRfGmXCaxP7dWF/CqCd/kMlTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763001526; c=relaxed/simple;
	bh=hQi0cmMrFqzhO9RyJkRV2VrOB2uSubsM11KOsAdhBHg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=V0Rt0yheS9HUxdia4sWWIhyEuoy01saW0gzKLuE7f1dI+Sgbal33Mt3+76uua8V+xwNDoBFYS+vGfM0JoQfWAa0T1bhcV091wnrz6iC/ywmxnns2bDgsPg6v3sKI3Dy2bpi87vSOwOehcU/693TjaehAQXUsrzm78mScHSGpfFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qhaS+mwM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qldMazbw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qhaS+mwM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qldMazbw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gOi5019369;
	Thu, 13 Nov 2025 02:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=d/xGuMgSsMfR3jW+3n
	hJQ6yNgvsAWTmWe8BLtVkaPJM=; b=qhaS+mwMCxzNC38IXK7+ysbGehVx+VDhTW
	ihfGZOL3umeafK3KHZRzY6Jm1Zd7vCvz9FREHl1oBbRbhXiSmcw7E8QnxKf/NnfI
	R90uwsrXfKgKQn9MPvM1QxbS4zLPQEMyn6UWDnikRVTK3e82EH7nyTqx5fkyjrl0
	RJXkQ2q2Jp9QAYz07+IM/bT6ANB6ayAfq5iwFDD8O/Hgrda3LauUeySl7IO25jqg
	1hxODKIGjtxE0sS07tj/eSmHNXPjI1iS40+gXanJ5MbcAJWWyeCSVg35hpI814Ln
	4rCzzJlqzfOsJ0Q5zBh38l5BFlQW20HKw/UooRlEUjPHsX616nQA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjs8rkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:38:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0PrS5029330;
	Thu, 13 Nov 2025 02:38:37 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vafjqvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:38:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stMe7+N4c51KPWatovfGaXVg6lOzsTog5IkHB+GzOao/g6osHcehOHtmRSlCbt92DQO/2CpAOkXQrlBP3hfF1e6hwzh4VdrA4afxMO4ocb6BgRh/A/ZXzErJiL9Gi7lrbOHmN8tCN9MNkGBgNgQjge7T6D+Iykg8MbYgTXRdAjnuk/+QfkXqv3t1uNf1yz1FGd2jatPLQNaZ9pU65ZU+f7Q/ynqk2ANE+0sv741vvrR80KF0H9MbDpxEcfAf8kuA9VADK26fSFe2K07dK+G/XcIOgakMOz1k+BOUhQKyU+a3JZj5Uokp6yxDjiyb8Pfuf/ggDeJ8rUu4BpvilcSbxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/xGuMgSsMfR3jW+3nhJQ6yNgvsAWTmWe8BLtVkaPJM=;
 b=LsHyezGP8Y37PmyTKzfXo6gmvbvTm/wglUDOIKRlmBLkhir3FcYGOSlO6JoR3/FWPd3nDgQVj7/HV9LIMXOZp4ffsvOS+8sRqMX4Brv2AIwjr9dyAH/fi1zFUIxqR0G4/bK9iZ1i5197hO8mnuOUHSoJZLE7Z5hJdYM4BzNdp6jv/CSlOYylb6ms2NatPXUezJ6yP2THlejBHQ9EQnFoWQVDOxdbJ0ypTRQDe0TScxrs8oU6EwRJw35akHVFgfmhOzUKuqjA9aiQd0h7D8ExVl/H28eMCXvGKM2pr0MU3l5MFJq8LsUMdeG/SRcjT8qSzts3B2ao9jLf9tIFIEXOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/xGuMgSsMfR3jW+3nhJQ6yNgvsAWTmWe8BLtVkaPJM=;
 b=qldMazbwmFyulhNWmabklJ/LAntKH6hOQPzk3ibo3CfYANeF6pXNXJJqblG2z+Von+AheQeYI/yQmNrX1zImtFFIT1LLimnTBDlE9Mnoc+vCG84nP/y544VXRLu83JkN/pT5UxVE2hZ1RIf+95b4drHWjD40E1PWxVjUYToew4g=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA1PR10MB6073.namprd10.prod.outlook.com (2603:10b6:208:3af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 02:38:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 02:38:14 +0000
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic
 Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] replace old wq(s), added WQ_PERCPU to alloc_workqueue
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251031095643.74246-1-marco.crivellari@suse.com> (Marco
	Crivellari's message of "Fri, 31 Oct 2025 10:56:39 +0100")
Organization: Oracle Corporation
Message-ID: <yq1wm3ud5nw.fsf@ca-mkp.ca.oracle.com>
References: <20251031095643.74246-1-marco.crivellari@suse.com>
Date: Wed, 12 Nov 2025 21:38:12 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0021.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::29)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA1PR10MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: af4e1e03-062a-4fdd-93c3-08de225db18a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pjOgm7/2Ynj2W7MUzb6OC0MWwleY8e/1lT2ULikVhk3KeA2CjHurAE15M006?=
 =?us-ascii?Q?ah2ZQlP+uGImUlzJK9T4gwVD9hxyJ6ECEWEnOdc43+lvY4OZNNnjx5S8pYD7?=
 =?us-ascii?Q?TnFvAPrC3GH0Rq6SMrhQYEbCQFJeSJ6ngICkRlureu0Ujo48xFX0yrnK9576?=
 =?us-ascii?Q?StNClWCMdbJOPH/XiWIKNijze7U8wqdBpqrBGID04ZM9NtMJxqR3hkvW09UY?=
 =?us-ascii?Q?kfd7q3Npl0Vswyl7LAZpuZ7NCcsno3H9hH3JKbu263EtiU0Km0oaWazGm4x/?=
 =?us-ascii?Q?ctykRyc2895H7GeNxITn0YxJbPcEOOCmQswR+4pjsBRmWyt2givXH6Z+1q4P?=
 =?us-ascii?Q?RoiWZSl6xuPW4pRYf0HlRGWx/Bp2xQObWSXxuNqiHE4/V2rS10pz4oSKAFLt?=
 =?us-ascii?Q?9NIOx/ZW14tCdep0Bezx3O7foZCTF2nbaQKfQ+n0RHvQ8v//U+YYU5hHzS+e?=
 =?us-ascii?Q?eHATSnF2FJshmqjDV/HqzNrIEzPMNXEEW6mU4yG+r7ZUFWZZor7Jscl0UU0f?=
 =?us-ascii?Q?yLmQKL4v9kVDL+dKEKVufTxdgI5OUTl+4o/AU37nIJ6oXOF8L/XPMa5IgvYJ?=
 =?us-ascii?Q?QFxeb3jlkcR7tucJ7IvB6YWfXPzcaaA9Ihu2UAn5ta3Rz14uJjLaHCagEX4d?=
 =?us-ascii?Q?e28ay6VbSMR7j1ghxmkK/iQ2cULce0EF2seXvrtPc6Nc2pQtjgSwQ+wBmodN?=
 =?us-ascii?Q?0M1eixdJf6YxorZqvJl8lvVF5t7Ru4YkxQ1to6TOL/MWqxyu2ZhvmVBPMk7E?=
 =?us-ascii?Q?6XjuuNnQEX1zUIHRGfxZbBK6gJFOb5/6H+elW1s8D1XJh2EDAsRnX8uM7cEv?=
 =?us-ascii?Q?sshwwpizXxY+zeFu6V/WSCifZAA07oUrfPhVQTXdfccWVNiJFgfN19tBn0sN?=
 =?us-ascii?Q?+KHWJMco9XyDSIieWA4YxsTppESYfMpG5mYmG6F3iDzf7Utt8yxvMKBiK7gE?=
 =?us-ascii?Q?30f1CoE9/bkuVRB1vp6LFTu/Vh/rh2w0ohgxUKf2aJ32zUKKQpX4dReOfyrd?=
 =?us-ascii?Q?z4nzDVsr44q3RRRPZYxMIXd6x0rePKCrmb6lXoTmQ9WeH6gO+Fqpe0mhuFZ7?=
 =?us-ascii?Q?UTnNpWYQIY2trY2FbvrepwibfYidre4zOzN9W55nVa+9FHyyVOcNQa2u8lQa?=
 =?us-ascii?Q?/UiSAMlkq82++1nH10Y8QakE+OcuPPtoovCzRhkHvYb4TFl5BPT27lm7PWnX?=
 =?us-ascii?Q?u9hDD2ihHkYZ/t6UICBTxihoyT9G/wRj9zo+3kOrit/U8ZxcKP0F1mm8/xhS?=
 =?us-ascii?Q?0W0ZgG5E8qRh1jHvgInnrjpBE5HPtyBVgGyhIWba34XKmQLaGUzLlbOtoRB4?=
 =?us-ascii?Q?F/75slzqhs84oDtjCNVj1hkagXO2wHoKkVE8wgGlldRtsgWOYVH4lmgqrz+9?=
 =?us-ascii?Q?gP8XUqNU97bbP6O3OPQf8bm5IVCP3rn4Ht/cz3F9v0SdB/5PimzJxZnqQYfI?=
 =?us-ascii?Q?LBt6mjHGfqu/WBcpqtEtDGcLK9GghNEy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fv5easDCX6JQYZdmxZ1Su37BuDYf1LIM7ZbtrM349kLOrt4qrjJ2ganT8Gdw?=
 =?us-ascii?Q?G/gc61ynodvYnh9gjxa94+TCBYwOjLRMhXpQQLa085xj7Ter374tviTT+Wbc?=
 =?us-ascii?Q?Vzn0kJSPSvly6IjCwIwIuadMYFJmcPKT6sIYSjBJ3qBQfHEKGhZLEPBsZrjN?=
 =?us-ascii?Q?9zI89Oi9Etsaqi46f67ukPm5dL8tDT6L0yi+ADrUUq60wJNUp078wmN82tFY?=
 =?us-ascii?Q?Vh2eWMpqpkVem8D7FOgrNxJmvBx3AW8xXlBm5GWjM++Z+uL+rGuwKRBsigHE?=
 =?us-ascii?Q?JcBtBUIHyh/OWPcAVuAUw2fzfkEYBza9pp3Lg1YjNtY0TPKbdfOLI3/dK5fq?=
 =?us-ascii?Q?szIz7aXm007kmvQfyeBnb98SUuSsbtvwl9vcSaYooLhke73KFSx2HtnYu4kj?=
 =?us-ascii?Q?LhPe4zQMVSBcEODc6C9B7s59thA4zGnGQp8RKYY8CYQcTgsZcvsh9ug+Gk4P?=
 =?us-ascii?Q?DkYU4Xn6DCjz5p+dGCwr+3lP8qSASRjGGVFW/ciAStWPD4PVW6psD6tmx1oD?=
 =?us-ascii?Q?sQJhjtSC927LZRCDSE/MO/FsI/yWQtZjRz4CWDAGVUcMIgTMl9S6DKQuFv6t?=
 =?us-ascii?Q?gqjTEsJSHPjp9qbFhu+pzpM4Gjgx22kJVHkm2V/lJ6DhZOziHqVQUZUsyeKT?=
 =?us-ascii?Q?TI4lk4MixiOrL9nE1K/XtKp1VFF90AMnyuIWWzVOl45pdvWnVypIthR9JbfH?=
 =?us-ascii?Q?rwSL5zEMgCJefvFjEP0DPHW+eGKjZUtgHgvY7adktzl/V5mFE9T111gWK4ng?=
 =?us-ascii?Q?7kM7GKcjdgaDI4G7VmHAdJw/E2ky1Bx9tbONlf2Fil0cgqf4RhrG32O4Xh4n?=
 =?us-ascii?Q?ZvDEUtH//dv8aGEQ805yygkcmJVvtcP97bJwzWpG/nKj8GYkDOMHoa4gl0td?=
 =?us-ascii?Q?TaO/lHKjCg69LIu+qe3IL/UEV3Idzefl6/GXHm3UXBzSG8JSSMpJKgCSwGxd?=
 =?us-ascii?Q?NZuNB20KHOba2e9xeQuJomyy1T7lbsejyFB021f8m+k9s5o/6d6RdjoMAD9b?=
 =?us-ascii?Q?/LcCRuq8rsCYdQmJpjR81v8Vv6y77mDEPS6zf37Z9MByYZeih3HUGJcxS7jz?=
 =?us-ascii?Q?cXDqUKBqUSsJqrNMYYWmH+gTRXEA/qkPFi23XTwwKwMBSHHngd9tHjUgG73g?=
 =?us-ascii?Q?A+9Njw/jvnbTMuu+/GxRfWuCIjpwUCGT4akkE+9Gj9D49dRmXSQDUbNqjhqT?=
 =?us-ascii?Q?Kv5j9eIbUX0IFlsPCVVt3XPYOGIi7JWd6uA9Kw+k0WmyC891NClmlg817nOT?=
 =?us-ascii?Q?EXd6a5jn2rq4sA/S+55QsmJAj9p/yCcAlQ8drwcFPQYV2ZKgBSKKFJfm1cMK?=
 =?us-ascii?Q?HpWZGAFSJ41sTpZFN8wjRKbyZboCv+cP1o4sSd1Yg4UuNeP3Ob4HOKI92tiF?=
 =?us-ascii?Q?4GEA33TFRVtMmSbzKkBq8yEIYwTHyk8j+z34i/wTNrjvXBiqx7ACBUoOF/hW?=
 =?us-ascii?Q?hSF7ZVAUdJU1m6oSZkw7d0EMqk9IHMFCMeIvaV7vm+gFm0PhMjt5j5U6Rimr?=
 =?us-ascii?Q?l2bICcFRmoF3U71DKd8cUn0lIqEaXYeex/Hx9EFQDZ4u6Xk3zHZufcc9rVUS?=
 =?us-ascii?Q?EZSrJ6V01pDQKzgaLGvsiY4Zj4xH5MKmLkV+cX2qQ7IndMMsW8FQ2rAYYYZI?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HmRHAa4owH875Ctb2gb99QbeKMcOMUnM2LcbIoXkO4/Bglcehz0CCS3JpJRwREGXE+mXvfilA9V/HGigW2NbGVl+vwSN3cuc59u6jf8rQA30TtdrneRBI8/7ohivbp0mD3fOsC8uTjgbORhg8b4lo15mVwFXw9EAl7zLui7UqS3lpEyy7Q4k1Ea9yy514WAk8UOoliuWcdyOeGop3s4NaRcXpIyxp55VYgtYdS69HdFP3IC5gVWSCem/tXLJ0q7HesKPlRxoNwrZQse0KlUiZ9qvh9HQSXdgFplbA/eocPulPW0iGEIUvo6CHGwwr2W0GrZvD6SDFytlB/MkhyS2RqKTLLa+VfGVmJOzo23CUszv60KkdWsmQi7gesIYbtCSw7/F9V1veYAEpZ+yPRr5k1RiY5bd5yQfm2NcS2XpvwqRsIzhHNbATuOKjpTNH9NPSxlG17BW6RK3m9o1c4fwX1RAqy4cO/XbcVPSdPlgNVnCxWN/I3fKYsI+d3jJXtjVBkRj1Kx7UCTxMne0pr1CoXc1KKuD0sM7ab7truH9UeEZdYlJVMwxtxvoHgha21PUoPEQcW1i30/zM4GMYs4WaIx14XiggNjZGGnan+pV0lA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af4e1e03-062a-4fdd-93c3-08de225db18a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 02:38:14.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BqZFsCfLg/StXMg1JkLj115GF5+mWqybTxQH1dEAwlff+YUPe1IoVZZQZ+Z+HJgX7cLRXRvTq5po8yMAXDMl5ffnc/ccrFAOLE2JSdl/eck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=747 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130017
X-Proofpoint-GUID: RLnJbLBjBdDPY57h-MoH0ghQYbGpft3V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfXzE6cdavIEDPZ
 tqC7ji9zBnUDjOUK4YhPtrmeG+tvF06ivlirnD3Fbb6sK+glVPVvHUkTTJ9oWlfoACL4hKUt9Dv
 pHwitWXGZoWV3IV9WFMjIy0c+BFlhGjvw9yZgf0Ui32wUfJhtTT4rj26BmFakpmpSxrzZhiGID8
 3ReEnwIjryfMndjbNdAs7dW9bzFviQpkWG/bSzSlvOyTV+GFa1ahH4YawtdBnOdD1FcWZax2EVx
 F0AZhI3gxA1JVgNfzdIH7pGj973LyFdTyd5CSpxT3rbkybspxmKKwlPiEJXJUKn+EyaxqgfIMuY
 u2Yf06AY/k/ahYSIlN5kweaMJGX51pz9TIn22PJdeW5fhh9422frnSmcnzVTZ8afumekEKHWeYL
 Lf8ZCCwIFBHo/Z4hRjOs2qjyzab0vbALjeOK3OmeJFHD+eVhPD0=
X-Proofpoint-ORIG-GUID: RLnJbLBjBdDPY57h-MoH0ghQYbGpft3V
X-Authority-Analysis: v=2.4 cv=HLzO14tv c=1 sm=1 tr=0 ts=691544ae b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=lhTLxpHsTzY95nKMb14A:9 cc=ntf
 awl=host:13634


Marco,

> Let's consider a nohz_full system with isolated CPUs:
> wq_unbound_cpumask is set to the housekeeping CPUs, for !WQ_UNBOUND
> the local CPU is selected.

I applied this series and your other applicable workqueue patches to
6.19/scsi-staging. But ugh, that was a lot of work.

Next time, instead of posting individual patches, please prepare one
comprehensive series for the entire subsystem and submit that as a unit
so I don't have to stitch everything together, deal with dupes, etc.

-- 
Martin K. Petersen
