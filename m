Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186874;
	b=o6mCrbBHt+/4jJZwXA+RIs+/XbObq0dzggde/fNflOkNnMwCnfkZycNKDhAqea7Y3n5z
	 Ib3nY25bYJhChNEovr1FQPxeGIi2/mvnGgiVRKd+0tjnIbt8IgyLFXZludIKLgVHbeJDk
	 UHUzirxpkeqw/2sLxdxLi/wCJBQ0Cv6jD8noyifXB5uCwghplN9BMFpR/0Q/5FKZksNad
	 mDIxyFgF52QvYO0mSYk3HgVCWEqQBiSvOnzRqe4f4CRUkcnaSSbrtWZK0Pb0iP9G3WGvK
	 A8KWaylXj4/vCWBhQ/SjDBvecux2o7rDTFIk2FTAbzZ8b0ZjAXzkhEE2wg0vkp+YKfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186874;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bUXTcWB2gCAchh7a7jLoo9myOcXMnzJqVzVHJAOHy7Y=;
	b=MGviF28CSDhJvXIPE5ECRJLnslepKJNtK2wF1DJYZbGfn6io1Q2OOlapPeaL81pIVIT2
	 0a7gH32MEGIdTTQpypSM7ld9yfMxcr8vyMlzsnbH1Hx1bY0BhRk3irMh4SAu3dDx28XUt
	 9VGswrXiH38Gx1kOEfvRsnwZWGj6TuuV48WG8rG7aWAsRfCHdnZYLOJkGcuwRB2/y7Akr
	 BTw0uKOtdBibhGMUJzvG9Hwc73DY7p0biQoluWYPwh2tWuWeu+aTyZ2fUe3GdKR7JpiW+
	 zTooAupARSFwgOyhNcZs7RFi+u6I8pWQaxA/cyePzjfJ9xynZziKRSSHNp8A7EnNTkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="q/876PqC";
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6880E606BC99
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6880E606BC99
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=q/876PqC
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so430326a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186874; x=1795791674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bUXTcWB2gCAchh7a7jLoo9myOcXMnzJqVzVHJAOHy7Y=;
        b=q/876PqCgLYg6tbOv1L4VfzQwB4XKk6YHc8mfdeFLsL9+h3VRZOktn7UEeU3ZaREoh
         Hb3uJN1RoTBHw/D97uK55OMHsY/wL4bSOIqZ6aELTKUAyQ7oXjzgMDILpd64vNt6iAfF
         CJNy6rNyIq1/00W1ExqDuhMNb9G0VYhEpT8S25B01H+c6csmZc5/Vt3Y+JgFGl6mP2Cu
         JE9Fw6tqlyzuNcg7MnrqfSP3vAlE2NjuANuSVpg/cMYetY5RlHzhuZhg70Rygt8FXL7I
         Hns05w27Jj8nTy7+6t2IBjjDTtmlIyixFwdjeswnu/0R5ccN5//dYv0qd9Occ673oOjZ
         KiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186874; x=1795791674;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bUXTcWB2gCAchh7a7jLoo9myOcXMnzJqVzVHJAOHy7Y=;
        b=RAArU352i8u6lsgyoa3oAu9dut7vgAAmqn4bFWHl03AMVZ9PDUoShYAKyudGp//yos
         E0CHuf3y+Rq1foRg7ZraShLcfg8N/7KDoZRoMdkDIgejr6SZ0GQz7PmOsSLCQYAQw1ei
         iLCl49/V+wfu4JWaRczJ99OnEb1fGIPDZ92aEADb0K2tZ6q9Kby0gbSXhpQCvwMBmOSv
         JkwyV5U1fEb2+YK/sg//YG6kSyppFWUb0WLJXMnFZCsnQUao6bubANLz9TxbtITT8TRM
         d4by31f01oZOapXpYK38zzc/UyjA3wvjFYfTPP9sLrke3Hci4CTpqNmIBK0sUqj0KoPD
         vCuA==
X-Forwarded-Encrypted: i=1; AL+hErG0tXY6qE5Fkjul+JnfmamtCKeDAieQc214GIhaO5K//fSAgaLdgg+yNC7NomPkAhbAH5G9DbIjsP9K@vger.kernel.org
X-Gm-Message-State: APuU4Z8VM1jAd5cZbo6iVWAS+rw378bZSncecQWbYmuw1ecNpcX7BXIv
	24LtsLtb7zZOssDtQYhPVXEemIKgMnrdhq6cPEHnZi8sXppVrEvS4vOWGnS4CXPeU0U=
X-Gm-Gg: AZFdTZeG8v4MnFKqQmYxqjYKVufoDyQLRou7G+8DHEJcJEF43tItywQJdhjw1oqVyeY
	/oeb3kGDACEKaNaXzNgo+OinvnrmbXg4iQEY1uat/uia+WWnKaiYXSU47gqgz9EtKW/SUPwiOm/
	HNGFN9YdR2BZzYAOwgXMs8krH7BwXeddMFw/Wk5mSk8QG/u+QxTd7+Q0Q+DFnVJ0Fe4+gFHOG5j
	B5Z6tWk4dF9pLDLqp6JgTGXnI8xDS9qaYqr/yYJ45wDx7krGNmtCWLyRRPnuB+DeaP8QmhG6ybU
	UK/8p3s4W5DHsDBBITX9nQQjiRN8vhpS93Ja17uiWn2ovk3pueIePznMMb83jEm9y2op1/s6+Jn
	XkHI7XFNyWFmKmTlq8FfB2A6L2FzpkCBSZ59g8QJcsOi6rdBQSFfNwRhqcgYxqOO+k1Vjd/ZA3P
	rOVLHG/v+rbBDQHdQvfLXppT74pJ83elPJXWhzlWpHwLYP4/aVx5AwFaLu5bzXbSEqeWQZeI6VW
	5nT4UEZnH4wivMM6cOkuEEQOEO1Hg4Bk7qh8riWP263dKwDf2aCiUyypoC9tOggSz2Gh5VExWOp
	6gaQ2uWWEKlyJsm4ZHuVamPy8eZqiZDSbwTufbco2t8Cv8vpI1izdLb4/akybEyKT5yikRattGQ
	aPvCXjoHM49n4QBnAAAtucjpz9Ac1aVbXaDspEjArI4QaMF6IJ2mWqffJZg==
X-Received: by 2002:a17:90b:1801:b0:3b3:ffa8:6bc5 with SMTP id 98e67ed59e1d1-3b41c9823cemr3026706a91.60.1795186873588;
        Fri, 20 Nov 2026 07:01:13 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40578d771sm7768016a91.1.2026.11.20.07.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ram.vegesna@broadcom.com
Cc: dwagner@suse.de,
	mkp@kernel.org,
	jsmart2021@gmail.com,
	hare@suse.de,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: hold a node reference across asynchronous session setup
Date: Sat, 21 Nov 2026 00:01:08 +0900
Message-ID: <20261120150108.3128312-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
References: <20261021022209.2580332-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Oct 21, 2026 at 11:22:09AM +0900, Yehyeong Lee wrote:
> efct_scsi_new_initiator() hands a bare struct efc_node pointer to lio_wq
> and returns EFC_SCSI_CALL_ASYNC, so the node state machine keeps running
> while efct_lio_setup_session() is still queued. The work item then
> dereferences that pointer on both sides of a sleeping call.
> efct_get_vport_tpg() reads node->nport before target_setup_session(),
> efct_session_cb() reads it from inside that call, and node->tgt_node is

This is superseded by v3:
  https://lore.kernel.org/all/20261021142818.2782104-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
