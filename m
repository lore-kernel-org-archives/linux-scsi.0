Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795211956;
	b=TcDM/C9A34+YO5/C8taZRXeVR0yZtBnmh8dHPkCxVhrUU5hBIkL2mBEg10Vc+NBlG+kv
	 Ok5MoL5yBhE+CBmVD7qDC4UQYMqqYCgOs5c/2zzzACsSq46drNR1v0+xL7xfZ0IrnRLPH
	 MAEjZ3/iUXgc2m6s8uefl8R7AKAXWSaa6TWtemQg2yWiEvaUadw+Z+shO0LxKyEZf2+Gk
	 g1cA41qMgQwAXWorwRhP7P5fgidnHIv5VPsH+xnalPzaZ2N2K2GdX4o/YF6mfUg0i/uKb
	 F4E8DiPuirsMhR83fNv3MKGiNLAuqUimy1xeoXc2FzK4x9jnpx8au484L5qPFFLGwzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795211956;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
	b=WIgRHO+HJuU+knyj9ER52qI5x2fx4gWIYPMJZfbaHce0uGI9d8BdcqAwgWkNuaN6MG46
	 KSFwSDGurKpGyrz07ZPCV0J7xRdBRz8xK4Me+haCRe18V8KI4ztK7vNvdwT2T8pdhJu7M
	 gk+lP0peEn+aVrR2TBwaC10ykae9G6zRm5a9iAK9hCXyglUL8CPRrhKiwt8Xqbvzq9ZC7
	 FQ1GrMfVP/11WMk/gGgC55YYc1oaIP0uyKQd9d8gXadHdAfPxZZWa/KwTCEx9uUUTvCX9
	 jeTLg8i1ZhE6OmPDBkO4NT5W1rJHG9bsU2t3KN3REY4gQqBtjZfeM2atwCuoimE48HQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=VAyKOLhD;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=CMQTxvTr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C65606A692
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 21:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22C65606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=VAyKOLhD;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=CMQTxvTr
ARC-Seal: i=1; a=rsa-sha256; t=1795211916; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Hpm+gSaUuezIo10VitsHCTnyXVQZqvEdtUuty9lNrDmVHYccaRPfUCRrY8K3UpKKHV
    OQcXe22OPR+/akTUUThSk5vZxKPRbBYepKdKlywtV3ITci8sEUpFXP8fkBRqIccl3tmG
    TOglaEWOMTLSyk31Bk3EiyV2zFDDvIysgSxT8R5MUk/U5zMswJ8aA+COB+Y82HLlwRo7
    sgd344FPWrCnRvivYzw1fiNwGtVZ3idXuiXgB2APPDSM1FOW4dRe389G26AMH9RiHFdX
    qTeb4lJW/n/nH33p+z4vMfxj5SbYc1hUtLm7W5QgI6ZId9FFK1uveVGMW1Z8MkUCkBFo
    0lqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1795211916;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=npzT8IFS6PegnsV2fDebh0BPqgzZ7VvkijiiBmIbOEpP+KY3X2wReY0Tfzq5OsUtvi
    2biCvbTgHctXs7QSfJb/lxz4RazTskVY8LHATz0RuY+t8UF/uOhuvp+OcNOrdNKpqg99
    ++vIHpBKrYBT+wWxvuCuqa6AUfFUv0Ycl2mW4ge0aB6zt+icBU6ozB5EWD5+RSrTmDIv
    bDGyM2JYftoIMSbpSpuHglw8XN5pB6EzY9hyfaSFdxduIxlaPY6+aFR0pK/3RtpZJV4L
    L8VaR0spbDozxrNtVXVUj8VB4HqOm+16JjE7lwO+qxE4fw7+VLinQA3MNoGoQRCHHjor
    +a5A==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795211916;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=VAyKOLhDI7gSJdq6+0GohWx1b3ZSgpGhedejR7MZIEDVWSzE4Booz78km2OkOOw/4A
    D9/jjW4D/wcLA9GUUkkHIVG68swaUhWoXKrUQLKGP3uHxZKsGs/BQhSXZvR4taHxU5Ia
    k+HeH4ckBYyMmAVQqt8xPuL/kmys4FGedJMMvy9CqdZxtAR8AZ144tPzoX5R/UbQQHVY
    ep8yom06Nb3hNqhKM2hkd/zyoCJK2Vk6OSx2EnOfPhNguSYjMS7LbEvIMjWbE1TrxPuO
    DaVKesmK9zSuy1Y7rxnpZXd9VuxLxOCHSv3LyRwhP1P/f/PMBHIz44JDVDxKah1WD1Fs
    vMdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795211916;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=XU3f8iOzysWsUXprwUt22rCfRKOt8VzIxFdJ24lS6Ew=;
    b=CMQTxvTrnXpJMX3TZG1kWdJdtVjLCWRmT1UniTqpGSW0winRyF6Qojtaqw0e3QxP7f
    rbmrOha/DR94j4SpowAQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+/OKHzX1C7s/rmDeKaiuTMh4fPkN3S9g="
Received: from p200300c5872329173e1bad4e5fa0c087.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AKLwZIoe
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 20 Nov 2026 22:58:35 +0100 (CET)
Message-ID: <8ea453c9596b0086937b11ecddd93e981553d8fd.camel@iokpp.de>
Subject: Re: [PATCH] ufs: core: Remove the DMA addresses from struct
 ufshcd_lrb
From: Bean Huo <beanhuo@iokpp.de>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>,  Peter Wang <peter.wang@mediatek.com>, Bean Huo
 <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>,  Can Guo
 <can.guo@oss.qualcomm.com>, HOYOUNG SEO <hy50.seo@samsung.com>, John Garry
 <john.garry@linux.dev>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Date: Fri, 20 Nov 2026 22:58:34 +0100
In-Reply-To: <cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
References: 
	<cc98d54dcd4a98fead25db50c5c6aec2dd65d595.1795135853.git.bvanassche@acm.org>
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
