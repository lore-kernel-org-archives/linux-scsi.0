Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793621179;
	b=ne5t+iZsf08KAaijEtLXccevm79zhu+hxzCvVeC9ay9DqsPoa8RdCIa9/hg9hlXv5bWp
	 2+WJw1GzrEvw1TZK/xDIxk8TgiJ6zUvfQATKBBUM6t4Uar12ntMuEs3nLSvfNO+uJQZ3M
	 gfowrGfVYetx2m9BOmdv6DvUndDX/MIIe/mIujfsbtG4SxMdDdYiLrvek78P0Jc9NKoe4
	 5cBBgsk/q5K+F+8cs997YvWvBVjUwXU0GR5NUyD2wBtI0IGeY5m/o8uiNv9zMxS+PAuox
	 VR8suWd/v1S6aGjR2UkW+3nMmEd36wePceiTFfOF+1YIMWlw4tbDAktf7uyPYRy6isA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621179;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=JHEhxfLaPmXxjNS+ukaQsatORN659ol3TwCtCyeDnas=;
	b=eWBObT2yeHvyJHv6RQv/ZCzUYmvBUo6gI1jiOSb/UhSzX/YJ2kiuYgRMhpwkucKnFc5i
	 Af6FY6KbhizDZAMnnAbQMQZRaat2zgUgq9AhaIjcfcBIJkDaY4mGpDydrkDrk2b6J6RPy
	 CiNawC/M71mMJDg/Fw0PviuURS4sGDE6tq1iessndAEY01kg4C+d4acu+IbytLpgNa22d
	 GFpmu4zSrsaPi9VJ4Gl5W8CU/32l1nIhomYvNemdF/inUTIelUUqKX6heQ2nj0/t/9Vh4
	 SFQ1PFn9eytFEirRlFRiCntDMG05xVXGcoQUimpHV2hBWGTMyjhXDGkM0KjPE/JVbeA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=xcsLg5Yc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE8F606A329
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 12:06:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AE8F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=xcsLg5Yc
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c46822eefb6so392129266b.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 04:06:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793621178; cv=none;
        d=google.com; s=arc-20260327;
        b=O+FzakG/4k0eHyOP3pyMhbqQnsh8qysBaLKXVuJ4YCCeX5LIalENKxNbZvv24EqgHu
         yP5IsooTyz3LC1RyfpLVjeeLRYK5bnfDJC3WNTT58BXn/9v93m+TOv88I4S+pjRkWKxH
         iHNx+s4MHJijEqu0hGdRLuHphco58tb2TjTmIhs2eKoAfP8XggZWz/7w9czwIecKGqyF
         jhTYiJRKKzcwWPEL0z7Ta2fO1t4se4lkM6862YnzSfSJUn6KVgM0efB7WVy5i3ca5Jpk
         B4YO+kivXukEgUJe92FkxZWnMTQ28sW9nC2sM0mXM4gNi1bvTC8LWBjmdRNRLMJixZAI
         pEVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JHEhxfLaPmXxjNS+ukaQsatORN659ol3TwCtCyeDnas=;
        fh=R6bFMZuiOm0qV89c1+cuppUks3A+o8Nu0Pbk+PIjlLc=;
        b=NSBHlnCi0EjVjrBMTmeaaprdDgNEFdboF3fn+LLzX53P/g/C0C7RRJcM8O12SfLeDF
         AlURTgCPgFVmeTuAbalNtaRLU29JOVotNbqQwHqE8taRJiSD5O2oiyAc2FsPjRSixOU3
         FZ7jec+RAuTrLnjrhR/7I8bwFwA7gGXLRUxlLVRkkKtJVcLay+cZ68xI5mZcxSSmcSvk
         w5MSSNmvxp5ry8DJsQOu74+oUGWuE/rXHk8iPNXOUKbQp1nqf4BdkAJ5wByfUQ15D1WY
         cxoR4pIF76/p6AxzGFUpGw7JvdpKHA2FmgLWS33mev5ruuPOVV7SUXphdiBdJpEgcI/Y
         vWnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793621178; x=1794225978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JHEhxfLaPmXxjNS+ukaQsatORN659ol3TwCtCyeDnas=;
        b=xcsLg5YcAkb1OQ+4J/X5IlrCrkVofx+k0Q63BRV2QtzdJsDsstolQhW8tYq+cGMn3H
         GPyZFNvW878pzH1B8wZaH2o/bShbFEkaZjRn3OSS8Q4/tY/IzTF1yzzqhugjGP3ODNin
         s4kUsKDR/y4H73QAhwClIt4WPNlwLMlluk+I3x6UbcQnDKjX/uaqsLgj9dkfxNx1iGZ1
         tDHuuq5MgdA+lCriEYfzBgQ1VDRTNyT6w64Kn+07vqYOZ3a0N+6H1rzNQAsFqiD1rgsI
         n9urbYzU7kvgaa6QWPbR6K52Fmep1848h6oo+AWxP5dlK3PR8oK4duvhGwM4MeIAcePM
         LvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621178; x=1794225978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JHEhxfLaPmXxjNS+ukaQsatORN659ol3TwCtCyeDnas=;
        b=nlbXkb9J+tJfKha2UVh8f8wVoWjUfya3ERLUFVczRP5/7QMW9JQat4hYQrWXfMHkIS
         TsPDWQEvXAELSM76sq1tS3qgbiIScXhSn9YKvSos5vkc1Nxd+NPPNW3tEnlZrFM4K/NK
         zvKQOvjmD7SJfrq4pl23NBcH+JqD2q1QnOHEjiHOlwsVvTW2jc4y51sixuJISCvM52G5
         w1MGALiSGaQwPcwyCaj+ghjU6KX0RkFEfYpUgXO7BLxbAMEWIxAQO9so6lkcHVDZNPx1
         kT3EdH1kF3ALIMievkOiBy2KZnXa8J6xKacwRlr28Qtslk/hzNp8+QQEbfLDyOj6OhOO
         9r5Q==
X-Forwarded-Encrypted: i=1; AKwUvByeE5JjTzkT7mHR6pZxl+KVUmwJAEOdOutAdzUPsWChW6QS3UQ9KDJ+KxYoUoC9k4i8ucPBDmVRuLSp@vger.kernel.org
X-Gm-Message-State: AFq9FYI4NDzFry5tzFaDTiYM4pM7bA5NNf296X40guyRaPJ7N/7TvD4D
	plBeR6v+H6IkD42qVVw/SLiooonHsdAWu1uSXaEofB/hJmLsYWdXS14PE4FnhiqPnpL5Hj+whLN
	X2iH1np9YO4Ps0OVtCF12B8M2hxNzMi3iTLDHytuhtUPTWf4e2xf7hHx6QQ==
X-Gm-Gg: AYBFou2m7wL68xnVPbngONGI77kbYMmwuZxQUT0Ak1vHlQB1y+BwVYv/SuccksqHGI7
	kl3e++btDUmKCd1/SgbdTFN6710qPnph9ST4e5tqyENP7Oi2EDxoZuOolnojLm3I/8+T2ODOtat
	ftHj6O6Yvrq1XXQtoZnE8f7z9PPY6AePNR+e6TOtJBNK8TLkDhFTSQn2pfh2EBP4iI/cJAL9vuV
	KBgEcStTFbdhfVQeuQ4VJ2Nhva5VNuIObaUPdTgNhLh257RZ92orQx5jzB9PnB48ahey912VWrn
	C85fffE0GRUI90NE8tGvE5CiJK10Le59CX+S3usEdtg80MfBjux2u4cDP3GckjK/afgZ3VAltU6
	OpRyKDR9JMci4PAOlJ6IMBs7oKb/hUQAZw279fccXcTr+sdtt3yoKiw1OVDqvHlM672BTCwJdny
	3OF+XIK4p8bFZYeVE=
X-Received: by 2002:a17:906:9f87:b0:c46:9ca9:f524 with SMTP id
 a640c23a62f3a-c4ca7a6e316mr817145766b.32.1793621177520; Mon, 02 Nov 2026
 04:06:17 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793400000.git.bvanassche@acm.org> <5c34851674a67879e175251b9bfe6ccf091e390a.1793400000.git.bvanassche@acm.org>
In-Reply-To: <5c34851674a67879e175251b9bfe6ccf091e390a.1793400000.git.bvanassche@acm.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Mon, 2 Nov 2026 16:06:00 +0400
X-Gm-Features: AclHuK9euYgbqoaS7882GWwkMIZnogwya3fXALcoP_3DC2yTP4uvKeyC-tO5YUE
Message-ID: <CAKTNdwF47-UT2ckHfyg+pQ4G371Tx0FEHAvRLZfmDoVrU+da-Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] scsi: core: Escalate persistent UNIT ATTENTION conditions
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 2:43=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> Recover from persistent UNIT ATTENTION conditions in the SCSI midlayer
> instead of maintaining a per-device quirk list for targets such as
> BIWIN BWU2A05* UFS devices that fail to clear power-on or reset UNIT
> ATTENTION on WRITE commands while clearing it on commands such as TEST
> UNIT READY, READ, and SYNCHRONIZE CACHE.
>
> If a non-removable block request that is not failfast receives the same
> UNIT ATTENTION repeatedly, retry it twice and invoke the error handler
> thereafter, instead of letting scsi_io_completion_action() retry
> uncounted until the command runtime limit is exceeded. The error
> handler clears the UNIT ATTENTION by sending TEST UNIT READY. Track
> this with a dedicated per-command counter and the additional sense code
> of the most recent UNIT ATTENTION instead of scmd->retries.
> scmd->retries is also incremented for other retry reasons and by the
> error handler, and a target may report multiple queued UNIT ATTENTION
> conditions with different additional sense codes. On most
> architectures the new fields occupy an existing hole in struct
> scsi_cmnd. Limit the number of error handler invocations for commands
> with unlimited retries since scsi_eh_flush_done_q() does not limit
> these.
>
> Only apply this escalation when the sense data is evaluated by
> scsi_decide_disposition() and leave the behavior of the exported
> scsi_check_sense() function unchanged. libata calls scsi_check_sense()
> from its own error handler, which translates FAILED into an ATA port
> reset and never sends TEST UNIT READY.
>
> Reported-by: Alexey Charkov <alchark@flipper.net>
> Closes: https://lore.kernel.org/linux-scsi/20261028-biwin-tua-quirk-v1-1-=
767a12c9b9cc@flipper.net/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Tested-by: Alexey Charkov <alchark@flipper.net>

Thanks a lot and best regards,
Alexey
