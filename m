Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE41CB317;
	Fri,  1 Nov 2024 21:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495004; cv=none; b=N8Isx9uyYRHBKBrVheCfiGEckb/e8BX9q8M3bGD640z99tyQ5orpZGG1Lvh6VxLcoV3f+bWcG5Ldg2amixD7s5r18A6brMOszIGzZEJyD5mwH2bta6GoV3IRPf8xp/UoXoIdWPtcO8Gxrv/xSejnwxcUZ+LTBVJJF16EXM0Yvfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495004; c=relaxed/simple;
	bh=aJKbPTR8XisocNACIOvG4GnrKDw3LKtPktp2+r6V6dQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MLBOrJXIOKOt6tyDjKwreOedYelqBivdL/ySTwgT6l8MSKYUbj/SWZyUl64JNh5jeZrqGlNiMBz0PZRvcCYm/JR9nHQwuI3UbeRVEEOSxz6YR0yDs4/teVDU6qY+m8MdqgRZFemOxu6ec6wlWwYkWR0TfJX4Z1h+rgAKY9LHeBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePZKPU1U; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePZKPU1U"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c95a962c2bso3051847a12.2;
        Fri, 01 Nov 2024 14:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730495000; x=1731099800; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aJKbPTR8XisocNACIOvG4GnrKDw3LKtPktp2+r6V6dQ=;
        b=ePZKPU1Uvvt/s/1DlOubqZhm4d4woAWbZfdSz9aKBqPD0cKyd/85pKYcWTPvb8X+Ia
         dFJCRSLltuTVVoH5cArnEsAd//vdz0UB8tmtrrglFRRN5A3vL3fzCJYNgMpCQugGZD9Q
         PwanKouf8ZFyi5hKNQ6YPza4dGRoNxodL1ux+oJXykmMn1TXGSKCawlo/NA3RMBdgxHO
         84vrDI2mJDMO9IwNuy/AhTzzByarPJQRINgF7CPgnxvHqv37MU3wchu7MWhuGqix5tIY
         WkX7nVXyIkEBaHkw5gx7+GhIiIcA651uvsg7O6nX5s7xiGJE6ybVG4rRnSbhTUpb2TCf
         P2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495000; x=1731099800;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aJKbPTR8XisocNACIOvG4GnrKDw3LKtPktp2+r6V6dQ=;
        b=DsYwzBFfaOKnUpz75yjKllxky6iy6+nPi7/7d7OpGh3+B8+DKqt2/v1vvAdTwlWpAN
         inG3aFWTvTpaeTlNu8IXMVGsWJVUqhXJ31FIvkFSo/tTDnDY+TbAGefnkR6Y3FWtqRLM
         HAkmBwo6A2UpwY5I28BH35S2iawxxNvK5i86nwIzOdpvvu+oeCAtebImE2v+AAJpCdK/
         GUBtzLkUHkStTza6+EVXSC4appa/9TfIhU8093oZ2ANxYRnPIGWmjYIJtqC0+kOuq/L7
         eJV4Ib3XQEG3wrvOAQfcY9jAW+U/czd3ly1XQPWyRtJCrYcSx4hLaspfCDksWNF4kbvC
         KA9w==
X-Forwarded-Encrypted: i=1; AJvYcCWzTJwuikzftvK+qDcKUhgkK6GvCnUUemc87Orf8eIEo7g3otG5gN1tQz0RZ6AmAYosqTEamro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXD/29ffYgcx41bbYfrJ8Mbi4/Qt34NzRKjZr3sgmt8yVSKCvx
	G/0dISVpY7yelZkD+Y8jBYtxsxEF36ECwPk70rCEU3GLuTShI37oKBjlEw==
X-Google-Smtp-Source: AGHT+IERfLGsygYakLKvSsOXCS8BAQ/CmUEJ6VRZreUzoexZ1EoubHo014Cp8hL1EXXeii3Jo4aNGA==
X-Received: by 2002:a17:907:3fa9:b0:a9a:3f9d:62f8 with SMTP id a640c23a62f3a-a9e508d3430mr683678066b.19.1730494999688;
        Fri, 01 Nov 2024 14:03:19 -0700 (PDT)
Received: from p200300c5871cff95348cbecdbb312bd0.dip0.t-ipconnect.de (p200300c5871cff95348cbecdbb312bd0.dip0.t-ipconnect.de. [2003:c5:871c:ff95:348c:becd:bb31:2bd0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564941d5sm229879366b.19.2024.11.01.14.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 14:03:19 -0700 (PDT)
Message-ID: <9df5b676832dfcdac8e9fe39f8505076318a3ae7.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
From: Bean Huo <huobean@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>, 
 Bean Huo <beanhuo@micron.com>, stable@vger.kernel.org, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
 <peter.wang@mediatek.com>,  Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>, Maramaina Naresh
 <quic_mnaresh@quicinc.com>, Mike Bi <mikebi@micron.com>, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>, Luca Porzio
 <lporzio@micron.com>
Date: Fri, 01 Nov 2024 22:03:18 +0100
In-Reply-To: <20241031212632.2799127-1-bvanassche@acm.org>
References: <20241031212632.2799127-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-10-31 at 14:26 -0700, Bart Van Assche wrote:
> The RTC update work involves runtime resuming the UFS controller.
> Hence,
> only start the RTC update work after runtime power management in the
> UFS
> driver has been fully initialized. This patch fixes the following
> kernel
> crash:
>=20
> Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
> Workqueue: events ufshcd_rtc_work
> Call trace:
> =C2=A0_raw_spin_lock_irqsave+0x34/0x8c (P)
> =C2=A0pm_runtime_get_if_active+0x24/0x9c (L)
> =C2=A0pm_runtime_get_if_active+0x24/0x9c
> =C2=A0ufshcd_rtc_work+0x138/0x1b4
> =C2=A0process_one_work+0x148/0x288
> =C2=A0worker_thread+0x2cc/0x3d4
> =C2=A0kthread+0x110/0x114
> =C2=A0ret_from_fork+0x10/0x20
>=20
> Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
> Closes:
> https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@l=
inaro.org/
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>


Reviewed-by: Bean Huo <beanhuo@micron.com>
