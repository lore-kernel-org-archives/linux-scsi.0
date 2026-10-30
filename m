Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793322796;
	b=JnPHrQCHIakmGyZehSXZhxlCwppUfLUklZPyGwV3izTndETx+QoXR3O0y4xFLXf/0H7x
	 6JFuwYQ0sgr/NAq2IHFnRMvnf4fWxIicJcyyysgwfXQN0st/1DR8OneEx+ry2FHjPOrZM
	 Kxlnd/gRoUk+NuXp9ZxCKaYflWndAUtkRt6RbWZCsUKkseDObexEsAQh9YcoRUKucLwHR
	 b9f/+A7rRRujRBXy9bCZFdP40jdTskAbQrtNsI3gJ4sn0iKxd2TASx6e/Qq0lXYqr5lwx
	 qDcCij5UqD6zps39RZPBexcJ9EPcT4+sET2nkitt+Zh7eAdXGqvKwALYRmVxBsSvEPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793322796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jUw8Bd/Jslu03fjp200As37/ZzXC3YVxNBvroxscwA=;
	b=te55tbRuGLo6bW3pyHp5LxlSXVM5EYhpZuBh/plWAmQDIwagcW/AY5oPGJmcQyO2X6oU
	 zMgmMnCp7tEQUXt4w6un1TENCM28cJrYw5Il0zA5UD1y+ic6jPNqupLzXVytT6bjHEeI4
	 WOzNGN8/HoXyemuAZ/i/K2zPvdGUmE3hk6MgZm+hmY4KUbc9cWoJ16WmCatJ0PutDRsw5
	 RN0CMcGQ0KwdYBd1BVmj2Hb/WSh7Qbo/svhtQ2oBMoRlFZ4cGGU8AIUnsvvEZyz5gh24A
	 LAHueVMaqP5tvx77RhgXrBv85eFOFuPRV1Tj1KzMb5g+aWcj5Q1baEKmXMG8RvT5SXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C7ECxrPu;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F24D606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 01:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F24D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C7ECxrPu
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-369f33df08eso485044eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 18:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793322795; x=1793927595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+jUw8Bd/Jslu03fjp200As37/ZzXC3YVxNBvroxscwA=;
        b=C7ECxrPuwXKmtCnR9zQ5UVrBA9ZnwzJeDyEym7gi4HXYEgTrZb6RNABLI02VzTUPkk
         0xrXqeCGLGxdHW9chPwY9oHqbBvcSFB2TEtki2VETj1P7K1PPZ9vQVTtq7d6sgPDqMjm
         cCmelUwE+X8lFarqT1y9UE6Cy2dpEGFtEMnDB96o7S0epnznQ7E1antid2nIPSTBsWAB
         f+4BwJD8z2Ce4mBwC+7d74g24BsM0githUMuRf73+y4k8yR9fytO+kaj4uYRnSBJip90
         8xIiD+kX3dvl9r4E40D6LGq1la0LevL8C9Wp3fMrzQE1/jGQivXDAVL4/IqcfJiBfvFK
         u1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793322795; x=1793927595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jUw8Bd/Jslu03fjp200As37/ZzXC3YVxNBvroxscwA=;
        b=GKcfEBR2y4boWEMgieT++C0JIrwFI4Z9PfSkZLN/a0Hps/3MFY9QhAy5F0U0qGi5Gz
         gvXC67njndfgQ8BcPSJxwwjVXAvnN80SfJIafLZI2DZirAw2Gh5NtRyMxjFzLgFAr+G4
         pYqClgQRI091EBTwdQjZQxfTjjVjRkhKT+LNKqJDM0nnWrks1IdM3wy/C+55rVm3w3V8
         gTFYLw1xF5GaI+PcE9IJB1ayLXUBStwn+KFWqXkhQ0M5l4/UqOX4QK3kZ6BNpQUdsS2K
         L9RXfxqfYzRRlSC0CZnH87gMc1010f6XDE1RcVUV4vYJZozkrDYQFozE9bi5iZWDdFjS
         CRpA==
X-Forwarded-Encrypted: i=1; AKwUvBwy3Y3knMee80iF1LERrJ+tkJqSVFZODHW/CU2DNUAZEAtO+H7mBhiEay5fI2rxyo9U+XrdenxWwk8P@vger.kernel.org
X-Gm-Message-State: AFq9FYJfKJj70uffCvkChqbaSv9rIArEJXTTggBhicUMCTnnfB6pePYu
	4G6Qd2Q1jm7xrjdnMVDhSF7nq+4rJTy61O163h3GzpKy5Xx8UD5T7ZBr
X-Gm-Gg: AYBFou3EqD9wZjFG14X1q03iXIcbRdzJ8jetTN1L2ZFx4KwLnrzLJHYvk/h7Y9oY3mU
	XNtr2bv4Jbh3Eilo6l/kJScSHbIrqZeMe5p2pJu/7PrdgjTJ1luP9VY7+Iv89FBWL0FHRrwMh/u
	pv8dPyzpmvSdgA3//qKv5OQnKLHfAVms2cuXkHMfk36Us8lzYqxg1UDBHaCxO6CwvGx32i61k+7
	6cbeNaHXM9Udq16STTNz1/m+hDehkaom0kA/CeDp5P5CVF31invkbPbcyhOybswG0Vn0gsM7v5t
	zIV4puH09fzMiVTuru9DtuDLFoCYSwQnhsAStJZ2n1mwloWf+yGtNXuFtvgtpeQp5CzYEJ2PYAV
	xW4vcvcySOLxhtlJaBLXEw2nUC4OodBkjaNtII4tdNAPECMiQIAzNZYV5ItcfO1zY11a0XAdO7z
	9puqXIXOa10B9GZ9i+gglQ7PbzNGhlhqhLfib/6qHHGFfTsJFKIj8/Uf99rX62amNwmyNdDNvcv
	7v6WUT1w2hUMIMtGVVPquDqH10+HV9RN3szbOHz6OHaFI3Gp7KRzE7yoTRKVuZGD4Mgy90RVD3U
	m+ql4znz2tBSzWOPwB/iGNLqgY3W5OB2y6xSnFF+YCP2pkjBcqJ11vbrwJ56XRHamQ==
X-Received: by 2002:a05:7301:dd95:b0:36a:43d2:c9d4 with SMTP id 5a478bee46e88-36a43d2ca02mr888540eec.4.1793322794937;
        Thu, 29 Oct 2026 18:13:14 -0700 (PDT)
Received: from jeuk-MS-7D42.. ([211.226.54.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42952e1csm2323086eec.20.2026.10.29.18.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 18:13:14 -0700 (PDT)
From: Jeuk Kim <jeuk20.kim@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@sandisk.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	cw9316.lee@samsung.com,
	hyenc.jeong@samsung.com,
	j-young.choi@samsung.com,
	jeuk20.kim@samsung.com,
	john.garry@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	mkp@kernel.org,
	peter.wang@mediatek.com,
	ping.gao@samsung.com,
	rafael.j.wysocki@intel.com,
	stanleyjhu@google.com,
	vamshigajjela@google.com
Subject: Re: [PATCH] scsi: ufs: mcq: Reap aborted CQEs before returning from abort
Date: Fri, 30 Oct 2026 10:13:00 +0900
Message-ID: <20261030011300.1868002-1-jeuk20.kim@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <a7f072a8-01be-42e3-b17d-4bcda4c7cb55@acm.org>
References: <20261026091745.1490707-1-jeuk20.kim@samsung.com> <a7f072a8-01be-42e3-b17d-4bcda4c7cb55@acm.org>
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

Hi Bart,

Thanks for the review.

> If the late CQE arrives after the command has been resubmitted,
> ufshcd_compl_one_cqe() also overwrites cmd->result and calls scsi_done()
> for the new instance of the command

Fixed in v2.

> Please release the command only after the host reset has completed in
> the timeout case.

Fixed in v2. On timeout, abort returns FAILED without releasing DMA.
Recovery is left to the SCSI core.

> Note that ufshcd_mcq_force_compl_one() skips commands with
> SCMD_STATE_COMPLETE set

Fixed in v2. It now releases timed-out commands' resources without
changing their result or calling scsi_done().

> Have you considered setting a separate "completed" bit in
> ufshcd_compl_one_cqe() for every command type?

Done in v2. UFSHCD_LRB_COMPLETED covers all command types, and
ufshcd_release_scsi_cmd() retains its original semantics.

> Does UFSHCI guarantee that the OCS_ABORTED CQE has been posted by the
> time SQRTSy.CUS is set?

CUS alone does not establish that software has consumed the CQE.
v2 waits for driver completion in ufshcd_mcq_sq_cleanup(), covering
both abort and LU reset, and propagates LU cleanup failures.

> Please don't mix SCSI EH return codes with negative errno values in
> one return value.

Fixed in v2.

> Calling ufshcd_eh_host_reset_handler() from ufshcd_abort() is
> completely unacceptable.

Removed in v2.

> The kernel-doc for @flags should say which bits it holds
> (UFSHCD_LRB_*). I'd also define the bit next to struct ufshcd_lrb
> rather than in ufshcd-priv.h.

Fixed in v2.

> Please add an in-body From: Jeuk Kim <jeuk20.kim@samsung.com> line.
> Please add Cc: stable@vger.kernel.org.

Added in v2.

Thanks,
Jeuk
