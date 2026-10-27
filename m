Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=85.215.255.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793124780;
	b=Q14U67MBRnh2VYc3UrRMjjRh9gvD8SwF2yKdqafD6Gk/eIQNdHrXg03LTtcV2jXyx5Xg
	 zmcHwmVyebcWpa+7/xJpsis4Lr20UyPev6vCiBqclb57S8/Gb4veApwq4llsFpvtgfWuh
	 sAcPHKJI+pDIhlTWGHg4EnArxeJZrkrj8KJaaOvMeBhOu/JdWeHwepIcTTHe9F4/DRVJ1
	 LRkc0u8Gx0ydDxePdu1VceEXFcz1prl1tYDtDi1A5A8E1NGpRhkxoyW6MoGrIL2rhO/9g
	 DPKj326Nrh+RH3H7wCf309j/neml/nnRiUWQ89Brstu3n64Efoz9XVa9elszLJg0sdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124780;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=9K0cHhogjFGdzGmlyT7TpNjKvBBWzvIeBsJB7+bteoY=;
	b=Ax16ckMd0FMS09aeDGftx2Akky+ToIqZhovl8GQtQAPaoXDYd+C1XAxscjetXoFxsjzs
	 RhiyGf6o+jsCyyCIIGIAb825vZjgfrl4Om+UrwoxwRfcPKMHSqUWdQpV+YaPUVJ9TiaG3
	 kIqtSF+dNh3Ru/D/DRlZ4neL3zuL4rcph6BIPkZV0CVOLgXRRxwRiOgfQOT6UVh7nipNR
	 HypgdUMuiyNr09n6fPCUqUPZW1Rrfbjbc4eldE/oV0gZCrSu+5D876gTwaE7LguOSwegg
	 lypunK5djRXFh8n6TYiBxocgdKQhP2DqZK1Z8nGJyzzgLL1k4uiWxTBcWglIUnangOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=n2jbAlcY;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=egdW8twB;
	arc=fail smtp.remote-ip=85.215.255.51
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C9D606A31A;
	Tue, 27 Oct 2026 18:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3C9D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=n2jbAlcY;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=egdW8twB
ARC-Seal: i=1; a=rsa-sha256; t=1793124762; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=PIoEo8fub/GpGERjlGpouvvVB8GpP7cdZoDkfCzVh7oaKbakx6rtgmoQA/G0e0566e
    RDHf3OiSgApdYiFkO4K+9JFV/XyD5oJxPqkzYNtet/Iwnf7uRWaeqbi02nh6+gOcTEGS
    +16ntBlFtQAJzQ+6z+AWT3bFRHrKn/Ne7WZT43DJigqhxnPaPx+ffInwFdb9jJWgP0tG
    8EI8IBkGp9yel0qKDOAL1abnzMjCRPfQxD0tHBb7QMmDpbvATRmPAA6yugQXYGPqbQNr
    OlhdG88CEtoyw2xDmxpzWC6Uev+jkNQWGuSQrkVb24gf0lmajHuD4ujP6hAfk7eXK03c
    piqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1793124762;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=9K0cHhogjFGdzGmlyT7TpNjKvBBWzvIeBsJB7+bteoY=;
    b=dwutRWKLncdhHyX1EGDYs9rmfTtQzI4XIPskR/LgP7IvBW6z7ck0f8vV5ZcYYMGkrW
    bj/Y+MR3Ogs9nDm5rT6PYKzgg6qQqnlkc3KZSFKDZXutQUci61ncJLUGT0PAn5072xmC
    YOYAIDUsXegwFUbv3BlqTEBS+Ao6Ajwvre5cRYybHgLZpP6n7rtRX3Ia0IT9uCAvKjjc
    f0w8rXhJqLD2KrJjVQ3C7a65dGVSatOOK6agHvYujaPymyvrwJC/VmVNOn1pfRZrIJYi
    1J/4EiJP0BTVxUJBfOZLYGcV4qT1FG3t5PFhLEDmpxzAms055vNsMuyTHQy6qgYhm+jk
    /a4g==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1793124762;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=9K0cHhogjFGdzGmlyT7TpNjKvBBWzvIeBsJB7+bteoY=;
    b=n2jbAlcYTcjr+S2o3wo+mRgWFTSYQGPZovPk7NZjoBylSEXoxlJ75k81J84F9sCn/K
    esGjbVW2E0c2iL3+ZrHJvC5TUW4Vng/E279lLCeUYTR1Heo6RucezoT6pQt9J6VuKtwm
    aTTSmSb7Dx884gWN7wv+mli8W/BykMQWYSG3DUE8+VE5nhZGXm2jIyRs5GYB/0fXGdsO
    IpEr7AW1ZicQ2R/h095hDcu5eCg/ehiwiEyYvo9/vfwr9oSo8hSgsQ+cZNXUZWd+vjfu
    MBHz+W49GnLLjnKELbaYvt02kMiqEPEKk/TDro9ewpwIVG1bQgZtjM51z9GOBdji9hEv
    czEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1793124762;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=9K0cHhogjFGdzGmlyT7TpNjKvBBWzvIeBsJB7+bteoY=;
    b=egdW8twBSUfAwmSUUlzcedi+4pG0XAEow8WgPBhFmDylWAzgkz2+71kbAM86xkXrbr
    Wax23uO52XvrOFSKN1Cw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZyk"
Received: from [10.176.237.181]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29RICf8Xg
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 27 Oct 2026 19:12:41 +0100 (CET)
Message-ID: <112238206a5698e8766528c2b6d4d3e208c28d71.camel@iokpp.de>
Subject: Re: [PATCH v6] scsi: ufs: Change the error check sequence for auto
 hibern8
From: Bean Huo <beanhuo@iokpp.de>
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
  jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org, 
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com, 
 h10.kim@samsung.com
Cc: stable@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Date: Tue, 27 Oct 2026 19:12:40 +0100
In-Reply-To: <20261027110357.3649301-1-hy50.seo@samsung.com>
References: 
	<CGME20261027110813epcas2p4011de6cde600db5c995d3a3e45b056fb@epcas2p4.samsung.com>
	 <20261027110357.3649301-1-hy50.seo@samsung.com>
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

On Tue, 2026-10-27 at 20:03 +0900, HOYOUNG SEO wrote:
> Auto-hibern8 enter and exit are performed by the host controller without
> a UIC command, and the auto-hibern8 idle timer only runs while no UIC
> command is outstanding. An auto-hibern8 error (IS.UHES or IS.UHXS) is
> therefore usually reported while hba->active_uic_cmd is NULL.
>=20
> Since commit fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl()
> easier to analyze"), ufshcd_uic_cmd_compl() returns early when
> hba->active_uic_cmd is NULL, before ufshcd_is_auto_hibern8_error() is
> called. Such auto-hibern8 errors are no longer recorded in hba->errors,
> so ufshcd_check_errors() is not called for them and the error handler is
> not scheduled.
>=20
> Check for auto-hibern8 errors before checking for an active UIC command,
> as was done before that commit, but keep returning early when there is
> no active UIC command so that a NULL cmd is never dereferenced. Only
> report the missing UIC command if no auto-hibern8 error was found.
>=20
> Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier=
 to
> analyze")
> Cc: stable@vger.kernel.org=C2=A0# v6.13+
> Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
> Reviewed-by: Stanley Jhu <stanleyjhu@google.com>


Reviewed-by: Bean Huo <beanhuo@micron.com>
