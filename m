Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794868098;
	b=FzeRaeNeU52YY2oxJRP68cYPNZfGFS38XEbWEG87Q+eZ253cdJ0kGhdZxaqbEpvKeqgo
	 HG8uoyMJyuCPxBhFuhLgBdWOUCrhmhCztovySXFk8kprQ0u7HbDfkIkVzSq4TMdNoz2PR
	 x8TQ+nxY2MWA2NDb5tZAqmewZhRc/qQTULhIgkwTdlKmDv8j7n2hz72IBQPRxhw7BcmZv
	 +1p3UyzLco+bhZDdJCTaYc1romCt/7yScuxMM/IVJqmBwyuUZZ2FJMtkIcuv4vPEOwgii
	 LPOhA58pTD0crdvv85YPr9sR+8Wt0aIxfZijCd1KUtP/aVGH6Xx/vFH7GIVh4JtcpbQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868098;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=nMEldotVBDeIW1Nog+eq8zv6ICQMv55+W3dI9uF/fAs=;
	b=DlU5IJ55muqBDBErqB9+yD4Pr0kDT0BU/mZERfZc4LA0bnHIonb7s9fIhspH5L071gA6
	 G7xy0bjCXQ5tJ226NbDATxHHLf04gq7AF36vjT3vpMaaxSO3N8DvXdDIZk0YTFsoRd2Zb
	 br1Iw3hFcgC3xzcVTPk/yKeGZzKQzgf49pOQZ0FR1i+J8Umgt4my1jhVEDNuqRSR6VvUG
	 fnvkkzDG0DOOD7ibq3N+GsJEhcAS/ZeBQQpDeczOkzGBx1jiSq6GGQbuwUCAN3TPLUBHQ
	 i7TDFkuVdoK7SuSCjLNVujq9CA1CxhuWMfqm1OpUgUlgItDAvRolcXx6mrAUgKqSg1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=Fa9C4Qm1;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=HISLbBoE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=85.215.255.53
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6942606A8B0;
	Mon, 16 Nov 2026 22:28:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6942606A8B0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=Fa9C4Qm1;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=HISLbBoE
ARC-Seal: i=1; a=rsa-sha256; t=1794868072; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=hS0VlyNiwyy+2S/QXUX+nKra+p8jOHNbQQqKHJuvE6Hmh/B/jWW7f1U8P0ypkzEzAb
    YIrcU6WTfOnYDNanrmev4sju/cY0cm9E9Hmrvid6KUEAfo4+9/FNUPN4DnQmNAL0bICA
    oZ2dTTjxG0RYM7BTue54UmwniuzMTDL8UTOl3cBl72DO34yGjQLU3bGvHVhWBd1VlHu1
    bEXUvv1UAO+u48D6CNB1dCJh+na3zQnxe1xu3Jk7JGxEw72Hh2UvoNJsbQagnYE0SW70
    4g9nRI2UENZ9inYTwT/tEeQSkktFoKs2u6GkMAwymq6E46QVmKgYS3drWfwJPnD+x6Rf
    Q6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794868072;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nMEldotVBDeIW1Nog+eq8zv6ICQMv55+W3dI9uF/fAs=;
    b=Mx6g2aSDpkLNb1J4Z8g2CYwI+nUlkZ4kX99Pga+wwIVw6jlTZgd3SGVVjZDIzgZFjP
    oWQsJEtqjpJHCVvBVxZ8VDh530QoHIUcmkrNRXUqd0R4KRw1ZEscItgF/vKAIQiheoNU
    nvf/QYLvh+W1yIOjBj9rR32js0QeR+O4P/HhYVDdznTToAijlUjrazRi7jutj1iPVSza
    w7XDT5KRvOwCnTFiJrngjy0J3Il5OBBs/l3T0UEY0I8Ws8BFZ3wzfHx0dyKSl7cq2aAk
    7fOcvm1e0ahdGvXbbyVRNHc3e2jC3YjkffqYPBUwkGnMwbLcQ0X8wF6PFDcEjCxN5a+F
    jWuQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794868072;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nMEldotVBDeIW1Nog+eq8zv6ICQMv55+W3dI9uF/fAs=;
    b=Fa9C4Qm1OSA4F7pR2dnwAb3jDBfctq0fCu0F9IiL+tfjSMybH72MDPTJZ7Cmxw5gHx
    F2zcsDC0DwO9wwVL29LrA1+qfBNG3rSgK95FqvU+3RTeLcFI1SJEuTx9dc/zMzmT+UbI
    /SArBZThNXGG+WJm8VDJiQsfSO+lOKGVKQoHrpw4ysZuYGfinTskL6amvSFs9U8YAb4y
    Iq0cyPAC6mkcJeA7+r8RXEgsA4H1bpe1dDpelDU7DLVVqwTytzZXEzSRePs3FqxKoZiZ
    xWC654uhtMhKR4j67kffThJQKvIk6I7TljnLAe2pNTYhUHxgUKXnyliceRs8gqBngASq
    PCfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794868072;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=nMEldotVBDeIW1Nog+eq8zv6ICQMv55+W3dI9uF/fAs=;
    b=HISLbBoEvdOteLHTe+Jpv7eemsdK2ZoPREubl/zP0noMLuxeIX5SjBMbnaC66Jv41v
    SvPHo5RBHprCtA6sPMAA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+qLCHnC0WuM9jddvNMU0JC1zy5+GPNw=="
Received: from p200300c5872329eeb5e40ea9b27a9db1.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2AGMRp06w
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 16 Nov 2026 23:27:51 +0100 (CET)
Message-ID: <780f3f4ceacd7cf078542c9a8a4c8c8dba9666b0.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Use ufshcd_query_attr_retry() for RTC
 update
From: Bean Huo <beanhuo@iokpp.de>
To: Enric Balletbo i Serra <eballetb@redhat.com>, Alim Akhtar
 <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, Bean Huo
 <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, Mike Bi <mikebi@micron.com>, Avri Altman
 <avri.altman@sandisk.com>, Thomas =?ISO-8859-1?Q?Wei=DFschuh?=
 <linux@weissschuh.net>
Cc: Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, NXP S32 Linux Team <s32@nxp.com>, 
	linux-arm-kernel@lists.infradead.org, Frank Li <Frank.Li@nxp.com>, Larisa
	Grigore <larisa.grigore@oss.nxp.com>
Date: Mon, 16 Nov 2026 23:27:49 +0100
In-Reply-To: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
References: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
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

Thanks for the patch. A few comments:

On Mon, 2026-11-16 at 14:39 +0100, Enric Balletbo i Serra wrote:
> ufshcd_update_rtc() uses ufshcd_query_attr() directly to write the
> bSecondsPassed attribute, making it the only query attribute caller in
> the UFS core that does not use the retry variant. All other callers use
> ufshcd_query_attr_retry(), which retries up to three times on transient
> failures before escalating to dev_err.
>=20
> This causes spurious error messages during boot on some platforms when
> the write-attribute command hits a transient OCS_INVALID_COMMAND_STATUS
> error:
>=20
> =C2=A0 ufs-s32n7 4ac80000.ufs: ufshcd_query_attr: opcode 0x04 for idn 15 =
failed,
> index 0, err =3D 15

this is printed by ufshcd_query_attr() itself at dev_err level, so it will =
still
show up with this patch. Could you share the log with the patch applied?

and err =3D 15 is OCS_INVALID_COMMAND_STATUS, the value the driver puts in =
the
UTRD before sending. So the request was completed but the host controller d=
id
not update OCS. This looks like a host side problem? not a transient device
failure, and a retry here would only hide it. Is this SDB or MCQ? Does it o=
nly
happen on the first RTC update after probe?


> =C2=A0 ufs-s32n7 4ac80000.ufs: ufshcd_update_rtc: Failed to update rtc 15
> Switch to ufshcd_query_attr_retry() to handle transient failures
> gracefully, consistent with every other attribute query in the driver.
>=20

ufshcd_update_rtc() is not the only caller without retry. ufs-sysfs.c, ufs-
hwmon.c and ufs-txeq.c also call ufshcd_query_attr() directly, so the commi=
t
message is wrong.


> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")

> Signed-off-by: Enric Balletbo i Serra <eballetb@redhat.com>


I would like to understand the root cause first.

Kind regards,
Bean



