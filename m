Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7240E15A848;
	Fri,  9 Aug 2024 11:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723203598; cv=none; b=VAi3aIfIkgQUiSKWsZVdSW7nkoH+1RbKaRRV62+aavr5afo6OA1sspoTEQ5ktC1lzOmkZi7HQpl2+llQJYhiLUEP+mkOqmXavTwwiUyCoasOZZq6wWUGq0CC6zh/kp4aWvvYOVKzsHSCtq9EQ+F4G24kJYL9NlDKMwa6ei2T4Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723203598; c=relaxed/simple;
	bh=jacH4g8X1470Ls1GkGob9da4zkfSsP9NUWhYDM+M1fI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RcvyqWmDrHOJjOR6rMJhnEOxYxib55kUi8SC/sRdL1TKnwEGYAzZoMxf/ON2gjeGQfojlAWkMXB6aSVC7+LzvQgEDaZDhl9n2g+JPgUlvWJB6zLul/eXKVUCSCR/biwmebixSdS9gKSW/wzT42y8gqrfErI5umU5J1M/FZ8I0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eb0y0UQD; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eb0y0UQD"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7abe5aa9d5so255301366b.1;
        Fri, 09 Aug 2024 04:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723203595; x=1723808395; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jacH4g8X1470Ls1GkGob9da4zkfSsP9NUWhYDM+M1fI=;
        b=Eb0y0UQD+eSIOex7C+WK83vcR9gso2o0Fss29j3G8CmTWOaCYn35wACnvqtelO5BDL
         Lz4P3xKkRnOQBLFUhOQXhSuSSPdtCzmcyRbSuzOXM3MUEZaWb6kAIeu3aAsEpw/krPZn
         Gmar8OeEMfjEJj4LQ753Mf5SY8m6D6zioaQZlRQUY/oRMXVBIP9KevjGrU8wz7Mae0Ze
         PNuY4s4upRXjgIH7MvpgRBLGGykLf3vv5O1HsZViIGx1HAyN+tmyr8Ct0OvejLOUv9GP
         lRuXkUAIMZQgSy5bjrdkyfDeTctd3QH21ZFSxLPrcbCpwlLzvg9JnKiK+Qj3eA8LdOQU
         UnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723203595; x=1723808395;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jacH4g8X1470Ls1GkGob9da4zkfSsP9NUWhYDM+M1fI=;
        b=Of3IGGFIafG3a8n51xP3kESF9+XaFB0KhQpuR6ZYNQPKittCUsDKz32QG+7EUSrpTO
         WuEFnWhxdK5KyxuT2ljdtNPg7gAWSnP6myAhpgvwe96qw12LIzKHb3MXDr2UP5M7nyWV
         mmZnf3aegGyumTW9aKFnkCn8H8+5rriKYKmjb/CbmzqriQy4wqQtoDRiMy329bhwnRjL
         NWeSO+0/2eyZiv+20bCmhvPQMIZpQRfm+DmZacrJnb1kc7lhfId8QMTk9YCGRjOByJlj
         84Zg3NbApHUqZJZbv9AwK+1zIfiOebNFbEFSa9fLaMshZlr36yxHxibCwT4EGFbBqpJp
         a1qw==
X-Forwarded-Encrypted: i=1; AJvYcCXAJuriTnnpA/Sv4bw5Wopfn2IWIJAgAYMqlYhACruW/1oEkQhIQzBpyMeLadLcHZrSb9w2bcVDTxCbUxz0RPVW5pev6LauzrC5zqCL
X-Gm-Message-State: AOJu0YxSEVkafs11KnaKjFdgDhFzQXS6/Nt2RedzcjYwDmaFrQNuO1T/
	zLgwxsCWBd0Urzh9seRYqyCEKLZyGuwcO4nk0SOnZtn1v1DwYVvg
X-Google-Smtp-Source: AGHT+IFPJL5iZav3IHuigCq1KqRQQC+2gBj6ChDGqs1mdfBFK/0Ujg80SBkx6z/SOSlMgHUUF+a2gA==
X-Received: by 2002:a17:907:c88c:b0:a7a:aa35:408c with SMTP id a640c23a62f3a-a80aa54fc61mr103900166b.8.1723203594281;
        Fri, 09 Aug 2024 04:39:54 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9ec6b07sm823655866b.202.2024.08.09.04.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 04:39:53 -0700 (PDT)
Message-ID: <150094a0841219d1d08c21eac1acf099402fc4fd.camel@gmail.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add HCI capabilities sysfs group
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>, Keoseong Park <keosung.park@samsung.com>
Date: Fri, 09 Aug 2024 13:39:51 +0200
In-Reply-To: <20240809072331.2483196-3-avri.altman@wdc.com>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
	 <20240809072331.2483196-3-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-08-09 at 10:23 +0300, Avri Altman wrote:
> The standard register map of UFSHCI is comprised of several groups.=C2=A0
> The
> first group (starting from offset 0x00), is the host capabilities
> group.
> It contains some interesting information, that otherwise is not
> available, e.g. the UFS version of the platform etc.
>=20
> Reviewed-by: Keoseong Park <keosung.park@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

