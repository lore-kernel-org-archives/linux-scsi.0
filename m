Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793127092;
	b=VWQPTowdEQT25nPp0LUpNxkklcZmr358yZAxy7iwHVieTHXjxb6I8NUl1S9hBcmisEck
	 gebiPJZwsb2buT64EC0DxqBzhJwI2D5Lkxy3XPZWGIbXDC3JlgNsk1FIVnwo0KgJ3X1/i
	 cnYJ3Tn+xK+LW0PKnxVFA6U3BAvM12FRqiXXLMlHDawkRtKeO1oxkvJrM9mjtpCRzJkUp
	 BVqXYKXIXe/MEc3n8L14TZHr7FWFpDYP0Avk4btm8qgPwxMhtblC02cr7wVPb/yOu78zX
	 co2z7tQxDywxQ6fci9A2+oDiZj0xCXrswm+GpwIVrCp+RwqEtOpndwM9T1tTyb/EYew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793127092;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
	b=lS+Qs+4IiZZrkVSRKOHCo9qxp1EKIfAO3dVmhCkWFF+oY2csF9Oo0rV0AK9wiOj+NrjX
	 +QSXUs+VhPXMxB6Pd+jKcoXsJwidSuJA2mbhAgDHPo2LdoYSu9XhlDID6hfTkeemP4hke
	 O+2AoBiQlIR7Iv9xhQ0nmARRT5+XPUmS+m+eG+FOCwM4gcE37LfKSRTsgetFu9pIv0HES
	 VOISG8r5UELG03KSedaqDHVfTwLz9J3qTn9Ojzywx6AMJsmRJRrgXjae/ODKabT3w3nL6
	 v2T5me8YefihCkQuR+56UuZg8t6nuuyLM6ChpcDuWwBg6t/V6H2XHdrsOf5npIgSPqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HFK9DQOj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B5A606A31F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 18:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99B5A606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HFK9DQOj
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c3fd91337baso21459366b.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 11:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793127090; cv=none;
        d=google.com; s=arc-20260327;
        b=E7TlPh5jcCSewxeA6KMQ4bkHFoxvD9RkoKG61x+zCAhBba8PdZgXz00QTAflwgLJ/t
         PVRbd1F2f+p8hYpV7whcoTFklWBmWwufnhb8Ud8d62ip5wBI/pz57gJovmkiCdbRb+Cw
         gbP9KiJQOfIHSFUcZapk7zqGMx8bfmualoOo9DoIeFFXnWfbC+WCmlp7pV1/t1uJtlN+
         F42IIc8hCn9ZJ5TPzS0dC2vra0PMFAnQk5ZEcF16ZSY76PuMzfq1e9mF/mmKMA13tweS
         x1Cy/tybLdMT2O7TR6X65EqZpJbuipewtxtU7qx9XmJMtryi4Cjdy3zRkD663juJhscr
         dqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        fh=anEsDqP2Ct4yTH6Sb28v197Pq5RiroP12xDz3HyY8+A=;
        b=Ys5WuLmkxXxJQZF6gRGyloGttUOIFVYtphCd3+gRU3U4R8Zeqwx3PpxZAIltQaNEAz
         W5RNfqDz3BlSMEH0tonzRxvoYt3U2mHDIdOLfpdUoJL1UvxmQtH+qpv3VOe4hF7KG04k
         +Fcb/E31reVao35LT1+1821DCciukLrPCwgqy+Xn5khCP34fDUzwRTkw2j+mPwcvNGTP
         77bxiXm7e/yxln0xeYdXxyobnghdANcErCVmPC6lUz25+HDJsD0Lq6FZJ5joCob+kyau
         ZcHShbv546JLulSPY4cDpxq7/f7425fUON9FZG2WGjWxWbjUHWOW083JlHQ/VHPe/cXj
         IMOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793127090; x=1793731890; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        b=HFK9DQOjx55GzwyinowY3WKQr1IsXRiJeV+D7Z8hkiYPym2ZUBwoZvUifqN/FnkNGU
         pfa1ZewvhEMvZLoaCIPFZp4tA/umOO4oOn0eM3xlRhU2sdWIJfNsPw9HVJXR4LYjiytX
         dUAGwL90rw0Q5w+OWsW5iboZVP9RCytMSNYKe3ji15diP1zhAfgrHC9FvXhRMxxUMt35
         TQ2tHe1FHlUZ2NICIb0rhXxsSpvA5sFGf5zLgnOgSw/RZnKbxxQN9s376gQ8m4D1+J80
         lvL/AJdZ7uKnroRkKZncUslhbEYHXR8yj6xbpQX2rU8tK9ueLcaFgAw4VAp3h++AYDrG
         cmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793127090; x=1793731890;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJlLnl+V5fVkcEdrgjKFPN24Q/fJ++IZ4ZhlDmWxnT0=;
        b=emJl0AlcH2VXJxnzJO3kaRKlavTlTET5odwR83gezS1wt8ssEY7eVU8tg3PUnxihwm
         UVs/qBdvRbCJZR5j1MYy7Eju9D/aRGkgaSwNjWdDWQJtrB6fNtlEUaOKwN1a4FDtYG2N
         A/y1qESoFCPnj1i7TaNrcVED18FJFkr2XCleEwXKKMVaPJA1uhI0afDEMaPPcwR4vYEc
         qFf+ayGmSqkOmlH6PVeSf6MyxczxyV66iGCB9RTkfNPYLILxiofAz3g1eHD4YtgMHi9i
         l3HhPOUC4p++W6B8tjCgtJUx/S/EzuvzxCcRyTau1fF1EmJAnc3d6zhj7glIV6Qao0xK
         uL6Q==
X-Forwarded-Encrypted: i=1; AKwUvByicGZcUoljSSUrrIYutE8Tn0mq0xnsVSGfUVDTt5Q/rbpnHAOoAKQiVy+4c/JF+tNasPNLH1n6LwhP@vger.kernel.org
X-Gm-Message-State: AFq9FYIYX++tL57sT01Bd4/ekJJe8pWndvUXpAPZigqYDkqkVf5+9vQX
	gKX/xCGULqhNh58c8ukxlOjuGihSOTcb9WMlPKBzdXTwciOUQEhGs7KrNwJXAaSSRBAIJFYF/ge
	1/RD9z4Yr3AheOTgbrxJ1TXN8Pg7caMvT4nV+AL7b
X-Gm-Gg: AYBFou0AiyrLiH+MoX6xeeWHu3V7EYaNt8mRZRcOCOKOxQMBk7Wad5b2F12NMK4IARr
	JIJLBIrmstCOHLC4qlT0dlOw4TbaImqA29wIEws33EO9Kadv5/Zq0Wfmr7TtVL7pTN7SexY93tm
	wSVdJf6J0TC/e6TyJ7shez2+WAEp8zLoaADjJEqEQ/AuSQL0G/VRRfyaZ/Bv0xeDRbHNIxSdDrN
	2sMMbMnbC3EqGmE3vuYMio/xh8oQpbaGHKKH6gyo4eOjlLtTk0AR7sd9h/N6Y3gLLxgDus3Z33N
	Ywk6W8iwr3wR/A9X8KmJY+HJmIn72HyH1yYKd9mxgVyHaz7P6p5tD70elxGyIvgLTCjyncTa8sW
	vo23U7tZIfFY+wN/kbgDCcWXEXY3q1Wl68spp/v/87r4QnUxI1A3spJ2DgZmSstpj7Ef9THjEgP
	eQ7nbK+vf9ofG9V5e6jkIb5/HeMYGIew+C6r4qQjfKlYGQ67mOBYyEHiINbtT0/AcW17breETXJ
	OnUDPrfzK76WotPlO2IuXYs6nt5aP2x4w==
X-Received: by 2002:a17:907:a08a:b0:c41:8e21:4d5a with SMTP id
 a640c23a62f3a-c49bdb68d78mr15531766b.5.1793127089381; Tue, 27 Oct 2026
 11:51:29 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-4-jthoughton@google.com> <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
In-Reply-To: <10ab2f3b005f0df2c0a88e93e6917826d928bb1f82c6a645f942c099e48f8b6e@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 11:50:52 -0700
X-Gm-Features: AclHuK8M0uftDAMQJptfiH_zotg0NLNK0vqcV1a8EUqq1l3N0gBPNm3WO8H3TD0
Message-ID: <CADrL8HVHCVoh3AToNzFCe7KP=yC8byCGCzGYzzBEGYtYNC4fJw@mail.gmail.com>
Subject: Re: [RFC PATCH 03/10] bpf: Fail sleepable user copy helpers when
 current->mm is NULL
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, tglx@kernel.org, 
	peterz@infradead.org, kees@kernel.org, arnd@arndb.de, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	jmattson@google.com, axboe@kernel.dk, asml.silence@gmail.com, 
	James.Bottomley@hansenpartnership.com, mkp@kernel.org, dsterba@suse.com, 
	mason@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, andrii@kernel.org, martin.lau@kernel.org, 
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26, 2026 at 3:30=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > bpf: Fail sleepable user copy helpers when current->mm is NULL
>
> TL;DR: Commit message only: the security_file_release() example of a slee=
pable
> program running from a kworker looks inaccurate, since such a program app=
ears
> not to be attachable there. The fix itself looks justified.
>
> > bpf: Fail sleepable user copy helpers when current->mm is NULL
> >
> > Sleepable BPF programs can run on behalf of a kernel thread, or of a
> > task that has already gone through exit_mm(). For example, bpf_wq
> > callbacks always run from a kworker, bpf_task_work callbacks queued
> > late enough run from exit_task_work(), and lsm.s or fentry.s programs
> > may be attached to functions called during exit_files(),
> > exit_task_work() or from kernel threads (e.g. security_file_release()
> > from a kworker running delayed_fput()).
> > In such contexts, bpf_copy_from_user(), bpf_copy_from_user_str() and
> > bpf_copy_from_user{,_str}_dynptr() (when reading from the current task)
> > call copy_from_user() or strncpy_from_user() without an mm. That access
> > does not reliably fail: the user half of the address space belongs to
> > whatever mm happens to be lazily loaded, if any, so the program may rea=
d
> > another task's memory.
> > As there is no user memory to read from in this case, fail with -EFAULT
> > without attempting the access.
> > Fixes: 07be4c4a3e7a ("bpf: Add bpf_copy_from_user() helper.")
> > Fixes: 65ab5ac4df01 ("bpf: Add bpf_copy_from_user_str kfunc")
> > Fixes: a498ee7576de ("bpf: Implement dynptr copy kfuncs")
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> The commit message gives security_file_release() as an example of a place
> where an lsm.s or fentry.s program can run from a kworker:
>
> > (e.g. security_file_release() from a kworker running delayed_fput())
>
> Is this example accurate for the tree being patched?
>
> bpf_lsm_file_release is not in the sleepable_lsm_hooks set in
> kernel/bpf/bpf_lsm.c, so btf_id_allow_sleepable() rejects a sleepable
> BPF_PROG_TYPE_LSM program there.  bpf_lsm_file_free_security, the other h=
ook
> reached from __fput() through file_free(), is in untrusted_lsm_hooks rath=
er
> than the sleepable set.
>
> For a BPF_PROG_TYPE_TRACING program, check_attach_sleepable() requires
> within_error_injection_list(addr) (or a syscall prefix when
> CONFIG_FUNCTION_ERROR_INJECTION is off), or an fmodret set with
> KF_SLEEPABLE.  Neither security_file_release() nor bpf_lsm_file_release()
> has ALLOW_ERROR_INJECTION, and the only fmodret sets are in
> net/bpf/test_run.c, net/mptcp/bpf.c and bpf_testmod.
>
> That suggests a program attached to security_file_release() is never
> sleepable and cannot call bpf_copy_from_user() or the KF_SLEEPABLE copy
> kfuncs.

Great catch. Yeah, the examples aren't right (but the fix is still correct)=
.

> The fix itself still looks justified, since bpf_wq callbacks run from a
> kworker and is_async_cb_sleepable() is true for them.  Only the example
> appears to be off.
>
> Would an example that is actually reachable keep the changelog accurate?
> For instance, bpf_lsm_task_alloc() when kthreadd forks a kernel thread
> (current is kthreadd), or bpf_lsm_kernel_read_file() and bpf_lsm_file_ope=
n()
> when a kworker loads firmware with kernel_read_file().  All three hooks a=
re
> in sleepable_lsm_hooks.

I've adjusted the first paragraph of the changelog to:

  Sleepable BPF programs can run on behalf of a kernel thread, or of a
  task that has already gone through exit_mm(). For example, bpf_wq
  callbacks always run from a kworker, bpf_task_work callbacks queued late
  enough run from exit_task_work(), lsm.s programs may be attached to
  hooks reached from kernel threads or from exit_task_work() (e.g.
  bpf_lsm_inode_free_security() when the final __fput() of an unlinked
  file runs from delayed_fput() or from exit_task_work(), or
  bpf_lsm_bprm_check_security() during a usermode helper's
  kernel_execve()), and fentry.s programs may be attached to
  error-injectable functions called from kernel threads (e.g.
  btrfs_should_cancel_balance() from the btrfs-balance kthread).

I think all the Fixes are still accurate. The first Fixes isn't very
obvious; re-checking it with Claude provided a pretty clear
explanation for why it's accurate:

    This is the subtle one. In 07be4c4a3e7a (v5.10) the sleepable LSM
    set was just bpf_lsm_file_mprotect and bpf_lsm_bprm_committed_creds,
    and both always run with an mm. The LSM examples above only became
    sleepable later, in 423f16108c9d ("bpf: Augment the set of sleepable
    LSM hooks", v5.11), and bpf_wq only arrived in 81f1d7a583fa ("bpf:
    wq: add bpf_wq_set_callback_impl", v6.10).

    However, fentry.s was already allowed on any ALLOW_ERROR_INJECTION
    function other than __add_to_page_cache_locked, should_fail_alloc_page
    and should_failslab, and that list already included
    btrfs_should_cancel_balance() (called from the btrfs-balance kthread
    via balance_kthread() -> btrfs_balance() -> __btrfs_balance()), as
    well as btrfs_check_node() and btrfs_check_leaf_full() (called from
    the btrfs end-io workers). So bpf_copy_from_user() could be called
    without an mm from the moment it existed, and 07be4c4a3e7a is the
    right commit to blame rather than 423f16108c9d.
