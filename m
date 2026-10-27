Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793123182;
	b=yPMCQQqMQjXTHMs7P49TCb4SrXveq4inDN2h3lwyUUDApYrHOeWf+oks6/naF9XQ+Ljt
	 7Xa53lJPvWmdbCXSqwWmIO4yY4BnSNwpv2/u/sy0Ixu/qkj+NdlkK56IdSsYa0cnaUzhy
	 YwJ4LDZtnhIpfCII8y+mOjt7lunOJosRez++rQi61zEbYQNZRyzFwePamBuvciXb/MASb
	 WRZzHSs65Q3tT17ljoQM/33ILhi7TXr7oa62mJD61aQcbqJFFEnksIiGIn09nWajsLv7y
	 t4ExtOtaHBgDKkC5nbgPSnnT/wuzmyCgPigIGvjZRyQTetR0laMAgtk0dhYfTM4JU3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123182;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
	b=4yqV9vk4/39uaoYdYA98Hwsq4TIZYjApV8aJEzitBGNEu/fOTUrWFkKeLf2oGzujTbu7
	 O5fxqH1hZo2FXtXTIiLH8Qv3L6mCVUhS+sJ11InBVD/L27PHTZe+ofp5nKlcyb3z+Gg+O
	 NScARyf/77Xv5LvJqASUNAKtyrGJs0C5MTud8+9XMbJW6l/zfnC+mY2U8V8jBSfKOMeWL
	 8SnQi6kOJtgAqIjY3Uf81yKkOLfFRIEL8MXymcNTLFKJcrCQt2YxS5HmDRyVy+UueBXfC
	 BMttdImjL2t9Dlf1VASMjlqwzZ2yJ0IoH4QvrQ1viaLKDsRmvJe9fRftKNTTE+wvEPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dJZrWgbc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09A606A324
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 17:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F09A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dJZrWgbc
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c423b145922so9773266b.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 10:46:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123181; cv=none;
        d=google.com; s=arc-20260327;
        b=FAG6Aq97Kglropv16PlL72d41SqZ3bGp75XxM05Zibm36s1134HKclo7M/Es8ieaqN
         gTAeLzogwwiRWsQS9NvUXnMdV/pZxENYDH8esGvKHhs+9ngSMXr/6zTiHq6eXBYd2rI0
         L7MDolf2nkFf+6Vy9SaBLoSFCBWDA0M5AjdjlDQYbgqKmJh1uEYJueQXtFAhvTqHqixz
         qZ1MRqZlDWAm4ySE8/1dh1m+ofIk7UJ/61vx71gufblYzgwMLQ7Ii11ETd/28XPjTh4J
         92fRr4ety+NN+hsMZie3ClQjIxELTDJ+UhtHh4+bWi8pCqU9F7VzZjQ79jrM5Khib8rL
         e0iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        fh=yEd4zxDoGpwFW3WkOJVnIreWZ/3ElkvraY/H7CUoQ2A=;
        b=nMAAjm4k67mQjkbjzUVyh6fgcN2Xw91AVCCfnSNF4nxpHIYZEpd2v3Sk+ofB0ZqWYA
         bX/5NFs9sbN9ilO7Ket0MzdyJMGPuy9xSPWy+cvQA2ehBtEVi+gl0hEqtR9jdEDwXWYf
         zZe2RA+He+0GCCRQd/rUI4LC2DcW63j9yNkz8HQtuopjuTVM+kcno0ZIsWRxUtP8+WSt
         DPxgt84Bz/KCWBbxj0ZwkNZU+oVtNXkuNoaORTNnr3+8wqeNdX0wq3uaWhgdUZBJqwqQ
         LlFZCWJ2JCMW1aK/tMxCmqePhJLlkXNm3cT2UJvYmbWCiDD76cfVFNKhphqiVR3yuV4o
         q8dg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123181; x=1793727981; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        b=dJZrWgbceCcvybGI6S+yBWHGKTnRTkeoo+QAXarbXhuJJrcuUxjX6DL3VJxyeJguO7
         EIXUQuToxD9Oj2ADRK5huhz3YAPfLd6CErpWQOPm8uk8bar6rE79bi3bMLs3pZe51bGu
         X4MzPetzpkt4sIfnqO30iZNgo0TbdVmPtmqopEkvLhUnsg2bhmTSLgRVVzhYHy701dNf
         Q0OtvKJRnZ80/E3NbSjyx0npRgDvtmNSPb01SZjgkwzglNyd+xHEbqih3MUFsYvHWiHM
         BQc/ZWywC5lvAnEYkPeZz4JTWFyCYlKLP3X73YxsX8/hg+Ad4REwmoFnONsNmbYY7MNG
         Lt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123181; x=1793727981;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        b=T5ixxJCi5io5wV4Ap686/QQbsrkYavugSSeNnaKlKa+nSaLLrOEXR9Y7DwgvCHzHfF
         /TWcxPU9tGCSfkoo6y2oYQ2DcNN2EbGtp6KWTcSWXKTfXVxm262o6SVFEcLWJmQ88Odq
         2EPZjr04aCMyG4IedOlwPtnq8vnh6RN2SvdEDtPFwZ07RSq/8s9DjEM5VenY4pzU8udQ
         l4+QRROgJJduj1+l7C8HGUfoe/lvl4N8vUl1HEgJV49Ni1vCUvLYyBvbMGQ9uYPtQcfm
         Nm2oo34T3+LS9YkNTEuAb+E508KkMrHOczlwNcVmWYZNAQUr3yvQ0zzytP1d/WGPln8K
         S5RQ==
X-Forwarded-Encrypted: i=1; AKwUvBy0R8KUtiUTmKFnzRDF2RGslissNVtUEfQIW537RFiUZsI5vR6Wc2B9jo0th97DD+27P13jnZm6xD54@vger.kernel.org
X-Gm-Message-State: AFq9FYL37MM8ojttByOMayniJV0x6qbWhohtsN+Um5evj1DVAvAMFNdV
	7QRLXotn7tnPFGMh/JwCT8QidRMYzphhmTIxAw4S+L5YwrZaA6xjaRqC75Tzx8IVOhoobvS9wwZ
	1ZSFokB+DEaGLXvEGx6abkn8dOfTZQ+/PXm2WIPtF
X-Gm-Gg: AYBFou1frncs9sFax6yEkB2pE5bmmxx5O3AjGWnNBP2YeI6xRiD2bbnjLXPu4pfaBcZ
	nhd5pI6fiB6HK4vdW7f2gPl7la2Jkg2FVdmUS4VvuiFZHxVF0W1key357XKKDk8P3c/wGL4Jede
	KH51y6wGxbiX30irSAmVmjbv0hx5o/judnlky3EoFv0nLeHaqE5KOg+fGuRtrO8bDkor1dipbPb
	ZiOAzV63e5Xst7YrXA6gd2rGASW6Vx6DBUq0WbZlLp5Z95J0FHkz5Z7ZV4DYM9HstDpUM6LANv4
	qiGcJLwGStK8rrNimimWVyOzytCa0mGBJD9D7q7BbaYUAfJd8PzudrdctSoLm777NQkcpaJDb2z
	VJFW595h0gs3zOcJqRT1EjoKNcxXDYlOhlrjx6d5vfvgL8mnJZ6gwgh9hkTkEJQu0SosA0hbyMv
	l7MDsaYLvV2tKqWP1ajh42d00qxH6W5kxKC+auF7oKxRYPkg46/BNs/oITJoVJEks6J6rV+yEbc
	TF6T08mTllbZScSxe6CYX03+q5y0G/Lig==
X-Received: by 2002:a17:907:7b9e:b0:c41:b94c:4538 with SMTP id
 a640c23a62f3a-c46bdec03f8mr1197886866b.47.1793123179946; Tue, 27 Oct 2026
 10:46:19 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-6-jthoughton@google.com> <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
In-Reply-To: <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:45:43 -0700
X-Gm-Features: AclHuK-GDZyG6m8BFpUMWxfSIBXFJlvlZbCjTm5c1oLpEFzow0OEe9cdwDWWw7s
Message-ID: <CADrL8HXtBxf=qixBZV5-iz1sqfZAqSrMR4ZsJTFXS0N84G+nkw@mail.gmail.com>
Subject: Re: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without
 an mm
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 4:09=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Mon, Oct 26, 2026 at 09:52:21PM +0000, James Houghton wrote:
> > get_perf_callchain() only checks is_user_task(current) when the regs it
> > is given aren't user mode regs. However, BPF's bpf_get_task_stack() (an=
d
> > bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called =
on
> > the current task, which are user mode regs for a user task, even if tha=
t
> > task has already gone through exit_mm(), e.g. when called from a progra=
m
> > attached to exit_files() or to the dying task's final sched_switch.
> >
> > perf_callchain_user() then unwinds the user stack without an mm. That
> > access does not reliably fail: the user half of the address space
> > belongs to whatever mm happens to be lazily loaded, if any, so the
> > unwinder may read another task's memory. This affects e.g. arm64,
> > riscv, loongarch and csky, whose perf_callchain_user() doesn't check
> > current->mm itself. perf events themselves are not affected, as
> > perf_callchain() already clears the user callchain request when
> > current is not a user task with an mm.
> >
> > Check is_user_task(current) regardless of the regs' mode.
> >
> > Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  kernel/events/callchain.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> > index 9d24b6e0c91f..a451ca2a5573 100644
> > --- a/kernel/events/callchain.c
> > +++ b/kernel/events/callchain.c
> > @@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool ker=
nel, bool user,
> >       }
> >
> >       if (user && !crosstask) {
> > -             if (!user_mode(regs)) {
> > -                     if (!is_user_task(current))
> > -                             goto exit_put;
> > +             /*
> > +              * Even if @regs are user mode regs, e.g. task_pt_regs(cu=
rrent)
> > +              * passed in by bpf_get_task_stack(), current may already=
 have
> > +              * gone through exit_mm().
> > +              */
> > +             if (!is_user_task(current))
> > +                     goto exit_put;
> > +             if (!user_mode(regs))
> >                       regs =3D task_pt_regs(current);
> > -             }
> >
> >               if (defer_cookie) {
> >                       /*
>
> We have perf_event_exit_task() before exit_mm().
>
> Still, it doesn't hurt to be cautious. So no real objection, but perhaps
> adjust the Changelog?

Right, perf events can't get here, since perf_event_exit_task() runs
before exit_mm() (and CPU-wide events go through perf_callchain()'s
is_user_task() check).

The case this fixes is BPF: bpf_get_task_stack() calls
get_perf_callchain() directly with task_pt_regs(current), so a program
attached to e.g. exit_files() or the task's final sched_switch would
unwind the user stack without an mm.

I've added this paragraph to the start of the changelog to make it a
little clearer that the perf event case isn't the interesting one:

  get_perf_callchain() only checks is_user_task(current) when the regs it
  is given aren't user mode regs. That's fine for perf events: a task's
  own events are torn down by perf_event_exit_task() before exit_mm(), and
  samples from CPU-wide events go through perf_callchain(), which already
  skips the user callchain if current isn't a user task with an mm.

Are you happy with that?

Thanks for the feedback. :)
