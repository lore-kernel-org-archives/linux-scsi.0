Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012055.outbound.protection.outlook.com [40.107.209.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A01638D01B;
	Thu, 24 Sep 2026 19:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790278221; cv=fail; b=FvIBvTY4Gkr5H83R3sFNTARTT0Ig44CDlu3Z/n20vlHarBeYXdZQ+kvOQbG8EoQub5ar9M/MJIUweDN7mg0TeM3DMx8riylDFglpAtZAZrV6BhNkhHkUFV8jSxnKuuYG0A/StOkcepvAcjONAlL6jg2GLyIMmZXRbOAGVJHLycM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790278221; c=relaxed/simple;
	bh=PKRgrW6abMhIc09kPSFy0Thw7Gv0cFDnMsX3lCyLTZc=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=ehC+NXmYF4hFy/cVSrumX8ZjaV6TkdqZI0bXfkzsbOhWAwCBO6U0uOYHOcMxs/TTrSQblJqbG5WIEJ7fHz9p1WpCzRBFlLE7mXEdsSMc2ihhE5u+lFcRiP9jCYhhSj63iZ66tgspztrh889eFMz80ZW7FwqkcY47Bd1IXbe3Ck4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QmmUqpFn; arc=fail smtp.client-ip=40.107.209.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QmmUqpFn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuhnL9d9eALCj59nD+9czyQ56faESfrhLm5v2ouaRJiIqmpBQ3xUPczhluHNBs/ukYVw4Kv9WOGiuSQ2Fdphc1K2MyeoHbIpSjHMPRzb5jVZ6pQkNxvl9Kl2Dw8tWWyNYSOg4NNPWeAfGtdaGN941PhJDosEdhZjk7p0HxnguSA8aOeHohX6gOrGFW6FhAICXd1lHCpc9eZ9DICEmOX2MXBTiPss0PHq15uF7QbqoyftZcG2nU37xWR4d2Usk1CkU++GevcYfaoN5Db612tXJHbmVPA0NjDSSTccm6+jQ+dn6AJ8sVcqzvYXG5Jyj2bryx49esReX9oSIP44iBnlGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkIwKyxjGt1B1REIVI/rXEFCNLkFocEHiIdPxtjyLkU=;
 b=Wai5vKJ0p8scVHTj+NnSrB3WJaWVXRZQf1qR37ck2rU+IMxlQhOGWJUIfZ4ZDx/0Oe3LCvO0A2XFzF1QSgDo1dzF/Imjd97vudfjtK3m6+s0vEx98yf6IzJAmid6FSyJ1s+9Rqo5YcMHi97KHqZX3zdmu4AV5fVIqa66xG+g+txga+h8IkDl2pcL55lJKV5JJP0P63bdLDOt1eW0ClGtsuVcpJ3wLtb7ce6ZHLY5aBhZGOOTv+OaoVJlyoSvzgSLr0ebv4NZ0GjViT9auWUH2lOYZUMoTVwqeKa4Ztsj6CQLet8gZMr2SfNkJf4lz+HTmpuUmQtDg8xhPb+GHsUmlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkIwKyxjGt1B1REIVI/rXEFCNLkFocEHiIdPxtjyLkU=;
 b=QmmUqpFnfunhyqNh+RespZSeSKCrXfX6zUNB/nSnDvdAN+LP94xaV4TxAO4JWGvtoPvzNwH724NuP8lbNxSENFIXHk/UvubpAVtO33iRiE1/s+98Fael8hkVhaIoJzCjMv3DVx7qV6y2agAODNAGXSxUKbUVO82h9iUd65BAJ89oS8TORf/yhSQeQ3mPrf2nQd3zh3aCPYWt6ofxPjtKX7/OHyZe5FgcvClbaHTUee33MFlEXVbUCDHx5c1XAEamBBzSxttmI4kpQUM24ZCbuZyNx/HGCUaEZlvu02JZDd/zr1VO660W985IPJggiPdkdqNVCDxq9XtQ7NFkqAEGWw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF4D350AC80.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::993) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 19:30:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 19:30:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 15:30:07 -0400
Message-Id: <DLNSNQP7L4FM.1JZQ0GS9300H9@nvidia.com>
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
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BN9PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:408:f7::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF4D350AC80:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b272aff-50df-431c-c325-08df1a724075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|921020|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	qcFoJ8TrzrzuzEDh3+Lmgn5ctD9luf+ysfpXMPiQCon/Csfk66pTbFVlTP2wNbLJdFkANjgOLef+YYo3A6h7zpfwhVRxObMobP+BQeYrCeyOFMQD8WXgF7xSKAcUZIrKyj+dpkqddYUeM9ogmgnkepxPiNAdcNMd+Fgl88oDb8KA/19vwi/0IyvVfanixeK9epVGeOg6een6JzFQk2rCTd1zR+XJMqyQ3swwNCJLINxzaPOR/nLHfqZbhxdju9AwqEgzqTa+J1pP8IoGwRG0IwiTwIOCGt04PG68tgTRqJNg2QTH9JHwSqo0aMBDWe1TQ/6tbbqSEuBhwO8QmoJfXPIH8PgITEkxnZBxR9JpaMoWXULbD7VbzdDrn5sET2thmaM1anTAabq+2nA8ILNCfhI3bmlpm/W20qt8pKsUTfr7EsNRTc2q798JNOBjQlRuJQBzc0SnkLdfyhe/lOC5ZglTGD7dgoF1FEKmjkQzNnOhfCbfiRfYxeBsBlddQfuzNioj9Xok+AL9QrU+25iQWfZyP8SI3oXW9sw4pjYizb+Q9HYh8Q8L6kf8u6OA+Dgng4xydCGjUVIvaCMW/ctQTPr/WgDbBQJcd7IKW/LO9G/tTZyw359VP46O1o9kHvV9bColA5Gw2dEjNtUVP0WDRefylPUD0oAx9ju+b+bVb3bpbCJ2RrF8WFcOiEnLIyuHTfjVc64dVD3h/O8jb6f65g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHhxZzF1M1M0aDdnYmpBS2pUSkZVWU5XSEVIL2J5dkNYa0x3Qmt5a1JsOEZy?=
 =?utf-8?B?U3p2aWhFNGt6T3hGZFhTK3ZVUkw4NHk4T3hneWpXTytrVDBhYW5wNFNWdndP?=
 =?utf-8?B?Um1QVEJOdjEraUZmSS95MVllK0UxanZLZ0E1V0hpTkordythYzUzL2V6L0xI?=
 =?utf-8?B?QUtpUVRUQm0yOEtNNy9CTVJaTktnZitIRHN0dTl5ZjV0dmNKSTRCbC9hTzBx?=
 =?utf-8?B?d01xYTJoV3RtZzhVSnRDNFMxN0hySHY5S2FDRnpmSFpFWCtzS2MrSEkvTm5G?=
 =?utf-8?B?NWhRRmlSanNoMm04MTU4cTBsMEVpY1g5S05uU1Fta2RuY0tMOTBPZWRyeUlo?=
 =?utf-8?B?SjJMQ0JpWjBHUkwwUFk4RXhhYXR2VllqTFc5d3pGSWZUaWlacG1FSjQxY2xJ?=
 =?utf-8?B?RkJYUkZ3VzFMT0EySmszVHhFa1pnQS82VzhNTzVTak4rVkg5b0tNQkRvZE1r?=
 =?utf-8?B?YmF3dVlTeHdPaVA0eExtRENHdFBHQU5IN1BZcTNJZUEwM3lCMVdxam1wUXVH?=
 =?utf-8?B?ZFlVeE1TQ1ZSR0kydjgrbmdYZUNFcWtxazBwbUdRcGJ1V052aUErMTcvTzdy?=
 =?utf-8?B?WGNsTkhXTWM1cTJyQXcvMzMvV1NaMXpQcWlseG8xN2szVDVxcm9CTGtJZUhN?=
 =?utf-8?B?MmovcFN6Q001allmMDhiWHZBeE0wN0VZbm1BYWFucTJVbExWVDFCbnBYWGZa?=
 =?utf-8?B?VjJML2V1NUNjWVp4aStCUnYrb3MzcksxalVhemJMK3M4MTJEdmp2czlzVVVv?=
 =?utf-8?B?eDVwVTFyVVdlTEdXOXNPYXNIcTBGbmJtZEErSmNHdFFpUjkwZGxFWmVoQ014?=
 =?utf-8?B?Tlc4ZXFQZjZnUk9KUDVqam96bkNneXREK29MRlNDajkySE1lekN4V0RwT0pN?=
 =?utf-8?B?cVN0SlJDa2NKc0ZlMnE5a2VXZFNRcW9nS2tocUlvN2lKM0dGclpsVEk5SHRx?=
 =?utf-8?B?UFVoK29aR2J3MGtjeU5Kd25RSGdKaklQRlAvbjNuWnI3RkViQUNybzdXTHEv?=
 =?utf-8?B?YnVvRE9td3NGbzJnanRzbk1ScTMwVmxLSmZEUGF3QksrTmJRL2swamdVNVhu?=
 =?utf-8?B?eEE5NWY1QituQ3RyZEg4RzFzOXB4cjlNRXU0K2xuVmtjS29BSERpOExCSzZS?=
 =?utf-8?B?eWxTZGwxYy9wNDRmN0ZwcUxoZVIzaGllV1ozZzlTS2poWlZNellGUG90WDFj?=
 =?utf-8?B?THoycU1Wczg2R0Rub1BEcS9sQkI5MXg3MGUyem1TeWlaUWh4MTBzUW1ZMWE3?=
 =?utf-8?B?SFZJc01kZGZkY21teDZrcisxR0x4NzE2eEh1aDlCQmhwdFQwN0dxb2xFWlQ3?=
 =?utf-8?B?dGFqd3B0TEVVelQrcnFYTmpNODkxWmpqdHZxVDFFVEpyU3lDZDk1VjcvSlFk?=
 =?utf-8?B?TjJaWDNlUzdzVnREVFJlSE5oNHFxV0ludUU1ZHJLeEd2TnlJR1R5RWZxUktG?=
 =?utf-8?B?TXlJUkhaT05zNmJob0R2M2ZobUo3QzRaVGljeWhiNmVvMmlWYnhlYUdqS0pN?=
 =?utf-8?B?UWh0bmxmR2s1T2hGaUhqdVhKOFpmTFJHYXEzYXc2dTUxdFFxaXVVQytwaEEv?=
 =?utf-8?B?cS9ud2ZrTEFHckhwSXAxZDJ3WFFFOS9MUGxjd1RJVWViSFU0VkFHSExIRXZG?=
 =?utf-8?B?T1BHbXRYbGcrYnM2UUZUY2ZIcW9JU25jNEc1ZGxwMmc0ZzAvelN5UWw5VWxB?=
 =?utf-8?B?dERxWnF2ZUF0MHYzdjhOa0twNXBrcllEZHRWQ2kxV0o2QThJdnlLaDlxbjBz?=
 =?utf-8?B?QndyMWxyRnRia2hCbzBPTkl0SjY3M2h2bnVCRUZaLzZQTEdrUFJUZ0hnbjRl?=
 =?utf-8?B?blY0SitMZnN6Q3JxMitOcmJ4eFF6QmlkNlRJNUxGOTlWbW5GSWRoVTR4UXdF?=
 =?utf-8?B?ckdDd21jRmVJUG1xL0MxSGkyRE5vVldFdkFKUkFMczhVZURnR004OGZ0ZlJn?=
 =?utf-8?B?SVZQdzhwTlhwYlNCTHYwaXFsN1BmenJLc2ErdUpHcytoWnRhVzZkQlBrT3px?=
 =?utf-8?B?N0kxOHFYWnVmTWx3aHZUR1BvRkExSy9HckJxMUVEblV1WVNkTWFHQ1Y2S2Vr?=
 =?utf-8?B?VytNSnc4dXMvcE1GZkd5cm1nYzN6WkdpUW9Db2l1VFRIR2RnLzJqc0JpQVNW?=
 =?utf-8?B?Vm13ajBQamk5dGFmaTFybHpuWSs4eDhvTEJac1dvODFuSXBURXh2cEZUeWZK?=
 =?utf-8?B?bE9uS2lYTHcyaTd4U3FSNE94R01WNy8xZXlEaVJYZ2x0MmZRcHpQOStPREds?=
 =?utf-8?B?dURtSmJvUHk1ZDV0bjNwZjBPNHJMd1ZsRlBRV2dvbXYyejlKa3lEUHM4czFo?=
 =?utf-8?Q?1VykPtvsPKA3+tK+5g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b272aff-50df-431c-c325-08df1a724075
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 19:30:12.1248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRUQ2KrvOYig6kIu5tJe+o4lUkO5VaAyULfaj4Rd4LC/Y7np4A5Ae+Vj+fX3Qamm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4D350AC80

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> There's no reason to export the symbols for these functions which are onl=
y
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
>
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h | 3 ---
>  mm/internal.h      | 3 +++
>  mm/memory.c        | 2 --
>  3 files changed, 3 insertions(+), 5 deletions(-)
>

Makse sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

