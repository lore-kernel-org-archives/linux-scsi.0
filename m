Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058908;
	b=YufLymbnBmYFpneX2XQnBNre000Ms11Sa87dIaMJXUrJPnNjlVUCEwpZFvVyMU/nM4qg
	 WIbpbAg3V1kC0mWrKxLjMaDVm+1HBY1KScq4NXh/GRYsc724uZvfKGhRqn2U5dKVHdBq7
	 SQ4oqTYrzxz3fnqhbguJNosc02CsHcLeWPmfciHlTb+ia7teAf8R78E2sNkh7QEhWoPL0
	 bz9yo9jSxuT3qqIs4fVIssI9xS8WEQymgrCefQiNviNdpGEsxxs5ESIdbYwKeCDulV1uG
	 Q6wo5R7T2eO9mSLGSO0Y7ZQh9G04ew1ycTz6XezM/1B1lHHm8YLBF8yunoj+zkEGRXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058908;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YQzTAqF3MzHiLL8+x+WU7ZkzkvlgmGk4aWqjHy0yhtA=;
	b=g3B4GFvqoXNLPQMjrm7wSrfx6KqoBHTDzYq8VxzrMBr5Wr7xPya++hd99AhBr6ASr57N
	 Nq7oy9vke9LcjkCAAVIz/EhEJRJvkad3Ck6LUPIvgsrAkvkW2ykNqAoKIrZxS+McLoms6
	 VcrvApHRGqgjZl5q2BlyAm5MPihCmgM5qvH8u1r7kuGpMNYsiIXgnX7BKm/6dZvWiDHoz
	 KLbzSfaoUGE8sXWebmo0lCfwNqAGlGof7oGSuTyigXsaEWsBy2apOAsIhaI/vweps+0MJ
	 53aYGFqsC0Cv020WZL/mnyB4Zi3u6VBiFmaEgVBwju1uv+fjNE42BA8vNLn/K25kmmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e879EOiT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEEE606A326
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 03:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e879EOiT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653B51F000C4;
	Thu, 19 Nov 2026 03:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795058908;
	bh=YQzTAqF3MzHiLL8+x+WU7ZkzkvlgmGk4aWqjHy0yhtA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e879EOiTB+hv/jZuTGBuNT8+3PFvfs5jHp9B5+9JAZoxptOM3Wgb5adWRRTyN3VUP
	 XZdgNpdkXz8gLXbz4YfrsmLmNqIqfTyGH/DYtKt9XtJhvA+0q8SW3n7vA6UgWt/MZ6
	 LJc4vRVzhhI/fxb2xDwatYE9lTO4T3nhmNgK7XZrUctqXMl2NdEgj+y0gbvy6Jdhbo
	 ovr3XBUhsJTzTRKP59Y49SWIMvEPiybNyGttlLWA5jDmWC2R4BXz0zolHmGuEniZTC
	 fnTqSWsNtqwKUyDP4bqWX3LTobzrm03MbFwqYRajiV3oVAh3+VvrUKFn5Q1Va17pQn
	 ocHvwtKzK3p+g==
Message-ID: <sashiko-outbox-222393@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] block: bsg: add a per-device pool of uring_cmd
 completion buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261119031751.3471968-2-yangxiuwei@kylinos.cn>
References: <cover.1795016239.git.x-professor@outlook.com>
 <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
 <20261119031751.3471968-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 03:28:27 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] block: bsg: IRQ-unsafe pool->lock acquisition in completion
  buffer helpers
--

commit 581e3d94856bdf0c9a6edc480ced1d507eb97743
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

block: bsg: add a per-device pool of uring_cmd completion buffers

This commit adds a per-device pool of fixed-size completion buffers for
bsg devices registered with an io_uring command handler, along with
helpers to check out and return buffers.

> diff --git a/block/bsg.c b/block/bsg.c
> index b296fa3732924..96f46715ade9f 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
[ ... ]
> @@ -40,6 +43,116 @@ static inline struct bsg_device *to_bsg_device(struct=
 inode *inode)
>  #define BSG_DEFAULT_CMDS	64
>  #define BSG_MAX_DEVS		(1 << MINORBITS)
> =20
> +/*
> + * Per-device pool of fixed-size completion buffers for uring_cmd driver=
s that
> + * need data to outlive the block request until task work.  Allocated wh=
en the
> + * queue is registered with a uring_cmd handler; freed when the bsg devi=
ce is
> + * released.  Callers check a buffer out at issue time and return it fro=
m task
> + * work.  When the pool is exhausted the caller can reject the command w=
ith
> + * -EAGAIN instead of allocating or sleeping in the I/O path.
[ ... ]
> +void *bsg_uring_cmd_get_completion_buf(struct io_uring_cmd *ioucmd, size=
_t len)
> +{
> +	struct bsg_device *bd =3D to_bsg_device(file_inode(ioucmd->file));
> +	struct bsg_completion_pool *pool =3D bd->completion_pool;
> +	unsigned int index;
> +	void *buf;
> +
> +	if (!pool || WARN_ON_ONCE(len > pool->buf_size))
> +		return NULL;
> +
> +	spin_lock(&pool->lock);
> +	index =3D find_first_zero_bit(pool->checked_out, BSG_DEFAULT_CMDS);
> +	if (index >=3D BSG_DEFAULT_CMDS) {
> +		spin_unlock(&pool->lock);
> +		return NULL;
> +	}
> +	__set_bit(index, pool->checked_out);
> +	buf =3D pool->bufs + (size_t)index * pool->buf_size;
> +	spin_unlock(&pool->lock);
> +	return buf;
> +}
> +EXPORT_SYMBOL_GPL(bsg_uring_cmd_get_completion_buf);
> +
> +/**
> + * bsg_uring_cmd_put_completion_buf - return a per-device completion buf=
fer
> + * @ioucmd: the uring command being completed
> + * @buf: buffer previously returned by bsg_uring_cmd_get_completion_buf()
> + *
> + * Return the buffer to the pool of the bsg device.  Each buffer must be
> + * returned exactly once.  The pool warns if a buffer is returned while =
it
> + * is already free.
> + */
> +void bsg_uring_cmd_put_completion_buf(struct io_uring_cmd *ioucmd, void =
*buf)
> +{
> +	struct bsg_device *bd =3D to_bsg_device(file_inode(ioucmd->file));
> +	struct bsg_completion_pool *pool =3D bd->completion_pool;
> +	unsigned int index;
> +
> +	if (WARN_ON_ONCE(!buf))
> +		return;
> +	index =3D ((u8 *)buf - pool->bufs) / pool->buf_size;
> +	if (WARN_ON_ONCE(index >=3D BSG_DEFAULT_CMDS))
> +		return;
> +	spin_lock(&pool->lock);
> +	WARN_ON_ONCE(!__test_and_clear_bit(index, pool->checked_out));
> +	spin_unlock(&pool->lock);
> +}

[Severity: High]
Can acquiring pool->lock with plain spin_lock() deadlock when a command
completes in interrupt context?

In the next patch in this series, commit "scsi: bsg: release io_uring
requests from end-I/O", scsi_bsg_uring_cmd_done() runs as the req->end_io
callback from hardirq or softirq context and calls
bsg_uring_cmd_put_completion_buf() directly when a command completes
without sense data:

bsg_uring_cmd_get_completion_buf()
  spin_lock(&pool->lock)
  <hardirq / softirq>
    scsi_complete()
      ...
        scsi_bsg_uring_cmd_done()
          bsg_uring_cmd_put_completion_buf()
            spin_lock(&pool->lock)  <-- spins forever

Both helpers should use spin_lock_irqsave() and spin_unlock_irqrestore(),
and the comment above struct bsg_completion_pool should note that buffers
may also be returned from end-I/O context.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119031751.3471=
968-2-yangxiuwei@kylinos.cn?part=3D1
