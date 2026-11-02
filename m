Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793621196;
	b=lYoyjnpIXBAgXgR7Q4H/9Kt5ysFrK2HdDBsc6p7/qS4Q3CNv9QaHHR8Rln91HqBnwZfM
	 B48B6wvOXak4WwdNjLxhfTySyg57owL8xErw0b5l418YaViDBpVBmCpxK0orGJk5FHQ2l
	 w1jAxwNfa6nR/NjAvvvgyKzy7UtjUkiNQC6b4/efojeXbXROrpTDS7AzIQrFRrYMqJRVM
	 URUlBbSBcpOKyWBG8Lv8di3Yqkuoy24KqcZ0E66uYDEKxFO6WnYbMp1dA9UHW5r24GVEl
	 7i1M5vaxoniWaGvYNEhwSzLb35aJdbE7n1ToCDaeVHfFWGlip3k4tzv/sSE2dtTbVbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621196;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eYYAgvOyCzdVrPakjdZjdVAofrBzwkkeALOxwuI8D6Y=;
	b=bXXT0LAk1+DyNngcAIFaE7fPsZ3BFzfQVbsPqiseS3L+H+u//X5+s3ioSX60RbzTTBi/
	 3r6+FwtVawXa3thmetIgtgpxBffnvbWhWAA9kU8QVogCSddra3Qm5O+0aOIh4GMbbUZgP
	 bT7KYWdo6J6g7b5tBoZXQGtVGac5aRSL4iEZWVVwjnfo3MYUOaskVRuo2N8sTnYoM0Tsk
	 3rwiUXjPW/mYaefgiW/W5gAz9BtZDY6+b9gkNEHD1UhMtBLgUCK17+LE2og3BoxSax4S9
	 O0WyDegfKiIV2wwNHCtYj34r7WK2w1mqybYAxc8uNkOBmmUctxEOEXvv6E29ySYTBRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=YD8CPRen;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51041606A326
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 12:06:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51041606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=YD8CPRen
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so4690360a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 04:06:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793621195; cv=none;
        d=google.com; s=arc-20260327;
        b=MyTzrt11RIgHdzHGSUZ7PGe8597P5tk1veSYE0ELR46vGIO1ydlur47jAfM67tAVxn
         QY9vKLqmt1AvoxsyNfeUEjj8K2iYsy5pEfSeyJhie/W/9+qo+NO+7wdJdrYE/0Ssgwzo
         NrEhsN65iXRHovlLq0IsTFjDdKRbHqo5ki0cQVHDboa/BNdiYG7Cn1u1T5YeRi6RX1H/
         KkJAOYIHuIYJPytK4X6LShj2k+RF1OEc2aXctRZ1K1OXHRLqWTn8uo7/wCnA01uOWmaa
         eTBIHv8Ncvgp2y2z0qeua8CAaVMDQ4xHELvxwR+SwLq2R6PIqPX9FIUbpr1BbAAfYMFV
         PlFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eYYAgvOyCzdVrPakjdZjdVAofrBzwkkeALOxwuI8D6Y=;
        fh=rGbss79s38JIrh2dPfG9wAcGjX4cJjAFdwiTCMHd0OI=;
        b=FygkLeaflOBd4OU3lwrp4m4pToXv0rg48gLi5zcuKcD2vKZXiTNXk36PwDzvBZZbfv
         zGZcDqxjNMo2AMgFt6udmVYcZUHr5tPPUrf7NezCc5KbrjPKz/MSVTytQnF9mL26xXle
         vQeFyN2XrkAfuQP4LbJhZPiXBpeK49UoupZ77gWr+r6ldDX+iv86j9QP5RWF5GtR1Qz2
         b++CSH/bNNFIMlsS26EsM349gWzx6lr4wI22e6J1Qt+ABaVp0Jb4IaTkCfnsGbo746gR
         HG3iqr6Q5k/Du8GRgM74dFeYU2PF1I0w3KY9kCC6Jc6CRKT73u7ons1jJYoEruEnCV9/
         7NTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793621195; x=1794225995; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eYYAgvOyCzdVrPakjdZjdVAofrBzwkkeALOxwuI8D6Y=;
        b=YD8CPRen/8qaCeHsds+Eid4lzVpSVH/WQcb+eMe4MMh//G5Kg4Z7M//xqPhNkXSMS5
         X7EVjvqNxWq7l+vzpc+itPw1kXcQVAnUQHlMhOimkrr/gM3QlNCn+4XUQhNDM8Cy9YCW
         zpzMGOr5B4kMTd2kfQhroBBJnxxN20XlIm1p5xeayQArxZJoxFR0PS3rZ4hCffsGFVfu
         z4r4SjBz6bpVzloct9fNV1DYlirkPl3dUHR4Hsa/MjYoqnGMcU+xU1jAojvWF9wSIvvm
         zcTSO2I3BlizaFXiItumNNmBgyRRlOeQd23Gp6Xgeeio7U3vP4J09gJ48H3ZSXDw3J/S
         e4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621195; x=1794225995;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eYYAgvOyCzdVrPakjdZjdVAofrBzwkkeALOxwuI8D6Y=;
        b=LioPh/IB0G5665GFX4tjGByeN/ubpMmCM3wwVxiLCAEmnGj/zaNUBsVE8Ym0+qwlFh
         Nef8/zhb61qBf33Qt1N7PKXTKNw0eRBL1BoD3ep11+BJhhj8xO/J0pwVthDeKoH3vnaQ
         XBjOi1H6E2zkxjB3fvilMdGq4caRKuXz+1gPUUAKXCnk48HdxNSQumJBM/qJ9hbHrsBM
         vVvtOL+1TSxZtZeF+cYMa87vd69/1UdutKFdqElGj8ohYATIzQt9wQmDS2xDPRTkgUOP
         wN8TwHxqdN5r9oU95+0qLkmYRCCV2+IJ/7mAmpmjD45JGSKVPZRY/D6v6mRFnpcm2rUJ
         J8qg==
X-Forwarded-Encrypted: i=1; AKwUvBw57N0X/hiTivynmX20kZk7rMXCL5r3R7luS4yxL8DhBX3YA4NQvAnlDovwFklNzTlh6jI9RBLEdfw1@vger.kernel.org
X-Gm-Message-State: APuU4Z/21jygL61Zp0Rf3elnGH8VsoOE3cKuIOj3Cf7ZBFeKmK+SJyup
	TsKRiXzQep0C13+2+okTwpQW0Id/qeozFKEw71Mk1nzA6q+xpVDFz3kYs+aFl8pMiS5v3KmV515
	QTQNFxEF+Z84C0hGy9MDodl/Bx9FBBXo0bJyedImQSLyTHZZ98M7xvGDbIq18
X-Gm-Gg: AYBFou3BQM0xUbW+qzpZx7RrbzagCdOP2mRbZcahGzTjU2Wt7d98SZgh0c1j9UrjLWu
	3YDSzU0IGc+cbkjKMDAbZjAxIux+Ec7YiNe3YX3nQyCjBhJv2V4oJa1/UqzWV4bwZsAXvypoItJ
	o9QD/WPm3bi9PvmprSGEpr8oWBl8/pffNTD7PpQLFG607amL2Fn+2dkP7Ln10kxamMVQTqOyOZf
	VGpOqg+LMFfc1hIRS7rNREJKl3b/zpaJqqprFwTAQYjbA4WW0b2GZcoKNLY/BKIsqqH72IrFcyB
	mWdSR2T5+3LmWrQYy6RYhU+nL9JCTSRiYTUBpPjVmjlcoxGukF0KOGT9EZkTLtPz2I4r0bKUgjh
	YlLAhecCugaMFvTjuY9cbW3MjwmEjTfaNxjIwbI74rsr7LFB8choYi8HBPoWh10NXw9d6jw==
X-Received: by 2002:a17:907:3d89:b0:c25:504a:1e25 with SMTP id
 a640c23a62f3a-c4ca7a4e070mr795054966b.13.1793621194603; Mon, 02 Nov 2026
 04:06:34 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793400000.git.bvanassche@acm.org> <959f1c7628af83cd184ac51f35e38d654b261069.1793400000.git.bvanassche@acm.org>
In-Reply-To: <959f1c7628af83cd184ac51f35e38d654b261069.1793400000.git.bvanassche@acm.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Mon, 2 Nov 2026 16:06:18 +0400
X-Gm-Features: AclHuK8Jq3J4DxFlVjoZiu7tN3k93OeT9GQPHWWebhsy2WKCmY_qScq3i3yZODI
Message-ID: <CAKTNdwHhgP=7=0MwxGKi4Mc4rSsH8RrdGY+BEzLBiwwf9f54eQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] scsi: core: Limit retries of commands that receive
 UNIT ATTENTION
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 2:43=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> Fail non-removable commands in scsi_io_completion_action() on UNIT
> ATTENTION if retries exceed max(cmd->allowed, 3). This bounds the
> number of retries of commands for which scsi_decide_disposition()
> exhausted the retries or that have been finished by the error handler,
> e.g. because a target keeps reporting UNIT ATTENTION after recovery.
> Since scmd->retries is not incremented for failfast commands on this
> code path, failfast commands are retried until the command runtime
> limit is exceeded, as before.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Tested-by: Alexey Charkov <alchark@flipper.net>

Thanks a lot and best regards,
Alexey
