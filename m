Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794398014;
	b=bGeApxN+xlFGSlcDCcHwV4yrc7xRYmVReiXOyqTiYVI/9NVzR6hvCWSK7O0Zx1PGOkAG
	 /BHQor+RajRNuDxPkBxCA/CI3zq5Jw4BcMZGggKqx1Xa8bjWfcXV5enO/p/itVFA+1sGu
	 7o01cYpICs4E8++R3gBgVkkiwaTFmPnmMlPehNKSECNDNMME3qjnZaUlERnm3kREaxPO6
	 OJb0UJmc6SH/488bA+4nLIDzMQlTSMStOkTVAJdor963/F/+gD1BRJGVfiQ2Yeqq+eDEl
	 L3rvUZEwx9btzKnJUu0jq2yArKkowHn9FpMlymOQdROOdr8NyJEKZtu7sNG1qXr2IKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794398014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=1lovXTBTesNzrZjhYYZnRpEWhMn2C97Lh0f0GxPOO9M=;
	b=sY0/n+xaG4ahbFW2F9ot9ld7R61zQHgxzdl+sfJYcIjRyECZ3wWATzzXaTD1Tawvateb
	 B0KSXESoVNC0/dxavmyFLEDNCqW76CAfbObnaSx52PHtAtBQp91ejIQKWQScvAHrGCfA9
	 ybyiZP3KqpYg6lYi5vwVqFWBqkU8OK2gspsgR/L8SHROtCLhX7EmzSIlXboYTJ7ttv0Yc
	 zhpjqQX8eeYPnVBxWIEgY+9U0ttMHdHKTdzFP6KghE7lpLgkTfiZwlGiJffVkFUjE6UMz
	 yZIuJrlLjYpll8NBOpwWW1SylAtxpbpBvOEuQNWXKxmu/4Mc7mRSddbQjYB0PKHsmnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="mQeEA/v0";
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6405E606A884
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 11:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6405E606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mQeEA/v0
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cdd77f53db5so1727488a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 03:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794398014; x=1795002814; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1lovXTBTesNzrZjhYYZnRpEWhMn2C97Lh0f0GxPOO9M=;
        b=mQeEA/v04wDHYZXQHXJp6+Yj8QXt9MVbmAKWCtCRNRq0b+TEQ8SM3wltK9S15GIlBC
         67RWyBh8aOkhD2VwVra+n6QZ3dRbFwa0QzktebDyWW4lviuHEo1D/6vf5XQprQhmVHSL
         H2rNU11hKT/0SebeEz4BW436Sfl3blhGyEXyC69weJdX3UfmfH5aHA6e+UDdth9BQ1pW
         Anpmw35QFMo0CRLKYSSx+hGbXqFRYGvAOr3L+nC8bEUnCl/+AmBwCwxf+1s+SUCkS609
         FnDM6FO+JeVWc+gT2jntoq7VzvRCnBhkWTrruWfxcOOcXHzEPvpDjCh/P/qHTyJds1/l
         QrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794398014; x=1795002814;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1lovXTBTesNzrZjhYYZnRpEWhMn2C97Lh0f0GxPOO9M=;
        b=rLj65egQ9Ug7puKZOw07Ml6OD9TCSYAe9b53kYNrkj1Wom6G2ELMZq2ogroraNllUi
         MtDBQRoIJaM+awovHw9FLzXt72FD8Y4EePo49U/cPrBl4hZmgmvAZsHWHhfI6Clyh/05
         EzMinNmAFdtXdzsbUI2jIEVNB315QdslsM3PSuSarz3/zbvO0MZF7ZlYwZzvf+VtpN0Y
         4szlrZIfeqbmiJdE+Q0FsHGgPzICY34yVObaXccu/XdAl53sai1Fyy7B0qPZ/ZU8ifVE
         hRQYuusbTgwhq8t8xKnMqtR0M7agQUeIdRXWL4PxRMwGFd3SsjNGikwytswtE7xil0gw
         QVMQ==
X-Gm-Message-State: APuU4Z9uAk7dIHxowf35TevEKXHrLqWWXJAZJqYXG461VZO163txlQJW
	uqQagbtn5avCD60BV5kUJffFtj7ESBUeKc4qJQ0uWWN6Ft2fPy3ECwvd4isjmYuhxq60U3Ralzs
	S0igL7MniD/TfVgd/bmewog==
X-Received: from pgba19-n1.prod.google.com ([2002:a05:6a02:6453:10b0:cc7:b17d:4d13])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a0a:b0:3e8:b7fd:6294 with SMTP id adf61e73a8af0-3f2fc99f99cmr2221312637.16.1794398013463;
 Wed, 11 Nov 2026 03:53:33 -0800 (PST)
Date: Wed, 11 Nov 2026 19:53:30 +0800
In-Reply-To: <2052256418.81794387787276.JavaMail.epsvc@epcpadp2new>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <CGME20261111082303epcas2p180a7cf157dedd181634550630fe78df5@epcas2p1.samsung.com>
 <2052256418.81794387787276.JavaMail.epsvc@epcpadp2new>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111115331.1144901-1-stanleyjhu@google.com>
Subject: Re: [PATCH v10 0/4] scsi: ufs: core: Avoid redundant link recovery
 from the error handler during PM
From: Stanley Jhu <stanleyjhu@google.com>
To: HOYOUNG SEO <hy50.seo@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bvanassche@acm.org, mkp@kernel.org, stanleyjhu@google.com, 
	peter.wang@mediatek.com, alim.akhtar@samsung.com, kwangwon.min@samsung.com, 
	kwmad.kim@samsung.com, cpgsproxy1@samsung.com, h10.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"

For the series:

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
