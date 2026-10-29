Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793280838;
	b=cp/XjmDglYthhp4JQ3vJF32n4035ySfOGLuND/ffxviH0Ts/mEbEghz9FnhBSNlzu4j8
	 CwK2poA+bSMug+b/Hf45xK+HqS3vVwwRSlHQ9qTDVTSBBCV4uE7AwatmO/8s+IAaLW/uK
	 +moBXgvaVEJ5zkVhnvUHwzkMF+KbYeP+ybwDEG6OGIjsdeTdijtItZHYDk7Q5O7fieWYo
	 kBcq/wOB1zTZ1OWbfzapgFrk76wXpOLcVctaADqyuouq8wgvWVL52btdZTXmM6wS9BzD5
	 hh1axAfTQLAzNTUhQUwa7TogNism2pAcE7nkaOXT+8fpI0CEedfHv1C3BkKNfxZ5y0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=F+eNJSMVkwDxJUThG2ULRs96wZbJ07yl55m4EZseYWk=;
	b=mDk6svlctP4oxO/1oDcloqqMihVCqte+EqQCwzluBBNA2jF6ekAw1ji+8td/V4eis+Pf
	 kGHtO8+uzDK3NvV8uZYhsLemotjJL46zYeTJUVWfGbBJjMH2UYaqlzAOxD7LfNqh9VbzC
	 HUzr9/opVd4yLa6H2d46k3bztxaxHT4KLC2fJHDWhIsb9kVgXJyj5AaYA05ViJQuT3lh9
	 UB3OS7pspUQ5oUOY2aSuuig1JGgUUnc+nlaYkzmdW7Yuh8AXDbWsXTsKCfS3U+Thkwy9O
	 zo/K9GSfLz/Xi7Yv8kz7EgGSYAabts0FYpAuTvsNg2LY4ZSbhpmWqhD/g++NUiK/NDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=flipper.net;
	spf=pass smtp.mailfrom=flipper.net;
	dkim=pass header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=pXENXzws;
	arc=fail smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAA6606A31C
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 13:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCAA6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=flipper.net header.i=@flipper.net header.a=rsa-sha256 header.s=google header.b=pXENXzws
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b486e1d02eso2912533a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 06:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793280836; cv=none;
        d=google.com; s=arc-20260327;
        b=Gk0ShsjVASE+y+f/WV+zSjXOsNFBwJgXF4Ssk499/gHs98APhuYvD51f2F/Vtre+OB
         KoW+I2EbxHDWPHShQijFphkbclikrsVefHg398Fc2rXnzwwK/qtwd8IbAgcGI6JGfcUc
         ilJAlOqG4AOqPc0L6il6cPBC6j85V9e9D52TDE71bX2arACXisvG8n3lGZvfAv9aMuUc
         c59sVxt7RFr9EuIJPmd398ttAUwBbm6uAHM5ls08h1sOZAS+I6JhSwCpPsP/ZF/x0XSt
         uO0iEnY2Z5noPguS+JFFZMvaxsm8K25WGAiD8gg9fUqb50YrR6U45X7GQGxTxfxTOeFO
         J1yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F+eNJSMVkwDxJUThG2ULRs96wZbJ07yl55m4EZseYWk=;
        fh=huDnxIwPSwizRg/jZYfjiXYSqMeoWhcTkCWqAd/e5qM=;
        b=Mv12ol6tsol/jiqhblrlxP0gRjv1GAfswmg6Wrr4GSOYbP4C7V5bESbbPmTEG2o1VE
         13F93lm55J49TVEX7Mqai+1HPmHDzqfjr/BtzgrFLlvrXQeHfSlIagCT3q40Zxgb5ajy
         CTieZwV5Z/sAtPIA5qhhVDaK38mah3nVnW+gg4/zZMNjROYyd4yTU3yq7NuQXC0MTP/o
         DRgji2747mxy0Gk5qf+mJgktgJ2LYz8vNG4AMkacIipmqLBxtZ48a3Rp0cN5En3x2qsA
         Glch8KNekTsQh0FsgKTTkR63nbJsCQ1qU5/vk989xW3a7AyJhlyVg52st5QWgcJ3HYu7
         mzkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1793280836; x=1793885636; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F+eNJSMVkwDxJUThG2ULRs96wZbJ07yl55m4EZseYWk=;
        b=pXENXzwsbXs1Bi1Q/de3hCPfefNHByHAaEvTI4G0A+WREg0Ect4dw9f9kyV9r4ucgP
         5F8ZmauJaht58zJtnNK9yMCCSb6tLrLTukk6Ug6FxEAzCXTpRiUqJ9naaf/5aRrmgGtv
         EqbpZTfV7dKVYlJk3jVCnw/cvh5RAwYd5eDt20AZIQoEzM8XyrHQIO5UrTh0TJj1U/wY
         mynDC5vs+gyCvgk6DPi6HBAO34nYUcnZDwWHTHtxUSGt7oj2nx/ZxgHyhdeApsrdeZE6
         8+o5CslRF1nuPE1Jb22mXJdJAwnJ9C7DxsFXc7wblydSBsSwtBUvrtyWjL6HSTNjSE5T
         BlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280836; x=1793885636;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F+eNJSMVkwDxJUThG2ULRs96wZbJ07yl55m4EZseYWk=;
        b=SfHZS14yb4EOiBne5O6ujqRNywa2sU/ZnSnWn7ofMEOi+TwxR+8PRINO4ZbwkjkSL2
         l6Fw5dL5hIF0TZrd/d90ptwkBgy4uWa7aBYo3I7dZlh4lvj0d1vKiXlw7bJjhokE1wsp
         DB+VQDFw8bKdFeWrj3JkVgHyb8A1DflRKxM+5If6UMvUDzSw9XfcIOjI9004nsC0ImQL
         uCn6yJ7GT63WldJshfz/bl13M7mFMJpzxO9f871iCfm8mW2GLeCe0rtPBhnCvyY06r+N
         cgBbxVazBTQHVy0bC+bDq9t5WfhL8+EqfNZhzchEjK8Zh3ZKjDmJz2i+WpK+OEWOJw+1
         XOTA==
X-Gm-Message-State: AFq9FYJPX7jovRpP8JGgsW+XshNhTQGaRlouMWDCI4CMEPLeeVhKMwN7
	5/uUr8lX9K2q350QScJpaKdGSYqLP1mNPHJ5KvLE4som1SVW0DtwlE+9SOsBebh2NoFIqQwxE77
	bfADhJ7T+MnJNGmlOZq67Oqv7CBOEyXM4YysOr/JE6A==
X-Gm-Gg: AYBFou0WtK0iJXOCcLcI1oF6aNeccAhjMa9eJzH4yHOx+e1rVRgt9E+mh4Ycgdp7skE
	/OS8euleNIF/cA4JSs0masEPPKA5CzdGqMmsZ6rW9HA0oHhfi5luyzqyhLp9eztdgvN4h86j5kM
	cRFEvfBj/g5VVJls955qipCBRQjuvOwCczDnFVOy74xLPINgLD9hCvS0KDiDGDalmcC6L7Ib0N2
	3j4aZ8sGD4rszJ7IQfgi+LnMa/ZLDup3QKQjFuuRZ8YMr3hJSbqCUHqu2BlxSmcA6LfDKt+NcyB
	7VD9D1O5vKad0Vd76e1yBt2NkJHoK2GXprFD+Yx8IQE23KmzHx0ovr1IUJKm7qko2LBFYqbV5Tc
	em0U1tOr9Zf9k6w9D+buevCq0vKTnLZlIT0f8R2p+hAj3kYI2QKbm0tnnZL3DpY3Bn4VrAOafue
	4aGGLpkd4644L+mQI=
X-Received: by 2002:a17:907:6d29:b0:c2e:3f49:df04 with SMTP id
 a640c23a62f3a-c49bdb68d6dmr477795466b.1.1793280836138; Thu, 29 Oct 2026
 06:33:56 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-biwin-tua-quirk-v2-1-4d71af956ac5@flipper.net> <sashiko-outbox-189185@kernel.org>
In-Reply-To: <sashiko-outbox-189185@kernel.org>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 29 Oct 2026 17:33:42 +0400
X-Gm-Features: AclHuK-InaAZRWkyXXw7fbMZCCfKUR5Fcnop4TxQ9forW4KTFobV-VEqdzfk2_o
Message-ID: <CAKTNdwHeHECQiM=MBew4YE6E0STwPBxyo_QnshASoE7u2z8P1w@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: core: Clear power-on UNIT ATTENTION on BIWIN UFS devices
To: sashiko-reviews@lists.linux.dev, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 3:12=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
[...]
> [Severity: High]
> Can scsi_test_unit_ready() starve waiting for a request tag when retrying
> writes saturate the queue?
>
> scsi_test_unit_ready() calls scsi_execute_cmd() -> scsi_alloc_request() -=
>
> blk_mq_alloc_request() with flags =3D=3D 0, which waits in blk_mq_get_tag=
() for a
> normal non-reserved tag from bitmap_tags.
>
> When write commands receive a power-on/reset unit attention,
> drivers/scsi/scsi_lib.c:scsi_io_completion_action() requeues them immedia=
tely:
>
>         case ACTION_RETRY:
>                 /* Retry the same command immediately */
>                 __scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, false);
>                 break;
>
> In __scsi_queue_insert() -> blk_mq_requeue_request() ->
> __blk_mq_requeue_request() -> blk_mq_put_driver_tag():
>
>         if (rq->tag =3D=3D BLK_MQ_NO_TAG || rq->internal_tag =3D=3D BLK_M=
Q_NO_TAG)
>                 return;
>
>         __blk_mq_put_driver_tag(rq->mq_hctx, rq);
>
> When an I/O scheduler is attached (such as the default mq-deadline on UFS=
,
> where dd_init_sched() sets q->async_depth =3D q->nr_requests so writes ca=
n
> consume all tags in sched_tags->bitmap_tags), __blk_mq_requeue_request()
> releases rq->tag but keeps the scheduler tag (rq->internal_tag) across al=
l
> retries. When no I/O scheduler is configured, blk_mq_limit_depth() impose=
s no
> limit on writes and blk_mq_put_driver_tag() does not release rq->tag on
> requeue because rq->internal_tag =3D=3D BLK_MQ_NO_TAG.
>
> If enough write requests are queued to fill all non-reserved tags across =
a
> reset or runtime resume, won't those writes endlessly fail and requeue wh=
ile
> pinning every tag, blocking scsi_test_unit_ready() in blk_mq_get_tag() un=
til
> a write exceeds the 180s retry window and fails with an I/O error?

Hmm, I've simulated this scenario and it is indeed the case. When a
lot of writes are in-flight at the moment of an injected UFS
error-handler reset, they end up holding every scheduler tag upon
resume, meaning the TUR queues behind them, and the recovery doesn't
happen until after the writes time out with an I/O error (which is
pretty much the original broken behavior this was meant to fix).

Given that, I'm wondering if dealing with this via the UFS devman
interface (as was done in v1) is a better option after all. Bart, what
would you say?

- sd.c looks like a wrong place, because sd never sees resets the UFS
layer does on its own, such as UFS error recovery
- The midlayer (like this version) doesn't seem to work either,
because it only learns about the reset under the host lock, where it
can't issue commands, and queuing them in a process context means they
wait for a tag from the same pool as the offending writes are holding
- The devman path in UFS, on the other hand, knows when UFS does all
of its resets, and has its own reserved tag, so the TUR can go out
inside the reset before LU queues restart (thus no deadlock of the
sorts referenced in edc0596cc04b)

I've run the same test on v1 (TUR through the devman slot): the TUR
went out inside the reset, before ufshcd_err_handler finished, and all
399599 WRITEs in the same window succeeded, with no UNIT ATTENTIONs,
stalls or I/O errors. If we go that way, v3 would be v1 plus setting
lrbp->lun from the request UPIU, as pointed out by Sashiko during the
review of v1.

Best regards,
Alexey
