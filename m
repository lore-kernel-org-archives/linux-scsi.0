Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873269;
	b=dL4Kp0E07YZVGJriR9S/V8FSuXK9wZod4dCE0v9qGzrQSdob8tepMmJZXWhR9ZD9T6yc
	 bj2slQIFn4DRSZTqCO/qEQhzKLbgyhu5WPzXO0dXJvgfhXp15EjtcajLEopMK+Pa7fjVa
	 YKxdwlNdySYvrGuZkKmjf23iwLj0GjmrdPR4jbEFTwoYveQM7Nd61DEJlmMED7l35nZb2
	 kPeWLLL/qnh985gDSvj4lDXNHu7iM1nyU00xItQ37PrFXwohntgsr13Hg7AOqnlAka6U0
	 qaglNFa+FBc0TgQ62nv2MrAUQF/92oszAG5KjvCG8q6Mn2b9Zfk57wsL4Bu1e0an6Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873269;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=HRfPjQi/EPajP85bp44Mrjs4W2fVG4O74jaEjdHYdtc=;
	b=EFmHBUqlHlk5OjP3nwW6Bmqs9YkNRhaJFBvU7T0+BkNod/goEyCZKFkGcbImWmRykUsW
	 OAz14r5o9iz/Kz1HtRrpcLydCkk2inSE5Bv6ZP+WOVeW4EJ+42SQs+SGPvwjLB+RXQ4C5
	 tsfvD6EY4UwDaz/siFHHFnfMK8cXsrbT+tehnTze2wt+2kPfhy/n8ZsDM5YAZC53yQl9E
	 h7jodGSs3oa/65mNyyLrUDg8R2+xv/sj+d8cz7ZfNEnmXFUZ0HXom5CojHAmP0vzOjPW+
	 2HLah178tNLYETR+7zAif6XyDUswmXo0JeF+hha04iTSPox3+dMVX2AZzGLXv67VgJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.222.42
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C078606D814
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 10:07:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C078606D814
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-980c4f5c921so528847241.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 02:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793873268; x=1794478068;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HRfPjQi/EPajP85bp44Mrjs4W2fVG4O74jaEjdHYdtc=;
        b=g9muDfvTsy5a0tAC2/dVtVFwQryRMmPYCC2o1sdNEAzckMK0tE5FXuJhdCIZpB3A/x
         lpevDQWkrFQscvM3yMdxRaCWa6q4yP5ZiORt3SZvfdYRVJ7eXk7P36YY15sO+Qqcf7eW
         RdaY0qBuhrx/L2Fp42IWq7H4V9si5f5XTednQ3YkGfUjuaEx4D0JcvRZZgRew6nB2jjC
         u7XR+h9zKkCr1MUo3TaOqkh559o2BkR2ik5Sqb/Cg3rVfBbG1sTcvsJLoRAyQogma9Ih
         kuZcbnZweXlP0u9J1wOBEcPMAm4E2dGTS38sImRn8Ii8ih/qz/cdadpoG2NZWFAcYRuU
         VFTQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRN9iltdAIsTfXMJiHf7GqxG9XLI8tVqsKJgiqOO/pBwdMiDUysvZiY2eRS7v2uoVg0vpqrtxp3m+g@vger.kernel.org
X-Gm-Message-State: APuU4Z9uHs963kFi9oQgMbLTdwtlimyqfP8oApwMZvwbhoSsKZtkgVU8
	+xcvR/KxTXElp+Mwu7TVFFzejV+ibEr6lJzY/gyxOqyVuGdmZH58vqie0PpOKOjW9XM=
X-Gm-Gg: AYBFou2qjjZUVA1orGvndyVfT6d3Crv839fqww5FIdq61SBBzdhtvrrsLJRFV4+uNLl
	z4lvX45MMdDV1/Yt7ODEqmSLTW89gFj2VhKBSswKYSorCwRit4JbTD51yDpXDb/PPrBhp3+z54P
	o/7Un5zBlCFujZnugpvKlVRdMSYYU9BcL1meDnXXeBKdn9/jHZlNxJ/Tc8Y/D19jElcks1sDbh4
	q1bXCF30EcoXiL+bFT3yk1Oz6HND2s84q7+Qvcp2jZr+Q5gVXbskRs6Pvkz1nAp+7gX00d3NQG/
	ESKuxQa+aojUtdHSb66ycLLI5f1M6b+IR6nf1txizHGhJw0P44uURHMayzpVOzZLQi4VcleHfD0
	zTnPVldf6tZLQil6sCjgJkWgu2Y5iRZr0WTFEOekCnFMXOBvB5D1A5Yt4vH+WPLsgIz4N0wRmcu
	oHz9BDtCJEHHdR+LwzjMxYKR9UvZ9iwne/4ERPisO8qCNX8iQyiVZhNvT16xrsCa2UtwZnP9nvA
	kEZ0YsJmuW9qOALajr/VswnmzYsxo5uv60n3XtgzjuvJT6nShqt5vVtreO+dDE8e8zMBMn8FKRS
	J7Hw2O0ohlxs92XBnwxgEVqy/Umif6VSwVLWsiGWzkapiZe2UIEdil91DsMNsokrog==
X-Received: by 2002:a05:6102:1444:10b0:7d2:7dcd:7c99 with SMTP id ada2fe7eead31-7d27dcd9d66mr1864709137.7.1793873268288;
        Thu, 05 Nov 2026 02:07:48 -0800 (PST)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d91d2a3asm4082602241.8.2026.11.05.02.07.43
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:07:45 -0800 (PST)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7cccb2c96d0so515241137.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2026 02:07:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw75RAWoCGDAdT+8Pb32G1g7NBCWt1NyWmoTaYCtRnjIHK4dak02iVpw046qxLGqbicDvNrrX8u+JWj@vger.kernel.org
X-Received: by 2002:a05:6102:374c:b0:7cc:1a41:20e8 with SMTP id
 ada2fe7eead31-7d07227a940mr8060714137.5.1793873263361; Thu, 05 Nov 2026
 02:07:43 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org> <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 11:07:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
X-Gm-Features: AclHuK9naqg5CZQ7lhJVrMhg9TNH44f-SpA5WbUGCGBsAlcoOw2midTd7doJSmk
Message-ID: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
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

Hi Christian,

On Wed, 4 Nov 2026 at 20:32, Christian Brauner <brauner@kernel.org> wrote:
> proc_reg_write() pins the entry and calls ->proc_write() which copies
> from userspace itself. A page fault in that copy can take as long as
> the writer wants, just like the copy to userspace of a read, and
> remove_proc_entry() waits for it.
>
> So do what kernfs does for writes as well. An entry that implements
> ->proc_write_buf() gets a NUL-terminated kernel copy of what was
> written. procfs makes that copy before it pins the entry. The copy is
> capped at ->proc_write_size bytes, or at PAGE_SIZE - 1 like
> proc_simple_write() if the entry doesn't care. Larger writes fail with
> -EINVAL. The proc_ops go away with the entry, so procfs remembers the
> limit in the entry when it is registered, like the size of the seq_file
> state, instead of pinning the entry just to look up a number.
>
> Entries that take binary data in pieces, like the PCI config space,
> ALSA's data entries or a firmware image, can ask for
> PROC_ENTRY_SHORT_WRITES instead. procfs then copies in the first
> ->proc_write_size bytes and the write comes up short.
>
> ->proc_write_buf() gets the position like ->proc_write() so entries
> that write at an offset keep working.
>
> Note that procfs copies in the whole write before the entry looks at any
> of it. So a write that is too large or whose buffer can't be read fails
> before the entry's own checks run, permission checks included, even
> where the entry only ever looked at the first few bytes.
>
> An entry that implements ->proc_write_buf() and still has a
> ->proc_write() fails to register.
>
> No users yet.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks for your patch!

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -67,6 +74,16 @@ struct proc_ops {
>         const struct seq_operations *proc_seq_ops;
>         int     (*proc_show)(struct seq_file *, void *);
>         unsigned int proc_state_size;
> +       /*
> +        * procfs copies what is written into a kernel buffer and calls
> +        * ->proc_write_buf() with it. The buffer is NUL-terminated and holds
> +        * at most ->proc_write_size bytes, PAGE_SIZE - 1 if that's 0. Larger
> +        * writes fail with -EINVAL unless the entry asks for
> +        * PROC_ENTRY_SHORT_WRITES. The position is NULL for a stream, like
> +        * for ->write().
> +        */
> +       ssize_t (*proc_write_buf)(struct file *, char *, size_t, loff_t *);

"const char *"?

Seems like you have to drop several const attributes during the
conversion from "const char __user *buf" to "char *buf".

While at it, I think it would be good to use this conversion as an
opportunity to replace "char *" by "void *", which will probably let
you drop several casts from users.

> +       unsigned int proc_write_size;
>  } __randomize_layout;
>
>  /* definitions for hide_pid field */
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
