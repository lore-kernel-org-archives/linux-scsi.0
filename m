Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916266;
	b=g1Rcs80rW43Sj8U44h2FLSFwxSFOW+405K3Xhik8kXaCF0ZWYdaAq9ymeYGsR989HBiT
	 HONvaZa8hL62MC3ho1JqRsXGvirFXRxLFzDNIZJcgWAJzygrOrMBLbFzQzZ4taubCJrM3
	 w8svVTtft3RQKq6hVbLi1l9IaxSj+DytiPKjNSHAjNyg/3dgM54Y9t6sGcXOBsvOIEJQJ
	 C9kZSxrvrEYgk5al5GmNLZ9yI/mVmhks2L+WQUGeKHwu3xXKqsD/mY2wbYicTfLs9q/97
	 4gQ+BEn2GiMbRfsdsucd0y3NKzmvvxiPb9rkifmPUrDtqo1hubytDSxdrK2psv/PH5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916266;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=sndVk1kvVcJgUJP97zm2MOkioC3KVSvDmF0LGbe4m7k=;
	b=yL8xUMmjxWkK/d0HOF1egDXUh7ysDsq6gMhTkuEM7yHMcvHN1J4RlVds/d7NIvKDJ4Sn
	 WxuB1pQQ1z8RrDxyp9vCRhJ3EDemc2V5n/Zv6TC2bs4k/NzJYX47L5aLQZhVG0LRZP+BE
	 qPtzTmAJns+RuQOaqwKq5jBMn9lBt0P0FFis/hzPKdEvSq763SG2D4qr8QlEax/CEbQ7K
	 bFz9xdyltO7vwSM3DDMedWKbLxRVNJWSRhbkPJCDd93mc5YIAe9SGiEmJ7RnsRnO2Rbjs
	 eLBqIAKBKvXEOSFyenjn5WjWqZsplscWsqRCAKPHJoJVBT9bKA1yGig75e06jnZ4+rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PHE+DrLL;
	arc=none smtp.remote-ip=209.85.214.174
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29AB606A32F
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 11:51:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F29AB606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PHE+DrLL
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e987a2ba0cso27343425ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 03:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794916265; x=1795521065; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sndVk1kvVcJgUJP97zm2MOkioC3KVSvDmF0LGbe4m7k=;
        b=PHE+DrLLbq+bKoyCTmhWmTE+8SzJaoyIAVtlERyzMDnRmvXx5DvcH/afLo8IzOK3Ic
         mMjakZdf/kBTWEogCavfsZfNF8Fun8K3lgdiiHrqoNSseTg6nsOJyJzeLgOKkRVYpjSn
         XCsQEdBhs7xneBlzmGbuOb5GOXBbC34P5WEwruQQbtXOwYwg7rDVfp0M8YPmYtaOwDOD
         E7N/Clxw6UgZFTpURIJdgA1jS48/1i8n1KfXeHbGRiIx7l0WrPsMC28KKZ/KbmqbNBve
         bPv/p0lGGWwRMWdV8FRYb78iaPSvJ6P9i25WW7xkZfuQ/4s5z4sXdXQhePzO9viQx4IH
         ojGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794916265; x=1795521065;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sndVk1kvVcJgUJP97zm2MOkioC3KVSvDmF0LGbe4m7k=;
        b=lKGbj8keYweYuD3uTPwcnh1CmDRvREWSjjEPrLoFooKhI8T2+CL+lHnpe7aQ2venL2
         KxGn4j1RwhXHQ4Q0XyYFJXMMAiymKX+bXX+8DTiGh3SbXS/CUbkJO/sHIAj8mCxJyKmr
         +OxaF365WXszHLGffZnqFXfdYc0gaM17eDnqRWoPMH9wQS20JBW0gVW8gkBcqclHYacn
         O3uLG9iHK0rcRDInMasux3qNvFLXxtAhJZYUNO+QebkniBTzpvr8+P2gPAY5aKtYuXry
         bX3bnXQDIvUGccZT3aQuOfPnuthqVW1Y/j1ux3c+ntTX1kwlVue4clf3xzwijao3X6AS
         w8kg==
X-Forwarded-Encrypted: i=1; AL+hErFj39EJLo7IVQ7M+lSLy+zK/EsxfcBIPOveLeyroUqKL4I1NtM8/m0ndulSM9ON5MHYMIbArsMpkE2A@vger.kernel.org
X-Gm-Message-State: APuU4Z+EoNaA500xXnZ+WGqFEH/51TX+04WBg8+jMutYflQiofIA/jQZ
	DyqnOgBJ+nzkHXFVVOJ0fUpHRhPq5Gxm3I41t27ylKCjdDYLINf8DXOyOM2ya1W/+8Y=
X-Gm-Gg: AZFdTZf4q5PH/up6aTszQRwVB2TBtMYEYI8HxwM1Knb+0LUJUkPQ/6DXi2XDmzE7xdI
	CCbX34Dvt2RN04cLSQKNLh96aPw1TunQgzNClSfSnxlg59PQnCDAME48oEp+kSS5ZoUYOXRN6Zl
	tNbM2ZJuCVo+MOl3CVq1iMIY1JFL/7UUoMGvfQQWUQYeZi1yA5WWTBQnu6W7So8FHZExOn+mVmu
	nJzb0LRX/NPIrA1b/B5UrcksJVZ/D7wrQOmPNDUOECQ1Wqz8F24iJfcsEWYwjSJVUNKYMpgBLOR
	uos08PKuOJb0JOtQcuHzIXICSKtCDEMKivsVR3xOj9ZSUdnQ3ZdeNBHm5/Z1z+vF2PqisGnO5VG
	QY8BVU33xmMPLb2Eu4zk4N3gA5uAR9VEFJZjBo+8fdlwpHBaimrzvtcVnhTRusyQlhoETuHIhsU
	++G7DVcoGUGaiSYFvW5B7YBe9rL+WrVV907a09uk0Gbrk6h9LlLlEvgUO2sReCxKq/5GHI+wgkp
	jSj8vLAeLK09T731L6wZfxInNe96Zdr5SeHrLPTLE/4+D/7R8ZzAt9EpdstJaSCG7lTMnG2eK49
	ZcRowFeWeuNJgYEuAghkEdKRV1OnLTxy3Dsvnh7b2AtIUvHjzDOzkmvUeQw7wXYf4dR6KdfEdd8
	eCSS6/LSrpeY5PnXcIDXNlyjeX3aA5YSf9m10my4Iazwy2b7HSWYRyF9Pz1L3
X-Received: by 2002:a17:902:dace:b0:2ef:e547:e0cd with SMTP id d9443c01a7336-2efe547e397mr10611265ad.31.1794916265316;
        Tue, 17 Nov 2026 03:51:05 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a88a55sm14107085ad.65.2026.11.17.03.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:51:04 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org
Cc: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] scsi: libiscsi_tcp: do not accept a Data-In for a finished command
Date: Tue, 17 Nov 2026 20:50:58 +0900
Message-ID: <20261117115058.1955891-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-218654@kernel.org>
References: <20261117101500.1894608-5-yhlee@isslab.korea.ac.kr> <sashiko-outbox-218654@kernel.org>
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

Both cases need a target that reports a task management function as
complete (ABORT TASK, or a LUN or target reset) and then still sends a
Data-In or a SCSI Response for a command that function covered.  The
receive path handles PDUs in order, so a target that follows the protocol
cannot produce either.

Neither is new with this patch.  Without it the late PDU is accepted the
same way, and iscsi_eh_abort() says in its TMF_SUCCESS case that it does
not stop the receive side for exactly this reason.  The patch narrows the
window rather than widening it: a Data-In whose header arrives after the
task has left ISCSI_TASK_RUNNING is now refused, while one whose copy has
already started when the task is failed behaves as before.  That case
belongs in a separate patch.

Best regards,
Yehyeong Lee
