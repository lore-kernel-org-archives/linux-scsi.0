Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC64EE84E;
	Mon,  7 Sep 2026 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788848; cv=none; b=fY7eWwxFQa7adQjc+Yk++oGx8qutSWetbZ21wK1jeOergpN1YlAmnFbPJfcSPDv6qU6GpjYwW9SWj2xo+d2RS0RuBHrZt//rdLd+5WMlPNruuJEJEoJu/FFnXQ/OPUk2BeSvK99oZMxRvVXKVn0y43P60ZqzkNe8PDoeOhH8hyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788848; c=relaxed/simple;
	bh=hAl9oobrpUvaUCdoZkOGiIp4ATp088fHqtev5uTQEPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CVDKDxJgDBW0pv3z72E5kkH3mVL7KZT3yNsL8+MtKiwikACANLElKegINdLZPa+3Qp0A2BMdeu6JZ1sYaDvNR6TpFS5qiXtmKaWiBlx1u1UD4QnvQBB80un4Xc+ZbyAwHAIPFXVbRadnlGqF9dlcuE81DJfnmEJrf4d0iPrBxPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XP6ljds9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nA1JOrp+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I0NOXl9u; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d6u+dOX/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XP6ljds9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nA1JOrp+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="I0NOXl9u";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d6u+dOX/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8DDB51F796;
	Mon,  7 Sep 2026 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSdEHjF3mp4KRIuVQPm8gy/YsA/teqDLa286Z258/Jo=;
	b=XP6ljds9VA7UEVChZU4PcLNGedylvLwUVBntBY1mN4HeWlyakjKVicG/SMXyNUC6GjbHGc
	lUYIIdanOUjlwSZRf4pfq6cVDI57yQqcDTwXvrE9N+0/0fv1fiS16ArWPSlIXQbktLBaqr
	ZmS8R1QUwSfYR2NwFDo0br5Mmg41Nv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSdEHjF3mp4KRIuVQPm8gy/YsA/teqDLa286Z258/Jo=;
	b=nA1JOrp+Sb5tZ4rb61YzPEbSwfHMaiy14tJG1+JsSBVHdkTR5v4kxBKUwnQbHP4vx8CNs8
	kbSlcSiXuYmt2tDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788788830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSdEHjF3mp4KRIuVQPm8gy/YsA/teqDLa286Z258/Jo=;
	b=I0NOXl9utjIO2gtxOklBE/E6Defh1WHqH7/6uYQTdPl0D63ysVhfZPglfA8Lwm9sG9mUBc
	6LOglilB2CzF1GDFKQYhNetqc0GffAqK2AlOkp99M3CYA34KncAaRjgh7AYxqUBf8JJhEM
	5Lt7nh80ERTi84hE+nMZqImxJHKxxWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788788830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pSdEHjF3mp4KRIuVQPm8gy/YsA/teqDLa286Z258/Jo=;
	b=d6u+dOX/PbL0+j18RYETpoBzj13fgTR7FVLUxtfbAuWh+b4JzS6QPmhLNN+NuUbVocSLLs
	/LH2zWzPhbyCYrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B7D013432;
	Mon,  7 Sep 2026 13:47:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r515DV7AnmoZfQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 07 Sep 2026 13:47:10 +0000
Message-ID: <5c62db49-dd98-445a-ade1-5f547a721e1a@suse.de>
Date: Mon, 7 Sep 2026 15:47:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/40] scsi: st: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-13-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260903034201.112211-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On 9/3/26 5:41 AM, Damien Le Moal wrote:
> Refactor the SCSI tape driver to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/st.c | 35 +++++++++++++++++++----------------
>   1 file changed, 19 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
