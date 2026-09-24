Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86A371887;
	Thu, 24 Sep 2026 02:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790218360; cv=fail; b=T8aKxRbNWKsmqCcFWUiHb3Z7xMxGf2VLfz7ymI61aRwumjC42cDUchDBKlu/kTA2eFqq8KWcMdlHBu64+VbQhMgrkvVT8U/dcd9+2eRz+OE3zhF8qb6Zup9+HWTCb/gr0nHzdp3v6XfHPs48HEhvi5ESPqLBTFeVNOeiwhE2Bls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790218360; c=relaxed/simple;
	bh=adh1a9LxRrIQRaCpBKU9pv7GvS6AKNq+AgdNFeluttY=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=HX0/PtRRv0f3Wff9sftKoQMMpTFRDlw+YJw5kUf+yYzCMzcUdtafsigXNu9o7X+l/3cx2pr/QX+zddnUGVxI2HToLa9D5uqRm45AEQIHPgg1HnIghZbR+uIMOD21gzaVCFUd84XT0UhAkRlzNTZWm/PSO96AmPANcCt2/Q5aN/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tCMIVBDe; arc=fail smtp.client-ip=40.93.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tCMIVBDe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rrf6tqIn7V8/tqVHalPAaMsrS+TaBsGfKeRG2qKnRvCS/11wXM1ltIXxLRoM/fz97DK+e0BUV6UJ5cg76U8mA6BWtiU4HoWGQRvhJ7J9ZeWvAODcjMuxtXTkcrN9lswqzZf5dT7uFuTKAL5ZWPZShsILMpTMVOGh+Sc9LQWobi2UyaCT1gzy/qiDknTuLkh19fD9PAd76pUY4B9CCkwaMl/jcHCDIUlBLEgrKhHYaNhMVAJGkHei/I8G3ByoJtJC+WU8vTdpIoaYs4sfoczUGa+xjsBo3C1OCTbRPXwlWhasUwnnNldbtwIJ79YXxN5r4LHb91yDqmWIp+4N54URXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yM5iIU4Az6KRE7DwLvqEvDNeRolw1PHv9BwsT35mHc=;
 b=rIH85O9Q2dfL3CSJ0P2n2lwcaI0OGgP0CDEA2xWaTlBiCzj2N/6P8D5lbST8jBaD9t0TxIf4Ow0KFL34QGUpUcOczx8MQ8QTNsb1c/NbA3cFIOcZjC/4Ll7YHPJ1Cs907lgxHK/qFFPnBgcN0ZkeyOrs+rGNVO/+0h8FpXkpDHot9YfRCQWn3y7EaQfp7PsVoMSP2gq0Cmp/BxLJFHoMqRjghAfQ/y5YXGaCGoLQYHY2N3tvFLRnYrhBNYkpSJhLCUcqjdnSmSxd0q2vwyM0k39Kw14KrcqinrtNM9b5rfHm4OjnxFm+aM1AtkipOcMIVRUju7q9zgStcggljHns7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yM5iIU4Az6KRE7DwLvqEvDNeRolw1PHv9BwsT35mHc=;
 b=tCMIVBDeEtDSS9jLrAYb1ybEqd39vQIl9QNuSd63prGFjsR8FtLMdHm4yI59lLn+LxwvbpNMoYTPQYIC7vw9rjbEU57UkvXNrODEGZb1MOndIhJIq6kCOe7gyOWcpCy4z329N49gzkphDaYVNsWUJUpB+B1pCSJzGJ3bwX5FXDzGGD3XF7ObYTV9Z9SfQU4pgl4kvHdK4Cvz2edXqHvpYrIo+sXh9h0B9oQL5sglDBqlApFu2biPSrdbrl8t5FeO85LnCS4hVXHU7WdJsi2jFbsqlIrKWRv9qzBmXX8GPQufKSfuQ90bLoKJn24RgWjL6wnE8F8HZbVlrYOGcfrA0Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.13; Thu, 24 Sep 2026 02:52:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 02:52:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 23 Sep 2026 22:52:06 -0400
Message-Id: <DLN7FLRJGS5Y.1T8T274W2NS6L@nvidia.com>
Subject: Re: [PATCH v3 04/40] mm: consistently validate VMA state after
 mmap[_prepare] hooks
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
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-4-4583d8a23bca@kernel.org>
X-ClientProxiedBy: IA1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: 1336bf1e-0317-4150-1c3c-08df19e6d425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|6133799003|5023799004|11063799006|22082099003|18002099003|921020|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qemAkzXTKTDzQhkfrMhRpI2txuNGBJfhYzIpf/WeGP3YpK50uv9oCBJAhM0zqjlR24qfENLarVTCdpDkBq0ozYTikbYSnqaPkxD/wzJGUAFB+ZX+NuV/kW3FKn4JJdVFJ3TkRvMxEUfDemfpIq88CHhnLp76KVBVjdmEIyfjQ9F8eAaffEWUVZ2X0v0fFzeL+KIZNzaQ5ixUTmYKcBdyULENUNKJsMOMsLxEW7dlVVOo+8Ckim2ud8DmXspL18s5ORbnzVWYpbW2YdXtMDFuhAKSzE7sZQzhTNUFp17IDzpJHBRhxBYk8PVD9NXYGQc0TS0lUjZ9bNSHL64aA9rd0/xebr6n5xmdBqK4p8MVuYQFqug5JK7NKkiH2fPWCgZWuMRsiikDqE9hyYRTrOQbYk1aUqbdnk/bKjewd30eqQjQKVOAmx9i5HRNs5rzUpvGFneJMMba+3XB2pQ3Ep7j5NCQRoVTYODI/lYRIFdLFF5MbMYpOG+FXQKNab1pEDEZuckBXKUz0E45KAcZtvbmgbotc2L3cDqEExXylT+WR0g9wK18LGpTeVBHl7cfMgcMLDXlNZi9SgW5XI4Eown6255A6kw26OG4ul5i/bmG6YiXs36EoR1j19StR44hkfFuOMZoh3Vx2gUhDESDhwZGeG3beqo73Dv+rDFIlLzrh4dptsvAg+jANY/tJ+CRG2et/Rq45Em/SxB3/zhn4D09/Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(6133799003)(5023799004)(11063799006)(22082099003)(18002099003)(921020)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVplcjAvVVpUekVyMHI2SitkSlU4Qk5SRzYxT0hKY0RLQk55RmpFOGszNFp2?=
 =?utf-8?B?d1Y5ZnBKM3NXeEpVZ2NkNUY1Y0x5WFRHZ3NQUkJSY1ErN2JJR2JoeEhxR3JB?=
 =?utf-8?B?d2lQVUo4RFJwekhaMVdFS3VtUFVMNHBWdW90MWsvN0h1WllVdWxKaHRmTlFD?=
 =?utf-8?B?Y2pTRUozM1ROOVVaL1F1ajZ0S1BlTmp2YkdaZDV6Z0RmMUw4Y3lGdE55UVFH?=
 =?utf-8?B?R1RsWkRlTzdFVVJNQUhpNnYwMmNYOGJGTkZMRXpLalA0TnQ2OWR2T3oyM0gx?=
 =?utf-8?B?YU9aWG9ueUZ1YU5RRHN1SVR6UjZXN0RtaUJWMy9LQVB3dmVIRG1BWnB5MlQr?=
 =?utf-8?B?cGQ4N0VLZDgxeS9iWHllL2hiM2p3bVY1ZHhLajFRRWtUMFFqcFRNS1oxZHZt?=
 =?utf-8?B?S1FlV0hPNjVvdVpwZ2ZKM3FZa3JvZWMwN0UrUUt2Zi81bzVSWlRMbVpmOERR?=
 =?utf-8?B?RkZqTXg1MnJEZ2JqZE1QN2lyb3RlYmRXUGQ0WUtHNHg1ZFlHUExCb084VlJJ?=
 =?utf-8?B?VEFzU01YZXhDWFlNMzBMMVR1YWRGV0xJS3FUZTAzaklDZFlXS3M5WFZLVU12?=
 =?utf-8?B?TWgwaXQ4RUZ5dlp4WGUzc0s3cTRnektBcHVjTkhxbFJZM3JoYWJ5RWJlbEFP?=
 =?utf-8?B?UmFYeU5TN2YzcU5DRFJvdk9ad3AvMnlVMkZ2VWNEWUF1VXMvbDllUmE4YUhr?=
 =?utf-8?B?TndLQm9DWkZlcFhNQWlzQnhzTHJ3L2V2NGVzNUt0b2NNSXp5NjRkMHova3JV?=
 =?utf-8?B?THQyS1ZESWNCV2ZJaDZWdjBCd3hDUE04N2o1UGVhN0Fqdm0rbGV5U2dzUERa?=
 =?utf-8?B?TEN6MnliZzEybXQ5WFlPMTg0RlVDMjBMYWYrSzNUNS9IdWlzRVk3bjVKd0ZV?=
 =?utf-8?B?TGNIWk5GSzBwMm1MOXVNSDIvb1RZaXUzeTc3cGM0V3ZwVHNnNmxRUkxYK0F4?=
 =?utf-8?B?Vk1ZSmxwRjVsNDRxVzM3ZlcvVWU0cm9LbkFwbXBBemtvSkNaSG9ObktSQW5r?=
 =?utf-8?B?eGZvZUx2cWE3Z2NQVWFDaE1paThZRzBjOWRiN2xJb2JoOHdYN0o2aXdsMlg1?=
 =?utf-8?B?LzBxalFpTTQ5TytXMm9Ja2RndWwrcHdRbk1DSS8yeFlZLzdjUUNBYmJRMlVT?=
 =?utf-8?B?bUp3NTVlUU9WTzZQbTlQa0M0YTE5cHFKVjd3RE8zbVhsaUFxbUtRNGhybGRB?=
 =?utf-8?B?ZllDb1VCTmMrMTFwVUpJVHZhaVJoWm14UlpjK0lyaHRYODJnSzBKSzc0Tm9Z?=
 =?utf-8?B?Q1ZZRy9kZERwWjhkOCt1UlByektMWi9TMVZ0RVBoa2hrY3ZZRy9MZjFtQWVt?=
 =?utf-8?B?dG9RN21sWndKcjRHbEpudkNoNUlWNkxwVXV1NTI4c21PM0luK0hySnhRK3B5?=
 =?utf-8?B?Y3lremVBT09LRmpTZ1dnNW1ZTXBVS3VoZjN2M3N6MlRYTnJTNnQzdGpTSkJN?=
 =?utf-8?B?QmlHNTl0MUQxZEVhTkNrWnA4QnQwYlgwNFEyY2lZcU5FT1FHeEpJNUZEbzNJ?=
 =?utf-8?B?aGpRRTgvT2lCYVhLbmFDTGVMMC85RDFVeFhsN0VaZExvNk1rTXI2VndLdDVj?=
 =?utf-8?B?aWFQMmlLS2J5UmVjZ3RqODRwVUthbG80ZEdqQVA0QXk1aVcvU1dTQnlSM2Js?=
 =?utf-8?B?QmQ4L1ZWRUU3aGlaTDF2b2VrMzlReGp6UkhhMnphdXRNSnZ4Y0liMGJaYm9z?=
 =?utf-8?B?VWx4MFJESEhJa0xORDdjY3p0WmE1Qkp2MTZoSmh3WXlJZmlEV2tVU2M4QXdF?=
 =?utf-8?B?aTN2Z0UwSzV3MktFbk56ZzFEOEdKb056L0VsdytlRSsxQzNLb3IyN01ON1Vi?=
 =?utf-8?B?QWk5Z0oyUURGcnhXOXJ5NDVDb2lta2ttQ3psMWgzcnBGRUdVUnUyc3pIOVdt?=
 =?utf-8?B?SVd4SXF1YlpqNFJKRnEyMTFoR0NyYjNTdUVkN21jTzY5elgySGR6NENoTDRW?=
 =?utf-8?B?bEZCdXZYUmVwSEVwMkxOZHR0TURNaDdhdTlRcGFGSGJrU0htb1B1R2g3WEtp?=
 =?utf-8?B?YUJpVG9IcTBvWW4zaCsrZVFPZm13MnF4aE9UczdlRUlDVUJyOEdPWXhzM2dZ?=
 =?utf-8?B?V3FJNStETnMvdkpYRzRuQmdEaFVIR1U5QitjeFNKVWxUdWZLSGRiTnVyWDV5?=
 =?utf-8?B?WTJoUjA3VWRCQ1RSMGQ2aTYwNEJ6ZHNFV1JiUkFGWU9EZktISTZ3SFhSMFRr?=
 =?utf-8?B?SmlVVzltR3o0dTVhdDQ3TEEvSzNiSmFSb29CRlRHUTFDMUFqeVZYZ1JOTXMr?=
 =?utf-8?B?WEFXVjlxY3B5eENUQjJIRHFVckhpbWF3VnhQM0thcEcvN21pTTliRWQwZEMz?=
 =?utf-8?Q?V/r5JoTStyf2LgCpx+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1336bf1e-0317-4150-1c3c-08df19e6d425
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 02:52:10.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bu8jhEyZgLIp1tN8d8dL4Ad1qUuH0Wrhr9tixL2tgWDTDnnSqHpbURWOp23zX0Fr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5745

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked, t=
he
> driver might have done something crazy that is not permitted by the kerne=
l.
>
> Currently we check for three such cases in __mmap_new_file_vma(), but onl=
y
> if the legacy f_op->mmap hook is used:
>
> * Did sparc ADI result in invalid flags?
>
> * Did the driver alter vma->vm_start?
>
> * Did the driver make a file-backed mapping on a read-only file writable?
>
> Generalise these checks for both mmap_prepare and mmap and apply to all
> invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handlin=
g
> in the core VMA code and the mmap_prepare compatibility layer.
>
> Also extend the vm_start check to vm_end also - drivers must not change t=
he
> VMA range at all.
>
> We also WARN_ON_ONCE() on these conditions as they are things that should
> simply not occur in the kernel and it's important to call it out when it
> does.
>
> We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
> actions often manipulate state in the descriptor thus providing the final
> state the VMA will be derived from.
>
> Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
> special regions which are inserted (such as a VDSO or VVAR) also satisfy
> the sanity checks.
>
> This way every VMA established through an mmap hook, whether via mmap() o=
r
> the compatibility layer, or inserted via insert_vm_struct(), has been
> validated. brk() VMAs never pass through a driver hook and so need no suc=
h
> check.
>
> While we're here, also fixup a couple disjoint blocks of #ifdef CONFIG_MM=
U.
>
> Finally, update the VMA userland tests to reflect the change.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h                   |  51 ++++++++++++--------
>  mm/util.c                       |  19 ++++++--
>  mm/vma.c                        | 100 ++++++++++++++++++++++++++++++++++=
------
>  mm/vma.h                        |  25 ++++++++--
>  tools/testing/vma/include/dup.h |  10 ++++
>  5 files changed, 163 insertions(+), 42 deletions(-)
>
<snip>
> +
> +/* Check to ensure a driver hasn't done something crazy. */
> +static int mmap_validate(unsigned long prev_start, unsigned long prev_en=
d,
> +			 unsigned long curr_start, unsigned long curr_end,
> +			 const vma_flags_t *prev_flags,
> +			 const vma_flags_t *curr_flags)
> +{
> +	bool was_maywrite, is_maywrite;
> +
> +	/* Drivers cannot alter the range of the VMA. */
> +	if (WARN_ON_ONCE(prev_start !=3D curr_start || prev_end !=3D curr_end))
> +		return -EINVAL;
> +
> +	was_maywrite =3D vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
> +	is_maywrite =3D vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
> +
> +	/* A driver may not make a previously unwritable mapping writable. */
> +	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))

Is it driver specific or generally applicable to all mmap(_preppare)
operations? Is the comment too specific?

During my LLM quiz, making memfd write seals writable via a
hypothetically wrong shmem_mmap_prepare() implementation is an example
for this WARN_ON_ONCE. It is not driver related. Let me know if I get it
wrong.

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

