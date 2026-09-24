Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6934D90D;
	Thu, 24 Sep 2026 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790278132; cv=fail; b=CoQt+WhuPVPLjyj83kOoWn/p4aopamW/GCxi2+hvdleG6kFiMbrpPGl1h3uXuzpV7xjvyZUytGWRzNq51Vx61CWC9zawe4vt/EhdJQIRaj3QbjLZyKsA1nU93u5fevmUrEagvuY5hG48gD3l36FTGNoTpIhHiO85AgajwC/M98s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790278132; c=relaxed/simple;
	bh=ny8EbEvtbt9iqrScwz/pOR9WAVgerwBO6QW8MPc9WV8=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=SrAeQUaY+VRxAikpUlhi3wrco+SrASGJt/QHC9kVimyWWj+q7knIUqQghwcmbAQjT1GS+nww2caTU4SN5VWAgLZZ9D+UkZXPI5kzztGd+zfp27HJtdptUGAQEbP/WfYzDMKz6JoRhfj65OVxzCmlwWwDbj26V+FQYlDERhIluX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h+WaXW9a; arc=fail smtp.client-ip=52.101.85.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h+WaXW9a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjqlYp28LVRA1tlUe3pHgpcNtzuPmx8HtsSywXuC1NR+ZPFwniUWW/Qm6rQ/0M1T1eyUdRFAEd4TyZEpMXDUX7oVci/J5WN6Cw6jdc4Km+3FjnffxDISj1anGv3tyCEFbWi3iQ94ERo2TKcB00sXxNtAAppYz7pQl2AvHD6W0v1/3VY4YgaFKWzPXc/sUX6GdocahoDGUm4NVoIj2jDau0bhEWnGdHSXeqrsDD2efPXHZMYirzrezZz5WwoBs0FR4uwgkqaW0X7/o4ZxqvD0bdTihipeMxYRvC6blZuLRzqyL5LmaZ50M78kgpyUxYWBVhCaE+jOzUgVi+2LyYoAFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BanIIEJzpCiYkyUQdKsWNp/eZgx6p5TAqP8UPbXSTJI=;
 b=rCFzHE3rtPzAT2pO1Yzb9+YdowGNLOBxmdKJPzpJJD6IKidCRMPbK6PZ5z+9cR6oX80fc+pwQqpVp+/eq+ZB42PvjsF8PINhz7Du6dO0YUlCqhqlcnEkvTCS5xTpWWanNb0KwI52t2gy1ku88ZlP+2M2Jrl56poHrdtNj0QSfpYYi0L9rGr7lwvmJxHIlLMSJtZauH5fd9UtKE3Zfbyic7qOxEQy4hdX+D8pxQW+MvxMMuIZAXVzPKMz0V3olxlw5tQLOaDe8x7j5j8uvyAf3uXAEEOGfuasWqy20pO8VyzVZlkInH3nII0+fPo4my/16ebvh+svHH1agIxvTcPt9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BanIIEJzpCiYkyUQdKsWNp/eZgx6p5TAqP8UPbXSTJI=;
 b=h+WaXW9a+e0rH30DQ/pbEOlAmWReoVVlftVQhSSoR6JAI1e31yewFWsS7UzhNHrs2EmzGy9pOm2lhENGwGL6RqDTm9f17Dmynq4tP/FUIBl9bVFO5Q+XoSJpo7K/7/gz91QJUyA+BsUl5C7rCN55SM91p92IindNt/y2Q4+wt1pTuNYE/tsg2Rn+oCpYKMt7EU64qYRMl2JbBYI5Z/V2mSWsn7YE/pItFbhaoStic+h56FdNtzyDKeKG+AQO7zIWw2AX01TLa6MGmGsWcjNJRdKUGLCTmIENy4/ZXwgyKRJwxws3F+BFlSczhH30reLmIDQEg+aEtEuZm4i8g1+xwQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF4D350AC80.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::993) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 19:28:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 19:28:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 15:28:10 -0400
Message-Id: <DLNSM8R8JS9A.1850RMXAG9NSR@nvidia.com>
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
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set
 actions on a mergeable vma
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0171.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF4D350AC80:EE_
X-MS-Office365-Filtering-Correlation-Id: 81cafa58-af46-454b-9d3b-08df1a71fb9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|921020|56012099006|5023799004|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Ax/xivLGah5Be3D2je1u4kNuIHeKMWbPC8BT9QSSH+82ViHzGTE6r/CWbSFnTw48A101tMVCkTNv/MuXOijbtgoiIzzL1HtzYb/MR4RoYfbXgZ/cB4yb1+rrIDzSnHw/b4WJ1HBHrl/h/ZOaA3Ya4iD5C39QAI9/foOXNKtx12hE9xh97iC2WisOmfoDxHYZetWYVPpM17b9r9RdikF5duFcJuI0Pktc8PQVjeEWLcUTE4MvZU31TEX8yB+V4NLARZ1WgT7FtYoI4z/jcu4FnA9ZCTNrHDGrtlqpDKDa2B7wtYtyIC0xezTlb+st76fncctMnR1NIGRhoTwbha1UzcwvzyfbuXeKyB/tTyrPA+q8O66+1qofEtxIhP4gtCaMr6+Bs+Jp7H1w5vZ78O0OX/zKt5/Ca+HnC1qpQsG+13PRmHe5VuulxrdRKY/9CzlmUwso94qTs2MwxDLK3lc9LZdDbDNFEqQ3A9KHk+UGFHfUuK7qxyOTaqGg3lCG3oaG17gTGLEqHOUvOVpahMvPnFMAY4e2AJc2euiwFraL9hbmisCcu/7LbbZsCjcqODvjrDRzGHXV8PE2abhyv9nwWX8ZeeP5EcEQWtREreZf2/CT4T4+hai04IzuKrL09qfgdLDiERLGkF115Qle7LEfJKzJN+jvdPALyhuFWvkxDqA7nrT65scA85BQ6HmjsjrGyNw4/QqgwBTQIvCu/Q2ZPQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(921020)(56012099006)(5023799004)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFJRa3hZU2JUMFpLQTd3N3EwaUFualBZakRQazRkMDNNN0ptazg1eENRZWtJ?=
 =?utf-8?B?T2M0dTAzUDM4a1pPbEVqaHJxU0ZYOTBjYk1mS0p4VXU1QytOMjNwcGwrMmd1?=
 =?utf-8?B?ZFR4R1lYSytvZFU2U2pKOE1sT2k0eHNONWhqTElQTDFyQXNRaGgyeGwyOXo0?=
 =?utf-8?B?cUhwWmdHdWVvOVUvUHc2TzUyZGJIejVmTHJPMm8wR2dXRDJpV0Y0SWlxSzB5?=
 =?utf-8?B?Vy9vVU1uU2hWOTk0MDdjSzBScW94RVVldnREY3lNcEN5RnViU2FQdUpVYTFH?=
 =?utf-8?B?L2xaVnhnaWt3SE5wMFFIQlRnb0lMOEp5cVVqYXJoSkNIcmNmTVhMSWM0TG8y?=
 =?utf-8?B?QkpGdFh6MWg2dG5hOVA0MSsxQzBSVGZXbHI4RTdCZDA2am9kKy9wVG53WUpu?=
 =?utf-8?B?dkU0Qk1WcUlzcUoraURKOHg1RHJnczl2SXhwK2Q3enRBTkY1b3Q5V3lac1VP?=
 =?utf-8?B?OFJmZktVbmc0NUt3ZEppSFY1cmM2Um9YajAyM2c0dzdSTzVybjN2Z0tadkRG?=
 =?utf-8?B?ZXppQndsSkRDbWpzMzhweFNQN2xXc1F4ZjBNUXJNZ1lCUjM1Z3BSdTE0TzVm?=
 =?utf-8?B?NGZQQTNjTWpxdkx1b0JxYlhYbHdjOHBrMGhCQndBNUlIbGNVY2plWTRCMWpW?=
 =?utf-8?B?VzI4R2RPdlNTQVpmWjR1U0R5NlZnVThpUTYrUitvSlBnRTBKREZjcHkvSGNr?=
 =?utf-8?B?UDhKV3BNWVFnWUp0SjJkZjhZaDhKSzRlUS84V3hSWHVDcHNnd3NsTXgwSUdu?=
 =?utf-8?B?N2FlNmVsbnZoQVN2cmplNmViQ3dJRWxGOGNaRnpYekYreUNzdnpVQmdrTWhV?=
 =?utf-8?B?bTdycHlZaDVjcGZ5eEpFaUJhNlUwVk8zVmRLclpQbXR4c1VBeWpXOFVBS2xy?=
 =?utf-8?B?cDZOcnJTT3VET3cxck9JdmRjNjUrUTdXU2gyN28rZDBnVnBpN3dhQ0R2MXlJ?=
 =?utf-8?B?UUhRcWhvVlFDamJhcE1JbW5CY3ZSVURDamgzSFJCL3NtU1QxSHBSa2Y1Q2Vn?=
 =?utf-8?B?b2FEWHF0bFFIdEMzSUdHMjZuMGREeTFncHpicXNicDV3aVJGQzA4aU9RVHho?=
 =?utf-8?B?dFVwVGFETnlmaWIvNFVuQUhHUU1UV3RYYjNiQ0NYSWFzUDFnbWZqdVlWR2Ro?=
 =?utf-8?B?bDZGakRqd0k1R0I5bDl0UDBxS3A3VHVHSkhrYzkvQkNMRVZyMGIwOUlIaUph?=
 =?utf-8?B?OExMVlV2bU1OM1ZaS2d2dGxDaVVQbzNRVysvK29nYXF6ZDZrczUwZzJObDFv?=
 =?utf-8?B?czZnMVE3QnN6NjZtdGx6T2hCZVg5UFhIOG5pWU50NWFTbHpTenhFdzJmKzhP?=
 =?utf-8?B?QjNYM082Rk9zRmxtd29IblBYODFVU3p1VytabzV3OWxrL04vUWV0RUlteTZl?=
 =?utf-8?B?d3VVcXNCN3NldHhyRzJjSGF1UktycTJaY1FUNDRXVkdiUzZGYmUwOXV5a0hF?=
 =?utf-8?B?REwzdHR1Y3lTbjdpK2pKdDVuc1RETnpKWmx2Tkc5a2tsbklUNFpiR3IzcmxT?=
 =?utf-8?B?emVKdXFMaWJpcTNLbU4wbmYrMVJiU21ab3JVZkdFL0FRb3doOFB3SjVESTdI?=
 =?utf-8?B?a2JuM3NEYnNDcWVvMUxiUDc0NFpzVmtrbnRYZ0s4UnN5eGRIczhrQmxqL2ll?=
 =?utf-8?B?enNWMGVSQzN6Y2R0bTlUR0lSaWpDYUxWWXZFNG9HRXhnejlVTGJPaElRYWs5?=
 =?utf-8?B?eUhnV1JpY2FNbVdXT2VzSVcyZ2Jpc3hJTDZwRmVlUURqSWFZK3ZHdFBlTzl3?=
 =?utf-8?B?aFFNK2xxenNOQlJ1VzJsTDlpZUkrNWJjNGlPZWdwWDlWVUNzUXYrbDllZjUr?=
 =?utf-8?B?K2hCSlpHMTk1bU9IT0R4MVV6OEZYL3dmL2ZhbUFxUmR2RFVEa2IrNVVmcFgx?=
 =?utf-8?B?WGQ1WjFmY2l1SzUwdHdCNGFOS1ZjUXNVVDgxZGZtWG42WHJhTXR0a3JtYmFr?=
 =?utf-8?B?eFFPd2RXdnZhei9TNkRQMi8wR2FLS1U4SGZVeTFpdmYrK2ZYVWEyYkZlWlBw?=
 =?utf-8?B?eUFUUEZmdXRWa241Vm0vTkhnMG9WMEg1bENyc1Nha1N5bDJRQWRzOGx1a3RG?=
 =?utf-8?B?bjNEZ0hUOEFzdC9LZTdrWkpUcEF3b3lqdGRhUzZnZXZuZVVHaERKc09OSXQ1?=
 =?utf-8?B?SjdJRzM5dG1RRlh5N0RDSGs5QkYwczF5UWs0VXhPQzNUVXhrQWQvaEMvT3lq?=
 =?utf-8?B?T0trck9hVkxlWndDN2FSQU1pZGFYOXBVMGVJdzBWSFo1cEhwOEJvaVNNVFVk?=
 =?utf-8?B?N0xjK2JKUS9tN1ZtaVJhMnR3ckFYUE43MmVZVjVTUnpXMUZLMy9veFNVWk1J?=
 =?utf-8?Q?mnhPx5KyssRyBx3roV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cafa58-af46-454b-9d3b-08df1a71fb9d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 19:28:16.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiW9MVdMq6VFSl8GT1lYphVqy9SethyWUgkCOI3oIPh50dtSXfkTKjmN2rT8UU8a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4D350AC80

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index d6ed10cefc8f..62f2ce1ad5a1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start,=
 unsigned long prev_end,
>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>  			  const struct vm_area_desc *desc)
>  {
> +	/*
> +	 * It is not valid to execute mmap actions for VMAs which can be merged=
,

Is it better to say "for VMAs ... after mmap_action_prepare()"? When I
first read this, I wonder why the check is done after
mmap_action_prepare(), which does some work based on action.type. Then,
I realize mmap_action_prepare() changes desc->vma_flags and affect its
mergeablitiy.

> +	 * as any such merge would leave portions of the mapping incorrectly
> +	 * unmapped.
> +	 */
> +	if (vma_flags_can_merge(&desc->vma_flags) &&
> +	    WARN_ON_ONCE(desc->action.type !=3D MMAP_NOTHING))
> +		return -EINVAL;
> +
>  	return mmap_validate(prev_desc->start, prev_desc->end,
>  			     desc->start, desc->end,
>  			     &prev_desc->vma_flags, &desc->vma_flags);


Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

