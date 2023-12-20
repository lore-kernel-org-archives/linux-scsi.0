Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C773E466;
	Wed, 20 Dec 2023 15:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k4BjIt91";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qz/+RpKV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="k4BjIt91";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qz/+RpKV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 62EC2220A2;
	Wed, 20 Dec 2023 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703084624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJLiR52BvcvBcu+7KNu8szcQ3tFu3Q6j8/rxFOU/t94=;
	b=k4BjIt91dMGqCUXdnUgbU9v4Se8mgR8EH6CysXIqHTQHdyxN2nTrqERsK+jVpMcTYvl9hs
	RyRJTuyo7xahE7bD7UdVHa/Z6ERng05LDisfxFr2xmujvB+wZU690tf21+0IhsFto+l4gG
	MrbS7H4mNYcoiVX9pU0sqyn9khMcs7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703084624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJLiR52BvcvBcu+7KNu8szcQ3tFu3Q6j8/rxFOU/t94=;
	b=Qz/+RpKVDddZZfiR1WmP96tRunhs+naG5uu1rOTw4wmXAGVjc1PhLawAyzPvoi4otkzsbH
	E2+65rcv98sayRAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703084624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJLiR52BvcvBcu+7KNu8szcQ3tFu3Q6j8/rxFOU/t94=;
	b=k4BjIt91dMGqCUXdnUgbU9v4Se8mgR8EH6CysXIqHTQHdyxN2nTrqERsK+jVpMcTYvl9hs
	RyRJTuyo7xahE7bD7UdVHa/Z6ERng05LDisfxFr2xmujvB+wZU690tf21+0IhsFto+l4gG
	MrbS7H4mNYcoiVX9pU0sqyn9khMcs7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703084624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RJLiR52BvcvBcu+7KNu8szcQ3tFu3Q6j8/rxFOU/t94=;
	b=Qz/+RpKVDddZZfiR1WmP96tRunhs+naG5uu1rOTw4wmXAGVjc1PhLawAyzPvoi4otkzsbH
	E2+65rcv98sayRAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B181136A5;
	Wed, 20 Dec 2023 15:03:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 63A/A1ACg2VDKwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 20 Dec 2023 15:03:44 +0000
Message-ID: <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
Date: Wed, 20 Dec 2023 16:03:43 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [LSF/MM/BPF TOPIC] Large block for I/O
Content-Language: en-US
To: lsf-pc@lists.linuxfoundation.org
Cc: linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Level: 
X-Spamd-Result: default: False [-2.50 / 50.00];
	 ARC_NA(0.00)[];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-2.41)[97.32%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: -2.50
X-Spam-Flag: NO

Hi all,

I would like to discuss

Large blocks for I/O

Since the presentation last year there has been quite some developments
and improvements in some areas, but at the same time a lack of progress
in other areas.
In this presentation/discussion I would like to highlight the current
state of affairs, existing pain points, and future directions of 
development.
It might be an idea to co-locate it with the MM folks as we do have
quite some overlap with page-cache improvements and hugepage handling.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

