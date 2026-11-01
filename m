Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793571358;
	b=WRYXjjqcdiymMtLEDeK4EJy4oXhfR3SovdrmA1GLFQOmfNzWwBt4WpuGr7vYd5qznl7B
	 tw3HpHJB/w5TjnMS1bZQjJ6TeiUhZGEKcQZeU/gYj2E27gClQas20c2X2P8dPfozszdS9
	 Kor4lxKNJrrUpAHIBVqgecKnqgEnwwr5xTsHpKKxAvdR9xC1fp0ReZZ0OUDT9TfXHsPN/
	 SnZ9M0nNSPH7RQ4oolC7q9oW8SuP/bDDtavfwEJINKNAGNqbG17QWpZ6WJ6Y33P3rKQWQ
	 mUqLi2ovjm3FdZt513vPID4dlSWahY2H0YWYo9W1gbhOpkwH7VkXo9yKdJvIjvCnTXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793571358;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=FTHI4iJKGW8nTdZJYWi2ZEsJRVp05NwkVgRYnkQTnQI=;
	b=1QHtu6rNVURm7eD0rqTrDslkatx7XA0p/kvhzHe/A3lWszK0pPcVd4b6Yj0NUWYhq7bO
	 dYTFONS1nTgl3HIy6MaT2k+lWdzFfp28U6CLkCrfemkqR02GGE/QI8ktiTsjX5dAicfD5
	 mTiCP2dmdXI+LJfYkXxdQhphEYRWZvtZQlMkz2p+nTEoYtsm++RRFMPeR9RF4D7+WI7nX
	 BPfxmKmPZL1wFmoE+JZdRUTW5MYN/e2sDKTcR+shOEGorjHfH6Z3y4Rbc3EYKDi0nA00D
	 wjoCzNMpYhOETbbxvNiIMX0fVVT6ZBRl/V+UIu50+SKBIc6Gbf7DVzuR6M8GLMYXH4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSuQm1gi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C24F60A2602;
	Sun,  1 Nov 2026 22:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSuQm1gi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225BF1F00A1B;
	Sun,  1 Nov 2026 22:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571353;
	bh=FTHI4iJKGW8nTdZJYWi2ZEsJRVp05NwkVgRYnkQTnQI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kSuQm1gig26F3a5hbFrlCEgTV6KZdAUm8pVgji64pGU9IHFtmj1+0lqa6FjFwtpwY
	 RQDDMAWpx0nuTd442k2/dkXZmO3ak6/b0bODbLMMOiXHR7sqan7+OYTSomVvsVhatc
	 5sO4YlxH84ZbDrCWiv6NIlf3enn6ckTlaSH0A2hbLwanZ7TAw2vRzqI9LjdgxD9mYw
	 rVyzHjy74WbfzuCKilIc61p8YM/etpQQgk31aiPP5AoELP2cxYQDze2rDXYJz/8udp
	 9mbnMTtDK0Vamho7QvOMgWKAobDTF7XMy60kwODafcPU8OakiOi1fCrlQV4kt03Hd9
	 bPj8B6YTEsy3w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 032DA38003B8;
	Sun,  1 Nov 2026 22:15:53 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 00/39] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357135155.2624073.13862678489444424470.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:15:51 +0000
References: 
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: 
 <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
To: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 david@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, gregkh@linuxfoundation.org,
 dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org,
 paul@paul-moore.com, stephen.smalley.work@gmail.com, perex@perex.cz,
 tiwai@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 eddyz87@gmail.com, memxor@gmail.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, dgilbert@interlog.com,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org, simona@ffwll.ch,
 deller@gmx.de, sre@kernel.org, jhubbard@nvidia.com, peterx@redhat.com,
 mhiramat@kernel.org, oleg@redhat.com, peterz@infradead.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, riel@surriel.com,
 harry@kernel.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, arnd@arndb.de, muchun.song@linux.dev, osalvador@suse.de,
 willy@infradead.org, jack@suse.cz, maz@kernel.org, oupton@kernel.org,
 catalin.marinas@arm.com, maddy@linux.ibm.com, anup@brainfault.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chengming.zhou@linux.dev, mhocko@kernel.org, miklos@szeredi.hu,
 xu.xin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev,
 ihor.solodrai@linux.dev, spasswolf@web.de, tiwai@suse.de,
 emil@etsalapatis.com

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Tue, 13 Oct 2026 16:04:40 +0100 you wrote:
> The VM_SPECIAL / VMA_SPECIAL_FLAGS mask conflates several unrelated
> properties:
> 
> * Is this managed by core mm, or by a driver mapping MMIO, kernel-allocated
>   pages, or even ordinary pages itself?
> * Can it be expanded or merged?
> * Is this a 'weird' case like mlock where migration might race and we
>   'have' to set invalid flags to notify?
> * Is it another 'weird' case where we just want to stop GUP from touching
>   it?
> 
> [...]

Here is the summary with links:
  - [v6,01/39] mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
    (no matching commit)
  - [v6,02/39] mm/vma: introduce and use vma_[flags_]can_merge()
    https://git.kernel.org/riscv/c/86a779c53204
  - [v6,03/39] mm: consistently validate VMA state after mmap[_prepare] hooks
    https://git.kernel.org/riscv/c/9cae38dc11da
  - [v6,04/39] mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
    https://git.kernel.org/riscv/c/6335c786299f
  - [v6,05/39] mm: make map_kernel_pages_[prepare,complete] internal and unexported
    https://git.kernel.org/riscv/c/2a234f79d416
  - [v6,06/39] mm/vma: tidy up map kernel pages enum values
    https://git.kernel.org/riscv/c/4852f3421456
  - [v6,07/39] mm: assert mmap lock held, use new flags API in vm_insert_page[s]
    https://git.kernel.org/riscv/c/dad8e88fcfce
  - [v6,08/39] mm: add mmap action for discontiguous kernel page mapping
    https://git.kernel.org/riscv/c/b7b4d8f37a4f
  - [v6,09/39] docs: filesystems: update mmap_prepare docs for discontig kernel pgs
    https://git.kernel.org/riscv/c/ae60723abb65
  - [v6,10/39] drivers/usb/mon: update to use mmap_prepare + map kernel pages
    https://git.kernel.org/riscv/c/5323bb5f6ef3
  - [v6,11/39] infiniband: update hfi1 to use remap_vmalloc_range()
    (no matching commit)
  - [v6,12/39] selinux: reject writable opens of policy file, drop mmap shared/write check
    https://git.kernel.org/riscv/c/c6ce4378f20a
  - [v6,13/39] ALSA: pcm: use vm_insert_page() to map PCM status page
    https://git.kernel.org/riscv/c/ceb0de27371f
  - [v6,14/39] bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
    https://git.kernel.org/riscv/c/0c2c9885c5e9
  - [v6,15/39] mm/vma: add vma[_flags]_is_mm_managed() predicates
    https://git.kernel.org/riscv/c/7fdbc26b69c0
  - [v6,16/39] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
    https://git.kernel.org/riscv/c/d99c4a302c5a
  - [v6,17/39] mm/vma: add and use vma_[flags]_is_fixed_mapping
    https://git.kernel.org/riscv/c/9201d0f5b9d5
  - [v6,18/39] scsi: sg: convert mmap hook to mmap_prepare and rework
    https://git.kernel.org/riscv/c/abdd54cef5fc
  - [v6,19/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
    https://git.kernel.org/riscv/c/19458d015fcc
  - [v6,20/39] HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
    https://git.kernel.org/riscv/c/5605c40895fc
  - [v6,21/39] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
    https://git.kernel.org/riscv/c/2d2b1c508f21
  - [v6,22/39] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
    https://git.kernel.org/riscv/c/0d219bc3cb88
  - [v6,23/39] mm/mlock: clear VMA_LOCKED_MASK over mmap callback
    https://git.kernel.org/riscv/c/61e012ab9a1c
  - [v6,24/39] mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
    https://git.kernel.org/riscv/c/aea83f2694ed
  - [v6,25/39] mm/vma: enforce that mm-managed mappings may not set VMA_IO_BIT
    https://git.kernel.org/riscv/c/99fd6bf43d5d
  - [v6,26/39] mm: remove VMA_IO_BIT check in vma[_flags]_is_mm_managed()
    https://git.kernel.org/riscv/c/88d77002e1a1
  - [v6,27/39] mm: remove hugetlb_inline.h
    https://git.kernel.org/riscv/c/94c86564538e
  - [v6,28/39] mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
    (no matching commit)
  - [v6,29/39] mm: drop some redundant checks around hugetlb VMAs
    (no matching commit)
  - [v6,30/39] mm/vma: introduce vma[_flags]_is_mm_backed()
    https://git.kernel.org/riscv/c/44debd840ec9
  - [v6,31/39] mm/madvise: update is_valid_guard_vma() to use vma_is_mm_backed()
    https://git.kernel.org/riscv/c/fc95d1cf4a13
  - [v6,32/39] mm/uffd: use predicates for userfaultfd checks
    https://git.kernel.org/riscv/c/fb700342f506
  - [v6,33/39] mm/madvise: use predicates for madvise(..., MADV_DOFORK)
    https://git.kernel.org/riscv/c/1d1104fe6dc6
  - [v6,34/39] mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
    https://git.kernel.org/riscv/c/531e56359ffb
  - [v6,35/39] mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
    https://git.kernel.org/riscv/c/5997da57a09b
  - [v6,36/39] mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
    https://git.kernel.org/riscv/c/8bf792b7afcb
  - [v6,37/39] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
    https://git.kernel.org/riscv/c/72a993449cb0
  - [v6,38/39] fuse: dax: do not set VM_MIXEDMAP
    https://git.kernel.org/riscv/c/b0d88bfa7515
  - [v6,39/39] mm/huge_memory: remove vma_is_special_huge()
    https://git.kernel.org/riscv/c/e2a1d080f510

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


