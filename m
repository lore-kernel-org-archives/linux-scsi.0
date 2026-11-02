Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793621129;
	b=n95aLySH7ysSvo3EgQZR6mkEvk9RTtxSETx67HYObuDUgCK0QXtClnAHtv3Nt+RUalqC
	 JD/uP9zeeJKO267dq+FzswMh6whhWWV6MPiy3QgyAGi2ekhZg54QZnT+dGqDggsgNvxLO
	 e5GX0APWE+nJr/g4MpZ3Nobun/M+GxVHFzT/087kzXKN1OuqF0tUphuIO11LNlKeX2z0i
	 L8uXBTl4dHpGuvqTTw+mZi1I1XVCZjHkI2HsrrrH0hAqPCcmoZjtzsMRuL3hDTyYVs9RM
	 HyrG0a62xgFhZd8gc6a629bNoD+JOFvG1vG6xi+Nx5wtPQ4Myjce/KVzv2WCJn8+NiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621129;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+ZBFqIsnvhiWwoQmNZFa1u8ZkrptuSUpK2Sox6s25Co=;
	b=BSi/W5Cqjw5xQc21FS+IBYJnbarUc4f7wd7qyxmnx/eM8V4H1dnk6mVLrIS4TqMhvGhq
	 qejoaiwwAosFivWzreonMRmBqoj7ocZ76MraQq5p9XWMbEPHrP1emfSovK5rdw0XX9oT2
	 A2HNuLiPgltNStTPOa8Y0phUf0ho0NRMFx9P54DIAJU87/LChwVy+Tirn/L+hcQBDWiY/
	 bwp1yKovSII11JQrnSSgPzdKNWM7usURxvig3Ooory1sFzjcWi/gGG9/UMgZ+VtbjB5b4
	 Ch6zf/Fz0UaKbD7pWuDWefKwckJBVrlIGHSrhuiiDoCMt/HS73+psRZzImL1iuoomMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=eyqSjj0R;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C404606A327
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 12:05:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C404606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=eyqSjj0R
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c49b431f022so420544766b.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 04:05:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793621128; cv=none;
        d=google.com; s=arc-20260327;
        b=qYsQ5pm8z0LjRnAuIpZQZAp90hZKh22RIYyECu8h1fHPXhZ6b5vy9b4sehNRjF//5k
         GpWpuRrp145Zq1XRlJTsRxg6xz+UjGSClpgxGtTZOOOZMUwlCs8uEwM/kLz4RzOHVImH
         yV+sYZHgwUd9+l79XOzQEjYOWDkE/jtC5BxewngfwdoDCphgW2peWyp8EfZGXejJrrk6
         YXnvKB0LRlhzTOrksmga7FGuysv+ZZ4V36FdRIOLQmPFQE0o6o3PLuDFWQFCxcNK2qwo
         BejbIqbtaPMcHJYhvVE8j8r4vdpZh0vJUXCklQsKBfrBEubj7Ctr5jIjkwMFxeR9/Mc/
         8WmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+ZBFqIsnvhiWwoQmNZFa1u8ZkrptuSUpK2Sox6s25Co=;
        fh=9v4pUaDTasDA+DvytSX3ijbdZrOfxAWZCg74UGoBZCc=;
        b=ncadrC9pBTQQPAwct7lptHwfImBioqhFj/06WS2hZ+KLKgb1rwrn2td4ir838MXU86
         0fEkWvvWPGncc5g+zXsRwIMTAlRf1rdz4+J0sa8jqZi7/LateIWEnxzYai4HehYrYFpO
         2K4DiCUiRL0gsNazFzwikSEVi+ZdJgkN1qxxDRnnmM/MmZ1vcPwVa5OQEVQnlVLiUDGS
         8IgYaOrLd6ByGPhnq8RwbfKU+Tb+tdpd/kDBnGBM89LMI/RbBvJOjvS6hL/b8ceV+aFC
         ohuOzRCHtOvdKnGb/7Vx2uzDBRVCObtzbIOryED1N0TR7nwvvYTopyW1/VwRWGe/hOcH
         vFTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793621128; x=1794225928; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+ZBFqIsnvhiWwoQmNZFa1u8ZkrptuSUpK2Sox6s25Co=;
        b=eyqSjj0RkClijpWfiBqMXb15FITMx4DjasDVdZORNx3FOFBUaKU5tW2w9tVSJKDyNV
         aKz96K7T/ve9eR8LfdYP/qajNhVRMQRFpIbZ81dhPMJ9m/BQMcUVoJ7QN7De8GTm1LnQ
         e3DtLTNJqVCErgIkg68YlVC3O3vFUfSMTnSBEyga4KfPi5Q9Ub6ogO81tDd0IcsCf91k
         Nb1BQYrWSNKTah+7ZW3/14+rDETXJ2wPSk2VrvfmQpcwKafbkh1fCbV98DGZYS8ZdjTQ
         BLWrM5i7Hc2rsqo6VyG1wfIOrifcUGB0og3W3c350XVAOKC6OKTdfq6+AFhJ35t5+jJo
         NDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621128; x=1794225928;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ZBFqIsnvhiWwoQmNZFa1u8ZkrptuSUpK2Sox6s25Co=;
        b=R4ChrOL/NvzMMaMmyr2toVbYM3HUO+6UlqlJm9pQmYtBXpp39hhGjA342n0cWvSJR/
         5unABF/ipveToDAgC9XvRqpEK08TFa8mE8zI25NjUarXxzzmcNqCfMcz88sRHjhgt0o5
         4M9igChcHmLhbKOybgNovBLipz0B2eRyXY1f0RIrT65Wn2qgFoFgQYJyxHziBXsHv4zK
         vGoKJu4LQ5RJZ+3YaAk31WQHVsnUKQ5rBsi4Y39ehk4DqJMtnklkf37mlvq4dppPbkE3
         rKMYBsf6wllRlNBgnz9xMT/+I5iZvrr9Lda8rotQVoF9Svq9coge+cBlfSR4q1namW72
         Hy7w==
X-Forwarded-Encrypted: i=1; AKwUvByXUPRamFghF/T1QzPk7uR4BmTN8FatSAvkSLFxuNLNKdvK2fLJThaMrr5Uh+dkoKXQJTQIKrBsANOV@vger.kernel.org
X-Gm-Message-State: AFq9FYJvj1NefGBmueln6tEVC73r1FCZpKET5lsx7tHjOcXqFYeINMgN
	4q5GHJKPHuxZHXKaxo2mIWsS7+yAUyCY2MiDm8F2geyKjdj2JlfMSLZnCaSUnI1RBLgcaUnlp8R
	0oVsgQLF8jhaUYVi8MblhutORdopnn6lGbLMLO+hRVeDzNOZ2L/PxdtAtttJJ
X-Gm-Gg: AYBFou0BnfDqshT+7fYyu060+pn4ROQiLn+9eO+jRgoXPbA3wgGTWJsmnfdlS9YgoJn
	SBploejF/kD0tCHDkVnBhOeWKVguwKb1awtIXUVMGx5fcWPluaDweVu7nyyKsRsGKSRTlkb8Yqv
	uwdb05ptXHXyvO/KEuvfvgrXwGdqh9c1lecAFX/tEuR33TzSDsbXZ4rgKDDWZ2cH4+cEWy7qkKv
	odnrcBt8yNsaVmM+Fbyn33myMXbqR2JS+CAV3fV/J0bLyuOAeKraLfK8yTH6Pxpvapw8GtjQ1ho
	KAd3H9Wmp/42RlWYA+vB1Jba74DojT6rtzbsowEuaJp7v+48b2reUIYsKAALGrfo+Hh6lmAkWsy
	y7h/11tiGKLNso5+ErwMHxHEsIkKAsoGn92dpsqReUOZivr+ptTo4P6DHov7VO1uZ5jV4CQ==
X-Received: by 2002:a17:906:458:b0:c4c:c997:8711 with SMTP id
 a640c23a62f3a-c4cc997b01dmr214871466b.38.1793621127536; Mon, 02 Nov 2026
 04:05:27 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793400000.git.bvanassche@acm.org>
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Mon, 2 Nov 2026 16:05:10 +0400
X-Gm-Features: AclHuK978rZ9d1GZnK74RSlxGeVP4zjkT5roGpC1NZMHApOTAykLuYZkiNlWDVQ
Message-ID: <CAKTNdwFQOcSaSNzMQAg3XV3AH4tx7Js_cy-tFB5i9s=6szWGyw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Recover from persistent UNIT ATTENTION conditions
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 2:42=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> Hi Martin,
>
> Some SCSI targets do not clear a power-on or reset UNIT ATTENTION
> condition for all commands. BIWIN BWU2A05* UFS devices, for example,
> keep reporting UNIT ATTENTION for WRITE commands while TEST UNIT READY,
> READ and SYNCHRONIZE CACHE clear the condition. Today such WRITE
> commands are retried until the command runtime limit is exceeded. A
> quirk has been proposed for these devices [1]. This patch series instead
> makes the SCSI core recover from persistent UNIT ATTENTION conditions,
> so that no per-device quirk list has to be maintained:
> - Patches 1 and 2 prepare the SCSI error handler for the changes in
>   the later patches.
> - Patch 3 makes the SCSI error handler send TEST UNIT READY to clear
>   UNIT ATTENTION conditions before it falls back to resetting the
>   device.
> - Patch 4 makes scsi_decide_disposition() invoke the error handler if
>   a command receives the same UNIT ATTENTION repeatedly. The behavior
>   of the exported scsi_check_sense() function, used by libata, is not
>   changed.
> - Patch 5 limits the number of retries in scsi_io_completion_action()
>   of commands that keep receiving UNIT ATTENTION.
>
> Please consider this patch series for the next merge window.
>
> [1] https://lore.kernel.org/linux-scsi/20261028-biwin-tua-quirk-v1-1-767a=
12c9b9cc@flipper.net/
>
> Thanks,
>
> Bart.
>
> Bart Van Assche (5):
>   scsi: core: Introduce scsi_cmd_needs_stu()
>   scsi: core: Simplify scsi_eh_ready_devs()
>   scsi: core: Clear UNIT ATTENTION conditions with TEST UNIT READY
>   scsi: core: Escalate persistent UNIT ATTENTION conditions
>   scsi: core: Limit retries of commands that receive UNIT ATTENTION
>
>  drivers/scsi/scsi_error.c | 255 +++++++++++++++++++++++++++++++++++---
>  drivers/scsi/scsi_lib.c   |   5 +
>  include/scsi/scsi_cmnd.h  |   7 ++
>  3 files changed, 249 insertions(+), 18 deletions(-)

Thanks a lot, Bart! I've tested it on my offending devices (five
Flipper One boards, three with BIWIN BWU2A0526B128G / BWU2A0516B064G
UFS, two with FORESEE C2G071 for control), and everything now works as
expected. I tried UFS error-handler resets under light and saturating
write load, runtime PM with a WRITE first after resume, and suspend to
RAM. With the full series the BIWIN devices recover from the reset
UNIT ATTENTION within ~40-65ms and there are no I/O errors; the
FORESEE devices never enter the error handler.

One note on the ordering: with patch 4 but not patch 5, a target whose
UNIT ATTENTION never clears (emulated by a test hook) keeps the
command cycling through the error handler with an LU reset per round
until the runtime limit. Maybe patch 5 could go before patch 4, so
that the command fails after four rounds instead of hundreds of resets
in ~15s?

In any case, these work great for me, and I'll send my Tested-by on
both patch 4 and 5.

Best regards,
Alexey
