Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011022.outbound.protection.outlook.com [52.101.57.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CFB21CFE0;
	Tue, 29 Sep 2026 02:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790648031; cv=fail; b=f0d5/FNgueLvQbvv1B0fLP7Lze4nj/a6HW5qwzIZx+nztyxUI9G+ZiuJcUGD57v/wCidS44eT8RTPC18CwC/CIz1wVkOuu0ab1L/P0aVp0VTd3h/H9KajRSBPOZdFgLDz4I6l66Pwva55TCbuAQOhUZd5FQPkcL3Z5P5PTWtAQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790648031; c=relaxed/simple;
	bh=r++4a+lOc5/obwH40oRfjlNNxBSkiFui/OzN2A9dXrg=;
	h=Content-Type:Date:Message-Id:To:From:Subject:Cc:References:
	 In-Reply-To:MIME-Version; b=F/aGksBgOVkZUiR+s1S17yQgux1CotgARV0uHxE2iaax43GaJ5FOCwro2gVat/0TgENh6TAcv3Zruj5Hez6E0sjlR35z/k9CxgpRM482JOI5AfuNrCHTCpzFJyOQ6AT1V2tt8CdlOXF+j+8dxB0zkShKtLTDlWVY9a01IiM6tvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gK0HlgOE; arc=fail smtp.client-ip=52.101.57.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gK0HlgOE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kndv6K/gkpHHcqqbKJNg4MobTOUk8eXMpQSh5Jwq/FtbCP/UCZ03QQN7KTGYvVMsSUmZVSyC/hsEepiMb69COGam2ByIXWKikCakjKV3SF5he8NHTb2v2n3kfWPv+1bk4NkbMv3HKF/EfiUzCiE5xTnAe3Oj5+dX3GN4eMCwO63nmr9OSf54ia/hbjS5kwkB3pIo5WyHvrtvc6RAWymjaKUnXXepfQfQ2qvis0t+G0ecMPqute+GYEnHBu2vs7HALMB9nJZBnUOK+sxC6zqmmeQqoaF5b0Sr2Zbpx/Av3DXHpTvOZUCBv2SjvEtchJt5hPY0zqsfpKsCl1Ykg52rlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEB4tNONA3VNJjsg5URbR6nEereDrePFKYJqV1Jy6p0=;
 b=gqkLtD/oSvpRuGB6Fi5MeFx4GG2IprroanvLC5r0W30LL5bIYpR4yKcv4EpGYXgjY2MOpPc8ifo3lCWm9l+oC4gbGKZ05/MijYZlUqt+aVkECVmhm9+70svHIHOnKjgDcJo9G18u2xq6Oodm3xP+0Ww/AcXpEnn7oVySJUSBzYM2T5lyJWf2MC3ZBT6Yk+UCegl+sO8N8FdfOtShiGRCAN5s4QyfVhPTmLa/4hbtpv+kr6PprOIfbOpHQ2Jqhych74JXdessrEd9b31oTqJ8Od19NGDz4AXJ2qz7r9JwNZFrwi7ajLmjkw862yiPD+yKHl5GyRUCQSi8nMiSQXF6qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEB4tNONA3VNJjsg5URbR6nEereDrePFKYJqV1Jy6p0=;
 b=gK0HlgOE/vt3kvQlVm3aYAWALkWE7GV4N5vYEDSyU9vSAqXc15HITdFyB6TymZ8ujroAR3xAf7r2maYXL3dNcx8sQGblMex2LGy2vqzi6rQL1NvC8B8ak2DJKODzc+INhcYTmqyffP01B8YncchNW/T5id+994y/C/NfvCEh/zVkF4SrDOpnrd5iTx99iyAmK9Eb7w6o/SxUzHKcWz0CPq1pshlba1KvOSJfEJxv8W3gxBsC/kiKHdfzW50wT7aR93eR56S/HtSX55TNOAu3mLf6wneadOsl6j65beIJN+HTVdCHIME7MTZNWiW7OOX8uOe9UyhEygpz7gaj3k45Aw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:13:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:13:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:13:32 -0400
Message-Id: <DLRFQSFTXWCQ.23VDJM6S7C2DG@nvidia.com>
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
Subject: Re: [PATCH v3 27/40] mm: remove hugetlb_inline.h
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BL1PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d718503-ba0a-45a6-3484-08df1dcf4411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|10067099003|4143699003|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	chHGoarCm/pYiGB+1058Tl/Wypu4cHG1dGQTOvPCKbFVpmLIR1aJ3cryuGrBFBiiwFsRcCK/h1PGrSvO4rvggq1zujbHL2haj8BUz0cI2cnfCu4lWAlEzMeqZe8sRTFzVH4c3XgSw0Q7EZ+0uVq8bdN5zVwx8laCMYGPN52n/+Liv8MCe1+tJX31a2U0O7fxAOD+AEojoCjD5QOUmw0JjsPGfQhKxIwyQM3UFph3fw4mLTtriMze9acDVus8iibaGKQeVL9YXm6dQlJ7htXgWzviy55Ng/pXW3gKlVGuQv742vD+QseXre1V6+D+w4qA37r/fkZoFPrKpPUdjni8PHZ8o72VJdpB6D8hn1DufooUFYmo0EoA0zDB51h2BPxU112lGd2pszJQmKzsT/T/wGCrcavd4kZu0uv/RIFyFymNqvzoyXE3DlNrm0xHUvMN5TemecpqCUdM73nzu9x61L/XS5VWjG/H2vUxAVuduCSJI6vcvWWVt1SOgFJ9+t0PARz7BZaqXnWup2TV/6Bm6fmUfMsD0xTgwKY2ID/OL2lqBKhDbhKXP+ujVhD3N6o7YxsAhmCmwIz3ycp4eK1pl5INace+do60UrrNYG5rn9YJt+MZ3FvPDECrK7GMe8+yBc6fRESxjaDzzqJyXx3eLxxJDDQZ5orq5T9AD8uPAo/T4xgW82iIHim3spgk50JTmivi2BpS0rEjwWPr09Y+Tg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXU3M1FPSGQySU5iTzg5TmQ1bVFjVzVmUHpqZW5ZU1NnT1dvZXgrOVlpSjBs?=
 =?utf-8?B?dmZkVTB5c2c2bEhpVEhOSFhjRzBMTkFOeVBvcEtvSXliLzl3MnJoQ0RLOTJU?=
 =?utf-8?B?T1lxQVFsQUdTcUMwTUFtcVNCN0RaZWdwQTEwa2xHS1ZhbmhqT3hldmdnOVVo?=
 =?utf-8?B?bnAvNDVpQXNPT3FnYUVPME9lNno3RFdIQ3NOaTZacEpQTVYvQUVLYVk2YThP?=
 =?utf-8?B?dHV1dkhRZFhyVTNFVnd6YlVtQmJONktGdUhENUpCN25SdUZZR0FoR0Voc1Bq?=
 =?utf-8?B?QWxWalRvbVFobWxjYXpxcWF3MHBMdWFvSEVhK1dlZVZIajQ3SlpjckNLQnA0?=
 =?utf-8?B?K3FpSk1walRvZ1QvdjhmSkd5V3lpeWFLU2JIZmxTRm5QUXRqaWFieVpiMjlq?=
 =?utf-8?B?Rk45YW9jTndPVE5ySCtxWnVuc0E3V3ozUkw4ZllEa3BGZytySkl1eiszYjk4?=
 =?utf-8?B?QWxlN09wVnJhZUpzKytldHRJTlNrZzFPaHlaWVJ2QTd6djg3WXk0ZCtkaHlh?=
 =?utf-8?B?TFFYQjlKWjBXMnNhdjVuUVFXclc5R2tsaGR6Y0VjUEo0eU0zNyt2MHFiQWpj?=
 =?utf-8?B?Y3lhU0FGUUFjUWx3YVQ1ZU96eW5GUTdFaXNGRFhzcnRMTVZGK3J5MlhSUmZH?=
 =?utf-8?B?UXRtbS9VeE1zZFM3MFh4Z0duRXNEL3dkMnI5RHV4Q3h2bTM1d2ZSb3BXaGFK?=
 =?utf-8?B?bXE3WWNHR1paSklYaXhZWUl5SFJheGJVNjl5NHJJQ1U3cVU2czRjSngrWXdP?=
 =?utf-8?B?UU1leXFJNWZxZ0c5K2hTcCtoSzlWWi9mQ0c1S2hwNEkvZWJkWlBEYURxSlJs?=
 =?utf-8?B?SUhpTndmOW9QZ1FlNmI5RkxkZHcvWmFJbVVNS0EwMGpETWxobFo5S0phTWJM?=
 =?utf-8?B?cCtrTTl0Q1BDMFhFTHBCT2dLdDlFRTR5eDR4T1N1c3pjajU1S21IR09aL2JC?=
 =?utf-8?B?TWZaZlFkcEdGMVUzcXZ1OVZyN3ZuVi9Qb1JHWDRMMzVXSVNpZzc5V01PZzRn?=
 =?utf-8?B?T1ViczBHc0k2bTRoUGQ1K3BkdHpmOERTekcrM2dNRUVwWk9rNk9vQWNEVTkr?=
 =?utf-8?B?cXFIUGIxS1pGdHBCdEdBWDJZVFFZcHJWbUZhNy8zbFVObmpickFEa2FmbkhW?=
 =?utf-8?B?SFRNNEw2S085VlJTYUVtRnBkVStlenV2MWdrOXdGZFpqR096MG1iN0IrMjBT?=
 =?utf-8?B?dUhyemJoRWt3akdXdTJ1UTZGTUFpT1NuQ3hRelZFTVUwS1pQV0pwd3hVTGdw?=
 =?utf-8?B?TjEyS056ZEV1Q3NscEQzaG8ydHpHRU1iNTJ2WUlqNHJKa0l2R0tKYVJmWmRs?=
 =?utf-8?B?Y252ZFl0V0FlTzBSTHdLbGloSC9aM1JxcDRuZHdZN2JZeXZhT2wxbG9uWlR1?=
 =?utf-8?B?aGxHcm1HS1JMYytJa1NVWi93aEhOanIzSDhQd2dBODh5ZzBwRGMxOU90am1J?=
 =?utf-8?B?anBFYzNhQnh3UGhFdU00V011emo2MFhleDBrTm1QNG9yTFI3cjVjazgzY1Ju?=
 =?utf-8?B?NWNxRzhvMjJZRWx1MWV1KzNDMWRzL0ZPdUNPZ2hJUVJJSW5XL08ySkMvcTIv?=
 =?utf-8?B?b1krK0h4L2NiOVlSNjdmU1BGOTVqb2pNL2lrK2hoR1ppVXNKSXVuZ3lCd1Zt?=
 =?utf-8?B?T2h6OVhhNmVhVnlhMFREek9PTEZTWk43bWtSMzhLTlRPSEpsUlFmVjFYbUtk?=
 =?utf-8?B?ZG9SMFh4UDI1RTRZTHQ4QmtjbXNGYTJYTFJML0J3bG42Y2J3NytIR2RRYnlp?=
 =?utf-8?B?cUl2NFh3Ri9qK3JqK1JLdHpOell3RHRFVFF1Q2gyWFBEd2l1NUc1M2NCVFdU?=
 =?utf-8?B?ZHZYU3lhd2pvdG4zRnZ4ZDZKTDNXWTBvNEFTeTF2bWN6R3Q1Wk0wdTYzdFpM?=
 =?utf-8?B?ZUpoY0NkYlc5c1I4SU1tQkRQZDVsYkg1RlUySHduMUZsblVjOUZCK3FlNFdE?=
 =?utf-8?B?MHFzSTJpVkVjQ1FUNFZaZGVueEVkTEJXaHFtNm1TVUhXdnBQUE1lVjRVQjBh?=
 =?utf-8?B?MzUzU3pxZXg3ZlV4YU9iM1hXVTU4SXcxMVZ6TWxqbFZZc2cyQmY5bEtpN1VX?=
 =?utf-8?B?bVd6Z0tjMmwrT2JURkRrV1U5TDN4cE1lNFBsei9WdnhNY2JJSmI2OEdERDNC?=
 =?utf-8?B?Ym9Hd2ovTWdORU1vbzNKaTZmenN2bmhRbGFyQk9IeTZiN1VnZjExS3Y5bWhi?=
 =?utf-8?B?WVBjdjJLRlFNZk1XcTVROFMwZ2UyVWVPcHZaNVVtT3V5bHNsUS9WYXZFdWVN?=
 =?utf-8?B?Q0pwcmlQK1YveVZvNGxmQXJXeEFkVmxYVU5LYTRrUGdPMWdZWmsxZStpSUZn?=
 =?utf-8?Q?B+lUt+DpAE+3aQcGsc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d718503-ba0a-45a6-3484-08df1dcf4411
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:13:34.8534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSNEaHvYjabxjlqImkT3CknL2VDfsZnCv+Vukcww20/Z+DHdro0NFQK+V16BIdvc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> This header really makes little sense - every place it is included mm.h i=
s
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>
> The file was never put into MAINTAINERS so there's no change required
> there.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  drivers/gpu/drm/drm_gpusvm.c   |  2 +-
>  include/asm-generic/tlb.h      |  2 +-
>  include/linux/hugetlb.h        |  1 -
>  include/linux/hugetlb_inline.h | 28 ----------------------------
>  include/linux/mm.h             | 11 +++++++++++
>  include/linux/pagemap.h        |  1 -
>  include/linux/userfaultfd_k.h  |  1 -
>  kernel/sched/fair.c            |  1 -
>  mm/vma_internal.h              |  1 -
>  9 files changed, 13 insertions(+), 35 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

