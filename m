Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872940;
	b=rrJGGpHUdF5pPcTmou2z79iyMT6zBO/pjKeR4CYkj+ASVWWBWpCEIVxn99uPFKZVH4fO
	 iW6Xtq2xPfGZ71G6f2L9y1rtB5qQBERR1Ch3QECCNeF14NhYiUvD6FfciBYloCTsSnlDJ
	 PHxbwOF7W4+J/LyURtp1Nu4ec2+2GB+sulKaOtdnBY4pVfosoypYbTjFz/seaZalqZdMs
	 7Q4MGSp09nvS2xMF7ER8kKNri5DaxDK61eKydvKcJiYha6UVOnFkBlzE12zviL1ix7JxK
	 df8Y8QIwYOFoQXrfpxlwSg8Hfa0aKHkeKwXW7D7vHuHxdaZelkpcaSbOhcIrpAsejWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872940;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=xOspCUH407ncdz4MRoQITc/z0dHjOC2b1KQHKczX6adSHiUxl0sNbRdPvAU+fnYMkHhm
	 cnM/GuJZyxVMIOdE61dJmvpS9HU60/cn7x4Fb9YekfqjoL1MIhJFQMPr/oZWUdk+jitFI
	 rW33ons7OSME/dS+F7c5y0w+BLQU9FlQZYnWJG+TSucKsirTBZjsQ3EvwYUQRXApZww6R
	 X/Vl5rQmLt5cUA4/qjRaKuyp9WiCeJpEeDTQOqpdV7Svj60UoCFEYLyK4EzsNCd37qVSp
	 uBHYV0RUROC4Q12HD6RwgeaODRO+JEcyeamUP0r2VkZtQHxgIaF7As6wJzBriHlSEaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.219.45
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADCD606A32F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 10:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ADCD606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91c6ce60697so22225696d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 02:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872939; x=1794477739;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=CsbphymrfwYK/h1DmYKKFqr9YTh4y4kZ+jConSykKXI3eCewrgazuoZPpu+Lt3zZnh
         +XnMVyJLrFO1QTx3iuEpHAwuwysk1UdkdSIfF/sHEWYE25F7/gEAkQHznN4chCjD3Lty
         mytCMLqGG6ZlZ/udiScP0o5Oy0nhCLU8vaXiIEnHhCUQQjZw9iJcGB6vSShJUjVR9mPp
         3Q/DPM5FxnSW15yYuyT+Mx3nbntD6x62fng+yZnuDOlNyTh5JR40983AI/3HdtsV8jyW
         x5MICeG7npi5oYcoTlUaIEzNZk3FQC5oSDMfdSpS+GNKz0tlyZ+BFTpeIzfmNc/USLBs
         LFjA==
X-Forwarded-Encrypted: i=1; AKwUvBze+j3u1kGkn4xXoJy4l36aSpVMtjs88o6vk+fzOntG/nFXKc2bc2aH69bPBcbCQ6J140ax5lGqMnCf@vger.kernel.org
X-Gm-Message-State: APuU4Z/98cOvqEU39FwXjXGzWjMA2Hv5/P5OJ1Quq0Q8Say6g7/zXnNR
	pIphSlA7JOnP2dD3JrZUIcmJAtxOnFTEd8lkYOXvPf/2vphZI1D5dyVncgrmr/1QvC4=
X-Gm-Gg: AYBFou2LvWZPtj844JhLSyHtu2MlSkUvGsk770kEXrnyhXrX3mmRMgCQuwq1LdKv8kM
	07WiZgpDbILRAVI4Qqt/c+GnV5aRe44Dr49W1zL9va2awkXwS92Nb/bcTw9wg6iDBXJkb3Z13jk
	XopcrUcxPWI97t5pNFKcRFuoR7bDDApUQEjHKOvHsFqGvzC+MwTODbfByIaAwY8qyFpsAoeY++g
	Y5ixg7ns1vQWTHFCoogvORni2uGkZIFxQ09hBdahxTkB4t/t+CtkzAIZkBdk0Xwv+sD3WuYbnwi
	9IaMoUf2GrtI51q7yxTtv6V9bnq4L3R27S36SNbel1OnaAs7ols8v7uiVU62OKw3CQrU9FpXlfl
	MJ4WAWIg3VrEa2N+DlYJJGtW9w2BkGgt0jb0npXmBTtGWqW+E/f40zXo3VFMs8eJFcdiBa53Zi+
	pm1zdR2SR3w4dETObMeTz7Gv1DvKLTceXNFsuTPAAMfviHoH1DzHPjnKrhEvPMJAyf5d06zJKJH
	Lfx32BB6Xj1UqrFYPQjmUGbc8A1AIOjsWHholyNWp6/He9yBgtwfgkefMJ3uw1VrBdvltvI7TwL
	U7o5s3C5CHWsqsdMSN3/vIRDmIUvqr+JgcM4FTn77A5hMS27rJDnOdJM7NW27Rps7A==
X-Received: by 2002:ad4:5cc8:0:b0:91e:7ede:63fc with SMTP id 6a1803df08f44-91e7ede7474mr87322706d6.51.1793872939376;
        Thu, 05 Nov 2026 02:02:19 -0800 (PST)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com. [209.85.219.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e013a5dsm44039616d6.27.2026.11.05.02.02.18
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:02:19 -0800 (PST)
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91c1f548f87so26542236d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 02:02:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByyZlvCaqRjKyK4c2BnqxEk/0w5r6vvsNi4Coo/Nc5xngL5aCQeY/huoE7UyzJo50IVvgVX84yHWe/o@vger.kernel.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
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

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
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
