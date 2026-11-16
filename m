Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859647;
	b=T5qNjGhOfl4MlSUZmAbStDCiw+a/CAsV3rMmNufVHAflEUQcsK5XywzQx20rGxAUbBMt
	 wB0Ukvj2DMw94tLB9KY1vSFlTHNWO60fSXbt+tkJ0U5Q0hMd2Z2Z8T9l1+kD8zW6flXwd
	 xJLNyHO8JIZKS370gkegGnCC3A6rvxhd16L6bWzfv+FhmB/BE8VHcMQ8ODo3zyUAOAlol
	 TshHWEz7OB+qGGU5KalR9NVFLWxnQ0jrqlCo2RcZrODLTbTLguVERfoAEGFFJGoh/tSLd
	 qe+ZgSB/98kTBuyO/CEKWQXUz9w4APC6+tU+8/l+YvxOcPsA/SEwpF0mhbPP21XDo9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859647;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
	b=0urxk9gF0GSEICe6TkEwplDNP8FNe7crL8Hzj7/dS8zMt73MXFF/Z0wlwk37wK7gR/gq
	 MHMq420NXj14Ywp83uktRLh03lj4kfErtk+LXsIPXMeA7QAeCQ1+PapEgg9PCq16i9kIt
	 xZWfNqnj+qGS0Juo/JMHIp7LEufhrBpA4Zy/ssTvBmgWqlHaik9ewHr7UKCKxlfEN0PjB
	 Uok7/uBzLdAQWBqo5x2nMjFNCJw94Rik1W0fvFHlwCoLN0Xs3CNsFABQLIa5ZcAv/fDjn
	 ruwNfs/pM+TOwBhBkY30U0TLuxydjJWO/t4oU/NIpjca1MjKGsaJ/htmwMHl4TAJ8CQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XFDBy0c2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22087606A882
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 20:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22087606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XFDBy0c2
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so24340845e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 12:07:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859644; cv=none;
        d=google.com; s=arc-20260327;
        b=klA7NCTjIV/Rq/r6gTuQ2dUQ8u89sOEly9MGC3Fxe2jjm4ORvneSjRjMf/uymKnD/r
         kDK6OkIZPkqF4MaK2aV9ZQ8JxPpWNHh5turCKYURPToDduO3ntH7zbWyXh31ZM6ooyqL
         d6E4xP1x/Duqh5HqbLPfB1Cf1vTR/3HeqZq7YIz8uMag8IEODn+pWuGZet5mz66AjT67
         D6Z+KV+x/VukrIzOS0C6cyACvzcvy9g8EsFb5owupu7C+ELXUT9QnvUG1mN4FLO4QYkR
         x92JJuBRWfaSTNlGF7qy9yy6rLkUH6KSc6hihxtMt7bXoASDyyiG+QZ6dpjb4MjCRP4a
         akyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        fh=4UPcRv1tG4McAimO+15RAUXoUbJvC6aHf336TyiUZiQ=;
        b=kAlwUtknu2TKv6LIZiC89fZN3DyLBoYA7Rh+Mw0MSIeVMidzraaWz/58+85YI4FQJW
         fJlODmRSw9DtUIT8Bii3mgt5lI5MgaxVlSPlEVo+qvLj1cYGAEs66uQMwaSer9Hdvnaw
         XmqvAMUM8Zz6901iX0V/7jfOzWiMBuIrnFNg4DVLUJVuHAq9Gf1t1YVu/vpi2KJwQSSs
         du7g6t91KUBdCCT7CO/wo1t31rfO8SqOHOOhVkGkW2gd38fnJKg4jSsXPTLYGb7r2Qnw
         pxfkb+m7DCx/6vRl1/RqAUwNgZiw956aWgzK/lURshcKQJAm7rOU8ed4BR15hGHqyS0C
         mEpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859644; x=1795464444; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        b=XFDBy0c2q6nTYiJ4dwLENH1mguXX/IcFF58gOeYQArjps79P1XpkrhGZpUclTyZwpS
         r/ZYwRoOG8WhRg+8JvLZN08T5FQLHs7jA/CzeQCQsJeulI93s02F+iYtli/pBjYHG+CR
         W2MoU0n/+grSPpLZW83MAsn9WQiLh5CCwtBf/0GxLqRHC416IFZ4i13TeIFhLxmbz0il
         NPxDzLDOL7N17VVYsTOL0jDLDvB5woBcjlvcU+oGB0Wrnz6q9rCc3VHuwmdjl71ac6+n
         fuvYHmykPJU4vuSvTSKMetyKY9BqLddb2of0qXOJ87q21uNxSrudqkhk+T/+cyqihyd7
         2YNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859644; x=1795464444;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        b=Tm/n62E46Q9b2XdBsQtQmCs+ziC944CrQ5EHrltIQFNizyDHJQMb/pl6zSXTnUO0sy
         DxfTexs+UElqMMDa5Tg1owKyHB9MRyrpyeKfWz+wRfczaHZcE4gWG/cKDJruLpOz4Mjd
         2IyTIxcQ71wrnDT5Su2RGBOe0K8zbBzusNYfCPkkKrRp4xxh5m1vCvIIlLGbcUnvAeVj
         PHiDFOaSqLN5moRICVw5PO6uVj51dcA6Rn78xe+NqTAqDwsCBaPqnWPWYiEDrgUni6qw
         TGFt2Ubou6YCsx14OPZvPyzRu30DswTkH29+uEes4ILofJcnCq/HksJAllbMPcM9vZaG
         xPLw==
X-Forwarded-Encrypted: i=1; AL+hErGDKy4KM7WeCnZxapNJAlhdWM9dQ6dy2vYfBRQmTjsSn4l/cfLpcEibpe64NQ9n9b/TwUuTRpnPMsG6@vger.kernel.org
X-Gm-Message-State: APuU4Z8zwl2dWP2RxrnzJwcwpadmvwBH/niRKSsVYPgeu08brTDe7cvk
	rttMpumk9+HrJQG2pXolhJDvzbr6EZluPeQhatvNQXlUMjlsJ9CdN+jcVEf+iPIfVZ1Hadw3qR6
	3JHdlVU0yg0WZEMD/7mXioBDJ2rsZh7Q=
X-Gm-Gg: AYBFou1KlJ2jlSk/NTbcXo+71IDlVZPI5AxHppPbSUSaVVoJQ3qxabF27GWgE/75B2u
	Dq2QOm5O8+mbRgnGteKWJowx2MGu5f7MJOm3DUZhKbC8EAiqflHip0510O7T7u6QaBjGaV8L30W
	+kKeGzBTasK2fQLQHV2f3QaOijP2HoO/v/HaJ0eNTlBX02pVW7Me4pT2ElH01aQOR7U4RUtYRRY
	LUbsmh2B1Aa5CwJmrkXOdh34UPZLFc1thfeIlmY5g5GTayzNcqJmc9xO5shgs5DTW/0vI7VwgB/
	JD7jOAh5ljt1FeR2WnrJ/cjCJrNLCJT/GY9AmoxEVzDCQqcu52W/xuUjX1PlbSGswFzH2Dy2ae3
	QEmVmyjjIlnk0qLPMdvug/3BOimR5V7jKYyNsfKBEBSn/z2WYhWDeYUmpLcvrCyMU4rTRIZhWI5
	snLSqRiW6LMRnE6ToaHw==
X-Received: by 2002:a05:600c:506:b0:4a1:f377:5c6c with SMTP id
 5b1f17b1804b1-4bb55a5d6bbmr165067875e9.10.1794859644313; Mon, 16 Nov 2026
 12:07:24 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-fs-frozen_writes-v2-0-ecc4a2aac40e@kernel.org> <20261116-work-fs-frozen_writes-v2-13-ecc4a2aac40e@kernel.org>
In-Reply-To: <20261116-work-fs-frozen_writes-v2-13-ecc4a2aac40e@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:07:13 -0800
X-Gm-Features: Aa3M54rpWiCplKeR8o5TX-NbYGDID_36BWk-3VAyUzdEoXSYZ7J-t8pfWvm9Fcc
Message-ID: <CAEf4BzYANM9vtQ8L9-rJPQC-tTcw3YUGsw=qnCaoym3+EU=DBg@mail.gmail.com>
Subject: Re: [PATCH v2 13/17] bpf: fs/xattr: take freeze protection in the
 xattr kfuncs
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, linux-nfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:13=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> bpf_set_dentry_xattr() and bpf_remove_dentry_xattr() go through
> __vfs_setxattr() and __vfs_removexattr() which leave freeze protection
> to the caller. BPF LSM programs call them from sleepable hooks such as
> file_open where nobody holds it. So a program can modify a frozen
> filesystem.
>
> The hook may already hold freeze protection or locks a frozen
> filesystem would make us wait under. So don't wait for a thaw. Fail
> with -EBUSY if the filesystem is frozen.
>
> The _locked variants are only used from hooks that run inside setattr,
> setxattr, removexattr, unlink and rmdir. Their callers hold freeze
> protection already.
>
> Fixes: 56467292794b ("bpf: fs/xattr: Add BPF kfuncs to set and remove xat=
trs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/bpf_fs_kfuncs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>

LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> index 35ccd98a4de64..7f61e2efa08ba 100644
> --- a/fs/bpf_fs_kfuncs.c
> +++ b/fs/bpf_fs_kfuncs.c
> @@ -295,9 +295,13 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *=
dentry, const char *name__st
>         if (!inode)
>                 return -EINVAL;
>
> +       /* The hook may hold locks or freeze protection already. */
> +       if (!sb_start_write_trylock(inode->i_sb))
> +               return -EBUSY;
>         inode_lock(inode);
>         ret =3D bpf_set_dentry_xattr_locked(dentry, name__str, value_p, f=
lags);
>         inode_unlock(inode);
> +       sb_end_write(inode->i_sb);
>         return ret;
>  }
>
> @@ -323,9 +327,13 @@ __bpf_kfunc int bpf_remove_dentry_xattr(struct dentr=
y *dentry, const char *name_
>         if (!inode)
>                 return -EINVAL;
>
> +       /* The hook may hold locks or freeze protection already. */
> +       if (!sb_start_write_trylock(inode->i_sb))
> +               return -EBUSY;
>         inode_lock(inode);
>         ret =3D bpf_remove_dentry_xattr_locked(dentry, name__str);
>         inode_unlock(inode);
> +       sb_end_write(inode->i_sb);
>         return ret;
>  }
>
>
> --
> 2.53.0
>
>
