Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD7B18EB8;
	Sat, 15 Jun 2024 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718442306; cv=none; b=YqTll68y4gqJIBPfeiUEISQyIGwxthbOYVe28TdLdJigWZFAJE/Rtdx4QjzLh2K77qBLjzIgSzPJrrTI5w+twdEdpIe8rSNvOizjNRJb3xBUgXolWY9OF93xLwchai616P8m7PO5/Gi2RQoClZGqFwfd0ILy2W6ferc1o5LzJxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718442306; c=relaxed/simple;
	bh=pxpXqmmliP4LalNMkLJz6hme/jP5SrGxkfi2YKYM7TY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kFHvUl7y6KVYvDasf87StD1CS7iZ5GyVwzWeaGxAB+g6fVaZVY+6CKblphUtmdpX0GUK2eySLsaSfDztIhvmMpxRiWUDAsJQbNhS285A5oAYC+nDKJWXsMKzUr4XFdRiR5FOhev3ux8hEjop77cwHYpxJtdcGWxQW6p3o9cXl9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=166aHrMj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O76hlFn2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=166aHrMj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=O76hlFn2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="166aHrMj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O76hlFn2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="166aHrMj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="O76hlFn2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DA6E5227AB;
	Sat, 15 Jun 2024 09:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718442302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+yRbirosZx0eRGmUHYdSg53Kwkh7wZQY5A4JvRNiGQ=;
	b=166aHrMjoJxZwC2kspnXQgw0J0g+IuGcL1dI/WEzIpWS2b//9bPypD86GwFd8MJ181v3L7
	uklPY3bmVr7M/P0zllbgiCt+lhSRmlQICEkVLrk/0Qs7FSEVJS0riJrig4odGLolMHU/ik
	cb2iEMsg4S97o5MTQwtl57CCZfw4dcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718442302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+yRbirosZx0eRGmUHYdSg53Kwkh7wZQY5A4JvRNiGQ=;
	b=O76hlFn2sVXjPaVn9Pj+r2xt9/nkAPucEU6LE7vlcpv93CCPuL4YB+ejcNfAVpzImOSF+s
	429lYrzJnmH9IWCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718442302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+yRbirosZx0eRGmUHYdSg53Kwkh7wZQY5A4JvRNiGQ=;
	b=166aHrMjoJxZwC2kspnXQgw0J0g+IuGcL1dI/WEzIpWS2b//9bPypD86GwFd8MJ181v3L7
	uklPY3bmVr7M/P0zllbgiCt+lhSRmlQICEkVLrk/0Qs7FSEVJS0riJrig4odGLolMHU/ik
	cb2iEMsg4S97o5MTQwtl57CCZfw4dcA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718442302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+yRbirosZx0eRGmUHYdSg53Kwkh7wZQY5A4JvRNiGQ=;
	b=O76hlFn2sVXjPaVn9Pj+r2xt9/nkAPucEU6LE7vlcpv93CCPuL4YB+ejcNfAVpzImOSF+s
	429lYrzJnmH9IWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CA0713A7F;
	Sat, 15 Jun 2024 09:05:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wS+aEj1ZbWa9YgAAD6G6ig
	(envelope-from <hare@suse.de>); Sat, 15 Jun 2024 09:05:01 +0000
Message-ID: <4818863e-8ad2-4aa7-bed1-103d2801faa6@suse.de>
Date: Sat, 15 Jun 2024 11:05:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] scsi: fnic: Add and integrate support for FIP
Content-Language: en-US
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
 "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
Cc: "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
 "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
 "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
 "Masa Kai (mkai2)" <mkai2@cisco.com>,
 "Satish Kharat (satishkh)" <satishkh@cisco.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240610215100.673158-1-kartilak@cisco.com>
 <20240610215100.673158-8-kartilak@cisco.com>
 <43b8bd73-efca-45b0-9526-3c19c8cb3713@suse.de>
 <SJ0PR11MB5896B7E6DCABDE98D4ADBFA1C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <SJ0PR11MB5896B7E6DCABDE98D4ADBFA1C3C32@SJ0PR11MB5896.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On 6/15/24 05:44, Karan Tilak Kumar (kartilak) wrote:
> On Tuesday, June 11, 2024 11:48 PM, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 6/10/24 23:50, Karan Tilak Kumar wrote:
>>> Add and integrate support for FCoE Initialization
>>> (protocol) FIP. This protocol will be exercised on Cisco UCS rack
>>> servers.
>>> Add support to specifically print FIP related debug messages.
>>> Replace existing definitions to handle new data structures.
>>> Clean up old and obsolete definitions.
>>>
>> Aren't you getting a bit overboard here?
>>
>> I am _positive_ that the original fnic driver _did_ do FIP.
>> What happened to that?
>> Why can't you just use that implementation?
>>
>> And if you can't use that implementation, shouldn't this rather be a new driver instead of replacing
>> most if not all functionality of the original fnic driver?
> 
> Thanks for your review comments, Hannes.
> As you can see from this patch, and some of the later patches, fnic driver would be reliant on FDLS.
> FDLS helps solve some of the issues that we have seen in our hardware where:
> 
> 1) the adapter hangs such that FC offload is impacted,
> 2) the fabric gets into a blackhole situation, where nothing comes out of the fabric.
> 
> These situations get easily escalated and are quite hard to diagnose.
> FDLS has helped us in these instances to chart a way forward, and to solve the issue.
> 
> Cisco has been shipping async fnic driver based on FDLS for the past six years.
> Cisco officially supports the async driver.
> The async driver has support for PC-RSCN (seen in a later patch) and NVME initiators.
> Since the async driver has been in the field for quite a while now, it is a well-seasoned driver.
> It has also gone through lots of QA cycles to reach a level of stability today.
> Therefore, the Cisco team feels comfortable in upstreaming this change.
> 
> Keeping in line with the upstreaming best practices, our preferred line of approach is to modify
> the existing driver with this change.
> I assume that there will be challenges in maintaining two separate upstream drivers and hence the
> current approach.
> However, we want to be mindful of your comments.
> If you believe that a new driver is warranted based on these changes, the Cisco team can evaluate
> that approach.
> Please share your thoughts with us.
> 
In generally, adding new functionality to an existing driver is the 
correct way to do. What I am worrying about is that we avoid code 
duplication (hence my comment for FIP handling), and that existing
functionality is not impacted.
But when adding new functionality one always has to check how much
shared functionality there is; if there is very little overlap it
would make sense to split the driver in two.
However, that is personal preference; if you think that the driver is
easier to maintain as a single driver, that's fine, too.
But your effort in upstreaming the driver is very much appreciated.
Keep up the good work.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

