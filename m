Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028292;
	b=km4/uVcwHbo6RuuDycLCJQpK/c24PbrTyeB5qls6kooSYv9/5srax6h36i2fHVWJlNWe
	 I3HH9BzQiToZIl70txqEAIHCduy5RsAHcynij26R2abu2ZdbSz1rchHBCXnmmqXKGJcB7
	 +keuVooaPaFecfCEWZblhkop7u0w+PP6E1Ed+HywTWH6hsUP5mJQdvk2K92Yfn839CDSt
	 UeUiciZbtdx0LlApQyfdRbqkxTYMeEIo9z5dTq0GE8TrR9rMUug+Q/ctn5wy9GBF+8IeH
	 bkF1z8VeQT/IpaPo7bgxS3VHHi6AgebPPRBX2a91yyFCZt7Yy79r0FrsE1qmhmEmBAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028292;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CFP3sAy+nyBx/JCNvXQvD82uO55dVEcyEylOAJhkFUQ=;
	b=z0YPbyOaxhY44KHf2t0aG32407ROnqVdOghKgaRPCcqnpsXYzEYnjMPvkeaX13rjW9Z4
	 vf+tXiH+4ICVLXmk77ZWP5IrXigllYw7VxjwT/Wc09+k2gWLd5OFDz6+tygHktpsx7dR4
	 eGNRuuAW3iPSImieIDsPHfJP0pqjvySPiKxIQF/dc7nx+Wg7MHp0Uq0gT3LBoY1Y74F1+
	 N4/ZMlKAwKBeUdD8vjq5LaDiR2+XmLv+es1r/moM+NJODrXvzPqVrdBijCtqa2RuBNZCx
	 JzGNwyWBthGklLOVlXPJyUp/no0axTSlJr8lG4Znh0Kv7U4sUY7TFqM7w+b99JOSB/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="m9gptB/6";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D323606A31A;
	Mon, 26 Oct 2026 15:24:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D323606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=m9gptB/6
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jCy9961P3z1XM30g;
	Mon, 26 Oct 2026 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793028281; x=1795620282; bh=CFP3sAy+nyBx/JCNvXQvD82u
	O55dVEcyEylOAJhkFUQ=; b=m9gptB/6ZJoufpbC75B5v0XGKWgjTVCwAMKvR5it
	dD+d5WQeQKGLwWGSZZfHWiwJTYMtopeB5nRTc6t7Y31fTOBnHsa8YeHh0+BC5hxb
	ZN8YmyETGjUaKI0j2F6jXGJk0YK6yOLnfNaEwfVi2foMcn5lw23n0B/c39n/hXm0
	KaaKhMLoLwow8GRKnuZZBtkLWSL5alEcBJGZxaa1BISeYnboSbxHcW4oiFBBIwwF
	9YEC0/MmFiy+UbEsMcw2oGyEoarGc1sdF/tG3Kp6+CPB1hJVnpZMWlW9xxMjSA6+
	wX2UT738kz2HUfaohGI4wmRrxi9OjGbhMLyTOa9/zLN0Ww==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rBkXgnKsa6kC; Mon, 26 Oct 2026 15:24:41 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jCy9533PSz1XM4Tl;
	Mon, 26 Oct 2026 15:24:41 +0000 (UTC)
Message-ID: <79480408-8403-4a93-a2dc-c5f01864a20c@acm.org>
Date: Mon, 26 Oct 2026 08:24:40 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] scsi: target: iscsi: fix stalled and doubly
 completed aborted WRITEs
To: Laurence Oberman <loberman@redhat.com>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
References: <20261026150710.1063511-1-loberman@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261026150710.1063511-1-loberman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 8:07 AM, Laurence Oberman wrote:
 > On moving the one-shot guard into target core:
 >
 > This will be explored later on but is not in scope for this series; it
 > changes the path every fabric completes through and I have no way to test
 > easily in iSER, FC or SRP right now.

I don't think that argument holds. Fabric drivers that complete an
aborted command exactly once never trigger a one-shot guard in
target_cmd_interrupted(), so their behavior wouldn't change. The guard
can be a new transport_state bit that is tested and set under
t_state_lock, and the CMD_T_ABORTED test can be moved under that lock
too. Today target_cmd_interrupted() reads transport_state without
holding any lock. That would:
- make the iSCSI-private completion_claimed member and both new helpers
   unnecessary;
- close the race that patch 3 only narrows (CMD_T_ABORTED being set
   between the iSCSI test and target_cmd_interrupted());
- also cover the sites this series doesn't touch, e.g. the deferred
   ICF_OOO_CMDSN path where iscsit_execute_ooo_cmdsns() ends up calling
   target_execute_cmd() for an aborted command without taking the claim.

Please consider doing this instead of adding iSCSI-specific
bookkeeping. If the iSCSI-only approach is kept for stable, please
explain in the cover letter why the core approach isn't suitable.

Patch 1/3:

 > Fixes: aaa00cc93c1d ("scsi: target/core: Fix TAS handling for aborted 
commands")

transport_check_aborted_status() only sent the TASK ABORTED status. It
didn't drop the reference that the abort path now waits on. Nothing
waited in target_put_cmd_and_wait() until commit 2c9fa49e100f
("scsi: target/core: Make ABORT and LUN RESET handling synchronous").
I think that's the commit this patch fixes, or at least it should be
mentioned too. Both commits went into v5.0, so stable coverage doesn't
change.

 > +bool iscsit_claim_completion_locked(struct iscsit_cmd *cmd)
 > +{
 > +	lockdep_assert_held(&cmd->se_cmd.t_state_lock);

Please also add __must_hold(&cmd->se_cmd.t_state_lock) to the
declaration so that Clang's context analysis can check this at compile
time.

 > +/* Complete an aborted command at most once.  Must not hold 
t_state_lock. */
 > +void iscsit_complete_aborted_cmd(struct iscsit_cmd *cmd)

Please change that comment into a __must_not_hold() annotation.

 > +	spin_lock_irqsave(&se_cmd->t_state_lock, flags);

All callers run in process context with interrupts enabled, and
iscsit_release_commands_from_conn() uses spin_lock_irq() on the same
lock. spin_lock_irq() is enough here.

 > +	bool			completion_claimed;

Please add __guarded_by(&se_cmd.t_state_lock) instead of just stating
in a comment which lock protects this member.

Patch 2/3: looks fine to me, assuming the series stays as it is.

Patch 3/3: as explained above, this patch narrows the race but doesn't
close it, and the ooo_cmdsn branch right above the new code still
defers to a path that doesn't take the claim. I'd rather see this
solved in target_cmd_interrupted() than merge a partial fix that will
be replaced later anyway.

Thanks,

Bart.
