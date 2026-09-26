Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012006.outbound.protection.outlook.com [40.93.195.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2431A23E342;
	Sat, 26 Sep 2026 01:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790386695; cv=fail; b=UXOhxuiVEECGzNtHDqLSgoxQbTsph8lU9k43lC+CCT5BWNylQvPxJ2nwuMYCIj16G76PMZa9j7O7gv5ZslCl8U0MxLiT/06NQHOyFx2n9mXx+nOzRBeBmwt6SKWdO3sY/lKQutne572BvR3H6f9c9jzrE7cE+diuVfUDbA575Co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790386695; c=relaxed/simple;
	bh=hhnMCREZn0wq22a1StCnKPL4mhTvb6SRHqhHvgtkBBA=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=jW3kOpFfLGFIYl/RGdUOBqaj0oSFOLXDSVX91ljv/wn6kWG8DlRkLfJ0fgsRUj5DcSM2jf5gLH1kNo3LEqdKb+l0uxg6O2grZLF/Bhuu6Do658WFzN72RaLafkKkXXlmTBS7pSdocdUuvKrQI2h9XzcCL1Jab6mmolmJqw3Sjmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IlgmnWC0; arc=fail smtp.client-ip=40.93.195.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IlgmnWC0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nvoe+6KAlh9q4MhGIK0UDQg/EYvSIh2qF+dvQtLnaboA6F7xJf45zMPl4q4fHZU0OJUh8HSsJVmE+3Q/i7meFV3A0zxihk9GcXjL1IjsQaOdboX6Dce+eIlFc93YkfHXHKVo/5MYa5stBSjMCAOYLKpsLk0h2f2BGedQT6MezOF4pwePlBRHceI1sEvTRj8IEEdxP3T+E9mzhrZXnAAaMLLAJt3k/I/F4LJqcizZCxxqSYDh9f9k2Z8xDhPcNfvQT57QkUg5W1kZFE/Rlme4J8WpMIW/KloP5mHk3NKbHTA/DzZ3yz2c8vscKf+Ye47u1tRQaB8nC1isIjJKWEsOfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JREHSo7U9IfHqKqetOS7hWZc9sDxByVpwPxnE1Mw09Q=;
 b=Lyfs+cJXBtFi26dK2WzE1vLfJgTzu0rLEXIprhcRJEtkHEGB3btLmSrHNXF1N7sLQkC89iKPaiDFCn9ujAwXqTHa7ispVK3tEGbXSd3Gt8wHeSCFOG5CP1bA+YIcNg/PFVKw8jh6RynlifufJ18AbHnUwzqAqQJkKRCn3as50kXFz1ABQ4bKZtJ2CcWRc4SF7sAFHEW7993Q7bZ1ilUhGY0vcAfIvthpSWq5gM988ct10JOJGI5YIGfCLU7t+TfdYgntcgjU3rTxMACfI1oaEXlZyJ9Q2yQZxDfyVgrKts1cbtImiXfZIO4zayZKI0WjHAaC/nv7zSsb6vbdMbP1lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JREHSo7U9IfHqKqetOS7hWZc9sDxByVpwPxnE1Mw09Q=;
 b=IlgmnWC0rE/hjKPkhzRPb5WBKdrd91VzGb7XPPYpP5meQ00MvavGEh4qjtsyoZP47yfHwesFTsYgyv6rAG7Fg9yAlaLmNQ59TqwjXR29YNzE1THb2BQVwxIHHaCS1hst/i0F4Wguk99xqh/n/K/6xO6icloPdsORyojdNMRxFcd33r4WTjqlHzIC6nA14gkuVNw0pLzhwGdW7DKvTw/lAYVAt0m+xNx8qyfIb30szdMOvYVHyEWp24RWz9knmUEGcWlvd3SwsOlVULHF/7bGWxqtZIugT12i4CjvfOdhDo9P6efBbf2kyfzXQU+9DyJxtO03gsFhkEm1AdMqLvqRXQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7502.namprd12.prod.outlook.com (2603:10b6:8:112::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Sat, 26 Sep
 2026 01:37:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 01:37:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Sep 2026 21:37:54 -0400
Message-Id: <DLOV3VTNOBPL.193R3V124JURK@nvidia.com>
Subject: Re: [PATCH v3 15/40] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-15-4583d8a23bca@kernel.org>
X-ClientProxiedBy: IA1P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: 545be6ab-443e-42d1-8b0e-08df1b6ecb54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|921020|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eHTozzARUAPxautQc1g9RpS1Mb919g7GvHX3YmPnOtBZeaoLZ2ADMz+gWYvXqcBVfq/FUJK8gjMMH2y0ELwdrLt+g3ZaKBBKL2Aq6L91xZ/b8Z/T5lDVyXK1dpD2Pov8FrLNOeXQs+GYiqCX6OSOY6YCwg5dXXvudw7uPOkLjf8dCh/p6nKZ3dvvozUzcnGsoxrdd1dpdYuTc93yE/y+N5+D6RztFnm/J8jQw2FjjIrAd7FzboO6ea8fUMUExYKd2zdrcq/q6rXQ0vNqbK+BDfGXXojKaFHMZ/Ht64s1CmfYNlDHGgKumfO1ZmvrGqlTyme2BOsPiH4uksM1oDVZOgx69LGbUAZb/kmF0utEFkbjFBOl+uwUelfb54j+xpHwJbyaq5hE8fymtnL5lovlenfoRpXFqj6R7A6Zjjz5aUeC4uUVHjOFBWErnsUaX8QUj78oVnPDlb2FWFZaRY2oxlTG0Vt2r9czLLJip6jcjS9uLAONOZDvyJp79gbotv1T7g4nMpVCZNvu5Xc+OripRjMiQpS6kAI7rioDX/nvLESDj4jSXBmjy8hVDtFp1c477E/59qTwUfyMxhPPCdpTDFUCrfWUYFh3HNdaAfDnmZM0GSzhnOvIKXg4QhY7XRl87YD4E0Gf7XudDGBaDjOJLN61JB85VYqgNqTj8gVDEWrzjYP0XgbOOxT8KgOMnBUdiYItMPnw0O5m5YcY/q7eqA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXZjcnl1QlloWUJQWStML09WWWNZSG9pWHFXZ0lOR3lSUERERUVJZlk1SzVu?=
 =?utf-8?B?VTZDQ0dOaFJpL3BYWWNKc3FtT1RvS0kxcDdrdWpRTFZta2pxZTRJZ3R6RHhT?=
 =?utf-8?B?T29ZU1lvSEZpdFh3VGtFN1padUphVEZsZS85SS9SZS9TaTJMd2JHS3FvNDYx?=
 =?utf-8?B?TnVyQy95SFlnYytwb1ZZZFdXTm1mMitoUmNVYmNNcWpHZUt3NUlFMEZuVGJk?=
 =?utf-8?B?Q0VqMHNSa3JndVYrbGNUL2NrYjdkelV2d3U2bVBxR1RrbC9QWWtITnR6RGd3?=
 =?utf-8?B?UTk3K2N5azEwYUx5NytSU0poUnV2cys1NnJaUm1Bclkwd2kzcFBVbnRPVmNU?=
 =?utf-8?B?R291b2pVYzVEYVdsdUhVSmVVa3F3OXhrMm1yd0lXMFNKTzM3T0lZMmlnd2xE?=
 =?utf-8?B?RUY0K05IZVlkK3V1cStDdFJOU012RDNBSERJUDdQdmo5cVJnMlFMalJmYUY0?=
 =?utf-8?B?N29ockJXVWZLRkcwTVlNMXZzZlJwSmdJYWJrcFk2Uk9mWTdITGRmalRFYllw?=
 =?utf-8?B?dkRObXFCcHI3SGVpcm1Xd3hJb01xYXY3MjZTTVRPV0hyYlJDK2hGZzd5VC9r?=
 =?utf-8?B?aUR3OStZN1lIckdZaVk2aVRBTE5EZlVpcGFqRENPeHBVS0VPZmNiVUFra29n?=
 =?utf-8?B?ajRtaTYzb2sraUs2ek5KM2NvTktDOGt2NmY3Tnp4bGZSQ2lDRnEzbUkzRkYw?=
 =?utf-8?B?S0VBa3dnOEZYT0tQNzNRb2wwSGVYY3hTa083YkhsRmYrdlFiZjhhTmxTc2ho?=
 =?utf-8?B?SXU1UCswTWs5VDlEVTJjNHZpTy91Q2FUT3dnQ0l1Z2E1RWVpYUxOdjRUa1dN?=
 =?utf-8?B?R3FaeGNoM01xTFh0NVdvTVZiSXpEcUhmbEUrdXpJNUZTTmFDeit3Y3pQd3ox?=
 =?utf-8?B?VUtoZjVtcGN6MmN4ZlowcFFCaTlvVmtIWDA0YzlrUmpxQ2RXckxEdzJGanV4?=
 =?utf-8?B?Y1JMaUtqS0FKUFlwMWRSZkZhcVBJYWV6YTFXZ05HcnRWOStieWQvYkZmdXlx?=
 =?utf-8?B?dmhwL0ZUS2ZkdnRZcjNhb0M2cENFUzYvV005R2JqbUFXZWlwUmcyRFU0YnJJ?=
 =?utf-8?B?ZVl2LytselRKOUVCQS9IYUNCeDJ3aURTWEpnRW1kaktsdXluWmREc3JVYW04?=
 =?utf-8?B?cjlnM3FwK3d6cnkwa1YwMVFUbHF0VS94VVJNMytQNkkrSk5QQXhGZ1J6WWVi?=
 =?utf-8?B?eC9UUjhtaFpEbUJzVUx1SGJhMVR6aVZyVWJvQ3YvMXlaZW9IVW9JQ2pJUUZp?=
 =?utf-8?B?N3NYU0xCLzNiMkpxSDc1SndpLzlNenJnTVlCTGNPWXJzdnYrdGk0b2lxRENs?=
 =?utf-8?B?ZzM0NUQ4UEU0MFJoaDBxSVhjWmRkSW5oYmpEYldISzJRRXRHWmUrV05Fb1du?=
 =?utf-8?B?c3lCU1FqdXhIbkpWaDhMeFBNTm5WMnRHbXJhY1lwb3hIVktkMWhyUnZjRjhM?=
 =?utf-8?B?N2JWRWtPbXRjQWo1SVpwRzBSTldzREN3WFZSTDRJUlE1Wi9pNVhwcWRlVEd1?=
 =?utf-8?B?N1YwY0FNWmMrZjcxR0ZmWEVHbTNVeWs5R3NkNktYemRDL1ZVWUpqdmtLd3Ew?=
 =?utf-8?B?Mno2ekFjWEdpcmJHME4renB5cFFRMDlPa2VDbUNIdW50VUUvelJ1ZTY5UlB5?=
 =?utf-8?B?NGNOR3RZck9HWEh1YndsVTEzaVNaOURzUFFJVmY4RmRjRmx3ZXNpL2hTNUpq?=
 =?utf-8?B?MFltV2hJeXNDOVlWaEY5WTBhc2ZPd3dZd0l6UXdreTdNLytsZ2ZxZlRMbzhQ?=
 =?utf-8?B?UUlCUGVUYktwVzMyOGFwVlJKVlJlN1NKUy9zeFM5cDNvdG5aSUVReWxXVHFm?=
 =?utf-8?B?a0Y4OFMyUEVmVFQ5Tk0yeDQxeXQvQmFZaFN0U2ZObnRlMXlxNmJZdG12WldI?=
 =?utf-8?B?aWh6TlNFb0RsNjdlbmVjdVpXK3RTWnhtVTR2YUVLWHE0VFB4aldNS3dYWVBn?=
 =?utf-8?B?b0J3MlpTVUVzTFFNR3EzL25Ga1B3MzdFZlNoeWRGWTcyZ0N4SS9BSm05SFJV?=
 =?utf-8?B?YXUrSDNNTHFQbGJEQ2d5TFpKaVIwSVJPeWM2eGY4QlRxaEVXYTNUc0VOSDRO?=
 =?utf-8?B?Qk02djV0blVQOWJvWENoK21JYVRwUEI0UURKQ3BCTktaNFpxa3FFNDJ5RXU2?=
 =?utf-8?B?N1VwSVM2MDIxMzhhUE1xSC9wbU1vRTR2YVBRdDc5SGtFYTlRNHhwWUFqZWha?=
 =?utf-8?B?a21xTU8xaHF5Q0h2UnZ5cDBMN0cyUkpUS1lNYzlkVVJ0MUdiUGpvOFJEUXNv?=
 =?utf-8?B?dFVKckJMb3ZEeUlxcFNCRk1zeVpSMzdtb01lMERLSHVaWlBoMnBJbDF1aDZR?=
 =?utf-8?Q?8VYEs3y2DAyj0D4u5q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 545be6ab-443e-42d1-8b0e-08df1b6ecb54
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 01:37:58.3051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iG06bl6AsetwrGy8rU0jwt7ivW5xr1TeQD552YR9eamAkcxdA76zYOCom8MtghrX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7502

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
> or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
> determining VMA mergeability.
>
> Either flag means the contents of the mapping are owned by the kernel,
> usually a driver, rather than by the core mm: the memory may be MMIO,
> kernel-allocated pages or even ordinary pages the driver maps itself, but
> the core must not populate, reclaim, migrate, copy-on-write or merge the
> range on its own initiative.
>
> We initially also include VMA_IO_BIT here, as by implication, these must =
be
> kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
> while locking them, which is addressed later in this series.)
>
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
>
> This forms the basis of further work intended to improve how we express V=
MA
> properties such as this.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 56 +++++++++++++++++++++++++++++++++++=
+++++-
>  tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
>  2 files changed, 83 insertions(+), 2 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

