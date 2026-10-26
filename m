Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793055810;
	b=5gw7butYPJMXjI4Tt2puiMFaZ+X6/waDMg+PMNthtWoKDRfKrNZaUCbdPKpH7JA4Ig5P
	 HfB5jvV12fpKhfJUMNDQ29kqcTQypNX9jB21VeJ/Vg+xPQYUv8BVX/wRZVPO8hJCZbiYv
	 pG4hiY3t1XbkuiaRPDkVWr0fzIt05D1XWK5DyeOFTCXtXPw7G6EIouyFnAb+h0Nf0Y0/i
	 qyEROZLnb+FL2oLZtKOJYLytf4KlrcXKY/Nrk5/BfOZQ0I5254SY1eGp3Al8NUgrWtH27
	 VJzn2g6y7r4OggRrc5060A8IEAd87MWZdLCCpd2UEzLql2YTot96UxuFLBWLClN/ukg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793055810;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=D7+yWhNEfwBLVAnh4DVgwdCxL54hx3J7AhdglfNEalQ=;
	b=Ih+WFWpTKnt1iLoJduD00mz9crb3Z6ebuWdREG4xeidnfux/+ReHJ7KkBhrsRi/UdAUq
	 pWwOFQfP8AoPlc9A52LhgZmclPR/f0ww6YdlfdITnzu8G71c5nXKmbQ5LiSBePJZSMr29
	 IBWzGYcR7PnT8yScxBphn486JsxfyC33Q9v3lzYI9lmcUCJD+cRe+tE1QdgQjd7XiK0wM
	 fss81zea0BkvgqMQ3hrSGiT85n2+24fTDxc+6K0gHCUKTs8X25xzqk3JDlMhpBBHLaDu7
	 NwxAIfVbcuSifISVpVyQj75EE/xtArzhfm9Bqs7JmffJh/xuB/0TF/HDBS6o4lYSAkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b="YnCT/mJB";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Z9BmjjcB;
	arc=none smtp.remote-ip=103.168.172.139
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D04C606A32D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 23:03:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D04C606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=YnCT/mJB;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Z9BmjjcB
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 5B849138029B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 19:03:29 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Mon, 26 Oct 2026 19:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793055790;
	 x=1793062990; bh=D7+yWhNEfwBLVAnh4DVgwdCxL54hx3J7AhdglfNEalQ=; b=
	YnCT/mJB73FAGmQIu27ctvo5RESP4K+pTIiK9EhLFaGH8j7kXKQE+tSbzesbfDxs
	bV+9wV/9mJE87FIh60l/aPw0vUFP1oQOrI5riJBeeRGczFUwDyCLA8/y4BcBY12w
	wRegLgnRHobHCSF6BA6i0C+reNBRVR2FKTT/gbMwVrLZscUYxkn/44Vw8eG0qSvi
	tWJdiyjuyg2ickLmpnfR0RB/KUcSZm6NPyieIrb9GtPlZj+tCTyGrh4XFyNGGvj3
	0mNzbe0+txL9uJr9T4IbJyuT48LYOX1e+ZzKJe7AQTdcUWk+BiA6E+y23Kktm4eF
	0OdWKJ+MXJqpGpYEJntcLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793055790; x=
	1793062990; bh=D7+yWhNEfwBLVAnh4DVgwdCxL54hx3J7AhdglfNEalQ=; b=Z
	9BmjjcB8Ht97U3XpSdkutzu7KGGU83nJYqys9fKA8A8LFo89cKjsWQGjTr4pUO1L
	aP9kjNesX0okG+vOVw+RbXwBhTP1dlNpD+KBb13+OcK03C9JQt4JuFOOxyE3GGLG
	ZspFTpPuZDfO6wPr4qEO2A5TQRvlMMTy9lXbOlVikLCqKHWaoSShkmyr2lAQA0MW
	I75SaI19xADFJtpVucfW5iXU1oSN1+WUXqV2eC8N5VxDvuOCOwE0yDQK4eXGJuSC
	Y9wL+SsocvtYeidK4mRb5GFh4Lq5vzciH3Z2KUk3zskK7IRDyEhPwx+HWzKZpC0W
	mE1pSP6ArkmhYFD6hOYlw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793055790; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:mzpBt8cc2B/TWsBOYquPTmsnkd82su8NZdBz9gcgc3ZdLkN
	59UJnGTYl4+nak3ABKsmTUBQLQzqGgmPy02tgnYvcpPhJvl1zn7+hbiMAStiWon/
	pJl6qrghM/Qt74NjqRg77W30YgKhiSsGhhCQVco6qzNTPubWzJ0Uretc6WDFYuNt
	WGFRkhzvr+KBlY4Jl2611BGUaObAPSd4pf63WRoRm+DEZRAmLFnRC1xfDxc5PuGm
	mbkxO2EKLbNK6vrCzn0Cu8YVP/kPWyDyEGCJLaZEY3c03aYjQQVlS03GmG8pXpOk
	4a7oocfyZQdYBt1ZfMdBO9h1RwGxmZfY30uISew==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:t7TmO85uHz3Bu9BudK5SiRDodgnhLHm1Jzu0xBGeMzU=:nc6weggs1vuexqOORIgzQ+8Q4IQMXclbAa/HauyeO68=;
X-ME-Sender: <xms:I9zfarVlhcJ2BCr_X0f-Oqe3MJ-tfizxDxcVqqJu0UTFnur8n55_Vw>
    <xme:I9zfaua_l0AUV_QUaHlFQ6Xk6c6S9hDoF9LDP0z9ZWTiBfyLFB6bGMt2m3Qf-Wf2r
    Gp1aY7E3hmIDYnxO6ClUpLNdypmMNJMMAjKb_KTlIEA5DbBcFarl32S>
X-ME-Proxy-Cause: dmFkZTG2ipuQjn7o/dduxIouS3rexG2Fs38Yf1mgntfcBayDO96egVm+yZQ4lqIIentjs/
    mqWlr4cScm3wkM9Qig2xKeks6qaebjWFYjqSr1PEW0Un0mkdsaFkbg+xdJQiG2O2dvowLj
    8E21v7JskZMeciXQK6+wWU3W5TpMrftfB6Bs3P2KNxD6AlDYn9LdKl79i+Pap9CUN0lvH5
    Kmf7XF9ELL/4XciMlrED2crBvL0Cr1f1u2ohCkkGXPJJyr9NhF3TZ6Ev/Xhe+zrfxeWaDU
    CHzGxCZtrUFf0j+qOyVHd7hT7F2sM8dBpGw742e3r2mvfUUQKFeZdDheW6KomSHxo+nEDw
    iI6qO2cDvY1NeToTkMsmxh+Idwqe78oXaZf4JBivXyC6kcFQnAnTHzPS/v1istw/y4OU7I
    Ig5+4LcAMjuaK21mmbb4bb1DmpocpNGdDRw9yq3nlrcPMsuuD3uvsbn3xyT972zofrrKbr
    ymQ2KeWkMRr8lrdJKsZ996mCPszGebzucdgyrtSsUPulGKB9lpIv0RpYgf85X7CxFkC5mx
    0ahqqI390L+Dj1eTAd45HDhy64TtvMVlHqpgXnFPGAYR24gTjdAn2Wh1e+VqFY1QE9IKWw
    dT6VBuP/aA1R/oxwzZkn1goeGaMw0LOVAE7QiXpixIzvdkU0wv6eIJAHAEFA
X-ME-Proxy: <xmx:KdzfajHGJ6tf5pxLJ3v2PfbGRd6Rt6Io_8hyQBlkYOXCV7Lb2b01Vw>
    <xmx:Kdzfapg-6ACQ-dUEsnrl6Ji_ntio6Ly_-zbhQjCdP4T2kZZPc2mbjg>
    <xmx:KdzfapZpLCwDwzVm3OeHceISOSkLUArE0NE7AI0C6AgT-FmN177JAA>
    <xmx:Kdzfam27dS94lXZ5VmP_WcqDu7eLBRosip4J-91RpWhTlpq7UwmFJg>
    <xmx:LtzfasvLSVKrc-K83R8kLrDibnrCdXZT8NkkCjHCIPMKCuEvlTPp1urH>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C999832A0097; Mon, 26 Oct 2026 19:02:59 -0400 (EDT)
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
X-ThreadId: AmKN4IVPaSCN
Date: Tue, 27 Oct 2026 00:02:38 +0100
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
Message-Id: <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
In-Reply-To: <20261026215226.3713941-11-jthoughton@google.com>
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-11-jthoughton@google.com>
Subject: Re: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> uaccess_without_mm() is inlined into every user copy, including every
> copy_{to,from}_user() call site on architectures that define
> INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
> own __bug_table entry.
>
> Keep the NULL current->mm check inline, but move the warning into a
> single out-of-line, __cold function, uaccess_warn_without_mm().
>
> The trade-off is that only the first offending access in the system
> warns, rather than the first one from each call site. The stack trace
> still identifies the caller, and the access is refused either way.
>
> Compared to the base of this series, with defconfig + KVM:
>
>                      inline WARN_ON_ONCE()    out-of-line warning
>   x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
>   arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)
>
> On arm64, this removes the ~16 KB of __bug_table growth, while text
> size is unchanged, as a call is the same size as the inline brk. On
> x86_64, the call is larger than the inline ud2 and causes more .cold
> splitting, so this is a slight regression.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> NOTE: This patch is included for reference only, to show the cost of the
>       inline warning.

I would suspect that the growth is larger on architectures that
don't implement __WARN_FLAGS() but rely on the generic WARN_ON().

This would mainly affect 32-bit arm and mips machines, some of which
are very memory limited, most of the 64-bit architectures have it.

      Arnd
