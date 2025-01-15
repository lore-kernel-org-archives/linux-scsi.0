Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E898632E;
	Wed, 15 Jan 2025 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736952344; cv=none; b=fRIVfEO1o+N7DPAkAivzBp1R4PYx8+ovk3BRcK243AWYk4aLyKioQxraXPchZX3SFcLppV+aSmlBJ/vTIGf1mUOQ/s3xw7sA/hNaMHp/AXrEuHyWz3oaz6HkZvKGdjTWUfLiLWY0gQF6FIt/W6/mA0Plv2nnlRK8/l2ewvecIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736952344; c=relaxed/simple;
	bh=xDcaFirZd2OzqeozTaAS0Y1wGIC2GLBAnw4EoBR1Zxw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nugg6ZavN6CdmJtr9AdJAxC+7fELmRvLKMFv8xS3bJc/FraHZOyaTtOMX8BRzSNkRffe16m2SBu+qJjdp4EVLr+fD8kAGEXeSOuCbdkqopA8WMQ6FOLrFWrWEtIVbbPl2tM0cm72Ygt1bEAxbYTto67RXGIdFq9gabOR5krfGBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOoJhM8e; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOoJhM8e"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaec111762bso1226006066b.2;
        Wed, 15 Jan 2025 06:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736952341; x=1737557141; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xDcaFirZd2OzqeozTaAS0Y1wGIC2GLBAnw4EoBR1Zxw=;
        b=QOoJhM8ep+KF/JCUTvoffdnpEJv6seYUM8qJv1XVWgrvUkuaanRiZZke5sZrLM1P22
         y0Bn2m1UDhW+aFX4hB5mlzYZIgzOSwLGVuTtoaQ2eFXiWX9/EBFn0I2FaD5rRwdm7zON
         CyHErhTLJZca2OKZV3ESH+hvjkMm9J4WkXdB+k9DaQ9HEOsO1L4u608VBng4hOgipdoM
         rKCDosV9aAIniKogkouvKSvrRjoKK05tVdjzc3VeZrIKI0EZtNRi/Zjdo+FNWrCIk3jt
         Wf0T0IhVIyU5Sf6qWmTYCGahtqGU/Aa1+iALTHroNocmcn3EVDRnG9Qp58euyMsMegJr
         4LtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736952341; x=1737557141;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xDcaFirZd2OzqeozTaAS0Y1wGIC2GLBAnw4EoBR1Zxw=;
        b=bkB5oAEIzXyIfO1GpEbDZkMtAsuav85NlZ33kmulORusEZ7jZgNGRutCo6O7A/s5pN
         DkoCL8R7getUqe95UhbFwyuLfWun5zNDnVtm9LMxuTRkSxOiXDkcPn2MFe5xNHCOFNX1
         BgUdGIt+t+LeicHYqBUkRim+QSQ6+PRAYAVmBe1Md9KzCpY2ndyUulBXegUHIxnUeXJv
         vrkbeHdPn703dNQKuKUdayggIiKXuN82U175G2lYYYSyM116bCPrbdzhvxLfoClyOPho
         hSGDjav7FgrhGm6wmCEfW5qHkFsoaQXexWFE8hojNXYXHtSSvlMGNdlphhJveJWHKljQ
         oeTg==
X-Forwarded-Encrypted: i=1; AJvYcCUbCmrr64/VuoDfsnzKK9FptV6rRwC+vSzrP+7rq58mx5SJ1XUwKMha4iBefhFeAqsHoV2YuQgYZmFNVYM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0YKTS+HVfREkZetUG7NkMpV8a+fZoH+M+y2DCC7kWSozf7qAs
	xLKuKXN5nSJbnzKAGOCMYUnXQz9eun03Ag/ItpNLErtUemF9KRBT
X-Gm-Gg: ASbGnctNP+wL8yHDZbY5WmlNIjXra8p18yq/g5PWq0NA95JfJRJPrGyjFJu/WILx8ZO
	fPnqrw0nErr2UiX1cukoGzc3KaWmd1sGmk5kN+dUFQQhigV9f3wlsnJrTlYBqnLIYFVKj64a0Rs
	V7BoQr//7OUZ0erAgFBOc+nKSq+7HuMbLFIrS86ELg46r05raop1wernRqnFDj8DlC8Gt3cdrpt
	rcxZ6ejKyqkESgcP2NyXmwBy7wGPJbAM3Jjuqt/UbaM7k6kea+YDF3UovY=
X-Google-Smtp-Source: AGHT+IG6GkwzVXueUea2nm8PdXconvgh2gXJIBdDW7hrjM8Ql3CS1eRyyEIgaF4s0VbKT+z7FywWWg==
X-Received: by 2002:a17:907:da5:b0:aac:431:4ee7 with SMTP id a640c23a62f3a-ab2ab6a8e99mr2832574766b.5.1736952340616;
        Wed, 15 Jan 2025 06:45:40 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2e8c753fdsm633545566b.184.2025.01.15.06.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 06:45:40 -0800 (PST)
Message-ID: <2639eb5c75da3f64877641dc0fc5babe5b9f30b4.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Simplify temperature exception
 event handling
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Guenter Roeck
	 <linux@roeck-us.net>, Bart Van Assche <bvanassche@acm.org>
Date: Wed, 15 Jan 2025 15:45:38 +0100
In-Reply-To: <20250114181205.153760-1-avri.altman@wdc.com>
References: <20250114181205.153760-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-01-14 at 20:12 +0200, Avri Altman wrote:
> This commit simplifies the temperature exception event handling by
> removing the `ufshcd_temp_exception_event_handler` function and
> directly
> calling `ufs_hwmon_notify_event` in the
> `ufshcd_exception_event_handler`
> function.
>=20
> The `ufshcd_temp_exception_event_handler` function contained a
> placeholder comment for platform vendors to add additional steps if
> required. However, since its introduction a few years ago, no vendor
> has
> added any additional steps. Therefore, the placeholder function is
> removed to streamline the code.
>=20
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
at the moment, removing this is ok.

Reviewed-by: Bean Huo <beanhuo@micron.com>
