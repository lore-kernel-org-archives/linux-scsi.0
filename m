Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B9E28C009;
	Thu,  1 Oct 2026 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868213; cv=fail; b=qd203AtNfOSCLO01LQ6ARz/ndSgDNzaBaahxgD5gvVBqPBZXOPU7SufrygjZMP9XAbvkJkl7eKBr76jHT7dEAdkFxY64elUyqXJm9QMz8qR6AvILI/gltTmvnYxYTdYGiGYxKPTJvlma8a5sPxez5DFB7Pr+zL2PrUJax91x2y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868213; c=relaxed/simple;
	bh=LLjIzSz7vTK+CgMq4VmaInH+yLMRDJXSMfzx/3bPKXk=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=qIS9FFuPuZK+vjEf24RXUHdw6suId8mEWdkVMZUcVpOFzCdmDoZ0gNu8xz49UuppRBZB/uTCG1/TH7xr07XFbANB373cO8a4VqeXGLor54KXcy+EeH3SO0UAB//U50ZN+lsvGEqhEiGruaUL5yMB4v8OKtra5JrUhc+Dq2aFj0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TQHAzu9e; arc=fail smtp.client-ip=52.101.85.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TQHAzu9e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVEsUqt485td5yMc/TmZTRotg0nefR0Q2UOfcr+3bp6G1ZN9pooY5oUWL7r8OBtGSE0qgZVQYlF9Lc7AoW5QovChvrfKvQw7h7M8/40aR4R8l7VDPOMcoFao4pFCH4zyQtXqUPpoDTXPMN2BRcr7/DdJJLeVQVq7Xd7dVe382zCHnMIsDsYo8m/A9uWV3TEIdU9DwWubDNAqT+v/PjJ0TTfYbSbAqLdCUCn/kz3HP5zPvG9JJiPgVtSp6m+afHSa5S+i4SKpCLIfnRPFzk6JnjALicL0wTth2e1umDfQZUqfN7JaZnY9wPuRnU2LShnsgiNrhorRh6A9kXTLCQB2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I+tLX4sSdDtskFCx4KqZkGPZGt7ceNDv0HpitMg7NQ=;
 b=CSit+SJYKvP/ETHxyIUNRHQ+jhiAiOrh+dZ1lQQqFepeNK87S7iKOZ58szE3+Qr/hdhjuIOG7L2BbEKeJsEecjKCt2zthZEmc2zKndhERsYgTVtBqqQcrRuVG2Zs5Rvo9NerEYtRUUDcWqi0xyYPzfLT3FgMhzoJAUm7bHp7lp1GxwdMXeUS9Rts5azdgo98bsDp4ZXS3XDbM24sZBUTCojAkndrcCjud2wGiiN27u3Uw78wCqaBxrmsYPLjQlnLHotAsIDdt/a8+aMWHtqWjMFBUckvdNDa1w4e8rYZ5rkWg5QuqQo1O/5Bi8CoEifjQmvrvDkNtDeOtjEgzIsyxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I+tLX4sSdDtskFCx4KqZkGPZGt7ceNDv0HpitMg7NQ=;
 b=TQHAzu9eXbAyEIP+3BjNLXEIdQQQMQKJamm3rZcMcnJPZnACCMbPsYtBpO1A++54I0eGEy0Z3wzTA0JAVX5qNZURbB9T+EFeRCupr4c8V/lC4M5D0+27mQasINa0VF4vXwYpHckv9SfQY2FlgdHmwjg++s7630NdHYe6jF/p+L6Mv6h9Na/Dxsuk6ZXbq4OBHCY+0BvshT6O5UBprw8nG1BaJBHhabMAnnLe2O61vEPmi2w42739+qqpwizrdSFuxyAtcAfTw58VaoDbYJrzkW1CBZsUPsDDnEu0hyicM9fBoEMepj0L4IG7Pmy6qQ75VO5UAFMXRX6Oh/A8UOb2iA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB7686.namprd12.prod.outlook.com (2603:10b6:208:422::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Thu, 1 Oct
 2026 15:23:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 1 Oct 2026
 15:23:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Oct 2026 11:23:09 -0400
Message-Id: <DLTLSGL9YVQA.2DGDT17IQEDOR@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-sound@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <sparclinux@vger.kernel.org>, <fuse-devel@lists.linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Stephen Smalley"
 <stephen.smalley.work@gmail.com>, "Jaroslav Kysela" <perex@perex.cz>,
 "Takashi Iwai" <tiwai@suse.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Doug
 Gilbert" <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter"
 <simona@ffwll.ch>, "Helge Deller" <deller@gmx.de>, "Sebastian Reichel"
 <sre@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu"
 <peterx@redhat.com>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "Arnaldo Carvalho de Melo"
 <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent Guittot"
 <vincent.guittot@linaro.org>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "David Airlie"
 <airlied@gmail.com>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Marc Zyngier"
 <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, "Andreas Larsson" <andreas@gaisler.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, "Xu Xin"
 <xu.xin@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 40/40] mm/vma: introduce and use
 vma[_flags]_can_gup()
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQZPR01CA0016.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: 76c5c4a7-3c4c-46f8-9098-08df1fcfead3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|10067099003|11063799006|921020|6133799003|22082099003|18002099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	1twG8QghL+LTBuRZdZe37qTOAySIskxqIpP0AGo3hUOMQZitMd6g8nea0HxR7s6dXP2mMKp9Bz9MiDK4+Rk/baaXMDwUZJKUPsRxWhWfyOw7ukLQd9qwNbQ/4TodQDjDjtTnGz9MnVSWud59f9LIidGxuzjklD3hsUbII4tZcU2upZVw569SQ8WefERt3kE33BNQmNKlIHgRCe8OusaQDxJNJprEiq6+XD2/ahZMj1dg7gseESwTJS57uu964wu0+BopWSE9jLmiFtLpqgV0kvr5FSXTMGpJI3hbG3dPwhmREfMw0GoPTfaP+4CwOBeNIOiSejrR6nI9sMG8FY4fErpOI0mzBElVGaN4e9OivGwG1F6ObB4ZP1J489iUc897Tc3GnFlcAkC5pASErANxPC/7peKVHRQKAqhiiFdMLUZvu/6mCcEmZLm915MnXy5D9OlWi1BA6b9fFQ81poP48/vMI1p5dmudHk3fH4sJvcc9VNeulb5chOluaJJmZ9BQ2C+kOxsV7u60pedoWNmcs/2G5q77zlN7PpFAdeQXSI9Z35Cjr0HNw3ybcsn8lyI2OnG6t3Q6/sJIxo5sxYCb/bmTamRudLfmgCRauPXadYLDAb2B7L20dYwMu0E97GONUaLGr1W+Jqi85Y/GUmCtdoCZHSpdhhd+mplRQNaBZks9B3RVIXqPH6dEB6VFdrguEsQ6LU7oltvMELV3eXXSfA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(10067099003)(11063799006)(921020)(6133799003)(22082099003)(18002099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emMxS0xUMFBwQlp4RmNPa1pWV1hPQXVnYlc0VHFGRHRBK0VwRUpIZGZUdnBa?=
 =?utf-8?B?QjI1LzNNRks2eFJUTkxhdzNZOWhJalJuODJ4eFU0bzVKaXpITEdndElwM2JJ?=
 =?utf-8?B?eUtYT0ROS2RGWjBUbFJsZWViQ2JZYWxoamV2aTVjSEEzK25EK3FIWkx6eGM2?=
 =?utf-8?B?MitVUjVLTHYwL2RWaW5LQ2N3SWovYWtLN1dJbzlvem5TdFdicmdPU2FkWkNu?=
 =?utf-8?B?NXhlK0JubVBQRHpYMnNleXltMDZ4YlRMRnhTQzVjdWR4dU9CWE9aL2lLQUxY?=
 =?utf-8?B?REhVM0pOMHdtRUdjQmdqQW5hR0dMTjVSTUhicWl3RW1NcFd2S0ZQc0dKc1g2?=
 =?utf-8?B?Z2R4RmtCd281R2dBaWVBWHBRT0MvWTJ4R0ZOWmNOOGkrY1ZSVlI5b3UzdklW?=
 =?utf-8?B?R0d2YXRhT2JEVms5T1hWN2JzN09QSDdjajMxZWVzY0JrMWRBL0txMUZCSXFN?=
 =?utf-8?B?TFlYeExMUmRMc2Uzci9GM1BjdkpmZ1d3M2ZBc2tiZGpOMERNRWRlVWxRa0Zl?=
 =?utf-8?B?cHc4QTFRSzFzcml3cFBydEF4bGE3WFQ0dmVlb21DSVp2dXpMRUxENkxZaW1Q?=
 =?utf-8?B?Q3k4bGJnWkJsVTIwYUZuMXJaekZuamcvWG92bGcwUTh1TERSb2loK1BITmJr?=
 =?utf-8?B?cHFXVS9LZFZTbkZuM2hpeWRRMUJ0eFQ3all1aTAyZWlveDVMTnowL0p1YTA0?=
 =?utf-8?B?YThaQm9yUnUxOW8wejlyZjFVSlYvMFhSYXVFWmdzSy94bGxiNEhTTENid09w?=
 =?utf-8?B?YjF1cGo3RldMY05iM1lqTzdBQnplL2twRDBMcGJtNUgwTlBBWjFja2dwVld0?=
 =?utf-8?B?Y01Mak81eFcwdnNKYVc0bSsrUGo4d3VOK0pqK1k4U0xMdGFaT253blFhVTlv?=
 =?utf-8?B?WmxPR3Rjejhrb1MzY0Z5QWxESUVTS3hrL2g2b002SkdUb1FyTVFSMGYzK3Yw?=
 =?utf-8?B?bERkQTQ4WHB0SktXSjJHZW1PMjNFSUpteldxUW9NbWdRTkw3dlZZdks5bzlL?=
 =?utf-8?B?T0R5YmQvMGRXWEovLzdYNk5qcmhVcFU5VUQ0WGthdi9nV0VNOHBULzlaV3Y3?=
 =?utf-8?B?K2o1aHNHN0ZKRzBOTlNKWXhhemhqR3dzcXFhL1JUYjF3WnVkUm5IakZDcllp?=
 =?utf-8?B?M2VxNnhGTm9GTG0zaUhZZXNaV2R3ZlN4MjV0cXBza1FyTDlPZnZLcWY3Nm1t?=
 =?utf-8?B?WUFnTldZbjVkRkM5K2kxUHprbFN0RUU5MFY3d0s3S2NTS29DQmhMWWphTVBC?=
 =?utf-8?B?b1ZYbHB0cWZnY2M1WlA3WUZuLzVOUEJXaTl1TEQ3Mzc2dndiWHBJMlJ2dlNH?=
 =?utf-8?B?cE8ybGFRcVNLclhtU2lxRE56ZXJTM01kakhjZDAwSUF4VzU1NmxleTgvdjNY?=
 =?utf-8?B?amZXVlY0cDRYaHJGZnViUGdaNnE0dk92aDVtTnhGdTc1aTZ0Z1ZZbmhmbGUw?=
 =?utf-8?B?NDJBSVZhRWN4UXk4SktQZ0hOcmE2TFZYTVBwdEN4NnZ0TGtnSy9EWXNrSm00?=
 =?utf-8?B?VWJDUk82eWM0U1hXTXNRTnNGZlozUEFhVE55eEdPTDNBM3E4d1Nna1Ntc3Zi?=
 =?utf-8?B?RHJVMk10cW1mY096QWV6bkNVQ0taR2lNYTlqanVtSGhzeUJMYXdCNXNZZndj?=
 =?utf-8?B?endxWjlYbk51djlMYTFDV1FSODRFRjluNEZkQVZ0My93cGNQbGZIUFdUVWFp?=
 =?utf-8?B?RnJveDJRWXFqdERYOTRycU9IbGhEb1dvSnlQb1NsL05rVVJYRVZIZmI1MjMv?=
 =?utf-8?B?Vlg1RXFwSmtkbmVXMUNOMXhwUDVyUVdLTFVWbkVoa3h2YUV4QldPTzZYaG50?=
 =?utf-8?B?SnNMOUJUditmdG9wRXFIOVRzM0l0ZlVZMWcvL0NKT0ltT3NFdzMxRSt1TFhN?=
 =?utf-8?B?ZTZwWHlxT0NtaHNFdFZ6UE5TWVgyQ3Bxdlh3Z1o1RzVFSzhZVitRNkNSM2pZ?=
 =?utf-8?B?N1FIcG9kc1hYRXhiQlNPMUxxWEdUZzQ0cWEyOEJKelVhRWtUQXZIa3VYS3hF?=
 =?utf-8?B?ZGZnaXVCeS91NVpVdTdSaXFYYm5UdmhFWk1DWmI4ajhRZE9yUkx6R3JadDV5?=
 =?utf-8?B?cDM5Z2tsTFdjb2JxWllFYXZYSSthclJVQ3RyTWl0OUdLMGNPREg3d3N1ejc0?=
 =?utf-8?B?UjVaUmxXZk90anZrZjRtTG5lNnZLcTlkZlN4UzFwemthUjYweitNMWxTQjlG?=
 =?utf-8?B?cm9wQUhaVUFjeTVkRG4xYm55M21zVW9UZmlsOEZoQ2tWbWt5dVR4QzgxUHhM?=
 =?utf-8?B?YlRnZUV2aDVoSmREOTlLRXA3cEZYcHJIZ2pTN25lRTRLSUJQOXMzcXRxcmpQ?=
 =?utf-8?Q?fTZLeOxC795AdVOPCi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c5c4a7-3c4c-46f8-9098-08df1fcfead3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 15:23:17.0514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lo6/yKs2xgO8cAsoFikJ2BNR9Dx7LfFUc24eVWmjmRlVcF7mIZDA1YR2hh9uG6Um
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7686

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
> I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - becau=
se
> PFN maps have no folios which the kernel is permitted to access.
>
> Rather than keeping these checks open-coded, abstract them to
> vma_flags_can_gup() and its VMA wrapper vma_can_gup().
>
> A number of other places make the same check to decide whether a mapping
> can be populated or accessed as GUP would, so update those too.
>
> While here, drop a reference to 'special' and replace a use of the
> deprecated VMA flags API in vma_dump_size().
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  fs/coredump.c      |  4 ++--
>  include/linux/mm.h | 29 +++++++++++++++++++++++++++++
>  mm/gup.c           |  7 +++----
>  mm/hmm.c           |  3 +--
>  mm/memory.c        | 14 ++++++++------
>  mm/mempolicy.c     |  3 ++-
>  6 files changed, 45 insertions(+), 15 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

