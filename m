Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A439FC5
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 22:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UJ9CSk+Z"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40e62979d41so6386685e9.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705013656; x=1705618456; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bl2EO7yezYiVPGfmE+e0KG7KvJAbfV77M002tDc+A1A=;
        b=UJ9CSk+ZxcFgubqeEJdMZTZUDkmIpNsjC8jZxoqDFOhpetxzaOXoCbLC63VmGg5+yp
         XottLrR4OShrSbG8WbK/068db0LiSF4R2BSNio+Cew2Jfp18NYjUxutKN7d5s1ihWJsf
         QVXv6uE0Xey6hhQSe/E8l2VJFroDqwPiPScS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705013656; x=1705618456;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bl2EO7yezYiVPGfmE+e0KG7KvJAbfV77M002tDc+A1A=;
        b=gUtY+0JOBii2PbdpdWf3zjNfHxL1wOrQh/uKn6LjlXezB0NPwgISh/ASKFv9TKd7oU
         yCJJw9X+Uo0wqkeN7MBQTVu1i5PWy8v4p9GAzPb9bY3U5436bnUv3IPloNCTHrliva0W
         371R2ppHfE1FboUWttFSyYtaJ8QLCc53DjWcc/uOvcGhrA/IVnc+yRG0M9Cg/PRQTBX5
         5rFSQxUJoCuHIGEaQT+gF6PAK/WfuiQr4W0PM3/6MAUvx0uxuBdX5kDkEi/C489JnqNe
         Pqu78/SLqCjMuTYWBiotK7y9Pc4TwY9hYIwHY7ZIoUwZjrcmktLYsL/0mzSAF3buwX24
         TkhQ==
X-Gm-Message-State: AOJu0YzxF3FOSF+n6NsrT0Rmg6HC6+Buu1h+xI4gttqjydAjKvJLlo2s
	xMlC6wmo8MwcRlUMbHGKxIX6Z20McQIHoMnvDY6nzuq0wSG19d8w
X-Google-Smtp-Source: AGHT+IHxXJtphUFumK68JJ/KFe5/a3Z8be7BZ1kExqD9G429KqMq7qKYYVegrKTpThyzfP5YddERjQ==
X-Received: by 2002:a7b:c8d2:0:b0:40e:62a3:368e with SMTP id f18-20020a7bc8d2000000b0040e62a3368emr132736wml.264.1705013656144;
        Thu, 11 Jan 2024 14:54:16 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id lb10-20020a170906adca00b00a2930696259sm1078297ejb.71.2024.01.11.14.54.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 14:54:15 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a28b1095064so647583466b.2
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:54:15 -0800 (PST)
X-Received: by 2002:a17:907:36ce:b0:a28:d31a:f8a with SMTP id
 bj14-20020a17090736ce00b00a28d31a0f8amr113422ejc.246.1705013655197; Thu, 11
 Jan 2024 14:54:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5ac3166f35bac3a618b126dabadaddc11c8512d.camel@HansenPartnership.com>
 <CAHk-=whKVgb27o3+jhSRzuZdpjWJiAvxeO8faMjHpb-asONE1g@mail.gmail.com> <3b5b650fa3c6ed6dc7f296eb7258c722a699147d.camel@HansenPartnership.com>
In-Reply-To: <3b5b650fa3c6ed6dc7f296eb7258c722a699147d.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jan 2024 14:53:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wik=6Rhvm5Kmgzc6VUJdp=17kQcxXFAGwxkFveU=dAvtQ@mail.gmail.com>
Message-ID: <CAHk-=wik=6Rhvm5Kmgzc6VUJdp=17kQcxXFAGwxkFveU=dAvtQ@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.7+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Jan 2024 at 14:47, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Well, I did already tell you that I bypass the pgp keyservers because I
> use a DNSSEC based DANE entry instead:
>
> https://lore.kernel.org/all/1564171685.9950.14.camel@HansenPartnership.com/

I think I dimly remember seeing that email.

But honestly, that just reinforces my point: this is yet ANOTHER
magical thing you have to know about gpg, and that nobody buy you use.

So if you insist on using these things that are obscure, you need to
keep reminding people. Every time your keys are close to expiry, send
out an email saying "To update my key, use this magical command line".

If gpg did that auto-locate automatically, and it all JustWorked(tm),
it would be one thing. But that is clearly against the design
principles of pgp and gpg.

              Linus
