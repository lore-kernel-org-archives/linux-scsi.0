Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010036.outbound.protection.outlook.com [52.101.201.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC001A38F9;
	Wed, 30 Sep 2026 02:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736463; cv=fail; b=AQPnp4ZC90EDjuifZzfs10ftZLijtneKGD/U+anZC+/OInHIdZ7tk1zJwTjR1SCvcFCVICctMwlCEMjxNQWptUYSV4tcc3DxHEQN8lCLHISLC8e4fDW39zY4YNsgXXGXwDm8LbvAg4qn2id7G63PJ7vEdZFVLH9rd5rwED19pWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736463; c=relaxed/simple;
	bh=xNsa0L9U5oPNFphNUw9STjuK873ZeJ0DhLE1mvubb9w=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=Dj5zvPTpMtuIJGBh+6TghHrIDJbMNzXAijJ2Te8PWzsLn1VRs1ktGBHbTbBIIusMmjKgIBoT04KSpG1HqTkdKHvG3PJ6Yqc4+t2xxlWVNE4zk7zAJWFXFb/mjwaeS5HuwtW6mSps4Dc9MxC1Uj7JOHODoEu4HloNoKvQWN1+5rk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qu76NaPF; arc=fail smtp.client-ip=52.101.201.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qu76NaPF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3YgU02ZlDjikN2TC8QxfsdkF2skbAI8uJCdEoVKOw7NaWVoPJOwKU4DwLka3cOwlfMyc9ePrMA0b5XMi0IHB/15GmiU0XnUW/RkOfSQznICVvmRt440A0KPkfHU2wfHm3MWlVAF48EqFBVLF11fHZzqYfuSyVqTIsYp6UDGtOZcJ+cqvv9MwZL2WcnIRRzj1D1OrOZu9PHQ9vV10x6U8lBDvtp3H9b53F2sQ0EegJRmcYVljMK4dfVey2ZZx92NDSb0WxrfdxE8ww/HIBq1ph7bb1ctc0CwUKUEM0X6oQSILBVA5lRmALV8qcDV1Dr+eTWywCtMImoxROO1ohosdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slmh+m4OI3sCOT9p/QxqNR3n6yNwEi3EPAaROPUCwmU=;
 b=K+aOx5MOoboR+uJzP8iR0YUnWAPfAkSb1mgIsq+30g1ZeEGT5SvVVXI5VNGVWqRFaBrgtadf7cpOFcAhmtU9UyaNB4GNyqQEd1hU95bBA5jQyl1MUWuE3AxalDAPRgUdXzwB95/zAmCYXnPnCAjt1XVK0jJgPHRE92sDsf6LGUs5D4ydaVpuEm2pEPDZ29yF6NLXwd+bNHNVcAECRnsWBqwJsbqXGkCgi1b9hOt1leu7vk84dC89IaWZriQJvnSqkKHTYBUmfVlY4br/w1VmPdrxgy3S/51EkWj51kdwerUahEXJgwRRk2MzZhdiJgOyYG4usRnY0TQYUn4g1v2GCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slmh+m4OI3sCOT9p/QxqNR3n6yNwEi3EPAaROPUCwmU=;
 b=Qu76NaPFnw4kHNh/EM9vBOUwB05jUhcmptzkP0TzQQbJx89J1/1Dby4nORo4g4ofIkX0RjTo+4Mt8CXdD43g8WJ8k7U2mGGU2R8rdauEChQB374bbgA1PzvL7ZTXMDd0VonxV/V6PSGIxk6YotT4Jh8OM7cJ+hk//U9Do+I+nUelo6rgLS/dLHQkh34MiV/C/f6IjYMaYZh/fYW55rRuYFRqfJiohPnnCViyzUW2M42O/SNkWaBVS/Ic95QtUuCMh0QnszCaRopiqZZauNHcUyW+A1fCBZhycfBjOcNnFXKl+q7idJRXF951z6jO5k878z80iPrHBLm/1ssEFXwgIw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Wed, 30 Sep
 2026 02:47:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:47:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:47:22 -0400
Message-Id: <DLSB38ZXYUA7.1UDY2VUSRTTH@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 36/40] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
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
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 95aa10a4-b7b6-4237-79d4-08df1e9d290b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oSOnVAkeAv/Bzd28JsII1mk7FNOFe5QOKd9lk1PqLImLMTc2pFhvOnSfiYrL8nF9dk/oy4e/b0//fe1s/vvM70EDUrQJiu4RWOT8GjHVnsRJckrA79A3rcnvrit2KN1hg5GzGx1R6C0V5UrtYHVu1xb4FAwgBvCHtUp5LjKaRdK05MF29ElXy+bYmaZjz9E31EGOqE1jd1zild96vPU9hanGQF7DYUIfx6d1Qx8LyuugXzL11gh/Zhl7R2OZfFEul50iXANE636UvQuYvQ4tNwdkdjWX1NinRglDeSrln9whfN8pARiDqgoVzv9aoJJucof045XTDEqbNrYpmMsYoM6cRHMDsYXg1jG7JfIfW4mf3q0IgWF6ZviPx/PgR4W+kx2Sv6ERZ+wm2oi6+Df2tapmaAtOYdBP9VN4Yg3OOfoisQPjz9beIj5k1bkpSBKUh9OfofQT8ohEe8JvHgTWMsDapio0lgBXkvcJkraZGv/ajRMRYLstcVugi/3eesa7+1UZ5WvuvHMJGQRPCgOMG6qL9VD3CBosZJECk2ni5mmhfw/SYICiH6zGJYgp8OvfAaJMgxneB5edRW7rkH2S1XbGOXTSsnL7y53YaccMUGQAUtsL8h+xKu3L5NgyboMEASNn83zypCSMOdXB+s4t1Zi5xL4uyGkYEfjcACX2pWCKWjnhyJ8AeQmykVFhML+jnHOjkDPuLtD5Yy/eMN28nQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUdDUmlzOERlVDNUWXZ3RjFEWGFBY1FXcWQ3SlNtVkozOUpzWU5Nc1RwWEYv?=
 =?utf-8?B?VnRKb2YzSm1LcjJ3a2FqZlQxY0RGTTlUWUU3WWI5ZVZ2VDdVZzFmZkhlMmJj?=
 =?utf-8?B?YWlIa1NqWTBNK3Z3WStXdnZQNmwwcGFLVmcvOE45ZDVVZElHdm9waUVjRTQ2?=
 =?utf-8?B?ZVE0ZmpMMlBtcXcrbjNIZDJqZ0paTW9zZ25pcjBwVld2LzFWNWIzSFVmNnNN?=
 =?utf-8?B?QStkQVQwSlFMUHVYQ1g5Y1BXSStNdExSTzUwV29HdXFYcGxLbjlEVjRvQnBi?=
 =?utf-8?B?QS81UmROeTlXSTdqMFpta0QzQ2lsTDJDcHo2ZlJoN1VqUUY5dGVWekpPb1E3?=
 =?utf-8?B?TW16WWpPdUJxMU9xNWRSWnJ1TE15VVNzbTdleDk0VlFZSm1oaWxXVE1mYWNN?=
 =?utf-8?B?TmxKdCtCQ0Fla0txc3pPY1RKU2Z3enpKbC91UVByZFQ2RHZHaXdiSzlaajlN?=
 =?utf-8?B?L3ZjN1pOL0FUZit2MVlRWUNzdWUvaGQzR2gvbzV6eVZNNS9OVU4vTDhZSDQ4?=
 =?utf-8?B?bWQ4TWFYZEdObktpQjk3Vm05T1FYNjhLRjZoOTRjVzlTYmkxUEovTDArc2Ny?=
 =?utf-8?B?clF0NmJ1MVpGRWowQzJ6bi9PbWdod2RnV0FuQ2RMcURhcGZDcTJ1bjUvakt6?=
 =?utf-8?B?bDA3MG1kMHRRR0ZjaWdJV0pwc2lGNWlYVEExRCtSNThWOXVqUHl0SnhVbEdL?=
 =?utf-8?B?ejJIMW1MbUNpUk5NZHVJT1BIeXk0TTk2ekpqQjFvSnlOdXQ3M3o0eDg1UXNU?=
 =?utf-8?B?UjczZWNnRlVtSTFRREU2alFxSkhWeU1sMkRDZFBQVnY3YytIUW93TGpETFZi?=
 =?utf-8?B?dzM1dVI4bFRvdlBNZk5DWFkrZmNNNkoySlFab3JERWhkQW1YV2ZRQWZUazE1?=
 =?utf-8?B?RkxPY2pBbEl2U2ZLY0xGZzM4K3V5akNvRzhjdUhaZ3h0N1JZZFZVWWpQUWth?=
 =?utf-8?B?bkludkJZZzVEcVN2bkRGRWd3SzVxS1psMFM5ZHdEMTlpMVIrMUt0WWNEY0N4?=
 =?utf-8?B?YnV4bTBBbjBySTAzWk9WNUNndDd0aWxZZU1FU3ZQcW1PR3BMNDVsR3pxTU1i?=
 =?utf-8?B?eTh6SENybmxlS1NzNi82ODF5OXNlUEJrNHhDcTlBUTFidGRhMUV2WlhRMVVO?=
 =?utf-8?B?YTMvUXNSQU5qVHB2RHo3WjNhSTFmbmpPODNIeUhIaTJGOFIwdi9xNU4rTUh1?=
 =?utf-8?B?bm9rZ3hDL2x4NzZTYjhua2JmOUxJWWtUWDlEQ2ZRdUFUU3JpVzQ5KzkvLys1?=
 =?utf-8?B?Q3R6bTlmRXkreXYxTkJaZjFOeG5pODI3OEVqM2hZbDFlVEJUY0ZLcmZsSVdW?=
 =?utf-8?B?NytRRE1xejU4RGZ5VmpBaWwrcjZFRUQxRExHNEFmbENJY3BBb3ByUFZwNXZM?=
 =?utf-8?B?cGZGcG1TSC9OWE9zaHdKYk9WU2xidTBaek4zQUZyUVZNMUtTN0x4YXd0b0ZK?=
 =?utf-8?B?Vk5ra3hDTlhaR1JReUMvZVFqVUVydlRUc1BOcEhrRkhONWFpNG5kWGUvNkU2?=
 =?utf-8?B?dGQzQUlwSkpQcEx2cXQzNDdDUUN4dmE3angxanpxNStMRVozR2dlVnE5bTFC?=
 =?utf-8?B?VEt5dmsyWGdvZlFXaWNlbUJqaUFTaU1DdS9VQnF0dE1WQ3FjYnJMTmg0MHJU?=
 =?utf-8?B?NldPWUhyNDVBYzlvajBsS2ZoOXExWnE3WGVQMG9lcGNuQ2tySjRPSDVQSWdw?=
 =?utf-8?B?ZENkdDVPcUprSnhsKytDcDJuQkV3eDhIbTRMTzJ4NFEvMVpReXVtQndPUzVr?=
 =?utf-8?B?TDlZRDFaVEJWK0RPTkNQOVVsbUVrRk8yYTZ2YThYR2R3TDRWVlNxVHhoZ0N0?=
 =?utf-8?B?cytva1VUa2pUY2prNGNHQkZpdmU4SFl3UHBKSlIyUkdBcUwzYzNrb1NKY1lP?=
 =?utf-8?B?Ylc5dkIwbVF2RTB6dHR4SkprRytyR1JoT3RJWUdaNHRkYUJtYXpscTZiMG9W?=
 =?utf-8?B?TTNUNDFIQWM3THlzaE95YVpUV2FJRFY3WU1tbVhDQkJUZE5MT2tpZ3RDZ0ln?=
 =?utf-8?B?VWZUSWxVc2d0dEhmdmJEaXRDU2hJQ2xpallsa2VoTnZ3YStnRHVhSXFhRU1P?=
 =?utf-8?B?MTlTTC9tbHZDd29OcXlYTFBEcXpVNE95NnVuek5Wd1hJL0dTdWlZMTIva3BH?=
 =?utf-8?B?ZDBXOTVDMHdKUzdJbS9YbUFWT0xHd1UySkxzVS9MU2JNNHVsdzBhOFpVZEIv?=
 =?utf-8?B?YUdsWmNVNjRwREdwSmg0QWRZWTE4bFY4SVU1c21uU2h1M29CTkJ2RGpoME5h?=
 =?utf-8?B?NTVpdlhieVhFMjdvdUNXYmFyS0hNZDl3dHN3WG5acEFhZUJuNnZPOGxhUEln?=
 =?utf-8?Q?CQKzA39o9nSdXyB+sD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95aa10a4-b7b6-4237-79d4-08df1e9d290b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:47:25.8843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wW4XsY6UlY8EY22ToHn7hGFUxbaqSChMAjcG4pnwNboh3MRarYC+PhKD03GP8g5w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping=
()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings ma=
y
> set it.
>
> hugetlb mappings remain excluded, as they are fixed mappings.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

