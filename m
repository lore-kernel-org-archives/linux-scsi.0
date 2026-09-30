Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F01B34CFA1;
	Wed, 30 Sep 2026 02:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790736193; cv=fail; b=dnbA4mpyzq0GWS5StrTQSaWE6N4sFlNFwT3aF9bgoMdI0YcjVVrTCrWik6IiZNubcwaSKGpXb/SNZl1+WGv92cWuQoenNmb8QkmAReZr8RtOn/NBbVgUETd7CQKmxuuXtobyDAUNFx/sediqEW2YsCquTjI/Uq0Zc+y1aWEjdqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790736193; c=relaxed/simple;
	bh=+4mh06ICOUl+hrH3lx2VGh8fReTNapHd2QwA9hqlBwU=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=LrfnnKk3tDntKyFqPiok47Ntd33dnvymJuCiDaPA9qc0BIPAGInjSLnR7EbLIz0O54IXMh5Me5BeY03C13FSiKfJFk4ifYN5w3lPL6MxlZtIMzSFXPUzx5m9e0e7Xw5bY0ZuXnFZshJmswE2XhKefNWSQu0LrGJzwj4EllonvvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ghK7Bfxy; arc=fail smtp.client-ip=52.101.61.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ghK7Bfxy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aw216imaPX5ejBB8L9vOe383WaVFBWj27nq2A9Cv+y0PM40zEUhaj0Tc9B8eqQi5fForlBV68ZEklruu5TJJ0SP0MVneuIibGNL2hmeAx23DCQzlXOjYMa7iT6IneX14t9k+HMx4E7M3KK71fcbsqg+3UxIqBeV3e4wbOoytaLFO2xymhDCOOH2NDMtF+RHlfYM3MW15RhQM+3yAObeQbBXzhtiWG0B5z9nVEydhwPl9yr58L4yk/LXisBG0HuZlZnzOo+gfko5OW2wMtWZQvZoFwTU+7avljjaiITCK0OM6zFZ0F/iBCD+OK8qL0SwUSzI0znohH7SgWzQbx0gPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uRK6jbOL3YdkEOoObYwJrDtSsMJxqjT6/f6NzO6GPE=;
 b=eXc6AXS8sxNcEqvXmL9/gyI6E1SZ0ncXsQ5iDtoozl0uuqL13bqzosGQXdkWHtBV89btWTs5H+M6TUIgIjLu4MkUBr1ZoQBZ9nGeIsScG6/WwXZy3zzJzqhWrxYEDYIV0E4lM3xX/ucESUmU3iKguo/8RhIKZw8xhg5ZnbkUNz1XMl3JOOLSbr3UVc+3x2A82+V+wyIr5aHTHTi4yfJCyRaYmla1Eoh2MuSn67j6vQI8sQ7OjUVZf0zxDNJ6bntF4IXkEs1W/zT+t0NH3JZfY+OtKtY0ywTDIsWOWK8dUBtmInPyOGAMxhPNShN6LRvai8g2atqUmiHIJsisBSoDvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uRK6jbOL3YdkEOoObYwJrDtSsMJxqjT6/f6NzO6GPE=;
 b=ghK7BfxyxnbFshWrGdwNmLPh7H3YD/EhKowTTjx43GWi5U2ZdCKXxmp3lO/GS+st5UX5vc9xovzA1IfrVsgDg/CILTRMDJjyd9bYCMHMRNT146YgnnbyMUsxsZPubz7iQTMo4KC60lq7b4QkOKQ37fbWdYwtEU/pdauEneFREV27E1xeLbU0W3+ChFtwX1l1T/mLYvbJWc4wgiRWEP2lf7/1NwetwYe07mdCDe4Y9lt++/pLpKcfY54luwMFj1wQU3bUB7wfRDp29zJJ69anf8r+x33RVZHdWbbjkJs7szVNhll92TT8adzWkj2MNta3PlDGsUwIRZAmLJ225iurGw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 02:42:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:42:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:42:23 -0400
Message-Id: <DLSAZFFUS20R.2I3Y2GHG3E16I@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 35/40] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
X-ClientProxiedBy: MN2PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:208:23e::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 23b26cae-a7b6-457e-9fd1-08df1e9c76e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yV4yw91E2SBXClFhopyiiq/PoPHKu32eZwxm9ngeipzrvtnaTfRxBAsS90aCoJ6J05plFTy6d0K/cHz3RV8QmBGxz6IYE/WO1fviUNKADhUrfuCh8V0WX3s0lAqBFv6IqRrmZmSlesQkGNNyt0TjuVLeEGrnJH5USeE0D1uC8gBTMy2CLAwyawqhZLUtvvLKJR58WRPAT1H2np6j6SnQBAtuK+2CoZSaGQ6IrTuBII1cdnFdIMdO/RHIaovhl0EWwpJVQ0q9PgnkRpz3MeQdDiJe8RUKsUZ5xxVlnRBtTlSjmYhMlIqVhvHvl2Bot8jRNKixoUitDh7FoqJddYMRGJcw782ObntYNpjKQrKNDsQyykoNjIaV224AGUe4O6VeTuQHx3RukPVRzZ/9pIAWzAyfhzRcnzTmPzbrKa1AFf1cEd1rBRHsK8VE0zeio9E+HhanTfKH2mrHXRuHFuh40kpTr5h5I5UEiQTPlj5NPrY2oGYiiJqvc21HaSkpTfvXanEMzMj8z0R3CpUppQ/GvmocFRp9HR8tTYaR4Qk778MasYTQ0sFn5hILr7mYZq5m9KUwi0nX5T061vi5sBicIppHS3QefxZpihAv6w4wYVlkpsizGTRLweoYq3a71/BX6VpEcCHZCtegdOMPYM4X9veBflRYT1TGVfRAMuCfuXZTPcU2EHy0mh1jpQoY2m9+emkgxVmQMIBShd3Zr43j3A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTU2eEtoL2Q0aUE5Y3N5UEU3RjlIRDFBRk5RVEpvRzIxUFVkZTd2QjA2SlRy?=
 =?utf-8?B?UFhCYW8wdDZVVitSb0lKR1d3UWVONS8zbFN3Wnh0T2xVZDJ6YUdwSlF4N0lS?=
 =?utf-8?B?RTZOVFJlcUR1U0oxNWtDUUlQNFdxVTFnc2p1VllBZjVpbW5YVTR6THBDczFT?=
 =?utf-8?B?NVJUdExaelIyVndYMWUzYUVaYUFTUm9qdk04aVQ2b2FDNlp1aFREcU4vL1Rp?=
 =?utf-8?B?c3IrVkpKWHo4c1BtNksyMllINXNjTE9zMitJam5Nbmc0aTcySCtwbTVIQXAr?=
 =?utf-8?B?YjNHWHFOVmZvRmRDWmFxdWU5UEpMOVFDYnRwRE94Z0pMMHl5VDk2Wit3b2Vl?=
 =?utf-8?B?V1BobnM3cDFWbjdBNEI2UHZSK1BNcmJiVk5kK1JmUjMwZFkxSUpIc2Eva0dh?=
 =?utf-8?B?azNjdWZHY29nWHY1TXhmSTd5VzNOM1MwQ2NLa3J1T1FudExpdkNKQ0tFZlQx?=
 =?utf-8?B?WEcvdmFwV0VVRUdZTXRmblFvcFJzcVpROHkvNU9pNytrRk5DWlVaUTVSSDBa?=
 =?utf-8?B?UEg1UDFxUjl0WEp4eUZ1THAzaHFoMlAyRUs2bHByK0I5OE1IcTFiWmUwSVRC?=
 =?utf-8?B?cmNzZ2RycjhUV0xySDJ5aDJ5L3FOclJERVJyeTRMZE5Jak1Id1Y3SGlCdktL?=
 =?utf-8?B?eHRsc05iem0xeFVja2ZrdjlQbHZYU0FpK3FLSDNWRno5RExJbi95S2h3N3dX?=
 =?utf-8?B?aDF3Qzhnb1picFNubnpYQ2Y3MXBZQitTRFRremk4enc1V05PSU95TFFNRzh6?=
 =?utf-8?B?cUVzYjdDSU9ablV4NlFNZHBvVi8xcDdKU25sTi8xS2t4aVBkN2Z6eit2L0xy?=
 =?utf-8?B?REtaY2xoSWRSYlNPcmE1TmxVOGRxOWF2ZCtWVEl3c0d5WVdmSDBlb0pkNkVs?=
 =?utf-8?B?RDJzNVhac3RIcmhsTlo0ZHBlVlV2R1hnaG9CSlExeVpYZUVROWtrdE96S1cr?=
 =?utf-8?B?dmVuK1hMV2FTdFU4bnZXZVVGTXEra3huQS9RUW9CRmlpY0pRb2ZoajNOMVdN?=
 =?utf-8?B?eHpTbGZzd3U1eGl0VmhISGFzTk94eE5NWWVKU1RZWkh3Q1JiSDd5bE94aytG?=
 =?utf-8?B?K3EwTUhZUDhNdHhUdTdRWjhONUJocmV0Q3c0YWVCZkNSd0FaYzF4NWZ1bmpQ?=
 =?utf-8?B?clNsemhwa29IcXpaN3ZmR3VtUXVyNEhJNVlhbStGaVRSZFJvNWxaYXpsUm4v?=
 =?utf-8?B?cXRpVDNYdGFSV3h6KytZcjFoSFF1WDI4ZlpLQVdTMnNsdU5qdWZYQnBZZU5T?=
 =?utf-8?B?NjNnTTJ1cXV6RThSK3c2aFcvVk1WcFgxNHd1MFQxRVlhVXRmWkNoQ25xWEli?=
 =?utf-8?B?VExWd0RWREFGcUVIcFo1WGNjdG9iYnl5SFFIT2swSXY3eWd3cTJLS09VQXVH?=
 =?utf-8?B?cnMrWjRHQ1d1Nlk4ZHV3N1pzQzBlSTRLT2o3bUVkbEpxU2lLTllsdkdhbjJa?=
 =?utf-8?B?aW5iWGNiM01OSmhJOHJraiswT1NTMzJhaG9KSjFUT0RNMDFFbjR0ekhDZ1I5?=
 =?utf-8?B?MHBhdkpXTW12UU1pVEhZS3prMjFFY0lTeVpSZlZCejZkQVE1dFYrTlJHNmtC?=
 =?utf-8?B?NjF1TnFGcTBONXFpdTVIa1ArOU1tdXdsZHdRVC8rbUhSQUpaeFg0cXFjbys4?=
 =?utf-8?B?MnFpTzlQc0h0Q1V5SmVVTnZBb0xUY0FCeUtIaFNYelpJUzU0MStGdkxkTXZX?=
 =?utf-8?B?UUJmMkU2ZXplOVpXTW1LamNYcks5NHpESDVHYURDOU9BRmkzSTkxam96SjNh?=
 =?utf-8?B?TkZsbEQ2NlJGYnRLNmppcnkwRXNuYUJDZEVnYWJoazFpUXNzdW0vNGVwMUxQ?=
 =?utf-8?B?YVlNYnAwYm5SbTRKbWkzOXZiS3ovdlFLOE5meUo0STdFalQ2eEl0TVJFU1Fh?=
 =?utf-8?B?UU9SUVNvOVNLaXNsc2dLc1VGa1FBMHdIZEhkZ2NYVXVoVW1uaC9xeVJEdHE0?=
 =?utf-8?B?RlhPUWtIOHhDUnZCTVM0eVB2cjFocG9SUXpURVZaajFzYzg5U3RkTWtBWFhv?=
 =?utf-8?B?Mk04eERuSmRpbVhubmR3d21RNnNQMWRMdGdBb3U3ZnNpSjlJTFpzT09pSDlK?=
 =?utf-8?B?SDFzNkFiNExRZ3BjeEEvUDBZM2prTnZjcm9GQ2hZRHJXSENpMVdob0VWOGRG?=
 =?utf-8?B?c2NkSnVYVWwzdGM4NVFtdFBudnFBdlFoR1k0eU9nM3gzNnJLdnVTSWs5UnBL?=
 =?utf-8?B?OFVVRWlZSno1SGdsV0R6UzRpNDJLdW8vS2xkbTNNOW5CQVBwd1k5WThhUnBV?=
 =?utf-8?B?M3lnZ2x2elU4ZWFWRjcwdyt0QUhBNTJZQnpia1F3NTZLQXFpZnV0VlpVak1X?=
 =?utf-8?Q?WMz+AQ3G6myoR0cWxj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b26cae-a7b6-457e-9fd1-08df1e9c76e0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:42:27.0077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8v0cY/Vf2656EoRYyskPXT4Zol3eUCd1HNQGekE0hmn59/W2VWKP0TVYTr3L9R0d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop =
as
> only kernel-owned mappings may set it.
>
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags=
.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi

