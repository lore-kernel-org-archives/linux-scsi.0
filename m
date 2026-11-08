Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164398;
	b=qQeinN+WdtGqINQEg30uSbBMisDRUxfdZ+T7BZENGHyo119g6+SXpkv46ojvcjIA1bDK
	 fHQ/1LUFt8+Y8CpDwN1ps0PxCEs4HHEbN78sA5uAm3MQBbzNEd3pHmySaf/sR8ShfOzTX
	 8iyY5wVuP3bfxoO5w8/y1HuiMXQXH6B+8qV/hhucILD+VXzi2hdiPBm4c5m9a5aBN+xDa
	 i6pC6Jw0lwBCmTapsoVSKKhPpDRdfZghGzvv2KhTH9OzfU2YX7csUJa2F+MAIkx8VRWNs
	 NVZzzg21+K7GWJ8S0VB3y718iUIZA6uNdjBdjdS60LQDH5kSfAHoljCZX8Skmj0IEwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
	b=EjQZdtmU5B0kKKcNRQo86X/xRPoX+s78C4mVXvgW9/vk6vFyfri25Z7i4THPDoXn9WEx
	 mTsIGS29G/wg4rZ7gSH3pYlTsLHO/xgvbf0JlZoX8nKesqgI4cAEtuK50C12Tqx8W4q6R
	 5iUtvuaq6zCa3dA6jjxUGnOLs4AxE7WedNgUeLMWSBZbaQrhxOW/GqD+aet1C4Si0dGmd
	 YWMCDHHsh7mFD7xSk2MOPG6eHU6juAZTUTjy2ShUYH5CcPVBw9H8bKFSdnIDU99pqHnFr
	 wj9XQksC7Llv5NYJGA8vJ6kaESOutFrmIIBTIg5W9/WICBhl/zYf5hAIbdsA1TBXmeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F58606A32A
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 18:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32F58606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso1791485e9.1
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794164397; x=1794769197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=XrEUEgHUwv+lt2Z0T4RzlOQuYT1yMbnY/MJrtF5HY2pc8m0ujKE+1IGJbqc3A1SsPJ
         Pz+po0Wh7ECcrOl1hyNdZBme+OsO/r11IeCA1lW9KMbstFhlOkC0Hm7Ef+TTavGsfrDk
         7T2AE8nlcorDhYFpLo0KTCt4xOv09AacMRilfH2h4PS2mZ0iBReAF8XAcgtI3iT+qlRY
         EJQPYUIUlDRCCjadf1+24R8V0flZyhCZpLCroCVsidoQ510350k4POOaAcSXgGRrBTWF
         rbpUnz5O6K0TOR8uz/zwLHiObwDAqnCJFWP0+ssCNYCBYnXJwQ2yMfUqdKkv6ro/lp/q
         XMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794164397; x=1794769197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=BRrIXe498gsaHjS7yolmwaSWaOjJy/QCKh5ogug5aMZDQirIxiS88D/q+P4LadjqtT
         LYexyGXU99P01BWJGtgZ7L6Glk3Mh3ybZjrykAZ69hFV8M8eJAhtmyQIUZTMHp1Hi7N/
         wZ9B/uSRlvJl3P94Pso+MTZ43VngyzhGC00GP7XW9+Gb/nfSvBJyI1/12TW3n7CR7vBo
         ZouoYHBgnizzxFP3ubGwyikwbN3MN4x+PkLJPCtxqgSJJU6Jzj9jXev0zxDC6iBmTsBo
         GWdir6ELNmyU16spvzX/RMqZbImK832Gf3ASwDBNk7MyNSr7MsO1gmZJziXgAgIxN+rK
         K6/Q==
X-Forwarded-Encrypted: i=1; AL+hErEsG1ZlosC6UA2PXYOAMachqYJBOkdW70CHDOeYQXj5TxP9hVONro2JM9whpI/XiaimfVHJWprRiq/f@vger.kernel.org
X-Gm-Message-State: APuU4Z8/xp/4UmJMNzplf39Rb55R3HwdGjrozfzavI1Xz6U/4sjpQ1Nz
	tDeAlLdvql7qWdTPr6yfHg7J2tgqFS1BGzfuntPy9rnSb6dsX28l4eUx
X-Gm-Gg: AYBFou0apGMoWz56caP+Z6YuLVhAncNIoSZGzHoNqsqUecz1/dRZTOcvjPBnbhKdAxV
	oy64Ik1o8UjC+5SglTRWzXVOtm2EB76S1DOZPYHK6CkgfRoSTDxBJNvyCC4G9FOL5TLPl4jS/0F
	LiS9TmYA5e1OTwGmz/Yf+zZjzDyxwYc8LF1zJ4lirgBexlY/iFIkerjbYJskXOUy4wCBkjDCoID
	Nt8KpoMeOY+j8gAomlZSRj+lDFI5aMcwfHtrsUjBtX6cWh/yPt5xIMDjeR/xnbry9kpM0w+G9GG
	5bUGGnVBzVHzyuAiU0flHzY7bmfPktkNnwQg4UKBtt5jEH0sOsq2qQ4HwoStBUYG7YR5/z2pGBL
	hVkFvSvpXu6YXT4+6UrQ27TOmtjYjKu2ITrRShEO84fh8XJdeOlGqeHHRUTRCDQ3pp1mb0u4/ap
	Jp4/Xqav/dpj4nxYB2HecQk60nZpsvox/wxqJl7ZGekXFxjjHQ2yP1jAVQveRyrsV086CTpvP3G
	swe35yRVZL8748tVdVRuDOHGbB2zqrCn+Si8ARBE8/m/6E9tBmb/4iU2v2/8nVQHKISjeL3Vi6+
	EAEwT6M3Vk4cN8n18cBz4vke2zA8rexU4QSTRIMLJ58nYyuW9Fg2QOgXwfIFtblN
X-Received: by 2002:a05:600c:468f:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4b960d9b170mr35982125e9.5.1794164396406;
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1f3acsm185228445e9.14.2026.11.08.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Date: Sun, 8 Nov 2026 18:59:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
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
Message-ID: <20261108185953.28054fb3@pumpkin>
In-Reply-To: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
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

On Sat, 7 Nov 2026 10:48:35 +0100
Christian Brauner <brauner@kernel.org> wrote:

> > While at it, I think it would be good to use this conversion as an
> > opportunity to replace "char *" by "void *", which will probably let
> > you drop several casts from users.  
> 
> So I tried that too. The thing is it drops exactly one u8 * cast in
> ntfs3's label write. 

Since char is now unsigned that one isn't even needed...

David
