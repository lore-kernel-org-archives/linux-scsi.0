Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924323;
	b=1FRBK29a/psMhoTjbwRMp+WLoEKq3DIGN3LkJaJCFpbViY5PM3r3oXCUoXRrcn2eN2oH
	 tSdUAMOE66aTSxib/RcjkoIgr3y5zeS4u/gO7yc14ywCuiyoxVG+Q6sLJzv41WDa14a2q
	 PPP+eyK4/Zx/eBvS7xn0Se7zNlSArEle7x3awV681il06Mck7VI1KNSkvK4ljxTWQoAs7
	 j022YuvK8z4+VF/JqHlGxQHmwmsIy+h9N1CK8QxxvaRznHMsmj180g8p0KolOLjmn7Aww
	 5RpNufbIvJ1wcGFzJLx1OBUXZlSExHkvrVmJVYVZbVAvsly6XAF6b5Cqp4KIz7+HoUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924323;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IzbGVjgREwr9IrIK+xSlw1aYmIcPEF/XveJxpgUjaVI=;
	b=yMVTJ1WlNEpvlwuyqpOQuvOpe6tux2509GlINoyAIwGtGlBPMiT3EMeAH94BuT/YbXY4
	 rRID+diJ+NMOsxzsnk+93A14jeaY3J4NLqPOxk2xQURtnUMARe9uROCvW0qBSwlGow8su
	 rJeSl6b4nr25Nf/jwFVRdCKLjEcTurjJOd7Z8iQo06xu40V4ebluPRoIJNmsnkfOsg0ss
	 DZOsHUOOc+m1CXierPHBdd4ypHfsDbMpuf+mzYR6SnoPXrLrHYBtCLXdmJMg2ixjhFW7V
	 G5qeZtRwXVrG92GpL0drImsMmuTrSyNOjPnbB3l4LCW3vRPYVsYuil5uYk18uZb7uKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BBlemqxn;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B1606A32C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 14:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 286B1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BBlemqxn
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cde0daf3a2aso742578a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 06:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794924322; x=1795529122; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IzbGVjgREwr9IrIK+xSlw1aYmIcPEF/XveJxpgUjaVI=;
        b=BBlemqxndtn1LGN4lASfmZWK53JwgEvRUfKb0TF8DXG+BE9AgftjnNwXyXDetVobUA
         btHwhojvdic0e+IEoGQvrSYgHcC857Al0GuA4DYTnUilPkWyDm6IsD96VjqgWW+4J71a
         rKnc1ouqTmSMqFsUOeyxJ33ziK8iDRaLNSy6F6xnj/OrG6RI0cHD8c6s0cR82b0QCLQC
         XPhVH0TfQYHt9xIwfEe7UM/8xUI/LUIxNpplpDn5o7MSSKpIBkdx0bs9kxHAaRAsC9NU
         0vWweGxk5GyF79U9zM3LAKoy2ma1vvZvOA85n0fcq6hdnm8pgMBzb3Sgnq+wYpm3d6jX
         mmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794924322; x=1795529122;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IzbGVjgREwr9IrIK+xSlw1aYmIcPEF/XveJxpgUjaVI=;
        b=c/3sVdicSm90K01du/OXTT/sa0bEKEVdp1Z/ZGa7X0T0yMBCwLMDp6gIBiPI0xhc8L
         1yzKSnzjiguFQV4G+i0+KRiUkep/Y90/NKj1OFF0uZrxjHBCQpReCiPzxIyva/BRohPY
         4oTeRhJkG6afETnmtx1JaEL1EpnV50Smo8LdiupuFL0siOCzmC+tqVqO96dmx1uoUtoH
         dC8L77psnAhM9yhu25BvK73zhWMZG+KpQoonRyOeFs4jGK6+vvD2jIbJCP7VfEtl4uo8
         aJWXTvbrhl6A2Xcas6mQxniGp4q+wV6YsgXVo0SsCycgC98E/r6kixY8neQQcGpfY0JC
         IFnw==
X-Forwarded-Encrypted: i=1; AL+hErG3vO/iXjMSW0damCgQVIsHODxnL/htAH1CRDKwEjke7uxM6/ucqKpJ27yT+208UgToMCvzewNls30g@vger.kernel.org
X-Gm-Message-State: APuU4Z8OTRI75t+UStykRstv/GK88smEL3BnwztejbkI2kzP5NHKkuJH
	YPcm0Gxqw2EOPMnbr91o9P459/ff1acvlASPHOh2mEFDzmDiSQV69h/+xHyajyh6hJo=
X-Gm-Gg: AZFdTZd0z6ashApz0vb51iS88n9KIi8qGdBKLSuIseUxtawdyvZ9eCEVZ8rVWtDqrlh
	NNfIUFcaidruLvtjDCreO0oT3HCDQCNvDv4amA7SkNOI2xczOXGrWF5JqVjWGHkplhWUXrAGv8y
	MrXDWHYtSJy7IoNNlfAJX15gk9U4MJDr9YmeSTHOYKp/5983zvlAOz/dU5hC266vjIhnZGysRZP
	x2fWHNxhV/fu32UbKQqn1z6Gr+OtsKjyfLaCE3Gd0VBQj/Cle73AHuwdomllYNaZ/vMnAccoanL
	yrkmDR7zDVIi1In41maqnNtKLqX9kS/U8eF3YtundfxHptTY7ooH/NHIflwyeWl7pd5jblYTLlU
	i41GXBHAzuby+GFE/mHp5asKFt4PEGZlY8Yg30sRocL03IoGHzTg+E91aHbo8mx8fWYCcy81CTX
	lJSaGVtyi2fG7i86uAEAdQBdnFh55OlTZc7EbCTXLSHDQDUOv5/v4v571PDuhUXkfG0EH9fNmWN
	PwjoFLv7h+Djyya05z2QSl9ipMYmzNGjAtqUqts9Tq1XFWFeitcLRN7wr27JRQHB+rk5AeBIO/0
	b9RALEZwvmBIiGP/ITd//aQG4wsEPHlPHoRaYj68YU1jDYp1CAj7YM5drf2xa/rIPXe/dpQodNf
	U2d4G7fyeHCtfXdA8WM2Fi6QIb5EvMGhrbSFjDBFxrY9wNh/LV1hvEjrX4Ws=
X-Received: by 2002:a17:90b:4d8f:b0:3aa:fc22:8ab4 with SMTP id 98e67ed59e1d1-3b1b0a1ef17mr12600696a91.29.1794924322403;
        Tue, 17 Nov 2026 06:05:22 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abeaf532sm4292931a91.14.2026.11.17.06.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 06:05:21 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org
Cc: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zilin@seu.edu.cn
Subject: Re: [PATCH v3 3/3] scsi: mvumi: flush the event work before the host is freed
Date: Tue, 17 Nov 2026 23:05:07 +0900
Message-ID: <20261117140507.2098571-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-218911@kernel.org>
References: <20261117134227.2077013-4-yhlee@isslab.korea.ac.kr> <sashiko-outbox-218911@kernel.org>
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

The wait is real.  An event work that is still queued or running once
the interrupt is gone can only finish by timing out, so
mvumi_detach_one() and the mvumi_io_attach() failure path can take up
to 45 seconds when an event is outstanding.  The work items run
concurrently on the per-CPU queue, so that is one timeout, not one per
event.  Without this patch the same work runs on the freed host instead.

The APICDB0_EVENT after CDB_CORE_SHUTDOWN is not new: without this patch
the event work can submit it at any point during or after
mvumi_detach_one().

Both go away if removal first stops the work from issuing commands and
drains it before disable_intr(), so that a command in flight still gets
its interrupt.  I will send that as a separate patch on top of this
series rather than respin it.

Best regards,
Yehyeong Lee
