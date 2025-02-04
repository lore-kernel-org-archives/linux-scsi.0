Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF0E25A634;
	Tue,  4 Feb 2025 02:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738637564; cv=none; b=cCL/JGzWmaeQyzd/0jvq2/BkTe2Gu+Ph9uVTbTB1UyGm2T3DTL+Z/X1oqBusbWb44i11rf6Rwa/cpkZ53Vjji8/cb4z+Fc1eDeHOWBiTm3XHz/W4K+RkKQVUihEYrEtnpHHwdLZIBH191Uym6OuNBUwpjQiEYkKp4i8G2WOn24s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738637564; c=relaxed/simple;
	bh=guy3oknnvClt42Rhq1J2SKcdqRhcT7SE70hxYsir+/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sOdBqf8vT3w/P8I67EQ9TOyH1txLlbS82iCDPulyHqyNgqIEWTC3AtvL776xb1RmgijAuQxSjcA7BGxlwNcY8fXFlPQ2ecFd6XEsw/JpVczAaGX3bC9ooMeIR8dX+5o3p38DgcNrmtTo0hQWLX6oEjHW+cSLI/Bg0Ovq3YnUFzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UcDvm6V1; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UcDvm6V1"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-467a6781bc8so40894661cf.2;
        Mon, 03 Feb 2025 18:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738637561; x=1739242361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ja6Dsy6jn/o3Cll0WQK/DhgjJ2vQTCUsA9yzkkmoxLo=;
        b=UcDvm6V1OEH6+aZpVZTtpE22w4Pl76Dscy+lHn21EiOPEq+/KbMqHQOkpCMc9cOmzx
         4rgEzMr7ZgnML+CCwkrsN/5zObAYn13ToLl+NVCAdm8kQWJbV0bC5Yp2pyDLAxbMiPAm
         N0oYICbRRlVcnBUVr4Okm2pgDDyuwrjFtvIh7DZtOO5F/y29SBjggkyK4K5MCB3cxZqJ
         5ndzkR6LZ5QxLMMk5OkqCYS4qn+S280D5L02jeX49t0mqPHcl3zYCDlWez+rodmBbsQ2
         nnplL+yIN3G7fgCvm0v3gv4jPCgntm7vcH4da413DOqFr1HUpB79wb6i9SZB08QQOzVW
         9xFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738637561; x=1739242361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ja6Dsy6jn/o3Cll0WQK/DhgjJ2vQTCUsA9yzkkmoxLo=;
        b=u6MKJLnS7cpN5jmmzI6CEjD1NthXvlwZlZ2bFMyvuzb0rCi0BYzz/0kLcAy23p6lb4
         UQghk0xvgynHVUTeXrytpxKuA5IXtHDhNh7FH+hFpoBXhB742rHy6YwlNQSwEx8WL0m/
         ptuuX8SBpreaIdV3xUJsoIhOdAiX9FZgU99irIwq6r0qkyXpFkhYOqrNYBTIk82FU4na
         aziWALlkxfzFrHLcrIrlb0MZVsoN5AakrlCvemXkakBfTx8/DzS1bAI5g1/GRX8nJDVp
         rw8wv7+BI5X/+ft7OZTUu/B0IjEqN34/W/3ana3wIUe8d40m4R8U5VOVN1xwEj5qptgI
         kT5A==
X-Forwarded-Encrypted: i=1; AJvYcCXaDS0WrU8/JYGlwCMUt+MDyVjwEVTGNMxWoLfxd4lZKT8IG7iablnkHEkR6IZCGtAN9AKev4tKS0FxRd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU6sWrYnNNP+bo0NpvuDcjnLWT2ivipJAdx0UO+8D5gS/OOWqq
	nppje5C4SOloOfqM1racR/WY9b+HBFTpGiZqtInKccJwFisetDYc0gSOTCngHiUs9yTWF1EcHBO
	j+Pu9okCr/9yv6RPyFoV1FfMjYpw=
X-Gm-Gg: ASbGncuofcss8ek/EaS3hLH6mVFeOu814lbmmzMi3CR0/V1xy1UUHfnTzwJJHlZvg9T
	kGan+uVNkLbfl2zf2KelDHnqy8EoF12lzwDkI93040BIvYuuzMrmqDb7ptJJS+eWdt6vXy6jw
X-Google-Smtp-Source: AGHT+IFPJRlmGEEiebXSN8gPUBosDsBsBmCrM8kZVucQDYxGqXJHGcOqajrVKrXwTRmSfSOLvNyEMIAAJ/BLD0Z+U3o=
X-Received: by 2002:a05:622a:6117:b0:467:8734:994f with SMTP id
 d75a77b69052e-46fd0939525mr328567341cf.0.1738637561628; Mon, 03 Feb 2025
 18:52:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de> <20250202213239.49065-1-jiashengjiangcool@gmail.com>
 <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
In-Reply-To: <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Date: Mon, 3 Feb 2025 21:52:31 -0500
X-Gm-Features: AWEUYZlRzY7UPSLgXaFukXBGOFTGzKlRC5i7RbkrkEyW2ELp3mGDsInKIw6U5mU
Message-ID: <CANeGvZX5gcYj+Wjp+t=GLtOePHBjMNmVxiPsk2nruqsbiRaqVQ@mail.gmail.com>
Subject: Re: [PATCH v3?] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Javed Hasan <jhasan@marvell.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Saurav Kashyap <skashyap@marvell.com>, 
	LKML <linux-kernel@vger.kernel.org>, Arun Easi <arun.easi@cavium.com>, 
	Bart Van Assche <bvanassche@acm.org>, Manish Rangankar <manish.rangankar@cavium.com>, 
	Nilesh Javali <nilesh.javali@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Mon, Feb 3, 2025 at 2:20=E2=80=AFAM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> > Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
> > used/freed.=E2=80=A6
> > ---
> >  drivers/scsi/qedf/qedf_io.c | 4 +---
> =E2=80=A6
>
> Will you become more familiar with patch version descriptions?
> https://lore.kernel.org/all/?q=3D%22This+looks+like+a+new+version+of+a+pr=
eviously+submitted+patch%22
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/submitting-patches.rst?h=3Dv6.13#n310
>
> Regards,
> Markus

Thanks, I have submitted a v3 and added the changelog.

-Jiasheng
