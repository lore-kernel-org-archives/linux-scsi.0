Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793229270;
	b=O/xngGFKge2LG1l2hRCZ30xJX0cs3R3x/rHu43Y3i9szHpRZQRknIyA9sTs0J6E7Js6M
	 U5HK7SbtrC+cxZelpt5caSAtVXjcWi9O9NsYpwxyBmblU/pSYJYImCleD2oPTW8OMYiKL
	 2ET5yBI+faubds4nvlpjCBNt47Kqo8NNVFqLJwFy45MeEKQ3i0Gav9fpynXkO1L/9rCnY
	 QJzbsas++dHgTzPv2WvUXqmoTJ8fuTu50kpDcG4zl7ZHeI4stlyqY4VAJl+gn/5pFAxq1
	 xHXJpQ7MJooQnBdqT7KRxMeN1DVUmQxrktO5aNw9DdnY34H9dkVxLsZ1310wKMFWwLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793229270;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=3NNvExRhs41CllrriDglY+oL4uS1pgKk/7KJlisNUfM=;
	b=kYg7Uq4Nqt0e/uoWI92Y5wD5WXP2dhkq9/NTO0EwsVxrcUaz9BHR4o+W+WG56n6E6/dc
	 CRrqosgNaAALISNsI7bOJXVDe3PvX1b45HhxyhosH7ipmyFI7BKrlXVYy/TxZLSrNiXmJ
	 fikVp0CZdyrRNsbyFJOeuAGuHld3BovUEUOVftdtStNfPB6nq8an3ktypYN289Y6caLlQ
	 kCw2S8jDAHVhvaYq+gUQ8WyKmH8rblbnffUTsU+ed3BKsbWGdon6BXf9Vp1YRP0V43jLS
	 MxCUWFmIUrz4wcRcsw2sffK6x4ITc53FuccGVf2pw3pTPgowGo+OZ8E3H14MpcPKk8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b="HJ/9oA4h";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=F4QP1K0C;
	arc=none smtp.remote-ip=103.168.172.143
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE9660A2601
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FE9660A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=HJ/9oA4h;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=F4QP1K0C
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 86A2C13802EE
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 19:14:29 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 28 Oct 2026 19:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793229250;
	 x=1793236450; bh=3NNvExRhs41CllrriDglY+oL4uS1pgKk/7KJlisNUfM=; b=
	HJ/9oA4hbL+gy2W2kMtoUPBRMb9eb02SBFs9WSPPnJVSTb2YkROErs+OQKZmTQsa
	/HAx4OZA4I59jgFxYJGn9YUl2KYjlgqWA7GFaoY0wylZIVB4q1nbAUDpdfa4o09t
	WWsqQ5J1DWjqWCqo8kyeajw9PZ0cA8oUWKxPt9aRyHcwwDWhjT5OXeZ7mzVSm6HX
	r8xlrtYfvkTPlDqPvGK4K2sLrtKGVkdLYmvyYHm27NOyz+6WOId+oJ9OacAGyQMg
	xaUbbMWZwFjs9YfqBlQ6P2T1ZylMdfFcchf1+nt57spZu/nWs3smfEeZfMCE+LAv
	EscA093JciZyQqQR/verjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793229250; x=
	1793236450; bh=3NNvExRhs41CllrriDglY+oL4uS1pgKk/7KJlisNUfM=; b=F
	4QP1K0CA3b/8rkN/0r9Jiljf/MNNz1l2g0iDRWxKMMXIk/c7/kFyNtXScKPTH8xZ
	pWV5M22SkLFbtNBXoXgEqBmV66mY3WCzF6Prp9k01J3kHgIjwKosS/v8fRcBKDeI
	IZnXLmSEnOQ6f/mgh+HcFPZccEDPEnEMJvUTH5oJHp5fU600Mt9BlUy9rSuvE/15
	r6wcZTudJ2H68Cbj0qUQ59Y4a0bBqlXe6YjFrnDkPcIPqzgKQB4C0a1eDq8lMKJd
	8zzbSsKUyGTI11IW8FG5nZm4UeKwpveeux55SiqnEKlzQKCec6dkF9MOMvuvE3ZH
	xQ7+m56qYDDn/w9gI1vIg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793229250; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:AklUP6ib9cOrzLPF259w8H3gNIe93sXA/bOkf8Jh1Oad0H3
	n2cAfhllIfTfkUPhxPtwYmP+Q0lk/zYfSff/nz+hf9QRYxgbDgtjZtFn/crYEYbJ
	r/ebrBg43u6RiV1ehSt2eDNQhRcfJDdJjgkTD7Sm743UbLc7+yfU82PS6f5IbWtX
	7s1R3I/KFZOH71/hPW3BSd9FRoOAh4+ZbaPTtC0tuGw0aA2aOelbYbQXZYE64qVG
	vjHBcezuI59MWQubYQKMFPFAqjICJaiUZ3P7ZECAlm8MMBkMo6NsqhqHu7H3Cckd
	GSnFFHvAHjtw8Loi1J9B34jT2k9x/uHlPazhqlA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:1ox/+T3m0kOEAlmq1sGFbMgtCHtFlHB6pbQZya3sc78=:3uzdn1y57rhQviNcmBHgc6VsykPb90eUb7QRIui7pyA=;
X-ME-Sender: <xms:uIHiagz5NZKzNbUpd03HG5vXYGfXVtC_KWUDGUCYSoiONAiEqrFnUQ>
    <xme:uIHiavGlWpmT8co8loBrIMpSoDTcUgvQQ9m62webm9VRn1pGNdgefR57QudOBjngy
    jNYgqv6h-RF3HivHRPEmVDPjxX2_vFOg75DVB2XQ-_x1lQ1SdeoI9Fd>
X-ME-Proxy-Cause: dmFkZTEIv3O/hjA+DS1Gn0fVIHXS/AlrjN17sOycg4LFHdjHUhYgnSW9A9AfSzFMp/tRm8
    XfzEySVBTxN8zIPtS+CBPtsSP6JNszBAZNX5W9UfT6bJN/vk/EOs8PaPWJeniA9XSfocWz
    ftw6UyZ82qNvgXYFyKx0TpuXs6v45cKeeqQd8Mpq+fygU/HDIH1Cl55hzEiOly+Hq4Lmva
    Mymau3PyFPZn57CVBaS63qJjDtn72IWwCaMsSnq0xiuo9pwYW5Q8wmSZpK0gpir1EDpvKi
    gMehYxBD1ROulWm68oebxW1gk4S9kv3puG4HMihu+ei8PgnmJ2t0Lgup3TXw41U8PLDWsK
    lS3YQ4A9PipsOmhEztB5/SlxefvJ1nc2wZmxLHv6g2J9A2gE1rUvs5VgiZvup5xsiNLNWa
    oCb02kALZx9kVU0Pbtlg1t5Wm2h1SbQ5sBYXcRcIPXKEnpkzBWuUWGS/IZuLCyeSskFdN4
    4zzXKs6wdkeXLrcX2HN20wB6cnvglYFjzZpBZU/958a1bdaRLtaX1oa7NrbEeIe+Oi76LR
    sBgOLQlP7wp8klAd+GM8pibMeyBYQiX0sOJVu/JcWhO8d3+qVoN1NucM4DAHeS/nLHASOa
    Od1p7CERwQ/XC73A0PBBx5FIjswIECwC2i7xersOpHk9io1VqHTZq13jr8Pw
X-ME-Proxy: <xmx:voHiarhT6uMUhmm_U_iPa7YbilWgfR-kEMAw9AaIdneW7rGVZLPpEw>
    <xmx:voHiahPLWYEUdHWB3dFXUZ3sZzMV7pgFvvp3hwS9J2O20euYSZk0JQ>
    <xmx:voHiavW7HwyLicLjcznxZnjDILSFDs8HfztwqWvl1HyOzTj2E8i-WQ>
    <xmx:voHiauAnpXc7yD4RMne4mY95VUK1oeWFxoQIS-UMCuMdj932dAInNA>
    <xmx:woHiavrbcCXzohZqImWksNq-zvdo8ZPbhv-nacyxu0TrfbZLEl9kZl0d>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id A817332A0093; Wed, 28 Oct 2026 19:14:00 -0400 (EDT)
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
Date: Thu, 29 Oct 2026 00:13:29 +0100
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
Message-Id: <32fad21b-5bad-4640-97df-ef0f638cd9e9@app.fastmail.com>
In-Reply-To: <20261027231728.1466446-1-jthoughton@google.com>
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
 <20261027231728.1466446-1-jthoughton@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Oct 28, 2026, at 00:17, James Houghton wrote:
>>
>>  - does there need to be any compile-time configuration to skip
>>    the extra checks and/or the warnings?
>
> Since patch 10 moves the warning out of line, it costs nothing on the
> fast path, so making the WARN configurable wouldn't save anything. The
> question is really whether the mm check itself should be configurable,
> and that check is also what makes the access safe.

Right, makes sense.

> The text size increase seems manageable[1], but it would be great to
> hear other people's thoughts. For the runtime cost, I'll do some
> performance testing. My guess is that a load of current->mm and a
> well-predicted branch per user access will be negligible, but I'll get
> numbers.

Sounds good. I agree this should not have much of a performance
impact, and for the size it is probably as good as it gets without
a major rework of the lazy mm switch.

>>  - are there any cheaper ways to make it safe than to add a
>>    condition on each user access?
>>    E.g. the original lazy mm switch was intended to avoid
>>    expensive TLB flushes when switching to a kernel thread and
>>    back to the original task on 32-bit x86. On modern CPUs,
>>    the MMU can deal with multiple ASIDs cheaply, so turning
>>    off user access in a kernel thread may be cheaper than
>>    adding code to uaccess depending on the architecture.
>
> That's a fair point. If user memory were inaccessible in kernel threads
> and after exit_mm(), every such access would fault, and the fault
> handler could WARN about it (x86's do_user_addr_fault() already has a
> !mm branch), so it could still be loud without a check on every access.
>
> I'll look into disabling lazy mm switching on x86 and doing some
> performance testing with that (like comparing the per-uaccess check
> with the added cost of non-lazy mm switching).
>
> Other than the performance difference, I see these issues with making
> uaccess safe entirely with the mm switch mechanics:
>
>  - It only helps on architectures (and configs) that implement it,
>    while the common check works everywhere today.

Yes, this would probably be opt-in by architecture, unless we decide
to give up on lazy mm switch altogether and pay the performance
penalty for that on CPUs without ASID support. Either way it is not
be something we can do right away but that we can still consider
in the future.

>  - The fault handler would need to tell legitimate faults apart from
>    bugs, e.g. copy_from_user_nofault() from BPF or perf in a kernel
>    thread is fine and must stay quiet.

Would it be possible to move those checks into the individual
callers that want to avoid the WARN_ON(), with a comment on
each one explaining why they do that? It feels more consistent
to always warn here, and I would expect that for most of the
_nofault() users we do want the warning, and I'm still unsure
what is special about these.

> The series handles that today by
>    checking current->mm in the nofault helpers (patch 6).
>
> The two approaches are mostly complementary: if non-lazy switching
> turns out to be cheap enough, an architecture that does this will have
> better defense against uaccess bugs. But I'd still like the common
> check so that these bugs are reported on every architecture.

Agreed. My main remaining concern is about the number of functions
that need the additional check, if we want to avoid missing
any of them. If we can have the check in access_ok(), that would
cover the majority of the functions you are changing right now,
and it looks like we can deal with the corner cases individually.

Since in principle every user access should go through both
access_ok/mask_user_address and current->mm check at some point,
so combining the two as much as possible should help long-term
maintainability.

>> There are of course few enough of these left that I think
>> we can consider doing the same thing here and turn them all
>> into the checking version:
>>
>> $ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
>> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
>> drivers/gpu/drm/i915/i915_gem.c
>> drivers/gpu/drm/i915/i915_query.c
>> drivers/usb/gadget/udc/atmel_usba_udc.c
>> drivers/vhost/scsi.c
>> drivers/vhost/vhost.c
>> mm/kasan/kasan_test_c.c
>> virt/kvm/kvm_main.c
>
> Agreed, I think we should clean those up, but that can be done
> separately. This series already adds the check to the common
> __copy_{from,to}_user() and __copy_{from,to}_user_inatomic() wrappers
> in include/linux/uaccess.h (patches 7 and 8), so the KVM path is
> covered without converting the callers first.

Right, if dropping __copy_{from,to}_user() as global interfaces does
not help add the check in a consistent way, that can wait as well.
It looks like we are very slowly converting away from them already,
as we have about half the call sites left compared to v5.0.

There are probably few enough of these that we could address them
by either adding current->mm checks or converting them to use
the full versions instead where that is an obvious change like
that usb gadget driver.

>> As a quick fix I would probably start with just the 'if (!mm) return false'
>> bit here to get something merged while we still discuss the other
>> details.
>
> Making the same point as Sean[2] but with a little more detail, I had
> thought about making the change in access_ok(), but:
>
>  - On x86-64 and powerpc, the masked user access paths don't call
>    access_ok() at all. That includes copy_from_user(),
>    strncpy_from_user(), strnlen_user() and every scoped_user_*_access()
>    block, which is where many of the converted __get_user() users ended
>    up.

Ok. Apparently there is some of this on arm64 as well, using
__uaccess_mask_ptr() instead of mask_user_address().

>  - __copy_{from,to}_user() and __copy_from_user_inatomic() skip it too,
>    and the KVM bug followed exactly that pattern: the range was checked
>    once up front, and the access came much later from a different
>    context.

Arguably this is itself a TOCTOU issue and replacing
all __copy_{from,to}_user() with copy_{from,to}_user() would be a better
solution long-term, if we can do that.

>  - access_ok() is also used as a plain range check where having no mm
>    is fine. For example, copy_{from,to}_user_nofault() call
>    __access_ok()/access_ok(), and BPF and perf legitimately call those
>    from kernel threads, so a WARN there would fire on valid tracing.

These at least could be easily worked around by just skipping the
calls to copy_{from,to}_user_nofault() as mentioned above.

      Arnd
