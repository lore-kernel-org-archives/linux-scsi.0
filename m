Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A591E1DA63D;
	Wed,  6 Nov 2024 09:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887185; cv=none; b=onWB42JejNY6D97hOuei2uzpnLfDsp+iur9rbFfW06cJSbaosusF5VOVUJSwmS3YTufNJiY+X7brrqPAcsAbA4lLUJam1IEEaoSCHViaVUSWDk5xBr3MozADSso4/CYsPksEHHrT3pT5mAyyJsPsf5+sT6HAgjCF6E646/zf5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887185; c=relaxed/simple;
	bh=7l6K2Oe+7Ocw7CjKpQQAhOKiVxUpVshv33jRpchU9+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R4U6TNsDGRhGalg1a9MMcW3E+JcQy9L7a14SDHxZ1EkAYJvzTCrBH2vItE9n/BQ2T4W4I03b8DPHxtTj7cswB+scirV3VNi2nUrCaOy1oLLdIfD1Th43z0K8pjjA8FD438Bcvd7glSeSSfkrZUNVOFi99wW6a1ufdhelXRYezU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6ea1407e978so60855247b3.1;
        Wed, 06 Nov 2024 01:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730887182; x=1731491982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rC39RasH+GE4mvzpE5BKxCeRZzvkxv3B98iDAPKyxhM=;
        b=BCVS8wd0vRzgCvN9y4rju3gKKcwDESzC7HzdgowTz1wHtbymuzDFeYBJHCLjIWvcvi
         YSfLSIK2eddsZukKbZ7ZCM5Px8kzYqZ/SXw4TiKG/Ptjh3HJz5k6l+qZkk5gds+tr5HO
         PzdsFpaTPydjoYmHtDCXvKXlpWSZMwzjcOzhom4Tv0crWeCtnpLrdUtETc6Aw5Q2Gzuq
         szqqw4gzd13gVUWDX4h4c5ieiLfGf6DzR6CoeBcM06JxYUIAesv4WtjJq6K1ApzB0Jfo
         f80nWOvH9ayiqVhTpy3yIi5AqTnFOf9DglfUUG9tvC4yCnOrfOM7npxg7ROmygoZCDcx
         QZ0g==
X-Forwarded-Encrypted: i=1; AJvYcCVgS58J8YjnTMdpC66ZDbtiyQYi2C+pZlWaxUSsu44StkmNSjIxDoIKYduPND2s/gk2zBz8vlRUhoUe9A==@vger.kernel.org, AJvYcCVwIZJJV7OoNHmRfntCVD5F3V0tFFyOPTE93uQqfMXwxQ4xQW7ZEt9XCZL0KFwofk6ndWyZK/HN9Joh@vger.kernel.org
X-Gm-Message-State: AOJu0YzmjTxtHhPMDmWFkegz/YAKS5vapsXnwk9vA7I3cYGBnc+IZyCk
	xoA8ud5S3r1V1p5fZP0vzAThxpLHiY065GaqrVnA/dKTgVadUFvzSj7LL8Jd
X-Google-Smtp-Source: AGHT+IGyJbXT1PJOhJsPdjlo6jsGfOHWMdFvqXWneXG6AUxmv5ynX/hDBViKftfjgDO+OF+sa+j0HA==
X-Received: by 2002:a05:690c:4809:b0:6de:2ae:8138 with SMTP id 00721157ae682-6ea64a8cc02mr194814297b3.5.1730887182153;
        Wed, 06 Nov 2024 01:59:42 -0800 (PST)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ea55b10748sm26874227b3.32.2024.11.06.01.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 01:59:41 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6e38fc62b9fso55585377b3.2;
        Wed, 06 Nov 2024 01:59:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUpd9vYDJNrnENQYRzJ/nn2gPriVW6BxN8iElsR1YhF3a77Y0GtLAq7FhXcnhEvpfO3MrkladKkgjsx0Q==@vger.kernel.org, AJvYcCWQUntKnziaLUUx77mTqwcV31EX2XotmLtrRr5TtiF1g0Ut/9stksaYE9VYCIzN5ql+tBclMzC8QzR5@vger.kernel.org
X-Received: by 2002:a05:690c:9b10:b0:6db:e280:a3ae with SMTP id
 00721157ae682-6ea64b10af2mr200323037b3.23.1730887181333; Wed, 06 Nov 2024
 01:59:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
 <h7x2iksfw7vguvqvjg5axl67mpejodbimwhxluew6cfobotb4t@fewz7knes7au>
In-Reply-To: <h7x2iksfw7vguvqvjg5axl67mpejodbimwhxluew6cfobotb4t@fewz7knes7au>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 6 Nov 2024 10:59:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVemwQkmb-+SWQ2Rsr-E=gMQ5jUNMDX-QmZS+s5CY1zcQ@mail.gmail.com>
Message-ID: <CAMuHMdVemwQkmb-+SWQ2Rsr-E=gMQ5jUNMDX-QmZS+s5CY1zcQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: sun3: Mark driver struct with __refdata to prevent
 section mismatch
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Finn Thain <fthain@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, 
	linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Wed, Nov 6, 2024 at 9:50=E2=80=AFAM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@baylibre.com> wrote:
> On Tue, Nov 05, 2024 at 07:36:31PM +0100, Geert Uytterhoeven wrote:
> > As described in the added code comment, a reference to .exit.text is ok
> > for drivers registered via module_platform_driver_probe().  Make this
> > explicit to prevent the following section mismatch warnings
> >
> >     WARNING: modpost: drivers/scsi/sun3_scsi: section mismatch in refer=
ence: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .=
exit.text)
> >     WARNING: modpost: drivers/scsi/sun3_scsi_vme: section mismatch in r=
eference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (sectio=
n: .exit.text)
> >
> > that trigger on a Sun 3 allmodconfig build.
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Reviewed-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@baylibre.com>

Thanks!

> Seems I missed that one before posting 7308bf8a2c3d ("modpost: Enable
> section warning from *driver to .exit.text"). My excuse is that this
> driver isn't enabled for an ARCH=3Dm68k allmodconfig build.

Understandable, as there are basically 5 classes of m68k kernels:
  - Classic with MMU,
  - Coldfire with MMU,
  - Sun-3,
  - Classic without MMU,
  - Coldire without MMU.

As the last two consist of multiple single-platform kernels, they're
harder to do allmodconfig for.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
