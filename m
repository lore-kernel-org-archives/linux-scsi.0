Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795716549;
	b=LI7KeofljY2ofBrneZsn9Ye7H3GA1eBSTxzX4X/CzaPc7iPnio0iRtzDsRdbg2MLPN+r
	 dxHQ8NAVZpkWfFP0/NfwEEQ2ixjgNg1QDoA7LatzhxFk4qxXjGbPk5C6KTUX5dEEhzfbZ
	 afSlw9rsfspobhCOraJaVHm6QviUgqwU7goMwCUpXLy9fMfigvlJ4pR/9ir0mn6MpjHSw
	 YVCd6S2TM1bwDgyS3qyXYYcB+iUioU/F1mOpRFOk6AUNSKEgjkPDezuXuDyBhx7gkFBVC
	 UhToR8mCZPX3XWeH0Pou6fi2I2EME047Dm5eJLKQ1GZpLWuZn8rfJi0EqtK2DUhOWTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795716549;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=D/H2hmBkel5r7PxyanGspqrcmMdjq0Z9XFarNnWPEQ8=;
	b=Q06JdefsxCqLWGmaajNSOCSIxI4JvyUso29HqJpDY3BPYz++D0uonCSeu64C5KTDWsar
	 Hi0VRhidQI2ZEv6hM4zjgQH4G5d62T65Fh/dTYFJ0zoWFSxA8Dbadd83AvdSl9o2EfHWO
	 owaQpghr6UkLUGw/R5308o9PVYdVDBWl4JT1Xd3Sqr2kvPfki0EQNE4R45D0g5oUnlOFA
	 Fl8lm6FC5XBxIVH9uWY0FdyvhWKH8NwFI83s+CrOdwPlmTS/uiHe/mgbOp4eNdaOQXhcE
	 m6e1EHylMxjoIou6bKSdkEMxzWYuTU1AUE4OBgebOxzkLQRiRhUtdXuI4+Hfy+fuY+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=PAaokdy+;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=onydZ5oR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.52
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB102606A31E;
	Thu, 26 Nov 2026 18:09:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB102606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=PAaokdy+;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=onydZ5oR
ARC-Seal: i=1; a=rsa-sha256; t=1795716544; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kFS9IWYeFep1pEpF32GdXXPbX8G0oTPXnVWiosT6GMHOzfSqhQKd95H/xs7tzYsIuR
    0n6I990nQaw+YeiJiA0Ut1IOOotdPN7lS2rnTmZxhp3U5opga+4As9y2xQWhjTyrYW6g
    3KSfgOidZi+L3EDjGLh6vjt7wF+OHsxISfObmlU0MUyFQRvSHgAi+d6guCFqE/krsLaf
    ytPbNfVOeczlebUi1kcY8nx+4vP6fAgjX4bj6Vljsl9gqHgvVcaS7Gzf3rR4F/drLy2G
    FkFuof53bJS9ial8tzKxH99HVuxTJKlAnUggt3UkWIoais+OcCz74PCS6Ltu41GlYmXK
    zOPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1795716544;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=D/H2hmBkel5r7PxyanGspqrcmMdjq0Z9XFarNnWPEQ8=;
    b=liHmrGtS8+1FMhprBsClLXuwSNF/t4WKEemoQdZ9SK6c06KHcFkB0CBNuHZ7LtJvq+
    ropF3QPR9ywUMqMIg53wv5szDxC6Yfsw6BCoSkzDMzIGLFHoZvYMLQnPMJW0l1TzGT93
    5Ql5UrLVI58YB/nftWxKelxaml12p1SCXqKaX/1XT6d0lzX4o/DYelncrfGVbFtdMybT
    cvLxaZVZy6BGBQLFlssWjh6V7FLWv6vVTwM6/1PFksae3f8S3QhHcP826C05GgyiAYw8
    lwaQIccOkEtzbQGS5/c8tqWWQiHj/FXJ02kjhRtfUW8vqNQyBLlLhwWeghKkWKNvl8pH
    P+SQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1795716544;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=D/H2hmBkel5r7PxyanGspqrcmMdjq0Z9XFarNnWPEQ8=;
    b=PAaokdy+dln4icIx5SESUhSfuAidhgx4XCyVTDcCxw97wmdGcqzMfGgsiiDqBGJcTo
    5oYt1hbOXaaDEWKIoV976tkVLsDXjfojldQtFQ+hRi0CnU1lUS2/2BZrsVdx40s+UFvn
    CjgwdYKWUbBd5UXo/Iy4903+mV949p80XmQW5WUJJpx6uegJwCyLoa+Xyhvze+f54nOC
    xKYswvocBBYyEirKLlY77hetVOSib1e+hUX3V6/f/BRFvlF6Qdvuar0qD20l34vLSdtv
    V2NHvoIr2wKjUqjpquiLnRZ+/BDqFxhHyLYhHSUYftW0lzy8wJunV+GZFXK0cWuGzdF+
    EB9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1795716544;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=D/H2hmBkel5r7PxyanGspqrcmMdjq0Z9XFarNnWPEQ8=;
    b=onydZ5oRETOH5Ir4P/Y5nslTmiFk40SYnN4JuwsLyfqCEN+mQDIHJyITzXBxSB8WN5
    aHEI+pz32/629k1LElCg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+/rGHySpF6c+UiLF2EuI+KdD9FHsLX5A="
Received: from p200300c58723293d726ec4ea6d904a99.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AQI93eoI
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 26 Nov 2026 19:09:03 +0100 (CET)
Message-ID: <3ee1e205429612ff8448bae9a1e1b0af11a44302.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: disable exception work before removing
 hwmon
From: Bean Huo <beanhuo@iokpp.de>
To: Yaohan Li <shunsheng1218@gmail.com>, "Martin K . Petersen"
 <mkp@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
 <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>, Stanley Jhu
 <stanleyjhu@google.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Thu, 26 Nov 2026 19:09:03 +0100
In-Reply-To: <20261126111400.2828356-1-shunsheng1218@gmail.com>
References: <20261126111400.2828356-1-shunsheng1218@gmail.com>
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

On Thu, 2026-11-26 at 19:14 +0800, Yaohan Li wrote:
> ufshcd_remove() unregisters the hwmon device while hba->eeh_work can
> still be running. A SCSI completion can also queue hba->eeh_work later
> during scsi_remove_host(). When the worker runs ufs_hwmon_notify_event(),
> it can access the freed hwmon device and trigger a use-after-free.
>=20
> Disable and drain hba->eeh_work in ufshcd_remove() before removing
> hwmon. This ensures any running handler finishes while hwmon is still
> present and prevents later SCSI completions during removal from
> requeuing the work.
>=20
> Fixes: 66ec6d59407b ("[SCSI] ufs: Add support for host assisted backgroun=
d
> operations")

please double check this fix tag, should be  e88e2d32200a, where hwmon came=
 in?

Kind regards,
Bean
