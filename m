Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011035.outbound.protection.outlook.com [40.107.208.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C14E9475;
	Sat, 26 Sep 2026 02:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790389042; cv=fail; b=K+o0dNX6AJfSeFvjz1Wj/9KAHV2mMRNKYHQc0rHq2IPhSRpiaDyYjb8nWxZ7R5Evxh6r8HE1AXvOd/S1UDFf3wEhUO4VRiCcecKIUtfoeroh3yEcsRDOoZM3rTAkqZB3oFe8YTcRpmhGUNZ7bJo2/bJRvu/dzE1luVDqrOLYdCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790389042; c=relaxed/simple;
	bh=AaEE/FCbc91FWUkBNEPYcGUIVO1kQzD5TWD+5SZh3jI=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=LIrTeHna2PQCSZldQHaU6xZ8KKZVjq8EAJX5BczQS0itDr00J5q+T1DYvSFnpRKjFOpXwPOFrXl6xfk8mrC0IAJjgDo2SPfrCWzFwNT5/cf8Ax/SFfALc+cQ9hTOMSKzHpCpvy2tURwVC07Iu3lALh94U/90PXe0+UCWTx4fAPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LvKPZLnO; arc=fail smtp.client-ip=40.107.208.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LvKPZLnO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=In3i/RVRHOO+NAZatYd7yRsHq2d9QC6GKEHIhe9Aiv1hj0hv7OXve+r5RJG0+KiTzg/fvCjJ8z14hkazabZ4m6gTJvdczuMel48ovyPkwPJ/JGCOTct/NKCav3W6ZCRPUYkGbNurXq4v47ll7TUJmho6bKtru95UidAw719pOsnEiGf8X+mv8qzx7a45POQCrYtux/We7SO9VfalDqpd+6J41+rCt2aCtemHno+KtqECOKsAJBGSXH1Rg3kSNVNUBLcBrhSw1hAjZY16HizFhUpdVmx51t5QWy2Ot+isGSVIeDmCkkCd6kAFpSljEtqWEFbhXkuuxaU4mVqePx2Zvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCXrVmZ4lyiy6A5v8iB/MSV8lozFBPA7ImRAuRr4Vnc=;
 b=zTj1Tj0wfKhKzdIRi+teSJIijHBV86F7qvc/TlrInUX5uAmOtLDYgEZrYSrU0o9E0HhvObWoAbo8uabKOyPjuNycsMM2ODX2xxEZFZhWJLmt9PFdSUZ3rMEjgEkDTmIJ34HYMBDiin1AcrOXGs1T3QMAXRq/4Z5FUDKGkZ8p6QqmuN5fYoFPe7rY5VyKNimoUV6MMAe7VVDdcepLZz6rGI5b4rvUZeRQZmw0z4lXZ3HmF0wt07KhzsB/oVwL8748jGXt0XIbCfwlI3oUaFoJuT6iT72684IGeRRLxzO7dLLx6AR97dQIS134LlRUMbgbQc0wDQezFsZ0VLae4IgQvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCXrVmZ4lyiy6A5v8iB/MSV8lozFBPA7ImRAuRr4Vnc=;
 b=LvKPZLnOBSO9gH9enKlBWYGONF+phTlzfw0uQnkU11vnPhbAatdYemmzopwkHJ21j1M+3NPp6SYuPU50e3xcUUUJBiNp6ng2RaemVn7417LkE65O4PGA2wZMv+FUTipHFyIS5VuStIQnsfzh4kEvBlU7CV+F7f3rGAmIWiGEqyQFapk6nHViCuLOtG3TS59EfShWyP+Y0O5vqesJuuF4H8aRMirwVeZLJlZgDduO1ZRc3cR1OBiplxC7idBwH9S1KkFrwlL2CvuGNzAsd3RWSscGcFA9Ko/mHKrH8BHD6/+EPxffPa3PSmso+4bFNzn+LQV7sHnywqtn3ncLY9JlZw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB6898.namprd12.prod.outlook.com (2603:10b6:303:207::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Sat, 26 Sep
 2026 02:17:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 02:17:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Sep 2026 22:17:10 -0400
Message-Id: <DLOVXY4VFCXE.1RI7ZSD30VHH5@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 16/40] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if kernel-owned
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org> <DLOVQMACWLZ5.1WFOTGRG8ZG92@nvidia.com>
In-Reply-To: <DLOVQMACWLZ5.1WFOTGRG8ZG92@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:208:32f::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB6898:EE_
X-MS-Office365-Filtering-Correlation-Id: e32ec265-ca86-46eb-277c-08df1b74472f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	3YgA8pMJODnv/EH2Ttr8QsY/M/wdTKs8+9CD2bZoLXajktn7HXgqRvXIziroUN3fKa8+tO5Nt2AUuc6TEdYqkbdGn+thJwWotvKl8HKLLjUt83bgRmOEvQetnGlt3hrU864OvvsmnsMXvdo0gPt4QUz9QiPldpHEK1i64aqwQIFY+3HVqmhMnzI1UOej/IZ774TqgeOBfxR2cY7T0TOpJAmhc6LH0oNFYkwvt0IpFKjFF1pWZlweZvpmhuOr6aTs620ZSo57dlVtfyzR2fS1tnZM9nH0gZA+wse8j826Xja0Cju4zV1KY3hfhsO+MRUNtDtrHNFzkRQTe5fu6Jjy026LVbwJile0Dfa2oQCqOopDFDE6Rcvt28Br7uWVpFqzd/IadDWyvPbstIYU7EjBXsDGSzQD4OAqvKwUeuUPkgY+HxuSfhy7kF64RezuPGeuJUttBjF8Hp3nl+yA9pqxKr3vveGMnF4MvgIkL1i03pS867sDxEVsGUCmMhxrMtJqQr9ocTML+JZhvonKPVYbyGOEooC9wGGlr/0aSETxoNRc6yjyN7K0r+D3vs+I2X7r1bPSiard/Rorat+FzOYs30EBDeqGuoyiuDI39CqEYukkDHKfjPR/nG1FzRc8580CbDI+x770iUbddCtQ1yC87MYKxZLnLPW/UqyBPAqA46xXgro5RESkhOqijQ75SHHghtuKrBPWGrwEO8WOX6u4qw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFhZWGtJNnVZYVN1RjQvQTVKQnljcVN0RmtzV2JBQ1F0NHJ4OWh6WjJnaVBz?=
 =?utf-8?B?alJ3L3pUNkYxcC91aTljY1dwN0ZNMk00TEF1VE5FSFowTGgrNVpuN0ZXSnAz?=
 =?utf-8?B?TDBHOXB6bm1QRzRjOHE0bkhLUGZBbGdnMUpTWmdIS0p4YVJLaEZad2o4eEJo?=
 =?utf-8?B?dVpwOVRWLzZEd1d1RXVqb2NqTkNGd21WaDFOVEVWbjdIblFJMld6akJjcURB?=
 =?utf-8?B?c2ZucXlYU1ZyQUt0eW5TQTF0Um91TDlSVkJPaE4xTTljWnd4RHlpeDhlUm9K?=
 =?utf-8?B?UkRsMjhGSW1VSVFwMUFhdHNlMWdvNVNoUitSUnBlT3hWVE9NUHZoaklzdjBw?=
 =?utf-8?B?cmxoRk44dDJBQWpOWTFyN01XK0F6YmxMOWRwZFhrbThmcUYwdnpmY2M1cng4?=
 =?utf-8?B?TkV0S3JsZlczRzNYendDdmpqQzlPSEE0Y3RzendZVDVtbzM2TTlNb2dOMFFm?=
 =?utf-8?B?aWJXSVNTdDl5a1BBNWxsY0pXM2JZSFdXTzdHcjVuZUVzeStvbnlpWDU1N2Ns?=
 =?utf-8?B?aEtiUDRiREpQeE41eU9oWjNmcnZIbS9Ya0kvaDJ6djJzODJ4Vk8wZ1ZUK3Ru?=
 =?utf-8?B?YUVSTzdMditkUlFvaytxSXdkVzRVZGpibThDbVJGVktDc3RUdC9aQ2xnSERm?=
 =?utf-8?B?Qm5OVUdXaTlIL3FkMUFGeWZYdjA4UkkzTFB3OU9tTlNuVWZ3OU94eHNaQTV6?=
 =?utf-8?B?TGM3eEljYWZtWUlsYnFQY3dhSm1Nd2p3emlVVWZkdEdodG5NZWsyOFhOYllO?=
 =?utf-8?B?Q1ZDWE9FNzFtekFmZC9NWEp0TVNLV1FLNlowT0hwQ3FaZlp3L2t1RzhIS0E1?=
 =?utf-8?B?bTJBY2dreFl5UnovbE41NHBZOWlaaFJqL3dPZm92Z0J3QmU2T2xxNlVCRzhP?=
 =?utf-8?B?dkE4M3R6b09aUW1oV2xNc3RNRGZtQ2JpRW4rODVselllekVnU04vNnNWWldL?=
 =?utf-8?B?Z1M3Y2pETXRxMnBsMjZteGRPYms1YlM3R0tnaVk4elgrUFV0Y2JDN2prelVI?=
 =?utf-8?B?aSs4S2ZOSzNvOUs5cmtWSlJmamkzak1aUm5TNlpaVFRqQVp2VExSdk1Gb0ln?=
 =?utf-8?B?c2JVOTRqeU9FQXhiQXdUazRJSFFrY2NQcXlwVE1vcHdsbnhHQ2FTaDZWSXI4?=
 =?utf-8?B?dm5XS2x6T3UzZzV5S1V0VXk3Q3A5SS8rVkJLdTY2SS8vMEpNY3BLK0Q3Vlp1?=
 =?utf-8?B?L20yTnlRSjZiU0lHU1AzaWFiQU5SNUpPaDJ3aDAwUGhaMG5aRFZzOEpueGY5?=
 =?utf-8?B?ZXYvNGJBbzE1Ujdhcy9JZnNxdE1GMmt0VEFTRmlOVTQrVjkxVkhaekszcXE0?=
 =?utf-8?B?ZE5GYzNFMnFudFUwREgvbmtKWVprN2xDeTlGYi9sM3NRVmo3MW1jTGpkdTNY?=
 =?utf-8?B?ZHlVYzZBTDd4cWlHdXFsOHBtY3dvY3BJZllBTTFsbnBSRmxGbyt4STN4dHlK?=
 =?utf-8?B?R1J3TTNiZklnckprbXNmVWNOY1hEbHo1ekNGVG01VTRrdWx2b2RYQnhFM2tL?=
 =?utf-8?B?TGpad0VSeFEwbUhaNHJ3ZmRZWHpBZC9xNnRKUEZsSkNFNi80VFV0czBpM3FE?=
 =?utf-8?B?QUZrSWNEWG5DYXNXeW54OUJFaXRDK1YrSHJnbXlBM2hKYTUzd2xrZHB0NTVV?=
 =?utf-8?B?K2wrSEdUb29QRFkraER0YWRlU2tFVmh2UzM2WXBhc2N6citZSGlYLzFSUlFq?=
 =?utf-8?B?UVhDYll5S1JRejZlNkxSeE02Z2xKOStxZjd6TERKNUpkQ2dFam9YQS92Y3hX?=
 =?utf-8?B?MVZ1SktUM2cwUTZJMGZEQWRBWGtHV2NpckFsU1RqY1l1YmtIWHQ0MEdhbldl?=
 =?utf-8?B?OWhFTHJSV2RsYU1pc0dQOVhwTGZ5SXE1Vm9jaEwwYm5ubFBhWTIwMEdxdWtC?=
 =?utf-8?B?eklrV0NDL1BSY3VIWmd6b0JpZWZzU3RvUzYyTkRySVZ4OE4yWnk3ZmpINFFr?=
 =?utf-8?B?MkVrYzYyUXE2Z0ZXd1JXVGk2dHhVRER4b0VDQkhtK1AzaENuQkFHKzRhVXMv?=
 =?utf-8?B?aDFMTXZBODVmTFFaSjQ2WDZnMFU3MEZrNEpXQW5Ycm9XYmJQclV0ZnRRbnNh?=
 =?utf-8?B?aWYzaXEybW92QlZqdlBvbFR2VkpDc0xHY0tKcEFtM0U4RlBiL0plS2lYUGpn?=
 =?utf-8?B?KzFaaWM1UHhrZEEwcU1OMHNpQXVYM3RnZCt2TGpSdWRYNTJsblVGTFdUaVNR?=
 =?utf-8?B?VWpGSFZ5SHlrckhaajZRN2x4MWhRemRtbWhBV0FhRGx1LysvSklnNVdxU0Nu?=
 =?utf-8?B?VkNVL2hrckFLVkV0eFlWZ2wwNDhjM1Y0bnlmUStoc0M4ditCTnZHaFdqN0I5?=
 =?utf-8?Q?Uw8uaKPc2pOBf/fmX6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32ec265-ca86-46eb-277c-08df1b74472f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 02:17:13.5906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+9JHa7HDcoevfhfSNO1xP6V/Z6Yw2R/BElem47I+PNVQcbkD8GiFLSisV2sbofZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6898

On Fri Sep 25, 2026 at 10:07 PM EDT, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
>> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is =
if
>> the underlying file is itself read-only.
>>
>> This means that mprotect() cannot mark a shared mapping of a read-only f=
ile
>> as read/write, as doing so would violate the read only attribute, and
>> permit writes.
>>
>> In general, we do not want file systems to be able to do this for
>> read/write files.
>>
>> Doing so would violate fundamental user expectation of file attributes a=
nd
>> likely break userspace.
>>
>> However, drivers pose a tricky problem here - the /dev/xxx file may be
>> read/write but provide access to a resource which is fundamentally
>> read-only.
>>
>> Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

IIUC, a file's FMODE_* bear both fd and mmap permissions, e.g.,
FMODE_WRITE means fd is writable and mmap is writable. At least for
normal files. But a driver fd might not fit the same pattern. Would a
new FMODE_MAP_READ and a new FMODE_MAP_WRITE help? Not trying to propose
anything, but just thinking out load.

>>
>> To achieve both of these things, restrict this ability to kernel-owned
>> mappings as identified by vma_flags_is_kernel_owned().
>>
>> This constrains this ability to drivers which own the mapping's contents=
,
>> whether memory-mapped I/O, kernel-allocated pages, or ordinary pages the=
y
>> map themselves, and so define its semantics.
>>
>> Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
>> across drivers, filesystems and bpf, establishes a kernel-owned mapping,
>> with usbmon and the ALSA PCM status page converted earlier in this serie=
s
>> to do so.
>>
>> Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
>> disable MAP_PRIVATE-file-backed mapping CoW semantics.
>>
>> This is perhaps not always intended, but we retain this capacity to
>> maintain existing behaviour.
>>
>> As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
>> mappings, no functional change is intended.
>>
>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> ---
>>  mm/vma.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>
> Makes sense.
>
> Acked-by: Zi Yan <ziy@nvidia.com>




--=20
Best Regards,
Yan, Zi

