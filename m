Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573425;
	b=T81L/KmBKnDS1T9mQHRyxejBf0KBla2tdQ+nDJHt2O6MO5bbQYCzrmM2524vYawlTYKX
	 D7fhe+tfCFQs5cWbZpLu9ZDB97HxR/YtKzB8PLIVpB2lITUxNsr7EfM619gyP6Z3cNPhz
	 9Z1ozTq37tdC4hr6waJ+4Xpgqqna7H0Kl4kKYpODeJeoo0H1Tql4KaFFtjZ/B1HKBs6vq
	 qRcbxeNWmpIuX1X5FxEWzvLkj6EDIb2lGiafHmKbwaU0V2E0cOjznGOXA3E26FJxJiEve
	 0LY3jRZP1erdTzDUBiL9FbYbyQ0QkXI2Ydpa26Cc9um4scBdJ4vDBHtYiVqx15F/ycw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573425;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
	b=Yr34lBUlcff/I0eochCaA5efoRXRGqpI0F1DevvgsXuD7eV0yMuAD0/93G9VyNmgl2Pk
	 UIaIpeskLGWqCVpUpXJsdIBm9oDhGax71AmZq1am8OTjrhTUH5OxfP+TP7YGiwpPs4oCB
	 VWRj80MovO/4CVJhw7y3RAQREpmCaxlFw+G+Vs43lexRc10Y3lu9P9XfPGnJ+fxudScUQ
	 NrScMG1ddoN0mUQs+GaTqBNT5E+7wuCWo1sToRzmnfBlz8m2vmMBERbwWW8s7S0HkWU/S
	 rszXqCRTw0zE+UyOYPndvsa1SF5uXy3Avq7IjvUHr5TYgY0SgzWioCvIFjMgMNu/vdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n2XPHptJ;
	arc=none smtp.remote-ip=74.125.225.139
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FDD606A32E
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 12:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8FDD606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n2XPHptJ
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-4a5f76661b5so3542055e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 04:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573423; x=1795178223; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=n2XPHptJWAiGnWBjuWK6g5NkFljgiKFcabC8Vn0J/U7Rs5oCxIs8ae//bm8icbKFtW
         GhaGag1Xoi7ZyXwdHESo4gzqQGVIFHJ4SWyDVffZrMrzihrR6J8Y41NroO1pUm4S3UEM
         GevRMV87lpSFNCzDE68IInZGbL5X+gYDk7IApotAPKeUo9xOfBbHGBSC5mcggp0KJBcK
         Nc+e1mR1SmgmgC0Frha4Bk72pKDTzd14yUseYASwtvG8qZfbG+gNn4GmoQhA8ODET64L
         X6SskqZIriPJvj35d5mhI8G8hobVKdLKjnxeG6bMHAYcCPTjUD9dRkaaJK3nWVTXV/IA
         bDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573423; x=1795178223;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=87/Ge5NhXdmtGpcXCLUvnqWpWEAxiW5M6eWOW+m4zUs=;
        b=R6lY1kud161xjmB1nhOLjgaqwp+2A4mfTejKiuAlHxL6vC8QIQKvV99Y9PFoeFIP9m
         6Kkv79vbyBadLsyokz7rK4XVjqQUGLwqHQHeG5o7cgIK6vEfYqabIqnRwjytZb72zjmR
         wXRgifiNL8goAf2EaNtUo3L98nFKz9UGzcSS6UdmDRTsfaXPtFgO+z+QxXxs2f3J5gqb
         CA5FfoEYRZP5RuwtURSq7KBDc3TtspbsxOiM0DE5kqfqRZBR7KS74CNQB9iD3gBA8XVM
         uuTSQoY0AnneCZC47BV/pxTSDxPK8WIn+WE6sbh9In+e36Mro6iCLdaJI2Rq4TdcoFAV
         cyZQ==
X-Forwarded-Encrypted: i=1; AL+hErHSKY9evRVqduARZbTbEFZEYzuNiHF5FG2eT+ucjEnMVREU7nKb7bKjonRQtEMMotUZxM4JbkpOqPZW@vger.kernel.org
X-Gm-Message-State: APuU4Z+fxxwMnf2j88qgDp7WJMkRkixWWOvUsq7EkQWvKs8aEAYfCfq7
	QVSVVVyB5k7Gq/xpxmqGMg1o9v9SRpvEpT7yaFBuFEQEjXjdk90q06IOnCHL/kc/nP0i
X-Gm-Gg: AYBFou0wzHOXrExkEF2mSf77RxOI5qiokbQfid78yrs1hT+HhWD2EALNCHh6xP5Llyt
	a6udpdK6/z/93XEMy2/d32iW3Na3DIc4nN7vdMhMLs4BlF+M1MtSfY7wAZ+7QWXWqqwwsp4gnlG
	yQGFU0qWhOC0IP4/9nEHPPVToIuLB/REJM/z7Z5m2oJv2nF6q/XjMnmQ9fOK5RsIecRQupQAHd5
	L4w++WfDU8QYNWJb6Wk1k3w8bpEP/yx4nlolv0AHeiU/ZWWoOBewuV+Zd+fz93OnJELiD51N6cL
	ALscJQqke7/2DDZCrykW9x30xAbli8xhJIFkmaLun9LYFYzBMujWevTFYN8MKGykZZZgLXgLKii
	1rh+93SLLkcVoVXCUQIFcRX5hBxFPKahKGr6cEdyBFNYmJP2abzLxr1pHAQTmv7vZ7+p02n7plH
	9j4bdy+mW4nHgFaWuP0SA0FVgtgc+RAsHZALSIYhh0rHWBGXeMmsM+mV06yD2PoMXmM+NfVAma1
	Qx9tmBbCMK+DmF5wUqb/wQEKjtt8DAkI5CsMWfblqELQ23pYYjk1Frv8uKfDYq+dpCqndg0iC+F
	FKKEh3l4jkw1/nTEWvHzPJRItbxZORWZuYj3TkROXpQ+UWhuRM5u5aMYtzj22qYaQ9uyK4kJKEr
	tESoyMQAf
X-Received: by 2002:a05:600c:b86:b0:4b5:d95c:2378 with SMTP id 5b1f17b1804b1-4bb55ac4030mr49782945e9.34.1794573423157;
        Fri, 13 Nov 2026 04:37:03 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55af2901sm57437255e9.13.2026.11.13.04.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:37:02 -0800 (PST)
Message-ID: <f12140be54ffc4d1e8e4026f80c41c75cf5727e0.camel@amutable.com>
Subject: Re: [PATCH RFC 39/41] usb: gadget: f_mass_storage: refuse files on
 pseudo filesystems
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 13:36:59 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-39-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> fsg_lun_open() takes any regular file as the backing file of a LUN.
> The
> file-storage kthread then reads and writes it with kernel_read() and
> kernel_write() on behalf of the USB host. With a procfs or sysfs file
> behind a LUN the host gets to read and write kernel interfaces with
> kernel credentials. Refuse files on pseudo filesystems just like loop
> does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/usb/gadget/function/storage_common.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/function/storage_common.c
> b/drivers/usb/gadget/function/storage_common.c
> index 75831f2c7abe..83683ade20c2 100644
> --- a/drivers/usb/gadget/function/storage_common.c
> +++ b/drivers/usb/gadget/function/storage_common.c
> @@ -211,6 +211,11 @@ int fsg_lun_open(struct fsg_lun *curlun, const
> char *filename)
> =C2=A0		goto out;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(filp)) {
> +		LINFO(curlun, "file on a pseudo filesystem: %s\n",
> filename);
> +		goto out;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If we can't read the file, it's no good.
> =C2=A0	 * If we can't write the file, use it read-only.
