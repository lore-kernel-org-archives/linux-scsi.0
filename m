Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723208;
	b=UsIdkK4bR8WjZPifmjeeIKcP6tN+E+kyrOUHCeeMMbAL31GWxbq2cI62DEvBYxnU4GI+
	 kLYOYup18bANEzJoHhzaAO+y3+yWkEOqZ6z+Y41NowDPNKJTSZ0yMPhgGZ74IGk5HqfrW
	 L3VJg7P2xeOXNheEX8maZfTisZ+EHB1aanqtKVCbfEIy13vcSoD+DcMeKsus6Se3KGQQo
	 zpUPtfyw8tkHdMwITr1AoZZPYbp7p9xYbaelFCOjbU7r3laPuukaMdKTBDY74c3zqct3I
	 nwfPYgLfLoJzvCnrcT7Bmro0ktMfjCHogLmatJfrauO6MFhauYqFa3UWe3IHYyKACtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723208;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=rouW7nDm2RAxW8KJh1mBeowYSzyQJYswbOx6xzxW26I=;
	b=3qQaNbQQlxNZtbCAVNk3MVSNele6BaqeTFdFG08IQXzIqseL3GzC+fq2vpKoKllCobqw
	 H2C/3fovvFv7wNoal7UfQN7dt4i1m1SAZMsuYtcIOrBVkMt6ER6uzeToCByU1LbsnKWy/
	 CwaIQ7T3uyKTB2f1Drwe2mo3jsDhrC8MbIBhejYj4PLgYYx3USVkxtvhBnJ8g8PhRFkAS
	 IyExprczhu6VFftvn0Hk4idna1qpY3EkBTq8YEjKbrbTsH2PVMbx/i5gUmDrSsh6njPbt
	 gFY4BTexv+FfHMJHGPP0BApuvb15VmUQftdOBh4wPxVRC7457MFplKes72swNkFLgmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1NKBjawz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tvc6WHl9;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=O00ctMrb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bzygVwcx;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C9D606A327;
	Tue,  3 Nov 2026 16:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3C9D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1NKBjawz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tvc6WHl9;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=O00ctMrb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bzygVwcx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 40BCA1F7B6;
	Tue,  3 Nov 2026 16:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793723206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rouW7nDm2RAxW8KJh1mBeowYSzyQJYswbOx6xzxW26I=;
	b=1NKBjawzsf9PETfHWSEvBLYRuL0k+NovLQqKA8iTIZdCWIMPCBXAQoeRxE0cod9VblD8J8
	OcyhSACe2WcGVnVoTCDcNPVMLrooiEbrcOulaAnXciCKLL/VdR2SPxOjvCGGw88ONe8zXt
	GWwFWc91F9twexc0WLuvPwxfFnQ60cs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793723206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rouW7nDm2RAxW8KJh1mBeowYSzyQJYswbOx6xzxW26I=;
	b=tvc6WHl96AxZeSxWXyQNtJW597ZfDoqrl3dB7e6bWNPUO9hw0v5vjC/QsTsQjLUjDzgpxG
	xxxXaEx69ARebNAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O00ctMrb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bzygVwcx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793723205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rouW7nDm2RAxW8KJh1mBeowYSzyQJYswbOx6xzxW26I=;
	b=O00ctMrbIa/ZUYnmI0ZDEBP/Z6ySkVq4ePuJGqBwj8oHyUkjip+EovTfhuDTbm9ArPFRHK
	/BonMrU+nV2Kl2Qns8rFi76ncxwvOYCotIT4JaketV/PeMMiaOswJH7WpsQq6sCzv53BgK
	N7/Cs2Pkuqzy5VAs5cQ+ZUnsmP3bM4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793723205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rouW7nDm2RAxW8KJh1mBeowYSzyQJYswbOx6xzxW26I=;
	b=bzygVwcx/B7vQu6/HShqQgImb/hL7D1OMGKETyqXcdGIuUCOmttBzhwb6QjJmkP7KY3eiQ
	XBaSIrgHihlB83AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD09C134B8;
	Tue,  3 Nov 2026 16:26:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cm5NIkQL6mpNfgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 03 Nov 2026 16:26:44 +0000
Message-ID: <bdef8300-8570-4103-8c8b-cb978c88eb81@suse.de>
Date: Tue, 3 Nov 2026 17:26:44 +0100
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, mst@redhat.com,
 jasowangio@gmail.com, mkp@kernel.org, James.Bottomley@hansenpartnership.com,
 pbonzini@redhat.com, eperezma@redhat.com, virtualization@lists.linux.dev,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 sashiko-bot@kernel.org, kwolf@redhat.com
References: <20260911164417.33860-1-ngocthang2710.1999@gmail.com>
 <28865bba-ac60-4c6e-aec8-64b1fcdb1c8f@suse.de>
 <20260914133144.15509-1-ngocthang2710.1999@gmail.com>
 <20261102200615.GC1738758@shajnocz.csb>
 <c5460180-e134-423a-b67f-a58a00106eb8@suse.de>
 <20261103135156.GB2072598@shajnocz.csb>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261103135156.GB2072598@shajnocz.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,kernel.org,hansenpartnership.com,lists.linux.dev,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.00
X-Spam-Level: 
X-Rspamd-Queue-Id: 40BCA1F7B6

On 11/3/26 2:51 PM, Stefan Hajnoczi wrote:
> On Tue, Nov 03, 2026 at 08:27:52AM +0100, Hannes Reinecke wrote:
>> On 11/2/26 9:06 PM, Stefan Hajnoczi wrote:
>>> On Mon, Sep 14, 2026 at 08:31:44PM +0700, Nguyen Ngoc Thang wrote:
>>>> Once virtscsi_eh_timed_out() lets SCSI EH run on an unresponsive host,
>>>> abort and device reset both fail the same way (same dead ctrl vq), and
>>>> since virtio_scsi implements neither target nor bus reset, EH falls
>>>> through to scsi_eh_offline_sdevs(), which frees the stuck commands' DMA
>>>> buffers without any guarantee the device has actually stopped touching
>>>> them. If bus mastering (or whatever broke the transport) comes back
>>>> later, the device can still write into memory the kernel has already
>>>> reused.
>>>>
>>>> Add a real eh_host_reset_handler instead. virtio_reset_device() is the
>>>> guarantee scsi_eh_offline_sdevs() was missing: once it returns, the
>>>> device will not touch guest memory again, so it is safe to hand
>>>> outstanding commands' buffers back. Reuse virtscsi_remove_vqs() +
>>>> virtscsi_init() -- the exact sequence already used across
>>>> suspend/resume -- to tear the virtqueues down and rebuild them.
>>>>
>>>> Verified with a QEMU virtio-scsi repro (PCI_COMMAND_MASTER cleared
>>>> mid-write): EH now runs abort -> device reset -> host reset -> abort ->
>>>> device reset -> host reset -> offline, then dd's stuck fsync returns
>>>> EIO and D-state drains to 0, in ~244s total. No task remains
>>>> uninterruptibly blocked.
>>>
>>> By the way, there is a known limitation in the QEMU virtio-scsi
>>> implementation where some reset-related operations are implemented
>>> synchronously (can block vCPUs and QEMU activity while waiting for I/O
>>> to drain in some situations) instead of asynchronously. Recently there
>>> has been work in QEMU to make VIRTIO device reset asynchronous, for
>>> example, but it needs to be implemented on a per-device basis and
>>> virtio-scsi hasn't taken advantage of it yet.
>>>
>>> Please let me know if you'd like to discuss or contribute. It's
>>> something that is on my radar but not until 2027.
>>>
>>>>
>>>> Suggested-by: Hannes Reinecke <hare@suse.de>
>>>> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
>>>> ---
>>>> v1 -> v2: implemented eh_host_reset_handler as suggested by Hannes
>>>> Reinecke in review of the original RFC, instead of relying solely on
>>>> the EH loop falling through to offline.
>>>> ---
>>>>    drivers/scsi/virtio_scsi.c | 24 ++++++++++++++++++++++++
>>>>    1 file changed, 24 insertions(+)
>>>>
>>>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>>>> index b4f20c487718..9698f4f91cc6 100644
>>>> --- a/drivers/scsi/virtio_scsi.c
>>>> +++ b/drivers/scsi/virtio_scsi.c
>>>> @@ -833,6 +833,8 @@ static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
>>>>    	return SCSI_EH_NOT_HANDLED;
>>>>    }
>>>> +static int virtscsi_host_reset(struct scsi_cmnd *sc);
>>>> +
>>>>    static const struct scsi_host_template virtscsi_host_template = {
>>>>    	.module = THIS_MODULE,
>>>>    	.name = "Virtio SCSI HBA",
>>>> @@ -846,6 +848,7 @@ static const struct scsi_host_template virtscsi_host_template = {
>>>>    	.eh_abort_handler = virtscsi_abort,
>>>>    	.eh_device_reset_handler = virtscsi_device_reset,
>>>>    	.eh_timed_out = virtscsi_eh_timed_out,
>>>> +	.eh_host_reset_handler = virtscsi_host_reset,
>>>>    	.sdev_init = virtscsi_device_alloc,
>>>>    	.dma_boundary = UINT_MAX,
>>>> @@ -947,6 +950,27 @@ static int virtscsi_init(struct virtio_device *vdev,
>>>>    	return err;
>>>>    }
>>>> +/*
>>>> + * No bus/target reset in virtio-scsi, so EH lands here after device
>>>
>>> The choice to use the VIRTIO device reset in virtscsi_host_reset() looks
>>> good to me, but I would like clarification on this comment. virtio-scsi
>>> does have I_T_NEXUS_RESET and I believe this is the modern equivalent to
>>> the pre-SCSI-6 TARGET RESET. Is it really the case that virtio-scsi
>>> doesn't have target reset? And do you want to go ahead and implement
>>> .eh_target_reset_handler() using I_T_NEXUS_RESET?
>>>
>> Would probably not a bad idea to use I_T_NEXUS_RESET here.
>> Not sure what it does internally, though; _is_ there a nexus
>> to reset?
> 
> Whether there is any benefit to I_T_NEXUS_RESET may depend on the device
> implementation. In QEMU:
> - LOGICAL_UNIT_RESET resets just 1 LUN
> - I_T_NEXUS_RESET resets all LUNs
> - VIRTIO device reset also resets the HBA itself
> 
> In practice QEMU's I_T_NEXUS_RESET is unlikely to fix things if
> LOGICAL_UNIT_RESET wasn't sufficient. Maybe it will help on other device
> implementations though.
> 
> I think the Linux driver mapping should be:
> - .eh_device_reset_handler() -> LOGICAL_UNIT_RESET
> - .eh_target_reset_handler() -> I_T_NEXUS_RESET
> - .eh_host_reset_handler() -> VIRTIO device reset
> 
I guess 'target_reset' is pretty much pointless for modern setups.
If lun reset doesn't work it's pretty much guaranteed that target_reset
won't help, either.
(Unless you are on SAS, then it might, as I_T nexus reset actually
resets the SAS link and such does something useful).
Problem is that in most cases LUN reset fails as the _communication_
to the LUN is interrupted, and hence sending another TMF across the
same communication channel won't help, either.
For virtio that would mean that we'd have to reset the virtio queues;
can we even do that in a meaningful fashion?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
