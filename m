Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3A32417C7;
	Fri,  7 Feb 2025 12:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738930192; cv=none; b=JWb5tEcTLJ5v0npHYzay1zW+8DzaNPihQSbxW3Lqm41wJdp8uW7dNoKUWGJFQ64t5X7uocXBHsWUeWzooT1TIXEI/z/jMj4ijC5W6A8u2G6cq4glQMW4+MVQRhFfV23bmwoMKxnosCGNNl0Ab0wj0W90MQ4jkQ/sxklQxFXF+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738930192; c=relaxed/simple;
	bh=4pF195jRI8mjpC7aYEb7qPcoCnajxFj1HhZA4jePVNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sglkkh8GmPbwKG01nzDEDRb36iqG8RmpPh8Wb8I4qeYCdgFmekxcHH67TH0LN8LDO1Vkzuz5gZrf/sQHvjQ1I+gH90wbLLgBhJq8OA1woaf57y9mQrYuE/tztCf13945NO1rtIkOQaqRcXbH3kvzuILwadLQGFH7CVmwJ2miOyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHP+d+9O; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHP+d+9O"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab6fb1851d4so403189266b.0;
        Fri, 07 Feb 2025 04:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738930189; x=1739534989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pF195jRI8mjpC7aYEb7qPcoCnajxFj1HhZA4jePVNk=;
        b=bHP+d+9OlhLgJzYDcAPWbTl4vYBzYvSSaYJnJaBgeAiieAKYIXN26K4K+ioaOOjAvA
         PkZJ3BSIEkI7j4IylcEihsFrghUAKFRoabcJn4pKBQC3WTbPEX0kzcapyPEHQZu7e+85
         FNyae9MDnOo0MVKNRta6uWu0aJ0qzkbffUGz0gAVrpSxlo29nSZct2XUU54qkLHI2lRb
         cIDXnxTcFKVjLPZ0ne5Z2vwFGdL5JKZqmu+a/mk7FVNUleEggW4k7ZuGUgp5IDcuhOgY
         0f+F2Rr9dSlivECG2SLwadAngKqZUutZNbumRjLGGPuyovBxCbJyFExvu0G8EbppQFUq
         jk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738930189; x=1739534989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4pF195jRI8mjpC7aYEb7qPcoCnajxFj1HhZA4jePVNk=;
        b=uDWcpYuMcANRmyEnjVdOS60OPzfjxuNM5a77TfkH0/1ZWx0gt8zgBq2TBZLY5kT8oX
         5YxPplj2U7WCxoI37KeDHH3anjdP2Ba+C8ljlKY9N0sbCMbdnKVeaNQ4q2lNvG5b52hK
         cu+0mEufxbtkTPAIM1gl6uSBZcATsyDXwpy83E7YbGzPz9S/GuoqXx6ZGAyvSPLwzWKJ
         i3ldvZV3hVgT+N6PRXVGolW4bME9FZaPQr0oVK4h7vVCIcxw+7cwfQmUfR2lG/tc4jom
         zF/9jHA4WRvEb9cgWrBkajvyK/fKCFcHzK6QVSRGvQvRqpPpJ5ypMsr5ATnhnuyvxkdP
         ISxg==
X-Forwarded-Encrypted: i=1; AJvYcCWNCsH/rflWkClSzplMYl/5HTpelOEADYEaaOj1RRGJIoYp1mePi1H2ICjBuazQQBREWEAe909GtQnD9A==@vger.kernel.org, AJvYcCWwy3gL19u+CM1Xm9v4yA90DdyvSvB5W24oSpoTAkJkAnKfWxqnTUZidBpMvs1FOzSZZNrYjMAGfDh9dOvMbxk=@vger.kernel.org, AJvYcCX3qPyWl9WhtakavAUhBMoQWqh2tvZGEmMe3/iwH1czEOBrCrtY5BCcKZ7ZwLL6iqA5JBWqrKeY7pUAT72M@vger.kernel.org, AJvYcCXLkuwrzhtpDApN/DtgxWpl+zdR8IJ02tS1OiHw1cR4ruCsDixgqdPEBW2MdmQ5FMlDxa+LwNLaPindZyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxuteSjPyxikm6/KYPZABAWF1eeqGUx1XZ/MwYsWE98ihPRON7
	uyh7OZNyZL2Afz5TPx2+Zp2Nq+oqeMYo7j/poBepp5dPjeShwFeVZR7upKtz+MH7GiE8xdMt82T
	NMNNZP6CDZU1Jd6DstMcASEKXXrs=
X-Gm-Gg: ASbGncu+MlznLE1OJdTV76sxej78DJ2cZvTHEN/SSlP3Xyki4y9pfHsn3x2mKT/YRD9
	S1bh1wB7rjmG7jhZL43WGq/5Ow3OklGH7ESyaE6VjZFPNZsbMKhQ35l1bav6XFiZJprFcFdoes0
	U=
X-Google-Smtp-Source: AGHT+IHrbiWskXPle5ImdwLhrdLRBq1l1ymqvuJ3iK9ve3uv7DBb+2jINGkUj60DkJxJ5t3LfE4k4WUHDMyRSckgp7U=
X-Received: by 2002:a17:906:7309:b0:ab7:6d48:10a9 with SMTP id
 a640c23a62f3a-ab76e88d3a0mr822173366b.8.1738930188495; Fri, 07 Feb 2025
 04:09:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250207005832.work.324-kees@kernel.org> <20250207010022.749952-6-kees@kernel.org>
 <b4f08d43-c421-4e8d-9bbb-c954c4472f8a@intel.com> <202502061835.F57547B@keescook>
In-Reply-To: <202502061835.F57547B@keescook>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 7 Feb 2025 14:09:12 +0200
X-Gm-Features: AWEUYZnChrRXXIJNdmCjHjynXFGSUufAJmxvP7Q8yY-4-DWvfhOKjUuhnQ7LHUg
Message-ID: <CAHp75Vf4R73_GMNvsEWd3nyUKM8UEP22=9umArVsHYOA=dycWg@mail.gmail.com>
Subject: Re: [PATCH 06/10] x86/tdx: Mark message.str as nonstring
To: Kees Cook <kees@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Shevchenko <andy@kernel.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, 
	Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Sven Eckelmann <sven@narfation.org>, Tadeusz Struk <tadeusz.struk@linaro.org>, 
	kernel test robot <lkp@intel.com>, Erick Archer <erick.archer@outlook.com>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, linux-kernel@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	mpi3mr-linuxdrv.pdl@broadcom.com, GR-QLogic-Storage-Upstream@marvell.com, 
	linux-hardening@vger.kernel.org, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 4:37=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
> On Thu, Feb 06, 2025 at 05:12:11PM -0800, Dave Hansen wrote:
> > On 2/6/25 17:00, Kees Cook wrote:

...

> > So, the patch itself makes sense. But it does end up looking kinda
> > funky. We call it a "str"ing and then annotate it as not a string.
>
> Yeah, this is true all over the place. It's a string, just not a
> NUL-terminated string: *sob*

Maybe call it respectively, e.g., __nontermstr ?

--=20
With Best Regards,
Andy Shevchenko
