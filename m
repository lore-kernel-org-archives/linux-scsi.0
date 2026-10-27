Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793122223;
	b=dZ+aHJpJrXGQGrEBvIyZMNoBH2XXhJO6CW+HlIopT9wJNHLTqebT53Zbl5WPtix/vdb2
	 6Z/0SdDofiGexXnhe4r1C7NdPv5z2v6+Oy+HfOdxTYIQK6hzl3QKWNza+dC2d3lCGvM+n
	 FEKWiys7oX81cHtYb3sFjrpnH9sj7OZVIDUJ1QKU7uUpTaiROjEBOO7WF0GKdFGscxID5
	 j0NvRG6rl2YACfMrM2+0xSA4Icfq9p8ChVLC2qcJbypH/Op6ATOPkcLztYJ8kWvB5MECP
	 04BkRjkr6bK9x6IisqCOVduzO9Pc+RbbJ7PyxmUG5xzFbMcCW1TVslciSiWuKifUhkA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
	b=zGl5oZ3dpks8H6jgr4Wcb2uK6mnvXCKowJWVZt+l2ueTH6TfWouFbJ6NfkNoXDt62jB3
	 crt9EJJ4U7xN2MvzwcAAGVDxpcbEGCsIELqDTf2sZ/fLnx6Db7vowShSwk/Gx16Vp3uib
	 SNIRbG9vJ57or9qScYAhj/1S6wnXSPa9aQwKMha9XmT5fEAKdkQbBq4ldSHR+XAMexnZE
	 lAedOYlHGMP+pML0Y7vIkqaay5sPfO3bVfyQdezm9VldQtlPKcmFyeIVSpHW8C4eOxeUT
	 MzYT6x9JVGsIw7wDGZpO90c0ysQTLY670ke1U9EgdMfQpsnhUFHc5X7WfLZg3eJqaPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AH5XVSYu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A38606A321
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 17:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89A38606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AH5XVSYu
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c4322d310e7so11515066b.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 10:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122222; cv=none;
        d=google.com; s=arc-20260327;
        b=QRksCQ52DsdcNX/sdV5v2fF/D8T73/jcEklsOAiv0/h3CCm6W3jWy0L4NUtom8v5e0
         RXdibkPWZ0yiyJ07Qzj4sMcyUer7ekj5gKgNz3RvVZFfiHbxcg70llrzH+II0GolfZ8X
         gMUftOAZrthvA1Bn9UVnbLhAiJlSBczBLlibqgSQm5Nog6PpjvMYofs0NF5r7wLxzYHs
         0oP0cYRl/V/dmbAhHaB3PDj9eubJM6lnHY+NAt+cDZ+4dp8qCCGG4aAduGDEN4iY1DsC
         yrBDcEPytR9l6aqJElUV3b8acxX4ZgwJBCITh5tVr/tbpro/QJ/llGSWUOrveNDbGiYd
         nVqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        fh=6d3sb40ZOTjyqaQQZXRcZIhTBm2fv+x7BiKfnDSxY6g=;
        b=MTlEzP0ln04TDLdHvojAjZGMobVhG0lV4ak/Zu3Kbs9MRkvHLY0F11qNshJxbIWiYz
         0uJ3fKce5K+vp+wUc8v/yJLofKt2cRytnEWFor55scQTCS9XQoety21iYHgArAXiirKz
         KY13Jy4r8kJF8pQ3EK8/7Ms1ShrBWp76Jp3S3RU4Gq5tbCdGCpq67EjFOxf9JyWip0JY
         QPV2WHItWUsVgujLlmfj1genNQtW6/JVRBR+aqsYmSSFnNdYZS5YOfiFMcVYl5InthsR
         0/WcTXKsJxOKvpeOzsCpzqfMq6HVVJUEix0gSy5WrcweE2EhDFzjIQSWzCAKkrvLOW5I
         Flqg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122222; x=1793727022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        b=AH5XVSYuq6HUx6QejcrLzJHXiZbWI9DboIxOz+yByNgh84gxZAIKBuzZHV99EG6rqB
         sL71z4Wm6MSPA3Nnza0i731ilrImuFj3jUTow6hkS/0r7bYzxQobbOzdeIyt6ASGeEbF
         yTa0PHt944q+HSgG6NrCVe3wZJYFAVwhpzaLqX011nHEVLqO4I7UJy1zd5cfMTXQHdaA
         BSUKBBxl7R08MamwKyO7Ss8mI2wGFLi7Y2RxS2XZ75lMQCOMaDZ6YNjy/Um35SI/BQEx
         H9A/IMXo16KCWMivgQdBOKUL0g+UWglSQzebhEs3U4Ckl7bH2Y72gGHNDHSXACje/sxH
         22yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122222; x=1793727022;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7gQ+97vReKa4toS9130cb0MEUCUe5fofr2ehSKz/dNw=;
        b=fJ3HLhm709zHA0bCPV9L/3eLomtZ2JCwgCUlFjgIj8LmbR50QHY0UFoKeVyJeaA+uB
         +T1iPxbNFcLPOLDaK61Ja4UoWFqf9qv55XOgAOpers2APwci3IqDlBTnUVHSaEwz9U5m
         FZxg0Nz+T3bqqbKhjr8/YvmOqdobQE+GHwiLjzCagJdNwk85rQYASv/YuRK8p5ZB1pXg
         wlMbGAJOF/urh6Rp6DklE9sL2sqTCehJz3dRZfkIFfchhsVW5HihOI12hte9ukWZ69Iw
         qNvm8uuV0kXJlKBii9+Ocjot+4Vdna7LWT4oqyY+arOEiHkc2Lyo7ul7G8nvrvlFECQq
         6goQ==
X-Forwarded-Encrypted: i=1; AKwUvBxONiKNV8zkUktvxGt9Zxnyqv4zeTtVG/KU33tMP9DzokUIFK3/Rt4y58Tr0BpYfINOJ2HipVIx+BmX@vger.kernel.org
X-Gm-Message-State: AFq9FYIGE2JJW4WRCWq0LFK68NDtpISLdgZwQJI0E23Z+XHA+OBtz1A4
	2M6f0kc7vv9HlA3SFpEdW/t3sxGHFQ9TzCItDgw5AA+qeH3tN7Fia5lNOi5th3HyNb0SuhhZLE1
	+Y/Bmg2wBciY0vTJTcdkb8PszuiR+IQnPjx8LMDdW
X-Gm-Gg: AYBFou3A8CLS75oo+kZsV8I2eFz+74oMC+BDTMKfrcOBlHQ886Ea+XAlOx2l+mO+rCD
	xxxqeoqeOf/XNMxvZuC92P7OLbWePHbxaYSsFVVbkyXwFEcpUdMJerd9PRgkT6zealO31vBUydE
	r7n6oASGQU2yl/7cWpHcRs8mL5YAOdw9fbuCQwdNQVjPoWQYZQGGwZauG4r9DNWjDIEyWHSc7eg
	vo5/pa8/KigA6b0ruJfISbjg6Kl8iFOQiUIo/D98l2Nf/uYU/GBSrcBkuy4lE9CuxsEbWzC/YC0
	cOPfK4Sv6M0rdTg0Rqvc5oVv18A/dBzDT9PZ2KZ7iUD+lcyxDv1M5Ey/Z6IwyZwGT3rInpSD/hz
	VVxJOjkM6jlP0NoBUCTfrAXmbclTc6++nowKGnjPLE67OyJ6C4l44BoIT5q0eMZ8fmnFxAwtDqi
	KMEGHqpDZU/iUeMyGq+j+PlnZVOybQkZtilE1/WDesPS2CH2ZV/OQxZuxePabxPjV00xHu+e0x/
	//k/SxMI5HC4BuoTMYr0z+nXx0VeR8Ssg==
X-Received: by 2002:a17:907:80c:b0:c46:6a50:40c2 with SMTP id
 a640c23a62f3a-c46bdee2675mr1178260566b.39.1793122221137; Tue, 27 Oct 2026
 10:30:21 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com> <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
In-Reply-To: <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:29:43 -0700
X-Gm-Features: AclHuK_V7ZmMdE83iy-wOvaliSqHMUcbKVcnfqQwnRgRgjPYRFDHKTZOMwXOk5E
Message-ID: <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
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

On Mon, Oct 26, 2026 at 5:13=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Mon, Oct 26, 2026, at 22:52, James Houghton wrote:
> >
> > This series comes out of a set of bugs that were found in KVM where the
> > kernel can sometimes write to a random process's user memory[1]. The KV=
M
> > fixes at [1] are still required, even with this uaccess series, as note=
d
> > by Sean here[2] and below in this cover letter. The beginning of this
> > series includes fixes for similar bugs found through static analysis
> > with Claude Opus 5.5. I don't think any of these bugs are more severe
> > than the KVM bugs[1].
> >
> > We hit one of the KVM bugs in production, and it was challenging to
> > debug. This series makes such bugs, where the kernel is doing uaccess
> > without an mm, much more obvious.
>
> Nice work!

Thanks!

> > Such an access does not reliably fail. The user portion of the address
> > space belongs to whatever mm happens to be lazily loaded, if any. If
> > the access faults, the fault handler refuses to handle it and the copy
> > fails, but if the page is already mapped, the access silently reads or
> > writes another task's memory.
>
> This sounds like the problem depends a lot on the architecture,
> and to what degree they implement lazy mm switching. If an architecture
> makes all user pointers invalid for a kernel thread, this does not
> actually happen, right?
>
> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
> the current process is only set in user_access_begin() and would
> not point to any task here. Without ttbr0_pan, it should be
> covered by cpu_set_reserved_ttbr0() turning off all user space access
> for kernel threads.
>
> Should this perhaps be addressed in architecture specific code
> instead of in a common place?

You're right that whether corruption can actually occur depends on the
architecture and config. I'll write a note about this in the v2 cover
letter.

That being said, I still think the right thing to do is to have the
new check(s) in common code. Instances of improper uaccesses are still
bugs, even if no corruption occurs.

> > =3D=3D The New WARN =3D=3D
> >
> > The rest of the series makes the generic uaccess helpers WARN_ON_ONCE()
> > and refuse the access when current->mm is NULL:
> >
> >  - Patch 6 adds uaccess_should_fail(), which combines the existing
> >    should_fail_usercopy() fault injection check with the NULL mm check,
> >    and uses it in place of should_fail_usercopy(). This covers
> >    copy_{to,from}_user() on all architectures (including the masked
> >    user access paths, which never call access_ok()), the
> >    __copy_{to,from}_user() variants used by KVM's guest memory
> >    accessors, the user-backed iov_iter copy routines and
> >    strncpy_from_user().
> ...
> > The checks are deliberately limited to generic code. Accesses
> > implemented entirely by architectures (get_user(), put_user(),
> > clear_user(), and direct users of user_access_begin() or
> > masked_user_access_begin()) are not covered. Please let me know if the
> > new check should be placed elsewhere.
>
> I would think that user_access_begin() is a more natural place
> for the added checks, as this should be called exactly once for
> any function that accesses user space and also stays out of the
> way of the copy_from_kernel_nofault() etc.

user_access_begin() isn't used in a lot of places that I want to
catch, including the KVM case. Roughly:

  kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()

There's no user_access_begin() in there. :/

I do think user_access_begin() should have the new check though, so
I've added it in the v2.

Thanks for the feedback, Arnd. :)
