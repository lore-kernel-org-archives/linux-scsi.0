Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794850651;
	b=YgCGqz4XYRMstvCLUIY1PoNLslPPHv4Io7dNey9pbNM0UPIjgJXHDiqqQbGxKOM4gZyC
	 13iIlyNJNXtE+/lFSqmQwIcz0nbW+nMiJS1A2noI8DO/JxnMr4zrxxWetY7T9MYI6X1zC
	 kUGPZLnM3lQGXv2Jdv3XctpNKfqnLoyfdKvfWrjR8jxMi5og0/dEvbt7kQbVy7Z2sRIzK
	 0vlzmQwpD/zU0PkZj0f/n13HRwE88mFcCIR6qigjuCXaNQefJVM8fDa08vnXhzzQvN1Sq
	 pfLib3+iDwyOV1qOylJH1/dJZ8OR2lvjdy+uFGfDHqUwFo0G5D9ursdRNOMrFTrrFUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850651;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
	b=Ou9kMwN/Hln/51amgKpfCOtVqW3VV86RyPFIgcJel67oFwdk1O1Q5rQFrGGwgqlccXRn
	 5BXjqHE5SVm8/0ZmEZosbSPelPx6vSdkEVjuNBcJerXQlU27vTXrSqjRlWZxSj34nfubp
	 82j0OY869FSTmOnnjbsA09IDXBxpSYYioMPCW/RyRmVjOLWv0eZyIKy3Zgd+NQRTE0YCX
	 y1EAQvN3k58nvOqTZTz127K5O8Om40dggjpMtdZR98pbxHiI7q5fbpr2ksPfuZnwC6Eir
	 wyFLLGo4ylVuPYADBRnbrZWA4qkIO9MioBqwSj5x4QgtIYMs9cVPEwf/VoZIRimHo0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wda5m4T+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BF606A889
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 17:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 473BF606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wda5m4T+
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so105385a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 09:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850648; cv=none;
        d=google.com; s=arc-20260327;
        b=oGNqCJn0X3oNLick3sU94vZ2F0hPaB9twF1C+WIO+OciKRwSCOZUL2l4l3Gf7nX7qt
         yEYYNiB5ZJYPAkEvEFhIXDX2NvdoLcevlfzq+x7mEBSX+ERf25SpWYBh+8f93pmEortg
         Xu8FW1AYN4SMOlml0S04oiJ4vHaEbw2KGmny2Ifsi77aM9F57meoNPkfIDHyY9HVGRb9
         Z6+mxM6nGJMc00hfDP8AjTHwEDp7HVKXP5eh54Jt5G5knhNFGtCUttiny+2HWpteeE4+
         mVed7XS+V66NlETQIU5MBb5KlffTSVpWjrA174KSNCrE9I3zp50FgBhrQXRU9ejPeaSp
         HzMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        fh=DyGOOyqKWp0+d21uDSJrTV3FfSE4L3F7K9vrm6OjKUc=;
        b=LMVKOXfRPuooL6ag5h3Dn3Tz4BpEDP+p7LyD4Pl7/U/99Dc1RTA23cg5J97Jy7M7Z8
         LaX2TmHS4NraJ3z2Rj6XDpKI1GTtE2K7do/MEzXRtVMjh23wxVG/O34mnlbl3Cr8B7i/
         4MHvJpxRYfxJDZQCHidx5f10BisrymQYsK16GZ++BuvkeY3nm5MZ/8Pa7OrklZc6rZ8w
         ArsOINUL9zRs0ZZkoQBAkwchhFRbOj46QGsvY0bpq3UvTV8HaYm04YsL+BQCwOkXA5Jl
         2GAi4ZYby+OgiMxOKApoW/XCB8wyC/8KOb51lqu/kt5aLmWc8Y/7+Gb3wDi5RJFsavYd
         /UKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794850648; x=1795455448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=Wda5m4T+Og74YNLartpajMnAcctT7hnb5haqi9hjLlBRa67TYcEPjf80gw45qsgIx7
         FMobW/aC2ZXQsUmoaLilVLeaESS9ODytholTX6ZkGdI39Z50BqAMQuVm0upEGdU/eTIl
         KzXBiwaEJY7eqa6p49n+ZePGE0YUDeVtz78JPQJb7w7ae3zRsyAfYOAEtJq8eS6befDe
         ANfoXo4rOnrr9cTK5CEQbvEa19yD1CMimOfBL7pxwr0U+pGpN6RB970vgsC2xV+kB6BG
         DqloDFELm5xz1LM2zdKvbUwHIwogDmvmrNVDo81Was00uh+K9TR8cjrFQWZvFUjBWrt9
         3Csg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850648; x=1795455448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=Cta5EXyg25PLNBqtZl5VStTN7I+0UUiURN8ahBkptRePgErdFdJ7ECfigzuJxg8uTj
         Tt6zz/HEYLigdnMRD+A9+DouyG9f2bgg0BNZjieyOwv5rXMqHlbc0w7p6grzMNvKvTRk
         ugDhDVEgGA+QfozBYh32VUxQHJJGqXNFZ/NE60DwpceY0h2lQbXadgigiXr6sE9hChs9
         /7g7MQy9i+j3G8cuYsS/UwrMe/YDVVgQIyJQdhxH0sFEzt8w7L8GkSYtZVjQJjwX1Bgp
         nf/yfxhxG5eMfzhtfnfOSk3Dg/pjbrTH9eW19ZUGyQL3Mlwg3R616uPbQ5WUQTjHKUA/
         aWBg==
X-Forwarded-Encrypted: i=1; AL+hErGsAP1Fltbiy2aJ8zrMHgz/l02bTLXKzNNEn9/5gEQM/vVWivyX42728PdaH3dG4NjnDQ4klHh/f+71@vger.kernel.org
X-Gm-Message-State: APuU4Z8qo6J0AIYHHNvzKnnRMFoRksnfzty7hLkkZCqs27AXiy4cfwdG
	Cm7zJ84R1tWdPsZQ4ysZdjaiJuH1T9iS5IfF1mbIsNDbeR9xaRdHuEFHYqJBkgZg/Qr+JIJzWMO
	CjRSi2/jOMUIkH/ZUZQ3rrYom/W5JvEs=
X-Gm-Gg: AYBFou2B0YQQA8ZKqlYn5h8wzochWdMeWRS09pNRImKIwHVeYBqEEoS3aneYNKapHjD
	bkl0uO4bKaYFZU3s9/55FueHWAeGDyFNSNaaQHSPYiEMUdVVAr0stn9VoHE3txACjuB8Grc4xhN
	9aKGVUqNz4aqPkpqTKVs0qK9daXAEt/1JKOS0wLXp41Y+j/05ZyBrQA185PDtNWu78d6oix1/Po
	EvBCYPfOY4QDrqL98RIJj4bvVsV7lKL+UUe9URd3556Hp8NaqMaNZb1+DocmAlmjQKOAd36tN9d
	+Y+Q/oKJpWaQ2B+kturk+djHQcERqofWV3VOgDaP3FRN6rHY8eO6E7Dx7ZOs3oPC3POyk2EsR7h
	FRzQSmdodsVkAu3C+52jqNxZNnKl96d8ZwBpGs+D87NSf6jM+6YVodYwlgW5QS93cT1gWIg==
X-Received: by 2002:a05:6402:1598:b0:6b5:7250:d621 with SMTP id
 4fb4d7f45d1cf-6b859ae1a00mr134291a12.15.1794850647426; Mon, 16 Nov 2026
 09:37:27 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:37:16 +0100
X-Gm-Features: AclHuK_sKnxFPAK3k65pZhjyZC94SJD4eZ9z2j_P12s3kyb9TMw6hurQcjyq55Q
Message-ID: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
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

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> The data of a metacopy file can live in a data-only layer. overlayfs
> doesn't look that data up when it looks up the file. It only remembers
> the absolute redirect and looks up the data lazily the first time
> someone needs it. So until then nothing can tell which filesystem holds
> the data of such a file.
>
> But a data-only layer has no business being a pseudo filesystem in the
> first place. All it does is hold the data of metacopy files and the
> regular files of a pseudo filesystem are kernel interfaces, not storage.
> So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> mount time.
>
> Data-only layers can be added via the "::" separator in "lowerdir=3D" and
> via "datadir+" by path or by file descriptor. All of them end up at the
> end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> of them.
>
> Note that regular lower layers on pseudo filesystems are left alone.
> Stacking overlayfs on top of sysfs keeps working.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 39d4d57dec230..719c2569dfeaf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct=
 super_block *sb,
>         for (i =3D 0; i < ctx->nr; i++) {
>                 l =3D &ctx->lower[i];
>
> +               /* Pseudo filesystems don't hold data for metacopy files.=
 */
> +               if (i >=3D ctx->nr - ctx->nr_data &&
> +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> +                       pr_err("filesystem on %s not supported as data-on=
ly layer\n",
> +                              l->name);
> +                       return ERR_PTR(-EINVAL);
> +               }
> +

How about we make this just a tad more restrictive:

                /* Pseudo filesystems don't belong in composefs setup */
                if (ctx->nr_data &&
                    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
                        pr_err("filesystem on %s not supported along
with data-only layers\n",
                               l->name);
                        return ERR_PTR(-EINVAL);
                }

I could send this as followup patch, but since this version is simpler
there is no real reason to have the intermediate "only ban datadir" step.

Only the commit message needs a little more flexing to justify this.

Thanks,
Amir.
