Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1824570E1;
	Fri, 25 Sep 2026 22:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790374019; cv=none; b=KnF68ceULhHuwl9zGkE4KpadXcCo6dieB5pZxfwwdQhfx5EslvNRRqqmxFUm61zWlvrkq5cvHzh+nhe/R7TNEO8c9DNfZghyHYFtelAJXDWBWnFnOEHVl2jJ5/y+PipPF236SrMZILhlIa2RU+2llb4QyylhhFtBloJ9bPGDfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790374019; c=relaxed/simple;
	bh=lS1TxV0OL5XbjJoEVVQOxIs/WZv/eAgyubI3NbbQssI=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=qBMOiV8XKYqE2k6LV4zGN+Ym0gNRay1evLw51EiIATao+r3QN1HLgUuNYoQbBZRKgtdG00suqHJJz+Zv+bRDauX/f0jlv9G/IRgVP00uVEiVlZR+Q36ywtU3gzLx0vNyhQ4Hrtw0SPFpKcOD9ivHoE8kPXv9GeTZh5VBN3yN2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=VV93A+GB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aGXV+YUS; arc=none smtp.client-ip=202.12.124.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="VV93A+GB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aGXV+YUS"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.stl.internal (Postfix) with ESMTP id 573C313003B9;
	Fri, 25 Sep 2026 18:06:52 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 18:06:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790374011;
	 x=1790381211; bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=; b=
	VV93A+GBv2P9/qrRdwAhHm15SknYpPDoE9Rusj/hHzckBkjJVEcdDlJTHlO4p/7E
	MsStEr6lA9ZZpv80ctYjcMxWtVfeFtMzS2Pz6b48b4mBBrO1C9yPQ1m/yB4jrJsU
	Txgptg/CZdFHDOAYUVRGXXi1vMAjXp9R2q/zkAVgu2JU57U6eOhopKB9vdNOWomM
	8KEOhPJEGjfknNt7dRh1N3UcGrPPo322SVDR7u2P7ODyCz9fXvOMVKwB4BGJLV4d
	p1vZk++EfDAgCFACQelPXp+bGzwficcKO8bwIm5qbPT1tKzqp+6Byy8nrSst/iUF
	5iM/+XBRXhRzlq/3FdZWSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790374011; x=
	1790381211; bh=JrMmm48wWb5nfElfLTql9tnPeB0+8MEVeYNyAgGoaQE=; b=a
	GXV+YUSmJZBpt2RL3eFg0yROgDvjwUpne/3aX5qHc2ia1wEVE/khGVzWW2IGsz5l
	hd3jDKQVGFxsM4ytzm0w/bh9v/Q0fmxggROD5amVZbL2IpyazCJKEmXcfYygtqXQ
	BNuhNcefmS8wBdPbdpsyQgC85zo4DoYIA7PTlnLy/b0B7TGhHrMTVWAcQVUniEoZ
	1QJGFj+nGWa8IGhxIs0v/xiIAUYiBM7D6MMeI7Tqf0DCWrqnH693KRkitqw3jAgQ
	k0QlTsip1+o1bnRtNhMLSAe/LoZeLLRCKWTKQF0vQQ12dvxRPUWAYPzU7TrYn2iP
	xq/lsXF6iBqKAWrtf+W5Q==
X-ME-Sender: <xms:cvC2aiSvwM8it39YGAo0r2BFMlajZQzHCF1-wybOlfFNnzuJE4_VgQ>
    <xme:cvC2aim-IxtOzGmBKYQptfJ-5tq7fGqg-34DIWlZzsqMywgEQ0mR0QgqWq_6cb9JX
    NjtResFg31PUDdRrYBtL-YJLF1e2pjmDFCJzHcjJRCB_VemwzQ9RdVm>
X-ME-Proxy-Cause: dmFkZTGWorUwcHDaphCYw8v7P4r6eX5pMArEM2/fjfsVfdD8oh9PHyAFGRqsP8lKRNOvro
    Ftaux56ZQWBnJufjCK4NoTl5gmyZyS2NrT/mOlvXaJbBgwyJlksfmDxh/T6ep3Q5rP1X5I
    Gg3BUF69X8e0yxuG8tIsosXhwJWN04kZfd3Hs8hAZ/+JOdcATDpskVHlGuS/IemkueryOR
    hIuVjhFQk7CePHMlVc9CQ7MECLINzrqb9LdZmsZGkkEkpHSYSPer552CpRSKn34v37USct
    HhFuvihTiBMck5qt8HqfIL/ioFLlYd+AoG7CwtlhshQQ5QWzjlxpGOjuQuzfN0lyT2CNBA
    xiE3/XVFoRJUnTcPHXnnP4ULg2/OhUw0cUVTM2Hl8kzEGyQmxm0APQJMTvjFGoCeexOfR/
    jaxLRyktqvX8daF3L239waW+lQXkj8NIMZ45sRs0hondG/NYNiUtlwijloNURLVJpSRs1n
    HjrVk8mAadcUojfqUFKMkwbvd1knunWFqf3wFKqO35MyuIsff+Lt3vTDKNneO2MS2loK5e
    Q/dybw3p42QGSplvXOieL4zZL+ZwpJVbWdxv7+d9YbwYEGdtccmCLCVTEkoohZKIitwDZF
    bbnjGJjj38fYWu6AOjGxXX1gJyhzi0LUn/N6YtrvJoDdXC/mveLWJ3hmsmrw
X-ME-Proxy: <xmx:dvC2amzBvlQCAD5sW2JaXm3j0P9ai-oMPjy5v8vXmarN-S8XKRnZUw>
    <xmx:dvC2auHhsX2b7IMnKKPnB_m7lyGmqEgN3tOfWJI43cbUmyqJIJe9DQ>
    <xmx:dvC2avqA9un_ie7CCszm4rHR5kIbiuuqJAmgxGMKC0t4LTi-ke-ZMg>
    <xmx:dvC2avxp2MUpSON7EdEvlibuWv90i4hC2qOqz0DFeopE6Lyo9tYUDA>
    <xmx:e_C2asxjh4_ZZbt6wpAEkh3al--Q2E5cOHCufEezSsf4Ch9A-LWaZN6L>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 548BB32A0087; Fri, 25 Sep 2026 18:06:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AJwEWD5WPnhk
Date: Sat, 26 Sep 2026 00:06:22 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
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
 "Xu Xin" <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev, "Takashi Iwai" <tiwai@suse.de>,
 "Emil Tsalapatis" <emil@etsalapatis.com>
Message-Id: <d4d7d4c2-a1d5-41d0-b1c8-8ea0cc5a0397@app.fastmail.com>
In-Reply-To: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
References: 
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Sep 17, 2026, at 18:22, Lorenzo Stoakes (ARM) wrote:
>
>  mm/vma.c                                   | 246 +++++++++++++++++++-------

Hi Lorenzo,

I see that in linux-next there is a new build failure in some
configurations in code that you are changing here:

mm/vma.c: In function '__mmap_region':
mm/vma.c:3083:1: error: the frame size of 1552 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

I don't immediately see anything that you did that would have introduced
something bad that wasn't already there, so it's likely just gone from
just below the limit I was using for my testing to just above. The 1536
byte limit is what I use on 64-bit builds with KASAN and otherwise
still has a clean build (with a small number of local fixup patches).

What I see is that this function has multiple structures on the
stack that have nontrivial sizes:

        VMA_ITERATOR(vmi, mm, addr); /* 104 bytes */
        MMAP_STATE(map, mm, &vmi, addr, len,...); /* 384 bytes */
        struct vm_area_desc desc; /* 128 bytes */

The config that caused this is https://pastebin.com/raw/5M95qHy5,
which is an x86-64 build with CONFIG_KASAN_STACK enabled, and likely
a few other configuration options that made it a little worse.
KASAN_STACK tends to double the stack size used by structures
in order to catch out-of-bounds accesses.

If I sprinkle some 'noinline_for_stack' annotations on functions
called by __mmap_region(), I can get the size down to 1144 in this
config, but that doesn't sound like a great workaround.

The large stack usage is potentially harmful if this ends up
in call chains that have additional large stack usage (e.g.
kmalloc() leading to reclaim). Any ideas for how to reduce it here?

     Arnd
