Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792710067;
	b=yAiUnAJbDhXVOe/qCdKeI1Z44gcVDTTVu6STX5BIeITQa+rtb+Dh/H+hCVYK0KXZC0Ii
	 zgG0t2YA0MHAr3eNm3qBy+k/bxCRW8DMwKQAeNMAC8SRVm8Rfvz5HgWdDaJlrMJWqf0Tu
	 rJm0utDqrUZ0aQPU+vxmDVWgg1S9jlDxjFz2Pwhy7BOqj+lXcEIGWz+RfulhJsMbNudtR
	 Eo/jn+hbOxSq0OughSny2HLN7dfGDfUExO6Ob/cTX+aaHYiznimht5bcqsilW3bRoecXN
	 oFiFXbCq49VlhlcJBrUN6nE7NilVYF2Mqra5xZVIClRuNGBrU4SJGlUNz5jpnmoC1Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792710067;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RkCdxIIcsUSqZgK/y1VUtLxtcRLQdq+B+GtBMdyOLJE=;
	b=I8Q89EYvEez3KcverUFPx+EeuzY96L/PAx68rzAMKvJdYc04Y394+YYyNt7gZssVyrHE
	 WyZ+vOLilAcmMDsKzWWnfJAtdG0UqrYXOnNsTW04/Ap3Cyhx2UrZ5S9r2JzSiEr+ITVJO
	 LfI3MPYpQ6uRw3uPIIIpFJIH8PwyqDMHtRtJeMzU/lsaR9uox+xBk1z1QSlwaot/zjjxV
	 a+aM4mtoXd+IXWvSfWzzNjxUWLWsfQiEYGM4tntKSYo7mryWQ6pOKIT0b/q6uqI2IqWEl
	 MFqYD2yTQYYPDI+aGIe77qW5hMIYcD040M23yJaw/NVH5zP4aA1CzmwNQse6QsfAcBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iNYoA419;
	arc=none smtp.remote-ip=209.85.222.43
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75E606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 23:01:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D75E606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iNYoA419
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-99075306daaso199258241.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 16:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792710066; x=1793314866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RkCdxIIcsUSqZgK/y1VUtLxtcRLQdq+B+GtBMdyOLJE=;
        b=iNYoA419HV84ypruHHVNMc71/mABHuyJ1ef9/37rrb6BqB0cW/ICWaU6fRnWkU/HKS
         XxLNSv9LSbfTusCem+B/Kvc+oTmhPRFoxZ1kym/LPPo533ej5aicxY01YVHnN1c98+P1
         OqRzNFCoKp/makT4K7AWQQyQfkVkS8xTukMUL1B95iVqJXQqpppqWeCpDVzC6d016Wvy
         YIX4I76IP7SHcwp+KkYf9dtcIg44iApJrFUFaKAduJko5FLpAzuXmFzAi0ibX87IVaxV
         L2nD6SrN46jfJZmruqAJmzSU3MzRwZGYHPRZIfb49LMcV/DfWvzE08GspRtW7ckI7zFK
         jz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792710066; x=1793314866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RkCdxIIcsUSqZgK/y1VUtLxtcRLQdq+B+GtBMdyOLJE=;
        b=J2bj69WKTpgSEfuLHUJPkb3L5s1gXMFztEoKE7F1E9I+5vMHYwRTFbFPvTd+WklrMg
         hE7NHniNlEro9fdd4SCOrR4ozJ45kqx/Q0RnRNxurtcdE+m745AkxE33S8m15mX9wDHR
         GakmKobcAz5IYcEU3yuMdxcyfuMXlblL/r1Dr84v1tJfaEhBS6QDmzYAN3ABCQFpnGiG
         834dHF6X1MH1SMl/PVusnX8ziA6DJo0l0gYBGr2txMuEJyrflE3CRPIZ9yBNMXMOD8xY
         A8c+AFJtnjzza65qdv62jKLNmhjQOubytwOx5upV/CKfHHbxt7eFIZ7Aj8oUQ2ieRfxD
         RVYA==
X-Forwarded-Encrypted: i=1; AKwUvByx7JnaWBhrAU2YV9w6p69UO9a96oWP8C6smWHboGwwQLao391DSCZ2jOUgLw5soyjo0PUJxInAUiuW@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7BTHTe9/5/XFVQMWWZtolTu+fl0JKklXYgVFpXZ27RFgX7U/4
	orJz3kgIVxZ5Mej3tp2UfF3WWR6RHuwCHxIspbotzWfgZOJzGrfYo60e
X-Gm-Gg: AYBFou0/44kwfClmwtz9F5gbyIJ1Y2Za8jHCHyrFsDybEfkKosESArzS0X89PVooU1b
	A6WKp6V2U+fxeqC/hUuo50o0fjQk4z0CjlSjL/r3a688BAwYsTchwc6h5FSwrBSecmx+tdlX7G2
	47OiZEQe39btPFTjaxZgGbTk4YC2Wy/ZlpgSqUlGTIG6i127ARbjQOYcqQfM2LroWnCObiXX8B0
	WXBDJKE+dxmSzHqtPCAZ7lPV/xMbMw8/RYPoDXZlOu+3K5Lx5t2Su2yN/xeqrGWqiAxpKKSZGRs
	F11cu28pPHmHsvLq1rV44EgBdqADtZ+sNLgqj/jlAHyhyGEexm3f0/yGSQQCU4iNgnQY/OhdDRw
	+3E8Ood+f5LJ6HeCa1pktSiuw8beCvAxFMiq0ootmiULfnl6SeKP5VyToZ926KsOplWSjasHGba
	XttJgC2KWZs6q2BKGxRBM8AeEZZ8Yg1CSjGtqaQdPtCF4A+1WEKDTzirl49qcksWy0F8ZfBz716
	nbOACDC1bCsp6tm1rdnukK9fw6KwwP/GuubsLy0wuH/4PX1H6x0s2ObhS2V0s4Wa/EXvy6dT5SN
	fRfZtTLrsPehj+GnFqpw
X-Received: by 2002:a05:6102:26d3:b0:7c3:7286:c291 with SMTP id ada2fe7eead31-7ccc329bc4emr420829137.19.1792710066358;
        Thu, 22 Oct 2026 16:01:06 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ccc1e7ce72sm1245236137.2.2026.10.22.16.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 16:01:05 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux@armlinux.org.uk,
	Bart Van Assche <bvanassche@acm.org>,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 20:00:49 -0300
Message-ID: <20261022230049.95290-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <87o6clz749.fsf@trenco.lwn.net>
References: <20261022183658.58090-1-breno3011alves@gmail.com> <20261022185224.60700-1-breno3011alves@gmail.com> <20261022185224.60700-2-breno3011alves@gmail.com> <871p9h1kc7.fsf@trenco.lwn.net> <87wlr9z8iq.fsf@trenco.lwn.net> <87o6clz749.fsf@trenco.lwn.net>
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

Hi Jonathan,

Understood, and thanks for the clarification.  The maintenance angle is
a better justification than the one I gave - "this file has accumulated
no changes since the Git era, so there is no maintenance burden to
relieve" is a concrete argument, and I accept it.

I will leave the decision to Bart and the SCSI tree.  If they decide
the churn is not worth it, I will not resend.

Thanks again for taking the time - both the technical points and the
process correction are appreciated.

Breno
