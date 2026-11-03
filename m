Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793690883;
	b=TujPyGblvkesERM+y95oevETWZ3rW4AigJ4JRswNrrbD9hFfPh7zuISgYi8B6MBQ4O7G
	 qKKQh47etqTfCZfYVZum+FVEyhIwxfVjvA7Pcjsg7uW+E3SahLgAI6ktvfhPQPJ9s3IvK
	 +VzzDIuRa9Miyjmuu5fGTzIi51he9cGd4ZWTgc936ytQKRQjLbmeWpPlpt3xPl9S2PYXj
	 WjXhbCeKSB7iYY8zJjoLGCd8U4rcIT05BTlI6DrYxzSaZBr1Y7y/yWXaP69dGLtFgOeZS
	 yhMmqMAcBwFvNgxzyEubgpw72l0ujjiNuLs9op3pCxbZWa1k3t0w6x729Je8z3Vs7Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793690883;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=pWaY/rYsgBaeFIYf4z3GhG6EaFKHiV2sHSaImiqX9fs=;
	b=lz9Ige7dgSKA4684hB+yC1MyybJgkqoHM/E2goxeIRdRjBBk5hF/Yizq5ipr2VEu4opq
	 aV4GICAUMMzeWtbi7/srbeD5Lslkq9eF7XLiCOUg49+oNrogV4yFQa/B2b+2J2WVP8CpB
	 IdQd87y+okU+FqOCIR+st18/+UC6PE0B7e99rojnBQTeFvwo2NJ3+G4ZDxve3tGghKwaS
	 ZBPfyvjiZs4nrk7D+wY7i6C+lKtFmMv2+N2svFvw+baxye+kQfKtp/AVvZaY1GFiYqBGW
	 8fe8b8vdzsUOFtPIlfkQAcjNbha6FdHExMau8nedfZLku0WJjAVGP7FoG47Xy+5GE5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=TrQhA5fm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ku3KscF2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=s8dlFG6M;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jEa7bNLd;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94608606A32F;
	Tue,  3 Nov 2026 07:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94608606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=TrQhA5fm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Ku3KscF2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=s8dlFG6M;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jEa7bNLd
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E539921FB1;
	Tue,  3 Nov 2026 07:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793690875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWaY/rYsgBaeFIYf4z3GhG6EaFKHiV2sHSaImiqX9fs=;
	b=TrQhA5fmlx2kt2xwubOoC5NQTfypnMNM/pgCwrpQQr9qIMAV+b6j9cG8tiHzlcvCm9OyBj
	HenNnS/CWjtpXkY2POqwXP30rVYKR+gbG01g/H1ucH4Pm0KQ/p7LDYspKjrri4+FduvG93
	o9MmAYpHjd/FqbRWNNUpoydh+LkGWB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793690875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWaY/rYsgBaeFIYf4z3GhG6EaFKHiV2sHSaImiqX9fs=;
	b=Ku3KscF2UypdIV6w1fX5xDeL4cnSik1+CGpJLINKtplvXd9O/syV3+OtPvayrb0wPxpfju
	NQsUG0iT7y/0SCCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s8dlFG6M;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jEa7bNLd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793690873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWaY/rYsgBaeFIYf4z3GhG6EaFKHiV2sHSaImiqX9fs=;
	b=s8dlFG6M6g5Q+lt1wruJNEE0OjY6rFU5JUOoRYe4S4pOWaCNpA+Qr6oaLgUMeYx26MAYUN
	qvOE4qCk0lTJAoxH/fwN20NWaugPrAlN6tfKhPyhTHFmPbyOs645mjlWO/lUiRYQ5HT0hG
	Suu469lgp16I1dtRHWgvJrbn9UB3iuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793690873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWaY/rYsgBaeFIYf4z3GhG6EaFKHiV2sHSaImiqX9fs=;
	b=jEa7bNLdx6B7nfiSj3TKkmzYNm3QGHnzU3hIgpYqn/K0qgoMiv8OQf8jbfF6rMZAQ80/AD
	+vlqOewEkRQq7tBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66013134B8;
	Tue,  3 Nov 2026 07:27:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A2vADvmM6WrOSQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Nov 2026 07:27:53 +0000
Message-ID: <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
Date: Tue, 3 Nov 2026 08:27:52 +0100
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
Subject: Re: [PATCH v2] scsi: virtio_scsi: implement eh_host_reset_handler
To: Stefan Hajnoczi <stefanha@redhat.com>,
 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: mst@redhat.com, jasowangio@gmail.com, mkp@kernel.org,
 James.Bottomley@hansenpartnership.com, pbonzini@redhat.com,
 eperezma@redhat.com, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 sashiko-bot@kernel.org, kwolf@redhat.com
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
 <20261102200615.GC1738758@shajnocz.csb>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261102200615.GC1738758@shajnocz.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E539921FB1
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,kernel.org,hansenpartnership.com,lists.linux.dev,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Score: -12.00

On 11/2/26 9:06 PM, Stefan Hajnoczi wrote:
> On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
>> Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
>> abort and device reset both fail the same way (same dead ctrl vq), and
>> since virtio_scsi implements neither target nor bus reset, EH falls
>> through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
>> buffers without any guarantee the device has actually stopped touching
>> them. If bus mastering (or whatever broke the transport) comes back
>> later, the device can still write into memory the kernel has already
>> reused.
>>
>> Add a real eh_host_reset_handler instead. virtio_reset_device() is the
>> guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
>> device will not touch guest memory again, so it is safe to hand
>> outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
>> virtscsi_init() -- the exact sequence already used across
>> suspend/resume -- to tear the virtqueues down and rebuild them.
>>
>> Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
>> mid-write): EH now runs abort -> device reset -> host reset -> abort ->
>> device reset -> host reset -> offline, then dd's stuck fsync returns
>> EIO and D-state drains to 0, in ~244s total. No task remains
>> uninterruptibly blocked.
> 
> By the way, there is a known limitation in the QEMU virtio-scsi
> implementation where some reset-related operations are implemented
> synchronously (can block vCPUs and QEMU activity while waiting for I/O
> to drain in some situations) instead of asynchronously. Recently there
> has been work in QEMU to make VIRTIO device reset asynchronous, for
> example, but it needs to be implemented on a per-device basis and
> virtio-scsi hasn't taken advantage of it yet.
> 
> Please let me know if you'd like to discuss or contribute. It's
> something that is on my radar but not until 2027.
> 
>>
>> Suggested-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>> ---
>> v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
>> Reinecke in review of the original RFC, instead of relying solely on
>> the EH loop falling through to offline.
>> ---
>>   drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index b4f20c487718..9698f4f91cc6 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
>>   	return SCSI_EH_NOT_HANDLED;
>>   }
>>   
>> +static int virtscsi_host_reset(struct scsi_cmnd *sc);
>> +
>>   static const struct scsi_host_template virtscsi_host_template = {
>>   	.module = THIS_MODULE,
>>   	.name = "Virtio SCSI HBA",
>> @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
>>   	.eh_abort_handler = virtscsi_abort,
>>   	.eh_device_reset_handler = virtscsi_device_reset,
>>   	.eh_timed_out = virtscsi_eh_timed_out,
>> +	.eh_host_reset_handler = virtscsi_host_reset,
>>   	.sdev_init = virtscsi_device_alloc,
>>   
>>   	.dma_boundary = UINT_MAX,
>> @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
>>   	return err;
>>   }
>>   
>> +/*
>> + * No bus/target reset in virtio-scsi, so EH lands here after device
> 
> The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
> good to me, but I would like clarification on this comment. virtio-scsi
> does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
> the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
> doesn't have target reset? And do you want to go ahead and implement
> .eh_target_reset_handler() using I_T_NEXUS_RESET?
> 
Would probably not a bad idea to use I_T_NEXUS_RESET here.
Not sure what it does internally, though; _is_ there a nexus
to reset?

>> + * reset also times out. A virtio reset guarantees the device won't
>> + * touch guest memory again, so stuck commands can be freed safely.
>> + * Same teardown/rebuild already used for suspend/resume.
>> + */
>> +static int virtscsi_host_reset(struct scsi_cmnd *sc)
>> +{
>> +	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
>> +	struct virtio_device *vdev = vscsi->vdev;
>> +
>> +	scmd_printk(KERN_INFO, sc, "host reset\n");
>> +
>> +	virtscsi_remove_vqs(vdev);
> 
> This is synchronous and may take a long time. I noticed that some SCSI
> drivers have a timeout that returns FAILED when the low-level host reset
> operation takes too long. This can be done here too but would require
> adding a timeout to virtio_reset_device() (i.e. see the virtio-pci
> implementation that loops until the device register indicates reset is
> complete).
> 
Never, ever, return FAILED from a host reset.
That will induce a non-recoverable error, and you have to reset the
OS to get the virtio devices back.
Not something you'd want to do I guess.

Yes, I know that host reset can take a long time. But normally
host reset would be the last resort, so really when you have to
call it your system has exhausted all other options.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
