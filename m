Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794563701;
	b=zXRmeqff7qYl0Cb7nY6ydjNRdGvbffrY485OPBNJs/nqrFVCkJ5G6fYqkFdqUJX5rSp2
	 +HumxKOTTYC57D7HYXkaDL4pW5klj9zDiqqkyzKrX8nS0VWWk7XEAAOX+dsm4vvd8lLCZ
	 tUs2BNFTiKF9t2nJJEifPIazsIWXe1APYJjmMRfcL/abpMjKEqp5+uQunfwuVMtJNpIKi
	 JYjOhqdWTGff43+0qcf8qod3u5940YJcO6SbiBX7BDbOC+U8dxet/N6kBzBveuNQoY8Bs
	 viozZKar8no3NqrF9JrC80SEpPoc8CjIWlYh/01eW1+WHW77577Rm04HSNFooVlwrcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
	b=N7VS49ryz4bd5qJXR5duIbqZoQntNirtlxBhX5HFOUJB9fmO/b6baoiHvou3KhWvZPZm
	 EXnevm6aC2IgeVIOAINzf/N4hZVnRHG3yEhlOoqtqKN8AwmqFJM/PpzpesjWs4QS/EYRJ
	 SOF/3J63ix9uSbTiDnKR1FGeXx1XG3ueUJUBmcfxMSXJupLRU+Jl3VRc6M++ab9fdvSTG
	 umHXEDTQTSaJ1SLw127AxabsT3MT53EBoFNBlxEdjbu9vIGhK9oKxYK1vb/u96yYTMZRY
	 7FbpkFkubL/CfE19XIUmzBraBN/45hvjRvGhdzuKJ6ncLzFwwT6jYfWhwB3R4Ob+5bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sk58W6sW;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBD560A2603
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 09:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FBD560A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sk58W6sW
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5083bc0e28so142296766b.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 01:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794563698; x=1795168498; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=sk58W6sWmN4ERo+6S+koVh/BM/TVuc998Smvb7+dAHAHasLoIxA1PyH7SpTb2sphTs
         qaL8BceJIK/C5zTluK59TXAg0t7i18MIhSXKzAc74GDtFkVBtJ5XexxofTn2ErTCpEyw
         wBL0ZIwSoD+QdFLNUYuAtp3uhttIIU+8CcgeY50Q9BuPcdVkRSxffNnvhBi5q+TOT3Z0
         N0fPVcnw8avDa7R0wdKzwUNoVC/3vPRCD1SmgKjZfrkNv7BBIugYP8aqCryl3mRTzhIm
         nyzLSOhSkS/Bye+QA00IM2MsjhnUA408QIyungJaHYxvuyXbuTeC6K0dJcKnUnQNsCLo
         BJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794563698; x=1795168498;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=z8T018cx+3bsxdiH6nrR5a4xNbTRF8FbFB8dDReAP3JlmKhdaVvCXtwi0wXkcHYdHG
         PpfCP2L8qeTqoOS1+B0YcR4h70+/p4yHucEuAGOliuNh4uFzZnTNg6FDgHU+zEiekUcs
         nOteo3KGTW1NfJhqQ0nRXp9IhnQW434Uv+F87FNTI4FyKywSYAAmlAinAOWvDnMkQC0h
         9VS/tv8TqmYTpKhte+20tG67MElXc+o58FQxqu2b4jBI1dczXWsVNeldhukw/I45Ejgc
         pHeRHlSkvnF/VJBDK+mPwKHbggsABfMALBS6x2f7BZ2yrdtEvMTNkXlHncaykfSxl6To
         oquw==
X-Forwarded-Encrypted: i=1; AL+hErH5qfk46rinrP1cjbodMKcXT8Re9GtReOA8QRZ27o6iDwdg+ih2kYoYjKMVQcKHA3zjrEjgx4SFhj6R@vger.kernel.org
X-Gm-Message-State: APuU4Z8j1GXfZ8oj85jD1wo5KnX6kjkA6+FEtzQex3NxD1sD180j8Lg8
	25KsMWmXCwy3xl/dT3EfjBqfyuEUHa/VVR6JFK1uQRhV6r2lJkAri4zEnYG0gugilKZU
X-Gm-Gg: AYBFou2NF1rXvvtlz/63w4VpIcVK6Lel5/xpa+W/VF7TeW0n3FxHluUlsG+TOPO8z66
	QnR6KtaeUnyAYbc+pSpwE2nqIPhnoKe6XqCmE4N+NKovfxVuthh05ZMrOjm0NbZOZQI7sZXXkd1
	IrbAAuvQqN4LQ2d6ov6D20Hs2zTGGFARRKBus0S3HRG+FDIv1iQfat2Zi/h1w84ocK7Y7AO/ZRp
	3LGz69f9/SWfSmOTmy4/n3ZIk45S2PYd7fPZs4azTzg3TjTR9bwj1owcRaHg3tcX1TrAt9PdnI7
	ggQH7bOvALxyjUf5zLhD2VBApM54MqSfciIen0/UoGzAqAJ+/PbUfbdnwFC/CSDMzD09DvW8swM
	Q0qfre3qatKQREf3u5xsawCg8AUmUCfmyI9/BXP6B5X6CVGV2Nsr9iwfGe+TUm2rkbD7I14lcU1
	yoTK8OVn0AM7+n0iiHfP/L61BH6aiRF0G8UmeoWxzpJh+DP8PVZpmwGa8pOM1rhnDrC/KdQ8DUY
	gyzvoFgWacCVnteRFb945GVpwd9MfC+YJFt+DtgKD1aNCv/Bk2szlm0MMrp8R+yaBWBc7YOV6Np
	YdSsVAntjLuZWqFM8jJJA9VveaFTqFVGyYnb1WRLi4mUVshi2FYS4ZNKssbziWk=
X-Received: by 2002:a17:907:ea93:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c50963bdb9bmr198299566b.44.1794563698514;
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50957c6c1fsm75151566b.0.2026.11.13.01.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Message-ID: <b42c9f4d29a9cbea66929c95cc8f736f12703c72.camel@amutable.com>
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
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
 linux-kselftest@vger.kernel.org, 	stable@vger.kernel.org
Date: Fri, 13 Nov 2026 10:54:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
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
> loop_configure() takes any file as long as it implements -
> >read_iter().
> Loop itself never checked whether the file was actually opened for
> reading. Buffered I/O went through vfs_iter_read() which refuses
> files
> without FMODE_READ. Direct I/O has called ->read_iter() of the
> backing
> file directly ever since loop grew support for it.
>=20
> Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write}
> for
> buffered I/O") buffered I/O calls ->read_iter() directly as well.
> That
> commit was about O_DIRECT handling and the FMODE_READ check went away
> as a side effect.
>=20
> So whoever can set up a loop device can read a file it was only
> allowed
> to open for writing. Open the file O_WRONLY, configure a loop device
> with it and read the contents through the loop device.
>=20
> Refuse backing files that aren't open for reading. Loop always reads
> from its backing file so a write-only backing file never made sense
> in
> the first place.
>=20
> Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
> Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
> buffered I/O")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index a3325ceab484..c96e35c3ef42 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct
> loop_device *lo, struct file *file)
> =C2=A0
> =C2=A0static int loop_check_backing_file(struct file *file)
> =C2=A0{
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> =C2=A0	if (!file->f_op->read_iter)
> =C2=A0		return -EINVAL;
> =C2=A0
