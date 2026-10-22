Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.166
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792704231;
	b=LAwt9qM25IEhx9eAKjgzWuoxF+F7kH3MmrvR7DKbz6p2oIijUuRJW2DNfLb7daE/5Ahl
	 KQ/3V+AbmbgfjE8aF6LOhO/DVOvCUSYKjY4SrSzZ4cqtTDX351i511W91vyzU8zxuPbl0
	 FHfXrv6exybPOQhc8a5/fWfdxAkEKNXb/n/MqJ6YTBxF4rbCWWkGRRE5dkmTzyY/HU5He
	 c4Cc1BKBtDU5/W8R3UA7oeJzz1aTt8PAaFYCwubpuM748aOaOVJZp/VTujJgpM8txCwC7
	 pJaqXPBmj/I3UbwaLVHFj2+7W+ivQG9TE50ogea7BdjBulmqkqrlHC22qL7rpMGsNyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792704231;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=MA6yNba+DMwUFzdXWEDk+p3oc8MUkL4WqBZ+UhGsLhk=;
	b=1EucBhUBgmDXBczQhFgRDE6GK6s21nD8tW2OaWgZYDwOi6PjjpqnaK5Uk/Yo6HtKMzoA
	 6nfb+nClcOtkWMt2FpdtT4Xf6FYxdTee1/TuADaiqlAFAr1pvJ+3VbotX8/xsln29ZhQU
	 4GcRBiyECXMcRbUUOkp3U0AwF64Pp7o8liRlnzMJ+SmpfLNIC97J1v6ypIG39vAQ8+L61
	 3gpV5h2ZyZygTZqFylerdGmMnW0XUnVgScqzAVcWLaWdvASJAQQ0LABiel/KbflzEbFO0
	 oeRYkpV6M7NXgx9qKBXs5MNHmusNTktHZRuEZGbAit2x2lXNz0Nogv53o0fC/aqaKdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=nKIPlgXq;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b="jmBB7ut/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.166
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF225606A319;
	Thu, 22 Oct 2026 21:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF225606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=nKIPlgXq;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=jmBB7ut/
ARC-Seal: i=1; a=rsa-sha256; t=1792704197; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=dt5UeZo4FDQw5VyoMsTQPQjw5G/Tno2yFVwARufW2iaFJFx/+MXuyozbL1/ttOcRUf
    tCQoaoFvN9ofdJTxMJBdpjxUrh8ttNJyzVzo/NbFGo05yYPxQgXJDSlFAq1fUxoSYZgp
    GgtXm43StAaVUmjTm3ba6543qoDTdIw7SAE8rUiSGgO/pfZMTKCFM0WkNsUfBXXi/YvQ
    gsDPNO7BURfOwwvbLs6/Q/vGVUdYVOIoOaNWrmGqzEn4Cl1vRtCbSn9BaGSQmk3UMFsN
    V2rFG6r7PhOHWTv2lM9ylj8VxLPY8dE38X4t374W4l5lsDhazZhK0YX1p6J4m7GM6RQZ
    rCOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792704197;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MA6yNba+DMwUFzdXWEDk+p3oc8MUkL4WqBZ+UhGsLhk=;
    b=JX91JLX7grLiJp2+DDCcSw4nJhAYzbVjrEbBXRBa70qZReCSBLUZfP+omTgTBYjDM4
    IJ8nV192ROvWv6S2pVY07pQi4y/fiaKqqKL9OBJJNMoFDjxchbSDZAM3qUIuDsw0oqVv
    2kwQOJiTBstfez2qOTJ5hcpSq6NAKAk7CL2ZzuAoOthN8cAvA+xTI1CnOASvSDhxrDCt
    8PfhdT8F11nxZd0BXQIlMNDKR/gbjgtrhxMryTNYNQ4h+jfnHoFQhROgP+9edsLTjM+6
    SLM+b7YnWQYhp7P9o2Y3LtgoUbjCULByLxsHuOgKXYmL5gs487Np5KaWqcmnJFN4hFhd
    Meqg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792704197;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MA6yNba+DMwUFzdXWEDk+p3oc8MUkL4WqBZ+UhGsLhk=;
    b=nKIPlgXqkWWBG2h4i8wRl17vQQSdL7kT8HDAmVto55xRsNuj3DAkHTC2KUaXnBQ4su
    mSuKX8n4VSbliUec5DQP+SztYlHkBJIWb0ha2oFVnqU3i+E1Le1vtC1x0/VEevqx/al9
    x95q2YuuWi4HuSCRfclChL3FZOXaGR2Sff8dMJVsMgfcbK/CBluCuKgqSY++vbCsArXA
    h6SUjbniVi3AUF5aU7XbZnU13wvUuymWMlyWZc5zvVPQj3KMTnYmw4zYMC0Y/TCOeztO
    wtHrwOGuMmqWQf1aTjzHPGvKCWXyKzPdoyXS/FELAG8sYLCQat0acD8IRHrN+t0OndOk
    aDdw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792704197;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=MA6yNba+DMwUFzdXWEDk+p3oc8MUkL4WqBZ+UhGsLhk=;
    b=jmBB7ut/7w3fUbgKde4evQbHOA5YuSApTMWfX143S5yPkjipxjgIU5InTwaXkIZdCi
    kQU8odNbHY+5dBnWg+Bg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzMgm/NRnJ8fYgJntd1oEF1C773gkTGOc="
Received: from p200300c587368407ffe3ce4a1bcc928b.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29MLNGc7V
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 22 Oct 2026 23:23:16 +0200 (CEST)
Message-ID: <52d853186efd99a225649143ea5e6f23f63cdb35.camel@iokpp.de>
Subject: Re: [PATCH v5 5/6] scsi: ufs: core: Remove
 completed-without-interrupt path in ufshcd_abort()
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,  linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bean Huo <beanhuo@micron.com>,  Peter Wang <peter.wang@mediatek.com>, Can
 Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Date: Thu, 22 Oct 2026 23:23:15 +0200
In-Reply-To: <20261022034443.3034432-6-stanleyjhu@google.com>
References: <20261022034443.3034432-1-stanleyjhu@google.com>
	 <20261022034443.3034432-6-stanleyjhu@google.com>
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

On Thu, 2026-10-22 at 11:44 +0800, Stanley Jhu wrote:
> In SDB mode, a command that times out right as the controller finishes
> it can be completed twice:
>=20
> 1. The command times out and scsi_timeout() schedules ufshcd_abort().
> 2. The controller finishes the command and clears its doorbell bit in
> =C2=A0=C2=A0 REG_UTP_TRANSFER_REQ_DOOR_BELL, while the completion handler=
 has not
> =C2=A0=C2=A0 yet cleared BIT(tag) in hba->outstanding_reqs.
> 3. ufshcd_abort() sees the doorbell bit clear and calls
> =C2=A0=C2=A0 __ufshcd_transfer_req_compl() without clearing BIT(tag) in
> =C2=A0=C2=A0 hba->outstanding_reqs.
> 4. The normal completion handler or the logical unit reset that follows
> =C2=A0=C2=A0 sees BIT(tag) still set in hba->outstanding_reqs and complet=
es the
> =C2=A0=C2=A0 same command a second time.
>=20
> This branch only exists for a rare corner case, a completion interrupt
> that is lost or arrives late. Remove it to simplify the abort path and
> leave such a command to the SCSI error handler, like any other command
> that cannot be aborted. The cost is a slower recovery in this corner
> case, which is acceptable since it only happens after a timeout.
>=20
> Fixes: 169f5eb28869 ("scsi: ufs: Optimize SCSI command processing")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/fdb5c391-01ef-4a23-94c2-4f3853909348@acm.=
org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

