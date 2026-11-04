Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763543;
	b=BTbw3z0ud0H20h0JrRRTAEMndsI6TVcfRd+bmS5irZONCtLloQJ+7b0tg2FeR26GF1wB
	 g6j5nJJ9rpKDI4Rh3qQ+dK1C93IupqRxmZnOWyYzRYlCUFJU/yFrwZ1x1tSY4iO9g2Gqs
	 5tBYk63sZ3y3ZyASQc0ZZz/lb7o6OdOKcJYOzzxoqkzzFWghsxK6PrY0+UjmNh4pZKktO
	 U9yPJjEG1XolPiqxLIx5pECjbYgzPgtADcPKmGI9R4fULx/VBilx+QZhmEnc5BHXh7FiS
	 oO1zltZ9zuMSUM/qlHRLkTIMkUkPHg+2deVCe6wUOtMNU+aVE9stP3u68IDaaDy35AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763543;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=9MSatX/G/vVIWGJoAI0tPC6fx007E3Z2lu/4uprBFlM=;
	b=hUEeBwLIQRbHJveR7yYsr0C095wlfXI6PgbmrOtPVfBLfw0KBJNpsjkWmpZudZ1Rc3gm
	 6muoV6O1pSgSjl9dBoNFUQ6TuV5l9VNOs+DROieU+FswsxHTK0+lYCL/kXVLErcjIxhac
	 bTISKbjtxgpMojwys7IRUwLsZBycEZvc9Fjc2kils6qRephPFHV6k9wUiZMXvyQQsuM7H
	 OT5GS6ofnIiM2VChcxIVoU5EmyRa4QJAnr2IRNgoN3kAqWJE5IxdIUJcs+G/30qz8j+my
	 0fZxSg5u9ft+3MRBR2jj4y5uZN1Zmbo7Bf6i7zQIc0YGengA/RG0Sc59nI8u/LTEHTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oU8AH/tk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D3D606A32C;
	Wed,  4 Nov 2026 03:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oU8AH/tk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FA41F00919;
	Wed,  4 Nov 2026 03:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763543;
	bh=9MSatX/G/vVIWGJoAI0tPC6fx007E3Z2lu/4uprBFlM=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=oU8AH/tkWpzRwTF1kdq202zjvQncB0rfXyqulT4eyrNzEnIF4j48NgAbG2Caj1a7B
	 bMwPFiLxGpjgTtxKflKmS29xjpsYy+uoF/n935fbiBKeNusPTC1ePuFEOlPnPPcNEk
	 xFtpzO5elTJwY12Cy11QLYphesyVhHicZbo4/L/e91qX3dGksuyh8kvN9FyyrHgXAL
	 A2ZHgW8K1y0maVcVzKrTUm2MaPtPdCroAFRqGZ9P0+cop628w2faHu/6+eEMRMpwPc
	 3lqsGfgHjJTW8+Vc/3zNDrpsahxe/9gmvL+iS2SrdtAafA7cJAAJim7GFFQPdMePbb
	 CybKyOCyWeu4A==
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Thomas Gleixner <tglx@kernel.org>,  Peter
 Zijlstra <peterz@infradead.org>,  Kees Cook <kees@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  David Hildenbrand <david@kernel.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  "Liam R. Howlett" <liam@infradead.org>,
  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Sean Christopherson <seanjc@google.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jim Mattson <jmattson@google.com>,  Jens Axboe
 <axboe@kernel.dk>,  Pavel Begunkov <asml.silence@gmail.com>,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  David Sterba <dsterba@suse.com>,  Chris Mason
 <mason@kernel.org>,  Alexei Starovoitov <ast@kernel.org>,  Daniel Borkmann
 <daniel@iogearbox.net>,  John Fastabend <john.fastabend@gmail.com>,  Josh
 Poimboeuf <jpoimboe@kernel.org>,  Steven Rostedt <rostedt@goodmis.org>,
  Masami Hiramatsu <mhiramat@kernel.org>,  Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>,  Ingo Molnar <mingo@redhat.com>,
  Arnaldo Carvalho de Melo <acme@kernel.org>,  Namhyung Kim
 <namhyung@kernel.org>,  linux-mm@kvack.org,
  linux-fsdevel@vger.kernel.org,  kvm@vger.kernel.org,
  io-uring@vger.kernel.org,  linux-scsi@vger.kernel.org,
  linux-btrfs@vger.kernel.org,  bpf@vger.kernel.org,
  linux-trace-kernel@vger.kernel.org,  linux-perf-users@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] scsi: bsg: Don't copy sense data to user
 memory when canceled
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261026215226.3713941-2-jthoughton@google.com>
Message-ID: <yq1fqxh1d15.fsf@mail.kernel.org>
References: <20261026215226.3713941-1-jthoughton@google.com>
	<20261026215226.3713941-2-jthoughton@google.com>
Date: Tue, 03 Nov 2026 22:39:01 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


James,

> scsi_bsg_uring_task_cb() copies the sense data to the submitter's
> response_addr with copy_to_user(). It runs as io_uring task work, but
> io_uring may also run it with tw.cancel set from other contexts when the
> submitting task can't run it: from a kworker when the submitting task
> has exited (io_tctx_fallback_work()), or from io_cancel_local_task_work()
> when a DEFER_TASKRUN ring is torn down.

Applied to 7.4/scsi-fixes, thanks!

-- 
Martin K. Petersen
