Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794260763;
	b=3aKrVZ4isK7PQuMviFyoWlWynqBnkHLGh8IqPyDtDqxj5q7RBKkY99+Cy4irC1hH7l5K
	 O1+TULRYlfbf1z9ztIjtxFhZYLZNLAAiui7v4/H5RafrpGBAHZhYCrYtB/KYZ4Y+dNlJy
	 0w98xuu97EALUT1eKFdlOWqXRM5F6F313A7GXt8ttxW/4FMy5CUJTdnxWydPTCmFkVpVd
	 INh+IaqqU3P44K6oYsMOX0gRY2BrNTrSbUHsA7/4s5GUloxhiFGAPMmr8WUe29wZsZ3nq
	 v+57JF4nvuSK5PIipWUvC4Nggz2ZLq75f3uk8ZazNNNqXfCQ/Ytu7f6+smS3l8/GPLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794260763;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=874yjmK9ypxK94+nKOJ/uR1d6HpqK0owgIThZQA8ZUA=;
	b=38IO1PRsLEy8NdRdjA+R+VKg8sWZHG4QAtcuv3MhR6TG0dZWG9wbXhcj5XWpMkdWWdQz
	 ShiI3/9VXCH6oCInQ6pysqTppbnQ7uiqXFYFzZFCO2sSrr5pdGHrdGqeIC/YyisleFjqX
	 TX1IfLNUUP36ivg0biqrLBcyvYgAPtCZirgh0IkCJ8VciIi582V6iexBf/xM/b82uDbMw
	 IyjmS1d0Z0h6uThNOC56BSq4A/C0h1jvzUJMmMkr1c6VE6edbs8QCZUtQzPmSlM7j20ns
	 B3SEM58KejM2X/3NJ/khCS85uTM1U39da0hnpDErd155YrwYHMS4Ok8Z+vXOQ/e+/SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LaZ0qPv5;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ECF606A335
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 21:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96ECF606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LaZ0qPv5
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-490c1d337d8so966216f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 13:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794260761; x=1794865561; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=874yjmK9ypxK94+nKOJ/uR1d6HpqK0owgIThZQA8ZUA=;
        b=LaZ0qPv5+whTFQHjIA7oYo021SUS2QeXnWN8ii9Y4im7Ue68o46nz2xh/hHMwIUfQ/
         ICad5fyoXePYl6/8nNVhZk6UxBKiDwJbHcHq6QklDSJskt7Ox2MaUqpcgklbAASOb1WD
         7U13gt1MK2zXHTSuMFiAfjmE40I4QhfpTIR2Mc6nMOBQW6Dg/mqe6U/h69Hyf/QnrKae
         CyKIviPRPYc2tnG0IM8qOylYYY2PKnrUJzf833wY0ZcFYDbyZdAS7ekVESO+FaUUNtdA
         WzN6sPDUCv7pE3hPSGmxzNcqgZM1jmpktE+mpPCXGo9ukB9qCsiBySNit7DIM51G+Ivt
         K68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794260761; x=1794865561;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=874yjmK9ypxK94+nKOJ/uR1d6HpqK0owgIThZQA8ZUA=;
        b=GRT343HoEA8Dn6W8AeCIxHhLHIWvc1CDRhw6UIO3m8aCJRkSpFcuEO/KaH1GOhP7y0
         WJRuFgoOOuqMD5LjJ1WdY9Nh0I1w29qQx2v+38xxKw8VYryj3Dwm4WIwX0wKHQ4movHi
         AhwEWqN6jibmqx3Sb0R0I2bk5VcDNjtG0hv/xevFFEgAYz28Olr+9fqE3zkQG2Seb0c3
         PvbDSQBNZA6MKrbJZvbinwa6STXiLkhXhIojrEWxRFuGs6BgCphXNpB1ArSo86aGUpJv
         SzzenGJAjo+WxjivxZkSmT1n2d7dWGsFtQpSREEDJMKTaEB+eIzL+jOGe0ytG56AAZMq
         +51w==
X-Forwarded-Encrypted: i=1; AL+hErElWHkEdgGyAvK5I7O2niUwlIdnlDbl3CzYNgaXjjY/XSfQz7+j8VlGS6t8h5LHeXeJT05QSON46ACQ@vger.kernel.org
X-Gm-Message-State: APuU4Z+XTehCIR+4QcS1Ezr7YA4X3fmsKPc2VG9Bxl/LdgSY49w7oKTy
	irST5LOfWrPgjY5xZnuM1wQ2EuZR8fE7FP5AOry9bvtmQFaIoxhlgE6f
X-Gm-Gg: AYBFou00NZGXd5DQqPF42HJoTrAMSqxlrNNvRv38GYFTn1Tsy+Ym8fICJ9yf+bnpbM5
	77Iy3jQGeSBXuQOcKuGSAXwwH+oZQ885blFgi3scuBdhPOpOQA/VVajYrKlf66CUvEKaav0SvbR
	fT6RMgFTOwLim+L54gX+dzhNvbbnYSjXUVLQ0DiTadlozCc9qIhZ245X8bFDnZKA6Ku1QKuXc7R
	TzvTcX7SwqKEUaWIVIwjTd3Iv6ErZtTfRvslhRi3MvmXo8XdGrWdigz4PiP4OuxQL0nritSWZwN
	ePKnGeboQQjtv0leOA4itWlgYpDKOVomX78UHQJv/XOvo0QZ1L/kPvbbBBfq+mQZMEhn7otVjj+
	awcEzPUAo3Q1rYkiXUJU2NtLRCglF/WbyOvlFfNbQCc9AcVbaJVyfx0YnGQ39JDejiTtmNzjwY6
	E6g9EMvyDuDL1u+Q2+kGy+2sinM0fyun3fNJx1fk01uWFsPDsEX1Mss7lc9EHChIkIw4KS/PnF6
	v9pr23b3OQEKMepqZdx8IV0rVJzaDcoeZvV2vaRIwpu2pneYPwAnC0LVRxIIC7AvQ1+TJPiqVoi
	oUyO6GRyhPN8JNegOQ3SVE5CaagR3hgoAUMrEl5fnQvA0iTPCDG5j0X2fSpEZ7P4jQ==
X-Received: by 2002:a05:6000:288d:b0:48e:25e1:5eb8 with SMTP id ffacd0b85a97d-4982b28aa42mr1487213f8f.3.1794260760763;
        Mon, 09 Nov 2026 13:46:00 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983585c4fdsm1213644f8f.10.2026.11.09.13.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 13:46:00 -0800 (PST)
Date: Mon, 9 Nov 2026 21:45:58 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Christian Brauner <brauner@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik
 <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet
 <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph
 Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara
 <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mm@kvack.org, linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
	<20261108185953.28054fb3@pumpkin>
	<alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 9 Nov 2026 05:05:57 +0000 (GMT)
"Maciej W. Rozycki" <macro@orcam.me.uk> wrote:

> On Sun, 8 Nov 2026, David Laight wrote:
> 
> > > > While at it, I think it would be good to use this conversion as an
> > > > opportunity to replace "char *" by "void *", which will probably let
> > > > you drop several casts from users.    
> > > 
> > > So I tried that too. The thing is it drops exactly one u8 * cast in
> > > ntfs3's label write.   
> > 
> > Since char is now unsigned that one isn't even needed...  
> 
>  Please excuse me missing the context, but what circumstances does your 
> claim refer to?

Just that the cast would have to be:
	u8 *foo = (u8 *)bar;
where 'bar' is 'char *', and I don't think you need a cast there when
char is unsigned.

David
 
> 
>   Maciej
> 

