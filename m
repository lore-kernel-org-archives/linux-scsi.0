Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793054553;
	b=IU36R32bRlcx8rFgPGmAX+D/luEvy5sjIcxRm18e6pNYeHA1alXA5jHvRT34YgoFssXW
	 emiJ8EKNSeh0S7iZr+CNXT3TCg3H+qEpMK0eYORNzmJVf1mXoopAzthjF287koIzYXzr9
	 EaJieFY1k+xUcXej9JFuxvOJl1k6e98yUZt1eX4yEXwHPbyFUtPGdJUcVaUwF7APIZYMS
	 W5yIP7WmdViNpNvPv4MxZ3WExIWEWJYh9RqbZ+P78giRK//YdC9rd6fYgp1VXrH2UiN7s
	 4SLI3iYn0/1lYvQn3ULfFc+e53LvY3/pMQ8HWAnu6PX2o6dR4AUOQG0mbnj38+Ye9Gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793054553;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
	b=IA4DPC77ihzlILFjDK9HiyeId6sbnwbzRK28Qodota6LatZOLyLTpUGxvZCY6Fps1XLK
	 kEeCFRS9iyqCshzwXrWw+f+25Jn6dV4o1MKXuPUBxezd/MvCSO+sUc0UzapWxA4tzUBI1
	 DpgLLbhsEdU5OeovmyJOvIepLlIJmrKh/6uROw1xOdYUCJiuRn9JiM+lGsDqUTlz8h9Uu
	 uSvoLx68f4DbbLg1lp9eNbjlu7w6FwY9hBTjrdnrJEmHDunsphQjow3+6vdB+v8yZi+W7
	 fLfq0hO9FeuT0XOZUMW6JbiGXcAl/zOn+DcVpgr9dS4grFan57E4EmLRLUbFl1ENkjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Ho8+h6Mf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C80606A324
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 22:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56C80606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Ho8+h6Mf
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c43fbcb4393so495333366b.0
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793054552; cv=none;
        d=google.com; s=arc-20260327;
        b=HRfJwozP6xEH1ya2uAAJcDc21zr7e6MyWlHNO3+BRSDDz8x/NNw5LyZV/H2S3Hidxi
         qK98H7oMM/3xWPQ6uzlYYgUjgAKKFcM7klm8+S+u+BECEE+osG2vkvcyMfx7FRJZFBvR
         +SeQvtxBoZTpMiN2TwpeBrJ/3l3uMHf2OsIdcXFDN/Yb5MDYmvFKPXfw6bsxHnBIIVeT
         uEL7OcowJ/5DOsY/TP63YzwgdHaQ+k/nmGAHiXA48k6BbUicVrBicr1alKf7ZYhrRm8G
         LeoIDofKakORH5pm3pSEcDO5PAEBch43iYn0xaKJFd9dUlTIX8iBF3sa1XdU9jcWIBxX
         zd/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        fh=8D0TMyPK6BGOOoZYJMWMcT0yVQkitxUXiDQ09qfestc=;
        b=EjzzzzwtG2wG8ZRLlv0vnV88gZWpJkqVF1y43tC+JoqgpIFLcJMeEWZYTmaqiBZHq5
         UJihw1Fd0lrqGrQmh1ifouPKf5lEu9ibFUdDBNLO2DAERqtQK5zQkfa2CASIOnDEFwOs
         Wz7taYAgeSuN5RwxArMr/toCtJ27csF4fgVmAGwm0R/XHQNNPBxKBKgHsh2kIHbCoF59
         YG0NjQc4tyCboMBIbHRdgi0XOje7ULMPmqjaKh0XO+N0LAAhcp3Y/4wa86JhDRkNqG7y
         asJz02X9STLru22ZdrSXROHyJS/iLFB5+oZVPHUTuFpLC2rzONpiQS65WUmt6lRhVGRD
         8n7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793054552; x=1793659352; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        b=Ho8+h6MfzfNYBnYXWcB1Csn7RkH5FDAzc185C3faxOFFVI5Ip8rPZvUVVS9a7mPz36
         24gi8R8N3yA+KvfwmaRReqCQoQsNezGiPP1Bp7GiihlQBrxNS9eCbaY93g0l7+W+vIC0
         voQ2Heu+uMnZMYR6TuMnUotBhMhKn8fZO7YhZJ/VGMtSyWbiopW5EZJQ5vT2/6dOt2QP
         h6y7P/JEcSU5qhjYmxEPNqjJ3oooD2zuidI/sWorRbLSpg0w4GfbG7VlXLnZBZNxscre
         60kjozBonZXdnmTiD0g6qsMUd7kqNlcLdjiG7bhzjYU1/2dfEHHIUzSVvBAgpzwQCCET
         IiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793054552; x=1793659352;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1g41ScjhVwvRbzMcxKIfOWek1hrUNmo67dv5vjZ2E34=;
        b=d50Co9ZYi/lxSC5NkMPvR806a/QY6OWvJ5PBm6iFXjdCcvVL+34IFDweLyKnk3gNlD
         PreGCR0MewEmyfrt4EmYK/c4+XmHSZoq99G91czpV07botZgXwYp1x4rkxdWz0XyWurk
         RYydtXz6lYGJvkY2QJmoQPr/TzArqGFqV4vt1EYDweICbeEjOlg5O1W0KLvx0HbI0tVt
         NqY7Lc3j2L7vkR5K24S+LWtqi5UyRL4rOxo4fmndJ+SN260o6eAx3xaUv4ezW3o7aKHM
         Gyu9fHnAAsKnF91RvMuzGcjdQ4k6ShWUdPRlwuHUxBBcHdYfmZLoBf96vWrHvDdNdw3O
         Mb7Q==
X-Forwarded-Encrypted: i=1; AKwUvByyKqKMaTbzQm/Iqmp0gB3B3DL/TW5SHx2U7cYpylundrTRzUM8nwMrkrAUmtJHUeD3hGEGK0OAU8YV@vger.kernel.org
X-Gm-Message-State: AFq9FYKcmm+83TdQFaVawRDFYER+18nIp05B4PqbSkNBW/qS9s1/bUWV
	7ym3++yzSJTGyQ40tQ1G1PRwuD9JnBY/KleD/CZeYftXYvxxGR7hZBEfgYt/giGCE+B9+HvT8NG
	SxyKORC4pF1Of+15CNhuA48y0QkUqBbBkznTq9lta
X-Gm-Gg: AYBFou3g+o3KS/FdKR+vMup8zo2aIRPETGjZbQ6DHNrik5b2niVvLZZLmcnXZGyMTvd
	KVZm+zvCUwmz6a/cwxg0PD7B9EgtlncOIPMJpQ853bLprWX4yKvAPfwQG/gG2Pnwki3JRkWHp5Z
	hErtVGod3JPae33nFO/36h4mInFSbDG37FKVDV7j4TnflHD/P/6NBtEUpNeJdUwwY00tTJTkFO3
	sJ3GLzFnA/2MBxrokMu2/WidWNgppopPN570aOJdvN6+LmfENfOwMe46YFwiuTLG+bAOWTXfAWm
	lfgnnL/irQC1VwNDJ/STX7SJSwfcAVXi2wVRVhtHwlbMcuaLHjQwcJgm4mfDm+JOsiuQentvf6z
	WyMX+V64YSa/XJw95VXr4zLg1voguuxWWq0mXSxZdOYaMjMZrx/RW9K2idxd0h7y7+9Z11TIBgo
	+GGhcxkoH/+PiMDIf3qd99w03F53dI3oR24+cAoXUG5tGle4vxbZUi+cxX0K2cWFLabM7PP2DL+
	uVLPcpm
X-Received: by 2002:a17:906:4fcb:b0:c46:8733:642b with SMTP id
 a640c23a62f3a-c46bdeba20dmr991156866b.43.1793054551213; Mon, 26 Oct 2026
 15:42:31 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026215226.3713941-9-jthoughton@google.com> <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
In-Reply-To: <da7bb91d95914febc9b2b981c0b8292022d6f6437ecb68ed2b717f0f4a3a04c2@mail.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Mon, 26 Oct 2026 15:41:52 -0700
X-Gm-Features: AclHuK9NQf_DmtP280VFWB18VLK39ZMzdxZm9Qsh_-4Snm7U1eOCkiznChHcSHY
Message-ID: <CADrL8HXA3KVX9agtcExpPuaBLC-zAEWx6QgsRnQ6+cb4AZZrFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/10] uaccess: Refuse and warn on __copy_from_user_inatomic()
 without an mm
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
> > uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
>
> TL;DR: Commit message only: it names kvm_read_guest_atomic(), which no lo=
nger
> exists in this tree; the review suggests kvm_vcpu_read_guest_atomic() ins=
tead.
>
> >     uaccess: Refuse and warn on __copy_from_user_inatomic() without an =
mm
> >
> >     __copy_from_user_inatomic() never called should_fail_usercopy(), so=
 the
> >     NULL current->mm check added to uaccess_should_fail() does not cove=
r it.
> >     It is used e.g. by KVM's kvm_read_guest_atomic(), by several
> >     architectures' perf callchain and stack trace code, and by the gene=
ric
> >     copy_from_user_inatomic_nontemporal().
> >
> >     Split the NULL mm check out of uaccess_should_fail() into
> >     uaccess_without_mm(), and use it in __copy_from_user_inatomic() to =
warn
> >     and refuse the copy.
> >
> >     Don't use uaccess_should_fail() there, as that would also start inj=
ecting
> >     failures into __copy_from_user_inatomic(), which some callers don't
> >     expect to fail in practice, e.g. __wp_page_copy_user() warns if the=
 copy
> >     fails twice.
> >
> >     copy_from_user_nofault() already fails quietly when current->mm is =
NULL,
> >     and the generic user stack unwinding entry points (perf_callchain()=
,
> >     get_perf_callchain() and stack_trace_save_user()) only unwind the u=
ser
> >     stack of a user task with an mm, so neither is affected.
> >
> >     Signed-off-by: James Houghton <jthoughton@google.com>
>
> The changelog names kvm_read_guest_atomic() as a user of
> __copy_from_user_inatomic(), but that function no longer exists in this t=
ree.
> It was removed by commit ef82eddc0e31 ("KVM: Remove kvm_read_guest_atomic=
()").
>
> The KVM user is now kvm_vcpu_read_guest_atomic() in virt/kvm/kvm_main.c,
> which calls the static __kvm_read_guest_atomic():
>
>     static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_=
t gfn,
>                                        void *data, int offset, unsigned l=
ong len)
>     {
>         ...
>         pagefault_disable();
>         r =3D __copy_from_user_inatomic(data, (void __user *)addr + offse=
t, len);
>         pagefault_enable();
>
> A grep for kvm_read_guest_atomic only finds __kvm_read_guest_atomic() and
> kvm_vcpu_read_guest_atomic().
>
> Could the changelog say kvm_vcpu_read_guest_atomic() instead?

Yes, that is correct. I've applied this fix in v2.
