Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789965;
	b=ThUqzjpuSnYxtskac8LaaP/F1aOocqwNxl2mGDJatbyIH+iljSLLSLCeQLqT4jUXH4WO
	 4jqNXAQRxzYjPB1n0Ih0sw2ukYwtUEEubbOe+RW01fBy8EtvbmGukq8H1qMWat3IZrK+a
	 Dyy61Pr05GuTID3WFa1yj2uEWd9tRKNML2yjEz371CYAFu/VhsSphyelOxzeog55601rm
	 uWlPnUVAUMfLF3a3znw87IFEXooW88xeF57eBwx5C5YqChRrUk7GNYgEvfDNrmFSOfq89
	 AgPlJtD8jtwjYvCK2wsGdzjg/xAnZZ3GlCaE+izqGDnviJwJXKly4BLdys+2fEUN4GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789965;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=P9KmciO24V6/vG9pfsrfol4qJ9DQhIAPOfVYuyQYLNM=;
	b=4dSJhw5gFF4KR3Lt+LLmkSsieZAp8rQENiRyQ6C7c8Dr/AsCfyTPB2ZOrN/gZWzyw10n
	 CfHssRV096QnM7qZ2u72cyvgwq4EEV8D6AEB9MjOQ1vyOE5MmcusLoHDupA0OdsaEUhig
	 uYT959Ueh+AGuBwzinrJWdD0DaNgcgF9XhgOwq9xBhPHFuEVUXucUo3C4406v4ERz9YB0
	 BVANWs4+bR/MbBZ/qMxwb5Kw+LkGYHTI9X9dYR3LX+N41TBvikPfB9IdAsu4qinNT6fB2
	 XI2IcJH7BzXr4vaggT8IwAKqM6J8+Tt6O8dgQR5JM0CzX2QwYE76T0hgo7JQG+U6b1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddJ2TwTm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F73606A335;
	Mon, 16 Nov 2026 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ddJ2TwTm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35F01F000C5;
	Mon, 16 Nov 2026 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794789965;
	bh=P9KmciO24V6/vG9pfsrfol4qJ9DQhIAPOfVYuyQYLNM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ddJ2TwTmcPW0Z2R9soLQu+i+NcrpWemRqJQ8Y3ZDLVTCohYHT3UPwjitdFcHw+lY/
	 s8K5w+ycCoZx5aOy2cP8qguCArrS03BT62q+fvXS7xVxKUma5jDU+MzJNorkd7Fotr
	 vAhb2tic9md6IP1i9BpkQqZ5/q1hgYDQLOSghy4NhlxSgZCQyLkCSTudbW/yuqSxOO
	 zUZFhYHlQNKProGIGzzJx4aMHNiY3zpFfsbU+cxH5NTyIj3Dng006bEkpieGUZ96iH
	 JRgovFdKuF33yPnkECxkONpBsYd1dvHs+oINVI3YjB/+6CHyYgxfDBUua/NC0JoKUD
	 fm0L9qeP1IvvQ==
Message-ID: <sashiko-outbox-215970@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 05/18] scsi: target: uring: Queue commands until a
 server fetches them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-5-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-5-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:46:04 +0000
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
- [High] scsi: target: uring: missing TCMUR_MAX_IO_SIZE check in
  tcmur_execute_rw()
--

commit aaa41f59a5c1c48ba973ecbd7b4b910b4c814276
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

scsi: target: uring: Queue commands until a server fetches them

This commit allocates a struct tcmur_cmd for each read and write command,
populates its I/O descriptor, and queues it on the pending list of the
submitting CPU's queue.

> diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_c=
ore_uring.c
> index 904ce2a613618..90e443ecb944c 100644
> --- a/drivers/target/target_core_uring.c
> +++ b/drivers/target/target_core_uring.c

[ ... ]

> @@ -66,12 +88,56 @@ static struct tcmur_dev *TCMUR_DEV(struct se_device *=
dev)
>  	return container_of(dev, struct tcmur_dev, se_dev);
>  }
> =20
> +static struct tcmur_queue *tcmur_cmd_queue(struct tcmur_dev *udev,
> +					   struct se_cmd *se_cmd)
> +{
> +	return &udev->queues[(unsigned int)se_cmd->cpuid % udev->nr_queues];
> +}
> +
> +static void tcmur_queue_cmd(struct tcmur_dev *udev, struct tcmur_cmd *tc=
md)
> +{
> +	struct tcmur_queue *q =3D tcmur_cmd_queue(udev, tcmd->se_cmd);
> +
> +	spin_lock(&q->lock);
> +	list_add_tail(&tcmd->node, &q->pending);
> +	spin_unlock(&q->lock);
> +}
> +
> +static sense_reason_t tcmur_submit(struct se_cmd *se_cmd, u32 op, u64 of=
fset,
> +				   u64 len, struct scatterlist *sgl,
> +				   u32 sgl_nents)
> +{
> +	struct tcmur_dev *udev =3D TCMUR_DEV(se_cmd->se_dev);
> +	struct tcmur_cmd *tcmd;
> +
> +	tcmd =3D kmem_cache_zalloc(tcmur_cmd_cache, GFP_NOIO);
> +	if (!tcmd)
> +		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +
> +	tcmd->se_cmd =3D se_cmd;
> +	tcmd->sgl =3D sgl;
> +	tcmd->sgl_nents =3D sgl_nents;
> +	tcmd->desc.op =3D op;
> +	tcmd->desc.offset =3D offset;
> +	tcmd->desc.len =3D len;
> +	tcmd->desc.data_len =3D se_cmd->data_length;
> +	if (op =3D=3D TCMUR_OP_WRITE && (se_cmd->se_cmd_flags & SCF_FUA))
> +		tcmd->desc.flags |=3D TCMUR_IO_F_FUA;
> +
> +	tcmur_queue_cmd(udev, tcmd);
> +	return 0;
> +}
> +
>  static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
>  				       struct scatterlist *sgl, u32 sgl_nents,
>  				       enum dma_data_direction dir)
>  {
> -	/* Fail the commands until a server can pick them up */
> -	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	u32 block_size =3D se_cmd->se_dev->dev_attrib.block_size;
> +
> +	return tcmur_submit(se_cmd, dir =3D=3D DMA_FROM_DEVICE ? TCMUR_OP_READ :
> +							     TCMUR_OP_WRITE,
> +			    se_cmd->t_task_lba * block_size,
> +			    se_cmd->data_length, sgl, sgl_nents);
>  }

[Severity: High]
Can tcmur_execute_rw() queue a command with tcmd->desc.data_len larger than
the TCMUR_MAX_IO_SIZE limit advertised by TCMUR_GET_DEV_INFO in
info.max_io_size?

Although tcmur_configure_device() sets dev->dev_attrib.hw_max_sectors to
TCMUR_MAX_IO_SIZE / udev->block_size, the target core only uses
hw_max_sectors to report the advisory maximum transfer length in Block
Limits VPD page 0xb0 and does not reject READ or WRITE commands that exceed
it (unlike fd_execute_rw(), which checks cmd->data_length > FD_MAX_BYTES).
An initiator can send a READ or WRITE command larger than 4 MiB and cause a
userspace server that sizes its I/O buffer to info.max_io_size (such as
tcmur_server.c in this series) to overflow its buffer.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D5
