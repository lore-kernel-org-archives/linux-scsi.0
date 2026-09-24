Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011061.outbound.protection.outlook.com [40.93.194.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACCE3D3CF7;
	Thu, 24 Sep 2026 02:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790216729; cv=fail; b=QSCH+1IdQvkMSB1ix8r7+fXHf4pFv2StYDmmODo/QsGRAsKLdocf2FhiiGB57d66Xd1uJ0KIvn/UU/AjgPrKZ5t64FzM6Yg9J+LSxMAUEHDDjk/WPqId8eW/9cYP2GPQ7Z5VlTwX9+C27kWy7EMpJyQgadvgd6TIrfTfVPaw3YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790216729; c=relaxed/simple;
	bh=uaO6ub4ZVhQPypN2Y9cr5CCoy5P8V2UleFOETF12Hn0=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=tXC952MRKsJ9INEv6MeEerqXjSPo9x9gpHFzVeu0YDfMoRnYJitMZakfg5UOdvdlqROxFDsrX2rLTckJfpl/+iazfXIlHN2wtrmY9OnlrOy96uF9YZ9ofSzc7C/zQKxcSYl4+ui2O5mQspbMQGzFMDQ4vAMHtS5mjeLSL7JHukA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SjnPsU+/; arc=fail smtp.client-ip=40.93.194.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SjnPsU+/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pO1/T6A2Fdlx90Z/mCmyL6hDoDyMBnxmYvqiYxG4rKBzxD9PFNb3HtiNnB6sTKVc/ogwSXt+2Ni6VrdCUSm+DUP3XOJYN8InfuTm2UUhmoBr2AdiGZmxhBDgYek3Dfj8TbyUro8IFNbpSt5GOvA2bDzQU2oFtji78AOqbZ9hL1GuVQJcrT4QWNgK/JUkMyrgVnhcsxTs+R2XxLVFbLE6U/QSlaSpXfOV1GBfUghpsHh1x1pDamTzwu6/OsPAuS0EkUMZAN1syQ7lAXUpVrk7Jha+mtGXquGRORYSRjGta0txNHqdwFU7UARNP9Dbz7FOKTYeFzKg83H0vCItRP54Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diKz3zpBZAr5uJdDdRZxmOGRZ6MEEB2ohK+ehdIFWIg=;
 b=VDn1kvAb4GZRdM3hLf4mZPu2yqRC7j1weQnbY9ygoBAgjlPjkFxHBVzeM7fbs8qrd935TszZwOavsLUzmaGFOVKby1sw68hKbXa/CQo/Yigbd3IKLRHUekZ9jRTEoUZJZNH4BFSBi8adYI2LMdPCMrhMjzU/Mf6sHgzgZAzWUPbYm6gERlry8IRmxuqUQX5DdhOHQNoyYhtQthNg+oedWfzO+eyoXjyBDmJDHHlz3tTokcCAjvIQbI8eb1rSkfdWqYHhVMTspfRMrED/QP9u1RmfxAJf1CfHgb3rgZljIj4140AEILXwDfV9z+/CgyiHE+LudYMDvxGzNln5O5AVEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diKz3zpBZAr5uJdDdRZxmOGRZ6MEEB2ohK+ehdIFWIg=;
 b=SjnPsU+/1jE7wWx5GaquXfJO9qySNhGbMqNNlDUuyP3MRu62+SoOvRSxs337tNXF4nbmdQeJsWrLrp8JG4mpSNNNneZeoCaxaGLWki8SMfZlmRgX2H/YUOPlr233KsInx3jRriy/gvphguRlH4wxl2sRAXeN+t2WoqKaYMZdshf3SkvREHadMMldUOOAAluTK5rmv4JoGArxHIn5ataG9OahfhNfimQ5FmHuG0UIYc+FjegP/IE6ahLV55M+8o50xs8ykOgtYZnjDAT4qQ5mwE7s32P6ApqZj4wYA8Qjdcl0hilO6wBZPGQtg7napgTJeb05ojKVHWIikFWXxUqyHw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6996.namprd12.prod.outlook.com (2603:10b6:806:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 02:25:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 02:25:18 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 23 Sep 2026 22:25:14 -0400
Message-Id: <DLN6V14XZ8NE.1K05F25N0392O@nvidia.com>
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BLAPR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:208:32a::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: 179a5859-b634-4087-e7a7-08df19e3134b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|921020|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HcNfoYbut5M/9zn8AVIc91XBhtOGnC91KVSylIqSELfUAEXHMRBrNDJi8I6q773kAHGO28DXK6taP+oU9e+VKylHcvevPPdv/yIY5JlbW7kidipUN2IMgp1Xjt5U/suaM1Ba06wHQBo9WTgRS1K969Rsn2zdv4r+rohOg8gYHEINJP1uyy8pPDdELNpaHOF64UzjQfmsW5l5GQLrIWAfzAoqupgT3imkGOj2prIZv8S34lGU9J1Q8yTrUOcJATYDmkjSCGLwRR7zqm57tld7X7tC7/0l5PCDwyqT6JWTwb1vuDpqHj9PIz8IJrkn+KdYS3znfL+nDuXSGgDI4FFNj+xntS72psRgifaJ5kNspBiGTrmTgPedrR0RFWD7YR/TiMAJIl8rPAX9pE0BwEhh/ryPX3KRMJHCQOQ2OwOBhD9bBKP14YI8OtFAY5j6N+erCPAfxMOHfnpoh2S7RS88KO9RX3KZugtzOFGBcefyDHc/ds9hg6EL2fJ9N8blJYFwgSSBjO/gwD7+Vu7bYbsYR3UA0W7lEktn2sAh/1lMxaN4S0eBw0S9AAXqsklyVk/Voz+4cLdHYxlm5/jrs7coMinhpqTmfCqTNOL+Wn6+hqqDdSxLUtAD6ipMz2PVWvmO+yFbClQyecEnFujwzGLPyBhE82YphETAS6+izb/Qxq9lrrQ2kenoT1HdA9aja+pPL6FXAkAnOkJcPNP1vlNLIA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnJhdnVmeFh1TjNKamQzUkZaS0x3bzV1YVhORzROc2J2amVZSFl4ZjRnblBU?=
 =?utf-8?B?R3dIMTN2UEdrRkZDVGFXSG45bnhDNm4wYTNJZ2lFemczYzhsekpPeXRvT1BP?=
 =?utf-8?B?RVlDb1pxd21ycXZsUTBqQ1YyVGtsbXRzbmdSbjJtd1pWVHdQOXloU0c2T3hR?=
 =?utf-8?B?aW9BNCsxb0UveGVLT25DdytYU0d4UkIxQmh5MjlLckZDRmZWZjN5V2djaVF2?=
 =?utf-8?B?N3NJdjF0bkpUUEZCL0QrNm1udTNFOERNNW0yWU5NM2NhWEQvTnJ5WkFHVkph?=
 =?utf-8?B?aWNxL01WbnRCck52cXdYcFo3MjNXRU8vNXB4UHp5QytLWENCOWJ0UWFSaWFn?=
 =?utf-8?B?aW5zTlY0aXBQMDdHZFFUamg5OWNGa0VxYmxEbXgyQ3lHMjdpenZnZmU1MmhB?=
 =?utf-8?B?cmFGRGswM0dacGpEeHducytySExRT2hWS2piUDlGUkRhbTJ4ZHN2RzZWRURs?=
 =?utf-8?B?RCtoVXRqREVHRzRBMlB2NWlockphbUg5bmp5VUtTZzZwNUVjSlN5djNLVDlU?=
 =?utf-8?B?OE04UGRMKzVVWFgrRlA2V3I0NlZQTE1PNEs3dDQwSWV2MXBFY21tV3BhTFQr?=
 =?utf-8?B?bG9zNU5BaU5YTW92OFdzTHNDYnlNVTVmMEpucDlGOStYWVZDSW5PdEhCQWhz?=
 =?utf-8?B?WFBlYURmOGpvNDNZQmlpcEFxSUNkRExXbUpRcEVWZU4xZW1QYVRFMEZsV2dB?=
 =?utf-8?B?MWN0MUhpN0NRbnlsZEtQY1NiS3lvM3hOS3MrOVJOQUxOY0FvaFBQQXhuY0ZK?=
 =?utf-8?B?Z3ZCaFp1ejR0S3RnZXlpdGtFNmpuSXA2RUdlU2pPWGxPWkVJVlEyQXVkaktQ?=
 =?utf-8?B?K2dqUFkvWVZtNkU2UzNYMXVtbXd6QjQyNEZOL0tUazAzWjRReEJXQi9Sc2tN?=
 =?utf-8?B?YU0vVWpMang5bjBRYUVLOUtUOE5XdURDTHBObHNydWk3MU9aaGJ5OWRKSzBz?=
 =?utf-8?B?bW56NUVYNGhBTDRmc1FzSWNMMmladzRCRXE4VWhOa1V6aFZtQjJOVzhoNE9w?=
 =?utf-8?B?dkkxNjd6dE0rY2Y2WW9UcXRaR25PZmp0ZFE5RXRKTThIWm5jRVV3T0daYWlv?=
 =?utf-8?B?SWFBSnVhVzlPeFo4MSs5b1ZRTU82REdvWGlLSVpOMmQ4NkptdHV3WUhVTGtv?=
 =?utf-8?B?bWVNL0xkRHk4WjZ0a0ZzelBYTHM2SHNRa1M4MTkzL0ZkRU5KNDhmcXFvWm4y?=
 =?utf-8?B?cGMrSHNjYStGY2sydkhyaTdMbjdFR3BPdUNzazRxNlQ5c1J4eCtmT0pldHBL?=
 =?utf-8?B?RVNJSHNCalpuVGtVUWJLMVpjU3FqekZwWVlNNHBDUTRLbUg3VVhubzFCa1Zt?=
 =?utf-8?B?NmdPaGhBZWJQL25OdndCQ2FqYnUxTU9DdzdoVDBuZEJUY3Q3SFp1QURQeXhv?=
 =?utf-8?B?N3NEMnR2NmQ0WGFSNHpUcXVaZUl6aXNSMFZxRXp5NGFXYU9Jei9zNWF3cWIw?=
 =?utf-8?B?YWVETEFDSWtUL2ZqSmF5K1lEZThGanVTalFQdkxrQk9IK1hKbWhrZTZjWkRs?=
 =?utf-8?B?emQrYmM0QStKUXVzbk1Bbkw5TUlBUXNYTFNYMUhaSUZmU1pmR1c0YzRESnR3?=
 =?utf-8?B?K29lZmRsZ0tOR21QYUZVVnBZZWYrSUowWDgyNUE2cVZqVC85cHZBZ3RRUWRx?=
 =?utf-8?B?S2IzekpxRXRhb055NVVDUVZCVDA0U09WYTg2anc0bTRYT3JheEFoNlhNdzlo?=
 =?utf-8?B?M3RoUzlMZnRFTEc2emRWL2dNUnlWYmNtZEpraVBGS3FSWVA2TGtxRDJLRlFW?=
 =?utf-8?B?Wm96dzQ0dWIxRDhQN1dNZDkyVWV5dU5CZVNMWjAwdXdZQUo0ZWdGT2RUSXVP?=
 =?utf-8?B?dW8xQy9Peml4UE44d1E0cU1lOVRZY3BsRUd5QXVadFZuYnJDRHA5NG9Edzly?=
 =?utf-8?B?ZU41c1JUOWdqT0dYUy9VMm9zVWMrRnBtSlJKdzJXKysyNTd6anE4UnRjMVNn?=
 =?utf-8?B?UzlSRlB1bTlJaW15Qjg2Mi9ta0FocTJDNjlZZ2JORlhBay8yNVN0VE9JaVRy?=
 =?utf-8?B?eWJDQlRVcnhJRDI2MW9uUkRBallScFk4ZEJqbjViVXBiNnFqOVREQk94bWZn?=
 =?utf-8?B?WXh1UlBUaVRPdEdUa2VsZDYyWnhqVXc3NmZjdVk1aDZwVEpFR3poMVFvZ3pR?=
 =?utf-8?B?UGd5Rk9wWWlLbk04dlJQdzQwVVFBampUZ1ZvSGsxRkROWkd5eVJBTCtXb3hw?=
 =?utf-8?B?VU1uYTNlVmdoWnhYeVE0VlZQUUhXSGcwekNmODRWZGllZE1NRnV5bmxCOEQy?=
 =?utf-8?B?UHliWWRIaEU3cTB0NjVMVld0a2xna0ZDYjcvSHdNejhPNmRHVktjZHMrNWZW?=
 =?utf-8?Q?IdD+4PNPJhOkUbngby?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 179a5859-b634-4087-e7a7-08df19e3134b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 02:25:18.3509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGKxrXUiMfJK40WjNQAHEVbSl/K193OCF8KqZsQ2EN/AV7QxcidZSbqmugY04nP9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6996

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> It only makes sense to manipulate VMA fields if we allocated a new VMA,
> rather than merged it.
>
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since i=
t
> never touches an existing VMA. Previously set_vma_user_defined_fields()
> overwrote the merged VMA's fields with those set for the new mapping. In
> practice these are the same values, with rare exceptions such as shmem
> selecting vm_ops based on whether the file has been unlinked, so no
> user-visible change is expected.
>
> Make this dependency explicit, and additionally constify have_mmap_prepar=
e
> while we're here.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
Makse sense.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi

