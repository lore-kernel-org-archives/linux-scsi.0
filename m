Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794698411;
	b=iMGcN2g8WDtz+HRXTLizkP6B0yfDsRijbAUVl+nCGJaOHckjWoP4S0dB7qLL8btU7YTW
	 fmDftbXSvNs+riTvaPj0q3M4OeVes3BH4u6K3r1ql5rYavAZqVN44SEN0a9V5s508saZ/
	 5P02PyKGtftnX//FefIbMaLQxpkQ/HGHYJueWbj4JnlvRbtaeUByFAZVscxPG6LSwFWwN
	 jZ4hwVlRcpSBgUz+pg3HsWxQAEtLgsVZrZ/EUOmzhk7SPumEBTngYq/anQbPP6Un85KEz
	 VpsdSCa538VYV6/vhOU8sqE+/3ex64HhOAUST03GaJy7OzmjY3kxW6FFmGDoNwsSFxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
	b=vZWNcZoeyrLMDTwcB6ht3uqlpccUZV1RVC3gC7FGsMVNu3d3KKyJwJm/ZotfbTq5eqkO
	 SZ9caclyUVjglKyo4PYDOZFwn9KtP0qM+4NzuvTN+GEOve6ffFpmofXfTAROQmHKeOWxp
	 XQnNr92CUEP0DtNzE7SwEvmX+5rEU404aIANi4AbnQjJxquwgMPN+FZatv/XTSvX1LeEW
	 ABheyF53hiMPqEaGnVaWac45ljKXA5LyQ0KoJ8fyYXWePZmX5M8wieNnSCPUlvfTHwBXg
	 tC7cqpP3ujOR7zeSfROOQfOYJ0IlNJWiLdMQPbspyqNLfJ+S3Ftd47ccjJ/N9ucaNzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ4A5V+6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3822B606A330
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 23:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3822B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ4A5V+6
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so3771026a12.0
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 15:20:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794698409; cv=none;
        d=google.com; s=arc-20260327;
        b=d8adiufA8SEDPP7iQPe7DTLbt5uCaDenDHbkX6We8wwgh0ETiznIZ3XfTJKZWb87eQ
         59vRgewqgdWqo4HbsZ44WvL96hLvPBWw30pAOgrZPAmdp63wycvp5LmE8BZtABBJJDrt
         6TmBallSLpH5Gab+2QeLjV9QS7ob5sxSYImx8pcl1lH2W67OZBqbFs4ahFyEd3K1IV0n
         Z7JDYcJ8FpKdb/qgT6InSnXBFG+WJAtZBxBfs+UfEB5APjDOE4Q4xuHX27hqQ3y2ZVCk
         PYHSEOm68SlXuHUKjm93dmRYTMWrnDhD4U7c7WjpaSZMVKpK5mXwlD9hXdBvxAt+Ox8W
         UDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        fh=YMbUTicjTNunWBNxffTGMUKPEaM/Sb0pMkcdIXHEMAw=;
        b=nfhrIBq6/hKANbFD5EUBNeIKU/HFUPkQBb5YTaCEmYQmmHEogPltpLrSebpE2FdHxN
         3Qz+hUfr+ed6xyVdrfBMCQf4KaxBL3pbFyWICL+6LjDlVISVr+S5W9MGqw8QCurzCRfx
         uXeggGDrWLAHoPD0LK9KIikZkoZmBoAhdBgVU6xUgfUZVyLkE3CERipZHv3WvQ7t1I2n
         yjIPsYCArlUiNO5w4VZ30/pTwdik96TWuucmeQEhojHMQnnU/makPaeQkfty9amDMmcS
         /7GV4fil7yLX0Kf98+YU6Wiq8zOiUu9KRnCdNDBREQmtpqoMVkoE/z5Wje0rU+4uAQI3
         Ipgw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794698409; x=1795303209; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=bZ4A5V+6Vs4HKIPLNbCXlaoHg6GUiZAgPE1CoHup/u8F9XnmCFMSb6naMqQFAl++mw
         +LZR0jt78s/FhrwMU+95xN0Ho10rZ/g9p6M/dfGpr9SfvlaOXM2WfiTCtO0CejnyefhK
         5gg17lDjyCI6S+pTTK/DIWzHtcTY1JHkLI4t/I/Teu6/Lgz9A0oKfkx231Ay53Fdu4Kp
         zCo0ecwmPzO3ZOIddRCFMjOjLH94BU3oXsC8cOhJgJSeLFwZkZlFyxo1cq6JVw7hHb6A
         21NW8PziNlBat7d4DfM9UgO0YIScpglsDnmQoGQNIOQhlOx3hw76q6t8+8jTPfBn24eS
         FVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794698409; x=1795303209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=1ASlvBnEnfhdRlWCG2aBVDWnjKDvu/ojfTzBt9gCAR21iHdEpn+6w4PoNWFADye/+a
         B684a1VqjFIOquJlRYcejCB0k2K5ScGQwTwfjz/TBtEhkHZu/01Xi4XSPb+sKRvSnPdF
         AIWTpo8fCwsViLI4ida1qdwD94THe+yaBq0z9O8n2kv5+3tWHx4ea6My4jsr9El1seZG
         JZtlKfPR5EuFAN7J4ex0FU9idlRzyL1C3CC7cH2sLFssOZNoJL9jQu68nEc4JBgNQYUr
         SdW+oU01XQy3wuOb5wfQlBD7p1A80CDlhkKsM44vU/c4sr/0SHaPnoqV1G1kmG0hxibl
         exiw==
X-Forwarded-Encrypted: i=1; AL+hErG2UOJ/8udsZLXshbiucQxrajjuSU1m4hi4ZiYocHzFLTvSYUamLMXiKsFF+4DUXINeGBlL/M67Ln9E@vger.kernel.org
X-Gm-Message-State: APuU4Z9Kd3hfiSIKSz29MQYsssbqJEYQWjFqp8MowWUF2QOc5vzK7DF5
	RIIWAfL62XKYjay54du2TB1mJZagFSqyLsVwyA8SjvK59lt7TDsKqpUNfIgp51fIeWbOViV6pnn
	22lW6uFEk36avdKZHBCGjSw4rElLS+aU=
X-Gm-Gg: AYBFou15AFZQ6W/G7+KcXExyzHbE0jCZvrFxI2L0aF/rMXVwov0K4W1kFepoEhnH9B4
	51bGCLVMwJXXaQDhQh9KhO/K/z4eSaoNINKn0D2OInvgJUSS6/Me5LfdNINyjQJ6QQAmWV+k6sn
	Oh7ETN4Q+dooQl0ZoCsv6Gddju8xr/GymmV78UY92R+798sGNiIUW06Rgrfu2YHm54o2mCNgKnE
	VIobnDY5YgkEfpdXVgoI3HlVWRuCRLfBLW2D1q1QIsPO8kUIYXIV3Un3OfsEsbeXTBEO/Wluwb1
	mzpbLC6PuM3/px6L3PqYDqXSWZ0Kv7IrJV8l/eDKY1V5RS1qm0eoWrOWRu7LjiSY3A+D8lj9GKv
	vFlL+3XiofFSpxPwjIHBzISzVtBZgTfCdYho0USOLnXDB/MS0tY05hO73MJpnIAIFfuEcUQ==
X-Received: by 2002:a05:6402:e10:b0:6b7:f00e:5e56 with SMTP id
 4fb4d7f45d1cf-6b7f00e5f37mr1542816a12.1.1794698409123; Sat, 14 Nov 2026
 15:20:09 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org> <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
In-Reply-To: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 00:19:57 +0100
X-Gm-Features: AclHuK_YVxhIpv6JLzeNAX5mX5IHGfu05WS6uQ-TCKewxE3JKeci2PyA-UDMCbo
Message-ID: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
To: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2026 at 9:06=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Christian,
>
> Christian Brauner writes:
> >+      /* Look through stacking filesystems at the inode with the data. =
*/
> >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEU=
DO)
> >+              return -EINVAL;
>
> This looks good in general, but what the bots said about O_PATH files
> here is real. With FMODE_PATH this is reached for a file that was never
> opened, so on overlayfs nothing has been through ovl_open() to look up
> the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> itself, and when that fails it hits the WARN(1) at its end and returns
> the overlayfs dentry, so the check passes as well.
>
> Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> it's easy to trigger with that. From a quick test with a metacopy file
> whose redirect into a data-only layer points at nothing, registering an
> O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
>
>      ovl_d_real(/f, 0): real dentry not found
>      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
>      [...]
>       file_check_backing+0x308/0x5e0
>       fuse_backing_new+0x219/0x4a0
>       fuse_backing_open+0xe8/0x390
>       fuse_dev_ioctl+0x53a/0x7d0
>
> and the ioctl still succeeds. A normal open of that file fails with
> ENOENT, so nothing could have used it as a backing file anyway, but with
> panic_on_warn this is now a panic.
>
> Maybe ovl_d_real() should just stop warning when the lookup fails, now
> that it has a caller that isn't trace_uprobe?

Yeh I guess that this needs to be a Fixes for lazy data lookup.

The correct fix would be to teach all the callers to deal with an error.

> The check would still pass
> for an O_PATH file whose lowerdata couldn't be looked up at that point,
> though.

One observation relevant to this patch set is that a datadir layer has no
business being a pseudo fs and that can and should be blocked explicitly
at overlayfs mount time.

The other observation is that fuse_passthrough_open() should probably
check the backing_file that was opened for io in addition to checking
in fuse_backing_open(), which could have different FMODE and specifically
could be FMODE_PATH.

Thanks,
Amir.
