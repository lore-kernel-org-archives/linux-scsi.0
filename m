Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A631A632;
	Tue, 29 Sep 2026 02:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647941; cv=fail; b=Kf72bnslOeYuD5pwIme+6l1lWOmpKyRlEvObBGnJnsgFD/O6PZ1xuWQi2fcNhFzMUemCqRjhA+7vD6cT/YIhQuI5E8eHDum/ZFr7WM1px8Kyx7dvW7ELw8tGu1L1O5JSdG1nSc2B1aGknsdXD3wpfCJLwp++vH77YEjkPX7ybW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647941; c=relaxed/simple;
	bh=AzYIu37u22pHqb/M50reRigPIq7ehHO+XHRnK1k83kc=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=ReAYvP+jiLgGvUjRpDVqr5Az3n/3f5grKXV+RnzxoW7HA8dBhILQLeWEwd0THBRGZeXR3eLrfJ7DGZN3pWK5p2E0r0i78SuJeyYXd6nBWyy6DvbJqvSWaWdt55zEliKK/sXh0GZ+Jc4YQBTBjDs4Bg/PWP97kZGujjDsWYw37/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nbSi06Xg; arc=fail smtp.client-ip=40.93.196.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nbSi06Xg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leeJ8nG6kj+Isq6S32I/3jiDio4VD8pSbkms/J2QD/IoX8aLjHdso07oB/5c35shMYDpTwrel4o7mU4I1FWDN1AFAmeR/3R/NWNSVOl8pcMqS6kOgC5pT9tYA8/Ofn+tXn7rhqOudPS9JUhFuMNxboeOVhrACy5P6LkekpgZv3i5dw80SaSNAGPAMLPxZtg2+iT2IQxUpebjAPr9T0CIrXgCYf8Dqe0eh0+kNpenBcJ9k3zaXNia9AT/8Ieewx7u1VGQb19YkesBEYCMdnAf9p6qVUTkQHMWowi+2t9pL8nWE5ZUz5brT9TpM4o4VOzL/uCBGqII4umw7zkax/LubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rvbe69xBIpzGsOrw6VbYQRORSyH1zSp/rLtFmlWZcCQ=;
 b=BrZGvAynJ4ponUIVOC/cXDvrF1+Etamv2w8qVqOlmhTL8aiE49f6Fr+pOZGCxpsZ8U5TWZJeYCRTF0JCQRuPP55AJVZuwoRVfyelTWQbndJxpUDeg27fFcjsLvOWUBI2Lppn2TBIn+kkt+PdquLDl+M2IX9quoD3CNvn6dG+bzbCQcY8jNjTrlvky7Kvf2JnQ3oXOrvRgEnO3TC7qBz+Li/Di6Uy5qjKJrHOPmtgB+xJpTRvLbcJxCi2zqCf+Oif/79m+P6CKx8IGZcMsnRlxfrvt6nscsBQs4/yY6DxAyUtoYbi9lMgkjHr5wnZKQfQr9weeVUnEx3FaP0LAf7nfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rvbe69xBIpzGsOrw6VbYQRORSyH1zSp/rLtFmlWZcCQ=;
 b=nbSi06XgCR12RiFIHX53tm05VV6tvR8/+VLSfACKpV0nx74Nc/5S3tSezV1wqhbi0cq7fG5akeV+5ugVQEXZx8Ie72mN77tyNZKtIUXyfDpSyG/LqGOli/zt8QYC6byGtv4stGz12SOqQoiRkvlmC5mA4TMRiAQjpdyH1OJDE8LjQT4riv3BdU3C10yuHgc7649NY12R+CP4T1Tx1zYNsnEdcUpL0LVGqJ3HBYH4wwX1QmohJ86A9KA7M9mf/oIfEsTLcjSvbAqkkynzOcQySH2+tGANArdLXGiXQ1vmHAEC4/c4SlOl4OsmwIK78JCfEw4GrAkf2wlBAgXZBE6c6Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:12:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:12:09 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:12:02 -0400
Message-Id: <DLRFPN5JH235.34HHA5QDQGSBT@nvidia.com>
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
Subject: Re: [PATCH v3 25/40] mm/vma: enforce that only kernel-owned
 mappings may set VMA_IO_BIT
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
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0340.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: 929b79cd-7fd3-4fe7-b0ea-08df1dcf10e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	55V5jLLqnKa+bap2rTDpyXvJ3MS2KeCN1v66hI6BgDtw24iIHyBtnFcsj40HGTzEsTDv6VVOvLjR+3RKHA13ORaZjm94lG+Mm6zU/Gi5YMuUYQVpJFkYr14j9O2JEahCemsUkSAvCXrpWSlLjvgVYmWUWb2pMyw+ENNOeNu9ib40HzVvAlZ1hnYPKjBOGJmIhdSQahYFF2kBaQUuxI+GQ4Ggj6FQYrR3/VE+qJZJpfwcECIAFB4twVQa+hLHa0Ve0J3DSJT24HEHLYU4q4AkQdTVE/lEl/AIeXhgOUupKjHD9yu256BAbRce7VT6kw5gebvfaLB6PeRavLv8twn1I6OdyXfs2CsChLXJoeTSySz6laOIKou7jk9lJDIHvpn2NJ5j7FFWDYru8bNGIOYxS1D+oJOd1no8EYCKcS4FoVqOMZu8SxD6nI5W5LesieW6vo4Z8G5btadzb3CVLJi4YBw3XHQLNI+VkzVKhIJ3Kfq7hEkvvjn5jzX89cxCQekRNonJwLSUjc/eR/gZhHhBjnF7/pvLR4MhCfy5mos6X7sd77iTwY9mB+IEyGRt4oEGSOqPdlvWFtngelGgsZMcvRpKdOIJw9eZjxzu9+i3vf8mLI9h8wzHVv4jGxA0NzZEI8IofRgVaKEHJFZm2obMyU03kiQn9zErw/yXQeNHOCl8QWdt64j6Ft1G9PwSg+AhwwMh3EGQOYEH+UNFKOBvCw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmpGRzdZTUhYUEpidGovM2ltbThTWDBuQlNLbW1uZHRGTXl4Y05XRWxVcDVz?=
 =?utf-8?B?YXh6OFhPd3JhNTdtSytoMm91Yi9lVlp0NWJueS9wM3RRMW80QURYV29RUWg1?=
 =?utf-8?B?dnlVRWpVN1pMS2lkZlFOb0U1UGtzeVNkZjFUdFdXcEZTOEVGcWdzcU5zdlpv?=
 =?utf-8?B?QnJnL0JXQjBDVHVsNWt1SFB6LzZGWjlzRWdXTVYvNC9EVFJBTVlSRE9iQUJh?=
 =?utf-8?B?b3cvcWV6NTZXT2dOS1VmVUk2NHBHeE5NbGlYdithNC9VUHV4c1FMcnM3MXpX?=
 =?utf-8?B?cExGellJTFBXOU4xUlpwWkNnSTM1dzU0WkpRTytlNTQydUw2WGtTbHdJSEc4?=
 =?utf-8?B?M0dudWh6d2JMQUVKWWlZajhGMGhHZU9DWUNYckVUWG1YWDA2TFU0SEliL0RN?=
 =?utf-8?B?dERYNHEvQVJzWkNma3hSVndMVCtoc3o1MGhWdVNET3F1MGRjQUxPQmdaRmZC?=
 =?utf-8?B?Nzc5WFhkbVRkcldBdmVvZjF2T2tKVG1iRXdqWGVmdzYxaS80N0U0RWczNkpC?=
 =?utf-8?B?OWFjamVLOVBsVTNJR0U4V2lWVFRxSDJVSGZFZkhrY3BPTmRKei9YbXFuZ21L?=
 =?utf-8?B?UGx4R2VkM0sxMnZhd0RsejdGbTEzcUUxdmRyY2J3Ry9DWXc3Q2lVSHozbng3?=
 =?utf-8?B?c3hQMEJpWWdPdFpqZ3dybUxabmdOK1JQSE5UM0RyOGxRSVBwQzVneXF5UzRi?=
 =?utf-8?B?bEhJM3NMcjNiK1Evd2Y1eFNVRHQ3WnQ3c2RJNTNPZWwzM1dBTDN0RzZZQU1D?=
 =?utf-8?B?QWw2SDNwbCtsa010aEd2aVZoYnBXN1BKd3NxeW42WCtLUmFtdnRzVnkwbVlR?=
 =?utf-8?B?OWxkL1RQNlUrSTBkRTBsZ04zbG9iUy9jYTdqRjVudmg5RDlmWkhwNDRQUFlp?=
 =?utf-8?B?a2l0ZkFOdStOL1V4OVIzbDRFVFB6TWViQVc3OWRUZDducUlDMTZBZTNMcmVD?=
 =?utf-8?B?Ry90emRCTHd3NnQxZWFxelZDM2ttY2xrMklDd3M4dXJwV0Y3b2hhd0lnQnlr?=
 =?utf-8?B?bXlyOWt1NkNJZXc0VjNHLzFFT0NsQ1hwLzgwUzZKQ1VsNkk5eU5rR3F0cWRH?=
 =?utf-8?B?T3Zkc2Q4ZHh0cWhMbkwvQ3JCc0J0OWtuaTRVa1RFbnFBT1BQckJkS1FGN1ZV?=
 =?utf-8?B?QzM3Q2JSVzBzUzFJQWNZN3dOSEErZ2Q2dVl3WEk5dnBFRmxTc0RLWHFtNUZa?=
 =?utf-8?B?V01xWTI0R2hEbnp6d1RiekZGL0wwUzdkVjZ2RFVhTFU1OU5qZ1J2SXZQL05t?=
 =?utf-8?B?SzZSRzRiWWtDZ3MrL1FEVnVNUE1TZzh4UnV4a2w5R2RiQktjdmhWMEo5Y1Yz?=
 =?utf-8?B?YXoyYUQxd2J4WUo5Q0d1TUw0YVBDbUxjbEQwbEZpQStPZjVOQmZTakdTdVkw?=
 =?utf-8?B?elU2ZkZod2JERHpXek94UUJDTFZMVjF1Rnd5bVNTSUJ5bUVQRlpCamtCWkdq?=
 =?utf-8?B?bVJLbG1JS1BCS1dhQ0hMUTJNc3A5UFliOTkrWmdhMzFjbTh6OXZyMk9sa1p4?=
 =?utf-8?B?R2pyelhlU1BMZDg2VFN4SW5XbGdrWmQwOWdHV0l1ejBKS0hzK1AvMmJjRW5q?=
 =?utf-8?B?clh4cjhkb3VNdDA5T3pVNTc4dUFCUEJ2ZzZiSjlhY0pYRmF5Y1RDU1F3OVkw?=
 =?utf-8?B?VG1SdDdFTFRKU2FFL241cnhWNEFKWnRHdW15OXhaTUp2UjF0TnpiMUt4REdE?=
 =?utf-8?B?T01ETHRmdHRXcmpBcThpUE9ocFgrK2huT2N6bElBNWc2MkVEL2YvdHR1Z1M0?=
 =?utf-8?B?UXBkdTc0cVdjWEw4Sld2RHlFUkJnellpaUR5ZGUxNnIwRGJIa0RxY2pGWkFa?=
 =?utf-8?B?aGphNUFOL3c5dG1Lb0w5Y29DampLbGNIbHg4OThUY2NCRG1FTHdxaFg2OG0w?=
 =?utf-8?B?MkoyanMyY3BTVUl6dUZmcjF0MmZLNFZNSGpKY0w0NGtsVWYwOWJZbk9Xb2sy?=
 =?utf-8?B?NTE1Z2ZWZDZjMFVFdnZ5VUJmVmRyV1JDN1ErZFBwZ1E2VlJGQUYrck1WRzRa?=
 =?utf-8?B?aVROVjZRMW5mb1lWY1lZSlh3aVVzeEpWNmp3NGw2RG5oczIrS1YrUTlIYXNX?=
 =?utf-8?B?Zk9XRWt2VFVYc211ZVR4dUwzendWSkg3WWRKYkljWk5pUFNTcGxFMDd6UXE1?=
 =?utf-8?B?WmNHcVJlR1ZSYmRNWHFHdzVyeGJGQ1pRVVQyanhJUmpvUjRNb2dId1k3TDAr?=
 =?utf-8?B?T29MU2QrYTEyMWhudFFBN2FGQTd2ekZDMnJ4c2pubzBOdk9kcTBxSVFRSnJi?=
 =?utf-8?B?K3Y2QWJVRVZ4YmZHbGhFazFSdDdadkp2cEUyMmVQRUdMdzNVaENVd2hFUmxC?=
 =?utf-8?Q?nxE//RYebAqK4lZhk9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929b79cd-7fd3-4fe7-b0ea-08df1dcf10e1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:12:09.0376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGPiS2Ywd+V6AhZ66j60qQ5UQnjbvbizvRjnGHh57Z10grwgY/ZHiviWZgnay2r+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as kernel-owned. The check WARNs and fails the
> mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kern=
el
> mapping.
>
> No functional change intended for in-tree code.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 1db8b218fe64..56a0cd154419 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2787,6 +2787,12 @@ static int mmap_validate_vma_flags(const vma_flags=
_t *flags)
>  		return -EINVAL;
>  #endif
> =20
> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {

I thought why not just using vma_flags_is_kernel_owned(), then realize
that function is still checking VMA_IO_BIT. And you convert it in the
next patch.

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi

