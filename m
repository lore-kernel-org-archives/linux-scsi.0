Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93471188A3B;
	Mon, 17 Feb 2025 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739817577; cv=none; b=jmPQo+JxPXr51WvXimPyX414pnTPu5u42jHv+yj7jy+ZnW+AHKtEjGi1ZpyFLssk8fIDDsltBNjhybbwjrkk4KCjiY17Fh6gmANwF6nP8pPQVFGON509D4fQvZ6yI60ZkJfqKdfPElVwcZ2pv2RULUewEKY7O6tfT58LwkamVaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739817577; c=relaxed/simple;
	bh=ibeLQkqGZnHUGDV4imgix8149aTc0doBQb1jJhxFPpI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t/u5JQ+tliqIXMpka/+oA6TTygGHlNSZOYIJBVn3boZeW1i7smSEZfjOxuq/t9cSxvDvieqXceNIG5ZBVtUDxIFKmbJ0B+93jT9kWkYC+7y6MUXWDQ8OLo+qAG4u/8AnqFwpFig4sem/ddOI8wydk0mJnNOLVgRXKZ/Twz6t+tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpzMSWlk; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpzMSWlk"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso51486215e9.1;
        Mon, 17 Feb 2025 10:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739817574; x=1740422374; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rjNjpm7nad/tLGA41YlKQjUrQeFd8i+8MRCd6+CzP/8=;
        b=VpzMSWlk2UD8ReX1wS9AafF0n0OoyznTrSrnE0G6w3fjC3NZ13aa7F+oAZLU2sngBv
         sr0zsSu+UxU0V4Vl0ylFNXpuM1wFNfAbpXs1UqqE9W2QWtE1TG3JZ6aMlemP1w8bfmP2
         BkNXlwjRiIt1fz2Po0jJNxYC31f45RiUyJfexuR/zjsKNAX7lhjGW6eTOOjmhhsPVbEB
         7yYc96wuELvmncFAY1wC7qoOuJ/8PQh8IlnysOTmkN20TDW9f2SGnM4ePbD6f8Nqqca2
         DaphyWfbRZt+MbNJkwskqk5NygI3uPLxc65Ee1r+XHDp2xzkzywqQc/M5U0ehJOFO9ZC
         bx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739817574; x=1740422374;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjNjpm7nad/tLGA41YlKQjUrQeFd8i+8MRCd6+CzP/8=;
        b=C1PdmgOBKNB6XwoVrymOJ/yRCleNLCkZjGh1bLF1B/IjKo4vO1Efg7EXQAJU7u1O5w
         HkNajcf9QByf7QsbkZJaGweHBqTQbuOMQgyL/DDxGY6oIR5lahTxeJh+/3O0AztuGpWl
         WtLu1bEMm3awEaxMILkhhNCWqcFhvm1uW6+pPhkwKBjfWjR+q9N12mKJk1FiQfYBQvpw
         hN2xcqTdiqZtPz+e7uZK2gBKfSeEvIOQZ+Za6C8vi+2gQtD2fvtBWozVRqn1L6L5hSxq
         JyxCCEGm4IYQt6XxgNy0Zc+mXjcsOByGDuuIIwIwJCfuYQDVFB/wHqNoyBk6b/SVjcX/
         AUQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1Q9sfmmxtwO0d5Gh80ajE9jUJozFumMTB/vxMe9bUT3MN8FxO2Na8ubE5pLqsCq4Tw6n1fz6qUYFfQjg=@vger.kernel.org, AJvYcCVQYOvjTP0Yy0gA53ihX6ROVV45QBFxqoF2lSBxAPvLXAFox08jV8HoPH7qy+V5st+lEq/3duYhZ/JyDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yye4K1uXsPgjvp+0t8ZJ1hPr3w1RecACXlMf6CB9EUwqPv1AYGc
	9c7E4U/xEl/TIPp2cTD8C0WXyzb31CQ0L+/bY6dhAi9HPIr5eMBB
X-Gm-Gg: ASbGncsLNIefH+uJtRnrwEOhEsJAafKpzrsVhNqSXoBmnX/I1ab/spoWgMzgSQurT8t
	R0E+xI0A9fPGBHrO6Ficz84dEYCotApJi7M47xJuulav0mG0jdUFFRjvtZS7UmbeqnxpkV251vd
	3XccI155zp3G+3VZLaGVmwnRsk2vYyu8g9hQbeRhi/XsnuzUGyUQ5NlroqK6v57rBJFWNDqdTBe
	Qs3F4uptCplse7OK7jWvX2gLDq/i50BHiNfzjZw/je1q2dUTShJYXN2HxPJjQ05c5heAbRnlbJv
	C+RVdn09rmOwQFWOdw==
X-Google-Smtp-Source: AGHT+IFy2DKmv5AimZPDn79UVjPBJtoJqNpgKNKnT1JmYQ4gXVlOFt00P5a94eu6EJnw/XHRnqTPPQ==
X-Received: by 2002:a05:600c:a384:b0:439:88bb:d023 with SMTP id 5b1f17b1804b1-43988bbd481mr46336695e9.11.1739817573545;
        Mon, 17 Feb 2025 10:39:33 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43987088ecbsm28775975e9.31.2025.02.17.10.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 10:39:32 -0800 (PST)
Message-ID: <1fdfb9221f1cab04881d91e1e2d56ba97054a580.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix memory crash in case arpmb command
 failed
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <arthur.simchaev@sandisk.com>, martin.petersen@oracle.com
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
 beanhuo@micron.com,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, bvanassche@acm.org
Date: Mon, 17 Feb 2025 19:39:30 +0100
In-Reply-To: <20250217164330.245612-1-arthur.simchaev@sandisk.com>
References: <20250217164330.245612-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-02-17 at 18:43 +0200, Arthur Simchaev wrote:
> In case the device doesn't support arpmb, the kernel get memory crash
> due to copy user data in bsg_transport_sg_io_fn level. So in case
> ufshcd_send_bsg_uic_cmd returned error, do not change the job's
> reply_len.
>=20
> Memory crash backtrace:
> 3,1290,531166405,-;ufshcd 0000:00:12.5: ARPMB OP failed: error code -
> 22


It is Advanced RPMB access and not related to the UIC command,=C2=A0

If the deivce didn't support advanced rpmb, got return -EINVAL(-22).=C2=A0

In this case, in bsg_transport_sg_io_fn,=C2=A0

if (job->result < 0) {
	job->reply_len =3D sizeof(u32);=20

then:

 int len =3D min(hdr->max_response_len, job->reply_len);=20
	if (copy_to_user(uptr64(hdr->response), job->reply, len))


It looks like you didn't initialize the correct response buffer from
user space.

Could you rephrase your commit message, add a Fixes tag, and resubmit?


Kind regards,
Bean
