Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903967;
	b=18wwKZkJ+mxIBPSHikRuOZ/PB8jLI9BgjZ7tVFM3uf9cO/Qf6JAyF9UAIw1JPreiYjiO
	 tJL4mfNoq3Fq8hRmDVAHVdOJviafZT0WZGqbaeKEximO6/vLEYMK0cZkbL5Cl6NQZ0u2I
	 QhvNu6WhkY3C4x96HxOV0KQQ5K2booVpLPxrHk2nkNO455WQQfsgAP12wqirnruL4D/4L
	 9lJLzmYGWQnbkC9oCSWyQ/rhPtFw4FYtwI2Zj8U1kIocadfB1dEqrC7584xUu4aeGyIlB
	 Xh4MV7lF7IdwENFv9NioN7xDzmISzaAP7QA/Rh0WogsICSVKor4k7gAQlVhlAgFYAbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
	b=YcIjkcZ24xI/ru3fcO2BC7YxK2ABFNqtkdX3051SRPcqr5prPoROW+qB1XB/evhf1Ky6
	 I6foF8NKS+3sbvchfOkH8nazv2AaLTWVeZf3DefP1xG8yZ2tCFUQfcEL1yH2amRFf8Et7
	 LvWiDWFEJ6QHah45G5QwDn/APHDOl8RpRtk75CDhYoM50d3nJ9Uycz0bLUMX4xUtd7DzW
	 S78/KH5ii/5HqYkQa65TDbFJNYrkPfgPYDZfrCTbsljwW9II+WQ5MfK+Aaut93PP+vuON
	 Z4pHjjSqGxB8eRkYQBMFJtgPkbWGLmlpUAYOBHMODLmP8dnd8dzVlG+tmsadpoQy/9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cds43TFp;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291F606A339
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:26:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2291F606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cds43TFp
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so7875445e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903965; x=1795508765; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=cds43TFp7I9j7WPcDQvYfHpQ9LovbzzVif9J1GAb84gdrUsjaaD/ks8/CxWEGRZF0/
         68hyeBKuGnu6JbonI+DUrAk+S9ERoS7tOFFA4H5eAQDr7L4jclXV2ELfZ8mKm2Ufg0Vf
         wmDFKHpSFXtb9q6HdOEKHOgWOeHJI7n45fohFUmuSejGQMSPwWlozLhppiRP7NP6/RTN
         Xh3C0JkZ12tnXvLGCknth+xcOYp3m/oSfXqUlVI9cwzFe0Rue3P0S85bM03sQyFUoXwh
         8JJkMFcg0oB6zhSAQwaixAlqp7dYBZf2pow5RK/cSK97CWugz7jqMDtCMqYWg5eRSPcE
         y3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903965; x=1795508765;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=xKZ0ZKJ8hc65impW6RJjrRhveYWFRNF1axXcUPonj0tngK2/cnFeA3QMHGUIObj36+
         u9WkM/j8+T8dhlhZXO+RJ27cJdNMggtMw+seVBE9TwMTabXon2WNscIaDYFNo36H7JQ8
         GZmPd9lwjDwklNLt0Gp970zmDN6xr2x0Z+ZZObvRBi4KZ65P63TBYVTiewIELduVBikG
         jJ7T9jWWUpTviUL/zGlOJqSllcsCvicWr9kFjC3oVA1A+aFYHTBIeC/8sh66hQl/G/Mk
         DZ2Gi0bbdN1Hr2CJDRqnZdSrKLjDjifxsZi6r1/rb99EGIiUM0A2hrzvwKz408X46wA0
         uhAg==
X-Forwarded-Encrypted: i=1; AL+hErFP/YCGCZ7CR+6OXLShNRWvIt8XeriN9qsPtssUhLbC1G+rCLZ5/HwS2q5n1ndcpAnb8Qm6VzoFkULN@vger.kernel.org
X-Gm-Message-State: APuU4Z+WzpNJkyjlWl6bXdgmam9hdhR+yvZOv3DX9cUfuNJevpjA3AbH
	OD0Q/9DSK+tpkwwR0fEIZFoqtWWqS8NRxtpSTd19Uu8EUsgA/vzuouelBqJ4/tFmrknc
X-Gm-Gg: AYBFou1lq99DA2lNhKbS+OFtG9p0XcO7/xvXPyd3DXyOf5st78aiWht7YvLWrmlkKZ0
	gLtC7KQBkHpaKZZYqxED1qYnKhXaOzytYNHpHx4Vlgl6F+Wh0QgNGWWKSJG0O/2aLP/P1zqLnq/
	P6mG/+avwQrpNF1hfrTLu4/bvUXld3Us8TtnvQ/HsTcoDrSAGdSMq/CMJYv/aDKLPg8WtkWoMK3
	xOzYLqO5mjOGwtTqeyAiNZSIegXwnxSGraZoDD20djtggzqE5W1JT7whax6XZ439hosveMUYqwf
	q+Frsuw14w+WpZ5bTIxuTJqPd2eSSXH+Tpzcvs/LfCVNom7cNjirqEbvxJuj/N6w4I1WB9uv9q/
	de7GarhGAjCupGIW8NlnNYvTfUIZQq1GPwTStvWjG6z7/uxudPFS5y3HT0CJgLWOjyu5Ei0sKAE
	imC3133qCh3ZzNW2RztYUdZG/Ja3twlqb04PzC5qIIgTZMIy7KmsX/zZBEQ0p5IxSjuXkMgrTIE
	vVXRab3i78Oe9mVne0pEMa42CTpbyHZKwOcHguOq8KXOmTjEQHWQXp31KWsOqiKJhhB5Gm4/YiQ
	hu0Bw0a+hdtHz3mLaY6V936fMTHAuFzETlyhnmVBsICwgaolERcDAxn3nxElv06HlmSwQGgc1al
	58IXGiCFM2zuCL0RdXkS5co4GMXpjLEZnoQH8TXipItbsJw55Ibx2Ncyi
X-Received: by 2002:a05:600c:5493:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4bb783813a7mr42606245e9.10.1794903965400;
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ad9430asm12629125e9.15.2026.11.17.00.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Message-ID: <88041240268f70b218de7dfd58c41977d03a60d3.camel@amutable.com>
Subject: Re: [PATCH RFC v3 03/44] target: fileio: check that the backing
 file supports ->{read,write}_iter
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:26:03 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> With fd_async_io=3D1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path
> goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
>=20
> Refuse such files when configuring the device. On the synchronous
> path
> every read or write that needed the missing method failed with EINVAL
> anyway.
>=20
> Fixes: 769031c92c8b ("scsi: target: target/file: Add support of
> direct and async I/O")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/target/target_core_file.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/target/target_core_file.c
> b/drivers/target/target_core_file.c
> index ab9824a4852f1..a5391e57e9aa5 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device
> *dev)
> =C2=A0		goto fail;
> =C2=A0	}
> =C2=A0	fd_dev->fd_file =3D file;
> +
> +	if (!file->f_op->read_iter || !file->f_op->write_iter) {
> +		pr_err("FILEIO: %s lacks ->read_iter or -
> >write_iter\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fd_dev->fd_dev_name);
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If using a block backend with this struct file, we
> extract
> =C2=A0	 * fd_dev->fd_[block,dev]_size from struct block_device.
