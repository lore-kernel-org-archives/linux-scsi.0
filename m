Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554898;
	b=CgRWOMUWmcM8kz9M2Vb/FrHFxr1HpCR05JN5bFQkV7WlaHVBhNfWuiLShGrGm6lP8NfW
	 Jb5trhEcH0QKOi4IO9M14jXsNlLHN83VD74mJDBL7viSytEsUZB0WmY1nbj5xCuivX8B2
	 ZZDysNbXFjPnmFgjRfFRAQYf5UiR0m8Cz3qCJHwT8jtqy9ilvpVcgkayWEiBfwivOpBlA
	 S0rwTXOrfptNcrLW+w2PEsrwKGr030MQtkTME4V3XTRNrsHFTv+GPHYI9h1Thco5D4paT
	 i1Iv6wGo+ZFnUH3SbsZn+rY5t/tQHpozU7MLXyb9b/N8AWt5nr+QBnMmUoozpr+21Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554898;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Rr1gddCtUYSoNXnlne3L5Bk98geG27nFLDDMlOBWOC0=;
	b=lVVB7n9DDPn3Mgx38eta+mgkFqhKDQOXbdB3NHwdpvILvMMm+LbBft9ZqqnONbdYFr5Z
	 9QMpldhM7Z8jjk3/+E2ni5t0hutffPrEXFP+MRj0NDdUGVmCJF3U1NikKqb8wbmulvxZ0
	 /djWJ0MPR8KFBKFEMTeQwUNu0VVZugFkR/GirkaF3gqgPWrtY2RdWu7hmqPV6k7fJpWnK
	 nC17b3H240LFbWMb/AtovQPOflTHXSv1LujUZUaeu2u3Qnasz1mKdg2W99E65UtDuNknL
	 Vj+BhyTdvprtdytYDjEOtPFhPfl0fOPtvqcsqXZ4eViBqkCAhMIllSEd7vlLQk0DeTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2C6606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 03:54:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A2C6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-88629a452e0so218963b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 20:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792554890; x=1793159690; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rr1gddCtUYSoNXnlne3L5Bk98geG27nFLDDMlOBWOC0=;
        b=qtzs0MTZsqmHMANRE7P7S9YfABsEJxi0UF3Vl8eay4R9tfgsP9aB7R1u1gSr8lkB/H
         Ek/XPIlB7YY9Pt5TdmGCEDspIoXLhU6w4SrDuhC6TrAzLO9fTFenBKlgQoCfDFEomoJ0
         XAX1sQdz+kUob0yOdqX3NQ4LVbR2gG//qI8JB9T7UpJsB2ZhpBtlvI6EOvjUuCIhypbm
         fR859g2kOz8zt0PM9JeEphAuLFDy8ftTPWJ661mShF5bn/2ixAz/18ONwm9wdf2Dbanb
         Oc3qIBpYGwpcTvZsZsBqlcO6mWb1tB9sv1utRGnTEPGIknMwJQQUF6+x41VvLLvPTvoW
         hDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792554890; x=1793159690;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rr1gddCtUYSoNXnlne3L5Bk98geG27nFLDDMlOBWOC0=;
        b=hzrgAbI6sR9/5DPwHqy7uCsv4YuHlKVkuS/atbpMXrh6GUBUiz/N2Oi//Z7I/Bz3Pt
         sQLxxNLvZbfN+8dEK1bJQxIKeEIKsKmDLMLQgk7gXXrQQ5e/NLdAnLY6MyPhxlXw3YyM
         1cGEunYSxphAq2crn8xijBoHp04FpHDXt9Nk+pqj6gw5jHrGZOYgLmYfgxvK3NVaeu1o
         u/N0m490EFudamxuABEAaia+gqEQbQ5Y3sjtnB8NyajMETyD/fPwKVwYqQhMmbrD2wdS
         upqO4SzsC/1gfd79wfTGSYk6zv4fresueywxXnfLtoAVZUjuEw4XmOkrnlEN5xqvYZfN
         djJw==
X-Forwarded-Encrypted: i=1; AKwUvByKE/cdUFp3kvY+7t/3OI5JvK0xgPmZyCnRmj7pNkmJUSu+lrmhhTrGKaq9LVTBqaIk0Aaadx7VwSh3@vger.kernel.org
X-Gm-Message-State: AFq9FYKs9EdN94cT7hOqmNt3zdWaKi+pA82LH4nQjnxLUdQtyi4YNKXl
	+2B+vfcdvTRSlvkjpLg0mVzm6FOlwBnHKbHbXhvS4LXlbHLZpvC4xumwQHHvCb/kbRs/CiwWVRt
	j2tA4QErYBTFGMs4isXVDEg==
X-Received: from pfnr27.prod.google.com ([2002:aa7:845b:0:b0:89f:ee93:28a6])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:908e:b0:886:4070:ceb8 with SMTP id d2e1a72fcca58-8a089eeda16mr734413b3a.56.1792554889480;
 Tue, 20 Oct 2026 20:54:49 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:54:47 +0800
In-Reply-To: <04957492-ed95-426c-a5e1-5491ec749c16@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <04957492-ed95-426c-a5e1-5491ec749c16@acm.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021035447.3488381-1-stanleyjhu@google.com>
Subject: Re: [PATCH v3 6/7] scsi: ufs: core: Fix double release in ufshcd_abort()
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 10/20/26 1:13 PM, Bart Van Assche wrote:
> This change is incomplete. "err = SUCCESS" is missing above "goto
> release". Without this change, the SCSI error handler will escalate
> error handling unnecessarily to the next level.

Fixed in v4 by setting err = SUCCESS when
ufshcd_clear_outstanding_reqs() claims the tag. If the claim fails, a
concurrent ufshcd_poll() may still be completing the command, so the
handler keeps returning FAILED.
