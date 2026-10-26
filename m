Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793055393;
	b=Wyg0Rw7W3LX3kfzo8Pjep5H0uWnYzuSwK/3wqa/PcLDVDw37zQzxdYGI9wuxxM5ciOCS
	 m4UWv6f7O2qQgw90gODlE82u+w5WDXV+FoDzCnXJxaH5sxDyf5r+h6pHNZaMWhhE3UhYp
	 BZFFio286c1M2N9QdZChBewC8+LUmMVJTR0T9nd9K4jwzyXI73HIhkmymNHwJyni5kF/S
	 8XiNRpYoStj7UIuQHcUpfJfmckmRWxMGeSI9AgduPcj47Ot9GlF/YWlBRHtXOhAkQ9+uY
	 9ouVl9Hl7ysMvht7Jo3gsJjcNm0oYeRUJpEat4+B6pS1OH1gLjq311XG4EgJZhnsI4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793055393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
	b=YCFDaKqsZPEf6NiY39I473PuNRbdqhT7Kd772s/I8VTQLEQl+VkgBj+YKlwLXYx7RxbA
	 CvZ2BOjX1h8v3cktNH8Bgo7Apdxl02EuRk285QiqUsUde082frA/Wv8MDlaPstSlMvDj1
	 n59jV1P7PW49wJTDVNSJ5hdZNkiBvVn2Av4W7kubcSh81HEWrFgNmmLWZ7GLDzFwGviKr
	 lklM/2M8e0cE/F+XC5A7VLjp2+1VioowiVeKgYDudAZfhzdqDd6KsyJM3Z2WXpRhpKY/r
	 eBIcF3VfGVGCBD6RS/9p22yOyzyh3ZGOkVc7r1MF3k65eszQUjgUUa4D+yIQWMYFNeQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s8grGiR3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAC4606A321
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 22:56:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FAC4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s8grGiR3
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c423b145922so479997266b.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793055391; cv=none;
        d=google.com; s=arc-20260327;
        b=Zx070j1ZRXoy7z5+jfm4g3xMmXhrfOsmCHOiNqhnHd52AkeSUKatsldxRgfDiQSFnE
         lDTUaus82gwz8UanXzBz932kbNPFcy/aVwQuQQ7Pd487qRGpY2bjhW+N6/i/7OGyme+Z
         Pi+dK/dHMqT0kcKvBecqvWIyBTp3FxATaWIUfQ9OA2Nvp3Fol8Vl05ZFD1XGVpaLPhMx
         Se0h6x/rULQqwqNODzWajuZcVJtyfQwPzDfWR/eytYfMRW+/diiIP+IMZsfNXfEwNCOm
         ZXl+OkqsSzsMOfwaN/b9PukZww5TOA93Uf0CI6MEnFee+q9zMdkJDTL43uVzI4vz8FSL
         IhTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        fh=hlBC4oReQytAXDYNnN5oMYaDwj3Wv5M1aUKrHtoIPGo=;
        b=bSmGYsa5MVPNGvx4wHje8/nffO0U4zpt5DvHaxq9GNlNtEgWC2Ii1P/hkWZ8wWs+tZ
         PeZWMSqvdfPJAyv8uLb0uBpqoUxnpmPl9uQPvg1spnas38G7Xb7j2WLxg0bcbcQiGPlt
         ahRmoH8tgGQv8OfRb5ibxqPmiW34RF1FnRZ2JEiGmsWdcqQrQfH8o6Z5W7Xb1GilCiRQ
         FhcHEgVaapTn11ZuIulbv9wKvG24uvSSF32s96pwnqdnV338DhshLXPMHRaCCxtc81XH
         /SV7jzVvVC4lG3Oxj/T6STNbLxSGLZsTNdP4MLvLxYa5ZnJp24/ERIKXfTGt+qcy3dxi
         poJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793055391; x=1793660191; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        b=s8grGiR3jmOk9ry50/nEnZjaxWjWOPyppi2m4MHQTMfb5el8k0obk5/UMSWfPsQmIM
         HPtLzsEa12OcSsVXiRmiCNw+UUDDo1UYyS6DiU9bwXoKmoGF82ns9DjJzrfs9pJWdjkT
         dIxIeAf/R+LNQl/XTj1bdocyLOLlTkNfh75pW2KuZcZpn6JGMaXwZms8i83nnm2msMhG
         qxuIapSALuC5I4z0EKwNizZvGG6PaVYwrsYFc03clQ+zaffY9Yi7+Rd9DeVq8TqQMsPo
         mOa9KjkQgAnBHYiQJzjduIMO8ab1In9zxpTDESz20wql691IHa3z4eYMgIiR+VfFmdpS
         4rSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793055391; x=1793660191;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qh7+bL2tt7/pVu5eSjikO++61ieI9Cj5ZNr8SJkHxX4=;
        b=ngp3n6G4FqxdL7GqTCAdGa6AixGnzQ1CuJnTfynrRU1CfR2biOGQS8Kpka9KWGGnGN
         xE8kv/IFxhsat1N8t+skNxU86qUKeGtOGDkaForHZ2q3WUqru2yjDdNdJiwmONT6s4gs
         qw0ju3jhD4Xd6ZW7ShuLqK/+V5ga3JgcsC6RpUP/VlzqMlFcuH7d7aCL+23Q3v82MEEz
         aFtwdE/vv1oqn+DaQ1gPN/T1n1Tn2X8CzJkYq5/xrgV2PQ1lNj6A80PkXJH72RwmVoRh
         tojc+txv3litVY1dhT8gfY8tUYNhrRzwXFFddtxFoH7sF3EvlTDJzmDux42JHKM395ER
         289g==
X-Forwarded-Encrypted: i=1; AKwUvBy3EHtJn4JpA6DzbFbLMYRgTIIAJ1Udyi9yfZ1t3QxXwpyj9AhqDPVZsChUj11e0+vdeuvk6/AKK0p7@vger.kernel.org
X-Gm-Message-State: AFq9FYKWilyTutFk80BnBFjlinle4Wh8UZgG9gPYAo0HZRIhg+7ziuMT
	/csZSG24KXSiS94KD3N3cNwADICCy6pexhHiAOGhgj3ZXlga//lA/ThbU4QLRXFt1ddytybiODv
	jv/lExA/ld2ZH+5BrHDSfMqAoHCuTUrf/pMpZQ5lr
X-Gm-Gg: AYBFou32GHDNIQ6EGqyKx4+unNARBltnIxWsPO0qfn4xO5WG/9UR8xklpm3KRvToauV
	YKUrDx+ngjUucOYOqisIJCHttWUa+zaSF2EiDozGWahwRcNOR/4nESLkPaA5/7fbQjUnIWlEIGl
	//zjPNPhYpr1u7Lj3Ixu9CboV3FfIHClqriwwHN99BpMPvHdj/UfU4j2Y7+d2R4lyA8nr5PzbNh
	JYh04aw1m7YgEdLqJrONJ+Cr6yjCOI03lK3WkPQVqp3amfVxm9foVKh6bQKhq188rV/oGwCCL9H
	2EgFwd+SI+uMzWwMrr+vOGdXQKG1epBYV4uMaY5LX5sRaj8StPTnU08XYAMl0NvZh7eCnQHcKC5
	7HkDurG0QLkNdbOFqPc9q9V3lPAJBtihX5vi4x4BIP+9BbKq9K7gLe+tAoLJqZe1upbYDFttzI4
	HrA3vltGMMdcNSm2zjune9Qg311qJO4aCM4lYA+j3FI7jzqZfOP5UwfFWkovJUFMJncQ7amDP7/
	j9R49rI
X-Received: by 2002:a17:906:9c8a:b0:c2e:7da8:f54f with SMTP id
 a640c23a62f3a-c46bde874d7mr911731866b.38.1793055390933; Mon, 26 Oct 2026
 15:56:30 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-5-jthoughton@google.com> <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
In-Reply-To: <bce97570ea9665a2f83216d4dfd7ab7ce17d54aa777f761c3d12db430ba21bb9@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 15:55:53 -0700
X-Gm-Features: AclHuK_4pEIR4EnpfJkK690R4CHqdS4wt-7zneGKcf5MW03i114xuH5q5kcZiJk
Message-ID: <CADrL8HXeYRC8w7F7e_6ZXK6MHd6FRepN_zD632j0JPjNUDrLZw@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] stacktrace: Don't unwind the user stack without
 an mm
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
> > stacktrace: Don't unwind the user stack without an mm
>
> TL;DR: Commit message only: the Fixes: tag may point at the wrong commit;
> 7e8e6816c649, which dropped the !current->mm check, looks like the real
> culprit rather than 214d8ca6ee85.
>
> > stacktrace: Don't unwind the user stack without an mm
> >
> > stack_trace_save_user() only refuses to unwind the user stack of tasks
> > with PF_KTHREAD set. That doesn't cover all tasks without an mm:
> >  - A user task that has already gone through exit_mm(), e.g. when an
> >    event fires from exit_files(), exit_task_work() or the final context
> >    switch in do_exit().
> >  - PID 1 before it execs init, and usermode helper children before they
> >    exec, which are created with user_mode_thread() and don't have
> >    PF_KTHREAD set. E.g. booting with trace_options=3Duserstacktrace and
> >    an event enabled with trace_event=3D unwinds PID 1's "user stack"
> >    during initcalls.
> > With the ftrace userstacktrace option enabled, the architecture
> > unwinders then read the user stack without an mm. That access does not
> > reliably fail: the user half of the address space belongs to whatever
> > mm happens to be lazily loaded, if any, so the unwinder may read
> > another task's memory.
> > Use is_user_task() instead, which also checks current->mm, as perf
> > already does for the same reason since commit 76ed27608f7d ("perf:
> > sched: Fix perf crash with new is_user_task() helper"). This also stops
> > unwinding the user stack of PF_USER_WORKER threads, which never run in
> > user space, matching perf.
> > Fixes: 214d8ca6ee85 ("stacktrace: Provide common infrastructure")
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> Is the Fixes: tag pointing at the right commit?
>
> When 214d8ca6ee85 added the ARCH_STACKWALK version of
> stack_trace_save_user(), it guarded the unwind with:
>
>         /* Trace user stack if not a kernel thread */
>         if (!current->mm)
>                 return 0;
>
> That check already covers both cases described above (a task past exit_mm=
(),
> and PID 1 or usermode helpers before exec, which have mm =3D=3D NULL).
>
> The check was replaced by commit 7e8e6816c649 ("stacktrace: Use PF_KTHREA=
D to
> check for kernel threads"), which switched it to:
>
>         if (current->flags & PF_KTHREAD)
>                 return 0;
>
> That dropped the no-mm protection, which looks like what this patch resto=
res
> via is_user_task().
>
> Should this be:
>
>   Fixes: 7e8e6816c649 ("stacktrace: Use PF_KTHREAD to check for kernel th=
reads")

Thank you, yes that appears to be correct. Updated in v2.
