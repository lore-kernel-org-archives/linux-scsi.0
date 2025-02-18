Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82541243368;
	Tue, 18 Feb 2025 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739881890; cv=none; b=Y7jvrW1zqdytr4WS7E+IUBCfv4PGddN9AQZEwWGSUx5C95nA6ph39dIgOzDuqcPYM9oO5NtFLlKoUOxAk9XDtrZBdGf6kaR/DIqvQiKWZVRMgKWH3ZBfDEUfwJXKNTPrFSNv+rF91ZodguGSl6OVOurH9o3bVp0yiavZYtkfIPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739881890; c=relaxed/simple;
	bh=UA8BgaNnyRCw9xFtLSS5bxjRr4IV+xOTkb3Z8/jS98Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dS/cGZdsVkx3uRrXPZjBbHJe3IzJUBey4XF5Efvxu71rep5ych+xfb4zgU2JN4XcQ+p6JCG4ANuBXWvS7rKkOgVdCJE+ncL/PtHDntTiZPnsau0tZ27ju2cbxGG8Gkpcwb+2IE0sVf3AHlPOKIXR+k4+zeraa1Eg+/3LaC9WFS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nqLtlBiN; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqLtlBiN"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43989226283so11678665e9.1;
        Tue, 18 Feb 2025 04:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739881887; x=1740486687; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i1EiuFrOZAAO8BlNap0r2h1PwkpkjTMEHOOdrLbjwQw=;
        b=nqLtlBiNlAZBA06X0j0ZUBxPm/33ztcOa/kmENREwj2B91m1puNYm0WuU1zNocPu6E
         ykY/vRPL3jyXBcVQrw3Q/hb8hpCRmSL3zCvzTDp31g9nNCW49WAo0k5kEoX4lXLP1N2P
         +bTp31AS6O9ZMBypDk/YA6AbAq716L3q5mi/w8jqs5cIj0Gm0yF98p7drkzq9hc1kpax
         kqmlp3Bqv1IvaUd8SR2tBK9Uwav/aVyHByWEYAM9OQFCkMkuzRnvrAGrzUdiIa6Yvwo3
         A+i6eXiQExWXYd7ck7s7IhemzBLtOwQwcZKYsb3w8WXqbO6tQhX+Hl01oVs4jMcWXqsS
         HiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739881887; x=1740486687;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i1EiuFrOZAAO8BlNap0r2h1PwkpkjTMEHOOdrLbjwQw=;
        b=T17a7z7AIIOfFsgOX3PU0BdRDemZPXZ5GXkjz2rDez0CsJeZONrDv/pV2glFvbSvTD
         RpxmjT5kZOjL133ngWtu3Zt3YFC9T9T5+xeK4JbLw60fgAdCiUE3Z5JlJXqcf2y7wg7P
         UMPWKNAp16pd/ZbkmuthPMSR0bDTZt/79Cj6+so6LsnwMzwQcZvNpGM5QjLHsH9QaqMm
         nYAMCzCzbv4hUlnjHev39s8vhNWA5goMLzhQJ0BUntmxINWjfR7gopsLX6ulqaUub5qx
         4aGDR2kH225SQXhe4+scAsKRasjOXAlJ/jVLNMZvXCbImBM4u55G4YbJdJeNg05NKl7T
         MdnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAMixuZ322ZoffopR1dNet+tUmuveA5sYPdRTtH8gehb9bf7b1UVr4wN52Uq80aGb33cKlB46Gy5z45NM=@vger.kernel.org, AJvYcCWycFTc7gMXWQssQNXYnvUj78ug93A9ZqZjx6fPTdV/nSWONy8T2FVShVJB7qof/tuS2wNrpwz8@vger.kernel.org, AJvYcCXEJjnFjAVmzJzFHg7AWDZiNnayxd6jeq8GomAs7EHKST0B+gR+RwzqFBqNe3jeU1Qj0PI6C82f/tv8uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxILDrO1yNHSIlArjYohlAT2FygvvMDP5vjI9P9jP+fUdtlhiJq
	eNl5zmJdjVpnS+v7nSyEfXKvJ+a2GEjC3Q7xUEvepK9w+brO/FrX
X-Gm-Gg: ASbGnct+CGT2WQF1V/oIAsrQX0VN2TotQkf4ClHKOHfcdj1Xp4E9cNy9vS4+lnL+eUA
	Me6I7rukQqnGZkmdz39feeT4RH256Mafrc+O+q79rQ8SjECSaylG2UlXyrPbcLzdNl/8nqkgN92
	CyXyUDDjt6TYgd7j7het9wCN0CyNBzeqD0Z5xIymLDdKejUgffpSArfi1NOt85ykC4fsUOWenCh
	S7123oZffNjxsv934OckbRbd10lLyDTNpty6vOSuKHSaJdivW+eubAjKuCSNO8kaCn5ktaIRi5X
	jtfjnLeAJUcDqb8aWQ==
X-Google-Smtp-Source: AGHT+IHKpJVuCvnYRsmz4RpDTMOseTWydDN8ScsZSlwC/tzSRIKYd5jXEevc0CQS+qOpeSRpTQ0pbg==
X-Received: by 2002:a05:600c:474f:b0:439:9828:c450 with SMTP id 5b1f17b1804b1-4399828c663mr7030715e9.15.1739881886433;
        Tue, 18 Feb 2025 04:31:26 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43984dd042fsm56277745e9.12.2025.02.18.04.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 04:31:25 -0800 (PST)
Message-ID: <8be8c9c45d627e40e4ce3dc87c1ac83f32717e2b.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb
 command failed
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>, martin.petersen@oracle.com
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
 beanhuo@micron.com,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, bvanassche@acm.org,  stable@vger.kernel.org
Date: Tue, 18 Feb 2025 13:31:23 +0100
In-Reply-To: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
References: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-02-18 at 13:15 +0200, Arthur Simchaev wrote:
> In case the device doesn't support arpmb, the kernel get memory crash
> due to copy user data in bsg_transport_sg_io_fn level. So in case
> ufs_bsg_exec_advanced_rpmb_req returned error, do not set the job's
> reply_len.
>=20
> Memory crash backtrace:
> 3,1290,531166405,-;ufshcd 0000:00:12.5: ARPMB OP failed: error code -
> 22
>=20
> 4,1308,531166555,-;Call Trace:
>=20
> 4,1309,531166559,-; <TASK>
>=20
> 4,1310,531166565,-; ? show_regs+0x6d/0x80
>=20
> 4,1311,531166575,-; ? die+0x37/0xa0
>=20
> 4,1312,531166583,-; ? do_trap+0xd4/0xf0
>=20
> 4,1313,531166593,-; ? do_error_trap+0x71/0xb0
>=20
> 4,1314,531166601,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1315,531166610,-; ? exc_invalid_op+0x52/0x80
>=20
> 4,1316,531166622,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1317,531166630,-; ? asm_exc_invalid_op+0x1b/0x20
>=20
> 4,1318,531166643,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1319,531166652,-; __check_heap_object+0xe3/0x120
>=20
> 4,1320,531166661,-; check_heap_object+0x185/0x1d0
>=20
> 4,1321,531166670,-; __check_object_size.part.0+0x72/0x150
>=20
> 4,1322,531166679,-; __check_object_size+0x23/0x30
>=20
> 4,1323,531166688,-; bsg_transport_sg_io_fn+0x314/0x3b0
>=20
> Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support
> in ufs_bsg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
>=20
> ---
> Changes in v2:
> =C2=A0 - Add Fixes tag
> =C2=A0 - Elaborate commit log
>=20
> Signed-off-by: Arthur Simchaev <arthur.simchaev@sandisk.com>
> ---
> =C2=A0drivers/ufs/core/ufs_bsg.c | 6 ++++--
> =C2=A01 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 8d4ad0a3f2cf..a8ed9bc6e4f1 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -194,10 +194,12 @@ static int ufs_bsg_request(struct bsg_job *job)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_rpm_put_sync(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(buff);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bsg_reply->result =3D ret=
;
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0job->reply_len =3D !rpmb ? siz=
eof(struct ufs_bsg_reply) :
> sizeof(struct ufs_rpmb_reply);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* complete the job here =
only if no error */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret =3D=3D 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret =3D=3D 0) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0job->reply_len =3D !rpmb ? sizeof(struct ufs_bsg_reply)
> :
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 sizeof(struct
> ufs_rpmb_reply);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0bsg_job_done(job, ret, bsg_reply-
> >reply_payload_rcv_len);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> =C2=A0}


Arthur,

thanks for your update.=20

I tried to repoduce the issue as your steps, I didn't get this issue,
The kernel will only print this as expected:=20

Err: ARPMB OP failed 0 :-22



I don't think your patch can fix your issue, becase if ufs_bsg returns=C2=
=A0

-EINVAL(-22).  then,=20


bsg_reply->result =3D ret(-22);

after that,  then in bsg_transport_sg_io_fn:

if (job->result < 0) {
	job->reply_len =3D sizeof(u32);  //overwrite the length.



Could you please provide more information how you can get this issue?
My understanding is that it is not because this job->reply_len, it is
your buffer initiated by your application?


Kind regards,
Bean

