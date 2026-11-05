Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872332;
	b=zD0QA9o/hlvWQ38tgI+aJ9Mac6YteVdh7HknB10VwU0heW9dz2KrD0U/+E+FFzFAkdNQ
	 aNyLAKZKSZbqDxY5DNj0FpIfcw6n4cyi+HthDtawZCcydSDXuu9MBoIqGWjV3YkAv3gir
	 ViBFnaWytmF1c04rGs3hBELqk0/5C3xgfo0wQmKz/J+D/Pcjxkf01CbxvJnNfHQbI9+Qd
	 vJjk+x53AS4AuNar02VS0JPlW6yrltcK0Rm+6OoiE7mFhSOvafmBaecyUlHFU3U08IfG9
	 /qbwwq70P2hdaUSZDuHyya4w/E7jP+8km8X6GjWKFLKmJn+ri6+Lg3jQaZzhEJQOIKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872332;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=Hy4sGokz2ld//ogz2ALZ1hqwTXS1GETuHsxxhHpnDUU8kvCJYX4Pi1XE6Z2LO9l6r3vN
	 m+xPkxoS4XSf8iBHVuoTxKEDX9CDYE0lJQtjXcB8uZfSmDO5rD+6DFTq3MFVTM99mBjnl
	 FXIhgc4pdv2eEaQOGIE2vuxaOo9jjAn8alAXQIxknl9mjrz2wtMzfEp2q5GR7PPG3L0VV
	 ysTj2XIuDnJ2CyS6Awer1dww+lDKgplM+YZdyXc8PUnkRByajYyNsyObFycB5a72xsF0G
	 GtjQYUf8cHJGYsBaT/5yOG+jQssz1zQ7pi93r9sZKqb3tO5eK4xie0PAfQ6zN1NEnOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.222.171
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759A5606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 09:52:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 759A5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e635220b4so159079085a.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 01:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872331; x=1794477131;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=q6Lt3BDDWXlNOIDahXk/SQVIxaY67WfhborM5nK8YrO79s5TEeL/NXVpypFgKZBDeC
         AT6woK2xFEX7qPlaGb9BXUcfzxMSqzZnVwOlVkGsqIqY9nyYCHEzhqRsDBPoE8FC/gEP
         aSoYima9tyrdwhPd372ZZJJaNYIZ47HoH3+eNHY2YMdGpG0iIavjO77KWEX/qnDVDhh6
         ayf0vioCcguiGxSI524uEZ1KZiJAxGPk462Z5Yl39xJV6vZy4giDP2mAV0iecuYijKND
         4tUVgXbRH3sLbOet/i3udpC7/cAlUe1EgC0iMCmcNBHvMX7nml1I77zVk7jVCnIXqrIG
         fqFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwp6Ftbt8aPpr8H2gJ2b6CQvSMMOGIPw4fFPJPnChkybRBxsb2S3sJHckuQLTT9E2q0tCLb4SlvIu1x@vger.kernel.org
X-Gm-Message-State: APuU4Z9cvYuMtRWKNaBg32BiX7a+hqcjrw1ysFHx46SpE4MFCgLjK/Yj
	bE/pxkHcP7dzs3F3Q2jPvM0D43+HQ7pzhAw1y3YT5pt0QCF5hAAvlQ09HMVMX8eZf9s=
X-Gm-Gg: AYBFou0M7uwEFry15vsaysDJZzHNaH2uYOZUoav9zJ4cHxWi90V0y1jTMFXsdzUake6
	iJ3Ealzc7jB7HvJERaWhNMu0QVBS9kKUnXu9SizZPGsrax8cCQTgXt03+kLUAsMeZ1mJofCcpeG
	wX+B+QDejOS8nx+3qE5oRl6lZezB71H2/vetaf6q+8m2zDVlzMkkg4pSC1p80DKultJ+YmG7bwI
	sblmqwE411wF9UmwLx5y1y1CdtTLxlUX2Ofuq2l0gXeGRfsanusGIOElzhxZi+pFWSnOI2qMq96
	5zGkXzXlnKl1e1QEoUDbg59SQwmWwlMNHatuN2tBbabA4aEOlfD+JrsrR3Uu8L3SFUy+0wB2Qs1
	KKtu3bIylSHkHR3SYDAk8rJD8uxbK1nRmKSYJYj7ka1YsxFfwa0JMIvsiOzAxBrjEejuyTCXeqe
	HrbQc/XBFSjBS80zEBkn1IiOnZLXA97mc3XrEOGfimP3pK2M/bZXFqGBlLHDxT2NY61RjCf4Bk8
	2perEs/ZW97kh83NGOYDGHxd9PJtf13VX+Qq3L8lLvNQkRvMAiRZqydMBFexuveqeFT4rX9pmBt
	ADt6Xb9bYwNphbmd5kJPFy8i6g8hzaDhVJUQUs6rk6gS1k0E8/qpk92ZthO0xoRFnw==
X-Received: by 2002:a05:620a:4043:b0:93f:31f0:6a7f with SMTP id af79cd13be357-9442172a5c1mr3429218485a.69.1793872331425;
        Thu, 05 Nov 2026 01:52:11 -0800 (PST)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com. [209.85.219.53])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d482e7efsm425575785a.24.2026.11.05.01.52.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:52:11 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91c7a0c1617so23266116d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 01:52:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxDQYLykcV6UtFyjQ4gYdmvGVskdXpq2JxK1ogXbTocmdVGGdqjAEfPfHk94nWf7i1psG2G5LeZuZu1@vger.kernel.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
