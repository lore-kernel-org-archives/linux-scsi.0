Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068747;
	b=o1gPaojjdi2I/uCOq7SQQop/KhVVLklYgrF0Nv+XRvPkrpD9qYI9g7eDKATS8Y2EVRHT
	 ACOJoNz/xCKff9J8TF6SrwHgT55aC1hIUHqEKMADqAlPJnSb3qOQ5SBs8oQIi6CHur0ZJ
	 /BPW7sj+is9CYmqizHdBEYv7L+kUFK7V2KsO2EzSgJQEQXZLXTThsD9ReSEPnnDJwGswJ
	 UUsI3NIqZivZLM5cMkTgu5+MrjGS0IdK7PoyMRffIPWgxGkwJUCwuUYumoUU48/xzyaAg
	 1M3xA9L0k2ZsBpz+ocnCaELmINaSaAeiFOCqpxUFYSIkSWFVhCdbXQGIGEbg+L3wxJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068747;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Hq7xcFbHkpySaluyWj7ohzHnf8eEJwlCVyZcc1ITxaE=;
	b=NER0zi556EGOPi4gAJuDLmzf5k+9TBKVyTRTCR7LREVTm0MiUGVEE7EihTb9SKyroXPn
	 Ext+/2bJfSsJ6dd+I2LCuqX7JnUkJOZg5LiUlD3VJ3YLUJcEBP/6TOKOJwYE09LFmHbTa
	 AjX4yDUux4ZBTeJiIo8oitb7Zx9ljHhxSH5M2wIWxvQ2jlqpRtQspv8HffwyH97XfocWG
	 +MH2Y9h3RSfR3OdtFQGiDotAj0Mv1M0S4UiI1TKMP3bdNCQfDvX4kJ1TatCoHy85MdouF
	 Hqo000L22jv03IBhwBUlwXY61CnST1QF5spHiZk2OwRzc2YN9h7DS7liFq7eNgscp5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GOti/XJ2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F9E606A32C
	for <linux-scsi@vger.kernel.org>; Sat,  7 Nov 2026 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOti/XJ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A211F0089F;
	Sat,  7 Nov 2026 16:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794068746;
	bh=Hq7xcFbHkpySaluyWj7ohzHnf8eEJwlCVyZcc1ITxaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GOti/XJ25sMmZl6NSnEYsY/OrIO/9ZQh0NBEKnQX+8utAeSrB0VlEvDXFfB/rvW9O
	 iVJVzhzmH50c0+IZ53UPPauVqPBfKsQsP/5cq5XvEsTE33JYFu81OenltaO+B8lfXh
	 wftATmaZ0pgy2xErVSJtrLtIMH9qRyWHPgPq41hqflxu6KpQXdF6F3oHYHtp49oydw
	 TmYayTDaWEkVHyEAjM+JQfWY+O5+6VxGBqNMn2dO7lPwx1bQ12tDYNbn9W/pNKsVYP
	 gm1MM9RtNOKUfTR7zWEnfQzVz1yMQZgQmBW0Z+3S5pH+UuZV1Slg6vgie/GsWDaqrp
	 T8+TUyVwee+Cw==
Message-ID: <sashiko-outbox-203055@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: lpfc: Report bsg mailbox failures as an
 errno
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261107161655.2628796-2-vulab@iscas.ac.cn>
References: <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
 <20261107161655.2628796-1-vulab@iscas.ac.cn>
 <20261107161655.2628796-2-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 16:25:46 +0000
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
- [Low] scsi: lpfc: missing Fixes trailer for commit 7a4702774381
--

commit 7d6fb8accad0321798579f3066c01e672f56703a
Author: Wentao Liang <vulab@iscas.ac.cn>

> scsi: lpfc: Report bsg mailbox failures as an errno
>
> lpfc_bsg_issue_mbox() hands a command to the port with MBX_NOWAIT and, if
> that does not start the command, returns the raw result to
> lpfc_bsg_mbox_cmd(), which stores it in the bsg reply.  bsg-lib only
> reports a negative result as an error to the ioctl caller, so a positive
> MBX status such as MBX_NOT_FINISHED is passed off as success, with
> device_status holding the low byte of the status and no reply data.
>
> Report -EIO instead, as the polled path in the same function already maps
> its failures to -ETIME and -ENODEV.
>
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

[Severity: Low]
7a4702774381 ("[SCSI] lpfc 8.3.11: Driver management improvements via BSG")
dropped the -EIO assignment when refactoring lpfc_bsg_issue_mbox() to use
the job_done label.  Should this include:

  Fixes: 7a4702774381 ("[SCSI] lpfc 8.3.11: Driver management improvements =
via BSG")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107161655.2628=
796-1-vulab@iscas.ac.cn?part=3D2
