Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795089430;
	b=U6NDux63t3r59o7EnkxbzCUdF/WDKED9k9NfbDO1moBGrzaDWta41R4KOvVcJosP/PY8
	 Vpexchx3g+ADBmKhe3c2cLwBd3mnzElC5rYIlEzqpScmslN1Sr5HI6mwx2KZkTDP/Ugrn
	 /CCALcrWxBRizE0ACKN+HCjTqX7QrAZs6Mbz+pkA/FaK36EtvLKYNCkIY2TyvdFlYsrL6
	 oQOl0GD0BfbwKeYZ9X/wDv1lRcVdA7791fHPULEplBuf0JvfLrHuS30I1G7Q/wscW2RTE
	 X+6b+hT6G+qrvDMBZi1j03Lvj8yWZ2I67Ikw8OXPANXI3/Mj0vD4Ubtp5BZrkQhSVWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795089430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=zlJH4+t0mXQ/RY9w29YgUuQUml1Z0NJ3e214jG9j+bE=;
	b=UM/9A3TvIWawTMd0Xtm2OnMSGL7/zvdHRjNEfiJmXU/4n18BXcQsYij2jJaleeJtYXEd
	 qhAm/QeydRzYYvKBVK5M7T3DR5bhBfvSFvIXa9oJVmXLRTDS9LDMNPHp+dxO41hOi6G6C
	 T8TsUDCyBTqucL5JH3L4SyveGloVD2MauOzXn1UewXBR4T7EKvcM5OzEuvv+EIdbHy3Wv
	 KHSY2iuDVtDZGKeU2oiYe4O8Lo9dHEwslmCij20iD+KHqQl0LfjPx8UhNR6hul4nT1+0r
	 Sh5EzMtXye0LQ00BJnFcLB32tbbHV7mQXCQKuAPA0kkqpacQGFNksNLYVptbEYe8ctg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K3dI6WCM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55F606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 11:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D55F606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K3dI6WCM
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b86bbce3d1so2926776a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 03:57:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795089429; cv=none;
        d=google.com; s=arc-20260327;
        b=bOb696TijGoiV9lc+uls7S1Mv2ZcXC8NrKgtaUstVoLwofDCqgKrOn9HatapDN8nhE
         HoKmzwz4Q0TTK1QkbShWPA4W/Q2jRqqlRvv8K2+c15V+VgLudNdvt69MRcnf2WGpRsBY
         vOEGnFLz3zpRlF2w5euoseKHUHGF13q7UvnMY9tDYnB6JqxyjIozNuwZKKzJT13JP4+j
         KE/i2LB3Ka5AXqdMk8193sm9Je2oOlbyVQoLz1xYSI7hW5UZOx76P2qndGJAFJiZ3fDn
         iBYpDxny53QVUN+pAwFpNsZUedTbEgAp/LdLf1mzQFVV88+JTg4BzFQkHlWJEwf4dZjc
         UH0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zlJH4+t0mXQ/RY9w29YgUuQUml1Z0NJ3e214jG9j+bE=;
        fh=xARd4A7pfn/ZWt4/2HXfziBeRj5GJOpe5pfcF9dg4zA=;
        b=VcKNVsbYG57L7+Kdf3cGfOE9xQNe3RCL9VVGxTqDY/PtWCv8R+Z3ZlsarD1iV0V7r7
         end0wtGDwLwcgPWeeJSNtwOgaNKW3TSL/6Ve75LmKB6Vjpxmn2CHkY8J0UDmy83IPQQY
         5ss5vB5amlwsISDqRq27/TLCMHnc2priVe8vsooDJM/ascwxd4ZZ464AIw1GbyDtfpP+
         VycO6oPkAXAhzOo9UFuPvXHlJWhjxPZZ28y9fhbRgHbUrhsKEJr0UAjVVBt0eVJLY/zf
         X9bp8NUEToIsLmusVg23D7QtV/pWsQc0zJ2SRNeiV57I7YTu5YQEdmqMiWUdArOCXAsR
         MnQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795089429; x=1795694229; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zlJH4+t0mXQ/RY9w29YgUuQUml1Z0NJ3e214jG9j+bE=;
        b=K3dI6WCMFECyf1dQvj6+tjaYhjJfKrNWoVtixGzRQjg9hBHKLgJUV9jS2ejMt8mV70
         FUaP+VD0fcCJw8DuPW228fHRIs6UC5YTRaFCorGpUjggIzvfceeT9VDXSeeAsIM4K/Y0
         dI4yB8/W/9IAkbZvuNywYM1ulat3Tvp3Njr+CBFpEqydko3cMlGXfm79vX29MEwCUULD
         4PXKV0848aTIpdf/FMtlUEqvpn85CPFioJ+cx/TIbaDofkrnexNAEQtyqz4Z5zhLOoRK
         MPjWIUb1cuC0LQ8yBW88FLiqjvp3WQoK8vkiqGXnwluJMY8FROgTztlluOynaxTORKBO
         XNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795089429; x=1795694229;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zlJH4+t0mXQ/RY9w29YgUuQUml1Z0NJ3e214jG9j+bE=;
        b=G9kzUsAzT3XZAV4W/jqfdl+1HIMjwvkSuqylIXzRA2uzWMbO+LGBYeLZmkXg3OtWpk
         8BCtgPN792BsYYlJEr2sntybxLqyfx8GgMayqe6+S3F/5trpYxQ5BQoiACxXkAxiz2/b
         JsGVc35l29fqM//0Y6XmQ7SzRGzY/Qqy5pWnW02mRMES4XE4hURt1VI5AukyhP2YhJsG
         Z3+EB85r9/OIEH5IkZfJDOlD1uCAzhQ+jcTMh9akWHp2bugK848Wdkg514d/zy/jbIBr
         X3QnhbmBZzEm1rn1Zbe+lza1LJ/7QKPeYa7qz+fvm5HtG8oRv3t6WHCYc1zfD8NY7t0W
         74ow==
X-Forwarded-Encrypted: i=1; AL+hErGjW0aKK7E2HkBC48rxVQkEql1QUdqy9jxkdMqpNQDLtOXWbkNY0eY1C2HK3OSbxHOb1KZo0yhReazc@vger.kernel.org
X-Gm-Message-State: APuU4Z8lt1rVn7rIKdrkBHP/l39MdGA9iKTCINnbd+h1H68wQm3NL7y4
	R2yu64epejOnp34qJr53NVEJXSvkNH59UK/bn+F6xLmuCA5EQozVk+kdbsDR16oL+d6s9lGEQCe
	Q+/F6HBByReVkUymSL6HYnGRLIsoMzQ==
X-Gm-Gg: AYBFou20KcC/DuhC0r2c0Yg1CkufHzJIsfqwGh9TNtMI0mxBSskGCaMvzpcM/tpQWIC
	kmFmtGfoMWOzFvRFWe5Y2EyFsmVM6AcBclbwIZteerUz/M7CVtTySJ2sNkk36gjLbnpY1o32LGX
	9itefX9o+OQtsC5UuSyimNN9O6WTRL6DmeIPO53iNCbGvRQzCd27gVpLrosc2S40UxamxQffCSd
	lVPYVDlqo/5cDY5TqzhCuEDRsbqXYFMf6af6F4CCvNfpPj8ng9kwyqC6bDg1Q2GyOct9HVd8dA8
	lCyU2T7y0TYDcRglFrYq/hZ+Y0htL3kRg5rJXJwawpWFu+3iSHYTa1uuNnGOqOIqGGR8zaZuqmz
	jXMxw+ilnSf3LSSgK8LZq1ZSzPzHzmPneGSYArVGmUKjzDJYqViQyMlbBsX1GnbfDi5xDFWIzAE
	oKmi58Iya9vx6WWvzhzKJ0BLPO+kbMd7n3tiVa/MMJnDxHStI1N4uQi8NPe+BHrxloEx8=
X-Received: by 2002:a05:6402:2341:b0:6b8:50e:3bb0 with SMTP id
 4fb4d7f45d1cf-6b887f051b5mr5100854a12.43.1795089428496; Thu, 19 Nov 2026
 03:57:08 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030014540.3065403-1-anuj1072538@gmail.com>
In-Reply-To: <20261030014540.3065403-1-anuj1072538@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 19 Nov 2026 17:26:31 +0530
X-Gm-Features: AclHuK_SZqZJTPjuQjOc7cIWYhN7F4D2sFh9VtkHTF5WSy6wsq_qeWgrWRBsOwc
Message-ID: <CACzX3At2GfpQB7eE1S2njJONChr8DmDC5poBw4pX+pAg21cscg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] dma-buf backed NVMe passthrough I/O
To: axboe@kernel.dk, asml.silence@gmail.com, kbusch@kernel.org, hch@lst.de, 
	sagi@grimberg.me, James.Bottomley@hansenpartnership.com, mkp@kernel.org, 
	bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
Content-Type: text/plain; charset="UTF-8"

Hi Jens,
All patches in this series carry Reviewed-by tags from Pavel or
Christoph. The series no longer cleanly applies to current for-next, so
I have rebased it and posted a v4:
https://lore.kernel.org/linux-block/20261119095615.1840522-1-anuj20.g@samsung.com/
Please LMK if you have any other comments?
