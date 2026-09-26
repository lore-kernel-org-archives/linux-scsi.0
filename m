Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C0E2E7BD9;
	Sat, 26 Sep 2026 13:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790428040; cv=none; b=LHTFsMpEt13USu9HeMsUElviBDbXakGh/BVQrLdDpdPjfppJc/k301DI/JS7U0dOhkHQa4LHyCkQwCzeT6g6RNHtXLWrqzYQ4S/tDf9KBIHKC4VPrct090TXd2TboaIEaQdE2VcgzZ1zOhC8KR/q3X2TMuaH3qjd6gUS+YebX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790428040; c=relaxed/simple;
	bh=wko7kmHoPQKSvHJFu02PIBG+REawZo/0kXd/Igypq3o=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=PeKUwu/VkZcAsYQlRhD/aEYl/9X1wk7hWEjQ0J0g32Dpz2cGUSiNBpQco6qeEVcVocgMCmUsV3ZagJd6oTpN+D0Zd0wVxQgYD0chX2YyFpkZVc7x6nikuNqW3FchIz4QGPS3Oc5Znazd4zNxadz/Pkz3EMBRLGmaWdbBOST5ouM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=GUmK00Nm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CFCADCnP; arc=none smtp.client-ip=103.168.172.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="GUmK00Nm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CFCADCnP"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id B12EC1380386;
	Sat, 26 Sep 2026 09:07:13 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Sat, 26 Sep 2026 09:07:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790428032;
	 x=1790435232; bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=; b=
	GUmK00NmjYxSwfTBR3tVNjpqLAkVRWaCBtQW8hPgHgcvYPwGIIBCDq+aR194QZJV
	hmIcmgKgFrX27w+CIuLZuGT+yAFPNfLObwbKGmV03uNiklrcV1jmuaY6kEgV6x+q
	WRmC/1yuc3swDBfzqYG9TWNOngXm1W05PRIhj/dtOD6JqYWH9z9czT6feZHU2JL3
	JlQkDDPxveVpZogI1dYghXXZz++8wtMbQ/lGmn0NVM61W0LRFcwZWYUslQl8bO8O
	UX5rFh6elLuPZ8IbUOIIE0sUFyCCB2PLQbbO8ZRv4Z20dH1JfoSTZZZNWihCrVx9
	4U3VBA18TINEk/vd5YlE2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790428032; x=
	1790435232; bh=E/0Aixz4MoGQbluxHxh98fr8xrgoH3pVa08CacPtFqs=; b=C
	FCADCnP4fRR97/s//gFNfg+o+dRoT3zAGmmVQgzGghEZGGxzUUe6/HRcoxd0Wg1G
	g/HL22FnHnD3JvV0Dgj/rtpsMttSHnLk2hw5GuDQVsB9O1YsKx0PDaNwhGHxs7Z4
	3yzAqm5Dy1VVfvzQEYifHlvzaW2kEkSCIoH/+P2bVn2V9YgQVxn/pdYQA2rgNAx5
	67xRqC8Rz+PiPjdOzdId03n7pB6tcKzF4LBtK2G+iJk/8veJj42P4Bud7seJhcKM
	a9xTeAIp8QgYEr0LPZkLtZzLvDWJ1EdO7EU5y2Trcfp8zShGMwSGmxEVyk27RcDm
	3//dExIenidGLUR3jnVhg==
X-ME-Sender: <xms:d8O3au7n76eGhw2jpYdaVcHYn7upNz3419mg3XiM0JtuvZuHQIUVeA>
    <xme:d8O3aitofBqjo_lbLDOAU7mZfGFzex12BqHRTCkWnEKu20vrV6Gu_C_19EF4s5u5Q
    uVEwdBKfpJgOZoKzIw3RmstgUNQ8069BcGi5cScnfwl2JtyCll0uws>
X-ME-Proxy-Cause: dmFkZTGUsKpqFXqlz0GGP/SFu+nZLjbDSu7At32QI34HLKVvf1fGYqDec9fSpPeFMwM2na
    lCIyfst1DkAn1nxttW/0OGqAIcgR9hP0+9KRaczAEVzAiyIUrCzfAz3NG4OEkYMphPiska
    sxzrcia7B/OfHjuc0OL3x2A6enil36KUIzawLytpDPNS07jW2p5hyCyp71P9EehHhgSWHo
    13Bfkrk0kKx87sKF02XDEMx1t5GR+s+avdeSQ+AKRYbyaAuXdnE7xZSXQLdPsxEPtOlIpj
    o0ANo6Se5VTMUcD0Mj9SJPo17T3fs8fxxCSDV2AftKwgRroxTJNkJPQnQ7BWLJ6W6fgTL5
    wcNX32wzcM+QcLysY+pG69bj2RWFiUEd6wCYRTkVdCNfg7iFgjgAMtc09dsEXp4rUb9h87
    Oh8IM3cXORgKjuqI9lWC+3kWwTogF+JMgqrNQVO7wVPJtcj/YPXt3JSnFSK50DuW3jJQwf
    vC9xfsQarOpSwgT1SAHLeR5I1+SexGjeb1uJYikij/Vz/Qj8km+B2lRt2ir399BexDXylD
    PxhinKlmSGCiwMsbu3RaQoA44Ynwc4XeDZEW0AvzHcge9LqoiYgRJjopaNATJs7VKeCwkb
    Jf57C98/6wGVpJMIDVVR8ZEuU5t017X4o0/d6NVEbPZlm4dkUa5KYbehg+PA
X-ME-Proxy: <xmx:fMO3apNP7HWsw2MPRs-ieBJZJpJm3doBBN88O0NvYsDI9Xk97LbkcA>
    <xmx:fMO3asQhfZWmNKKQDfWOq1r6BmT1NpDzrtyIVNly6k8o72fqmwu0-Q>
    <xmx:fMO3av5b2ChKxwow5wOHgSJTP_6AHC2Hcrx_qsRy59RQjkEcTmxgSg>
    <xmx:fMO3agURH6NbNbT-w9t55VsJrrqeLwZ3RwxTXuqbm65L-K8N8i-6xA>
    <xmx:gMO3ashG8E4Vx1KpZYgMvK8nuPd1Idi8GbsxL2-2Fwaj5ZgG-zhsdId_>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 577F132A0087; Sat, 26 Sep 2026 09:07:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 15:06:33 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet" <corbet@lwn.net>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.com>,
 "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>,
 "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Zi Yan" <ziy@nvidia.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Nico Pache" <nico.pache@linux.dev>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>,
 "Usama Arif" <usama.arif@linux.dev>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Doug Gilbert" <dgilbert@interlog.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter" <simona@ffwll.ch>,
 "Helge Deller" <deller@gmx.de>, "Sebastian Reichel" <sre@kernel.org>,
 "John Hubbard" <jhubbard@nvidia.com>, peterx <peterx@redhat.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Oleg Nesterov" <oleg@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>,
 "Harry Yoo" <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Vincent Guittot" <vincent.guittot@linaro.org>,
 "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>,
 "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>,
 "Dave Airlie" <airlied@gmail.com>, "Will Deacon" <will@kernel.org>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>,
 "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>,
 "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Janosch Frank" <frankja@linux.ibm.com>,
 "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>,
 "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Chris Li" <chrisl@kernel.org>,
 "Kairui Song" <kasong@tencent.com>,
 "Kemeng Shi" <shikemeng@huaweicloud.com>,
 "Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>,
 "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>,
 "Michal Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>,
 "Xu Xin" <xu.xin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, linux-sound@vger.kernel.org,
 bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <408aef6e-5b0a-482f-8ba8-f8c20ee870e5@app.fastmail.com>
In-Reply-To: <areSEI5pWBadkqIe@gremlin>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
 <areSEI5pWBadkqIe@gremlin>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Sep 26, 2026, at 11:40, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 26, 2026 at 12:06:22AM +0200, Arnd Bergmann wrote:
>>
>> mm/vma.c: In function '__mmap_region':
>> mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
>>
>> I don't immediately see anything that you did that would have introduced
>> something bad that wasn't already there, so it's likely just gone from
>> just below the limit I was using for my testing to just above. The 1536
>> byte limit is what I use on 64-bit builds with KASAN and otherwise
>> still has a clean build (with a small number of local fixup patches).
>
> Hmm are you specifying this limit manually somehow?

It's a Kconfig setting upstream, but the way I'm doing it is to have
patch that calculates a sensible default based on other options that
is a little smaller than the default (currently 2048 bytes) on x86-64
to catch more cases where something sticks out.

>> If I sprinkle some 'noinline_for_stack' annotations on functions
>> called by __mmap_region(), I can get the size down to 1144 in this
>> config, but that doesn't sound like a great workaround.
>>
>> The large stack usage is potentially harmful if this ends up
>> in call chains that have additional large stack usage (e.g.
>> kmalloc() leading to reclaim). Any ideas for how to reduce it here?
>
> That can never happen :) this call chain is _only_ for an mmap() call.

I mean more functions called /from/ here, something like

  __mmap_region()
  __mmap_new_vma()
  vm_area_alloc()
  kmem_cache_alloc(..., GFP_KERNEL)
  slab_alloc_node()
  allocate_slab()
  alloc_slab_page()
  __alloc_pages_slowpath()
  __alloc_pages_direct_reclaim()
  __perform_reclaim()
  try_to_free_pages()
  shrink_zones()
  shrink_node()
  lru_gen_shrink_node()
  shrink_many()
  shrink_one()
  try_to_shrink_lruvec()
  evict_folios()
  shrink_folio_list()
  pageout()
  shmem_writeout()
  swap_writeout()
  swap_add_folio()
  swap_write_submit()
  nfs_swap_submit_write()
  nfs_file_direct_write()
  nfs_direct_extract_pages()
  nfs_do_recoalesce()
  __nfs_pageio_add_request()
  nfs_pageio_doio()
  pnfs_generic_pg_writepages()
  pnfs_do_write()
  pnfs_try_to_write_data()
  filelayout_write_pagelist()
  nfs_initiate_pgio()
  nfs_local_doio()
  nfs_local_do_write()
  nfs_local_call_write()
  ->write_iter()
  generic_file_write_iter()
  generic_write_sync()
  vfs_fsync_range()
  ->fsync()
  xfs_file_fsync()
  file_write_and_wait_range()
  filemap_fdatawrite_range()
  filemap_writeback()
  do_writepages()
  ->writepages()
  xfs_vm_writepages()
  iomap_writepages()
  iomap_writeback_folio()
  iomap_writeback_range()
  ->writeback_range()
  xfs_zoned_writeback_range()
  iomap_add_to_ioend()
  ->writeback_submit()
  xfs_zoned_writeback_submit()
  xfs_zone_alloc_and_submit()
  xfs_submit_zoned_bio()
  submit_bio()
  submit_bio_noacct()
  submit_bio_noacct_nocheck()
  __submit_bio_noacct()
  __submit_bio()
  blk_mq_submit_bio()
  blk_mq_run_dispatch_ops()
  blk_mq_try_issue_directly()
  blk_mq_run_hw_queue()
  blk_mq_sched_dispatch_requests()
  blk_mq_do_dispatch_sched()
  __blk_mq_do_dispatch_sched()
  blk_mq_dispatch_rq_list()
  ->queue_rq()
  scsi_queue_rq()
  scsi_dispatch_cmd()
  ->queuecommand()
  ata_scsi_queuecmd()
  __ata_scsi_queuecmd()
  ata_scsi_translate()
  ata_scsi_qc_issue()
  ata_qc_issue()
  qc_issue()
  ata_sff_qc_issue()
  ata_sff_queue_pio_task()

There are many ways the call chain can go of course, but the actual
stack overflows do tend to follow this pattern where you are at a
function with high stack usage and call kmalloc() during low memory
condition and that ends up waiting for a block I/O down the line.
(you normally don't go through swap and nfs, I was just looking
for the worst case I could easily see in the code)

> In general I am absolutely taking this seriously and will find a way to
> reduce this, but my only question is whether this is actually something
> that needs to be done in this series?
>
> Because it's already huge and I would rather avoid adding yet another patch
> to it if possible.
>
> If I can do it as a follow-up that'd be ideal!

What I was hoping for is that as you are already deep into the
exact code that caused the warning and you can already see something
in there that may help.

I don't think it's urgent, I just don't want it to be forgotten.

     Arnd
