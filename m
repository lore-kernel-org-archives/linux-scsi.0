Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794468306;
	b=Q32Kdn87sKhOBWWnHEpYR8UuiNCbiGoxe0SDuleqMaJ9vHfI99fC8sP9M/HJjMjZvysp
	 4tdwNuRKRPTbJLYA4l9Av2movIcoYMZsjvBxFdg77rwb+/N3c5s0MGD8y6LtemwD3+iVv
	 w1uGn6xHVqDZrMnrx7sUs423LJpRa08aL0gmys2A/DSXi23bmMNadVFObslTX+nxcikLt
	 3SkW7hfHw3xnL9IIDVL6DIR4IWA9Yo/gozakjbPLQXqpSI/bTFKmv/rBiZF2Zad63wB4s
	 AEOPrGvn1b9XiT/Fd116kTMhObSebcXzuDOYxFgrmiR30Mf5UnXsaQ5nJ7S6nD6Px7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794468306;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+WvN0xmqF+elIOOeEt2VFvZEwIi2q9/ZWjRGWz6r3jI=;
	b=M6PBgQBE84cNKi5cuChHJXq6E0L8BwiAI6KoBZfURj0ig4w0hdGOuKYf8TgjSHGfEuIv
	 YgOMUjEdPpNFLBmVLnQ7XJwk+sMujfFvWH240/ygbTCU0IVQtBrrGNrub40ph/CIyYROV
	 9EvB4ANYSkJfws3QLRW+0QHTp01T27v27vFrHL08PvY8N/zW48418dn/bxagshveI8le+
	 MaUrgmzDR3mVM6l7TQdHAC0KlcHJUblyRKXmGdrZJin6PzQOnJ/eTde4fTwnpR8jn77mI
	 0evwaH/u/tVGh/tu0n2GMgk4BXQiXDZr+AlmGg4Q5iM8Cj9VyUDLX7xToG2A8nfhoYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rvi3l9o+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D9606A331
	for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2026 07:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rvi3l9o+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F3D1F00A06;
	Thu, 12 Nov 2026 07:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794468306;
	bh=+WvN0xmqF+elIOOeEt2VFvZEwIi2q9/ZWjRGWz6r3jI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rvi3l9o+D2Obm4fvYR0anADFHqTwA5V9T/IUskQSjulaLocTHU54h1ShUYxQNvbN6
	 jxMZEW8oPanqXGJrEGKQM146DvzHRLlClvuAeryR+XiEAvoGsQgErGO4wZ5mVwhqEp
	 YyAdzsmj3HUw6tTjB3fhi2oLYCvLbycXH33PjDPeVT34sJ8IFrjpcnb7K9ACIgipl7
	 1IONNlkE0CaXqtPdqKoSED5MbBfjRKmG+5EXYHleuAwiqgYpmv5YDc6TVd8nSP/+Ul
	 8+OszBl2e7PQPppa3kxe+aC5fPEIGgFHbCxjFRYxBrUzwaFLQ4imjorLrcEeRS3dYy
	 BcYwRlfEU+FVg==
Message-ID: <sashiko-outbox-210601@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: myrs: Put the SCSI device after logging a
 physical event
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhu Jun" <zhujun2@cmss.chinamobile.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261112071752.154639-1-zhujun2@cmss.chinamobile.com>
References: <20261112071752.154639-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 07:25:05 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] scsi: myrs: silent drop of physical device events in
  myrs_log_event() [1]
--

commit ac88587479e352e8cedb430c156919340b859e81
Author: Zhu Jun <zhujun2@cmss.chinamobile.com>

scsi: myrs: Put the SCSI device after logging a physical event

This commit calls scsi_device_put() in myrs_log_event() to release the
SCSI device reference acquired via scsi_device_lookup() when handling a
physical device event.

> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index 1192b01fab8ec..1f248501a611f 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
> @@ -877,6 +877,8 @@ static void myrs_log_event(struct myrs_hba *cs, struc=
t myrs_event *ev)
>  				break;
>  			}
>  		}
> +		if (sdev)
> +			scsi_device_put(sdev);
>  		break;
>  	case 'L':
>  		shost_printk(KERN_INFO, shost,

[Severity: Medium]
This problem wasn't introduced by this patch, but does myrs_log_event()
silently drop physical device events [1] when scsi_device_lookup()
returns NULL?

drivers/scsi/myrs.c:myrs_log_event() {
	...
	case 'P':
		sdev =3D scsi_device_lookup(shost, ev->channel,
					  ev->target, 0);
		sdev_printk(KERN_INFO, sdev, "event %d: Physical Device %s\n",
			    ev->ev_seq, ev_msg);
	...
}

When a physical drive is hidden by the controller, unconfigured, or
already removed, scsi_device_lookup() returns NULL. Because sdev_printk()
-> sdev_prefix_printk() returns immediately when sdev is NULL instead of
falling back to shost_printk(), drive failure and removal events are never
logged.

[1] https://sashiko.dev/#/bug/linux-5aadc823-d60c-4405-bf84-45e4ed87504d

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112071752.1546=
39-1-zhujun2@cmss.chinamobile.com?part=3D1
