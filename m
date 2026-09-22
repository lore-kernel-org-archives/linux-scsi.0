Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C14442C51C;
	Tue, 22 Sep 2026 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087950; cv=none; b=PrdBHj9BOFUuos128+3EDJUUpK6ri4tpQknJ1G8xsVHPciRGRkyN0mtGg83YdLLrtmwg2eLpj3/akWDItyu2uyYMa0oZc7l/f+2pUI8QOuXVwdQFaKPlDhUIPFISnZ0pMfJ75JF4mdZgAwwzD2id/pUKEy8gvlqmJbSG5X3OtXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087950; c=relaxed/simple;
	bh=af2yWMM4LUFbtaoAA+hAucg10Zu2Ry8R7kzTXbLhkpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mF/ipXt3SFRBqOoAtYTghLOgcKjCsTpgxlQGXg+C1IpuubNkI84C4I6k7hmzLgaajHdXifeJImihtLW54GRvn7tnLlKGGraO5lfCcO++xtk1MFvojJlehZNiEqxutKjvfkxJtfgeSaBmWjoZ1w9kgBKOzuCUNPxEfyl5c0bsRUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OEGQZdvL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mK8MAT01; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G3AtbyPX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=A9l0YRPF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OEGQZdvL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mK8MAT01";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G3AtbyPX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="A9l0YRPF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A6B5821AEC;
	Tue, 22 Sep 2026 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790087942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bg2sCOwKiRj33zXWVdRM/HUBz9cnyhbUaZqvwJlheOM=;
	b=OEGQZdvLA9LCZ+w4MZhztgiWM7KNUJKcKjbYtJ+u+I7Kq8eozECweucnr8cLRUVZwqgeFn
	2iWVvwtNIH950Oo6QCwy+82LuzKnZGLECyyWN7ZljYbi8OZO53bBGpmoevFgDVydStB4cW
	JDRp/PSP22i2K81d83kMXJO3tpXm+W8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790087942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bg2sCOwKiRj33zXWVdRM/HUBz9cnyhbUaZqvwJlheOM=;
	b=mK8MAT01NQpMFsyiuhnWB6BwUtyS9BUiT7xVGdTJadLEuvyhL1T9qfR5PAYsy5hszPDXJK
	X22O9yE9quE1PMAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790087938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bg2sCOwKiRj33zXWVdRM/HUBz9cnyhbUaZqvwJlheOM=;
	b=G3AtbyPXFB9a51ued4JJ1TKkqXaYAlrTWg6vczRcnVaEkb5YlgaDjLJ9/qozbJoKQTf78D
	nFRoiVYZeq/kwD1kbb/H+sYRGyDKPa8RKm/B1YDHxGeIfaUSfzB943Vxv9BFC1KOydmeVv
	uXVxzbThQbYDm6/rGc9F91uZgRzm4xk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790087938;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bg2sCOwKiRj33zXWVdRM/HUBz9cnyhbUaZqvwJlheOM=;
	b=A9l0YRPFxcBJmX2I0S+hdn0PClzmDUsRnDfMUP5zJalpsDPT8n/RdcJChCpWZ0kr1z0ysJ
	vRCCnmYWz0XE+cCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3AF89136D9;
	Tue, 22 Sep 2026 14:38:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U31aAQKTsmruQwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 22 Sep 2026 14:38:58 +0000
Message-ID: <0c396008-7e24-4980-a640-3a8582747ee1@suse.de>
Date: Tue, 22 Sep 2026 16:38:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libfc: fix directory server rport memory leak
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Robert Love <robert.w.love@intel.com>,
 James Bottomley <James.Bottomley@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260919173405.3718408-1-lgs201920130244@gmail.com>
 <4ca4f5c5-5021-4a63-bb14-4b7d0502eef6@suse.de>
 <CANUHTR-AHqeBhiuTpoVSrGjBqpWzug2JW3npaQEv7ZDZj7q9BA@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CANUHTR-AHqeBhiuTpoVSrGjBqpWzug2JW3npaQEv7ZDZj7q9BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO

On 9/22/26 10:26 AM, Guangshuo Li wrote:
> Hi Hannes,
> 
> On Mon, 21 Sept 2026 at 16:48, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 9/19/26 7:34 PM, Guangshuo Li wrote:
>>> fc_rport_recv_plogi_req() creates an rport before allocating the frame
>>> used for the PLOGI LS_ACC response.
>>>
>>> fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
>>> rport list. If fc_frame_alloc() fails while handling a PLOGI from the
>>> directory server, the function returns without starting the rport state
>>> machine or dropping the initial rport reference.
>>>
>>> Since the directory server rport is not present in the discovery list,
>>> there is no later teardown path that can find the object and release
>>> that reference. The allocated fc_rport_priv is therefore leaked.
>>>
>>> Record when the failed frame allocation leaves an unlisted directory
>>> server rport behind and drop its initial reference after releasing the
>>> rport mutex. Keep the existing lifetime unchanged for ordinary rports,
>>> which remain owned by the discovery list.
>>>
>>> The issue was identified by a static analysis tool I developed and
>>> confirmed by manual review.
>>>
>>> Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>>> ---
>>>    drivers/scsi/libfc/fc_rport.c | 7 ++++++-
>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
>>> index c25979d96808..884b233c2f72 100644
>>> --- a/drivers/scsi/libfc/fc_rport.c
>>> +++ b/drivers/scsi/libfc/fc_rport.c
>>> @@ -1848,6 +1848,7 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
>>>        struct fc_els_flogi *pl;
>>>        struct fc_seq_els_data rjt_data;
>>>        u32 sid;
>>> +     bool drop_rdata = false;
>>>
>>>        lockdep_assert_held(&lport->lp_mutex);
>>>
>>> @@ -1940,8 +1941,10 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
>>>         * Send LS_ACC.  If this fails, the originator should retry.
>>>         */
>>>        fp = fc_frame_alloc(lport, sizeof(*pl));
>>> -     if (!fp)
>>> +     if (!fp) {
>>> +             drop_rdata = sid == FC_FID_DIR_SERV;
>>>                goto out;
>>> +     }
>>>
>>>        fc_plogi_fill(lport, fp, ELS_LS_ACC);
>>>        fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
>>> @@ -1949,6 +1952,8 @@ static void fc_rport_recv_plogi_req(struct fc_lport *lport,
>>>        fc_rport_enter_prli(rdata);
>>>    out:
>>>        mutex_unlock(&rdata->rp_mutex);
>>> +     if (drop_rdata)
>>> +             kref_put(&rdata->kref, fc_rport_destroy);
>>>        fc_frame_free(rx_fp);
>>>        return;
>>>
>>
>> Wouldn't it be better to always create an rport for the directory
>> server?
>> That would make the teardown path far easier.
>>
> 
> Yes, that sounds cleaner.
> 
> I kept the current directory-server special case to minimize the change, but
> using the normal rport lifetime would avoid this extra cleanup logic.
> 
> Do you mean adding the directory-server rport to the regular rport list as
> well, so the existing teardown path can release it?
> 
Yes. We should always register with the nameserver (like 'normal' FC 
does it), and then the existing teardown path should take care of it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
