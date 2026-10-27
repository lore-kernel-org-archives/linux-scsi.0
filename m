Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793115909;
	b=fInp0ba2oPzHfMf3k63rLX6alpjQ2WiDVNzAnNeDgXwaEfdpxZ7H7N/eX3uLwiQQjYwR
	 xi8Iik3EcoffTzRbAA3GzW6z2mrtzrxT6JCFKqeF8sf2QtJLyKGXpfYlf5iVvFT/89amu
	 lAe9Ntzt0yhaHCxCIcMXKC+bzPhWtkCIDEZ6ghN1k2+j1du20Y4HK0M5zDo1fGkt7a7Gg
	 Z6hJcKBOblOjno6Eds+MTB1LzuqHab2pm1ECo7qcTsEjanuMqiBVMYnuKBmjcSIDSNUIO
	 gjpBVdzU7IXP+1ZCXQfbzqOzoYsFtlKxcjln20z9XxiUAVvw0FwR566AYLI4f7Ge3mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=7qVC9UUYwsvf3txmzp76sMUotGQnqFYvIzeVPR+E2O0=;
	b=hvCBKbnnarjP6Le5H5PESa3fE1NxiMwELm6l9HP/TyFDDnlRVrF48oWWm3q0tA7wIkyl
	 3Hg9RNuTD4gZfwgJxUEJ28ZHr8tquSltM/dMtwpApBSdUQlR2W0qJpz1eLZbyQpC1ACsy
	 /QgHaVZvNeO/bQ6r5SEUzrF19NmyLyI/wWMCpkLb7Y6hh64OMcGTjet5kLjJMT3qh3XWL
	 za7j8Es2nbhA0nWBh788Zp/f/nnwZ2vbjVE28K+BlONSHZfdfSCpjTcCEiCPC5xDIgRWJ
	 hHW+nckD1tPS4UG35s/yLfaIqH+zKmQ+WEfBmILeSgwMStc31TBl3ZWt7NHz1gVGwLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qnMepubd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.70
Received: from mail-lr2-f6.google.com (mail-lr2-f6.google.com [74.125.230.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32842606A335
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 15:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32842606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qnMepubd
Received: by mail-lr2-f6.google.com with SMTP id 38308e7fff4ca-3ab1be9340aso28428151fa.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 08:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793115907; cv=none;
        d=google.com; s=arc-20260327;
        b=DSSg5ZUTJ1yNTNFAact0uv2Rkowf364qmsL6cbqJuQthh4WMLMl71qovksGZLwhwfv
         6FWQn6AQtxnFdKW5dJj3ceDYqny9zrXKQAB+yMKq4foWzGpOurcn6LHX2mqQSCkmSAgY
         yaIr1z0rpJ1pqoYv6iOkIkl4Xyb5B5KALG8IHWld9D98K/WkvwMOBzF5fpb7I3hIJ/YD
         HsXN5BvbP/zTw2bAwB3NyFgFIo5h1DDlBqP06NtkHdIuaO0bbDl0cWiKa03BvfpyzO/l
         h+7/twAmNwNUARZBfj9Th8cOmFyo8+k/UNzsBfIwE370vCH0L4ZfOCKC33SUeD0tl0Ce
         MG/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7qVC9UUYwsvf3txmzp76sMUotGQnqFYvIzeVPR+E2O0=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=IzMQGdnVOEtaJcgNxARYXqLBFoH45pVSReebn/dgin8CVae+c1xbExfkrY/CPfnriJ
         X1AERR0IdQR8oIe+9HyIv8haTAiQBJzSQxMlY9NwOXZ01wwJMFggMgHNsdYiIRvvlPrD
         17f3PkQ/KW+2vyL1/3J1pyzzqLy6jQs6HnH9sJjtR3ppBJU6wZI0sHQZv845mDMRjkTc
         L33ugzspo2uQwQAONOPNmryLd2IyufiCv1RMTT4heDlsofj8qPkgHZBJdG4vbAdCPOAD
         BDD8Kii+xUOR0M1UlBt98Z9J7+0ZiKMszt3WmkVpxWN4rjvHPmLK7w3Ifl5zJhgQeDtl
         SeZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793115907; x=1793720707; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7qVC9UUYwsvf3txmzp76sMUotGQnqFYvIzeVPR+E2O0=;
        b=qnMepubdAlpijU9hG+aKTmNngMlElH4JCL9LchVQUUXjCS/uoOBrudjzIXUNngXy4H
         NRVcIYDFyG1D+HKi6aq2g/IY656Rd3Cg+1/fm3C0WMD7yFMxQFgP0vD2gk2fW120yHn/
         B7vlVrFTihDvpJApxmougYmK4Si2t/t1wWCikVI9yzF0b+MG0LrcCaBju9oZb0B2d5dj
         HU7qaZ+OYZXCxeY37tof/DgC6IqY8QlHbZhaDZiP3wRakZ3UuxK5QNIYpAPIYGRfBHRo
         puRsAXgNkjjxmHL8+JWtVdY2q7EVfV3+ELHL9rYZh7wWQGa9GJnDYK/wXfFtC1P/U94P
         npVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793115907; x=1793720707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7qVC9UUYwsvf3txmzp76sMUotGQnqFYvIzeVPR+E2O0=;
        b=KffgmMz+KzjyDtioEgvzqPbmh3jc5M6n0OETtkCQVKRBWPxw+S+d3MeXfZVC/H1Zgv
         0yKvviXrTaDvBQsqplSHRIU+cv47g6emoyJkszM+x58e7ZGqLYeUxnabD5ynH/FeXQsP
         tDpitfpiqnqacKQPIuRBcmSwrkjlo+3vozGJ4UKDi8Ufy/xheZJnLUzz4mCflFpzEnsc
         C42sdRLUox2DuyvhiJFgqcyfVOfGF3meSG3RfqizesfmmYr2JcClsvV6gficvl8tAI4s
         Zku0ACAwHIU5MUXju7ijzXgQz7s/QdOfvqUfQmYAPCBbAPli1aRNY8lrVlnDN0j/3ACi
         cvwQ==
X-Gm-Message-State: AFq9FYJs2PFT7KO5AhXfpONrPIX28uYwXzkMQE3XadHwXjdQmcyJPJK+
	tWMPMLEjIVmPDR0xX4HxieFdKt68BaPHweXB2FGlziumqHQtNElEE3AjHEUk8Lyh4R3Ns1f3Ix9
	YDQF+S6rRgC1aENYz5l0/9w/3cxbCmst2Ln6Alvnx0Q==
X-Gm-Gg: AYBFou0DRZdK1WQH6FsSf+i+ey7IaIGPKGIeQsBvVoKka3bXewmWeKILNfUUoNbHsPp
	VS/peFSfvHwz1uunc7VgPfYhjZB7FTUUP3XvqOw8taDf+wV7DOZzF4liw6LhqUEbWdmnuhThyr8
	qTg55nWetWbCuGn0zuqsN/cHVKH6NcDVLGx78qDN4Eg+iiF2cUkgNP9RkdO4ttoPnSfaa3g5YLQ
	dzdyym+nxxUQer0JE418vLS+ksaGr0Wfs5zxYTogxSiaqhJjroaYhdsU5Vb2n3bbfM50siIPyhs
	PUdeqYvmEBvHv7NdiBMMi4G1xgYDHPjm7sU5agFEipZxSZIgeqNjoB8eF+oDJNkgAmUHKV+6V/x
	47kDBhmoa8nbNilVFMf2+pBiNNQP8G7n87DJsrA==
X-Received: by 2002:a05:651c:2118:b0:3a6:4452:bff1 with SMTP id
 38308e7fff4ca-3ac6fd1896dmr27035421fa.16.1793115907142; Tue, 27 Oct 2026
 08:45:07 -0700 (PDT)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027150752.951217-1-bsdhenrymartin@gmail.com> <sashiko-outbox-186828@kernel.org>
In-Reply-To: <sashiko-outbox-186828@kernel.org>
From: henry martin <bsdhenrymartin@gmail.com>
Date: Tue, 27 Oct 2026 23:44:55 +0800
X-Gm-Features: AclHuK8o_x8D51yrjumY0OMRV8pch24SxXC-FujqEcNgHdBayQFoQUU8OSZPKKo
Message-ID: <CAEnQdOrkc5EMpWBAreTOG038brf9LcfffL7psoNO50JiFt+8Fg@mail.gmail.com>
Subject: Re: [PATCH] scsi: qedi: fix OOB read in login/text response completion
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Correct, thanks.  Confirmed in-tree: push_callback_call() only
propagates -EFAULT from btf_check_subprog_call(), so the -EINVAL
path reaches check_stack_arg_read() with caller->stack_arg_regs
unvalidated or stale - and it is a heap array sized by
out_stack_arg_cnt, so this is a NULL deref or stale-state copy.

One refinement: set_timer_callback_state() (async timer/workqueue)
does not set in_callback_fn, so that check alone misses the
original frame[-1] case.  v2 rejects on both:

    if (vstate->curframe =3D=3D 0 || state->in_callback_fn)

pw-bot: cr

Regards,
Henry

<sashiko-bot@kernel.org> =E4=BA=8E2026=E5=B9=B410=E6=9C=8827=E6=97=A5=E5=91=
=A8=E4=BA=8C 23:23=E5=86=99=E9=81=93=EF=BC=9A
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] scsi: qedi: unclamped dlength in qedi_process_text_resp() and =
login_resp()
> --
>
> commit b81ce3a14651452d3f551e4635d2337a8b305729
> Author: Henry Martin <bsdhenrymartin@gmail.com>
>
> scsi: qedi: fix OOB read in login/text response completion
>
> This commit clamps the payload length extracted from the CQE in
> qedi_process_text_resp() and qedi_process_login_resp() to
> qedi_conn->gen_pdu.resp_buf_size before advancing resp_wr_ptr, preventing
> an out-of-bounds read when completing the PDU to userspace.
>
> > diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> > index c8af10c326532..5e20716043aee 100644
> > --- a/drivers/scsi/qedi/qedi_fw.c
> > +++ b/drivers/scsi/qedi/qedi_fw.c
> > @@ -115,6 +115,8 @@ static void qedi_process_text_resp(struct qedi_ctx =
*qedi,
> >
> >       pld_len =3D cqe_text_response->hdr_second_dword &
> >                 ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
> > +     if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
> > +             pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
> >       qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + =
pld_len;
> >
> >       memset(task_ctx, '\0', sizeof(*task_ctx));
> > @@ -294,6 +296,8 @@ static void qedi_process_login_resp(struct qedi_ctx=
 *qedi,
> >       resp_hdr_ptr->status_detail =3D cqe_login_response->status_detail=
;
> >       pld_len =3D cqe_login_response->hdr_second_dword &
> >                 ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
> > +     if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
> > +             pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
> >       qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + =
pld_len;
>
> [Severity: Medium]
> Should resp_hdr_ptr->dlength also be populated from the clamped pld_len i=
n
> both qedi_process_text_resp() and qedi_process_login_resp()?
>
> Earlier in both functions, resp_hdr_ptr->dlength is written using the raw
> unclamped 24-bit CQE value before pld_len is clamped to
> qedi_conn->gen_pdu.resp_buf_size:
>
> drivers/scsi/qedi/qedi_fw.c:qedi_process_text_resp() {
>         ...
>         hton24(resp_hdr_ptr->dlength,
>                (cqe_text_response->hdr_second_dword &
>                 ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK));
>         ...
>         pld_len =3D cqe_text_response->hdr_second_dword &
>                   ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK;
>         if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
>                 pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
>         qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + =
pld_len;
>
> and similarly in qedi_process_login_resp():
>
> drivers/scsi/qedi/qedi_fw.c:qedi_process_login_resp() {
>         ...
>         hton24(resp_hdr_ptr->dlength,
>                (cqe_login_response->hdr_second_dword &
>                 ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK));
>         ...
>         pld_len =3D cqe_login_response->hdr_second_dword &
>                   ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK;
>         if (pld_len > qedi_conn->gen_pdu.resp_buf_size)
>                 pld_len =3D qedi_conn->gen_pdu.resp_buf_size;
>         qedi_conn->gen_pdu.resp_wr_ptr =3D qedi_conn->gen_pdu.resp_buf + =
pld_len;
>
> When __iscsi_complete_pdu() calls iscsi_recv_pdu(), the netlink message i=
s
> allocated and populated with only data_size (the clamped pld_len) bytes o=
f
> payload following the header:
>
> drivers/scsi/scsi_transport_iscsi.c:iscsi_recv_pdu() {
>         int len =3D nlmsg_total_size(sizeof(*ev) + sizeof(struct iscsi_hd=
r) +
>                                    data_size);
>         ...
>         pdu =3D (char*)ev + sizeof(*ev);
>         memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
>         memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
>
> If the CQE data segment length exceeds resp_buf_size, won't this leave
> resp_hdr_ptr->dlength advertising the larger unclamped length in the
> embedded struct iscsi_hdr while only resp_buf_size bytes of payload are
> actually present in the netlink message sent to userspace?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027150752.95=
1217-1-bsdhenrymartin@gmail.com?part=3D1
