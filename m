Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795625056;
	b=JgnrKd7fjaTDtnavA+EJTNqK/7LrQLfSAeAFVHstAV+FMZhn14OjmEwgmv8g3Px4veCN
	 ThuQK72vX7jP85IkjpxNw9/dh4i5k8AEQRDMz2BevnYeTcYXR4L2fI5Gt9rjFKLt22KWy
	 T9aaVQ2J61gFEICeWWDf3PRQA+7qkDVYh06rvu7STt9GqZ4fOTfLrbX50DxmIyuPpkm0K
	 WjkVNhrvxRjoLavR1Vg2gHH/cbo0ob/WwKKWVUk0jeZt3mOKLNmprhVV/twEJIOjggPvv
	 4rlEuBamFxs8JAHHmGj21HsfWIbGa0woTMMB9SAM7Hbz5QU1NUtkSJ+P61HUREDto9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625056;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
	b=NrQGBGRWP1+oZVgwA3jNWJeu1dEqFpMLto5JSU5kMle4mjzC6PGZIfgtGXOqM/VYd+JJ
	 yuutE5kYKg0IbjzWFEeZMPBuyBL+TCLuPDLLL0Y+wNAkyYtSnNQuQ23fYUiEPH/gL/WiI
	 xSPtKqBbVVhdqRByhtLxjfdvFxYlP5K+P27IwksVA8lnL2O4edKAO8pU5lY1WNpxRwYFK
	 TOM9ssF32occe5vwgYddeH7Hu24gshZTyiARbE/R6TCF9nyYIuknCfkIT0zWv+LQA75rO
	 XqCJP5ytoJsWOgl5tGxuJ5lWC6q6ln5QMwCRt7ipcMMeuaf5nUCZ4+Y7Zw1i2TlslAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PKZ23RQe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FD8606A331
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 16:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94FD8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PKZ23RQe
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c516a194350so84722866b.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 08:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795625054; cv=none;
        d=google.com; s=arc-20260327;
        b=YsXEwbgNkcIYgmt0M+rp3DvgtrX0+avrNll3/CLE46x+0w2hLiU3rmuKkRPzdrVimd
         fcORlpLxy4SZxBmI8Dk/zQPC5AejR7OjmB/KZh+i6eurPpXm3cadTzMcxkpofHcsPKU0
         tv31RjKDVOHLb5LPjFDDXniTZE2KFWpfT8AlkG6JdOSJZfai8g+70kzfpYK+KF6HEJi9
         mif9EBrdtaUQ8eopNt8v4DK7c4zAIDZzp4aBgNZ2Z0PFLToq7+cOaARv57n4foUDJt0P
         OWygKALAHzavlxO1uMmhO9s6jjo53bDmLAyC9tTpUaZ1Eor3lo+xmWuFqf/YUIU+F2jW
         mM+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        fh=/Imn10XzKwf/b53Ef5uDMh+QuP3W2TDBrBefbmx5jmo=;
        b=ba4mjUIwgxvjTJr3Iutztutly4TOYPVU9vycN4BfsFwL3C0Y4hlZepArVKgIBmNEIS
         EIeXXE/6lwkul6RaE8gPJ+H5rO0YH7TQrgkduo8MV5GTBtgFlZhqetzMlkQ/G0sJQu2y
         grpHD1zAjB73GlhtwBxYOQxGV+J5X0p64RTUQkzkSzW6dtolQkuuaDKmyHvJ1nWXivlz
         vjr7rp0bUp8wvOyu6xk7+Qw7KEdWDMqnus0CAQAeHVLrZDx6L55lMVQeh0j6Vh5ZIQ9H
         MWGe0FygrTVrvSrjfx7/uOeecIDJHTQ/2e9XiI4seG5ZsWLef9TLDmTEeBrgLVyRIpHB
         h+bA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795625054; x=1796229854; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        b=PKZ23RQeMEttotX4OBPRP2DbbrMEB51nwAQlsHi3Clsl60+KLwydytyVzIwS3CPrsp
         gMCa0qLojqUmZPTj1WgDWb2vfDDzy8I3ouZC6AtzVQzGhYkAtsdS7I194LfKbKzPHVBH
         9FjnQKv/TdlaTy27yqxtS+FRu+TCtlSdjsR4QOyB9tkMnDrs00BEwfTTEGdJNrrE0d1S
         i0G3BgU+8ocwt4ScMKi+JN47+02WlDqK9aHu8g0fQCVcWCnmaTG9N306L0mPKog4H/f4
         BgsXgGhnHP8RFqRdmh8kRVgxVbHO2JS8qa43xqFnpf9P4Z4Esbd1QfxvoHuOMiibIYtV
         4BnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795625054; x=1796229854;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=II/aro/lwWCAag041h9klo86GZWrpoxtriGNBQNlDMw=;
        b=Uk28qM0hVYikpavCIqoB3Tv3YBGGh8vV/j7yovvLnE44K7xqpXoFtCaeoUkbZrLjLs
         uMZIUvjb1td4IEX6kkWfWAwXD0luh4njRKUtX0mCJrPs3xl/mpNNiN61PqfNb/yLgG+R
         Ebdqm1HF2QPiJTgfJYzEMcqVw0Zh+v/tNdSkwL0dSA7UpDLsQ8YZRp8xwUle5z435zX/
         2dH44rbdJalp0zIE91YwIVDgazVtUPg2XB1qWtIPY9yZf3wTUXJ/2sClGhTg2f5hguJ5
         rwVFkyTffKegLbfg4NhYGHloFsT5rO30kJiQX2WQ1oxRJD/QZ26jJ+slQxinMb4DdXFt
         L3cg==
X-Forwarded-Encrypted: i=1; AL+hErF5hGnLOO1b9vU9H3kLLk/oR+hthnKaIH7JzYt29T7f5dYS/zIBzH6VWAUxv/EduMJYLITcc8E5cEgN@vger.kernel.org
X-Gm-Message-State: APuU4Z+Dgvlmlec2slDtkxYPHlMSvCYcveWu2fact+nAhXVZZcQm3lln
	8yv71I8M1AukPyCMrRnltUyJjkaDPheQYzsKQ9pWyrxkGl7+NtyojWcu2S91f39YfW3Yl2yIZlq
	rmK8MQr5WbY8sJG2LCdcSmNnRaxcgSScAo5Evdbq1
X-Gm-Gg: AZFdTZcC1daUZPBRQefg+CTf6AlYW5nS5kDjmprCvGDokBNMCEZI8C9JoO7La/TJBan
	u7c2EsAChGzlr1u4QtiKuSBehL3gcrXGsCyseJOCPaS95LDXdL35UZx9tzWrQ2DRlKv5InpokOY
	xlItPg0Yq9YzdnpQW6rE4PvovDJ9NWDjo2sYWQKQPXJOdI66T6i5BspPchchKIqEA0i+7L9oLak
	4K6OFeHOoQLPw+JdNilITUPWUHxop8+z1lzHhLPMFxTlWjfA+llverE+uIlI8o9oTmk7F1Lhd7q
	0LwvYxrvJms5/o6R0G5NPpY+E4NecnLO62a+G6qa3wVgAKdAB+/7eWxyHt5PiiqJzWWNUmYoSBq
	bAEDKnq9jtaQlBee5NX390bWXjsWoaFGqTKYSupLMLV03Ny2zLeC3j7677J3iAvBDoh2AmFfzKY
	qAWqbMyYhTJoii7ZRk340cqOXYeR+pn2wZbBOU/qVcwCMzX4plDgI=
X-Received: by 2002:a17:907:6d22:b0:c51:40e:847a with SMTP id
 a640c23a62f3a-c513a1e6fdfmr1639688066b.0.1795625053094; Wed, 25 Nov 2026
 08:44:13 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
 <20261027231728.1466446-1-jthoughton@google.com> <32fad21b-5bad-4640-97df-ef0f638cd9e9@app.fastmail.com>
 <CADrL8HX5vb1PGDpWzp-eR0rNfsMCVUhFa9vp_WZZx2eJZ+dfXQ@mail.gmail.com> <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
In-Reply-To: <1a99e5fc-129e-41e3-8420-101bcf04b366@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Nov 2026 11:43:36 -0500
X-Gm-Features: Aa3M54qTCDON0Zo2YJDXp5pBtwrXjTcYjv8NoqDjQS_XV_tl8JrBb-LQVlKEL3Q
Message-ID: <CADrL8HUOZs-vWRyM9p+Na-=arRU+Gx_cWMLbxHmUYnho4fAUXg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pavel Begunkov <asml.silence@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, David Sterba <dsterba@suse.com>, io-uring@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, kvm@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Mike Rapoport <rppt@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 5:02=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Tue, Nov 24, 2026, at 22:10, James Houghton wrote:
> > On Wed, Oct 28, 2026 at 7:14=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
> >> On Wed, Oct 28, 2026, at 00:17, James Houghton wrote:
>
> > So now in v2, the _nofault() helpers themselves do not check current->m=
m.
> >
> > I've uploaded a draft version of v2 here, in case you want to take a lo=
ok:
> >   https://github.com/48ca/linux uaccess-v2-wip
>
> I read through this now and it all looks good to me so far.

Wow you looked at that really quickly, thank you so much!

> >> Since in principle every user access should go through both
> >> access_ok/mask_user_address and current->mm check at some point,
> >> so combining the two as much as possible should help long-term
> >> maintainability.
> >
> > You're right, and v2 has been restructured like this.
> >
> > - The check is in access_ok() itself: the generic version, plus the
> > arm64 and riscv versions. __access_ok() remains a plain range check.
> > - The callers of mask_user_address()/masked_user_*_access_begin()
> > check current->mm explicitly. There are about a dozen such callers.
> > - The unchecked accessors, __copy_{from,to}_user()
> > and__copy_{from,to}_user_inatomic() (and arm64's
> > copy_from_user_flushcache(), which also relies on an earlier
> > access_ok()), keep an explicit check for now. Once their users are
> > converted to the checked versions, those checks can be dropped.
>
> Ok, sounds all good. If we get more than handful of mask_user_address()
> and masked_user_*_access_begin(), we can always revisit that interface
> to make sure the check can't be skipped, but for now this seems
> like a good tradeoff.

Great!

> > Compared to v1, this also covers get_user()/put_user()/clear_user() on
> > arm64, powerpc, riscv and the asm-generic architectures, and arch code
> > like signal frame setup that uses access_ok() followed by __put_user()
> > or unsafe_*(). user_access_begin() no longer needs its own check.
> >
> > What's still not covered: x86's get_user()/put_user(), which do their
> > own range check in asm, a few architecture-specific paths that call
> > __access_ok() directly (e.g. on alpha and sparc32), and arch code that
> > calls __get_user()/__put_user() without access_ok(), mostly trap
> > handlers for user-mode faults. Probably best tackled later.
>
> ok
>
> >> There are probably few enough of these that we could address them
> >> by either adding current->mm checks or converting them to use
> >> the full versions instead where that is an obvious change like
> >> that usb gadget driver.
> >
> > Sounds good. I'll send a separate series converting the obvious ones,
> > starting with the usb gadget driver. I think that will be useful.
> > Let's see how far I can get; hopefully I can drop
> > __copy_{from,to}_user() completely.
>
> Ok, perfect!

Thanks, Arnd! FWIW, there have been no syzkaller issues so far with
this WIP v2. :)
