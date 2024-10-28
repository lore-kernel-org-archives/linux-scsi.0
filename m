Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E913F189B8D;
	Mon, 28 Oct 2024 11:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730116511; cv=none; b=gL0NlAe21JnTFQcXpfPtdCFrf8i7QkmTSOzDaq6xb5SiDsa6a3AaJU/YT84ygXxxBgWYL+aedy8N1KMUAR6XmvAXTyRGsz17i14nciXPkMmDHxxGtXFja3sQbzip+wdLn6IXqYReJQkXbRG2nQdPdp1x+jQYH1caiUQOhVR8JE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730116511; c=relaxed/simple;
	bh=UFyy7O9vlPF1Xk8+f0lsUcEsYOVgPX4xqnBE9k9kgrI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PUCKggStnEPC4Pl9fhwl0BMij1wtYA6awUf7+3o3Pal/8M/rczpL9uiDf0x7cf88XlPj/l2et9/O2qJjGj77urkZ6Hgx5Vh7oPmUkZKoNrgMjP8ArSy0NA8S0yTAgyvyDQgsiIBkUPFyXi7m2lZSZ1khUvm7XAl4bIUzadUGtB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iqNO0lGP; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iqNO0lGP"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539fb49c64aso6889942e87.0;
        Mon, 28 Oct 2024 04:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730116508; x=1730721308; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UFyy7O9vlPF1Xk8+f0lsUcEsYOVgPX4xqnBE9k9kgrI=;
        b=iqNO0lGPjlRAEgnPsdGxiy8nmVzerBpO+PK8GCtpiwPT7+J/OeCrQGszTyVdY7Pebj
         iWNXymGHl/L3SggwKu4OtEP2E+L+4lydRtv8fQ97X+ecsGNVu4As6mSIYHhBuCaXvehL
         6FMLUHq34scTfA658hSrxnDJs18axiJv0r3/lDAxpaiHwbGzCs+LFsocnurCY1Fomqsv
         6kytWD0foU04ohMGQYOayHIbYpf63DZMtYeoLbhdKtjcNKaYn3+ItYBQbIXw8oOykwh9
         9G6oSRundotnLQWKfjt6YFivxJGLn3xLH4pvyzoOJRJaKJDowD8oV0YvZUcC9iLhdcKa
         Q4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730116508; x=1730721308;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UFyy7O9vlPF1Xk8+f0lsUcEsYOVgPX4xqnBE9k9kgrI=;
        b=vHaVwMpz+x0C6zFCSYAXdJz+VmkZMNBzw1+3lFRHjzdbVImXtqvTt7xIDREpDlxW7P
         9O6bF941nWcXdCP4sP8neLo13/ikmdDcqWv/ahkTuqbl1Gqfh0tQ2fvcblaVDiKeV/bV
         KFcpngMyA+7yLJBv3oWzQoTrQHdU6TguK9NsXyPM3fXdjwbdoM/1cW2gYriLQuCGTM2S
         x0jDpTPFKaC1TB9Ovlx7jZCPwiDgc7tLW9y3felNzS6IKTvXirOEC/ONCqr18asgXTzU
         bHJ449isCzHNNJmxlbrwtCYQJnQeNR41bG9zjA5ks76MC+eNrfc0Qv22ZfCH6mkuA347
         Ol0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWu9SgHqTu7FDy9ZBgavk/KhYq2qTKN8Cmusl8Zvv6xFJH1QthcY2atZsqXF3Uvo1QWQ98vflmAoRueCCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYmFFym0Kwx5RgZDOThl9m65zix+dueUqASYc6ZtjFyG1D+Sdl
	8tfY2XLgcqJA8TTcqdUBt6KrDsJ1mRYCp4gP0UeeDqCO8AGlXi/Y
X-Google-Smtp-Source: AGHT+IEOIZIw97yqmYXzvWBjVOmNLf8XbVJjEBhgWtqSvFNNa7kWoRSe+i8esmpIhpDvXO4mNxaJaQ==
X-Received: by 2002:a05:6512:b8d:b0:539:89a8:600f with SMTP id 2adb3069b0e04-53b348cfdefmr5009912e87.23.1730116507807;
        Mon, 28 Oct 2024 04:55:07 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1f298324sm370492666b.128.2024.10.28.04.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 04:55:07 -0700 (PDT)
Message-ID: <ad06abd927fa002033f6744a59ee3dda10beac2b.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Replace deprecated PCI functions
From: Bean Huo <huobean@gmail.com>
To: Philipp Stanner <pstanner@redhat.com>, Pedro Sousa
 <pedrom.sousa@synopsys.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Minwoo
 Im <minwoo.im@samsung.com>, Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Oct 2024 12:55:05 +0100
In-Reply-To: <20241028102428.23118-2-pstanner@redhat.com>
References: <20241028102428.23118-2-pstanner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-10-28 at 11:24 +0100, Philipp Stanner wrote:
> pcim_iomap_regions() and pcim_iomap_table() have been deprecated in
> commit e354bb84a4c1 ("PCI: Deprecate pcim_iomap_table(),
> pcim_iomap_regions_request_all()").
>=20
> Replace these functions with pcim_iomap_region().
>=20
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

