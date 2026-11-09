Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794238174;
	b=VY7gLKeF3YMdCr94KqbyPiVaFHqzeYe0d9Q9Z+GrU0HcuUfvYLV8/Xs3H3sdEwFxWvPx
	 uvAP9JAgYSltmlwOkSDw9WJWvlcifJwEV7e3TsZ3q854lGp7Y7hMQpdIRWluUC80zz2nY
	 JP/5tpaX+X+yX+C9f3CldhiV8oe60do80df7cezJIvkNQ7RyCgMI/Wu5z17nPi9vNvUca
	 AC+Ijrj+NqLUyWvxQXHSnobUAi7ca4zqDogNQTdG19SJtqYV3veJSypv+aW127EHnLwZC
	 3nqps3g36Rpn+6HrLFqb9ekby1O9c8fCuwlsI8mc1cKDivcC5wM7UZdKew2oTxfTguQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794238174;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
	b=a8lJVSELNSi2ir0norPFIYBdA99IS9HHCbdVhwP9Lglg4dfaED8ePWOOQyvBItKPeRK0
	 4Ys5QoGTaPkJpXVaPx88QdVWELNf8PfjGvtTETuN07aVUfjVijIt1oTczuNmWhcKjejEs
	 xMf67VcpFgSUUlmHV9/8jehHIgdmeHKrMl9zWoI6+x5ElmdkPSnNUL1hdXuRW9iA41mDV
	 iudY741C62WOImOXBZC+x7Bnknjjv/V6Kp7SUIc5DpgD9XYk66Xw+w1XaPMd13ufcWuNx
	 Zuw8eh2DmTnwOdU14hQ1dQfSadoKLMsB+hOOUTrg3z+3v/e18XOgfevEk+napcwVuRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=OqlZYnEE;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=24bjRyDW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7AF606A31C;
	Mon,  9 Nov 2026 15:29:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A7AF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=OqlZYnEE;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=24bjRyDW
ARC-Seal: i=1; a=rsa-sha256; t=1794238140; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=NOTMaKuTbmhqhCpv5k1b1DHYrWuDuUkPBpXZRWoM6b8SmgafHS37lOcuXResm0eAe3
    GFTTaoDLhcUt4WemdAXb5SeoI2AkpSmz1qQgGsv5Nu14AeFDJ2wUHTAVLyXtDgMFSNhc
    uJCha+Onl6YPAI/S68oX6fljoLmu6EvDjlB/znumAQXIne28MWOfIa4Ygwp+/w0f5rcg
    t5g/krGEqDCUzyAVpbJE069f/HkvOI3SdXn3hB1Li3fY3GyB0Ov4bwJpzbP2qFgVfARL
    JZVYNeDJsC/RygZ2XKtnxe7vmRDqE+6MKJNM79DO90FWk+sN1AR6/i9EqSnmrYF57MLC
    jTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794238140;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=d4fSN8lAPxk4OXQd6x9vPZgtjDmnUHrc0Tr/4VJkZQmod/b2FNsadjt+ZqLMHS0+0n
    994jNuKoKzrmM2QXCzL4/lWExsdVtBVYXcoj1Wwj/4B44xnMw8s3CjZigMsY4/6hZTzf
    gjUcO834xwuaVPHP5qoCGLfmRb9Xnxgt0AVFMEEjIq6W2xvO9SJ3Tc21ip0m6zM9QC6u
    V4SLTsGDPSdkjmwF8wTXeDW8+Hjc1CGZWwvrsCcVHqcIeeGARrfN10UrZR/P2oea5aSu
    1Gdl1hDo2MOCfFpzNoCrQJw4WK2bekBB5J/HOlZLJQU1gBKy1jNrThmWp48wui1Vr4Qf
    UQXg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794238140;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=OqlZYnEECVVdhZx0fKX1OZFaDBT6z+U8JRvXPdZraMOEfq4eB8E15DlV8sS+i5TN3O
    LKStF8H72XlqM34J1S2HDfv69ppIiDYVE5pUK12hYQd/o4ffs08kHgqzW95m25hDLxCC
    /3WNdCUoCmiA91XC4IjLIWXuZuLSP2mqqHZv7fHZD8IgaWGoYoqlBKhfT2FtRVXnCnxs
    PoIM0YnV/8rk8h+iQGW8yncqnkJK+dVZPkkukL/x+Q1vZz/DAx91hZ9fW7nBT6SE+Jhr
    eD26BlO7KZ2O0czfvL/I6BtjrAlGY5R1TdX7ipINpe2nvcitkhM0b75RPBGOufISaDtt
    leTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794238140;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=24bjRyDW+Ah057SAUJSo7hd9pmwMI96PI3xuSNjd9/EIE5V+h1yNIK5/MdZ+npCRS0
    1JbUyLQ52jT+K0qYK8AA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.78]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2A9FSxWhm
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 9 Nov 2026 16:28:59 +0100 (CET)
Message-ID: <dd6f1be598ce31e732100a641f7598589bcc1b32.camel@iokpp.de>
Subject: Re: [PATCH v8 1/3] scsi: ufs: core: Clear saved errors in
 ufshcd_link_recovery()
From: Bean Huo <beanhuo@iokpp.de>
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bvanassche@acm.org, mkp@kernel.org, 
 martin.petersen@oracle.com, stanleyjhu@google.com, peter.wang@mediatek.com,
  alim.akhtar@samsung.com, kwangwon.min@samsung.com, kwmad.kim@samsung.com, 
 cpgs@samsung.com, h10.kim@samsung.com
Date: Mon, 09 Nov 2026 16:28:58 +0100
In-Reply-To: <728258269.41794200283102.JavaMail.epsvc@epcpadp2new>
References: <cover.1794196863.git.hy50.seo@samsung.com>
	 <CGME20261109041346epcas2p403d660b62bc9f227fef868e8b19816af@epcas2p4.samsung.com>
	 <728258269.41794200283102.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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


Reviewed-by: Bean Huo <beanhuo@micron.com>
