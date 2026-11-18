Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023486;
	b=V6MUq+sG1G3jDbDUpBtfBNYXz07tFulZcjqiBC8rPoxYC8dUzssvg8HwKrlYFyXeTOVI
	 osP8rkVstX4Vdhah59SpjVupls1mQyy0n7B1RSsO4n5efAUWzNsSCtIaFkpk0eXpe3/79
	 GMG++WJwxG88VYhM3wnV0nxftvWguylrlAJ61pQ3eckgd2M0MTcfxhJOE35RAVAq9cyFA
	 a5vebmv/kJOIDEs1LsptdqFLAetMJ3ILFz5QNyeyZF9M8Iq2KLIq30cHyNarx9FRj8SwM
	 HulWGgPX0FsYaDLK1em1GRoANaMjOIa9pa0pigU8SyJX26jFoaKmU15twHcrOoSaGQQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=9XinJYc23aTzc1eZ3Zb8fdPpoBmzr+cm88xaEMLHGT4=;
	b=F9hILgJ1+MYCMifbndg76LG/FDclSUxJoS9lAVtyiXBdCQpfS8txRhNL83nK3p7gXZ3Y
	 RFFOIKsZ5mcqOUbGu41ADQVSpkvQR6U++Lhsv2aKd4NUcsqxEePt6GVexaEnO3Z6/ZDzX
	 kinlHk65xyM55MA1/yfxh5AC0531tU1TbjG5q9YiZjjJGqfXtVPalJwaE5ffg0k3UvmK4
	 r4QyOo3utrX0BRIzI5H7wLCW8opuW5rrzLdk5xnAA5sOUN77tdTEQ4pw0onLb5hKqgbC+
	 G0RSPHFqS+fJEzt7Lg10f6jh1qy6oJAGCwqKngK2L9bBQTuO8S4QYQ+As+UvA6+M9PA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pPpPJsex;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9FE606A33F
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 17:38:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E9FE606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pPpPJsex
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1b546061d58so1947854c88.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 09:38:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023485; cv=none;
        d=google.com; s=arc-20260327;
        b=Yf0PzSNTPDN4e2HWavzPKVq2ao/bTaBzvDKQUMV64hyQS8NtyOFL45z15nUFPT2HkY
         gIBUJBmI/cFXro6RKYW6dkHODyzncecbixxCw8WcLpiZudx9621t0E+e4f0LdAwp3jkE
         ad2kB3JnIlU7VfHOPXyvIRcmf98JmflVHpjvMjFNePigiiSKv/itJ5FHi8mJjvwm7nXd
         hJjOcjDpr/s4ik8x15bK5VxQd2Yj9P9z+hV7fyqpoaPe565f2TWpzYdLrsqcV4SDYHn6
         Z/jYDNHtPSRar8cRkZFmWt8C0tKHcK69ZqQjW/4zp9zhW//GOBq73qdWsF/FTkkuVoDY
         MwCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9XinJYc23aTzc1eZ3Zb8fdPpoBmzr+cm88xaEMLHGT4=;
        fh=nEel/SSdhAPk9bJLUAvPo+qS/u3qpmy4rVtTTBH5OZc=;
        b=CvB8jCamHfVrXAyLGjGqrJpyDppm4CF6FHv/j1ws4kIGEmhN2u5UB+YeTV1fT7/iMw
         CPVtCyjLjGnuDnskagk1gSUnDp8BK4YuB0A55HOz3YWzxTjwQFaQk8Wk4Kr4qJBsrDT1
         6cv2wLpwf9dSJaBJqEOwCJgZnORorKrOleO+EswycWf+saFssJ9qLrlVEC6byoyI8fG5
         iJ48LHf34mxjNXgeJ+m39u0PGQfut44rlOx165NmzVBVWW48iiOc3IoZBpViVwLcQVIc
         RG1mbNFjshwP4Y2nMwzPRFxoIT/0dGdQF6cfJkcg3WVIuOlypNLs6lI2gEF+BZoDK1f1
         EfBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795023485; x=1795628285; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9XinJYc23aTzc1eZ3Zb8fdPpoBmzr+cm88xaEMLHGT4=;
        b=pPpPJsexIsntT+WjN2QIJQsnpE+HhrkkKcPtu4GiBtx5JRVlIwVRu45ltgZlrs431A
         KbqSoPYXxhivgSYfNjmizm75Z5J0kLlUrPT1arUUBNJBiYovJTzPFSvIZRf0JyZjCWhl
         BlwSPbvhgwWWwbckfttx4xA8pCb0r0Os7gWrup2/nggf0wlg3d1oWPTy3bpQfo7Lsf3h
         hp/+xV1OPzX19uh85Z2aDoMGOh+fuF1oxziyDXymvUMx9TuG3EIZtef0G1/LoBK6+qrP
         ajEqiXvxysl0h9R0suBhvWlQA6IRj7keq3zSGA7mnrrttt1lE1NWMI0yGPfB/pCU+oM5
         FUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023485; x=1795628285;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9XinJYc23aTzc1eZ3Zb8fdPpoBmzr+cm88xaEMLHGT4=;
        b=hMGBsfsHswcwcGeGgDmKTC9uIvXA00Yri5KD6Etsh8GNZwMsm8vlu1JMLOB4rFgE+O
         rsa2lBu5Og0YsvuomfOB05DOeSOg+vcxWteFZS4mQjUplCtNW3fcZ0YW4wc/lKxDtJgh
         jdxzdn25Kr2w8mP0TlOssONyGcKDgKwosaOjoyOFy4YmND86iMHf/4KWF9R+ry5R5xlQ
         nSVYsocH3p69FBjMtX97N7WUCVYtlJuC8dJn9Tt4YfTXc3w3XLUvrBr5bafWhqnPK0zu
         nYfokAAx6oy/CVIlbBPE/GKFht/Cq3a9Nfp4negWPlC201fkmWaMwuEQ/oo9aQXXxZPo
         uOfg==
X-Forwarded-Encrypted: i=1; AL+hErE83NMVQOufYMm/ypmMZW3jwUZs21l33u1Slyo28yk2kvP7yUkBqvLSINytTwFabHnb8f7ILxmnGjfQ@vger.kernel.org
X-Gm-Message-State: APuU4Z/8fbiNCTB9IvvTfe+LNb+n0AlLN198Ghp2k07qnng7Cp6AVZMA
	1ZfcQDhF+UpLaBHuv3NcY3O+bKjpavomNEcgWnpDjr1fYY1LinS8J9yOKyCNfXXbXIRX6lt1fi6
	r1BD2m0cykpCFVqYCGai0wCBXFUIgaU9h9njNwIWQ
X-Gm-Gg: AYBFou3wxOffpmk168EXBbvezthNVFSfkNzIcMmBzoH/yi9n/yLaYcVwuB+wjDhf/Kb
	EpH8dMIUbQGeGWZu/3RenIcVa51KsFEA4sd3B4+kuv8VxZdHjq0LeISbsIeL2YUY/yr3Z8T7MxF
	vffoTXwZLGHkhRnsqAYhCphn2GHhxhT4AizbRGVj2GFRdyCxGFhYWNDiRniXe01F7R0RqVXISLC
	KXAc/wGnRZ3ni9wrsp9uZ8hC+Jckl5yY4qJcMQcGktU2EFyC3qYXj0K9+l3k4XzMk68Pv/vjX1x
	WS3WL6nmsv+JulcCCdCPSd3kzqTsWT3i0Iq0rpcnJjxepIS+wX/Dewe6tI3wfQgtFTLMp734eeT
	vbkWGHYjPYJYvdFK4XNVPyxh+Y7KU10XqWhUcUwRXQ2PzU5shArJRKeabzKC0QvErDC6SgJIWkf
	AAozN10qIo3BA+OaqTCpxKXNFz8kV7oV5UL8euaib3xPJKwGtEnWwoBP4kAvJgPUnR3lVk
X-Received: by 2002:a05:701b:2511:b0:1b2:6cba:7f48 with SMTP id
 a92af1059eb24-1b543c2e6d5mr2710784c88.31.1795023484139; Wed, 18 Nov 2026
 09:38:04 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117175558.4146151-1-tadamsjr@google.com> <350d2c49-1a12-47e2-8720-8deb8e322531@acm.org>
In-Reply-To: <350d2c49-1a12-47e2-8720-8deb8e322531@acm.org>
From: TJ Adams <tadamsjr@google.com>
Date: Wed, 18 Nov 2026 09:37:51 -0800
X-Gm-Features: AclHuK_0NsTuXEEac6siFWSTVFj23klwMEJRHXzUGkWjbieisM9ywPhJLbID-UM
Message-ID: <CAL54JgevCiOLgC3XegnrMO6RT15gXqdDP+L=BzzKqt9OowDCOQ@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: pm8001: Offset hardware queue index for MSI-X pre-vector
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 17, 2026 at 11:27 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> The surrounding definitions have a tab between "#define" and the
> macro name, while this one has a space. Is this intentional?

No, this was unintentional. My editor rendered the tab as one column
after #define, so I didn't notice. I'll fix this in v3.

> A side effect of this change: completions for the highest hardware
> queue now go to outbound queue max_q_num - 1. pm80xx_chip_init()
> programs that vector as the fatal error interrupt. process_oq() reads
> MSGU_SCRATCH_PAD_1 for every interrupt on that vector, and also
> MSGU_SCRATCH_PAD_RSVD_0 if no fatal error is reported. Without this
> patch, no I/O completions go to that queue, so those MMIO reads only
> happen for fatal error interrupts. The code is still correct, and the
> driver used that queue for I/O before commit 42f22fe36d51 too, but it
> might be worth mentioning in the patch description. Alternatively, a
> follow-up patch could move the fatal error interrupt to the
> housekeeping vector.

Thanks for pointing that out! I'll just mention it in the v3 patch
description since I haven't tested moving the fatal error interrupt to
the housekeeping vector.

Thanks for the review,
TJ
