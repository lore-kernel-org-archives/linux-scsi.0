Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD0622;
	Wed,  8 May 2024 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715185965; cv=none; b=OYMz2wbWklcYggNk0c7Jf0UeIyiNGP/nRxdD/3FEDUzW/hXvoqokxoCvoiE4MGE4ZO8398qXxjV7v93XBJKlH3wP3lZPRRGSJf/ylcsvU2E/27mYDvXBSGIazEQ6VUkaOrkI5TlnkkupPYvD35m+ayMx7vWpmP7jeSCyNQwRD80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715185965; c=relaxed/simple;
	bh=V+UlBtviKRplAFVuSD5WaZIQT/sci91Paoj0zH91ETc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m3pnfJ+WanRb+61blhpmbpkU3opxq2sxk8TBzm7fx9ncQrW65+DuJMKQNUUDL7vjMT66bExKykFWKNcmxhLpZRqjxb1IFyKYcP/wKmIsGX9IPV4dEqyoYRgo7UbKJiMW9iD2a9qydtM0DeTmoPKT9rtjotJUkMz4EH21JjScFh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WoofWAtM; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WoofWAtM"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-51f3761c96aso5971606e87.3;
        Wed, 08 May 2024 09:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715185962; x=1715790762; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V+UlBtviKRplAFVuSD5WaZIQT/sci91Paoj0zH91ETc=;
        b=WoofWAtMGWbhf2JCmj00SvUHO8iwHiyqqwWhYYveelKGrJMwCkj8cYmG+Xt6Ttl6Zc
         0s+uKmM9g59U6UmRqs12p9VjsBB3Rhy2ZqNcm0+v4i4Ztr8XVjP/Xm3irScdRDuLA2L4
         gZXFe5pg4m5/hhP37ASjTgnTkTIzJAlxgIsAgV3Mt5HJOtgltw0GhUD4y733eoX1WVBc
         dD0bGnxDQ4JEkhmK+s++4/dyfQRfLq/xMaZMciEx+Z85XBzFMsdV5Rqk/AQfJe9mBZs+
         KCrUFS3nGXsZJnLGqqliNP91QIeBvZW19yLGytO/nf/6VfVmMDisNl8Rfp5Vi5CV7FAY
         vf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715185962; x=1715790762;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V+UlBtviKRplAFVuSD5WaZIQT/sci91Paoj0zH91ETc=;
        b=R2OEH8BQXsuW5Co41WEw6i0Yhd4pGCC2qT/HzAjVm6vRWFFBjB4m612CCQ+1t5Hz8N
         QnWD9aJmwGYLJagXA0mj0AkqmLIAykhm2jmfQmNORIOB7o+fxjtU04/VCF52qTR2b54q
         j6Ry2LnmkTNFmvF6wgjstjtp5J7BtgHwcpLY2ey3IgSWgJJLtiArrQNVlVcCrYsitExU
         FZDHi0/lGPJtdka5Q5YmM/hpu2JUUMInNH/C5bB/w4uXpe/o9ylHR/bVLotlFb2BxRHs
         GK5Z84HjIUnNUGQLUWvIquIawdNiwUGVewPulEIi4iXfDTT50DVndQZCFry0obEi8mP2
         FeWw==
X-Forwarded-Encrypted: i=1; AJvYcCXXDEKN6u2znMLYezKVSCpJDLVH0F8tG8Z5kpOG8jzNQMYgVfWbC79GsgAY39YdNY/XrduaKwT0nokHpcb+F44/97a1EsMuu1xX0UWex0+rLtL+ACZXYK8UcAYLtl/JxPABcwDTnN+ZGw==
X-Gm-Message-State: AOJu0YxF6QHQfhqnWnSQ6pUgx5+vXNMwVUnjqzAcrc8ex/Mzac/l01WZ
	lnjvsu6NejtOdcs8TZOwsjOcrHyaBbvBe3cozFr1eUX7w4kBevQe
X-Google-Smtp-Source: AGHT+IHAs8Tu5r/cNrM8qwZu2fstp9iHU9GwAkEowndpD34nsUQ0NN6g30dKDQKYz9ZqtvE7WFA0Tw==
X-Received: by 2002:ac2:5929:0:b0:51d:a1ab:98bc with SMTP id 2adb3069b0e04-5217c3733cfmr2768097e87.2.1715185962225;
        Wed, 08 May 2024 09:32:42 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id kk1-20020a170907766100b00a599c00442fsm6421117ejc.150.2024.05.08.09.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 09:32:41 -0700 (PDT)
Message-ID: <e00686432d2aa09880f801eecadbb2bdf6d23573.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: Allow RTT negotiation
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 08 May 2024 18:32:40 +0200
In-Reply-To: <20240503113429.7220-1-avri.altman@wdc.com>
References: <20240503113429.7220-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-05-03 at 14:34 +0300, Avri Altman wrote:
> UFS4.0, and specifically gear 5 changes this, and requires the device
> to
> be more attentive.=C2=A0 This doesn't come free - the device has to
> allocate
> more resources to that end, but the sequential write performance
> improvement is significant. Early measurements shows 25% gain when
> moving from rtt 2 to 9. Therefore, set bMaxNumOfRTT to be
> min(bDeviceRTTCap, NORTT) as UFSHCI expects.
>=20
> Signed-off-by: Avri Altman <avri.altman@wdc.com>


Avri,

I was still curious about this 25% gain, so I will take a look. It
would be great if you could share more information about this.



Reviewed-by: Bean Huo <beanhuo@micron.com>


