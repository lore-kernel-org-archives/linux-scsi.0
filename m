Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795557763;
	b=CTTS4tTyoepmkkde03UFvhrz/lLC9wupWmvG8pt1DGGC8Tu0qzxxUNi7/yefpWQqGSGV
	 I+NfPHFZ6yPqVEtQCnkXDp5wwFJGcQSt9ed9UrIKjrT+QZ8qas+xfZ/tgwgUBDkoVAmd0
	 0DVJ0bpOEdDBnZunpURpMtwr9POohZ/YFgaxihUO9GWSUHEd59sEY42Btcz1UW+WAmmX0
	 67vAbbFQhYM+YkL9xM98dF9TipSJ1D4cy6toD2TceXgHr/F+hI/kgQJ6/lqKkjix2nhO7
	 Xk1Nh8+XaTa2//I26oABqdLyK5eBqpppLw1Mt/6eQJcZX7FB+7060EQGcmN75hWTWmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795557763;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=xqSGxC68OuGq0f3lY+sfYUCqjXoRvtvCw0BSPI+8ZKw=;
	b=bCetgvVw47Za9I7fiIR1E+mMn1wfBYBIvRu3XsLDHramIE8kLb0TwbJPwEosM6FTNDbY
	 I5mUiKmz61HBjC92cM19GacaKGLC13KXJsSqzxtsiKv4f6e1l5foZJdPeu/eWUkzVNQIn
	 yqXmcUTJfd8+VMR5RAcqw2+cJvKrs9I4oAsrNQ4aiBY2Q+KAwYfhnOWoK5pB6VnSmF2ig
	 aDc48npgoJeiLQami3RGfySDnq3CW0Z7i9uT4ykxTP+kWKnQMMM5OjEWVmPBo8sAaX/1M
	 LlslqQj4yK+lOES1jrP8goiOXR2fMQ0PRn1a1Ru31lVYZ/OLyk7fLJfkbiM9rN8XurQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=mfnJGR8Z;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=wbnBnHyI;
	arc=none smtp.remote-ip=103.168.172.137
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C36606A68C
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 22:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1C36606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=mfnJGR8Z;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=wbnBnHyI
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id BA04E138032E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 17:02:41 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 17:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795557742;
	 x=1795564942; bh=xqSGxC68OuGq0f3lY+sfYUCqjXoRvtvCw0BSPI+8ZKw=; b=
	mfnJGR8ZvkU0LMsvLhbkB2aWWyYvVftk34Igv9f+VSyWFZL75F98YRJInsubsg5N
	ErWkbpwwYR8PYwwytDXrBO4Zv5tmqL7Kcd99KBzFrH3plirHNa3BF91ghYHg1G2X
	OmIzUeu9alCUMqYdLPe3t6xGqQDeBJFNzjBkCZdXLIRdfSfdGAENAvBoCa2Hd/va
	6GViewBlkNAzICD3R2R+FvuW+BnNIr3jT+Fl9ot6DTCUyPwgXgiOAE7gr65RUlWF
	zTV1eaMMqoKhfcdTawq7FOwHVOJ7hDxNDHC9/0HIOAI9uDObbhkabN2JM4I0uCwd
	iklYqFK06JlPTifavsWnwQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795557742; x=
	1795564942; bh=xqSGxC68OuGq0f3lY+sfYUCqjXoRvtvCw0BSPI+8ZKw=; b=w
	bnBnHyIX27rhdSGfAc5H4g5+m7drm11Zac2njlCmzN4mbo2YQ6EhH6D3pD/8PeWY
	8GHoNQCNetXraVudoAhL0qYFTYu9qtXjJhzOx0LKjAdkofjkzwVdOhVC1J2hwfwt
	VGDOiyN7FwH93as5zO5o+8QJnGBEUiUslUd724GRZXy/EKfZPjLZu/8oWwovMRB0
	gqyKbJtAxmz5Ye7KI5rrGabmlFjzzdpLjwI7iCre5OXCavuM7GUe/YusH3YuhrsM
	tEnsRe06oXURbQM9aMsO08wVojk5ODAx8uWqDju1VwkBgXeAY+UL/ydC1j0YZtCu
	KfHp2BvZEv/a3sOge7mDw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795557742; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:VG2mADAN+KavdhCyd4RaGiDvblsUIiVDU1P6wAmB5yRi0Hh
	PLnsVppMy8nNu0x0f7oOX9qwNA0Qo2M6ZUD2+MmfjjxLs0/ZAYVnHsfRekt/E+sH
	TN3AOT0mXBZICl01zG9GcsC5pgEq9X5Za4t7wDTHj85edFperyQL3GD07Bfw3XqX
	zX35huGsgYuy5YjQlk1u8nOVSXPUjXqbLv7ib/fTbxNMS9JX7Su0qLsBaMw1hAAO
	FHn4rlEVwL8HqBbCVDF7W5YODz4inmk7IKUEEwWWCtCdrqjffvgHhHzJ8IgPKQGK
	58jD08Gx1wX6YxNpVzZAMpTTa4PLq6DmDTn8A3g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Y1L9ZRjDVf0ae1O5OLJmIEMJoJINj3g0qWcfqpumaM8=:uV7HNzlAfzr4LTvQgcdWBWGhD8P70PVpTMD/LBLagBw=;
X-ME-Sender: <xms:ZAkGa2S1qU5q8Tt4P59rLUZLMDcdcz9MhGSLBcV29aA_t5jwHSVpFQ>
    <xme:ZAkGa2nn-MLHHH5bsIrtUn53Bm6dbM7HMZKuIRmjk9pvX9DAb9jnrJeBrNTX2ODRl
    wAAtRHYTqQ6S0lkRVQTlORopD_RQ-qt5BuiOtcQDZFWBrRtGC248laJ>
X-ME-Proxy-Cause: dmFkZTFRHh3IY7AQpE2sOB2PLJi3AuimKZDL9H1tXPiO9loafbcw/DGlO/Xoejw+8P82CU
    LZtGPx5Dw2fehVmppW39nh7aiKQqHD4K4dz4hhwMbfJ/rvud1uNRBqKqwpOM3ItmC7aGg2
    A+GKbJZ0q/HAUhCKq8KTriq2kSTLiR4BY395K6QXzmGZqOgGBQCeI+/qZ5DjTPzrKb+KCk
    fWxNoXXTvO6/Q9umpMuH+R2tl9qmfexdyWMyjNVwhUtZI0siPxAVzMuaiN62cXkT1LxPsl
    ivdDM2jUMgnHoUAdJkJTv2Cd0wNryoNWCgNqfkM9sF+PCCJ+n2SVasPPSYcFY35/BtjUi/
    TlJok52x6K/qFFOH5y2f4B3BhSmPbdoGhxzStq5W26pndjLaCuALLGrZUSxDowPZL8Uxm9
    tq8OcCqqLGoNK4Gz1S9oU6o18yltNNQA8ylIOP1GM8y9zFzH4ACeaKMpbIKk59CrU6mG5p
    r7Vqugsc+zPL78L05eqJ+Dv566UPYEBjuKKkv+Kuz7Ek+Vcjrk5P3BBEWeI5xh7lI87c+k
    EGduRPaTIxc7VwNPWY7uJsLAvKDYRTBcjLlbz5kr2cdl14XqqH/o219lKVdPi2m4ANFlMt
    HKT2MGXWfnbkl4Zcq1AAqLM5PN7cFVRnArfJggG7bcTT8iycB6wsrFxURFsA
X-ME-Proxy: <xmx:aQkGa5ADK0kQBKydW-jsYQL2owm6ypApuRcgesYyb9gfGqwkudPKNw>
    <xmx:aQkGawu6ACeRQkfy1MUQnkSHymWoFOBsVAuxGxAvsiDY-MRkdjhslw>
    <xmx:aQkGa41LhutcH3hl071xdqmfJ1-SyaJRtJWCEsdFZTLgpNQKlsyu9g>
    <xmx:aQkGa5jbcusQENaD1VV6mJUEOIOUF73AiAns-Bfib3Jpb0Xg437OxQ>
    <xmx:bgkGa4awIhQYBbKzBAjp50sAI32cG5KibTRETI3OZH4oHKFRGLB2KqwC>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id EEB3B32A009C; Tue, 24 Nov 2026 17:02:11 -0500 (EST)
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
Date: Tue, 24 Nov 2026 23:01:51 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "James Houghton" <jthoughton@google.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Pavel Begunkov" <asml.silence@gmail.com>,
 "Alexei Starovoitov" <ast@kernel.org>, "Jens Axboe" <axboe@kernel.dk>,
 bpf@vger.kernel.org, "Daniel Borkmann" <daniel@iogearbox.net>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "David Sterba" <dsterba@suse.com>, io-uring@vger.kernel.org,
 "Jim Mattson" <jmattson@google.com>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>, "Kees Cook" <kees@kernel.org>,
 kvm@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Chris Mason" <mason@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Masami Hiramatsu" <mhiramat@kernel.org>, "Michal Hocko" <mhocko@suse.com>,
 "Ingo Molnar" <mingo@redhat.com>, "Martin K. Petersen" <mkp@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Sean Christopherson" <seanjc@google.com>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>
Message-Id: <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
In-Reply-To: 
 <CADrL8HX5vb1PGDpWzp-eR0rNfsMCVUhFa9vp_WZZx2eJZ+dfXQ@mail.gmail.com>
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
 <20261027231728.1466446-1-jthoughton@google.com>
 <32fad21b-5bad-4640-97df-ef0f638cd9e9@app.fastmail.com>
 <CADrL8HX5vb1PGDpWzp-eR0rNfsMCVUhFa9vp_WZZx2eJZ+dfXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026, at 22:10, James Houghton wrote:
> On Wed, Oct 28, 2026 at 7:14=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> =
wrote:
>> On Wed, Oct 28, 2026, at 00:17, James Houghton wrote:

> So now in v2, the _nofault() helpers themselves do not check current->=
mm.
>
> I've uploaded a draft version of v2 here, in case you want to take a l=
ook:
>   https://github.com/48ca/linux uaccess-v2-wip

I read through this now and it all looks good to me so far.

>> Since in principle every user access should go through both
>> access_ok/mask_user_address and current->mm check at some point,
>> so combining the two as much as possible should help long-term
>> maintainability.
>
> You're right, and v2 has been restructured like this.
>
> - The check is in access_ok() itself: the generic version, plus the
> arm64 and riscv versions. __access_ok() remains a plain range check.
> - The callers of mask_user_address()/masked_user_*_access_begin()
> check current->mm explicitly. There are about a dozen such callers.
> - The unchecked accessors, __copy_{from,to}_user()
> and__copy_{from,to}_user_inatomic() (and arm64's
> copy_from_user_flushcache(), which also relies on an earlier
> access_ok()), keep an explicit check for now. Once their users are
> converted to the checked versions, those checks can be dropped.

Ok, sounds all good. If we get more than handful of mask_user_address()
and masked_user_*_access_begin(), we can always revisit that interface
to make sure the check can't be skipped, but for now this seems
like a good tradeoff.

> Compared to v1, this also covers get_user()/put_user()/clear_user() on
> arm64, powerpc, riscv and the asm-generic architectures, and arch code
> like signal frame setup that uses access_ok() followed by __put_user()
> or unsafe_*(). user_access_begin() no longer needs its own check.
>
> What's still not covered: x86's get_user()/put_user(), which do their
> own range check in asm, a few architecture-specific paths that call
> __access_ok() directly (e.g. on alpha and sparc32), and arch code that
> calls __get_user()/__put_user() without access_ok(), mostly trap
> handlers for user-mode faults. Probably best tackled later.

ok

>> There are probably few enough of these that we could address them
>> by either adding current->mm checks or converting them to use
>> the full versions instead where that is an obvious change like
>> that usb gadget driver.
>
> Sounds good. I'll send a separate series converting the obvious ones,
> starting with the usb gadget driver. I think that will be useful.
> Let's see how far I can get; hopefully I can drop
> __copy_{from,to}_user() completely.

Ok, perfect!

      Arnd
