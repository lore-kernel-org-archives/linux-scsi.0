Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F5E19F475;
	Wed,  4 Dec 2024 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316660; cv=none; b=YXYV1ZyDvZ+lAAWFYZx6HfL/1R/z5vDZYA0stMg+TikRfB3N4p6mxdu/iWaXhdHpNq2sKEIGveWNbcJ9IH4hG+vjUFyCuDBF/KbUBKUdZDfXhOdZZm8SZRVHttRjmlB+H4y+mA4iKya6swWohEGFwyn/jOoJ+Mk93GrGBVUHXwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316660; c=relaxed/simple;
	bh=NDhsbahJD+yAj12Er2ie34fi2x/7kfX4pIrDSW6gQpA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eUeAnHe1AUAAm8PCRlTTC+P+CtJYdaebfAFkVPIdOFU/VpDUhvfH7P4kT/mk+yv6RIKmwqrcED85YS35Wjw6HzPoY2iET6Pg2Rw+OZ+PHqoIJOvo3oPWxdWTZ+C2D2tJ0XDA107rx2E1El8xvqi1xwE9RNQXQQ1TTcRBqc3t2SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IMpvMVG2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IMpvMVG2"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4349cc45219so61017085e9.3;
        Wed, 04 Dec 2024 04:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733316657; x=1733921457; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NDhsbahJD+yAj12Er2ie34fi2x/7kfX4pIrDSW6gQpA=;
        b=IMpvMVG24VazuNCIAv/pJgJ71EZPxV/jViQiezWk17M0v0YLRDmhbYXsMP0RqdL2gS
         eKq8eZUClNSFSxbEbRaDgD/0u4K76NN4kMuwU/HrxW+WGgHMFFyHqZXk2XCXym/5iOQG
         EwNUOYd5tW+WYpkNDwRpPb4fr0BzQG58TnZhVRMNLPTzMSMMhVAz9EGBSguR+4k5llxb
         vDODDfyo6XRlSlTRFpWPNhYgfyvienL/iA4CX5ZfVOQSjEJKUbDWAVqoi3F05wzbZG8g
         v1MLEH2tQcOU8tq6MlX6V5WDiEDEKPHjZHMkDNzDWdxv33SVERnXeJKRWfkK0KZhYT7e
         V8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316657; x=1733921457;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NDhsbahJD+yAj12Er2ie34fi2x/7kfX4pIrDSW6gQpA=;
        b=DMgB3f1Eo7sEs0OoYJoCvK2A64dbOnPqec7Xx2FYDT28rn1996pmBeLcUMOi8xuK3X
         +jMMEdIRzvKHpHJkzxnghBkLQVgWl/ylYAe0QyUBQ+0OZaMQTK3UowiM3ko/n2CIvdQn
         uxjO0f8c/275xYykJ5xa74Vg1g6CZEwc0wLUJir20mSeAHthPanN3KZhhtN7S15i1sVG
         /kiT99svsEJFoih2RTuDn4rnFXcsbcK5coJZS59FjohkdVqMBv9hil5Kzcg6HjipAVss
         vOG6QJorOztzQi27b+vjotzuQnhB9QS0Y+Oz4NvDvf+E+DOzAtTDSRym+0GjJXywaqU0
         M+xg==
X-Forwarded-Encrypted: i=1; AJvYcCV1z+zqC8nC2ewd3SVzazCTTL6PWl/dx9k8KvLVINajv2Wrr+Ynsj/3bCl1V720Nd+NY3FccT5fQJQaa5o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5yycWab7gflDzkrGvI9GjIJ+GZoUIenL9KDb+lFQ7N9OxW5cv
	mVIhqYbDhLtEWk0PKO6cqeV2gkVn4OQIjzsOK+VDOJIdqCUVOIzX
X-Gm-Gg: ASbGncvFjAco5IK2OcHiRMVJXty1tMhOpIrAp77tv9IacKLj5N191WGCoFieq7ove7S
	xpvHt3CpHAH8+RPZ7ExXILZOp8knlMsrA7096e1LJSQWkA0P1g6TAr7grhV350LREicPYKjcgdK
	Db7/ATZYrFu5u0jddqHwPT8wjAHe/97Oecq9exGUsU6+rrfLqhrA1kw3q9hoCCmF6dWj+JxukLd
	BQ67WCu5v2jcccpt+AfLXP/e0cbBHZI/4AJN3x9ZG2HyO+O05JN
X-Google-Smtp-Source: AGHT+IFwWT7Pst+/G/eyPLR91512VqyL2tkvgnSgk8cxtOg8lJAvE8NQrhAfBubxyWStcdidVl8iOw==
X-Received: by 2002:a05:6000:4024:b0:385:e94d:b152 with SMTP id ffacd0b85a97d-385fd433427mr5598869f8f.54.1733316656957;
        Wed, 04 Dec 2024 04:50:56 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d5280fc4sm23624105e9.24.2024.12.04.04.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 04:50:56 -0800 (PST)
Message-ID: <b1e4207586a7b6bc1dbaef69627eb5c6b8e956db.camel@gmail.com>
Subject: Re: [PATCH] scsi:ufs:core: update compl_time_stamp_local_clock
 after complete a cqe
From: Bean Huo <huobean@gmail.com>
To: liuderong@oppo.com, alim.akhtar@samsung.com, avri.altman@wdc.com, 
	bvanassche@acm.org, James.Bottomley@HansenPartnership.com, 
	martin.petersen@oracle.com, peter.wang@mediatek.com, 
	manivannan.sadhasivam@linaro.org, ahalaney@redhat.com, beanhuo@micron.com, 
	quic_mnaresh@quicinc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 04 Dec 2024 13:50:55 +0100
In-Reply-To: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
References: <1733313004-350420-1-git-send-email-liuderong@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-12-04 at 19:50 +0800, liuderong@oppo.com wrote:
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 6a26853..bd70fe1 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5519,6 +5519,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba,
> int task_tag,
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lrbp =3D &hba->lrb[task_t=
ag];
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lrbp->compl_time_stamp =
=3D ktime_get();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lrbp->compl_time_stamp_local_c=
lock =3D local_clock();

probably, we should change lrbp->compl_time_stamp =3D ktime_get(); to
lrbp->compl_time_stamp =3D local_clock(); also, the name of
compl_time_stamp_local_clock, is so long, should be shorter.=20


but the patch is ok to me:

Reviewed-by: Bean Huo <beanhuo@micron.com>
