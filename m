Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751691D5CC4;
	Fri, 13 Sep 2024 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726216600; cv=none; b=lzfnlJVKXI2Elay7tDZjSAqYPoMvRP3C5/01RLeU3ePCoMlynCgRou3kyXS3qCtCJ8iQLnf8MRijiVU80PknuLryhl4Qj1O/FcoTNiwyQ+FOv3p4gnbvb/wiNe8SecpGmifjO8XkCHZv/P5AvoeIO1k/Cyfr6edsjhRnWIp8ZEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726216600; c=relaxed/simple;
	bh=R58ELqG4dQhTb9hcZYONkquL3m27pEzO2iUo+HZctVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YDhyhh5r7cZYwgv8vj/BsXXl7IyjaRF8PzFz2U8ACmJLOZ2V3gvL5eeA1speuu/hEmA+F4+oHrRGUlYTKpdrmD5tcxeq2i2Ah929A3MA5eLdgGYneDDKV7VAamAGH8BWqm5xKS6jJVICm4IPYdhPvTbEPCPBHMpahh5Www79cHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LsSWGwtY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zIYQwGmY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LsSWGwtY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=zIYQwGmY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LsSWGwtY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zIYQwGmY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LsSWGwtY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zIYQwGmY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D11E1F7C3;
	Fri, 13 Sep 2024 08:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726216591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vhSCZiL+9anxD5usYK8fOJ72G/jRJ53A6YdH+smGiw=;
	b=LsSWGwtYxo7+sz0WTHBK7eeeM4yTUS7dRR+4vIwtsm+nSiMueTbZwopUwo7kxs/HSs1eFZ
	v4Bb1SldhY0ca5nRj6GY5gA0u69WZjjJ4OlOfirjYPEdqnY3zISpf8UzFEnitOw5hg8TMR
	qc2GmR4fQu26DQ+VS5T/CcUobxxosFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726216591;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vhSCZiL+9anxD5usYK8fOJ72G/jRJ53A6YdH+smGiw=;
	b=zIYQwGmYxNmqktGQ9Qnb0RfDvdJAfzxXPoXQZ1fD4rZj33+82yT17vrB8h4ujxZJq1GrIa
	PyXxglbYxYVQiDDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1726216591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vhSCZiL+9anxD5usYK8fOJ72G/jRJ53A6YdH+smGiw=;
	b=LsSWGwtYxo7+sz0WTHBK7eeeM4yTUS7dRR+4vIwtsm+nSiMueTbZwopUwo7kxs/HSs1eFZ
	v4Bb1SldhY0ca5nRj6GY5gA0u69WZjjJ4OlOfirjYPEdqnY3zISpf8UzFEnitOw5hg8TMR
	qc2GmR4fQu26DQ+VS5T/CcUobxxosFc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1726216591;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vhSCZiL+9anxD5usYK8fOJ72G/jRJ53A6YdH+smGiw=;
	b=zIYQwGmYxNmqktGQ9Qnb0RfDvdJAfzxXPoXQZ1fD4rZj33+82yT17vrB8h4ujxZJq1GrIa
	PyXxglbYxYVQiDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0417213A73;
	Fri, 13 Sep 2024 08:36:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CLoWO47542adQQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 13 Sep 2024 08:36:30 +0000
Message-ID: <a8e47dd4-26f4-49da-9ba8-aad2e8fcf9b1@suse.de>
Date: Fri, 13 Sep 2024 10:36:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/4] block: Make bdev_can_atomic_write() robust
 against mis-aligned bdev size
To: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
 sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-2-john.g.garry@oracle.com>
 <20240912131506.GA29641@lst.de>
 <0f2652ce-63e1-4399-8414-0bd150521e1b@oracle.com>
 <20240912150736.GA5534@lst.de>
 <4a015015-ae7f-4eb5-ad00-420db5961d96@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4a015015-ae7f-4eb5-ad00-420db5961d96@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 9/12/24 17:22, John Garry wrote:
> On 12/09/2024 16:07, Christoph Hellwig wrote:
>>> We should do be able to, but with this patch we cannot. However, a
>>> misaligned partition would be very much unexpected.
>> Yes, misaligned partitions is very unexpected, but with large and
>> potentially unlimited atomic boundaries I would not expect the size
>> to always be aligned.  But then again at least in NVMe atomic writes
>> don't need to match the max size anyway, so I'm not entirely sure
>> what the problem actually is.
> 
> Actually it's not an alignment issue, but a size issue.
> 
> Consider a 3.5MB partition and atomic write max is 1MB. If we tried to 
> atomic write 1MB at offset 3MB, then it would be truncated to a 0.5MB 
> write.
> 
> So maybe it is an application bug.
> 
Hmm. Why don't we reject such an I/O? We cannot guarantee an atomic 
write, so I think we should be perfectly fine to return an error to
userspace.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

