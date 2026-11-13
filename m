Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.225.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565562;
	b=wlt79BBjEUsb3y4NZhRqOx+OT7OwfdrOhRkJIx/2/Iy/wjJSRywRAFxsI8qHywiptUd2
	 SIrtamDozOA+pRfFxo8ZrW/gy8rKzssL1AjWpgPq9e8GjAQWWu8nnXwDHsCa7i8opkoPu
	 BUU/0VcZPBl9jU2kS6tlB0+keMLw6RfNFX37vY+gp961chAhYYBjMWBNTJzqPmV+iUS+g
	 NtkatwdCkCKEdrRRoMMduJwHH58zLnm1MRenJg9ib5nmDkW5iVCd4fGKviKpIiV7h/38K
	 JkJeQvjgqjrRe4dWMQRrVUNPGr9cUQIuo0z4aiAse+dxRDwKqYVD/hU0ZzYRWRBXpoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
	b=rUtPYm9xYMpTJehy1EjSq2sC/I8V/Ic6LxqDLO5Gs2MW6ZNyU2P6VU1SRgi9KjHzKU4+
	 xIyka3r1OVnMJRMLDaGxSShvyuIlU6KJJ4EiaQn6y2+CHMGUXhZ4/l3FdnP2wtLzZzvJl
	 6Knr/wUTx4Nks9uE8QKedEBYyUeyOmK+FawfeVsZ2rZaA4SuSL/7w+JNHjajpBJJOtM0j
	 lTzudgD+6D6v6TUMW89F2vDQzblSqqQdW1UU8llingEqKba0ZGUlh0dUQj+mb2gdCYpbA
	 cgymLqAHz3xx56roY9aM/GEZcvGR4jjuylbmhyg/nTNxTlPU5nMLwZnZ2h33vZLujFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhCy1rjV;
	arc=none smtp.remote-ip=74.125.225.138
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB51E606A88C
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB51E606A88C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhCy1rjV
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b80834ce1aso1170675e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565560; x=1795170360; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=EhCy1rjVxVdFrlqlBXdnWdhZOgju6UqPO7MHP0T5eDQlLH3bu4fGnJjBmSeu+X4e2W
         fqknndYp9WUsPcSw+hMOJQKeOCVQ26f4CApHOuaHiz0ZnrEcpw06GAGjRX2e/v0KskXR
         kPbczhlJA2JL/E3RYwJYZ55bjMsTqV1bcwrFG/iNBMGzSlTlhWz25UxyOw6nI4axYZSB
         u0krz81cE8qJBpZN+Gj0XIkGJFuZa0vCttP7+3dXPKfvLd7fzcQdMwTNK/JaleYs6P1m
         dJAReh6EvrYwFB4nFlJdvgjX0mrHV5c8k7KozarvFnbaOIXtcKdLHY5nOcL1YTJjLQtf
         x2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565560; x=1795170360;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=h7yWFO0iGoq56A6RD/My+iZPfUMlgM4p4ASGrv8xxhWgFjiu/IYjJ4n4UViJ8fIjqp
         rlFWJ6mha85lPChbPk+SbwyxBM37uFK9ACrgcuyYwa+5OVEIqeE9Xz+Ssk2QTsGhEpOo
         SUoQv4l5gDu2QIqUOccrZkTNphy569w3Z8jTr07V6s1cJXsmmW0+z0La7yV+Xqoljaaw
         1mS25Lxfb7OVx2rcJ4X+X7z11UEAhmK3Aq96U/nfRQHa7yvLBYYow0k73QGoODwU6drB
         qKPWQg3wzY7F2aK5t4cDOZmbZX3D9BMoSo3YOoh+gi0iQ1v7qyupUfB9BII2+n2mkHV5
         XumQ==
X-Forwarded-Encrypted: i=1; AL+hErF7+Ued/H9NK+yvaFSbPbu0OmpYHtgsdudH2S7HxTcEXpJX8e2nv/7PdQBWZPqu5JIpMpGQnvmYx7n9@vger.kernel.org
X-Gm-Message-State: APuU4Z9PqpPUBvH+nMPjj6h6DRmTLHIxt2pxBfGCyS2v19sQ6vZkv1cH
	s2u5394oTtMfcuk+2/WOcW42Ay+O6lfJOx3Yg6CYzNt6oi0EMlhsndVafMkNv+rw6xmS
X-Gm-Gg: AYBFou3t6s5tX6cEmCNps643ZuHEeylsqCnUQGkygNVdRJnMp1LSfWIH8+GD+ffz8+J
	UHUEC+NV3UUgv0H1Yyg99lcLdX+XDUSRorC0VOzMEJx/P+2wMcgFHDLBM4N6ZJJTU1XojRYu30E
	ItD7IUrMP8/87Pu6yS/wiTgG54lAN+FDq4Zn41uEAcW5IIwenhVi4rXyA0i2aANzlfZ8iowb43y
	S6xALAMRsbEXwl1I1nlEd6/oc7QlnWefDIK/w9Jt6uzEijMWXI2n88p50JSvCy4zr+9CIXOf281
	aw8lnZvv792Wz3HQh+pGgqSHRNEeyGytKYaBima0FhZ+UmCNngWUw74gciHQ546EWVYkdmWCOKc
	hDRQ6Tw8UoD+89cw65L4r0e4WPJ9sVxViRGDSLfzFvD/sabyj7rZZrwGBQrx7xBGfXfwl8HjUKc
	nYGtDQ+YroSjXfnI3w3E0Y0m05z+dmAdff6AIvTPh5JWxFCew84en8z39FtIAQfrtbKcnSI/RPv
	a9uSHuhBT7BGNIsCDmY09fGh4lHjCMYggiXkp2mzpTb+DhRQmIpDT/3vPblT1zDqzi5OrIR0HmG
	NxsC+W01gX3qqjtkXRrE2PesTvVK+4dWwHkJnrLIoBg2njUCI0RUroU1I5i55Dg=
X-Received: by 2002:a05:600c:4e49:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4bb55aa999dmr38995625e9.33.1794565560090;
        Fri, 13 Nov 2026 02:26:00 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm244439965e9.1.2026.11.13.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:25:59 -0800 (PST)
Message-ID: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, Chris Mason
	 <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
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
Date: Fri, 13 Nov 2026 11:25:57 +0100
In-Reply-To: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
	 <20261111151202.GA11391@lst.de>
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

Hi Christoph,

On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> I've seen setups where people use fuse to mediate access to sysfs
> sysfs in odd ways.=C2=A0 No idea if that's still around, but if so, this
> patch will break it.


Oh, that's painful. Do they use backing files for that?
It's a relatively new feature in FUSE...

Kind regards,
Alex
