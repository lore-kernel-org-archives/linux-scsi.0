Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794791035;
	b=hvEhsj38ir237OWy4UY8pOvWnh45xJdgwWjd+g0zUvUDeVzET9vMJwT9SoY/PlAdnWVC
	 IBV1IDLEK1k1sihTFC6Qv2BkH2vdIVjOvX4op/8sI8mOjJVUudMDy8XeRQmobYfegGvTC
	 ZRXT1+M8dv3DBoYuaGnnHhBMJNLhAPQnLvNxXQV58loF34x5A86/F9dekSoxfHvfJx2jz
	 SP6XwbYD5P3BOFJHpHWL6EYrfIBi74BPyJIWOvbOcx/psOSefL5r6hw1885enbAUrsdyw
	 qFfUIsws7A6Nfb67cijKTlXdQ64+QtcoLJvoLKt3UJHLya9+htA55kWokXG7cOlAp6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794791035;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mEYKNfhSJ/91kGjAF+dIdQ3waU3Xm6twNBDL/M167dg=;
	b=L3LzMdE1EGjFp1Zi++8HmK3vZ4DqO4XHmv8DlYEEV8QUtgDGpz340ERsmQPzqILajWJJ
	 aPFk1r5cdD7up5DpAu2ROBaxWh3w4Dv8kgHj8E+9m/HfGr0ouRTboeRewIibJFKYor/uL
	 JQEhIMfW1eXO1Bhp1xCIwnr37X+/8G/7YV+hqI5VpoJXjjuCwECd9xAobrQf60MTZpFpA
	 s7/j+0ftimlzyR69A+Mt/djn3on+iFInZxdwnIsM34hhzNUdRfGXmBmOrdHSHKajNds3q
	 BBsF9jn4UXULX3LMCuSUo+0+eMhQYfL+Mb2TfhiuXO+N1aVQ2cDy1GRTRjkr7Ddh+yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ky9QrBrH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BBF606A329;
	Mon, 16 Nov 2026 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ky9QrBrH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ECC1F000C4;
	Mon, 16 Nov 2026 01:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794791035;
	bh=mEYKNfhSJ/91kGjAF+dIdQ3waU3Xm6twNBDL/M167dg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ky9QrBrH1rNQ4ahdU+kCZ+wbu6yudnREOEYe/vr3cPUHmqYXP6/2jcqDY8v1SufQB
	 4yxgzHCNsmn2fMJYEj6hRAPsGGSoP/0mQGf76bLmyCbvqs0WG2GXGPfQAAFgzdbMLk
	 q469jp12EZVPcY7Ycl4JCR0SMMpnDaiCYogrGLJNX3cyZ96cp4x1Y6pR3Hjq4xD/5/
	 BF291gARKJvUajqIsFw2tBTMJ7IP6xvCtaOh/2Y/sAP03Y5QeuM0m0rJyzvQjgoWzq
	 cPhfneySL5VX9ZeOOzLn5SjS+IH72Vwq02BHgGRdSgsZ62F/QYA6achlVXNE/dKq9r
	 EOIXgwHO43ylg==
Message-ID: <sashiko-outbox-215986@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 16/18] selftests: target_core_uring: Add a minimal
 server
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-16-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-16-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 01:03:54 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [Medium] selftests: target_core_uring: missing FUA sync in zero-copy
  handle()
- [Medium] selftests: target_core_uring: tag leak on UD_REG failure in
  queue_fn()
- [Medium] selftests: target_core_uring: commit before UD_UNREG in
  queue_fn()
- [Medium] selftests: target_core_uring: 32-bit off_t truncation in
  copy_data()
- [Low] selftests: target_core_uring: 0-length I/O passed to
  start_zero_copy()
- [Low] selftests: target_core_uring: perror() after liburing calls in
  queue_fn()
- [Low] selftests: target_core_uring: unchecked calloc() for queues in
  main()
--

commit a8d885b7b600468b558a9ffcad7e5d1e7afa97ce
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

selftests: target_core_uring: Add a minimal server

This commit adds tcmur_server, a minimal userspace server for
target_core_uring devices supporting null, RAM, and file backends with
optional zero-copy fixed-buffer I/O.

> diff --git a/tools/testing/selftests/target_core_uring/Makefile b/tools/t=
esting/selftests/target_core_uring/Makefile
> new file mode 100644
> index 0000000000000..438628fd1606b
> --- /dev/null
> +++ b/tools/testing/selftests/target_core_uring/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +CFLAGS +=3D -O2 -Wall -D_GNU_SOURCE $(KHDR_INCLUDES)
> +LDLIBS +=3D -luring -lpthread
> +
> +TEST_GEN_PROGS_EXTENDED :=3D tcmur_server
> +
> +include ../lib.mk
> diff --git a/tools/testing/selftests/target_core_uring/tcmur_server.c b/t=
ools/testing/selftests/target_core_uring/tcmur_server.c
> new file mode 100644
> index 0000000000000..128a0021e7796
> --- /dev/null
> +++ b/tools/testing/selftests/target_core_uring/tcmur_server.c

[ ... ]

> +static int copy_data(struct queue *q, int tag, void *buf, uint32_t len,
> +		     bool to_cmd)
> +{
> +	uint64_t pos =3D tcmur_buf_pos(q->q_id, tag, 0);
> +	ssize_t ret;
> +
> +	if (to_cmd)
> +		ret =3D pwrite(dev_fd, buf, len, pos);
> +	else
> +		ret =3D pread(dev_fd, buf, len, pos);
> +	return ret =3D=3D len ? 0 : -EIO;
> +}

[Severity: Medium]
Does passing pos to pread() and pwrite() truncate the upper 32 bits on
32-bit architectures?

tcmur_buf_pos() encodes q_id in bits 48..63 and tag in bits 32..47, but
neither the Makefile nor tcmur_server.c defines _FILE_OFFSET_BITS=3D64, so
off_t is 32-bit on 32-bit targets and every non-zero q_id or tag is lost.
Also, passing -D_GNU_SOURCE in the Makefile conflicts with -D_GNU_SOURCE=3D
in ../lib.mk, triggering a macro redefinition warning during the build.

[ ... ]

> +/* Start the I/O on the data pages of the command, without copying them =
*/
> +static void start_zero_copy(struct queue *q, int tag, struct tcmur_io_de=
sc *d)
> +{
> +	struct io_uring_sqe *sqe;
> +
> +	sqe =3D prep_cmd(q, TCMUR_IO_REGISTER_BUF, tag, 0, UD_REG);
> +	sqe->flags |=3D IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS;
> +
> +	sqe =3D get_sqe(q);
> +	if (d->op =3D=3D TCMUR_OP_READ)
> +		io_uring_prep_read_fixed(sqe, backing_fd, NULL, d->data_len,
> +					 d->offset, tag);
> +	else
> +		io_uring_prep_write_fixed(sqe, backing_fd, NULL, d->data_len,
> +					  d->offset, tag);
> +	sqe->flags |=3D IOSQE_IO_HARDLINK;
> +	sqe->user_data =3D (uint64_t)UD_RW << 16 | tag;
> +
> +	sqe =3D prep_cmd(q, TCMUR_IO_UNREGISTER_BUF, tag, 0, UD_UNREG);
> +	sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
> +}
> +
> +/* Return true if the command completes later */
> +static bool handle(struct queue *q, int tag, int *result)
> +{
> +	struct tcmur_io_desc *d =3D &q->descs[tag];
> +	bool rd =3D d->op =3D=3D TCMUR_OP_READ;
> +	int ret =3D 0;
> +
> +	switch (d->op) {
> +	case TCMUR_OP_READ:
> +	case TCMUR_OP_WRITE:
> +		if (d->offset + d->len > info.dev_size) {
> +			ret =3D -EINVAL;
> +		} else if (backend =3D=3D BACKEND_RAM) {
> +			ret =3D copy_data(q, tag, ram + d->offset, d->data_len,
> +					rd);
> +		} else if (backend =3D=3D BACKEND_FILE && zero_copy) {
> +			start_zero_copy(q, tag, d);
> +			return true;
> +		}

[Severity: Low]
What happens in zero-copy mode when a valid 0-sector SCSI READ or WRITE
arrives with d->data_len =3D=3D 0?

handle() still calls start_zero_copy(), which submits
TCMUR_IO_REGISTER_BUF, and tcmur_register_buf() in
drivers/target/target_core_uring.c rejects !tcmd->desc.data_len with
-EINVAL instead of completing the 0-length transfer with 0 as the non-zero-=
copy
paths do.

> +		} else if (backend =3D=3D BACKEND_FILE && rd) {
> +			if (pread(backing_fd, q->buf, d->data_len, d->offset) !=3D
> +			    d->data_len)
> +				ret =3D -EIO;
> +			else
> +				ret =3D copy_data(q, tag, q->buf, d->data_len,
> +						true);
> +		} else if (backend =3D=3D BACKEND_FILE) {
> +			ret =3D copy_data(q, tag, q->buf, d->data_len, false);
> +			if (!ret && pwrite(backing_fd, q->buf, d->data_len,
> +					   d->offset) !=3D d->data_len)
> +				ret =3D -EIO;
> +		}
> +		if (!ret && backend =3D=3D BACKEND_FILE &&
> +		    (d->flags & TCMUR_IO_F_FUA) && fdatasync(backing_fd))
> +			ret =3D -errno;
> +		break;

[Severity: Medium]
Does zero-copy mode ignore TCMUR_IO_F_FUA on writes?

When zero_copy is true, handle() returns early after start_zero_copy() and
skips the fdatasync(backing_fd) check above, while neither
start_zero_copy() (for instance via RWF_DSYNC on sqe->rw_flags) nor the
UD_RW completion path in queue_fn() syncs backing_fd before committing the
command.

[ ... ]

> +static void *queue_fn(void *arg)
> +{
> +	struct io_uring_params p =3D {
> +		.flags =3D IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN,
> +	};
> +	struct queue *q =3D arg;
> +	struct io_uring_cqe *cqe;
> +	unsigned int head, n;
> +	int tag, kind, result;
> +
> +	/* Create the ring here, as only its creator may submit to it */
> +	if (io_uring_queue_init_params(info.queue_depth * 4, &q->ring, &p) ||
> +	    (zero_copy &&
> +	     io_uring_register_buffers_sparse(&q->ring, info.queue_depth))) {
> +		perror("io_uring setup");
> +		exit(1);
> +	}
> +
> +	for (tag =3D 0; tag < info.queue_depth; tag++)
> +		prep_cmd(q, TCMUR_IO_FETCH, tag, 0, UD_FETCH);
> +
> +	for (;;) {
> +		if (io_uring_submit_and_wait(&q->ring, 1) < 0) {
> +			perror("io_uring_submit_and_wait");
> +			exit(1);
> +		}

[Severity: Low]
Will perror() print a meaningful error after these liburing calls fail?
io_uring_queue_init_params(), io_uring_register_buffers_sparse(), and
io_uring_submit_and_wait() return negative errno values directly without
setting errno.

> +
> +		n =3D 0;
> +		io_uring_for_each_cqe(&q->ring, head, cqe) {
> +			n++;
> +			tag =3D cqe->user_data & 0xffff;
> +			kind =3D cqe->user_data >> 16;
> +
> +			switch (kind) {
> +			case UD_FETCH:
> +				if (cqe->res < 0)
> +					goto out;
> +				if (handle(q, tag, &result))
> +					continue;
> +				break;
> +			case UD_RW:
> +				result =3D cqe->res =3D=3D q->descs[tag].data_len ?
> +					 0 : -EIO;
> +				break;
> +			default:
> +				/* Report failures through the I/O that follows */
> +				continue;
> +			}

[Severity: Medium]
If TCMUR_IO_REGISTER_BUF (UD_REG) fails, does this ignore the only CQE and
leak the tag?

In start_zero_copy(), UD_REG is submitted with
IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS.  When a request with
IOSQE_CQE_SKIP_SUCCESS fails and uses a soft link (IOSQE_IO_LINK),
req_set_fail() sets REQ_F_SKIP_LINK_CQES and io_fail_links() suppresses
CQEs for all subsequent linked requests (both UD_RW and UD_UNREG).
Because the default branch ignores the UD_REG error CQE waiting for a
UD_RW CQE that will never arrive, TCMUR_IO_COMMIT_AND_FETCH is never
issued for tag.

> +			prep_cmd(q, TCMUR_IO_COMMIT_AND_FETCH, tag, result,
> +				 UD_FETCH);
> +		}

[Severity: Medium]
Can submitting TCMUR_IO_COMMIT_AND_FETCH on the UD_RW CQE race ahead of
the linked TCMUR_IO_UNREGISTER_BUF (UD_UNREG) request?

In start_zero_copy(), UD_UNREG is linked after UD_RW with
IOSQE_CQE_SKIP_SUCCESS, so UD_RW's CQE is posted to the CQ ring before
UD_UNREG runs:

kernel                                      queue_fn()
------                                      ----------
UD_RW completes (e.g. via io-wq)
  posts UD_RW CQE to CQ ring
                                            io_uring_submit_and_wait(..., 1)
                                              reaps UD_RW CQE
                                              prep_cmd(TCMUR_IO_COMMIT_AND_=
FETCH)
                                            io_uring_submit_and_wait(..., 1)
__sys_io_uring_enter()
  io_submit_sqes()
    TCMUR_IO_COMMIT_AND_FETCH completes
    fetches new command on same tag
                                              reaps UD_FETCH CQE
                                              start_zero_copy()
                                                prep_cmd(TCMUR_IO_REGISTER_=
BUF)
    io_kernel_buffer_init()
      returns -EBUSY  <-- slot tag still occupied before UD_UNREG runs

Because __sys_io_uring_enter() processes new SQEs before draining pending
local task_work (or while UD_UNREG is still queued from io-wq), the tag is
committed and reused while fixed-buffer slot tag is still registered.
Linking TCMUR_IO_COMMIT_AND_FETCH after UD_UNREG, or waiting for UD_UNREG
before committing, would avoid this ordering issue.

[ ... ]

> +	desc_size =3D info.queue_depth * sizeof(struct tcmur_io_desc);
> +	desc_size =3D (desc_size + getpagesize() - 1) & ~(getpagesize() - 1);
> +	queues =3D calloc(info.nr_queues, sizeof(*queues));
> +	for (i =3D 0; i < info.nr_queues; i++) {
> +		struct queue *q =3D &queues[i];
> +
> +		q->q_id =3D i;

[Severity: Low]
Can calloc() return NULL here and cause a NULL pointer dereference at
q->q_id =3D i?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D16
