Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF10D14A0BC;
	Thu, 13 Jun 2024 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718300707; cv=none; b=S2T4c2ufJbllhZrt22LzXljfCn2p3Wgj6l1YtX4V5oBtxp+uVD/kTWWwyGrTdOzjmFZFXTY80nhLB40bIqj4O8PcOABs9b63M3tdAN9v1CzoU3HuxZeJA5xr6HZTsPmWY1xT+nP0PBlVLhnumxcApRX5bOe41FYDEz46vdbtHxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718300707; c=relaxed/simple;
	bh=W1NN4FEaI545WsKG5QYNWSaOEHoanK1aCsXeN3ZFySY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=plCSveJ4fHbkhYJIVgjmj+8zI3YmAMeK/VCs9mvHbkcOX1wSk5nK3o91odRUDd7GibQgWGdkjDw5T8TRBaD2yKjNum7JCJ3fYnkwpb8k2lIacCj5FWHMSB5keHby/gCXKsDK1yM6fWLUst70KZvubXfixU6BM5/n4x2WGL0FTOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O1NTnV0w; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1NTnV0w"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52bbdc237f0so1627812e87.0;
        Thu, 13 Jun 2024 10:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718300704; x=1718905504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1NN4FEaI545WsKG5QYNWSaOEHoanK1aCsXeN3ZFySY=;
        b=O1NTnV0wnt1Ii5Xcam0p7pU44VL+a1r0kGMXID6kpX1jQCWdpgEN8EcEidmcSD3oEI
         9fRS+v6P7MA8EnZNHCGiID3kjAJD9rJfp40KpLRMnp+WhMJm1YaHxqbeeeVMErqnwhZo
         C7gNrRwXd3Trb3NEpfOEXfAEWUf39ErJBn0XqkOHAJ/ggoaKLQ4Pqc2yxR/fCJ/FrI81
         dIf9WobPbIBxWqY/XEMkO94ZVHuDL9DMKarhlgp5DBcvN2tTA0PNywW3EFX5UIOnnREh
         /dGa8rCfUE9aq9x+K1Frs+LN1uNaGfZTsSMRNfwiUSdyfibMbQ8LXlW8ACsZTe3sQClF
         m9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718300704; x=1718905504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1NN4FEaI545WsKG5QYNWSaOEHoanK1aCsXeN3ZFySY=;
        b=IzI+JtTm1oWcdWPP1eJ4faNNljc0a+J52oFkupvYHTepCcnwBR+mBGCnf+b4b/CrpN
         OEovrK70hpF57UqPq6R9l5sFPdc+I7kEdkL+g4wMZ6LXOhNwToqx1DrR6lCWsWrgnsMm
         yj8nF8CLsgu1MrFtTnikuEL1qNsSwsVhI3xiAANy+8pZ9HwmHyoYIMbz4srTsRSPQdLu
         8oY1sqvIwpIh3rlC2koHqUDWc7B0JXmJFZdtSaxC/DvMcW5IIBrrFKLTmsyBpoM95PZu
         J//CwqChzk5hOBvukKE5Wr6objPv+btGk81qIq9pvs6AI7fv7MMNyzFZEsFPkLZJ5449
         xmNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFQKlHmKcekuWWn4vwJWLuMtgMJQyoIl2Ok3d72mHkV9Ofi4Sw/xz6mN7t0oGapLF/Vh2mAkK7Giu049BxdC667mnpWe2eHobm0e/GiAGiH5+wbmCSvsAzqpQziinRNfUGgHNyr11sIu2kerpChOpRX3Gf5jWIWRITQyl8xg==
X-Gm-Message-State: AOJu0YxtVRHV3zIDgihH1NvJK41P2enmMAd2zhCDxvQBGKde3Ow6vpIf
	ZB5gmjmaZen9/SfHnfNcg9vvUH6U7VSivWiGZ/8fo+iELhb7AgCfXfpjH55yWyU+xOXdwvdo2w2
	5YaJV1ksYK7cX3Ezih3VvAOC8ltL7oEDMJqqu3Q==
X-Google-Smtp-Source: AGHT+IHYWeogOBzyL542s+6sxUjpi4sk9wNSwKBTh/Q8bkZg0I7HCQz3LHhUiZcmfmY+AC6RY80vUHIB7pAF/F8QP7I=
X-Received: by 2002:a05:6512:5c9:b0:520:ed4e:2203 with SMTP id
 2adb3069b0e04-52ca6e562bfmr360632e87.8.1718300703669; Thu, 13 Jun 2024
 10:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612165249.2671204-1-bvanassche@acm.org> <20240612165249.2671204-3-bvanassche@acm.org>
In-Reply-To: <20240612165249.2671204-3-bvanassche@acm.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 13 Jun 2024 19:44:26 +0200
Message-ID: <CAHp75VdT8hp+aSN_ZyGebkUykaP=p9ipq4Guk6+e_HJ2apu18g@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Joao Machado <jocrismachado@gmail.com>, Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 6:53=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> Recently it was reported that the following USB storage devices are unusa=
ble
> with Linux kernel 6.9:
> * Kingston DataTraveler G2
> * Garmin FR35
>
> This is because attempting to read the IO hint VPD page causes these devi=
ces
> to reset. Hence do not read the IO hint VPD page from USB storage devices=
.

> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: linux-usb@vger.kernel.org
> Cc: Joao Machado <jocrismachado@gmail.com>

> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Christian Heusel <christian@heusel.eu>

Besides no need to repeat these Cc's in case there are other tags for
the same emails, can you move the rest of Cc's after the --- line
below? For you it will be the same effect, for many others the Git
history won't be polluted with this noise.


--=20
With Best Regards,
Andy Shevchenko
