Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795524488;
	b=EX18XxcFdOLN+mfYbccI+33KGV0VRhl5XKZmDxkczG6VzwQ9SU+ZE2ZaHqdAYGWnQVlm
	 AMbGgntnts83mMw2C58Vyd6/7CqvIXce6h5Wwblryl+4oJrK/F51bM2PIFl1gRK64FOxD
	 aknyPC7d5H8NKDMyBvxxKLdCZPvdqm4XXhpe5yExHbYW6mFGbKQqcGXCZinUAElS9t1Vo
	 UlSUX1lrqSjFVl9edomVop4OY5xOrPh1y9P8I6aDT0Z54aM7MH0eyMO58dd5n9GhVgZzk
	 QoFxmVGkMOAGixKDsauErEZNui4Url9H0lL0m+xQDs1DtlKwohYGibWIrYcJINoICbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524488;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HjxIqXJuwDIHgycP8pMxDoncP5M0KhqavR/YXAqM1LY=;
	b=4FRCT+y+CAv4EhyNLmiiqHeRbOKJ4NISsO0HYY7tX22iFJfVmUyrgnNBCl3atTwBxDGV
	 eD2WPmvMYQ5J3vLDfF5wbxE0tT4I6gMUZWJFhdG1lzEQfGvKwhBkgdWetbR7IZw8zl4ON
	 R4ERdAIeYXEMCKUQ1dB5imCOStm4us1exS3oFOr4wGCow3eYbx4qA/i5buhms4pEbYHbR
	 g3of3X1JrXu01fQogen7hZUgD0EhgU/ai3EwYV7oLHD0tTV1GvAflsBayGfyUjY8Byp8r
	 G4EnYhj6U+g1hObsBt3rz+GIUzFlgYlYkhhIsWbP67n6fneSO+pBi+QoeT4QX1pGPbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Mw/z1tT1";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B077606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 12:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B077606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mw/z1tT1
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so39049975e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 04:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795524486; x=1796129286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HjxIqXJuwDIHgycP8pMxDoncP5M0KhqavR/YXAqM1LY=;
        b=Mw/z1tT1w46FW0lrD03RAe/r0UUT5HdnLknf1I4u4jWPwOmhupH7a9ZhU1daktHX/G
         BTqU7v2bobDzxibgaVEQZbatRiJGxMoMcNjh/U8Uzsm6lFsXZvv48DlhIObCvsZn5jE6
         GJ1C18SReJ8Yoi8KF8PJPnLHrisIYGeS1JlAdozhA9bqmsjAqvK89onVuscXfM9RE+cL
         paigCm8TgeXMEyNu/VRj2u57/eMjUbTQJrvpAvq//u/NzcgH/WUUz2I2pPXvwaqgQktk
         k4eJcpR0gDS3/5F/6y7uL9G7kTjVdFMWHQK/W2DBmFgqDmL78V3DE5Idu0Vsxjn2EpdB
         DvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795524486; x=1796129286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HjxIqXJuwDIHgycP8pMxDoncP5M0KhqavR/YXAqM1LY=;
        b=LVGnCELBQJJeNG+zs64rtgGY+kYwlKAjP/MRtUv5mB090WPOkDm6Sfs+3PLrdNhIfD
         fvbTeqWgD6C6ZLXk8hqt5TDib9BZmk99+wO5asVsZOKRGU+Z3d/6bPLSU1J5I8YHgQ4B
         pzYaVtscqDsTBUeITWBAJ1xEeEW6vXLh0jdQuirGWXZA40qnPUHM1/7gdeyKxFvNXqoF
         sLNdLoW1L6qC6YaBCk7G/hnbUDf+XujF67RW4Zx3n9Lu/5ava2Pro5neTh0gAp6ayX9T
         bH4Io5ZkQboiv/n+u3RE4dDd7V3nmsGMXl5yLB+scG+o9cvNhFJCASNfnTX5BcHhxqpl
         xZRg==
X-Gm-Message-State: APuU4Z9I8q8L6GzpKvE9kB/Rwz593oBXpFULBemQ0GUUkByO1TPHXI56
	LHDQdrR/B2/u28Qb0hLBlxUUvuB9sOiFyfMnCfDeCXdoGOnAdsyHHfNHoAzH8VWW
X-Gm-Gg: AZFdTZfUpQ6Y21Z91YM8X9C96hbwQ2k113rwtz2CjevgiaJnWy25FPj7s1SZhz63cmq
	YNfSMp6UDSdvRYFdy5MqQQNbk4RIv8xDVHHs27fb5IysSgntcnkOH5mHwmDv2d1ewHTOgELGN0Y
	8rBenV3YYNimXGl/e2vrkwF50Eu8iEzOR8wJ5Oxi6pgb9/kkGgA0U/HnqBvmdbs74wc9w8+sYG1
	pJcZTPASJANYbMGENl05V28s5NJGihQJMA5/+gtx2e7DB7wMAEGRgWuLA1NmK32xY/84kT18fc0
	9tqEPExpQl5dhZUYdEfD1y7mWOku4h0ID+aEYt/Me0cf0WUnMzz9P34rTzDIteQ0VWfv3F80Ngq
	gRDtfIhJ1aSC7GgOg1yNW3lGPicUevrTprDtuk8f5kv1Oah52Wz0g5f4DmIngcfzT3dOOI66d1f
	meh9DzOrWdkVAHT01H8+WgK8/F6bN47mdlYPMUjXrLN8bgoaaAt3nUGxFIjMHKuqzu67gZotkw6
	wE5Y0wk9o3W+Vwe3RP4IlE/VOWFn2JbDpf2PW2/g/p/t9GUHFK44+bm28koXUxNUMhWHN0+zFeV
	GIjZi2kTtNIpcQc28kEQnx+j1QwEXkGKl09MwH7J
X-Received: by 2002:a05:600c:64c7:b0:4bb:872a:f500 with SMTP id 5b1f17b1804b1-4bb887c2697mr314184245e9.3.1795524486402;
        Tue, 24 Nov 2026 04:48:06 -0800 (PST)
Received: from localhost.localdomain ([91.223.207.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90655f5asm251567345e9.1.2026.11.24.04.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:48:05 -0800 (PST)
From: Benjamin Saiz <benj.saiz@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	Sagar.Biradar@microchip.com,
	bvanassche@acm.org,
	thenzl@redhat.com,
	aacraid@microsemi.com,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH RFC] scsi: aacraid: free aborted management FIBs on late completion
Date: Tue, 24 Nov 2026 12:47:58 +0000
Message-Id: <20261124124758.3485-1-benj.saiz@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <sashiko-outbox-231035@kernel.org>
References: <sashiko-outbox-231035@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review. Both findings are correct, so please do not
apply this RFC as is.

Before a v2, I would like to agree on the direction, because the fix
touches the ownership of abandoned FIBs in several callers and I can
only test one of them. The question is at the end; the findings
behind it come first.

I had the RFC and the surrounding code reviewed again, and checked
each item below against the v7.4-rc4 sources (file:line refer to
drivers/scsi/aacraid/ in v7.4-rc4).

Made worse by the RFC on controllers handled by aac_intr_normal()
(a second free, or a write to a FIB the interrupt handler may already
have freed and handed out again):

 1. aac_hba_send(): done = 2 is written outside event_lock
    (commsup.c:761-762), and done is never reset before delivery
    (only aac_fib_send() does it, commsup.c:561). This is the pattern
    commit cacb6dc3d7fe ("[SCSI] aacraid: fix File System going into
    read-only mode") removed from aac_fib_send(); commit 423400e64d37
    ("scsi: aacraid: Include HBA direct interface") reintroduced it.
    Dan Carpenter flagged this block in 2017:
    https://lore.kernel.org/all/20170213184101.GA4762@mwanda/
    Without the RFC, a stale done == 1 already leaks the FIB when the
    reply arrives before the unlocked write, as the review notes.

 2. aac_send_safw_bmic_cmd(): completes and frees the FIB
    unconditionally after -ERESTARTSYS (aachba.c:1736-1753). This was
    harmless while done == 2 turned both calls into no-ops. Commit
    8fb391827f57 ("scsi: aacraid: Create bmic submission function
    from bmic identify") added the -ERESTARTSYS to -ERESTART
    conversion, and commit 5480aa18375e ("scsi: aacraid: Change phy
    luns function to use common bmic function") dropped the
    -ERESTARTSYS check its old caller had.

 3. ioctl_send_fib() with a replaced hw_fib (size > max_fib_size):
    on -ERESTARTSYS the cleanup frees the coherent buffer and restores
    hw_fib_va/hw_fib_pa (commctrl.c:80-102 and 146-155). With the RFC
    that FIB may already be back on the free list.

 4. aac_get_adapter_info(): if both DMA mask settings fail, rcode =
    -ENOMEM overwrites the -ERESTARTSYS of GetBusInfo before the final
    cleanup, which then frees the FIB (aachba.c:2238-2248, 2306-2312).
    This needs both dma_set_mask() calls to fail, so it is unlikely.

Controllers whose replies go through aac_response_normal() (rx.c,
sa.c) already free abandoned FIBs unconditionally today
(dpcsup.c:126-132), so items 3 and 4 already apply there.

Pre-existing, independent of the RFC:

 5. fibptr->event_wait is initialised once (commsup.c:169) and never
    re-initialised. If the reply posts complete() while the waiter is
    leaving on a signal (done already 1), that completion is never
    consumed and may wake the next user of the FIB early. The same
    applies to the polled and sync_mode paths.

 6. Block layer tagged FIBs reach aac_fib_free() on error paths (for
    example aachba.c:2490-2507, 2598-2599, 2686-2687, and
    dpcsup.c:346-349), so the management free list does not only hold
    the 8 pool FIBs. My changelog was wrong on that point, and also
    in saying that cacb6dc3d7fe introduced done = 2: it moved the
    abort marking under event_lock.

 7. Buffers released while the controller may still use them: the
    BMIC buffer (dma_unmap_single(), aachba.c:1749, then freed by the
    callers), the wellness buffer (dma_free_coherent() right after
    the send, commsup.c:2207), and the replaced ioctl hw_fib (item 3).
    Raw SRB instead strands its SG buffers and leaves its DMA mappings
    unmapped (bugzilla 220504).

 8. Polled sends (wait < 0) that time out or see the adapter offline
    (commsup.c:640-662), and sync_mode on a signal
    (commsup.c:604-610), return after delivery without marking the
    FIB as abandoned, and their callers free it.

I see two directions:

 (a) An explicit, scoped ownership handover, for controllers handled
     by aac_intr_normal(). ioctl_send_fib(), on its plain path only
     (no replaced hw_fib), marks the FIB before delivery as handed
     over on abort, in a dedicated field rather than in fib->flags,
     which is updated outside the lock. aac_fib_alloc() clears the
     mark, and so does aac_fib_alloc_tag(), since tagged FIBs reach
     the free list (item 6). On a late reply, aac_intr_normal()
     decides under event_lock whether done == 2 and the FIB is
     marked, then completes and frees it once. The completion is
     re-initialised before each synchronous send. This fixes the leak
     I observed (plain FSACTL_SEND_FIB on a Series 6). Every other
     path keeps its current behaviour on these controllers: it leaks
     an abandoned FIB but never frees it twice. A FIB whose reply
     never arrives stays lost until an adapter reset, as today.

 (b) A series that first fixes each path above (aac_hba_send()
     locking and done reset; ownership in BMIC, GetBusInfo and the
     replaced ioctl hw_fib; buffer lifetime; items 5 and 8), then
     frees abandoned FIBs for every caller, in aac_intr_normal() as
     aac_response_normal() already does.

For reference, the Microchip out-of-tree driver 1.2.1-60001 frees the
FIB in both done == 2 branches of aac_intr_normal() and only returns
pool FIBs to the free list. It marks done = 2 under the lock when a
polled send times out. But it keeps the same aac_hba_send() and BMIC
patterns as mainline, and an unlocked done = 2 in aac_fib_send() too.

Testing: my only affected controller is an Adaptec 6805 in production.
I can observe the driver there with kprobes, but I cannot load a
modified driver on it. I have no hardware for the native HBA or SA
firmware paths.

Which direction would you accept? Sagar, could Microchip test the
native HBA and SA paths on Series 7/8 hardware if we go for (b)?

Unless someone prefers (b), I plan to send (a) as v2 in a week or
two, with the remaining items listed in the cover letter.

This analysis was done with the help of AI coding assistants (Claude,
and Codex for an independent review). I checked each item against the
v7.4-rc4 sources.

Benjamin
