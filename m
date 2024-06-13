Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B13D1311B6;
	Thu, 13 Jun 2024 17:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718300851; cv=none; b=dnpAJXIZvuKir4pE3BIHv5pmxq/MbwOujR7ufCCGcU3JUKbdQMpMBSDPWxx46wkTO36oe0jYud9NnAA00JoRTdfiHm5QTrCJ2k5FY3MApdulNoZ6Nj3sAoj59tmk32gFjgjTnYUFM5af/Lg9J2lcLzENg8HuykHIsqzDc0tcztc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718300851; c=relaxed/simple;
	bh=QhF3rdEorRJO2pP9xuC52x0LmUL4vTmT9mKvfH56YA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qNzgkvo+HK5dK710ZZiO1eVOnuCcAmGb5mNp/lIJNQ/7RFIabgbkRd4TG9+HQzz1Lh688dcF4tI94bisnmUEiCFf2dJdY4UmXV0JUURSMRsuEzPalZoPmQsIE0vPK2V9euUAHq0AtIQDfOuJCzU/F0E6jTLaT6wg8Il0e2pR2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDixL1B+; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDixL1B+"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso157967466b.0;
        Thu, 13 Jun 2024 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718300849; x=1718905649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhF3rdEorRJO2pP9xuC52x0LmUL4vTmT9mKvfH56YA4=;
        b=iDixL1B+98zGw/4CXMkv6RvfZ3y89WyCKyjByMLd67gBWdNiF8O/STWoZs6MZjQrpn
         WYtf7lXEsMY1dcGdbUNWREJ1lYwBZ4wQ9RYTBCG6qkG4UF+aXFVlDBHr4KiGEHn01jiU
         JWsrvk+4Ptbm9DEtgj9TlFVOteEqz40g0Wq2WRUYCo0LxTEBVBGDh9SIjK2s7MQeWknR
         amTsrBPR7Z5CVRYd3dBRhFjsgK1zhcLXPdBv3GsA5Iz98K8L+HlLzbt/J5mkxaiebnYe
         BRSRIKBmzwIVuv+uUSnNQ6yPDlCIHVOyKk/Ti5Qsvo7QxRLmWx++lC33mf6NdWVe5xZi
         tuxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718300849; x=1718905649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QhF3rdEorRJO2pP9xuC52x0LmUL4vTmT9mKvfH56YA4=;
        b=kxhpmMm7aYiMUzu4amkxY5ZDgeTdOAXT4OeyW99t6t5sMxlbz22Ev1mDvybSpeB0Q/
         CQCBxvCHvglpOb/FJkgiMQuX9QoqcaWiYwsGZE9FS362Stz0ailcbUbtHM7/87MQkUia
         sU1ixlAXcbmeQMLyk/QxzDnDSLcCcCiH08w11gCztluvY4QyeOoSrj/V18mEitfvdAeW
         vbiMohXsA1A8bYwc3aE/Ur6ud4U6MOGlcVw2HLJcgKnNcm6cqDKZbWoiaN4BZ3k7eP8P
         y63mPnk0a5Uy2Mtyr057uROB8tCcES/IU/CRk19M0a7Yd4RNO5C1TF17dWP65q40vaeP
         FUcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjs5gjNi2eoHJeid3Nbbq/+0foEI7G6e0KS2IGwHTATTI0TVJUWXXjbrvwJKt44syUpcJJvdjPsXQ6Vl06j4jTXUhJ3i/r9QSwXxKw9XsCCuFUpgSSMw1ngaZ4f1WMWer1k2Szl6nG9NDXyCtUeGaUejz3i79AOv0vzcOfhQ==
X-Gm-Message-State: AOJu0Yy47obeMRJlX/sOA80nzByEyrEsIpP+ch7GgzocfVRf3qwoCeTb
	9SdqRmAmQuyMuRk9N8k0oJsNT6uprl3l/2+mO5R6Ofi4v4nD+/ZykPwP2zbGCLzkSpwjrngCvBr
	13ucBhaHxYolA9wVVyMARAxDeZiU=
X-Google-Smtp-Source: AGHT+IFf2JUe+2b8ry0rYcMP2K8D/VxvfrVvNwfyDeXbeWwOq+wgVPzMsY0NMtAtvI6c7zTGW0+fODd4/lnQ03Mmr5M=
X-Received: by 2002:a17:907:72cb:b0:a6f:1f66:833d with SMTP id
 a640c23a62f3a-a6f60cef68amr42407166b.9.1718300848598; Thu, 13 Jun 2024
 10:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612203735.4108690-1-bvanassche@acm.org> <20240612203735.4108690-4-bvanassche@acm.org>
In-Reply-To: <20240612203735.4108690-4-bvanassche@acm.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 13 Jun 2024 19:46:52 +0200
Message-ID: <CAHp75VcFkNmg=7DZyaBJuNjF0sYkamhcCJ=Of07X+d-4vde94g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] scsi: core: Do not query IO hints for USB devices
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Joao Machado <jocrismachado@gmail.com>, Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oliver Neukum <oneukum@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 10:37=E2=80=AFPM Bart Van Assche <bvanassche@acm.or=
g> wrote:
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

I have commented on v1, same applicable here. Not that it's a big deal
for this change, but in general can you follow the advice given there?

--=20
With Best Regards,
Andy Shevchenko
