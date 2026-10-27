Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793060027;
	b=tNMwY0r8fj2LopjJ174VBhIaz4VziHJIz9oqYGFG76ZVKr69mlTjNz1Kw10NqvdQPlUm
	 7lPMvM7bgyEqrzo115Qij4A5E7Fone3wrzb1GQL97M0BXtRxCozDMRPEGODIePsDnBd0L
	 b7h5Zz+HjuIspl1H/Ln1a3S5rd4SVWdjproiXaMd9BYPSjv7RQwQO1/RPnnQ29lobtbhh
	 OcNDyIg8mE6aZ06RGRMnxk5PkxJ43Fh/iJ0EhfC2e8s3zI/LNqBgOHCRln/b/Fwa1hmEc
	 FVKAl3wqAGAjIq4AL2kE7QQus8HSNZlOjalI0kSBbKgZk+zkFQYTlw6Ym5UMc6xrXxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793060027;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=si+Qhande5UvxFya2tFMhl+nVzGoE+GcsU0vRngX6G8=;
	b=5EY8LVW7b13bD9ILsBUEc/4tke8yXY4OvrlFd7szSDjvNax+fpqING0sy5Fl87ExvF4y
	 mEku5bCeDWtbX2Rp1/DnxayzfBYoKSZIyvmyw0Tku0hqDL5S2kH4l6ZoeBDKBxej/JTLm
	 X4hlkmBhAb+/aR4Rn/7k81a9vMgNU4AJFfN3LrmQK9ASPpn2wOtn0/KLXM0kra9ftdDPK
	 3bHQXL82vPLwrgwEcHQ/kNLJe4hQMbpPqVCAPR354WshyD++uVco6jbpgnmWnOEoJoCzK
	 ooo4IMTUqcVldVpmjnhrCjP/7+t7oYWNV7to2igz6cm/0nluqPQKNmT0DG/ssu5q0Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=U3YGvdOt;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=sNtb+bIv;
	arc=none smtp.remote-ip=202.12.124.138
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E931606A323
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 00:13:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E931606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=U3YGvdOt;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=sNtb+bIv
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.stl.internal (Postfix) with ESMTP id 6FBFC1302033
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 20:13:46 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Mon, 26 Oct 2026 20:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793060001;
	 x=1793067201; bh=si+Qhande5UvxFya2tFMhl+nVzGoE+GcsU0vRngX6G8=; b=
	U3YGvdOtK5z0MLENZikfRWb/SLS3tN5q2KIlnncV8n8B6q/88GUIqRcHk/vGydtQ
	FS8sX9A1oRc3mRQPJMpF50WBg9qz94gDLC3+879cQZLNq1dxKLVBYjC/iOaTUChX
	mxYIwZLx1N3S7bbCZ/mImfn8wbd38nHV7hIgmF7vOKzU3+YYZrTQArEcc9rh+B/b
	KMdlqf5SKzL/f6s1EDnpY7XZ8W3nVEZg2L4msxlrfAqv/Jk0j7ZUlk/GsDSjkXPc
	ldA/XX4CvvPyKEcROFVx1tYb/KKG9fiNGXG9DUyjX7qxlOooitBLu4KPvsZBp7i9
	9oEthDoRglV3rZfQE2aOZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793060001; x=
	1793067201; bh=si+Qhande5UvxFya2tFMhl+nVzGoE+GcsU0vRngX6G8=; b=s
	Ntb+bIvyt+finyiKcLyWraqD04yZyKS+0SUAaPYjEqXDnBV6zHgtFQ/8TfAY9oC2
	NDiZXZWH0JHbhKyfa1dHcOfE0J4IpkbiAbjxrRL6Y92l1UGmObDGPnVKe7qP6YNt
	ST33rmDlLN6L8h6ZJEuWP90+wHD72V6+GnQYLlAgKBpi3+n3Tgh5LXp1sVOi4boh
	Bf6krYfz26TvqByg1xmWAI/FLJ4XaWMrrOUl2SAGfnYbLBUMdXBTuQqeXeSFgFhJ
	3u/qloOapbu5S9e4vggtczW5heu5UykY3T8a2TZe7BZh1Nhjsya/HZaj/yXAM/kO
	TVxuIgUxJs7lnyHSGRSHA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793060001; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:HlVr9Xnc9y3P6KrsYYGMf/NUnL8t+Z5IlZnUogRFuG++Q5j
	tk6tn6almawiB4I3TBuumm/RRRszluS7TGsopJehfyFut9DCawmdAoXANxJ1CtKo
	/dnZ2ifJg8Nk3yJr/49qBTESY2s+DlK1O5PN2Y142d0KISpCr7DWDWrEKIwp2ujY
	nzUIoXIGTNNZOsJWdsJWrVGxiMnNhY7KLhByY2lC3dmy50olm+llGQgWlXj9jOrd
	IZuEcGgeWe3vx2wSzZEzZhWe/dGBQB0fBRPyuG/zJTPs/5MmSvF0o5xQ5yD51S27
	PiQovGs6d0rk2xo5WJektzZyl5dPjv0fgoTbkGA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:HO8bCNZuevoE55ZZzGJNSZMW2blajER/wEIsZJ9pK+U=:caeGQziho4FRHDY3cNygzudu2C/MJTIFaWIByauHPSA=;
X-ME-Sender: <xms:l-zfarV0xYG9cXbLNAjMRS-NGrB533bJUDrO7tw7IQmuiTHIfxDTsA>
    <xme:l-zfauYiWBD4kCpdnyho0MnGGS33y2LYgKSF3XrgxyjM0QpY1wMBQocd-rpAOPVla
    nZ0dh4NOasjKIpo07zSdaKi1DqWFf69ISgOfkfcgdJ9b6UCfL3hL_c>
X-ME-Proxy-Cause: dmFkZTEkf/YaqXBD6OkPCTBsCAQbPu2YW9sbt7UK3+UhRfBeofSSrl6hJkJHf9dF0rJg3N
    JfESDt4DvGRtzl+GmwBe7qsV2Za2TtScaDpwb+1nPiSEC23L7O5/QDGDDHkkqePFksREHl
    XU5dvNKC1hdHByCH0NgqiobHBjKrbj9jbD1I59fEdgTH3JMsZ6ZfDuO/z1c68fjUXFLL2r
    J8hVDQMrH064UmFfogQ8Sz3DesWwtSvTSw63x8Z2kd6ltXcHMkLp3Ud6vNRQYsKU7hjmRl
    /dP3RtDx62S+ikAxBE3BB1G+xG8JEObZSy6tVfPtEaGsqzPsdEyV7tjpBYy5RPu8eU7BtS
    pv/NdncJ9PUvwVRDTUHemZZgQCYS4NTDfHPcBktTUdmOVeXMmbEO8J4RkdFLvOctoGnsjm
    MVxFXKbZLUEIAQ1qS8Q5E64WXtwtwZQLEOfzHiJJZqf8ZryZPcMBmzKQXQ0QwZaN8ISNoJ
    S/ftgSQ59xD5mN0KYsovSy7v5Z8EmqiU+uzfw84F4PDmfcqLkrFleRwPnXor2ZPToL7Wwl
    zTDxlH62iD2P8UDUZF6+tWzflaIgNhpxvWwWeDJ+xjJX2nrXZjEv7k2ySwKy1geKMzAXKF
    fXgvX+juI9JxqNHFvQYpFjKMgWBUIHvrzcyM5V1fLrWdFMQTCqVFLDiOYoUQ
X-ME-Proxy: <xmx:nOzfajGF0xNsYNmV8YCc2Pd7UeABRUtRBqoYjhYIYDhiMjlpvI7yag>
    <xmx:nOzfapiRovMD9ZE1E5hDJaY6sWPoZ7pT4XzsIJ-j-hZWrrCg_-UouA>
    <xmx:nOzfapbAE3BpExg8FlH_xCskPyBv08PzQc5zXuuGtwgjeA7VlWveEQ>
    <xmx:nOzfam3GHyXyAuCx5jGFzvSyfiLGeSUA3AocyLyTLvC2vt2ZvIcxnw>
    <xmx:oezfastyPfBJRPG1FGvyHsNW7nf3RRKHw_57JGdRsQgtKDzwvORkdPKN>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5628B32A0093; Mon, 26 Oct 2026 20:13:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AUJ1OXWu3nCJ
Date: Tue, 27 Oct 2026 01:12:50 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>
Cc: "Thomas Gleixner" <tglx@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>, "Kees Cook" <kees@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Jim Mattson" <jmattson@google.com>,
 "Jens Axboe" <axboe@kernel.dk>, "Pavel Begunkov" <asml.silence@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, "David Sterba" <dsterba@suse.com>,
 "Chris Mason" <mason@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
In-Reply-To: <20261026215226.3713941-1-jthoughton@google.com>
References: <20261026215226.3713941-1-jthoughton@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
>
> This series comes out of a set of bugs that were found in KVM where the
> kernel can sometimes write to a random process's user memory[1]. The KVM
> fixes at [1] are still required, even with this uaccess series, as noted
> by Sean here[2] and below in this cover letter. The beginning of this
> series includes fixes for similar bugs found through static analysis
> with Claude Opus 5.5. I don't think any of these bugs are more severe
> than the KVM bugs[1].
>
> We hit one of the KVM bugs in production, and it was challenging to
> debug. This series makes such bugs, where the kernel is doing uaccess
> without an mm, much more obvious.

Nice work!

> Such an access does not reliably fail. The user portion of the address
> space belongs to whatever mm happens to be lazily loaded, if any. If
> the access faults, the fault handler refuses to handle it and the copy
> fails, but if the page is already mapped, the access silently reads or
> writes another task's memory.

This sounds like the problem depends a lot on the architecture,
and to what degree they implement lazy mm switching. If an architecture
makes all user pointers invalid for a kernel thread, this does not
actually happen, right?

E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
the current process is only set in user_access_begin() and would
not point to any task here. Without ttbr0_pan, it should be
covered by cpu_set_reserved_ttbr0() turning off all user space access
for kernel threads.

Should this perhaps be addressed in architecture specific code
instead of in a common place?

> == The New WARN ==
>
> The rest of the series makes the generic uaccess helpers WARN_ON_ONCE()
> and refuse the access when current->mm is NULL:
>
>  - Patch 6 adds uaccess_should_fail(), which combines the existing
>    should_fail_usercopy() fault injection check with the NULL mm check,
>    and uses it in place of should_fail_usercopy(). This covers
>    copy_{to,from}_user() on all architectures (including the masked
>    user access paths, which never call access_ok()), the
>    __copy_{to,from}_user() variants used by KVM's guest memory
>    accessors, the user-backed iov_iter copy routines and
>    strncpy_from_user().
...
> The checks are deliberately limited to generic code. Accesses
> implemented entirely by architectures (get_user(), put_user(),
> clear_user(), and direct users of user_access_begin() or
> masked_user_access_begin()) are not covered. Please let me know if the
> new check should be placed elsewhere.

I would think that user_access_begin() is a more natural place
for the added checks, as this should be called exactly once for
any function that accesses user space and also stays out of the
way of the copy_from_kernel_nofault() etc.

       Arnd
