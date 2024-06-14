Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B13218508A;
	Fri, 14 Jun 2024 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718353743; cv=none; b=B4nSPUQKej9AIGXGdqMRHxvsZBsaMo6/pHUUdZS9KDR8E9cp2engjivyfJb34vxEiMZwAB/T/aSzAa75bdVAgXEeiTRfhbj1YX6ms2gqTNAVmAwJgwsxFpEehQ2CE2xaEL9cPEenmS+5S2n+3ONkpb7BicAmiIPQRVhx9Jo0yls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718353743; c=relaxed/simple;
	bh=si66A7Bww7MdzXWYVuhn5dggZ9QjSpqjNge2lbjPC+U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ROrjHH3pYyTdJsBOxMicOGx0Ge2X5glXIQiQMtOlc4Kc3YL92tDYQ5+xaNKm6vB8RqbVWr396aj9tt2niY0RduNWya+4IZhw3/7Idzq3tGUU3XqXx9hHJGprHQ0lV9gYXx3B4M+qx7R8twG/OibQGZxaRD2LINbTs3X09F0a/Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VsY3Mmh+; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VsY3Mmh+"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-57c7681ccf3so2093852a12.2;
        Fri, 14 Jun 2024 01:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718353741; x=1718958541; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=si66A7Bww7MdzXWYVuhn5dggZ9QjSpqjNge2lbjPC+U=;
        b=VsY3Mmh++P4SOYSkAQFUaw6ikBB0SAoIsvji9vc7Px123avUQYY+EcrDDBnNsi0QW3
         7i/f+UpXDVrOnN/xnSATZj4l6ci/SzmMdAF6ee0QdyTB9Pf6fkzNAMV9WWvzn9PV9bKY
         9YP9I+pL4pWlKLVftp4ofshvjAkKIPCP5DXZHD8sMyh90uLD6OoxC6VGK7L3TsTjmCqu
         +GEziByf3zpf3tlw05j7FKK3oWby5dCPJ7z7YHgFtvKYfYlJndNgjMWui0a227OGdmg0
         MG4iIFzf1Sbkh4wQDIQj/QMOv+JWhO7Jvaj+MeJ8gWIE4XzH95EbFof1kGrzOAntWWTC
         a+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718353741; x=1718958541;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=si66A7Bww7MdzXWYVuhn5dggZ9QjSpqjNge2lbjPC+U=;
        b=g6VSZVWAx3P23o903fggjhj3BrXH20/ZYqt5o9TZN6DUt5azTiA4CWYC+/xC80pciL
         hR/FaqZcI2sQUnk47aAVZMZeAQkzzlPawneU0vir5XXIoJBXgr+as95z9ytmJnEF43pK
         u9F0a3bFVXjgV/SUTf/UftOLEBgrqDeHKvH0oPVzzutOAomGeXMg3hx225uIYRtJq3P/
         vc0o6Ah4aZgxVfBv5+OYaZHvaMkq5fIjrKa0HZAqT69M9cec5DZMZBkMKz6jwPBTpzD4
         r1jx+n2B8+6VhD93enCXasehiugiz52SXmhD5Wl2z4IJcdbz0zo6Ji52SXmsvvB9MJtf
         p4Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWvZ90w53jAOhsNu8HnWf97IYKf72bHZsDRGGTCcLMk5HOYww78SSDyXVmIYeB80pDBcf2aAIC1xmOKGWkBOFPIQdblD0RiBIGfIA==
X-Gm-Message-State: AOJu0YyYahE2R4Sm3s4l2HdDmz6BRCdbFJaY0cS0sKRuE3PV4nWXdTM2
	L1zegnZiFbQWN9vhNkrtQPviBv69jD0ossDvpO/qPuq7G7W2xqHb
X-Google-Smtp-Source: AGHT+IGVwb2EkB9dWSTgBPUqPXbLYxIKnMpLWYR8kRJGNxRo5NbCsRevoKdqLxGS9mSPcY/fALjcRA==
X-Received: by 2002:a50:d70d:0:b0:57c:7ce3:6cd9 with SMTP id 4fb4d7f45d1cf-57cbd67f5d3mr1197926a12.23.1718353740377;
        Fri, 14 Jun 2024 01:29:00 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb743b026sm1931399a12.97.2024.06.14.01.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 01:28:59 -0700 (PDT)
Message-ID: <81c85dd8bb770d4747a7f18a4607e02309ecb965.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
From: Bean Huo <huobean@gmail.com>
To: Joel Slebodnick <jslebodn@redhat.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com,  bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 peter.wang@mediatek.com,  manivannan.sadhasivam@linaro.org,
 ahalaney@redhat.com, beanhuo@micron.com
Date: Fri, 14 Jun 2024 10:28:58 +0200
In-Reply-To: <20240613182728.2521951-1-jslebodn@redhat.com>
References: <20240613182728.2521951-1-jslebodn@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-06-13 at 14:27 -0400, Joel Slebodnick wrote:
> Signed-off-by: Joel Slebodnick <jslebodn@redhat.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

