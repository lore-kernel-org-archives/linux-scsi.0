Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793123600;
	b=ouDFPRgIt2hXVIbdO1k6/TRaNTWdBlSxKSWmHaVARKX5HEcAFGrZmx2tMPXInFFaLAtf
	 NgHx35e4ecQqQ15V4xMpnHOfn5zh6lwhcdhqjtMt9hbIwyVH4OwImPeZzeJmycNn0SgPh
	 UYIUHuQfKt/kM90qsykIMAmyp9Oy1NOWL6f/NmQBigNMz9GdFAuN6wzf3iAldQzBMHRTH
	 GlyVQzJOQZRkebWtnp9MZIQOG+OQJ4j2VTJNukiGMA/QlxbThDAIc7h6x47luOoFZDYXf
	 tZdSaxMm2E++yzjQqNVSQoeuTaPZqckkjZw/xzJ1a0/CUFtK9/HCy2Vxlbyz7qctBMg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123600;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
	b=SZacMfMxmubaHL0NyWuGavBgSa/AwfpEME+oXcNJb4sEheutAa3NdA2r6hRbA8ZEMqWu
	 ZsN9exZUbLtwpHYLkjUsrJVh3OKVlNDU/cVhHENU6gOKIjqmIh8WsKrZoPlYEBQeuM7bQ
	 SsRc93+dZNCmttdRqmIg2qAyQ0K8U+pKqVsGpmeg285ANYsqVmpepENNIeXkZjK9W5d6L
	 zAV/JsDXSPq9vjkkqTIyppg0/2FWT5MymH8wmdRR9qXc/3ALJnfSlaqSfXXbzEvE5OlXW
	 YavdGAsJFV/R7qPuid256x37SjyCTT3gRywrwnivan89S7QsdP2M1c8WJitD9/mneOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=inJR6ox6;
	arc=fail smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76F4606A31F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 17:53:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D76F4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=inJR6ox6
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c46d41f6af3so13862466b.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 10:53:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123598; cv=none;
        d=google.com; s=arc-20260327;
        b=s19yUUkjAqgt0ZG0o4OZNY0dfwvqsEELib7UaMOnblTXg9t/IqSt21IqHZcjQOVj2f
         2mKcVwD0QhcYy4LTa3L7/9pteWsvs7k8dj00F0grPzbQ21M6IYJyrbd0o//QO5q7YdIY
         tFPce3auqV+474ThJrlrWbKOrLDUOTwJsPxEhNcEMlaVfefUs22VYiHiifwcfd8QYCSH
         IrjUo9UUBjMaWX/iDSnx6i48RlRKRVUZdEwR0krCfA1srGM3NI3PLXlm+Kg8UvRzzLPv
         sOgHX/ikSZgN86hyndocoZsf8JU4tdJxI/1WQzQ3PXUm4EwLWC50Sqo4du9KtthaVcJB
         Bv7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        fh=sOS/XA3MhrS51h/od48nrlHoPhAB/GdRx2Xagv4dE3w=;
        b=RLDQRR4kDYdBgtnolULC9d1r5OJy/aotRpY3EEA3AD6F8eutSiCvEgSccWz5aPEZiO
         TD06bvnziBzme2tS5K9E3PWldmjwnroOtowPHcTwFnpXYLTu9/Uuj5gZePdTsv+WVnCa
         kznoUZmB7VlQJcz7oQ4J5RRqFgMvm45oraqc6StWe3+BPw9RtDb6V711jfIMQtNSpP99
         JgZaAE9A/WXK2+uy5Ir4wqBEUaUuKH3MQh4AuAfGpYMapIB9EmAL+22/Yah28hPB9qQn
         Y1KMybnx4/Ojil1knzge57Nd+VmGDmI5/9QzHZT9PmmL4bl+09er5afkg0xDVDuGNg/p
         xRPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123598; x=1793728398; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        b=inJR6ox6aQPgzkJ0wZYiPBugaLW1/kUDoRUxznaXNPrxE2Wn3DkQl3afONPaEwO9sl
         vnrt6FP9OFfRf9KWlwZNng3ZlaCrfp3bQxPXGc+Gx+AORrKLJ8WZpN9m6kJEM6IAqHPq
         Jk4iMXPxJgkZqxRsoYIxQcD6CPbdcJbwTT1mEJs9Oh6VfooqjmJi5DvsYqRTbZ70S79m
         W2gdT7rvplj4k08tnzQQgxgOTLo5uqZ4a0mScYBLYVaYMXTVeZPwvd3azNIWeu6/sXO8
         zyeS5P1gD5N0vXZJTHB1IRGypOyTZEZWjLyDPXDDqsHxY4MhwV784zCuBQDBJ99Srvxy
         lKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123598; x=1793728398;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eZ7BfEA5+mgPjgQ08MRW3gJSoX82BS/9Z3gx++ZKTBg=;
        b=XB7kdUEjMUReKYE2RVJSbXqyD0Ff1hxSiamPMHeVT1AX0g1gG7ufjBMvYYRtAn8DGi
         wQ0+XgB0bj6kNkUdCLizsn46kkQDzIoaR4DOyUfxOKOAW8hgAIeN5xboKqZn1NsxmKwT
         WhT/H9f53TQNe66eqQy3Le6uHp3nJRuEHTTVgH/O6Jeue+o82GRdqm4rsr69Mvmp591p
         6bQ6X6qxuXQxgllXdWBf/ekM6pQUGBzE2CLiox5lfwrB5BZLdo2eZusPVPawV7BhpJm/
         JZZAtWAY9EDyU+0nKTRcJvQS8ajiC+Tsi6CZblXtZfthLjgSnpWBMumxGjmUzvYyepR9
         WcBA==
X-Forwarded-Encrypted: i=1; AKwUvBzr10Z/bY0B0DR1VAHMk64ybC3lqKiVZsaaZiX2RfFvV8phP9vCysi+UCOrDPBX7o5AmQkNKMZ+ruja@vger.kernel.org
X-Gm-Message-State: AFq9FYLO418NOxOE2G4B0CyvZRN10HWRvihpkcbdyRO7glL5HJ1GXlKi
	6UpWEOJIfVbtfxpJIaW+tvipQq8y7+8zsqO5NN7N0bRLangMmlQ+/iTey2lBwsFut9ny7ed3ODp
	XB6MO/trzNmcjEjorO8I5KBHGoR1+xxeNKDsfNbv4
X-Gm-Gg: AYBFou188iX+lSAfvzOpY3dNieH3i6JCAQuu2uyLEdZqKVNFwQ7rSUiB32IAkRCk2KZ
	mStJSJRR0RazhblzPKRF87LTO80SlR9p/mn6XZxLP1oTS+pIZP7aMoCO0WRTLttDCXPYhb3vOa9
	AR7SDHQSDqrXpjX1uu0US37i50CRjV+3ZnfiCs20I8KxBi+1CCJih/IRfeQMQQPJslFpicKwN6q
	qcKn8XNYHG1i/WJ9YNaTQMlAwhOy44BMiKkyA403LMCKUXmxnxSbrSiL2FCBSe83M8AabeBw7gk
	RO9mhA0KfsQY+aoc1K5WFlP2b7Wbomg4AGCxORO/ZRyk9MntAaZiSBTOyiDvKkJ7i319dyvOmyd
	SrBwfVyElW9OxxKrs9yrXJoLO9mNUYeWEMECZqZsHatX4G8VRGtTwrpXmAiXAQLo+c4E9ZCjHhV
	P3luqhtyzW1ROhhk5WICq09LoamHwhEWcpg+fwv156G9dz4jm3w5J32K9z6qOe74ZChXK3i/Te8
	MBTihbknHeMVg==
X-Received: by 2002:a17:906:dc8e:b0:c31:e958:408c with SMTP id
 a640c23a62f3a-c46bde8b464mr1159692166b.38.1793123597614; Tue, 27 Oct 2026
 10:53:17 -0700 (PDT)
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
 <20261026215226.3713941-2-jthoughton@google.com> <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
In-Reply-To: <1ee97e9e-3658-41a7-a879-348f51ab547d@kernel.dk>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:52:40 -0700
X-Gm-Features: AclHuK_7gnb7g4GjAy_SA5zcAxXhabVZixR-oCAtO-qS-tkfEqOEG_LlV9pvyY0
Message-ID: <CADrL8HVgOYb1hzWDJzm4sCrEAR7PL1xBv-1zTGebTusPoDsGXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user memory
 when canceled
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
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

On Mon, Oct 26, 2026 at 7:41=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Thanks, Jens!
