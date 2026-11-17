Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794903941;
	b=WCE5mq7jbOSN8g9llG4tfqNKmUIVvoRr8LIS6+uJ0zA1tIPiec5BIh/uNu+e+ZNXtRbG
	 mhSWH+BVYFx1E5WfvF8V1agsl8xWa5sbyI/87nhDAbsWvHyS10oBFqf1N+uutNEBHAdkx
	 CkHyRKitsyUU2qTpEuIdMjFhJ+rVsSt4dJ+YumM7dydl0+LU64iWJsnEYlfW87FPQgxbK
	 gx4sYW/5G5aCkyPyRO/Q5nE/vor63t7Sxv7EfB3zJRh1y0dNhyQmwOPNSF92MXSne/oCv
	 rsU1NFipHfnoJB2sdoNIOoOU6SjakAfJE98WhE6FHngDliw+56wlBRr7rC1btfwZZUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794903941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
	b=olvc4w17ri7n0VOKQ8mDHHvE/X414Zk2sbeBSa3NjzzAdzw66WeW2dTGIb99VCwiiH2J
	 InUl6gZNfsPt2mqIyXTZbI0QCx74JHrdtMbBErH4Nrda/TSjJXm0ZYzPr0KCvCxmmquVy
	 6db77eUw7wiI/ZZuvP63i8JfmY90nEyX581yGyvJTCx09ZN/q9P25lDTyEbs/fk9nBusk
	 WCmRiQDTUAZf2PPRn+lOtF+aZB4WKj3x2zFYNgQDjWQVHIPDkO4yzbjDTxMkMJUO5O3WL
	 IK+kq1p/NsVQ/Uuj1z8lOIGIFYEFwGPxsWaVWFre1t8JvNx3t8asJ7TzkUKMbCrHb0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="QoCmkI1/";
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23A0606A323
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 08:25:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B23A0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QoCmkI1/
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48dee593f18so4521680f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903939; x=1795508739; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=QoCmkI1/XbLLMuB5pWQjj6w7lhYbbqiM96jQW+pj9RZ000aRRl9S7H2qSmbtORMNOo
         ePt1TXAWzVIR/TrMeI58Zu3n81XgIdPHavzyhyljr/3uEJYZwsW6Sg14gd450d308jE0
         RrvE2vSlthe4MhW9V05IsJzW8g0CM3u+nfQ1hkfntpYQW6a4z4zmXmxD0w/TiuzDbd7U
         U8xZ2FexNWbZhSQ3d3pA0tlH/f0MOfn4O69UeuIyRM8vQ/YXTKpGPDyGoQczoxEfoynP
         BDcwZppUf46pJGXZ+RH52kug0iZSl25eld2NGIqCa+XVs4XFwFr0CZI1pzljVyhbNHw0
         NmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903939; x=1795508739;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=0HUpDIHEFK7GwGA87dpNnPIAVUjUy0xKxeGHNkE5fyT/6vLfWZtIs1VbmUCoVc4AKk
         UdtwqJaY/t3+uU7uV+TTr40sIliPcGjhLGZE6vMs8coF1lkDyxzvAEqyDENtfwmAwvkq
         3JQw/tPDvnHKjrxZS47SYcqlQzrHdcgG1u2tq1jf+ZLtFBYyKGgGFGQUd6K2ja3YLECM
         AIaSR/vNz+QCY9U5lTRc1iu523n/OQ6e9GmrPqD42Hj2SXqUwodSQI4JfbZIlAhfiLSb
         sQpV0ySxeTcdCd7BWGUkz/72S6psmapvDf/QzKJcyv6nEQTd9Ogm/RQZGk3sCAnFlNsf
         843Q==
X-Forwarded-Encrypted: i=1; AL+hErHWUeS2zMHyBMzUGBadAxXpUeiLco63L0U3901uvrCx7/Dt9XuGFgLbiJs06MwI0J/mE30Uh4XUyQS5@vger.kernel.org
X-Gm-Message-State: APuU4Z+sneqUH9MvOXMz2L86msUhN1KhtCeNfnowduiRfzGIvxcLosNW
	NlBgHQ3M3V/PnEGIrJEGD4SRA6i7pHlIxvB0UQugBYCEKD4TkZBGa11EhqiJQk5nc+n/
X-Gm-Gg: AZFdTZey2p4fyvy3RMfLXxSS541gUhZF/oiVfzO3sui3OQ5kRBUbkTUROcNnmWrgaF3
	iRJVlYsb6cPFssHyYludBGa4ootPECZ50cscOO5e4ETaRDer0dLqcE7K+GChuU9kgCEZmYsfo6W
	YmzoXX/LkEj7GXfSg+hprBtgXxQPAUUJ6gguUk8O/5bsI4yofZ3q8xJhUA8K2MmiZYdeJof0cgj
	ct4EHrJzRS5qTVwxmM9PuhZ9wU5ydFb5h3J3gDw7YL/zu3mL6riv5erq90HwZZruU9gTYS94zD5
	SJY1P+8LIX+nh1/aqMhQfDXRcE/vIIT4KqlSItAt3c4JIDHYI7hIwIMUGH2kNCPu2k8s6FgThFQ
	sfBlYvOdPshaVH/Ojxt9syHcV05Y4gEc2OYGVZvcSzZxUmO4v4XttcMhNZfRtrD6BUijiWCR8Wv
	Yvki9Eo3T2pbxzY7Oc9yv9PTZ5zd1OQJlwfeQL71Zw6qjHQbXrttTMSJU2wpvT/bfirnR02vkPc
	Kdd8DiIZtqukHRY4vdHg3RVtnEKZVJfH4TLk4BlRjzgzm4rZ4ejdutsWfU3D2cmuFD1C2pCI3O6
	LYka/kUITh+qBv9hfQXtktuE7dYRzStEqfah7fnr0rktiN2jDcf6Eeb+fyf74fh0MJDeToFU29V
	Z7ajCj0ipzh23WiOcYSG45lz4jscyJssMvq4+uGr9tjMhsy1VwMR3EMJeagOCpKhcV2perlonLs
	r1zw==
X-Received: by 2002:a05:6000:2084:b0:492:46e:d4ce with SMTP id ffacd0b85a97d-49c6fd932c8mr25238543f8f.13.1794903938925;
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm26907832f8f.28.2026.11.17.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Message-ID: <a9124bf1c858cef3e8ac06b1b2396dcb0e19e2a5.camel@amutable.com>
Subject: Re: [PATCH RFC v3 02/44] nvmet: check that the file backend
 supports ->{read,write}_iter
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
Date: Tue, 17 Nov 2026 09:25:36 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
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
> The file backend calls ->read_iter() and ->write_iter() of the
> backing
> file directly but never checks that they exist. Everything that isn't
> a
> block device ends up in the file backend. So a namespace pointing to
> a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=3D1 gets that far as the O_DIRECT open fails for such
> files.
>=20
> Refuse them when the namespace is enabled the same way zloop does
> since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
>=20
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/nvme/target/io-cmd-file.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/nvme/target/io-cmd-file.c
> b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932ee..dfa8aa46188c8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
> =C2=A0		return ret;
> =C2=A0	}
> =C2=A0
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op-
> >write_iter) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> =C2=A0	nvmet_file_ns_revalidate(ns);
> =C2=A0
> =C2=A0	/*
