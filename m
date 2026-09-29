Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013006.outbound.protection.outlook.com [40.107.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5218351C17;
	Tue, 29 Sep 2026 02:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649544; cv=fail; b=ErWQmt7ZjZqSlMy/RxdpuVzgLXz97V4u3EaT8rwDuTvHM7LSw1/UrDH46IoaWHHFdmoC6Z5JnJ6vAOmEOeF0TnrggWF+O8eEVAXqXTkw/3rIV3Xmvk2oqxGIX8PpgbA4CEoc/68vDh0I3Q8wYJjbDcxt3gb9c+H/h/NviaNOPAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649544; c=relaxed/simple;
	bh=2To8e42dXnZG3g7asF5GaTBADeGzaHBiVIe2x0wnELE=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=QovYTNyX+h6vYRcKj4i0BBA/ycjkHG953Fa+T1lU3YZ5HmeFNYFEPdusgeBSBEfPLXNqF510iygOG/n8Nn0HY2wMlFp+7kAqNI9aKatzRyhSlmunYKAoj/JuLASSRxPISXNkEvR8voI5t2Iyj+phYO81dNWq3cAS/21+hFgdi84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AS8wTGZ1; arc=fail smtp.client-ip=40.107.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AS8wTGZ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxrJD4y4/9tuSyk+P+9pc2N4nmFYLRtdMAWwZfUlv9T/7jb8JUzzcH5d9chPITiU0ebHt22hY1G41Sau58ko9u1rgBTgZk/0WFxnEjxJ/G6JS2eYLz/nPbv1yYW4FT4Z57kT0HM2q4NiDXULFA9aXerk2mIwf8rHLky3zmBSSjwFvFI5oItKYmPpnFmpvyqThOV+X3xesIeV8Rn9UPIO3/yf9e1nha9S9O45bi3KjVxp4eCwL8Fsyn4M/JwyPG+E0dKdb2OiwjWjx4vTuaqIEz/3qc3v7vEabBR0oiedKNlE0RmE2/aGrfBSxP/wCgidDQRgEoZ5dxoxMwIN/+lWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvaYIht3qC43l33T9gA6PBsXi5WuPyLqVZAdhOrQEok=;
 b=I8RhcZuYVsswM4jDrKuo54SLDUwYNYKPhOx5I7spYpCEoQ4zZM8Zq9XD/qMAuLmKrg7oqv2fAcIJJqxXviN+Auh+1oF2gD2qZYQ2Uf3RRPtDwMuqTQQrXpf6e5xqJbT9PNGgvp+qKjb29xJwjEMBsJO93bnpzIZ37uJsYJ/4AvZXhOk0pUWlpHcD61h0Wni5bM5wqB7mNhHLmx9Ff8PftmjCVlIK5HGJfsvolXDibbVt+7NrBOyyJAYgIGpWn34Z9rH4WvebymJdXZtsjDaFgT4VYTJ9vYAqQECP0C/HB/fW8joYoUnfv1EcV5YZCMlRYNqGqqVQ3P/oyNCWiCDPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvaYIht3qC43l33T9gA6PBsXi5WuPyLqVZAdhOrQEok=;
 b=AS8wTGZ1fj54HmZvvCwlcFsrIgj22uOpVJo7nWl/JAEg4azMV6alg0JlSVyWozgdL7dZzrtj3OId+U2f7wacpXSNJyuYGTUdvL/EcdV6aK1YmNSvv0+y1M9VNrYOBUh/7CpvH+l1x7JYASkC7UcShEf/XEIGzJC/tEsZUeHOXd37QISzgieWzH8H917gB8isGyhV2G+qBkfj4tsOSoHe1GrNnQZuZ7y6mOP995gWKNjnCEvTxkOvW0NBCZd/4YIwcxvc8EqwMFjbBpsE4s3BxP8ZQllNPY+MdhoNSzUXNv5nh1khFK1s3/sCtiDtuoSXOgq2f5DkrTY/sYvmcnzJDw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV0PR12MB259608.namprd12.prod.outlook.com (2603:10b6:408:3ef::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:38:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:38:57 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:38:50 -0400
Message-Id: <DLRGA620YS8T.2RFO662N4ZALL@nvidia.com>
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
Subject: Re: [PATCH v3 30/40] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQZPR01CA0186.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV0PR12MB259608:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d6b35c9-7282-40ea-50a5-08df1dd2cf79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	gljZFTseVyKrJTZjhmJHt82BVX2G/iUZYeqKu4kYw7iKkTD5OwweUBUHMnEGd6VVpjk5m7bT0NoqjKLPWUN2PP8jcegrinKargxnoSRbxX3P7vx2d4cgfNpqsJQWzwmgNmOqA+gnO5420sG7ZD38wcFUEvUAskN+O6s7unVK5FXFyo1xPj/B++cuLlui4wRTvCP0gc28QOLcJ3Gp17Owfseg6EhjmNfReM/1+Rfckg74H0yUMp9QaSoJNn/hPHK/ZNGfgUQu32VwPjN063wM9ktc/73l30cmSHj1K2hjaTo0KbsRerVK0nvLr8m/fZEiGh9zvCkc/TkEeC+kWVkZp6q710uJP5mdv6zNK2sB/rU6pa7Zfqw6lJ/eXcXB9vCMqqSC6xm/jaxlJ20wYDh01zPjPP+LISwIWMsOQnY+fvs0olWUJmCCAvYs4SK5Nkf/3HZkbKOWJFaW+GPjTj7yt4IKfCWkkjPB2r+BguhAeRM3QB0+ZBtnmdzjaKWIZGmBWBzWdzNjflSwF2DgvROUwLhyF5Rc90xf88kSP2qRiF7pySNFyhsxKoZnFPayDZIlWT2El9Ky9RPwSQu3HqFOPehcnY3WFwYRwI1pQkIP68Wo3S8uAKg3OugkILfHlgX3z+mhlyE5QJf4KjCI+qmEaNX3bvAvHiYllW8e4Fop98ZKTulpkWkXE0k9l7u3UOAKNUXOoL31VqCKjQf3AtMrtg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LytUSFU1MHJGdGxiU0N1bjhocDdwTnNHUWZxSkszSzNKNXd0YzJyTmpDUWIx?=
 =?utf-8?B?alBSbVhKeTVJK3FQZjJYSXYzeFpJREFjOGFSTEU4UmFsTE9tTm1zb3lrVGJ5?=
 =?utf-8?B?eWFPNVpGd2J0WmR3eStJN0RoWEVWQWowMVIyTVkwWU42dVhKZVJiTjV4Y1dO?=
 =?utf-8?B?b0tSaFFxd2x1R1BaVlBmRHd2a3FweXd6c29CdXY4Rzl1L21XUzBzbjJ4TXYz?=
 =?utf-8?B?UUpoOFJRd2c4NG1McWFqbkdzQ1FheTd2eHJWUTNrOUpqUHRyK2QzNzNmNnVw?=
 =?utf-8?B?blpOdHd6UlBGSjR2ZDdjMTI1blBkT3RuNzJNazNJSytDajFzUTNxVTdBdjJP?=
 =?utf-8?B?VDFoTk5nWTNCbEpOOHZRUUdiME1tUU0wTDR1NkFUeU94aExFR1JzazkwaFV1?=
 =?utf-8?B?RElzRS9EMmJBN0tZLzJ2eEFwWFNCSW5tSkR6MDNRc0pNQWVUZHY2QXg3bURC?=
 =?utf-8?B?aFhaWkY1alRDU1VYeEJMb1NRUTRnd1NHTVRLNEZGOXhPTWhXWU80L3pqRis1?=
 =?utf-8?B?NU9QeE9WN015Sm5KZDF3am53ZnNHWTcrTVZKV3RGVlp0NjRoYVlMQi8xelV1?=
 =?utf-8?B?bi9iVXFXRnZCTHdvb1E0ZjY2T214ZlYwOFdPZjVSQk1COHp5SDl2SzFJZTho?=
 =?utf-8?B?ZFBuNzd2UEZnd00xNlRNeGpzWEtZbXloRWZyay9iVmxmay9hSGdZdUlvNHlL?=
 =?utf-8?B?TnlrblRzUWw4STQwN3VIVEhxNURHd095SldTQmRCNlVSZHRNaS9Fa3Fpc1VU?=
 =?utf-8?B?anMxSTRvUHYrY251cFV2NmgrL3pBbERXZW05VWIxMllSRXRrWmY1MngzSTgr?=
 =?utf-8?B?SUY1dldIUHhjaEt5aW1oWWFpb1lWR1lwak5lZVNzb29JVE5PaS92Rm1ScWFo?=
 =?utf-8?B?YW84RDBrdllyTzdUVlk0OHhwZkdhOE5QWkpneXlwWjgrWWo1UzZ3NElqdGdI?=
 =?utf-8?B?UmVzMGlVR0lTMWg0aXFRNGRrQVFRSDA5MlB3d3ROalM4ZktvYXN5RStsbDYw?=
 =?utf-8?B?SkpsdWxiWWhtTE1qbHFBYkoyaWlyQlg5QjQ2NHdOeXV6V1BTU2F2c05jK3Ar?=
 =?utf-8?B?SjdZYXdiZ1NUZjlQOWMvVitXd0xEeDJnYTcxWnI1U29kRG1kc1BWb1U4dVJx?=
 =?utf-8?B?cXg0UzlYYzJHbkJtQ3YvbWt5cVBTSTBpT3phSlpsVUFLM1JwVWhYMFArTzBE?=
 =?utf-8?B?QytLVEdPVE5IOWVLSlpJa0tYUlBuMmpDVmszQjhPdTVsa3dFV3NhUkh1ZWhU?=
 =?utf-8?B?VEMrNkxaaDhsR0pzSUZkdExzUGgvbnhndjJxR2l0YldwNlhESlN1TGxWNEZX?=
 =?utf-8?B?M21RelFudHVQNFlIWUc5bTdCYmpIWFRrekxrTmtNSkxTWXZiTk9FMjlvdkxU?=
 =?utf-8?B?N1NIamtEc2dscUlPOUxRdmdDdkV1U1E1VlR0ek1MYVdmdThhbUN5WWNvSWd4?=
 =?utf-8?B?YlBscmp5dnN0MkpjWnRyWHJLNEMxMjlHVE53V1NBOG02VjlUTXhjVGhVVzAv?=
 =?utf-8?B?d0FPRzlUd2tzMnBDK2tNUTFrU3h2dUhHbk5UZHg5OTF4NVE3ZDRuajVISGJ3?=
 =?utf-8?B?RnZ3NjZxR25oQ2o0emRkOXhNbk1qcE5HWmx0YXQ3U1QrcnBCeVdjejM2bXR0?=
 =?utf-8?B?UGxJczdlbWxUNE53Z2VjV0FkNzZwenZabk1PbGhmYVJiYVdyQU1IU0FURWNN?=
 =?utf-8?B?SGlTZmtHVVEycDZxUTR1eGcyMHV1aFA1NVZjVUxxVkN1K1h1b28zNkd5SEVQ?=
 =?utf-8?B?QzVwRFE2eUYzVTFiR0hnQUIwOXA5RmFBVG12L0dYK3RMeWhMMjJPYTlIMUI5?=
 =?utf-8?B?b2lxVVMxUm1PdCtIeUZPMnJQaDlLdExqYllVQktiREh4ZmZYYlYyRHZuaC9q?=
 =?utf-8?B?M3VNeDZqT2ZKSHppQmFmMTRsdTRwQWVXbk1NZFBDMmhVdnJpQS9vT0wyVHF5?=
 =?utf-8?B?ZWN3cmR1VE1sRCtXRUt6UDNwOHNtaDdmTFN6N1YzekEvNmpKNnR4Q2lYbWto?=
 =?utf-8?B?bmd0R08xeEljbTZNbXBMVkY2RmRwZlI5M0t3bmpmaE00aXh3bG9adHhSVGhO?=
 =?utf-8?B?QnFsMnVGYnRPTVBSczhKbjQxVFUyU0dpcS8yZkkxNnIrTnQxeElFQThRU0Ja?=
 =?utf-8?B?a1lHQ3FJSGUzMTBHN0NTOVBtNUt0b3FHZzNITXZzY3ZvN3d0UWFrTnBpNDB3?=
 =?utf-8?B?dC9BZWtta2JLUVN3NEIvS1dEL3VXU05HRUkzc25hWmJWSHZJaFU1MStxeW8x?=
 =?utf-8?B?cmpLZ0FXL1d2VkovWlFIbWo5aE5ITW5Cb3U4RkoxeDZNemdtZ09zb0xmb2F3?=
 =?utf-8?Q?PmSTRfh4bbbBx98Nox?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6b35c9-7282-40ea-50a5-08df1dd2cf79
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:38:57.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kz4Gh+4PfT9OthCqi3aJai8u3MakmVbDYvKctajS1UUQMnHv4XP6ftmnTAa84qvE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB259608

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> We currently disallow the installation of lightweight guard regions in VM=
As
> whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
> VMA_LOCKED_BIT unless allow_locked is set.
>
> hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
> VMA_SPECIAL_FLAGS already sufficed.
>
> However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BI=
T
> is set, this check collapses to being the equivalent of
> !vma_can_merge().
>
> Update is_valid_guard_vma() to reflect this.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/madvise.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

