Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175076;
	b=LkD7lt1HsXYFF2aMLvYEsEaDUggJvrgU4hFcwqg+QEu6b9nQLFidjTkBs6OadAUmc8Lg
	 +Dz4jXdo/539IZzj9f+dxIs//FkC1v491cHYiQG+fBvjYsMNoTiSotcxZIjZXEk5y9NR1
	 a2D/vHSjAi6U2CE6/88K2TEvL4pbp/StszZp2VvBopPbtYt1CPGMyKZP7kd7yRr7nWgGq
	 2HP7UxVREVXUBT6R8M2V4xqyigFlHOigvwbkBtBgnHw+gZqg93O9zKNxUDq+5MKqT7IHY
	 AXtrvwUHrBrmseO6uJF/bSV2oUsYVxaabW2VVI15iF7/rHY6ZWV/q5ILGP6Xa5ctITg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175076;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
	b=drA/4a5owzdwE2THAODCb3jeFqXLybuDnvpb8Cjv8qKabSZHlIZuCtOY9ZRXnck/OEOn
	 NwEoSgSHUA1AZZuhsZFR3wGdaiq0nblyCB15eKGNQwCur+8o9/SYxMP9uxADtoHUjEu+6
	 3UzvbxIhZEJyPyOCYfa5N8raHje1nMoCyQOCDUv6C0REZ69zLASqY1ND5ntFURZlQ/Qfj
	 9SpIiGO/y9RShqsUnbkf3vzV/VsUEruK1zOMmUEM+qL21hSj927InBLkfYXbl1FJNnb0m
	 frZQLHM7/dMWmAmhU24pXy5VlKERhSbBruie3DDSlbagX5JPQ7sOFLSEj8kjQ+R+LQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="tFKensX/";
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D67860A5BE2
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D67860A5BE2
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tFKensX/
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cdb2893531bso467697a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175075; x=1795779875; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
        b=tFKensX/IVE1xNls7FhXjPwujTdR1gGHuvBvo9s4/yqZvI1ZSFmGitg46dg1b5nF5j
         L9x8O/2mBFzcfQL+C9dmOHZtx+c/6g/bPejo4J7OJaxthrOhpYFyHlXEehfhJogwKDyH
         pu4JtN3FcZ6nUzY0t6mVEY3AATrdiUe1GJUpDbmgrdjZ6N+130p/LZQrd1AVEAO5SVYc
         qofUP2/ID5rbo90pRfi9W9C1d6nA5Wh6ztIMp9NRwnbk9do0kPmPC1OYKS2l76fxzN5g
         Mz7tZq33/Xmi611g77yQlvrL4Fd+nHGNLyHl14NQ5CAfxHd0RuzqFvuENdsuIO3jnV27
         uwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175075; x=1795779875;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
        b=vyvV7ttbjli5wvGbHaWc6ajizC2QZnUdZUTphfWWiRqRdLQwRlZ1jxv7aP81DP05nK
         VzTn80ytYgLZ7PV+Jpf1GxtzC6rjoEW3zfFZNKHmCyzniDkZGAQ9lIF37mrDIuAY2UoN
         wIYJn48Ktz8PFkjch9IB4/zdA7bKKXjqXm4yl5xjBfY2sI4z5vS3cTk0GfD+/SgfvPd6
         GZ8ou7LIFnQ3BUiz3fDSsyzxm/xRhRVvQ4rGDOkTj3Vn04k4/sjmZD7Y2hvnGTW4UNvE
         bu+UhmtxPukErn3yIOZgnc0RuJe0WfTPH67nbyguAjgk7uE/T1mXBzB3nSrIYLcUImal
         o3iw==
X-Forwarded-Encrypted: i=1; AL+hErHRN1NGCbGCBAxMnXRVZLpMIQNGOWNKY+8BEJnocempqxmwXJpKyLtcRJCYb4HArUhMh+EDTN4CR8Tm@vger.kernel.org
X-Gm-Message-State: APuU4Z9MkyDNwkv2fsrfO07WqwNbOb6VsiZ0/GTkspNNq+0IoVy1nDnC
	bqZ0DMaCRJrHztz/43ARRBm7bI4wwwF51H8xkuXrMzDoTigiZAspWFGEPActUS46Xfc=
X-Gm-Gg: AZFdTZckhMxyWeiEYYSlLbHFgHPTs/b0zud3PC9RcXoeU4orDH/vhKF1XqSP3GACCnp
	MvmZNEdncK7YQZOszfXO4P2/VdV4bRPn/7yu7tRxJzIxVkJG4HgqJ1alpb3yKGQZwHSjUxCvkZr
	RR5AXfZ7B4LWg/lTocypdDHSsOglyUV8hoIqJrQQOXbkGGNpt1YW2o50xIxK6HhHBfXzA7zJfyB
	Qp7UFi0PEpa8b7KNvImN1gg47NR59UFY/1jp9GK1a8QRsHupRdCp3BEVMXxD6FyZPBIxft/TTbJ
	Swr7spWZXhj8mjDJE7GI7pqNGPRZH8A4OdMr0NgQHnXCTZ6Jf+MuOP12KucYBnm+T1DKfNPELob
	5vdBuoHXwrPJgNF8JxyOevkM5MUDjSckINOsmNNijTtRsOmNdt57PoR1FLAoGut+QdM37n5EIu/
	e6q51cOOYlVXl7ytYpPepRiX51/OMPdWwnhVZxuIslelF1/vf+irQy28N0Ec6t2kUIi142hgEH1
	qeX9uRiaMSmBF1ryihOpz2rbVQMWoq+Env7K03lzNXdYOsdskaHceTAvBxRBlxfT/DadEdiM1Rp
	+oos0VNEGyC6biQUsT7D08LrIYdQWs1upGUe2ukzi8RzxQMGm8lZ1lM2X7dXe9T6bThiAjDTQx7
	iuZNrjUbtf6fKS8koLQiKD7nbD+qBAswzUVvd
X-Received: by 2002:a17:90a:ec88:b0:3b4:127a:2bb9 with SMTP id 98e67ed59e1d1-3b41c8d9275mr2609195a91.13.1795175075688;
        Fri, 20 Nov 2026 03:44:35 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40a878d50sm6476169a91.11.2026.11.20.03.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:35 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] scsi: bfa: bound the unsolicited frame receive path
Date: Fri, 20 Nov 2026 20:44:31 +0900
Message-ID: <20261120114431.3072616-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
References: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v5:
  https://lore.kernel.org/all/20261016155441.1607196-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
