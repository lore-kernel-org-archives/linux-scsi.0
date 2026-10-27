Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.50.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793099403;
	b=hoi/K6ym7mTBdKxY3nYs27ilDMAtA2MzQKfXtH8BWpWg4ZuVdOno5vNCW4AJhW0pV6+G
	 nauLcKJ5ToB1x9rHUt6wY21IM9o+6aRKr7ugRqJlF8rIEwKrE/AC8pp3YoJAGbXnIn/qL
	 aeeuv5DNZd/uLkHxzgGTQ19Jy2hl7BVeiBY5k4l4o/7olN/Vkap7+6atC1vfA7gbeld2V
	 hVDAaufs1B70xFZb+PlPMXQYjDyF8pFilSn6JkEaYLBWb5BJRn+f8cj7KOcv3UooCr2I9
	 pdSx4cjfQ8Krpgaum5IbWVGv0tN/QOBDNMxzkr18mi+03k03nV16JeQXP7KGH9oz1ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793099403;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=8BryABgcZ7DA+XBYIpyIPDmj1TmISKJ+oIODypTsFPw=;
	b=MXVvH2F8h17+v9i0YehnEsGLYpqNyMqtibeDicZ9UHw7Hjhi+1CKCzIJcaov7dQABCFf
	 N0MgGny8WJ1EbKnX+Zr9uhiZjomfnaZ/nCkQbgmTuhXSV9ip2ZjLXzNnF3H3rDo9L0uUS
	 hxd6BDsJ4g7Ls2nTl7+631DSqrJvYM+2adcAkMLebXVtY8CsHTw7NX6PPFld/J3/N6wMh
	 2KqdjRbEEVXpTgu0y2n+9sCpYMUCgbQVrH0B3OnCHXMhvTpRSFINbjCgi9Pi7vJUocIGs
	 avCwmz6wb2/JuC5upb/dlWuYbRxkD8hCHfIz8Ik8R9DhkBJT0dw7Pz5cFS9etNbfLBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=tec1jmsz;
	arc=none smtp.remote-ip=90.155.50.34
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CDD606A31A;
	Tue, 27 Oct 2026 11:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48CDD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=tec1jmsz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8BryABgcZ7DA+XBYIpyIPDmj1TmISKJ+oIODypTsFPw=; b=tec1jmszyHzg20Gsi9B9OGtdi0
	bsCvcBUhd46e/5/GXq6SGAww+LVpHIHQwe0YKWk72ihksfy4XUJrxTbGdLAnv+D/3l8x0l5pOrtHd
	7acMwSIp8xdaNQ1AIn1SBzFfdKqfG47ktiRrG9Gdqsr6nFLRAKQwd+iSUVX0qRopMxZbjuME3IWYU
	rWWjhVhXS7N+lyNQrK9sV4YC1izjgWJLVZnwjd0PysDBxqh4LXHJQqVbGOqt8gUresF7JGcKsKk/M
	4u4+TrZIvctu40uV383GKM/IXYMeeS9/2czQz3WkAwKHaXgRu8pQpjnw4c+liTKeH/5Cd28W8xTcV
	Jq4Gy6Aw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLf3s-0000000D9LE-3APy;
	Tue, 27 Oct 2026 11:09:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 385DE300312; Tue, 27 Oct 2026 12:09:48 +0100 (CET)
Date: Tue, 27 Oct 2026 12:09:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Thomas Gleixner <tglx@kernel.org>, Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	io-uring@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without
 an mm
Message-ID: <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-6-jthoughton@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026215226.3713941-6-jthoughton@google.com>

On Mon, Oct 26, 2026 at 09:52:21PM +0000, James Houghton wrote:
> get_perf_callchain() only checks is_user_task(current) when the regs it
> is given aren't user mode regs. However, BPF's bpf_get_task_stack() (and
> bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called on
> the current task, which are user mode regs for a user task, even if that
> task has already gone through exit_mm(), e.g. when called from a program
> attached to exit_files() or to the dying task's final sched_switch.
> 
> perf_callchain_user() then unwinds the user stack without an mm. That
> access does not reliably fail: the user half of the address space
> belongs to whatever mm happens to be lazily loaded, if any, so the
> unwinder may read another task's memory. This affects e.g. arm64,
> riscv, loongarch and csky, whose perf_callchain_user() doesn't check
> current->mm itself. perf events themselves are not affected, as
> perf_callchain() already clears the user callchain request when
> current is not a user task with an mm.
> 
> Check is_user_task(current) regardless of the regs' mode.
> 
> Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  kernel/events/callchain.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 9d24b6e0c91f..a451ca2a5573 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool kernel, bool user,
>  	}
>  
>  	if (user && !crosstask) {
> -		if (!user_mode(regs)) {
> -			if (!is_user_task(current))
> -				goto exit_put;
> +		/*
> +		 * Even if @regs are user mode regs, e.g. task_pt_regs(current)
> +		 * passed in by bpf_get_task_stack(), current may already have
> +		 * gone through exit_mm().
> +		 */
> +		if (!is_user_task(current))
> +			goto exit_put;
> +		if (!user_mode(regs))
>  			regs = task_pt_regs(current);
> -		}
>  
>  		if (defer_cookie) {
>  			/*

We have perf_event_exit_task() before exit_mm().

Still, it doesn't hurt to be cautious. So no real objection, but perhaps
adjust the Changelog?
