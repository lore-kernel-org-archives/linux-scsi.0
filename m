Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793746534;
	b=I+EVBAcRq6nJ0sJ0FpISMujtM4d6tg+25s1aEBlP33cIm0pApO3971WnSuK7cYIhknZj
	 p1VbBX/Y+/ymUyp/G6QzXeAgx2e4GpQwDwkVoJE447hqPFn5OvFgJj45oLocMAlNsz9ii
	 ZgRT9UiOt+EjFOJPm7gSGV0LS+kvNWT9CODgahbbDi/6V6K/lXplnwkTS+DNiIIzMaGJL
	 AMlH9i34TqI+j3C5Q7wboGY5Z/UVTgW1mt3aHWayzQsNNipqtJ+FP3uGlPfRGYL34+mqU
	 dXDx26t5VGgNzfgUQNrKPjVl7KfD93G2hEJxDHZDnwjNS7CfZ1ckKGwcfx6VDe53lvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746534;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=c7Qwu5HMJ4YQnRYiZoH48T5mka01qDfhnJmyLJShtmE=;
	b=FLMUhSx+S06tckKx6MXgHImAPphHUdn0jzB/4lkObAcIG7lDlWT7p4csu7YsHy5IEV1G
	 djKO6VyBucgYW63mvu8XTE+yx6RMVo7o0Bi0f0pUII0oHDzoZ4o0mZvTn4J2SVM/INYBf
	 4zU1oMg4Tua+zptwE2HZlxRYDMcIPu4gi3Etb4rD2PfDHgDtIRy66TUU4z5ErjTHCRooy
	 eiHQqLVAroObTXKBFNkmjQjxmqzO1kC57D63T7cceCw55Ayh+KGzgcvOmoWR7puXycG8K
	 pn6d2uWnLHQOo9sO2yn/Aum2y+BqLCkZKgq/9MwgUwTLcvq3FRz4qjub24DQK8Y/SMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b="AuTOxs/J";
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=iZfxCvbk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.50
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8176606A31B;
	Tue,  3 Nov 2026 22:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8176606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=AuTOxs/J;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=iZfxCvbk
ARC-Seal: i=1; a=rsa-sha256; t=1793746513; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=lsj8QD4O++YQbUUNDFLaLfEesxzMFL95FDbqSJ20LfRUgk5AKYVM6BqxNJUCoBQ/FE
    nIjvdhAyi6sEVrqJWs61GO1Qm3xtMcj8MQI4JVcFi9dLFVs+YpZmWC/qZmUhP+KKruc6
    B6+BSgjub61+1hz4OVNuy/mBckphgG34EYBgRftBsWhOWNAeiY+7lzFJIlwgCzH9z0b1
    LiYp8h45+XPKMFSDm+Fm5pMwW6ollhfkrzL7EAaoTGnJTpYBAwgt3t7t7mMr2sbgnvkp
    efWTgXbn5jyf6WnlqxaqZ97/x4axuj+sWVllJ/0FEjR/6KBprrDh0KR20RAj+xhq+nJU
    rqFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1793746513;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=c7Qwu5HMJ4YQnRYiZoH48T5mka01qDfhnJmyLJShtmE=;
    b=ellDCkCJ/OS4yZRlT7lK0pHmuDihkpXmfd2xbcgHV6QrZuqIf6tpxtUh5nOotFfnNo
    OVO44gn4TM5yQ5K/QMaTEN19SSD/AQHz4ZwYymPfBQMiKkaZHXzAXA7ZDazxD145S/+k
    Uw5EBvKooSThQ5Yg2e2RJCsHMXHTYnVH0Hmzzyvlv1fmiLRhR9z3Z/gh38NJ2rpWnQG6
    hJDoE+i2vCu2deySO3Ge/R1zwIdiU9FenVTt4DZc1Qiy0yiUUu1N6iTLfTNULE5ipfxF
    aDWWQdQd6BAUMAgde/W62CMe0OUUyawp8e3yCOkBUcAzWOi1P3cPuHLFm5xEWSh9GxsX
    W3Og==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1793746513;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=c7Qwu5HMJ4YQnRYiZoH48T5mka01qDfhnJmyLJShtmE=;
    b=AuTOxs/JofVYcloCyQH9qn+lGZl5BfFuKsQKePxqLG9QDMK3PP4eBDzSOYtHDtX2Yx
    9y5MENQYOBWrVOk1KsrSNp4xB/EFztSxurP40RTeelLzNImUNzw3W/Gv+z04DloZEUiU
    Z7yVpZqNROdDQH343GJYzpHtTMEt4GqelS1vlWx7CcjYPBV3K1S2lhAH9Oy15LLIMUMR
    BMhXXeFYMkuDaAzPq7qp6yI43xEpJK2h3q1WdMrKuv4PTTAyDlOedASgbMQqkwHEBOpu
    1nquwsyqq6y4BPUAH1UhVBC+KXIC/OW3qLM+FpwQgd029n90W3rMe/dQ+mC/F7r2b713
    Vqgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1793746513;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=c7Qwu5HMJ4YQnRYiZoH48T5mka01qDfhnJmyLJShtmE=;
    b=iZfxCvbk/3Tli0c0HD9ACG5Dyd8Ptt8Y0aAEadj196VCCSBxi6yJhyek4msdVs4+r1
    U2UoHxvz3uYR3z9KOkAw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DpplXNpYf0i2235vA=="
Received: from [10.93.0.228]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2A3MtDsNB
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 3 Nov 2026 23:55:13 +0100 (CET)
Message-ID: <32965373714362be3f3bf0b5960e0da4d743b6c6.camel@iokpp.de>
Subject: Re: [PATCH v4 1/2] ufs: core: skip ABORT TASK for device management
 commands
From: Bean Huo <beanhuo@iokpp.de>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, bvanassche@acm.org, kwangwon.min@samsung.com, 
	hy50.seo@samsung.com, cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
Date: Tue, 03 Nov 2026 23:55:12 +0100
In-Reply-To: <6e40b9a374f50616e84ce1f974da6ec27a79cbf5.1793598099.git.kwmad.kim@samsung.com>
References: <cover.1793598099.git.kwmad.kim@samsung.com>
	 <CGME20261102055315epcas2p4024322466144d1a59b4e8fdadfdbec2a@epcas2p4.samsung.com>
	 <6e40b9a374f50616e84ce1f974da6ec27a79cbf5.1793598099.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


change looks correct to me. It makes mcq do what the scsi io path in
ufshcd_abort() already does.

I read the spec, seems we cannot abort a query task, it is gap to fill this=
.


Reviewed-by: Bean Huo <beanhuo@micron.com>
