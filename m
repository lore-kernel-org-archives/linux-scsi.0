Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793058730;
	b=PIWqkWC81dW9GdD2LGc6C0VLGAE9i9AKQR6LVWQA2mx/PS0W2UVABUyWCKAOz2ZBy++U
	 MbQ6cn2UwyaH/mgtIM13sbGldUzzV9nT0NGinEw1VPd/U7yp+goEsGUjU4RyeDBzJcRCJ
	 mtsUyC986lFIHJtR0J4HiVWKKQ4TxEwnXsJiID51jxiBlsgdmiRGIp0Yf6uUI4fycU1Yx
	 3mWx8Djp3A6FW9KohLr4RCHYBrCWGSrEYa1mhGyYdQCpuDhaf8O2jO8fZvTipuPeVos/G
	 iWrolbJkeFnnlKoa1ChhtfeSuneqWdhTfnzjmKDsHagXM9Zj2a5DPSLxppDM1C752jw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058730;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
	b=aU/xkgpHaZyuEpwdrXFsSEsh43WytZJN3nhhdPvQQ+teJ7i34K1fsVf3Xc7pCALEDb4Z
	 VgM8SbYf0p/w2+5d8wr8KMVAf5mM/xpnWu/FMZBPckk8aP95grWQPdLyVNyNIr0VHfCbw
	 gPTuL1BZNOsKDRhFQ47KwpzGjctt3iHoxTPQl6hfwUg8/QxvTudSfcrkyCRpTC0Qbh2wO
	 jlSHE9g2FR21B8lJKo4Th6g0jhEA0omojM3JdKDWyjQLkWaU73B9KDo9BqnGLqw2Dhp4U
	 KBtY/f3m4GnEHmmuZ4BHRNVuSocgjGWr7oTzFkMCVksaDLIfYdyVm4rYOeClwKADa2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=IrwijN25;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03473606A322
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 23:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03473606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=IrwijN25
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so5582792a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 16:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793058728; cv=none;
        d=google.com; s=arc-20260327;
        b=ikXlH/TrXHexxmODLsxFrjjQ7h2ensuQeh3KBGkX+kZRVQVewPSgtKPMVSTgU6FJRg
         J63d8idnq/YolClfDZUESLGlaSGeQrcMRSm8akH2ld1ZIxw5vStsnxpfe2l3UYr6aYES
         wYLLOtM42T6katCf0JNO+b7fHJ+wxw2l5/0XovLIqJRcNX2hYhXZjyr2C3N4TN5t8ezl
         E+GX34IOMg3BcwftkX7FM37kIMrBqA9cVFDZgtGcjkieZx7F8bEfhJeFB0uPKPQbIEXd
         hlTImwELVQJy+rnQ0XYvhk+OItMVbjNUKHWSuWfuVAptHmZ5vjGuObRa44ZnRPtOZFmT
         x+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        fh=yRNFaDIwroEbXnu8a1SaygLXbWE3h1BaZDbAFHX8fP8=;
        b=i+Ffo1lM+wJnyh1fh7D2NFNvFh+auYMm3vd7Dwtj5Z3hk7y6JGF5g+YM39Bdwi8Rjz
         tX0Ljh+KAOHFsjVQWBSugZH4JPdlTX2O3E05T/alH7PtZPJCwZ3BWjTInQZzNUqBauwW
         a4QgcA1fbeOJEIOaZuz0TUOV2t+GSLxGVbBN7akhc0NWMytRvvcxCBKU11Zija2id12a
         lQG5kK5/WsEHMbHOUuvFr3oCYskUQYGVjPIW2AtlFS+JxvU7YMKbZteqjdfUFLm6wWdH
         uffLDewE7ploDEewRlxJnsSrkFlVEQS6cRjyqiS+rZBEjrc5xXnQXSFk2WKvnuOm0AaP
         eSZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793058728; x=1793663528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        b=IrwijN25Y5XuhkNoEvpxTGUzu2F8Fw7yumOC6bQX+sv9sI5cIkUQ+8qDyW8Rn0leIE
         KD/M3UgHYaJH9qxw5QEzap4cvaO8QRp4WvUy/b8d8qlbP4zjT/NLwA46mVK4rk5TE67Z
         hbcIs7JRXy3S3BU1Zp46QexhDFTfTqhgb9F5yDiJoNepIvxVOAnGlUkvuMj53pVOulEq
         nY7AospiQUxyoh3b4b1zlSlhp0Xm7S9U0DWHUHqyywQpS6V9BxBGr6qPvm7+SL/x95K4
         vKS38fvl7h/D+VqUiNNcMPjyNlpB+LfGZlaoNjHo8oTsgp0eeolgiheQhrTjRg97kEV2
         ylBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793058728; x=1793663528;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wkDgiw/AqsIfVPHoMoSGYbq8gYoliaNoZ6zCaoCS6us=;
        b=u9lY0iPWu0DeWsJ9Ce7i5mJr3vjPl+CKfEbqi7stW5aP7fzPh2IEl4SIJGB6pWGhtc
         0Jv8YR6C/Ngel02vRbX+DkXDkz6yimU8DM/X6QZNyGUTBegXU3S/xZBnnDD4PSvIbSLc
         kus8MEgl6vGIH/0A63SBUUWHmJq+YorXZLTlFI70+Q7ebk+EkYpVgOjQv6dTs2mvPZkL
         TP55efX3RzlAsmFGL1zRwreOBGj3UHJ7Y+GwnVwRUghxJphqBV9FCzC3aM4DubCZ9yG9
         26krY8euoxfth3zwvfFZd+4LBJPayBXNoxqniPNHmS7Ak+9cRAL46VnP2aISrEJAX7OO
         gVdA==
X-Forwarded-Encrypted: i=1; AKwUvByiIgubfzxfQB1O3u2A5qwRBFXKGuixLq9RAyo9xbzrHMboaKRpGnYInuCR7ieYMZgl+RiiOMRukJyS@vger.kernel.org
X-Gm-Message-State: AFq9FYJfHlhhKr5fJ8UUeh3T19oWkKNDhlP5JwRBTnCZvcxsxOWnz2z8
	rRs16cdFie0JZpS3okOPUFjqqROPH8j5J54dLvYkr4Z0Jh789q67c8UIjJdsd77MOuz7jXVg0d4
	cTvup74YXHGTCZoptOQVR3et64sBp1EEAzQr20Gz0
X-Gm-Gg: AYBFou0H2kePPUafRpHSEjOOIw87mTF8Bjzd2wkMjt28Hs0G2xVXy4RoUd3Ezd+w2xh
	ULW/fjlZZkwIE1k1BzDW9HQ+ok+icfkfxGmsEuAzQifarfIav0DAtsFIs72cNWNYUGuHbjAW0Ax
	+lNmTF2axeCXcBIfGiNx13UF9eq/BPceu8wGxi0RvPIRyQjvCyxVOqwC7+84el6n63fCWWgknza
	uEEphwVZzuijRatDNhdTVD3m0VZY25moKjSbe9oOtckTSWnRynHcpzIikG0krVtNcC020HnRo3M
	sDpan2aJMG3mrx4pf2jscgXpz9yXVEoLHq+H3ZgeTLmhOZ7cl0rdYQdtZ05g79qzIzFsVQj3s8S
	8Oks8k/VRYK7zTlBbtp5otKqmXdiOJoDzLtHvvZSuYLobBG1Xa9tKOLtDb6XzusUXXTUxmSID2w
	O6rnl+48Vlt1eU+LNswnnD3RmVdrgMKElNffqLb1nZB903Hi02q26D+N8MG/imAzAnVq4uecuXb
	Le32MAG4g==
X-Received: by 2002:a17:907:80c:b0:c46:6a50:40c2 with SMTP id
 a640c23a62f3a-c46bdee2675mr943075666b.39.1793058727681; Mon, 26 Oct 2026
 16:52:07 -0700 (PDT)
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
 <20261026215226.3713941-11-jthoughton@google.com> <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
In-Reply-To: <3b0a8fc4-d140-4a90-b810-cbc1283fc083@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 16:51:31 -0700
X-Gm-Features: AclHuK-Nhf6TYTDNWSq0v6hReecRKBdo5ExoV8oZWGVCIO9BK-126Jv082Kq0QQ
Message-ID: <CADrL8HUZ3t8RdMEeBPfqsy1_1rN0Ty9B2c4iP6OzNS12te6vOg@mail.gmail.com>
Subject: Re: [RFC PATCH 10/10] uaccess: Move the NULL mm warning out of line
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
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

On Mon, Oct 26, 2026 at 4:03=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> > uaccess_without_mm() is inlined into every user copy, including every
> > copy_{to,from}_user() call site on architectures that define
> > INLINE_COPY_USER, such as arm64. Each inlined WARN_ON_ONCE() adds its
> > own __bug_table entry.
> >
> > Keep the NULL current->mm check inline, but move the warning into a
> > single out-of-line, __cold function, uaccess_warn_without_mm().
> >
> > The trade-off is that only the first offending access in the system
> > warns, rather than the first one from each call site. The stack trace
> > still identifies the caller, and the access is refused either way.
> >
> > Compared to the base of this series, with defconfig + KVM:
> >
> >                      inline WARN_ON_ONCE()    out-of-line warning
> >   x86_64 total       +5,884 B (+0.014%)       +9,714 B (+0.023%)
> >   arm64  total      +40,948 B (+0.10%)       +24,609 B (+0.06%)
> >
> > On arm64, this removes the ~16 KB of __bug_table growth, while text
> > size is unchanged, as a call is the same size as the inline brk. On
> > x86_64, the call is larger than the inline ud2 and causes more .cold
> > splitting, so this is a slight regression.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > NOTE: This patch is included for reference only, to show the cost of th=
e
> >       inline warning.
>
> I would suspect that the growth is larger on architectures that
> don't implement __WARN_FLAGS() but rely on the generic WARN_ON().
>
> This would mainly affect 32-bit arm and mips machines, some of which
> are very memory limited, most of the 64-bit architectures have it.

Thanks, Arnd! I ran some build tests on 32-bit arm and mips:

arm (multi_v7_defconfig):
 - base: 31,913,726 B
 - patches 1-9: +64,816 B (+0.20%)
 - patches 1-10: +23,193 B (+0.07%)

mips (malta_defconfig):
 - base: 11,830,177 B
 - patches 1-9: +61,168 B (+0.52%)
 - patches 1-10: +25,881 B (+0.22%)

I think it makes sense to include patch 10 with these results; cutting
>50% of the size increase for arm and mips seems worth the trade-off
of only WARNing on the violating callstack. Let me know what you
think.

Is the increase even with patch 10 too much for mips or arm? I can add
a Kconfig in that case.
