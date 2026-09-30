Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177FE3264EA;
	Wed, 30 Sep 2026 02:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736262; cv=fail; b=KSSiEd36cChz6Z2LZoki0W4IMBZEYKv1qKadixVbwTbyl/8bC/mxviqtel398nlmZHnA9MrJwVPTsRTvMVFdeosrbcoDysXxQI4UC7FpDbCDfc/xzZ+uYQSSb4201I0tKe8C6+WPLCCjxgo/TFgxQ7+2ECfcjM/mIUt4kRpYwAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736262; c=relaxed/simple;
	bh=cbcgsGi4l/LORbPLBxFVC73zxFsahchLdeuWOKmyHfA=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=YOcHApMHKnort0MLsSZ3C47I5rK1eXXOSwqymyi7/Vg9uNcb1wMupo25enUvisaLUkgXfVbKYgjrQJxPFV/Q+7VUhK+SYu0a8FrVMAjUsVROkfj/IWFuRD2z9KJjfvtcSRmeUhUJ3V198eiq6vgPhjm0ib4BvHBTluhAPPeYqVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OrEAaZ1B; arc=fail smtp.client-ip=52.101.62.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OrEAaZ1B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtQr6YoSz25cK+etyqfOKLxPKxLtbAOz4SjSCY045+U9aoFgi8BcMssJI7ro7nFpRy8Fdm79WOXP9F07xz26DyR7nuoD69CjzL1T1F5wi+LkHsvspoLs+9DcbDcYfeLQmmlwWyaeqoFcNiyePg0usPhcI9M0tD5tRwStp5dynEUHIpqmXMZxqx2oiRISm5ERnfqjq6b6bz6iVycH9NfLxxs1dxCCacgSvqaW4o/UwJ5WSRV1u5TlMwK+wSNj7phy3jFUK8SSNcv7oHZ4rhTk0Z+ogSWwBVEKcltdfxyKo1zQPUBTxXtNwg/ovsu/688wj5wtT3YrO5V1O4m+Eix8uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+BiEqcYJWjwvFrts5cTJ13CyXfWxmFWki6OqmZ4Yyk=;
 b=roBGLqJqDxwPTrzG+Lsjqxp9BQCWuy0qY9U0DD54OG3nIHAA0QtkL3xxwhI9Jq1yTiW7ac13kRGyea7IR4KQZalciaeItg8Vytc/iIeYH2HYDLYNCV87zkTtsiu4J5X5dkNoKWf3m9e93SXkuyKAwdxxzDNkDduB0AsNwFdV/svzG7AcKhlThEkwuj4VchlyCYeOEzsiHnLjPvZQtvl1Kc+MSRabJeChQ3qVbudMvh5oMaKnKLvVNJSViSfyKe9SMwPAxVHGxqu+gUTfCjkjk3tVnpUvbPUctAr8OYhxvh9Vqg618HrWBQk4bZjVntxMpZE+BrIzQDAumoKf2XJTCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+BiEqcYJWjwvFrts5cTJ13CyXfWxmFWki6OqmZ4Yyk=;
 b=OrEAaZ1BqnLlM/K8+aW0a/A8kb2FLvp/GZt/M+nCSFe3f6hnw+o8zc4yfQfTbwxxtTdc1UefCDr5WKPm1DmVnlxof1bCByBXGfRG3Jkx30HGjG9I7aWaFyowf7BcjAguNl2qnxSIKipCufbiI4qbUnbEZz9osIfKUW+8lbpApYiighm0Ox4nQYGuvGNijE9aebJfQtwCE1zZqIpG/XQ7KvWY0aO3ZH9QYqY+D93KuFEzh1vvfAOgo71dOVti7S5mUyiQHR4EcBmmGDGNa/VzIzDP/stsQRrM8UaD6h4UbiWEuEMVw/7yETwvRizQilU+r9zYYQBY8tiAFFN8TM6Lqg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 02:42:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:42:07 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:42:00 -0400
Message-Id: <DLSAZ4ZQY8Q3.3OKOCCOQAFVCC@nvidia.com>
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
Subject: Re: [PATCH v3 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0280.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb26b6e-b031-4302-30e5-08df1e9c6b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FKdjrhUigjp/mj4l00p6dNSaGADCbUQjUeU9NxoCtL4FESOJDJm5XsA/nJ0ATd/8JJRZb7FYlHM5U2gO3873lgC04i+amKyyNEaizz4tWKXviQI862kGicGpRVSkC4XvLInpSj5I2sxh36fqEwh29klfG0y6BtqoyTmiJs/qWjgH1GhJK8y+6EBQfqGzkANuztJcJtmuVhCI4wtK0Zrze84zTj3mBHustzuxtTeuuFT9ME/93iuO5oZirUfCkKKF7uUJSzvm+3cLutyummxZjPPUs0Q+ZIP3VrUUEKhgHWxYx3WcjpJ3qwMGDX4y2Ky8z2XJbScKc6hrkXk8iJoStOkzCWd6b+XzKWHSwclz3enPiPjZD5FK7EAe0Fka2dlRYz0P6vgrYxTFiFTmTjUOxxNUkGCEVToiG6tMSfmL3rGTLaMXxtEsIu1zm6/kBxE+SIRTnsI0XGEgkfKEFj6nlU71G4+1x9+CyuHlJXZIw95dbISg0SOhR/RNWSGn3TnOiDDFlpZZQu9FyObU4w7AxInswKQefRRXcwSAPw+n0uToCyKOaR1xBQ30LTe4zD2S0FhDxLlQEYA8sKfmhBZQAE3ZbFt2E09wkQhHgBoKGUAeU9a1BnrP0x87lh78CeVKI52rozNqUfdY9sLZqfYLztIU7tQvT5y/5HGvS1n6rGiOoRlTmWf4Dr1mVc656fCSTLZc1G1aJETb55tGWJ0AIw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjRydXM2UVcrL01qa3h3Zlo3TWFaeFJlenpzSlZLbjYwQmJqY0gxcGQ5cnBm?=
 =?utf-8?B?ZE5wTkw2VithY2FXRE9aTTdvQ1JiVFNudnlCRjJSNXJlcURtRmN3U1crMU10?=
 =?utf-8?B?RWVKMW4zTlh1UkF0MnBEaW1QVjBGbDI1U2VjQ2g4bWpHajcyT0pWVzV4RlFM?=
 =?utf-8?B?eHppOFg3OVpQR0M4U1l2L0pCaHg0V0pMTmVmOXdHZnBVdU4yQWZyVWN5eWZD?=
 =?utf-8?B?RjZlTEIydDVTL21MTHRIRlIyajlpTHpYOVlVcVVzdzRnT2NSZUVvV3FmTW1O?=
 =?utf-8?B?b1NpaG9qM0ZvWG5mdXJ4ODdQeEovSk9rblhJeGs5V1FtU2x2a1VMdTBLYW9M?=
 =?utf-8?B?UVRNcklEMENPUWpPcmR2eW4vRkZpQnpDbEFNMzVaSUF0b2Zya1BiV2pxZk8w?=
 =?utf-8?B?MEZ4YUtnUzB4aEZiRFFaeXB4VmNiMnRnN08zWnN6aFRrZ2wwT1NWMS9TNElM?=
 =?utf-8?B?M1dCSFdCRkNWd0hXWitmOGR0eVZhUnZRWDBpWmFSL0tabTJyNWJDVWdrVitV?=
 =?utf-8?B?Y0xGUFBPQ29RVHNhVVVlRStkTUxEbTFEbVYwRzVjeURwU0dZbmkyMllvRm15?=
 =?utf-8?B?b2F4TVRoODZJMjBBOGovODRudEl2NDdJeW1wWFd1ckhWRkRQeW5WdFkxVytG?=
 =?utf-8?B?T2JOZEJnMUl3V2FmeUVucDl6MU55Q0RKdHdNaUZFU2F4M1FxenJTdzlJRnA3?=
 =?utf-8?B?Y1hPM2dWV1ZNQUViUi9tUkV3OEowQW00TTZtaDNlZHd1SFJ4UXp3Q0Z0dGt2?=
 =?utf-8?B?M25LSUNYenUwNTJKRDViRzRYQ3gwWUxLMXBKa0FDbFVKM2hHOVMwWERCc3M4?=
 =?utf-8?B?M2lMMENsUk5WaWNPMGFWby93aHYxZkV5NUd0OHlLUUllWkhURnBZdmgzLzVH?=
 =?utf-8?B?b2FORFd4RjZFL1VlN2FTSHNCMXMrN0lpZG8zOVhLalZ2ZUxpL2JmUVJSNG8w?=
 =?utf-8?B?ejkxME5URjdYbGVscElvNmd5L1B6NWJhRVlBc0FwZUF4b1VjUS9iMFhXd1Mz?=
 =?utf-8?B?cW9zaTlGWUMycW8zNmhUd3pHSWFJQWZPNHJiQ1I1Qi9jdzFSbmdWNTUrYW5m?=
 =?utf-8?B?NmZJUUFWaTRJK2VFSUtJRWVKYnBFRGhCWjRKNVZKQk9DTlV5VUdzWkJHdkxk?=
 =?utf-8?B?Yjd5ZE9QNTA3SEZLVzBLUTJ2cy9mc1VERzE3M3RHRkFhN0hsRkNhd0FXSnpu?=
 =?utf-8?B?WlUzbXhjZXdnMW8xUkkxQUtkeTdXSXhPNmJvdXpUVStOai9KcE5HaXVqbjZj?=
 =?utf-8?B?blMvN1ZHdUc0WW1RaCs5MWVtTWdjajhkZldoQkV0d2ZKY29rY2hOU24zakZo?=
 =?utf-8?B?Q3JNT1l1NmRrNG9oVDFtWHd0USt5Y01WOFFmK3F0S1dndDFPSmVDNGJROEY4?=
 =?utf-8?B?UktLMGY3TER6eDBGd0o3dmwwYnc4U0lSMU42STlXM3VEajdwUGNEZDlnSjhJ?=
 =?utf-8?B?VWdQYis0UnJORERSRE52MGJYVVpHNWlWK2wrL2MzQ21heFlGbXhRWjNKek1G?=
 =?utf-8?B?TG1VSWtRcHVneHliZmZBQjBPTlZnclgvYmpXYSs0QmlXUnlST1dhODQxYUpI?=
 =?utf-8?B?ejc0R0JvN3MyUWxEL2l2K2dieGNmTTh2QlEzRjk2QU5GOEJiYkF6WFJMcVpp?=
 =?utf-8?B?R0E1clpCemFJVHNKWURIamlEdzVVMnFxV01PcDQ2azlGOWtjVUxScnRvbGhB?=
 =?utf-8?B?WVVjZHhxc2hnUmRZNjVaN0RTNTJWVXE4WGR5N0xMSnlDQlRCckZUOHp4Tytz?=
 =?utf-8?B?bnRRcDl4aGNEMlhlYWpncGk4RldMR3VjUHlSbWpPOTVhNjUxb2xqd1Q3NlFL?=
 =?utf-8?B?UlBJYyt0aERWL3kyclJkem9kdlhqRk0yejcrc3hiK2NCS3ZkTk5jWEV1WXNn?=
 =?utf-8?B?SXJEOG9Fa21iK1BxT3NsUm9JNDRmZ1lJSkl4bkJxR245YkFhMXVLYmJvOGl2?=
 =?utf-8?B?dXk1T3U5YVp3VU1sZi9DRGFYc3FVbzdrMUJZTXFVbzFJRUYxZytnODlYUjhy?=
 =?utf-8?B?cnVGWnR3bDYwV0UrWEg2cXhZb0EydGlFSzFqUmc3c25rVHhTNnUyNkdkeW5F?=
 =?utf-8?B?cXpQTzZrajlkY1E1bGVLSWp0eEpWREVGTTV4UVd4OE5qT0VTQkNzRnpZNjNv?=
 =?utf-8?B?QWRYQkdFemcyVkdwM0VKZEMzaVU3b3czZWlDQVE3RnRVUzhZMG4yQlIxRTdM?=
 =?utf-8?B?QzdHSFRuOTVHS1doaERQa1c1bVV1UDNrUzJYUnpIOGRyRGxrZDRDMTZDV2hw?=
 =?utf-8?B?TFF6RmlHTC9yczBPemVsNXN0Q2RINVArNUlYTHJ2U0tmSUdzZ3N1MHJmUUpj?=
 =?utf-8?Q?d799MV+pP2HZVfsgzG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb26b6e-b031-4302-30e5-08df1e9c6b25
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:42:07.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPzcFbRknJXG+K0vzcHYWrwlsklx2uZNMDavAZ2xb5nOck9YW7oSxG/c83m7ASbk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
> mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
> VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
>
> This is precisely a test for a kernel-owned or fixed mapping.
>
> Update a number of callsites which already explicitly handle hugetlb
> mappings.
>
> vma_supports_mlock() and ksm_compatible() also explicitly bail on droppab=
le
> mappings - detecting kernel-owned, fixed or droppable mappings is handled
> by vma_is_persistent(), so in these cases use this predicate.
>
> should_skip_vma() tests for locked, kernel-owned or fixed memory (having
> already excluded hugetlb mappings) so simply test for those there.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h | 4 +---
>  mm/ksm.c      | 4 +---
>  mm/vmscan.c   | 3 ++-
>  3 files changed, 4 insertions(+), 7 deletions(-)
>

<snip>

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 12ed3388ee41..09ff20c3df5b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, uns=
igned long end, struct mm_wal
>  	if (!vma_has_recency(vma))
>  		return true;
> =20
> -	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
> +	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||

At this point, mmap_lock is held, there is no mlock WIP, so
VMA_LOCKED_BIT is enough.

> +	    vma_is_fixed_mapping(vma))
>  		return true;
> =20
>  	if (vma =3D=3D get_gate_vma(vma->vm_mm))

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

