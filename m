Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848301;
	b=1K8FiKJhRNb9i1pEFYp6KvFlpx9r0PixvK043he2rzTS5N00jdTLWqPykyTNzhRa4Wfs
	 Zny5gbGAz3CsMOnqmZoi58KTb0ibZW1U5fxN1yg4T7kx0K6nb3anRlhdoN9OHA8HbKbjH
	 w3TaPfz3bgIbYHZPKTxfVV6uF9si5gpvSp+UAgPdaHfVNiEq5rSrmhYeLFKnd1kmN2acV
	 dJImhCapxvYPauG6kYWb8yV8nTNu7i4G5Nc8ADIGhNZYQ7uoRB4tJAasLUm3RuKvqF2zD
	 pSmoS0NlOKMvUar0+v6nCn88U6BSWJHOtdUWMyUwkQw3l3+1snXhva/SdaG7WXdzewA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848301;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=v1ZC4177952dmHFY2wm5BMhliYJM81FgXxiUJDLBSTU=;
	b=RFJqE9brlPnEQ0jgK4YTqwl+InQUY4LIJXD5NnJbaHkgSniGSd7uq+MZtGUKUI79cZUM
	 ULHit+GuKq++paNMghtwUeWqHZ+g/sJomdHWIaxPwpQXVNOwrDYirafmqSOfkvbtn2oKG
	 AwwPOSmfeMAji1S10oPXvGbdthOlFZEW+GQoWPiEZi15N6Nw6IjJDGKnSRQOgFjrxkob/
	 h+Heu7t4Md3FtNAuKXJJBorpbv/5R33DIwKjo3DiQB8Y5K5FUxA39yGAcBBvdBj3i9ZDO
	 opqcxTfOgRq3MoNekw/7pgwkvShMmdzcNz02MVnZbMzIS/JCbFw0lj6T0fRcZSTrBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cS6IUWLJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC14E606A88D;
	Mon, 16 Nov 2026 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cS6IUWLJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169491F000C4;
	Mon, 16 Nov 2026 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794848301;
	bh=v1ZC4177952dmHFY2wm5BMhliYJM81FgXxiUJDLBSTU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cS6IUWLJGJW9ttvChNIu/I+/2Zy7qvZLcXWboveVYFVr2BTg+4jiDDlCpMPhtybac
	 sowK9bL39zN/6D8Yd4UhOFznlYfpMKMbWfFEKyu7dHTQi3IEzELWbHbR7ApLdv/W4j
	 sNDUJwiH8qp4QRWHlGfKJlvZDvzVMIowKYd3BLdVZfe6U2eYYlZtrNxd1FlcBNSjGq
	 mki+zJipKsI31SuAjy8bISj92bqM3cI6PcaVGrh3lHkofvtfgdAm1ll2spRz6/r6RK
	 VCk+mXFZvS3pGcZmN5DWBhMqfjQSaxuULPlV0w4WjivZN0lnuiHIq+nCwMRKSPGE3f
	 AXrv52JcVylVQ==
Date: Mon, 16 Nov 2026 11:58:10 -0500
From: Steven Rostedt <rostedt@kernel.org>
To: Choi Chanwoo <cwchoi00@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Vineeth Pillai <vineeth@bitbyteword.org>,
 Peter Zijlstra <peterz@infradead.org>, Aaron Conole <aconole@redhat.com>,
 Alex Deucher <alexander.deucher@amd.com>, Alexei Starovoitov
 <ast@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Chanwoo Choi <cw00.choi@samsung.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Daniel Borkmann
 <daniel@iogearbox.net>, Danilo Krummrich <dakr@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eelco Chaudron <echaudro@redhat.com>, Eric
 Dumazet <edumazet@kernel.org>, Frederic Weisbecker <frederic@kernel.org>,
 Ilya Maximets <i.maximets@ovn.org>, Ingo Molnar <mingo@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Jiri Pirko <jiri@resnulli.us>, John Fastabend
 <john.fastabend@gmail.com>, Jon Maloy <jmaloy@redhat.com>, Koby Elbaz
 <koby.elbaz@intel.com>, Konstantin Sinyuk <konstantin.sinyuk@intel.com>,
 Kyungmin Park <kyungmin.park@samsung.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, "Martin K. Petersen" <mkp@kernel.org>, Matthew
 Brost <matthew.brost@intel.com>, Maxime Ripard <mripard@kernel.org>,
 MyungJoo Ham <myungjoo.ham@samsung.com>, Oded Gabbay <ogabbay@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Philipp Stanner <phasta@kernel.org>,
 Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>,
 Thomas Gleixner <tglx@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 tipc-discussion@lists.sourceforge.net, Tung Quang Nguyen
 <tung.quang.nguyen@est.tech>, Xin Long <lucien.xin@gmail.com>,
 x86@kernel.org, amd-gfx@lists.freedesktop.org, bpf@vger.kernel.org,
 dev@openvswitch.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH 3/9] devfreq: Use trace_call__##name() at guarded
 tracepoint call sites
Message-ID: <20261116115810.719f4e18@gandalf.local.home>
In-Reply-To: <2d8dbfaf-46d3-4d05-b052-5e8a8670931e@gmail.com>
References: <20261027153658.703730257@kernel.org>
	<20261027154413.039021489@kernel.org>
	<2d8dbfaf-46d3-4d05-b052-5e8a8670931e@gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 14 Nov 2026 23:11:05 +0900
Choi Chanwoo <cwchoi00@gmail.com> wrote:

> Applied it.

Thanks a lot!

-- Steve
