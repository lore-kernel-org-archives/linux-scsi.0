Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF222566;
	Mon,  5 May 2025 05:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746421318; cv=none; b=BQeMQHbRvX6XS5sN2rKIE/xXHFwdnQ/xEEpy/hZfKtCOjVzDf0UtZm5kzXuMV4DAW2HZsF+nfoTEMBY88rFzgpfCbWnFAVvx0MF9+vJBx1g02fQT1SY6anKtJZ3jNM/hTJpM87gR6zkLmjaP+5MMcHk4EByC9tdhWVVpCkjjFv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746421318; c=relaxed/simple;
	bh=4ViT3LXt0QH4SnxsFtW5d7x+CtJEfR+/rZCNUoi7YPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XGnb460noRNDy/bV5TN9k2I4I+x3qRwRz1eWIS6cOmB2MsBwyxOd0izaiyjp5b+e5uECgiF0BhxcjGpclfaSNWMDkugE4ZPyPnvr88+akCTtgsfFKgPudNsZSb6cOo3yeXSeBx4pb62HZm2lG3kAPQucxuOHLR3FSKQXUE8SHYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPjWbMQs; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPjWbMQs"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-549b116321aso5036748e87.3;
        Sun, 04 May 2025 22:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746421314; x=1747026114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmpYbvBMI9AsI/UkcpVBkG0S1uIUBYKbf/+Nv3CsnRI=;
        b=UPjWbMQsj2/EbaHdG6qv62Dybnbo1UIEt7bs9ZCku0i43qiGXzijIQoKhiHekMmip0
         UQGBgae0l5N2rB6ZaFhUEQBCF3LR+dI7GzG3AsG9eqWaNlWcqU7RyoevnW4vz/x+cpPM
         yp+/U7YpsF6EkSgKeG9bfNhuv+o5tW00+RJbTqsHnsiG9/iNxwlxg+J15yLE3Tq2lMsE
         dwjOI14U8U1mKZAU4YNIk3k+Tg9uHrE03zl/pgBLrBqkLFYgyksiMdmCv+6GV5pNF+Mg
         AszLwpn5oDe4akpSB52HhM3MPQPap1ZPXvzQO0hGV1JUctud/XszC7bC7AtvThvQrHLg
         iQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746421314; x=1747026114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmpYbvBMI9AsI/UkcpVBkG0S1uIUBYKbf/+Nv3CsnRI=;
        b=w7uXDSK8XyzgvvGacQ7Qs/WC07Mqb42e+1eiAZFtVcahzQ/QKqIIycU8CTWls4R/z1
         TVhReYN0S8402lDg0/1WQybslM9QWXga3JmoS2722oOWEh8ZCeRqMIsZ8g8b8GtotC3X
         QsP1xKHGohZjDUNclYv1J9NHOIkldd1WZ+SMT0pIRZUiVltsZCzfZgDbC7dQqtYbJsrT
         rJ613AY2UJ9RDFEczqonekmpligT+SSyW3JUQoVBRvUT7ltqqm82IihC6CFZa/lCoUr9
         igUFQnkc/tYjrfjRrtiiaTeXPE3vQAqvPSddOdH3Pl4Ad1lflVkbNQArALK2S7AG3Y0H
         +0BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY6A8vImXJ8M0My98570BHHh+TVGBwzD/9QfST/m9YKQkaYm1QHPhIzsHbM1E5M6wALeS9dzud33v7XA==@vger.kernel.org, AJvYcCXx+07Ikss6tiPqLy+w53QCrecDUKT9B5EJLwaGyYFZ+5hAXAs90KCFdvwVGWzL7Ee1h0PU3MZ2A1mvxpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM+P9zyk+IF8zBqiflmMX5NzNgu9CGSJgNm8nW7bGG/UHFIaDr
	XimNW9V0vDVYHhGeu4kmqpBUHniWnPYYngQD7ncjDuAYGl81MSGp7e3mXrHXysdLg7OMQpubg/D
	Yd48E3rDOtICefueGemOygcw5YzU=
X-Gm-Gg: ASbGnctB8M2RmQGywNPv2R+9ZZmJIiC3fKexV4WWamfV9/kchqblgQXtYBe69SSyv5s
	qHu/vHaItjc94ix5TzTO2p93kFFAZX5yTtp/zvMdHlksNTOP7r/1TFF12ycfZBjIr1y8o15rcBa
	W8M5ifv26EKEdevx6gUTGzqA==
X-Google-Smtp-Source: AGHT+IHrGdAczLy6DFk9G7cF7f/Wjb6YJKaCJYrDZu9gByYO98eCuaSMEJtEDxszy3sjSOxmj1HT1u2CQg8duiL2Yoc=
X-Received: by 2002:a05:6512:3c9a:b0:549:39d8:51ef with SMTP id
 2adb3069b0e04-54f9efb8264mr1208726e87.6.1746421313939; Sun, 04 May 2025
 22:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430115926.6335-1-rand.sec96@gmail.com> <9028680b0d2b7c42d0e990bbdcd247d824e01153.camel@HansenPartnership.com>
In-Reply-To: <9028680b0d2b7c42d0e990bbdcd247d824e01153.camel@HansenPartnership.com>
From: Rand Deeb <rand.sec96@gmail.com>
Date: Mon, 5 May 2025 08:00:00 +0300
X-Gm-Features: ATxdqUE33cDra2cb2TPeDDpzcgpOt-sUHG0jdy6t6FDlIgtKanNZcP2zerypUIw
Message-ID: <CAN8dotmt91Kqwrz7e4O71opGX7gK802-WwXOPV1GkQB-KmRHDw@mail.gmail.com>
Subject: Re: [PATCH] scsi: NCR5380: Prevent potential out-of-bounds read in spi_print_msg()
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Finn Thain <fthain@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:NCR 5380 SCSI DRIVERS" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	deeb.rand@confident.ru, lvc-project@linuxtesting.org, 
	voskresenski.stanislav@confident.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 3:59=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2025-04-30 at 14:59 +0300, Rand Deeb wrote:
> > spi_print_msg() assumes that the input buffer is large enough to
> > contain the full SCSI message, including extended messages which may
> > access msg[2], msg[3], msg[7], and beyond based on message type.
>
> That's true because it's a generic function designed to work for all
> parallel card.  However, this card only a narrow non-HVD low frequency
> one, so it only really speaks a tiny subset of this (in particular it
> would never speak messages over 3 bytes).

Thank you for clarifying this. I wasn=E2=80=99t aware that the NCR5380 is s=
o
strictly limited in terms of message support.I assumed a more generic
scenario when applying defensive checks, without considering the practical
behavior of this specific hardware.

> > NCR5380_reselect() currently allocates a 3-byte buffer for 'msg'
> > and reads only a single byte from the SCSI bus before passing it to
> > spi_print_msg(), which can result in a potential out-of-bounds read
> > if the message is malformed or declares a longer length.

That makes sense. My initial assumption was that, even if unlikely, a
malformed or non-compliant message could theoretically appear. But I now
see that this isn=E2=80=99t realistic for these devices, and no evidence su=
ggests
this has ever occurred in the field.

> The reselect protocol *requires* the next message to be an identify.
> Since these cards and the devices they attack to are all decades old, I
> think if they were going to behave like this we'd have seen it by now.
>
> The bottom line is we don't add this type of thing to a device facing
> interface unless there's evidence of an actual negotiation problem.

Understood and I agree. Defensive programming without a known issue on
hardware-level interfaces introduces unnecessary complexity.

> You didn't test this, did you?  The above code instructs the card to
> wait for 16 bytes on reselection and abort if they aren't found ...

You=E2=80=99re absolutely right. I misjudged the effect of changing the rea=
d length.

Given this, I=E2=80=99ll drop the patch entirely, as there=E2=80=99s no act=
ual problem to
fix. The intent was only to silence static analysis tools, but I now
realize this isn=E2=80=99t a valid justification for modifying a stable har=
dware-
facing path.

Thanks again for the review and your insights.

Best regards,
Rand Deeb

On Wed, Apr 30, 2025 at 3:59=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2025-04-30 at 14:59 +0300, Rand Deeb wrote:
> > spi_print_msg() assumes that the input buffer is large enough to
> > contain the full SCSI message, including extended messages which may
> > access msg[2], msg[3], msg[7], and beyond based on message type.
>
> That's true because it's a generic function designed to work for all
> parallel card.  However, this card only a narrow non-HVD low frequency
> one, so it only really speaks a tiny subset of this (in particular it
> would never speak messages over 3 bytes).
>
> > NCR5380_reselect() currently allocates a 3-byte buffer for 'msg'
> > and reads only a single byte from the SCSI bus before passing it to
> > spi_print_msg(), which can result in a potential out-of-bounds read
> > if the message is malformed or declares a longer length.
>
> The reselect protocol *requires* the next message to be an identify.
> Since these cards and the devices they attack to are all decades old, I
> think if they were going to behave like this we'd have seen it by now.
>
> The bottom line is we don't add this type of thing to a device facing
> interface unless there's evidence of an actual negotiation problem.
>
> [...]
> > @@ -2084,7 +2084,7 @@ static void NCR5380_reselect(struct Scsi_Host
> > *instance)
> >       msg[0] =3D NCR5380_read(CURRENT_SCSI_DATA_REG);
> >  #else
> >       {
> > -             int len =3D 1;
> > +             int len =3D sizeof(msg);
>
> You didn't test this, did you?  The above code instructs the card to
> wait for 16 bytes on reselection and abort if they aren't found ...
> i.e. every reselection now aborts because the device is only sending a
> one byte message.
>
> Regards,
>
> James
>
