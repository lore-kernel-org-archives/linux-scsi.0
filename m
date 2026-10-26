Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053848;
	b=JkGts5qqtRad0XQrh1EoetgD3xQeo9FuzWSQdcRjPsMXn0DlErAvwSaG7uy4+io7Aj/5
	 A6BFW9hdLg2bn05CmHMUvBrkVEGIOiarrOtppnHMPIk9YJCrO2MAVEtL2pdARV6FfX7KZ
	 x3AuNlhcLiGFgbTI1ReHSKAO+z3Yix2sISZlfevUIxM0CxtYyeKc0N3dIEo+bsGOVAWuh
	 F0yZje/UMXtThahO3PPemHEqJclG6HSolCvHdeSNTlOri88m+exn4uPdOuz11j3B5ilEE
	 0zYyJy7IAu1h0pKhn7/VEq3rQPQgpVsHTL+owDeUr0KIQpwqQyAAMxFqZUWNzzCu4dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053848;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=D1dGqPdZiLYrsql2Rc3j/ObDweNiJt+El8ZFD+tFnEU=;
	b=TVfDXpn8uzPQRn+yLchji10ygLF3n4lC2FrxVMXraqEjphEr/xjNzmfmh37FVhMwLc92
	 6J69y8EeAJ+ch2F4c0QYHHYMLtquXOPz6XgUMebsimhEsTwROBGeq3qEDFcbVZMuQbQCP
	 s+VDcmTf3b0noP/fhLRQQTLduMdw5bwhtHRI/JYjbbwiPc1OlZwbkM2MWEXwyXyZRXCH+
	 qNncZtCFQurUaQjNpj/pi6ucWXgsSw8nzv/myxRxUcl0Wn1WcO/fKbxlEVCfI8D3P3KMv
	 LfHdVf2okyqPwke7nL9MI4B63UKwW0wN68NbMLiLlEvSnyZjrVcGBIb4rjf1b7MJGKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MTjETDRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B43606A324;
	Mon, 26 Oct 2026 22:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MTjETDRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1371F01828;
	Mon, 26 Oct 2026 22:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053848;
	bh=D1dGqPdZiLYrsql2Rc3j/ObDweNiJt+El8ZFD+tFnEU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=MTjETDRaX5IWRNr8zo6eKcsiJTMXj+jN5NU52GNhzTuJRRqsP1n5ZBGqcFAjr6fxu
	 EzlWBsvul3YDuKCrGi/ceYnyJDr/B1kyJy9gRkhZRGf8lF5CJDGR0pa/RpbRCnrHme
	 T4f28IThtV4cEhl2fY3ZvlQdIPaRab8JY0x4rOR0PyNYR4PblnjRrkwVxvMr6ADALH
	 ks3gMfQjUnxNgrqTZVy/T19F6SFiUB65MhNJqWOaJa0qIpXuouqUvHYVovS86BiDjp
	 kkmGyJsLpZN/FjZ+88pcWMIHWomiqz+cotPEILty6LvMiMEQSSkMj+afYnYn0LZV1u
	 yMMY50v3U71yA==
Content-Type: multipart/mixed; boundary="===============4380318559748323999=="
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-9-jthoughton@google.com>
References: <20261026215226.3713941-9-jthoughton@google.com>
Subject: Re: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:30:47 +0000 (UTC)

--===============4380318559748323999==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm

TL;DR: Commit message only: it names kvm_read_guest_atomic(), which no longer
exists in this tree; the review suggests kvm_vcpu_read_guest_atomic() instead.

>     uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
>
>     __copy_from_user_inatomic() never called should_fail_usercopy(), so the
>     NULL current->mm check added to uaccess_should_fail() does not cover it.
>     It is used e.g. by KVM's kvm_read_guest_atomic(), by several
>     architectures' perf callchain and stack trace code, and by the generic
>     copy_from_user_inatomic_nontemporal().
>
>     Split the NULL mm check out of uaccess_should_fail() into
>     uaccess_without_mm(), and use it in __copy_from_user_inatomic() to warn
>     and refuse the copy.
>
>     Don't use uaccess_should_fail() there, as that would also start injecting
>     failures into __copy_from_user_inatomic(), which some callers don't
>     expect to fail in practice, e.g. __wp_page_copy_user() warns if the copy
>     fails twice.
>
>     copy_from_user_nofault() already fails quietly when current->mm is NULL,
>     and the generic user stack unwinding entry points (perf_callchain(),
>     get_perf_callchain() and stack_trace_save_user()) only unwind the user
>     stack of a user task with an mm, so neither is affected.
>
>     Signed-off-by: James Houghton <jthoughton@google.com>

The changelog names kvm_read_guest_atomic() as a user of
__copy_from_user_inatomic(), but that function no longer exists in this tree.
It was removed by commit ef82eddc0e31 ("KVM: Remove kvm_read_guest_atomic()").

The KVM user is now kvm_vcpu_read_guest_atomic() in virt/kvm/kvm_main.c,
which calls the static __kvm_read_guest_atomic():

    static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
                                       void *data, int offset, unsigned long len)
    {
        ...
        pagefault_disable();
        r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
        pagefault_enable();

A grep for kvm_read_guest_atomic only finds __kvm_read_guest_atomic() and
kvm_vcpu_read_guest_atomic().

Could the changelog say kvm_vcpu_read_guest_atomic() instead?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============4380318559748323999==--
