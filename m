Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792516680;
	b=aXx4WTv+SEVKh2tEO+LdYNEbfGyDPtH7MdsS6h3VbF506fD/q1UwXd6vnoROafgCFJJq
	 p3AihD4aa4SGBZBVTCTyo8jAIjLEmEzCLKX3lqjfskH1GIQ/aFw+Num2h3ZnETJhT6qkz
	 JhtxtrTUaDrWwzU8KCbm58TOchXHIA/rUJN2o93/MZgfTUivX0J/hivgFfAfTGfqArEQQ
	 wbLYLpIQ6ZpAZLghVYvjLqTlYQafrL+/7Go6hcF0nN8c+TrT3xDPAlEIT1vlFduRniPQi
	 7OmLtPd8RqJCxVVCWOyJcgP2G2MUTNZYtphw+cBZ1rs6Su03bRkYWYZumknlPT5mWjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792516680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sYqMlvJJwtBuXijDqffBiFQ/uYlHt4eWPxa4DEKR1x0=;
	b=Jyh3kJAa6hk5nGFfr6z3ug/T7dj9yln0AzzUP1b57n4tAWY+uSQEH0h0II9dajK2EBXS
	 5pXvHaeKZQn3qwYxR8XGzFMeOJm0bjtCkSvppgAxs2BRgIJj6v7SCT3xrg7GisyaTFMNQ
	 fxYQf75DMYzrkYdOl+oYBvw9N863K2VRWLI/k2KbzBz4hVA6vipzw6If1CjG2otZ6/wU6
	 Nv7OsqZcCdMsvzKvmcDbeMdLMgYeeOPhfAhsaz/Xfr8PA5mma9hslZPpv8DsQzJMfi5Ht
	 kF/ZSaPSWs5kzDdnwPobYS7N0KHQiEbTgkG5ak9Iy+O/0fLNefb6cxV/AB7EkVsifpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=MuvYq1yC;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60D8606A32D
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 17:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A60D8606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=MuvYq1yC
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so6949610eec.0
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 10:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792516679; x=1793121479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sYqMlvJJwtBuXijDqffBiFQ/uYlHt4eWPxa4DEKR1x0=;
        b=MuvYq1yCvTotSLIrg3Qx2IFChbe0c9vehkld8n2QBfkpbt0CsNpMjhoLL1R1Eb7hlS
         uDxJfGvEj1P0ya0oLUt8t3k7qXlnmqTbqhEroqQK5GTyMF9+0wr0Qj81iQxPvrxfBr+R
         e8DzZ5J0RtwTW6HkPosCrdsq7NLAxA+kKEMSFtUYY+nsWnPUUZIfnvNHr2X5dGHqv+xu
         VRQsAHtoOC/5v1/teBjbtRdWMXrhB/trB+YzZswpRguscxUmLrt+ZnUssADQOuCd91g8
         piWQIzsXqhQlCbWBos4tHjwLzQsGtjm0Nti7TXTKFZW5ppvAVyqTefHkszlXPg+TAMT7
         XHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792516679; x=1793121479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sYqMlvJJwtBuXijDqffBiFQ/uYlHt4eWPxa4DEKR1x0=;
        b=V+GeKkv9MXB/T/G0tEtCr8hmWM9qq12YZj3v0NnRi5jxz341tvGS9HEOpllVVrFjkG
         GAbpeowKyw8+aEOs7C5rf27ms4EOFxLBdpgX93PQFsd3AMaTQGI5XiZhibr2NomKBxqJ
         qcpcKUbye6FqE5IgvPA1dPQ8TpnfgbliWgSAx9A//VDFV9+euMiALJvrsXVP6i5jnz+S
         79wIJH0IJTsHiWVABVFD47rdGGaJxKRE9aQw1v9FAJacbR6Jvbe7abuaQUgQgS0sGwbo
         NuHXUmBrWtyqAeehjsCfq3Rvh1LYEEBLo5L3kfoOw+JFE5988j6xBZ4P5vzaRZcU6jH7
         Xb4A==
X-Forwarded-Encrypted: i=1; AKwUvBx5KmXXuHTfDBXeo5o44nkn4SHDnZORurAxXhtrt2CrHnF1dKlA40aQIYNarHnyQB0VB3reNc+8pU/j@vger.kernel.org
X-Gm-Message-State: AFq9FYKek3WNaHGBI7hBKSEFA/reSCZmuoRUytCQCAZSw8Bq4kUX/bAi
	J/b41tIUVKO+GvN9DJRhNeJDeEfOlpWG2vA5BrmQqKrmG0Re1tTnrIksLELLtREpqQA=
X-Gm-Gg: AYBFou0obPJFDv8dc7BNOlK7uAS+cZ9RWJD4MmcBoy1MCBA0N5D1tA5o904Z1iGB1Uw
	rZuOPh5NQ0lDIePKm1pajATsUlvDFKc9rcI4/79bIIxGB3bBkOCwJ0k66/X6uaaasv8LKkrihE9
	36iMonKxaf9dL/L2sdy6GIaVwO5YC9TQ4ahSSTepr50xQ1BtBZO95+KmJQTzQNams4SIne38Er2
	nHbsSqT9qVTtv7A9W2GmEnf5op/qVq9blGQIftChwAS8KL7FvhM8mIgcI20dMJzpl8wr5Cqrj6Z
	UExXtGVg31/yr6O1y1/LwmG267zSVF9IsQbMg316pRTrrA8QtRpA9oFF8axq0HdjYXEhOd0pQ40
	aK1JhzIZs7bXEeP5CeZD9NUqC+7nvlcM6KYdA2dfLENV9L+6evCOYeRkEyJgUrT9LxmKVDN754Z
	FIu3pDIsag0ciM83/v0035eLEPQtYMDJLoY+kEIxuhz2bSSt/yMvIAMcAYxaneF3b5H47HiO/TC
	XWrAsbchvtp/mUGgw95DVKLHKQoSwv9F/g9y/tWB/zNt4AlMzm8MwCog7P9irQisNBAa8fVkSV6
	U+6NygPaoor5I7850gBb6+6yWwAOYLe7visz2lFlQkjKIBV2W5df9n6jGZnMiciN2K7qR37w8zE
	0
X-Received: by 2002:a05:7023:a4d:20b0:144:fb42:52 with SMTP id a92af1059eb24-18512f1ed6amr14583045c88.28.1792516678362;
        Tue, 20 Oct 2026 10:17:58 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1902f96dc4bsm156657c88.0.2026.10.20.10.17.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 10:17:57 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Tue, 20 Oct 2026 10:17:48 -0700
Message-ID: <20261020171748.7207-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <120fc95e-432a-4f05-aa87-54873363ed9f@acm.org>
References: <120fc95e-432a-4f05-aa87-54873363ed9f@acm.org>
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

On 10/19/26 3:41 PM, Bart Van Assche wrote:
> Some feedback from an experimental LLM can be found below. Please take a
> look.

Hi Bart,

Thanks for the detailed review. Before I post v9, I want to answer the
design question so that v9 isn't heading in a direction you and Martin
don't want.

> The open question: a target can now remove a disk that is bound and in
> use. [...] My suggestion is to only reprobe when no driver is bound
> (PQ 1 -> 0), but the author should say which direction the ALUA case
> actually needs.

Both directions. Let me describe the setup that motivates this, because
it isn't a short interruption.

Pure ActiveCluster is two separate arrays that present the same volume.
The volume is synchronously replicated between them, and each array
exposes it through its own front-end ports, which are in their own
target port groups. A host sees paths to both arrays as one multipath
device.

When the replication link between the arrays breaks, one array keeps
serving the volume and the other must stop, because it can no longer
mirror writes or persistent reservation changes to its peer. Its
front-end ports stay up, but its paths must not serve I/O. The array
reports those target port groups as unavailable. Unavailable is the
state we can use here, because its required command set is one we can
fully support without the link: we don't have to accept reservations
we cannot mirror. This lasts as long as the link is down, which can be
much longer than a microcode download.

> - Cite the SPC text that requires a PQ change across the ALUA
> unavailable state.

You're right that the citation in 4/5 is wrong; it should be SPC-4
5.15.2.4.5, not 5.15.2.4.4. That section says that while in the
unavailable state the device server shall support:

  a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to
     001b);

So the PQ change isn't something we chose: once the array uses
unavailable, the standard requires PQ = 001b. We set it to 1 on
entering unavailable and back to 0 when we leave it.

Why I think Linux should honor it in both directions: today the
outcome depends on when the host looked, not on what the target
reports.

  - A host that scans while the link is down sees PQ = 1 on those
    paths. scsi_bus_match() doesn't bind sd, so they are not disks.
    When the link comes back and PQ returns to 0, nothing binds sd, and
    those paths stay unusable until someone deletes and rescans the
    device. That is the bug this series started from.

  - A host that was already running keeps sd bound on the same paths
    for as long as the link is down.

Reprobing on a PQ change in either direction makes the binding follow
the PQ the target reports, which is the rule the scan path already
applies. With dm-multipath, the unavailable paths leave the map while
the link is down and come back as new paths afterwards, while the
other array's paths keep serving I/O. Without multipath, a disk whose
only path is unavailable cannot do I/O anyway, and it reappears when
PQ returns to 0.

If you or Martin would still rather not unbind a bound disk by
default, please say so now and I'll rework v9 around that.

> Offlining can't be undone: [...] I'd drop the offline step.

Agreed. Hannes, you asked in the v4 review for more than a warning when
device_reprobe() fails, which is where the SDEV_OFFLINE step came from.
But Bart is right: scsi_rescan_device() only acts on SDEV_RUNNING
devices, so an offlined device never comes back through a later
rescan, and failing to bind a ULD is not an I/O error. For v9 I plan to
just log a real reprobe failure and not treat -EPROBE_DEFER as one.
Please shout if you see that differently.

> 5/5 widens rescan behaviour a lot.

5/5 is needed for FC, but you're right that it does far too much. The
two directions reach the host differently:

  - Entering unavailable, the array reports INQUIRY DATA HAS CHANGED
    (along with the ALUA state change). sd is bound and I/O is flowing,
    so the host sees the UNIT ATTENTION on its next command, and
    scsi_evt_thread() -> scsi_rescan_device() handles it. That is 4/5.

  - Leaving unavailable, a UNIT ATTENTION alone doesn't work. With
    PQ = 1 nothing is bound to the LUN and no commands reach it, so
    nothing ever sees the UNIT ATTENTION. So the array also makes the
    host rescan, the same way it does when the first volume is mapped
    to a host.

    On iSCSI it sends an asynchronous SCSI event with REPORTED LUNS
    DATA HAS CHANGED. iscsid writes to the sysfs rescan attribute of
    every existing device on the session, which is scsi_rescan_device()
    and therefore 4/5, and then scans the host for new LUNs.

    On FC there is no equivalent, so it logs out the host's initiators.
    After the re-login, fc_scsi_scan_rport() calls
    scsi_scan_target(..., SCSI_SCAN_RESCAN), and that scan finds the
    existing scsi_device. Without 5/5 it does nothing with it, PQ = 0
    is never seen, and sd never binds.

So the scan path only has to handle LUNs that can't receive a UNIT
ATTENTION, which are the ones with no driver bound. For v9 I plan to
limit 5/5 to existing devices that are registered and have no driver
bound. A bound LUN learns about INQUIRY changes through UNIT ATTENTIONs
on its own I/O, so the scan path leaves it alone. On a normal host that
skips nearly every LUN, which removes the per-scan cost and the
scan_mutex hold time you described. It also avoids the double LUN 0
rescan, except in the rare case where LUN 0 itself has no driver bound.

For the rest, v9 will:

  - check device_is_registered() before reprobing, so a rescan before
    scsi_sysfs_add_sdev() can't reach __device_attach() with dev->p
    still NULL;
  - keep the LLD's INQUIRY length limit separate from the last response
    length, so scsi_probe_lun() behaves the same on a refresh as on the
    first probe;
  - when a refresh returns PQ 3, PQ 1 with PDT 0x1f, or a different
    vendor/model, warn and keep the existing data rather than accept
    a response that the scan path would treat differently;
  - merge 2/5 and 3/5, declare scsi_update_inquiry_data() in
    scsi_priv.h, and keep the comment explaining why a PQ = 1 device is
    still created;
  - drop cdl_supported from the INQUIRY-derived list in 1/5 and limit
    its claims to what the mutex actually protects;
  - say in the 4/5 commit message that every scsi_rescan_device()
    caller now sends an extra INQUIRY;
  - address the smaller points (0444, a shared constant instead of 256,
    the explicit first-call argument, the stale comments).

Thanks,

Brian
