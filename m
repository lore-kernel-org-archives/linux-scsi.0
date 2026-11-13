Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565649;
	b=UCwVxl+FNfP6qfUxz478iFpV6XLDZFcwyYUUtkkwF1yMTr1GOV8BrlWdVoLpyq9ZOwmi
	 e6Th8BA8SD8PhyYL7WRXzvO32k9NFZ+ut0DLI3f6r/hqHxASGkAQQwntdT+AWMpBKRi65
	 B4AUNdEQtStuLn5US82tRlD7ZPdzvgX3tvPZKu1PINyA3FhYKuGaWQjLK582lq9fpZSYW
	 GzLjtGhUY+7RXGfYkYtVfaMyiDx2nzHOWmGORvNca4yfW0jrEKzGCPB16BXr5sJLNayXG
	 exPiLLuCOv5sSutl+m2EC5/Sse7HSC4OPiD2Djx6JNVthBicgMpMBqtyIXV1hjplYSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
	b=qLTV1YPrFLTQnM9NpQynY5XmatVLRbiFTigRLkiBS9wou1RYu9JnCzDqrIHHHL695RUP
	 baGLtB4neCyN0B226RNqsPeMBUKXKCOJzZtFu1iDwRJr+8YU+SqpmdfV8jp0tNbZP9mZk
	 RCzgrXgc6mKuri5TOfovemiCoLkjuLOgyeyr3Aj9Ud7V84Uy35UnTImhkZ70yFGqGxaOt
	 14SrpoOpXGq/5GH7+7AEbe7WCYELRDfXSfeW8CQi9xIOLQkIRIV5Y4BMal47caCHq7U4I
	 jjaqKO8Q8uIXp1ryCXY5Y4JF55Mou5GWn2hWxQVCo8E1Iv9yDsazaUjHH1k2t0oG7+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N7Ff61ik;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4FB606A33A
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 10:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F4FB606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=N7Ff61ik
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49465892f7bso822118f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565647; x=1795170447; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=N7Ff61ikIQ27nXVrR+i5fFuiFp+kpNCkSJ8kzzwXsWXF8oHPQYaaEtIn2sVJ/R61Yt
         eN/EgbWtaqyPzsaKr2MVnoSj+msmKBheiZS6yCjGNfIw7Nev7hKixHBvdeyifMwCAuyY
         p4HuC2pLhsdw/6s4IDRTQYVk2XreSuuUeA2/lEtpnIKw65+UPm9cBNCU3JmsoFXsrPGj
         WUoovGImF4s4dFS6xRIsBa0e81egoKAVqgb5m7AbWjvbiu6rsFasaFfPaH+ik5AAKzYn
         61DshIaK40jfv3WiwMjZKKDrEIOQNGX/IDgIqQj4sI1tIu9ZETTA/xF/QESgBcPouNO3
         9yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565647; x=1795170447;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXY31nY7nMCHyiOZTp7Dn0JSWYPda+tFg8CPAdTq7II=;
        b=zpRyEpCiz4NyhePsw7Pq/53B9C9mHeX7nr07eG0ZmKy6LUiJJ5XxpDt1tzB0M1z5DA
         IImNeCySIgko8Ns9jjrq5mQIxjPSJjgasbq+T5h1yBF9IwYYiqrfqDrSWtkZAKWw/1ox
         1omZyqiIw8XfDDbVYcMJFclUUC2mS7clhVo4zuMo9Is4Vo5KqpJH6cR/BAFh40q/TfVV
         2zHpZXuptNBFGj+ZQ/1BBkmMTZMrp+U+QNxxY1HLtWgs8Fo7U2iQdLFHmcJ6ArG2tg8X
         5NKWW4bw/9d6EA9AKLMMD3oQGlZ4Cvx1SHrSzEauLT5BPDY9/fD9vmtnFAgQhtgWBzIt
         aY4A==
X-Forwarded-Encrypted: i=1; AL+hErEpjirjn4Knt0jdnLA02vloT8l2mE2FE+z62GdMlWcsWTYu5/pjAHUmYJxT0cXvPOKEVMByeC4G0slQ@vger.kernel.org
X-Gm-Message-State: APuU4Z9GaCAN7+x+piYGs4hObkFpnV8xS0jLGG2y2s6A/zJs/YUOLsCP
	L/1RMnJppH+aQReNi6sC23BmIghRV3K4CU0Wehnje7rqJ1IM3/InKb3FwCDAtJDH5fnx
X-Gm-Gg: AYBFou3L/0t0rtJGvSn5g0NTAMHrzMdOr2PRx5wvPTzZPEzcHzJVGtU/1jqGCAm/Ze4
	5PYOjfeA+kULyVRhU6+6Is8tlE0A73u4T6RSwm0TG7exVrvlAoVSmtW4Km3ODrnK6y5TAxqeVyc
	uXBNUESTZI0Bu/+j/NLSrpXw4bBEi7jkThs3T9UdZYK9e95o7wpLaReqQ2XFDDSIaS2U00pBnig
	ttR/+WqzoMfpAJ9EHxfnPIfAQrwkTl3QNMZu0lFtZujAckw20MVuyjPaIu13yN7Jng5tPRg4y5H
	6QhmzM3skLSDF29zgWn0V8+LwSpt2IIBa3UYp8UaX22rn1LfVQZRVEKEyiXQwBZesQwT96q+mEj
	Cn1d9b7q5taZar5xHbwTZN4VnykE3/8nzWqB19MZrh7rNVL339oGwQofEpHuY7YGJ/anvFOVst7
	R+HiH2gLRpfI1TSkVeTTxwuQB/cQF4PNWcDfR/Rs7Xvd0fl6kNxFfFCYrvCa6o/un1f5TLUlFke
	whGCs5lpBPRVJYSlFmsRw0CgF7mYfsWslRoKerLVEzi1tXyArlCmFNacPy/Ul3XWaA9S/YzWuvY
	MPhTnd5dSnfhbERspSDWDLPit9EDdcSGYowlMYO7MpRDp42aVkOxGwgXNcSgtqg=
X-Received: by 2002:a05:6000:4707:b0:498:c419:3728 with SMTP id ffacd0b85a97d-49c713ae367mr4463557f8f.22.1794565646661;
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm5077482f8f.0.2026.11.13.02.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:27:26 -0800 (PST)
Message-ID: <0c109a58804a2d782e549af6ad13e89532d9f9d2.camel@amutable.com>
Subject: Re: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
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
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:27:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> File-backed mounts take any regular file as the image and the same
> goes
> for the extra devices of such a mount. erofs reads them with the
> credentials of the mounter so this doesn't hand out anything the
> mounter
> couldn't read anyway. But files on pseudo filesystems aren't images.
> Refuse them just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/erofs/super.c | 6 +++++-
> =C2=A01 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/erofs/super.c b/fs/erofs/super.c
> index ce05557bd998..980d5fc2b576 100644
> --- a/fs/erofs/super.c
> +++ b/fs/erofs/super.c
> @@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf
> *buf, struct super_block *sb,
> =C2=A0		if (!erofs_is_fileio_mode(sbi)) {
> =C2=A0			dif->dax_dev =3D
> fs_dax_get_by_bdev(file_bdev(file),
> =C2=A0					&dif->dax_part_off, NULL,
> NULL);
> -		} else if (!S_ISREG(file_inode(file)->i_mode)) {
> +		} else if (!S_ISREG(file_inode(file)->i_mode) ||
> +			=C2=A0=C2=A0 file_is_pseudo(file)) {
> =C2=A0			fput(file);
> =C2=A0			return -EINVAL;
> =C2=A0		}
> @@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context
> *fc)
> =C2=A0{
> =C2=A0	struct erofs_sb_info *sbi =3D fc->s_fs_info;
> =C2=A0
> +	if (file_is_pseudo(sbi->dif0.file))
> +		return invalfc(fc, "source is on a pseudo
> filesystem");
> +
> =C2=A0	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
> =C2=A0		return get_tree_nodev(fc, erofs_fc_fill_super);
> =C2=A0
